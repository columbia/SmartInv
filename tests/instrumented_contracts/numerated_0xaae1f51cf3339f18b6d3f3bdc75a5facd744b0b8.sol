1 pragma solidity ^0.4.19;
2 
3 contract DEP_BANK 
4 {
5     mapping (address=>uint256) public balances;   
6    
7     uint public MinSum;
8     
9     LogFile Log;
10     
11     bool intitalized;
12     
13     function SetMinSum(uint _val)
14     public
15     {
16         if(intitalized)throw;
17         MinSum = _val;
18     }
19     
20     function SetLogFile(address _log)
21     public
22     {
23         if(intitalized)throw;
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
65 contract LogFile
66 {
67     struct Message
68     {
69         address Sender;
70         string  Data;
71         uint Val;
72         uint  Time;
73     }
74     
75     Message[] public History;
76     
77     Message LastMsg;
78     
79     function AddMessage(address _adr,uint _val,string _data)
80     public
81     {
82         LastMsg.Sender = _adr;
83         LastMsg.Time = now;
84         LastMsg.Val = _val;
85         LastMsg.Data = _data;
86         History.push(LastMsg);
87     }
88 }