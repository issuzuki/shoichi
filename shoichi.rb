#!/Users/hope/.rvm/rubies/ruby-2.0.0-rc2/bin/ruby

# ## explain
#
# $ bundle exec ruby shoichi.rb --itemCodes <itemCode>,<itemCode>,<itemCode>,...
#     @option:
#       --itemCodes: 商品コードカンマ区切り
#       -no-csv    : csv出力なし
#       -no-img    : img出力なし
#
# example
#
#   $ bundle exec ruby shoichi.rb --itemCodes a-afashion:10002235
#
#
# itemCode #=> 楽天商品詳細 メタタグに埋め込まれています
#  <meta property="apprakuten:item_code" content="a-afashion:10002235">
#

# ## directory
#
#   ./shoichi.rb
#   ./data/
#     |- shoichi.csv   # 商品データ
#     |- <product_id>/ # 画像データ
#     |- <product_id>/ # 画像データ
#     |- <product_id>/ # 画像データ
#


# ## require
require 'optparse'
require 'csv'
require 'rakuten'
require 'nokogiri'
require 'open-uri'
require 'mechanize'


# ## environment
RAKUTEN_APIKEY = "b0bd341050065bcba3cab5e07e275fb2"

# ## option
options = {}
OptionParser.new do |opts|
  opts.on('-h','--help'){|boo| options[:help] = boo }
  opts.on('--noimg'){|boo| options[:noimg] = boo }
  opts.on('--nocsv'){|boo| options[:nocsv] = boo }
  opts.on("--itemCodes ITEMCODES") do |item_codes|
    options[:itemCodes] = item_codes.split(",")
  end
end.parse!

# ## help
if options[:help]
  puts "USAGE: bundle exec ruby shoichi.rb [--nocsv] [--noimg] --itemCodes <itemCode>,<itemCode>,<itemCode>,..."
  exit(0)
end

# ## 取得する商品データ
# option
# item_codes
item_codes = options[:itemCodes] || []


# ## get
# API データの取得
items = []
def client
  @client ||= Rakuten::Client.new(RAKUTEN_APIKEY)
end
item_codes.each do |item_code|
  json = client.request(nil,nil,{itemCode:item_code,genreInformationFlag:1})
  items << json["Items"][0]["Item"]
end

# ## insert
# 商品データ
if !options[:nocsv]
  CSV.open(File.expand_path('../data/shoichi.csv',__FILE__),"wb") do |csv|
    # ## header
    csv << [
      "商品コード",
      "商品名",
      "キャッチコピー",
      "個別在庫数",
      "合計在庫数",
      "商品価格",
      "商品説明文",
      "商品URL",
      "販売可能フラグ",
      "レビュー件数",
      "レビュー平均"
    ]


    # ## body
    items.each do |item|

      # 在庫数データ
      nums = []
      if !options[:nonum]
        agent = Mechanize.new
        page = agent.get(item["itemUrl"])
        form = page.forms.detect{|f| f.action=="https://basket.step.rakuten.co.jp/rms/mall/bs/cartadd/set" }

        form['units'] = 9999
        form.radiobuttons.each do |radio|
          form['inventory_id'] = radio.value

          next_page = form.submit
          nums << next_page.root.css("font").text.scan(/在庫数は残り([\d ]*)個/).flatten.first.gsub(" ","").to_i
        end
      end

      csv << [
        item["itemCode"],
        item["itemName"],
        item["catchcopy"],
        nums.join(","),
        nums.inject(:+),
        item["itemPrice"],
        item["itemCaption"],
        item["itemUrl"],
        item["availability"],
        item["reviewCount"],
        item["reviewAverage"]
      ]
    end
  end
end

# 商品画像データ
if !options[:noimg]
  items.each do |item|
    # ディレクトリがなければ作成
    # ./data/<itemCode>
    unless Dir.exist?(File.expand_path("../data/#{item['itemCode']}",__FILE__))
      FileUtils.mkdir_p(File.expand_path("../data/#{item['itemCode']}",__FILE__))
    end

    # 画像取得 from API
    item["mediumImageUrls"].each do |image|
      system("cd ./data/#{item['itemCode']} && wget #{image['imageUrl']}")
    end

    # 画像取得 from HTML
    doc = Nokogiri::HTML(open(item["itemUrl"]))
    doc.css("#pagebody img").each do |img|
      src = img.attributes["src"]
      system("cd ./data/#{item['itemCode']} && wget #{src}")
    end

  end
end

