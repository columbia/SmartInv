1 // CryptoTorch-Token Source code
2 // copyright 2018 CryptoTorch <https://cryptotorch.io>
3 
4 pragma solidity 0.4.19;
5 
6 
7 /**
8  * @title SafeMath
9  * Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13     /**
14     * Multiplies two numbers, throws on overflow.
15     */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17         if (a == 0) {
18             return 0;
19         }
20         uint256 c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return c;
33     }
34 
35     /**
36     * Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 
54 /**
55 * @title Ownable
56  *
57  * Owner rights:
58  *   - change the name of the contract
59  *   - change the name of the token
60  *   - change the Proof of Stake difficulty
61  *   - transfer ownership
62  *
63  * Owner CANNOT:
64  *   - withdrawal funds
65  *   - disable withdrawals
66  *   - kill the contract
67  *   - change the price of tokens
68 */
69 contract Ownable {
70     address public owner;
71 
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     function Ownable() public {
75         owner = msg.sender;
76     }
77 
78     modifier onlyOwner() {
79         require(msg.sender == owner);
80         _;
81     }
82 
83     function transferOwnership(address newOwner) public onlyOwner {
84         require(newOwner != address(0));
85         OwnershipTransferred(owner, newOwner);
86         owner = newOwner;
87     }
88 }
89 
90 
91 /**
92  * @title ERC20 interface (Good parts only)
93  * see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 {
96     event Transfer(address indexed from, address indexed to, uint256 value);
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 
99     function totalSupply() public view returns (uint256);
100     function balanceOf(address who) public view returns (uint256);
101     function transfer(address to, uint256 value) public returns (bool);
102 }
103 
104 
105 /**
106  * @title CryptoTorchToken
107  *
108  * Token + Dividends System for the Cryptolympic-Torch
109  *
110  * Token: KMS - Kilometers (Distance of Torch Run)
111  */
112 contract CryptoTorchToken is ERC20, Ownable {
113     using SafeMath for uint256;
114 
115     //
116     // Events
117     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
118     //
119     event onWithdraw(
120         address indexed to,
121         uint256 amount
122     );
123     event onMint(
124         address indexed to,
125         uint256 pricePaid,
126         uint256 tokensMinted,
127         address indexed referredBy
128     );
129     event onBurn(
130         address indexed from,
131         uint256 tokensBurned,
132         uint256 amountEarned
133     );
134 
135     //
136     // Token Configurations
137     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
138     //
139     string internal name_ = "Cryptolympic Torch-Run Kilometers";
140     string internal symbol_ = "KMS";
141     uint256 constant internal dividendFee_ = 5;
142     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
143     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
144     uint256 constant internal magnitude = 2**64;
145     uint256 public stakingRequirement = 50e18;
146 
147     //
148     // Token Internals
149     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
150     //
151     uint256 internal tokenSupply_ = 0;
152     uint256 internal profitPerShare_;
153     address internal tokenController_;
154     address internal donationsReceiver_;
155     mapping (address => uint256) internal tokenBalanceLedger_; // scaled by 1e18
156     mapping (address => uint256) internal referralBalance_;
157     mapping (address => uint256) internal profitsReceived_;
158     mapping (address => int256) internal payoutsTo_;
159 
160     //
161     // Modifiers
162     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
163     //
164     // No buying tokens directly through this contract, only through the
165     // CryptoTorch Controller Contract via the CryptoTorch Dapp
166     //
167     modifier onlyTokenController() {
168         require(tokenController_ != address(0) && msg.sender == tokenController_);
169         _;
170     }
171 
172     // Token Holders Only
173     modifier onlyTokenHolders() {
174         require(myTokens() > 0);
175         _;
176     }
177 
178     // Dividend Holders Only
179     modifier onlyProfitHolders() {
180         require(myDividends(true) > 0);
181         _;
182     }
183 
184     //
185     // Public Functions
186     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
187     //
188     /**
189      * Contract Constructor
190      */
191     function CryptoTorchToken() public {}
192 
193     /**
194      * Sets the Token Controller Contract (CryptoTorch)
195      */
196     function setTokenController(address _controller) public onlyOwner {
197         tokenController_ = _controller;
198     }
199 
200     /**
201      * Sets the Contract Donations Receiver address
202      */
203     function setDonationsReceiver(address _receiver) public onlyOwner {
204         donationsReceiver_ = _receiver;
205     }
206 
207     /**
208      * Do not make payments directly to this contract (unless it is a donation! :)
209      *  - payments made directly to the contract do not receive tokens.  Tokens
210      *    are only available through the CryptoTorch Controller Contract, which
211      *    is managed by the Dapp at https://cryptotorch.io
212      */
213     function() payable public {
214         if (msg.value > 0 && donationsReceiver_ != 0x0) {
215             donationsReceiver_.transfer(msg.value); // donations?  Thank you!  :)
216         }
217     }
218 
219     /**
220      * Liquifies tokens to ether.
221      */
222     function sell(uint256 _amountOfTokens) public onlyTokenHolders {
223         sell_(msg.sender, _amountOfTokens);
224     }
225 
226     /**
227      * Liquifies tokens to ether.
228      */
229     function sellFor(address _for, uint256 _amountOfTokens) public onlyTokenController {
230         sell_(_for, _amountOfTokens);
231     }
232 
233     /**
234      * Liquifies tokens to ether.
235      */
236     function withdraw() public onlyProfitHolders {
237         withdraw_(msg.sender);
238     }
239 
240     /**
241      * Liquifies tokens to ether.
242      */
243     function withdrawFor(address _for) public onlyTokenController {
244         withdraw_(_for);
245     }
246 
247     /**
248      * Liquifies tokens to ether.
249      */
250     function mint(address _to, uint256 _amountPaid, address _referredBy) public onlyTokenController payable returns(uint256) {
251         require(_amountPaid == msg.value);
252         return mintTokens_(_to, _amountPaid, _referredBy);
253     }
254 
255     /**
256      * Transfer tokens from the caller to a new holder.
257      * There's a small fee here that is redistributed to all token holders
258      */
259     function transfer(address _to, uint256 _value) public onlyTokenHolders returns(bool) {
260         return transferFor_(msg.sender, _to, _value);
261     }
262 
263     //
264     // Owner Functions
265     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
266     //
267     /**
268      * If we want to rebrand, we can.
269      */
270     function setName(string _name) public onlyOwner {
271         name_ = _name;
272     }
273 
274     /**
275      * If we want to rebrand, we can.
276      */
277     function setSymbol(string _symbol) public onlyOwner {
278         symbol_ = _symbol;
279     }
280 
281     /**
282      * Precautionary measures in case we need to adjust the masternode rate.
283      */
284     function setStakingRequirement(uint256 _amountOfTokens) public onlyOwner {
285         stakingRequirement = _amountOfTokens;
286     }
287 
288     //
289     // Helper Functions
290     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
291     //
292     /**
293      * View the total balance of the contract
294      */
295     function contractBalance() public view returns (uint256) {
296         return this.balance;
297     }
298 
299     /**
300      * Retrieve the total token supply.
301      */
302     function totalSupply() public view returns(uint256) {
303         return tokenSupply_;
304     }
305 
306     /**
307      * ERC20 Token Name
308      */
309     function name() public view returns (string) {
310         return name_;
311     }
312 
313     /**
314      * ERC20 Token Symbol
315      */
316     function symbol() public view returns (string) {
317         return symbol_;
318     }
319 
320     /**
321      * ERC20 Token Decimals
322      */
323     function decimals() public pure returns (uint256) {
324         return 18;
325     }
326 
327     /**
328      * Retrieve the tokens owned by the caller.
329      */
330     function myTokens() public view returns(uint256) {
331         address _playerAddress = msg.sender;
332         return balanceOf(_playerAddress);
333     }
334 
335     /**
336      * Retrieve the dividends owned by the caller.
337      * If `_includeBonus` is to to true, the referral bonus will be included in the calculations.
338      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
339      * But in the internal calculations, we want them separate.
340      */
341     function myDividends(bool _includeBonus) public view returns(uint256) {
342         address _playerAddress = msg.sender;
343         return _includeBonus ? dividendsOf(_playerAddress) + referralBalance_[_playerAddress] : dividendsOf(_playerAddress);
344     }
345 
346     /**
347      * Retreive the Total Profits previously paid out to the Caller
348      */
349     function myProfitsReceived() public view returns (uint256) {
350         address _playerAddress = msg.sender;
351         return profitsOf(_playerAddress);
352     }
353 
354     /**
355      * Retrieve the token balance of any single address.
356      */
357     function balanceOf(address _playerAddress) public view returns(uint256) {
358         return tokenBalanceLedger_[_playerAddress];
359     }
360 
361     /**
362      * Retrieve the dividend balance of any single address.
363      */
364     function dividendsOf(address _playerAddress) public view returns(uint256) {
365         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_playerAddress]) - payoutsTo_[_playerAddress]) / magnitude;
366     }
367 
368     /**
369      * Retrieve the paid-profits balance of any single address.
370      */
371     function profitsOf(address _playerAddress) public view returns(uint256) {
372         return profitsReceived_[_playerAddress];
373     }
374 
375     /**
376      * Retrieve the referral dividends balance of any single address.
377      */
378     function referralBalanceOf(address _playerAddress) public view returns(uint256) {
379         return referralBalance_[_playerAddress];
380     }
381 
382     /**
383      * Return the sell price of 1 individual token.
384      */
385     function sellPrice() public view returns(uint256) {
386         // our calculation relies on the token supply, so we need supply. Doh.
387         if (tokenSupply_ == 0) {
388             return tokenPriceInitial_ - tokenPriceIncremental_;
389         } else {
390             uint256 _ether = tokensToEther_(1e18);
391             uint256 _dividends = SafeMath.div(_ether, dividendFee_);
392             uint256 _taxedEther = SafeMath.sub(_ether, _dividends);
393             return _taxedEther;
394         }
395     }
396 
397     /**
398      * Return the buy price of 1 individual token.
399      */
400     function buyPrice() public view returns(uint256) {
401         // our calculation relies on the token supply, so we need supply. Doh.
402         if (tokenSupply_ == 0) {
403             return tokenPriceInitial_ + tokenPriceIncremental_;
404         } else {
405             uint256 _ether = tokensToEther_(1e18);
406             uint256 _dividends = SafeMath.div(_ether, dividendFee_);
407             uint256 _taxedEther = SafeMath.add(_ether, _dividends);
408             return _taxedEther;
409         }
410     }
411 
412     /**
413      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
414      */
415     function calculateTokensReceived(uint256 _etherToSpend) public view returns(uint256) {
416         uint256 _dividends = _etherToSpend.div(dividendFee_);
417         uint256 _taxedEther = _etherToSpend.sub(_dividends);
418         uint256 _amountOfTokens = etherToTokens_(_taxedEther);
419         return _amountOfTokens;
420     }
421 
422     /**
423      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
424      */
425     function calculateEtherReceived(uint256 _tokensToSell) public view returns(uint256) {
426         require(_tokensToSell <= tokenSupply_);
427         uint256 _ether = tokensToEther_(_tokensToSell);
428         uint256 _dividends = _ether.div(dividendFee_);
429         uint256 _taxedEther = _ether.sub(_dividends);
430         return _taxedEther;
431     }
432 
433     //
434     // Internal Functions
435     // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
436     //
437 
438     /**
439      * Liquifies tokens to ether.
440      */
441     function sell_(address _recipient, uint256 _amountOfTokens) internal {
442         require(_amountOfTokens <= tokenBalanceLedger_[_recipient]);
443 
444         uint256 _tokens = _amountOfTokens;
445         uint256 _ether = tokensToEther_(_tokens);
446         uint256 _dividends = SafeMath.div(_ether, dividendFee_);
447         uint256 _taxedEther = SafeMath.sub(_ether, _dividends);
448 
449         // burn the sold tokens
450         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
451         tokenBalanceLedger_[_recipient] = SafeMath.sub(tokenBalanceLedger_[_recipient], _tokens);
452 
453         // update dividends tracker
454         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEther * magnitude));
455         payoutsTo_[_recipient] -= _updatedPayouts;
456 
457         // update the amount of dividends per token
458         if (tokenSupply_ > 0) {
459             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
460         }
461 
462         // fire event
463         onBurn(_recipient, _tokens, _taxedEther);
464     }
465 
466     /**
467      * Withdraws all of the callers earnings.
468      */
469     function withdraw_(address _recipient) internal {
470         require(_recipient != address(0));
471 
472         // setup data
473         uint256 _dividends = getDividendsOf_(_recipient, false);
474 
475         // update dividend tracker
476         payoutsTo_[_recipient] += (int256)(_dividends * magnitude);
477 
478         // add ref. bonus
479         _dividends += referralBalance_[_recipient];
480         referralBalance_[_recipient] = 0;
481 
482         // fire event
483         onWithdraw(_recipient, _dividends);
484 
485         // transfer funds
486         profitsReceived_[_recipient] = profitsReceived_[_recipient].add(_dividends);
487         _recipient.transfer(_dividends);
488 
489         // Keep contract clean
490         if (tokenSupply_ == 0 && this.balance > 0) {
491             owner.transfer(this.balance);
492         }
493     }
494 
495     /**
496      * Assign tokens to player
497      */
498     function mintTokens_(address _to, uint256 _amountPaid, address _referredBy) internal returns(uint256) {
499         require(_to != address(this) && _to != tokenController_);
500 
501         uint256 _undividedDividends = SafeMath.div(_amountPaid, dividendFee_);
502         uint256 _referralBonus = SafeMath.div(_undividedDividends, 10);
503         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
504         uint256 _taxedEther = SafeMath.sub(_amountPaid, _undividedDividends);
505         uint256 _amountOfTokens = etherToTokens_(_taxedEther);
506         uint256 _fee = _dividends * magnitude;
507 
508         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
509         // (or hackers)
510         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens, tokenSupply_) > tokenSupply_));
511 
512         // is the user referred by a masternode?
513         if (_referredBy != address(0) && _referredBy != _to && tokenBalanceLedger_[_referredBy] >= stakingRequirement) {
514             // wealth redistribution
515             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
516         } else {
517             // no ref purchase
518             // add the referral bonus back to the global dividends cake
519             _dividends = SafeMath.add(_dividends, _referralBonus);
520             _fee = _dividends * magnitude;
521         }
522 
523         if (tokenSupply_ > 0) {
524             // add tokens to the pool
525             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
526 
527             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
528             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
529 
530             // calculate the amount of tokens the customer receives over his purchase
531             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
532 
533         } else {
534             // add tokens to the pool
535             tokenSupply_ = _amountOfTokens;
536         }
537 
538         // update circulating supply & the ledger address for the customer
539         tokenBalanceLedger_[_to] = SafeMath.add(tokenBalanceLedger_[_to], _amountOfTokens);
540 
541         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them
542         int256 _updatedPayouts = (int256)((profitPerShare_ * _amountOfTokens) - _fee);
543         payoutsTo_[_to] += _updatedPayouts;
544 
545         // fire event
546         onMint(_to, _amountPaid, _amountOfTokens, _referredBy);
547 
548         return _amountOfTokens;
549     }
550 
551     /**
552      * Transfer tokens from the caller to a new holder.
553      * There's a small fee here that is redistributed to all token holders
554      */
555     function transferFor_(address _from, address _to, uint256 _amountOfTokens) internal returns(bool) {
556         require(_to != address(0));
557         require(tokenBalanceLedger_[_from] >= _amountOfTokens && tokenBalanceLedger_[_to] + _amountOfTokens >= tokenBalanceLedger_[_to]);
558 
559         // make sure we have the requested tokens
560         require(_amountOfTokens <= tokenBalanceLedger_[_from]);
561 
562         // withdraw all outstanding dividends first
563         if (getDividendsOf_(_from, true) > 0) {
564             withdraw_(_from);
565         }
566 
567         // liquify 10% of the tokens that are transferred
568         // these are dispersed to shareholders
569         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
570         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
571         uint256 _dividends = tokensToEther_(_tokenFee);
572 
573         // burn the fee tokens
574         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
575 
576         // exchange tokens
577         tokenBalanceLedger_[_from] = SafeMath.sub(tokenBalanceLedger_[_from], _amountOfTokens);
578         tokenBalanceLedger_[_to] = SafeMath.add(tokenBalanceLedger_[_to], _taxedTokens);
579 
580         // update dividend trackers
581         payoutsTo_[_from] -= (int256)(profitPerShare_ * _amountOfTokens);
582         payoutsTo_[_to] += (int256)(profitPerShare_ * _taxedTokens);
583 
584         // disperse dividends among holders
585         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
586 
587         // fire event
588         Transfer(_from, _to, _taxedTokens);
589 
590         // ERC20
591         return true;
592     }
593 
594     /**
595      * Retrieve the dividends of the owner.
596      */
597     function getDividendsOf_(address _recipient, bool _includeBonus) internal view returns(uint256) {
598         return _includeBonus ? dividendsOf(_recipient) + referralBalance_[_recipient] : dividendsOf(_recipient);
599     }
600 
601     /**
602      * Calculate Token price based on an amount of incoming ether;
603      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
604      */
605     function etherToTokens_(uint256 _ether) internal view returns(uint256) {
606         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
607         uint256 _tokensReceived =
608         (
609         (
610         // underflow attempts BTFO
611         SafeMath.sub(
612             (sqrt
613         (
614             (_tokenPriceInitial**2)
615             +
616             (2*(tokenPriceIncremental_ * 1e18)*(_ether * 1e18))
617             +
618             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
619             +
620             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
621         )
622             ), _tokenPriceInitial
623         )
624         )/(tokenPriceIncremental_)
625         )-(tokenSupply_);
626 
627         return _tokensReceived;
628     }
629 
630     /**
631      * Calculate token sell value.
632      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
633      */
634     function tokensToEther_(uint256 _tokens) internal view returns(uint256) {
635         uint256 tokens_ = (_tokens + 1e18);
636         uint256 _tokenSupply = (tokenSupply_ + 1e18);
637         uint256 _etherReceived =
638         (
639         // underflow attempts BTFO
640         SafeMath.sub(
641             (
642             (
643             (
644             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
645             )-tokenPriceIncremental_
646             )*(tokens_ - 1e18)
647             ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
648         )
649         /1e18);
650         return _etherReceived;
651     }
652 
653     /**
654      * Squirts gas! ;)
655      */
656     function sqrt(uint x) internal pure returns (uint y) {
657         uint z = (x + 1) / 2;
658         y = x;
659         while (z < y) {
660             y = z;
661             z = (x / z + z) / 2;
662         }
663     }
664 }