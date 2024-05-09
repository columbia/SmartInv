1 pragma solidity ^0.5.8;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
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
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
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
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://eips.ethereum.org/EIPS/eip-20
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
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * https://eips.ethereum.org/EIPS/eip-20
94  * Originally based on code by FirstBlood:
95  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
96  *
97  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
98  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
99  * compliant implementations may not do it.
100  */
101 contract ERC20 is IERC20 {
102     using SafeMath for uint256;
103 
104     mapping (address => uint256) private _balances;
105 
106     mapping (address => mapping (address => uint256)) private _allowed;
107 
108     uint256 private _totalSupply;
109 
110     /**
111      * @dev Total number of tokens in existence
112      */
113     function totalSupply() public view returns (uint256) {
114         return _totalSupply;
115     }
116 
117     /**
118      * @dev Gets the balance of the specified address.
119      * @param owner The address to query the balance of.
120      * @return A uint256 representing the amount owned by the passed address.
121      */
122     function balanceOf(address owner) public view returns (uint256) {
123         return _balances[owner];
124     }
125 
126     /**
127      * @dev Function to check the amount of tokens that an owner allowed to a spender.
128      * @param owner address The address which owns the funds.
129      * @param spender address The address which will spend the funds.
130      * @return A uint256 specifying the amount of tokens still available for the spender.
131      */
132     function allowance(address owner, address spender) public view returns (uint256) {
133         return _allowed[owner][spender];
134     }
135 
136     /**
137      * @dev Transfer token to a specified address
138      * @param to The address to transfer to.
139      * @param value The amount to be transferred.
140      */
141     function transfer(address to, uint256 value) public returns (bool) {
142         _transfer(msg.sender, to, value);
143         return true;
144     }
145 
146     /**
147      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148      * Beware that changing an allowance with this method brings the risk that someone may use both the old
149      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
150      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
151      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152      * @param spender The address which will spend the funds.
153      * @param value The amount of tokens to be spent.
154      */
155     function approve(address spender, uint256 value) public returns (bool) {
156         _approve(msg.sender, spender, value);
157         return true;
158     }
159 
160     /**
161      * @dev Transfer tokens from one address to another.
162      * Note that while this function emits an Approval event, this is not required as per the specification,
163      * and other compliant implementations may not emit the event.
164      * @param from address The address which you want to send tokens from
165      * @param to address The address which you want to transfer to
166      * @param value uint256 the amount of tokens to be transferred
167      */
168     function transferFrom(address from, address to, uint256 value) public returns (bool) {
169         _transfer(from, to, value);
170         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
171         return true;
172     }
173 
174     /**
175      * @dev Increase the amount of tokens that an owner allowed to a spender.
176      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
177      * allowed value is better to use this function to avoid 2 calls (and wait until
178      * the first transaction is mined)
179      * From MonolithDAO Token.sol
180      * Emits an Approval event.
181      * @param spender The address which will spend the funds.
182      * @param addedValue The amount of tokens to increase the allowance by.
183      */
184     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
185         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
186         return true;
187     }
188 
189     /**
190      * @dev Decrease the amount of tokens that an owner allowed to a spender.
191      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
192      * allowed value is better to use this function to avoid 2 calls (and wait until
193      * the first transaction is mined)
194      * From MonolithDAO Token.sol
195      * Emits an Approval event.
196      * @param spender The address which will spend the funds.
197      * @param subtractedValue The amount of tokens to decrease the allowance by.
198      */
199     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
200         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
201         return true;
202     }
203 
204     /**
205      * @dev Transfer token for a specified addresses
206      * @param from The address to transfer from.
207      * @param to The address to transfer to.
208      * @param value The amount to be transferred.
209      */
210     function _transfer(address from, address to, uint256 value) internal {
211         require(to != address(0));
212 
213         _balances[from] = _balances[from].sub(value);
214         _balances[to] = _balances[to].add(value);
215         emit Transfer(from, to, value);
216     }
217 
218     /**
219      * @dev Internal function that mints an amount of the token and assigns it to
220      * an account. This encapsulates the modification of balances such that the
221      * proper events are emitted.
222      * @param account The account that will receive the created tokens.
223      * @param value The amount that will be created.
224      */
225     function _mint(address account, uint256 value) internal {
226         require(account != address(0));
227 
228         _totalSupply = _totalSupply.add(value);
229         _balances[account] = _balances[account].add(value);
230         emit Transfer(address(0), account, value);
231     }
232 
233     /**
234      * @dev Internal function that burns an amount of the token of a given
235      * account.
236      * @param account The account whose tokens will be burnt.
237      * @param value The amount that will be burnt.
238      */
239     function _burn(address account, uint256 value) internal {
240         require(account != address(0));
241 
242         _totalSupply = _totalSupply.sub(value);
243         _balances[account] = _balances[account].sub(value);
244         emit Transfer(account, address(0), value);
245     }
246 
247     /**
248      * @dev Approve an address to spend another addresses' tokens.
249      * @param owner The address that owns the tokens.
250      * @param spender The address that will spend the tokens.
251      * @param value The number of tokens that can be spent.
252      */
253     function _approve(address owner, address spender, uint256 value) internal {
254         require(spender != address(0));
255         require(owner != address(0));
256 
257         _allowed[owner][spender] = value;
258         emit Approval(owner, spender, value);
259     }
260 
261     /**
262      * @dev Internal function that burns an amount of the token of a given
263      * account, deducting from the sender's allowance for said account. Uses the
264      * internal burn function.
265      * Emits an Approval event (reflecting the reduced allowance).
266      * @param account The account whose tokens will be burnt.
267      * @param value The amount that will be burnt.
268      */
269     function _burnFrom(address account, uint256 value) internal {
270         _burn(account, value);
271         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
272     }
273 }
274 
275 /**
276  * @title Claimable
277  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
278  * This allows the new owner to accept the transfer.
279  */
280 contract Claimable {
281     address private _pendingOwner;
282     address private _owner;
283 
284     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
285 
286     /**
287      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
288      * account.
289      */
290     constructor () internal {
291         _owner = msg.sender;
292         emit OwnershipTransferred(address(0), _owner);
293     }
294 
295     /**
296      * @return the address of the owner.
297      */
298     function owner() public view returns (address) {
299         return _owner;
300     }
301 
302     /**
303      * @dev Throws if called by any account other than the owner.
304      */
305     modifier onlyOwner() {
306         require(isOwner());
307         _;
308     }
309 
310     /**
311     * @dev Modifier throws if called by any account other than the pendingOwner.
312     */
313     modifier onlyPendingOwner() {
314       require(msg.sender == _pendingOwner);
315       _;
316     }
317 
318     /**
319      * @return true if `msg.sender` is the owner of the contract.
320      */
321     function isOwner() public view returns (bool) {
322         return msg.sender == _owner;
323     }
324 
325     /**
326      * @dev Allows the current owner to relinquish control of the contract.
327      * It will not be possible to call the functions with the `onlyOwner`
328      * modifier anymore.
329      * @notice Renouncing ownership will leave the contract without an owner,
330      * thereby removing any functionality that is only available to the owner.
331      */
332     function renounceOwnership() public onlyOwner {
333         emit OwnershipTransferred(_owner, address(0));
334         _owner = address(0);
335     }
336 
337     /**
338     * @dev Allows the current owner to set the pendingOwner address.
339     * @param newOwner The address to transfer ownership to.
340     */
341     function transferOwnership(address newOwner) onlyOwner public {
342       _pendingOwner = newOwner;
343     }
344 
345     /**
346     * @dev Allows the pendingOwner address to finalize the transfer.
347     */
348     function claimOwnership() onlyPendingOwner public {
349       emit OwnershipTransferred(_owner, _pendingOwner);
350       _owner = _pendingOwner;
351       _pendingOwner = address(0);
352     }
353 }
354 
355 /**
356  * @title Math
357  * @dev Assorted math operations
358  */
359 library Math {
360     /**
361      * @dev Returns the largest of two numbers.
362      */
363     function max(uint256 a, uint256 b) internal pure returns (uint256) {
364         return a >= b ? a : b;
365     }
366 
367     /**
368      * @dev Returns the smallest of two numbers.
369      */
370     function min(uint256 a, uint256 b) internal pure returns (uint256) {
371         return a < b ? a : b;
372     }
373 
374     /**
375      * @dev Calculates the average of two numbers. Since these are integers,
376      * averages of an even and odd number cannot be represented, and will be
377      * rounded down.
378      */
379     function average(uint256 a, uint256 b) internal pure returns (uint256) {
380         // (a + b) / 2 can overflow, so we distribute
381         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
382     }
383 }
384 
385 /**
386  * Utility library of inline functions on addresses
387  */
388 library Address {
389     /**
390      * Returns whether the target address is a contract
391      * @dev This function will return false if invoked during the constructor of a contract,
392      * as the code is not actually created until after the constructor finishes.
393      * @param account address of the account to check
394      * @return whether the target address is a contract
395      */
396     function isContract(address account) internal view returns (bool) {
397         uint256 size;
398         // XXX Currently there is no better way to check if there is a contract in an address
399         // than to check the size of the code at that address.
400         // See https://ethereum.stackexchange.com/a/14016/36603
401         // for more details about how this works.
402         // TODO Check this again before the Serenity release, because all addresses will be
403         // contracts then.
404         // solhint-disable-next-line no-inline-assembly
405         assembly { size := extcodesize(account) }
406         return size > 0;
407     }
408 }
409 
410 /// @notice Implements safeTransfer, safeTransferFrom and
411 /// safeApprove for CompatibleERC20.
412 ///
413 /// See https://github.com/ethereum/solidity/issues/4116
414 ///
415 /// This library allows interacting with ERC20 tokens that implement any of
416 /// these interfaces:
417 ///
418 /// (1) transfer returns true on success, false on failure
419 /// (2) transfer returns true on success, reverts on failure
420 /// (3) transfer returns nothing on success, reverts on failure
421 ///
422 /// Additionally, safeTransferFromWithFees will return the final token
423 /// value received after accounting for token fees.
424 
425 library CompatibleERC20Functions {
426     using SafeMath for uint256;
427     using Address for address;
428 
429     function safeTransfer(IERC20 token, address to, uint256 value) internal {
430         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
431     }
432 
433     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
434         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
435     }
436 
437     /// @notice Calls transferFrom on the token, reverts if the call fails and
438     /// returns the value transferred after fees.
439     function safeTransferFromWithFees(IERC20 token, address from, address to, uint256 value) internal returns (uint256) {
440         uint256 balancesBefore = token.balanceOf(to);
441         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
442         require(previousReturnValue(), "transferFrom failed");
443         uint256 balancesAfter = token.balanceOf(to);
444         return Math.min(value, balancesAfter.sub(balancesBefore));
445     }
446 
447     function safeApprove(IERC20 token, address spender, uint256 value) internal {
448         // safeApprove should only be called when setting an initial allowance,
449         // or when resetting it to zero. To increase and decrease it, use
450         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
451         require((value == 0) || (token.allowance(address(this), spender) == 0));
452         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
453     }
454 
455     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
456         uint256 newAllowance = token.allowance(address(this), spender).add(value);
457         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
458     }
459 
460     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
461         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
462         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
463     }
464 
465     /**
466      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
467      * on the return value: the return value is optional (but if data is returned, it must equal true).
468      * @param token The token targeted by the call.
469      * @param data The call data (encoded using abi.encode or one of its variants).
470      */
471     function callOptionalReturn(IERC20 token, bytes memory data) private {
472         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
473         // we're implementing it ourselves.
474 
475         // A Solidity high level call has three parts:
476         //  1. The target address is checked to verify it contains contract code
477         //  2. The call itself is made, and success asserted
478         //  3. The return value is decoded, which in turn checks the size of the returned data.
479 
480         require(address(token).isContract());
481 
482         // solhint-disable-next-line avoid-low-level-calls
483         (bool success, bytes memory returndata) = address(token).call(data);
484         require(success);
485 
486         if (returndata.length > 0) { // Return data is optional
487             require(abi.decode(returndata, (bool)));
488         }
489     }
490 
491     /// @notice Checks the return value of the previous function. Returns true
492     /// if the previous function returned 32 non-zero bytes or returned zero
493     /// bytes.
494     function previousReturnValue() private pure returns (bool)
495     {
496         uint256 returnData = 0;
497 
498         assembly { /* solium-disable-line security/no-inline-assembly */
499             // Switch on the number of bytes returned by the previous call
500             switch returndatasize
501 
502             // 0 bytes: ERC20 of type (3), did not throw
503             case 0 {
504                 returnData := 1
505             }
506 
507             // 32 bytes: ERC20 of types (1) or (2)
508             case 32 {
509                 // Copy the return data into scratch space
510                 returndatacopy(0, 0, 32)
511 
512                 // Load  the return data into returnData
513                 returnData := mload(0)
514             }
515 
516             // Other return size: return false
517             default { }
518         }
519 
520         return returnData != 0;
521     }
522 }
523 
524 /**
525  * @title Ownable
526  * @dev The Ownable contract has an owner address, and provides basic authorization control
527  * functions, this simplifies the implementation of "user permissions".
528  */
529 contract Ownable {
530     address private _owner;
531 
532     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
533 
534     /**
535      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
536      * account.
537      */
538     constructor () internal {
539         _owner = msg.sender;
540         emit OwnershipTransferred(address(0), _owner);
541     }
542 
543     /**
544      * @return the address of the owner.
545      */
546     function owner() public view returns (address) {
547         return _owner;
548     }
549 
550     /**
551      * @dev Throws if called by any account other than the owner.
552      */
553     modifier onlyOwner() {
554         require(isOwner());
555         _;
556     }
557 
558     /**
559      * @return true if `msg.sender` is the owner of the contract.
560      */
561     function isOwner() public view returns (bool) {
562         return msg.sender == _owner;
563     }
564 
565     /**
566      * @dev Allows the current owner to relinquish control of the contract.
567      * It will not be possible to call the functions with the `onlyOwner`
568      * modifier anymore.
569      * @notice Renouncing ownership will leave the contract without an owner,
570      * thereby removing any functionality that is only available to the owner.
571      */
572     function renounceOwnership() public onlyOwner {
573         emit OwnershipTransferred(_owner, address(0));
574         _owner = address(0);
575     }
576 
577     /**
578      * @dev Allows the current owner to transfer control of the contract to a newOwner.
579      * @param newOwner The address to transfer ownership to.
580      */
581     function transferOwnership(address newOwner) public onlyOwner {
582         _transferOwnership(newOwner);
583     }
584 
585     /**
586      * @dev Transfers control of the contract to a newOwner.
587      * @param newOwner The address to transfer ownership to.
588      */
589     function _transferOwnership(address newOwner) internal {
590         require(newOwner != address(0));
591         emit OwnershipTransferred(_owner, newOwner);
592         _owner = newOwner;
593     }
594 }
595 
596 /**
597  * @title ERC20Detailed token
598  * @dev The decimals are only for visualization purposes.
599  * All the operations are done using the smallest and indivisible token unit,
600  * just as on Ethereum all the operations are done in wei.
601  */
602 contract ERC20Detailed is IERC20 {
603     string private _name;
604     string private _symbol;
605     uint8 private _decimals;
606 
607     constructor (string memory name, string memory symbol, uint8 decimals) public {
608         _name = name;
609         _symbol = symbol;
610         _decimals = decimals;
611     }
612 
613     /**
614      * @return the name of the token.
615      */
616     function name() public view returns (string memory) {
617         return _name;
618     }
619 
620     /**
621      * @return the symbol of the token.
622      */
623     function symbol() public view returns (string memory) {
624         return _symbol;
625     }
626 
627     /**
628      * @return the number of decimals of the token.
629      */
630     function decimals() public view returns (uint8) {
631         return _decimals;
632     }
633 }
634 
635 /**
636  * @title Roles
637  * @dev Library for managing addresses assigned to a Role.
638  */
639 library Roles {
640     struct Role {
641         mapping (address => bool) bearer;
642     }
643 
644     /**
645      * @dev give an account access to this role
646      */
647     function add(Role storage role, address account) internal {
648         require(account != address(0));
649         require(!has(role, account));
650 
651         role.bearer[account] = true;
652     }
653 
654     /**
655      * @dev remove an account's access to this role
656      */
657     function remove(Role storage role, address account) internal {
658         require(account != address(0));
659         require(has(role, account));
660 
661         role.bearer[account] = false;
662     }
663 
664     /**
665      * @dev check if an account has this role
666      * @return bool
667      */
668     function has(Role storage role, address account) internal view returns (bool) {
669         require(account != address(0));
670         return role.bearer[account];
671     }
672 }
673 
674 contract PauserRole {
675     using Roles for Roles.Role;
676 
677     event PauserAdded(address indexed account);
678     event PauserRemoved(address indexed account);
679 
680     Roles.Role private _pausers;
681 
682     constructor () internal {
683         _addPauser(msg.sender);
684     }
685 
686     modifier onlyPauser() {
687         require(isPauser(msg.sender));
688         _;
689     }
690 
691     function isPauser(address account) public view returns (bool) {
692         return _pausers.has(account);
693     }
694 
695     function addPauser(address account) public onlyPauser {
696         _addPauser(account);
697     }
698 
699     function renouncePauser() public {
700         _removePauser(msg.sender);
701     }
702 
703     function _addPauser(address account) internal {
704         _pausers.add(account);
705         emit PauserAdded(account);
706     }
707 
708     function _removePauser(address account) internal {
709         _pausers.remove(account);
710         emit PauserRemoved(account);
711     }
712 }
713 
714 /**
715  * @title Pausable
716  * @dev Base contract which allows children to implement an emergency stop mechanism.
717  */
718 contract Pausable is PauserRole {
719     event Paused(address account);
720     event Unpaused(address account);
721 
722     bool private _paused;
723 
724     constructor () internal {
725         _paused = false;
726     }
727 
728     /**
729      * @return true if the contract is paused, false otherwise.
730      */
731     function paused() public view returns (bool) {
732         return _paused;
733     }
734 
735     /**
736      * @dev Modifier to make a function callable only when the contract is not paused.
737      */
738     modifier whenNotPaused() {
739         require(!_paused);
740         _;
741     }
742 
743     /**
744      * @dev Modifier to make a function callable only when the contract is paused.
745      */
746     modifier whenPaused() {
747         require(_paused);
748         _;
749     }
750 
751     /**
752      * @dev called by the owner to pause, triggers stopped state
753      */
754     function pause() public onlyPauser whenNotPaused {
755         _paused = true;
756         emit Paused(msg.sender);
757     }
758 
759     /**
760      * @dev called by the owner to unpause, returns to normal state
761      */
762     function unpause() public onlyPauser whenPaused {
763         _paused = false;
764         emit Unpaused(msg.sender);
765     }
766 }
767 
768 /**
769  * @title Pausable token
770  * @dev ERC20 modified with pausable transfers.
771  */
772 contract ERC20Pausable is ERC20, Pausable {
773     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
774         return super.transfer(to, value);
775     }
776 
777     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
778         return super.transferFrom(from, to, value);
779     }
780 
781     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
782         return super.approve(spender, value);
783     }
784 
785     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
786         return super.increaseAllowance(spender, addedValue);
787     }
788 
789     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
790         return super.decreaseAllowance(spender, subtractedValue);
791     }
792 }
793 
794 /**
795  * @title Burnable Token
796  * @dev Token that can be irreversibly burned (destroyed).
797  */
798 contract ERC20Burnable is ERC20 {
799     /**
800      * @dev Burns a specific amount of tokens.
801      * @param value The amount of token to be burned.
802      */
803     function burn(uint256 value) public {
804         _burn(msg.sender, value);
805     }
806 
807     /**
808      * @dev Burns a specific amount of tokens from the target address and decrements allowance
809      * @param from address The account whose tokens will be burned.
810      * @param value uint256 The amount of token to be burned.
811      */
812     function burnFrom(address from, uint256 value) public {
813         _burnFrom(from, value);
814     }
815 }
816 
817 contract RenToken is Ownable, ERC20Detailed, ERC20Pausable, ERC20Burnable {
818 
819     string private constant _name = "Republic Token";
820     string private constant _symbol = "REN";
821     uint8 private constant _decimals = 18;
822 
823     uint256 public constant INITIAL_SUPPLY = 1000000000 * 10**uint256(_decimals);
824 
825     /// @notice The RenToken Constructor.
826     constructor() ERC20Burnable() ERC20Pausable() ERC20Detailed(_name, _symbol, _decimals) public {
827         _mint(msg.sender, INITIAL_SUPPLY);
828     }
829 
830     function transferTokens(address beneficiary, uint256 amount) public onlyOwner returns (bool) {
831         /* solium-disable error-reason */
832         require(amount > 0);
833 
834         _transfer(msg.sender, beneficiary, amount);
835         emit Transfer(msg.sender, beneficiary, amount);
836 
837         return true;
838     }
839 }
840 
841 /// @notice DarknodeSlasher will become a voting system for darknodes to
842 /// deregister other misbehaving darknodes.
843 /// Right now, it is a placeholder.
844 contract DarknodeSlasher is Ownable {
845 
846     DarknodeRegistry public darknodeRegistry;
847 
848     constructor(DarknodeRegistry _darknodeRegistry) public {
849         darknodeRegistry = _darknodeRegistry;
850     }
851 
852     function slash(address _prover, address _challenger1, address _challenger2)
853         external
854         onlyOwner
855     {
856         darknodeRegistry.slash(_prover, _challenger1, _challenger2);
857     }
858 }
859 
860 /**
861  * @notice LinkedList is a library for a circular double linked list.
862  */
863 library LinkedList {
864 
865     /*
866     * @notice A permanent NULL node (0x0) in the circular double linked list.
867     * NULL.next is the head, and NULL.previous is the tail.
868     */
869     address public constant NULL = address(0);
870 
871     /**
872     * @notice A node points to the node before it, and the node after it. If
873     * node.previous = NULL, then the node is the head of the list. If
874     * node.next = NULL, then the node is the tail of the list.
875     */
876     struct Node {
877         bool inList;
878         address previous;
879         address next;
880     }
881 
882     /**
883     * @notice LinkedList uses a mapping from address to nodes. Each address
884     * uniquely identifies a node, and in this way they are used like pointers.
885     */
886     struct List {
887         mapping (address => Node) list;
888     }
889 
890     /**
891     * @notice Insert a new node before an existing node.
892     *
893     * @param self The list being used.
894     * @param target The existing node in the list.
895     * @param newNode The next node to insert before the target.
896     */
897     function insertBefore(List storage self, address target, address newNode) internal {
898         require(!isInList(self, newNode), "already in list");
899         require(isInList(self, target) || target == NULL, "not in list");
900 
901         // It is expected that this value is sometimes NULL.
902         address prev = self.list[target].previous;
903 
904         self.list[newNode].next = target;
905         self.list[newNode].previous = prev;
906         self.list[target].previous = newNode;
907         self.list[prev].next = newNode;
908 
909         self.list[newNode].inList = true;
910     }
911 
912     /**
913     * @notice Insert a new node after an existing node.
914     *
915     * @param self The list being used.
916     * @param target The existing node in the list.
917     * @param newNode The next node to insert after the target.
918     */
919     function insertAfter(List storage self, address target, address newNode) internal {
920         require(!isInList(self, newNode), "already in list");
921         require(isInList(self, target) || target == NULL, "not in list");
922 
923         // It is expected that this value is sometimes NULL.
924         address n = self.list[target].next;
925 
926         self.list[newNode].previous = target;
927         self.list[newNode].next = n;
928         self.list[target].next = newNode;
929         self.list[n].previous = newNode;
930 
931         self.list[newNode].inList = true;
932     }
933 
934     /**
935     * @notice Remove a node from the list, and fix the previous and next
936     * pointers that are pointing to the removed node. Removing anode that is not
937     * in the list will do nothing.
938     *
939     * @param self The list being using.
940     * @param node The node in the list to be removed.
941     */
942     function remove(List storage self, address node) internal {
943         require(isInList(self, node), "not in list");
944         if (node == NULL) {
945             return;
946         }
947         address p = self.list[node].previous;
948         address n = self.list[node].next;
949 
950         self.list[p].next = n;
951         self.list[n].previous = p;
952 
953         // Deleting the node should set this value to false, but we set it here for
954         // explicitness.
955         self.list[node].inList = false;
956         delete self.list[node];
957     }
958 
959     /**
960     * @notice Insert a node at the beginning of the list.
961     *
962     * @param self The list being used.
963     * @param node The node to insert at the beginning of the list.
964     */
965     function prepend(List storage self, address node) internal {
966         // isInList(node) is checked in insertBefore
967 
968         insertBefore(self, begin(self), node);
969     }
970 
971     /**
972     * @notice Insert a node at the end of the list.
973     *
974     * @param self The list being used.
975     * @param node The node to insert at the end of the list.
976     */
977     function append(List storage self, address node) internal {
978         // isInList(node) is checked in insertBefore
979 
980         insertAfter(self, end(self), node);
981     }
982 
983     function swap(List storage self, address left, address right) internal {
984         // isInList(left) and isInList(right) are checked in remove
985 
986         address previousRight = self.list[right].previous;
987         remove(self, right);
988         insertAfter(self, left, right);
989         remove(self, left);
990         insertAfter(self, previousRight, left);
991     }
992 
993     function isInList(List storage self, address node) internal view returns (bool) {
994         return self.list[node].inList;
995     }
996 
997     /**
998     * @notice Get the node at the beginning of a double linked list.
999     *
1000     * @param self The list being used.
1001     *
1002     * @return A address identifying the node at the beginning of the double
1003     * linked list.
1004     */
1005     function begin(List storage self) internal view returns (address) {
1006         return self.list[NULL].next;
1007     }
1008 
1009     /**
1010     * @notice Get the node at the end of a double linked list.
1011     *
1012     * @param self The list being used.
1013     *
1014     * @return A address identifying the node at the end of the double linked
1015     * list.
1016     */
1017     function end(List storage self) internal view returns (address) {
1018         return self.list[NULL].previous;
1019     }
1020 
1021     function next(List storage self, address node) internal view returns (address) {
1022         require(isInList(self, node), "not in list");
1023         return self.list[node].next;
1024     }
1025 
1026     function previous(List storage self, address node) internal view returns (address) {
1027         require(isInList(self, node), "not in list");
1028         return self.list[node].previous;
1029     }
1030 
1031 }
1032 
1033 /// @notice This contract stores data and funds for the DarknodeRegistry
1034 /// contract. The data / fund logic and storage have been separated to improve
1035 /// upgradability.
1036 contract DarknodeRegistryStore is Claimable {
1037     using SafeMath for uint256;
1038 
1039     string public VERSION; // Passed in as a constructor parameter.
1040 
1041     /// @notice Darknodes are stored in the darknode struct. The owner is the
1042     /// address that registered the darknode, the bond is the amount of REN that
1043     /// was transferred during registration, and the public key is the
1044     /// encryption key that should be used when sending sensitive information to
1045     /// the darknode.
1046     struct Darknode {
1047         // The owner of a Darknode is the address that called the register
1048         // function. The owner is the only address that is allowed to
1049         // deregister the Darknode, unless the Darknode is slashed for
1050         // malicious behavior.
1051         address payable owner;
1052 
1053         // The bond is the amount of REN submitted as a bond by the Darknode.
1054         // This amount is reduced when the Darknode is slashed for malicious
1055         // behavior.
1056         uint256 bond;
1057 
1058         // The block number at which the Darknode is considered registered.
1059         uint256 registeredAt;
1060 
1061         // The block number at which the Darknode is considered deregistered.
1062         uint256 deregisteredAt;
1063 
1064         // The public key used by this Darknode for encrypting sensitive data
1065         // off chain. It is assumed that the Darknode has access to the
1066         // respective private key, and that there is an agreement on the format
1067         // of the public key.
1068         bytes publicKey;
1069     }
1070 
1071     /// Registry data.
1072     mapping(address => Darknode) private darknodeRegistry;
1073     LinkedList.List private darknodes;
1074 
1075     // RenToken.
1076     RenToken public ren;
1077 
1078     /// @notice The contract constructor.
1079     ///
1080     /// @param _VERSION A string defining the contract version.
1081     /// @param _ren The address of the RenToken contract.
1082     constructor(
1083         string memory _VERSION,
1084         RenToken _ren
1085     ) public {
1086         VERSION = _VERSION;
1087         ren = _ren;
1088     }
1089 
1090     /// @notice Instantiates a darknode and appends it to the darknodes
1091     /// linked-list.
1092     ///
1093     /// @param _darknodeID The darknode's ID.
1094     /// @param _darknodeOwner The darknode's owner's address
1095     /// @param _bond The darknode's bond value
1096     /// @param _publicKey The darknode's public key
1097     /// @param _registeredAt The time stamp when the darknode is registered.
1098     /// @param _deregisteredAt The time stamp when the darknode is deregistered.
1099     function appendDarknode(
1100         address _darknodeID,
1101         address payable _darknodeOwner,
1102         uint256 _bond,
1103         bytes calldata _publicKey,
1104         uint256 _registeredAt,
1105         uint256 _deregisteredAt
1106     ) external onlyOwner {
1107         Darknode memory darknode = Darknode({
1108             owner: _darknodeOwner,
1109             bond: _bond,
1110             publicKey: _publicKey,
1111             registeredAt: _registeredAt,
1112             deregisteredAt: _deregisteredAt
1113         });
1114         darknodeRegistry[_darknodeID] = darknode;
1115         LinkedList.append(darknodes, _darknodeID);
1116     }
1117 
1118     /// @notice Returns the address of the first darknode in the store
1119     function begin() external view onlyOwner returns(address) {
1120         return LinkedList.begin(darknodes);
1121     }
1122 
1123     /// @notice Returns the address of the next darknode in the store after the
1124     /// given address.
1125     function next(address darknodeID) external view onlyOwner returns(address) {
1126         return LinkedList.next(darknodes, darknodeID);
1127     }
1128 
1129     /// @notice Removes a darknode from the store and transfers its bond to the
1130     /// owner of this contract.
1131     function removeDarknode(address darknodeID) external onlyOwner {
1132         uint256 bond = darknodeRegistry[darknodeID].bond;
1133         delete darknodeRegistry[darknodeID];
1134         LinkedList.remove(darknodes, darknodeID);
1135         require(ren.transfer(owner(), bond), "bond transfer failed");
1136     }
1137 
1138     /// @notice Updates the bond of a darknode. The new bond must be smaller
1139     /// than the previous bond of the darknode.
1140     function updateDarknodeBond(address darknodeID, uint256 decreasedBond) external onlyOwner {
1141         uint256 previousBond = darknodeRegistry[darknodeID].bond;
1142         require(decreasedBond < previousBond, "bond not decreased");
1143         darknodeRegistry[darknodeID].bond = decreasedBond;
1144         require(ren.transfer(owner(), previousBond.sub(decreasedBond)), "bond transfer failed");
1145     }
1146 
1147     /// @notice Updates the deregistration timestamp of a darknode.
1148     function updateDarknodeDeregisteredAt(address darknodeID, uint256 deregisteredAt) external onlyOwner {
1149         darknodeRegistry[darknodeID].deregisteredAt = deregisteredAt;
1150     }
1151 
1152     /// @notice Returns the owner of a given darknode.
1153     function darknodeOwner(address darknodeID) external view onlyOwner returns (address payable) {
1154         return darknodeRegistry[darknodeID].owner;
1155     }
1156 
1157     /// @notice Returns the bond of a given darknode.
1158     function darknodeBond(address darknodeID) external view onlyOwner returns (uint256) {
1159         return darknodeRegistry[darknodeID].bond;
1160     }
1161 
1162     /// @notice Returns the registration time of a given darknode.
1163     function darknodeRegisteredAt(address darknodeID) external view onlyOwner returns (uint256) {
1164         return darknodeRegistry[darknodeID].registeredAt;
1165     }
1166 
1167     /// @notice Returns the deregistration time of a given darknode.
1168     function darknodeDeregisteredAt(address darknodeID) external view onlyOwner returns (uint256) {
1169         return darknodeRegistry[darknodeID].deregisteredAt;
1170     }
1171 
1172     /// @notice Returns the encryption public key of a given darknode.
1173     function darknodePublicKey(address darknodeID) external view onlyOwner returns (bytes memory) {
1174         return darknodeRegistry[darknodeID].publicKey;
1175     }
1176 }
1177 
1178 /// @notice DarknodeRegistry is responsible for the registration and
1179 /// deregistration of Darknodes.
1180 contract DarknodeRegistry is Ownable {
1181     using SafeMath for uint256;
1182 
1183     string public VERSION; // Passed in as a constructor parameter.
1184 
1185     /// @notice Darknode pods are shuffled after a fixed number of blocks.
1186     /// An Epoch stores an epoch hash used as an (insecure) RNG seed, and the
1187     /// blocknumber which restricts when the next epoch can be called.
1188     struct Epoch {
1189         uint256 epochhash;
1190         uint256 blocknumber;
1191     }
1192 
1193     uint256 public numDarknodes;
1194     uint256 public numDarknodesNextEpoch;
1195     uint256 public numDarknodesPreviousEpoch;
1196 
1197     /// Variables used to parameterize behavior.
1198     uint256 public minimumBond;
1199     uint256 public minimumPodSize;
1200     uint256 public minimumEpochInterval;
1201 
1202     /// When one of the above variables is modified, it is only updated when the
1203     /// next epoch is called. These variables store the values for the next epoch.
1204     uint256 public nextMinimumBond;
1205     uint256 public nextMinimumPodSize;
1206     uint256 public nextMinimumEpochInterval;
1207 
1208     /// The current and previous epoch
1209     Epoch public currentEpoch;
1210     Epoch public previousEpoch;
1211 
1212     /// Republic ERC20 token contract used to transfer bonds.
1213     RenToken public ren;
1214 
1215     /// Darknode Registry Store is the storage contract for darknodes.
1216     DarknodeRegistryStore public store;
1217 
1218     /// Darknode Slasher allows darknodes to vote on bond slashing.
1219     DarknodeSlasher public slasher;
1220     DarknodeSlasher public nextSlasher;
1221 
1222     /// @notice Emitted when a darknode is registered.
1223     /// @param _darknodeID The darknode ID that was registered.
1224     /// @param _bond The amount of REN that was transferred as bond.
1225     event LogDarknodeRegistered(address indexed _darknodeID, uint256 _bond);
1226 
1227     /// @notice Emitted when a darknode is deregistered.
1228     /// @param _darknodeID The darknode ID that was deregistered.
1229     event LogDarknodeDeregistered(address indexed _darknodeID);
1230 
1231     /// @notice Emitted when a refund has been made.
1232     /// @param _owner The address that was refunded.
1233     /// @param _amount The amount of REN that was refunded.
1234     event LogDarknodeOwnerRefunded(address indexed _owner, uint256 _amount);
1235 
1236     /// @notice Emitted when a new epoch has begun.
1237     event LogNewEpoch(uint256 indexed epochhash);
1238 
1239     /// @notice Emitted when a constructor parameter has been updated.
1240     event LogMinimumBondUpdated(uint256 previousMinimumBond, uint256 nextMinimumBond);
1241     event LogMinimumPodSizeUpdated(uint256 previousMinimumPodSize, uint256 nextMinimumPodSize);
1242     event LogMinimumEpochIntervalUpdated(uint256 previousMinimumEpochInterval, uint256 nextMinimumEpochInterval);
1243     event LogSlasherUpdated(address previousSlasher, address nextSlasher);
1244 
1245     /// @notice Only allow the owner that registered the darknode to pass.
1246     modifier onlyDarknodeOwner(address _darknodeID) {
1247         require(store.darknodeOwner(_darknodeID) == msg.sender, "must be darknode owner");
1248         _;
1249     }
1250 
1251     /// @notice Only allow unregistered darknodes.
1252     modifier onlyRefunded(address _darknodeID) {
1253         require(isRefunded(_darknodeID), "must be refunded or never registered");
1254         _;
1255     }
1256 
1257     /// @notice Only allow refundable darknodes.
1258     modifier onlyRefundable(address _darknodeID) {
1259         require(isRefundable(_darknodeID), "must be deregistered for at least one epoch");
1260         _;
1261     }
1262 
1263     /// @notice Only allowed registered nodes without a pending deregistration to
1264     /// deregister
1265     modifier onlyDeregisterable(address _darknodeID) {
1266         require(isDeregisterable(_darknodeID), "must be deregisterable");
1267         _;
1268     }
1269 
1270     /// @notice Only allow the Slasher contract.
1271     modifier onlySlasher() {
1272         require(address(slasher) == msg.sender, "must be slasher");
1273         _;
1274     }
1275 
1276     /// @notice The contract constructor.
1277     ///
1278     /// @param _VERSION A string defining the contract version.
1279     /// @param _renAddress The address of the RenToken contract.
1280     /// @param _storeAddress The address of the DarknodeRegistryStore contract.
1281     /// @param _minimumBond The minimum bond amount that can be submitted by a
1282     ///        Darknode.
1283     /// @param _minimumPodSize The minimum size of a Darknode pod.
1284     /// @param _minimumEpochInterval The minimum number of blocks between
1285     ///        epochs.
1286     constructor(
1287         string memory _VERSION,
1288         RenToken _renAddress,
1289         DarknodeRegistryStore _storeAddress,
1290         uint256 _minimumBond,
1291         uint256 _minimumPodSize,
1292         uint256 _minimumEpochInterval
1293     ) public {
1294         VERSION = _VERSION;
1295 
1296         store = _storeAddress;
1297         ren = _renAddress;
1298 
1299         minimumBond = _minimumBond;
1300         nextMinimumBond = minimumBond;
1301 
1302         minimumPodSize = _minimumPodSize;
1303         nextMinimumPodSize = minimumPodSize;
1304 
1305         minimumEpochInterval = _minimumEpochInterval;
1306         nextMinimumEpochInterval = minimumEpochInterval;
1307 
1308         currentEpoch = Epoch({
1309             epochhash: uint256(blockhash(block.number - 1)),
1310             blocknumber: block.number
1311         });
1312         numDarknodes = 0;
1313         numDarknodesNextEpoch = 0;
1314         numDarknodesPreviousEpoch = 0;
1315     }
1316 
1317     /// @notice Register a darknode and transfer the bond to this contract.
1318     /// Before registering, the bond transfer must be approved in the REN
1319     /// contract. The caller must provide a public encryption key for the
1320     /// darknode. The darknode will remain pending registration until the next
1321     /// epoch. Only after this period can the darknode be deregistered. The
1322     /// caller of this method will be stored as the owner of the darknode.
1323     ///
1324     /// @param _darknodeID The darknode ID that will be registered.
1325     /// @param _publicKey The public key of the darknode. It is stored to allow
1326     ///        other darknodes and traders to encrypt messages to the trader.
1327     function register(address _darknodeID, bytes calldata _publicKey) external onlyRefunded(_darknodeID) {
1328         // Use the current minimum bond as the darknode's bond.
1329         uint256 bond = minimumBond;
1330 
1331         // Transfer bond to store
1332         require(ren.transferFrom(msg.sender, address(store), bond), "bond transfer failed");
1333 
1334         // Flag this darknode for registration
1335         store.appendDarknode(
1336             _darknodeID,
1337             msg.sender,
1338             bond,
1339             _publicKey,
1340             currentEpoch.blocknumber.add(minimumEpochInterval),
1341             0
1342         );
1343 
1344         numDarknodesNextEpoch = numDarknodesNextEpoch.add(1);
1345 
1346         // Emit an event.
1347         emit LogDarknodeRegistered(_darknodeID, bond);
1348     }
1349 
1350     /// @notice Deregister a darknode. The darknode will not be deregistered
1351     /// until the end of the epoch. After another epoch, the bond can be
1352     /// refunded by calling the refund method.
1353     /// @param _darknodeID The darknode ID that will be deregistered. The caller
1354     ///        of this method store.darknodeRegisteredAt(_darknodeID) must be
1355     //         the owner of this darknode.
1356     function deregister(address _darknodeID) external onlyDeregisterable(_darknodeID) onlyDarknodeOwner(_darknodeID) {
1357         deregisterDarknode(_darknodeID);
1358     }
1359 
1360     /// @notice Progress the epoch if it is possible to do so. This captures
1361     /// the current timestamp and current blockhash and overrides the current
1362     /// epoch.
1363     function epoch() external {
1364         if (previousEpoch.blocknumber == 0) {
1365             // The first epoch must be called by the owner of the contract
1366             require(msg.sender == owner(), "not authorized (first epochs)");
1367         }
1368 
1369         // Require that the epoch interval has passed
1370         require(block.number >= currentEpoch.blocknumber.add(minimumEpochInterval), "epoch interval has not passed");
1371         uint256 epochhash = uint256(blockhash(block.number - 1));
1372 
1373         // Update the epoch hash and timestamp
1374         previousEpoch = currentEpoch;
1375         currentEpoch = Epoch({
1376             epochhash: epochhash,
1377             blocknumber: block.number
1378         });
1379 
1380         // Update the registry information
1381         numDarknodesPreviousEpoch = numDarknodes;
1382         numDarknodes = numDarknodesNextEpoch;
1383 
1384         // If any update functions have been called, update the values now
1385         if (nextMinimumBond != minimumBond) {
1386             minimumBond = nextMinimumBond;
1387             emit LogMinimumBondUpdated(minimumBond, nextMinimumBond);
1388         }
1389         if (nextMinimumPodSize != minimumPodSize) {
1390             minimumPodSize = nextMinimumPodSize;
1391             emit LogMinimumPodSizeUpdated(minimumPodSize, nextMinimumPodSize);
1392         }
1393         if (nextMinimumEpochInterval != minimumEpochInterval) {
1394             minimumEpochInterval = nextMinimumEpochInterval;
1395             emit LogMinimumEpochIntervalUpdated(minimumEpochInterval, nextMinimumEpochInterval);
1396         }
1397         if (nextSlasher != slasher) {
1398             slasher = nextSlasher;
1399             emit LogSlasherUpdated(address(slasher), address(nextSlasher));
1400         }
1401 
1402         // Emit an event
1403         emit LogNewEpoch(epochhash);
1404     }
1405 
1406     /// @notice Allows the contract owner to initiate an ownership transfer of
1407     /// the DarknodeRegistryStore. 
1408     /// @param _newOwner The address to transfer the ownership to.
1409     function transferStoreOwnership(address _newOwner) external onlyOwner {
1410         store.transferOwnership(_newOwner);
1411     }
1412 
1413     /// @notice Claims ownership of the store passed in to the constructor.
1414     /// `transferStoreOwnership` must have previously been called when
1415     /// transferring from another Darknode Registry.
1416     function claimStoreOwnership() external onlyOwner {
1417         store.claimOwnership();
1418     }
1419 
1420     /// @notice Allows the contract owner to update the minimum bond.
1421     /// @param _nextMinimumBond The minimum bond amount that can be submitted by
1422     ///        a darknode.
1423     function updateMinimumBond(uint256 _nextMinimumBond) external onlyOwner {
1424         // Will be updated next epoch
1425         nextMinimumBond = _nextMinimumBond;
1426     }
1427 
1428     /// @notice Allows the contract owner to update the minimum pod size.
1429     /// @param _nextMinimumPodSize The minimum size of a pod.
1430     function updateMinimumPodSize(uint256 _nextMinimumPodSize) external onlyOwner {
1431         // Will be updated next epoch
1432         nextMinimumPodSize = _nextMinimumPodSize;
1433     }
1434 
1435     /// @notice Allows the contract owner to update the minimum epoch interval.
1436     /// @param _nextMinimumEpochInterval The minimum number of blocks between epochs.
1437     function updateMinimumEpochInterval(uint256 _nextMinimumEpochInterval) external onlyOwner {
1438         // Will be updated next epoch
1439         nextMinimumEpochInterval = _nextMinimumEpochInterval;
1440     }
1441 
1442     /// @notice Allow the contract owner to update the DarknodeSlasher contract
1443     /// address.
1444     /// @param _slasher The new slasher address.
1445     function updateSlasher(DarknodeSlasher _slasher) external onlyOwner {
1446         require(address(_slasher) != address(0), "invalid slasher address");
1447         nextSlasher = _slasher;
1448     }
1449 
1450     /// @notice Allow the DarknodeSlasher contract to slash half of a darknode's
1451     /// bond and deregister it. The bond is distributed as follows:
1452     ///   1/2 is kept by the guilty prover
1453     ///   1/8 is rewarded to the first challenger
1454     ///   1/8 is rewarded to the second challenger
1455     ///   1/4 becomes unassigned
1456     /// @param _prover The guilty prover whose bond is being slashed
1457     /// @param _challenger1 The first of the two darknodes who submitted the challenge
1458     /// @param _challenger2 The second of the two darknodes who submitted the challenge
1459     function slash(address _prover, address _challenger1, address _challenger2)
1460         external
1461         onlySlasher
1462     {
1463         uint256 penalty = store.darknodeBond(_prover) / 2;
1464         uint256 reward = penalty / 4;
1465 
1466         // Slash the bond of the failed prover in half
1467         store.updateDarknodeBond(_prover, penalty);
1468 
1469         // If the darknode has not been deregistered then deregister it
1470         if (isDeregisterable(_prover)) {
1471             deregisterDarknode(_prover);
1472         }
1473 
1474         // Reward the challengers with less than the penalty so that it is not
1475         // worth challenging yourself
1476         require(ren.transfer(store.darknodeOwner(_challenger1), reward), "reward transfer failed");
1477         require(ren.transfer(store.darknodeOwner(_challenger2), reward), "reward transfer failed");
1478     }
1479 
1480     /// @notice Refund the bond of a deregistered darknode. This will make the
1481     /// darknode available for registration again. Anyone can call this function
1482     /// but the bond will always be refunded to the darknode owner.
1483     ///
1484     /// @param _darknodeID The darknode ID that will be refunded. The caller
1485     ///        of this method must be the owner of this darknode.
1486     function refund(address _darknodeID) external onlyRefundable(_darknodeID) {
1487         address darknodeOwner = store.darknodeOwner(_darknodeID);
1488 
1489         // Remember the bond amount
1490         uint256 amount = store.darknodeBond(_darknodeID);
1491 
1492         // Erase the darknode from the registry
1493         store.removeDarknode(_darknodeID);
1494 
1495         // Refund the owner by transferring REN
1496         require(ren.transfer(darknodeOwner, amount), "bond transfer failed");
1497 
1498         // Emit an event.
1499         emit LogDarknodeOwnerRefunded(darknodeOwner, amount);
1500     }
1501 
1502     /// @notice Retrieves the address of the account that registered a darknode.
1503     /// @param _darknodeID The ID of the darknode to retrieve the owner for.
1504     function getDarknodeOwner(address _darknodeID) external view returns (address payable) {
1505         return store.darknodeOwner(_darknodeID);
1506     }
1507 
1508     /// @notice Retrieves the bond amount of a darknode in 10^-18 REN.
1509     /// @param _darknodeID The ID of the darknode to retrieve the bond for.
1510     function getDarknodeBond(address _darknodeID) external view returns (uint256) {
1511         return store.darknodeBond(_darknodeID);
1512     }
1513 
1514     /// @notice Retrieves the encryption public key of the darknode.
1515     /// @param _darknodeID The ID of the darknode to retrieve the public key for.
1516     function getDarknodePublicKey(address _darknodeID) external view returns (bytes memory) {
1517         return store.darknodePublicKey(_darknodeID);
1518     }
1519 
1520     /// @notice Retrieves a list of darknodes which are registered for the
1521     /// current epoch.
1522     /// @param _start A darknode ID used as an offset for the list. If _start is
1523     ///        0x0, the first dark node will be used. _start won't be
1524     ///        included it is not registered for the epoch.
1525     /// @param _count The number of darknodes to retrieve starting from _start.
1526     ///        If _count is 0, all of the darknodes from _start are
1527     ///        retrieved. If _count is more than the remaining number of
1528     ///        registered darknodes, the rest of the list will contain
1529     ///        0x0s.
1530     function getDarknodes(address _start, uint256 _count) external view returns (address[] memory) {
1531         uint256 count = _count;
1532         if (count == 0) {
1533             count = numDarknodes;
1534         }
1535         return getDarknodesFromEpochs(_start, count, false);
1536     }
1537 
1538     /// @notice Retrieves a list of darknodes which were registered for the
1539     /// previous epoch. See `getDarknodes` for the parameter documentation.
1540     function getPreviousDarknodes(address _start, uint256 _count) external view returns (address[] memory) {
1541         uint256 count = _count;
1542         if (count == 0) {
1543             count = numDarknodesPreviousEpoch;
1544         }
1545         return getDarknodesFromEpochs(_start, count, true);
1546     }
1547 
1548     /// @notice Returns whether a darknode is scheduled to become registered
1549     /// at next epoch.
1550     /// @param _darknodeID The ID of the darknode to return
1551     function isPendingRegistration(address _darknodeID) external view returns (bool) {
1552         uint256 registeredAt = store.darknodeRegisteredAt(_darknodeID);
1553         return registeredAt != 0 && registeredAt > currentEpoch.blocknumber;
1554     }
1555 
1556     /// @notice Returns if a darknode is in the pending deregistered state. In
1557     /// this state a darknode is still considered registered.
1558     function isPendingDeregistration(address _darknodeID) external view returns (bool) {
1559         uint256 deregisteredAt = store.darknodeDeregisteredAt(_darknodeID);
1560         return deregisteredAt != 0 && deregisteredAt > currentEpoch.blocknumber;
1561     }
1562 
1563     /// @notice Returns if a darknode is in the deregistered state.
1564     function isDeregistered(address _darknodeID) public view returns (bool) {
1565         uint256 deregisteredAt = store.darknodeDeregisteredAt(_darknodeID);
1566         return deregisteredAt != 0 && deregisteredAt <= currentEpoch.blocknumber;
1567     }
1568 
1569     /// @notice Returns if a darknode can be deregistered. This is true if the
1570     /// darknodes is in the registered state and has not attempted to
1571     /// deregister yet.
1572     function isDeregisterable(address _darknodeID) public view returns (bool) {
1573         uint256 deregisteredAt = store.darknodeDeregisteredAt(_darknodeID);
1574         // The Darknode is currently in the registered state and has not been
1575         // transitioned to the pending deregistration, or deregistered, state
1576         return isRegistered(_darknodeID) && deregisteredAt == 0;
1577     }
1578 
1579     /// @notice Returns if a darknode is in the refunded state. This is true
1580     /// for darknodes that have never been registered, or darknodes that have
1581     /// been deregistered and refunded.
1582     function isRefunded(address _darknodeID) public view returns (bool) {
1583         uint256 registeredAt = store.darknodeRegisteredAt(_darknodeID);
1584         uint256 deregisteredAt = store.darknodeDeregisteredAt(_darknodeID);
1585         return registeredAt == 0 && deregisteredAt == 0;
1586     }
1587 
1588     /// @notice Returns if a darknode is refundable. This is true for darknodes
1589     /// that have been in the deregistered state for one full epoch.
1590     function isRefundable(address _darknodeID) public view returns (bool) {
1591         return isDeregistered(_darknodeID) && store.darknodeDeregisteredAt(_darknodeID) <= previousEpoch.blocknumber;
1592     }
1593 
1594     /// @notice Returns if a darknode is in the registered state.
1595     function isRegistered(address _darknodeID) public view returns (bool) {
1596         return isRegisteredInEpoch(_darknodeID, currentEpoch);
1597     }
1598 
1599     /// @notice Returns if a darknode was in the registered state last epoch.
1600     function isRegisteredInPreviousEpoch(address _darknodeID) public view returns (bool) {
1601         return isRegisteredInEpoch(_darknodeID, previousEpoch);
1602     }
1603 
1604     /// @notice Returns if a darknode was in the registered state for a given
1605     /// epoch.
1606     /// @param _darknodeID The ID of the darknode
1607     /// @param _epoch One of currentEpoch, previousEpoch
1608     function isRegisteredInEpoch(address _darknodeID, Epoch memory _epoch) private view returns (bool) {
1609         uint256 registeredAt = store.darknodeRegisteredAt(_darknodeID);
1610         uint256 deregisteredAt = store.darknodeDeregisteredAt(_darknodeID);
1611         bool registered = registeredAt != 0 && registeredAt <= _epoch.blocknumber;
1612         bool notDeregistered = deregisteredAt == 0 || deregisteredAt > _epoch.blocknumber;
1613         // The Darknode has been registered and has not yet been deregistered,
1614         // although it might be pending deregistration
1615         return registered && notDeregistered;
1616     }
1617 
1618     /// @notice Returns a list of darknodes registered for either the current
1619     /// or the previous epoch. See `getDarknodes` for documentation on the
1620     /// parameters `_start` and `_count`.
1621     /// @param _usePreviousEpoch If true, use the previous epoch, otherwise use
1622     ///        the current epoch.
1623     function getDarknodesFromEpochs(address _start, uint256 _count, bool _usePreviousEpoch) private view returns (address[] memory) {
1624         uint256 count = _count;
1625         if (count == 0) {
1626             count = numDarknodes;
1627         }
1628 
1629         address[] memory nodes = new address[](count);
1630 
1631         // Begin with the first node in the list
1632         uint256 n = 0;
1633         address next = _start;
1634         if (next == address(0)) {
1635             next = store.begin();
1636         }
1637 
1638         // Iterate until all registered Darknodes have been collected
1639         while (n < count) {
1640             if (next == address(0)) {
1641                 break;
1642             }
1643             // Only include Darknodes that are currently registered
1644             bool includeNext;
1645             if (_usePreviousEpoch) {
1646                 includeNext = isRegisteredInPreviousEpoch(next);
1647             } else {
1648                 includeNext = isRegistered(next);
1649             }
1650             if (!includeNext) {
1651                 next = store.next(next);
1652                 continue;
1653             }
1654             nodes[n] = next;
1655             next = store.next(next);
1656             n += 1;
1657         }
1658         return nodes;
1659     }
1660 
1661     /// Private function called by `deregister` and `slash`
1662     function deregisterDarknode(address _darknodeID) private {
1663         // Flag the darknode for deregistration
1664         store.updateDarknodeDeregisteredAt(_darknodeID, currentEpoch.blocknumber.add(minimumEpochInterval));
1665         numDarknodesNextEpoch = numDarknodesNextEpoch.sub(1);
1666 
1667         // Emit an event
1668         emit LogDarknodeDeregistered(_darknodeID);
1669     }
1670 }
1671 
1672 /// @notice DarknodePaymentStore is responsible for tracking black/whitelisted
1673 ///         darknodes as well as the balances which have been allocated to the
1674 ///         darknodes. It is also responsible for holding the tokens to be paid
1675 ///         out to darknodes.
1676 contract DarknodePaymentStore is Claimable {
1677     using SafeMath for uint256;
1678     using CompatibleERC20Functions for ERC20;
1679 
1680     string public VERSION; // Passed in as a constructor parameter.
1681 
1682     /// @notice The special address for Ether.
1683     address constant public ETHEREUM = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1684 
1685     /// @notice The size of the whitelist
1686     uint256 public darknodeWhitelistLength;
1687 
1688     /// @notice Mapping of darknode -> token -> balance
1689     mapping(address => mapping(address => uint256)) public darknodeBalances;
1690 
1691     /// @notice Mapping of token -> lockedAmount
1692     mapping(address => uint256) public lockedBalances;
1693 
1694     /// @notice mapping of darknode -> blacklistTimestamp
1695     mapping(address => uint256) public darknodeBlacklist;
1696 
1697     /// @notice mapping of darknode -> whitelistTimestamp
1698     mapping(address => uint256) public darknodeWhitelist;
1699 
1700     /// @notice The contract constructor.
1701     ///
1702     /// @param _VERSION A string defining the contract version.
1703     constructor(
1704         string memory _VERSION
1705     ) public {
1706         VERSION = _VERSION;
1707     }
1708 
1709     /// @notice Allow direct payments to be made to the DarknodePaymentStore.
1710     function () external payable {
1711     }
1712 
1713     /// @notice Checks to see if a darknode is blacklisted
1714     ///
1715     /// @param _darknode The address of the darknode
1716     /// @return true if the darknode is blacklisted
1717     function isBlacklisted(address _darknode) public view returns (bool) {
1718         return darknodeBlacklist[_darknode] != 0;
1719     }
1720 
1721     /// @notice Checks to see if a darknode is whitelisted
1722     ///
1723     /// @param _darknode The address of the darknode
1724     /// @return true if the darknode is whitelisted
1725     function isWhitelisted(address _darknode) public view returns (bool) {
1726         return darknodeWhitelist[_darknode] != 0;
1727     }
1728 
1729     /// @notice Get the total balance of the contract for a particular token
1730     ///
1731     /// @param _token The token to check balance of
1732     /// @return The total balance of the contract
1733     function totalBalance(address _token) public view returns (uint256) {
1734         if (_token == ETHEREUM) {
1735             return address(this).balance;
1736         } else {
1737             return ERC20(_token).balanceOf(address(this));
1738         }
1739     }
1740 
1741     /// @notice Get the available balance of the contract for a particular token
1742     ///         This is the free amount which has not yet been allocated to
1743     ///         darknodes.
1744     ///
1745     /// @param _token The token to check balance of
1746     /// @return The available balance of the contract
1747     function availableBalance(address _token) public view returns (uint256) {
1748         return totalBalance(_token).sub(lockedBalances[_token]);
1749     }
1750 
1751     /// @notice Blacklists a darknode from participating in reward allocation.
1752     ///         If the darknode is whitelisted, it is removed from the whitelist
1753     ///         and the number of whitelisted nodes is decreased.
1754     ///
1755     /// @param _darknode The address of the darknode to blacklist
1756     function blacklist(address _darknode) external onlyOwner {
1757         require(!isBlacklisted(_darknode), "darknode already blacklisted");
1758         darknodeBlacklist[_darknode] = now;
1759 
1760         // Unwhitelist if necessary
1761         if (isWhitelisted(_darknode)) {
1762             darknodeWhitelist[_darknode] = 0;
1763             // Use SafeMath when subtracting to avoid underflows
1764             darknodeWhitelistLength = darknodeWhitelistLength.sub(1);
1765         }
1766     }
1767 
1768     /// @notice Whitelists a darknode allowing it to participate in reward
1769     ///         allocation.
1770     ///
1771     /// @param _darknode The address of the darknode to whitelist
1772     function whitelist(address _darknode) external onlyOwner {
1773         require(!isBlacklisted(_darknode), "darknode is blacklisted");
1774         require(!isWhitelisted(_darknode), "darknode already whitelisted");
1775 
1776         darknodeWhitelist[_darknode] = now;
1777         darknodeWhitelistLength++;
1778     }
1779 
1780     /// @notice Increments the amount of funds allocated to a particular
1781     ///         darknode.
1782     ///
1783     /// @param _darknode The address of the darknode to increase balance of
1784     /// @param _token The token which the balance should be incremented
1785     /// @param _amount The amount that the balance should be incremented by
1786     function incrementDarknodeBalance(address _darknode, address _token, uint256 _amount) external onlyOwner {
1787         require(_amount > 0, "invalid amount");
1788         require(availableBalance(_token) >= _amount, "insufficient contract balance");
1789 
1790         darknodeBalances[_darknode][_token] = darknodeBalances[_darknode][_token].add(_amount);
1791         lockedBalances[_token] = lockedBalances[_token].add(_amount);
1792     }
1793 
1794     /// @notice Transfers an amount out of balance to a specified address
1795     ///
1796     /// @param _darknode The address of the darknode
1797     /// @param _token Which token to transfer
1798     /// @param _amount The amount to transfer
1799     /// @param _recipient The address to withdraw it to
1800     function transfer(address _darknode, address _token, uint256 _amount, address payable _recipient) external onlyOwner {
1801         require(darknodeBalances[_darknode][_token] >= _amount, "insufficient darknode balance");
1802         darknodeBalances[_darknode][_token] = darknodeBalances[_darknode][_token].sub(_amount);
1803         lockedBalances[_token] = lockedBalances[_token].sub(_amount);
1804 
1805         if (_token == ETHEREUM) {
1806             _recipient.transfer(_amount);
1807         } else {
1808             ERC20(_token).safeTransfer(_recipient, _amount);
1809         }
1810     }
1811 
1812 }