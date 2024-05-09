1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-27
3 */
4 
5 /*
6   https://t.me/web5erc
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity 0.8.9;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address payable) {
15         return payable(msg.sender);
16     }
17 
18     function _msgData() internal view virtual returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 interface IERC20 {
25     function totalSupply() external view returns (uint256);
26 
27     function balanceOf(address account) external view returns (uint256);
28 
29     function transfer(address recipient, uint256 amount)
30         external
31         returns (bool);
32 
33     function allowance(address owner, address spender)
34         external
35         view
36         returns (uint256);
37 
38     function approve(address spender, uint256 amount) external returns (bool);
39 
40     function transferFrom(
41         address sender,
42         address recipient,
43         uint256 amount
44     ) external returns (bool);
45 
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(
48         address indexed owner,
49         address indexed spender,
50         uint256 value
51     );
52 }
53 
54 library SafeMath {
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a, "SafeMath: addition overflow");
58 
59         return c;
60     }
61 
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         return sub(a, b, "SafeMath: subtraction overflow");
64     }
65 
66     function sub(
67         uint256 a,
68         uint256 b,
69         string memory errorMessage
70     ) internal pure returns (uint256) {
71         require(b <= a, errorMessage);
72         uint256 c = a - b;
73 
74         return c;
75     }
76 
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         if (a == 0) {
79             return 0;
80         }
81 
82         uint256 c = a * b;
83         require(c / a == b, "SafeMath: multiplication overflow");
84 
85         return c;
86     }
87 
88     function div(uint256 a, uint256 b) internal pure returns (uint256) {
89         return div(a, b, "SafeMath: division by zero");
90     }
91 
92     function div(
93         uint256 a,
94         uint256 b,
95         string memory errorMessage
96     ) internal pure returns (uint256) {
97         require(b > 0, errorMessage);
98         uint256 c = a / b;
99         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
100 
101         return c;
102     }
103 
104     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
105         return mod(a, b, "SafeMath: modulo by zero");
106     }
107 
108     function mod(
109         uint256 a,
110         uint256 b,
111         string memory errorMessage
112     ) internal pure returns (uint256) {
113         require(b != 0, errorMessage);
114         return a % b;
115     }
116 }
117 
118 library Address {
119     function isContract(address account) internal view returns (bool) {
120         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
121         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
122         // for accounts without code, i.e. `keccak256('')`
123         bytes32 codehash;
124         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
125         // solhint-disable-next-line no-inline-assembly
126         assembly {
127             codehash := extcodehash(account)
128         }
129         return (codehash != accountHash && codehash != 0x0);
130     }
131 
132     function sendValue(address payable recipient, uint256 amount) internal {
133         require(
134             address(this).balance >= amount,
135             "Address: insufficient balance"
136         );
137 
138         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
139         (bool success, ) = recipient.call{value: amount}("");
140         require(
141             success,
142             "Address: unable to send value, recipient may have reverted"
143         );
144     }
145 
146     function functionCall(address target, bytes memory data)
147         internal
148         returns (bytes memory)
149     {
150         return functionCall(target, data, "Address: low-level call failed");
151     }
152 
153     function functionCall(
154         address target,
155         bytes memory data,
156         string memory errorMessage
157     ) internal returns (bytes memory) {
158         return _functionCallWithValue(target, data, 0, errorMessage);
159     }
160 
161     function functionCallWithValue(
162         address target,
163         bytes memory data,
164         uint256 value
165     ) internal returns (bytes memory) {
166         return
167             functionCallWithValue(
168                 target,
169                 data,
170                 value,
171                 "Address: low-level call with value failed"
172             );
173     }
174 
175     function functionCallWithValue(
176         address target,
177         bytes memory data,
178         uint256 value,
179         string memory errorMessage
180     ) internal returns (bytes memory) {
181         require(
182             address(this).balance >= value,
183             "Address: insufficient balance for call"
184         );
185         return _functionCallWithValue(target, data, value, errorMessage);
186     }
187 
188     function _functionCallWithValue(
189         address target,
190         bytes memory data,
191         uint256 weiValue,
192         string memory errorMessage
193     ) private returns (bytes memory) {
194         require(isContract(target), "Address: call to non-contract");
195 
196         (bool success, bytes memory returndata) = target.call{value: weiValue}(
197             data
198         );
199         if (success) {
200             return returndata;
201         } else {
202             if (returndata.length > 0) {
203                 assembly {
204                     let returndata_size := mload(returndata)
205                     revert(add(32, returndata), returndata_size)
206                 }
207             } else {
208                 revert(errorMessage);
209             }
210         }
211     }
212 }
213 
214 contract Ownable is Context {
215     address private _owner;
216     address private _previousOwner;
217     uint256 private _lockTime;
218 
219     event OwnershipTransferred(
220         address indexed previousOwner,
221         address indexed newOwner
222     );
223 
224     constructor() {
225         address msgSender = _msgSender();
226         _owner = msgSender;
227         emit OwnershipTransferred(address(0), msgSender);
228     }
229 
230     function owner() public view returns (address) {
231         return _owner;
232     }
233 
234     modifier onlyOwner() {
235         require(_owner == _msgSender(), "Ownable: caller is not the owner");
236         _;
237     }
238 
239     function renounceOwnership() public virtual onlyOwner {
240         emit OwnershipTransferred(_owner, address(0));
241         _owner = address(0);
242     }
243 
244     function transferOwnership(address newOwner) public virtual onlyOwner {
245         require(
246             newOwner != address(0),
247             "Ownable: new owner is the zero address"
248         );
249         emit OwnershipTransferred(_owner, newOwner);
250         _owner = newOwner;
251     }
252 
253     function getUnlockTime() public view returns (uint256) {
254         return _lockTime;
255     }
256 
257     function getTime() public view returns (uint256) {
258         return block.timestamp;
259     }
260 }
261 
262 
263 interface IUniswapV2Factory {
264     event PairCreated(
265         address indexed token0,
266         address indexed token1,
267         address pair,
268         uint256
269     );
270 
271     function feeTo() external view returns (address);
272 
273     function feeToSetter() external view returns (address);
274 
275     function getPair(address tokenA, address tokenB)
276         external
277         view
278         returns (address pair);
279 
280     function allPairs(uint256) external view returns (address pair);
281 
282     function allPairsLength() external view returns (uint256);
283 
284     function createPair(address tokenA, address tokenB)
285         external
286         returns (address pair);
287 
288     function setFeeTo(address) external;
289 
290     function setFeeToSetter(address) external;
291 }
292 
293 
294 interface IUniswapV2Pair {
295     event Approval(
296         address indexed owner,
297         address indexed spender,
298         uint256 value
299     );
300     event Transfer(address indexed from, address indexed to, uint256 value);
301 
302     function name() external pure returns (string memory);
303 
304     function symbol() external pure returns (string memory);
305 
306     function decimals() external pure returns (uint8);
307 
308     function totalSupply() external view returns (uint256);
309 
310     function balanceOf(address owner) external view returns (uint256);
311 
312     function allowance(address owner, address spender)
313         external
314         view
315         returns (uint256);
316 
317     function approve(address spender, uint256 value) external returns (bool);
318 
319     function transfer(address to, uint256 value) external returns (bool);
320 
321     function transferFrom(
322         address from,
323         address to,
324         uint256 value
325     ) external returns (bool);
326 
327     function DOMAIN_SEPARATOR() external view returns (bytes32);
328 
329     function PERMIT_TYPEHASH() external pure returns (bytes32);
330 
331     function nonces(address owner) external view returns (uint256);
332 
333     function permit(
334         address owner,
335         address spender,
336         uint256 value,
337         uint256 deadline,
338         uint8 v,
339         bytes32 r,
340         bytes32 s
341     ) external;
342 
343     event Burn(
344         address indexed sender,
345         uint256 amount0,
346         uint256 amount1,
347         address indexed to
348     );
349     event Swap(
350         address indexed sender,
351         uint256 amount0In,
352         uint256 amount1In,
353         uint256 amount0Out,
354         uint256 amount1Out,
355         address indexed to
356     );
357     event Sync(uint112 reserve0, uint112 reserve1);
358 
359     function MINIMUM_LIQUIDITY() external pure returns (uint256);
360 
361     function factory() external view returns (address);
362 
363     function token0() external view returns (address);
364 
365     function token1() external view returns (address);
366 
367     function getReserves()
368         external
369         view
370         returns (
371             uint112 reserve0,
372             uint112 reserve1,
373             uint32 blockTimestampLast
374         );
375 
376     function price0CumulativeLast() external view returns (uint256);
377 
378     function price1CumulativeLast() external view returns (uint256);
379 
380     function kLast() external view returns (uint256);
381 
382     function burn(address to)
383         external
384         returns (uint256 amount0, uint256 amount1);
385 
386     function swap(
387         uint256 amount0Out,
388         uint256 amount1Out,
389         address to,
390         bytes calldata data
391     ) external;
392 
393     function skim(address to) external;
394 
395     function sync() external;
396 
397     function initialize(address, address) external;
398 }
399 
400 interface IUniswapV2Router01 {
401     function factory() external pure returns (address);
402 
403     function WETH() external pure returns (address);
404 
405     function addLiquidity(
406         address tokenA,
407         address tokenB,
408         uint256 amountADesired,
409         uint256 amountBDesired,
410         uint256 amountAMin,
411         uint256 amountBMin,
412         address to,
413         uint256 deadline
414     )
415         external
416         returns (
417             uint256 amountA,
418             uint256 amountB,
419             uint256 liquidity
420         );
421 
422     function addLiquidityETH(
423         address token,
424         uint256 amountTokenDesired,
425         uint256 amountTokenMin,
426         uint256 amountETHMin,
427         address to,
428         uint256 deadline
429     )
430         external
431         payable
432         returns (
433             uint256 amountToken,
434             uint256 amountETH,
435             uint256 liquidity
436         );
437 
438     function removeLiquidity(
439         address tokenA,
440         address tokenB,
441         uint256 liquidity,
442         uint256 amountAMin,
443         uint256 amountBMin,
444         address to,
445         uint256 deadline
446     ) external returns (uint256 amountA, uint256 amountB);
447 
448     function removeLiquidityETH(
449         address token,
450         uint256 liquidity,
451         uint256 amountTokenMin,
452         uint256 amountETHMin,
453         address to,
454         uint256 deadline
455     ) external returns (uint256 amountToken, uint256 amountETH);
456 
457     function removeLiquidityWithPermit(
458         address tokenA,
459         address tokenB,
460         uint256 liquidity,
461         uint256 amountAMin,
462         uint256 amountBMin,
463         address to,
464         uint256 deadline,
465         bool approveMax,
466         uint8 v,
467         bytes32 r,
468         bytes32 s
469     ) external returns (uint256 amountA, uint256 amountB);
470 
471     function removeLiquidityETHWithPermit(
472         address token,
473         uint256 liquidity,
474         uint256 amountTokenMin,
475         uint256 amountETHMin,
476         address to,
477         uint256 deadline,
478         bool approveMax,
479         uint8 v,
480         bytes32 r,
481         bytes32 s
482     ) external returns (uint256 amountToken, uint256 amountETH);
483 
484     function swapExactTokensForTokens(
485         uint256 amountIn,
486         uint256 amountOutMin,
487         address[] calldata path,
488         address to,
489         uint256 deadline
490     ) external returns (uint256[] memory amounts);
491 
492     function swapTokensForExactTokens(
493         uint256 amountOut,
494         uint256 amountInMax,
495         address[] calldata path,
496         address to,
497         uint256 deadline
498     ) external returns (uint256[] memory amounts);
499 
500     function swapExactETHForTokens(
501         uint256 amountOutMin,
502         address[] calldata path,
503         address to,
504         uint256 deadline
505     ) external payable returns (uint256[] memory amounts);
506 
507     function swapTokensForExactETH(
508         uint256 amountOut,
509         uint256 amountInMax,
510         address[] calldata path,
511         address to,
512         uint256 deadline
513     ) external returns (uint256[] memory amounts);
514 
515     function swapExactTokensForETH(
516         uint256 amountIn,
517         uint256 amountOutMin,
518         address[] calldata path,
519         address to,
520         uint256 deadline
521     ) external returns (uint256[] memory amounts);
522 
523     function swapETHForExactTokens(
524         uint256 amountOut,
525         address[] calldata path,
526         address to,
527         uint256 deadline
528     ) external payable returns (uint256[] memory amounts);
529 
530     function quote(
531         uint256 amountA,
532         uint256 reserveA,
533         uint256 reserveB
534     ) external pure returns (uint256 amountB);
535 
536     function getAmountOut(
537         uint256 amountIn,
538         uint256 reserveIn,
539         uint256 reserveOut
540     ) external pure returns (uint256 amountOut);
541 
542     function getAmountIn(
543         uint256 amountOut,
544         uint256 reserveIn,
545         uint256 reserveOut
546     ) external pure returns (uint256 amountIn);
547 
548     function getAmountsOut(uint256 amountIn, address[] calldata path)
549         external
550         view
551         returns (uint256[] memory amounts);
552 
553     function getAmountsIn(uint256 amountOut, address[] calldata path)
554         external
555         view
556         returns (uint256[] memory amounts);
557 }
558 
559 interface IUniswapV2Router02 is IUniswapV2Router01 {
560     function removeLiquidityETHSupportingFeeOnTransferTokens(
561         address token,
562         uint256 liquidity,
563         uint256 amountTokenMin,
564         uint256 amountETHMin,
565         address to,
566         uint256 deadline
567     ) external returns (uint256 amountETH);
568 
569     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
570         address token,
571         uint256 liquidity,
572         uint256 amountTokenMin,
573         uint256 amountETHMin,
574         address to,
575         uint256 deadline,
576         bool approveMax,
577         uint8 v,
578         bytes32 r,
579         bytes32 s
580     ) external returns (uint256 amountETH);
581 
582     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
583         uint256 amountIn,
584         uint256 amountOutMin,
585         address[] calldata path,
586         address to,
587         uint256 deadline
588     ) external;
589 
590     function swapExactETHForTokensSupportingFeeOnTransferTokens(
591         uint256 amountOutMin,
592         address[] calldata path,
593         address to,
594         uint256 deadline
595     ) external payable;
596 
597     function swapExactTokensForETHSupportingFeeOnTransferTokens(
598         uint256 amountIn,
599         uint256 amountOutMin,
600         address[] calldata path,
601         address to,
602         uint256 deadline
603     ) external;
604 }
605 
606 contract WWWDOTW5DOTOMG is Context, IERC20, Ownable {
607     using SafeMath for uint256;
608     using Address for address;
609 
610     address payable public marketingAddress = payable(0xF4A976273F46B1eDD14b9f78ceDa194719aCf5d5); // Marketing Address
611 
612     address payable public liquidityAddress =
613         payable(0xF4A976273F46B1eDD14b9f78ceDa194719aCf5d5); // Liquidity Address
614 
615     mapping(address => uint256) private _rOwned;
616     mapping(address => uint256) private _tOwned;
617     mapping(address => mapping(address => uint256)) private _allowances;
618 
619     mapping(address => bool) private _isExcludedFromFee;
620 
621     mapping(address => bool) private _isExcluded;
622     address[] private _excluded;
623 
624     uint256 private constant MAX = ~uint256(0);
625     uint256 private constant _tTotal = 50 * 1e7 * 1e18;
626     uint256 private _rTotal = (MAX - (MAX % _tTotal));
627     uint256 private _tFeeTotal;
628 
629     string private constant _name = "WEB5DOTOMG";
630     string private constant _symbol = "WEBV";
631     uint8 private constant _decimals = 18;
632 
633     uint256 private constant BUY = 1;
634     uint256 private constant SELL = 2;
635     uint256 private constant TRANSFER = 3;
636     uint256 private buyOrSellSwitch;
637 
638     // these values are pretty much arbitrary since they get overwritten for every txn, but the placeholders make it easier to work with current contract.
639     uint256 private _taxFee;
640     uint256 private _previousTaxFee = _taxFee;
641 
642     uint256 private _liquidityFee;
643     uint256 private _previousLiquidityFee = _liquidityFee;
644 
645     uint256 public _buyTaxFee = 1;
646     uint256 public _buyLiquidityFee = 2;
647     uint256 public _buyMarketingFee = 3;
648 
649     uint256 public _sellTaxFee = 1;
650     uint256 public _sellLiquidityFee = 2;
651     uint256 public _sellMarketingFee = 3;
652 
653     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
654     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
655 
656     bool public limitsInEffect = true;
657     bool public tradingActive = false;
658     bool public swapEnabled = false;
659 
660     mapping (address => bool) public _isExcludedMaxTransactionAmount;
661 
662      // Anti-bot and anti-whale mappings and variables
663     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
664     bool public transferDelayEnabled = true;
665 
666     uint256 private _liquidityTokensToSwap;
667     uint256 private _marketingTokensToSwap;
668 
669     bool private gasLimitActive = true;
670     uint256 private gasPriceLimit = 602 * 1 gwei;
671 
672     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
673     // could be subject to a maximum transfer amount
674     mapping (address => bool) public automatedMarketMakerPairs;
675 
676     uint256 public minimumTokensBeforeSwap;
677     uint256 public maxTransactionAmount;
678     uint256 public maxWallet;
679 
680     IUniswapV2Router02 public uniswapV2Router;
681     address public uniswapV2Pair;
682 
683     bool inSwapAndLiquify;
684     bool public swapAndLiquifyEnabled = false;
685 
686     event RewardLiquidityProviders(uint256 tokenAmount);
687     event SwapAndLiquifyEnabledUpdated(bool enabled);
688     event SwapAndLiquify(
689         uint256 tokensSwapped,
690         uint256 ethReceived,
691         uint256 tokensIntoLiqudity
692     );
693 
694     event SwapETHForTokens(uint256 amountIn, address[] path);
695 
696     event SwapTokensForETH(uint256 amountIn, address[] path);
697 
698     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
699 
700     modifier lockTheSwap() {
701         inSwapAndLiquify = true;
702         _;
703         inSwapAndLiquify = false;
704     }
705 
706     constructor() {
707         address newOwner = msg.sender; // update if auto-deploying to a different wallet
708         address futureOwner = address(msg.sender); // use if ownership will be transferred after deployment.
709 
710         maxTransactionAmount = _tTotal * 5 / 1000; // 0.5% max txn
711         minimumTokensBeforeSwap = _tTotal * 5 / 10000; // 0.05%
712         maxWallet = _tTotal * 1 / 100; // 1%
713 
714         _rOwned[newOwner] = _rTotal;
715 
716         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
717             // ROPSTEN or HARDHAT
718             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
719         );
720 
721         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
722             .createPair(address(this), _uniswapV2Router.WETH());
723 
724         uniswapV2Router = _uniswapV2Router;
725         uniswapV2Pair = _uniswapV2Pair;
726 
727         marketingAddress = payable(msg.sender); // update to marketing address
728         liquidityAddress = payable(address(0xdead)); // update to a liquidity wallet if you don't want to burn LP tokens generated by the contract.
729 
730         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
731 
732         _isExcludedFromFee[newOwner] = true;
733         _isExcludedFromFee[futureOwner] = true; // pre-exclude future owner wallet
734         _isExcludedFromFee[address(this)] = true;
735         _isExcludedFromFee[liquidityAddress] = true;
736 
737         excludeFromMaxTransaction(newOwner, true);
738         excludeFromMaxTransaction(futureOwner, true); // pre-exclude future owner wallet
739         excludeFromMaxTransaction(address(this), true);
740         excludeFromMaxTransaction(address(_uniswapV2Router), true);
741         excludeFromMaxTransaction(address(0xdead), true);
742 
743         emit Transfer(address(0), newOwner, _tTotal);
744     }
745 
746     function name() external pure returns (string memory) {
747         return _name;
748     }
749 
750     function symbol() external pure returns (string memory) {
751         return _symbol;
752     }
753 
754     function decimals() external pure returns (uint8) {
755         return _decimals;
756     }
757 
758     function totalSupply() external pure override returns (uint256) {
759         return _tTotal;
760     }
761 
762     function balanceOf(address account) public view override returns (uint256) {
763         if (_isExcluded[account]) return _tOwned[account];
764         return tokenFromReflection(_rOwned[account]);
765     }
766 
767     function transfer(address recipient, uint256 amount)
768         external
769         override
770         returns (bool)
771     {
772         _transfer(_msgSender(), recipient, amount);
773         return true;
774     }
775 
776     function allowance(address owner, address spender)
777         external
778         view
779         override
780         returns (uint256)
781     {
782         return _allowances[owner][spender];
783     }
784 
785     function approve(address spender, uint256 amount)
786         public
787         override
788         returns (bool)
789     {
790         _approve(_msgSender(), spender, amount);
791         return true;
792     }
793 
794     function transferFrom(
795         address sender,
796         address recipient,
797         uint256 amount
798     ) external override returns (bool) {
799         _transfer(sender, recipient, amount);
800         _approve(
801             sender,
802             _msgSender(),
803             _allowances[sender][_msgSender()].sub(
804                 amount,
805                 "ERC20: transfer amount exceeds allowance"
806             )
807         );
808         return true;
809     }
810 
811     function increaseAllowance(address spender, uint256 addedValue)
812         external
813         virtual
814         returns (bool)
815     {
816         _approve(
817             _msgSender(),
818             spender,
819             _allowances[_msgSender()][spender].add(addedValue)
820         );
821         return true;
822     }
823 
824     function decreaseAllowance(address spender, uint256 subtractedValue)
825         external
826         virtual
827         returns (bool)
828     {
829         _approve(
830             _msgSender(),
831             spender,
832             _allowances[_msgSender()][spender].sub(
833                 subtractedValue,
834                 "ERC20: decreased allowance below zero"
835             )
836         );
837         return true;
838     }
839 
840     function isExcludedFromReward(address account)
841         external
842         view
843         returns (bool)
844     {
845         return _isExcluded[account];
846     }
847 
848     function totalFees() external view returns (uint256) {
849         return _tFeeTotal;
850     }
851 
852     // once enabled, can never be turned off
853     function enableTrading() external onlyOwner {
854         tradingActive = true;
855         swapAndLiquifyEnabled = true;
856         tradingActiveBlock = block.number;
857     }
858 
859     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
860         return minimumTokensBeforeSwap;
861     }
862 
863     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
864         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
865 
866         _setAutomatedMarketMakerPair(pair, value);
867     }
868 
869     function _setAutomatedMarketMakerPair(address pair, bool value) private {
870         automatedMarketMakerPairs[pair] = value;
871 
872         excludeFromMaxTransaction(pair, value);
873         if(value){excludeFromReward(pair);}
874         if(!value){includeInReward(pair);}
875     }
876 
877     function setProtectionSettings(bool antiGas) external onlyOwner() {
878         gasLimitActive = antiGas;
879     }
880 
881     function setGasPriceLimit(uint256 gas) external onlyOwner {
882         require(gas >= 300);
883         gasPriceLimit = gas * 1 gwei;
884     }
885 
886     // disable Transfer delay
887     function disableTransferDelay() external onlyOwner returns (bool){
888         transferDelayEnabled = false;
889         return true;
890     }
891 
892     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
893         external
894         view
895         returns (uint256)
896     {
897         require(tAmount <= _tTotal, "Amount must be less than supply");
898         if (!deductTransferFee) {
899             (uint256 rAmount, , , , , ) = _getValues(tAmount);
900             return rAmount;
901         } else {
902             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
903             return rTransferAmount;
904         }
905     }
906 
907     // for one-time airdrop feature after contract launch
908     function airdropToWallets(address[] memory airdropWallets, uint256[] memory amount) external onlyOwner() {
909         require(airdropWallets.length == amount.length, "airdropToWallets:: Arrays must be the same length");
910         removeAllFee();
911         buyOrSellSwitch = TRANSFER;
912         for(uint256 i = 0; i < airdropWallets.length; i++){
913             address wallet = airdropWallets[i];
914             uint256 airdropAmount = amount[i];
915             _tokenTransfer(msg.sender, wallet, airdropAmount);
916         }
917         restoreAllFee();
918     }
919 
920     // remove limits after token is stable - 30-60 minutes
921     function removeLimits() external onlyOwner returns (bool){
922         limitsInEffect = false;
923         gasLimitActive = false;
924         transferDelayEnabled = false;
925         return true;
926     }
927 
928     function tokenFromReflection(uint256 rAmount)
929         public
930         view
931         returns (uint256)
932     {
933         require(
934             rAmount <= _rTotal,
935             "Amount must be less than total reflections"
936         );
937         uint256 currentRate = _getRate();
938         return rAmount.div(currentRate);
939     }
940 
941     function excludeFromReward(address account) public onlyOwner {
942         require(!_isExcluded[account], "Account is already excluded");
943         require(_excluded.length + 1 <= 50, "Cannot exclude more than 50 accounts.  Include a previously excluded address.");
944         if (_rOwned[account] > 0) {
945             _tOwned[account] = tokenFromReflection(_rOwned[account]);
946         }
947         _isExcluded[account] = true;
948         _excluded.push(account);
949     }
950 
951     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
952         _isExcludedMaxTransactionAmount[updAds] = isEx;
953         emit ExcludedMaxTransactionAmount(updAds, isEx);
954     }
955 
956     function includeInReward(address account) public onlyOwner {
957         require(_isExcluded[account], "Account is not excluded");
958         for (uint256 i = 0; i < _excluded.length; i++) {
959             if (_excluded[i] == account) {
960                 _excluded[i] = _excluded[_excluded.length - 1];
961                 _tOwned[account] = 0;
962                 _isExcluded[account] = false;
963                 _excluded.pop();
964                 break;
965             }
966         }
967     }
968 
969     function _approve(
970         address owner,
971         address spender,
972         uint256 amount
973     ) private {
974         require(owner != address(0), "ERC20: approve from the zero address");
975         require(spender != address(0), "ERC20: approve to the zero address");
976 
977         _allowances[owner][spender] = amount;
978         emit Approval(owner, spender, amount);
979     }
980 
981     function _transfer(
982         address from,
983         address to,
984         uint256 amount
985     ) private {
986         require(from != address(0), "ERC20: transfer from the zero address");
987         require(to != address(0), "ERC20: transfer to the zero address");
988         require(amount > 0, "Transfer amount must be greater than zero");
989 
990         if(!tradingActive){
991             require(_isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading is not active yet.");
992         }
993 
994         if(limitsInEffect){
995             if (
996                 from != owner() &&
997                 to != owner() &&
998                 to != address(0) &&
999                 to != address(0xdead) &&
1000                 !inSwapAndLiquify
1001             ){
1002 
1003                 // only use to prevent sniper buys in the first blocks.
1004                 if (gasLimitActive && automatedMarketMakerPairs[from]) {
1005                     require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
1006                 }
1007 
1008                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1009                 if (transferDelayEnabled){
1010                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1011                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1012                         _holderLastTransferTimestamp[tx.origin] = block.number;
1013                     }
1014                 }
1015 
1016                 //when buy
1017                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1018                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1019                     require(amount + balanceOf(to) <= maxWallet, "Cannot exceed max wallet");
1020                 }
1021                 //when sell
1022                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1023                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1024                 }
1025                 else if (!_isExcludedMaxTransactionAmount[to]){
1026                     require(amount + balanceOf(to) <= maxWallet, "Cannot exceed max wallet");
1027                 }
1028             }
1029         }
1030 
1031         uint256 contractTokenBalance = balanceOf(address(this));
1032         bool overMinimumTokenBalance = contractTokenBalance >=
1033             minimumTokensBeforeSwap;
1034 
1035         // Sell tokens for ETH
1036         if (
1037             !inSwapAndLiquify &&
1038             swapAndLiquifyEnabled &&
1039             balanceOf(uniswapV2Pair) > 0 &&
1040             overMinimumTokenBalance &&
1041             automatedMarketMakerPairs[to]
1042         ) {
1043             swapBack();
1044         }
1045 
1046         removeAllFee();
1047 
1048         buyOrSellSwitch = TRANSFER;
1049 
1050         // If any account belongs to _isExcludedFromFee account then remove the fee
1051         if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
1052             // Buy
1053             if (automatedMarketMakerPairs[from]) {
1054                 _taxFee = _buyTaxFee;
1055                 _liquidityFee = _buyLiquidityFee + _buyMarketingFee;
1056                 if(_liquidityFee > 0){
1057                     buyOrSellSwitch = BUY;
1058                 }
1059             }
1060             // Sell
1061             else if (automatedMarketMakerPairs[to]) {
1062                 _taxFee = _sellTaxFee;
1063                 _liquidityFee = _sellLiquidityFee + _sellMarketingFee;
1064                 if(_liquidityFee > 0){
1065                     buyOrSellSwitch = SELL;
1066                 }
1067             }
1068         }
1069 
1070         _tokenTransfer(from, to, amount);
1071 
1072         restoreAllFee();
1073 
1074     }
1075 
1076     function swapBack() private lockTheSwap {
1077         uint256 contractBalance = balanceOf(address(this));
1078         bool success;
1079         uint256 totalTokensToSwap = _liquidityTokensToSwap + _marketingTokensToSwap;
1080         if(totalTokensToSwap == 0 || contractBalance == 0) {return;}
1081 
1082         // Halve the amount of liquidity tokens
1083         uint256 tokensForLiquidity = (contractBalance * _liquidityTokensToSwap / totalTokensToSwap) / 2;
1084         uint256 amountToSwapForBNB = contractBalance.sub(tokensForLiquidity);
1085 
1086         uint256 initialBNBBalance = address(this).balance;
1087 
1088         swapTokensForBNB(amountToSwapForBNB);
1089 
1090         uint256 bnbBalance = address(this).balance.sub(initialBNBBalance);
1091 
1092         uint256 bnbForMarketing = bnbBalance.mul(_marketingTokensToSwap).div(totalTokensToSwap);
1093 
1094         uint256 bnbForLiquidity = bnbBalance - bnbForMarketing;
1095 
1096         _liquidityTokensToSwap = 0;
1097         _marketingTokensToSwap = 0;
1098 
1099         if(tokensForLiquidity > 0 && bnbForLiquidity > 0){
1100             addLiquidity(tokensForLiquidity, bnbForLiquidity);
1101             emit SwapAndLiquify(amountToSwapForBNB, bnbForLiquidity, tokensForLiquidity);
1102         }
1103 
1104         (success,) = address(marketingAddress).call{value: address(this).balance}("");
1105 
1106     }
1107 
1108     function swapTokensForBNB(uint256 tokenAmount) private {
1109         address[] memory path = new address[](2);
1110         path[0] = address(this);
1111         path[1] = uniswapV2Router.WETH();
1112         _approve(address(this), address(uniswapV2Router), tokenAmount);
1113         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1114             tokenAmount,
1115             0, // accept any amount of ETH
1116             path,
1117             address(this),
1118             block.timestamp
1119         );
1120     }
1121 
1122     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1123         _approve(address(this), address(uniswapV2Router), tokenAmount);
1124         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1125             address(this),
1126             tokenAmount,
1127             0, // slippage is unavoidable
1128             0, // slippage is unavoidable
1129             liquidityAddress,
1130             block.timestamp
1131         );
1132     }
1133 
1134     function _tokenTransfer(
1135         address sender,
1136         address recipient,
1137         uint256 amount
1138     ) private {
1139 
1140         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1141             _transferFromExcluded(sender, recipient, amount);
1142         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1143             _transferToExcluded(sender, recipient, amount);
1144         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1145             _transferBothExcluded(sender, recipient, amount);
1146         } else {
1147             _transferStandard(sender, recipient, amount);
1148         }
1149     }
1150 
1151     function _transferStandard(
1152         address sender,
1153         address recipient,
1154         uint256 tAmount
1155     ) private {
1156         (
1157             uint256 rAmount,
1158             uint256 rTransferAmount,
1159             uint256 rFee,
1160             uint256 tTransferAmount,
1161             uint256 tFee,
1162             uint256 tLiquidity
1163         ) = _getValues(tAmount);
1164         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1165         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1166         _takeLiquidity(tLiquidity);
1167         _reflectFee(rFee, tFee);
1168         emit Transfer(sender, recipient, tTransferAmount);
1169     }
1170 
1171     function _transferToExcluded(
1172         address sender,
1173         address recipient,
1174         uint256 tAmount
1175     ) private {
1176         (
1177             uint256 rAmount,
1178             uint256 rTransferAmount,
1179             uint256 rFee,
1180             uint256 tTransferAmount,
1181             uint256 tFee,
1182             uint256 tLiquidity
1183         ) = _getValues(tAmount);
1184         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1185         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1186         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1187         _takeLiquidity(tLiquidity);
1188         _reflectFee(rFee, tFee);
1189         emit Transfer(sender, recipient, tTransferAmount);
1190     }
1191 
1192     function _transferFromExcluded(
1193         address sender,
1194         address recipient,
1195         uint256 tAmount
1196     ) private {
1197         (
1198             uint256 rAmount,
1199             uint256 rTransferAmount,
1200             uint256 rFee,
1201             uint256 tTransferAmount,
1202             uint256 tFee,
1203             uint256 tLiquidity
1204         ) = _getValues(tAmount);
1205         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1206         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1207         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1208         _takeLiquidity(tLiquidity);
1209         _reflectFee(rFee, tFee);
1210         emit Transfer(sender, recipient, tTransferAmount);
1211     }
1212 
1213     function _transferBothExcluded(
1214         address sender,
1215         address recipient,
1216         uint256 tAmount
1217     ) private {
1218         (
1219             uint256 rAmount,
1220             uint256 rTransferAmount,
1221             uint256 rFee,
1222             uint256 tTransferAmount,
1223             uint256 tFee,
1224             uint256 tLiquidity
1225         ) = _getValues(tAmount);
1226         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1227         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1228         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1229         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1230         _takeLiquidity(tLiquidity);
1231         _reflectFee(rFee, tFee);
1232         emit Transfer(sender, recipient, tTransferAmount);
1233     }
1234 
1235     function _reflectFee(uint256 rFee, uint256 tFee) private {
1236         _rTotal = _rTotal.sub(rFee);
1237         _tFeeTotal = _tFeeTotal.add(tFee);
1238     }
1239 
1240     function _getValues(uint256 tAmount)
1241         private
1242         view
1243         returns (
1244             uint256,
1245             uint256,
1246             uint256,
1247             uint256,
1248             uint256,
1249             uint256
1250         )
1251     {
1252         (
1253             uint256 tTransferAmount,
1254             uint256 tFee,
1255             uint256 tLiquidity
1256         ) = _getTValues(tAmount);
1257         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1258             tAmount,
1259             tFee,
1260             tLiquidity,
1261             _getRate()
1262         );
1263         return (
1264             rAmount,
1265             rTransferAmount,
1266             rFee,
1267             tTransferAmount,
1268             tFee,
1269             tLiquidity
1270         );
1271     }
1272 
1273     function _getTValues(uint256 tAmount)
1274         private
1275         view
1276         returns (
1277             uint256,
1278             uint256,
1279             uint256
1280         )
1281     {
1282         uint256 tFee = calculateTaxFee(tAmount);
1283         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1284         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1285         return (tTransferAmount, tFee, tLiquidity);
1286     }
1287 
1288     function _getRValues(
1289         uint256 tAmount,
1290         uint256 tFee,
1291         uint256 tLiquidity,
1292         uint256 currentRate
1293     )
1294         private
1295         pure
1296         returns (
1297             uint256,
1298             uint256,
1299             uint256
1300         )
1301     {
1302         uint256 rAmount = tAmount.mul(currentRate);
1303         uint256 rFee = tFee.mul(currentRate);
1304         uint256 rLiquidity = tLiquidity.mul(currentRate);
1305         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1306         return (rAmount, rTransferAmount, rFee);
1307     }
1308 
1309     function _getRate() private view returns (uint256) {
1310         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1311         return rSupply.div(tSupply);
1312     }
1313 
1314     function _getCurrentSupply() private view returns (uint256, uint256) {
1315         uint256 rSupply = _rTotal;
1316         uint256 tSupply = _tTotal;
1317         for (uint256 i = 0; i < _excluded.length; i++) {
1318             if (
1319                 _rOwned[_excluded[i]] > rSupply ||
1320                 _tOwned[_excluded[i]] > tSupply
1321             ) return (_rTotal, _tTotal);
1322             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1323             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1324         }
1325         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1326         return (rSupply, tSupply);
1327     }
1328 
1329     function _takeLiquidity(uint256 tLiquidity) private {
1330         if(buyOrSellSwitch == BUY){
1331             _liquidityTokensToSwap += tLiquidity * _buyLiquidityFee / _liquidityFee;
1332             _marketingTokensToSwap += tLiquidity * _buyMarketingFee / _liquidityFee;
1333         } else if(buyOrSellSwitch == SELL){
1334             _liquidityTokensToSwap += tLiquidity * _sellLiquidityFee / _liquidityFee;
1335             _marketingTokensToSwap += tLiquidity * _sellMarketingFee / _liquidityFee;
1336         }
1337         uint256 currentRate = _getRate();
1338         uint256 rLiquidity = tLiquidity.mul(currentRate);
1339         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1340         if (_isExcluded[address(this)])
1341             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1342     }
1343 
1344     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1345         return _amount.mul(_taxFee).div(10**2);
1346     }
1347 
1348     function calculateLiquidityFee(uint256 _amount)
1349         private
1350         view
1351         returns (uint256)
1352     {
1353         return _amount.mul(_liquidityFee).div(10**2);
1354     }
1355 
1356     function removeAllFee() private {
1357         if (_taxFee == 0 && _liquidityFee == 0) return;
1358 
1359         _previousTaxFee = _taxFee;
1360         _previousLiquidityFee = _liquidityFee;
1361 
1362         _taxFee = 0;
1363         _liquidityFee = 0;
1364     }
1365 
1366     function restoreAllFee() private {
1367         _taxFee = _previousTaxFee;
1368         _liquidityFee = _previousLiquidityFee;
1369     }
1370 
1371     function isExcludedFromFee(address account) external view returns (bool) {
1372         return _isExcludedFromFee[account];
1373     }
1374 
1375     function excludeFromFee(address account) external onlyOwner {
1376         _isExcludedFromFee[account] = true;
1377     }
1378 
1379     function includeInFee(address account) external onlyOwner {
1380         _isExcludedFromFee[account] = false;
1381     }
1382 
1383     function setBuyFee(uint256 buyTaxFee, uint256 buyLiquidityFee, uint256 buyMarketingFee)
1384         external
1385         onlyOwner
1386     {
1387         _buyTaxFee = buyTaxFee;
1388         _buyLiquidityFee = buyLiquidityFee;
1389         _buyMarketingFee = buyMarketingFee;
1390         require(_buyTaxFee + _buyLiquidityFee + _buyMarketingFee <= 20, "Must keep taxes below 20%");
1391     }
1392 
1393     function setSellFee(uint256 sellTaxFee, uint256 sellLiquidityFee, uint256 sellMarketingFee)
1394         external
1395         onlyOwner
1396     {
1397         _sellTaxFee = sellTaxFee;
1398         _sellLiquidityFee = sellLiquidityFee;
1399         _sellMarketingFee = sellMarketingFee;
1400         require(_sellTaxFee + _sellLiquidityFee + _sellMarketingFee <= 30, "Must keep taxes below 30%");
1401     }
1402 
1403     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1404         marketingAddress = payable(_marketingAddress);
1405         _isExcludedFromFee[marketingAddress] = true;
1406     }
1407 
1408     function setLiquidityAddress(address _liquidityAddress) external onlyOwner {
1409         liquidityAddress = payable(_liquidityAddress);
1410         _isExcludedFromFee[liquidityAddress] = true;
1411     }
1412 
1413     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1414         swapAndLiquifyEnabled = _enabled;
1415         emit SwapAndLiquifyEnabledUpdated(_enabled);
1416     }
1417 
1418     // useful for buybacks or to reclaim any BNB on the contract in a way that helps holders.
1419     function buyBackTokens(uint256 bnbAmountInWei) external onlyOwner {
1420         // generate the uniswap pair path of weth -> eth
1421         address[] memory path = new address[](2);
1422         path[0] = uniswapV2Router.WETH();
1423         path[1] = address(this);
1424 
1425         // make the swap
1426         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmountInWei}(
1427             0, // accept any amount of Ethereum
1428             path,
1429             address(0xdead),
1430             block.timestamp
1431         );
1432     }
1433 
1434     // To receive ETH from uniswapV2Router when swapping
1435     receive() external payable {}
1436 
1437     function transferForeignToken(address _token, address _to)
1438         external
1439         onlyOwner
1440         returns (bool _sent)
1441     {
1442         require(_token != address(this), "Can't withdraw native tokens");
1443         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1444         _sent = IERC20(_token).transfer(_to, _contractBalance);
1445     }
1446 }