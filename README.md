# iLadder

iLadder Community Levels

This repository hosts level sets created by the community.  These levels are accessible to the iLadder application.  To contribute your own levels follow the following simple steps.

1. Create a branch of the https://github.com/travislondon/iLadder/ repository
  - On the repository site click the button titled: Branch: master
  - Enter a name for the branch <branch_name>
  - Select Create branch: <branch_name>
  - Proceed to step 2
2. Create your file structure.  For example: Levels/ReallyAwesomeLevels/Level One... Level Two.  Note that all level sets must start under the root Levels folder.
3. Create your level file as a simple text file using the lvl file extension.
4. See [Object Legend](https://github.com/travislondon/iLadder/blob/master/Game/ObjectLegend.md) for adding gaming content, adding items from this legend.
5. See https://github.com/travislondon/iLadder/blob/master/Levels/Community/Sample-iphone6.lvl (or others) for hints on available real estate for levels
6. Create a level description file (see the [Classic level configuration](https://github.com/travislondon/iLadder/blob/master/Levels/Classic/Classic.cfg) for details), currently this specifies the order of levels in the game.
7. Add a Level Set: <path to level> entry in the [root configuration](https://github.com/travislondon/iLadder/blob/master/LevelConfiguration.cfg) file.
8. Create a pull request for addition to the game
  - Under the repository select the Pull Request tab
  - Click the New pull request button
  - For the base use master, for the compare use <branch_name>
  - Click the Create pull request button
9. As long as there is nothing obscene (including ascii pictures) the levels will be promoted.
10. Begin enjoying playing your new levels :), and sharing them with the community.  (Note there is a small delay for online content to become available once promoted)

As the application progresses expect more support for level descriptions, including things like marking the "Agent" with a different character.
