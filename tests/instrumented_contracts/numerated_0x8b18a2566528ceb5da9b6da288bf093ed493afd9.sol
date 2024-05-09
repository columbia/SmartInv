1 pragma solidity ^0.6.12;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP.
5  */
6 interface IERC20 {
7     /**
8      * @dev Returns the amount of tokens in existence.
9      */
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `sender` to `recipient` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(
61         address sender,
62         address recipient,
63         uint256 amount
64     ) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 /**
82  * @dev Interface for the optional metadata functions from the ERC20 standard.
83  *
84  * _Available since v4.1._
85  */
86 interface IERC20Metadata is IERC20 {
87     /**
88      * @dev Returns the name of the token.
89      */
90     function name() external view returns (string memory);
91 
92     /**
93      * @dev Returns the symbol of the token.
94      */
95     function symbol() external view returns (string memory);
96 
97     /**
98      * @dev Returns the decimals places of the token.
99      */
100     function decimals() external view returns (uint8);
101 }
102 
103 /*
104  * @dev Provides information about the current execution context, including the
105  * sender of the transaction and its data. While these are generally available
106  * via msg.sender and msg.data, they should not be accessed in such a direct
107  * manner, since when dealing with meta-transactions the account sending and
108  * paying for execution may not be the actual sender (as far as an application
109  * is concerned).
110  *
111  * This contract is only required for intermediate, library-like contracts.
112  */
113 abstract contract Context {
114     function _msgSender() internal view virtual returns (address) {
115         return msg.sender;
116     }
117 
118     function _msgData() internal view virtual returns (bytes calldata) {
119         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
120         return msg.data;
121     }
122 }
123 
124 contract Ownable is Context {
125     address private _owner;
126 
127     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
128 
129     /**
130      * @dev Initializes the contract setting the deployer as the initial owner.
131      */
132     constructor () public {
133         address msgSender = _msgSender();
134         _owner = msgSender;
135         emit OwnershipTransferred(address(0), msgSender);
136     }
137 
138     /**
139      * @dev Returns the address of the current owner.
140      */
141     function owner() public view returns (address) {
142         return _owner;
143     }
144 
145     /**
146      * @dev Throws if called by any account other than the owner.
147      */
148     modifier onlyOwner() {
149         require(_owner == _msgSender(), "Ownable: caller is not the owner");
150         _;
151     }
152 
153     /**
154      * @dev Leaves the contract without owner. It will not be possible to call
155      * `onlyOwner` functions anymore. Can only be called by the current owner.
156      *
157      * NOTE: Renouncing ownership will leave the contract without an owner,
158      * thereby removing any functionality that is only available to the owner.
159      */
160     function renounceOwnership() public virtual onlyOwner {
161         emit OwnershipTransferred(_owner, address(0));
162         _owner = address(0);
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Can only be called by the current owner.
168      */
169     function transferOwnership(address newOwner) public virtual onlyOwner {
170         require(newOwner != address(0), "Ownable: new owner is the zero address");
171         emit OwnershipTransferred(_owner, newOwner);
172         _owner = newOwner;
173     }
174 }
175 
176 library SafeMath {
177     /**
178      * @dev Returns the addition of two unsigned integers, reverting on
179      * overflow.
180      *
181      * Counterpart to Solidity's `+` operator.
182      *
183      * Requirements:
184      *
185      * - Addition cannot overflow.
186      */
187     function add(uint256 a, uint256 b) internal pure returns (uint256) {
188         uint256 c = a + b;
189         require(c >= a, "SafeMath: addition overflow");
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the subtraction of two unsigned integers, reverting on
196      * overflow (when the result is negative).
197      *
198      * Counterpart to Solidity's `-` operator.
199      *
200      * Requirements:
201      *
202      * - Subtraction cannot overflow.
203      */
204     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
205         return sub(a, b, "SafeMath: subtraction overflow");
206     }
207 
208     /**
209      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
210      * overflow (when the result is negative).
211      *
212      * Counterpart to Solidity's `-` operator.
213      *
214      * Requirements:
215      *
216      * - Subtraction cannot overflow.
217      */
218     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b <= a, errorMessage);
220         uint256 c = a - b;
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the multiplication of two unsigned integers, reverting on
227      * overflow.
228      *
229      * Counterpart to Solidity's `*` operator.
230      *
231      * Requirements:
232      *
233      * - Multiplication cannot overflow.
234      */
235     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
236         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
237         // benefit is lost if 'b' is also tested.
238         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
239         if (a == 0) {
240             return 0;
241         }
242 
243         uint256 c = a * b;
244         require(c / a == b, "SafeMath: multiplication overflow");
245 
246         return c;
247     }
248 
249     /**
250      * @dev Returns the integer division of two unsigned integers. Reverts on
251      * division by zero. The result is rounded towards zero.
252      *
253      * Counterpart to Solidity's `/` operator. Note: this function uses a
254      * `revert` opcode (which leaves remaining gas untouched) while Solidity
255      * uses an invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function div(uint256 a, uint256 b) internal pure returns (uint256) {
262         return div(a, b, "SafeMath: division by zero");
263     }
264 
265     /**
266      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
267      * division by zero. The result is rounded towards zero.
268      *
269      * Counterpart to Solidity's `/` operator. Note: this function uses a
270      * `revert` opcode (which leaves remaining gas untouched) while Solidity
271      * uses an invalid opcode to revert (consuming all remaining gas).
272      *
273      * Requirements:
274      *
275      * - The divisor cannot be zero.
276      */
277     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
278         require(b > 0, errorMessage);
279         uint256 c = a / b;
280         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
281 
282         return c;
283     }
284 
285     /**
286      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
287      * Reverts when dividing by zero.
288      *
289      * Counterpart to Solidity's `%` operator. This function uses a `revert`
290      * opcode (which leaves remaining gas untouched) while Solidity uses an
291      * invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      *
295      * - The divisor cannot be zero.
296      */
297     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
298         return mod(a, b, "SafeMath: modulo by zero");
299     }
300 
301     /**
302      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
303      * Reverts with custom message when dividing by zero.
304      *
305      * Counterpart to Solidity's `%` operator. This function uses a `revert`
306      * opcode (which leaves remaining gas untouched) while Solidity uses an
307      * invalid opcode to revert (consuming all remaining gas).
308      *
309      * Requirements:
310      *
311      * - The divisor cannot be zero.
312      */
313     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
314         require(b != 0, errorMessage);
315         return a % b;
316     }
317 }
318 
319 interface IUniswapV2Pair {
320     event Approval(address indexed owner, address indexed spender, uint value);
321     event Transfer(address indexed from, address indexed to, uint value);
322 
323     function name() external pure returns (string memory);
324     function symbol() external pure returns (string memory);
325     function decimals() external pure returns (uint8);
326     function totalSupply() external view returns (uint);
327     function balanceOf(address owner) external view returns (uint);
328     function allowance(address owner, address spender) external view returns (uint);
329 
330     function approve(address spender, uint value) external returns (bool);
331     function transfer(address to, uint value) external returns (bool);
332     function transferFrom(address from, address to, uint value) external returns (bool);
333 
334     function DOMAIN_SEPARATOR() external view returns (bytes32);
335     function PERMIT_TYPEHASH() external pure returns (bytes32);
336     function nonces(address owner) external view returns (uint);
337 
338     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
339 
340     event Mint(address indexed sender, uint amount0, uint amount1);
341     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
342     event Swap(
343         address indexed sender,
344         uint amount0In,
345         uint amount1In,
346         uint amount0Out,
347         uint amount1Out,
348         address indexed to
349     );
350     event Sync(uint112 reserve0, uint112 reserve1);
351 
352     function MINIMUM_LIQUIDITY() external pure returns (uint);
353     function factory() external view returns (address);
354     function token0() external view returns (address);
355     function token1() external view returns (address);
356     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
357     function price0CumulativeLast() external view returns (uint);
358     function price1CumulativeLast() external view returns (uint);
359     function kLast() external view returns (uint);
360 
361     function mint(address to) external returns (uint liquidity);
362     function burn(address to) external returns (uint amount0, uint amount1);
363     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
364     function skim(address to) external;
365     function sync() external;
366 
367     function initialize(address, address) external;
368 }
369 
370 interface IUniswapV2Factory {
371     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
372 
373     function feeTo() external view returns (address);
374     function feeToSetter() external view returns (address);
375 
376     function getPair(address tokenA, address tokenB) external view returns (address pair);
377     function allPairs(uint) external view returns (address pair);
378     function allPairsLength() external view returns (uint);
379 
380     function createPair(address tokenA, address tokenB) external returns (address pair);
381 
382     function setFeeTo(address) external;
383     function setFeeToSetter(address) external;
384 }
385 
386 interface IUniswapV2Router01 {
387     function factory() external pure returns (address);
388     function WETH() external pure returns (address);
389 
390     function addLiquidity(
391         address tokenA,
392         address tokenB,
393         uint amountADesired,
394         uint amountBDesired,
395         uint amountAMin,
396         uint amountBMin,
397         address to,
398         uint deadline
399     ) external returns (uint amountA, uint amountB, uint liquidity);
400     function addLiquidityETH(
401         address token,
402         uint amountTokenDesired,
403         uint amountTokenMin,
404         uint amountETHMin,
405         address to,
406         uint deadline
407     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
408     function removeLiquidity(
409         address tokenA,
410         address tokenB,
411         uint liquidity,
412         uint amountAMin,
413         uint amountBMin,
414         address to,
415         uint deadline
416     ) external returns (uint amountA, uint amountB);
417     function removeLiquidityETH(
418         address token,
419         uint liquidity,
420         uint amountTokenMin,
421         uint amountETHMin,
422         address to,
423         uint deadline
424     ) external returns (uint amountToken, uint amountETH);
425     function removeLiquidityWithPermit(
426         address tokenA,
427         address tokenB,
428         uint liquidity,
429         uint amountAMin,
430         uint amountBMin,
431         address to,
432         uint deadline,
433         bool approveMax, uint8 v, bytes32 r, bytes32 s
434     ) external returns (uint amountA, uint amountB);
435     function removeLiquidityETHWithPermit(
436         address token,
437         uint liquidity,
438         uint amountTokenMin,
439         uint amountETHMin,
440         address to,
441         uint deadline,
442         bool approveMax, uint8 v, bytes32 r, bytes32 s
443     ) external returns (uint amountToken, uint amountETH);
444     function swapExactTokensForTokens(
445         uint amountIn,
446         uint amountOutMin,
447         address[] calldata path,
448         address to,
449         uint deadline
450     ) external returns (uint[] memory amounts);
451     function swapTokensForExactTokens(
452         uint amountOut,
453         uint amountInMax,
454         address[] calldata path,
455         address to,
456         uint deadline
457     ) external returns (uint[] memory amounts);
458     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
459         external
460         payable
461         returns (uint[] memory amounts);
462     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
463         external
464         returns (uint[] memory amounts);
465     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
466         external
467         returns (uint[] memory amounts);
468     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
469         external
470         payable
471         returns (uint[] memory amounts);
472 
473     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
474     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
475     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
476     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
477     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
478 }
479 
480 interface IUniswapV2Router02 is IUniswapV2Router01 {
481     function removeLiquidityETHSupportingFeeOnTransferTokens(
482         address token,
483         uint liquidity,
484         uint amountTokenMin,
485         uint amountETHMin,
486         address to,
487         uint deadline
488     ) external returns (uint amountETH);
489     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
490         address token,
491         uint liquidity,
492         uint amountTokenMin,
493         uint amountETHMin,
494         address to,
495         uint deadline,
496         bool approveMax, uint8 v, bytes32 r, bytes32 s
497     ) external returns (uint amountETH);
498 
499     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
500         uint amountIn,
501         uint amountOutMin,
502         address[] calldata path,
503         address to,
504         uint deadline
505     ) external;
506     function swapExactETHForTokensSupportingFeeOnTransferTokens(
507         uint amountOutMin,
508         address[] calldata path,
509         address to,
510         uint deadline
511     ) external payable;
512     function swapExactTokensForETHSupportingFeeOnTransferTokens(
513         uint amountIn,
514         uint amountOutMin,
515         address[] calldata path,
516         address to,
517         uint deadline
518     ) external;
519 }
520 
521 /**
522  * @dev Implementation of the {IERC20} interface.
523  *
524  * This implementation is agnostic to the way tokens are created. This means
525  * that a supply mechanism has to be added in a derived contract using {_mint}.
526  * For a generic mechanism see {ERC20PresetMinterPauser}.
527  *
528  * TIP: For a detailed writeup see our guide
529  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
530  * to implement supply mechanisms].
531  *
532  * We have followed general OpenZeppelin guidelines: functions revert instead
533  * of returning `false` on failure. This behavior is nonetheless conventional
534  * and does not conflict with the expectations of ERC20 applications.
535  *
536  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
537  * This allows applications to reconstruct the allowance for all accounts just
538  * by listening to said events. Other implementations of the EIP may not emit
539  * these events, as it isn't required by the specification.
540  *
541  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
542  * functions have been added to mitigate the well-known issues around setting
543  * allowances. See {IERC20-approve}.
544  */
545 contract ERC20 is Context, IERC20, IERC20Metadata {
546     using SafeMath for uint256;
547 
548     mapping(address => uint256) private _balances;
549 
550     mapping(address => mapping(address => uint256)) private _allowances;
551 
552     uint256 private _totalSupply;
553 
554     string private _name;
555     string private _symbol;
556 
557     /**
558      * @dev Sets the values for {name} and {symbol}.
559      *
560      * The default value of {decimals} is 18. To select a different value for
561      * {decimals} you should overload it.
562      *
563      * All two of these values are immutable: they can only be set once during
564      * construction.
565      */
566     constructor(string memory name_, string memory symbol_) public {
567         _name = name_;
568         _symbol = symbol_;
569     }
570 
571     /**
572      * @dev Returns the name of the token.
573      */
574     function name() public view virtual override returns (string memory) {
575         return _name;
576     }
577 
578     /**
579      * @dev Returns the symbol of the token, usually a shorter version of the
580      * name.
581      */
582     function symbol() public view virtual override returns (string memory) {
583         return _symbol;
584     }
585 
586     /**
587      * @dev Returns the number of decimals used to get its user representation.
588      * For example, if `decimals` equals `2`, a balance of `505` tokens should
589      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
590      *
591      * Tokens usually opt for a value of 18, imitating the relationship between
592      * Ether and Wei. This is the value {ERC20} uses, unless this function is
593      * overridden;
594      *
595      * NOTE: This information is only used for _display_ purposes: it in
596      * no way affects any of the arithmetic of the contract, including
597      * {IERC20-balanceOf} and {IERC20-transfer}.
598      */
599     function decimals() public view virtual override returns (uint8) {
600         return 9;
601     }
602 
603     /**
604      * @dev See {IERC20-totalSupply}.
605      */
606     function totalSupply() public view virtual override returns (uint256) {
607         return _totalSupply;
608     }
609 
610     /**
611      * @dev See {IERC20-balanceOf}.
612      */
613     function balanceOf(address account) public view virtual override returns (uint256) {
614         return _balances[account];
615     }
616 
617     /**
618      * @dev See {IERC20-transfer}.
619      *
620      * Requirements:
621      *
622      * - `recipient` cannot be the zero address.
623      * - the caller must have a balance of at least `amount`.
624      */
625     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
626         _transfer(_msgSender(), recipient, amount);
627         return true;
628     }
629 
630     /**
631      * @dev See {IERC20-allowance}.
632      */
633     function allowance(address owner, address spender) public view virtual override returns (uint256) {
634         return _allowances[owner][spender];
635     }
636 
637     /**
638      * @dev See {IERC20-approve}.
639      *
640      * Requirements:
641      *
642      * - `spender` cannot be the zero address.
643      */
644     function approve(address spender, uint256 amount) public virtual override returns (bool) {
645         _approve(_msgSender(), spender, amount);
646         return true;
647     }
648 
649     /**
650      * @dev See {IERC20-transferFrom}.
651      *
652      * Emits an {Approval} event indicating the updated allowance. This is not
653      * required by the EIP. See the note at the beginning of {ERC20}.
654      *
655      * Requirements:
656      *
657      * - `sender` and `recipient` cannot be the zero address.
658      * - `sender` must have a balance of at least `amount`.
659      * - the caller must have allowance for ``sender``'s tokens of at least
660      * `amount`.
661      */
662     function transferFrom(
663         address sender,
664         address recipient,
665         uint256 amount
666     ) public virtual override returns (bool) {
667         _transfer(sender, recipient, amount);
668         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
669         return true;
670     }
671 
672     /**
673      * @dev Atomically increases the allowance granted to `spender` by the caller.
674      *
675      * This is an alternative to {approve} that can be used as a mitigation for
676      * problems described in {IERC20-approve}.
677      *
678      * Emits an {Approval} event indicating the updated allowance.
679      *
680      * Requirements:
681      *
682      * - `spender` cannot be the zero address.
683      */
684     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
685         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
686         return true;
687     }
688 
689     /**
690      * @dev Atomically decreases the allowance granted to `spender` by the caller.
691      *
692      * This is an alternative to {approve} that can be used as a mitigation for
693      * problems described in {IERC20-approve}.
694      *
695      * Emits an {Approval} event indicating the updated allowance.
696      *
697      * Requirements:
698      *
699      * - `spender` cannot be the zero address.
700      * - `spender` must have allowance for the caller of at least
701      * `subtractedValue`.
702      */
703     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
704         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
705         return true;
706     }
707 
708     /**
709      * @dev Moves tokens `amount` from `sender` to `recipient`.
710      *
711      * This is internal function is equivalent to {transfer}, and can be used to
712      * e.g. implement automatic token fees, slashing mechanisms, etc.
713      *
714      * Emits a {Transfer} event.
715      *
716      * Requirements:
717      *
718      * - `sender` cannot be the zero address.
719      * - `recipient` cannot be the zero address.
720      * - `sender` must have a balance of at least `amount`.
721      */
722     function _transfer(
723         address sender,
724         address recipient,
725         uint256 amount
726     ) internal virtual {
727         require(sender != address(0), "ERC20: transfer from the zero address");
728         require(recipient != address(0), "ERC20: transfer to the zero address");
729 
730         _beforeTokenTransfer(sender, recipient, amount);
731 
732         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
733         _balances[recipient] = _balances[recipient].add(amount);
734         emit Transfer(sender, recipient, amount);
735     }
736 
737     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
738      * the total supply.
739      *
740      * Emits a {Transfer} event with `from` set to the zero address.
741      *
742      * Requirements:
743      *
744      * - `account` cannot be the zero address.
745      */
746     function _mint(address account, uint256 amount) internal virtual {
747         require(account != address(0), "ERC20: mint to the zero address");
748 
749         _beforeTokenTransfer(address(0), account, amount);
750 
751         _totalSupply = _totalSupply.add(amount);
752         _balances[account] = _balances[account].add(amount);
753         emit Transfer(address(0), account, amount);
754     }
755 
756     /**
757      * @dev Destroys `amount` tokens from `account`, reducing the
758      * total supply.
759      *
760      * Emits a {Transfer} event with `to` set to the zero address.
761      *
762      * Requirements:
763      *
764      * - `account` cannot be the zero address.
765      * - `account` must have at least `amount` tokens.
766      */
767     function _burn(address account, uint256 amount) internal virtual {
768         require(account != address(0), "ERC20: burn from the zero address");
769 
770         _beforeTokenTransfer(account, address(0), amount);
771 
772         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
773         _totalSupply = _totalSupply.sub(amount);
774         emit Transfer(account, address(0), amount);
775     }
776 
777     /**
778      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
779      *
780      * This internal function is equivalent to `approve`, and can be used to
781      * e.g. set automatic allowances for certain subsystems, etc.
782      *
783      * Emits an {Approval} event.
784      *
785      * Requirements:
786      *
787      * - `owner` cannot be the zero address.
788      * - `spender` cannot be the zero address.
789      */
790     function _approve(
791         address owner,
792         address spender,
793         uint256 amount
794     ) internal virtual {
795         require(owner != address(0), "ERC20: approve from the zero address");
796         require(spender != address(0), "ERC20: approve to the zero address");
797 
798         _allowances[owner][spender] = amount;
799         emit Approval(owner, spender, amount);
800     }
801 
802     /**
803      * @dev Hook that is called before any transfer of tokens. This includes
804      * minting and burning.
805      *
806      * Calling conditions:
807      *
808      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
809      * will be to transferred to `to`.
810      * - when `from` is zero, `amount` tokens will be minted for `to`.
811      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
812      * - `from` and `to` are never both zero.
813      *
814      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
815      */
816     function _beforeTokenTransfer(
817         address from,
818         address to,
819         uint256 amount
820     ) internal virtual {}
821 }
822 
823 contract MISOORS is ERC20, Ownable {
824     using SafeMath for uint256;
825 
826     address public constant DEAD_ADDRESS = address(0xdead);
827     IUniswapV2Router02 public constant uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
828 
829     uint256 public buyLiquidityFee = 1;
830     uint256 public sellLiquidityFee = 1;
831     uint256 public buyTxFee = 4;
832     uint256 public sellTxFee = 4;
833     uint256 public tokensForLiquidity;
834     uint256 public tokensForTax;
835 
836     uint256 public _tTotal = 10**6 * 10**9;                         // 1 million
837     uint256 public swapAtAmount = _tTotal.mul(10).div(100);       // 0.10% of total supply
838     uint256 public maxTxLimit = _tTotal.mul(50).div(100);         // 0.50% of total supply
839     uint256 public maxWalletLimit = _tTotal.mul(100).div(100);    // 1.00% of total supply
840 
841     address public dev;
842     address public uniswapV2Pair;
843 
844     uint256 private launchBlock;
845     bool private swapping;
846     bool public isLaunched;
847 
848     // exclude from fees
849     mapping (address => bool) public isExcludedFromFees;
850 
851     // exclude from max transaction amount
852     mapping (address => bool) public isExcludedFromTxLimit;
853 
854     // exclude from max wallet limit
855     mapping (address => bool) public isExcludedFromWalletLimit;
856 
857     // if the account is blacklisted from transacting
858     mapping (address => bool) public isBlacklisted;
859 
860 
861     constructor(address _dev) public ERC20("MISOORS", "MISOORS") {
862 
863         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
864         _approve(address(this), address(uniswapV2Router), type(uint256).max);
865 
866 
867         // exclude from fees, wallet limit and transaction limit
868         excludeFromAllLimits(owner(), true);
869         excludeFromAllLimits(address(this), true);
870         excludeFromWalletLimit(uniswapV2Pair, true);
871 
872         dev = _dev;
873 
874         /*
875             _mint is an internal function in ERC20.sol that is only called here,
876             and CANNOT be called ever again
877         */
878         _mint(owner(), _tTotal);
879     }
880 
881     function excludeFromFees(address account, bool value) public onlyOwner() {
882         require(isExcludedFromFees[account] != value, "Fees: Already set to this value");
883         isExcludedFromFees[account] = value;
884     }
885 
886     function excludeFromTxLimit(address account, bool value) public onlyOwner() {
887         require(isExcludedFromTxLimit[account] != value, "TxLimit: Already set to this value");
888         isExcludedFromTxLimit[account] = value;
889     }
890 
891     function excludeFromWalletLimit(address account, bool value) public onlyOwner() {
892         require(isExcludedFromWalletLimit[account] != value, "WalletLimit: Already set to this value");
893         isExcludedFromWalletLimit[account] = value;
894     }
895 
896     function excludeFromAllLimits(address account, bool value) public onlyOwner() {
897         excludeFromFees(account, value);
898         excludeFromTxLimit(account, value);
899         excludeFromWalletLimit(account, value);
900     }
901 
902     function setBuyFee(uint256 liquidityFee, uint256 txFee) external onlyOwner() {
903         buyLiquidityFee = liquidityFee;
904         buyTxFee = txFee;
905     }
906 
907     function setSellFee(uint256 liquidityFee, uint256 txFee) external onlyOwner() {
908         sellLiquidityFee = liquidityFee;
909         sellTxFee = txFee;
910     }
911 
912     function setMaxTxLimit(uint256 newLimit) external onlyOwner() {
913         maxTxLimit = newLimit * (10**9);
914     }
915 
916     function setMaxWalletLimit(uint256 newLimit) external onlyOwner() {
917         maxWalletLimit = newLimit * (10**9);
918     }
919 
920     function setSwapAtAmount(uint256 amountToSwap) external onlyOwner() {
921         swapAtAmount = amountToSwap * (10**9);
922     }
923 
924     function updateDevWallet(address newWallet) external onlyOwner() {
925         dev = newWallet;
926     }
927 
928     function addBlacklist(address account) external onlyOwner() {
929         require(!isBlacklisted[account], "Blacklist: Already blacklisted");
930         require(account != uniswapV2Pair, "Cannot blacklist pair");
931         _setBlacklist(account, true);
932     }
933 
934     function removeBlacklist(address account) external onlyOwner() {
935         require(isBlacklisted[account], "Blacklist: Not blacklisted");
936         _setBlacklist(account, false);
937     }
938 
939     function launchNow() external onlyOwner() {
940         require(!isLaunched, "Contract is already launched");
941         isLaunched = true;
942         launchBlock = block.number;
943     }
944 
945     function _transfer(address from, address to, uint256 amount) internal override {
946         require(from != address(0), "transfer from the zero address");
947         require(to != address(0), "transfer to the zero address");
948         require(amount <= maxTxLimit || isExcludedFromTxLimit[from] || isExcludedFromTxLimit[to], "Tx Amount too large");
949         require(balanceOf(to).add(amount) <= maxWalletLimit || isExcludedFromWalletLimit[to], "Transfer will exceed wallet limit");
950         require(isLaunched || isExcludedFromFees[from] || isExcludedFromFees[to], "Waiting to go live");
951         require(!isBlacklisted[from], "Sender is blacklisted");
952 
953         if(amount == 0) {
954             super._transfer(from, to, 0);
955             return;
956         }
957 
958         uint256 totalTokensForFee = tokensForLiquidity + tokensForTax;
959         bool canSwap = totalTokensForFee >= swapAtAmount;
960 
961         if(
962             from != uniswapV2Pair &&
963             canSwap &&
964             !swapping
965         ) {
966             swapping = true;
967             swapBack(totalTokensForFee);
968             swapping = false;
969         } else if(
970             from == uniswapV2Pair &&
971             to != uniswapV2Pair &&
972             block.number < launchBlock + 3 &&
973             !isExcludedFromFees[to]
974         ) {
975             _setBlacklist(to, true);
976         }
977 
978         bool takeFee = !swapping;
979 
980         if(isExcludedFromFees[from] || isExcludedFromFees[to]) {
981             takeFee = false;
982         }
983 
984         if(takeFee) {
985             uint256 fees;
986             // on sell
987             if (to == uniswapV2Pair) {
988                 uint256 sellTotalFees = sellLiquidityFee.add(sellTxFee);
989                 fees = amount.mul(sellTotalFees).div(100);
990                 tokensForLiquidity = tokensForLiquidity.add(fees.mul(sellLiquidityFee).div(sellTotalFees));
991                 tokensForTax = tokensForTax.add(fees.mul(sellTxFee).div(sellTotalFees));
992             }
993             // on buy & wallet transfers
994             else {
995                 uint256 buyTotalFees = buyLiquidityFee.add(buyTxFee);
996                 fees = amount.mul(buyTotalFees).div(100);
997                 tokensForLiquidity = tokensForLiquidity.add(fees.mul(buyLiquidityFee).div(buyTotalFees));
998                 tokensForTax = tokensForTax.add(fees.mul(buyTxFee).div(buyTotalFees));
999             }
1000 
1001             if(fees > 0){
1002                 super._transfer(from, address(this), fees);
1003                 amount = amount.sub(fees);
1004             }
1005         }
1006 
1007         super._transfer(from, to, amount);
1008     }
1009 
1010     function swapBack(uint256 totalTokensForFee) private {
1011         uint256 toSwap = swapAtAmount;
1012 
1013         // Halve the amount of liquidity tokens
1014         uint256 liquidityTokens = toSwap.mul(tokensForLiquidity).div(totalTokensForFee).div(2);
1015         uint256 taxTokens = toSwap.sub(liquidityTokens).sub(liquidityTokens);
1016         uint256 amountToSwapForETH = toSwap.sub(liquidityTokens);
1017 
1018         _swapTokensForETH(amountToSwapForETH);
1019 
1020         uint256 ethBalance = address(this).balance;
1021         uint256 ethForTax = ethBalance.mul(taxTokens).div(amountToSwapForETH);
1022         uint256 ethForLiquidity = ethBalance.sub(ethForTax);
1023 
1024         tokensForLiquidity = tokensForLiquidity.sub(liquidityTokens.mul(2));
1025         tokensForTax = tokensForTax.sub(toSwap.sub(liquidityTokens.mul(2)));
1026 
1027         payable(address(dev)).transfer(ethForTax);
1028         _addLiquidity(liquidityTokens, ethForLiquidity);
1029     }
1030 
1031     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1032 
1033         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1034             address(this),
1035             tokenAmount,
1036             0,
1037             0,
1038             DEAD_ADDRESS,
1039             block.timestamp
1040         );
1041     }
1042 
1043     function _swapTokensForETH(uint256 tokenAmount) private {
1044 
1045         address[] memory path = new address[](2);
1046         path[0] = address(this);
1047         path[1] = uniswapV2Router.WETH();
1048 
1049         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1050             tokenAmount,
1051             0,
1052             path,
1053             address(this),
1054             block.timestamp
1055         );
1056     }
1057 
1058     function _setBlacklist(address account, bool value) internal {
1059         isBlacklisted[account] = value;
1060     }
1061 
1062     receive() external payable {}
1063 }