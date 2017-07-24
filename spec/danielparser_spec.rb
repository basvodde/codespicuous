

describe "Daniel format parser" do

  it "Should be able to parse daniel format correctly" do
    daniel_format = COMMIT_HISTORY_WINE_CHEESE_DANIEL_FORMAT
    commit_history = COMMIT_HISTORY_WINE_CHEESE

    expect(DanielFormatParser.new.parse(daniel_format)).to eq commit_history
  end

end
