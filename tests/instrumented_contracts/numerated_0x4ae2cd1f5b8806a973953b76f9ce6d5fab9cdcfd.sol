1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address to, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(
22         address from,
23         address to,
24         uint256 amount
25     ) external returns (bool);
26 
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 interface IERC20Metadata is IERC20 {
32     function name() external view returns (string memory);
33     function symbol() external view returns (string memory);
34     function decimals() external view returns (uint8);
35 }
36 
37 contract ERC20 is Context, IERC20, IERC20Metadata {
38     mapping(address => uint256) private _balances;
39 
40     mapping(address => mapping(address => uint256)) private _allowances;
41 
42     uint256 private _totalSupply;
43 
44     string private _name;
45     string private _symbol;
46 
47     constructor(string memory name_, string memory symbol_) {
48         _name = name_;
49         _symbol = symbol_;
50     }
51 
52     function name() public view virtual override returns (string memory) {
53         return _name;
54     }
55 
56     function symbol() public view virtual override returns (string memory) {
57         return _symbol;
58     }
59 
60     function decimals() public view virtual override returns (uint8) {
61         return 18;
62     }
63 
64     function totalSupply() public view virtual override returns (uint256) {
65         return _totalSupply;
66     }
67 
68     function balanceOf(address account) public view virtual override returns (uint256) {
69         return _balances[account];
70     }
71 
72     function transfer(address to, uint256 amount) public virtual override returns (bool) {
73         address owner = _msgSender();
74         _transfer(owner, to, amount);
75         return true;
76     }
77 
78     function allowance(address owner, address spender) public view virtual override returns (uint256) {
79         return _allowances[owner][spender];
80     }
81 
82     function approve(address spender, uint256 amount) public virtual override returns (bool) {
83         address owner = _msgSender();
84         _approve(owner, spender, amount);
85         return true;
86     }
87 
88     function transferFrom(
89         address from,
90         address to,
91         uint256 amount
92     ) public virtual override returns (bool) {
93         address spender = _msgSender();
94         _spendAllowance(from, spender, amount);
95         _transfer(from, to, amount);
96         return true;
97     }
98 
99     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
100         address owner = _msgSender();
101         _approve(owner, spender, _allowances[owner][spender] + addedValue);
102         return true;
103     }
104 
105     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
106         address owner = _msgSender();
107         uint256 currentAllowance = _allowances[owner][spender];
108         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
109         unchecked {
110             _approve(owner, spender, currentAllowance - subtractedValue);
111         }
112 
113         return true;
114     }
115 
116     function _transfer(
117         address from,
118         address to,
119         uint256 amount
120     ) internal virtual {
121         require(from != address(0), "ERC20: transfer from the zero address");
122         require(to != address(0), "ERC20: transfer to the zero address");
123 
124         _beforeTokenTransfer(from, to, amount);
125 
126         uint256 fromBalance = _balances[from];
127         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
128         unchecked {
129             _balances[from] = fromBalance - amount;
130         }
131         _balances[to] += amount;
132 
133         emit Transfer(from, to, amount);
134 
135         _afterTokenTransfer(from, to, amount);
136     }
137 
138     function _mint(address account, uint256 amount) internal virtual {
139         require(account != address(0), "ERC20: mint to the zero address");
140 
141         _beforeTokenTransfer(address(0), account, amount);
142 
143         _totalSupply += amount;
144         _balances[account] += amount;
145         emit Transfer(address(0), account, amount);
146 
147         _afterTokenTransfer(address(0), account, amount);
148     }
149 
150     function _burn(address account, uint256 amount) internal virtual {
151         require(account != address(0), "ERC20: burn from the zero address");
152 
153         _beforeTokenTransfer(account, address(0), amount);
154 
155         uint256 accountBalance = _balances[account];
156         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
157         unchecked {
158             _balances[account] = accountBalance - amount;
159         }
160         _totalSupply -= amount;
161 
162         emit Transfer(account, address(0), amount);
163 
164         _afterTokenTransfer(account, address(0), amount);
165     }
166 
167     function _approve(
168         address owner,
169         address spender,
170         uint256 amount
171     ) internal virtual {
172         require(owner != address(0), "ERC20: approve from the zero address");
173         require(spender != address(0), "ERC20: approve to the zero address");
174 
175         _allowances[owner][spender] = amount;
176         emit Approval(owner, spender, amount);
177     }
178 
179     function _spendAllowance(
180         address owner,
181         address spender,
182         uint256 amount
183     ) internal virtual {
184         uint256 currentAllowance = allowance(owner, spender);
185         if (currentAllowance != type(uint256).max) {
186             require(currentAllowance >= amount, "ERC20: insufficient allowance");
187             unchecked {
188                 _approve(owner, spender, currentAllowance - amount);
189             }
190         }
191     }
192 
193     function _beforeTokenTransfer(
194         address from,
195         address to,
196         uint256 amount
197     ) internal virtual {}
198 
199     function _afterTokenTransfer(
200         address from,
201         address to,
202         uint256 amount
203     ) internal virtual {}
204 }
205 
206 interface IUniswapV2Factory {
207     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
208 
209     function feeTo() external view returns (address);
210     function feeToSetter() external view returns (address);
211 
212     function getPair(address tokenA, address tokenB) external view returns (address pair);
213     function allPairs(uint) external view returns (address pair);
214     function allPairsLength() external view returns (uint);
215 
216     function createPair(address tokenA, address tokenB) external returns (address pair);
217 
218     function setFeeTo(address) external;
219     function setFeeToSetter(address) external;
220 }
221 
222 interface IUniswapV2Pair {
223     event Approval(address indexed owner, address indexed spender, uint value);
224     event Transfer(address indexed from, address indexed to, uint value);
225 
226     function name() external pure returns (string memory);
227     function symbol() external pure returns (string memory);
228     function decimals() external pure returns (uint8);
229     function totalSupply() external view returns (uint);
230     function balanceOf(address owner) external view returns (uint);
231     function allowance(address owner, address spender) external view returns (uint);
232 
233     function approve(address spender, uint value) external returns (bool);
234     function transfer(address to, uint value) external returns (bool);
235     function transferFrom(address from, address to, uint value) external returns (bool);
236 
237     function DOMAIN_SEPARATOR() external view returns (bytes32);
238     function PERMIT_TYPEHASH() external pure returns (bytes32);
239     function nonces(address owner) external view returns (uint);
240 
241     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
242 
243     event Mint(address indexed sender, uint amount0, uint amount1);
244     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
245     event Swap(
246         address indexed sender,
247         uint amount0In,
248         uint amount1In,
249         uint amount0Out,
250         uint amount1Out,
251         address indexed to
252     );
253     event Sync(uint112 reserve0, uint112 reserve1);
254 
255     function MINIMUM_LIQUIDITY() external pure returns (uint);
256     function factory() external view returns (address);
257     function token0() external view returns (address);
258     function token1() external view returns (address);
259     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
260     function price0CumulativeLast() external view returns (uint);
261     function price1CumulativeLast() external view returns (uint);
262     function kLast() external view returns (uint);
263 
264     function mint(address to) external returns (uint liquidity);
265     function burn(address to) external returns (uint amount0, uint amount1);
266     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
267     function skim(address to) external;
268     function sync() external;
269 
270     function initialize(address, address) external;
271 }
272 
273 interface IUniswapV2Router01 {
274     function factory() external pure returns (address);
275     function WETH() external pure returns (address);
276 
277     function addLiquidity(
278         address tokenA,
279         address tokenB,
280         uint amountADesired,
281         uint amountBDesired,
282         uint amountAMin,
283         uint amountBMin,
284         address to,
285         uint deadline
286     ) external returns (uint amountA, uint amountB, uint liquidity);
287     function addLiquidityETH(
288         address token,
289         uint amountTokenDesired,
290         uint amountTokenMin,
291         uint amountETHMin,
292         address to,
293         uint deadline
294     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
295     function removeLiquidity(
296         address tokenA,
297         address tokenB,
298         uint liquidity,
299         uint amountAMin,
300         uint amountBMin,
301         address to,
302         uint deadline
303     ) external returns (uint amountA, uint amountB);
304     function removeLiquidityETH(
305         address token,
306         uint liquidity,
307         uint amountTokenMin,
308         uint amountETHMin,
309         address to,
310         uint deadline
311     ) external returns (uint amountToken, uint amountETH);
312     function removeLiquidityWithPermit(
313         address tokenA,
314         address tokenB,
315         uint liquidity,
316         uint amountAMin,
317         uint amountBMin,
318         address to,
319         uint deadline,
320         bool approveMax, uint8 v, bytes32 r, bytes32 s
321     ) external returns (uint amountA, uint amountB);
322     function removeLiquidityETHWithPermit(
323         address token,
324         uint liquidity,
325         uint amountTokenMin,
326         uint amountETHMin,
327         address to,
328         uint deadline,
329         bool approveMax, uint8 v, bytes32 r, bytes32 s
330     ) external returns (uint amountToken, uint amountETH);
331     function swapExactTokensForTokens(
332         uint amountIn,
333         uint amountOutMin,
334         address[] calldata path,
335         address to,
336         uint deadline
337     ) external returns (uint[] memory amounts);
338     function swapTokensForExactTokens(
339         uint amountOut,
340         uint amountInMax,
341         address[] calldata path,
342         address to,
343         uint deadline
344     ) external returns (uint[] memory amounts);
345     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
346         external
347         payable
348         returns (uint[] memory amounts);
349     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
350         external
351         returns (uint[] memory amounts);
352     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
353         external
354         returns (uint[] memory amounts);
355     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
356         external
357         payable
358         returns (uint[] memory amounts);
359 
360     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
361     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
362     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
363     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
364     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
365 }
366 
367 interface IUniswapV2Router02 is IUniswapV2Router01 {
368     function removeLiquidityETHSupportingFeeOnTransferTokens(
369         address token,
370         uint liquidity,
371         uint amountTokenMin,
372         uint amountETHMin,
373         address to,
374         uint deadline
375     ) external returns (uint amountETH);
376     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
377         address token,
378         uint liquidity,
379         uint amountTokenMin,
380         uint amountETHMin,
381         address to,
382         uint deadline,
383         bool approveMax, uint8 v, bytes32 r, bytes32 s
384     ) external returns (uint amountETH);
385 
386     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
387         uint amountIn,
388         uint amountOutMin,
389         address[] calldata path,
390         address to,
391         uint deadline
392     ) external;
393     function swapExactETHForTokensSupportingFeeOnTransferTokens(
394         uint amountOutMin,
395         address[] calldata path,
396         address to,
397         uint deadline
398     ) external payable;
399     function swapExactTokensForETHSupportingFeeOnTransferTokens(
400         uint amountIn,
401         uint amountOutMin,
402         address[] calldata path,
403         address to,
404         uint deadline
405     ) external;
406 }
407 
408 abstract contract Ownable is Context {
409     address private _owner;
410 
411     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
412 
413     constructor() {
414         _transferOwnership(_msgSender());
415     }
416 
417     function owner() public view virtual returns (address) {
418         return _owner;
419     }
420 
421     modifier onlyOwner() {
422         require(owner() == _msgSender(), "Ownable: caller is not the owner");
423         _;
424     }
425 
426     function renounceOwnership() public virtual onlyOwner {
427         _transferOwnership(address(0));
428     }
429 
430     function transferOwnership(address newOwner) public virtual onlyOwner {
431         require(newOwner != address(0), "Ownable: new owner is the zero address");
432         _transferOwnership(newOwner);
433     }
434 
435     function _transferOwnership(address newOwner) internal virtual {
436         address oldOwner = _owner;
437         _owner = newOwner;
438         emit OwnershipTransferred(oldOwner, newOwner);
439     }
440 }
441 
442 library SafeMath {
443     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
444         unchecked {
445             uint256 c = a + b;
446             if (c < a) return (false, 0);
447             return (true, c);
448         }
449     }
450 
451     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
452         unchecked {
453             if (b > a) return (false, 0);
454             return (true, a - b);
455         }
456     }
457 
458     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
459         unchecked {
460             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
461             // benefit is lost if 'b' is also tested.
462             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
463             if (a == 0) return (true, 0);
464             uint256 c = a * b;
465             if (c / a != b) return (false, 0);
466             return (true, c);
467         }
468     }
469 
470     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
471         unchecked {
472             if (b == 0) return (false, 0);
473             return (true, a / b);
474         }
475     }
476 
477     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
478         unchecked {
479             if (b == 0) return (false, 0);
480             return (true, a % b);
481         }
482     }
483 
484     function add(uint256 a, uint256 b) internal pure returns (uint256) {
485         return a + b;
486     }
487 
488     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
489         return a - b;
490     }
491 
492     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
493         return a * b;
494     }
495 
496     function div(uint256 a, uint256 b) internal pure returns (uint256) {
497         return a / b;
498     }
499 
500     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
501         return a % b;
502     }
503 
504     function sub(
505         uint256 a,
506         uint256 b,
507         string memory errorMessage
508     ) internal pure returns (uint256) {
509         unchecked {
510             require(b <= a, errorMessage);
511             return a - b;
512         }
513     }
514 
515     function div(
516         uint256 a,
517         uint256 b,
518         string memory errorMessage
519     ) internal pure returns (uint256) {
520         unchecked {
521             require(b > 0, errorMessage);
522             return a / b;
523         }
524     }
525 
526     function mod(
527         uint256 a,
528         uint256 b,
529         string memory errorMessage
530     ) internal pure returns (uint256) {
531         unchecked {
532             require(b > 0, errorMessage);
533             return a % b;
534         }
535     }
536 }
537 
538 contract EHIVE is ERC20, Ownable {
539     using SafeMath for uint256;
540 
541     uint256 public maxSupply; // what the total supply can reach and not go beyond
542 
543     IUniswapV2Router02 private uniswapV2Router;
544     address private uniswapV2Pair;
545 
546     bool private _swapping;
547 
548     address private _swapFeeReceiver;
549     
550     uint256 public maxTransactionAmount;
551     uint256 public maxWallet;
552 
553     uint256 public swapTokensThreshold;
554         
555     bool public limitsInEffect = true;
556 
557     uint256 public totalFees;
558     uint256 private _marketingFee;
559     uint256 private _liquidityFee;
560     uint256 private _validatorFee;
561     
562     uint256 private _tokensForMarketing;
563     uint256 private _tokensForLiquidity;
564     uint256 private _tokensForValidator;
565     
566     // staking vars
567     uint256 public totalStaked;
568     address public stakingToken;
569     address public rewardToken;
570     uint256 public apr;
571 
572     bool public stakingEnabled = false;
573     uint256 public totalClaimed;
574 
575     struct Validator {
576         uint256 creationTime;
577         uint256 staked;
578     }
579 
580     struct Staker {
581         address staker;
582         uint256 start;
583         uint256 staked;
584         uint256 earned;
585     }
586 
587     struct ClaimHistory {
588         uint256[] dates;
589         uint256[] amounts;
590     }
591 
592     // exlcude from fees and max transaction amount
593     mapping (address => bool) private _isExcludedFromFees;
594     mapping (address => bool) private _isExcludedMaxTransactionAmount;
595 
596     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
597     // could be subject to a maximum transfer amount
598     mapping (address => bool) private _automatedMarketMakerPairs;
599 
600     // to stop bot spam buys and sells on launch
601     mapping(address => uint256) private _holderLastTransferBlock;
602 
603     // stake data
604     mapping(address => mapping(uint256 => Staker)) private _stakers;
605     mapping(address => ClaimHistory) private _claimHistory;
606     Validator[] public validators;
607 
608     /**
609      * @dev Throws if called by any account other than the _swapFeeReceiver
610      */
611     modifier teamOROwner() {
612         require(_swapFeeReceiver == _msgSender() || owner() == _msgSender(), "Caller is not the _swapFeeReceiver address nor owner.");
613         _;
614     }
615 
616     modifier isStakingEnabled() {
617         require(stakingEnabled, "Staking is not enabled.");
618         _;
619     }
620 
621     constructor() ERC20("Ethereum Hive", "EHIVE") payable {
622         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
623         
624         _isExcludedMaxTransactionAmount[address(_uniswapV2Router)] = true;
625         uniswapV2Router = _uniswapV2Router;
626 
627         uint256 marketingFee = 2;
628         uint256 liquidityFee = 1;
629         uint256 validatorFee = 3;
630 
631         uint256 totalSupply = 5e11 * 1e18;
632         maxSupply = 1e12 * 1e18;
633 
634         maxTransactionAmount = totalSupply * 4 / 1000;
635         maxWallet = totalSupply * 1 / 100;
636         swapTokensThreshold = totalSupply * 1 / 1000;
637         
638         _marketingFee = marketingFee;
639         _liquidityFee = liquidityFee;
640         _validatorFee = validatorFee;
641         totalFees = _marketingFee + _liquidityFee + _validatorFee;
642 
643         _swapFeeReceiver = owner();
644 
645         // exclude from paying fees or having max transaction amount
646         excludeFromFees(owner(), true);
647         excludeFromFees(address(this), true);
648         excludeFromFees(address(0xdead), true);
649         
650         _isExcludedMaxTransactionAmount[owner()] = true;
651         _isExcludedMaxTransactionAmount[address(this)] = true;
652         _isExcludedMaxTransactionAmount[address(0xdead)] = true;
653         
654         stakingToken = address(this);
655         rewardToken = address(this);
656         apr = 50;
657 
658         _mint(address(this), totalSupply.sub(17e10 * 1e18));
659         _mint(msg.sender, 17e10 * 1e18);
660     }
661 
662     /**
663     * @dev Once live, can never be switched off
664     */
665     function startTrading() external teamOROwner {
666         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
667         _isExcludedMaxTransactionAmount[address(uniswapV2Pair)] = true;
668         _automatedMarketMakerPairs[address(uniswapV2Pair)] = true;
669 
670         _approve(address(this), address(uniswapV2Router), balanceOf(address(this)));
671         uniswapV2Router.addLiquidityETH{value: address(this).balance} (
672             address(this),
673             balanceOf(address(this)),
674             0,
675             0,
676             owner(),
677             block.timestamp
678         );
679     }
680 
681     /**
682     * @dev Remove limits after token is somewhat stable
683     */
684     function removeLimits() external teamOROwner {
685         limitsInEffect = false;
686     }
687 
688     /**
689     * @dev Exclude from fee calculation
690     */
691     function excludeFromFees(address account, bool excluded) public teamOROwner {
692         _isExcludedFromFees[account] = excluded;
693     }
694     
695     /**
696     * @dev Update token fees (max set to initial fee)
697     */
698     function updateFees(uint256 marketingFee, uint256 liquidityFee, uint256 validatorFee) external onlyOwner {
699         _marketingFee = marketingFee;
700         _liquidityFee = liquidityFee;
701         _validatorFee = validatorFee;
702 
703         totalFees = _marketingFee + _liquidityFee + _validatorFee;
704 
705         require(totalFees <= 6, "Must keep fees at 6% or less");
706     }
707 
708     /**
709     * @dev Update wallet that receives fees and newly added LP
710     */
711     function updateFeeReceiver(address newWallet) external teamOROwner {
712         _swapFeeReceiver = newWallet;
713     }
714 
715     /**
716     * @dev Very important function. 
717     * Updates the threshold of how many tokens that must be in the contract calculation for fees to be taken
718     */
719     function updateSwapTokensThreshold(uint256 newThreshold) external teamOROwner returns (bool) {
720   	    require(newThreshold >= totalSupply() * 1 / 100000, "Swap threshold cannot be lower than 0.001% total supply.");
721   	    require(newThreshold <= totalSupply() * 5 / 1000, "Swap threshold cannot be higher than 0.5% total supply.");
722   	    swapTokensThreshold = newThreshold;
723   	    return true;
724   	}
725 
726     /**
727     * @dev Check if an address is excluded from the fee calculation
728     */
729     function isExcludedFromFees(address account) external view returns(bool) {
730         return _isExcludedFromFees[account];
731     }
732 
733     function _transfer(
734         address from,
735         address to,
736         uint256 amount
737     ) internal override {
738         require(from != address(0), "ERC20: transfer from the zero address");
739         require(to != address(0), "ERC20: transfer to the zero address");
740         
741         if (amount == 0) {
742             super._transfer(from, to, 0);
743             return;
744         }
745 
746         // all to secure a smooth launch
747         if (limitsInEffect) {
748             if (
749                 from != owner() &&
750                 to != owner() &&
751                 to != address(0xdead) &&
752                 !_swapping
753             ) {
754                 if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
755                     require(_holderLastTransferBlock[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
756                     _holderLastTransferBlock[tx.origin] = block.number;
757                 }
758 
759                 // on buy
760                 if (_automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
761                     require(amount <= maxTransactionAmount, "_transfer:: Buy transfer amount exceeds the maxTransactionAmount.");
762                     require(amount + balanceOf(to) <= maxWallet, "_transfer:: Max wallet exceeded");
763                 }
764                 
765                 // on sell
766                 else if (_automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
767                     require(amount <= maxTransactionAmount, "_transfer:: Sell transfer amount exceeds the maxTransactionAmount.");
768                 }
769                 else if (!_isExcludedMaxTransactionAmount[to]) {
770                     require(amount + balanceOf(to) <= maxWallet, "_transfer:: Max wallet exceeded");
771                 }
772             }
773         }
774         
775 		uint256 contractTokenBalance = balanceOf(address(this));
776         bool canSwap = contractTokenBalance >= swapTokensThreshold;
777         if (
778             canSwap &&
779             !_swapping &&
780             !_automatedMarketMakerPairs[from] &&
781             !_isExcludedFromFees[from] &&
782             !_isExcludedFromFees[to]
783         ) {
784             _swapping = true;
785             swapBack();
786             _swapping = false;
787         }
788 
789         bool takeFee = !_swapping;
790 
791         // if any addy belongs to _isExcludedFromFee or isn't a swap then remove the fee
792         if (
793             _isExcludedFromFees[from] || 
794             _isExcludedFromFees[to] || 
795             (!_automatedMarketMakerPairs[from] && !_automatedMarketMakerPairs[to])
796         ) takeFee = false;
797         
798         uint256 fees = 0;
799         if (takeFee) {
800             fees = amount.mul(totalFees).div(100);
801             _tokensForLiquidity += fees * _liquidityFee / totalFees;
802             _tokensForValidator += fees * _validatorFee / totalFees;
803             _tokensForMarketing += fees * _marketingFee / totalFees;
804             
805             if (fees > 0) {
806                 super._transfer(from, address(this), fees);
807             }
808         	
809         	amount -= fees;
810         }
811 
812         super._transfer(from, to, amount);
813     }
814 
815     function _swapTokensForEth(uint256 tokenAmount) internal {
816         address[] memory path = new address[](2);
817         path[0] = address(this);
818         path[1] = uniswapV2Router.WETH();
819 
820         _approve(address(this), address(uniswapV2Router), tokenAmount);
821 
822         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
823             tokenAmount,
824             0,
825             path,
826             address(this),
827             block.timestamp
828         );
829     }
830 
831     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) internal {
832         _approve(address(this), address(uniswapV2Router), tokenAmount);
833 
834         uniswapV2Router.addLiquidityETH{value: ethAmount}(
835             address(this),
836             tokenAmount,
837             0,
838             0,
839             _swapFeeReceiver,
840             block.timestamp
841         );
842     }
843 
844     function swapBack() internal {
845         uint256 contractBalance = balanceOf(address(this));
846         uint256 totalTokensToSwap = _tokensForLiquidity + _tokensForMarketing + _tokensForValidator;
847         
848         if (contractBalance == 0 || totalTokensToSwap == 0) return;
849         if (contractBalance > swapTokensThreshold) contractBalance = swapTokensThreshold;
850         
851         
852         // Halve the amount of liquidity tokens
853         uint256 liquidityTokens = contractBalance * _tokensForLiquidity / totalTokensToSwap / 2;
854         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
855         
856         uint256 initialETHBalance = address(this).balance;
857 
858         _swapTokensForEth(amountToSwapForETH);
859         
860         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
861         uint256 ethForMarketing = ethBalance.mul(_tokensForMarketing).div(totalTokensToSwap);
862         uint256 ethForValidator = ethBalance.mul(_tokensForValidator).div(totalTokensToSwap);
863         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForValidator;
864         
865         _tokensForLiquidity = 0;
866         _tokensForMarketing = 0;
867         _tokensForValidator = 0;
868 
869         payable(_swapFeeReceiver).transfer(ethForMarketing.add(ethForValidator));
870                 
871         if (liquidityTokens > 0 && ethForLiquidity > 0) {
872             _addLiquidity(liquidityTokens, ethForLiquidity);
873         }
874     }
875 
876     /**
877     * @dev Transfer eth stuck in contract to _swapFeeReceiver
878     */
879     function withdrawContractETH() external {
880         payable(_swapFeeReceiver).transfer(address(this).balance);
881     }
882 
883     /**
884     * @dev In case swap wont do it and sells/buys might be blocked
885     */
886     function forceSwap() external teamOROwner {
887         _swapTokensForEth(balanceOf(address(this)));
888     }
889 
890     /**
891         *
892         * @dev Staking part starts here
893         *
894     */
895 
896     /**
897     * @dev Checks if holder is staking
898     */
899     function isStaking(address stakerAddr, uint256 validator) public view returns (bool) {
900         return _stakers[stakerAddr][validator].staker == stakerAddr;
901     }
902 
903     /**
904     * @dev Returns how much staker is staking
905     */
906     function userStaked(address staker, uint256 validator) public view returns (uint256) {
907         return _stakers[staker][validator].staked;
908     }
909 
910     /**
911     * @dev Returns how much staker has claimed over time
912     */
913     function userClaimHistory(address staker) public view returns (ClaimHistory memory) {
914         return _claimHistory[staker];
915     }
916 
917     /**
918     * @dev Returns how much staker has earned
919     */
920     function userEarned(address staker, uint256 validator) public view returns (uint256) {
921         uint256 currentlyEarned = _userEarned(staker, validator);
922         uint256 previouslyEarned = _stakers[msg.sender][validator].earned;
923 
924         if (previouslyEarned > 0) return currentlyEarned.add(previouslyEarned);
925         return currentlyEarned;
926     }
927 
928     function _userEarned(address staker, uint256 validator) private view returns (uint256) {
929         require(isStaking(staker, validator), "User is not staking.");
930 
931         uint256 staked = userStaked(staker, validator);
932         uint256 stakersStartInSeconds = _stakers[staker][validator].start.div(1 seconds);
933         uint256 blockTimestampInSeconds = block.timestamp.div(1 seconds);
934         uint256 secondsStaked = blockTimestampInSeconds.sub(stakersStartInSeconds);
935 
936         uint256 earn = staked.mul(apr).div(100);
937         uint256 rewardPerSec = earn.div(365).div(24).div(60).div(60);
938         uint256 earned = rewardPerSec.mul(secondsStaked);
939 
940         return earned;
941     }
942  
943     /**
944     * @dev Stake tokens in validator
945     */
946     function stake(uint256 stakeAmount, uint256 validator) external isStakingEnabled {
947         require(totalSupply() <= maxSupply, "There are no more rewards left to be claimed.");
948 
949         // Check user is registered as staker
950         if (isStaking(msg.sender, validator)) {
951             _stakers[msg.sender][validator].staked += stakeAmount;
952             _stakers[msg.sender][validator].earned += _userEarned(msg.sender, validator);
953             _stakers[msg.sender][validator].start = block.timestamp;
954         } else {
955             _stakers[msg.sender][validator] = Staker(msg.sender, block.timestamp, stakeAmount, 0);
956         }
957 
958         validators[validator].staked += stakeAmount;
959         totalStaked += stakeAmount;
960         _burn(msg.sender, stakeAmount);
961     }
962     
963     /**
964     * @dev Claim earned tokens from stake in validator
965     */
966     function claim(uint256 validator) external isStakingEnabled {
967         require(isStaking(msg.sender, validator), "You are not staking!?");
968         require(totalSupply() <= maxSupply, "There are no more rewards left to be claimed.");
969 
970         uint256 reward = userEarned(msg.sender, validator);
971 
972         _claimHistory[msg.sender].dates.push(block.timestamp);
973         _claimHistory[msg.sender].amounts.push(reward);
974         totalClaimed += reward;
975 
976         _mint(msg.sender, reward);
977 
978         _stakers[msg.sender][validator].start = block.timestamp;
979         _stakers[msg.sender][validator].earned = 0;
980     }
981 
982     /**
983     * @dev Claim earned and staked tokens from validator
984     */
985     function unstake(uint256 validator) external {
986         require(isStaking(msg.sender, validator), "You are not staking!?");
987 
988         uint256 reward = userEarned(msg.sender, validator);
989 
990         if (totalSupply().add(reward) < maxSupply && stakingEnabled) {
991             _claimHistory[msg.sender].dates.push(block.timestamp);
992             _claimHistory[msg.sender].amounts.push(reward);
993             totalClaimed += reward;
994 
995             _mint(msg.sender, _stakers[msg.sender][validator].staked.add(reward));
996         } else {
997             _mint(msg.sender, _stakers[msg.sender][validator].staked);
998         }
999 
1000         validators[validator].staked -= _stakers[msg.sender][validator].staked;
1001         totalStaked -= _stakers[msg.sender][validator].staked;
1002 
1003         delete _stakers[msg.sender][validator];
1004     }
1005 
1006     /**
1007     * @dev Creates validator 
1008     */
1009     function createValidator() external teamOROwner {
1010         Validator memory validator = Validator(block.timestamp, 0);
1011         validators.push(validator);
1012     }
1013 
1014     /**
1015     * @dev Returns amount of validators
1016     */
1017     function amountOfValidators() public view returns (uint256) {
1018         return validators.length;
1019     }
1020 
1021     /**
1022     * @dev Enables/disables staking
1023     */
1024     function setStakingState(bool onoff) external teamOROwner {
1025         stakingEnabled = onoff;
1026     }
1027 
1028     receive() external payable {}
1029 }