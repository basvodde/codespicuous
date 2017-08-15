require 'fileutils'
require 'tmpdir'

describe "Integration tests using offline logs from the filezilla project" do

  before (:each) do
    @codespicuous_script = "#{File.dirname(__FILE__)}/../bin/codespicuous"
    @filezilla_path = "#{File.dirname(__FILE__)}/../bin/filezilla"
    @tempdir = Dir.mktmpdir

    ARGV.clear
  end

  after (:each) do
    FileUtils.remove_entry_secure @tempdir
  end

  it "Gives the standard error when not finding repositories" do

    expect($stdout).to receive(:puts).with("Stage 1: Configuring")
    expect($stdout).to receive(:puts).with("** Error: No repositories configured in \"codespicuous.yaml\"")

    load @codespicuous_script
  end

  it "Is able to list the repositories" do
    ARGV.clear
    ARGV[0] = "-i"
    ARGV[1] = "#{@filezilla_path}"
    ARGV[2] = "-r"

    expect($stdout).to receive(:puts).with("Stage 1: Configuring")
    expect($stdout).to receive(:puts).with("** Configuring options with \"/Users/basvodde/git/codespicuous/spec/../bin/filezilla/codespicuous.yaml\"")
    expect($stdout).to receive(:puts).with("Stage 2: Collecting input data")
    expect($stdout).to receive(:puts).with("Getting svn log from repository: filezilla")
    expect($stdout).to receive(:puts).with("Getting svn log from repository: xiph")
    expect($stdout).to receive(:puts).with("Stage 3: Listing repositories committed to")

    load @codespicuous_script
  end
end
