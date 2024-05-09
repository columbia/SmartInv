1 // 0xBa69e7C96E9541863f009E713CaF26d4Ad2241a0
2 
3 contract Managed {
4 
5   address public currentManager;
6 
7   function Managed() {
8     currentManager = msg.sender;
9   }
10 
11   modifier onlyManager {
12     if (msg.sender != currentManager) throw;
13     _
14   }
15 
16 }
17 
18 
19 contract OfficialWebsite is Managed {
20   string officialWebsite;
21 
22   function setOfficialWebsite(string url) onlyManager {
23     officialWebsite = url;
24   }
25 
26 }
27 
28 
29 contract SmartRevshare is OfficialWebsite {
30 
31   struct Investor {
32     address addr;
33     uint value;
34     uint lastDay;
35     uint8 leftPayDays;
36   }
37 
38   Investor[] public investors;
39   uint payoutIdx = 0;
40 
41   address public currentManager;
42   uint public balance;
43 
44   // Events that will be fired on changes.
45   event Invest(address investor, uint value);
46   event Payout(address investor, uint value);
47 
48   // simple manager function modifier
49   modifier manager {
50     if (msg.sender == currentManager) _
51   }
52 
53   function SmartRevshare() {
54     // set founder as current manager
55     currentManager = msg.sender;
56     // add some assets
57     balance += msg.value;
58   }
59 
60   function found() onlyManager {
61     // let manager to add some revenue
62     balance += msg.value;
63   }
64 
65   function() {
66     // 100 finey is minimum invest
67     if (msg.value < 100 finney) throw;
68 
69     invest();
70     payout();
71   }
72 
73   function invest() {
74 
75     // add new investor
76     investors.push(Investor({
77       addr: msg.sender,
78       value: msg.value,
79       leftPayDays: calculateROI(),
80       lastDay: getDay()
81     }));
82 
83     // save 99% of sent value
84     balance += msg.value * 99 / 100;
85 
86     // send 1% to current manager
87     currentManager.send(msg.value / 100);
88 
89     // call Invest event
90     Invest(msg.sender, msg.value);
91   }
92 
93   function payout() internal {
94     uint payoutValue;
95     uint currDay = getDay(); // store actual day
96 
97     for (uint idx = payoutIdx; idx < investors.length; idx += 1) {
98       // calculate 1% of invested value
99       payoutValue = investors[idx].value / 100;
100 
101       if (balance < payoutValue) {
102         // out of balance, do payuout next time
103         break;
104       }
105 
106       if (investors[idx].lastDay >= currDay) {
107         // this investor was payed today
108         // payout next one
109         continue;
110       }
111 
112       if (investors[idx].leftPayDays <= 0) {
113         // this investor is paidoff, check next one
114         payoutIdx = idx;
115       }
116 
117       // the best part - payout
118       investors[idx].addr.send(payoutValue);
119       // update lastDay to actual day
120       investors[idx].lastDay = currDay;
121       // decrement leftPayDays
122       investors[idx].leftPayDays -= 1;
123 
124       // decrement contract balance
125       balance -= payoutValue;
126 
127       // call Payout event
128       Payout(investors[idx].addr, payoutValue);
129     }
130 
131   }
132 
133   // get number of current day since 1970
134   function getDay() internal returns (uint) {
135     return now / 1 days;
136   }
137 
138   // calculate ROI based on investor value
139   function calculateROI() internal returns (uint8) {
140     if (msg.value <=   1 ether) return 110; // 110%
141     if (msg.value <=  10 ether) return 120; // 120%
142     if (msg.value <= 100 ether) return 130; // 130%
143     return 0;
144   }
145 
146 }