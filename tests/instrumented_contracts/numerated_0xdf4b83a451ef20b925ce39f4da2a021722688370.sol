1 pragma solidity ^0.4.25;
2 
3 contract M_BANK
4 {
5     function Put(uint _unlockTime)
6     public
7     payable
8     {
9         var acc = Acc[msg.sender];
10         acc.balance += msg.value;
11         acc.unlockTime = _unlockTime>now?_unlockTime:now;
12         LogFile.AddMessage(msg.sender,msg.value,"Put");
13     }
14 
15     function Collect(uint _am)
16     public
17     payable
18     {
19         var acc = Acc[msg.sender];
20         if( acc.balance>=MinSum && acc.balance>=_am && now>acc.unlockTime)
21         {
22             if(msg.sender.call.value(_am)())
23             {
24                 acc.balance-=_am;
25                 LogFile.AddMessage(msg.sender,_am,"Collect");
26             }
27         }
28     }
29 
30     function() 
31     public 
32     payable
33     {
34         Put(0);
35     }
36 
37     struct Holder   
38     {
39         uint unlockTime;
40         uint balance;
41     }
42 
43     mapping (address => Holder) public Acc;
44 
45     Log LogFile;
46 
47     uint public MinSum = 1 ether;    
48 
49     function M_BANK(address log) public{
50         LogFile = Log(log);
51     }
52 }
53 
54 
55 contract Log 
56 {
57     struct Message
58     {
59         address Sender;
60         string  Data;
61         uint Val;
62         uint  Time;
63     }
64 
65     Message[] public History;
66 
67     Message LastMsg;
68 
69     function AddMessage(address _adr,uint _val,string _data)
70     public
71     {
72         LastMsg.Sender = _adr;
73         LastMsg.Time = now;
74         LastMsg.Val = _val;
75         LastMsg.Data = _data;
76         History.push(LastMsg);
77     }
78 }