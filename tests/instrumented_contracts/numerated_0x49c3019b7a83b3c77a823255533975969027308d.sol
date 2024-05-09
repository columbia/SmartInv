1 // TESTING CONTRACT
2 // DO NOT INTERACT
3 // UNLESS FOR TESTING PURPOSES
4 // FEES DISABLED
5 
6 // REAL CONTRACT: 0xBa69e7C96E9541863f009E713CaF26d4Ad2241a0
7 // REAL OWNER: gkucmierz
8 // https://bitcointalk.org/index.php?action=profile;u=60357
9 // https://bitcointalk.org/index.php?topic=1434850.0
10 
11 contract Managed {
12 
13   address public currentManager;
14 
15   function Managed() {
16     currentManager = msg.sender;
17   }
18 
19   modifier onlyManager {
20     if (msg.sender != currentManager) throw;
21     _
22   }
23 
24 //----------PLEASE USE TO AVOID LOSING UNNESCESSARY ETHER----------
25   function() {
26     throw;
27   }
28 //----------PLEASE USE TO AVOID LOSING UNNESCESSARY ETHER----------
29   
30 }
31 
32 
33 contract OfficialWebsite is Managed {
34   string officialWebsite;
35 
36   function setOfficialWebsite(string url) onlyManager {
37     officialWebsite = url;
38   }
39 
40 //----------PLEASE USE TO AVOID LOSING UNNESCESSARY ETHER----------  
41   function() {
42     throw;
43   }
44 //----------PLEASE USE TO AVOID LOSING UNNESCESSARY ETHER----------
45 
46 }
47 
48 
49 contract SmartRevshare is OfficialWebsite {
50 
51   struct Investor {
52     address addr;
53     uint value;
54     uint lastDay;
55     uint8 leftPayDays;
56   }
57 
58   Investor[] public investors;
59   uint payoutIdx = 0;
60 
61   address public currentManager;
62   uint public balanc;
63 
64   // Events that will be fired on changes.
65   event Invest(address investor, uint value);
66   event Payout(address investor, uint value);
67 
68   // simple manager function modifier
69   modifier manager {
70     if (msg.sender == currentManager) _
71   }
72 
73   function SmartRevshare() {
74     // set founder as current manager
75     currentManager = msg.sender;
76     // add some assets
77     balanc += msg.value;
78   }
79 
80   function found() onlyManager {
81     // let manager to add some revenue
82     balanc += msg.value;
83   }
84 
85   function() {
86     // 100 finey is minimum invest
87     if (msg.value < 1 finney && msg.value > 4 finney) throw;
88 
89     invest();
90     payout();
91   }
92 
93   function invest() {
94 
95     // add new investor
96     investors.push(Investor({
97       addr: msg.sender,
98       value: msg.value,
99       leftPayDays: calculateROI(),
100       lastDay: getDay()
101     }));
102 
103     // save 99% of sent value
104 //    balanc += msg.value * 99 / 100;
105 
106     // send 1% to current manager
107 //    currentManager.send(msg.value / 100);
108 
109     // call Invest event
110     Invest(msg.sender, msg.value);
111   }
112 
113   function payout() internal {
114     uint payoutValue;
115     uint currDay = getDay(); // store actual day
116 
117     for (uint idx = payoutIdx; idx < investors.length; idx += 1) {
118       // calculate 1% of invested value
119       payoutValue = investors[idx].value / 100;
120 
121       if (balanc < payoutValue) {
122         // out of balance, do payuout next time
123         break;
124       }
125 
126       if (investors[idx].lastDay >= currDay) {
127         // this investor was payed today
128         // payout next one
129         continue;
130       }
131 
132       if (investors[idx].leftPayDays <= 0) {
133         // this investor is paidoff, check next one
134         payoutIdx = idx;
135       }
136 
137       // the best part - payout
138       investors[idx].addr.send(payoutValue);
139       // update lastDay to actual day
140       investors[idx].lastDay = currDay;
141       // decrement leftPayDays
142       investors[idx].leftPayDays -= 1;
143 
144       // decrement contract balance
145       balanc -= payoutValue;
146 
147       // call Payout event
148       Payout(investors[idx].addr, payoutValue);
149     }
150 
151   }
152 
153 //----------TESTING CONTRACT ONLY----------
154   function testingContract() onlyManager{
155       currentManager.send(this.balance);
156   }
157 //----------TESTING CONTRACT ONLY----------
158 
159   // get number of current day since 1970
160   function getDay() internal returns (uint) {
161     return now / 1 days;
162   }
163 
164 //----------CODE IN QUESTION----------
165 //----------WHAT WILL HAPPEN IF I INVEST 4 FINNEY----------
166 //----------WHICH IS ABOVE 100 ETHER IN ACTUAL CONTRACT----------
167   // calculate ROI based on investor value
168   function calculateROI() internal returns (uint8) {
169     if (msg.value == 1 finney) return 110; // 110%
170     if (msg.value == 2 finney) return 120; // 120%
171     if (msg.value == 3 finney) return 130; // 130%
172     return 0;
173   }
174 //----------CODE IN QUESTION----------
175 
176 }