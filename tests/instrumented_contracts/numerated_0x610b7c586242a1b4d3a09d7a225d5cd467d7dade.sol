1 pragma solidity ^0.8.16;
2 
3 // SPDX-License-Identifier: MIT
4 
5 library SafeMath {
6     function tryAdd(uint256 a, uint256 b)
7         internal
8         pure
9         returns (bool, uint256)
10     {
11         unchecked {
12             uint256 c = a + b;
13             if (c < a) return (false, 0);
14             return (true, c);
15         }
16     }
17 
18     function trySub(uint256 a, uint256 b)
19         internal
20         pure
21         returns (bool, uint256)
22     {
23         unchecked {
24             if (b > a) return (false, 0);
25             return (true, a - b);
26         }
27     }
28 
29     function tryMul(uint256 a, uint256 b)
30         internal
31         pure
32         returns (bool, uint256)
33     {
34         unchecked {
35             if (a == 0) return (true, 0);
36             uint256 c = a * b;
37             if (c / a != b) return (false, 0);
38             return (true, c);
39         }
40     }
41 
42     function tryDiv(uint256 a, uint256 b)
43         internal
44         pure
45         returns (bool, uint256)
46     {
47         unchecked {
48             if (b == 0) return (false, 0);
49             return (true, a / b);
50         }
51     }
52 
53     function tryMod(uint256 a, uint256 b)
54         internal
55         pure
56         returns (bool, uint256)
57     {
58         unchecked {
59             if (b == 0) return (false, 0);
60             return (true, a % b);
61         }
62     }
63 
64     function add(uint256 a, uint256 b) internal pure returns (uint256) {
65         return a + b;
66     }
67 
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         return a - b;
70     }
71 
72     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73         return a * b;
74     }
75 
76     function div(uint256 a, uint256 b) internal pure returns (uint256) {
77         return a / b;
78     }
79 
80     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
81         return a % b;
82     }
83 
84     function sub(
85         uint256 a,
86         uint256 b,
87         string memory errorMessage
88     ) internal pure returns (uint256) {
89         unchecked {
90             require(b <= a, errorMessage);
91             return a - b;
92         }
93     }
94 
95     function div(
96         uint256 a,
97         uint256 b,
98         string memory errorMessage
99     ) internal pure returns (uint256) {
100         unchecked {
101             require(b > 0, errorMessage);
102             return a / b;
103         }
104     }
105 
106     function mod(
107         uint256 a,
108         uint256 b,
109         string memory errorMessage
110     ) internal pure returns (uint256) {
111         unchecked {
112             require(b > 0, errorMessage);
113             return a % b;
114         }
115     }
116 }
117 
118 interface IERC20 {
119     function totalSupply() external view returns (uint256);
120 
121     function decimals() external view returns (uint8);
122 
123     function symbol() external view returns (string memory);
124 
125     function name() external view returns (string memory);
126 
127     function getOwner() external view returns (address);
128 
129     function balanceOf(address account) external view returns (uint256);
130 
131     function transfer(address recipient, uint256 amount)
132         external
133         returns (bool);
134 
135     function allowance(address _owner, address spender)
136         external
137         view
138         returns (uint256);
139 
140     function approve(address spender, uint256 amount) external returns (bool);
141 
142     function transferFrom(
143         address sender,
144         address recipient,
145         uint256 amount
146     ) external returns (bool);
147 
148     event Transfer(address indexed from, address indexed to, uint256 value);
149     event Approval(
150         address indexed owner,
151         address indexed spender,
152         uint256 value
153     );
154 }
155 
156 interface DexFactory {
157     function createPair(address tokenA, address tokenB)
158         external
159         returns (address pair);
160 }
161 
162 interface DexRouter {
163     function factory() external pure returns (address);
164 
165     function WETH() external pure returns (address);
166 
167     function addLiquidity(
168         address tokenA,
169         address tokenB,
170         uint256 amountADesired,
171         uint256 amountBDesired,
172         uint256 amountAMin,
173         uint256 amountBMin,
174         address to,
175         uint256 deadline
176     )
177         external
178         returns (
179             uint256 amountA,
180             uint256 amountB,
181             uint256 liquidity
182         );
183 
184     function addLiquidityETH(
185         address token,
186         uint256 amountTokenDesired,
187         uint256 amountTokenMin,
188         uint256 amountETHMin,
189         address to,
190         uint256 deadline
191     )
192         external
193         payable
194         returns (
195             uint256 amountToken,
196             uint256 amountETH,
197             uint256 liquidity
198         );
199 
200     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
201         uint256 amountIn,
202         uint256 amountOutMin,
203         address[] calldata path,
204         address to,
205         uint256 deadline
206     ) external;
207 
208     function swapExactETHForTokensSupportingFeeOnTransferTokens(
209         uint256 amountOutMin,
210         address[] calldata path,
211         address to,
212         uint256 deadline
213     ) external payable;
214 
215     function swapExactTokensForETHSupportingFeeOnTransferTokens(
216         uint256 amountIn,
217         uint256 amountOutMin,
218         address[] calldata path,
219         address to,
220         uint256 deadline
221     ) external;
222 }
223 
224 abstract contract Context {
225     function _msgSender() internal view virtual returns (address payable) {
226         return payable(msg.sender);
227     }
228 
229     function _msgData() internal view virtual returns (bytes memory) {
230         this;
231         return msg.data;
232     }
233 }
234 
235 contract Ownable is Context {
236     address private _owner;
237 
238     event OwnershipTransferred(
239         address indexed previousOwner,
240         address indexed newOwner
241     );
242 
243     constructor() {
244         address msgSender = _msgSender();
245         _owner = msgSender;
246         authorizations[_owner] = true;
247         emit OwnershipTransferred(address(0), msgSender);
248     }
249 
250     mapping(address => bool) internal authorizations;
251 
252     function owner() public view returns (address) {
253         return _owner;
254     }
255 
256     modifier onlyOwner() {
257         require(_owner == _msgSender(), "Ownable: caller is not the owner");
258         _;
259     }
260 
261     function renounceOwnership() public virtual onlyOwner {
262         emit OwnershipTransferred(_owner, address(0));
263         _owner = address(0);
264     }
265 
266     function transferOwnership(address newOwner) public virtual onlyOwner {
267         require(
268             newOwner != address(0),
269             "Ownable: new owner is the zero address"
270         );
271         emit OwnershipTransferred(_owner, newOwner);
272         _owner = newOwner;
273     }
274 }
275 
276 interface INFT {
277     function freeMint(address to) external;
278 }
279 
280 contract OGAMA is Ownable, IERC20 {
281     using SafeMath for uint256;
282 
283     address private constant DEAD = 0x000000000000000000000000000000000000dEaD;
284     address private constant ZERO = 0x0000000000000000000000000000000000000000;
285 
286     address public nftContract;
287 
288     address private routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
289 
290     uint8 private constant _decimals = 18;
291 
292     uint256 private _totalSupply = 50000000 * (10**_decimals);
293     uint256 public _maxTxAmount = (_totalSupply * 20) / 1000;
294     uint256 public _walletMax = (_totalSupply * 20) / 1000;
295 
296     uint256 public nftMintCooldown = 5 days;
297     uint256 public minBalanceForNFT = (_totalSupply * 2) / 1000;
298 
299     string private constant _name = "Dejitaru \u014Cgama";
300     string private constant _symbol = "\u014CGAMA";
301 
302     bool public restrictWhales = true;
303 
304     mapping(address => uint256) private _balances;
305     mapping(address => mapping(address => uint256)) private _allowances;
306     mapping(address => uint256) public lastSell;
307     mapping(address => uint256) public nftMinted;
308 
309     mapping(address => bool) public isFeeExempt;
310     mapping(address => bool) public isTxLimitExempt;
311 
312     uint256 public liquidityFee = 2;
313     uint256 public marketingFee = 8;
314     uint256 public devFee = 0;
315     uint256 public tokenFee = 0;
316 
317     uint256 public totalFee = 0;
318     uint256 public totalFeeIfSelling = 0;
319 
320     bool public takeBuyFee = true;
321     bool public takeSellFee = true;
322     bool public takeTransferFee = true;
323 
324     address private lpWallet;
325     address private projectAddress;
326     address private devWallet;
327     address private nativeWallet;
328 
329     DexRouter public router;
330     address public pair;
331     mapping(address => bool) public isPair;
332 
333     uint256 public launchedAt;
334 
335     bool public tradingOpen = false;
336     bool public blacklistMode = true;
337     bool public canUseBlacklist = true;
338     bool private inSwapAndLiquify;
339     bool public swapAndLiquifyEnabled = true;
340     bool public swapAndLiquifyByLimitOnly = false;
341 
342     mapping(address => bool) public isBlacklisted;
343     mapping(address => bool) public isEcosystem;
344 
345     uint256 public swapThreshold = (_totalSupply * 2) / 2000;
346 
347     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
348 
349     modifier lockTheSwap() {
350         inSwapAndLiquify = true;
351         _;
352         inSwapAndLiquify = false;
353     }
354 
355     constructor() {
356         router = DexRouter(routerAddress);
357         pair = DexFactory(router.factory()).createPair(
358             router.WETH(),
359             address(this)
360         );
361         isPair[pair] = true;
362         _allowances[address(this)][address(router)] = type(uint256).max;
363         _allowances[address(this)][address(pair)] = type(uint256).max;
364 
365         isFeeExempt[msg.sender] = true;
366         isFeeExempt[address(this)] = true;
367         isFeeExempt[DEAD] = true;
368         isFeeExempt[nativeWallet] = true;
369 
370         isEcosystem[address(this)] = true;
371         isEcosystem[msg.sender] = true;
372         isEcosystem[address(pair)] = true;
373         isEcosystem[address(router)] = true;
374 
375         isTxLimitExempt[nativeWallet] = true;
376         isTxLimitExempt[msg.sender] = true;
377         isTxLimitExempt[pair] = true;
378         isTxLimitExempt[DEAD] = true;
379 
380         lpWallet = msg.sender;
381         projectAddress = 0xb223674FA7b277b5A8A09ad8257b870Df481152C;
382         devWallet = msg.sender;
383         nativeWallet = msg.sender;
384 
385         isFeeExempt[projectAddress] = true;
386         totalFee = liquidityFee.add(marketingFee).add(tokenFee).add(devFee);
387         totalFeeIfSelling = totalFee + 80;
388 
389         _balances[msg.sender] = _totalSupply;
390         emit Transfer(address(0), msg.sender, _totalSupply);
391     }
392 
393     receive() external payable {}
394 
395     function name() external pure override returns (string memory) {
396         return _name;
397     }
398 
399     function symbol() external pure override returns (string memory) {
400         return _symbol;
401     }
402 
403     function decimals() external pure override returns (uint8) {
404         return _decimals;
405     }
406 
407     function totalSupply() external view override returns (uint256) {
408         return _totalSupply;
409     }
410 
411     function getOwner() external view override returns (address) {
412         return owner();
413     }
414 
415     function balanceOf(address account) public view override returns (uint256) {
416         return _balances[account];
417     }
418 
419     function allowance(address holder, address spender)
420         external
421         view
422         override
423         returns (uint256)
424     {
425         return _allowances[holder][spender];
426     }
427 
428     function getCirculatingSupply() public view returns (uint256) {
429         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
430     }
431 
432     function approve(address spender, uint256 amount)
433         public
434         override
435         returns (bool)
436     {
437         _allowances[msg.sender][spender] = amount;
438         emit Approval(msg.sender, spender, amount);
439         return true;
440     }
441 
442     function approveMax(address spender) external returns (bool) {
443         return approve(spender, type(uint256).max);
444     }
445 
446     function launched() internal view returns (bool) {
447         return launchedAt != 0;
448     }
449 
450     function launch() internal {
451         launchedAt = block.number;
452     }
453 
454     function eligible(address _address) public view returns (bool) {
455         if (lastSell[_address] < 1) {
456             return false;
457         }
458         return lastSell[_address] < block.timestamp - nftMintCooldown;
459     }
460 
461     function checkTxLimit(address sender, uint256 amount) internal view {
462         require(
463             amount <= _maxTxAmount || isTxLimitExempt[sender],
464             "TX Limit Exceeded"
465         );
466     }
467 
468     function transfer(address recipient, uint256 amount)
469         external
470         override
471         returns (bool)
472     {
473         return _transferFrom(msg.sender, recipient, amount);
474     }
475 
476     function _basicTransfer(
477         address sender,
478         address recipient,
479         uint256 amount
480     ) internal returns (bool) {
481         _balances[sender] = _balances[sender].sub(
482             amount,
483             "Insufficient Balance"
484         );
485         _balances[recipient] = _balances[recipient].add(amount);
486         emit Transfer(sender, recipient, amount);
487         return true;
488     }
489 
490     function transferFrom(
491         address sender,
492         address recipient,
493         uint256 amount
494     ) external override returns (bool) {
495         if (_allowances[sender][msg.sender] != type(uint256).max) {
496             _allowances[sender][msg.sender] = _allowances[sender][msg.sender]
497                 .sub(amount, "Insufficient Allowance");
498         }
499         return _transferFrom(sender, recipient, amount);
500     }
501 
502     function _transferFrom(
503         address sender,
504         address recipient,
505         uint256 amount
506     ) internal returns (bool) {
507         if (inSwapAndLiquify) {
508             return _basicTransfer(sender, recipient, amount);
509         }
510         if (!authorizations[sender] && !authorizations[recipient]) {
511             require(tradingOpen, "");
512         }
513 
514         require(
515             amount <= _maxTxAmount ||
516                 (isTxLimitExempt[sender] && isTxLimitExempt[recipient]),
517             "TX Limit"
518         );
519         if (
520             isPair[recipient] &&
521             !inSwapAndLiquify &&
522             swapAndLiquifyEnabled &&
523             _balances[address(this)] >= swapThreshold
524         ) {
525             marketingAndLiquidity();
526         }
527         if (!launched() && isPair[recipient]) {
528             require(_balances[sender] > 0, "");
529             launch();
530         }
531 
532         // Blacklist
533         if (blacklistMode) {
534             require(!isBlacklisted[sender], "Blacklisted");
535         }
536 
537         //Exchange tokens
538         _balances[sender] = _balances[sender].sub(amount, "");
539 
540         if (!isTxLimitExempt[recipient] && restrictWhales) {
541             require(_balances[recipient].add(amount) <= _walletMax, "");
542         }
543 
544         uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient]
545             ? extractFee(sender, recipient, amount)
546             : amount;
547         _balances[recipient] = _balances[recipient].add(finalAmount);
548 
549         handleLastSell(sender, recipient);
550 
551         emit Transfer(sender, recipient, finalAmount);
552         return true;
553     }
554 
555     function handleLastSell(address sender, address recipient) internal{
556         if (!isPair[sender]) {
557             if(balanceOf(sender) < minBalanceForNFT){
558                 lastSell[sender] = 0;
559             }
560             else {
561                 lastSell[sender] = block.timestamp;
562             }
563         }
564         if (lastSell[recipient] < 1 && balanceOf(recipient) > minBalanceForNFT) {
565             lastSell[recipient] = block.timestamp;
566         }
567     }
568 
569     function extractFee(
570         address sender,
571         address recipient,
572         uint256 amount
573     ) internal returns (uint256) {
574         uint256 feeApplicable = 0;
575         uint256 nativeAmount = 0;
576         if (isPair[recipient] && takeSellFee) {
577             feeApplicable = totalFeeIfSelling.sub(tokenFee);
578         }
579         if (isPair[sender] && takeBuyFee) {
580             feeApplicable = totalFee.sub(tokenFee);
581         }
582         if (!isPair[sender] && !isPair[recipient]) {
583             if (takeTransferFee) {
584                 feeApplicable = totalFeeIfSelling.sub(tokenFee);
585             } else {
586                 feeApplicable = 0;
587             }
588         }
589         if (feeApplicable > 0 && tokenFee > 0) {
590             nativeAmount = amount.mul(tokenFee).div(100);
591             _balances[nativeWallet] = _balances[nativeWallet].add(nativeAmount);
592             emit Transfer(sender, nativeWallet, nativeAmount);
593         }
594         uint256 feeAmount = amount.mul(feeApplicable).div(100);
595 
596         _balances[address(this)] = _balances[address(this)].add(feeAmount);
597         emit Transfer(sender, address(this), feeAmount);
598 
599         return amount.sub(feeAmount).sub(nativeAmount);
600     }
601 
602     function marketingAndLiquidity() internal lockTheSwap {
603         uint256 tokensToLiquify = _balances[address(this)];
604         uint256 amountToLiquify = tokensToLiquify
605             .mul(liquidityFee)
606             .div(totalFee.sub(tokenFee))
607             .div(2);
608         uint256 amountToSwap = tokensToLiquify.sub(amountToLiquify);
609 
610         address[] memory path = new address[](2);
611         path[0] = address(this);
612         path[1] = router.WETH();
613 
614         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
615             amountToSwap,
616             0,
617             path,
618             address(this),
619             block.timestamp
620         );
621 
622         uint256 amountETH = address(this).balance;
623 
624         uint256 totalETHFee = totalFee.sub(tokenFee).sub(liquidityFee.div(2));
625 
626         uint256 amountETHLiquidity = amountETH
627             .mul(liquidityFee)
628             .div(totalETHFee)
629             .div(2);
630         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(
631             totalETHFee
632         );
633         uint256 amountETHDev = amountETH.mul(devFee).div(totalETHFee);
634 
635         (bool tmpSuccess1, ) = payable(projectAddress).call{
636             value: amountETHMarketing,
637             gas: 30000
638         }("");
639         tmpSuccess1 = false;
640 
641         (tmpSuccess1, ) = payable(devWallet).call{
642             value: amountETHDev,
643             gas: 30000
644         }("");
645         tmpSuccess1 = false;
646 
647         if (amountToLiquify > 0) {
648             router.addLiquidityETH{value: amountETHLiquidity}(
649                 address(this),
650                 amountToLiquify,
651                 0,
652                 0,
653                 lpWallet,
654                 block.timestamp
655             );
656             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
657         }
658     }
659 
660     function changeisEcosystem(address _address, bool _bool)
661         external
662         onlyOwner
663     {
664         isEcosystem[_address] = _bool;
665     }
666 
667     function setWalletLimit(uint256 newLimit) external onlyOwner {
668         require(newLimit >= 5, "Wallet Limit needs to be at least 0.5%");
669         _walletMax = (_totalSupply * newLimit) / 1000;
670     }
671 
672     function setTxLimit(uint256 newLimit) external onlyOwner {
673         require(newLimit >= 5, "Wallet Limit needs to be at least 0.5%");
674         _maxTxAmount = (_totalSupply * newLimit) / 1000;
675     }
676 
677     function tradingStatus(bool newStatus) public onlyOwner {
678         require(canUseBlacklist, "Can no longer pause trading");
679         tradingOpen = newStatus;
680     }
681 
682     function openTrading() public onlyOwner {
683         tradingOpen = true;
684     }
685 
686     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
687         isFeeExempt[holder] = exempt;
688     }
689 
690     function setIsTxLimitExempt(address holder, bool exempt)
691         external
692         onlyOwner
693     {
694         isTxLimitExempt[holder] = exempt;
695     }
696 
697     function addWhitelist(address target) public onlyOwner {
698         authorizations[target] = true;
699         isFeeExempt[target] = true;
700         isTxLimitExempt[target] = true;
701         isEcosystem[target] = true;
702         isBlacklisted[target] = false;
703     }
704 
705     function changeFees(
706         uint256 newLiqFee,
707         uint256 newMarketingFee,
708         uint256 newBetFee,
709         uint256 newNativeFee,
710         uint256 extraSellFee
711     ) external onlyOwner {
712         liquidityFee = newLiqFee;
713         marketingFee = newMarketingFee;
714         devFee = newBetFee;
715         tokenFee = newNativeFee;
716 
717         totalFee = liquidityFee.add(marketingFee).add(devFee).add(tokenFee);
718         totalFeeIfSelling = totalFee + extraSellFee;
719         require(totalFeeIfSelling + totalFee < 25);
720     }
721 
722     function enableBlacklist(bool _status) public onlyOwner {
723         require(canUseBlacklist, "");
724         blacklistMode = _status;
725     }
726 
727     function changeBlacklist(address[] calldata addresses, bool status)
728         public
729         onlyOwner
730     {
731         require(canUseBlacklist, "");
732         for (uint256 i; i < addresses.length; ++i) {
733             isBlacklisted[addresses[i]] = status;
734         }
735     }
736 
737     function isAuth(address _address, bool status) public onlyOwner {
738         authorizations[_address] = status;
739     }
740 
741     function changePair(address _address, bool status) public onlyOwner {
742         isPair[_address] = status;
743     }
744 
745     function renounceBlacklist() public onlyOwner {
746         canUseBlacklist = false;
747     }
748 
749     function disableBlacklist() public onlyOwner {
750         blacklistMode = false;
751     }
752 
753     function changeTakeBuyfee(bool status) public onlyOwner {
754         takeBuyFee = status;
755     }
756 
757     function changeTakeSellfee(bool status) public onlyOwner {
758         takeSellFee = status;
759     }
760 
761     function changeTakeTransferfee(bool status) public onlyOwner {
762         takeTransferFee = status;
763     }
764 
765     function changeSwapbackSettings(bool status, uint256 newAmount)
766         public
767         onlyOwner
768     {
769         swapAndLiquifyEnabled = status;
770         swapThreshold = newAmount;
771     }
772 
773     function changeWallets(
774         address newProjectWallet,
775         address newDevWallet,
776         address newLpWallet,
777         address newNativeWallet
778     ) public onlyOwner {
779         lpWallet = newLpWallet;
780         projectAddress = newProjectWallet;
781         devWallet = newDevWallet;
782         nativeWallet = newNativeWallet;
783     }
784 
785     function removeERC20(address tokenAddress, uint256 tokens)
786         public
787         onlyOwner
788         returns (bool success)
789     {
790         require(tokenAddress != address(this), "Cant remove the native token");
791         return IERC20(tokenAddress).transfer(msg.sender, tokens);
792     }
793 
794     function removeEther(uint256 amountPercentage) external onlyOwner {
795         uint256 amountETH = address(this).balance;
796         payable(msg.sender).transfer((amountETH * amountPercentage) / 100);
797     }
798 
799     function changeNFTContract(address _address) external onlyOwner {
800         nftContract = _address;
801     }
802 
803     function changeMintCooldown(uint256 _seconds) external onlyOwner {
804         nftMintCooldown = _seconds;
805     }
806 
807     function changeMinBalanceForNFT(uint256 _amount) external onlyOwner {
808         minBalanceForNFT = (_totalSupply * _amount) / 1000;
809     }
810 
811     function MintNFT() external {
812         require(eligible(msg.sender), "cant mint yet");
813         require(balanceOf(msg.sender) >= minBalanceForNFT, "not enough tokens");
814         nftMinted[msg.sender] += 1;
815         lastSell[msg.sender] = block.timestamp;
816         INFT(nftContract).freeMint(msg.sender);
817     }
818 }