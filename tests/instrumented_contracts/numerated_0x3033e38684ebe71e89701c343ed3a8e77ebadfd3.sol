1 /*
2 
3 
4 
5 Portal:  https://t.me/BananaCat_ERC
6 Twitter: https://twitter.com/BananaCatERC
7 Website: https://www.banana-cat.xyz/
8 
9 
10 
11 */
12 
13 
14 
15 
16 // SPDX-License-Identifier: Unlicensed
17 
18 
19 pragma solidity 0.8.11;
20  
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25  
26     function _msgData() internal view virtual returns (bytes calldata) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31  
32 interface IUniswapV2Pair {
33     event Approval(address indexed owner, address indexed spender, uint value);
34     event Transfer(address indexed from, address indexed to, uint value);
35  
36     function name() external pure returns (string memory);
37     function symbol() external pure returns (string memory);
38     function decimals() external pure returns (uint8);
39     function totalSupply() external view returns (uint);
40     function balanceOf(address owner) external view returns (uint);
41     function allowance(address owner, address spender) external view returns (uint);
42  
43     function approve(address spender, uint value) external returns (bool);
44     function transfer(address to, uint value) external returns (bool);
45     function transferFrom(address from, address to, uint value) external returns (bool);
46  
47     function DOMAIN_SEPARATOR() external view returns (bytes32);
48     function PERMIT_TYPEHASH() external pure returns (bytes32);
49     function nonces(address owner) external view returns (uint);
50  
51     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
52  
53     event Mint(address indexed sender, uint amount0, uint amount1);
54     event Swap(
55         address indexed sender,
56         uint amount0In,
57         uint amount1In,
58         uint amount0Out,
59         uint amount1Out,
60         address indexed to
61     );
62     event Sync(uint112 reserve0, uint112 reserve1);
63  
64     function MINIMUM_LIQUIDITY() external pure returns (uint);
65     function factory() external view returns (address);
66     function token0() external view returns (address);
67     function token1() external view returns (address);
68     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
69     function price0CumulativeLast() external view returns (uint);
70     function price1CumulativeLast() external view returns (uint);
71     function kLast() external view returns (uint);
72  
73     function mint(address to) external returns (uint liquidity);
74     function burn(address to) external returns (uint amount0, uint amount1);
75     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
76     function skim(address to) external;
77     function sync() external;
78  
79     function initialize(address, address) external;
80 }
81  
82 interface IUniswapV2Factory {
83     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
84  
85     function feeTo() external view returns (address);
86     function feeToSetter() external view returns (address);
87  
88     function getPair(address tokenA, address tokenB) external view returns (address pair);
89     function allPairs(uint) external view returns (address pair);
90     function allPairsLength() external view returns (uint);
91  
92     function createPair(address tokenA, address tokenB) external returns (address pair);
93  
94     function setFeeTo(address) external;
95     function setFeeToSetter(address) external;
96 }
97  
98 interface IERC20 {
99     /**
100      * @dev Returns the amount of tokens in existence.
101      */
102     function totalSupply() external view returns (uint256);
103  
104     /**
105      * @dev Returns the amount of tokens owned by `account`.
106      */
107     function balanceOf(address account) external view returns (uint256);
108  
109     /**
110      * @dev Moves `amount` tokens from the caller's account to `recipient`.
111      *
112      * Returns a boolean value indicating whether the operation succeeded.
113      *
114      * Emits a {Transfer} event.
115      */
116     function transfer(address recipient, uint256 amount) external returns (bool);
117  
118     /**
119      * @dev Returns the remaining number of tokens that `spender` will be
120      * allowed to spend on behalf of `owner` through {transferFrom}. This is
121      * zero by default.
122      *
123      * This value changes when {approve} or {transferFrom} are called.
124      */
125     function allowance(address owner, address spender) external view returns (uint256);
126  
127     /**
128      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
129      *
130      * Returns a boolean value indicating whether the operation succeeded.
131      *
132      * IMPORTANT: Beware that changing an allowance with this method brings the risk
133      * that someone may use both the old and the new allowance by unfortunate
134      * transaction ordering. One possible solution to mitigate this race
135      * condition is to first reduce the spender's allowance to 0 and set the
136      * desired value afterwards:
137      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138      *
139      * Emits an {Approval} event.
140      */
141     function approve(address spender, uint256 amount) external returns (bool);
142  
143     /**
144      * @dev Moves `amount` tokens from `sender` to `recipient` using the
145      * allowance mechanism. `amount` is then deducted from the caller's
146      * allowance.
147      *
148      * Returns a boolean value indicating whether the operation succeeded.
149      *
150      * Emits a {Transfer} event.
151      */
152     function transferFrom(
153         address sender,
154         address recipient,
155         uint256 amount
156     ) external returns (bool);
157  
158     /**
159      * @dev Emitted when `value` tokens are moved from one account (`from`) to
160      * another (`to`).
161      *
162      * Note that `value` may be zero.
163      */
164     event Transfer(address indexed from, address indexed to, uint256 value);
165  
166     /**
167      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
168      * a call to {approve}. `value` is the new allowance.
169      */
170     event Approval(address indexed owner, address indexed spender, uint256 value);
171 }
172  
173 interface IERC20Metadata is IERC20 {
174     /**
175      * @dev Returns the name of the token.
176      */
177     function name() external view returns (string memory);
178  
179     /**
180      * @dev Returns the symbol of the token.
181      */
182     function symbol() external view returns (string memory);
183  
184     /**
185      * @dev Returns the decimals places of the token.
186      */
187     function decimals() external view returns (uint8);
188 }
189  
190  
191 contract ERC20 is Context, IERC20, IERC20Metadata {
192     using SafeMath for uint256;
193  
194     mapping(address => uint256) private _balances;
195  
196     mapping(address => mapping(address => uint256)) private _allowances;
197  
198     uint256 private _totalSupply;
199  
200     string private _name;
201     string private _symbol;
202 
203     constructor(string memory name_, string memory symbol_) {
204         _name = name_;
205         _symbol = symbol_;
206     }
207  
208     /**
209      * @dev Returns the name of the token.
210      */
211     function name() public view virtual override returns (string memory) {
212         return _name;
213     }
214 
215     function symbol() public view virtual override returns (string memory) {
216         return _symbol;
217     }
218 
219     function decimals() public view virtual override returns (uint8) {
220         return 9;
221     }
222  
223     /**
224      * @dev See {IERC20-totalSupply}.
225      */
226     function totalSupply() public view virtual override returns (uint256) {
227         return _totalSupply;
228     }
229  
230     /**
231      * @dev See {IERC20-balanceOf}.
232      */
233     function balanceOf(address account) public view virtual override returns (uint256) {
234         return _balances[account];
235     }
236  
237     /**
238      * @dev See {IERC20-transfer}.
239      *
240      * Requirements:
241      *
242      * - `recipient` cannot be the zero address.
243      * - the caller must have a balance of at least `amount`.
244      */
245     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
246         _transfer(_msgSender(), recipient, amount);
247         return true;
248     }
249  
250     /**
251      * @dev See {IERC20-allowance}.
252      */
253     function allowance(address owner, address spender) public view virtual override returns (uint256) {
254         return _allowances[owner][spender];
255     }
256  
257     /**
258      * @dev See {IERC20-approve}.
259      *
260      * Requirements:
261      *
262      * - `spender` cannot be the zero address.
263      */
264     function approve(address spender, uint256 amount) public virtual override returns (bool) {
265         _approve(_msgSender(), spender, amount);
266         return true;
267     }
268  
269     /**
270      * @dev See {IERC20-transferFrom}.
271      *
272      * Emits an {Approval} event indicating the updated allowance. This is not
273      * required by the EIP. See the note at the beginning of {ERC20}.
274      *
275      * Requirements:
276      *
277      * - `sender` and `recipient` cannot be the zero address.
278      * - `sender` must have a balance of at least `amount`.
279      * - the caller must have allowance for ``sender``'s tokens of at least
280      * `amount`.
281      */
282     function transferFrom(
283         address sender,
284         address recipient,
285         uint256 amount
286     ) public virtual override returns (bool) {
287         _transfer(sender, recipient, amount);
288         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
289         return true;
290     }
291  
292     /**
293      * @dev Atomically increases the allowance granted to `spender` by the caller.
294      *
295      * This is an alternative to {approve} that can be used as a mitigation for
296      * problems described in {IERC20-approve}.
297      *
298      * Emits an {Approval} event indicating the updated allowance.
299      *
300      * Requirements:
301      *
302      * - `spender` cannot be the zero address.
303      */
304     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
305         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
306         return true;
307     }
308 
309     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
310         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
311         return true;
312     }
313  
314     function _transfer(
315         address sender,
316         address recipient,
317         uint256 amount
318     ) internal virtual {
319         require(sender != address(0), "ERC20: transfer from the zero address");
320         require(recipient != address(0), "ERC20: transfer to the zero address");
321  
322         _beforeTokenTransfer(sender, recipient, amount);
323  
324         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
325         _balances[recipient] = _balances[recipient].add(amount);
326         emit Transfer(sender, recipient, amount);
327     }
328 
329     function _mint(address account, uint256 amount) internal virtual {
330         require(account != address(0), "ERC20: mint to the zero address");
331  
332         _beforeTokenTransfer(address(0), account, amount);
333  
334         _totalSupply = _totalSupply.add(amount);
335         _balances[account] = _balances[account].add(amount);
336         emit Transfer(address(0), account, amount);
337     }
338 
339     function _burn(address account, uint256 amount) internal virtual {
340         require(account != address(0), "ERC20: burn from the zero address");
341  
342         _beforeTokenTransfer(account, address(0), amount);
343  
344         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
345         _totalSupply = _totalSupply.sub(amount);
346         emit Transfer(account, address(0), amount);
347     }
348 
349     function _approve(
350         address owner,
351         address spender,
352         uint256 amount
353     ) internal virtual {
354         require(owner != address(0), "ERC20: approve from the zero address");
355         require(spender != address(0), "ERC20: approve to the zero address");
356  
357         _allowances[owner][spender] = amount;
358         emit Approval(owner, spender, amount);
359     }
360 
361     function _beforeTokenTransfer(
362         address from,
363         address to,
364         uint256 amount
365     ) internal virtual {}
366 }
367  
368 library SafeMath {
369 
370     function add(uint256 a, uint256 b) internal pure returns (uint256) {
371         uint256 c = a + b;
372         require(c >= a, "SafeMath: addition overflow");
373  
374         return c;
375     }
376  
377     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
378         return sub(a, b, "SafeMath: subtraction overflow");
379     }
380  
381 
382     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
383         require(b <= a, errorMessage);
384         uint256 c = a - b;
385  
386         return c;
387     }
388  
389 
390     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
391         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
392         // benefit is lost if 'b' is also tested.
393         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
394         if (a == 0) {
395             return 0;
396         }
397  
398         uint256 c = a * b;
399         require(c / a == b, "SafeMath: multiplication overflow");
400  
401         return c;
402     }
403  
404 
405     function div(uint256 a, uint256 b) internal pure returns (uint256) {
406         return div(a, b, "SafeMath: division by zero");
407     }
408 
409     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
410         require(b > 0, errorMessage);
411         uint256 c = a / b;
412         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
413  
414         return c;
415     }
416 
417     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
418         return mod(a, b, "SafeMath: modulo by zero");
419     }
420 
421     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
422         require(b != 0, errorMessage);
423         return a % b;
424     }
425 }
426  
427 contract Ownable is Context {
428     address private _owner;
429  
430     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
431  
432     /**
433      * @dev Initializes the contract setting the deployer as the initial owner.
434      */
435     constructor () {
436         address msgSender = _msgSender();
437         _owner = msgSender;
438         emit OwnershipTransferred(address(0), msgSender);
439     }
440  
441     /**
442      * @dev Returns the address of the current owner.
443      */
444     function owner() public view returns (address) {
445         return _owner;
446     }
447  
448     /**
449      * @dev Throws if called by any account other than the owner.
450      */
451     modifier onlyOwner() {
452         require(_owner == _msgSender(), "Ownable: caller is not the owner");
453         _;
454     }
455  
456     /**
457      * @dev Leaves the contract without owner. It will not be possible to call
458      * `onlyOwner` functions anymore. Can only be called by the current owner.
459      *
460      * NOTE: Renouncing ownership will leave the contract without an owner,
461      * thereby removing any functionality that is only available to the owner.
462      */
463     function renounceOwnership() public virtual onlyOwner {
464         emit OwnershipTransferred(_owner, address(0));
465         _owner = address(0);
466     }
467  
468     /**
469      * @dev Transfers ownership of the contract to a new account (`newOwner`).
470      * Can only be called by the current owner.
471      */
472     function transferOwnership(address newOwner) public virtual onlyOwner {
473         require(newOwner != address(0), "Ownable: new owner is the zero address");
474         emit OwnershipTransferred(_owner, newOwner);
475         _owner = newOwner;
476     }
477 }
478  
479  
480  
481 library SafeMathInt {
482     int256 private constant MIN_INT256 = int256(1) << 255;
483     int256 private constant MAX_INT256 = ~(int256(1) << 255);
484  
485     /**
486      * @dev Multiplies two int256 variables and fails on overflow.
487      */
488     function mul(int256 a, int256 b) internal pure returns (int256) {
489         int256 c = a * b;
490  
491         // Detect overflow when multiplying MIN_INT256 with -1
492         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
493         require((b == 0) || (c / b == a));
494         return c;
495     }
496  
497     /**
498      * @dev Division of two int256 variables and fails on overflow.
499      */
500     function div(int256 a, int256 b) internal pure returns (int256) {
501         // Prevent overflow when dividing MIN_INT256 by -1
502         require(b != -1 || a != MIN_INT256);
503  
504         // Solidity already throws when dividing by 0.
505         return a / b;
506     }
507  
508     /**
509      * @dev Subtracts two int256 variables and fails on overflow.
510      */
511     function sub(int256 a, int256 b) internal pure returns (int256) {
512         int256 c = a - b;
513         require((b >= 0 && c <= a) || (b < 0 && c > a));
514         return c;
515     }
516  
517     /**
518      * @dev Adds two int256 variables and fails on overflow.
519      */
520     function add(int256 a, int256 b) internal pure returns (int256) {
521         int256 c = a + b;
522         require((b >= 0 && c >= a) || (b < 0 && c < a));
523         return c;
524     }
525  
526     /**
527      * @dev Converts to absolute value, and fails on overflow.
528      */
529     function abs(int256 a) internal pure returns (int256) {
530         require(a != MIN_INT256);
531         return a < 0 ? -a : a;
532     }
533  
534  
535     function toUint256Safe(int256 a) internal pure returns (uint256) {
536         require(a >= 0);
537         return uint256(a);
538     }
539 }
540  
541 library SafeMathUint {
542   function toInt256Safe(uint256 a) internal pure returns (int256) {
543     int256 b = int256(a);
544     require(b >= 0);
545     return b;
546   }
547 }
548  
549  
550 interface IUniswapV2Router01 {
551     function factory() external pure returns (address);
552     function WETH() external pure returns (address);
553  
554     function addLiquidity(
555         address tokenA,
556         address tokenB,
557         uint amountADesired,
558         uint amountBDesired,
559         uint amountAMin,
560         uint amountBMin,
561         address to,
562         uint deadline
563     ) external returns (uint amountA, uint amountB, uint liquidity);
564     function addLiquidityETH(
565         address token,
566         uint amountTokenDesired,
567         uint amountTokenMin,
568         uint amountETHMin,
569         address to,
570         uint deadline
571     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
572     function removeLiquidity(
573         address tokenA,
574         address tokenB,
575         uint liquidity,
576         uint amountAMin,
577         uint amountBMin,
578         address to,
579         uint deadline
580     ) external returns (uint amountA, uint amountB);
581     function removeLiquidityETH(
582         address token,
583         uint liquidity,
584         uint amountTokenMin,
585         uint amountETHMin,
586         address to,
587         uint deadline
588     ) external returns (uint amountToken, uint amountETH);
589     function removeLiquidityWithPermit(
590         address tokenA,
591         address tokenB,
592         uint liquidity,
593         uint amountAMin,
594         uint amountBMin,
595         address to,
596         uint deadline,
597         bool approveMax, uint8 v, bytes32 r, bytes32 s
598     ) external returns (uint amountA, uint amountB);
599     function removeLiquidityETHWithPermit(
600         address token,
601         uint liquidity,
602         uint amountTokenMin,
603         uint amountETHMin,
604         address to,
605         uint deadline,
606         bool approveMax, uint8 v, bytes32 r, bytes32 s
607     ) external returns (uint amountToken, uint amountETH);
608     function swapExactTokensForTokens(
609         uint amountIn,
610         uint amountOutMin,
611         address[] calldata path,
612         address to,
613         uint deadline
614     ) external returns (uint[] memory amounts);
615     function swapTokensForExactTokens(
616         uint amountOut,
617         uint amountInMax,
618         address[] calldata path,
619         address to,
620         uint deadline
621     ) external returns (uint[] memory amounts);
622     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
623         external
624         payable
625         returns (uint[] memory amounts);
626     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
627         external
628         returns (uint[] memory amounts);
629     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
630         external
631         returns (uint[] memory amounts);
632     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
633         external
634         payable
635         returns (uint[] memory amounts);
636  
637     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
638     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
639     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
640     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
641     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
642 }
643  
644 interface IUniswapV2Router02 is IUniswapV2Router01 {
645     function removeLiquidityETHSupportingFeeOnTransferTokens(
646         address token,
647         uint liquidity,
648         uint amountTokenMin,
649         uint amountETHMin,
650         address to,
651         uint deadline
652     ) external returns (uint amountETH);
653     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
654         address token,
655         uint liquidity,
656         uint amountTokenMin,
657         uint amountETHMin,
658         address to,
659         uint deadline,
660         bool approveMax, uint8 v, bytes32 r, bytes32 s
661     ) external returns (uint amountETH);
662  
663     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
664         uint amountIn,
665         uint amountOutMin,
666         address[] calldata path,
667         address to,
668         uint deadline
669     ) external;
670     function swapExactETHForTokensSupportingFeeOnTransferTokens(
671         uint amountOutMin,
672         address[] calldata path,
673         address to,
674         uint deadline
675     ) external payable;
676     function swapExactTokensForETHSupportingFeeOnTransferTokens(
677         uint amountIn,
678         uint amountOutMin,
679         address[] calldata path,
680         address to,
681         uint deadline
682     ) external;
683 }
684  
685 contract BananaCat is ERC20, Ownable {
686     using SafeMath for uint256;
687  
688     IUniswapV2Router02 public immutable uniswapV2Router;
689     address public immutable uniswapV2Pair;
690  
691     bool private swapping;
692  
693     address private marketingWallet;
694     address private teamWallet;
695  
696     uint256 public maxTransactionAmount;
697     uint256 public swapTokensAtAmount;
698     uint256 public maxWallet;
699  
700     bool public limitsInEffect = true;
701     bool public tradingActive = false;
702     bool public swapEnabled = false;
703  
704      // Anti-bot and anti-whale mappings and variables
705     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
706  
707     // Seller Map
708     mapping (address => uint256) private _holderFirstBuyTimestamp;
709  
710     // Blacklist Map
711     mapping (address => bool) private _blacklist;
712     bool public transferDelayEnabled = true;
713  
714     uint256 public buyTotalFees;
715     uint256 public buyMarketingFee;
716     uint256 public buyLiquidityFee;
717     uint256 public buyTeamFee;
718  
719     uint256 public sellTotalFees;
720     uint256 public sellMarketingFee;
721     uint256 public sellLiquidityFee;
722     uint256 public sellTeamFee;
723  
724     uint256 public tokensForMarketing;
725     uint256 public tokensForLiquidity;
726     uint256 public tokensForTeam;
727  
728     // block number of opened trading
729     uint256 launchedAt;
730  
731     /******************/
732  
733     // exclude from fees and max transaction amount
734     mapping (address => bool) private _isExcludedFromFees;
735     mapping (address => bool) public _isExcludedMaxTransactionAmount;
736  
737     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
738     // could be subject to a maximum transfer amount
739     mapping (address => bool) public automatedMarketMakerPairs;
740  
741     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
742  
743     event ExcludeFromFees(address indexed account, bool isExcluded);
744  
745     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
746  
747     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
748  
749     event teamWalletUpdated(address indexed newWallet, address indexed oldWallet);
750  
751     event SwapAndLiquify(
752         uint256 tokensSwapped,
753         uint256 ethReceived,
754         uint256 tokensIntoLiquidity
755     );
756  
757     event AutoNukeLP();
758  
759     event ManualNukeLP();
760  
761     constructor() ERC20("BANANACAT", unicode"Бананакат") {
762  
763         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
764  
765         excludeFromMaxTransaction(address(_uniswapV2Router), true);
766         uniswapV2Router = _uniswapV2Router;
767  
768         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
769         excludeFromMaxTransaction(address(uniswapV2Pair), true);
770         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
771  
772         uint256 _buyMarketingFee = 25;
773         uint256 _buyLiquidityFee = 10;
774         uint256 _buyTeamFee = 0;
775  
776         uint256 _sellMarketingFee = 25;
777         uint256 _sellLiquidityFee = 10;
778         uint256 _sellTeamFee = 0;
779  
780         uint256 totalSupply = 1 * 100000000000 * 1e9;
781  
782         maxTransactionAmount = totalSupply * 10 / 1000; // 1% maxTransactionAmountTxn
783         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet
784         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.10% swap wallet
785  
786         buyMarketingFee = _buyMarketingFee;
787         buyLiquidityFee = _buyLiquidityFee;
788         buyTeamFee = _buyTeamFee;
789         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyTeamFee;
790  
791         sellMarketingFee = _sellMarketingFee;
792         sellLiquidityFee = _sellLiquidityFee;
793         sellTeamFee = _sellTeamFee;
794         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellTeamFee;
795  
796         marketingWallet = address(owner()); // set as marketing wallet
797         teamWallet = address(owner()); // set as team wallet
798  
799         // exclude from paying fees or having max transaction amount
800         excludeFromFees(owner(), true);
801         excludeFromFees(address(this), true);
802         excludeFromFees(address(0xdead), true);
803  
804         excludeFromMaxTransaction(owner(), true);
805         excludeFromMaxTransaction(address(this), true);
806         excludeFromMaxTransaction(address(0xdead), true);
807  
808         /*
809             _mint is an internal function in ERC20.sol that is only called here,
810             and CANNOT be called ever again
811         */
812         _mint(msg.sender, totalSupply);
813     }
814  
815     receive() external payable {
816  
817     }
818  
819     // once enabled, can never be turned off
820     function enableTrading() external onlyOwner {
821         tradingActive = true;
822         swapEnabled = true;
823         launchedAt = block.number;
824     }
825  
826     // remove limits after token is stable
827     function removeLimits() external onlyOwner returns (bool){
828         limitsInEffect = false;
829         return true;
830     }
831  
832     // disable Transfer delay - cannot be reenabled
833     function disableTransferDelay() external onlyOwner returns (bool){
834         transferDelayEnabled = false;
835         return true;
836     }
837  
838      // change the minimum amount of tokens to sell from fees
839     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
840         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
841         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
842         swapTokensAtAmount = newAmount;
843         return true;
844     }
845  
846     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
847         require(newNum >= (totalSupply() * 1 / 1000)/1e9, "Cannot set maxTransactionAmount lower than 0.1%");
848         maxTransactionAmount = newNum * (10**9);
849     }
850  
851     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
852         require(newNum >= (totalSupply() * 5 / 1000)/1e9, "Cannot set maxWallet lower than 0.5%");
853         maxWallet = newNum * (10**9);
854     }
855  
856     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
857         _isExcludedMaxTransactionAmount[updAds] = isEx;
858     }
859 
860 
861     function updateBuyFees(
862         uint256 _marketingFee,
863         uint256 _liquidityFee,
864         uint256 _teamFee
865     ) external onlyOwner {
866         buyMarketingFee = _marketingFee;
867         buyLiquidityFee = _liquidityFee;
868         buyTeamFee = _teamFee;
869         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyTeamFee;
870         require(buyTotalFees <= 51, 'Must keep fees at 51% or less');
871     }
872 
873     function updateSellFees(
874         uint256 _marketingFee,
875         uint256 _liquidityFee,
876         uint256 _teamFee
877     ) external onlyOwner {
878         sellMarketingFee = _marketingFee;
879         sellLiquidityFee = _liquidityFee;
880         sellTeamFee = _teamFee;
881         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellTeamFee;
882         require(sellTotalFees <= 51, 'Must keep fees at 51% or less');
883     }
884     // only use to disable contract sales if absolutely necessary (emergency use only)
885     function updateSwapEnabled(bool enabled) external onlyOwner(){
886         swapEnabled = enabled;
887     }
888  
889     function excludeFromFees(address account, bool excluded) public onlyOwner {
890         _isExcludedFromFees[account] = excluded;
891         emit ExcludeFromFees(account, excluded);
892     }
893  
894     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
895         _blacklist[account] = isBlacklisted;
896     }
897  
898     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
899         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
900  
901         _setAutomatedMarketMakerPair(pair, value);
902     }
903  
904     function _setAutomatedMarketMakerPair(address pair, bool value) private {
905         automatedMarketMakerPairs[pair] = value;
906  
907         emit SetAutomatedMarketMakerPair(pair, value);
908     }
909  
910     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
911         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
912         marketingWallet = newMarketingWallet;
913     }
914  
915     function updateTeamWallet(address newWallet) external onlyOwner {
916         emit teamWalletUpdated(newWallet, teamWallet);
917         teamWallet = newWallet;
918     }
919  
920  
921     function isExcludedFromFees(address account) public view returns(bool) {
922         return _isExcludedFromFees[account];
923     }
924  
925     function _transfer(
926         address from,
927         address to,
928         uint256 amount
929     ) internal override {
930         require(from != address(0), "ERC20: transfer from the zero address");
931         require(to != address(0), "ERC20: transfer to the zero address");
932         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
933          if(amount == 0) {
934             super._transfer(from, to, 0);
935             return;
936         }
937  
938         if(limitsInEffect){
939             if (
940                 from != owner() &&
941                 to != owner() &&
942                 to != address(0) &&
943                 to != address(0xdead) &&
944                 !swapping
945             ){
946                 if(!tradingActive){
947                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
948                 }
949  
950                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
951                 if (transferDelayEnabled){
952                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
953                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
954                         _holderLastTransferTimestamp[tx.origin] = block.number;
955                     }
956                 }
957  
958                 //when buy
959                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
960                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
961                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
962                 }
963  
964                 //when sell
965                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
966                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
967                 }
968                 else if(!_isExcludedMaxTransactionAmount[to]){
969                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
970                 }
971             }
972         }
973  
974         uint256 contractTokenBalance = balanceOf(address(this));
975  
976         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
977  
978         if( 
979             canSwap &&
980             swapEnabled &&
981             !swapping &&
982             !automatedMarketMakerPairs[from] &&
983             !_isExcludedFromFees[from] &&
984             !_isExcludedFromFees[to]
985         ) {
986             swapping = true;
987  
988             swapBack();
989  
990             swapping = false;
991         }
992  
993         bool takeFee = !swapping;
994  
995         // if any account belongs to _isExcludedFromFee account then remove the fee
996         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
997             takeFee = false;
998         }
999  
1000         uint256 fees = 0;
1001         // only take fees on buys/sells, do not take on wallet transfers
1002         if(takeFee){
1003             // on sell
1004             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1005                 fees = amount.mul(sellTotalFees).div(100);
1006                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1007                 tokensForTeam += fees * sellTeamFee / sellTotalFees;
1008                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1009             }
1010             // on buy
1011             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1012                 fees = amount.mul(buyTotalFees).div(100);
1013                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1014                 tokensForTeam += fees * buyTeamFee / buyTotalFees;
1015                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1016             }
1017  
1018             if(fees > 0){    
1019                 super._transfer(from, address(this), fees);
1020             }
1021  
1022             amount -= fees;
1023         }
1024  
1025         super._transfer(from, to, amount);
1026     }
1027  
1028     function swapTokensForEth(uint256 tokenAmount) private {
1029  
1030         // generate the uniswap pair path of token -> weth
1031         address[] memory path = new address[](2);
1032         path[0] = address(this);
1033         path[1] = uniswapV2Router.WETH();
1034  
1035         _approve(address(this), address(uniswapV2Router), tokenAmount);
1036  
1037         // make the swap
1038         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1039             tokenAmount,
1040             0, // accept any amount of ETH
1041             path,
1042             address(this),
1043             block.timestamp
1044         );
1045  
1046     }
1047  
1048     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1049         // approve token transfer to cover all possible scenarios
1050         _approve(address(this), address(uniswapV2Router), tokenAmount);
1051  
1052         // add the liquidity
1053         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1054             address(this),
1055             tokenAmount,
1056             0, // slippage is unavoidable
1057             0, // slippage is unavoidable
1058             address(marketingWallet),
1059             block.timestamp
1060         );
1061     }
1062  
1063     function swapBack() private {
1064         uint256 contractBalance = balanceOf(address(this));
1065         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForTeam;
1066         bool success;
1067  
1068         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1069  
1070         if(contractBalance > swapTokensAtAmount * 20){
1071           contractBalance = swapTokensAtAmount * 20;
1072         }
1073  
1074         // Halve the amount of liquidity tokens
1075         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1076         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1077  
1078         uint256 initialETHBalance = address(this).balance;
1079  
1080         swapTokensForEth(amountToSwapForETH); 
1081  
1082         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1083  
1084         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1085         uint256 ethForTeam = ethBalance.mul(tokensForTeam).div(totalTokensToSwap);
1086         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForTeam;
1087  
1088  
1089         tokensForLiquidity = 0;
1090         tokensForMarketing = 0;
1091         tokensForTeam = 0;
1092  
1093         (success,) = address(teamWallet).call{value: ethForTeam}("");
1094  
1095         if(liquidityTokens > 0 && ethForLiquidity > 0){
1096             addLiquidity(liquidityTokens, ethForLiquidity);
1097             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1098         }
1099  
1100         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1101     }
1102 }