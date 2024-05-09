1 pragma solidity 0.5.3;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a, "SafeMath: subtraction overflow");
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Returns the multiplication of two unsigned integers, reverting on
51      * overflow.
52      *
53      * Counterpart to Solidity's `*` operator.
54      *
55      * Requirements:
56      * - Multiplication cannot overflow.
57      */
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60         // benefit is lost if 'b' is also tested.
61         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
62         if (a == 0) {
63             return 0;
64         }
65 
66         uint256 c = a * b;
67         require(c / a == b, "SafeMath: multiplication overflow");
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the integer division of two unsigned integers. Reverts on
74      * division by zero. The result is rounded towards zero.
75      *
76      * Counterpart to Solidity's `/` operator. Note: this function uses a
77      * `revert` opcode (which leaves remaining gas untouched) while Solidity
78      * uses an invalid opcode to revert (consuming all remaining gas).
79      *
80      * Requirements:
81      * - The divisor cannot be zero.
82      */
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Solidity only automatically asserts when dividing by 0
85         require(b > 0, "SafeMath: division by zero");
86         uint256 c = a / b;
87         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
94      * Reverts when dividing by zero.
95      *
96      * Counterpart to Solidity's `%` operator. This function uses a `revert`
97      * opcode (which leaves remaining gas untouched) while Solidity uses an
98      * invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      * - The divisor cannot be zero.
102      */
103     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b != 0, "SafeMath: modulo by zero");
105         return a % b;
106     }
107 }
108 
109 
110 /**
111  * @title Roles
112  * @dev Library for managing addresses assigned to a Role.
113  */
114 library Roles {
115     struct Role {
116         mapping (address => bool) bearer;
117     }
118 
119     /**
120      * @dev Give an account access to this role.
121      */
122     function add(Role storage role, address account) internal {
123         require(!has(role, account), "Roles: account already has role");
124         role.bearer[account] = true;
125     }
126 
127     /**
128      * @dev Remove an account's access to this role.
129      */
130     function remove(Role storage role, address account) internal {
131         require(has(role, account), "Roles: account does not have role");
132         role.bearer[account] = false;
133     }
134 
135     /**
136      * @dev Check if an account has this role.
137      * @return bool
138      */
139     function has(Role storage role, address account) internal view returns (bool) {
140         require(account != address(0), "Roles: account is the zero address");
141         return role.bearer[account];
142     }
143 }
144 
145 
146 
147 /**
148  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
149  * the optional functions; to access them see `ERC20Detailed`.
150  */
151 interface IERC20 {
152     /**
153      * @dev Returns the amount of tokens in existence.
154      */
155     function totalSupply() external view returns (uint256);
156 
157     /**
158      * @dev Returns the amount of tokens owned by `account`.
159      */
160     function balanceOf(address account) external view returns (uint256);
161 
162     /**
163      * @dev Moves `amount` tokens from the caller's account to `recipient`.
164      *
165      * Returns a boolean value indicating whether the operation succeeded.
166      *
167      * Emits a `Transfer` event.
168      */
169     function transfer(address recipient, uint256 amount) external returns (bool);
170 
171     /**
172      * @dev Returns the remaining number of tokens that `spender` will be
173      * allowed to spend on behalf of `owner` through `transferFrom`. This is
174      * zero by default.
175      *
176      * This value changes when `approve` or `transferFrom` are called.
177      */
178     function allowance(address owner, address spender) external view returns (uint256);
179 
180     /**
181      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
182      *
183      * Returns a boolean value indicating whether the operation succeeded.
184      *
185      * > Beware that changing an allowance with this method brings the risk
186      * that someone may use both the old and the new allowance by unfortunate
187      * transaction ordering. One possible solution to mitigate this race
188      * condition is to first reduce the spender's allowance to 0 and set the
189      * desired value afterwards:
190      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191      *
192      * Emits an `Approval` event.
193      */
194     function approve(address spender, uint256 amount) external returns (bool);
195 
196     /**
197      * @dev Moves `amount` tokens from `sender` to `recipient` using the
198      * allowance mechanism. `amount` is then deducted from the caller's
199      * allowance.
200      *
201      * Returns a boolean value indicating whether the operation succeeded.
202      *
203      * Emits a `Transfer` event.
204      */
205     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
206 
207     /**
208      * @dev Emitted when `value` tokens are moved from one account (`from`) to
209      * another (`to`).
210      *
211      * Note that `value` may be zero.
212      */
213     event Transfer(address indexed from, address indexed to, uint256 value);
214 
215     /**
216      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
217      * a call to `approve`. `value` is the new allowance.
218      */
219     event Approval(address indexed owner, address indexed spender, uint256 value);
220 }
221 
222 
223 contract PauserRole {
224     using Roles for Roles.Role;
225 
226     event PauserAdded(address indexed account);
227     event PauserRemoved(address indexed account);
228 
229     Roles.Role private _pausers;
230 
231     constructor () internal {
232         _addPauser(msg.sender);
233     }
234 
235     modifier onlyPauser() {
236         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
237         _;
238     }
239 
240     function isPauser(address account) public view returns (bool) {
241         return _pausers.has(account);
242     }
243 
244     function addPauser(address account) public onlyPauser {
245         _addPauser(account);
246     }
247 
248     function renouncePauser() public {
249         _removePauser(msg.sender);
250     }
251 
252     function _addPauser(address account) internal {
253         _pausers.add(account);
254         emit PauserAdded(account);
255     }
256 
257     function _removePauser(address account) internal {
258         _pausers.remove(account);
259         emit PauserRemoved(account);
260     }
261 }
262 
263 
264 /**
265  * @dev Contract module which allows children to implement an emergency stop
266  * mechanism that can be triggered by an authorized account.
267  *
268  * This module is used through inheritance. It will make available the
269  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
270  * the functions of your contract. Note that they will not be pausable by
271  * simply including this module, only once the modifiers are put in place.
272  */
273 contract Pausable is PauserRole {
274     /**
275      * @dev Emitted when the pause is triggered by a pauser (`account`).
276      */
277     event Paused(address account);
278 
279     /**
280      * @dev Emitted when the pause is lifted by a pauser (`account`).
281      */
282     event Unpaused(address account);
283 
284     bool private _paused;
285 
286     /**
287      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
288      * to the deployer.
289      */
290     constructor () internal {
291         _paused = false;
292     }
293 
294     /**
295      * @dev Returns true if the contract is paused, and false otherwise.
296      */
297     function paused() public view returns (bool) {
298         return _paused;
299     }
300 
301     /**
302      * @dev Modifier to make a function callable only when the contract is not paused.
303      */
304     modifier whenNotPaused() {
305         require(!_paused, "Pausable: paused");
306         _;
307     }
308 
309     /**
310      * @dev Modifier to make a function callable only when the contract is paused.
311      */
312     modifier whenPaused() {
313         require(_paused, "Pausable: not paused");
314         _;
315     }
316 
317     /**
318      * @dev Called by a pauser to pause, triggers stopped state.
319      */
320     function pause() public onlyPauser whenNotPaused {
321         _paused = true;
322         emit Paused(msg.sender);
323     }
324 
325     /**
326      * @dev Called by a pauser to unpause, returns to normal state.
327      */
328     function unpause() public onlyPauser whenPaused {
329         _paused = false;
330         emit Unpaused(msg.sender);
331     }
332 }
333 
334 
335 
336 /**
337  * @dev Implementation of the `IERC20` interface.
338  *
339  * This implementation is agnostic to the way tokens are created. This means
340  * that a supply mechanism has to be added in a derived contract using `_mint`.
341  * For a generic mechanism see `ERC20Mintable`.
342  *
343  * *For a detailed writeup see our guide [How to implement supply
344  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
345  *
346  * We have followed general OpenZeppelin guidelines: functions revert instead
347  * of returning `false` on failure. This behavior is nonetheless conventional
348  * and does not conflict with the expectations of ERC20 applications.
349  *
350  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
351  * This allows applications to reconstruct the allowance for all accounts just
352  * by listening to said events. Other implementations of the EIP may not emit
353  * these events, as it isn't required by the specification.
354  *
355  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
356  * functions have been added to mitigate the well-known issues around setting
357  * allowances. See `IERC20.approve`.
358  */
359 contract ERC20 is IERC20 {
360     using SafeMath for uint256;
361 
362     mapping (address => uint256) private _balances;
363 
364     mapping (address => mapping (address => uint256)) private _allowances;
365 
366     uint256 private _totalSupply;
367 
368     /**
369      * @dev See `IERC20.totalSupply`.
370      */
371     function totalSupply() public view returns (uint256) {
372         return _totalSupply;
373     }
374 
375     /**
376      * @dev See `IERC20.balanceOf`.
377      */
378     function balanceOf(address account) public view returns (uint256) {
379         return _balances[account];
380     }
381 
382     /**
383      * @dev See `IERC20.transfer`.
384      *
385      * Requirements:
386      *
387      * - `recipient` cannot be the zero address.
388      * - the caller must have a balance of at least `amount`.
389      */
390     function transfer(address recipient, uint256 amount) public returns (bool) {
391         _transfer(msg.sender, recipient, amount);
392         return true;
393     }
394 
395     /**
396      * @dev See `IERC20.allowance`.
397      */
398     function allowance(address owner, address spender) public view returns (uint256) {
399         return _allowances[owner][spender];
400     }
401 
402     /**
403      * @dev See `IERC20.approve`.
404      *
405      * Requirements:
406      *
407      * - `spender` cannot be the zero address.
408      */
409     function approve(address spender, uint256 value) public returns (bool) {
410         _approve(msg.sender, spender, value);
411         return true;
412     }
413 
414     /**
415      * @dev See `IERC20.transferFrom`.
416      *
417      * Emits an `Approval` event indicating the updated allowance. This is not
418      * required by the EIP. See the note at the beginning of `ERC20`;
419      *
420      * Requirements:
421      * - `sender` and `recipient` cannot be the zero address.
422      * - `sender` must have a balance of at least `value`.
423      * - the caller must have allowance for `sender`'s tokens of at least
424      * `amount`.
425      */
426     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
427         _transfer(sender, recipient, amount);
428         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
429         return true;
430     }
431 
432     /**
433      * @dev Atomically increases the allowance granted to `spender` by the caller.
434      *
435      * This is an alternative to `approve` that can be used as a mitigation for
436      * problems described in `IERC20.approve`.
437      *
438      * Emits an `Approval` event indicating the updated allowance.
439      *
440      * Requirements:
441      *
442      * - `spender` cannot be the zero address.
443      */
444     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
445         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
446         return true;
447     }
448 
449     /**
450      * @dev Atomically decreases the allowance granted to `spender` by the caller.
451      *
452      * This is an alternative to `approve` that can be used as a mitigation for
453      * problems described in `IERC20.approve`.
454      *
455      * Emits an `Approval` event indicating the updated allowance.
456      *
457      * Requirements:
458      *
459      * - `spender` cannot be the zero address.
460      * - `spender` must have allowance for the caller of at least
461      * `subtractedValue`.
462      */
463     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
464         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
465         return true;
466     }
467 
468     /**
469      * @dev Moves tokens `amount` from `sender` to `recipient`.
470      *
471      * This is internal function is equivalent to `transfer`, and can be used to
472      * e.g. implement automatic token fees, slashing mechanisms, etc.
473      *
474      * Emits a `Transfer` event.
475      *
476      * Requirements:
477      *
478      * - `sender` cannot be the zero address.
479      * - `recipient` cannot be the zero address.
480      * - `sender` must have a balance of at least `amount`.
481      */
482     function _transfer(address sender, address recipient, uint256 amount) internal {
483         require(sender != address(0), "ERC20: transfer from the zero address");
484         require(recipient != address(0), "ERC20: transfer to the zero address");
485         require(_balances[sender] >= amount, "ERC20: transfer more than balance");
486         require(amount > 0, "ERC20: transfer value negative");
487         
488         _balances[sender] = _balances[sender].sub(amount);
489         _balances[recipient] = _balances[recipient].add(amount);
490         emit Transfer(sender, recipient, amount);
491     }
492 
493      /**
494      * @dev Destoys `amount` tokens from `account`, reducing the
495      * total supply.
496      *
497      * Emits a `Transfer` event with `to` set to the zero address.
498      *
499      * Requirements
500      *
501      * - `account` cannot be the zero address.
502      * - `account` must have at least `amount` tokens.
503      */
504     function _burn(address account, uint256 value) internal {
505         require(account != address(0), "ERC20: burn from the zero address");
506         require(_balances[account] >= value, "ERC20: burn overflow from address");
507 
508         _totalSupply = _totalSupply.sub(value);
509         _balances[account] = _balances[account].sub(value);
510         emit Transfer(account, address(0), value);
511     }
512 
513     /**
514      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
515      *
516      * This is internal function is equivalent to `approve`, and can be used to
517      * e.g. set automatic allowances for certain subsystems, etc.
518      *
519      * Emits an `Approval` event.
520      *
521      * Requirements:
522      *
523      * - `owner` cannot be the zero address.
524      * - `spender` cannot be the zero address.
525      */
526     function _approve(address owner, address spender, uint256 value) internal {
527         require(owner != address(0), "ERC20: approve from the zero address");
528         require(spender != address(0), "ERC20: approve to the zero address");
529 
530         _allowances[owner][spender] = value;
531         emit Approval(owner, spender, value);
532     }
533 
534     /**
535      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
536      * from the caller's allowance.
537      *
538      * See `_burn` and `_approve`.
539      */
540     function _burnFrom(address account, uint256 amount) internal {
541         _burn(account, amount);
542         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
543     }
544 
545 }
546 
547 
548 /**
549  * @dev Collection of functions related to the address type,
550  */
551 library Address {
552     /**
553      * @dev Returns true if `account` is a contract.
554      *
555      * This test is non-exhaustive, and there may be false-negatives: during the
556      * execution of a contract's constructor, its address will be reported as
557      * not containing a contract.
558      *
559      * > It is unsafe to assume that an address for which this function returns
560      * false is an externally-owned account (EOA) and not a contract.
561      */
562     function isContract(address account) internal view returns (bool) {
563         // This method relies in extcodesize, which returns 0 for contracts in
564         // construction, since the code is only stored at the end of the
565         // constructor execution.
566 
567         uint256 size;
568         // solhint-disable-next-line no-inline-assembly
569         assembly { size := extcodesize(account) }
570         return size > 0;
571     }
572 
573     /**
574      * @dev Converts an `address` into `address payable`. Note that this is
575      * simply a type cast: the actual underlying value is not changed.
576      */
577     function toPayable(address account) internal pure returns (address payable) {
578         return address(uint160(account));
579     }
580 }
581 
582 
583 /**
584  * @title SafeERC20
585  * @dev Wrappers around ERC20 operations that throw on failure (when the token
586  * contract returns false). Tokens that return no value (and instead revert or
587  * throw on failure) are also supported, non-reverting calls are assumed to be
588  * successful.
589  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
590  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
591  */
592 library SafeERC20 {
593     using SafeMath for uint256;
594     using Address for address;
595 
596     function safeTransfer(IERC20 token, address to, uint256 value) internal {
597         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
598     }
599 
600     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
601         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
602     }
603 
604     function safeApprove(IERC20 token, address spender, uint256 value) internal {
605         // safeApprove should only be called when setting an initial allowance,
606         // or when resetting it to zero. To increase and decrease it, use
607         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
608         // solhint-disable-next-line max-line-length
609         require((value == 0) || (token.allowance(address(this), spender) == 0),
610             "SafeERC20: approve from non-zero to non-zero allowance"
611         );
612         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
613     }
614 
615     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
616         uint256 newAllowance = token.allowance(address(this), spender).add(value);
617         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
618     }
619 
620     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
621         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
622         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
623     }
624 
625     /**
626      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
627      * on the return value: the return value is optional (but if data is returned, it must not be false).
628      * @param token The token targeted by the call.
629      * @param data The call data (encoded using abi.encode or one of its variants).
630      */
631     function callOptionalReturn(IERC20 token, bytes memory data) private {
632         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
633         // we're implementing it ourselves.
634 
635         // A Solidity high level call has three parts:
636         //  1. The target address is checked to verify it contains contract code
637         //  2. The call itself is made, and success asserted
638         //  3. The return value is decoded, which in turn checks the size of the returned data.
639         // solhint-disable-next-line max-line-length
640         require(address(token).isContract(), "SafeERC20: call to non-contract");
641 
642         // solhint-disable-next-line avoid-low-level-calls
643         (bool success, bytes memory returndata) = address(token).call(data);
644         require(success, "SafeERC20: low-level call failed");
645 
646         if (returndata.length > 0) { // Return data is optional
647             // solhint-disable-next-line max-line-length
648             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
649         }
650     }
651 }
652 
653 
654 /**
655  * @dev Extension of `ERC20` that allows token holders to destroy both their own
656  * tokens and those that they have an allowance for, in a way that can be
657  * recognized off-chain (via event analysis).
658  */
659 contract ERC20Burnable is ERC20 {
660     /**
661      * @dev Destroys `amount` tokens from the caller.
662      *
663      * See `ERC20._burn`.
664      */
665     function burn(uint256 amount) public {
666         _burn(msg.sender, amount);
667     }
668 
669     /**
670      * @dev See `ERC20._burnFrom`.
671      */
672     function burnFrom(address account, uint256 amount) public {
673         _burnFrom(account, amount);
674     }
675 }
676 
677 /**
678  * @dev Contract module which provides a basic access control mechanism, where
679  * there is an account (an owner) that can be granted exclusive access to
680  * specific functions.
681  *
682  * This module is used through inheritance. It will make available the modifier
683  * `onlyOwner`, which can be aplied to your functions to restrict their use to
684  * the owner.
685  */
686 contract Ownable {
687     address private _owner;
688 
689     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
690 
691     /**
692      * @dev Initializes the contract setting the deployer as the initial owner.
693      */
694     constructor () internal {
695         _owner = msg.sender;
696         emit OwnershipTransferred(address(0), _owner);
697     }
698 
699     /**
700      * @dev Returns the address of the current owner.
701      */
702     function owner() public view returns (address) {
703         return _owner;
704     }
705 
706     /**
707      * @dev Throws if called by any account other than the owner.
708      */
709     modifier onlyOwner() {
710         require(isOwner(), "Ownable: caller is not the owner");
711         _;
712     }
713 
714     /**
715      * @dev Returns true if the caller is the current owner.
716      */
717     function isOwner() public view returns (bool) {
718         return msg.sender == _owner;
719     }
720 
721     /**
722      * @dev Leaves the contract without owner. It will not be possible to call
723      * `onlyOwner` functions anymore. Can only be called by the current owner.
724      *
725      * > Note: Renouncing ownership will leave the contract without an owner,
726      * thereby removing any functionality that is only available to the owner.
727      */
728     function renounceOwnership() public onlyOwner {
729         emit OwnershipTransferred(_owner, address(0));
730         _owner = address(0);
731     }
732 
733     /**
734      * @dev Transfers ownership of the contract to a new account (`newOwner`).
735      * Can only be called by the current owner.
736      */
737     function transferOwnership(address newOwner) public onlyOwner {
738         _transferOwnership(newOwner);
739     }
740 
741     /**
742      * @dev Transfers ownership of the contract to a new account (`newOwner`).
743      */
744     function _transferOwnership(address newOwner) internal {
745         require(newOwner != address(0), "Ownable: new owner is the zero address");
746         emit OwnershipTransferred(_owner, newOwner);
747         _owner = newOwner;
748     }
749 }
750 
751 // ----------------------------------------------------------------------------
752 // Contract function to receive approval and execute function in one call
753 //
754 // Borrowed from MiniMeToken
755 // ----------------------------------------------------------------------------
756 contract ApproveAndCallFallBack {
757     function receiveApproval(address from, uint256 tokens, address tokenAddress, bytes memory data) public;
758 }
759 
760 
761 /**
762  * @title TokenVesting
763  * @dev A token holder contract that can release its token balance gradually like a
764  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
765  * owner.
766  */
767 contract TokenVesting is Ownable {
768     // The vesting schedule is time-based (i.e. using block timestamps as opposed to e.g. block numbers), and is
769     // therefore sensitive to timestamp manipulation (which is something miners can do, to a certain degree). Therefore,
770     // it is recommended to avoid using short time durations (less than a minute). Typical vesting schemes, with a
771     // cliff period of a year and a duration of four years, are safe to use.
772     // solhint-disable not-rely-on-time
773 
774     using SafeMath for uint256;
775     using SafeERC20 for IERC20;
776 
777     event TokensReleased(address token, uint256 amount);
778     event TokenVestingRevoked(address token);
779 
780     // beneficiary of tokens after they are released
781     address private _beneficiary;
782 
783     // Durations and timestamps are expressed in UNIX time, the same units as block.timestamp.
784     uint256 private _cliff;
785     uint256 private _start;
786     uint256 private _duration;
787 
788     bool private _revocable;
789 
790     mapping (address => uint256) private _released;
791     mapping (address => bool) private _revoked;
792 
793     /**
794      * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
795      * beneficiary, gradually in a linear fashion until start + duration. By then all
796      * of the balance will have vested.
797      * @param beneficiary address of the beneficiary to whom vested tokens are transferred
798      * @param cliffDuration duration in seconds of the cliff in which tokens will begin to vest
799      * @param start the time (as Unix time) at which point vesting starts
800      * @param duration duration in seconds of the period in which the tokens will vest
801      * @param revocable whether the vesting is revocable or not
802      */
803     constructor (address beneficiary, uint256 start, uint256 cliffDuration, uint256 duration, bool revocable) public {
804         require(beneficiary != address(0), "TokenVesting: beneficiary is the zero address");
805         // solhint-disable-next-line max-line-length
806         require(cliffDuration <= duration, "TokenVesting: cliff is longer than duration");
807         require(duration > 0, "TokenVesting: duration is 0");
808         // solhint-disable-next-line max-line-length
809         require(start.add(duration) > block.timestamp, "TokenVesting: final time is before current time");
810 
811         _beneficiary = beneficiary;
812         _revocable = revocable;
813         _duration = duration;
814         _cliff = start.add(cliffDuration);
815         _start = start;
816     }
817 
818     /**
819      * @return the beneficiary of the tokens.
820      */
821     function beneficiary() public view returns (address) {
822         return _beneficiary;
823     }
824 
825     /**
826      * @return the cliff time of the token vesting.
827      */
828     function cliff() public view returns (uint256) {
829         return _cliff;
830     }
831 
832     /**
833      * @return the start time of the token vesting.
834      */
835     function start() public view returns (uint256) {
836         return _start;
837     }
838 
839     /**
840      * @return the duration of the token vesting.
841      */
842     function duration() public view returns (uint256) {
843         return _duration;
844     }
845 
846     /**
847      * @return true if the vesting is revocable.
848      */
849     function revocable() public view returns (bool) {
850         return _revocable;
851     }
852 
853     /**
854      * @return the amount of the token released.
855      */
856     function released(address token) public view returns (uint256) {
857         return _released[token];
858     }
859 
860     /**
861      * @return true if the token is revoked.
862      */
863     function revoked(address token) public view returns (bool) {
864         return _revoked[token];
865     }
866 
867     /**
868      * @notice Transfers vested tokens to beneficiary.
869      * @param token ERC20 token which is being vested
870      */
871     function release(IERC20 token) public {
872         uint256 unreleased = _releasableAmount(token);
873 
874         require(unreleased > 0, "TokenVesting: no tokens are due");
875 
876         _released[address(token)] = _released[address(token)].add(unreleased);
877 
878         token.safeTransfer(_beneficiary, unreleased);
879 
880         emit TokensReleased(address(token), unreleased);
881     }
882 
883     /**
884      * @notice Allows the owner to revoke the vesting. Tokens already vested
885      * remain in the contract, the rest are returned to the owner.
886      * @param token ERC20 token which is being vested
887      */
888     function revoke(IERC20 token) public onlyOwner {
889         require(_revocable, "TokenVesting: cannot revoke");
890         require(!_revoked[address(token)], "TokenVesting: token already revoked");
891 
892         uint256 balance = token.balanceOf(address(this));
893 
894         uint256 unreleased = _releasableAmount(token);
895         uint256 refund = balance.sub(unreleased);
896 
897         _revoked[address(token)] = true;
898 
899         token.safeTransfer(owner(), refund);
900 
901         emit TokenVestingRevoked(address(token));
902     }
903 
904 
905     /**
906      * @dev Calculates the amount that has already vested but hasn't been released yet.
907      * @param token ERC20 token which is being vested
908      */
909     function _releasableAmount(IERC20 token) private view returns (uint256) {
910         return _vestedAmount(token).sub(_released[address(token)]);
911     }
912 
913     /**
914      * @dev Calculates the amount that has already vested.
915      * @param token ERC20 token which is being vested
916      */
917     function _vestedAmount(IERC20 token) private view returns (uint256) {
918         uint256 currentBalance = token.balanceOf(address(this));
919         uint256 totalBalance = currentBalance.add(_released[address(token)]);
920 
921         if (block.timestamp < _cliff) {
922             return 0;
923         } else if (block.timestamp >= _start.add(_duration) || _revoked[address(token)]) {
924             return totalBalance;
925         } else {
926             return totalBalance.mul(block.timestamp.sub(_start)).div(_duration);
927         }
928     }
929 }
930 
931 
932 // ----------------------------------------------------------------------------
933 // ERC20 Token, with the addition of symbol, name and decimals and assisted
934 // token transfers
935 // ----------------------------------------------------------------------------
936 contract NexxoToken is Ownable, ERC20, Pausable, ERC20Burnable {
937 
938     using SafeMath for uint256;
939     string public symbol;
940     string public  name;
941     uint8 public decimals;
942     uint public _totalSupply;
943     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
944     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
945     address payable fundsWallet;           // Where should the raised ETH go?
946 
947     mapping(address => uint) balances;
948     mapping(address => mapping(address => uint)) allowed;
949 
950 
951     // ------------------------------------------------------------------------
952     // Constructor
953     // ------------------------------------------------------------------------
954     constructor() public {
955         symbol = "NEXXO";
956         name = "Nexxo Tokens";
957         decimals = 18;
958         _totalSupply = 100000000000000000000000000000;
959         balances[msg.sender] = _totalSupply;
960         unitsOneEthCanBuy = 287780;                                  // Set the price of your token for the ICO (CHANGE THIS)
961         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
962         emit Transfer(address(0), msg.sender, _totalSupply);
963     }
964 
965    // ------------------------------------------------------------------------
966     // Don't accept ETH
967     // ------------------------------------------------------------------------
968     function () external payable {
969         totalEthInWei = totalEthInWei + msg.value;
970         uint256 amount = msg.value * unitsOneEthCanBuy;
971         require(balances[fundsWallet] >= amount, "NexxoToken : amount more than balance");
972 
973         balances[fundsWallet] = balances[fundsWallet].sub(amount);
974         balances[msg.sender] = balances[msg.sender].add(amount);
975 
976         emit Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
977 
978         //Transfer ether to fundsWallet
979         fundsWallet.transfer(msg.value); 
980     }
981 
982     // ------------------------------------------------------------------------
983     // Total supply
984     // ------------------------------------------------------------------------
985     function totalSupply() public view returns (uint) {
986         return _totalSupply  - balances[address(0)];
987     }
988 
989 
990     // ------------------------------------------------------------------------
991     // Get the token balance for account tokenOwner
992     // ------------------------------------------------------------------------
993     function balanceOf(address tokenOwner) public view returns (uint ownerBalance) {
994         return balances[tokenOwner];
995     }
996 
997 
998     // ------------------------------------------------------------------------
999     // Transfer the balance from token owner's account to to account
1000     // - Owner's account must have sufficient balance to transfer
1001     // - 0 value transfers are allowed
1002     // ------------------------------------------------------------------------
1003     function transfer(address to, uint tokens) public returns (bool success) {
1004         balances[msg.sender] = balances[msg.sender].sub(tokens);
1005         balances[to] = balances[to].add(tokens);
1006         emit Transfer(msg.sender, to, tokens);
1007         return true;
1008     }
1009 
1010 
1011     // ------------------------------------------------------------------------
1012     // Token owner can approve for spender to transferFrom(...) tokens
1013     // from the token owner's account
1014     //
1015     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
1016     // recommends that there are no checks for the approval double-spend attack
1017     // as this should be implemented in user interfaces 
1018     // ------------------------------------------------------------------------
1019     function approve(address spender, uint tokens) public returns (bool success) {
1020         allowed[msg.sender][spender] = tokens;
1021         emit Approval(msg.sender, spender, tokens);
1022         return true;
1023     }
1024 
1025 
1026     // ------------------------------------------------------------------------
1027     // Transfer tokens from the from account to the to account
1028     // 
1029     // The calling account must already have sufficient tokens approve(...)-d
1030     // for spending from the from account and
1031     // - From account must have sufficient balance to transfer
1032     // - Spender must have sufficient allowance to transfer
1033     // - 0 value transfers are allowed
1034     // ------------------------------------------------------------------------
1035     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
1036         balances[from] = balances[from].sub(tokens);
1037         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
1038         balances[to] = balances[to].add(tokens);
1039         emit Transfer(from, to, tokens);
1040         return true;
1041     }
1042 
1043 
1044     // ------------------------------------------------------------------------
1045     // Returns the amount of tokens approved by the owner that can be
1046     // transferred to the spender's account
1047     // ------------------------------------------------------------------------
1048     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
1049         return allowed[tokenOwner][spender];
1050     }
1051 
1052 
1053     // ------------------------------------------------------------------------
1054     // Token owner can approve for spender to transferFrom(...) tokens
1055     // from the token owner's account. The spender contract function
1056     // receiveApproval(...) is then executed
1057     // ------------------------------------------------------------------------
1058     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
1059         allowed[msg.sender][spender] = tokens;
1060         emit Approval(msg.sender, spender, tokens);
1061         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
1062         return true;
1063     }
1064 
1065     // ------------------------------------------------------------------------
1066     // Token Owner can allow burning of the token
1067     // ------------------------------------------------------------------------
1068     function burn(uint256 amount) public onlyOwner {
1069         burn(amount);
1070     }
1071 
1072 }