# Match settings
Match settings are stuff like "5 minute match" or "Best of 3". The rules that you set before starting a match.  
For most of these, the game makes a distinction between:
* The value that is selected in the menu. Doesn't directly affect the gameplay
* The value that is actually active, used in the match. You probably want to edit this one


## Domination mode - Time and goals
| **address**         | **data type** | **description**                                                                                                                          | 
|---------------------|---------------|------------------------------------------------------------------------------------------------------------------------------------------|
| 80C5F2E7            | BOOL          | Win condition. 0=Timed; 1=First to X goals (menu value, offline)                                                                         |
| 80C5F22B            | BOOL          | Win condition. 0=Timed; 1=First to X goals (active value, offline)                                                                       |
| 80C5F2E8            | INT32         | Initial timer (menu value, offline)                                                                                                      |
| 80C5F22C            | INT32         | Initial timer (active value, offline)                                                                                                    |
| 80C5F2EC            | INT32         | Goals to score (menu value, offline)                                                                                                     |
| 80C5F230            | INT32         | Goals to score (active value, offline)                                                                                                   |
| 80C5F2F3            | BYTE          | Best of X (menu value, offline)                                                                                                          |


## Domination mode - Cheats
| **address**         | **data type** | **description**                                                                                                                          | 
|---------------------|---------------|------------------------------------------------------------------------------------------------------------------------------------------|
| 80C5F2FF            | BYTE          | Item cheat (offline)                                                                                                                     |
| 80C5F303            | BYTE          | Environment cheat (offline)                                                                                                              |
| 80C5F307            | BYTE          | Player cheat (offline)                                                                                                                   |
| 80C5F297            | BYTE          | Item cheat (online)                                                                                                                      |
| 80C5F29B            | BYTE          | Environment cheat (online)                                                                                                               |
| 80C5F29F            | BYTE          | Player cheat (online)                                                                                                                    |


## Strikers challenges match settings
This might actually be dynamically allocated. Check for yourself.  
| **address**         | **data type** | **description**                                                                                                                          | 
|---------------------|---------------|------------------------------------------------------------------------------------------------------------------------------------------|
| 80C7F3C7            | BYTE          | Win condition                                                                                                                            |
| 80C7F3CF            | BYTE          | Win condition parameter                                                                                                                  |

Win condition:
| **value**           | **meaning**                                                |
|---------------------|------------------------------------------------------------|
| 0                   | no win condition                                           |
| 1                   | score X goals over your opponent (see peach challenge)     |
| 2                   | don't get scored on (daisy challenge)                      |
| 3                   | score at least X (diddy kong challenge)                    |
X is the value of winparameter.