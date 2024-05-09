1 /**
2 
3 https://T.me/WallShitBets
4 */
5 // SPDX-License-Identifier: MIT
6 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
7 pragma experimental ABIEncoderV2;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         return msg.data;
16     }
17 }
18 
19 abstract contract Ownable is Context {
20     address private _owner;
21 
22     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 
24     constructor() {
25         _transferOwnership(_msgSender());
26     }
27 
28     function owner() public view virtual returns (address) {
29         return _owner;
30     }
31 
32     modifier onlyOwner() {
33         require(owner() == _msgSender(), "Ownable: caller is not the owner");
34         _;
35     }
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
46     function _transferOwnership(address newOwner) internal virtual {
47         address oldOwner = _owner;
48         _owner = newOwner;
49         emit OwnershipTransferred(oldOwner, newOwner);
50     }
51 }
52 
53 interface IERC20 {
54 
55     function totalSupply() external view returns (uint256);
56 
57     function balanceOf(address account) external view returns (uint256);
58 
59     function transfer(address recipient, uint256 amount) external returns (bool);
60 
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     function transferFrom(
66         address sender,
67         address recipient,
68         uint256 amount
69     ) external returns (bool);
70 
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 interface IERC20Metadata is IERC20 {
77 
78     function name() external view returns (string memory);
79 
80     function symbol() external view returns (string memory);
81 
82     function decimals() external view returns (uint8);
83 }
84 
85 contract ERC20 is Context, IERC20, IERC20Metadata {
86     mapping(address => uint256) private _balances;
87 
88     mapping(address => mapping(address => uint256)) private _allowances;
89 
90     uint256 private _totalSupply;
91 
92     string private _name;
93     string private _symbol;
94 
95     constructor(string memory name_, string memory symbol_) {
96         _name = name_;
97         _symbol = symbol_;
98     }
99 
100     function name() public view virtual override returns (string memory) {
101         return _name;
102     }
103 
104     function symbol() public view virtual override returns (string memory) {
105         return _symbol;
106     }
107 
108     function decimals() public view virtual override returns (uint8) {
109         return 18;
110     }
111 
112     function totalSupply() public view virtual override returns (uint256) {
113         return _totalSupply;
114     }
115 
116     function balanceOf(address account) public view virtual override returns (uint256) {
117         return _balances[account];
118     }
119 
120     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
121         _transfer(_msgSender(), recipient, amount);
122         return true;
123     }
124 
125     function allowance(address owner, address spender) public view virtual override returns (uint256) {
126         return _allowances[owner][spender];
127     }
128 
129     function approve(address spender, uint256 amount) public virtual override returns (bool) {
130         _approve(_msgSender(), spender, amount);
131         return true;
132     }
133 
134     function transferFrom(
135         address sender,
136         address recipient,
137         uint256 amount
138     ) public virtual override returns (bool) {
139         _transfer(sender, recipient, amount);
140 
141         uint256 currentAllowance = _allowances[sender][_msgSender()];
142         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
143         unchecked {
144             _approve(sender, _msgSender(), currentAllowance - amount);
145         }
146 
147         return true;
148     }
149 
150     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
151         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
152         return true;
153     }
154 
155     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
156         uint256 currentAllowance = _allowances[_msgSender()][spender];
157         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
158         unchecked {
159             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
160         }
161 
162         return true;
163     }
164 
165     function _transfer(
166         address sender,
167         address recipient,
168         uint256 amount
169     ) internal virtual {
170         require(sender != address(0), "ERC20: transfer from the zero address");
171         require(recipient != address(0), "ERC20: transfer to the zero address");
172 
173         _beforeTokenTransfer(sender, recipient, amount);
174 
175         uint256 senderBalance = _balances[sender];
176         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
177         unchecked {
178             _balances[sender] = senderBalance - amount;
179         }
180         _balances[recipient] += amount;
181 
182         emit Transfer(sender, recipient, amount);
183 
184         _afterTokenTransfer(sender, recipient, amount);
185     }
186 
187     function _mint(address account, uint256 amount) internal virtual {
188         require(account != address(0), "ERC20: mint to the zero address");
189 
190         _beforeTokenTransfer(address(0), account, amount);
191 
192         _totalSupply += amount;
193         _balances[account] += amount;
194         emit Transfer(address(0), account, amount);
195 
196         _afterTokenTransfer(address(0), account, amount);
197     }
198 
199     function _burn(address account, uint256 amount) internal virtual {
200         require(account != address(0), "ERC20: burn from the zero address");
201 
202         _beforeTokenTransfer(account, address(0), amount);
203 
204         uint256 accountBalance = _balances[account];
205         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
206         unchecked {
207             _balances[account] = accountBalance - amount;
208         }
209         _totalSupply -= amount;
210 
211         emit Transfer(account, address(0), amount);
212 
213         _afterTokenTransfer(account, address(0), amount);
214     }
215 
216     function _approve(
217         address owner,
218         address spender,
219         uint256 amount
220     ) internal virtual {
221         require(owner != address(0), "ERC20: approve from the zero address");
222         require(spender != address(0), "ERC20: approve to the zero address");
223 
224         _allowances[owner][spender] = amount;
225         emit Approval(owner, spender, amount);
226     }
227 
228     function _beforeTokenTransfer(
229         address from,
230         address to,
231         uint256 amount
232     ) internal virtual {}
233 
234     function _afterTokenTransfer(
235         address from,
236         address to,
237         uint256 amount
238     ) internal virtual {}
239 }
240 
241 library SafeMath {
242 
243     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
244         unchecked {
245             uint256 c = a + b;
246             if (c < a) return (false, 0);
247             return (true, c);
248         }
249     }
250 
251     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
252         unchecked {
253             if (b > a) return (false, 0);
254             return (true, a - b);
255         }
256     }
257 
258     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
259         unchecked {
260             if (a == 0) return (true, 0);
261             uint256 c = a * b;
262             if (c / a != b) return (false, 0);
263             return (true, c);
264         }
265     }
266 
267     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
268         unchecked {
269             if (b == 0) return (false, 0);
270             return (true, a / b);
271         }
272     }
273 
274     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
275         unchecked {
276             if (b == 0) return (false, 0);
277             return (true, a % b);
278         }
279     }
280 
281     function add(uint256 a, uint256 b) internal pure returns (uint256) {
282         return a + b;
283     }
284 
285     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
286         return a - b;
287     }
288 
289     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
290         return a * b;
291     }
292 
293     function div(uint256 a, uint256 b) internal pure returns (uint256) {
294         return a / b;
295     }
296 
297     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
298         return a % b;
299     }
300 
301     function sub(
302         uint256 a,
303         uint256 b,
304         string memory errorMessage
305     ) internal pure returns (uint256) {
306         unchecked {
307             require(b <= a, errorMessage);
308             return a - b;
309         }
310     }
311 
312     function div(
313         uint256 a,
314         uint256 b,
315         string memory errorMessage
316     ) internal pure returns (uint256) {
317         unchecked {
318             require(b > 0, errorMessage);
319             return a / b;
320         }
321     }
322 
323     function mod(
324         uint256 a,
325         uint256 b,
326         string memory errorMessage
327     ) internal pure returns (uint256) {
328         unchecked {
329             require(b > 0, errorMessage);
330             return a % b;
331         }
332     }
333 }
334 
335 interface IUniswapV2Factory {
336     event PairCreated(
337         address indexed token0,
338         address indexed token1,
339         address pair,
340         uint256
341     );
342 
343     function feeTo() external view returns (address);
344 
345     function feeToSetter() external view returns (address);
346 
347     function getPair(address tokenA, address tokenB)
348         external
349         view
350         returns (address pair);
351 
352     function allPairs(uint256) external view returns (address pair);
353 
354     function allPairsLength() external view returns (uint256);
355 
356     function createPair(address tokenA, address tokenB)
357         external
358         returns (address pair);
359 
360     function setFeeTo(address) external;
361 
362     function setFeeToSetter(address) external;
363 }
364 
365 interface IUniswapV2Pair {
366     event Approval(
367         address indexed owner,
368         address indexed spender,
369         uint256 value
370     );
371     event Transfer(address indexed from, address indexed to, uint256 value);
372 
373     function name() external pure returns (string memory);
374 
375     function symbol() external pure returns (string memory);
376 
377     function decimals() external pure returns (uint8);
378 
379     function totalSupply() external view returns (uint256);
380 
381     function balanceOf(address owner) external view returns (uint256);
382 
383     function allowance(address owner, address spender)
384         external
385         view
386         returns (uint256);
387 
388     function approve(address spender, uint256 value) external returns (bool);
389 
390     function transfer(address to, uint256 value) external returns (bool);
391 
392     function transferFrom(
393         address from,
394         address to,
395         uint256 value
396     ) external returns (bool);
397 
398     function DOMAIN_SEPARATOR() external view returns (bytes32);
399 
400     function PERMIT_TYPEHASH() external pure returns (bytes32);
401 
402     function nonces(address owner) external view returns (uint256);
403 
404     function permit(
405         address owner,
406         address spender,
407         uint256 value,
408         uint256 deadline,
409         uint8 v,
410         bytes32 r,
411         bytes32 s
412     ) external;
413 
414     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
415     event Burn(
416         address indexed sender,
417         uint256 amount0,
418         uint256 amount1,
419         address indexed to
420     );
421     event Swap(
422         address indexed sender,
423         uint256 amount0In,
424         uint256 amount1In,
425         uint256 amount0Out,
426         uint256 amount1Out,
427         address indexed to
428     );
429     event Sync(uint112 reserve0, uint112 reserve1);
430 
431     function MINIMUM_LIQUIDITY() external pure returns (uint256);
432 
433     function factory() external view returns (address);
434 
435     function token0() external view returns (address);
436 
437     function token1() external view returns (address);
438 
439     function getReserves()
440         external
441         view
442         returns (
443             uint112 reserve0,
444             uint112 reserve1,
445             uint32 blockTimestampLast
446         );
447 
448     function price0CumulativeLast() external view returns (uint256);
449 
450     function price1CumulativeLast() external view returns (uint256);
451 
452     function kLast() external view returns (uint256);
453 
454     function mint(address to) external returns (uint256 liquidity);
455 
456     function burn(address to)
457         external
458         returns (uint256 amount0, uint256 amount1);
459 
460     function swap(
461         uint256 amount0Out,
462         uint256 amount1Out,
463         address to,
464         bytes calldata data
465     ) external;
466 
467     function skim(address to) external;
468 
469     function sync() external;
470 
471     function initialize(address, address) external;
472 }
473 
474 interface IUniswapV2Router02 {
475     function factory() external pure returns (address);
476 
477     function WETH() external pure returns (address);
478 
479     function addLiquidity(
480         address tokenA,
481         address tokenB,
482         uint256 amountADesired,
483         uint256 amountBDesired,
484         uint256 amountAMin,
485         uint256 amountBMin,
486         address to,
487         uint256 deadline
488     )
489         external
490         returns (
491             uint256 amountA,
492             uint256 amountB,
493             uint256 liquidity
494         );
495 
496     function addLiquidityETH(
497         address token,
498         uint256 amountTokenDesired,
499         uint256 amountTokenMin,
500         uint256 amountETHMin,
501         address to,
502         uint256 deadline
503     )
504         external
505         payable
506         returns (
507             uint256 amountToken,
508             uint256 amountETH,
509             uint256 liquidity
510         );
511 
512     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
513         uint256 amountIn,
514         uint256 amountOutMin,
515         address[] calldata path,
516         address to,
517         uint256 deadline
518     ) external;
519 
520     function swapExactETHForTokensSupportingFeeOnTransferTokens(
521         uint256 amountOutMin,
522         address[] calldata path,
523         address to,
524         uint256 deadline
525     ) external payable;
526 
527     function swapExactTokensForETHSupportingFeeOnTransferTokens(
528         uint256 amountIn,
529         uint256 amountOutMin,
530         address[] calldata path,
531         address to,
532         uint256 deadline
533     ) external;
534 }
535 
536 contract WallShitBets is ERC20, Ownable {
537     using SafeMath for uint256;
538 
539     IUniswapV2Router02 public immutable uniswapV2Router;
540     address public immutable uniswapV2Pair;
541     address private constant deadAddress = address(0xdead);
542     address private routerCA = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D uniswap
543 
544     bool private swapping;
545 
546     address private mktgWallet;
547     address private devWallet;
548     address private liqWallet;
549     address private operationsWallet;
550 
551     uint256 private maxTransactionAmount;
552     uint256 private swapTokensAtAmount;
553     uint256 private maxWallet;
554 
555     bool public limitsInEffect = true;
556     bool public tradingActive = false;
557     bool public swapEnabled = false;
558 
559     // Anti-bot and anti-whale mappings and variables
560     mapping(address => uint256) private _holderLastTransferTimestamp;
561     bool public transferDelayEnabled = true;
562     uint256 private launchBlock;
563     uint256 private deadBlocks;
564     mapping(address => bool) public blocked;
565 
566     uint256 public buyTotalFees;
567     uint256 public buyMktgFee;
568     uint256 public buyLiquidityFee;
569     uint256 public buyDevFee;
570     uint256 public buyOperationsFee;
571 
572     uint256 public sellTotalFees;
573     uint256 public sellMktgFee;
574     uint256 public sellLiquidityFee;
575     uint256 public sellDevFee;
576     uint256 public sellOperationsFee;
577 
578     uint256 private tokensForMktg;
579     uint256 private tokensForLiquidity;
580     uint256 private tokensForDev;
581     uint256 private tokensForOperations;
582 
583     mapping(address => bool) private _isExcludedFromFees;
584     mapping(address => bool) private _isExcludedMaxTransactionAmount;
585 
586     mapping(address => bool) public automatedMarketMakerPairs;
587 
588     event UpdateUniswapV2Router(
589         address indexed newAddress,
590         address indexed oldAddress
591     );
592 
593     event ExcludeFromFees(address indexed account, bool isExcluded);
594 
595     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
596 
597     event mktgWalletUpdated(
598         address indexed newWallet,
599         address indexed oldWallet
600     );
601 
602     event devWalletUpdated(
603         address indexed newWallet,
604         address indexed oldWallet
605     );
606 
607     event liqWalletUpdated(
608         address indexed newWallet,
609         address indexed oldWallet
610     );
611 
612     event operationsWalletUpdated(
613         address indexed newWallet,
614         address indexed oldWallet
615     );
616 
617     event SwapAndLiquify(
618         uint256 tokensSwapped,
619         uint256 ethReceived,
620         uint256 tokensIntoLiquidity
621     );
622 
623     constructor() ERC20("WallShitBets", "WSB") {
624         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(routerCA); 
625 
626         excludeFromMaxTransaction(address(_uniswapV2Router), true);
627         uniswapV2Router = _uniswapV2Router;
628 
629         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
630             .createPair(address(this), _uniswapV2Router.WETH());
631         excludeFromMaxTransaction(address(uniswapV2Pair), true);
632         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
633 
634         // launch buy fees
635         uint256 _buyMktgFee = 10;
636         uint256 _buyLiquidityFee = 5;
637         uint256 _buyDevFee = 10;
638         uint256 _buyOperationsFee = 20;
639         
640         // launch sell fees
641         uint256 _sellMktgFee = 20;
642         uint256 _sellLiquidityFee = 5;
643         uint256 _sellDevFee = 10;
644         uint256 _sellOperationsFee = 10;
645 
646         uint256 totalSupply = 1_000_000 * 1e18;
647 
648         maxTransactionAmount = 10_000 * 1e18; // 2% max txn
649         maxWallet = 20_000 * 1e18; // 2% max wallet
650         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
651 
652         buyMktgFee = _buyMktgFee;
653         buyLiquidityFee = _buyLiquidityFee;
654         buyDevFee = _buyDevFee;
655         buyOperationsFee = _buyOperationsFee;
656         buyTotalFees = buyMktgFee + buyLiquidityFee + buyDevFee + buyOperationsFee;
657 
658         sellMktgFee = _sellMktgFee;
659         sellLiquidityFee = _sellLiquidityFee;
660         sellDevFee = _sellDevFee;
661         sellOperationsFee = _sellOperationsFee;
662         sellTotalFees = sellMktgFee + sellLiquidityFee + sellDevFee + sellOperationsFee;
663 
664         mktgWallet = address(0xfb93d4B5ac6f7a3d8f99a9517C45B8b808e68004); 
665         devWallet = address(0xdBf04E5Ab9E5b6d0E0a6216113F613b8776b5f3F); 
666         liqWallet = address(0xcb0658F877431f9565F44e45840956122728862e); 
667         operationsWallet = address(0xC69A3e5087932404ac2f2066419AbB1e14f8DE5a);
668 
669         // exclude from paying fees or having max transaction amount
670         excludeFromFees(owner(), true);
671         excludeFromFees(address(this), true);
672         excludeFromFees(address(0xdead), true);
673 
674         excludeFromMaxTransaction(owner(), true);
675         excludeFromMaxTransaction(address(this), true);
676         excludeFromMaxTransaction(address(0xdead), true);
677 
678         _mint(msg.sender, totalSupply);
679     }
680 
681     receive() external payable {}
682 
683     function enableTrading(uint256 _deadBlocks) external onlyOwner {
684         require(!tradingActive, "Token launched");
685         tradingActive = true;
686         launchBlock = block.number;
687         swapEnabled = true;
688         deadBlocks = _deadBlocks;
689     }
690 
691     // remove limits after token is stable
692     function removeLimits() external onlyOwner returns (bool) {
693         limitsInEffect = false;
694         return true;
695     }
696 
697     // disable Transfer delay - cannot be reenabled
698     function disableTransferDelay() external onlyOwner returns (bool) {
699         transferDelayEnabled = false;
700         return true;
701     }
702 
703     // change the minimum amount of tokens to sell from fees
704     function updateSwapTokensAtAmount(uint256 newAmount)
705         external
706         onlyOwner
707         returns (bool)
708     {
709         require(
710             newAmount >= (totalSupply() * 1) / 100000,
711             "Swap amount cannot be lower than 0.001% total supply."
712         );
713         require(
714             newAmount <= (totalSupply() * 5) / 1000,
715             "Swap amount cannot be higher than 0.5% total supply."
716         );
717         swapTokensAtAmount = newAmount;
718         return true;
719     }
720 
721     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
722         require(
723             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
724             "Cannot set maxTransactionAmount lower than 0.1%"
725         );
726         maxTransactionAmount = newNum * (10**18);
727     }
728 
729     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
730         require(
731             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
732             "Cannot set maxWallet lower than 0.5%"
733         );
734         maxWallet = newNum * (10**18);
735     }
736 
737     function excludeFromMaxTransaction(address updAds, bool isEx)
738         public
739         onlyOwner
740     {
741         _isExcludedMaxTransactionAmount[updAds] = isEx;
742     }
743 
744     // only use to disable contract sales if absolutely necessary (emergency use only)
745     function updateSwapEnabled(bool enabled) external onlyOwner {
746         swapEnabled = enabled;
747     }
748 
749     function updateBuyFees(
750         uint256 _mktgFee,
751         uint256 _liquidityFee,
752         uint256 _devFee,
753         uint256 _operationsFee
754     ) external onlyOwner {
755         buyMktgFee = _mktgFee;
756         buyLiquidityFee = _liquidityFee;
757         buyDevFee = _devFee;
758         buyOperationsFee = _operationsFee;
759         buyTotalFees = buyMktgFee + buyLiquidityFee + buyDevFee + buyOperationsFee;
760         require(buyTotalFees <= 99);
761     }
762 
763     function updateSellFees(
764         uint256 _mktgFee,
765         uint256 _liquidityFee,
766         uint256 _devFee,
767         uint256 _operationsFee
768     ) external onlyOwner {
769         sellMktgFee = _mktgFee;
770         sellLiquidityFee = _liquidityFee;
771         sellDevFee = _devFee;
772         sellOperationsFee = _operationsFee;
773         sellTotalFees = sellMktgFee + sellLiquidityFee + sellDevFee + sellOperationsFee;
774         require(sellTotalFees <= 99); 
775     }
776 
777     function excludeFromFees(address account, bool excluded) public onlyOwner {
778         _isExcludedFromFees[account] = excluded;
779         emit ExcludeFromFees(account, excluded);
780     }
781 
782     function setAutomatedMarketMakerPair(address pair, bool value)
783         public
784         onlyOwner
785     {
786         require(
787             pair != uniswapV2Pair,
788             "The pair cannot be removed from automatedMarketMakerPairs"
789         );
790 
791         _setAutomatedMarketMakerPair(pair, value);
792     }
793 
794     function _setAutomatedMarketMakerPair(address pair, bool value) private {
795         automatedMarketMakerPairs[pair] = value;
796 
797         emit SetAutomatedMarketMakerPair(pair, value);
798     }
799 
800     function updatemktgWallet(address newmktgWallet) external onlyOwner {
801         emit mktgWalletUpdated(newmktgWallet, mktgWallet);
802         mktgWallet = newmktgWallet;
803     }
804 
805     function updateDevWallet(address newWallet) external onlyOwner {
806         emit devWalletUpdated(newWallet, devWallet);
807         devWallet = newWallet;
808     }
809 
810     function updateoperationsWallet(address newWallet) external onlyOwner{
811         emit operationsWalletUpdated(newWallet, operationsWallet);
812         operationsWallet = newWallet;
813     }
814 
815     function updateLiqWallet(address newLiqWallet) external onlyOwner {
816         emit liqWalletUpdated(newLiqWallet, liqWallet);
817         liqWallet = newLiqWallet;
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
833         require(!blocked[from], "Sniper blocked");
834 
835         if (amount == 0) {
836             super._transfer(from, to, 0);
837             return;
838         }
839 
840         if (limitsInEffect) {
841             if (
842                 from != owner() &&
843                 to != owner() &&
844                 to != address(0) &&
845                 to != address(0xdead) &&
846                 !swapping
847             ) {
848                 if (!tradingActive) {
849                     require(
850                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
851                         "Trading is not active."
852                     );
853                 }
854 
855                 if(block.number <= launchBlock + deadBlocks && from == address(uniswapV2Pair) &&  
856                 to != routerCA && to != address(this) && to != address(uniswapV2Pair)){
857                     blocked[to] = true;
858                     emit BoughtEarly(to);
859                 }
860 
861                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
862                 if (transferDelayEnabled) {
863                     if (
864                         to != owner() &&
865                         to != address(uniswapV2Router) &&
866                         to != address(uniswapV2Pair)
867                     ) {
868                         require(
869                             _holderLastTransferTimestamp[tx.origin] <
870                                 block.number,
871                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
872                         );
873                         _holderLastTransferTimestamp[tx.origin] = block.number;
874                     }
875                 }
876 
877                 //when buy
878                 if (
879                     automatedMarketMakerPairs[from] &&
880                     !_isExcludedMaxTransactionAmount[to]
881                 ) {
882                     require(
883                         amount <= maxTransactionAmount,
884                         "Buy transfer amount exceeds the maxTransactionAmount."
885                     );
886                     require(
887                         amount + balanceOf(to) <= maxWallet,
888                         "Max wallet exceeded"
889                     );
890                 }
891                 //when sell
892                 else if (
893                     automatedMarketMakerPairs[to] &&
894                     !_isExcludedMaxTransactionAmount[from]
895                 ) {
896                     require(
897                         amount <= maxTransactionAmount,
898                         "Sell transfer amount exceeds the maxTransactionAmount."
899                     );
900                 } else if (!_isExcludedMaxTransactionAmount[to]) {
901                     require(
902                         amount + balanceOf(to) <= maxWallet,
903                         "Max wallet exceeded"
904                     );
905                 }
906             }
907         }
908 
909         uint256 contractTokenBalance = balanceOf(address(this));
910 
911         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
912 
913         if (
914             canSwap &&
915             swapEnabled &&
916             !swapping &&
917             !automatedMarketMakerPairs[from] &&
918             !_isExcludedFromFees[from] &&
919             !_isExcludedFromFees[to]
920         ) {
921             swapping = true;
922 
923             swapBack();
924 
925             swapping = false;
926         }
927 
928         bool takeFee = !swapping;
929 
930         // if any account belongs to _isExcludedFromFee account then remove the fee
931         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
932             takeFee = false;
933         }
934 
935         uint256 fees = 0;
936         // only take fees on buys/sells, do not take on wallet transfers
937         if (takeFee) {
938             // on sell
939             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
940                 fees = amount.mul(sellTotalFees).div(100);
941                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
942                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
943                 tokensForMktg += (fees * sellMktgFee) / sellTotalFees;
944                 tokensForOperations += (fees * sellOperationsFee) / sellTotalFees;
945             }
946             // on buy
947             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
948                 fees = amount.mul(buyTotalFees).div(100);
949                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
950                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
951                 tokensForMktg += (fees * buyMktgFee) / buyTotalFees;
952                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
953             }
954 
955             if (fees > 0) {
956                 super._transfer(from, address(this), fees);
957             }
958 
959             amount -= fees;
960         }
961 
962         super._transfer(from, to, amount);
963     }
964 
965     function swapTokensForEth(uint256 tokenAmount) public {
966         // generate the uniswap pair path of token -> weth
967         address[] memory path = new address[](2);
968         path[0] = address(this);
969         path[1] = uniswapV2Router.WETH();
970 
971         _approve(address(this), address(uniswapV2Router), tokenAmount);
972 
973         // make the swap
974         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
975             tokenAmount,
976             0, // accept any amount of ETH
977             path,
978             address(this),
979             block.timestamp
980         );
981     }
982 
983     function multiBlock(address[] calldata blockees, bool shouldBlock) external onlyOwner {
984         for(uint256 i = 0;i<blockees.length;i++){
985             address blockee = blockees[i];
986             if(blockee != address(this) && 
987                blockee != routerCA && 
988                blockee != address(uniswapV2Pair))
989                 blocked[blockee] = shouldBlock;
990         }
991     }
992 
993     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
994         // approve token transfer to cover all possible scenarios
995         _approve(address(this), address(uniswapV2Router), tokenAmount);
996 
997         // add the liquidity
998         uniswapV2Router.addLiquidityETH{value: ethAmount}(
999             address(this),
1000             tokenAmount,
1001             0, // slippage is unavoidable
1002             0, // slippage is unavoidable
1003             liqWallet,
1004             block.timestamp
1005         );
1006     }
1007 
1008     function swapBack() private {
1009         uint256 contractBalance = balanceOf(address(this));
1010         uint256 totalTokensToSwap = tokensForLiquidity +
1011             tokensForMktg +
1012             tokensForDev +
1013             tokensForOperations;
1014         bool success;
1015 
1016         if (contractBalance == 0 || totalTokensToSwap == 0) {
1017             return;
1018         }
1019 
1020         if (contractBalance > swapTokensAtAmount * 20) {
1021             contractBalance = swapTokensAtAmount * 20;
1022         }
1023 
1024         // Halve the amount of liquidity tokens
1025         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1026         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1027 
1028         uint256 initialETHBalance = address(this).balance;
1029 
1030         swapTokensForEth(amountToSwapForETH);
1031 
1032         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1033 
1034         uint256 ethForMktg = ethBalance.mul(tokensForMktg).div(totalTokensToSwap);
1035         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1036         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap);
1037 
1038         uint256 ethForLiquidity = ethBalance - ethForMktg - ethForDev - ethForOperations;
1039 
1040         tokensForLiquidity = 0;
1041         tokensForMktg = 0;
1042         tokensForDev = 0;
1043         tokensForOperations = 0;
1044 
1045         (success, ) = address(devWallet).call{value: ethForDev}("");
1046 
1047         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1048             addLiquidity(liquidityTokens, ethForLiquidity);
1049             emit SwapAndLiquify(
1050                 amountToSwapForETH,
1051                 ethForLiquidity,
1052                 tokensForLiquidity
1053             );
1054         }
1055         (success, ) = address(operationsWallet).call{value: ethForOperations}("");
1056         (success, ) = address(mktgWallet).call{value: address(this).balance}("");
1057     }
1058 }