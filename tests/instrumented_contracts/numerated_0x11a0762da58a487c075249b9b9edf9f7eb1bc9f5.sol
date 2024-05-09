1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.1;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7 
8     function balanceOf(address account) external view returns (uint256);
9 
10     function transfer(address recipient, uint256 amount)
11         external
12         returns (bool);
13 
14     function allowance(address owner, address spender)
15         external
16         view
17         returns (uint256);
18 
19     function approve(address spender, uint256 amount) external returns (bool);
20 
21     function transferFrom(
22         address sender,
23         address recipient,
24         uint256 amount
25     ) external returns (bool);
26 
27     event Transfer(address indexed from, address indexed to, uint256 value);
28 
29     event Approval(
30         address indexed owner,
31         address indexed spender,
32         uint256 value
33     );
34 }
35 
36 abstract contract Context {
37     function _msgSender() internal view virtual returns (address) {
38         return msg.sender;
39     }
40 
41     function _msgData() internal view virtual returns (bytes memory) {
42         this;
43         return msg.data;
44     }
45 }
46 
47 library Address {
48     function isContract(address account) internal view returns (bool) {
49         bytes32 codehash;
50         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
51         assembly {
52             codehash := extcodehash(account)
53         }
54         return (codehash != accountHash && codehash != 0x0);
55     }
56 
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(
59             address(this).balance >= amount,
60             "Address: insufficient balance"
61         );
62 
63         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
64         (bool success, ) = recipient.call{value: amount}("");
65         require(
66             success,
67             "Address: unable to send value, recipient may have reverted"
68         );
69     }
70 
71     function functionCall(address target, bytes memory data)
72         internal
73         returns (bytes memory)
74     {
75         return functionCall(target, data, "Address: low-level call failed");
76     }
77 
78     function functionCall(
79         address target,
80         bytes memory data,
81         string memory errorMessage
82     ) internal returns (bytes memory) {
83         return _functionCallWithValue(target, data, 0, errorMessage);
84     }
85 
86     function functionCallWithValue(
87         address target,
88         bytes memory data,
89         uint256 value
90     ) internal returns (bytes memory) {
91         return
92             functionCallWithValue(
93                 target,
94                 data,
95                 value,
96                 "Address: low-level call with value failed"
97             );
98     }
99 
100     function functionCallWithValue(
101         address target,
102         bytes memory data,
103         uint256 value,
104         string memory errorMessage
105     ) internal returns (bytes memory) {
106         require(
107             address(this).balance >= value,
108             "Address: insufficient balance for call"
109         );
110         return _functionCallWithValue(target, data, value, errorMessage);
111     }
112 
113     function _functionCallWithValue(
114         address target,
115         bytes memory data,
116         uint256 weiValue,
117         string memory errorMessage
118     ) private returns (bytes memory) {
119         require(isContract(target), "Address: call to non-contract");
120 
121         (bool success, bytes memory returndata) = target.call{value: weiValue}(
122             data
123         );
124         if (success) {
125             return returndata;
126         } else {
127             if (returndata.length > 0) {
128                 assembly {
129                     let returndata_size := mload(returndata)
130                     revert(add(32, returndata), returndata_size)
131                 }
132             } else {
133                 revert(errorMessage);
134             }
135         }
136     }
137 }
138 
139 contract Ownable is Context {
140     address private _owner;
141     address private _previousOwner;
142     uint256 private _lockTime;
143 
144     event OwnershipTransferred(
145         address indexed previousOwner,
146         address indexed newOwner
147     );
148 
149     constructor() {
150         address msgSender = _msgSender();
151         _owner = msgSender;
152         emit OwnershipTransferred(address(0), msgSender);
153     }
154 
155     function owner() public view returns (address) {
156         return _owner;
157     }
158 
159     modifier onlyOwner() {
160         require(_owner == _msgSender(), "Ownable: caller is not the owner");
161         _;
162     }
163 
164     function renounceOwnership() public virtual onlyOwner {
165         emit OwnershipTransferred(_owner, address(0));
166         _owner = address(0);
167     }
168 
169     function transferOwnership(address newOwner) public virtual onlyOwner {
170         require(
171             newOwner != address(0),
172             "Ownable: new owner is the zero address"
173         );
174         emit OwnershipTransferred(_owner, newOwner);
175         _owner = newOwner;
176     }
177 }
178 
179 // pragma solidity >=0.5.0;
180 
181 interface IUniswapV2Factory {
182     event PairCreated(
183         address indexed token0,
184         address indexed token1,
185         address pair,
186         uint256
187     );
188 
189     function feeTo() external view returns (address);
190 
191     function feeToSetter() external view returns (address);
192 
193     function getPair(address tokenA, address tokenB)
194         external
195         view
196         returns (address pair);
197 
198     function allPairs(uint256) external view returns (address pair);
199 
200     function allPairsLength() external view returns (uint256);
201 
202     function createPair(address tokenA, address tokenB)
203         external
204         returns (address pair);
205 
206     function setFeeTo(address) external;
207 
208     function setFeeToSetter(address) external;
209 }
210 
211 // pragma solidity >=0.5.0;
212 
213 interface IUniswapV2Pair {
214     event Approval(
215         address indexed owner,
216         address indexed spender,
217         uint256 value
218     );
219     event Transfer(address indexed from, address indexed to, uint256 value);
220 
221     function name() external pure returns (string memory);
222 
223     function symbol() external pure returns (string memory);
224 
225     function decimals() external pure returns (uint8);
226 
227     function totalSupply() external view returns (uint256);
228 
229     function balanceOf(address owner) external view returns (uint256);
230 
231     function allowance(address owner, address spender)
232         external
233         view
234         returns (uint256);
235 
236     function approve(address spender, uint256 value) external returns (bool);
237 
238     function transfer(address to, uint256 value) external returns (bool);
239 
240     function transferFrom(
241         address from,
242         address to,
243         uint256 value
244     ) external returns (bool);
245 
246     function DOMAIN_SEPARATOR() external view returns (bytes32);
247 
248     function PERMIT_TYPEHASH() external pure returns (bytes32);
249 
250     function nonces(address owner) external view returns (uint256);
251 
252     function permit(
253         address owner,
254         address spender,
255         uint256 value,
256         uint256 deadline,
257         uint8 v,
258         bytes32 r,
259         bytes32 s
260     ) external;
261 
262     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
263     event Burn(
264         address indexed sender,
265         uint256 amount0,
266         uint256 amount1,
267         address indexed to
268     );
269     event Swap(
270         address indexed sender,
271         uint256 amount0In,
272         uint256 amount1In,
273         uint256 amount0Out,
274         uint256 amount1Out,
275         address indexed to
276     );
277     event Sync(uint112 reserve0, uint112 reserve1);
278 
279     function MINIMUM_LIQUIDITY() external pure returns (uint256);
280 
281     function factory() external view returns (address);
282 
283     function token0() external view returns (address);
284 
285     function token1() external view returns (address);
286 
287     function getReserves()
288         external
289         view
290         returns (
291             uint112 reserve0,
292             uint112 reserve1,
293             uint32 blockTimestampLast
294         );
295 
296     function price0CumulativeLast() external view returns (uint256);
297 
298     function price1CumulativeLast() external view returns (uint256);
299 
300     function kLast() external view returns (uint256);
301 
302     function mint(address to) external returns (uint256 liquidity);
303 
304     function burn(address to)
305         external
306         returns (uint256 amount0, uint256 amount1);
307 
308     function swap(
309         uint256 amount0Out,
310         uint256 amount1Out,
311         address to,
312         bytes calldata data
313     ) external;
314 
315     function skim(address to) external;
316 
317     function sync() external;
318 
319     function initialize(address, address) external;
320 }
321 
322 // pragma solidity >=0.6.2;
323 
324 interface IUniswapV2Router01 {
325     function factory() external pure returns (address);
326 
327     function WETH() external pure returns (address);
328 
329     function addLiquidity(
330         address tokenA,
331         address tokenB,
332         uint256 amountADesired,
333         uint256 amountBDesired,
334         uint256 amountAMin,
335         uint256 amountBMin,
336         address to,
337         uint256 deadline
338     )
339         external
340         returns (
341             uint256 amountA,
342             uint256 amountB,
343             uint256 liquidity
344         );
345 
346     function addLiquidityETH(
347         address token,
348         uint256 amountTokenDesired,
349         uint256 amountTokenMin,
350         uint256 amountETHMin,
351         address to,
352         uint256 deadline
353     )
354         external
355         payable
356         returns (
357             uint256 amountToken,
358             uint256 amountETH,
359             uint256 liquidity
360         );
361 
362     function removeLiquidity(
363         address tokenA,
364         address tokenB,
365         uint256 liquidity,
366         uint256 amountAMin,
367         uint256 amountBMin,
368         address to,
369         uint256 deadline
370     ) external returns (uint256 amountA, uint256 amountB);
371 
372     function removeLiquidityETH(
373         address token,
374         uint256 liquidity,
375         uint256 amountTokenMin,
376         uint256 amountETHMin,
377         address to,
378         uint256 deadline
379     ) external returns (uint256 amountToken, uint256 amountETH);
380 
381     function removeLiquidityWithPermit(
382         address tokenA,
383         address tokenB,
384         uint256 liquidity,
385         uint256 amountAMin,
386         uint256 amountBMin,
387         address to,
388         uint256 deadline,
389         bool approveMax,
390         uint8 v,
391         bytes32 r,
392         bytes32 s
393     ) external returns (uint256 amountA, uint256 amountB);
394 
395     function removeLiquidityETHWithPermit(
396         address token,
397         uint256 liquidity,
398         uint256 amountTokenMin,
399         uint256 amountETHMin,
400         address to,
401         uint256 deadline,
402         bool approveMax,
403         uint8 v,
404         bytes32 r,
405         bytes32 s
406     ) external returns (uint256 amountToken, uint256 amountETH);
407 
408     function swapExactTokensForTokens(
409         uint256 amountIn,
410         uint256 amountOutMin,
411         address[] calldata path,
412         address to,
413         uint256 deadline
414     ) external returns (uint256[] memory amounts);
415 
416     function swapTokensForExactTokens(
417         uint256 amountOut,
418         uint256 amountInMax,
419         address[] calldata path,
420         address to,
421         uint256 deadline
422     ) external returns (uint256[] memory amounts);
423 
424     function swapExactETHForTokens(
425         uint256 amountOutMin,
426         address[] calldata path,
427         address to,
428         uint256 deadline
429     ) external payable returns (uint256[] memory amounts);
430 
431     function swapTokensForExactETH(
432         uint256 amountOut,
433         uint256 amountInMax,
434         address[] calldata path,
435         address to,
436         uint256 deadline
437     ) external returns (uint256[] memory amounts);
438 
439     function swapExactTokensForETH(
440         uint256 amountIn,
441         uint256 amountOutMin,
442         address[] calldata path,
443         address to,
444         uint256 deadline
445     ) external returns (uint256[] memory amounts);
446 
447     function swapETHForExactTokens(
448         uint256 amountOut,
449         address[] calldata path,
450         address to,
451         uint256 deadline
452     ) external payable returns (uint256[] memory amounts);
453 
454     function quote(
455         uint256 amountA,
456         uint256 reserveA,
457         uint256 reserveB
458     ) external pure returns (uint256 amountB);
459 
460     function getAmountOut(
461         uint256 amountIn,
462         uint256 reserveIn,
463         uint256 reserveOut
464     ) external pure returns (uint256 amountOut);
465 
466     function getAmountIn(
467         uint256 amountOut,
468         uint256 reserveIn,
469         uint256 reserveOut
470     ) external pure returns (uint256 amountIn);
471 
472     function getAmountsOut(uint256 amountIn, address[] calldata path)
473         external
474         view
475         returns (uint256[] memory amounts);
476 
477     function getAmountsIn(uint256 amountOut, address[] calldata path)
478         external
479         view
480         returns (uint256[] memory amounts);
481 }
482 
483 // pragma solidity >=0.6.2;
484 
485 interface IUniswapV2Router02 is IUniswapV2Router01 {
486     function removeLiquidityETHSupportingFeeOnTransferTokens(
487         address token,
488         uint256 liquidity,
489         uint256 amountTokenMin,
490         uint256 amountETHMin,
491         address to,
492         uint256 deadline
493     ) external returns (uint256 amountETH);
494 
495     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
496         address token,
497         uint256 liquidity,
498         uint256 amountTokenMin,
499         uint256 amountETHMin,
500         address to,
501         uint256 deadline,
502         bool approveMax,
503         uint8 v,
504         bytes32 r,
505         bytes32 s
506     ) external returns (uint256 amountETH);
507 
508     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
509         uint256 amountIn,
510         uint256 amountOutMin,
511         address[] calldata path,
512         address to,
513         uint256 deadline
514     ) external;
515 
516     function swapExactETHForTokensSupportingFeeOnTransferTokens(
517         uint256 amountOutMin,
518         address[] calldata path,
519         address to,
520         uint256 deadline
521     ) external payable;
522 
523     function swapExactTokensForETHSupportingFeeOnTransferTokens(
524         uint256 amountIn,
525         uint256 amountOutMin,
526         address[] calldata path,
527         address to,
528         uint256 deadline
529     ) external;
530 }
531 
532 contract OriginDao is Context, IERC20, Ownable {
533     using Address for address;
534 
535     string private _name = "Origin";
536     string private _symbol = "OG";
537     uint8 private _decimals = 9;
538     uint256 private initialsupply = 1_000_000_000;
539     uint256 private _tTotal = initialsupply * 10**_decimals;
540 
541     address payable public marketingWallet;
542     address public liquidityWallet;
543 
544     mapping(address => uint256) private _tOwned;
545     mapping(address => uint256) private buycooldown;
546     mapping(address => uint256) private sellcooldown;
547     mapping(address => mapping(address => uint256)) private _allowances;
548     mapping(address => bool) public isExcludedFromFee;
549     mapping(address => bool) public isBlacklisted;
550 
551     struct Icooldown {
552         bool buycooldownEnabled;
553         bool sellcooldownEnabled;
554         uint256 cooldown;
555         uint256 cooldownLimit;
556     }
557     Icooldown public cooldownInfo =
558         Icooldown({
559             buycooldownEnabled: true,
560             sellcooldownEnabled: true,
561             cooldown: 30 seconds,
562             cooldownLimit: 60 seconds
563         });
564     struct ILaunch {
565         uint256 launchedAt;
566         bool launched;
567         bool launchProtection;
568     }
569     ILaunch public wenLaunch =
570         ILaunch({
571             launchedAt: 0, 
572             launched: false, 
573             launchProtection: true
574         });
575 
576     struct ItxSettings {
577         uint256 maxTxAmount;
578         uint256 maxWalletAmount;
579         uint256 numTokensToSwap;
580         bool limited;
581     }
582 
583     ItxSettings public txSettings;
584 
585     uint256 public _transferLiquidityFee;
586     uint256 public _transferMarketingFee;
587     uint256 public _transferBurnFee;
588 
589     uint256 public _buyLiquidityFee;
590     uint256 public _buyMarketingFee;
591     uint256 public _buyBurnFee;
592 
593     uint256 public _sellLiquidityFee;
594     uint256 public _sellMarketingFee;
595     uint256 public _sellBurnFee;
596 
597     uint256 public lpFeeAccumulated;
598 
599     uint256 public antiBlocks = 2;
600 
601     IUniswapV2Router02 public immutable uniswapV2Router;
602     address public immutable uniswapV2Pair;
603     bool private inSwapAndLiquify;
604     bool public swapAndLiquifyEnabled;
605 
606     bool public tradeEnabled;
607     mapping(address => bool) public tradeAllowedList;
608 
609     modifier lockTheSwap() {
610         inSwapAndLiquify = true;
611         _;
612         inSwapAndLiquify = false;
613     }
614 
615     event SniperStatus(address account, bool blacklisted);
616     event ToMarketing(uint256 marketingBalance);
617     event SwapAndLiquify(uint256 liquidityTokens, uint256 liquidityFees);
618     event Launch();
619 
620     constructor(address _marketingWallet) {        
621         marketingWallet = payable(_marketingWallet);
622         // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E); // bsc pancake router 
623         // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3); //bsc test net router kiem
624         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //eth unisawp router
625 
626         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
627             .createPair(address(this), _uniswapV2Router.WETH());
628         uniswapV2Router = _uniswapV2Router;
629 
630         _approve(_msgSender(), address(_uniswapV2Router), type(uint256).max);
631         _approve(address(this), address(_uniswapV2Router), type(uint256).max);
632 
633         isExcludedFromFee[owner()] = true;
634         isExcludedFromFee[address(this)] = true;
635 
636         setSellFee(15,35, 0);
637         setBuyFee(15,35, 0);
638         setTransferFee(10,30, 0);
639 
640         setTxSettings(1,100,2,100,1,1000,true);
641 
642         _tOwned[_msgSender()] = _tTotal;
643         emit Transfer(address(0), _msgSender(), _tTotal);
644 
645         tradeEnabled = false;
646         tradeAllowedList[owner()] = true;
647         tradeAllowedList[address(this)] = true;
648 
649         liquidityWallet = _msgSender();
650     }
651 
652     function name() public view returns (string memory) {
653         return _name;
654     }
655 
656     function symbol() public view returns (string memory) {
657         return _symbol;
658     }
659 
660     function decimals() public view returns (uint8) {
661         return _decimals;
662     }
663 
664     function totalSupply() public view override returns (uint256) {
665         return _tTotal;
666     }
667 
668     function allowance(address owner, address spender) public view override returns (uint256) {
669         return _allowances[owner][spender];
670     }
671 
672     function balanceOf(address account) public view override returns (uint256) {
673         return _tOwned[account];
674     }
675 
676     function approve(address spender, uint256 amount) public override returns (bool) {
677         _approve(_msgSender(), spender, amount);
678         return true;
679     }
680 
681     function setSellFee(uint256 liquidityFee, uint256 marketingFee, uint256 burnFee) public onlyOwner {
682         require(liquidityFee + marketingFee + burnFee <= 250);
683         _sellLiquidityFee = liquidityFee;
684         _sellMarketingFee = marketingFee;
685         _sellBurnFee = burnFee;
686     }
687 
688     function setBuyFee(uint256 liquidityFee, uint256 marketingFee, uint256 burnFee) public onlyOwner {
689         require(liquidityFee + marketingFee + burnFee <= 250);
690         _buyMarketingFee = marketingFee;
691         _buyLiquidityFee = liquidityFee;
692         _buyBurnFee = burnFee;
693     }
694 
695     function setTransferFee(uint256 liquidityFee, uint256 marketingFee, uint256 burnFee) public onlyOwner {
696         require(liquidityFee + marketingFee + burnFee <= 250);
697         _transferLiquidityFee = liquidityFee;
698         _transferMarketingFee = marketingFee;
699         _transferBurnFee = burnFee;
700     }
701 
702     function setLiquidityFees(uint256 newTransfer, uint256 newBuy, uint256 newSell) public onlyOwner {
703         _transferLiquidityFee = newTransfer;
704         _buyLiquidityFee = newBuy;
705         _sellLiquidityFee = newSell;
706     }
707 
708     function setMarketingFees(uint256 newTransfer, uint256 newBuy, uint256 newSell) public onlyOwner {
709         _transferMarketingFee = newTransfer;
710         _buyMarketingFee = newBuy;
711         _sellMarketingFee = newSell;
712     }
713 
714     function setBurnFees(uint256 newTransfer, uint256 newBuy, uint256 newSell) public onlyOwner {
715         _transferBurnFee = newTransfer;
716         _buyBurnFee = newBuy;
717         _sellBurnFee = newSell;
718     }
719 
720     function setCooldown(uint256 amount) external onlyOwner {
721         require(amount <= cooldownInfo.cooldownLimit);
722         cooldownInfo.cooldown = amount;
723     }
724 
725     function setMarketingWallet(address payable newMarketingWallet) external onlyOwner {
726         marketingWallet = payable(newMarketingWallet);
727     }
728 
729     function setLiquidityWallet(address newLpWallet) external onlyOwner {
730         liquidityWallet = newLpWallet;
731     }
732 
733     function setTxSettings(uint256 txp, uint256 txd, uint256 mwp, uint256 mwd, uint256 sp, uint256 sd, bool limiter) public onlyOwner {
734         require((_tTotal * txp) / txd >= (_tTotal / 1000), "Max Transaction must be above 0.1% of total supply.");
735         require((_tTotal * mwp) / mwd >= (_tTotal / 1000), "Max Wallet must be above 0.1% of total supply.");
736         uint256 newTx = (_tTotal * txp) / (txd);
737         uint256 newMw = (_tTotal * mwp) / mwd;
738         uint256 swapAmount = (_tTotal * sp) / (sd);
739         txSettings = ItxSettings ({
740             numTokensToSwap: swapAmount,
741             maxTxAmount: newTx,
742             maxWalletAmount: newMw,
743             limited: limiter
744         });
745     }
746 
747     function setTradeEnabled(bool onoff) external onlyOwner {
748         if (!wenLaunch.launched) {
749             wenLaunch.launchedAt = block.number;
750             wenLaunch.launched = true;
751             swapAndLiquifyEnabled = true;
752         }
753 
754         tradeEnabled = onoff;
755 
756         if (!wenLaunch.launched) {
757             emit Launch();
758         }
759     }
760 
761     function setAntiBlocks(uint256 _block) external onlyOwner {
762         antiBlocks = _block;
763     }
764 
765     function setTradeAllowedAddress(address who, bool status) external onlyOwner {
766         tradeAllowedList[who] = status;
767     }
768 
769     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool){
770         _approve(
771             _msgSender(),
772             spender,
773             _allowances[_msgSender()][spender] + (addedValue)
774         );
775         return true;
776     }
777 
778     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
779         _approve(
780             _msgSender(),
781             spender,
782             _allowances[_msgSender()][spender] - (subtractedValue)
783         );
784         return true;
785     }
786 
787     function setBlacklistStatus(address account, bool blacklisted) external onlyOwner {
788         if(account == uniswapV2Pair || account == address(this) || account == address(uniswapV2Router)) {revert();}
789         
790         isBlacklisted[account] = blacklisted;
791     }
792 
793     function Sniper(address [] calldata accounts, bool blacklisted) external onlyOwner {
794         for (uint256 i; i < accounts.length; i++) {
795             address account = accounts[i];
796             if(account != uniswapV2Pair && account != address(this) && account != address(uniswapV2Router)) {
797                 isBlacklisted[account] = blacklisted;
798             }
799         }
800     }
801     
802     function setSniperStatus(address account, bool blacklisted) private{
803         if(account == uniswapV2Pair || account == address(this) || account == address(uniswapV2Router)) {revert();}
804         
805         if (blacklisted == true) {
806             isBlacklisted[account] = true;
807             emit SniperStatus(account, blacklisted);
808         } 
809     }
810 
811     function limits(bool onoff) public onlyOwner {
812         txSettings.limited = onoff;
813     }
814 
815     function excludeFromFee(address account) public onlyOwner {
816         isExcludedFromFee[account] = true;
817     }
818 
819     function includeInFee(address account) public onlyOwner {
820         isExcludedFromFee[account] = false;
821     }
822 
823     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
824         swapAndLiquifyEnabled = _enabled;
825     }
826 
827     //to receive ETH from uniswapV2Router when swapping
828     receive() external payable {}
829 
830     function _approve(address owner,address spender,uint256 amount) private {
831         require(owner != address(0), "ERC20: approve from the zero address");
832         require(spender != address(0), "ERC20: approve to the zero address");
833 
834         _allowances[owner][spender] = amount;
835         emit Approval(owner, spender, amount);
836     }
837 
838     function swapAndLiquify(uint256 tokenBalance) private lockTheSwap {
839         uint256 initialBalance = address(this).balance;
840         uint256 tokensToSwap = tokenBalance / 2;
841         uint256 liquidityTokens = tokenBalance - tokensToSwap;
842 
843         if (tokensToSwap > 0) {
844             swapTokensForEth(tokensToSwap);
845         }
846 
847         uint256 newBalance = address(this).balance;
848         uint256 liquidityBalance = uint256(newBalance - initialBalance);
849 
850         if (liquidityTokens > 0 && liquidityBalance > 0) {
851             addLiquidity(liquidityTokens, liquidityBalance);
852             emit SwapAndLiquify(liquidityTokens, liquidityBalance);
853         }
854 
855         lpFeeAccumulated -= tokenBalance;
856     }
857 
858     function swapAndMarketing(uint256 tokenBalance) private lockTheSwap {
859         if (tokenBalance > 0) {
860             swapTokensForEth(tokenBalance);
861         }
862 
863         uint256 marketingBalance = address(this).balance;
864         if (marketingBalance > 0) {
865             marketingWallet.transfer(marketingBalance);
866             emit ToMarketing(marketingBalance);
867         }
868     }
869 
870     function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
871         require(amountPercentage <= 100);
872         uint256 amountETH = address(this).balance;
873         payable(marketingWallet).transfer(
874             (amountETH * (amountPercentage)) / (100)
875         );
876     }
877 
878     function clearStuckToken(address to) external onlyOwner {
879         uint256 _balance = balanceOf(address(this));
880         lpFeeAccumulated = 0;
881         _transfer(address(this), to, _balance);        
882     }
883 
884     function clearStuckTokens(address _token, address _to) external onlyOwner returns (bool _sent) {
885         require(_token != address(0));
886         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
887         _sent = IERC20(_token).transfer(_to, _contractBalance);
888     }
889 
890     function swapTokensForEth(uint256 tokenAmount) private {
891         // generate the uniswap pair path of token -> weth
892         address[] memory path = new address[](2);
893         path[0] = address(this);
894         path[1] = uniswapV2Router.WETH();
895 
896         if(_allowances[address(this)][address(uniswapV2Router)] < tokenAmount) {
897             _approve(address(this), address(uniswapV2Router), type(uint256).max);
898         }
899 
900         // make the swap
901         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
902             tokenAmount,
903             0, // accept any amount of ETH
904             path,
905             address(this),
906             block.timestamp
907         );
908     }
909 
910     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
911         if(_allowances[address(this)][address(uniswapV2Router)] < tokenAmount) {
912             _approve(address(this), address(uniswapV2Router), type(uint256).max);
913         }
914 
915         // add the liquidity
916         uniswapV2Router.addLiquidityETH{value: ethAmount}(
917             address(this),
918             tokenAmount,
919             0, // slippage is unavoidable
920             0, // slippage is unavoidable
921             liquidityWallet,
922             block.timestamp
923         );
924     }
925 
926     function transferFrom(address sender,address recipient,uint256 amount) public override returns (bool) {
927         _transfer(sender, recipient, amount);
928         _approve(
929             sender,
930             _msgSender(),
931             _allowances[sender][_msgSender()] - (
932                 amount
933             )
934         );
935         return true;
936     }    
937 
938     function _transfer(address from, address to, uint256 amount) private {
939         require(from != address(0), "ERC20: transfer from the zero address");
940         require(to != address(0), "ERC20: transfer to the zero address");
941         require(amount > 0, "Transfer amount must be greater than zero");
942         require(isBlacklisted[from] == false, "Hehe");
943         require(isBlacklisted[to] == false, "Hehe");
944 
945         if (!tradeEnabled) {
946             require(tradeAllowedList[from] || tradeAllowedList[to], "Transfer: not allowed");
947             require(balanceOf(uniswapV2Pair) == 0 || to != uniswapV2Pair, "Transfer: no body can sell now");
948         }
949 
950         if (txSettings.limited) {
951             if(from != owner() && to != owner() || to != address(0xdead) && to != address(0)) 
952             {
953                 if (from == uniswapV2Pair || to == uniswapV2Pair
954                 ) {
955                     if(!isExcludedFromFee[to] && !isExcludedFromFee[from]) {
956                         require(amount <= txSettings.maxTxAmount);
957                     }
958                 }
959                 if(to != address(uniswapV2Router) && to != uniswapV2Pair) {
960                     if(!isExcludedFromFee[to]) {
961                         require(balanceOf(to) + amount <= txSettings.maxWalletAmount);
962                     }
963                 }
964             }
965         }
966 
967         if (from == uniswapV2Pair && to != address(uniswapV2Router) && !isExcludedFromFee[to]
968             ) {
969                 if (cooldownInfo.buycooldownEnabled) {
970                     require(buycooldown[to] < block.timestamp);
971                     buycooldown[to] = block.timestamp + (cooldownInfo.cooldown);
972                 }
973             } else if (from != uniswapV2Pair && !isExcludedFromFee[from]){
974                 if (cooldownInfo.sellcooldownEnabled) {
975                     require(sellcooldown[from] <= block.timestamp);
976                     sellcooldown[from] = block.timestamp + (cooldownInfo.cooldown);
977                 }
978             }
979 
980         if (
981             !inSwapAndLiquify &&
982             from != uniswapV2Pair &&
983             swapAndLiquifyEnabled
984         ) {
985             uint256 contractTokenBalance = balanceOf(address(this));
986 
987             if (contractTokenBalance > txSettings.numTokensToSwap) {
988                 if (lpFeeAccumulated > txSettings.numTokensToSwap) {
989                     swapAndLiquify(txSettings.numTokensToSwap);
990                 } else if ((_transferMarketingFee + _buyMarketingFee + _sellMarketingFee) > 0) {
991                     swapAndMarketing(txSettings.numTokensToSwap);
992                 }
993             }
994         }
995 
996         //indicates if fee should be deducted from transfer
997         bool takeFee = true;
998 
999         //if any account belongs to isExcludedFromFee account then remove the fee
1000         if (isExcludedFromFee[from] || isExcludedFromFee[to]) {
1001             takeFee = false;
1002         }
1003 
1004         //transfer amount, it will take tax, marketing, liquidity fee
1005         _tokenTransfer(from, to, amount, takeFee);
1006     }
1007 
1008     function transfer(address recipient, uint256 amount) public override returns (bool) {
1009         _transfer(_msgSender(), recipient, amount);
1010         return true;
1011     }
1012 
1013     //this method is responsible for taking all fee, if takeFee is true
1014     function _tokenTransfer(address sender,address recipient,uint256 amount,bool takeFee) private {
1015         uint256 liquidityFee;
1016         uint256 marketingFee;
1017         uint256 burnFee;
1018 
1019         uint256 liquidityFeeAmount = 0;
1020         uint256 marketingFeeAmount = 0;
1021         uint256 burnFeeAmount = 0;
1022         uint256 feeAmount = 0;
1023 
1024         bool highFee = false;
1025 
1026         if (wenLaunch.launchProtection) {
1027             if (wenLaunch.launched && wenLaunch.launchedAt > 0 && block.number > (wenLaunch.launchedAt + antiBlocks)) {
1028                 wenLaunch.launchProtection = false;
1029             } else {
1030                 if (
1031                     sender == uniswapV2Pair &&
1032                     recipient != address(uniswapV2Router) &&
1033                     !isExcludedFromFee[recipient]
1034                 ) {
1035                     setSniperStatus(recipient, true); 
1036                     highFee = true;
1037                 }
1038             }
1039         }
1040 
1041         if (takeFee) {
1042             if (sender == uniswapV2Pair) {
1043                 liquidityFee = _buyLiquidityFee;
1044                 marketingFee = _buyMarketingFee;
1045                 burnFee = _buyBurnFee;                
1046             } else if (recipient == uniswapV2Pair) {
1047                 liquidityFee = _sellLiquidityFee;
1048                 marketingFee = _sellMarketingFee;
1049                 burnFee = _sellBurnFee;
1050             } else {
1051                 liquidityFee = _transferLiquidityFee;
1052                 marketingFee = _transferMarketingFee;
1053                 burnFee = _transferBurnFee;
1054             }
1055 
1056             if (highFee) {
1057                 liquidityFee = 950;
1058                 marketingFee = 0;
1059                 burnFee = 0;
1060             }
1061 
1062             feeAmount = (amount * (liquidityFee + marketingFee + burnFee)) / (1000);
1063 
1064             if ((liquidityFee + marketingFee + burnFee) > 0) {                
1065                 liquidityFeeAmount = feeAmount * liquidityFee / (liquidityFee + marketingFee + burnFee);
1066                 marketingFeeAmount = feeAmount * marketingFee / (liquidityFee + marketingFee + burnFee);
1067                 burnFeeAmount = feeAmount * burnFee / (liquidityFee + marketingFee + burnFee);
1068             }
1069 
1070             lpFeeAccumulated += liquidityFeeAmount;
1071         }
1072         
1073         uint256 tAmount = amount - (liquidityFeeAmount + marketingFeeAmount + burnFeeAmount);
1074         _tOwned[sender] -= amount;
1075         _tOwned[address(this)] += (liquidityFeeAmount + marketingFeeAmount);
1076         emit Transfer(sender, address(this), (liquidityFeeAmount + marketingFeeAmount));
1077         _tOwned[recipient] += tAmount;
1078         emit Transfer(sender, recipient, tAmount);
1079         if (burnFeeAmount > 0) {
1080             _tOwned[address(0xdead)] += burnFeeAmount;
1081             emit Transfer(sender, address(0xdead), burnFeeAmount);
1082         }        
1083     }
1084 
1085     function setCooldownEnabled(bool onoff, bool offon) external onlyOwner {
1086         cooldownInfo.buycooldownEnabled = onoff;
1087         cooldownInfo.sellcooldownEnabled = offon;
1088     }
1089 }