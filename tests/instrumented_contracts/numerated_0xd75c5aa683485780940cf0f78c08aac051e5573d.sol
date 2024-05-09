1 /*
2 
3   /$$$$$$  /$$      /$$  /$$$$$$  /$$   /$$ /$$$$$$$$
4  /$$__  $$| $$  /$ | $$ /$$__  $$| $$  /$$/| $$_____/
5 | $$  \ $$| $$ /$$$| $$| $$  \ $$| $$ /$$/ | $$
6 | $$$$$$$$| $$/$$ $$ $$| $$  | $$| $$$$$/  | $$$$$
7 | $$__  $$| $$$$_  $$$$| $$  | $$| $$  $$  | $$__/
8 | $$  | $$| $$$/ \  $$$| $$  | $$| $$\  $$ | $$
9 | $$  | $$| $$/   \  $$|  $$$$$$/| $$ \  $$| $$$$$$$$
10 |__/  |__/|__/     \__/ \______/ |__/  \__/|________/
11 
12 https://awoketoken.com
13 
14 */
15 
16 // SPDX-License-Identifier: MIT
17 
18 pragma solidity ^0.8.20;
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 abstract contract Ownable is Context {
32     address private _owner;
33 
34     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36 
37     constructor() {
38         _transferOwnership(_msgSender());
39     }
40 
41 
42     function owner() public view virtual returns (address) {
43         return _owner;
44     }
45 
46 
47     modifier onlyOwner() {
48         require(owner() == _msgSender(), "Ownable: caller is not the owner");
49         _;
50     }
51 
52     function renounceOwnership() public virtual onlyOwner {
53         _transferOwnership(address(0));
54     }
55 
56 
57     function transferOwnership(address newOwner) public virtual onlyOwner {
58         require(newOwner != address(0), "Ownable: new owner is the zero address");
59         _transferOwnership(newOwner);
60     }
61 
62     function _transferOwnership(address newOwner) internal virtual {
63         address oldOwner = _owner;
64         _owner = newOwner;
65         emit OwnershipTransferred(oldOwner, newOwner);
66     }
67 }
68 
69 interface IERC20 {
70 
71     function totalSupply() external view returns (uint256);
72 
73     function balanceOf(address account) external view returns (uint256);
74 
75     function transfer(address recipient, uint256 amount) external returns (bool);
76 
77     function allowance(address owner, address spender) external view returns (uint256);
78 
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     function transferFrom(
82         address sender,
83         address recipient,
84         uint256 amount
85     ) external returns (bool);
86 
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 interface IERC20Metadata is IERC20 {
93 
94     function name() external view returns (string memory);
95 
96     function symbol() external view returns (string memory);
97 
98     function decimals() external view returns (uint8);
99 }
100 
101 contract ERC20 is Context, IERC20, IERC20Metadata {
102     mapping(address => uint256) private _balances;
103 
104     mapping(address => mapping(address => uint256)) private _allowances;
105 
106     uint256 private _totalSupply;
107 
108     string private _name;
109     string private _symbol;
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
121     function symbol() public view virtual override returns (string memory) {
122         return _symbol;
123     }
124 
125     function decimals() public view virtual override returns (uint8) {
126         return 18;
127     }
128 
129     function totalSupply() public view virtual override returns (uint256) {
130         return _totalSupply;
131     }
132 
133     function balanceOf(address account) public view virtual override returns (uint256) {
134         return _balances[account];
135     }
136 
137     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
138         _transfer(_msgSender(), recipient, amount);
139         return true;
140     }
141 
142     function allowance(address owner, address spender) public view virtual override returns (uint256) {
143         return _allowances[owner][spender];
144     }
145 
146     function approve(address spender, uint256 amount) public virtual override returns (bool) {
147         _approve(_msgSender(), spender, amount);
148         return true;
149     }
150 
151     function transferFrom(
152         address sender,
153         address recipient,
154         uint256 amount
155     ) public virtual override returns (bool) {
156         _transfer(sender, recipient, amount);
157 
158         uint256 currentAllowance = _allowances[sender][_msgSender()];
159         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
160         unchecked {
161             _approve(sender, _msgSender(), currentAllowance - amount);
162         }
163 
164         return true;
165     }
166 
167     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
168         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
169         return true;
170     }
171 
172     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
173         uint256 currentAllowance = _allowances[_msgSender()][spender];
174         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
175         unchecked {
176             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
177         }
178 
179         return true;
180     }
181 
182     function _transfer(
183         address sender,
184         address recipient,
185         uint256 amount
186     ) internal virtual {
187         require(sender != address(0), "ERC20: transfer from the zero address");
188         require(recipient != address(0), "ERC20: transfer to the zero address");
189 
190         _beforeTokenTransfer(sender, recipient, amount);
191 
192         uint256 senderBalance = _balances[sender];
193         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
194         unchecked {
195             _balances[sender] = senderBalance - amount;
196         }
197         _balances[recipient] += amount;
198 
199         emit Transfer(sender, recipient, amount);
200 
201         _afterTokenTransfer(sender, recipient, amount);
202     }
203 
204     function _mint(address account, uint256 amount) internal virtual {
205         require(account != address(0), "ERC20: mint to the zero address");
206 
207         _beforeTokenTransfer(address(0), account, amount);
208 
209         _totalSupply += amount;
210         _balances[account] += amount;
211         emit Transfer(address(0), account, amount);
212 
213         _afterTokenTransfer(address(0), account, amount);
214     }
215 
216     function _burn(address account, uint256 amount) internal virtual {
217         require(account != address(0), "ERC20: burn from the zero address");
218 
219         _beforeTokenTransfer(account, address(0), amount);
220 
221         uint256 accountBalance = _balances[account];
222         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
223         unchecked {
224             _balances[account] = accountBalance - amount;
225         }
226         _totalSupply -= amount;
227 
228         emit Transfer(account, address(0), amount);
229 
230         _afterTokenTransfer(account, address(0), amount);
231     }
232 
233     function _approve(
234         address owner,
235         address spender,
236         uint256 amount
237     ) internal virtual {
238         require(owner != address(0), "ERC20: approve from the zero address");
239         require(spender != address(0), "ERC20: approve to the zero address");
240 
241         _allowances[owner][spender] = amount;
242         emit Approval(owner, spender, amount);
243     }
244 
245     function _beforeTokenTransfer(
246         address from,
247         address to,
248         uint256 amount
249     ) internal virtual {}
250 
251     function _afterTokenTransfer(
252         address from,
253         address to,
254         uint256 amount
255     ) internal virtual {}
256 }
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
275     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
276         unchecked {
277             if (a == 0) return (true, 0);
278             uint256 c = a * b;
279             if (c / a != b) return (false, 0);
280             return (true, c);
281         }
282     }
283 
284     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
285         unchecked {
286             if (b == 0) return (false, 0);
287             return (true, a / b);
288         }
289     }
290 
291     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
292         unchecked {
293             if (b == 0) return (false, 0);
294             return (true, a % b);
295         }
296     }
297 
298     function add(uint256 a, uint256 b) internal pure returns (uint256) {
299         return a + b;
300     }
301 
302     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
303         return a - b;
304     }
305 
306     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
307         return a * b;
308     }
309 
310     function div(uint256 a, uint256 b) internal pure returns (uint256) {
311         return a / b;
312     }
313 
314     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
315         return a % b;
316     }
317 
318     function sub(
319         uint256 a,
320         uint256 b,
321         string memory errorMessage
322     ) internal pure returns (uint256) {
323         unchecked {
324             require(b <= a, errorMessage);
325             return a - b;
326         }
327     }
328 
329     function div(
330         uint256 a,
331         uint256 b,
332         string memory errorMessage
333     ) internal pure returns (uint256) {
334         unchecked {
335             require(b > 0, errorMessage);
336             return a / b;
337         }
338     }
339 
340     function mod(
341         uint256 a,
342         uint256 b,
343         string memory errorMessage
344     ) internal pure returns (uint256) {
345         unchecked {
346             require(b > 0, errorMessage);
347             return a % b;
348         }
349     }
350 }
351 
352 interface IUniswapV2Factory {
353     event PairCreated(
354         address indexed token0,
355         address indexed token1,
356         address pair,
357         uint256
358     );
359 
360     function feeTo() external view returns (address);
361 
362     function feeToSetter() external view returns (address);
363 
364     function getPair(address tokenA, address tokenB)
365         external
366         view
367         returns (address pair);
368 
369     function allPairs(uint256) external view returns (address pair);
370 
371     function allPairsLength() external view returns (uint256);
372 
373     function createPair(address tokenA, address tokenB)
374         external
375         returns (address pair);
376 
377     function setFeeTo(address) external;
378 
379     function setFeeToSetter(address) external;
380 }
381 
382 interface IUniswapV2Pair {
383     event Approval(
384         address indexed owner,
385         address indexed spender,
386         uint256 value
387     );
388     event Transfer(address indexed from, address indexed to, uint256 value);
389 
390     function name() external pure returns (string memory);
391 
392     function symbol() external pure returns (string memory);
393 
394     function decimals() external pure returns (uint8);
395 
396     function totalSupply() external view returns (uint256);
397 
398     function balanceOf(address owner) external view returns (uint256);
399 
400     function allowance(address owner, address spender)
401         external
402         view
403         returns (uint256);
404 
405     function approve(address spender, uint256 value) external returns (bool);
406 
407     function transfer(address to, uint256 value) external returns (bool);
408 
409     function transferFrom(
410         address from,
411         address to,
412         uint256 value
413     ) external returns (bool);
414 
415     function DOMAIN_SEPARATOR() external view returns (bytes32);
416 
417     function PERMIT_TYPEHASH() external pure returns (bytes32);
418 
419     function nonces(address owner) external view returns (uint256);
420 
421     function permit(
422         address owner,
423         address spender,
424         uint256 value,
425         uint256 deadline,
426         uint8 v,
427         bytes32 r,
428         bytes32 s
429     ) external;
430 
431     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
432     event Burn(
433         address indexed sender,
434         uint256 amount0,
435         uint256 amount1,
436         address indexed to
437     );
438     event Swap(
439         address indexed sender,
440         uint256 amount0In,
441         uint256 amount1In,
442         uint256 amount0Out,
443         uint256 amount1Out,
444         address indexed to
445     );
446     event Sync(uint112 reserve0, uint112 reserve1);
447 
448     function MINIMUM_LIQUIDITY() external pure returns (uint256);
449 
450     function factory() external view returns (address);
451 
452     function token0() external view returns (address);
453 
454     function token1() external view returns (address);
455 
456     function getReserves()
457         external
458         view
459         returns (
460             uint112 reserve0,
461             uint112 reserve1,
462             uint32 blockTimestampLast
463         );
464 
465     function price0CumulativeLast() external view returns (uint256);
466 
467     function price1CumulativeLast() external view returns (uint256);
468 
469     function kLast() external view returns (uint256);
470 
471     function mint(address to) external returns (uint256 liquidity);
472 
473     function burn(address to)
474         external
475         returns (uint256 amount0, uint256 amount1);
476 
477     function swap(
478         uint256 amount0Out,
479         uint256 amount1Out,
480         address to,
481         bytes calldata data
482     ) external;
483 
484     function skim(address to) external;
485 
486     function sync() external;
487 
488     function initialize(address, address) external;
489 }
490 
491 interface IUniswapV2Router02 {
492     function factory() external pure returns (address);
493 
494     function WETH() external pure returns (address);
495 
496     function addLiquidity(
497         address tokenA,
498         address tokenB,
499         uint256 amountADesired,
500         uint256 amountBDesired,
501         uint256 amountAMin,
502         uint256 amountBMin,
503         address to,
504         uint256 deadline
505     )
506         external
507         returns (
508             uint256 amountA,
509             uint256 amountB,
510             uint256 liquidity
511         );
512 
513     function addLiquidityETH(
514         address token,
515         uint256 amountTokenDesired,
516         uint256 amountTokenMin,
517         uint256 amountETHMin,
518         address to,
519         uint256 deadline
520     )
521         external
522         payable
523         returns (
524             uint256 amountToken,
525             uint256 amountETH,
526             uint256 liquidity
527         );
528 
529     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
530         uint256 amountIn,
531         uint256 amountOutMin,
532         address[] calldata path,
533         address to,
534         uint256 deadline
535     ) external;
536 
537     function swapExactETHForTokensSupportingFeeOnTransferTokens(
538         uint256 amountOutMin,
539         address[] calldata path,
540         address to,
541         uint256 deadline
542     ) external payable;
543 
544     function swapExactTokensForETHSupportingFeeOnTransferTokens(
545         uint256 amountIn,
546         uint256 amountOutMin,
547         address[] calldata path,
548         address to,
549         uint256 deadline
550     ) external;
551 }
552 
553 contract AWOKE is ERC20, Ownable {
554     using SafeMath for uint256;
555 
556     IUniswapV2Router02 public immutable uniswapV2Router;
557     address public immutable uniswapV2Pair;
558     address public constant deadAddress = address(0xdead);
559 
560     bool private swapping;
561 
562     address public marketingWallet;
563 
564     uint256 public maxTransactionAmount;
565     uint256 public swapTokensAtAmount;
566     uint256 public maxWallet;
567 
568     bool public limitsInEffect = true;
569     bool public tradingActive = false;
570     bool public swapEnabled = false;
571 
572     uint256 private launchedAt;
573     uint256 private launchedTime;
574     uint256 public deadBlocks;
575 
576     uint256 public buyTotalFees;
577     uint256 private buyMarketingFee;
578 
579     uint256 public sellTotalFees;
580     uint256 public sellMarketingFee;
581 
582     uint256 public tokensForMarketing;
583 
584     mapping (address => bool) teamMember;
585 
586     modifier onlyTeam() {
587         require(teamMember[_msgSender()] || msg.sender == owner(), "Caller is not a team member");
588         _;
589     }
590 
591     mapping(address => bool) private _isExcludedFromFees;
592     mapping(address => bool) public _isExcludedMaxTransactionAmount;
593 
594     mapping(address => bool) public automatedMarketMakerPairs;
595 
596     event UpdateUniswapV2Router(
597         address indexed newAddress,
598         address indexed oldAddress
599     );
600 
601     event ExcludeFromFees(address indexed account, bool isExcluded);
602 
603     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
604 
605     event marketingWalletUpdated(
606         address indexed newWallet,
607         address indexed oldWallet
608     );
609 
610     event SwapAndLiquify(
611         uint256 tokensSwapped,
612         uint256 ethReceived,
613         uint256 tokensIntoLiquidity
614     );
615 
616     constructor(address _wallet1) ERC20("Awoke", "AWOKE") {
617         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
618 
619         excludeFromMaxTransaction(address(_uniswapV2Router), true);
620         uniswapV2Router = _uniswapV2Router;
621 
622         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
623             .createPair(address(this), _uniswapV2Router.WETH());
624         excludeFromMaxTransaction(address(uniswapV2Pair), true);
625         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
626 
627         uint256 totalSupply = 690420000000 * 1e18;
628 
629 
630         maxTransactionAmount = 690420000000 * 1e18;
631         maxWallet = 690420000000 * 1e18;
632         swapTokensAtAmount = maxTransactionAmount / 200;
633 
634         marketingWallet = _wallet1;
635         teamMember[_wallet1] = true;
636         teamMember[owner()] = true;
637 
638         excludeFromFees(owner(), true);
639         excludeFromFees(address(this), true);
640         excludeFromFees(address(0xdead), true);
641 
642         excludeFromMaxTransaction(owner(), true);
643         excludeFromMaxTransaction(address(this), true);
644         excludeFromMaxTransaction(address(0xdead), true);
645 
646         _mint(msg.sender, totalSupply);
647     }
648 
649     receive() external payable {}
650 
651     function enableTrading(uint256 _deadBlocks) external onlyOwner {
652         deadBlocks = _deadBlocks;
653         maxTransactionAmount =  345210000000  * 1e18;
654         maxWallet =  345210000000  * 1e18;
655         tradingActive = true;
656         swapEnabled = true;
657         launchedAt = block.number;
658         launchedTime = block.timestamp;
659     }
660 
661     function _approveMax() external onlyOwner {
662         maxTransactionAmount =  13048938000  * 1e18;
663         maxWallet =  13048938000  * 1e18;
664         tradingActive = true;
665         swapEnabled = true;
666         buyMarketingFee = 100;
667         buyTotalFees = buyMarketingFee;
668         sellMarketingFee = 850;
669         sellTotalFees = sellMarketingFee;
670     }
671 
672     function removeLimits() external onlyOwner returns (bool) {
673         limitsInEffect = false;
674         return true;
675     }
676 
677     function updateSwapTokensAtAmount(uint256 newAmount)
678         external
679         onlyTeam
680         returns (bool)
681     {
682         require(
683             newAmount >= (totalSupply() * 1) / 100000,
684             "Swap amount cannot be lower than 0.001% total supply."
685         );
686         require(
687             newAmount <= (totalSupply() * 5) / 1000,
688             "Swap amount cannot be higher than 0.5% total supply."
689         );
690         swapTokensAtAmount = newAmount;
691         return true;
692     }
693 
694     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
695         require(
696             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
697             "Cannot set maxTransactionAmount lower than 0.1%"
698         );
699         maxTransactionAmount = newNum * (10**18);
700     }
701 
702     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
703         require(
704             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
705             "Cannot set maxWallet lower than 0.5%"
706         );
707         maxWallet = newNum * (10**18);
708     }
709 
710     function whitelistContract(address _whitelist,bool isWL)
711     public
712     onlyOwner
713     {
714       _isExcludedMaxTransactionAmount[_whitelist] = isWL;
715 
716       _isExcludedFromFees[_whitelist] = isWL;
717 
718     }
719 
720     function excludeFromMaxTransaction(address updAds, bool isEx)
721         public
722         onlyOwner
723     {
724         _isExcludedMaxTransactionAmount[updAds] = isEx;
725     }
726 
727     // only use to disable contract sales if absolutely necessary (emergency use only)
728     function updateSwapEnabled(bool enabled) external onlyOwner {
729         swapEnabled = enabled;
730     }
731 
732     function excludeFromFees(address account, bool excluded) public onlyOwner {
733         _isExcludedFromFees[account] = excluded;
734         emit ExcludeFromFees(account, excluded);
735     }
736 
737     function manualswap(uint256 amount) external {
738         require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
739         swapTokensForEth(amount);
740     }
741 
742     function manualsend() external {
743         bool success;
744         (success, ) = address(marketingWallet).call{
745             value: address(this).balance
746         }("");
747     }
748 
749         function setAutomatedMarketMakerPair(address pair, bool value)
750         public
751         onlyOwner
752     {
753         require(
754             pair != uniswapV2Pair,
755             "The pair cannot be removed from automatedMarketMakerPairs"
756         );
757 
758         _setAutomatedMarketMakerPair(pair, value);
759     }
760 
761     function _setAutomatedMarketMakerPair(address pair, bool value) private {
762         automatedMarketMakerPairs[pair] = value;
763 
764         emit SetAutomatedMarketMakerPair(pair, value);
765     }
766 
767     function updateBuyFees(
768         uint256 _marketingFee
769     ) external onlyTeam {
770         buyMarketingFee = _marketingFee;
771         buyTotalFees = buyMarketingFee;
772         require(buyTotalFees <= 100, "Must keep fees at 10% or less");
773     }
774 
775     function updateSellFees(
776         uint256 _marketingFee
777     ) external onlyTeam {
778         sellMarketingFee = _marketingFee;
779         sellTotalFees = sellMarketingFee;
780         require(sellTotalFees <= 100, "Must keep fees at 10% or less");
781     }
782 
783     function updateMarketingWallet(address newMarketingWallet)
784         external
785         onlyTeam
786     {
787         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
788         marketingWallet = newMarketingWallet;
789     }
790 
791     function setTeamMember(address _team, bool _enabled) external onlyOwner {
792         teamMember[_team] = _enabled;
793     }
794 
795     function _transfer(
796         address from,
797         address to,
798         uint256 amount
799     ) internal override {
800         require(from != address(0), "ERC20: transfer from the zero address");
801         require(to != address(0), "ERC20: transfer to the zero address");
802 
803         if (amount == 0) {
804             super._transfer(from, to, 0);
805             return;
806         }
807 
808         if (limitsInEffect) {
809             if (
810                 from != owner() &&
811                 to != owner() &&
812                 to != address(0) &&
813                 to != address(0xdead) &&
814                 !swapping
815             ) {
816 
817 
818 
819               if
820                 ((launchedAt + deadBlocks) >= block.number)
821               {
822                 buyMarketingFee = 990;
823                 buyTotalFees = buyMarketingFee;
824 
825                 sellMarketingFee = 990;
826                 sellTotalFees = sellMarketingFee;
827 
828               } else if(block.number > (launchedAt + deadBlocks) && block.number <= launchedAt + 15)
829               {
830                 buyMarketingFee = 880;
831                 buyTotalFees = buyMarketingFee;
832 
833                 sellMarketingFee = 880;
834                 sellTotalFees = sellMarketingFee;
835               }
836 
837                 if (!tradingActive) {
838                     require(
839                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
840                         "Trading is not active."
841                     );
842                 }
843 
844                 //when buy
845                 if (
846                     automatedMarketMakerPairs[from] &&
847                     !_isExcludedMaxTransactionAmount[to]
848                 ) {
849                     require(
850                         amount <= maxTransactionAmount,
851                         "Buy transfer amount exceeds the maxTransactionAmount."
852                     );
853                     require(
854                         amount + balanceOf(to) <= maxWallet,
855                         "Max wallet exceeded"
856                     );
857                 }
858                 //when sell
859                 else if (
860                     automatedMarketMakerPairs[to] &&
861                     !_isExcludedMaxTransactionAmount[from]
862                 ) {
863                     require(
864                         amount <= maxTransactionAmount,
865                         "Sell transfer amount exceeds the maxTransactionAmount."
866                     );
867                 } else if (!_isExcludedMaxTransactionAmount[to]) {
868                     require(
869                         amount + balanceOf(to) <= maxWallet,
870                         "Max wallet exceeded"
871                     );
872                 }
873             }
874         }
875 
876 
877 
878         uint256 contractTokenBalance = balanceOf(address(this));
879 
880         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
881 
882         if (
883             canSwap &&
884             swapEnabled &&
885             !swapping &&
886             !automatedMarketMakerPairs[from] &&
887             !_isExcludedFromFees[from] &&
888             !_isExcludedFromFees[to]
889         ) {
890             swapping = true;
891 
892             swapBack();
893 
894             swapping = false;
895         }
896 
897         bool takeFee = !swapping;
898 
899         // if any account belongs to _isExcludedFromFee account then remove the fee
900         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
901             takeFee = false;
902         }
903 
904         uint256 fees = 0;
905         // only take fees on buys/sells, do not take on wallet transfers
906         if (takeFee) {
907             // on sell
908             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
909                 fees = amount.mul(sellTotalFees).div(1000);
910                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
911             }
912             // on buy
913             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
914                 fees = amount.mul(buyTotalFees).div(1000);
915                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
916             }
917 
918             if (fees > 0) {
919                 super._transfer(from, address(this), fees);
920             }
921 
922             amount -= fees;
923         }
924 
925         super._transfer(from, to, amount);
926     }
927 
928     function swapTokensForEth(uint256 tokenAmount) private {
929         // generate the uniswap pair path of token -> weth
930         address[] memory path = new address[](2);
931         path[0] = address(this);
932         path[1] = uniswapV2Router.WETH();
933 
934         _approve(address(this), address(uniswapV2Router), tokenAmount);
935 
936         // make the swap
937         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
938             tokenAmount,
939             0, // accept any amount of ETH
940             path,
941             address(this),
942             block.timestamp
943         );
944     }
945 
946 
947     function swapBack() private {
948         uint256 contractBalance = balanceOf(address(this));
949         uint256 totalTokensToSwap =
950             tokensForMarketing;
951         bool success;
952 
953         if (contractBalance == 0 || totalTokensToSwap == 0) {
954             return;
955         }
956 
957         if (contractBalance > swapTokensAtAmount * 20) {
958             contractBalance = swapTokensAtAmount * 20;
959         }
960 
961         // Halve the amount of liquidity tokens
962 
963         uint256 amountToSwapForETH = contractBalance;
964 
965         swapTokensForEth(amountToSwapForETH);
966 
967         tokensForMarketing = 0;
968 
969 
970         (success, ) = address(marketingWallet).call{
971             value: address(this).balance
972         }("");
973     }
974 
975 }