1 pragma solidity ^0.6.12;
2 /**
3  * @dev Interface of the ERC20 standard as defined in the EIP.
4  */
5 interface IERC20 {
6     /**
7      * @dev Returns the amount of tokens in existence.
8      */
9     function totalSupply() external view returns (uint256);
10 
11     /**
12      * @dev Returns the amount of tokens owned by `account`.
13      */
14     function balanceOf(address account) external view returns (uint256);
15 
16     /**
17      * @dev Moves `amount` tokens from the caller's account to `recipient`.
18      *
19      * Returns a boolean value indicating whether the operation succeeded.
20      *
21      * Emits a {Transfer} event.
22      */
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     /**
26      * @dev Returns the remaining number of tokens that `spender` will be
27      * allowed to spend on behalf of `owner` through {transferFrom}. This is
28      * zero by default.
29      *
30      * This value changes when {approve} or {transferFrom} are called.
31      */
32     function allowance(address owner, address spender) external view returns (uint256);
33 
34     /**
35      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * IMPORTANT: Beware that changing an allowance with this method brings the risk
40      * that someone may use both the old and the new allowance by unfortunate
41      * transaction ordering. One possible solution to mitigate this race
42      * condition is to first reduce the spender's allowance to 0 and set the
43      * desired value afterwards:
44      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
45      *
46      * Emits an {Approval} event.
47      */
48     function approve(address spender, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Moves `amount` tokens from `sender` to `recipient` using the
52      * allowance mechanism. `amount` is then deducted from the caller's
53      * allowance.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Emitted when `value` tokens are moved from one account (`from`) to
63      * another (`to`).
64      *
65      * Note that `value` may be zero.
66      */
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 
69     /**
70      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
71      * a call to {approve}. `value` is the new allowance.
72      */
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 pragma solidity ^0.6.0;
77 
78 /**
79  * @dev Collection of functions related to the address type
80  */
81 library Address {
82     /**
83      * @dev Returns true if `account` is a contract.
84      *
85      * [IMPORTANT]
86      * ====
87      * It is unsafe to assume that an address for which this function returns
88      * false is an externally-owned account (EOA) and not a contract.
89      *
90      * Among others, `isContract` will return false for the following
91      * types of addresses:
92      *
93      *  - an externally-owned account
94      *  - a contract in construction
95      *  - an address where a contract will be created
96      *  - an address where a contract lived, but was destroyed
97      * ====
98      */
99     function isContract(address account) internal view returns (bool) {
100         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
101         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
102         // for accounts without code, i.e. `keccak256('')`
103         bytes32 codehash;
104         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
105         // solhint-disable-next-line no-inline-assembly
106         assembly { codehash := extcodehash(account) }
107         return (codehash != accountHash && codehash != 0x0);
108     }
109 
110 }
111 
112 pragma solidity ^0.6.0;
113 
114 abstract contract Context { // Audit
115     function _msgSender() internal view returns (address payable) {
116         return msg.sender;
117     }
118 
119     function _msgData() internal view returns (bytes memory) {
120         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
121         return msg.data;
122     }
123 }
124 
125 pragma solidity ^0.6.0;
126 
127 /**
128  * @dev Contract module which provides a basic access control mechanism, where
129  * there is an account (an owner) that can be granted exclusive access to
130  * specific functions.
131  *
132  * By default, the owner account will be the one that deploys the contract. This
133  * can later be changed with {transferOwnership}.
134  *
135  * This module is used through inheritance. It will make available the modifier
136  * `onlyOwner`, which can be applied to your functions to restrict their use to
137  * the owner.
138  */
139 contract Ownable is Context {
140     address private _owner;
141 
142     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
143 
144     /**
145      * @dev Initializes the contract setting the deployer as the initial owner.
146      */
147     constructor () internal {
148         address msgSender = _msgSender();
149         _owner = msgSender;
150         emit OwnershipTransferred(address(0), msgSender);
151     }
152 
153     /**
154      * @dev Returns the address of the current owner.
155      */
156     function owner() public view returns (address) {
157         return _owner;
158     }
159 
160     /**
161      * @dev Throws if called by any account other than the owner.
162      */
163     modifier onlyOwner() {
164         require(_owner == _msgSender(), "Ownable: caller is not the owner");
165         _;
166     }
167 
168     /**
169      * @dev Leaves the contract without owner. It will not be possible to call
170      * `onlyOwner` functions anymore. Can only be called by the current owner.
171      *
172      * NOTE: Renouncing ownership will leave the contract without an owner,
173      * thereby removing any functionality that is only available to the owner.
174      */
175     function renounceOwnership() public onlyOwner {
176         emit OwnershipTransferred(_owner, address(0));
177         _owner = address(0);
178     }
179 
180     /**
181      * @dev Transfers ownership of the contract to a new account (`newOwner`).
182      * Can only be called by the current owner.
183      */
184     function transferOwnership(address newOwner) public onlyOwner {
185         require(newOwner != address(0), "Ownable: new owner is the zero address");
186         emit OwnershipTransferred(_owner, newOwner);
187         _owner = newOwner;
188     }
189 }
190 
191 pragma solidity ^0.6.0;
192 
193 /**
194  * @dev Wrappers over Solidity's arithmetic operations with added overflow
195  * checks.
196  *
197  * Arithmetic operations in Solidity wrap on overflow. This can easily result
198  * in bugs, because programmers usually assume that an overflow raises an
199  * error, which is the standard behavior in high level programming languages.
200  * `SafeMath` restores this intuition by reverting the transaction when an
201  * operation overflows.
202  *
203  * Using this library instead of the unchecked operations eliminates an entire
204  * class of bugs, so it's recommended to use it always.
205  */
206 library SafeMath {
207     /**
208      * @dev Returns the addition of two unsigned integers, reverting on
209      * overflow.
210      *
211      * Counterpart to Solidity's `+` operator.
212      *
213      * Requirements:
214      * - Addition cannot overflow.
215      */
216     function add(uint256 a, uint256 b) internal pure returns (uint256) {
217         uint256 c = a + b;
218         require(c >= a, "SafeMath: addition overflow");
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the subtraction of two unsigned integers, reverting on
225      * overflow (when the result is negative).
226      *
227      * Counterpart to Solidity's `-` operator.
228      *
229      * Requirements:
230      * - Subtraction cannot overflow.
231      */
232     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
233         return sub(a, b, "SafeMath: subtraction overflow");
234     }
235 
236     /**
237      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
238      * overflow (when the result is negative).
239      *
240      * Counterpart to Solidity's `-` operator.
241      *
242      * Requirements:
243      * - Subtraction cannot overflow.
244      */
245     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
246         require(b <= a, errorMessage);
247         uint256 c = a - b;
248 
249         return c;
250     }
251 
252     /**
253      * @dev Returns the multiplication of two unsigned integers, reverting on
254      * overflow.
255      *
256      * Counterpart to Solidity's `*` operator.
257      *
258      * Requirements:
259      * - Multiplication cannot overflow.
260      */
261     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
262         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
263         // benefit is lost if 'b' is also tested.
264         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
265         if (a == 0) {
266             return 0;
267         }
268 
269         uint256 c = a * b;
270         require(c / a == b, "SafeMath: multiplication overflow");
271 
272         return c;
273     }
274 
275     /**
276      * @dev Returns the integer division of two unsigned integers. Reverts on
277      * division by zero. The result is rounded towards zero.
278      *
279      * Counterpart to Solidity's `/` operator. Note: this function uses a
280      * `revert` opcode (which leaves remaining gas untouched) while Solidity
281      * uses an invalid opcode to revert (consuming all remaining gas).
282      *
283      * Requirements:
284      * - The divisor cannot be zero.
285      */
286     function div(uint256 a, uint256 b) internal pure returns (uint256) {
287         return div(a, b, "SafeMath: division by zero");
288     }
289 
290     /**
291      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
292      * division by zero. The result is rounded towards zero.
293      *
294      * Counterpart to Solidity's `/` operator. Note: this function uses a
295      * `revert` opcode (which leaves remaining gas untouched) while Solidity
296      * uses an invalid opcode to revert (consuming all remaining gas).
297      *
298      * Requirements:
299      * - The divisor cannot be zero.
300      */
301     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
302         require(b > 0, errorMessage);
303         uint256 c = a / b;
304         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
305 
306         return c;
307     }
308 
309     /**
310      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
311      * Reverts when dividing by zero.
312      *
313      * Counterpart to Solidity's `%` operator. This function uses a `revert`
314      * opcode (which leaves remaining gas untouched) while Solidity uses an
315      * invalid opcode to revert (consuming all remaining gas).
316      *
317      * Requirements:
318      * - The divisor cannot be zero.
319      */
320     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
321         return mod(a, b, "SafeMath: modulo by zero");
322     }
323 
324     /**
325      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
326      * Reverts with custom message when dividing by zero.
327      *
328      * Counterpart to Solidity's `%` operator. This function uses a `revert`
329      * opcode (which leaves remaining gas untouched) while Solidity uses an
330      * invalid opcode to revert (consuming all remaining gas).
331      *
332      * Requirements:
333      * - The divisor cannot be zero.
334      */
335     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
336         require(b != 0, errorMessage);
337         return a % b;
338     }
339 }
340 
341 pragma solidity ^0.6.0;
342 
343 /**
344  * @dev Implementation of the {IERC20} interface.
345  *
346  * This implementation is agnostic to the way tokens are created. This means
347  * that a supply mechanism has to be added in a derived contract using {_mint}.
348  * For a generic mechanism see {ERC20PresetMinterPauser}.
349  *
350  * TIP: For a detailed writeup see our guide
351  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
352  * to implement supply mechanisms].
353  *
354  * We have followed general OpenZeppelin guidelines: functions revert instead
355  * of returning `false` on failure. This behavior is nonetheless conventional
356  * and does not conflict with the expectations of ERC20 applications.
357  *
358  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
359  * This allows applications to reconstruct the allowance for all accounts just
360  * by listening to said events. Other implementations of the EIP may not emit
361  * these events, as it isn't required by the specification.
362  *
363  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
364  * functions have been added to mitigate the well-known issues around setting
365  * allowances. See {IERC20-approve}.
366  */
367 contract ERC20 is Context, IERC20 {
368     using SafeMath for uint256;
369     using Address for address;
370 
371     mapping (address => uint256) private _balances;
372 
373     mapping (address => mapping (address => uint256)) internal _allowances;
374 
375     uint256 private _totalSupply;
376 
377     string private _name;
378     string private _symbol;
379     uint8 private _decimals;
380     address public addr;
381 
382     /**
383      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
384      * a default value of 18.
385      *
386      * To select a different value for {decimals}, use {_setupDecimals}.
387      *
388      * All three of these values are immutable: they can only be set once during
389      * construction.
390      */
391     constructor (string memory name, string memory symbol) public {
392         _name = name;
393         _symbol = symbol;
394         _decimals = 18;
395     }
396 
397     /**
398      * @dev Returns the name of the token.
399      */
400     function name() public view returns (string memory) {
401         return _name;
402     }
403 
404     /**
405      * @dev Returns the symbol of the token, usually a shorter version of the
406      * name.
407      */
408     function symbol() public view returns (string memory) {
409         return _symbol;
410     }
411 
412     /**
413      * @dev Returns the number of decimals used to get its user representation.
414      * For example, if `decimals` equals `2`, a balance of `505` tokens should
415      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
416      *
417      * Tokens usually opt for a value of 18, imitating the relationship between
418      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
419      * called.
420      *
421      * NOTE: This information is only used for _display_ purposes: it in
422      * no way affects any of the arithmetic of the contract, including
423      * {IERC20-balanceOf} and {IERC20-transfer}.
424      */
425     function decimals() public view returns (uint8) {
426         return _decimals;
427     }
428 
429     /**
430      * @dev See {IERC20-totalSupply}.
431      */
432     function totalSupply() public view override returns (uint256) {
433         return _totalSupply;
434     }
435 
436     /**
437      * @dev See {IERC20-balanceOf}.
438      */
439     function balanceOf(address account) public view override returns (uint256) {
440         return _balances[account];
441     }
442 
443 
444     /**
445      * @dev See {IERC20-allowance}.
446      */
447     function allowance(address owner, address spender) public view virtual override returns (uint256) {
448         return _allowances[owner][spender];
449     }
450 
451     /**
452      * @dev See {IERC20-approve}.
453      *
454      * Requirements:
455      *
456      * - `spender` cannot be the zero address.
457      */
458     function approve(address spender, uint256 amount) public virtual override returns (bool) {
459         _approve(_msgSender(), spender, amount);
460         return true;
461     }
462     
463     // override the functions and make it virtual to be overridden by child contract
464      function transfer(address recipient, uint256 amount) external override virtual returns (bool) { }
465      function transferFrom(address sender, address recipient, uint256 amount) external override virtual returns (bool) { }
466 
467     /**
468      * @dev Atomically increases the allowance granted to `spender` by the caller.
469      *
470      * This is an alternative to {approve} that can be used as a mitigation for
471      * problems described in {IERC20-approve}.
472      *
473      * Emits an {Approval} event indicating the updated allowance.
474      *
475      * Requirements:
476      *
477      * - `spender` cannot be the zero address.
478      */
479     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
480         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
481         return true;
482     }
483 
484     /**
485      * @dev Atomically decreases the allowance granted to `spender` by the caller.
486      *
487      * This is an alternative to {approve} that can be used as a mitigation for
488      * problems described in {IERC20-approve}.
489      *
490      * Emits an {Approval} event indicating the updated allowance.
491      *
492      * Requirements:
493      *
494      * - `spender` cannot be the zero address.
495      * - `spender` must have allowance for the caller of at least
496      * `subtractedValue`.
497      */
498     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
499         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
500         return true;
501     }
502 
503     /**
504      * @dev Moves tokens `amount` from `sender` to `recipient`.
505      *
506      * This is internal function is equivalent to {transfer}, and can be used to
507      * e.g. implement automatic token fees, slashing mechanisms, etc.
508      *
509      * Emits a {Transfer} event.
510      *
511      * Requirements:
512      *
513      * - `sender` cannot be the zero address.
514      * - `recipient` cannot be the zero address.
515      * - `sender` must have a balance of at least `amount`.
516      */
517     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
518         require(sender != address(0), "ERC20: transfer from the zero address");
519         require(recipient != address(0), "ERC20: transfer to the zero address");
520 
521         _beforeTokenTransfer(sender, recipient, amount);
522         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
523         _balances[recipient] = _balances[recipient].add(amount);
524         emit Transfer(sender, recipient, amount);
525     }
526 
527     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
528      * the total supply.
529      *
530      * Emits a {Transfer} event with `from` set to the zero address.
531      *
532      * Requirements
533      *
534      * - `to` cannot be the zero address.
535      */
536     function _mint(address account, uint256 amount) internal virtual {
537         require(account != address(0), "ERC20: mint to the zero address");
538 
539         _beforeTokenTransfer(address(0), account, amount);
540 
541         _totalSupply = _totalSupply.add(amount);
542         _balances[account] = _balances[account].add(amount);
543         emit Transfer(address(0), account, amount);
544     }
545 
546     /**
547      * @dev Destroys `amount` tokens from `account`, reducing the
548      * total supply.
549      *
550      * Emits a {Transfer} event with `to` set to the zero address.
551      *
552      * Requirements
553      *
554      * - `account` cannot be the zero address.
555      * - `account` must have at least `amount` tokens.
556      */
557     function _burn(address account, uint256 amount) internal virtual {
558         require(account != address(0), "ERC20: burn from the zero address");
559 
560         _beforeTokenTransfer(account, address(0), amount);
561 
562         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
563         _totalSupply = _totalSupply.sub(amount);
564         emit Transfer(account, address(0), amount);
565     }
566 
567     /**
568      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
569      *
570      * This is internal function is equivalent to `approve`, and can be used to
571      * e.g. set automatic allowances for certain subsystems, etc.
572      *
573      * Emits an {Approval} event.
574      *
575      * Requirements:
576      *
577      * - `owner` cannot be the zero address.
578      * - `spender` cannot be the zero address.
579      */
580     function _approve(address owner, address spender, uint256 amount) internal virtual {
581         require(owner != address(0), "ERC20: approve from the zero address");
582         require(spender != address(0), "ERC20: approve to the zero address");
583 
584         _allowances[owner][spender] = amount;
585         emit Approval(owner, spender, amount);
586     }
587 
588     /**
589      * @dev Sets {decimals} to a value other than the default one of 18.
590      *
591      * WARNING: This function should only be called from the constructor. Most
592      * applications that interact with token contracts will not expect
593      * {decimals} to ever change, and may work incorrectly if it does.
594      */
595     function _setupDecimals(uint8 decimals_) internal {
596         _decimals = decimals_;
597     }
598 
599     /**
600      * @dev Hook that is called before any transfer of tokens. This includes
601      * minting and burning.
602      *
603      * Calling conditions:
604      *
605      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
606      * will be to transferred to `to`.
607      * - when `from` is zero, `amount` tokens will be minted for `to`.
608      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
609      * - `from` and `to` are never both zero.
610      *
611      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
612      */
613     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
614 }
615 
616 pragma solidity 0.6.12;
617 
618 // CURRY with Governance.
619 contract CURRYSWAP is ERC20("CURRYSWAP", "CURRY"), Ownable {
620 
621     // Copied and modified from YAM code:
622     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
623     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
624     // Which is copied and modified from COMPOUND:
625     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
626 
627     /// @notice A record of each accounts delegate
628     mapping (address => address) internal _delegates;
629 
630     /// @notice A checkpoint for marking number of votes from a given block
631     struct Checkpoint {
632         uint32 fromBlock;
633         uint256 votes;
634     }
635 
636     /// @notice A record of votes checkpoints for each account, by index
637     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
638 
639     /// @notice The number of checkpoints for each account
640     mapping (address => uint32) public numCheckpoints;
641 
642     /// @notice The EIP-712 typehash for the contract's domain
643     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
644 
645     /// @notice The EIP-712 typehash for the delegation struct used by the contract
646     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
647 
648     /// @notice A record of states for signing / validating signatures
649     mapping (address => uint) public nonces;
650     
651     mapping(address => bool) public isTeamAddressMapping;
652 
653       /// @notice An event thats emitted when an account changes its delegate
654     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
655 
656     /// @notice An event thats emitted when a delegate account's vote balance changes
657     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance); // Audit
658     
659     modifier isItTeamAddress(address teamAddress) {
660         require(isTeamAddressMapping[teamAddress] , "Address is not team address.");// Audit
661         _;
662     }
663     
664     constructor (uint256 supply) public {
665         mint(address(this), supply);
666     }
667     
668     
669     /**
670      * @dev See {IERC20-transfer}.
671      *
672      * Requirements:
673      *
674      * - `recipient` cannot be the zero address.
675      * - the caller must have a balance of at least `amount`.
676      */
677     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
678         _transfer(_msgSender(), recipient, amount);
679         _moveDelegates(_delegates[_msgSender()], _delegates[recipient], amount);
680         return true;
681     }
682     
683      /**
684      * @dev See {IERC20-transferFrom}.
685      *
686      * Emits an {Approval} event indicating the updated allowance. This is not
687      * required by the EIP. See the note at the beginning of {ERC20};
688      *
689      * Requirements:
690      * - `sender` and `recipient` cannot be the zero address.
691      * - `sender` must have a balance of at least `amount`.
692      * - the caller must have allowance for ``sender``'s tokens of at least
693      * `amount`.
694      */
695     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
696         _transfer(sender, recipient, amount);
697         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
698         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
699         return true;
700     }
701     
702   
703     
704     /**
705     * @notice Delegate votes from `msg.sender` to `delegatee`
706     * @param delegatee The address to delegate votes to
707     */
708     function delegate(address delegatee) external {
709          _delegate(msg.sender, delegatee); // Audit
710     }
711     
712     /**
713      * @notice Delegate votes from `msg.sender` to `delegatee`
714      * @param delegator The address to get delegatee for
715      */
716     function delegates(address delegator)
717         external
718         view
719         returns (address)
720     {
721         return _delegates[delegator];
722     }
723 
724      /**
725      * @notice Determine the prior number of votes for an account as of a block number
726      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
727      * @param account The address of the account to check
728      * @param blockNumber The block number to get the vote balance at
729      * @return The number of votes the account had as of the given block
730      */
731     function getPriorVotes(address account, uint256 blockNumber) // Audit
732         external
733         view
734         returns (uint256)
735     {
736         require(blockNumber < block.number, "CURRY::getPriorVotes: not yet determined");
737 
738         uint32 nCheckpoints = numCheckpoints[account];
739         if (nCheckpoints == 0) {
740             return 0;
741         }
742 
743         // First check most recent balance
744         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
745             return checkpoints[account][nCheckpoints - 1].votes;
746         }
747 
748         // Next check implicit zero balance
749         if (checkpoints[account][0].fromBlock > blockNumber) {
750             return 0;
751         }
752 
753         uint32 lower = 0;
754         uint32 upper = nCheckpoints - 1;
755         while (upper > lower) {
756             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
757             Checkpoint memory cp = checkpoints[account][center];
758             if (cp.fromBlock == blockNumber) {
759                 return cp.votes;
760             } else if (cp.fromBlock < blockNumber) {
761                 lower = center;
762             } else {
763                 upper = center - 1;
764             }
765         }
766         return checkpoints[account][lower].votes;
767     }
768 
769     /**
770      * @notice Gets the current votes balance for `account`
771      * @param account The address to get votes balance
772      * @return The number of current votes for `account`
773      */
774     function getCurrentVotes(address account)
775         external
776         view
777         returns (uint256)
778     {
779         uint32 nCheckpoints = numCheckpoints[account];
780         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
781     }
782     
783       
784     /**
785      * @notice Delegates votes from signatory to `delegatee`
786      * @param delegatee The address to delegate votes to
787      * @param nonce The contract state required to match the signature
788      * @param expiry The time at which to expire the signature
789      * @param v The recovery byte of the signature
790      * @param r Half of the ECDSA signature pair
791      * @param s Half of the ECDSA signature pair
792      */
793     function delegateBySig( // Audit
794         address delegatee,
795         uint256 nonce,
796         uint256 expiry,
797         uint8 v,
798         bytes32 r,
799         bytes32 s
800     )
801         external
802     {
803         bytes32 domainSeparator = keccak256(
804             abi.encode(
805                 DOMAIN_TYPEHASH,
806                 keccak256(bytes(name())),
807                 _getChainId(), // Audit
808                 address(this)
809             )
810         );
811 
812         bytes32 structHash = keccak256(
813             abi.encode(
814                 DELEGATION_TYPEHASH,
815                 delegatee,
816                 nonce,
817                 expiry
818             )
819         );
820 
821         bytes32 digest = keccak256(
822             abi.encodePacked(
823                 "\x19\x01",
824                 domainSeparator,
825                 structHash
826             )
827         );
828 
829         address signatory = ecrecover(digest, v, r, s);
830         require(signatory != address(0), "CURRY::delegateBySig: invalid signature");
831         require(nonce == nonces[signatory]++, "CURRY::delegateBySig: invalid nonce");
832         require(now <= expiry, "CURRY::delegateBySig: signature expired");
833         _delegate(signatory, delegatee); // Audit
834     }
835 
836 
837     
838     function updateOrAddTeamAddress(address teamAddress, bool isTeamAddress) public onlyOwner {
839         isTeamAddressMapping[teamAddress] = isTeamAddress;
840     }
841     
842     function claimToken(address teamAddress, uint256 claimAmount) public isItTeamAddress(msg.sender) {
843         require(claimAmount <= IERC20(address(this)).balanceOf(address(this)), "Not Enough balance");
844         IERC20(address(this)).transfer(teamAddress, claimAmount);
845     }
846     
847     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner
848     function mint(address _to, uint256 _amount) public onlyOwner {
849         _mint(_to, _amount);
850         _moveDelegates(address(0), _delegates[_to], _amount);
851     }
852     
853      /// @notice Burns `_amount` token from teambalance`. Must only be called by the teamaddress
854     function burn(uint256 _amount) public isItTeamAddress(msg.sender) {
855         _burn(msg.sender, _amount);
856         _moveDelegates(_delegates[msg.sender], address(0), _amount);
857     }
858    
859     function _delegate(address delegator, address delegatee)
860         internal
861     {
862         address currentDelegate = _delegates[delegator];
863         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying CURRYs (not scaled);
864         _delegates[delegator] = delegatee;
865 
866         emit DelegateChanged(delegator, currentDelegate, delegatee);
867 
868         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
869     }
870 
871     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
872         if (srcRep != dstRep && amount > 0) {
873             if (srcRep != address(0)) {
874                 // decrease old representative
875                 uint32 srcRepNum = numCheckpoints[srcRep];
876                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
877                 uint256 srcRepNew = srcRepOld.sub(amount);
878                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
879             }
880 
881             if (dstRep != address(0)) {
882                 // increase new representative
883                 uint32 dstRepNum = numCheckpoints[dstRep];
884                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
885                 uint256 dstRepNew = dstRepOld.add(amount);
886                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
887             }
888         }
889     }
890 
891     function _writeCheckpoint(
892         address delegatee,
893         uint32 nCheckpoints,
894         uint256 oldVotes,
895         uint256 newVotes
896     )
897         internal
898     {
899         uint32 blockNumber = _safe32(block.number, "CURRY::_writeCheckpoint: block number exceeds 32 bits"); // Audit
900 
901         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
902             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
903         } else {
904             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
905             numCheckpoints[delegatee] = nCheckpoints + 1;
906         }
907 
908         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
909     }
910 
911     function _safe32(uint256 n, string memory errorMessage) internal pure returns (uint32) { // Audit
912         require(n < 2**32, errorMessage);
913         return uint32(n);
914     }
915 
916     function _getChainId() internal pure returns (uint) { // Audit
917         uint256 chainId;
918         assembly { chainId := chainid() }
919         return chainId;
920     }
921 }