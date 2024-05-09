1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-08
3 */
4 
5 // Verified using https://dapp.tools
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity = 0.8.11;
9 
10 /*
11 ✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿
12 hanabira.club              ✿
13 t.me/Hanabiraportal        ✿
14 twitter.com/HANABIRA_ETH   ✿
15 medium.com/@hanabira_eth   ✿
16 ✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿✿
17 */
18 
19 pragma experimental ABIEncoderV2;
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
48     function renounceOwnership() public virtual onlyOwner {
49         _transferOwnership(address(0));
50     }
51 
52     function transferOwnership(address newOwner) public virtual onlyOwner {
53         require(newOwner != address(0), "Ownable: new owner is the zero address");
54         _transferOwnership(newOwner);
55     }
56 
57     function _transferOwnership(address newOwner) internal virtual {
58         address oldOwner = _owner;
59         _owner = newOwner;
60         emit OwnershipTransferred(oldOwner, newOwner);
61     }
62 }
63 
64 interface IERC20 {
65  
66     function totalSupply() external view returns (uint256);
67 
68     function balanceOf(address account) external view returns (uint256);
69 
70     function transfer(address recipient, uint256 amount) external returns (bool);
71 
72     function allowance(address owner, address spender) external view returns (uint256);
73 
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     function transferFrom(
77         address sender,
78         address recipient,
79         uint256 amount
80     ) external returns (bool);
81 
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 interface IERC20Metadata is IERC20 {
88 
89     function name() external view returns (string memory);
90 
91     function symbol() external view returns (string memory);
92 
93     function decimals() external view returns (uint8);
94 }
95 
96 contract ERC20 is Context, IERC20, IERC20Metadata {
97     mapping(address => uint256) private _balances;
98 
99     mapping(address => mapping(address => uint256)) private _allowances;
100 
101     uint256 private _totalSupply;
102 
103     string private _name;
104     string private _symbol;
105 
106     constructor(string memory name_, string memory symbol_) {
107         _name = name_;
108         _symbol = symbol_;
109     }
110 
111     function name() public view virtual override returns (string memory) {
112         return _name;
113     }
114 
115     function symbol() public view virtual override returns (string memory) {
116         return _symbol;
117     }
118 
119     function decimals() public view virtual override returns (uint8) {
120         return 18;
121     }
122 
123     function totalSupply() public view virtual override returns (uint256) {
124         return _totalSupply;
125     }
126 
127     function balanceOf(address account) public view virtual override returns (uint256) {
128         return _balances[account];
129     }
130 
131     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
132         _transfer(_msgSender(), recipient, amount);
133         return true;
134     }
135 
136     function allowance(address owner, address spender) public view virtual override returns (uint256) {
137         return _allowances[owner][spender];
138     }
139 
140     function approve(address spender, uint256 amount) public virtual override returns (bool) {
141         _approve(_msgSender(), spender, amount);
142         return true;
143     }
144 
145     function transferFrom(
146         address sender,
147         address recipient,
148         uint256 amount
149     ) public virtual override returns (bool) {
150         _transfer(sender, recipient, amount);
151 
152         uint256 currentAllowance = _allowances[sender][_msgSender()];
153         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
154         unchecked {
155             _approve(sender, _msgSender(), currentAllowance - amount);
156         }
157 
158         return true;
159     }
160 
161     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
162         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
163         return true;
164     }
165 
166     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
167         uint256 currentAllowance = _allowances[_msgSender()][spender];
168         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
169         unchecked {
170             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
171         }
172 
173         return true;
174     }
175 
176     function _transfer(
177         address sender,
178         address recipient,
179         uint256 amount
180     ) internal virtual {
181         require(sender != address(0), "ERC20: transfer from the zero address");
182         require(recipient != address(0), "ERC20: transfer to the zero address");
183 
184         _beforeTokenTransfer(sender, recipient, amount);
185 
186         uint256 senderBalance = _balances[sender];
187         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
188         unchecked {
189             _balances[sender] = senderBalance - amount;
190         }
191         _balances[recipient] += amount;
192 
193         emit Transfer(sender, recipient, amount);
194 
195         _afterTokenTransfer(sender, recipient, amount);
196     }
197 
198     function _mint(address account, uint256 amount) internal virtual {
199         require(account != address(0), "ERC20: mint to the zero address");
200 
201         _beforeTokenTransfer(address(0), account, amount);
202 
203         _totalSupply += amount;
204         _balances[account] += amount;
205         emit Transfer(address(0), account, amount);
206 
207         _afterTokenTransfer(address(0), account, amount);
208     }
209 
210     function _burn(address account, uint256 amount) internal virtual {
211         require(account != address(0), "ERC20: burn from the zero address");
212 
213         _beforeTokenTransfer(account, address(0), amount);
214 
215         uint256 accountBalance = _balances[account];
216         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
217         unchecked {
218             _balances[account] = accountBalance - amount;
219         }
220         _totalSupply -= amount;
221 
222         emit Transfer(account, address(0), amount);
223 
224         _afterTokenTransfer(account, address(0), amount);
225     }
226 
227     function _approve(
228         address owner,
229         address spender,
230         uint256 amount
231     ) internal virtual {
232         require(owner != address(0), "ERC20: approve from the zero address");
233         require(spender != address(0), "ERC20: approve to the zero address");
234 
235         _allowances[owner][spender] = amount;
236         emit Approval(owner, spender, amount);
237     }
238 
239     function _beforeTokenTransfer(
240         address from,
241         address to,
242         uint256 amount
243     ) internal virtual {}
244 
245     function _afterTokenTransfer(
246         address from,
247         address to,
248         uint256 amount
249     ) internal virtual {}
250 }
251 
252 library SafeMath {
253 
254     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
255         unchecked {
256             uint256 c = a + b;
257             if (c < a) return (false, 0);
258             return (true, c);
259         }
260     }
261 
262     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
263         unchecked {
264             if (b > a) return (false, 0);
265             return (true, a - b);
266         }
267     }
268 
269     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
270         unchecked {
271             if (a == 0) return (true, 0);
272             uint256 c = a * b;
273             if (c / a != b) return (false, 0);
274             return (true, c);
275         }
276     }
277 
278     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
279         unchecked {
280             if (b == 0) return (false, 0);
281             return (true, a / b);
282         }
283     }
284 
285     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
286         unchecked {
287             if (b == 0) return (false, 0);
288             return (true, a % b);
289         }
290     }
291 
292     function add(uint256 a, uint256 b) internal pure returns (uint256) {
293         return a + b;
294     }
295 
296     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
297         return a - b;
298     }
299 
300     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
301         return a * b;
302     }
303 
304     function div(uint256 a, uint256 b) internal pure returns (uint256) {
305         return a / b;
306     }
307 
308     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
309         return a % b;
310     }
311 
312     function sub(
313         uint256 a,
314         uint256 b,
315         string memory errorMessage
316     ) internal pure returns (uint256) {
317         unchecked {
318             require(b <= a, errorMessage);
319             return a - b;
320         }
321     }
322 
323     function div(
324         uint256 a,
325         uint256 b,
326         string memory errorMessage
327     ) internal pure returns (uint256) {
328         unchecked {
329             require(b > 0, errorMessage);
330             return a / b;
331         }
332     }
333 
334     function mod(
335         uint256 a,
336         uint256 b,
337         string memory errorMessage
338     ) internal pure returns (uint256) {
339         unchecked {
340             require(b > 0, errorMessage);
341             return a % b;
342         }
343     }
344 }
345 
346 interface IUniswapV2Factory {
347     event PairCreated(
348         address indexed token0,
349         address indexed token1,
350         address pair,
351         uint256
352     );
353 
354     function feeTo() external view returns (address);
355 
356     function feeToSetter() external view returns (address);
357 
358     function getPair(address tokenA, address tokenB)
359         external
360         view
361         returns (address pair);
362 
363     function allPairs(uint256) external view returns (address pair);
364 
365     function allPairsLength() external view returns (uint256);
366 
367     function createPair(address tokenA, address tokenB)
368         external
369         returns (address pair);
370 
371     function setFeeTo(address) external;
372 
373     function setFeeToSetter(address) external;
374 }
375 
376 ////// src/IUniswapV2Pair.sol
377 /* pragma solidity 0.8.10; */
378 /* pragma experimental ABIEncoderV2; */
379 
380 interface IUniswapV2Pair {
381     event Approval(
382         address indexed owner,
383         address indexed spender,
384         uint256 value
385     );
386     event Transfer(address indexed from, address indexed to, uint256 value);
387 
388     function name() external pure returns (string memory);
389 
390     function symbol() external pure returns (string memory);
391 
392     function decimals() external pure returns (uint8);
393 
394     function totalSupply() external view returns (uint256);
395 
396     function balanceOf(address owner) external view returns (uint256);
397 
398     function allowance(address owner, address spender)
399         external
400         view
401         returns (uint256);
402 
403     function approve(address spender, uint256 value) external returns (bool);
404 
405     function transfer(address to, uint256 value) external returns (bool);
406 
407     function transferFrom(
408         address from,
409         address to,
410         uint256 value
411     ) external returns (bool);
412 
413     function DOMAIN_SEPARATOR() external view returns (bytes32);
414 
415     function PERMIT_TYPEHASH() external pure returns (bytes32);
416 
417     function nonces(address owner) external view returns (uint256);
418 
419     function permit(
420         address owner,
421         address spender,
422         uint256 value,
423         uint256 deadline,
424         uint8 v,
425         bytes32 r,
426         bytes32 s
427     ) external;
428 
429     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
430     event Burn(
431         address indexed sender,
432         uint256 amount0,
433         uint256 amount1,
434         address indexed to
435     );
436     event Swap(
437         address indexed sender,
438         uint256 amount0In,
439         uint256 amount1In,
440         uint256 amount0Out,
441         uint256 amount1Out,
442         address indexed to
443     );
444     event Sync(uint112 reserve0, uint112 reserve1);
445 
446     function MINIMUM_LIQUIDITY() external pure returns (uint256);
447 
448     function factory() external view returns (address);
449 
450     function token0() external view returns (address);
451 
452     function token1() external view returns (address);
453 
454     function getReserves()
455         external
456         view
457         returns (
458             uint112 reserve0,
459             uint112 reserve1,
460             uint32 blockTimestampLast
461         );
462 
463     function price0CumulativeLast() external view returns (uint256);
464 
465     function price1CumulativeLast() external view returns (uint256);
466 
467     function kLast() external view returns (uint256);
468 
469     function mint(address to) external returns (uint256 liquidity);
470 
471     function burn(address to)
472         external
473         returns (uint256 amount0, uint256 amount1);
474 
475     function swap(
476         uint256 amount0Out,
477         uint256 amount1Out,
478         address to,
479         bytes calldata data
480     ) external;
481 
482     function skim(address to) external;
483 
484     function sync() external;
485 
486     function initialize(address, address) external;
487 }
488 
489 interface IUniswapV2Router02 {
490     function factory() external pure returns (address);
491 
492     function WETH() external pure returns (address);
493 
494     function addLiquidity(
495         address tokenA,
496         address tokenB,
497         uint256 amountADesired,
498         uint256 amountBDesired,
499         uint256 amountAMin,
500         uint256 amountBMin,
501         address to,
502         uint256 deadline
503     )
504         external
505         returns (
506             uint256 amountA,
507             uint256 amountB,
508             uint256 liquidity
509         );
510 
511     function addLiquidityETH(
512         address token,
513         uint256 amountTokenDesired,
514         uint256 amountTokenMin,
515         uint256 amountETHMin,
516         address to,
517         uint256 deadline
518     )
519         external
520         payable
521         returns (
522             uint256 amountToken,
523             uint256 amountETH,
524             uint256 liquidity
525         );
526 
527     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
528         uint256 amountIn,
529         uint256 amountOutMin,
530         address[] calldata path,
531         address to,
532         uint256 deadline
533     ) external;
534 
535     function swapExactETHForTokensSupportingFeeOnTransferTokens(
536         uint256 amountOutMin,
537         address[] calldata path,
538         address to,
539         uint256 deadline
540     ) external payable;
541 
542     function swapExactTokensForETHSupportingFeeOnTransferTokens(
543         uint256 amountIn,
544         uint256 amountOutMin,
545         address[] calldata path,
546         address to,
547         uint256 deadline
548     ) external;
549 }
550 
551 ////// src/MarshallRoganInu.sol - HANABIRA = MRI Fork.
552 /* pragma solidity >=0.8.10; */
553 
554 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
555 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
556 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
557 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
558 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
559 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
560 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
561 
562 contract HANABIRA is ERC20, Ownable {
563     using SafeMath for uint256;
564 
565     IUniswapV2Router02 public immutable uniswapV2Router;
566     address public immutable uniswapV2Pair;
567     address public constant deadAddress = address(0xdead);
568 
569     bool private swapping;
570 
571     address public marketingWallet;
572     address public devWallet;
573 
574     uint256 public maxTransactionAmount;
575     uint256 public swapTokensAtAmount;
576     uint256 public maxWallet;
577 
578     uint256 public percentForLPBurn = 25; // 25 = .25%
579     bool public lpBurnEnabled = true;
580     uint256 public lpBurnFrequency = 3600 seconds;
581     uint256 public lastLpBurnTime;
582 
583     uint256 public manualBurnFrequency = 30 minutes;
584     uint256 public lastManualLpBurnTime;
585 
586     bool public limitsInEffect = true;
587     bool public tradingActive = false;
588     bool public swapEnabled = false;
589 
590     mapping(address => uint256) private _holderLastTransferTimestamp; 
591     bool public transferDelayEnabled = true;
592 
593     uint256 public buyTotalFees;
594     uint256 public buyMarketingFee;
595     uint256 public buyLiquidityFee;
596     uint256 public buyDevFee;
597 
598     uint256 public sellTotalFees;
599     uint256 public sellMarketingFee;
600     uint256 public sellLiquidityFee;
601     uint256 public sellDevFee;
602 
603     uint256 public tokensForMarketing;
604     uint256 public tokensForLiquidity;
605     uint256 public tokensForDev;
606 
607     /******************/
608 
609     mapping(address => bool) private _isExcludedFromFees;
610     mapping(address => bool) public _isExcludedMaxTransactionAmount;
611     mapping(address => bool) public automatedMarketMakerPairs;
612 
613     event UpdateUniswapV2Router(
614         address indexed newAddress,
615         address indexed oldAddress
616     );
617 
618     event ExcludeFromFees(address indexed account, bool isExcluded);
619 
620     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
621 
622     event marketingWalletUpdated(
623         address indexed newWallet,
624         address indexed oldWallet
625     );
626 
627     event devWalletUpdated(
628         address indexed newWallet,
629         address indexed oldWallet
630     );
631 
632     event SwapAndLiquify(
633         uint256 tokensSwapped,
634         uint256 ethReceived,
635         uint256 tokensIntoLiquidity
636     );
637 
638     event AutoNukeLP();
639 
640     event ManualNukeLP();
641 
642     constructor() ERC20("HANABIRA", "BIRA") {
643         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
644             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
645         );
646 
647         excludeFromMaxTransaction(address(_uniswapV2Router), true);
648         uniswapV2Router = _uniswapV2Router;
649 
650         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
651             .createPair(address(this), _uniswapV2Router.WETH());
652         excludeFromMaxTransaction(address(uniswapV2Pair), true);
653         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
654 
655         uint256 _buyMarketingFee = 10;
656         uint256 _buyLiquidityFee = 0;
657         uint256 _buyDevFee = 0;
658 
659         uint256 _sellMarketingFee = 40;
660         uint256 _sellLiquidityFee = 0;
661         uint256 _sellDevFee = 0;
662 
663         uint256 totalSupply = 888_888_888 * 1e18;
664 
665         maxTransactionAmount = 7_111_110 * 1e18; // 0.8% from total supply maxTransactionAmountTxn
666         maxWallet = 14_222_220 * 1e18; // 1.6% from total supply maxWallet
667         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
668 
669         buyMarketingFee = _buyMarketingFee;
670         buyLiquidityFee = _buyLiquidityFee;
671         buyDevFee = _buyDevFee;
672         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
673 
674         sellMarketingFee = _sellMarketingFee;
675         sellLiquidityFee = _sellLiquidityFee;
676         sellDevFee = _sellDevFee;
677         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
678 
679         marketingWallet = address(0x7788a9d3B7B452D3e1b82591fA6cD03053B090a6); // set as marketing wallet
680         devWallet = address(0x7788a9d3B7B452D3e1b82591fA6cD03053B090a6); // set as dev wallet
681 
682         excludeFromFees(owner(), true);
683         excludeFromFees(address(this), true);
684         excludeFromFees(address(0xdead), true);
685 
686         excludeFromMaxTransaction(owner(), true);
687         excludeFromMaxTransaction(address(this), true);
688         excludeFromMaxTransaction(address(0xdead), true);
689 
690         /*
691             _mint is an internal function in ERC20.sol that is only called here,
692             and CANNOT be called ever again
693         */
694         _mint(msg.sender, totalSupply);
695     }
696 
697     receive() external payable {}
698 
699     function enableTrading() external onlyOwner {
700         tradingActive = true;
701         swapEnabled = true;
702         lastLpBurnTime = block.timestamp;
703     }
704 
705     function removeLimits() external onlyOwner returns (bool) {
706         limitsInEffect = false;
707         return true;
708     }
709 
710     function disableTransferDelay() external onlyOwner returns (bool) {
711         transferDelayEnabled = false;
712         return true;
713     }
714 
715     function updateSwapTokensAtAmount(uint256 newAmount)
716         external
717         onlyOwner
718         returns (bool)
719     {
720         require(
721             newAmount >= (totalSupply() * 1) / 100000,
722             "Swap amount cannot be lower than 0.001% total supply."
723         );
724         require(
725             newAmount <= (totalSupply() * 5) / 1000,
726             "Swap amount cannot be higher than 0.5% total supply."
727         );
728         swapTokensAtAmount = newAmount;
729         return true;
730     }
731 
732     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
733         require(
734             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
735             "Cannot set maxTransactionAmount lower than 0.1%"
736         );
737         maxTransactionAmount = newNum * (10**18);
738     }
739 
740     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
741         require(
742             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
743             "Cannot set maxWallet lower than 0.5%"
744         );
745         maxWallet = newNum * (10**18);
746     }
747 
748     function excludeFromMaxTransaction(address updAds, bool isEx)
749         public
750         onlyOwner
751     {
752         _isExcludedMaxTransactionAmount[updAds] = isEx;
753     }
754 
755     function updateSwapEnabled(bool enabled) external onlyOwner {
756         swapEnabled = enabled;
757     }
758 
759     function updateBuyFees(
760         uint256 _marketingFee,
761         uint256 _liquidityFee,
762         uint256 _devFee
763     ) external onlyOwner {
764         buyMarketingFee = _marketingFee;
765         buyLiquidityFee = _liquidityFee;
766         buyDevFee = _devFee;
767         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
768         require(buyTotalFees <= 70, "Must keep fees at 70% or less");
769     }
770 
771     function updateSellFees(
772         uint256 _marketingFee,
773         uint256 _liquidityFee,
774         uint256 _devFee
775     ) external onlyOwner {
776         sellMarketingFee = _marketingFee;
777         sellLiquidityFee = _liquidityFee;
778         sellDevFee = _devFee;
779         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
780         require(sellTotalFees <= 70, "Must keep fees at 70% or less");
781     }
782 
783     function excludeFromFees(address account, bool excluded) public onlyOwner {
784         _isExcludedFromFees[account] = excluded;
785         emit ExcludeFromFees(account, excluded);
786     }
787 
788     function setAutomatedMarketMakerPair(address pair, bool value)
789         public
790         onlyOwner
791     {
792         require(
793             pair != uniswapV2Pair,
794             "The pair cannot be removed from automatedMarketMakerPairs"
795         );
796 
797         _setAutomatedMarketMakerPair(pair, value);
798     }
799 
800     function _setAutomatedMarketMakerPair(address pair, bool value) private {
801         automatedMarketMakerPairs[pair] = value;
802 
803         emit SetAutomatedMarketMakerPair(pair, value);
804     }
805 
806     function updateMarketingWallet(address newMarketingWallet)
807         external
808         onlyOwner
809     {
810         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
811         marketingWallet = newMarketingWallet;
812     }
813 
814     function updateDevWallet(address newWallet) external onlyOwner {
815         emit devWalletUpdated(newWallet, devWallet);
816         devWallet = newWallet;
817     }
818 
819     function isExcludedFromFees(address account) public view returns (bool) {
820         return _isExcludedFromFees[account];
821     }
822 
823     function _transfer(
824         address from,
825         address to,
826         uint256 amount
827     ) internal override {
828         require(from != address(0), "ERC20: transfer from the zero address");
829         require(to != address(0), "ERC20: transfer to the zero address");
830 
831         if (amount == 0) {
832             super._transfer(from, to, 0);
833             return;
834         }
835 
836         if (limitsInEffect) {
837             if (
838                 from != owner() &&
839                 to != owner() &&
840                 to != address(0) &&
841                 to != address(0xdead) &&
842                 !swapping
843             ) {
844                 if (!tradingActive) {
845                     require(
846                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
847                         "Trading is not active."
848                     );
849                 }
850 
851                 if (transferDelayEnabled) {
852                     if (
853                         to != owner() &&
854                         to != address(uniswapV2Router) &&
855                         to != address(uniswapV2Pair)
856                     ) {
857                         require(
858                             _holderLastTransferTimestamp[tx.origin] <
859                                 block.number,
860                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
861                         );
862                         _holderLastTransferTimestamp[tx.origin] = block.number;
863                     }
864                 }
865 
866                 if (
867                     automatedMarketMakerPairs[from] &&
868                     !_isExcludedMaxTransactionAmount[to]
869                 ) {
870                     require(
871                         amount <= maxTransactionAmount,
872                         "Buy transfer amount exceeds the maxTransactionAmount."
873                     );
874                     require(
875                         amount + balanceOf(to) <= maxWallet,
876                         "Max wallet exceeded"
877                     );
878                 }
879                 //when sell
880                 else if (
881                     automatedMarketMakerPairs[to] &&
882                     !_isExcludedMaxTransactionAmount[from]
883                 ) {
884                     require(
885                         amount <= maxTransactionAmount,
886                         "Sell transfer amount exceeds the maxTransactionAmount."
887                     );
888                 } else if (!_isExcludedMaxTransactionAmount[to]) {
889                     require(
890                         amount + balanceOf(to) <= maxWallet,
891                         "Max wallet exceeded"
892                     );
893                 }
894             }
895         }
896 
897         uint256 contractTokenBalance = balanceOf(address(this));
898 
899         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
900 
901         if (
902             canSwap &&
903             swapEnabled &&
904             !swapping &&
905             !automatedMarketMakerPairs[from] &&
906             !_isExcludedFromFees[from] &&
907             !_isExcludedFromFees[to]
908         ) {
909             swapping = true;
910             swapBack();
911             swapping = false;
912         }
913 
914         if (
915             !swapping &&
916             automatedMarketMakerPairs[to] &&
917             lpBurnEnabled &&
918             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
919             !_isExcludedFromFees[from]
920         ) {
921             autoBurnLiquidityPairTokens();
922         }
923 
924         bool takeFee = !swapping;
925 
926         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
927             takeFee = false;
928         }
929 
930         uint256 fees = 0;
931         if (takeFee) {
932             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
933                 fees = amount.mul(sellTotalFees).div(100);
934                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
935                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
936                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
937             }
938             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
939                 fees = amount.mul(buyTotalFees).div(100);
940                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
941                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
942                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
943             }
944 
945             if (fees > 0) {
946                 super._transfer(from, address(this), fees);
947             }
948 
949             amount -= fees;
950         }
951 
952         super._transfer(from, to, amount);
953     }
954 
955     function swapTokensForEth(uint256 tokenAmount) private {
956         address[] memory path = new address[](2);
957         path[0] = address(this);
958         path[1] = uniswapV2Router.WETH();
959 
960         _approve(address(this), address(uniswapV2Router), tokenAmount);
961 
962         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
963             tokenAmount,
964             0, 
965             path,
966             address(this),
967             block.timestamp
968         );
969     }
970 
971     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
972         _approve(address(this), address(uniswapV2Router), tokenAmount);
973 
974         uniswapV2Router.addLiquidityETH{value: ethAmount}(
975             address(this),
976             tokenAmount,
977             0, 
978             0, 
979             deadAddress,
980             block.timestamp
981         );
982     }
983 
984     function swapBack() private {
985         uint256 contractBalance = balanceOf(address(this));
986         uint256 totalTokensToSwap = tokensForLiquidity +
987             tokensForMarketing +
988             tokensForDev;
989         bool success;
990 
991         if (contractBalance == 0 || totalTokensToSwap == 0) {
992             return;
993         }
994 
995         if (contractBalance > swapTokensAtAmount * 20) {
996             contractBalance = swapTokensAtAmount * 20;
997         }
998 
999         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1000             totalTokensToSwap /
1001             2;
1002         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1003 
1004         uint256 initialETHBalance = address(this).balance;
1005 
1006         swapTokensForEth(amountToSwapForETH);
1007 
1008         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1009 
1010         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1011             totalTokensToSwap
1012         );
1013         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1014 
1015         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1016 
1017         tokensForLiquidity = 0;
1018         tokensForMarketing = 0;
1019         tokensForDev = 0;
1020 
1021         (success, ) = address(devWallet).call{value: ethForDev}("");
1022 
1023         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1024             addLiquidity(liquidityTokens, ethForLiquidity);
1025             emit SwapAndLiquify(
1026                 amountToSwapForETH,
1027                 ethForLiquidity,
1028                 tokensForLiquidity
1029             );
1030         }
1031 
1032         (success, ) = address(marketingWallet).call{
1033             value: address(this).balance
1034         }("");
1035     }
1036 
1037     function setAutoLPBurnSettings(
1038         uint256 _frequencyInSeconds,
1039         uint256 _percent,
1040         bool _Enabled
1041     ) external onlyOwner {
1042         require(
1043             _frequencyInSeconds >= 600,
1044             "cannot set buyback more often than every 10 minutes"
1045         );
1046         require(
1047             _percent <= 1000 && _percent >= 0,
1048             "Must set auto LP burn percent between 0% and 10%"
1049         );
1050         lpBurnFrequency = _frequencyInSeconds;
1051         percentForLPBurn = _percent;
1052         lpBurnEnabled = _Enabled;
1053     }
1054 
1055     function autoBurnLiquidityPairTokens() internal returns (bool) {
1056         lastLpBurnTime = block.timestamp;
1057 
1058         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1059 
1060         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1061             10000
1062         );
1063 
1064         if (amountToBurn > 0) {
1065             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1066         }
1067 
1068         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1069         pair.sync();
1070         emit AutoNukeLP();
1071         return true;
1072     }
1073 
1074     function manualBurnLiquidityPairTokens(uint256 percent)
1075         external
1076         onlyOwner
1077         returns (bool)
1078     {
1079         require(
1080             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1081             "Must wait for cooldown to finish"
1082         );
1083         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1084         lastManualLpBurnTime = block.timestamp;
1085 
1086         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1087 
1088         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1089 
1090         if (amountToBurn > 0) {
1091             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1092         }
1093 
1094         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1095         pair.sync();
1096         emit ManualNukeLP();
1097         return true;
1098     }
1099 }