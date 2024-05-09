1 pragma solidity ^0.4.19;
2 
3 contract ACCURAL_DEPOSIT
4 {
5     mapping (address=>uint256) public balances;   
6    
7     uint public MinSum = 1 ether;
8     
9     LogFile Log = LogFile(0x0486cF65A2F2F3A392CBEa398AFB7F5f0B72FF46);
10     
11     bool intitalized;
12     
13     function SetMinSum(uint _val)
14     public
15     {
16         if(intitalized)revert();
17         MinSum = _val;
18     }
19     
20     function SetLogFile(address _log)
21     public
22     {
23         if(intitalized)revert();
24         Log = LogFile(_log);
25     }
26     
27     function Initialized()
28     public
29     {
30         intitalized = true;
31     }
32     
33     function Deposit()
34     public
35     payable
36     {
37         balances[msg.sender]+= msg.value;
38         Log.AddMessage(msg.sender,msg.value,"Put");
39     }
40     
41     function Collect(uint _am)
42     public
43     payable
44     {
45         if(balances[msg.sender]>=MinSum && balances[msg.sender]>=_am)
46         {
47             if(msg.sender.call.value(_am)())
48             {
49                 balances[msg.sender]-=_am;
50                 Log.AddMessage(msg.sender,_am,"Collect");
51             }
52         }
53     }
54     
55     function() 
56     public 
57     payable
58     {
59         Deposit();
60     }
61     
62 }
63 
64 
65 
66 contract LogFile
67 {
68     struct Message
69     {
70         address Sender;
71         string  Data;
72         uint Val;
73         uint  Time;
74     }
75     
76     Message[] public History;
77     
78     Message LastMsg;
79     
80     function AddMessage(address _adr,uint _val,string _data)
81     public
82     {
83         LastMsg.Sender = _adr;
84         LastMsg.Time = now;
85         LastMsg.Val = _val;
86         LastMsg.Data = _data;
87         History.push(LastMsg);
88     }
89 }