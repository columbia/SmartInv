1 /*
2 
3 
4           _____                    _____                    _____          
5          /\    \                  /\    \                  /\    \         
6         /::\    \                /::\____\                /::\    \        
7        /::::\    \              /::::|   |               /::::\    \       
8       /::::::\    \            /:::::|   |              /::::::\    \      
9      /:::/\:::\    \          /::::::|   |             /:::/\:::\    \     
10     /:::/__\:::\    \        /:::/|::|   |            /:::/  \:::\    \    
11    /::::\   \:::\    \      /:::/ |::|   |           /:::/    \:::\    \   
12   /::::::\   \:::\    \    /:::/  |::|___|______    /:::/    / \:::\    \  
13  /:::/\:::\   \:::\ ___\  /:::/   |::::::::\    \  /:::/    /   \:::\ ___\ 
14 /:::/__\:::\   \:::|    |/:::/    |:::::::::\____\/:::/____/     \:::|    |
15 \:::\   \:::\  /:::|____|\::/    / ~~~~~/:::/    /\:::\    \     /:::|____|
16  \:::\   \:::\/:::/    /  \/____/      /:::/    /  \:::\    \   /:::/    / 
17   \:::\   \::::::/    /               /:::/    /    \:::\    \ /:::/    /  
18    \:::\   \::::/    /               /:::/    /      \:::\    /:::/    /   
19     \:::\  /:::/    /               /:::/    /        \:::\  /:::/    /    
20      \:::\/:::/    /               /:::/    /          \:::\/:::/    /     
21       \::::::/    /               /:::/    /            \::::::/    /      
22        \::::/    /               /:::/    /              \::::/    /       
23         \::/____/                \::/    /                \::/____/        
24          ~~                       \/____/                  ~~              
25                                                                            
26 
27 
28 Telegram: http://t.me/BipolarMilady
29 Twitter: https://twitter.com/BipolarMilady
30 Website: https://www.BipolarMiladyDisorder.com
31 
32 */
33 
34 // SPDX-License-Identifier: UNLICENSED
35 
36 pragma solidity ^0.8.21;
37 
38 abstract contract Context {
39     function _msgSender() internal view virtual returns (address) {
40         return msg.sender;
41     }
42 
43     function _msgData() internal view virtual returns (bytes calldata) {
44         return msg.data;
45     }
46 }
47 
48 
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54 
55     constructor() {
56         _transferOwnership(_msgSender());
57     }
58 
59 
60     function owner() public view virtual returns (address) {
61         return _owner;
62     }
63 
64 
65     modifier onlyOwner() {
66         require(owner() == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     function renounceOwnership() public virtual onlyOwner {
71         _transferOwnership(address(0));
72     }
73 
74 
75     function transferOwnership(address newOwner) public virtual onlyOwner {
76         require(newOwner != address(0), "Ownable: new owner is the zero address");
77         _transferOwnership(newOwner);
78     }
79 
80     function _transferOwnership(address newOwner) internal virtual {
81         address oldOwner = _owner;
82         _owner = newOwner;
83         emit OwnershipTransferred(oldOwner, newOwner);
84     }
85 }
86 
87 interface IERC20 {
88 
89     function totalSupply() external view returns (uint256);
90 
91     function balanceOf(address account) external view returns (uint256);
92 
93     function transfer(address recipient, uint256 amount) external returns (bool);
94 
95     function allowance(address owner, address spender) external view returns (uint256);
96 
97     function approve(address spender, uint256 amount) external returns (bool);
98 
99     function transferFrom(
100         address sender,
101         address recipient,
102         uint256 amount
103     ) external returns (bool);
104 
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 interface IERC20Metadata is IERC20 {
111 
112     function name() external view returns (string memory);
113 
114     function symbol() external view returns (string memory);
115 
116     function decimals() external view returns (uint8);
117 }
118 
119 contract ERC20 is Context, IERC20, IERC20Metadata {
120     mapping(address => uint256) private _balances;
121 
122     mapping(address => mapping(address => uint256)) private _allowances;
123 
124     uint256 private _totalSupply;
125 
126     string private _name;
127     string private _symbol;
128 
129     constructor(string memory name_, string memory symbol_) {
130         _name = name_;
131         _symbol = symbol_;
132     }
133 
134 
135     function name() public view virtual override returns (string memory) {
136         return _name;
137     }
138 
139     function symbol() public view virtual override returns (string memory) {
140         return _symbol;
141     }
142 
143     function decimals() public view virtual override returns (uint8) {
144         return 18;
145     }
146 
147     function totalSupply() public view virtual override returns (uint256) {
148         return _totalSupply;
149     }
150 
151     function balanceOf(address account) public view virtual override returns (uint256) {
152         return _balances[account];
153     }
154 
155     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
156         _transfer(_msgSender(), recipient, amount);
157         return true;
158     }
159 
160     function allowance(address owner, address spender) public view virtual override returns (uint256) {
161         return _allowances[owner][spender];
162     }
163 
164     function approve(address spender, uint256 amount) public virtual override returns (bool) {
165         _approve(_msgSender(), spender, amount);
166         return true;
167     }
168 
169     function transferFrom(
170         address sender,
171         address recipient,
172         uint256 amount
173     ) public virtual override returns (bool) {
174         _transfer(sender, recipient, amount);
175 
176         uint256 currentAllowance = _allowances[sender][_msgSender()];
177         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
178         unchecked {
179             _approve(sender, _msgSender(), currentAllowance - amount);
180         }
181 
182         return true;
183     }
184 
185     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
186         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
187         return true;
188     }
189 
190     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
191         uint256 currentAllowance = _allowances[_msgSender()][spender];
192         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
193         unchecked {
194             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
195         }
196 
197         return true;
198     }
199 
200     function _transfer(
201         address sender,
202         address recipient,
203         uint256 amount
204     ) internal virtual {
205         require(sender != address(0), "ERC20: transfer from the zero address");
206         require(recipient != address(0), "ERC20: transfer to the zero address");
207 
208         _beforeTokenTransfer(sender, recipient, amount);
209 
210         uint256 senderBalance = _balances[sender];
211         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
212         unchecked {
213             _balances[sender] = senderBalance - amount;
214         }
215         _balances[recipient] += amount;
216 
217         emit Transfer(sender, recipient, amount);
218 
219         _afterTokenTransfer(sender, recipient, amount);
220     }
221 
222     function _mint(address account, uint256 amount) internal virtual {
223         require(account != address(0), "ERC20: mint to the zero address");
224 
225         _beforeTokenTransfer(address(0), account, amount);
226 
227         _totalSupply += amount;
228         _balances[account] += amount;
229         emit Transfer(address(0), account, amount);
230 
231         _afterTokenTransfer(address(0), account, amount);
232     }
233 
234     function _burn(address account, uint256 amount) internal virtual {
235         require(account != address(0), "ERC20: burn from the zero address");
236 
237         _beforeTokenTransfer(account, address(0), amount);
238 
239         uint256 accountBalance = _balances[account];
240         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
241         unchecked {
242             _balances[account] = accountBalance - amount;
243         }
244         _totalSupply -= amount;
245 
246         emit Transfer(account, address(0), amount);
247 
248         _afterTokenTransfer(account, address(0), amount);
249     }
250 
251     function _approve(
252         address owner,
253         address spender,
254         uint256 amount
255     ) internal virtual {
256         require(owner != address(0), "ERC20: approve from the zero address");
257         require(spender != address(0), "ERC20: approve to the zero address");
258 
259         _allowances[owner][spender] = amount;
260         emit Approval(owner, spender, amount);
261     }
262 
263     function _beforeTokenTransfer(
264         address from,
265         address to,
266         uint256 amount
267     ) internal virtual {}
268 
269     function _afterTokenTransfer(
270         address from,
271         address to,
272         uint256 amount
273     ) internal virtual {}
274 }
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
295             if (a == 0) return (true, 0);
296             uint256 c = a * b;
297             if (c / a != b) return (false, 0);
298             return (true, c);
299         }
300     }
301 
302     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
303         unchecked {
304             if (b == 0) return (false, 0);
305             return (true, a / b);
306         }
307     }
308 
309     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
310         unchecked {
311             if (b == 0) return (false, 0);
312             return (true, a % b);
313         }
314     }
315 
316     function add(uint256 a, uint256 b) internal pure returns (uint256) {
317         return a + b;
318     }
319 
320     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
321         return a - b;
322     }
323 
324     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
325         return a * b;
326     }
327 
328     function div(uint256 a, uint256 b) internal pure returns (uint256) {
329         return a / b;
330     }
331 
332     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
333         return a % b;
334     }
335 
336     function sub(
337         uint256 a,
338         uint256 b,
339         string memory errorMessage
340     ) internal pure returns (uint256) {
341         unchecked {
342             require(b <= a, errorMessage);
343             return a - b;
344         }
345     }
346 
347     function div(
348         uint256 a,
349         uint256 b,
350         string memory errorMessage
351     ) internal pure returns (uint256) {
352         unchecked {
353             require(b > 0, errorMessage);
354             return a / b;
355         }
356     }
357 
358     function mod(
359         uint256 a,
360         uint256 b,
361         string memory errorMessage
362     ) internal pure returns (uint256) {
363         unchecked {
364             require(b > 0, errorMessage);
365             return a % b;
366         }
367     }
368 }
369 
370 interface IUniswapV2Factory {
371     event PairCreated(
372         address indexed token0,
373         address indexed token1,
374         address pair,
375         uint256
376     );
377 
378     function feeTo() external view returns (address);
379 
380     function feeToSetter() external view returns (address);
381 
382     function getPair(address tokenA, address tokenB)
383         external
384         view
385         returns (address pair);
386 
387     function allPairs(uint256) external view returns (address pair);
388 
389     function allPairsLength() external view returns (uint256);
390 
391     function createPair(address tokenA, address tokenB)
392         external
393         returns (address pair);
394 
395     function setFeeTo(address) external;
396 
397     function setFeeToSetter(address) external;
398 }
399 
400 interface IUniswapV2Pair {
401     event Approval(
402         address indexed owner,
403         address indexed spender,
404         uint256 value
405     );
406     event Transfer(address indexed from, address indexed to, uint256 value);
407 
408     function name() external pure returns (string memory);
409 
410     function symbol() external pure returns (string memory);
411 
412     function decimals() external pure returns (uint8);
413 
414     function totalSupply() external view returns (uint256);
415 
416     function balanceOf(address owner) external view returns (uint256);
417 
418     function allowance(address owner, address spender)
419         external
420         view
421         returns (uint256);
422 
423     function approve(address spender, uint256 value) external returns (bool);
424 
425     function transfer(address to, uint256 value) external returns (bool);
426 
427     function transferFrom(
428         address from,
429         address to,
430         uint256 value
431     ) external returns (bool);
432 
433     function DOMAIN_SEPARATOR() external view returns (bytes32);
434 
435     function PERMIT_TYPEHASH() external pure returns (bytes32);
436 
437     function nonces(address owner) external view returns (uint256);
438 
439     function permit(
440         address owner,
441         address spender,
442         uint256 value,
443         uint256 deadline,
444         uint8 v,
445         bytes32 r,
446         bytes32 s
447     ) external;
448 
449     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
450     event Burn(
451         address indexed sender,
452         uint256 amount0,
453         uint256 amount1,
454         address indexed to
455     );
456     event Swap(
457         address indexed sender,
458         uint256 amount0In,
459         uint256 amount1In,
460         uint256 amount0Out,
461         uint256 amount1Out,
462         address indexed to
463     );
464     event Sync(uint112 reserve0, uint112 reserve1);
465 
466     function MINIMUM_LIQUIDITY() external pure returns (uint256);
467 
468     function factory() external view returns (address);
469 
470     function token0() external view returns (address);
471 
472     function token1() external view returns (address);
473 
474     function getReserves()
475         external
476         view
477         returns (
478             uint112 reserve0,
479             uint112 reserve1,
480             uint32 blockTimestampLast
481         );
482 
483     function price0CumulativeLast() external view returns (uint256);
484 
485     function price1CumulativeLast() external view returns (uint256);
486 
487     function kLast() external view returns (uint256);
488 
489     function mint(address to) external returns (uint256 liquidity);
490 
491     function burn(address to)
492         external
493         returns (uint256 amount0, uint256 amount1);
494 
495     function swap(
496         uint256 amount0Out,
497         uint256 amount1Out,
498         address to,
499         bytes calldata data
500     ) external;
501 
502     function skim(address to) external;
503 
504     function sync() external;
505 
506     function initialize(address, address) external;
507 }
508 
509 interface IUniswapV2Router02 {
510     function factory() external pure returns (address);
511 
512     function WETH() external pure returns (address);
513 
514     function addLiquidity(
515         address tokenA,
516         address tokenB,
517         uint256 amountADesired,
518         uint256 amountBDesired,
519         uint256 amountAMin,
520         uint256 amountBMin,
521         address to,
522         uint256 deadline
523     )
524         external
525         returns (
526             uint256 amountA,
527             uint256 amountB,
528             uint256 liquidity
529         );
530 
531     function addLiquidityETH(
532         address token,
533         uint256 amountTokenDesired,
534         uint256 amountTokenMin,
535         uint256 amountETHMin,
536         address to,
537         uint256 deadline
538     )
539         external
540         payable
541         returns (
542             uint256 amountToken,
543             uint256 amountETH,
544             uint256 liquidity
545         );
546 
547     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
548         uint256 amountIn,
549         uint256 amountOutMin,
550         address[] calldata path,
551         address to,
552         uint256 deadline
553     ) external;
554 
555     function swapExactETHForTokensSupportingFeeOnTransferTokens(
556         uint256 amountOutMin,
557         address[] calldata path,
558         address to,
559         uint256 deadline
560     ) external payable;
561 
562     function swapExactTokensForETHSupportingFeeOnTransferTokens(
563         uint256 amountIn,
564         uint256 amountOutMin,
565         address[] calldata path,
566         address to,
567         uint256 deadline
568     ) external;
569 }
570 
571 contract BipolarMiladyDisorder is ERC20, Ownable {
572     using SafeMath for uint256;
573 
574     IUniswapV2Router02 public immutable uniswapV2Router;
575     address public immutable uniswapV2Pair;
576     address public constant deadAddress = address(0xdead);
577 
578     bool private swapping;
579 
580     address private marketingWallet;
581 
582     uint256 public maxTransactionAmount;
583     uint256 public swapTokensAtAmount;
584     uint256 public maxWallet;
585 
586     bool public limitsInEffect = true;
587     bool public tradingActive = false;
588     bool public swapEnabled = false;
589 
590     uint256 private launchedAt;
591     uint256 private launchedTime;
592     uint256 public deadBlocks;
593 
594     uint256 public buyTotalFees;
595     uint256 private buyMarketingFee;
596 
597     uint256 public sellTotalFees;
598     uint256 public sellMarketingFee;
599 
600     mapping(address => bool) private _isExcludedFromFees;
601     mapping(uint256 => uint256) private swapInBlock;
602     mapping(address => bool) public _isExcludedMaxTransactionAmount;
603 
604     mapping(address => bool) public automatedMarketMakerPairs;
605 
606     event UpdateUniswapV2Router(
607         address indexed newAddress,
608         address indexed oldAddress
609     );
610 
611     event ExcludeFromFees(address indexed account, bool isExcluded);
612 
613     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
614 
615     event marketingWalletUpdated(
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
626     constructor(address _wallet1) ERC20("BipolarMiladyDisorder", "BMD") {
627         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
628 
629         excludeFromMaxTransaction(address(_uniswapV2Router), true);
630         uniswapV2Router = _uniswapV2Router;
631 
632         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
633             .createPair(address(this), _uniswapV2Router.WETH());
634         excludeFromMaxTransaction(address(uniswapV2Pair), true);
635         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
636 
637         uint256 totalSupply = 1_000_000_000 * 1e18;
638 
639 
640         maxTransactionAmount = 1_000_000_000 * 1e18;
641         maxWallet = 1_000_000_000 * 1e18;
642         swapTokensAtAmount = maxTransactionAmount / 2000;
643 
644         marketingWallet = _wallet1;
645 
646         excludeFromFees(owner(), true);
647         excludeFromFees(address(this), true);
648         excludeFromFees(address(0xdead), true);
649 
650         excludeFromMaxTransaction(owner(), true);
651         excludeFromMaxTransaction(address(this), true);
652         excludeFromMaxTransaction(address(0xdead), true);
653 
654         _mint(msg.sender, totalSupply);
655     }
656 
657     receive() external payable {}
658 
659     function enableTrading(uint256 _deadBlocks) external onlyOwner {
660         deadBlocks = _deadBlocks;
661         tradingActive = true;
662         swapEnabled = true;
663         launchedAt = block.number;
664         launchedTime = block.timestamp;
665     }
666 
667     function removeLimits() external onlyOwner returns (bool) {
668         limitsInEffect = false;
669         return true;
670     }
671 
672     function updateSwapTokensAtAmount(uint256 newAmount)
673         external
674         onlyOwner
675         returns (bool)
676     {
677         require(
678             newAmount >= (totalSupply() * 1) / 100000,
679             "Swap amount cannot be lower than 0.001% total supply."
680         );
681         require(
682             newAmount <= (totalSupply() * 5) / 1000,
683             "Swap amount cannot be higher than 0.5% total supply."
684         );
685         swapTokensAtAmount = newAmount;
686         return true;
687     }
688 
689     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
690         require(
691             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
692             "Cannot set maxTransactionAmount lower than 0.1%"
693         );
694         maxTransactionAmount = newNum * (10**18);
695     }
696 
697     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
698         require(
699             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
700             "Cannot set maxWallet lower than 0.5%"
701         );
702         maxWallet = newNum * (10**18);
703     }
704 
705     function whitelistContract(address _whitelist,bool isWL)
706     public
707     onlyOwner
708     {
709       _isExcludedMaxTransactionAmount[_whitelist] = isWL;
710 
711       _isExcludedFromFees[_whitelist] = isWL;
712 
713     }
714 
715     function excludeFromMaxTransaction(address updAds, bool isEx)
716         public
717         onlyOwner
718     {
719         _isExcludedMaxTransactionAmount[updAds] = isEx;
720     }
721 
722     // only use to disable contract sales if absolutely necessary (emergency use only)
723     function updateSwapEnabled(bool enabled) external onlyOwner {
724         swapEnabled = enabled;
725     }
726 
727     function excludeFromFees(address account, bool excluded) public onlyOwner {
728         _isExcludedFromFees[account] = excluded;
729         emit ExcludeFromFees(account, excluded);
730     }
731 
732     function manualswap(uint256 amount) external {
733       require(_msgSender() == marketingWallet);
734         require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
735         swapTokensForEth(amount);
736     }
737 
738     function manualsend() external {
739         bool success;
740         (success, ) = address(marketingWallet).call{
741             value: address(this).balance
742         }("");
743     }
744 
745         function setAutomatedMarketMakerPair(address pair, bool value)
746         public
747         onlyOwner
748     {
749         require(
750             pair != uniswapV2Pair,
751             "The pair cannot be removed from automatedMarketMakerPairs"
752         );
753 
754         _setAutomatedMarketMakerPair(pair, value);
755     }
756 
757     function _setAutomatedMarketMakerPair(address pair, bool value) private {
758         automatedMarketMakerPairs[pair] = value;
759 
760         emit SetAutomatedMarketMakerPair(pair, value);
761     }
762 
763     function updateBuyFees(
764         uint256 _marketingFee
765     ) external onlyOwner {
766         buyMarketingFee = _marketingFee;
767         buyTotalFees = buyMarketingFee;
768         require(buyTotalFees <= 10, "Must keep fees at 5% or less");
769     }
770 
771     function updateSellFees(
772         uint256 _marketingFee
773     ) external onlyOwner {
774         sellMarketingFee = _marketingFee;
775         sellTotalFees = sellMarketingFee;
776         require(sellTotalFees <= 10, "Must keep fees at 5% or less");
777     }
778 
779     function updateMarketingWallet(address newMarketingWallet)
780         external
781         onlyOwner
782     {
783         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
784         marketingWallet = newMarketingWallet;
785     }
786 
787     function airdrop(address[] calldata addresses, uint256[] calldata amounts) external {
788           require(addresses.length > 0 && amounts.length == addresses.length);
789           address from = msg.sender;
790 
791           for (uint i = 0; i < addresses.length; i++) {
792 
793             _transfer(from, addresses[i], amounts[i] * (10**18));
794 
795           }
796     }
797 
798     function _transfer(
799         address from,
800         address to,
801         uint256 amount
802     ) internal override {
803         require(from != address(0), "ERC20: transfer from the zero address");
804         require(to != address(0), "ERC20: transfer to the zero address");
805 
806         if (amount == 0) {
807             super._transfer(from, to, 0);
808             return;
809         }
810 
811         uint256 blockNum = block.number;
812 
813         if (limitsInEffect) {
814             if (
815                 from != owner() &&
816                 to != owner() &&
817                 to != address(0) &&
818                 to != address(0xdead) &&
819                 !swapping
820             ) {
821               if
822                 ((launchedAt + deadBlocks) >= blockNum)
823               {
824                 buyMarketingFee = 50;
825                 buyTotalFees = buyMarketingFee;
826 
827                 sellMarketingFee = 50;
828                 sellTotalFees = sellMarketingFee;
829 
830               } else if(blockNum > (launchedAt + deadBlocks) && blockNum <= launchedAt + 8)
831               {
832                 maxTransactionAmount =  20_000_000 * 1e18;
833                 maxWallet =  20_000_000 * 1e18;
834 
835                 buyMarketingFee = 10;
836                 buyTotalFees = buyMarketingFee;
837 
838                 sellMarketingFee = 10;
839                 sellTotalFees = sellMarketingFee;
840               }
841               else
842               {
843                 maxTransactionAmount =  20_000_000 * 1e18;
844                 maxWallet =  20_000_000 * 1e18;
845 
846                 buyMarketingFee = 2;
847                 buyTotalFees = buyMarketingFee;
848 
849                 sellMarketingFee = 2;
850                 sellTotalFees = sellMarketingFee;
851               }
852 
853                 if (!tradingActive) {
854                     require(
855                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
856                         "Trading is not active."
857                     );
858                 }
859 
860                 //when buy
861                 if (
862                     automatedMarketMakerPairs[from] &&
863                     !_isExcludedMaxTransactionAmount[to]
864                 ) {
865                     require(
866                         amount <= maxTransactionAmount,
867                         "Buy transfer amount exceeds the maxTransactionAmount."
868                     );
869                     require(
870                         amount + balanceOf(to) <= maxWallet,
871                         "Max wallet exceeded"
872                     );
873                 }
874                 //when sell
875                 else if (
876                     automatedMarketMakerPairs[to] &&
877                     !_isExcludedMaxTransactionAmount[from]
878                 ) {
879                     require(
880                         amount <= maxTransactionAmount,
881                         "Sell transfer amount exceeds the maxTransactionAmount."
882                     );
883                 } else if (!_isExcludedMaxTransactionAmount[to]) {
884                     require(
885                         amount + balanceOf(to) <= maxWallet,
886                         "Max wallet exceeded"
887                     );
888                 }
889             }
890         }
891 
892         uint256 contractTokenBalance = balanceOf(address(this));
893 
894         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
895 
896         if (
897             canSwap &&
898             swapEnabled &&
899             !swapping &&
900             (swapInBlock[blockNum] < 2) &&
901             !automatedMarketMakerPairs[from] &&
902             !_isExcludedFromFees[from] &&
903             !_isExcludedFromFees[to]
904         ) {
905             swapping = true;
906 
907             swapBack();
908 
909             ++swapInBlock[blockNum];
910 
911             swapping = false;
912         }
913 
914         bool takeFee = !swapping;
915 
916         // if any account belongs to _isExcludedFromFee account then remove the fee
917         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
918             takeFee = false;
919         }
920 
921         uint256 fees = 0;
922         // only take fees on buys/sells, do not take on wallet transfers
923         if (takeFee) {
924             // on sell
925             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
926                 fees = amount.mul(sellTotalFees).div(100);
927             }
928             // on buy
929             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
930                 fees = amount.mul(buyTotalFees).div(100);
931             }
932 
933             if (fees > 0) {
934                 super._transfer(from, address(this), fees);
935             }
936 
937             amount -= fees;
938         }
939 
940         super._transfer(from, to, amount);
941     }
942 
943     function swapTokensForEth(uint256 tokenAmount) private {
944         // generate the uniswap pair path of token -> weth
945         address[] memory path = new address[](2);
946         path[0] = address(this);
947         path[1] = uniswapV2Router.WETH();
948 
949         _approve(address(this), address(uniswapV2Router), tokenAmount);
950 
951         // make the swap
952         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
953             tokenAmount,
954             0, // accept any amount of ETH
955             path,
956             address(this),
957             block.timestamp
958         );
959     }
960 
961 
962     function swapBack() private {
963         uint256 contractBalance = balanceOf(address(this));
964         bool success;
965 
966         if (contractBalance == 0) {
967             return;
968         }
969 
970         if (contractBalance > swapTokensAtAmount * 20) {
971             contractBalance = swapTokensAtAmount * 20;
972         }
973 
974 
975         uint256 amountToSwapForETH = contractBalance;
976 
977         swapTokensForEth(amountToSwapForETH);
978 
979         (success, ) = address(marketingWallet).call{
980             value: address(this).balance
981         }("");
982     }
983 
984 }