1 /*         
2 
3     You don't want to miss $ME
4 ‍
5     We've all Missed Everything in the past, but now is our opportunity to seize the moment and soar to the moon, together as one!
6 
7     Tax : 0/0 
8 
9     https://t.me/MEtokenETH
10 
11     https://twitter.com/MetokenETH
12 
13     https://MissedEverything.com
14 */
15 
16 // SPDX-License-Identifier: MIT
17 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
18 pragma experimental ABIEncoderV2;
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 abstract contract Ownable is Context {
31     address private _owner;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     constructor() {
36         _transferOwnership(_msgSender());
37     }
38 
39     function owner() public view virtual returns (address) {
40         return _owner;
41     }
42 
43     modifier onlyOwner() {
44         require(owner() == _msgSender(), "Ownable: caller is not the owner");
45         _;
46     }
47 
48 
49     function renounceOwnership() public virtual onlyOwner {
50         _transferOwnership(address(0));
51     }
52 
53     function transferOwnership(address newOwner) public virtual onlyOwner {
54         require(newOwner != address(0), "Ownable: new owner is the zero address");
55         _transferOwnership(newOwner);
56     }
57 
58 
59     function _transferOwnership(address newOwner) internal virtual {
60         address oldOwner = _owner;
61         _owner = newOwner;
62         emit OwnershipTransferred(oldOwner, newOwner);
63     }
64 }
65 
66 interface IERC20 {
67 
68     function totalSupply() external view returns (uint256);
69 
70     function balanceOf(address account) external view returns (uint256);
71 
72 
73     function transfer(address recipient, uint256 amount) external returns (bool);
74 
75 
76     function allowance(address owner, address spender) external view returns (uint256);
77 
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80 
81     function transferFrom(
82         address sender,
83         address recipient,
84         uint256 amount
85     ) external returns (bool);
86 
87 
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 interface IERC20Metadata is IERC20 {
94 
95     function name() external view returns (string memory);
96 
97     function symbol() external view returns (string memory);
98 
99     function decimals() external view returns (uint8);
100 }
101 
102 
103 contract ERC20 is Context, IERC20, IERC20Metadata {
104     mapping(address => uint256) private _balances;
105 
106     mapping(address => mapping(address => uint256)) private _allowances;
107 
108     uint256 private _totalSupply;
109 
110     string private _name;
111     string private _symbol;
112 
113 
114     constructor(string memory name_, string memory symbol_) {
115         _name = name_;
116         _symbol = symbol_;
117     }
118 
119 
120     function name() public view virtual override returns (string memory) {
121         return _name;
122     }
123 
124 
125     function symbol() public view virtual override returns (string memory) {
126         return _symbol;
127     }
128 
129 
130     function decimals() public view virtual override returns (uint8) {
131         return 18;
132     }
133 
134 
135     function totalSupply() public view virtual override returns (uint256) {
136         return _totalSupply;
137     }
138 
139     function balanceOf(address account) public view virtual override returns (uint256) {
140         return _balances[account];
141     }
142 
143     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
144         _transfer(_msgSender(), recipient, amount);
145         return true;
146     }
147 
148 
149     function allowance(address owner, address spender) public view virtual override returns (uint256) {
150         return _allowances[owner][spender];
151     }
152 
153     function approve(address spender, uint256 amount) public virtual override returns (bool) {
154         _approve(_msgSender(), spender, amount);
155         return true;
156     }
157 
158     function transferFrom(
159         address sender,
160         address recipient,
161         uint256 amount
162     ) public virtual override returns (bool) {
163         _transfer(sender, recipient, amount);
164 
165         uint256 currentAllowance = _allowances[sender][_msgSender()];
166         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
167         unchecked {
168             _approve(sender, _msgSender(), currentAllowance - amount);
169         }
170 
171         return true;
172     }
173 
174     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
175         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
176         return true;
177     }
178 
179     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
180         uint256 currentAllowance = _allowances[_msgSender()][spender];
181         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
182         unchecked {
183             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
184         }
185 
186         return true;
187     }
188 
189     function _transfer(
190         address sender,
191         address recipient,
192         uint256 amount
193     ) internal virtual {
194         require(sender != address(0), "ERC20: transfer from the zero address");
195         require(recipient != address(0), "ERC20: transfer to the zero address");
196 
197         _beforeTokenTransfer(sender, recipient, amount);
198 
199         uint256 senderBalance = _balances[sender];
200         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
201         unchecked {
202             _balances[sender] = senderBalance - amount;
203         }
204         _balances[recipient] += amount;
205 
206         emit Transfer(sender, recipient, amount);
207 
208         _afterTokenTransfer(sender, recipient, amount);
209     }
210 
211     function _mint(address account, uint256 amount) internal virtual {
212         require(account != address(0), "ERC20: mint to the zero address");
213 
214         _beforeTokenTransfer(address(0), account, amount);
215 
216         _totalSupply += amount;
217         _balances[account] += amount;
218         emit Transfer(address(0), account, amount);
219 
220         _afterTokenTransfer(address(0), account, amount);
221     }
222 
223     function _burn(address account, uint256 amount) internal virtual {
224         require(account != address(0), "ERC20: burn from the zero address");
225 
226         _beforeTokenTransfer(account, address(0), amount);
227 
228         uint256 accountBalance = _balances[account];
229         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
230         unchecked {
231             _balances[account] = accountBalance - amount;
232         }
233         _totalSupply -= amount;
234 
235         emit Transfer(account, address(0), amount);
236 
237         _afterTokenTransfer(account, address(0), amount);
238     }
239 
240     function _approve(
241         address owner,
242         address spender,
243         uint256 amount
244     ) internal virtual {
245         require(owner != address(0), "ERC20: approve from the zero address");
246         require(spender != address(0), "ERC20: approve to the zero address");
247 
248         _allowances[owner][spender] = amount;
249         emit Approval(owner, spender, amount);
250     }
251 
252     function _beforeTokenTransfer(
253         address from,
254         address to,
255         uint256 amount
256     ) internal virtual {}
257 
258     function _afterTokenTransfer(
259         address from,
260         address to,
261         uint256 amount
262     ) internal virtual {}
263 }
264 
265 
266 library SafeMath {
267 
268     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
269         unchecked {
270             uint256 c = a + b;
271             if (c < a) return (false, 0);
272             return (true, c);
273         }
274     }
275 
276     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
277         unchecked {
278             if (b > a) return (false, 0);
279             return (true, a - b);
280         }
281     }
282 
283 
284     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
285         unchecked {
286             if (a == 0) return (true, 0);
287             uint256 c = a * b;
288             if (c / a != b) return (false, 0);
289             return (true, c);
290         }
291     }
292 
293     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
294         unchecked {
295             if (b == 0) return (false, 0);
296             return (true, a / b);
297         }
298     }
299 
300     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
301         unchecked {
302             if (b == 0) return (false, 0);
303             return (true, a % b);
304         }
305     }
306 
307 
308     function add(uint256 a, uint256 b) internal pure returns (uint256) {
309         return a + b;
310     }
311 
312     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
313         return a - b;
314     }
315 
316     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
317         return a * b;
318     }
319 
320     function div(uint256 a, uint256 b) internal pure returns (uint256) {
321         return a / b;
322     }
323 
324     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
325         return a % b;
326     }
327 
328     function sub(
329         uint256 a,
330         uint256 b,
331         string memory errorMessage
332     ) internal pure returns (uint256) {
333         unchecked {
334             require(b <= a, errorMessage);
335             return a - b;
336         }
337     }
338 
339     function div(
340         uint256 a,
341         uint256 b,
342         string memory errorMessage
343     ) internal pure returns (uint256) {
344         unchecked {
345             require(b > 0, errorMessage);
346             return a / b;
347         }
348     }
349 
350 
351     function mod(
352         uint256 a,
353         uint256 b,
354         string memory errorMessage
355     ) internal pure returns (uint256) {
356         unchecked {
357             require(b > 0, errorMessage);
358             return a % b;
359         }
360     }
361 }
362 
363 
364 interface IUniswapV2Factory {
365     event PairCreated(
366         address indexed token0,
367         address indexed token1,
368         address pair,
369         uint256
370     );
371 
372     function feeTo() external view returns (address);
373 
374     function feeToSetter() external view returns (address);
375 
376     function getPair(address tokenA, address tokenB)
377         external
378         view
379         returns (address pair);
380 
381     function allPairs(uint256) external view returns (address pair);
382 
383     function allPairsLength() external view returns (uint256);
384 
385     function createPair(address tokenA, address tokenB)
386         external
387         returns (address pair);
388 
389     function setFeeTo(address) external;
390 
391     function setFeeToSetter(address) external;
392 }
393 
394 
395 interface IUniswapV2Pair {
396     event Approval(
397         address indexed owner,
398         address indexed spender,
399         uint256 value
400     );
401     event Transfer(address indexed from, address indexed to, uint256 value);
402 
403     function name() external pure returns (string memory);
404 
405     function symbol() external pure returns (string memory);
406 
407     function decimals() external pure returns (uint8);
408 
409     function totalSupply() external view returns (uint256);
410 
411     function balanceOf(address owner) external view returns (uint256);
412 
413     function allowance(address owner, address spender)
414         external
415         view
416         returns (uint256);
417 
418     function approve(address spender, uint256 value) external returns (bool);
419 
420     function transfer(address to, uint256 value) external returns (bool);
421 
422     function transferFrom(
423         address from,
424         address to,
425         uint256 value
426     ) external returns (bool);
427 
428     function DOMAIN_SEPARATOR() external view returns (bytes32);
429 
430     function PERMIT_TYPEHASH() external pure returns (bytes32);
431 
432     function nonces(address owner) external view returns (uint256);
433 
434     function permit(
435         address owner,
436         address spender,
437         uint256 value,
438         uint256 deadline,
439         uint8 v,
440         bytes32 r,
441         bytes32 s
442     ) external;
443 
444     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
445     event Burn(
446         address indexed sender,
447         uint256 amount0,
448         uint256 amount1,
449         address indexed to
450     );
451     event Swap(
452         address indexed sender,
453         uint256 amount0In,
454         uint256 amount1In,
455         uint256 amount0Out,
456         uint256 amount1Out,
457         address indexed to
458     );
459     event Sync(uint112 reserve0, uint112 reserve1);
460 
461     function MINIMUM_LIQUIDITY() external pure returns (uint256);
462 
463     function factory() external view returns (address);
464 
465     function token0() external view returns (address);
466 
467     function token1() external view returns (address);
468 
469     function getReserves()
470         external
471         view
472         returns (
473             uint112 reserve0,
474             uint112 reserve1,
475             uint32 blockTimestampLast
476         );
477 
478     function price0CumulativeLast() external view returns (uint256);
479 
480     function price1CumulativeLast() external view returns (uint256);
481 
482     function kLast() external view returns (uint256);
483 
484     function mint(address to) external returns (uint256 liquidity);
485 
486     function burn(address to)
487         external
488         returns (uint256 amount0, uint256 amount1);
489 
490     function swap(
491         uint256 amount0Out,
492         uint256 amount1Out,
493         address to,
494         bytes calldata data
495     ) external;
496 
497     function skim(address to) external;
498 
499     function sync() external;
500 
501     function initialize(address, address) external;
502 }
503 
504 
505 interface IUniswapV2Router02 {
506     function factory() external pure returns (address);
507 
508     function WETH() external pure returns (address);
509 
510     function addLiquidity(
511         address tokenA,
512         address tokenB,
513         uint256 amountADesired,
514         uint256 amountBDesired,
515         uint256 amountAMin,
516         uint256 amountBMin,
517         address to,
518         uint256 deadline
519     )
520         external
521         returns (
522             uint256 amountA,
523             uint256 amountB,
524             uint256 liquidity
525         );
526 
527     function addLiquidityETH(
528         address token,
529         uint256 amountTokenDesired,
530         uint256 amountTokenMin,
531         uint256 amountETHMin,
532         address to,
533         uint256 deadline
534     )
535         external
536         payable
537         returns (
538             uint256 amountToken,
539             uint256 amountETH,
540             uint256 liquidity
541         );
542 
543     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
544         uint256 amountIn,
545         uint256 amountOutMin,
546         address[] calldata path,
547         address to,
548         uint256 deadline
549     ) external;
550 
551     function swapExactETHForTokensSupportingFeeOnTransferTokens(
552         uint256 amountOutMin,
553         address[] calldata path,
554         address to,
555         uint256 deadline
556     ) external payable;
557 
558     function swapExactTokensForETHSupportingFeeOnTransferTokens(
559         uint256 amountIn,
560         uint256 amountOutMin,
561         address[] calldata path,
562         address to,
563         uint256 deadline
564     ) external;
565 }
566 
567 
568 contract MissedEverything is ERC20, Ownable {
569     using SafeMath for uint256;
570 
571     IUniswapV2Router02 public immutable uniswapV2Router;
572     address public immutable uniswapV2Pair;
573     address public constant deadAddress = address(0xdead);
574 
575     bool private swapping;
576 
577     address private marketingWallet;
578     address private developmentWallet;
579 
580     uint256 public maxTransactionAmount;
581     uint256 public swapTokensAtAmount;
582     uint256 public maxWallet;
583 
584     uint256 public percentForLPBurn = 0; 
585     bool public lpBurnEnabled = false;
586     uint256 public lpBurnFrequency = 3600 seconds;
587     uint256 public lastLpBurnTime;
588 
589     uint256 public manualBurnFrequency = 30 minutes;
590     uint256 public lastManualLpBurnTime;
591 
592     bool public limitsInEffect = true;
593     bool public tradingActive = false;
594     bool public swapEnabled = true;
595 
596     mapping(address => uint256) private _holderLastTransferTimestamp; 
597     bool public transferDelayEnabled = true;
598 
599     uint256 public buyTotalFees;
600     uint256 public buyMarketingFee;
601     uint256 public buyLiquidityFee;
602     uint256 public buyDevelopmentFee;
603 
604     uint256 public sellTotalFees;
605     uint256 public sellMarketingFee;
606     uint256 public sellLiquidityFee;
607     uint256 public sellDevelopmentFee;
608 
609     uint256 public tokensForMarketing;
610     uint256 public tokensForLiquidity;
611     uint256 public tokensForDev;
612 
613     mapping(address => bool) private _isExcludedFromFees;
614     mapping(address => bool) public _isExcludedMaxTransactionAmount;
615 
616     mapping(address => bool) public automatedMarketMakerPairs;
617 
618     event UpdateUniswapV2Router(
619         address indexed newAddress,
620         address indexed oldAddress
621     );
622 
623     event ExcludeFromFees(address indexed account, bool isExcluded);
624 
625     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
626 
627     event marketingWalletUpdated(
628         address indexed newWallet,
629         address indexed oldWallet
630     );
631 
632     event developmentWalletUpdated(
633         address indexed newWallet,
634         address indexed oldWallet
635     );
636 
637     event SwapAndLiquify(
638         uint256 tokensSwapped,
639         uint256 ethReceived,
640         uint256 tokensIntoLiquidity
641     );
642 
643     event AutoNukeLP();
644 
645     event ManualNukeLP();
646 
647     constructor() ERC20("Missed Everything", "ME") {
648         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
649             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
650         );
651 
652         excludeFromMaxTransaction(address(_uniswapV2Router), true);
653         uniswapV2Router = _uniswapV2Router;
654 
655         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
656             .createPair(address(this), _uniswapV2Router.WETH());
657         excludeFromMaxTransaction(address(uniswapV2Pair), true);
658         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
659 
660         uint256 _buyMarketingFee = 20;
661         uint256 _buyLiquidityFee = 0;
662         uint256 _buyDevelopmentFee = 0;
663 
664         uint256 _sellMarketingFee = 30;
665         uint256 _sellLiquidityFee = 0;
666         uint256 _sellDevelopmentFee = 0;
667 
668         uint256 totalSupply = 1000000000 * 1e18;
669 
670         maxTransactionAmount = 20000000 * 1e18; 
671         maxWallet = 20000000 * 1e18; 
672         swapTokensAtAmount = (totalSupply * 10) / 10000;
673 
674         buyMarketingFee = _buyMarketingFee;
675         buyLiquidityFee = _buyLiquidityFee;
676         buyDevelopmentFee = _buyDevelopmentFee;
677         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
678 
679         sellMarketingFee = _sellMarketingFee;
680         sellLiquidityFee = _sellLiquidityFee;
681         sellDevelopmentFee = _sellDevelopmentFee;
682         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
683 
684         marketingWallet = address(0x952453F829170e38E5465ea85a870eAAFD3783a4); 
685         developmentWallet = address(0x952453F829170e38E5465ea85a870eAAFD3783a4); 
686 
687         excludeFromFees(owner(), true);
688         excludeFromFees(address(this), true);
689         excludeFromFees(address(0xdead), true);
690 
691         excludeFromMaxTransaction(owner(), true);
692         excludeFromMaxTransaction(address(this), true);
693         excludeFromMaxTransaction(address(0xdead), true);
694 
695         _mint(msg.sender, totalSupply);
696     }
697 
698     receive() external payable {}
699 
700     function enableTrading() external onlyOwner {
701         tradingActive = true;
702         swapEnabled = true;
703         lastLpBurnTime = block.timestamp;
704     }
705 
706     function removeLimits() external onlyOwner returns (bool) {
707         limitsInEffect = false;
708         return true;
709     }
710 
711     function disableTransferDelay() external onlyOwner returns (bool) {
712         transferDelayEnabled = false;
713         return true;
714     }
715 
716     function updateSwapTokensAtAmount(uint256 newAmount)
717         external
718         onlyOwner
719         returns (bool)
720     {
721         require(
722             newAmount >= (totalSupply() * 1) / 100000,
723             "Swap amount cannot be lower than 0.001% total supply."
724         );
725         require(
726             newAmount <= (totalSupply() * 5) / 1000,
727             "Swap amount cannot be higher than 0.5% total supply."
728         );
729         swapTokensAtAmount = newAmount;
730         return true;
731     }
732 
733     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
734         require(
735             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
736             "Cannot set maxTransactionAmount lower than 0.1%"
737         );
738         maxTransactionAmount = newNum * (10**18);
739     }
740 
741     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
742         require(
743             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
744             "Cannot set maxWallet lower than 0.5%"
745         );
746         maxWallet = newNum * (10**18);
747     }
748 
749     function excludeFromMaxTransaction(address updAds, bool isEx)
750         public
751         onlyOwner
752     {
753         _isExcludedMaxTransactionAmount[updAds] = isEx;
754     }
755 
756     function updateSwapEnabled(bool enabled) external onlyOwner {
757         swapEnabled = enabled;
758     }
759 
760     function updateBuyFees(
761         uint256 _marketingFee,
762         uint256 _liquidityFee,
763         uint256 _developmentFee
764     ) external onlyOwner {
765         buyMarketingFee = _marketingFee;
766         buyLiquidityFee = _liquidityFee;
767         buyDevelopmentFee = _developmentFee;
768         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
769         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
770     }
771 
772     function updateSellFees(
773         uint256 _marketingFee,
774         uint256 _liquidityFee,
775         uint256 _developmentFee
776     ) external onlyOwner {
777         sellMarketingFee = _marketingFee;
778         sellLiquidityFee = _liquidityFee;
779         sellDevelopmentFee = _developmentFee;
780         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
781         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
782     }
783 
784     function excludeFromFees(address account, bool excluded) public onlyOwner {
785         _isExcludedFromFees[account] = excluded;
786         emit ExcludeFromFees(account, excluded);
787     }
788 
789     function setAutomatedMarketMakerPair(address pair, bool value)
790         public
791         onlyOwner
792     {
793         require(
794             pair != uniswapV2Pair,
795             "The pair cannot be removed from automatedMarketMakerPairs"
796         );
797 
798         _setAutomatedMarketMakerPair(pair, value);
799     }
800 
801     function _setAutomatedMarketMakerPair(address pair, bool value) private {
802         automatedMarketMakerPairs[pair] = value;
803 
804         emit SetAutomatedMarketMakerPair(pair, value);
805     }
806 
807     function updateMarketingWalletInfo(address newMarketingWallet)
808         external
809         onlyOwner
810     {
811         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
812         marketingWallet = newMarketingWallet;
813     }
814 
815     function updateDevelopmentWalletInfo(address newWallet) external onlyOwner {
816         emit developmentWalletUpdated(newWallet, developmentWallet);
817         developmentWallet = newWallet;
818     }
819 
820     function isExcludedFromFees(address account) public view returns (bool) {
821         return _isExcludedFromFees[account];
822     }
823 
824     event BoughtEarly(address indexed sniper);
825 
826     function _transfer(
827         address from,
828         address to,
829         uint256 amount
830     ) internal override {
831         require(from != address(0), "ERC20: transfer from the zero address");
832         require(to != address(0), "ERC20: transfer to the zero address");
833 
834         if (amount == 0) {
835             super._transfer(from, to, 0);
836             return;
837         }
838 
839         if (limitsInEffect) {
840             if (
841                 from != owner() &&
842                 to != owner() &&
843                 to != address(0) &&
844                 to != address(0xdead) &&
845                 !swapping
846             ) {
847                 if (!tradingActive) {
848                     require(
849                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
850                         "Trading is not active."
851                     );
852                 }
853 
854                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
855                 if (transferDelayEnabled) {
856                     if (
857                         to != owner() &&
858                         to != address(uniswapV2Router) &&
859                         to != address(uniswapV2Pair)
860                     ) {
861                         require(
862                             _holderLastTransferTimestamp[tx.origin] <
863                                 block.number,
864                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
865                         );
866                         _holderLastTransferTimestamp[tx.origin] = block.number;
867                     }
868                 }
869 
870                 //when buy
871                 if (
872                     automatedMarketMakerPairs[from] &&
873                     !_isExcludedMaxTransactionAmount[to]
874                 ) {
875                     require(
876                         amount <= maxTransactionAmount,
877                         "Buy transfer amount exceeds the maxTransactionAmount."
878                     );
879                     require(
880                         amount + balanceOf(to) <= maxWallet,
881                         "Max wallet exceeded"
882                     );
883                 }
884                 //when sell
885                 else if (
886                     automatedMarketMakerPairs[to] &&
887                     !_isExcludedMaxTransactionAmount[from]
888                 ) {
889                     require(
890                         amount <= maxTransactionAmount,
891                         "Sell transfer amount exceeds the maxTransactionAmount."
892                     );
893                 } else if (!_isExcludedMaxTransactionAmount[to]) {
894                     require(
895                         amount + balanceOf(to) <= maxWallet,
896                         "Max wallet exceeded"
897                     );
898                 }
899             }
900         }
901 
902         uint256 contractTokenBalance = balanceOf(address(this));
903 
904         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
905 
906         if (
907             canSwap &&
908             swapEnabled &&
909             !swapping &&
910             !automatedMarketMakerPairs[from] &&
911             !_isExcludedFromFees[from] &&
912             !_isExcludedFromFees[to]
913         ) {
914             swapping = true;
915 
916             swapBack();
917 
918             swapping = false;
919         }
920 
921         if (
922             !swapping &&
923             automatedMarketMakerPairs[to] &&
924             lpBurnEnabled &&
925             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
926             !_isExcludedFromFees[from]
927         ) {
928             autoBurnLiquidityPairTokens();
929         }
930 
931         bool takeFee = !swapping;
932 
933         // if any account belongs to _isExcludedFromFee account then remove the fee
934         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
935             takeFee = false;
936         }
937 
938         uint256 fees = 0;
939         // only take fees on buys/sells, do not take on wallet transfers
940         if (takeFee) {
941             // on sell
942             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
943                 fees = amount.mul(sellTotalFees).div(100);
944                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
945                 tokensForDev += (fees * sellDevelopmentFee) / sellTotalFees;
946                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
947             }
948             // on buy
949             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
950                 fees = amount.mul(buyTotalFees).div(100);
951                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
952                 tokensForDev += (fees * buyDevelopmentFee) / buyTotalFees;
953                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
954             }
955 
956             if (fees > 0) {
957                 super._transfer(from, address(this), fees);
958             }
959 
960             amount -= fees;
961         }
962 
963         super._transfer(from, to, amount);
964     }
965 
966     function swapTokensForEth(uint256 tokenAmount) private {
967         // generate the uniswap pair path of token -> weth
968         address[] memory path = new address[](2);
969         path[0] = address(this);
970         path[1] = uniswapV2Router.WETH();
971 
972         _approve(address(this), address(uniswapV2Router), tokenAmount);
973 
974         // make the swap
975         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
976             tokenAmount,
977             0, // accept any amount of ETH
978             path,
979             address(this),
980             block.timestamp
981         );
982     }
983 
984     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
985         // approve token transfer to cover all possible scenarios
986         _approve(address(this), address(uniswapV2Router), tokenAmount);
987 
988         // add the liquidity
989         uniswapV2Router.addLiquidityETH{value: ethAmount}(
990             address(this),
991             tokenAmount,
992             0, // slippage is unavoidable
993             0, // slippage is unavoidable
994             deadAddress,
995             block.timestamp
996         );
997     }
998 
999     function swapBack() private {
1000         uint256 contractBalance = balanceOf(address(this));
1001         uint256 totalTokensToSwap = tokensForLiquidity +
1002             tokensForMarketing +
1003             tokensForDev;
1004         bool success;
1005 
1006         if (contractBalance == 0 || totalTokensToSwap == 0) {
1007             return;
1008         }
1009 
1010         if (contractBalance > swapTokensAtAmount * 20) {
1011             contractBalance = swapTokensAtAmount * 20;
1012         }
1013 
1014         // Halve the amount of liquidity tokens
1015         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1016             totalTokensToSwap /
1017             2;
1018         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1019 
1020         uint256 initialETHBalance = address(this).balance;
1021 
1022         swapTokensForEth(amountToSwapForETH);
1023 
1024         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1025 
1026         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1027             totalTokensToSwap
1028         );
1029         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1030 
1031         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1032 
1033         tokensForLiquidity = 0;
1034         tokensForMarketing = 0;
1035         tokensForDev = 0;
1036 
1037         (success, ) = address(developmentWallet).call{value: ethForDev}("");
1038 
1039         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1040             addLiquidity(liquidityTokens, ethForLiquidity);
1041             emit SwapAndLiquify(
1042                 amountToSwapForETH,
1043                 ethForLiquidity,
1044                 tokensForLiquidity
1045             );
1046         }
1047 
1048         (success, ) = address(marketingWallet).call{
1049             value: address(this).balance
1050         }("");
1051     }
1052 
1053     function setAutoLPBurnSettings(
1054         uint256 _frequencyInSeconds,
1055         uint256 _percent,
1056         bool _Enabled
1057     ) external onlyOwner {
1058         require(
1059             _frequencyInSeconds >= 600,
1060             "cannot set buyback more often than every 10 minutes"
1061         );
1062         require(
1063             _percent <= 1000 && _percent >= 0,
1064             "Must set auto LP burn percent between 0% and 10%"
1065         );
1066         lpBurnFrequency = _frequencyInSeconds;
1067         percentForLPBurn = _percent;
1068         lpBurnEnabled = _Enabled;
1069     }
1070 
1071     function autoBurnLiquidityPairTokens() internal returns (bool) {
1072         lastLpBurnTime = block.timestamp;
1073 
1074         // get balance of liquidity pair
1075         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1076 
1077         // calculate amount to burn
1078         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1079             10000
1080         );
1081 
1082         // pull tokens from pancakePair liquidity and move to dead address permanently
1083         if (amountToBurn > 0) {
1084             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1085         }
1086 
1087         //sync price since this is not in a swap transaction!
1088         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1089         pair.sync();
1090         emit AutoNukeLP();
1091         return true;
1092     }
1093 
1094     function manualBurnLiquidityPairTokens(uint256 percent)
1095         external
1096         onlyOwner
1097         returns (bool)
1098     {
1099         require(
1100             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1101             "Must wait for cooldown to finish"
1102         );
1103         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1104         lastManualLpBurnTime = block.timestamp;
1105 
1106         // get balance of liquidity pair
1107         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1108 
1109         // calculate amount to burn
1110         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1111 
1112         // pull tokens from pancakePair liquidity and move to dead address permanently
1113         if (amountToBurn > 0) {
1114             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1115         }
1116 
1117         //sync price since this is not in a swap transaction!
1118         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1119         pair.sync();
1120         emit ManualNukeLP();
1121         return true;
1122     }
1123 }