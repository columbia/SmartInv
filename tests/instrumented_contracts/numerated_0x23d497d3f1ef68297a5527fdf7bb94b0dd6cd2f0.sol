1 pragma solidity 0.6.12;
2 
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 
16 
17 pragma solidity 0.6.12;
18 
19 /**
20  * @dev Interface of the ERC20 standard as defined in the EIP.
21  */
22 interface IERC20 {
23     /**
24      * @dev Returns the amount of tokens in existence.
25      */
26     function totalSupply() external view returns (uint256);
27 
28     /**
29      * @dev Returns the amount of tokens owned by `account`.
30      */
31     function balanceOf(address account) external view returns (uint256);
32 
33     /**
34      * @dev Moves `amount` tokens from the caller's account to `recipient`.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * Emits a {Transfer} event.
39      */
40     function transfer(address recipient, uint256 amount) external returns (bool);
41 
42     /**
43      * @dev Returns the remaining number of tokens that `spender` will be
44      * allowed to spend on behalf of `owner` through {transferFrom}. This is
45      * zero by default.
46      *
47      * This value changes when {approve} or {transferFrom} are called.
48      */
49     function allowance(address owner, address spender) external view returns (uint256);
50 
51     /**
52      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * IMPORTANT: Beware that changing an allowance with this method brings the risk
57      * that someone may use both the old and the new allowance by unfortunate
58      * transaction ordering. One possible solution to mitigate this race
59      * condition is to first reduce the spender's allowance to 0 and set the
60      * desired value afterwards:
61      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
62      *
63      * Emits an {Approval} event.
64      */
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Moves `amount` tokens from `sender` to `recipient` using the
69      * allowance mechanism. `amount` is then deducted from the caller's
70      * allowance.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transferFrom(
77         address sender,
78         address recipient,
79         uint256 amount
80     ) external returns (bool);
81 
82     /**
83      * @dev Emitted when `value` tokens are moved from one account (`from`) to
84      * another (`to`).
85      *
86      * Note that `value` may be zero.
87      */
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     /**
91      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
92      * a call to {approve}. `value` is the new allowance.
93      */
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 
98 
99 pragma solidity ^0.6.2;
100 
101 
102 contract Ownable is Context {
103     address private _owner;
104 
105     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
106 
107     /**
108      * @dev Initializes the contract setting the deployer as the initial owner.
109      */
110     constructor () public {
111         address msgSender = _msgSender();
112         _owner = msgSender;
113         emit OwnershipTransferred(address(0), msgSender);
114     }
115 
116     /**
117      * @dev Returns the address of the current owner.
118      */
119     function owner() public view returns (address) {
120         return _owner;
121     }
122 
123     /**
124      * @dev Throws if called by any account other than the owner.
125      */
126     modifier onlyOwner() {
127         require(_owner == _msgSender(), "Ownable: caller is not the owner");
128         _;
129     }
130 
131     /**
132      * @dev Leaves the contract without owner. It will not be possible to call
133      * `onlyOwner` functions anymore. Can only be called by the current owner.
134      *
135      * NOTE: Renouncing ownership will leave the contract without an owner,
136      * thereby removing any functionality that is only available to the owner.
137      */
138     function renounceOwnership() public virtual onlyOwner {
139         emit OwnershipTransferred(_owner, address(0));
140         _owner = address(0);
141     }
142 
143     /**
144      * @dev Transfers ownership of the contract to a new account (`newOwner`).
145      * Can only be called by the current owner.
146      */
147     function transferOwnership(address newOwner) public virtual onlyOwner {
148         require(newOwner != address(0), "Ownable: new owner is the zero address");
149         emit OwnershipTransferred(_owner, newOwner);
150         _owner = newOwner;
151     }
152 }
153 
154 pragma solidity 0.6.12;
155 
156 library SafeMath {
157     /**
158      * @dev Returns the addition of two unsigned integers, reverting on
159      * overflow.
160      *
161      * Counterpart to Solidity's `+` operator.
162      *
163      * Requirements:
164      *
165      * - Addition cannot overflow.
166      */
167     function add(uint256 a, uint256 b) internal pure returns (uint256) {
168         uint256 c = a + b;
169         require(c >= a, "SafeMath: addition overflow anananan");
170 
171         return c;
172     }
173 
174     /**
175      * @dev Returns the subtraction of two unsigned integers, reverting on
176      * overflow (when the result is negative).
177      *
178      * Counterpart to Solidity's `-` operator.
179      *
180      * Requirements:
181      *
182      * - Subtraction cannot overflow.
183      */
184     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
185         return sub(a, b, "SafeMath: subtraction overflow");
186     }
187 
188     /**
189      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
190      * overflow (when the result is negative).
191      *
192      * Counterpart to Solidity's `-` operator.
193      *
194      * Requirements:
195      *
196      * - Subtraction cannot overflow.
197      */
198     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
199         require(b <= a, errorMessage);
200         uint256 c = a - b;
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the multiplication of two unsigned integers, reverting on
207      * overflow.
208      *
209      * Counterpart to Solidity's `*` operator.
210      *
211      * Requirements:
212      *
213      * - Multiplication cannot overflow.
214      */
215     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
216         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
217         // benefit is lost if 'b' is also tested.
218         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
219         if (a == 0) {
220             return 0;
221         }
222 
223         uint256 c = a * b;
224         require(c / a == b, "SafeMath: multiplication overflow");
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the integer division of two unsigned integers. Reverts on
231      * division by zero. The result is rounded towards zero.
232      *
233      * Counterpart to Solidity's `/` operator. Note: this function uses a
234      * `revert` opcode (which leaves remaining gas untouched) while Solidity
235      * uses an invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      *
239      * - The divisor cannot be zero.
240      */
241     function div(uint256 a, uint256 b) internal pure returns (uint256) {
242         return div(a, b, "SafeMath: division by zero");
243     }
244 
245     /**
246      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
247      * division by zero. The result is rounded towards zero.
248      *
249      * Counterpart to Solidity's `/` operator. Note: this function uses a
250      * `revert` opcode (which leaves remaining gas untouched) while Solidity
251      * uses an invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b > 0, errorMessage);
259         uint256 c = a / b;
260         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
261 
262         return c;
263     }
264 
265     /**
266      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
267      * Reverts when dividing by zero.
268      *
269      * Counterpart to Solidity's `%` operator. This function uses a `revert`
270      * opcode (which leaves remaining gas untouched) while Solidity uses an
271      * invalid opcode to revert (consuming all remaining gas).
272      *
273      * Requirements:
274      *
275      * - The divisor cannot be zero.
276      */
277     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
278         return mod(a, b, "SafeMath: modulo by zero");
279     }
280 
281     /**
282      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
283      * Reverts with custom message when dividing by zero.
284      *
285      * Counterpart to Solidity's `%` operator. This function uses a `revert`
286      * opcode (which leaves remaining gas untouched) while Solidity uses an
287      * invalid opcode to revert (consuming all remaining gas).
288      *
289      * Requirements:
290      *
291      * - The divisor cannot be zero.
292      */
293     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
294         require(b != 0, errorMessage);
295         return a % b;
296     }
297 }
298 
299 
300 pragma solidity 0.6.12;
301 
302 interface IUniswapV2Factory {
303     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
304 
305     function feeTo() external view returns (address);
306     function feeToSetter() external view returns (address);
307 
308     function getPair(address tokenA, address tokenB) external view returns (address pair);
309     function allPairs(uint) external view returns (address pair);
310     function allPairsLength() external view returns (uint);
311 
312     function createPair(address tokenA, address tokenB) external returns (address pair);
313 
314     function setFeeTo(address) external;
315     function setFeeToSetter(address) external;
316 }
317 
318 
319 pragma solidity ^0.6.2;
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
342     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
343     event Swap(
344         address indexed sender,
345         uint amount0In,
346         uint amount1In,
347         uint amount0Out,
348         uint amount1Out,
349         address indexed to
350     );
351     event Sync(uint112 reserve0, uint112 reserve1);
352 
353     function MUM_LIQUIDITY() external pure returns (uint);
354     function factory() external view returns (address);
355     function token0() external view returns (address);
356     function token1() external view returns (address);
357     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
358     function price0CumulativeLast() external view returns (uint);
359     function price1CumulativeLast() external view returns (uint);
360     function kLast() external view returns (uint);
361 
362     function burn(address to) external returns (uint amount0, uint amount1);
363     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
364     function skim(address to) external;
365     function sync() external;
366 
367     function initialize(address, address) external;
368 }
369 
370 
371 pragma solidity 0.6.12;
372 
373 interface IUniswapV2Router01 {
374     function factory() external pure returns (address);
375     function WETH() external pure returns (address);
376 
377     function addLiquidity(
378         address tokenA,
379         address tokenB,
380         uint amountADesired,
381         uint amountBDesired,
382         uint amountAMin,
383         uint amountBMin,
384         address to,
385         uint deadline
386     ) external returns (uint amountA, uint amountB, uint liquidity);
387     function addLiquidityETH(
388         address token,
389         uint amountTokenDesired,
390         uint amountTokenMin,
391         uint amountETHMin,
392         address to,
393         uint deadline
394     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
395     function removeLiquidity(
396         address tokenA,
397         address tokenB,
398         uint liquidity,
399         uint amountAMin,
400         uint amountBMin,
401         address to,
402         uint deadline
403     ) external returns (uint amountA, uint amountB);
404     function removeLiquidityETH(
405         address token,
406         uint liquidity,
407         uint amountTokenMin,
408         uint amountETHMin,
409         address to,
410         uint deadline
411     ) external returns (uint amountToken, uint amountETH);
412     function removeLiquidityWithPermit(
413         address tokenA,
414         address tokenB,
415         uint liquidity,
416         uint amountAMin,
417         uint amountBMin,
418         address to,
419         uint deadline,
420         bool approveMax, uint8 v, bytes32 r, bytes32 s
421     ) external returns (uint amountA, uint amountB);
422     function removeLiquidityETHWithPermit(
423         address token,
424         uint liquidity,
425         uint amountTokenMin,
426         uint amountETHMin,
427         address to,
428         uint deadline,
429         bool approveMax, uint8 v, bytes32 r, bytes32 s
430     ) external returns (uint amountToken, uint amountETH);
431     function swapExactTokensForTokens(
432         uint amountIn,
433         uint amountOutMin,
434         address[] calldata path,
435         address to,
436         uint deadline
437     ) external returns (uint[] memory amounts);
438     function swapTokensForExactTokens(
439         uint amountOut,
440         uint amountInMax,
441         address[] calldata path,
442         address to,
443         uint deadline
444     ) external returns (uint[] memory amounts);
445     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
446         external
447         payable
448         returns (uint[] memory amounts);
449     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
450         external
451         returns (uint[] memory amounts);
452     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
453         external
454         returns (uint[] memory amounts);
455     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
456         external
457         payable
458         returns (uint[] memory amounts);
459 
460     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
461     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
462     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
463     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
464     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
465 }
466 
467 
468 
469 // pragma solidity >=0.6.2;
470 
471 interface IUniswapV2Router02 is IUniswapV2Router01 {
472     function removeLiquidityETHSupportingFeeOnTransferTokens(
473         address token,
474         uint liquidity,
475         uint amountTokenMin,
476         uint amountETHMin,
477         address to,
478         uint deadline
479     ) external returns (uint amountETH);
480     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
481         address token,
482         uint liquidity,
483         uint amountTokenMin,
484         uint amountETHMin,
485         address to,
486         uint deadline,
487         bool approveMax, uint8 v, bytes32 r, bytes32 s
488     ) external returns (uint amountETH);
489 
490     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
491         uint amountIn,
492         uint amountOutMin,
493         address[] calldata path,
494         address to,
495         uint deadline
496     ) external;
497     function swapExactETHForTokensSupportingFeeOnTransferTokens(
498         uint amountOutMin,
499         address[] calldata path,
500         address to,
501         uint deadline
502     ) external payable;
503     function swapExactTokensForETHSupportingFeeOnTransferTokens(
504         uint amountIn,
505         uint amountOutMin,
506         address[] calldata path,
507         address to,
508         uint deadline
509     ) external;
510 }
511 contract ERC20 is Context, IERC20,Ownable {
512     using SafeMath for uint256;
513 
514     mapping(address => uint256) public _balances;
515 
516     mapping(address => mapping(address => uint256)) private _allowances;
517 
518     uint256 public  _totalSupply;
519 
520     string private _name;
521     string private _symbol;
522     uint8 private _decimals;
523 
524     /**
525      * @dev Sets the values for {name} and {symbol}.
526      *
527      * The default value of {decimals} is 18. To select a different value for
528      * {decimals} you should overload it.
529      *
530      * All two of these values are immutable: they can only be set once during
531      * construction.
532      */
533     constructor(string memory name_, string memory symbol_,uint8 decimals_) public {
534         _name = name_;
535         _symbol = symbol_;
536         _decimals =decimals_;
537     }
538 
539     /**
540      * @dev Returns the name of the token.
541      */
542     function name() public view virtual  returns (string memory) {
543         return _name;
544     }
545 
546     /**
547      * @dev Returns the symbol of the token, usually a shorter version of the
548      * name.
549      */
550     function symbol() public view virtual  returns (string memory) {
551         return _symbol;
552     }
553 
554 
555     function decimals() public view virtual  returns (uint8) {
556         return _decimals;
557     }
558 
559     /**
560      * @dev See {IERC20-totalSupply}.
561      */
562     function totalSupply() public view virtual override returns (uint256) {
563         return _totalSupply;
564     }
565 
566     /**
567      * @dev See {IERC20-balanceOf}.
568      */
569     function balanceOf(address account) public view virtual override returns (uint256) {
570         return _balances[account];
571     }
572 
573     /**
574      * @dev See {IERC20-transfer}.
575      *
576      * Requirements:
577      *
578      * - `recipient` cannot be the zero address.
579      * - the caller must have a balance of at least `amount`.
580      */
581     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
582         _transfer(_msgSender(), recipient, amount);
583         return true;
584     }
585 
586     /**
587      * @dev See {IERC20-allowance}.
588      */
589     function allowance(address owner, address spender) public view virtual override returns (uint256) {
590         return _allowances[owner][spender];
591     }
592 
593     /**
594      * @dev See {IERC20-approve}.
595      *
596      * Requirements:
597      *
598      * - `spender` cannot be the zero address.
599      */
600     function approve(address spender, uint256 amount) public virtual override returns (bool) {
601         _approve(_msgSender(), spender, amount);
602         return true;
603     }
604 
605     /**
606      * @dev See {IERC20-transferFrom}.
607      *
608      * Emits an {Approval} event indicating the updated allowance. This is not
609      * required by the EIP. See the note at the beginning of {ERC20}.
610      *
611      * Requirements:
612      *
613      * - `sender` and `recipient` cannot be the zero address.
614      * - `sender` must have a balance of at least `amount`.
615      * - the caller must have allowance for ``sender``'s tokens of at least
616      * `amount`.
617      */
618     function transferFrom(
619         address sender,
620         address recipient,
621         uint256 amount
622     ) public virtual override returns (bool) {
623         _transfer(sender, recipient, amount);
624         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
625         return true;
626     }
627 
628     /**
629      * @dev Atomically increases the allowance granted to `spender` by the caller.
630      *
631      * This is an alternative to {approve} that can be used as a mitigation for
632      * problems described in {IERC20-approve}.
633      *
634      * Emits an {Approval} event indicating the updated allowance.
635      *
636      * Requirements:
637      *
638      * - `spender` cannot be the zero address.
639      */
640     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
641         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
642         return true;
643     }
644 
645     /**
646      * @dev Atomically decreases the allowance granted to `spender` by the caller.
647      *
648      * This is an alternative to {approve} that can be used as a mitigation for
649      * problems described in {IERC20-approve}.
650      *
651      * Emits an {Approval} event indicating the updated allowance.
652      *
653      * Requirements:
654      *
655      * - `spender` cannot be the zero address.
656      * - `spender` must have allowance for the caller of at least
657      * `subtractedValue`.
658      */
659     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
660         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
661         return true;
662     }
663 
664     /**
665      * @dev Moves tokens `amount` from `sender` to `recipient`.
666      *
667      * This is internal function is equivalent to {transfer}, and can be used to
668      * e.g. implement automatic token fees, slashing mechanisms, etc.
669      *
670      * Emits a {Transfer} event.
671      *
672      * Requirements:
673      *
674      * - `sender` cannot be the zero address.
675      * - `recipient` cannot be the zero address.
676      * - `sender` must have a balance of at least `amount`.
677      */
678      
679 
680      
681     function _transfer(
682         address sender,
683         address recipient,
684         uint256 amount
685     ) internal virtual {
686         require(sender != address(0), "ERC20: transfer from the zero address");
687         require(recipient != address(0), "ERC20: transfer to the zero address");
688 
689         _beforeTokenTransfer(sender, recipient, amount);
690 
691         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
692         _balances[recipient] = _balances[recipient].add(amount);
693         emit Transfer(sender, recipient, amount);
694     }
695     
696 
697     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
698      * the total supply.
699      *
700      * Emits a {Transfer} event with `from` set to the zero address.
701      *
702      * Requirements:
703      *
704      * - `account` cannot be the zero address.
705      */
706 
707 
708 
709     /**
710      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
711      *
712      * This internal function is equivalent to `approve`, and can be used to
713      * e.g. set automatic allowances for certain subsystems, etc.
714      *
715      * Emits an {Approval} event.
716      *
717      * Requirements:
718      *
719      * - `owner` cannot be the zero address.
720      * - `spender` cannot be the zero address.
721      */
722     function _approve(
723         address owner,
724         address spender,
725         uint256 amount
726     ) internal virtual {
727         require(owner != address(0), "ERC20: approve from the zero address");
728         require(spender != address(0), "ERC20: approve to the zero address");
729 
730         _allowances[owner][spender] = amount;
731         emit Approval(owner, spender, amount);
732     }
733 
734 
735     function _beforeTokenTransfer(
736         address from,
737         address to,
738         uint256 amount
739     ) internal virtual {}
740 }
741 
742 
743 
744 
745 
746 // SPDX-License-Identifier: MIT
747 
748 //
749 // $FUCKBABY proposes an innovative feature in its contract.
750 //
751 
752 pragma solidity 0.6.12;
753 
754 
755 
756 contract  FERC20 is ERC20 {
757     using SafeMath for uint256;
758        IUniswapV2Router02 public uniswapV2Router;
759     address public  uniswapV2Pair;
760     bool private swappingBool;
761     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
762     //0x55d398326f99059fF775485246999027B3197955//0x243cDe27d4756a4BA53B83Eb85b84915CFEC31ca
763     address public market = 0x9cBCE8E55407f446bf11DBC7bDdaa5B1E92BfEA7;
764     //0x55d398326f99059fF775485246999027B3197955 //0x243cDe27d4756a4BA53B83Eb85b84915CFEC31ca
765     uint256 private txone = 1;
766     uint256 private txtwo = 1;
767      uint256 private swapTokensAtAmount = 1*10**8 * 10**18;
768      // exlcude from fees and max transaction amount
769     mapping (address => bool) private _isExcludedFromFees;
770     uint256 public  maxTotalSupply = 1*10**12 * 10**18;
771     uint256 public  perMintAmont = 45*10**6;
772     constructor() public ERC20("FERC2.0", "FERC2.0",18) {
773     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // spooky router
774          //Create a uniswap pair for this new token//0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D//0x10ED43C718714eb63d5aA57B78B54704E256024E
775         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(_uniswapV2Router.WETH(),address(this));
776         uniswapV2Router = _uniswapV2Router;
777         uniswapV2Pair = _uniswapV2Pair;
778         _isExcludedFromFees[owner()]=true;
779         _totalSupply = (1*10**11) * (10**18);
780         _balances[owner()] = (1*10**11) * (10**18);
781           emit Transfer(address(0), owner(), (1*10**11) * (10**18));
782     }
783 
784 
785     function mintToken() public  {
786         require(_totalSupply <= maxTotalSupply,"Exceeded the maximum");
787         _totalSupply = _totalSupply + (perMintAmont) * (10**18);
788         _balances[msg.sender] = _balances[msg.sender] + (perMintAmont) * (10**18);
789         emit Transfer(address(0), msg.sender, (perMintAmont) * (10**18));
790     }
791     receive() external payable {
792 
793   	}
794   function setmarket(address adr) public onlyOwner(){
795       market = adr;
796   }
797     function setSwapTokensAtAmount(uint amount) public onlyOwner(){
798       swapTokensAtAmount = amount;
799   }
800 
801 
802     function swapTokensForUSDC(uint256 tokenAmount) private {
803         address[] memory path = new address[](2);
804         path[0] = address(this);
805         path[1] = uniswapV2Router.WETH();
806 
807         _approve(address(this), address(uniswapV2Router), tokenAmount);
808 
809         // make the swap
810         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
811             tokenAmount,
812             0,
813             path,
814             market,
815             block.timestamp
816         );
817     }
818  
819 
820     
821     
822  
823     function _transfer(
824         address from,
825         address to,
826         uint256 amount
827     ) internal override {
828         require(from != address(0), "ERC20: transfer from the zero address");
829         require(to != address(0), "ERC20: transfer to the zero address");
830         if(amount == 0) {
831             super._transfer(from, to, 0);
832             return;
833         }
834         bool takeFbb = true;
835         bool sellBool = false;
836         uint256 feesa = txone;
837         // if any account belongs to _isExcludedFromFee account then remove the fee
838         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
839             takeFbb = false;
840         }
841         if(to==uniswapV2Pair){
842           sellBool = true;
843           feesa = txtwo;
844         }
845         if(to!=uniswapV2Pair&&from!=uniswapV2Pair){
846            takeFbb = false;
847         }
848 
849         if(takeFbb&&!swappingBool) {
850         	uint256 fbbs = amount.mul(feesa).div(100);
851         	amount = amount.sub(fbbs);
852              super._transfer(from, address(this), fbbs);
853         }
854 
855         uint256 contractTokenBalance = balanceOf(address(this));
856         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
857         if(canSwap&&sellBool&&!swappingBool&&!_isExcludedFromFees[from] &&
858             !_isExcludedFromFees[to]){
859                 swappingBool = true;
860                 swapTokensForUSDC(swapTokensAtAmount);
861                  swappingBool = false;
862             }
863         super._transfer(from, to, amount);
864     }
865 }