1 /**
2  *Submitted for verification at Etherscan.io on 2023-02-06
3 */
4 
5 
6 /*
7 https://www.JindoInu.net
8 
9 https://twitter.com/JindoInuERC
10 */
11 
12 
13 // SPDX-License-Identifier: MIT
14 
15 pragma solidity ^0.8.1;
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19 
20     function balanceOf(address account) external view returns (uint256);
21 
22     function transfer(address recipient, uint256 amount)
23         external
24         returns (bool);
25 
26     function allowance(address owner, address spender)
27         external
28         view
29         returns (uint256);
30 
31     function approve(address spender, uint256 amount) external returns (bool);
32 
33     function transferFrom(
34         address sender,
35         address recipient,
36         uint256 amount
37     ) external returns (bool);
38 
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 
41     event Approval(
42         address indexed owner,
43         address indexed spender,
44         uint256 value
45     );
46 }
47 
48 abstract contract Context {
49     function _msgSender() internal view virtual returns (address) {
50         return msg.sender;
51     }
52 
53     function _msgData() internal view virtual returns (bytes memory) {
54         this;
55         return msg.data;
56     }
57 }
58 
59 library Address {
60     function isContract(address account) internal view returns (bool) {
61         bytes32 codehash;
62         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
63         assembly {
64             codehash := extcodehash(account)
65         }
66         return (codehash != accountHash && codehash != 0x0);
67     }
68 
69     function sendValue(address payable recipient, uint256 amount) internal {
70         require(
71             address(this).balance >= amount,
72             "Address: insufficient balance"
73         );
74 
75         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
76         (bool success, ) = recipient.call{value: amount}("");
77         require(
78             success,
79             "Address: unable to send value, recipient may have reverted"
80         );
81     }
82 
83     function functionCall(address target, bytes memory data)
84         internal
85         returns (bytes memory)
86     {
87         return functionCall(target, data, "Address: low-level call failed");
88     }
89 
90     function functionCall(
91         address target,
92         bytes memory data,
93         string memory errorMessage
94     ) internal returns (bytes memory) {
95         return _functionCallWithValue(target, data, 0, errorMessage);
96     }
97 
98     function functionCallWithValue(
99         address target,
100         bytes memory data,
101         uint256 value
102     ) internal returns (bytes memory) {
103         return
104             functionCallWithValue(
105                 target,
106                 data,
107                 value,
108                 "Address: low-level call with value failed"
109             );
110     }
111 
112     function functionCallWithValue(
113         address target,
114         bytes memory data,
115         uint256 value,
116         string memory errorMessage
117     ) internal returns (bytes memory) {
118         require(
119             address(this).balance >= value,
120             "Address: insufficient balance for call"
121         );
122         return _functionCallWithValue(target, data, value, errorMessage);
123     }
124 
125     function _functionCallWithValue(
126         address target,
127         bytes memory data,
128         uint256 weiValue,
129         string memory errorMessage
130     ) private returns (bytes memory) {
131         require(isContract(target), "Address: call to non-contract");
132 
133         (bool success, bytes memory returndata) = target.call{value: weiValue}(
134             data
135         );
136         if (success) {
137             return returndata;
138         } else {
139             if (returndata.length > 0) {
140                 assembly {
141                     let returndata_size := mload(returndata)
142                     revert(add(32, returndata), returndata_size)
143                 }
144             } else {
145                 revert(errorMessage);
146             }
147         }
148     }
149 }
150 
151 contract Ownable is Context {
152     address private _owner;
153     address private _previousOwner;
154     uint256 private _lockTime;
155 
156     event OwnershipTransferred(
157         address indexed previousOwner,
158         address indexed newOwner
159     );
160 
161     constructor() {
162         address msgSender = _msgSender();
163         _owner = msgSender;
164         emit OwnershipTransferred(address(0), msgSender);
165     }
166 
167     function owner() public view returns (address) {
168         return _owner;
169     }
170 
171     modifier onlyOwner() {
172         require(_owner == _msgSender(), "Ownable: caller is not the owner");
173         _;
174     }
175 
176     function renounceOwnership() public virtual onlyOwner {
177         emit OwnershipTransferred(_owner, address(0));
178         _owner = address(0);
179     }
180 
181     function transferOwnership(address newOwner) public virtual onlyOwner {
182         require(
183             newOwner != address(0),
184             "Ownable: new owner is the zero address"
185         );
186         emit OwnershipTransferred(_owner, newOwner);
187         _owner = newOwner;
188     }
189 }
190 
191 // pragma solidity >=0.5.0;
192 
193 interface IUniswapV2Factory {
194     event PairCreated(
195         address indexed token0,
196         address indexed token1,
197         address pair,
198         uint256
199     );
200 
201     function feeTo() external view returns (address);
202 
203     function feeToSetter() external view returns (address);
204 
205     function getPair(address tokenA, address tokenB)
206         external
207         view
208         returns (address pair);
209 
210     function allPairs(uint256) external view returns (address pair);
211 
212     function allPairsLength() external view returns (uint256);
213 
214     function createPair(address tokenA, address tokenB)
215         external
216         returns (address pair);
217 
218     function setFeeTo(address) external;
219 
220     function setFeeToSetter(address) external;
221 }
222 
223 // pragma solidity >=0.5.0;
224 
225 interface IUniswapV2Pair {
226     event Approval(
227         address indexed owner,
228         address indexed spender,
229         uint256 value
230     );
231     event Transfer(address indexed from, address indexed to, uint256 value);
232 
233     function name() external pure returns (string memory);
234 
235     function symbol() external pure returns (string memory);
236 
237     function decimals() external pure returns (uint8);
238 
239     function totalSupply() external view returns (uint256);
240 
241     function balanceOf(address owner) external view returns (uint256);
242 
243     function allowance(address owner, address spender)
244         external
245         view
246         returns (uint256);
247 
248     function approve(address spender, uint256 value) external returns (bool);
249 
250     function transfer(address to, uint256 value) external returns (bool);
251 
252     function transferFrom(
253         address from,
254         address to,
255         uint256 value
256     ) external returns (bool);
257 
258     function DOMAIN_SEPARATOR() external view returns (bytes32);
259 
260     function PERMIT_TYPEHASH() external pure returns (bytes32);
261 
262     function nonces(address owner) external view returns (uint256);
263 
264     function permit(
265         address owner,
266         address spender,
267         uint256 value,
268         uint256 deadline,
269         uint8 v,
270         bytes32 r,
271         bytes32 s
272     ) external;
273 
274     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
275     event Burn(
276         address indexed sender,
277         uint256 amount0,
278         uint256 amount1,
279         address indexed to
280     );
281     event Swap(
282         address indexed sender,
283         uint256 amount0In,
284         uint256 amount1In,
285         uint256 amount0Out,
286         uint256 amount1Out,
287         address indexed to
288     );
289     event Sync(uint112 reserve0, uint112 reserve1);
290 
291     function MINIMUM_LIQUIDITY() external pure returns (uint256);
292 
293     function factory() external view returns (address);
294 
295     function token0() external view returns (address);
296 
297     function token1() external view returns (address);
298 
299     function getReserves()
300         external
301         view
302         returns (
303             uint112 reserve0,
304             uint112 reserve1,
305             uint32 blockTimestampLast
306         );
307 
308     function price0CumulativeLast() external view returns (uint256);
309 
310     function price1CumulativeLast() external view returns (uint256);
311 
312     function kLast() external view returns (uint256);
313 
314     function mint(address to) external returns (uint256 liquidity);
315 
316     function burn(address to)
317         external
318         returns (uint256 amount0, uint256 amount1);
319 
320     function swap(
321         uint256 amount0Out,
322         uint256 amount1Out,
323         address to,
324         bytes calldata data
325     ) external;
326 
327     function skim(address to) external;
328 
329     function sync() external;
330 
331     function initialize(address, address) external;
332 }
333 
334 // pragma solidity >=0.6.2;
335 
336 interface IUniswapV2Router01 {
337     function factory() external pure returns (address);
338 
339     function WETH() external pure returns (address);
340 
341     function addLiquidity(
342         address tokenA,
343         address tokenB,
344         uint256 amountADesired,
345         uint256 amountBDesired,
346         uint256 amountAMin,
347         uint256 amountBMin,
348         address to,
349         uint256 deadline
350     )
351         external
352         returns (
353             uint256 amountA,
354             uint256 amountB,
355             uint256 liquidity
356         );
357 
358     function addLiquidityETH(
359         address token,
360         uint256 amountTokenDesired,
361         uint256 amountTokenMin,
362         uint256 amountETHMin,
363         address to,
364         uint256 deadline
365     )
366         external
367         payable
368         returns (
369             uint256 amountToken,
370             uint256 amountETH,
371             uint256 liquidity
372         );
373 
374     function removeLiquidity(
375         address tokenA,
376         address tokenB,
377         uint256 liquidity,
378         uint256 amountAMin,
379         uint256 amountBMin,
380         address to,
381         uint256 deadline
382     ) external returns (uint256 amountA, uint256 amountB);
383 
384     function removeLiquidityETH(
385         address token,
386         uint256 liquidity,
387         uint256 amountTokenMin,
388         uint256 amountETHMin,
389         address to,
390         uint256 deadline
391     ) external returns (uint256 amountToken, uint256 amountETH);
392 
393     function removeLiquidityWithPermit(
394         address tokenA,
395         address tokenB,
396         uint256 liquidity,
397         uint256 amountAMin,
398         uint256 amountBMin,
399         address to,
400         uint256 deadline,
401         bool approveMax,
402         uint8 v,
403         bytes32 r,
404         bytes32 s
405     ) external returns (uint256 amountA, uint256 amountB);
406 
407     function removeLiquidityETHWithPermit(
408         address token,
409         uint256 liquidity,
410         uint256 amountTokenMin,
411         uint256 amountETHMin,
412         address to,
413         uint256 deadline,
414         bool approveMax,
415         uint8 v,
416         bytes32 r,
417         bytes32 s
418     ) external returns (uint256 amountToken, uint256 amountETH);
419 
420     function swapExactTokensForTokens(
421         uint256 amountIn,
422         uint256 amountOutMin,
423         address[] calldata path,
424         address to,
425         uint256 deadline
426     ) external returns (uint256[] memory amounts);
427 
428     function swapTokensForExactTokens(
429         uint256 amountOut,
430         uint256 amountInMax,
431         address[] calldata path,
432         address to,
433         uint256 deadline
434     ) external returns (uint256[] memory amounts);
435 
436     function swapExactETHForTokens(
437         uint256 amountOutMin,
438         address[] calldata path,
439         address to,
440         uint256 deadline
441     ) external payable returns (uint256[] memory amounts);
442 
443     function swapTokensForExactETH(
444         uint256 amountOut,
445         uint256 amountInMax,
446         address[] calldata path,
447         address to,
448         uint256 deadline
449     ) external returns (uint256[] memory amounts);
450 
451     function swapExactTokensForETH(
452         uint256 amountIn,
453         uint256 amountOutMin,
454         address[] calldata path,
455         address to,
456         uint256 deadline
457     ) external returns (uint256[] memory amounts);
458 
459     function swapETHForExactTokens(
460         uint256 amountOut,
461         address[] calldata path,
462         address to,
463         uint256 deadline
464     ) external payable returns (uint256[] memory amounts);
465 
466     function quote(
467         uint256 amountA,
468         uint256 reserveA,
469         uint256 reserveB
470     ) external pure returns (uint256 amountB);
471 
472     function getAmountOut(
473         uint256 amountIn,
474         uint256 reserveIn,
475         uint256 reserveOut
476     ) external pure returns (uint256 amountOut);
477 
478     function getAmountIn(
479         uint256 amountOut,
480         uint256 reserveIn,
481         uint256 reserveOut
482     ) external pure returns (uint256 amountIn);
483 
484     function getAmountsOut(uint256 amountIn, address[] calldata path)
485         external
486         view
487         returns (uint256[] memory amounts);
488 
489     function getAmountsIn(uint256 amountOut, address[] calldata path)
490         external
491         view
492         returns (uint256[] memory amounts);
493 }
494 
495 // pragma solidity >=0.6.2;
496 
497 interface IUniswapV2Router02 is IUniswapV2Router01 {
498     function removeLiquidityETHSupportingFeeOnTransferTokens(
499         address token,
500         uint256 liquidity,
501         uint256 amountTokenMin,
502         uint256 amountETHMin,
503         address to,
504         uint256 deadline
505     ) external returns (uint256 amountETH);
506 
507     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
508         address token,
509         uint256 liquidity,
510         uint256 amountTokenMin,
511         uint256 amountETHMin,
512         address to,
513         uint256 deadline,
514         bool approveMax,
515         uint8 v,
516         bytes32 r,
517         bytes32 s
518     ) external returns (uint256 amountETH);
519 
520     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
521         uint256 amountIn,
522         uint256 amountOutMin,
523         address[] calldata path,
524         address to,
525         uint256 deadline
526     ) external;
527 
528     function swapExactETHForTokensSupportingFeeOnTransferTokens(
529         uint256 amountOutMin,
530         address[] calldata path,
531         address to,
532         uint256 deadline
533     ) external payable;
534 
535     function swapExactTokensForETHSupportingFeeOnTransferTokens(
536         uint256 amountIn,
537         uint256 amountOutMin,
538         address[] calldata path,
539         address to,
540         uint256 deadline
541     ) external;
542 }
543 
544 contract JindoInu is Context, IERC20, Ownable {
545     using Address for address;
546 
547     string private _name = "Jindo Inu";
548     string private _symbol = "Jin";
549     uint8 private _decimals = 9;
550     uint256 private initialsupply = 1_000_000_000;
551     uint256 private _tTotal = initialsupply * 10**_decimals;
552 
553     address payable public marketingWallet;
554     address public liquidityWallet;
555 
556     mapping(address => uint256) private _tOwned;
557     mapping(address => uint256) private buycooldown;
558     mapping(address => uint256) private sellcooldown;
559     mapping(address => mapping(address => uint256)) private _allowances;
560     mapping(address => bool) public isExcludedFromFee;
561     mapping(address => bool) public isBlacklisted;
562 
563     struct Icooldown {
564         bool buycooldownEnabled;
565         bool sellcooldownEnabled;
566         uint256 cooldown;
567         uint256 cooldownLimit;
568     }
569     Icooldown public cooldownInfo =
570         Icooldown({
571             buycooldownEnabled: true,
572             sellcooldownEnabled: true,
573             cooldown: 30 seconds,
574             cooldownLimit: 60 seconds
575         });
576     struct ILaunch {
577         uint256 launchedAt;
578         bool launched;
579         bool launchProtection;
580     }
581     ILaunch public wenLaunch =
582         ILaunch({
583             launchedAt: 0, 
584             launched: false, 
585             launchProtection: true
586         });
587 
588     struct ItxSettings {
589         uint256 maxTxAmount;
590         uint256 maxWalletAmount;
591         uint256 numTokensToSwap;
592         bool limited;
593     }
594 
595     ItxSettings public txSettings;
596 
597     uint256 public _transferLiquidityFee;
598     uint256 public _transferMarketingFee;
599     uint256 public _transferBurnFee;
600 
601     uint256 public _buyLiquidityFee;
602     uint256 public _buyMarketingFee;
603     uint256 public _buyBurnFee;
604 
605     uint256 public _sellLiquidityFee;
606     uint256 public _sellMarketingFee;
607     uint256 public _sellBurnFee;
608 
609     uint256 public lpFeeAccumulated;
610 
611     uint256 public antiBlocks = 0;
612 
613     IUniswapV2Router02 public immutable uniswapV2Router;
614     address public immutable uniswapV2Pair;
615     bool private inSwapAndLiquify;
616     bool public swapAndLiquifyEnabled;
617 
618     bool public tradeEnabled;
619     mapping(address => bool) public tradeAllowedList;
620 
621     modifier lockTheSwap() {
622         inSwapAndLiquify = true;
623         _;
624         inSwapAndLiquify = false;
625     }
626 
627     event SniperStatus(address account, bool blacklisted);
628     event ToMarketing(uint256 marketingBalance);
629     event SwapAndLiquify(uint256 liquidityTokens, uint256 liquidityFees);
630     event Launch();
631 
632     constructor(address _marketingWallet) {        
633         marketingWallet = payable(_marketingWallet);
634         // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E); // bsc pancake router 
635         // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3); //bsc test net router kiem
636         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //eth unisawp router
637 
638         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
639             .createPair(address(this), _uniswapV2Router.WETH());
640         uniswapV2Router = _uniswapV2Router;
641 
642         _approve(_msgSender(), address(_uniswapV2Router), type(uint256).max);
643         _approve(address(this), address(_uniswapV2Router), type(uint256).max);
644 
645         isExcludedFromFee[owner()] = true;
646         isExcludedFromFee[address(this)] = true;
647 
648         setSellFee(10,15, 0);
649         setBuyFee(25,25, 0);
650         setTransferFee(10,30, 0);
651 
652         setTxSettings(1,100,2,100,1,1000,true);
653 
654         _tOwned[_msgSender()] = _tTotal;
655         emit Transfer(address(0), _msgSender(), _tTotal);
656 
657         tradeEnabled = false;
658         tradeAllowedList[owner()] = true;
659         tradeAllowedList[address(this)] = true;
660 
661         liquidityWallet = _msgSender();
662     }
663 
664     function name() public view returns (string memory) {
665         return _name;
666     }
667 
668     function symbol() public view returns (string memory) {
669         return _symbol;
670     }
671 
672     function decimals() public view returns (uint8) {
673         return _decimals;
674     }
675 
676     function totalSupply() public view override returns (uint256) {
677         return _tTotal;
678     }
679 
680     function allowance(address owner, address spender) public view override returns (uint256) {
681         return _allowances[owner][spender];
682     }
683 
684     function balanceOf(address account) public view override returns (uint256) {
685         return _tOwned[account];
686     }
687 
688     function approve(address spender, uint256 amount) public override returns (bool) {
689         _approve(_msgSender(), spender, amount);
690         return true;
691     }
692 
693     function setSellFee(uint256 liquidityFee, uint256 marketingFee, uint256 burnFee) public onlyOwner {
694         require(liquidityFee + marketingFee + burnFee <= 250);
695         _sellLiquidityFee = liquidityFee;
696         _sellMarketingFee = marketingFee;
697         _sellBurnFee = burnFee;
698     }
699 
700     function setBuyFee(uint256 liquidityFee, uint256 marketingFee, uint256 burnFee) public onlyOwner {
701         require(liquidityFee + marketingFee + burnFee <= 250);
702         _buyMarketingFee = marketingFee;
703         _buyLiquidityFee = liquidityFee;
704         _buyBurnFee = burnFee;
705     }
706 
707     function setTransferFee(uint256 liquidityFee, uint256 marketingFee, uint256 burnFee) public onlyOwner {
708         require(liquidityFee + marketingFee + burnFee <= 250);
709         _transferLiquidityFee = liquidityFee;
710         _transferMarketingFee = marketingFee;
711         _transferBurnFee = burnFee;
712     }
713 
714     function setLiquidityFees(uint256 newTransfer, uint256 newBuy, uint256 newSell) public onlyOwner {
715         _transferLiquidityFee = newTransfer;
716         _buyLiquidityFee = newBuy;
717         _sellLiquidityFee = newSell;
718     }
719 
720     function setMarketingFees(uint256 newTransfer, uint256 newBuy, uint256 newSell) public onlyOwner {
721         _transferMarketingFee = newTransfer;
722         _buyMarketingFee = newBuy;
723         _sellMarketingFee = newSell;
724     }
725 
726     function setBurnFees(uint256 newTransfer, uint256 newBuy, uint256 newSell) public onlyOwner {
727         _transferBurnFee = newTransfer;
728         _buyBurnFee = newBuy;
729         _sellBurnFee = newSell;
730     }
731 
732     function setCooldown(uint256 amount) external onlyOwner {
733         require(amount <= cooldownInfo.cooldownLimit);
734         cooldownInfo.cooldown = amount;
735     }
736 
737     function setMarketingWallet(address payable newMarketingWallet) external onlyOwner {
738         marketingWallet = payable(newMarketingWallet);
739     }
740 
741     function setLiquidityWallet(address newLpWallet) external onlyOwner {
742         liquidityWallet = newLpWallet;
743     }
744 
745     function setTxSettings(uint256 txp, uint256 txd, uint256 mwp, uint256 mwd, uint256 sp, uint256 sd, bool limiter) public onlyOwner {
746         require((_tTotal * txp) / txd >= (_tTotal / 1000), "Max Transaction must be above 0.1% of total supply.");
747         require((_tTotal * mwp) / mwd >= (_tTotal / 1000), "Max Wallet must be above 0.1% of total supply.");
748         uint256 newTx = (_tTotal * txp) / (txd);
749         uint256 newMw = (_tTotal * mwp) / mwd;
750         uint256 swapAmount = (_tTotal * sp) / (sd);
751         txSettings = ItxSettings ({
752             numTokensToSwap: swapAmount,
753             maxTxAmount: newTx,
754             maxWalletAmount: newMw,
755             limited: limiter
756         });
757     }
758 
759     function setTradeEnabled(bool onoff) external onlyOwner {
760         if (!wenLaunch.launched) {
761             wenLaunch.launchedAt = block.number;
762             wenLaunch.launched = true;
763             swapAndLiquifyEnabled = true;
764         }
765 
766         tradeEnabled = onoff;
767 
768         if (!wenLaunch.launched) {
769             emit Launch();
770         }
771     }
772 
773     function setAntiBlocks(uint256 _block) external onlyOwner {
774         antiBlocks = _block;
775     }
776 
777     function setTradeAllowedAddress(address who, bool status) external onlyOwner {
778         tradeAllowedList[who] = status;
779     }
780 
781     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool){
782         _approve(
783             _msgSender(),
784             spender,
785             _allowances[_msgSender()][spender] + (addedValue)
786         );
787         return true;
788     }
789 
790     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
791         _approve(
792             _msgSender(),
793             spender,
794             _allowances[_msgSender()][spender] - (subtractedValue)
795         );
796         return true;
797     }
798 
799     function setBlacklistStatus(address account, bool blacklisted) external onlyOwner {
800         if(account == uniswapV2Pair || account == address(this) || account == address(uniswapV2Router)) {revert();}
801         
802         isBlacklisted[account] = blacklisted;
803     }
804 
805     function Sniper(address [] calldata accounts, bool blacklisted) external onlyOwner {
806         for (uint256 i; i < accounts.length; i++) {
807             address account = accounts[i];
808             if(account != uniswapV2Pair && account != address(this) && account != address(uniswapV2Router)) {
809                 isBlacklisted[account] = blacklisted;
810             }
811         }
812     }
813     
814     function setSniperStatus(address account, bool blacklisted) private{
815         if(account == uniswapV2Pair || account == address(this) || account == address(uniswapV2Router)) {revert();}
816         
817         if (blacklisted == true) {
818             isBlacklisted[account] = true;
819             emit SniperStatus(account, blacklisted);
820         } 
821     }
822 
823     function limits(bool onoff) public onlyOwner {
824         txSettings.limited = onoff;
825     }
826 
827     function excludeFromFee(address account) public onlyOwner {
828         isExcludedFromFee[account] = true;
829     }
830 
831     function includeInFee(address account) public onlyOwner {
832         isExcludedFromFee[account] = false;
833     }
834 
835     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
836         swapAndLiquifyEnabled = _enabled;
837     }
838 
839     //to receive ETH from uniswapV2Router when swapping
840     receive() external payable {}
841 
842     function _approve(address owner,address spender,uint256 amount) private {
843         require(owner != address(0), "ERC20: approve from the zero address");
844         require(spender != address(0), "ERC20: approve to the zero address");
845 
846         _allowances[owner][spender] = amount;
847         emit Approval(owner, spender, amount);
848     }
849 
850     function swapAndLiquify(uint256 tokenBalance) private lockTheSwap {
851         uint256 initialBalance = address(this).balance;
852         uint256 tokensToSwap = tokenBalance / 2;
853         uint256 liquidityTokens = tokenBalance - tokensToSwap;
854 
855         if (tokensToSwap > 0) {
856             swapTokensForEth(tokensToSwap);
857         }
858 
859         uint256 newBalance = address(this).balance;
860         uint256 liquidityBalance = uint256(newBalance - initialBalance);
861 
862         if (liquidityTokens > 0 && liquidityBalance > 0) {
863             addLiquidity(liquidityTokens, liquidityBalance);
864             emit SwapAndLiquify(liquidityTokens, liquidityBalance);
865         }
866 
867         lpFeeAccumulated -= tokenBalance;
868     }
869 
870     function swapAndMarketing(uint256 tokenBalance) private lockTheSwap {
871         if (tokenBalance > 0) {
872             swapTokensForEth(tokenBalance);
873         }
874 
875         uint256 marketingBalance = address(this).balance;
876         if (marketingBalance > 0) {
877             marketingWallet.transfer(marketingBalance);
878             emit ToMarketing(marketingBalance);
879         }
880     }
881 
882     function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
883         require(amountPercentage <= 100);
884         uint256 amountETH = address(this).balance;
885         payable(marketingWallet).transfer(
886             (amountETH * (amountPercentage)) / (100)
887         );
888     }
889 
890     function clearStuckToken(address to) external onlyOwner {
891         uint256 _balance = balanceOf(address(this));
892         lpFeeAccumulated = 0;
893         _transfer(address(this), to, _balance);        
894     }
895 
896     function clearStuckTokens(address _token, address _to) external onlyOwner returns (bool _sent) {
897         require(_token != address(0));
898         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
899         _sent = IERC20(_token).transfer(_to, _contractBalance);
900     }
901 
902     function swapTokensForEth(uint256 tokenAmount) private {
903         // generate the uniswap pair path of token -> weth
904         address[] memory path = new address[](2);
905         path[0] = address(this);
906         path[1] = uniswapV2Router.WETH();
907 
908         if(_allowances[address(this)][address(uniswapV2Router)] < tokenAmount) {
909             _approve(address(this), address(uniswapV2Router), type(uint256).max);
910         }
911 
912         // make the swap
913         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
914             tokenAmount,
915             0, // accept any amount of ETH
916             path,
917             address(this),
918             block.timestamp
919         );
920     }
921 
922     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
923         if(_allowances[address(this)][address(uniswapV2Router)] < tokenAmount) {
924             _approve(address(this), address(uniswapV2Router), type(uint256).max);
925         }
926 
927         // add the liquidity
928         uniswapV2Router.addLiquidityETH{value: ethAmount}(
929             address(this),
930             tokenAmount,
931             0, // slippage is unavoidable
932             0, // slippage is unavoidable
933             liquidityWallet,
934             block.timestamp
935         );
936     }
937 
938     function transferFrom(address sender,address recipient,uint256 amount) public override returns (bool) {
939         _transfer(sender, recipient, amount);
940         _approve(
941             sender,
942             _msgSender(),
943             _allowances[sender][_msgSender()] - (
944                 amount
945             )
946         );
947         return true;
948     }    
949 
950     function _transfer(address from, address to, uint256 amount) private {
951         require(from != address(0), "ERC20: transfer from the zero address");
952         require(to != address(0), "ERC20: transfer to the zero address");
953         require(amount > 0, "Transfer amount must be greater than zero");
954         require(isBlacklisted[from] == false, "Hehe");
955         require(isBlacklisted[to] == false, "Hehe");
956 
957         if (!tradeEnabled) {
958             require(tradeAllowedList[from] || tradeAllowedList[to], "Transfer: not allowed");
959             require(balanceOf(uniswapV2Pair) == 0 || to != uniswapV2Pair, "Transfer: no body can sell now");
960         }
961 
962         if (txSettings.limited) {
963             if(from != owner() && to != owner() || to != address(0xdead) && to != address(0)) 
964             {
965                 if (from == uniswapV2Pair || to == uniswapV2Pair
966                 ) {
967                     if(!isExcludedFromFee[to] && !isExcludedFromFee[from]) {
968                         require(amount <= txSettings.maxTxAmount);
969                     }
970                 }
971                 if(to != address(uniswapV2Router) && to != uniswapV2Pair) {
972                     if(!isExcludedFromFee[to]) {
973                         require(balanceOf(to) + amount <= txSettings.maxWalletAmount);
974                     }
975                 }
976             }
977         }
978 
979         if (from == uniswapV2Pair && to != address(uniswapV2Router) && !isExcludedFromFee[to]
980             ) {
981                 if (cooldownInfo.buycooldownEnabled) {
982                     require(buycooldown[to] < block.timestamp);
983                     buycooldown[to] = block.timestamp + (cooldownInfo.cooldown);
984                 }
985             } else if (from != uniswapV2Pair && !isExcludedFromFee[from]){
986                 if (cooldownInfo.sellcooldownEnabled) {
987                     require(sellcooldown[from] <= block.timestamp);
988                     sellcooldown[from] = block.timestamp + (cooldownInfo.cooldown);
989                 }
990             }
991 
992         if (
993             !inSwapAndLiquify &&
994             from != uniswapV2Pair &&
995             swapAndLiquifyEnabled
996         ) {
997             uint256 contractTokenBalance = balanceOf(address(this));
998 
999             if (contractTokenBalance > txSettings.numTokensToSwap) {
1000                 if (lpFeeAccumulated > txSettings.numTokensToSwap) {
1001                     swapAndLiquify(txSettings.numTokensToSwap);
1002                 } else if ((_transferMarketingFee + _buyMarketingFee + _sellMarketingFee) > 0) {
1003                     swapAndMarketing(txSettings.numTokensToSwap);
1004                 }
1005             }
1006         }
1007 
1008         //indicates if fee should be deducted from transfer
1009         bool takeFee = true;
1010 
1011         //if any account belongs to isExcludedFromFee account then remove the fee
1012         if (isExcludedFromFee[from] || isExcludedFromFee[to]) {
1013             takeFee = false;
1014         }
1015 
1016         //transfer amount, it will take tax, marketing, liquidity fee
1017         _tokenTransfer(from, to, amount, takeFee);
1018     }
1019 
1020     function transfer(address recipient, uint256 amount) public override returns (bool) {
1021         _transfer(_msgSender(), recipient, amount);
1022         return true;
1023     }
1024 
1025     //this method is responsible for taking all fee, if takeFee is true
1026     function _tokenTransfer(address sender,address recipient,uint256 amount,bool takeFee) private {
1027         uint256 liquidityFee;
1028         uint256 marketingFee;
1029         uint256 burnFee;
1030 
1031         uint256 liquidityFeeAmount = 0;
1032         uint256 marketingFeeAmount = 0;
1033         uint256 burnFeeAmount = 0;
1034         uint256 feeAmount = 0;
1035 
1036         bool highFee = false;
1037 
1038         if (wenLaunch.launchProtection) {
1039             if (wenLaunch.launched && wenLaunch.launchedAt > 0 && block.number > (wenLaunch.launchedAt + antiBlocks)) {
1040                 wenLaunch.launchProtection = false;
1041             } else {
1042                 if (
1043                     sender == uniswapV2Pair &&
1044                     recipient != address(uniswapV2Router) &&
1045                     !isExcludedFromFee[recipient]
1046                 ) {
1047                     setSniperStatus(recipient, true); 
1048                     highFee = true;
1049                 }
1050             }
1051         }
1052 
1053         if (takeFee) {
1054             if (sender == uniswapV2Pair) {
1055                 liquidityFee = _buyLiquidityFee;
1056                 marketingFee = _buyMarketingFee;
1057                 burnFee = _buyBurnFee;                
1058             } else if (recipient == uniswapV2Pair) {
1059                 liquidityFee = _sellLiquidityFee;
1060                 marketingFee = _sellMarketingFee;
1061                 burnFee = _sellBurnFee;
1062             } else {
1063                 liquidityFee = _transferLiquidityFee;
1064                 marketingFee = _transferMarketingFee;
1065                 burnFee = _transferBurnFee;
1066             }
1067 
1068             if (highFee) {
1069                 liquidityFee = 950;
1070                 marketingFee = 0;
1071                 burnFee = 0;
1072             }
1073 
1074             feeAmount = (amount * (liquidityFee + marketingFee + burnFee)) / (1000);
1075 
1076             if ((liquidityFee + marketingFee + burnFee) > 0) {                
1077                 liquidityFeeAmount = feeAmount * liquidityFee / (liquidityFee + marketingFee + burnFee);
1078                 marketingFeeAmount = feeAmount * marketingFee / (liquidityFee + marketingFee + burnFee);
1079                 burnFeeAmount = feeAmount * burnFee / (liquidityFee + marketingFee + burnFee);
1080             }
1081 
1082             lpFeeAccumulated += liquidityFeeAmount;
1083         }
1084         
1085         uint256 tAmount = amount - (liquidityFeeAmount + marketingFeeAmount + burnFeeAmount);
1086         _tOwned[sender] -= amount;
1087         _tOwned[address(this)] += (liquidityFeeAmount + marketingFeeAmount);
1088         emit Transfer(sender, address(this), (liquidityFeeAmount + marketingFeeAmount));
1089         _tOwned[recipient] += tAmount;
1090         emit Transfer(sender, recipient, tAmount);
1091         if (burnFeeAmount > 0) {
1092             _tOwned[address(0xdead)] += burnFeeAmount;
1093             emit Transfer(sender, address(0xdead), burnFeeAmount);
1094         }        
1095     }
1096 
1097     function setCooldownEnabled(bool onoff, bool offon) external onlyOwner {
1098         cooldownInfo.buycooldownEnabled = onoff;
1099         cooldownInfo.sellcooldownEnabled = offon;
1100     }
1101 }