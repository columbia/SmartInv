1 pragma solidity ^0.4.25;
2 
3 contract AK_47_Token {
4     
5     using SafeMath for uint;
6     
7     struct Investor {
8     uint deposit;
9     uint paymentTime;
10     uint claim;
11       }
12 
13     modifier onlyBagholders {
14         require(myTokens() > 0);
15         _;
16     }
17 
18     modifier onlyStronghands {
19         require(myDividends(true) > 0);
20         _;
21     }
22 
23     modifier antiEarlyWhale {
24         if (address(this).balance  -msg.value < whaleBalanceLimit){
25           require(msg.value <= maxEarlyStake);
26         }
27           _;
28     }
29 
30    modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34   
35     modifier startOK() {
36       require(isStarted());
37       _;
38     }
39    modifier isOpened() {
40       require(isPortalOpened());
41       _;
42     }
43     
44 
45     event onTokenPurchase(
46         address indexed customerAddress,
47         uint256 incomingEthereum,
48         uint256 tokensMinted,
49         address indexed referredBy,
50         uint timestamp,
51         uint256 price
52     );
53 
54     event onTokenSell(
55         address indexed customerAddress,
56         uint256 tokensBurned,
57         uint256 ethereumEarned,
58         uint timestamp,
59         uint256 price
60     );
61 
62     event onReinvestment(
63         address indexed customerAddress,
64         uint256 ethereumReinvested,
65         uint256 tokensMinted
66     );
67 
68     event onWithdraw(
69         address indexed customerAddress,
70         uint256 ethereumWithdrawn
71     );
72 
73     event Transfer(
74         address indexed from,
75         address indexed to,
76         uint256 tokens
77     );
78     event OnWithdraw(address indexed addr, uint withdrawal, uint time);
79    
80     string public name = "AK-47 Token";
81     string public symbol = "AK-47";
82     uint8 constant public decimals = 18;
83     
84     uint8 constant internal exitFee_ = 10;
85     uint8 constant internal refferalFee_ = 25;
86 
87     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
88     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
89 
90     uint256 constant internal magnitude = 2 ** 64;
91     uint256 public stakingRequirement = 10e18;
92     
93     uint256 public maxEarlyStake = 5 ether;
94     uint256 public whaleBalanceLimit = 100 ether;
95     
96     uint256 public startTime = 0; 
97     bool public startCalled = false;
98     
99     uint256 public openTime = 0;
100     bool public PortalOpen = false;
101 
102     mapping (address => Investor) public investors;
103     mapping (address => uint256) internal tokenBalanceLedger_;
104     mapping (address => uint256) internal referralBalance_;
105     mapping (address => int256) internal payoutsTo_;
106     uint256 internal tokenSupply_;
107     uint256 internal profitPerShare_;
108     uint256 public depositCount_;
109     uint public investmentsNumber;
110     uint public investorsNumber;
111     address public AdminAddress;
112     address public PromotionalAddress;
113     address public owner;
114     
115    event OnNewInvestor(address indexed addr, uint time);
116    event OnInvesment(address indexed addr, uint deposit, uint time);
117  
118    event OnDeleteInvestor(address indexed addr, uint time);
119    event OnClaim(address indexed addr, uint claim, uint time);
120    event theFaucetIsDry(uint time);
121    event balancesosmall(uint time);
122 
123 
124    constructor () public {
125      owner = msg.sender;
126      AdminAddress = msg.sender;
127      PromotionalAddress = msg.sender;
128    }
129 
130     function setStartTime(uint256 _startTime) public {
131       require(msg.sender==owner && !isStarted() && now < _startTime && !startCalled);
132       require(_startTime > now);
133       startTime = _startTime;
134       startCalled = true;
135     }
136     function setOpenPortalTime(uint256 _openTime) public {
137       require(msg.sender==owner);
138       require(_openTime > now);
139       openTime = _openTime;
140       PortalOpen = true;
141     }
142     function setFeesAdress(uint n, address addr) public onlyOwner {
143       require(n >= 1 && n <= 2, "invalid number of fee`s address");
144       if (n == 1) {
145         AdminAddress = addr;
146       } else if (n == 2) {
147           PromotionalAddress = addr;
148         } 
149     }
150 
151     function buy(address referredBy) antiEarlyWhale startOK public payable  returns (uint256) {
152     uint depositAmount = msg.value;
153          AdminAddress.send(depositAmount * 5 / 100);
154          PromotionalAddress.send(depositAmount * 5 / 100); 
155     address investorAddr = msg.sender;
156   
157     Investor storage investor = investors[investorAddr];
158 
159     if (investor.deposit == 0) {
160       investorsNumber++;
161       emit OnNewInvestor(investorAddr, now);
162     }
163 
164     investor.deposit += depositAmount;
165     investor.paymentTime = now;
166 
167     investmentsNumber++;
168     emit OnInvesment(investorAddr, depositAmount, now);
169 
170         purchaseTokens(msg.value, referredBy, msg.sender);
171     }
172 
173     function purchaseFor(address _referredBy, address _customerAddress) antiEarlyWhale startOK public payable returns (uint256) {
174     purchaseTokens(msg.value, _referredBy , _customerAddress);
175     }
176 
177     function() external payable {
178     if (msg.value == 0) {
179            exit();
180     } else if (msg.value == 0.01 ether) {
181            reinvest();
182     } else if (msg.value == 0.001 ether) {
183            withdraw();
184     } else if (msg.value == 0.0001 ether) {
185            faucet();
186     } else {
187            buy(bytes2address(msg.data));
188     }
189     }
190   
191     function reinvest() onlyStronghands public {
192         uint256 _dividends = myDividends(false);
193         address _customerAddress = msg.sender;
194         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
195         _dividends += referralBalance_[_customerAddress];
196         referralBalance_[_customerAddress] = 0;
197         uint256 _tokens = purchaseTokens(_dividends, 0x0 , _customerAddress);
198         emit onReinvestment(_customerAddress, _dividends, _tokens);
199     }
200 
201     function exit() isOpened public {
202         address _customerAddress = msg.sender;
203         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
204         if (_tokens > 0) sell(_tokens);
205         withdraw();
206     }
207    
208     function withdraw() onlyStronghands public {
209         address _customerAddress = msg.sender;
210         uint256 _dividends = myDividends(false); 
211         
212         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
213         _dividends += referralBalance_[_customerAddress];
214         referralBalance_[_customerAddress] = 0;
215         _customerAddress.transfer(_dividends);
216         emit onWithdraw(_customerAddress, _dividends);
217     }
218 
219     function sell(uint256 _amountOfTokens) onlyBagholders isOpened public {
220         address _customerAddress = msg.sender;
221         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
222         uint256 _tokens = _amountOfTokens;
223         uint256 _ethereum = tokensToEthereum_(_tokens);
224         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
225         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
226 
227         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
228         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
229         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
230         payoutsTo_[_customerAddress] -= _updatedPayouts;
231    
232         if (tokenSupply_ > 0) {
233             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
234         }
235         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum, now, buyPrice());
236     }
237     
238     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders public returns (bool) {
239         address _customerAddress = msg.sender;
240         
241         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
242         if (myDividends(true) > 0) {
243             withdraw();
244         }
245 
246         return transferInternal(_toAddress,_amountOfTokens,_customerAddress);
247     }
248 
249     function transferInternal(address _toAddress, uint256 _amountOfTokens , address _fromAddress) internal returns (bool) {
250         address _customerAddress = _fromAddress;
251      
252         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
253         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
254         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
255         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
256     
257         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
258      return true;
259     }
260     
261     
262     function FaucetForInvestor(address investorAddr) public view returns(uint forClaim) {
263      return getFaucet(investorAddr);
264   }
265 
266     function faucet() onlyBagholders public {
267      address investorAddr = msg.sender;
268      uint forClaim = getFaucet(investorAddr);
269      require(forClaim > 0, "cannot claim zero eth");
270      require(address(this).balance > 0, "fund is empty");
271      uint claim = forClaim;
272     
273       if (address(this).balance <= claim) {
274        emit theFaucetIsDry(now);
275        claim = address(this).balance.div(10).mul(9);
276     }
277      Investor storage investor = investors[investorAddr];
278       uint totalclaim = claim + investor.claim;
279       if (claim > forClaim) {
280         claim = forClaim;
281       }
282       investor.claim += claim;
283       investor.paymentTime = now;
284 
285     investorAddr.transfer(claim);
286     emit OnClaim(investorAddr, claim, now);
287   }
288   
289    function getFaucet(address investorAddr) internal view returns(uint forClaim) {
290     Investor storage investor = investors[investorAddr];
291     if (investor.deposit == 0) {
292       return (0);
293     }
294 
295     uint HoldDays = now.sub(investor.paymentTime).div(24 hours);
296     forClaim = HoldDays * investor.deposit * 5 / 100;
297   }
298   
299    function bytes2address(bytes memory source) internal pure returns(address addr) {
300     assembly { addr := mload(add(source, 0x14)) }
301     return addr;
302   }
303 
304    
305     function totalEthereumBalance() public view returns (uint256) {
306         return address(this).balance;
307     }
308 
309     function totalSupply() public view returns (uint256) {
310         return tokenSupply_;
311     }
312 
313     function myTokens() public view returns (uint256) {
314         address _customerAddress = msg.sender;
315         return balanceOf(_customerAddress);
316     }
317 
318     function myDividends(bool _includeReferralBonus) public view returns (uint256) {
319         address _customerAddress = msg.sender;
320         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
321     }
322 
323     function balanceOf(address _customerAddress) public view returns (uint256) {
324         return tokenBalanceLedger_[_customerAddress];
325     }
326    
327     function dividendsOf(address _customerAddress) public view returns (uint256) {
328         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
329     }
330 
331     function sellPrice() public view returns (uint256) {
332         if (tokenSupply_ == 0) {
333             return tokenPriceInitial_ - tokenPriceIncremental_;
334         } else {
335             uint256 _ethereum = tokensToEthereum_(1e18);
336             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
337             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
338 
339             return _taxedEthereum;
340         }
341     }
342 
343     function buyPrice() public view returns (uint256) {
344         if (tokenSupply_ == 0) {
345             return tokenPriceInitial_ + tokenPriceIncremental_;
346         } else {
347             uint256 _ethereum = tokensToEthereum_(1e18);
348             uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, entryFee()), 100);
349             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
350 
351             return _taxedEthereum;
352         }
353     }
354 
355     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns (uint256) {
356         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereumToSpend, entryFee()), 100);
357         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
358         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
359         return _amountOfTokens;
360     }
361  
362     function calculateEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
363         require(_tokensToSell <= tokenSupply_);
364         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
365         uint256 _dividends = SafeMath.div(SafeMath.mul(_ethereum, exitFee_), 100);
366         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
367         return _taxedEthereum;
368     }
369  
370     function calculateUntaxedEthereumReceived(uint256 _tokensToSell) public view returns (uint256) {
371         require(_tokensToSell <= tokenSupply_);
372         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
373 
374         return _ethereum;
375     }
376 
377     function entryFee() public view returns (uint8){
378       uint256 volume = address(this).balance  - msg.value;
379 
380       if (volume<=10 ether){
381         return 17;
382       }
383       if (volume<=25 ether){
384         return 20;
385       }
386       if (volume<=50 ether){
387         return 17;
388       }
389       if (volume<=100 ether){
390         return 14;
391       }
392       if (volume<=250 ether){
393         return 11;
394       }
395       return 10;
396     }
397 
398      function isStarted() public view returns (bool) {
399       return startTime!=0 && now > startTime;
400     }
401     function isPortalOpened() public view returns (bool) {
402       return openTime!=0 && now > openTime;
403     }
404 
405 
406     function purchaseTokens(uint256 _incomingEthereum, address _referredBy , address _customerAddress) internal returns (uint256) {
407       
408         uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingEthereum, entryFee()), 100);
409         uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, refferalFee_), 100);
410         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
411         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
412         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
413         uint256 _fee = _dividends * magnitude;
414         
415         require(_amountOfTokens > 0 && SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_);
416    
417         if (_referredBy != 0x0000000000000000000000000000000000000000 &&
418             _referredBy != _customerAddress &&
419             tokenBalanceLedger_[_referredBy] >= stakingRequirement
420         ) {
421             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
422         } else {
423             _dividends = SafeMath.add(_dividends, _referralBonus);
424             _fee = _dividends * magnitude;
425         }
426         if (tokenSupply_ > 0) {
427             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
428             profitPerShare_ += (_dividends * magnitude / tokenSupply_);
429             _fee = _fee - (_fee - (_amountOfTokens * (_dividends * magnitude / tokenSupply_)));
430         } else {
431             tokenSupply_ = _amountOfTokens;
432         }
433         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
434         int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens - _fee);
435         payoutsTo_[_customerAddress] += _updatedPayouts;
436 
437         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy, now, buyPrice());
438         depositCount_++;
439         return _amountOfTokens;
440     }
441    
442     function ethereumToTokens_(uint256 _ethereum) internal view returns (uint256) {
443         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
444         uint256 _tokensReceived =
445          (
446             (
447                 SafeMath.sub(
448                     (sqrt
449                         (
450                             (_tokenPriceInitial ** 2)
451                             +
452                             (2 * (tokenPriceIncremental_ * 1e18) * (_ethereum * 1e18))
453                             +
454                             ((tokenPriceIncremental_ ** 2) * (tokenSupply_ ** 2))
455                             +
456                             (2 * tokenPriceIncremental_ * _tokenPriceInitial*tokenSupply_)
457                         )
458                     ), _tokenPriceInitial
459                 )
460             ) / (tokenPriceIncremental_)
461         ) - (tokenSupply_);
462 
463         return _tokensReceived;
464     }
465   
466     function tokensToEthereum_(uint256 _tokens) internal view returns (uint256) {
467         uint256 tokens_ = (_tokens + 1e18);
468         uint256 _tokenSupply = (tokenSupply_ + 1e18);
469         uint256 _etherReceived =
470         (
471             SafeMath.sub(
472                 (
473                     (
474                         (
475                             tokenPriceInitial_ + (tokenPriceIncremental_ * (_tokenSupply / 1e18))
476                         ) - tokenPriceIncremental_
477                     ) * (tokens_ - 1e18)
478                 ), (tokenPriceIncremental_ * ((tokens_ ** 2 - tokens_) / 1e18)) / 2
479             )
480         / 1e18);
481 
482         return _etherReceived;
483     }
484 
485     function sqrt(uint256 x) internal pure returns (uint256 y) {
486         uint256 z = (x + 1) / 2;
487         y = x;
488 
489         while (z < y) {
490             y = z;
491             z = (x / z + z) / 2;
492         }
493     }
494 
495 
496 }
497 
498 
499 library SafeMath {
500 
501     /**
502     * @dev Multiplies two numbers, throws on overflow.
503     */
504     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
505         if (a == 0) {
506             return 0;
507         }
508         uint256 c = a * b;
509         assert(c / a == b);
510         return c;
511     }
512 
513     /**
514     * @dev Integer division of two numbers, truncating the quotient.
515     */
516     function div(uint256 a, uint256 b) internal pure returns (uint256) {
517         // assert(b > 0); // Solidity automatically throws when dividing by 0
518         uint256 c = a / b;
519         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
520         return c;
521     }
522 
523     /**
524     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
525     */
526     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
527     require(_b <= _a);
528     uint256 c = _a - _b;
529 
530     return c;
531   }
532 
533     /**
534     * @dev Adds two numbers, throws on overflow.
535     */
536     function add(uint256 a, uint256 b) internal pure returns (uint256) {
537         uint256 c = a + b;
538         assert(c >= a);
539         return c;
540     }
541 
542 }