require File.join(File.dirname(__FILE__), 'spec_helper.rb')

class MysqlToolsManifest < Moonshine::Manifest
  include Moonshine::Plugins::MysqlTools
end

describe "A manifest with the MysqlTools plugin" do

  before do
    @manifest = MysqlToolsManifest.new
  end

  it "should be executable" do
    @manifest.should be_executable
  end

  it "should provide common mysql tools" do
    @manifest.mysql_tools
    @manifest.execs['wget mysqltuner.pl'].should_not be_nil
    @manifest.packages['mytop'].should_not be_nil
    @manifest.packages['xtrabackup'].should_not be_nil
    @manifest.packages['maatkit'].should_not be_nil
  end

  it "can disable xtrabackup" do
    @manifest.mysql_tools :xtrabackup => false
    @manifest.packages['xtrabackup'].should be_nil
  end

  it "can disable maatkit" do
    @manifest.mysql_tools :maatkit => false
    @manifest.packages['maatkit'].should be_nil
  end

  it "should require mysql-server package before xtrabackup and maatkit" do
    @manifest.mysql_tools
    tools = [@manifest.packages['xtrabackup'], @manifest.packages['maatkit']]
    tools.each do |tool|
      tool[:require].should include(@manifest.package('mysql-server'))
    end
  end
end