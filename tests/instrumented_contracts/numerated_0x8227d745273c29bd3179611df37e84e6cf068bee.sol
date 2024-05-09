1 pragma solidity 0.5.3;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two unsigned integers, reverts on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two unsigned integers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 interface IERC20 {
72     function transfer(address to, uint256 value) external returns (bool);
73 
74     function approve(address spender, uint256 value) external returns (bool);
75 
76     function transferFrom(address from, address to, uint256 value) external returns (bool);
77 
78     function totalSupply() external view returns (uint256);
79 
80     function balanceOf(address who) external view returns (uint256);
81 
82     function allowance(address owner, address spender) external view returns (uint256);
83 
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 /**
90  * @title SafeERC20
91  * @dev Wrappers around ERC20 operations that throw on failure.
92  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
93  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
94  */
95 library SafeERC20 {
96     using SafeMath for uint256;
97 
98     function safeTransfer(IERC20 token, address to, uint256 value) internal {
99         require(token.transfer(to, value));
100     }
101 
102     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
103         require(token.transferFrom(from, to, value));
104     }
105 
106     function safeApprove(IERC20 token, address spender, uint256 value) internal {
107         // safeApprove should only be called when setting an initial allowance,
108         // or when resetting it to zero. To increase and decrease it, use
109         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
110         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
111         require(token.approve(spender, value));
112     }
113 
114     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
115         uint256 newAllowance = token.allowance(address(this), spender).add(value);
116         require(token.approve(spender, newAllowance));
117     }
118 
119     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
120         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
121         require(token.approve(spender, newAllowance));
122     }
123 }
124 
125 /**
126  * @title Helps contracts guard against reentrancy attacks.
127  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
128  * @dev If you mark a function `nonReentrant`, you should also
129  * mark it `external`.
130  */
131 contract ReentrancyGuard {
132     /// @dev counter to allow mutex lock with only one SSTORE operation
133     uint256 private _guardCounter;
134 
135     constructor () internal {
136         // The counter starts at one to prevent changing it from zero to a non-zero
137         // value, which is a more expensive operation.
138         _guardCounter = 1;
139     }
140 
141     /**
142      * @dev Prevents a contract from calling itself, directly or indirectly.
143      * Calling a `nonReentrant` function from another `nonReentrant`
144      * function is not supported. It is possible to prevent this from happening
145      * by making the `nonReentrant` function external, and make it call a
146      * `private` function that does the actual work.
147      */
148     modifier nonReentrant() {
149         _guardCounter += 1;
150         uint256 localCounter = _guardCounter;
151         _;
152         require(localCounter == _guardCounter);
153     }
154 }
155 
156 /**
157  * @title Crowdsale
158  * @dev Crowdsale is a base contract for managing a token crowdsale,
159  * allowing investors to purchase tokens with ether. This contract implements
160  * such functionality in its most fundamental form and can be extended to provide additional
161  * functionality and/or custom behavior.
162  * The external interface represents the basic interface for purchasing tokens, and conform
163  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
164  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
165  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
166  * behavior.
167  */
168 contract Crowdsale is ReentrancyGuard {
169     using SafeMath for uint256;
170     using SafeERC20 for IERC20;
171 
172     // The token being sold
173     IERC20 private _token;
174 
175     // Address where funds are collected
176     address payable private _wallet;
177 
178     // How many token units a buyer gets per wei.
179     // The rate is the conversion between wei and the smallest and indivisible token unit.
180     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
181     // 1 wei will give you 1 unit, or 0.001 TOK.
182     uint256 private _rate;
183 
184     // Amount of wei raised
185     uint256 private _weiRaised;
186 
187     /**
188      * Event for token purchase logging
189      * @param purchaser who paid for the tokens
190      * @param beneficiary who got the tokens
191      * @param value weis paid for purchase
192      * @param amount amount of tokens purchased
193      */
194     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
195 
196     /**
197      * @param rate Number of token units a buyer gets per wei
198      * @dev The rate is the conversion between wei and the smallest and indivisible
199      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
200      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
201      * @param wallet Address where collected funds will be forwarded to
202      * @param token Address of the token being sold
203      */
204     constructor (uint256 rate, address payable wallet, IERC20 token) public {
205         require(rate > 0);
206         require(wallet != address(0));
207         require(address(token) != address(0));
208 
209         _rate = rate;
210         _wallet = wallet;
211         _token = token;
212     }
213 
214     /**
215      * @dev fallback function ***DO NOT OVERRIDE***
216      * Note that other contracts will transfer fund with a base gas stipend
217      * of 2300, which is not enough to call buyTokens. Consider calling
218      * buyTokens directly when purchasing tokens from a contract.
219      */
220     function () external payable {
221         buyTokens(msg.sender);
222     }
223 
224     /**
225      * @return the token being sold.
226      */
227     function token() public view returns (IERC20) {
228         return _token;
229     }
230 
231     /**
232      * @return the address where funds are collected.
233      */
234     function wallet() public view returns (address payable) {
235         return _wallet;
236     }
237 
238     /**
239      * @return the number of token units a buyer gets per wei.
240      */
241     function rate() public view returns (uint256) {
242         return _rate;
243     }
244 
245     /**
246      * @return the amount of wei raised.
247      */
248     function weiRaised() public view returns (uint256) {
249         return _weiRaised;
250     }
251 
252     /**
253      * @dev low level token purchase ***DO NOT OVERRIDE***
254      * This function has a non-reentrancy guard, so it shouldn't be called by
255      * another `nonReentrant` function.
256      * @param beneficiary Recipient of the token purchase
257      */
258     function buyTokens(address beneficiary) public nonReentrant payable {
259         uint256 weiAmount = msg.value;
260         _preValidatePurchase(beneficiary, weiAmount);
261 
262         // calculate token amount to be created
263         uint256 tokens = _getTokenAmount(weiAmount);
264 
265         // update state
266         _weiRaised = _weiRaised.add(weiAmount);
267 
268         _processPurchase(beneficiary, tokens);
269         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
270 
271         _updatePurchasingState(beneficiary, weiAmount);
272 
273         _forwardFunds();
274         _postValidatePurchase(beneficiary, weiAmount);
275     }
276 
277     /**
278      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
279      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
280      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
281      *     super._preValidatePurchase(beneficiary, weiAmount);
282      *     require(weiRaised().add(weiAmount) <= cap);
283      * @param beneficiary Address performing the token purchase
284      * @param weiAmount Value in wei involved in the purchase
285      */
286     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
287         require(beneficiary != address(0));
288         require(weiAmount != 0);
289     }
290 
291     /**
292      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
293      * conditions are not met.
294      * @param beneficiary Address performing the token purchase
295      * @param weiAmount Value in wei involved in the purchase
296      */
297     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
298         // solhint-disable-previous-line no-empty-blocks
299     }
300 
301     /**
302      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
303      * its tokens.
304      * @param beneficiary Address performing the token purchase
305      * @param tokenAmount Number of tokens to be emitted
306      */
307     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
308         _token.safeTransfer(beneficiary, tokenAmount);
309     }
310 
311     /**
312      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
313      * tokens.
314      * @param beneficiary Address receiving the tokens
315      * @param tokenAmount Number of tokens to be purchased
316      */
317     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
318         _deliverTokens(beneficiary, tokenAmount);
319     }
320 
321     /**
322      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
323      * etc.)
324      * @param beneficiary Address receiving the tokens
325      * @param weiAmount Value in wei involved in the purchase
326      */
327     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
328         // solhint-disable-previous-line no-empty-blocks
329     }
330 
331     /**
332      * @dev Override to extend the way in which ether is converted to tokens.
333      * @param weiAmount Value in wei to be converted into tokens
334      * @return Number of tokens that can be purchased with the specified _weiAmount
335      */
336     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
337         return weiAmount.mul(_rate);
338     }
339 
340     /**
341      * @dev Determines how ETH is stored/forwarded on purchases.
342      */
343     function _forwardFunds() internal {
344         _wallet.transfer(msg.value);
345     }
346 }
347 
348 /**
349  * @title TimedCrowdsale
350  * @dev Crowdsale accepting contributions only within a time frame.
351  */
352 contract TimedCrowdsale is Crowdsale {
353     using SafeMath for uint256;
354 
355     uint256 private _openingTime;
356     uint256 private _closingTime;
357 
358     /**
359      * @dev Reverts if not in crowdsale time range.
360      */
361     modifier onlyWhileOpen {
362         require(isOpen());
363         _;
364     }
365 
366     /**
367      * @dev Constructor, takes crowdsale opening and closing times.
368      * @param openingTime Crowdsale opening time
369      * @param closingTime Crowdsale closing time
370      */
371     constructor (uint256 openingTime, uint256 closingTime) public {
372         // solhint-disable-next-line not-rely-on-time
373         require(openingTime >= block.timestamp);
374         require(closingTime > openingTime);
375 
376         _openingTime = openingTime;
377         _closingTime = closingTime;
378     }
379 
380     /**
381      * @return the crowdsale opening time.
382      */
383     function openingTime() public view returns (uint256) {
384         return _openingTime;
385     }
386 
387     /**
388      * @return the crowdsale closing time.
389      */
390     function closingTime() public view returns (uint256) {
391         return _closingTime;
392     }
393 
394     /**
395      * @return true if the crowdsale is open, false otherwise.
396      */
397     function isOpen() public view returns (bool) {
398         // solhint-disable-next-line not-rely-on-time
399         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
400     }
401 
402     /**
403      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
404      * @return Whether crowdsale period has elapsed
405      */
406     function hasClosed() public view returns (bool) {
407         // solhint-disable-next-line not-rely-on-time
408         return block.timestamp > _closingTime;
409     }
410 
411     /**
412      * @dev Extend parent behavior requiring to be within contributing period
413      * @param beneficiary Token purchaser
414      * @param weiAmount Amount of wei contributed
415      */
416     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
417         super._preValidatePurchase(beneficiary, weiAmount);
418     }
419 }
420 
421 /**
422  * @title Math
423  * @dev Assorted math operations
424  */
425 library Math {
426     /**
427     * @dev Returns the largest of two numbers.
428     */
429     function max(uint256 a, uint256 b) internal pure returns (uint256) {
430         return a >= b ? a : b;
431     }
432 
433     /**
434     * @dev Returns the smallest of two numbers.
435     */
436     function min(uint256 a, uint256 b) internal pure returns (uint256) {
437         return a < b ? a : b;
438     }
439 
440     /**
441     * @dev Calculates the average of two numbers. Since these are integers,
442     * averages of an even and odd number cannot be represented, and will be
443     * rounded down.
444     */
445     function average(uint256 a, uint256 b) internal pure returns (uint256) {
446         // (a + b) / 2 can overflow, so we distribute
447         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
448     }
449 }
450 
451 /**
452  * @title AllowanceCrowdsale
453  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
454  */
455 contract AllowanceCrowdsale is Crowdsale {
456     using SafeMath for uint256;
457     using SafeERC20 for IERC20;
458 
459     address private _tokenWallet;
460 
461     /**
462      * @dev Constructor, takes token wallet address.
463      * @param tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
464      */
465     constructor (address tokenWallet) public {
466         require(tokenWallet != address(0));
467         _tokenWallet = tokenWallet;
468     }
469 
470     /**
471      * @return the address of the wallet that will hold the tokens.
472      */
473     function tokenWallet() public view returns (address) {
474         return _tokenWallet;
475     }
476 
477     /**
478      * @dev Checks the amount of tokens left in the allowance.
479      * @return Amount of tokens left in the allowance
480      */
481     function remainingTokens() public view returns (uint256) {
482         return Math.min(token().balanceOf(_tokenWallet), token().allowance(_tokenWallet, address(this)));
483     }
484 
485     /**
486      * @dev Overrides parent behavior by transferring tokens from wallet.
487      * @param beneficiary Token purchaser
488      * @param tokenAmount Amount of tokens purchased
489      */
490     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
491         token().safeTransferFrom(_tokenWallet, beneficiary, tokenAmount);
492     }
493 }
494 
495 /**
496  * @title CappedCrowdsale
497  * @dev Crowdsale with a limit for total contributions.
498  */
499 contract CappedCrowdsale is Crowdsale {
500     using SafeMath for uint256;
501 
502     uint256 private _cap;
503 
504     /**
505      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
506      * @param cap Max amount of wei to be contributed
507      */
508     constructor (uint256 cap) public {
509         require(cap > 0);
510         _cap = cap;
511     }
512 
513     /**
514      * @return the cap of the crowdsale.
515      */
516     function cap() public view returns (uint256) {
517         return _cap;
518     }
519 
520     /**
521      * @dev Checks whether the cap has been reached.
522      * @return Whether the cap was reached
523      */
524     function capReached() public view returns (bool) {
525         return weiRaised() >= _cap;
526     }
527 
528     /**
529      * @dev Extend parent behavior requiring purchase to respect the funding cap.
530      * @param beneficiary Token purchaser
531      * @param weiAmount Amount of wei contributed
532      */
533     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
534         super._preValidatePurchase(beneficiary, weiAmount);
535         require(weiRaised().add(weiAmount) <= _cap);
536     }
537 }
538 
539 /**
540  * @title BitherPlatformCrowdsale
541  * @dev BitherCrowdsale contract uses multiple openzeppelin base contracts and adds some custom behaviour.
542  *      The openzeppelin base contracts have been audited and are widely used by the community. They can
543  *      be trusted to have almost zero security vulnerabilities and therefore do not need to be tested.
544  *      The BitherCrowdale enables the purchasing of 2 tokens, the BitherToken (BTR) and RentalProcessorToken (BRP) 
545  *      at rates determined by the current block time. It specifies a cap of Ether that can be contributed
546  *      and a length of time the crowdsale lasts. It requires the crowdsale contract address be given
547  *      an allowance of 33000000 BTR and 420000000 BRP enabling it to distribute the purchased tokens. These
548  *      values are determined by the cap of 300000 ETH and the phased distribution rates.
549  */
550 contract BitherPlatformCrowdsale is AllowanceCrowdsale, TimedCrowdsale, CappedCrowdsale {
551 
552     uint256 constant private CAP_IN_WEI = 300000 ether;
553 
554     uint256 constant private BTR_PRIVATE_SALE_RATE = 110;
555     uint256 constant private BTR_PRESALE_RATE_DAY_1 = 110;
556     uint256 constant private BTR_PRESALE_RATE_DAY_2_TO_5 = 109;
557     uint256 constant private BTR_PRESALE_RATE_DAY_6_TO_9 = 108;
558     uint256 constant private BTR_PRESALE_RATE_DAY_10_TO_13 = 107;
559 
560     uint256 constant private BTR_CROWDSALE_ROUND1_RATE_DAY_1_FIRST_2_HOURS = 110;
561     uint256 constant private BTR_CROWDSALE_ROUND1_RATE_DAY_1_TO_14 = 107;
562     uint256 constant private BTR_CROWDSALE_ROUND1_RATE_DAY_15_TO_28 = 106;
563 
564     uint256 constant private BTR_CROWDSALE_ROUND2_RATE_DAY_1_FIRST_2_HOURS = 110;
565     uint256 constant private BTR_CROWDSALE_ROUND2_RATE_DAY_1_TO_7 = 106;
566     uint256 constant private BTR_CROWDSALE_ROUND2_RATE_DAY_8_TO_14 = 104;
567     uint256 constant private BTR_CROWDSALE_ROUND2_RATE_DAY_15_TO_21 = 102;
568     uint256 constant private BTR_CROWDSALE_ROUND2_RATE_DAY_22_TO_28 = 100;
569 
570     uint256 constant private BRP_PRIVATE_SALE_RATE = 1400;
571     uint256 constant private BRP_PRESALE_RATE_FIRST_2_HOURS = 1400;
572     uint256 constant private BRP_PRESALE_RATE_DAY_1_TO_5 = 1380;
573     uint256 constant private BRP_PRESALE_RATE_DAY_6_TO_13 = 1360;
574 
575     uint256 constant private BRP_CROWDSALE_ROUND1_RATE_DAY_1_TO_7 = 1340;
576     uint256 constant private BRP_CROWDSALE_ROUND1_RATE_DAY_8_TO_21 = 1320;
577     uint256 constant private BRP_CROWDSALE_ROUND1_RATE_DAY_22_TO_28 = 1300;
578 
579     uint256 constant private BRP_CROWDSALE_ROUND2_RATE_DAY_1_TO_7 = 1240;
580     uint256 constant private BRP_CROWDSALE_ROUND2_RATE_DAY_8_TO_14 = 1160;
581     uint256 constant private BRP_CROWDSALE_ROUND2_RATE_DAY_15_TO_21 = 1080;
582     uint256 constant private BRP_CROWDSALE_ROUND2_RATE_DAY_22_TO_28 = 1000;
583 
584     IERC20 private _rentalProcessorToken;
585     uint256 private _privateSaleClosingTime; // Friday, March 22, 2019 12:00:00 AM (1553212800)
586     uint256 private _presaleOpeningTime; // Saturday, March 23, 2019 2:00:00 PM (1553349600)
587     uint256 private _crowdsaleRound1OpeningTime; // Saturday, April 20, 2019 2:00:00 PM (1555768800)
588     uint256 private _crowdsaleRound2OpeningTime; // Saturday, June 1, 2019 2:00:00 PM (1559397600)
589 
590     /**
591      * Event for BRP token purchase logging
592      * @param purchaser Who paid for the tokens
593      * @param beneficiary Who got the tokens
594      * @param value Wei paid for purchase
595      * @param amount Amount of tokens purchased
596      */
597     event RentalProcessorTokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
598 
599     /**
600      * @dev Constructor, calls the inherited classes constructors, stores RentalProcessorToken and determines crowdsale times
601      * @param bitherToken The BitherToken address, must be an ERC20 contract
602      * @param rentalProcessorToken The RentalProcessorToken, must be an ERC20 contract
603      * @param bitherTokensOwner Address holding the tokens, which has approved allowance to the crowdsale
604      * @param etherBenefactor Address that will receive the deposited Ether
605      * @param preSaleOpeningTime The presale opening time, in seconds, all other times are determined using this to reduce risk of error
606      */
607     constructor(IERC20 bitherToken, IERC20 rentalProcessorToken, address bitherTokensOwner, address payable etherBenefactor, uint256 preSaleOpeningTime)
608         Crowdsale(BTR_PRIVATE_SALE_RATE, etherBenefactor, bitherToken)
609         AllowanceCrowdsale(bitherTokensOwner)
610         TimedCrowdsale(now, preSaleOpeningTime + 14 weeks)
611         CappedCrowdsale(CAP_IN_WEI)
612         public
613     {
614         _rentalProcessorToken = rentalProcessorToken;
615 
616         _privateSaleClosingTime = preSaleOpeningTime - 38 hours;
617         _presaleOpeningTime = preSaleOpeningTime;
618         _crowdsaleRound1OpeningTime = preSaleOpeningTime + 4 weeks;
619         _crowdsaleRound2OpeningTime = preSaleOpeningTime + 10 weeks;
620     }
621 
622     /**
623      * @dev Overrides function in the Crowdsale contract to revert contributions less then
624      *      50 Eth during the first period and less than 0.1 Eth during the rest of the crowdsale
625      * @param beneficiary Address performing the token purchase
626      * @param weiAmount Value in wei involved in the purchase
627      */
628     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
629         super._preValidatePurchase(beneficiary, weiAmount);
630 
631         if (now < _privateSaleClosingTime) {
632             require(weiAmount >= 50 ether, "Not enough Eth. Contributions must be 50 Eth minimum during the private sale");
633         } else {
634             require(weiAmount >= 100 finney, "Not enough Eth. Contributions must be 0.1 Eth minimum during the presale and crowdsale (Round 1 and Round 2)");
635         }
636 
637         if (now > _privateSaleClosingTime && now < _presaleOpeningTime) {
638             revert("Private sale has ended and the presale is yet to begin");
639         } else if (now > _presaleOpeningTime + 13 days && now < _crowdsaleRound1OpeningTime) {
640             revert("Presale has ended and the crowdsale (Round 1) is yet to begin");
641         } else if (now > _crowdsaleRound1OpeningTime + 4 weeks && now < _crowdsaleRound2OpeningTime) {
642             revert("crowdsale (Round 1) has ended and the crowdsale (Round 2) is yet to begin");
643         }
644     }
645 
646     /**
647      * @dev Overrides function in the Crowdsale contract to enable a custom phased distribution
648      * @param weiAmount Value in wei to be converted into tokens
649      * @return Number of tokens that can be purchased with the specified weiAmount
650      */
651     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
652 
653         if (now < _privateSaleClosingTime) {
654             return weiAmount.mul(BTR_PRIVATE_SALE_RATE);
655         } else if (now < _presaleOpeningTime + 1 days) {
656             return weiAmount.mul(BTR_PRESALE_RATE_DAY_1);
657         } else if (now < _presaleOpeningTime + 5 days) {
658             return weiAmount.mul(BTR_PRESALE_RATE_DAY_2_TO_5);
659         } else if (now < _presaleOpeningTime + 9 days) {
660             return weiAmount.mul(BTR_PRESALE_RATE_DAY_6_TO_9);
661         } else if (now < _presaleOpeningTime + 13 days) {
662             return weiAmount.mul(BTR_PRESALE_RATE_DAY_10_TO_13);
663 
664         } else if (now < _crowdsaleRound1OpeningTime + 2 hours) {
665             return weiAmount.mul(BTR_CROWDSALE_ROUND1_RATE_DAY_1_FIRST_2_HOURS);
666         } else if (now < _crowdsaleRound1OpeningTime + 2 weeks) {
667             return weiAmount.mul(BTR_CROWDSALE_ROUND1_RATE_DAY_1_TO_14);
668         } else if (now < _crowdsaleRound1OpeningTime + 4 weeks) {
669             return weiAmount.mul(BTR_CROWDSALE_ROUND1_RATE_DAY_15_TO_28);
670 
671         } else if (now < _crowdsaleRound2OpeningTime + 2 hours) {
672             return weiAmount.mul(BTR_CROWDSALE_ROUND2_RATE_DAY_1_FIRST_2_HOURS);
673         } else if (now < _crowdsaleRound2OpeningTime + 1 weeks) {
674             return weiAmount.mul(BTR_CROWDSALE_ROUND2_RATE_DAY_1_TO_7);
675         } else if (now < _crowdsaleRound2OpeningTime + 2 weeks) {
676             return weiAmount.mul(BTR_CROWDSALE_ROUND2_RATE_DAY_8_TO_14);
677         } else if (now < _crowdsaleRound2OpeningTime + 3 weeks) {
678             return weiAmount.mul(BTR_CROWDSALE_ROUND2_RATE_DAY_15_TO_21);
679         } else if (now < closingTime()) {
680             return weiAmount.mul(BTR_CROWDSALE_ROUND2_RATE_DAY_22_TO_28);
681         }
682     }
683 
684     /**
685      * @dev Overrides function in AllowanceCrowdsale contract (therefore also overrides function
686      *      in Crowdsale contract) to add functionality for distribution of a second token, BRP.
687      * @param beneficiary Token purchaser
688      * @param tokenAmount Amount of tokens purchased
689      */
690     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
691         super._deliverTokens(beneficiary, tokenAmount);
692 
693         uint256 weiAmount = msg.value;
694         uint256 brpTokenAmount = getBrpTokenAmount(weiAmount);
695 
696         _rentalProcessorToken.safeTransferFrom(tokenWallet(), beneficiary, brpTokenAmount);
697 
698         emit RentalProcessorTokensPurchased(msg.sender, beneficiary, weiAmount, brpTokenAmount);
699     }
700 
701     /**
702      * @dev Determines distribution of BRP depending on the time of the transaction
703      * @param weiAmount Value in wei to be converted into tokens
704      * @return Number of tokens that can be purchased with the specified weiAmount
705      */
706     function getBrpTokenAmount(uint256 weiAmount) private view returns (uint256) {
707 
708         if (now < _privateSaleClosingTime) {
709             return weiAmount.mul(BRP_PRIVATE_SALE_RATE);
710 
711         } else if (now < _presaleOpeningTime + 2 hours) {
712             return weiAmount.mul(BRP_PRESALE_RATE_FIRST_2_HOURS);
713         } else if (now < _presaleOpeningTime + 5 days) {
714             return weiAmount.mul(BRP_PRESALE_RATE_DAY_1_TO_5);
715         } else if (now < _presaleOpeningTime + 13 days) {
716             return weiAmount.mul(BRP_PRESALE_RATE_DAY_6_TO_13);
717 
718         } else if (now < _crowdsaleRound1OpeningTime + 1 weeks) {
719             return weiAmount.mul(BRP_CROWDSALE_ROUND1_RATE_DAY_1_TO_7);
720         } else if (now < _crowdsaleRound1OpeningTime + 3 weeks) {
721             return weiAmount.mul(BRP_CROWDSALE_ROUND1_RATE_DAY_8_TO_21);
722         } else if (now <= _crowdsaleRound1OpeningTime + 4 weeks) {
723             return weiAmount.mul(BRP_CROWDSALE_ROUND1_RATE_DAY_22_TO_28);
724         
725         } else if (now < _crowdsaleRound2OpeningTime + 1 weeks) {
726             return weiAmount.mul(BRP_CROWDSALE_ROUND2_RATE_DAY_1_TO_7);
727         } else if (now < _crowdsaleRound2OpeningTime + 2 weeks) {
728             return weiAmount.mul(BRP_CROWDSALE_ROUND2_RATE_DAY_8_TO_14);
729         } else if (now < _crowdsaleRound2OpeningTime + 3 weeks) {
730             return weiAmount.mul(BRP_CROWDSALE_ROUND2_RATE_DAY_15_TO_21);
731         } else if (now <= closingTime()) {
732             return weiAmount.mul(BRP_CROWDSALE_ROUND2_RATE_DAY_22_TO_28);
733         }
734     }
735 }