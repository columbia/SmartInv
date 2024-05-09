1 // File: contracts\open-zeppelin-contracts\token\ERC20\IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: contracts\open-zeppelin-contracts\math\SafeMath.sol
28 
29 pragma solidity ^0.5.0;
30 
31 /**
32  * @title SafeMath
33  * @dev Unsigned math operations with safety checks that revert on error
34  */
35 library SafeMath {
36     /**
37      * @dev Multiplies two unsigned integers, reverts on overflow.
38      */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41         // benefit is lost if 'b' is also tested.
42         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b);
49 
50         return c;
51     }
52 
53     /**
54      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
55      */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // Solidity only automatically asserts when dividing by 0
58         require(b > 0);
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62         return c;
63     }
64 
65     /**
66      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67      */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76      * @dev Adds two unsigned integers, reverts on overflow.
77      */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a);
81 
82         return c;
83     }
84 
85     /**
86      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
87      * reverts when dividing by zero.
88      */
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0);
91         return a % b;
92     }
93 }
94 
95 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20.sol
96 
97 pragma solidity ^0.5.0;
98 
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
106  * Originally based on code by FirstBlood:
107  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  *
109  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
110  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
111  * compliant implementations may not do it.
112  */
113 contract ERC20 is IERC20 {
114     using SafeMath for uint256;
115 
116     mapping (address => uint256) private _balances;
117 
118     mapping (address => mapping (address => uint256)) private _allowed;
119 
120     uint256 private _totalSupply;
121 
122     /**
123      * @dev Total number of tokens in existence
124      */
125     function totalSupply() public view returns (uint256) {
126         return _totalSupply;
127     }
128 
129     /**
130      * @dev Gets the balance of the specified address.
131      * @param owner The address to query the balance of.
132      * @return An uint256 representing the amount owned by the passed address.
133      */
134     function balanceOf(address owner) public view returns (uint256) {
135         return _balances[owner];
136     }
137 
138     /**
139      * @dev Function to check the amount of tokens that an owner allowed to a spender.
140      * @param owner address The address which owns the funds.
141      * @param spender address The address which will spend the funds.
142      * @return A uint256 specifying the amount of tokens still available for the spender.
143      */
144     function allowance(address owner, address spender) public view returns (uint256) {
145         return _allowed[owner][spender];
146     }
147 
148     /**
149      * @dev Transfer token for a specified address
150      * @param to The address to transfer to.
151      * @param value The amount to be transferred.
152      */
153     function transfer(address to, uint256 value) public returns (bool) {
154         _transfer(msg.sender, to, value);
155         return true;
156     }
157 
158     /**
159      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160      * Beware that changing an allowance with this method brings the risk that someone may use both the old
161      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      * @param spender The address which will spend the funds.
165      * @param value The amount of tokens to be spent.
166      */
167     function approve(address spender, uint256 value) public returns (bool) {
168         _approve(msg.sender, spender, value);
169         return true;
170     }
171 
172     /**
173      * @dev Transfer tokens from one address to another.
174      * Note that while this function emits an Approval event, this is not required as per the specification,
175      * and other compliant implementations may not emit the event.
176      * @param from address The address which you want to send tokens from
177      * @param to address The address which you want to transfer to
178      * @param value uint256 the amount of tokens to be transferred
179      */
180     function transferFrom(address from, address to, uint256 value) public returns (bool) {
181         _transfer(from, to, value);
182         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
183         return true;
184     }
185 
186     /**
187      * @dev Increase the amount of tokens that an owner allowed to a spender.
188      * approve should be called when allowed_[_spender] == 0. To increment
189      * allowed value is better to use this function to avoid 2 calls (and wait until
190      * the first transaction is mined)
191      * From MonolithDAO Token.sol
192      * Emits an Approval event.
193      * @param spender The address which will spend the funds.
194      * @param addedValue The amount of tokens to increase the allowance by.
195      */
196     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
197         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
198         return true;
199     }
200 
201     /**
202      * @dev Decrease the amount of tokens that an owner allowed to a spender.
203      * approve should be called when allowed_[_spender] == 0. To decrement
204      * allowed value is better to use this function to avoid 2 calls (and wait until
205      * the first transaction is mined)
206      * From MonolithDAO Token.sol
207      * Emits an Approval event.
208      * @param spender The address which will spend the funds.
209      * @param subtractedValue The amount of tokens to decrease the allowance by.
210      */
211     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
212         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
213         return true;
214     }
215 
216     /**
217      * @dev Transfer token for a specified addresses
218      * @param from The address to transfer from.
219      * @param to The address to transfer to.
220      * @param value The amount to be transferred.
221      */
222     function _transfer(address from, address to, uint256 value) internal {
223         require(to != address(0));
224 
225         _balances[from] = _balances[from].sub(value);
226         _balances[to] = _balances[to].add(value);
227         emit Transfer(from, to, value);
228     }
229 
230     /**
231      * @dev Internal function that mints an amount of the token and assigns it to
232      * an account. This encapsulates the modification of balances such that the
233      * proper events are emitted.
234      * @param account The account that will receive the created tokens.
235      * @param value The amount that will be created.
236      */
237     function _mint(address account, uint256 value) internal {
238         require(account != address(0));
239 
240         _totalSupply = _totalSupply.add(value);
241         _balances[account] = _balances[account].add(value);
242         emit Transfer(address(0), account, value);
243     }
244 
245     /**
246      * @dev Internal function that burns an amount of the token of a given
247      * account.
248      * @param account The account whose tokens will be burnt.
249      * @param value The amount that will be burnt.
250      */
251     function _burn(address account, uint256 value) internal {
252         require(account != address(0));
253 
254         _totalSupply = _totalSupply.sub(value);
255         _balances[account] = _balances[account].sub(value);
256         emit Transfer(account, address(0), value);
257     }
258 
259     /**
260      * @dev Approve an address to spend another addresses' tokens.
261      * @param owner The address that owns the tokens.
262      * @param spender The address that will spend the tokens.
263      * @param value The number of tokens that can be spent.
264      */
265     function _approve(address owner, address spender, uint256 value) internal {
266         require(spender != address(0));
267         require(owner != address(0));
268 
269         _allowed[owner][spender] = value;
270         emit Approval(owner, spender, value);
271     }
272 
273     /**
274      * @dev Internal function that burns an amount of the token of a given
275      * account, deducting from the sender's allowance for said account. Uses the
276      * internal burn function.
277      * Emits an Approval event (reflecting the reduced allowance).
278      * @param account The account whose tokens will be burnt.
279      * @param value The amount that will be burnt.
280      */
281     function _burnFrom(address account, uint256 value) internal {
282         _burn(account, value);
283         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
284     }
285 }
286 
287 // File: contracts\open-zeppelin-contracts\access\Roles.sol
288 
289 pragma solidity ^0.5.0;
290 
291 /**
292  * @title Roles
293  * @dev Library for managing addresses assigned to a Role.
294  */
295 library Roles {
296     struct Role {
297         mapping (address => bool) bearer;
298     }
299 
300     /**
301      * @dev give an account access to this role
302      */
303     function add(Role storage role, address account) internal {
304         require(account != address(0));
305         require(!has(role, account));
306 
307         role.bearer[account] = true;
308     }
309 
310     /**
311      * @dev remove an account's access to this role
312      */
313     function remove(Role storage role, address account) internal {
314         require(account != address(0));
315         require(has(role, account));
316 
317         role.bearer[account] = false;
318     }
319 
320     /**
321      * @dev check if an account has this role
322      * @return bool
323      */
324     function has(Role storage role, address account) internal view returns (bool) {
325         require(account != address(0));
326         return role.bearer[account];
327     }
328 }
329 
330 // File: contracts\open-zeppelin-contracts\access\roles\MinterRole.sol
331 
332 pragma solidity ^0.5.0;
333 
334 
335 contract MinterRole {
336     using Roles for Roles.Role;
337 
338     event MinterAdded(address indexed account);
339     event MinterRemoved(address indexed account);
340 
341     Roles.Role private _minters;
342 
343     constructor () internal {
344         _addMinter(msg.sender);
345     }
346 
347     modifier onlyMinter() {
348         require(isMinter(msg.sender));
349         _;
350     }
351 
352     function isMinter(address account) public view returns (bool) {
353         return _minters.has(account);
354     }
355 
356     function addMinter(address account) public onlyMinter {
357         _addMinter(account);
358     }
359 
360     function renounceMinter() public {
361         _removeMinter(msg.sender);
362     }
363 
364     function _addMinter(address account) internal {
365         _minters.add(account);
366         emit MinterAdded(account);
367     }
368 
369     function _removeMinter(address account) internal {
370         _minters.remove(account);
371         emit MinterRemoved(account);
372     }
373 }
374 
375 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20Mintable.sol
376 
377 pragma solidity ^0.5.0;
378 
379 
380 
381 /**
382  * @title ERC20Mintable
383  * @dev ERC20 minting logic
384  */
385 contract ERC20Mintable is ERC20, MinterRole {
386     /**
387      * @dev Function to mint tokens
388      * @param to The address that will receive the minted tokens.
389      * @param value The amount of tokens to mint.
390      * @return A boolean that indicates if the operation was successful.
391      */
392     function mint(address to, uint256 value) public onlyMinter returns (bool) {
393         _mint(to, value);
394         return true;
395     }
396 }
397 
398 // File: contracts\open-zeppelin-contracts\token\ERC20\SafeERC20.sol
399 
400 pragma solidity ^0.5.0;
401 
402 
403 
404 /**
405  * @title SafeERC20
406  * @dev Wrappers around ERC20 operations that throw on failure.
407  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
408  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
409  */
410 library SafeERC20 {
411     using SafeMath for uint256;
412 
413     function safeTransfer(IERC20 token, address to, uint256 value) internal {
414         require(token.transfer(to, value));
415     }
416 
417     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
418         require(token.transferFrom(from, to, value));
419     }
420 
421     function safeApprove(IERC20 token, address spender, uint256 value) internal {
422         // safeApprove should only be called when setting an initial allowance,
423         // or when resetting it to zero. To increase and decrease it, use
424         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
425         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
426         require(token.approve(spender, value));
427     }
428 
429     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
430         uint256 newAllowance = token.allowance(address(this), spender).add(value);
431         require(token.approve(spender, newAllowance));
432     }
433 
434     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
435         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
436         require(token.approve(spender, newAllowance));
437     }
438 }
439 
440 // File: contracts\open-zeppelin-contracts\utils\ReentrancyGuard.sol
441 
442 pragma solidity ^0.5.0;
443 
444 /**
445  * @title Helps contracts guard against reentrancy attacks.
446  * @author Remco Bloemen <remco@2╧Ç.com>, Eenae <alexey@mixbytes.io>
447  * @dev If you mark a function `nonReentrant`, you should also
448  * mark it `external`.
449  */
450 contract ReentrancyGuard {
451     /// @dev counter to allow mutex lock with only one SSTORE operation
452     uint256 private _guardCounter;
453 
454     constructor () internal {
455         // The counter starts at one to prevent changing it from zero to a non-zero
456         // value, which is a more expensive operation.
457         _guardCounter = 1;
458     }
459 
460     /**
461      * @dev Prevents a contract from calling itself, directly or indirectly.
462      * Calling a `nonReentrant` function from another `nonReentrant`
463      * function is not supported. It is possible to prevent this from happening
464      * by making the `nonReentrant` function external, and make it call a
465      * `private` function that does the actual work.
466      */
467     modifier nonReentrant() {
468         _guardCounter += 1;
469         uint256 localCounter = _guardCounter;
470         _;
471         require(localCounter == _guardCounter);
472     }
473 }
474 
475 // File: contracts\open-zeppelin-contracts\crowdsale\Crowdsale.sol
476 
477 pragma solidity ^0.5.0;
478 
479 
480 
481 
482 
483 /**
484  * @title Crowdsale
485  * @dev Crowdsale is a base contract for managing a token crowdsale,
486  * allowing investors to purchase tokens with ether. This contract implements
487  * such functionality in its most fundamental form and can be extended to provide additional
488  * functionality and/or custom behavior.
489  * The external interface represents the basic interface for purchasing tokens, and conform
490  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
491  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
492  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
493  * behavior.
494  */
495 contract Crowdsale is ReentrancyGuard {
496     using SafeMath for uint256;
497     using SafeERC20 for IERC20;
498 
499     // The token being sold
500     IERC20 private _token;
501 
502     // Address where funds are collected
503     address payable private _wallet;
504 
505     // How many token units a buyer gets per wei.
506     // The rate is the conversion between wei and the smallest and indivisible token unit.
507     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
508     // 1 wei will give you 1 unit, or 0.001 TOK.
509     uint256 private _rate;
510 
511     // Amount of wei raised
512     uint256 private _weiRaised;
513 
514     /**
515      * Event for token purchase logging
516      * @param purchaser who paid for the tokens
517      * @param beneficiary who got the tokens
518      * @param value weis paid for purchase
519      * @param amount amount of tokens purchased
520      */
521     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
522 
523     /**
524      * @param rate Number of token units a buyer gets per wei
525      * @dev The rate is the conversion between wei and the smallest and indivisible
526      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
527      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
528      * @param wallet Address where collected funds will be forwarded to
529      * @param token Address of the token being sold
530      */
531     constructor (uint256 rate, address payable wallet, IERC20 token) public {
532         require(rate > 0);
533         require(wallet != address(0));
534         require(address(token) != address(0));
535 
536         _rate = rate;
537         _wallet = wallet;
538         _token = token;
539     }
540 
541     /**
542      * @dev fallback function ***DO NOT OVERRIDE***
543      * Note that other contracts will transfer fund with a base gas stipend
544      * of 2300, which is not enough to call buyTokens. Consider calling
545      * buyTokens directly when purchasing tokens from a contract.
546      */
547     function () external payable {
548         buyTokens(msg.sender);
549     }
550 
551     /**
552      * @return the token being sold.
553      */
554     function token() public view returns (IERC20) {
555         return _token;
556     }
557 
558     /**
559      * @return the address where funds are collected.
560      */
561     function wallet() public view returns (address payable) {
562         return _wallet;
563     }
564 
565     /**
566      * @return the number of token units a buyer gets per wei.
567      */
568     function rate() public view returns (uint256) {
569         return _rate;
570     }
571 
572     /**
573      * @return the amount of wei raised.
574      */
575     function weiRaised() public view returns (uint256) {
576         return _weiRaised;
577     }
578 
579     /**
580      * @dev low level token purchase ***DO NOT OVERRIDE***
581      * This function has a non-reentrancy guard, so it shouldn't be called by
582      * another `nonReentrant` function.
583      * @param beneficiary Recipient of the token purchase
584      */
585     function buyTokens(address beneficiary) public nonReentrant payable {
586         uint256 weiAmount = msg.value;
587         _preValidatePurchase(beneficiary, weiAmount);
588 
589         // calculate token amount to be created
590         uint256 tokens = _getTokenAmount(weiAmount);
591 
592         // update state
593         _weiRaised = _weiRaised.add(weiAmount);
594 
595         _processPurchase(beneficiary, tokens);
596         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
597 
598         _updatePurchasingState(beneficiary, weiAmount);
599 
600         _forwardFunds();
601         _postValidatePurchase(beneficiary, weiAmount);
602     }
603 
604     /**
605      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
606      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
607      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
608      *     super._preValidatePurchase(beneficiary, weiAmount);
609      *     require(weiRaised().add(weiAmount) <= cap);
610      * @param beneficiary Address performing the token purchase
611      * @param weiAmount Value in wei involved in the purchase
612      */
613     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
614         require(beneficiary != address(0));
615         require(weiAmount != 0);
616     }
617 
618     /**
619      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
620      * conditions are not met.
621      * @param beneficiary Address performing the token purchase
622      * @param weiAmount Value in wei involved in the purchase
623      */
624     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
625         // solhint-disable-previous-line no-empty-blocks
626     }
627 
628     /**
629      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
630      * its tokens.
631      * @param beneficiary Address performing the token purchase
632      * @param tokenAmount Number of tokens to be emitted
633      */
634     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
635         _token.safeTransfer(beneficiary, tokenAmount);
636     }
637 
638     /**
639      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
640      * tokens.
641      * @param beneficiary Address receiving the tokens
642      * @param tokenAmount Number of tokens to be purchased
643      */
644     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
645         _deliverTokens(beneficiary, tokenAmount);
646     }
647 
648     /**
649      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
650      * etc.)
651      * @param beneficiary Address receiving the tokens
652      * @param weiAmount Value in wei involved in the purchase
653      */
654     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
655         // solhint-disable-previous-line no-empty-blocks
656     }
657 
658     /**
659      * @dev Override to extend the way in which ether is converted to tokens.
660      * @param weiAmount Value in wei to be converted into tokens
661      * @return Number of tokens that can be purchased with the specified _weiAmount
662      */
663     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
664         return weiAmount.mul(_rate);
665     }
666 
667     /**
668      * @dev Determines how ETH is stored/forwarded on purchases.
669      */
670     function _forwardFunds() internal {
671         _wallet.transfer(msg.value);
672     }
673 }
674 
675 // File: contracts\open-zeppelin-contracts\crowdsale\validation\CappedCrowdsale.sol
676 
677 pragma solidity ^0.5.0;
678 
679 
680 
681 /**
682  * @title CappedCrowdsale
683  * @dev Crowdsale with a limit for total contributions.
684  */
685 contract CappedCrowdsale is Crowdsale {
686     using SafeMath for uint256;
687 
688     uint256 private _cap;
689 
690     /**
691      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
692      * @param cap Max amount of wei to be contributed
693      */
694     constructor (uint256 cap) public {
695         require(cap > 0);
696         _cap = cap;
697     }
698 
699     /**
700      * @return the cap of the crowdsale.
701      */
702     function cap() public view returns (uint256) {
703         return _cap;
704     }
705 
706     /**
707      * @dev Checks whether the cap has been reached.
708      * @return Whether the cap was reached
709      */
710     function capReached() public view returns (bool) {
711         return weiRaised() >= _cap;
712     }
713 
714     /**
715      * @dev Extend parent behavior requiring purchase to respect the funding cap.
716      * @param beneficiary Token purchaser
717      * @param weiAmount Amount of wei contributed
718      */
719     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
720         super._preValidatePurchase(beneficiary, weiAmount);
721         require(weiRaised().add(weiAmount) <= _cap);
722     }
723 }
724 
725 // File: contracts\open-zeppelin-contracts\crowdsale\emission\MintedCrowdsale.sol
726 
727 pragma solidity ^0.5.0;
728 
729 
730 
731 /**
732  * @title MintedCrowdsale
733  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
734  * Token ownership should be transferred to MintedCrowdsale for minting.
735  */
736 contract MintedCrowdsale is Crowdsale {
737     /**
738      * @dev Overrides delivery by minting tokens upon purchase.
739      * @param beneficiary Token purchaser
740      * @param tokenAmount Number of tokens to be minted
741      */
742     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
743         // Potentially dangerous assumption about the type of the token.
744         require(ERC20Mintable(address(token())).mint(beneficiary, tokenAmount));
745     }
746 }
747 
748 // File: contracts\open-zeppelin-contracts\crowdsale\validation\TimedCrowdsale.sol
749 
750 pragma solidity ^0.5.0;
751 
752 
753 
754 /**
755  * @title TimedCrowdsale
756  * @dev Crowdsale accepting contributions only within a time frame.
757  */
758 contract TimedCrowdsale is Crowdsale {
759     using SafeMath for uint256;
760 
761     uint256 private _openingTime;
762     uint256 private _closingTime;
763 
764     /**
765      * @dev Reverts if not in crowdsale time range.
766      */
767     modifier onlyWhileOpen {
768         require(isOpen());
769         _;
770     }
771 
772     /**
773      * @dev Constructor, takes crowdsale opening and closing times.
774      * @param openingTime Crowdsale opening time
775      * @param closingTime Crowdsale closing time
776      */
777     constructor (uint256 openingTime, uint256 closingTime) public {
778         // solhint-disable-next-line not-rely-on-time
779         require(openingTime >= block.timestamp);
780         require(closingTime > openingTime);
781 
782         _openingTime = openingTime;
783         _closingTime = closingTime;
784     }
785 
786     /**
787      * @return the crowdsale opening time.
788      */
789     function openingTime() public view returns (uint256) {
790         return _openingTime;
791     }
792 
793     /**
794      * @return the crowdsale closing time.
795      */
796     function closingTime() public view returns (uint256) {
797         return _closingTime;
798     }
799 
800     /**
801      * @return true if the crowdsale is open, false otherwise.
802      */
803     function isOpen() public view returns (bool) {
804         // solhint-disable-next-line not-rely-on-time
805         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
806     }
807 
808     /**
809      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
810      * @return Whether crowdsale period has elapsed
811      */
812     function hasClosed() public view returns (bool) {
813         // solhint-disable-next-line not-rely-on-time
814         return block.timestamp > _closingTime;
815     }
816 
817     /**
818      * @dev Extend parent behavior requiring to be within contributing period
819      * @param beneficiary Token purchaser
820      * @param weiAmount Amount of wei contributed
821      */
822     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
823         super._preValidatePurchase(beneficiary, weiAmount);
824     }
825 }
826 
827 // File: contracts\open-zeppelin-contracts\crowdsale\price\IncreasingPriceCrowdsale.sol
828 
829 pragma solidity ^0.5.0;
830 
831 
832 
833 /**
834  * @title IncreasingPriceCrowdsale
835  * @dev Extension of Crowdsale contract that increases the price of tokens linearly in time.
836  * Note that what should be provided to the constructor is the initial and final _rates_, that is,
837  * the amount of tokens per wei contributed. Thus, the initial rate must be greater than the final rate.
838  */
839 contract IncreasingPriceCrowdsale is TimedCrowdsale {
840     using SafeMath for uint256;
841 
842     uint256 private _initialRate;
843     uint256 private _finalRate;
844 
845     /**
846      * @dev Constructor, takes initial and final rates of tokens received per wei contributed.
847      * @param initialRate Number of tokens a buyer gets per wei at the start of the crowdsale
848      * @param finalRate Number of tokens a buyer gets per wei at the end of the crowdsale
849      */
850     constructor (uint256 initialRate, uint256 finalRate) public {
851         require(finalRate > 0);
852         require(initialRate > finalRate);
853         _initialRate = initialRate;
854         _finalRate = finalRate;
855     }
856 
857     /**
858      * The base rate function is overridden to revert, since this crowdsale doens't use it, and
859      * all calls to it are a mistake.
860      */
861     function rate() public view returns (uint256) {
862         revert();
863     }
864 
865     /**
866      * @return the initial rate of the crowdsale.
867      */
868     function initialRate() public view returns (uint256) {
869         return _initialRate;
870     }
871 
872     /**
873      * @return the final rate of the crowdsale.
874      */
875     function finalRate() public view returns (uint256) {
876         return _finalRate;
877     }
878 
879     /**
880      * @dev Returns the rate of tokens per wei at the present time.
881      * Note that, as price _increases_ with time, the rate _decreases_.
882      * @return The number of tokens a buyer gets per wei at a given time
883      */
884     function getCurrentRate() public view returns (uint256) {
885         if (!isOpen()) {
886             return 0;
887         }
888 
889         // solhint-disable-next-line not-rely-on-time
890         uint256 elapsedTime = block.timestamp.sub(openingTime());
891         uint256 timeRange = closingTime().sub(openingTime());
892         uint256 rateRange = _initialRate.sub(_finalRate);
893         return _initialRate.sub(elapsedTime.mul(rateRange).div(timeRange));
894     }
895 
896     /**
897      * @dev Overrides parent method taking into account variable rate.
898      * @param weiAmount The value in wei to be converted into tokens
899      * @return The number of tokens _weiAmount wei will buy at present time
900      */
901     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
902         uint256 currentRate = getCurrentRate();
903         return currentRate.mul(weiAmount);
904     }
905 }
906 
907 // File: contracts\open-zeppelin-contracts\crowdsale\distribution\FinalizableCrowdsale.sol
908 
909 pragma solidity ^0.5.0;
910 
911 
912 
913 /**
914  * @title FinalizableCrowdsale
915  * @dev Extension of Crowdsale with a one-off finalization action, where one
916  * can do extra work after finishing.
917  */
918 contract FinalizableCrowdsale is TimedCrowdsale {
919     using SafeMath for uint256;
920 
921     bool private _finalized;
922 
923     event CrowdsaleFinalized();
924 
925     constructor () internal {
926         _finalized = false;
927     }
928 
929     /**
930      * @return true if the crowdsale is finalized, false otherwise.
931      */
932     function finalized() public view returns (bool) {
933         return _finalized;
934     }
935 
936     /**
937      * @dev Must be called after crowdsale ends, to do some extra finalization
938      * work. Calls the contract's finalization function.
939      */
940     function finalize() public {
941         require(!_finalized);
942         require(hasClosed());
943 
944         _finalized = true;
945 
946         _finalization();
947         emit CrowdsaleFinalized();
948     }
949 
950     /**
951      * @dev Can be overridden to add finalization logic. The overriding function
952      * should call super._finalization() to ensure the chain of finalization is
953      * executed entirely.
954      */
955     function _finalization() internal {
956         // solhint-disable-previous-line no-empty-blocks
957     }
958 }
959 
960 // File: contracts\open-zeppelin-contracts\ownership\Secondary.sol
961 
962 pragma solidity ^0.5.0;
963 
964 /**
965  * @title Secondary
966  * @dev A Secondary contract can only be used by its primary account (the one that created it)
967  */
968 contract Secondary {
969     address private _primary;
970 
971     event PrimaryTransferred(
972         address recipient
973     );
974 
975     /**
976      * @dev Sets the primary account to the one that is creating the Secondary contract.
977      */
978     constructor () internal {
979         _primary = msg.sender;
980         emit PrimaryTransferred(_primary);
981     }
982 
983     /**
984      * @dev Reverts if called from any account other than the primary.
985      */
986     modifier onlyPrimary() {
987         require(msg.sender == _primary);
988         _;
989     }
990 
991     /**
992      * @return the address of the primary.
993      */
994     function primary() public view returns (address) {
995         return _primary;
996     }
997 
998     /**
999      * @dev Transfers contract to a new primary.
1000      * @param recipient The address of new primary.
1001      */
1002     function transferPrimary(address recipient) public onlyPrimary {
1003         require(recipient != address(0));
1004         _primary = recipient;
1005         emit PrimaryTransferred(_primary);
1006     }
1007 }
1008 
1009 // File: contracts\open-zeppelin-contracts\payment\escrow\Escrow.sol
1010 
1011 pragma solidity ^0.5.0;
1012 
1013 
1014 
1015  /**
1016   * @title Escrow
1017   * @dev Base escrow contract, holds funds designated for a payee until they
1018   * withdraw them.
1019   * @dev Intended usage: This contract (and derived escrow contracts) should be a
1020   * standalone contract, that only interacts with the contract that instantiated
1021   * it. That way, it is guaranteed that all Ether will be handled according to
1022   * the Escrow rules, and there is no need to check for payable functions or
1023   * transfers in the inheritance tree. The contract that uses the escrow as its
1024   * payment method should be its primary, and provide public methods redirecting
1025   * to the escrow's deposit and withdraw.
1026   */
1027 contract Escrow is Secondary {
1028     using SafeMath for uint256;
1029 
1030     event Deposited(address indexed payee, uint256 weiAmount);
1031     event Withdrawn(address indexed payee, uint256 weiAmount);
1032 
1033     mapping(address => uint256) private _deposits;
1034 
1035     function depositsOf(address payee) public view returns (uint256) {
1036         return _deposits[payee];
1037     }
1038 
1039     /**
1040      * @dev Stores the sent amount as credit to be withdrawn.
1041      * @param payee The destination address of the funds.
1042      */
1043     function deposit(address payee) public onlyPrimary payable {
1044         uint256 amount = msg.value;
1045         _deposits[payee] = _deposits[payee].add(amount);
1046 
1047         emit Deposited(payee, amount);
1048     }
1049 
1050     /**
1051      * @dev Withdraw accumulated balance for a payee.
1052      * @param payee The address whose funds will be withdrawn and transferred to.
1053      */
1054     function withdraw(address payable payee) public onlyPrimary {
1055         uint256 payment = _deposits[payee];
1056 
1057         _deposits[payee] = 0;
1058 
1059         payee.transfer(payment);
1060 
1061         emit Withdrawn(payee, payment);
1062     }
1063 }
1064 
1065 // File: contracts\open-zeppelin-contracts\payment\escrow\ConditionalEscrow.sol
1066 
1067 pragma solidity ^0.5.0;
1068 
1069 
1070 /**
1071  * @title ConditionalEscrow
1072  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
1073  * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
1074  */
1075 contract ConditionalEscrow is Escrow {
1076     /**
1077      * @dev Returns whether an address is allowed to withdraw their funds. To be
1078      * implemented by derived contracts.
1079      * @param payee The destination address of the funds.
1080      */
1081     function withdrawalAllowed(address payee) public view returns (bool);
1082 
1083     function withdraw(address payable payee) public {
1084         require(withdrawalAllowed(payee));
1085         super.withdraw(payee);
1086     }
1087 }
1088 
1089 // File: contracts\open-zeppelin-contracts\payment\escrow\RefundEscrow.sol
1090 
1091 pragma solidity ^0.5.0;
1092 
1093 
1094 /**
1095  * @title RefundEscrow
1096  * @dev Escrow that holds funds for a beneficiary, deposited from multiple
1097  * parties.
1098  * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
1099  * @dev The primary account (that is, the contract that instantiates this
1100  * contract) may deposit, close the deposit period, and allow for either
1101  * withdrawal by the beneficiary, or refunds to the depositors. All interactions
1102  * with RefundEscrow will be made through the primary contract. See the
1103  * RefundableCrowdsale contract for an example of RefundEscrowΓÇÖs use.
1104  */
1105 contract RefundEscrow is ConditionalEscrow {
1106     enum State { Active, Refunding, Closed }
1107 
1108     event RefundsClosed();
1109     event RefundsEnabled();
1110 
1111     State private _state;
1112     address payable private _beneficiary;
1113 
1114     /**
1115      * @dev Constructor.
1116      * @param beneficiary The beneficiary of the deposits.
1117      */
1118     constructor (address payable beneficiary) public {
1119         require(beneficiary != address(0));
1120         _beneficiary = beneficiary;
1121         _state = State.Active;
1122     }
1123 
1124     /**
1125      * @return the current state of the escrow.
1126      */
1127     function state() public view returns (State) {
1128         return _state;
1129     }
1130 
1131     /**
1132      * @return the beneficiary of the escrow.
1133      */
1134     function beneficiary() public view returns (address) {
1135         return _beneficiary;
1136     }
1137 
1138     /**
1139      * @dev Stores funds that may later be refunded.
1140      * @param refundee The address funds will be sent to if a refund occurs.
1141      */
1142     function deposit(address refundee) public payable {
1143         require(_state == State.Active);
1144         super.deposit(refundee);
1145     }
1146 
1147     /**
1148      * @dev Allows for the beneficiary to withdraw their funds, rejecting
1149      * further deposits.
1150      */
1151     function close() public onlyPrimary {
1152         require(_state == State.Active);
1153         _state = State.Closed;
1154         emit RefundsClosed();
1155     }
1156 
1157     /**
1158      * @dev Allows for refunds to take place, rejecting further deposits.
1159      */
1160     function enableRefunds() public onlyPrimary {
1161         require(_state == State.Active);
1162         _state = State.Refunding;
1163         emit RefundsEnabled();
1164     }
1165 
1166     /**
1167      * @dev Withdraws the beneficiary's funds.
1168      */
1169     function beneficiaryWithdraw() public {
1170         require(_state == State.Closed);
1171         _beneficiary.transfer(address(this).balance);
1172     }
1173 
1174     /**
1175      * @dev Returns whether refundees can withdraw their deposits (be refunded). The overriden function receives a
1176      * 'payee' argument, but we ignore it here since the condition is global, not per-payee.
1177      */
1178     function withdrawalAllowed(address) public view returns (bool) {
1179         return _state == State.Refunding;
1180     }
1181 }
1182 
1183 // File: contracts\open-zeppelin-contracts\crowdsale\distribution\RefundableCrowdsale.sol
1184 
1185 pragma solidity ^0.5.0;
1186 
1187 
1188 
1189 
1190 /**
1191  * @title RefundableCrowdsale
1192  * @dev Extension of Crowdsale contract that adds a funding goal, and the possibility of users getting a refund
1193  * if goal is not met.
1194  *
1195  * Deprecated, use RefundablePostDeliveryCrowdsale instead. Note that if you allow tokens to be traded before the goal
1196  * is met, then an attack is possible in which the attacker purchases tokens from the crowdsale and when they sees that
1197  * the goal is unlikely to be met, they sell their tokens (possibly at a discount). The attacker will be refunded when
1198  * the crowdsale is finalized, and the users that purchased from them will be left with worthless tokens.
1199  */
1200 contract RefundableCrowdsale is FinalizableCrowdsale {
1201     using SafeMath for uint256;
1202 
1203     // minimum amount of funds to be raised in weis
1204     uint256 private _goal;
1205 
1206     // refund escrow used to hold funds while crowdsale is running
1207     RefundEscrow private _escrow;
1208 
1209     /**
1210      * @dev Constructor, creates RefundEscrow.
1211      * @param goal Funding goal
1212      */
1213     constructor (uint256 goal) public {
1214         require(goal > 0);
1215         _escrow = new RefundEscrow(wallet());
1216         _goal = goal;
1217     }
1218 
1219     /**
1220      * @return minimum amount of funds to be raised in wei.
1221      */
1222     function goal() public view returns (uint256) {
1223         return _goal;
1224     }
1225 
1226     /**
1227      * @dev Investors can claim refunds here if crowdsale is unsuccessful
1228      * @param refundee Whose refund will be claimed.
1229      */
1230     function claimRefund(address payable refundee) public {
1231         require(finalized());
1232         require(!goalReached());
1233 
1234         _escrow.withdraw(refundee);
1235     }
1236 
1237     /**
1238      * @dev Checks whether funding goal was reached.
1239      * @return Whether funding goal was reached
1240      */
1241     function goalReached() public view returns (bool) {
1242         return weiRaised() >= _goal;
1243     }
1244 
1245     /**
1246      * @dev escrow finalization task, called when finalize() is called
1247      */
1248     function _finalization() internal {
1249         if (goalReached()) {
1250             _escrow.close();
1251             _escrow.beneficiaryWithdraw();
1252         } else {
1253             _escrow.enableRefunds();
1254         }
1255 
1256         super._finalization();
1257     }
1258 
1259     /**
1260      * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
1261      */
1262     function _forwardFunds() internal {
1263         _escrow.deposit.value(msg.value)(msg.sender);
1264     }
1265 }
1266 
1267 // File: contracts\open-zeppelin-contracts\crowdsale\distribution\PostDeliveryCrowdsale.sol
1268 
1269 pragma solidity ^0.5.0;
1270 
1271 
1272 
1273 /**
1274  * @title PostDeliveryCrowdsale
1275  * @dev Crowdsale that locks tokens from withdrawal until it ends.
1276  */
1277 contract PostDeliveryCrowdsale is TimedCrowdsale {
1278     using SafeMath for uint256;
1279 
1280     mapping(address => uint256) private _balances;
1281 
1282     /**
1283      * @dev Withdraw tokens only after crowdsale ends.
1284      * @param beneficiary Whose tokens will be withdrawn.
1285      */
1286     function withdrawTokens(address beneficiary) public {
1287         require(hasClosed());
1288         uint256 amount = _balances[beneficiary];
1289         require(amount > 0);
1290         _balances[beneficiary] = 0;
1291         _deliverTokens(beneficiary, amount);
1292     }
1293 
1294     /**
1295      * @return the balance of an account.
1296      */
1297     function balanceOf(address account) public view returns (uint256) {
1298         return _balances[account];
1299     }
1300 
1301     /**
1302      * @dev Overrides parent by storing balances instead of issuing tokens right away.
1303      * @param beneficiary Token purchaser
1304      * @param tokenAmount Amount of tokens purchased
1305      */
1306     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
1307         _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
1308     }
1309 
1310 }
1311 
1312 // File: contracts\open-zeppelin-contracts\crowdsale\distribution\RefundablePostDeliveryCrowdsale.sol
1313 
1314 pragma solidity ^0.5.0;
1315 
1316 
1317 
1318 
1319 /**
1320  * @title RefundablePostDeliveryCrowdsale
1321  * @dev Extension of RefundableCrowdsale contract that only delivers the tokens
1322  * once the crowdsale has closed and the goal met, preventing refunds to be issued
1323  * to token holders.
1324  */
1325 contract RefundablePostDeliveryCrowdsale is RefundableCrowdsale, PostDeliveryCrowdsale {
1326     function withdrawTokens(address beneficiary) public {
1327         require(finalized());
1328         require(goalReached());
1329 
1330         super.withdrawTokens(beneficiary);
1331     }
1332 }
1333 
1334 // File: contracts\open-zeppelin-contracts\ownership\Ownable.sol
1335 
1336 pragma solidity ^0.5.0;
1337 
1338 /**
1339  * @title Ownable
1340  * @dev The Ownable contract has an owner address, and provides basic authorization control
1341  * functions, this simplifies the implementation of "user permissions".
1342  */
1343 contract Ownable {
1344     address private _owner;
1345 
1346     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1347 
1348     /**
1349      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1350      * account.
1351      */
1352     constructor () internal {
1353         _owner = msg.sender;
1354         emit OwnershipTransferred(address(0), _owner);
1355     }
1356 
1357     /**
1358      * @return the address of the owner.
1359      */
1360     function owner() public view returns (address) {
1361         return _owner;
1362     }
1363 
1364     /**
1365      * @dev Throws if called by any account other than the owner.
1366      */
1367     modifier onlyOwner() {
1368         require(isOwner());
1369         _;
1370     }
1371 
1372     /**
1373      * @return true if `msg.sender` is the owner of the contract.
1374      */
1375     function isOwner() public view returns (bool) {
1376         return msg.sender == _owner;
1377     }
1378 
1379     /**
1380      * @dev Allows the current owner to relinquish control of the contract.
1381      * @notice Renouncing to ownership will leave the contract without an owner.
1382      * It will not be possible to call the functions with the `onlyOwner`
1383      * modifier anymore.
1384      */
1385     function renounceOwnership() public onlyOwner {
1386         emit OwnershipTransferred(_owner, address(0));
1387         _owner = address(0);
1388     }
1389 
1390     /**
1391      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1392      * @param newOwner The address to transfer ownership to.
1393      */
1394     function transferOwnership(address newOwner) public onlyOwner {
1395         _transferOwnership(newOwner);
1396     }
1397 
1398     /**
1399      * @dev Transfers control of the contract to a newOwner.
1400      * @param newOwner The address to transfer ownership to.
1401      */
1402     function _transferOwnership(address newOwner) internal {
1403         require(newOwner != address(0));
1404         emit OwnershipTransferred(_owner, newOwner);
1405         _owner = newOwner;
1406     }
1407 }
1408 
1409 // File: contracts\crowdsale\CMIRPDCrowdsale.sol
1410 
1411 pragma solidity ^0.5.0;
1412 
1413 
1414 
1415 
1416 
1417 
1418 
1419 /**
1420  * @title CMIRPDCrowdsale
1421  * @dev CMIRPDCrowdsale is an ERC-20 tokens crowdsale. Contract uses ETH as a fund raising currency. Features:
1422  *   - Capped - has a cap (maximum, hard cap) on ETH funds raised
1423  *   - Minted - new tokens are minted during crowdsale
1424  *   - Timed - has opening and closing time
1425  *   - Increasing price - price increases linearly from the opening to the closing time
1426  *   - Refundable - has a goal (minimum, soft cap), if not exceeded, funds are returned to investors
1427  *   - PostDelivery - tokens are withdrawn after crowsale is successfully finished, if tokens not paused
1428  * @author TokenMint (visit https://tokenmint.io)
1429  */
1430 contract CMIRPDCrowdsale is CappedCrowdsale, MintedCrowdsale, IncreasingPriceCrowdsale, RefundablePostDeliveryCrowdsale, Ownable {
1431 
1432     // minimum amount of wei needed for single investment
1433     uint256 private _minimumInvestmentWei;
1434 
1435     /**
1436     * @dev Constructor, creates CMIRPDCrowdsale.
1437     * @param openingTime Crowdsale opening time
1438     * @param closingTime Crowdsale closing time
1439     * @param initialRate How many smallest token units a buyer gets per wei at the beginning of the crowdsale
1440     * @param finalRate How many smallest token units a buyer gets per wei at the end of the crowdsale
1441     * @param fundRaisingAddress Address where raised funds will be transfered if crowdsale is successful
1442     * @param tokenContractAddress ERC20Mintable contract address of the token being sold, already deployed
1443     * @param cap Cap on funds raised (maximum, hard cap)
1444     * @param goal Goal on funds raised (minimum, soft cap)
1445     * @param minimumInvestmentWei Minimum amount of wei needed for single investment
1446     * @param feeReceiverAddress Address that receives fees for contract deployment
1447     */
1448     constructor (
1449         uint256 openingTime,
1450         uint256 closingTime,
1451         uint256 initialRate,
1452         uint256 finalRate,
1453         address payable fundRaisingAddress,
1454         ERC20Mintable tokenContractAddress,
1455         uint256 cap,
1456         uint256 goal,
1457         uint256 minimumInvestmentWei,
1458         address payable feeReceiverAddress
1459     )
1460         public payable
1461         Crowdsale(initialRate, fundRaisingAddress, tokenContractAddress)
1462         CappedCrowdsale(cap)
1463         TimedCrowdsale(openingTime, closingTime)
1464         IncreasingPriceCrowdsale(initialRate, finalRate)
1465         RefundableCrowdsale(goal)
1466     {
1467         // As goal needs to be met for a successful crowdsale
1468         // the value needs to less or equal than a cap which is limit for accepted funds
1469         require(goal <= cap);
1470 
1471         // set minimum investment
1472         _minimumInvestmentWei = minimumInvestmentWei;
1473     }
1474 
1475     /**
1476      * @return minimum investment amount in wei
1477      */
1478     function minimumInvestmentWei() public view returns (uint256) {
1479         return _minimumInvestmentWei;
1480     }
1481 
1482     /**
1483      * @dev Extend parent behavior requiring purchase to respect the minimum investment amount in wei
1484      * @param beneficiary Token purchaser
1485      * @param weiAmount Amount of wei contributed
1486      */
1487     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
1488         super._preValidatePurchase(beneficiary, weiAmount);
1489         require(weiAmount >= _minimumInvestmentWei);
1490     }
1491 }