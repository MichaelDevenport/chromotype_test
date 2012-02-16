class CreateAssetUris < ActiveRecord::Migration
  def change
    create_table :asset_uris do |t|
      t.references :asset, :required => true
      t.string :sha, :limit => 64, :required => true
      t.string :uri, :limit => 2000, :required => true
      t.datetime :created_at
    end
    # MySQL can only have 760 chars in an index, so let's index the uri by sha.
    add_index :asset_uris, [:sha], :name => 'uri_sha_udx', :unique => true
  end
end
