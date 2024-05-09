1 /*
2     ////////////////     ///////////////    ////            /////////////
3    ////                          ////     ////            ////     ////
4   ////     ///////           ////       ////            ////////////
5  ////       ////         ////         ////            ////  \\\\
6 //////////////       ////////////   //////////////  ////     \\\\
7 
8 
9 
10 
11 ////////////////       /////////////      ////            /////////////
12 ////                          ////       ////            ////    ////
13 ////     ///////           ////         ////            //////////
14 ////        ////         ////          ////            ////  \\\\
15 //////////////        ////////////   //////////////   ////    \\\\
16 */
17 
18 // SPDX-License-Identifier: MIT
19 
20 pragma solidity 0.8.9;
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address payable) {
24         return payable(msg.sender);
25     }
26 
27     function _msgData() internal view virtual returns (bytes memory) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 interface IERC20 {
34     function totalSupply() external view returns (uint256);
35 
36     function balanceOf(address account) external view returns (uint256);
37 
38     function transfer(address recipient, uint256 amount)
39         external
40         returns (bool);
41 
42     function allowance(address owner, address spender)
43         external
44         view
45         returns (uint256);
46 
47     function approve(address spender, uint256 amount) external returns (bool);
48 
49     function transferFrom(
50         address sender,
51         address recipient,
52         uint256 amount
53     ) external returns (bool);
54 
55     event Transfer(address indexed from, address indexed to, uint256 value);
56     event Approval(
57         address indexed owner,
58         address indexed spender,
59         uint256 value
60     );
61 }
62 
63 library SafeMath {
64     function add(uint256 a, uint256 b) internal pure returns (uint256) {
65         uint256 c = a + b;
66         require(c >= a, "SafeMath: addition overflow");
67 
68         return c;
69     }
70 
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         return sub(a, b, "SafeMath: subtraction overflow");
73     }
74 
75     function sub(
76         uint256 a,
77         uint256 b,
78         string memory errorMessage
79     ) internal pure returns (uint256) {
80         require(b <= a, errorMessage);
81         uint256 c = a - b;
82 
83         return c;
84     }
85 
86     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87         if (a == 0) {
88             return 0;
89         }
90 
91         uint256 c = a * b;
92         require(c / a == b, "SafeMath: multiplication overflow");
93 
94         return c;
95     }
96 
97     function div(uint256 a, uint256 b) internal pure returns (uint256) {
98         return div(a, b, "SafeMath: division by zero");
99     }
100 
101     function div(
102         uint256 a,
103         uint256 b,
104         string memory errorMessage
105     ) internal pure returns (uint256) {
106         require(b > 0, errorMessage);
107         uint256 c = a / b;
108         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
109 
110         return c;
111     }
112 
113     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
114         return mod(a, b, "SafeMath: modulo by zero");
115     }
116 
117     function mod(
118         uint256 a,
119         uint256 b,
120         string memory errorMessage
121     ) internal pure returns (uint256) {
122         require(b != 0, errorMessage);
123         return a % b;
124     }
125 }
126 
127 library Address {
128     function isContract(address account) internal view returns (bool) {
129         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
130         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
131         // for accounts without code, i.e. `keccak256('')`
132         bytes32 codehash;
133         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
134         // solhint-disable-next-line no-inline-assembly
135         assembly {
136             codehash := extcodehash(account)
137         }
138         return (codehash != accountHash && codehash != 0x0);
139     }
140 
141     function sendValue(address payable recipient, uint256 amount) internal {
142         require(
143             address(this).balance >= amount,
144             "Address: insufficient balance"
145         );
146 
147         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
148         (bool success, ) = recipient.call{value: amount}("");
149         require(
150             success,
151             "Address: unable to send value, recipient may have reverted"
152         );
153     }
154 
155     function functionCall(address target, bytes memory data)
156         internal
157         returns (bytes memory)
158     {
159         return functionCall(target, data, "Address: low-level call failed");
160     }
161 
162     function functionCall(
163         address target,
164         bytes memory data,
165         string memory errorMessage
166     ) internal returns (bytes memory) {
167         return _functionCallWithValue(target, data, 0, errorMessage);
168     }
169 
170     function functionCallWithValue(
171         address target,
172         bytes memory data,
173         uint256 value
174     ) internal returns (bytes memory) {
175         return
176             functionCallWithValue(
177                 target,
178                 data,
179                 value,
180                 "Address: low-level call with value failed"
181             );
182     }
183 
184     function functionCallWithValue(
185         address target,
186         bytes memory data,
187         uint256 value,
188         string memory errorMessage
189     ) internal returns (bytes memory) {
190         require(
191             address(this).balance >= value,
192             "Address: insufficient balance for call"
193         );
194         return _functionCallWithValue(target, data, value, errorMessage);
195     }
196 
197     function _functionCallWithValue(
198         address target,
199         bytes memory data,
200         uint256 weiValue,
201         string memory errorMessage
202     ) private returns (bytes memory) {
203         require(isContract(target), "Address: call to non-contract");
204 
205         (bool success, bytes memory returndata) = target.call{value: weiValue}(
206             data
207         );
208         if (success) {
209             return returndata;
210         } else {
211             if (returndata.length > 0) {
212                 assembly {
213                     let returndata_size := mload(returndata)
214                     revert(add(32, returndata), returndata_size)
215                 }
216             } else {
217                 revert(errorMessage);
218             }
219         }
220     }
221 }
222 
223 contract Ownable is Context {
224     address private _owner;
225     address private _previousOwner;
226     uint256 private _lockTime;
227 
228     event OwnershipTransferred(
229         address indexed previousOwner,
230         address indexed newOwner
231     );
232 
233     constructor() {
234         address msgSender = _msgSender();
235         _owner = msgSender;
236         emit OwnershipTransferred(address(0), msgSender);
237     }
238 
239     function owner() public view returns (address) {
240         return _owner;
241     }
242 
243     modifier onlyOwner() {
244         require(_owner == _msgSender(), "Ownable: caller is not the owner");
245         _;
246     }
247 
248     function renounceOwnership() public virtual onlyOwner {
249         emit OwnershipTransferred(_owner, address(0));
250         _owner = address(0);
251     }
252 
253     function transferOwnership(address newOwner) public virtual onlyOwner {
254         require(
255             newOwner != address(0),
256             "Ownable: new owner is the zero address"
257         );
258         emit OwnershipTransferred(_owner, newOwner);
259         _owner = newOwner;
260     }
261 
262     function getUnlockTime() public view returns (uint256) {
263         return _lockTime;
264     }
265 
266     function getTime() public view returns (uint256) {
267         return block.timestamp;
268     }
269 }
270 
271 
272 interface IUniswapV2Factory {
273     event PairCreated(
274         address indexed token0,
275         address indexed token1,
276         address pair,
277         uint256
278     );
279 
280     function feeTo() external view returns (address);
281 
282     function feeToSetter() external view returns (address);
283 
284     function getPair(address tokenA, address tokenB)
285         external
286         view
287         returns (address pair);
288 
289     function allPairs(uint256) external view returns (address pair);
290 
291     function allPairsLength() external view returns (uint256);
292 
293     function createPair(address tokenA, address tokenB)
294         external
295         returns (address pair);
296 
297     function setFeeTo(address) external;
298 
299     function setFeeToSetter(address) external;
300 }
301 
302 
303 interface IUniswapV2Pair {
304     event Approval(
305         address indexed owner,
306         address indexed spender,
307         uint256 value
308     );
309     event Transfer(address indexed from, address indexed to, uint256 value);
310 
311     function name() external pure returns (string memory);
312 
313     function symbol() external pure returns (string memory);
314 
315     function decimals() external pure returns (uint8);
316 
317     function totalSupply() external view returns (uint256);
318 
319     function balanceOf(address owner) external view returns (uint256);
320 
321     function allowance(address owner, address spender)
322         external
323         view
324         returns (uint256);
325 
326     function approve(address spender, uint256 value) external returns (bool);
327 
328     function transfer(address to, uint256 value) external returns (bool);
329 
330     function transferFrom(
331         address from,
332         address to,
333         uint256 value
334     ) external returns (bool);
335 
336     function DOMAIN_SEPARATOR() external view returns (bytes32);
337 
338     function PERMIT_TYPEHASH() external pure returns (bytes32);
339 
340     function nonces(address owner) external view returns (uint256);
341 
342     function permit(
343         address owner,
344         address spender,
345         uint256 value,
346         uint256 deadline,
347         uint8 v,
348         bytes32 r,
349         bytes32 s
350     ) external;
351 
352     event Burn(
353         address indexed sender,
354         uint256 amount0,
355         uint256 amount1,
356         address indexed to
357     );
358     event Swap(
359         address indexed sender,
360         uint256 amount0In,
361         uint256 amount1In,
362         uint256 amount0Out,
363         uint256 amount1Out,
364         address indexed to
365     );
366     event Sync(uint112 reserve0, uint112 reserve1);
367 
368     function MINIMUM_LIQUIDITY() external pure returns (uint256);
369 
370     function factory() external view returns (address);
371 
372     function token0() external view returns (address);
373 
374     function token1() external view returns (address);
375 
376     function getReserves()
377         external
378         view
379         returns (
380             uint112 reserve0,
381             uint112 reserve1,
382             uint32 blockTimestampLast
383         );
384 
385     function price0CumulativeLast() external view returns (uint256);
386 
387     function price1CumulativeLast() external view returns (uint256);
388 
389     function kLast() external view returns (uint256);
390 
391     function burn(address to)
392         external
393         returns (uint256 amount0, uint256 amount1);
394 
395     function swap(
396         uint256 amount0Out,
397         uint256 amount1Out,
398         address to,
399         bytes calldata data
400     ) external;
401 
402     function skim(address to) external;
403 
404     function sync() external;
405 
406     function initialize(address, address) external;
407 }
408 
409 interface IUniswapV2Router01 {
410     function factory() external pure returns (address);
411 
412     function WETH() external pure returns (address);
413 
414     function addLiquidity(
415         address tokenA,
416         address tokenB,
417         uint256 amountADesired,
418         uint256 amountBDesired,
419         uint256 amountAMin,
420         uint256 amountBMin,
421         address to,
422         uint256 deadline
423     )
424         external
425         returns (
426             uint256 amountA,
427             uint256 amountB,
428             uint256 liquidity
429         );
430 
431     function addLiquidityETH(
432         address token,
433         uint256 amountTokenDesired,
434         uint256 amountTokenMin,
435         uint256 amountETHMin,
436         address to,
437         uint256 deadline
438     )
439         external
440         payable
441         returns (
442             uint256 amountToken,
443             uint256 amountETH,
444             uint256 liquidity
445         );
446 
447     function removeLiquidity(
448         address tokenA,
449         address tokenB,
450         uint256 liquidity,
451         uint256 amountAMin,
452         uint256 amountBMin,
453         address to,
454         uint256 deadline
455     ) external returns (uint256 amountA, uint256 amountB);
456 
457     function removeLiquidityETH(
458         address token,
459         uint256 liquidity,
460         uint256 amountTokenMin,
461         uint256 amountETHMin,
462         address to,
463         uint256 deadline
464     ) external returns (uint256 amountToken, uint256 amountETH);
465 
466     function removeLiquidityWithPermit(
467         address tokenA,
468         address tokenB,
469         uint256 liquidity,
470         uint256 amountAMin,
471         uint256 amountBMin,
472         address to,
473         uint256 deadline,
474         bool approveMax,
475         uint8 v,
476         bytes32 r,
477         bytes32 s
478     ) external returns (uint256 amountA, uint256 amountB);
479 
480     function removeLiquidityETHWithPermit(
481         address token,
482         uint256 liquidity,
483         uint256 amountTokenMin,
484         uint256 amountETHMin,
485         address to,
486         uint256 deadline,
487         bool approveMax,
488         uint8 v,
489         bytes32 r,
490         bytes32 s
491     ) external returns (uint256 amountToken, uint256 amountETH);
492 
493     function swapExactTokensForTokens(
494         uint256 amountIn,
495         uint256 amountOutMin,
496         address[] calldata path,
497         address to,
498         uint256 deadline
499     ) external returns (uint256[] memory amounts);
500 
501     function swapTokensForExactTokens(
502         uint256 amountOut,
503         uint256 amountInMax,
504         address[] calldata path,
505         address to,
506         uint256 deadline
507     ) external returns (uint256[] memory amounts);
508 
509     function swapExactETHForTokens(
510         uint256 amountOutMin,
511         address[] calldata path,
512         address to,
513         uint256 deadline
514     ) external payable returns (uint256[] memory amounts);
515 
516     function swapTokensForExactETH(
517         uint256 amountOut,
518         uint256 amountInMax,
519         address[] calldata path,
520         address to,
521         uint256 deadline
522     ) external returns (uint256[] memory amounts);
523 
524     function swapExactTokensForETH(
525         uint256 amountIn,
526         uint256 amountOutMin,
527         address[] calldata path,
528         address to,
529         uint256 deadline
530     ) external returns (uint256[] memory amounts);
531 
532     function swapETHForExactTokens(
533         uint256 amountOut,
534         address[] calldata path,
535         address to,
536         uint256 deadline
537     ) external payable returns (uint256[] memory amounts);
538 
539     function quote(
540         uint256 amountA,
541         uint256 reserveA,
542         uint256 reserveB
543     ) external pure returns (uint256 amountB);
544 
545     function getAmountOut(
546         uint256 amountIn,
547         uint256 reserveIn,
548         uint256 reserveOut
549     ) external pure returns (uint256 amountOut);
550 
551     function getAmountIn(
552         uint256 amountOut,
553         uint256 reserveIn,
554         uint256 reserveOut
555     ) external pure returns (uint256 amountIn);
556 
557     function getAmountsOut(uint256 amountIn, address[] calldata path)
558         external
559         view
560         returns (uint256[] memory amounts);
561 
562     function getAmountsIn(uint256 amountOut, address[] calldata path)
563         external
564         view
565         returns (uint256[] memory amounts);
566 }
567 
568 interface IUniswapV2Router02 is IUniswapV2Router01 {
569     function removeLiquidityETHSupportingFeeOnTransferTokens(
570         address token,
571         uint256 liquidity,
572         uint256 amountTokenMin,
573         uint256 amountETHMin,
574         address to,
575         uint256 deadline
576     ) external returns (uint256 amountETH);
577 
578     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
579         address token,
580         uint256 liquidity,
581         uint256 amountTokenMin,
582         uint256 amountETHMin,
583         address to,
584         uint256 deadline,
585         bool approveMax,
586         uint8 v,
587         bytes32 r,
588         bytes32 s
589     ) external returns (uint256 amountETH);
590 
591     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
592         uint256 amountIn,
593         uint256 amountOutMin,
594         address[] calldata path,
595         address to,
596         uint256 deadline
597     ) external;
598 
599     function swapExactETHForTokensSupportingFeeOnTransferTokens(
600         uint256 amountOutMin,
601         address[] calldata path,
602         address to,
603         uint256 deadline
604     ) external payable;
605 
606     function swapExactTokensForETHSupportingFeeOnTransferTokens(
607         uint256 amountIn,
608         uint256 amountOutMin,
609         address[] calldata path,
610         address to,
611         uint256 deadline
612     ) external;
613 }
614 
615 contract GZLR is Context, IERC20, Ownable {
616     using SafeMath for uint256;
617     using Address for address;
618 
619     address payable public marketingAddress = payable(0x47dDf575789f6d2044401c949d2Ce9FC1C7233fF); // Marketing Address
620 
621     address payable public liquidityAddress =
622         payable(0x59B5eD384Cbfb691dEE3D20Bd38750b60eE814ea); // Liquidity Address
623 
624     mapping(address => uint256) private _rOwned;
625     mapping(address => uint256) private _tOwned;
626     mapping(address => mapping(address => uint256)) private _allowances;
627 
628     mapping(address => bool) private _isExcludedFromFee;
629 
630     mapping(address => bool) private _isExcluded;
631     address[] private _excluded;
632 
633     uint256 private constant MAX = ~uint256(0);
634     uint256 private constant _tTotal = 100 * 1e9 * 1e18;
635     uint256 private _rTotal = (MAX - (MAX % _tTotal));
636     uint256 private _tFeeTotal;
637 
638     string private constant _name = "Guzzler";
639     string private constant _symbol = "GZLR";
640     uint8 private constant _decimals = 18;
641 
642     uint256 private constant BUY = 1;
643     uint256 private constant SELL = 2;
644     uint256 private constant TRANSFER = 3;
645     uint256 private buyOrSellSwitch;
646 
647     // these values are pretty much arbitrary since they get overwritten for every txn, but the placeholders make it easier to work with current contract.
648     uint256 private _taxFee;
649     uint256 private _previousTaxFee = _taxFee;
650 
651     uint256 private _liquidityFee;
652     uint256 private _previousLiquidityFee = _liquidityFee;
653 
654     uint256 public _buyTaxFee = 6;
655     uint256 public _buyLiquidityFee = 3;
656     uint256 public _buyMarketingFee = 3;
657 
658     uint256 public _sellTaxFee = 6;
659     uint256 public _sellLiquidityFee = 3;
660     uint256 public _sellMarketingFee = 3;
661 
662     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
663     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
664 
665     bool public limitsInEffect = true;
666     bool public tradingActive = false;
667     bool public swapEnabled = false;
668 
669     mapping (address => bool) public _isExcludedMaxTransactionAmount;
670 
671      // Anti-bot and anti-whale mappings and variables
672     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
673     bool public transferDelayEnabled = true;
674 
675     uint256 private _liquidityTokensToSwap;
676     uint256 private _marketingTokensToSwap;
677 
678     bool private gasLimitActive = true;
679     uint256 private gasPriceLimit = 602 * 1 gwei;
680 
681     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
682     // could be subject to a maximum transfer amount
683     mapping (address => bool) public automatedMarketMakerPairs;
684 
685     uint256 public minimumTokensBeforeSwap;
686     uint256 public maxTransactionAmount;
687     uint256 public maxWallet;
688 
689     IUniswapV2Router02 public uniswapV2Router;
690     address public uniswapV2Pair;
691 
692     bool inSwapAndLiquify;
693     bool public swapAndLiquifyEnabled = false;
694 
695     event RewardLiquidityProviders(uint256 tokenAmount);
696     event SwapAndLiquifyEnabledUpdated(bool enabled);
697     event SwapAndLiquify(
698         uint256 tokensSwapped,
699         uint256 ethReceived,
700         uint256 tokensIntoLiqudity
701     );
702 
703     event SwapETHForTokens(uint256 amountIn, address[] path);
704 
705     event SwapTokensForETH(uint256 amountIn, address[] path);
706 
707     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
708 
709     modifier lockTheSwap() {
710         inSwapAndLiquify = true;
711         _;
712         inSwapAndLiquify = false;
713     }
714 
715     constructor() {
716         address newOwner = msg.sender; // update if auto-deploying to a different wallet
717         address futureOwner = address(msg.sender); // use if ownership will be transferred after deployment.
718 
719         maxTransactionAmount = _tTotal * 5 / 1000; // 0.5% max txn
720         minimumTokensBeforeSwap = _tTotal * 5 / 10000; // 0.05%
721         maxWallet = _tTotal * 1 / 100; // 1%
722 
723         _rOwned[newOwner] = _rTotal;
724 
725         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
726             // ROPSTEN or HARDHAT
727             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
728         );
729 
730         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
731             .createPair(address(this), _uniswapV2Router.WETH());
732 
733         uniswapV2Router = _uniswapV2Router;
734         uniswapV2Pair = _uniswapV2Pair;
735 
736         marketingAddress = payable(msg.sender); // update to marketing address
737         liquidityAddress = payable(address(0xdead)); // update to a liquidity wallet if you don't want to burn LP tokens generated by the contract.
738 
739         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
740 
741         _isExcludedFromFee[newOwner] = true;
742         _isExcludedFromFee[futureOwner] = true; // pre-exclude future owner wallet
743         _isExcludedFromFee[address(this)] = true;
744         _isExcludedFromFee[liquidityAddress] = true;
745 
746         excludeFromMaxTransaction(newOwner, true);
747         excludeFromMaxTransaction(futureOwner, true); // pre-exclude future owner wallet
748         excludeFromMaxTransaction(address(this), true);
749         excludeFromMaxTransaction(address(_uniswapV2Router), true);
750         excludeFromMaxTransaction(address(0xdead), true);
751 
752         emit Transfer(address(0), newOwner, _tTotal);
753     }
754 
755     function name() external pure returns (string memory) {
756         return _name;
757     }
758 
759     function symbol() external pure returns (string memory) {
760         return _symbol;
761     }
762 
763     function decimals() external pure returns (uint8) {
764         return _decimals;
765     }
766 
767     function totalSupply() external pure override returns (uint256) {
768         return _tTotal;
769     }
770 
771     function balanceOf(address account) public view override returns (uint256) {
772         if (_isExcluded[account]) return _tOwned[account];
773         return tokenFromReflection(_rOwned[account]);
774     }
775 
776     function transfer(address recipient, uint256 amount)
777         external
778         override
779         returns (bool)
780     {
781         _transfer(_msgSender(), recipient, amount);
782         return true;
783     }
784 
785     function allowance(address owner, address spender)
786         external
787         view
788         override
789         returns (uint256)
790     {
791         return _allowances[owner][spender];
792     }
793 
794     function approve(address spender, uint256 amount)
795         public
796         override
797         returns (bool)
798     {
799         _approve(_msgSender(), spender, amount);
800         return true;
801     }
802 
803     function transferFrom(
804         address sender,
805         address recipient,
806         uint256 amount
807     ) external override returns (bool) {
808         _transfer(sender, recipient, amount);
809         _approve(
810             sender,
811             _msgSender(),
812             _allowances[sender][_msgSender()].sub(
813                 amount,
814                 "ERC20: transfer amount exceeds allowance"
815             )
816         );
817         return true;
818     }
819 
820     function increaseAllowance(address spender, uint256 addedValue)
821         external
822         virtual
823         returns (bool)
824     {
825         _approve(
826             _msgSender(),
827             spender,
828             _allowances[_msgSender()][spender].add(addedValue)
829         );
830         return true;
831     }
832 
833     function decreaseAllowance(address spender, uint256 subtractedValue)
834         external
835         virtual
836         returns (bool)
837     {
838         _approve(
839             _msgSender(),
840             spender,
841             _allowances[_msgSender()][spender].sub(
842                 subtractedValue,
843                 "ERC20: decreased allowance below zero"
844             )
845         );
846         return true;
847     }
848 
849     function isExcludedFromReward(address account)
850         external
851         view
852         returns (bool)
853     {
854         return _isExcluded[account];
855     }
856 
857     function totalFees() external view returns (uint256) {
858         return _tFeeTotal;
859     }
860 
861     // once enabled, can never be turned off
862     function enableTrading() external onlyOwner {
863         tradingActive = true;
864         swapAndLiquifyEnabled = true;
865         tradingActiveBlock = block.number;
866     }
867 
868     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
869         return minimumTokensBeforeSwap;
870     }
871 
872     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
873         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
874 
875         _setAutomatedMarketMakerPair(pair, value);
876     }
877 
878     function _setAutomatedMarketMakerPair(address pair, bool value) private {
879         automatedMarketMakerPairs[pair] = value;
880 
881         excludeFromMaxTransaction(pair, value);
882         if(value){excludeFromReward(pair);}
883         if(!value){includeInReward(pair);}
884     }
885 
886     function setProtectionSettings(bool antiGas) external onlyOwner() {
887         gasLimitActive = antiGas;
888     }
889 
890     function setGasPriceLimit(uint256 gas) external onlyOwner {
891         require(gas >= 300);
892         gasPriceLimit = gas * 1 gwei;
893     }
894 
895     // disable Transfer delay
896     function disableTransferDelay() external onlyOwner returns (bool){
897         transferDelayEnabled = false;
898         return true;
899     }
900 
901     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
902         external
903         view
904         returns (uint256)
905     {
906         require(tAmount <= _tTotal, "Amount must be less than supply");
907         if (!deductTransferFee) {
908             (uint256 rAmount, , , , , ) = _getValues(tAmount);
909             return rAmount;
910         } else {
911             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
912             return rTransferAmount;
913         }
914     }
915 
916     // for one-time airdrop feature after contract launch
917     function airdropToWallets(address[] memory airdropWallets, uint256[] memory amount) external onlyOwner() {
918         require(airdropWallets.length == amount.length, "airdropToWallets:: Arrays must be the same length");
919         removeAllFee();
920         buyOrSellSwitch = TRANSFER;
921         for(uint256 i = 0; i < airdropWallets.length; i++){
922             address wallet = airdropWallets[i];
923             uint256 airdropAmount = amount[i];
924             _tokenTransfer(msg.sender, wallet, airdropAmount);
925         }
926         restoreAllFee();
927     }
928 
929     // remove limits after token is stable - 30-60 minutes
930     function removeLimits() external onlyOwner returns (bool){
931         limitsInEffect = false;
932         gasLimitActive = false;
933         transferDelayEnabled = false;
934         return true;
935     }
936 
937     function tokenFromReflection(uint256 rAmount)
938         public
939         view
940         returns (uint256)
941     {
942         require(
943             rAmount <= _rTotal,
944             "Amount must be less than total reflections"
945         );
946         uint256 currentRate = _getRate();
947         return rAmount.div(currentRate);
948     }
949 
950     function excludeFromReward(address account) public onlyOwner {
951         require(!_isExcluded[account], "Account is already excluded");
952         require(_excluded.length + 1 <= 50, "Cannot exclude more than 50 accounts.  Include a previously excluded address.");
953         if (_rOwned[account] > 0) {
954             _tOwned[account] = tokenFromReflection(_rOwned[account]);
955         }
956         _isExcluded[account] = true;
957         _excluded.push(account);
958     }
959 
960     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
961         _isExcludedMaxTransactionAmount[updAds] = isEx;
962         emit ExcludedMaxTransactionAmount(updAds, isEx);
963     }
964 
965     function includeInReward(address account) public onlyOwner {
966         require(_isExcluded[account], "Account is not excluded");
967         for (uint256 i = 0; i < _excluded.length; i++) {
968             if (_excluded[i] == account) {
969                 _excluded[i] = _excluded[_excluded.length - 1];
970                 _tOwned[account] = 0;
971                 _isExcluded[account] = false;
972                 _excluded.pop();
973                 break;
974             }
975         }
976     }
977 
978     function _approve(
979         address owner,
980         address spender,
981         uint256 amount
982     ) private {
983         require(owner != address(0), "ERC20: approve from the zero address");
984         require(spender != address(0), "ERC20: approve to the zero address");
985 
986         _allowances[owner][spender] = amount;
987         emit Approval(owner, spender, amount);
988     }
989 
990     function _transfer(
991         address from,
992         address to,
993         uint256 amount
994     ) private {
995         require(from != address(0), "ERC20: transfer from the zero address");
996         require(to != address(0), "ERC20: transfer to the zero address");
997         require(amount > 0, "Transfer amount must be greater than zero");
998 
999         if(!tradingActive){
1000             require(_isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading is not active yet.");
1001         }
1002 
1003         if(limitsInEffect){
1004             if (
1005                 from != owner() &&
1006                 to != owner() &&
1007                 to != address(0) &&
1008                 to != address(0xdead) &&
1009                 !inSwapAndLiquify
1010             ){
1011 
1012                 // only use to prevent sniper buys in the first blocks.
1013                 if (gasLimitActive && automatedMarketMakerPairs[from]) {
1014                     require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
1015                 }
1016 
1017                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1018                 if (transferDelayEnabled){
1019                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1020                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1021                         _holderLastTransferTimestamp[tx.origin] = block.number;
1022                     }
1023                 }
1024 
1025                 //when buy
1026                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1027                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1028                     require(amount + balanceOf(to) <= maxWallet, "Cannot exceed max wallet");
1029                 }
1030                 //when sell
1031                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1032                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1033                 }
1034                 else if (!_isExcludedMaxTransactionAmount[to]){
1035                     require(amount + balanceOf(to) <= maxWallet, "Cannot exceed max wallet");
1036                 }
1037             }
1038         }
1039 
1040         uint256 contractTokenBalance = balanceOf(address(this));
1041         bool overMinimumTokenBalance = contractTokenBalance >=
1042             minimumTokensBeforeSwap;
1043 
1044         // Sell tokens for ETH
1045         if (
1046             !inSwapAndLiquify &&
1047             swapAndLiquifyEnabled &&
1048             balanceOf(uniswapV2Pair) > 0 &&
1049             overMinimumTokenBalance &&
1050             automatedMarketMakerPairs[to]
1051         ) {
1052             swapBack();
1053         }
1054 
1055         removeAllFee();
1056 
1057         buyOrSellSwitch = TRANSFER;
1058 
1059         // If any account belongs to _isExcludedFromFee account then remove the fee
1060         if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
1061             // Buy
1062             if (automatedMarketMakerPairs[from]) {
1063                 _taxFee = _buyTaxFee;
1064                 _liquidityFee = _buyLiquidityFee + _buyMarketingFee;
1065                 if(_liquidityFee > 0){
1066                     buyOrSellSwitch = BUY;
1067                 }
1068             }
1069             // Sell
1070             else if (automatedMarketMakerPairs[to]) {
1071                 _taxFee = _sellTaxFee;
1072                 _liquidityFee = _sellLiquidityFee + _sellMarketingFee;
1073                 if(_liquidityFee > 0){
1074                     buyOrSellSwitch = SELL;
1075                 }
1076             }
1077         }
1078 
1079         _tokenTransfer(from, to, amount);
1080 
1081         restoreAllFee();
1082 
1083     }
1084 
1085     function swapBack() private lockTheSwap {
1086         uint256 contractBalance = balanceOf(address(this));
1087         bool success;
1088         uint256 totalTokensToSwap = _liquidityTokensToSwap + _marketingTokensToSwap;
1089         if(totalTokensToSwap == 0 || contractBalance == 0) {return;}
1090 
1091         // Halve the amount of liquidity tokens
1092         uint256 tokensForLiquidity = (contractBalance * _liquidityTokensToSwap / totalTokensToSwap) / 2;
1093         uint256 amountToSwapForBNB = contractBalance.sub(tokensForLiquidity);
1094 
1095         uint256 initialBNBBalance = address(this).balance;
1096 
1097         swapTokensForBNB(amountToSwapForBNB);
1098 
1099         uint256 bnbBalance = address(this).balance.sub(initialBNBBalance);
1100 
1101         uint256 bnbForMarketing = bnbBalance.mul(_marketingTokensToSwap).div(totalTokensToSwap);
1102 
1103         uint256 bnbForLiquidity = bnbBalance - bnbForMarketing;
1104 
1105         _liquidityTokensToSwap = 0;
1106         _marketingTokensToSwap = 0;
1107 
1108         if(tokensForLiquidity > 0 && bnbForLiquidity > 0){
1109             addLiquidity(tokensForLiquidity, bnbForLiquidity);
1110             emit SwapAndLiquify(amountToSwapForBNB, bnbForLiquidity, tokensForLiquidity);
1111         }
1112 
1113         (success,) = address(marketingAddress).call{value: address(this).balance}("");
1114 
1115     }
1116 
1117     function swapTokensForBNB(uint256 tokenAmount) private {
1118         address[] memory path = new address[](2);
1119         path[0] = address(this);
1120         path[1] = uniswapV2Router.WETH();
1121         _approve(address(this), address(uniswapV2Router), tokenAmount);
1122         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1123             tokenAmount,
1124             0, // accept any amount of ETH
1125             path,
1126             address(this),
1127             block.timestamp
1128         );
1129     }
1130 
1131     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1132         _approve(address(this), address(uniswapV2Router), tokenAmount);
1133         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1134             address(this),
1135             tokenAmount,
1136             0, // slippage is unavoidable
1137             0, // slippage is unavoidable
1138             liquidityAddress,
1139             block.timestamp
1140         );
1141     }
1142 
1143     function _tokenTransfer(
1144         address sender,
1145         address recipient,
1146         uint256 amount
1147     ) private {
1148 
1149         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1150             _transferFromExcluded(sender, recipient, amount);
1151         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1152             _transferToExcluded(sender, recipient, amount);
1153         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1154             _transferBothExcluded(sender, recipient, amount);
1155         } else {
1156             _transferStandard(sender, recipient, amount);
1157         }
1158     }
1159 
1160     function _transferStandard(
1161         address sender,
1162         address recipient,
1163         uint256 tAmount
1164     ) private {
1165         (
1166             uint256 rAmount,
1167             uint256 rTransferAmount,
1168             uint256 rFee,
1169             uint256 tTransferAmount,
1170             uint256 tFee,
1171             uint256 tLiquidity
1172         ) = _getValues(tAmount);
1173         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1174         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1175         _takeLiquidity(tLiquidity);
1176         _reflectFee(rFee, tFee);
1177         emit Transfer(sender, recipient, tTransferAmount);
1178     }
1179 
1180     function _transferToExcluded(
1181         address sender,
1182         address recipient,
1183         uint256 tAmount
1184     ) private {
1185         (
1186             uint256 rAmount,
1187             uint256 rTransferAmount,
1188             uint256 rFee,
1189             uint256 tTransferAmount,
1190             uint256 tFee,
1191             uint256 tLiquidity
1192         ) = _getValues(tAmount);
1193         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1194         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1195         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1196         _takeLiquidity(tLiquidity);
1197         _reflectFee(rFee, tFee);
1198         emit Transfer(sender, recipient, tTransferAmount);
1199     }
1200 
1201     function _transferFromExcluded(
1202         address sender,
1203         address recipient,
1204         uint256 tAmount
1205     ) private {
1206         (
1207             uint256 rAmount,
1208             uint256 rTransferAmount,
1209             uint256 rFee,
1210             uint256 tTransferAmount,
1211             uint256 tFee,
1212             uint256 tLiquidity
1213         ) = _getValues(tAmount);
1214         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1215         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1216         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1217         _takeLiquidity(tLiquidity);
1218         _reflectFee(rFee, tFee);
1219         emit Transfer(sender, recipient, tTransferAmount);
1220     }
1221 
1222     function _transferBothExcluded(
1223         address sender,
1224         address recipient,
1225         uint256 tAmount
1226     ) private {
1227         (
1228             uint256 rAmount,
1229             uint256 rTransferAmount,
1230             uint256 rFee,
1231             uint256 tTransferAmount,
1232             uint256 tFee,
1233             uint256 tLiquidity
1234         ) = _getValues(tAmount);
1235         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1236         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1237         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1238         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1239         _takeLiquidity(tLiquidity);
1240         _reflectFee(rFee, tFee);
1241         emit Transfer(sender, recipient, tTransferAmount);
1242     }
1243 
1244     function _reflectFee(uint256 rFee, uint256 tFee) private {
1245         _rTotal = _rTotal.sub(rFee);
1246         _tFeeTotal = _tFeeTotal.add(tFee);
1247     }
1248 
1249     function _getValues(uint256 tAmount)
1250         private
1251         view
1252         returns (
1253             uint256,
1254             uint256,
1255             uint256,
1256             uint256,
1257             uint256,
1258             uint256
1259         )
1260     {
1261         (
1262             uint256 tTransferAmount,
1263             uint256 tFee,
1264             uint256 tLiquidity
1265         ) = _getTValues(tAmount);
1266         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1267             tAmount,
1268             tFee,
1269             tLiquidity,
1270             _getRate()
1271         );
1272         return (
1273             rAmount,
1274             rTransferAmount,
1275             rFee,
1276             tTransferAmount,
1277             tFee,
1278             tLiquidity
1279         );
1280     }
1281 
1282     function _getTValues(uint256 tAmount)
1283         private
1284         view
1285         returns (
1286             uint256,
1287             uint256,
1288             uint256
1289         )
1290     {
1291         uint256 tFee = calculateTaxFee(tAmount);
1292         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1293         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1294         return (tTransferAmount, tFee, tLiquidity);
1295     }
1296 
1297     function _getRValues(
1298         uint256 tAmount,
1299         uint256 tFee,
1300         uint256 tLiquidity,
1301         uint256 currentRate
1302     )
1303         private
1304         pure
1305         returns (
1306             uint256,
1307             uint256,
1308             uint256
1309         )
1310     {
1311         uint256 rAmount = tAmount.mul(currentRate);
1312         uint256 rFee = tFee.mul(currentRate);
1313         uint256 rLiquidity = tLiquidity.mul(currentRate);
1314         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1315         return (rAmount, rTransferAmount, rFee);
1316     }
1317 
1318     function _getRate() private view returns (uint256) {
1319         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1320         return rSupply.div(tSupply);
1321     }
1322 
1323     function _getCurrentSupply() private view returns (uint256, uint256) {
1324         uint256 rSupply = _rTotal;
1325         uint256 tSupply = _tTotal;
1326         for (uint256 i = 0; i < _excluded.length; i++) {
1327             if (
1328                 _rOwned[_excluded[i]] > rSupply ||
1329                 _tOwned[_excluded[i]] > tSupply
1330             ) return (_rTotal, _tTotal);
1331             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1332             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1333         }
1334         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1335         return (rSupply, tSupply);
1336     }
1337 
1338     function _takeLiquidity(uint256 tLiquidity) private {
1339         if(buyOrSellSwitch == BUY){
1340             _liquidityTokensToSwap += tLiquidity * _buyLiquidityFee / _liquidityFee;
1341             _marketingTokensToSwap += tLiquidity * _buyMarketingFee / _liquidityFee;
1342         } else if(buyOrSellSwitch == SELL){
1343             _liquidityTokensToSwap += tLiquidity * _sellLiquidityFee / _liquidityFee;
1344             _marketingTokensToSwap += tLiquidity * _sellMarketingFee / _liquidityFee;
1345         }
1346         uint256 currentRate = _getRate();
1347         uint256 rLiquidity = tLiquidity.mul(currentRate);
1348         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1349         if (_isExcluded[address(this)])
1350             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1351     }
1352 
1353     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1354         return _amount.mul(_taxFee).div(10**2);
1355     }
1356 
1357     function calculateLiquidityFee(uint256 _amount)
1358         private
1359         view
1360         returns (uint256)
1361     {
1362         return _amount.mul(_liquidityFee).div(10**2);
1363     }
1364 
1365     function removeAllFee() private {
1366         if (_taxFee == 0 && _liquidityFee == 0) return;
1367 
1368         _previousTaxFee = _taxFee;
1369         _previousLiquidityFee = _liquidityFee;
1370 
1371         _taxFee = 0;
1372         _liquidityFee = 0;
1373     }
1374 
1375     function restoreAllFee() private {
1376         _taxFee = _previousTaxFee;
1377         _liquidityFee = _previousLiquidityFee;
1378     }
1379 
1380     function isExcludedFromFee(address account) external view returns (bool) {
1381         return _isExcludedFromFee[account];
1382     }
1383 
1384     function excludeFromFee(address account) external onlyOwner {
1385         _isExcludedFromFee[account] = true;
1386     }
1387 
1388     function includeInFee(address account) external onlyOwner {
1389         _isExcludedFromFee[account] = false;
1390     }
1391 
1392     function setBuyFee(uint256 buyTaxFee, uint256 buyLiquidityFee, uint256 buyMarketingFee)
1393         external
1394         onlyOwner
1395     {
1396         _buyTaxFee = buyTaxFee;
1397         _buyLiquidityFee = buyLiquidityFee;
1398         _buyMarketingFee = buyMarketingFee;
1399         require(_buyTaxFee + _buyLiquidityFee + _buyMarketingFee <= 20, "Must keep taxes below 20%");
1400     }
1401 
1402     function setSellFee(uint256 sellTaxFee, uint256 sellLiquidityFee, uint256 sellMarketingFee)
1403         external
1404         onlyOwner
1405     {
1406         _sellTaxFee = sellTaxFee;
1407         _sellLiquidityFee = sellLiquidityFee;
1408         _sellMarketingFee = sellMarketingFee;
1409         require(_sellTaxFee + _sellLiquidityFee + _sellMarketingFee <= 30, "Must keep taxes below 30%");
1410     }
1411 
1412     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1413         marketingAddress = payable(_marketingAddress);
1414         _isExcludedFromFee[marketingAddress] = true;
1415     }
1416 
1417     function setLiquidityAddress(address _liquidityAddress) external onlyOwner {
1418         liquidityAddress = payable(_liquidityAddress);
1419         _isExcludedFromFee[liquidityAddress] = true;
1420     }
1421 
1422     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1423         swapAndLiquifyEnabled = _enabled;
1424         emit SwapAndLiquifyEnabledUpdated(_enabled);
1425     }
1426 
1427     // useful for buybacks or to reclaim any BNB on the contract in a way that helps holders.
1428     function buyBackTokens(uint256 bnbAmountInWei) external onlyOwner {
1429         // generate the uniswap pair path of weth -> eth
1430         address[] memory path = new address[](2);
1431         path[0] = uniswapV2Router.WETH();
1432         path[1] = address(this);
1433 
1434         // make the swap
1435         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmountInWei}(
1436             0, // accept any amount of Ethereum
1437             path,
1438             address(0xdead),
1439             block.timestamp
1440         );
1441     }
1442 
1443     // To receive ETH from uniswapV2Router when swapping
1444     receive() external payable {}
1445 
1446     function transferForeignToken(address _token, address _to)
1447         external
1448         onlyOwner
1449         returns (bool _sent)
1450     {
1451         require(_token != address(this), "Can't withdraw native tokens");
1452         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1453         _sent = IERC20(_token).transfer(_to, _contractBalance);
1454     }
1455 }