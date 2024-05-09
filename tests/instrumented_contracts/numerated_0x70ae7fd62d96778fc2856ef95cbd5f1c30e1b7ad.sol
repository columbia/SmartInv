1 /*
2 We are FSOCIETY. We are MANY.
3 
4 Website: https://Fsociety.pro
5 Twitter: https://twitter.com/FsocietyERC20
6 
7 𝙵𝚂𝙾𝙲𝙸𝙴𝚃𝚈 𝚑𝚊𝚜 𝚣𝚎𝚛𝚘 𝚝𝚘𝚕𝚎𝚛𝚊𝚗𝚌𝚎 𝚏𝚘𝚛 𝚝𝚑𝚎 𝚞𝚜𝚎 𝚘𝚏 𝚝𝚑𝚎 𝚌𝚘𝚛𝚙𝚘𝚛𝚊𝚝𝚎 𝚋𝚘𝚝𝚜 𝚘𝚏 𝚝𝚑𝚒𝚜 𝚠𝚘𝚛𝚕𝚍. 𝙱𝚘𝚝𝚜 𝚠𝚒𝚕𝚕 𝚋𝚎 𝚘𝚜𝚝𝚛𝚊𝚌𝚒𝚣𝚎𝚍. You have been warned.
8 */
9 
10 // SPDX-License-Identifier: MIT
11 
12 pragma solidity ^0.8.1;
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16 
17     function balanceOf(address account) external view returns (uint256);
18 
19     function transfer(address recipient, uint256 amount)
20         external
21         returns (bool);
22 
23     function allowance(address owner, address spender)
24         external
25         view
26         returns (uint256);
27 
28     function approve(address spender, uint256 amount) external returns (bool);
29 
30     function transferFrom(
31         address sender,
32         address recipient,
33         uint256 amount
34     ) external returns (bool);
35 
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 
38     event Approval(
39         address indexed owner,
40         address indexed spender,
41         uint256 value
42     );
43 }
44 
45 abstract contract Context {
46     function _msgSender() internal view virtual returns (address) {
47         return msg.sender;
48     }
49 
50     function _msgData() internal view virtual returns (bytes memory) {
51         this;
52         return msg.data;
53     }
54 }
55 
56 library Address {
57     function isContract(address account) internal view returns (bool) {
58         bytes32 codehash;
59         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
60         assembly {
61             codehash := extcodehash(account)
62         }
63         return (codehash != accountHash && codehash != 0x0);
64     }
65 
66     function sendValue(address payable recipient, uint256 amount) internal {
67         require(
68             address(this).balance >= amount,
69             "Address: insufficient balance"
70         );
71 
72         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
73         (bool success, ) = recipient.call{value: amount}("");
74         require(
75             success,
76             "Address: unable to send value, recipient may have reverted"
77         );
78     }
79 
80     function functionCall(address target, bytes memory data)
81         internal
82         returns (bytes memory)
83     {
84         return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     function functionCall(
88         address target,
89         bytes memory data,
90         string memory errorMessage
91     ) internal returns (bytes memory) {
92         return _functionCallWithValue(target, data, 0, errorMessage);
93     }
94 
95     function functionCallWithValue(
96         address target,
97         bytes memory data,
98         uint256 value
99     ) internal returns (bytes memory) {
100         return
101             functionCallWithValue(
102                 target,
103                 data,
104                 value,
105                 "Address: low-level call with value failed"
106             );
107     }
108 
109     function functionCallWithValue(
110         address target,
111         bytes memory data,
112         uint256 value,
113         string memory errorMessage
114     ) internal returns (bytes memory) {
115         require(
116             address(this).balance >= value,
117             "Address: insufficient balance for call"
118         );
119         return _functionCallWithValue(target, data, value, errorMessage);
120     }
121 
122     function _functionCallWithValue(
123         address target,
124         bytes memory data,
125         uint256 weiValue,
126         string memory errorMessage
127     ) private returns (bytes memory) {
128         require(isContract(target), "Address: call to non-contract");
129 
130         (bool success, bytes memory returndata) = target.call{value: weiValue}(
131             data
132         );
133         if (success) {
134             return returndata;
135         } else {
136             if (returndata.length > 0) {
137                 assembly {
138                     let returndata_size := mload(returndata)
139                     revert(add(32, returndata), returndata_size)
140                 }
141             } else {
142                 revert(errorMessage);
143             }
144         }
145     }
146 }
147 
148 contract Ownable is Context {
149     address private _owner;
150     address private _previousOwner;
151     uint256 private _lockTime;
152 
153     event OwnershipTransferred(
154         address indexed previousOwner,
155         address indexed newOwner
156     );
157 
158     constructor() {
159         address msgSender = _msgSender();
160         _owner = msgSender;
161         emit OwnershipTransferred(address(0), msgSender);
162     }
163 
164     function owner() public view returns (address) {
165         return _owner;
166     }
167 
168     modifier onlyOwner() {
169         require(_owner == _msgSender(), "Ownable: caller is not the owner");
170         _;
171     }
172 
173     function renounceOwnership() public virtual onlyOwner {
174         emit OwnershipTransferred(_owner, address(0));
175         _owner = address(0);
176     }
177 
178     function transferOwnership(address newOwner) public virtual onlyOwner {
179         require(
180             newOwner != address(0),
181             "Ownable: new owner is the zero address"
182         );
183         emit OwnershipTransferred(_owner, newOwner);
184         _owner = newOwner;
185     }
186 }
187 
188 // pragma solidity >=0.5.0;
189 
190 interface IUniswapV2Factory {
191     event PairCreated(
192         address indexed token0,
193         address indexed token1,
194         address pair,
195         uint256
196     );
197 
198     function feeTo() external view returns (address);
199 
200     function feeToSetter() external view returns (address);
201 
202     function getPair(address tokenA, address tokenB)
203         external
204         view
205         returns (address pair);
206 
207     function allPairs(uint256) external view returns (address pair);
208 
209     function allPairsLength() external view returns (uint256);
210 
211     function createPair(address tokenA, address tokenB)
212         external
213         returns (address pair);
214 
215     function setFeeTo(address) external;
216 
217     function setFeeToSetter(address) external;
218 }
219 
220 // pragma solidity >=0.5.0;
221 
222 interface IUniswapV2Pair {
223     event Approval(
224         address indexed owner,
225         address indexed spender,
226         uint256 value
227     );
228     event Transfer(address indexed from, address indexed to, uint256 value);
229 
230     function name() external pure returns (string memory);
231 
232     function symbol() external pure returns (string memory);
233 
234     function decimals() external pure returns (uint8);
235 
236     function totalSupply() external view returns (uint256);
237 
238     function balanceOf(address owner) external view returns (uint256);
239 
240     function allowance(address owner, address spender)
241         external
242         view
243         returns (uint256);
244 
245     function approve(address spender, uint256 value) external returns (bool);
246 
247     function transfer(address to, uint256 value) external returns (bool);
248 
249     function transferFrom(
250         address from,
251         address to,
252         uint256 value
253     ) external returns (bool);
254 
255     function DOMAIN_SEPARATOR() external view returns (bytes32);
256 
257     function PERMIT_TYPEHASH() external pure returns (bytes32);
258 
259     function nonces(address owner) external view returns (uint256);
260 
261     function permit(
262         address owner,
263         address spender,
264         uint256 value,
265         uint256 deadline,
266         uint8 v,
267         bytes32 r,
268         bytes32 s
269     ) external;
270 
271     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
272     event Burn(
273         address indexed sender,
274         uint256 amount0,
275         uint256 amount1,
276         address indexed to
277     );
278     event Swap(
279         address indexed sender,
280         uint256 amount0In,
281         uint256 amount1In,
282         uint256 amount0Out,
283         uint256 amount1Out,
284         address indexed to
285     );
286     event Sync(uint112 reserve0, uint112 reserve1);
287 
288     function MINIMUM_LIQUIDITY() external pure returns (uint256);
289 
290     function factory() external view returns (address);
291 
292     function token0() external view returns (address);
293 
294     function token1() external view returns (address);
295 
296     function getReserves()
297         external
298         view
299         returns (
300             uint112 reserve0,
301             uint112 reserve1,
302             uint32 blockTimestampLast
303         );
304 
305     function price0CumulativeLast() external view returns (uint256);
306 
307     function price1CumulativeLast() external view returns (uint256);
308 
309     function kLast() external view returns (uint256);
310 
311     function mint(address to) external returns (uint256 liquidity);
312 
313     function burn(address to)
314         external
315         returns (uint256 amount0, uint256 amount1);
316 
317     function swap(
318         uint256 amount0Out,
319         uint256 amount1Out,
320         address to,
321         bytes calldata data
322     ) external;
323 
324     function skim(address to) external;
325 
326     function sync() external;
327 
328     function initialize(address, address) external;
329 }
330 
331 // pragma solidity >=0.6.2;
332 
333 interface IUniswapV2Router01 {
334     function factory() external pure returns (address);
335 
336     function WETH() external pure returns (address);
337 
338     function addLiquidity(
339         address tokenA,
340         address tokenB,
341         uint256 amountADesired,
342         uint256 amountBDesired,
343         uint256 amountAMin,
344         uint256 amountBMin,
345         address to,
346         uint256 deadline
347     )
348         external
349         returns (
350             uint256 amountA,
351             uint256 amountB,
352             uint256 liquidity
353         );
354 
355     function addLiquidityETH(
356         address token,
357         uint256 amountTokenDesired,
358         uint256 amountTokenMin,
359         uint256 amountETHMin,
360         address to,
361         uint256 deadline
362     )
363         external
364         payable
365         returns (
366             uint256 amountToken,
367             uint256 amountETH,
368             uint256 liquidity
369         );
370 
371     function removeLiquidity(
372         address tokenA,
373         address tokenB,
374         uint256 liquidity,
375         uint256 amountAMin,
376         uint256 amountBMin,
377         address to,
378         uint256 deadline
379     ) external returns (uint256 amountA, uint256 amountB);
380 
381     function removeLiquidityETH(
382         address token,
383         uint256 liquidity,
384         uint256 amountTokenMin,
385         uint256 amountETHMin,
386         address to,
387         uint256 deadline
388     ) external returns (uint256 amountToken, uint256 amountETH);
389 
390     function removeLiquidityWithPermit(
391         address tokenA,
392         address tokenB,
393         uint256 liquidity,
394         uint256 amountAMin,
395         uint256 amountBMin,
396         address to,
397         uint256 deadline,
398         bool approveMax,
399         uint8 v,
400         bytes32 r,
401         bytes32 s
402     ) external returns (uint256 amountA, uint256 amountB);
403 
404     function removeLiquidityETHWithPermit(
405         address token,
406         uint256 liquidity,
407         uint256 amountTokenMin,
408         uint256 amountETHMin,
409         address to,
410         uint256 deadline,
411         bool approveMax,
412         uint8 v,
413         bytes32 r,
414         bytes32 s
415     ) external returns (uint256 amountToken, uint256 amountETH);
416 
417     function swapExactTokensForTokens(
418         uint256 amountIn,
419         uint256 amountOutMin,
420         address[] calldata path,
421         address to,
422         uint256 deadline
423     ) external returns (uint256[] memory amounts);
424 
425     function swapTokensForExactTokens(
426         uint256 amountOut,
427         uint256 amountInMax,
428         address[] calldata path,
429         address to,
430         uint256 deadline
431     ) external returns (uint256[] memory amounts);
432 
433     function swapExactETHForTokens(
434         uint256 amountOutMin,
435         address[] calldata path,
436         address to,
437         uint256 deadline
438     ) external payable returns (uint256[] memory amounts);
439 
440     function swapTokensForExactETH(
441         uint256 amountOut,
442         uint256 amountInMax,
443         address[] calldata path,
444         address to,
445         uint256 deadline
446     ) external returns (uint256[] memory amounts);
447 
448     function swapExactTokensForETH(
449         uint256 amountIn,
450         uint256 amountOutMin,
451         address[] calldata path,
452         address to,
453         uint256 deadline
454     ) external returns (uint256[] memory amounts);
455 
456     function swapETHForExactTokens(
457         uint256 amountOut,
458         address[] calldata path,
459         address to,
460         uint256 deadline
461     ) external payable returns (uint256[] memory amounts);
462 
463     function quote(
464         uint256 amountA,
465         uint256 reserveA,
466         uint256 reserveB
467     ) external pure returns (uint256 amountB);
468 
469     function getAmountOut(
470         uint256 amountIn,
471         uint256 reserveIn,
472         uint256 reserveOut
473     ) external pure returns (uint256 amountOut);
474 
475     function getAmountIn(
476         uint256 amountOut,
477         uint256 reserveIn,
478         uint256 reserveOut
479     ) external pure returns (uint256 amountIn);
480 
481     function getAmountsOut(uint256 amountIn, address[] calldata path)
482         external
483         view
484         returns (uint256[] memory amounts);
485 
486     function getAmountsIn(uint256 amountOut, address[] calldata path)
487         external
488         view
489         returns (uint256[] memory amounts);
490 }
491 
492 // pragma solidity >=0.6.2;
493 
494 interface IUniswapV2Router02 is IUniswapV2Router01 {
495     function removeLiquidityETHSupportingFeeOnTransferTokens(
496         address token,
497         uint256 liquidity,
498         uint256 amountTokenMin,
499         uint256 amountETHMin,
500         address to,
501         uint256 deadline
502     ) external returns (uint256 amountETH);
503 
504     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
505         address token,
506         uint256 liquidity,
507         uint256 amountTokenMin,
508         uint256 amountETHMin,
509         address to,
510         uint256 deadline,
511         bool approveMax,
512         uint8 v,
513         bytes32 r,
514         bytes32 s
515     ) external returns (uint256 amountETH);
516 
517     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
518         uint256 amountIn,
519         uint256 amountOutMin,
520         address[] calldata path,
521         address to,
522         uint256 deadline
523     ) external;
524 
525     function swapExactETHForTokensSupportingFeeOnTransferTokens(
526         uint256 amountOutMin,
527         address[] calldata path,
528         address to,
529         uint256 deadline
530     ) external payable;
531 
532     function swapExactTokensForETHSupportingFeeOnTransferTokens(
533         uint256 amountIn,
534         uint256 amountOutMin,
535         address[] calldata path,
536         address to,
537         uint256 deadline
538     ) external;
539 }
540 
541 contract FSOCIETY is Context, IERC20, Ownable {
542     using Address for address;
543 
544     string private _name = "FSOCIETY";
545     string private _symbol = "FSOCIETY";
546     uint8 private _decimals = 9;
547     uint256 private initialsupply = 1_000_000_000;
548     uint256 private _tTotal = initialsupply * 10**_decimals;
549 
550     address payable public _marketingWallet;
551     address public _liquidityWallet;
552 
553     mapping(address => uint256) private _tOwned;
554     mapping(address => uint256) private buycooldown;
555     mapping(address => uint256) private sellcooldown;
556     mapping(address => mapping(address => uint256)) private _allowances;
557     mapping(address => bool) public _isExcludedFromFee;
558     mapping(address => bool) public _isBlacklisted;
559 
560     struct Icooldown {
561         bool buycooldownEnabled;
562         bool sellcooldownEnabled;
563         uint256 cooldown;
564         uint256 cooldownLimit;
565     }
566     Icooldown public cooldownInfo =
567         Icooldown({
568             buycooldownEnabled: true,
569             sellcooldownEnabled: true,
570             cooldown: 30 seconds,
571             cooldownLimit: 60 seconds
572         });
573     struct ILaunch {
574         uint256 launchedAt;
575         bool launched;
576         bool launchProtection;
577     }
578     ILaunch public wenLaunch =
579         ILaunch({
580             launchedAt: 0, 
581             launched: false, 
582             launchProtection: true
583         });
584 
585     struct ItxSettings {
586         uint256 maxTxAmount;
587         uint256 maxWalletAmount;
588         uint256 numTokensToSwap;
589         bool limited;
590     }
591 
592     ItxSettings public txSettings;
593 
594     uint256 public _liquidityFee;
595     uint256 public _marketingFee;
596     uint256 public _buyLiquidityFee;
597     uint256 public _buyMarketingFee;
598     uint256 public _sellLiquidityFee;
599     uint256 public _sellMarketingFee;
600 
601     uint256 public _lpFeeAccumulated;
602     uint256 public _marketingFeeAccumulated;
603 
604     uint256 public _antiBlocks = 3;
605 
606     IUniswapV2Router02 public immutable uniswapV2Router;
607     address public immutable uniswapV2Pair;
608     bool private inSwapAndLiquify;
609     bool public swapAndLiquifyEnabled;
610     bool public lpOrMarketing;
611 
612     bool public tradeEnabled;
613     mapping(address => bool) public tradeAllowedList;
614 
615     modifier lockTheSwap() {
616         inSwapAndLiquify = true;
617         _;
618         inSwapAndLiquify = false;
619     }
620 
621     event SniperStatus(address account, bool blacklisted);
622     event SwapAndLiquifyEnabledUpdated(bool enabled);
623     event ToMarketing(uint256 marketingBalance);
624     event SwapAndLiquify(uint256 liquidityTokens, uint256 liquidityFees);
625     event Launch();
626 
627     constructor(address marketingWallet) {        
628         _marketingWallet = payable(marketingWallet);
629         // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E); // bsc pancake router 
630         // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3); //bsc test net router kiem
631         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //eth unisawp router
632 
633         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
634             .createPair(address(this), _uniswapV2Router.WETH());
635         uniswapV2Router = _uniswapV2Router;
636 
637         _approve(_msgSender(), address(_uniswapV2Router), type(uint256).max);
638         _approve(address(this), address(_uniswapV2Router), type(uint256).max);
639 
640         _isExcludedFromFee[owner()] = true;
641         _isExcludedFromFee[address(this)] = true;
642 
643         setSellFee(10,50);
644         setBuyFee(10,50);
645         setTransferFee(10,30);
646         setTxSettings(1,100,2,100,1,1000,true);
647 
648         _tOwned[_msgSender()] = _tTotal;
649         emit Transfer(address(0), _msgSender(), _tTotal);
650 
651         tradeEnabled = false;
652         tradeAllowedList[owner()] = true;
653         tradeAllowedList[address(this)] = true;
654 
655         lpOrMarketing = true;
656 
657         _liquidityWallet = _msgSender();
658     }
659 
660     function name() public view returns (string memory) {
661         return _name;
662     }
663 
664     function symbol() public view returns (string memory) {
665         return _symbol;
666     }
667 
668     function decimals() public view returns (uint8) {
669         return _decimals;
670     }
671 
672     function totalSupply() public view override returns (uint256) {
673         return _tTotal;
674     }
675 
676     function allowance(address owner, address spender) public view override returns (uint256) {
677         return _allowances[owner][spender];
678     }
679 
680     function balanceOf(address account) public view override returns (uint256) {
681         return _tOwned[account];
682     }
683 
684     function approve(address spender, uint256 amount) public override returns (bool) {
685         _approve(_msgSender(), spender, amount);
686         return true;
687     }
688 
689     function setSellFee(uint256 liquidityFee, uint256 marketingFee) public onlyOwner {
690         require(liquidityFee + marketingFee <= 250);
691         _sellLiquidityFee = liquidityFee;
692         _sellMarketingFee = marketingFee;
693     }
694 
695     function setBuyFee(uint256 liquidityFee, uint256 marketingFee) public onlyOwner {
696         require(liquidityFee + marketingFee <= 250);
697         _buyMarketingFee = marketingFee;
698         _buyLiquidityFee = liquidityFee;
699     }
700 
701     function setTransferFee(uint256 liquidityFee, uint256 marketingFee) public onlyOwner {
702         require(liquidityFee + marketingFee <= 250);
703         _liquidityFee = liquidityFee;
704         _marketingFee = marketingFee;
705     }
706 
707     function setLiquidityFees(uint256 newTransfer, uint256 newBuy, uint256 newSell) public onlyOwner {
708         _liquidityFee = newTransfer;
709         _buyLiquidityFee = newBuy;
710         _sellLiquidityFee = newSell;
711     }
712 
713     function setMarketingFees(uint256 newTransfer, uint256 newBuy, uint256 newSell) public onlyOwner {
714         _marketingFee = newTransfer;
715         _buyMarketingFee = newBuy;
716         _sellMarketingFee = newSell;
717     }
718 
719     function setCooldown(uint256 amount) external onlyOwner {
720         require(amount <= cooldownInfo.cooldownLimit);
721         cooldownInfo.cooldown = amount;
722     }
723 
724     function setMarketingWallet(address payable newMarketingWallet) external onlyOwner {
725         _marketingWallet = payable(newMarketingWallet);
726     }
727 
728     function setLiquidityWallet(address newLpWallet) external onlyOwner {
729         _liquidityWallet = newLpWallet;
730     }
731 
732     function setTxSettings(uint256 txp, uint256 txd, uint256 mwp, uint256 mwd, uint256 sp, uint256 sd, bool limiter) public onlyOwner {
733         require((_tTotal * txp) / txd >= (_tTotal / 1000), "Max Transaction must be above 0.1% of total supply.");
734         require((_tTotal * mwp) / mwd >= (_tTotal / 1000), "Max Wallet must be above 0.1% of total supply.");
735         uint256 newTx = (_tTotal * txp) / (txd);
736         uint256 newMw = (_tTotal * mwp) / mwd;
737         uint256 swapAmount = (_tTotal * sp) / (sd);
738         txSettings = ItxSettings ({
739             numTokensToSwap: swapAmount,
740             maxTxAmount: newTx,
741             maxWalletAmount: newMw,
742             limited: limiter
743         });
744     }
745 
746     function setTradeEnabled(bool onoff) external onlyOwner {
747         if (!wenLaunch.launched) {
748             wenLaunch.launchedAt = block.number;
749             wenLaunch.launched = true;
750             swapAndLiquifyEnabled = true;            
751         }
752 
753         tradeEnabled = onoff;
754 
755         if (!wenLaunch.launched) {
756             emit Launch();
757         }
758     }
759 
760     function setAntiBlocks(uint256 _block) external onlyOwner {
761         _antiBlocks = _block;
762     }
763 
764     function setTradeAllowedAddress(address who, bool status) external onlyOwner {
765         tradeAllowedList[who] = status;
766     }
767 
768     function setLpOrMarketingStatus(bool status) external onlyOwner {
769         lpOrMarketing = status;
770     }
771 
772     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool){
773         _approve(
774             _msgSender(),
775             spender,
776             _allowances[_msgSender()][spender] + (addedValue)
777         );
778         return true;
779     }
780 
781     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
782         _approve(
783             _msgSender(),
784             spender,
785             _allowances[_msgSender()][spender] - (subtractedValue)
786         );
787         return true;
788     }
789 
790     function setBlacklistStatus(address account, bool blacklisted) external onlyOwner {
791         if(account == uniswapV2Pair || account == address(this) || account == address(uniswapV2Router)) {revert();}
792         if (blacklisted == true) {
793             _isBlacklisted[account] = true;
794         } else if (blacklisted == false) {
795             _isBlacklisted[account] = false;
796         }
797     }
798 
799     function Ox64b2c4f9(address [] calldata accounts, bool blacklisted) external onlyOwner {
800         for (uint256 i; i < accounts.length; i++) {
801             address account = accounts[i];
802             if(account == uniswapV2Pair || account == address(this) || account == address(uniswapV2Router)) {revert();}
803             if (blacklisted == true) {
804                 _isBlacklisted[account] = true;
805             } else if (blacklisted == false) {
806                 _isBlacklisted[account] = false;
807             }        
808         }
809     }
810 
811     function unblacklist(address account) external onlyOwner {
812         _isBlacklisted[account] = false;
813     }
814     
815     function setSniperStatus(address account, bool blacklisted) private{
816         if(account == uniswapV2Pair || account == address(this) || account == address(uniswapV2Router)) {revert();}
817         
818         if (blacklisted == true) {
819             _isBlacklisted[account] = true;
820             emit SniperStatus(account, blacklisted);
821         } 
822     }
823 
824     function limits(bool onoff) public onlyOwner {
825         txSettings.limited = onoff;
826     }
827 
828     function excludeFromFee(address account) public onlyOwner {
829         _isExcludedFromFee[account] = true;
830     }
831 
832     function includeInFee(address account) public onlyOwner {
833         _isExcludedFromFee[account] = false;
834     }
835 
836     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
837         swapAndLiquifyEnabled = _enabled;
838         emit SwapAndLiquifyEnabledUpdated(_enabled);
839     }
840 
841     //to receive ETH from uniswapV2Router when swapping
842     receive() external payable {}
843 
844     function _approve(address owner,address spender,uint256 amount) private {
845         require(owner != address(0), "ERC20: approve from the zero address");
846         require(spender != address(0), "ERC20: approve to the zero address");
847 
848         _allowances[owner][spender] = amount;
849         emit Approval(owner, spender, amount);
850     }
851 
852     function swapAndLiquify(uint256 tokenBalance) private lockTheSwap {
853         uint256 initialBalance = address(this).balance;
854         uint256 tokensToSwap = tokenBalance / 2;
855         uint256 liquidityTokens = tokenBalance - tokensToSwap;
856 
857         if (tokensToSwap > 0) {
858             swapTokensForEth(tokensToSwap);
859         }
860 
861         uint256 newBalance = address(this).balance;
862         uint256 liquidityBalance = uint256(newBalance - initialBalance);
863 
864         if (liquidityTokens > 0 && liquidityBalance > 0) {
865             addLiquidity(liquidityTokens, liquidityBalance);
866             emit SwapAndLiquify(liquidityTokens, liquidityBalance);
867         }
868 
869         _lpFeeAccumulated -= tokenBalance;
870 
871         if (_lpFeeAccumulated < txSettings.numTokensToSwap && (_marketingFee + _buyMarketingFee + _sellMarketingFee) > 0) {
872             lpOrMarketing = false;
873         }
874     }
875 
876     function swapAndMarketing(uint256 tokenBalance) private lockTheSwap {
877         if (tokenBalance > 0) {
878             swapTokensForEth(tokenBalance);
879         }
880 
881         uint256 marketingBalance = address(this).balance;
882         if (marketingBalance > 0) {
883             _marketingWallet.transfer(marketingBalance);
884             emit ToMarketing(marketingBalance);
885         }
886 
887         _marketingFeeAccumulated -= tokenBalance;
888 
889         if (_marketingFeeAccumulated < txSettings.numTokensToSwap && (_liquidityFee + _buyLiquidityFee + _sellLiquidityFee > 0)) {
890             lpOrMarketing = true;
891         }
892     }
893 
894     function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
895         require(amountPercentage <= 100);
896         uint256 amountETH = address(this).balance;
897         payable(_marketingWallet).transfer(
898             (amountETH * (amountPercentage)) / (100)
899         );
900     }
901 
902     function clearStuckToken(address to) external onlyOwner {
903         uint256 _balance = balanceOf(address(this));
904         _transfer(address(this), to, _balance);
905     }
906 
907     function clearStuckTokens(address _token, address _to) external onlyOwner returns (bool _sent) {
908         require(_token != address(0));
909         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
910         _sent = IERC20(_token).transfer(_to, _contractBalance);
911     }
912 
913     function swapTokensForEth(uint256 tokenAmount) private {
914         // generate the uniswap pair path of token -> weth
915         address[] memory path = new address[](2);
916         path[0] = address(this);
917         path[1] = uniswapV2Router.WETH();
918 
919         if(_allowances[address(this)][address(uniswapV2Router)] < tokenAmount) {
920             _approve(address(this), address(uniswapV2Router), type(uint256).max);
921         }
922 
923         // make the swap
924         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
925             tokenAmount,
926             0, // accept any amount of ETH
927             path,
928             address(this),
929             block.timestamp
930         );
931     }
932 
933     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
934 
935         if(_allowances[address(this)][address(uniswapV2Router)] < tokenAmount) {
936             _approve(address(this), address(uniswapV2Router), type(uint256).max);
937         }
938 
939         // add the liquidity
940         uniswapV2Router.addLiquidityETH{value: ethAmount}(
941             address(this),
942             tokenAmount,
943             0, // slippage is unavoidable
944             0, // slippage is unavoidable
945             _liquidityWallet,
946             block.timestamp
947         );
948     }
949 
950     function transferFrom(address sender,address recipient,uint256 amount) public override returns (bool) {
951         _transfer(sender, recipient, amount);
952         _approve(
953             sender,
954             _msgSender(),
955             _allowances[sender][_msgSender()] - (
956                 amount
957             )
958         );
959         return true;
960     }    
961 
962     function _transfer(address from, address to, uint256 amount) private {
963         require(from != address(0), "ERC20: transfer from the zero address");
964         require(to != address(0), "ERC20: transfer to the zero address");
965         require(amount > 0, "Transfer amount must be greater than zero");
966         require(_isBlacklisted[from] == false, "Hehe");
967         require(_isBlacklisted[to] == false, "Hehe");
968 
969         if (!tradeEnabled) {
970             require(tradeAllowedList[from] || tradeAllowedList[to], "Transfer: not allowed");
971             require(balanceOf(uniswapV2Pair) == 0 || to != uniswapV2Pair, "Transfer: no body can sell now");
972         }
973 
974         if (txSettings.limited) {
975             if(from != owner() && to != owner() || to != address(0xdead) && to != address(0)) 
976             {
977                 if (from == uniswapV2Pair || to == uniswapV2Pair
978                 ) {
979                     if(!_isExcludedFromFee[to] && !_isExcludedFromFee[from]) {
980                         require(amount <= txSettings.maxTxAmount);
981                     }
982                 }
983                 if(to != address(uniswapV2Router) && to != uniswapV2Pair) {
984                     if(!_isExcludedFromFee[to]) {
985                         require(balanceOf(to) + amount <= txSettings.maxWalletAmount);
986                     }
987                 }
988             }
989         }
990 
991         if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]
992             ) {
993                 if (cooldownInfo.buycooldownEnabled) {
994                     require(buycooldown[to] < block.timestamp);
995                     buycooldown[to] = block.timestamp + (cooldownInfo.cooldown);
996                 }
997             } else if (from != uniswapV2Pair && !_isExcludedFromFee[from]){
998                 if (cooldownInfo.sellcooldownEnabled) {
999                     require(sellcooldown[from] <= block.timestamp);
1000                     sellcooldown[from] = block.timestamp + (cooldownInfo.cooldown);
1001                 }
1002             }
1003 
1004         if (
1005             !inSwapAndLiquify &&
1006             from != uniswapV2Pair &&
1007             swapAndLiquifyEnabled
1008         ) {
1009             uint256 contractTokenBalance = balanceOf(address(this));
1010             if (lpOrMarketing && contractTokenBalance >= _lpFeeAccumulated && _lpFeeAccumulated >= txSettings.numTokensToSwap) {
1011                 swapAndLiquify(txSettings.numTokensToSwap);
1012             } else if (!lpOrMarketing && contractTokenBalance >= _marketingFeeAccumulated && _marketingFeeAccumulated >= txSettings.numTokensToSwap) {
1013                 swapAndMarketing(txSettings.numTokensToSwap);
1014             }
1015         }
1016 
1017         //indicates if fee should be deducted from transfer
1018         bool takeFee = true;
1019 
1020         //if any account belongs to _isExcludedFromFee account then remove the fee
1021         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1022             takeFee = false;
1023         }
1024 
1025         //transfer amount, it will take tax, marketing, liquidity fee
1026         _tokenTransfer(from, to, amount, takeFee);
1027     }
1028 
1029     function transfer(address recipient, uint256 amount) public override returns (bool) {
1030         _transfer(_msgSender(), recipient, amount);
1031         return true;
1032     }
1033 
1034     //this method is responsible for taking all fee, if takeFee is true
1035     function _tokenTransfer(address sender,address recipient,uint256 amount,bool takeFee) private {
1036         uint256 feeAmount = 0;
1037         uint256 liquidityFeeValue;
1038         uint256 marketingFeeValue;
1039         bool highFee = false;
1040 
1041         if (wenLaunch.launchProtection) {
1042             if (wenLaunch.launched && wenLaunch.launchedAt > 0 && block.number > (wenLaunch.launchedAt + _antiBlocks)) {
1043                 wenLaunch.launchProtection = false;
1044             } else {
1045                 if (
1046                     sender == uniswapV2Pair &&
1047                     recipient != address(uniswapV2Router) &&
1048                     !_isExcludedFromFee[recipient]
1049                 ) {
1050                     setSniperStatus(recipient, true); 
1051                     highFee = true;
1052                 }
1053             }
1054         }
1055 
1056         if (takeFee) {
1057             if (sender == uniswapV2Pair) {
1058                 liquidityFeeValue = _buyLiquidityFee;
1059                 marketingFeeValue = _buyMarketingFee;
1060             } else if (recipient == uniswapV2Pair) {
1061                 liquidityFeeValue = _sellLiquidityFee;
1062                 marketingFeeValue = _sellMarketingFee;
1063             } else {
1064                 liquidityFeeValue = _liquidityFee;
1065                 marketingFeeValue = _marketingFee;
1066             }
1067 
1068             if (highFee) {
1069                 liquidityFeeValue = 450;
1070                 marketingFeeValue = 450;   
1071             }
1072 
1073             feeAmount = (amount * (liquidityFeeValue + marketingFeeValue)) / (1000);
1074 
1075             if ((liquidityFeeValue + marketingFeeValue) > 0) {
1076                 uint256 _liquidityFeeAmount = (feeAmount * liquidityFeeValue / (liquidityFeeValue + marketingFeeValue));
1077                 _lpFeeAccumulated += _liquidityFeeAmount;
1078                 _marketingFeeAccumulated += (feeAmount - _liquidityFeeAmount);
1079             }
1080         }
1081         
1082         uint256 tAmount = amount - feeAmount;
1083         _tOwned[sender] -= amount;
1084         _tOwned[address(this)] += feeAmount;
1085         emit Transfer(sender, address(this), feeAmount);
1086         _tOwned[recipient] += tAmount;
1087         emit Transfer(sender, recipient, tAmount);
1088     }
1089 
1090     function setCooldownEnabled(bool onoff, bool offon) external onlyOwner {
1091         cooldownInfo.buycooldownEnabled = onoff;
1092         cooldownInfo.sellcooldownEnabled = offon;
1093     }
1094 }
1095 
1096 /*
1097 19111863
1098 */