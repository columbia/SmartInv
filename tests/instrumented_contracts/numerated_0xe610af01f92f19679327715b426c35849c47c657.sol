1 pragma solidity ^0.4.19;
2 
3 contract PIGGY_BANK
4 {
5     mapping (address => uint) public Accounts;
6     
7     uint public MinSum = 1 ether;
8     
9     Log LogFile;
10     
11     uint putBlock;
12     
13     function PIGGY_BANK(address _log)
14     public 
15     {
16         LogFile = Log(_log);
17     }
18     
19     function Put(address to)
20     public
21     payable
22     {
23         Accounts[to]+=msg.value;
24         LogFile.AddMessage(msg.sender,msg.value,"Put");
25         putBlock = block.number;
26     }
27     
28     function Collect(uint _am)
29     public
30     payable
31     {
32         if(Accounts[msg.sender]>=MinSum && _am<=Accounts[msg.sender] && block.number>putBlock)
33         {
34             if(msg.sender.call.value(_am)())
35             {
36                 Accounts[msg.sender]-=_am;
37                 LogFile.AddMessage(msg.sender,_am,"Collect");
38             }
39         }
40     }
41     
42     function() 
43     public 
44     payable
45     {
46         Put(msg.sender);
47     }    
48     
49 }
50 
51 contract Log 
52 {
53     struct Message
54     {
55         address Sender;
56         string  Data;
57         uint Val;
58         uint  Time;
59     }
60     
61     Message[] public History;
62     
63     Message LastMsg;
64     
65     function AddMessage(address _adr,uint _val,string _data)
66     public
67     {
68         LastMsg.Sender = _adr;
69         LastMsg.Time = now;
70         LastMsg.Val = _val;
71         LastMsg.Data = _data;
72         History.push(LastMsg);
73     }
74 }