1 /*
2 
3 XINU - The first meme coin to deploy on Xchange (Ethereum)
4 
5 -A black labrador service dog for the X7 Finance's ecosystem. 
6 
7 -Every dog learns tricks, our favourite trick is burying (burning) the "quints", the X7100 series of consellation tokens that act as the backstop to the lending pool.
8 
9 -A meme with a dream, to contribute to the X7 Ecosystem in the best way possible, raising the floor!
10 
11 WOOF WOOF
12 
13 Twitter: @XINUxchange
14 Telegram: @XINUxchange
15 
16 
17 */
18 // SPDX-License-Identifier: MIT
19 pragma solidity ^ 0.8.15;
20 pragma experimental ABIEncoderV2;
21 
22 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
23 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
24 
25 /* pragma solidity ^0.8.15; */
26 
27 abstract contract Context {
28   function _msgSender() internal view virtual returns(address) {
29     return msg.sender;
30   }
31 
32   function _msgData() internal view virtual returns(bytes calldata) {
33     return msg.data;
34   }
35 }
36 
37 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
38 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
39 
40 /* pragma solidity ^0.8.15; */
41 
42 /* import "../utils/Context.sol"; */
43 
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49   constructor() {
50     _transferOwnership(_msgSender());
51   }
52 
53   function owner() public view virtual returns(address) {
54     return _owner;
55   }
56 
57     modifier onlyOwner() {
58     require(owner() == _msgSender(), "Ownable: caller is not the owner");
59     _;
60   }
61 
62   function renounceOwnership() public virtual onlyOwner {
63     _transferOwnership(address(0));
64   }
65 
66   function transferOwnership(address newOwner) public virtual onlyOwner {
67     require(newOwner != address(0), "Ownable: new owner is the zero address");
68     _transferOwnership(newOwner);
69   }
70 
71   function _transferOwnership(address newOwner) internal virtual {
72         address oldOwner = _owner;
73     _owner = newOwner;
74         emit OwnershipTransferred(oldOwner, newOwner);
75   }
76 }
77 
78 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
79 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
80 
81 /* pragma solidity ^0.8.15; */
82 
83 interface IERC20 {
84 
85     function totalSupply() external view returns(uint256);
86 
87 function balanceOf(address account) external view returns(uint256);
88 
89 function transfer(address recipient, uint256 amount) external returns(bool);
90 
91 function allowance(address owner, address spender) external view returns(uint256);
92 
93 function approve(address spender, uint256 amount) external returns(bool);
94 
95 function transferFrom(
96   address sender,
97   address recipient,
98   uint256 amount
99 ) external returns(bool);
100 
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
107 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
108 
109 /* pragma solidity ^0.8.15; */
110 
111 /* import "../IERC20.sol"; */
112 
113 interface IERC20Metadata is IERC20 {
114 
115   function name() external view returns(string memory);
116 
117   function symbol() external view returns(string memory);
118 
119   function decimals() external view returns(uint8);
120 }
121 
122 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
123 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
124 
125 /* pragma solidity ^0.8.15; */
126 
127 /* import "./IERC20.sol"; */
128 /* import "./extensions/IERC20Metadata.sol"; */
129 /* import "../../utils/Context.sol"; */
130 
131 contract ERC20 is Context, IERC20, IERC20Metadata {
132   mapping(address => uint256) private _balances;
133 
134   mapping(address => mapping(address => uint256)) private _allowances;
135 
136     uint256 private _totalSupply;
137 
138     string private _name;
139     string private _symbol;
140 
141   constructor(string memory name_, string memory symbol_) {
142     _name = name_;
143     _symbol = symbol_;
144   }
145 
146   function name() public view virtual override returns(string memory) {
147     return _name;
148   }
149 
150   function symbol() public view virtual override returns(string memory) {
151     return _symbol;
152   }
153 
154   function decimals() public view virtual override returns(uint8) {
155     return 18;
156   }
157 
158   function totalSupply() public view virtual override returns(uint256) {
159     return _totalSupply;
160   }
161 
162   function balanceOf(address account) public view virtual override returns(uint256) {
163     return _balances[account];
164   }
165 
166   function transfer(address recipient, uint256 amount) public virtual override returns(bool) {
167     _transfer(_msgSender(), recipient, amount);
168     return true;
169   }
170 
171   function allowance(address owner, address spender) public view virtual override returns(uint256) {
172     return _allowances[owner][spender];
173   }
174 
175   function approve(address spender, uint256 amount) public virtual override returns(bool) {
176     _approve(_msgSender(), spender, amount);
177     return true;
178   }
179 
180   function transferFrom(
181     address sender,
182     address recipient,
183     uint256 amount
184   ) public virtual override returns(bool) {
185     _transfer(sender, recipient, amount);
186 
187         uint256 currentAllowance = _allowances[sender][_msgSender()];
188     require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
189         unchecked {
190       _approve(sender, _msgSender(), currentAllowance - amount);
191     }
192 
193     return true;
194   }
195 
196   function increaseAllowance(address spender, uint256 addedValue) public virtual returns(bool) {
197     _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
198     return true;
199   }
200 
201   function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns(bool) {
202         uint256 currentAllowance = _allowances[_msgSender()][spender];
203     require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
204         unchecked {
205       _approve(_msgSender(), spender, currentAllowance - subtractedValue);
206     }
207 
208     return true;
209   }
210 
211   function _transfer(
212     address sender,
213     address recipient,
214     uint256 amount
215   ) internal virtual {
216     require(sender != address(0), "ERC20: transfer from the zero address");
217     require(recipient != address(0), "ERC20: transfer to the zero address");
218 
219     _beforeTokenTransfer(sender, recipient, amount);
220 
221         uint256 senderBalance = _balances[sender];
222     require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
223         unchecked {
224       _balances[sender] = senderBalance - amount;
225     }
226     _balances[recipient] += amount;
227 
228         emit Transfer(sender, recipient, amount);
229 
230     _afterTokenTransfer(sender, recipient, amount);
231   }
232 
233   function _mint(address account, uint256 amount) internal virtual {
234     require(account != address(0), "ERC20: mint to the zero address");
235 
236     _beforeTokenTransfer(address(0), account, amount);
237 
238     _totalSupply += amount;
239     _balances[account] += amount;
240         emit Transfer(address(0), account, amount);
241 
242     _afterTokenTransfer(address(0), account, amount);
243   }
244 
245   function _burn(address account, uint256 amount) internal virtual {
246     require(account != address(0), "ERC20: burn from the zero address");
247 
248     _beforeTokenTransfer(account, address(0), amount);
249 
250         uint256 accountBalance = _balances[account];
251     require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
252         unchecked {
253       _balances[account] = accountBalance - amount;
254     }
255     _totalSupply -= amount;
256 
257         emit Transfer(account, address(0), amount);
258 
259     _afterTokenTransfer(account, address(0), amount);
260   }
261 
262   function _approve(
263     address owner,
264     address spender,
265     uint256 amount
266   ) internal virtual {
267     require(owner != address(0), "ERC20: approve from the zero address");
268     require(spender != address(0), "ERC20: approve to the zero address");
269 
270     _allowances[owner][spender] = amount;
271         emit Approval(owner, spender, amount);
272   }
273 
274   function _beforeTokenTransfer(
275     address from,
276     address to,
277     uint256 amount
278   ) internal virtual { }
279 
280   function _afterTokenTransfer(
281     address from,
282     address to,
283     uint256 amount
284   ) internal virtual { }
285 }
286 
287 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
288 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
289 
290 /* pragma solidity ^0.8.15; */
291 
292 library SafeMath {
293 
294   function tryAdd(uint256 a, uint256 b) internal pure returns(bool, uint256) {
295         unchecked {
296             uint256 c = a + b;
297       if (c < a) return (false, 0);
298       return (true, c);
299     }
300   }
301 
302   function trySub(uint256 a, uint256 b) internal pure returns(bool, uint256) {
303         unchecked {
304       if (b > a) return (false, 0);
305       return (true, a - b);
306     }
307   }
308 
309   function tryMul(uint256 a, uint256 b) internal pure returns(bool, uint256) {
310         unchecked {
311       // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
312       // benefit is lost if 'b' is also tested.
313       // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
314       if (a == 0) return (true, 0);
315             uint256 c = a * b;
316       if (c / a != b) return (false, 0);
317       return (true, c);
318     }
319   }
320 
321   function tryDiv(uint256 a, uint256 b) internal pure returns(bool, uint256) {
322         unchecked {
323       if (b == 0) return (false, 0);
324       return (true, a / b);
325     }
326   }
327 
328   function tryMod(uint256 a, uint256 b) internal pure returns(bool, uint256) {
329         unchecked {
330       if (b == 0) return (false, 0);
331       return (true, a % b);
332     }
333   }
334 
335   function add(uint256 a, uint256 b) internal pure returns(uint256) {
336     return a + b;
337   }
338 
339   function sub(uint256 a, uint256 b) internal pure returns(uint256) {
340     return a - b;
341   }
342 
343   function mul(uint256 a, uint256 b) internal pure returns(uint256) {
344     return a * b;
345   }
346 
347   function div(uint256 a, uint256 b) internal pure returns(uint256) {
348     return a / b;
349   }
350 
351   function mod(uint256 a, uint256 b) internal pure returns(uint256) {
352     return a % b;
353   }
354 
355   function sub(
356     uint256 a,
357     uint256 b,
358     string memory errorMessage
359   ) internal pure returns(uint256) {
360         unchecked {
361       require(b <= a, errorMessage);
362       return a - b;
363     }
364   }
365 
366   function div(
367     uint256 a,
368     uint256 b,
369     string memory errorMessage
370   ) internal pure returns(uint256) {
371         unchecked {
372       require(b > 0, errorMessage);
373       return a / b;
374     }
375   }
376 
377   function mod(
378     uint256 a,
379     uint256 b,
380     string memory errorMessage
381   ) internal pure returns(uint256) {
382         unchecked {
383       require(b > 0, errorMessage);
384       return a % b;
385     }
386   }
387 }
388 
389 /* pragma solidity 0.8.15; */
390 /* pragma experimental ABIEncoderV2; */
391 
392 interface IUniswapV2Factory {
393     event PairCreated(
394   address indexed token0,
395   address indexed token1,
396   address pair,
397   uint256
398 );
399 
400 function feeTo() external view returns(address);
401 
402 function feeToSetter() external view returns(address);
403 
404 function getPair(address tokenA, address tokenB)
405 external
406 view
407 returns(address pair);
408 
409 function allPairs(uint256) external view returns(address pair);
410 
411 function allPairsLength() external view returns(uint256);
412 
413 function createPair(address tokenA, address tokenB)
414 external
415 returns(address pair);
416 
417 function setFeeTo(address) external;
418 
419 function setFeeToSetter(address) external;
420 }
421 
422 /* pragma solidity 0.8.15; */
423 /* pragma experimental ABIEncoderV2; */
424 
425 interface IUniswapV2Pair {
426     event Approval(
427   address indexed owner,
428   address indexed spender,
429   uint256 value
430 );
431     event Transfer(address indexed from, address indexed to, uint256 value);
432 
433 function name() external pure returns(string memory);
434 
435 function symbol() external pure returns(string memory);
436 
437 function decimals() external pure returns(uint8);
438 
439 function totalSupply() external view returns(uint256);
440 
441 function balanceOf(address owner) external view returns(uint256);
442 
443 function allowance(address owner, address spender)
444 external
445 view
446 returns(uint256);
447 
448 function approve(address spender, uint256 value) external returns(bool);
449 
450 function transfer(address to, uint256 value) external returns(bool);
451 
452 function transferFrom(
453   address from,
454   address to,
455   uint256 value
456 ) external returns(bool);
457 
458 function DOMAIN_SEPARATOR() external view returns(bytes32);
459 
460 function PERMIT_TYPEHASH() external pure returns(bytes32);
461 
462 function nonces(address owner) external view returns(uint256);
463 
464 function permit(
465   address owner,
466   address spender,
467   uint256 value,
468   uint256 deadline,
469   uint8 v,
470   bytes32 r,
471   bytes32 s
472 ) external;
473 
474     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
475     event Burn(
476   address indexed sender,
477   uint256 amount0,
478   uint256 amount1,
479   address indexed to
480 );
481     event Swap(
482   address indexed sender,
483   uint256 amount0In,
484   uint256 amount1In,
485   uint256 amount0Out,
486   uint256 amount1Out,
487   address indexed to
488 );
489     event Sync(uint112 reserve0, uint112 reserve1);
490 
491 function MINIMUM_LIQUIDITY() external pure returns(uint256);
492 
493 function factory() external view returns(address);
494 
495 function token0() external view returns(address);
496 
497 function token1() external view returns(address);
498 
499 function getReserves()
500 external
501 view
502 returns(
503   uint112 reserve0,
504   uint112 reserve1,
505   uint32 blockTimestampLast
506 );
507 
508 function price0CumulativeLast() external view returns(uint256);
509 
510 function price1CumulativeLast() external view returns(uint256);
511 
512 function kLast() external view returns(uint256);
513 
514 function mint(address to) external returns(uint256 liquidity);
515 
516 function burn(address to)
517 external
518 returns(uint256 amount0, uint256 amount1);
519 
520 function swap(
521   uint256 amount0Out,
522   uint256 amount1Out,
523   address to,
524   bytes calldata data
525 ) external;
526 
527 function skim(address to) external;
528 
529 function sync() external;
530 
531 function initialize(address, address) external;
532 }
533 
534 /* pragma solidity 0.8.15; */
535 /* pragma experimental ABIEncoderV2; */
536 
537 interface IUniswapV2Router02 {
538     function factory() external pure returns(address);
539 
540 function WETH() external pure returns(address);
541 
542 function addLiquidity(
543   address tokenA,
544   address tokenB,
545   uint256 amountADesired,
546   uint256 amountBDesired,
547   uint256 amountAMin,
548   uint256 amountBMin,
549   address to,
550   uint256 deadline
551 )
552 external
553 returns(
554   uint256 amountA,
555   uint256 amountB,
556   uint256 liquidity
557 );
558 
559 function addLiquidityETH(
560   address token,
561   uint256 amountTokenDesired,
562   uint256 amountTokenMin,
563   uint256 amountETHMin,
564   address to,
565   uint256 deadline
566 )
567 external
568 payable
569 returns(
570   uint256 amountToken,
571   uint256 amountETH,
572   uint256 liquidity
573 );
574 
575 function swapExactTokensForTokensSupportingFeeOnTransferTokens(
576   uint256 amountIn,
577   uint256 amountOutMin,
578   address[] calldata path,
579   address to,
580   uint256 deadline
581 ) external;
582 
583 function swapExactETHForTokensSupportingFeeOnTransferTokens(
584   uint256 amountOutMin,
585   address[] calldata path,
586   address to,
587   uint256 deadline
588 ) external payable;
589 
590 function swapExactTokensForETHSupportingFeeOnTransferTokens(
591   uint256 amountIn,
592   uint256 amountOutMin,
593   address[] calldata path,
594   address to,
595   uint256 deadline
596 ) external;
597 }
598 
599 /* pragma solidity >=0.8.15; */
600 
601 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
602 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
603 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
604 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
605 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
606 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
607 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
608 
609 contract XINU is ERC20, Ownable {
610     using SafeMath for uint256;
611 
612     IUniswapV2Router02 public  uniswapV2Router;
613     address public  uniswapV2Pair;
614     address public constant deadAddress = address(0xdead);
615 
616     address public x7101 = address(0x7101a9392EAc53B01e7c07ca3baCa945A56EE105);
617     address public x7102 = address(0x7102DC82EF61bfB0410B1b1bF8EA74575bf0A105);
618     address public x7103 = address(0x7103eBdbF1f89be2d53EFF9B3CF996C9E775c105);
619     address public x7104 = address(0x7104D1f179Cc9cc7fb5c79Be6Da846E3FBC4C105);
620     address public x7105 = address(0x7105FAA4a26eD1c67B8B2b41BEc98F06Ee21D105);
621 
622     bool private swapping;
623 
624     address public marketingWallet;
625     address public devWallet;
626 
627     uint256 public maxTransactionAmount;
628     uint256 public swapTokensAtAmount;
629     uint256 public maxWallet;
630 
631     bool public limitsInEffect = true;
632     bool public tradingActive = false;
633     bool public swapEnabled = false;
634 
635   // Anti-bot and anti-whale mappings and variables
636   mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
637     bool public transferDelayEnabled = false;
638 
639     uint256 public buyTotalFees;
640 	uint256 public buyMarketingFee;
641     uint256 public buyBurnFee;
642     uint256 public buyDevFee;
643 
644     uint256 public sellTotalFees;
645     uint256 public sellMarketingFee;
646     uint256 public sellBurnFee;
647     uint256 public sellDevFee;
648 
649     uint256 public tokensForMarketing;
650     uint256 public tokensForBurn;
651     uint256 public tokensForDev;
652 
653   /******************/
654 
655   // exlcude from fees and max transaction amount
656   mapping(address => bool) private _isExcludedFromFees;
657   mapping(address => bool) public _isExcludedMaxTransactionAmount;
658 
659   // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
660   // could be subject to a maximum transfer amount
661   mapping(address => bool) public automatedMarketMakerPairs;
662 
663     event UpdateUniswapV2Router(
664     address indexed newAddress,
665     address indexed oldAddress
666   );
667 
668     event ExcludeFromFees(address indexed account, bool isExcluded);
669 
670     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
671 
672     event SwapAndLiquify(
673     uint256 tokensSwapped,
674     uint256 ethReceived,
675     uint256 tokensIntoLiquidity
676   );
677 
678   constructor() ERC20("XINU", "XINU") {
679         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
680     0x7DE8063E9fB43321d2100e8Ddae5167F56A50060
681   );
682 
683     excludeFromMaxTransaction(address(_uniswapV2Router), true);
684     uniswapV2Router = _uniswapV2Router;
685 
686     uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
687       .createPair(address(this), _uniswapV2Router.WETH());
688     excludeFromMaxTransaction(address(uniswapV2Pair), true);
689     _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
690 
691         uint256 _buyMarketingFee = 5;
692         uint256 _buyBurnFee = 10;
693         uint256 _buyDevFee = 5;
694 
695         uint256 _sellMarketingFee = 5;
696         uint256 _sellBurnFee = 10;
697         uint256 _sellDevFee = 5;
698 
699         uint256 totalSupply = 100000000 * 1e18;
700 
701     maxTransactionAmount = 2000000 * 1e18; // 2% from total supply maxTransactionAmountTxn
702     maxWallet = 2000000 * 1e18; // 2% from total supply maxWallet
703     swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
704 
705     buyMarketingFee = _buyMarketingFee;
706     buyBurnFee = _buyBurnFee;
707     buyDevFee = _buyDevFee;
708     buyTotalFees = buyMarketingFee + buyBurnFee + buyDevFee;
709 
710     sellMarketingFee = _sellMarketingFee;
711     sellBurnFee = _sellBurnFee;
712     sellDevFee = _sellDevFee;
713     sellTotalFees = sellMarketingFee + sellBurnFee + sellDevFee;
714 
715     marketingWallet = address(0x78519E437F5b6051e5d09aAE9210c5b2e8Fe43C2); // set as marketing wallet
716     devWallet = address(0x78d1676854F04F1C32A5965DAf9ff4083fE6Db5d); // set as dev wallet
717 
718     // exclude from paying fees or having max transaction amount
719     excludeFromFees(owner(), true);
720     excludeFromFees(address(this), true);
721     excludeFromFees(address(0xdead), true);
722     excludeFromFees(address(marketingWallet), true);
723     excludeFromFees(address(devWallet), true);
724 
725     excludeFromMaxTransaction(owner(), true);
726     excludeFromMaxTransaction(address(this), true);
727     excludeFromMaxTransaction(address(0xdead), true);
728     excludeFromMaxTransaction(address(marketingWallet), true);
729     excludeFromMaxTransaction(address(devWallet), true);
730 
731     /*
732         _mint is an internal function in ERC20.sol that is only called here,
733         and CANNOT be called ever again
734     */
735     _mint(msg.sender, totalSupply);
736   }
737 
738   receive() external payable { }
739 
740   function setRouter(address _newRouterAddress) external onlyOwner() {
741     IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_newRouterAddress);
742     uniswapV2Router = _uniswapV2Router;
743 
744   }
745   function setPair(address _newPairAddress) external onlyOwner() {
746       uniswapV2Pair = _newPairAddress;
747   }
748 
749   // once enabled, can never be turned off
750   function enableTrading() external onlyOwner {
751     tradingActive = true;
752     swapEnabled = true;
753   }
754 
755   // remove limits after token is stable
756   function removeLimits() external onlyOwner returns(bool) {
757     limitsInEffect = false;
758     return true;
759   }
760 
761   // disable Transfer delay - cannot be reenabled
762   function disableTransferDelay() external onlyOwner returns(bool) {
763     transferDelayEnabled = false;
764     return true;
765   }
766 
767   // change the minimum amount of tokens to sell from fees
768   function updateSwapTokensAtAmount(uint256 newAmount)
769   external
770   onlyOwner
771   returns(bool)
772   {
773     require(
774       newAmount >= (totalSupply() * 1) / 100000,
775       "Swap amount cannot be lower than 0.001% total supply."
776     );
777     require(
778       newAmount <= (totalSupply() * 5) / 1000,
779       "Swap amount cannot be higher than 0.5% total supply."
780     );
781     swapTokensAtAmount = newAmount;
782     return true;
783   }
784 
785   function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
786     require(
787       newNum >= ((totalSupply() * 1) / 1000) / 1e18,
788       "Cannot set maxTransactionAmount lower than 0.1%"
789     );
790     maxTransactionAmount = newNum * (10 ** 18);
791   }
792 
793   function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
794     require(
795       newNum >= ((totalSupply() * 5) / 1000) / 1e18,
796       "Cannot set maxWallet lower than 0.5%"
797     );
798     maxWallet = newNum * (10 ** 18);
799   }
800 
801   function excludeFromMaxTransaction(address updAds, bool isEx)
802   public
803   onlyOwner
804   {
805     _isExcludedMaxTransactionAmount[updAds] = isEx;
806   }
807 
808   // only use to disable contract sales if absolutely necessary (emergency use only)
809   function updateSwapEnabled(bool enabled) external onlyOwner {
810     swapEnabled = enabled;
811   }
812 
813   function excludeFromFees(address account, bool excluded) public onlyOwner {
814     _isExcludedFromFees[account] = excluded;
815         emit ExcludeFromFees(account, excluded);
816   }
817 
818   function setAutomatedMarketMakerPair(address pair, bool value)
819   public
820   onlyOwner
821   {
822     require(
823       pair != uniswapV2Pair,
824       "The pair cannot be removed from automatedMarketMakerPairs"
825     );
826 
827     _setAutomatedMarketMakerPair(pair, value);
828   }
829 
830   function _setAutomatedMarketMakerPair(address pair, bool value) private {
831     automatedMarketMakerPairs[pair] = value;
832 
833         emit SetAutomatedMarketMakerPair(pair, value);
834   }
835 
836   function isExcludedFromFees(address account) public view returns(bool) {
837     return _isExcludedFromFees[account];
838   }
839 
840   function _transfer(
841     address from,
842     address to,
843     uint256 amount
844   ) internal override {
845     require(from != address(0), "ERC20: transfer from the zero address");
846     require(to != address(0), "ERC20: transfer to the zero address");
847 
848     if (amount == 0) {
849       super._transfer(from, to, 0);
850       return;
851     }
852 
853     if (limitsInEffect) {
854       if (
855         from != owner() &&
856         to != owner() &&
857         to != address(0) &&
858         to != address(0xdead) &&
859         !swapping
860       ) {
861         if (!tradingActive) {
862           require(
863             _isExcludedFromFees[from] || _isExcludedFromFees[to],
864             "Trading is not active."
865           );
866         }
867 
868         // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
869         if (transferDelayEnabled) {
870           if (
871             to != owner() &&
872             to != address(uniswapV2Router) &&
873             to != address(uniswapV2Pair)
874           ) {
875             require(
876               _holderLastTransferTimestamp[tx.origin] <
877               block.number,
878               "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
879             );
880             _holderLastTransferTimestamp[tx.origin] = block.number;
881           }
882         }
883 
884         //when buy
885         if (
886           automatedMarketMakerPairs[from] &&
887           !_isExcludedMaxTransactionAmount[to]
888         ) {
889           require(
890             amount <= maxTransactionAmount,
891             "Buy transfer amount exceeds the maxTransactionAmount."
892           );
893           require(
894             amount + balanceOf(to) <= maxWallet,
895             "Max wallet exceeded"
896           );
897         }
898         //when sell
899         else if (
900           automatedMarketMakerPairs[to] &&
901           !_isExcludedMaxTransactionAmount[from]
902         ) {
903           require(
904             amount <= maxTransactionAmount,
905             "Sell transfer amount exceeds the maxTransactionAmount."
906           );
907         } else if (!_isExcludedMaxTransactionAmount[to]) {
908           require(
909             amount + balanceOf(to) <= maxWallet,
910             "Max wallet exceeded"
911           );
912         }
913       }
914     }
915 
916         uint256 contractTokenBalance = balanceOf(address(this));
917 
918         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
919 
920     if (
921       canSwap &&
922       swapEnabled &&
923       !swapping &&
924       !automatedMarketMakerPairs[from] &&
925       !_isExcludedFromFees[from] &&
926       !_isExcludedFromFees[to]
927     ) {
928       swapping = true;
929 
930       swapBack();
931 
932       swapping = false;
933     }
934 
935         bool takeFee = !swapping;
936 
937     // if any account belongs to _isExcludedFromFee account then remove the fee
938     if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
939       takeFee = false;
940     }
941 
942         uint256 fees = 0;
943     // only take fees on buys/sells, do not take on wallet transfers
944     if (takeFee) {
945       // on sell
946       if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
947         fees = amount.mul(sellTotalFees).div(100);
948         tokensForBurn += (fees * sellBurnFee) / sellTotalFees;
949         tokensForDev += (fees * sellDevFee) / sellTotalFees;
950         tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
951       }
952       // on buy
953       else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
954         fees = amount.mul(buyTotalFees).div(100);
955         tokensForBurn += (fees * buyBurnFee) / buyTotalFees;
956         tokensForDev += (fees * buyDevFee) / buyTotalFees;
957         tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
958       }
959 
960       if (fees > 0) {
961         super._transfer(from, address(this), fees);
962       }
963 
964       amount -= fees;
965     }
966 
967     super._transfer(from, to, amount);
968   }
969 
970   function swapTokensForEth(uint256 tokenAmount) private {
971     // generate the uniswap pair path of token -> weth
972     address[] memory path = new address[](2);
973     path[0] = address(this);
974     path[1] = uniswapV2Router.WETH();
975 
976     _approve(address(this), address(uniswapV2Router), tokenAmount);
977 
978     // make the swap
979     uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
980       tokenAmount,
981       0, // accept any amount of ETH
982       path,
983       address(this),
984       block.timestamp
985     );
986   }
987 
988   function burnRandomQuint(uint256 ethAmount) private {
989     // generate the uniswap pair path of token -> weth
990     address[] memory path = new address[](2);
991     address[] memory quints = new address[](5);
992     quints[0] = x7101;
993     quints[1] = x7102;
994     quints[2] = x7103;
995     quints[3] = x7104;
996     quints[4] = x7105;
997 
998     uint256 mod = block.number % 5;
999 
1000     path[0] = uniswapV2Router.WETH();
1001     path[1] = quints[mod];
1002 
1003     // make the swap
1004     uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{ value: ethAmount } (
1005       0,
1006       path,
1007       deadAddress,
1008       block.timestamp
1009     );
1010   }
1011 
1012   function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1013     // approve token transfer to cover all possible scenarios
1014     _approve(address(this), address(uniswapV2Router), tokenAmount);
1015 
1016     // add the liquidity
1017     uniswapV2Router.addLiquidityETH{ value: ethAmount } (
1018       address(this),
1019       tokenAmount,
1020       0, // slippage is unavoidable
1021       0, // slippage is unavoidable
1022       devWallet,
1023       block.timestamp
1024     );
1025   }
1026 
1027   function setFees(uint256 _buyMarketingFee, uint256 _buyBurnFee, uint256 _buyDevFee, uint256 _sellMarketingFee, uint256 _sellBurnFee, uint256 _sellDevFee) public onlyOwner {
1028     buyMarketingFee = _buyMarketingFee;
1029     buyBurnFee = _buyBurnFee;
1030     buyDevFee = _buyDevFee;
1031     buyTotalFees = buyMarketingFee + buyBurnFee + buyDevFee;
1032 
1033     sellMarketingFee = _sellMarketingFee;
1034     sellBurnFee = _sellBurnFee;
1035     sellDevFee = _sellDevFee;
1036     sellTotalFees = sellMarketingFee + sellBurnFee + sellDevFee;
1037   }
1038 
1039 
1040   function swapBack() private {
1041     uint256 contractBalance = balanceOf(address(this));
1042     uint256 totalTokensToSwap = tokensForBurn + tokensForMarketing + tokensForDev;
1043     bool success;
1044 
1045     if (contractBalance == 0 || totalTokensToSwap == 0) {
1046       return;
1047     }
1048 
1049     if (contractBalance > swapTokensAtAmount * 20) {
1050       contractBalance = swapTokensAtAmount * 20;
1051     }
1052 
1053     uint256 initialETHBalance = address(this).balance;
1054 
1055     swapTokensForEth(contractBalance);
1056 
1057     uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1058 
1059     uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1060     uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1061 
1062     (success, ) = address(devWallet).call{ value: ethForDev } ("");
1063     (success, ) = address(marketingWallet).call{ value: ethForMarketing / 2 } ("");
1064 
1065     burnRandomQuint(address(this).balance);
1066   }
1067 
1068 }