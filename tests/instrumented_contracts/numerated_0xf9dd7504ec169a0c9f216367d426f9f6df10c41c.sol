1 /*
2 
3 MusicAI is the first Text To Music AI project!
4 
5 Telegram: https://t.me/MusicAIeth
6 Website:  https://MusicAIeth.com
7 Twitter: https://twitter.com/MusicAIeth
8 */
9 
10 // SPDX-License-Identifier: MIT
11 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
12 pragma experimental ABIEncoderV2;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 abstract contract Ownable is Context {
25     address private _owner;
26 
27     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29     constructor() {
30         _transferOwnership(_msgSender());
31     }
32 
33     function owner() public view virtual returns (address) {
34         return _owner;
35     }
36 
37     modifier onlyOwner() {
38         require(owner() == _msgSender(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     function renounceOwnership() public virtual onlyOwner {
43         _transferOwnership(address(0));
44     }
45 
46     function transferOwnership(address newOwner) public virtual onlyOwner {
47         require(newOwner != address(0), "Ownable: new owner is the zero address");
48         _transferOwnership(newOwner);
49     }
50 
51     function _transferOwnership(address newOwner) internal virtual {
52         address oldOwner = _owner;
53         _owner = newOwner;
54         emit OwnershipTransferred(oldOwner, newOwner);
55     }
56 }
57 
58 interface IERC20 {
59 
60     function totalSupply() external view returns (uint256);
61 
62     function balanceOf(address account) external view returns (uint256);
63 
64     function transfer(address recipient, uint256 amount) external returns (bool);
65 
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75 
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 interface IERC20Metadata is IERC20 {
82 
83     function name() external view returns (string memory);
84 
85     function symbol() external view returns (string memory);
86 
87     function decimals() external view returns (uint8);
88 }
89 
90 contract ERC20 is Context, IERC20, IERC20Metadata {
91     mapping(address => uint256) private _balances;
92 
93     mapping(address => mapping(address => uint256)) private _allowances;
94 
95     uint256 private _totalSupply;
96 
97     string private _name;
98     string private _symbol;
99 
100     constructor(string memory name_, string memory symbol_) {
101         _name = name_;
102         _symbol = symbol_;
103     }
104 
105     function name() public view virtual override returns (string memory) {
106         return _name;
107     }
108 
109     function symbol() public view virtual override returns (string memory) {
110         return _symbol;
111     }
112 
113     function decimals() public view virtual override returns (uint8) {
114         return 18;
115     }
116 
117     function totalSupply() public view virtual override returns (uint256) {
118         return _totalSupply;
119     }
120 
121     function balanceOf(address account) public view virtual override returns (uint256) {
122         return _balances[account];
123     }
124 
125     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
126         _transfer(_msgSender(), recipient, amount);
127         return true;
128     }
129 
130     function allowance(address owner, address spender) public view virtual override returns (uint256) {
131         return _allowances[owner][spender];
132     }
133 
134     function approve(address spender, uint256 amount) public virtual override returns (bool) {
135         _approve(_msgSender(), spender, amount);
136         return true;
137     }
138 
139     function transferFrom(
140         address sender,
141         address recipient,
142         uint256 amount
143     ) public virtual override returns (bool) {
144         _transfer(sender, recipient, amount);
145 
146         uint256 currentAllowance = _allowances[sender][_msgSender()];
147         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
148         unchecked {
149             _approve(sender, _msgSender(), currentAllowance - amount);
150         }
151 
152         return true;
153     }
154 
155     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
156         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
157         return true;
158     }
159 
160     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
161         uint256 currentAllowance = _allowances[_msgSender()][spender];
162         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
163         unchecked {
164             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
165         }
166 
167         return true;
168     }
169 
170     function _transfer(
171         address sender,
172         address recipient,
173         uint256 amount
174     ) internal virtual {
175         require(sender != address(0), "ERC20: transfer from the zero address");
176         require(recipient != address(0), "ERC20: transfer to the zero address");
177 
178         _beforeTokenTransfer(sender, recipient, amount);
179 
180         uint256 senderBalance = _balances[sender];
181         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
182         unchecked {
183             _balances[sender] = senderBalance - amount;
184         }
185         _balances[recipient] += amount;
186 
187         emit Transfer(sender, recipient, amount);
188 
189         _afterTokenTransfer(sender, recipient, amount);
190     }
191 
192     function _mint(address account, uint256 amount) internal virtual {
193         require(account != address(0), "ERC20: mint to the zero address");
194 
195         _beforeTokenTransfer(address(0), account, amount);
196 
197         _totalSupply += amount;
198         _balances[account] += amount;
199         emit Transfer(address(0), account, amount);
200 
201         _afterTokenTransfer(address(0), account, amount);
202     }
203 
204     function _burn(address account, uint256 amount) internal virtual {
205         require(account != address(0), "ERC20: burn from the zero address");
206 
207         _beforeTokenTransfer(account, address(0), amount);
208 
209         uint256 accountBalance = _balances[account];
210         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
211         unchecked {
212             _balances[account] = accountBalance - amount;
213         }
214         _totalSupply -= amount;
215 
216         emit Transfer(account, address(0), amount);
217 
218         _afterTokenTransfer(account, address(0), amount);
219     }
220 
221     function _approve(
222         address owner,
223         address spender,
224         uint256 amount
225     ) internal virtual {
226         require(owner != address(0), "ERC20: approve from the zero address");
227         require(spender != address(0), "ERC20: approve to the zero address");
228 
229         _allowances[owner][spender] = amount;
230         emit Approval(owner, spender, amount);
231     }
232 
233     function _beforeTokenTransfer(
234         address from,
235         address to,
236         uint256 amount
237     ) internal virtual {}
238 
239     function _afterTokenTransfer(
240         address from,
241         address to,
242         uint256 amount
243     ) internal virtual {}
244 }
245 
246 library SafeMath {
247 
248     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
249         unchecked {
250             uint256 c = a + b;
251             if (c < a) return (false, 0);
252             return (true, c);
253         }
254     }
255 
256     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
257         unchecked {
258             if (b > a) return (false, 0);
259             return (true, a - b);
260         }
261     }
262 
263     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
264         unchecked {
265             if (a == 0) return (true, 0);
266             uint256 c = a * b;
267             if (c / a != b) return (false, 0);
268             return (true, c);
269         }
270     }
271 
272     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
273         unchecked {
274             if (b == 0) return (false, 0);
275             return (true, a / b);
276         }
277     }
278 
279     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
280         unchecked {
281             if (b == 0) return (false, 0);
282             return (true, a % b);
283         }
284     }
285 
286     function add(uint256 a, uint256 b) internal pure returns (uint256) {
287         return a + b;
288     }
289 
290     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
291         return a - b;
292     }
293 
294     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
295         return a * b;
296     }
297 
298     function div(uint256 a, uint256 b) internal pure returns (uint256) {
299         return a / b;
300     }
301 
302     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
303         return a % b;
304     }
305 
306     function sub(
307         uint256 a,
308         uint256 b,
309         string memory errorMessage
310     ) internal pure returns (uint256) {
311         unchecked {
312             require(b <= a, errorMessage);
313             return a - b;
314         }
315     }
316 
317     function div(
318         uint256 a,
319         uint256 b,
320         string memory errorMessage
321     ) internal pure returns (uint256) {
322         unchecked {
323             require(b > 0, errorMessage);
324             return a / b;
325         }
326     }
327 
328     function mod(
329         uint256 a,
330         uint256 b,
331         string memory errorMessage
332     ) internal pure returns (uint256) {
333         unchecked {
334             require(b > 0, errorMessage);
335             return a % b;
336         }
337     }
338 }
339 
340 interface IUniswapV2Factory {
341     event PairCreated(
342         address indexed token0,
343         address indexed token1,
344         address pair,
345         uint256
346     );
347 
348     function feeTo() external view returns (address);
349 
350     function feeToSetter() external view returns (address);
351 
352     function getPair(address tokenA, address tokenB)
353         external
354         view
355         returns (address pair);
356 
357     function allPairs(uint256) external view returns (address pair);
358 
359     function allPairsLength() external view returns (uint256);
360 
361     function createPair(address tokenA, address tokenB)
362         external
363         returns (address pair);
364 
365     function setFeeTo(address) external;
366 
367     function setFeeToSetter(address) external;
368 }
369 
370 interface IUniswapV2Pair {
371     event Approval(
372         address indexed owner,
373         address indexed spender,
374         uint256 value
375     );
376     event Transfer(address indexed from, address indexed to, uint256 value);
377 
378     function name() external pure returns (string memory);
379 
380     function symbol() external pure returns (string memory);
381 
382     function decimals() external pure returns (uint8);
383 
384     function totalSupply() external view returns (uint256);
385 
386     function balanceOf(address owner) external view returns (uint256);
387 
388     function allowance(address owner, address spender)
389         external
390         view
391         returns (uint256);
392 
393     function approve(address spender, uint256 value) external returns (bool);
394 
395     function transfer(address to, uint256 value) external returns (bool);
396 
397     function transferFrom(
398         address from,
399         address to,
400         uint256 value
401     ) external returns (bool);
402 
403     function DOMAIN_SEPARATOR() external view returns (bytes32);
404 
405     function PERMIT_TYPEHASH() external pure returns (bytes32);
406 
407     function nonces(address owner) external view returns (uint256);
408 
409     function permit(
410         address owner,
411         address spender,
412         uint256 value,
413         uint256 deadline,
414         uint8 v,
415         bytes32 r,
416         bytes32 s
417     ) external;
418 
419     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
420     event Burn(
421         address indexed sender,
422         uint256 amount0,
423         uint256 amount1,
424         address indexed to
425     );
426     event Swap(
427         address indexed sender,
428         uint256 amount0In,
429         uint256 amount1In,
430         uint256 amount0Out,
431         uint256 amount1Out,
432         address indexed to
433     );
434     event Sync(uint112 reserve0, uint112 reserve1);
435 
436     function MINIMUM_LIQUIDITY() external pure returns (uint256);
437 
438     function factory() external view returns (address);
439 
440     function token0() external view returns (address);
441 
442     function token1() external view returns (address);
443 
444     function getReserves()
445         external
446         view
447         returns (
448             uint112 reserve0,
449             uint112 reserve1,
450             uint32 blockTimestampLast
451         );
452 
453     function price0CumulativeLast() external view returns (uint256);
454 
455     function price1CumulativeLast() external view returns (uint256);
456 
457     function kLast() external view returns (uint256);
458 
459     function mint(address to) external returns (uint256 liquidity);
460 
461     function burn(address to)
462         external
463         returns (uint256 amount0, uint256 amount1);
464 
465     function swap(
466         uint256 amount0Out,
467         uint256 amount1Out,
468         address to,
469         bytes calldata data
470     ) external;
471 
472     function skim(address to) external;
473 
474     function sync() external;
475 
476     function initialize(address, address) external;
477 }
478 
479 interface IUniswapV2Router02 {
480     function factory() external pure returns (address);
481 
482     function WETH() external pure returns (address);
483 
484     function addLiquidity(
485         address tokenA,
486         address tokenB,
487         uint256 amountADesired,
488         uint256 amountBDesired,
489         uint256 amountAMin,
490         uint256 amountBMin,
491         address to,
492         uint256 deadline
493     )
494         external
495         returns (
496             uint256 amountA,
497             uint256 amountB,
498             uint256 liquidity
499         );
500 
501     function addLiquidityETH(
502         address token,
503         uint256 amountTokenDesired,
504         uint256 amountTokenMin,
505         uint256 amountETHMin,
506         address to,
507         uint256 deadline
508     )
509         external
510         payable
511         returns (
512             uint256 amountToken,
513             uint256 amountETH,
514             uint256 liquidity
515         );
516 
517     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
518         uint256 amountIn,
519         uint256 amountOutMin,
520         address[] calldata path,
521         address to,
522         uint256 deadline
523     ) external;
524 
525     function swapExactETHForTokensSupportingFeeOnTransferTokens(
526         uint256 amountOutMin,
527         address[] calldata path,
528         address to,
529         uint256 deadline
530     ) external payable;
531 
532     function swapExactTokensForETHSupportingFeeOnTransferTokens(
533         uint256 amountIn,
534         uint256 amountOutMin,
535         address[] calldata path,
536         address to,
537         uint256 deadline
538     ) external;
539 }
540 
541 contract MusicAI is ERC20, Ownable {
542     using SafeMath for uint256;
543 
544     IUniswapV2Router02 public immutable uniswapV2Router;
545     address public immutable uniswapV2Pair;
546     address public constant deadAddress = address(0xdead);
547     address public router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
548 
549     bool private swapping;
550 
551     address public marketingWallet;
552     address public developmentWallet;
553     address public liquidityWallet;
554     address public operationsWallet;
555 
556     uint256 public maxTransaction;
557     uint256 public swapTokensAtAmount;
558     uint256 public maxWallet;
559 
560     bool public limitsInEffect = true;
561     bool public tradingActive = false;
562     bool public swapEnabled = false;
563 
564     // Anti-bot and anti-whale mappings and variables
565     mapping(address => uint256) private _holderLastTransferTimestamp;
566     bool public transferDelayEnabled = true;
567     uint256 private launchBlock;
568     mapping(address => bool) public blocked;
569 
570     uint256 public buyTotalFees;
571     uint256 public buyMarketingFee;
572     uint256 public buyLiquidityFee;
573     uint256 public buyDevelopmentFee;
574     uint256 public buyOperationsFee;
575 
576     uint256 public sellTotalFees;
577     uint256 public sellMarketingFee;
578     uint256 public sellLiquidityFee;
579     uint256 public sellDevelopmentFee;
580     uint256 public sellOperationsFee;
581 
582     uint256 public tokensForMarketing;
583     uint256 public tokensForLiquidity;
584     uint256 public tokensForDevelopment;
585     uint256 public tokensForOperations;
586 
587     mapping(address => bool) private _isExcludedFromFees;
588     mapping(address => bool) public _isExcludedmaxTransaction;
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
601     event marketingWalletUpdated(
602         address indexed newWallet,
603         address indexed oldWallet
604     );
605 
606     event developmentWalletUpdated(
607         address indexed newWallet,
608         address indexed oldWallet
609     );
610 
611     event liquidityWalletUpdated(
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
627     constructor() ERC20("MusicAI", "MAI") {
628         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router); 
629 
630         excludeFromMaxTransaction(address(_uniswapV2Router), true);
631         uniswapV2Router = _uniswapV2Router;
632 
633         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
634         excludeFromMaxTransaction(address(uniswapV2Pair), true);
635         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
636 
637         // launch buy fees
638         uint256 _buyMarketingFee = 5;
639         uint256 _buyLiquidityFee = 0;
640         uint256 _buyDevelopmentFee = 10;
641         uint256 _buyOperationsFee = 5;
642         
643         // launch sell fees
644         uint256 _sellMarketingFee = 10;
645         uint256 _sellLiquidityFee = 0;
646         uint256 _sellDevelopmentFee = 10;
647         uint256 _sellOperationsFee = 10;
648 
649         uint256 totalSupply = 100_000_000 * 1e18;
650 
651         maxTransaction = 3_000_000 * 1e18; // 2% max transaction at launch
652         maxWallet = 3_000_000 * 1e18; // 2% max wallet at launch
653         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
654 
655         buyMarketingFee = _buyMarketingFee;
656         buyLiquidityFee = _buyLiquidityFee;
657         buyDevelopmentFee = _buyDevelopmentFee;
658         buyOperationsFee = _buyOperationsFee;
659         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee + buyOperationsFee;
660 
661         sellMarketingFee = _sellMarketingFee;
662         sellLiquidityFee = _sellLiquidityFee;
663         sellDevelopmentFee = _sellDevelopmentFee;
664         sellOperationsFee = _sellOperationsFee;
665         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee + sellOperationsFee;
666 
667         marketingWallet = address(0x7C869C44B4f0F69f8ca22815375BF105d5FBea9D); 
668         developmentWallet = address(0x953b707D18932f67839346f1178911a94Eb551fb); 
669         liquidityWallet = address(0xE6bc5f168399C18687002E85Fb2CEAF2BfBF19E5); 
670         operationsWallet = address(0xE6bc5f168399C18687002E85Fb2CEAF2BfBF19E5);
671 
672         // exclude from paying fees or having max transaction amount
673         excludeFromFees(owner(), true);
674         excludeFromFees(address(this), true);
675         excludeFromFees(address(0xdead), true);
676 
677         excludeFromMaxTransaction(owner(), true);
678         excludeFromMaxTransaction(address(this), true);
679         excludeFromMaxTransaction(address(0xdead), true);
680 
681         _mint(msg.sender, totalSupply);
682     }
683 
684     receive() external payable {}
685 
686     function enableTrading() external onlyOwner {
687         require(!tradingActive, "Token launched");
688         tradingActive = true;
689         launchBlock = block.number;
690         swapEnabled = true;
691     }
692 
693     // remove limits after token is stable
694     function removeLimits() external onlyOwner returns (bool) {
695         limitsInEffect = false;
696         return true;
697     }
698 
699     // disable Transfer delay - cannot be reenabled
700     function disableTransferDelay() external onlyOwner returns (bool) {
701         transferDelayEnabled = false;
702         return true;
703     }
704 
705     // change the minimum amount of tokens to sell from fees
706     function updateSwapTokensAtAmount(uint256 newAmount)
707         external
708         onlyOwner
709         returns (bool)
710     {
711         require(
712             newAmount >= (totalSupply() * 1) / 100000,
713             "Swap amount cannot be lower than 0.001% total supply."
714         );
715         require(
716             newAmount <= (totalSupply() * 5) / 1000,
717             "Swap amount cannot be higher than 0.5% total supply."
718         );
719         swapTokensAtAmount = newAmount;
720         return true;
721     }
722 
723     function updateMaxTransaction(uint256 newNum) external onlyOwner {
724         require(
725             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
726             "Cannot set maxTransaction lower than 0.1%"
727         );
728         maxTransaction = newNum * (10**18);
729     }
730 
731     function updateMaxWallet(uint256 newNum) external onlyOwner {
732         require(
733             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
734             "Cannot set maxWallet lower than 0.5%"
735         );
736         maxWallet = newNum * (10**18);
737     }
738 
739     function excludeFromMaxTransaction(address updAds, bool isEx)
740         public
741         onlyOwner
742     {
743         _isExcludedmaxTransaction[updAds] = isEx;
744     }
745 
746     // only use to disable contract sales if absolutely necessary (emergency use only)
747     function updateSwapEnabled(bool enabled) external onlyOwner {
748         swapEnabled = enabled;
749     }
750 
751     function updateBuyFees(
752         uint256 _marketingFee,
753         uint256 _liquidityFee,
754         uint256 _developmentFee,
755         uint256 _operationsFee
756     ) external onlyOwner {
757         buyMarketingFee = _marketingFee;
758         buyLiquidityFee = _liquidityFee;
759         buyDevelopmentFee = _developmentFee;
760         buyOperationsFee = _operationsFee;
761         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee + buyOperationsFee;
762         require(buyTotalFees <= 50);
763     }
764 
765     function updateSellFees(
766         uint256 _marketingFee,
767         uint256 _liquidityFee,
768         uint256 _developmentFee,
769         uint256 _operationsFee
770     ) external onlyOwner {
771         sellMarketingFee = _marketingFee;
772         sellLiquidityFee = _liquidityFee;
773         sellDevelopmentFee = _developmentFee;
774         sellOperationsFee = _operationsFee;
775         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee + sellOperationsFee;
776         require(sellTotalFees <= 50); 
777     }
778 
779     function excludeFromFees(address account, bool excluded) public onlyOwner {
780         _isExcludedFromFees[account] = excluded;
781         emit ExcludeFromFees(account, excluded);
782     }
783 
784     function setAutomatedMarketMakerPair(address pair, bool value)
785         public
786         onlyOwner
787     {
788         require(
789             pair != uniswapV2Pair,
790             "The pair cannot be removed from automatedMarketMakerPairs"
791         );
792 
793         _setAutomatedMarketMakerPair(pair, value);
794     }
795 
796     function _setAutomatedMarketMakerPair(address pair, bool value) private {
797         automatedMarketMakerPairs[pair] = value;
798 
799         emit SetAutomatedMarketMakerPair(pair, value);
800     }
801 
802     function updatemarketingWallet(address newmarketingWallet) external onlyOwner {
803         emit marketingWalletUpdated(newmarketingWallet, marketingWallet);
804         marketingWallet = newmarketingWallet;
805     }
806 
807     function updatedevelopmentWallet(address newWallet) external onlyOwner {
808         emit developmentWalletUpdated(newWallet, developmentWallet);
809         developmentWallet = newWallet;
810     }
811 
812     function updateoperationsWallet(address newWallet) external onlyOwner{
813         emit operationsWalletUpdated(newWallet, operationsWallet);
814         operationsWallet = newWallet;
815     }
816 
817     function updateliquidityWallet(address newliquidityWallet) external onlyOwner {
818         emit liquidityWalletUpdated(newliquidityWallet, liquidityWallet);
819         liquidityWallet = newliquidityWallet;
820     }
821 
822     function isExcludedFromFees(address account) public view returns (bool) {
823         return _isExcludedFromFees[account];
824     }
825 
826     function _transfer(
827         address from,
828         address to,
829         uint256 amount
830     ) internal override {
831         require(from != address(0), "ERC20: transfer from the zero address");
832         require(to != address(0), "ERC20: transfer to the zero address");
833         require(!blocked[from], "Sniper");
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
855                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
856                 if (transferDelayEnabled) {
857                     if (
858                         to != owner() &&
859                         to != address(uniswapV2Router) &&
860                         to != address(uniswapV2Pair)
861                     ) {
862                         require(
863                             _holderLastTransferTimestamp[tx.origin] <
864                                 block.number,
865                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
866                         );
867                         _holderLastTransferTimestamp[tx.origin] = block.number;
868                     }
869                 }
870 
871                 //when buy
872                 if (
873                     automatedMarketMakerPairs[from] &&
874                     !_isExcludedmaxTransaction[to]
875                 ) {
876                     require(
877                         amount <= maxTransaction,
878                         "Buy transfer amount exceeds the maxTransaction."
879                     );
880                     require(
881                         amount + balanceOf(to) <= maxWallet,
882                         "Max wallet exceeded"
883                     );
884                 }
885                 //when sell
886                 else if (
887                     automatedMarketMakerPairs[to] &&
888                     !_isExcludedmaxTransaction[from]
889                 ) {
890                     require(
891                         amount <= maxTransaction,
892                         "Sell transfer amount exceeds the maxTransaction."
893                     );
894                 } else if (!_isExcludedmaxTransaction[to]) {
895                     require(
896                         amount + balanceOf(to) <= maxWallet,
897                         "Max wallet exceeded"
898                     );
899                 }
900             }
901         }
902 
903         uint256 contractTokenBalance = balanceOf(address(this));
904 
905         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
906 
907         if (
908             canSwap &&
909             swapEnabled &&
910             !swapping &&
911             !automatedMarketMakerPairs[from] &&
912             !_isExcludedFromFees[from] &&
913             !_isExcludedFromFees[to]
914         ) {
915             swapping = true;
916 
917             swapBack();
918 
919             swapping = false;
920         }
921 
922         bool takeFee = !swapping;
923 
924         // if any account belongs to _isExcludedFromFee account then remove the fee
925         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
926             takeFee = false;
927         }
928 
929         uint256 fees = 0;
930         // only take fees on buys/sells, do not take on wallet transfers
931         if (takeFee) {
932             // on sell
933             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
934                 fees = amount.mul(sellTotalFees).div(100);
935                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
936                 tokensForDevelopment += (fees * sellDevelopmentFee) / sellTotalFees;
937                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
938                 tokensForOperations += (fees * sellOperationsFee) / sellTotalFees;
939             }
940             // on buy
941             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
942                 fees = amount.mul(buyTotalFees).div(100);
943                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
944                 tokensForDevelopment += (fees * buyDevelopmentFee) / buyTotalFees;
945                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
946                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
947             }
948 
949             if (fees > 0) {
950                 super._transfer(from, address(this), fees);
951             }
952 
953             amount -= fees;
954         }
955 
956         super._transfer(from, to, amount);
957     }
958 
959     function blacklistSnipers(address[] calldata blockees, bool shouldBlock) external onlyOwner {
960         for(uint256 i = 0;i<blockees.length;i++){
961             address blockee = blockees[i];
962             if(blockee != address(this) && 
963                blockee != router && 
964                blockee != address(uniswapV2Pair))
965                 blocked[blockee] = shouldBlock;
966         }
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
987     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
988         // approve token transfer to cover all possible scenarios
989         _approve(address(this), address(uniswapV2Router), tokenAmount);
990 
991         // add the liquidity
992         uniswapV2Router.addLiquidityETH{value: ethAmount}(
993             address(this),
994             tokenAmount,
995             0, // slippage is unavoidable
996             0, // slippage is unavoidable
997             liquidityWallet,
998             block.timestamp
999         );
1000     }
1001 
1002     function swapBack() private {
1003         uint256 contractBalance = balanceOf(address(this));
1004         uint256 totalTokensToSwap = tokensForLiquidity +
1005             tokensForMarketing +
1006             tokensForDevelopment +
1007             tokensForOperations;
1008         bool success;
1009 
1010         if (contractBalance == 0 || totalTokensToSwap == 0) {
1011             return;
1012         }
1013 
1014         if (contractBalance > swapTokensAtAmount * 20) {
1015             contractBalance = swapTokensAtAmount * 20;
1016         }
1017 
1018         // Halve the amount of liquidity tokens
1019         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1020         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1021 
1022         uint256 initialETHBalance = address(this).balance;
1023 
1024         swapTokensForEth(amountToSwapForETH);
1025 
1026         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1027 
1028         uint256 ethForMark = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1029         uint256 ethForDevelopment = ethBalance.mul(tokensForDevelopment).div(totalTokensToSwap);
1030         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap);
1031 
1032         uint256 ethForLiquidity = ethBalance - ethForMark - ethForDevelopment - ethForOperations;
1033 
1034         tokensForLiquidity = 0;
1035         tokensForMarketing = 0;
1036         tokensForDevelopment = 0;
1037         tokensForOperations = 0;
1038 
1039         (success, ) = address(developmentWallet).call{value: ethForDevelopment}("");
1040 
1041         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1042             addLiquidity(liquidityTokens, ethForLiquidity);
1043             emit SwapAndLiquify(
1044                 amountToSwapForETH,
1045                 ethForLiquidity,
1046                 tokensForLiquidity
1047             );
1048         }
1049         (success, ) = address(operationsWallet).call{value: ethForOperations}("");
1050         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
1051     }
1052 }