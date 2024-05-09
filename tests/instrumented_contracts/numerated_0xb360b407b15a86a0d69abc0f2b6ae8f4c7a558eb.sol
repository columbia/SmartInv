1 pragma solidity ^0.4.25;
2 
3 /* solium-disable error-reason */
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two numbers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29      */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Adds two numbers, reverts on overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60      * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61      * reverts when dividing by zero.
62      */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 /**
70  * @title SafeERC20
71  * @dev Wrappers around ERC20 operations that throw on failure.
72  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
73  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
74  */
75 library SafeERC20 {
76     using SafeMath for uint256;
77 
78     function safeTransfer(IERC20 token, address to, uint256 value) internal {
79         require(token.transfer(to, value));
80     }
81 
82     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
83         require(token.transferFrom(from, to, value));
84     }
85 
86     function safeApprove(IERC20 token, address spender, uint256 value) internal {
87         // safeApprove should only be called when setting an initial allowance,
88         // or when resetting it to zero. To increase and decrease it, use
89         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
90         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
91         require(token.approve(spender, value));
92     }
93 
94     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
95         uint256 newAllowance = token.allowance(address(this), spender).add(value);
96         require(token.approve(spender, newAllowance));
97     }
98 
99     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
100         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
101         require(token.approve(spender, newAllowance));
102     }
103 }
104 
105 /**
106  * @title ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/20
108  */
109 interface IERC20 {
110     function totalSupply() external view returns (uint256);
111 
112     function balanceOf(address who) external view returns (uint256);
113 
114     function allowance(address owner, address spender) external view returns (uint256);
115 
116     function transfer(address to, uint256 value) external returns (bool);
117 
118     function approve(address spender, uint256 value) external returns (bool);
119 
120     function transferFrom(address from, address to, uint256 value) external returns (bool);
121 
122     event Transfer(address indexed from, address indexed to, uint256 value);
123 
124     event Approval(address indexed owner, address indexed spender, uint256 value);
125 }
126 
127 /**
128  * @title Helps contracts guard against reentrancy attacks.
129  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
130  * @dev If you mark a function `nonReentrant`, you should also
131  * mark it `external`.
132  */
133 contract ReentrancyGuard {
134     /// @dev counter to allow mutex lock with only one SSTORE operation
135     uint256 private _guardCounter;
136 
137     constructor () internal {
138         // The counter starts at one to prevent changing it from zero to a non-zero
139         // value, which is a more expensive operation.
140         _guardCounter = 1;
141     }
142 
143     /**
144      * @dev Prevents a contract from calling itself, directly or indirectly.
145      * Calling a `nonReentrant` function from another `nonReentrant`
146      * function is not supported. It is possible to prevent this from happening
147      * by making the `nonReentrant` function external, and make it call a
148      * `private` function that does the actual work.
149      */
150     modifier nonReentrant() {
151         _guardCounter += 1;
152         uint256 localCounter = _guardCounter;
153         _;
154         require(localCounter == _guardCounter);
155     }
156 }
157 
158 /**
159  * @title Crowdsale
160  * @dev Crowdsale is a base contract for managing a token crowdsale,
161  * allowing investors to purchase tokens with ether. This contract implements
162  * such functionality in its most fundamental form and can be extended to provide additional
163  * functionality and/or custom behavior.
164  * The external interface represents the basic interface for purchasing tokens, and conform
165  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
166  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
167  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
168  * behavior.
169  */
170 contract Crowdsale is ReentrancyGuard {
171     using SafeMath for uint256;
172     using SafeERC20 for IERC20;
173 
174     // The token being sold
175     IERC20 private _token;
176 
177     // Address where funds are collected
178     address private _wallet;
179 
180     // How many token units a buyer gets per wei.
181     // The rate is the conversion between wei and the smallest and indivisible token unit.
182     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
183     // 1 wei will give you 1 unit, or 0.001 TOK.
184     uint256 private _rate;
185 
186     // Amount of wei raised
187     uint256 private _weiRaised;
188 
189     /**
190      * Event for token purchase logging
191      * @param purchaser who paid for the tokens
192      * @param beneficiary who got the tokens
193      * @param value weis paid for purchase
194      * @param amount amount of tokens purchased
195      */
196     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
197 
198     /**
199      * @param rate Number of token units a buyer gets per wei
200      * @dev The rate is the conversion between wei and the smallest and indivisible
201      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
202      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
203      * @param wallet Address where collected funds will be forwarded to
204      * @param token Address of the token being sold
205      */
206     constructor (uint256 rate, address wallet, IERC20 token) internal {
207         require(rate > 0);
208         require(wallet != address(0));
209         require(token != address(0));
210 
211         _rate = rate;
212         _wallet = wallet;
213         _token = token;
214     }
215 
216     // -----------------------------------------
217     // Crowdsale external interface
218     // -----------------------------------------
219 
220     /**
221      * @dev fallback function ***DO NOT OVERRIDE***
222      * Note that other contracts will transfer fund with a base gas stipend
223      * of 2300, which is not enough to call buyTokens. Consider calling
224      * buyTokens directly when purchasing tokens from a contract.
225      */
226     function () external payable {
227         buyTokens(msg.sender);
228     }
229 
230     /**
231      * @return the token being sold.
232      */
233     function token() public view returns (IERC20) {
234         return _token;
235     }
236 
237     /**
238      * @return the address where funds are collected.
239      */
240     function wallet() public view returns (address) {
241         return _wallet;
242     }
243 
244     /**
245      * @return the number of token units a buyer gets per wei.
246      */
247     function rate() public view returns (uint256) {
248         return _rate;
249     }
250 
251     /**
252      * @return the amount of wei raised.
253      */
254     function weiRaised() public view returns (uint256) {
255         return _weiRaised;
256     }
257 
258     /**
259      * @dev low level token purchase ***DO NOT OVERRIDE***
260      * This function has a non-reentrancy guard, so it shouldn't be called by
261      * another `nonReentrant` function.
262      * @param beneficiary Recipient of the token purchase
263      */
264     function buyTokens(address beneficiary) public nonReentrant payable {
265         uint256 weiAmount = msg.value;
266         _preValidatePurchase(beneficiary, weiAmount);
267 
268         // calculate token amount to be created
269         uint256 tokens = _getTokenAmount(weiAmount);
270 
271         // update state
272         _weiRaised = _weiRaised.add(weiAmount);
273 
274         _processPurchase(beneficiary, tokens);
275         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
276 
277         _updatePurchasingState(beneficiary, weiAmount);
278 
279         _forwardFunds();
280         _postValidatePurchase(beneficiary, weiAmount);
281     }
282 
283     // -----------------------------------------
284     // Internal interface (extensible)
285     // -----------------------------------------
286 
287     /**
288      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
289      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
290      *     super._preValidatePurchase(beneficiary, weiAmount);
291      *     require(weiRaised().add(weiAmount) <= cap);
292      * @param beneficiary Address performing the token purchase
293      * @param weiAmount Value in wei involved in the purchase
294      */
295     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
296         require(beneficiary != address(0));
297         require(weiAmount != 0);
298     }
299 
300     /**
301      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
302      * @param beneficiary Address performing the token purchase
303      * @param weiAmount Value in wei involved in the purchase
304      */
305     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
306         // optional override
307     }
308 
309     /**
310      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
311      * @param beneficiary Address performing the token purchase
312      * @param tokenAmount Number of tokens to be emitted
313      */
314     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
315         _token.safeTransfer(beneficiary, tokenAmount);
316     }
317 
318     /**
319      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send tokens.
320      * @param beneficiary Address receiving the tokens
321      * @param tokenAmount Number of tokens to be purchased
322      */
323     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
324         _deliverTokens(beneficiary, tokenAmount);
325     }
326 
327     /**
328      * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
329      * @param beneficiary Address receiving the tokens
330      * @param weiAmount Value in wei involved in the purchase
331      */
332     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
333         // optional override
334     }
335 
336     /**
337      * @dev Override to extend the way in which ether is converted to tokens.
338      * @param weiAmount Value in wei to be converted into tokens
339      * @return Number of tokens that can be purchased with the specified _weiAmount
340      */
341     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
342         return weiAmount.mul(_rate);
343     }
344 
345     /**
346      * @dev Determines how ETH is stored/forwarded on purchases.
347      */
348     function _forwardFunds() internal {
349         _wallet.transfer(msg.value);
350     }
351 }
352 
353 /**
354  * @title CappedCrowdsale
355  * @dev Crowdsale with a limit for total contributions.
356  */
357 contract CappedCrowdsale is Crowdsale {
358     using SafeMath for uint256;
359 
360     uint256 private _cap;
361 
362     /**
363      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
364      * @param cap Max amount of wei to be contributed
365      */
366     constructor (uint256 cap) internal {
367         require(cap > 0);
368         _cap = cap;
369     }
370 
371     /**
372      * @return the cap of the crowdsale.
373      */
374     function cap() public view returns (uint256) {
375         return _cap;
376     }
377 
378     /**
379      * @dev Checks whether the cap has been reached.
380      * @return Whether the cap was reached
381      */
382     function capReached() public view returns (bool) {
383         return weiRaised() >= _cap;
384     }
385 
386     /**
387      * @dev Extend parent behavior requiring purchase to respect the funding cap.
388      * @param beneficiary Token purchaser
389      * @param weiAmount Amount of wei contributed
390      */
391     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
392         super._preValidatePurchase(beneficiary, weiAmount);
393         require(weiRaised().add(weiAmount) <= _cap);
394     }
395 }
396 
397 /**
398  * @title TimedCrowdsale
399  * @dev Crowdsale accepting contributions only within a time frame.
400  */
401 contract TimedCrowdsale is Crowdsale {
402     using SafeMath for uint256;
403 
404     uint256 private _openingTime;
405     uint256 private _closingTime;
406 
407     /**
408      * @dev Reverts if not in crowdsale time range.
409      */
410     modifier onlyWhileOpen {
411         require(isOpen());
412         _;
413     }
414 
415     /**
416      * @dev Constructor, takes crowdsale opening and closing times.
417      * @param openingTime Crowdsale opening time
418      * @param closingTime Crowdsale closing time
419      */
420     constructor (uint256 openingTime, uint256 closingTime) internal {
421         // solium-disable-next-line security/no-block-members
422         require(openingTime >= block.timestamp);
423         require(closingTime > openingTime);
424 
425         _openingTime = openingTime;
426         _closingTime = closingTime;
427     }
428 
429     /**
430      * @return the crowdsale opening time.
431      */
432     function openingTime() public view returns (uint256) {
433         return _openingTime;
434     }
435 
436     /**
437      * @return the crowdsale closing time.
438      */
439     function closingTime() public view returns (uint256) {
440         return _closingTime;
441     }
442 
443     /**
444      * @return true if the crowdsale is open, false otherwise.
445      */
446     function isOpen() public view returns (bool) {
447         // solium-disable-next-line security/no-block-members
448         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
449     }
450 
451     /**
452      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
453      * @return Whether crowdsale period has elapsed
454      */
455     function hasClosed() public view returns (bool) {
456         // solium-disable-next-line security/no-block-members
457         return block.timestamp > _closingTime;
458     }
459 
460     /**
461      * @dev Extend parent behavior requiring to be within contributing period
462      * @param beneficiary Token purchaser
463      * @param weiAmount Amount of wei contributed
464      */
465     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
466         super._preValidatePurchase(beneficiary, weiAmount);
467     }
468 }
469 
470 /**
471  * @title FthCrowdsale
472  */
473 contract FthCrowdsale is CappedCrowdsale, TimedCrowdsale {
474     using SafeMath for uint256;
475 
476     uint256 constant MIN_WEI_AMOUNT = 0.1 ether;
477 
478     uint256 private _rewardPeriod;
479     uint256 private _unlockPeriod;
480 
481     struct Contribution {
482         uint256 contributeTime;
483         uint256 buyTokenAmount;
484         uint256 rewardTokenAmount;
485         uint256 lastWithdrawTime;
486         uint256 withdrawPercent;
487     }
488 
489     mapping(address => Contribution[]) private _contributions;
490 
491     constructor (
492         uint256 rewardPeriod,
493         uint256 unlockPeriod,
494         uint256 cap,
495         uint256 openingTime,
496         uint256 closingTime,
497         uint256 rate,
498         address wallet,
499         IERC20 token
500     )
501         public
502         CappedCrowdsale(cap)
503         TimedCrowdsale(openingTime, closingTime)
504         Crowdsale(rate, wallet, token)
505     {
506         _rewardPeriod = rewardPeriod;
507         _unlockPeriod = unlockPeriod;
508     }
509 
510     function contributionsOf(address beneficiary)
511         public
512         view
513         returns (
514             uint256[] memory contributeTimes,
515             uint256[] memory buyTokenAmounts,
516             uint256[] memory rewardTokenAmounts,
517             uint256[] memory lastWithdrawTimes,
518             uint256[] memory withdrawPercents
519         )
520     {
521         Contribution[] memory contributions = _contributions[beneficiary];
522 
523         uint256 length = contributions.length;
524 
525         contributeTimes = new uint256[](length);
526         buyTokenAmounts = new uint256[](length);
527         rewardTokenAmounts = new uint256[](length);
528         lastWithdrawTimes = new uint256[](length);
529         withdrawPercents = new uint256[](length);
530 
531         for (uint256 i = 0; i < length; i++) {
532             contributeTimes[i] = contributions[i].contributeTime;
533             buyTokenAmounts[i] = contributions[i].buyTokenAmount;
534             rewardTokenAmounts[i] = contributions[i].rewardTokenAmount;
535             lastWithdrawTimes[i] = contributions[i].lastWithdrawTime;
536             withdrawPercents[i] = contributions[i].withdrawPercent;
537         }
538     }
539 
540     function withdrawTokens(address beneficiary) public {
541         require(isOver());
542 
543         if (msg.sender == beneficiary && msg.sender == wallet()) {
544             _withdrawTokensToWallet();
545         } else {
546             _withdrawTokensTo(beneficiary);
547         }
548     }
549 
550     function unlockBalanceOf(address beneficiary) public view returns (uint256) {
551         uint256 unlockBalance = 0;
552 
553         Contribution[] memory contributions = _contributions[beneficiary];
554 
555         for (uint256 i = 0; i < contributions.length; i++) {
556             uint256 unlockPercent = _unlockPercent(contributions[i]);
557 
558             if (unlockPercent == 0) {
559                 continue;
560             }
561 
562             unlockBalance = unlockBalance.add(
563                 contributions[i].buyTokenAmount.mul(unlockPercent).div(100)
564             ).add(
565                 contributions[i].rewardTokenAmount.mul(unlockPercent).div(100)
566             );
567         }
568 
569         return unlockBalance;
570     }
571 
572     function rewardTokenAmount(uint256 buyTokenAmount) public view returns (uint256) {
573         if (!isOpen()) {
574             return 0;
575         }
576 
577         uint256 rewardTokenPercent = 0;
578 
579         // solium-disable-next-line security/no-block-members
580         uint256 timePeriod = block.timestamp.sub(openingTime()).div(_rewardPeriod);
581 
582         if (timePeriod < 1) {
583             rewardTokenPercent = 15;
584         } else if (timePeriod < 2) {
585             rewardTokenPercent = 10;
586         } else if (timePeriod < 3) {
587             rewardTokenPercent = 5;
588         } else {
589             return 0;
590         }
591 
592         return buyTokenAmount.mul(rewardTokenPercent).div(100);
593     }
594 
595     function rewardPeriod() public view returns (uint256) {
596         return _rewardPeriod;
597     }
598 
599     function unlockPeriod() public view returns (uint256) {
600         return _unlockPeriod;
601     }
602 
603     function isOver() public view returns (bool) {
604         return capReached() || hasClosed();
605     }
606 
607     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
608         require(weiAmount >= MIN_WEI_AMOUNT);
609 
610         super._preValidatePurchase(beneficiary, weiAmount);
611     }
612 
613     function _processPurchase(address beneficiary, uint256 buyTokenAmount) internal {
614         Contribution[] storage contributions = _contributions[beneficiary];
615         require(contributions.length < 100);
616 
617         contributions.push(Contribution({
618             // solium-disable-next-line security/no-block-members
619             contributeTime: block.timestamp,
620             buyTokenAmount: buyTokenAmount,
621             rewardTokenAmount: rewardTokenAmount(buyTokenAmount),
622             lastWithdrawTime: 0,
623             withdrawPercent: 0
624         }));
625     }
626 
627     function _withdrawTokensToWallet() private {
628         uint256 balanceTokenAmount = token().balanceOf(address(this));
629         require(balanceTokenAmount > 0);
630 
631         _deliverTokens(wallet(), balanceTokenAmount);
632     }
633 
634     function _withdrawTokensTo(address beneficiary) private {
635         uint256 unlockBalance = unlockBalanceOf(beneficiary);
636         require(unlockBalance > 0);
637 
638         Contribution[] storage contributions = _contributions[beneficiary];
639 
640         for (uint256 i = 0; i < contributions.length; i++) {
641             uint256 unlockPercent = _unlockPercent(contributions[i]);
642 
643             if (unlockPercent == 0) {
644                 continue;
645             }
646 
647             // solium-disable-next-line security/no-block-members
648             contributions[i].lastWithdrawTime = block.timestamp;
649             contributions[i].withdrawPercent = contributions[i].withdrawPercent.add(unlockPercent);
650         }
651 
652         _deliverTokens(beneficiary, unlockBalance);
653     }
654 
655     function _unlockPercent(Contribution memory contribution) private view returns (uint256) {
656         if (contribution.withdrawPercent >= 100) {
657             return 0;
658         }
659 
660         uint256 baseTimestamp = contribution.contributeTime;
661 
662         if (contribution.lastWithdrawTime > baseTimestamp) {
663             baseTimestamp = contribution.lastWithdrawTime;
664         }
665 
666         // solium-disable-next-line security/no-block-members
667         uint256 period = block.timestamp.sub(baseTimestamp);
668 
669         if (period < _unlockPeriod) {
670             return 0;
671         }
672 
673         uint256 unlockPercent = period.div(_unlockPeriod).sub(1).mul(10);
674 
675         if (contribution.withdrawPercent == 0) {
676             unlockPercent = unlockPercent.add(50);
677         } else {
678             unlockPercent = unlockPercent.add(10);
679         }
680 
681         uint256 max = 100 - contribution.withdrawPercent;
682 
683         if (unlockPercent > max) {
684             unlockPercent = max;
685         }
686 
687         return unlockPercent;
688     }
689 }