1 /*
2 
3 Website: https://www.akitama.app/
4 
5 TG: https://t.me/AkitamaETH
6 
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.6.12;
12 
13 /**
14  * @dev Interface of the ERC20 standard as defined in the EIP.
15  */
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through {transferFrom}. This is
39      * zero by default.
40      *
41      * This value changes when {approve} or {transferFrom} are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 /**
92  * @dev Interface for the optional metadata functions from the ERC20 standard.
93  *
94  * _Available since v4.1._
95  */
96 interface IERC20Metadata is IERC20 {
97     /**
98      * @dev Returns the name of the token.
99      */
100     function name() external view returns (string memory);
101 
102     /**
103      * @dev Returns the symbol of the token.
104      */
105     function symbol() external view returns (string memory);
106 
107     /**
108      * @dev Returns the decimals places of the token.
109      */
110     function decimals() external view returns (uint8);
111 }
112 
113 /*
114  * @dev Provides information about the current execution context, including the
115  * sender of the transaction and its data. While these are generally available
116  * via msg.sender and msg.data, they should not be accessed in such a direct
117  * manner, since when dealing with meta-transactions the account sending and
118  * paying for execution may not be the actual sender (as far as an application
119  * is concerned).
120  *
121  * This contract is only required for intermediate, library-like contracts.
122  */
123 abstract contract Context {
124     function _msgSender() internal view virtual returns (address) {
125         return msg.sender;
126     }
127 
128     function _msgData() internal view virtual returns (bytes calldata) {
129         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
130         return msg.data;
131     }
132 }
133 
134 contract Ownable is Context {
135     address private _owner;
136 
137     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
138 
139     /**
140      * @dev Initializes the contract setting the deployer as the initial owner.
141      */
142     constructor () public {
143         address msgSender = _msgSender();
144         _owner = msgSender;
145         emit OwnershipTransferred(address(0), msgSender);
146     }
147 
148     /**
149      * @dev Returns the address of the current owner.
150      */
151     function owner() public view returns (address) {
152         return _owner;
153     }
154 
155     /**
156      * @dev Throws if called by any account other than the owner.
157      */
158     modifier onlyOwner() {
159         require(_owner == _msgSender(), "Ownable: caller is not the owner");
160         _;
161     }
162 
163     /**
164      * @dev Leaves the contract without owner. It will not be possible to call
165      * `onlyOwner` functions anymore. Can only be called by the current owner.
166      *
167      * NOTE: Renouncing ownership will leave the contract without an owner,
168      * thereby removing any functionality that is only available to the owner.
169      */
170     function renounceOwnership() public virtual onlyOwner {
171         emit OwnershipTransferred(_owner, address(0));
172         _owner = address(0);
173     }
174 
175     /**
176      * @dev Transfers ownership of the contract to a new account (`newOwner`).
177      * Can only be called by the current owner.
178      */
179     function transferOwnership(address newOwner) public virtual onlyOwner {
180         require(newOwner != address(0), "Ownable: new owner is the zero address");
181         emit OwnershipTransferred(_owner, newOwner);
182         _owner = newOwner;
183     }
184 }
185 
186 library SafeMath {
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
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the subtraction of two unsigned integers, reverting on
206      * overflow (when the result is negative).
207      *
208      * Counterpart to Solidity's `-` operator.
209      *
210      * Requirements:
211      *
212      * - Subtraction cannot overflow.
213      */
214     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
215         return sub(a, b, "SafeMath: subtraction overflow");
216     }
217 
218     /**
219      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
220      * overflow (when the result is negative).
221      *
222      * Counterpart to Solidity's `-` operator.
223      *
224      * Requirements:
225      *
226      * - Subtraction cannot overflow.
227      */
228     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b <= a, errorMessage);
230         uint256 c = a - b;
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the multiplication of two unsigned integers, reverting on
237      * overflow.
238      *
239      * Counterpart to Solidity's `*` operator.
240      *
241      * Requirements:
242      *
243      * - Multiplication cannot overflow.
244      */
245     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
246         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
247         // benefit is lost if 'b' is also tested.
248         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
249         if (a == 0) {
250             return 0;
251         }
252 
253         uint256 c = a * b;
254         require(c / a == b, "SafeMath: multiplication overflow");
255 
256         return c;
257     }
258 
259     /**
260      * @dev Returns the integer division of two unsigned integers. Reverts on
261      * division by zero. The result is rounded towards zero.
262      *
263      * Counterpart to Solidity's `/` operator. Note: this function uses a
264      * `revert` opcode (which leaves remaining gas untouched) while Solidity
265      * uses an invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function div(uint256 a, uint256 b) internal pure returns (uint256) {
272         return div(a, b, "SafeMath: division by zero");
273     }
274 
275     /**
276      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
277      * division by zero. The result is rounded towards zero.
278      *
279      * Counterpart to Solidity's `/` operator. Note: this function uses a
280      * `revert` opcode (which leaves remaining gas untouched) while Solidity
281      * uses an invalid opcode to revert (consuming all remaining gas).
282      *
283      * Requirements:
284      *
285      * - The divisor cannot be zero.
286      */
287     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
288         require(b > 0, errorMessage);
289         uint256 c = a / b;
290         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
291 
292         return c;
293     }
294 
295     /**
296      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
297      * Reverts when dividing by zero.
298      *
299      * Counterpart to Solidity's `%` operator. This function uses a `revert`
300      * opcode (which leaves remaining gas untouched) while Solidity uses an
301      * invalid opcode to revert (consuming all remaining gas).
302      *
303      * Requirements:
304      *
305      * - The divisor cannot be zero.
306      */
307     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
308         return mod(a, b, "SafeMath: modulo by zero");
309     }
310 
311     /**
312      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
313      * Reverts with custom message when dividing by zero.
314      *
315      * Counterpart to Solidity's `%` operator. This function uses a `revert`
316      * opcode (which leaves remaining gas untouched) while Solidity uses an
317      * invalid opcode to revert (consuming all remaining gas).
318      *
319      * Requirements:
320      *
321      * - The divisor cannot be zero.
322      */
323     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
324         require(b != 0, errorMessage);
325         return a % b;
326     }
327 }
328 
329 interface IUniswapV2Pair {
330     event Approval(address indexed owner, address indexed spender, uint value);
331     event Transfer(address indexed from, address indexed to, uint value);
332 
333     function name() external pure returns (string memory);
334     function symbol() external pure returns (string memory);
335     function decimals() external pure returns (uint8);
336     function totalSupply() external view returns (uint);
337     function balanceOf(address owner) external view returns (uint);
338     function allowance(address owner, address spender) external view returns (uint);
339 
340     function approve(address spender, uint value) external returns (bool);
341     function transfer(address to, uint value) external returns (bool);
342     function transferFrom(address from, address to, uint value) external returns (bool);
343 
344     function DOMAIN_SEPARATOR() external view returns (bytes32);
345     function PERMIT_TYPEHASH() external pure returns (bytes32);
346     function nonces(address owner) external view returns (uint);
347 
348     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
349 
350     event Mint(address indexed sender, uint amount0, uint amount1);
351     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
352     event Swap(
353         address indexed sender,
354         uint amount0In,
355         uint amount1In,
356         uint amount0Out,
357         uint amount1Out,
358         address indexed to
359     );
360     event Sync(uint112 reserve0, uint112 reserve1);
361 
362     function MINIMUM_LIQUIDITY() external pure returns (uint);
363     function factory() external view returns (address);
364     function token0() external view returns (address);
365     function token1() external view returns (address);
366     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
367     function price0CumulativeLast() external view returns (uint);
368     function price1CumulativeLast() external view returns (uint);
369     function kLast() external view returns (uint);
370 
371     function mint(address to) external returns (uint liquidity);
372     function burn(address to) external returns (uint amount0, uint amount1);
373     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
374     function skim(address to) external;
375     function sync() external;
376 
377     function initialize(address, address) external;
378 }
379 
380 interface IUniswapV2Factory {
381     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
382 
383     function feeTo() external view returns (address);
384     function feeToSetter() external view returns (address);
385 
386     function getPair(address tokenA, address tokenB) external view returns (address pair);
387     function allPairs(uint) external view returns (address pair);
388     function allPairsLength() external view returns (uint);
389 
390     function createPair(address tokenA, address tokenB) external returns (address pair);
391 
392     function setFeeTo(address) external;
393     function setFeeToSetter(address) external;
394 }
395 
396 interface IUniswapV2Router01 {
397     function factory() external pure returns (address);
398     function WETH() external pure returns (address);
399 
400     function addLiquidity(
401         address tokenA,
402         address tokenB,
403         uint amountADesired,
404         uint amountBDesired,
405         uint amountAMin,
406         uint amountBMin,
407         address to,
408         uint deadline
409     ) external returns (uint amountA, uint amountB, uint liquidity);
410     function addLiquidityETH(
411         address token,
412         uint amountTokenDesired,
413         uint amountTokenMin,
414         uint amountETHMin,
415         address to,
416         uint deadline
417     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
418     function removeLiquidity(
419         address tokenA,
420         address tokenB,
421         uint liquidity,
422         uint amountAMin,
423         uint amountBMin,
424         address to,
425         uint deadline
426     ) external returns (uint amountA, uint amountB);
427     function removeLiquidityETH(
428         address token,
429         uint liquidity,
430         uint amountTokenMin,
431         uint amountETHMin,
432         address to,
433         uint deadline
434     ) external returns (uint amountToken, uint amountETH);
435     function removeLiquidityWithPermit(
436         address tokenA,
437         address tokenB,
438         uint liquidity,
439         uint amountAMin,
440         uint amountBMin,
441         address to,
442         uint deadline,
443         bool approveMax, uint8 v, bytes32 r, bytes32 s
444     ) external returns (uint amountA, uint amountB);
445     function removeLiquidityETHWithPermit(
446         address token,
447         uint liquidity,
448         uint amountTokenMin,
449         uint amountETHMin,
450         address to,
451         uint deadline,
452         bool approveMax, uint8 v, bytes32 r, bytes32 s
453     ) external returns (uint amountToken, uint amountETH);
454     function swapExactTokensForTokens(
455         uint amountIn,
456         uint amountOutMin,
457         address[] calldata path,
458         address to,
459         uint deadline
460     ) external returns (uint[] memory amounts);
461     function swapTokensForExactTokens(
462         uint amountOut,
463         uint amountInMax,
464         address[] calldata path,
465         address to,
466         uint deadline
467     ) external returns (uint[] memory amounts);
468     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
469         external
470         payable
471         returns (uint[] memory amounts);
472     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
473         external
474         returns (uint[] memory amounts);
475     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
476         external
477         returns (uint[] memory amounts);
478     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
479         external
480         payable
481         returns (uint[] memory amounts);
482 
483     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
484     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
485     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
486     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
487     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
488 }
489 
490 interface IUniswapV2Router02 is IUniswapV2Router01 {
491     function removeLiquidityETHSupportingFeeOnTransferTokens(
492         address token,
493         uint liquidity,
494         uint amountTokenMin,
495         uint amountETHMin,
496         address to,
497         uint deadline
498     ) external returns (uint amountETH);
499     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
500         address token,
501         uint liquidity,
502         uint amountTokenMin,
503         uint amountETHMin,
504         address to,
505         uint deadline,
506         bool approveMax, uint8 v, bytes32 r, bytes32 s
507     ) external returns (uint amountETH);
508 
509     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
510         uint amountIn,
511         uint amountOutMin,
512         address[] calldata path,
513         address to,
514         uint deadline
515     ) external;
516     function swapExactETHForTokensSupportingFeeOnTransferTokens(
517         uint amountOutMin,
518         address[] calldata path,
519         address to,
520         uint deadline
521     ) external payable;
522     function swapExactTokensForETHSupportingFeeOnTransferTokens(
523         uint amountIn,
524         uint amountOutMin,
525         address[] calldata path,
526         address to,
527         uint deadline
528     ) external;
529 }
530 
531 /**
532  * @dev Implementation of the {IERC20} interface.
533  *
534  * This implementation is agnostic to the way tokens are created. This means
535  * that a supply mechanism has to be added in a derived contract using {_mint}.
536  * For a generic mechanism see {ERC20PresetMinterPauser}.
537  *
538  * TIP: For a detailed writeup see our guide
539  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
540  * to implement supply mechanisms].
541  *
542  * We have followed general OpenZeppelin guidelines: functions revert instead
543  * of returning `false` on failure. This behavior is nonetheless conventional
544  * and does not conflict with the expectations of ERC20 applications.
545  *
546  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
547  * This allows applications to reconstruct the allowance for all accounts just
548  * by listening to said events. Other implementations of the EIP may not emit
549  * these events, as it isn't required by the specification.
550  *
551  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
552  * functions have been added to mitigate the well-known issues around setting
553  * allowances. See {IERC20-approve}.
554  */
555 contract ERC20 is Context, IERC20, IERC20Metadata {
556     using SafeMath for uint256;
557 
558     mapping(address => uint256) private _balances;
559 
560     mapping(address => mapping(address => uint256)) private _allowances;
561 
562     uint256 private _totalSupply;
563 
564     string private _name;
565     string private _symbol;
566 
567     /**
568      * @dev Sets the values for {name} and {symbol}.
569      *
570      * The default value of {decimals} is 18. To select a different value for
571      * {decimals} you should overload it.
572      *
573      * All two of these values are immutable: they can only be set once during
574      * construction.
575      */
576     constructor(string memory name_, string memory symbol_) public {
577         _name = name_;
578         _symbol = symbol_;
579     }
580 
581     /**
582      * @dev Returns the name of the token.
583      */
584     function name() public view virtual override returns (string memory) {
585         return _name;
586     }
587 
588     /**
589      * @dev Returns the symbol of the token, usually a shorter version of the
590      * name.
591      */
592     function symbol() public view virtual override returns (string memory) {
593         return _symbol;
594     }
595 
596     /**
597      * @dev Returns the number of decimals used to get its user representation.
598      * For example, if `decimals` equals `2`, a balance of `505` tokens should
599      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
600      *
601      * Tokens usually opt for a value of 18, imitating the relationship between
602      * Ether and Wei. This is the value {ERC20} uses, unless this function is
603      * overridden;
604      *
605      * NOTE: This information is only used for _display_ purposes: it in
606      * no way affects any of the arithmetic of the contract, including
607      * {IERC20-balanceOf} and {IERC20-transfer}.
608      */
609     function decimals() public view virtual override returns (uint8) {
610         return 9;
611     }
612 
613     /**
614      * @dev See {IERC20-totalSupply}.
615      */
616     function totalSupply() public view virtual override returns (uint256) {
617         return _totalSupply;
618     }
619 
620     /**
621      * @dev See {IERC20-balanceOf}.
622      */
623     function balanceOf(address account) public view virtual override returns (uint256) {
624         return _balances[account];
625     }
626 
627     /**
628      * @dev See {IERC20-transfer}.
629      *
630      * Requirements:
631      *
632      * - `recipient` cannot be the zero address.
633      * - the caller must have a balance of at least `amount`.
634      */
635     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
636         _transfer(_msgSender(), recipient, amount);
637         return true;
638     }
639 
640     /**
641      * @dev See {IERC20-allowance}.
642      */
643     function allowance(address owner, address spender) public view virtual override returns (uint256) {
644         return _allowances[owner][spender];
645     }
646 
647     /**
648      * @dev See {IERC20-approve}.
649      *
650      * Requirements:
651      *
652      * - `spender` cannot be the zero address.
653      */
654     function approve(address spender, uint256 amount) public virtual override returns (bool) {
655         _approve(_msgSender(), spender, amount);
656         return true;
657     }
658 
659     /**
660      * @dev See {IERC20-transferFrom}.
661      *
662      * Emits an {Approval} event indicating the updated allowance. This is not
663      * required by the EIP. See the note at the beginning of {ERC20}.
664      *
665      * Requirements:
666      *
667      * - `sender` and `recipient` cannot be the zero address.
668      * - `sender` must have a balance of at least `amount`.
669      * - the caller must have allowance for ``sender``'s tokens of at least
670      * `amount`.
671      */
672     function transferFrom(
673         address sender,
674         address recipient,
675         uint256 amount
676     ) public virtual override returns (bool) {
677         _transfer(sender, recipient, amount);
678         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
679         return true;
680     }
681 
682     /**
683      * @dev Atomically increases the allowance granted to `spender` by the caller.
684      *
685      * This is an alternative to {approve} that can be used as a mitigation for
686      * problems described in {IERC20-approve}.
687      *
688      * Emits an {Approval} event indicating the updated allowance.
689      *
690      * Requirements:
691      *
692      * - `spender` cannot be the zero address.
693      */
694     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
695         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
696         return true;
697     }
698 
699     /**
700      * @dev Atomically decreases the allowance granted to `spender` by the caller.
701      *
702      * This is an alternative to {approve} that can be used as a mitigation for
703      * problems described in {IERC20-approve}.
704      *
705      * Emits an {Approval} event indicating the updated allowance.
706      *
707      * Requirements:
708      *
709      * - `spender` cannot be the zero address.
710      * - `spender` must have allowance for the caller of at least
711      * `subtractedValue`.
712      */
713     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
714         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
715         return true;
716     }
717 
718     /**
719      * @dev Moves tokens `amount` from `sender` to `recipient`.
720      *
721      * This is internal function is equivalent to {transfer}, and can be used to
722      * e.g. implement automatic token fees, slashing mechanisms, etc.
723      *
724      * Emits a {Transfer} event.
725      *
726      * Requirements:
727      *
728      * - `sender` cannot be the zero address.
729      * - `recipient` cannot be the zero address.
730      * - `sender` must have a balance of at least `amount`.
731      */
732     function _transfer(
733         address sender,
734         address recipient,
735         uint256 amount
736     ) internal virtual {
737         require(sender != address(0), "ERC20: transfer from the zero address");
738         require(recipient != address(0), "ERC20: transfer to the zero address");
739 
740         _beforeTokenTransfer(sender, recipient, amount);
741 
742         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
743         _balances[recipient] = _balances[recipient].add(amount);
744         emit Transfer(sender, recipient, amount);
745     }
746 
747     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
748      * the total supply.
749      *
750      * Emits a {Transfer} event with `from` set to the zero address.
751      *
752      * Requirements:
753      *
754      * - `account` cannot be the zero address.
755      */
756     function _mint(address account, uint256 amount) internal virtual {
757         require(account != address(0), "ERC20: mint to the zero address");
758 
759         _beforeTokenTransfer(address(0), account, amount);
760 
761         _totalSupply = _totalSupply.add(amount);
762         _balances[account] = _balances[account].add(amount);
763         emit Transfer(address(0), account, amount);
764     }
765 
766     /**
767      * @dev Destroys `amount` tokens from `account`, reducing the
768      * total supply.
769      *
770      * Emits a {Transfer} event with `to` set to the zero address.
771      *
772      * Requirements:
773      *
774      * - `account` cannot be the zero address.
775      * - `account` must have at least `amount` tokens.
776      */
777     function _burn(address account, uint256 amount) internal virtual {
778         require(account != address(0), "ERC20: burn from the zero address");
779 
780         _beforeTokenTransfer(account, address(0), amount);
781 
782         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
783         _totalSupply = _totalSupply.sub(amount);
784         emit Transfer(account, address(0), amount);
785     }
786 
787     /**
788      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
789      *
790      * This internal function is equivalent to `approve`, and can be used to
791      * e.g. set automatic allowances for certain subsystems, etc.
792      *
793      * Emits an {Approval} event.
794      *
795      * Requirements:
796      *
797      * - `owner` cannot be the zero address.
798      * - `spender` cannot be the zero address.
799      */
800     function _approve(
801         address owner,
802         address spender,
803         uint256 amount
804     ) internal virtual {
805         require(owner != address(0), "ERC20: approve from the zero address");
806         require(spender != address(0), "ERC20: approve to the zero address");
807 
808         _allowances[owner][spender] = amount;
809         emit Approval(owner, spender, amount);
810     }
811 
812     /**
813      * @dev Hook that is called before any transfer of tokens. This includes
814      * minting and burning.
815      *
816      * Calling conditions:
817      *
818      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
819      * will be to transferred to `to`.
820      * - when `from` is zero, `amount` tokens will be minted for `to`.
821      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
822      * - `from` and `to` are never both zero.
823      *
824      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
825      */
826     function _beforeTokenTransfer(
827         address from,
828         address to,
829         uint256 amount
830     ) internal virtual {}
831 }
832 
833 contract AKITAMA is ERC20, Ownable {
834     using SafeMath for uint256;
835 
836     address public constant DEAD_ADDRESS = address(0xdead);
837     IUniswapV2Router02 public constant uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
838 
839     uint256 public buyLiquidityFee = 3;
840     uint256 public sellLiquidityFee = 3;
841     uint256 public buyTxFee = 9;
842     uint256 public sellTxFee = 9;
843     uint256 public tokensForLiquidity;
844     uint256 public tokensForTax;
845 
846     uint256 public _tTotal = 10**9 * 10**9;                         // 1 billion
847     uint256 public swapAtAmount = _tTotal.mul(10).div(10000);       // 0.10% of total supply
848     uint256 public maxTxLimit = _tTotal.mul(75).div(10000);         // 0.75% of total supply
849     uint256 public maxWalletLimit = _tTotal.mul(150).div(10000);    // 1.50% of total supply
850 
851     address public dev;
852     address public immutable deployer;
853     address public uniswapV2Pair;
854 
855     uint256 private launchBlock;
856     bool private swapping;
857     bool public isLaunched;
858 
859     // exclude from fees
860     mapping (address => bool) public isExcludedFromFees;
861 
862     // exclude from max transaction amount
863     mapping (address => bool) public isExcludedFromTxLimit;
864 
865     // exclude from max wallet limit
866     mapping (address => bool) public isExcludedFromWalletLimit;
867 
868     // if the account is blacklisted from transacting
869     mapping (address => bool) public isBlacklisted;
870 
871 
872     constructor(address _dev) public ERC20("AKITAMA", "AKITAMA") {
873 
874         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
875         _approve(address(this), address(uniswapV2Router), type(uint256).max);
876 
877 
878         // exclude from fees, wallet limit and transaction limit
879         excludeFromAllLimits(owner(), true);
880         excludeFromAllLimits(address(this), true);
881         excludeFromWalletLimit(uniswapV2Pair, true);
882 
883         dev = _dev;
884         deployer = _msgSender();
885 
886         /*
887             _mint is an internal function in ERC20.sol that is only called here,
888             and CANNOT be called ever again
889         */
890         _mint(owner(), _tTotal);
891     }
892 
893     function excludeFromFees(address account, bool value) public onlyOwner() {
894         require(isExcludedFromFees[account] != value, "Fees: Already set to this value");
895         isExcludedFromFees[account] = value;
896     }
897 
898     function excludeFromTxLimit(address account, bool value) public onlyOwner() {
899         require(isExcludedFromTxLimit[account] != value, "TxLimit: Already set to this value");
900         isExcludedFromTxLimit[account] = value;
901     }
902 
903     function excludeFromWalletLimit(address account, bool value) public onlyOwner() {
904         require(isExcludedFromWalletLimit[account] != value, "WalletLimit: Already set to this value");
905         isExcludedFromWalletLimit[account] = value;
906     }
907 
908     function excludeFromAllLimits(address account, bool value) public onlyOwner() {
909         excludeFromFees(account, value);
910         excludeFromTxLimit(account, value);
911         excludeFromWalletLimit(account, value);
912     }
913 
914     function setBuyFee(uint256 liquidityFee, uint256 txFee) external onlyOwner() {
915         buyLiquidityFee = liquidityFee;
916         buyTxFee = txFee;
917     }
918 
919     function setSellFee(uint256 liquidityFee, uint256 txFee) external onlyOwner() {
920         sellLiquidityFee = liquidityFee;
921         sellTxFee = txFee;
922     }
923 
924     function setMaxTxLimit(uint256 newLimit) external onlyOwner() {
925         maxTxLimit = newLimit * (10**9);
926     }
927 
928     function setMaxWalletLimit(uint256 newLimit) external onlyOwner() {
929         maxWalletLimit = newLimit * (10**9);
930     }
931 
932     function setSwapAtAmount(uint256 amountToSwap) external onlyOwner() {
933         swapAtAmount = amountToSwap * (10**9);
934     }
935 
936     function updateDevWallet(address newWallet) external onlyOwner() {
937         dev = newWallet;
938     }
939 
940     function addBlacklist(address account) external onlyOwner() {
941         require(!isBlacklisted[account], "Blacklist: Already blacklisted");
942         require(account != uniswapV2Pair, "Cannot blacklist pair");
943         _setBlacklist(account, true);
944     }
945 
946     function removeBlacklist(address account) external onlyOwner() {
947         require(isBlacklisted[account], "Blacklist: Not blacklisted");
948         _setBlacklist(account, false);
949     }
950 
951     function launchNow() external onlyOwner() {
952         require(!isLaunched, "Contract is already launched");
953         isLaunched = true;
954         launchBlock = block.number;
955     }
956 
957     function _transfer(address from, address to, uint256 amount) internal override {
958         require(from != address(0), "transfer from the zero address");
959         require(to != address(0), "transfer to the zero address");
960         require(amount <= maxTxLimit || isExcludedFromTxLimit[from] || isExcludedFromTxLimit[to], "Tx Amount too large");
961         require(balanceOf(to).add(amount) <= maxWalletLimit || isExcludedFromWalletLimit[to], "Transfer will exceed wallet limit");
962         require(isLaunched || isExcludedFromFees[from] || isExcludedFromFees[to], "Waiting to go live");
963         require(!isBlacklisted[from], "Sender is blacklisted");
964 
965         if(amount == 0) {
966             super._transfer(from, to, 0);
967             return;
968         }
969 
970         uint256 totalTokensForFee = tokensForLiquidity + tokensForTax;
971         bool canSwap = totalTokensForFee >= swapAtAmount;
972 
973         if(
974             from != uniswapV2Pair &&
975             canSwap &&
976             !swapping
977         ) {
978             swapping = true;
979             swapBack(totalTokensForFee);
980             swapping = false;
981         } else if(
982             from == uniswapV2Pair &&
983             to != uniswapV2Pair &&
984             block.number < launchBlock + 2 &&
985             !isExcludedFromFees[to]
986         ) {
987             _setBlacklist(to, true);
988         }
989 
990         bool takeFee = !swapping;
991 
992         if(isExcludedFromFees[from] || isExcludedFromFees[to]) {
993             takeFee = false;
994         }
995 
996         if(takeFee) {
997             uint256 fees;
998             // on sell
999             if (to == uniswapV2Pair) {
1000                 uint256 sellTotalFees = sellLiquidityFee.add(sellTxFee);
1001                 fees = amount.mul(sellTotalFees).div(100);
1002                 tokensForLiquidity = tokensForLiquidity.add(fees.mul(sellLiquidityFee).div(sellTotalFees));
1003                 tokensForTax = tokensForTax.add(fees.mul(sellTxFee).div(sellTotalFees));
1004             }
1005             // on buy & wallet transfers
1006             else {
1007                 uint256 buyTotalFees = buyLiquidityFee.add(buyTxFee);
1008                 fees = amount.mul(buyTotalFees).div(100);
1009                 tokensForLiquidity = tokensForLiquidity.add(fees.mul(buyLiquidityFee).div(buyTotalFees));
1010                 tokensForTax = tokensForTax.add(fees.mul(buyTxFee).div(buyTotalFees));
1011             }
1012 
1013             if(fees > 0){
1014                 super._transfer(from, address(this), fees);
1015                 amount = amount.sub(fees);
1016             }
1017         }
1018 
1019         super._transfer(from, to, amount);
1020     }
1021 
1022     function swapBack(uint256 totalTokensForFee) private {
1023         uint256 toSwap = swapAtAmount;
1024 
1025         // Halve the amount of liquidity tokens
1026         uint256 liquidityTokens = toSwap.mul(tokensForLiquidity).div(totalTokensForFee).div(2);
1027         uint256 taxTokens = toSwap.sub(liquidityTokens).sub(liquidityTokens);
1028         uint256 amountToSwapForETH = toSwap.sub(liquidityTokens);
1029 
1030         _swapTokensForETH(amountToSwapForETH);
1031 
1032         uint256 ethBalance = address(this).balance;
1033         uint256 ethForTax = ethBalance.mul(taxTokens).div(amountToSwapForETH);
1034         uint256 ethForLiquidity = ethBalance.sub(ethForTax);
1035 
1036         tokensForLiquidity = tokensForLiquidity.sub(liquidityTokens.mul(2));
1037         tokensForTax = tokensForTax.sub(toSwap.sub(liquidityTokens.mul(2)));
1038 
1039         payable(address(dev)).transfer(ethForTax);
1040         _addLiquidity(liquidityTokens, ethForLiquidity);
1041     }
1042 
1043     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1044 
1045         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1046             address(this),
1047             tokenAmount,
1048             0,
1049             0,
1050             deployer,
1051             block.timestamp
1052         );
1053     }
1054 
1055     function _swapTokensForETH(uint256 tokenAmount) private {
1056 
1057         address[] memory path = new address[](2);
1058         path[0] = address(this);
1059         path[1] = uniswapV2Router.WETH();
1060 
1061         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1062             tokenAmount,
1063             0,
1064             path,
1065             address(this),
1066             block.timestamp
1067         );
1068     }
1069 
1070     function _setBlacklist(address account, bool value) internal {
1071         isBlacklisted[account] = value;
1072     }
1073 
1074     receive() external payable {}
1075 }