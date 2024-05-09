1 pragma solidity ^0.4.19;
2 
3 contract Private_Bank
4 {
5     mapping (address => uint) public balances;
6     
7     uint public MinDeposit = 1 ether;
8     
9     Log TransferLog;
10     
11     function Private_Bank(address _log)
12     {
13         TransferLog = Log(_log);
14     }
15     
16     function Deposit()
17     public
18     payable
19     {
20         if(msg.value > MinDeposit)
21         {
22             balances[msg.sender]+=msg.value;
23             TransferLog.AddMessage(msg.sender,msg.value,"Deposit");
24         }
25     }
26     
27     function CashOut(uint _am)
28     {
29         if(_am<=balances[msg.sender])
30         {
31             
32             if(msg.sender.call.value(_am)())
33             {
34                 balances[msg.sender]-=_am;
35                 TransferLog.AddMessage(msg.sender,_am,"CashOut");
36             }
37         }
38     }
39     
40     function() public payable{}    
41     
42 }
43 
44 contract Log 
45 {
46    
47     struct Message
48     {
49         address Sender;
50         string  Data;
51         uint Val;
52         uint  Time;
53     }
54     
55     Message[] public History;
56     
57     Message LastMsg;
58     
59     function AddMessage(address _adr,uint _val,string _data)
60     public
61     {
62         LastMsg.Sender = _adr;
63         LastMsg.Time = now;
64         LastMsg.Val = _val;
65         LastMsg.Data = _data;
66         History.push(LastMsg);
67     }
68 }