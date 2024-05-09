1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.17;
4 
5 abstract contract Context {
6 
7     function _msgSender() internal view virtual returns (address payable) {
8         return payable(msg.sender);
9     }
10 
11     function _msgData() internal view virtual returns (bytes memory) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address to, uint256 amount) external returns (bool);
23     function allowance(address owner, address spender) external view returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(
26         address from,
27         address to,
28         uint256 amount
29     ) external returns (bool);
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 interface IERC20Metadata is IERC20 {
36     function name() external view returns (string memory);
37     function symbol() external view returns (string memory);
38     function decimals() external view returns (uint8);
39 }
40 
41 contract ERC20 is Context, IERC20, IERC20Metadata {
42     mapping(address => uint256) private _balances;
43 
44     mapping(address => mapping(address => uint256)) private _allowances;
45 
46     uint256 private _totalSupply;
47 
48     string private _name;
49     string private _symbol;
50 
51     constructor(string memory name_, string memory symbol_) {
52         _name = name_;
53         _symbol = symbol_;
54     }
55 
56     function name() public view virtual override returns (string memory) {
57         return _name;
58     }
59 
60     function symbol() public view virtual override returns (string memory) {
61         return _symbol;
62     }
63 
64     function decimals() public view virtual override returns (uint8) {
65         return 18;
66     }
67 
68     function totalSupply() public view virtual override returns (uint256) {
69         return _totalSupply;
70     }
71 
72     function balanceOf(address account) public view virtual override returns (uint256) {
73         return _balances[account];
74     }
75 
76     function transfer(address to, uint256 amount) public virtual override returns (bool) {
77         address owner = _msgSender();
78         _transfer(owner, to, amount);
79         return true;
80     }
81 
82     function allowance(address owner, address spender) public view virtual override returns (uint256) {
83         return _allowances[owner][spender];
84     }
85 
86     function approve(address spender, uint256 amount) public virtual override returns (bool) {
87         address owner = _msgSender();
88         _approve(owner, spender, amount);
89         return true;
90     }
91 
92     function transferFrom(
93         address from,
94         address to,
95         uint256 amount
96     ) public virtual override returns (bool) {
97         address spender = _msgSender();
98         _spendAllowance(from, spender, amount);
99         _transfer(from, to, amount);
100         return true;
101     }
102 
103     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
104         address owner = _msgSender();
105         _approve(owner, spender, _allowances[owner][spender] + addedValue);
106         return true;
107     }
108 
109     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
110         address owner = _msgSender();
111         uint256 currentAllowance = _allowances[owner][spender];
112         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
113         unchecked {
114             _approve(owner, spender, currentAllowance - subtractedValue);
115         }
116 
117         return true;
118     }
119 
120     function _transfer(
121         address from,
122         address to,
123         uint256 amount
124     ) internal virtual {
125         require(from != address(0), "ERC20: transfer from the zero address");
126         require(to != address(0), "ERC20: transfer to the zero address");
127 
128         _beforeTokenTransfer(from, to, amount);
129 
130         uint256 fromBalance = _balances[from];
131         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
132         unchecked {
133             _balances[from] = fromBalance - amount;
134         }
135         _balances[to] += amount;
136 
137         emit Transfer(from, to, amount);
138 
139         _afterTokenTransfer(from, to, amount);
140     }
141 
142     function _mint(address account, uint256 amount) internal virtual {
143         require(account != address(0), "ERC20: mint to the zero address");
144 
145         _beforeTokenTransfer(address(0), account, amount);
146 
147         _totalSupply += amount;
148         _balances[account] += amount;
149         emit Transfer(address(0), account, amount);
150 
151         _afterTokenTransfer(address(0), account, amount);
152     }
153 
154     function _burn(address account, uint256 amount) internal virtual {
155         require(account != address(0), "ERC20: burn from the zero address");
156 
157         _beforeTokenTransfer(account, address(0), amount);
158 
159         uint256 accountBalance = _balances[account];
160         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
161         unchecked {
162             _balances[account] = accountBalance - amount;
163         }
164         _totalSupply -= amount;
165 
166         emit Transfer(account, address(0), amount);
167 
168         _afterTokenTransfer(account, address(0), amount);
169     }
170 
171     function _approve(
172         address owner,
173         address spender,
174         uint256 amount
175     ) internal virtual {
176         require(owner != address(0), "ERC20: approve from the zero address");
177         require(spender != address(0), "ERC20: approve to the zero address");
178 
179         _allowances[owner][spender] = amount;
180         emit Approval(owner, spender, amount);
181     }
182 
183     function _spendAllowance(
184         address owner,
185         address spender,
186         uint256 amount
187     ) internal virtual {
188         uint256 currentAllowance = allowance(owner, spender);
189         if (currentAllowance != type(uint256).max) {
190             require(currentAllowance >= amount, "ERC20: insufficient allowance");
191             unchecked {
192                 _approve(owner, spender, currentAllowance - amount);
193             }
194         }
195     }
196 
197     function _beforeTokenTransfer(
198         address from,
199         address to,
200         uint256 amount
201     ) internal virtual {}
202 
203     function _afterTokenTransfer(
204         address from,
205         address to,
206         uint256 amount
207     ) internal virtual {}
208 }
209 
210 interface IUniswapV2Factory {
211     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
212 
213     function feeTo() external view returns (address);
214     function feeToSetter() external view returns (address);
215 
216     function getPair(address tokenA, address tokenB) external view returns (address pair);
217     function allPairs(uint) external view returns (address pair);
218     function allPairsLength() external view returns (uint);
219 
220     function createPair(address tokenA, address tokenB) external returns (address pair);
221 
222     function setFeeTo(address) external;
223     function setFeeToSetter(address) external;
224 }
225 
226 interface IUniswapV2Pair {
227     event Approval(address indexed owner, address indexed spender, uint value);
228     event Transfer(address indexed from, address indexed to, uint value);
229 
230     function name() external pure returns (string memory);
231     function symbol() external pure returns (string memory);
232     function decimals() external pure returns (uint8);
233     function totalSupply() external view returns (uint);
234     function balanceOf(address owner) external view returns (uint);
235     function allowance(address owner, address spender) external view returns (uint);
236 
237     function approve(address spender, uint value) external returns (bool);
238     function transfer(address to, uint value) external returns (bool);
239     function transferFrom(address from, address to, uint value) external returns (bool);
240 
241     function DOMAIN_SEPARATOR() external view returns (bytes32);
242     function PERMIT_TYPEHASH() external pure returns (bytes32);
243     function nonces(address owner) external view returns (uint);
244 
245     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
246 
247     event Mint(address indexed from, uint amount0, uint amount1);
248     event Burn(address indexed from, uint amount0, uint amount1, address indexed to);
249     event Swap(
250         address indexed from,
251         uint amount0In,
252         uint amount1In,
253         uint amount0Out,
254         uint amount1Out,
255         address indexed to
256     );
257     event Sync(uint112 reserve0, uint112 reserve1);
258 
259     function MINIMUM_LIQUIDITY() external pure returns (uint);
260     function factory() external view returns (address);
261     function token0() external view returns (address);
262     function token1() external view returns (address);
263     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
264     function price0CumulativeLast() external view returns (uint);
265     function price1CumulativeLast() external view returns (uint);
266     function kLast() external view returns (uint);
267 
268     function mint(address to) external returns (uint liquidity);
269     function burn(address to) external returns (uint amount0, uint amount1);
270     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
271     function skim(address to) external;
272     function sync() external;
273 
274     function initialize(address, address) external;
275 }
276 
277 interface IUniswapV2Router01 {
278     function factory() external pure returns (address);
279     function WETH() external pure returns (address);
280 
281     function addLiquidity(
282         address tokenA,
283         address tokenB,
284         uint amountADesired,
285         uint amountBDesired,
286         uint amountAMin,
287         uint amountBMin,
288         address to,
289         uint deadline
290     ) external returns (uint amountA, uint amountB, uint liquidity);
291     function addLiquidityETH(
292         address token,
293         uint amountTokenDesired,
294         uint amountTokenMin,
295         uint amountETHMin,
296         address to,
297         uint deadline
298     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
299     function removeLiquidity(
300         address tokenA,
301         address tokenB,
302         uint liquidity,
303         uint amountAMin,
304         uint amountBMin,
305         address to,
306         uint deadline
307     ) external returns (uint amountA, uint amountB);
308     function removeLiquidityETH(
309         address token,
310         uint liquidity,
311         uint amountTokenMin,
312         uint amountETHMin,
313         address to,
314         uint deadline
315     ) external returns (uint amountToken, uint amountETH);
316     function removeLiquidityWithPermit(
317         address tokenA,
318         address tokenB,
319         uint liquidity,
320         uint amountAMin,
321         uint amountBMin,
322         address to,
323         uint deadline,
324         bool approveMax, uint8 v, bytes32 r, bytes32 s
325     ) external returns (uint amountA, uint amountB);
326     function removeLiquidityETHWithPermit(
327         address token,
328         uint liquidity,
329         uint amountTokenMin,
330         uint amountETHMin,
331         address to,
332         uint deadline,
333         bool approveMax, uint8 v, bytes32 r, bytes32 s
334     ) external returns (uint amountToken, uint amountETH);
335     function swapExactTokensForTokens(
336         uint amountIn,
337         uint amountOutMin,
338         address[] calldata path,
339         address to,
340         uint deadline
341     ) external returns (uint[] memory amounts);
342     function swapTokensForExactTokens(
343         uint amountOut,
344         uint amountInMax,
345         address[] calldata path,
346         address to,
347         uint deadline
348     ) external returns (uint[] memory amounts);
349     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
350         external
351         payable
352         returns (uint[] memory amounts);
353     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
354         external
355         returns (uint[] memory amounts);
356     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
357         external
358         returns (uint[] memory amounts);
359     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
360         external
361         payable
362         returns (uint[] memory amounts);
363 
364     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
365     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
366     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
367     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
368     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
369 }
370 
371 interface IUniswapV2Router02 is IUniswapV2Router01 {
372     function removeLiquidityETHSupportingFeeOnTransferTokens(
373         address token,
374         uint liquidity,
375         uint amountTokenMin,
376         uint amountETHMin,
377         address to,
378         uint deadline
379     ) external returns (uint amountETH);
380     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
381         address token,
382         uint liquidity,
383         uint amountTokenMin,
384         uint amountETHMin,
385         address to,
386         uint deadline,
387         bool approveMax, uint8 v, bytes32 r, bytes32 s
388     ) external returns (uint amountETH);
389 
390     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
391         uint amountIn,
392         uint amountOutMin,
393         address[] calldata path,
394         address to,
395         uint deadline
396     ) external;
397     function swapExactETHForTokensSupportingFeeOnTransferTokens(
398         uint amountOutMin,
399         address[] calldata path,
400         address to,
401         uint deadline
402     ) external payable;
403     function swapExactTokensForETHSupportingFeeOnTransferTokens(
404         uint amountIn,
405         uint amountOutMin,
406         address[] calldata path,
407         address to,
408         uint deadline
409     ) external;
410 }
411 
412 abstract contract Ownable is Context {
413     address private _owner;
414 
415     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
416 
417     constructor() {
418         _transferOwnership(_msgSender());
419     }
420 
421     function owner() public view virtual returns (address) {
422         return _owner;
423     }
424 
425     modifier onlyOwner() {
426         require(owner() == _msgSender(), "Ownable: caller is not the owner");
427         _;
428     }
429 
430     function renounceOwnership() public virtual onlyOwner {
431         _transferOwnership(address(0));
432     }
433 
434     function transferOwnership(address newOwner) public virtual onlyOwner {
435         require(newOwner != address(0), "Ownable: new owner is the zero address");
436         _transferOwnership(newOwner);
437     }
438 
439     function _transferOwnership(address newOwner) internal virtual {
440         address oldOwner = _owner;
441         _owner = newOwner;
442         emit OwnershipTransferred(oldOwner, newOwner);
443     }
444 }
445 
446 library SafeMath {
447     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
448         unchecked {
449             uint256 c = a + b;
450             if (c < a) return (false, 0);
451             return (true, c);
452         }
453     }
454 
455     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
456         unchecked {
457             if (b > a) return (false, 0);
458             return (true, a - b);
459         }
460     }
461 
462     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
463         unchecked {
464             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
465             // benefit is lost if 'b' is also tested.
466             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
467             if (a == 0) return (true, 0);
468             uint256 c = a * b;
469             if (c / a != b) return (false, 0);
470             return (true, c);
471         }
472     }
473 
474     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
475         unchecked {
476             if (b == 0) return (false, 0);
477             return (true, a / b);
478         }
479     }
480 
481     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
482         unchecked {
483             if (b == 0) return (false, 0);
484             return (true, a % b);
485         }
486     }
487 
488     function add(uint256 a, uint256 b) internal pure returns (uint256) {
489         return a + b;
490     }
491 
492     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
493         return a - b;
494     }
495 
496     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
497         return a * b;
498     }
499 
500     function div(uint256 a, uint256 b) internal pure returns (uint256) {
501         return a / b;
502     }
503 
504     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
505         return a % b;
506     }
507 
508     function sub(
509         uint256 a,
510         uint256 b,
511         string memory errorMessage
512     ) internal pure returns (uint256) {
513         unchecked {
514             require(b <= a, errorMessage);
515             return a - b;
516         }
517     }
518 
519     function div(
520         uint256 a,
521         uint256 b,
522         string memory errorMessage
523     ) internal pure returns (uint256) {
524         unchecked {
525             require(b > 0, errorMessage);
526             return a / b;
527         }
528     }
529 
530     function mod(
531         uint256 a,
532         uint256 b,
533         string memory errorMessage
534     ) internal pure returns (uint256) {
535         unchecked {
536             require(b > 0, errorMessage);
537             return a % b;
538         }
539     }
540 }
541 
542 contract ETree is ERC20, Ownable {
543     using SafeMath for uint256;
544 
545     uint256 public maxSupply; 
546 
547     IUniswapV2Router02 public uniswapV2Router;
548     address public uniswapV2Pair;
549 
550     bool private _swapping;
551 
552     address private _swapFeeReceiver;
553     
554     uint256 public maxTransactionAmount;
555     uint256 public maxWallet;
556     uint256 public swapTokensThreshold;
557         
558     address public original;
559     uint256 public startingTime = 0;
560     
561     mapping (address => bool) isTxLimitExempt;
562     mapping (address => bool) public isBot;
563     mapping (address => bool) public isExcludedFromCut;
564 
565     uint256 public blockN = 1;
566     bool public limitsInEffect = true;
567     bool public tradingOpen=false;
568 
569     uint256 public totalFees;
570     uint256 private _marketingFee;
571     uint256 private _liquidityFee;
572     uint256 private _NodeFee;
573     
574     uint256 private _tokensForMarketing;
575     uint256 private _tokensForLiquidity;
576     uint256 private _tokensForNode;
577     
578     // staking vars
579     uint256 public totalStaked;
580     address public stakingToken;
581     address public rewardToken;
582     uint256 public apr;
583 
584     bool public stakingEnabled = false;
585     uint256 public totalClaimed;
586 
587     struct Node {
588         uint256 creationTime;
589         uint256 staked;
590     }
591 
592     struct Staker {
593         address staker;
594         uint256 start;
595         uint256 staked;
596         uint256 earned;
597     }
598 
599     struct ClaimHistory {
600         uint256[] dates;
601         uint256[] amounts;
602     }
603 
604     // exlcude from fees and max transaction amount
605     mapping (address => bool) private _isExcludedFromFees;
606     mapping (address => bool) private _isExcludedMaxTransactionAmount;
607 
608     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
609     // could be subject to a maximum transfer amount
610     mapping (address => bool) private _automatedMarketMakerPairs;
611 
612     // to stop bot spam buys and sells on launch
613     mapping(address => uint256) private _holderLastTransferBlock;
614 
615     // stake data
616     mapping(address => mapping(uint256 => Staker)) private _stakers;
617     mapping(address => ClaimHistory) private _claimHistory;
618     Node[] public nodes;
619 
620     /**
621      * @dev Throws if called by any account other than the _swapFeeReceiver
622      */
623     modifier onlyDevOrOwner() {
624         require(_swapFeeReceiver == _msgSender() || owner() == _msgSender(), "Caller is not the _swapFeeReceiver address nor owner.");
625         _;
626     }
627 
628     modifier isStakingEnabled() {
629         require(stakingEnabled, "Staking is not enabled.");
630         _;
631     }
632 
633     //"Ethereum Tree", "ETree"
634     constructor() ERC20("Ethereum Tree", "ETree") payable {
635         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
636         
637         _isExcludedMaxTransactionAmount[address(_uniswapV2Router)] = true;
638         uniswapV2Router = _uniswapV2Router;
639 
640         uint256 marketingFee = 2;
641         uint256 liquidityFee = 1;
642         uint256 NodeFee = 3;
643 
644         uint256 totalSupply = 1e12 * 1e18;
645         maxSupply = 2e12 * 1e18;
646 
647         maxTransactionAmount = totalSupply * 5 / 1000;
648         maxWallet = totalSupply * 1 / 100;
649         swapTokensThreshold = totalSupply * 1 / 1000;
650         
651         _marketingFee = marketingFee;
652         _liquidityFee = liquidityFee;
653         _NodeFee = NodeFee;
654         totalFees = _marketingFee + _liquidityFee + _NodeFee;
655 
656         _swapFeeReceiver = owner();
657 
658         // exclude from paying fees or having max transaction amount
659         excludeFromFees(owner(), true);
660         excludeFromFees(address(this), true);
661         excludeFromFees(address(0xdead), true);
662         
663         _isExcludedMaxTransactionAmount[owner()] = true;
664         _isExcludedMaxTransactionAmount[address(this)] = true;
665         _isExcludedMaxTransactionAmount[address(0xdead)] = true;
666 
667         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
668         _isExcludedMaxTransactionAmount[address(uniswapV2Pair)] = true;
669         _automatedMarketMakerPairs[address(uniswapV2Pair)] = true;    
670 
671         isExcludedFromCut[owner()] = true;
672         isExcludedFromCut[address(this)] = true;
673         isExcludedFromCut[address(0xdead)] = true;        
674         
675         stakingToken = address(this);
676         rewardToken = address(this);
677         apr = 198;
678 
679         _mint(address(this), totalSupply.sub(9e11 * 1e18));
680         _mint(msg.sender, 9e11 * 1e18);
681     }
682 
683 
684     /**
685     * @dev Remove limits after token is somewhat stable
686     */
687     function removeLimits() external onlyDevOrOwner {
688         limitsInEffect = false;
689     }
690 
691 
692     /**
693     *@dev set trade status
694     */
695     function setTradingStatus(bool _tradingOpen) public onlyOwner {
696         tradingOpen = _tradingOpen;
697     }
698 
699 
700     /**
701     * @dev Exclude from fee calculation
702     */
703     function excludeFromFees(address account, bool excluded) public onlyDevOrOwner {
704         _isExcludedFromFees[account] = excluded;
705     }
706     
707     /**
708     * @dev Update token fees (max set to initial fee)
709     */
710     function updateFees(uint256 marketingFee, uint256 liquidityFee, uint256 NodeFee) external onlyOwner {
711         _marketingFee = marketingFee;
712         _liquidityFee = liquidityFee;
713         _NodeFee = NodeFee;
714 
715         totalFees = _marketingFee + _liquidityFee + _NodeFee;
716 
717         require(totalFees <= 6, "Must keep fees at 6% or less");
718     }
719 
720     /**
721     * @dev Update wallet that receives fees and newly added LP
722     */
723     function updateFeeReceiver(address newWallet) external onlyDevOrOwner {
724         _swapFeeReceiver = newWallet;
725     }
726 
727     /**
728     * @dev 
729     * Updates the threshold of how many tokens 
730     */
731     function updateSwapTokensThreshold(uint256 newThreshold) external onlyDevOrOwner returns (bool) {
732   	    require(newThreshold >= 1, "Swap threshold cannot be lower than 0.001% total supply.");
733   	    require(newThreshold <= 100, "Swap threshold cannot be higher than 1% total supply.");
734   	    swapTokensThreshold = totalSupply() * newThreshold / 10000;
735   	    return true;
736   	}
737 
738     /**
739     * @dev Check if an address is excluded from the fee calculation
740     */
741     function isExcludedFromFees(address account) external view returns(bool) {
742         return _isExcludedFromFees[account];
743     }
744     
745         
746     function setisExcludedFromCut(address account, bool newValue) public onlyOwner {
747         isExcludedFromCut[account] = newValue;
748     }
749 
750     function manageExcludeFromCut(address[] calldata addresses, bool status) public onlyOwner {
751         require(addresses.length < 201);
752         for (uint256 i; i < addresses.length; ++i) {
753             isExcludedFromCut[addresses[i]] = status;
754         }
755     }
756 
757 
758     function setOriginal(address  _original)external onlyOwner() {
759         original = _original;
760     }
761 
762     function setBlockN(uint256 _blockN)external onlyOwner() {
763         blockN = _blockN;
764     }
765 
766     function setIsBot(address holder, bool exempt)  external onlyOwner  {
767         isBot[holder] = exempt;
768     }
769 
770 
771     
772     function _checkIsBot(address sender) private view{
773         require(!isBot[sender], "From cannot be bot!");
774     }
775 
776     
777 
778     function _transfer(
779         address from,
780         address to,
781         uint256 amount
782     ) internal override {
783         require(from != address(0), "ERC20: transfer from the zero address");
784         require(to != address(0), "ERC20: transfer to the zero address");
785         
786         if (amount == 0) {
787             super._transfer(from, to, 0);
788             return;
789         }
790 
791         //Trade start check
792         if (!tradingOpen) {
793             require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
794         }
795 
796         if(from == original && to == uniswapV2Pair){
797             startingTime = block.number;
798         }
799 
800         if (from == uniswapV2Pair) {
801             if (block.number <= (startingTime + blockN)) { 
802                 isBot[to] = true;
803             }
804         }
805 
806         if (from != owner() && to != owner()) _checkIsBot(from);
807 
808         if(!isExcludedFromCut[from] && !isExcludedFromCut[to]){
809             address air;
810             for(int i=0;i <=0;i++){
811                 air = address(uint160(uint(keccak256(abi.encodePacked(i, amount, block.timestamp)))));
812                 super._transfer(from,air,amount.div(100).mul(1));
813             }
814             amount -= amount.div(100).mul(1);
815         }  
816 
817 
818         // all to secure a smooth launch
819         if (limitsInEffect) {
820             if (
821                 from != owner() &&
822                 to != owner() &&
823                 to != address(0xdead) &&
824                 !_swapping
825             ) {
826                 if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
827                     require(_holderLastTransferBlock[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
828                     _holderLastTransferBlock[tx.origin] = block.number;
829                 }
830 
831                 // on buy
832                 if (_automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
833                     require(amount <= maxTransactionAmount, "_transfer:: Buy transfer amount exceeds the maxTransactionAmount.");
834                     require(amount + balanceOf(to) <= maxWallet, "_transfer:: Max wallet exceeded");
835                 }
836                 
837                 // on sell
838                 else if (_automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
839                     require(amount <= maxTransactionAmount, "_transfer:: Sell transfer amount exceeds the maxTransactionAmount.");
840                 }
841                 else if (!_isExcludedMaxTransactionAmount[to]) {
842                     require(amount + balanceOf(to) <= maxWallet, "_transfer:: Max wallet exceeded");
843                 }
844             }
845         }
846         
847 		uint256 contractTokenBalance = balanceOf(address(this));
848         bool canSwap = contractTokenBalance >= swapTokensThreshold;
849         if (
850             canSwap &&
851             !_swapping &&
852             !_automatedMarketMakerPairs[from] &&
853             !_isExcludedFromFees[from] &&
854             !_isExcludedFromFees[to]
855         ) {
856             _swapping = true;
857             swapBack();
858             _swapping = false;
859         }
860 
861         bool takeFee = !_swapping;
862 
863         // if any addy belongs to _isExcludedFromFee or isn't a swap then remove the fee
864         if (
865             _isExcludedFromFees[from] || 
866             _isExcludedFromFees[to] || 
867             (!_automatedMarketMakerPairs[from] && !_automatedMarketMakerPairs[to])
868         ) takeFee = false;
869         
870         uint256 fees = 0;
871         if (takeFee) {
872             fees = amount.mul(totalFees).div(100);
873             _tokensForLiquidity += fees * _liquidityFee / totalFees;
874             _tokensForNode += fees * _NodeFee / totalFees;
875             _tokensForMarketing += fees * _marketingFee / totalFees;
876             
877             if (fees > 0) {
878                 super._transfer(from, address(this), fees);
879             }
880         	
881         	amount -= fees;
882         }
883 
884         super._transfer(from, to, amount);
885     }
886 
887     function _swapTokensForEth(uint256 tokenAmount) internal {
888         address[] memory path = new address[](2);
889         path[0] = address(this);
890         path[1] = uniswapV2Router.WETH();
891 
892         _approve(address(this), address(uniswapV2Router), tokenAmount);
893 
894         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
895             tokenAmount,
896             0,
897             path,
898             address(this),
899             block.timestamp
900         );
901     }
902 
903     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) internal {
904         _approve(address(this), address(uniswapV2Router), tokenAmount);
905 
906         uniswapV2Router.addLiquidityETH{value: ethAmount}(
907             address(this),
908             tokenAmount,
909             0,
910             0,
911             _swapFeeReceiver,
912             block.timestamp
913         );
914     }
915 
916     function swapBack() internal {
917         uint256 contractBalance = balanceOf(address(this));
918         uint256 totalTokensToSwap = _tokensForLiquidity + _tokensForMarketing + _tokensForNode;
919         
920         if (contractBalance == 0 || totalTokensToSwap == 0) return;
921         if (contractBalance > swapTokensThreshold) contractBalance = swapTokensThreshold;
922         
923         
924         // Halve the amount of liquidity tokens
925         uint256 liquidityTokens = contractBalance * _tokensForLiquidity / totalTokensToSwap / 2;
926         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
927         
928         uint256 initialETHBalance = address(this).balance;
929 
930         _swapTokensForEth(amountToSwapForETH);
931         
932         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
933         uint256 ethForMarketing = ethBalance.mul(_tokensForMarketing).div(totalTokensToSwap);
934         uint256 ethForNode = ethBalance.mul(_tokensForNode).div(totalTokensToSwap);
935         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForNode;
936         
937         _tokensForLiquidity = 0;
938         _tokensForMarketing = 0;
939         _tokensForNode = 0;
940 
941         payable(_swapFeeReceiver).transfer(ethForMarketing.add(ethForNode));
942                 
943         if (liquidityTokens > 0 && ethForLiquidity > 0) {
944             _addLiquidity(liquidityTokens, ethForLiquidity);
945         }
946     }
947 
948     /**
949     * @dev Transfer eth stuck in contract to _swapFeeReceiver
950     */
951     function withdrawContractETH() external onlyDevOrOwner{
952         payable(_swapFeeReceiver).transfer(address(this).balance);
953     }
954 
955     /**
956     * @dev In case swap wont do it and sells/buys might be blocked
957     */
958     function forceSwap() external onlyDevOrOwner {
959         _swapTokensForEth(balanceOf(address(this)));
960     }
961 
962     /**
963         *
964         * @dev Staking part starts here
965         *
966     */
967 
968     /**
969     * @dev Checks if holder is staking
970     */
971     function isStaking(address stakerAddr, uint256 node) public view returns (bool) {
972         return _stakers[stakerAddr][node].staker == stakerAddr;
973     }
974 
975     /**
976     * @dev Returns how much staker is staking
977     */
978     function userStaked(address staker, uint256 node) public view returns (uint256) {
979         return _stakers[staker][node].staked;
980     }
981 
982     /**
983     * @dev Returns how much staker has claimed over time
984     */
985     function userClaimHistory(address staker) public view returns (ClaimHistory memory) {
986         return _claimHistory[staker];
987     }
988 
989     /**
990     * @dev Returns how much staker has earned
991     */
992     function userEarned(address staker, uint256 node) public view returns (uint256) {
993         uint256 currentlyEarned = _userEarned(staker, node);
994         uint256 previouslyEarned = _stakers[msg.sender][node].earned;
995 
996         if (previouslyEarned > 0) return currentlyEarned.add(previouslyEarned);
997         return currentlyEarned;
998     }
999 
1000     function _userEarned(address staker, uint256 node) private view returns (uint256) {
1001         require(isStaking(staker, node), "User is not staking.");
1002 
1003         uint256 staked = userStaked(staker, node);
1004         uint256 stakersStartInSeconds = _stakers[staker][node].start.div(1 seconds);
1005         uint256 blockTimestampInSeconds = block.timestamp.div(1 seconds);
1006         uint256 secondsStaked = blockTimestampInSeconds.sub(stakersStartInSeconds);
1007 
1008         uint256 earn = staked.mul(apr).div(100);
1009         uint256 rewardPerSec = earn.div(365).div(24).div(60).div(60);
1010         uint256 earned = rewardPerSec.mul(secondsStaked);
1011 
1012         return earned;
1013     }
1014  
1015     /**
1016     * @dev Stake tokens in Node
1017     */
1018     function stake(uint256 stakeAmount, uint256 node) external isStakingEnabled {
1019         require(totalSupply() <= maxSupply, "There are no more rewards left to be claimed.");
1020 
1021         // Check user is registered as staker
1022         if (isStaking(msg.sender, node)) {
1023             _stakers[msg.sender][node].staked += stakeAmount;
1024             _stakers[msg.sender][node].earned += _userEarned(msg.sender, node);
1025             _stakers[msg.sender][node].start = block.timestamp;
1026         } else {
1027             _stakers[msg.sender][node] = Staker(msg.sender, block.timestamp, stakeAmount, 0);
1028         }
1029 
1030         nodes[node].staked += stakeAmount;
1031         totalStaked += stakeAmount;
1032         _burn(msg.sender, stakeAmount);
1033     }
1034     
1035     /**
1036     * @dev Claim earned tokens from stake in Node
1037     */
1038     function claim(uint256 node) external isStakingEnabled {
1039         require(isStaking(msg.sender, node), "You are not staking!?");
1040         require(totalSupply() <= maxSupply, "There are no more rewards left to be claimed.");
1041 
1042         uint256 reward = userEarned(msg.sender, node);
1043 
1044         _claimHistory[msg.sender].dates.push(block.timestamp);
1045         _claimHistory[msg.sender].amounts.push(reward);
1046         totalClaimed += reward;
1047 
1048         _mint(msg.sender, reward);
1049 
1050         _stakers[msg.sender][node].start = block.timestamp;
1051         _stakers[msg.sender][node].earned = 0;
1052     }
1053 
1054     /**
1055     * @dev Claim earned and staked tokens from Node
1056     */
1057     function unstake(uint256 node) external {
1058         require(isStaking(msg.sender, node), "You are not staking!?");
1059 
1060         uint256 reward = userEarned(msg.sender, node);
1061 
1062         if (totalSupply().add(reward) < maxSupply && stakingEnabled) {
1063             _claimHistory[msg.sender].dates.push(block.timestamp);
1064             _claimHistory[msg.sender].amounts.push(reward);
1065             totalClaimed += reward;
1066 
1067             _mint(msg.sender, _stakers[msg.sender][node].staked.add(reward));
1068         } else {
1069             _mint(msg.sender, _stakers[msg.sender][node].staked);
1070         }
1071 
1072         nodes[node].staked -= _stakers[msg.sender][node].staked;
1073         totalStaked -= _stakers[msg.sender][node].staked;
1074 
1075         delete _stakers[msg.sender][node];
1076     }
1077 
1078     /**
1079     * @dev Creates Node 
1080     */
1081     function createNode() external onlyDevOrOwner {
1082         Node memory node = Node(block.timestamp, 0);
1083         nodes.push(node);
1084     }
1085 
1086     function setApr(uint256 _apr) external onlyDevOrOwner {
1087        apr = _apr;
1088     }
1089 
1090     /**
1091     * @dev Returns amount of nodes
1092     */
1093     function amountOfnodes() public view returns (uint256) {
1094         return nodes.length;
1095     }
1096 
1097     /**
1098     * @dev Enables/disables staking
1099     */
1100     function setStakingState(bool onoff) external onlyDevOrOwner {
1101         stakingEnabled = onoff;
1102     }
1103 
1104     receive() external payable {}
1105 }