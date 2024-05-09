1 pragma solidity 0.5.7;
2 
3 /**
4  * @title Game
5  * @dev A game of wits.
6  */
7 contract Game {
8 
9     address public governance;
10 
11     constructor(address _governance) public payable {
12         governance = _governance;
13     }
14 
15     function claim(address payable who) public {
16         require(msg.sender == governance, "Game::claim: The winner must be approved by governance");
17 
18         selfdestruct(who);
19     }
20 
21 }