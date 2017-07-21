
COMMIT_HISTORY_WINE_CHEESE_DANIEL_FORMAT = "
repository: osaka
*** basvodde
team:                  Wine
commits in week:
  2016-04-18: 2 commits
  2016-05-02: 2 commits

*** daniel
team:                  Cheese
commits in week:
  2016-03-28: 1 commits

*** basvodde
team:                  Wine
commits in week:
  2016-03-14: 4 commits
  2016-04-04: 1 commits

repository: cpputest

*** janne
team: Wine
commits in week:
  2016-02-29: 1 commits
  2016-04-04: 3 commits
  2016-05-16: 3 commits"

COMMIT_HISTORY_WINE_CHEESE = CommitHistoryBuilder.new.
   in_repository("osaka").
     commits_of("basvodde").of_team("Wine").
       at("2016-04-18").times(2).
       at("2016-05-02").times(2).
     commits_of("daniel").of_team("Cheese").
       at("2016-03-28").
     commits_of("basvodde").of_team("Wine").
       at("2016-03-14").times(4).
       at("2016-04-04").
   in_repository("cpputest").
     commits_of("janne").of_team("Wine").
       at("2016-02-29").
       at("2016-04-04").times(3).
       at("2016-05-16").times(3).
   build

