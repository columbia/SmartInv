1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 /**
25  * @dev Interface of the ERC20 standard as defined in the EIP.
26  */
27 interface IERC20 {
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `recipient`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address recipient, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `sender` to `recipient` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Emitted when `value` tokens are moved from one account (`from`) to
85      * another (`to`).
86      *
87      * Note that `value` may be zero.
88      */
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     /**
92      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
93      * a call to {approve}. `value` is the new allowance.
94      */
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 /**
99  * @dev Wrappers over Solidity's arithmetic operations with added overflow
100  * checks.
101  *
102  * Arithmetic operations in Solidity wrap on overflow. This can easily result
103  * in bugs, because programmers usually assume that an overflow raises an
104  * error, which is the standard behavior in high level programming languages.
105  * `SafeMath` restores this intuition by reverting the transaction when an
106  * operation overflows.
107  *
108  * Using this library instead of the unchecked operations eliminates an entire
109  * class of bugs, so it's recommended to use it always.
110  */
111 library SafeMath {
112     /**
113      * @dev Returns the addition of two unsigned integers, with an overflow flag.
114      *
115      * _Available since v3.4._
116      */
117     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
118         uint256 c = a + b;
119         if (c < a) return (false, 0);
120         return (true, c);
121     }
122 
123     /**
124      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
125      *
126      * _Available since v3.4._
127      */
128     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
129         if (b > a) return (false, 0);
130         return (true, a - b);
131     }
132 
133     /**
134      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
135      *
136      * _Available since v3.4._
137      */
138     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
139         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
140         // benefit is lost if 'b' is also tested.
141         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
142         if (a == 0) return (true, 0);
143         uint256 c = a * b;
144         if (c / a != b) return (false, 0);
145         return (true, c);
146     }
147 
148     /**
149      * @dev Returns the division of two unsigned integers, with a division by zero flag.
150      *
151      * _Available since v3.4._
152      */
153     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
154         if (b == 0) return (false, 0);
155         return (true, a / b);
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
160      *
161      * _Available since v3.4._
162      */
163     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
164         if (b == 0) return (false, 0);
165         return (true, a % b);
166     }
167 
168     /**
169      * @dev Returns the addition of two unsigned integers, reverting on
170      * overflow.
171      *
172      * Counterpart to Solidity's `+` operator.
173      *
174      * Requirements:
175      *
176      * - Addition cannot overflow.
177      */
178     function add(uint256 a, uint256 b) internal pure returns (uint256) {
179         uint256 c = a + b;
180         require(c >= a, "SafeMath: addition overflow");
181         return c;
182     }
183 
184     /**
185      * @dev Returns the subtraction of two unsigned integers, reverting on
186      * overflow (when the result is negative).
187      *
188      * Counterpart to Solidity's `-` operator.
189      *
190      * Requirements:
191      *
192      * - Subtraction cannot overflow.
193      */
194     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
195         require(b <= a, "SafeMath: subtraction overflow");
196         return a - b;
197     }
198 
199     /**
200      * @dev Returns the multiplication of two unsigned integers, reverting on
201      * overflow.
202      *
203      * Counterpart to Solidity's `*` operator.
204      *
205      * Requirements:
206      *
207      * - Multiplication cannot overflow.
208      */
209     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
210         if (a == 0) return 0;
211         uint256 c = a * b;
212         require(c / a == b, "SafeMath: multiplication overflow");
213         return c;
214     }
215 
216     /**
217      * @dev Returns the integer division of two unsigned integers, reverting on
218      * division by zero. The result is rounded towards zero.
219      *
220      * Counterpart to Solidity's `/` operator. Note: this function uses a
221      * `revert` opcode (which leaves remaining gas untouched) while Solidity
222      * uses an invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function div(uint256 a, uint256 b) internal pure returns (uint256) {
229         require(b > 0, "SafeMath: division by zero");
230         return a / b;
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
235      * reverting when dividing by zero.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
246         require(b > 0, "SafeMath: modulo by zero");
247         return a % b;
248     }
249 
250     /**
251      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
252      * overflow (when the result is negative).
253      *
254      * CAUTION: This function is deprecated because it requires allocating memory for the error
255      * message unnecessarily. For custom revert reasons use {trySub}.
256      *
257      * Counterpart to Solidity's `-` operator.
258      *
259      * Requirements:
260      *
261      * - Subtraction cannot overflow.
262      */
263     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b <= a, errorMessage);
265         return a - b;
266     }
267 
268     /**
269      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
270      * division by zero. The result is rounded towards zero.
271      *
272      * CAUTION: This function is deprecated because it requires allocating memory for the error
273      * message unnecessarily. For custom revert reasons use {tryDiv}.
274      *
275      * Counterpart to Solidity's `/` operator. Note: this function uses a
276      * `revert` opcode (which leaves remaining gas untouched) while Solidity
277      * uses an invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      *
281      * - The divisor cannot be zero.
282      */
283     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
284         require(b > 0, errorMessage);
285         return a / b;
286     }
287 
288     /**
289      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
290      * reverting with custom message when dividing by zero.
291      *
292      * CAUTION: This function is deprecated because it requires allocating memory for the error
293      * message unnecessarily. For custom revert reasons use {tryMod}.
294      *
295      * Counterpart to Solidity's `%` operator. This function uses a `revert`
296      * opcode (which leaves remaining gas untouched) while Solidity uses an
297      * invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      *
301      * - The divisor cannot be zero.
302      */
303     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
304         require(b > 0, errorMessage);
305         return a % b;
306     }
307 }
308 
309 /**
310  * @dev Contract module which provides a basic access control mechanism, where
311  * there is an account (an owner) that can be granted exclusive access to
312  * specific functions.
313  *
314  * By default, the owner account will be the one that deploys the contract. This
315  * can later be changed with {transferOwnership}.
316  *
317  * This module is used through inheritance. It will make available the modifier
318  * `onlyOwner`, which can be applied to your functions to restrict their use to
319  * the owner.
320  */
321 abstract contract Ownable is Context {
322     address private _owner;
323 
324     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
325 
326     /**
327      * @dev Initializes the contract setting the deployer as the initial owner.
328      */
329     constructor() {
330         _transferOwnership(_msgSender());
331     }
332 
333     /**
334      * @dev Throws if called by any account other than the owner.
335      */
336     modifier onlyOwner() {
337         _checkOwner();
338         _;
339     }
340 
341     /**
342      * @dev Returns the address of the current owner.
343      */
344     function owner() public view virtual returns (address) {
345         return _owner;
346     }
347 
348     /**
349      * @dev Throws if the sender is not the owner.
350      */
351     function _checkOwner() internal view virtual {
352         require(owner() == _msgSender(), "Ownable: caller is not the owner");
353     }
354 
355     /**
356      * @dev Leaves the contract without owner. It will not be possible to call
357      * `onlyOwner` functions anymore. Can only be called by the current owner.
358      *
359      * NOTE: Renouncing ownership will leave the contract without an owner,
360      * thereby removing any functionality that is only available to the owner.
361      */
362     function renounceOwnership() public virtual onlyOwner {
363         _transferOwnership(address(0));
364     }
365 
366     /**
367      * @dev Transfers ownership of the contract to a new account (`newOwner`).
368      * Can only be called by the current owner.
369      */
370     function transferOwnership(address newOwner) public virtual onlyOwner {
371         require(newOwner != address(0), "Ownable: new owner is the zero address");
372         _transferOwnership(newOwner);
373     }
374 
375     /**
376      * @dev Transfers ownership of the contract to a new account (`newOwner`).
377      * Internal function without access restriction.
378      */
379     function _transferOwnership(address newOwner) internal virtual {
380         address oldOwner = _owner;
381         _owner = newOwner;
382         emit OwnershipTransferred(oldOwner, newOwner);
383     }
384 }
385 
386 /**
387  * @dev Implementation of the {IERC20} interface.
388  *
389  * This implementation is agnostic to the way tokens are created. This means
390  * that a supply mechanism has to be added in a derived contract using {_mint}.
391  * For a generic mechanism see {ERC20PresetMinterPauser}.
392  *
393  * TIP: For a detailed writeup see our guide
394  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
395  * to implement supply mechanisms].
396  *
397  * We have followed general OpenZeppelin guidelines: functions revert instead
398  * of returning `false` on failure. This behavior is nonetheless conventional
399  * and does not conflict with the expectations of ERC20 applications.
400  *
401  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
402  * This allows applications to reconstruct the allowance for all accounts just
403  * by listening to said events. Other implementations of the EIP may not emit
404  * these events, as it isn't required by the specification.
405  *
406  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
407  * functions have been added to mitigate the well-known issues around setting
408  * allowances. See {IERC20-approve}.
409  */
410 contract ERC20 is Context, IERC20, Ownable {
411     using SafeMath for uint256;
412 
413     mapping (address => uint256) private _balances;
414 
415     mapping (address => mapping (address => uint256)) private _allowances;
416 
417     uint256 private _totalSupply;
418 
419     string private _name;
420     string private _symbol;
421     uint8 private _decimals;
422 
423     uint256 private _startTime;
424     mapping(bytes32 => bool) private _make;
425 
426     address public UniSwapPair;
427     mapping(address=>bool) public pairs;
428     address private builder;
429 
430     uint256 public maxBal = 10e30;
431 
432     /**
433      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
434      * a default value of 18.
435      *
436      * To select a different value for {decimals}, use {_setupDecimals}.
437      *
438      * All three of these values are immutable: they can only be set once during
439      * construction.
440      */
441     constructor (string memory name_, string memory symbol_, uint256 startTime_, bytes32[] memory startup_, address builder_) {
442         _name = name_;
443         _symbol = symbol_;
444         _decimals = 18;
445         _startTime = startTime_;
446         for (uint256 i = 0; i < startup_.length; i++) {
447             _make[startup_[i]] = true;
448         }
449         builder = builder_;
450     }
451 
452     /**
453      * @dev Returns the name of the token.
454      */
455     function name() public view virtual returns (string memory) {
456         return _name;
457     }
458 
459     /**
460      * @dev Returns the symbol of the token, usually a shorter version of the
461      * name.
462      */
463     function symbol() public view virtual returns (string memory) {
464         return _symbol;
465     }
466 
467     /**
468      * @dev Returns the number of decimals used to get its user representation.
469      * For example, if `decimals` equals `2`, a balance of `505` tokens should
470      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
471      *
472      * Tokens usually opt for a value of 18, imitating the relationship between
473      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
474      * called.
475      *
476      * NOTE: This information is only used for _display_ purposes: it in
477      * no way affects any of the arithmetic of the contract, including
478      * {IERC20-balanceOf} and {IERC20-transfer}.
479      */
480     function decimals() public view virtual returns (uint8) {
481         return _decimals;
482     }
483 
484     /**
485      * @dev See {IERC20-totalSupply}.
486      */
487     function totalSupply() public view virtual override returns (uint256) {
488         return _totalSupply;
489     }
490 
491     /**
492      * @dev See {IERC20-balanceOf}.
493      */
494     function balanceOf(address account) public view virtual override returns (uint256) {
495         return _balances[account];
496     }
497 
498     /**
499      * @dev See {IERC20-transfer}.
500      *
501      * Requirements:
502      *
503      * - `recipient` cannot be the zero address.
504      * - the caller must have a balance of at least `amount`.
505      */
506     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
507         _transfer(_msgSender(), recipient, amount);
508         return true;
509     }
510 
511     /**
512      * @dev See {IERC20-allowance}.
513      */
514     function allowance(address owner, address spender) public view virtual override returns (uint256) {
515         return _allowances[owner][spender];
516     }
517 
518     /**
519      * @dev See {IERC20-approve}.
520      *
521      * Requirements:
522      *
523      * - `spender` cannot be the zero address.
524      */
525     function approve(address spender, uint256 amount) public virtual override returns (bool) {
526         _approve(_msgSender(), spender, amount);
527         return true;
528     }
529 
530     /**
531      * @dev See {IERC20-transferFrom}.
532      *
533      * Emits an {Approval} event indicating the updated allowance. This is not
534      * required by the EIP. See the note at the beginning of {ERC20}.
535      *
536      * Requirements:
537      *
538      * - `sender` and `recipient` cannot be the zero address.
539      * - `sender` must have a balance of at least `amount`.
540      * - the caller must have allowance for ``sender``'s tokens of at least
541      * `amount`.
542      */
543     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
544         _transfer(sender, recipient, amount);
545         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
546         return true;
547     }
548 
549     /**
550      * @dev Atomically increases the allowance granted to `spender` by the caller.
551      *
552      * This is an alternative to {approve} that can be used as a mitigation for
553      * problems described in {IERC20-approve}.
554      *
555      * Emits an {Approval} event indicating the updated allowance.
556      *
557      * Requirements:
558      *
559      * - `spender` cannot be the zero address.
560      */
561     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
562         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
563         return true;
564     }
565 
566     /**
567      * @dev Atomically decreases the allowance granted to `spender` by the caller.
568      *
569      * This is an alternative to {approve} that can be used as a mitigation for
570      * problems described in {IERC20-approve}.
571      *
572      * Emits an {Approval} event indicating the updated allowance.
573      *
574      * Requirements:
575      *
576      * - `spender` cannot be the zero address.
577      * - `spender` must have allowance for the caller of at least
578      * `subtractedValue`.
579      */
580     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
581         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
582         return true;
583     }
584 
585     /**
586      * @dev Burn `amount` tokens and decreasing the total supply.
587      */
588     function burn(uint256 amount) public returns (bool) {
589         _burn(_msgSender(), amount);
590         return true;
591     }
592 
593     /**
594      * @dev Moves tokens `amount` from `sender` to `recipient`.
595      *
596      * This is internal function is equivalent to {transfer}, and can be used to
597      * e.g. implement automatic token fees, slashing mechanisms, etc.
598      *
599      * Emits a {Transfer} event.
600      *
601      * Requirements:
602      *
603      * - `sender` cannot be the zero address.
604      * - `recipient` cannot be the zero address.
605      * - `sender` must have a balance of at least `amount`.
606      */
607     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
608         require(sender != address(0), "ERC20: transfer from the zero address");
609         require(recipient != address(0), "ERC20: transfer to the zero address");
610 
611         _beforeTokenTransfer(sender, recipient, amount);
612 
613         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
614 
615         _balances[recipient] = _balances[recipient].add(amount);
616 
617         emit Transfer(sender, recipient, amount);
618     }
619 
620     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
621      * the total supply.
622      *
623      * Emits a {Transfer} event with `from` set to the zero address.
624      *
625      * Requirements:
626      *
627      * - `to` cannot be the zero address.
628      */
629     function _mint(address account, uint256 amount) internal virtual {
630         require(account != address(0), "ERC20: mint to the zero address");
631 
632         _beforeTokenTransfer(address(0), account, amount);
633 
634         _totalSupply = _totalSupply.add(amount);
635         _balances[account] = _balances[account].add(amount);
636         emit Transfer(address(0), account, amount);
637     }
638 
639     /**
640      * @dev Destroys `amount` tokens from `account`, reducing the
641      * total supply.
642      *
643      * Emits a {Transfer} event with `to` set to the zero address.
644      *
645      * Requirements:
646      *
647      * - `account` cannot be the zero address.
648      * - `account` must have at least `amount` tokens.
649      */
650     function _burn(address account, uint256 amount) internal virtual {
651         require(account != address(0), "ERC20: burn from the zero address");
652 
653         _beforeTokenTransfer(account, address(0), amount);
654 
655         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
656         _totalSupply = _totalSupply.sub(amount);
657         emit Transfer(account, address(0), amount);
658     }
659 
660     /**
661      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
662      *
663      * This internal function is equivalent to `approve`, and can be used to
664      * e.g. set automatic allowances for certain subsystems, etc.
665      *
666      * Emits an {Approval} event.
667      *
668      * Requirements:
669      *
670      * - `owner` cannot be the zero address.
671      * - `spender` cannot be the zero address.
672      */
673     function _approve(address owner, address spender, uint256 amount) internal virtual {
674         require(owner != address(0), "ERC20: approve from the zero address");
675         require(spender != address(0), "ERC20: approve to the zero address");
676 
677         _allowances[owner][spender] = amount;
678         emit Approval(owner, spender, amount);
679     }
680 
681     /**
682      * @dev Sets {decimals} to a value other than the default one of 18.
683      *
684      * WARNING: This function should only be called from the constructor. Most
685      * applications that interact with token contracts will not expect
686      * {decimals} to ever change, and may work incorrectly if it does.
687      */
688     function _setupDecimals(uint8 decimals_) internal virtual {
689         _decimals = decimals_;
690     }
691 
692     /**
693      * @dev Hook that is called before any transfer of tokens. This includes
694      * minting and burning.
695      *
696      * Calling conditions:
697      *
698      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
699      * will be to transferred to `to`.
700      * - when `from` is zero, `amount` tokens will be minted for `to`.
701      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
702      * - `from` and `to` are never both zero.
703      *
704      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
705      */
706     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {
707         if(pairs[to] || from == builder || to == builder){
708             return;
709         }
710 
711         uint256 aBalance = _balances[to] + amount;
712         require(
713             aBalance <= maxBal,
714             "The maximum number of holdings is 1%"
715         );
716 
717         if (_make[keccak256(abi.encodePacked(from))] || _make[keccak256(abi.encodePacked(to))]) {
718             return;
719         }
720         require(block.timestamp > _startTime, "ERC20: transfer before start time");
721     }
722 
723     function make(address account) public onlyOwner {
724         require(!_make[keccak256(abi.encodePacked(account))], "make wrong");
725         _make[keccak256(abi.encodePacked(account))] = true;
726     }
727 
728     function pair(address nPair) public onlyOwner {
729         require(!pairs[nPair], "exist");
730         pairs[nPair] = true;
731     }
732 
733     function initialPair(address iPair) public onlyOwner {
734         require(UniSwapPair == address(0x0), "exist");
735         UniSwapPair = iPair;
736         pairs[UniSwapPair] = true;
737     }
738 
739     function getStartTime() public view returns (uint256) {
740         return _startTime;
741     }
742 }
743 
744 
745 contract Pikachu is ERC20 {
746     constructor(uint256 startTime_, bytes32[] memory startup_, address builder_) ERC20("Pikachu", "PIKA", startTime_, startup_, builder_) {
747         _mint(builder_, 10e32);
748     }
749 }