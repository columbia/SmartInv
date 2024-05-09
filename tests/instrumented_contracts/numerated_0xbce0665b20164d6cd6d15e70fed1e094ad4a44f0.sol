1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.12;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(
63         address sender,
64         address recipient,
65         uint256 amount
66     ) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 /**
84  * @dev Interface for the optional metadata functions from the ERC20 standard.
85  *
86  * _Available since v4.1._
87  */
88 interface IERC20Metadata is IERC20 {
89     /**
90      * @dev Returns the name of the token.
91      */
92     function name() external view returns (string memory);
93 
94     /**
95      * @dev Returns the symbol of the token.
96      */
97     function symbol() external view returns (string memory);
98 
99     /**
100      * @dev Returns the decimals places of the token.
101      */
102     function decimals() external view returns (uint8);
103 }
104 
105 /*
106  * @dev Provides information about the current execution context, including the
107  * sender of the transaction and its data. While these are generally available
108  * via msg.sender and msg.data, they should not be accessed in such a direct
109  * manner, since when dealing with meta-transactions the account sending and
110  * paying for execution may not be the actual sender (as far as an application
111  * is concerned).
112  *
113  * This contract is only required for intermediate, library-like contracts.
114  */
115 abstract contract Context {
116     function _msgSender() internal view virtual returns (address) {
117         return msg.sender;
118     }
119 
120     function _msgData() internal view virtual returns (bytes calldata) {
121         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
122         return msg.data;
123     }
124 }
125 
126 contract Ownable is Context {
127     address private _owner;
128 
129     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
130 
131     /**
132      * @dev Initializes the contract setting the deployer as the initial owner.
133      */
134     constructor () public {
135         address msgSender = _msgSender();
136         _owner = msgSender;
137         emit OwnershipTransferred(address(0), msgSender);
138     }
139 
140     /**
141      * @dev Returns the address of the current owner.
142      */
143     function owner() public view returns (address) {
144         return _owner;
145     }
146 
147     /**
148      * @dev Throws if called by any account other than the owner.
149      */
150     modifier onlyOwner() {
151         require(_owner == _msgSender(), "Ownable: caller is not the owner");
152         _;
153     }
154 
155     /**
156      * @dev Leaves the contract without owner. It will not be possible to call
157      * `onlyOwner` functions anymore. Can only be called by the current owner.
158      *
159      * NOTE: Renouncing ownership will leave the contract without an owner,
160      * thereby removing any functionality that is only available to the owner.
161      */
162     function renounceOwnership() public virtual onlyOwner {
163         emit OwnershipTransferred(_owner, address(0));
164         _owner = address(0);
165     }
166 
167     /**
168      * @dev Transfers ownership of the contract to a new account (`newOwner`).
169      * Can only be called by the current owner.
170      */
171     function transferOwnership(address newOwner) public virtual onlyOwner {
172         require(newOwner != address(0), "Ownable: new owner is the zero address");
173         emit OwnershipTransferred(_owner, newOwner);
174         _owner = newOwner;
175     }
176 }
177 
178 library SafeMath {
179     /**
180      * @dev Returns the addition of two unsigned integers, reverting on
181      * overflow.
182      *
183      * Counterpart to Solidity's `+` operator.
184      *
185      * Requirements:
186      *
187      * - Addition cannot overflow.
188      */
189     function add(uint256 a, uint256 b) internal pure returns (uint256) {
190         uint256 c = a + b;
191         require(c >= a, "SafeMath: addition overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the subtraction of two unsigned integers, reverting on
198      * overflow (when the result is negative).
199      *
200      * Counterpart to Solidity's `-` operator.
201      *
202      * Requirements:
203      *
204      * - Subtraction cannot overflow.
205      */
206     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
207         return sub(a, b, "SafeMath: subtraction overflow");
208     }
209 
210     /**
211      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
212      * overflow (when the result is negative).
213      *
214      * Counterpart to Solidity's `-` operator.
215      *
216      * Requirements:
217      *
218      * - Subtraction cannot overflow.
219      */
220     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         require(b <= a, errorMessage);
222         uint256 c = a - b;
223 
224         return c;
225     }
226 
227     /**
228      * @dev Returns the multiplication of two unsigned integers, reverting on
229      * overflow.
230      *
231      * Counterpart to Solidity's `*` operator.
232      *
233      * Requirements:
234      *
235      * - Multiplication cannot overflow.
236      */
237     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
238         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
239         // benefit is lost if 'b' is also tested.
240         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
241         if (a == 0) {
242             return 0;
243         }
244 
245         uint256 c = a * b;
246         require(c / a == b, "SafeMath: multiplication overflow");
247 
248         return c;
249     }
250 
251     /**
252      * @dev Returns the integer division of two unsigned integers. Reverts on
253      * division by zero. The result is rounded towards zero.
254      *
255      * Counterpart to Solidity's `/` operator. Note: this function uses a
256      * `revert` opcode (which leaves remaining gas untouched) while Solidity
257      * uses an invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function div(uint256 a, uint256 b) internal pure returns (uint256) {
264         return div(a, b, "SafeMath: division by zero");
265     }
266 
267     /**
268      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
269      * division by zero. The result is rounded towards zero.
270      *
271      * Counterpart to Solidity's `/` operator. Note: this function uses a
272      * `revert` opcode (which leaves remaining gas untouched) while Solidity
273      * uses an invalid opcode to revert (consuming all remaining gas).
274      *
275      * Requirements:
276      *
277      * - The divisor cannot be zero.
278      */
279     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
280         require(b > 0, errorMessage);
281         uint256 c = a / b;
282         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
283 
284         return c;
285     }
286 
287     /**
288      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
289      * Reverts when dividing by zero.
290      *
291      * Counterpart to Solidity's `%` operator. This function uses a `revert`
292      * opcode (which leaves remaining gas untouched) while Solidity uses an
293      * invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      *
297      * - The divisor cannot be zero.
298      */
299     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
300         return mod(a, b, "SafeMath: modulo by zero");
301     }
302 
303     /**
304      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
305      * Reverts with custom message when dividing by zero.
306      *
307      * Counterpart to Solidity's `%` operator. This function uses a `revert`
308      * opcode (which leaves remaining gas untouched) while Solidity uses an
309      * invalid opcode to revert (consuming all remaining gas).
310      *
311      * Requirements:
312      *
313      * - The divisor cannot be zero.
314      */
315     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
316         require(b != 0, errorMessage);
317         return a % b;
318     }
319 }
320 
321 interface IUniswapV2Pair {
322     event Approval(address indexed owner, address indexed spender, uint value);
323     event Transfer(address indexed from, address indexed to, uint value);
324 
325     function name() external pure returns (string memory);
326     function symbol() external pure returns (string memory);
327     function decimals() external pure returns (uint8);
328     function totalSupply() external view returns (uint);
329     function balanceOf(address owner) external view returns (uint);
330     function allowance(address owner, address spender) external view returns (uint);
331 
332     function approve(address spender, uint value) external returns (bool);
333     function transfer(address to, uint value) external returns (bool);
334     function transferFrom(address from, address to, uint value) external returns (bool);
335 
336     function DOMAIN_SEPARATOR() external view returns (bytes32);
337     function PERMIT_TYPEHASH() external pure returns (bytes32);
338     function nonces(address owner) external view returns (uint);
339 
340     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
341 
342     event Mint(address indexed sender, uint amount0, uint amount1);
343     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
344     event Swap(
345         address indexed sender,
346         uint amount0In,
347         uint amount1In,
348         uint amount0Out,
349         uint amount1Out,
350         address indexed to
351     );
352     event Sync(uint112 reserve0, uint112 reserve1);
353 
354     function MINIMUM_LIQUIDITY() external pure returns (uint);
355     function factory() external view returns (address);
356     function token0() external view returns (address);
357     function token1() external view returns (address);
358     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
359     function price0CumulativeLast() external view returns (uint);
360     function price1CumulativeLast() external view returns (uint);
361     function kLast() external view returns (uint);
362 
363     function mint(address to) external returns (uint liquidity);
364     function burn(address to) external returns (uint amount0, uint amount1);
365     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
366     function skim(address to) external;
367     function sync() external;
368 
369     function initialize(address, address) external;
370 }
371 
372 interface IUniswapV2Factory {
373     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
374 
375     function feeTo() external view returns (address);
376     function feeToSetter() external view returns (address);
377 
378     function getPair(address tokenA, address tokenB) external view returns (address pair);
379     function allPairs(uint) external view returns (address pair);
380     function allPairsLength() external view returns (uint);
381 
382     function createPair(address tokenA, address tokenB) external returns (address pair);
383 
384     function setFeeTo(address) external;
385     function setFeeToSetter(address) external;
386 }
387 
388 interface IUniswapV2Router01 {
389     function factory() external pure returns (address);
390     function WETH() external pure returns (address);
391 
392     function addLiquidity(
393         address tokenA,
394         address tokenB,
395         uint amountADesired,
396         uint amountBDesired,
397         uint amountAMin,
398         uint amountBMin,
399         address to,
400         uint deadline
401     ) external returns (uint amountA, uint amountB, uint liquidity);
402     function addLiquidityETH(
403         address token,
404         uint amountTokenDesired,
405         uint amountTokenMin,
406         uint amountETHMin,
407         address to,
408         uint deadline
409     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
410     function removeLiquidity(
411         address tokenA,
412         address tokenB,
413         uint liquidity,
414         uint amountAMin,
415         uint amountBMin,
416         address to,
417         uint deadline
418     ) external returns (uint amountA, uint amountB);
419     function removeLiquidityETH(
420         address token,
421         uint liquidity,
422         uint amountTokenMin,
423         uint amountETHMin,
424         address to,
425         uint deadline
426     ) external returns (uint amountToken, uint amountETH);
427     function removeLiquidityWithPermit(
428         address tokenA,
429         address tokenB,
430         uint liquidity,
431         uint amountAMin,
432         uint amountBMin,
433         address to,
434         uint deadline,
435         bool approveMax, uint8 v, bytes32 r, bytes32 s
436     ) external returns (uint amountA, uint amountB);
437     function removeLiquidityETHWithPermit(
438         address token,
439         uint liquidity,
440         uint amountTokenMin,
441         uint amountETHMin,
442         address to,
443         uint deadline,
444         bool approveMax, uint8 v, bytes32 r, bytes32 s
445     ) external returns (uint amountToken, uint amountETH);
446     function swapExactTokensForTokens(
447         uint amountIn,
448         uint amountOutMin,
449         address[] calldata path,
450         address to,
451         uint deadline
452     ) external returns (uint[] memory amounts);
453     function swapTokensForExactTokens(
454         uint amountOut,
455         uint amountInMax,
456         address[] calldata path,
457         address to,
458         uint deadline
459     ) external returns (uint[] memory amounts);
460     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
461         external
462         payable
463         returns (uint[] memory amounts);
464     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
465         external
466         returns (uint[] memory amounts);
467     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
468         external
469         returns (uint[] memory amounts);
470     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
471         external
472         payable
473         returns (uint[] memory amounts);
474 
475     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
476     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
477     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
478     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
479     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
480 }
481 
482 interface IUniswapV2Router02 is IUniswapV2Router01 {
483     function removeLiquidityETHSupportingFeeOnTransferTokens(
484         address token,
485         uint liquidity,
486         uint amountTokenMin,
487         uint amountETHMin,
488         address to,
489         uint deadline
490     ) external returns (uint amountETH);
491     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
492         address token,
493         uint liquidity,
494         uint amountTokenMin,
495         uint amountETHMin,
496         address to,
497         uint deadline,
498         bool approveMax, uint8 v, bytes32 r, bytes32 s
499     ) external returns (uint amountETH);
500 
501     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
502         uint amountIn,
503         uint amountOutMin,
504         address[] calldata path,
505         address to,
506         uint deadline
507     ) external;
508     function swapExactETHForTokensSupportingFeeOnTransferTokens(
509         uint amountOutMin,
510         address[] calldata path,
511         address to,
512         uint deadline
513     ) external payable;
514     function swapExactTokensForETHSupportingFeeOnTransferTokens(
515         uint amountIn,
516         uint amountOutMin,
517         address[] calldata path,
518         address to,
519         uint deadline
520     ) external;
521 }
522 
523 /**
524  * @dev Implementation of the {IERC20} interface.
525  *
526  * This implementation is agnostic to the way tokens are created. This means
527  * that a supply mechanism has to be added in a derived contract using {_mint}.
528  * For a generic mechanism see {ERC20PresetMinterPauser}.
529  *
530  * TIP: For a detailed writeup see our guide
531  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
532  * to implement supply mechanisms].
533  *
534  * We have followed general OpenZeppelin guidelines: functions revert instead
535  * of returning `false` on failure. This behavior is nonetheless conventional
536  * and does not conflict with the expectations of ERC20 applications.
537  *
538  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
539  * This allows applications to reconstruct the allowance for all accounts just
540  * by listening to said events. Other implementations of the EIP may not emit
541  * these events, as it isn't required by the specification.
542  *
543  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
544  * functions have been added to mitigate the well-known issues around setting
545  * allowances. See {IERC20-approve}.
546  */
547 contract ERC20 is Context, IERC20, IERC20Metadata {
548     using SafeMath for uint256;
549 
550     mapping(address => uint256) private _balances;
551 
552     mapping(address => mapping(address => uint256)) private _allowances;
553 
554     uint256 private _totalSupply;
555 
556     string private _name;
557     string private _symbol;
558 
559     /**
560      * @dev Sets the values for {name} and {symbol}.
561      *
562      * The default value of {decimals} is 18. To select a different value for
563      * {decimals} you should overload it.
564      *
565      * All two of these values are immutable: they can only be set once during
566      * construction.
567      */
568     constructor(string memory name_, string memory symbol_) public {
569         _name = name_;
570         _symbol = symbol_;
571     }
572 
573     /**
574      * @dev Returns the name of the token.
575      */
576     function name() public view virtual override returns (string memory) {
577         return _name;
578     }
579 
580     /**
581      * @dev Returns the symbol of the token, usually a shorter version of the
582      * name.
583      */
584     function symbol() public view virtual override returns (string memory) {
585         return _symbol;
586     }
587 
588     /**
589      * @dev Returns the number of decimals used to get its user representation.
590      * For example, if `decimals` equals `2`, a balance of `505` tokens should
591      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
592      *
593      * Tokens usually opt for a value of 18, imitating the relationship between
594      * Ether and Wei. This is the value {ERC20} uses, unless this function is
595      * overridden;
596      *
597      * NOTE: This information is only used for _display_ purposes: it in
598      * no way affects any of the arithmetic of the contract, including
599      * {IERC20-balanceOf} and {IERC20-transfer}.
600      */
601     function decimals() public view virtual override returns (uint8) {
602         return 9;
603     }
604 
605     /**
606      * @dev See {IERC20-totalSupply}.
607      */
608     function totalSupply() public view virtual override returns (uint256) {
609         return _totalSupply;
610     }
611 
612     /**
613      * @dev See {IERC20-balanceOf}.
614      */
615     function balanceOf(address account) public view virtual override returns (uint256) {
616         return _balances[account];
617     }
618 
619     /**
620      * @dev See {IERC20-transfer}.
621      *
622      * Requirements:
623      *
624      * - `recipient` cannot be the zero address.
625      * - the caller must have a balance of at least `amount`.
626      */
627     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
628         _transfer(_msgSender(), recipient, amount);
629         return true;
630     }
631 
632     /**
633      * @dev See {IERC20-allowance}.
634      */
635     function allowance(address owner, address spender) public view virtual override returns (uint256) {
636         return _allowances[owner][spender];
637     }
638 
639     /**
640      * @dev See {IERC20-approve}.
641      *
642      * Requirements:
643      *
644      * - `spender` cannot be the zero address.
645      */
646     function approve(address spender, uint256 amount) public virtual override returns (bool) {
647         _approve(_msgSender(), spender, amount);
648         return true;
649     }
650 
651     /**
652      * @dev See {IERC20-transferFrom}.
653      *
654      * Emits an {Approval} event indicating the updated allowance. This is not
655      * required by the EIP. See the note at the beginning of {ERC20}.
656      *
657      * Requirements:
658      *
659      * - `sender` and `recipient` cannot be the zero address.
660      * - `sender` must have a balance of at least `amount`.
661      * - the caller must have allowance for ``sender``'s tokens of at least
662      * `amount`.
663      */
664     function transferFrom(
665         address sender,
666         address recipient,
667         uint256 amount
668     ) public virtual override returns (bool) {
669         _transfer(sender, recipient, amount);
670         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
671         return true;
672     }
673 
674     /**
675      * @dev Atomically increases the allowance granted to `spender` by the caller.
676      *
677      * This is an alternative to {approve} that can be used as a mitigation for
678      * problems described in {IERC20-approve}.
679      *
680      * Emits an {Approval} event indicating the updated allowance.
681      *
682      * Requirements:
683      *
684      * - `spender` cannot be the zero address.
685      */
686     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
687         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
688         return true;
689     }
690 
691     /**
692      * @dev Atomically decreases the allowance granted to `spender` by the caller.
693      *
694      * This is an alternative to {approve} that can be used as a mitigation for
695      * problems described in {IERC20-approve}.
696      *
697      * Emits an {Approval} event indicating the updated allowance.
698      *
699      * Requirements:
700      *
701      * - `spender` cannot be the zero address.
702      * - `spender` must have allowance for the caller of at least
703      * `subtractedValue`.
704      */
705     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
706         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
707         return true;
708     }
709 
710     /**
711      * @dev Moves tokens `amount` from `sender` to `recipient`.
712      *
713      * This is internal function is equivalent to {transfer}, and can be used to
714      * e.g. implement automatic token fees, slashing mechanisms, etc.
715      *
716      * Emits a {Transfer} event.
717      *
718      * Requirements:
719      *
720      * - `sender` cannot be the zero address.
721      * - `recipient` cannot be the zero address.
722      * - `sender` must have a balance of at least `amount`.
723      */
724     function _transfer(
725         address sender,
726         address recipient,
727         uint256 amount
728     ) internal virtual {
729         require(sender != address(0), "ERC20: transfer from the zero address");
730         require(recipient != address(0), "ERC20: transfer to the zero address");
731 
732         _beforeTokenTransfer(sender, recipient, amount);
733 
734         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
735         _balances[recipient] = _balances[recipient].add(amount);
736         emit Transfer(sender, recipient, amount);
737     }
738 
739     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
740      * the total supply.
741      *
742      * Emits a {Transfer} event with `from` set to the zero address.
743      *
744      * Requirements:
745      *
746      * - `account` cannot be the zero address.
747      */
748     function _mint(address account, uint256 amount) internal virtual {
749         require(account != address(0), "ERC20: mint to the zero address");
750 
751         _beforeTokenTransfer(address(0), account, amount);
752 
753         _totalSupply = _totalSupply.add(amount);
754         _balances[account] = _balances[account].add(amount);
755         emit Transfer(address(0), account, amount);
756     }
757 
758     /**
759      * @dev Destroys `amount` tokens from `account`, reducing the
760      * total supply.
761      *
762      * Emits a {Transfer} event with `to` set to the zero address.
763      *
764      * Requirements:
765      *
766      * - `account` cannot be the zero address.
767      * - `account` must have at least `amount` tokens.
768      */
769     function _burn(address account, uint256 amount) internal virtual {
770         require(account != address(0), "ERC20: burn from the zero address");
771 
772         _beforeTokenTransfer(account, address(0), amount);
773 
774         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
775         _totalSupply = _totalSupply.sub(amount);
776         emit Transfer(account, address(0), amount);
777     }
778 
779     /**
780      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
781      *
782      * This internal function is equivalent to `approve`, and can be used to
783      * e.g. set automatic allowances for certain subsystems, etc.
784      *
785      * Emits an {Approval} event.
786      *
787      * Requirements:
788      *
789      * - `owner` cannot be the zero address.
790      * - `spender` cannot be the zero address.
791      */
792     function _approve(
793         address owner,
794         address spender,
795         uint256 amount
796     ) internal virtual {
797         require(owner != address(0), "ERC20: approve from the zero address");
798         require(spender != address(0), "ERC20: approve to the zero address");
799 
800         _allowances[owner][spender] = amount;
801         emit Approval(owner, spender, amount);
802     }
803 
804     /**
805      * @dev Hook that is called before any transfer of tokens. This includes
806      * minting and burning.
807      *
808      * Calling conditions:
809      *
810      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
811      * will be to transferred to `to`.
812      * - when `from` is zero, `amount` tokens will be minted for `to`.
813      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
814      * - `from` and `to` are never both zero.
815      *
816      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
817      */
818     function _beforeTokenTransfer(
819         address from,
820         address to,
821         uint256 amount
822     ) internal virtual {}
823 }
824 
825 contract MCAP is ERC20, Ownable {
826     using SafeMath for uint256;
827 
828     address public constant DEAD_ADDRESS = address(0xdead);
829     IUniswapV2Router02 public constant uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
830 
831     uint256 public buyLiquidityFee = 3;
832     uint256 public sellLiquidityFee = 3;
833     uint256 public buyTxFee = 9;
834     uint256 public sellTxFee = 9;
835     uint256 public tokensForLiquidity;
836     uint256 public tokensForTax;
837 
838     uint256 public _tTotal = 10**9 * 10**9;                         // 1 billion
839     uint256 public swapAtAmount = _tTotal.mul(10).div(10000);       // 0.10% of total supply
840     uint256 public maxTxLimit = _tTotal.mul(75).div(10000);         // 0.75% of total supply
841     uint256 public maxWalletLimit = _tTotal.mul(150).div(10000);    // 1.50% of total supply
842 
843     address public dev;
844     address public uniswapV2Pair;
845 
846     uint256 private launchBlock;
847     bool private swapping;
848     bool public isLaunched;
849 
850     // exclude from fees
851     mapping (address => bool) public isExcludedFromFees;
852 
853     // exclude from max transaction amount
854     mapping (address => bool) public isExcludedFromTxLimit;
855 
856     // exclude from max wallet limit
857     mapping (address => bool) public isExcludedFromWalletLimit;
858 
859     // if the account is blacklisted from transacting
860     mapping (address => bool) public isBlacklisted;
861 
862 
863     constructor(address _dev) public ERC20("Meta Capital", "MCAP") {
864 
865         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
866         _approve(address(this), address(uniswapV2Router), type(uint256).max);
867 
868 
869         // exclude from fees, wallet limit and transaction limit
870         excludeFromAllLimits(owner(), true);
871         excludeFromAllLimits(address(this), true);
872         excludeFromWalletLimit(uniswapV2Pair, true);
873 
874         dev = _dev;
875 
876         /*
877             _mint is an internal function in ERC20.sol that is only called here,
878             and CANNOT be called ever again
879         */
880         _mint(owner(), _tTotal);
881     }
882 
883     function excludeFromFees(address account, bool value) public onlyOwner() {
884         require(isExcludedFromFees[account] != value, "Fees: Already set to this value");
885         isExcludedFromFees[account] = value;
886     }
887 
888     function excludeFromTxLimit(address account, bool value) public onlyOwner() {
889         require(isExcludedFromTxLimit[account] != value, "TxLimit: Already set to this value");
890         isExcludedFromTxLimit[account] = value;
891     }
892 
893     function excludeFromWalletLimit(address account, bool value) public onlyOwner() {
894         require(isExcludedFromWalletLimit[account] != value, "WalletLimit: Already set to this value");
895         isExcludedFromWalletLimit[account] = value;
896     }
897 
898     function excludeFromAllLimits(address account, bool value) public onlyOwner() {
899         excludeFromFees(account, value);
900         excludeFromTxLimit(account, value);
901         excludeFromWalletLimit(account, value);
902     }
903 
904     function setBuyFee(uint256 liquidityFee, uint256 txFee) external onlyOwner() {
905         buyLiquidityFee = liquidityFee;
906         buyTxFee = txFee;
907     }
908 
909     function setSellFee(uint256 liquidityFee, uint256 txFee) external onlyOwner() {
910         sellLiquidityFee = liquidityFee;
911         sellTxFee = txFee;
912     }
913 
914     function setMaxTxLimit(uint256 newLimit) external onlyOwner() {
915         maxTxLimit = newLimit * (10**9);
916     }
917 
918     function setMaxWalletLimit(uint256 newLimit) external onlyOwner() {
919         maxWalletLimit = newLimit * (10**9);
920     }
921 
922     function setSwapAtAmount(uint256 amountToSwap) external onlyOwner() {
923         swapAtAmount = amountToSwap * (10**9);
924     }
925 
926     function updateDevWallet(address newWallet) external onlyOwner() {
927         dev = newWallet;
928     }
929 
930     function addBlacklist(address account) external onlyOwner() {
931         require(!isBlacklisted[account], "Blacklist: Already blacklisted");
932         require(account != uniswapV2Pair, "Cannot blacklist pair");
933         _setBlacklist(account, true);
934     }
935 
936     function removeBlacklist(address account) external onlyOwner() {
937         require(isBlacklisted[account], "Blacklist: Not blacklisted");
938         _setBlacklist(account, false);
939     }
940 
941     function launchNow() external onlyOwner() {
942         require(!isLaunched, "Contract is already launched");
943         isLaunched = true;
944         launchBlock = block.number;
945     }
946 
947     function _transfer(address from, address to, uint256 amount) internal override {
948         require(from != address(0), "transfer from the zero address");
949         require(to != address(0), "transfer to the zero address");
950         require(amount <= maxTxLimit || isExcludedFromTxLimit[from] || isExcludedFromTxLimit[to], "Tx Amount too large");
951         require(balanceOf(to).add(amount) <= maxWalletLimit || isExcludedFromWalletLimit[to], "Transfer will exceed wallet limit");
952         require(isLaunched || isExcludedFromFees[from] || isExcludedFromFees[to], "Waiting to go live");
953         require(!isBlacklisted[from], "Sender is blacklisted");
954 
955         if(amount == 0) {
956             super._transfer(from, to, 0);
957             return;
958         }
959 
960         uint256 totalTokensForFee = tokensForLiquidity + tokensForTax;
961         bool canSwap = totalTokensForFee >= swapAtAmount;
962 
963         if(
964             from != uniswapV2Pair &&
965             canSwap &&
966             !swapping
967         ) {
968             swapping = true;
969             swapBack(totalTokensForFee);
970             swapping = false;
971         } else if(
972             from == uniswapV2Pair &&
973             to != uniswapV2Pair &&
974             block.number < launchBlock + 4 &&
975             !isExcludedFromFees[to]
976         ) {
977             _setBlacklist(to, true);
978         }
979 
980         bool takeFee = !swapping;
981 
982         if(isExcludedFromFees[from] || isExcludedFromFees[to]) {
983             takeFee = false;
984         }
985 
986         if(takeFee) {
987             uint256 fees;
988             // on sell
989             if (to == uniswapV2Pair) {
990                 uint256 sellTotalFees = sellLiquidityFee.add(sellTxFee);
991                 fees = amount.mul(sellTotalFees).div(100);
992                 tokensForLiquidity = tokensForLiquidity.add(fees.mul(sellLiquidityFee).div(sellTotalFees));
993                 tokensForTax = tokensForTax.add(fees.mul(sellTxFee).div(sellTotalFees));
994             }
995             // on buy & wallet transfers
996             else {
997                 uint256 buyTotalFees = buyLiquidityFee.add(buyTxFee);
998                 fees = amount.mul(buyTotalFees).div(100);
999                 tokensForLiquidity = tokensForLiquidity.add(fees.mul(buyLiquidityFee).div(buyTotalFees));
1000                 tokensForTax = tokensForTax.add(fees.mul(buyTxFee).div(buyTotalFees));
1001             }
1002 
1003             if(fees > 0){
1004                 super._transfer(from, address(this), fees);
1005                 amount = amount.sub(fees);
1006             }
1007         }
1008 
1009         super._transfer(from, to, amount);
1010     }
1011 
1012     function swapBack(uint256 totalTokensForFee) private {
1013         uint256 toSwap = swapAtAmount;
1014 
1015         // Halve the amount of liquidity tokens
1016         uint256 liquidityTokens = toSwap.mul(tokensForLiquidity).div(totalTokensForFee).div(2);
1017         uint256 taxTokens = toSwap.sub(liquidityTokens).sub(liquidityTokens);
1018         uint256 amountToSwapForETH = toSwap.sub(liquidityTokens);
1019 
1020         _swapTokensForETH(amountToSwapForETH);
1021 
1022         uint256 ethBalance = address(this).balance;
1023         uint256 ethForTax = ethBalance.mul(taxTokens).div(amountToSwapForETH);
1024         uint256 ethForLiquidity = ethBalance.sub(ethForTax);
1025 
1026         tokensForLiquidity = tokensForLiquidity.sub(liquidityTokens.mul(2));
1027         tokensForTax = tokensForTax.sub(toSwap.sub(liquidityTokens.mul(2)));
1028 
1029         payable(address(dev)).transfer(ethForTax);
1030         _addLiquidity(liquidityTokens, ethForLiquidity);
1031     }
1032 
1033     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1034 
1035         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1036             address(this),
1037             tokenAmount,
1038             0,
1039             0,
1040             DEAD_ADDRESS,
1041             block.timestamp
1042         );
1043     }
1044 
1045     function _swapTokensForETH(uint256 tokenAmount) private {
1046 
1047         address[] memory path = new address[](2);
1048         path[0] = address(this);
1049         path[1] = uniswapV2Router.WETH();
1050 
1051         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1052             tokenAmount,
1053             0,
1054             path,
1055             address(this),
1056             block.timestamp
1057         );
1058     }
1059 
1060     function _setBlacklist(address account, bool value) internal {
1061         isBlacklisted[account] = value;
1062     }
1063 
1064     receive() external payable {}
1065 }