# shoichi

    
    $ bundle exec ruby shoichi.rb --itemCodes <itemCode>,<itemCode>,<itemCode>,...

      @option:
        --itemCodes: 商品コードカンマ区切り
        --nocsv    : csv出力なし
        --nonum    : 在庫数データなし
        --noimg    : img出力なし

      @example
        $ bundle exec ruby shoichi.rb --itemCodes a-afashion:10002235,a-afashion:10002898


    <itemCode>
      #=> 楽天商品詳細 メタタグに埋め込まれています
      <meta property="apprakuten:item_code" content="a-afashion:10002235">
    

# install

    $ git clone git@github.com:88labs/shoichi.git
    $ cd shoichi
    $ bundle install


# directory

    ./shoichi.rb
    ./data/
      |- shoichi.csv # 商品データ

      |- <itemCode>/ # 画像データ
      |- <itemCode>/ # 画像データ
      |- <itemCode>/ # 画像データ

