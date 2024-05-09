1 // SPDX-License-Identifier: MIT
2  
3 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
4 pragma experimental ABIEncoderV2;
5  
6  
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11  
12     function _msgData() internal view virtual returns (bytes calldata) {
13         return msg.data;
14     }
15 }
16  
17  
18 abstract contract Ownable is Context {
19     address private _owner;
20  
21     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22  
23     constructor() {
24         _transferOwnership(_msgSender());
25     }
26  
27     function owner() public view virtual returns (address) {
28         return _owner;
29     }
30  
31     modifier onlyOwner() {
32         require(owner() == _msgSender(), "Ownable: caller is not the owner");
33         _;
34     }
35  
36  
37     function renounceOwnership() public virtual onlyOwner {
38         _transferOwnership(address(0));
39     }
40  
41     function transferOwnership(address newOwner) public virtual onlyOwner {
42         require(newOwner != address(0), "Ownable: new owner is the zero address");
43         _transferOwnership(newOwner);
44     }
45  
46  
47     function _transferOwnership(address newOwner) internal virtual {
48         address oldOwner = _owner;
49         _owner = newOwner;
50         emit OwnershipTransferred(oldOwner, newOwner);
51     }
52 }
53  
54  
55 interface IERC20 {
56  
57     function totalSupply() external view returns (uint256);
58  
59     function balanceOf(address account) external view returns (uint256);
60  
61  
62     function transfer(address recipient, uint256 amount) external returns (bool);
63  
64  
65     function allowance(address owner, address spender) external view returns (uint256);
66  
67     function approve(address spender, uint256 amount) external returns (bool);
68  
69  
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75  
76  
77     event Transfer(address indexed from, address indexed to, uint256 value);
78  
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81  
82  
83 interface IERC20Metadata is IERC20 {
84  
85     function name() external view returns (string memory);
86  
87     function symbol() external view returns (string memory);
88  
89     function decimals() external view returns (uint8);
90 }
91  
92  
93 contract ERC20 is Context, IERC20, IERC20Metadata {
94     mapping(address => uint256) private _balances;
95  
96     mapping(address => mapping(address => uint256)) private _allowances;
97  
98     uint256 private _totalSupply;
99  
100     string private _name;
101     string private _symbol;
102  
103  
104  
105     constructor(string memory name_, string memory symbol_) {
106         _name = name_;
107         _symbol = symbol_;
108     }
109  
110  
111     function name() public view virtual override returns (string memory) {
112         return _name;
113     }
114  
115  
116     function symbol() public view virtual override returns (string memory) {
117         return _symbol;
118     }
119  
120  
121     function decimals() public view virtual override returns (uint8) {
122         return 18;
123     }
124  
125  
126     function totalSupply() public view virtual override returns (uint256) {
127         return _totalSupply;
128     }
129  
130     function balanceOf(address account) public view virtual override returns (uint256) {
131         return _balances[account];
132     }
133  
134     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
135         _transfer(_msgSender(), recipient, amount);
136         return true;
137     }
138  
139  
140     function allowance(address owner, address spender) public view virtual override returns (uint256) {
141         return _allowances[owner][spender];
142     }
143  
144     function approve(address spender, uint256 amount) public virtual override returns (bool) {
145         _approve(_msgSender(), spender, amount);
146         return true;
147     }
148  
149     function transferFrom(
150         address sender,
151         address recipient,
152         uint256 amount
153     ) public virtual override returns (bool) {
154         _transfer(sender, recipient, amount);
155  
156         uint256 currentAllowance = _allowances[sender][_msgSender()];
157         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
158         unchecked {
159             _approve(sender, _msgSender(), currentAllowance - amount);
160         }
161  
162         return true;
163     }
164  
165     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
166         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
167         return true;
168     }
169  
170     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
171         uint256 currentAllowance = _allowances[_msgSender()][spender];
172         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
173         unchecked {
174             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
175         }
176  
177         return true;
178     }
179  
180     function _transfer(
181         address sender,
182         address recipient,
183         uint256 amount
184     ) internal virtual {
185         require(sender != address(0), "ERC20: transfer from the zero address");
186         require(recipient != address(0), "ERC20: transfer to the zero address");
187  
188         _beforeTokenTransfer(sender, recipient, amount);
189  
190         uint256 senderBalance = _balances[sender];
191         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
192         unchecked {
193             _balances[sender] = senderBalance - amount;
194         }
195         _balances[recipient] += amount;
196  
197         emit Transfer(sender, recipient, amount);
198  
199         _afterTokenTransfer(sender, recipient, amount);
200     }
201  
202     function _mint(address account, uint256 amount) internal virtual {
203         require(account != address(0), "ERC20: mint to the zero address");
204  
205         _beforeTokenTransfer(address(0), account, amount);
206  
207         _totalSupply += amount;
208         _balances[account] += amount;
209         emit Transfer(address(0), account, amount);
210  
211         _afterTokenTransfer(address(0), account, amount);
212     }
213  
214     function _burn(address account, uint256 amount) internal virtual {
215         require(account != address(0), "ERC20: burn from the zero address");
216  
217         _beforeTokenTransfer(account, address(0), amount);
218  
219         uint256 accountBalance = _balances[account];
220         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
221         unchecked {
222             _balances[account] = accountBalance - amount;
223         }
224         _totalSupply -= amount;
225  
226         emit Transfer(account, address(0), amount);
227  
228         _afterTokenTransfer(account, address(0), amount);
229     }
230  
231     function _approve(
232         address owner,
233         address spender,
234         uint256 amount
235     ) internal virtual {
236         require(owner != address(0), "ERC20: approve from the zero address");
237         require(spender != address(0), "ERC20: approve to the zero address");
238  
239         _allowances[owner][spender] = amount;
240         emit Approval(owner, spender, amount);
241     }
242  
243     function _beforeTokenTransfer(
244         address from,
245         address to,
246         uint256 amount
247     ) internal virtual {}
248  
249     function _afterTokenTransfer(
250         address from,
251         address to,
252         uint256 amount
253     ) internal virtual {}
254 }
255  
256  
257 library SafeMath {
258  
259     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
260         unchecked {
261             uint256 c = a + b;
262             if (c < a) return (false, 0);
263             return (true, c);
264         }
265     }
266  
267     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
268         unchecked {
269             if (b > a) return (false, 0);
270             return (true, a - b);
271         }
272     }
273  
274  
275     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
276         unchecked {
277             if (a == 0) return (true, 0);
278             uint256 c = a * b;
279             if (c / a != b) return (false, 0);
280             return (true, c);
281         }
282     }
283  
284     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
285         unchecked {
286             if (b == 0) return (false, 0);
287             return (true, a / b);
288         }
289     }
290  
291     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
292         unchecked {
293             if (b == 0) return (false, 0);
294             return (true, a % b);
295         }
296     }
297  
298  
299     function add(uint256 a, uint256 b) internal pure returns (uint256) {
300         return a + b;
301     }
302  
303     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
304         return a - b;
305     }
306  
307     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
308         return a * b;
309     }
310  
311     function div(uint256 a, uint256 b) internal pure returns (uint256) {
312         return a / b;
313     }
314  
315     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
316         return a % b;
317     }
318  
319     function sub(
320         uint256 a,
321         uint256 b,
322         string memory errorMessage
323     ) internal pure returns (uint256) {
324         unchecked {
325             require(b <= a, errorMessage);
326             return a - b;
327         }
328     }
329  
330     function div(
331         uint256 a,
332         uint256 b,
333         string memory errorMessage
334     ) internal pure returns (uint256) {
335         unchecked {
336             require(b > 0, errorMessage);
337             return a / b;
338         }
339     }
340  
341  
342     function mod(
343         uint256 a,
344         uint256 b,
345         string memory errorMessage
346     ) internal pure returns (uint256) {
347         unchecked {
348             require(b > 0, errorMessage);
349             return a % b;
350         }
351     }
352 }
353  
354  
355 interface IUniswapV2Factory {
356     event PairCreated(
357         address indexed token0,
358         address indexed token1,
359         address pair,
360         uint256
361     );
362  
363     function feeTo() external view returns (address);
364  
365     function feeToSetter() external view returns (address);
366  
367     function getPair(address tokenA, address tokenB)
368         external
369         view
370         returns (address pair);
371  
372     function allPairs(uint256) external view returns (address pair);
373  
374     function allPairsLength() external view returns (uint256);
375  
376     function createPair(address tokenA, address tokenB)
377         external
378         returns (address pair);
379  
380     function setFeeTo(address) external;
381  
382     function setFeeToSetter(address) external;
383 }
384  
385  
386 interface IUniswapV2Pair {
387     event Approval(
388         address indexed owner,
389         address indexed spender,
390         uint256 value
391     );
392     event Transfer(address indexed from, address indexed to, uint256 value);
393  
394     function name() external pure returns (string memory);
395  
396     function symbol() external pure returns (string memory);
397  
398     function decimals() external pure returns (uint8);
399  
400     function totalSupply() external view returns (uint256);
401  
402     function balanceOf(address owner) external view returns (uint256);
403  
404     function allowance(address owner, address spender)
405         external
406         view
407         returns (uint256);
408  
409     function approve(address spender, uint256 value) external returns (bool);
410  
411     function transfer(address to, uint256 value) external returns (bool);
412  
413     function transferFrom(
414         address from,
415         address to,
416         uint256 value
417     ) external returns (bool);
418  
419     function DOMAIN_SEPARATOR() external view returns (bytes32);
420  
421     function PERMIT_TYPEHASH() external pure returns (bytes32);
422  
423     function nonces(address owner) external view returns (uint256);
424  
425     function permit(
426         address owner,
427         address spender,
428         uint256 value,
429         uint256 deadline,
430         uint8 v,
431         bytes32 r,
432         bytes32 s
433     ) external;
434  
435     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
436     event Burn(
437         address indexed sender,
438         uint256 amount0,
439         uint256 amount1,
440         address indexed to
441     );
442     event Swap(
443         address indexed sender,
444         uint256 amount0In,
445         uint256 amount1In,
446         uint256 amount0Out,
447         uint256 amount1Out,
448         address indexed to
449     );
450     event Sync(uint112 reserve0, uint112 reserve1);
451  
452     function MINIMUM_LIQUIDITY() external pure returns (uint256);
453  
454     function factory() external view returns (address);
455  
456     function token0() external view returns (address);
457  
458     function token1() external view returns (address);
459  
460     function getReserves()
461         external
462         view
463         returns (
464             uint112 reserve0,
465             uint112 reserve1,
466             uint32 blockTimestampLast
467         );
468  
469     function price0CumulativeLast() external view returns (uint256);
470  
471     function price1CumulativeLast() external view returns (uint256);
472  
473     function kLast() external view returns (uint256);
474  
475     function mint(address to) external returns (uint256 liquidity);
476  
477     function burn(address to)
478         external
479         returns (uint256 amount0, uint256 amount1);
480  
481     function swap(
482         uint256 amount0Out,
483         uint256 amount1Out,
484         address to,
485         bytes calldata data
486     ) external;
487  
488     function skim(address to) external;
489  
490     function sync() external;
491  
492     function initialize(address, address) external;
493 }
494  
495  
496 interface IUniswapV2Router02 {
497     function factory() external pure returns (address);
498  
499     function WETH() external pure returns (address);
500  
501     function addLiquidity(
502         address tokenA,
503         address tokenB,
504         uint256 amountADesired,
505         uint256 amountBDesired,
506         uint256 amountAMin,
507         uint256 amountBMin,
508         address to,
509         uint256 deadline
510     )
511         external
512         returns (
513             uint256 amountA,
514             uint256 amountB,
515             uint256 liquidity
516         );
517  
518     function addLiquidityETH(
519         address token,
520         uint256 amountTokenDesired,
521         uint256 amountTokenMin,
522         uint256 amountETHMin,
523         address to,
524         uint256 deadline
525     )
526         external
527         payable
528         returns (
529             uint256 amountToken,
530             uint256 amountETH,
531             uint256 liquidity
532         );
533  
534     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
535         uint256 amountIn,
536         uint256 amountOutMin,
537         address[] calldata path,
538         address to,
539         uint256 deadline
540     ) external;
541  
542     function swapExactETHForTokensSupportingFeeOnTransferTokens(
543         uint256 amountOutMin,
544         address[] calldata path,
545         address to,
546         uint256 deadline
547     ) external payable;
548  
549     function swapExactTokensForETHSupportingFeeOnTransferTokens(
550         uint256 amountIn,
551         uint256 amountOutMin,
552         address[] calldata path,
553         address to,
554         uint256 deadline
555     ) external;
556 }
557  
558  
559  
560 contract DOGGER is ERC20, Ownable {
561     using SafeMath for uint256;
562  
563     IUniswapV2Router02 public immutable uniswapV2Router;
564     address public immutable uniswapV2Pair;
565     address public constant deadAddress = address(0xdead);
566  
567     bool private swapping;
568  
569     address private marketingWallet;
570     address private developmentWallet;
571  
572     uint256 public percentForLPBurn = 0; 
573     bool public lpBurnEnabled = false;
574     uint256 public lpBurnFrequency = 3600 seconds;
575     uint256 public lastLpBurnTime;
576  
577     uint256 public maxTransactionAmount;
578     uint256 public swapTokensAtAmount;
579     uint256 public maxWallet;
580  
581     bool public limitsInEffect = true;
582     bool public tradingActive = true;
583     bool public swapEnabled = true;
584  
585     uint256 public manualBurnFrequency = 30 minutes;
586     uint256 public lastManualLpBurnTime;
587  
588  
589  
590     mapping(address => uint256) private _holderLastTransferTimestamp; 
591     bool public transferDelayEnabled = true;
592  
593     uint256 public buyTotalFees;
594     uint256 public buyMarketingFee;
595     uint256 public buyLiquidityFee;
596     uint256 public buyDevelopmentFee;
597  
598     uint256 public sellTotalFees;
599     uint256 public sellMarketingFee;
600     uint256 public sellLiquidityFee;
601     uint256 public sellDevelopmentFee;
602  
603     uint256 public tokensForMarketing;
604     uint256 public tokensForLiquidity;
605     uint256 public tokensForDev;
606  
607     mapping(address => bool) private _isExcludedFromFees;
608     mapping(address => bool) public _isExcludedMaxTransactionAmount;
609  
610     mapping(address => bool) public automatedMarketMakerPairs;
611  
612     event UpdateUniswapV2Router(
613         address indexed newAddress,
614         address indexed oldAddress
615     );
616  
617     event ExcludeFromFees(address indexed account, bool isExcluded);
618  
619     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
620  
621     event marketingWalletUpdated(
622         address indexed newWallet,
623         address indexed oldWallet
624     );
625  
626     event developmentWalletUpdated(
627         address indexed newWallet,
628         address indexed oldWallet
629     );
630  
631     event SwapAndLiquify(
632         uint256 tokensSwapped,
633         uint256 ethReceived,
634         uint256 tokensIntoLiquidity
635     );
636  
637     event AutoNukeLP();
638  
639     event ManualNukeLP();
640  
641     constructor() ERC20("Twitter Doge", "DOGGER") {
642         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
643             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
644         );
645  
646         excludeFromMaxTransaction(address(_uniswapV2Router), true);
647         uniswapV2Router = _uniswapV2Router;
648  
649         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
650             .createPair(address(this), _uniswapV2Router.WETH());
651         excludeFromMaxTransaction(address(uniswapV2Pair), true);
652         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
653  
654         uint256 _buyMarketingFee = 25;
655         uint256 _buyLiquidityFee = 0;
656         uint256 _buyDevelopmentFee = 0;
657  
658         uint256 _sellMarketingFee = 99;
659         uint256 _sellLiquidityFee = 0;
660         uint256 _sellDevelopmentFee = 0;
661  
662         uint256 totalSupply = 1_000_000_000 * 1e18;
663  
664         maxTransactionAmount = 1_000_000_000 * 1e18; 
665         maxWallet = 20_000_000 * 1e18; 
666         swapTokensAtAmount = (totalSupply * 10) / 10000;
667  
668         buyMarketingFee = _buyMarketingFee;
669         buyLiquidityFee = _buyLiquidityFee;
670         buyDevelopmentFee = _buyDevelopmentFee;
671         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
672  
673         sellMarketingFee = _sellMarketingFee;
674         sellLiquidityFee = _sellLiquidityFee;
675         sellDevelopmentFee = _sellDevelopmentFee;
676         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
677  
678         marketingWallet = address(0xd6133ddE21F328EB7DfcAaF22aee8dB8d76590A1); 
679         developmentWallet = address(0xd6133ddE21F328EB7DfcAaF22aee8dB8d76590A1); 
680  
681         excludeFromFees(owner(), true);
682         excludeFromFees(address(this), true);
683         excludeFromFees(address(0xdead), true);
684  
685         excludeFromMaxTransaction(owner(), true);
686         excludeFromMaxTransaction(address(this), true);
687         excludeFromMaxTransaction(address(0xdead), true);
688  
689         _mint(msg.sender, totalSupply);
690     }
691  
692     receive() external payable {}
693  
694     function enableTrade() external onlyOwner {
695         tradingActive = true;
696         swapEnabled = true;
697         lastLpBurnTime = block.timestamp;
698     }
699  
700     function removeLimits() external onlyOwner returns (bool) {
701         limitsInEffect = false;
702         return true;
703     }
704  
705     function disableTransferDelay() external onlyOwner returns (bool) {
706         transferDelayEnabled = false;
707         return true;
708     }
709  
710     function updateSwapTokensAtAmount(uint256 newAmount)
711         external
712         onlyOwner
713         returns (bool)
714     {
715         require(
716             newAmount >= (totalSupply() * 1) / 100000,
717             "Swap amount cannot be lower than 0.001% total supply."
718         );
719         require(
720             newAmount <= (totalSupply() * 5) / 1000,
721             "Swap amount cannot be higher than 0.5% total supply."
722         );
723         swapTokensAtAmount = newAmount;
724         return true;
725     }
726  
727     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
728         require(
729             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
730             "Cannot set maxTransactionAmount lower than 0.1%"
731         );
732         maxTransactionAmount = newNum * (10**18);
733     }
734  
735     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
736         require(
737             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
738             "Cannot set maxWallet lower than 0.5%"
739         );
740         maxWallet = newNum * (10**18);
741     }
742  
743     function excludeFromMaxTransaction(address updAds, bool isEx)
744         public
745         onlyOwner
746     {
747         _isExcludedMaxTransactionAmount[updAds] = isEx;
748     }
749  
750     function updateSwapEnabled(bool enabled) external onlyOwner {
751         swapEnabled = enabled;
752     }
753  
754     function updateBuyFees(
755         uint256 _marketingFee,
756         uint256 _liquidityFee,
757         uint256 _developmentFee
758     ) external onlyOwner {
759         buyMarketingFee = _marketingFee;
760         buyLiquidityFee = _liquidityFee;
761         buyDevelopmentFee = _developmentFee;
762         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
763     }
764  
765     function updateSellFees(
766         uint256 _marketingFee,
767         uint256 _liquidityFee,
768         uint256 _developmentFee
769     ) external onlyOwner {
770         sellMarketingFee = _marketingFee;
771         sellLiquidityFee = _liquidityFee;
772         sellDevelopmentFee = _developmentFee;
773         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
774     }
775  
776     function excludeFromFees(address account, bool excluded) public onlyOwner {
777         _isExcludedFromFees[account] = excluded;
778         emit ExcludeFromFees(account, excluded);
779     }
780  
781     function setAutomatedMarketMakerPair(address pair, bool value)
782         public
783         onlyOwner
784     {
785         require(
786             pair != uniswapV2Pair,
787             "The pair cannot be removed from automatedMarketMakerPairs"
788         );
789  
790         _setAutomatedMarketMakerPair(pair, value);
791     }
792  
793     function _setAutomatedMarketMakerPair(address pair, bool value) private {
794         automatedMarketMakerPairs[pair] = value;
795  
796         emit SetAutomatedMarketMakerPair(pair, value);
797     }
798  
799     function updateMarketingWalletInfo(address newMarketingWallet)
800         external
801         onlyOwner
802     {
803         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
804         marketingWallet = newMarketingWallet;
805     }
806  
807     function updateDevelopmentWalletInfo(address newWallet) external onlyOwner {
808         emit developmentWalletUpdated(newWallet, developmentWallet);
809         developmentWallet = newWallet;
810     }
811  
812     function isExcludedFromFees(address account) public view returns (bool) {
813         return _isExcludedFromFees[account];
814     }
815  
816     event BoughtEarly(address indexed sniper);
817  
818     function _transfer(
819         address from,
820         address to,
821         uint256 amount
822     ) internal override {
823         require(from != address(0), "ERC20: transfer from the zero address");
824         require(to != address(0), "ERC20: transfer to the zero address");
825  
826         if (amount == 0) {
827             super._transfer(from, to, 0);
828             return;
829         }
830  
831         if (limitsInEffect) {
832             if (
833                 from != owner() &&
834                 to != owner() &&
835                 to != address(0) &&
836                 to != address(0xdead) &&
837                 !swapping
838             ) {
839                 if (!tradingActive) {
840                     require(
841                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
842                         "Trading is not active."
843                     );
844                 }
845  
846                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
847                 if (transferDelayEnabled) {
848                     if (
849                         to != owner() &&
850                         to != address(uniswapV2Router) &&
851                         to != address(uniswapV2Pair)
852                     ) {
853                         require(
854                             _holderLastTransferTimestamp[tx.origin] <
855                                 block.number,
856                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
857                         );
858                         _holderLastTransferTimestamp[tx.origin] = block.number;
859                     }
860                 }
861  
862                 //when buy
863                 if (
864                     automatedMarketMakerPairs[from] &&
865                     !_isExcludedMaxTransactionAmount[to]
866                 ) {
867                     require(
868                         amount <= maxTransactionAmount,
869                         "Buy transfer amount exceeds the maxTransactionAmount."
870                     );
871                     require(
872                         amount + balanceOf(to) <= maxWallet,
873                         "Max wallet exceeded"
874                     );
875                 }
876                 //when sell
877                 else if (
878                     automatedMarketMakerPairs[to] &&
879                     !_isExcludedMaxTransactionAmount[from]
880                 ) {
881                     require(
882                         amount <= maxTransactionAmount,
883                         "Sell transfer amount exceeds the maxTransactionAmount."
884                     );
885                 } else if (!_isExcludedMaxTransactionAmount[to]) {
886                     require(
887                         amount + balanceOf(to) <= maxWallet,
888                         "Max wallet exceeded"
889                     );
890                 }
891             }
892         }
893  
894         uint256 contractTokenBalance = balanceOf(address(this));
895  
896         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
897  
898         if (
899             canSwap &&
900             swapEnabled &&
901             !swapping &&
902             !automatedMarketMakerPairs[from] &&
903             !_isExcludedFromFees[from] &&
904             !_isExcludedFromFees[to]
905         ) {
906             swapping = true;
907  
908             swapBack();
909  
910             swapping = false;
911         }
912  
913         if (
914             !swapping &&
915             automatedMarketMakerPairs[to] &&
916             lpBurnEnabled &&
917             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
918             !_isExcludedFromFees[from]
919         ) {
920             autoBurnLiquidityPairTokens();
921         }
922  
923         bool takeFee = !swapping;
924  
925         // if any account belongs to _isExcludedFromFee account then remove the fee
926         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
927             takeFee = false;
928         }
929  
930         uint256 fees = 0;
931         // only take fees on buys/sells, do not take on wallet transfers
932         if (takeFee) {
933             // on sell
934             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
935                 fees = amount.mul(sellTotalFees).div(100);
936                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
937                 tokensForDev += (fees * sellDevelopmentFee) / sellTotalFees;
938                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
939             }
940             // on buy
941             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
942                 fees = amount.mul(buyTotalFees).div(100);
943                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
944                 tokensForDev += (fees * buyDevelopmentFee) / buyTotalFees;
945                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
946             }
947  
948             if (fees > 0) {
949                 super._transfer(from, address(this), fees);
950             }
951  
952             amount -= fees;
953         }
954  
955         super._transfer(from, to, amount);
956     }
957  
958     function swapTokensForEth(uint256 tokenAmount) private {
959         // generate the uniswap pair path of token -> weth
960         address[] memory path = new address[](2);
961         path[0] = address(this);
962         path[1] = uniswapV2Router.WETH();
963  
964         _approve(address(this), address(uniswapV2Router), tokenAmount);
965  
966         // make the swap
967         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
968             tokenAmount,
969             0, // accept any amount of ETH
970             path,
971             address(this),
972             block.timestamp
973         );
974     }
975  
976     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
977         // approve token transfer to cover all possible scenarios
978         _approve(address(this), address(uniswapV2Router), tokenAmount);
979  
980         // add the liquidity
981         uniswapV2Router.addLiquidityETH{value: ethAmount}(
982             address(this),
983             tokenAmount,
984             0, // slippage is unavoidable
985             0, // slippage is unavoidable
986             deadAddress,
987             block.timestamp
988         );
989     }
990  
991     function swapBack() private {
992         uint256 contractBalance = balanceOf(address(this));
993         uint256 totalTokensToSwap = tokensForLiquidity +
994             tokensForMarketing +
995             tokensForDev;
996         bool success;
997  
998         if (contractBalance == 0 || totalTokensToSwap == 0) {
999             return;
1000         }
1001  
1002         if (contractBalance > swapTokensAtAmount * 20) {
1003             contractBalance = swapTokensAtAmount * 20;
1004         }
1005  
1006         // Halve the amount of liquidity tokens
1007         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1008             totalTokensToSwap /
1009             2;
1010         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1011  
1012         uint256 initialETHBalance = address(this).balance;
1013  
1014         swapTokensForEth(amountToSwapForETH);
1015  
1016         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1017  
1018         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1019             totalTokensToSwap
1020         );
1021         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1022  
1023         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1024  
1025         tokensForLiquidity = 0;
1026         tokensForMarketing = 0;
1027         tokensForDev = 0;
1028  
1029         (success, ) = address(developmentWallet).call{value: ethForDev}("");
1030  
1031         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1032             addLiquidity(liquidityTokens, ethForLiquidity);
1033             emit SwapAndLiquify(
1034                 amountToSwapForETH,
1035                 ethForLiquidity,
1036                 tokensForLiquidity
1037             );
1038         }
1039  
1040         (success, ) = address(marketingWallet).call{
1041             value: address(this).balance
1042         }("");
1043     }
1044  
1045     function setAutoLPBurnSettings(
1046         uint256 _frequencyInSeconds,
1047         uint256 _percent,
1048         bool _Enabled
1049     ) external onlyOwner {
1050         require(
1051             _frequencyInSeconds >= 600,
1052             "cannot set buyback more often than every 10 minutes"
1053         );
1054         require(
1055             _percent <= 1000 && _percent >= 0,
1056             "Must set auto LP burn percent between 0% and 10%"
1057         );
1058         lpBurnFrequency = _frequencyInSeconds;
1059         percentForLPBurn = _percent;
1060         lpBurnEnabled = _Enabled;
1061     }
1062  
1063     function autoBurnLiquidityPairTokens() internal returns (bool) {
1064         lastLpBurnTime = block.timestamp;
1065  
1066         // get balance of liquidity pair
1067         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1068  
1069         // calculate amount to burn
1070         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1071             10000
1072         );
1073  
1074         // pull tokens from pancakePair liquidity and move to dead address permanently
1075         if (amountToBurn > 0) {
1076             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1077         }
1078  
1079         //sync price since this is not in a swap transaction!
1080         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1081         pair.sync();
1082         emit AutoNukeLP();
1083         return true;
1084     }
1085  
1086     function manualBurnLiquidityPairTokens(uint256 percent)
1087         external
1088         onlyOwner
1089         returns (bool)
1090     {
1091         require(
1092             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1093             "Must wait for cooldown to finish"
1094         );
1095         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1096         lastManualLpBurnTime = block.timestamp;
1097  
1098         // get balance of liquidity pair
1099         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1100  
1101         // calculate amount to burn
1102         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1103  
1104         // pull tokens from pancakePair liquidity and move to dead address permanently
1105         if (amountToBurn > 0) {
1106             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1107         }
1108  
1109         //sync price since this is not in a swap transaction!
1110         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1111         pair.sync();
1112         emit ManualNukeLP();
1113         return true;
1114     }
1115 }