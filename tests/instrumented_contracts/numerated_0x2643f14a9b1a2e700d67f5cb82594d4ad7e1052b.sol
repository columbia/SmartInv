1 /**
2 
3 Telegram: https://t.me/DeepFuckingValueERC
4 Twitter: https://twitter.com/DVFonChain
5 Website: https://www.dfvcoin.vip/
6 
7 */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
11 pragma experimental ABIEncoderV2;
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
23 abstract contract Ownable is Context {
24     address private _owner;
25 
26     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28     constructor() {
29         _transferOwnership(_msgSender());
30     }
31 
32     function owner() public view virtual returns (address) {
33         return _owner;
34     }
35 
36     modifier onlyOwner() {
37         require(owner() == _msgSender(), "Ownable: caller is not the owner");
38         _;
39     }
40 
41     function renounceOwnership() public virtual onlyOwner {
42         _transferOwnership(address(0));
43     }
44 
45     function transferOwnership(address newOwner) public virtual onlyOwner {
46         require(newOwner != address(0), "Ownable: new owner is the zero address");
47         _transferOwnership(newOwner);
48     }
49 
50     function _transferOwnership(address newOwner) internal virtual {
51         address oldOwner = _owner;
52         _owner = newOwner;
53         emit OwnershipTransferred(oldOwner, newOwner);
54     }
55 }
56 
57 interface IERC20 {
58 
59     function totalSupply() external view returns (uint256);
60 
61     function balanceOf(address account) external view returns (uint256);
62 
63     function transfer(address recipient, uint256 amount) external returns (bool);
64 
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     function transferFrom(
70         address sender,
71         address recipient,
72         uint256 amount
73     ) external returns (bool);
74 
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 interface IERC20Metadata is IERC20 {
81 
82     function name() external view returns (string memory);
83 
84     function symbol() external view returns (string memory);
85 
86     function decimals() external view returns (uint8);
87 }
88 
89 contract ERC20 is Context, IERC20, IERC20Metadata {
90     mapping(address => uint256) private _balances;
91 
92     mapping(address => mapping(address => uint256)) private _allowances;
93 
94     uint256 private _totalSupply;
95 
96     string private _name;
97     string private _symbol;
98 
99     constructor(string memory name_, string memory symbol_) {
100         _name = name_;
101         _symbol = symbol_;
102     }
103 
104     function name() public view virtual override returns (string memory) {
105         return _name;
106     }
107 
108     function symbol() public view virtual override returns (string memory) {
109         return _symbol;
110     }
111 
112     function decimals() public view virtual override returns (uint8) {
113         return 18;
114     }
115 
116     function totalSupply() public view virtual override returns (uint256) {
117         return _totalSupply;
118     }
119 
120     function balanceOf(address account) public view virtual override returns (uint256) {
121         return _balances[account];
122     }
123 
124     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
125         _transfer(_msgSender(), recipient, amount);
126         return true;
127     }
128 
129     function allowance(address owner, address spender) public view virtual override returns (uint256) {
130         return _allowances[owner][spender];
131     }
132 
133     function approve(address spender, uint256 amount) public virtual override returns (bool) {
134         _approve(_msgSender(), spender, amount);
135         return true;
136     }
137 
138     function transferFrom(
139         address sender,
140         address recipient,
141         uint256 amount
142     ) public virtual override returns (bool) {
143         _transfer(sender, recipient, amount);
144 
145         uint256 currentAllowance = _allowances[sender][_msgSender()];
146         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
147         unchecked {
148             _approve(sender, _msgSender(), currentAllowance - amount);
149         }
150 
151         return true;
152     }
153 
154     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
155         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
156         return true;
157     }
158 
159     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
160         uint256 currentAllowance = _allowances[_msgSender()][spender];
161         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
162         unchecked {
163             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
164         }
165 
166         return true;
167     }
168 
169     function _transfer(
170         address sender,
171         address recipient,
172         uint256 amount
173     ) internal virtual {
174         require(sender != address(0), "ERC20: transfer from the zero address");
175         require(recipient != address(0), "ERC20: transfer to the zero address");
176 
177         _beforeTokenTransfer(sender, recipient, amount);
178 
179         uint256 senderBalance = _balances[sender];
180         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
181         unchecked {
182             _balances[sender] = senderBalance - amount;
183         }
184         _balances[recipient] += amount;
185 
186         emit Transfer(sender, recipient, amount);
187 
188         _afterTokenTransfer(sender, recipient, amount);
189     }
190 
191     function _mint(address account, uint256 amount) internal virtual {
192         require(account != address(0), "ERC20: mint to the zero address");
193 
194         _beforeTokenTransfer(address(0), account, amount);
195 
196         _totalSupply += amount;
197         _balances[account] += amount;
198         emit Transfer(address(0), account, amount);
199 
200         _afterTokenTransfer(address(0), account, amount);
201     }
202 
203     function _burn(address account, uint256 amount) internal virtual {
204         require(account != address(0), "ERC20: burn from the zero address");
205 
206         _beforeTokenTransfer(account, address(0), amount);
207 
208         uint256 accountBalance = _balances[account];
209         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
210         unchecked {
211             _balances[account] = accountBalance - amount;
212         }
213         _totalSupply -= amount;
214 
215         emit Transfer(account, address(0), amount);
216 
217         _afterTokenTransfer(account, address(0), amount);
218     }
219 
220     function _approve(
221         address owner,
222         address spender,
223         uint256 amount
224     ) internal virtual {
225         require(owner != address(0), "ERC20: approve from the zero address");
226         require(spender != address(0), "ERC20: approve to the zero address");
227 
228         _allowances[owner][spender] = amount;
229         emit Approval(owner, spender, amount);
230     }
231 
232     function _beforeTokenTransfer(
233         address from,
234         address to,
235         uint256 amount
236     ) internal virtual {}
237 
238     function _afterTokenTransfer(
239         address from,
240         address to,
241         uint256 amount
242     ) internal virtual {}
243 }
244 
245 library SafeMath {
246 
247     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
248         unchecked {
249             uint256 c = a + b;
250             if (c < a) return (false, 0);
251             return (true, c);
252         }
253     }
254 
255     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
256         unchecked {
257             if (b > a) return (false, 0);
258             return (true, a - b);
259         }
260     }
261 
262     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
263         unchecked {
264             if (a == 0) return (true, 0);
265             uint256 c = a * b;
266             if (c / a != b) return (false, 0);
267             return (true, c);
268         }
269     }
270 
271     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
272         unchecked {
273             if (b == 0) return (false, 0);
274             return (true, a / b);
275         }
276     }
277 
278     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
279         unchecked {
280             if (b == 0) return (false, 0);
281             return (true, a % b);
282         }
283     }
284 
285     function add(uint256 a, uint256 b) internal pure returns (uint256) {
286         return a + b;
287     }
288 
289     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
290         return a - b;
291     }
292 
293     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
294         return a * b;
295     }
296 
297     function div(uint256 a, uint256 b) internal pure returns (uint256) {
298         return a / b;
299     }
300 
301     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
302         return a % b;
303     }
304 
305     function sub(
306         uint256 a,
307         uint256 b,
308         string memory errorMessage
309     ) internal pure returns (uint256) {
310         unchecked {
311             require(b <= a, errorMessage);
312             return a - b;
313         }
314     }
315 
316     function div(
317         uint256 a,
318         uint256 b,
319         string memory errorMessage
320     ) internal pure returns (uint256) {
321         unchecked {
322             require(b > 0, errorMessage);
323             return a / b;
324         }
325     }
326 
327     function mod(
328         uint256 a,
329         uint256 b,
330         string memory errorMessage
331     ) internal pure returns (uint256) {
332         unchecked {
333             require(b > 0, errorMessage);
334             return a % b;
335         }
336     }
337 }
338 
339 interface IUniswapV2Factory {
340     event PairCreated(
341         address indexed token0,
342         address indexed token1,
343         address pair,
344         uint256
345     );
346 
347     function feeTo() external view returns (address);
348 
349     function feeToSetter() external view returns (address);
350 
351     function getPair(address tokenA, address tokenB)
352         external
353         view
354         returns (address pair);
355 
356     function allPairs(uint256) external view returns (address pair);
357 
358     function allPairsLength() external view returns (uint256);
359 
360     function createPair(address tokenA, address tokenB)
361         external
362         returns (address pair);
363 
364     function setFeeTo(address) external;
365 
366     function setFeeToSetter(address) external;
367 }
368 
369 interface IUniswapV2Pair {
370     event Approval(
371         address indexed owner,
372         address indexed spender,
373         uint256 value
374     );
375     event Transfer(address indexed from, address indexed to, uint256 value);
376 
377     function name() external pure returns (string memory);
378 
379     function symbol() external pure returns (string memory);
380 
381     function decimals() external pure returns (uint8);
382 
383     function totalSupply() external view returns (uint256);
384 
385     function balanceOf(address owner) external view returns (uint256);
386 
387     function allowance(address owner, address spender)
388         external
389         view
390         returns (uint256);
391 
392     function approve(address spender, uint256 value) external returns (bool);
393 
394     function transfer(address to, uint256 value) external returns (bool);
395 
396     function transferFrom(
397         address from,
398         address to,
399         uint256 value
400     ) external returns (bool);
401 
402     function DOMAIN_SEPARATOR() external view returns (bytes32);
403 
404     function PERMIT_TYPEHASH() external pure returns (bytes32);
405 
406     function nonces(address owner) external view returns (uint256);
407 
408     function permit(
409         address owner,
410         address spender,
411         uint256 value,
412         uint256 deadline,
413         uint8 v,
414         bytes32 r,
415         bytes32 s
416     ) external;
417 
418     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
419     event Burn(
420         address indexed sender,
421         uint256 amount0,
422         uint256 amount1,
423         address indexed to
424     );
425     event Swap(
426         address indexed sender,
427         uint256 amount0In,
428         uint256 amount1In,
429         uint256 amount0Out,
430         uint256 amount1Out,
431         address indexed to
432     );
433     event Sync(uint112 reserve0, uint112 reserve1);
434 
435     function MINIMUM_LIQUIDITY() external pure returns (uint256);
436 
437     function factory() external view returns (address);
438 
439     function token0() external view returns (address);
440 
441     function token1() external view returns (address);
442 
443     function getReserves()
444         external
445         view
446         returns (
447             uint112 reserve0,
448             uint112 reserve1,
449             uint32 blockTimestampLast
450         );
451 
452     function price0CumulativeLast() external view returns (uint256);
453 
454     function price1CumulativeLast() external view returns (uint256);
455 
456     function kLast() external view returns (uint256);
457 
458     function mint(address to) external returns (uint256 liquidity);
459 
460     function burn(address to)
461         external
462         returns (uint256 amount0, uint256 amount1);
463 
464     function swap(
465         uint256 amount0Out,
466         uint256 amount1Out,
467         address to,
468         bytes calldata data
469     ) external;
470 
471     function skim(address to) external;
472 
473     function sync() external;
474 
475     function initialize(address, address) external;
476 }
477 
478 interface IUniswapV2Router02 {
479     function factory() external pure returns (address);
480 
481     function WETH() external pure returns (address);
482 
483     function addLiquidity(
484         address tokenA,
485         address tokenB,
486         uint256 amountADesired,
487         uint256 amountBDesired,
488         uint256 amountAMin,
489         uint256 amountBMin,
490         address to,
491         uint256 deadline
492     )
493         external
494         returns (
495             uint256 amountA,
496             uint256 amountB,
497             uint256 liquidity
498         );
499 
500     function addLiquidityETH(
501         address token,
502         uint256 amountTokenDesired,
503         uint256 amountTokenMin,
504         uint256 amountETHMin,
505         address to,
506         uint256 deadline
507     )
508         external
509         payable
510         returns (
511             uint256 amountToken,
512             uint256 amountETH,
513             uint256 liquidity
514         );
515 
516     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
517         uint256 amountIn,
518         uint256 amountOutMin,
519         address[] calldata path,
520         address to,
521         uint256 deadline
522     ) external;
523 
524     function swapExactETHForTokensSupportingFeeOnTransferTokens(
525         uint256 amountOutMin,
526         address[] calldata path,
527         address to,
528         uint256 deadline
529     ) external payable;
530 
531     function swapExactTokensForETHSupportingFeeOnTransferTokens(
532         uint256 amountIn,
533         uint256 amountOutMin,
534         address[] calldata path,
535         address to,
536         uint256 deadline
537     ) external;
538 }
539 
540 contract DeepFuckingValue is ERC20, Ownable {
541     using SafeMath for uint256;
542 
543     IUniswapV2Router02 public immutable uniswapV2Router;
544     address public immutable uniswapV2Pair;
545     address public constant deadAddress = address(0xdead);
546     address public routerCA = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D uniswap
547 
548     bool private swapping;
549 
550     address public mktgWallet;
551     address public devWallet;
552     address public liqWallet;
553     address public operationsWallet;
554 
555     uint256 public maxTransactionAmount;
556     uint256 public swapTokensAtAmount;
557     uint256 public maxWallet;
558 
559     bool public limitsInEffect = true;
560     bool public tradingActive = false;
561     bool public swapEnabled = false;
562 
563     // Anti-bot and anti-whale mappings and variables
564     mapping(address => uint256) private _holderLastTransferTimestamp;
565     bool public transferDelayEnabled = true;
566     uint256 private launchBlock;
567     uint256 private deadBlocks;
568     mapping(address => bool) public blocked;
569 
570     uint256 public buyTotalFees;
571     uint256 public buyMktgFee;
572     uint256 public buyLiquidityFee;
573     uint256 public buyDevFee;
574     uint256 public buyOperationsFee;
575 
576     uint256 public sellTotalFees;
577     uint256 public sellMktgFee;
578     uint256 public sellLiquidityFee;
579     uint256 public sellDevFee;
580     uint256 public sellOperationsFee;
581 
582     uint256 public tokensForMktg;
583     uint256 public tokensForLiquidity;
584     uint256 public tokensForDev;
585     uint256 public tokensForOperations;
586 
587     mapping(address => bool) private _isExcludedFromFees;
588     mapping(address => bool) public _isExcludedMaxTransactionAmount;
589 
590     mapping(address => bool) public automatedMarketMakerPairs;
591 
592     event UpdateUniswapV2Router(
593         address indexed newAddress,
594         address indexed oldAddress
595     );
596 
597     event ExcludeFromFees(address indexed account, bool isExcluded);
598 
599     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
600 
601     event mktgWalletUpdated(
602         address indexed newWallet,
603         address indexed oldWallet
604     );
605 
606     event devWalletUpdated(
607         address indexed newWallet,
608         address indexed oldWallet
609     );
610 
611     event liqWalletUpdated(
612         address indexed newWallet,
613         address indexed oldWallet
614     );
615 
616     event operationsWalletUpdated(
617         address indexed newWallet,
618         address indexed oldWallet
619     );
620 
621     event SwapAndLiquify(
622         uint256 tokensSwapped,
623         uint256 ethReceived,
624         uint256 tokensIntoLiquidity
625     );
626 
627     constructor() ERC20("DeepFuckingValue", "DFV") {
628         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(routerCA); 
629 
630         excludeFromMaxTransaction(address(_uniswapV2Router), true);
631         uniswapV2Router = _uniswapV2Router;
632 
633         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
634             .createPair(address(this), _uniswapV2Router.WETH());
635         excludeFromMaxTransaction(address(uniswapV2Pair), true);
636         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
637 
638         // launch buy fees
639         uint256 _buyMktgFee = 20;
640         uint256 _buyLiquidityFee = 0;
641         uint256 _buyDevFee = 0;
642         uint256 _buyOperationsFee = 0;
643         
644         // launch sell fees
645         uint256 _sellMktgFee = 45;
646         uint256 _sellLiquidityFee = 0;
647         uint256 _sellDevFee = 0;
648         uint256 _sellOperationsFee = 0;
649 
650         uint256 totalSupply = 2_000_000 * 1e18;
651 
652         maxTransactionAmount = 40_000 * 1e18; // 2% max txn
653         maxWallet = 40_000 * 1e18; // 2% max wallet
654         swapTokensAtAmount = (totalSupply * 5) / 1000; // 0.5% swap wallet
655 
656         buyMktgFee = _buyMktgFee;
657         buyLiquidityFee = _buyLiquidityFee;
658         buyDevFee = _buyDevFee;
659         buyOperationsFee = _buyOperationsFee;
660         buyTotalFees = buyMktgFee + buyLiquidityFee + buyDevFee + buyOperationsFee;
661 
662         sellMktgFee = _sellMktgFee;
663         sellLiquidityFee = _sellLiquidityFee;
664         sellDevFee = _sellDevFee;
665         sellOperationsFee = _sellOperationsFee;
666         sellTotalFees = sellMktgFee + sellLiquidityFee + sellDevFee + sellOperationsFee;
667 
668         mktgWallet = address(0xE7fDe2b164bf88CE6B5739bAAA72deEC77C8e5a6); 
669         devWallet = address(0xE7fDe2b164bf88CE6B5739bAAA72deEC77C8e5a6); 
670         liqWallet = address(0xE7fDe2b164bf88CE6B5739bAAA72deEC77C8e5a6); 
671         operationsWallet = address(0xE7fDe2b164bf88CE6B5739bAAA72deEC77C8e5a6);
672 
673         // exclude from paying fees or having max transaction amount
674         excludeFromFees(owner(), true);
675         excludeFromFees(address(this), true);
676         excludeFromFees(address(0xdead), true);
677 
678         excludeFromMaxTransaction(owner(), true);
679         excludeFromMaxTransaction(address(this), true);
680         excludeFromMaxTransaction(address(0xdead), true);
681 
682         _mint(msg.sender, totalSupply);
683     }
684 
685     receive() external payable {}
686 
687     function enableTrading(uint256 _deadBlocks) external onlyOwner {
688         require(!tradingActive, "Token launched");
689         tradingActive = true;
690         launchBlock = block.number;
691         swapEnabled = true;
692         deadBlocks = _deadBlocks;
693     }
694 
695     // remove limits after token is stable
696     function removeLimits() external onlyOwner returns (bool) {
697         limitsInEffect = false;
698         return true;
699     }
700 
701     // disable Transfer delay - cannot be reenabled
702     function disableTransferDelay() external onlyOwner returns (bool) {
703         transferDelayEnabled = false;
704         return true;
705     }
706 
707     // change the minimum amount of tokens to sell from fees
708     function updateSwapTokensAtAmount(uint256 newAmount)
709         external
710         onlyOwner
711         returns (bool)
712     {
713         require(
714             newAmount >= (totalSupply() * 1) / 100000,
715             "Swap amount cannot be lower than 0.001% total supply."
716         );
717         require(
718             newAmount <= (totalSupply() * 5) / 1000,
719             "Swap amount cannot be higher than 0.5% total supply."
720         );
721         swapTokensAtAmount = newAmount;
722         return true;
723     }
724 
725     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
726         require(
727             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
728             "Cannot set maxTransactionAmount lower than 0.1%"
729         );
730         maxTransactionAmount = newNum * (10**18);
731     }
732 
733     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
734         require(
735             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
736             "Cannot set maxWallet lower than 0.5%"
737         );
738         maxWallet = newNum * (10**18);
739     }
740 
741     function excludeFromMaxTransaction(address updAds, bool isEx)
742         public
743         onlyOwner
744     {
745         _isExcludedMaxTransactionAmount[updAds] = isEx;
746     }
747 
748     // only use to disable contract sales if absolutely necessary (emergency use only)
749     function updateSwapEnabled(bool enabled) external onlyOwner {
750         swapEnabled = enabled;
751     }
752 
753     function updateBuyFees(
754         uint256 _mktgFee,
755         uint256 _liquidityFee,
756         uint256 _devFee,
757         uint256 _operationsFee
758     ) external onlyOwner {
759         buyMktgFee = _mktgFee;
760         buyLiquidityFee = _liquidityFee;
761         buyDevFee = _devFee;
762         buyOperationsFee = _operationsFee;
763         buyTotalFees = buyMktgFee + buyLiquidityFee + buyDevFee + buyOperationsFee;
764         require(buyTotalFees <= 99);
765     }
766 
767     function updateSellFees(
768         uint256 _mktgFee,
769         uint256 _liquidityFee,
770         uint256 _devFee,
771         uint256 _operationsFee
772     ) external onlyOwner {
773         sellMktgFee = _mktgFee;
774         sellLiquidityFee = _liquidityFee;
775         sellDevFee = _devFee;
776         sellOperationsFee = _operationsFee;
777         sellTotalFees = sellMktgFee + sellLiquidityFee + sellDevFee + sellOperationsFee;
778         require(sellTotalFees <= 99); 
779     }
780 
781     function excludeFromFees(address account, bool excluded) public onlyOwner {
782         _isExcludedFromFees[account] = excluded;
783         emit ExcludeFromFees(account, excluded);
784     }
785 
786     function setAutomatedMarketMakerPair(address pair, bool value)
787         public
788         onlyOwner
789     {
790         require(
791             pair != uniswapV2Pair,
792             "The pair cannot be removed from automatedMarketMakerPairs"
793         );
794 
795         _setAutomatedMarketMakerPair(pair, value);
796     }
797 
798     function _setAutomatedMarketMakerPair(address pair, bool value) private {
799         automatedMarketMakerPairs[pair] = value;
800 
801         emit SetAutomatedMarketMakerPair(pair, value);
802     }
803 
804     function updatemktgWallet(address newmktgWallet) external onlyOwner {
805         emit mktgWalletUpdated(newmktgWallet, mktgWallet);
806         mktgWallet = newmktgWallet;
807     }
808 
809     function updateDevWallet(address newWallet) external onlyOwner {
810         emit devWalletUpdated(newWallet, devWallet);
811         devWallet = newWallet;
812     }
813 
814     function updateoperationsWallet(address newWallet) external onlyOwner{
815         emit operationsWalletUpdated(newWallet, operationsWallet);
816         operationsWallet = newWallet;
817     }
818 
819     function updateLiqWallet(address newLiqWallet) external onlyOwner {
820         emit liqWalletUpdated(newLiqWallet, liqWallet);
821         liqWallet = newLiqWallet;
822     }
823 
824     function isExcludedFromFees(address account) public view returns (bool) {
825         return _isExcludedFromFees[account];
826     }
827 
828     event BoughtEarly(address indexed sniper);
829 
830     function _transfer(
831         address from,
832         address to,
833         uint256 amount
834     ) internal override {
835         require(from != address(0), "ERC20: transfer from the zero address");
836         require(to != address(0), "ERC20: transfer to the zero address");
837         require(!blocked[from], "Sniper blocked");
838 
839         if (amount == 0) {
840             super._transfer(from, to, 0);
841             return;
842         }
843 
844         if (limitsInEffect) {
845             if (
846                 from != owner() &&
847                 to != owner() &&
848                 to != address(0) &&
849                 to != address(0xdead) &&
850                 !swapping
851             ) {
852                 if (!tradingActive) {
853                     require(
854                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
855                         "Trading is not active."
856                     );
857                 }
858 
859                 if(block.number < launchBlock + deadBlocks && from == address(uniswapV2Pair) &&  
860                 to != routerCA && to != address(this) && to != address(uniswapV2Pair)){
861                     blocked[to] = false;
862                     emit BoughtEarly(to);
863                 }
864 
865                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
866                 if (transferDelayEnabled) {
867                     if (
868                         to != owner() &&
869                         to != address(uniswapV2Router) &&
870                         to != address(uniswapV2Pair)
871                     ) {
872                         require(
873                             _holderLastTransferTimestamp[tx.origin] <
874                                 block.number,
875                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
876                         );
877                         _holderLastTransferTimestamp[tx.origin] = block.number;
878                     }
879                 }
880 
881                 //when buy
882                 if (
883                     automatedMarketMakerPairs[from] &&
884                     !_isExcludedMaxTransactionAmount[to]
885                 ) {
886                     require(
887                         amount <= maxTransactionAmount,
888                         "Buy transfer amount exceeds the maxTransactionAmount."
889                     );
890                     require(
891                         amount + balanceOf(to) <= maxWallet,
892                         "Max wallet exceeded"
893                     );
894                 }
895                 //when sell
896                 else if (
897                     automatedMarketMakerPairs[to] &&
898                     !_isExcludedMaxTransactionAmount[from]
899                 ) {
900                     require(
901                         amount <= maxTransactionAmount,
902                         "Sell transfer amount exceeds the maxTransactionAmount."
903                     );
904                 } else if (!_isExcludedMaxTransactionAmount[to]) {
905                     require(
906                         amount + balanceOf(to) <= maxWallet,
907                         "Max wallet exceeded"
908                     );
909                 }
910             }
911         }
912 
913         uint256 contractTokenBalance = balanceOf(address(this));
914 
915         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
916 
917         if (
918             canSwap &&
919             swapEnabled &&
920             !swapping &&
921             !automatedMarketMakerPairs[from] &&
922             !_isExcludedFromFees[from] &&
923             !_isExcludedFromFees[to]
924         ) {
925             swapping = true;
926 
927             swapBack();
928 
929             swapping = false;
930         }
931 
932         bool takeFee = !swapping;
933 
934         // if any account belongs to _isExcludedFromFee account then remove the fee
935         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
936             takeFee = false;
937         }
938 
939         uint256 fees = 0;
940         // only take fees on buys/sells, do not take on wallet transfers
941         if (takeFee) {
942             // on sell
943             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
944                 fees = amount.mul(sellTotalFees).div(100);
945                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
946                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
947                 tokensForMktg += (fees * sellMktgFee) / sellTotalFees;
948                 tokensForOperations += (fees * sellOperationsFee) / sellTotalFees;
949             }
950             // on buy
951             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
952                 fees = amount.mul(buyTotalFees).div(100);
953                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
954                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
955                 tokensForMktg += (fees * buyMktgFee) / buyTotalFees;
956                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
957             }
958 
959             if (fees > 0) {
960                 super._transfer(from, address(this), fees);
961             }
962 
963             amount -= fees;
964         }
965 
966         super._transfer(from, to, amount);
967     }
968 
969     function swapTokensForEth(uint256 tokenAmount) private {
970         // generate the uniswap pair path of token -> weth
971         address[] memory path = new address[](2);
972         path[0] = address(this);
973         path[1] = uniswapV2Router.WETH();
974 
975         _approve(address(this), address(uniswapV2Router), tokenAmount);
976 
977         // make the swap
978         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
979             tokenAmount,
980             0, // accept any amount of ETH
981             path,
982             address(this),
983             block.timestamp
984         );
985     }
986 
987     function multiBlock(address[] calldata blockees, bool shouldBlock) external onlyOwner {
988         for(uint256 i = 0;i<blockees.length;i++){
989             address blockee = blockees[i];
990             if(blockee != address(this) && 
991                blockee != routerCA && 
992                blockee != address(uniswapV2Pair))
993                 blocked[blockee] = shouldBlock;
994         }
995     }
996 
997     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
998         // approve token transfer to cover all possible scenarios
999         _approve(address(this), address(uniswapV2Router), tokenAmount);
1000 
1001         // add the liquidity
1002         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1003             address(this),
1004             tokenAmount,
1005             0, // slippage is unavoidable
1006             0, // slippage is unavoidable
1007             liqWallet,
1008             block.timestamp
1009         );
1010     }
1011 
1012     function swapBack() private {
1013         uint256 contractBalance = balanceOf(address(this));
1014         uint256 totalTokensToSwap = tokensForLiquidity +
1015             tokensForMktg +
1016             tokensForDev +
1017             tokensForOperations;
1018         bool success;
1019 
1020         if (contractBalance == 0 || totalTokensToSwap == 0) {
1021             return;
1022         }
1023 
1024         if (contractBalance > swapTokensAtAmount * 20) {
1025             contractBalance = swapTokensAtAmount * 20;
1026         }
1027 
1028         // Halve the amount of liquidity tokens
1029         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1030         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1031 
1032         uint256 initialETHBalance = address(this).balance;
1033 
1034         swapTokensForEth(amountToSwapForETH);
1035 
1036         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1037 
1038         uint256 ethForMktg = ethBalance.mul(tokensForMktg).div(totalTokensToSwap);
1039         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1040         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap);
1041 
1042         uint256 ethForLiquidity = ethBalance - ethForMktg - ethForDev - ethForOperations;
1043 
1044         tokensForLiquidity = 0;
1045         tokensForMktg = 0;
1046         tokensForDev = 0;
1047         tokensForOperations = 0;
1048 
1049         (success, ) = address(devWallet).call{value: ethForDev}("");
1050 
1051         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1052             addLiquidity(liquidityTokens, ethForLiquidity);
1053             emit SwapAndLiquify(
1054                 amountToSwapForETH,
1055                 ethForLiquidity,
1056                 tokensForLiquidity
1057             );
1058         }
1059         (success, ) = address(operationsWallet).call{value: ethForOperations}("");
1060         (success, ) = address(mktgWallet).call{value: address(this).balance}("");
1061     }
1062 }