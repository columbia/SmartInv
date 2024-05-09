1 pragma solidity ^0.5.0;
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
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     /**
47      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
48      * overflow (when the result is negative).
49      *
50      * Counterpart to Solidity's `-` operator.
51      *
52      * Requirements:
53      * - Subtraction cannot overflow.
54      *
55      * _Available since v2.4.0._
56      */
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the multiplication of two unsigned integers, reverting on
66      * overflow.
67      *
68      * Counterpart to Solidity's `*` operator.
69      *
70      * Requirements:
71      * - Multiplication cannot overflow.
72      */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the integer division of two unsigned integers. Reverts on
89      * division by zero. The result is rounded towards zero.
90      *
91      * Counterpart to Solidity's `/` operator. Note: this function uses a
92      * `revert` opcode (which leaves remaining gas untouched) while Solidity
93      * uses an invalid opcode to revert (consuming all remaining gas).
94      *
95      * Requirements:
96      * - The divisor cannot be zero.
97      */
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         return div(a, b, "SafeMath: division by zero");
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      * - The divisor cannot be zero.
112      *
113      * _Available since v2.4.0._
114      */
115     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         // Solidity only automatically asserts when dividing by 0
117         require(b > 0, errorMessage);
118         uint256 c = a / b;
119         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
126      * Reverts when dividing by zero.
127      *
128      * Counterpart to Solidity's `%` operator. This function uses a `revert`
129      * opcode (which leaves remaining gas untouched) while Solidity uses an
130      * invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      * - The divisor cannot be zero.
134      */
135     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
136         return mod(a, b, "SafeMath: modulo by zero");
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
141      * Reverts with custom message when dividing by zero.
142      *
143      * Counterpart to Solidity's `%` operator. This function uses a `revert`
144      * opcode (which leaves remaining gas untouched) while Solidity uses an
145      * invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      * - The divisor cannot be zero.
149      *
150      * _Available since v2.4.0._
151      */
152     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
153         require(b != 0, errorMessage);
154         return a % b;
155     }
156 }
157 
158 /*
159  * @dev Provides information about the current execution context, including the
160  * sender of the transaction and its data. While these are generally available
161  * via msg.sender and msg.data, they should not be accessed in such a direct
162  * manner, since when dealing with GSN meta-transactions the account sending and
163  * paying for execution may not be the actual sender (as far as an application
164  * is concerned).
165  *
166  * This contract is only required for intermediate, library-like contracts.
167  */
168 contract Context {
169     // Empty internal constructor, to prevent people from mistakenly deploying
170     // an instance of this contract, which should be used via inheritance.
171     constructor () internal { }
172     // solhint-disable-previous-line no-empty-blocks
173 
174     function _msgSender() internal view returns (address payable) {
175         return msg.sender;
176     }
177 
178     function _msgData() internal view returns (bytes memory) {
179         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
180         return msg.data;
181     }
182 }
183 
184 /**
185  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
186  * the optional functions; to access them see {ERC20Detailed}.
187  */
188 interface IERC20 {
189     /**
190      * @dev Returns the amount of tokens in existence.
191      */
192     function totalSupply() external view returns (uint256);
193 
194     /**
195      * @dev Returns the amount of tokens owned by `account`.
196      */
197     function balanceOf(address account) external view returns (uint256);
198 
199     /**
200      * @dev Moves `amount` tokens from the caller's account to `recipient`.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * Emits a {Transfer} event.
205      */
206     function transfer(address recipient, uint256 amount) external returns (bool);
207 
208     /**
209      * @dev Returns the remaining number of tokens that `spender` will be
210      * allowed to spend on behalf of `owner` through {transferFrom}. This is
211      * zero by default.
212      *
213      * This value changes when {approve} or {transferFrom} are called.
214      */
215     function allowance(address owner, address spender) external view returns (uint256);
216 
217     /**
218      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * IMPORTANT: Beware that changing an allowance with this method brings the risk
223      * that someone may use both the old and the new allowance by unfortunate
224      * transaction ordering. One possible solution to mitigate this race
225      * condition is to first reduce the spender's allowance to 0 and set the
226      * desired value afterwards:
227      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228      *
229      * Emits an {Approval} event.
230      */
231     function approve(address spender, uint256 amount) external returns (bool);
232 
233     /**
234      * @dev Moves `amount` tokens from `sender` to `recipient` using the
235      * allowance mechanism. `amount` is then deducted from the caller's
236      * allowance.
237      *
238      * Returns a boolean value indicating whether the operation succeeded.
239      *
240      * Emits a {Transfer} event.
241      */
242     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
243 
244     /**
245      * @dev Emitted when `value` tokens are moved from one account (`from`) to
246      * another (`to`).
247      *
248      * Note that `value` may be zero.
249      */
250     event Transfer(address indexed from, address indexed to, uint256 value);
251 
252     /**
253      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
254      * a call to {approve}. `value` is the new allowance.
255      */
256     event Approval(address indexed owner, address indexed spender, uint256 value);
257 }
258 
259 /**
260  * @dev Implementation of the {IERC20} interface.
261  *
262  * This implementation is agnostic to the way tokens are created. This means
263  * that a supply mechanism has to be added in a derived contract using {_mint}.
264  * For a generic mechanism see {ERC20Mintable}.
265  *
266  * TIP: For a detailed writeup see our guide
267  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
268  * to implement supply mechanisms].
269  *
270  * We have followed general OpenZeppelin guidelines: functions revert instead
271  * of returning `false` on failure. This behavior is nonetheless conventional
272  * and does not conflict with the expectations of ERC20 applications.
273  *
274  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
275  * This allows applications to reconstruct the allowance for all accounts just
276  * by listening to said events. Other implementations of the EIP may not emit
277  * these events, as it isn't required by the specification.
278  *
279  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
280  * functions have been added to mitigate the well-known issues around setting
281  * allowances. See {IERC20-approve}.
282  */
283 contract ERC20 is Context, IERC20 {
284     using SafeMath for uint256;
285 
286     mapping (address => uint256) private _balances;
287 
288     mapping (address => mapping (address => uint256)) private _allowances;
289 
290     uint256 private _totalSupply;
291 
292     /**
293      * @dev See {IERC20-totalSupply}.
294      */
295     function totalSupply() public view returns (uint256) {
296         return _totalSupply;
297     }
298 
299     /**
300      * @dev See {IERC20-balanceOf}.
301      */
302     function balanceOf(address account) public view returns (uint256) {
303         return _balances[account];
304     }
305 
306     /**
307      * @dev See {IERC20-transfer}.
308      *
309      * Requirements:
310      *
311      * - `recipient` cannot be the zero address.
312      * - the caller must have a balance of at least `amount`.
313      */
314     function transfer(address recipient, uint256 amount) public returns (bool) {
315         _transfer(_msgSender(), recipient, amount);
316         return true;
317     }
318 
319     /**
320      * @dev See {IERC20-allowance}.
321      */
322     function allowance(address owner, address spender) public view returns (uint256) {
323         return _allowances[owner][spender];
324     }
325 
326     /**
327      * @dev See {IERC20-approve}.
328      *
329      * Requirements:
330      *
331      * - `spender` cannot be the zero address.
332      */
333     function approve(address spender, uint256 amount) public returns (bool) {
334         _approve(_msgSender(), spender, amount);
335         return true;
336     }
337 
338     /**
339      * @dev See {IERC20-transferFrom}.
340      *
341      * Emits an {Approval} event indicating the updated allowance. This is not
342      * required by the EIP. See the note at the beginning of {ERC20};
343      *
344      * Requirements:
345      * - `sender` and `recipient` cannot be the zero address.
346      * - `sender` must have a balance of at least `amount`.
347      * - the caller must have allowance for `sender`'s tokens of at least
348      * `amount`.
349      */
350     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
351         _transfer(sender, recipient, amount);
352         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
353         return true;
354     }
355 
356     /**
357      * @dev Atomically increases the allowance granted to `spender` by the caller.
358      *
359      * This is an alternative to {approve} that can be used as a mitigation for
360      * problems described in {IERC20-approve}.
361      *
362      * Emits an {Approval} event indicating the updated allowance.
363      *
364      * Requirements:
365      *
366      * - `spender` cannot be the zero address.
367      */
368     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
369         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
370         return true;
371     }
372 
373     /**
374      * @dev Atomically decreases the allowance granted to `spender` by the caller.
375      *
376      * This is an alternative to {approve} that can be used as a mitigation for
377      * problems described in {IERC20-approve}.
378      *
379      * Emits an {Approval} event indicating the updated allowance.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      * - `spender` must have allowance for the caller of at least
385      * `subtractedValue`.
386      */
387     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
388         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
389         return true;
390     }
391 
392     /**
393      * @dev Moves tokens `amount` from `sender` to `recipient`.
394      *
395      * This is internal function is equivalent to {transfer}, and can be used to
396      * e.g. implement automatic token fees, slashing mechanisms, etc.
397      *
398      * Emits a {Transfer} event.
399      *
400      * Requirements:
401      *
402      * - `sender` cannot be the zero address.
403      * - `recipient` cannot be the zero address.
404      * - `sender` must have a balance of at least `amount`.
405      */
406     function _transfer(address sender, address recipient, uint256 amount) internal {
407         require(sender != address(0), "ERC20: transfer from the zero address");
408         require(recipient != address(0), "ERC20: transfer to the zero address");
409 
410         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
411         _balances[recipient] = _balances[recipient].add(amount);
412         emit Transfer(sender, recipient, amount);
413     }
414 
415     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
416      * the total supply.
417      *
418      * Emits a {Transfer} event with `from` set to the zero address.
419      *
420      * Requirements
421      *
422      * - `to` cannot be the zero address.
423      */
424     function _mint(address account, uint256 amount) internal {
425         require(account != address(0), "ERC20: mint to the zero address");
426 
427         _totalSupply = _totalSupply.add(amount);
428         _balances[account] = _balances[account].add(amount);
429         emit Transfer(address(0), account, amount);
430     }
431 
432     /**
433      * @dev Destroys `amount` tokens from `account`, reducing the
434      * total supply.
435      *
436      * Emits a {Transfer} event with `to` set to the zero address.
437      *
438      * Requirements
439      *
440      * - `account` cannot be the zero address.
441      * - `account` must have at least `amount` tokens.
442      */
443     function _burn(address account, uint256 amount) internal {
444         require(account != address(0), "ERC20: burn from the zero address");
445 
446         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
447         _totalSupply = _totalSupply.sub(amount);
448         emit Transfer(account, address(0), amount);
449     }
450 
451     /**
452      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
453      *
454      * This is internal function is equivalent to `approve`, and can be used to
455      * e.g. set automatic allowances for certain subsystems, etc.
456      *
457      * Emits an {Approval} event.
458      *
459      * Requirements:
460      *
461      * - `owner` cannot be the zero address.
462      * - `spender` cannot be the zero address.
463      */
464     function _approve(address owner, address spender, uint256 amount) internal {
465         require(owner != address(0), "ERC20: approve from the zero address");
466         require(spender != address(0), "ERC20: approve to the zero address");
467 
468         _allowances[owner][spender] = amount;
469         emit Approval(owner, spender, amount);
470     }
471 
472     /**
473      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
474      * from the caller's allowance.
475      *
476      * See {_burn} and {_approve}.
477      */
478     function _burnFrom(address account, uint256 amount) internal {
479         _burn(account, amount);
480         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
481     }
482 }
483 
484 /**
485  * @dev Optional functions from the ERC20 standard.
486  */
487 contract ERC20Detailed is IERC20 {
488     string private _name;
489     string private _symbol;
490     uint8 private _decimals;
491 
492     /**
493      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
494      * these values are immutable: they can only be set once during
495      * construction.
496      */
497     constructor (string memory name, string memory symbol, uint8 decimals) public {
498         _name = name;
499         _symbol = symbol;
500         _decimals = decimals;
501     }
502 
503     /**
504      * @dev Returns the name of the token.
505      */
506     function name() public view returns (string memory) {
507         return _name;
508     }
509 
510     /**
511      * @dev Returns the symbol of the token, usually a shorter version of the
512      * name.
513      */
514     function symbol() public view returns (string memory) {
515         return _symbol;
516     }
517 
518     /**
519      * @dev Returns the number of decimals used to get its user representation.
520      * For example, if `decimals` equals `2`, a balance of `505` tokens should
521      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
522      *
523      * Tokens usually opt for a value of 18, imitating the relationship between
524      * Ether and Wei.
525      *
526      * NOTE: This information is only used for _display_ purposes: it in
527      * no way affects any of the arithmetic of the contract, including
528      * {IERC20-balanceOf} and {IERC20-transfer}.
529      */
530     function decimals() public view returns (uint8) {
531         return _decimals;
532     }
533 }
534 
535 /**
536  * @dev Contract module which provides a basic access control mechanism, where
537  * there is an account (an owner) that can be granted exclusive access to
538  * specific functions.
539  *
540  * This module is used through inheritance. It will make available the modifier
541  * `onlyOwner`, which can be applied to your functions to restrict their use to
542  * the owner.
543  */
544 contract Ownable is Context {
545     address private _owner;
546 
547     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
548 
549     /**
550      * @dev Initializes the contract setting the deployer as the initial owner.
551      */
552     constructor () internal {
553         address msgSender = _msgSender();
554         _owner = msgSender;
555         emit OwnershipTransferred(address(0), msgSender);
556     }
557 
558     /**
559      * @dev Returns the address of the current owner.
560      */
561     function owner() public view returns (address) {
562         return _owner;
563     }
564 
565     /**
566      * @dev Throws if called by any account other than the owner.
567      */
568     modifier onlyOwner() {
569         require(isOwner(), "Ownable: caller is not the owner");
570         _;
571     }
572 
573     /**
574      * @dev Returns true if the caller is the current owner.
575      */
576     function isOwner() public view returns (bool) {
577         return _msgSender() == _owner;
578     }
579 
580     /**
581      * @dev Leaves the contract without owner. It will not be possible to call
582      * `onlyOwner` functions anymore. Can only be called by the current owner.
583      *
584      * NOTE: Renouncing ownership will leave the contract without an owner,
585      * thereby removing any functionality that is only available to the owner.
586      */
587     function renounceOwnership() public onlyOwner {
588         emit OwnershipTransferred(_owner, address(0));
589         _owner = address(0);
590     }
591 
592     /**
593      * @dev Transfers ownership of the contract to a new account (`newOwner`).
594      * Can only be called by the current owner.
595      */
596     function transferOwnership(address newOwner) public onlyOwner {
597         _transferOwnership(newOwner);
598     }
599 
600     /**
601      * @dev Transfers ownership of the contract to a new account (`newOwner`).
602      */
603     function _transferOwnership(address newOwner) internal {
604         require(newOwner != address(0), "Ownable: new owner is the zero address");
605         emit OwnershipTransferred(_owner, newOwner);
606         _owner = newOwner;
607     }
608 }
609 
610 contract MarsToken is ERC20, ERC20Detailed("MarsToken", "Mars", 18), Ownable {
611     function distributeMars(address _communityTreasury, address _teamTreasury, address _investorTreasury) external onlyOwner {
612         require(totalSupply() == 0, "token distributed");
613 
614         uint256 supply = 2_100_000_000e18; // 2.1 billion Mars
615         _mint(_communityTreasury, supply.mul(75).div(100));
616         _mint(_teamTreasury, supply.mul(20).div(100));
617         _mint(_investorTreasury, supply.mul(5).div(100));
618 
619         require(supply == totalSupply(), "total number of mars error");
620     }
621 
622     // Copied and modified from YAM code:
623     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
624     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
625     // Which is copied and modified from COMPOUND:
626     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
627 
628     /// @notice A record of each accounts delegate
629     mapping (address => address) internal _delegates;
630 
631     /// @notice A checkpoint for marking number of votes from a given block
632     struct Checkpoint {
633         uint32 fromBlock;
634         uint256 votes;
635     }
636 
637     /// @notice A record of votes checkpoints for each account, by index
638     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
639 
640     /// @notice The number of checkpoints for each account
641     mapping (address => uint32) public numCheckpoints;
642 
643     /// @notice The EIP-712 typehash for the contract's domain
644     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
645 
646     /// @notice The EIP-712 typehash for the delegation struct used by the contract
647     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
648 
649     /// @notice A record of states for signing / validating signatures
650     mapping (address => uint) public nonces;
651 
652     /// @notice An event thats emitted when an account changes its delegate
653     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
654 
655     /// @notice An event thats emitted when a delegate account's vote balance changes
656     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
657 
658     /**
659      * @notice Delegate votes from `msg.sender` to `delegatee`
660      * @param delegator The address to get delegatee for
661      */
662     function delegates(address delegator)
663     external
664     view
665     returns (address)
666     {
667         return _delegates[delegator];
668     }
669 
670     /**
671      * @notice Delegate votes from `msg.sender` to `delegatee`
672      * @param delegatee The address to delegate votes to
673      */
674     function delegate(address delegatee) external {
675         return _delegate(msg.sender, delegatee);
676     }
677 
678     /**
679      * @notice Delegates votes from signatory to `delegatee`
680      * @param delegatee The address to delegate votes to
681      * @param nonce The contract state required to match the signature
682      * @param expiry The time at which to expire the signature
683      * @param v The recovery byte of the signature
684      * @param r Half of the ECDSA signature pair
685      * @param s Half of the ECDSA signature pair
686      */
687     function delegateBySig(
688         address delegatee,
689         uint nonce,
690         uint expiry,
691         uint8 v,
692         bytes32 r,
693         bytes32 s
694     )
695     external
696     {
697         bytes32 domainSeparator = keccak256(
698             abi.encode(
699                 DOMAIN_TYPEHASH,
700                 keccak256(bytes(name())),
701                 getChainId(),
702                 address(this)
703             )
704         );
705 
706         bytes32 structHash = keccak256(
707             abi.encode(
708                 DELEGATION_TYPEHASH,
709                 delegatee,
710                 nonce,
711                 expiry
712             )
713         );
714 
715         bytes32 digest = keccak256(
716             abi.encodePacked(
717                 "\x19\x01",
718                 domainSeparator,
719                 structHash
720             )
721         );
722 
723         address signatory = ecrecover(digest, v, r, s);
724         require(signatory != address(0), "MARS::delegateBySig: invalid signature");
725         require(nonce == nonces[signatory]++, "MARS::delegateBySig: invalid nonce");
726         require(now <= expiry, "MARS::delegateBySig: signature expired");
727         return _delegate(signatory, delegatee);
728     }
729 
730     /**
731      * @notice Gets the current votes balance for `account`
732      * @param account The address to get votes balance
733      * @return The number of current votes for `account`
734      */
735     function getCurrentVotes(address account)
736     external
737     view
738     returns (uint256)
739     {
740         uint32 nCheckpoints = numCheckpoints[account];
741         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
742     }
743 
744     /**
745      * @notice Determine the prior number of votes for an account as of a block number
746      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
747      * @param account The address of the account to check
748      * @param blockNumber The block number to get the vote balance at
749      * @return The number of votes the account had as of the given block
750      */
751     function getPriorVotes(address account, uint blockNumber)
752     external
753     view
754     returns (uint256)
755     {
756         require(blockNumber < block.number, "MARS::getPriorVotes: not yet determined");
757 
758         uint32 nCheckpoints = numCheckpoints[account];
759         if (nCheckpoints == 0) {
760             return 0;
761         }
762 
763         // First check most recent balance
764         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
765             return checkpoints[account][nCheckpoints - 1].votes;
766         }
767 
768         // Next check implicit zero balance
769         if (checkpoints[account][0].fromBlock > blockNumber) {
770             return 0;
771         }
772 
773         uint32 lower = 0;
774         uint32 upper = nCheckpoints - 1;
775         while (upper > lower) {
776             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
777             Checkpoint memory cp = checkpoints[account][center];
778             if (cp.fromBlock == blockNumber) {
779                 return cp.votes;
780             } else if (cp.fromBlock < blockNumber) {
781                 lower = center;
782             } else {
783                 upper = center - 1;
784             }
785         }
786         return checkpoints[account][lower].votes;
787     }
788 
789     function _delegate(address delegator, address delegatee)
790     internal
791     {
792         address currentDelegate = _delegates[delegator];
793         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying MARSs (not scaled);
794         _delegates[delegator] = delegatee;
795 
796         emit DelegateChanged(delegator, currentDelegate, delegatee);
797 
798         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
799     }
800 
801     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
802         if (srcRep != dstRep && amount > 0) {
803             if (srcRep != address(0)) {
804                 // decrease old representative
805                 uint32 srcRepNum = numCheckpoints[srcRep];
806                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
807                 uint256 srcRepNew = srcRepOld.sub(amount);
808                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
809             }
810 
811             if (dstRep != address(0)) {
812                 // increase new representative
813                 uint32 dstRepNum = numCheckpoints[dstRep];
814                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
815                 uint256 dstRepNew = dstRepOld.add(amount);
816                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
817             }
818         }
819     }
820 
821     function _writeCheckpoint(
822         address delegatee,
823         uint32 nCheckpoints,
824         uint256 oldVotes,
825         uint256 newVotes
826     )
827     internal
828     {
829         uint32 blockNumber = safe32(block.number, "MARS::_writeCheckpoint: block number exceeds 32 bits");
830 
831         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
832             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
833         } else {
834             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
835             numCheckpoints[delegatee] = nCheckpoints + 1;
836         }
837 
838         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
839     }
840 
841     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
842         require(n < 2**32, errorMessage);
843         return uint32(n);
844     }
845 
846     function getChainId() internal pure returns (uint) {
847         uint256 chainId;
848         assembly { chainId := chainid() }
849         return chainId;
850     }
851 }