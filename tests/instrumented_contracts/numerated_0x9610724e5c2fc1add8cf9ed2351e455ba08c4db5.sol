1 pragma solidity ^0.4.24;
2 
3 /***
4  * https://cryptox.market
5  * 
6  *
7  *
8  * 10 % entry fee
9  * 30 % to masternode referrals
10  * 0 % transfer fee
11  * Exit fee starts at 50% from contract start
12  * Exit fee decreases over 30 days  until 3%
13  * Stays at 3% forever, thereby allowing short trades.
14  */
15 contract CryptoXchange {
16 
17    
18 
19     
20     modifier onlyBagholders {
21         require(myTokens() > 0);
22         _;
23     }
24 
25     
26     modifier onlyStronghands {
27         require(myDividends(true) > 0);
28         _;
29     }
30 
31     
32     modifier notGasbag() {
33       require(tx.gasprice < 200999999999);
34       _;
35     }
36 
37     
38     modifier antiEarlyWhale {
39         if (address(this).balance  -msg.value < whaleBalanceLimit){
40           require(msg.value <= maxEarlyStake);
41         }
42         if (depositCount_ == 0){
43           require(ambassadors_[msg.sender] && msg.value == 1 ether);
44         }else
45         if (depositCount_ < 1){
46           require(ambassadors_[msg.sender] && msg.value == 1 ether);
47         }else
48         if (depositCount_ == 2 || depositCount_==3){
49           require(ambassadors_[msg.sender] && msg.value == 1 ether);
50         }
51         _;
52     }
53 
54     
55     modifier isControlled() {
56       require(isPremine() || isStarted());
57       _;
58     }
59 
60     
61 
62     event onTokenPurchase(
63         address indexed customerAddress,
64         uint256 incomingEthereum,
65         uint256 tokensMinted,
66         address indexed referredBy,
67         uint timestamp,
68         uint256 price
69     );
70 
71     event onTokenSell(
72         address indexed customerAddress,
73         uint256 tokensBurned,
74         uint256 ethereumEarned,
75         uint timestamp,
76         uint256 price
77     );
78 
79     event onReinvestment(
80         address indexed customerAddress,
81         uint256 ethereumReinvested,
82         uint256 tokensMinted
83     );
84 
85     event onWithdraw(
86         address indexed customerAddress,
87         uint256 ethereumWithdrawn
88     );
89 
90     // ERC20
91     event Transfer(
92         address indexed from,
93         address indexed to,
94         uint256 tokens
95     );
96 
97 
98     
99 
100     string public name = "CryptoX";
101     string public symbol = "CryptoX";
102     uint8 constant public decimals = 18;
103 
104     
105     uint8 constant internal entryFee_ = 10;
106 
107    
108     uint8 constant internal startExitFee_ = 50;
109 
110     
111     uint8 constant internal finalExitFee_ = 3;
112 
113     
114     uint256 constant internal exitFeeFallDuration_ = 30 days;
115 
116    
117     uint8 constant internal refferalFee_ = 30;
118 
119     
120     uint256 constant internal tokenPriceInitial_ = 0.00000001 ether;
121     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
122 
123     uint256 constant internal magnitude = 2 ** 64;
124 
125     
126     uint256 public stakingRequirement = 100e18;
127 
128     
129     uint256 public maxEarlyStake = 5 ether;
130     uint256 public whaleBalanceLimit = 50 ether;
131 
132     
133     address public owner;
134 
135     
136     uint256 public startTime = 0; 
137     
138     address promo1 = 0x54efb8160a4185cb5a0c86eb2abc0f1fcf4c3d07;
139     address promo2 = 0x41FE3738B503cBaFD01C1Fd8DD66b7fE6Ec11b01;
140    
141 
142     
143     mapping(address => uint256) internal tokenBalanceLedger_;
144     mapping(address => uint256) internal referralBalance_;
145     mapping(address => uint256) internal bonusBalance_;
146     mapping(address => int256) internal payoutsTo_;
147     uint256 internal tokenSupply_;
148     uint256 internal profitPerShare_;
149     uint256 public depositCount_;
150 
151     mapping(address => bool) internal ambassadors_;
152 
153     
154 
155    constructor () public {
156 
157      //Marketing Fund
158      ambassadors_[msg.sender]=true;
159      //1
160      ambassadors_[0x3f2cc2a7c15d287dd4d0614df6338e2414d5935a]=true;
161      //2
162      ambassadors_[0x41FE3738B503cBaFD01C1Fd8DD66b7fE6Ec11b01]=true;
163      //3
164      ambassadors_[0x0f238601e6b61bf4abf9d34fe846c108da38936c]=true;
165     
166      owner = msg.sender;
167    }
168 
169 
170 
171     function setStartTime(uint256 _startTime) public {
172       require(msg.sender==owner && !isStarted() && now < _startTime);
173       startTime = _startTime;
174     }
175 
176 
177     function buy(address _referredBy) antiEarlyWhale notGasbag isControlled public payable  returns (uint256) {
178         purchaseTokens(msg.value, _referredBy , msg.sender);
179         uint256 getmsgvalue = msg.value / 20;
180         promo1.transfer(getmsgvalue);
181         promo2.transfer(getmsgvalue);
182     }
183 
184 
185     function buyFor(address _referredBy, address _customerAddress) antiEarlyWhale notGasbag isControlled public payable returns (uint256) {
186         purchaseTokens(msg.value, _referredBy , _customerAddress);
187         uint256 getmsgvalue = msg.value / 20;
188         promo1.transfer(getmsgvalue);
189         promo2.transfer(getmsgvalue);
190     }
191 
192 
193     function() antiEarlyWhale notGasbag isControlled payable public {
194         purchaseTokens(msg.value, 0x0 , msg.sender);
195         uint256 getmsgvalue = msg.value / 20;
196         promo1.transfer(getmsgvalue);
197         promo2.transfer(getmsgvalue);
198     }
199 
200 
201     function reinvest() onlyStronghands public {
202     
203         uint256 _dividends = myDividends(false); 
204 
205         
206         address _customerAddress = msg.sender;
207         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
208 
209         
210         _dividends += referralBalance_[_customerAddress];
211         referralBalance_[_customerAddress] = 0;
212 
213         
214         uint256 _tokens = purchaseTokens(_dividends, 0x0 , _customerAddress);
215 
216         
217         emit onReinvestment(_customerAddress, _dividends, _tokens);
218     }
219 
220 
221     function exit() public {
222         
223         address _customerAddress = msg.sender;
224         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
225         if (_tokens > 0) sell(_tokens);
226 
227         
228         withdraw();
229     }
230 
231 
232     function withdraw() onlyStronghands public {
233         
234         address _customerAddress = msg.sender;
235         uint256 _dividends = myDividends(false); 
236 
237         
238         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
239 
240         
241         _dividends += referralBalance_[_customerAddress];
242         referralBalance_[_customerAddress] = 0;
243 
244         
245         _customerAddress.transfer(_dividends);
246 
247         
248         emit onWithdraw(_customerAddress, _dividends);
249     }
250 
251    
252     function sell(uint256 _amountOfTokens) onlyBagholders public {
253        
254         address _customerAddress = msg.sender;
255         
256         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
257         uint256 _tokens = _amountOfTokens;
258         uint256 _ethereum = tokensToEthereum_(_tokens);
259         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
260         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
261 
262         
263         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
264         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
265 
266         
267         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
268         payoutsTo_[_customerAddress] -= _updatedPayouts;
269 
270         
271         if (tokenSupply_ > 0) {
272             
273             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
274         }
275 
276         
277         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
278     }
279 
280 
281     
282     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
283         
284         address _customerAddress = msg.sender;
285 
286         
287         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
288 
289         
290         if (myDividends(true) > 0) {
291             withdraw();
292         }
293 
294         
295         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
296         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
297 
298         
299         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
300         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
301 
302         
303         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
304 
305         
306         return true;
307     }
308 
309 
310   
311   
312     function totalEthereumBalance() public view returns (uint256) {
313         return address(this).balance;
314     }
315 
316    
317     function totalSupply() public view returns (uint256) {
318         return tokenSupply_;
319     }
320 
321    
322     function myTokens() public view returns (uint256) {
323         address _customerAddress = msg.sender;
324         return balanceOf(_customerAddress);
325     }
326 
327 
328     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
329         address _customerAddress = msg.sender;
330         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
331     }
332 
333     
334     function balanceOf(address _customerAddress) public view returns (uint256) {
335         return tokenBalanceLedger_[_customerAddress];
336     }
337 
338     
339     function dividendsOf(address _customerAddress) public view returns (uint256) {
340         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
341     }
342 
343     
344     function sellPrice() public view returns (uint256) {
345         
346         if (tokenSupply_ == 0) {
347             return tokenPriceInitial_ - tokenPriceIncremental_;
348         } else {
349             uint256 _ethereum = tokensToEthereum_(1e18);
350             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
351             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
352 
353             return _taxedEthereum;
354         }
355     }
356 
357     
358     function buyPrice() public view returns (uint256) {
359         
360         if (tokenSupply_ == 0) {
361             return tokenPriceInitial_ + tokenPriceIncremental_;
362         } else {
363             uint256 _ethereum = tokensToEthereum_(1e18);
364             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
365             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
366 
367             return _taxedEthereum;
368         }
369     }
370 
371    
372     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
373         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
374         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
375         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
376         return _amountOfTokens;
377     }
378 
379     
380     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
381         require(_tokensToSell <= tokenSupply_);
382         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
383         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
384         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
385         return _taxedEthereum;
386     }
387 
388 
389     function calculateUntaxedEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
390         require(_tokensToSell <= tokenSupply_);
391         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
392         //uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
393         //uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
394         return _ethereum;
395     }
396 
397 
398     
399     function exitFee() public view returns (uint8) {
400         if (startTime==0){
401            return startExitFee_;
402         }
403         if ( now < startTime) {
404           return 0;
405         }
406         uint256 secondsPassed = now - startTime;
407         if (secondsPassed >= exitFeeFallDuration_) {
408             return finalExitFee_;
409         }
410         uint8 totalChange = startExitFee_ - finalExitFee_;
411         uint8 currentChange = uint8(totalChange * secondsPassed / exitFeeFallDuration_);
412         uint8 currentFee = startExitFee_- currentChange;
413         return currentFee;
414     }
415 
416     
417     function isPremine() public view returns (bool) {
418       return depositCount_<=3;
419     }
420 
421     
422     function isStarted() public view returns (bool) {
423       return startTime!=0 && now > startTime;
424     }
425 
426    
427     function purchaseTokens(uint256 _incomingEthereum, address _referredBy , address _customerAddress) internal returns (uint256) {
428         
429         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
430         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
431         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
432         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
433         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
434         uint256 _fee = _dividends * magnitude;
435 
436         
437         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
438 
439         
440         if (
441             
442             _referredBy != 0x0000000000000000000000000000000000000000 &&
443 
444             
445             _referredBy != _customerAddress &&
446 
447             
448             tokenBalanceLedger_[_referredBy] >= stakingRequirement
449         ) {
450             
451             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
452         } else {
453             
454             _dividends = SafeMath.add(_dividends, _referralBonus);
455             _fee = _dividends * magnitude;
456         }
457 
458         
459         if (tokenSupply_ > 0) {
460             
461             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
462 
463             
464             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
465 
466             
467             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
468         } else {
469             
470             tokenSupply_ = _amountOfTokens;
471         }
472 
473         
474         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
475 
476         
477         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
478         payoutsTo_[_customerAddress] += _updatedPayouts;
479 
480         
481         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
482 
483         
484         depositCount_++;
485         return _amountOfTokens;
486     }
487 
488    
489     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
490         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
491         uint256 _tokensReceived =
492          (
493             (
494                 // underflow attempts BTFO
495                 SafeMath.sub(
496                     (sqrt
497                         (
498                             (_tokenPriceInitial ** 2)
499                             +
500                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
501                             +
502                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
503                             +
504                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
505                         )
506                     ), _tokenPriceInitial
507                 )
508             ) / (tokenPriceIncremental_)
509         ) - (tokenSupply_);
510 
511         return _tokensReceived;
512     }
513 
514     
515     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
516         uint256 tokens_ = (_tokens + 1e18);
517         uint256 _tokenSupply = (tokenSupply_ + 1e18);
518         uint256 _etherReceived =
519         (
520             // underflow attempts BTFO
521             SafeMath.sub(
522                 (
523                     (
524                         (
525                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
526                         ) - tokenPriceIncremental_
527                     ) * (tokens_ - 1e18)
528                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
529             )
530         / 1e18);
531 
532         return _etherReceived;
533     }
534 
535     /// @dev This is where all your gas goes.
536     function sqrt(uint256 x) internal pure returns (uint256 y) {
537         uint256 z = (x + 1) / 2;
538         y = x;
539 
540         while (z < y) {
541             y = z;
542             z = (x / z + z) / 2;
543         }
544     }
545 
546 
547 }
548 
549 
550 library SafeMath {
551 
552     
553     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
554         if (a == 0) {
555             return 0;
556         }
557         uint256 c = a * b;
558         assert(c / a == b);
559         return c;
560     }
561 
562 
563     function div(uint256 a, uint256 b) internal pure returns (uint256) {
564         
565         uint256 c = a / b;
566         
567         return c;
568     }
569 
570    
571     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
572         assert(b <= a);
573         return a - b;
574     }
575 
576    
577     function add(uint256 a, uint256 b) internal pure returns (uint256) {
578         uint256 c = a + b;
579         assert(c >= a);
580         return c;
581     }
582 
583 }