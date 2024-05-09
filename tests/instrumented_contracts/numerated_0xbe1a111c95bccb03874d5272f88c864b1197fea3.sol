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
130 /**
131  * @title Roles
132  * @dev Library for managing addresses assigned to a Role.
133  */
134 library Roles {
135     struct Role {
136         mapping (address => bool) bearer;
137     }
138 
139     /**
140      * @dev give an account access to this role
141      */
142     function add(Role storage role, address account) internal {
143         require(account != address(0));
144         require(!has(role, account));
145 
146         role.bearer[account] = true;
147     }
148 
149     /**
150      * @dev remove an account's access to this role
151      */
152     function remove(Role storage role, address account) internal {
153         require(account != address(0));
154         require(has(role, account));
155 
156         role.bearer[account] = false;
157     }
158 
159     /**
160      * @dev check if an account has this role
161      * @return bool
162      */
163     function has(Role storage role, address account) internal view returns (bool) {
164         require(account != address(0));
165         return role.bearer[account];
166     }
167 }
168 
169 contract PauserRole {
170     using Roles for Roles.Role;
171 
172     event PauserAdded(address indexed account);
173     event PauserRemoved(address indexed account);
174 
175     Roles.Role private _pausers;
176 
177     constructor () internal {
178         _addPauser(msg.sender);
179     }
180 
181     modifier onlyPauser() {
182         require(isPauser(msg.sender));
183         _;
184     }
185 
186     function isPauser(address account) public view returns (bool) {
187         return _pausers.has(account);
188     }
189 
190     function addPauser(address account) public onlyPauser {
191         _addPauser(account);
192     }
193 
194     function renouncePauser() public {
195         _removePauser(msg.sender);
196     }
197 
198     function _addPauser(address account) internal {
199         _pausers.add(account);
200         emit PauserAdded(account);
201     }
202 
203     function _removePauser(address account) internal {
204         _pausers.remove(account);
205         emit PauserRemoved(account);
206     }
207 }
208 
209 /**
210  * @title Pausable
211  * @dev Base contract which allows children to implement an emergency stop mechanism.
212  */
213 contract Pausable is PauserRole {
214     event Paused(address account);
215     event Unpaused(address account);
216 
217     bool private _paused;
218 
219     constructor () internal {
220         _paused = false;
221     }
222 
223     /**
224      * @return true if the contract is paused, false otherwise.
225      */
226     function paused() public view returns (bool) {
227         return _paused;
228     }
229 
230     /**
231      * @dev Modifier to make a function callable only when the contract is not paused.
232      */
233     modifier whenNotPaused() {
234         require(!_paused);
235         _;
236     }
237 
238     /**
239      * @dev Modifier to make a function callable only when the contract is paused.
240      */
241     modifier whenPaused() {
242         require(_paused);
243         _;
244     }
245 
246     /**
247      * @dev called by the owner to pause, triggers stopped state
248      */
249     function pause() public onlyPauser whenNotPaused {
250         _paused = true;
251         emit Paused(msg.sender);
252     }
253 
254     /**
255      * @dev called by the owner to unpause, returns to normal state
256      */
257     function unpause() public onlyPauser whenPaused {
258         _paused = false;
259         emit Unpaused(msg.sender);
260     }
261 }
262 
263 contract MoneyMarketInterface {
264   function getSupplyBalance(address account, address asset) public view returns (uint);
265   function supply(address asset, uint amount) public returns (uint);
266   function withdraw(address asset, uint requestedAmount) public returns (uint);
267 }
268 
269 contract LoanEscrow is Pausable {
270   using SafeERC20 for IERC20;
271   using SafeMath for uint256;
272 
273   // configurable to any ERC20 (i.e. xCHF)
274   address public constant DAI_ADDRESS = 0xB4272071eCAdd69d933AdcD19cA99fe80664fc08;  // 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;  // 0x9Ad61E35f8309aF944136283157FABCc5AD371E5;
275   IERC20 public dai = IERC20(DAI_ADDRESS);
276 
277   address public constant MONEY_MARKET_ADDRESS = 0x3FDA67f7583380E67ef93072294a7fAc882FD7E7;  // 0x6732c278C58FC90542cce498981844A073D693d7;
278   MoneyMarketInterface public moneyMarket = MoneyMarketInterface(MONEY_MARKET_ADDRESS);
279 
280   event Deposited(address indexed from, uint256 daiAmount);
281   event InterestWithdrawn(address indexed to, uint256 daiAmount);
282   event Pulled(address indexed to, uint256 daiAmount);
283 
284   mapping(address => uint256) public deposits;
285   mapping(address => uint256) public pulls;
286   uint256 public deposited;
287   uint256 public pulled;
288 
289   modifier onlyBlockimmo() {
290     require(msg.sender == blockimmo(), "onlyBlockimmo");
291     _;
292   }
293 
294   function blockimmo() public view returns (address);
295 
296   function withdrawInterest() public onlyBlockimmo {
297     uint256 amountInterest = moneyMarket.getSupplyBalance(address(this), DAI_ADDRESS).add(dai.balanceOf(address(this))).add(pulled).sub(deposited);
298     require(amountInterest > 0, "no interest");
299 
300     uint256 errorCode = moneyMarket.withdraw(DAI_ADDRESS, amountInterest);
301     require(errorCode == 0, "withdraw failed");
302 
303     dai.safeTransfer(msg.sender, amountInterest);
304     emit InterestWithdrawn(msg.sender, amountInterest);
305   }
306 
307   function deposit(address _from, uint256 _amountDai) internal {
308     require(_from != address(0) && _amountDai > 0, "invalid parameter(s)");
309 
310     dai.safeTransferFrom(msg.sender, address(this), _amountDai);
311 
312     if (!paused()) {
313       require(dai.allowance(address(this), MONEY_MARKET_ADDRESS) == 0, "non-zero initial moneyMarket allowance");
314       require(dai.approve(MONEY_MARKET_ADDRESS, _amountDai), "approving moneyMarket failed");
315 
316       uint256 errorCode = moneyMarket.supply(DAI_ADDRESS, _amountDai);
317       require(errorCode == 0, "supply failed");
318       require(dai.allowance(address(this), MONEY_MARKET_ADDRESS) == 0, "allowance not fully consumed by moneyMarket");
319     }
320 
321     deposits[_from] = deposits[_from].add(_amountDai);
322     deposited = deposited.add(_amountDai);
323     emit Deposited(_from, _amountDai);
324   }
325 
326   function pull(address _to, uint256 _amountDai, bool _refund) internal {
327     require(_to != address(0) && _amountDai > 0, "invalid parameter(s)");
328 
329     uint256 errorCode = (_amountDai > dai.balanceOf(address(this))) ? moneyMarket.withdraw(DAI_ADDRESS, _amountDai.sub(dai.balanceOf(address(this)))) : 0;
330     require(errorCode == 0, "withdraw failed");
331 
332     if (_refund) {
333       deposits[_to] = deposits[_to].sub(_amountDai);
334       deposited = deposited.sub(_amountDai);
335     } else {
336       pulls[_to] = pulls[_to].add(_amountDai);
337       pulled = pulled.add(_amountDai);
338     }
339 
340     dai.safeTransfer(_to, _amountDai);
341     emit Pulled(_to, _amountDai);
342   }
343 }
344 
345 /**
346  * @title Helps contracts guard against reentrancy attacks.
347  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
348  * @dev If you mark a function `nonReentrant`, you should also
349  * mark it `external`.
350  */
351 contract ReentrancyGuard {
352     /// @dev counter to allow mutex lock with only one SSTORE operation
353     uint256 private _guardCounter;
354 
355     constructor () internal {
356         // The counter starts at one to prevent changing it from zero to a non-zero
357         // value, which is a more expensive operation.
358         _guardCounter = 1;
359     }
360 
361     /**
362      * @dev Prevents a contract from calling itself, directly or indirectly.
363      * Calling a `nonReentrant` function from another `nonReentrant`
364      * function is not supported. It is possible to prevent this from happening
365      * by making the `nonReentrant` function external, and make it call a
366      * `private` function that does the actual work.
367      */
368     modifier nonReentrant() {
369         _guardCounter += 1;
370         uint256 localCounter = _guardCounter;
371         _;
372         require(localCounter == _guardCounter);
373     }
374 }
375 
376 /**
377  * @title Crowdsale
378  * @dev Crowdsale is a base contract for managing a token crowdsale,
379  * allowing investors to purchase tokens with ether. This contract implements
380  * such functionality in its most fundamental form and can be extended to provide additional
381  * functionality and/or custom behavior.
382  * The external interface represents the basic interface for purchasing tokens, and conform
383  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
384  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
385  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
386  * behavior.
387  */
388 contract Crowdsale is ReentrancyGuard {
389     using SafeMath for uint256;
390     using SafeERC20 for IERC20;
391 
392     // The token being sold
393     IERC20 private _token;
394 
395     // Address where funds are collected
396     address payable private _wallet;
397 
398     // How many token units a buyer gets per wei.
399     // The rate is the conversion between wei and the smallest and indivisible token unit.
400     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
401     // 1 wei will give you 1 unit, or 0.001 TOK.
402     uint256 private _rate;
403 
404     // Amount of wei raised
405     uint256 private _weiRaised;
406 
407     /**
408      * Event for token purchase logging
409      * @param purchaser who paid for the tokens
410      * @param beneficiary who got the tokens
411      * @param value weis paid for purchase
412      * @param amount amount of tokens purchased
413      */
414     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
415 
416     /**
417      * @param rate Number of token units a buyer gets per wei
418      * @dev The rate is the conversion between wei and the smallest and indivisible
419      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
420      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
421      * @param wallet Address where collected funds will be forwarded to
422      * @param token Address of the token being sold
423      */
424     constructor (uint256 rate, address payable wallet, IERC20 token) public {
425         require(rate > 0);
426         require(wallet != address(0));
427         require(address(token) != address(0));
428 
429         _rate = rate;
430         _wallet = wallet;
431         _token = token;
432     }
433 
434     /**
435      * @dev fallback function ***DO NOT OVERRIDE***
436      * Note that other contracts will transfer fund with a base gas stipend
437      * of 2300, which is not enough to call buyTokens. Consider calling
438      * buyTokens directly when purchasing tokens from a contract.
439      */
440     function () external payable {
441         buyTokens(msg.sender);
442     }
443 
444     /**
445      * @return the token being sold.
446      */
447     function token() public view returns (IERC20) {
448         return _token;
449     }
450 
451     /**
452      * @return the address where funds are collected.
453      */
454     function wallet() public view returns (address payable) {
455         return _wallet;
456     }
457 
458     /**
459      * @return the number of token units a buyer gets per wei.
460      */
461     function rate() public view returns (uint256) {
462         return _rate;
463     }
464 
465     /**
466      * @return the amount of wei raised.
467      */
468     function weiRaised() public view returns (uint256) {
469         return _weiRaised;
470     }
471 
472     /**
473      * @dev low level token purchase ***DO NOT OVERRIDE***
474      * This function has a non-reentrancy guard, so it shouldn't be called by
475      * another `nonReentrant` function.
476      * @param beneficiary Recipient of the token purchase
477      */
478     function buyTokens(address beneficiary) public nonReentrant payable {
479         uint256 weiAmount = _weiAmount();
480         _preValidatePurchase(beneficiary, weiAmount);
481 
482         // calculate token amount to be created
483         uint256 tokens = _getTokenAmount(weiAmount);
484 
485         // update state
486         _weiRaised = _weiRaised.add(weiAmount);
487 
488         _processPurchase(beneficiary, tokens);
489         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
490 
491         _updatePurchasingState(beneficiary, weiAmount);
492 
493         _forwardFunds();
494         _postValidatePurchase(beneficiary, weiAmount);
495     }
496 
497     /**
498      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
499      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
500      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
501      *     super._preValidatePurchase(beneficiary, weiAmount);
502      *     require(weiRaised().add(weiAmount) <= cap);
503      * @param beneficiary Address performing the token purchase
504      * @param weiAmount Value in wei involved in the purchase
505      */
506     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
507         require(beneficiary != address(0));
508         require(weiAmount != 0);
509     }
510 
511     /**
512      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
513      * conditions are not met.
514      * @param beneficiary Address performing the token purchase
515      * @param weiAmount Value in wei involved in the purchase
516      */
517     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
518         // solhint-disable-previous-line no-empty-blocks
519     }
520 
521     /**
522      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
523      * its tokens.
524      * @param beneficiary Address performing the token purchase
525      * @param tokenAmount Number of tokens to be emitted
526      */
527     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
528         _token.safeTransfer(beneficiary, tokenAmount);
529     }
530 
531     /**
532      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
533      * tokens.
534      * @param beneficiary Address receiving the tokens
535      * @param tokenAmount Number of tokens to be purchased
536      */
537     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
538         _deliverTokens(beneficiary, tokenAmount);
539     }
540 
541     /**
542      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
543      * etc.)
544      * @param beneficiary Address receiving the tokens
545      * @param weiAmount Value in wei involved in the purchase
546      */
547     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
548         // solhint-disable-previous-line no-empty-blocks
549     }
550 
551     /**
552      * @dev Override to extend the way in which ether is converted to tokens.
553      * @param weiAmount Value in wei to be converted into tokens
554      * @return Number of tokens that can be purchased with the specified _weiAmount
555      */
556     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
557         return weiAmount.mul(_rate);
558     }
559 
560     /**
561      * @dev Determines how ETH is stored/forwarded on purchases.
562      */
563     function _forwardFunds() internal {
564         _wallet.transfer(msg.value);
565     }
566 
567     /**
568      * @dev Determines the value (in Wei) included with a purchase.
569      */
570     function _weiAmount() internal view returns (uint256) {
571         return msg.value;
572     }
573 }
574 
575 /**
576  * @title CappedCrowdsale
577  * @dev Crowdsale with a limit for total contributions.
578  */
579 contract CappedCrowdsale is Crowdsale {
580     using SafeMath for uint256;
581 
582     uint256 private _cap;
583 
584     /**
585      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
586      * @param cap Max amount of wei to be contributed
587      */
588     constructor (uint256 cap) public {
589         require(cap > 0);
590         _cap = cap;
591     }
592 
593     /**
594      * @return the cap of the crowdsale.
595      */
596     function cap() public view returns (uint256) {
597         return _cap;
598     }
599 
600     /**
601      * @dev Checks whether the cap has been reached.
602      * @return Whether the cap was reached
603      */
604     function capReached() public view returns (bool) {
605         return weiRaised() >= _cap;
606     }
607 
608     /**
609      * @dev Extend parent behavior requiring purchase to respect the funding cap.
610      * @param beneficiary Token purchaser
611      * @param weiAmount Amount of wei contributed
612      */
613     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
614         super._preValidatePurchase(beneficiary, weiAmount);
615         require(weiRaised().add(weiAmount) <= _cap);
616     }
617 }
618 
619 /**
620  * @title TimedCrowdsale
621  * @dev Crowdsale accepting contributions only within a time frame.
622  */
623 contract TimedCrowdsale is Crowdsale {
624     using SafeMath for uint256;
625 
626     uint256 private _openingTime;
627     uint256 private _closingTime;
628 
629     /**
630      * @dev Reverts if not in crowdsale time range.
631      */
632     modifier onlyWhileOpen {
633         require(isOpen());
634         _;
635     }
636 
637     /**
638      * @dev Constructor, takes crowdsale opening and closing times.
639      * @param openingTime Crowdsale opening time
640      * @param closingTime Crowdsale closing time
641      */
642     constructor (uint256 openingTime, uint256 closingTime) public {
643         // solhint-disable-next-line not-rely-on-time
644         require(openingTime >= block.timestamp);
645         require(closingTime > openingTime);
646 
647         _openingTime = openingTime;
648         _closingTime = closingTime;
649     }
650 
651     /**
652      * @return the crowdsale opening time.
653      */
654     function openingTime() public view returns (uint256) {
655         return _openingTime;
656     }
657 
658     /**
659      * @return the crowdsale closing time.
660      */
661     function closingTime() public view returns (uint256) {
662         return _closingTime;
663     }
664 
665     /**
666      * @return true if the crowdsale is open, false otherwise.
667      */
668     function isOpen() public view returns (bool) {
669         // solhint-disable-next-line not-rely-on-time
670         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
671     }
672 
673     /**
674      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
675      * @return Whether crowdsale period has elapsed
676      */
677     function hasClosed() public view returns (bool) {
678         // solhint-disable-next-line not-rely-on-time
679         return block.timestamp > _closingTime;
680     }
681 
682     /**
683      * @dev Extend parent behavior requiring to be within contributing period
684      * @param beneficiary Token purchaser
685      * @param weiAmount Amount of wei contributed
686      */
687     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
688         super._preValidatePurchase(beneficiary, weiAmount);
689     }
690 }
691 
692 /**
693  * @title FinalizableCrowdsale
694  * @dev Extension of Crowdsale with a one-off finalization action, where one
695  * can do extra work after finishing.
696  */
697 contract FinalizableCrowdsale is TimedCrowdsale {
698     using SafeMath for uint256;
699 
700     bool private _finalized;
701 
702     event CrowdsaleFinalized();
703 
704     constructor () internal {
705         _finalized = false;
706     }
707 
708     /**
709      * @return true if the crowdsale is finalized, false otherwise.
710      */
711     function finalized() public view returns (bool) {
712         return _finalized;
713     }
714 
715     /**
716      * @dev Must be called after crowdsale ends, to do some extra finalization
717      * work. Calls the contract's finalization function.
718      */
719     function finalize() public {
720         require(!_finalized);
721         require(hasClosed());
722 
723         _finalized = true;
724 
725         _finalization();
726         emit CrowdsaleFinalized();
727     }
728 
729     /**
730      * @dev Can be overridden to add finalization logic. The overriding function
731      * should call super._finalization() to ensure the chain of finalization is
732      * executed entirely.
733      */
734     function _finalization() internal {
735         // solhint-disable-previous-line no-empty-blocks
736     }
737 }
738 
739 /**
740  * @title PostDeliveryCrowdsale
741  * @dev Crowdsale that locks tokens from withdrawal until it ends.
742  */
743 contract PostDeliveryCrowdsale is TimedCrowdsale {
744     using SafeMath for uint256;
745 
746     mapping(address => uint256) private _balances;
747 
748     /**
749      * @dev Withdraw tokens only after crowdsale ends.
750      * @param beneficiary Whose tokens will be withdrawn.
751      */
752     function withdrawTokens(address beneficiary) public {
753         require(hasClosed());
754         uint256 amount = _balances[beneficiary];
755         require(amount > 0);
756         _balances[beneficiary] = 0;
757         _deliverTokens(beneficiary, amount);
758     }
759 
760     /**
761      * @return the balance of an account.
762      */
763     function balanceOf(address account) public view returns (uint256) {
764         return _balances[account];
765     }
766 
767     /**
768      * @dev Overrides parent by storing balances instead of issuing tokens right away.
769      * @param beneficiary Token purchaser
770      * @param tokenAmount Amount of tokens purchased
771      */
772     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
773         _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
774     }
775 
776 }
777 
778 contract LandRegistryProxyInterface {
779   function owner() public view returns (address);
780 }
781 
782 contract WhitelistInterface {
783   function checkRole(address _operator, string memory _role) public view;
784   function hasRole(address _operator, string memory _role) public view returns (bool);
785 }
786 
787 contract WhitelistProxyInterface {
788   function whitelist() public view returns (WhitelistInterface);
789 }
790 
791 /**
792  * @title TokenSale
793  * @dev Distribute tokens to investors in exchange for Dai.
794  *
795  * This is the primary mechanism for outright sales of commercial investment properties (and blockimmo's STO, where shares
796  * of our company are represented as `TokenizedProperty`).
797  *
798  * Selling:
799  *   1. Deploy `TokenizedProperty`. Initially all tokens and ownership of this property will be assigned to the 'deployer'
800  *   2. Deploy `ShareholderDAO` and transfer the property's (1) ownership to it
801  *   3. Configure and deploy `TokenSale`
802  *     - After completing (1, 2, 3), blockimmo will verify the property as legitimate in `LandRegistry`
803  *     - blockimmo will then authorize `this` to the `Whitelist` before seller can proceed to (4)
804  *   4. Transfer tokens of `TokenizedProperty` (1) to be sold to `this` (3)
805  *   5. Investors are able to buy tokens while the sale is open. 'Deployer' calls `finalize` to complete the sale
806  *
807  * Note: blockimmo will be responsible for managing initial sales on our platform. This means we will be configuring
808  *       and deploying all contracts for sellers. This provides an extra layer of control/security until we've refined
809  *       these processes and proven them in the real-world.
810  *
811  * Unsold tokens (of a successful sale) are redistributed proportionally to investors via Airdrop, as described in:
812  * https://medium.com/FundFantasy/airdropping-vs-burning-part-1-613a9c6ebf1c
813  *
814  * If `goal` is not reached, investors will be refunded Dai, and the 'deployer' refunded tokens.
815  */
816 contract TokenSale is CappedCrowdsale, FinalizableCrowdsale, LoanEscrow, PostDeliveryCrowdsale {
817   address public constant LAND_REGISTRY_PROXY_ADDRESS = 0xe72AD2A335AE18e6C7cdb6dAEB64b0330883CD56;  // 0x0f5Ea0A652E851678Ebf77B69484bFcD31F9459B;
818   address public constant WHITELIST_PROXY_ADDRESS = 0x7223b032180CDb06Be7a3D634B1E10032111F367;  // 0xEC8bE1A5630364292E56D01129E8ee8A9578d7D8;
819 
820   LandRegistryProxyInterface public registryProxy = LandRegistryProxyInterface(LAND_REGISTRY_PROXY_ADDRESS);
821   WhitelistProxyInterface public whitelistProxy = WhitelistProxyInterface(WHITELIST_PROXY_ADDRESS);
822 
823   mapping(address => bool) public claimedRefund;
824   uint256 public goal;
825   mapping(address => bool) public reversed;
826   uint256 public totalTokens;
827 
828   constructor (
829     uint256 _cap,
830     uint256 _closingTime,
831     uint256 _goal,
832     uint256 _openingTime,
833     uint256 _rate,
834     IERC20 _token,
835     address payable _wallet
836   )
837   public
838     Crowdsale(_rate, _wallet, _token)
839     CappedCrowdsale(_cap)
840     FinalizableCrowdsale()
841     TimedCrowdsale(_openingTime, _closingTime)
842     PostDeliveryCrowdsale()
843   {
844     goal = _goal;
845   }
846 
847   function blockimmo() public view returns (address) {
848     return registryProxy.owner();
849   }
850 
851   function claimRefund(address _refundee) public {
852     require(finalized() && !goalReached());
853     require(!claimedRefund[_refundee]);
854 
855     claimedRefund[_refundee] = true;
856     pull(_refundee, deposits[_refundee], true);
857   }
858 
859   function goalReached() public view returns (bool) {
860     return weiRaised() >= goal;
861   }
862 
863   function reverse(address _account) public {
864     require(!finalized());
865     require(!reversed[_account]);
866     WhitelistInterface whitelist = whitelistProxy.whitelist();
867     require(!whitelist.hasRole(_account, "authorized"));
868 
869     reversed[_account] = true;
870     pull(_account, deposits[_account], true);
871   }
872 
873   function totalTokensSold() public view returns (uint256) {
874     return _getTokenAmount(weiRaised());
875   }
876 
877   function withdrawTokens(address beneficiary) public {  // airdrop remaining tokens to investors proportionally
878     require(finalized() && goalReached(), "withdrawTokens requires the TokenSale to be successfully finalized");
879     require(!reversed[beneficiary]);
880 
881     uint256 extra = totalTokens.sub(totalTokensSold()).mul(balanceOf(beneficiary)).div(totalTokensSold());
882     _deliverTokens(beneficiary, extra);
883 
884     super.withdrawTokens(beneficiary);
885   }
886 
887   function weiRaised() public view returns (uint256) {
888     return deposited;
889   }
890 
891   function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
892     return weiAmount.div(rate());
893   }
894 
895   function _finalization() internal {
896     require(msg.sender == blockimmo() || msg.sender == wallet());
897     super._finalization();
898 
899     totalTokens = token().balanceOf(address(this));
900 
901     if (goalReached()) {
902       uint256 fee = weiRaised().div(100);
903 
904       pull(blockimmo(), fee, false);
905       pull(wallet(), weiRaised().sub(fee), false);
906     } else {
907       token().safeTransfer(wallet(), totalTokens);
908     }
909   }
910 
911   function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
912     super._processPurchase(beneficiary, tokenAmount);
913     deposit(beneficiary, tokenAmount.mul(rate()));
914   }
915 
916   function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
917     require(weiAmount % rate() == 0, "rounding loss");
918     require(!reversed[beneficiary]);
919 
920     super._preValidatePurchase(beneficiary, weiAmount);
921 
922     WhitelistInterface whitelist = whitelistProxy.whitelist();
923     whitelist.checkRole(beneficiary, "authorized");
924     require(deposits[beneficiary].add(weiAmount) <= 100000e18 || whitelist.hasRole(beneficiary, "uncapped"));
925   }
926 
927   function _weiAmount() internal view returns (uint256) {
928     return dai.allowance(msg.sender, address(this));
929   }
930 }