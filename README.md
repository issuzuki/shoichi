# shoichi

    
    $ bundle exec ruby shoichi.rb --itemCodes <itemCode>,<itemCode>,<itemCode>,...

      @option:
        --itemCodes: 商品コードカンマ区切り
        --nocsv    : csv出力なし
        --noimg    : img出力なし

      @example
        $ bundle exec ruby shoichi.rb --itemCodes a-afashion:10002235


    <itemCode>
      #=> 楽天商品詳細 メタタグに埋め込まれています
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

