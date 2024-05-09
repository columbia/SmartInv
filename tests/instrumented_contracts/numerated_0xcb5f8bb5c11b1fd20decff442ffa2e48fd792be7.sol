1 pragma solidity ^ 0.4 .24;
2 library MathForInterset {
3     function mul(uint256 _a, uint256 _b) internal pure returns(uint256) {
4         if (_a == 0) {
5             return 0;
6         }
7         uint256 c = _a * _b;
8         require(c / _a == _b);
9         return c;
10     }
11 
12     function div(uint256 _a, uint256 _b) internal pure returns(uint256) {
13         require(_b > 0);
14         uint256 c = _a / _b;
15         return c;
16     }
17 }
18 contract Hermes {
19     using MathForInterset
20     for uint;
21     uint constant public MINIMUM_INVEST = 10000000000000000 wei;
22     uint public DAY_VALUE = 0;
23     uint public DAY_LIMIT = 200 ether;//first limit
24     uint public DEPOSIT_AMOUNT;
25     uint public PERCENT_FOR_MARKETING = 1500000000;
26     address[] public ADDRESSES;
27     mapping(address => Investor) public INVESTORS;
28     address public ADMIN_ADDR;
29     struct Investor {
30         uint id;
31         uint percentCount;
32         uint deposit;
33         uint date;
34         address referrer;
35         uint reinvestID;
36         uint actualValue;
37         uint stage;
38         uint startReinvestDate;
39         uint dayLimitValue;
40     }
41     event reinvest(uint date, address addr, uint active);
42     event payout(uint date, address addr, uint amount, string eventType);
43     constructor() public {
44         ADMIN_ADDR = msg.sender;
45     }
46 
47     function Invest(address _referrer) private {
48         if (msg.value == 0 ether) {
49 
50             if (msg.sender == ADMIN_ADDR) {
51                 payAll();
52             } else {
53                 paySelfByAddress(msg.sender);
54             }
55         } else {
56             if (INVESTORS[msg.sender].deposit == 0) {
57                 require(DAY_VALUE + msg.value < DAY_LIMIT, "DAY LIMIT!!!");
58                 require(INVESTORS[msg.sender].dayLimitValue + msg.value < DAY_LIMIT / 2, "DAY LIMIT!!!");
59                 INVESTORS[msg.sender].dayLimitValue += msg.value;
60                 DAY_VALUE += msg.value;
61                 ADDRESSES.push(msg.sender);
62                 uint id = ADDRESSES.length;
63                 ADMIN_ADDR.send((msg.value.mul(PERCENT_FOR_MARKETING).div(10000000000)).mul(1));
64                 DEPOSIT_AMOUNT += msg.value;
65                 if (msg.value >= MINIMUM_INVEST) {
66                     if (INVESTORS[_referrer].deposit != 0) {
67                         if (INVESTORS[_referrer].deposit >= 3 ether) {
68                             uint value = (msg.value.mul(200000000).div(10000000000));
69                             msg.sender.send(value);
70                             value = (msg.value.mul(250000000).div(10000000000));
71                             _referrer.send(value);
72                             if (INVESTORS[_referrer].stage < 1) {
73 
74                                 INVESTORS[_referrer].stage = 1;
75                             }
76                         }
77                         address nextReferrer = _referrer;
78                         for (uint i = 0; i < 4; i++) {
79                             if (INVESTORS[nextReferrer].referrer == address(0x0)) {
80                                 break;
81                             }
82                             if (INVESTORS[INVESTORS[nextReferrer].referrer].reinvestID != 3) {
83                                 if (INVESTORS[INVESTORS[nextReferrer].referrer].deposit >= 3 ether) {
84                                     if (INVESTORS[INVESTORS[nextReferrer].referrer].stage <= 2) {
85                                         if (INVESTORS[INVESTORS[nextReferrer].referrer].stage <= i + 2) {
86                                             value = (msg.value.mul(100000000).div(10000000000));
87                                             INVESTORS[INVESTORS[nextReferrer].referrer].stage = i + 2;
88                                             INVESTORS[nextReferrer].referrer.send(value);
89                                         }
90                                     }
91                                 }
92                                 if (INVESTORS[INVESTORS[nextReferrer].referrer].deposit >= 5 ether) {
93                                     if (INVESTORS[INVESTORS[nextReferrer].referrer].stage < i + 2) {
94                                         INVESTORS[INVESTORS[nextReferrer].referrer].stage = i + 2;
95                                     }
96                                     if (i + 2 == 2) {
97                                         value = (msg.value.mul(150000000).div(10000000000));
98                                     }
99                                     if (i + 2 == 3) {
100                                         value = (msg.value.mul(75000000).div(10000000000));
101                                     }
102                                     if (i + 2 == 4) {
103                                         value = (msg.value.mul(50000000).div(10000000000));
104                                     }
105                                     if (i + 2 == 5) {
106                                         value = (msg.value.mul(25000000).div(10000000000));
107                                     }
108                                     INVESTORS[nextReferrer].referrer.send(value);
109                                 }
110                             }
111                             nextReferrer = INVESTORS[nextReferrer].referrer;
112                             if (nextReferrer == address(0x0)) {
113                                 break;
114                             }
115                         }
116                     } else {
117                         _referrer = address(0x0);
118                     }
119                 } else {
120                     _referrer = address(0x0);
121                 }
122                 INVESTORS[msg.sender] = Investor(id, 0, msg.value, now, _referrer, 0, msg.value, 0, 0, msg.value);
123             } else {
124                 require(DAY_VALUE + msg.value < DAY_LIMIT, "DAY LIMIT!!!");
125                 require(INVESTORS[msg.sender].dayLimitValue + msg.value < DAY_LIMIT / 2, "DAY LIMIT!!!");
126                 INVESTORS[msg.sender].dayLimitValue += msg.value;
127                 DAY_VALUE += msg.value;
128                 if (INVESTORS[msg.sender].reinvestID == 3) {
129                     INVESTORS[msg.sender].reinvestID = 0;
130                 }
131                 INVESTORS[msg.sender].deposit += msg.value;
132                 INVESTORS[msg.sender].actualValue += msg.value;
133                 DEPOSIT_AMOUNT += msg.value;
134                 ADMIN_ADDR.send((msg.value.mul(PERCENT_FOR_MARKETING).div(10000000000)).mul(1));
135                 if (msg.value == 0.000012 ether) {
136                     require(INVESTORS[msg.sender].reinvestID == 0, "REINVEST BLOCK");
137                     INVESTORS[msg.sender].reinvestID = 1;
138                     INVESTORS[msg.sender].startReinvestDate = now;
139                     emit reinvest(now,msg.sender, 1);
140                 }
141                 if (msg.value == 0.000013 ether) {
142                     uint interval = 0;
143                     uint interest = 0;
144                     require(INVESTORS[msg.sender].reinvestID == 1, "REINVEST BLOCK");
145 
146                     if ((DEPOSIT_AMOUNT >= 0 ether) && (DEPOSIT_AMOUNT < 1000 ether)) {
147                         interest = 125000000; //1.25
148                     }
149                     if ((DEPOSIT_AMOUNT >= 1000 ether) && (DEPOSIT_AMOUNT <= 2000 ether)) {
150                         interest = 100000000; //1
151                     }
152                     if ((DEPOSIT_AMOUNT >= 2000 ether) && (DEPOSIT_AMOUNT <= 3000 ether)) {
153                         interest = 75000000; //0.75
154                     }
155                     if (DEPOSIT_AMOUNT > 3000 ether) {
156                         interest = 60000000; //0.6
157                     }
158                     ////
159                     interval = (now - INVESTORS[msg.sender].startReinvestDate) / 1 days;
160                     interest = (interest + INVESTORS[msg.sender].stage * 10000000) * interval;
161                     value = (INVESTORS[msg.sender].deposit.mul(interest).div(10000000000)).mul(1);
162                     INVESTORS[msg.sender].percentCount += interest;
163                     INVESTORS[msg.sender].deposit += value;
164                     INVESTORS[msg.sender].actualValue = INVESTORS[msg.sender].deposit;
165                     INVESTORS[msg.sender].reinvestID = 0;
166                     emit reinvest(now,msg.sender, 0);
167                 }
168             }
169         }
170     }
171 
172     function() payable public {
173         require(msg.value >= MINIMUM_INVEST || msg.value == 0.000012 ether || msg.value == 0 ether || msg.value == 0.000013 ether, "Too small amount, minimum 0.01 ether");
174         require(INVESTORS[msg.sender].percentCount < 10000000000, "You can't invest");
175         require(INVESTORS[msg.sender].reinvestID != 1 || msg.value == 0.000013 ether, "You can't invest");
176         Invest(bytesToAddress(msg.data));
177     }
178 
179 
180 
181     function paySelfByAddress(address addr) public {
182 
183         uint interest = 0;
184         if ((DEPOSIT_AMOUNT >= 0) && (DEPOSIT_AMOUNT < 1000 ether)) {
185             interest = 125000000; //1.25
186         }
187         if ((DEPOSIT_AMOUNT >= 1000 ether) && (DEPOSIT_AMOUNT <= 2000 ether)) {
188             interest = 100000000; //1
189         }
190         if ((DEPOSIT_AMOUNT >= 2000 ether) && (DEPOSIT_AMOUNT <= 3000 ether)) {
191             interest = 75000000; //0.75
192         }
193         if (DEPOSIT_AMOUNT >= 3000 ether) {
194             interest = 60000000; //0.6
195         }
196         Investor storage stackObject = INVESTORS[addr];
197         uint value = 0;
198         uint interval = (now - INVESTORS[addr].date) / 1 days;
199         if (interval > 0) {
200             interest = ((INVESTORS[addr].stage * 10000000) + interest) * interval;
201             /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
202             if (INVESTORS[addr].reinvestID == 1) {
203                 uint residualInterest = 0;
204                 value = (stackObject.actualValue.mul(interest).div(10000000000));
205                 residualInterest = (((stackObject.actualValue + value) - stackObject.deposit).mul(10000000000)).div(stackObject.deposit);
206                 if (INVESTORS[addr].percentCount + residualInterest >= 10000000000) {
207 
208                     value = (stackObject.deposit * 2) - INVESTORS[addr].actualValue;
209                     INVESTORS[addr].reinvestID = 2;
210                     INVESTORS[addr].percentCount = 10000000000;
211                 }
212                 INVESTORS[addr].actualValue += value;
213                 INVESTORS[addr].date = now;
214             }
215             /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
216             if (INVESTORS[addr].reinvestID == 0 || INVESTORS[addr].reinvestID == 2) {
217                 if (INVESTORS[addr].percentCount != 10000000000) {
218                     if (INVESTORS[addr].percentCount + interest >= 10000000000) {
219                         interest = 10000000000 - INVESTORS[addr].percentCount;
220 
221                     }
222                     INVESTORS[addr].percentCount += interest;
223                     value = (stackObject.deposit.mul(interest).div(10000000000));
224                     addr.send(value);
225                     emit payout(now,addr, value, "Interest payment");
226                     INVESTORS[addr].date = now;
227                 } else {
228                     if (INVESTORS[addr].reinvestID == 2) {
229                         interest = 2000000000 * interval;
230                     }
231                     value = (stackObject.deposit.mul(interest).div(10000000000));
232                     if (INVESTORS[addr].actualValue < value) {
233                         value = INVESTORS[addr].actualValue;
234                     }
235                     INVESTORS[addr].actualValue -= value;
236                     addr.send(value);
237                     emit payout(now,addr, value, "Body payout");
238                     INVESTORS[addr].date = now;
239                     if (INVESTORS[addr].actualValue == 0) {
240                         INVESTORS[addr].reinvestID = 3;
241                         INVESTORS[addr].deposit = 0;
242                         INVESTORS[addr].percentCount = 0;
243                         INVESTORS[addr].actualValue = 0;
244                     }
245                 }
246             }
247             /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
248         }
249     }
250 
251 
252     function payAll() private {
253         DAY_VALUE = 0;
254         //////////////////////////////////////////////
255         for (uint i = 0; i < ADDRESSES.length; i++) {
256             INVESTORS[ADDRESSES[i]].dayLimitValue = 0;
257             paySelfByAddress(ADDRESSES[i]);
258         }
259 
260         if (address(this).balance < 1000 ether) {
261             DAY_LIMIT = 200 ether;
262         }
263         if (address(this).balance >= 1000 ether && address(this).balance < 2000 ether) {
264             DAY_LIMIT = 400 ether;
265         }
266         if (address(this).balance >= 2000 && address(this).balance < 4000 ether) {
267             DAY_LIMIT = 600 ether;
268         }
269         if (address(this).balance >= 4000 ether) {
270             DAY_LIMIT = 1000000000 ether;
271         }
272     }
273 
274     function bytesToAddress(bytes bys) private pure returns(address addr) {
275         assembly {
276             addr: = mload(add(bys, 20))
277         }
278     }
279 }