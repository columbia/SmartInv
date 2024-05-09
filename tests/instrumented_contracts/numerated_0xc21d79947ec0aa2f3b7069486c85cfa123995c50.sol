1 /*
2 * Tokenomics
3 
4   ____    ____ __   __          
5  |  _ \  / __ \\ \ / /    /\    
6  | |_) || |  | |\ V /    /  \   
7  |  _ < | |  | | > <    / /\ \  
8  | |_) || |__| |/ . \  / ____ \ 
9  |____/  \____//_/ \_\/_/    \_\                               
10 
11 
12 
13 * Main Contract (Contract): Boxa – Boxa Coin
14 * Name: Boxa Coin
15 * Symbol: BOXA
16 * Total Supply: 1,000,000,000
17 * Decimals: 18 
18 * ERC20 token
19 
20 * 6% marketing fee buy/sell
21 * 3% development fee buy/sell
22 * 0% reflection
23 * 3% liquidity buy/sell
24 */
25 
26 //SPDX-License-Identifier: MIT
27 
28 pragma solidity 0.8.9;
29 
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address payable) {
32         return payable(msg.sender);
33     }
34 
35     function _msgData() internal view virtual returns (bytes memory) {
36         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
37         return msg.data;
38     }
39 }
40 
41 interface IERC20 {
42     function totalSupply() external view returns (uint256);
43 
44     function balanceOf(address account) external view returns (uint256);
45 
46     function transfer(address recipient, uint256 amount)
47         external
48         returns (bool);
49 
50     function allowance(address owner, address spender)
51         external
52         view
53         returns (uint256);
54 
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     function transferFrom(
58         address sender,
59         address recipient,
60         uint256 amount
61     ) external returns (bool);
62 
63     event Transfer(address indexed from, address indexed to, uint256 value);
64     event Approval(
65         address indexed owner,
66         address indexed spender,
67         uint256 value
68     );
69 }
70 
71 library SafeMath {
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a, "SafeMath: addition overflow");
75 
76         return c;
77     }
78 
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         return sub(a, b, "SafeMath: subtraction overflow");
81     }
82 
83     function sub(
84         uint256 a,
85         uint256 b,
86         string memory errorMessage
87     ) internal pure returns (uint256) {
88         require(b <= a, errorMessage);
89         uint256 c = a - b;
90 
91         return c;
92     }
93 
94     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
95         if (a == 0) {
96             return 0;
97         }
98 
99         uint256 c = a * b;
100         require(c / a == b, "SafeMath: multiplication overflow");
101 
102         return c;
103     }
104 
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     function div(
110         uint256 a,
111         uint256 b,
112         string memory errorMessage
113     ) internal pure returns (uint256) {
114         require(b > 0, errorMessage);
115         uint256 c = a / b;
116         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
117 
118         return c;
119     }
120 
121     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
122         return mod(a, b, "SafeMath: modulo by zero");
123     }
124 
125     function mod(
126         uint256 a,
127         uint256 b,
128         string memory errorMessage
129     ) internal pure returns (uint256) {
130         require(b != 0, errorMessage);
131         return a % b;
132     }
133 }
134 
135 library Address {
136     function isContract(address account) internal view returns (bool) {
137         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
138         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
139         // for accounts without code, i.e. `keccak256('')`
140         bytes32 codehash;
141         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
142         // solhint-disable-next-line no-inline-assembly
143         assembly {
144             codehash := extcodehash(account)
145         }
146         return (codehash != accountHash && codehash != 0x0);
147     }
148 
149     function sendValue(address payable recipient, uint256 amount) internal {
150         require(
151             address(this).balance >= amount,
152             "Address: insufficient balance"
153         );
154 
155         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
156         (bool success, ) = recipient.call{value: amount}("");
157         require(
158             success,
159             "Address: unable to send value, recipient may have reverted"
160         );
161     }
162 
163     function functionCall(address target, bytes memory data)
164         internal
165         returns (bytes memory)
166     {
167         return functionCall(target, data, "Address: low-level call failed");
168     }
169 
170     function functionCall(
171         address target,
172         bytes memory data,
173         string memory errorMessage
174     ) internal returns (bytes memory) {
175         return _functionCallWithValue(target, data, 0, errorMessage);
176     }
177 
178     function functionCallWithValue(
179         address target,
180         bytes memory data,
181         uint256 value
182     ) internal returns (bytes memory) {
183         return
184             functionCallWithValue(
185                 target,
186                 data,
187                 value,
188                 "Address: low-level call with value failed"
189             );
190     }
191 
192     function functionCallWithValue(
193         address target,
194         bytes memory data,
195         uint256 value,
196         string memory errorMessage
197     ) internal returns (bytes memory) {
198         require(
199             address(this).balance >= value,
200             "Address: insufficient balance for call"
201         );
202         return _functionCallWithValue(target, data, value, errorMessage);
203     }
204 
205     function _functionCallWithValue(
206         address target,
207         bytes memory data,
208         uint256 weiValue,
209         string memory errorMessage
210     ) private returns (bytes memory) {
211         require(isContract(target), "Address: call to non-contract");
212 
213         (bool success, bytes memory returndata) = target.call{value: weiValue}(
214             data
215         );
216         if (success) {
217             return returndata;
218         } else {
219             if (returndata.length > 0) {
220                 assembly {
221                     let returndata_size := mload(returndata)
222                     revert(add(32, returndata), returndata_size)
223                 }
224             } else {
225                 revert(errorMessage);
226             }
227         }
228     }
229 }
230 
231 contract Ownable is Context {
232     address private _owner;
233     address private _previousOwner;
234     uint256 private _lockTime;
235 
236     event OwnershipTransferred(
237         address indexed previousOwner,
238         address indexed newOwner
239     );
240 
241     constructor() {
242         address msgSender = _msgSender();
243         _owner = msgSender;
244         emit OwnershipTransferred(address(0), msgSender);
245     }
246 
247     function owner() public view returns (address) {
248         return _owner;
249     }
250 
251     modifier onlyOwner() {
252         require(_owner == _msgSender(), "Ownable: caller is not the owner");
253         _;
254     }
255 
256     function renounceOwnership() public virtual onlyOwner {
257         emit OwnershipTransferred(_owner, address(0));
258         _owner = address(0);
259     }
260 
261     function transferOwnership(address newOwner) public virtual onlyOwner {
262         require(
263             newOwner != address(0),
264             "Ownable: new owner is the zero address"
265         );
266         emit OwnershipTransferred(_owner, newOwner);
267         _owner = newOwner;
268     }
269 
270     function getUnlockTime() public view returns (uint256) {
271         return _lockTime;
272     }
273 
274     function getTime() public view returns (uint256) {
275         return block.timestamp;
276     }
277 }
278 
279 
280 interface IUniswapV2Factory {
281     event PairCreated(
282         address indexed token0,
283         address indexed token1,
284         address pair,
285         uint256
286     );
287 
288     function feeTo() external view returns (address);
289 
290     function feeToSetter() external view returns (address);
291 
292     function getPair(address tokenA, address tokenB)
293         external
294         view
295         returns (address pair);
296 
297     function allPairs(uint256) external view returns (address pair);
298 
299     function allPairsLength() external view returns (uint256);
300 
301     function createPair(address tokenA, address tokenB)
302         external
303         returns (address pair);
304 
305     function setFeeTo(address) external;
306 
307     function setFeeToSetter(address) external;
308 }
309 
310 
311 interface IUniswapV2Pair {
312     event Approval(
313         address indexed owner,
314         address indexed spender,
315         uint256 value
316     );
317     event Transfer(address indexed from, address indexed to, uint256 value);
318 
319     function name() external pure returns (string memory);
320 
321     function symbol() external pure returns (string memory);
322 
323     function decimals() external pure returns (uint8);
324 
325     function totalSupply() external view returns (uint256);
326 
327     function balanceOf(address owner) external view returns (uint256);
328 
329     function allowance(address owner, address spender)
330         external
331         view
332         returns (uint256);
333 
334     function approve(address spender, uint256 value) external returns (bool);
335 
336     function transfer(address to, uint256 value) external returns (bool);
337 
338     function transferFrom(
339         address from,
340         address to,
341         uint256 value
342     ) external returns (bool);
343 
344     function DOMAIN_SEPARATOR() external view returns (bytes32);
345 
346     function PERMIT_TYPEHASH() external pure returns (bytes32);
347 
348     function nonces(address owner) external view returns (uint256);
349 
350     function permit(
351         address owner,
352         address spender,
353         uint256 value,
354         uint256 deadline,
355         uint8 v,
356         bytes32 r,
357         bytes32 s
358     ) external;
359 
360     event Burn(
361         address indexed sender,
362         uint256 amount0,
363         uint256 amount1,
364         address indexed to
365     );
366     event Swap(
367         address indexed sender,
368         uint256 amount0In,
369         uint256 amount1In,
370         uint256 amount0Out,
371         uint256 amount1Out,
372         address indexed to
373     );
374     event Sync(uint112 reserve0, uint112 reserve1);
375 
376     function MINIMUM_LIQUIDITY() external pure returns (uint256);
377 
378     function factory() external view returns (address);
379 
380     function token0() external view returns (address);
381 
382     function token1() external view returns (address);
383 
384     function getReserves()
385         external
386         view
387         returns (
388             uint112 reserve0,
389             uint112 reserve1,
390             uint32 blockTimestampLast
391         );
392 
393     function price0CumulativeLast() external view returns (uint256);
394 
395     function price1CumulativeLast() external view returns (uint256);
396 
397     function kLast() external view returns (uint256);
398 
399     function burn(address to)
400         external
401         returns (uint256 amount0, uint256 amount1);
402 
403     function swap(
404         uint256 amount0Out,
405         uint256 amount1Out,
406         address to,
407         bytes calldata data
408     ) external;
409 
410     function skim(address to) external;
411 
412     function sync() external;
413 
414     function initialize(address, address) external;
415 }
416 
417 interface IUniswapV2Router01 {
418     function factory() external pure returns (address);
419 
420     function WETH() external pure returns (address);
421 
422     function addLiquidity(
423         address tokenA,
424         address tokenB,
425         uint256 amountADesired,
426         uint256 amountBDesired,
427         uint256 amountAMin,
428         uint256 amountBMin,
429         address to,
430         uint256 deadline
431     )
432         external
433         returns (
434             uint256 amountA,
435             uint256 amountB,
436             uint256 liquidity
437         );
438 
439     function addLiquidityETH(
440         address token,
441         uint256 amountTokenDesired,
442         uint256 amountTokenMin,
443         uint256 amountETHMin,
444         address to,
445         uint256 deadline
446     )
447         external
448         payable
449         returns (
450             uint256 amountToken,
451             uint256 amountETH,
452             uint256 liquidity
453         );
454 
455     function removeLiquidity(
456         address tokenA,
457         address tokenB,
458         uint256 liquidity,
459         uint256 amountAMin,
460         uint256 amountBMin,
461         address to,
462         uint256 deadline
463     ) external returns (uint256 amountA, uint256 amountB);
464 
465     function removeLiquidityETH(
466         address token,
467         uint256 liquidity,
468         uint256 amountTokenMin,
469         uint256 amountETHMin,
470         address to,
471         uint256 deadline
472     ) external returns (uint256 amountToken, uint256 amountETH);
473 
474     function removeLiquidityWithPermit(
475         address tokenA,
476         address tokenB,
477         uint256 liquidity,
478         uint256 amountAMin,
479         uint256 amountBMin,
480         address to,
481         uint256 deadline,
482         bool approveMax,
483         uint8 v,
484         bytes32 r,
485         bytes32 s
486     ) external returns (uint256 amountA, uint256 amountB);
487 
488     function removeLiquidityETHWithPermit(
489         address token,
490         uint256 liquidity,
491         uint256 amountTokenMin,
492         uint256 amountETHMin,
493         address to,
494         uint256 deadline,
495         bool approveMax,
496         uint8 v,
497         bytes32 r,
498         bytes32 s
499     ) external returns (uint256 amountToken, uint256 amountETH);
500 
501     function swapExactTokensForTokens(
502         uint256 amountIn,
503         uint256 amountOutMin,
504         address[] calldata path,
505         address to,
506         uint256 deadline
507     ) external returns (uint256[] memory amounts);
508 
509     function swapTokensForExactTokens(
510         uint256 amountOut,
511         uint256 amountInMax,
512         address[] calldata path,
513         address to,
514         uint256 deadline
515     ) external returns (uint256[] memory amounts);
516 
517     function swapExactETHForTokens(
518         uint256 amountOutMin,
519         address[] calldata path,
520         address to,
521         uint256 deadline
522     ) external payable returns (uint256[] memory amounts);
523 
524     function swapTokensForExactETH(
525         uint256 amountOut,
526         uint256 amountInMax,
527         address[] calldata path,
528         address to,
529         uint256 deadline
530     ) external returns (uint256[] memory amounts);
531 
532     function swapExactTokensForETH(
533         uint256 amountIn,
534         uint256 amountOutMin,
535         address[] calldata path,
536         address to,
537         uint256 deadline
538     ) external returns (uint256[] memory amounts);
539 
540     function swapETHForExactTokens(
541         uint256 amountOut,
542         address[] calldata path,
543         address to,
544         uint256 deadline
545     ) external payable returns (uint256[] memory amounts);
546 
547     function quote(
548         uint256 amountA,
549         uint256 reserveA,
550         uint256 reserveB
551     ) external pure returns (uint256 amountB);
552 
553     function getAmountOut(
554         uint256 amountIn,
555         uint256 reserveIn,
556         uint256 reserveOut
557     ) external pure returns (uint256 amountOut);
558 
559     function getAmountIn(
560         uint256 amountOut,
561         uint256 reserveIn,
562         uint256 reserveOut
563     ) external pure returns (uint256 amountIn);
564 
565     function getAmountsOut(uint256 amountIn, address[] calldata path)
566         external
567         view
568         returns (uint256[] memory amounts);
569 
570     function getAmountsIn(uint256 amountOut, address[] calldata path)
571         external
572         view
573         returns (uint256[] memory amounts);
574 }
575 
576 interface IUniswapV2Router02 is IUniswapV2Router01 {
577     function removeLiquidityETHSupportingFeeOnTransferTokens(
578         address token,
579         uint256 liquidity,
580         uint256 amountTokenMin,
581         uint256 amountETHMin,
582         address to,
583         uint256 deadline
584     ) external returns (uint256 amountETH);
585 
586     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
587         address token,
588         uint256 liquidity,
589         uint256 amountTokenMin,
590         uint256 amountETHMin,
591         address to,
592         uint256 deadline,
593         bool approveMax,
594         uint8 v,
595         bytes32 r,
596         bytes32 s
597     ) external returns (uint256 amountETH);
598 
599     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
600         uint256 amountIn,
601         uint256 amountOutMin,
602         address[] calldata path,
603         address to,
604         uint256 deadline
605     ) external;
606 
607     function swapExactETHForTokensSupportingFeeOnTransferTokens(
608         uint256 amountOutMin,
609         address[] calldata path,
610         address to,
611         uint256 deadline
612     ) external payable;
613 
614     function swapExactTokensForETHSupportingFeeOnTransferTokens(
615         uint256 amountIn,
616         uint256 amountOutMin,
617         address[] calldata path,
618         address to,
619         uint256 deadline
620     ) external;
621 }
622 
623 contract BoxaToken is Context, IERC20, Ownable {
624     using SafeMath for uint256;
625     using Address for address;
626 
627     address payable public marketingAddress = payable(0x7D3c6ba14799E87fA29Ec6B9493aCCa9b517F6E6); // Marketing fee Address
628     address payable public devAddress = payable(0x5662392910d09c8d0AA7853c0cC45E84c3890c61); // development fee Address
629     address payable public rewardAddress = payable(0x3999d2a2cCA6D61473cEA8D705059EfE67835c29); // Reward Address
630     address payable public liquidityAddress = payable(0x3999d2a2cCA6D61473cEA8D705059EfE67835c29); // Liquidity Address, owner address
631 
632     mapping(address => uint256) private _rOwned;
633     mapping(address => uint256) private _tOwned;
634     mapping(address => mapping(address => uint256)) private _allowances;
635 
636     mapping(address => bool) private _isExcludedFromFee;
637 
638     mapping(address => bool) private _isExcluded;
639     address[] private _excluded;
640 
641     uint256 private constant MAX = ~uint256(0);
642     uint256 private constant _tTotal = 1 * 1e9 * 1e18;
643     uint256 private _rTotal = (MAX - (MAX % _tTotal));
644     uint256 private _tFeeTotal;
645 
646     string private constant _name = "Boxa Coin";
647     string private constant _symbol = "BOXA";
648     uint8 private constant _decimals = 18;
649 
650     uint256 private constant BUY = 1;
651     uint256 private constant SELL = 2;
652     uint256 private constant TRANSFER = 3;
653     uint256 private buyOrSellSwitch;
654 
655     uint256 public manualBurnFrequency = 30 minutes;
656     uint256 public lastManualLpBurnTime;
657 
658     uint256 private _taxFee;
659     uint256 private _previousTaxFee = _taxFee;
660 
661     uint256 private _liquidityFee;
662     uint256 private _previousLiquidityFee = _liquidityFee;
663 
664     uint256 public _buyTaxFee = 0;          // reflection fee 0%
665     uint256 public _buyLiquidityFee = 3;    // liqudity fee in buying case 3%
666     uint256 public _buyRewardFee = 0;       // burn fee in buying case 2%
667     uint256 public _buyMarketingFee = 6;    // marketing fee in buying case 6%
668     uint256 public _buyDevFee = 3;          // development fee in buying case 2%
669 
670     uint256 public _sellTaxFee = 0;         // reflection fee 0%
671     uint256 public _sellLiquidityFee = 3;   // liqudity fee in buying case 3%
672     uint256 public _sellRewardFee = 0;      // burn fee in buying case 2%
673     uint256 public _sellMarketingFee = 6;   // marketing fee in buying case 6%
674     uint256 public _sellDevFee = 3;         // development fee in buying case 2%    
675 
676     uint256 public liquidityActiveBlock;    // 0 means liquidity is not active yet
677     uint256 public tradingActiveBlock;      // 0 means trading is not active
678     uint256 public deadBlocks;
679 
680     bool public limitsInEffect = true;
681     bool public tradingActive = false;
682     bool public swapEnabled = false;
683 
684     mapping (address => bool) public _isExcludedMaxTransactionAmount;
685 
686      // Anti-bot and anti-whale mappings and variables
687     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
688     bool public transferDelayEnabled = true;
689 
690     uint256 private _liquidityTokensToSwap;
691     uint256 private _rewardTokens;
692     uint256 private _marketingTokensToSwap;
693     uint256 private _devTokensToSwap;
694 
695     bool private gasLimitActive = true;
696     uint256 private gasPriceLimit = 602 * 1 gwei;
697 
698     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
699     // could be subject to a maximum transfer amount
700     mapping (address => bool) public automatedMarketMakerPairs;
701     mapping (address => bool) private _isSniper;
702 
703     uint256 public minimumTokensBeforeSwap;
704     uint256 public maxTransactionAmount;
705     uint256 public maxWallet;
706 
707     IUniswapV2Router02 public uniswapV2Router;
708     address public uniswapV2Pair;
709 
710     bool inSwapAndLiquify;
711     bool public swapAndLiquifyEnabled = false;
712 
713     event RewardLiquidityProviders(uint256 tokenAmount);
714     event SwapAndLiquifyEnabledUpdated(bool enabled);
715     event SwapAndLiquify(
716         uint256 tokensSwapped,
717         uint256 ethReceived,
718         uint256 tokensIntoLiqudity
719     );
720 
721     event SwapETHForTokens(uint256 amountIn, address[] path);
722 
723     event SwapTokensForETH(uint256 amountIn, address[] path);
724 
725     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
726 
727     event ManualBurnLP();
728 
729     modifier lockTheSwap() {
730         inSwapAndLiquify = true;
731         _;
732         inSwapAndLiquify = false;
733     }
734 
735     constructor() {
736         address newOwner = msg.sender; // update if auto-deploying to a different wallet        
737 
738         deadBlocks = 2;
739 
740         maxTransactionAmount = _tTotal * 50 / 10000; // 0.5% max txn
741         minimumTokensBeforeSwap = _tTotal * 5 / 10000; // 0.05%
742         maxWallet = _tTotal * 100 / 10000; // 1%
743 
744         _rOwned[newOwner] = _rTotal;
745 
746         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
747             // Ethereum and Rinkeby
748             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
749         );
750 
751         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
752             .createPair(address(this), _uniswapV2Router.WETH());
753 
754         uniswapV2Router = _uniswapV2Router;
755         uniswapV2Pair = _uniswapV2Pair;
756 
757         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
758 
759         _isExcludedFromFee[newOwner] = true;
760         _isExcludedFromFee[address(this)] = true;
761         _isExcludedFromFee[liquidityAddress] = true;
762 
763         excludeFromMaxTransaction(newOwner, true);
764         excludeFromMaxTransaction(address(this), true);
765         excludeFromMaxTransaction(address(_uniswapV2Router), true);
766         excludeFromMaxTransaction(address(0xdead), true);
767 
768         emit Transfer(address(0), newOwner, _tTotal);
769     }
770 
771     function name() external pure returns (string memory) {
772         return _name;
773     }
774 
775     function symbol() external pure returns (string memory) {
776         return _symbol;
777     }
778 
779     function decimals() external pure returns (uint8) {
780         return _decimals;
781     }
782 
783     function totalSupply() external pure override returns (uint256) {
784         return _tTotal;
785     }
786 
787     function balanceOf(address account) public view override returns (uint256) {
788         if (_isExcluded[account]) return _tOwned[account];
789         return tokenFromReflection(_rOwned[account]);
790     }
791 
792     function transfer(address recipient, uint256 amount)
793         external
794         override
795         returns (bool)
796     {
797         _transfer(_msgSender(), recipient, amount);
798         return true;
799     }
800 
801     function allowance(address owner, address spender)
802         external
803         view
804         override
805         returns (uint256)
806     {
807         return _allowances[owner][spender];
808     }
809 
810     function approve(address spender, uint256 amount)
811         public
812         override
813         returns (bool)
814     {
815         _approve(_msgSender(), spender, amount);
816         return true;
817     }
818 
819     function transferFrom(
820         address sender,
821         address recipient,
822         uint256 amount
823     ) external override returns (bool) {
824         _transfer(sender, recipient, amount);
825         _approve(
826             sender,
827             _msgSender(),
828             _allowances[sender][_msgSender()].sub(
829                 amount,
830                 "ERC20: transfer amount exceeds allowance"
831             )
832         );
833         return true;
834     }
835 
836     function increaseAllowance(address spender, uint256 addedValue)
837         external
838         virtual
839         returns (bool)
840     {
841         _approve(
842             _msgSender(),
843             spender,
844             _allowances[_msgSender()][spender].add(addedValue)
845         );
846         return true;
847     }
848 
849     function decreaseAllowance(address spender, uint256 subtractedValue)
850         external
851         virtual
852         returns (bool)
853     {
854         _approve(
855             _msgSender(),
856             spender,
857             _allowances[_msgSender()][spender].sub(
858                 subtractedValue,
859                 "ERC20: decreased allowance below zero"
860             )
861         );
862         return true;
863     }
864 
865     function isExcludedFromReward(address account)
866         external
867         view
868         returns (bool)
869     {
870         return _isExcluded[account];
871     }
872 
873     function totalFees() external view returns (uint256) {
874         return _tFeeTotal;
875     }
876 
877     // once enabled, can never be turned off
878     function enableTrading(uint256 _deadBlocks) external onlyOwner {
879         tradingActive = true;
880         swapAndLiquifyEnabled = true;
881         tradingActiveBlock = block.number;
882         deadBlocks = _deadBlocks;
883     }
884 
885     function isSniper(address account) public view returns (bool) {
886         return _isSniper[account];
887     }
888     
889     function manageSnipers(address[] calldata addresses, bool status) public onlyOwner {
890         for (uint256 i; i < addresses.length; ++i) {
891             _isSniper[addresses[i]] = status;
892         }
893     }
894 
895     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
896         return minimumTokensBeforeSwap;
897     }
898 
899     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
900         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
901 
902         _setAutomatedMarketMakerPair(pair, value);
903     }
904 
905     function _setAutomatedMarketMakerPair(address pair, bool value) private {
906         automatedMarketMakerPairs[pair] = value;
907 
908         excludeFromMaxTransaction(pair, value);
909         if(value){excludeFromReward(pair);}
910         if(!value){includeInReward(pair);}
911     }
912 
913     function setProtectionSettings(bool antiGas) external onlyOwner() {
914         gasLimitActive = antiGas;
915     }
916 
917     function setGasPriceLimit(uint256 gas) external onlyOwner {
918         require(gas >= 300);
919         gasPriceLimit = gas * 1 gwei;
920     }
921 
922     // disable Transfer delay
923     function disableTransferDelay() external onlyOwner returns (bool){
924         transferDelayEnabled = false;
925         return true;
926     }
927 
928     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
929         external
930         view
931         returns (uint256)
932     {
933         require(tAmount <= _tTotal, "Amount must be less than supply");
934         if (!deductTransferFee) {
935             (uint256 rAmount, , , , , ) = _getValues(tAmount);
936             return rAmount;
937         } else {
938             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
939             return rTransferAmount;
940         }
941     }
942 
943     // for one-time airdrop feature after contract launch
944     function airdropToWallets(address[] memory airdropWallets, uint256[] memory amount) external onlyOwner() {
945         require(airdropWallets.length == amount.length, "airdropToWallets:: Arrays must be the same length");
946         removeAllFee();
947         buyOrSellSwitch = TRANSFER;
948         for(uint256 i = 0; i < airdropWallets.length; i++){
949             address wallet = airdropWallets[i];
950             uint256 airdropAmount = amount[i];
951             _tokenTransfer(msg.sender, wallet, airdropAmount);
952         }
953         restoreAllFee();
954     }
955 
956     // remove limits after token is stable - 30-60 minutes
957     function removeLimits() external onlyOwner returns (bool){
958         limitsInEffect = false;
959         gasLimitActive = false;
960         transferDelayEnabled = false;
961         return true;
962     }
963 
964     function tokenFromReflection(uint256 rAmount)
965         public
966         view
967         returns (uint256)
968     {
969         require(
970             rAmount <= _rTotal,
971             "Amount must be less than total reflections"
972         );
973         uint256 currentRate = _getRate();
974         return rAmount.div(currentRate);
975     }
976 
977     function excludeFromReward(address account) public onlyOwner {
978         require(!_isExcluded[account], "Account is already excluded");
979         require(_excluded.length + 1 <= 50, "Cannot exclude more than 50 accounts.  Include a previously excluded address.");
980         if (_rOwned[account] > 0) {
981             _tOwned[account] = tokenFromReflection(_rOwned[account]);
982         }
983         _isExcluded[account] = true;
984         _excluded.push(account);
985     }
986 
987     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
988         _isExcludedMaxTransactionAmount[updAds] = isEx;
989         emit ExcludedMaxTransactionAmount(updAds, isEx);
990     }
991 
992     function includeInReward(address account) public onlyOwner {
993         require(_isExcluded[account], "Account is not excluded");
994         for (uint256 i = 0; i < _excluded.length; i++) {
995             if (_excluded[i] == account) {
996                 _excluded[i] = _excluded[_excluded.length - 1];
997                 _tOwned[account] = 0;
998                 _isExcluded[account] = false;
999                 _excluded.pop();
1000                 break;
1001             }
1002         }
1003     }
1004 
1005     function _approve(
1006         address owner,
1007         address spender,
1008         uint256 amount
1009     ) private {
1010         require(owner != address(0), "ERC20: approve from the zero address");
1011         require(spender != address(0), "ERC20: approve to the zero address");
1012 
1013         _allowances[owner][spender] = amount;
1014         emit Approval(owner, spender, amount);
1015     }
1016 
1017     function _transfer(
1018         address from,
1019         address to,
1020         uint256 amount
1021     ) private {
1022         require(from != address(0), "ERC20: transfer from the zero address");
1023         require(to != address(0), "ERC20: transfer to the zero address");
1024         // require(!_isSniper[to], "You have no power here!");
1025         // require(!_isSniper[from], "You have no power here!");
1026         require(amount > 0, "Transfer amount must be greater than zero");
1027 
1028         if(limitsInEffect){
1029             if (
1030                 from != owner() &&
1031                 to != owner() &&
1032                 to != address(0) &&
1033                 to != address(0xdead) &&
1034                 !inSwapAndLiquify
1035             ){
1036 
1037                 require(tradingActive, "Trading is not enabled yet");
1038 
1039                 // only use to prevent sniper buys in the first blocks.
1040                 if (gasLimitActive && automatedMarketMakerPairs[from]) {
1041                     require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
1042                 }
1043 
1044                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1045                 if (transferDelayEnabled){
1046                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1047                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1048                         _holderLastTransferTimestamp[tx.origin] = block.number;
1049                     }
1050                 }
1051 
1052                 //when buy
1053                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1054                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1055                     require(amount + balanceOf(to) <= maxWallet, "Cannot exceed max wallet");
1056                 }
1057                 //when sell
1058                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1059                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1060                 }
1061                 else if (!_isExcludedMaxTransactionAmount[to]){
1062                     require(amount + balanceOf(to) <= maxWallet, "Cannot exceed max wallet");
1063                 }
1064             }
1065         }
1066 
1067         uint256 contractTokenBalance = balanceOf(address(this));
1068         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
1069 
1070         // Sell tokens for ETH
1071         if (
1072             !inSwapAndLiquify &&
1073             swapAndLiquifyEnabled &&
1074             balanceOf(uniswapV2Pair) > 0 &&
1075             overMinimumTokenBalance &&
1076             automatedMarketMakerPairs[to]
1077         ) {
1078             swapBack();
1079         }
1080 
1081         removeAllFee();
1082 
1083         buyOrSellSwitch = TRANSFER;
1084 
1085         // If any account belongs to _isExcludedFromFee account then remove the fee
1086         if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
1087             // Buy
1088             if (automatedMarketMakerPairs[from]) {
1089                 _taxFee = _buyTaxFee;
1090                 _liquidityFee = _buyLiquidityFee + _buyRewardFee + _buyMarketingFee + _buyDevFee;
1091                 if(_liquidityFee > 0){
1092                     buyOrSellSwitch = BUY;
1093                 }
1094             }
1095             // Sell
1096             else if (automatedMarketMakerPairs[to]) {
1097                 _taxFee = _sellTaxFee;
1098                 _liquidityFee = _sellLiquidityFee + _sellRewardFee + _sellMarketingFee + _sellDevFee;
1099                 if(_liquidityFee > 0){
1100                     buyOrSellSwitch = SELL;
1101                 }
1102             }
1103         }
1104 
1105         _tokenTransfer(from, to, amount);
1106 
1107         restoreAllFee();
1108 
1109     }
1110     
1111     // change the minimum amount of tokens to sell from fees
1112     function updateSwapTokensAtPercent(uint256 percent) external onlyOwner returns (bool){
1113   	    require(percent >= 1, "Swap amount cannot be lower than 0.001% total supply.");
1114   	    require(percent <= 50, "Swap amount cannot be higher than 0.5% total supply.");
1115   	    minimumTokensBeforeSwap = _tTotal * percent / 10000;
1116   	    return true;
1117   	}
1118 
1119     function updateMaxTxnPercent(uint256 percent) external onlyOwner {
1120         require(percent >= 10, "Cannot set maxTransactionAmount lower than 0.1%");
1121         maxTransactionAmount = _tTotal * percent / 10000;
1122     }
1123 
1124     // percent 25 for .25%
1125     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1126         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1127         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1128         lastManualLpBurnTime = block.timestamp;
1129         
1130         // get balance of liquidity pair
1131         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1132         
1133         // calculate amount to burn
1134         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1135         
1136         // pull tokens from pancakePair liquidity and move to dead address permanently
1137         if (amountToBurn > 0){
1138             _transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1139         }
1140         
1141         //sync price since this is not in a swap transaction!
1142         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1143         pair.sync();
1144         emit ManualBurnLP();
1145         return true;
1146     }
1147 
1148     function swapBack() private lockTheSwap {
1149         uint256 contractBalance = balanceOf(address(this));
1150         bool success;
1151         uint256 totalTokensToSwap = _liquidityTokensToSwap + _rewardTokens + _marketingTokensToSwap + _devTokensToSwap;
1152         if(totalTokensToSwap == 0 || contractBalance == 0) {return;}
1153 
1154         uint256 tokensForLiquidity = (contractBalance * _liquidityTokensToSwap / totalTokensToSwap) / 2;
1155         uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity).sub(_rewardTokens);
1156 
1157         uint256 initialETHBalance = address(this).balance;
1158 
1159         swapTokensForETH(amountToSwapForETH);
1160 
1161         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1162 
1163         uint256 ethForMarketing = ethBalance.mul(_marketingTokensToSwap).div(totalTokensToSwap);
1164 
1165         uint256 ethForDev = ethBalance.mul(_devTokensToSwap).div(totalTokensToSwap);
1166 
1167         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1168 
1169         // Transfer rewards token to reward wallet
1170         uint256 currentRate = _getRate();
1171         uint256 rReward = _rewardTokens.mul(currentRate);
1172         _rOwned[address(rewardAddress)] = _rOwned[address(rewardAddress)].add(rReward);
1173         _tOwned[address(rewardAddress)] = _tOwned[address(rewardAddress)].add(_rewardTokens);
1174 
1175         _liquidityTokensToSwap = 0;
1176         _rewardTokens = 0;
1177         _marketingTokensToSwap = 0;
1178         _devTokensToSwap = 0;
1179 
1180         if(tokensForLiquidity > 0 && ethForLiquidity > 0){
1181             addLiquidity(tokensForLiquidity, ethForLiquidity);
1182             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1183         }
1184 
1185         (success,) = address(marketingAddress).call{value: address(this).balance.sub(ethForDev)}("");
1186         (success,) = address(devAddress).call{value: ethForDev}("");
1187 
1188     }
1189 
1190     function swapTokensForETH(uint256 tokenAmount) private {
1191         address[] memory path = new address[](2);
1192         path[0] = address(this);
1193         path[1] = uniswapV2Router.WETH();
1194         _approve(address(this), address(uniswapV2Router), tokenAmount);
1195         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1196             tokenAmount,
1197             0, // accept any amount of ETH
1198             path,
1199             address(this),
1200             block.timestamp
1201         );
1202     }
1203 
1204     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1205         _approve(address(this), address(uniswapV2Router), tokenAmount);
1206         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1207             address(this),
1208             tokenAmount,
1209             0, // slippage is unavoidable
1210             0, // slippage is unavoidable
1211             liquidityAddress,
1212             block.timestamp
1213         );
1214     }
1215 
1216     function _tokenTransfer(
1217         address sender,
1218         address recipient,
1219         uint256 amount
1220     ) private {
1221 
1222         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1223             _transferFromExcluded(sender, recipient, amount);
1224         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1225             _transferToExcluded(sender, recipient, amount);
1226         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1227             _transferBothExcluded(sender, recipient, amount);
1228         } else {
1229             _transferStandard(sender, recipient, amount);
1230         }
1231     }
1232 
1233     function _transferStandard(
1234         address sender,
1235         address recipient,
1236         uint256 tAmount
1237     ) private {
1238         (
1239             uint256 rAmount,
1240             uint256 rTransferAmount,
1241             uint256 rFee,
1242             uint256 tTransferAmount,
1243             uint256 tFee,
1244             uint256 tLiquidity
1245         ) = _getValues(tAmount);
1246         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1247         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1248         _takeLiquidity(tLiquidity);
1249         _reflectFee(rFee, tFee);
1250         emit Transfer(sender, recipient, tTransferAmount);
1251     }
1252 
1253     function _transferToExcluded(
1254         address sender,
1255         address recipient,
1256         uint256 tAmount
1257     ) private {
1258         (
1259             uint256 rAmount,
1260             uint256 rTransferAmount,
1261             uint256 rFee,
1262             uint256 tTransferAmount,
1263             uint256 tFee,
1264             uint256 tLiquidity
1265         ) = _getValues(tAmount);
1266         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1267         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1268         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1269         _takeLiquidity(tLiquidity);
1270         _reflectFee(rFee, tFee);
1271         emit Transfer(sender, recipient, tTransferAmount);
1272     }
1273 
1274     function _transferFromExcluded(
1275         address sender,
1276         address recipient,
1277         uint256 tAmount
1278     ) private {
1279         (
1280             uint256 rAmount,
1281             uint256 rTransferAmount,
1282             uint256 rFee,
1283             uint256 tTransferAmount,
1284             uint256 tFee,
1285             uint256 tLiquidity
1286         ) = _getValues(tAmount);
1287         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1288         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1289         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1290         _takeLiquidity(tLiquidity);
1291         _reflectFee(rFee, tFee);
1292         emit Transfer(sender, recipient, tTransferAmount);
1293     }
1294 
1295     function _transferBothExcluded(
1296         address sender,
1297         address recipient,
1298         uint256 tAmount
1299     ) private {
1300         (
1301             uint256 rAmount,
1302             uint256 rTransferAmount,
1303             uint256 rFee,
1304             uint256 tTransferAmount,
1305             uint256 tFee,
1306             uint256 tLiquidity
1307         ) = _getValues(tAmount);
1308         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1309         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1310         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1311         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1312         _takeLiquidity(tLiquidity);
1313         _reflectFee(rFee, tFee);
1314         emit Transfer(sender, recipient, tTransferAmount);
1315     }
1316 
1317     function _reflectFee(uint256 rFee, uint256 tFee) private {
1318         _rTotal = _rTotal.sub(rFee);
1319         _tFeeTotal = _tFeeTotal.add(tFee);
1320     }
1321 
1322     function _getValues(uint256 tAmount)
1323         private
1324         view
1325         returns (
1326             uint256,
1327             uint256,
1328             uint256,
1329             uint256,
1330             uint256,
1331             uint256
1332         )
1333     {
1334         (
1335             uint256 tTransferAmount,
1336             uint256 tFee,
1337             uint256 tLiquidity
1338         ) = _getTValues(tAmount);
1339         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1340             tAmount,
1341             tFee,
1342             tLiquidity,
1343             _getRate()
1344         );
1345         return (
1346             rAmount,
1347             rTransferAmount,
1348             rFee,
1349             tTransferAmount,
1350             tFee,
1351             tLiquidity
1352         );
1353     }
1354 
1355     function _getTValues(uint256 tAmount)
1356         private
1357         view
1358         returns (
1359             uint256,
1360             uint256,
1361             uint256
1362         )
1363     {
1364         uint256 tFee = calculateTaxFee(tAmount);
1365         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1366         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1367         return (tTransferAmount, tFee, tLiquidity);
1368     }
1369 
1370     function _getRValues(
1371         uint256 tAmount,
1372         uint256 tFee,
1373         uint256 tLiquidity,
1374         uint256 currentRate
1375     )
1376         private
1377         pure
1378         returns (
1379             uint256,
1380             uint256,
1381             uint256
1382         )
1383     {
1384         uint256 rAmount = tAmount.mul(currentRate);
1385         uint256 rFee = tFee.mul(currentRate);
1386         uint256 rLiquidity = tLiquidity.mul(currentRate);
1387         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1388         return (rAmount, rTransferAmount, rFee);
1389     }
1390 
1391     function _getRate() private view returns (uint256) {
1392         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1393         return rSupply.div(tSupply);
1394     }
1395 
1396     function _getCurrentSupply() private view returns (uint256, uint256) {
1397         uint256 rSupply = _rTotal;
1398         uint256 tSupply = _tTotal;
1399         for (uint256 i = 0; i < _excluded.length; i++) {
1400             if (
1401                 _rOwned[_excluded[i]] > rSupply ||
1402                 _tOwned[_excluded[i]] > tSupply
1403             ) return (_rTotal, _tTotal);
1404             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1405             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1406         }
1407         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1408         return (rSupply, tSupply);
1409     }
1410 
1411     function _takeLiquidity(uint256 tLiquidity) private {
1412         if(buyOrSellSwitch == BUY){
1413             _liquidityTokensToSwap += tLiquidity * _buyLiquidityFee / _liquidityFee;
1414             _rewardTokens += tLiquidity * _buyRewardFee / _liquidityFee;
1415             _marketingTokensToSwap += tLiquidity * _buyMarketingFee / _liquidityFee;
1416             _devTokensToSwap += tLiquidity * _buyDevFee / _liquidityFee;
1417         } else if(buyOrSellSwitch == SELL){
1418             _liquidityTokensToSwap += tLiquidity * _sellLiquidityFee / _liquidityFee;
1419             _rewardTokens += tLiquidity * _sellRewardFee / _liquidityFee;
1420             _marketingTokensToSwap += tLiquidity * _sellMarketingFee / _liquidityFee;
1421             _devTokensToSwap += tLiquidity * _sellDevFee / _liquidityFee;
1422         }
1423         
1424         uint256 currentRate = _getRate();
1425         uint256 rLiquidity = tLiquidity.mul(currentRate);
1426         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1427         if (_isExcluded[address(this)])
1428             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1429     }
1430 
1431     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1432         return _amount.mul(_taxFee).div(10**2);
1433     }
1434 
1435     function calculateLiquidityFee(uint256 _amount)
1436         private
1437         view
1438         returns (uint256)
1439     {
1440         return _amount.mul(_liquidityFee).div(10**2);
1441     }
1442 
1443     function removeAllFee() private {
1444         if (_taxFee == 0 && _liquidityFee == 0) return;
1445 
1446         _previousTaxFee = _taxFee;
1447         _previousLiquidityFee = _liquidityFee;
1448 
1449         _taxFee = 0;
1450         _liquidityFee = 0;
1451     }
1452 
1453     function restoreAllFee() private {
1454         _taxFee = _previousTaxFee;
1455         _liquidityFee = _previousLiquidityFee;
1456     }
1457 
1458     function isExcludedFromFee(address account) external view returns (bool) {
1459         return _isExcludedFromFee[account];
1460     }
1461 
1462     function excludeFromFee(address account) external onlyOwner {
1463         _isExcludedFromFee[account] = true;
1464     }
1465 
1466     function includeInFee(address account) external onlyOwner {
1467         _isExcludedFromFee[account] = false;
1468     }
1469 
1470     function setBuyFee(uint256 buyTaxFee, uint256 buyLiquidityFee, uint256 buyRewardFee, uint256 buyMarketingFee, uint256 buyDevFee)
1471         external
1472         onlyOwner
1473     {
1474         _buyTaxFee = buyTaxFee;
1475         _buyLiquidityFee = buyLiquidityFee;
1476         _buyRewardFee = buyRewardFee;
1477         _buyMarketingFee = buyMarketingFee;
1478         _buyDevFee = buyDevFee;
1479         require(_buyTaxFee + _buyLiquidityFee + _buyRewardFee + _buyMarketingFee + _buyDevFee <= 15, "Must keep taxes below 15%");
1480     }
1481 
1482     function setSellFee(uint256 sellTaxFee, uint256 sellLiquidityFee, uint256 sellRewardFee, uint256 sellMarketingFee, uint256 sellDevFee)
1483         external
1484         onlyOwner
1485     {
1486         _sellTaxFee = sellTaxFee;
1487         _sellLiquidityFee = sellLiquidityFee;
1488         _sellRewardFee = sellRewardFee;
1489         _sellMarketingFee = sellMarketingFee;
1490         _sellDevFee = sellDevFee;
1491         require(_sellTaxFee + _sellLiquidityFee + _sellRewardFee + _sellMarketingFee + _sellDevFee <= 25, "Must keep taxes below 25%");
1492     }
1493 
1494     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1495         marketingAddress = payable(_marketingAddress);
1496         _isExcludedFromFee[marketingAddress] = true;
1497     }
1498 
1499     function setDevelopmentAddress(address _devWalletAddress) external onlyOwner {
1500         devAddress = payable(_devWalletAddress);
1501         _isExcludedFromFee[devAddress] = true;
1502     }
1503 
1504     function setRewardAddress(address _rewardAddress) external onlyOwner {
1505         rewardAddress = payable(_rewardAddress);
1506         _isExcludedFromFee[rewardAddress] = true;
1507     }
1508 
1509     function setLiquidityAddress(address _liquidityAddress) external onlyOwner {
1510         liquidityAddress = payable(_liquidityAddress);
1511         _isExcludedFromFee[liquidityAddress] = true;
1512     }
1513 
1514     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1515         swapAndLiquifyEnabled = _enabled;
1516         emit SwapAndLiquifyEnabledUpdated(_enabled);
1517     }
1518 
1519     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
1520     function buyBackTokens(uint256 ethAmountInWei) external onlyOwner {
1521         // generate the uniswap pair path of weth -> eth
1522         address[] memory path = new address[](2);
1523         path[0] = uniswapV2Router.WETH();
1524         path[1] = address(this);
1525 
1526         // make the swap
1527         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmountInWei}(
1528             0, // accept any amount of Token
1529             path,
1530             address(0xdead),
1531             block.timestamp
1532         );
1533     }
1534 
1535     // To receive ETH from uniswapV2Router when swapping
1536     receive() external payable {}
1537 
1538     function transferForeignToken(address _token, address _to)
1539         external
1540         onlyOwner
1541         returns (bool _sent)
1542     {
1543         require(_token != address(this), "Can't withdraw native tokens");
1544         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1545         _sent = IERC20(_token).transfer(_to, _contractBalance);
1546     }
1547 
1548     function manualSend(address _recipient) external onlyOwner {
1549         uint256 contractETHBalance = address(this).balance;
1550         (bool success, ) = _recipient.call{ value: contractETHBalance }("");
1551         require(success, "Address: unable to send value, recipient may have reverted");
1552     }
1553 }