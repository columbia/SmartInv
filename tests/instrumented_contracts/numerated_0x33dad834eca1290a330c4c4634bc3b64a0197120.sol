1 // SPDX-License-Identifier: MIT
2 // File: X7 Protocol.sol
3 
4 
5 pragma solidity ^0.8.15;
6 pragma experimental ABIEncoderV2;
7 
8 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
9 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
10 
11 /* pragma solidity ^0.8.15; */
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 
23 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
24 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
25 
26 /* pragma solidity ^0.8.15; */
27 
28 /* import "../utils/Context.sol"; */
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
64 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
65 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
66 
67 /* pragma solidity ^0.8.15; */
68 
69 interface IERC20 {
70     
71     function totalSupply() external view returns (uint256);
72 
73     function balanceOf(address account) external view returns (uint256);
74 
75     function transfer(address recipient, uint256 amount) external returns (bool);
76 
77     function allowance(address owner, address spender) external view returns (uint256);
78 
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     function transferFrom(
82         address sender,
83         address recipient,
84         uint256 amount
85     ) external returns (bool);
86 
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
93 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
94 
95 /* pragma solidity ^0.8.15; */
96 
97 /* import "../IERC20.sol"; */
98 
99 interface IERC20Metadata is IERC20 {
100    
101     function name() external view returns (string memory);
102 
103     function symbol() external view returns (string memory);
104 
105     function decimals() external view returns (uint8);
106 }
107 
108 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
109 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
110 
111 /* pragma solidity ^0.8.15; */
112 
113 /* import "./IERC20.sol"; */
114 /* import "./extensions/IERC20Metadata.sol"; */
115 /* import "../../utils/Context.sol"; */
116 
117 contract ERC20 is Context, IERC20, IERC20Metadata {
118     mapping(address => uint256) private _balances;
119 
120     mapping(address => mapping(address => uint256)) private _allowances;
121 
122     uint256 private _totalSupply;
123 
124     string private _name;
125     string private _symbol;
126 
127     constructor(string memory name_, string memory symbol_) {
128         _name = name_;
129         _symbol = symbol_;
130     }
131 
132     function name() public view virtual override returns (string memory) {
133         return _name;
134     }
135 
136     function symbol() public view virtual override returns (string memory) {
137         return _symbol;
138     }
139 
140     function decimals() public view virtual override returns (uint8) {
141         return 18;
142     }
143 
144     function totalSupply() public view virtual override returns (uint256) {
145         return _totalSupply;
146     }
147 
148     function balanceOf(address account) public view virtual override returns (uint256) {
149         return _balances[account];
150     }
151 
152     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
153         _transfer(_msgSender(), recipient, amount);
154         return true;
155     }
156 
157     function allowance(address owner, address spender) public view virtual override returns (uint256) {
158         return _allowances[owner][spender];
159     }
160 
161     function approve(address spender, uint256 amount) public virtual override returns (bool) {
162         _approve(_msgSender(), spender, amount);
163         return true;
164     }
165 
166     function transferFrom(
167         address sender,
168         address recipient,
169         uint256 amount
170     ) public virtual override returns (bool) {
171         _transfer(sender, recipient, amount);
172 
173         uint256 currentAllowance = _allowances[sender][_msgSender()];
174         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
175         unchecked {
176             _approve(sender, _msgSender(), currentAllowance - amount);
177         }
178 
179         return true;
180     }
181 
182     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
183         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
184         return true;
185     }
186 
187     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
188         uint256 currentAllowance = _allowances[_msgSender()][spender];
189         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
190         unchecked {
191             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
192         }
193 
194         return true;
195     }
196 
197     function _transfer(
198         address sender,
199         address recipient,
200         uint256 amount
201     ) internal virtual {
202         require(sender != address(0), "ERC20: transfer from the zero address");
203         require(recipient != address(0), "ERC20: transfer to the zero address");
204 
205         _beforeTokenTransfer(sender, recipient, amount);
206 
207         uint256 senderBalance = _balances[sender];
208         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
209         unchecked {
210             _balances[sender] = senderBalance - amount;
211         }
212         _balances[recipient] += amount;
213 
214         emit Transfer(sender, recipient, amount);
215 
216         _afterTokenTransfer(sender, recipient, amount);
217     }
218 
219     function _mint(address account, uint256 amount) internal virtual {
220         require(account != address(0), "ERC20: mint to the zero address");
221 
222         _beforeTokenTransfer(address(0), account, amount);
223 
224         _totalSupply += amount;
225         _balances[account] += amount;
226         emit Transfer(address(0), account, amount);
227 
228         _afterTokenTransfer(address(0), account, amount);
229     }
230 
231     function _burn(address account, uint256 amount) internal virtual {
232         require(account != address(0), "ERC20: burn from the zero address");
233 
234         _beforeTokenTransfer(account, address(0), amount);
235 
236         uint256 accountBalance = _balances[account];
237         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
238         unchecked {
239             _balances[account] = accountBalance - amount;
240         }
241         _totalSupply -= amount;
242 
243         emit Transfer(account, address(0), amount);
244 
245         _afterTokenTransfer(account, address(0), amount);
246     }
247 
248     function _approve(
249         address owner,
250         address spender,
251         uint256 amount
252     ) internal virtual {
253         require(owner != address(0), "ERC20: approve from the zero address");
254         require(spender != address(0), "ERC20: approve to the zero address");
255 
256         _allowances[owner][spender] = amount;
257         emit Approval(owner, spender, amount);
258     }
259 
260     function _beforeTokenTransfer(
261         address from,
262         address to,
263         uint256 amount
264     ) internal virtual {}
265 
266     function _afterTokenTransfer(
267         address from,
268         address to,
269         uint256 amount
270     ) internal virtual {}
271 }
272 
273 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
274 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
275 
276 /* pragma solidity ^0.8.15; */
277 
278 library SafeMath {
279    
280     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
281         unchecked {
282             uint256 c = a + b;
283             if (c < a) return (false, 0);
284             return (true, c);
285         }
286     }
287 
288     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
289         unchecked {
290             if (b > a) return (false, 0);
291             return (true, a - b);
292         }
293     }
294 
295     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
296         unchecked {
297             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
298             // benefit is lost if 'b' is also tested.
299             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
300             if (a == 0) return (true, 0);
301             uint256 c = a * b;
302             if (c / a != b) return (false, 0);
303             return (true, c);
304         }
305     }
306 
307     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
308         unchecked {
309             if (b == 0) return (false, 0);
310             return (true, a / b);
311         }
312     }
313 
314     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
315         unchecked {
316             if (b == 0) return (false, 0);
317             return (true, a % b);
318         }
319     }
320 
321     function add(uint256 a, uint256 b) internal pure returns (uint256) {
322         return a + b;
323     }
324 
325     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
326         return a - b;
327     }
328 
329     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
330         return a * b;
331     }
332 
333     function div(uint256 a, uint256 b) internal pure returns (uint256) {
334         return a / b;
335     }
336 
337     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
338         return a % b;
339     }
340 
341     function sub(
342         uint256 a,
343         uint256 b,
344         string memory errorMessage
345     ) internal pure returns (uint256) {
346         unchecked {
347             require(b <= a, errorMessage);
348             return a - b;
349         }
350     }
351 
352     function div(
353         uint256 a,
354         uint256 b,
355         string memory errorMessage
356     ) internal pure returns (uint256) {
357         unchecked {
358             require(b > 0, errorMessage);
359             return a / b;
360         }
361     }
362 
363     function mod(
364         uint256 a,
365         uint256 b,
366         string memory errorMessage
367     ) internal pure returns (uint256) {
368         unchecked {
369             require(b > 0, errorMessage);
370             return a % b;
371         }
372     }
373 }
374 
375 /* pragma solidity 0.8.15; */
376 /* pragma experimental ABIEncoderV2; */
377 
378 interface IUniswapV2Factory {
379     event PairCreated(
380         address indexed token0,
381         address indexed token1,
382         address pair,
383         uint256
384     );
385 
386     function feeTo() external view returns (address);
387 
388     function feeToSetter() external view returns (address);
389 
390     function getPair(address tokenA, address tokenB)
391         external
392         view
393         returns (address pair);
394 
395     function allPairs(uint256) external view returns (address pair);
396 
397     function allPairsLength() external view returns (uint256);
398 
399     function createPair(address tokenA, address tokenB)
400         external
401         returns (address pair);
402 
403     function setFeeTo(address) external;
404 
405     function setFeeToSetter(address) external;
406 }
407 
408 /* pragma solidity 0.8.15; */
409 /* pragma experimental ABIEncoderV2; */
410 
411 interface IUniswapV2Pair {
412     event Approval(
413         address indexed owner,
414         address indexed spender,
415         uint256 value
416     );
417     event Transfer(address indexed from, address indexed to, uint256 value);
418 
419     function name() external pure returns (string memory);
420 
421     function symbol() external pure returns (string memory);
422 
423     function decimals() external pure returns (uint8);
424 
425     function totalSupply() external view returns (uint256);
426 
427     function balanceOf(address owner) external view returns (uint256);
428 
429     function allowance(address owner, address spender)
430         external
431         view
432         returns (uint256);
433 
434     function approve(address spender, uint256 value) external returns (bool);
435 
436     function transfer(address to, uint256 value) external returns (bool);
437 
438     function transferFrom(
439         address from,
440         address to,
441         uint256 value
442     ) external returns (bool);
443 
444     function DOMAIN_SEPARATOR() external view returns (bytes32);
445 
446     function PERMIT_TYPEHASH() external pure returns (bytes32);
447 
448     function nonces(address owner) external view returns (uint256);
449 
450     function permit(
451         address owner,
452         address spender,
453         uint256 value,
454         uint256 deadline,
455         uint8 v,
456         bytes32 r,
457         bytes32 s
458     ) external;
459 
460     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
461     event Burn(
462         address indexed sender,
463         uint256 amount0,
464         uint256 amount1,
465         address indexed to
466     );
467     event Swap(
468         address indexed sender,
469         uint256 amount0In,
470         uint256 amount1In,
471         uint256 amount0Out,
472         uint256 amount1Out,
473         address indexed to
474     );
475     event Sync(uint112 reserve0, uint112 reserve1);
476 
477     function MINIMUM_LIQUIDITY() external pure returns (uint256);
478 
479     function factory() external view returns (address);
480 
481     function token0() external view returns (address);
482 
483     function token1() external view returns (address);
484 
485     function getReserves()
486         external
487         view
488         returns (
489             uint112 reserve0,
490             uint112 reserve1,
491             uint32 blockTimestampLast
492         );
493 
494     function price0CumulativeLast() external view returns (uint256);
495 
496     function price1CumulativeLast() external view returns (uint256);
497 
498     function kLast() external view returns (uint256);
499 
500     function mint(address to) external returns (uint256 liquidity);
501 
502     function burn(address to)
503         external
504         returns (uint256 amount0, uint256 amount1);
505 
506     function swap(
507         uint256 amount0Out,
508         uint256 amount1Out,
509         address to,
510         bytes calldata data
511     ) external;
512 
513     function skim(address to) external;
514 
515     function sync() external;
516 
517     function initialize(address, address) external;
518 }
519 
520 /* pragma solidity 0.8.15; */
521 /* pragma experimental ABIEncoderV2; */
522 
523 interface IUniswapV2Router02 {
524     function factory() external pure returns (address);
525 
526     function WETH() external pure returns (address);
527 
528     function addLiquidity(
529         address tokenA,
530         address tokenB,
531         uint256 amountADesired,
532         uint256 amountBDesired,
533         uint256 amountAMin,
534         uint256 amountBMin,
535         address to,
536         uint256 deadline
537     )
538         external
539         returns (
540             uint256 amountA,
541             uint256 amountB,
542             uint256 liquidity
543         );
544 
545     function addLiquidityETH(
546         address token,
547         uint256 amountTokenDesired,
548         uint256 amountTokenMin,
549         uint256 amountETHMin,
550         address to,
551         uint256 deadline
552     )
553         external
554         payable
555         returns (
556             uint256 amountToken,
557             uint256 amountETH,
558             uint256 liquidity
559         );
560 
561     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
562         uint256 amountIn,
563         uint256 amountOutMin,
564         address[] calldata path,
565         address to,
566         uint256 deadline
567     ) external;
568 
569     function swapExactETHForTokensSupportingFeeOnTransferTokens(
570         uint256 amountOutMin,
571         address[] calldata path,
572         address to,
573         uint256 deadline
574     ) external payable;
575 
576     function swapExactTokensForETHSupportingFeeOnTransferTokens(
577         uint256 amountIn,
578         uint256 amountOutMin,
579         address[] calldata path,
580         address to,
581         uint256 deadline
582     ) external;
583 }
584 
585 /* pragma solidity >=0.8.15; */
586 
587 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
588 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
589 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
590 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
591 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
592 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
593 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
594 
595 contract Protocol is ERC20, Ownable {
596     using SafeMath for uint256;
597 
598     IUniswapV2Router02 public immutable uniswapV2Router;
599     address public immutable uniswapV2Pair;
600     address public constant deadAddress = address(0xdead);
601 
602     bool private swapping;
603 
604     address public marketingWallet;
605     address public devWallet;
606 
607     uint256 public maxTransactionAmount;
608     uint256 public swapTokensAtAmount;
609     uint256 public maxWallet;
610 
611     bool public limitsInEffect = true;
612     bool public tradingActive = false;
613     bool public swapEnabled = false;
614 
615     // Anti-bot and anti-whale mappings and variables
616     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
617     bool public transferDelayEnabled = false;
618 
619     uint256 public buyTotalFees;
620 	uint256 public buyMarketingFee;
621     uint256 public buyLiquidityFee;
622     uint256 public buyDevFee;
623 
624     uint256 public sellTotalFees;
625     uint256 public sellMarketingFee;
626     uint256 public sellLiquidityFee;
627     uint256 public sellDevFee;
628 
629     uint256 public tokensForMarketing;
630     uint256 public tokensForLiquidity;
631     uint256 public tokensForDev;
632 
633     /******************/
634 
635     // exlcude from fees and max transaction amount
636     mapping(address => bool) private _isExcludedFromFees;
637     mapping(address => bool) public _isExcludedMaxTransactionAmount;
638 
639     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
640     // could be subject to a maximum transfer amount
641     mapping(address => bool) public automatedMarketMakerPairs;
642 
643     event UpdateUniswapV2Router(
644         address indexed newAddress,
645         address indexed oldAddress
646     );
647 
648     event ExcludeFromFees(address indexed account, bool isExcluded);
649 
650     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
651 
652     event SwapAndLiquify(
653         uint256 tokensSwapped,
654         uint256 ethReceived,
655         uint256 tokensIntoLiquidity
656     );
657 
658     constructor() ERC20("X7 Protocol", "X7") {
659         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
660             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
661         );
662 
663         excludeFromMaxTransaction(address(_uniswapV2Router), true);
664         uniswapV2Router = _uniswapV2Router;
665 
666         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
667             .createPair(address(this), _uniswapV2Router.WETH());
668         excludeFromMaxTransaction(address(uniswapV2Pair), true);
669         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
670 
671         uint256 _buyMarketingFee = 3;
672         uint256 _buyLiquidityFee = 0;
673         uint256 _buyDevFee = 3;
674 
675         uint256 _sellMarketingFee = 3;
676         uint256 _sellLiquidityFee = 0;
677         uint256 _sellDevFee = 3;
678 
679         uint256 totalSupply = 100000000 * 1e18;
680 
681         maxTransactionAmount = 200000 * 1e18; // .2% from total supply maxTransactionAmountTxn
682         maxWallet = 1000000 * 1e18; // 1% from total supply maxWallet
683         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
684 
685         buyMarketingFee = _buyMarketingFee;
686 		buyLiquidityFee = _buyLiquidityFee;
687         buyDevFee = _buyDevFee;
688         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
689 
690         sellMarketingFee = _sellMarketingFee;
691         sellLiquidityFee = _sellLiquidityFee;
692         sellDevFee = _sellDevFee;
693         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
694 
695         marketingWallet = address(0x76685a61585010B7855436906E50c05f91d316F9); // set as marketing wallet
696         devWallet = address(0x69dbc4f1527791fEA8f9b61D4d264a54F2627369); // set as dev wallet
697 
698         // exclude from paying fees or having max transaction amount
699         excludeFromFees(owner(), true);
700         excludeFromFees(address(this), true);
701         excludeFromFees(address(0xdead), true);
702 		excludeFromFees(address(marketingWallet), true);
703 		
704         excludeFromMaxTransaction(owner(), true);
705         excludeFromMaxTransaction(address(this), true);
706         excludeFromMaxTransaction(address(0xdead), true);
707 		excludeFromMaxTransaction(address(marketingWallet), true);
708 
709         /*
710             _mint is an internal function in ERC20.sol that is only called here,
711             and CANNOT be called ever again
712         */
713         _mint(msg.sender, totalSupply);
714     }
715 
716     receive() external payable {}
717 
718     // once enabled, can never be turned off
719     function enableTrading() external onlyOwner {
720         tradingActive = true;
721         swapEnabled = true;
722     }
723 
724     // remove limits after token is stable
725     function removeLimits() external onlyOwner returns (bool) {
726         limitsInEffect = false;
727         return true;
728     }
729 
730     // disable Transfer delay - cannot be reenabled
731     function disableTransferDelay() external onlyOwner returns (bool) {
732         transferDelayEnabled = false;
733         return true;
734     }
735 
736     // change the minimum amount of tokens to sell from fees
737     function updateSwapTokensAtAmount(uint256 newAmount)
738         external
739         onlyOwner
740         returns (bool)
741     {
742         require(
743             newAmount >= (totalSupply() * 1) / 100000,
744             "Swap amount cannot be lower than 0.001% total supply."
745         );
746         require(
747             newAmount <= (totalSupply() * 5) / 1000,
748             "Swap amount cannot be higher than 0.5% total supply."
749         );
750         swapTokensAtAmount = newAmount;
751         return true;
752     }
753 
754     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
755         require(
756             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
757             "Cannot set maxTransactionAmount lower than 0.1%"
758         );
759         maxTransactionAmount = newNum * (10**18);
760     }
761 
762     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
763         require(
764             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
765             "Cannot set maxWallet lower than 0.5%"
766         );
767         maxWallet = newNum * (10**18);
768     }
769 	
770     function excludeFromMaxTransaction(address updAds, bool isEx)
771         public
772         onlyOwner
773     {
774         _isExcludedMaxTransactionAmount[updAds] = isEx;
775     }
776 
777     // only use to disable contract sales if absolutely necessary (emergency use only)
778     function updateSwapEnabled(bool enabled) external onlyOwner {
779         swapEnabled = enabled;
780     }
781 
782     function excludeFromFees(address account, bool excluded) public onlyOwner {
783         _isExcludedFromFees[account] = excluded;
784         emit ExcludeFromFees(account, excluded);
785     }
786 
787     function setAutomatedMarketMakerPair(address pair, bool value)
788         public
789         onlyOwner
790     {
791         require(
792             pair != uniswapV2Pair,
793             "The pair cannot be removed from automatedMarketMakerPairs"
794         );
795 
796         _setAutomatedMarketMakerPair(pair, value);
797     }
798 
799     function _setAutomatedMarketMakerPair(address pair, bool value) private {
800         automatedMarketMakerPairs[pair] = value;
801 
802         emit SetAutomatedMarketMakerPair(pair, value);
803     }
804 
805     function isExcludedFromFees(address account) public view returns (bool) {
806         return _isExcludedFromFees[account];
807     }
808 
809     function _transfer(
810         address from,
811         address to,
812         uint256 amount
813     ) internal override {
814         require(from != address(0), "ERC20: transfer from the zero address");
815         require(to != address(0), "ERC20: transfer to the zero address");
816 
817         if (amount == 0) {
818             super._transfer(from, to, 0);
819             return;
820         }
821 
822         if (limitsInEffect) {
823             if (
824                 from != owner() &&
825                 to != owner() &&
826                 to != address(0) &&
827                 to != address(0xdead) &&
828                 !swapping
829             ) {
830                 if (!tradingActive) {
831                     require(
832                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
833                         "Trading is not active."
834                     );
835                 }
836 
837                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
838                 if (transferDelayEnabled) {
839                     if (
840                         to != owner() &&
841                         to != address(uniswapV2Router) &&
842                         to != address(uniswapV2Pair)
843                     ) {
844                         require(
845                             _holderLastTransferTimestamp[tx.origin] <
846                                 block.number,
847                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
848                         );
849                         _holderLastTransferTimestamp[tx.origin] = block.number;
850                     }
851                 }
852 
853                 //when buy
854                 if (
855                     automatedMarketMakerPairs[from] &&
856                     !_isExcludedMaxTransactionAmount[to]
857                 ) {
858                     require(
859                         amount <= maxTransactionAmount,
860                         "Buy transfer amount exceeds the maxTransactionAmount."
861                     );
862                     require(
863                         amount + balanceOf(to) <= maxWallet,
864                         "Max wallet exceeded"
865                     );
866                 }
867                 //when sell
868                 else if (
869                     automatedMarketMakerPairs[to] &&
870                     !_isExcludedMaxTransactionAmount[from]
871                 ) {
872                     require(
873                         amount <= maxTransactionAmount,
874                         "Sell transfer amount exceeds the maxTransactionAmount."
875                     );
876                 } else if (!_isExcludedMaxTransactionAmount[to]) {
877                     require(
878                         amount + balanceOf(to) <= maxWallet,
879                         "Max wallet exceeded"
880                     );
881                 }
882             }
883         }
884 
885         uint256 contractTokenBalance = balanceOf(address(this));
886 
887         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
888 
889         if (
890             canSwap &&
891             swapEnabled &&
892             !swapping &&
893             !automatedMarketMakerPairs[from] &&
894             !_isExcludedFromFees[from] &&
895             !_isExcludedFromFees[to]
896         ) {
897             swapping = true;
898 
899             swapBack();
900 
901             swapping = false;
902         }
903 
904         bool takeFee = !swapping;
905 
906         // if any account belongs to _isExcludedFromFee account then remove the fee
907         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
908             takeFee = false;
909         }
910 
911         uint256 fees = 0;
912         // only take fees on buys/sells, do not take on wallet transfers
913         if (takeFee) {
914             // on sell
915             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
916                 fees = amount.mul(sellTotalFees).div(100);
917                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
918                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
919                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
920             }
921             // on buy
922             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
923                 fees = amount.mul(buyTotalFees).div(100);
924                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
925                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
926                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
927             }
928 
929             if (fees > 0) {
930                 super._transfer(from, address(this), fees);
931             }
932 
933             amount -= fees;
934         }
935 
936         super._transfer(from, to, amount);
937     }
938 
939     function swapTokensForEth(uint256 tokenAmount) private {
940         // generate the uniswap pair path of token -> weth
941         address[] memory path = new address[](2);
942         path[0] = address(this);
943         path[1] = uniswapV2Router.WETH();
944 
945         _approve(address(this), address(uniswapV2Router), tokenAmount);
946 
947         // make the swap
948         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
949             tokenAmount,
950             0, // accept any amount of ETH
951             path,
952             address(this),
953             block.timestamp
954         );
955     }
956 
957     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
958         // approve token transfer to cover all possible scenarios
959         _approve(address(this), address(uniswapV2Router), tokenAmount);
960 
961         // add the liquidity
962         uniswapV2Router.addLiquidityETH{value: ethAmount}(
963             address(this),
964             tokenAmount,
965             0, // slippage is unavoidable
966             0, // slippage is unavoidable
967             devWallet,
968             block.timestamp
969         );
970     }
971 
972     function swapBack() private {
973         uint256 contractBalance = balanceOf(address(this));
974         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
975         bool success;
976 
977         if (contractBalance == 0 || totalTokensToSwap == 0) {
978             return;
979         }
980 
981         if (contractBalance > swapTokensAtAmount * 20) {
982             contractBalance = swapTokensAtAmount * 20;
983         }
984 
985         // Halve the amount of liquidity tokens
986         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
987         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
988 
989         uint256 initialETHBalance = address(this).balance;
990 
991         swapTokensForEth(amountToSwapForETH);
992 
993         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
994 
995         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
996         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
997 
998         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
999 
1000 		tokensForLiquidity = 0;
1001         tokensForMarketing = 0;
1002         tokensForDev = 0;
1003 
1004         (success, ) = address(devWallet).call{value: ethForDev}("");
1005 
1006         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1007             addLiquidity(liquidityTokens, ethForLiquidity);
1008             emit SwapAndLiquify(
1009                 amountToSwapForETH,
1010                 ethForLiquidity,
1011                 liquidityTokens
1012             );
1013         }
1014 
1015         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
1016     }
1017 
1018 }