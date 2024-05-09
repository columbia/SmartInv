1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-02
3 */
4 
5 pragma solidity ^0.8.0;
6 
7 // SPDX-License-Identifier:MIT
8 //Naetion
9 
10 interface IERC20 {
11     event Approval(
12         address indexed owner,
13         address indexed spender,
14         uint256 value
15     );
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     function name() external view returns (string memory);
19 
20     function symbol() external view returns (string memory);
21 
22     function decimals() external view returns (uint8);
23 
24     function totalSupply() external view returns (uint256);
25 
26     function balanceOf(address owner) external view returns (uint256);
27 
28     function allowance(address owner, address spender)
29         external
30         view
31         returns (uint256);
32 
33     function approve(address spender, uint256 value) external returns (bool);
34 
35     function transfer(address to, uint256 value) external returns (bool);
36 
37     function transferFrom(
38         address from,
39         address to,
40         uint256 value
41     ) external returns (bool);
42 }
43 
44 abstract contract Context {
45     function _msgSender() internal view virtual returns (address) {
46         return (msg.sender);
47     }
48 
49     function _msgData() internal view virtual returns (bytes memory) {
50         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
51         return msg.data;
52     }
53 }
54 
55 contract Ownable is Context {
56     address private _owner;
57     address private _previousOwner;
58     uint256 private _lockTime;
59 
60     event OwnershipTransferred(
61         address indexed previousOwner,
62         address indexed newOwner
63     );
64 
65     constructor() {
66         _owner = _msgSender();
67         emit OwnershipTransferred(address(0), _owner);
68     }
69 
70     function owner() public view returns (address) {
71         return _owner;
72     }
73 
74     modifier onlyOwner() {
75         require(_owner == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     function renounceOwnership() public virtual onlyOwner {
80         emit OwnershipTransferred(_owner, address(0));
81         _owner = (address(0));
82     }
83 
84     function transferOwnership(address newOwner) public virtual onlyOwner {
85         require(
86             newOwner != address(0),
87             "Ownable: new owner is the zero address"
88         );
89         emit OwnershipTransferred(_owner, newOwner);
90         _owner = newOwner;
91     }
92 
93     function geUnlockTime() public view returns (uint256) {
94         return _lockTime;
95     }
96 
97     //Locks the contract for owner for the amount of time provided
98     function lock(uint256 time) public virtual onlyOwner {
99         _previousOwner = _owner;
100         _owner = address(0);
101         _lockTime = block.timestamp + time;
102         emit OwnershipTransferred(_owner, address(0));
103     }
104 
105     //Unlocks the contract for owner when _lockTime is exceeds
106     function unlock() public virtual {
107         require(
108             _previousOwner == msg.sender,
109             "You don't have permission to unlock"
110         );
111         require(
112             block.timestamp > _lockTime,
113             "Contract is locked until defined days"
114         );
115         emit OwnershipTransferred(_owner, _previousOwner);
116         _owner = _previousOwner;
117         _previousOwner = address(0);
118     }
119 }
120 
121 interface IUniswapV2Factory {
122     event PairCreated(
123         address indexed token0,
124         address indexed token1,
125         address pair,
126         uint256
127     );
128 
129     function feeTo() external view returns (address);
130 
131     function feeToSetter() external view returns (address);
132 
133     function getPair(address tokenA, address tokenB)
134         external
135         view
136         returns (address pair);
137 
138     function allPairs(uint256) external view returns (address pair);
139 
140     function allPairsLength() external view returns (uint256);
141 
142     function createPair(address tokenA, address tokenB)
143         external
144         returns (address pair);
145 
146     function setFeeTo(address) external;
147 
148     function setFeeToSetter(address) external;
149 }
150 
151 interface IUniswapV2Pair {
152     event Approval(
153         address indexed owner,
154         address indexed spender,
155         uint256 value
156     );
157     event Transfer(address indexed from, address indexed to, uint256 value);
158 
159     function name() external pure returns (string memory);
160 
161     function symbol() external pure returns (string memory);
162 
163     function decimals() external pure returns (uint8);
164 
165     function totalSupply() external view returns (uint256);
166 
167     function balanceOf(address owner) external view returns (uint256);
168 
169     function allowance(address owner, address spender)
170         external
171         view
172         returns (uint256);
173 
174     function approve(address spender, uint256 value) external returns (bool);
175 
176     function transfer(address to, uint256 value) external returns (bool);
177 
178     function transferFrom(
179         address from,
180         address to,
181         uint256 value
182     ) external returns (bool);
183 
184     function DOMAIN_SEPARATOR() external view returns (bytes32);
185 
186     function PERMIT_TYPEHASH() external pure returns (bytes32);
187 
188     function nonces(address owner) external view returns (uint256);
189 
190     function permit(
191         address owner,
192         address spender,
193         uint256 value,
194         uint256 deadline,
195         uint8 v,
196         bytes32 r,
197         bytes32 s
198     ) external;
199 
200     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
201     event Burn(
202         address indexed sender,
203         uint256 amount0,
204         uint256 amount1,
205         address indexed to
206     );
207     event Swap(
208         address indexed sender,
209         uint256 amount0In,
210         uint256 amount1In,
211         uint256 amount0Out,
212         uint256 amount1Out,
213         address indexed to
214     );
215     event Sync(uint112 reserve0, uint112 reserve1);
216 
217     function MINIMUM_LIQUIDITY() external pure returns (uint256);
218 
219     function factory() external view returns (address);
220 
221     function token0() external view returns (address);
222 
223     function token1() external view returns (address);
224 
225     function getReserves()
226         external
227         view
228         returns (
229             uint112 reserve0,
230             uint112 reserve1,
231             uint32 blockTimestampLast
232         );
233 
234     function price0CumulativeLast() external view returns (uint256);
235 
236     function price1CumulativeLast() external view returns (uint256);
237 
238     function kLast() external view returns (uint256);
239 
240     function mint(address to) external returns (uint256 liquidity);
241 
242     function burn(address to)
243         external
244         returns (uint256 amount0, uint256 amount1);
245 
246     function swap(
247         uint256 amount0Out,
248         uint256 amount1Out,
249         address to,
250         bytes calldata data
251     ) external;
252 
253     function skim(address to) external;
254 
255     function sync() external;
256 
257     function initialize(address, address) external;
258 }
259 
260 interface IUniswapV2Router01 {
261     function factory() external pure returns (address);
262 
263     function WETH() external pure returns (address);
264 
265     function addLiquidity(
266         address tokenA,
267         address tokenB,
268         uint256 amountADesired,
269         uint256 amountBDesired,
270         uint256 amountAMin,
271         uint256 amountBMin,
272         address to,
273         uint256 deadline
274     )
275         external
276         returns (
277             uint256 amountA,
278             uint256 amountB,
279             uint256 liquidity
280         );
281 
282     function addLiquidityETH(
283         address token,
284         uint256 amountTokenDesired,
285         uint256 amountTokenMin,
286         uint256 amountETHMin,
287         address to,
288         uint256 deadline
289     )
290         external
291         payable
292         returns (
293             uint256 amountToken,
294             uint256 amountETH,
295             uint256 liquidity
296         );
297 
298     function removeLiquidity(
299         address tokenA,
300         address tokenB,
301         uint256 liquidity,
302         uint256 amountAMin,
303         uint256 amountBMin,
304         address to,
305         uint256 deadline
306     ) external returns (uint256 amountA, uint256 amountB);
307 
308     function removeLiquidityETH(
309         address token,
310         uint256 liquidity,
311         uint256 amountTokenMin,
312         uint256 amountETHMin,
313         address to,
314         uint256 deadline
315     ) external returns (uint256 amountToken, uint256 amountETH);
316 
317     function removeLiquidityWithPermit(
318         address tokenA,
319         address tokenB,
320         uint256 liquidity,
321         uint256 amountAMin,
322         uint256 amountBMin,
323         address to,
324         uint256 deadline,
325         bool approveMax,
326         uint8 v,
327         bytes32 r,
328         bytes32 s
329     ) external returns (uint256 amountA, uint256 amountB);
330 
331     function removeLiquidityETHWithPermit(
332         address token,
333         uint256 liquidity,
334         uint256 amountTokenMin,
335         uint256 amountETHMin,
336         address to,
337         uint256 deadline,
338         bool approveMax,
339         uint8 v,
340         bytes32 r,
341         bytes32 s
342     ) external returns (uint256 amountToken, uint256 amountETH);
343 
344     function swapExactTokensForTokens(
345         uint256 amountIn,
346         uint256 amountOutMin,
347         address[] calldata path,
348         address to,
349         uint256 deadline
350     ) external returns (uint256[] memory amounts);
351 
352     function swapTokensForExactTokens(
353         uint256 amountOut,
354         uint256 amountInMax,
355         address[] calldata path,
356         address to,
357         uint256 deadline
358     ) external returns (uint256[] memory amounts);
359 
360     function swapExactETHForTokens(
361         uint256 amountOutMin,
362         address[] calldata path,
363         address to,
364         uint256 deadline
365     ) external returns (uint256[] memory amounts);
366 
367     function swapTokensForExactETH(
368         uint256 amountOut,
369         uint256 amountInMax,
370         address[] calldata path,
371         address to,
372         uint256 deadline
373     ) external returns (uint256[] memory amounts);
374 
375     function swapExactTokensForETH(
376         uint256 amountIn,
377         uint256 amountOutMin,
378         address[] calldata path,
379         address to,
380         uint256 deadline
381     ) external returns (uint256[] memory amounts);
382 
383     function swapETHForExactTokens(
384         uint256 amountOut,
385         address[] calldata path,
386         address to,
387         uint256 deadline
388     ) external returns (uint256[] memory amounts);
389 
390     function quote(
391         uint256 amountA,
392         uint256 reserveA,
393         uint256 reserveB
394     ) external pure returns (uint256 amountB);
395 
396     function getAmountOut(
397         uint256 amountIn,
398         uint256 reserveIn,
399         uint256 reserveOut
400     ) external pure returns (uint256 amountOut);
401 
402     function getAmountIn(
403         uint256 amountOut,
404         uint256 reserveIn,
405         uint256 reserveOut
406     ) external pure returns (uint256 amountIn);
407 
408     function getAmountsOut(uint256 amountIn, address[] calldata path)
409         external
410         view
411         returns (uint256[] memory amounts);
412 
413     function getAmountsIn(uint256 amountOut, address[] calldata path)
414         external
415         view
416         returns (uint256[] memory amounts);
417 }
418 
419 interface IUniswapV2Router02 is IUniswapV2Router01 {
420     function removeLiquidityETHSupportingFeeOnTransferTokens(
421         address token,
422         uint256 liquidity,
423         uint256 amountTokenMin,
424         uint256 amountETHMin,
425         address to,
426         uint256 deadline
427     ) external returns (uint256 amountETH);
428 
429     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
430         address token,
431         uint256 liquidity,
432         uint256 amountTokenMin,
433         uint256 amountETHMin,
434         address to,
435         uint256 deadline,
436         bool approveMax,
437         uint8 v,
438         bytes32 r,
439         bytes32 s
440     ) external returns (uint256 amountETH);
441 
442     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
443         uint256 amountIn,
444         uint256 amountOutMin,
445         address[] calldata path,
446         address to,
447         uint256 deadline
448     ) external;
449 
450     function swapExactETHForTokensSupportingFeeOnTransferTokens(
451         uint256 amountOutMin,
452         address[] calldata path,
453         address to,
454         uint256 deadline
455     ) external payable;
456 
457     function swapExactTokensForETHSupportingFeeOnTransferTokens(
458         uint256 amountIn,
459         uint256 amountOutMin,
460         address[] calldata path,
461         address to,
462         uint256 deadline
463     ) external;
464 }
465 
466 library Utils {
467     using SafeMath for uint256;
468 
469     function swapTokensForEth(address routerAddress, uint256 tokenAmount)
470         internal
471     {
472         IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(routerAddress);
473 
474         // generate the uniswap pair path of token -> weth
475         address[] memory path = new address[](2);
476         path[0] = address(this);
477         path[1] = uniswapV2Router.WETH();
478 
479         // make the swap
480         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
481             tokenAmount,
482             0, // accept any amount of BNB
483             path,
484             address(this),
485             block.timestamp + 360
486         );
487     }
488 
489     function swapETHForTokens(
490         address routerAddress,
491         address recipient,
492         uint256 ethAmount
493     ) internal {
494         IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(routerAddress);
495 
496         // generate the uniswap pair path of token -> weth
497         address[] memory path = new address[](2);
498         path[0] = uniswapV2Router.WETH();
499         path[1] = address(this);
500 
501         // make the swap
502         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
503             value: ethAmount
504         }(
505             0, // accept any amount of BNB
506             path,
507             address(recipient),
508             block.timestamp + 360
509         );
510     }
511 
512     function addLiquidity(
513         address routerAddress,
514         address owner,
515         uint256 tokenAmount,
516         uint256 ethAmount
517     ) internal {
518         IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(routerAddress);
519 
520         // add the liquidity
521         uniswapV2Router.addLiquidityETH{value: ethAmount}(
522             address(this),
523             tokenAmount,
524             0, // slippage is unavoidable
525             0, // slippage is unavoidable
526             owner,
527             block.timestamp + 360
528         );
529     }
530 }
531 
532 // Protocol by team BloctechSolutions.com
533 
534 contract Naetion is Context, IERC20, Ownable {
535     using SafeMath for uint256;
536 
537     mapping(address => uint256) private _balances;
538     mapping(address => mapping(address => uint256)) private _allowances;
539 
540     string private _name;
541     string private _symbol;
542     uint8 private _decimals;
543     uint256 private _totalSupply;
544 
545     mapping(address => bool) private _isExcludedFromFee;
546 
547     uint256 public _taxFee;
548     uint256 public _liquidityFee;
549 
550     IUniswapV2Router02 public immutable uniswapV2Router;
551     address public immutable uniswapV2Pair;
552 
553     bool inSwapAndLiquify;
554     bool public swapAndLiquifyEnabled; // should be true to turn on to add liquidty
555     bool public buyBackEnabled; // should be true to turn on to buy back from pool
556     bool public _tradingOpen; // should be true to turn on trading, one time process
557 
558     uint256 public _minTokensToAddToLiquidity;
559     uint256 public buyBackLowerLimit = 0.1 ether;
560     uint256 public buyBackUpperLimit = 1 ether;
561 
562     address private providerAddress;
563 
564     event SwapAndLiquifyEnabledUpdated(bool enabled);
565     event BuyBackEnabledUpdated(bool enabled);
566     event BuyBack(address indexed receiver, uint256 indexed bnbAmount);
567     event SwapAndLiquify(
568         uint256 tokensSwapped,
569         uint256 ethReceived,
570         uint256 tokensIntoLiqudity
571     );
572 
573     modifier lockTheSwap() {
574         inSwapAndLiquify = true;
575         _;
576         inSwapAndLiquify = false;
577     }
578 
579     constructor() {
580         _name = "Naetion";
581         _symbol = "NTN";
582         _decimals = 18;
583         _totalSupply = 1000000000 * (10**18); // total Supply: 1B
584 
585         // unit of 0.01%
586         _taxFee = 400;
587         _liquidityFee = 400;
588 
589         _minTokensToAddToLiquidity = 10000 * (10**18); // 0.1M
590 
591         _balances[owner()] = _balances[owner()].add(_totalSupply);
592 
593         // The service provider wallet that takes tax from transactions
594         providerAddress = owner();
595 
596         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
597             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
598         );
599         // Create a uniswap pair for this new token
600         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
601             .createPair(address(this), _uniswapV2Router.WETH());
602 
603         // Set the rest of the contract variables
604         uniswapV2Router = _uniswapV2Router;
605         uniswapV2Pair = _uniswapV2Pair;
606 
607         // Exclude owner and this contract from fee
608         _isExcludedFromFee[owner()] = true;
609         _isExcludedFromFee[address(this)] = true;
610 
611         emit Transfer(address(0), owner(), _totalSupply);
612     }
613 
614     receive() external payable {}
615 
616     function decimals() external view override returns (uint8) {
617         return _decimals;
618     }
619 
620     function symbol() external view override returns (string memory) {
621         return _symbol;
622     }
623 
624     function name() external view override returns (string memory) {
625         return _name;
626     }
627 
628     function totalSupply() external view override returns (uint256) {
629         return _totalSupply;
630     }
631 
632     function balanceOf(address account)
633         external
634         view
635         override
636         returns (uint256)
637     {
638         return _balances[account];
639     }
640 
641     function transfer(address recipient, uint256 amount)
642         external
643         override
644         returns (bool)
645     {
646         _transfer(_msgSender(), recipient, amount);
647         return true;
648     }
649 
650     function allowance(address owner, address spender)
651         external
652         view
653         override
654         returns (uint256)
655     {
656         return _allowances[owner][spender];
657     }
658 
659     function approve(address spender, uint256 amount)
660         external
661         override
662         returns (bool)
663     {
664         _approve(_msgSender(), spender, amount);
665         return true;
666     }
667 
668     function transferFrom(
669         address sender,
670         address recipient,
671         uint256 amount
672     ) external override returns (bool) {
673         _transfer(sender, recipient, amount);
674         _approve(
675             sender,
676             _msgSender(),
677             _allowances[sender][_msgSender()].sub(
678                 amount,
679                 "ERC20: transfer amount exceeds allowance"
680             )
681         );
682         return true;
683     }
684 
685     function increaseAllowance(address spender, uint256 addedValue)
686         public
687         returns (bool)
688     {
689         _approve(
690             _msgSender(),
691             spender,
692             _allowances[_msgSender()][spender].add(addedValue)
693         );
694         return true;
695     }
696 
697     function decreaseAllowance(address spender, uint256 subtractedValue)
698         public
699         returns (bool)
700     {
701         _approve(
702             _msgSender(),
703             spender,
704             _allowances[_msgSender()][spender].sub(
705                 subtractedValue,
706                 "ERC20: decreased allowance below zero"
707             )
708         );
709         return true;
710     }
711 
712     function _approve(
713         address owner,
714         address spender,
715         uint256 amount
716     ) internal {
717         require(owner != address(0), "ERC20: approve from the zero address");
718         require(spender != address(0), "ERC20: approve to the zero address");
719 
720         _allowances[owner][spender] = amount;
721         emit Approval(owner, spender, amount);
722     }
723 
724     function excludeFromFee(address account) public onlyOwner {
725         _isExcludedFromFee[account] = true;
726     }
727 
728     function includeInFee(address account) public onlyOwner {
729         _isExcludedFromFee[account] = false;
730     }
731 
732     function setTaxFeePercent(uint256 taxFee) external onlyOwner {
733         _taxFee = taxFee;
734     }
735 
736     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner {
737         _liquidityFee = liquidityFee;
738     }
739 
740     function setMinTokensToAddToLiquidity(uint256 minTokensToAddToLiquidity)
741         external
742         onlyOwner
743     {
744         _minTokensToAddToLiquidity = minTokensToAddToLiquidity;
745     }
746 
747     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
748         swapAndLiquifyEnabled = _enabled;
749         emit SwapAndLiquifyEnabledUpdated(_enabled);
750     }
751 
752     function setBuyback(
753         bool _state,
754         uint256 _upperAmount,
755         uint256 _lowerAmount
756     ) public onlyOwner {
757         buyBackEnabled = _state;
758         buyBackUpperLimit = _upperAmount;
759         buyBackLowerLimit = _lowerAmount;
760     }
761 
762     function setProviderAddress(address newProviderAddress) external onlyOwner {
763         // Remove the current provider from Tax Exclusion List.
764         includeInFee(providerAddress);
765 
766         // Remove the current provider from Tax Exclusion List.
767         excludeFromFee(newProviderAddress);
768 
769         providerAddress = newProviderAddress;
770     }
771 
772     function startTrading() external onlyOwner {
773         require(!_tradingOpen, "Tradiing already enabled");
774         _tradingOpen = true;
775         swapAndLiquifyEnabled = true;
776         buyBackEnabled = true;
777 
778         emit SwapAndLiquifyEnabledUpdated(true);
779         emit BuyBackEnabledUpdated(true);
780     }
781 
782     function _transfer(
783         address sender,
784         address recipient,
785         uint256 amount
786     ) internal {
787         require(sender != address(0), "ERC20: transfer from the zero address");
788         require(recipient != address(0), "ERC20: transfer to the zero address");
789         require(amount > 0, "Transfer amount must be greater than zero");
790         require(_balances[sender] >= amount, "Transfer amount exceeds balance");
791 
792         if (!_tradingOpen && sender != owner() && recipient != owner()) {
793             require(
794                 sender != uniswapV2Pair && recipient != uniswapV2Pair,
795                 "Trading is not enabled"
796             );
797         }
798 
799         uint256 totalFee = 0;
800 
801         if (!_isExcludedFromFee[sender] && !_isExcludedFromFee[recipient]) {
802             // Take tax of transaction and transfer to the provider wallet.
803             uint256 taxFeeAmount = amount.mul(_taxFee).div(10000);
804             _balances[providerAddress] = _balances[providerAddress].add(
805                 taxFeeAmount
806             );
807             emit Transfer(sender, providerAddress, taxFeeAmount);
808 
809             // Take tax of transaction and add to liquidity.
810             uint256 liquidityFeeAmount = amount.mul(_liquidityFee).div(10000);
811             _balances[address(this)] = _balances[address(this)].add(
812                 liquidityFeeAmount
813             );
814             emit Transfer(sender, address(this), liquidityFeeAmount);
815 
816             // is the token balance of this contract address over the min number of
817             // tokens that we need to initiate a swap + liquidity lock?
818             // also, don't get caught in a circular liquidity event.
819             // also, don't swap & liquify if sender is uniswap pair.
820             uint256 contractTokenBalance = _balances[address(this)];
821 
822             bool overMinTokenBalance = contractTokenBalance >=
823                 _minTokensToAddToLiquidity;
824             if (
825                 overMinTokenBalance &&
826                 !inSwapAndLiquify &&
827                 sender != uniswapV2Pair &&
828                 swapAndLiquifyEnabled
829             ) {
830                 contractTokenBalance = _minTokensToAddToLiquidity;
831                 //add liquidity
832                 swapAndLiquify(contractTokenBalance);
833             }
834 
835             totalFee = taxFeeAmount.add(liquidityFeeAmount);
836         }
837 
838         _balances[sender] = _balances[sender].sub(amount);
839         _balances[recipient] = _balances[recipient].add(amount.sub(totalFee));
840         emit Transfer(sender, recipient, amount.sub(totalFee));
841     }
842 
843     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
844         // split the contract balance into halves
845         uint256 half = contractTokenBalance.div(2);
846         uint256 otherHalf = contractTokenBalance.sub(half);
847 
848         // capture the contract's current ETH balance.
849         // this is so that we can capture exactly the amount of ETH that the
850         // swap creates, and not make the liquidity event include any ETH that
851         // has been manually sent to the contract
852         uint256 initialBalance = address(this).balance;
853 
854         // now is to lock into liquidity pool
855         Utils.swapTokensForEth(address(uniswapV2Router), half);
856 
857         // how much ETH did we just swap into?
858         uint256 newBalance = address(this).balance.sub(initialBalance);
859 
860         // add liquidity to uniswap
861         Utils.addLiquidity(
862             address(uniswapV2Router),
863             owner(),
864             otherHalf,
865             newBalance
866         );
867 
868         // buy back if balance bnb is exceed lower limit
869         if (buyBackEnabled && initialBalance > uint256(buyBackLowerLimit)) {
870             if (initialBalance > buyBackUpperLimit)
871                 initialBalance = buyBackUpperLimit;
872             Utils.swapETHForTokens(
873                 address(uniswapV2Router),
874                 address(this),
875                 initialBalance.div(10)
876             );
877 
878             emit BuyBack(address(this), initialBalance.div(10));
879         }
880 
881         emit SwapAndLiquify(half, newBalance, otherHalf);
882     }
883 }
884 
885 library SafeMath {
886     function add(uint256 a, uint256 b) internal pure returns (uint256) {
887         uint256 c = a + b;
888         require(c >= a, "SafeMath: addition overflow");
889 
890         return c;
891     }
892 
893     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
894         return sub(a, b, "SafeMath: subtraction overflow");
895     }
896 
897     function sub(
898         uint256 a,
899         uint256 b,
900         string memory errorMessage
901     ) internal pure returns (uint256) {
902         require(b <= a, errorMessage);
903         uint256 c = a - b;
904 
905         return c;
906     }
907 
908     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
909         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
910         // benefit is lost if 'b' is also tested.
911         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
912         if (a == 0) {
913             return 0;
914         }
915 
916         uint256 c = a * b;
917         require(c / a == b, "SafeMath: multiplication overflow");
918 
919         return c;
920     }
921 
922     function div(uint256 a, uint256 b) internal pure returns (uint256) {
923         return div(a, b, "SafeMath: division by zero");
924     }
925 
926     function div(
927         uint256 a,
928         uint256 b,
929         string memory errorMessage
930     ) internal pure returns (uint256) {
931         require(b > 0, errorMessage);
932         uint256 c = a / b;
933         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
934 
935         return c;
936     }
937 
938     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
939         return mod(a, b, "SafeMath: modulo by zero");
940     }
941 
942     function mod(
943         uint256 a,
944         uint256 b,
945         string memory errorMessage
946     ) internal pure returns (uint256) {
947         require(b != 0, errorMessage);
948         return a % b;
949     }
950 }