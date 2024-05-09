1 /* 
2     Berserk Inu - BERSERK
3     
4     Website : https://berserkinu.com
5     Telegram: https://t.me/berserkinu
6     Twitter: https://twitter.com/BerserkInu
7     
8     1 Quadrillion supply
9     2% Dev tax
10     5% marketing
11     1% liquidity
12     2% Reflection to Holders
13     
14 */
15 
16 // SPDX-License-Identifier: MIT
17 
18 pragma solidity ^0.8.9;
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address payable) {
22         return payable(msg.sender);
23     }
24 
25     function _msgData() internal view virtual returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 interface IERC20 {
32     function totalSupply() external view returns (uint256);
33 
34     function balanceOf(address account) external view returns (uint256);
35 
36     function transfer(address recipient, uint256 amount)
37         external
38         returns (bool);
39 
40     function allowance(address owner, address spender)
41         external
42         view
43         returns (uint256);
44 
45     function approve(address spender, uint256 amount) external returns (bool);
46 
47     function transferFrom(
48         address sender,
49         address recipient,
50         uint256 amount
51     ) external returns (bool);
52 
53     event Transfer(address indexed from, address indexed to, uint256 value);
54     event Approval(
55         address indexed owner,
56         address indexed spender,
57         uint256 value
58     );
59 }
60 
61 library SafeMath {
62     function add(uint256 a, uint256 b) internal pure returns (uint256) {
63         uint256 c = a + b;
64         require(c >= a, "SafeMath: addition overflow");
65 
66         return c;
67     }
68 
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         return sub(a, b, "SafeMath: subtraction overflow");
71     }
72 
73     function sub(
74         uint256 a,
75         uint256 b,
76         string memory errorMessage
77     ) internal pure returns (uint256) {
78         require(b <= a, errorMessage);
79         uint256 c = a - b;
80 
81         return c;
82     }
83 
84     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85         if (a == 0) {
86             return 0;
87         }
88 
89         uint256 c = a * b;
90         require(c / a == b, "SafeMath: multiplication overflow");
91 
92         return c;
93     }
94 
95     function div(uint256 a, uint256 b) internal pure returns (uint256) {
96         return div(a, b, "SafeMath: division by zero");
97     }
98 
99     function div(
100         uint256 a,
101         uint256 b,
102         string memory errorMessage
103     ) internal pure returns (uint256) {
104         require(b > 0, errorMessage);
105         uint256 c = a / b;
106         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107 
108         return c;
109     }
110 
111     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
112         return mod(a, b, "SafeMath: modulo by zero");
113     }
114 
115     function mod(
116         uint256 a,
117         uint256 b,
118         string memory errorMessage
119     ) internal pure returns (uint256) {
120         require(b != 0, errorMessage);
121         return a % b;
122     }
123 }
124 
125 library Address {
126     function isContract(address account) internal view returns (bool) {
127         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
128         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
129         // for accounts without code, i.e. `keccak256('')`
130         bytes32 codehash;
131         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
132         // solhint-disable-next-line no-inline-assembly
133         assembly {
134             codehash := extcodehash(account)
135         }
136         return (codehash != accountHash && codehash != 0x0);
137     }
138 
139     function sendValue(address payable recipient, uint256 amount) internal {
140         require(
141             address(this).balance >= amount,
142             "Address: insufficient balance"
143         );
144 
145         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
146         (bool success, ) = recipient.call{value: amount}("");
147         require(
148             success,
149             "Address: unable to send value, recipient may have reverted"
150         );
151     }
152 
153     function functionCall(address target, bytes memory data)
154         internal
155         returns (bytes memory)
156     {
157         return functionCall(target, data, "Address: low-level call failed");
158     }
159 
160     function functionCall(
161         address target,
162         bytes memory data,
163         string memory errorMessage
164     ) internal returns (bytes memory) {
165         return _functionCallWithValue(target, data, 0, errorMessage);
166     }
167 
168     function functionCallWithValue(
169         address target,
170         bytes memory data,
171         uint256 value
172     ) internal returns (bytes memory) {
173         return
174             functionCallWithValue(
175                 target,
176                 data,
177                 value,
178                 "Address: low-level call with value failed"
179             );
180     }
181 
182     function functionCallWithValue(
183         address target,
184         bytes memory data,
185         uint256 value,
186         string memory errorMessage
187     ) internal returns (bytes memory) {
188         require(
189             address(this).balance >= value,
190             "Address: insufficient balance for call"
191         );
192         return _functionCallWithValue(target, data, value, errorMessage);
193     }
194 
195     function _functionCallWithValue(
196         address target,
197         bytes memory data,
198         uint256 weiValue,
199         string memory errorMessage
200     ) private returns (bytes memory) {
201         require(isContract(target), "Address: call to non-contract");
202 
203         (bool success, bytes memory returndata) = target.call{value: weiValue}(
204             data
205         );
206         if (success) {
207             return returndata;
208         } else {
209             if (returndata.length > 0) {
210                 assembly {
211                     let returndata_size := mload(returndata)
212                     revert(add(32, returndata), returndata_size)
213                 }
214             } else {
215                 revert(errorMessage);
216             }
217         }
218     }
219 }
220 
221 contract Ownable is Context {
222     address private _owner;
223     address private _previousOwner;
224     uint256 private _lockTime;
225 
226     event OwnershipTransferred(
227         address indexed previousOwner,
228         address indexed newOwner
229     );
230 
231     constructor() {
232         address msgSender = _msgSender();
233         _owner = msgSender;
234         emit OwnershipTransferred(address(0), msgSender);
235     }
236 
237     function owner() public view returns (address) {
238         return _owner;
239     }
240 
241     modifier onlyOwner() {
242         require(_owner == _msgSender(), "Ownable: caller is not the owner");
243         _;
244     }
245 
246     function renounceOwnership() public virtual onlyOwner {
247         emit OwnershipTransferred(_owner, address(0));
248         _owner = address(0);
249     }
250 
251     function transferOwnership(address newOwner) public virtual onlyOwner {
252         require(
253             newOwner != address(0),
254             "Ownable: new owner is the zero address"
255         );
256         emit OwnershipTransferred(_owner, newOwner);
257         _owner = newOwner;
258     }
259 
260     function getUnlockTime() public view returns (uint256) {
261         return _lockTime;
262     }
263 
264     function getTime() public view returns (uint256) {
265         return block.timestamp;
266     }
267 }
268 
269 
270 interface IUniswapV2Factory {
271     event PairCreated(
272         address indexed token0,
273         address indexed token1,
274         address pair,
275         uint256
276     );
277 
278     function feeTo() external view returns (address);
279 
280     function feeToSetter() external view returns (address);
281 
282     function getPair(address tokenA, address tokenB)
283         external
284         view
285         returns (address pair);
286 
287     function allPairs(uint256) external view returns (address pair);
288 
289     function allPairsLength() external view returns (uint256);
290 
291     function createPair(address tokenA, address tokenB)
292         external
293         returns (address pair);
294 
295     function setFeeTo(address) external;
296 
297     function setFeeToSetter(address) external;
298 }
299 
300 
301 interface IUniswapV2Pair {
302     event Approval(
303         address indexed owner,
304         address indexed spender,
305         uint256 value
306     );
307     event Transfer(address indexed from, address indexed to, uint256 value);
308 
309     function name() external pure returns (string memory);
310 
311     function symbol() external pure returns (string memory);
312 
313     function decimals() external pure returns (uint8);
314 
315     function totalSupply() external view returns (uint256);
316 
317     function balanceOf(address owner) external view returns (uint256);
318 
319     function allowance(address owner, address spender)
320         external
321         view
322         returns (uint256);
323 
324     function approve(address spender, uint256 value) external returns (bool);
325 
326     function transfer(address to, uint256 value) external returns (bool);
327 
328     function transferFrom(
329         address from,
330         address to,
331         uint256 value
332     ) external returns (bool);
333 
334     function DOMAIN_SEPARATOR() external view returns (bytes32);
335 
336     function PERMIT_TYPEHASH() external pure returns (bytes32);
337 
338     function nonces(address owner) external view returns (uint256);
339 
340     function permit(
341         address owner,
342         address spender,
343         uint256 value,
344         uint256 deadline,
345         uint8 v,
346         bytes32 r,
347         bytes32 s
348     ) external;
349 
350     event Burn(
351         address indexed sender,
352         uint256 amount0,
353         uint256 amount1,
354         address indexed to
355     );
356     event Swap(
357         address indexed sender,
358         uint256 amount0In,
359         uint256 amount1In,
360         uint256 amount0Out,
361         uint256 amount1Out,
362         address indexed to
363     );
364     event Sync(uint112 reserve0, uint112 reserve1);
365 
366     function MINIMUM_LIQUIDITY() external pure returns (uint256);
367 
368     function factory() external view returns (address);
369 
370     function token0() external view returns (address);
371 
372     function token1() external view returns (address);
373 
374     function getReserves()
375         external
376         view
377         returns (
378             uint112 reserve0,
379             uint112 reserve1,
380             uint32 blockTimestampLast
381         );
382 
383     function price0CumulativeLast() external view returns (uint256);
384 
385     function price1CumulativeLast() external view returns (uint256);
386 
387     function kLast() external view returns (uint256);
388 
389     function burn(address to)
390         external
391         returns (uint256 amount0, uint256 amount1);
392 
393     function swap(
394         uint256 amount0Out,
395         uint256 amount1Out,
396         address to,
397         bytes calldata data
398     ) external;
399 
400     function skim(address to) external;
401 
402     function sync() external;
403 
404     function initialize(address, address) external;
405 }
406 
407 interface IUniswapV2Router01 {
408     function factory() external pure returns (address);
409 
410     function WETH() external pure returns (address);
411 
412     function addLiquidity(
413         address tokenA,
414         address tokenB,
415         uint256 amountADesired,
416         uint256 amountBDesired,
417         uint256 amountAMin,
418         uint256 amountBMin,
419         address to,
420         uint256 deadline
421     )
422         external
423         returns (
424             uint256 amountA,
425             uint256 amountB,
426             uint256 liquidity
427         );
428 
429     function addLiquidityETH(
430         address token,
431         uint256 amountTokenDesired,
432         uint256 amountTokenMin,
433         uint256 amountETHMin,
434         address to,
435         uint256 deadline
436     )
437         external
438         payable
439         returns (
440             uint256 amountToken,
441             uint256 amountETH,
442             uint256 liquidity
443         );
444 
445     function removeLiquidity(
446         address tokenA,
447         address tokenB,
448         uint256 liquidity,
449         uint256 amountAMin,
450         uint256 amountBMin,
451         address to,
452         uint256 deadline
453     ) external returns (uint256 amountA, uint256 amountB);
454 
455     function removeLiquidityETH(
456         address token,
457         uint256 liquidity,
458         uint256 amountTokenMin,
459         uint256 amountETHMin,
460         address to,
461         uint256 deadline
462     ) external returns (uint256 amountToken, uint256 amountETH);
463 
464     function removeLiquidityWithPermit(
465         address tokenA,
466         address tokenB,
467         uint256 liquidity,
468         uint256 amountAMin,
469         uint256 amountBMin,
470         address to,
471         uint256 deadline,
472         bool approveMax,
473         uint8 v,
474         bytes32 r,
475         bytes32 s
476     ) external returns (uint256 amountA, uint256 amountB);
477 
478     function removeLiquidityETHWithPermit(
479         address token,
480         uint256 liquidity,
481         uint256 amountTokenMin,
482         uint256 amountETHMin,
483         address to,
484         uint256 deadline,
485         bool approveMax,
486         uint8 v,
487         bytes32 r,
488         bytes32 s
489     ) external returns (uint256 amountToken, uint256 amountETH);
490 
491     function swapExactTokensForTokens(
492         uint256 amountIn,
493         uint256 amountOutMin,
494         address[] calldata path,
495         address to,
496         uint256 deadline
497     ) external returns (uint256[] memory amounts);
498 
499     function swapTokensForExactTokens(
500         uint256 amountOut,
501         uint256 amountInMax,
502         address[] calldata path,
503         address to,
504         uint256 deadline
505     ) external returns (uint256[] memory amounts);
506 
507     function swapExactETHForTokens(
508         uint256 amountOutMin,
509         address[] calldata path,
510         address to,
511         uint256 deadline
512     ) external payable returns (uint256[] memory amounts);
513 
514     function swapTokensForExactETH(
515         uint256 amountOut,
516         uint256 amountInMax,
517         address[] calldata path,
518         address to,
519         uint256 deadline
520     ) external returns (uint256[] memory amounts);
521 
522     function swapExactTokensForETH(
523         uint256 amountIn,
524         uint256 amountOutMin,
525         address[] calldata path,
526         address to,
527         uint256 deadline
528     ) external returns (uint256[] memory amounts);
529 
530     function swapETHForExactTokens(
531         uint256 amountOut,
532         address[] calldata path,
533         address to,
534         uint256 deadline
535     ) external payable returns (uint256[] memory amounts);
536 
537     function quote(
538         uint256 amountA,
539         uint256 reserveA,
540         uint256 reserveB
541     ) external pure returns (uint256 amountB);
542 
543     function getAmountOut(
544         uint256 amountIn,
545         uint256 reserveIn,
546         uint256 reserveOut
547     ) external pure returns (uint256 amountOut);
548 
549     function getAmountIn(
550         uint256 amountOut,
551         uint256 reserveIn,
552         uint256 reserveOut
553     ) external pure returns (uint256 amountIn);
554 
555     function getAmountsOut(uint256 amountIn, address[] calldata path)
556         external
557         view
558         returns (uint256[] memory amounts);
559 
560     function getAmountsIn(uint256 amountOut, address[] calldata path)
561         external
562         view
563         returns (uint256[] memory amounts);
564 }
565 
566 interface IUniswapV2Router02 is IUniswapV2Router01 {
567     function removeLiquidityETHSupportingFeeOnTransferTokens(
568         address token,
569         uint256 liquidity,
570         uint256 amountTokenMin,
571         uint256 amountETHMin,
572         address to,
573         uint256 deadline
574     ) external returns (uint256 amountETH);
575 
576     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
577         address token,
578         uint256 liquidity,
579         uint256 amountTokenMin,
580         uint256 amountETHMin,
581         address to,
582         uint256 deadline,
583         bool approveMax,
584         uint8 v,
585         bytes32 r,
586         bytes32 s
587     ) external returns (uint256 amountETH);
588 
589     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
590         uint256 amountIn,
591         uint256 amountOutMin,
592         address[] calldata path,
593         address to,
594         uint256 deadline
595     ) external;
596 
597     function swapExactETHForTokensSupportingFeeOnTransferTokens(
598         uint256 amountOutMin,
599         address[] calldata path,
600         address to,
601         uint256 deadline
602     ) external payable;
603 
604     function swapExactTokensForETHSupportingFeeOnTransferTokens(
605         uint256 amountIn,
606         uint256 amountOutMin,
607         address[] calldata path,
608         address to,
609         uint256 deadline
610     ) external;
611 }
612 
613 contract BerserkInu is Context, IERC20, Ownable {
614     using SafeMath for uint256;
615     using Address for address;
616 
617     address payable public marketingAddress;
618         
619     address payable public devAddress;
620         
621     address payable public liquidityAddress;
622         
623     mapping(address => uint256) private _rOwned;
624     mapping(address => uint256) private _tOwned;
625     mapping(address => mapping(address => uint256)) private _allowances;
626     
627     // Anti-bot and anti-whale mappings and variables
628     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
629     bool public transferDelayEnabled = true;
630     bool public limitsInEffect = true;
631 
632     mapping(address => bool) private _isExcludedFromFee;
633 
634     mapping(address => bool) private _isExcluded;
635     address[] private _excluded;
636     
637     uint256 private constant MAX = ~uint256(0);
638     uint256 private constant _tTotal = 1 * 1e15 * 1e9;
639     uint256 private _rTotal = (MAX - (MAX % _tTotal));
640     uint256 private _tFeeTotal;
641 
642     string private constant _name = "Berserk-Inu";
643     string private constant _symbol = "BERSERK";
644     uint8 private constant _decimals = 9;
645 
646     // these values are pretty much arbitrary since they get overwritten for every txn, but the placeholders make it easier to work with current contract.
647     uint256 private _taxFee;
648     uint256 private _previousTaxFee = _taxFee;
649 
650     uint256 private _marketingFee;
651     
652     uint256 private _liquidityFee;
653     uint256 private _previousLiquidityFee = _liquidityFee;
654     
655     uint256 private constant BUY = 1;
656     uint256 private constant SELL = 2;
657     uint256 private constant TRANSFER = 3;
658     uint256 private buyOrSellSwitch;
659 
660     uint256 public _buyTaxFee = 2;
661     uint256 public _buyLiquidityFee = 1;
662     uint256 public _buyMarketingFee = 7;
663 
664     uint256 public _sellTaxFee = 2;
665     uint256 public _sellLiquidityFee = 1;
666     uint256 public _sellMarketingFee = 7;
667     
668     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
669     mapping(address => bool) public boughtEarly; // mapping to track addresses that buy within the first 2 blocks pay a 3x tax for 24 hours to sell
670     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
671     
672     uint256 public _liquidityTokensToSwap;
673     uint256 public _marketingTokensToSwap;
674     
675     uint256 public maxTransactionAmount;
676     mapping (address => bool) public _isExcludedMaxTransactionAmount;
677     
678     bool private gasLimitActive = true;
679     uint256 private gasPriceLimit = 500 * 1 gwei; // do not allow over 500 gwei for launch
680     
681     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
682     // could be subject to a maximum transfer amount
683     mapping (address => bool) public automatedMarketMakerPairs;
684 
685     uint256 private minimumTokensBeforeSwap;
686 
687     IUniswapV2Router02 public uniswapV2Router;
688     address public uniswapV2Pair;
689 
690     bool inSwapAndLiquify;
691     bool public swapAndLiquifyEnabled = false;
692     bool public tradingActive = false;
693 
694     event SwapAndLiquifyEnabledUpdated(bool enabled);
695     event SwapAndLiquify(
696         uint256 tokensSwapped,
697         uint256 ethReceived,
698         uint256 tokensIntoLiquidity
699     );
700 
701     event SwapETHForTokens(uint256 amountIn, address[] path);
702 
703     event SwapTokensForETH(uint256 amountIn, address[] path);
704     
705     event SetAutomatedMarketMakerPair(address pair, bool value);
706     
707     event ExcludeFromReward(address excludedAddress);
708     
709     event IncludeInReward(address includedAddress);
710     
711     event ExcludeFromFee(address excludedAddress);
712     
713     event IncludeInFee(address includedAddress);
714     
715     event SetBuyFee(uint256 marketingFee, uint256 liquidityFee, uint256 reflectFee);
716     
717     event SetSellFee(uint256 marketingFee, uint256 liquidityFee, uint256 reflectFee);
718     
719     event TransferForeignToken(address token, uint256 amount);
720     
721     event UpdatedMarketingAddress(address marketing);
722     
723     event UpdatedLiquidityAddress(address liquidity);
724     
725     event OwnerForcedSwapBack(uint256 timestamp);
726     
727     event BoughtEarly(address indexed sniper);
728     
729     event RemovedSniper(address indexed notsnipersupposedly);
730 
731     modifier lockTheSwap() {
732         inSwapAndLiquify = true;
733         _;
734         inSwapAndLiquify = false;
735     }
736 
737     constructor() payable {
738         _rOwned[_msgSender()] = _rTotal / 1000 * 205;
739         _rOwned[address(this)] = _rTotal / 1000 * 795;
740         
741         maxTransactionAmount = _tTotal * 5 / 1000; // 0.5% maxTransactionAmountTxn
742         minimumTokensBeforeSwap = _tTotal * 5 / 10000; // 0.05% swap tokens amount
743         
744         marketingAddress = payable(0xBc64A198bf8607523d1BDB657311B229A0179C18); // Marketing Address
745         
746         devAddress = payable(0x0dd51A13c655FF1af23217929162026F95B47Cf2); // Dev Address
747         
748         liquidityAddress = payable(owner()); // Liquidity Address (switches to dead address once launch happens)
749         
750         _isExcludedFromFee[owner()] = true;
751         _isExcludedFromFee[address(this)] = true;
752         _isExcludedFromFee[marketingAddress] = true;
753         _isExcludedFromFee[liquidityAddress] = true;
754         
755         excludeFromMaxTransaction(owner(), true);
756         excludeFromMaxTransaction(address(this), true);
757         excludeFromMaxTransaction(address(0xdead), true);
758         
759         emit Transfer(address(0), _msgSender(), _tTotal * 205 / 1000);
760         emit Transfer(address(0), address(this), _tTotal * 795 / 1000);
761     }
762 
763     function name() external pure returns (string memory) {
764         return _name;
765     }
766 
767     function symbol() external pure returns (string memory) {
768         return _symbol;
769     }
770 
771     function decimals() external pure returns (uint8) {
772         return _decimals;
773     }
774 
775     function totalSupply() external pure override returns (uint256) {
776         return _tTotal;
777     }
778 
779     function balanceOf(address account) public view override returns (uint256) {
780         if (_isExcluded[account]) return _tOwned[account];
781         return tokenFromReflection(_rOwned[account]);
782     }
783 
784     function transfer(address recipient, uint256 amount)
785         external
786         override
787         returns (bool)
788     {
789         _transfer(_msgSender(), recipient, amount);
790         return true;
791     }
792 
793     function allowance(address owner, address spender)
794         external
795         view
796         override
797         returns (uint256)
798     {
799         return _allowances[owner][spender];
800     }
801 
802     function approve(address spender, uint256 amount)
803         public
804         override
805         returns (bool)
806     {
807         _approve(_msgSender(), spender, amount);
808         return true;
809     }
810 
811     function transferFrom(
812         address sender,
813         address recipient,
814         uint256 amount
815     ) external override returns (bool) {
816         _transfer(sender, recipient, amount);
817         _approve(
818             sender,
819             _msgSender(),
820             _allowances[sender][_msgSender()].sub(
821                 amount,
822                 "ERC20: transfer amount exceeds allowance"
823             )
824         );
825         return true;
826     }
827 
828     function increaseAllowance(address spender, uint256 addedValue)
829         external
830         virtual
831         returns (bool)
832     {
833         _approve(
834             _msgSender(),
835             spender,
836             _allowances[_msgSender()][spender].add(addedValue)
837         );
838         return true;
839     }
840 
841     function decreaseAllowance(address spender, uint256 subtractedValue)
842         external
843         virtual
844         returns (bool)
845     {
846         _approve(
847             _msgSender(),
848             spender,
849             _allowances[_msgSender()][spender].sub(
850                 subtractedValue,
851                 "ERC20: decreased allowance below zero"
852             )
853         );
854         return true;
855     }
856 
857     function isExcludedFromReward(address account)
858         external
859         view
860         returns (bool)
861     {
862         return _isExcluded[account];
863     }
864 
865     function totalFees() external view returns (uint256) {
866         return _tFeeTotal;
867     }
868     
869     // remove limits after token is stable - 30-60 minutes
870     function removeLimits() external onlyOwner returns (bool){
871         limitsInEffect = false;
872         gasLimitActive = false;
873         transferDelayEnabled = false;
874         return true;
875     }
876     
877     // disable Transfer delay
878     function disableTransferDelay() external onlyOwner returns (bool){
879         transferDelayEnabled = false;
880         return true;
881     }
882     
883     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
884         _isExcludedMaxTransactionAmount[updAds] = isEx;
885     }
886     
887     // once enabled, can never be turned off
888     function enableTrading() internal onlyOwner {
889         tradingActive = true;
890         swapAndLiquifyEnabled = true;
891         tradingActiveBlock = block.number;
892         earlyBuyPenaltyEnd = block.timestamp + 72 hours;
893     }
894     
895     // send tokens and ETH for liquidity to contract directly, then call this (not required, can still use Uniswap to add liquidity manually, but this ensures everything is excluded properly and makes for a great stealth launch)
896     function launch(address[] memory airdropWallets, uint256[] memory amounts) external onlyOwner returns (bool){
897         require(!tradingActive, "Trading is already active, cannot relaunch.");
898         require(airdropWallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
899         for(uint256 i = 0; i < airdropWallets.length; i++){
900             address wallet = airdropWallets[i];
901             uint256 amount = amounts[i];
902             _transfer(msg.sender, wallet, amount);
903         }
904         enableTrading();
905         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
906         excludeFromMaxTransaction(address(_uniswapV2Router), true);
907         uniswapV2Router = _uniswapV2Router;
908         _approve(address(this), address(uniswapV2Router), _tTotal);
909         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
910         excludeFromMaxTransaction(address(uniswapV2Pair), true);
911         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
912         require(address(this).balance > 0, "Must have ETH on contract to launch");
913         addLiquidity(balanceOf(address(this)), address(this).balance);
914         setLiquidityAddress(address(0xdead));
915         return true;
916     }
917     
918     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
919         return minimumTokensBeforeSwap;
920     }
921     
922     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
923         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
924 
925         _setAutomatedMarketMakerPair(pair, value);
926     }
927 
928     function _setAutomatedMarketMakerPair(address pair, bool value) private {
929         automatedMarketMakerPairs[pair] = value;
930         _isExcludedMaxTransactionAmount[pair] = value;
931         if(value){excludeFromReward(pair);}
932         if(!value){includeInReward(pair);}
933     }
934     
935     function setGasPriceLimit(uint256 gas) external onlyOwner {
936         require(gas >= 200);
937         gasPriceLimit = gas * 1 gwei;
938     }
939 
940     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
941         external
942         view
943         returns (uint256)
944     {
945         require(tAmount <= _tTotal, "Amount must be less than supply");
946         if (!deductTransferFee) {
947             (uint256 rAmount, , , , , ) = _getValues(tAmount);
948             return rAmount;
949         } else {
950             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
951             return rTransferAmount;
952         }
953     }
954 
955     function tokenFromReflection(uint256 rAmount)
956         public
957         view
958         returns (uint256)
959     {
960         require(
961             rAmount <= _rTotal,
962             "Amount must be less than total reflections"
963         );
964         uint256 currentRate = _getRate();
965         return rAmount.div(currentRate);
966     }
967 
968     function excludeFromReward(address account) public onlyOwner {
969         require(!_isExcluded[account], "Account is already excluded");
970         require(_excluded.length + 1 <= 50, "Cannot exclude more than 50 accounts.  Include a previously excluded address.");
971         if (_rOwned[account] > 0) {
972             _tOwned[account] = tokenFromReflection(_rOwned[account]);
973         }
974         _isExcluded[account] = true;
975         _excluded.push(account);
976     }
977 
978     function includeInReward(address account) public onlyOwner {
979         require(_isExcluded[account], "Account is not excluded");
980         for (uint256 i = 0; i < _excluded.length; i++) {
981             if (_excluded[i] == account) {
982                 _excluded[i] = _excluded[_excluded.length - 1];
983                 _tOwned[account] = 0;
984                 _isExcluded[account] = false;
985                 _excluded.pop();
986                 break;
987             }
988         }
989     }
990  
991     function _approve(
992         address owner,
993         address spender,
994         uint256 amount
995     ) private {
996         require(owner != address(0), "ERC20: approve from the zero address");
997         require(spender != address(0), "ERC20: approve to the zero address");
998 
999         _allowances[owner][spender] = amount;
1000         emit Approval(owner, spender, amount);
1001     }
1002 
1003     function _transfer(
1004         address from,
1005         address to,
1006         uint256 amount
1007     ) private {
1008         require(from != address(0), "ERC20: transfer from the zero address");
1009         require(to != address(0), "ERC20: transfer to the zero address");
1010         require(amount > 0, "Transfer amount must be greater than zero");
1011         
1012         if(!tradingActive){
1013             require(_isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading is not active yet.");
1014         }
1015         
1016         
1017         
1018         if(limitsInEffect){
1019             if (
1020                 from != owner() &&
1021                 to != owner() &&
1022                 to != address(0) &&
1023                 to != address(0xdead) &&
1024                 !inSwapAndLiquify
1025             ){
1026                 
1027                 if(from != owner() && to != uniswapV2Pair && block.number == tradingActiveBlock){
1028                     boughtEarly[to] = true;
1029                     emit BoughtEarly(to);
1030                 }
1031                 
1032                 // only use to prevent sniper buys in the first blocks.
1033                 if (gasLimitActive && automatedMarketMakerPairs[from]) {
1034                     require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
1035                 }
1036                 
1037                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1038                 if (transferDelayEnabled){
1039                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1040                         require(_holderLastTransferTimestamp[to] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1041                         _holderLastTransferTimestamp[to] = block.number;
1042                     }
1043                 }
1044                 
1045                 //when buy
1046                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1047                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1048                 } 
1049                 //when sell
1050                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1051                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1052                 }
1053             }
1054         }
1055         
1056         
1057         
1058         uint256 totalTokensToSwap = _liquidityTokensToSwap.add(_marketingTokensToSwap);
1059         uint256 contractTokenBalance = balanceOf(address(this));
1060         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
1061 
1062         // swap and liquify
1063         if (
1064             !inSwapAndLiquify &&
1065             swapAndLiquifyEnabled &&
1066             balanceOf(uniswapV2Pair) > 0 &&
1067             totalTokensToSwap > 0 &&
1068             !_isExcludedFromFee[to] &&
1069             !_isExcludedFromFee[from] &&
1070             automatedMarketMakerPairs[to] &&
1071             overMinimumTokenBalance
1072         ) {
1073             swapBack();
1074         }
1075 
1076         bool takeFee = true;
1077 
1078         // If any account belongs to _isExcludedFromFee account then remove the fee
1079         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1080             takeFee = false;
1081             buyOrSellSwitch = TRANSFER; // TRANSFERs do not pay a tax.
1082         } else {
1083             // Buy
1084             if (automatedMarketMakerPairs[from]) {
1085                 removeAllFee();
1086                 _taxFee = _buyTaxFee;
1087                 _liquidityFee = _buyLiquidityFee + _buyMarketingFee;
1088                 buyOrSellSwitch = BUY;
1089             } 
1090             // Sell
1091             else if (automatedMarketMakerPairs[to]) {
1092                 removeAllFee();
1093                 _taxFee = _sellTaxFee;
1094                 _liquidityFee = _sellLiquidityFee + _sellMarketingFee;
1095                 buyOrSellSwitch = SELL;
1096                 // higher tax if bought in the same block as trading active for 72 hours (sniper protect)
1097                 if(boughtEarly[from] && earlyBuyPenaltyEnd > block.timestamp){
1098                     _taxFee = _taxFee * 5;
1099                     _liquidityFee = _liquidityFee * 5;
1100                 }
1101             // Normal transfers do not get taxed
1102             } else {
1103                 require(!boughtEarly[from] || earlyBuyPenaltyEnd <= block.timestamp, "Snipers can't transfer tokens to sell cheaper until penalty timeframe is over.  DM a Mod.");
1104                 removeAllFee();
1105                 buyOrSellSwitch = TRANSFER; // TRANSFERs do not pay a tax.
1106             }
1107         }
1108         
1109         _tokenTransfer(from, to, amount, takeFee);
1110         
1111     }
1112 
1113     function swapBack() private lockTheSwap {
1114         uint256 contractBalance = balanceOf(address(this));
1115         uint256 totalTokensToSwap = _liquidityTokensToSwap + _marketingTokensToSwap;
1116         
1117         // Halve the amount of liquidity tokens
1118         uint256 tokensForLiquidity = _liquidityTokensToSwap.div(2);
1119         uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity);
1120         
1121         uint256 initialETHBalance = address(this).balance;
1122 
1123         swapTokensForETH(amountToSwapForETH); 
1124         
1125         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1126         
1127         uint256 ethForMarketing = ethBalance.mul(_marketingTokensToSwap).div(totalTokensToSwap);
1128         
1129         uint256 ethForLiquidity = ethBalance.sub(ethForMarketing);
1130         
1131         uint256 ethForDev= ethForMarketing * 2 / 7; // 2/7 gos to dev
1132         ethForMarketing -= ethForDev;
1133         
1134         _liquidityTokensToSwap = 0;
1135         _marketingTokensToSwap = 0;
1136         
1137         (bool success,) = address(marketingAddress).call{value: ethForMarketing}("");
1138         (success,) = address(devAddress).call{value: ethForDev}("");
1139         
1140         addLiquidity(tokensForLiquidity, ethForLiquidity);
1141         emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1142         
1143         // send leftover BNB to the marketing wallet so it doesn't get stuck on the contract.
1144         if(address(this).balance > 1e17){
1145             (success,) = address(marketingAddress).call{value: address(this).balance}("");
1146         }
1147     }
1148     
1149     // force Swap back if slippage above 49% for launch.
1150     function forceSwapBack() external onlyOwner {
1151         uint256 contractBalance = balanceOf(address(this));
1152         require(contractBalance >= _tTotal / 100, "Can only swap back if more than 1% of tokens stuck on contract");
1153         swapBack();
1154         emit OwnerForcedSwapBack(block.timestamp);
1155     }
1156     
1157     function swapTokensForETH(uint256 tokenAmount) private {
1158         address[] memory path = new address[](2);
1159         path[0] = address(this);
1160         path[1] = uniswapV2Router.WETH();
1161         _approve(address(this), address(uniswapV2Router), tokenAmount);
1162         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1163             tokenAmount,
1164             0, // accept any amount of ETH
1165             path,
1166             address(this),
1167             block.timestamp
1168         );
1169     }
1170     
1171     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1172         _approve(address(this), address(uniswapV2Router), tokenAmount);
1173         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1174             address(this),
1175             tokenAmount,
1176             0, // slippage is unavoidable
1177             0, // slippage is unavoidable
1178             liquidityAddress,
1179             block.timestamp
1180         );
1181     }
1182 
1183     function _tokenTransfer(
1184         address sender,
1185         address recipient,
1186         uint256 amount,
1187         bool takeFee
1188     ) private {
1189         if (!takeFee) removeAllFee();
1190 
1191         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1192             _transferFromExcluded(sender, recipient, amount);
1193         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1194             _transferToExcluded(sender, recipient, amount);
1195         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1196             _transferBothExcluded(sender, recipient, amount);
1197         } else {
1198             _transferStandard(sender, recipient, amount);
1199         }
1200 
1201         if (!takeFee) restoreAllFee();
1202     }
1203 
1204     function _transferStandard(
1205         address sender,
1206         address recipient,
1207         uint256 tAmount
1208     ) private {
1209         (
1210             uint256 rAmount,
1211             uint256 rTransferAmount,
1212             uint256 rFee,
1213             uint256 tTransferAmount,
1214             uint256 tFee,
1215             uint256 tLiquidity
1216         ) = _getValues(tAmount);
1217         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1218         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1219         _takeLiquidity(tLiquidity);
1220         _reflectFee(rFee, tFee);
1221         emit Transfer(sender, recipient, tTransferAmount);
1222     }
1223 
1224     function _transferToExcluded(
1225         address sender,
1226         address recipient,
1227         uint256 tAmount
1228     ) private {
1229         (
1230             uint256 rAmount,
1231             uint256 rTransferAmount,
1232             uint256 rFee,
1233             uint256 tTransferAmount,
1234             uint256 tFee,
1235             uint256 tLiquidity
1236         ) = _getValues(tAmount);
1237         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1238         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1239         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1240         _takeLiquidity(tLiquidity);
1241         _reflectFee(rFee, tFee);
1242         emit Transfer(sender, recipient, tTransferAmount);
1243     }
1244 
1245     function _transferFromExcluded(
1246         address sender,
1247         address recipient,
1248         uint256 tAmount
1249     ) private {
1250         (
1251             uint256 rAmount,
1252             uint256 rTransferAmount,
1253             uint256 rFee,
1254             uint256 tTransferAmount,
1255             uint256 tFee,
1256             uint256 tLiquidity
1257         ) = _getValues(tAmount);
1258         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1259         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1260         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1261         _takeLiquidity(tLiquidity);
1262         _reflectFee(rFee, tFee);
1263         emit Transfer(sender, recipient, tTransferAmount);
1264     }
1265 
1266     function _transferBothExcluded(
1267         address sender,
1268         address recipient,
1269         uint256 tAmount
1270     ) private {
1271         (
1272             uint256 rAmount,
1273             uint256 rTransferAmount,
1274             uint256 rFee,
1275             uint256 tTransferAmount,
1276             uint256 tFee,
1277             uint256 tLiquidity
1278         ) = _getValues(tAmount);
1279         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1280         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1281         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1282         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1283         _takeLiquidity(tLiquidity);
1284         _reflectFee(rFee, tFee);
1285         emit Transfer(sender, recipient, tTransferAmount);
1286     }
1287 
1288     function _reflectFee(uint256 rFee, uint256 tFee) private {
1289         _rTotal = _rTotal.sub(rFee);
1290         _tFeeTotal = _tFeeTotal.add(tFee);
1291     }
1292 
1293     function _getValues(uint256 tAmount)
1294         private
1295         view
1296         returns (
1297             uint256,
1298             uint256,
1299             uint256,
1300             uint256,
1301             uint256,
1302             uint256
1303         )
1304     {
1305         (
1306             uint256 tTransferAmount,
1307             uint256 tFee,
1308             uint256 tLiquidity
1309         ) = _getTValues(tAmount);
1310         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1311             tAmount,
1312             tFee,
1313             tLiquidity,
1314             _getRate()
1315         );
1316         return (
1317             rAmount,
1318             rTransferAmount,
1319             rFee,
1320             tTransferAmount,
1321             tFee,
1322             tLiquidity
1323         );
1324     }
1325 
1326     function _getTValues(uint256 tAmount)
1327         private
1328         view
1329         returns (
1330             uint256,
1331             uint256,
1332             uint256
1333         )
1334     {
1335         uint256 tFee = calculateTaxFee(tAmount);
1336         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1337         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1338         return (tTransferAmount, tFee, tLiquidity);
1339     }
1340 
1341     function _getRValues(
1342         uint256 tAmount,
1343         uint256 tFee,
1344         uint256 tLiquidity,
1345         uint256 currentRate
1346     )
1347         private
1348         pure
1349         returns (
1350             uint256,
1351             uint256,
1352             uint256
1353         )
1354     {
1355         uint256 rAmount = tAmount.mul(currentRate);
1356         uint256 rFee = tFee.mul(currentRate);
1357         uint256 rLiquidity = tLiquidity.mul(currentRate);
1358         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1359         return (rAmount, rTransferAmount, rFee);
1360     }
1361 
1362     function _getRate() private view returns (uint256) {
1363         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1364         return rSupply.div(tSupply);
1365     }
1366 
1367     function _getCurrentSupply() private view returns (uint256, uint256) {
1368         uint256 rSupply = _rTotal;
1369         uint256 tSupply = _tTotal;
1370         for (uint256 i = 0; i < _excluded.length; i++) {
1371             if (
1372                 _rOwned[_excluded[i]] > rSupply ||
1373                 _tOwned[_excluded[i]] > tSupply
1374             ) return (_rTotal, _tTotal);
1375             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1376             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1377         }
1378         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1379         return (rSupply, tSupply);
1380     }
1381 
1382     function _takeLiquidity(uint256 tLiquidity) private {
1383         if(buyOrSellSwitch == BUY){
1384             _liquidityTokensToSwap += tLiquidity * _buyLiquidityFee / _liquidityFee;
1385             _marketingTokensToSwap += tLiquidity * _buyMarketingFee / _liquidityFee;
1386         } else if(buyOrSellSwitch == SELL){
1387             _liquidityTokensToSwap += tLiquidity * _sellLiquidityFee / _liquidityFee;
1388             _marketingTokensToSwap += tLiquidity * _sellMarketingFee / _liquidityFee;
1389         }
1390         uint256 currentRate = _getRate();
1391         uint256 rLiquidity = tLiquidity.mul(currentRate);
1392         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1393         if (_isExcluded[address(this)])
1394             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1395     }
1396 
1397     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1398         return _amount.mul(_taxFee).div(10**2);
1399     }
1400 
1401     function calculateLiquidityFee(uint256 _amount)
1402         private
1403         view
1404         returns (uint256)
1405     {
1406         return _amount.mul(_liquidityFee).div(10**2);
1407     }
1408 
1409     function removeAllFee() private {
1410         if (_taxFee == 0 && _liquidityFee == 0) return;
1411 
1412         _previousTaxFee = _taxFee;
1413         _previousLiquidityFee = _liquidityFee;
1414 
1415         _taxFee = 0;
1416         _liquidityFee = 0;
1417     }
1418 
1419     function restoreAllFee() private {
1420         _taxFee = _previousTaxFee;
1421         _liquidityFee = _previousLiquidityFee;
1422     }
1423 
1424     function isExcludedFromFee(address account) external view returns (bool) {
1425         return _isExcludedFromFee[account];
1426     }
1427     
1428      function removeBoughtEarly(address account) external onlyOwner {
1429         boughtEarly[account] = false;
1430         emit RemovedSniper(account);
1431     }
1432 
1433     function excludeFromFee(address account) external onlyOwner {
1434         _isExcludedFromFee[account] = true;
1435         emit ExcludeFromFee(account);
1436     }
1437 
1438     function includeInFee(address account) external onlyOwner {
1439         _isExcludedFromFee[account] = false;
1440         emit IncludeInFee(account);
1441     }
1442 
1443     function setBuyFee(uint256 buyTaxFee, uint256 buyLiquidityFee, uint256 buyMarketingFee)
1444         external
1445         onlyOwner
1446     {
1447         _buyTaxFee = buyTaxFee;
1448         _buyLiquidityFee = buyLiquidityFee;
1449         _buyMarketingFee = buyMarketingFee;
1450         require(_buyTaxFee + _buyLiquidityFee + _buyMarketingFee <= 10, "Must keep buy taxes below 10%");
1451         emit SetBuyFee(buyMarketingFee, buyLiquidityFee, buyTaxFee);
1452     }
1453 
1454     function setSellFee(uint256 sellTaxFee, uint256 sellLiquidityFee, uint256 sellMarketingFee)
1455         external
1456         onlyOwner
1457     {
1458         _sellTaxFee = sellTaxFee;
1459         _sellLiquidityFee = sellLiquidityFee;
1460         _sellMarketingFee = sellMarketingFee;
1461         require(_sellTaxFee + _sellLiquidityFee + _sellMarketingFee <= 15, "Must keep sell taxes below 15%");
1462         emit SetSellFee(sellMarketingFee, sellLiquidityFee, sellTaxFee);
1463     }
1464 
1465 
1466     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1467         require(_marketingAddress != address(0), "_marketingAddress address cannot be 0");
1468         _isExcludedFromFee[marketingAddress] = false;
1469         marketingAddress = payable(_marketingAddress);
1470         _isExcludedFromFee[marketingAddress] = true;
1471         emit UpdatedMarketingAddress(_marketingAddress);
1472     }
1473     
1474     function setLiquidityAddress(address _liquidityAddress) public onlyOwner {
1475         require(_liquidityAddress != address(0), "_liquidityAddress address cannot be 0");
1476         liquidityAddress = payable(_liquidityAddress);
1477         _isExcludedFromFee[liquidityAddress] = true;
1478         emit UpdatedLiquidityAddress(_liquidityAddress);
1479     }
1480 
1481     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1482         swapAndLiquifyEnabled = _enabled;
1483         emit SwapAndLiquifyEnabledUpdated(_enabled);
1484     }
1485 
1486     // To receive ETH from uniswapV2Router when swapping
1487     receive() external payable {}
1488 
1489     function transferForeignToken(address _token, address _to)
1490         external
1491         onlyOwner
1492         returns (bool _sent)
1493     {
1494         require(_token != address(0), "_token address cannot be 0");
1495         require(_token != address(this), "Can't withdraw native tokens");
1496         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1497         _sent = IERC20(_token).transfer(_to, _contractBalance);
1498         emit TransferForeignToken(_token, _contractBalance);
1499     }
1500     
1501     // withdraw ETH if stuck before launch
1502     function withdrawStuckETH() external onlyOwner {
1503         require(!tradingActive, "Can only withdraw if trading hasn't started");
1504         bool success;
1505         (success,) = address(msg.sender).call{value: address(this).balance}("");
1506     }
1507 }