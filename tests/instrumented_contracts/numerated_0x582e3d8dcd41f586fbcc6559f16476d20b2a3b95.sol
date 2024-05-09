1 contract Token { 
2     function issue(address _recipient, uint256 _value) returns (bool success) {} 
3     function totalSupply() constant returns (uint256 supply) {}
4     function unlock() returns (bool success) {}
5 }
6 
7 contract SCLCrowdsale {
8 
9     // Crowdsale details
10     address public beneficiary; // Company address multisig (95% funding)
11     address public creator; // Creator (5% funding)
12     address public confirmedBy; // Address that confirmed beneficiary
13     uint256 public minAmount = 294 ether; // ≈ 250k SCL
14     uint256 public maxAmount = 100000 ether; // ≈ 50 mln SCL
15     uint256 public maxSupply = 50000000 * 10**8; // 50 mln SCL
16     uint256 public minAcceptedAmount = 40 finney; // 1/25 ether
17 
18     // Eth to SCL rate
19     uint256 public ratePreICO = 850;
20     uint256 public rateWaiting = 0;
21     uint256 public rateAngelDay = 750;
22     uint256 public rateFirstWeek = 700;
23     uint256 public rateSecondWeek = 650;
24     uint256 public rateThirdWeek = 600;
25     uint256 public rateLastWeek = 550;
26 
27     uint256 public ratePreICOEnd = 10 days;
28     uint256 public rateWaitingEnd = 20 days;
29     uint256 public rateAngelDayEnd = 21 days;
30     uint256 public rateFirstWeekEnd = 28 days;
31     uint256 public rateSecondWeekEnd = 35 days;
32     uint256 public rateThirdWeekEnd = 42 days;
33     uint256 public rateLastWeekEnd = 49 days;
34 
35     enum Stages {
36         InProgress,
37         Ended,
38         Withdrawn
39     }
40 
41     Stages public stage = Stages.InProgress;
42 
43     // Crowdsale state
44     uint256 public start;
45     uint256 public end;
46     uint256 public raised;
47 
48     // SCL token
49     Token public sclToken;
50 
51     // Invested balances
52     mapping (address => uint256) balances;
53 
54 
55     /**
56      * Throw if at stage other than current stage
57      * 
58      * @param _stage expected stage to test for
59      */
60     modifier atStage(Stages _stage) {
61         if (stage != _stage) {
62             throw;
63         }
64         _;
65     }
66     
67 
68     /**
69      * Throw if sender is not beneficiary
70      */
71     modifier onlyBeneficiary() {
72         if (beneficiary != msg.sender) {
73             throw;
74         }
75         _;
76     }
77 
78 
79     /** 
80      * Get balance of `_investor` 
81      * 
82      * @param _investor The address from which the balance will be retrieved
83      * @return The balance
84      */
85     function balanceOf(address _investor) constant returns (uint256 balance) {
86         return balances[_investor];
87     }
88 
89 
90     /**
91      * Construct
92      *
93      * @param _tokenAddress The address of the SCL token contact
94      */
95     function SCLCrowdsale(address _tokenAddress, address _beneficiary, address _creator, uint256 _start) {
96         sclToken = Token(_tokenAddress);
97         beneficiary = _beneficiary;
98         creator = _creator;
99         start = _start;
100         end = start + rateLastWeekEnd;
101     }
102 
103 
104     /**
105      * For testing purposes
106      *
107      * @return The beneficiary address
108      */
109     function confirmBeneficiary() onlyBeneficiary {
110         confirmedBy = msg.sender;
111     }
112 
113 
114     /**
115      * Convert `_wei` to an amount in SCL using 
116      * the current rate
117      *
118      * @param _wei amount of wei to convert
119      * @return The amount in SCL
120      */
121     function toSCL(uint256 _wei) returns (uint256 amount) {
122         uint256 rate = 0;
123         if (stage != Stages.Ended && now >= start && now <= end) {
124 
125             // Check for preico
126             if (now <= start + ratePreICOEnd) {
127                 rate = ratePreICO;
128             }
129 
130             // Check for waiting period
131             else if (now <= start + rateWaitingEnd) {
132                 rate = rateWaiting;
133             }
134 
135             // Check for angelday
136             else if (now <= start + rateAngelDayEnd) {
137                 rate = rateAngelDay;
138             }
139 
140             // Check first week
141             else if (now <= start + rateFirstWeekEnd) {
142                 rate = rateFirstWeek;
143             }
144 
145             // Check second week
146             else if (now <= start + rateSecondWeekEnd) {
147                 rate = rateSecondWeek;
148             }
149 
150             // Check third week
151             else if (now <= start + rateThirdWeekEnd) {
152                 rate = rateThirdWeek;
153             }
154 
155             // Check last week
156             else if (now <= start + rateLastWeekEnd) {
157                 rate = rateLastWeek;
158             }
159         }
160 
161         return _wei * rate * 10**8 / 1 ether; // 10**8 for 8 decimals
162     }
163 
164 
165     /**
166      * Function to end the crowdsale by setting 
167      * the stage to Ended
168      */
169     function endCrowdsale() atStage(Stages.InProgress) {
170 
171         // Crowdsale not ended yet
172         if (now < end) {
173             throw;
174         }
175 
176         stage = Stages.Ended;
177     }
178 
179 
180     /**
181      * Transfer appropriate percentage of raised amount 
182      * to the company address
183      */
184     function withdraw() onlyBeneficiary atStage(Stages.Ended) {
185 
186         // Confirm that minAmount is raised
187         if (raised < minAmount) {
188             throw;
189         }
190 
191         if (!sclToken.unlock()) {
192             throw;
193         }
194 
195         uint256 ethBalance = this.balance;
196 
197         // 5% eth
198         uint256 ethFees = ethBalance * 5 / 10**2;
199         if (!creator.send(ethFees)) {
200             throw;
201         }
202 
203         // 95% eth
204         if (!beneficiary.send(ethBalance - ethFees)) {
205             throw;
206         }
207 
208         stage = Stages.Withdrawn;
209     }
210 
211 
212     /**
213      * Refund in the case of an unsuccessful crowdsale. The 
214      * crowdsale is considered unsuccessful if minAmount was 
215      * not raised before end
216      */
217     function refund() atStage(Stages.Ended) {
218 
219         // Only allow refunds if minAmount is not raised
220         if (raised >= minAmount) {
221             throw;
222         }
223 
224         uint256 receivedAmount = balances[msg.sender];
225         balances[msg.sender] = 0;
226 
227         if (receivedAmount > 0 && !msg.sender.send(receivedAmount)) {
228             balances[msg.sender] = receivedAmount;
229         }
230     }
231 
232     
233     /**
234      * Receives Eth and issue SCL tokens to the sender
235      */
236     function () payable atStage(Stages.InProgress) {
237 
238         // Crowdsale not started yet
239         if (now < start) {
240             throw;
241         }
242 
243         // Crowdsale expired
244         if (now > end) {
245             throw;
246         }
247 
248         // Enforce min amount
249         if (msg.value < minAcceptedAmount) {
250             throw;
251         }
252  
253         uint256 received = msg.value;
254         uint256 valueInSCL = toSCL(msg.value);
255 
256         // Period between pre-ico and ico
257         if (valueInSCL == 0) {
258             throw;
259         }
260 
261         if (!sclToken.issue(msg.sender, valueInSCL)) {
262             throw;
263         }
264 
265         // Fees
266         uint256 sclFees = valueInSCL * 5 / 10**2;
267 
268         // 5% tokens
269         if (!sclToken.issue(creator, sclFees)) {
270             throw;
271         }
272 
273         if (now <= start + ratePreICOEnd) {
274 
275             // Fees
276             uint256 ethFees = received * 5 / 10**2;
277 
278             // 5% eth
279             if (!creator.send(ethFees)) {
280                 throw;
281             }
282 
283             // During pre-ico - Non-Refundable
284             if (!beneficiary.send(received - ethFees)) {
285                 throw;
286             }
287 
288         } else {
289 
290             // During the ICO
291             balances[msg.sender] += received; // 100% refundable
292         }
293 
294         raised += received;
295 
296         // Check maxAmount raised
297         if (raised >= maxAmount || sclToken.totalSupply() >= maxSupply) {
298             stage = Stages.Ended;
299         }
300     }
301 }