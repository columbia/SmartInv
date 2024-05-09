1 // SPDX-License-Identifier: MIT
2 // https://t.me/SAMHIMETH
3 
4 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
5 pragma experimental ABIEncoderV2;
6  
7  
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12  
13     function _msgData() internal view virtual returns (bytes calldata) {
14         return msg.data;
15     }
16 }
17  
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
37  
38     function renounceOwnership() public virtual onlyOwner {
39         _transferOwnership(address(0));
40     }
41  
42     function transferOwnership(address newOwner) public virtual onlyOwner {
43         require(newOwner != address(0), "Ownable: new owner is the zero address");
44         _transferOwnership(newOwner);
45     }
46  
47  
48     function _transferOwnership(address newOwner) internal virtual {
49         address oldOwner = _owner;
50         _owner = newOwner;
51         emit OwnershipTransferred(oldOwner, newOwner);
52     }
53 }
54  
55  
56 interface IERC20 {
57  
58     function totalSupply() external view returns (uint256);
59  
60     function balanceOf(address account) external view returns (uint256);
61  
62  
63     function transfer(address recipient, uint256 amount) external returns (bool);
64  
65  
66     function allowance(address owner, address spender) external view returns (uint256);
67  
68     function approve(address spender, uint256 amount) external returns (bool);
69  
70  
71     function transferFrom(
72         address sender,
73         address recipient,
74         uint256 amount
75     ) external returns (bool);
76  
77  
78     event Transfer(address indexed from, address indexed to, uint256 value);
79  
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82  
83  
84 interface IERC20Metadata is IERC20 {
85  
86     function name() external view returns (string memory);
87  
88     function symbol() external view returns (string memory);
89  
90     function decimals() external view returns (uint8);
91 }
92  
93  
94 contract ERC20 is Context, IERC20, IERC20Metadata {
95     mapping(address => uint256) private _balances;
96  
97     mapping(address => mapping(address => uint256)) private _allowances;
98  
99     uint256 private _totalSupply;
100  
101     string private _name;
102     string private _symbol;
103  
104  
105  
106     constructor(string memory name_, string memory symbol_) {
107         _name = name_;
108         _symbol = symbol_;
109     }
110  
111  
112     function name() public view virtual override returns (string memory) {
113         return _name;
114     }
115  
116  
117     function symbol() public view virtual override returns (string memory) {
118         return _symbol;
119     }
120  
121  
122     function decimals() public view virtual override returns (uint8) {
123         return 18;
124     }
125  
126  
127     function totalSupply() public view virtual override returns (uint256) {
128         return _totalSupply;
129     }
130  
131     function balanceOf(address account) public view virtual override returns (uint256) {
132         return _balances[account];
133     }
134  
135     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
136         _transfer(_msgSender(), recipient, amount);
137         return true;
138     }
139  
140  
141     function allowance(address owner, address spender) public view virtual override returns (uint256) {
142         return _allowances[owner][spender];
143     }
144  
145     function approve(address spender, uint256 amount) public virtual override returns (bool) {
146         _approve(_msgSender(), spender, amount);
147         return true;
148     }
149  
150     function transferFrom(
151         address sender,
152         address recipient,
153         uint256 amount
154     ) public virtual override returns (bool) {
155         _transfer(sender, recipient, amount);
156  
157         uint256 currentAllowance = _allowances[sender][_msgSender()];
158         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
159         unchecked {
160             _approve(sender, _msgSender(), currentAllowance - amount);
161         }
162  
163         return true;
164     }
165  
166     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
167         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
168         return true;
169     }
170  
171     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
172         uint256 currentAllowance = _allowances[_msgSender()][spender];
173         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
174         unchecked {
175             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
176         }
177  
178         return true;
179     }
180  
181     function _transfer(
182         address sender,
183         address recipient,
184         uint256 amount
185     ) internal virtual {
186         require(sender != address(0), "ERC20: transfer from the zero address");
187         require(recipient != address(0), "ERC20: transfer to the zero address");
188  
189         _beforeTokenTransfer(sender, recipient, amount);
190  
191         uint256 senderBalance = _balances[sender];
192         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
193         unchecked {
194             _balances[sender] = senderBalance - amount;
195         }
196         _balances[recipient] += amount;
197  
198         emit Transfer(sender, recipient, amount);
199  
200         _afterTokenTransfer(sender, recipient, amount);
201     }
202  
203     function _mint(address account, uint256 amount) internal virtual {
204         require(account != address(0), "ERC20: mint to the zero address");
205  
206         _beforeTokenTransfer(address(0), account, amount);
207  
208         _totalSupply += amount;
209         _balances[account] += amount;
210         emit Transfer(address(0), account, amount);
211  
212         _afterTokenTransfer(address(0), account, amount);
213     }
214  
215     function _burn(address account, uint256 amount) internal virtual {
216         require(account != address(0), "ERC20: burn from the zero address");
217  
218         _beforeTokenTransfer(account, address(0), amount);
219  
220         uint256 accountBalance = _balances[account];
221         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
222         unchecked {
223             _balances[account] = accountBalance - amount;
224         }
225         _totalSupply -= amount;
226  
227         emit Transfer(account, address(0), amount);
228  
229         _afterTokenTransfer(account, address(0), amount);
230     }
231  
232     function _approve(
233         address owner,
234         address spender,
235         uint256 amount
236     ) internal virtual {
237         require(owner != address(0), "ERC20: approve from the zero address");
238         require(spender != address(0), "ERC20: approve to the zero address");
239  
240         _allowances[owner][spender] = amount;
241         emit Approval(owner, spender, amount);
242     }
243  
244     function _beforeTokenTransfer(
245         address from,
246         address to,
247         uint256 amount
248     ) internal virtual {}
249  
250     function _afterTokenTransfer(
251         address from,
252         address to,
253         uint256 amount
254     ) internal virtual {}
255 }
256  
257  
258 library SafeMath {
259  
260     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
261         unchecked {
262             uint256 c = a + b;
263             if (c < a) return (false, 0);
264             return (true, c);
265         }
266     }
267  
268     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
269         unchecked {
270             if (b > a) return (false, 0);
271             return (true, a - b);
272         }
273     }
274  
275  
276     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
277         unchecked {
278             if (a == 0) return (true, 0);
279             uint256 c = a * b;
280             if (c / a != b) return (false, 0);
281             return (true, c);
282         }
283     }
284  
285     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
286         unchecked {
287             if (b == 0) return (false, 0);
288             return (true, a / b);
289         }
290     }
291  
292     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
293         unchecked {
294             if (b == 0) return (false, 0);
295             return (true, a % b);
296         }
297     }
298  
299  
300     function add(uint256 a, uint256 b) internal pure returns (uint256) {
301         return a + b;
302     }
303  
304     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
305         return a - b;
306     }
307  
308     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
309         return a * b;
310     }
311  
312     function div(uint256 a, uint256 b) internal pure returns (uint256) {
313         return a / b;
314     }
315  
316     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
317         return a % b;
318     }
319  
320     function sub(
321         uint256 a,
322         uint256 b,
323         string memory errorMessage
324     ) internal pure returns (uint256) {
325         unchecked {
326             require(b <= a, errorMessage);
327             return a - b;
328         }
329     }
330  
331     function div(
332         uint256 a,
333         uint256 b,
334         string memory errorMessage
335     ) internal pure returns (uint256) {
336         unchecked {
337             require(b > 0, errorMessage);
338             return a / b;
339         }
340     }
341  
342  
343     function mod(
344         uint256 a,
345         uint256 b,
346         string memory errorMessage
347     ) internal pure returns (uint256) {
348         unchecked {
349             require(b > 0, errorMessage);
350             return a % b;
351         }
352     }
353 }
354  
355  
356 interface IUniswapV2Factory {
357     event PairCreated(
358         address indexed token0,
359         address indexed token1,
360         address pair,
361         uint256
362     );
363  
364     function feeTo() external view returns (address);
365  
366     function feeToSetter() external view returns (address);
367  
368     function getPair(address tokenA, address tokenB)
369         external
370         view
371         returns (address pair);
372  
373     function allPairs(uint256) external view returns (address pair);
374  
375     function allPairsLength() external view returns (uint256);
376  
377     function createPair(address tokenA, address tokenB)
378         external
379         returns (address pair);
380  
381     function setFeeTo(address) external;
382  
383     function setFeeToSetter(address) external;
384 }
385  
386  
387 interface IUniswapV2Pair {
388     event Approval(
389         address indexed owner,
390         address indexed spender,
391         uint256 value
392     );
393     event Transfer(address indexed from, address indexed to, uint256 value);
394  
395     function name() external pure returns (string memory);
396  
397     function symbol() external pure returns (string memory);
398  
399     function decimals() external pure returns (uint8);
400  
401     function totalSupply() external view returns (uint256);
402  
403     function balanceOf(address owner) external view returns (uint256);
404  
405     function allowance(address owner, address spender)
406         external
407         view
408         returns (uint256);
409  
410     function approve(address spender, uint256 value) external returns (bool);
411  
412     function transfer(address to, uint256 value) external returns (bool);
413  
414     function transferFrom(
415         address from,
416         address to,
417         uint256 value
418     ) external returns (bool);
419  
420     function DOMAIN_SEPARATOR() external view returns (bytes32);
421  
422     function PERMIT_TYPEHASH() external pure returns (bytes32);
423  
424     function nonces(address owner) external view returns (uint256);
425  
426     function permit(
427         address owner,
428         address spender,
429         uint256 value,
430         uint256 deadline,
431         uint8 v,
432         bytes32 r,
433         bytes32 s
434     ) external;
435  
436     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
437     event Burn(
438         address indexed sender,
439         uint256 amount0,
440         uint256 amount1,
441         address indexed to
442     );
443     event Swap(
444         address indexed sender,
445         uint256 amount0In,
446         uint256 amount1In,
447         uint256 amount0Out,
448         uint256 amount1Out,
449         address indexed to
450     );
451     event Sync(uint112 reserve0, uint112 reserve1);
452  
453     function MINIMUM_LIQUIDITY() external pure returns (uint256);
454  
455     function factory() external view returns (address);
456  
457     function token0() external view returns (address);
458  
459     function token1() external view returns (address);
460  
461     function getReserves()
462         external
463         view
464         returns (
465             uint112 reserve0,
466             uint112 reserve1,
467             uint32 blockTimestampLast
468         );
469  
470     function price0CumulativeLast() external view returns (uint256);
471  
472     function price1CumulativeLast() external view returns (uint256);
473  
474     function kLast() external view returns (uint256);
475  
476     function mint(address to) external returns (uint256 liquidity);
477  
478     function burn(address to)
479         external
480         returns (uint256 amount0, uint256 amount1);
481  
482     function swap(
483         uint256 amount0Out,
484         uint256 amount1Out,
485         address to,
486         bytes calldata data
487     ) external;
488  
489     function skim(address to) external;
490  
491     function sync() external;
492  
493     function initialize(address, address) external;
494 }
495  
496  
497 interface IUniswapV2Router02 {
498     function factory() external pure returns (address);
499  
500     function WETH() external pure returns (address);
501  
502     function addLiquidity(
503         address tokenA,
504         address tokenB,
505         uint256 amountADesired,
506         uint256 amountBDesired,
507         uint256 amountAMin,
508         uint256 amountBMin,
509         address to,
510         uint256 deadline
511     )
512         external
513         returns (
514             uint256 amountA,
515             uint256 amountB,
516             uint256 liquidity
517         );
518  
519     function addLiquidityETH(
520         address token,
521         uint256 amountTokenDesired,
522         uint256 amountTokenMin,
523         uint256 amountETHMin,
524         address to,
525         uint256 deadline
526     )
527         external
528         payable
529         returns (
530             uint256 amountToken,
531             uint256 amountETH,
532             uint256 liquidity
533         );
534  
535     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
536         uint256 amountIn,
537         uint256 amountOutMin,
538         address[] calldata path,
539         address to,
540         uint256 deadline
541     ) external;
542  
543     function swapExactETHForTokensSupportingFeeOnTransferTokens(
544         uint256 amountOutMin,
545         address[] calldata path,
546         address to,
547         uint256 deadline
548     ) external payable;
549  
550     function swapExactTokensForETHSupportingFeeOnTransferTokens(
551         uint256 amountIn,
552         uint256 amountOutMin,
553         address[] calldata path,
554         address to,
555         uint256 deadline
556     ) external;
557 }
558  
559  
560  
561 contract HIM is ERC20, Ownable {
562     using SafeMath for uint256;
563  
564     IUniswapV2Router02 public immutable uniswapV2Router;
565     address public immutable uniswapV2Pair;
566     address public constant deadAddress = address(0xdead);
567  
568     bool private swapping;
569  
570     address private marketingWallet;
571     address private developmentWallet;
572  
573     uint256 public percentForLPBurn = 0; 
574     bool public lpBurnEnabled = false;
575     uint256 public lpBurnFrequency = 3600 seconds;
576     uint256 public lastLpBurnTime;
577  
578     uint256 public maxTransactionAmount;
579     uint256 public swapTokensAtAmount;
580     uint256 public maxWallet;
581  
582     bool public limitsInEffect = true;
583     bool public tradingActive = true;
584     bool public swapEnabled = true;
585  
586     uint256 public manualBurnFrequency = 30 minutes;
587     uint256 public lastManualLpBurnTime;
588  
589  
590  
591     mapping(address => uint256) private _holderLastTransferTimestamp; 
592     bool public transferDelayEnabled = true;
593  
594     uint256 public buyTotalFees;
595     uint256 public buyMarketingFee;
596     uint256 public buyLiquidityFee;
597     uint256 public buyDevelopmentFee;
598  
599     uint256 public sellTotalFees;
600     uint256 public sellMarketingFee;
601     uint256 public sellLiquidityFee;
602     uint256 public sellDevelopmentFee;
603  
604     uint256 public tokensForMarketing;
605     uint256 public tokensForLiquidity;
606     uint256 public tokensForDev;
607  
608     mapping(address => bool) private _isExcludedFromFees;
609     mapping(address => bool) public _isExcludedMaxTransactionAmount;
610  
611     mapping(address => bool) public automatedMarketMakerPairs;
612  
613     event UpdateUniswapV2Router(
614         address indexed newAddress,
615         address indexed oldAddress
616     );
617  
618     event ExcludeFromFees(address indexed account, bool isExcluded);
619  
620     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
621  
622     event marketingWalletUpdated(
623         address indexed newWallet,
624         address indexed oldWallet
625     );
626  
627     event developmentWalletUpdated(
628         address indexed newWallet,
629         address indexed oldWallet
630     );
631  
632     event SwapAndLiquify(
633         uint256 tokensSwapped,
634         uint256 ethReceived,
635         uint256 tokensIntoLiquidity
636     );
637  
638     event AutoNukeLP();
639  
640     event ManualNukeLP();
641  
642     constructor() ERC20("Sam", "HIM") {
643         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
644             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
645         );
646  
647         excludeFromMaxTransaction(address(_uniswapV2Router), true);
648         uniswapV2Router = _uniswapV2Router;
649  
650         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
651             .createPair(address(this), _uniswapV2Router.WETH());
652         excludeFromMaxTransaction(address(uniswapV2Pair), true);
653         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
654  
655         uint256 _buyMarketingFee = 10;
656         uint256 _buyLiquidityFee = 0;
657         uint256 _buyDevelopmentFee = 15;
658  
659         uint256 _sellMarketingFee = 99;
660         uint256 _sellLiquidityFee = 0;
661         uint256 _sellDevelopmentFee = 0;
662  
663         uint256 totalSupply = 1_000_000_000 * 1e18;
664  
665         maxTransactionAmount = 20_000_000 * 1e18; 
666         maxWallet = 20_000_000 * 1e18; 
667         swapTokensAtAmount = (totalSupply * 10) / 10000;
668  
669         buyMarketingFee = _buyMarketingFee;
670         buyLiquidityFee = _buyLiquidityFee;
671         buyDevelopmentFee = _buyDevelopmentFee;
672         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
673  
674         sellMarketingFee = _sellMarketingFee;
675         sellLiquidityFee = _sellLiquidityFee;
676         sellDevelopmentFee = _sellDevelopmentFee;
677         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
678  
679         marketingWallet = address(0x67f8D6c27b6af1de3b9Cd221AeDCC6B90E9442f7); 
680         developmentWallet = address(0x67f8D6c27b6af1de3b9Cd221AeDCC6B90E9442f7); 
681  
682         excludeFromFees(owner(), true);
683         excludeFromFees(address(this), true);
684         excludeFromFees(address(0xdead), true);
685  
686         excludeFromMaxTransaction(owner(), true);
687         excludeFromMaxTransaction(address(this), true);
688         excludeFromMaxTransaction(address(0xdead), true);
689  
690         _mint(msg.sender, totalSupply);
691     }
692  
693     receive() external payable {}
694  
695     function enableTrade() external onlyOwner {
696         tradingActive = true;
697         swapEnabled = true;
698         lastLpBurnTime = block.timestamp;
699     }
700  
701     function removeLimits() external onlyOwner returns (bool) {
702         limitsInEffect = false;
703         return true;
704     }
705  
706     function disableTransferDelay() external onlyOwner returns (bool) {
707         transferDelayEnabled = false;
708         return true;
709     }
710  
711     function updateSwapTokensAtAmount(uint256 newAmount)
712         external
713         onlyOwner
714         returns (bool)
715     {
716         require(
717             newAmount >= (totalSupply() * 1) / 100000,
718             "Swap amount cannot be lower than 0.001% total supply."
719         );
720         require(
721             newAmount <= (totalSupply() * 5) / 1000,
722             "Swap amount cannot be higher than 0.5% total supply."
723         );
724         swapTokensAtAmount = newAmount;
725         return true;
726     }
727  
728     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
729         require(
730             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
731             "Cannot set maxTransactionAmount lower than 0.1%"
732         );
733         maxTransactionAmount = newNum * (10**18);
734     }
735  
736     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
737         require(
738             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
739             "Cannot set maxWallet lower than 0.5%"
740         );
741         maxWallet = newNum * (10**18);
742     }
743  
744     function excludeFromMaxTransaction(address updAds, bool isEx)
745         public
746         onlyOwner
747     {
748         _isExcludedMaxTransactionAmount[updAds] = isEx;
749     }
750  
751     function updateSwapEnabled(bool enabled) external onlyOwner {
752         swapEnabled = enabled;
753     }
754  
755     function updateBuyFees(
756         uint256 _marketingFee,
757         uint256 _liquidityFee,
758         uint256 _developmentFee
759     ) external onlyOwner {
760         buyMarketingFee = _marketingFee;
761         buyLiquidityFee = _liquidityFee;
762         buyDevelopmentFee = _developmentFee;
763         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
764     }
765  
766     function updateSellFees(
767         uint256 _marketingFee,
768         uint256 _liquidityFee,
769         uint256 _developmentFee
770     ) external onlyOwner {
771         sellMarketingFee = _marketingFee;
772         sellLiquidityFee = _liquidityFee;
773         sellDevelopmentFee = _developmentFee;
774         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
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
800     function updateMarketingWalletInfo(address newMarketingWallet)
801         external
802         onlyOwner
803     {
804         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
805         marketingWallet = newMarketingWallet;
806     }
807  
808     function updateDevelopmentWalletInfo(address newWallet) external onlyOwner {
809         emit developmentWalletUpdated(newWallet, developmentWallet);
810         developmentWallet = newWallet;
811     }
812  
813     function isExcludedFromFees(address account) public view returns (bool) {
814         return _isExcludedFromFees[account];
815     }
816  
817     event BoughtEarly(address indexed sniper);
818  
819     function _transfer(
820         address from,
821         address to,
822         uint256 amount
823     ) internal override {
824         require(from != address(0), "ERC20: transfer from the zero address");
825         require(to != address(0), "ERC20: transfer to the zero address");
826  
827         if (amount == 0) {
828             super._transfer(from, to, 0);
829             return;
830         }
831  
832         if (limitsInEffect) {
833             if (
834                 from != owner() &&
835                 to != owner() &&
836                 to != address(0) &&
837                 to != address(0xdead) &&
838                 !swapping
839             ) {
840                 if (!tradingActive) {
841                     require(
842                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
843                         "Trading is not active."
844                     );
845                 }
846  
847                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
848                 if (transferDelayEnabled) {
849                     if (
850                         to != owner() &&
851                         to != address(uniswapV2Router) &&
852                         to != address(uniswapV2Pair)
853                     ) {
854                         require(
855                             _holderLastTransferTimestamp[tx.origin] <
856                                 block.number,
857                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
858                         );
859                         _holderLastTransferTimestamp[tx.origin] = block.number;
860                     }
861                 }
862  
863                 //when buy
864                 if (
865                     automatedMarketMakerPairs[from] &&
866                     !_isExcludedMaxTransactionAmount[to]
867                 ) {
868                     require(
869                         amount <= maxTransactionAmount,
870                         "Buy transfer amount exceeds the maxTransactionAmount."
871                     );
872                     require(
873                         amount + balanceOf(to) <= maxWallet,
874                         "Max wallet exceeded"
875                     );
876                 }
877                 //when sell
878                 else if (
879                     automatedMarketMakerPairs[to] &&
880                     !_isExcludedMaxTransactionAmount[from]
881                 ) {
882                     require(
883                         amount <= maxTransactionAmount,
884                         "Sell transfer amount exceeds the maxTransactionAmount."
885                     );
886                 } else if (!_isExcludedMaxTransactionAmount[to]) {
887                     require(
888                         amount + balanceOf(to) <= maxWallet,
889                         "Max wallet exceeded"
890                     );
891                 }
892             }
893         }
894  
895         uint256 contractTokenBalance = balanceOf(address(this));
896  
897         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
898  
899         if (
900             canSwap &&
901             swapEnabled &&
902             !swapping &&
903             !automatedMarketMakerPairs[from] &&
904             !_isExcludedFromFees[from] &&
905             !_isExcludedFromFees[to]
906         ) {
907             swapping = true;
908  
909             swapBack();
910  
911             swapping = false;
912         }
913  
914         if (
915             !swapping &&
916             automatedMarketMakerPairs[to] &&
917             lpBurnEnabled &&
918             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
919             !_isExcludedFromFees[from]
920         ) {
921             autoBurnLiquidityPairTokens();
922         }
923  
924         bool takeFee = !swapping;
925  
926         // if any account belongs to _isExcludedFromFee account then remove the fee
927         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
928             takeFee = false;
929         }
930  
931         uint256 fees = 0;
932         // only take fees on buys/sells, do not take on wallet transfers
933         if (takeFee) {
934             // on sell
935             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
936                 fees = amount.mul(sellTotalFees).div(100);
937                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
938                 tokensForDev += (fees * sellDevelopmentFee) / sellTotalFees;
939                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
940             }
941             // on buy
942             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
943                 fees = amount.mul(buyTotalFees).div(100);
944                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
945                 tokensForDev += (fees * buyDevelopmentFee) / buyTotalFees;
946                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
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
959     function swapTokensForEth(uint256 tokenAmount) private {
960         // generate the uniswap pair path of token -> weth
961         address[] memory path = new address[](2);
962         path[0] = address(this);
963         path[1] = uniswapV2Router.WETH();
964  
965         _approve(address(this), address(uniswapV2Router), tokenAmount);
966  
967         // make the swap
968         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
969             tokenAmount,
970             0, // accept any amount of ETH
971             path,
972             address(this),
973             block.timestamp
974         );
975     }
976  
977     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
978         // approve token transfer to cover all possible scenarios
979         _approve(address(this), address(uniswapV2Router), tokenAmount);
980  
981         // add the liquidity
982         uniswapV2Router.addLiquidityETH{value: ethAmount}(
983             address(this),
984             tokenAmount,
985             0, // slippage is unavoidable
986             0, // slippage is unavoidable
987             deadAddress,
988             block.timestamp
989         );
990     }
991  
992     function swapBack() private {
993         uint256 contractBalance = balanceOf(address(this));
994         uint256 totalTokensToSwap = tokensForLiquidity +
995             tokensForMarketing +
996             tokensForDev;
997         bool success;
998  
999         if (contractBalance == 0 || totalTokensToSwap == 0) {
1000             return;
1001         }
1002  
1003         if (contractBalance > swapTokensAtAmount * 20) {
1004             contractBalance = swapTokensAtAmount * 20;
1005         }
1006  
1007         // Halve the amount of liquidity tokens
1008         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1009             totalTokensToSwap /
1010             2;
1011         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1012  
1013         uint256 initialETHBalance = address(this).balance;
1014  
1015         swapTokensForEth(amountToSwapForETH);
1016  
1017         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1018  
1019         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1020             totalTokensToSwap
1021         );
1022         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1023  
1024         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1025  
1026         tokensForLiquidity = 0;
1027         tokensForMarketing = 0;
1028         tokensForDev = 0;
1029  
1030         (success, ) = address(developmentWallet).call{value: ethForDev}("");
1031  
1032         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1033             addLiquidity(liquidityTokens, ethForLiquidity);
1034             emit SwapAndLiquify(
1035                 amountToSwapForETH,
1036                 ethForLiquidity,
1037                 tokensForLiquidity
1038             );
1039         }
1040  
1041         (success, ) = address(marketingWallet).call{
1042             value: address(this).balance
1043         }("");
1044     }
1045  
1046     function setAutoLPBurnSettings(
1047         uint256 _frequencyInSeconds,
1048         uint256 _percent,
1049         bool _Enabled
1050     ) external onlyOwner {
1051         require(
1052             _frequencyInSeconds >= 600,
1053             "cannot set buyback more often than every 10 minutes"
1054         );
1055         require(
1056             _percent <= 1000 && _percent >= 0,
1057             "Must set auto LP burn percent between 0% and 10%"
1058         );
1059         lpBurnFrequency = _frequencyInSeconds;
1060         percentForLPBurn = _percent;
1061         lpBurnEnabled = _Enabled;
1062     }
1063  
1064     function autoBurnLiquidityPairTokens() internal returns (bool) {
1065         lastLpBurnTime = block.timestamp;
1066  
1067         // get balance of liquidity pair
1068         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1069  
1070         // calculate amount to burn
1071         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1072             10000
1073         );
1074  
1075         // pull tokens from pancakePair liquidity and move to dead address permanently
1076         if (amountToBurn > 0) {
1077             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1078         }
1079  
1080         //sync price since this is not in a swap transaction!
1081         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1082         pair.sync();
1083         emit AutoNukeLP();
1084         return true;
1085     }
1086  
1087     function manualBurnLiquidityPairTokens(uint256 percent)
1088         external
1089         onlyOwner
1090         returns (bool)
1091     {
1092         require(
1093             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1094             "Must wait for cooldown to finish"
1095         );
1096         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1097         lastManualLpBurnTime = block.timestamp;
1098  
1099         // get balance of liquidity pair
1100         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1101  
1102         // calculate amount to burn
1103         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1104  
1105         // pull tokens from pancakePair liquidity and move to dead address permanently
1106         if (amountToBurn > 0) {
1107             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1108         }
1109  
1110         //sync price since this is not in a swap transaction!
1111         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1112         pair.sync();
1113         emit ManualNukeLP();
1114         return true;
1115     }
1116 }