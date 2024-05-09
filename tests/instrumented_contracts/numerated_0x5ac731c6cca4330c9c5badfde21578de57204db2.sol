1 pragma solidity ^0.5.0;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
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
27 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
28 
29 /**
30  * @title SafeMath
31  * @dev Unsigned math operations with safety checks that revert on error
32  */
33 library SafeMath {
34     /**
35     * @dev Multiplies two unsigned integers, reverts on overflow.
36     */
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39         // benefit is lost if 'b' is also tested.
40         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41         if (a == 0) {
42             return 0;
43         }
44 
45         uint256 c = a * b;
46         require(c / a == b);
47 
48         return c;
49     }
50 
51     /**
52     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
53     */
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         // Solidity only automatically asserts when dividing by 0
56         require(b > 0);
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59 
60         return c;
61     }
62 
63     /**
64     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
65     */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b <= a);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     /**
74     * @dev Adds two unsigned integers, reverts on overflow.
75     */
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a);
79 
80         return c;
81     }
82 
83     /**
84     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
85     * reverts when dividing by zero.
86     */
87     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b != 0);
89         return a % b;
90     }
91 }
92 
93 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
100  * Originally based on code by FirstBlood:
101  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  *
103  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
104  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
105  * compliant implementations may not do it.
106  */
107 contract ERC20 is IERC20 {
108     using SafeMath for uint256;
109 
110     mapping (address => uint256) private _balances;
111 
112     mapping (address => mapping (address => uint256)) private _allowed;
113 
114     uint256 private _totalSupply;
115 
116     /**
117     * @dev Total number of tokens in existence
118     */
119     function totalSupply() public view returns (uint256) {
120         return _totalSupply;
121     }
122 
123     /**
124     * @dev Gets the balance of the specified address.
125     * @param owner The address to query the balance of.
126     * @return An uint256 representing the amount owned by the passed address.
127     */
128     function balanceOf(address owner) public view returns (uint256) {
129         return _balances[owner];
130     }
131 
132     /**
133      * @dev Function to check the amount of tokens that an owner allowed to a spender.
134      * @param owner address The address which owns the funds.
135      * @param spender address The address which will spend the funds.
136      * @return A uint256 specifying the amount of tokens still available for the spender.
137      */
138     function allowance(address owner, address spender) public view returns (uint256) {
139         return _allowed[owner][spender];
140     }
141 
142     /**
143     * @dev Transfer token for a specified address
144     * @param to The address to transfer to.
145     * @param value The amount to be transferred.
146     */
147     function transfer(address to, uint256 value) public returns (bool) {
148         _transfer(msg.sender, to, value);
149         return true;
150     }
151 
152     /**
153      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154      * Beware that changing an allowance with this method brings the risk that someone may use both the old
155      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      * @param spender The address which will spend the funds.
159      * @param value The amount of tokens to be spent.
160      */
161     function approve(address spender, uint256 value) public returns (bool) {
162         require(spender != address(0));
163 
164         _allowed[msg.sender][spender] = value;
165         emit Approval(msg.sender, spender, value);
166         return true;
167     }
168 
169     /**
170      * @dev Transfer tokens from one address to another.
171      * Note that while this function emits an Approval event, this is not required as per the specification,
172      * and other compliant implementations may not emit the event.
173      * @param from address The address which you want to send tokens from
174      * @param to address The address which you want to transfer to
175      * @param value uint256 the amount of tokens to be transferred
176      */
177     function transferFrom(address from, address to, uint256 value) public returns (bool) {
178         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
179         _transfer(from, to, value);
180         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
181         return true;
182     }
183 
184     /**
185      * @dev Increase the amount of tokens that an owner allowed to a spender.
186      * approve should be called when allowed_[_spender] == 0. To increment
187      * allowed value is better to use this function to avoid 2 calls (and wait until
188      * the first transaction is mined)
189      * From MonolithDAO Token.sol
190      * Emits an Approval event.
191      * @param spender The address which will spend the funds.
192      * @param addedValue The amount of tokens to increase the allowance by.
193      */
194     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
195         require(spender != address(0));
196 
197         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
198         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
199         return true;
200     }
201 
202     /**
203      * @dev Decrease the amount of tokens that an owner allowed to a spender.
204      * approve should be called when allowed_[_spender] == 0. To decrement
205      * allowed value is better to use this function to avoid 2 calls (and wait until
206      * the first transaction is mined)
207      * From MonolithDAO Token.sol
208      * Emits an Approval event.
209      * @param spender The address which will spend the funds.
210      * @param subtractedValue The amount of tokens to decrease the allowance by.
211      */
212     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
213         require(spender != address(0));
214 
215         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
216         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
217         return true;
218     }
219 
220     /**
221     * @dev Transfer token for a specified addresses
222     * @param from The address to transfer from.
223     * @param to The address to transfer to.
224     * @param value The amount to be transferred.
225     */
226     function _transfer(address from, address to, uint256 value) internal {
227         require(to != address(0));
228 
229         _balances[from] = _balances[from].sub(value);
230         _balances[to] = _balances[to].add(value);
231         emit Transfer(from, to, value);
232     }
233 
234     /**
235      * @dev Internal function that mints an amount of the token and assigns it to
236      * an account. This encapsulates the modification of balances such that the
237      * proper events are emitted.
238      * @param account The account that will receive the created tokens.
239      * @param value The amount that will be created.
240      */
241     function _mint(address account, uint256 value) internal {
242         require(account != address(0));
243 
244         _totalSupply = _totalSupply.add(value);
245         _balances[account] = _balances[account].add(value);
246         emit Transfer(address(0), account, value);
247     }
248 
249     /**
250      * @dev Internal function that burns an amount of the token of a given
251      * account.
252      * @param account The account whose tokens will be burnt.
253      * @param value The amount that will be burnt.
254      */
255     function _burn(address account, uint256 value) internal {
256         require(account != address(0));
257 
258         _totalSupply = _totalSupply.sub(value);
259         _balances[account] = _balances[account].sub(value);
260         emit Transfer(account, address(0), value);
261     }
262 
263     /**
264      * @dev Internal function that burns an amount of the token of a given
265      * account, deducting from the sender's allowance for said account. Uses the
266      * internal burn function.
267      * Emits an Approval event (reflecting the reduced allowance).
268      * @param account The account whose tokens will be burnt.
269      * @param value The amount that will be burnt.
270      */
271     function _burnFrom(address account, uint256 value) internal {
272         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
273         _burn(account, value);
274         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
275     }
276 }
277 
278 // File: openzeppelin-solidity/contracts/access/Roles.sol
279 
280 /**
281  * @title Roles
282  * @dev Library for managing addresses assigned to a Role.
283  */
284 library Roles {
285     struct Role {
286         mapping (address => bool) bearer;
287     }
288 
289     /**
290      * @dev give an account access to this role
291      */
292     function add(Role storage role, address account) internal {
293         require(account != address(0));
294         require(!has(role, account));
295 
296         role.bearer[account] = true;
297     }
298 
299     /**
300      * @dev remove an account's access to this role
301      */
302     function remove(Role storage role, address account) internal {
303         require(account != address(0));
304         require(has(role, account));
305 
306         role.bearer[account] = false;
307     }
308 
309     /**
310      * @dev check if an account has this role
311      * @return bool
312      */
313     function has(Role storage role, address account) internal view returns (bool) {
314         require(account != address(0));
315         return role.bearer[account];
316     }
317 }
318 
319 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
320 
321 contract MinterRole {
322     using Roles for Roles.Role;
323 
324     event MinterAdded(address indexed account);
325     event MinterRemoved(address indexed account);
326 
327     Roles.Role private _minters;
328 
329     constructor () internal {
330         _addMinter(msg.sender);
331     }
332 
333     modifier onlyMinter() {
334         require(isMinter(msg.sender));
335         _;
336     }
337 
338     function isMinter(address account) public view returns (bool) {
339         return _minters.has(account);
340     }
341 
342     function addMinter(address account) public onlyMinter {
343         _addMinter(account);
344     }
345 
346     function renounceMinter() public {
347         _removeMinter(msg.sender);
348     }
349 
350     function _addMinter(address account) internal {
351         _minters.add(account);
352         emit MinterAdded(account);
353     }
354 
355     function _removeMinter(address account) internal {
356         _minters.remove(account);
357         emit MinterRemoved(account);
358     }
359 }
360 
361 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
362 
363 /**
364  * @title ERC20Mintable
365  * @dev ERC20 minting logic
366  */
367 contract ERC20Mintable is ERC20, MinterRole {
368     /**
369      * @dev Function to mint tokens
370      * @param to The address that will receive the minted tokens.
371      * @param value The amount of tokens to mint.
372      * @return A boolean that indicates if the operation was successful.
373      */
374     function mint(address to, uint256 value) public onlyMinter returns (bool) {
375         _mint(to, value);
376         return true;
377     }
378 }
379 
380 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
381 
382 /**
383  * @title SafeERC20
384  * @dev Wrappers around ERC20 operations that throw on failure.
385  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
386  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
387  */
388 library SafeERC20 {
389     using SafeMath for uint256;
390 
391     function safeTransfer(IERC20 token, address to, uint256 value) internal {
392         require(token.transfer(to, value));
393     }
394 
395     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
396         require(token.transferFrom(from, to, value));
397     }
398 
399     function safeApprove(IERC20 token, address spender, uint256 value) internal {
400         // safeApprove should only be called when setting an initial allowance,
401         // or when resetting it to zero. To increase and decrease it, use
402         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
403         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
404         require(token.approve(spender, value));
405     }
406 
407     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
408         uint256 newAllowance = token.allowance(address(this), spender).add(value);
409         require(token.approve(spender, newAllowance));
410     }
411 
412     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
413         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
414         require(token.approve(spender, newAllowance));
415     }
416 }
417 
418 // File: openzeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol
419 
420 /**
421  * @title TokenTimelock
422  * @dev TokenTimelock is a token holder contract that will allow a
423  * beneficiary to extract the tokens after a given release time
424  */
425 contract TokenTimelock {
426     using SafeERC20 for IERC20;
427 
428     // ERC20 basic token contract being held
429     IERC20 private _token;
430 
431     // beneficiary of tokens after they are released
432     address private _beneficiary;
433 
434     // timestamp when token release is enabled
435     uint256 private _releaseTime;
436 
437     constructor (IERC20 token, address beneficiary, uint256 releaseTime) public {
438         // solhint-disable-next-line not-rely-on-time
439         require(releaseTime > block.timestamp);
440         _token = token;
441         _beneficiary = beneficiary;
442         _releaseTime = releaseTime;
443     }
444 
445     /**
446      * @return the token being held.
447      */
448     function token() public view returns (IERC20) {
449         return _token;
450     }
451 
452     /**
453      * @return the beneficiary of the tokens.
454      */
455     function beneficiary() public view returns (address) {
456         return _beneficiary;
457     }
458 
459     /**
460      * @return the time when the tokens are released.
461      */
462     function releaseTime() public view returns (uint256) {
463         return _releaseTime;
464     }
465 
466     /**
467      * @notice Transfers tokens held by timelock to beneficiary.
468      */
469     function release() public {
470         // solhint-disable-next-line not-rely-on-time
471         require(block.timestamp >= _releaseTime);
472 
473         uint256 amount = _token.balanceOf(address(this));
474         require(amount > 0);
475 
476         _token.safeTransfer(_beneficiary, amount);
477     }
478 }
479 
480 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
481 
482 contract PauserRole {
483     using Roles for Roles.Role;
484 
485     event PauserAdded(address indexed account);
486     event PauserRemoved(address indexed account);
487 
488     Roles.Role private _pausers;
489 
490     constructor () internal {
491         _addPauser(msg.sender);
492     }
493 
494     modifier onlyPauser() {
495         require(isPauser(msg.sender));
496         _;
497     }
498 
499     function isPauser(address account) public view returns (bool) {
500         return _pausers.has(account);
501     }
502 
503     function addPauser(address account) public onlyPauser {
504         _addPauser(account);
505     }
506 
507     function renouncePauser() public {
508         _removePauser(msg.sender);
509     }
510 
511     function _addPauser(address account) internal {
512         _pausers.add(account);
513         emit PauserAdded(account);
514     }
515 
516     function _removePauser(address account) internal {
517         _pausers.remove(account);
518         emit PauserRemoved(account);
519     }
520 }
521 
522 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
523 
524 /**
525  * @title Pausable
526  * @dev Base contract which allows children to implement an emergency stop mechanism.
527  */
528 contract Pausable is PauserRole {
529     event Paused(address account);
530     event Unpaused(address account);
531 
532     bool private _paused;
533 
534     constructor () internal {
535         _paused = false;
536     }
537 
538     /**
539      * @return true if the contract is paused, false otherwise.
540      */
541     function paused() public view returns (bool) {
542         return _paused;
543     }
544 
545     /**
546      * @dev Modifier to make a function callable only when the contract is not paused.
547      */
548     modifier whenNotPaused() {
549         require(!_paused);
550         _;
551     }
552 
553     /**
554      * @dev Modifier to make a function callable only when the contract is paused.
555      */
556     modifier whenPaused() {
557         require(_paused);
558         _;
559     }
560 
561     /**
562      * @dev called by the owner to pause, triggers stopped state
563      */
564     function pause() public onlyPauser whenNotPaused {
565         _paused = true;
566         emit Paused(msg.sender);
567     }
568 
569     /**
570      * @dev called by the owner to unpause, returns to normal state
571      */
572     function unpause() public onlyPauser whenPaused {
573         _paused = false;
574         emit Unpaused(msg.sender);
575     }
576 }
577 
578 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
579 
580 /**
581  * @title Pausable token
582  * @dev ERC20 modified with pausable transfers.
583  **/
584 contract ERC20Pausable is ERC20, Pausable {
585     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
586         return super.transfer(to, value);
587     }
588 
589     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
590         return super.transferFrom(from, to, value);
591     }
592 
593     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
594         return super.approve(spender, value);
595     }
596 
597     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
598         return super.increaseAllowance(spender, addedValue);
599     }
600 
601     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
602         return super.decreaseAllowance(spender, subtractedValue);
603     }
604 }
605 
606 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
607 
608 /**
609  * @title Helps contracts guard against reentrancy attacks.
610  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
611  * @dev If you mark a function `nonReentrant`, you should also
612  * mark it `external`.
613  */
614 contract ReentrancyGuard {
615     /// @dev counter to allow mutex lock with only one SSTORE operation
616     uint256 private _guardCounter;
617 
618     constructor () internal {
619         // The counter starts at one to prevent changing it from zero to a non-zero
620         // value, which is a more expensive operation.
621         _guardCounter = 1;
622     }
623 
624     /**
625      * @dev Prevents a contract from calling itself, directly or indirectly.
626      * Calling a `nonReentrant` function from another `nonReentrant`
627      * function is not supported. It is possible to prevent this from happening
628      * by making the `nonReentrant` function external, and make it call a
629      * `private` function that does the actual work.
630      */
631     modifier nonReentrant() {
632         _guardCounter += 1;
633         uint256 localCounter = _guardCounter;
634         _;
635         require(localCounter == _guardCounter);
636     }
637 }
638 
639 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
640 
641 /**
642  * @title Crowdsale
643  * @dev Crowdsale is a base contract for managing a token crowdsale,
644  * allowing investors to purchase tokens with ether. This contract implements
645  * such functionality in its most fundamental form and can be extended to provide additional
646  * functionality and/or custom behavior.
647  * The external interface represents the basic interface for purchasing tokens, and conform
648  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
649  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
650  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
651  * behavior.
652  */
653 contract Crowdsale is ReentrancyGuard {
654     using SafeMath for uint256;
655     using SafeERC20 for IERC20;
656 
657     // The token being sold
658     IERC20 private _token;
659 
660     // Address where funds are collected
661     address payable private _wallet;
662 
663     // How many token units a buyer gets per wei.
664     // The rate is the conversion between wei and the smallest and indivisible token unit.
665     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
666     // 1 wei will give you 1 unit, or 0.001 TOK.
667     uint256 private _rate;
668 
669     // Amount of wei raised
670     uint256 private _weiRaised;
671 
672     /**
673      * Event for token purchase logging
674      * @param purchaser who paid for the tokens
675      * @param beneficiary who got the tokens
676      * @param value weis paid for purchase
677      * @param amount amount of tokens purchased
678      */
679     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
680 
681     /**
682      * @param rate Number of token units a buyer gets per wei
683      * @dev The rate is the conversion between wei and the smallest and indivisible
684      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
685      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
686      * @param wallet Address where collected funds will be forwarded to
687      * @param token Address of the token being sold
688      */
689     constructor (uint256 rate, address payable wallet, IERC20 token) public {
690         require(rate > 0);
691         require(wallet != address(0));
692         require(address(token) != address(0));
693 
694         _rate = rate;
695         _wallet = wallet;
696         _token = token;
697     }
698 
699     /**
700      * @dev fallback function ***DO NOT OVERRIDE***
701      * Note that other contracts will transfer fund with a base gas stipend
702      * of 2300, which is not enough to call buyTokens. Consider calling
703      * buyTokens directly when purchasing tokens from a contract.
704      */
705     function () external payable {
706         buyTokens(msg.sender);
707     }
708 
709     /**
710      * @return the token being sold.
711      */
712     function token() public view returns (IERC20) {
713         return _token;
714     }
715 
716     /**
717      * @return the address where funds are collected.
718      */
719     function wallet() public view returns (address payable) {
720         return _wallet;
721     }
722 
723     /**
724      * @return the number of token units a buyer gets per wei.
725      */
726     function rate() public view returns (uint256) {
727         return _rate;
728     }
729 
730     /**
731      * @return the amount of wei raised.
732      */
733     function weiRaised() public view returns (uint256) {
734         return _weiRaised;
735     }
736 
737     /**
738      * @dev low level token purchase ***DO NOT OVERRIDE***
739      * This function has a non-reentrancy guard, so it shouldn't be called by
740      * another `nonReentrant` function.
741      * @param beneficiary Recipient of the token purchase
742      */
743     function buyTokens(address beneficiary) public nonReentrant payable {
744         uint256 weiAmount = msg.value;
745         _preValidatePurchase(beneficiary, weiAmount);
746 
747         // calculate token amount to be created
748         uint256 tokens = _getTokenAmount(weiAmount);
749 
750         // update state
751         _weiRaised = _weiRaised.add(weiAmount);
752 
753         _processPurchase(beneficiary, tokens);
754         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
755 
756         _updatePurchasingState(beneficiary, weiAmount);
757 
758         _forwardFunds();
759         _postValidatePurchase(beneficiary, weiAmount);
760     }
761 
762     /**
763      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
764      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
765      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
766      *     super._preValidatePurchase(beneficiary, weiAmount);
767      *     require(weiRaised().add(weiAmount) <= cap);
768      * @param beneficiary Address performing the token purchase
769      * @param weiAmount Value in wei involved in the purchase
770      */
771     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
772         require(beneficiary != address(0));
773         require(weiAmount != 0);
774     }
775 
776     /**
777      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
778      * conditions are not met.
779      * @param beneficiary Address performing the token purchase
780      * @param weiAmount Value in wei involved in the purchase
781      */
782     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
783         // solhint-disable-previous-line no-empty-blocks
784     }
785 
786     /**
787      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
788      * its tokens.
789      * @param beneficiary Address performing the token purchase
790      * @param tokenAmount Number of tokens to be emitted
791      */
792     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
793         _token.safeTransfer(beneficiary, tokenAmount);
794     }
795 
796     /**
797      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
798      * tokens.
799      * @param beneficiary Address receiving the tokens
800      * @param tokenAmount Number of tokens to be purchased
801      */
802     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
803         _deliverTokens(beneficiary, tokenAmount);
804     }
805 
806     /**
807      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
808      * etc.)
809      * @param beneficiary Address receiving the tokens
810      * @param weiAmount Value in wei involved in the purchase
811      */
812     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
813         // solhint-disable-previous-line no-empty-blocks
814     }
815 
816     /**
817      * @dev Override to extend the way in which ether is converted to tokens.
818      * @param weiAmount Value in wei to be converted into tokens
819      * @return Number of tokens that can be purchased with the specified _weiAmount
820      */
821     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
822         return weiAmount.mul(_rate);
823     }
824 
825     /**
826      * @dev Determines how ETH is stored/forwarded on purchases.
827      */
828     function _forwardFunds() internal {
829         _wallet.transfer(msg.value);
830     }
831 }
832 
833 // File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol
834 
835 /**
836  * @title MintedCrowdsale
837  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
838  * Token ownership should be transferred to MintedCrowdsale for minting.
839  */
840 contract MintedCrowdsale is Crowdsale {
841     /**
842      * @dev Overrides delivery by minting tokens upon purchase.
843      * @param beneficiary Token purchaser
844      * @param tokenAmount Number of tokens to be minted
845      */
846     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
847         // Potentially dangerous assumption about the type of the token.
848         require(ERC20Mintable(address(token())).mint(beneficiary, tokenAmount));
849     }
850 }
851 
852 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
853 
854 /**
855  * @title CappedCrowdsale
856  * @dev Crowdsale with a limit for total contributions.
857  */
858 contract CappedCrowdsale is Crowdsale {
859     using SafeMath for uint256;
860 
861     uint256 private _cap;
862 
863     /**
864      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
865      * @param cap Max amount of wei to be contributed
866      */
867     constructor (uint256 cap) public {
868         require(cap > 0);
869         _cap = cap;
870     }
871 
872     /**
873      * @return the cap of the crowdsale.
874      */
875     function cap() public view returns (uint256) {
876         return _cap;
877     }
878 
879     /**
880      * @dev Checks whether the cap has been reached.
881      * @return Whether the cap was reached
882      */
883     function capReached() public view returns (bool) {
884         return weiRaised() >= _cap;
885     }
886 
887     /**
888      * @dev Extend parent behavior requiring purchase to respect the funding cap.
889      * @param beneficiary Token purchaser
890      * @param weiAmount Amount of wei contributed
891      */
892     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
893         super._preValidatePurchase(beneficiary, weiAmount);
894         require(weiRaised().add(weiAmount) <= _cap);
895     }
896 }
897 
898 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
899 
900 /**
901  * @title TimedCrowdsale
902  * @dev Crowdsale accepting contributions only within a time frame.
903  */
904 contract TimedCrowdsale is Crowdsale {
905     using SafeMath for uint256;
906 
907     uint256 private _openingTime;
908     uint256 private _closingTime;
909 
910     /**
911      * @dev Reverts if not in crowdsale time range.
912      */
913     modifier onlyWhileOpen {
914         require(isOpen());
915         _;
916     }
917 
918     /**
919      * @dev Constructor, takes crowdsale opening and closing times.
920      * @param openingTime Crowdsale opening time
921      * @param closingTime Crowdsale closing time
922      */
923     constructor (uint256 openingTime, uint256 closingTime) public {
924         // solhint-disable-next-line not-rely-on-time
925         require(openingTime >= block.timestamp);
926         require(closingTime > openingTime);
927 
928         _openingTime = openingTime;
929         _closingTime = closingTime;
930     }
931 
932     /**
933      * @return the crowdsale opening time.
934      */
935     function openingTime() public view returns (uint256) {
936         return _openingTime;
937     }
938 
939     /**
940      * @return the crowdsale closing time.
941      */
942     function closingTime() public view returns (uint256) {
943         return _closingTime;
944     }
945 
946     /**
947      * @return true if the crowdsale is open, false otherwise.
948      */
949     function isOpen() public view returns (bool) {
950         // solhint-disable-next-line not-rely-on-time
951         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
952     }
953 
954     /**
955      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
956      * @return Whether crowdsale period has elapsed
957      */
958     function hasClosed() public view returns (bool) {
959         // solhint-disable-next-line not-rely-on-time
960         return block.timestamp > _closingTime;
961     }
962 
963     /**
964      * @dev Extend parent behavior requiring to be within contributing period
965      * @param beneficiary Token purchaser
966      * @param weiAmount Amount of wei contributed
967      */
968     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
969         super._preValidatePurchase(beneficiary, weiAmount);
970     }
971 }
972 
973 // File: openzeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
974 
975 /**
976  * @title FinalizableCrowdsale
977  * @dev Extension of Crowdsale with a one-off finalization action, where one
978  * can do extra work after finishing.
979  */
980 contract FinalizableCrowdsale is TimedCrowdsale {
981     using SafeMath for uint256;
982 
983     bool private _finalized;
984 
985     event CrowdsaleFinalized();
986 
987     constructor () internal {
988         _finalized = false;
989     }
990 
991     /**
992      * @return true if the crowdsale is finalized, false otherwise.
993      */
994     function finalized() public view returns (bool) {
995         return _finalized;
996     }
997 
998     /**
999      * @dev Must be called after crowdsale ends, to do some extra finalization
1000      * work. Calls the contract's finalization function.
1001      */
1002     function finalize() public {
1003         require(!_finalized);
1004         require(hasClosed());
1005 
1006         _finalized = true;
1007 
1008         _finalization();
1009         emit CrowdsaleFinalized();
1010     }
1011 
1012     /**
1013      * @dev Can be overridden to add finalization logic. The overriding function
1014      * should call super._finalization() to ensure the chain of finalization is
1015      * executed entirely.
1016      */
1017     function _finalization() internal {
1018         // solhint-disable-previous-line no-empty-blocks
1019     }
1020 }
1021 
1022 // File: openzeppelin-solidity/contracts/ownership/Secondary.sol
1023 
1024 /**
1025  * @title Secondary
1026  * @dev A Secondary contract can only be used by its primary account (the one that created it)
1027  */
1028 contract Secondary {
1029     address private _primary;
1030 
1031     event PrimaryTransferred(
1032         address recipient
1033     );
1034 
1035     /**
1036      * @dev Sets the primary account to the one that is creating the Secondary contract.
1037      */
1038     constructor () internal {
1039         _primary = msg.sender;
1040         emit PrimaryTransferred(_primary);
1041     }
1042 
1043     /**
1044      * @dev Reverts if called from any account other than the primary.
1045      */
1046     modifier onlyPrimary() {
1047         require(msg.sender == _primary);
1048         _;
1049     }
1050 
1051     /**
1052      * @return the address of the primary.
1053      */
1054     function primary() public view returns (address) {
1055         return _primary;
1056     }
1057 
1058     /**
1059      * @dev Transfers contract to a new primary.
1060      * @param recipient The address of new primary.
1061      */
1062     function transferPrimary(address recipient) public onlyPrimary {
1063         require(recipient != address(0));
1064         _primary = recipient;
1065         emit PrimaryTransferred(_primary);
1066     }
1067 }
1068 
1069 // File: openzeppelin-solidity/contracts/payment/escrow/Escrow.sol
1070 
1071 /**
1072  * @title Escrow
1073  * @dev Base escrow contract, holds funds designated for a payee until they
1074  * withdraw them.
1075  * @dev Intended usage: This contract (and derived escrow contracts) should be a
1076  * standalone contract, that only interacts with the contract that instantiated
1077  * it. That way, it is guaranteed that all Ether will be handled according to
1078  * the Escrow rules, and there is no need to check for payable functions or
1079  * transfers in the inheritance tree. The contract that uses the escrow as its
1080  * payment method should be its primary, and provide public methods redirecting
1081  * to the escrow's deposit and withdraw.
1082  */
1083 contract Escrow is Secondary {
1084     using SafeMath for uint256;
1085 
1086     event Deposited(address indexed payee, uint256 weiAmount);
1087     event Withdrawn(address indexed payee, uint256 weiAmount);
1088 
1089     mapping(address => uint256) private _deposits;
1090 
1091     function depositsOf(address payee) public view returns (uint256) {
1092         return _deposits[payee];
1093     }
1094 
1095     /**
1096     * @dev Stores the sent amount as credit to be withdrawn.
1097     * @param payee The destination address of the funds.
1098     */
1099     function deposit(address payee) public onlyPrimary payable {
1100         uint256 amount = msg.value;
1101         _deposits[payee] = _deposits[payee].add(amount);
1102 
1103         emit Deposited(payee, amount);
1104     }
1105 
1106     /**
1107     * @dev Withdraw accumulated balance for a payee.
1108     * @param payee The address whose funds will be withdrawn and transferred to.
1109     */
1110     function withdraw(address payable payee) public onlyPrimary {
1111         uint256 payment = _deposits[payee];
1112 
1113         _deposits[payee] = 0;
1114 
1115         payee.transfer(payment);
1116 
1117         emit Withdrawn(payee, payment);
1118     }
1119 }
1120 
1121 // File: openzeppelin-solidity/contracts/payment/escrow/ConditionalEscrow.sol
1122 
1123 /**
1124  * @title ConditionalEscrow
1125  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
1126  * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
1127  */
1128 contract ConditionalEscrow is Escrow {
1129     /**
1130     * @dev Returns whether an address is allowed to withdraw their funds. To be
1131     * implemented by derived contracts.
1132     * @param payee The destination address of the funds.
1133     */
1134     function withdrawalAllowed(address payee) public view returns (bool);
1135 
1136     function withdraw(address payable payee) public {
1137         require(withdrawalAllowed(payee));
1138         super.withdraw(payee);
1139     }
1140 }
1141 
1142 // File: openzeppelin-solidity/contracts/payment/escrow/RefundEscrow.sol
1143 
1144 /**
1145  * @title RefundEscrow
1146  * @dev Escrow that holds funds for a beneficiary, deposited from multiple
1147  * parties.
1148  * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
1149  * @dev The primary account (that is, the contract that instantiates this
1150  * contract) may deposit, close the deposit period, and allow for either
1151  * withdrawal by the beneficiary, or refunds to the depositors. All interactions
1152  * with RefundEscrow will be made through the primary contract. See the
1153  * RefundableCrowdsale contract for an example of RefundEscrow’s use.
1154  */
1155 contract RefundEscrow is ConditionalEscrow {
1156     enum State { Active, Refunding, Closed }
1157 
1158     event RefundsClosed();
1159     event RefundsEnabled();
1160 
1161     State private _state;
1162     address payable private _beneficiary;
1163 
1164     /**
1165      * @dev Constructor.
1166      * @param beneficiary The beneficiary of the deposits.
1167      */
1168     constructor (address payable beneficiary) public {
1169         require(beneficiary != address(0));
1170         _beneficiary = beneficiary;
1171         _state = State.Active;
1172     }
1173 
1174     /**
1175      * @return the current state of the escrow.
1176      */
1177     function state() public view returns (State) {
1178         return _state;
1179     }
1180 
1181     /**
1182      * @return the beneficiary of the escrow.
1183      */
1184     function beneficiary() public view returns (address) {
1185         return _beneficiary;
1186     }
1187 
1188     /**
1189      * @dev Stores funds that may later be refunded.
1190      * @param refundee The address funds will be sent to if a refund occurs.
1191      */
1192     function deposit(address refundee) public payable {
1193         require(_state == State.Active);
1194         super.deposit(refundee);
1195     }
1196 
1197     /**
1198      * @dev Allows for the beneficiary to withdraw their funds, rejecting
1199      * further deposits.
1200      */
1201     function close() public onlyPrimary {
1202         require(_state == State.Active);
1203         _state = State.Closed;
1204         emit RefundsClosed();
1205     }
1206 
1207     /**
1208      * @dev Allows for refunds to take place, rejecting further deposits.
1209      */
1210     function enableRefunds() public onlyPrimary {
1211         require(_state == State.Active);
1212         _state = State.Refunding;
1213         emit RefundsEnabled();
1214     }
1215 
1216     /**
1217      * @dev Withdraws the beneficiary's funds.
1218      */
1219     function beneficiaryWithdraw() public {
1220         require(_state == State.Closed);
1221         _beneficiary.transfer(address(this).balance);
1222     }
1223 
1224     /**
1225      * @dev Returns whether refundees can withdraw their deposits (be refunded). The overriden function receives a
1226      * 'payee' argument, but we ignore it here since the condition is global, not per-payee.
1227      */
1228     function withdrawalAllowed(address) public view returns (bool) {
1229         return _state == State.Refunding;
1230     }
1231 }
1232 
1233 // File: openzeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol
1234 
1235 /**
1236  * @title RefundableCrowdsale
1237  * @dev Extension of Crowdsale contract that adds a funding goal, and the possibility of users getting a refund if goal
1238  * is not met.
1239  *
1240  * Deprecated, use RefundablePostDeliveryCrowdsale instead. Note that if you allow tokens to be traded before the goal
1241  * is met, then an attack is possible in which the attacker purchases tokens from the crowdsale and when they sees that
1242  * the goal is unlikely to be met, they sell their tokens (possibly at a discount). The attacker will be refunded when
1243  * the crowdsale is finalized, and the users that purchased from them will be left with worthless tokens.
1244  */
1245 contract RefundableCrowdsale is FinalizableCrowdsale {
1246     using SafeMath for uint256;
1247 
1248     // minimum amount of funds to be raised in weis
1249     uint256 private _goal;
1250 
1251     // refund escrow used to hold funds while crowdsale is running
1252     RefundEscrow private _escrow;
1253 
1254     /**
1255      * @dev Constructor, creates RefundEscrow.
1256      * @param goal Funding goal
1257      */
1258     constructor (uint256 goal) public {
1259         require(goal > 0);
1260         _escrow = new RefundEscrow(wallet());
1261         _goal = goal;
1262     }
1263 
1264     /**
1265      * @return minimum amount of funds to be raised in wei.
1266      */
1267     function goal() public view returns (uint256) {
1268         return _goal;
1269     }
1270 
1271     /**
1272      * @dev Investors can claim refunds here if crowdsale is unsuccessful
1273      * @param refundee Whose refund will be claimed.
1274      */
1275     function claimRefund(address payable refundee) public {
1276         require(finalized());
1277         require(!goalReached());
1278 
1279         _escrow.withdraw(refundee);
1280     }
1281 
1282     /**
1283      * @dev Checks whether funding goal was reached.
1284      * @return Whether funding goal was reached
1285      */
1286     function goalReached() public view returns (bool) {
1287         return weiRaised() >= _goal;
1288     }
1289 
1290     /**
1291      * @dev escrow finalization task, called when finalize() is called
1292      */
1293     function _finalization() internal {
1294         if (goalReached()) {
1295             _escrow.close();
1296             _escrow.beneficiaryWithdraw();
1297         } else {
1298             _escrow.enableRefunds();
1299         }
1300 
1301         super._finalization();
1302     }
1303 
1304     /**
1305      * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
1306      */
1307     function _forwardFunds() internal {
1308         _escrow.deposit.value(msg.value)(msg.sender);
1309     }
1310 }
1311 
1312 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
1313 
1314 /**
1315  * @title Ownable
1316  * @dev The Ownable contract has an owner address, and provides basic authorization control
1317  * functions, this simplifies the implementation of "user permissions".
1318  */
1319 contract Ownable {
1320     address private _owner;
1321 
1322     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1323 
1324     /**
1325      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1326      * account.
1327      */
1328     constructor () internal {
1329         _owner = msg.sender;
1330         emit OwnershipTransferred(address(0), _owner);
1331     }
1332 
1333     /**
1334      * @return the address of the owner.
1335      */
1336     function owner() public view returns (address) {
1337         return _owner;
1338     }
1339 
1340     /**
1341      * @dev Throws if called by any account other than the owner.
1342      */
1343     modifier onlyOwner() {
1344         require(isOwner());
1345         _;
1346     }
1347 
1348     /**
1349      * @return true if `msg.sender` is the owner of the contract.
1350      */
1351     function isOwner() public view returns (bool) {
1352         return msg.sender == _owner;
1353     }
1354 
1355     /**
1356      * @dev Allows the current owner to relinquish control of the contract.
1357      * @notice Renouncing to ownership will leave the contract without an owner.
1358      * It will not be possible to call the functions with the `onlyOwner`
1359      * modifier anymore.
1360      */
1361     function renounceOwnership() public onlyOwner {
1362         emit OwnershipTransferred(_owner, address(0));
1363         _owner = address(0);
1364     }
1365 
1366     /**
1367      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1368      * @param newOwner The address to transfer ownership to.
1369      */
1370     function transferOwnership(address newOwner) public onlyOwner {
1371         _transferOwnership(newOwner);
1372     }
1373 
1374     /**
1375      * @dev Transfers control of the contract to a newOwner.
1376      * @param newOwner The address to transfer ownership to.
1377      */
1378     function _transferOwnership(address newOwner) internal {
1379         require(newOwner != address(0));
1380         emit OwnershipTransferred(_owner, newOwner);
1381         _owner = newOwner;
1382     }
1383 }
1384 
1385 // File: openzeppelin-solidity/contracts/drafts/TokenVesting.sol
1386 
1387 /**
1388  * @title TokenVesting
1389  * @dev A token holder contract that can release its token balance gradually like a
1390  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
1391  * owner.
1392  */
1393 contract TokenVesting is Ownable {
1394     // The vesting schedule is time-based (i.e. using block timestamps as opposed to e.g. block numbers), and is
1395     // therefore sensitive to timestamp manipulation (which is something miners can do, to a certain degree). Therefore,
1396     // it is recommended to avoid using short time durations (less than a minute). Typical vesting schemes, with a cliff
1397     // period of a year and a duration of four years, are safe to use.
1398     // solhint-disable not-rely-on-time
1399 
1400     using SafeMath for uint256;
1401     using SafeERC20 for IERC20;
1402 
1403     event TokensReleased(address token, uint256 amount);
1404     event TokenVestingRevoked(address token);
1405 
1406     // beneficiary of tokens after they are released
1407     address private _beneficiary;
1408 
1409     // Durations and timestamps are expressed in UNIX time, the same units as block.timestamp.
1410     uint256 private _cliff;
1411     uint256 private _start;
1412     uint256 private _duration;
1413 
1414     bool private _revocable;
1415 
1416     mapping (address => uint256) private _released;
1417     mapping (address => bool) private _revoked;
1418 
1419     /**
1420      * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
1421      * beneficiary, gradually in a linear fashion until start + duration. By then all
1422      * of the balance will have vested.
1423      * @param beneficiary address of the beneficiary to whom vested tokens are transferred
1424      * @param cliffDuration duration in seconds of the cliff in which tokens will begin to vest
1425      * @param start the time (as Unix time) at which point vesting starts
1426      * @param duration duration in seconds of the period in which the tokens will vest
1427      * @param revocable whether the vesting is revocable or not
1428      */
1429     constructor (address beneficiary, uint256 start, uint256 cliffDuration, uint256 duration, bool revocable) public {
1430         require(beneficiary != address(0));
1431         require(cliffDuration <= duration);
1432         require(duration > 0);
1433         require(start.add(duration) > block.timestamp);
1434 
1435         _beneficiary = beneficiary;
1436         _revocable = revocable;
1437         _duration = duration;
1438         _cliff = start.add(cliffDuration);
1439         _start = start;
1440     }
1441 
1442     /**
1443      * @return the beneficiary of the tokens.
1444      */
1445     function beneficiary() public view returns (address) {
1446         return _beneficiary;
1447     }
1448 
1449     /**
1450      * @return the cliff time of the token vesting.
1451      */
1452     function cliff() public view returns (uint256) {
1453         return _cliff;
1454     }
1455 
1456     /**
1457      * @return the start time of the token vesting.
1458      */
1459     function start() public view returns (uint256) {
1460         return _start;
1461     }
1462 
1463     /**
1464      * @return the duration of the token vesting.
1465      */
1466     function duration() public view returns (uint256) {
1467         return _duration;
1468     }
1469 
1470     /**
1471      * @return true if the vesting is revocable.
1472      */
1473     function revocable() public view returns (bool) {
1474         return _revocable;
1475     }
1476 
1477     /**
1478      * @return the amount of the token released.
1479      */
1480     function released(address token) public view returns (uint256) {
1481         return _released[token];
1482     }
1483 
1484     /**
1485      * @return true if the token is revoked.
1486      */
1487     function revoked(address token) public view returns (bool) {
1488         return _revoked[token];
1489     }
1490 
1491     /**
1492      * @notice Transfers vested tokens to beneficiary.
1493      * @param token ERC20 token which is being vested
1494      */
1495     function release(IERC20 token) public {
1496         uint256 unreleased = _releasableAmount(token);
1497 
1498         require(unreleased > 0);
1499 
1500         _released[address(token)] = _released[address(token)].add(unreleased);
1501 
1502         token.safeTransfer(_beneficiary, unreleased);
1503 
1504         emit TokensReleased(address(token), unreleased);
1505     }
1506 
1507     /**
1508      * @notice Allows the owner to revoke the vesting. Tokens already vested
1509      * remain in the contract, the rest are returned to the owner.
1510      * @param token ERC20 token which is being vested
1511      */
1512     function revoke(IERC20 token) public onlyOwner {
1513         require(_revocable);
1514         require(!_revoked[address(token)]);
1515 
1516         uint256 balance = token.balanceOf(address(this));
1517 
1518         uint256 unreleased = _releasableAmount(token);
1519         uint256 refund = balance.sub(unreleased);
1520 
1521         _revoked[address(token)] = true;
1522 
1523         token.safeTransfer(owner(), refund);
1524 
1525         emit TokenVestingRevoked(address(token));
1526     }
1527 
1528     /**
1529      * @dev Calculates the amount that has already vested but hasn't been released yet.
1530      * @param token ERC20 token which is being vested
1531      */
1532     function _releasableAmount(IERC20 token) private view returns (uint256) {
1533         return _vestedAmount(token).sub(_released[address(token)]);
1534     }
1535 
1536     /**
1537      * @dev Calculates the amount that has already vested.
1538      * @param token ERC20 token which is being vested
1539      */
1540     function _vestedAmount(IERC20 token) private view returns (uint256) {
1541         uint256 currentBalance = token.balanceOf(address(this));
1542         uint256 totalBalance = currentBalance.add(_released[address(token)]);
1543 
1544         if (block.timestamp < _cliff) {
1545             return 0;
1546         } else if (block.timestamp >= _start.add(_duration) || _revoked[address(token)]) {
1547             return totalBalance;
1548         } else {
1549             return totalBalance.mul(block.timestamp.sub(_start)).div(_duration);
1550         }
1551     }
1552 }
1553 
1554 // File: contracts/WiseCrowdsale.sol
1555 
1556 contract WiseTokenCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundableCrowdsale, Ownable {
1557     ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1558     ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1559     ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1560     //////////////   company  WISE                                                                        //////////////
1561     //////////////   website  WISE.CR                                                                     //////////////
1562     //////////////   token    WISE                                                                        //////////////
1563     //////////////   token symbol   WSE                                                                   //////////////
1564     //////////////   developer jamesjara                                                                  //////////////
1565     //////////////                     WSE             USD         TR-USD  TOKEN-RATE        STRATEGY     //////////////
1566     //////////////   ETH PRICE: $150                                                                      //////////////
1567     //////////////   TOTAL SUPPLY: 100 000 000       100 000 0000                                         //////////////
1568     //////////////   AIR-DROPED     5 000 000 (5%)                 $10                       MINTED       //////////////
1569     //////////////   ADVISORS       4 000 000 (4%)                 $10                       MINTED       //////////////
1570     //////////////   TEAM           7 000 000 (7%)                 $10                       MINTED       //////////////
1571     //////////////   BUSINESS      30 000 000 (30%)                $10                       MINTED       //////////////
1572     //////////////   RESERVER      20 000 000 (20%)                $10                       MINTED       //////////////
1573     //////////////   PRIVATE       20 000 000 (20%)  60 000 000    $3       50               MANUAL/BUY   //////////////
1574     //////////////   PRE           10 000 000 (10%)  50 000 000    $5       20               MANUAL/BUY   //////////////
1575     //////////////   PUBLIC         5 000 000 (5%)   40 000 000    $8       19               BUY          //////////////
1576     ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1577     ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1578     ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
1579 
1580     // Events
1581     event EthTransferred(string text);
1582     event RateChanged(uint256 rate);
1583     event StageChanged(uint256 stage);
1584     event TokensQuantityChanged(uint256 stage, uint256 _tokens);
1585     event MintTokens(address _beneficiary, uint256 _tokens);
1586     event MintFullTeamDone();
1587 
1588     // Crowdsale
1589     enum CrowdsaleStage { PrivateICO, PreICO, ICO }
1590     CrowdsaleStage public stage = CrowdsaleStage.PrivateICO;
1591     uint256 private _wserate;
1592 
1593     // Token Distribution
1594     uint256 public totalTokens                = 100000000;
1595     uint256 public crowdsaleFundDistribution  = 35;
1596     uint256 public airdroppedFundDistribution = 5;
1597     uint256 public advisorsFundDistribution   = 3;
1598     uint256 public teamFundDistribution       = 7;
1599     uint256 public bussinesFundDistribution   = 30;
1600     uint256 public reserveFundDistribution    = 20;
1601     uint256 public privateFundDistribution    = 20;
1602     uint256 public preFundDistribution        = 10;
1603     uint256 public publicFundDistribution     = 5;
1604 
1605     // Token funds
1606     address public crowdsaleFund;
1607     address public airdroppedFund;
1608     address public advisorsFund;
1609     address public teamFund;
1610     address public bussinesFund;
1611     address public reserveFund;
1612 
1613     // Tracking tokens
1614     uint256 public totalPrivateTokens = 0;
1615     uint256 public totalPreTokens     = 0;
1616     uint256 public totalPublicTokens  = 0;
1617 
1618     // Vesting
1619     uint256 public constant VESTING_CLIFF = 365 days;
1620     uint256 public constant VESTING_DURATION = 1460 days;
1621 
1622     constructor(
1623       uint256 _rate,
1624       address payable _wallet,
1625       ERC20Mintable _token,
1626       uint256 _cap,
1627       uint256 _goal,
1628       address[] memory _fundAddresses,
1629       uint256 _openingTime,
1630       uint256 _closingTime
1631     )
1632       Crowdsale(_rate, _wallet, _token)
1633       CappedCrowdsale(_cap)
1634       TimedCrowdsale(_openingTime, _closingTime)
1635       RefundableCrowdsale(_goal)
1636       public
1637     {
1638         require(_goal <= _cap, "goal must be equal or less than cap");
1639         _wserate = _rate;
1640         airdroppedFund = _fundAddresses[0];
1641         advisorsFund = _fundAddresses[1];
1642         teamFund = _fundAddresses[2];
1643         bussinesFund = _fundAddresses[3];
1644         reserveFund = _fundAddresses[4];
1645     }
1646 
1647     /**
1648       * @dev Change the current rate
1649       * @param _rate rate
1650       * @param _multiplier multiplier of the reate
1651     */
1652     function setCurrentRate(uint256 _rate, uint256 _multiplier) public onlyOwner {
1653         // ETH-PRICE / TOKEN-USD-PRICE
1654         _wserate = _rate.mul(10**_multiplier);
1655         emit RateChanged(_wserate);
1656     }
1657 
1658     /**
1659     * @dev Allows admin to update the crowdsale stage
1660     * @param _stage Crowdsale stage
1661     */
1662     function setCrowdsaleStage(uint _stage) public onlyOwner {
1663         if(uint(CrowdsaleStage.PrivateICO) == _stage) {
1664             stage = CrowdsaleStage.PrivateICO;
1665         } else if (uint(CrowdsaleStage.PreICO) == _stage) {
1666             stage = CrowdsaleStage.PreICO;
1667         } else if (uint(CrowdsaleStage.ICO) == _stage) {
1668             stage = CrowdsaleStage.ICO;
1669         }
1670         emit StageChanged(uint(stage));
1671     }
1672 
1673     /**
1674       * @dev Update current tokens total stack by stage
1675       * @param _tokens new tokens
1676       */
1677     function updateTokensQuantity(uint256 _tokens) internal {
1678         if(stage == CrowdsaleStage.PrivateICO) {
1679             totalPrivateTokens = totalPrivateTokens.add(_tokens);
1680         } else if (stage == CrowdsaleStage.PreICO) {
1681             totalPreTokens = totalPreTokens.add(_tokens);
1682         } else if (stage == CrowdsaleStage.ICO) {
1683             totalPublicTokens = totalPublicTokens.add(_tokens);
1684         }
1685         emit TokensQuantityChanged(uint(stage), _tokens);
1686     }
1687 
1688     /**
1689       * @dev Update current tokens total stack by stage for mantaince
1690       * @param _stage stage
1691       * @param _tokens new tokens state
1692       */
1693     function updateTokensQuantityAdmin(uint _stage, uint256 _tokens) public onlyOwner  {
1694         if(_stage == uint(CrowdsaleStage.PrivateICO)) {
1695             totalPrivateTokens = _tokens;
1696         } else if (_stage == uint(CrowdsaleStage.PreICO)) {
1697             totalPreTokens = _tokens;
1698         } else if (_stage == uint(CrowdsaleStage.ICO)) {
1699             totalPublicTokens = _tokens;
1700         }
1701         emit TokensQuantityChanged(_stage, _tokens);
1702     }
1703 
1704     /**
1705       * @dev Returns the rate of tokens per wei at the present time.
1706       * @return The number of tokens a buyer gets per wei at a given time
1707       */
1708     function getCurrentRate() public view returns (uint256) {
1709         return _wserate;
1710     }
1711 
1712     /**
1713       * The base rate function is overridden to revert, since this crowdsale doens't use it, and
1714       * all calls to it are a mistake.
1715       */
1716     function rate() public view returns (uint256) {
1717         return getCurrentRate();
1718     }
1719 
1720     /**
1721     * @dev Extend parent behavior verifing the limits of each stage
1722     * @param _beneficiary Token purchaser
1723     * @param _weiAmount Amount of wei contributed
1724     */
1725     function _preValidatePurchase( address payable _beneficiary, uint256 _weiAmount ) internal {
1726         super._preValidatePurchase(_beneficiary, _weiAmount);
1727         require(_validateTokenLimits(_getTokenAmount(_weiAmount)),"max tokens reached");
1728     }
1729 
1730     /**
1731       * @dev validates the tokens limit of Private and Public stages
1732       * @param tokens new tokens
1733       * @return if it is posible to continue or has reached the limits
1734       */
1735     function _validateTokenLimits(uint256 tokens) internal view returns (bool) {
1736         if(stage == CrowdsaleStage.PrivateICO) {
1737             require(totalPrivateTokens.add(tokens) <= privateFundDistribution.mul(10**6),"max tokens reached 0");
1738         } else if (stage == CrowdsaleStage.PreICO) {
1739             require(totalPreTokens.add(tokens) <= preFundDistribution.mul(10**6),"max tokens reached 1");
1740         } 
1741         // else if (stage == CrowdsaleStage.ICO) {
1742         // Public ICO doesn't have any tokens limits,
1743         // however will be limited by the cap contract;
1744         // and the cap will be on ETH rather than tokens.
1745         // }
1746         return true;
1747     }
1748 
1749 
1750     /**
1751       * @dev Calculate tokens amount.
1752       * @param rateP rate of token
1753       * @param rateMultiplierP rate multiplier
1754       * @param weiAmountP wei 
1755       * @param weiAmountMultiplierP wei multiplier
1756       * @return The number of tokens _weiAmount wei will buy at present time
1757       */
1758     function calculateTokens(uint256 rateP, uint256 rateMultiplierP, uint weiAmountP, uint weiAmountMultiplierP) public view returns (uint256) {
1759         uint256 currentRate = getCurrentRate();
1760         uint256 rateLocal = rateP;
1761         uint256 rateMultiplier = rateMultiplierP;
1762         uint256 weiAmount = weiAmountP;
1763         uint256 weiAmountMultiplier = weiAmountMultiplierP;
1764         if(rateLocal == 0){
1765             rateLocal = currentRate;
1766         }
1767         if(rateMultiplier != 0){
1768             rateLocal = rateLocal.mul(10**rateMultiplier);
1769         }
1770         if(weiAmountMultiplier != 0){
1771             weiAmount = weiAmount.mul(10**weiAmountMultiplier);
1772         }
1773         return weiAmount.div(rateLocal);
1774     }
1775 
1776     /**
1777       * @dev Overrides parent method taking into account variable rate.
1778       * @param weiAmount The value in wei to be converted into tokens
1779       * @return The number of tokens _weiAmount wei will buy at present time
1780       */
1781     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
1782         uint256 currentRate = getCurrentRate();
1783         uint256 count = weiAmount.div(currentRate);
1784         return count * 1 ether;
1785     }
1786 
1787     /**
1788       * @dev Utility method to convert wei to tokens
1789       * @param weiAmount Value in wei to be converted into tokens
1790       * @return Number of tokens that can be purchased with the specified _weiAmount
1791       */
1792     function _getTokenAmountSimple(uint256 weiAmount) internal view returns (uint256) {
1793         return _getTokenAmount(weiAmount);
1794     }
1795 
1796     /**
1797       * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
1798       * @param beneficiary Address receiving the tokens
1799       * @param weiAmount Value in wei involved in the purchase
1800     */
1801     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
1802         updateTokensQuantity(_getTokenAmount(weiAmount).div(10**18));
1803     }
1804 
1805     /**
1806       * @dev forwards funds to the wallet during the PrivateICO/PreICO stage,
1807       * then the refund vault during ICO stage using the RefundablePostDeliveryCrowdsale
1808     */
1809     function _forwardFunds() internal {
1810         if(stage == CrowdsaleStage.PrivateICO) {
1811             address(wallet()).transfer(msg.value);
1812             emit EthTransferred("forwarding funds to wallet PrivateICO");
1813         } else if (stage == CrowdsaleStage.PreICO) {
1814             address(wallet()).transfer(msg.value);
1815             emit EthTransferred("forwarding funds to wallet PreICO");
1816         } else if (stage == CrowdsaleStage.ICO) {
1817             emit EthTransferred("forwarding funds to refundable vault");
1818             super._forwardFunds();
1819         }
1820     }
1821 
1822     /**
1823       * @dev Allocates tokens for investors that contributed. These include
1824       * whitelisted investors and investors paying with usd
1825       * mode mint/manual
1826       * @param _beneficiary Token purchaser
1827       * @param _tokens Number of tokens
1828     */
1829     function mintTokensInvestors(address _beneficiary, uint256 _tokens) public onlyOwner  {
1830         uint tokensInWei = _tokens.mul(10**18);
1831         require(_beneficiary != address(0), "beneficiary cant be address 0");
1832         require(_tokens > 0, "invalid # of tokens");
1833         require(_validateTokenLimits(_tokens), "max tokens reached");
1834         require(ERC20Mintable(address(token())).mint(_beneficiary, tokensInWei), "mint error");
1835         updateTokensQuantity(_tokens);
1836         emit MintTokens(_beneficiary, _tokens);
1837     }
1838 
1839     /**
1840       * @dev Allocates tokens for each group
1841       * Requires mintin role
1842       * mode: mint/manual
1843     */
1844     function mintFullTeam() public onlyOwner {
1845         if(goalReached()) {
1846             ERC20Mintable _mintableToken = ERC20Mintable(address(token()));
1847             TokenVesting airdroppedFundVested = new TokenVesting(airdroppedFund, 1549737919, VESTING_CLIFF, VESTING_DURATION, false);
1848             TokenVesting advisorsFundVested = new TokenVesting(advisorsFund, 1549737919, VESTING_CLIFF, VESTING_DURATION, false);
1849             TokenVesting teamFundVested = new TokenVesting(teamFund, 1549737919, VESTING_CLIFF, VESTING_DURATION, false);
1850             TokenVesting bussinesFundVested = new TokenVesting(bussinesFund, 1549737919, VESTING_CLIFF, VESTING_DURATION, false);
1851             TokenVesting reserveFundVested = new TokenVesting(reserveFund, 1549737919, VESTING_CLIFF, VESTING_DURATION, false);
1852             _mintableToken.mint(address(airdroppedFundVested), airdroppedFundDistribution * (10**6) * 10**18);
1853             _mintableToken.mint(address(advisorsFundVested), advisorsFundDistribution * (10**6) * 10**18);
1854             _mintableToken.mint(address(teamFundVested), teamFundDistribution * (10**6) * 10**18);
1855             _mintableToken.mint(address(bussinesFundVested), bussinesFundDistribution * (10**6) * 10**18);
1856             _mintableToken.mint(address(reserveFundVested), reserveFundDistribution * (10**6) * 10**18);
1857             emit MintFullTeamDone();
1858         }
1859     }
1860 
1861     /**
1862       * @dev called when owner calls finalize(), calls mintFullTeam()
1863       * Requires mintin role
1864     */
1865     function _finalization() internal {
1866         if(goalReached()) {
1867             mintFullTeam();
1868         }
1869         super._finalization();
1870     }
1871 }
1872 
1873 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
1874 
1875 /**
1876  * @title ERC20Detailed token
1877  * @dev The decimals are only for visualization purposes.
1878  * All the operations are done using the smallest and indivisible token unit,
1879  * just as on Ethereum all the operations are done in wei.
1880  */
1881 contract ERC20Detailed is IERC20 {
1882     string private _name;
1883     string private _symbol;
1884     uint8 private _decimals;
1885 
1886     constructor (string memory name, string memory symbol, uint8 decimals) public {
1887         _name = name;
1888         _symbol = symbol;
1889         _decimals = decimals;
1890     }
1891 
1892     /**
1893      * @return the name of the token.
1894      */
1895     function name() public view returns (string memory) {
1896         return _name;
1897     }
1898 
1899     /**
1900      * @return the symbol of the token.
1901      */
1902     function symbol() public view returns (string memory) {
1903         return _symbol;
1904     }
1905 
1906     /**
1907      * @return the number of decimals of the token.
1908      */
1909     function decimals() public view returns (uint8) {
1910         return _decimals;
1911     }
1912 }
1913 
1914 // File: contracts/WiseToken.sol
1915 
1916 contract WiseToken is  ERC20, ERC20Detailed, ERC20Mintable, ERC20Pausable, Ownable{
1917     constructor () public ERC20Detailed("WISE TOKEN", "WSE", 18) {
1918     }
1919 }
1920 
1921 // File: contracts/Migrations.sol
1922 
1923 contract Migrations {
1924     address public owner;
1925     uint public last_completed_migration;
1926 
1927     constructor() public {
1928         owner = msg.sender;
1929     }
1930 
1931     modifier restricted() {
1932         if (msg.sender == owner) _;
1933     }
1934 
1935     function setCompleted(uint completed) public restricted {
1936         last_completed_migration = completed;
1937     }
1938 
1939     function upgrade(address new_address) public restricted {
1940         Migrations upgraded = Migrations(new_address);
1941         upgraded.setCompleted(last_completed_migration);
1942     }
1943 }