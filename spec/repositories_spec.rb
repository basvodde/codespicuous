
describe "The repositories that we are examining" do

  repositories_in_csv = "name,url
kewl,https://github/kewl
also-ok,https://github/also-ok
"
  subject { Repositories.new }

  before (:each) do
    parser = RepositoriesParserFromCsv.new.parse(repositories_in_csv)
    @repositories = parser.repositories
  end

  it "reads the repositories from a CSV" do
    expect(@repositories.amount).to eq 2
  end
end

