1 pragma solidity ^0.4.19;
2 
3 contract PrivateBank
4 {
5     mapping (address => uint) balances;
6     
7     function GetBal() 
8     public
9     returns(uint) 
10     {
11         return balances[msg.sender];
12     }
13     
14     uint public MinDeposit = 1 ether;
15     
16     Log TransferLog;
17     
18     function PrivateBank(address _lib)
19     {
20         TransferLog = Log(_lib);
21     }
22     
23     function Deposit()
24     public
25     payable
26     {
27         if(msg.value >= MinDeposit)
28         {
29             balances[msg.sender]+=msg.value;
30             TransferLog.AddMessage(msg.sender,msg.value,"Deposit");
31         }
32     }
33     
34     function CashOut(uint _am)
35     {
36         if(_am<=balances[msg.sender])
37         {
38             
39             if(msg.sender.call.value(_am)())
40             {
41                 balances[msg.sender]-=_am;
42                 TransferLog.AddMessage(msg.sender,_am,"CashOut");
43             }
44         }
45     }
46     
47     function() public payable{}    
48     
49 }
50 
51 contract Log 
52 {
53    
54     struct Message
55     {
56         address Sender;
57         string  Data;
58         uint Val;
59         uint  Time;
60     }
61     
62     Message[] public History;
63     
64     Message LastMsg;
65     
66     function AddMessage(address _adr,uint _val,string _data)
67     public
68     {
69         LastMsg.Sender = _adr;
70         LastMsg.Time = now;
71         LastMsg.Val = _val;
72         LastMsg.Data = _data;
73         History.push(LastMsg);
74     }
75 }