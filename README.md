# shoichi

    $ bundle exec ruby shoichi.rb

        @option:
          -no-csv: csv出力なし
          -no-img: img出力なし


    itemCode #=> 楽天商品詳細 メタタグに埋め込まれています
      <meta property="apprakuten:item_code" content="a-afashion:10002235">


# install

    $ bundle install


# directory

    ./shoichi.rb
    ./data/
      |- shoichi.csv   # 商品データ
      |- <product_id>/ # 画像データ
      |- <product_id>/ # 画像データ
      |- <product_id>/ # 画像データ

