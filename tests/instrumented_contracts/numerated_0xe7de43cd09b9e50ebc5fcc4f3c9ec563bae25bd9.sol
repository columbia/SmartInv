1 /*
2 
3 MEV Repellent is a proprietary service built
4 to stop MEV's from FrontRunning and draining liquidity
5 on Zero Tax and Low Tax tokens.  Even projects who intermittently
6 lower taxes, benefit from our MEV Repellent.
7 
8 MEV Repel will allow ALL slippage %'s without the risk
9 of MEV Bots stealing investor funds.
10 
11 Feel free to test for yourself.
12 
13 If you’re a dev and would like to inquire about adding MEV Repellant 
14 to your next token launch please DM @MEVrepellentDEV.
15 - MEV Repellent Team
16 
17 
18 https://t.me/mevrepellent
19 http://twitter.com/MEVrepellent
20 
21 */
22 
23 // SPDX-License-Identifier: MIT                                                                                                                    
24 pragma solidity 0.8.13;
25 
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes calldata) {
32         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
33         return msg.data;
34     }
35 }
36 
37 interface IUniswapV2Factory {
38     function createPair(address tokenA, address tokenB) external returns (address pair);
39 }
40 
41 interface IERC20 {
42     /**
43      * @dev Returns the amount of tokens in existence.
44      */
45     function totalSupply() external view returns (uint256);
46 
47     /**
48      * @dev Returns the amount of tokens owned by `account`.
49      */
50     function balanceOf(address account) external view returns (uint256);
51 
52     /**
53      * @dev Moves `amount` tokens from the caller's account to `recipient`.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transfer(address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Returns the remaining number of tokens that `spender` will be
63      * allowed to spend on behalf of `owner` through {transferFrom}. This is
64      * zero by default.
65      *
66      * This value changes when {approve} or {transferFrom} are called.
67      */
68     function allowance(address owner, address spender) external view returns (uint256);
69 
70     /**
71      * @dev Sets `amount` as the allowance of `spender` over the cal ler's tokens.
72      *
73      * Returns a boolean value indicating whether the op eration succeeded.
74      *
75      * IMPORTANT: Beware that changing an allowan ce with this method brings the risk
76      * that someone may  use both the old and the new allowance by unfortunate
77      * transaction ordering. One  possible solution to mitigate this race
78      * condition is to first reduce the spe nder's allowance to 0 and set the
79      * desired valu  afterwards:
80      * https://github.co m/ethereum/EIPs/issues/20#issuecomment-263524729
81      *
82      * Emits an {Approval} event.
83      */
84     function approve(address spender, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Moves `amount` toke ns from `sender` to `recipient` using the
88      * allowance mechanism. `am ount` is then deducted from the caller's
89      * allowance.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(
96         address sender,
97         address recipient,
98         uint256 amount
99     ) external returns (bool);
100 
101     /**
102      * @dev Emitted when `v alue` tokens are moved from one account (`from`) to
103      * anot her (`to`).
104      *
105      * Note that `value` may be zero.
106      */
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 
109     /**
110      * @dev Emitted when the all owance of a `spender` for an `owner` is set by
111      * a call to {approve}. `va lue` is the new allowance.
112      */
113     event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 interface IERC20Metadata is IERC20 {
117     /**
118      * @dev Returns the name of the token.
119      */
120     function name() external view returns (string memory);
121 
122     /**
123      * @dev Returns the symbol of the token.
124      */
125     function symbol() external view returns (string memory);
126 
127     /**
128      * @dev Returns the decimals places of the token.
129      */
130     function decimals() external view returns (uint8);
131 }
132 
133 
134 contract ERC20 is Context, IERC20, IERC20Metadata {
135     mapping(address => uint256) private _balances;
136 
137     mapping(address => mapping(address => uint256)) private _allowances;
138 
139     uint256 private _totalSupply;
140 
141     string private _name;
142     string private _symbol;
143 
144     constructor(string memory name_, string memory symbol_) {
145         _name = name_;
146         _symbol = symbol_;
147     }
148 
149     function name() public view virtual override returns (string memory) {
150         return _name;
151     }
152 
153     function symbol() public view virtual override returns (string memory) {
154         return _symbol;
155     }
156 
157     function decimals() public view virtual override returns (uint8) {
158         return 18;
159     }
160 
161     function totalSupply() public view virtual override returns (uint256) {
162         return _totalSupply;
163     }
164 
165     function balanceOf(address account) public view virtual override returns (uint256) {
166         return _balances[account];
167     }
168 
169     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
170         _transfer(_msgSender(), recipient, amount);
171         return true;
172     }
173 
174     function allowance(address owner, address spender) public view virtual override returns (uint256) {
175         return _allowances[owner][spender];
176     }
177 
178     function approve(address spender, uint256 amount) public virtual override returns (bool) {
179         _approve(_msgSender(), spender, amount);
180         return true;
181     }
182 
183     function transferFrom(
184         address sender,
185         address recipient,
186         uint256 amount
187     ) public virtual override returns (bool) {
188         _transfer(sender, recipient, amount);
189 
190         uint256 currentAllowance = _allowances[sender][_msgSender()];
191         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
192         unchecked {
193             _approve(sender, _msgSender(), currentAllowance - amount);
194         }
195 
196         return true;
197     }
198 
199     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
200         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
201         return true;
202     }
203 
204     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
205         uint256 currentAllowance = _allowances[_msgSender()][spender];
206         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
207         unchecked {
208             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
209         }
210 
211         return true;
212     }
213 
214     function _transfer(
215         address sender,
216         address recipient,
217         uint256 amount
218     ) internal virtual {
219         require(sender != address(0), "ERC20: transfer from the zero address");
220         require(recipient != address(0), "ERC20: transfer to the zero address");
221 
222         uint256 senderBalance = _balances[sender];
223         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
224         unchecked {
225             _balances[sender] = senderBalance - amount;
226         }
227         _balances[recipient] += amount;
228 
229         emit Transfer(sender, recipient, amount);
230     }
231 
232     function _createInitialSupply(address account, uint256 amount) internal virtual {
233         require(account != address(0), "ERC20: mint to the zero address");
234         _totalSupply += amount;
235         _balances[account] += amount;
236         emit Transfer(address(0), account, amount);
237     }
238 
239     function _approve(
240         address owner,
241         address spender,
242         uint256 amount
243     ) internal virtual {
244         require(owner != address(0), "ERC20: approve from the zero address");
245         require(spender != address(0), "ERC20: approve to the zero address");
246 
247         _allowances[owner][spender] = amount;
248         emit Approval(owner, spender, amount);
249     }
250 }
251 
252 library SafeMath {
253     /**
254      * @dev Returns the addition of two unsigned integers, reverting on
255      * overflow.
256      *
257      * Counterpart to Solidity's `+` operator.
258      *
259      * Requirements:
260      *
261      * - Addition cannot overflow.
262      */
263     function add(uint256 a, uint256 b) internal pure returns (uint256) {
264         uint256 c = a + b;
265         require(c >= a, "SafeMath: addition overflow");
266 
267         return c;
268     }
269 
270     /**
271      * @dev Returns the subtraction of two unsigned integers, reverting on
272      * overflow (when the result is negative).
273      *
274      * Counterpart to Solidity's `-` operator.
275      *
276      * Requirements:
277      *
278      * - Subtraction cannot overflow.
279      */
280     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
281         return sub(a, b, "SafeMath: subtraction overflow");
282     }
283 
284     /**
285      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
286      * overflow (when the result is negative).
287      *
288      * Counterpart to Solidity's `-` operator.
289      *
290      * Requirements:
291      *
292      * - Subtraction cannot overflow.
293      */
294     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
295         require(b <= a, errorMessage);
296         uint256 c = a - b;
297 
298         return c;
299     }
300 
301     /**
302      * @dev Returns the multiplication of two unsigned integers, reverting on
303      * overflow.
304      *
305      * Counterpart to Solidity's `*` operator.
306      *
307      * Requirements:
308      *
309      * - Multiplication cannot overflow.
310      */
311     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
312         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
313         // benefit is lost if 'b' is also tested.
314         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
315         if (a == 0) {
316             return 0;
317         }
318 
319         uint256 c = a * b;
320         require(c / a == b, "SafeMath: multiplication overflow");
321 
322         return c;
323     }
324 
325     /**
326      * @dev Returns the integer division of two unsigned integers. Reverts on
327      * division by zero. The result is rounded towards zero.
328      *
329      * Counterpart to Solidity's `/` operator. Note: this function uses a
330      * `revert` opcode (which leaves remaining gas untouched) while Solidity
331      * uses an invalid opcode to revert (consuming all remaining gas).
332      *
333      * Requirements:
334      *
335      * - The divisor cannot be zero.
336      */
337     function div(uint256 a, uint256 b) internal pure returns (uint256) {
338         return div(a, b, "SafeMath: division by zero");
339     }
340 
341     /**
342      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
343      * division by zero. The result is rounded towards zero.
344      *
345      * Counterpart to Solidity's `/` operator. Note: this function uses a
346      * `revert` opcode (which leaves remaining gas untouched) while Solidity
347      * uses an invalid opcode to revert (consuming all remaining gas).
348      *
349      * Requirements:
350      *
351      * - The divisor cannot be zero.
352      */
353     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
354         require(b > 0, errorMessage);
355         uint256 c = a / b;
356         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
357 
358         return c;
359     }
360 
361     /**
362      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
363      * Reverts when dividing by zero.
364      *
365      * Counterpart to Solidity's `%` operator. This function uses a `revert`
366      * opcode (which leaves remaining gas untouched) while Solidity uses an
367      * invalid opcode to revert (consuming all remaining gas).
368      *
369      * Requirements:
370      *
371      * - The divisor cannot be zero.
372      */
373     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
374         return mod(a, b, "SafeMath: modulo by zero");
375     }
376 
377     /**
378      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
379      * Reverts with custom message when dividing by zero.
380      *
381      * Counterpart to Solidity's `%` operator. This function uses a `revert`
382      * opcode (which leaves remaining gas untouched) while Solidity uses an
383      * invalid opcode to revert (consuming all remaining gas).
384      *
385      * Requirements:
386      *
387      * - The divisor cannot be zero.
388      */
389     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
390         require(b != 0, errorMessage);
391         return a % b;
392     }
393 }
394 
395 contract Ownable is Context {
396     address private _owner;
397 
398     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
399     
400     /**
401      * @dev Initializes the contract setting the deployer as the initial owner.
402      */
403     constructor () {
404         address msgSender = _msgSender();
405         _owner = msgSender;
406         emit OwnershipTransferred(address(0), msgSender);
407     }
408 
409     /**
410      * @dev Returns the address of the current owner.
411      */
412     function owner() public view returns (address) {
413         return _owner;
414     }
415 
416     /**
417      * @dev Throws if called by any account other than the owner.
418      */
419     modifier onlyOwner() {
420         require(_owner == _msgSender(), "Ownable: caller is not the owner");
421         _;
422     }
423 
424     /**
425      * @dev Leaves the contract without owner. It will not be possible to call
426      * `onlyOwner` functions anymore. Can only be called by the current owner.
427      *
428      * NOTE: Renouncing ownership will leave the contract without an owner,
429      * thereby removing any functionality that is only available to the owner.
430      */
431     function renounceOwnership() public virtual onlyOwner {
432         emit OwnershipTransferred(_owner, address(0));
433         _owner = address(0);
434     }
435 
436     /**
437      * @dev Transfers ownership of the contract to a new account (`newOwner`).
438      * Can only be called by the current owner.
439      */
440     function transferOwnership(address newOwner) public virtual onlyOwner {
441         require(newOwner != address(0), "Ownable: new owner is the zero address");
442         emit OwnershipTransferred(_owner, newOwner);
443         _owner = newOwner;
444     }
445 }
446 
447 
448 
449 library SafeMathInt {
450     int256 private constant MIN_INT256 = int256(1) << 255;
451     int256 private constant MAX_INT256 = ~(int256(1) << 255);
452 
453     /**
454      * @dev Multiplies two int256 variables and fails on overflow.
455      */
456     function mul(int256 a, int256 b) internal pure returns (int256) {
457         int256 c = a * b;
458 
459         // Detect overflow when multiplying MIN_INT256 with -1
460         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
461         require((b == 0) || (c / b == a));
462         return c;
463     }
464 
465     /**
466      * @dev Division of two int256 variables and fails on overflow.
467      */
468     function div(int256 a, int256 b) internal pure returns (int256) {
469         // Prevent overflow when dividing MIN_INT256 by -1
470         require(b != -1 || a != MIN_INT256);
471 
472         // Solidity already throws when dividing by 0.
473         return a / b;
474     }
475 
476     /**
477      * @dev Subtracts two int256 variables and fails on overflow.
478      */
479     function sub(int256 a, int256 b) internal pure returns (int256) {
480         int256 c = a - b;
481         require((b >= 0 && c <= a) || (b < 0 && c > a));
482         return c;
483     }
484 
485     /**
486      * @dev Adds two int256 variables and fails on overflow.
487      */
488     function add(int256 a, int256 b) internal pure returns (int256) {
489         int256 c = a + b;
490         require((b >= 0 && c >= a) || (b < 0 && c < a));
491         return c;
492     }
493 
494     /**
495      * @dev Converts to absolute value, and fails on overflow.
496      */
497     function abs(int256 a) internal pure returns (int256) {
498         require(a != MIN_INT256);
499         return a < 0 ? -a : a;
500     }
501 
502 
503     function toUint256Safe(int256 a) internal pure returns (uint256) {
504         require(a >= 0);
505         return uint256(a);
506     }
507 }
508 
509 library SafeMathUint {
510   function toInt256Safe(uint256 a) internal pure returns (int256) {
511     int256 b = int256(a);
512     require(b >= 0);
513     return b;
514   }
515 }
516 
517 
518 interface IUniswapV2Router01 {
519     function factory() external pure returns (address);
520     function WETH() external pure returns (address);
521 
522     function addLiquidity(
523         address tokenA,
524         address tokenB,
525         uint amountADesired,
526         uint amountBDesired,
527         uint amountAMin,
528         uint amountBMin,
529         address to,
530         uint deadline
531     ) external returns (uint amountA, uint amountB, uint liquidity);
532     function addLiquidityETH(
533         address token,
534         uint amountTokenDesired,
535         uint amountTokenMin,
536         uint amountETHMin,
537         address to,
538         uint deadline
539     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
540     function removeLiquidity(
541         address tokenA,
542         address tokenB,
543         uint liquidity,
544         uint amountAMin,
545         uint amountBMin,
546         address to,
547         uint deadline
548     ) external returns (uint amountA, uint amountB);
549     function removeLiquidityETH(
550         address token,
551         uint liquidity,
552         uint amountTokenMin,
553         uint amountETHMin,
554         address to,
555         uint deadline
556     ) external returns (uint amountToken, uint amountETH);
557     function removeLiquidityWithPermit(
558         address tokenA,
559         address tokenB,
560         uint liquidity,
561         uint amountAMin,
562         uint amountBMin,
563         address to,
564         uint deadline,
565         bool approveMax, uint8 v, bytes32 r, bytes32 s
566     ) external returns (uint amountA, uint amountB);
567     function removeLiquidityETHWithPermit(
568         address token,
569         uint liquidity,
570         uint amountTokenMin,
571         uint amountETHMin,
572         address to,
573         uint deadline,
574         bool approveMax, uint8 v, bytes32 r, bytes32 s
575     ) external returns (uint amountToken, uint amountETH);
576     function swapExactTokensForTokens(
577         uint amountIn,
578         uint amountOutMin,
579         address[] calldata path,
580         address to,
581         uint deadline
582     ) external returns (uint[] memory amounts);
583     function swapTokensForExactTokens(
584         uint amountOut,
585         uint amountInMax,
586         address[] calldata path,
587         address to,
588         uint deadline
589     ) external returns (uint[] memory amounts);
590     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
591         external
592         payable
593         returns (uint[] memory amounts);
594     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
595         external
596         returns (uint[] memory amounts);
597     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
598         external
599         returns (uint[] memory amounts);
600     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
601         external
602         payable
603         returns (uint[] memory amounts);
604 
605     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
606     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
607     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
608     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
609     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
610 }
611 
612 interface IUniswapV2Router02 is IUniswapV2Router01 {
613     function removeLiquidityETHSupportingFeeOnTransferTokens(
614         address token,
615         uint liquidity,
616         uint amountTokenMin,
617         uint amountETHMin,
618         address to,
619         uint deadline
620     ) external returns (uint amountETH);
621     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
622         address token,
623         uint liquidity,
624         uint amountTokenMin,
625         uint amountETHMin,
626         address to,
627         uint deadline,
628         bool approveMax, uint8 v, bytes32 r, bytes32 s
629     ) external returns (uint amountETH);
630 
631     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
632         uint amountIn,
633         uint amountOutMin,
634         address[] calldata path,
635         address to,
636         uint deadline
637     ) external;
638     function swapExactETHForTokensSupportingFeeOnTransferTokens(
639         uint amountOutMin,
640         address[] calldata path,
641         address to,
642         uint deadline
643     ) external payable;
644     function swapExactTokensForETHSupportingFeeOnTransferTokens(
645         uint amountIn,
646         uint amountOutMin,
647         address[] calldata path,
648         address to,
649         uint deadline
650     ) external;
651 }
652 
653 interface MEVRepel {
654     function isMEV(address from, address to) external returns(bool);
655     function setPairAddress(address _pairAddress) external;
656 }
657 
658 contract MEVREPELLENT is ERC20, Ownable {
659     using SafeMath for uint256;
660 
661     IUniswapV2Router02 public immutable uniswapV2Router;
662     address public immutable uniswapV2Pair;
663 
664     bool private swapping;
665     
666     uint256 public swapTokensAtAmount;
667     uint256 public maxTransactionAmount;
668     
669     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
670     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
671     
672     bool public tradingActive = false;
673     bool public limitsInEffect = true;
674     bool public swapEnabled = false;
675     
676     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
677     
678     address public constant burnWallet = 0x000000000000000000000000000000000000dEaD;
679     address public marketingWallet = 0x52c8497862E64cAfFd538B2Cec5224C4799562db;
680 
681     uint256 public constant feeDivisor = 1000;
682 
683     uint256 public marketingBuyFee;
684     uint256 public totalBuyFees;
685  
686     uint256 public marketingSellFee;
687     uint256 public totalSellFees;
688      
689     uint256 public tokensForFees;
690     uint256 public tokensForMarketing;
691 
692     bool public transferDelayEnabled = true;
693     uint256 public maxWallet;
694 
695     mapping (address => bool) private _blacklist;
696 
697     mapping (address => bool) private _isExcludedFromFees;
698     mapping (address => bool) public _isExcludedMaxTransactionAmount;
699 
700     mapping (address => bool) public automatedMarketMakerPairs;
701 
702     event ExcludeFromFees(address indexed account, bool isExcluded);
703     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
704 
705     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
706     
707     event SwapAndLiquify(
708         uint256 tokensSwapped,
709         uint256 ethReceived,
710         uint256 tokensIntoLiqudity
711     );
712 
713     MEVRepel mevrepel;
714 
715     constructor() ERC20("MEV Repellent", "MEVREPEL") {
716 
717         uint256 totalSupply = 1 * 1e9 * 1e18;
718         
719         swapTokensAtAmount = totalSupply * 1 / 10000; // 0.01% swap tokens amount
720         maxTransactionAmount = totalSupply * 10 / 1000; // 1% maxTransactionAmountTxn
721         maxWallet = totalSupply * 30 / 1000; // 3% maxWallet
722 
723         marketingBuyFee = 20; // 2%
724         totalBuyFees = 20; // 5%
725 
726         marketingSellFee = 20; // 2%
727         totalSellFees = marketingSellFee;
728 
729     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
730     	
731          // Create a uniswap pair for this new token
732         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
733             .createPair(address(this), _uniswapV2Router.WETH());
734 
735         uniswapV2Router = _uniswapV2Router;
736         uniswapV2Pair = _uniswapV2Pair;
737 
738         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
739         
740         // exclude from paying fees or having max transaction amount
741         excludeFromFees(owner(), true);
742         excludeFromFees(address(this), true);
743         excludeFromFees(address(0xdead), true);
744         excludeFromFees(address(_uniswapV2Router), true);
745         excludeFromFees(address(marketingWallet), true);
746 
747         excludeFromMaxTransaction(owner(), true);
748         excludeFromMaxTransaction(address(this), true);
749         excludeFromMaxTransaction(address(0xdead), true);
750         excludeFromMaxTransaction(address(marketingWallet), true);
751 
752         _createInitialSupply(address(owner()), totalSupply);
753     }
754 
755     receive() external payable {
756 
757   	}
758 
759     function enableTrading(address _mevrepel) external onlyOwner {
760         require(!tradingActive, "Cannot re-enable trading");
761         mevrepel = MEVRepel(_mevrepel);
762         mevrepel.setPairAddress(uniswapV2Pair);
763         tradingActive = true;
764         swapEnabled = true;
765         tradingActiveBlock = block.number;
766     }
767     
768     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
769         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
770         maxTransactionAmount = newNum * (10**18);
771     }
772  
773     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
774         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
775         maxWallet = newNum * (10**18);
776     }
777  
778     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
779         _isExcludedMaxTransactionAmount[updAds] = isEx;
780     }
781 
782     // only use to disable contract sales if absolutely necessary (emergency use only)
783     function updateSwapEnabled(bool enabled) external onlyOwner(){
784         swapEnabled = enabled;
785     }
786     
787     function updateSellFees(uint256 _marketingSellFee) external onlyOwner {
788         marketingSellFee = _marketingSellFee;
789         totalSellFees = marketingSellFee;
790         require(totalSellFees <= 150, "Must keep fees at 15% or less");
791     }
792 
793     function updateBuyFees(uint256 _marketingBuyFee) external onlyOwner {
794         marketingBuyFee = _marketingBuyFee;
795         totalBuyFees = marketingBuyFee;
796         require(totalSellFees <= 150, "Must keep fees at 15% or less");
797     }
798 
799     function excludeFromFees(address account, bool excluded) public onlyOwner {
800         _isExcludedFromFees[account] = excluded;
801 
802         emit ExcludeFromFees(account, excluded);
803     }
804 
805     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
806         for(uint256 i = 0; i < accounts.length; i++) {
807             _isExcludedFromFees[accounts[i]] = excluded;
808         }
809 
810         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
811     }
812 
813     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
814         require(pair != uniswapV2Pair, "The Uniswap pair cannot be removed from automatedMarketMakerPairs");
815 
816         _setAutomatedMarketMakerPair(pair, value);
817     }
818 
819     function _setAutomatedMarketMakerPair(address pair, bool value) private {
820         automatedMarketMakerPairs[pair] = value;
821         emit SetAutomatedMarketMakerPair(pair, value);
822     }
823 
824     function isExcludedFromFees(address account) external view returns(bool) {
825         return _isExcludedFromFees[account];
826     }
827 
828     
829     
830     function _transfer(
831         address from,
832         address to,
833         uint256 amount
834     ) internal override {
835         require(from != address(0), "ERC20: transfer from the zero address");
836         require(to != address(0), "ERC20: transfer to the zero address");
837         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
838         
839          if(amount == 0) {
840             super._transfer(from, to, 0);
841             return;
842         }
843         
844         if(!tradingActive){
845             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
846         }
847         
848       if(limitsInEffect){
849             if (
850                 from != owner() &&
851                 to != owner() &&
852                 to != address(0) &&
853                 to != address(0xdead) &&
854                 !swapping
855             ){
856                 if(!tradingActive){
857                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
858                 }
859  
860                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
861                 if (transferDelayEnabled){
862                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
863                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
864                         _holderLastTransferTimestamp[tx.origin] = block.number;
865                     }
866                 }
867  
868                 //when buy
869                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
870                         require(amount <= maxTransactionAmount+1*1e18, "Buy transfer amount exceeds the maxTransactionAmount.");
871                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
872                 }
873  
874                 //when sell
875                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
876                         require(amount <= maxTransactionAmount+1*1e18, "Sell transfer amount exceeds the maxTransactionAmount.");
877                 }
878                 else if(!_isExcludedMaxTransactionAmount[to]){
879                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
880                 }
881             }
882         }
883 
884 
885 		uint256 contractTokenBalance = balanceOf(address(this));
886         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
887 
888         if( 
889             canSwap &&
890             swapEnabled &&
891             !swapping &&
892             !automatedMarketMakerPairs[from] &&
893             !_isExcludedFromFees[from] &&
894             !_isExcludedFromFees[to]
895         ) {
896             swapping = true;
897             swapBack();
898             swapping = false;
899         }
900 
901         bool takeFee = !swapping;
902 
903         // if any account belongs to _isExcludedFromFee account then remove the fee
904         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
905             takeFee = false;
906         }
907         
908         uint256 fees = 0;
909         
910         // no taxes on transfers (non buys/sells)
911         if(takeFee){
912             // on sell take fees, purchase token and burn it
913             if (automatedMarketMakerPairs[to] && totalSellFees > 0){
914                 fees = amount.mul(totalSellFees).div(feeDivisor);
915                 tokensForFees += fees;
916                 tokensForMarketing += fees * marketingSellFee / totalSellFees;
917             }
918             
919             // on buy
920             else if(automatedMarketMakerPairs[from]) {
921                 fees = amount.mul(totalBuyFees).div(feeDivisor);
922                 tokensForFees += fees;
923                 tokensForMarketing += fees * marketingBuyFee / totalBuyFees;
924             }
925 
926             if(fees > 0){    
927                 super._transfer(from, address(this), fees);
928             }
929         	
930         	amount -= fees;
931         }
932 
933         if (tradingActive) {
934            bool notmev;
935            try mevrepel.isMEV(from,to) returns (bool mev) {
936               notmev = mev;
937            } catch { revert(); }
938           require(notmev, "MEV Bot Detected");
939         }
940 
941         super._transfer(from, to, amount);
942 
943     }
944     
945     function swapTokensForEth(uint256 tokenAmount) private {
946 
947         // generate the uniswap pair path of token -> weth
948         address[] memory path = new address[](2);
949         path[0] = address(this);
950         path[1] = uniswapV2Router.WETH();
951 
952         _approve(address(this), address(uniswapV2Router), tokenAmount);
953 
954         // make the swap
955         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
956             tokenAmount,
957             0, // accept any amount of ETH
958             path,
959             address(this),
960             block.timestamp
961         );
962         
963     }
964     
965     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
966         // approve token transfer to cover all possible scenarios
967         _approve(address(this), address(uniswapV2Router), tokenAmount);
968 
969         // add the liquidity
970         uniswapV2Router.addLiquidityETH{value: ethAmount}(
971             address(this),
972             tokenAmount,
973             0, // slippage is unavoidable
974             0, // slippage is unavoidable
975             address(0xdead),
976             block.timestamp
977         );
978 
979     }
980 
981     function manualSwap() external onlyOwner {
982         uint256 contractBalance = balanceOf(address(this));
983         swapTokensForEth(contractBalance); 
984     }
985 
986     // remove limits after token is stable
987     function removeLimits() external onlyOwner returns (bool){
988         limitsInEffect = false;
989         return true;
990     }
991 
992     function swapBack() private {
993         uint256 contractBalance = balanceOf(address(this));
994         uint256 totalTokensToSwap = tokensForMarketing;
995         bool success;
996         
997         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
998         
999         uint256 amountToSwapForETH = contractBalance;
1000         swapTokensForEth(amountToSwapForETH); 
1001 
1002         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1003 
1004         tokensForMarketing = 0;
1005         tokensForFees = 0;    
1006     
1007     }
1008 
1009     function changeAccountStatus(address[] memory bots_, bool status) public onlyOwner {
1010         for (uint256 i = 0; i < bots_.length; i++) {
1011             _blacklist[bots_[i]] = status;
1012         }
1013     }
1014 
1015     function withdrawStuckEth() external onlyOwner {
1016         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1017         require(success, "failed to withdraw");
1018     }
1019 
1020 }