1 // SPDX-License-Identifier: MIT
2 
3 // Hel is a mini game casino built for the true degens of crypto! 
4 
5 // Twitter :   https://twitter.com/hel_eth
6 // Telegram :  https://t.me/Hel_Games 
7 
8 
9 // Designed and Deployed by @crypt0xa
10 // For more info, check out https://xa0.dev
11 
12 pragma solidity >=0.7.5;
13 
14 
15 interface IERC20 {
16   /**
17    * @dev Returns the amount of tokens in existence.
18    */
19   function totalSupply() external view returns (uint256);
20 
21   /**
22    * @dev Returns the amount of tokens owned by `account`.
23    */
24   function balanceOf(address account) external view returns (uint256);
25 
26   /**
27    * @dev Moves `amount` tokens from the caller's account to `recipient`.
28    *
29    * Returns a boolean value indicating whether the operation succeeded.
30    *
31    * Emits a {Transfer} event.
32    */
33   function transfer(address recipient, uint256 amount) external returns (bool);
34 
35   /**
36    * @dev Returns the remaining number of tokens that `spender` will be
37    * allowed to spend on behalf of `owner` through {transferFrom}. This is
38    * zero by default.
39    *
40    * This value changes when {approve} or {transferFrom} are called.
41    */
42   function allowance(address owner, address spender) external view returns (uint256);
43 
44   /**
45    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46    *
47    * Returns a boolean value indicating whether the operation succeeded.
48    *
49    * IMPORTANT: Beware that changing an allowance with this method brings the risk
50    * that someone may use both the old and the new allowance by unfortunate
51    * transaction ordering. One possible solution to mitigate this race
52    * condition is to first reduce the spender's allowance to 0 and set the
53    * desired value afterwards:
54    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55    *
56    * Emits an {Approval} event.
57    */
58   function approve(address spender, uint256 amount) external returns (bool);
59 
60   /**
61    * @dev Moves `amount` tokens from `sender` to `recipient` using the
62    * allowance mechanism. `amount` is then deducted from the caller's
63    * allowance.
64    *
65    * Returns a boolean value indicating whether the operation succeeded.
66    *
67    * Emits a {Transfer} event.
68    */
69   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
70 
71   /**
72    * @dev Emitted when `value` tokens are moved from one account (`from`) to
73    * another (`to`).
74    *
75    * Note that `value` may be zero.
76    */
77   event Transfer(address indexed from, address indexed to, uint256 value);
78 
79   /**
80    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81    * a call to {approve}. `value` is the new allowance.
82    */
83   event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 
87 interface IUniswapV2Router01 {
88     function factory() external pure returns (address);
89     function WETH() external pure returns (address);
90 
91     function addLiquidity(
92         address tokenA,
93         address tokenB,
94         uint amountADesired,
95         uint amountBDesired,
96         uint amountAMin,
97         uint amountBMin,
98         address to,
99         uint deadline
100     ) external returns (uint amountA, uint amountB, uint liquidity);
101     function addLiquidityETH(
102         address token,
103         uint amountTokenDesired,
104         uint amountTokenMin,
105         uint amountETHMin,
106         address to,
107         uint deadline
108     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
109     function removeLiquidity(
110         address tokenA,
111         address tokenB,
112         uint liquidity,
113         uint amountAMin,
114         uint amountBMin,
115         address to,
116         uint deadline
117     ) external returns (uint amountA, uint amountB);
118     function removeLiquidityETH(
119         address token,
120         uint liquidity,
121         uint amountTokenMin,
122         uint amountETHMin,
123         address to,
124         uint deadline
125     ) external returns (uint amountToken, uint amountETH);
126     function removeLiquidityWithPermit(
127         address tokenA,
128         address tokenB,
129         uint liquidity,
130         uint amountAMin,
131         uint amountBMin,
132         address to,
133         uint deadline,
134         bool approveMax, uint8 v, bytes32 r, bytes32 s
135     ) external returns (uint amountA, uint amountB);
136     function removeLiquidityETHWithPermit(
137         address token,
138         uint liquidity,
139         uint amountTokenMin,
140         uint amountETHMin,
141         address to,
142         uint deadline,
143         bool approveMax, uint8 v, bytes32 r, bytes32 s
144     ) external returns (uint amountToken, uint amountETH);
145     function swapExactTokensForTokens(
146         uint amountIn,
147         uint amountOutMin,
148         address[] calldata path,
149         address to,
150         uint deadline
151     ) external returns (uint[] memory amounts);
152     function swapTokensForExactTokens(
153         uint amountOut,
154         uint amountInMax,
155         address[] calldata path,
156         address to,
157         uint deadline
158     ) external returns (uint[] memory amounts);
159     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
160         external
161         payable
162         returns (uint[] memory amounts);
163     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
164         external
165         returns (uint[] memory amounts);
166     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
167         external
168         returns (uint[] memory amounts);
169     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
170         external
171         payable
172         returns (uint[] memory amounts);
173 
174     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
175     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
176     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
177     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
178     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
179 }
180 
181 
182 interface IUniswapV2Router02 is IUniswapV2Router01 {
183     function removeLiquidityETHSupportingFeeOnTransferTokens(
184         address token,
185         uint liquidity,
186         uint amountTokenMin,
187         uint amountETHMin,
188         address to,
189         uint deadline
190     ) external returns (uint amountETH);
191     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
192         address token,
193         uint liquidity,
194         uint amountTokenMin,
195         uint amountETHMin,
196         address to,
197         uint deadline,
198         bool approveMax, uint8 v, bytes32 r, bytes32 s
199     ) external returns (uint amountETH);
200 
201     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
202         uint amountIn,
203         uint amountOutMin,
204         address[] calldata path,
205         address to,
206         uint deadline
207     ) external;
208     function swapExactETHForTokensSupportingFeeOnTransferTokens(
209         uint amountOutMin,
210         address[] calldata path,
211         address to,
212         uint deadline
213     ) external payable;
214     function swapExactTokensForETHSupportingFeeOnTransferTokens(
215         uint amountIn,
216         uint amountOutMin,
217         address[] calldata path,
218         address to,
219         uint deadline
220     ) external;
221 }
222 
223 
224 interface IUniswapV2Pair {
225     event Approval(address indexed owner, address indexed spender, uint value);
226     event Transfer(address indexed from, address indexed to, uint value);
227 
228     function name() external pure returns (string memory);
229     function symbol() external pure returns (string memory);
230     function decimals() external pure returns (uint8);
231     function totalSupply() external view returns (uint);
232     function balanceOf(address owner) external view returns (uint);
233     function allowance(address owner, address spender) external view returns (uint);
234 
235     function approve(address spender, uint value) external returns (bool);
236     function transfer(address to, uint value) external returns (bool);
237     function transferFrom(address from, address to, uint value) external returns (bool);
238 
239     function DOMAIN_SEPARATOR() external view returns (bytes32);
240     function PERMIT_TYPEHASH() external pure returns (bytes32);
241     function nonces(address owner) external view returns (uint);
242 
243     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
244 
245     event Mint(address indexed sender, uint amount0, uint amount1);
246     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
247     event Swap(
248         address indexed sender,
249         uint amount0In,
250         uint amount1In,
251         uint amount0Out,
252         uint amount1Out,
253         address indexed to
254     );
255     event Sync(uint112 reserve0, uint112 reserve1);
256 
257     function MINIMUM_LIQUIDITY() external pure returns (uint);
258     function factory() external view returns (address);
259     function token0() external view returns (address);
260     function token1() external view returns (address);
261     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
262     function price0CumulativeLast() external view returns (uint);
263     function price1CumulativeLast() external view returns (uint);
264     function kLast() external view returns (uint);
265 
266     function mint(address to) external returns (uint liquidity);
267     function burn(address to) external returns (uint amount0, uint amount1);
268     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
269     function skim(address to) external;
270     function sync() external;
271 
272     function initialize(address, address) external;
273 }
274 
275 interface IUniswapV2Factory {
276     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
277 
278     function feeTo() external view returns (address);
279     function feeToSetter() external view returns (address);
280 
281     function getPair(address tokenA, address tokenB) external view returns (address pair);
282     function allPairs(uint) external view returns (address pair);
283     function allPairsLength() external view returns (uint);
284 
285     function createPair(address tokenA, address tokenB) external returns (address pair);
286 
287     function setFeeTo(address) external;
288     function setFeeToSetter(address) external;
289 }
290 
291 library SafeMath {
292 
293     function add(uint256 a, uint256 b) internal pure returns (uint256) {
294         uint256 c = a + b;
295         require(c >= a, "SafeMath: addition overflow");
296 
297         return c;
298     }
299 
300     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
301         return sub(a, b, "SafeMath: subtraction overflow");
302     }
303 
304     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
305         require(b <= a, errorMessage);
306         uint256 c = a - b;
307 
308         return c;
309     }
310 
311     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
312         if (a == 0) {
313             return 0;
314         }
315 
316         uint256 c = a * b;
317         require(c / a == b, "SafeMath: multiplication overflow");
318 
319         return c;
320     }
321 
322     function div(uint256 a, uint256 b) internal pure returns (uint256) {
323         return div(a, b, "SafeMath: division by zero");
324     }
325 
326     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
327         require(b > 0, errorMessage);
328         uint256 c = a / b;
329         assert(a == b * c + a % b); // There is no case in which this doesn't hold
330 
331         return c;
332     }
333 
334     // Only used in the  BondingCalculator.sol
335     function sqrrt(uint256 a) internal pure returns (uint c) {
336         if (a > 3) {
337             c = a;
338             uint b = add( div( a, 2), 1 );
339             while (b < c) {
340                 c = b;
341                 b = div( add( div( a, b ), b), 2 );
342             }
343         } else if (a != 0) {
344             c = 1;
345         }
346     }
347 
348 }
349 
350 library SafeMathInt {
351     int256 private constant MIN_INT256 = int256(1) << 255;
352     int256 private constant MAX_INT256 = ~(int256(1) << 255);
353 
354     /**
355      * @dev Multiplies two int256 variables and fails on overflow.
356      */
357     function mul(int256 a, int256 b) internal pure returns (int256) {
358         int256 c = a * b;
359 
360         // Detect overflow when multiplying MIN_INT256 with -1
361         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
362         require((b == 0) || (c / b == a));
363         return c;
364     }
365 
366     /**
367      * @dev Division of two int256 variables and fails on overflow.
368      */
369     function div(int256 a, int256 b) internal pure returns (int256) {
370         // Prevent overflow when dividing MIN_INT256 by -1
371         require(b != -1 || a != MIN_INT256);
372 
373         // Solidity already throws when dividing by 0.
374         return a / b;
375     }
376 
377     /**
378      * @dev Subtracts two int256 variables and fails on overflow.
379      */
380     function sub(int256 a, int256 b) internal pure returns (int256) {
381         int256 c = a - b;
382         require((b >= 0 && c <= a) || (b < 0 && c > a));
383         return c;
384     }
385 
386     /**
387      * @dev Adds two int256 variables and fails on overflow.
388      */
389     function add(int256 a, int256 b) internal pure returns (int256) {
390         int256 c = a + b;
391         require((b >= 0 && c >= a) || (b < 0 && c < a));
392         return c;
393     }
394 
395     /**
396      * @dev Converts to absolute value, and fails on overflow.
397      */
398     function abs(int256 a) internal pure returns (int256) {
399         require(a != MIN_INT256);
400         return a < 0 ? -a : a;
401     }
402 
403 
404     function toUint256Safe(int256 a) internal pure returns (uint256) {
405         require(a >= 0);
406         return uint256(a);
407     }
408 }
409 
410 library SafeMathUint {
411   function toInt256Safe(uint256 a) internal pure returns (int256) {
412     int256 b = int256(a);
413     require(b >= 0);
414     return b;
415   }
416 }
417 
418 library Counters {
419     using SafeMath for uint256;
420 
421     struct Counter {
422         // This variable should never be directly accessed by users of the library: interactions must be restricted to
423         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
424         // this feature: see https://github.com/ethereum/solidity/issues/4637
425         uint256 _value; // default: 0
426     }
427 
428     function current(Counter storage counter) internal view returns (uint256) {
429         return counter._value;
430     }
431 
432     function increment(Counter storage counter) internal {
433         // The {SafeMath} overflow check can be skipped here, see the comment at the top
434         counter._value += 1;
435     }
436 
437     function decrement(Counter storage counter) internal {
438         counter._value = counter._value.sub(1);
439     }
440 }
441 
442 abstract contract Context {
443     function _msgSender() internal view virtual returns (address) {
444         return msg.sender;
445     }
446 
447     function _msgData() internal view virtual returns (bytes calldata) {
448         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
449         return msg.data;
450     }
451 }
452 
453 pragma solidity >=0.7.5;
454 
455 contract Ownable is Context {
456     address private _owner;
457 
458     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
459     
460     /**
461      * @dev Initializes the contract setting the deployer as the initial owner.
462      */
463     constructor () {
464         address msgSender = _msgSender();
465         _owner = msgSender;
466         emit OwnershipTransferred(address(0), msgSender);
467     }
468 
469     /**
470      * @dev Returns the address of the current owner.
471      */
472     function owner() public view returns (address) {
473         return _owner;
474     }
475 
476     /**
477      * @dev Throws if called by any account other than the owner.
478      */
479     modifier onlyOwner() {
480         require(_owner == _msgSender(), "Ownable: caller is not the owner");
481         _;
482     }
483 
484     /**
485      * @dev Leaves the contract without owner. It will not be possible to call
486      * `onlyOwner` functions anymore. Can only be called by the current owner.
487      *
488      * NOTE: Renouncing ownership will leave the contract without an owner,
489      * thereby removing any functionality that is only available to the owner.
490      */
491     function renounceOwnership() public virtual onlyOwner {
492         emit OwnershipTransferred(_owner, address(0));
493         _owner = address(0);
494     }
495 
496     /**
497      * @dev Transfers ownership of the contract to a new account (`newOwner`).
498      * Can only be called by the current owner.
499      */
500     function transferOwnership(address newOwner) public virtual onlyOwner {
501         require(newOwner != address(0), "Ownable: new owner is the zero address");
502         emit OwnershipTransferred(_owner, newOwner);
503         _owner = newOwner;
504     }
505 }
506 
507 abstract contract ERC20 is Context, IERC20{
508 
509     using SafeMath for uint256;
510 
511     // TODO comment actual hash value.
512     bytes32 constant private ERC20TOKEN_ERC1820_INTERFACE_ID = keccak256( "ERC20Token" );
513     
514     mapping (address => uint256) internal _balances;
515 
516     mapping (address => mapping (address => uint256)) internal _allowances;
517 
518     uint256 internal _totalSupply;
519 
520     string internal _name;
521     
522     string internal _symbol;
523     
524     uint8 internal immutable _decimals;
525 
526     constructor (string memory name_, string memory symbol_, uint8 decimals_) {
527         _name = name_;
528         _symbol = symbol_;
529         _decimals = decimals_;
530     }
531 
532     function name() public view returns (string memory) {
533         return _name;
534     }
535 
536     function symbol() public view returns (string memory) {
537         return _symbol;
538     }
539 
540     function decimals() public view virtual returns (uint8) {
541         return _decimals;
542     }
543 
544     function totalSupply() public view override returns (uint256) {
545         return _totalSupply;
546     }
547 
548     function balanceOf(address account) public view virtual override returns (uint256) {
549         return _balances[account];
550     }
551 
552     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
553         _transfer(msg.sender, recipient, amount);
554         return true;
555     }
556 
557     function allowance(address owner, address spender) public view virtual override returns (uint256) {
558         return _allowances[owner][spender];
559     }
560 
561     function approve(address spender, uint256 amount) public virtual override returns (bool) {
562         _approve(msg.sender, spender, amount);
563         return true;
564     }
565 
566     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
567         _transfer(sender, recipient, amount);
568         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
569         return true;
570     }
571 
572     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
573         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
574         return true;
575     }
576 
577     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
578         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
579         return true;
580     }
581 
582     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
583         require(sender != address(0), "ERC20: transfer from the zero address");
584         require(recipient != address(0), "ERC20: transfer to the zero address");
585 
586         _beforeTokenTransfer(sender, recipient, amount);
587 
588         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
589         _balances[recipient] = _balances[recipient].add(amount);
590         emit Transfer(sender, recipient, amount);
591     }
592 
593     function _mint(address account, uint256 amount) internal virtual {
594         require(account != address(0), "ERC20: mint to the zero address");
595         _beforeTokenTransfer(address(0), account, amount);
596         _totalSupply = _totalSupply.add(amount);
597         _balances[account] = _balances[account].add(amount);
598         emit Transfer(address(0), account, amount);
599     }
600 
601     function _burn(address account, uint256 amount) internal virtual {
602         require(account != address(0), "ERC20: burn from the zero address");
603 
604         _beforeTokenTransfer(account, address(0), amount);
605 
606         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
607         _totalSupply = _totalSupply.sub(amount);
608         emit Transfer(account, address(0), amount);
609     }
610 
611     function _approve(address owner, address spender, uint256 amount) internal virtual {
612         require(owner != address(0), "ERC20: approve from the zero address");
613         require(spender != address(0), "ERC20: approve to the zero address");
614 
615         _allowances[owner][spender] = amount;
616         emit Approval(owner, spender, amount);
617     }
618 
619   function _beforeTokenTransfer( address from_, address to_, uint256 amount_ ) internal virtual { }
620 }
621 
622 
623 
624 contract HelERC20Token is ERC20, Ownable {
625     using SafeMath for uint256;
626 
627     IUniswapV2Router02 public uniswapV2Router;
628     address public uniswapV2Pair;
629     address public constant deadAddress = address(0xdead);
630 
631     bool public tradingActive = false;
632     uint256 public enableBlock = 0;
633 
634     bool public superPower = true;
635     bool public limitsInEffect = true;
636     // Anti-bot and anti-whale mappings and variables
637     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
638     bool public transferDelayEnabled = true;
639     bool public contractInteractionEnabled = false;
640      // exlcude from max transaction amount
641     mapping (address => bool) public _isExcludedMaxTransactionAmount;
642 
643     uint256 public maxTransactionAmount;
644     uint256 public maxWallet;
645     uint256 public initialSupply;
646     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
647     // could be subject to a maximum transfer amount
648     mapping (address => bool) public automatedMarketMakerPairs;
649     mapping (address => bool) public earlyBotBuyers;
650 
651     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
652 
653     event ExcludeFromFees(address indexed account, bool isExcluded);
654 
655     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
656     
657     constructor() 
658     ERC20("HEL Games", "Hel", 9)
659     {
660 
661         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
662         uniswapV2Router = _uniswapV2Router;
663         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
664         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
665 
666         initialSupply = 100000000*1e9;
667         maxTransactionAmount = initialSupply * 45 / 10000; // 0.45% maxTransactionAmountTxn
668         maxWallet = initialSupply * 1 / 100; // 1% maxWallet
669         _mint(owner(), initialSupply);
670         excludeFromMaxTransaction(owner(), true);
671         excludeFromMaxTransaction(address(this), true);
672         excludeFromMaxTransaction(deadAddress, true);
673     }
674 
675     receive() external payable {
676 
677   	}
678 
679     function removeSuperPower() external onlyOwner returns (bool){
680         superPower = false;
681         return true;
682     }
683 
684     // remove limits after token is stable, can only be re-enabled if you have superpowers
685     function removeLimits() external onlyOwner returns (bool){
686         limitsInEffect = false;
687         return true;
688     }
689     
690     function addLimits() external onlyOwner returns (bool){
691         require(superPower, "You gave up your SuperPowers. Sadge!");
692         limitsInEffect = true;
693         return true;
694     }
695 
696     // disable Transfer delay - cannot be re-enabled
697     function disableTransferDelay() external onlyOwner returns (bool){
698         transferDelayEnabled = false;
699         return true;
700     }
701 
702     function toggleContractInteractionEnabled() external onlyOwner returns (bool){
703         contractInteractionEnabled  = !contractInteractionEnabled;
704         return true;
705     }
706 
707     // Launch :p
708     function init() external onlyOwner {
709         require(!tradingActive, "Trading is already active");
710         require(enableBlock == 0, "Trading has already been enabled");
711         tradingActive = true;
712         enableBlock = block.number;
713     }
714 
715     function setEarlyBotBuyers(address _add, bool _isTrue) external onlyOwner{
716     	if (_isTrue){
717 	    	// Can only add manually if you have superpowers (initailly)
718             require(superPower, "You gave up your SuperPowers. Sadge!");
719 
720 	}
721         earlyBotBuyers[_add] = _isTrue;
722     }
723 
724     function pauseTrading() external onlyOwner {
725         tradingActive = false;
726     }
727 
728     function resumeTrading() external onlyOwner {
729         tradingActive = true;
730     }
731 
732     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
733         require(newNum >= (totalSupply() * 1 / 1000)/1e9, "Cannot set maxTransactionAmount lower than 0.1%");
734         maxTransactionAmount = newNum * (10**9);
735     }
736 
737     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
738         require(newNum >= (totalSupply() * 5 / 1000)/1e9, "Cannot set maxWallet lower than 0.5%");
739         maxWallet = newNum * (10**9);
740     }
741 
742     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
743         _isExcludedMaxTransactionAmount[updAds] = isEx;
744     }
745 
746 
747     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
748         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
749 
750         _setAutomatedMarketMakerPair(pair, value);
751     }
752 
753     function _setAutomatedMarketMakerPair(address pair, bool value) private {
754         automatedMarketMakerPairs[pair] = value;
755 
756         emit SetAutomatedMarketMakerPair(pair, value);
757     }
758 
759     function isContract(address _addr) private view returns (bool){
760         uint32 size;
761         assembly {
762             size := extcodesize(_addr)
763         }
764         return (size > 0);
765     }
766 
767     function _transfer(
768         address from,
769         address to,
770         uint256 amount
771     ) internal override {
772         require(from != address(0), "ERC20: transfer from the zero address");
773         require(to != address(0), "ERC20: transfer to the zero address");
774         if (!_isExcludedMaxTransactionAmount[from] && !contractInteractionEnabled){
775             require(!isContract(tx.origin), "Contract Interactions are disabled!");
776         }
777 
778         if(amount == 0) {
779             super._transfer(from, to, 0);
780             return;
781         }
782         // check if blacklisted
783         if (earlyBotBuyers[from] || earlyBotBuyers[to]){
784             super._transfer(from, to, 0);
785             return;
786         }
787 
788         if(limitsInEffect){
789             if (
790                 from != owner() &&
791                 to != owner() &&
792                 to != address(0) &&
793                 to != address(0xdead)
794             ){
795                
796                if(!tradingActive){	
797                     require(_isExcludedMaxTransactionAmount[from] || _isExcludedMaxTransactionAmount[to], "Trading is not active.");	
798                 }	
799 
800                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
801                 if (!(_isExcludedMaxTransactionAmount[from] || _isExcludedMaxTransactionAmount[to])){
802                     if (transferDelayEnabled){
803                         if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
804                             require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
805                             _holderLastTransferTimestamp[tx.origin] = block.number;
806                         }
807                     }
808                 }
809 
810                 //when buy
811                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
812                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
813                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
814                 }
815 
816                 //when sell
817                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
818                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
819                 }
820                 else if(!_isExcludedMaxTransactionAmount[to]){
821                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
822                 }
823                 // Add to earlyBuyerlist for launch
824                 if (automatedMarketMakerPairs[from] && enableBlock != 0 && block.number <= enableBlock){
825                     earlyBotBuyers[to] = true;
826                 }
827             }
828         }
829         super._transfer(from, to, amount);
830     }
831 
832 
833     function withdrawEthPool() external onlyOwner {
834         bool success;
835         (success,) = address(msg.sender).call{value: address(this).balance}("");
836     }
837 
838 
839     function emergenceRescueToken(address token) public onlyOwner{
840         IERC20(token).transfer(owner(), IERC20(token).balanceOf(address(this)));
841     }
842 
843 }
844 
845 // Designed and Deployed by @crypt0xa
846 // For more info, check out https://xa0.dev
847 // DISCLAIMER: I love building stuff. I am not and will not be accountable for anything anyone does with this code. 
848 // Crypto is a high-risk investment by definition. Always DYOR and ape what you can afford to lose.
849 // XA :)