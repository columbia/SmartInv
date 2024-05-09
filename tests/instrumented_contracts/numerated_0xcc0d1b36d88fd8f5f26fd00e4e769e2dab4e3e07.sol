1 //██╗     ██╗ ██████╗ ██╗  ██╗████████╗███╗   ██╗██╗███╗   ██╗ ██████╗     ██████╗  ██████╗ ████████╗
2 //██║     ██║██╔════╝ ██║  ██║╚══██╔══╝████╗  ██║██║████╗  ██║██╔════╝     ██╔══██╗██╔═══██╗╚══██╔══╝
3 //██║     ██║██║  ███╗███████║   ██║   ██╔██╗ ██║██║██╔██╗ ██║██║  ███╗    ██████╔╝██║   ██║   ██║   
4 //██║     ██║██║   ██║██╔══██║   ██║   ██║╚██╗██║██║██║╚██╗██║██║   ██║    ██╔══██╗██║   ██║   ██║   
5 //███████╗██║╚██████╔╝██║  ██║   ██║   ██║ ╚████║██║██║ ╚████║╚██████╔╝    ██████╔╝╚██████╔╝   ██║   
6 //╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚═════╝  ╚═════╝    ╚═╝   
7                                                                                                        
8 
9 // TW: twitter.com/LightningBotETH
10 // TG: https://t.me/LightningBotPortal 
11 // Website: https://lightningbot.io/
12 
13 // SPDX-License-Identifier: MIT
14 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
15 pragma experimental ABIEncoderV2;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 abstract contract Ownable is Context {
28     address private _owner;
29 
30     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31 
32     constructor() {
33         _transferOwnership(_msgSender());
34     }
35 
36     function owner() public view virtual returns (address) {
37         return _owner;
38     }
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
55 
56     function _transferOwnership(address newOwner) internal virtual {
57         address oldOwner = _owner;
58         _owner = newOwner;
59         emit OwnershipTransferred(oldOwner, newOwner);
60     }
61 }
62 
63 interface IERC20 {
64 
65     function totalSupply() external view returns (uint256);
66 
67     function balanceOf(address account) external view returns (uint256);
68 
69 
70     function transfer(address recipient, uint256 amount) external returns (bool);
71 
72 
73     function allowance(address owner, address spender) external view returns (uint256);
74 
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77 
78     function transferFrom(
79         address sender,
80         address recipient,
81         uint256 amount
82     ) external returns (bool);
83 
84 
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 interface IERC20Metadata is IERC20 {
91 
92     function name() external view returns (string memory);
93 
94     function symbol() external view returns (string memory);
95 
96     function decimals() external view returns (uint8);
97 }
98 
99 
100 contract ERC20 is Context, IERC20, IERC20Metadata {
101     mapping(address => uint256) private _balances;
102 
103     mapping(address => mapping(address => uint256)) private _allowances;
104 
105     uint256 private _totalSupply;
106 
107     string private _name;
108     string private _symbol;
109 
110 
111     constructor(string memory name_, string memory symbol_) {
112         _name = name_;
113         _symbol = symbol_;
114     }
115 
116 
117     function name() public view virtual override returns (string memory) {
118         return _name;
119     }
120 
121 
122     function symbol() public view virtual override returns (string memory) {
123         return _symbol;
124     }
125 
126 
127     function decimals() public view virtual override returns (uint8) {
128         return 18;
129     }
130 
131 
132     function totalSupply() public view virtual override returns (uint256) {
133         return _totalSupply;
134     }
135 
136     function balanceOf(address account) public view virtual override returns (uint256) {
137         return _balances[account];
138     }
139 
140     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
141         _transfer(_msgSender(), recipient, amount);
142         return true;
143     }
144 
145 
146     function allowance(address owner, address spender) public view virtual override returns (uint256) {
147         return _allowances[owner][spender];
148     }
149 
150     function approve(address spender, uint256 amount) public virtual override returns (bool) {
151         _approve(_msgSender(), spender, amount);
152         return true;
153     }
154 
155     function transferFrom(
156         address sender,
157         address recipient,
158         uint256 amount
159     ) public virtual override returns (bool) {
160         _transfer(sender, recipient, amount);
161 
162         uint256 currentAllowance = _allowances[sender][_msgSender()];
163         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
164         unchecked {
165             _approve(sender, _msgSender(), currentAllowance - amount);
166         }
167 
168         return true;
169     }
170 
171     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
172         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
173         return true;
174     }
175 
176     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
177         uint256 currentAllowance = _allowances[_msgSender()][spender];
178         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
179         unchecked {
180             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
181         }
182 
183         return true;
184     }
185 
186     function _transfer(
187         address sender,
188         address recipient,
189         uint256 amount
190     ) internal virtual {
191         require(sender != address(0), "ERC20: transfer from the zero address");
192         require(recipient != address(0), "ERC20: transfer to the zero address");
193 
194         _beforeTokenTransfer(sender, recipient, amount);
195 
196         uint256 senderBalance = _balances[sender];
197         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
198         unchecked {
199             _balances[sender] = senderBalance - amount;
200         }
201         _balances[recipient] += amount;
202 
203         emit Transfer(sender, recipient, amount);
204 
205         _afterTokenTransfer(sender, recipient, amount);
206     }
207 
208     function _mint(address account, uint256 amount) internal virtual {
209         require(account != address(0), "ERC20: mint to the zero address");
210 
211         _beforeTokenTransfer(address(0), account, amount);
212 
213         _totalSupply += amount;
214         _balances[account] += amount;
215         emit Transfer(address(0), account, amount);
216 
217         _afterTokenTransfer(address(0), account, amount);
218     }
219 
220     function _burn(address account, uint256 amount) internal virtual {
221         require(account != address(0), "ERC20: burn from the zero address");
222 
223         _beforeTokenTransfer(account, address(0), amount);
224 
225         uint256 accountBalance = _balances[account];
226         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
227         unchecked {
228             _balances[account] = accountBalance - amount;
229         }
230         _totalSupply -= amount;
231 
232         emit Transfer(account, address(0), amount);
233 
234         _afterTokenTransfer(account, address(0), amount);
235     }
236 
237     function _approve(
238         address owner,
239         address spender,
240         uint256 amount
241     ) internal virtual {
242         require(owner != address(0), "ERC20: approve from the zero address");
243         require(spender != address(0), "ERC20: approve to the zero address");
244 
245         _allowances[owner][spender] = amount;
246         emit Approval(owner, spender, amount);
247     }
248 
249     function _beforeTokenTransfer(
250         address from,
251         address to,
252         uint256 amount
253     ) internal virtual {}
254 
255     function _afterTokenTransfer(
256         address from,
257         address to,
258         uint256 amount
259     ) internal virtual {}
260 }
261 
262 
263 library SafeMath {
264 
265     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
266         unchecked {
267             uint256 c = a + b;
268             if (c < a) return (false, 0);
269             return (true, c);
270         }
271     }
272 
273     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
274         unchecked {
275             if (b > a) return (false, 0);
276             return (true, a - b);
277         }
278     }
279 
280 
281     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
282         unchecked {
283             if (a == 0) return (true, 0);
284             uint256 c = a * b;
285             if (c / a != b) return (false, 0);
286             return (true, c);
287         }
288     }
289 
290     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
291         unchecked {
292             if (b == 0) return (false, 0);
293             return (true, a / b);
294         }
295     }
296 
297     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
298         unchecked {
299             if (b == 0) return (false, 0);
300             return (true, a % b);
301         }
302     }
303 
304 
305     function add(uint256 a, uint256 b) internal pure returns (uint256) {
306         return a + b;
307     }
308 
309     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
310         return a - b;
311     }
312 
313     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
314         return a * b;
315     }
316 
317     function div(uint256 a, uint256 b) internal pure returns (uint256) {
318         return a / b;
319     }
320 
321     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
322         return a % b;
323     }
324 
325     function sub(
326         uint256 a,
327         uint256 b,
328         string memory errorMessage
329     ) internal pure returns (uint256) {
330         unchecked {
331             require(b <= a, errorMessage);
332             return a - b;
333         }
334     }
335 
336     function div(
337         uint256 a,
338         uint256 b,
339         string memory errorMessage
340     ) internal pure returns (uint256) {
341         unchecked {
342             require(b > 0, errorMessage);
343             return a / b;
344         }
345     }
346 
347 
348     function mod(
349         uint256 a,
350         uint256 b,
351         string memory errorMessage
352     ) internal pure returns (uint256) {
353         unchecked {
354             require(b > 0, errorMessage);
355             return a % b;
356         }
357     }
358 }
359 
360 
361 interface IUniswapV2Factory {
362     event PairCreated(
363         address indexed token0,
364         address indexed token1,
365         address pair,
366         uint256
367     );
368 
369     function feeTo() external view returns (address);
370 
371     function feeToSetter() external view returns (address);
372 
373     function getPair(address tokenA, address tokenB)
374         external
375         view
376         returns (address pair);
377 
378     function allPairs(uint256) external view returns (address pair);
379 
380     function allPairsLength() external view returns (uint256);
381 
382     function createPair(address tokenA, address tokenB)
383         external
384         returns (address pair);
385 
386     function setFeeTo(address) external;
387 
388     function setFeeToSetter(address) external;
389 }
390 
391 
392 interface IUniswapV2Pair {
393     event Approval(
394         address indexed owner,
395         address indexed spender,
396         uint256 value
397     );
398     event Transfer(address indexed from, address indexed to, uint256 value);
399 
400     function name() external pure returns (string memory);
401 
402     function symbol() external pure returns (string memory);
403 
404     function decimals() external pure returns (uint8);
405 
406     function totalSupply() external view returns (uint256);
407 
408     function balanceOf(address owner) external view returns (uint256);
409 
410     function allowance(address owner, address spender)
411         external
412         view
413         returns (uint256);
414 
415     function approve(address spender, uint256 value) external returns (bool);
416 
417     function transfer(address to, uint256 value) external returns (bool);
418 
419     function transferFrom(
420         address from,
421         address to,
422         uint256 value
423     ) external returns (bool);
424 
425     function DOMAIN_SEPARATOR() external view returns (bytes32);
426 
427     function PERMIT_TYPEHASH() external pure returns (bytes32);
428 
429     function nonces(address owner) external view returns (uint256);
430 
431     function permit(
432         address owner,
433         address spender,
434         uint256 value,
435         uint256 deadline,
436         uint8 v,
437         bytes32 r,
438         bytes32 s
439     ) external;
440 
441     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
442     event Burn(
443         address indexed sender,
444         uint256 amount0,
445         uint256 amount1,
446         address indexed to
447     );
448     event Swap(
449         address indexed sender,
450         uint256 amount0In,
451         uint256 amount1In,
452         uint256 amount0Out,
453         uint256 amount1Out,
454         address indexed to
455     );
456     event Sync(uint112 reserve0, uint112 reserve1);
457 
458     function MINIMUM_LIQUIDITY() external pure returns (uint256);
459 
460     function factory() external view returns (address);
461 
462     function token0() external view returns (address);
463 
464     function token1() external view returns (address);
465 
466     function getReserves()
467         external
468         view
469         returns (
470             uint112 reserve0,
471             uint112 reserve1,
472             uint32 blockTimestampLast
473         );
474 
475     function price0CumulativeLast() external view returns (uint256);
476 
477     function price1CumulativeLast() external view returns (uint256);
478 
479     function kLast() external view returns (uint256);
480 
481     function mint(address to) external returns (uint256 liquidity);
482 
483     function burn(address to)
484         external
485         returns (uint256 amount0, uint256 amount1);
486 
487     function swap(
488         uint256 amount0Out,
489         uint256 amount1Out,
490         address to,
491         bytes calldata data
492     ) external;
493 
494     function skim(address to) external;
495 
496     function sync() external;
497 
498     function initialize(address, address) external;
499 }
500 
501 
502 interface IUniswapV2Router02 {
503     function factory() external pure returns (address);
504 
505     function WETH() external pure returns (address);
506 
507     function addLiquidity(
508         address tokenA,
509         address tokenB,
510         uint256 amountADesired,
511         uint256 amountBDesired,
512         uint256 amountAMin,
513         uint256 amountBMin,
514         address to,
515         uint256 deadline
516     )
517         external
518         returns (
519             uint256 amountA,
520             uint256 amountB,
521             uint256 liquidity
522         );
523 
524     function addLiquidityETH(
525         address token,
526         uint256 amountTokenDesired,
527         uint256 amountTokenMin,
528         uint256 amountETHMin,
529         address to,
530         uint256 deadline
531     )
532         external
533         payable
534         returns (
535             uint256 amountToken,
536             uint256 amountETH,
537             uint256 liquidity
538         );
539 
540     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
541         uint256 amountIn,
542         uint256 amountOutMin,
543         address[] calldata path,
544         address to,
545         uint256 deadline
546     ) external;
547 
548     function swapExactETHForTokensSupportingFeeOnTransferTokens(
549         uint256 amountOutMin,
550         address[] calldata path,
551         address to,
552         uint256 deadline
553     ) external payable;
554 
555     function swapExactTokensForETHSupportingFeeOnTransferTokens(
556         uint256 amountIn,
557         uint256 amountOutMin,
558         address[] calldata path,
559         address to,
560         uint256 deadline
561     ) external;
562 }
563 
564 
565 contract LightningBot is ERC20, Ownable {
566     using SafeMath for uint256;
567 
568     IUniswapV2Router02 public immutable uniswapV2Router;
569     address public immutable uniswapV2Pair;
570     address public constant deadAddress = address(0xdead);
571 
572     bool private swapping;
573 
574     address private marketingWallet;
575     address private developmentWallet;
576 
577     uint256 public maxTransactionAmount;
578     uint256 public swapTokensAtAmount;
579     uint256 public maxWallet;
580 
581     uint256 public percentForLPBurn = 0; 
582     bool public lpBurnEnabled = false;
583     uint256 public lpBurnFrequency = 3600 seconds;
584     uint256 public lastLpBurnTime;
585 
586     uint256 public manualBurnFrequency = 30 minutes;
587     uint256 public lastManualLpBurnTime;
588 
589     bool public limitsInEffect = true;
590     bool public tradingActive = false;
591     bool public swapEnabled = true;
592 
593     mapping(address => uint256) private _holderLastTransferTimestamp; 
594     bool public transferDelayEnabled = true;
595 
596     uint256 public buyTotalFees;
597     uint256 public buyMarketingFee;
598     uint256 public buyLiquidityFee;
599     uint256 public buyDevelopmentFee;
600 
601     uint256 public sellTotalFees;
602     uint256 public sellMarketingFee;
603     uint256 public sellLiquidityFee;
604     uint256 public sellDevelopmentFee;
605 
606     uint256 public tokensForMarketing;
607     uint256 public tokensForLiquidity;
608     uint256 public tokensForDev;
609 
610     mapping(address => bool) private _isExcludedFromFees;
611     mapping(address => bool) public _isExcludedMaxTransactionAmount;
612 
613     mapping(address => bool) public automatedMarketMakerPairs;
614 
615     event UpdateUniswapV2Router(
616         address indexed newAddress,
617         address indexed oldAddress
618     );
619 
620     event ExcludeFromFees(address indexed account, bool isExcluded);
621 
622     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
623 
624     event marketingWalletUpdated(
625         address indexed newWallet,
626         address indexed oldWallet
627     );
628 
629     event developmentWalletUpdated(
630         address indexed newWallet,
631         address indexed oldWallet
632     );
633 
634     event SwapAndLiquify(
635         uint256 tokensSwapped,
636         uint256 ethReceived,
637         uint256 tokensIntoLiquidity
638     );
639 
640     event AutoNukeLP();
641 
642     event ManualNukeLP();
643 
644     constructor() ERC20("Lightning Bot", "LIGHT") {
645         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
646             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
647         );
648 
649         excludeFromMaxTransaction(address(_uniswapV2Router), true);
650         uniswapV2Router = _uniswapV2Router;
651 
652         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
653             .createPair(address(this), _uniswapV2Router.WETH());
654         excludeFromMaxTransaction(address(uniswapV2Pair), true);
655         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
656 
657         uint256 _buyMarketingFee = 25;
658         uint256 _buyLiquidityFee = 0;
659         uint256 _buyDevelopmentFee = 0;
660 
661         uint256 _sellMarketingFee = 30;
662         uint256 _sellLiquidityFee = 0;
663         uint256 _sellDevelopmentFee = 0;
664 
665         uint256 totalSupply = 100_000_000 * 1e18;
666 
667         maxTransactionAmount = 1_500_000 * 1e18;
668         maxWallet = 2_000_000 * 1e18;
669         swapTokensAtAmount = (totalSupply * 10) / 10000;
670 
671         buyMarketingFee = _buyMarketingFee;
672         buyLiquidityFee = _buyLiquidityFee;
673         buyDevelopmentFee = _buyDevelopmentFee;
674         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
675 
676         sellMarketingFee = _sellMarketingFee;
677         sellLiquidityFee = _sellLiquidityFee;
678         sellDevelopmentFee = _sellDevelopmentFee;
679         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
680 
681         marketingWallet = address(0x8C6e02Dfe803a9E1c94B130dfc4902551B701147); 
682         developmentWallet = address(0x8C6e02Dfe803a9E1c94B130dfc4902551B701147); 
683 
684         excludeFromFees(owner(), true);
685         excludeFromFees(address(this), true);
686         excludeFromFees(address(0xdead), true);
687 
688         excludeFromMaxTransaction(owner(), true);
689         excludeFromMaxTransaction(address(this), true);
690         excludeFromMaxTransaction(address(0xdead), true);
691 
692         _mint(msg.sender, totalSupply);
693     }
694 
695     receive() external payable {}
696 
697     function enableTrading() external onlyOwner {
698         tradingActive = true;
699         swapEnabled = true;
700         lastLpBurnTime = block.timestamp;
701     }
702 
703     function removeLimits() external onlyOwner returns (bool) {
704         limitsInEffect = false;
705         return true;
706     }
707 
708     function disableTransferDelay() external onlyOwner returns (bool) {
709         transferDelayEnabled = false;
710         return true;
711     }
712 
713     function updateSwapTokensAtAmount(uint256 newAmount)
714         external
715         onlyOwner
716         returns (bool)
717     {
718         require(
719             newAmount >= (totalSupply() * 1) / 100000,
720             "Swap amount cannot be lower than 0.001% total supply."
721         );
722         require(
723             newAmount <= (totalSupply() * 5) / 1000,
724             "Swap amount cannot be higher than 0.5% total supply."
725         );
726         swapTokensAtAmount = newAmount;
727         return true;
728     }
729 
730     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
731         require(
732             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
733             "Cannot set maxTransactionAmount lower than 0.1%"
734         );
735         maxTransactionAmount = newNum * (10**18);
736     }
737 
738     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
739         require(
740             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
741             "Cannot set maxWallet lower than 0.5%"
742         );
743         maxWallet = newNum * (10**18);
744     }
745 
746     function excludeFromMaxTransaction(address updAds, bool isEx)
747         public
748         onlyOwner
749     {
750         _isExcludedMaxTransactionAmount[updAds] = isEx;
751     }
752 
753     function updateSwapEnabled(bool enabled) external onlyOwner {
754         swapEnabled = enabled;
755     }
756 
757     function updateBuyFees(
758         uint256 _marketingFee,
759         uint256 _liquidityFee,
760         uint256 _developmentFee
761     ) external onlyOwner {
762         buyMarketingFee = _marketingFee;
763         buyLiquidityFee = _liquidityFee;
764         buyDevelopmentFee = _developmentFee;
765         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
766         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
767     }
768 
769     function updateSellFees(
770         uint256 _marketingFee,
771         uint256 _liquidityFee,
772         uint256 _developmentFee
773     ) external onlyOwner {
774         sellMarketingFee = _marketingFee;
775         sellLiquidityFee = _liquidityFee;
776         sellDevelopmentFee = _developmentFee;
777         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
778         require(sellTotalFees <= 35, "Must keep fees at 35% or less");
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
804     function updateMarketingWalletInfo(address newMarketingWallet)
805         external
806         onlyOwner
807     {
808         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
809         marketingWallet = newMarketingWallet;
810     }
811 
812     function updateDevelopmentWalletInfo(address newWallet) external onlyOwner {
813         emit developmentWalletUpdated(newWallet, developmentWallet);
814         developmentWallet = newWallet;
815     }
816 
817     function isExcludedFromFees(address account) public view returns (bool) {
818         return _isExcludedFromFees[account];
819     }
820 
821     event BoughtEarly(address indexed sniper);
822 
823     function _transfer(
824         address from,
825         address to,
826         uint256 amount
827     ) internal override {
828         require(from != address(0), "ERC20: transfer from the zero address");
829         require(to != address(0), "ERC20: transfer to the zero address");
830 
831         if (amount == 0) {
832             super._transfer(from, to, 0);
833             return;
834         }
835 
836         if (limitsInEffect) {
837             if (
838                 from != owner() &&
839                 to != owner() &&
840                 to != address(0) &&
841                 to != address(0xdead) &&
842                 !swapping
843             ) {
844                 if (!tradingActive) {
845                     require(
846                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
847                         "Trading is not active."
848                     );
849                 }
850 
851                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
852                 if (transferDelayEnabled) {
853                     if (
854                         to != owner() &&
855                         to != address(uniswapV2Router) &&
856                         to != address(uniswapV2Pair)
857                     ) {
858                         require(
859                             _holderLastTransferTimestamp[tx.origin] <
860                                 block.number,
861                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
862                         );
863                         _holderLastTransferTimestamp[tx.origin] = block.number;
864                     }
865                 }
866 
867                 //when buy
868                 if (
869                     automatedMarketMakerPairs[from] &&
870                     !_isExcludedMaxTransactionAmount[to]
871                 ) {
872                     require(
873                         amount <= maxTransactionAmount,
874                         "Buy transfer amount exceeds the maxTransactionAmount."
875                     );
876                     require(
877                         amount + balanceOf(to) <= maxWallet,
878                         "Max wallet exceeded"
879                     );
880                 }
881                 //when sell
882                 else if (
883                     automatedMarketMakerPairs[to] &&
884                     !_isExcludedMaxTransactionAmount[from]
885                 ) {
886                     require(
887                         amount <= maxTransactionAmount,
888                         "Sell transfer amount exceeds the maxTransactionAmount."
889                     );
890                 } else if (!_isExcludedMaxTransactionAmount[to]) {
891                     require(
892                         amount + balanceOf(to) <= maxWallet,
893                         "Max wallet exceeded"
894                     );
895                 }
896             }
897         }
898 
899         uint256 contractTokenBalance = balanceOf(address(this));
900 
901         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
902 
903         if (
904             canSwap &&
905             swapEnabled &&
906             !swapping &&
907             !automatedMarketMakerPairs[from] &&
908             !_isExcludedFromFees[from] &&
909             !_isExcludedFromFees[to]
910         ) {
911             swapping = true;
912 
913             swapBack();
914 
915             swapping = false;
916         }
917 
918         if (
919             !swapping &&
920             automatedMarketMakerPairs[to] &&
921             lpBurnEnabled &&
922             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
923             !_isExcludedFromFees[from]
924         ) {
925             autoBurnLiquidityPairTokens();
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
942                 tokensForDev += (fees * sellDevelopmentFee) / sellTotalFees;
943                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
944             }
945             // on buy
946             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
947                 fees = amount.mul(buyTotalFees).div(100);
948                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
949                 tokensForDev += (fees * buyDevelopmentFee) / buyTotalFees;
950                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
951             }
952 
953             if (fees > 0) {
954                 super._transfer(from, address(this), fees);
955             }
956 
957             amount -= fees;
958         }
959 
960         super._transfer(from, to, amount);
961     }
962 
963     function swapTokensForEth(uint256 tokenAmount) private {
964         // generate the uniswap pair path of token -> weth
965         address[] memory path = new address[](2);
966         path[0] = address(this);
967         path[1] = uniswapV2Router.WETH();
968 
969         _approve(address(this), address(uniswapV2Router), tokenAmount);
970 
971         // make the swap
972         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
973             tokenAmount,
974             0, // accept any amount of ETH
975             path,
976             address(this),
977             block.timestamp
978         );
979     }
980 
981     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
982         // approve token transfer to cover all possible scenarios
983         _approve(address(this), address(uniswapV2Router), tokenAmount);
984 
985         // add the liquidity
986         uniswapV2Router.addLiquidityETH{value: ethAmount}(
987             address(this),
988             tokenAmount,
989             0, // slippage is unavoidable
990             0, // slippage is unavoidable
991             deadAddress,
992             block.timestamp
993         );
994     }
995 
996     function swapBack() private {
997         uint256 contractBalance = balanceOf(address(this));
998         uint256 totalTokensToSwap = tokensForLiquidity +
999             tokensForMarketing +
1000             tokensForDev;
1001         bool success;
1002 
1003         if (contractBalance == 0 || totalTokensToSwap == 0) {
1004             return;
1005         }
1006 
1007         if (contractBalance > swapTokensAtAmount * 20) {
1008             contractBalance = swapTokensAtAmount * 20;
1009         }
1010 
1011         // Halve the amount of liquidity tokens
1012         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1013             totalTokensToSwap /
1014             2;
1015         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1016 
1017         uint256 initialETHBalance = address(this).balance;
1018 
1019         swapTokensForEth(amountToSwapForETH);
1020 
1021         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1022 
1023         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1024             totalTokensToSwap
1025         );
1026         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1027 
1028         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1029 
1030         tokensForLiquidity = 0;
1031         tokensForMarketing = 0;
1032         tokensForDev = 0;
1033 
1034         (success, ) = address(developmentWallet).call{value: ethForDev}("");
1035 
1036         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1037             addLiquidity(liquidityTokens, ethForLiquidity);
1038             emit SwapAndLiquify(
1039                 amountToSwapForETH,
1040                 ethForLiquidity,
1041                 tokensForLiquidity
1042             );
1043         }
1044 
1045         (success, ) = address(marketingWallet).call{
1046             value: address(this).balance
1047         }("");
1048     }
1049 
1050     function setAutoLPBurnSettings(
1051         uint256 _frequencyInSeconds,
1052         uint256 _percent,
1053         bool _Enabled
1054     ) external onlyOwner {
1055         require(
1056             _frequencyInSeconds >= 600,
1057             "cannot set buyback more often than every 10 minutes"
1058         );
1059         require(
1060             _percent <= 1000 && _percent >= 0,
1061             "Must set auto LP burn percent between 0% and 10%"
1062         );
1063         lpBurnFrequency = _frequencyInSeconds;
1064         percentForLPBurn = _percent;
1065         lpBurnEnabled = _Enabled;
1066     }
1067 
1068     function autoBurnLiquidityPairTokens() internal returns (bool) {
1069         lastLpBurnTime = block.timestamp;
1070 
1071         // get balance of liquidity pair
1072         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1073 
1074         // calculate amount to burn
1075         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1076             10000
1077         );
1078 
1079         // pull tokens from pancakePair liquidity and move to dead address permanently
1080         if (amountToBurn > 0) {
1081             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1082         }
1083 
1084         //sync price since this is not in a swap transaction!
1085         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1086         pair.sync();
1087         emit AutoNukeLP();
1088         return true;
1089     }
1090 
1091     function manualBurnLiquidityPairTokens(uint256 percent)
1092         external
1093         onlyOwner
1094         returns (bool)
1095     {
1096         require(
1097             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1098             "Must wait for cooldown to finish"
1099         );
1100         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1101         lastManualLpBurnTime = block.timestamp;
1102 
1103         // get balance of liquidity pair
1104         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1105 
1106         // calculate amount to burn
1107         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1108 
1109         // pull tokens from pancakePair liquidity and move to dead address permanently
1110         if (amountToBurn > 0) {
1111             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1112         }
1113 
1114         //sync price since this is not in a swap transaction!
1115         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1116         pair.sync();
1117         emit ManualNukeLP();
1118         return true;
1119     }
1120 }