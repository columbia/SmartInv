1 /*
2 
3 www.kiraeth.com
4 
5 https://t.me/kiraportal
6 
7 https://twitter.com/KiraraERC
8 
9 
10 */
11 
12 // SPDX-License-Identifier: MIT
13 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
14 pragma experimental ABIEncoderV2;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 abstract contract Ownable is Context {
27     address private _owner;
28 
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     constructor() {
32         _transferOwnership(_msgSender());
33     }
34 
35     function owner() public view virtual returns (address) {
36         return _owner;
37     }
38 
39 
40     modifier onlyOwner() {
41         require(owner() == _msgSender(), "Ownable: caller is not the owner");
42         _;
43     }
44 
45 
46     function renounceOwnership() public virtual onlyOwner {
47         _transferOwnership(address(0));
48     }
49 
50     function transferOwnership(address newOwner) public virtual onlyOwner {
51         require(newOwner != address(0), "Ownable: new owner is the zero address");
52         _transferOwnership(newOwner);
53     }
54 
55     function _transferOwnership(address newOwner) internal virtual {
56         address oldOwner = _owner;
57         _owner = newOwner;
58         emit OwnershipTransferred(oldOwner, newOwner);
59     }
60 }
61 
62 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
63 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
64 
65 interface IERC20 {
66 
67     function totalSupply() external view returns (uint256);
68 
69     function balanceOf(address account) external view returns (uint256);
70 
71     function transfer(address recipient, uint256 amount) external returns (bool);
72 
73     function allowance(address owner, address spender) external view returns (uint256);
74 
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77     function transferFrom(
78         address sender,
79         address recipient,
80         uint256 amount
81     ) external returns (bool);
82 
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
89 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
90 
91 /* pragma solidity ^0.8.0; */
92 
93 /* import "../IERC20.sol"; */
94 
95 
96 interface IERC20Metadata is IERC20 {
97 
98     function name() external view returns (string memory);
99 
100     function symbol() external view returns (string memory);
101 
102     function decimals() external view returns (uint8);
103 }
104 
105 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
106 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
107 
108 /* pragma solidity ^0.8.0; */
109 
110 /* import "./IERC20.sol"; */
111 /* import "./extensions/IERC20Metadata.sol"; */
112 /* import "../../utils/Context.sol"; */
113 
114 contract ERC20 is Context, IERC20, IERC20Metadata {
115     mapping(address => uint256) private _balances;
116 
117     mapping(address => mapping(address => uint256)) private _allowances;
118 
119     uint256 private _totalSupply;
120 
121     string private _name;
122     string private _symbol;
123 
124     constructor(string memory name_, string memory symbol_) {
125         _name = name_;
126         _symbol = symbol_;
127     }
128 
129     function name() public view virtual override returns (string memory) {
130         return _name;
131     }
132 
133     function symbol() public view virtual override returns (string memory) {
134         return _symbol;
135     }
136 
137     function decimals() public view virtual override returns (uint8) {
138         return 18;
139     }
140 
141     function totalSupply() public view virtual override returns (uint256) {
142         return _totalSupply;
143     }
144 
145     function balanceOf(address account) public view virtual override returns (uint256) {
146         return _balances[account];
147     }
148 
149     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
150         _transfer(_msgSender(), recipient, amount);
151         return true;
152     }
153 
154     function allowance(address owner, address spender) public view virtual override returns (uint256) {
155         return _allowances[owner][spender];
156     }
157 
158     function approve(address spender, uint256 amount) public virtual override returns (bool) {
159         _approve(_msgSender(), spender, amount);
160         return true;
161     }
162 
163     function transferFrom(
164         address sender,
165         address recipient,
166         uint256 amount
167     ) public virtual override returns (bool) {
168         _transfer(sender, recipient, amount);
169 
170         uint256 currentAllowance = _allowances[sender][_msgSender()];
171         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
172         unchecked {
173             _approve(sender, _msgSender(), currentAllowance - amount);
174         }
175 
176         return true;
177     }
178 
179     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
180         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
181         return true;
182     }
183 
184     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
185         uint256 currentAllowance = _allowances[_msgSender()][spender];
186         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
187         unchecked {
188             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
189         }
190 
191         return true;
192     }
193 
194     function _transfer(
195         address sender,
196         address recipient,
197         uint256 amount
198     ) internal virtual {
199         require(sender != address(0), "ERC20: transfer from the zero address");
200         require(recipient != address(0), "ERC20: transfer to the zero address");
201 
202         _beforeTokenTransfer(sender, recipient, amount);
203 
204         uint256 senderBalance = _balances[sender];
205         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
206         unchecked {
207             _balances[sender] = senderBalance - amount;
208         }
209         _balances[recipient] += amount;
210 
211         emit Transfer(sender, recipient, amount);
212 
213         _afterTokenTransfer(sender, recipient, amount);
214     }
215 
216     function _mint(address account, uint256 amount) internal virtual {
217         require(account != address(0), "ERC20: mint to the zero address");
218 
219         _beforeTokenTransfer(address(0), account, amount);
220 
221         _totalSupply += amount;
222         _balances[account] += amount;
223         emit Transfer(address(0), account, amount);
224 
225         _afterTokenTransfer(address(0), account, amount);
226     }
227 
228     function _burn(address account, uint256 amount) internal virtual {
229         require(account != address(0), "ERC20: burn from the zero address");
230 
231         _beforeTokenTransfer(account, address(0), amount);
232 
233         uint256 accountBalance = _balances[account];
234         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
235         unchecked {
236             _balances[account] = accountBalance - amount;
237         }
238         _totalSupply -= amount;
239 
240         emit Transfer(account, address(0), amount);
241 
242         _afterTokenTransfer(account, address(0), amount);
243     }
244 
245     function _approve(
246         address owner,
247         address spender,
248         uint256 amount
249     ) internal virtual {
250         require(owner != address(0), "ERC20: approve from the zero address");
251         require(spender != address(0), "ERC20: approve to the zero address");
252 
253         _allowances[owner][spender] = amount;
254         emit Approval(owner, spender, amount);
255     }
256 
257     function _beforeTokenTransfer(
258         address from,
259         address to,
260         uint256 amount
261     ) internal virtual {}
262 
263     function _afterTokenTransfer(
264         address from,
265         address to,
266         uint256 amount
267     ) internal virtual {}
268 }
269 
270 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
271 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
272 
273 /* pragma solidity ^0.8.0; */
274 
275 
276 library SafeMath {
277 
278     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
279         unchecked {
280             uint256 c = a + b;
281             if (c < a) return (false, 0);
282             return (true, c);
283         }
284     }
285 
286     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
287         unchecked {
288             if (b > a) return (false, 0);
289             return (true, a - b);
290         }
291     }
292 
293     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
294         unchecked {
295             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
296             // benefit is lost if 'b' is also tested.
297             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
298             if (a == 0) return (true, 0);
299             uint256 c = a * b;
300             if (c / a != b) return (false, 0);
301             return (true, c);
302         }
303     }
304 
305     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
306         unchecked {
307             if (b == 0) return (false, 0);
308             return (true, a / b);
309         }
310     }
311 
312     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
313         unchecked {
314             if (b == 0) return (false, 0);
315             return (true, a % b);
316         }
317     }
318 
319     function add(uint256 a, uint256 b) internal pure returns (uint256) {
320         return a + b;
321     }
322 
323     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
324         return a - b;
325     }
326 
327     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
328         return a * b;
329     }
330 
331     function div(uint256 a, uint256 b) internal pure returns (uint256) {
332         return a / b;
333     }
334 
335     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
336         return a % b;
337     }
338 
339     function sub(
340         uint256 a,
341         uint256 b,
342         string memory errorMessage
343     ) internal pure returns (uint256) {
344         unchecked {
345             require(b <= a, errorMessage);
346             return a - b;
347         }
348     }
349 
350     function div(
351         uint256 a,
352         uint256 b,
353         string memory errorMessage
354     ) internal pure returns (uint256) {
355         unchecked {
356             require(b > 0, errorMessage);
357             return a / b;
358         }
359     }
360 
361     function mod(
362         uint256 a,
363         uint256 b,
364         string memory errorMessage
365     ) internal pure returns (uint256) {
366         unchecked {
367             require(b > 0, errorMessage);
368             return a % b;
369         }
370     }
371 }
372 
373 /* pragma solidity 0.8.10; */
374 /* pragma experimental ABIEncoderV2; */
375 
376 interface IUniswapV2Factory {
377     event PairCreated(
378         address indexed token0,
379         address indexed token1,
380         address pair,
381         uint256
382     );
383 
384     function feeTo() external view returns (address);
385 
386     function feeToSetter() external view returns (address);
387 
388     function getPair(address tokenA, address tokenB)
389         external
390         view
391         returns (address pair);
392 
393     function allPairs(uint256) external view returns (address pair);
394 
395     function allPairsLength() external view returns (uint256);
396 
397     function createPair(address tokenA, address tokenB)
398         external
399         returns (address pair);
400 
401     function setFeeTo(address) external;
402 
403     function setFeeToSetter(address) external;
404 }
405 
406 /* pragma solidity 0.8.10; */
407 /* pragma experimental ABIEncoderV2; */
408 
409 interface IUniswapV2Pair {
410     event Approval(
411         address indexed owner,
412         address indexed spender,
413         uint256 value
414     );
415     event Transfer(address indexed from, address indexed to, uint256 value);
416 
417     function name() external pure returns (string memory);
418 
419     function symbol() external pure returns (string memory);
420 
421     function decimals() external pure returns (uint8);
422 
423     function totalSupply() external view returns (uint256);
424 
425     function balanceOf(address owner) external view returns (uint256);
426 
427     function allowance(address owner, address spender)
428         external
429         view
430         returns (uint256);
431 
432     function approve(address spender, uint256 value) external returns (bool);
433 
434     function transfer(address to, uint256 value) external returns (bool);
435 
436     function transferFrom(
437         address from,
438         address to,
439         uint256 value
440     ) external returns (bool);
441 
442     function DOMAIN_SEPARATOR() external view returns (bytes32);
443 
444     function PERMIT_TYPEHASH() external pure returns (bytes32);
445 
446     function nonces(address owner) external view returns (uint256);
447 
448     function permit(
449         address owner,
450         address spender,
451         uint256 value,
452         uint256 deadline,
453         uint8 v,
454         bytes32 r,
455         bytes32 s
456     ) external;
457 
458     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
459     event Burn(
460         address indexed sender,
461         uint256 amount0,
462         uint256 amount1,
463         address indexed to
464     );
465     event Swap(
466         address indexed sender,
467         uint256 amount0In,
468         uint256 amount1In,
469         uint256 amount0Out,
470         uint256 amount1Out,
471         address indexed to
472     );
473     event Sync(uint112 reserve0, uint112 reserve1);
474 
475     function MINIMUM_LIQUIDITY() external pure returns (uint256);
476 
477     function factory() external view returns (address);
478 
479     function token0() external view returns (address);
480 
481     function token1() external view returns (address);
482 
483     function getReserves()
484         external
485         view
486         returns (
487             uint112 reserve0,
488             uint112 reserve1,
489             uint32 blockTimestampLast
490         );
491 
492     function price0CumulativeLast() external view returns (uint256);
493 
494     function price1CumulativeLast() external view returns (uint256);
495 
496     function kLast() external view returns (uint256);
497 
498     function mint(address to) external returns (uint256 liquidity);
499 
500     function burn(address to)
501         external
502         returns (uint256 amount0, uint256 amount1);
503 
504     function swap(
505         uint256 amount0Out,
506         uint256 amount1Out,
507         address to,
508         bytes calldata data
509     ) external;
510 
511     function skim(address to) external;
512 
513     function sync() external;
514 
515     function initialize(address, address) external;
516 }
517 
518 /* pragma solidity 0.8.10; */
519 /* pragma experimental ABIEncoderV2; */
520 
521 interface IUniswapV2Router02 {
522     function factory() external pure returns (address);
523 
524     function WETH() external pure returns (address);
525 
526     function addLiquidity(
527         address tokenA,
528         address tokenB,
529         uint256 amountADesired,
530         uint256 amountBDesired,
531         uint256 amountAMin,
532         uint256 amountBMin,
533         address to,
534         uint256 deadline
535     )
536         external
537         returns (
538             uint256 amountA,
539             uint256 amountB,
540             uint256 liquidity
541         );
542 
543     function addLiquidityETH(
544         address token,
545         uint256 amountTokenDesired,
546         uint256 amountTokenMin,
547         uint256 amountETHMin,
548         address to,
549         uint256 deadline
550     )
551         external
552         payable
553         returns (
554             uint256 amountToken,
555             uint256 amountETH,
556             uint256 liquidity
557         );
558 
559     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
560         uint256 amountIn,
561         uint256 amountOutMin,
562         address[] calldata path,
563         address to,
564         uint256 deadline
565     ) external;
566 
567     function swapExactETHForTokensSupportingFeeOnTransferTokens(
568         uint256 amountOutMin,
569         address[] calldata path,
570         address to,
571         uint256 deadline
572     ) external payable;
573 
574     function swapExactTokensForETHSupportingFeeOnTransferTokens(
575         uint256 amountIn,
576         uint256 amountOutMin,
577         address[] calldata path,
578         address to,
579         uint256 deadline
580     ) external;
581 }
582 
583 /* pragma solidity >=0.8.10; */
584 
585 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
586 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
587 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
588 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
589 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
590 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
591 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
592 
593 contract Kira is ERC20, Ownable {
594     using SafeMath for uint256;
595 
596     IUniswapV2Router02 public immutable uniswapV2Router;
597     address public immutable uniswapV2Pair;
598     address public constant deadAddress = address(0xdead);
599 
600     bool private swapping;
601 
602     address public devWallet;
603 
604     uint256 public maxTransactionAmount;
605     uint256 public swapTokensAtAmount;
606     uint256 public maxWallet;
607 
608     bool public limitsInEffect = true;
609     bool public tradingActive = false;
610     bool public swapEnabled = false;
611 
612     uint256 public buyTotalFees;
613     uint256 public buyLiquidityFee;
614     uint256 public buyDevFee;
615 
616     uint256 public sellTotalFees;
617     uint256 public sellLiquidityFee;
618     uint256 public sellDevFee;
619 
620 	uint256 public tokensForLiquidity;
621     uint256 public tokensForDev;
622 
623     /******************/
624 
625     // exlcude from fees and max transaction amount
626     mapping(address => bool) private _isExcludedFromFees;
627     mapping(address => bool) public _isExcludedMaxTransactionAmount;
628 
629     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
630     // could be subject to a maximum transfer amount
631     mapping(address => bool) public automatedMarketMakerPairs;
632 
633     event UpdateUniswapV2Router(
634         address indexed newAddress,
635         address indexed oldAddress
636     );
637 
638     event ExcludeFromFees(address indexed account, bool isExcluded);
639 
640     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
641 
642     event SwapAndLiquify(
643         uint256 tokensSwapped,
644         uint256 ethReceived,
645         uint256 tokensIntoLiquidity
646     );
647 
648     constructor() ERC20("Kirara", "KIRA") {
649         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
650             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
651         );
652 
653         excludeFromMaxTransaction(address(_uniswapV2Router), true);
654         uniswapV2Router = _uniswapV2Router;
655 
656         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
657             .createPair(address(this), _uniswapV2Router.WETH());
658         excludeFromMaxTransaction(address(uniswapV2Pair), true);
659         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
660 
661         uint256 _buyLiquidityFee = 0;
662         uint256 _buyDevFee = 5;
663 
664         uint256 _sellLiquidityFee = 0;
665         uint256 _sellDevFee = 6;
666 
667         uint256 totalSupply = 1 * 1e9 * 1e18;
668 
669         maxTransactionAmount = 2 * 1e7 * 1e18; // 2% from total supply maxTransactionAmountTxn
670         maxWallet = 2 * 1e7 * 1e18; // 2% from total supply maxWallet
671         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
672 
673         buyLiquidityFee = _buyLiquidityFee;
674         buyDevFee = _buyDevFee;
675         buyTotalFees = buyLiquidityFee + buyDevFee;
676 
677         sellLiquidityFee = _sellLiquidityFee;
678         sellDevFee = _sellDevFee;
679         sellTotalFees = sellLiquidityFee + sellDevFee;
680 
681         devWallet = address(0x0eAD437A8A247Fd563BB11FF1D02e76D93990287); // set as dev wallet
682 
683         // exclude from paying fees or having max transaction amount
684         excludeFromFees(owner(), true);
685         excludeFromFees(address(this), true);
686         excludeFromFees(address(0xdead), true);
687 
688         excludeFromMaxTransaction(owner(), true);
689         excludeFromMaxTransaction(address(this), true);
690         excludeFromMaxTransaction(address(0xdead), true);
691 
692         /*
693             _mint is an internal function in ERC20.sol that is only called here,
694             and CANNOT be called ever again
695         */
696         _mint(msg.sender, totalSupply);
697     }
698 
699     receive() external payable {}
700 
701     // once enabled, can never be turned off
702     function enableTrading() external onlyOwner {
703         tradingActive = true;
704         swapEnabled = true;
705     }
706 
707     // remove limits after token is stable
708     function removeLimits() external onlyOwner returns (bool) {
709         limitsInEffect = false;
710         return true;
711     }
712 
713     // change the minimum amount of tokens to sell from fees
714     function updateSwapTokensAtAmount(uint256 newAmount)
715         external
716         onlyOwner
717         returns (bool)
718     {
719         require(
720             newAmount >= (totalSupply() * 1) / 100000,
721             "Swap amount cannot be lower than 0.001% total supply."
722         );
723         require(
724             newAmount <= (totalSupply() * 5) / 1000,
725             "Swap amount cannot be higher than 0.5% total supply."
726         );
727         swapTokensAtAmount = newAmount;
728         return true;
729     }
730 	
731     function excludeFromMaxTransaction(address updAds, bool isEx)
732         public
733         onlyOwner
734     {
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
748     function setAutomatedMarketMakerPair(address pair, bool value)
749         public
750         onlyOwner
751     {
752         require(
753             pair != uniswapV2Pair,
754             "The pair cannot be removed from automatedMarketMakerPairs"
755         );
756 
757         _setAutomatedMarketMakerPair(pair, value);
758     }
759 
760     function _setAutomatedMarketMakerPair(address pair, bool value) private {
761         automatedMarketMakerPairs[pair] = value;
762 
763         emit SetAutomatedMarketMakerPair(pair, value);
764     }
765 
766     function isExcludedFromFees(address account) public view returns (bool) {
767         return _isExcludedFromFees[account];
768     }
769 
770     function _transfer(
771         address from,
772         address to,
773         uint256 amount
774     ) internal override {
775         require(from != address(0), "ERC20: transfer from the zero address");
776         require(to != address(0), "ERC20: transfer to the zero address");
777 
778         if (amount == 0) {
779             super._transfer(from, to, 0);
780             return;
781         }
782 
783         if (limitsInEffect) {
784             if (
785                 from != owner() &&
786                 to != owner() &&
787                 to != address(0) &&
788                 to != address(0xdead) &&
789                 !swapping
790             ) {
791                 if (!tradingActive) {
792                     require(
793                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
794                         "Trading is not active."
795                     );
796                 }
797 
798                 //when buy
799                 if (
800                     automatedMarketMakerPairs[from] &&
801                     !_isExcludedMaxTransactionAmount[to]
802                 ) {
803                     require(
804                         amount <= maxTransactionAmount,
805                         "Buy transfer amount exceeds the maxTransactionAmount."
806                     );
807                     require(
808                         amount + balanceOf(to) <= maxWallet,
809                         "Max wallet exceeded"
810                     );
811                 }
812                 //when sell
813                 else if (
814                     automatedMarketMakerPairs[to] &&
815                     !_isExcludedMaxTransactionAmount[from]
816                 ) {
817                     require(
818                         amount <= maxTransactionAmount,
819                         "Sell transfer amount exceeds the maxTransactionAmount."
820                     );
821                 } else if (!_isExcludedMaxTransactionAmount[to]) {
822                     require(
823                         amount + balanceOf(to) <= maxWallet,
824                         "Max wallet exceeded"
825                     );
826                 }
827             }
828         }
829 
830         uint256 contractTokenBalance = balanceOf(address(this));
831 
832         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
833 
834         if (
835             canSwap &&
836             swapEnabled &&
837             !swapping &&
838             !automatedMarketMakerPairs[from] &&
839             !_isExcludedFromFees[from] &&
840             !_isExcludedFromFees[to]
841         ) {
842             swapping = true;
843 
844             swapBack();
845 
846             swapping = false;
847         }
848 
849         bool takeFee = !swapping;
850 
851         // if any account belongs to _isExcludedFromFee account then remove the fee
852         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
853             takeFee = false;
854         }
855 
856         uint256 fees = 0;
857         // only take fees on buys/sells, do not take on wallet transfers
858         if (takeFee) {
859             // on sell
860             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
861                 fees = amount.mul(sellTotalFees).div(100);
862                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
863                 tokensForDev += (fees * sellDevFee) / sellTotalFees;                
864             }
865             // on buy
866             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
867                 fees = amount.mul(buyTotalFees).div(100);
868                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
869                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
870             }
871 
872             if (fees > 0) {
873                 super._transfer(from, address(this), fees);
874             }
875 
876             amount -= fees;
877         }
878 
879         super._transfer(from, to, amount);
880     }
881 
882     function swapTokensForEth(uint256 tokenAmount) private {
883         // generate the uniswap pair path of token -> weth
884         address[] memory path = new address[](2);
885         path[0] = address(this);
886         path[1] = uniswapV2Router.WETH();
887 
888         _approve(address(this), address(uniswapV2Router), tokenAmount);
889 
890         // make the swap
891         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
892             tokenAmount,
893             0, // accept any amount of ETH
894             path,
895             address(this),
896             block.timestamp
897         );
898     }
899 
900     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
901         // approve token transfer to cover all possible scenarios
902         _approve(address(this), address(uniswapV2Router), tokenAmount);
903 
904         // add the liquidity
905         uniswapV2Router.addLiquidityETH{value: ethAmount}(
906             address(this),
907             tokenAmount,
908             0, // slippage is unavoidable
909             0, // slippage is unavoidable
910             devWallet,
911             block.timestamp
912         );
913     }
914 
915     function swapBack() private {
916         uint256 contractBalance = balanceOf(address(this));
917         uint256 totalTokensToSwap = tokensForLiquidity + tokensForDev;
918         bool success;
919 
920         if (contractBalance == 0 || totalTokensToSwap == 0) {
921             return;
922         }
923 
924         if (contractBalance > swapTokensAtAmount * 20) {
925             contractBalance = swapTokensAtAmount * 20;
926         }
927 
928         // Halve the amount of liquidity tokens
929         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
930         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
931 
932         uint256 initialETHBalance = address(this).balance;
933 
934         swapTokensForEth(amountToSwapForETH);
935 
936         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
937 	
938         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
939 
940         uint256 ethForLiquidity = ethBalance - ethForDev;
941 
942         tokensForLiquidity = 0;
943         tokensForDev = 0;
944 
945         if (liquidityTokens > 0 && ethForLiquidity > 0) {
946             addLiquidity(liquidityTokens, ethForLiquidity);
947             emit SwapAndLiquify(
948                 amountToSwapForETH,
949                 ethForLiquidity,
950                 tokensForLiquidity
951             );
952         }
953 
954         (success, ) = address(devWallet).call{value: address(this).balance}("");
955     }
956 
957 }