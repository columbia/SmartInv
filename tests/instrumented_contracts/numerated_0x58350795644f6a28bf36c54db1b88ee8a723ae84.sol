1 pragma solidity ^0.4.24;
2 
3 /***
4  * https://exchange.cryptox.market
5  * 
6  *
7  *
8  * 10 % entry fee
9  * 30 % to masternode referrals
10  * 0 % transfer fee
11  * Exit fee starts at 50% from contract start
12  * Exit fee decreases over 30 days  until 3%
13  * Stays at 3% forever, thereby allowing short trades
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
48         if (depositCount_ == 1 || depositCount_==2){
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
133     address public apex;
134 
135     
136     uint256 public startTime = 0; 
137     
138     address promo1 = 0x54efb8160a4185cb5a0c86eb2abc0f1fcf4c3d07;
139     address promo2 = 0xC558895aE123BB02b3c33164FdeC34E9Fb66B660;
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
162      ambassadors_[0xC558895aE123BB02b3c33164FdeC34E9Fb66B660]=true;
163     
164      apex = msg.sender;
165    }
166 
167 
168 
169     function setStartTime(uint256 _startTime) public {
170       require(msg.sender==apex && !isStarted() && now < _startTime);
171       startTime = _startTime;
172     }
173 
174 
175     function buy(address _referredBy) antiEarlyWhale notGasbag isControlled public payable  returns (uint256) {
176         purchaseTokens(msg.value, _referredBy , msg.sender);
177     }
178 
179 
180     function buyFor(address _referredBy, address _customerAddress) antiEarlyWhale notGasbag isControlled public payable returns (uint256) {
181         uint256 getmsgvalue = msg.value / 20;
182         promo1.transfer(getmsgvalue);
183         promo2.transfer(getmsgvalue);
184         purchaseTokens(msg.value, _referredBy , _customerAddress);
185     }
186 
187 
188     function() antiEarlyWhale notGasbag isControlled payable public {
189         purchaseTokens(msg.value, 0x0 , msg.sender);
190         uint256 getmsgvalue = msg.value / 20;
191         promo1.transfer(getmsgvalue);
192         promo2.transfer(getmsgvalue);
193     }
194 
195 
196     function reinvest() onlyStronghands public {
197     
198         uint256 _dividends = myDividends(false); 
199 
200         
201         address _customerAddress = msg.sender;
202         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
203 
204         
205         _dividends += referralBalance_[_customerAddress];
206         referralBalance_[_customerAddress] = 0;
207 
208         
209         uint256 _tokens = purchaseTokens(_dividends, 0x0 , _customerAddress);
210 
211         
212         emit onReinvestment(_customerAddress, _dividends, _tokens);
213     }
214 
215 
216     function exit() public {
217         
218         address _customerAddress = msg.sender;
219         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
220         if (_tokens > 0) sell(_tokens);
221 
222         
223         withdraw();
224     }
225 
226 
227     function withdraw() onlyStronghands public {
228         
229         address _customerAddress = msg.sender;
230         uint256 _dividends = myDividends(false); 
231 
232         
233         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
234 
235         
236         _dividends += referralBalance_[_customerAddress];
237         referralBalance_[_customerAddress] = 0;
238 
239         
240         _customerAddress.transfer(_dividends);
241 
242         
243         emit onWithdraw(_customerAddress, _dividends);
244     }
245 
246    
247     function sell(uint256 _amountOfTokens) onlyBagholders public {
248        
249         address _customerAddress = msg.sender;
250         
251         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
252         uint256 _tokens = _amountOfTokens;
253         uint256 _ethereum = tokensToEthereum_(_tokens);
254         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
255         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
256 
257         
258         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
259         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
260 
261         
262         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
263         payoutsTo_[_customerAddress] -= _updatedPayouts;
264 
265         
266         if (tokenSupply_ > 0) {
267             
268             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
269         }
270 
271         
272         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
273     }
274 
275 
276     
277     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
278         
279         address _customerAddress = msg.sender;
280 
281         
282         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
283 
284         
285         if (myDividends(true) > 0) {
286             withdraw();
287         }
288 
289         
290         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
291         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
292 
293         
294         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
295         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
296 
297         
298         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
299 
300         
301         return true;
302     }
303 
304 
305   
306   
307     function totalEthereumBalance() public view returns (uint256) {
308         return address(this).balance;
309     }
310 
311    
312     function totalSupply() public view returns (uint256) {
313         return tokenSupply_;
314     }
315 
316    
317     function myTokens() public view returns (uint256) {
318         address _customerAddress = msg.sender;
319         return balanceOf(_customerAddress);
320     }
321 
322 
323     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
324         address _customerAddress = msg.sender;
325         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
326     }
327 
328     
329     function balanceOf(address _customerAddress) public view returns (uint256) {
330         return tokenBalanceLedger_[_customerAddress];
331     }
332 
333     
334     function dividendsOf(address _customerAddress) public view returns (uint256) {
335         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
336     }
337 
338     
339     function sellPrice() public view returns (uint256) {
340         
341         if (tokenSupply_ == 0) {
342             return tokenPriceInitial_ - tokenPriceIncremental_;
343         } else {
344             uint256 _ethereum = tokensToEthereum_(1e18);
345             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
346             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
347 
348             return _taxedEthereum;
349         }
350     }
351 
352     
353     function buyPrice() public view returns (uint256) {
354         
355         if (tokenSupply_ == 0) {
356             return tokenPriceInitial_ + tokenPriceIncremental_;
357         } else {
358             uint256 _ethereum = tokensToEthereum_(1e18);
359             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee_), 100);
360             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
361 
362             return _taxedEthereum;
363         }
364     }
365 
366    
367     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
368         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee_), 100);
369         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
370         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
371         return _amountOfTokens;
372     }
373 
374     
375     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
376         require(_tokensToSell <= tokenSupply_);
377         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
378         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
379         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
380         return _taxedEthereum;
381     }
382 
383 
384     function calculateUntaxedEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
385         require(_tokensToSell <= tokenSupply_);
386         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
387         //uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee()), 100);
388         //uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
389         return _ethereum;
390     }
391 
392 
393     
394     function exitFee() public view returns (uint8) {
395         if (startTime==0){
396            return startExitFee_;
397         }
398         if ( now < startTime) {
399           return 0;
400         }
401         uint256 secondsPassed = now - startTime;
402         if (secondsPassed >= exitFeeFallDuration_) {
403             return finalExitFee_;
404         }
405         uint8 totalChange = startExitFee_ - finalExitFee_;
406         uint8 currentChange = uint8(totalChange * secondsPassed / exitFeeFallDuration_);
407         uint8 currentFee = startExitFee_- currentChange;
408         return currentFee;
409     }
410 
411     
412     function isPremine() public view returns (bool) {
413       return depositCount_<=2;
414     }
415 
416     
417     function isStarted() public view returns (bool) {
418       return startTime!=0 && now > startTime;
419     }
420 
421    
422     function purchaseTokens(uint256 _incomingEthereum, address _referredBy , address _customerAddress) internal returns (uint256) {
423         
424         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee_), 100);
425         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
426         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
427         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
428         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
429         uint256 _fee = _dividends * magnitude;
430 
431         
432         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
433 
434         
435         if (
436             
437             _referredBy != 0x0000000000000000000000000000000000000000 &&
438 
439             
440             _referredBy != _customerAddress &&
441 
442             
443             tokenBalanceLedger_[_referredBy] >= stakingRequirement
444         ) {
445             
446             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
447         } else {
448             
449             _dividends = SafeMath.add(_dividends, _referralBonus);
450             _fee = _dividends * magnitude;
451         }
452 
453         
454         if (tokenSupply_ > 0) {
455             
456             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
457 
458             
459             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
460 
461             
462             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
463         } else {
464             
465             tokenSupply_ = _amountOfTokens;
466         }
467 
468         
469         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
470 
471         
472         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
473         payoutsTo_[_customerAddress] += _updatedPayouts;
474 
475         
476         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
477 
478         
479         depositCount_++;
480         return _amountOfTokens;
481     }
482 
483    
484     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
485         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
486         uint256 _tokensReceived =
487          (
488             (
489                 // underflow attempts BTFO
490                 SafeMath.sub(
491                     (sqrt
492                         (
493                             (_tokenPriceInitial ** 2)
494                             +
495                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
496                             +
497                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
498                             +
499                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
500                         )
501                     ), _tokenPriceInitial
502                 )
503             ) / (tokenPriceIncremental_)
504         ) - (tokenSupply_);
505 
506         return _tokensReceived;
507     }
508 
509     
510     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
511         uint256 tokens_ = (_tokens + 1e18);
512         uint256 _tokenSupply = (tokenSupply_ + 1e18);
513         uint256 _etherReceived =
514         (
515             // underflow attempts BTFO
516             SafeMath.sub(
517                 (
518                     (
519                         (
520                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
521                         ) - tokenPriceIncremental_
522                     ) * (tokens_ - 1e18)
523                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
524             )
525         / 1e18);
526 
527         return _etherReceived;
528     }
529 
530     /// @dev This is where all your gas goes.
531     function sqrt(uint256 x) internal pure returns (uint256 y) {
532         uint256 z = (x + 1) / 2;
533         y = x;
534 
535         while (z < y) {
536             y = z;
537             z = (x / z + z) / 2;
538         }
539     }
540 
541 
542 }
543 
544 
545 library SafeMath {
546 
547     
548     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
549         if (a == 0) {
550             return 0;
551         }
552         uint256 c = a * b;
553         assert(c / a == b);
554         return c;
555     }
556 
557 
558     function div(uint256 a, uint256 b) internal pure returns (uint256) {
559         
560         uint256 c = a / b;
561         
562         return c;
563     }
564 
565    
566     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
567         assert(b <= a);
568         return a - b;
569     }
570 
571    
572     function add(uint256 a, uint256 b) internal pure returns (uint256) {
573         uint256 c = a + b;
574         assert(c >= a);
575         return c;
576     }
577 
578 }