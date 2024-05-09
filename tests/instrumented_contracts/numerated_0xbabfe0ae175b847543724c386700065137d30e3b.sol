1 pragma solidity ^0.4.18;
2 
3 contract PrivateBank
4 {
5     mapping (address => uint) balances;
6     
7     function GetBal() 
8     public
9     constant
10     returns(uint) 
11     {
12         return balances[msg.sender];
13     }
14     
15     uint public MinDeposit = 1 ether;
16     
17     Log TransferLog;
18     
19     function PrivateBank(address _lib)
20     {
21         TransferLog = Log(_lib);
22     }
23     
24     function Deposit()
25     public
26     payable
27     {
28         if(msg.value >= MinDeposit)
29         {
30             balances[msg.sender]+=msg.value;
31             TransferLog.AddMessage(msg.sender,msg.value,"Deposit");
32         }
33     }
34     
35     function CashOut(uint _am)
36     {
37         if(_am<=balances[msg.sender])
38         {
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
49     function bal()
50     public
51     constant
52     returns(uint)
53     {
54          return this.balance;
55     }
56 }
57 
58 contract Log 
59 {
60    
61     struct Message
62     {
63         address Sender;
64         string  Data;
65         uint Val;
66         uint  Time;
67     }
68     
69     Message[] public History;
70     
71     Message public LastMsg;
72     
73     function AddMessage(address _adr,uint _val,string _data)
74     public
75     {
76         LastMsg.Sender = _adr;
77         LastMsg.Time = now;
78         LastMsg.Val = _val;
79         LastMsg.Data = _data;
80         History.push(LastMsg);
81     }
82 }