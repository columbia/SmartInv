1 pragma solidity ^0.4.25;
2 
3 /*
4 * https://smartwager.app 
5 * https://smartwager.app/en/ - english
6 * https://smartwager.app/ch/ - 中文
7 * https://smartwager.app/ru/ - русский
8 * 
9 * DISCORD - https://discord.gg/r5JTRE 
10 * Telegram News - https://t.me/smartwager
11 * Telegram Chat - https://t.me/smartwagermain
12 *
13 * Wager Chain Token Concept
14 *
15 * [✓] 8% Withdraw fee
16 * [✓] 15% Deposit fee
17 * [✓] 0% Token transfer
18 * [✓] Multi-level Refferal System - 10% from total purchase
19 *  *  [✓]  1st level 50% Refferal (5% from total purchase)
20 *  *  [✓]  2nd level 30% Refferal (3% from total purchase)
21 *  *  [✓]  3rd level 20% Refferal (2% from total purchase)
22 */
23 
24 contract SmartWagerToken {
25 
26     /*=================================
27     =            MODIFIERS            =
28     =================================*/
29 
30     modifier onlyBagholders {
31         require(myTokens() > 0);
32         _;
33     }
34 
35     modifier onlyStronghands {
36         require(myDividends(true) > 0);
37         _;
38     }
39 
40     /*==============================
41     =            EVENTS            =
42     ==============================*/
43 
44     event onTokenPurchase(
45         address indexed customerAddress,
46         uint256 incomingEthereum,
47         uint256 tokensMinted,
48         address indexed referredBy,
49         uint timestamp,
50         uint256 price
51     );
52 
53     event onTokenSell(
54         address indexed customerAddress,
55         uint256 tokensBurned,
56         uint256 ethereumEarned,
57         uint timestamp,
58         uint256 price
59     );
60 
61     event onReinvestment(
62         address indexed customerAddress,
63         uint256 ethereumReinvested,
64         uint256 tokensMinted
65     );
66 
67     event onWithdraw(
68         address indexed customerAddress,
69         uint256 ethereumWithdrawn
70     );
71 
72     event Transfer(
73         address indexed from,
74         address indexed to,
75         uint256 tokens
76     );
77 
78     event onRefferalUse(
79         address indexed refferer,
80         uint8  indexed level,
81         uint256 ethereumCollected,
82         address indexed customerAddress,
83         uint256 timestamp
84     );
85 
86     string public name = "Smart Wager Token";
87     string public symbol = "SMT";
88     uint8 constant public decimals = 18;
89     uint8 constant internal entryFee_ = 15;
90     uint8 constant internal exitFee_ = 8;
91     uint8 constant internal maxRefferalFee_ = 10; // 10% from total sum (lev1 - 5%, lev2 - 3%, lev3 - 2%)
92     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
93     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
94     uint256 constant internal magnitude = 2 ** 64;
95     uint256 public stakingRequirement = 50e18;
96     mapping(address => uint256) internal tokenBalanceLedger_;
97     mapping(address => uint256) internal referralBalance_;
98     mapping(address => int256) internal payoutsTo_;
99     uint256 internal tokenSupply_;
100     uint256 internal profitPerShare_;
101 
102     mapping(address => address) public stickyRef;
103 
104     function buy(address _referredBy) public payable {
105         purchaseInternal(msg.value, _referredBy);
106     }
107 
108     function() payable public {
109         purchaseInternal(msg.value, 0x0);
110     }
111 
112     function reinvest() onlyStronghands public {
113         uint256 _dividends = myDividends(false);
114         address _customerAddress = msg.sender;
115         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
116         _dividends += referralBalance_[_customerAddress];
117         referralBalance_[_customerAddress] = 0;
118         uint256 _tokens = purchaseTokens(_dividends, 0x0);
119         emit onReinvestment(_customerAddress, _dividends, _tokens);
120     }
121 
122     function exit() public {
123         address _customerAddress = msg.sender;
124         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
125         if (_tokens > 0) sell(_tokens);
126         withdraw();
127     }
128 
129     function withdraw() onlyStronghands public {
130         address _customerAddress = msg.sender;
131         uint256 _dividends = myDividends(false);
132         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
133         _dividends += referralBalance_[_customerAddress];
134         referralBalance_[_customerAddress] = 0;
135         _customerAddress.transfer(_dividends);
136         emit onWithdraw(_customerAddress, _dividends);
137     }
138 
139     function sell(uint256 _amountOfTokens) onlyBagholders public {
140         address _customerAddress = msg.sender;
141         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
142         uint256 _tokens = _amountOfTokens;
143         uint256 _ethereum = tokensToEthereum_(_tokens);
144         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
145         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
146 
147         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
148         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
149 
150         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
151         payoutsTo_[_customerAddress] -= _updatedPayouts;
152 
153         if (tokenSupply_ > 0) {
154             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
155         }
156         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
157     }
158 
159     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
160         // setup
161         address _customerAddress = msg.sender;
162 
163         // make sure we have the requested tokens
164         // also disables transfers until ambassador phase is over
165         // ( we dont want whale premines )
166         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
167 
168         // withdraw all outstanding dividends first
169         if(myDividends(true) > 0) withdraw();
170 
171         // exchange tokens
172         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
173         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
174 
175         // update dividend trackers
176         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
177         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
178 
179 
180         // fire event
181         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
182         return true;
183     }
184 
185 
186     function totalEthereumBalance() public view returns (uint256) {
187         return address(this).balance;
188     }
189 
190     function totalSupply() public view returns (uint256) {
191         return tokenSupply_;
192     }
193 
194     function myTokens() public view returns (uint256) {
195         address _customerAddress = msg.sender;
196         return balanceOf(_customerAddress);
197     }
198 
199     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
200         address _customerAddress = msg.sender;
201         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
202     }
203 
204     function balanceOf(address _customerAddress) public view returns (uint256) {
205         return tokenBalanceLedger_[_customerAddress];
206     }
207 
208     function dividendsOf(address _customerAddress) public view returns (uint256) {
209         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
210     }
211 
212     function sellPrice() public view returns (uint256) {
213         // our calculation relies on the token supply, so we need supply. Doh.
214         if (tokenSupply_ == 0) {
215             return tokenPriceInitial_ - tokenPriceIncremental_;
216         } else {
217             uint256 _ethereum = tokensToEthereum_(1e18);
218             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
219             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
220 
221             return _taxedEthereum;
222         }
223     }
224 
225     function buyPrice() public view returns (uint256) {
226         if (tokenSupply_ == 0) {
227             return tokenPriceInitial_ + tokenPriceIncremental_;
228         } else {
229             uint256 _ethereum = tokensToEthereum_(1e18);
230             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
231             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
232 
233             return _taxedEthereum;
234         }
235     }
236 
237     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
238         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
239         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
240         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
241 
242         return _amountOfTokens;
243     }
244 
245     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
246         require(_tokensToSell <= tokenSupply_);
247         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
248         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
249         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
250         return _taxedEthereum;
251     }
252 
253     /*==========================================
254     =            INTERNAL FUNCTIONS            =
255     ==========================================*/
256 
257     // Make sure we will send back excess if user sends more then 2 ether before 100 ETH in contract
258     function purchaseInternal(uint256 _incomingEthereum, address _referredBy)
259       internal
260       returns(uint256) {
261 
262       uint256 purchaseEthereum = _incomingEthereum;
263       uint256 excess;
264       if(purchaseEthereum > 2 ether) { // check if the transaction is over 2 ether
265           if (SafeMath.sub(address(this).balance, purchaseEthereum) <= 100 ether) { // if so check the contract is less then 100 ether
266               purchaseEthereum = 2 ether;
267               excess = SafeMath.sub(_incomingEthereum, purchaseEthereum);
268           }
269       }
270     
271       if (excess > 0) {
272         msg.sender.transfer(excess);
273       }
274     
275       purchaseTokens(purchaseEthereum, _referredBy);
276     }
277 
278     function handleRefferals(address _referredBy, uint _referralBonus, uint _undividedDividends) internal returns (uint){
279         uint _dividends = _undividedDividends;
280         address _level1Referrer = stickyRef[msg.sender];
281         
282         if (_level1Referrer == address(0x0)){
283             _level1Referrer = _referredBy;
284         }
285         // is the user referred by a masternode?
286         if(
287             // is this a referred purchase?
288             _level1Referrer != 0x0000000000000000000000000000000000000000 &&
289 
290             // no cheating!
291             _level1Referrer != msg.sender &&
292 
293             // does the referrer have at least X whole tokens?
294             // i.e is the referrer a godly chad masternode
295             tokenBalanceLedger_[_level1Referrer] >= stakingRequirement
296         ){
297             // wealth redistribution
298             if (stickyRef[msg.sender] == address(0x0)){
299                 stickyRef[msg.sender] = _level1Referrer;
300             }
301 
302             // level 1 refs - 50%
303             uint256 ethereumCollected =  _referralBonus/2;
304             referralBalance_[_level1Referrer] = SafeMath.add(referralBalance_[_level1Referrer], ethereumCollected);
305             _dividends = SafeMath.sub(_dividends, ethereumCollected);
306             emit onRefferalUse(_level1Referrer, 1, ethereumCollected, msg.sender, now);
307 
308             address _level2Referrer = stickyRef[_level1Referrer];
309 
310             if (_level2Referrer != address(0x0) && tokenBalanceLedger_[_level2Referrer] >= stakingRequirement){
311                 // level 2 refs - 30%
312                 ethereumCollected =  (_referralBonus*3)/10;
313                 referralBalance_[_level2Referrer] = SafeMath.add(referralBalance_[_level2Referrer], ethereumCollected);
314                 _dividends = SafeMath.sub(_dividends, ethereumCollected);
315                 emit onRefferalUse(_level2Referrer, 2, ethereumCollected, _level1Referrer, now);
316                 address _level3Referrer = stickyRef[_level2Referrer];
317 
318                 if (_level3Referrer != address(0x0) && tokenBalanceLedger_[_level3Referrer] >= stakingRequirement){
319                     //level 3 refs - 20%
320                     ethereumCollected =  (_referralBonus*2)/10;
321                     referralBalance_[_level3Referrer] = SafeMath.add(referralBalance_[_level3Referrer], ethereumCollected);
322                     _dividends = SafeMath.sub(_dividends, ethereumCollected);
323                     emit onRefferalUse(_level3Referrer, 3, ethereumCollected, _level2Referrer, now);
324                 }
325             }
326         }
327         return _dividends;
328     }
329 
330     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) internal returns (uint256) {
331         address _customerAddress = msg.sender;
332         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
333         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_incomingEthereum, maxRefferalFee_), 100);
334         uint256 _dividends = handleRefferals(_referredBy, _referralBonus, _undividedDividends);
335         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
336         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
337         uint256 _fee = _dividends * magnitude;
338 
339         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
340 
341         if (tokenSupply_ > 0) {
342             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
343             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
344             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
345         } else {
346             tokenSupply_ = _amountOfTokens;
347         }
348 
349         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
350         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
351         payoutsTo_[_customerAddress] += _updatedPayouts;
352         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
353 
354         return _amountOfTokens;
355     }
356 
357     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
358         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
359         uint256 _tokensReceived =
360             (
361                 (
362                     SafeMath.sub(
363                         (sqrt
364                             (
365                                 (_tokenPriceInitial ** 2)
366                                 +
367                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
368                                 +
369                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
370                                 +
371                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
372                             )
373                         ), _tokenPriceInitial
374                     )
375                 ) / (tokenPriceIncremental_)
376             ) - (tokenSupply_);
377 
378         return _tokensReceived;
379     }
380 
381     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
382         uint256 tokens_ = (_tokens + 1e18);
383         uint256 _tokenSupply = (tokenSupply_ + 1e18);
384         uint256 _etherReceived =
385             (
386                 SafeMath.sub(
387                     (
388                         (
389                             (
390                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
391                             ) - tokenPriceIncremental_
392                         ) * (tokens_ - 1e18)
393                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
394                 )
395                 / 1e18);
396 
397         return _etherReceived;
398     }
399 
400     function sqrt(uint256 x) internal pure returns (uint256 y) {
401         uint256 z = (x + 1) / 2;
402         y = x;
403 
404         while (z < y) {
405             y = z;
406             z = (x / z + z) / 2;
407         }
408     }
409 
410 
411 }
412 
413 library SafeMath {
414     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
415         if (a == 0) {
416             return 0;
417         }
418         uint256 c = a * b;
419         assert(c / a == b);
420         return c;
421     }
422 
423     function div(uint256 a, uint256 b) internal pure returns (uint256) {
424         uint256 c = a / b;
425         return c;
426     }
427 
428     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
429         assert(b <= a);
430         return a - b;
431     }
432 
433     function add(uint256 a, uint256 b) internal pure returns (uint256) {
434         uint256 c = a + b;
435         assert(c >= a);
436         return c;
437     }
438 }