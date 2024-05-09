1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 pragma solidity ^0.5.0;
26 
27 /**
28  * @title SafeMath
29  * @dev Unsigned math operations with safety checks that revert on error.
30  */
31 library SafeMath {
32     /**
33      * @dev Multiplies two unsigned integers, reverts on overflow.
34      */
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
37         // benefit is lost if 'b' is also tested.
38         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
39         if (a == 0) {
40             return 0;
41         }
42 
43         uint256 c = a * b;
44         require(c / a == b, "SafeMath: multiplication overflow");
45 
46         return c;
47     }
48 
49     /**
50      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
51      */
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         // Solidity only automatically asserts when dividing by 0
54         require(b > 0, "SafeMath: division by zero");
55         uint256 c = a / b;
56         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57 
58         return c;
59     }
60 
61     /**
62      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
63      */
64     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65         require(b <= a, "SafeMath: subtraction overflow");
66         uint256 c = a - b;
67 
68         return c;
69     }
70 
71     /**
72      * @dev Adds two unsigned integers, reverts on overflow.
73      */
74     function add(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a + b;
76         require(c >= a, "SafeMath: addition overflow");
77 
78         return c;
79     }
80 
81     /**
82      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
83      * reverts when dividing by zero.
84      */
85     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
86         require(b != 0, "SafeMath: modulo by zero");
87         return a % b;
88     }
89 }
90 
91 pragma solidity ^0.5.0;
92 
93 /**
94  * Utility library of inline functions on addresses
95  */
96 library Address {
97     /**
98      * Returns whether the target address is a contract
99      * @dev This function will return false if invoked during the constructor of a contract,
100      * as the code is not actually created until after the constructor finishes.
101      * @param account address of the account to check
102      * @return whether the target address is a contract
103      */
104     function isContract(address account) internal view returns (bool) {
105         uint256 size;
106         // XXX Currently there is no better way to check if there is a contract in an address
107         // than to check the size of the code at that address.
108         // See https://ethereum.stackexchange.com/a/14016/36603
109         // for more details about how this works.
110         // TODO Check this again before the Serenity release, because all addresses will be
111         // contracts then.
112         // solhint-disable-next-line no-inline-assembly
113         assembly { size := extcodesize(account) }
114         return size > 0;
115     }
116 }
117 
118 pragma solidity ^0.5.0;
119 
120 /**
121  * @title SafeERC20
122  * @dev Wrappers around ERC20 operations that throw on failure (when the token
123  * contract returns false). Tokens that return no value (and instead revert or
124  * throw on failure) are also supported, non-reverting calls are assumed to be
125  * successful.
126  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
127  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
128  */
129 library SafeERC20 {
130     using SafeMath for uint256;
131     using Address for address;
132 
133     function safeTransfer(IERC20 token, address to, uint256 value) internal {
134         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
135     }
136 
137     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
138         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
139     }
140 
141     function safeApprove(IERC20 token, address spender, uint256 value) internal {
142         // safeApprove should only be called when setting an initial allowance,
143         // or when resetting it to zero. To increase and decrease it, use
144         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
145         // solhint-disable-next-line max-line-length
146         require((value == 0) || (token.allowance(address(this), spender) == 0),
147             "SafeERC20: approve from non-zero to non-zero allowance"
148         );
149         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
150     }
151 
152     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
153         uint256 newAllowance = token.allowance(address(this), spender).add(value);
154         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
155     }
156 
157     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
158         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
159         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
160     }
161 
162     /**
163      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
164      * on the return value: the return value is optional (but if data is returned, it must not be false).
165      * @param token The token targeted by the call.
166      * @param data The call data (encoded using abi.encode or one of its variants).
167      */
168     function callOptionalReturn(IERC20 token, bytes memory data) private {
169         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
170         // we're implementing it ourselves.
171 
172         // A Solidity high level call has three parts:
173         //  1. The target address is checked to verify it contains contract code
174         //  2. The call itself is made, and success asserted
175         //  3. The return value is decoded, which in turn checks the size of the returned data.
176         // solhint-disable-next-line max-line-length
177         require(address(token).isContract(), "SafeERC20: call to non-contract");
178 
179         // solhint-disable-next-line avoid-low-level-calls
180         (bool success, bytes memory returndata) = address(token).call(data);
181         require(success, "SafeERC20: low-level call failed");
182 
183         if (returndata.length > 0) { // Return data is optional
184             // solhint-disable-next-line max-line-length
185             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
186         }
187     }
188 }
189 
190 pragma solidity ^0.5.0;
191 
192 /**
193  * @title Helps contracts guard against reentrancy attacks.
194  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
195  * @dev If you mark a function `nonReentrant`, you should also
196  * mark it `external`.
197  */
198 contract ReentrancyGuard {
199     /// @dev counter to allow mutex lock with only one SSTORE operation
200     uint256 private _guardCounter;
201 
202     constructor () internal {
203         // The counter starts at one to prevent changing it from zero to a non-zero
204         // value, which is a more expensive operation.
205         _guardCounter = 1;
206     }
207 
208     /**
209      * @dev Prevents a contract from calling itself, directly or indirectly.
210      * Calling a `nonReentrant` function from another `nonReentrant`
211      * function is not supported. It is possible to prevent this from happening
212      * by making the `nonReentrant` function external, and make it call a
213      * `private` function that does the actual work.
214      */
215     modifier nonReentrant() {
216         _guardCounter += 1;
217         uint256 localCounter = _guardCounter;
218         _;
219         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
220     }
221 }
222 
223 pragma solidity ^0.5.0;
224 
225 /**
226  * @title Crowdsale
227  * @dev Crowdsale is a base contract for managing a token crowdsale,
228  * allowing investors to purchase tokens with ether. This contract implements
229  * such functionality in its most fundamental form and can be extended to provide additional
230  * functionality and/or custom behavior.
231  * The external interface represents the basic interface for purchasing tokens, and conforms
232  * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
233  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
234  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
235  * behavior.
236  */
237 contract Crowdsale is ReentrancyGuard {
238     using SafeMath for uint256;
239     using SafeERC20 for IERC20;
240 
241     // The token being sold
242     IERC20 private _token;
243 
244     // Address where funds are collected
245     address payable private _wallet;
246 
247     // How many token units a buyer gets per wei.
248     // The rate is the conversion between wei and the smallest and indivisible token unit.
249     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
250     // 1 wei will give you 1 unit, or 0.001 TOK.
251     uint256 private _rate;
252 
253     // Amount of wei raised
254     uint256 private _weiRaised;
255 
256     /**
257      * Event for token purchase logging
258      * @param purchaser who paid for the tokens
259      * @param beneficiary who got the tokens
260      * @param value weis paid for purchase
261      * @param amount amount of tokens purchased
262      */
263     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
264 
265     /**
266      * @param rate Number of token units a buyer gets per wei
267      * @dev The rate is the conversion between wei and the smallest and indivisible
268      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
269      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
270      * @param wallet Address where collected funds will be forwarded to
271      * @param token Address of the token being sold
272      */
273     constructor (uint256 rate, address payable wallet, IERC20 token) public {
274         require(rate > 0, "Crowdsale: rate is 0");
275         require(wallet != address(0), "Crowdsale: wallet is the zero address");
276         require(address(token) != address(0), "Crowdsale: token is the zero address");
277 
278         _rate = rate;
279         _wallet = wallet;
280         _token = token;
281     }
282 
283     /**
284      * @dev fallback function ***DO NOT OVERRIDE***
285      * Note that other contracts will transfer funds with a base gas stipend
286      * of 2300, which is not enough to call buyTokens. Consider calling
287      * buyTokens directly when purchasing tokens from a contract.
288      */
289     function () external payable {
290         buyTokens(msg.sender);
291     }
292 
293     /**
294      * @return the token being sold.
295      */
296     function token() public view returns (IERC20) {
297         return _token;
298     }
299 
300     /**
301      * @return the address where funds are collected.
302      */
303     function wallet() public view returns (address payable) {
304         return _wallet;
305     }
306 
307     /**
308      * @return the number of token units a buyer gets per wei.
309      */
310     function rate() public view returns (uint256) {
311         return _rate;
312     }
313 
314     /**
315      * @return the amount of wei raised.
316      */
317     function weiRaised() public view returns (uint256) {
318         return _weiRaised;
319     }
320 
321     /**
322      * @dev low level token purchase ***DO NOT OVERRIDE***
323      * This function has a non-reentrancy guard, so it shouldn't be called by
324      * another `nonReentrant` function.
325      * @param beneficiary Recipient of the token purchase
326      */
327     function buyTokens(address beneficiary) public nonReentrant payable {
328         uint256 weiAmount = msg.value;
329         _preValidatePurchase(beneficiary, weiAmount);
330 
331         // calculate token amount to be created
332         uint256 tokens = _getTokenAmount(weiAmount);
333 
334         // update state
335         _weiRaised = _weiRaised.add(weiAmount);
336 
337         _processPurchase(beneficiary, tokens);
338         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
339 
340         _updatePurchasingState(beneficiary, weiAmount);
341 
342         _forwardFunds();
343         _postValidatePurchase(beneficiary, weiAmount);
344     }
345 
346     /**
347      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
348      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
349      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
350      *     super._preValidatePurchase(beneficiary, weiAmount);
351      *     require(weiRaised().add(weiAmount) <= cap);
352      * @param beneficiary Address performing the token purchase
353      * @param weiAmount Value in wei involved in the purchase
354      */
355     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
356         require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
357         require(weiAmount != 0, "Crowdsale: weiAmount is 0");
358     }
359 
360     /**
361      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
362      * conditions are not met.
363      * @param beneficiary Address performing the token purchase
364      * @param weiAmount Value in wei involved in the purchase
365      */
366     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
367         // solhint-disable-previous-line no-empty-blocks
368     }
369 
370     /**
371      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
372      * its tokens.
373      * @param beneficiary Address performing the token purchase
374      * @param tokenAmount Number of tokens to be emitted
375      */
376     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
377         _token.safeTransfer(beneficiary, tokenAmount);
378     }
379 
380     /**
381      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
382      * tokens.
383      * @param beneficiary Address receiving the tokens
384      * @param tokenAmount Number of tokens to be purchased
385      */
386     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
387         _deliverTokens(beneficiary, tokenAmount);
388     }
389 
390     /**
391      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
392      * etc.)
393      * @param beneficiary Address receiving the tokens
394      * @param weiAmount Value in wei involved in the purchase
395      */
396     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
397         // solhint-disable-previous-line no-empty-blocks
398     }
399 
400     /**
401      * @dev Override to extend the way in which ether is converted to tokens.
402      * @param weiAmount Value in wei to be converted into tokens
403      * @return Number of tokens that can be purchased with the specified _weiAmount
404      */
405     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
406         return weiAmount.mul(_rate);
407     }
408 
409     /**
410      * @dev Determines how ETH is stored/forwarded on purchases.
411      */
412     function _forwardFunds() internal {
413         _wallet.transfer(msg.value);
414     }
415 }
416 
417 pragma solidity ^0.5.0;
418 
419 /**
420  * @title Roles
421  * @dev Library for managing addresses assigned to a Role.
422  */
423 library Roles {
424     struct Role {
425         mapping (address => bool) bearer;
426     }
427 
428     /**
429      * @dev Give an account access to this role.
430      */
431     function add(Role storage role, address account) internal {
432         require(!has(role, account), "Roles: account already has role");
433         role.bearer[account] = true;
434     }
435 
436     /**
437      * @dev Remove an account's access to this role.
438      */
439     function remove(Role storage role, address account) internal {
440         require(has(role, account), "Roles: account does not have role");
441         role.bearer[account] = false;
442     }
443 
444     /**
445      * @dev Check if an account has this role.
446      * @return bool
447      */
448     function has(Role storage role, address account) internal view returns (bool) {
449         require(account != address(0), "Roles: account is the zero address");
450         return role.bearer[account];
451     }
452 }
453 
454 pragma solidity ^0.5.0;
455 
456 contract PauserRole {
457     using Roles for Roles.Role;
458 
459     event PauserAdded(address indexed account);
460     event PauserRemoved(address indexed account);
461 
462     Roles.Role private _pausers;
463 
464     constructor () internal {
465         _addPauser(msg.sender);
466     }
467 
468     modifier onlyPauser() {
469         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
470         _;
471     }
472 
473     function isPauser(address account) public view returns (bool) {
474         return _pausers.has(account);
475     }
476 
477     function addPauser(address account) public onlyPauser {
478         _addPauser(account);
479     }
480 
481     function renouncePauser() public {
482         _removePauser(msg.sender);
483     }
484 
485     function _addPauser(address account) internal {
486         _pausers.add(account);
487         emit PauserAdded(account);
488     }
489 
490     function _removePauser(address account) internal {
491         _pausers.remove(account);
492         emit PauserRemoved(account);
493     }
494 }
495 
496 pragma solidity ^0.5.0;
497 
498 /**
499  * @title Pausable
500  * @dev Base contract which allows children to implement an emergency stop mechanism.
501  */
502 contract Pausable is PauserRole {
503     event Paused(address account);
504     event Unpaused(address account);
505 
506     bool private _paused;
507 
508     constructor () internal {
509         _paused = false;
510     }
511 
512     /**
513      * @return True if the contract is paused, false otherwise.
514      */
515     function paused() public view returns (bool) {
516         return _paused;
517     }
518 
519     /**
520      * @dev Modifier to make a function callable only when the contract is not paused.
521      */
522     modifier whenNotPaused() {
523         require(!_paused, "Pausable: paused");
524         _;
525     }
526 
527     /**
528      * @dev Modifier to make a function callable only when the contract is paused.
529      */
530     modifier whenPaused() {
531         require(_paused, "Pausable: not paused");
532         _;
533     }
534 
535     /**
536      * @dev Called by a pauser to pause, triggers stopped state.
537      */
538     function pause() public onlyPauser whenNotPaused {
539         _paused = true;
540         emit Paused(msg.sender);
541     }
542 
543     /**
544      * @dev Called by a pauser to unpause, returns to normal state.
545      */
546     function unpause() public onlyPauser whenPaused {
547         _paused = false;
548         emit Unpaused(msg.sender);
549     }
550 }
551 
552 pragma solidity ^0.5.0;
553 
554 /**
555  * @title PausableCrowdsale
556  * @dev Extension of Crowdsale contract where purchases can be paused and unpaused by the pauser role.
557  */
558 contract PausableCrowdsale is Crowdsale, Pausable {
559     /**
560      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
561      * Use super to concatenate validations.
562      * Adds the validation that the crowdsale must not be paused.
563      * @param _beneficiary Address performing the token purchase
564      * @param _weiAmount Value in wei involved in the purchase
565      */
566     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view whenNotPaused {
567         return super._preValidatePurchase(_beneficiary, _weiAmount);
568     }
569 }
570 
571 pragma solidity ^0.5.0;
572 
573 /**
574  * @title CappedCrowdsale
575  * @dev Crowdsale with a limit for total contributions.
576  */
577 contract CappedCrowdsale is Crowdsale {
578     using SafeMath for uint256;
579 
580     uint256 private _cap;
581 
582     /**
583      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
584      * @param cap Max amount of wei to be contributed
585      */
586     constructor (uint256 cap) public {
587         require(cap > 0, "CappedCrowdsale: cap is 0");
588         _cap = cap;
589     }
590 
591     /**
592      * @return the cap of the crowdsale.
593      */
594     function cap() public view returns (uint256) {
595         return _cap;
596     }
597 
598     /**
599      * @dev Checks whether the cap has been reached.
600      * @return Whether the cap was reached
601      */
602     function capReached() public view returns (bool) {
603         return weiRaised() >= _cap;
604     }
605 
606     /**
607      * @dev Extend parent behavior requiring purchase to respect the funding cap.
608      * @param beneficiary Token purchaser
609      * @param weiAmount Amount of wei contributed
610      */
611     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
612         super._preValidatePurchase(beneficiary, weiAmount);
613         require(weiRaised().add(weiAmount) <= _cap, "CappedCrowdsale: cap exceeded");
614     }
615 }
616 
617 pragma solidity ^0.5.0;
618 
619 /**
620  * @title Standard ERC20 token
621  *
622  * @dev Implementation of the basic standard token.
623  * https://eips.ethereum.org/EIPS/eip-20
624  * Originally based on code by FirstBlood:
625  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
626  *
627  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
628  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
629  * compliant implementations may not do it.
630  */
631 contract ERC20 is IERC20 {
632     using SafeMath for uint256;
633 
634     mapping (address => uint256) private _balances;
635 
636     mapping (address => mapping (address => uint256)) private _allowed;
637 
638     uint256 private _totalSupply;
639 
640     /**
641      * @dev Total number of tokens in existence.
642      */
643     function totalSupply() public view returns (uint256) {
644         return _totalSupply;
645     }
646 
647     /**
648      * @dev Gets the balance of the specified address.
649      * @param owner The address to query the balance of.
650      * @return A uint256 representing the amount owned by the passed address.
651      */
652     function balanceOf(address owner) public view returns (uint256) {
653         return _balances[owner];
654     }
655 
656     /**
657      * @dev Function to check the amount of tokens that an owner allowed to a spender.
658      * @param owner address The address which owns the funds.
659      * @param spender address The address which will spend the funds.
660      * @return A uint256 specifying the amount of tokens still available for the spender.
661      */
662     function allowance(address owner, address spender) public view returns (uint256) {
663         return _allowed[owner][spender];
664     }
665 
666     /**
667      * @dev Transfer token to a specified address.
668      * @param to The address to transfer to.
669      * @param value The amount to be transferred.
670      */
671     function transfer(address to, uint256 value) public returns (bool) {
672         _transfer(msg.sender, to, value);
673         return true;
674     }
675 
676     /**
677      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
678      * Beware that changing an allowance with this method brings the risk that someone may use both the old
679      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
680      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
681      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
682      * @param spender The address which will spend the funds.
683      * @param value The amount of tokens to be spent.
684      */
685     function approve(address spender, uint256 value) public returns (bool) {
686         _approve(msg.sender, spender, value);
687         return true;
688     }
689 
690     /**
691      * @dev Transfer tokens from one address to another.
692      * Note that while this function emits an Approval event, this is not required as per the specification,
693      * and other compliant implementations may not emit the event.
694      * @param from address The address which you want to send tokens from
695      * @param to address The address which you want to transfer to
696      * @param value uint256 the amount of tokens to be transferred
697      */
698     function transferFrom(address from, address to, uint256 value) public returns (bool) {
699         _transfer(from, to, value);
700         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
701         return true;
702     }
703 
704     /**
705      * @dev Increase the amount of tokens that an owner allowed to a spender.
706      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
707      * allowed value is better to use this function to avoid 2 calls (and wait until
708      * the first transaction is mined)
709      * From MonolithDAO Token.sol
710      * Emits an Approval event.
711      * @param spender The address which will spend the funds.
712      * @param addedValue The amount of tokens to increase the allowance by.
713      */
714     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
715         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
716         return true;
717     }
718 
719     /**
720      * @dev Decrease the amount of tokens that an owner allowed to a spender.
721      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
722      * allowed value is better to use this function to avoid 2 calls (and wait until
723      * the first transaction is mined)
724      * From MonolithDAO Token.sol
725      * Emits an Approval event.
726      * @param spender The address which will spend the funds.
727      * @param subtractedValue The amount of tokens to decrease the allowance by.
728      */
729     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
730         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
731         return true;
732     }
733 
734     /**
735      * @dev Transfer token for a specified addresses.
736      * @param from The address to transfer from.
737      * @param to The address to transfer to.
738      * @param value The amount to be transferred.
739      */
740     function _transfer(address from, address to, uint256 value) internal {
741         require(to != address(0), "ERC20: transfer to the zero address");
742 
743         _balances[from] = _balances[from].sub(value);
744         _balances[to] = _balances[to].add(value);
745         emit Transfer(from, to, value);
746     }
747 
748     /**
749      * @dev Internal function that mints an amount of the token and assigns it to
750      * an account. This encapsulates the modification of balances such that the
751      * proper events are emitted.
752      * @param account The account that will receive the created tokens.
753      * @param value The amount that will be created.
754      */
755     function _mint(address account, uint256 value) internal {
756         require(account != address(0), "ERC20: mint to the zero address");
757 
758         _totalSupply = _totalSupply.add(value);
759         _balances[account] = _balances[account].add(value);
760         emit Transfer(address(0), account, value);
761     }
762 
763     /**
764      * @dev Internal function that burns an amount of the token of a given
765      * account.
766      * @param account The account whose tokens will be burnt.
767      * @param value The amount that will be burnt.
768      */
769     function _burn(address account, uint256 value) internal {
770         require(account != address(0), "ERC20: burn from the zero address");
771 
772         _totalSupply = _totalSupply.sub(value);
773         _balances[account] = _balances[account].sub(value);
774         emit Transfer(account, address(0), value);
775     }
776 
777     /**
778      * @dev Approve an address to spend another addresses' tokens.
779      * @param owner The address that owns the tokens.
780      * @param spender The address that will spend the tokens.
781      * @param value The number of tokens that can be spent.
782      */
783     function _approve(address owner, address spender, uint256 value) internal {
784         require(owner != address(0), "ERC20: approve from the zero address");
785         require(spender != address(0), "ERC20: approve to the zero address");
786 
787         _allowed[owner][spender] = value;
788         emit Approval(owner, spender, value);
789     }
790 
791     /**
792      * @dev Internal function that burns an amount of the token of a given
793      * account, deducting from the sender's allowance for said account. Uses the
794      * internal burn function.
795      * Emits an Approval event (reflecting the reduced allowance).
796      * @param account The account whose tokens will be burnt.
797      * @param value The amount that will be burnt.
798      */
799     function _burnFrom(address account, uint256 value) internal {
800         _burn(account, value);
801         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
802     }
803 }
804 
805 pragma solidity ^0.5.0;
806 
807 contract MinterRole {
808     using Roles for Roles.Role;
809 
810     event MinterAdded(address indexed account);
811     event MinterRemoved(address indexed account);
812 
813     Roles.Role private _minters;
814 
815     constructor () internal {
816         _addMinter(msg.sender);
817     }
818 
819     modifier onlyMinter() {
820         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
821         _;
822     }
823 
824     function isMinter(address account) public view returns (bool) {
825         return _minters.has(account);
826     }
827 
828     function addMinter(address account) public onlyMinter {
829         _addMinter(account);
830     }
831 
832     function renounceMinter() public {
833         _removeMinter(msg.sender);
834     }
835 
836     function _addMinter(address account) internal {
837         _minters.add(account);
838         emit MinterAdded(account);
839     }
840 
841     function _removeMinter(address account) internal {
842         _minters.remove(account);
843         emit MinterRemoved(account);
844     }
845 }
846 
847 pragma solidity ^0.5.0;
848 
849 /**
850  * @title ERC20Mintable
851  * @dev ERC20 minting logic.
852  */
853 contract ERC20Mintable is ERC20, MinterRole {
854     /**
855      * @dev Function to mint tokens
856      * @param to The address that will receive the minted tokens.
857      * @param value The amount of tokens to mint.
858      * @return A boolean that indicates if the operation was successful.
859      */
860     function mint(address to, uint256 value) public onlyMinter returns (bool) {
861         _mint(to, value);
862         return true;
863     }
864 }
865 
866 pragma solidity ^0.5.0;
867 
868 /**
869  * @title MintedCrowdsale
870  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
871  * Token ownership should be transferred to MintedCrowdsale for minting.
872  */
873 contract MintedCrowdsale is Crowdsale {
874     /**
875      * @dev Overrides delivery by minting tokens upon purchase.
876      * @param beneficiary Token purchaser
877      * @param tokenAmount Number of tokens to be minted
878      */
879     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
880         // Potentially dangerous assumption about the type of the token.
881         require(
882             ERC20Mintable(address(token())).mint(beneficiary, tokenAmount),
883                 "MintedCrowdsale: minting failed"
884         );
885     }
886 }
887 
888 pragma solidity ^0.5.0;
889 
890 /**
891  * @title TimedCrowdsale
892  * @dev Crowdsale accepting contributions only within a time frame.
893  */
894 contract TimedCrowdsale is Crowdsale {
895     using SafeMath for uint256;
896 
897     uint256 private _openingTime;
898     uint256 private _closingTime;
899 
900     /**
901      * Event for crowdsale extending
902      * @param newClosingTime new closing time
903      * @param prevClosingTime old closing time
904      */
905     event TimedCrowdsaleExtended(uint256 prevClosingTime, uint256 newClosingTime);
906 
907     /**
908      * @dev Reverts if not in crowdsale time range.
909      */
910     modifier onlyWhileOpen {
911         require(isOpen(), "TimedCrowdsale: not open");
912         _;
913     }
914 
915     /**
916      * @dev Constructor, takes crowdsale opening and closing times.
917      * @param openingTime Crowdsale opening time
918      * @param closingTime Crowdsale closing time
919      */
920     constructor (uint256 openingTime, uint256 closingTime) public {
921         // solhint-disable-next-line not-rely-on-time
922         require(openingTime >= block.timestamp, "TimedCrowdsale: opening time is before current time");
923         // solhint-disable-next-line max-line-length
924         require(closingTime > openingTime, "TimedCrowdsale: opening time is not before closing time");
925 
926         _openingTime = openingTime;
927         _closingTime = closingTime;
928     }
929 
930     /**
931      * @return the crowdsale opening time.
932      */
933     function openingTime() public view returns (uint256) {
934         return _openingTime;
935     }
936 
937     /**
938      * @return the crowdsale closing time.
939      */
940     function closingTime() public view returns (uint256) {
941         return _closingTime;
942     }
943 
944     /**
945      * @return true if the crowdsale is open, false otherwise.
946      */
947     function isOpen() public view returns (bool) {
948         // solhint-disable-next-line not-rely-on-time
949         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
950     }
951 
952     /**
953      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
954      * @return Whether crowdsale period has elapsed
955      */
956     function hasClosed() public view returns (bool) {
957         // solhint-disable-next-line not-rely-on-time
958         return block.timestamp > _closingTime;
959     }
960 
961     /**
962      * @dev Extend parent behavior requiring to be within contributing period.
963      * @param beneficiary Token purchaser
964      * @param weiAmount Amount of wei contributed
965      */
966     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
967         super._preValidatePurchase(beneficiary, weiAmount);
968     }
969 
970     /**
971      * @dev Extend crowdsale.
972      * @param newClosingTime Crowdsale closing time
973      */
974     function _extendTime(uint256 newClosingTime) internal {
975         require(!hasClosed(), "TimedCrowdsale: already closed");
976         // solhint-disable-next-line max-line-length
977         require(newClosingTime > _closingTime, "TimedCrowdsale: new closing time is before current closing time");
978 
979         emit TimedCrowdsaleExtended(_closingTime, newClosingTime);
980         _closingTime = newClosingTime;
981     }
982 }
983 
984 pragma solidity ^0.5.0;
985 
986 /**
987  * @title FinalizableCrowdsale
988  * @dev Extension of TimedCrowdsale with a one-off finalization action, where one
989  * can do extra work after finishing.
990  */
991 contract FinalizableCrowdsale is TimedCrowdsale {
992     using SafeMath for uint256;
993 
994     bool private _finalized;
995 
996     event CrowdsaleFinalized();
997 
998     constructor () internal {
999         _finalized = false;
1000     }
1001 
1002     /**
1003      * @return true if the crowdsale is finalized, false otherwise.
1004      */
1005     function finalized() public view returns (bool) {
1006         return _finalized;
1007     }
1008 
1009     /**
1010      * @dev Must be called after crowdsale ends, to do some extra finalization
1011      * work. Calls the contract's finalization function.
1012      */
1013     function finalize() public {
1014         require(!_finalized, "FinalizableCrowdsale: already finalized");
1015         require(hasClosed(), "FinalizableCrowdsale: not closed");
1016 
1017         _finalized = true;
1018 
1019         _finalization();
1020         emit CrowdsaleFinalized();
1021     }
1022 
1023     /**
1024      * @dev Can be overridden to add finalization logic. The overriding function
1025      * should call super._finalization() to ensure the chain of finalization is
1026      * executed entirely.
1027      */
1028     function _finalization() internal {
1029         // solhint-disable-previous-line no-empty-blocks
1030     }
1031 }
1032 
1033 pragma solidity ^0.5.0;
1034 
1035 /**
1036  * @title Capped token
1037  * @dev Mintable token with a token cap.
1038  */
1039 contract ERC20Capped is ERC20Mintable {
1040     uint256 private _cap;
1041 
1042     constructor (uint256 cap) public {
1043         require(cap > 0, "ERC20Capped: cap is 0");
1044         _cap = cap;
1045     }
1046 
1047     /**
1048      * @return the cap for the token minting.
1049      */
1050     function cap() public view returns (uint256) {
1051         return _cap;
1052     }
1053 
1054     function _mint(address account, uint256 value) internal {
1055         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
1056         super._mint(account, value);
1057     }
1058 }
1059 
1060 
1061 
1062 
1063 
1064 pragma solidity ^0.5.0;
1065 
1066 contract MTB19Crowdsale is MintedCrowdsale, PausableCrowdsale, FinalizableCrowdsale, CappedCrowdsale {
1067 
1068    constructor(uint256 rate, address payable wallet, IERC20 token,
1069                uint256 openingTime, uint256 closingTime,
1070                uint256 cap
1071               ) public Crowdsale(rate, wallet, token)
1072                         TimedCrowdsale(openingTime, closingTime)
1073                         FinalizableCrowdsale()
1074                         CappedCrowdsale(cap) { }
1075 
1076    /**
1077      * @dev Overrides finalization of FinalizableCrowdsale. It stores the remaining tokens to the
1078             fundwallet and renounces minter role.
1079    */
1080 
1081    function _finalization() internal {
1082 
1083       uint256 remaining = ERC20Capped(address(token())).cap() - ERC20(address(token())).totalSupply();
1084       if (remaining > 0) ERC20Capped(address(super.token())).mint(super.wallet(), remaining);
1085 
1086       MinterRole(address(token())).renounceMinter();
1087 
1088       super._finalization();
1089 
1090    }
1091 
1092 }