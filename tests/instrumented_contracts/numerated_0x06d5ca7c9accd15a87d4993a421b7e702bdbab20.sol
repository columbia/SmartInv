1 // SPDX-License-Identifier: MIT
2 // File: 7m105.sol
3 
4 /*
5  
6  x7m105
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
600 contract X7m105 is ERC20, Ownable {
601     using SafeMath for uint256;
602 
603     IUniswapV2Router02 public immutable uniswapV2Router;
604     address public immutable uniswapV2Pair;
605     address public constant deadAddress = address(0xdead);
606 
607     bool private swapping;
608 
609     address public marketingWallet;
610     address public devWallet;
611 
612     uint256 public maxTransactionAmount;
613     uint256 public swapTokensAtAmount;
614     uint256 public maxWallet;
615 
616     bool public limitsInEffect = true;
617     bool public tradingActive = false;
618     bool public swapEnabled = false;
619 
620     // Anti-bot and anti-whale mappings and variables
621     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
622     bool public transferDelayEnabled = false;
623 
624     uint256 public buyTotalFees;
625 	uint256 public buyMarketingFee;
626     uint256 public buyLiquidityFee;
627     uint256 public buyDevFee;
628 
629     uint256 public sellTotalFees;
630     uint256 public sellMarketingFee;
631     uint256 public sellLiquidityFee;
632     uint256 public sellDevFee;
633 
634     uint256 public tokensForMarketing;
635     uint256 public tokensForLiquidity;
636     uint256 public tokensForDev;
637 
638     /******************/
639 
640     // exlcude from fees and max transaction amount
641     mapping(address => bool) private _isExcludedFromFees;
642     mapping(address => bool) public _isExcludedMaxTransactionAmount;
643 
644     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
645     // could be subject to a maximum transfer amount
646     mapping(address => bool) public automatedMarketMakerPairs;
647 
648     event UpdateUniswapV2Router(
649         address indexed newAddress,
650         address indexed oldAddress
651     );
652 
653     event ExcludeFromFees(address indexed account, bool isExcluded);
654 
655     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
656 
657     event SwapAndLiquify(
658         uint256 tokensSwapped,
659         uint256 ethReceived,
660         uint256 tokensIntoLiquidity
661     );
662 
663     constructor() ERC20("X7m105", "X7m105") {
664         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
665             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
666         );
667 
668         excludeFromMaxTransaction(address(_uniswapV2Router), true);
669         uniswapV2Router = _uniswapV2Router;
670 
671         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
672             .createPair(address(this), _uniswapV2Router.WETH());
673         excludeFromMaxTransaction(address(uniswapV2Pair), true);
674         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
675 
676         uint256 _buyMarketingFee = 3;
677         uint256 _buyLiquidityFee = 0;
678         uint256 _buyDevFee = 3;
679 
680         uint256 _sellMarketingFee = 3;
681         uint256 _sellLiquidityFee = 0;
682         uint256 _sellDevFee = 3;
683 
684         uint256 totalSupply = 100000000 * 1e18;
685 
686         maxTransactionAmount = 150000 * 1e18; // .15% from total supply maxTransactionAmountTxn
687         maxWallet = 1500000 * 1e18; // 1.5% from total supply maxWallet
688         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
689 
690         buyMarketingFee = _buyMarketingFee;
691 		buyLiquidityFee = _buyLiquidityFee;
692         buyDevFee = _buyDevFee;
693         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
694 
695         sellMarketingFee = _sellMarketingFee;
696         sellLiquidityFee = _sellLiquidityFee;
697         sellDevFee = _sellDevFee;
698         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
699 
700         marketingWallet = address(0x5Bacb575b88888D08231b65B243419eDe49D1795); // set as marketing wallet
701         devWallet = address(0x8a790d1e746C2621E12c66fb1523672a97B502F7); // set as dev wallet
702 
703         // exclude from paying fees or having max transaction amount
704         excludeFromFees(owner(), true);
705         excludeFromFees(address(this), true);
706         excludeFromFees(address(0xdead), true);
707 		excludeFromFees(address(marketingWallet), true);
708 		
709         excludeFromMaxTransaction(owner(), true);
710         excludeFromMaxTransaction(address(this), true);
711         excludeFromMaxTransaction(address(0xdead), true);
712 		excludeFromMaxTransaction(address(marketingWallet), true);
713 
714         /*
715             _mint is an internal function in ERC20.sol that is only called here,
716             and CANNOT be called ever again
717         */
718         _mint(msg.sender, totalSupply);
719     }
720 
721     receive() external payable {}
722 
723     // once enabled, can never be turned off
724     function enableTrading() external onlyOwner {
725         tradingActive = true;
726         swapEnabled = true;
727     }
728 
729     // remove limits after token is stable
730     function removeLimits() external onlyOwner returns (bool) {
731         limitsInEffect = false;
732         return true;
733     }
734 
735     // disable Transfer delay - cannot be reenabled
736     function disableTransferDelay() external onlyOwner returns (bool) {
737         transferDelayEnabled = false;
738         return true;
739     }
740 
741     // change the minimum amount of tokens to sell from fees
742     function updateSwapTokensAtAmount(uint256 newAmount)
743         external
744         onlyOwner
745         returns (bool)
746     {
747         require(
748             newAmount >= (totalSupply() * 1) / 100000,
749             "Swap amount cannot be lower than 0.001% total supply."
750         );
751         require(
752             newAmount <= (totalSupply() * 5) / 1000,
753             "Swap amount cannot be higher than 0.5% total supply."
754         );
755         swapTokensAtAmount = newAmount;
756         return true;
757     }
758 
759     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
760         require(
761             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
762             "Cannot set maxTransactionAmount lower than 0.1%"
763         );
764         maxTransactionAmount = newNum * (10**18);
765     }
766 
767     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
768         require(
769             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
770             "Cannot set maxWallet lower than 0.5%"
771         );
772         maxWallet = newNum * (10**18);
773     }
774 	
775     function excludeFromMaxTransaction(address updAds, bool isEx)
776         public
777         onlyOwner
778     {
779         _isExcludedMaxTransactionAmount[updAds] = isEx;
780     }
781 
782     // only use to disable contract sales if absolutely necessary (emergency use only)
783     function updateSwapEnabled(bool enabled) external onlyOwner {
784         swapEnabled = enabled;
785     }
786 
787     function excludeFromFees(address account, bool excluded) public onlyOwner {
788         _isExcludedFromFees[account] = excluded;
789         emit ExcludeFromFees(account, excluded);
790     }
791 
792     function setAutomatedMarketMakerPair(address pair, bool value)
793         public
794         onlyOwner
795     {
796         require(
797             pair != uniswapV2Pair,
798             "The pair cannot be removed from automatedMarketMakerPairs"
799         );
800 
801         _setAutomatedMarketMakerPair(pair, value);
802     }
803 
804     function _setAutomatedMarketMakerPair(address pair, bool value) private {
805         automatedMarketMakerPairs[pair] = value;
806 
807         emit SetAutomatedMarketMakerPair(pair, value);
808     }
809 
810     function isExcludedFromFees(address account) public view returns (bool) {
811         return _isExcludedFromFees[account];
812     }
813 
814     function _transfer(
815         address from,
816         address to,
817         uint256 amount
818     ) internal override {
819         require(from != address(0), "ERC20: transfer from the zero address");
820         require(to != address(0), "ERC20: transfer to the zero address");
821 
822         if (amount == 0) {
823             super._transfer(from, to, 0);
824             return;
825         }
826 
827         if (limitsInEffect) {
828             if (
829                 from != owner() &&
830                 to != owner() &&
831                 to != address(0) &&
832                 to != address(0xdead) &&
833                 !swapping
834             ) {
835                 if (!tradingActive) {
836                     require(
837                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
838                         "Trading is not active."
839                     );
840                 }
841 
842                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
843                 if (transferDelayEnabled) {
844                     if (
845                         to != owner() &&
846                         to != address(uniswapV2Router) &&
847                         to != address(uniswapV2Pair)
848                     ) {
849                         require(
850                             _holderLastTransferTimestamp[tx.origin] <
851                                 block.number,
852                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
853                         );
854                         _holderLastTransferTimestamp[tx.origin] = block.number;
855                     }
856                 }
857 
858                 //when buy
859                 if (
860                     automatedMarketMakerPairs[from] &&
861                     !_isExcludedMaxTransactionAmount[to]
862                 ) {
863                     require(
864                         amount <= maxTransactionAmount,
865                         "Buy transfer amount exceeds the maxTransactionAmount."
866                     );
867                     require(
868                         amount + balanceOf(to) <= maxWallet,
869                         "Max wallet exceeded"
870                     );
871                 }
872                 //when sell
873                 else if (
874                     automatedMarketMakerPairs[to] &&
875                     !_isExcludedMaxTransactionAmount[from]
876                 ) {
877                     require(
878                         amount <= maxTransactionAmount,
879                         "Sell transfer amount exceeds the maxTransactionAmount."
880                     );
881                 } else if (!_isExcludedMaxTransactionAmount[to]) {
882                     require(
883                         amount + balanceOf(to) <= maxWallet,
884                         "Max wallet exceeded"
885                     );
886                 }
887             }
888         }
889 
890         uint256 contractTokenBalance = balanceOf(address(this));
891 
892         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
893 
894         if (
895             canSwap &&
896             swapEnabled &&
897             !swapping &&
898             !automatedMarketMakerPairs[from] &&
899             !_isExcludedFromFees[from] &&
900             !_isExcludedFromFees[to]
901         ) {
902             swapping = true;
903 
904             swapBack();
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
922                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
923                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
924                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
925             }
926             // on buy
927             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
928                 fees = amount.mul(buyTotalFees).div(100);
929                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
930                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
931                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
932             }
933 
934             if (fees > 0) {
935                 super._transfer(from, address(this), fees);
936             }
937 
938             amount -= fees;
939         }
940 
941         super._transfer(from, to, amount);
942     }
943 
944     function swapTokensForEth(uint256 tokenAmount) private {
945         // generate the uniswap pair path of token -> weth
946         address[] memory path = new address[](2);
947         path[0] = address(this);
948         path[1] = uniswapV2Router.WETH();
949 
950         _approve(address(this), address(uniswapV2Router), tokenAmount);
951 
952         // make the swap
953         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
954             tokenAmount,
955             0, // accept any amount of ETH
956             path,
957             address(this),
958             block.timestamp
959         );
960     }
961 
962     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
963         // approve token transfer to cover all possible scenarios
964         _approve(address(this), address(uniswapV2Router), tokenAmount);
965 
966         // add the liquidity
967         uniswapV2Router.addLiquidityETH{value: ethAmount}(
968             address(this),
969             tokenAmount,
970             0, // slippage is unavoidable
971             0, // slippage is unavoidable
972             devWallet,
973             block.timestamp
974         );
975     }
976 
977     function swapBack() private {
978         uint256 contractBalance = balanceOf(address(this));
979         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
980         bool success;
981 
982         if (contractBalance == 0 || totalTokensToSwap == 0) {
983             return;
984         }
985 
986         if (contractBalance > swapTokensAtAmount * 20) {
987             contractBalance = swapTokensAtAmount * 20;
988         }
989 
990         // Halve the amount of liquidity tokens
991         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
992         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
993 
994         uint256 initialETHBalance = address(this).balance;
995 
996         swapTokensForEth(amountToSwapForETH);
997 
998         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
999 
1000         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1001         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1002 
1003         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1004 
1005 		tokensForLiquidity = 0;
1006         tokensForMarketing = 0;
1007         tokensForDev = 0;
1008 
1009         (success, ) = address(devWallet).call{value: ethForDev}("");
1010 
1011         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1012             addLiquidity(liquidityTokens, ethForLiquidity);
1013             emit SwapAndLiquify(
1014                 amountToSwapForETH,
1015                 ethForLiquidity,
1016                 liquidityTokens
1017             );
1018         }
1019 
1020         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
1021     }
1022 
1023 }