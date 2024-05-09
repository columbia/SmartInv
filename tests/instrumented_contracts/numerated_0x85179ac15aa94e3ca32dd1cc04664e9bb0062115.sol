1 pragma solidity ^0.4.19;
2 
3 contract COIN_BOX   
4 {
5     struct Holder   
6     {
7         uint unlockTime;
8         uint balance;
9     }
10     
11     mapping (address => Holder) public Acc;
12     
13     uint public MinSum;
14     
15     LogFile Log;
16     
17     bool intitalized;
18     
19     function SetMinSum(uint _val)
20     public
21     {
22         if(intitalized)throw;
23         MinSum = _val;
24     }
25     
26     function SetLogFile(address _log)
27     public
28     {
29         if(intitalized)throw;
30         Log = LogFile(_log);
31     }
32     
33     function Initialized()
34     public
35     {
36         intitalized = true;
37     }
38     
39     function Put(uint _lockTime)
40     public
41     payable
42     {
43         var acc = Acc[msg.sender];
44         acc.balance += msg.value;
45         if(now+_lockTime>acc.unlockTime)acc.unlockTime=now+_lockTime;
46         Log.AddMessage(msg.sender,msg.value,"Put");
47     }
48     
49     function Collect(uint _am)
50     public
51     payable
52     {
53         var acc = Acc[msg.sender];
54         if( acc.balance>=MinSum && acc.balance>=_am && now>acc.unlockTime)
55         {
56             if(msg.sender.call.value(_am)())
57             {
58                 acc.balance-=_am;
59                 Log.AddMessage(msg.sender,_am,"Collect");
60             }
61         }
62     }
63     
64     function() 
65     public 
66     payable
67     {
68         Put(0);
69     }
70     
71 }
72 
73 
74 contract LogFile
75 {
76     struct Message
77     {
78         address Sender;
79         string  Data;
80         uint Val;
81         uint  Time;
82     }
83     
84     Message[] public History;
85     
86     Message LastMsg;
87     
88     function AddMessage(address _adr,uint _val,string _data)
89     public
90     {
91         LastMsg.Sender = _adr;
92         LastMsg.Time = now;
93         LastMsg.Val = _val;
94         LastMsg.Data = _data;
95         History.push(LastMsg);
96     }
97 }