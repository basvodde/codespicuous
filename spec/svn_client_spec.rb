
describe "Interface towards the command line svn" do

  it "Should be able to retrieve an xml log for entire repository" do
    svn = SVNClient.new
    xmllog = double(:xmllog)

    expect(AttemptTo).to receive(:attempt_to).with('svn log: "Heh"', 5).and_yield
    expect(CommandRunner).to receive(:run).with("svn log Heh --xml --non-interactive ").and_return(xmllog)

    svn.repository("Heh")
    expect(svn.log_xml).to eq(xmllog)
  end

  it "Should be able to retrieve an xml log for timeframe" do
    svn = SVNClient.new
    xmllog = double(:xmllog)

    now = DateTime.new(1978)

    expect(AttemptTo).to receive(:attempt_to).with('svn log: "Heh"', 5).and_yield
    expect(CommandRunner).to receive(:run).with("svn log Heh -r{1977-01-01}:{1978-01-01} --xml --non-interactive ").and_return(xmllog)

    svn.repository("Heh")
    expect(svn.log_xml_for_timeframe(now.prev_year, now)).to eq(xmllog)
  end
end
