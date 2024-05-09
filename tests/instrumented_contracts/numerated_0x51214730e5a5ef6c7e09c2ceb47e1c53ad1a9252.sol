1 /**
2 */
3 
4 /**
5 https://stealthxcoin.com
6 https://t.me/STLTHXETH
7 https://stealthy.gitbook.io/stealth-x/
8 */
9 
10 pragma solidity ^0.6.12;
11 
12 /**
13  * @dev Interface of the ERC20 standard as defined in the EIP.
14  */
15 interface IERC20 {
16     /**
17      * @dev Returns the amount of tokens in existence.
18      */
19     function totalSupply() external view returns (uint256);
20 
21     /**
22      * @dev Returns the amount of tokens owned by `account`.
23      */
24     function balanceOf(address account) external view returns (uint256);
25 
26     /**
27      * @dev Moves `amount` tokens from the caller's account to `recipient`.
28      *
29      * Returns a boolean value indicating whether the operation succeeded.
30      *
31      * Emits a {Transfer} event.
32      */
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     /**
36      * @dev Returns the remaining number of tokens that `spender` will be
37      * allowed to spend on behalf of `owner` through {transferFrom}. This is
38      * zero by default.
39      *
40      * This value changes when {approve} or {transferFrom} are called.
41      */
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(
70         address sender,
71         address recipient,
72         uint256 amount
73     ) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 /**
91  * @dev Interface for the optional metadata functions from the ERC20 standard.
92  *
93  * _Available since v4.1._
94  */
95 interface IERC20Metadata is IERC20 {
96     /**
97      * @dev Returns the name of the token.
98      */
99     function name() external view returns (string memory);
100 
101     /**
102      * @dev Returns the symbol of the token.
103      */
104     function symbol() external view returns (string memory);
105 
106     /**
107      * @dev Returns the decimals places of the token.
108      */
109     function decimals() external view returns (uint8);
110 }
111 
112 /*
113  * @dev Provides information about the current execution context, including the
114  * sender of the transaction and its data. While these are generally available
115  * via msg.sender and msg.data, they should not be accessed in such a direct
116  * manner, since when dealing with meta-transactions the account sending and
117  * paying for execution may not be the actual sender (as far as an application
118  * is concerned).
119  *
120  * This contract is only required for intermediate, library-like contracts.
121  */
122 abstract contract Context {
123     function _msgSender() internal view virtual returns (address) {
124         return msg.sender;
125     }
126 
127     function _msgData() internal view virtual returns (bytes calldata) {
128         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
129         return msg.data;
130     }
131 }
132 
133 contract Ownable is Context {
134     address private _owner;
135 
136     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
137 
138     /**
139      * @dev Initializes the contract setting the deployer as the initial owner.
140      */
141     constructor () public {
142         address msgSender = _msgSender();
143         _owner = msgSender;
144         emit OwnershipTransferred(address(0), msgSender);
145     }
146 
147     /**
148      * @dev Returns the address of the current owner.
149      */
150     function owner() public view returns (address) {
151         return _owner;
152     }
153 
154     /**
155      * @dev Throws if called by any account other than the owner.
156      */
157     modifier onlyOwner() {
158         require(_owner == _msgSender(), "Ownable: caller is not the owner");
159         _;
160     }
161 
162     /**
163      * @dev Leaves the contract without owner. It will not be possible to call
164      * `onlyOwner` functions anymore. Can only be called by the current owner.
165      *
166      * NOTE: Renouncing ownership will leave the contract without an owner,
167      * thereby removing any functionality that is only available to the owner.
168      */
169     function renounceOwnership() public virtual onlyOwner {
170         emit OwnershipTransferred(_owner, address(0));
171         _owner = address(0);
172     }
173 
174     /**
175      * @dev Transfers ownership of the contract to a new account (`newOwner`).
176      * Can only be called by the current owner.
177      */
178     function transferOwnership(address newOwner) public virtual onlyOwner {
179         require(newOwner != address(0), "Ownable: new owner is the zero address");
180         emit OwnershipTransferred(_owner, newOwner);
181         _owner = newOwner;
182     }
183 }
184 
185 library SafeMath {
186     /**
187      * @dev Returns the addition of two unsigned integers, reverting on
188      * overflow.
189      *
190      * Counterpart to Solidity's `+` operator.
191      *
192      * Requirements:
193      *
194      * - Addition cannot overflow.
195      */
196     function add(uint256 a, uint256 b) internal pure returns (uint256) {
197         uint256 c = a + b;
198         require(c >= a, "SafeMath: addition overflow");
199 
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
214         return sub(a, b, "SafeMath: subtraction overflow");
215     }
216 
217     /**
218      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
219      * overflow (when the result is negative).
220      *
221      * Counterpart to Solidity's `-` operator.
222      *
223      * Requirements:
224      *
225      * - Subtraction cannot overflow.
226      */
227     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b <= a, errorMessage);
229         uint256 c = a - b;
230 
231         return c;
232     }
233 
234     /**
235      * @dev Returns the multiplication of two unsigned integers, reverting on
236      * overflow.
237      *
238      * Counterpart to Solidity's `*` operator.
239      *
240      * Requirements:
241      *
242      * - Multiplication cannot overflow.
243      */
244     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
245         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
246         // benefit is lost if 'b' is also tested.
247         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
248         if (a == 0) {
249             return 0;
250         }
251 
252         uint256 c = a * b;
253         require(c / a == b, "SafeMath: multiplication overflow");
254 
255         return c;
256     }
257 
258     /**
259      * @dev Returns the integer division of two unsigned integers. Reverts on
260      * division by zero. The result is rounded towards zero.
261      *
262      * Counterpart to Solidity's `/` operator. Note: this function uses a
263      * `revert` opcode (which leaves remaining gas untouched) while Solidity
264      * uses an invalid opcode to revert (consuming all remaining gas).
265      *
266      * Requirements:
267      *
268      * - The divisor cannot be zero.
269      */
270     function div(uint256 a, uint256 b) internal pure returns (uint256) {
271         return div(a, b, "SafeMath: division by zero");
272     }
273 
274     /**
275      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
276      * division by zero. The result is rounded towards zero.
277      *
278      * Counterpart to Solidity's `/` operator. Note: this function uses a
279      * `revert` opcode (which leaves remaining gas untouched) while Solidity
280      * uses an invalid opcode to revert (consuming all remaining gas).
281      *
282      * Requirements:
283      *
284      * - The divisor cannot be zero.
285      */
286     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
287         require(b > 0, errorMessage);
288         uint256 c = a / b;
289         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
290 
291         return c;
292     }
293 
294     /**
295      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
296      * Reverts when dividing by zero.
297      *
298      * Counterpart to Solidity's `%` operator. This function uses a `revert`
299      * opcode (which leaves remaining gas untouched) while Solidity uses an
300      * invalid opcode to revert (consuming all remaining gas).
301      *
302      * Requirements:
303      *
304      * - The divisor cannot be zero.
305      */
306     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
307         return mod(a, b, "SafeMath: modulo by zero");
308     }
309 
310     /**
311      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
312      * Reverts with custom message when dividing by zero.
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
323         require(b != 0, errorMessage);
324         return a % b;
325     }
326 }
327 
328 interface IUniswapV2Pair {
329     event Approval(address indexed owner, address indexed spender, uint value);
330     event Transfer(address indexed from, address indexed to, uint value);
331 
332     function name() external pure returns (string memory);
333     function symbol() external pure returns (string memory);
334     function decimals() external pure returns (uint8);
335     function totalSupply() external view returns (uint);
336     function balanceOf(address owner) external view returns (uint);
337     function allowance(address owner, address spender) external view returns (uint);
338 
339     function approve(address spender, uint value) external returns (bool);
340     function transfer(address to, uint value) external returns (bool);
341     function transferFrom(address from, address to, uint value) external returns (bool);
342 
343     function DOMAIN_SEPARATOR() external view returns (bytes32);
344     function PERMIT_TYPEHASH() external pure returns (bytes32);
345     function nonces(address owner) external view returns (uint);
346 
347     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
348 
349     event Mint(address indexed sender, uint amount0, uint amount1);
350     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
351     event Swap(
352         address indexed sender,
353         uint amount0In,
354         uint amount1In,
355         uint amount0Out,
356         uint amount1Out,
357         address indexed to
358     );
359     event Sync(uint112 reserve0, uint112 reserve1);
360 
361     function MINIMUM_LIQUIDITY() external pure returns (uint);
362     function factory() external view returns (address);
363     function token0() external view returns (address);
364     function token1() external view returns (address);
365     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
366     function price0CumulativeLast() external view returns (uint);
367     function price1CumulativeLast() external view returns (uint);
368     function kLast() external view returns (uint);
369 
370     function mint(address to) external returns (uint liquidity);
371     function burn(address to) external returns (uint amount0, uint amount1);
372     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
373     function skim(address to) external;
374     function sync() external;
375 
376     function initialize(address, address) external;
377 }
378 
379 interface IUniswapV2Factory {
380     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
381 
382     function feeTo() external view returns (address);
383     function feeToSetter() external view returns (address);
384 
385     function getPair(address tokenA, address tokenB) external view returns (address pair);
386     function allPairs(uint) external view returns (address pair);
387     function allPairsLength() external view returns (uint);
388 
389     function createPair(address tokenA, address tokenB) external returns (address pair);
390 
391     function setFeeTo(address) external;
392     function setFeeToSetter(address) external;
393 }
394 
395 interface IUniswapV2Router01 {
396     function factory() external pure returns (address);
397     function WETH() external pure returns (address);
398 
399     function addLiquidity(
400         address tokenA,
401         address tokenB,
402         uint amountADesired,
403         uint amountBDesired,
404         uint amountAMin,
405         uint amountBMin,
406         address to,
407         uint deadline
408     ) external returns (uint amountA, uint amountB, uint liquidity);
409     function addLiquidityETH(
410         address token,
411         uint amountTokenDesired,
412         uint amountTokenMin,
413         uint amountETHMin,
414         address to,
415         uint deadline
416     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
417     function removeLiquidity(
418         address tokenA,
419         address tokenB,
420         uint liquidity,
421         uint amountAMin,
422         uint amountBMin,
423         address to,
424         uint deadline
425     ) external returns (uint amountA, uint amountB);
426     function removeLiquidityETH(
427         address token,
428         uint liquidity,
429         uint amountTokenMin,
430         uint amountETHMin,
431         address to,
432         uint deadline
433     ) external returns (uint amountToken, uint amountETH);
434     function removeLiquidityWithPermit(
435         address tokenA,
436         address tokenB,
437         uint liquidity,
438         uint amountAMin,
439         uint amountBMin,
440         address to,
441         uint deadline,
442         bool approveMax, uint8 v, bytes32 r, bytes32 s
443     ) external returns (uint amountA, uint amountB);
444     function removeLiquidityETHWithPermit(
445         address token,
446         uint liquidity,
447         uint amountTokenMin,
448         uint amountETHMin,
449         address to,
450         uint deadline,
451         bool approveMax, uint8 v, bytes32 r, bytes32 s
452     ) external returns (uint amountToken, uint amountETH);
453     function swapExactTokensForTokens(
454         uint amountIn,
455         uint amountOutMin,
456         address[] calldata path,
457         address to,
458         uint deadline
459     ) external returns (uint[] memory amounts);
460     function swapTokensForExactTokens(
461         uint amountOut,
462         uint amountInMax,
463         address[] calldata path,
464         address to,
465         uint deadline
466     ) external returns (uint[] memory amounts);
467     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
468         external
469         payable
470         returns (uint[] memory amounts);
471     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
472         external
473         returns (uint[] memory amounts);
474     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
475         external
476         returns (uint[] memory amounts);
477     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
478         external
479         payable
480         returns (uint[] memory amounts);
481 
482     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
483     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
484     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
485     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
486     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
487 }
488 
489 interface IUniswapV2Router02 is IUniswapV2Router01 {
490     function removeLiquidityETHSupportingFeeOnTransferTokens(
491         address token,
492         uint liquidity,
493         uint amountTokenMin,
494         uint amountETHMin,
495         address to,
496         uint deadline
497     ) external returns (uint amountETH);
498     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
499         address token,
500         uint liquidity,
501         uint amountTokenMin,
502         uint amountETHMin,
503         address to,
504         uint deadline,
505         bool approveMax, uint8 v, bytes32 r, bytes32 s
506     ) external returns (uint amountETH);
507 
508     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
509         uint amountIn,
510         uint amountOutMin,
511         address[] calldata path,
512         address to,
513         uint deadline
514     ) external;
515     function swapExactETHForTokensSupportingFeeOnTransferTokens(
516         uint amountOutMin,
517         address[] calldata path,
518         address to,
519         uint deadline
520     ) external payable;
521     function swapExactTokensForETHSupportingFeeOnTransferTokens(
522         uint amountIn,
523         uint amountOutMin,
524         address[] calldata path,
525         address to,
526         uint deadline
527     ) external;
528 }
529 
530 /**
531  * @dev Implementation of the {IERC20} interface.
532  *
533  * This implementation is agnostic to the way tokens are created. This means
534  * that a supply mechanism has to be added in a derived contract using {_mint}.
535  * For a generic mechanism see {ERC20PresetMinterPauser}.
536  *
537  * TIP: For a detailed writeup see our guide
538  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
539  * to implement supply mechanisms].
540  *
541  * We have followed general OpenZeppelin guidelines: functions revert instead
542  * of returning `false` on failure. This behavior is nonetheless conventional
543  * and does not conflict with the expectations of ERC20 applications.
544  *
545  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
546  * This allows applications to reconstruct the allowance for all accounts just
547  * by listening to said events. Other implementations of the EIP may not emit
548  * these events, as it isn't required by the specification.
549  *
550  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
551  * functions have been added to mitigate the well-known issues around setting
552  * allowances. See {IERC20-approve}.
553  */
554 contract ERC20 is Context, IERC20, IERC20Metadata {
555     using SafeMath for uint256;
556 
557     mapping(address => uint256) private _balances;
558 
559     mapping(address => mapping(address => uint256)) private _allowances;
560 
561     uint256 private _totalSupply;
562 
563     string private _name;
564     string private _symbol;
565 
566     /**
567      * @dev Sets the values for {name} and {symbol}.
568      *
569      * The default value of {decimals} is 18. To select a different value for
570      * {decimals} you should overload it.
571      *
572      * All two of these values are immutable: they can only be set once during
573      * construction.
574      */
575     constructor(string memory name_, string memory symbol_) public {
576         _name = name_;
577         _symbol = symbol_;
578     }
579 
580     /**
581      * @dev Returns the name of the token.
582      */
583     function name() public view virtual override returns (string memory) {
584         return _name;
585     }
586 
587     /**
588      * @dev Returns the symbol of the token, usually a shorter version of the
589      * name.
590      */
591     function symbol() public view virtual override returns (string memory) {
592         return _symbol;
593     }
594 
595     /**
596      * @dev Returns the number of decimals used to get its user representation.
597      * For example, if `decimals` equals `2`, a balance of `505` tokens should
598      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
599      *
600      * Tokens usually opt for a value of 18, imitating the relationship between
601      * Ether and Wei. This is the value {ERC20} uses, unless this function is
602      * overridden;
603      *
604      * NOTE: This information is only used for _display_ purposes: it in
605      * no way affects any of the arithmetic of the contract, including
606      * {IERC20-balanceOf} and {IERC20-transfer}.
607      */
608     function decimals() public view virtual override returns (uint8) {
609         return 9;
610     }
611 
612     /**
613      * @dev See {IERC20-totalSupply}.
614      */
615     function totalSupply() public view virtual override returns (uint256) {
616         return _totalSupply;
617     }
618 
619     /**
620      * @dev See {IERC20-balanceOf}.
621      */
622     function balanceOf(address account) public view virtual override returns (uint256) {
623         return _balances[account];
624     }
625 
626     /**
627      * @dev See {IERC20-transfer}.
628      *
629      * Requirements:
630      *
631      * - `recipient` cannot be the zero address.
632      * - the caller must have a balance of at least `amount`.
633      */
634     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
635         _transfer(_msgSender(), recipient, amount);
636         return true;
637     }
638 
639     /**
640      * @dev See {IERC20-allowance}.
641      */
642     function allowance(address owner, address spender) public view virtual override returns (uint256) {
643         return _allowances[owner][spender];
644     }
645 
646     /**
647      * @dev See {IERC20-approve}.
648      *
649      * Requirements:
650      *
651      * - `spender` cannot be the zero address.
652      */
653     function approve(address spender, uint256 amount) public virtual override returns (bool) {
654         _approve(_msgSender(), spender, amount);
655         return true;
656     }
657 
658     /**
659      * @dev See {IERC20-transferFrom}.
660      *
661      * Emits an {Approval} event indicating the updated allowance. This is not
662      * required by the EIP. See the note at the beginning of {ERC20}.
663      *
664      * Requirements:
665      *
666      * - `sender` and `recipient` cannot be the zero address.
667      * - `sender` must have a balance of at least `amount`.
668      * - the caller must have allowance for ``sender``'s tokens of at least
669      * `amount`.
670      */
671     function transferFrom(
672         address sender,
673         address recipient,
674         uint256 amount
675     ) public virtual override returns (bool) {
676         _transfer(sender, recipient, amount);
677         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
678         return true;
679     }
680 
681     /**
682      * @dev Atomically increases the allowance granted to `spender` by the caller.
683      *
684      * This is an alternative to {approve} that can be used as a mitigation for
685      * problems described in {IERC20-approve}.
686      *
687      * Emits an {Approval} event indicating the updated allowance.
688      *
689      * Requirements:
690      *
691      * - `spender` cannot be the zero address.
692      */
693     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
694         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
695         return true;
696     }
697 
698     /**
699      * @dev Atomically decreases the allowance granted to `spender` by the caller.
700      *
701      * This is an alternative to {approve} that can be used as a mitigation for
702      * problems described in {IERC20-approve}.
703      *
704      * Emits an {Approval} event indicating the updated allowance.
705      *
706      * Requirements:
707      *
708      * - `spender` cannot be the zero address.
709      * - `spender` must have allowance for the caller of at least
710      * `subtractedValue`.
711      */
712     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
713         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
714         return true;
715     }
716 
717     /**
718      * @dev Moves tokens `amount` from `sender` to `recipient`.
719      *
720      * This is internal function is equivalent to {transfer}, and can be used to
721      * e.g. implement automatic token fees, slashing mechanisms, etc.
722      *
723      * Emits a {Transfer} event.
724      *
725      * Requirements:
726      *
727      * - `sender` cannot be the zero address.
728      * - `recipient` cannot be the zero address.
729      * - `sender` must have a balance of at least `amount`.
730      */
731     function _transfer(
732         address sender,
733         address recipient,
734         uint256 amount
735     ) internal virtual {
736         require(sender != address(0), "ERC20: transfer from the zero address");
737         require(recipient != address(0), "ERC20: transfer to the zero address");
738 
739         _beforeTokenTransfer(sender, recipient, amount);
740 
741         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
742         _balances[recipient] = _balances[recipient].add(amount);
743         emit Transfer(sender, recipient, amount);
744     }
745 
746     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
747      * the total supply.
748      *
749      * Emits a {Transfer} event with `from` set to the zero address.
750      *
751      * Requirements:
752      *
753      * - `account` cannot be the zero address.
754      */
755     function _mint(address account, uint256 amount) internal virtual {
756         require(account != address(0), "ERC20: mint to the zero address");
757 
758         _beforeTokenTransfer(address(0), account, amount);
759 
760         _totalSupply = _totalSupply.add(amount);
761         _balances[account] = _balances[account].add(amount);
762         emit Transfer(address(0), account, amount);
763     }
764 
765     /**
766      * @dev Destroys `amount` tokens from `account`, reducing the
767      * total supply.
768      *
769      * Emits a {Transfer} event with `to` set to the zero address.
770      *
771      * Requirements:
772      *
773      * - `account` cannot be the zero address.
774      * - `account` must have at least `amount` tokens.
775      */
776     function _burn(address account, uint256 amount) internal virtual {
777         require(account != address(0), "ERC20: burn from the zero address");
778 
779         _beforeTokenTransfer(account, address(0), amount);
780 
781         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
782         _totalSupply = _totalSupply.sub(amount);
783         emit Transfer(account, address(0), amount);
784     }
785 
786     /**
787      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
788      *
789      * This internal function is equivalent to `approve`, and can be used to
790      * e.g. set automatic allowances for certain subsystems, etc.
791      *
792      * Emits an {Approval} event.
793      *
794      * Requirements:
795      *
796      * - `owner` cannot be the zero address.
797      * - `spender` cannot be the zero address.
798      */
799     function _approve(
800         address owner,
801         address spender,
802         uint256 amount
803     ) internal virtual {
804         require(owner != address(0), "ERC20: approve from the zero address");
805         require(spender != address(0), "ERC20: approve to the zero address");
806 
807         _allowances[owner][spender] = amount;
808         emit Approval(owner, spender, amount);
809     }
810 
811     /**
812      * @dev Hook that is called before any transfer of tokens. This includes
813      * minting and burning.
814      *
815      * Calling conditions:
816      *
817      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
818      * will be to transferred to `to`.
819      * - when `from` is zero, `amount` tokens will be minted for `to`.
820      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
821      * - `from` and `to` are never both zero.
822      *
823      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
824      */
825     function _beforeTokenTransfer(
826         address from,
827         address to,
828         uint256 amount
829     ) internal virtual {}
830 }
831 
832 contract STEALTHX is ERC20, Ownable {
833     using SafeMath for uint256;
834 
835     address public constant DEAD_ADDRESS = address(0xdead);
836     IUniswapV2Router02 public constant uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
837 
838     uint256 public buyLiquidityFee = 1;
839     uint256 public sellLiquidityFee = 1;
840     uint256 public buyTxFee = 9;
841     uint256 public sellTxFee = 9;
842     uint256 public tokensForLiquidity;
843     uint256 public tokensForTax;
844 
845     uint256 public _tTotal = 10**9 * 10**9;                         // 1 billion
846     uint256 public swapAtAmount = _tTotal.mul(10).div(10000);       // 0.10% of total supply
847     uint256 public maxTxLimit = _tTotal.mul(50).div(10000);         // 0.50% of total supply
848     uint256 public maxWalletLimit = _tTotal.mul(100).div(10000);    // 1.00% of total supply
849 
850     address public dev;
851     address public uniswapV2Pair;
852 
853     uint256 private launchBlock;
854     bool private swapping;
855     bool public isLaunched;
856 
857     // exclude from fees
858     mapping (address => bool) public isExcludedFromFees;
859 
860     // exclude from max transaction amount
861     mapping (address => bool) public isExcludedFromTxLimit;
862 
863     // exclude from max wallet limit
864     mapping (address => bool) public isExcludedFromWalletLimit;
865 
866     // if the account is blacklisted from transacting
867     mapping (address => bool) public isBlacklisted;
868 
869 
870     constructor(address _dev) public ERC20("STEALTHX", "STHX") {
871 
872         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
873         _approve(address(this), address(uniswapV2Router), type(uint256).max);
874 
875 
876         // exclude from fees, wallet limit and transaction limit
877         excludeFromAllLimits(owner(), true);
878         excludeFromAllLimits(address(this), true);
879         excludeFromWalletLimit(uniswapV2Pair, true);
880 
881         dev = _dev;
882 
883         /*
884             _mint is an internal function in ERC20.sol that is only called here,
885             and CANNOT be called ever again
886         */
887         _mint(owner(), _tTotal);
888     }
889 
890     function excludeFromFees(address account, bool value) public onlyOwner() {
891         require(isExcludedFromFees[account] != value, "Fees: Already set to this value");
892         isExcludedFromFees[account] = value;
893     }
894 
895     function excludeFromTxLimit(address account, bool value) public onlyOwner() {
896         require(isExcludedFromTxLimit[account] != value, "TxLimit: Already set to this value");
897         isExcludedFromTxLimit[account] = value;
898     }
899 
900     function excludeFromWalletLimit(address account, bool value) public onlyOwner() {
901         require(isExcludedFromWalletLimit[account] != value, "WalletLimit: Already set to this value");
902         isExcludedFromWalletLimit[account] = value;
903     }
904 
905     function excludeFromAllLimits(address account, bool value) public onlyOwner() {
906         excludeFromFees(account, value);
907         excludeFromTxLimit(account, value);
908         excludeFromWalletLimit(account, value);
909     }
910 
911     function setBuyFee(uint256 liquidityFee, uint256 txFee) external onlyOwner() {
912         buyLiquidityFee = liquidityFee;
913         buyTxFee = txFee;
914     }
915 
916     function setSellFee(uint256 liquidityFee, uint256 txFee) external onlyOwner() {
917         sellLiquidityFee = liquidityFee;
918         sellTxFee = txFee;
919     }
920 
921     function setMaxTxLimit(uint256 newLimit) external onlyOwner() {
922         maxTxLimit = newLimit * (10**9);
923     }
924 
925     function setMaxWalletLimit(uint256 newLimit) external onlyOwner() {
926         maxWalletLimit = newLimit * (10**9);
927     }
928 
929     function setSwapAtAmount(uint256 amountToSwap) external onlyOwner() {
930         swapAtAmount = amountToSwap * (10**9);
931     }
932 
933     function updateDevWallet(address newWallet) external onlyOwner() {
934         dev = newWallet;
935     }
936 
937     function addBlacklist(address account) external onlyOwner() {
938         require(!isBlacklisted[account], "Blacklist: Already blacklisted");
939         require(account != uniswapV2Pair, "Cannot blacklist pair");
940         _setBlacklist(account, true);
941     }
942 
943     function removeBlacklist(address account) external onlyOwner() {
944         require(isBlacklisted[account], "Blacklist: Not blacklisted");
945         _setBlacklist(account, false);
946     }
947 
948     function Dissapear() external onlyOwner() {
949         require(!isLaunched, "Contract is already launched");
950         isLaunched = true;
951         launchBlock = block.number;
952     }
953 
954     function _transfer(address from, address to, uint256 amount) internal override {
955         require(from != address(0), "transfer from the zero address");
956         require(to != address(0), "transfer to the zero address");
957         require(amount <= maxTxLimit || isExcludedFromTxLimit[from] || isExcludedFromTxLimit[to], "Tx Amount too large");
958         require(balanceOf(to).add(amount) <= maxWalletLimit || isExcludedFromWalletLimit[to], "Transfer will exceed wallet limit");
959         require(isLaunched || isExcludedFromFees[from] || isExcludedFromFees[to], "Waiting to go live");
960         require(!isBlacklisted[from], "Sender is blacklisted");
961 
962         if(amount == 0) {
963             super._transfer(from, to, 0);
964             return;
965         }
966 
967         uint256 totalTokensForFee = tokensForLiquidity + tokensForTax;
968         bool canSwap = totalTokensForFee >= swapAtAmount;
969 
970         if(
971             from != uniswapV2Pair &&
972             canSwap &&
973             !swapping
974         ) {
975             swapping = true;
976             swapBack(totalTokensForFee);
977             swapping = false;
978         } else if(
979             from == uniswapV2Pair &&
980             to != uniswapV2Pair &&
981             block.number < launchBlock + 1 &&
982             !isExcludedFromFees[to]
983         ) {
984             _setBlacklist(to, true);
985         }
986 
987         bool takeFee = !swapping;
988 
989         if(isExcludedFromFees[from] || isExcludedFromFees[to]) {
990             takeFee = false;
991         }
992 
993         if(takeFee) {
994             uint256 fees;
995             // on sell
996             if (to == uniswapV2Pair) {
997                 uint256 sellTotalFees = sellLiquidityFee.add(sellTxFee);
998                 fees = amount.mul(sellTotalFees).div(100);
999                 tokensForLiquidity = tokensForLiquidity.add(fees.mul(sellLiquidityFee).div(sellTotalFees));
1000                 tokensForTax = tokensForTax.add(fees.mul(sellTxFee).div(sellTotalFees));
1001             }
1002             // on buy & wallet transfers
1003             else {
1004                 uint256 buyTotalFees = buyLiquidityFee.add(buyTxFee);
1005                 fees = amount.mul(buyTotalFees).div(100);
1006                 tokensForLiquidity = tokensForLiquidity.add(fees.mul(buyLiquidityFee).div(buyTotalFees));
1007                 tokensForTax = tokensForTax.add(fees.mul(buyTxFee).div(buyTotalFees));
1008             }
1009 
1010             if(fees > 0){
1011                 super._transfer(from, address(this), fees);
1012                 amount = amount.sub(fees);
1013             }
1014         }
1015 
1016         super._transfer(from, to, amount);
1017     }
1018 
1019     function swapBack(uint256 totalTokensForFee) private {
1020         uint256 toSwap = swapAtAmount;
1021 
1022         // Halve the amount of liquidity tokens
1023         uint256 liquidityTokens = toSwap.mul(tokensForLiquidity).div(totalTokensForFee).div(2);
1024         uint256 taxTokens = toSwap.sub(liquidityTokens).sub(liquidityTokens);
1025         uint256 amountToSwapForETH = toSwap.sub(liquidityTokens);
1026 
1027         _swapTokensForETH(amountToSwapForETH);
1028 
1029         uint256 ethBalance = address(this).balance;
1030         uint256 ethForTax = ethBalance.mul(taxTokens).div(amountToSwapForETH);
1031         uint256 ethForLiquidity = ethBalance.sub(ethForTax);
1032 
1033         tokensForLiquidity = tokensForLiquidity.sub(liquidityTokens.mul(2));
1034         tokensForTax = tokensForTax.sub(toSwap.sub(liquidityTokens.mul(2)));
1035 
1036         payable(address(dev)).transfer(ethForTax);
1037         _addLiquidity(liquidityTokens, ethForLiquidity);
1038     }
1039 
1040     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1041 
1042         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1043             address(this),
1044             tokenAmount,
1045             0,
1046             0,
1047             DEAD_ADDRESS,
1048             block.timestamp
1049         );
1050     }
1051 
1052     function _swapTokensForETH(uint256 tokenAmount) private {
1053 
1054         address[] memory path = new address[](2);
1055         path[0] = address(this);
1056         path[1] = uniswapV2Router.WETH();
1057 
1058         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1059             tokenAmount,
1060             0,
1061             path,
1062             address(this),
1063             block.timestamp
1064         );
1065     }
1066 
1067     function _setBlacklist(address account, bool value) internal {
1068         isBlacklisted[account] = value;
1069     }
1070 
1071     receive() external payable {}
1072 }