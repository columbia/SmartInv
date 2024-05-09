1 //
2 //  /$$   /$$   /$$                         /$$                        
3 // | $$  | $$  | $$                        |__/                        
4 // | $$  | $$ /$$$$$$    /$$$$$$   /$$$$$$  /$$ /$$   /$$ /$$$$$$/$$$$ 
5 // | $$  | $$|_  $$_/   /$$__  $$ /$$__  $$| $$| $$  | $$| $$_  $$_  $$
6 // | $$  | $$  | $$    | $$  \ $$| $$  \ $$| $$| $$  | $$| $$ \ $$ \ $$
7 // | $$  | $$  | $$ /$$| $$  | $$| $$  | $$| $$| $$  | $$| $$ | $$ | $$
8 // |  $$$$$$/  |  $$$$/|  $$$$$$/| $$$$$$$/| $$|  $$$$$$/| $$ | $$ | $$
9 //  \______/    \___/   \______/ | $$____/ |__/ \______/ |__/ |__/ |__/
10 //                               | $$                                  
11 //                               | $$                                  
12 // 
13 //                                  
14 // Utopium Unstoppable Smart Contract Bot
15 // 4% Or 6% Daily
16 // Batch mass payments to mitigate Block Gas Limit
17 // All functions are internal including Payout
18 
19 
20 pragma solidity ^0.4.24;
21 
22 
23 contract Utopium
24 
25 {
26     struct _Tx {
27         address txuser;
28         uint txvalue;
29     }
30 
31     _Tx[] public Tx;
32     uint public users;
33     uint public batch;
34     address owner;
35 
36     modifier onlyowner
37     {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     constructor() public {
43         owner = msg.sender;
44         
45     }
46     
47     function() public payable {
48         require(msg.value>=0.0001 ether);
49         Optin();
50         
51     }
52     
53     function Optin() internal
54     {
55         uint feecounter;
56         feecounter+=msg.value/5;
57 	    owner.send(feecounter);
58         feecounter=0;
59 
60 	   uint txcounter=Tx.length;     	   
61 	   Tx.length++;
62 	   Tx[txcounter].txuser=msg.sender;
63 	   Tx[txcounter].txvalue=msg.value;
64 	   users=Tx.length;
65 	   
66 	   if (msg.sender == owner )
67         {
68           if (batch == 0 )
69             {
70             
71             uint a=Tx.length;
72 	        uint b;
73 
74 
75             if (a <= 250 )
76             {            
77               b=0;
78               batch=0;
79             } else {                     
80               batch+=1;
81               b=Tx.length-250;
82             }
83 
84 
85             } else {
86 
87             a=Tx.length-(250*batch);
88             
89 
90             if (a <= 250 )
91             {            
92               b=0;
93               batch=0;
94             } else {                     
95               batch+=1;
96               b=a-250;
97             }
98 
99            }
100 
101 
102             Payout(a,b);
103         }
104     }
105     
106     
107     function Payout(uint a, uint b) internal onlyowner {
108         
109         while (a>b) {
110             
111         uint c;   
112         a-=1;
113         
114         if(Tx[a].txvalue < 1000000000000000000) {
115           c=4;
116         } else if (Tx[a].txvalue >= 1000000000000000000) {
117           c=6; 
118         }
119             
120         Tx[a].txuser.send((Tx[a].txvalue/100)*c);
121         
122         }
123     }
124 
125 
126        
127 }