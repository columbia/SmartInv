1 // SPDX-License-Identifier: MIT
2 // File: x7dao.sol
3 
4 /*
5  
6  x7da0
7 
8 */
9 
10 pragma solidity ^0.8.15;
11 pragma experimental ABIEncoderV2;
12 
13 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
14 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
15 
16 /* pragma solidity ^0.8.15; */
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
28 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
29 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
30 
31 /* pragma solidity ^0.8.15; */
32 
33 /* import "../utils/Context.sol"; */
34 
35 abstract contract Ownable is Context {
36     address private _owner;
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40     constructor() {
41         _transferOwnership(_msgSender());
42     }
43 
44     function owner() public view virtual returns (address) {
45         return _owner;
46     }
47 
48     modifier onlyOwner() {
49         require(owner() == _msgSender(), "Ownable: caller is not the owner");
50         _;
51     }
52 
53     function renounceOwnership() public virtual onlyOwner {
54         _transferOwnership(address(0));
55     }
56 
57     function transferOwnership(address newOwner) public virtual onlyOwner {
58         require(newOwner != address(0), "Ownable: new owner is the zero address");
59         _transferOwnership(newOwner);
60     }
61 
62     function _transferOwnership(address newOwner) internal virtual {
63         address oldOwner = _owner;
64         _owner = newOwner;
65         emit OwnershipTransferred(oldOwner, newOwner);
66     }
67 }
68 
69 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
70 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
71 
72 /* pragma solidity ^0.8.15; */
73 
74 interface IERC20 {
75     
76     function totalSupply() external view returns (uint256);
77 
78     function balanceOf(address account) external view returns (uint256);
79 
80     function transfer(address recipient, uint256 amount) external returns (bool);
81 
82     function allowance(address owner, address spender) external view returns (uint256);
83 
84     function approve(address spender, uint256 amount) external returns (bool);
85 
86     function transferFrom(
87         address sender,
88         address recipient,
89         uint256 amount
90     ) external returns (bool);
91 
92     event Transfer(address indexed from, address indexed to, uint256 value);
93 
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
98 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
99 
100 /* pragma solidity ^0.8.15; */
101 
102 /* import "../IERC20.sol"; */
103 
104 interface IERC20Metadata is IERC20 {
105    
106     function name() external view returns (string memory);
107 
108     function symbol() external view returns (string memory);
109 
110     function decimals() external view returns (uint8);
111 }
112 
113 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
114 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
115 
116 /* pragma solidity ^0.8.15; */
117 
118 /* import "./IERC20.sol"; */
119 /* import "./extensions/IERC20Metadata.sol"; */
120 /* import "../../utils/Context.sol"; */
121 
122 contract ERC20 is Context, IERC20, IERC20Metadata {
123     mapping(address => uint256) private _balances;
124 
125     mapping(address => mapping(address => uint256)) private _allowances;
126 
127     uint256 private _totalSupply;
128 
129     string private _name;
130     string private _symbol;
131 
132     constructor(string memory name_, string memory symbol_) {
133         _name = name_;
134         _symbol = symbol_;
135     }
136 
137     function name() public view virtual override returns (string memory) {
138         return _name;
139     }
140 
141     function symbol() public view virtual override returns (string memory) {
142         return _symbol;
143     }
144 
145     function decimals() public view virtual override returns (uint8) {
146         return 18;
147     }
148 
149     function totalSupply() public view virtual override returns (uint256) {
150         return _totalSupply;
151     }
152 
153     function balanceOf(address account) public view virtual override returns (uint256) {
154         return _balances[account];
155     }
156 
157     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
158         _transfer(_msgSender(), recipient, amount);
159         return true;
160     }
161 
162     function allowance(address owner, address spender) public view virtual override returns (uint256) {
163         return _allowances[owner][spender];
164     }
165 
166     function approve(address spender, uint256 amount) public virtual override returns (bool) {
167         _approve(_msgSender(), spender, amount);
168         return true;
169     }
170 
171     function transferFrom(
172         address sender,
173         address recipient,
174         uint256 amount
175     ) public virtual override returns (bool) {
176         _transfer(sender, recipient, amount);
177 
178         uint256 currentAllowance = _allowances[sender][_msgSender()];
179         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
180         unchecked {
181             _approve(sender, _msgSender(), currentAllowance - amount);
182         }
183 
184         return true;
185     }
186 
187     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
188         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
189         return true;
190     }
191 
192     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
193         uint256 currentAllowance = _allowances[_msgSender()][spender];
194         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
195         unchecked {
196             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
197         }
198 
199         return true;
200     }
201 
202     function _transfer(
203         address sender,
204         address recipient,
205         uint256 amount
206     ) internal virtual {
207         require(sender != address(0), "ERC20: transfer from the zero address");
208         require(recipient != address(0), "ERC20: transfer to the zero address");
209 
210         _beforeTokenTransfer(sender, recipient, amount);
211 
212         uint256 senderBalance = _balances[sender];
213         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
214         unchecked {
215             _balances[sender] = senderBalance - amount;
216         }
217         _balances[recipient] += amount;
218 
219         emit Transfer(sender, recipient, amount);
220 
221         _afterTokenTransfer(sender, recipient, amount);
222     }
223 
224     function _mint(address account, uint256 amount) internal virtual {
225         require(account != address(0), "ERC20: mint to the zero address");
226 
227         _beforeTokenTransfer(address(0), account, amount);
228 
229         _totalSupply += amount;
230         _balances[account] += amount;
231         emit Transfer(address(0), account, amount);
232 
233         _afterTokenTransfer(address(0), account, amount);
234     }
235 
236     function _burn(address account, uint256 amount) internal virtual {
237         require(account != address(0), "ERC20: burn from the zero address");
238 
239         _beforeTokenTransfer(account, address(0), amount);
240 
241         uint256 accountBalance = _balances[account];
242         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
243         unchecked {
244             _balances[account] = accountBalance - amount;
245         }
246         _totalSupply -= amount;
247 
248         emit Transfer(account, address(0), amount);
249 
250         _afterTokenTransfer(account, address(0), amount);
251     }
252 
253     function _approve(
254         address owner,
255         address spender,
256         uint256 amount
257     ) internal virtual {
258         require(owner != address(0), "ERC20: approve from the zero address");
259         require(spender != address(0), "ERC20: approve to the zero address");
260 
261         _allowances[owner][spender] = amount;
262         emit Approval(owner, spender, amount);
263     }
264 
265     function _beforeTokenTransfer(
266         address from,
267         address to,
268         uint256 amount
269     ) internal virtual {}
270 
271     function _afterTokenTransfer(
272         address from,
273         address to,
274         uint256 amount
275     ) internal virtual {}
276 }
277 
278 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
279 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
280 
281 /* pragma solidity ^0.8.15; */
282 
283 library SafeMath {
284    
285     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
286         unchecked {
287             uint256 c = a + b;
288             if (c < a) return (false, 0);
289             return (true, c);
290         }
291     }
292 
293     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
294         unchecked {
295             if (b > a) return (false, 0);
296             return (true, a - b);
297         }
298     }
299 
300     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
301         unchecked {
302             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
303             // benefit is lost if 'b' is also tested.
304             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
305             if (a == 0) return (true, 0);
306             uint256 c = a * b;
307             if (c / a != b) return (false, 0);
308             return (true, c);
309         }
310     }
311 
312     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
313         unchecked {
314             if (b == 0) return (false, 0);
315             return (true, a / b);
316         }
317     }
318 
319     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
320         unchecked {
321             if (b == 0) return (false, 0);
322             return (true, a % b);
323         }
324     }
325 
326     function add(uint256 a, uint256 b) internal pure returns (uint256) {
327         return a + b;
328     }
329 
330     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
331         return a - b;
332     }
333 
334     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
335         return a * b;
336     }
337 
338     function div(uint256 a, uint256 b) internal pure returns (uint256) {
339         return a / b;
340     }
341 
342     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
343         return a % b;
344     }
345 
346     function sub(
347         uint256 a,
348         uint256 b,
349         string memory errorMessage
350     ) internal pure returns (uint256) {
351         unchecked {
352             require(b <= a, errorMessage);
353             return a - b;
354         }
355     }
356 
357     function div(
358         uint256 a,
359         uint256 b,
360         string memory errorMessage
361     ) internal pure returns (uint256) {
362         unchecked {
363             require(b > 0, errorMessage);
364             return a / b;
365         }
366     }
367 
368     function mod(
369         uint256 a,
370         uint256 b,
371         string memory errorMessage
372     ) internal pure returns (uint256) {
373         unchecked {
374             require(b > 0, errorMessage);
375             return a % b;
376         }
377     }
378 }
379 
380 /* pragma solidity 0.8.15; */
381 /* pragma experimental ABIEncoderV2; */
382 
383 interface IUniswapV2Factory {
384     event PairCreated(
385         address indexed token0,
386         address indexed token1,
387         address pair,
388         uint256
389     );
390 
391     function feeTo() external view returns (address);
392 
393     function feeToSetter() external view returns (address);
394 
395     function getPair(address tokenA, address tokenB)
396         external
397         view
398         returns (address pair);
399 
400     function allPairs(uint256) external view returns (address pair);
401 
402     function allPairsLength() external view returns (uint256);
403 
404     function createPair(address tokenA, address tokenB)
405         external
406         returns (address pair);
407 
408     function setFeeTo(address) external;
409 
410     function setFeeToSetter(address) external;
411 }
412 
413 /* pragma solidity 0.8.15; */
414 /* pragma experimental ABIEncoderV2; */
415 
416 interface IUniswapV2Pair {
417     event Approval(
418         address indexed owner,
419         address indexed spender,
420         uint256 value
421     );
422     event Transfer(address indexed from, address indexed to, uint256 value);
423 
424     function name() external pure returns (string memory);
425 
426     function symbol() external pure returns (string memory);
427 
428     function decimals() external pure returns (uint8);
429 
430     function totalSupply() external view returns (uint256);
431 
432     function balanceOf(address owner) external view returns (uint256);
433 
434     function allowance(address owner, address spender)
435         external
436         view
437         returns (uint256);
438 
439     function approve(address spender, uint256 value) external returns (bool);
440 
441     function transfer(address to, uint256 value) external returns (bool);
442 
443     function transferFrom(
444         address from,
445         address to,
446         uint256 value
447     ) external returns (bool);
448 
449     function DOMAIN_SEPARATOR() external view returns (bytes32);
450 
451     function PERMIT_TYPEHASH() external pure returns (bytes32);
452 
453     function nonces(address owner) external view returns (uint256);
454 
455     function permit(
456         address owner,
457         address spender,
458         uint256 value,
459         uint256 deadline,
460         uint8 v,
461         bytes32 r,
462         bytes32 s
463     ) external;
464 
465     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
466     event Burn(
467         address indexed sender,
468         uint256 amount0,
469         uint256 amount1,
470         address indexed to
471     );
472     event Swap(
473         address indexed sender,
474         uint256 amount0In,
475         uint256 amount1In,
476         uint256 amount0Out,
477         uint256 amount1Out,
478         address indexed to
479     );
480     event Sync(uint112 reserve0, uint112 reserve1);
481 
482     function MINIMUM_LIQUIDITY() external pure returns (uint256);
483 
484     function factory() external view returns (address);
485 
486     function token0() external view returns (address);
487 
488     function token1() external view returns (address);
489 
490     function getReserves()
491         external
492         view
493         returns (
494             uint112 reserve0,
495             uint112 reserve1,
496             uint32 blockTimestampLast
497         );
498 
499     function price0CumulativeLast() external view returns (uint256);
500 
501     function price1CumulativeLast() external view returns (uint256);
502 
503     function kLast() external view returns (uint256);
504 
505     function mint(address to) external returns (uint256 liquidity);
506 
507     function burn(address to)
508         external
509         returns (uint256 amount0, uint256 amount1);
510 
511     function swap(
512         uint256 amount0Out,
513         uint256 amount1Out,
514         address to,
515         bytes calldata data
516     ) external;
517 
518     function skim(address to) external;
519 
520     function sync() external;
521 
522     function initialize(address, address) external;
523 }
524 
525 /* pragma solidity 0.8.15; */
526 /* pragma experimental ABIEncoderV2; */
527 
528 interface IUniswapV2Router02 {
529     function factory() external pure returns (address);
530 
531     function WETH() external pure returns (address);
532 
533     function addLiquidity(
534         address tokenA,
535         address tokenB,
536         uint256 amountADesired,
537         uint256 amountBDesired,
538         uint256 amountAMin,
539         uint256 amountBMin,
540         address to,
541         uint256 deadline
542     )
543         external
544         returns (
545             uint256 amountA,
546             uint256 amountB,
547             uint256 liquidity
548         );
549 
550     function addLiquidityETH(
551         address token,
552         uint256 amountTokenDesired,
553         uint256 amountTokenMin,
554         uint256 amountETHMin,
555         address to,
556         uint256 deadline
557     )
558         external
559         payable
560         returns (
561             uint256 amountToken,
562             uint256 amountETH,
563             uint256 liquidity
564         );
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
590 /* pragma solidity >=0.8.15; */
591 
592 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
593 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
594 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
595 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
596 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
597 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
598 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
599 
600 contract X7DAO is ERC20, Ownable {
601     using SafeMath for uint256;
602 
603     IUniswapV2Router02 public immutable uniswapV2Router;
604     address public immutable uniswapV2Pair;
605     address public constant deadAddress = address(0xdead);
606 
607     address public x7m105 = address(0x06D5cA7C9accd15a87d4993A421B7e702BDBaB20);
608 
609     bool private swapping;
610 
611     address public marketingWallet;
612     address public devWallet;
613 
614     uint256 public maxTransactionAmount;
615     uint256 public swapTokensAtAmount;
616     uint256 public maxWallet;
617 
618     bool public limitsInEffect = true;
619     bool public tradingActive = false;
620     bool public swapEnabled = false;
621 
622     // Anti-bot and anti-whale mappings and variables
623     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
624     bool public transferDelayEnabled = false;
625 
626     uint256 public buyTotalFees;
627 	uint256 public buyMarketingFee;
628     uint256 public buyLiquidityFee;
629     uint256 public buyDevFee;
630 
631     uint256 public sellTotalFees;
632     uint256 public sellMarketingFee;
633     uint256 public sellLiquidityFee;
634     uint256 public sellDevFee;
635 
636     uint256 public tokensForMarketing;
637     uint256 public tokensForLiquidity;
638     uint256 public tokensForDev;
639 
640     /******************/
641 
642     // exlcude from fees and max transaction amount
643     mapping(address => bool) private _isExcludedFromFees;
644     mapping(address => bool) public _isExcludedMaxTransactionAmount;
645 
646     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
647     // could be subject to a maximum transfer amount
648     mapping(address => bool) public automatedMarketMakerPairs;
649 
650     event UpdateUniswapV2Router(
651         address indexed newAddress,
652         address indexed oldAddress
653     );
654 
655     event ExcludeFromFees(address indexed account, bool isExcluded);
656 
657     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
658 
659     event SwapAndLiquify(
660         uint256 tokensSwapped,
661         uint256 ethReceived,
662         uint256 tokensIntoLiquidity
663     );
664 
665     constructor() ERC20("X7DAO", "X7DAO") {
666         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
667             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
668         );
669 
670         excludeFromMaxTransaction(address(_uniswapV2Router), true);
671         uniswapV2Router = _uniswapV2Router;
672 
673         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
674             .createPair(address(this), _uniswapV2Router.WETH());
675         excludeFromMaxTransaction(address(uniswapV2Pair), true);
676         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
677 
678         uint256 _buyMarketingFee = 2;
679         uint256 _buyLiquidityFee = 1;
680         uint256 _buyDevFee = 3;
681 
682         uint256 _sellMarketingFee = 2;
683         uint256 _sellLiquidityFee = 1;
684         uint256 _sellDevFee = 3;
685 
686         uint256 totalSupply = 100000000 * 1e18;
687 
688         maxTransactionAmount = 150000 * 1e18; // .15% from total supply maxTransactionAmountTxn
689         maxWallet = 1500000 * 1e18; // 1.5% from total supply maxWallet
690         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
691 
692         buyMarketingFee = _buyMarketingFee;
693 		buyLiquidityFee = _buyLiquidityFee;
694         buyDevFee = _buyDevFee;
695         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
696 
697         sellMarketingFee = _sellMarketingFee;
698         sellLiquidityFee = _sellLiquidityFee;
699         sellDevFee = _sellDevFee;
700         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
701 
702         marketingWallet = address(0x5Bacb575b88888D08231b65B243419eDe49D1795); // set as marketing wallet
703         devWallet = address(0x7000a09c425ABf5173FF458dF1370C25d1C58105); // set as dev wallet
704 
705         // exclude from paying fees or having max transaction amount
706         excludeFromFees(owner(), true);
707         excludeFromFees(address(this), true);
708         excludeFromFees(address(0xdead), true);
709 		excludeFromFees(address(marketingWallet), true);
710 		
711         excludeFromMaxTransaction(owner(), true);
712         excludeFromMaxTransaction(address(this), true);
713         excludeFromMaxTransaction(address(0xdead), true);
714 		excludeFromMaxTransaction(address(marketingWallet), true);
715 
716         /*
717             _mint is an internal function in ERC20.sol that is only called here,
718             and CANNOT be called ever again
719         */
720         _mint(msg.sender, totalSupply);
721     }
722 
723     receive() external payable {}
724 
725     // once enabled, can never be turned off
726     function enableTrading() external onlyOwner {
727         tradingActive = true;
728         swapEnabled = true;
729     }
730 
731     // remove limits after token is stable
732     function removeLimits() external onlyOwner returns (bool) {
733         limitsInEffect = false;
734         return true;
735     }
736 
737     // disable Transfer delay - cannot be reenabled
738     function disableTransferDelay() external onlyOwner returns (bool) {
739         transferDelayEnabled = false;
740         return true;
741     }
742 
743     // change the minimum amount of tokens to sell from fees
744     function updateSwapTokensAtAmount(uint256 newAmount)
745         external
746         onlyOwner
747         returns (bool)
748     {
749         require(
750             newAmount >= (totalSupply() * 1) / 100000,
751             "Swap amount cannot be lower than 0.001% total supply."
752         );
753         require(
754             newAmount <= (totalSupply() * 5) / 1000,
755             "Swap amount cannot be higher than 0.5% total supply."
756         );
757         swapTokensAtAmount = newAmount;
758         return true;
759     }
760 
761     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
762         require(
763             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
764             "Cannot set maxTransactionAmount lower than 0.1%"
765         );
766         maxTransactionAmount = newNum * (10**18);
767     }
768 
769     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
770         require(
771             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
772             "Cannot set maxWallet lower than 0.5%"
773         );
774         maxWallet = newNum * (10**18);
775     }
776 	
777     function excludeFromMaxTransaction(address updAds, bool isEx)
778         public
779         onlyOwner
780     {
781         _isExcludedMaxTransactionAmount[updAds] = isEx;
782     }
783 
784     // only use to disable contract sales if absolutely necessary (emergency use only)
785     function updateSwapEnabled(bool enabled) external onlyOwner {
786         swapEnabled = enabled;
787     }
788 
789     function excludeFromFees(address account, bool excluded) public onlyOwner {
790         _isExcludedFromFees[account] = excluded;
791         emit ExcludeFromFees(account, excluded);
792     }
793 
794     function setAutomatedMarketMakerPair(address pair, bool value)
795         public
796         onlyOwner
797     {
798         require(
799             pair != uniswapV2Pair,
800             "The pair cannot be removed from automatedMarketMakerPairs"
801         );
802 
803         _setAutomatedMarketMakerPair(pair, value);
804     }
805 
806     function _setAutomatedMarketMakerPair(address pair, bool value) private {
807         automatedMarketMakerPairs[pair] = value;
808 
809         emit SetAutomatedMarketMakerPair(pair, value);
810     }
811 
812     function isExcludedFromFees(address account) public view returns (bool) {
813         return _isExcludedFromFees[account];
814     }
815 
816     function _transfer(
817         address from,
818         address to,
819         uint256 amount
820     ) internal override {
821         require(from != address(0), "ERC20: transfer from the zero address");
822         require(to != address(0), "ERC20: transfer to the zero address");
823 
824         if (amount == 0) {
825             super._transfer(from, to, 0);
826             return;
827         }
828 
829         if (limitsInEffect) {
830             if (
831                 from != owner() &&
832                 to != owner() &&
833                 to != address(0) &&
834                 to != address(0xdead) &&
835                 !swapping
836             ) {
837                 if (!tradingActive) {
838                     require(
839                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
840                         "Trading is not active."
841                     );
842                 }
843 
844                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
845                 if (transferDelayEnabled) {
846                     if (
847                         to != owner() &&
848                         to != address(uniswapV2Router) &&
849                         to != address(uniswapV2Pair)
850                     ) {
851                         require(
852                             _holderLastTransferTimestamp[tx.origin] <
853                                 block.number,
854                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
855                         );
856                         _holderLastTransferTimestamp[tx.origin] = block.number;
857                     }
858                 }
859 
860                 //when buy
861                 if (
862                     automatedMarketMakerPairs[from] &&
863                     !_isExcludedMaxTransactionAmount[to]
864                 ) {
865                     require(
866                         amount <= maxTransactionAmount,
867                         "Buy transfer amount exceeds the maxTransactionAmount."
868                     );
869                     require(
870                         amount + balanceOf(to) <= maxWallet,
871                         "Max wallet exceeded"
872                     );
873                 }
874                 //when sell
875                 else if (
876                     automatedMarketMakerPairs[to] &&
877                     !_isExcludedMaxTransactionAmount[from]
878                 ) {
879                     require(
880                         amount <= maxTransactionAmount,
881                         "Sell transfer amount exceeds the maxTransactionAmount."
882                     );
883                 } else if (!_isExcludedMaxTransactionAmount[to]) {
884                     require(
885                         amount + balanceOf(to) <= maxWallet,
886                         "Max wallet exceeded"
887                     );
888                 }
889             }
890         }
891 
892         uint256 contractTokenBalance = balanceOf(address(this));
893 
894         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
895 
896         if (
897             canSwap &&
898             swapEnabled &&
899             !swapping &&
900             !automatedMarketMakerPairs[from] &&
901             !_isExcludedFromFees[from] &&
902             !_isExcludedFromFees[to]
903         ) {
904             swapping = true;
905 
906             swapBack();
907 
908             swapping = false;
909         }
910 
911         bool takeFee = !swapping;
912 
913         // if any account belongs to _isExcludedFromFee account then remove the fee
914         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
915             takeFee = false;
916         }
917 
918         uint256 fees = 0;
919         // only take fees on buys/sells, do not take on wallet transfers
920         if (takeFee) {
921             // on sell
922             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
923                 fees = amount.mul(sellTotalFees).div(100);
924                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
925                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
926                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
927             }
928             // on buy
929             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
930                 fees = amount.mul(buyTotalFees).div(100);
931                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
932                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
933                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
934             }
935 
936             if (fees > 0) {
937                 super._transfer(from, address(this), fees);
938             }
939 
940             amount -= fees;
941         }
942 
943         super._transfer(from, to, amount);
944     }
945 
946     function swapTokensForEth(uint256 tokenAmount) private {
947         // generate the uniswap pair path of token -> weth
948         address[] memory path = new address[](2);
949         path[0] = address(this);
950         path[1] = uniswapV2Router.WETH();
951 
952         _approve(address(this), address(uniswapV2Router), tokenAmount);
953 
954         // make the swap
955         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
956             tokenAmount,
957             0, // accept any amount of ETH
958             path,
959             address(this),
960             block.timestamp
961         );
962     }
963 
964     function burnx7m105(uint256 ethAmount) private {
965         // generate the uniswap pair path of token -> weth
966         address[] memory path = new address[](2);
967         path[0] = uniswapV2Router.WETH();
968         path[1] = x7m105;
969 
970         // make the swap
971         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmount}(
972         	0,
973             path,
974             deadAddress,
975             block.timestamp
976         );
977     }
978 
979     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
980         // approve token transfer to cover all possible scenarios
981         _approve(address(this), address(uniswapV2Router), tokenAmount);
982 
983         // add the liquidity
984         uniswapV2Router.addLiquidityETH{value: ethAmount}(
985             address(this),
986             tokenAmount,
987             0, // slippage is unavoidable
988             0, // slippage is unavoidable
989             devWallet,
990             block.timestamp
991         );
992     }
993 
994     function swapBack() private {
995         uint256 contractBalance = balanceOf(address(this));
996         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
997         bool success;
998 
999         if (contractBalance == 0 || totalTokensToSwap == 0) {
1000             return;
1001         }
1002 
1003         if (contractBalance > swapTokensAtAmount * 20) {
1004             contractBalance = swapTokensAtAmount * 20;
1005         }
1006 
1007         // Halve the amount of liquidity tokens
1008         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1009         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1010 
1011         uint256 initialETHBalance = address(this).balance;
1012 
1013         swapTokensForEth(amountToSwapForETH);
1014 
1015         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1016 
1017         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1018         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1019 
1020         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1021 
1022 		tokensForLiquidity = 0;
1023         tokensForMarketing = 0;
1024         tokensForDev = 0;
1025 
1026         (success, ) = address(devWallet).call{value: ethForDev}("");
1027         (success, ) = address(marketingWallet).call{value: ethForMarketing/2}("");
1028 
1029         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1030             addLiquidity(liquidityTokens, ethForLiquidity);
1031             emit SwapAndLiquify(
1032                 amountToSwapForETH,
1033                 ethForLiquidity,
1034                 liquidityTokens
1035             );
1036         }
1037 
1038         burnx7m105(address(this).balance);
1039     }
1040 
1041 }