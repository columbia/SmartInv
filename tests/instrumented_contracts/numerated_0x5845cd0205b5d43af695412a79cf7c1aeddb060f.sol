1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 pragma solidity >=0.6.0 <0.8.0;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/GSN/Context.sol
28 
29 
30 pragma solidity >=0.6.0 <0.8.0;
31 
32 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
33 
34 
35 pragma solidity >=0.6.0 <0.8.0;
36 
37 /**
38  * @dev Interface of the ERC20 standard as defined in the EIP.
39  */
40 interface IERC20 {
41     /**
42      * @dev Returns the amount of tokens in existence.
43      */
44     function totalSupply() external view returns (uint256);
45 
46     /**
47      * @dev Returns the amount of tokens owned by `account`.
48      */
49     function balanceOf(address account) external view returns (uint256);
50 
51     /**
52      * @dev Moves `amount` tokens from the caller's account to `recipient`.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transfer(address recipient, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Returns the remaining number of tokens that `spender` will be
62      * allowed to spend on behalf of `owner` through {transferFrom}. This is
63      * zero by default.
64      *
65      * This value changes when {approve} or {transferFrom} are called.
66      */
67     function allowance(address owner, address spender) external view returns (uint256);
68 
69     /**
70      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * IMPORTANT: Beware that changing an allowance with this method brings the risk
75      * that someone may use both the old and the new allowance by unfortunate
76      * transaction ordering. One possible solution to mitigate this race
77      * condition is to first reduce the spender's allowance to 0 and set the
78      * desired value afterwards:
79      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
80      *
81      * Emits an {Approval} event.
82      */
83     function approve(address spender, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Moves `amount` tokens from `sender` to `recipient` using the
87      * allowance mechanism. `amount` is then deducted from the caller's
88      * allowance.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Emitted when `value` tokens are moved from one account (`from`) to
98      * another (`to`).
99      *
100      * Note that `value` may be zero.
101      */
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     /**
105      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
106      * a call to {approve}. `value` is the new allowance.
107      */
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 // File: @openzeppelin/contracts/math/SafeMath.sol
112 
113 
114 
115 pragma solidity >=0.6.0 <0.8.0;
116 
117 /**
118  * @dev Wrappers over Solidity's arithmetic operations with added overflow
119  * checks.
120  *
121  * Arithmetic operations in Solidity wrap on overflow. This can easily result
122  * in bugs, because programmers usually assume that an overflow raises an
123  * error, which is the standard behavior in high level programming languages.
124  * `SafeMath` restores this intuition by reverting the transaction when an
125  * operation overflows.
126  *
127  * Using this library instead of the unchecked operations eliminates an entire
128  * class of bugs, so it's recommended to use it always.
129  */
130 library SafeMath {
131     /**
132      * @dev Returns the addition of two unsigned integers, with an overflow flag.
133      *
134      * _Available since v3.4._
135      */
136     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
137         uint256 c = a + b;
138         if (c < a) return (false, 0);
139         return (true, c);
140     }
141 
142     /**
143      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
144      *
145      * _Available since v3.4._
146      */
147     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
148         if (b > a) return (false, 0);
149         return (true, a - b);
150     }
151 
152     /**
153      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
154      *
155      * _Available since v3.4._
156      */
157     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
158         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
159         // benefit is lost if 'b' is also tested.
160         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
161         if (a == 0) return (true, 0);
162         uint256 c = a * b;
163         if (c / a != b) return (false, 0);
164         return (true, c);
165     }
166 
167     /**
168      * @dev Returns the division of two unsigned integers, with a division by zero flag.
169      *
170      * _Available since v3.4._
171      */
172     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
173         if (b == 0) return (false, 0);
174         return (true, a / b);
175     }
176 
177     /**
178      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
179      *
180      * _Available since v3.4._
181      */
182     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
183         if (b == 0) return (false, 0);
184         return (true, a % b);
185     }
186 
187     /**
188      * @dev Returns the addition of two unsigned integers, reverting on
189      * overflow.
190      *
191      * Counterpart to Solidity's `+` operator.
192      *
193      * Requirements:
194      *
195      * - Addition cannot overflow.
196      */
197     function add(uint256 a, uint256 b) internal pure returns (uint256) {
198         uint256 c = a + b;
199         require(c >= a, "SafeMath: addition overflow");
200         return c;
201     }
202 
203     /**
204      * @dev Returns the subtraction of two unsigned integers, reverting on
205      * overflow (when the result is negative).
206      *
207      * Counterpart to Solidity's `-` operator.
208      *
209      * Requirements:
210      *
211      * - Subtraction cannot overflow.
212      */
213     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
214         require(b <= a, "SafeMath: subtraction overflow");
215         return a - b;
216     }
217 
218     /**
219      * @dev Returns the multiplication of two unsigned integers, reverting on
220      * overflow.
221      *
222      * Counterpart to Solidity's `*` operator.
223      *
224      * Requirements:
225      *
226      * - Multiplication cannot overflow.
227      */
228     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
229         if (a == 0) return 0;
230         uint256 c = a * b;
231         require(c / a == b, "SafeMath: multiplication overflow");
232         return c;
233     }
234 
235     /**
236      * @dev Returns the integer division of two unsigned integers, reverting on
237      * division by zero. The result is rounded towards zero.
238      *
239      * Counterpart to Solidity's `/` operator. Note: this function uses a
240      * `revert` opcode (which leaves remaining gas untouched) while Solidity
241      * uses an invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function div(uint256 a, uint256 b) internal pure returns (uint256) {
248         require(b > 0, "SafeMath: division by zero");
249         return a / b;
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * reverting when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
265         require(b > 0, "SafeMath: modulo by zero");
266         return a % b;
267     }
268 
269     /**
270      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
271      * overflow (when the result is negative).
272      *
273      * CAUTION: This function is deprecated because it requires allocating memory for the error
274      * message unnecessarily. For custom revert reasons use {trySub}.
275      *
276      * Counterpart to Solidity's `-` operator.
277      *
278      * Requirements:
279      *
280      * - Subtraction cannot overflow.
281      */
282     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
283         require(b <= a, errorMessage);
284         return a - b;
285     }
286 
287     /**
288      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
289      * division by zero. The result is rounded towards zero.
290      *
291      * CAUTION: This function is deprecated because it requires allocating memory for the error
292      * message unnecessarily. For custom revert reasons use {tryDiv}.
293      *
294      * Counterpart to Solidity's `/` operator. Note: this function uses a
295      * `revert` opcode (which leaves remaining gas untouched) while Solidity
296      * uses an invalid opcode to revert (consuming all remaining gas).
297      *
298      * Requirements:
299      *
300      * - The divisor cannot be zero.
301      */
302     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
303         require(b > 0, errorMessage);
304         return a / b;
305     }
306 
307     /**
308      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
309      * reverting with custom message when dividing by zero.
310      *
311      * CAUTION: This function is deprecated because it requires allocating memory for the error
312      * message unnecessarily. For custom revert reasons use {tryMod}.
313      *
314      * Counterpart to Solidity's `%` operator. This function uses a `revert`
315      * opcode (which leaves remaining gas untouched) while Solidity uses an
316      * invalid opcode to revert (consuming all remaining gas).
317      *
318      * Requirements:
319      *
320      * - The divisor cannot be zero.
321      */
322     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
323         require(b > 0, errorMessage);
324         return a % b;
325     }
326 }
327 
328 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
329 
330 
331 pragma solidity >=0.6.0 <0.8.0;
332 
333 
334 
335 
336 /**
337  * @dev Implementation of the {IERC20} interface.
338  *
339  * This implementation is agnostic to the way tokens are created. This means
340  * that a supply mechanism has to be added in a derived contract using {_mint}.
341  * For a generic mechanism see {ERC20PresetMinterPauser}.
342  *
343  * TIP: For a detailed writeup see our guide
344  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
345  * to implement supply mechanisms].
346  *
347  * We have followed general OpenZeppelin guidelines: functions revert instead
348  * of returning `false` on failure. This behavior is nonetheless conventional
349  * and does not conflict with the expectations of ERC20 applications.
350  *
351  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
352  * This allows applications to reconstruct the allowance for all accounts just
353  * by listening to said events. Other implementations of the EIP may not emit
354  * these events, as it isn't required by the specification.
355  *
356  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
357  * functions have been added to mitigate the well-known issues around setting
358  * allowances. See {IERC20-approve}.
359  */
360 contract ERC20 is Context, IERC20 {
361     using SafeMath for uint256;
362 
363     mapping (address => uint256) private _balances;
364 
365     mapping (address => mapping (address => uint256)) private _allowances;
366 
367     uint256 private _totalSupply;
368 
369     string private _name;
370     string private _symbol;
371     uint8 private _decimals;
372 
373     /**
374      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
375      * a default value of 18.
376      *
377      * To select a different value for {decimals}, use {_setupDecimals}.
378      *
379      * All three of these values are immutable: they can only be set once during
380      * construction.
381      */
382     constructor (string memory name_, string memory symbol_) public {
383         _name = name_;
384         _symbol = symbol_;
385         _decimals = 18;
386     }
387 
388     /**
389      * @dev Returns the name of the token.
390      */
391     function name() public view virtual returns (string memory) {
392         return _name;
393     }
394 
395     /**
396      * @dev Returns the symbol of the token, usually a shorter version of the
397      * name.
398      */
399     function symbol() public view virtual returns (string memory) {
400         return _symbol;
401     }
402 
403     /**
404      * @dev Returns the number of decimals used to get its user representation.
405      * For example, if `decimals` equals `2`, a balance of `505` tokens should
406      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
407      *
408      * Tokens usually opt for a value of 18, imitating the relationship between
409      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
410      * called.
411      *
412      * NOTE: This information is only used for _display_ purposes: it in
413      * no way affects any of the arithmetic of the contract, including
414      * {IERC20-balanceOf} and {IERC20-transfer}.
415      */
416     function decimals() public view virtual returns (uint8) {
417         return _decimals;
418     }
419 
420     /**
421      * @dev See {IERC20-totalSupply}.
422      */
423     function totalSupply() public view virtual override returns (uint256) {
424         return _totalSupply;
425     }
426 
427     /**
428      * @dev See {IERC20-balanceOf}.
429      */
430     function balanceOf(address account) public view virtual override returns (uint256) {
431         return _balances[account];
432     }
433 
434     /**
435      * @dev See {IERC20-transfer}.
436      *
437      * Requirements:
438      *
439      * - `recipient` cannot be the zero address.
440      * - the caller must have a balance of at least `amount`.
441      */
442     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
443         _transfer(_msgSender(), recipient, amount);
444         return true;
445     }
446 
447     /**
448      * @dev See {IERC20-allowance}.
449      */
450     function allowance(address owner, address spender) public view virtual override returns (uint256) {
451         return _allowances[owner][spender];
452     }
453 
454     /**
455      * @dev See {IERC20-approve}.
456      *
457      * Requirements:
458      *
459      * - `spender` cannot be the zero address.
460      */
461     function approve(address spender, uint256 amount) public virtual override returns (bool) {
462         _approve(_msgSender(), spender, amount);
463         return true;
464     }
465 
466     /**
467      * @dev See {IERC20-transferFrom}.
468      *
469      * Emits an {Approval} event indicating the updated allowance. This is not
470      * required by the EIP. See the note at the beginning of {ERC20}.
471      *
472      * Requirements:
473      *
474      * - `sender` and `recipient` cannot be the zero address.
475      * - `sender` must have a balance of at least `amount`.
476      * - the caller must have allowance for ``sender``'s tokens of at least
477      * `amount`.
478      */
479     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
480         _transfer(sender, recipient, amount);
481         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
482         return true;
483     }
484 
485     /**
486      * @dev Atomically increases the allowance granted to `spender` by the caller.
487      *
488      * This is an alternative to {approve} that can be used as a mitigation for
489      * problems described in {IERC20-approve}.
490      *
491      * Emits an {Approval} event indicating the updated allowance.
492      *
493      * Requirements:
494      *
495      * - `spender` cannot be the zero address.
496      */
497     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
498         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
499         return true;
500     }
501 
502     /**
503      * @dev Atomically decreases the allowance granted to `spender` by the caller.
504      *
505      * This is an alternative to {approve} that can be used as a mitigation for
506      * problems described in {IERC20-approve}.
507      *
508      * Emits an {Approval} event indicating the updated allowance.
509      *
510      * Requirements:
511      *
512      * - `spender` cannot be the zero address.
513      * - `spender` must have allowance for the caller of at least
514      * `subtractedValue`.
515      */
516     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
517         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
518         return true;
519     }
520 
521     /**
522      * @dev Moves tokens `amount` from `sender` to `recipient`.
523      *
524      * This is internal function is equivalent to {transfer}, and can be used to
525      * e.g. implement automatic token fees, slashing mechanisms, etc.
526      *
527      * Emits a {Transfer} event.
528      *
529      * Requirements:
530      *
531      * - `sender` cannot be the zero address.
532      * - `recipient` cannot be the zero address.
533      * - `sender` must have a balance of at least `amount`.
534      */
535     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
536         require(sender != address(0), "ERC20: transfer from the zero address");
537         require(recipient != address(0), "ERC20: transfer to the zero address");
538 
539         _beforeTokenTransfer(sender, recipient, amount);
540 
541         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
542         _balances[recipient] = _balances[recipient].add(amount);
543         emit Transfer(sender, recipient, amount);
544     }
545 
546     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
547      * the total supply.
548      *
549      * Emits a {Transfer} event with `from` set to the zero address.
550      *
551      * Requirements:
552      *
553      * - `to` cannot be the zero address.
554      */
555     function _mint(address account, uint256 amount) internal virtual {
556         require(account != address(0), "ERC20: mint to the zero address");
557 
558         _beforeTokenTransfer(address(0), account, amount);
559 
560         _totalSupply = _totalSupply.add(amount);
561         _balances[account] = _balances[account].add(amount);
562         emit Transfer(address(0), account, amount);
563     }
564 
565     /**
566      * @dev Destroys `amount` tokens from `account`, reducing the
567      * total supply.
568      *
569      * Emits a {Transfer} event with `to` set to the zero address.
570      *
571      * Requirements:
572      *
573      * - `account` cannot be the zero address.
574      * - `account` must have at least `amount` tokens.
575      */
576     function _burn(address account, uint256 amount) internal virtual {
577         require(account != address(0), "ERC20: burn from the zero address");
578 
579         _beforeTokenTransfer(account, address(0), amount);
580 
581         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
582         _totalSupply = _totalSupply.sub(amount);
583         emit Transfer(account, address(0), amount);
584     }
585 
586     /**
587      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
588      *
589      * This internal function is equivalent to `approve`, and can be used to
590      * e.g. set automatic allowances for certain subsystems, etc.
591      *
592      * Emits an {Approval} event.
593      *
594      * Requirements:
595      *
596      * - `owner` cannot be the zero address.
597      * - `spender` cannot be the zero address.
598      */
599     function _approve(address owner, address spender, uint256 amount) internal virtual {
600         require(owner != address(0), "ERC20: approve from the zero address");
601         require(spender != address(0), "ERC20: approve to the zero address");
602 
603         _allowances[owner][spender] = amount;
604         emit Approval(owner, spender, amount);
605     }
606 
607     /**
608      * @dev Sets {decimals} to a value other than the default one of 18.
609      *
610      * WARNING: This function should only be called from the constructor. Most
611      * applications that interact with token contracts will not expect
612      * {decimals} to ever change, and may work incorrectly if it does.
613      */
614     function _setupDecimals(uint8 decimals_) internal virtual {
615         _decimals = decimals_;
616     }
617 
618     /**
619      * @dev Hook that is called before any transfer of tokens. This includes
620      * minting and burning.
621      *
622      * Calling conditions:
623      *
624      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
625      * will be to transferred to `to`.
626      * - when `from` is zero, `amount` tokens will be minted for `to`.
627      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
628      * - `from` and `to` are never both zero.
629      *
630      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
631      */
632     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
633 }
634 
635 // File: @openzeppelin/contracts/access/Ownable.sol
636 
637 
638 pragma solidity >=0.6.0 <0.8.0;
639 
640 /**
641  * @dev Contract module which provides a basic access control mechanism, where
642  * there is an account (an owner) that can be granted exclusive access to
643  * specific functions.
644  *
645  * By default, the owner account will be the one that deploys the contract. This
646  * can later be changed with {transferOwnership}.
647  *
648  * This module is used through inheritance. It will make available the modifier
649  * `onlyOwner`, which can be applied to your functions to restrict their use to
650  * the owner.
651  */
652 abstract contract Ownable is Context {
653     address private _owner;
654 
655     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
656 
657     /**
658      * @dev Initializes the contract setting the deployer as the initial owner.
659      */
660     constructor () internal {
661         address msgSender = _msgSender();
662         _owner = msgSender;
663         emit OwnershipTransferred(address(0), msgSender);
664     }
665 
666     /**
667      * @dev Returns the address of the current owner.
668      */
669     function owner() public view virtual returns (address) {
670         return _owner;
671     }
672 
673     /**
674      * @dev Throws if called by any account other than the owner.
675      */
676     modifier onlyOwner() {
677         require(owner() == _msgSender(), "Ownable: caller is not the owner");
678         _;
679     }
680 
681     /**
682      * @dev Leaves the contract without owner. It will not be possible to call
683      * `onlyOwner` functions anymore. Can only be called by the current owner.
684      *
685      * NOTE: Renouncing ownership will leave the contract without an owner,
686      * thereby removing any functionality that is only available to the owner.
687      */
688     function renounceOwnership() public virtual onlyOwner {
689         emit OwnershipTransferred(_owner, address(0));
690         _owner = address(0);
691     }
692 
693     /**
694      * @dev Transfers ownership of the contract to a new account (`newOwner`).
695      * Can only be called by the current owner.
696      */
697     function transferOwnership(address newOwner) public virtual onlyOwner {
698         require(newOwner != address(0), "Ownable: new owner is the zero address");
699         emit OwnershipTransferred(_owner, newOwner);
700         _owner = newOwner;
701     }
702 }
703 
704 // File: contracts/SHDToken.sol
705 
706 
707 pragma solidity 0.6.12;
708 
709 
710 
711 
712 
713 
714 // SHDToken with Governance.
715 contract SHDToken is ERC20("ShardingDAO", "SHD"), Ownable {
716     // cross chain
717     mapping(address => bool) public minters;
718 
719     struct Checkpoint {
720         uint256 fromBlock;
721         uint256 votes;
722     }
723     /// @notice A record of votes checkpoints for each account, by index
724     mapping(address => mapping(uint256 => Checkpoint)) public checkpoints;
725 
726     /// @notice The number of checkpoints for each account
727     mapping(address => uint256) public numCheckpoints;
728     event VotesBalanceChanged(
729         address indexed user,
730         uint256 previousBalance,
731         uint256 newBalance
732     );
733 
734     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
735     function mint(address _to, uint256 _amount) public {
736         require(minters[msg.sender] == true, "SHD : You are not the miner");
737         _mint(_to, _amount);
738     }
739 
740     function burn(uint256 _amount) public {
741         _burn(msg.sender, _amount);
742     }
743 
744     function addMiner(address _miner) external onlyOwner {
745         minters[_miner] = true;
746     }
747 
748     function removeMiner(address _miner) external onlyOwner {
749         minters[_miner] = false;
750     }
751 
752     function getPriorVotes(address account, uint256 blockNumber)
753         public
754         view
755         returns (uint256)
756     {
757         require(
758             blockNumber < block.number,
759             "getPriorVotes: not yet determined"
760         );
761 
762         uint256 nCheckpoints = numCheckpoints[account];
763         if (nCheckpoints == 0) {
764             return 0;
765         }
766 
767         // First check most recent balance
768         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
769             return checkpoints[account][nCheckpoints - 1].votes;
770         }
771 
772         // Next check implicit zero balance
773         if (checkpoints[account][0].fromBlock > blockNumber) {
774             return 0;
775         }
776 
777         uint256 lower = 0;
778         uint256 upper = nCheckpoints - 1;
779         while (upper > lower) {
780             uint256 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
781             Checkpoint memory cp = checkpoints[account][center];
782             if (cp.fromBlock == blockNumber) {
783                 return cp.votes;
784             } else if (cp.fromBlock < blockNumber) {
785                 lower = center;
786             } else {
787                 upper = center - 1;
788             }
789         }
790         return checkpoints[account][lower].votes;
791     }
792 
793     function _voteTransfer(
794         address from,
795         address to,
796         uint256 amount
797     ) internal {
798         if (from != to && amount > 0) {
799             if (from != address(0)) {
800                 uint256 fromNum = numCheckpoints[from];
801                 uint256 fromOld =
802                     fromNum > 0 ? checkpoints[from][fromNum - 1].votes : 0;
803                 uint256 fromNew = fromOld.sub(amount);
804                 _writeCheckpoint(from, fromNum, fromOld, fromNew);
805             }
806 
807             if (to != address(0)) {
808                 uint256 toNum = numCheckpoints[to];
809                 uint256 toOld =
810                     toNum > 0 ? checkpoints[to][toNum - 1].votes : 0;
811                 uint256 toNew = toOld.add(amount);
812                 _writeCheckpoint(to, toNum, toOld, toNew);
813             }
814         }
815     }
816 
817     function _writeCheckpoint(
818         address user,
819         uint256 nCheckpoints,
820         uint256 oldVotes,
821         uint256 newVotes
822     ) internal {
823         uint256 blockNumber = block.number;
824         if (
825             nCheckpoints > 0 &&
826             checkpoints[user][nCheckpoints - 1].fromBlock == blockNumber
827         ) {
828             checkpoints[user][nCheckpoints - 1].votes = newVotes;
829         } else {
830             checkpoints[user][nCheckpoints] = Checkpoint(blockNumber, newVotes);
831             numCheckpoints[user] = nCheckpoints + 1;
832         }
833 
834         emit VotesBalanceChanged(user, oldVotes, newVotes);
835     }
836 
837     function _beforeTokenTransfer(
838         address from,
839         address to,
840         uint256 amount
841     ) internal override {
842         _voteTransfer(from, to, amount);
843     }
844 }