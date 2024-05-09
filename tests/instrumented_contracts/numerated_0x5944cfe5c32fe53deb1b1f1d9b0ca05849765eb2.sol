1 pragma solidity ^0.4.25;
2 
3 /*
4 * https://ethcapital.fund
5 *
6 * DISCORD - https://discord.gg/pj5zFwc
7 * Telegram News - https://t.me/ethcapitalfund
8 *
9 * ETH Capital Fund Concept
10 *
11 * [✓] 20% Withdraw fee
12 * [✓] 20% Deposit fee
13 * [✓] 0% Token transfer
14 * [✓] Multi-level Refferal System - 10% from total purchase
15 *  *  [✓]  1st level 50% Refferal (5% from total purchase)
16 *  *  [✓]  2nd level 30% Refferal (3% from total purchase)
17 *  *  [✓]  3rd level 20% Refferal (2% from total purchase)
18 */
19 
20 contract ETHCapitalFund {
21 
22     /*=================================
23     =            MODIFIERS            =
24     =================================*/
25 
26     modifier onlyBagholders {
27         require(myTokens() > 0);
28         _;
29     }
30 
31     modifier onlyStronghands {
32         require(myDividends(true) > 0);
33         _;
34     }
35 
36     // administrators can:
37     // -> disable initial stage
38     // they CANNOT:
39     // -> take funds
40     // -> disable withdrawals
41     // -> kill the contract
42     // -> change the price of tokens
43     modifier onlyAdministrator(){
44         require(administrators[msg.sender]);
45         _;
46     }
47 
48     // ensures that the first tokens in the contract will be equally distributed
49     // meaning, no divine dump will be ever possible
50     // result: healthy longevity.
51     modifier antiEarlyWhale(uint256 _amountOfEthereum){
52       address _customerAddress = msg.sender;
53 
54       // are we still in the vulnerable phase?
55       // if so, enact anti early whale protocol
56       if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
57           require(
58               // is the customer in the ambassador list?
59               ambassadors_[_customerAddress] == true &&
60 
61               // does the customer purchase exceed the max ambassador quota?
62               (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
63 
64           );
65 
66           // updated the accumulated quota
67           ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
68 
69           // execute
70           _;
71       } else {
72           // in case the ether count drops low, the ambassador phase won't reinitiate
73           onlyAmbassadors = false;
74           _;
75       }
76 
77     }
78 
79 
80 
81     /*==============================
82     =            EVENTS            =
83     ==============================*/
84 
85     event onTokenPurchase(
86         address indexed customerAddress,
87         uint256 incomingEthereum,
88         uint256 tokensMinted,
89         address indexed referredBy,
90         uint timestamp,
91         uint256 price
92     );
93 
94     event onTokenSell(
95         address indexed customerAddress,
96         uint256 tokensBurned,
97         uint256 ethereumEarned,
98         uint timestamp,
99         uint256 price
100     );
101 
102     event onReinvestment(
103         address indexed customerAddress,
104         uint256 ethereumReinvested,
105         uint256 tokensMinted
106     );
107 
108     event onWithdraw(
109         address indexed customerAddress,
110         uint256 ethereumWithdrawn
111     );
112 
113     event Transfer(
114         address indexed from,
115         address indexed to,
116         uint256 tokens
117     );
118 
119     event onRefferalUse(
120         address indexed refferer,
121         uint8  indexed level,
122         uint256 ethereumCollected,
123         address indexed customerAddress,
124         uint256 timestamp
125     );
126 
127     string public name = "Ether Capital Fund";
128     string public symbol = "ECF";
129     uint8 constant public decimals = 18;
130     uint8 constant internal entryFee_ = 20;
131     uint8 constant internal exitFee_ = 20;
132     uint8 constant internal maxRefferalFee_ = 10; // 10% from total sum (lev1 - 5%, lev2 - 3%, lev3 - 2%)
133     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
134     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
135     uint256 constant internal magnitude = 2 ** 64;
136     uint256 public stakingRequirement = 50e18;
137     mapping(address => uint256) internal tokenBalanceLedger_;
138     mapping(address => uint256) internal referralBalance_;
139     mapping(address => int256) internal payoutsTo_;
140     uint256 internal tokenSupply_;
141     uint256 internal profitPerShare_;
142 
143     mapping(address => address) public stickyRef;
144 
145     mapping(address => bool) public administrators;
146     // ambassador program
147     mapping(address => bool) internal ambassadors_;
148     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
149     uint256 constant internal ambassadorMaxPurchase_ = 100 ether;
150     uint256 constant internal ambassadorQuota_ = 100 ether;
151     bool public onlyAmbassadors = true;
152 
153     constructor() public {
154         // add administrators here
155         administrators[0x19647aC87C5F932d04c91DfF2B8Ed325E13de6Ca] = true;
156 
157         // add the ambassadors here.
158         ambassadors_[0x82293FD3bAaE472Cc0C9F914918780962383294D] = true;
159     }
160 
161     function buy(address _referredBy) public payable {
162         purchaseTokens(msg.value, _referredBy);
163     }
164 
165     function() payable public {
166         purchaseTokens(msg.value, 0x0);
167     }
168 
169     function reinvest() onlyStronghands public {
170         uint256 _dividends = myDividends(false);
171         address _customerAddress = msg.sender;
172         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
173         _dividends += referralBalance_[_customerAddress];
174         referralBalance_[_customerAddress] = 0;
175         uint256 _tokens = purchaseTokens(_dividends, 0x0);
176         emit onReinvestment(_customerAddress, _dividends, _tokens);
177     }
178 
179     function exit() public {
180         address _customerAddress = msg.sender;
181         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
182         if (_tokens > 0) sell(_tokens);
183         withdraw();
184     }
185 
186     function withdraw() onlyStronghands public {
187         address _customerAddress = msg.sender;
188         uint256 _dividends = myDividends(false);
189         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
190         _dividends += referralBalance_[_customerAddress];
191         referralBalance_[_customerAddress] = 0;
192         _customerAddress.transfer(_dividends);
193         emit onWithdraw(_customerAddress, _dividends);
194     }
195 
196     function sell(uint256 _amountOfTokens) onlyBagholders public {
197         address _customerAddress = msg.sender;
198         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
199         uint256 _tokens = _amountOfTokens;
200         uint256 _ethereum = tokensToEthereum_(_tokens);
201         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
202         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
203 
204         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
205         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
206 
207         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
208         payoutsTo_[_customerAddress] -= _updatedPayouts;
209 
210         if (tokenSupply_ > 0) {
211             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
212         }
213         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
214     }
215 
216     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
217         // setup
218         address _customerAddress = msg.sender;
219 
220         // make sure we have the requested tokens
221         // also disables transfers until ambassador phase is over
222         // ( we dont want whale premines )
223         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
224 
225         // withdraw all outstanding dividends first
226         if(myDividends(true) > 0) withdraw();
227 
228         // exchange tokens
229         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
230         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
231 
232         // update dividend trackers
233         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
234         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
235 
236 
237         // fire event
238         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
239         return true;
240     }
241 
242     /**
243     * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
244     */
245     function disableInitialStage()
246         onlyAdministrator()
247         public
248     {
249         onlyAmbassadors = false;
250     }
251 
252 
253     function totalEthereumBalance() public view returns (uint256) {
254         return address(this).balance;
255     }
256 
257     function totalSupply() public view returns (uint256) {
258         return tokenSupply_;
259     }
260 
261     function myTokens() public view returns (uint256) {
262         address _customerAddress = msg.sender;
263         return balanceOf(_customerAddress);
264     }
265 
266     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
267         address _customerAddress = msg.sender;
268         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
269     }
270 
271     function balanceOf(address _customerAddress) public view returns (uint256) {
272         return tokenBalanceLedger_[_customerAddress];
273     }
274 
275     function dividendsOf(address _customerAddress) public view returns (uint256) {
276         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
277     }
278 
279     function sellPrice() public view returns (uint256) {
280         // our calculation relies on the token supply, so we need supply. Doh.
281         if (tokenSupply_ == 0) {
282             return tokenPriceInitial_ - tokenPriceIncremental_;
283         } else {
284             uint256 _ethereum = tokensToEthereum_(1e18);
285             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
286             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
287 
288             return _taxedEthereum;
289         }
290     }
291 
292     function buyPrice() public view returns (uint256) {
293         if (tokenSupply_ == 0) {
294             return tokenPriceInitial_ + tokenPriceIncremental_;
295         } else {
296             uint256 _ethereum = tokensToEthereum_(1e18);
297             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
298             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
299 
300             return _taxedEthereum;
301         }
302     }
303 
304     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
305         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
306         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
307         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
308 
309         return _amountOfTokens;
310     }
311 
312     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
313         require(_tokensToSell <= tokenSupply_);
314         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
315         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
316         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
317         return _taxedEthereum;
318     }
319 
320     /*==========================================
321     =            INTERNAL FUNCTIONS            =
322     ==========================================*/
323 
324     function handleRefferals(address _referredBy, uint _referralBonus, uint _undividedDividends) internal returns (uint){
325         uint _dividends = _undividedDividends;
326         address _level1Referrer = stickyRef[msg.sender];
327 
328         if (_level1Referrer == address(0x0)){
329             _level1Referrer = _referredBy;
330         }
331         // is the user referred by a masternode?
332         if(
333             // is this a referred purchase?
334             _level1Referrer != 0x0000000000000000000000000000000000000000 &&
335 
336             // no cheating!
337             _level1Referrer != msg.sender &&
338 
339             // does the referrer have at least X whole tokens?
340             // i.e is the referrer a godly chad masternode
341             tokenBalanceLedger_[_level1Referrer] >= stakingRequirement
342         ){
343             // wealth redistribution
344             if (stickyRef[msg.sender] == address(0x0)){
345                 stickyRef[msg.sender] = _level1Referrer;
346             }
347 
348             // level 1 refs - 50%
349             uint256 ethereumCollected =  _referralBonus/2;
350             referralBalance_[_level1Referrer] = SafeMath.add(referralBalance_[_level1Referrer], ethereumCollected);
351             _dividends = SafeMath.sub(_dividends, ethereumCollected);
352             emit onRefferalUse(_level1Referrer, 1, ethereumCollected, msg.sender, now);
353 
354             address _level2Referrer = stickyRef[_level1Referrer];
355 
356             if (_level2Referrer != address(0x0) && tokenBalanceLedger_[_level2Referrer] >= stakingRequirement){
357                 // level 2 refs - 30%
358                 ethereumCollected =  (_referralBonus*3)/10;
359                 referralBalance_[_level2Referrer] = SafeMath.add(referralBalance_[_level2Referrer], ethereumCollected);
360                 _dividends = SafeMath.sub(_dividends, ethereumCollected);
361                 emit onRefferalUse(_level2Referrer, 2, ethereumCollected, _level1Referrer, now);
362                 address _level3Referrer = stickyRef[_level2Referrer];
363 
364                 if (_level3Referrer != address(0x0) && tokenBalanceLedger_[_level3Referrer] >= stakingRequirement){
365                     //level 3 refs - 20%
366                     ethereumCollected =  (_referralBonus*2)/10;
367                     referralBalance_[_level3Referrer] = SafeMath.add(referralBalance_[_level3Referrer], ethereumCollected);
368                     _dividends = SafeMath.sub(_dividends, ethereumCollected);
369                     emit onRefferalUse(_level3Referrer, 3, ethereumCollected, _level2Referrer, now);
370                 }
371             }
372         }
373         return _dividends;
374     }
375 
376     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
377         antiEarlyWhale(_incomingEthereum)
378         internal
379         returns (uint256) {
380         address _customerAddress = msg.sender;
381         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
382         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_incomingEthereum, maxRefferalFee_), 100);
383         uint256 _dividends = handleRefferals(_referredBy, _referralBonus, _undividedDividends);
384         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
385         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
386         uint256 _fee = _dividends * magnitude;
387 
388         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
389 
390         if (tokenSupply_ > 0) {
391             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
392             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
393             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
394         } else {
395             tokenSupply_ = _amountOfTokens;
396         }
397 
398         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
399         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
400         payoutsTo_[_customerAddress] += _updatedPayouts;
401         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
402 
403         return _amountOfTokens;
404     }
405 
406     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
407         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
408         uint256 _tokensReceived =
409             (
410                 (
411                     SafeMath.sub(
412                         (sqrt
413                             (
414                                 (_tokenPriceInitial ** 2)
415                                 +
416                                 (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
417                                 +
418                                 ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
419                                 +
420                                 (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
421                             )
422                         ), _tokenPriceInitial
423                     )
424                 ) / (tokenPriceIncremental_)
425             ) - (tokenSupply_);
426 
427         return _tokensReceived;
428     }
429 
430     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
431         uint256 tokens_ = (_tokens + 1e18);
432         uint256 _tokenSupply = (tokenSupply_ + 1e18);
433         uint256 _etherReceived =
434             (
435                 SafeMath.sub(
436                     (
437                         (
438                             (
439                                 tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
440                             ) - tokenPriceIncremental_
441                         ) * (tokens_ - 1e18)
442                     ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
443                 )
444                 / 1e18);
445 
446         return _etherReceived;
447     }
448 
449     function sqrt(uint256 x) internal pure returns (uint256 y) {
450         uint256 z = (x + 1) / 2;
451         y = x;
452 
453         while (z < y) {
454             y = z;
455             z = (x / z + z) / 2;
456         }
457     }
458 
459 
460 }
461 
462 library SafeMath {
463     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
464         if (a == 0) {
465             return 0;
466         }
467         uint256 c = a * b;
468         assert(c / a == b);
469         return c;
470     }
471 
472     function div(uint256 a, uint256 b) internal pure returns (uint256) {
473         uint256 c = a / b;
474         return c;
475     }
476 
477     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
478         assert(b <= a);
479         return a - b;
480     }
481 
482     function add(uint256 a, uint256 b) internal pure returns (uint256) {
483         uint256 c = a + b;
484         assert(c >= a);
485         return c;
486     }
487 }