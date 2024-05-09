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
28     public
29     payable
30     {
31         if(_am<=balances[msg.sender])
32         {
33             
34             if(msg.sender.call.value(_am)())
35             {
36                 balances[msg.sender]-=_am;
37                 TransferLog.AddMessage(msg.sender,_am,"CashOut");
38             }
39         }
40     }
41     
42     function() public payable{}    
43     
44 }
45 
46 contract Log 
47 {
48    
49     struct Message
50     {
51         address Sender;
52         string  Data;
53         uint Val;
54         uint  Time;
55     }
56     
57     Message[] public History;
58     
59     Message LastMsg;
60     
61     function AddMessage(address _adr,uint _val,string _data)
62     public
63     {
64         LastMsg.Sender = _adr;
65         LastMsg.Time = now;
66         LastMsg.Val = _val;
67         LastMsg.Data = _data;
68         History.push(LastMsg);
69     }
70 }