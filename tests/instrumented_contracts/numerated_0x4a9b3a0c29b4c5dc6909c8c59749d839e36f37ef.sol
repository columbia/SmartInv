1 /**
2  * Copyright (c) 2019 blockimmo AG license@blockimmo.ch
3  * No license
4  */
5 
6 pragma solidity ^0.5.4;
7 
8 library Roles {
9     struct Role {
10         mapping (address => bool) bearer;
11     }
12 
13     /**
14      * @dev give an account access to this role
15      */
16     function add(Role storage role, address account) internal {
17         require(account != address(0));
18         require(!has(role, account));
19 
20         role.bearer[account] = true;
21     }
22 
23     /**
24      * @dev remove an account's access to this role
25      */
26     function remove(Role storage role, address account) internal {
27         require(account != address(0));
28         require(has(role, account));
29 
30         role.bearer[account] = false;
31     }
32 
33     /**
34      * @dev check if an account has this role
35      * @return bool
36      */
37     function has(Role storage role, address account) internal view returns (bool) {
38         require(account != address(0));
39         return role.bearer[account];
40     }
41 }
42 
43 contract PauserRole {
44     using Roles for Roles.Role;
45 
46     event PauserAdded(address indexed account);
47     event PauserRemoved(address indexed account);
48 
49     Roles.Role private _pausers;
50 
51     constructor () internal {
52         _addPauser(msg.sender);
53     }
54 
55     modifier onlyPauser() {
56         require(isPauser(msg.sender));
57         _;
58     }
59 
60     function isPauser(address account) public view returns (bool) {
61         return _pausers.has(account);
62     }
63 
64     function addPauser(address account) public onlyPauser {
65         _addPauser(account);
66     }
67 
68     function renouncePauser() public {
69         _removePauser(msg.sender);
70     }
71 
72     function _addPauser(address account) internal {
73         _pausers.add(account);
74         emit PauserAdded(account);
75     }
76 
77     function _removePauser(address account) internal {
78         _pausers.remove(account);
79         emit PauserRemoved(account);
80     }
81 }
82 
83 contract Pausable is PauserRole {
84     event Paused(address account);
85     event Unpaused(address account);
86 
87     bool private _paused;
88 
89     constructor () internal {
90         _paused = false;
91     }
92 
93     /**
94      * @return true if the contract is paused, false otherwise.
95      */
96     function paused() public view returns (bool) {
97         return _paused;
98     }
99 
100     /**
101      * @dev Modifier to make a function callable only when the contract is not paused.
102      */
103     modifier whenNotPaused() {
104         require(!_paused);
105         _;
106     }
107 
108     /**
109      * @dev Modifier to make a function callable only when the contract is paused.
110      */
111     modifier whenPaused() {
112         require(_paused);
113         _;
114     }
115 
116     /**
117      * @dev called by the owner to pause, triggers stopped state
118      */
119     function pause() public onlyPauser whenNotPaused {
120         _paused = true;
121         emit Paused(msg.sender);
122     }
123 
124     /**
125      * @dev called by the owner to unpause, returns to normal state
126      */
127     function unpause() public onlyPauser whenPaused {
128         _paused = false;
129         emit Unpaused(msg.sender);
130     }
131 }
132 
133 library SafeMath {
134     /**
135      * @dev Multiplies two unsigned integers, reverts on overflow.
136      */
137     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
138         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
139         // benefit is lost if 'b' is also tested.
140         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
141         if (a == 0) {
142             return 0;
143         }
144 
145         uint256 c = a * b;
146         require(c / a == b);
147 
148         return c;
149     }
150 
151     /**
152      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
153      */
154     function div(uint256 a, uint256 b) internal pure returns (uint256) {
155         // Solidity only automatically asserts when dividing by 0
156         require(b > 0);
157         uint256 c = a / b;
158         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
159 
160         return c;
161     }
162 
163     /**
164      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
165      */
166     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
167         require(b <= a);
168         uint256 c = a - b;
169 
170         return c;
171     }
172 
173     /**
174      * @dev Adds two unsigned integers, reverts on overflow.
175      */
176     function add(uint256 a, uint256 b) internal pure returns (uint256) {
177         uint256 c = a + b;
178         require(c >= a);
179 
180         return c;
181     }
182 
183     /**
184      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
185      * reverts when dividing by zero.
186      */
187     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
188         require(b != 0);
189         return a % b;
190     }
191 }
192 
193 interface IERC20 {
194     function transfer(address to, uint256 value) external returns (bool);
195 
196     function approve(address spender, uint256 value) external returns (bool);
197 
198     function transferFrom(address from, address to, uint256 value) external returns (bool);
199 
200     function totalSupply() external view returns (uint256);
201 
202     function balanceOf(address who) external view returns (uint256);
203 
204     function allowance(address owner, address spender) external view returns (uint256);
205 
206     event Transfer(address indexed from, address indexed to, uint256 value);
207 
208     event Approval(address indexed owner, address indexed spender, uint256 value);
209 }
210 
211 library SafeERC20 {
212     using SafeMath for uint256;
213     using Address for address;
214 
215     function safeTransfer(IERC20 token, address to, uint256 value) internal {
216         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
217     }
218 
219     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
220         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
221     }
222 
223     function safeApprove(IERC20 token, address spender, uint256 value) internal {
224         // safeApprove should only be called when setting an initial allowance,
225         // or when resetting it to zero. To increase and decrease it, use
226         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
227         require((value == 0) || (token.allowance(address(this), spender) == 0));
228         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
229     }
230 
231     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
232         uint256 newAllowance = token.allowance(address(this), spender).add(value);
233         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
234     }
235 
236     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
237         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
238         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
239     }
240 
241     /**
242      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
243      * on the return value: the return value is optional (but if data is returned, it must equal true).
244      * @param token The token targeted by the call.
245      * @param data The call data (encoded using abi.encode or one of its variants).
246      */
247     function callOptionalReturn(IERC20 token, bytes memory data) private {
248         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
249         // we're implementing it ourselves.
250 
251         // A Solidity high level call has three parts:
252         //  1. The target address is checked to verify it contains contract code
253         //  2. The call itself is made, and success asserted
254         //  3. The return value is decoded, which in turn checks the size of the returned data.
255 
256         require(address(token).isContract());
257 
258         // solhint-disable-next-line avoid-low-level-calls
259         (bool success, bytes memory returndata) = address(token).call(data);
260         require(success);
261 
262         if (returndata.length > 0) { // Return data is optional
263             require(abi.decode(returndata, (bool)));
264         }
265     }
266 }
267 
268 library Address {
269     /**
270      * Returns whether the target address is a contract
271      * @dev This function will return false if invoked during the constructor of a contract,
272      * as the code is not actually created until after the constructor finishes.
273      * @param account address of the account to check
274      * @return whether the target address is a contract
275      */
276     function isContract(address account) internal view returns (bool) {
277         uint256 size;
278         // XXX Currently there is no better way to check if there is a contract in an address
279         // than to check the size of the code at that address.
280         // See https://ethereum.stackexchange.com/a/14016/36603
281         // for more details about how this works.
282         // TODO Check this again before the Serenity release, because all addresses will be
283         // contracts then.
284         // solhint-disable-next-line no-inline-assembly
285         assembly { size := extcodesize(account) }
286         return size > 0;
287     }
288 }
289 
290 contract ReentrancyGuard {
291     /// @dev counter to allow mutex lock with only one SSTORE operation
292     uint256 private _guardCounter;
293 
294     constructor () internal {
295         // The counter starts at one to prevent changing it from zero to a non-zero
296         // value, which is a more expensive operation.
297         _guardCounter = 1;
298     }
299 
300     /**
301      * @dev Prevents a contract from calling itself, directly or indirectly.
302      * Calling a `nonReentrant` function from another `nonReentrant`
303      * function is not supported. It is possible to prevent this from happening
304      * by making the `nonReentrant` function external, and make it call a
305      * `private` function that does the actual work.
306      */
307     modifier nonReentrant() {
308         _guardCounter += 1;
309         uint256 localCounter = _guardCounter;
310         _;
311         require(localCounter == _guardCounter);
312     }
313 }
314 
315 contract Crowdsale is ReentrancyGuard {
316     using SafeMath for uint256;
317     using SafeERC20 for IERC20;
318 
319     // The token being sold
320     IERC20 private _token;
321 
322     // Address where funds are collected
323     address payable private _wallet;
324 
325     // How many token units a buyer gets per wei.
326     // The rate is the conversion between wei and the smallest and indivisible token unit.
327     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
328     // 1 wei will give you 1 unit, or 0.001 TOK.
329     uint256 private _rate;
330 
331     // Amount of wei raised
332     uint256 private _weiRaised;
333 
334     /**
335      * Event for token purchase logging
336      * @param purchaser who paid for the tokens
337      * @param beneficiary who got the tokens
338      * @param value weis paid for purchase
339      * @param amount amount of tokens purchased
340      */
341     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
342 
343     /**
344      * @param rate Number of token units a buyer gets per wei
345      * @dev The rate is the conversion between wei and the smallest and indivisible
346      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
347      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
348      * @param wallet Address where collected funds will be forwarded to
349      * @param token Address of the token being sold
350      */
351     constructor (uint256 rate, address payable wallet, IERC20 token) public {
352         require(rate > 0);
353         require(wallet != address(0));
354         require(address(token) != address(0));
355 
356         _rate = rate;
357         _wallet = wallet;
358         _token = token;
359     }
360 
361     /**
362      * @dev fallback function ***DO NOT OVERRIDE***
363      * Note that other contracts will transfer funds with a base gas stipend
364      * of 2300, which is not enough to call buyTokens. Consider calling
365      * buyTokens directly when purchasing tokens from a contract.
366      */
367     function () external payable {
368         buyTokens(msg.sender);
369     }
370 
371     /**
372      * @return the token being sold.
373      */
374     function token() public view returns (IERC20) {
375         return _token;
376     }
377 
378     /**
379      * @return the address where funds are collected.
380      */
381     function wallet() public view returns (address payable) {
382         return _wallet;
383     }
384 
385     /**
386      * @return the number of token units a buyer gets per wei.
387      */
388     function rate() public view returns (uint256) {
389         return _rate;
390     }
391 
392     /**
393      * @return the amount of wei raised.
394      */
395     function weiRaised() public view returns (uint256) {
396         return _weiRaised;
397     }
398 
399     /**
400      * @dev low level token purchase ***DO NOT OVERRIDE***
401      * This function has a non-reentrancy guard, so it shouldn't be called by
402      * another `nonReentrant` function.
403      * @param beneficiary Recipient of the token purchase
404      */
405     function buyTokens(address beneficiary) public nonReentrant payable {
406         uint256 weiAmount = _weiAmount();
407         _preValidatePurchase(beneficiary, weiAmount);
408 
409         // calculate token amount to be created
410         uint256 tokens = _getTokenAmount(weiAmount);
411 
412         // update state
413         _weiRaised = _weiRaised.add(weiAmount);
414 
415         _processPurchase(beneficiary, tokens);
416         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
417 
418         _updatePurchasingState(beneficiary, weiAmount);
419 
420         _forwardFunds();
421         _postValidatePurchase(beneficiary, weiAmount);
422     }
423 
424     /**
425      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
426      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
427      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
428      *     super._preValidatePurchase(beneficiary, weiAmount);
429      *     require(weiRaised().add(weiAmount) <= cap);
430      * @param beneficiary Address performing the token purchase
431      * @param weiAmount Value in wei involved in the purchase
432      */
433     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
434         require(beneficiary != address(0));
435         require(weiAmount != 0);
436     }
437 
438     /**
439      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
440      * conditions are not met.
441      * @param beneficiary Address performing the token purchase
442      * @param weiAmount Value in wei involved in the purchase
443      */
444     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
445         // solhint-disable-previous-line no-empty-blocks
446     }
447 
448     /**
449      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
450      * its tokens.
451      * @param beneficiary Address performing the token purchase
452      * @param tokenAmount Number of tokens to be emitted
453      */
454     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
455         _token.safeTransfer(beneficiary, tokenAmount);
456     }
457 
458     /**
459      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
460      * tokens.
461      * @param beneficiary Address receiving the tokens
462      * @param tokenAmount Number of tokens to be purchased
463      */
464     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
465         _deliverTokens(beneficiary, tokenAmount);
466     }
467 
468     /**
469      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
470      * etc.)
471      * @param beneficiary Address receiving the tokens
472      * @param weiAmount Value in wei involved in the purchase
473      */
474     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
475         // solhint-disable-previous-line no-empty-blocks
476     }
477 
478     /**
479      * @dev Override to extend the way in which ether is converted to tokens.
480      * @param weiAmount Value in wei to be converted into tokens
481      * @return Number of tokens that can be purchased with the specified _weiAmount
482      */
483     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
484         return weiAmount.mul(_rate);
485     }
486 
487     /**
488      * @dev Determines how ETH is stored/forwarded on purchases.
489      */
490     function _forwardFunds() internal {
491         _wallet.transfer(msg.value);
492     }
493 
494     /**
495      * @dev Determines the value (in Wei) included with a purchase.
496      */
497     function _weiAmount() internal view returns (uint256) {
498       return msg.value;
499     }
500 }
501 
502 contract CappedCrowdsale is Crowdsale {
503     using SafeMath for uint256;
504 
505     uint256 private _cap;
506 
507     /**
508      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
509      * @param cap Max amount of wei to be contributed
510      */
511     constructor (uint256 cap) public {
512         require(cap > 0);
513         _cap = cap;
514     }
515 
516     /**
517      * @return the cap of the crowdsale.
518      */
519     function cap() public view returns (uint256) {
520         return _cap;
521     }
522 
523     /**
524      * @dev Checks whether the cap has been reached.
525      * @return Whether the cap was reached
526      */
527     function capReached() public view returns (bool) {
528         return weiRaised() >= _cap;
529     }
530 
531     /**
532      * @dev Extend parent behavior requiring purchase to respect the funding cap.
533      * @param beneficiary Token purchaser
534      * @param weiAmount Amount of wei contributed
535      */
536     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
537         super._preValidatePurchase(beneficiary, weiAmount);
538         require(weiRaised().add(weiAmount) <= _cap);
539     }
540 }
541 
542 contract TimedCrowdsale is Crowdsale {
543     using SafeMath for uint256;
544 
545     uint256 private _openingTime;
546     uint256 private _closingTime;
547 
548     /**
549      * Event for crowdsale extending
550      * @param newClosingTime new closing time
551      * @param prevClosingTime old closing time
552      */
553     event TimedCrowdsaleExtended(uint256 prevClosingTime, uint256 newClosingTime);
554 
555     /**
556      * @dev Reverts if not in crowdsale time range.
557      */
558     modifier onlyWhileOpen {
559         require(isOpen());
560         _;
561     }
562 
563     /**
564      * @dev Constructor, takes crowdsale opening and closing times.
565      * @param openingTime Crowdsale opening time
566      * @param closingTime Crowdsale closing time
567      */
568     constructor (uint256 openingTime, uint256 closingTime) public {
569         // solhint-disable-next-line not-rely-on-time
570         require(openingTime >= block.timestamp);
571         require(closingTime > openingTime);
572 
573         _openingTime = openingTime;
574         _closingTime = closingTime;
575     }
576 
577     /**
578      * @return the crowdsale opening time.
579      */
580     function openingTime() public view returns (uint256) {
581         return _openingTime;
582     }
583 
584     /**
585      * @return the crowdsale closing time.
586      */
587     function closingTime() public view returns (uint256) {
588         return _closingTime;
589     }
590 
591     /**
592      * @return true if the crowdsale is open, false otherwise.
593      */
594     function isOpen() public view returns (bool) {
595         // solhint-disable-next-line not-rely-on-time
596         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
597     }
598 
599     /**
600      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
601      * @return Whether crowdsale period has elapsed
602      */
603     function hasClosed() public view returns (bool) {
604         // solhint-disable-next-line not-rely-on-time
605         return block.timestamp > _closingTime;
606     }
607 
608     /**
609      * @dev Extend parent behavior requiring to be within contributing period
610      * @param beneficiary Token purchaser
611      * @param weiAmount Amount of wei contributed
612      */
613     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
614         super._preValidatePurchase(beneficiary, weiAmount);
615     }
616 
617     /**
618      * @dev Extend crowdsale
619      * @param newClosingTime Crowdsale closing time
620      */
621     function _extendTime(uint256 newClosingTime) internal {
622         require(!hasClosed());
623         require(newClosingTime > _closingTime);
624 
625         emit TimedCrowdsaleExtended(_closingTime, newClosingTime);
626         _closingTime = newClosingTime;
627     }
628 }
629 
630 contract FinalizableCrowdsale is TimedCrowdsale {
631     using SafeMath for uint256;
632 
633     bool private _finalized;
634 
635     event CrowdsaleFinalized();
636 
637     constructor () internal {
638         _finalized = false;
639     }
640 
641     /**
642      * @return true if the crowdsale is finalized, false otherwise.
643      */
644     function finalized() public view returns (bool) {
645         return _finalized;
646     }
647 
648     /**
649      * @dev Must be called after crowdsale ends, to do some extra finalization
650      * work. Calls the contract's finalization function.
651      */
652     function finalize() public {
653         require(!_finalized);
654         require(hasClosed());
655 
656         _finalized = true;
657 
658         _finalization();
659         emit CrowdsaleFinalized();
660     }
661 
662     /**
663      * @dev Can be overridden to add finalization logic. The overriding function
664      * should call super._finalization() to ensure the chain of finalization is
665      * executed entirely.
666      */
667     function _finalization() internal {
668         // solhint-disable-previous-line no-empty-blocks
669     }
670 }
671 
672 contract PostDeliveryCrowdsale is TimedCrowdsale {
673     using SafeMath for uint256;
674 
675     mapping(address => uint256) private _balances;
676 
677     /**
678      * @dev Withdraw tokens only after crowdsale ends.
679      * @param beneficiary Whose tokens will be withdrawn.
680      */
681     function withdrawTokens(address beneficiary) public {
682         require(hasClosed());
683         uint256 amount = _balances[beneficiary];
684         require(amount > 0);
685         _balances[beneficiary] = 0;
686         _deliverTokens(beneficiary, amount);
687     }
688 
689     /**
690      * @return the balance of an account.
691      */
692     function balanceOf(address account) public view returns (uint256) {
693         return _balances[account];
694     }
695 
696     /**
697      * @dev Overrides parent by storing balances instead of issuing tokens right away.
698      * @param beneficiary Token purchaser
699      * @param tokenAmount Amount of tokens purchased
700      */
701     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
702         _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
703     }
704 
705 }
706 
707 contract MoneyMarketInterface {
708   function getSupplyBalance(address account, address asset) public view returns (uint);
709   function supply(address asset, uint amount) public returns (uint);
710   function withdraw(address asset, uint requestedAmount) public returns (uint);
711 }
712 
713 contract LoanEscrow is Pausable {
714   using SafeERC20 for IERC20;
715   using SafeMath for uint256;
716 
717   // configurable to any ERC20 (i.e. xCHF)
718   IERC20 public dai = IERC20(0xB4272071eCAdd69d933AdcD19cA99fe80664fc08);  // 0x9Ad61E35f8309aF944136283157FABCc5AD371E5  // 0xB4272071eCAdd69d933AdcD19cA99fe80664fc08
719   MoneyMarketInterface public moneyMarket = MoneyMarketInterface(0x3FDA67f7583380E67ef93072294a7fAc882FD7E7);  // 0x6732c278C58FC90542cce498981844A073D693d7
720 
721   event Deposited(address indexed from, uint256 daiAmount);
722   event InterestWithdrawn(address indexed to, uint256 daiAmount);
723   event Pulled(address indexed to, uint256 daiAmount);
724 
725   mapping(address => uint256) public deposits;
726   mapping(address => uint256) public pulls;
727   uint256 public deposited;
728   uint256 public pulled;
729 
730   modifier onlyBlockimmo() {
731     require(msg.sender == blockimmo(), "onlyBlockimmo");
732     _;
733   }
734 
735   function blockimmo() public view returns (address);
736 
737   function withdrawInterest() public onlyBlockimmo {
738     uint256 amountInterest = moneyMarket.getSupplyBalance(address(this), address(dai)).add(dai.balanceOf(address(this))).add(pulled).sub(deposited);
739     require(amountInterest > 0, "no interest");
740 
741     uint256 errorCode = (amountInterest > dai.balanceOf(address(this))) ? moneyMarket.withdraw(address(dai), amountInterest.sub(dai.balanceOf(address(this)))) : 0;
742     require(errorCode == 0, "withdraw failed");
743 
744     dai.safeTransfer(msg.sender, amountInterest);
745     emit InterestWithdrawn(msg.sender, amountInterest);
746   }
747 
748   function withdrawMoneyMarket(uint256 _amountDai) public onlyBlockimmo {
749     uint256 errorCode = moneyMarket.withdraw(address(dai), _amountDai);
750     require(errorCode == 0, "withdraw failed");
751   }
752 
753   function deposit(address _from, uint256 _amountDai) internal {
754     require(_from != address(0) && _amountDai > 0, "invalid parameter(s)");
755 
756     dai.safeTransferFrom(msg.sender, address(this), _amountDai);
757 
758     if (!paused()) {
759       dai.safeApprove(address(moneyMarket), _amountDai);
760 
761       uint256 errorCode = moneyMarket.supply(address(dai), _amountDai);
762       require(errorCode == 0, "supply failed");
763       require(dai.allowance(address(this), address(moneyMarket)) == 0, "allowance not fully consumed by moneyMarket");
764     }
765 
766     deposits[_from] = deposits[_from].add(_amountDai);
767     deposited = deposited.add(_amountDai);
768     emit Deposited(_from, _amountDai);
769   }
770 
771   function pull(address _to, uint256 _amountDai, bool _refund) internal {
772     require(_to != address(0) && _amountDai > 0, "invalid parameter(s)");
773 
774     uint256 errorCode = (_amountDai > dai.balanceOf(address(this))) ? moneyMarket.withdraw(address(dai), _amountDai.sub(dai.balanceOf(address(this)))) : 0;
775     require(errorCode == 0, "withdraw failed");
776 
777     if (_refund) {
778       deposits[_to] = deposits[_to].sub(_amountDai);
779       deposited = deposited.sub(_amountDai);
780     } else {
781       pulls[_to] = pulls[_to].add(_amountDai);
782       pulled = pulled.add(_amountDai);
783     }
784 
785     dai.safeTransfer(_to, _amountDai);
786     emit Pulled(_to, _amountDai);
787   }
788 }
789 
790 contract LandRegistryProxyInterface {
791   function owner() public view returns (address);
792 }
793 
794 contract WhitelistInterface {
795   function checkRole(address _operator, string memory _role) public view;
796   function hasRole(address _operator, string memory _role) public view returns (bool);
797 }
798 
799 contract WhitelistProxyInterface {
800   function whitelist() public view returns (WhitelistInterface);
801 }
802 
803 contract TokenSale is CappedCrowdsale, FinalizableCrowdsale, LoanEscrow, PostDeliveryCrowdsale {
804   LandRegistryProxyInterface public registryProxy = LandRegistryProxyInterface(0xe72AD2A335AE18e6C7cdb6dAEB64b0330883CD56);  // 0x0f5Ea0A652E851678Ebf77B69484bFcD31F9459B;
805   WhitelistProxyInterface public whitelistProxy = WhitelistProxyInterface(0x7223b032180CDb06Be7a3D634B1E10032111F367);  // 0xEC8bE1A5630364292E56D01129E8ee8A9578d7D8;
806 
807   mapping(address => bool) public claimedRefund;
808   uint256 public goal;
809   mapping(address => bool) public reversed;
810   uint256 public totalTokens;
811 
812   constructor (
813     uint256 _cap,
814     uint256 _closingTime,
815     uint256 _goal,
816     uint256 _openingTime,
817     uint256 _rate,
818     IERC20 _token,
819     address payable _wallet
820   )
821   public
822     Crowdsale(_rate, _wallet, _token)
823     CappedCrowdsale(_cap)
824     FinalizableCrowdsale()
825     TimedCrowdsale(_openingTime, _closingTime)
826     PostDeliveryCrowdsale()
827   {
828     goal = _goal;
829   }
830 
831   function blockimmo() public view returns (address) {
832     return registryProxy.owner();
833   }
834 
835   function claimRefund(address _refundee) public {
836     require(finalized() && !goalReached());
837     require(!claimedRefund[_refundee]);
838 
839     claimedRefund[_refundee] = true;
840     pull(_refundee, deposits[_refundee], true);
841   }
842 
843   function goalReached() public view returns (bool) {
844     return weiRaised() >= goal;
845   }
846 
847   function hasClosed() public view returns (bool) {
848     return capReached() || super.hasClosed();
849   }
850 
851   function reverse(address _account) public {
852     require(!finalized());
853     require(!reversed[_account]);
854     WhitelistInterface whitelist = whitelistProxy.whitelist();
855     require(!whitelist.hasRole(_account, "authorized"));
856 
857     reversed[_account] = true;
858     pull(_account, deposits[_account], true);
859   }
860 
861   function totalTokensSold() public view returns (uint256) {
862     return _getTokenAmount(weiRaised());
863   }
864 
865   function withdrawTokens(address beneficiary) public {  // airdrop remaining tokens to investors proportionally
866     require(finalized() && goalReached(), "withdrawTokens requires the TokenSale to be successfully finalized");
867     require(!reversed[beneficiary]);
868 
869     uint256 extra = totalTokens.sub(totalTokensSold()).mul(balanceOf(beneficiary)).div(totalTokensSold());
870     _deliverTokens(beneficiary, extra);
871 
872     super.withdrawTokens(beneficiary);
873   }
874 
875   function weiRaised() public view returns (uint256) {
876     return deposited;
877   }
878 
879   function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
880     return weiAmount.div(rate());
881   }
882 
883   function _finalization() internal {
884     require(msg.sender == blockimmo() || msg.sender == wallet());
885     super._finalization();
886 
887     totalTokens = token().balanceOf(address(this));
888 
889     if (goalReached()) {
890       uint256 fee = weiRaised().div(100);
891 
892       pull(blockimmo(), fee, false);
893       pull(wallet(), weiRaised().sub(fee), false);
894     } else {
895       token().safeTransfer(wallet(), totalTokens);
896     }
897   }
898 
899   function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
900     super._processPurchase(beneficiary, tokenAmount);
901     deposit(beneficiary, tokenAmount.mul(rate()));
902   }
903 
904   function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
905     require(msg.value == 0, "ether loss");
906     require(!reversed[beneficiary]);
907 
908     super._preValidatePurchase(beneficiary, weiAmount);
909 
910     WhitelistInterface whitelist = whitelistProxy.whitelist();
911     whitelist.checkRole(beneficiary, "authorized");
912     require(deposits[beneficiary].add(weiAmount) <= 100000e18 || whitelist.hasRole(beneficiary, "uncapped"));
913   }
914 
915   function _weiAmount() internal view returns (uint256) {
916     return dai.allowance(msg.sender, address(this));
917   }
918 }