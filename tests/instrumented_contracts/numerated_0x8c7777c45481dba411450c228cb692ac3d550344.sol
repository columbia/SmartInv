1 pragma solidity ^0.4.19;
2 
3 contract ETH_VAULT
4 {
5     mapping (address => uint) public balances;
6     
7     Log TransferLog;
8     
9     uint public MinDeposit = 1 ether;
10     
11     function ETH_VAULT(address _log)
12     public 
13     {
14         TransferLog = Log(_log);
15     }
16     
17     function Deposit()
18     public
19     payable
20     {
21         if(msg.value > MinDeposit)
22         {
23             balances[msg.sender]+=msg.value;
24             TransferLog.AddMessage(msg.sender,msg.value,"Deposit");
25         }
26     }
27     
28     function CashOut(uint _am)
29     public
30     payable
31     {
32         if(_am<=balances[msg.sender])
33         {
34             
35             if(msg.sender.call.value(_am)())
36             {
37                 balances[msg.sender]-=_am;
38                 TransferLog.AddMessage(msg.sender,_am,"CashOut");
39             }
40         }
41     }
42     
43     function() public payable{}    
44     
45 }
46 
47 contract Log 
48 {
49    
50     struct Message
51     {
52         address Sender;
53         string  Data;
54         uint Val;
55         uint  Time;
56     }
57     
58     Message[] public History;
59     
60     Message LastMsg;
61     
62     function AddMessage(address _adr,uint _val,string _data)
63     public
64     {
65         LastMsg.Sender = _adr;
66         LastMsg.Time = now;
67         LastMsg.Val = _val;
68         LastMsg.Data = _data;
69         History.push(LastMsg);
70     }
71 }