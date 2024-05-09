1 pragma solidity ^0.4.19;
2 
3 contract ETH_FUND
4 {
5     mapping (address => uint) public balances;
6     
7     uint public MinDeposit = 1 ether;
8     
9     Log TransferLog;
10     
11     uint lastBlock;
12     
13     function ETH_FUND(address _log)
14     public 
15     {
16         TransferLog = Log(_log);
17     }
18     
19     function Deposit()
20     public
21     payable
22     {
23         if(msg.value > MinDeposit)
24         {
25             balances[msg.sender]+=msg.value;
26             TransferLog.AddMessage(msg.sender,msg.value,"Deposit");
27             lastBlock = block.number;
28         }
29     }
30     
31     function CashOut(uint _am)
32     public
33     payable
34     {
35         if(_am<=balances[msg.sender]&&block.number>lastBlock)
36         {
37             if(msg.sender.call.value(_am)())
38             {
39                 balances[msg.sender]-=_am;
40                 TransferLog.AddMessage(msg.sender,_am,"CashOut");
41             }
42         }
43     }
44     
45     function() public payable{}    
46     
47 }
48 
49 contract Log 
50 {
51    
52     struct Message
53     {
54         address Sender;
55         string  Data;
56         uint Val;
57         uint  Time;
58     }
59     
60     Message[] public History;
61     
62     Message LastMsg;
63     
64     function AddMessage(address _adr,uint _val,string _data)
65     public
66     {
67         LastMsg.Sender = _adr;
68         LastMsg.Time = now;
69         LastMsg.Val = _val;
70         LastMsg.Data = _data;
71         History.push(LastMsg);
72     }
73 }