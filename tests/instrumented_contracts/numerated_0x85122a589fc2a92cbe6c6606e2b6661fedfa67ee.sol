1 //import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0-solc-0.7/contracts/token/ERC20/ERC20.sol";
2 // SPDX-License-Identifier: MIT
3 // 84 71 32 64 84 104 101 71 104 111 115 116 68 101 118 
4 // ASCII
5 
6 pragma solidity ^0.8.4;
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return payable(msg.sender);
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 /**
30  * @dev Wrappers over Solidity's arithmetic operations with added overflow
31  * checks.
32  *
33  * Arithmetic operations in Solidity wrap on overflow. This can easily result
34  * in bugs, because programmers usually assume that an overflow raises an
35  * error, which is the standard behavior in high level programming languages.
36  * `SafeMath` restores this intuition by reverting the transaction when an
37  * operation overflows.
38  *
39  * Using this library instead of the unchecked operations eliminates an entire
40  * class of bugs, so it's recommended to use it always.
41  */
42 library SafeMath {
43     /**
44      * @dev Returns the addition of two unsigned integers, with an overflow flag.
45      *
46      * _Available since v3.4._
47      */
48     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
49         uint256 c = a + b;
50         if (c < a) return (false, 0);
51         return (true, c);
52     }
53 
54     /**
55      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
56      *
57      * _Available since v3.4._
58      */
59     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
60         if (b > a) return (false, 0);
61         return (true, a - b);
62     }
63 
64     /**
65      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
66      *
67      * _Available since v3.4._
68      */
69     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
70         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
71         // benefit is lost if 'b' is also tested.
72         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
73         if (a == 0) return (true, 0);
74         uint256 c = a * b;
75         if (c / a != b) return (false, 0);
76         return (true, c);
77     }
78 
79     /**
80      * @dev Returns the division of two unsigned integers, with a division by zero flag.
81      *
82      * _Available since v3.4._
83      */
84     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
85         if (b == 0) return (false, 0);
86         return (true, a / b);
87     }
88 
89     /**
90      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
91      *
92      * _Available since v3.4._
93      */
94     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
95         if (b == 0) return (false, 0);
96         return (true, a % b);
97     }
98 
99     /**
100      * @dev Returns the addition of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `+` operator.
104      *
105      * Requirements:
106      *
107      * - Addition cannot overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a, "SafeMath: addition overflow");
112         return c;
113     }
114 
115     /**
116      * @dev Returns the subtraction of two unsigned integers, reverting on
117      * overflow (when the result is negative).
118      *
119      * Counterpart to Solidity's `-` operator.
120      *
121      * Requirements:
122      *
123      * - Subtraction cannot overflow.
124      */
125     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126         require(b <= a, "SafeMath: subtraction overflow");
127         return a - b;
128     }
129 
130     /**
131      * @dev Returns the multiplication of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `*` operator.
135      *
136      * Requirements:
137      *
138      * - Multiplication cannot overflow.
139      */
140     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
141         if (a == 0) return 0;
142         uint256 c = a * b;
143         require(c / a == b, "SafeMath: multiplication overflow");
144         return c;
145     }
146 
147     /**
148      * @dev Returns the integer division of two unsigned integers, reverting on
149      * division by zero. The result is rounded towards zero.
150      *
151      * Counterpart to Solidity's `/` operator. Note: this function uses a
152      * `revert` opcode (which leaves remaining gas untouched) while Solidity
153      * uses an invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      *
157      * - The divisor cannot be zero.
158      */
159     function div(uint256 a, uint256 b) internal pure returns (uint256) {
160         require(b > 0, "SafeMath: division by zero");
161         return a / b;
162     }
163 
164     /**
165      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
166      * reverting when dividing by zero.
167      *
168      * Counterpart to Solidity's `%` operator. This function uses a `revert`
169      * opcode (which leaves remaining gas untouched) while Solidity uses an
170      * invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      *
174      * - The divisor cannot be zero.
175      */
176     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
177         require(b > 0, "SafeMath: modulo by zero");
178         return a % b;
179     }
180 
181     /**
182      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
183      * overflow (when the result is negative).
184      *
185      * CAUTION: This function is deprecated because it requires allocating memory for the error
186      * message unnecessarily. For custom revert reasons use {trySub}.
187      *
188      * Counterpart to Solidity's `-` operator.
189      *
190      * Requirements:
191      *
192      * - Subtraction cannot overflow.
193      */
194     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b <= a, errorMessage);
196         return a - b;
197     }
198 
199     /**
200      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
201      * division by zero. The result is rounded towards zero.
202      *
203      * CAUTION: This function is deprecated because it requires allocating memory for the error
204      * message unnecessarily. For custom revert reasons use {tryDiv}.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         require(b > 0, errorMessage);
216         return a / b;
217     }
218 
219     /**
220      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221      * reverting with custom message when dividing by zero.
222      *
223      * CAUTION: This function is deprecated because it requires allocating memory for the error
224      * message unnecessarily. For custom revert reasons use {tryMod}.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
235         require(b > 0, errorMessage);
236         return a % b;
237     }
238 }
239 
240 
241 /**
242  * @dev Interface of the ERC20 standard as defined in the EIP.
243  */
244 interface IERC20 {
245     /**
246      * @dev Returns the amount of tokens in existence.
247      */
248     function totalSupply() external view returns (uint256);
249 
250     /**
251      * @dev Returns the amount of tokens owned by `account`.
252      */
253     function balanceOf(address account) external view returns (uint256);
254 
255     /**
256      * @dev Moves `amount` tokens from the caller's account to `recipient`.
257      *
258      * Returns a boolean value indicating whether the operation succeeded.
259      *
260      * Emits a {Transfer} event.
261      */
262     function transfer(address recipient, uint256 amount) external returns (bool);
263 
264     /**
265      * @dev Returns the remaining number of tokens that `spender` will be
266      * allowed to spend on behalf of `owner` through {transferFrom}. This is
267      * zero by default.
268      *
269      * This value changes when {approve} or {transferFrom} are called.
270      */
271     function allowance(address owner, address spender) external view returns (uint256);
272 
273     /**
274      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
275      *
276      * Returns a boolean value indicating whether the operation succeeded.
277      *
278      * IMPORTANT: Beware that changing an allowance with this method brings the risk
279      * that someone may use both the old and the new allowance by unfortunate
280      * transaction ordering. One possible solution to mitigate this race
281      * condition is to first reduce the spender's allowance to 0 and set the
282      * desired value afterwards:
283      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
284      *
285      * Emits an {Approval} event.
286      */
287     function approve(address spender, uint256 amount) external returns (bool);
288 
289     /**
290      * @dev Moves `amount` tokens from `sender` to `recipient` using the
291      * allowance mechanism. `amount` is then deducted from the caller's
292      * allowance.
293      *
294      * Returns a boolean value indicating whether the operation succeeded.
295      *
296      * Emits a {Transfer} event.
297      */
298     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
299 
300     /**
301      * @dev Emitted when `value` tokens are moved from one account (`from`) to
302      * another (`to`).
303      *
304      * Note that `value` may be zero.
305      */
306     event Transfer(address indexed from, address indexed to, uint256 value);
307 
308     /**
309      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
310      * a call to {approve}. `value` is the new allowance.
311      */
312     event Approval(address indexed owner, address indexed spender, uint256 value);
313 }
314 
315 
316 /**
317  * @dev Implementation of the {IERC20} interface.
318  *
319  * This implementation is agnostic to the way tokens are created. This means
320  * that a supply mechanism has to be added in a derived contract using {_mint}.
321  * For a generic mechanism see {ERC20PresetMinterPauser}.
322  *
323  * TIP: For a detailed writeup see our guide
324  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
325  * to implement supply mechanisms].
326  *
327  * We have followed general OpenZeppelin guidelines: functions revert instead
328  * of returning `false` on failure. This behavior is nonetheless conventional
329  * and does not conflict with the expectations of ERC20 applications.
330  *
331  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
332  * This allows applications to reconstruct the allowance for all accounts just
333  * by listening to said events. Other implementations of the EIP may not emit
334  * these events, as it isn't required by the specification.
335  *
336  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
337  * functions have been added to mitigate the well-known issues around setting
338  * allowances. See {IERC20-approve}.
339  */
340 contract ERC20 is Context, IERC20 {
341     using SafeMath for uint256;
342 
343     mapping (address => uint256) private _balances;
344 
345     mapping (address => mapping (address => uint256)) private _allowances;
346 
347     uint256 private _totalSupply;
348 
349     string private _name;
350     string private _symbol;
351     uint8 private _decimals;
352 
353     /**
354      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
355      * a default value of 18.
356      *
357      * To select a different value for {decimals}, use {_setupDecimals}.
358      *
359      * All three of these values are immutable: they can only be set once during
360      * construction.
361      */
362     constructor (string memory name_, string memory symbol_) {
363         _name = name_;
364         _symbol = symbol_;
365         _decimals = 18;
366     }
367 
368     /**
369      * @dev Returns the name of the token.
370      */
371     function name() public view virtual returns (string memory) {
372         return _name;
373     }
374 
375     /**
376      * @dev Returns the symbol of the token, usually a shorter version of the
377      * name.
378      */
379     function symbol() public view virtual returns (string memory) {
380         return _symbol;
381     }
382 
383     /**
384      * @dev Returns the number of decimals used to get its user representation.
385      * For example, if `decimals` equals `2`, a balance of `505` tokens should
386      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
387      *
388      * Tokens usually opt for a value of 18, imitating the relationship between
389      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
390      * called.
391      *
392      * NOTE: This information is only used for _display_ purposes: it in
393      * no way affects any of the arithmetic of the contract, including
394      * {IERC20-balanceOf} and {IERC20-transfer}.
395      */
396     function decimals() public view virtual returns (uint8) {
397         return _decimals;
398     }
399 
400     /**
401      * @dev See {IERC20-totalSupply}.
402      */
403     function totalSupply() public view virtual override returns (uint256) {
404         return _totalSupply;
405     }
406 
407     /**
408      * @dev See {IERC20-balanceOf}.
409      */
410     function balanceOf(address account) public view virtual override returns (uint256) {
411         return _balances[account];
412     }
413 
414     /**
415      * @dev See {IERC20-transfer}.
416      *
417      * Requirements:
418      *
419      * - `recipient` cannot be the zero address.
420      * - the caller must have a balance of at least `amount`.
421      */
422     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
423         _transfer(_msgSender(), recipient, amount);
424         return true;
425     }
426 
427     /**
428      * @dev See {IERC20-allowance}.
429      */
430     function allowance(address owner, address spender) public view virtual override returns (uint256) {
431         return _allowances[owner][spender];
432     }
433 
434     /**
435      * @dev See {IERC20-approve}.
436      *
437      * Requirements:
438      *
439      * - `spender` cannot be the zero address.
440      */
441     function approve(address spender, uint256 amount) public virtual override returns (bool) {
442         _approve(_msgSender(), spender, amount);
443         return true;
444     }
445 
446     /**
447      * @dev See {IERC20-transferFrom}.
448      *
449      * Emits an {Approval} event indicating the updated allowance. This is not
450      * required by the EIP. See the note at the beginning of {ERC20}.
451      *
452      * Requirements:
453      *
454      * - `sender` and `recipient` cannot be the zero address.
455      * - `sender` must have a balance of at least `amount`.
456      * - the caller must have allowance for ``sender``'s tokens of at least
457      * `amount`.
458      */
459     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
460         _transfer(sender, recipient, amount);
461         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
462         return true;
463     }
464 
465     /**
466      * @dev Atomically increases the allowance granted to `spender` by the caller.
467      *
468      * This is an alternative to {approve} that can be used as a mitigation for
469      * problems described in {IERC20-approve}.
470      *
471      * Emits an {Approval} event indicating the updated allowance.
472      *
473      * Requirements:
474      *
475      * - `spender` cannot be the zero address.
476      */
477     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
478         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
479         return true;
480     }
481 
482     /**
483      * @dev Atomically decreases the allowance granted to `spender` by the caller.
484      *
485      * This is an alternative to {approve} that can be used as a mitigation for
486      * problems described in {IERC20-approve}.
487      *
488      * Emits an {Approval} event indicating the updated allowance.
489      *
490      * Requirements:
491      *
492      * - `spender` cannot be the zero address.
493      * - `spender` must have allowance for the caller of at least
494      * `subtractedValue`.
495      */
496     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
497         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
498         return true;
499     }
500 
501     /**
502      * @dev Moves tokens `amount` from `sender` to `recipient`.
503      *
504      * This is internal function is equivalent to {transfer}, and can be used to
505      * e.g. implement automatic token fees, slashing mechanisms, etc.
506      *
507      * Emits a {Transfer} event.
508      *
509      * Requirements:
510      *
511      * - `sender` cannot be the zero address.
512      * - `recipient` cannot be the zero address.
513      * - `sender` must have a balance of at least `amount`.
514      */
515     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
516         require(sender != address(0), "ERC20: transfer from the zero address");
517         require(recipient != address(0), "ERC20: transfer to the zero address");
518 
519         _beforeTokenTransfer(sender, recipient, amount);
520 
521         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
522         _balances[recipient] = _balances[recipient].add(amount);
523         emit Transfer(sender, recipient, amount);
524     }
525 
526     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
527      * the total supply.
528      *
529      * Emits a {Transfer} event with `from` set to the zero address.
530      *
531      * Requirements:
532      *
533      * - `to` cannot be the zero address.
534      */
535     function _mint(address account, uint256 amount) internal virtual {
536         require(account != address(0), "ERC20: mint to the zero address");
537 
538         _beforeTokenTransfer(address(0), account, amount);
539 
540         _totalSupply = _totalSupply.add(amount);
541         _balances[account] = _balances[account].add(amount);
542         emit Transfer(address(0), account, amount);
543     }
544 
545     /**
546      * @dev Destroys `amount` tokens from `account`, reducing the
547      * total supply.
548      *
549      * Emits a {Transfer} event with `to` set to the zero address.
550      *
551      * Requirements:
552      *
553      * - `account` cannot be the zero address.
554      * - `account` must have at least `amount` tokens.
555      */
556     function _burn(address account, uint256 amount) internal virtual {
557         require(account != address(0), "ERC20: burn from the zero address");
558 
559         _beforeTokenTransfer(account, address(0), amount);
560 
561         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
562         _totalSupply = _totalSupply.sub(amount);
563         emit Transfer(account, address(0), amount);
564     }
565 
566     /**
567      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
568      *
569      * This internal function is equivalent to `approve`, and can be used to
570      * e.g. set automatic allowances for certain subsystems, etc.
571      *
572      * Emits an {Approval} event.
573      *
574      * Requirements:
575      *
576      * - `owner` cannot be the zero address.
577      * - `spender` cannot be the zero address.
578      */
579     function _approve(address owner, address spender, uint256 amount) internal virtual {
580         require(owner != address(0), "ERC20: approve from the zero address");
581         require(spender != address(0), "ERC20: approve to the zero address");
582 
583         _allowances[owner][spender] = amount;
584         emit Approval(owner, spender, amount);
585     }
586 
587     /**
588      * @dev Sets {decimals} to a value other than the default one of 18.
589      *
590      * WARNING: This function should only be called from the constructor. Most
591      * applications that interact with token contracts will not expect
592      * {decimals} to ever change, and may work incorrectly if it does.
593      */
594     function _setupDecimals(uint8 decimals_) internal virtual {
595         _decimals = decimals_;
596     }
597 
598     /**
599      * @dev Hook that is called before any transfer of tokens. This includes
600      * minting and burning.
601      *
602      * Calling conditions:
603      *
604      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
605      * will be to transferred to `to`.
606      * - when `from` is zero, `amount` tokens will be minted for `to`.
607      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
608      * - `from` and `to` are never both zero.
609      *
610      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
611      */
612     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
613 }
614 
615 
616 contract Ownable {
617     address public _owner;
618     event onOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
619     constructor() {
620         _owner = msg.sender;
621     }
622     modifier onlyOwner() {
623         require(msg.sender == _owner);
624         _;
625     }
626 
627     function owner() public view virtual returns (address) {
628         return _owner;
629     }
630 
631     function transferOwnership(address _newOwner) public onlyOwner {
632         require(_newOwner != address(0));
633         emit onOwnershipTransferred(_owner, _newOwner);
634         _owner = _newOwner;
635     }
636 }
637 
638 
639 
640 interface IUniswapV2Factory {
641     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
642 
643     function feeTo() external view returns (address);
644     function feeToSetter() external view returns (address);
645 
646     function getPair(address tokenA, address tokenB) external view returns (address pair);
647     function allPairs(uint) external view returns (address pair);
648     function allPairsLength() external view returns (uint);
649 
650     function createPair(address tokenA, address tokenB) external returns (address pair);
651 
652     function setFeeTo(address) external;
653     function setFeeToSetter(address) external;
654 }
655 
656 
657 // pragma solidity >=0.5.0;
658 
659 interface IUniswapV2Pair {
660     event Approval(address indexed owner, address indexed spender, uint value);
661     event Transfer(address indexed from, address indexed to, uint value);
662 
663     function name() external pure returns (string memory);
664     function symbol() external pure returns (string memory);
665     function decimals() external pure returns (uint8);
666     function totalSupply() external view returns (uint);
667     function balanceOf(address owner) external view returns (uint);
668     function allowance(address owner, address spender) external view returns (uint);
669 
670     function approve(address spender, uint value) external returns (bool);
671     function transfer(address to, uint value) external returns (bool);
672     function transferFrom(address from, address to, uint value) external returns (bool);
673 
674     function DOMAIN_SEPARATOR() external view returns (bytes32);
675     function PERMIT_TYPEHASH() external pure returns (bytes32);
676     function nonces(address owner) external view returns (uint);
677 
678     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
679     
680     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
681     event Swap(
682         address indexed sender,
683         uint amount0In,
684         uint amount1In,
685         uint amount0Out,
686         uint amount1Out,
687         address indexed to
688     );
689     event Sync(uint112 reserve0, uint112 reserve1);
690 
691     function MINIMUM_LIQUIDITY() external pure returns (uint);
692     function factory() external view returns (address);
693     function token0() external view returns (address);
694     function token1() external view returns (address);
695     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
696     function price0CumulativeLast() external view returns (uint);
697     function price1CumulativeLast() external view returns (uint);
698     function kLast() external view returns (uint);
699 
700     function burn(address to) external returns (uint amount0, uint amount1);
701     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
702     function skim(address to) external;
703     function sync() external;
704 
705     function initialize(address, address) external;
706 }
707 
708 // pragma solidity >=0.6.2;
709 
710 interface IUniswapV2Router01 {
711     function factory() external pure returns (address);
712     function WETH() external pure returns (address);
713 
714     function addLiquidity(
715         address tokenA,
716         address tokenB,
717         uint amountADesired,
718         uint amountBDesired,
719         uint amountAMin,
720         uint amountBMin,
721         address to,
722         uint deadline
723     ) external returns (uint amountA, uint amountB, uint liquidity);
724     function addLiquidityETH(
725         address token,
726         uint amountTokenDesired,
727         uint amountTokenMin,
728         uint amountETHMin,
729         address to,
730         uint deadline
731     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
732     function removeLiquidity(
733         address tokenA,
734         address tokenB,
735         uint liquidity,
736         uint amountAMin,
737         uint amountBMin,
738         address to,
739         uint deadline
740     ) external returns (uint amountA, uint amountB);
741     function removeLiquidityETH(
742         address token,
743         uint liquidity,
744         uint amountTokenMin,
745         uint amountETHMin,
746         address to,
747         uint deadline
748     ) external returns (uint amountToken, uint amountETH);
749     function removeLiquidityWithPermit(
750         address tokenA,
751         address tokenB,
752         uint liquidity,
753         uint amountAMin,
754         uint amountBMin,
755         address to,
756         uint deadline,
757         bool approveMax, uint8 v, bytes32 r, bytes32 s
758     ) external returns (uint amountA, uint amountB);
759     function removeLiquidityETHWithPermit(
760         address token,
761         uint liquidity,
762         uint amountTokenMin,
763         uint amountETHMin,
764         address to,
765         uint deadline,
766         bool approveMax, uint8 v, bytes32 r, bytes32 s
767     ) external returns (uint amountToken, uint amountETH);
768     function swapExactTokensForTokens(
769         uint amountIn,
770         uint amountOutMin,
771         address[] calldata path,
772         address to,
773         uint deadline
774     ) external returns (uint[] memory amounts);
775     function swapTokensForExactTokens(
776         uint amountOut,
777         uint amountInMax,
778         address[] calldata path,
779         address to,
780         uint deadline
781     ) external returns (uint[] memory amounts);
782     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
783         external
784         payable
785         returns (uint[] memory amounts);
786     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
787         external
788         returns (uint[] memory amounts);
789     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
790         external
791         returns (uint[] memory amounts);
792     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
793         external
794         payable
795         returns (uint[] memory amounts);
796 
797     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
798     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
799     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
800     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
801     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
802 }
803 
804 
805 
806 // pragma solidity >=0.6.2;
807 
808 interface IUniswapV2Router02 is IUniswapV2Router01 {
809     function removeLiquidityETHSupportingFeeOnTransferTokens(
810         address token,
811         uint liquidity,
812         uint amountTokenMin,
813         uint amountETHMin,
814         address to,
815         uint deadline
816     ) external returns (uint amountETH);
817     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
818         address token,
819         uint liquidity,
820         uint amountTokenMin,
821         uint amountETHMin,
822         address to,
823         uint deadline,
824         bool approveMax, uint8 v, bytes32 r, bytes32 s
825     ) external returns (uint amountETH);
826 
827     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
828         uint amountIn,
829         uint amountOutMin,
830         address[] calldata path,
831         address to,
832         uint deadline
833     ) external;
834     function swapExactETHForTokensSupportingFeeOnTransferTokens(
835         uint amountOutMin,
836         address[] calldata path,
837         address to,
838         uint deadline
839     ) external payable;
840     function swapExactTokensForETHSupportingFeeOnTransferTokens(
841         uint amountIn,
842         uint amountOutMin,
843         address[] calldata path,
844         address to,
845         uint deadline
846     ) external;
847 }
848 
849 /**
850  * @dev Contract module that helps prevent reentrant calls to a function.
851  *
852  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
853  * available, which can be applied to functions to make sure there are no nested
854  * (reentrant) calls to them.
855  *
856  * Note that because there is a single `nonReentrant` guard, functions marked as
857  * `nonReentrant` may not call one another. This can be worked around by making
858  * those functions `private`, and then adding `external` `nonReentrant` entry
859  * points to them.
860  *
861  * TIP: If you would like to learn more about reentrancy and alternative ways
862  * to protect against it, check out our blog post
863  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
864  */
865 abstract contract ReentrancyGuard {
866     // Booleans are more expensive than uint256 or any type that takes up a full
867     // word because each write operation emits an extra SLOAD to first read the
868     // slot's contents, replace the bits taken up by the boolean, and then write
869     // back. This is the compiler's defense against contract upgrades and
870     // pointer aliasing, and it cannot be disabled.
871 
872     // The values being non-zero value makes deployment a bit more expensive,
873     // but in exchange the refund on every call to nonReentrant will be lower in
874     // amount. Since refunds are capped to a percentage of the total
875     // transaction's gas, it is best to keep them low in cases like this one, to
876     // increase the likelihood of the full refund coming into effect.
877     uint256 private constant _NOT_ENTERED = 1;
878     uint256 private constant _ENTERED = 2;
879 
880     uint256 private _status;
881 
882     constructor() {
883         _status = _NOT_ENTERED;
884     }
885 
886     /**
887      * @dev Prevents a contract from calling itself, directly or indirectly. Calling a `nonReentrant` function from another `nonReentrant` function is not supported. It is possible to prevent this from happeningby making the `nonReentrant` function external, and make it call a`private` function that does the actual work.
888      */
889     modifier nonReentrant() {
890         // On the first call to nonReentrant, _notEntered will be true
891         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
892 
893         // Any calls to nonReentrant after this point will fail
894         _status = _ENTERED;
895 
896         _;
897 
898         // By storing the original value once again, a refund is triggered (see
899         // https://eips.ethereum.org/EIPS/eip-2200)
900         _status = _NOT_ENTERED;
901     }
902 }
903 
904 contract SHIBNAKI is ERC20, Ownable, ReentrancyGuard {
905     using SafeMath for uint256;
906 
907     IUniswapV2Router02 public uniswapV2Router;
908     address public uniswapV2Pair;
909 
910     uint256 public feeDevelopment = 40;
911     uint256 public feeSustainability = 40;
912     uint256 public feeLiquidity = 20;
913 
914     mapping (address => bool) public isExcludedFromFees;
915     mapping (address => bool) public isExcludedFromMax;
916     mapping (address => bool) public isInBlacklist;
917     mapping (address => bool) public isInWhitelist;
918     mapping (address => bool) public isrouterother;
919 
920     uint256 private _totalSupply = 1000000000000 * (10**18);
921     uint256 private maxBuyLimit = 1000000000 * (10**18);
922     string private _name = "SHIBNAKI";
923     string private _symbol = "SHAKI";
924     uint256 public maxWallet = _totalSupply.div(10000).mul(75);
925 
926     uint256 public _tokenThresholdToSwap = _totalSupply / 10000;
927     bool inSwapAndLiquify;
928     bool swapping;
929     bool public swapAndSendFeesEnabled = true;
930     bool public CEX = false;
931     bool public addliq = true;
932     bool public trading = false;
933     bool public limitsEnabled = true;
934 
935     address public walletSustainability;
936     address public walletDevelopment;
937     address public walletLiquidity;
938     address public DAOcontrol;
939 
940     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
941     bool public transferDelayEnabled = true;
942 
943     modifier lockTheSwap {
944         inSwapAndLiquify = true;
945         _;
946         inSwapAndLiquify = false;
947     }
948 
949     constructor (address _walletSustainability, address _walletDevelopment, address _DAOcontrol, address _walletLiquidity) ERC20(_name, _symbol) {
950         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
951         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
952             .createPair(address(this), _uniswapV2Router.WETH());
953 
954         uniswapV2Router = _uniswapV2Router;
955         uniswapV2Pair = _uniswapV2Pair;
956 
957         walletSustainability = _walletSustainability;
958         walletDevelopment = _walletDevelopment;
959         walletLiquidity = _walletLiquidity;
960         DAOcontrol = _DAOcontrol;
961 
962         // exclude from paying fees
963         excludeFromFee(owner());
964         excludeFromFee(address(this));
965         excludeFromMax(owner());
966         excludeFromMax(address(this));
967 
968         _mint(owner(), _totalSupply);
969     }
970 
971     receive() external payable {}
972 
973     function updateWalletSustainability(address _walletSustainability) external {
974         require(_msgSender() == DAOcontrol);
975         walletSustainability = _walletSustainability;
976     }
977 
978     function updateWalletDevelopment(address _walletDevelopment) external {
979         require(_msgSender() == DAOcontrol);
980         walletDevelopment = _walletDevelopment;
981     }
982 
983     function updateWalletLiquidity(address _walletLiquidity) external {
984         require(_msgSender() == DAOcontrol);
985         walletLiquidity = _walletLiquidity;
986     }
987     function updateDAOcontrol(address _DAOcontrol) external {
988         require(_msgSender() == DAOcontrol);
989         DAOcontrol = _DAOcontrol;
990     }
991 
992     function excludeFromFee(address account) public {
993         require(_msgSender() == DAOcontrol);
994         isExcludedFromFees[account] = true;
995     }
996 
997     function excludeFromMax(address account) public {
998         require(_msgSender() == DAOcontrol);
999         isExcludedFromMax[account] = true;
1000     }
1001 
1002     function includeInMax(address account) public {
1003         require(_msgSender() == DAOcontrol);
1004         isExcludedFromMax[account] = false;
1005     }
1006     
1007     function includeInFee(address account) public {
1008         require(_msgSender() == DAOcontrol);
1009         isExcludedFromFees[account] = false;
1010     }
1011 
1012     function setSwapAndSendFeesEnabled(bool _enabled) public {
1013         require(_msgSender() == DAOcontrol);
1014         swapAndSendFeesEnabled = _enabled;
1015     }
1016 
1017     function setLimitsEnabled(bool _enabled) public{
1018         require(_msgSender() == DAOcontrol);
1019         limitsEnabled = _enabled;
1020     }
1021 
1022     function setTradingEnabled(bool _enabled) public {
1023         require(_msgSender() == DAOcontrol);
1024         trading = _enabled;
1025     }
1026 
1027     function setTransferDelay(bool _enabled) public {
1028         require(_msgSender() == DAOcontrol);
1029         transferDelayEnabled = _enabled;
1030     }
1031     function setThresoldToSwap(uint256 amount) public {
1032         require(_msgSender() == DAOcontrol);
1033         _tokenThresholdToSwap = amount;
1034     }
1035     function setMaxBuyLimit(uint256 percentage) public {
1036         require(_msgSender() == DAOcontrol);
1037         maxBuyLimit = _totalSupply.div(10**4).mul(percentage);
1038     }
1039     function setMaxWallet(uint256 percentage) public {
1040         require(_msgSender() == DAOcontrol);
1041         require(percentage >= 75);
1042         maxWallet = _totalSupply.div(10000).mul(percentage);
1043     }
1044     function setFeesPercent(uint256 devFee, uint256 sustainabilityFee, uint256 liquidityFee) public {
1045         require(_msgSender() == DAOcontrol);
1046         feeDevelopment = devFee;
1047         feeSustainability  = sustainabilityFee;
1048         feeLiquidity = liquidityFee;
1049         require(devFee + sustainabilityFee + liquidityFee <= 990, "Check fee limit");
1050     }
1051 
1052     function setBlacklistWallet(address account, bool blacklisted) external {
1053         require(!CEX);
1054         require(!isInWhitelist[account]);
1055         require(_msgSender() == DAOcontrol);
1056         isInBlacklist[account] = blacklisted;
1057     }
1058 
1059     function setCEXWhitelistWallet(address account) external {
1060         require(_msgSender() == DAOcontrol);
1061         isInWhitelist[account] = true;
1062         isExcludedFromMax[account] = true;
1063     }
1064 
1065     function setRouterOther(address account, bool enabled) external {
1066         require(_msgSender() == DAOcontrol);
1067         isrouterother[account] = enabled;
1068     }
1069 
1070     function AddToCEX (bool enabled) external {
1071         require(_msgSender() == DAOcontrol);
1072         CEX = enabled;
1073     }  
1074 
1075     function Addliq (bool enabled) external {
1076         require(_msgSender() == DAOcontrol);
1077         addliq = enabled;
1078     } 
1079 
1080     function manualswap() external lockTheSwap {
1081         require(_msgSender() == DAOcontrol);
1082         uint256 contractBalance = balanceOf(address(this));
1083         swapTokensForEth(contractBalance);
1084     }
1085 
1086     function manualswapcustom(uint256 percentage) external lockTheSwap {
1087         require(_msgSender() == DAOcontrol);
1088         uint256 contractBalance = balanceOf(address(this));
1089         uint256 swapbalance = contractBalance.div(10**5).mul(percentage);
1090         swapTokensForEth(swapbalance);
1091     }
1092 
1093     function manualsend() external {
1094         require(_msgSender() == DAOcontrol);
1095         uint256 amount = address(this).balance;
1096 
1097         uint256 ethDevelopment = amount.mul(feeDevelopment).div(feeDevelopment.add(feeSustainability).add(feeLiquidity));
1098         uint256 ethSustainability = amount.mul(feeSustainability).div(feeDevelopment.add(feeSustainability).add(feeLiquidity));
1099         uint256 ethLiquidity = amount.sub(ethDevelopment).sub(ethSustainability);
1100 
1101         //Send out fees
1102         if(ethDevelopment > 0)
1103             payable(walletDevelopment).transfer(ethDevelopment);
1104         if(ethSustainability > 0)
1105             payable(walletSustainability).transfer(ethSustainability);
1106         if(ethLiquidity > 0)
1107             payable(walletLiquidity).transfer(ethLiquidity);
1108     }
1109     
1110     function _transfer(
1111         address from,
1112         address to,
1113         uint256 amount
1114     ) internal override {
1115         require(from != address(0), "ERC20: transfer from the zero address");
1116         require(to != address(0), "ERC20: transfer to the zero address");
1117         require(amount > 0, "Transfer amount must be greater than zero");
1118         require(isInBlacklist[from] == false, "You're in blacklist");
1119         
1120         if(limitsEnabled){
1121         if(!isExcludedFromMax[to] && !isExcludedFromFees[to] && from != owner() && to != owner() && to != uniswapV2Pair && !isrouterother[to]){
1122         require(amount <= maxBuyLimit,"Over the Max buy");
1123         require(amount.add(balanceOf(to)) <= maxWallet);
1124         }
1125         if (
1126                 from != owner() &&
1127                 to != owner() &&
1128                 to != address(0) &&
1129                 to != address(0xdead) &&
1130                 !inSwapAndLiquify
1131             ){
1132 
1133                 if(!trading){
1134                     require(isExcludedFromFees[from] || isExcludedFromFees[to], "Trading is not active.");
1135                 }
1136 
1137             
1138                 if (transferDelayEnabled){
1139                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1140                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1141                         _holderLastTransferTimestamp[tx.origin] = block.number;
1142                     }
1143                 }
1144             }
1145         }
1146         bool overMinTokenBalance = balanceOf(address(this)) >= _tokenThresholdToSwap;
1147         if (
1148             overMinTokenBalance &&
1149             !inSwapAndLiquify &&
1150             from != uniswapV2Pair &&
1151             swapAndSendFeesEnabled
1152         ) {
1153             swapAndSendFees();
1154         }
1155     
1156         bool takeFee = true;
1157         if(isExcludedFromFees[from] || isExcludedFromFees[to] || (from != uniswapV2Pair && to != uniswapV2Pair && !isrouterother[from] && !isrouterother[to])) {
1158             takeFee = false;
1159         }
1160 
1161         uint256 finalTransferAmount = amount;
1162         if(takeFee) {
1163             uint256 totalFeesPercent = feeDevelopment.add(feeSustainability).add(feeLiquidity);
1164         	uint256 fees = amount.mul(totalFeesPercent).div(1000);
1165         	finalTransferAmount = amount.sub(fees);
1166             super._transfer(from, address(this), fees);
1167         }
1168 
1169         super._transfer(from, to, finalTransferAmount);
1170     }
1171 
1172     function swapAndSendFees() private lockTheSwap {
1173 
1174         swapTokensForEth(balanceOf(address(this)));
1175         uint256 amount = address(this).balance;
1176 
1177         uint256 ethDevelopment = amount.mul(feeDevelopment).div(feeDevelopment.add(feeSustainability).add(feeLiquidity));
1178         uint256 ethSustainability = amount.mul(feeSustainability).div(feeDevelopment.add(feeSustainability).add(feeLiquidity));
1179         uint256 ethLiquidity = amount.sub(ethDevelopment).sub(ethSustainability);
1180 
1181         //Send out fees
1182         if(ethDevelopment > 0)
1183             payable(walletDevelopment).transfer(ethDevelopment);
1184         if(ethSustainability > 0)
1185             payable(walletSustainability).transfer(ethSustainability);
1186         if(ethLiquidity > 0)
1187             payable(walletLiquidity).transfer(ethLiquidity);
1188     }
1189 
1190     function swapTokensForEth(uint256 tokenAmount) private {
1191         // generate the uniswap pair path of token -> weth
1192         address[] memory path = new address[](2);
1193         path[0] = address(this);
1194         path[1] = uniswapV2Router.WETH();
1195 
1196         _approve(address(this), address(uniswapV2Router), tokenAmount);
1197 
1198         // make the swap
1199         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1200             tokenAmount,
1201             0, // accept any amount of ETH
1202             path,
1203             address(this),
1204             block.timestamp
1205         );
1206     }
1207 
1208     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1209         // approve token transfer to cover all possible scenarios
1210         _approve(address(this), address(uniswapV2Router), tokenAmount);
1211 
1212         // add the liquidity
1213         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1214             address(this),
1215             tokenAmount,
1216             0, // slippage is unavoidable
1217             0, // slippage is unavoidable
1218             owner(),
1219             block.timestamp
1220         );
1221     }
1222 }