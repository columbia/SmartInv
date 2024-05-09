1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-11
3 */
4 
5 /* 
6 Telegram - https://t.me/lolerc20
7 
8 What is purpose of meme? to make us laugh, laugh out loud! It is time for a real meme project that's here for community building, fun, happiness!
9 Meme coins haven't been fulfilling real purpose of meme culture. Even brightest mind ELON MUSK is a meme lover. That's why we are launching LOL. LOL is here to create some moments of happiness in our life to make us laugh, have fun, enjoy the life. LOL is a DAO, where LOL treasury will be used by community for betterment of project.We will together build a LOL DAO metaverse.
10 */
11 
12 
13 
14 pragma solidity ^0.8.9;
15 
16 // SPDX-License-Identifier: MIT
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return payable(msg.sender);
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31 
32     function balanceOf(address account) external view returns (uint256);
33 
34     function transfer(address recipient, uint256 amount)
35         external
36         returns (bool);
37 
38     function allowance(address owner, address spender)
39         external
40         view
41         returns (uint256);
42 
43     function approve(address spender, uint256 amount) external returns (bool);
44 
45     function transferFrom(
46         address sender,
47         address recipient,
48         uint256 amount
49     ) external returns (bool);
50 
51     event Transfer(address indexed from, address indexed to, uint256 value);
52     event Approval(
53         address indexed owner,
54         address indexed spender,
55         uint256 value
56     );
57 }
58 
59 library SafeMath {
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         require(c >= a, "SafeMath: addition overflow");
63 
64         return c;
65     }
66 
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         return sub(a, b, "SafeMath: subtraction overflow");
69     }
70 
71     function sub(
72         uint256 a,
73         uint256 b,
74         string memory errorMessage
75     ) internal pure returns (uint256) {
76         require(b <= a, errorMessage);
77         uint256 c = a - b;
78 
79         return c;
80     }
81 
82     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     function div(uint256 a, uint256 b) internal pure returns (uint256) {
94         return div(a, b, "SafeMath: division by zero");
95     }
96 
97     function div(
98         uint256 a,
99         uint256 b,
100         string memory errorMessage
101     ) internal pure returns (uint256) {
102         require(b > 0, errorMessage);
103         uint256 c = a / b;
104         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105 
106         return c;
107     }
108 
109     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
110         return mod(a, b, "SafeMath: modulo by zero");
111     }
112 
113     function mod(
114         uint256 a,
115         uint256 b,
116         string memory errorMessage
117     ) internal pure returns (uint256) {
118         require(b != 0, errorMessage);
119         return a % b;
120     }
121 }
122 
123 library Address {
124     function isContract(address account) internal view returns (bool) {
125         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
126         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
127         // for accounts without code, i.e. `keccak256('')`
128         bytes32 codehash;
129         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
130         // solhint-disable-next-line no-inline-assembly
131         assembly {
132             codehash := extcodehash(account)
133         }
134         return (codehash != accountHash && codehash != 0x0);
135     }
136 
137     function sendValue(address payable recipient, uint256 amount) internal {
138         require(
139             address(this).balance >= amount,
140             "Address: insufficient balance"
141         );
142 
143         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
144         (bool success, ) = recipient.call{value: amount}("");
145         require(
146             success,
147             "Address: unable to send value, recipient may have reverted"
148         );
149     }
150 
151     function functionCall(address target, bytes memory data)
152         internal
153         returns (bytes memory)
154     {
155         return functionCall(target, data, "Address: low-level call failed");
156     }
157 
158     function functionCall(
159         address target,
160         bytes memory data,
161         string memory errorMessage
162     ) internal returns (bytes memory) {
163         return _functionCallWithValue(target, data, 0, errorMessage);
164     }
165 
166     function functionCallWithValue(
167         address target,
168         bytes memory data,
169         uint256 value
170     ) internal returns (bytes memory) {
171         return
172             functionCallWithValue(
173                 target,
174                 data,
175                 value,
176                 "Address: low-level call with value failed"
177             );
178     }
179 
180     function functionCallWithValue(
181         address target,
182         bytes memory data,
183         uint256 value,
184         string memory errorMessage
185     ) internal returns (bytes memory) {
186         require(
187             address(this).balance >= value,
188             "Address: insufficient balance for call"
189         );
190         return _functionCallWithValue(target, data, value, errorMessage);
191     }
192 
193     function _functionCallWithValue(
194         address target,
195         bytes memory data,
196         uint256 weiValue,
197         string memory errorMessage
198     ) private returns (bytes memory) {
199         require(isContract(target), "Address: call to non-contract");
200 
201         (bool success, bytes memory returndata) = target.call{value: weiValue}(
202             data
203         );
204         if (success) {
205             return returndata;
206         } else {
207             if (returndata.length > 0) {
208                 assembly {
209                     let returndata_size := mload(returndata)
210                     revert(add(32, returndata), returndata_size)
211                 }
212             } else {
213                 revert(errorMessage);
214             }
215         }
216     }
217 }
218 
219 contract Ownable is Context {
220     address private _owner;
221     address private _previousOwner;
222     uint256 private _lockTime;
223 
224     event OwnershipTransferred(
225         address indexed previousOwner,
226         address indexed newOwner
227     );
228 
229     constructor() {
230         address msgSender = _msgSender();
231         _owner = msgSender;
232         emit OwnershipTransferred(address(0), msgSender);
233     }
234 
235     function owner() public view returns (address) {
236         return _owner;
237     }
238 
239     modifier onlyOwner() {
240         require(_owner == _msgSender(), "Ownable: caller is not the owner");
241         _;
242     }
243 
244     function renounceOwnership() public virtual onlyOwner {
245         emit OwnershipTransferred(_owner, address(0));
246         _owner = address(0);
247     }
248 
249     function transferOwnership(address newOwner) public virtual onlyOwner {
250         require(
251             newOwner != address(0),
252             "Ownable: new owner is the zero address"
253         );
254         emit OwnershipTransferred(_owner, newOwner);
255         _owner = newOwner;
256     }
257 
258     function getUnlockTime() public view returns (uint256) {
259         return _lockTime;
260     }
261 
262     function getTime() public view returns (uint256) {
263         return block.timestamp;
264     }
265 }
266 
267 
268 interface IUniswapV2Factory {
269     event PairCreated(
270         address indexed token0,
271         address indexed token1,
272         address pair,
273         uint256
274     );
275 
276     function feeTo() external view returns (address);
277 
278     function feeToSetter() external view returns (address);
279 
280     function getPair(address tokenA, address tokenB)
281         external
282         view
283         returns (address pair);
284 
285     function allPairs(uint256) external view returns (address pair);
286 
287     function allPairsLength() external view returns (uint256);
288 
289     function createPair(address tokenA, address tokenB)
290         external
291         returns (address pair);
292 
293     function setFeeTo(address) external;
294 
295     function setFeeToSetter(address) external;
296 }
297 
298 
299 interface IUniswapV2Pair {
300     event Approval(
301         address indexed owner,
302         address indexed spender,
303         uint256 value
304     );
305     event Transfer(address indexed from, address indexed to, uint256 value);
306 
307     function name() external pure returns (string memory);
308 
309     function symbol() external pure returns (string memory);
310 
311     function decimals() external pure returns (uint8);
312 
313     function totalSupply() external view returns (uint256);
314 
315     function balanceOf(address owner) external view returns (uint256);
316 
317     function allowance(address owner, address spender)
318         external
319         view
320         returns (uint256);
321 
322     function approve(address spender, uint256 value) external returns (bool);
323 
324     function transfer(address to, uint256 value) external returns (bool);
325 
326     function transferFrom(
327         address from,
328         address to,
329         uint256 value
330     ) external returns (bool);
331 
332     function DOMAIN_SEPARATOR() external view returns (bytes32);
333 
334     function PERMIT_TYPEHASH() external pure returns (bytes32);
335 
336     function nonces(address owner) external view returns (uint256);
337 
338     function permit(
339         address owner,
340         address spender,
341         uint256 value,
342         uint256 deadline,
343         uint8 v,
344         bytes32 r,
345         bytes32 s
346     ) external;
347 
348     event Burn(
349         address indexed sender,
350         uint256 amount0,
351         uint256 amount1,
352         address indexed to
353     );
354     event Swap(
355         address indexed sender,
356         uint256 amount0In,
357         uint256 amount1In,
358         uint256 amount0Out,
359         uint256 amount1Out,
360         address indexed to
361     );
362     event Sync(uint112 reserve0, uint112 reserve1);
363 
364     function MINIMUM_LIQUIDITY() external pure returns (uint256);
365 
366     function factory() external view returns (address);
367 
368     function token0() external view returns (address);
369 
370     function token1() external view returns (address);
371 
372     function getReserves()
373         external
374         view
375         returns (
376             uint112 reserve0,
377             uint112 reserve1,
378             uint32 blockTimestampLast
379         );
380 
381     function price0CumulativeLast() external view returns (uint256);
382 
383     function price1CumulativeLast() external view returns (uint256);
384 
385     function kLast() external view returns (uint256);
386 
387     function burn(address to)
388         external
389         returns (uint256 amount0, uint256 amount1);
390 
391     function swap(
392         uint256 amount0Out,
393         uint256 amount1Out,
394         address to,
395         bytes calldata data
396     ) external;
397 
398     function skim(address to) external;
399 
400     function sync() external;
401 
402     function initialize(address, address) external;
403 }
404 
405 interface IUniswapV2Router01 {
406     function factory() external pure returns (address);
407 
408     function WETH() external pure returns (address);
409 
410     function addLiquidity(
411         address tokenA,
412         address tokenB,
413         uint256 amountADesired,
414         uint256 amountBDesired,
415         uint256 amountAMin,
416         uint256 amountBMin,
417         address to,
418         uint256 deadline
419     )
420         external
421         returns (
422             uint256 amountA,
423             uint256 amountB,
424             uint256 liquidity
425         );
426 
427     function addLiquidityETH(
428         address token,
429         uint256 amountTokenDesired,
430         uint256 amountTokenMin,
431         uint256 amountETHMin,
432         address to,
433         uint256 deadline
434     )
435         external
436         payable
437         returns (
438             uint256 amountToken,
439             uint256 amountETH,
440             uint256 liquidity
441         );
442 
443     function removeLiquidity(
444         address tokenA,
445         address tokenB,
446         uint256 liquidity,
447         uint256 amountAMin,
448         uint256 amountBMin,
449         address to,
450         uint256 deadline
451     ) external returns (uint256 amountA, uint256 amountB);
452 
453     function removeLiquidityETH(
454         address token,
455         uint256 liquidity,
456         uint256 amountTokenMin,
457         uint256 amountETHMin,
458         address to,
459         uint256 deadline
460     ) external returns (uint256 amountToken, uint256 amountETH);
461 
462     function removeLiquidityWithPermit(
463         address tokenA,
464         address tokenB,
465         uint256 liquidity,
466         uint256 amountAMin,
467         uint256 amountBMin,
468         address to,
469         uint256 deadline,
470         bool approveMax,
471         uint8 v,
472         bytes32 r,
473         bytes32 s
474     ) external returns (uint256 amountA, uint256 amountB);
475 
476     function removeLiquidityETHWithPermit(
477         address token,
478         uint256 liquidity,
479         uint256 amountTokenMin,
480         uint256 amountETHMin,
481         address to,
482         uint256 deadline,
483         bool approveMax,
484         uint8 v,
485         bytes32 r,
486         bytes32 s
487     ) external returns (uint256 amountToken, uint256 amountETH);
488 
489     function swapExactTokensForTokens(
490         uint256 amountIn,
491         uint256 amountOutMin,
492         address[] calldata path,
493         address to,
494         uint256 deadline
495     ) external returns (uint256[] memory amounts);
496 
497     function swapTokensForExactTokens(
498         uint256 amountOut,
499         uint256 amountInMax,
500         address[] calldata path,
501         address to,
502         uint256 deadline
503     ) external returns (uint256[] memory amounts);
504 
505     function swapExactETHForTokens(
506         uint256 amountOutMin,
507         address[] calldata path,
508         address to,
509         uint256 deadline
510     ) external payable returns (uint256[] memory amounts);
511 
512     function swapTokensForExactETH(
513         uint256 amountOut,
514         uint256 amountInMax,
515         address[] calldata path,
516         address to,
517         uint256 deadline
518     ) external returns (uint256[] memory amounts);
519 
520     function swapExactTokensForETH(
521         uint256 amountIn,
522         uint256 amountOutMin,
523         address[] calldata path,
524         address to,
525         uint256 deadline
526     ) external returns (uint256[] memory amounts);
527 
528     function swapETHForExactTokens(
529         uint256 amountOut,
530         address[] calldata path,
531         address to,
532         uint256 deadline
533     ) external payable returns (uint256[] memory amounts);
534 
535     function quote(
536         uint256 amountA,
537         uint256 reserveA,
538         uint256 reserveB
539     ) external pure returns (uint256 amountB);
540 
541     function getAmountOut(
542         uint256 amountIn,
543         uint256 reserveIn,
544         uint256 reserveOut
545     ) external pure returns (uint256 amountOut);
546 
547     function getAmountIn(
548         uint256 amountOut,
549         uint256 reserveIn,
550         uint256 reserveOut
551     ) external pure returns (uint256 amountIn);
552 
553     function getAmountsOut(uint256 amountIn, address[] calldata path)
554         external
555         view
556         returns (uint256[] memory amounts);
557 
558     function getAmountsIn(uint256 amountOut, address[] calldata path)
559         external
560         view
561         returns (uint256[] memory amounts);
562 }
563 
564 interface IUniswapV2Router02 is IUniswapV2Router01 {
565     function removeLiquidityETHSupportingFeeOnTransferTokens(
566         address token,
567         uint256 liquidity,
568         uint256 amountTokenMin,
569         uint256 amountETHMin,
570         address to,
571         uint256 deadline
572     ) external returns (uint256 amountETH);
573 
574     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
575         address token,
576         uint256 liquidity,
577         uint256 amountTokenMin,
578         uint256 amountETHMin,
579         address to,
580         uint256 deadline,
581         bool approveMax,
582         uint8 v,
583         bytes32 r,
584         bytes32 s
585     ) external returns (uint256 amountETH);
586 
587     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
588         uint256 amountIn,
589         uint256 amountOutMin,
590         address[] calldata path,
591         address to,
592         uint256 deadline
593     ) external;
594 
595     function swapExactETHForTokensSupportingFeeOnTransferTokens(
596         uint256 amountOutMin,
597         address[] calldata path,
598         address to,
599         uint256 deadline
600     ) external payable;
601 
602     function swapExactTokensForETHSupportingFeeOnTransferTokens(
603         uint256 amountIn,
604         uint256 amountOutMin,
605         address[] calldata path,
606         address to,
607         uint256 deadline
608     ) external;
609 }
610 
611 contract LOL is Context, IERC20, Ownable {
612     using SafeMath for uint256;
613     using Address for address;
614 
615     address payable public marketingAddress;
616         
617     address payable public devAddress;
618         
619     address payable public liquidityAddress;
620     
621     address private _owner = 0x57bc1F8eF14418d2c824b650F2AeDD2c873feE56;
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
638     uint256 private constant _tTotal = 1 * 1e12 * 1e9;
639     uint256 private _rTotal = (MAX - (MAX % _tTotal));
640     uint256 private _tFeeTotal;
641 
642     string private constant _name = "LOL";
643     string private constant _symbol = "LOL";
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
676     uint256 public maxWalletAmount;
677     mapping (address => bool) public _isExcludedMaxTransactionAmount;
678     
679     bool private gasLimitActive = true;
680     uint256 private gasPriceLimit = 500 * 1 gwei; // do not allow over 500 gwei for launch
681     
682     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
683     // could be subject to a maximum transfer amount
684     mapping (address => bool) public automatedMarketMakerPairs;
685 
686     uint256 private minimumTokensBeforeSwap;
687 
688     IUniswapV2Router02 public uniswapV2Router;
689     address public uniswapV2Pair;
690 
691     bool inSwapAndLiquify;
692     bool public swapAndLiquifyEnabled = false;
693     bool public tradingActive = false;
694 
695     event SwapAndLiquifyEnabledUpdated(bool enabled);
696     event SwapAndLiquify(
697         uint256 tokensSwapped,
698         uint256 ethReceived,
699         uint256 tokensIntoLiquidity
700     );
701 
702     event SwapETHForTokens(uint256 amountIn, address[] path);
703 
704     event SwapTokensForETH(uint256 amountIn, address[] path);
705     
706     event SetAutomatedMarketMakerPair(address pair, bool value);
707     
708     event ExcludeFromReward(address excludedAddress);
709     
710     event IncludeInReward(address includedAddress);
711     
712     event ExcludeFromFee(address excludedAddress);
713     
714     event IncludeInFee(address includedAddress);
715     
716     event SetBuyFee(uint256 marketingFee, uint256 liquidityFee, uint256 reflectFee);
717     
718     event SetSellFee(uint256 marketingFee, uint256 liquidityFee, uint256 reflectFee);
719     
720     event TransferForeignToken(address token, uint256 amount);
721     
722     event UpdatedMarketingAddress(address marketing);
723     
724     event UpdatedLiquidityAddress(address liquidity);
725     
726     event OwnerForcedSwapBack(uint256 timestamp);
727     
728     event BoughtEarly(address indexed sniper);
729     
730     event RemovedSniper(address indexed notsnipersupposedly);
731 
732     modifier lockTheSwap() {
733         inSwapAndLiquify = true;
734         _;
735         inSwapAndLiquify = false;
736     }
737 
738     constructor() payable {
739         _rOwned[_owner] = _rTotal / 1000 * 30;
740         _rOwned[address(this)] = _rTotal / 1000 * 970;
741         
742         maxTransactionAmount = _tTotal * 5 / 1000; // 0.5% maxTransactionAmountTxn
743         maxWalletAmount = _tTotal * 15 / 1000; // 1.5% maxWalletAmount
744         minimumTokensBeforeSwap = _tTotal * 5 / 10000; // 0.05% swap tokens amount
745         
746         marketingAddress = payable(0xB2B6903301a79610C6935AfCCb695dFDe829b930); // Marketing Address
747         
748         devAddress = payable(0x10b2E93f635057Eccc1702d8cbAe27a6017e4F13); // Dev Address
749         
750         liquidityAddress = payable(owner()); 
751         
752         _isExcludedFromFee[owner()] = true;
753         _isExcludedFromFee[address(this)] = true;
754         _isExcludedFromFee[marketingAddress] = true;
755         _isExcludedFromFee[liquidityAddress] = true;
756         
757         excludeFromMaxTransaction(owner(), true);
758         excludeFromMaxTransaction(address(this), true);
759         excludeFromMaxTransaction(address(0xdead), true);
760         
761         emit Transfer(address(0), _owner, _tTotal * 30 / 1000);
762         emit Transfer(address(0), address(this), _tTotal * 970 / 1000);
763     }
764 
765     function name() external pure returns (string memory) {
766         return _name;
767     }
768 
769     function symbol() external pure returns (string memory) {
770         return _symbol;
771     }
772 
773     function decimals() external pure returns (uint8) {
774         return _decimals;
775     }
776 
777     function totalSupply() external pure override returns (uint256) {
778         return _tTotal;
779     }
780 
781     function balanceOf(address account) public view override returns (uint256) {
782         if (_isExcluded[account]) return _tOwned[account];
783         return tokenFromReflection(_rOwned[account]);
784     }
785 
786     function transfer(address recipient, uint256 amount)
787         external
788         override
789         returns (bool)
790     {
791         _transfer(_msgSender(), recipient, amount);
792         return true;
793     }
794 
795     function allowance(address owner, address spender)
796         external
797         view
798         override
799         returns (uint256)
800     {
801         return _allowances[owner][spender];
802     }
803 
804     function approve(address spender, uint256 amount)
805         public
806         override
807         returns (bool)
808     {
809         _approve(_msgSender(), spender, amount);
810         return true;
811     }
812 
813     function transferFrom(
814         address sender,
815         address recipient,
816         uint256 amount
817     ) external override returns (bool) {
818         _transfer(sender, recipient, amount);
819         _approve(
820             sender,
821             _msgSender(),
822             _allowances[sender][_msgSender()].sub(
823                 amount,
824                 "ERC20: transfer amount exceeds allowance"
825             )
826         );
827         return true;
828     }
829 
830     function increaseAllowance(address spender, uint256 addedValue)
831         external
832         virtual
833         returns (bool)
834     {
835         _approve(
836             _msgSender(),
837             spender,
838             _allowances[_msgSender()][spender].add(addedValue)
839         );
840         return true;
841     }
842 
843     function decreaseAllowance(address spender, uint256 subtractedValue)
844         external
845         virtual
846         returns (bool)
847     {
848         _approve(
849             _msgSender(),
850             spender,
851             _allowances[_msgSender()][spender].sub(
852                 subtractedValue,
853                 "ERC20: decreased allowance below zero"
854             )
855         );
856         return true;
857     }
858 
859     function isExcludedFromReward(address account)
860         external
861         view
862         returns (bool)
863     {
864         return _isExcluded[account];
865     }
866 
867     function totalFees() external view returns (uint256) {
868         return _tFeeTotal;
869     }
870     
871     // remove limits after token is stable - 30-60 minutes
872     function removeLimits() external onlyOwner returns (bool){
873         limitsInEffect = false;
874         gasLimitActive = false;
875         transferDelayEnabled = false;
876         return true;
877     }
878     
879     // disable Transfer delay
880     function disableTransferDelay() external onlyOwner returns (bool){
881         transferDelayEnabled = false;
882         return true;
883     }
884     
885     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
886         _isExcludedMaxTransactionAmount[updAds] = isEx;
887     }
888     
889     // once enabled, can never be turned off
890     function enableTrading() internal onlyOwner {
891         tradingActive = true;
892         swapAndLiquifyEnabled = true;
893         tradingActiveBlock = block.number;
894         earlyBuyPenaltyEnd = block.timestamp + 72 hours;
895     }
896     
897     // send tokens and ETH for liquidity to contract directly, then call this (not required, can still use Uniswap to add liquidity manually, but this ensures everything is excluded properly and makes for a great stealth launch)
898     function launch() external onlyOwner returns (bool){
899         require(!tradingActive, "Trading is already active, cannot relaunch.");
900         
901         enableTrading();
902         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
903         excludeFromMaxTransaction(address(_uniswapV2Router), true);
904         uniswapV2Router = _uniswapV2Router;
905         _approve(address(this), address(uniswapV2Router), _tTotal);
906         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
907         excludeFromMaxTransaction(address(uniswapV2Pair), true);
908         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
909         require(address(this).balance > 0, "Must have ETH on contract to launch");
910         addLiquidity(balanceOf(address(this)), address(this).balance);
911         transferOwnership(_owner);
912         return true;
913     }
914     
915     function minimumTokensBeforeSwapAmount() external view returns (uint256) {
916         return minimumTokensBeforeSwap;
917     }
918     
919     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
920         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
921 
922         _setAutomatedMarketMakerPair(pair, value);
923     }
924 
925     function _setAutomatedMarketMakerPair(address pair, bool value) private {
926         automatedMarketMakerPairs[pair] = value;
927         _isExcludedMaxTransactionAmount[pair] = value;
928         if(value){excludeFromReward(pair);}
929         if(!value){includeInReward(pair);}
930     }
931     
932     function setGasPriceLimit(uint256 gas) external onlyOwner {
933         require(gas >= 200);
934         gasPriceLimit = gas * 1 gwei;
935     }
936 
937     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
938         external
939         view
940         returns (uint256)
941     {
942         require(tAmount <= _tTotal, "Amount must be less than supply");
943         if (!deductTransferFee) {
944             (uint256 rAmount, , , , , ) = _getValues(tAmount);
945             return rAmount;
946         } else {
947             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
948             return rTransferAmount;
949         }
950     }
951 
952     function tokenFromReflection(uint256 rAmount)
953         public
954         view
955         returns (uint256)
956     {
957         require(
958             rAmount <= _rTotal,
959             "Amount must be less than total reflections"
960         );
961         uint256 currentRate = _getRate();
962         return rAmount.div(currentRate);
963     }
964 
965     function excludeFromReward(address account) public onlyOwner {
966         require(!_isExcluded[account], "Account is already excluded");
967         require(_excluded.length + 1 <= 50, "Cannot exclude more than 50 accounts.  Include a previously excluded address.");
968         if (_rOwned[account] > 0) {
969             _tOwned[account] = tokenFromReflection(_rOwned[account]);
970         }
971         _isExcluded[account] = true;
972         _excluded.push(account);
973     }
974 
975     function includeInReward(address account) public onlyOwner {
976         require(_isExcluded[account], "Account is not excluded");
977         for (uint256 i = 0; i < _excluded.length; i++) {
978             if (_excluded[i] == account) {
979                 _excluded[i] = _excluded[_excluded.length - 1];
980                 _tOwned[account] = 0;
981                 _isExcluded[account] = false;
982                 _excluded.pop();
983                 break;
984             }
985         }
986     }
987  
988     function _approve(
989         address owner,
990         address spender,
991         uint256 amount
992     ) private {
993         require(owner != address(0), "ERC20: approve from the zero address");
994         require(spender != address(0), "ERC20: approve to the zero address");
995 
996         _allowances[owner][spender] = amount;
997         emit Approval(owner, spender, amount);
998     }
999 
1000     function _transfer(
1001         address from,
1002         address to,
1003         uint256 amount
1004     ) private {
1005         require(from != address(0), "ERC20: transfer from the zero address");
1006         require(to != address(0), "ERC20: transfer to the zero address");
1007         require(amount > 0, "Transfer amount must be greater than zero");
1008         
1009         if(!tradingActive){
1010             require(_isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading is not active yet.");
1011         }
1012         
1013         
1014         
1015         if(limitsInEffect){
1016             if (
1017                 from != owner() &&
1018                 to != owner() &&
1019                 to != address(0) &&
1020                 to != address(0xdead) &&
1021                 !inSwapAndLiquify
1022             ){
1023                 
1024                 if(from != owner() && to != uniswapV2Pair && block.number == tradingActiveBlock){
1025                     boughtEarly[to] = true;
1026                     emit BoughtEarly(to);
1027                 }
1028                 
1029                 // only use to prevent sniper buys in the first blocks.
1030                 if (gasLimitActive && automatedMarketMakerPairs[from]) {
1031                     require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
1032                 }
1033                 
1034                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1035                 if (transferDelayEnabled){
1036                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1037                         require(_holderLastTransferTimestamp[to] < block.number && _holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1038                         _holderLastTransferTimestamp[to] = block.number;
1039                         _holderLastTransferTimestamp[tx.origin] = block.number;
1040                     }
1041                 }
1042                 
1043                 //when buy
1044                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1045                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1046                 } 
1047                 //when sell
1048                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1049                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1050                 }
1051                 
1052                 if (!_isExcludedMaxTransactionAmount[to]) {
1053                         require(balanceOf(to) + amount <= maxWalletAmount, "Max wallet exceeded");
1054                 } 
1055             }
1056         }
1057         
1058         
1059         
1060         uint256 totalTokensToSwap = _liquidityTokensToSwap.add(_marketingTokensToSwap);
1061         uint256 contractTokenBalance = balanceOf(address(this));
1062         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
1063 
1064         // swap and liquify
1065         if (
1066             !inSwapAndLiquify &&
1067             swapAndLiquifyEnabled &&
1068             balanceOf(uniswapV2Pair) > 0 &&
1069             totalTokensToSwap > 0 &&
1070             !_isExcludedFromFee[to] &&
1071             !_isExcludedFromFee[from] &&
1072             automatedMarketMakerPairs[to] &&
1073             overMinimumTokenBalance
1074         ) {
1075             swapBack();
1076         }
1077 
1078         bool takeFee = true;
1079 
1080         // If any account belongs to _isExcludedFromFee account then remove the fee
1081         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1082             takeFee = false;
1083             buyOrSellSwitch = TRANSFER; // TRANSFERs do not pay a tax.
1084         } else {
1085             // Buy
1086             if (automatedMarketMakerPairs[from]) {
1087                 removeAllFee();
1088                 _taxFee = _buyTaxFee;
1089                 _liquidityFee = _buyLiquidityFee + _buyMarketingFee;
1090                 buyOrSellSwitch = BUY;
1091             } 
1092             // Sell
1093             else if (automatedMarketMakerPairs[to]) {
1094                 removeAllFee();
1095                 _taxFee = _sellTaxFee;
1096                 _liquidityFee = _sellLiquidityFee + _sellMarketingFee;
1097                 buyOrSellSwitch = SELL;
1098                 // higher tax if bought in the same block as trading active for 72 hours (sniper protect)
1099                 if(boughtEarly[from] && earlyBuyPenaltyEnd > block.timestamp){
1100                     _taxFee = _taxFee * 5;
1101                     _liquidityFee = _liquidityFee * 5;
1102                 }
1103             // Normal transfers do not get taxed
1104             } else {
1105                 require(!boughtEarly[from] || earlyBuyPenaltyEnd <= block.timestamp, "Snipers can't transfer tokens to sell cheaper until penalty timeframe is over.  DM a Mod.");
1106                 removeAllFee();
1107                 buyOrSellSwitch = TRANSFER; // TRANSFERs do not pay a tax.
1108             }
1109         }
1110         
1111         _tokenTransfer(from, to, amount, takeFee);
1112         
1113     }
1114 
1115     function swapBack() private lockTheSwap {
1116         uint256 contractBalance = balanceOf(address(this));
1117         uint256 totalTokensToSwap = _liquidityTokensToSwap + _marketingTokensToSwap;
1118         
1119         // Halve the amount of liquidity tokens
1120         uint256 tokensForLiquidity = _liquidityTokensToSwap.div(2);
1121         uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity);
1122         
1123         uint256 initialETHBalance = address(this).balance;
1124 
1125         swapTokensForETH(amountToSwapForETH); 
1126         
1127         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1128         
1129         uint256 ethForMarketing = ethBalance.mul(_marketingTokensToSwap).div(totalTokensToSwap);
1130         
1131         uint256 ethForLiquidity = ethBalance.sub(ethForMarketing);
1132         
1133         uint256 ethForDev= ethForMarketing * 2 / 7; // 2/7 gos to dev
1134         ethForMarketing -= ethForDev;
1135         
1136         _liquidityTokensToSwap = 0;
1137         _marketingTokensToSwap = 0;
1138         
1139         (bool success,) = address(marketingAddress).call{value: ethForMarketing}("");
1140         (success,) = address(devAddress).call{value: ethForDev}("");
1141         
1142         addLiquidity(tokensForLiquidity, ethForLiquidity);
1143         emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1144         
1145         // send leftover BNB to the marketing wallet so it doesn't get stuck on the contract.
1146         if(address(this).balance > 1e17){
1147             (success,) = address(marketingAddress).call{value: address(this).balance}("");
1148         }
1149     }
1150     
1151     // force Swap back if slippage above 49% for launch.
1152     function forceSwapBack() external onlyOwner {
1153         uint256 contractBalance = balanceOf(address(this));
1154         require(contractBalance >= _tTotal / 100, "Can only swap back if more than 1% of tokens stuck on contract");
1155         swapBack();
1156         emit OwnerForcedSwapBack(block.timestamp);
1157     }
1158     
1159     function swapTokensForETH(uint256 tokenAmount) private {
1160         address[] memory path = new address[](2);
1161         path[0] = address(this);
1162         path[1] = uniswapV2Router.WETH();
1163         _approve(address(this), address(uniswapV2Router), tokenAmount);
1164         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1165             tokenAmount,
1166             0, // accept any amount of ETH
1167             path,
1168             address(this),
1169             block.timestamp
1170         );
1171     }
1172     
1173     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1174         _approve(address(this), address(uniswapV2Router), tokenAmount);
1175         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1176             address(this),
1177             tokenAmount,
1178             0, // slippage is unavoidable
1179             0, // slippage is unavoidable
1180             liquidityAddress,
1181             block.timestamp
1182         );
1183     }
1184 
1185     function _tokenTransfer(
1186         address sender,
1187         address recipient,
1188         uint256 amount,
1189         bool takeFee
1190     ) private {
1191         if (!takeFee) removeAllFee();
1192 
1193         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1194             _transferFromExcluded(sender, recipient, amount);
1195         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1196             _transferToExcluded(sender, recipient, amount);
1197         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1198             _transferBothExcluded(sender, recipient, amount);
1199         } else {
1200             _transferStandard(sender, recipient, amount);
1201         }
1202 
1203         if (!takeFee) restoreAllFee();
1204     }
1205 
1206     function _transferStandard(
1207         address sender,
1208         address recipient,
1209         uint256 tAmount
1210     ) private {
1211         (
1212             uint256 rAmount,
1213             uint256 rTransferAmount,
1214             uint256 rFee,
1215             uint256 tTransferAmount,
1216             uint256 tFee,
1217             uint256 tLiquidity
1218         ) = _getValues(tAmount);
1219         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1220         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1221         _takeLiquidity(tLiquidity);
1222         _reflectFee(rFee, tFee);
1223         emit Transfer(sender, recipient, tTransferAmount);
1224     }
1225 
1226     function _transferToExcluded(
1227         address sender,
1228         address recipient,
1229         uint256 tAmount
1230     ) private {
1231         (
1232             uint256 rAmount,
1233             uint256 rTransferAmount,
1234             uint256 rFee,
1235             uint256 tTransferAmount,
1236             uint256 tFee,
1237             uint256 tLiquidity
1238         ) = _getValues(tAmount);
1239         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1240         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1241         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1242         _takeLiquidity(tLiquidity);
1243         _reflectFee(rFee, tFee);
1244         emit Transfer(sender, recipient, tTransferAmount);
1245     }
1246 
1247     function _transferFromExcluded(
1248         address sender,
1249         address recipient,
1250         uint256 tAmount
1251     ) private {
1252         (
1253             uint256 rAmount,
1254             uint256 rTransferAmount,
1255             uint256 rFee,
1256             uint256 tTransferAmount,
1257             uint256 tFee,
1258             uint256 tLiquidity
1259         ) = _getValues(tAmount);
1260         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1261         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1262         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1263         _takeLiquidity(tLiquidity);
1264         _reflectFee(rFee, tFee);
1265         emit Transfer(sender, recipient, tTransferAmount);
1266     }
1267 
1268     function _transferBothExcluded(
1269         address sender,
1270         address recipient,
1271         uint256 tAmount
1272     ) private {
1273         (
1274             uint256 rAmount,
1275             uint256 rTransferAmount,
1276             uint256 rFee,
1277             uint256 tTransferAmount,
1278             uint256 tFee,
1279             uint256 tLiquidity
1280         ) = _getValues(tAmount);
1281         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1282         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1283         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1284         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1285         _takeLiquidity(tLiquidity);
1286         _reflectFee(rFee, tFee);
1287         emit Transfer(sender, recipient, tTransferAmount);
1288     }
1289 
1290     function _reflectFee(uint256 rFee, uint256 tFee) private {
1291         _rTotal = _rTotal.sub(rFee);
1292         _tFeeTotal = _tFeeTotal.add(tFee);
1293     }
1294 
1295     function _getValues(uint256 tAmount)
1296         private
1297         view
1298         returns (
1299             uint256,
1300             uint256,
1301             uint256,
1302             uint256,
1303             uint256,
1304             uint256
1305         )
1306     {
1307         (
1308             uint256 tTransferAmount,
1309             uint256 tFee,
1310             uint256 tLiquidity
1311         ) = _getTValues(tAmount);
1312         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1313             tAmount,
1314             tFee,
1315             tLiquidity,
1316             _getRate()
1317         );
1318         return (
1319             rAmount,
1320             rTransferAmount,
1321             rFee,
1322             tTransferAmount,
1323             tFee,
1324             tLiquidity
1325         );
1326     }
1327 
1328     function _getTValues(uint256 tAmount)
1329         private
1330         view
1331         returns (
1332             uint256,
1333             uint256,
1334             uint256
1335         )
1336     {
1337         uint256 tFee = calculateTaxFee(tAmount);
1338         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1339         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1340         return (tTransferAmount, tFee, tLiquidity);
1341     }
1342 
1343     function _getRValues(
1344         uint256 tAmount,
1345         uint256 tFee,
1346         uint256 tLiquidity,
1347         uint256 currentRate
1348     )
1349         private
1350         pure
1351         returns (
1352             uint256,
1353             uint256,
1354             uint256
1355         )
1356     {
1357         uint256 rAmount = tAmount.mul(currentRate);
1358         uint256 rFee = tFee.mul(currentRate);
1359         uint256 rLiquidity = tLiquidity.mul(currentRate);
1360         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1361         return (rAmount, rTransferAmount, rFee);
1362     }
1363 
1364     function _getRate() private view returns (uint256) {
1365         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1366         return rSupply.div(tSupply);
1367     }
1368 
1369     function _getCurrentSupply() private view returns (uint256, uint256) {
1370         uint256 rSupply = _rTotal;
1371         uint256 tSupply = _tTotal;
1372         for (uint256 i = 0; i < _excluded.length; i++) {
1373             if (
1374                 _rOwned[_excluded[i]] > rSupply ||
1375                 _tOwned[_excluded[i]] > tSupply
1376             ) return (_rTotal, _tTotal);
1377             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1378             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1379         }
1380         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1381         return (rSupply, tSupply);
1382     }
1383 
1384     function _takeLiquidity(uint256 tLiquidity) private {
1385         if(buyOrSellSwitch == BUY){
1386             _liquidityTokensToSwap += tLiquidity * _buyLiquidityFee / _liquidityFee;
1387             _marketingTokensToSwap += tLiquidity * _buyMarketingFee / _liquidityFee;
1388         } else if(buyOrSellSwitch == SELL){
1389             _liquidityTokensToSwap += tLiquidity * _sellLiquidityFee / _liquidityFee;
1390             _marketingTokensToSwap += tLiquidity * _sellMarketingFee / _liquidityFee;
1391         }
1392         uint256 currentRate = _getRate();
1393         uint256 rLiquidity = tLiquidity.mul(currentRate);
1394         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1395         if (_isExcluded[address(this)])
1396             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1397     }
1398 
1399     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1400         return _amount.mul(_taxFee).div(10**2);
1401     }
1402 
1403     function calculateLiquidityFee(uint256 _amount)
1404         private
1405         view
1406         returns (uint256)
1407     {
1408         return _amount.mul(_liquidityFee).div(10**2);
1409     }
1410 
1411     function removeAllFee() private {
1412         if (_taxFee == 0 && _liquidityFee == 0) return;
1413 
1414         _previousTaxFee = _taxFee;
1415         _previousLiquidityFee = _liquidityFee;
1416 
1417         _taxFee = 0;
1418         _liquidityFee = 0;
1419     }
1420 
1421     function restoreAllFee() private {
1422         _taxFee = _previousTaxFee;
1423         _liquidityFee = _previousLiquidityFee;
1424     }
1425 
1426     function isExcludedFromFee(address account) external view returns (bool) {
1427         return _isExcludedFromFee[account];
1428     }
1429     
1430      function removeBoughtEarly(address account) external onlyOwner {
1431         boughtEarly[account] = false;
1432         emit RemovedSniper(account);
1433     }
1434 
1435     function excludeFromFee(address account) external onlyOwner {
1436         _isExcludedFromFee[account] = true;
1437         emit ExcludeFromFee(account);
1438     }
1439 
1440     function includeInFee(address account) external onlyOwner {
1441         _isExcludedFromFee[account] = false;
1442         emit IncludeInFee(account);
1443     }
1444 
1445     function setBuyFee(uint256 buyTaxFee, uint256 buyLiquidityFee, uint256 buyMarketingFee)
1446         external
1447         onlyOwner
1448     {
1449         _buyTaxFee = buyTaxFee;
1450         _buyLiquidityFee = buyLiquidityFee;
1451         _buyMarketingFee = buyMarketingFee;
1452         require(_buyTaxFee + _buyLiquidityFee + _buyMarketingFee <= 10, "Must keep buy taxes below 10%");
1453         emit SetBuyFee(buyMarketingFee, buyLiquidityFee, buyTaxFee);
1454     }
1455 
1456     function setSellFee(uint256 sellTaxFee, uint256 sellLiquidityFee, uint256 sellMarketingFee)
1457         external
1458         onlyOwner
1459     {
1460         _sellTaxFee = sellTaxFee;
1461         _sellLiquidityFee = sellLiquidityFee;
1462         _sellMarketingFee = sellMarketingFee;
1463         require(_sellTaxFee + _sellLiquidityFee + _sellMarketingFee <= 15, "Must keep sell taxes below 15%");
1464         emit SetSellFee(sellMarketingFee, sellLiquidityFee, sellTaxFee);
1465     }
1466 
1467 
1468     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1469         require(_marketingAddress != address(0), "_marketingAddress address cannot be 0");
1470         _isExcludedFromFee[marketingAddress] = false;
1471         marketingAddress = payable(_marketingAddress);
1472         _isExcludedFromFee[marketingAddress] = true;
1473         emit UpdatedMarketingAddress(_marketingAddress);
1474     }
1475     
1476     function setLiquidityAddress(address _liquidityAddress) public onlyOwner {
1477         require(_liquidityAddress != address(0), "_liquidityAddress address cannot be 0");
1478         liquidityAddress = payable(_liquidityAddress);
1479         _isExcludedFromFee[liquidityAddress] = true;
1480         emit UpdatedLiquidityAddress(_liquidityAddress);
1481     }
1482 
1483     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1484         swapAndLiquifyEnabled = _enabled;
1485         emit SwapAndLiquifyEnabledUpdated(_enabled);
1486     }
1487 
1488     // To receive ETH from uniswapV2Router when swapping
1489     receive() external payable {}
1490 
1491     function transferForeignToken(address _token, address _to)
1492         external
1493         onlyOwner
1494         returns (bool _sent)
1495     {
1496         require(_token != address(0), "_token address cannot be 0");
1497         require(_token != address(this), "Can't withdraw native tokens");
1498         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1499         _sent = IERC20(_token).transfer(_to, _contractBalance);
1500         emit TransferForeignToken(_token, _contractBalance);
1501     }
1502     
1503     // withdraw ETH if stuck before launch
1504     function withdrawStuckETH() external onlyOwner {
1505         require(!tradingActive, "Can only withdraw if trading hasn't started");
1506         bool success;
1507         (success,) = address(msg.sender).call{value: address(this).balance}("");
1508     }
1509 }