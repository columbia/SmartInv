1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.9;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return payable(msg.sender);
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18 
19     function balanceOf(address account) external view returns (uint256);
20 
21     function transfer(address recipient, uint256 amount)
22         external
23         returns (bool);
24 
25     function allowance(address owner, address spender)
26         external
27         view
28         returns (uint256);
29 
30     function approve(address spender, uint256 amount) external returns (bool);
31 
32     function transferFrom(
33         address sender,
34         address recipient,
35         uint256 amount
36     ) external returns (bool);
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(
40         address indexed owner,
41         address indexed spender,
42         uint256 value
43     );
44 }
45 
46 library SafeMath {
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a, "SafeMath: addition overflow");
50 
51         return c;
52     }
53 
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         return sub(a, b, "SafeMath: subtraction overflow");
56     }
57 
58     function sub(
59         uint256 a,
60         uint256 b,
61         string memory errorMessage
62     ) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
70         if (a == 0) {
71             return 0;
72         }
73 
74         uint256 c = a * b;
75         require(c / a == b, "SafeMath: multiplication overflow");
76 
77         return c;
78     }
79 
80     function div(uint256 a, uint256 b) internal pure returns (uint256) {
81         return div(a, b, "SafeMath: division by zero");
82     }
83 
84     function div(
85         uint256 a,
86         uint256 b,
87         string memory errorMessage
88     ) internal pure returns (uint256) {
89         require(b > 0, errorMessage);
90         uint256 c = a / b;
91         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92 
93         return c;
94     }
95 
96     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
97         return mod(a, b, "SafeMath: modulo by zero");
98     }
99 
100     function mod(
101         uint256 a,
102         uint256 b,
103         string memory errorMessage
104     ) internal pure returns (uint256) {
105         require(b != 0, errorMessage);
106         return a % b;
107     }
108 }
109 
110 library Address {
111     function isContract(address account) internal view returns (bool) {
112         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
113         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
114         // for accounts without code, i.e. `keccak256('')`
115         bytes32 codehash;
116         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
117         // solhint-disable-next-line no-inline-assembly
118         assembly {
119             codehash := extcodehash(account)
120         }
121         return (codehash != accountHash && codehash != 0x0);
122     }
123 
124     function sendValue(address payable recipient, uint256 amount) internal {
125         require(
126             address(this).balance >= amount,
127             "Address: insufficient balance"
128         );
129 
130         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
131         (bool success, ) = recipient.call{value: amount}("");
132         require(
133             success,
134             "Address: unable to send value, recipient may have reverted"
135         );
136     }
137 
138     function functionCall(address target, bytes memory data)
139         internal
140         returns (bytes memory)
141     {
142         return functionCall(target, data, "Address: low-level call failed");
143     }
144 
145     function functionCall(
146         address target,
147         bytes memory data,
148         string memory errorMessage
149     ) internal returns (bytes memory) {
150         return _functionCallWithValue(target, data, 0, errorMessage);
151     }
152 
153     function functionCallWithValue(
154         address target,
155         bytes memory data,
156         uint256 value
157     ) internal returns (bytes memory) {
158         return
159             functionCallWithValue(
160                 target,
161                 data,
162                 value,
163                 "Address: low-level call with value failed"
164             );
165     }
166 
167     function functionCallWithValue(
168         address target,
169         bytes memory data,
170         uint256 value,
171         string memory errorMessage
172     ) internal returns (bytes memory) {
173         require(
174             address(this).balance >= value,
175             "Address: insufficient balance for call"
176         );
177         return _functionCallWithValue(target, data, value, errorMessage);
178     }
179 
180     function _functionCallWithValue(
181         address target,
182         bytes memory data,
183         uint256 weiValue,
184         string memory errorMessage
185     ) private returns (bytes memory) {
186         require(isContract(target), "Address: call to non-contract");
187 
188         (bool success, bytes memory returndata) = target.call{value: weiValue}(
189             data
190         );
191         if (success) {
192             return returndata;
193         } else {
194             if (returndata.length > 0) {
195                 assembly {
196                     let returndata_size := mload(returndata)
197                     revert(add(32, returndata), returndata_size)
198                 }
199             } else {
200                 revert(errorMessage);
201             }
202         }
203     }
204 }
205 
206 contract Ownable is Context {
207     address private _owner;
208     address private _previousOwner;
209     uint256 private _lockTime;
210 
211     event OwnershipTransferred(
212         address indexed previousOwner,
213         address indexed newOwner
214     );
215 
216     constructor() {
217         address msgSender = _msgSender();
218         _owner = msgSender;
219         emit OwnershipTransferred(address(0), msgSender);
220     }
221 
222     function owner() public view returns (address) {
223         return _owner;
224     }
225 
226     modifier onlyOwner() {
227         require(_owner == _msgSender(), "Ownable: caller is not the owner");
228         _;
229     }
230 
231     function renounceOwnership() public virtual onlyOwner {
232         emit OwnershipTransferred(_owner, address(0));
233         _owner = address(0);
234     }
235 
236     function transferOwnership(address newOwner) public virtual onlyOwner {
237         require(
238             newOwner != address(0),
239             "Ownable: new owner is the zero address"
240         );
241         emit OwnershipTransferred(_owner, newOwner);
242         _owner = newOwner;
243     }
244 
245     function getUnlockTime() public view returns (uint256) {
246         return _lockTime;
247     }
248 
249     function getTime() public view returns (uint256) {
250         return block.timestamp;
251     }
252 }
253 
254 
255 interface IUniswapV2Factory {
256     event PairCreated(
257         address indexed token0,
258         address indexed token1,
259         address pair,
260         uint256
261     );
262 
263     function feeTo() external view returns (address);
264 
265     function feeToSetter() external view returns (address);
266 
267     function getPair(address tokenA, address tokenB)
268         external
269         view
270         returns (address pair);
271 
272     function allPairs(uint256) external view returns (address pair);
273 
274     function allPairsLength() external view returns (uint256);
275 
276     function createPair(address tokenA, address tokenB)
277         external
278         returns (address pair);
279 
280     function setFeeTo(address) external;
281 
282     function setFeeToSetter(address) external;
283 }
284 
285 
286 interface IUniswapV2Pair {
287     event Approval(
288         address indexed owner,
289         address indexed spender,
290         uint256 value
291     );
292     event Transfer(address indexed from, address indexed to, uint256 value);
293 
294     function name() external pure returns (string memory);
295 
296     function symbol() external pure returns (string memory);
297 
298     function decimals() external pure returns (uint8);
299 
300     function totalSupply() external view returns (uint256);
301 
302     function balanceOf(address owner) external view returns (uint256);
303 
304     function allowance(address owner, address spender)
305         external
306         view
307         returns (uint256);
308 
309     function approve(address spender, uint256 value) external returns (bool);
310 
311     function transfer(address to, uint256 value) external returns (bool);
312 
313     function transferFrom(
314         address from,
315         address to,
316         uint256 value
317     ) external returns (bool);
318 
319     function DOMAIN_SEPARATOR() external view returns (bytes32);
320 
321     function PERMIT_TYPEHASH() external pure returns (bytes32);
322 
323     function nonces(address owner) external view returns (uint256);
324 
325     function permit(
326         address owner,
327         address spender,
328         uint256 value,
329         uint256 deadline,
330         uint8 v,
331         bytes32 r,
332         bytes32 s
333     ) external;
334 
335     event Burn(
336         address indexed sender,
337         uint256 amount0,
338         uint256 amount1,
339         address indexed to
340     );
341     event Swap(
342         address indexed sender,
343         uint256 amount0In,
344         uint256 amount1In,
345         uint256 amount0Out,
346         uint256 amount1Out,
347         address indexed to
348     );
349     event Sync(uint112 reserve0, uint112 reserve1);
350 
351     function MINIMUM_LIQUIDITY() external pure returns (uint256);
352 
353     function factory() external view returns (address);
354 
355     function token0() external view returns (address);
356 
357     function token1() external view returns (address);
358 
359     function getReserves()
360         external
361         view
362         returns (
363             uint112 reserve0,
364             uint112 reserve1,
365             uint32 blockTimestampLast
366         );
367 
368     function price0CumulativeLast() external view returns (uint256);
369 
370     function price1CumulativeLast() external view returns (uint256);
371 
372     function kLast() external view returns (uint256);
373 
374     function burn(address to)
375         external
376         returns (uint256 amount0, uint256 amount1);
377 
378     function swap(
379         uint256 amount0Out,
380         uint256 amount1Out,
381         address to,
382         bytes calldata data
383     ) external;
384 
385     function skim(address to) external;
386 
387     function sync() external;
388 
389     function initialize(address, address) external;
390 }
391 
392 interface IUniswapV2Router01 {
393     function factory() external pure returns (address);
394 
395     function WETH() external pure returns (address);
396 
397     function addLiquidity(
398         address tokenA,
399         address tokenB,
400         uint256 amountADesired,
401         uint256 amountBDesired,
402         uint256 amountAMin,
403         uint256 amountBMin,
404         address to,
405         uint256 deadline
406     )
407         external
408         returns (
409             uint256 amountA,
410             uint256 amountB,
411             uint256 liquidity
412         );
413 
414     function addLiquidityETH(
415         address token,
416         uint256 amountTokenDesired,
417         uint256 amountTokenMin,
418         uint256 amountETHMin,
419         address to,
420         uint256 deadline
421     )
422         external
423         payable
424         returns (
425             uint256 amountToken,
426             uint256 amountETH,
427             uint256 liquidity
428         );
429 
430     function removeLiquidity(
431         address tokenA,
432         address tokenB,
433         uint256 liquidity,
434         uint256 amountAMin,
435         uint256 amountBMin,
436         address to,
437         uint256 deadline
438     ) external returns (uint256 amountA, uint256 amountB);
439 
440     function removeLiquidityETH(
441         address token,
442         uint256 liquidity,
443         uint256 amountTokenMin,
444         uint256 amountETHMin,
445         address to,
446         uint256 deadline
447     ) external returns (uint256 amountToken, uint256 amountETH);
448 
449     function removeLiquidityWithPermit(
450         address tokenA,
451         address tokenB,
452         uint256 liquidity,
453         uint256 amountAMin,
454         uint256 amountBMin,
455         address to,
456         uint256 deadline,
457         bool approveMax,
458         uint8 v,
459         bytes32 r,
460         bytes32 s
461     ) external returns (uint256 amountA, uint256 amountB);
462 
463     function removeLiquidityETHWithPermit(
464         address token,
465         uint256 liquidity,
466         uint256 amountTokenMin,
467         uint256 amountETHMin,
468         address to,
469         uint256 deadline,
470         bool approveMax,
471         uint8 v,
472         bytes32 r,
473         bytes32 s
474     ) external returns (uint256 amountToken, uint256 amountETH);
475 
476     function swapExactTokensForTokens(
477         uint256 amountIn,
478         uint256 amountOutMin,
479         address[] calldata path,
480         address to,
481         uint256 deadline
482     ) external returns (uint256[] memory amounts);
483 
484     function swapTokensForExactTokens(
485         uint256 amountOut,
486         uint256 amountInMax,
487         address[] calldata path,
488         address to,
489         uint256 deadline
490     ) external returns (uint256[] memory amounts);
491 
492     function swapExactETHForTokens(
493         uint256 amountOutMin,
494         address[] calldata path,
495         address to,
496         uint256 deadline
497     ) external payable returns (uint256[] memory amounts);
498 
499     function swapTokensForExactETH(
500         uint256 amountOut,
501         uint256 amountInMax,
502         address[] calldata path,
503         address to,
504         uint256 deadline
505     ) external returns (uint256[] memory amounts);
506 
507     function swapExactTokensForETH(
508         uint256 amountIn,
509         uint256 amountOutMin,
510         address[] calldata path,
511         address to,
512         uint256 deadline
513     ) external returns (uint256[] memory amounts);
514 
515     function swapETHForExactTokens(
516         uint256 amountOut,
517         address[] calldata path,
518         address to,
519         uint256 deadline
520     ) external payable returns (uint256[] memory amounts);
521 
522     function quote(
523         uint256 amountA,
524         uint256 reserveA,
525         uint256 reserveB
526     ) external pure returns (uint256 amountB);
527 
528     function getAmountOut(
529         uint256 amountIn,
530         uint256 reserveIn,
531         uint256 reserveOut
532     ) external pure returns (uint256 amountOut);
533 
534     function getAmountIn(
535         uint256 amountOut,
536         uint256 reserveIn,
537         uint256 reserveOut
538     ) external pure returns (uint256 amountIn);
539 
540     function getAmountsOut(uint256 amountIn, address[] calldata path)
541         external
542         view
543         returns (uint256[] memory amounts);
544 
545     function getAmountsIn(uint256 amountOut, address[] calldata path)
546         external
547         view
548         returns (uint256[] memory amounts);
549 }
550 
551 interface IUniswapV2Router02 is IUniswapV2Router01 {
552     function removeLiquidityETHSupportingFeeOnTransferTokens(
553         address token,
554         uint256 liquidity,
555         uint256 amountTokenMin,
556         uint256 amountETHMin,
557         address to,
558         uint256 deadline
559     ) external returns (uint256 amountETH);
560 
561     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
562         address token,
563         uint256 liquidity,
564         uint256 amountTokenMin,
565         uint256 amountETHMin,
566         address to,
567         uint256 deadline,
568         bool approveMax,
569         uint8 v,
570         bytes32 r,
571         bytes32 s
572     ) external returns (uint256 amountETH);
573 
574     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
575         uint256 amountIn,
576         uint256 amountOutMin,
577         address[] calldata path,
578         address to,
579         uint256 deadline
580     ) external;
581 
582     function swapExactETHForTokensSupportingFeeOnTransferTokens(
583         uint256 amountOutMin,
584         address[] calldata path,
585         address to,
586         uint256 deadline
587     ) external payable;
588 
589     function swapExactTokensForETHSupportingFeeOnTransferTokens(
590         uint256 amountIn,
591         uint256 amountOutMin,
592         address[] calldata path,
593         address to,
594         uint256 deadline
595     ) external;
596 }
597 
598 contract THELUCKYCAT is Context, IERC20, Ownable {
599     using SafeMath for uint256;
600     using Address for address;
601 
602     address payable public marketingAddress = payable(0x00D76a762B3b71b2044c7A8Fee022419c39Dc76f); // Marketing Address
603 
604     address payable public liquidityAddress =
605         payable(0x000000000000000000000000000000000000dEaD); // Liquidity Address
606 
607     mapping(address => uint256) private _rOwned;
608     mapping(address => uint256) private _tOwned;
609     mapping(address => mapping(address => uint256)) private _allowances;
610 
611     mapping(address => bool) private _isExcludedFromFee;
612 
613     mapping(address => bool) private _isExcluded;
614     address[] private _excluded;
615 
616     uint256 private constant MAX = ~uint256(0);
617     uint256 private constant _tTotal = 100 * 1e9 * 1e18;
618     uint256 private _rTotal = (MAX - (MAX % _tTotal));
619     uint256 private _tFeeTotal;
620 
621     string private constant _name = "MANEKI-NEKO";
622     string private constant _symbol = "NEKO";
623     uint8 private constant _decimals = 18;
624 
625     uint256 private constant BUY = 1;
626     uint256 private constant SELL = 2;
627     uint256 private constant TRANSFER = 3;
628     uint256 private buyOrSellSwitch;
629 
630     // these values are pretty much arbitrary since they get overwritten for every txn, but the placeholders make it easier to work with current contract.
631     uint256 private _taxFee;
632     uint256 private _previousTaxFee = _taxFee;
633 
634     uint256 private _liquidityFee;
635     uint256 private _previousLiquidityFee = _liquidityFee;
636 
637     uint256 public _buyTaxFee = 0;
638     uint256 public _buyLiquidityFee = 5;
639     uint256 public _buyMarketingFee = 0;
640 
641     uint256 public _sellTaxFee = 0;
642     uint256 public _sellLiquidityFee = 8;
643     uint256 public _sellMarketingFee = 7;
644 
645     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
646     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
647 
648     bool public limitsInEffect = true;
649     bool public tradingActive = false;
650     bool public swapEnabled = false;
651 
652     mapping (address => bool) public _isExcludedMaxTransactionAmount;
653 
654      // Anti-bot and anti-whale mappings and variables
655     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
656     bool public transferDelayEnabled = true;
657 
658     uint256 private _liquidityTokensToSwap;
659     uint256 private _marketingTokensToSwap;
660 
661     bool private gasLimitActive = true;
662     uint256 private gasPriceLimit = 602 * 1 gwei;
663 
664     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
665     // could be subject to a maximum transfer amount
666     mapping (address => bool) public automatedMarketMakerPairs;
667 
668     uint256 public minimumTokensBeforeSwap;
669     uint256 public maxTransactionAmount;
670     uint256 public maxWallet;
671 
672     IUniswapV2Router02 public uniswapV2Router;
673     address public uniswapV2Pair;
674 
675     bool inSwapAndLiquify;
676     bool public swapAndLiquifyEnabled = false;
677 
678     event RewardLiquidityProviders(uint256 tokenAmount);
679     event SwapAndLiquifyEnabledUpdated(bool enabled);
680     event SwapAndLiquify(
681         uint256 tokensSwapped,
682         uint256 ethReceived,
683         uint256 tokensIntoLiqudity
684     );
685 
686     event SwapETHForTokens(uint256 amountIn, address[] path);
687 
688     event SwapTokensForETH(uint256 amountIn, address[] path);
689 
690     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
691 
692     modifier lockTheSwap() {
693         inSwapAndLiquify = true;
694         _;
695         inSwapAndLiquify = false;
696     }
697 
698     constructor() {
699         address newOwner = msg.sender; // update if auto-deploying to a different wallet
700         address futureOwner = address(msg.sender); // use if ownership will be transferred after deployment.
701 
702         maxTransactionAmount = _tTotal * 3 / 1000; // 0.3% max txn
703         minimumTokensBeforeSwap = _tTotal * 3 / 10000; // 0.03%
704         maxWallet = _tTotal * 3 / 1000; // .3%
705 
706         _rOwned[newOwner] = _rTotal;
707 
708         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
709             // ROPSTEN or HARDHAT
710             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
711         );
712 
713         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
714             .createPair(address(this), _uniswapV2Router.WETH());
715 
716         uniswapV2Router = _uniswapV2Router;
717         uniswapV2Pair = _uniswapV2Pair;
718 
719         marketingAddress = payable(0x00D76a762B3b71b2044c7A8Fee022419c39Dc76f); //  update to marketing address
720         liquidityAddress = payable(address(0xdead)); // update to a liquidity wallet if you don't want to burn LP tokens generated by the contract.
721 
722         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
723 
724         _isExcludedFromFee[newOwner] = true;
725         _isExcludedFromFee[futureOwner] = true; // pre-exclude future owner wallet
726         _isExcludedFromFee[address(this)] = true;
727         _isExcludedFromFee[liquidityAddress] = true;
728 
729         excludeFromMaxTransaction(newOwner, true);
730         excludeFromMaxTransaction(futureOwner, true); // pre-exclude future owner wallet
731         excludeFromMaxTransaction(address(this), true);
732         excludeFromMaxTransaction(address(_uniswapV2Router), true);
733         excludeFromMaxTransaction(address(0xdead), true);
734 
735         emit Transfer(address(0), newOwner, _tTotal);
736     }
737 
738     function name() external pure returns (string memory) {
739         return _name;
740     }
741 
742     function symbol() external pure returns (string memory) {
743         return _symbol;
744     }
745 
746     function decimals() external pure returns (uint8) {
747         return _decimals;
748     }
749 
750     function totalSupply() external pure override returns (uint256) {
751         return _tTotal;
752     }
753 
754     function balanceOf(address account) public view override returns (uint256) {
755         if (_isExcluded[account]) return _tOwned[account];
756         return tokenFromReflection(_rOwned[account]);
757     }
758 
759     function transfer(address recipient, uint256 amount)
760         external
761         override
762         returns (bool)
763     {
764         _transfer(_msgSender(), recipient, amount);
765         return true;
766     }
767 
768     function allowance(address owner, address spender)
769         external
770         view
771         override
772         returns (uint256)
773     {
774         return _allowances[owner][spender];
775     }
776 
777     function approve(address spender, uint256 amount)
778         public
779         override
780         returns (bool)
781     {
782         _approve(_msgSender(), spender, amount);
783         return true;
784     }
785 
786     function transferFrom(
787         address sender,
788         address recipient,
789         uint256 amount
790     ) external override returns (bool) {
791         _transfer(sender, recipient, amount);
792         _approve(
793             sender,
794             _msgSender(),
795             _allowances[sender][_msgSender()].sub(
796                 amount,
797                 "ERC20: transfer amount exceeds allowance"
798             )
799         );
800         return true;
801     }
802 
803     function increaseAllowance(address spender, uint256 addedValue)
804         external
805         virtual
806         returns (bool)
807     {
808         _approve(
809             _msgSender(),
810             spender,
811             _allowances[_msgSender()][spender].add(addedValue)
812         );
813         return true;
814     }
815 
816     function decreaseAllowance(address spender, uint256 subtractedValue)
817         external
818         virtual
819         returns (bool)
820     {
821         _approve(
822             _msgSender(),
823             spender,
824             _allowances[_msgSender()][spender].sub(
825                 subtractedValue,
826                 "ERC20: decreased allowance below zero"
827             )
828         );
829         return true;
830     }
831 
832     function isExcludedFromReward(address account)
833         external
834         view
835         returns (bool)
836     {
837         return _isExcluded[account];
838     }
839 
840     function totalFees() external view returns (uint256) {
841         return _tFeeTotal;
842     }
843 
844     // once enabled, can never be turned off
845     function enableTrading() external onlyOwner {
846         tradingActive = true;
847         swapAndLiquifyEnabled = true;
848         tradingActiveBlock = block.number;
849     }
850 
851     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
852         return minimumTokensBeforeSwap;
853     }
854 
855     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
856         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
857 
858         _setAutomatedMarketMakerPair(pair, value);
859     }
860 
861     function _setAutomatedMarketMakerPair(address pair, bool value) private {
862         automatedMarketMakerPairs[pair] = value;
863 
864         excludeFromMaxTransaction(pair, value);
865         if(value){excludeFromReward(pair);}
866         if(!value){includeInReward(pair);}
867     }
868 
869     function setProtectionSettings(bool antiGas) external onlyOwner() {
870         gasLimitActive = antiGas;
871     }
872 
873     function setGasPriceLimit(uint256 gas) external onlyOwner {
874         require(gas >= 300);
875         gasPriceLimit = gas * 1 gwei;
876     }
877 
878     // disable Transfer delay
879     function disableTransferDelay() external onlyOwner returns (bool){
880         transferDelayEnabled = false;
881         return true;
882     }
883 
884     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
885         external
886         view
887         returns (uint256)
888     {
889         require(tAmount <= _tTotal, "Amount must be less than supply");
890         if (!deductTransferFee) {
891             (uint256 rAmount, , , , , ) = _getValues(tAmount);
892             return rAmount;
893         } else {
894             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
895             return rTransferAmount;
896         }
897     }
898 
899    
900 
901     // remove limits after token is stable - 30-60 minutes
902     function removeLimits() external onlyOwner returns (bool){
903         limitsInEffect = false;
904         gasLimitActive = false;
905         transferDelayEnabled = false;
906         return true;
907     }
908 
909     function tokenFromReflection(uint256 rAmount)
910         public
911         view
912         returns (uint256)
913     {
914         require(
915             rAmount <= _rTotal,
916             "Amount must be less than total reflections"
917         );
918         uint256 currentRate = _getRate();
919         return rAmount.div(currentRate);
920     }
921 
922     function excludeFromReward(address account) public onlyOwner {
923         require(!_isExcluded[account], "Account is already excluded");
924         require(_excluded.length + 1 <= 50, "Cannot exclude more than 50 accounts.  Include a previously excluded address.");
925         if (_rOwned[account] > 0) {
926             _tOwned[account] = tokenFromReflection(_rOwned[account]);
927         }
928         _isExcluded[account] = true;
929         _excluded.push(account);
930     }
931 
932     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
933         _isExcludedMaxTransactionAmount[updAds] = isEx;
934         emit ExcludedMaxTransactionAmount(updAds, isEx);
935     }
936 
937     function includeInReward(address account) public onlyOwner {
938         require(_isExcluded[account], "Account is not excluded");
939         for (uint256 i = 0; i < _excluded.length; i++) {
940             if (_excluded[i] == account) {
941                 _excluded[i] = _excluded[_excluded.length - 1];
942                 _tOwned[account] = 0;
943                 _isExcluded[account] = false;
944                 _excluded.pop();
945                 break;
946             }
947         }
948     }
949 
950     function _approve(
951         address owner,
952         address spender,
953         uint256 amount
954     ) private {
955         require(owner != address(0), "ERC20: approve from the zero address");
956         require(spender != address(0), "ERC20: approve to the zero address");
957 
958         _allowances[owner][spender] = amount;
959         emit Approval(owner, spender, amount);
960     }
961 
962     function _transfer(
963         address from,
964         address to,
965         uint256 amount
966     ) private {
967         require(from != address(0), "ERC20: transfer from the zero address");
968         require(to != address(0), "ERC20: transfer to the zero address");
969         require(amount > 0, "Transfer amount must be greater than zero");
970 
971         if(!tradingActive){
972             require(_isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading is not active yet.");
973         }
974 
975         if(limitsInEffect){
976             if (
977                 from != owner() &&
978                 to != owner() &&
979                 to != address(0) &&
980                 to != address(0xdead) &&
981                 !inSwapAndLiquify
982             ){
983 
984                 // only use to prevent sniper buys in the first blocks.
985                 if (gasLimitActive && automatedMarketMakerPairs[from]) {
986                     require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
987                 }
988 
989                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
990                 if (transferDelayEnabled){
991                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
992                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
993                         _holderLastTransferTimestamp[tx.origin] = block.number;
994                     }
995                 }
996 
997                 //when buy
998                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
999                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1000                     require(amount + balanceOf(to) <= maxWallet, "Cannot exceed max wallet");
1001                 }
1002                 //when sell
1003                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1004                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1005                 }
1006                 else if (!_isExcludedMaxTransactionAmount[to]){
1007                     require(amount + balanceOf(to) <= maxWallet, "Cannot exceed max wallet");
1008                 }
1009             }
1010         }
1011 
1012         uint256 contractTokenBalance = balanceOf(address(this));
1013         bool overMinimumTokenBalance = contractTokenBalance >=
1014             minimumTokensBeforeSwap;
1015 
1016         // Sell tokens for ETH
1017         if (
1018             !inSwapAndLiquify &&
1019             swapAndLiquifyEnabled &&
1020             balanceOf(uniswapV2Pair) > 0 &&
1021             overMinimumTokenBalance &&
1022             automatedMarketMakerPairs[to]
1023         ) {
1024             swapBack();
1025         }
1026 
1027         removeAllFee();
1028 
1029         buyOrSellSwitch = TRANSFER;
1030 
1031         // If any account belongs to _isExcludedFromFee account then remove the fee
1032         if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
1033             // Buy
1034             if (automatedMarketMakerPairs[from]) {
1035                 _taxFee = _buyTaxFee;
1036                 _liquidityFee = _buyLiquidityFee + _buyMarketingFee;
1037                 if(_liquidityFee > 0){
1038                     buyOrSellSwitch = BUY;
1039                 }
1040             }
1041             // Sell
1042             else if (automatedMarketMakerPairs[to]) {
1043                 _taxFee = _sellTaxFee;
1044                 _liquidityFee = _sellLiquidityFee + _sellMarketingFee;
1045                 if(_liquidityFee > 0){
1046                     buyOrSellSwitch = SELL;
1047                 }
1048             }
1049         }
1050 
1051         _tokenTransfer(from, to, amount);
1052 
1053         restoreAllFee();
1054 
1055     }
1056 
1057     function swapBack() private lockTheSwap {
1058         uint256 contractBalance = balanceOf(address(this));
1059         bool success;
1060         uint256 totalTokensToSwap = _liquidityTokensToSwap + _marketingTokensToSwap;
1061         if(totalTokensToSwap == 0 || contractBalance == 0) {return;}
1062 
1063         // Halve the amount of liquidity tokens
1064         uint256 tokensForLiquidity = (contractBalance * _liquidityTokensToSwap / totalTokensToSwap) / 2;
1065         uint256 amountToSwapForBNB = contractBalance.sub(tokensForLiquidity);
1066 
1067         uint256 initialBNBBalance = address(this).balance;
1068 
1069         swapTokensForBNB(amountToSwapForBNB);
1070 
1071         uint256 bnbBalance = address(this).balance.sub(initialBNBBalance);
1072 
1073         uint256 bnbForMarketing = bnbBalance.mul(_marketingTokensToSwap).div(totalTokensToSwap);
1074 
1075         uint256 bnbForLiquidity = bnbBalance - bnbForMarketing;
1076 
1077         _liquidityTokensToSwap = 0;
1078         _marketingTokensToSwap = 0;
1079 
1080         if(tokensForLiquidity > 0 && bnbForLiquidity > 0){
1081             addLiquidity(tokensForLiquidity, bnbForLiquidity);
1082             emit SwapAndLiquify(amountToSwapForBNB, bnbForLiquidity, tokensForLiquidity);
1083         }
1084 
1085         (success,) = address(marketingAddress).call{value: address(this).balance}("");
1086 
1087     }
1088 
1089     function swapTokensForBNB(uint256 tokenAmount) private {
1090         address[] memory path = new address[](2);
1091         path[0] = address(this);
1092         path[1] = uniswapV2Router.WETH();
1093         _approve(address(this), address(uniswapV2Router), tokenAmount);
1094         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1095             tokenAmount,
1096             0, // accept any amount of ETH
1097             path,
1098             address(this),
1099             block.timestamp
1100         );
1101     }
1102 
1103     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1104         _approve(address(this), address(uniswapV2Router), tokenAmount);
1105         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1106             address(this),
1107             tokenAmount,
1108             0, // slippage is unavoidable
1109             0, // slippage is unavoidable
1110             liquidityAddress,
1111             block.timestamp
1112         );
1113     }
1114 
1115     function _tokenTransfer(
1116         address sender,
1117         address recipient,
1118         uint256 amount
1119     ) private {
1120 
1121         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1122             _transferFromExcluded(sender, recipient, amount);
1123         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1124             _transferToExcluded(sender, recipient, amount);
1125         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1126             _transferBothExcluded(sender, recipient, amount);
1127         } else {
1128             _transferStandard(sender, recipient, amount);
1129         }
1130     }
1131 
1132     function _transferStandard(
1133         address sender,
1134         address recipient,
1135         uint256 tAmount
1136     ) private {
1137         (
1138             uint256 rAmount,
1139             uint256 rTransferAmount,
1140             uint256 rFee,
1141             uint256 tTransferAmount,
1142             uint256 tFee,
1143             uint256 tLiquidity
1144         ) = _getValues(tAmount);
1145         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1146         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1147         _takeLiquidity(tLiquidity);
1148         _reflectFee(rFee, tFee);
1149         emit Transfer(sender, recipient, tTransferAmount);
1150     }
1151 
1152     function _transferToExcluded(
1153         address sender,
1154         address recipient,
1155         uint256 tAmount
1156     ) private {
1157         (
1158             uint256 rAmount,
1159             uint256 rTransferAmount,
1160             uint256 rFee,
1161             uint256 tTransferAmount,
1162             uint256 tFee,
1163             uint256 tLiquidity
1164         ) = _getValues(tAmount);
1165         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1166         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1167         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1168         _takeLiquidity(tLiquidity);
1169         _reflectFee(rFee, tFee);
1170         emit Transfer(sender, recipient, tTransferAmount);
1171     }
1172 
1173     function _transferFromExcluded(
1174         address sender,
1175         address recipient,
1176         uint256 tAmount
1177     ) private {
1178         (
1179             uint256 rAmount,
1180             uint256 rTransferAmount,
1181             uint256 rFee,
1182             uint256 tTransferAmount,
1183             uint256 tFee,
1184             uint256 tLiquidity
1185         ) = _getValues(tAmount);
1186         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1187         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1188         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1189         _takeLiquidity(tLiquidity);
1190         _reflectFee(rFee, tFee);
1191         emit Transfer(sender, recipient, tTransferAmount);
1192     }
1193 
1194     function _transferBothExcluded(
1195         address sender,
1196         address recipient,
1197         uint256 tAmount
1198     ) private {
1199         (
1200             uint256 rAmount,
1201             uint256 rTransferAmount,
1202             uint256 rFee,
1203             uint256 tTransferAmount,
1204             uint256 tFee,
1205             uint256 tLiquidity
1206         ) = _getValues(tAmount);
1207         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1208         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1209         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1210         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1211         _takeLiquidity(tLiquidity);
1212         _reflectFee(rFee, tFee);
1213         emit Transfer(sender, recipient, tTransferAmount);
1214     }
1215 
1216     function _reflectFee(uint256 rFee, uint256 tFee) private {
1217         _rTotal = _rTotal.sub(rFee);
1218         _tFeeTotal = _tFeeTotal.add(tFee);
1219     }
1220 
1221     function _getValues(uint256 tAmount)
1222         private
1223         view
1224         returns (
1225             uint256,
1226             uint256,
1227             uint256,
1228             uint256,
1229             uint256,
1230             uint256
1231         )
1232     {
1233         (
1234             uint256 tTransferAmount,
1235             uint256 tFee,
1236             uint256 tLiquidity
1237         ) = _getTValues(tAmount);
1238         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1239             tAmount,
1240             tFee,
1241             tLiquidity,
1242             _getRate()
1243         );
1244         return (
1245             rAmount,
1246             rTransferAmount,
1247             rFee,
1248             tTransferAmount,
1249             tFee,
1250             tLiquidity
1251         );
1252     }
1253 
1254     function _getTValues(uint256 tAmount)
1255         private
1256         view
1257         returns (
1258             uint256,
1259             uint256,
1260             uint256
1261         )
1262     {
1263         uint256 tFee = calculateTaxFee(tAmount);
1264         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1265         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1266         return (tTransferAmount, tFee, tLiquidity);
1267     }
1268 
1269     function _getRValues(
1270         uint256 tAmount,
1271         uint256 tFee,
1272         uint256 tLiquidity,
1273         uint256 currentRate
1274     )
1275         private
1276         pure
1277         returns (
1278             uint256,
1279             uint256,
1280             uint256
1281         )
1282     {
1283         uint256 rAmount = tAmount.mul(currentRate);
1284         uint256 rFee = tFee.mul(currentRate);
1285         uint256 rLiquidity = tLiquidity.mul(currentRate);
1286         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1287         return (rAmount, rTransferAmount, rFee);
1288     }
1289 
1290     function _getRate() private view returns (uint256) {
1291         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1292         return rSupply.div(tSupply);
1293     }
1294 
1295     function _getCurrentSupply() private view returns (uint256, uint256) {
1296         uint256 rSupply = _rTotal;
1297         uint256 tSupply = _tTotal;
1298         for (uint256 i = 0; i < _excluded.length; i++) {
1299             if (
1300                 _rOwned[_excluded[i]] > rSupply ||
1301                 _tOwned[_excluded[i]] > tSupply
1302             ) return (_rTotal, _tTotal);
1303             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1304             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1305         }
1306         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1307         return (rSupply, tSupply);
1308     }
1309 
1310     function _takeLiquidity(uint256 tLiquidity) private {
1311         if(buyOrSellSwitch == BUY){
1312             _liquidityTokensToSwap += tLiquidity * _buyLiquidityFee / _liquidityFee;
1313             _marketingTokensToSwap += tLiquidity * _buyMarketingFee / _liquidityFee;
1314         } else if(buyOrSellSwitch == SELL){
1315             _liquidityTokensToSwap += tLiquidity * _sellLiquidityFee / _liquidityFee;
1316             _marketingTokensToSwap += tLiquidity * _sellMarketingFee / _liquidityFee;
1317         }
1318         uint256 currentRate = _getRate();
1319         uint256 rLiquidity = tLiquidity.mul(currentRate);
1320         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1321         if (_isExcluded[address(this)])
1322             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1323     }
1324 
1325     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1326         return _amount.mul(_taxFee).div(10**2);
1327     }
1328 
1329     function calculateLiquidityFee(uint256 _amount)
1330         private
1331         view
1332         returns (uint256)
1333     {
1334         return _amount.mul(_liquidityFee).div(10**2);
1335     }
1336 
1337     function removeAllFee() private {
1338         if (_taxFee == 0 && _liquidityFee == 0) return;
1339 
1340         _previousTaxFee = _taxFee;
1341         _previousLiquidityFee = _liquidityFee;
1342 
1343         _taxFee = 0;
1344         _liquidityFee = 0;
1345     }
1346 
1347     function restoreAllFee() private {
1348         _taxFee = _previousTaxFee;
1349         _liquidityFee = _previousLiquidityFee;
1350     }
1351 
1352     function isExcludedFromFee(address account) external view returns (bool) {
1353         return _isExcludedFromFee[account];
1354     }
1355 
1356     function excludeFromFee(address account) external onlyOwner {
1357         _isExcludedFromFee[account] = true;
1358     }
1359 
1360     function includeInFee(address account) external onlyOwner {
1361         _isExcludedFromFee[account] = false;
1362     }
1363 
1364     function setBuyFee(uint256 buyTaxFee, uint256 buyLiquidityFee, uint256 buyMarketingFee)
1365         external
1366         onlyOwner
1367     {
1368         _buyTaxFee = buyTaxFee;
1369         _buyLiquidityFee = buyLiquidityFee;
1370         _buyMarketingFee = buyMarketingFee;
1371         require(_buyTaxFee + _buyLiquidityFee + _buyMarketingFee <= 20, "Must keep taxes below 20%");
1372     }
1373 
1374     function setSellFee(uint256 sellTaxFee, uint256 sellLiquidityFee, uint256 sellMarketingFee)
1375         external
1376         onlyOwner
1377     {
1378         _sellTaxFee = sellTaxFee;
1379         _sellLiquidityFee = sellLiquidityFee;
1380         _sellMarketingFee = sellMarketingFee;
1381         require(_sellTaxFee + _sellLiquidityFee + _sellMarketingFee <= 30, "Must keep taxes below 30%");
1382     }
1383 
1384     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1385         marketingAddress = payable(_marketingAddress);
1386         _isExcludedFromFee[marketingAddress] = true;
1387     }
1388 
1389     function setLiquidityAddress(address _liquidityAddress) external onlyOwner {
1390         liquidityAddress = payable(_liquidityAddress);
1391         _isExcludedFromFee[liquidityAddress] = true;
1392     }
1393 
1394     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1395         swapAndLiquifyEnabled = _enabled;
1396         emit SwapAndLiquifyEnabledUpdated(_enabled);
1397     }
1398 
1399     // useful for buybacks or to reclaim any BNB on the contract in a way that helps holders.
1400     function buyBackTokens(uint256 bnbAmountInWei) external onlyOwner {
1401         // generate the uniswap pair path of weth -> eth
1402         address[] memory path = new address[](2);
1403         path[0] = uniswapV2Router.WETH();
1404         path[1] = address(this);
1405 
1406         // make the swap
1407         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmountInWei}(
1408             0, // accept any amount of Ethereum
1409             path,
1410             address(0xdead),
1411             block.timestamp
1412         );
1413     }
1414 
1415     // To receive ETH from uniswapV2Router when swapping
1416     receive() external payable {}
1417 
1418     function transferForeignToken(address _token, address _to)
1419         external
1420         onlyOwner
1421         returns (bool _sent)
1422     {
1423         require(_token != address(this), "Can't withdraw native tokens");
1424         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1425         _sent = IERC20(_token).transfer(_to, _contractBalance);
1426     }
1427 }