1 /*
2 
3 Telegram: https://t.me/goblinzwtf_coin
4 Twitter: https://twitter.com/goblinzwtf_coin
5 Web: https://www.goblinzwtf.com
6 
7 
8   /$$$$$$   /$$$$$$  /$$$$$$$  /$$       /$$$$$$ /$$   /$$ /$$$$$$$$
9  /$$__  $$ /$$__  $$| $$__  $$| $$      |_  $$_/| $$$ | $$|_____ $$ 
10 | $$  \__/| $$  \ $$| $$  \ $$| $$        | $$  | $$$$| $$     /$$/ 
11 | $$ /$$$$| $$  | $$| $$$$$$$ | $$        | $$  | $$ $$ $$    /$$/  
12 | $$|_  $$| $$  | $$| $$__  $$| $$        | $$  | $$  $$$$   /$$/   
13 | $$  \ $$| $$  | $$| $$  \ $$| $$        | $$  | $$\  $$$  /$$/    
14 |  $$$$$$/|  $$$$$$/| $$$$$$$/| $$$$$$$$ /$$$$$$| $$ \  $$ /$$$$$$$$
15  \______/  \______/ |_______/ |________/|______/|__/  \__/|________/
16 
17 
18 */
19 
20 // SPDX-License-Identifier: UNLICENSED
21 
22 pragma solidity ^0.8.21;
23 
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         return msg.data;
31     }
32 }
33 
34 
35 abstract contract Ownable is Context {
36     address private _owner;
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40 
41     constructor() {
42         _transferOwnership(_msgSender());
43     }
44 
45 
46     function owner() public view virtual returns (address) {
47         return _owner;
48     }
49 
50 
51     modifier onlyOwner() {
52         require(owner() == _msgSender(), "Ownable: caller is not the owner");
53         _;
54     }
55 
56     function renounceOwnership() public virtual onlyOwner {
57         _transferOwnership(address(0));
58     }
59 
60 
61     function transferOwnership(address newOwner) public virtual onlyOwner {
62         require(newOwner != address(0), "Ownable: new owner is the zero address");
63         _transferOwnership(newOwner);
64     }
65 
66     function _transferOwnership(address newOwner) internal virtual {
67         address oldOwner = _owner;
68         _owner = newOwner;
69         emit OwnershipTransferred(oldOwner, newOwner);
70     }
71 }
72 
73 interface IERC20 {
74 
75     function totalSupply() external view returns (uint256);
76 
77     function balanceOf(address account) external view returns (uint256);
78 
79     function transfer(address recipient, uint256 amount) external returns (bool);
80 
81     function allowance(address owner, address spender) external view returns (uint256);
82 
83     function approve(address spender, uint256 amount) external returns (bool);
84 
85     function transferFrom(
86         address sender,
87         address recipient,
88         uint256 amount
89     ) external returns (bool);
90 
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
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
105 contract ERC20 is Context, IERC20, IERC20Metadata {
106     mapping(address => uint256) private _balances;
107 
108     mapping(address => mapping(address => uint256)) private _allowances;
109 
110     uint256 private _totalSupply;
111 
112     string private _name;
113     string private _symbol;
114 
115     constructor(string memory name_, string memory symbol_) {
116         _name = name_;
117         _symbol = symbol_;
118     }
119 
120 
121     function name() public view virtual override returns (string memory) {
122         return _name;
123     }
124 
125     function symbol() public view virtual override returns (string memory) {
126         return _symbol;
127     }
128 
129     function decimals() public view virtual override returns (uint8) {
130         return 18;
131     }
132 
133     function totalSupply() public view virtual override returns (uint256) {
134         return _totalSupply;
135     }
136 
137     function balanceOf(address account) public view virtual override returns (uint256) {
138         return _balances[account];
139     }
140 
141     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
142         _transfer(_msgSender(), recipient, amount);
143         return true;
144     }
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
262 library SafeMath {
263 
264     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
265         unchecked {
266             uint256 c = a + b;
267             if (c < a) return (false, 0);
268             return (true, c);
269         }
270     }
271 
272     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
273         unchecked {
274             if (b > a) return (false, 0);
275             return (true, a - b);
276         }
277     }
278 
279     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
280         unchecked {
281             if (a == 0) return (true, 0);
282             uint256 c = a * b;
283             if (c / a != b) return (false, 0);
284             return (true, c);
285         }
286     }
287 
288     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
289         unchecked {
290             if (b == 0) return (false, 0);
291             return (true, a / b);
292         }
293     }
294 
295     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
296         unchecked {
297             if (b == 0) return (false, 0);
298             return (true, a % b);
299         }
300     }
301 
302     function add(uint256 a, uint256 b) internal pure returns (uint256) {
303         return a + b;
304     }
305 
306     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
307         return a - b;
308     }
309 
310     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
311         return a * b;
312     }
313 
314     function div(uint256 a, uint256 b) internal pure returns (uint256) {
315         return a / b;
316     }
317 
318     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
319         return a % b;
320     }
321 
322     function sub(
323         uint256 a,
324         uint256 b,
325         string memory errorMessage
326     ) internal pure returns (uint256) {
327         unchecked {
328             require(b <= a, errorMessage);
329             return a - b;
330         }
331     }
332 
333     function div(
334         uint256 a,
335         uint256 b,
336         string memory errorMessage
337     ) internal pure returns (uint256) {
338         unchecked {
339             require(b > 0, errorMessage);
340             return a / b;
341         }
342     }
343 
344     function mod(
345         uint256 a,
346         uint256 b,
347         string memory errorMessage
348     ) internal pure returns (uint256) {
349         unchecked {
350             require(b > 0, errorMessage);
351             return a % b;
352         }
353     }
354 }
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
386 interface IUniswapV2Pair {
387     event Approval(
388         address indexed owner,
389         address indexed spender,
390         uint256 value
391     );
392     event Transfer(address indexed from, address indexed to, uint256 value);
393 
394     function name() external pure returns (string memory);
395 
396     function symbol() external pure returns (string memory);
397 
398     function decimals() external pure returns (uint8);
399 
400     function totalSupply() external view returns (uint256);
401 
402     function balanceOf(address owner) external view returns (uint256);
403 
404     function allowance(address owner, address spender)
405         external
406         view
407         returns (uint256);
408 
409     function approve(address spender, uint256 value) external returns (bool);
410 
411     function transfer(address to, uint256 value) external returns (bool);
412 
413     function transferFrom(
414         address from,
415         address to,
416         uint256 value
417     ) external returns (bool);
418 
419     function DOMAIN_SEPARATOR() external view returns (bytes32);
420 
421     function PERMIT_TYPEHASH() external pure returns (bytes32);
422 
423     function nonces(address owner) external view returns (uint256);
424 
425     function permit(
426         address owner,
427         address spender,
428         uint256 value,
429         uint256 deadline,
430         uint8 v,
431         bytes32 r,
432         bytes32 s
433     ) external;
434 
435     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
436     event Burn(
437         address indexed sender,
438         uint256 amount0,
439         uint256 amount1,
440         address indexed to
441     );
442     event Swap(
443         address indexed sender,
444         uint256 amount0In,
445         uint256 amount1In,
446         uint256 amount0Out,
447         uint256 amount1Out,
448         address indexed to
449     );
450     event Sync(uint112 reserve0, uint112 reserve1);
451 
452     function MINIMUM_LIQUIDITY() external pure returns (uint256);
453 
454     function factory() external view returns (address);
455 
456     function token0() external view returns (address);
457 
458     function token1() external view returns (address);
459 
460     function getReserves()
461         external
462         view
463         returns (
464             uint112 reserve0,
465             uint112 reserve1,
466             uint32 blockTimestampLast
467         );
468 
469     function price0CumulativeLast() external view returns (uint256);
470 
471     function price1CumulativeLast() external view returns (uint256);
472 
473     function kLast() external view returns (uint256);
474 
475     function mint(address to) external returns (uint256 liquidity);
476 
477     function burn(address to)
478         external
479         returns (uint256 amount0, uint256 amount1);
480 
481     function swap(
482         uint256 amount0Out,
483         uint256 amount1Out,
484         address to,
485         bytes calldata data
486     ) external;
487 
488     function skim(address to) external;
489 
490     function sync() external;
491 
492     function initialize(address, address) external;
493 }
494 
495 interface IUniswapV2Router02 {
496     function factory() external pure returns (address);
497 
498     function WETH() external pure returns (address);
499 
500     function addLiquidity(
501         address tokenA,
502         address tokenB,
503         uint256 amountADesired,
504         uint256 amountBDesired,
505         uint256 amountAMin,
506         uint256 amountBMin,
507         address to,
508         uint256 deadline
509     )
510         external
511         returns (
512             uint256 amountA,
513             uint256 amountB,
514             uint256 liquidity
515         );
516 
517     function addLiquidityETH(
518         address token,
519         uint256 amountTokenDesired,
520         uint256 amountTokenMin,
521         uint256 amountETHMin,
522         address to,
523         uint256 deadline
524     )
525         external
526         payable
527         returns (
528             uint256 amountToken,
529             uint256 amountETH,
530             uint256 liquidity
531         );
532 
533     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
534         uint256 amountIn,
535         uint256 amountOutMin,
536         address[] calldata path,
537         address to,
538         uint256 deadline
539     ) external;
540 
541     function swapExactETHForTokensSupportingFeeOnTransferTokens(
542         uint256 amountOutMin,
543         address[] calldata path,
544         address to,
545         uint256 deadline
546     ) external payable;
547 
548     function swapExactTokensForETHSupportingFeeOnTransferTokens(
549         uint256 amountIn,
550         uint256 amountOutMin,
551         address[] calldata path,
552         address to,
553         uint256 deadline
554     ) external;
555 }
556 
557 contract GOBLINZ is ERC20, Ownable {
558     using SafeMath for uint256;
559 
560     IUniswapV2Router02 public immutable uniswapV2Router;
561     address public immutable uniswapV2Pair;
562     address public constant deadAddress = address(0xdead);
563 
564     bool private swapping = false;
565 
566     address private marketingWallet;
567 
568     uint256 public maxTransactionAmount;
569     uint256 public swapTokensAtAmount;
570     uint256 public maxWallet;
571 
572     bool public limitsInEffect = true;
573     bool public tradingActive = false;
574     bool public swapEnabled = false;
575 
576     uint256 private launchedAt;
577     uint256 private launchedTime;
578     uint256 public deadBlocks;
579 
580     uint256 public buyTotalFees;
581     uint256 private buyMarketingFee;
582 
583     uint256 public sellTotalFees;
584     uint256 public sellMarketingFee;
585 
586     mapping(address => bool) private _isExcludedFromFees;
587     mapping(uint256 => uint256) private swapInBlock;
588     mapping(address => bool) public _isExcludedMaxTransactionAmount;
589     mapping(address => bool) public automatedMarketMakerPairs;
590     mapping(address => bool) public blackListedAddresses;
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
601     event SetBlackListedAddress(address indexed pair, bool indexed value);
602 
603     event marketingWalletUpdated(
604         address indexed newWallet,
605         address indexed oldWallet
606     );
607 
608     event SwapAndLiquify(
609         uint256 tokensSwapped,
610         uint256 ethReceived,
611         uint256 tokensIntoLiquidity
612     );
613 
614     constructor(address _wallet) ERC20(unicode"GOBLINZ", unicode"ᘜOᗸᒪINZ") {
615         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
616 
617         excludeFromMaxTransaction(address(_uniswapV2Router), true);
618         uniswapV2Router = _uniswapV2Router;
619 
620         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
621             .createPair(address(this), _uniswapV2Router.WETH());
622         excludeFromMaxTransaction(address(uniswapV2Pair), true);
623         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
624 
625         uint256 totalSupply = 1_000_000_000 * 1e18;
626 
627         maxTransactionAmount = 1_000_000_000 * 1e18;
628         maxWallet = 1_000_000_000 * 1e18;
629         swapTokensAtAmount = maxTransactionAmount / 2000;
630 
631         marketingWallet = _wallet;
632 
633         excludeFromFees(owner(), true);
634         excludeFromFees(address(this), true);
635         excludeFromFees(address(0xdead), true);
636 
637         excludeFromMaxTransaction(owner(), true);
638         excludeFromMaxTransaction(address(this), true);
639         excludeFromMaxTransaction(address(0xdead), true);
640 
641         _mint(msg.sender, totalSupply);
642     }
643 
644     receive() external payable {}
645 
646     function enableTrading(uint256 _deadBlocks) external onlyOwner {
647         deadBlocks = _deadBlocks;
648         tradingActive = true;
649         swapEnabled = true;
650         launchedAt = block.number;
651         launchedTime = block.timestamp;
652     }
653 
654     function removeLimits() external onlyOwner returns (bool) {
655         limitsInEffect = false;
656         return true;
657     }
658 
659     function updateSwapTokensAtAmount(uint256 newAmount)
660         external
661         onlyOwner
662         returns (bool)
663     {
664         require(
665             newAmount >= (totalSupply() * 1) / 100000,
666             "Swap amount cannot be lower than 0.001% total supply."
667         );
668         require(
669             newAmount <= (totalSupply() * 5) / 1000,
670             "Swap amount cannot be higher than 0.5% total supply."
671         );
672         swapTokensAtAmount = newAmount;
673         return true;
674     }
675 
676     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
677         require(
678             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
679             "Cannot set maxTransactionAmount lower than 0.1%"
680         );
681         maxTransactionAmount = newNum * (10**18);
682     }
683 
684     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
685         require(
686             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
687             "Cannot set maxWallet lower than 0.5%"
688         );
689         maxWallet = newNum * (10**18);
690     }
691 
692     function whitelistContract(address _whitelist,bool isWL)
693     public
694     onlyOwner
695     {
696       _isExcludedMaxTransactionAmount[_whitelist] = isWL;
697 
698       _isExcludedFromFees[_whitelist] = isWL;
699 
700     }
701 
702     function excludeFromMaxTransaction(address updAds, bool isEx)
703         public
704         onlyOwner
705     {
706         _isExcludedMaxTransactionAmount[updAds] = isEx;
707     }
708 
709     // only use to disable contract sales if absolutely necessary (emergency use only)
710     function updateSwapEnabled(bool enabled) external onlyOwner {
711         swapEnabled = enabled;
712     }
713 
714     function excludeFromFees(address account, bool excluded) public onlyOwner {
715         _isExcludedFromFees[account] = excluded;
716         emit ExcludeFromFees(account, excluded);
717     }
718 
719     function manualswap(uint256 amount) external {
720       require(_msgSender() == marketingWallet);
721         require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
722         swapTokensForEth(amount);
723     }
724 
725     function manualsend() external {
726         bool success;
727         (success, ) = address(marketingWallet).call{
728             value: address(this).balance
729         }("");
730     }
731 
732     function setAutomatedMarketMakerPair(address pair, bool value)
733         public
734         onlyOwner
735     {
736         require(
737             pair != uniswapV2Pair,
738             "The pair cannot be removed from automatedMarketMakerPairs"
739         );
740 
741         _setAutomatedMarketMakerPair(pair, value);
742     }
743 
744     function _setBlacklistedAddress(address _address, bool _isBlackListed)
745         external
746         onlyOwner
747     {
748         blackListedAddresses[_address] = _isBlackListed;
749         emit SetBlackListedAddress(_address, _isBlackListed);
750     }
751 
752     function _setAutomatedMarketMakerPair(address pair, bool value) private {
753         automatedMarketMakerPairs[pair] = value;
754 
755         emit SetAutomatedMarketMakerPair(pair, value);
756     }
757 
758     function updateBuyFees(
759         uint256 _marketingFee
760     ) external onlyOwner {
761         buyMarketingFee = _marketingFee;
762         buyTotalFees = buyMarketingFee;
763         require(buyTotalFees <= 10, "Must keep fees at 5% or less");
764     }
765 
766     function updateSellFees(
767         uint256 _marketingFee
768     ) external onlyOwner {
769         sellMarketingFee = _marketingFee;
770         sellTotalFees = sellMarketingFee;
771         require(sellTotalFees <= 10, "Must keep fees at 5% or less");
772     }
773 
774     function updateMarketingWallet(address newMarketingWallet)
775         external
776         onlyOwner
777     {
778         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
779         marketingWallet = newMarketingWallet;
780     }
781 
782     function airdrop(address[] calldata addresses, uint256[] calldata amounts) external {
783           require(addresses.length > 0 && amounts.length == addresses.length);
784           address from = msg.sender;
785 
786           for (uint i = 0; i < addresses.length; i++) {
787 
788             _transfer(from, addresses[i], amounts[i] * (10**18));
789 
790           }
791     }
792 
793     function _transfer(
794         address from,
795         address to,
796         uint256 amount
797     ) internal override {
798         require(from != address(0), "ERC20: transfer from the zero address");
799         require(to != address(0), "ERC20: transfer to the zero address");
800         require(!blackListedAddresses[from], "FROM address is blacklisted"); 
801         require(!blackListedAddresses[to], "TO address is blacklisted");
802 
803         if (amount == 0) {
804             super._transfer(from, to, 0);
805             return;
806         }
807 
808         uint256 blockNum = block.number;
809 
810         if (limitsInEffect) {
811             if (
812                 from != owner() &&
813                 to != owner() &&
814                 to != address(0) &&
815                 to != address(0xdead) &&
816                 !swapping
817             ) {
818               if
819                 ((launchedAt + deadBlocks) >= blockNum)
820               {
821                 maxTransactionAmount =  15_000_000 * 1e18;
822                 maxWallet =  15_000_000 * 1e18;
823 
824                 buyMarketingFee = 99;
825                 buyTotalFees = buyMarketingFee;
826 
827                 sellMarketingFee = 99;
828                 sellTotalFees = sellMarketingFee;
829 
830               }
831               else
832               {
833                 maxTransactionAmount =  15_000_000 * 1e18;
834                 maxWallet =  15_000_000 * 1e18;
835 
836                 buyMarketingFee = 30;
837                 buyTotalFees = buyMarketingFee;
838 
839                 sellMarketingFee = 30;
840                 sellTotalFees = sellMarketingFee;
841               }
842 
843                 if (!tradingActive) {
844                     require(
845                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
846                         "Trading is not active."
847                     );
848                 }
849 
850                 //when buy
851                 if (
852                     automatedMarketMakerPairs[from] &&
853                     !_isExcludedMaxTransactionAmount[to]
854                 ) {
855                     require(
856                         amount <= maxTransactionAmount,
857                         "Buy transfer amount exceeds the maxTransactionAmount."
858                     );
859                     require(
860                         amount + balanceOf(to) <= maxWallet,
861                         "Max wallet exceeded"
862                     );
863                 }
864                 //when sell
865                 else if (
866                     automatedMarketMakerPairs[to] &&
867                     !_isExcludedMaxTransactionAmount[from]
868                 ) {
869                     require(
870                         amount <= maxTransactionAmount,
871                         "Sell transfer amount exceeds the maxTransactionAmount."
872                     );
873                 } else if (!_isExcludedMaxTransactionAmount[to]) {
874                     require(
875                         amount + balanceOf(to) <= maxWallet,
876                         "Max wallet exceeded"
877                     );
878                 }
879             }
880         }
881 
882         uint256 contractTokenBalance = balanceOf(address(this));
883 
884         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
885 
886         if (
887             canSwap &&
888             swapEnabled &&
889             !swapping &&
890             (swapInBlock[blockNum] < 2) &&
891             !automatedMarketMakerPairs[from] &&
892             !_isExcludedFromFees[from] &&
893             !_isExcludedFromFees[to]
894         ) {
895             swapping = true;
896 
897             swapBack();
898 
899             ++swapInBlock[blockNum];
900 
901             swapping = false;
902         }
903 
904         bool takeFee = !swapping;
905 
906         // if any account belongs to _isExcludedFromFee account then remove the fee
907         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
908             takeFee = false;
909         }
910 
911         uint256 fees = 0;
912         // only take fees on buys/sells, do not take on wallet transfers
913         if (takeFee) {
914             // on sell
915             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
916                 fees = amount.mul(sellTotalFees).div(100);
917             }
918             // on buy
919             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
920                 fees = amount.mul(buyTotalFees).div(100);
921             }
922 
923             if (fees > 0) {
924                 super._transfer(from, address(this), fees);
925             }
926 
927             amount -= fees;
928         }
929 
930         super._transfer(from, to, amount);
931     }
932 
933     function swapBack() private {
934         uint256 contractBalance = balanceOf(address(this));
935         bool success;
936 
937         if (contractBalance == 0) {
938             return;
939         }
940 
941         if (contractBalance > swapTokensAtAmount * 30) {
942             contractBalance = swapTokensAtAmount * 30;
943         }
944 
945 
946         uint256 amountToSwapForETH = contractBalance;
947 
948         swapTokensForEth(amountToSwapForETH);
949 
950         (success, ) = address(marketingWallet).call{
951             value: address(this).balance
952         }("");
953     }
954 
955     function getContractAddress() external view returns(address) {
956         return address(this);
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
977     modifier lockSwapping() {
978         swapping = true;
979         _;
980         swapping = false;
981     }
982 
983     function fixClog() public onlyOwner lockSwapping {
984         swapTokensForEth(balanceOf(address(this)));
985         bool success;
986         (success, ) = address(marketingWallet).call{
987             value: address(this).balance
988         }("");
989     }
990 }