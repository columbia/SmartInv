1 pragma solidity ^0.5.15;
2 
3 
4 interface ERC20 {
5     function totalSupply() external view returns (uint256 supply);
6 
7     function balanceOf(address _owner) external view returns (uint256 balance);
8 
9     function transfer(address _to, uint256 _value)
10         external
11         returns (bool success);
12 
13     function transferFrom(
14         address _from,
15         address _to,
16         uint256 _value
17     ) external returns (bool success);
18 
19     function approve(address _spender, uint256 _value)
20         external
21         returns (bool success);
22 
23     function allowance(address _owner, address _spender)
24         external
25         view
26         returns (uint256 remaining);
27 
28     function decimals() external view returns (uint256 digits);
29 
30     event Approval(
31         address indexed _owner,
32         address indexed _spender,
33         uint256 _value
34     );
35 }
36 
37 
38 contract Link3D {
39     /*=================================
40   =            MODIFIERS            =
41   =================================*/
42     // only people with tokens
43     modifier onlyBagholders() {
44         require(myTokens() > 0);
45         _;
46     }
47 
48     // only people with profits
49     modifier onlyStronghands() {
50         require(myDividends(true) > 0);
51         _;
52     }
53 
54     modifier onlyAdmin() {
55         require(msg.sender == administrator);
56         _;
57     }
58 
59     /*==============================
60   =            EVENTS            =
61   ==============================*/
62     event onTokenPurchase(
63         address indexed customerAddress,
64         uint256 incomingEthereum,
65         uint256 tokensMinted,
66         address indexed referredBy
67     );
68 
69     event onTokenSell(
70         address indexed customerAddress,
71         uint256 tokensBurned,
72         uint256 ethereumEarned
73     );
74 
75     event onReinvestment(
76         address indexed customerAddress,
77         uint256 ethereumReinvested,
78         uint256 tokensMinted
79     );
80 
81     event onWithdraw(
82         address indexed customerAddress,
83         uint256 ethereumWithdrawn
84     );
85 
86     // ERC20
87     event Transfer(address indexed from, address indexed to, uint256 tokens);
88 
89     /*=====================================
90   =            CONFIGURABLES            =
91   =====================================*/
92     string public name = "Link3D";
93     string public symbol = "L3D";
94     uint8 public constant decimals = 18;
95     uint8 internal constant dividendFee_ = 10; // 10%
96     uint8 internal constant sellFee_ = 15; // 15%
97     uint256 internal constant baseIncrease = 1e8;
98     uint256 internal constant basePrice = 1e11;
99     uint256 internal constant tokenPriceInitial_ = 50 * basePrice; // (1*10^11)/10^18 => 0,0000001
100     uint256 internal constant tokenPriceIncremental_ = 2 * baseIncrease; // (1*10^10)/10^18 => 0,00000001, 1e10/50 = 2*10e8
101     uint256 internal constant magnitude = 2**64;
102     address internal constant tokenAddress = address(
103         0x514910771AF9Ca656af840dff83E8264EcF986CA  // chainlink token address
104     );
105     ERC20 internal constant _contract = ERC20(tokenAddress);
106 
107     // admin for premine lock
108     address internal administrator;
109     uint256 public stakingRequirement = 10e18;
110     uint256 public releaseTime = 1593295200;
111 
112     /*================================
113   =            DATASETS            =
114   ================================*/
115     // amount of shares for each address (scaled number)
116     mapping(address => uint256) internal tokenBalanceLedger_;
117     mapping(address => uint256) internal referralBalance_;
118     mapping(address => int256) internal payoutsTo_;
119     uint256 internal tokenSupply_ = 0;
120     uint256 internal profitPerShare_;
121 
122     /*=======================================
123   =            PUBLIC FUNCTIONS            =
124   =======================================*/
125     /*
126      * -- APPLICATION ENTRY POINTS --
127      */
128     constructor() public {
129         administrator = msg.sender;
130     }
131 
132     /**
133      * ERC677 transferandcall support
134      */
135     function onTokenTransfer(address _sender, uint _value, bytes calldata _data) external {
136         // make sure that only chainlink transferandcalls are supported
137         require(msg.sender == tokenAddress);
138 
139         // convert _data to address
140         bytes memory x = _data;
141         address _referredBy;
142 
143         assembly {
144             _referredBy := mload(add(x,20))
145         }
146 
147         
148 
149         purchaseTokens(_value, _referredBy, _sender);
150     }
151 
152     /**
153      * refuse to receive any tokens directly sent
154      *
155      */
156     function() external payable {
157         revert();
158     }
159 
160     function distribute(uint256 amount) external {
161         _contract.transferFrom(msg.sender, address(this), amount);
162         profitPerShare_ = SafeMath.add(
163             profitPerShare_,
164             (amount * magnitude) / tokenSupply_
165         );
166     }
167 
168     /**
169      * Converts all of caller's dividends to tokens.
170      */
171     function reinvest() public onlyStronghands() {
172         // fetch dividends
173         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
174 
175         // pay out the dividends virtually
176         address _customerAddress = msg.sender;
177         payoutsTo_[_customerAddress] += (int256)(_dividends * magnitude);
178 
179         // retrieve ref. bonus
180         _dividends += referralBalance_[_customerAddress];
181         referralBalance_[_customerAddress] = 0;
182 
183         // dispatch a buy order with the virtualized "withdrawn dividends"
184         uint256 _tokens = purchaseTokens(_dividends, address(0x0), _customerAddress);
185         emit onReinvestment(
186             _customerAddress,
187             _dividends,
188             _tokens
189         );
190     }
191 
192     /**
193      * Alias of sell() and withdraw().
194      */
195     function exit() public {
196         // get token count for caller & sell them all
197         address _customerAddress = msg.sender;
198         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
199         if (_tokens > 0) sell(_tokens);
200 
201         withdraw();
202     }
203 
204     /**
205      * Withdraws all of the callers earnings.
206      */
207     function withdraw() public onlyStronghands() {
208         // setup data
209         address _customerAddress = msg.sender;
210         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
211 
212         // update dividend tracker
213         payoutsTo_[_customerAddress] += (int256)(_dividends * magnitude);
214 
215         // add ref. bonus
216         _dividends += referralBalance_[_customerAddress];
217         referralBalance_[_customerAddress] = 0;
218 
219         // lambo delivery service
220         _contract.transfer(_customerAddress, _dividends);
221 
222         // fire event
223         emit onWithdraw(
224             _customerAddress,
225             _dividends
226         );
227     }
228 
229     /**
230      * Liquifies tokens to ethereum.
231      */
232     function sell(uint256 _amountOfTokens) public onlyBagholders() {
233         // setup data
234         address _customerAddress = msg.sender;
235         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
236         uint256 _tokens = _amountOfTokens;
237         uint256 _ethereum = tokensToEthereum_(_tokens);
238         uint256 _dividends = SafeMath.div((_ethereum*sellFee_), 100);
239         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
240 
241         // burn the sold tokens
242         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
243         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(
244             tokenBalanceLedger_[_customerAddress],
245             _tokens
246         );
247 
248         // update dividends tracker
249         int256 _updatedPayouts = (int256)(
250             profitPerShare_ * _tokens + (_taxedEthereum * magnitude)
251         );
252         payoutsTo_[_customerAddress] -= _updatedPayouts;
253 
254         // dividing by zero is a bad idea
255         if (tokenSupply_ > 0) {
256             // update the amount of dividends per token
257             profitPerShare_ = SafeMath.add(
258                 profitPerShare_,
259                 (_dividends * magnitude) / tokenSupply_
260             );
261         }
262 
263         // fire event
264         emit onTokenSell(
265             _customerAddress,
266             _tokens,
267             _taxedEthereum
268         );
269     }
270 
271     /**
272      * Transfers tokens to another wallet.
273      * There is no transfer fee.
274      */
275     function transfer(address _toAddress, uint256 _amountOfTokens)
276         public
277         onlyBagholders()
278         returns (bool)
279     {
280         // setup
281         address _customerAddress = msg.sender;
282 
283         // make sure we have the requested tokens
284         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
285 
286         // withdraw all outstanding dividends first
287         if (myDividends(true) > 0) withdraw();
288 
289         // exchange tokens
290         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(
291             tokenBalanceLedger_[_customerAddress],
292             _amountOfTokens
293         );
294         tokenBalanceLedger_[_toAddress] = SafeMath.add(
295             tokenBalanceLedger_[_toAddress],
296             _amountOfTokens
297         );
298 
299         // update dividend trackers
300         payoutsTo_[_customerAddress] -= (int256)(
301             profitPerShare_ * _amountOfTokens
302         );
303         payoutsTo_[_toAddress] += (int256)(profitPerShare_ * _amountOfTokens);
304 
305         // fire event
306         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
307 
308         // ERC20
309         return true;
310     }
311 
312     /*----------  HELPERS AND CALCULATORS  ----------*/
313     /**
314      * Method to view the current Chainlink stored in the contract
315      * Example: totalLinkBalance()
316      */
317     function totalLinkBalance() public view returns (uint256) {
318         return _contract.balanceOf(address(this));
319     }
320 
321     /**
322      * Retrieve the total token supply.
323      */
324     function totalSupply() public view returns (uint256) {
325         return tokenSupply_;
326     }
327 
328     /**
329      * Retrieve the tokens owned by the caller.
330      */
331     function myTokens() public view returns (uint256) {
332         address _customerAddress = msg.sender;
333         return balanceOf(_customerAddress);
334     }
335 
336     /**
337      * Retrieve the dividends owned by the caller.
338      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
339      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
340      * But in the internal calculations, we want them separate.
341      */
342     function myDividends(bool _includeReferralBonus)
343         public
344         view
345         returns (uint256)
346     {
347         address _customerAddress = msg.sender;
348         return
349             _includeReferralBonus
350                 ? dividendsOf(_customerAddress) +
351                     referralBalance_[_customerAddress]
352                 : dividendsOf(_customerAddress);
353     }
354 
355     /**
356      * Retrieve the token balance of any single address.
357      */
358     function balanceOf(address _customerAddress) public view returns (uint256) {
359         return tokenBalanceLedger_[_customerAddress];
360     }
361 
362     /**
363      * Retrieve the referral balance of any single address.
364      */
365     function getReferralBalance(address _customerAddress) public view returns (uint256) {
366         return referralBalance_[_customerAddress];
367     }
368 
369     /**
370      * Retrieve the dividend balance of any single address.
371      */
372     function dividendsOf(address _customerAddress)
373         public
374         view
375         returns (uint256)
376     {
377         return
378             (uint256)(
379                 (int256)(
380                     profitPerShare_ * tokenBalanceLedger_[_customerAddress]
381                 ) - payoutsTo_[_customerAddress]
382             ) / magnitude;
383     }
384 
385     /**
386      * Return the sell price of 1 individual token.
387      */
388     function sellPrice() public view returns (uint256) {
389         // our calculation relies on the token supply, so we need supply.
390         if (tokenSupply_ == 0) {
391             return tokenPriceInitial_ - tokenPriceIncremental_;
392         } else {
393             uint256 _ethereum = tokensToEthereum_(1e18);
394             uint256 _dividends = SafeMath.div((_ethereum*sellFee_), 100);
395             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
396             return _taxedEthereum;
397         }
398     }
399 
400     /**
401      * Return the buy price of 1 individual token.
402      */
403     function buyPrice() public view returns (uint256) {
404         if (tokenSupply_ == 0) {
405             return tokenPriceInitial_ + tokenPriceIncremental_;
406         } else {
407             uint256 _ethereum = tokensToEthereum_(1e18);
408             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
409             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
410             return _taxedEthereum;
411         }
412     }
413 
414     /**
415      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
416      */
417     function calculateTokensReceived(uint256 _ethereumToSpend)
418         public
419         view
420         returns (uint256)
421     {
422         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
423         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
424         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
425 
426         return _amountOfTokens;
427     }
428 
429     /**
430      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
431      */
432     function calculateEthereumReceived(uint256 _tokensToSell)
433         public
434         view
435         returns (uint256)
436     {
437         require(_tokensToSell <= tokenSupply_);
438         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
439         uint256 _dividends = SafeMath.div((_ethereum*sellFee_), 100);
440         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
441         return _taxedEthereum;
442     }
443 
444     /*==========================================
445   =            INTERNAL FUNCTIONS            =
446   ==========================================*/
447     function purchaseTokens(
448         uint256 _incomingEthereum,
449         address _referredBy,
450         address _sender
451     ) internal returns (uint256) {
452         require((block.timestamp >= releaseTime) || (_sender == administrator));
453         // data setup
454         address _customerAddress = _sender;
455         uint256 _undividedDividends = SafeMath.div(
456             _incomingEthereum,
457             dividendFee_
458         );
459         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
460         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
461         uint256 _taxedEthereum = SafeMath.sub(
462             _incomingEthereum,
463             _undividedDividends
464         );
465         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
466         uint256 _fee = _dividends * magnitude;
467 
468         require(
469             _amountOfTokens > 0 &&
470                 (SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_)
471         );
472 
473         // is the user referred by a masternode?
474         if (
475             // is this a referred purchase?
476             _referredBy != 0x0000000000000000000000000000000000000000 &&
477             // no cheating!
478             _referredBy != _customerAddress &&
479 
480             // does the referrer have at least X whole tokens?
481             tokenBalanceLedger_[_referredBy] >= stakingRequirement
482         ) {
483             // wealth redistribution
484             referralBalance_[_referredBy] = SafeMath.add(
485                 referralBalance_[_referredBy],
486                 _referralBonus
487             );
488         } else {
489             // no ref purchase
490             // add the referral bonus back to the global dividends
491             _dividends = SafeMath.add(_dividends, _referralBonus);
492             _fee = _dividends * magnitude;
493         }
494 
495         // we can't give people infinite ethereum
496         if (tokenSupply_ > 0) {
497             // add tokens to the pool
498             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
499 
500             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
501             profitPerShare_ += ((_dividends * magnitude) / (tokenSupply_));
502 
503             // calculate the amount of tokens the customer receives over his purchase
504             _fee =
505                 _fee -
506                 (_fee -
507                     (_amountOfTokens *
508                         ((_dividends * magnitude) / (tokenSupply_))));
509         } else {
510             // add tokens to the pool
511             tokenSupply_ = _amountOfTokens;
512         }
513 
514         // update circulating supply & the ledger address for the customer
515         tokenBalanceLedger_[_customerAddress] = SafeMath.add(
516             tokenBalanceLedger_[_customerAddress],
517             _amountOfTokens
518         );
519 
520         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
521         //really i know you think you do but you don't
522         int256 _updatedPayouts = (int256)(
523             (profitPerShare_ * _amountOfTokens) - _fee
524         );
525         payoutsTo_[_customerAddress] += _updatedPayouts;
526 
527         // fire event
528         emit onTokenPurchase(
529             _customerAddress,
530             _incomingEthereum,
531             _amountOfTokens,
532             _referredBy
533         );
534 
535         return _amountOfTokens;
536     }
537 
538     /**
539      * Calculate Token price based on an amount of incoming ethereum
540      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
541      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
542      */
543     function ethereumToTokens_(uint256 _ethereum)
544         internal
545         view
546         returns (uint256)
547     {
548         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
549         uint256 _tokensReceived = ((
550             SafeMath.sub(
551                 (
552                     sqrt(
553                         (_tokenPriceInitial**2) +
554                             (2 *
555                                 (tokenPriceIncremental_ * 1e18) *
556                                 (_ethereum * 1e18)) +
557                             (((tokenPriceIncremental_)**2) *
558                                 (tokenSupply_**2)) +
559                             (2 *
560                                 (tokenPriceIncremental_) *
561                                 _tokenPriceInitial *
562                                 tokenSupply_)
563                     )
564                 ),
565                 _tokenPriceInitial
566             )
567         ) / (tokenPriceIncremental_)) - (tokenSupply_);
568 
569         return _tokensReceived;
570     }
571 
572     /**
573      * Calculate token sell value.
574      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
575      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
576      */
577     function tokensToEthereum_(uint256 _tokens)
578         internal
579         view
580         returns (uint256)
581     {
582         uint256 tokens_ = (_tokens + 1e18);
583         uint256 _tokenSupply = (tokenSupply_ + 1e18);
584         uint256 _etherReceived = (SafeMath.sub(
585             (((tokenPriceInitial_ +
586                 (tokenPriceIncremental_ * (_tokenSupply / 1e18))) -
587                 tokenPriceIncremental_) * (tokens_ - 1e18)),
588             (tokenPriceIncremental_ * ((tokens_**2 - tokens_) / 1e18)) / 2
589         ) / 1e18);
590         return _etherReceived;
591     }
592 
593     //This is where all your gas goes apparently
594     function sqrt(uint256 x) internal pure returns (uint256 y) {
595         uint256 z = (x + 1) / 2;
596         y = x;
597         while (z < y) {
598             y = z;
599             z = (x / z + z) / 2;
600         }
601     }
602 }
603 
604 /**
605  * @title SafeMath
606  * @dev Math operations with safety checks that throw on error
607  */
608 library SafeMath {
609     /**
610      * @dev Multiplies two numbers, throws on overflow.
611      */
612     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
613         if (a == 0) {
614             return 0;
615         }
616         uint256 c = a * b;
617         require(c / a == b);
618         return c;
619     }
620 
621     /**
622      * @dev Integer division of two numbers, truncating the quotient.
623      */
624     function div(uint256 a, uint256 b) internal pure returns (uint256) {
625         uint256 c = a / b;
626         return c;
627     }
628 
629     /**
630      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
631      */
632     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
633         require(b <= a);
634         return a - b;
635     }
636 
637     /**
638      * @dev Adds two numbers, throws on overflow.
639      */
640     function add(uint256 a, uint256 b) internal pure returns (uint256) {
641         uint256 c = a + b;
642         require(c >= a);
643         return c;
644     }
645 }