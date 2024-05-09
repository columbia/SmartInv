1 pragma solidity ^0.4.15;
2 
3 /*
4 - The ZTT pre-sale will last between September 5 to 15 with a 5% bonus payable in ZTT on all purchases.
5 - The ICO is expected to start September 15, 2017, and run for exactly 30 days.
6 - The PreICO price is 290ZTT/ETH. Bonus of 25 ZTT on the first day. The first week price is 250 ZTT/ETH. The price then increases approximately 26%/week and 3.6%/raised ZTT in multiples of minimum amount to be raised. In the first day, price is 275 - times funds raised discount factor. In first, second, third and fourth week, price is 250, 198, 157, 125 respectively times discount factor. The discount factor for each successive multiple (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, etc) of the minimum funds raised so far, of 1, .966, .933, .901, .871, .841, .812, .785, .758, .732, .707, etc.
7 - Tradable when issued to the public for consideration, after the ICO closes.
8 - Dividends of 4% per annum are payable as increased territory size
9 - Deputy Mayor crypto-currency governance role.
10 - Democratic governance applies to traffic congestion. All crowd funders who own ZTT coins are "Deputy Mayors" of their district below and may democratically advise ZeroTraffic on congested areas in their district on a regular basis. District maybe re-centered.
11 - Coins are optionally retractable and redeemable by ZeroTraffic, individually from each owner any time after 5 years after IOD. Once an owner is exchanged, the market price average for the last 5 days shall be used to compute payment.
12 - At least 1250 ZTTs' are required to fill the role of Deputy Mayor.
13 - Price per each non-exclusive circle of radius 1/2 km, around any ZTT coin owner specified GPS point, for a map of traffic standstill congestion management advice = (1250 ZTT). Additional size regions are priced for a R' km radius at (R'/R)**2 *price for 1/2km radius in ZTT coin.
14 - To be exempt from securities laws, there is no share ownership to ZTT coin holders, right to dividends, proceeds from sales. The parties agree that the Howey test is not met: "investment of money from an expectation of profits arising from a common enterprise depending solely on the efforts of a promoter or third party". Proceeds will fund initial and continuing development and business development, depending on level of funds raised, for several years.
15 - Funds raised in ICO are refundable if minimum isn't met during ICO and presale, however funds raised during the PreICO are not subject to refund on minimum raise.
16 */
17 
18 contract Token { 
19     function issue(address _recipient, uint256 _value) returns (bool success);
20     function balanceOf(address _owner) constant returns (uint256 balance);
21     function owner() returns (address _owner);
22 }
23 
24 contract ZTCrowdsale {
25 
26     // Crowdsale details
27     address public beneficiary; // Company address
28     address public creator; // Creator address
29     address public confirmedBy; // Address that confirmed beneficiary
30     uint256 public minAmount = 20000 ether; 
31     uint256 public maxAmount = 400000 ether; 
32     uint256 public minAcceptedAmount = 40 finney; // 1/25 ether
33 
34     // Eth to ZT rate
35     uint256 public ratePreICO = 290;
36     uint256 public rateAngelDay = 275;
37     uint256 public rateFirstWeek = 250;
38     uint256 public rateSecondWeek = 198;
39     uint256 public rateThirdWeek = 157;
40     uint256 public rateLastWeek = 125;
41 
42     uint256 public ratePreICOEnd = 10 days;
43     uint256 public rateAngelDayEnd = 11 days;
44     uint256 public rateFirstWeekEnd = 18 days;
45     uint256 public rateSecondWeekEnd = 25 days;
46     uint256 public rateThirdWeekEnd = 32 days;
47     uint256 public rateLastWeekEnd = 39 days;
48 
49     enum Stages {
50         InProgress,
51         Ended,
52         Withdrawn
53     }
54 
55     Stages public stage = Stages.InProgress;
56 
57     // Crowdsale state
58     uint256 public start;
59     uint256 public end;
60     uint256 public raised;
61 
62     // ZT token
63     Token public ztToken;
64 
65     // Invested balances
66     mapping (address => uint256) balances;
67 
68 
69     /**
70      * Throw if at stage other than current stage
71      * 
72      * @param _stage expected stage to test for
73      */
74     modifier atStage(Stages _stage) {
75         require(stage == _stage);
76         _;
77     }
78 
79 
80     /**
81      * Throw if sender is not beneficiary
82      */
83     modifier onlyBeneficiary() {
84         require(beneficiary == msg.sender);
85         _;
86     }
87 
88 
89     /** 
90      * Get balance of `_investor` 
91      * 
92      * @param _investor The address from which the balance will be retrieved
93      * @return The balance
94      */
95     function balanceOf(address _investor) constant returns (uint256 balance) {
96         return balances[_investor];
97     }
98 
99 
100     /**
101      * Most params are hardcoded for clarity
102      *
103      * @param _tokenAddress The address of the ZT token contact
104      */
105     function ZTCrowdsale(address _tokenAddress, address _beneficiary, address _creator, uint256 _start) {
106         ztToken = Token(_tokenAddress);
107         beneficiary = _beneficiary;
108         creator = _creator;
109         start = _start;
110         end = start + rateLastWeekEnd;
111     }
112 
113 
114     /**
115      * For testing purposes
116      *
117      * @return The beneficiary address
118      */
119     function confirmBeneficiary() onlyBeneficiary {
120         confirmedBy = msg.sender;
121     }
122 
123 
124     /**
125      * Convert `_wei` to an amount in ZT using 
126      * the current rate
127      *
128      * @param _wei amount of wei to convert
129      * @return The amount in ZT
130      */
131     function toZT(uint256 _wei) returns (uint256 amount) {
132         uint256 rate = 0;
133         if (stage != Stages.Ended && now >= start && now <= end) {
134 
135             // Check for preico
136             if (now <= start + ratePreICOEnd) {
137                 rate = ratePreICO;
138             }
139 
140             // Check for angelday
141             else if (now <= start + rateAngelDayEnd) {
142                 rate = rateAngelDay;
143             }
144 
145             // Check first week
146             else if (now <= start + rateFirstWeekEnd) {
147                 rate = rateFirstWeek;
148             }
149 
150             // Check second week
151             else if (now <= start + rateSecondWeekEnd) {
152                 rate = rateSecondWeek;
153             }
154 
155             // Check third week
156             else if (now <= start + rateThirdWeekEnd) {
157                 rate = rateThirdWeek;
158             }
159 
160             // Check last week
161             else if (now <= start + rateLastWeekEnd) {
162                 rate = rateLastWeek;
163             }
164         }
165 
166         uint256 ztAmount = _wei * rate * 10**8 / 1 ether; // 10**8 for 8 decimals
167 
168         // Increase price after min amount is reached
169         if (raised > minAmount) {
170             uint256 multiplier = raised / minAmount; // Remainder discarded
171             for (uint256 i = 0; i < multiplier; i++) {
172                 ztAmount = ztAmount * 965936329 / 10**9;
173             }
174         }
175 
176         return ztAmount;
177     }
178 
179 
180     /**
181      * Function to end the crowdsale by setting 
182      * the stage to Ended
183      */
184     function endCrowdsale() atStage(Stages.InProgress) {
185 
186         // Crowdsale not ended yet
187         require(now >= end);
188 
189         stage = Stages.Ended;
190     }
191 
192 
193     /**
194      * Transfer appropriate percentage of raised amount 
195      * to the company address
196      */
197     function withdraw() atStage(Stages.Ended) {
198 
199         // Confirm that minAmount is raised
200         require(raised >= minAmount);
201 
202         uint256 ethBalance = this.balance;
203         uint256 ethFees = ethBalance * 5 / 10**3; // 0.005
204         creator.transfer(ethFees);
205         beneficiary.transfer(ethBalance - ethFees);
206 
207         stage = Stages.Withdrawn;
208     }
209 
210 
211     /**
212      * Refund in the case of an unsuccessful crowdsale. The 
213      * crowdsale is considered unsuccessful if minAmount was 
214      * not raised before end
215      */
216     function refund() atStage(Stages.Ended) {
217 
218         // Only allow refunds if minAmount is not raised
219         require(raised < minAmount);
220 
221         uint256 receivedAmount = balances[msg.sender];
222         balances[msg.sender] = 0;
223 
224         if (receivedAmount > 0 && !msg.sender.send(receivedAmount)) {
225             balances[msg.sender] = receivedAmount;
226         }
227     }
228 
229     
230     /**
231      * Receives Eth and issue ZT tokens to the sender
232      */
233     function () payable atStage(Stages.InProgress) {
234 
235         // Require Crowdsale started
236         require(now > start);
237 
238         // Require Crowdsale not expired
239         require(now < end);
240 
241         // Enforce min amount
242         require(msg.value >= minAcceptedAmount);
243         
244         address sender = msg.sender;
245         uint256 received = msg.value;
246         uint256 valueInZT = toZT(msg.value);
247         if (!ztToken.issue(sender, valueInZT)) {
248             revert();
249         }
250 
251         if (now <= start + ratePreICOEnd) {
252 
253             // Fees
254             uint256 ethFees = received * 5 / 10**3; // 0.005
255 
256             // 0.5% eth
257             if (!creator.send(ethFees)) {
258                 revert();
259             }
260 
261             // During pre-ico - Non-Refundable
262             if (!beneficiary.send(received - ethFees)) {
263                 revert();
264             }
265 
266         } else {
267 
268             // During the ICO
269             balances[sender] += received; // 100% refundable
270         }
271 
272         raised += received;
273 
274         // Check maxAmount raised
275         if (raised >= maxAmount) {
276             stage = Stages.Ended;
277         }
278     }
279 }