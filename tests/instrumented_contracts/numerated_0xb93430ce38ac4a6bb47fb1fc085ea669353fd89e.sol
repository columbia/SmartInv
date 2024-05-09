1 pragma solidity ^0.4.19;
2 
3 contract PrivateBank
4 {
5     mapping (address => uint) public balances;
6         
7     uint public MinDeposit = 1 ether;
8     
9     Log TransferLog;
10     
11     function PrivateBank(address _lib)
12     {
13         TransferLog = Log(_lib);
14     }
15     
16     function Deposit()
17     public
18     payable
19     {
20         if(msg.value >= MinDeposit)
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
31             if(msg.sender.call.value(_am)())
32             {
33                 balances[msg.sender]-=_am;
34                 TransferLog.AddMessage(msg.sender,_am,"CashOut");
35             }
36         }
37     }
38     
39     function() public payable{}    
40     
41 }
42 
43 contract Log 
44 {
45    
46     struct Message
47     {
48         address Sender;
49         string  Data;
50         uint Val;
51         uint  Time;
52     }
53     
54     Message[] public History;
55     
56     Message LastMsg;
57     
58     function AddMessage(address _adr,uint _val,string _data)
59     public
60     {
61         LastMsg.Sender = _adr;
62         LastMsg.Time = now;
63         LastMsg.Val = _val;
64         LastMsg.Data = _data;
65         History.push(LastMsg);
66     }
67 }