1 /*
2 
3 
4 https://twitter.com/dednfts
5 https://www.dedfts.io/
6 https://t.me/dedfts
7 
8 */
9 
10 
11 // SPDX-License-Identifier: Unlicensed
12 
13 
14 pragma solidity 0.8.21;
15  
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20  
21     function _msgData() internal view virtual returns (bytes calldata) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26  
27 interface IUniswapV2Pair {
28     event Approval(address indexed owner, address indexed spender, uint value);
29     event Transfer(address indexed from, address indexed to, uint value);
30  
31     function name() external pure returns (string memory);
32     function symbol() external pure returns (string memory);
33     function decimals() external pure returns (uint8);
34     function totalSupply() external view returns (uint);
35     function balanceOf(address owner) external view returns (uint);
36     function allowance(address owner, address spender) external view returns (uint);
37  
38     function approve(address spender, uint value) external returns (bool);
39     function transfer(address to, uint value) external returns (bool);
40     function transferFrom(address from, address to, uint value) external returns (bool);
41  
42     function DOMAIN_SEPARATOR() external view returns (bytes32);
43     function PERMIT_TYPEHASH() external pure returns (bytes32);
44     function nonces(address owner) external view returns (uint);
45  
46     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
47  
48     event Mint(address indexed sender, uint amount0, uint amount1);
49     event Swap(
50         address indexed sender,
51         uint amount0In,
52         uint amount1In,
53         uint amount0Out,
54         uint amount1Out,
55         address indexed to
56     );
57     event Sync(uint112 reserve0, uint112 reserve1);
58  
59     function MINIMUM_LIQUIDITY() external pure returns (uint);
60     function factory() external view returns (address);
61     function token0() external view returns (address);
62     function token1() external view returns (address);
63     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
64     function price0CumulativeLast() external view returns (uint);
65     function price1CumulativeLast() external view returns (uint);
66     function kLast() external view returns (uint);
67  
68     function mint(address to) external returns (uint liquidity);
69     function burn(address to) external returns (uint amount0, uint amount1);
70     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
71     function skim(address to) external;
72     function sync() external;
73  
74     function initialize(address, address) external;
75 }
76  
77 interface IUniswapV2Factory {
78     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
79  
80     function feeTo() external view returns (address);
81     function feeToSetter() external view returns (address);
82  
83     function getPair(address tokenA, address tokenB) external view returns (address pair);
84     function allPairs(uint) external view returns (address pair);
85     function allPairsLength() external view returns (uint);
86  
87     function createPair(address tokenA, address tokenB) external returns (address pair);
88  
89     function setFeeTo(address) external;
90     function setFeeToSetter(address) external;
91 }
92  
93 interface IERC20 {
94     /**
95      * @dev Returns the amount of tokens in existence.
96      */
97     function totalSupply() external view returns (uint256);
98  
99     /**
100      * @dev Returns the amount of tokens owned by `account`.
101      */
102     function balanceOf(address account) external view returns (uint256);
103  
104     /**
105      * @dev Moves `amount` tokens from the caller's account to `recipient`.
106      *
107      * Returns a boolean value indicating whether the operation succeeded.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transfer(address recipient, uint256 amount) external returns (bool);
112  
113     /**
114      * @dev Returns the remaining number of tokens that `spender` will be
115      * allowed to spend on behalf of `owner` through {transferFrom}. This is
116      * zero by default.
117      *
118      * This value changes when {approve} or {transferFrom} are called.
119      */
120     function allowance(address owner, address spender) external view returns (uint256);
121  
122     /**
123      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
124      *
125      * Returns a boolean value indicating whether the operation succeeded.
126      *
127      * IMPORTANT: Beware that changing an allowance with this method brings the risk
128      * that someone may use both the old and the new allowance by unfortunate
129      * transaction ordering. One possible solution to mitigate this race
130      * condition is to first reduce the spender's allowance to 0 and set the
131      * desired value afterwards:
132      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133      *
134      * Emits an {Approval} event.
135      */
136     function approve(address spender, uint256 amount) external returns (bool);
137  
138     /**
139      * @dev Moves `amount` tokens from `sender` to `recipient` using the
140      * allowance mechanism. `amount` is then deducted from the caller's
141      * allowance.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * Emits a {Transfer} event.
146      */
147     function transferFrom(
148         address sender,
149         address recipient,
150         uint256 amount
151     ) external returns (bool);
152  
153     /**
154      * @dev Emitted when `value` tokens are moved from one account (`from`) to
155      * another (`to`).
156      *
157      * Note that `value` may be zero.
158      */
159     event Transfer(address indexed from, address indexed to, uint256 value);
160  
161     /**
162      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
163      * a call to {approve}. `value` is the new allowance.
164      */
165     event Approval(address indexed owner, address indexed spender, uint256 value);
166 }
167  
168 interface IERC20Metadata is IERC20 {
169     /**
170      * @dev Returns the name of the token.
171      */
172     function name() external view returns (string memory);
173  
174     /**
175      * @dev Returns the symbol of the token.
176      */
177     function symbol() external view returns (string memory);
178  
179     /**
180      * @dev Returns the decimals places of the token.
181      */
182     function decimals() external view returns (uint8);
183 }
184  
185  
186 contract ERC20 is Context, IERC20, IERC20Metadata {
187     using SafeMath for uint256;
188  
189     mapping(address => uint256) private _balances;
190  
191     mapping(address => mapping(address => uint256)) private _allowances;
192  
193     uint256 private _totalSupply;
194  
195     string private _name;
196     string private _symbol;
197 
198     constructor(string memory name_, string memory symbol_) {
199         _name = name_;
200         _symbol = symbol_;
201     }
202  
203     /**
204      * @dev Returns the name of the token.
205      */
206     function name() public view virtual override returns (string memory) {
207         return _name;
208     }
209 
210     function symbol() public view virtual override returns (string memory) {
211         return _symbol;
212     }
213 
214     function decimals() public view virtual override returns (uint8) {
215         return 9;
216     }
217  
218     /**
219      * @dev See {IERC20-totalSupply}.
220      */
221     function totalSupply() public view virtual override returns (uint256) {
222         return _totalSupply;
223     }
224  
225     /**
226      * @dev See {IERC20-balanceOf}.
227      */
228     function balanceOf(address account) public view virtual override returns (uint256) {
229         return _balances[account];
230     }
231  
232     /**
233      * @dev See {IERC20-transfer}.
234      *
235      * Requirements:
236      *
237      * - `recipient` cannot be the zero address.
238      * - the caller must have a balance of at least `amount`.
239      */
240     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
241         _transfer(_msgSender(), recipient, amount);
242         return true;
243     }
244  
245     /**
246      * @dev See {IERC20-allowance}.
247      */
248     function allowance(address owner, address spender) public view virtual override returns (uint256) {
249         return _allowances[owner][spender];
250     }
251  
252     /**
253      * @dev See {IERC20-approve}.
254      *
255      * Requirements:
256      *
257      * - `spender` cannot be the zero address.
258      */
259     function approve(address spender, uint256 amount) public virtual override returns (bool) {
260         _approve(_msgSender(), spender, amount);
261         return true;
262     }
263  
264     /**
265      * @dev See {IERC20-transferFrom}.
266      *
267      * Emits an {Approval} event indicating the updated allowance. This is not
268      * required by the EIP. See the note at the beginning of {ERC20}.
269      *
270      * Requirements:
271      *
272      * - `sender` and `recipient` cannot be the zero address.
273      * - `sender` must have a balance of at least `amount`.
274      * - the caller must have allowance for ``sender``'s tokens of at least
275      * `amount`.
276      */
277     function transferFrom(
278         address sender,
279         address recipient,
280         uint256 amount
281     ) public virtual override returns (bool) {
282         _transfer(sender, recipient, amount);
283         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
284         return true;
285     }
286  
287     /**
288      * @dev Atomically increases the allowance granted to `spender` by the caller.
289      *
290      * This is an alternative to {approve} that can be used as a mitigation for
291      * problems described in {IERC20-approve}.
292      *
293      * Emits an {Approval} event indicating the updated allowance.
294      *
295      * Requirements:
296      *
297      * - `spender` cannot be the zero address.
298      */
299     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
300         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
301         return true;
302     }
303 
304     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
305         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
306         return true;
307     }
308  
309     function _transfer(
310         address sender,
311         address recipient,
312         uint256 amount
313     ) internal virtual {
314         require(sender != address(0), "ERC20: transfer from the zero address");
315         require(recipient != address(0), "ERC20: transfer to the zero address");
316  
317         _beforeTokenTransfer(sender, recipient, amount);
318  
319         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
320         _balances[recipient] = _balances[recipient].add(amount);
321         emit Transfer(sender, recipient, amount);
322     }
323 
324     function _mint(address account, uint256 amount) internal virtual {
325         require(account != address(0), "ERC20: mint to the zero address");
326  
327         _beforeTokenTransfer(address(0), account, amount);
328  
329         _totalSupply = _totalSupply.add(amount);
330         _balances[account] = _balances[account].add(amount);
331         emit Transfer(address(0), account, amount);
332     }
333 
334     function _burn(address account, uint256 amount) internal virtual {
335         require(account != address(0), "ERC20: burn from the zero address");
336  
337         _beforeTokenTransfer(account, address(0), amount);
338  
339         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
340         _totalSupply = _totalSupply.sub(amount);
341         emit Transfer(account, address(0), amount);
342     }
343 
344     function _approve(
345         address owner,
346         address spender,
347         uint256 amount
348     ) internal virtual {
349         require(owner != address(0), "ERC20: approve from the zero address");
350         require(spender != address(0), "ERC20: approve to the zero address");
351  
352         _allowances[owner][spender] = amount;
353         emit Approval(owner, spender, amount);
354     }
355 
356     function _beforeTokenTransfer(
357         address from,
358         address to,
359         uint256 amount
360     ) internal virtual {}
361 }
362  
363 library SafeMath {
364 
365     function add(uint256 a, uint256 b) internal pure returns (uint256) {
366         uint256 c = a + b;
367         require(c >= a, "SafeMath: addition overflow");
368  
369         return c;
370     }
371  
372     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
373         return sub(a, b, "SafeMath: subtraction overflow");
374     }
375  
376 
377     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
378         require(b <= a, errorMessage);
379         uint256 c = a - b;
380  
381         return c;
382     }
383  
384 
385     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
386         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
387         // benefit is lost if 'b' is also tested.
388         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
389         if (a == 0) {
390             return 0;
391         }
392  
393         uint256 c = a * b;
394         require(c / a == b, "SafeMath: multiplication overflow");
395  
396         return c;
397     }
398  
399 
400     function div(uint256 a, uint256 b) internal pure returns (uint256) {
401         return div(a, b, "SafeMath: division by zero");
402     }
403 
404     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
405         require(b > 0, errorMessage);
406         uint256 c = a / b;
407         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
408  
409         return c;
410     }
411 
412     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
413         return mod(a, b, "SafeMath: modulo by zero");
414     }
415 
416     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
417         require(b != 0, errorMessage);
418         return a % b;
419     }
420 }
421  
422 contract Ownable is Context {
423     address private _owner;
424  
425     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
426  
427     /**
428      * @dev Initializes the contract setting the deployer as the initial owner.
429      */
430     constructor () {
431         address msgSender = _msgSender();
432         _owner = msgSender;
433         emit OwnershipTransferred(address(0), msgSender);
434     }
435  
436     /**
437      * @dev Returns the address of the current owner.
438      */
439     function owner() public view returns (address) {
440         return _owner;
441     }
442  
443     /**
444      * @dev Throws if called by any account other than the owner.
445      */
446     modifier onlyOwner() {
447         require(_owner == _msgSender(), "Ownable: caller is not the owner");
448         _;
449     }
450  
451     /**
452      * @dev Leaves the contract without owner. It will not be possible to call
453      * `onlyOwner` functions anymore. Can only be called by the current owner.
454      *
455      * NOTE: Renouncing ownership will leave the contract without an owner,
456      * thereby removing any functionality that is only available to the owner.
457      */
458     function renounceOwnership() public virtual onlyOwner {
459         emit OwnershipTransferred(_owner, address(0));
460         _owner = address(0);
461     }
462  
463     /**
464      * @dev Transfers ownership of the contract to a new account (`newOwner`).
465      * Can only be called by the current owner.
466      */
467     function transferOwnership(address newOwner) public virtual onlyOwner {
468         require(newOwner != address(0), "Ownable: new owner is the zero address");
469         emit OwnershipTransferred(_owner, newOwner);
470         _owner = newOwner;
471     }
472 }
473  
474  
475  
476 library SafeMathInt {
477     int256 private constant MIN_INT256 = int256(1) << 255;
478     int256 private constant MAX_INT256 = ~(int256(1) << 255);
479  
480     /**
481      * @dev Multiplies two int256 variables and fails on overflow.
482      */
483     function mul(int256 a, int256 b) internal pure returns (int256) {
484         int256 c = a * b;
485  
486         // Detect overflow when multiplying MIN_INT256 with -1
487         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
488         require((b == 0) || (c / b == a));
489         return c;
490     }
491  
492     /**
493      * @dev Division of two int256 variables and fails on overflow.
494      */
495     function div(int256 a, int256 b) internal pure returns (int256) {
496         // Prevent overflow when dividing MIN_INT256 by -1
497         require(b != -1 || a != MIN_INT256);
498  
499         // Solidity already throws when dividing by 0.
500         return a / b;
501     }
502  
503     /**
504      * @dev Subtracts two int256 variables and fails on overflow.
505      */
506     function sub(int256 a, int256 b) internal pure returns (int256) {
507         int256 c = a - b;
508         require((b >= 0 && c <= a) || (b < 0 && c > a));
509         return c;
510     }
511  
512     /**
513      * @dev Adds two int256 variables and fails on overflow.
514      */
515     function add(int256 a, int256 b) internal pure returns (int256) {
516         int256 c = a + b;
517         require((b >= 0 && c >= a) || (b < 0 && c < a));
518         return c;
519     }
520  
521     /**
522      * @dev Converts to absolute value, and fails on overflow.
523      */
524     function abs(int256 a) internal pure returns (int256) {
525         require(a != MIN_INT256);
526         return a < 0 ? -a : a;
527     }
528  
529  
530     function toUint256Safe(int256 a) internal pure returns (uint256) {
531         require(a >= 0);
532         return uint256(a);
533     }
534 }
535  
536 library SafeMathUint {
537   function toInt256Safe(uint256 a) internal pure returns (int256) {
538     int256 b = int256(a);
539     require(b >= 0);
540     return b;
541   }
542 }
543  
544  
545 interface IUniswapV2Router01 {
546     function factory() external pure returns (address);
547     function WETH() external pure returns (address);
548  
549     function addLiquidity(
550         address tokenA,
551         address tokenB,
552         uint amountADesired,
553         uint amountBDesired,
554         uint amountAMin,
555         uint amountBMin,
556         address to,
557         uint deadline
558     ) external returns (uint amountA, uint amountB, uint liquidity);
559     function addLiquidityETH(
560         address token,
561         uint amountTokenDesired,
562         uint amountTokenMin,
563         uint amountETHMin,
564         address to,
565         uint deadline
566     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
567     function removeLiquidity(
568         address tokenA,
569         address tokenB,
570         uint liquidity,
571         uint amountAMin,
572         uint amountBMin,
573         address to,
574         uint deadline
575     ) external returns (uint amountA, uint amountB);
576     function removeLiquidityETH(
577         address token,
578         uint liquidity,
579         uint amountTokenMin,
580         uint amountETHMin,
581         address to,
582         uint deadline
583     ) external returns (uint amountToken, uint amountETH);
584     function removeLiquidityWithPermit(
585         address tokenA,
586         address tokenB,
587         uint liquidity,
588         uint amountAMin,
589         uint amountBMin,
590         address to,
591         uint deadline,
592         bool approveMax, uint8 v, bytes32 r, bytes32 s
593     ) external returns (uint amountA, uint amountB);
594     function removeLiquidityETHWithPermit(
595         address token,
596         uint liquidity,
597         uint amountTokenMin,
598         uint amountETHMin,
599         address to,
600         uint deadline,
601         bool approveMax, uint8 v, bytes32 r, bytes32 s
602     ) external returns (uint amountToken, uint amountETH);
603     function swapExactTokensForTokens(
604         uint amountIn,
605         uint amountOutMin,
606         address[] calldata path,
607         address to,
608         uint deadline
609     ) external returns (uint[] memory amounts);
610     function swapTokensForExactTokens(
611         uint amountOut,
612         uint amountInMax,
613         address[] calldata path,
614         address to,
615         uint deadline
616     ) external returns (uint[] memory amounts);
617     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
618         external
619         payable
620         returns (uint[] memory amounts);
621     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
622         external
623         returns (uint[] memory amounts);
624     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
625         external
626         returns (uint[] memory amounts);
627     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
628         external
629         payable
630         returns (uint[] memory amounts);
631  
632     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
633     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
634     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
635     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
636     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
637 }
638  
639 interface IUniswapV2Router02 is IUniswapV2Router01 {
640     function removeLiquidityETHSupportingFeeOnTransferTokens(
641         address token,
642         uint liquidity,
643         uint amountTokenMin,
644         uint amountETHMin,
645         address to,
646         uint deadline
647     ) external returns (uint amountETH);
648     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
649         address token,
650         uint liquidity,
651         uint amountTokenMin,
652         uint amountETHMin,
653         address to,
654         uint deadline,
655         bool approveMax, uint8 v, bytes32 r, bytes32 s
656     ) external returns (uint amountETH);
657  
658     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
659         uint amountIn,
660         uint amountOutMin,
661         address[] calldata path,
662         address to,
663         uint deadline
664     ) external;
665     function swapExactETHForTokensSupportingFeeOnTransferTokens(
666         uint amountOutMin,
667         address[] calldata path,
668         address to,
669         uint deadline
670     ) external payable;
671     function swapExactTokensForETHSupportingFeeOnTransferTokens(
672         uint amountIn,
673         uint amountOutMin,
674         address[] calldata path,
675         address to,
676         uint deadline
677     ) external;
678 }
679  
680 contract dedft is ERC20, Ownable {
681     using SafeMath for uint256;
682  
683     IUniswapV2Router02 public immutable uniswapV2Router;
684     address public immutable uniswapV2Pair;
685  
686     bool private swapping;
687  
688     address private marketingWallet;
689     address private teamWallet;
690  
691     uint256 public maxTransactionAmount;
692     uint256 public swapTokensAtAmount;
693     uint256 public maxWallet;
694  
695     bool public limitsInEffect = true;
696     bool public tradingActive = false;
697     bool public swapEnabled = false;
698  
699      // Anti-bot and anti-whale mappings and variables
700     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
701  
702     // Seller Map
703     mapping (address => uint256) private _holderFirstBuyTimestamp;
704  
705     // Blacklist Map
706     mapping (address => bool) private _blacklist;
707     bool public transferDelayEnabled = true;
708  
709     uint256 public buyTotalFees;
710     uint256 public buyMarketingFee;
711     uint256 public buyLiquidityFee;
712     uint256 public buyTeamFee;
713  
714     uint256 public sellTotalFees;
715     uint256 public sellMarketingFee;
716     uint256 public sellLiquidityFee;
717     uint256 public sellTeamFee;
718  
719     uint256 public tokensForMarketing;
720     uint256 public tokensForLiquidity;
721     uint256 public tokensForTeam;
722  
723     // block number of opened trading
724     uint256 launchedAt;
725  
726     /******************/
727  
728     // exclude from fees and max transaction amount
729     mapping (address => bool) private _isExcludedFromFees;
730     mapping (address => bool) public _isExcludedMaxTransactionAmount;
731  
732     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
733     // could be subject to a maximum transfer amount
734     mapping (address => bool) public automatedMarketMakerPairs;
735  
736     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
737  
738     event ExcludeFromFees(address indexed account, bool isExcluded);
739  
740     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
741  
742     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
743  
744     event teamWalletUpdated(address indexed newWallet, address indexed oldWallet);
745  
746     event SwapAndLiquify(
747         uint256 tokensSwapped,
748         uint256 ethReceived,
749         uint256 tokensIntoLiquidity
750     );
751  
752     event AutoNukeLP();
753  
754     event ManualNukeLP();
755  
756     constructor() ERC20("dedfts","dedfts") {
757  
758         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
759  
760         excludeFromMaxTransaction(address(_uniswapV2Router), true);
761         uniswapV2Router = _uniswapV2Router;
762  
763         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
764         excludeFromMaxTransaction(address(uniswapV2Pair), true);
765         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
766  
767         uint256 _buyMarketingFee = 21;
768         uint256 _buyLiquidityFee = 9;
769         uint256 _buyTeamFee = 0;
770  
771         uint256 _sellMarketingFee = 21;
772         uint256 _sellLiquidityFee = 9;
773         uint256 _sellTeamFee = 0;
774  
775         uint256 totalSupply = 1 * 420690420690 * 1e9;
776  
777         maxTransactionAmount = totalSupply * 10 / 1000; // 1% maxTransactionAmountTxn
778         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet
779         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.10% swap wallet
780  
781         buyMarketingFee = _buyMarketingFee;
782         buyLiquidityFee = _buyLiquidityFee;
783         buyTeamFee = _buyTeamFee;
784         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyTeamFee;
785  
786         sellMarketingFee = _sellMarketingFee;
787         sellLiquidityFee = _sellLiquidityFee;
788         sellTeamFee = _sellTeamFee;
789         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellTeamFee;
790  
791         marketingWallet = address(owner()); // set as marketing wallet
792         teamWallet = address(owner()); // set as team wallet
793  
794         // exclude from paying fees or having max transaction amount
795         excludeFromFees(owner(), true);
796         excludeFromFees(address(this), true);
797         excludeFromFees(address(0xdead), true);
798  
799         excludeFromMaxTransaction(owner(), true);
800         excludeFromMaxTransaction(address(this), true);
801         excludeFromMaxTransaction(address(0xdead), true);
802  
803         /*
804             _mint is an internal function in ERC20.sol that is only called here,
805             and CANNOT be called ever again
806         */
807         _mint(msg.sender, totalSupply);
808     }
809  
810     receive() external payable {
811  
812     }
813  
814     // once enabled, can never be turned off
815     function enableTrading() external onlyOwner {
816         tradingActive = true;
817         swapEnabled = true;
818         launchedAt = block.number;
819     }
820  
821     // remove limits after token is stable
822     function removeLimits() external onlyOwner returns (bool){
823         limitsInEffect = false;
824         return true;
825     }
826  
827     // disable Transfer delay - cannot be reenabled
828     function disableTransferDelay() external onlyOwner returns (bool){
829         transferDelayEnabled = false;
830         return true;
831     }
832  
833      // change the minimum amount of tokens to sell from fees
834     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
835         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
836         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
837         swapTokensAtAmount = newAmount;
838         return true;
839     }
840  
841     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
842         require(newNum >= (totalSupply() * 1 / 1000)/1e9, "Cannot set maxTransactionAmount lower than 0.1%");
843         maxTransactionAmount = newNum * (10**9);
844     }
845  
846     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
847         require(newNum >= (totalSupply() * 5 / 1000)/1e9, "Cannot set maxWallet lower than 0.5%");
848         maxWallet = newNum * (10**9);
849     }
850  
851     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
852         _isExcludedMaxTransactionAmount[updAds] = isEx;
853     }
854 
855 
856     function updateBuyFees(
857         uint256 _marketingFee,
858         uint256 _liquidityFee,
859         uint256 _teamFee
860     ) external onlyOwner {
861         buyMarketingFee = _marketingFee;
862         buyLiquidityFee = _liquidityFee;
863         buyTeamFee = _teamFee;
864         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyTeamFee;
865         require(buyTotalFees <= 41, 'Must keep fees at 31% or less');
866     }
867 
868     function updateSellFees(
869         uint256 _marketingFee,
870         uint256 _liquidityFee,
871         uint256 _teamFee
872     ) external onlyOwner {
873         sellMarketingFee = _marketingFee;
874         sellLiquidityFee = _liquidityFee;
875         sellTeamFee = _teamFee;
876         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellTeamFee;
877         require(sellTotalFees <= 41, 'Must keep fees at 31% or less');
878     }
879     // only use to disable contract sales if absolutely necessary (emergency use only)
880     function updateSwapEnabled(bool enabled) external onlyOwner(){
881         swapEnabled = enabled;
882     }
883  
884     function excludeFromFees(address account, bool excluded) public onlyOwner {
885         _isExcludedFromFees[account] = excluded;
886         emit ExcludeFromFees(account, excluded);
887     }
888  
889     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
890         _blacklist[account] = isBlacklisted;
891     }
892  
893     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
894         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
895  
896         _setAutomatedMarketMakerPair(pair, value);
897     }
898  
899     function _setAutomatedMarketMakerPair(address pair, bool value) private {
900         automatedMarketMakerPairs[pair] = value;
901  
902         emit SetAutomatedMarketMakerPair(pair, value);
903     }
904  
905     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
906         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
907         marketingWallet = newMarketingWallet;
908     }
909  
910     function updateTeamWallet(address newWallet) external onlyOwner {
911         emit teamWalletUpdated(newWallet, teamWallet);
912         teamWallet = newWallet;
913     }
914  
915  
916     function isExcludedFromFees(address account) public view returns(bool) {
917         return _isExcludedFromFees[account];
918     }
919  
920     function _transfer(
921         address from,
922         address to,
923         uint256 amount
924     ) internal override {
925         require(from != address(0), "ERC20: transfer from the zero address");
926         require(to != address(0), "ERC20: transfer to the zero address");
927         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
928          if(amount == 0) {
929             super._transfer(from, to, 0);
930             return;
931         }
932  
933         if(limitsInEffect){
934             if (
935                 from != owner() &&
936                 to != owner() &&
937                 to != address(0) &&
938                 to != address(0xdead) &&
939                 !swapping
940             ){
941                 if(!tradingActive){
942                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
943                 }
944  
945                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
946                 if (transferDelayEnabled){
947                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
948                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
949                         _holderLastTransferTimestamp[tx.origin] = block.number;
950                     }
951                 }
952  
953                 //when buy
954                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
955                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
956                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
957                 }
958  
959                 //when sell
960                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
961                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
962                 }
963                 else if(!_isExcludedMaxTransactionAmount[to]){
964                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
965                 }
966             }
967         }
968  
969         uint256 contractTokenBalance = balanceOf(address(this));
970  
971         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
972  
973         if( 
974             canSwap &&
975             swapEnabled &&
976             !swapping &&
977             !automatedMarketMakerPairs[from] &&
978             !_isExcludedFromFees[from] &&
979             !_isExcludedFromFees[to]
980         ) {
981             swapping = true;
982  
983             swapBack();
984  
985             swapping = false;
986         }
987  
988         bool takeFee = !swapping;
989  
990         // if any account belongs to _isExcludedFromFee account then remove the fee
991         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
992             takeFee = false;
993         }
994  
995         uint256 fees = 0;
996         // only take fees on buys/sells, do not take on wallet transfers
997         if(takeFee){
998             // on sell
999             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1000                 fees = amount.mul(sellTotalFees).div(100);
1001                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1002                 tokensForTeam += fees * sellTeamFee / sellTotalFees;
1003                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1004             }
1005             // on buy
1006             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1007                 fees = amount.mul(buyTotalFees).div(100);
1008                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1009                 tokensForTeam += fees * buyTeamFee / buyTotalFees;
1010                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1011             }
1012  
1013             if(fees > 0){    
1014                 super._transfer(from, address(this), fees);
1015             }
1016  
1017             amount -= fees;
1018         }
1019  
1020         super._transfer(from, to, amount);
1021     }
1022  
1023     function swapTokensForEth(uint256 tokenAmount) private {
1024  
1025         // generate the uniswap pair path of token -> weth
1026         address[] memory path = new address[](2);
1027         path[0] = address(this);
1028         path[1] = uniswapV2Router.WETH();
1029  
1030         _approve(address(this), address(uniswapV2Router), tokenAmount);
1031  
1032         // make the swap
1033         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1034             tokenAmount,
1035             0, // accept any amount of ETH
1036             path,
1037             address(this),
1038             block.timestamp
1039         );
1040  
1041     }
1042  
1043     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1044         // approve token transfer to cover all possible scenarios
1045         _approve(address(this), address(uniswapV2Router), tokenAmount);
1046  
1047         // add the liquidity
1048         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1049             address(this),
1050             tokenAmount,
1051             0, // slippage is unavoidable
1052             0, // slippage is unavoidable
1053             address(marketingWallet),
1054             block.timestamp
1055         );
1056     }
1057  
1058     function swapBack() private {
1059         uint256 contractBalance = balanceOf(address(this));
1060         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForTeam;
1061         bool success;
1062  
1063         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1064  
1065         if(contractBalance > swapTokensAtAmount * 20){
1066           contractBalance = swapTokensAtAmount * 20;
1067         }
1068  
1069         // Halve the amount of liquidity tokens
1070         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1071         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1072  
1073         uint256 initialETHBalance = address(this).balance;
1074  
1075         swapTokensForEth(amountToSwapForETH); 
1076  
1077         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1078  
1079         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1080         uint256 ethForTeam = ethBalance.mul(tokensForTeam).div(totalTokensToSwap);
1081         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForTeam;
1082  
1083  
1084         tokensForLiquidity = 0;
1085         tokensForMarketing = 0;
1086         tokensForTeam = 0;
1087  
1088         (success,) = address(teamWallet).call{value: ethForTeam}("");
1089  
1090         if(liquidityTokens > 0 && ethForLiquidity > 0){
1091             addLiquidity(liquidityTokens, ethForLiquidity);
1092             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1093         }
1094  
1095         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1096     }
1097 }