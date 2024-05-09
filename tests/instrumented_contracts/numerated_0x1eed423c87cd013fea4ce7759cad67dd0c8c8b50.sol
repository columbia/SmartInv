1 /**
2  * Copyright (c) 2019 blockimmo AG license@blockimmo.ch
3  * No license
4  */
5 
6 pragma solidity ^0.5.3;
7 
8 /**
9  * @title SafeMath
10  * @dev Unsigned math operations with safety checks that revert on error
11  */
12 library SafeMath {
13     /**
14     * @dev Multiplies two unsigned integers, reverts on overflow.
15     */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
18         // benefit is lost if 'b' is also tested.
19         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
20         if (a == 0) {
21             return 0;
22         }
23 
24         uint256 c = a * b;
25         require(c / a == b);
26 
27         return c;
28     }
29 
30     /**
31     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
32     */
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         // Solidity only automatically asserts when dividing by 0
35         require(b > 0);
36         uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38 
39         return c;
40     }
41 
42     /**
43     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
44     */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         require(b <= a);
47         uint256 c = a - b;
48 
49         return c;
50     }
51 
52     /**
53     * @dev Adds two unsigned integers, reverts on overflow.
54     */
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a);
58 
59         return c;
60     }
61 
62     /**
63     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
64     * reverts when dividing by zero.
65     */
66     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b != 0);
68         return a % b;
69     }
70 }
71 
72 /**
73  * @title ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/20
75  */
76 interface IERC20 {
77     function transfer(address to, uint256 value) external returns (bool);
78 
79     function approve(address spender, uint256 value) external returns (bool);
80 
81     function transferFrom(address from, address to, uint256 value) external returns (bool);
82 
83     function totalSupply() external view returns (uint256);
84 
85     function balanceOf(address who) external view returns (uint256);
86 
87     function allowance(address owner, address spender) external view returns (uint256);
88 
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 /**
95  * @title SafeERC20
96  * @dev Wrappers around ERC20 operations that throw on failure.
97  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
98  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
99  */
100 library SafeERC20 {
101     using SafeMath for uint256;
102 
103     function safeTransfer(IERC20 token, address to, uint256 value) internal {
104         require(token.transfer(to, value));
105     }
106 
107     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
108         require(token.transferFrom(from, to, value));
109     }
110 
111     function safeApprove(IERC20 token, address spender, uint256 value) internal {
112         // safeApprove should only be called when setting an initial allowance,
113         // or when resetting it to zero. To increase and decrease it, use
114         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
115         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
116         require(token.approve(spender, value));
117     }
118 
119     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
120         uint256 newAllowance = token.allowance(address(this), spender).add(value);
121         require(token.approve(spender, newAllowance));
122     }
123 
124     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
125         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
126         require(token.approve(spender, newAllowance));
127     }
128 }
129 
130 contract MoneyMarketInterface {
131   function getSupplyBalance(address account, address asset) public view returns (uint);
132   function supply(address asset, uint amount) public returns (uint);
133   function withdraw(address asset, uint requestedAmount) public returns (uint);
134 }
135 
136 contract LoanEscrow {
137   using SafeERC20 for IERC20;
138   using SafeMath for uint256;
139 
140   address public constant DAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;  // 0x9Ad61E35f8309aF944136283157FABCc5AD371E5;
141   IERC20 public dai = IERC20(DAI_ADDRESS);
142 
143   address public constant MONEY_MARKET_ADDRESS = 0x3FDA67f7583380E67ef93072294a7fAc882FD7E7;  // 0x6732c278C58FC90542cce498981844A073D693d7;
144   MoneyMarketInterface public moneyMarket = MoneyMarketInterface(MONEY_MARKET_ADDRESS);
145 
146   event Deposited(address indexed from, uint256 daiAmount);
147   event Pulled(address indexed to, uint256 daiAmount);
148   event InterestWithdrawn(address indexed to, uint256 daiAmount);
149 
150   mapping(address => uint256) public deposits;
151   mapping(address => uint256) public pulls;
152   uint256 public deposited;
153   uint256 public pulled;
154 
155   modifier onlyBlockimmo() {
156     require(msg.sender == blockimmo());
157     _;
158   }
159 
160   function blockimmo() public returns (address);
161 
162   function withdrawInterest() public onlyBlockimmo {
163     uint256 amountInterest = moneyMarket.getSupplyBalance(address(this), DAI_ADDRESS).add(pulled).sub(deposited);
164     require(amountInterest > 0, "no interest");
165 
166     uint256 errorCode = moneyMarket.withdraw(DAI_ADDRESS, amountInterest);
167     require(errorCode == 0, "withdraw failed");
168 
169     dai.safeTransfer(msg.sender, amountInterest);
170     emit InterestWithdrawn(msg.sender, amountInterest);
171   }
172 
173   function deposit(address _from, uint256 _amountDai) internal {
174     require(_from != address(0) && _amountDai > 0, "invalid parameter(s)");
175     dai.safeTransferFrom(msg.sender, address(this), _amountDai);
176 
177     require(dai.allowance(address(this), MONEY_MARKET_ADDRESS) == 0, "non-zero initial moneyMarket allowance");
178     require(dai.approve(MONEY_MARKET_ADDRESS, _amountDai), "approving moneyMarket failed");
179 
180     uint256 errorCode = moneyMarket.supply(DAI_ADDRESS, _amountDai);
181     require(errorCode == 0, "supply failed");
182     require(dai.allowance(address(this), MONEY_MARKET_ADDRESS) == 0, "allowance not fully consumed by moneyMarket");
183 
184     deposits[_from] = deposits[_from].add(_amountDai);
185     deposited = deposited.add(_amountDai);
186     emit Deposited(_from, _amountDai);
187   }
188 
189   function pull(address _to, uint256 _amountDai, bool refund) internal {
190     uint256 errorCode = moneyMarket.withdraw(DAI_ADDRESS, _amountDai);
191     require(errorCode == 0, "withdraw failed");
192 
193     if (refund) {
194       deposits[_to] = deposits[_to].sub(_amountDai);
195       deposited = deposited.sub(_amountDai);
196     } else {
197       pulls[_to] = pulls[_to].add(_amountDai);
198       pulled = pulled.add(_amountDai);
199     }
200 
201     dai.safeTransfer(_to, _amountDai);
202     emit Pulled(_to, _amountDai);
203   }
204 }
205 
206 /**
207  * @title Helps contracts guard against reentrancy attacks.
208  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
209  * @dev If you mark a function `nonReentrant`, you should also
210  * mark it `external`.
211  */
212 contract ReentrancyGuard {
213     /// @dev counter to allow mutex lock with only one SSTORE operation
214     uint256 private _guardCounter;
215 
216     constructor () internal {
217         // The counter starts at one to prevent changing it from zero to a non-zero
218         // value, which is a more expensive operation.
219         _guardCounter = 1;
220     }
221 
222     /**
223      * @dev Prevents a contract from calling itself, directly or indirectly.
224      * Calling a `nonReentrant` function from another `nonReentrant`
225      * function is not supported. It is possible to prevent this from happening
226      * by making the `nonReentrant` function external, and make it call a
227      * `private` function that does the actual work.
228      */
229     modifier nonReentrant() {
230         _guardCounter += 1;
231         uint256 localCounter = _guardCounter;
232         _;
233         require(localCounter == _guardCounter);
234     }
235 }
236 
237 /**
238  * @title Crowdsale
239  * @dev Crowdsale is a base contract for managing a token crowdsale,
240  * allowing investors to purchase tokens with ether. This contract implements
241  * such functionality in its most fundamental form and can be extended to provide additional
242  * functionality and/or custom behavior.
243  * The external interface represents the basic interface for purchasing tokens, and conform
244  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
245  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
246  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
247  * behavior.
248  */
249 contract Crowdsale is ReentrancyGuard {
250     using SafeMath for uint256;
251     using SafeERC20 for IERC20;
252 
253     // The token being sold
254     IERC20 private _token;
255 
256     // Address where funds are collected
257     address payable private _wallet;
258 
259     // How many token units a buyer gets per wei.
260     // The rate is the conversion between wei and the smallest and indivisible token unit.
261     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
262     // 1 wei will give you 1 unit, or 0.001 TOK.
263     uint256 private _rate;
264 
265     // Amount of wei raised
266     uint256 private _weiRaised;
267 
268     /**
269      * Event for token purchase logging
270      * @param purchaser who paid for the tokens
271      * @param beneficiary who got the tokens
272      * @param value weis paid for purchase
273      * @param amount amount of tokens purchased
274      */
275     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
276 
277     /**
278      * @param rate Number of token units a buyer gets per wei
279      * @dev The rate is the conversion between wei and the smallest and indivisible
280      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
281      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
282      * @param wallet Address where collected funds will be forwarded to
283      * @param token Address of the token being sold
284      */
285     constructor (uint256 rate, address payable wallet, IERC20 token) public {
286         require(rate > 0);
287         require(wallet != address(0));
288         require(address(token) != address(0));
289 
290         _rate = rate;
291         _wallet = wallet;
292         _token = token;
293     }
294 
295     /**
296      * @dev fallback function ***DO NOT OVERRIDE***
297      * Note that other contracts will transfer fund with a base gas stipend
298      * of 2300, which is not enough to call buyTokens. Consider calling
299      * buyTokens directly when purchasing tokens from a contract.
300      */
301     function () external payable {
302         buyTokens(msg.sender);
303     }
304 
305     /**
306      * @return the token being sold.
307      */
308     function token() public view returns (IERC20) {
309         return _token;
310     }
311 
312     /**
313      * @return the address where funds are collected.
314      */
315     function wallet() public view returns (address payable) {
316         return _wallet;
317     }
318 
319     /**
320      * @return the number of token units a buyer gets per wei.
321      */
322     function rate() public view returns (uint256) {
323         return _rate;
324     }
325 
326     /**
327      * @return the amount of wei raised.
328      */
329     function weiRaised() public view returns (uint256) {
330         return _weiRaised;
331     }
332 
333     /**
334      * @dev low level token purchase ***DO NOT OVERRIDE***
335      * This function has a non-reentrancy guard, so it shouldn't be called by
336      * another `nonReentrant` function.
337      * @param beneficiary Recipient of the token purchase
338      */
339     function buyTokens(address beneficiary) public nonReentrant payable {
340         uint256 weiAmount = _weiAmount();
341         _preValidatePurchase(beneficiary, weiAmount);
342 
343         // calculate token amount to be created
344         uint256 tokens = _getTokenAmount(weiAmount);
345 
346         // update state
347         _weiRaised = _weiRaised.add(weiAmount);
348 
349         _processPurchase(beneficiary, tokens);
350         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
351 
352         _updatePurchasingState(beneficiary, weiAmount);
353 
354         _forwardFunds();
355         _postValidatePurchase(beneficiary, weiAmount);
356     }
357 
358     /**
359      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
360      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
361      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
362      *     super._preValidatePurchase(beneficiary, weiAmount);
363      *     require(weiRaised().add(weiAmount) <= cap);
364      * @param beneficiary Address performing the token purchase
365      * @param weiAmount Value in wei involved in the purchase
366      */
367     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
368         require(beneficiary != address(0));
369         require(weiAmount != 0);
370     }
371 
372     /**
373      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
374      * conditions are not met.
375      * @param beneficiary Address performing the token purchase
376      * @param weiAmount Value in wei involved in the purchase
377      */
378     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
379         // solhint-disable-previous-line no-empty-blocks
380     }
381 
382     /**
383      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
384      * its tokens.
385      * @param beneficiary Address performing the token purchase
386      * @param tokenAmount Number of tokens to be emitted
387      */
388     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
389         _token.safeTransfer(beneficiary, tokenAmount);
390     }
391 
392     /**
393      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
394      * tokens.
395      * @param beneficiary Address receiving the tokens
396      * @param tokenAmount Number of tokens to be purchased
397      */
398     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
399         _deliverTokens(beneficiary, tokenAmount);
400     }
401 
402     /**
403      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
404      * etc.)
405      * @param beneficiary Address receiving the tokens
406      * @param weiAmount Value in wei involved in the purchase
407      */
408     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
409         // solhint-disable-previous-line no-empty-blocks
410     }
411 
412     /**
413      * @dev Override to extend the way in which ether is converted to tokens.
414      * @param weiAmount Value in wei to be converted into tokens
415      * @return Number of tokens that can be purchased with the specified _weiAmount
416      */
417     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
418         return weiAmount.mul(_rate);
419     }
420 
421     /**
422      * @dev Determines how ETH is stored/forwarded on purchases.
423      */
424     function _forwardFunds() internal {
425         _wallet.transfer(msg.value);
426     }
427 
428     /**
429      * @dev Determines the value (in Wei) included with a purchase.
430      */
431     function _weiAmount() internal view returns (uint256) {
432         return msg.value;
433     }
434 }
435 
436 /**
437  * @title CappedCrowdsale
438  * @dev Crowdsale with a limit for total contributions.
439  */
440 contract CappedCrowdsale is Crowdsale {
441     using SafeMath for uint256;
442 
443     uint256 private _cap;
444 
445     /**
446      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
447      * @param cap Max amount of wei to be contributed
448      */
449     constructor (uint256 cap) public {
450         require(cap > 0);
451         _cap = cap;
452     }
453 
454     /**
455      * @return the cap of the crowdsale.
456      */
457     function cap() public view returns (uint256) {
458         return _cap;
459     }
460 
461     /**
462      * @dev Checks whether the cap has been reached.
463      * @return Whether the cap was reached
464      */
465     function capReached() public view returns (bool) {
466         return weiRaised() >= _cap;
467     }
468 
469     /**
470      * @dev Extend parent behavior requiring purchase to respect the funding cap.
471      * @param beneficiary Token purchaser
472      * @param weiAmount Amount of wei contributed
473      */
474     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
475         super._preValidatePurchase(beneficiary, weiAmount);
476         require(weiRaised().add(weiAmount) <= _cap);
477     }
478 }
479 
480 /**
481  * @title TimedCrowdsale
482  * @dev Crowdsale accepting contributions only within a time frame.
483  */
484 contract TimedCrowdsale is Crowdsale {
485     using SafeMath for uint256;
486 
487     uint256 private _openingTime;
488     uint256 private _closingTime;
489 
490     /**
491      * @dev Reverts if not in crowdsale time range.
492      */
493     modifier onlyWhileOpen {
494         require(isOpen());
495         _;
496     }
497 
498     /**
499      * @dev Constructor, takes crowdsale opening and closing times.
500      * @param openingTime Crowdsale opening time
501      * @param closingTime Crowdsale closing time
502      */
503     constructor (uint256 openingTime, uint256 closingTime) public {
504         // solhint-disable-next-line not-rely-on-time
505         require(openingTime >= block.timestamp);
506         require(closingTime > openingTime);
507 
508         _openingTime = openingTime;
509         _closingTime = closingTime;
510     }
511 
512     /**
513      * @return the crowdsale opening time.
514      */
515     function openingTime() public view returns (uint256) {
516         return _openingTime;
517     }
518 
519     /**
520      * @return the crowdsale closing time.
521      */
522     function closingTime() public view returns (uint256) {
523         return _closingTime;
524     }
525 
526     /**
527      * @return true if the crowdsale is open, false otherwise.
528      */
529     function isOpen() public view returns (bool) {
530         // solhint-disable-next-line not-rely-on-time
531         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
532     }
533 
534     /**
535      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
536      * @return Whether crowdsale period has elapsed
537      */
538     function hasClosed() public view returns (bool) {
539         // solhint-disable-next-line not-rely-on-time
540         return block.timestamp > _closingTime;
541     }
542 
543     /**
544      * @dev Extend parent behavior requiring to be within contributing period
545      * @param beneficiary Token purchaser
546      * @param weiAmount Amount of wei contributed
547      */
548     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
549         super._preValidatePurchase(beneficiary, weiAmount);
550     }
551 }
552 
553 /**
554  * @title FinalizableCrowdsale
555  * @dev Extension of Crowdsale with a one-off finalization action, where one
556  * can do extra work after finishing.
557  */
558 contract FinalizableCrowdsale is TimedCrowdsale {
559     using SafeMath for uint256;
560 
561     bool private _finalized;
562 
563     event CrowdsaleFinalized();
564 
565     constructor () internal {
566         _finalized = false;
567     }
568 
569     /**
570      * @return true if the crowdsale is finalized, false otherwise.
571      */
572     function finalized() public view returns (bool) {
573         return _finalized;
574     }
575 
576     /**
577      * @dev Must be called after crowdsale ends, to do some extra finalization
578      * work. Calls the contract's finalization function.
579      */
580     function finalize() public {
581         require(!_finalized);
582         require(hasClosed());
583 
584         _finalized = true;
585 
586         _finalization();
587         emit CrowdsaleFinalized();
588     }
589 
590     /**
591      * @dev Can be overridden to add finalization logic. The overriding function
592      * should call super._finalization() to ensure the chain of finalization is
593      * executed entirely.
594      */
595     function _finalization() internal {
596         // solhint-disable-previous-line no-empty-blocks
597     }
598 }
599 
600 /**
601  * @title PostDeliveryCrowdsale
602  * @dev Crowdsale that locks tokens from withdrawal until it ends.
603  */
604 contract PostDeliveryCrowdsale is TimedCrowdsale {
605     using SafeMath for uint256;
606 
607     mapping(address => uint256) private _balances;
608 
609     /**
610      * @dev Withdraw tokens only after crowdsale ends.
611      * @param beneficiary Whose tokens will be withdrawn.
612      */
613     function withdrawTokens(address beneficiary) public {
614         require(hasClosed());
615         uint256 amount = _balances[beneficiary];
616         require(amount > 0);
617         _balances[beneficiary] = 0;
618         _deliverTokens(beneficiary, amount);
619     }
620 
621     /**
622      * @return the balance of an account.
623      */
624     function balanceOf(address account) public view returns (uint256) {
625         return _balances[account];
626     }
627 
628     /**
629      * @dev Overrides parent by storing balances instead of issuing tokens right away.
630      * @param beneficiary Token purchaser
631      * @param tokenAmount Amount of tokens purchased
632      */
633     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
634         _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
635     }
636 
637 }
638 
639 contract LandRegistryProxyInterface {
640   function owner() public view returns (address);
641 }
642 
643 contract WhitelistInterface {
644   function checkRole(address _operator, string memory _role) public view;
645   function hasRole(address _operator, string memory _role) public view returns (bool);
646 }
647 
648 contract WhitelistProxyInterface {
649   function whitelist() public view returns (WhitelistInterface);
650 }
651 
652 /**
653  * @title TokenSale
654  * @dev Distribute tokens to investors in exchange for Dai.
655  *
656  * This is the primary mechanism for outright sales of commercial investment properties (and blockimmo's STO, where shares
657  * of our company are represented as `TokenizedProperty`).
658  *
659  * Selling:
660  *   1. Deploy `TokenizedProperty`. Initially all tokens and ownership of this property will be assigned to the 'deployer'
661  *   2. Deploy `ShareholderDAO` and transfer the property's (1) ownership to it
662  *   3. Configure and deploy `TokenSale`
663  *     - After completing (1, 2, 3), blockimmo will verify the property as legitimate in `LandRegistry`
664  *     - blockimmo will then authorize `this` to the `Whitelist` before seller can proceed to (4)
665  *   4. Transfer tokens of `TokenizedProperty` (1) to be sold to `this` (3)
666  *   5. Investors are able to buy tokens while the sale is open. 'Deployer' calls `finalize` to complete the sale
667  *
668  * Note: blockimmo will be responsible for managing initial sales on our platform. This means we will be configuring
669  *       and deploying all contracts for sellers. This provides an extra layer of control/security until we've refined
670  *       these processes and proven them in the real-world.
671  *
672  * Unsold tokens (of a successful sale) are redistributed proportionally to investors via Airdrop, as described in:
673  * https://medium.com/FundFantasy/airdropping-vs-burning-part-1-613a9c6ebf1c
674  *
675  * If `goal` is not reached, investors will be refunded Dai, and the 'deployer' refunded tokens.
676  */
677 contract TokenSale is CappedCrowdsale, FinalizableCrowdsale, LoanEscrow, PostDeliveryCrowdsale {
678   address public constant LAND_REGISTRY_PROXY_ADDRESS = 0xe72AD2A335AE18e6C7cdb6dAEB64b0330883CD56;  // 0x0f5Ea0A652E851678Ebf77B69484bFcD31F9459B;
679   address public constant WHITELIST_PROXY_ADDRESS = 0x7223b032180CDb06Be7a3D634B1E10032111F367;  // 0xEC8bE1A5630364292E56D01129E8ee8A9578d7D8;
680 
681   LandRegistryProxyInterface public registryProxy = LandRegistryProxyInterface(LAND_REGISTRY_PROXY_ADDRESS);
682   WhitelistProxyInterface public whitelistProxy = WhitelistProxyInterface(WHITELIST_PROXY_ADDRESS);
683 
684   mapping(address => bool) public claimedRefund;
685   uint256 public goal;
686   mapping(address => bool) public reversed;
687   uint256 public totalTokens;
688 
689   constructor (
690     uint256 _cap,
691     uint256 _closingTime,
692     uint256 _goal,
693     uint256 _openingTime,
694     uint256 _rate,
695     IERC20 _token,
696     address payable _wallet
697   )
698   public
699     Crowdsale(_rate, _wallet, _token)
700     CappedCrowdsale(_cap)
701     FinalizableCrowdsale()
702     TimedCrowdsale(_openingTime, _closingTime)
703     PostDeliveryCrowdsale()
704   {
705     goal = _goal;
706   }
707 
708   function blockimmo() public returns (address) {
709     return registryProxy.owner();
710   }
711 
712   function claimRefund(address _refundee) public {
713     require(finalized() && !goalReached());
714     require(!claimedRefund[_refundee]);
715 
716     claimedRefund[_refundee] = true;
717     pull(_refundee, deposits[_refundee], true);
718   }
719 
720   function goalReached() public view returns (bool) {
721     return weiRaised() >= goal;
722   }
723 
724   function reverse(address _account) public onlyBlockimmo {
725     require(!finalized());
726     require(!reversed[_account]);
727     WhitelistInterface whitelist = whitelistProxy.whitelist();
728     require(!whitelist.hasRole(_account, "authorized"));
729 
730     reversed[_account] = true;
731     pull(_account, deposits[_account], true);
732   }
733 
734   function totalTokensSold() public view returns (uint256) {
735     return _getTokenAmount(weiRaised());
736   }
737 
738   function withdrawTokens(address beneficiary) public {  // airdrop remaining tokens to investors proportionally
739     require(finalized() && goalReached(), "withdrawTokens requires the TokenSale to be successfully finalized");
740     require(!reversed[beneficiary]);
741 
742     uint256 extra = totalTokens.sub(totalTokensSold()).mul(balanceOf(beneficiary)) / totalTokensSold();
743     _deliverTokens(beneficiary, extra);
744 
745     super.withdrawTokens(beneficiary);
746   }
747 
748   function weiRaised() public view returns (uint256) {
749     return deposited;
750   }
751 
752   function _finalization() internal {
753     require(msg.sender == blockimmo() || msg.sender == wallet());
754 
755     totalTokens = token().balanceOf(address(this));
756 
757     if (goalReached()) {
758       uint256 fee = weiRaised().div(100);
759 
760       pull(blockimmo(), fee, false);
761       pull(wallet(), weiRaised().sub(fee), false);
762     } else {
763       token().safeTransfer(wallet(), totalTokens);
764     }
765 
766     super._finalization();
767   }
768 
769   function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
770     deposit(beneficiary, weiAmount);
771   }
772 
773   function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
774     super._preValidatePurchase(beneficiary, weiAmount);
775 
776     require(!reversed[beneficiary]);
777 
778     WhitelistInterface whitelist = whitelistProxy.whitelist();
779     whitelist.checkRole(beneficiary, "authorized");
780     require(deposits[beneficiary].add(weiAmount) <= 100000e18 || whitelist.hasRole(beneficiary, "uncapped"));
781   }
782 
783   function _weiAmount() internal view returns (uint256) {
784     return dai.allowance(msg.sender, address(this));
785   }
786 }