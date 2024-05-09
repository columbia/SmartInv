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
54     uint256 public currentMarketRate = 400; // Current market price RICH/ETH. Will be updated before each ico
55     uint256 public maximumIcoRate = 330; // Maximum rate at wich will be issued RICH token
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
188      * Set humanity fund address
189      *
190      * @param _humanityFund Humanity fund address
191      */
192     function setHumanityFund(address _humanityFund) onlyCreator {
193         humanityFund = _humanityFund;
194     }
195 
196     /**
197      * Set buy back fund address
198      *
199      * @param _buyBackFund Bay back fund address
200      */
201     function setBuyBackFund(address _buyBackFund) onlyCreator {
202         buyBackFund = _buyBackFund;
203     }
204 
205     /**
206      * Get current rate at which will be issued tokens
207      *
208      * @return rate How many tokens will be issued for one ETH
209      */
210     function getRate() returns (uint256 rate) {
211         if (currentMarketRate * 8 / 10 > maximumIcoRate) {
212             return maximumIcoRate;
213         }
214 
215         return currentMarketRate * 8 / 10;
216     }
217 
218     /**
219      * Retrun pecentage of tokens owned by provided investor
220      *
221      * @param _investor address of investor
222      * @param exeptInIco ICO number that will be excluded from calculation (usually current ICO number)
223      * @return investor rate, 1000000 = 100%
224      */
225     function getInvestorTokenPercentage(address _investor, uint256 exeptInIco) returns (uint256 percentage) {
226         uint256 deductionInvestor = 0;
227         uint256 deductionIco = 0;
228 
229         if (exeptInIco >= 0) {
230             deductionInvestor = tokenBalancesPerIco[_investor][exeptInIco];
231             deductionIco = icoTokenIssued[exeptInIco];
232         }
233 
234         if (totalTokenIssued - deductionIco == 0) {
235             return 0;
236         }
237 
238         return 1000000 * (tokenBalances[_investor] - deductionInvestor) / (totalTokenIssued - deductionIco);
239     }
240 
241     /**
242      * Convert `_wei` to an amount in RICH using
243      * the current rate
244      *
245      * @param _wei amount of wei to convert
246      * @return The amount in RICH
247      */
248     function toRICH(uint256 _wei) returns (uint256 amount) {
249         uint256 rate = getRate();
250 
251         return _wei * rate * 10**8 / 1 ether; // 10**8 for 8 decimals
252     }
253 
254     /**
255      * Return ICO number (PreIco has index 0)
256      *
257      * @return ICO number
258      */
259     function getCurrentIcoNumber() returns (uint256 amount) {
260         uint256 timeBehind = now - start;
261         if (now < start) {
262             return 0;
263         }
264 
265         return 1 + ((timeBehind - (timeBehind % (icoPeriod + noIcoPeriod))) / (icoPeriod + noIcoPeriod));
266     }
267 
268     /**
269      * Update crowd sale stage based on current time and ICO periods
270      */
271     function updateState() {
272         uint256 timeBehind = now - start;
273         uint256 currentIcoNumber = getCurrentIcoNumber();
274 
275         if (icoTokenIssued[currentIcoNumber] >= maxIssuedTokensPerIco) {
276             stage = Stages.NoIco;
277             return;
278         }
279 
280         if (totalTokenIssued >= maxTotalSupply) {
281             stage = Stages.Ended;
282             return;
283         }
284 
285         if (now >= preIcoStart && now <= preIcoStart + preIcoPeriod) {
286             stage = Stages.PreIco;
287             return;
288         }
289 
290         if (now < start) {
291             stage = Stages.Countdown;
292             return;
293         }
294 
295         uint256 timeFromIcoStart = timeBehind - (currentIcoNumber - 1) * (icoPeriod + noIcoPeriod);
296 
297         if (timeFromIcoStart > icoPeriod) {
298             stage = Stages.NoIco;
299             return;
300         }
301 
302         if (timeFromIcoStart > icoPeriod / 2) {
303             stage = Stages.OpenIco;
304             return;
305         }
306 
307         stage = Stages.PriorityIco;
308     }
309 
310 
311     /**
312      * Transfer appropriate percentage of raised amount to the company address and humanity and buy back fund
313      */
314     function withdraw() onlyCreator {
315         uint256 ethBalance = this.balance;
316         uint256 amountToSend = ethBalance - 100000000;
317 
318         if (creatorWithdraw < maxCreatorWithdraw) {
319             if (amountToSend > maxCreatorWithdraw - creatorWithdraw) {
320                 amountToSend = maxCreatorWithdraw - creatorWithdraw;
321             }
322 
323             if (!creator.send(amountToSend)) {
324                 throw;
325             }
326 
327             creatorWithdraw += amountToSend;
328             return;
329         }
330 
331         uint256 ethForHumanityFund = amountToSend * percentageHumanityFund / 100;
332         uint256 ethForBuyBackFund = amountToSend * percentageBuyBackFund / 100;
333 
334         if (!humanityFund.send(ethForHumanityFund)) {
335             throw;
336         }
337 
338         if (!buyBackFund.send(ethForBuyBackFund)) {
339             throw;
340         }
341     }
342 
343     /**
344      * Add additional bonus tokens for subscribed investors
345      *
346      * @param investorAddress Address of investor
347      */
348     function sendSubscriptionBonus(address investorAddress) onlyCreator {
349         uint256 subscriptionBonus = tokenBalances[investorAddress] * bonusSubscription / 100;
350 
351         if (subsriptionBonusTokensIssued[investorAddress] < subscriptionBonus) {
352             uint256 toBeIssued = subscriptionBonus - subsriptionBonusTokensIssued[investorAddress];
353             if (!richToken.issue(investorAddress, toBeIssued)) {
354                 throw;
355             }
356 
357             subsriptionBonusTokensIssued[investorAddress] += toBeIssued;
358         }
359     }
360 
361     /**
362      * Receives Eth and issue RICH tokens to the sender
363      */
364     function () payable atStage(Stages.Ico) {
365         uint256 receivedEth = msg.value;
366 
367         if (receivedEth < minAcceptedEthAmount) {
368             throw;
369         }
370 
371         uint256 tokensToBeIssued = toRICH(receivedEth);
372         uint256 currentIco = getCurrentIcoNumber();
373 
374         //add bonus
375         tokensToBeIssued = tokensToBeIssued + (tokensToBeIssued * getPercentageBonusForIco(currentIco) / 100);
376 
377         if (tokensToBeIssued == 0 || icoTokenIssued[currentIco] + tokensToBeIssued > maxIssuedTokensPerIco) {
378             throw;
379         }
380 
381         if (stage == Stages.PriorityIco) {
382             uint256 alreadyBoughtInIco = tokenBalancesPerIco[msg.sender][currentIco];
383             uint256 canBuyTokensInThisIco = maxIssuedTokensPerIco * getInvestorTokenPercentage(msg.sender, currentIco) / 1000000;
384 
385             if (tokensToBeIssued > canBuyTokensInThisIco - alreadyBoughtInIco) {
386                 throw;
387             }
388         }
389 
390         if (!richToken.issue(msg.sender, tokensToBeIssued)) {
391             throw;
392         }
393 
394         icoTokenIssued[currentIco] += tokensToBeIssued;
395         totalTokenIssued += tokensToBeIssued;
396         balances[msg.sender] += receivedEth;
397         tokenBalances[msg.sender] += tokensToBeIssued;
398         tokenBalancesPerIco[msg.sender][currentIco] += tokensToBeIssued;
399     }
400 }