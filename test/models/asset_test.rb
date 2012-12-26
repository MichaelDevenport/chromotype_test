require "minitest_helper"

describe Asset do
  before :each do
    Asset.delete_all
    AssetUrl.delete_all

    @asset = Asset.new
    @path = "Gemfile".to_pathname.realpath
    @asset.add_pathname @path
    @asset.save!
    @url = @path.to_url.to_s
  end

  def assert_path
    @asset.url.must_equal(@path.to_url)
    @asset.asset_uris.collect{|ea|ea.url}.must_equal [@url]
    au = @asset.asset_uris.first
    au.to_url.must_equal(@path.to_url)
    au.url.must_equal(@path.to_url.to_s)
  end

  it "should work on insert" do
    assert_path
  end

  it "should find with_filename(pathname)" do
    Asset.with_any_filename([@path]).to_a.must_equal([@asset])
  end

  it "should find with_uri(pathname)" do
    Asset.with_uri(@path.to_url).to_a.must_equal([@asset])
  end

  it "should find with_filename(to_s)" do
    Asset.with_any_filename([@path.to_s]).to_a.must_equal([@asset])
  end

  it "should be a no-op on Asset.uri= with existing uri" do
    @asset.add_pathname Pathname.new("Gemfile")
    @asset.save!
    assert_path
    @asset.add_uri @path
    @asset.save!
    assert_path
  end

  it "should add another #uri=" do
    u = "https://s3.amazonaws.com/test/test/Gemfile"
    @asset.add_uri u
    @asset.save!
    @asset.reload.asset_uris.collect{|ea|ea.url}.must_equal [u, @url]
    au = @asset.asset_uris.first
    au.url.must_equal(u)
    @asset.asset_uris.second.url.must_equal(@url)
  end

  it "should fail to give the same URI to another asset" do
    a = Asset.create!
    lambda { a.add_pathname Pathname.new("Gemfile") }.must_raise(ArgumentError)
  end
end

