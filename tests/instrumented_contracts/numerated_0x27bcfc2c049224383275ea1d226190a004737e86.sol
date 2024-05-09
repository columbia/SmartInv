1 /*
2 
3 
4 Telegram: https://t.me/Text2VidAI
5 Website:  https://Text2VidAI.com
6 Twitter: https://twitter.com/Text2Vid
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
540 contract Text2VidAI is ERC20, Ownable {
541     using SafeMath for uint256;
542 
543     IUniswapV2Router02 public immutable uniswapV2Router;
544     address public immutable uniswapV2Pair;
545     address public constant deadAddress = address(0xdead);
546     address public router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
547 
548     bool private swapping;
549 
550     address public marketingWallet;
551     address public developmentWallet;
552     address public liquidityWallet;
553     address public operationsWallet;
554 
555     uint256 public maxTransaction;
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
567     mapping(address => bool) public blocked;
568 
569     uint256 public buyTotalFees;
570     uint256 public buyMarketingFee;
571     uint256 public buyLiquidityFee;
572     uint256 public buyDevelopmentFee;
573     uint256 public buyOperationsFee;
574 
575     uint256 public sellTotalFees;
576     uint256 public sellMarketingFee;
577     uint256 public sellLiquidityFee;
578     uint256 public sellDevelopmentFee;
579     uint256 public sellOperationsFee;
580 
581     uint256 public tokensForMarketing;
582     uint256 public tokensForLiquidity;
583     uint256 public tokensForDevelopment;
584     uint256 public tokensForOperations;
585 
586     mapping(address => bool) private _isExcludedFromFees;
587     mapping(address => bool) public _isExcludedmaxTransaction;
588 
589     mapping(address => bool) public automatedMarketMakerPairs;
590 
591     event UpdateUniswapV2Router(
592         address indexed newAddress,
593         address indexed oldAddress
594     );
595 
596     event ExcludeFromFees(address indexed account, bool isExcluded);
597 
598     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
599 
600     event marketingWalletUpdated(
601         address indexed newWallet,
602         address indexed oldWallet
603     );
604 
605     event developmentWalletUpdated(
606         address indexed newWallet,
607         address indexed oldWallet
608     );
609 
610     event liquidityWalletUpdated(
611         address indexed newWallet,
612         address indexed oldWallet
613     );
614 
615     event operationsWalletUpdated(
616         address indexed newWallet,
617         address indexed oldWallet
618     );
619 
620     event SwapAndLiquify(
621         uint256 tokensSwapped,
622         uint256 ethReceived,
623         uint256 tokensIntoLiquidity
624     );
625 
626     constructor() ERC20("Text2VidAI", "T2V") {
627         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router); 
628 
629         excludeFromMaxTransaction(address(_uniswapV2Router), true);
630         uniswapV2Router = _uniswapV2Router;
631 
632         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
633         excludeFromMaxTransaction(address(uniswapV2Pair), true);
634         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
635 
636         // launch buy fees
637         uint256 _buyMarketingFee = 10;
638         uint256 _buyLiquidityFee = 0;
639         uint256 _buyDevelopmentFee = 10;
640         uint256 _buyOperationsFee = 10;
641         
642         // launch sell fees
643         uint256 _sellMarketingFee = 10;
644         uint256 _sellLiquidityFee = 0;
645         uint256 _sellDevelopmentFee = 10;
646         uint256 _sellOperationsFee = 10;
647 
648         uint256 totalSupply = 100_000_000 * 1e18;
649 
650         maxTransaction = 3_000_000 * 1e18; // 2% max transaction at launch
651         maxWallet = 3_000_000 * 1e18; // 2% max wallet at launch
652         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
653 
654         buyMarketingFee = _buyMarketingFee;
655         buyLiquidityFee = _buyLiquidityFee;
656         buyDevelopmentFee = _buyDevelopmentFee;
657         buyOperationsFee = _buyOperationsFee;
658         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee + buyOperationsFee;
659 
660         sellMarketingFee = _sellMarketingFee;
661         sellLiquidityFee = _sellLiquidityFee;
662         sellDevelopmentFee = _sellDevelopmentFee;
663         sellOperationsFee = _sellOperationsFee;
664         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee + sellOperationsFee;
665 
666         marketingWallet = address(0x25AC9222289C5d58428Bf235010692b80E3DF30B); 
667         developmentWallet = address(0xC9438A7603A89cCF80e9e5Fb564383e6a89F333d); 
668         liquidityWallet = address(0x229759B0702D6eC64cCBcd2fEf05B4F8b157481e); 
669         operationsWallet = address(0x229759B0702D6eC64cCBcd2fEf05B4F8b157481e);
670 
671         // exclude from paying fees or having max transaction amount
672         excludeFromFees(owner(), true);
673         excludeFromFees(address(this), true);
674         excludeFromFees(address(0xdead), true);
675 
676         excludeFromMaxTransaction(owner(), true);
677         excludeFromMaxTransaction(address(this), true);
678         excludeFromMaxTransaction(address(0xdead), true);
679 
680         _mint(msg.sender, totalSupply);
681     }
682 
683     receive() external payable {}
684 
685     function enableTrading() external onlyOwner {
686         require(!tradingActive, "Token launched");
687         tradingActive = true;
688         launchBlock = block.number;
689         swapEnabled = true;
690     }
691 
692     // remove limits after token is stable
693     function removeLimits() external onlyOwner returns (bool) {
694         limitsInEffect = false;
695         return true;
696     }
697 
698     // disable Transfer delay - cannot be reenabled
699     function disableTransferDelay() external onlyOwner returns (bool) {
700         transferDelayEnabled = false;
701         return true;
702     }
703 
704     // change the minimum amount of tokens to sell from fees
705     function updateSwapTokensAtAmount(uint256 newAmount)
706         external
707         onlyOwner
708         returns (bool)
709     {
710         require(
711             newAmount >= (totalSupply() * 1) / 100000,
712             "Swap amount cannot be lower than 0.001% total supply."
713         );
714         require(
715             newAmount <= (totalSupply() * 5) / 1000,
716             "Swap amount cannot be higher than 0.5% total supply."
717         );
718         swapTokensAtAmount = newAmount;
719         return true;
720     }
721 
722     function updateMaxTransaction(uint256 newNum) external onlyOwner {
723         require(
724             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
725             "Cannot set maxTransaction lower than 0.1%"
726         );
727         maxTransaction = newNum * (10**18);
728     }
729 
730     function updateMaxWallet(uint256 newNum) external onlyOwner {
731         require(
732             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
733             "Cannot set maxWallet lower than 0.5%"
734         );
735         maxWallet = newNum * (10**18);
736     }
737 
738     function excludeFromMaxTransaction(address updAds, bool isEx)
739         public
740         onlyOwner
741     {
742         _isExcludedmaxTransaction[updAds] = isEx;
743     }
744 
745     // only use to disable contract sales if absolutely necessary (emergency use only)
746     function updateSwapEnabled(bool enabled) external onlyOwner {
747         swapEnabled = enabled;
748     }
749 
750     function updateBuyFees(
751         uint256 _marketingFee,
752         uint256 _liquidityFee,
753         uint256 _developmentFee,
754         uint256 _operationsFee
755     ) external onlyOwner {
756         buyMarketingFee = _marketingFee;
757         buyLiquidityFee = _liquidityFee;
758         buyDevelopmentFee = _developmentFee;
759         buyOperationsFee = _operationsFee;
760         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee + buyOperationsFee;
761         require(buyTotalFees <= 50);
762     }
763 
764     function updateSellFees(
765         uint256 _marketingFee,
766         uint256 _liquidityFee,
767         uint256 _developmentFee,
768         uint256 _operationsFee
769     ) external onlyOwner {
770         sellMarketingFee = _marketingFee;
771         sellLiquidityFee = _liquidityFee;
772         sellDevelopmentFee = _developmentFee;
773         sellOperationsFee = _operationsFee;
774         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee + sellOperationsFee;
775         require(sellTotalFees <= 50); 
776     }
777 
778     function excludeFromFees(address account, bool excluded) public onlyOwner {
779         _isExcludedFromFees[account] = excluded;
780         emit ExcludeFromFees(account, excluded);
781     }
782 
783     function setAutomatedMarketMakerPair(address pair, bool value)
784         public
785         onlyOwner
786     {
787         require(
788             pair != uniswapV2Pair,
789             "The pair cannot be removed from automatedMarketMakerPairs"
790         );
791 
792         _setAutomatedMarketMakerPair(pair, value);
793     }
794 
795     function _setAutomatedMarketMakerPair(address pair, bool value) private {
796         automatedMarketMakerPairs[pair] = value;
797 
798         emit SetAutomatedMarketMakerPair(pair, value);
799     }
800 
801     function updatemarketingWallet(address newmarketingWallet) external onlyOwner {
802         emit marketingWalletUpdated(newmarketingWallet, marketingWallet);
803         marketingWallet = newmarketingWallet;
804     }
805 
806     function updatedevelopmentWallet(address newWallet) external onlyOwner {
807         emit developmentWalletUpdated(newWallet, developmentWallet);
808         developmentWallet = newWallet;
809     }
810 
811     function updateoperationsWallet(address newWallet) external onlyOwner{
812         emit operationsWalletUpdated(newWallet, operationsWallet);
813         operationsWallet = newWallet;
814     }
815 
816     function updateliquidityWallet(address newliquidityWallet) external onlyOwner {
817         emit liquidityWalletUpdated(newliquidityWallet, liquidityWallet);
818         liquidityWallet = newliquidityWallet;
819     }
820 
821     function isExcludedFromFees(address account) public view returns (bool) {
822         return _isExcludedFromFees[account];
823     }
824 
825     function _transfer(
826         address from,
827         address to,
828         uint256 amount
829     ) internal override {
830         require(from != address(0), "ERC20: transfer from the zero address");
831         require(to != address(0), "ERC20: transfer to the zero address");
832         require(!blocked[from], "Sniper");
833 
834         if (amount == 0) {
835             super._transfer(from, to, 0);
836             return;
837         }
838 
839         if (limitsInEffect) {
840             if (
841                 from != owner() &&
842                 to != owner() &&
843                 to != address(0) &&
844                 to != address(0xdead) &&
845                 !swapping
846             ) {
847                 if (!tradingActive) {
848                     require(
849                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
850                         "Trading is not active."
851                     );
852                 }
853 
854                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
855                 if (transferDelayEnabled) {
856                     if (
857                         to != owner() &&
858                         to != address(uniswapV2Router) &&
859                         to != address(uniswapV2Pair)
860                     ) {
861                         require(
862                             _holderLastTransferTimestamp[tx.origin] <
863                                 block.number,
864                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
865                         );
866                         _holderLastTransferTimestamp[tx.origin] = block.number;
867                     }
868                 }
869 
870                 //when buy
871                 if (
872                     automatedMarketMakerPairs[from] &&
873                     !_isExcludedmaxTransaction[to]
874                 ) {
875                     require(
876                         amount <= maxTransaction,
877                         "Buy transfer amount exceeds the maxTransaction."
878                     );
879                     require(
880                         amount + balanceOf(to) <= maxWallet,
881                         "Max wallet exceeded"
882                     );
883                 }
884                 //when sell
885                 else if (
886                     automatedMarketMakerPairs[to] &&
887                     !_isExcludedmaxTransaction[from]
888                 ) {
889                     require(
890                         amount <= maxTransaction,
891                         "Sell transfer amount exceeds the maxTransaction."
892                     );
893                 } else if (!_isExcludedmaxTransaction[to]) {
894                     require(
895                         amount + balanceOf(to) <= maxWallet,
896                         "Max wallet exceeded"
897                     );
898                 }
899             }
900         }
901 
902         uint256 contractTokenBalance = balanceOf(address(this));
903 
904         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
905 
906         if (
907             canSwap &&
908             swapEnabled &&
909             !swapping &&
910             !automatedMarketMakerPairs[from] &&
911             !_isExcludedFromFees[from] &&
912             !_isExcludedFromFees[to]
913         ) {
914             swapping = true;
915 
916             swapBack();
917 
918             swapping = false;
919         }
920 
921         bool takeFee = !swapping;
922 
923         // if any account belongs to _isExcludedFromFee account then remove the fee
924         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
925             takeFee = false;
926         }
927 
928         uint256 fees = 0;
929         // only take fees on buys/sells, do not take on wallet transfers
930         if (takeFee) {
931             // on sell
932             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
933                 fees = amount.mul(sellTotalFees).div(100);
934                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
935                 tokensForDevelopment += (fees * sellDevelopmentFee) / sellTotalFees;
936                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
937                 tokensForOperations += (fees * sellOperationsFee) / sellTotalFees;
938             }
939             // on buy
940             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
941                 fees = amount.mul(buyTotalFees).div(100);
942                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
943                 tokensForDevelopment += (fees * buyDevelopmentFee) / buyTotalFees;
944                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
945                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
946             }
947 
948             if (fees > 0) {
949                 super._transfer(from, address(this), fees);
950             }
951 
952             amount -= fees;
953         }
954 
955         super._transfer(from, to, amount);
956     }
957 
958     function blacklistSnipers(address[] calldata blockees, bool shouldBlock) external onlyOwner {
959         for(uint256 i = 0;i<blockees.length;i++){
960             address blockee = blockees[i];
961             if(blockee != address(this) && 
962                blockee != router && 
963                blockee != address(uniswapV2Pair))
964                 blocked[blockee] = shouldBlock;
965         }
966     }
967 
968     function swapTokensForEth(uint256 tokenAmount) private {
969         // generate the uniswap pair path of token -> weth
970         address[] memory path = new address[](2);
971         path[0] = address(this);
972         path[1] = uniswapV2Router.WETH();
973 
974         _approve(address(this), address(uniswapV2Router), tokenAmount);
975 
976         // make the swap
977         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
978             tokenAmount,
979             0, // accept any amount of ETH
980             path,
981             address(this),
982             block.timestamp
983         );
984     }
985 
986     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
987         // approve token transfer to cover all possible scenarios
988         _approve(address(this), address(uniswapV2Router), tokenAmount);
989 
990         // add the liquidity
991         uniswapV2Router.addLiquidityETH{value: ethAmount}(
992             address(this),
993             tokenAmount,
994             0, // slippage is unavoidable
995             0, // slippage is unavoidable
996             liquidityWallet,
997             block.timestamp
998         );
999     }
1000 
1001     function swapBack() private {
1002         uint256 contractBalance = balanceOf(address(this));
1003         uint256 totalTokensToSwap = tokensForLiquidity +
1004             tokensForMarketing +
1005             tokensForDevelopment +
1006             tokensForOperations;
1007         bool success;
1008 
1009         if (contractBalance == 0 || totalTokensToSwap == 0) {
1010             return;
1011         }
1012 
1013         if (contractBalance > swapTokensAtAmount * 20) {
1014             contractBalance = swapTokensAtAmount * 20;
1015         }
1016 
1017         // Halve the amount of liquidity tokens
1018         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1019         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1020 
1021         uint256 initialETHBalance = address(this).balance;
1022 
1023         swapTokensForEth(amountToSwapForETH);
1024 
1025         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1026 
1027         uint256 ethForMark = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1028         uint256 ethForDevelopment = ethBalance.mul(tokensForDevelopment).div(totalTokensToSwap);
1029         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap);
1030 
1031         uint256 ethForLiquidity = ethBalance - ethForMark - ethForDevelopment - ethForOperations;
1032 
1033         tokensForLiquidity = 0;
1034         tokensForMarketing = 0;
1035         tokensForDevelopment = 0;
1036         tokensForOperations = 0;
1037 
1038         (success, ) = address(developmentWallet).call{value: ethForDevelopment}("");
1039 
1040         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1041             addLiquidity(liquidityTokens, ethForLiquidity);
1042             emit SwapAndLiquify(
1043                 amountToSwapForETH,
1044                 ethForLiquidity,
1045                 tokensForLiquidity
1046             );
1047         }
1048         (success, ) = address(operationsWallet).call{value: ethForOperations}("");
1049         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
1050     }
1051 }