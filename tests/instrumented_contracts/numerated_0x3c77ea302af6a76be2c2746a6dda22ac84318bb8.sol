1 pragma solidity ^0.4.13;
2 
3 contract GameAbstraction {
4    function sendBet(address sender, uint choice) payable public;
5 }
6 
7 contract TeamChoice {
8 
9     address gameAddress;
10     uint teamChoice;
11 
12     function TeamChoice(address _gameAddress, uint _teamChoice) public {
13         gameAddress = _gameAddress;
14         teamChoice = _teamChoice;
15     }
16 
17     function fund() payable public {}
18 
19     function() payable public {
20         GameAbstraction game = GameAbstraction(gameAddress);
21         game.sendBet.value(msg.value)(msg.sender, teamChoice);
22     }
23 
24 }
25 
26 contract TeamHeadsChoice is TeamChoice {
27 
28     function TeamHeadsChoice(address _gameAddress) TeamChoice(_gameAddress, 1) public {}
29 
30 }