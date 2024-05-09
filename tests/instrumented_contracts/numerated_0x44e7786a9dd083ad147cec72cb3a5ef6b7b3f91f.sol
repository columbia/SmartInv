1 pragma solidity ^0.4.8;
2  
3 contract owned {
4 
5   address public owner;
6  
7   function owned() { owner = msg.sender; }
8 
9   modifier onlyOwner {
10     if (msg.sender != owner) { throw; }
11     _;
12   }
13 
14   function changeOwner( address newowner ) onlyOwner {
15     owner = newowner;
16   }
17 }
18 
19 contract OX_TOKEN is owned {
20  
21   string public constant name = "OX";
22   string public constant symbol = "OX"; 
23  
24   event Receipt( address indexed _to,
25                  uint _oxen,
26                  uint _paymentwei ); 
27 
28   event Transfer( address indexed _from,
29                   address indexed _to,
30                   uint _ox );
31 
32   uint public starttime;
33   bool public expanded;
34   uint public inCirculation;
35   mapping( address => uint ) public oxen;
36 
37   function OX_TOKEN() {
38     starttime = 0;
39     expanded = false;
40     inCirculation = 0;
41   }
42 
43   function closedown() onlyOwner {
44     selfdestruct( owner );
45   }
46 
47   function() payable {}
48 
49   function withdraw( uint amount ) onlyOwner {
50     if (amount <= this.balance)
51       bool result = owner.send( amount );
52   }
53 
54   function startSale() onlyOwner {
55     if (starttime != 0) return;
56 
57     starttime = now; // now is block timestamp, units are unix-seconds
58 
59     // allocate 2 for the org itself, so only 5 can be sold
60     inCirculation = 200000000;
61     oxen[OX_ORG] = inCirculation;
62     Transfer( OX_ORG, OX_ORG, inCirculation );
63   }
64 
65   // TEST CODE ONLY
66   //function hack() { starttime = now - 32 days; }
67   //function setstart( uint newstart ) { starttime = newstart; }
68   //function gettime() constant returns (uint) { return now; }
69 
70   function expand() {
71     if (expanded || saleOn()) { return; }
72 
73     expanded = true;
74 
75     // 1 / 0.7 = 1.428571..., ext is the number to add
76     uint ext = inCirculation * 1428571428 / 10**9 - inCirculation;
77     oxen[OX_ORG] += ext;
78     inCirculation += ext;
79     Transfer( this, OX_ORG, ext );
80   }
81 
82   function buyOx() payable {
83 
84     // min purchase .1 E = 10**17 wei
85     if (!saleOn() || msg.value < 10**17) {
86       throw; // returns customer's Ether and unused gas
87     }
88 
89     // rate: 1 eth <==> 3000 ox
90     //
91     // to buy: msg.value * 3000 * (100 + bonus)
92     //         ---------          -------------
93     //          10**18                 100
94 
95     uint tobuy = (msg.value * 3 * (100 + bonus())) / 10**17;
96 
97     if (inCirculation + tobuy > 700000000) {
98       throw; // returns customer's Ether and unused gas
99     }
100 
101     inCirculation += tobuy;
102     oxen[msg.sender] += tobuy;
103     Receipt( msg.sender, tobuy, msg.value );
104   }
105 
106   function transfer( address to, uint ox ) {
107     if ( ox > oxen[msg.sender] || saleOn() ) {
108       return;
109     }
110 
111     if (!expanded) { expand(); }
112 
113     oxen[msg.sender] -= ox;
114     oxen[to] += ox;
115     Transfer( msg.sender, to, ox );
116   }
117 
118   function saleOn() constant returns(bool) {
119     return now - starttime < 31 days;
120   }
121 
122   function bonus() constant returns(uint) {
123     uint elapsed = now - starttime;
124 
125     if (elapsed < 1 days) return 25;
126     if (elapsed < 1 weeks) return 20;
127     if (elapsed < 2 weeks) return 15;
128     if (elapsed < 3 weeks) return 10;
129     if (elapsed < 4 weeks) return 5;
130     return 0;
131   }
132 
133   address public constant OX_ORG = 0x8f256c71a25344948777f333abd42f2b8f32be8e;
134   address public constant AUTHOR = 0x8e9342eb769c4039aaf33da739fb2fc8af9afdc1;
135 }