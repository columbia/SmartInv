1 // SPDX-License-Identifier: GPL-3.0-or-later
2 // File: @openzeppelin/contracts/GSN/Context.sol
3 
4 pragma solidity ^0.6.0;
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
16 contract Context {
17     // Empty internal constructor, to prevent people from mistakenly deploying
18     // an instance of this contract, which should be used via inheritance.
19     constructor () internal { }
20 
21     function _msgSender() internal view virtual returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
32 
33 pragma solidity ^0.6.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP.
37  */
38 interface IERC20 {
39     /**
40      * @dev Returns the amount of tokens in existence.
41      */
42     function totalSupply() external view returns (uint256);
43 
44     /**
45      * @dev Returns the amount of tokens owned by `account`.
46      */
47     function balanceOf(address account) external view returns (uint256);
48 
49     /**
50      * @dev Moves `amount` tokens from the caller's account to `recipient`.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transfer(address recipient, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Returns the remaining number of tokens that `spender` will be
60      * allowed to spend on behalf of `owner` through {transferFrom}. This is
61      * zero by default.
62      *
63      * This value changes when {approve} or {transferFrom} are called.
64      */
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67     /**
68      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * IMPORTANT: Beware that changing an allowance with this method brings the risk
73      * that someone may use both the old and the new allowance by unfortunate
74      * transaction ordering. One possible solution to mitigate this race
75      * condition is to first reduce the spender's allowance to 0 and set the
76      * desired value afterwards:
77      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78      *
79      * Emits an {Approval} event.
80      */
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Moves `amount` tokens from `sender` to `recipient` using the
85      * allowance mechanism. `amount` is then deducted from the caller's
86      * allowance.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
93 
94     /**
95      * @dev Emitted when `value` tokens are moved from one account (`from`) to
96      * another (`to`).
97      *
98      * Note that `value` may be zero.
99      */
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     /**
103      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
104      * a call to {approve}. `value` is the new allowance.
105      */
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 // File: @openzeppelin/contracts/math/SafeMath.sol
110 
111 pragma solidity ^0.6.0;
112 
113 /**
114  * @dev Wrappers over Solidity's arithmetic operations with added overflow
115  * checks.
116  *
117  * Arithmetic operations in Solidity wrap on overflow. This can easily result
118  * in bugs, because programmers usually assume that an overflow raises an
119  * error, which is the standard behavior in high level programming languages.
120  * `SafeMath` restores this intuition by reverting the transaction when an
121  * operation overflows.
122  *
123  * Using this library instead of the unchecked operations eliminates an entire
124  * class of bugs, so it's recommended to use it always.
125  */
126 library SafeMath {
127     /**
128      * @dev Returns the addition of two unsigned integers, reverting on
129      * overflow.
130      *
131      * Counterpart to Solidity's `+` operator.
132      *
133      * Requirements:
134      * - Addition cannot overflow.
135      */
136     function add(uint256 a, uint256 b) internal pure returns (uint256) {
137         uint256 c = a + b;
138         require(c >= a, "SafeMath: addition overflow");
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting on
145      * overflow (when the result is negative).
146      *
147      * Counterpart to Solidity's `-` operator.
148      *
149      * Requirements:
150      * - Subtraction cannot overflow.
151      */
152     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
153         return sub(a, b, "SafeMath: subtraction overflow");
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * Counterpart to Solidity's `-` operator.
161      *
162      * Requirements:
163      * - Subtraction cannot overflow.
164      */
165     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
166         require(b <= a, errorMessage);
167         uint256 c = a - b;
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the multiplication of two unsigned integers, reverting on
174      * overflow.
175      *
176      * Counterpart to Solidity's `*` operator.
177      *
178      * Requirements:
179      * - Multiplication cannot overflow.
180      */
181     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
182         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
183         // benefit is lost if 'b' is also tested.
184         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
185         if (a == 0) {
186             return 0;
187         }
188 
189         uint256 c = a * b;
190         require(c / a == b, "SafeMath: multiplication overflow");
191 
192         return c;
193     }
194 
195     /**
196      * @dev Returns the integer division of two unsigned integers. Reverts on
197      * division by zero. The result is rounded towards zero.
198      *
199      * Counterpart to Solidity's `/` operator. Note: this function uses a
200      * `revert` opcode (which leaves remaining gas untouched) while Solidity
201      * uses an invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      * - The divisor cannot be zero.
205      */
206     function div(uint256 a, uint256 b) internal pure returns (uint256) {
207         return div(a, b, "SafeMath: division by zero");
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      * - The divisor cannot be zero.
220      */
221     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
222         // Solidity only automatically asserts when dividing by 0
223         require(b > 0, errorMessage);
224         uint256 c = a / b;
225         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
226 
227         return c;
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * Reverts when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      * - The divisor cannot be zero.
240      */
241     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
242         return mod(a, b, "SafeMath: modulo by zero");
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247      * Reverts with custom message when dividing by zero.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      * - The divisor cannot be zero.
255      */
256     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         require(b != 0, errorMessage);
258         return a % b;
259     }
260 }
261 
262 // File: @openzeppelin/contracts/utils/Address.sol
263 
264 pragma solidity ^0.6.2;
265 
266 /**
267  * @dev Collection of functions related to the address type
268  */
269 library Address {
270     /**
271      * @dev Returns true if `account` is a contract.
272      *
273      * [IMPORTANT]
274      * ====
275      * It is unsafe to assume that an address for which this function returns
276      * false is an externally-owned account (EOA) and not a contract.
277      *
278      * Among others, `isContract` will return false for the following
279      * types of addresses:
280      *
281      *  - an externally-owned account
282      *  - a contract in construction
283      *  - an address where a contract will be created
284      *  - an address where a contract lived, but was destroyed
285      * ====
286      */
287     function isContract(address account) internal view returns (bool) {
288         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
289         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
290         // for accounts without code, i.e. `keccak256('')`
291         bytes32 codehash;
292         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
293         // solhint-disable-next-line no-inline-assembly
294         assembly { codehash := extcodehash(account) }
295         return (codehash != accountHash && codehash != 0x0);
296     }
297 
298     /**
299      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
300      * `recipient`, forwarding all available gas and reverting on errors.
301      *
302      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
303      * of certain opcodes, possibly making contracts go over the 2300 gas limit
304      * imposed by `transfer`, making them unable to receive funds via
305      * `transfer`. {sendValue} removes this limitation.
306      *
307      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
308      *
309      * IMPORTANT: because control is transferred to `recipient`, care must be
310      * taken to not create reentrancy vulnerabilities. Consider using
311      * {ReentrancyGuard} or the
312      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
313      */
314     function sendValue(address payable recipient, uint256 amount) internal {
315         require(address(this).balance >= amount, "Address: insufficient balance");
316 
317         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
318         (bool success, ) = recipient.call{ value: amount }("");
319         require(success, "Address: unable to send value, recipient may have reverted");
320     }
321 }
322 
323 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
324 
325 pragma solidity ^0.6.0;
326 
327 
328 
329 
330 
331 /**
332  * @dev Implementation of the {IERC20} interface.
333  *
334  * This implementation is agnostic to the way tokens are created. This means
335  * that a supply mechanism has to be added in a derived contract using {_mint}.
336  * For a generic mechanism see {ERC20MinterPauser}.
337  *
338  * TIP: For a detailed writeup see our guide
339  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
340  * to implement supply mechanisms].
341  *
342  * We have followed general OpenZeppelin guidelines: functions revert instead
343  * of returning `false` on failure. This behavior is nonetheless conventional
344  * and does not conflict with the expectations of ERC20 applications.
345  *
346  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
347  * This allows applications to reconstruct the allowance for all accounts just
348  * by listening to said events. Other implementations of the EIP may not emit
349  * these events, as it isn't required by the specification.
350  *
351  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
352  * functions have been added to mitigate the well-known issues around setting
353  * allowances. See {IERC20-approve}.
354  */
355 contract ERC20 is Context, IERC20 {
356     using SafeMath for uint256;
357     using Address for address;
358 
359     mapping (address => uint256) private _balances;
360 
361     mapping (address => mapping (address => uint256)) private _allowances;
362 
363     uint256 private _totalSupply;
364 
365     string private _name;
366     string private _symbol;
367     uint8 private _decimals;
368 
369     /**
370      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
371      * a default value of 18.
372      *
373      * To select a different value for {decimals}, use {_setupDecimals}.
374      *
375      * All three of these values are immutable: they can only be set once during
376      * construction.
377      */
378     constructor (string memory name, string memory symbol) public {
379         _name = name;
380         _symbol = symbol;
381         _decimals = 18;
382     }
383 
384     /**
385      * @dev Returns the name of the token.
386      */
387     function name() public view returns (string memory) {
388         return _name;
389     }
390 
391     /**
392      * @dev Returns the symbol of the token, usually a shorter version of the
393      * name.
394      */
395     function symbol() public view returns (string memory) {
396         return _symbol;
397     }
398 
399     /**
400      * @dev Returns the number of decimals used to get its user representation.
401      * For example, if `decimals` equals `2`, a balance of `505` tokens should
402      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
403      *
404      * Tokens usually opt for a value of 18, imitating the relationship between
405      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
406      * called.
407      *
408      * NOTE: This information is only used for _display_ purposes: it in
409      * no way affects any of the arithmetic of the contract, including
410      * {IERC20-balanceOf} and {IERC20-transfer}.
411      */
412     function decimals() public view returns (uint8) {
413         return _decimals;
414     }
415 
416     /**
417      * @dev See {IERC20-totalSupply}.
418      */
419     function totalSupply() public view override returns (uint256) {
420         return _totalSupply;
421     }
422 
423     /**
424      * @dev See {IERC20-balanceOf}.
425      */
426     function balanceOf(address account) public view override returns (uint256) {
427         return _balances[account];
428     }
429 
430     /**
431      * @dev See {IERC20-transfer}.
432      *
433      * Requirements:
434      *
435      * - `recipient` cannot be the zero address.
436      * - the caller must have a balance of at least `amount`.
437      */
438     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
439         _transfer(_msgSender(), recipient, amount);
440         return true;
441     }
442 
443     /**
444      * @dev See {IERC20-allowance}.
445      */
446     function allowance(address owner, address spender) public view virtual override returns (uint256) {
447         return _allowances[owner][spender];
448     }
449 
450     /**
451      * @dev See {IERC20-approve}.
452      *
453      * Requirements:
454      *
455      * - `spender` cannot be the zero address.
456      */
457     function approve(address spender, uint256 amount) public virtual override returns (bool) {
458         _approve(_msgSender(), spender, amount);
459         return true;
460     }
461 
462     /**
463      * @dev See {IERC20-transferFrom}.
464      *
465      * Emits an {Approval} event indicating the updated allowance. This is not
466      * required by the EIP. See the note at the beginning of {ERC20};
467      *
468      * Requirements:
469      * - `sender` and `recipient` cannot be the zero address.
470      * - `sender` must have a balance of at least `amount`.
471      * - the caller must have allowance for ``sender``'s tokens of at least
472      * `amount`.
473      */
474     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
475         _transfer(sender, recipient, amount);
476         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
477         return true;
478     }
479 
480     /**
481      * @dev Atomically increases the allowance granted to `spender` by the caller.
482      *
483      * This is an alternative to {approve} that can be used as a mitigation for
484      * problems described in {IERC20-approve}.
485      *
486      * Emits an {Approval} event indicating the updated allowance.
487      *
488      * Requirements:
489      *
490      * - `spender` cannot be the zero address.
491      */
492     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
493         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
494         return true;
495     }
496 
497     /**
498      * @dev Atomically decreases the allowance granted to `spender` by the caller.
499      *
500      * This is an alternative to {approve} that can be used as a mitigation for
501      * problems described in {IERC20-approve}.
502      *
503      * Emits an {Approval} event indicating the updated allowance.
504      *
505      * Requirements:
506      *
507      * - `spender` cannot be the zero address.
508      * - `spender` must have allowance for the caller of at least
509      * `subtractedValue`.
510      */
511     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
512         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
513         return true;
514     }
515 
516     /**
517      * @dev Moves tokens `amount` from `sender` to `recipient`.
518      *
519      * This is internal function is equivalent to {transfer}, and can be used to
520      * e.g. implement automatic token fees, slashing mechanisms, etc.
521      *
522      * Emits a {Transfer} event.
523      *
524      * Requirements:
525      *
526      * - `sender` cannot be the zero address.
527      * - `recipient` cannot be the zero address.
528      * - `sender` must have a balance of at least `amount`.
529      */
530     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
531         require(sender != address(0), "ERC20: transfer from the zero address");
532         require(recipient != address(0), "ERC20: transfer to the zero address");
533 
534         _beforeTokenTransfer(sender, recipient, amount);
535 
536         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
537         _balances[recipient] = _balances[recipient].add(amount);
538         emit Transfer(sender, recipient, amount);
539     }
540 
541     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
542      * the total supply.
543      *
544      * Emits a {Transfer} event with `from` set to the zero address.
545      *
546      * Requirements
547      *
548      * - `to` cannot be the zero address.
549      */
550     function _mint(address account, uint256 amount) internal virtual {
551         require(account != address(0), "ERC20: mint to the zero address");
552 
553         _beforeTokenTransfer(address(0), account, amount);
554 
555         _totalSupply = _totalSupply.add(amount);
556         _balances[account] = _balances[account].add(amount);
557         emit Transfer(address(0), account, amount);
558     }
559 
560     /**
561      * @dev Destroys `amount` tokens from `account`, reducing the
562      * total supply.
563      *
564      * Emits a {Transfer} event with `to` set to the zero address.
565      *
566      * Requirements
567      *
568      * - `account` cannot be the zero address.
569      * - `account` must have at least `amount` tokens.
570      */
571     function _burn(address account, uint256 amount) internal virtual {
572         require(account != address(0), "ERC20: burn from the zero address");
573 
574         _beforeTokenTransfer(account, address(0), amount);
575 
576         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
577         _totalSupply = _totalSupply.sub(amount);
578         emit Transfer(account, address(0), amount);
579     }
580 
581     /**
582      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
583      *
584      * This is internal function is equivalent to `approve`, and can be used to
585      * e.g. set automatic allowances for certain subsystems, etc.
586      *
587      * Emits an {Approval} event.
588      *
589      * Requirements:
590      *
591      * - `owner` cannot be the zero address.
592      * - `spender` cannot be the zero address.
593      */
594     function _approve(address owner, address spender, uint256 amount) internal virtual {
595         require(owner != address(0), "ERC20: approve from the zero address");
596         require(spender != address(0), "ERC20: approve to the zero address");
597 
598         _allowances[owner][spender] = amount;
599         emit Approval(owner, spender, amount);
600     }
601 
602     /**
603      * @dev Sets {decimals} to a value other than the default one of 18.
604      *
605      * WARNING: This function should only be called from the constructor. Most
606      * applications that interact with token contracts will not expect
607      * {decimals} to ever change, and may work incorrectly if it does.
608      */
609     function _setupDecimals(uint8 decimals_) internal {
610         _decimals = decimals_;
611     }
612 
613     /**
614      * @dev Hook that is called before any transfer of tokens. This includes
615      * minting and burning.
616      *
617      * Calling conditions:
618      *
619      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
620      * will be to transferred to `to`.
621      * - when `from` is zero, `amount` tokens will be minted for `to`.
622      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
623      * - `from` and `to` are never both zero.
624      *
625      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
626      */
627     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
628 }
629 
630 // File: @openzeppelin/contracts/access/Ownable.sol
631 
632 pragma solidity ^0.6.0;
633 
634 /**
635  * @dev Contract module which provides a basic access control mechanism, where
636  * there is an account (an owner) that can be granted exclusive access to
637  * specific functions.
638  *
639  * By default, the owner account will be the one that deploys the contract. This
640  * can later be changed with {transferOwnership}.
641  *
642  * This module is used through inheritance. It will make available the modifier
643  * `onlyOwner`, which can be applied to your functions to restrict their use to
644  * the owner.
645  */
646 contract Ownable is Context {
647     address private _owner;
648 
649     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
650 
651     /**
652      * @dev Initializes the contract setting the deployer as the initial owner.
653      */
654     constructor () internal {
655         address msgSender = _msgSender();
656         _owner = msgSender;
657         emit OwnershipTransferred(address(0), msgSender);
658     }
659 
660     /**
661      * @dev Returns the address of the current owner.
662      */
663     function owner() public view returns (address) {
664         return _owner;
665     }
666 
667     /**
668      * @dev Throws if called by any account other than the owner.
669      */
670     modifier onlyOwner() {
671         require(_owner == _msgSender(), "Ownable: caller is not the owner");
672         _;
673     }
674 
675     /**
676      * @dev Leaves the contract without owner. It will not be possible to call
677      * `onlyOwner` functions anymore. Can only be called by the current owner.
678      *
679      * NOTE: Renouncing ownership will leave the contract without an owner,
680      * thereby removing any functionality that is only available to the owner.
681      */
682     function renounceOwnership() public virtual onlyOwner {
683         emit OwnershipTransferred(_owner, address(0));
684         _owner = address(0);
685     }
686 
687     /**
688      * @dev Transfers ownership of the contract to a new account (`newOwner`).
689      * Can only be called by the current owner.
690      */
691     function transferOwnership(address newOwner) public virtual onlyOwner {
692         require(newOwner != address(0), "Ownable: new owner is the zero address");
693         emit OwnershipTransferred(_owner, newOwner);
694         _owner = newOwner;
695     }
696 }
697 
698 // File: @chainlink/contracts/src/v0.6/dev/AggregatorInterface.sol
699 
700 pragma solidity ^0.6.0;
701 
702 interface AggregatorInterface {
703   function latestAnswer() external view returns (int256);
704   function latestTimestamp() external view returns (uint256);
705   function latestRound() external view returns (uint256);
706   function getAnswer(uint256 roundId) external view returns (int256);
707   function getTimestamp(uint256 roundId) external view returns (uint256);
708 
709   event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 timestamp);
710   event NewRound(uint256 indexed roundId, address indexed startedBy, uint256 startedAt);
711 }
712 
713 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
714 
715 pragma solidity >=0.6.2;
716 
717 interface IUniswapV2Router01 {
718     function factory() external pure returns (address);
719     function WETH() external pure returns (address);
720 
721     function addLiquidity(
722         address tokenA,
723         address tokenB,
724         uint amountADesired,
725         uint amountBDesired,
726         uint amountAMin,
727         uint amountBMin,
728         address to,
729         uint deadline
730     ) external returns (uint amountA, uint amountB, uint liquidity);
731     function addLiquidityETH(
732         address token,
733         uint amountTokenDesired,
734         uint amountTokenMin,
735         uint amountETHMin,
736         address to,
737         uint deadline
738     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
739     function removeLiquidity(
740         address tokenA,
741         address tokenB,
742         uint liquidity,
743         uint amountAMin,
744         uint amountBMin,
745         address to,
746         uint deadline
747     ) external returns (uint amountA, uint amountB);
748     function removeLiquidityETH(
749         address token,
750         uint liquidity,
751         uint amountTokenMin,
752         uint amountETHMin,
753         address to,
754         uint deadline
755     ) external returns (uint amountToken, uint amountETH);
756     function removeLiquidityWithPermit(
757         address tokenA,
758         address tokenB,
759         uint liquidity,
760         uint amountAMin,
761         uint amountBMin,
762         address to,
763         uint deadline,
764         bool approveMax, uint8 v, bytes32 r, bytes32 s
765     ) external returns (uint amountA, uint amountB);
766     function removeLiquidityETHWithPermit(
767         address token,
768         uint liquidity,
769         uint amountTokenMin,
770         uint amountETHMin,
771         address to,
772         uint deadline,
773         bool approveMax, uint8 v, bytes32 r, bytes32 s
774     ) external returns (uint amountToken, uint amountETH);
775     function swapExactTokensForTokens(
776         uint amountIn,
777         uint amountOutMin,
778         address[] calldata path,
779         address to,
780         uint deadline
781     ) external returns (uint[] memory amounts);
782     function swapTokensForExactTokens(
783         uint amountOut,
784         uint amountInMax,
785         address[] calldata path,
786         address to,
787         uint deadline
788     ) external returns (uint[] memory amounts);
789     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
790         external
791         payable
792         returns (uint[] memory amounts);
793     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
794         external
795         returns (uint[] memory amounts);
796     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
797         external
798         returns (uint[] memory amounts);
799     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
800         external
801         payable
802         returns (uint[] memory amounts);
803 
804     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
805     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
806     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
807     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
808     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
809 }
810 
811 // File: contracts/Interfaces.sol
812 
813 /**
814  * Hegic
815  * Copyright (C) 2020 Hegic Protocol
816  *
817  * This program is free software: you can redistribute it and/or modify
818  * it under the terms of the GNU General Public License as published by
819  * the Free Software Foundation, either version 3 of the License, or
820  * (at your option) any later version.
821  *
822  * This program is distributed in the hope that it will be useful,
823  * but WITHOUT ANY WARRANTY; without even the implied warranty of
824  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
825  * GNU General Public License for more details.
826  *
827  * You should have received a copy of the GNU General Public License
828  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
829  */
830 
831 pragma solidity 0.6.8;
832 
833 
834 
835 
836 
837 
838 interface ILiquidityPool {
839     event Withdraw(
840         address indexed account,
841         uint256 amount,
842         uint256 writeAmount
843     );
844 
845     event Provide(address indexed account, uint256 amount, uint256 writeAmount);
846     function lock(uint256 amount) external;
847     function unlock(uint256 amount) external;
848     function unlockPremium(uint256 amount) external;
849     function send(address payable account, uint256 amount) external;
850     function setLockupPeriod(uint value) external;
851     function totalBalance() external view returns (uint256 amount);
852 }
853 
854 
855 interface IERCLiquidityPool is ILiquidityPool {
856     function sendPremium(uint256 amount) external;
857     function token() external view returns (IERC20);
858 }
859 
860 
861 interface IETHLiquidityPool is ILiquidityPool {
862     function sendPremium() external payable;
863 }
864 
865 
866 // for the future
867 // interface ERC20Incorrect {
868 //     event Transfer(address indexed from, address indexed to, uint256 value);
869 //
870 //     event Approval(address indexed owner, address indexed spender, uint256 value);
871 //
872 //     function transfer(address to, uint256 value) external;
873 //
874 //     function transferFrom(
875 //         address from,
876 //         address to,
877 //         uint256 value
878 //     ) external;
879 //
880 //     function approve(address spender, uint256 value) external;
881 //     function balanceOf(address who) external view returns (uint256);
882 //     function allowance(address owner, address spender) external view returns (uint256);
883 //
884 // }
885 
886 // File: contracts/HegicERCPool.sol
887 
888 /**
889  * Hegic
890  * Copyright (C) 2020 Hegic Protocol
891  *
892  * This program is free software: you can redistribute it and/or modify
893  * it under the terms of the GNU General Public License as published by
894  * the Free Software Foundation, either version 3 of the License, or
895  * (at your option) any later version.
896  *
897  * This program is distributed in the hope that it will be useful,
898  * but WITHOUT ANY WARRANTY; without even the implied warranty of
899  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
900  * GNU General Public License for more details.
901  *
902  * You should have received a copy of the GNU General Public License
903  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
904  */
905 
906 pragma solidity 0.6.8;
907 
908 
909 
910 /**
911  * @author 0mllwntrmt3
912  * @title Hegic DAI Liquidity Pool
913  * @notice Accumulates liquidity in DAI from LPs and distributes P&L in DAI
914  */
915 contract HegicERCPool is
916     IERCLiquidityPool,
917     Ownable,
918     ERC20("Hegic DAI LP Token", "writeDAI")
919 {
920     using SafeMath for uint256;
921     uint256 public lockupPeriod = 2 weeks;
922     uint256 public lockedAmount;
923     uint256 public lockedPremium;
924     mapping(address => uint256) private lastProvideTimestamp;
925     IERC20 public override token;
926 
927     /*
928      * @return _token DAI Address
929      */
930     constructor(IERC20 _token) public {
931         token = _token;
932     }
933 
934     /**
935      * @notice Used for changing the lockup period
936      * @param value New period value
937      */
938     function setLockupPeriod(uint256 value) external override onlyOwner {
939         require(value <= 60 days, "Lockup period is too large");
940         lockupPeriod = value;
941     }
942 
943     /*
944      * @nonce calls by HegicPutOptions to lock funds
945      * @param amount Amount of funds that should be locked in an option
946      */
947     function lock(uint256 amount) external override onlyOwner {
948         require(
949             lockedAmount.add(amount).mul(10).div(totalBalance()) < 8,
950             "Pool Error: Not enough funds on the pool contract. Please lower the amount."
951         );
952         lockedAmount = lockedAmount.add(amount);
953     }
954 
955     /*
956      * @nonce Calls by HegicPutOptions to unlock funds
957      * @param amount Amount of funds that should be unlocked in an expired option
958      */
959     function unlock(uint256 amount) external override onlyOwner {
960         require(lockedAmount >= amount, "Pool Error: You are trying to unlock more funds than have been locked for your contract. Please lower the amount.");
961         lockedAmount = lockedAmount.sub(amount);
962     }
963 
964     /*
965      * @nonce Calls by HegicPutOptions to send and lock the premiums
966      * @param amount Funds that should be locked
967      */
968     function sendPremium(uint256 amount) external override onlyOwner {
969         lockedPremium = lockedPremium.add(amount);
970         require(
971             token.transferFrom(msg.sender, address(this), amount),
972             "Token transfer error: Please lower the amount of premiums that you want to send."
973         );
974     }
975 
976     /*
977      * @nonce Calls by HegicPutOptions to unlock premium after an option expiraton
978      * @param amount Amount of premiums that should be locked
979      */
980     function unlockPremium(uint256 amount) external override onlyOwner {
981         require(lockedPremium >= amount, "Pool Error: You are trying to unlock more premiums than have been locked for the contract. Please lower the amount.");
982         lockedPremium = lockedPremium.sub(amount);
983     }
984 
985     /*
986      * @nonce calls by HegicPutOptions to unlock the premiums after an option's expiraton
987      * @param to Provider
988      * @param amount Amount of premiums that should be unlocked
989      */
990     function send(address payable to, uint256 amount)
991         external
992         override
993         onlyOwner
994     {
995         require(to != address(0));
996         require(lockedAmount >= amount, "Pool Error: You are trying to unlock more premiums than have been locked for the contract. Please lower the amount.");
997         require(token.transfer(to, amount), "Token transfer error: Please lower the amount of premiums that you want to send.");
998     }
999 
1000     /*
1001      * @nonce A provider supplies DAI to the pool and receives writeDAI tokens
1002      * @param amount Provided tokens
1003      * @param minMint Minimum amount of tokens that should be received by a provider.
1004                       Calling the provide function will require the minimum amount of tokens to be minted.
1005                       The actual amount that will be minted could vary but can only be higher (not lower) than the minimum value.
1006      * @return mint Amount of tokens to be received
1007      */
1008     function provide(uint256 amount, uint256 minMint) external returns (uint256 mint) {
1009         lastProvideTimestamp[msg.sender] = now;
1010         uint supply = totalSupply();
1011         uint balance = totalBalance();
1012         if (supply > 0 && balance > 0)
1013             mint = amount.mul(supply).div(balance);
1014         else
1015             mint = amount.mul(1000);
1016 
1017         require(mint >= minMint, "Pool: Mint limit is too large");
1018         require(mint > 0, "Pool: Amount is too small");
1019         _mint(msg.sender, mint);
1020         emit Provide(msg.sender, amount, mint);
1021 
1022         require(
1023             token.transferFrom(msg.sender, address(this), amount),
1024             "Token transfer error: Please lower the amount of premiums that you want to send."
1025         );
1026     }
1027 
1028     /*
1029      * @nonce Provider burns writeDAI and receives DAI from the pool
1030      * @param amount Amount of DAI to receive
1031      * @param maxBurn Maximum amount of tokens that can be burned
1032      * @return mint Amount of tokens to be burnt
1033      */
1034     function withdraw(uint256 amount, uint256 maxBurn) external returns (uint256 burn) {
1035         require(
1036             lastProvideTimestamp[msg.sender].add(lockupPeriod) <= now,
1037             "Pool: Withdrawal is locked up"
1038         );
1039         require(
1040             amount <= availableBalance(),
1041             "Pool Error: You are trying to unlock more funds than have been locked for your contract. Please lower the amount."
1042         );
1043         burn = amount.mul(totalSupply()).div(totalBalance());
1044 
1045         require(burn <= maxBurn, "Pool: Burn limit is too small");
1046         require(burn <= balanceOf(msg.sender), "Pool: Amount is too large");
1047         require(burn > 0, "Pool: Amount is too small");
1048 
1049         _burn(msg.sender, burn);
1050         emit Withdraw(msg.sender, amount, burn);
1051         require(token.transfer(msg.sender, amount), "Insufficient funds");
1052     }
1053 
1054     /*
1055      * @nonce Returns provider's share in DAI
1056      * @param account Provider's address
1057      * @return Provider's share in DAI
1058      */
1059     function shareOf(address user) external view returns (uint256 share) {
1060         uint supply = totalSupply();
1061         if (supply > 0)
1062             share = totalBalance().mul(balanceOf(user)).div(supply);
1063         else
1064             share = 0;
1065     }
1066 
1067     /*
1068      * @nonce Returns the amount of DAI available for withdrawals
1069      * @return balance Unlocked amount
1070      */
1071     function availableBalance() public view returns (uint256 balance) {
1072         return totalBalance().sub(lockedAmount);
1073     }
1074 
1075     /*
1076      * @nonce Returns the DAI total balance provided to the pool
1077      * @return balance Pool balance
1078      */
1079     function totalBalance() public override view returns (uint256 balance) {
1080         return token.balanceOf(address(this)).sub(lockedPremium);
1081     }
1082 
1083     function _beforeTokenTransfer(address from, address, uint256) internal override {
1084         require(
1085             lastProvideTimestamp[from].add(lockupPeriod) <= now,
1086             "Pool: Withdrawal is locked up"
1087         );
1088     }
1089 }
1090 
1091 // File: contracts/HegicETHPool.sol
1092 
1093 /**
1094  * Hegic
1095  * Copyright (C) 2020 Hegic Protocol
1096  *
1097  * This program is free software: you can redistribute it and/or modify
1098  * it under the terms of the GNU General Public License as published by
1099  * the Free Software Foundation, either version 3 of the License, or
1100  * (at your option) any later version.
1101  *
1102  * This program is distributed in the hope that it will be useful,
1103  * but WITHOUT ANY WARRANTY; without even the implied warranty of
1104  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1105  * GNU General Public License for more details.
1106  *
1107  * You should have received a copy of the GNU General Public License
1108  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
1109  */
1110 
1111 pragma solidity 0.6.8;
1112 
1113 
1114 
1115 /**
1116  * @author 0mllwntrmt3
1117  * @title Hegic ETH Liquidity Pool
1118  * @notice Accumulates liquidity in ETH from LPs and distributes P&L in ETH
1119  */
1120 contract HegicETHPool is
1121     IETHLiquidityPool,
1122     Ownable,
1123     ERC20("Hegic ETH LP Token", "writeETH")
1124 {
1125     using SafeMath for uint256;
1126     uint256 public lockupPeriod = 2 weeks;
1127     uint256 public lockedAmount;
1128     uint256 public lockedPremium;
1129     mapping(address => uint256) private lastProvideTimestamp;
1130 
1131     /*
1132      * @nonce Sends premiums to the liquidity pool
1133      **/
1134     receive() external payable {}
1135 
1136     /**
1137      * @notice Used for changing the lockup period
1138      * @param value New period value
1139      */
1140     function setLockupPeriod(uint256 value) external override onlyOwner {
1141         require(value <= 60 days, "Lockup period is too large");
1142         lockupPeriod = value;
1143     }
1144 
1145     /*
1146      * @nonce A provider supplies ETH to the pool and receives writeETH tokens
1147      * @param minMint Minimum amount of tokens that should be received by a provider.
1148                       Calling the provide function will require the minimum amount of tokens to be minted.
1149                       The actual amount that will be minted could vary but can only be higher (not lower) than the minimum value.
1150      * @return mint Amount of tokens to be received
1151      */
1152     function provide(uint256 minMint) external payable returns (uint256 mint) {
1153         lastProvideTimestamp[msg.sender] = now;
1154         uint supply = totalSupply();
1155         uint balance = totalBalance();
1156         if (supply > 0 && balance > 0)
1157             mint = msg.value.mul(supply).div(balance.sub(msg.value));
1158         else
1159             mint = msg.value.mul(1000);
1160 
1161         require(mint >= minMint, "Pool: Mint limit is too large");
1162         require(mint > 0, "Pool: Amount is too small");
1163 
1164         _mint(msg.sender, mint);
1165         emit Provide(msg.sender, msg.value, mint);
1166     }
1167 
1168     /*
1169      * @nonce Provider burns writeETH and receives ETH from the pool
1170      * @param amount Amount of ETH to receive
1171      * @return burn Amount of tokens to be burnt
1172      */
1173     function withdraw(uint256 amount, uint256 maxBurn) external returns (uint256 burn) {
1174         require(
1175             lastProvideTimestamp[msg.sender].add(lockupPeriod) <= now,
1176             "Pool: Withdrawal is locked up"
1177         );
1178         require(
1179             amount <= availableBalance(),
1180             "Pool Error: Not enough funds on the pool contract. Please lower the amount."
1181         );
1182         burn = amount.mul(totalSupply()).div(totalBalance());
1183 
1184         require(burn <= maxBurn, "Pool: Burn limit is too small");
1185         require(burn <= balanceOf(msg.sender), "Pool: Amount is too large");
1186         require(burn > 0, "Pool: Amount is too small");
1187 
1188         _burn(msg.sender, burn);
1189         emit Withdraw(msg.sender, amount, burn);
1190         msg.sender.transfer(amount);
1191     }
1192 
1193     /*
1194      * @nonce calls by HegicCallOptions to lock the funds
1195      * @param amount Amount of funds that should be locked in an option
1196      */
1197     function lock(uint256 amount) external override onlyOwner {
1198         require(
1199             lockedAmount.add(amount).mul(10).div(totalBalance()) < 8,
1200             "Pool Error: You are trying to unlock more funds than have been locked for your contract. Please lower the amount."
1201         );
1202         lockedAmount = lockedAmount.add(amount);
1203     }
1204 
1205     /*
1206      * @nonce calls by HegicCallOptions to unlock the funds
1207      * @param amount Amount of funds that should be unlocked in an expired option
1208      */
1209     function unlock(uint256 amount) external override onlyOwner {
1210         require(lockedAmount >= amount, "Pool Error: You are trying to unlock more funds than have been locked for your contract. Please lower the amount.");
1211         lockedAmount = lockedAmount.sub(amount);
1212     }
1213 
1214     /*
1215      * @nonce calls by HegicPutOptions to lock the premiums
1216      * @param amount Amount of premiums that should be locked
1217      */
1218     function sendPremium() external override payable onlyOwner {
1219         lockedPremium = lockedPremium.add(msg.value);
1220     }
1221 
1222     /*
1223      * @nonce calls by HegicPutOptions to unlock the premiums after an option's expiraton
1224      * @param amount Amount of premiums that should be unlocked
1225      */
1226     function unlockPremium(uint256 amount) external override onlyOwner {
1227         require(lockedPremium >= amount, "Pool Error: You are trying to unlock more premiums than have been locked for the contract. Please lower the amount.");
1228         lockedPremium = lockedPremium.sub(amount);
1229     }
1230 
1231     /*
1232      * @nonce calls by HegicCallOptions to send funds to liquidity providers after an option's expiration
1233      * @param to Provider
1234      * @param amount Funds that should be sent
1235      */
1236     function send(address payable to, uint256 amount)
1237         external
1238         override
1239         onlyOwner
1240     {
1241         require(to != address(0));
1242         require(lockedAmount >= amount, "Pool Error: You are trying to unlock more premiums than have been locked for the contract. Please lower the amount.");
1243         to.transfer(amount);
1244     }
1245 
1246     /*
1247      * @nonce Returns provider's share in ETH
1248      * @param account Provider's address
1249      * @return Provider's share in ETH
1250      */
1251     function shareOf(address account) external view returns (uint256 share) {
1252         if (totalSupply() > 0)
1253             share = totalBalance().mul(balanceOf(account)).div(totalSupply());
1254         else
1255             share = 0;
1256     }
1257 
1258     /*
1259      * @nonce Returns the amount of ETH available for withdrawals
1260      * @return balance Unlocked amount
1261      */
1262     function availableBalance() public view returns (uint256 balance) {
1263         return totalBalance().sub(lockedAmount);
1264     }
1265 
1266     /*
1267      * @nonce Returns the total balance of ETH provided to the pool
1268      * @return balance Pool balance
1269      */
1270     function totalBalance() public override view returns (uint256 balance) {
1271         return address(this).balance.sub(lockedPremium);
1272     }
1273 
1274     function _beforeTokenTransfer(address from, address, uint256) internal override {
1275         require(
1276             lastProvideTimestamp[from].add(lockupPeriod) <= now,
1277             "Pool: Withdrawal is locked up"
1278         );
1279     }
1280 }
1281 
1282 // File: contracts/HegicOptions.sol
1283 
1284 /**
1285  * Hegic
1286  * Copyright (C) 2020 Hegic Protocol
1287  *
1288  * This program is free software: you can redistribute it and/or modify
1289  * it under the terms of the GNU General Public License as published by
1290  * the Free Software Foundation, either version 3 of the License, or
1291  * (at your option) any later version.
1292  *
1293  * This program is distributed in the hope that it will be useful,
1294  * but WITHOUT ANY WARRANTY; without even the implied warranty of
1295  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1296  * GNU General Public License for more details.
1297  *
1298  * You should have received a copy of the GNU General Public License
1299  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
1300  */
1301 
1302 pragma solidity 0.6.8;
1303 
1304 
1305 
1306 
1307 /**
1308  * @author 0mllwntrmt3
1309  * @title Hegic: On-chain Options Trading Protocol on Ethereum
1310  * @notice Hegic Protocol Options Contract
1311  */
1312 abstract
1313 contract HegicOptions is Ownable {
1314     using SafeMath for uint256;
1315 
1316     address payable public settlementFeeRecipient;
1317     Option[] public options;
1318     uint256 public impliedVolRate;
1319     uint256 internal constant PRICE_DECIMALS = 1e8;
1320     uint256 internal contractCreationTimestamp;
1321     AggregatorInterface public priceProvider;
1322     OptionType private optionType;
1323 
1324     event Create(
1325         uint256 indexed id,
1326         address indexed account,
1327         uint256 settlementFee,
1328         uint256 totalFee
1329     );
1330 
1331     event Exercise(uint256 indexed id, uint256 profit);
1332     event Expire(uint256 indexed id, uint256 premium);
1333     enum State {Active, Exercised, Expired}
1334     enum OptionType {Put, Call}
1335 
1336     struct Option {
1337         State state;
1338         address payable holder;
1339         uint256 strike;
1340         uint256 amount;
1341         uint256 premium;
1342         uint256 expiration;
1343     }
1344 
1345     /**
1346      * @param pp The address of ChainLink ETH/USD price feed contract
1347      * @param _type Put or Call type of an option contract
1348      */
1349     constructor(AggregatorInterface pp, OptionType _type) public {
1350         priceProvider = pp;
1351         optionType = _type;
1352         settlementFeeRecipient = payable(owner());
1353         impliedVolRate = 5500;
1354         contractCreationTimestamp = now;
1355     }
1356 
1357     /**
1358      * @notice Used for adjusting the options prices while balancing asset's implied volatility rate
1359      * @param value New IVRate value
1360      */
1361     function setImpliedVolRate(uint256 value) external onlyOwner {
1362         require(value >= 1000, "ImpliedVolRate limit is too small");
1363         impliedVolRate = value;
1364     }
1365 
1366     /**
1367      * @notice Used for changing settlementFeeRecipient
1368      * @param recipient New settlementFee recipient address
1369      */
1370     function setSettlementFeeRecipient(address payable recipient) external onlyOwner {
1371         require(recipient != address(0));
1372         settlementFeeRecipient = recipient;
1373     }
1374 
1375     /**
1376      * @notice Creates a new option
1377      * @param period Option period in seconds (1 days <= period <= 4 weeks)
1378      * @param amount Option amount
1379      * @param strike Strike price of the option
1380      * @return optionID Created option's ID
1381      */
1382     function create(
1383         uint256 period,
1384         uint256 amount,
1385         uint256 strike
1386     ) external payable returns (uint256 optionID) {
1387         (uint256 total, uint256 settlementFee, , ) = fees(
1388             period,
1389             amount,
1390             strike
1391         );
1392         uint256 strikeAmount = strike.mul(amount) / PRICE_DECIMALS;
1393 
1394         require(strikeAmount > 0, "Amount is too small");
1395         require(settlementFee < total, "Premium is too small");
1396         require(period >= 1 days, "Period is too short");
1397         require(period <= 4 weeks, "Period is too long");
1398         require(msg.value == total, "Wrong value");
1399 
1400         uint256 premium = sendPremium(total.sub(settlementFee));
1401         optionID = options.length;
1402         options.push(
1403             Option(
1404                 State.Active,
1405                 msg.sender,
1406                 strike,
1407                 amount,
1408                 premium,
1409                 now + period
1410             )
1411         );
1412 
1413         emit Create(optionID, msg.sender, settlementFee, total);
1414         lockFunds(options[optionID]);
1415         settlementFeeRecipient.transfer(settlementFee);
1416     }
1417 
1418     /**
1419      * @notice Exercises an active option
1420      * @param optionID ID of your option
1421      */
1422     function exercise(uint256 optionID) external {
1423         Option storage option = options[optionID];
1424 
1425         require(option.expiration >= now, "Option has expired");
1426         require(option.holder == msg.sender, "Wrong msg.sender");
1427         require(option.state == State.Active, "Wrong state");
1428 
1429         option.state = State.Exercised;
1430         uint256 profit = payProfit(option);
1431 
1432         emit Exercise(optionID, profit);
1433     }
1434 
1435     /**
1436      * @notice Unlocks an array of options
1437      * @param optionIDs array of options
1438      */
1439     function unlockAll(uint256[] calldata optionIDs) external {
1440         uint arrayLength = optionIDs.length;
1441         for (uint256 i = 0; i < arrayLength; i++) {
1442             unlock(optionIDs[i]);
1443         }
1444     }
1445 
1446     /**
1447      * @notice Used for getting the actual options prices
1448      * @param period Option period in seconds (1 days <= period <= 4 weeks)
1449      * @param amount Option amount
1450      * @param strike Strike price of the option
1451      * @return total Total price to be paid
1452      * @return settlementFee Amount to be distributed to the HEGIC token holders
1453      * @return strikeFee Amount that covers the price difference in the ITM options
1454      * @return periodFee Option period fee amount
1455      */
1456     function fees(
1457         uint256 period,
1458         uint256 amount,
1459         uint256 strike
1460     )
1461         public
1462         view
1463         returns (
1464             uint256 total,
1465             uint256 settlementFee,
1466             uint256 strikeFee,
1467             uint256 periodFee
1468         )
1469     {
1470         uint256 currentPrice = uint256(priceProvider.latestAnswer());
1471         settlementFee = getSettlementFee(amount);
1472         periodFee = getPeriodFee(amount, period, strike, currentPrice);
1473         strikeFee = getStrikeFee(amount, strike, currentPrice);
1474         total = periodFee.add(strikeFee);
1475     }
1476 
1477     /**
1478      * @notice Unlock funds locked in the expired options
1479      * @param optionID ID of the option
1480      */
1481     function unlock(uint256 optionID) public {
1482         Option storage option = options[optionID];
1483         require(option.expiration < now, "Option has not expired yet");
1484         require(option.state == State.Active, "Option is not active");
1485         option.state = State.Expired;
1486         unlockFunds(option);
1487         emit Expire(optionID, option.premium);
1488     }
1489 
1490     /**
1491      * @notice Calculates settlementFee
1492      * @param amount Option amount
1493      * @return fee Settlement fee amount
1494      */
1495     function getSettlementFee(uint256 amount)
1496         internal
1497         pure
1498         returns (uint256 fee)
1499     {
1500         return amount / 100;
1501     }
1502 
1503     /**
1504      * @notice Calculates periodFee
1505      * @param amount Option amount
1506      * @param period Option period in seconds (1 days <= period <= 4 weeks)
1507      * @param strike Strike price of the option
1508      * @param currentPrice Current price of ETH
1509      * @return fee Period fee amount
1510      *
1511      * amount < 1e30        |
1512      * impliedVolRate < 1e10| => amount * impliedVolRate * strike < 1e60 < 2^uint256
1513      * strike < 1e20 ($1T)  |
1514      *
1515      * in case amount * impliedVolRate * strike >= 2^256
1516      * transaction will be reverted by the SafeMath
1517      */
1518     function getPeriodFee(
1519         uint256 amount,
1520         uint256 period,
1521         uint256 strike,
1522         uint256 currentPrice
1523     ) internal view returns (uint256 fee) {
1524         if (optionType == OptionType.Put)
1525             return amount
1526                 .mul(sqrt(period))
1527                 .mul(impliedVolRate)
1528                 .mul(strike)
1529                 .div(currentPrice)
1530                 .div(PRICE_DECIMALS);
1531         else
1532             return amount
1533                 .mul(sqrt(period))
1534                 .mul(impliedVolRate)
1535                 .mul(currentPrice)
1536                 .div(strike)
1537                 .div(PRICE_DECIMALS);
1538     }
1539 
1540     /**
1541      * @notice Calculates strikeFee
1542      * @param amount Option amount
1543      * @param strike Strike price of the option
1544      * @param currentPrice Current price of ETH
1545      * @return fee Strike fee amount
1546      */
1547     function getStrikeFee(
1548         uint256 amount,
1549         uint256 strike,
1550         uint256 currentPrice
1551     ) internal view returns (uint256 fee) {
1552         if (strike > currentPrice && optionType == OptionType.Put)
1553             return strike.sub(currentPrice).mul(amount).div(currentPrice);
1554         if (strike < currentPrice && optionType == OptionType.Call)
1555             return currentPrice.sub(strike).mul(amount).div(currentPrice);
1556         return 0;
1557     }
1558 
1559     function sendPremium(uint256 amount)
1560         internal
1561         virtual
1562         returns (uint256 locked);
1563 
1564     function payProfit(Option memory option)
1565         internal
1566         virtual
1567         returns (uint256 amount);
1568 
1569     function lockFunds(Option memory option) internal virtual;
1570     function unlockFunds(Option memory option) internal virtual;
1571 
1572     /**
1573      * @return result Square root of the number
1574      */
1575     function sqrt(uint256 x) private pure returns (uint256 result) {
1576         result = x;
1577         uint256 k = x.add(1).div(2);
1578         while (k < result) (result, k) = (k, x.div(k).add(k).div(2));
1579     }
1580 }
1581 
1582 // File: contracts/HegicCallOptions.sol
1583 
1584 /**
1585  * Hegic
1586  * Copyright (C) 2020 Hegic Protocol
1587  *
1588  * This program is free software: you can redistribute it and/or modify
1589  * it under the terms of the GNU General Public License as published by
1590  * the Free Software Foundation, either version 3 of the License, or
1591  * (at your option) any later version.
1592  *
1593  * This program is distributed in the hope that it will be useful,
1594  * but WITHOUT ANY WARRANTY; without even the implied warranty of
1595  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1596  * GNU General Public License for more details.
1597  *
1598  * You should have received a copy of the GNU General Public License
1599  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
1600  */
1601 
1602 pragma solidity 0.6.8;
1603 
1604 
1605 
1606 /**
1607  * @author 0mllwntrmt3
1608  * @title Hegic ETH Call Options
1609  * @notice ETH Call Options Contract
1610  */
1611 contract HegicCallOptions is HegicOptions {
1612     HegicETHPool public pool;
1613 
1614     /**
1615      * @param _priceProvider The address of ChainLink ETH/USD price feed contract
1616      */
1617     constructor(AggregatorInterface _priceProvider)
1618         public
1619         HegicOptions(_priceProvider, HegicOptions.OptionType.Call)
1620     {
1621         pool = new HegicETHPool();
1622     }
1623 
1624     /**
1625      * @notice Can be used to update the contract in critical situations in the first 90 days after deployment
1626      */
1627     function transferPoolOwnership() external onlyOwner {
1628         require(now < contractCreationTimestamp + 90 days);
1629         pool.transferOwnership(owner());
1630     }
1631 
1632     /**
1633      * @notice Used for changing the lockup period
1634      * @param value New period value
1635      */
1636     function setLockupPeriod(uint256 value) external onlyOwner {
1637         require(value <= 60 days, "Lockup period is too large");
1638         pool.setLockupPeriod(value);
1639     }
1640 
1641     /**
1642      * @notice Sends premiums to the ETH liquidity pool contract
1643      * @param amount The amount of premiums that will be sent to the pool
1644      */
1645     function sendPremium(uint amount) internal override returns (uint locked) {
1646         pool.sendPremium {value: amount}();
1647         locked = amount;
1648     }
1649 
1650     /**
1651      * @notice Locks the amount required for an option
1652      * @param option A specific option contract
1653      */
1654     function lockFunds(Option memory option) internal override {
1655         pool.lock(option.amount);
1656     }
1657 
1658     /**
1659      * @notice Sends profits in ETH from the ETH pool to a call option holder's address
1660      * @param option A specific option contract
1661      */
1662     function payProfit(Option memory option)
1663         internal
1664         override
1665         returns (uint profit)
1666     {
1667         uint currentPrice = uint(priceProvider.latestAnswer());
1668         require(option.strike <= currentPrice, "Current price is too low");
1669         profit = currentPrice.sub(option.strike).mul(option.amount).div(currentPrice);
1670         pool.send(option.holder, profit);
1671         unlockFunds(option);
1672     }
1673 
1674     /**
1675      * @notice Unlocks the amount that was locked in a call option contract
1676      * @param option A specific option contract
1677      */
1678     function unlockFunds(Option memory option) internal override {
1679         pool.unlockPremium(option.premium);
1680         pool.unlock(option.amount);
1681     }
1682 }
1683 
1684 // File: contracts/HegicPutOptions.sol
1685 
1686 /**
1687  * Hegic
1688  * Copyright (C) 2020 Hegic Protocol
1689  *
1690  * This program is free software: you can redistribute it and/or modify
1691  * it under the terms of the GNU General Public License as published by
1692  * the Free Software Foundation, either version 3 of the License, or
1693  * (at your option) any later version.
1694  *
1695  * This program is distributed in the hope that it will be useful,
1696  * but WITHOUT ANY WARRANTY; without even the implied warranty of
1697  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1698  * GNU General Public License for more details.
1699  *
1700  * You should have received a copy of the GNU General Public License
1701  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
1702  */
1703 
1704 pragma solidity 0.6.8;
1705 
1706 
1707 
1708 /**
1709  * @author 0mllwntrmt3
1710  * @title Hegic ETH Put Options
1711  * @notice ETH Put Options Contract
1712  */
1713 contract HegicPutOptions is HegicOptions {
1714     IUniswapV2Router01 public uniswapRouter;
1715     HegicERCPool public pool;
1716     uint256 public maxSpread = 95;
1717     IERC20 internal token;
1718 
1719     /**
1720      * @param _token The address of stable ERC20 token contract
1721      * @param _priceProvider The address of ChainLink ETH/USD price feed contract
1722      * @param _uniswapRouter The address of Uniswap Router contract
1723      */
1724     constructor(
1725         IERC20 _token,
1726         AggregatorInterface _priceProvider,
1727         IUniswapV2Router01 _uniswapRouter
1728     )
1729         public
1730         HegicOptions(_priceProvider, HegicOptions.OptionType.Put)
1731     {
1732         token = _token;
1733         uniswapRouter = _uniswapRouter;
1734         pool = new HegicERCPool(token);
1735         approve();
1736     }
1737 
1738     /**
1739      * @notice Can be used to update the contract in critical situations
1740      *         in the first 90 days after deployment
1741      */
1742     function transferPoolOwnership() external onlyOwner {
1743         require(now < contractCreationTimestamp + 90 days);
1744         pool.transferOwnership(owner());
1745     }
1746 
1747     /**
1748      * @notice Used for adjusting the spread limit
1749      * @param value New maxSpread value
1750      */
1751     function setMaxSpread(uint256 value) external onlyOwner {
1752         require(value <= 95, "Spread limit is too small");
1753         maxSpread = value;
1754     }
1755 
1756     /**
1757      * @notice Used for changing the lockup period
1758      * @param value New period value
1759      */
1760     function setLockupPeriod(uint256 value) external onlyOwner {
1761         require(value <= 60 days, "Lockup period is too large");
1762         pool.setLockupPeriod(value);
1763     }
1764 
1765     /**
1766      * @notice Allows the ERC pool contract to receive and send tokens
1767      */
1768     function approve() public {
1769         require(
1770             token.approve(address(pool), uint256(-1)),
1771             "token approve failed"
1772         );
1773     }
1774 
1775     /**
1776      * @notice Sends premiums to the ERC liquidity pool contract
1777      */
1778     function sendPremium(uint256 amount) internal override returns (uint premium) {
1779         uint currentPrice = uint(priceProvider.latestAnswer());
1780         address[] memory path = new address[](2);
1781         path[0] = uniswapRouter.WETH();
1782         path[1] = address(token);
1783         uint[] memory amounts = uniswapRouter.swapExactETHForTokens {
1784             value: amount
1785         }(
1786             amount.mul(currentPrice).mul(maxSpread).div(1e10),
1787             path,
1788             address(this),
1789             now
1790         );
1791         premium = amounts[amounts.length - 1];
1792         pool.sendPremium(premium);
1793     }
1794 
1795     /**
1796      * @notice Locks the amount required for an option
1797      * @param option A specific option contract
1798      */
1799     function lockFunds(Option memory option) internal override {
1800         pool.lock(option.amount.mul(option.strike).div(PRICE_DECIMALS));
1801     }
1802 
1803     /**
1804      * @notice Sends profits in DAI from the ERC pool to a put option holder's address
1805      * @param option A specific option contract
1806      */
1807     function payProfit(Option memory option) internal override returns (uint profit) {
1808         uint currentPrice = uint(priceProvider.latestAnswer());
1809         require(option.strike >= currentPrice, "Current price is too high");
1810         profit = option.strike.sub(currentPrice).mul(option.amount).div(PRICE_DECIMALS);
1811         pool.send(option.holder, profit);
1812         unlockFunds(option);
1813     }
1814 
1815     /**
1816      * @notice Unlocks the amount that was locked in a put option contract
1817      * @param option A specific option contract
1818      */
1819     function unlockFunds(Option memory option) internal override {
1820         pool.unlockPremium(option.premium);
1821         pool.unlock(option.amount.mul(option.strike).div(PRICE_DECIMALS));
1822     }
1823 }
1824 
1825 // File: test/Import.flat