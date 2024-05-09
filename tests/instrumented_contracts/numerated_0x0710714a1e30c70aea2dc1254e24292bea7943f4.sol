1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal constant returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal constant returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract Token {
32     function issue(address _recipient, uint256 _value) returns (bool success) {}
33     function issueAtIco(address _recipient, uint256 _value, uint256 _icoNumber) returns (bool success) {}
34     function totalSupply() constant returns (uint256 supply) {}
35     function unlock() returns (bool success) {}
36 }
37 
38 contract RICHCrowdsale {
39 
40     using SafeMath for uint256;
41 
42     // Crowdsale addresses
43     address public creator; // Creator (1% funding)
44     address public buyBackFund; // Fund for buying back and burning (48% funding)
45     address public humanityFund; // Humanity fund (51% funding)
46 
47     // Withdrawal rules
48     uint256 public creatorWithdraw = 0; // Current withdrawed
49     uint256 public maxCreatorWithdraw = 5 * 10 ** 3 * 10**18; // First 5.000 ETH
50     uint256 public percentageHumanityFund = 51; // Percentage goes to Humanity fund
51     uint256 public percentageBuyBackFund = 49; // Percentage goes to Buy-back fund
52 
53     // Eth to token rate
54     uint256 public currentMarketRate = 1; // Current market price ETH/RCH. Will be updated before each ico
55     uint256 public minimumIcoRate = 240; // ETH/dollar rate. Minimum rate at wich will be issued RICH token, 1$ = 1RCH
56     uint256 public minAcceptedEthAmount = 4 finney; // 0.004 ether
57 
58     // ICOs specification
59     uint256 public maxTotalSupply = 1000000000 * 10**8; // 1 mlrd. tokens
60 
61     mapping (uint256 => uint256) icoTokenIssued; // Issued in each ICO
62     uint256 public totalTokenIssued; // Total of issued tokens
63 
64     uint256 public icoPeriod = 10 days;
65     uint256 public noIcoPeriod = 10 days;
66     uint256 public maxIssuedTokensPerIco = 10**6 * 10**8; // 1 mil.
67     uint256 public preIcoPeriod = 30 days;
68 
69     uint256 public bonusPreIco = 50;
70     uint256 public bonusFirstIco = 30;
71     uint256 public bonusSecondIco = 10;
72 
73     uint256 public bonusSubscription = 5;
74     mapping (address => uint256) subsriptionBonusTokensIssued;
75 
76     // Balances
77     mapping (address => uint256) balances;
78     mapping (address => uint256) tokenBalances;
79     mapping (address => mapping (uint256 => uint256)) tokenBalancesPerIco;
80 
81     enum Stages {
82         Countdown,
83         PreIco,
84         PriorityIco,
85         OpenIco,
86         Ico, // [PreIco, PriorityIco, OpenIco]
87         NoIco,
88         Ended
89     }
90 
91     Stages public stage = Stages.Countdown;
92 
93     // Crowdsale times
94     uint public start;
95     uint public preIcoStart;
96 
97     // Rich token
98     Token public richToken;
99 
100     /**
101      * Throw if at stage other than current stage
102      *
103      * @param _stage expected stage to test for
104      */
105     modifier atStage(Stages _stage) {
106         updateState();
107 
108         if (stage != _stage && _stage != Stages.Ico) {
109             throw;
110         }
111 
112         if (stage != Stages.PriorityIco && stage != Stages.OpenIco && stage != Stages.PreIco) {
113             throw;
114         }
115         _;
116     }
117 
118 
119     /**
120      * Throw if sender is not creator
121      */
122     modifier onlyCreator() {
123         if (creator != msg.sender) {
124             throw;
125         }
126         _;
127     }
128 
129     /**
130      * Get bonus for provided ICO number
131      *
132      * @param _currentIco current ico number
133      * @return percentage
134      */
135     function getPercentageBonusForIco(uint256 _currentIco) returns (uint256 percentage) {
136         updateState();
137 
138         if (stage == Stages.PreIco) {
139             return bonusPreIco;
140         }
141 
142         if (_currentIco == 1) {
143             return bonusFirstIco;
144         }
145 
146         if (_currentIco == 2) {
147             return bonusSecondIco;
148         }
149 
150         return 0;
151     }
152 
153     /**
154      * Get ethereum balance of `_investor`
155      *
156      * @param _investor The address from which the balance will be retrieved
157      * @return The balance
158      */
159     function balanceOf(address _investor) constant returns (uint256 balance) {
160         return balances[_investor];
161     }
162 
163     /**
164      * Construct
165      *
166      * @param _tokenAddress The address of the Rich token contact
167      * @param _creator Contract creator
168      * @param _start Start of the first ICO
169      * @param _preIcoStart Start of pre-ICO
170      */
171     function RICHCrowdsale(address _tokenAddress, address _creator, uint256 _start, uint256 _preIcoStart) {
172         richToken = Token(_tokenAddress);
173         creator = _creator;
174         start = _start;
175         preIcoStart = _preIcoStart;
176     }
177 
178     /**
179      * Set current market rate ETH/RICH. Will be caled by creator before each ICO
180      *
181      * @param _currentMarketRate current ETH/RICH rate at the market
182      */
183     function setCurrentMarketRate(uint256 _currentMarketRate) onlyCreator returns (uint256) {
184         currentMarketRate = _currentMarketRate;
185     }
186 
187     /**
188      * Set minimum ICO rate (ETH/dollar) in order to achieve max price of 1$ for 1 RCH.
189      * Will be called by creator before each ICO
190      *
191      * @param _minimumIcoRate current ETH/dollar rate at the market
192      */
193     function setMinimumIcoRate(uint256 _minimumIcoRate) onlyCreator returns (uint256) {
194         minimumIcoRate = _minimumIcoRate;
195     }
196 
197     /**
198      * Set humanity fund address
199      *
200      * @param _humanityFund Humanity fund address
201      */
202     function setHumanityFund(address _humanityFund) onlyCreator {
203         humanityFund = _humanityFund;
204     }
205 
206     /**
207      * Set buy back fund address
208      *
209      * @param _buyBackFund Bay back fund address
210      */
211     function setBuyBackFund(address _buyBackFund) onlyCreator {
212         buyBackFund = _buyBackFund;
213     }
214 
215     /**
216      * Get current rate at which will be issued tokens
217      *
218      * @return rate How many tokens will be issued for one ETH
219      */
220     function getRate() returns (uint256 rate) {
221         if (currentMarketRate * 12 / 10 < minimumIcoRate) {
222             return minimumIcoRate;
223         }
224 
225         return currentMarketRate * 12 / 10;
226     }
227 
228     /**
229      * Retrun pecentage of tokens owned by provided investor
230      *
231      * @param _investor address of investor
232      * @param exeptInIco ICO number that will be excluded from calculation (usually current ICO number)
233      * @return investor rate, 1000000 = 100%
234      */
235     function getInvestorTokenPercentage(address _investor, uint256 exeptInIco) returns (uint256 percentage) {
236         uint256 deductionInvestor = 0;
237         uint256 deductionIco = 0;
238 
239         if (exeptInIco >= 0) {
240             deductionInvestor = tokenBalancesPerIco[_investor][exeptInIco];
241             deductionIco = icoTokenIssued[exeptInIco];
242         }
243 
244         if (totalTokenIssued - deductionIco == 0) {
245             return 0;
246         }
247 
248         return 1000000 * (tokenBalances[_investor] - deductionInvestor) / (totalTokenIssued - deductionIco);
249     }
250 
251     /**
252      * Convert `_wei` to an amount in RICH using
253      * the current rate
254      *
255      * @param _wei amount of wei to convert
256      * @return The amount in RICH
257      */
258     function toRICH(uint256 _wei) returns (uint256 amount) {
259         uint256 rate = getRate();
260 
261         return _wei * rate * 10**8 / 1 ether; // 10**8 for 8 decimals
262     }
263 
264     /**
265      * Return ICO number (PreIco has index 0)
266      *
267      * @return ICO number
268      */
269     function getCurrentIcoNumber() returns (uint256 amount) {
270         uint256 timeBehind = now - start;
271         if (now < start) {
272             return 0;
273         }
274 
275         return 1 + ((timeBehind - (timeBehind % (icoPeriod + noIcoPeriod))) / (icoPeriod + noIcoPeriod));
276     }
277 
278     /**
279      * Update crowd sale stage based on current time and ICO periods
280      */
281     function updateState() {
282         uint256 timeBehind = now - start;
283         uint256 currentIcoNumber = getCurrentIcoNumber();
284 
285         if (icoTokenIssued[currentIcoNumber] >= maxIssuedTokensPerIco) {
286             stage = Stages.NoIco;
287             return;
288         }
289 
290         if (totalTokenIssued >= maxTotalSupply) {
291             stage = Stages.Ended;
292             return;
293         }
294 
295         if (now >= preIcoStart && now <= preIcoStart + preIcoPeriod) {
296             stage = Stages.PreIco;
297             return;
298         }
299 
300         if (now < start) {
301             stage = Stages.Countdown;
302             return;
303         }
304 
305         uint256 timeFromIcoStart = timeBehind - (currentIcoNumber - 1) * (icoPeriod + noIcoPeriod);
306 
307         if (timeFromIcoStart > icoPeriod) {
308             stage = Stages.NoIco;
309             return;
310         }
311 
312         if (timeFromIcoStart > icoPeriod / 2) {
313             stage = Stages.OpenIco;
314             return;
315         }
316 
317         stage = Stages.PriorityIco;
318     }
319 
320 
321     /**
322      * Transfer appropriate percentage of raised amount to the company address and humanity and buy back fund
323      */
324     function withdraw() onlyCreator {
325         uint256 ethBalance = this.balance;
326         uint256 amountToSend = ethBalance - 100000000;
327 
328         if (creatorWithdraw < maxCreatorWithdraw) {
329             if (amountToSend > maxCreatorWithdraw - creatorWithdraw) {
330                 amountToSend = maxCreatorWithdraw - creatorWithdraw;
331             }
332 
333             if (!creator.send(amountToSend)) {
334                 throw;
335             }
336 
337             creatorWithdraw += amountToSend;
338             return;
339         }
340 
341         uint256 ethForHumanityFund = amountToSend * percentageHumanityFund / 100;
342         uint256 ethForBuyBackFund = amountToSend * percentageBuyBackFund / 100;
343 
344         if (!humanityFund.send(ethForHumanityFund)) {
345             throw;
346         }
347 
348         if (!buyBackFund.send(ethForBuyBackFund)) {
349             throw;
350         }
351     }
352 
353     /**
354      * Add additional bonus tokens for subscribed investors
355      *
356      * @param investorAddress Address of investor
357      */
358     function sendSubscriptionBonus(address investorAddress) onlyCreator {
359         uint256 subscriptionBonus = tokenBalances[investorAddress] * bonusSubscription / 100;
360 
361         if (subsriptionBonusTokensIssued[investorAddress] < subscriptionBonus) {
362             uint256 toBeIssued = subscriptionBonus - subsriptionBonusTokensIssued[investorAddress];
363             if (!richToken.issue(investorAddress, toBeIssued)) {
364                 throw;
365             }
366 
367             subsriptionBonusTokensIssued[investorAddress] += toBeIssued;
368         }
369     }
370 
371     /**
372      * Receives Eth and issue RICH tokens to the sender
373      */
374     function () payable atStage(Stages.Ico) {
375         uint256 receivedEth = msg.value;
376 
377         if (receivedEth < minAcceptedEthAmount) {
378             throw;
379         }
380 
381         uint256 tokensToBeIssued = toRICH(receivedEth);
382         uint256 currentIco = getCurrentIcoNumber();
383 
384         //add bonus
385         tokensToBeIssued = tokensToBeIssued + (tokensToBeIssued * getPercentageBonusForIco(currentIco) / 100);
386 
387         if (tokensToBeIssued == 0 || icoTokenIssued[currentIco] + tokensToBeIssued > maxIssuedTokensPerIco) {
388             throw;
389         }
390 
391         if (stage == Stages.PriorityIco) {
392             uint256 alreadyBoughtInIco = tokenBalancesPerIco[msg.sender][currentIco];
393             uint256 canBuyTokensInThisIco = maxIssuedTokensPerIco * getInvestorTokenPercentage(msg.sender, currentIco) / 1000000;
394 
395             if (tokensToBeIssued > canBuyTokensInThisIco - alreadyBoughtInIco) {
396                 throw;
397             }
398         }
399 
400         if (!richToken.issue(msg.sender, tokensToBeIssued)) {
401             throw;
402         }
403 
404         icoTokenIssued[currentIco] += tokensToBeIssued;
405         totalTokenIssued += tokensToBeIssued;
406         balances[msg.sender] += receivedEth;
407         tokenBalances[msg.sender] += tokensToBeIssued;
408         tokenBalancesPerIco[msg.sender][currentIco] += tokensToBeIssued;
409     }
410 }