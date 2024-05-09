1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-27
3 */
4 
5 /*   
6 ░██████╗██████╗░██████╗░░█████╗░██╗░░░██╗████████╗
7 ██╔════╝██╔══██╗██╔══██╗██╔══██╗██║░░░██║╚══██╔══╝
8 ╚█████╗░██████╔╝██████╔╝██║░░██║██║░░░██║░░░██║░░░
9 ░╚═══██╗██╔═══╝░██╔══██╗██║░░██║██║░░░██║░░░██║░░░
10 ██████╔╝██║░░░░░██║░░██║╚█████╔╝╚██████╔╝░░░██║░░░
11 ╚═════╝░╚═╝░░░░░╚═╝░░╚═╝░╚════╝░░╚═════╝░░░░╚═╝░░░
12 THEPLANTDAO - https://plantdao.io/
13 */
14 
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity 0.8.9;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return payable(msg.sender);
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 interface IERC20 {
31     function totalSupply() external view returns (uint256);
32 
33     function balanceOf(address account) external view returns (uint256);
34 
35     function transfer(address recipient, uint256 amount)
36         external
37         returns (bool);
38 
39     function allowance(address owner, address spender)
40         external
41         view
42         returns (uint256);
43 
44     function approve(address spender, uint256 amount) external returns (bool);
45 
46     function transferFrom(
47         address sender,
48         address recipient,
49         uint256 amount
50     ) external returns (bool);
51 
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(
54         address indexed owner,
55         address indexed spender,
56         uint256 value
57     );
58 }
59 
60 library SafeMath {
61     function add(uint256 a, uint256 b) internal pure returns (uint256) {
62         uint256 c = a + b;
63         require(c >= a, "SafeMath: addition overflow");
64 
65         return c;
66     }
67 
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         return sub(a, b, "SafeMath: subtraction overflow");
70     }
71 
72     function sub(
73         uint256 a,
74         uint256 b,
75         string memory errorMessage
76     ) internal pure returns (uint256) {
77         require(b <= a, errorMessage);
78         uint256 c = a - b;
79 
80         return c;
81     }
82 
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         if (a == 0) {
85             return 0;
86         }
87 
88         uint256 c = a * b;
89         require(c / a == b, "SafeMath: multiplication overflow");
90 
91         return c;
92     }
93 
94     function div(uint256 a, uint256 b) internal pure returns (uint256) {
95         return div(a, b, "SafeMath: division by zero");
96     }
97 
98     function div(
99         uint256 a,
100         uint256 b,
101         string memory errorMessage
102     ) internal pure returns (uint256) {
103         require(b > 0, errorMessage);
104         uint256 c = a / b;
105         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106 
107         return c;
108     }
109 
110     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
111         return mod(a, b, "SafeMath: modulo by zero");
112     }
113 
114     function mod(
115         uint256 a,
116         uint256 b,
117         string memory errorMessage
118     ) internal pure returns (uint256) {
119         require(b != 0, errorMessage);
120         return a % b;
121     }
122 }
123 
124 library Address {
125     function isContract(address account) internal view returns (bool) {
126         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
127         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
128         // for accounts without code, i.e. `keccak256('')`
129         bytes32 codehash;
130         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
131         // solhint-disable-next-line no-inline-assembly
132         assembly {
133             codehash := extcodehash(account)
134         }
135         return (codehash != accountHash && codehash != 0x0);
136     }
137 
138     function sendValue(address payable recipient, uint256 amount) internal {
139         require(
140             address(this).balance >= amount,
141             "Address: insufficient balance"
142         );
143 
144         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
145         (bool success, ) = recipient.call{value: amount}("");
146         require(
147             success,
148             "Address: unable to send value, recipient may have reverted"
149         );
150     }
151 
152     function functionCall(address target, bytes memory data)
153         internal
154         returns (bytes memory)
155     {
156         return functionCall(target, data, "Address: low-level call failed");
157     }
158 
159     function functionCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal returns (bytes memory) {
164         return _functionCallWithValue(target, data, 0, errorMessage);
165     }
166 
167     function functionCallWithValue(
168         address target,
169         bytes memory data,
170         uint256 value
171     ) internal returns (bytes memory) {
172         return
173             functionCallWithValue(
174                 target,
175                 data,
176                 value,
177                 "Address: low-level call with value failed"
178             );
179     }
180 
181     function functionCallWithValue(
182         address target,
183         bytes memory data,
184         uint256 value,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         require(
188             address(this).balance >= value,
189             "Address: insufficient balance for call"
190         );
191         return _functionCallWithValue(target, data, value, errorMessage);
192     }
193 
194     function _functionCallWithValue(
195         address target,
196         bytes memory data,
197         uint256 weiValue,
198         string memory errorMessage
199     ) private returns (bytes memory) {
200         require(isContract(target), "Address: call to non-contract");
201 
202         (bool success, bytes memory returndata) = target.call{value: weiValue}(
203             data
204         );
205         if (success) {
206             return returndata;
207         } else {
208             if (returndata.length > 0) {
209                 assembly {
210                     let returndata_size := mload(returndata)
211                     revert(add(32, returndata), returndata_size)
212                 }
213             } else {
214                 revert(errorMessage);
215             }
216         }
217     }
218 }
219 
220 contract Ownable is Context {
221     address private _owner;
222     address private _previousOwner;
223     uint256 private _lockTime;
224 
225     event OwnershipTransferred(
226         address indexed previousOwner,
227         address indexed newOwner
228     );
229 
230     constructor() {
231         address msgSender = _msgSender();
232         _owner = msgSender;
233         emit OwnershipTransferred(address(0), msgSender);
234     }
235 
236     function owner() public view returns (address) {
237         return _owner;
238     }
239 
240     modifier onlyOwner() {
241         require(_owner == _msgSender(), "Ownable: caller is not the owner");
242         _;
243     }
244 
245     function renounceOwnership() public virtual onlyOwner {
246         emit OwnershipTransferred(_owner, address(0));
247         _owner = address(0);
248     }
249 
250     function transferOwnership(address newOwner) public virtual onlyOwner {
251         require(
252             newOwner != address(0),
253             "Ownable: new owner is the zero address"
254         );
255         emit OwnershipTransferred(_owner, newOwner);
256         _owner = newOwner;
257     }
258 
259     function getUnlockTime() public view returns (uint256) {
260         return _lockTime;
261     }
262 
263     function getTime() public view returns (uint256) {
264         return block.timestamp;
265     }
266 }
267 
268 
269 interface IUniswapV2Factory {
270     event PairCreated(
271         address indexed token0,
272         address indexed token1,
273         address pair,
274         uint256
275     );
276 
277     function feeTo() external view returns (address);
278 
279     function feeToSetter() external view returns (address);
280 
281     function getPair(address tokenA, address tokenB)
282         external
283         view
284         returns (address pair);
285 
286     function allPairs(uint256) external view returns (address pair);
287 
288     function allPairsLength() external view returns (uint256);
289 
290     function createPair(address tokenA, address tokenB)
291         external
292         returns (address pair);
293 
294     function setFeeTo(address) external;
295 
296     function setFeeToSetter(address) external;
297 }
298 
299 
300 interface IUniswapV2Pair {
301     event Approval(
302         address indexed owner,
303         address indexed spender,
304         uint256 value
305     );
306     event Transfer(address indexed from, address indexed to, uint256 value);
307 
308     function name() external pure returns (string memory);
309 
310     function symbol() external pure returns (string memory);
311 
312     function decimals() external pure returns (uint8);
313 
314     function totalSupply() external view returns (uint256);
315 
316     function balanceOf(address owner) external view returns (uint256);
317 
318     function allowance(address owner, address spender)
319         external
320         view
321         returns (uint256);
322 
323     function approve(address spender, uint256 value) external returns (bool);
324 
325     function transfer(address to, uint256 value) external returns (bool);
326 
327     function transferFrom(
328         address from,
329         address to,
330         uint256 value
331     ) external returns (bool);
332 
333     function DOMAIN_SEPARATOR() external view returns (bytes32);
334 
335     function PERMIT_TYPEHASH() external pure returns (bytes32);
336 
337     function nonces(address owner) external view returns (uint256);
338 
339     function permit(
340         address owner,
341         address spender,
342         uint256 value,
343         uint256 deadline,
344         uint8 v,
345         bytes32 r,
346         bytes32 s
347     ) external;
348 
349     event Burn(
350         address indexed sender,
351         uint256 amount0,
352         uint256 amount1,
353         address indexed to
354     );
355     event Swap(
356         address indexed sender,
357         uint256 amount0In,
358         uint256 amount1In,
359         uint256 amount0Out,
360         uint256 amount1Out,
361         address indexed to
362     );
363     event Sync(uint112 reserve0, uint112 reserve1);
364 
365     function MINIMUM_LIQUIDITY() external pure returns (uint256);
366 
367     function factory() external view returns (address);
368 
369     function token0() external view returns (address);
370 
371     function token1() external view returns (address);
372 
373     function getReserves()
374         external
375         view
376         returns (
377             uint112 reserve0,
378             uint112 reserve1,
379             uint32 blockTimestampLast
380         );
381 
382     function price0CumulativeLast() external view returns (uint256);
383 
384     function price1CumulativeLast() external view returns (uint256);
385 
386     function kLast() external view returns (uint256);
387 
388     function burn(address to)
389         external
390         returns (uint256 amount0, uint256 amount1);
391 
392     function swap(
393         uint256 amount0Out,
394         uint256 amount1Out,
395         address to,
396         bytes calldata data
397     ) external;
398 
399     function skim(address to) external;
400 
401     function sync() external;
402 
403     function initialize(address, address) external;
404 }
405 
406 interface IUniswapV2Router01 {
407     function factory() external pure returns (address);
408 
409     function WETH() external pure returns (address);
410 
411     function addLiquidity(
412         address tokenA,
413         address tokenB,
414         uint256 amountADesired,
415         uint256 amountBDesired,
416         uint256 amountAMin,
417         uint256 amountBMin,
418         address to,
419         uint256 deadline
420     )
421         external
422         returns (
423             uint256 amountA,
424             uint256 amountB,
425             uint256 liquidity
426         );
427 
428     function addLiquidityETH(
429         address token,
430         uint256 amountTokenDesired,
431         uint256 amountTokenMin,
432         uint256 amountETHMin,
433         address to,
434         uint256 deadline
435     )
436         external
437         payable
438         returns (
439             uint256 amountToken,
440             uint256 amountETH,
441             uint256 liquidity
442         );
443 
444     function removeLiquidity(
445         address tokenA,
446         address tokenB,
447         uint256 liquidity,
448         uint256 amountAMin,
449         uint256 amountBMin,
450         address to,
451         uint256 deadline
452     ) external returns (uint256 amountA, uint256 amountB);
453 
454     function removeLiquidityETH(
455         address token,
456         uint256 liquidity,
457         uint256 amountTokenMin,
458         uint256 amountETHMin,
459         address to,
460         uint256 deadline
461     ) external returns (uint256 amountToken, uint256 amountETH);
462 
463     function removeLiquidityWithPermit(
464         address tokenA,
465         address tokenB,
466         uint256 liquidity,
467         uint256 amountAMin,
468         uint256 amountBMin,
469         address to,
470         uint256 deadline,
471         bool approveMax,
472         uint8 v,
473         bytes32 r,
474         bytes32 s
475     ) external returns (uint256 amountA, uint256 amountB);
476 
477     function removeLiquidityETHWithPermit(
478         address token,
479         uint256 liquidity,
480         uint256 amountTokenMin,
481         uint256 amountETHMin,
482         address to,
483         uint256 deadline,
484         bool approveMax,
485         uint8 v,
486         bytes32 r,
487         bytes32 s
488     ) external returns (uint256 amountToken, uint256 amountETH);
489 
490     function swapExactTokensForTokens(
491         uint256 amountIn,
492         uint256 amountOutMin,
493         address[] calldata path,
494         address to,
495         uint256 deadline
496     ) external returns (uint256[] memory amounts);
497 
498     function swapTokensForExactTokens(
499         uint256 amountOut,
500         uint256 amountInMax,
501         address[] calldata path,
502         address to,
503         uint256 deadline
504     ) external returns (uint256[] memory amounts);
505 
506     function swapExactETHForTokens(
507         uint256 amountOutMin,
508         address[] calldata path,
509         address to,
510         uint256 deadline
511     ) external payable returns (uint256[] memory amounts);
512 
513     function swapTokensForExactETH(
514         uint256 amountOut,
515         uint256 amountInMax,
516         address[] calldata path,
517         address to,
518         uint256 deadline
519     ) external returns (uint256[] memory amounts);
520 
521     function swapExactTokensForETH(
522         uint256 amountIn,
523         uint256 amountOutMin,
524         address[] calldata path,
525         address to,
526         uint256 deadline
527     ) external returns (uint256[] memory amounts);
528 
529     function swapETHForExactTokens(
530         uint256 amountOut,
531         address[] calldata path,
532         address to,
533         uint256 deadline
534     ) external payable returns (uint256[] memory amounts);
535 
536     function quote(
537         uint256 amountA,
538         uint256 reserveA,
539         uint256 reserveB
540     ) external pure returns (uint256 amountB);
541 
542     function getAmountOut(
543         uint256 amountIn,
544         uint256 reserveIn,
545         uint256 reserveOut
546     ) external pure returns (uint256 amountOut);
547 
548     function getAmountIn(
549         uint256 amountOut,
550         uint256 reserveIn,
551         uint256 reserveOut
552     ) external pure returns (uint256 amountIn);
553 
554     function getAmountsOut(uint256 amountIn, address[] calldata path)
555         external
556         view
557         returns (uint256[] memory amounts);
558 
559     function getAmountsIn(uint256 amountOut, address[] calldata path)
560         external
561         view
562         returns (uint256[] memory amounts);
563 }
564 
565 interface IUniswapV2Router02 is IUniswapV2Router01 {
566     function removeLiquidityETHSupportingFeeOnTransferTokens(
567         address token,
568         uint256 liquidity,
569         uint256 amountTokenMin,
570         uint256 amountETHMin,
571         address to,
572         uint256 deadline
573     ) external returns (uint256 amountETH);
574 
575     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
576         address token,
577         uint256 liquidity,
578         uint256 amountTokenMin,
579         uint256 amountETHMin,
580         address to,
581         uint256 deadline,
582         bool approveMax,
583         uint8 v,
584         bytes32 r,
585         bytes32 s
586     ) external returns (uint256 amountETH);
587 
588     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
589         uint256 amountIn,
590         uint256 amountOutMin,
591         address[] calldata path,
592         address to,
593         uint256 deadline
594     ) external;
595 
596     function swapExactETHForTokensSupportingFeeOnTransferTokens(
597         uint256 amountOutMin,
598         address[] calldata path,
599         address to,
600         uint256 deadline
601     ) external payable;
602 
603     function swapExactTokensForETHSupportingFeeOnTransferTokens(
604         uint256 amountIn,
605         uint256 amountOutMin,
606         address[] calldata path,
607         address to,
608         uint256 deadline
609     ) external;
610 }
611 
612 contract THEPLANTDAO is Context, IERC20, Ownable {
613     using SafeMath for uint256;
614     using Address for address;
615 
616     address payable public marketingAddress = payable(0xdEA44A73ce2d4f66979d8E501A5BF12055E2acd6); // Marketing Address
617 
618     address payable public liquidityAddress =
619         payable(0x976Fa404A29d96cae5dd6B9f74C44394C9F4087e); // Liquidity Address
620 
621     mapping(address => uint256) private _rOwned;
622     mapping(address => uint256) private _tOwned;
623     mapping(address => mapping(address => uint256)) private _allowances;
624 
625     mapping(address => bool) private _isExcludedFromFee;
626 
627     mapping(address => bool) private _isExcluded;
628     address[] private _excluded;
629 
630     uint256 private constant MAX = ~uint256(0);
631     uint256 private constant _tTotal = 100 * 1e9 * 1e18;
632     uint256 private _rTotal = (MAX - (MAX % _tTotal));
633     uint256 private _tFeeTotal;
634 
635     string private constant _name = "SPROUT";
636     string private constant _symbol = "SPROUT";
637     uint8 private constant _decimals = 18;
638 
639     uint256 private constant BUY = 1;
640     uint256 private constant SELL = 2;
641     uint256 private constant TRANSFER = 3;
642     uint256 private buyOrSellSwitch;
643 
644     // these values are pretty much arbitrary since they get overwritten for every txn, but the placeholders make it easier to work with current contract.
645     uint256 private _taxFee;
646     uint256 private _previousTaxFee = _taxFee;
647 
648     uint256 private _liquidityFee;
649     uint256 private _previousLiquidityFee = _liquidityFee;
650 
651     uint256 public _buyTaxFee = 1;
652     uint256 public _buyLiquidityFee = 9;
653     uint256 public _buyMarketingFee = 6;
654 
655     uint256 public _sellTaxFee = 1;
656     uint256 public _sellLiquidityFee = 9;
657     uint256 public _sellMarketingFee = 6;
658 
659     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
660     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
661 
662     bool public limitsInEffect = true;
663     bool public tradingActive = false;
664     bool public swapEnabled = false;
665 
666     mapping (address => bool) public _isExcludedMaxTransactionAmount;
667 
668      // Anti-bot and anti-whale mappings and variables
669     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
670     bool public transferDelayEnabled = true;
671 
672     uint256 private _liquidityTokensToSwap;
673     uint256 private _marketingTokensToSwap;
674 
675     bool private gasLimitActive = true;
676     uint256 private gasPriceLimit = 602 * 1 gwei;
677 
678     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
679     // could be subject to a maximum transfer amount
680     mapping (address => bool) public automatedMarketMakerPairs;
681 
682     uint256 public minimumTokensBeforeSwap;
683     uint256 public maxTransactionAmount;
684     uint256 public maxWallet;
685 
686     IUniswapV2Router02 public uniswapV2Router;
687     address public uniswapV2Pair;
688 
689     bool inSwapAndLiquify;
690     bool public swapAndLiquifyEnabled = false;
691 
692     event RewardLiquidityProviders(uint256 tokenAmount);
693     event SwapAndLiquifyEnabledUpdated(bool enabled);
694     event SwapAndLiquify(
695         uint256 tokensSwapped,
696         uint256 ethReceived,
697         uint256 tokensIntoLiqudity
698     );
699 
700     event SwapETHForTokens(uint256 amountIn, address[] path);
701 
702     event SwapTokensForETH(uint256 amountIn, address[] path);
703 
704     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
705 
706     modifier lockTheSwap() {
707         inSwapAndLiquify = true;
708         _;
709         inSwapAndLiquify = false;
710     }
711 
712     constructor() {
713         address newOwner = msg.sender; // update if auto-deploying to a different wallet
714         address futureOwner = address(msg.sender); // use if ownership will be transferred after deployment.
715 
716         maxTransactionAmount = _tTotal * 3 / 1000; // 0.3% max txn
717         minimumTokensBeforeSwap = _tTotal * 5 / 10000; // 0.05%
718         maxWallet = _tTotal * 1 / 100; // 1%
719 
720         _rOwned[newOwner] = _rTotal;
721 
722         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
723             // ROPSTEN or HARDHAT
724             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
725         );
726 
727         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
728             .createPair(address(this), _uniswapV2Router.WETH());
729 
730         uniswapV2Router = _uniswapV2Router;
731         uniswapV2Pair = _uniswapV2Pair;
732 
733         marketingAddress = payable(msg.sender); // update to marketing address
734         liquidityAddress = payable(address(0xdead)); // update to a liquidity wallet if you don't want to burn LP tokens generated by the contract.
735 
736         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
737 
738         _isExcludedFromFee[newOwner] = true;
739         _isExcludedFromFee[futureOwner] = true; // pre-exclude future owner wallet
740         _isExcludedFromFee[address(this)] = true;
741         _isExcludedFromFee[liquidityAddress] = true;
742 
743         excludeFromMaxTransaction(newOwner, true);
744         excludeFromMaxTransaction(futureOwner, true); // pre-exclude future owner wallet
745         excludeFromMaxTransaction(address(this), true);
746         excludeFromMaxTransaction(address(_uniswapV2Router), true);
747         excludeFromMaxTransaction(address(0xdead), true);
748 
749         emit Transfer(address(0), newOwner, _tTotal);
750     }
751 
752     function name() external pure returns (string memory) {
753         return _name;
754     }
755 
756     function symbol() external pure returns (string memory) {
757         return _symbol;
758     }
759 
760     function decimals() external pure returns (uint8) {
761         return _decimals;
762     }
763 
764     function totalSupply() external pure override returns (uint256) {
765         return _tTotal;
766     }
767 
768     function balanceOf(address account) public view override returns (uint256) {
769         if (_isExcluded[account]) return _tOwned[account];
770         return tokenFromReflection(_rOwned[account]);
771     }
772 
773     function transfer(address recipient, uint256 amount)
774         external
775         override
776         returns (bool)
777     {
778         _transfer(_msgSender(), recipient, amount);
779         return true;
780     }
781 
782     function allowance(address owner, address spender)
783         external
784         view
785         override
786         returns (uint256)
787     {
788         return _allowances[owner][spender];
789     }
790 
791     function approve(address spender, uint256 amount)
792         public
793         override
794         returns (bool)
795     {
796         _approve(_msgSender(), spender, amount);
797         return true;
798     }
799 
800     function transferFrom(
801         address sender,
802         address recipient,
803         uint256 amount
804     ) external override returns (bool) {
805         _transfer(sender, recipient, amount);
806         _approve(
807             sender,
808             _msgSender(),
809             _allowances[sender][_msgSender()].sub(
810                 amount,
811                 "ERC20: transfer amount exceeds allowance"
812             )
813         );
814         return true;
815     }
816 
817     function increaseAllowance(address spender, uint256 addedValue)
818         external
819         virtual
820         returns (bool)
821     {
822         _approve(
823             _msgSender(),
824             spender,
825             _allowances[_msgSender()][spender].add(addedValue)
826         );
827         return true;
828     }
829 
830     function decreaseAllowance(address spender, uint256 subtractedValue)
831         external
832         virtual
833         returns (bool)
834     {
835         _approve(
836             _msgSender(),
837             spender,
838             _allowances[_msgSender()][spender].sub(
839                 subtractedValue,
840                 "ERC20: decreased allowance below zero"
841             )
842         );
843         return true;
844     }
845 
846     function isExcludedFromReward(address account)
847         external
848         view
849         returns (bool)
850     {
851         return _isExcluded[account];
852     }
853 
854     function totalFees() external view returns (uint256) {
855         return _tFeeTotal;
856     }
857 
858     // once enabled, can never be turned off
859     function enableTrading() external onlyOwner {
860         tradingActive = true;
861         swapAndLiquifyEnabled = true;
862         tradingActiveBlock = block.number;
863     }
864 
865     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
866         return minimumTokensBeforeSwap;
867     }
868 
869     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
870         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
871 
872         _setAutomatedMarketMakerPair(pair, value);
873     }
874 
875     function _setAutomatedMarketMakerPair(address pair, bool value) private {
876         automatedMarketMakerPairs[pair] = value;
877 
878         excludeFromMaxTransaction(pair, value);
879         if(value){excludeFromReward(pair);}
880         if(!value){includeInReward(pair);}
881     }
882 
883     function setProtectionSettings(bool antiGas) external onlyOwner() {
884         gasLimitActive = antiGas;
885     }
886 
887     function setGasPriceLimit(uint256 gas) external onlyOwner {
888         require(gas >= 300);
889         gasPriceLimit = gas * 1 gwei;
890     }
891 
892     // disable Transfer delay
893     function disableTransferDelay() external onlyOwner returns (bool){
894         transferDelayEnabled = false;
895         return true;
896     }
897 
898     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
899         external
900         view
901         returns (uint256)
902     {
903         require(tAmount <= _tTotal, "Amount must be less than supply");
904         if (!deductTransferFee) {
905             (uint256 rAmount, , , , , ) = _getValues(tAmount);
906             return rAmount;
907         } else {
908             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
909             return rTransferAmount;
910         }
911     }
912 
913     // for one-time airdrop feature after contract launch
914     function airdropToWallets(address[] memory airdropWallets, uint256[] memory amount) external onlyOwner() {
915         require(airdropWallets.length == amount.length, "airdropToWallets:: Arrays must be the same length");
916         removeAllFee();
917         buyOrSellSwitch = TRANSFER;
918         for(uint256 i = 0; i < airdropWallets.length; i++){
919             address wallet = airdropWallets[i];
920             uint256 airdropAmount = amount[i];
921             _tokenTransfer(msg.sender, wallet, airdropAmount);
922         }
923         restoreAllFee();
924     }
925 
926     // remove limits after token is stable - 30-60 minutes
927     function removeLimits() external onlyOwner returns (bool){
928         limitsInEffect = false;
929         gasLimitActive = false;
930         transferDelayEnabled = false;
931         return true;
932     }
933 
934     function tokenFromReflection(uint256 rAmount)
935         public
936         view
937         returns (uint256)
938     {
939         require(
940             rAmount <= _rTotal,
941             "Amount must be less than total reflections"
942         );
943         uint256 currentRate = _getRate();
944         return rAmount.div(currentRate);
945     }
946 
947     function excludeFromReward(address account) public onlyOwner {
948         require(!_isExcluded[account], "Account is already excluded");
949         require(_excluded.length + 1 <= 50, "Cannot exclude more than 50 accounts.  Include a previously excluded address.");
950         if (_rOwned[account] > 0) {
951             _tOwned[account] = tokenFromReflection(_rOwned[account]);
952         }
953         _isExcluded[account] = true;
954         _excluded.push(account);
955     }
956 
957     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
958         _isExcludedMaxTransactionAmount[updAds] = isEx;
959         emit ExcludedMaxTransactionAmount(updAds, isEx);
960     }
961 
962     function includeInReward(address account) public onlyOwner {
963         require(_isExcluded[account], "Account is not excluded");
964         for (uint256 i = 0; i < _excluded.length; i++) {
965             if (_excluded[i] == account) {
966                 _excluded[i] = _excluded[_excluded.length - 1];
967                 _tOwned[account] = 0;
968                 _isExcluded[account] = false;
969                 _excluded.pop();
970                 break;
971             }
972         }
973     }
974 
975     function _approve(
976         address owner,
977         address spender,
978         uint256 amount
979     ) private {
980         require(owner != address(0), "ERC20: approve from the zero address");
981         require(spender != address(0), "ERC20: approve to the zero address");
982 
983         _allowances[owner][spender] = amount;
984         emit Approval(owner, spender, amount);
985     }
986 
987     function _transfer(
988         address from,
989         address to,
990         uint256 amount
991     ) private {
992         require(from != address(0), "ERC20: transfer from the zero address");
993         require(to != address(0), "ERC20: transfer to the zero address");
994         require(amount > 0, "Transfer amount must be greater than zero");
995 
996         if(!tradingActive){
997             require(_isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading is not active yet.");
998         }
999 
1000         if(limitsInEffect){
1001             if (
1002                 from != owner() &&
1003                 to != owner() &&
1004                 to != address(0) &&
1005                 to != address(0xdead) &&
1006                 !inSwapAndLiquify
1007             ){
1008 
1009                 // only use to prevent sniper buys in the first blocks.
1010                 if (gasLimitActive && automatedMarketMakerPairs[from]) {
1011                     require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
1012                 }
1013 
1014                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1015                 if (transferDelayEnabled){
1016                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1017                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1018                         _holderLastTransferTimestamp[tx.origin] = block.number;
1019                     }
1020                 }
1021 
1022                 //when buy
1023                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1024                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1025                     require(amount + balanceOf(to) <= maxWallet, "Cannot exceed max wallet");
1026                 }
1027                 //when sell
1028                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1029                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1030                 }
1031                 else if (!_isExcludedMaxTransactionAmount[to]){
1032                     require(amount + balanceOf(to) <= maxWallet, "Cannot exceed max wallet");
1033                 }
1034             }
1035         }
1036 
1037         uint256 contractTokenBalance = balanceOf(address(this));
1038         bool overMinimumTokenBalance = contractTokenBalance >=
1039             minimumTokensBeforeSwap;
1040 
1041         // Sell tokens for ETH
1042         if (
1043             !inSwapAndLiquify &&
1044             swapAndLiquifyEnabled &&
1045             balanceOf(uniswapV2Pair) > 0 &&
1046             overMinimumTokenBalance &&
1047             automatedMarketMakerPairs[to]
1048         ) {
1049             swapBack();
1050         }
1051 
1052         removeAllFee();
1053 
1054         buyOrSellSwitch = TRANSFER;
1055 
1056         // If any account belongs to _isExcludedFromFee account then remove the fee
1057         if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
1058             // Buy
1059             if (automatedMarketMakerPairs[from]) {
1060                 _taxFee = _buyTaxFee;
1061                 _liquidityFee = _buyLiquidityFee + _buyMarketingFee;
1062                 if(_liquidityFee > 0){
1063                     buyOrSellSwitch = BUY;
1064                 }
1065             }
1066             // Sell
1067             else if (automatedMarketMakerPairs[to]) {
1068                 _taxFee = _sellTaxFee;
1069                 _liquidityFee = _sellLiquidityFee + _sellMarketingFee;
1070                 if(_liquidityFee > 0){
1071                     buyOrSellSwitch = SELL;
1072                 }
1073             }
1074         }
1075 
1076         _tokenTransfer(from, to, amount);
1077 
1078         restoreAllFee();
1079 
1080     }
1081 
1082     function swapBack() private lockTheSwap {
1083         uint256 contractBalance = balanceOf(address(this));
1084         bool success;
1085         uint256 totalTokensToSwap = _liquidityTokensToSwap + _marketingTokensToSwap;
1086         if(totalTokensToSwap == 0 || contractBalance == 0) {return;}
1087 
1088         // Halve the amount of liquidity tokens
1089         uint256 tokensForLiquidity = (contractBalance * _liquidityTokensToSwap / totalTokensToSwap) / 2;
1090         uint256 amountToSwapForBNB = contractBalance.sub(tokensForLiquidity);
1091 
1092         uint256 initialBNBBalance = address(this).balance;
1093 
1094         swapTokensForBNB(amountToSwapForBNB);
1095 
1096         uint256 bnbBalance = address(this).balance.sub(initialBNBBalance);
1097 
1098         uint256 bnbForMarketing = bnbBalance.mul(_marketingTokensToSwap).div(totalTokensToSwap);
1099 
1100         uint256 bnbForLiquidity = bnbBalance - bnbForMarketing;
1101 
1102         _liquidityTokensToSwap = 0;
1103         _marketingTokensToSwap = 0;
1104 
1105         if(tokensForLiquidity > 0 && bnbForLiquidity > 0){
1106             addLiquidity(tokensForLiquidity, bnbForLiquidity);
1107             emit SwapAndLiquify(amountToSwapForBNB, bnbForLiquidity, tokensForLiquidity);
1108         }
1109 
1110         (success,) = address(marketingAddress).call{value: address(this).balance}("");
1111 
1112     }
1113 
1114     function swapTokensForBNB(uint256 tokenAmount) private {
1115         address[] memory path = new address[](2);
1116         path[0] = address(this);
1117         path[1] = uniswapV2Router.WETH();
1118         _approve(address(this), address(uniswapV2Router), tokenAmount);
1119         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1120             tokenAmount,
1121             0, // accept any amount of ETH
1122             path,
1123             address(this),
1124             block.timestamp
1125         );
1126     }
1127 
1128     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1129         _approve(address(this), address(uniswapV2Router), tokenAmount);
1130         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1131             address(this),
1132             tokenAmount,
1133             0, // slippage is unavoidable
1134             0, // slippage is unavoidable
1135             liquidityAddress,
1136             block.timestamp
1137         );
1138     }
1139 
1140     function _tokenTransfer(
1141         address sender,
1142         address recipient,
1143         uint256 amount
1144     ) private {
1145 
1146         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1147             _transferFromExcluded(sender, recipient, amount);
1148         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1149             _transferToExcluded(sender, recipient, amount);
1150         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1151             _transferBothExcluded(sender, recipient, amount);
1152         } else {
1153             _transferStandard(sender, recipient, amount);
1154         }
1155     }
1156 
1157     function _transferStandard(
1158         address sender,
1159         address recipient,
1160         uint256 tAmount
1161     ) private {
1162         (
1163             uint256 rAmount,
1164             uint256 rTransferAmount,
1165             uint256 rFee,
1166             uint256 tTransferAmount,
1167             uint256 tFee,
1168             uint256 tLiquidity
1169         ) = _getValues(tAmount);
1170         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1171         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1172         _takeLiquidity(tLiquidity);
1173         _reflectFee(rFee, tFee);
1174         emit Transfer(sender, recipient, tTransferAmount);
1175     }
1176 
1177     function _transferToExcluded(
1178         address sender,
1179         address recipient,
1180         uint256 tAmount
1181     ) private {
1182         (
1183             uint256 rAmount,
1184             uint256 rTransferAmount,
1185             uint256 rFee,
1186             uint256 tTransferAmount,
1187             uint256 tFee,
1188             uint256 tLiquidity
1189         ) = _getValues(tAmount);
1190         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1191         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1192         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1193         _takeLiquidity(tLiquidity);
1194         _reflectFee(rFee, tFee);
1195         emit Transfer(sender, recipient, tTransferAmount);
1196     }
1197 
1198     function _transferFromExcluded(
1199         address sender,
1200         address recipient,
1201         uint256 tAmount
1202     ) private {
1203         (
1204             uint256 rAmount,
1205             uint256 rTransferAmount,
1206             uint256 rFee,
1207             uint256 tTransferAmount,
1208             uint256 tFee,
1209             uint256 tLiquidity
1210         ) = _getValues(tAmount);
1211         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1212         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1213         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1214         _takeLiquidity(tLiquidity);
1215         _reflectFee(rFee, tFee);
1216         emit Transfer(sender, recipient, tTransferAmount);
1217     }
1218 
1219     function _transferBothExcluded(
1220         address sender,
1221         address recipient,
1222         uint256 tAmount
1223     ) private {
1224         (
1225             uint256 rAmount,
1226             uint256 rTransferAmount,
1227             uint256 rFee,
1228             uint256 tTransferAmount,
1229             uint256 tFee,
1230             uint256 tLiquidity
1231         ) = _getValues(tAmount);
1232         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1233         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1234         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1235         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1236         _takeLiquidity(tLiquidity);
1237         _reflectFee(rFee, tFee);
1238         emit Transfer(sender, recipient, tTransferAmount);
1239     }
1240 
1241     function _reflectFee(uint256 rFee, uint256 tFee) private {
1242         _rTotal = _rTotal.sub(rFee);
1243         _tFeeTotal = _tFeeTotal.add(tFee);
1244     }
1245 
1246     function _getValues(uint256 tAmount)
1247         private
1248         view
1249         returns (
1250             uint256,
1251             uint256,
1252             uint256,
1253             uint256,
1254             uint256,
1255             uint256
1256         )
1257     {
1258         (
1259             uint256 tTransferAmount,
1260             uint256 tFee,
1261             uint256 tLiquidity
1262         ) = _getTValues(tAmount);
1263         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1264             tAmount,
1265             tFee,
1266             tLiquidity,
1267             _getRate()
1268         );
1269         return (
1270             rAmount,
1271             rTransferAmount,
1272             rFee,
1273             tTransferAmount,
1274             tFee,
1275             tLiquidity
1276         );
1277     }
1278 
1279     function _getTValues(uint256 tAmount)
1280         private
1281         view
1282         returns (
1283             uint256,
1284             uint256,
1285             uint256
1286         )
1287     {
1288         uint256 tFee = calculateTaxFee(tAmount);
1289         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1290         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1291         return (tTransferAmount, tFee, tLiquidity);
1292     }
1293 
1294     function _getRValues(
1295         uint256 tAmount,
1296         uint256 tFee,
1297         uint256 tLiquidity,
1298         uint256 currentRate
1299     )
1300         private
1301         pure
1302         returns (
1303             uint256,
1304             uint256,
1305             uint256
1306         )
1307     {
1308         uint256 rAmount = tAmount.mul(currentRate);
1309         uint256 rFee = tFee.mul(currentRate);
1310         uint256 rLiquidity = tLiquidity.mul(currentRate);
1311         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1312         return (rAmount, rTransferAmount, rFee);
1313     }
1314 
1315     function _getRate() private view returns (uint256) {
1316         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1317         return rSupply.div(tSupply);
1318     }
1319 
1320     function _getCurrentSupply() private view returns (uint256, uint256) {
1321         uint256 rSupply = _rTotal;
1322         uint256 tSupply = _tTotal;
1323         for (uint256 i = 0; i < _excluded.length; i++) {
1324             if (
1325                 _rOwned[_excluded[i]] > rSupply ||
1326                 _tOwned[_excluded[i]] > tSupply
1327             ) return (_rTotal, _tTotal);
1328             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1329             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1330         }
1331         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1332         return (rSupply, tSupply);
1333     }
1334 
1335     function _takeLiquidity(uint256 tLiquidity) private {
1336         if(buyOrSellSwitch == BUY){
1337             _liquidityTokensToSwap += tLiquidity * _buyLiquidityFee / _liquidityFee;
1338             _marketingTokensToSwap += tLiquidity * _buyMarketingFee / _liquidityFee;
1339         } else if(buyOrSellSwitch == SELL){
1340             _liquidityTokensToSwap += tLiquidity * _sellLiquidityFee / _liquidityFee;
1341             _marketingTokensToSwap += tLiquidity * _sellMarketingFee / _liquidityFee;
1342         }
1343         uint256 currentRate = _getRate();
1344         uint256 rLiquidity = tLiquidity.mul(currentRate);
1345         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1346         if (_isExcluded[address(this)])
1347             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1348     }
1349 
1350     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1351         return _amount.mul(_taxFee).div(10**2);
1352     }
1353 
1354     function calculateLiquidityFee(uint256 _amount)
1355         private
1356         view
1357         returns (uint256)
1358     {
1359         return _amount.mul(_liquidityFee).div(10**2);
1360     }
1361 
1362     function removeAllFee() private {
1363         if (_taxFee == 0 && _liquidityFee == 0) return;
1364 
1365         _previousTaxFee = _taxFee;
1366         _previousLiquidityFee = _liquidityFee;
1367 
1368         _taxFee = 0;
1369         _liquidityFee = 0;
1370     }
1371 
1372     function restoreAllFee() private {
1373         _taxFee = _previousTaxFee;
1374         _liquidityFee = _previousLiquidityFee;
1375     }
1376 
1377     function isExcludedFromFee(address account) external view returns (bool) {
1378         return _isExcludedFromFee[account];
1379     }
1380 
1381     function excludeFromFee(address account) external onlyOwner {
1382         _isExcludedFromFee[account] = true;
1383     }
1384 
1385     function includeInFee(address account) external onlyOwner {
1386         _isExcludedFromFee[account] = false;
1387     }
1388 
1389     function setBuyFee(uint256 buyTaxFee, uint256 buyLiquidityFee, uint256 buyMarketingFee)
1390         external
1391         onlyOwner
1392     {
1393         _buyTaxFee = buyTaxFee;
1394         _buyLiquidityFee = buyLiquidityFee;
1395         _buyMarketingFee = buyMarketingFee;
1396         require(_buyTaxFee + _buyLiquidityFee + _buyMarketingFee <= 20, "Must keep taxes below 20%");
1397     }
1398 
1399     function setSellFee(uint256 sellTaxFee, uint256 sellLiquidityFee, uint256 sellMarketingFee)
1400         external
1401         onlyOwner
1402     {
1403         _sellTaxFee = sellTaxFee;
1404         _sellLiquidityFee = sellLiquidityFee;
1405         _sellMarketingFee = sellMarketingFee;
1406         require(_sellTaxFee + _sellLiquidityFee + _sellMarketingFee <= 30, "Must keep taxes below 30%");
1407     }
1408 
1409     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1410         marketingAddress = payable(_marketingAddress);
1411         _isExcludedFromFee[marketingAddress] = true;
1412     }
1413 
1414     function setLiquidityAddress(address _liquidityAddress) external onlyOwner {
1415         liquidityAddress = payable(_liquidityAddress);
1416         _isExcludedFromFee[liquidityAddress] = true;
1417     }
1418 
1419     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1420         swapAndLiquifyEnabled = _enabled;
1421         emit SwapAndLiquifyEnabledUpdated(_enabled);
1422     }
1423 
1424     // useful for buybacks or to reclaim any BNB on the contract in a way that helps holders.
1425     function buyBackTokens(uint256 bnbAmountInWei) external onlyOwner {
1426         // generate the uniswap pair path of weth -> eth
1427         address[] memory path = new address[](2);
1428         path[0] = uniswapV2Router.WETH();
1429         path[1] = address(this);
1430 
1431         // make the swap
1432         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmountInWei}(
1433             0, // accept any amount of Ethereum
1434             path,
1435             address(0xdead),
1436             block.timestamp
1437         );
1438     }
1439 
1440     // To receive ETH from uniswapV2Router when swapping
1441     receive() external payable {}
1442 
1443     function transferForeignToken(address _token, address _to)
1444         external
1445         onlyOwner
1446         returns (bool _sent)
1447     {
1448         require(_token != address(this), "Can't withdraw native tokens");
1449         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1450         _sent = IERC20(_token).transfer(_to, _contractBalance);
1451     }
1452 }