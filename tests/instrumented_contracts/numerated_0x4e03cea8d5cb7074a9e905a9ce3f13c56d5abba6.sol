1 /**
2 Twitter:  http://twitter.com/mustarderc20
3 Website:  https://mustard.cool
4 Telegram: http://t.me/mustardportal
5 **/
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
9 pragma experimental ABIEncoderV2;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         return msg.data;
18     }
19 }
20 
21 abstract contract Ownable is Context {
22     address private _owner;
23 
24     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26     constructor() {
27         _transferOwnership(_msgSender());
28     }
29 
30     function owner() public view virtual returns (address) {
31         return _owner;
32     }
33 
34     modifier onlyOwner() {
35         require(owner() == _msgSender(), "Ownable: caller is not the owner");
36         _;
37     }
38 
39     function renounceOwnership() public virtual onlyOwner {
40         _transferOwnership(address(0));
41     }
42 
43     function transferOwnership(address newOwner) public virtual onlyOwner {
44         require(newOwner != address(0), "Ownable: new owner is the zero address");
45         _transferOwnership(newOwner);
46     }
47 
48     function _transferOwnership(address newOwner) internal virtual {
49         address oldOwner = _owner;
50         _owner = newOwner;
51         emit OwnershipTransferred(oldOwner, newOwner);
52     }
53 }
54 
55 interface IERC20 {
56 
57     function totalSupply() external view returns (uint256);
58 
59     function balanceOf(address account) external view returns (uint256);
60 
61     function transfer(address recipient, uint256 amount) external returns (bool);
62 
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72 
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 interface IERC20Metadata is IERC20 {
79 
80     function name() external view returns (string memory);
81 
82     function symbol() external view returns (string memory);
83 
84     function decimals() external view returns (uint8);
85 }
86 
87 contract ERC20 is Context, IERC20, IERC20Metadata {
88     mapping(address => uint256) private _balances;
89 
90     mapping(address => mapping(address => uint256)) private _allowances;
91 
92     uint256 private _totalSupply;
93 
94     string private _name;
95     string private _symbol;
96 
97     constructor(string memory name_, string memory symbol_) {
98         _name = name_;
99         _symbol = symbol_;
100     }
101 
102     function name() public view virtual override returns (string memory) {
103         return _name;
104     }
105 
106     function symbol() public view virtual override returns (string memory) {
107         return _symbol;
108     }
109 
110     function decimals() public view virtual override returns (uint8) {
111         return 18;
112     }
113 
114     function totalSupply() public view virtual override returns (uint256) {
115         return _totalSupply;
116     }
117 
118     function balanceOf(address account) public view virtual override returns (uint256) {
119         return _balances[account];
120     }
121 
122     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
123         _transfer(_msgSender(), recipient, amount);
124         return true;
125     }
126 
127     function allowance(address owner, address spender) public view virtual override returns (uint256) {
128         return _allowances[owner][spender];
129     }
130 
131     function approve(address spender, uint256 amount) public virtual override returns (bool) {
132         _approve(_msgSender(), spender, amount);
133         return true;
134     }
135 
136     function transferFrom(
137         address sender,
138         address recipient,
139         uint256 amount
140     ) public virtual override returns (bool) {
141         _transfer(sender, recipient, amount);
142 
143         uint256 currentAllowance = _allowances[sender][_msgSender()];
144         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
145         unchecked {
146             _approve(sender, _msgSender(), currentAllowance - amount);
147         }
148 
149         return true;
150     }
151 
152     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
153         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
154         return true;
155     }
156 
157     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
158         uint256 currentAllowance = _allowances[_msgSender()][spender];
159         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
160         unchecked {
161             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
162         }
163 
164         return true;
165     }
166 
167     function _transfer(
168         address sender,
169         address recipient,
170         uint256 amount
171     ) internal virtual {
172         require(sender != address(0), "ERC20: transfer from the zero address");
173         require(recipient != address(0), "ERC20: transfer to the zero address");
174 
175         _beforeTokenTransfer(sender, recipient, amount);
176 
177         uint256 senderBalance = _balances[sender];
178         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
179         unchecked {
180             _balances[sender] = senderBalance - amount;
181         }
182         _balances[recipient] += amount;
183 
184         emit Transfer(sender, recipient, amount);
185 
186         _afterTokenTransfer(sender, recipient, amount);
187     }
188 
189     function _mint(address account, uint256 amount) internal virtual {
190         require(account != address(0), "ERC20: mint to the zero address");
191 
192         _beforeTokenTransfer(address(0), account, amount);
193 
194         _totalSupply += amount;
195         _balances[account] += amount;
196         emit Transfer(address(0), account, amount);
197 
198         _afterTokenTransfer(address(0), account, amount);
199     }
200 
201     function _burn(address account, uint256 amount) internal virtual {
202         require(account != address(0), "ERC20: burn from the zero address");
203 
204         _beforeTokenTransfer(account, address(0), amount);
205 
206         uint256 accountBalance = _balances[account];
207         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
208         unchecked {
209             _balances[account] = accountBalance - amount;
210         }
211         _totalSupply -= amount;
212 
213         emit Transfer(account, address(0), amount);
214 
215         _afterTokenTransfer(account, address(0), amount);
216     }
217 
218     function _approve(
219         address owner,
220         address spender,
221         uint256 amount
222     ) internal virtual {
223         require(owner != address(0), "ERC20: approve from the zero address");
224         require(spender != address(0), "ERC20: approve to the zero address");
225 
226         _allowances[owner][spender] = amount;
227         emit Approval(owner, spender, amount);
228     }
229 
230     function _beforeTokenTransfer(
231         address from,
232         address to,
233         uint256 amount
234     ) internal virtual {}
235 
236     function _afterTokenTransfer(
237         address from,
238         address to,
239         uint256 amount
240     ) internal virtual {}
241 }
242 
243 library SafeMath {
244 
245     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
246         unchecked {
247             uint256 c = a + b;
248             if (c < a) return (false, 0);
249             return (true, c);
250         }
251     }
252 
253     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
254         unchecked {
255             if (b > a) return (false, 0);
256             return (true, a - b);
257         }
258     }
259 
260     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
261         unchecked {
262             if (a == 0) return (true, 0);
263             uint256 c = a * b;
264             if (c / a != b) return (false, 0);
265             return (true, c);
266         }
267     }
268 
269     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
270         unchecked {
271             if (b == 0) return (false, 0);
272             return (true, a / b);
273         }
274     }
275 
276     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
277         unchecked {
278             if (b == 0) return (false, 0);
279             return (true, a % b);
280         }
281     }
282 
283     function add(uint256 a, uint256 b) internal pure returns (uint256) {
284         return a + b;
285     }
286 
287     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
288         return a - b;
289     }
290 
291     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
292         return a * b;
293     }
294 
295     function div(uint256 a, uint256 b) internal pure returns (uint256) {
296         return a / b;
297     }
298 
299     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
300         return a % b;
301     }
302 
303     function sub(
304         uint256 a,
305         uint256 b,
306         string memory errorMessage
307     ) internal pure returns (uint256) {
308         unchecked {
309             require(b <= a, errorMessage);
310             return a - b;
311         }
312     }
313 
314     function div(
315         uint256 a,
316         uint256 b,
317         string memory errorMessage
318     ) internal pure returns (uint256) {
319         unchecked {
320             require(b > 0, errorMessage);
321             return a / b;
322         }
323     }
324 
325     function mod(
326         uint256 a,
327         uint256 b,
328         string memory errorMessage
329     ) internal pure returns (uint256) {
330         unchecked {
331             require(b > 0, errorMessage);
332             return a % b;
333         }
334     }
335 }
336 
337 interface IUniswapV2Factory {
338     event PairCreated(
339         address indexed token0,
340         address indexed token1,
341         address pair,
342         uint256
343     );
344 
345     function feeTo() external view returns (address);
346 
347     function feeToSetter() external view returns (address);
348 
349     function getPair(address tokenA, address tokenB)
350         external
351         view
352         returns (address pair);
353 
354     function allPairs(uint256) external view returns (address pair);
355 
356     function allPairsLength() external view returns (uint256);
357 
358     function createPair(address tokenA, address tokenB)
359         external
360         returns (address pair);
361 
362     function setFeeTo(address) external;
363 
364     function setFeeToSetter(address) external;
365 }
366 
367 interface IUniswapV2Pair {
368     event Approval(
369         address indexed owner,
370         address indexed spender,
371         uint256 value
372     );
373     event Transfer(address indexed from, address indexed to, uint256 value);
374 
375     function name() external pure returns (string memory);
376 
377     function symbol() external pure returns (string memory);
378 
379     function decimals() external pure returns (uint8);
380 
381     function totalSupply() external view returns (uint256);
382 
383     function balanceOf(address owner) external view returns (uint256);
384 
385     function allowance(address owner, address spender)
386         external
387         view
388         returns (uint256);
389 
390     function approve(address spender, uint256 value) external returns (bool);
391 
392     function transfer(address to, uint256 value) external returns (bool);
393 
394     function transferFrom(
395         address from,
396         address to,
397         uint256 value
398     ) external returns (bool);
399 
400     function DOMAIN_SEPARATOR() external view returns (bytes32);
401 
402     function PERMIT_TYPEHASH() external pure returns (bytes32);
403 
404     function nonces(address owner) external view returns (uint256);
405 
406     function permit(
407         address owner,
408         address spender,
409         uint256 value,
410         uint256 deadline,
411         uint8 v,
412         bytes32 r,
413         bytes32 s
414     ) external;
415 
416     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
417     event Burn(
418         address indexed sender,
419         uint256 amount0,
420         uint256 amount1,
421         address indexed to
422     );
423     event Swap(
424         address indexed sender,
425         uint256 amount0In,
426         uint256 amount1In,
427         uint256 amount0Out,
428         uint256 amount1Out,
429         address indexed to
430     );
431     event Sync(uint112 reserve0, uint112 reserve1);
432 
433     function MINIMUM_LIQUIDITY() external pure returns (uint256);
434 
435     function factory() external view returns (address);
436 
437     function token0() external view returns (address);
438 
439     function token1() external view returns (address);
440 
441     function getReserves()
442         external
443         view
444         returns (
445             uint112 reserve0,
446             uint112 reserve1,
447             uint32 blockTimestampLast
448         );
449 
450     function price0CumulativeLast() external view returns (uint256);
451 
452     function price1CumulativeLast() external view returns (uint256);
453 
454     function kLast() external view returns (uint256);
455 
456     function mint(address to) external returns (uint256 liquidity);
457 
458     function burn(address to)
459         external
460         returns (uint256 amount0, uint256 amount1);
461 
462     function swap(
463         uint256 amount0Out,
464         uint256 amount1Out,
465         address to,
466         bytes calldata data
467     ) external;
468 
469     function skim(address to) external;
470 
471     function sync() external;
472 
473     function initialize(address, address) external;
474 }
475 
476 interface IUniswapV2Router02 {
477     function factory() external pure returns (address);
478 
479     function WETH() external pure returns (address);
480 
481     function addLiquidity(
482         address tokenA,
483         address tokenB,
484         uint256 amountADesired,
485         uint256 amountBDesired,
486         uint256 amountAMin,
487         uint256 amountBMin,
488         address to,
489         uint256 deadline
490     )
491         external
492         returns (
493             uint256 amountA,
494             uint256 amountB,
495             uint256 liquidity
496         );
497 
498     function addLiquidityETH(
499         address token,
500         uint256 amountTokenDesired,
501         uint256 amountTokenMin,
502         uint256 amountETHMin,
503         address to,
504         uint256 deadline
505     )
506         external
507         payable
508         returns (
509             uint256 amountToken,
510             uint256 amountETH,
511             uint256 liquidity
512         );
513 
514     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
515         uint256 amountIn,
516         uint256 amountOutMin,
517         address[] calldata path,
518         address to,
519         uint256 deadline
520     ) external;
521 
522     function swapExactETHForTokensSupportingFeeOnTransferTokens(
523         uint256 amountOutMin,
524         address[] calldata path,
525         address to,
526         uint256 deadline
527     ) external payable;
528 
529     function swapExactTokensForETHSupportingFeeOnTransferTokens(
530         uint256 amountIn,
531         uint256 amountOutMin,
532         address[] calldata path,
533         address to,
534         uint256 deadline
535     ) external;
536 }
537 
538 contract Mustard is ERC20, Ownable {
539     using SafeMath for uint256;
540 
541     IUniswapV2Router02 public immutable uniswapV2Router;
542     address public immutable uniswapV2Pair;
543     address public constant deadAddress = address(0xdead);
544     address public uniswapRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
545 
546     bool private swapping;
547 
548     address public cexWallet;
549     address public devWallet;
550     address public liqWallet;
551     address public opsWallet;
552 
553     uint256 public maxTxn;
554     uint256 public swapTokensAtAmount;
555     uint256 public maxWallet;
556 
557     bool public limitsInEffect = true;
558     bool public tradingActive = false;
559     bool public swapEnabled = false;
560 
561     // Anti-bot and anti-whale mappings and variables
562     mapping(address => uint256) private _holderLastTransferTimestamp;
563     bool public transferDelayEnabled = true;
564     uint256 private launchBlock;
565     mapping(address => bool) public blocked;
566 
567     uint256 public buyTotalFees;
568     uint256 public buyCexFee;
569     uint256 public buyLiqFee;
570     uint256 public buyDevFee;
571     uint256 public buyOpsFee;
572 
573     uint256 public sellTotalFees;
574     uint256 public sellCexFee;
575     uint256 public sellLiqFee;
576     uint256 public sellDevFee;
577     uint256 public sellOpsFee;
578 
579     uint256 public tokensForCex;
580     uint256 public tokensForLiq;
581     uint256 public tokensForDev;
582     uint256 public tokensForOps;
583 
584     mapping(address => bool) private _isExcludedFromFees;
585     mapping(address => bool) public _isExcludedmaxTxn;
586 
587     mapping(address => bool) public automatedMarketMakerPairs;
588 
589     event UpdateUniswapV2Router(
590         address indexed newAddress,
591         address indexed oldAddress
592     );
593 
594     event ExcludeFromFees(address indexed account, bool isExcluded);
595 
596     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
597 
598     event cexWalletUpdated(
599         address indexed newWallet,
600         address indexed oldWallet
601     );
602 
603     event devWalletUpdated(
604         address indexed newWallet,
605         address indexed oldWallet
606     );
607 
608     event liqWalletUpdated(
609         address indexed newWallet,
610         address indexed oldWallet
611     );
612 
613     event opsWalletUpdated(
614         address indexed newWallet,
615         address indexed oldWallet
616     );
617 
618     event SwapAndLiquify(
619         uint256 tokensSwapped,
620         uint256 ethReceived,
621         uint256 tokensIntoLiquidity
622     );
623 
624     constructor() ERC20("Mustard", "MUSTARD") {
625         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(uniswapRouter); 
626 
627         excludeFrommaxTxn(address(_uniswapV2Router), true);
628         uniswapV2Router = _uniswapV2Router;
629 
630         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
631         excludeFrommaxTxn(address(uniswapV2Pair), true);
632         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
633 
634         // launch buy fees
635         uint256 _buyCexFee = 0;
636         uint256 _buyLiqFee = 0;
637         uint256 _buyDevFee = 15;
638         uint256 _buyOpsFee = 0;
639         
640         // launch sell fees
641         uint256 _sellCexFee = 0;
642         uint256 _sellLiqFee = 0;
643         uint256 _sellDevFee = 30;
644         uint256 _sellOpsFee = 0;
645 
646         uint256 totalSupply = 100_000_000 * 1e18;
647 
648         maxTxn = 1_500_000 * 1e18; // 1.5% max transaction at launch
649         maxWallet = 1_500_000 * 1e18; // 1.5% max wallet at launch
650         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
651 
652         buyCexFee = _buyCexFee;
653         buyLiqFee = _buyLiqFee;
654         buyDevFee = _buyDevFee;
655         buyOpsFee = _buyOpsFee;
656         buyTotalFees = buyCexFee + buyLiqFee + buyDevFee + buyOpsFee;
657 
658         sellCexFee = _sellCexFee;
659         sellLiqFee = _sellLiqFee;
660         sellDevFee = _sellDevFee;
661         sellOpsFee = _sellOpsFee;
662         sellTotalFees = sellCexFee + sellLiqFee + sellDevFee + sellOpsFee;
663 
664         cexWallet = address(0xB3F5236816d9CaCcd502FA1cE04b80F12e364A50); 
665         devWallet = address(0xd870EAFFEF98508967626889a5C4871d90d5F3aF); 
666         liqWallet = address(0xB3F5236816d9CaCcd502FA1cE04b80F12e364A50); 
667         opsWallet = address(0xB3F5236816d9CaCcd502FA1cE04b80F12e364A50);
668 
669         // exclude from paying fees or having max transaction amount
670         excludeFromFees(owner(), true);
671         excludeFromFees(address(this), true);
672         excludeFromFees(address(0xdead), true);
673 
674         excludeFrommaxTxn(owner(), true);
675         excludeFrommaxTxn(address(this), true);
676         excludeFrommaxTxn(address(0xdead), true);
677 
678         _mint(msg.sender, totalSupply);
679     }
680 
681     receive() external payable {}
682 
683     function enableTrading() external onlyOwner {
684         require(!tradingActive, "Token launched");
685         tradingActive = true;
686         launchBlock = block.number;
687         swapEnabled = true;
688     }
689 
690     // remove limits after token is stable
691     function removeLimits() external onlyOwner returns (bool) {
692         limitsInEffect = false;
693         return true;
694     }
695 
696     // disable Transfer delay - cannot be reenabled
697     function disableTransferDelay() external onlyOwner returns (bool) {
698         transferDelayEnabled = false;
699         return true;
700     }
701 
702     // change the minimum amount of tokens to sell from fees
703     function updateSwapTokensAtAmount(uint256 newAmount)
704         external
705         onlyOwner
706         returns (bool)
707     {
708         require(
709             newAmount >= (totalSupply() * 1) / 100000,
710             "Swap amount cannot be lower than 0.001% total supply."
711         );
712         require(
713             newAmount <= (totalSupply() * 5) / 1000,
714             "Swap amount cannot be higher than 0.5% total supply."
715         );
716         swapTokensAtAmount = newAmount;
717         return true;
718     }
719 
720     function updatemaxTxn(uint256 newNum) external onlyOwner {
721         require(
722             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
723             "Cannot set maxTxn lower than 0.1%"
724         );
725         maxTxn = newNum * (10**18);
726     }
727 
728     function updateMaxWallet(uint256 newNum) external onlyOwner {
729         require(
730             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
731             "Cannot set maxWallet lower than 0.5%"
732         );
733         maxWallet = newNum * (10**18);
734     }
735 
736     function excludeFrommaxTxn(address updAds, bool isEx)
737         public
738         onlyOwner
739     {
740         _isExcludedmaxTxn[updAds] = isEx;
741     }
742 
743     // only use to disable contract sales if absolutely necessary (emergency use only)
744     function updateSwapEnabled(bool enabled) external onlyOwner {
745         swapEnabled = enabled;
746     }
747 
748     function updateBuyFees(
749         uint256 _cexFee,
750         uint256 _liqFee,
751         uint256 _devFee,
752         uint256 _opsFee
753     ) external onlyOwner {
754         buyCexFee = _cexFee;
755         buyLiqFee = _liqFee;
756         buyDevFee = _devFee;
757         buyOpsFee = _opsFee;
758         buyTotalFees = buyCexFee + buyLiqFee + buyDevFee + buyOpsFee;
759         require(buyTotalFees <= 99);
760     }
761 
762     function updateSellFees(
763         uint256 _cexFee,
764         uint256 _liqFee,
765         uint256 _devFee,
766         uint256 _opsFee
767     ) external onlyOwner {
768         sellCexFee = _cexFee;
769         sellLiqFee = _liqFee;
770         sellDevFee = _devFee;
771         sellOpsFee = _opsFee;
772         sellTotalFees = sellCexFee + sellLiqFee + sellDevFee + sellOpsFee;
773         require(sellTotalFees <= 99); 
774     }
775 
776     function excludeFromFees(address account, bool excluded) public onlyOwner {
777         _isExcludedFromFees[account] = excluded;
778         emit ExcludeFromFees(account, excluded);
779     }
780 
781     function setAutomatedMarketMakerPair(address pair, bool value)
782         public
783         onlyOwner
784     {
785         require(
786             pair != uniswapV2Pair,
787             "The pair cannot be removed from automatedMarketMakerPairs"
788         );
789 
790         _setAutomatedMarketMakerPair(pair, value);
791     }
792 
793     function _setAutomatedMarketMakerPair(address pair, bool value) private {
794         automatedMarketMakerPairs[pair] = value;
795 
796         emit SetAutomatedMarketMakerPair(pair, value);
797     }
798 
799     function updatecexWallet(address newcexWallet) external onlyOwner {
800         emit cexWalletUpdated(newcexWallet, cexWallet);
801         cexWallet = newcexWallet;
802     }
803 
804     function updatedevWallet(address newWallet) external onlyOwner {
805         emit devWalletUpdated(newWallet, devWallet);
806         devWallet = newWallet;
807     }
808 
809     function updateopsWallet(address newWallet) external onlyOwner{
810         emit opsWalletUpdated(newWallet, opsWallet);
811         opsWallet = newWallet;
812     }
813 
814     function updateliqWallet(address newliqWallet) external onlyOwner {
815         emit liqWalletUpdated(newliqWallet, liqWallet);
816         liqWallet = newliqWallet;
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
830         require(!blocked[from], "Blocked");
831 
832         if (amount == 0) {
833             super._transfer(from, to, 0);
834             return;
835         }
836 
837         if (limitsInEffect) {
838             if (
839                 from != owner() &&
840                 to != owner() &&
841                 to != address(0) &&
842                 to != address(0xdead) &&
843                 !swapping
844             ) {
845                 if (!tradingActive) {
846                     require(
847                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
848                         "Trading is not active."
849                     );
850                 }
851 
852                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
853                 if (transferDelayEnabled) {
854                     if (
855                         to != owner() &&
856                         to != address(uniswapV2Router) &&
857                         to != address(uniswapV2Pair)
858                     ) {
859                         require(
860                             _holderLastTransferTimestamp[tx.origin] <
861                                 block.number,
862                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
863                         );
864                         _holderLastTransferTimestamp[tx.origin] = block.number;
865                     }
866                 }
867 
868                 //when buy
869                 if (
870                     automatedMarketMakerPairs[from] &&
871                     !_isExcludedmaxTxn[to]
872                 ) {
873                     require(
874                         amount <= maxTxn,
875                         "Buy transfer amount exceeds the maxTxn."
876                     );
877                     require(
878                         amount + balanceOf(to) <= maxWallet,
879                         "Max wallet exceeded"
880                     );
881                 }
882                 //when sell
883                 else if (
884                     automatedMarketMakerPairs[to] &&
885                     !_isExcludedmaxTxn[from]
886                 ) {
887                     require(
888                         amount <= maxTxn,
889                         "Sell transfer amount exceeds the maxTxn."
890                     );
891                 } else if (!_isExcludedmaxTxn[to]) {
892                     require(
893                         amount + balanceOf(to) <= maxWallet,
894                         "Max wallet exceeded"
895                     );
896                 }
897             }
898         }
899 
900         uint256 contractTokenBalance = balanceOf(address(this));
901 
902         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
903 
904         if (
905             canSwap &&
906             swapEnabled &&
907             !swapping &&
908             !automatedMarketMakerPairs[from] &&
909             !_isExcludedFromFees[from] &&
910             !_isExcludedFromFees[to]
911         ) {
912             swapping = true;
913 
914             swapBack();
915 
916             swapping = false;
917         }
918 
919         bool takeFee = !swapping;
920 
921         // if any account belongs to _isExcludedFromFee account then remove the fee
922         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
923             takeFee = false;
924         }
925 
926         uint256 fees = 0;
927         // only take fees on buys/sells, do not take on wallet transfers
928         if (takeFee) {
929             // on sell
930             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
931                 fees = amount.mul(sellTotalFees).div(100);
932                 tokensForLiq += (fees * sellLiqFee) / sellTotalFees;
933                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
934                 tokensForCex += (fees * sellCexFee) / sellTotalFees;
935                 tokensForOps += (fees * sellOpsFee) / sellTotalFees;
936             }
937             // on buy
938             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
939                 fees = amount.mul(buyTotalFees).div(100);
940                 tokensForLiq += (fees * buyLiqFee) / buyTotalFees;
941                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
942                 tokensForCex += (fees * buyCexFee) / buyTotalFees;
943                 tokensForOps += (fees * buyOpsFee) / buyTotalFees;
944             }
945 
946             if (fees > 0) {
947                 super._transfer(from, address(this), fees);
948             }
949 
950             amount -= fees;
951         }
952 
953         super._transfer(from, to, amount);
954     }
955 
956     function swapTokensForEth(uint256 tokenAmount) private {
957         // generate the uniswap pair path of token -> weth
958         address[] memory path = new address[](2);
959         path[0] = address(this);
960         path[1] = uniswapV2Router.WETH();
961 
962         _approve(address(this), address(uniswapV2Router), tokenAmount);
963 
964         // make the swap
965         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
966             tokenAmount,
967             0, // accept any amount of ETH
968             path,
969             address(this),
970             block.timestamp
971         );
972     }
973 
974     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
975         // approve token transfer to cover all possible scenarios
976         _approve(address(this), address(uniswapV2Router), tokenAmount);
977 
978         // add the liquidity
979         uniswapV2Router.addLiquidityETH{value: ethAmount}(
980             address(this),
981             tokenAmount,
982             0, // slippage is unavoidable
983             0, // slippage is unavoidable
984             liqWallet,
985             block.timestamp
986         );
987     }
988 
989     function toggleBlackList(address[] calldata blockees, bool shouldBlock) external onlyOwner {
990         for(uint256 i = 0;i<blockees.length;i++){
991             address blockee = blockees[i];
992             if(blockee != address(this) && 
993                blockee != uniswapRouter && 
994                blockee != address(uniswapV2Pair))
995                 blocked[blockee] = shouldBlock;
996         }
997     }
998 
999     function swapBack() private {
1000         uint256 contractBalance = balanceOf(address(this));
1001         uint256 totalTokensToSwap = tokensForLiq +
1002             tokensForCex +
1003             tokensForDev +
1004             tokensForOps;
1005         bool success;
1006 
1007         if (contractBalance == 0 || totalTokensToSwap == 0) {
1008             return;
1009         }
1010 
1011         if (contractBalance > swapTokensAtAmount * 20) {
1012             contractBalance = swapTokensAtAmount * 20;
1013         }
1014 
1015         // Halve the amount of liquidity tokens
1016         uint256 liquidityTokens = (contractBalance * tokensForLiq) / totalTokensToSwap / 2;
1017         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1018 
1019         uint256 initialETHBalance = address(this).balance;
1020 
1021         swapTokensForEth(amountToSwapForETH);
1022 
1023         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1024 
1025         uint256 ethForCex = ethBalance.mul(tokensForCex).div(totalTokensToSwap);
1026         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1027         uint256 ethForOps = ethBalance.mul(tokensForOps).div(totalTokensToSwap);
1028 
1029         uint256 ethForLiquidity = ethBalance - ethForCex - ethForDev - ethForOps;
1030 
1031         tokensForLiq = 0;
1032         tokensForCex = 0;
1033         tokensForDev = 0;
1034         tokensForOps = 0;
1035 
1036         (success, ) = address(devWallet).call{value: ethForDev}("");
1037 
1038         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1039             addLiquidity(liquidityTokens, ethForLiquidity);
1040             emit SwapAndLiquify(
1041                 amountToSwapForETH,
1042                 ethForLiquidity,
1043                 tokensForLiq
1044             );
1045         }
1046         (success, ) = address(opsWallet).call{value: ethForOps}("");
1047         (success, ) = address(cexWallet).call{value: address(this).balance}("");
1048     }
1049 }