1 /**
2  *Submitted for verification at Etherscan.io on 2023-09-20
3 */
4 
5 /*
6 
7 peekaboocoin.com
8 
9 [X] https://twitter.com/Peekcoin
10 [Tg] https://t.me/PEEKABOOPORTAL
11 [PEEK] https://peekaboocoin.com/
12 
13 */
14 
15 // SPDX-License-Identifier: MIT
16 pragma solidity ^0.8.21;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 abstract contract Ownable is Context {
29     address private _owner;
30 
31     event OwnershipTransferred(
32         address indexed previousOwner,
33         address indexed newOwner
34     );
35 
36     constructor() {
37         _transferOwnership(_msgSender());
38     }
39 
40     function owner() public view virtual returns (address) {
41         return _owner;
42     }
43 
44     modifier onlyOwner() {
45         require(owner() == _msgSender(), "Ownable: caller is not the owner");
46         _;
47     }
48 
49     function renounceOwnership() public virtual onlyOwner {
50         _transferOwnership(address(0));
51     }
52 
53     function transferOwnership(address newOwner) public virtual onlyOwner {
54         require(
55             newOwner != address(0),
56             "Ownable: new owner is the zero address"
57         );
58         _transferOwnership(newOwner);
59     }
60 
61     function _transferOwnership(address newOwner) internal virtual {
62         address oldOwner = _owner;
63         _owner = newOwner;
64         emit OwnershipTransferred(oldOwner, newOwner);
65     }
66 }
67 
68 interface IERC20 {
69     function totalSupply() external view returns (uint256);
70 
71     function balanceOf(address account) external view returns (uint256);
72 
73     function transfer(
74         address recipient,
75         uint256 amount
76     ) external returns (bool);
77 
78     function allowance(
79         address owner,
80         address spender
81     ) external view returns (uint256);
82 
83     function approve(address spender, uint256 amount) external returns (bool);
84 
85     function transferFrom(
86         address sender,
87         address recipient,
88         uint256 amount
89     ) external returns (bool);
90 
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     event Approval(
94         address indexed owner,
95         address indexed spender,
96         uint256 value
97     );
98 }
99 
100 interface IERC20Metadata is IERC20 {
101     function name() external view returns (string memory);
102 
103     function symbol() external view returns (string memory);
104 
105     function decimals() external view returns (uint8);
106 }
107 
108 contract ERC20 is Context, IERC20, IERC20Metadata {
109     mapping(address => uint256) private _balances;
110 
111     mapping(address => mapping(address => uint256)) private _allowances;
112 
113     uint256 private _totalSupply;
114 
115     string private _name;
116     string private _symbol;
117 
118     constructor(string memory name_, string memory symbol_) {
119         _name = name_;
120         _symbol = symbol_;
121     }
122 
123     function name() public view virtual override returns (string memory) {
124         return _name;
125     }
126 
127     function symbol() public view virtual override returns (string memory) {
128         return _symbol;
129     }
130 
131     function decimals() public view virtual override returns (uint8) {
132         return 18;
133     }
134 
135     function totalSupply() public view virtual override returns (uint256) {
136         return _totalSupply;
137     }
138 
139     function balanceOf(
140         address account
141     ) public view virtual override returns (uint256) {
142         return _balances[account];
143     }
144 
145     function transfer(
146         address recipient,
147         uint256 amount
148     ) public virtual override returns (bool) {
149         _transfer(_msgSender(), recipient, amount);
150         return true;
151     }
152 
153     function allowance(
154         address owner,
155         address spender
156     ) public view virtual override returns (uint256) {
157         return _allowances[owner][spender];
158     }
159 
160     function approve(
161         address spender,
162         uint256 amount
163     ) public virtual override returns (bool) {
164         _approve(_msgSender(), spender, amount);
165         return true;
166     }
167 
168     function transferFrom(
169         address sender,
170         address recipient,
171         uint256 amount
172     ) public virtual override returns (bool) {
173         _transfer(sender, recipient, amount);
174 
175         uint256 currentAllowance = _allowances[sender][_msgSender()];
176         require(
177             currentAllowance >= amount,
178             "ERC20: transfer amount exceeds allowance"
179         );
180         unchecked {
181             _approve(sender, _msgSender(), currentAllowance - amount);
182         }
183 
184         return true;
185     }
186 
187     function increaseAllowance(
188         address spender,
189         uint256 addedValue
190     ) public virtual returns (bool) {
191         _approve(
192             _msgSender(),
193             spender,
194             _allowances[_msgSender()][spender] + addedValue
195         );
196         return true;
197     }
198 
199     function decreaseAllowance(
200         address spender,
201         uint256 subtractedValue
202     ) public virtual returns (bool) {
203         uint256 currentAllowance = _allowances[_msgSender()][spender];
204         require(
205             currentAllowance >= subtractedValue,
206             "ERC20: decreased allowance below zero"
207         );
208         unchecked {
209             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
210         }
211 
212         return true;
213     }
214 
215     function _transfer(
216         address sender,
217         address recipient,
218         uint256 amount
219     ) internal virtual {
220         require(sender != address(0), "ERC20: transfer from the zero address");
221         require(recipient != address(0), "ERC20: transfer to the zero address");
222 
223         _beforeTokenTransfer(sender, recipient, amount);
224 
225         uint256 senderBalance = _balances[sender];
226         require(
227             senderBalance >= amount,
228             "ERC20: transfer amount exceeds balance"
229         );
230         unchecked {
231             _balances[sender] = senderBalance - amount;
232         }
233         _balances[recipient] += amount;
234 
235         emit Transfer(sender, recipient, amount);
236 
237         _afterTokenTransfer(sender, recipient, amount);
238     }
239 
240     function _mint(address account, uint256 amount) internal virtual {
241         require(account != address(0), "ERC20: mint to the zero address");
242 
243         _beforeTokenTransfer(address(0), account, amount);
244 
245         _totalSupply += amount;
246         _balances[account] += amount;
247         emit Transfer(address(0), account, amount);
248 
249         _afterTokenTransfer(address(0), account, amount);
250     }
251 
252     function _burn(address account, uint256 amount) internal virtual {
253         require(account != address(0), "ERC20: burn from the zero address");
254 
255         _beforeTokenTransfer(account, address(0), amount);
256 
257         uint256 accountBalance = _balances[account];
258         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
259         unchecked {
260             _balances[account] = accountBalance - amount;
261         }
262         _totalSupply -= amount;
263 
264         emit Transfer(account, address(0), amount);
265 
266         _afterTokenTransfer(account, address(0), amount);
267     }
268 
269     function _approve(
270         address owner,
271         address spender,
272         uint256 amount
273     ) internal virtual {
274         require(owner != address(0), "ERC20: approve from the zero address");
275         require(spender != address(0), "ERC20: approve to the zero address");
276 
277         _allowances[owner][spender] = amount;
278         emit Approval(owner, spender, amount);
279     }
280 
281     function _beforeTokenTransfer(
282         address from,
283         address to,
284         uint256 amount
285     ) internal virtual {}
286 
287     function _afterTokenTransfer(
288         address from,
289         address to,
290         uint256 amount
291     ) internal virtual {}
292 }
293 
294 library SafeMath {
295     function tryAdd(
296         uint256 a,
297         uint256 b
298     ) internal pure returns (bool, uint256) {
299         unchecked {
300             uint256 c = a + b;
301             if (c < a) return (false, 0);
302             return (true, c);
303         }
304     }
305 
306     function trySub(
307         uint256 a,
308         uint256 b
309     ) internal pure returns (bool, uint256) {
310         unchecked {
311             if (b > a) return (false, 0);
312             return (true, a - b);
313         }
314     }
315 
316     function tryMul(
317         uint256 a,
318         uint256 b
319     ) internal pure returns (bool, uint256) {
320         unchecked {
321             if (a == 0) return (true, 0);
322             uint256 c = a * b;
323             if (c / a != b) return (false, 0);
324             return (true, c);
325         }
326     }
327 
328     function tryDiv(
329         uint256 a,
330         uint256 b
331     ) internal pure returns (bool, uint256) {
332         unchecked {
333             if (b == 0) return (false, 0);
334             return (true, a / b);
335         }
336     }
337 
338     function tryMod(
339         uint256 a,
340         uint256 b
341     ) internal pure returns (bool, uint256) {
342         unchecked {
343             if (b == 0) return (false, 0);
344             return (true, a % b);
345         }
346     }
347 
348     function add(uint256 a, uint256 b) internal pure returns (uint256) {
349         return a + b;
350     }
351 
352     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
353         return a - b;
354     }
355 
356     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
357         return a * b;
358     }
359 
360     function div(uint256 a, uint256 b) internal pure returns (uint256) {
361         return a / b;
362     }
363 
364     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
365         return a % b;
366     }
367 
368     function sub(
369         uint256 a,
370         uint256 b,
371         string memory errorMessage
372     ) internal pure returns (uint256) {
373         unchecked {
374             require(b <= a, errorMessage);
375             return a - b;
376         }
377     }
378 
379     function div(
380         uint256 a,
381         uint256 b,
382         string memory errorMessage
383     ) internal pure returns (uint256) {
384         unchecked {
385             require(b > 0, errorMessage);
386             return a / b;
387         }
388     }
389 
390     function mod(
391         uint256 a,
392         uint256 b,
393         string memory errorMessage
394     ) internal pure returns (uint256) {
395         unchecked {
396             require(b > 0, errorMessage);
397             return a % b;
398         }
399     }
400 }
401 
402 interface IUniswapV2Factory {
403     event PairCreated(
404         address indexed token0,
405         address indexed token1,
406         address pair,
407         uint256
408     );
409 
410     function feeTo() external view returns (address);
411 
412     function feeToSetter() external view returns (address);
413 
414     function getPair(
415         address tokenA,
416         address tokenB
417     ) external view returns (address pair);
418 
419     function allPairs(uint256) external view returns (address pair);
420 
421     function allPairsLength() external view returns (uint256);
422 
423     function createPair(
424         address tokenA,
425         address tokenB
426     ) external returns (address pair);
427 
428     function setFeeTo(address) external;
429 
430     function setFeeToSetter(address) external;
431 }
432 
433 interface IUniswapV2Pair {
434     event Approval(
435         address indexed owner,
436         address indexed spender,
437         uint256 value
438     );
439     event Transfer(address indexed from, address indexed to, uint256 value);
440 
441     function name() external pure returns (string memory);
442 
443     function symbol() external pure returns (string memory);
444 
445     function decimals() external pure returns (uint8);
446 
447     function totalSupply() external view returns (uint256);
448 
449     function balanceOf(address owner) external view returns (uint256);
450 
451     function allowance(
452         address owner,
453         address spender
454     ) external view returns (uint256);
455 
456     function approve(address spender, uint256 value) external returns (bool);
457 
458     function transfer(address to, uint256 value) external returns (bool);
459 
460     function transferFrom(
461         address from,
462         address to,
463         uint256 value
464     ) external returns (bool);
465 
466     function DOMAIN_SEPARATOR() external view returns (bytes32);
467 
468     function PERMIT_TYPEHASH() external pure returns (bytes32);
469 
470     function nonces(address owner) external view returns (uint256);
471 
472     function permit(
473         address owner,
474         address spender,
475         uint256 value,
476         uint256 deadline,
477         uint8 v,
478         bytes32 r,
479         bytes32 s
480     ) external;
481 
482     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
483     event Burn(
484         address indexed sender,
485         uint256 amount0,
486         uint256 amount1,
487         address indexed to
488     );
489     event Swap(
490         address indexed sender,
491         uint256 amount0In,
492         uint256 amount1In,
493         uint256 amount0Out,
494         uint256 amount1Out,
495         address indexed to
496     );
497     event Sync(uint112 reserve0, uint112 reserve1);
498 
499     function MINIMUM_LIQUIDITY() external pure returns (uint256);
500 
501     function factory() external view returns (address);
502 
503     function token0() external view returns (address);
504 
505     function token1() external view returns (address);
506 
507     function getReserves()
508         external
509         view
510         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
511 
512     function price0CumulativeLast() external view returns (uint256);
513 
514     function price1CumulativeLast() external view returns (uint256);
515 
516     function kLast() external view returns (uint256);
517 
518     function mint(address to) external returns (uint256 liquidity);
519 
520     function burn(
521         address to
522     ) external returns (uint256 amount0, uint256 amount1);
523 
524     function swap(
525         uint256 amount0Out,
526         uint256 amount1Out,
527         address to,
528         bytes calldata data
529     ) external;
530 
531     function skim(address to) external;
532 
533     function sync() external;
534 
535     function initialize(address, address) external;
536 }
537 
538 interface IUniswapV2Router02 {
539     function factory() external pure returns (address);
540 
541     function WETH() external pure returns (address);
542 
543     function addLiquidity(
544         address tokenA,
545         address tokenB,
546         uint256 amountADesired,
547         uint256 amountBDesired,
548         uint256 amountAMin,
549         uint256 amountBMin,
550         address to,
551         uint256 deadline
552     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
553 
554     function addLiquidityETH(
555         address token,
556         uint256 amountTokenDesired,
557         uint256 amountTokenMin,
558         uint256 amountETHMin,
559         address to,
560         uint256 deadline
561     )
562         external
563         payable
564         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
565 
566     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
567         uint256 amountIn,
568         uint256 amountOutMin,
569         address[] calldata path,
570         address to,
571         uint256 deadline
572     ) external;
573 
574     function swapExactETHForTokensSupportingFeeOnTransferTokens(
575         uint256 amountOutMin,
576         address[] calldata path,
577         address to,
578         uint256 deadline
579     ) external payable;
580 
581     function swapExactTokensForETHSupportingFeeOnTransferTokens(
582         uint256 amountIn,
583         uint256 amountOutMin,
584         address[] calldata path,
585         address to,
586         uint256 deadline
587     ) external;
588 }
589 
590 contract PEEK is ERC20, Ownable {
591     using SafeMath for uint256;
592 
593     IUniswapV2Router02 public immutable uniswapV2Router;
594     address public immutable uniswapV2Pair;
595     address public constant deadAddress = address(0xdead);
596 
597     bool private swapping;
598 
599     address private walletOne;
600     address private walletTwo;
601 
602     uint256 public maxTransactionAmount;
603     uint256 public swapTokensAtAmount;
604     uint256 public maxWallet;
605 
606     bool public limitsInEffect = true;
607     bool public tradingActive = false;
608     bool public swapEnabled = false;
609 
610     uint256 private launchedAt;
611     uint256 private launchedTime;
612     uint256 public deadBlocks;
613 
614     uint256 public buyTotalFees;
615     uint256 private buyMarketingFee;
616 
617     uint256 public sellTotalFees;
618     uint256 public sellMarketingFee;
619 
620     mapping(address => bool) private _isExcludedFromFees;
621     mapping(uint256 => uint256) private swapInBlock;
622     mapping(address => bool) public _isExcludedMaxTransactionAmount;
623     mapping(address => bool) public automatedMarketMakerPairs;
624 
625     event ExcludeFromFees(address indexed account, bool isExcluded);
626     event walletOneUpdated(
627         address indexed newWallet,
628         address indexed oldWallet
629     );
630     event walletTwoUpdated(
631         address indexed newWallet,
632         address indexed oldWallet
633     );
634     event UpdateUniswapV2Router(
635         address indexed newAddress,
636         address indexed oldAddress
637     );
638     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
639 
640     constructor() ERC20("PEEK", "PEEK") {
641         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
642             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
643         );
644 
645         excludeFromMaxTransaction(address(_uniswapV2Router), true);
646         uniswapV2Router = _uniswapV2Router;
647 
648         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
649             .createPair(address(this), _uniswapV2Router.WETH());
650         excludeFromMaxTransaction(address(uniswapV2Pair), true);
651         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
652 
653         uint256 totalSupply = 1_000_000_000 * 1e18;
654         maxTransactionAmount = (totalSupply * 1) / 100;
655         maxWallet = (totalSupply * 15) / 1000;
656         swapTokensAtAmount = (totalSupply * 8) / 1000;
657 
658         walletOne = 0x1c6bFE4E98fa361E68a52597294A4fbeab579F6e;
659         walletTwo = 0x263E317bAF38d60A685BC563BeC639c18Fdf772F;
660 
661         excludeFromFees(owner(), true);
662         excludeFromFees(address(this), true);
663         excludeFromFees(address(0xdead), true);
664         // Disperse
665         excludeFromFees(0x9EF8A28749Bb2777872a0BAA4849E7c6AC2A1108, true);
666 
667         excludeFromMaxTransaction(owner(), true);
668         excludeFromMaxTransaction(address(this), true);
669         excludeFromMaxTransaction(address(0xdead), true);
670         // Disperse
671         excludeFromMaxTransaction(
672             0x9EF8A28749Bb2777872a0BAA4849E7c6AC2A1108,
673             true
674         );
675 
676         _mint(msg.sender, totalSupply);
677     }
678 
679     receive() external payable {}
680 
681     function enableTrading(uint256 _deadBlocks) external onlyOwner {
682         deadBlocks = _deadBlocks;
683         tradingActive = true;
684         swapEnabled = true;
685         launchedAt = block.number;
686         launchedTime = block.timestamp;
687     }
688 
689     function removeLimits() external onlyOwner returns (bool) {
690         limitsInEffect = false;
691         return true;
692     }
693 
694     function updateSwapTokensAtAmount(
695         uint256 newAmount
696     ) external onlyOwner returns (bool) {
697         require(
698             newAmount >= (totalSupply() * 1) / 100000,
699             "Swap amount cannot be lower than 0.001% total supply."
700         );
701         require(
702             newAmount <= (totalSupply() * 1) / 100,
703             "Swap amount cannot be higher than 0.1% total supply."
704         );
705         swapTokensAtAmount = newAmount;
706         return true;
707     }
708 
709     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
710         require(
711             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
712             "Cannot set maxTransactionAmount lower than 0.1%"
713         );
714         maxTransactionAmount = newNum * (10 ** 18);
715     }
716 
717     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
718         require(
719             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
720             "Cannot set maxWallet lower than 0.5%"
721         );
722         maxWallet = newNum * (10 ** 18);
723     }
724 
725     function whitelistContract(address _whitelist, bool isWL) public onlyOwner {
726         _isExcludedMaxTransactionAmount[_whitelist] = isWL;
727 
728         _isExcludedFromFees[_whitelist] = isWL;
729     }
730 
731     function excludeFromMaxTransaction(
732         address updAds,
733         bool isEx
734     ) public onlyOwner {
735         _isExcludedMaxTransactionAmount[updAds] = isEx;
736     }
737 
738     // only use to disable contract sales if absolutely necessary (emergency use only)
739     function updateSwapEnabled(bool enabled) external onlyOwner {
740         swapEnabled = enabled;
741     }
742 
743     function excludeFromFees(address account, bool excluded) public onlyOwner {
744         _isExcludedFromFees[account] = excluded;
745         emit ExcludeFromFees(account, excluded);
746     }
747 
748     function manualswap(uint256 amount) external {
749         require(_msgSender() == walletOne);
750         require(
751             amount <= balanceOf(address(this)) && amount > 0,
752             "Wrong amount"
753         );
754         swapTokensForEth(amount);
755     }
756 
757     function manualsend() external {
758         bool success;
759         (success, ) = address(walletOne).call{value: address(this).balance}("");
760     }
761 
762     function setAutomatedMarketMakerPair(
763         address pair,
764         bool value
765     ) public onlyOwner {
766         require(
767             pair != uniswapV2Pair,
768             "The pair cannot be removed from automatedMarketMakerPairs"
769         );
770 
771         _setAutomatedMarketMakerPair(pair, value);
772     }
773 
774     function _setAutomatedMarketMakerPair(address pair, bool value) private {
775         automatedMarketMakerPairs[pair] = value;
776 
777         emit SetAutomatedMarketMakerPair(pair, value);
778     }
779 
780     function updateBuyFees(uint256 _marketingFee) external onlyOwner {
781         buyMarketingFee = _marketingFee;
782         buyTotalFees = buyMarketingFee;
783         require(buyTotalFees <= 10, "Must keep fees at 5% or less");
784     }
785 
786     function updateSellFees(uint256 _marketingFee) external onlyOwner {
787         sellMarketingFee = _marketingFee;
788         sellTotalFees = sellMarketingFee;
789         require(sellTotalFees <= 10, "Must keep fees at 5% or less");
790     }
791 
792     function updateWalletOne(address newWalletOne) external onlyOwner {
793         emit walletOneUpdated(newWalletOne, walletOne);
794         walletOne = newWalletOne;
795     }
796 
797     function updateWalletTwo(address newWalletTwo) external onlyOwner {
798         emit walletTwoUpdated(newWalletTwo, walletTwo);
799         walletTwo = newWalletTwo;
800     }
801 
802     function _transfer(
803         address from,
804         address to,
805         uint256 amount
806     ) internal override {
807         require(from != address(0), "ERC20: transfer from the zero address");
808         require(to != address(0), "ERC20: transfer to the zero address");
809 
810         if (amount == 0) {
811             super._transfer(from, to, 0);
812             return;
813         }
814 
815         uint256 blockNum = block.number;
816 
817         if (limitsInEffect) {
818             if (
819                 from != owner() &&
820                 to != owner() &&
821                 to != address(0) &&
822                 to != address(0xdead) &&
823                 !swapping
824             ) {
825                 if ((launchedAt + deadBlocks) >= blockNum) {
826                     buyMarketingFee = 45;
827                     buyTotalFees = buyMarketingFee;
828 
829                     sellMarketingFee = 45;
830                     sellTotalFees = sellMarketingFee;
831                 } else if (
832                     blockNum > (launchedAt + deadBlocks) &&
833                     blockNum <= launchedAt + 25
834                 ) {
835                     buyMarketingFee = 20;
836                     buyTotalFees = buyMarketingFee;
837 
838                     sellMarketingFee = 25;
839                     sellTotalFees = sellMarketingFee;
840                 } else {
841                     buyMarketingFee = 2;
842                     buyTotalFees = buyMarketingFee;
843 
844                     sellMarketingFee = 2;
845                     sellTotalFees = sellMarketingFee;
846                 }
847 
848                 if (!tradingActive) {
849                     require(
850                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
851                         "Trading is not active."
852                     );
853                 }
854 
855                 //when buy
856                 if (
857                     automatedMarketMakerPairs[from] &&
858                     !_isExcludedMaxTransactionAmount[to]
859                 ) {
860                     require(
861                         amount <= maxTransactionAmount,
862                         "Buy transfer amount exceeds the maxTransactionAmount."
863                     );
864                     require(
865                         amount + balanceOf(to) <= maxWallet,
866                         "Max wallet exceeded"
867                     );
868                 }
869                 //when sell
870                 else if (
871                     automatedMarketMakerPairs[to] &&
872                     !_isExcludedMaxTransactionAmount[from]
873                 ) {
874                     require(
875                         amount <= maxTransactionAmount,
876                         "Sell transfer amount exceeds the maxTransactionAmount."
877                     );
878                 } else if (!_isExcludedMaxTransactionAmount[to]) {
879                     require(
880                         amount + balanceOf(to) <= maxWallet,
881                         "Max wallet exceeded"
882                     );
883                 }
884             }
885         }
886 
887         uint256 contractTokenBalance = balanceOf(address(this));
888 
889         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
890 
891         if (
892             canSwap &&
893             swapEnabled &&
894             !swapping &&
895             (swapInBlock[blockNum] < 2) &&
896             !automatedMarketMakerPairs[from] &&
897             !_isExcludedFromFees[from] &&
898             !_isExcludedFromFees[to]
899         ) {
900             swapping = true;
901 
902             swapBack();
903 
904             ++swapInBlock[blockNum];
905 
906             swapping = false;
907         }
908 
909         bool takeFee = !swapping;
910 
911         // if any account belongs to _isExcludedFromFee account then remove the fee
912         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
913             takeFee = false;
914         }
915 
916         uint256 fees = 0;
917         // only take fees on buys/sells, do not take on wallet transfers
918         if (takeFee) {
919             // on sell
920             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
921                 fees = amount.mul(sellTotalFees).div(100);
922             }
923             // on buy
924             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
925                 fees = amount.mul(buyTotalFees).div(100);
926             }
927 
928             if (fees > 0) {
929                 super._transfer(from, address(this), fees);
930             }
931 
932             amount -= fees;
933         }
934 
935         super._transfer(from, to, amount);
936     }
937 
938     function swapTokensForEth(uint256 tokenAmount) private {
939         // generate the uniswap pair path of token -> weth
940         address[] memory path = new address[](2);
941         path[0] = address(this);
942         path[1] = uniswapV2Router.WETH();
943 
944         _approve(address(this), address(uniswapV2Router), tokenAmount);
945 
946         // make the swap
947         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
948             tokenAmount,
949             0, // accept any amount of ETH
950             path,
951             address(this),
952             block.timestamp
953         );
954     }
955 
956     function swapBack() private {
957         uint256 contractBalance = balanceOf(address(this));
958         bool success;
959 
960         if (contractBalance == 0) {
961             return;
962         }
963 
964         if (contractBalance > swapTokensAtAmount * 20) {
965             contractBalance = swapTokensAtAmount * 20;
966         }
967 
968         uint256 amountToSwapForETH = contractBalance;
969 
970         swapTokensForEth(amountToSwapForETH);
971 
972         (success, ) = address(walletOne).call{value: address(this).balance / 2}(
973             ""
974         );
975         (success, ) = address(walletTwo).call{value: address(this).balance}("");
976     }
977 }