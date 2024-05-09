1 /*
2          
3 Telegram: http://t.me/calciumpepecoin
4 X: https://twitter.com/calciumpepecoin
5 Web: https://www.calciumpepe.xyz
6                                                                                                     
7                                                                                                     
8              ..::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::..             
9             :##GGGGGPGGGGPPGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG##:            
10             :@G    .:.   :.                                                          P@:            
11             :@G   ?J!P!.57JY                                                         P@:            
12             :@G   : ~P^7B .#^                                                        P@:            
13             :@G   ~P5~:~B~7B.      .:^^~^^:.                                         P@:            
14             :@G   ^!^~^ :~~:   :75B&@@@@@@&#GY!.                                     P@:            
15             :@G              :5&@@@@@@@@@@@@@@@#?                                    P@:            
16             :@G             7&@@@@@P7~^^^~?B@@@@@G.                                  P@:            
17             :@G            !@@@@@#~         Y@@@@@P       :!?J555YJ7~.               P@:            
18             :@G           .#@@@@@!          :PPPPPP.   .?B&@@@@@@@@@@&5^             P@:            
19             :@G           ~@@@@@#.                    ^#@@@@@P?7?5&@@@@@!            P@:            
20             :@G           7@@@@@#.                    !P5555!     ~@@@@@G            P@:            
21             :@G           !@@@@@#.                        .:~!77?7J&@@@@B.           P@:            
22             :@G           ~@@@@@#.                     :JG&@@@@@@@@@@@@@B.           P@:            
23             :@G           .B@@@@@7          :PPPPPP.  7&@@@@BJ!~^^!&@@@@B.           P@:            
24             :@G            !@@@@@&~        .P@@@@@P  .#@@@@#.     :&@@@@B.           P@:            
25             :@G             !&@@@@@P?!~~!7Y#@@@@@P.  .#@@@@&J:::^7G@@@@@B.           P@:            
26             :@G              :Y#@@@@@@@@@@@@@@@B7     ~#@@@@@@&&@@@@@@@@&:           P@:            
27             :@G                .!YG##&@@&&#B5?^        .7PB&&@@&B5~J#####?           P@:            
28             :@G                     .::::..                .:::.    .   ..           P@:            
29             :@G                                                                      P@:            
30             :@G                                                                      P@:            
31             :@G                  .~~^.      ^^      ^.                               P@:            
32             :@G                 ^5~:!J :~~~ 7J ^!!^ ?:^^ :~ !~!!~!!.                 P@:            
33             :@G                 ?Y   : 77!B:7J^P..!.P^J? ~5.G^:G!.57                 P@:            
34             :@G                 :Y!^7?.57!G^!?:5~~7.5^!Y^?Y.5. 5^ ?7                 P@:            
35             :@G                   :::  .::. ..  ::. .  ::.. .  .  ..                 P@:            
36             :@G                                                                      P@:            
37             :@G                         7Y. ?!77    77!?.:?!7!                       P@:            
38             :@G                       :?7G.!5  B^  ^G  Y!^P~JJ                       P@:            
39             :@G                      .Y?!B!!5 .G^  :G. 5!7Y:75                       P@:            
40             :@G                         .?. !77! ~~ ~7!7 :7!7~                       P@:            
41             :@G                                                                      P@:            
42             :@&JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ#@:            
43             .!!7777777777777777777777777777777777777777777777777777777777777777777777!!.            
44                                                                                                    
45 */
46 
47 // SPDX-License-Identifier: UNLICENSED
48 
49 pragma solidity ^0.8.21;
50 
51 abstract contract Context {
52     function _msgSender() internal view virtual returns (address) {
53         return msg.sender;
54     }
55 
56     function _msgData() internal view virtual returns (bytes calldata) {
57         return msg.data;
58     }
59 }
60 
61 
62 abstract contract Ownable is Context {
63     address private _owner;
64 
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67 
68     constructor() {
69         _transferOwnership(_msgSender());
70     }
71 
72 
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77 
78     modifier onlyOwner() {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80         _;
81     }
82 
83     function renounceOwnership() public virtual onlyOwner {
84         _transferOwnership(address(0));
85     }
86 
87 
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _transferOwnership(newOwner);
91     }
92 
93     function _transferOwnership(address newOwner) internal virtual {
94         address oldOwner = _owner;
95         _owner = newOwner;
96         emit OwnershipTransferred(oldOwner, newOwner);
97     }
98 }
99 
100 interface IERC20 {
101 
102     function totalSupply() external view returns (uint256);
103 
104     function balanceOf(address account) external view returns (uint256);
105 
106     function transfer(address recipient, uint256 amount) external returns (bool);
107 
108     function allowance(address owner, address spender) external view returns (uint256);
109 
110     function approve(address spender, uint256 amount) external returns (bool);
111 
112     function transferFrom(
113         address sender,
114         address recipient,
115         uint256 amount
116     ) external returns (bool);
117 
118     event Transfer(address indexed from, address indexed to, uint256 value);
119 
120     event Approval(address indexed owner, address indexed spender, uint256 value);
121 }
122 
123 interface IERC20Metadata is IERC20 {
124 
125     function name() external view returns (string memory);
126 
127     function symbol() external view returns (string memory);
128 
129     function decimals() external view returns (uint8);
130 }
131 
132 contract ERC20 is Context, IERC20, IERC20Metadata {
133     mapping(address => uint256) private _balances;
134 
135     mapping(address => mapping(address => uint256)) private _allowances;
136 
137     uint256 private _totalSupply;
138 
139     string private _name;
140     string private _symbol;
141 
142     constructor(string memory name_, string memory symbol_) {
143         _name = name_;
144         _symbol = symbol_;
145     }
146 
147 
148     function name() public view virtual override returns (string memory) {
149         return _name;
150     }
151 
152     function symbol() public view virtual override returns (string memory) {
153         return _symbol;
154     }
155 
156     function decimals() public view virtual override returns (uint8) {
157         return 18;
158     }
159 
160     function totalSupply() public view virtual override returns (uint256) {
161         return _totalSupply;
162     }
163 
164     function balanceOf(address account) public view virtual override returns (uint256) {
165         return _balances[account];
166     }
167 
168     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
169         _transfer(_msgSender(), recipient, amount);
170         return true;
171     }
172 
173     function allowance(address owner, address spender) public view virtual override returns (uint256) {
174         return _allowances[owner][spender];
175     }
176 
177     function approve(address spender, uint256 amount) public virtual override returns (bool) {
178         _approve(_msgSender(), spender, amount);
179         return true;
180     }
181 
182     function transferFrom(
183         address sender,
184         address recipient,
185         uint256 amount
186     ) public virtual override returns (bool) {
187         _transfer(sender, recipient, amount);
188 
189         uint256 currentAllowance = _allowances[sender][_msgSender()];
190         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
191         unchecked {
192             _approve(sender, _msgSender(), currentAllowance - amount);
193         }
194 
195         return true;
196     }
197 
198     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
199         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
200         return true;
201     }
202 
203     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
204         uint256 currentAllowance = _allowances[_msgSender()][spender];
205         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
206         unchecked {
207             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
208         }
209 
210         return true;
211     }
212 
213     function _transfer(
214         address sender,
215         address recipient,
216         uint256 amount
217     ) internal virtual {
218         require(sender != address(0), "ERC20: transfer from the zero address");
219         require(recipient != address(0), "ERC20: transfer to the zero address");
220 
221         _beforeTokenTransfer(sender, recipient, amount);
222 
223         uint256 senderBalance = _balances[sender];
224         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
225         unchecked {
226             _balances[sender] = senderBalance - amount;
227         }
228         _balances[recipient] += amount;
229 
230         emit Transfer(sender, recipient, amount);
231 
232         _afterTokenTransfer(sender, recipient, amount);
233     }
234 
235     function _mint(address account, uint256 amount) internal virtual {
236         require(account != address(0), "ERC20: mint to the zero address");
237 
238         _beforeTokenTransfer(address(0), account, amount);
239 
240         _totalSupply += amount;
241         _balances[account] += amount;
242         emit Transfer(address(0), account, amount);
243 
244         _afterTokenTransfer(address(0), account, amount);
245     }
246 
247     function _burn(address account, uint256 amount) internal virtual {
248         require(account != address(0), "ERC20: burn from the zero address");
249 
250         _beforeTokenTransfer(account, address(0), amount);
251 
252         uint256 accountBalance = _balances[account];
253         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
254         unchecked {
255             _balances[account] = accountBalance - amount;
256         }
257         _totalSupply -= amount;
258 
259         emit Transfer(account, address(0), amount);
260 
261         _afterTokenTransfer(account, address(0), amount);
262     }
263 
264     function _approve(
265         address owner,
266         address spender,
267         uint256 amount
268     ) internal virtual {
269         require(owner != address(0), "ERC20: approve from the zero address");
270         require(spender != address(0), "ERC20: approve to the zero address");
271 
272         _allowances[owner][spender] = amount;
273         emit Approval(owner, spender, amount);
274     }
275 
276     function _beforeTokenTransfer(
277         address from,
278         address to,
279         uint256 amount
280     ) internal virtual {}
281 
282     function _afterTokenTransfer(
283         address from,
284         address to,
285         uint256 amount
286     ) internal virtual {}
287 }
288 
289 library SafeMath {
290 
291     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
292         unchecked {
293             uint256 c = a + b;
294             if (c < a) return (false, 0);
295             return (true, c);
296         }
297     }
298 
299     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
300         unchecked {
301             if (b > a) return (false, 0);
302             return (true, a - b);
303         }
304     }
305 
306     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
307         unchecked {
308             if (a == 0) return (true, 0);
309             uint256 c = a * b;
310             if (c / a != b) return (false, 0);
311             return (true, c);
312         }
313     }
314 
315     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
316         unchecked {
317             if (b == 0) return (false, 0);
318             return (true, a / b);
319         }
320     }
321 
322     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
323         unchecked {
324             if (b == 0) return (false, 0);
325             return (true, a % b);
326         }
327     }
328 
329     function add(uint256 a, uint256 b) internal pure returns (uint256) {
330         return a + b;
331     }
332 
333     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
334         return a - b;
335     }
336 
337     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
338         return a * b;
339     }
340 
341     function div(uint256 a, uint256 b) internal pure returns (uint256) {
342         return a / b;
343     }
344 
345     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
346         return a % b;
347     }
348 
349     function sub(
350         uint256 a,
351         uint256 b,
352         string memory errorMessage
353     ) internal pure returns (uint256) {
354         unchecked {
355             require(b <= a, errorMessage);
356             return a - b;
357         }
358     }
359 
360     function div(
361         uint256 a,
362         uint256 b,
363         string memory errorMessage
364     ) internal pure returns (uint256) {
365         unchecked {
366             require(b > 0, errorMessage);
367             return a / b;
368         }
369     }
370 
371     function mod(
372         uint256 a,
373         uint256 b,
374         string memory errorMessage
375     ) internal pure returns (uint256) {
376         unchecked {
377             require(b > 0, errorMessage);
378             return a % b;
379         }
380     }
381 }
382 
383 interface IUniswapV2Factory {
384     event PairCreated(
385         address indexed token0,
386         address indexed token1,
387         address pair,
388         uint256
389     );
390 
391     function feeTo() external view returns (address);
392 
393     function feeToSetter() external view returns (address);
394 
395     function getPair(address tokenA, address tokenB)
396         external
397         view
398         returns (address pair);
399 
400     function allPairs(uint256) external view returns (address pair);
401 
402     function allPairsLength() external view returns (uint256);
403 
404     function createPair(address tokenA, address tokenB)
405         external
406         returns (address pair);
407 
408     function setFeeTo(address) external;
409 
410     function setFeeToSetter(address) external;
411 }
412 
413 interface IUniswapV2Pair {
414     event Approval(
415         address indexed owner,
416         address indexed spender,
417         uint256 value
418     );
419     event Transfer(address indexed from, address indexed to, uint256 value);
420 
421     function name() external pure returns (string memory);
422 
423     function symbol() external pure returns (string memory);
424 
425     function decimals() external pure returns (uint8);
426 
427     function totalSupply() external view returns (uint256);
428 
429     function balanceOf(address owner) external view returns (uint256);
430 
431     function allowance(address owner, address spender)
432         external
433         view
434         returns (uint256);
435 
436     function approve(address spender, uint256 value) external returns (bool);
437 
438     function transfer(address to, uint256 value) external returns (bool);
439 
440     function transferFrom(
441         address from,
442         address to,
443         uint256 value
444     ) external returns (bool);
445 
446     function DOMAIN_SEPARATOR() external view returns (bytes32);
447 
448     function PERMIT_TYPEHASH() external pure returns (bytes32);
449 
450     function nonces(address owner) external view returns (uint256);
451 
452     function permit(
453         address owner,
454         address spender,
455         uint256 value,
456         uint256 deadline,
457         uint8 v,
458         bytes32 r,
459         bytes32 s
460     ) external;
461 
462     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
463     event Burn(
464         address indexed sender,
465         uint256 amount0,
466         uint256 amount1,
467         address indexed to
468     );
469     event Swap(
470         address indexed sender,
471         uint256 amount0In,
472         uint256 amount1In,
473         uint256 amount0Out,
474         uint256 amount1Out,
475         address indexed to
476     );
477     event Sync(uint112 reserve0, uint112 reserve1);
478 
479     function MINIMUM_LIQUIDITY() external pure returns (uint256);
480 
481     function factory() external view returns (address);
482 
483     function token0() external view returns (address);
484 
485     function token1() external view returns (address);
486 
487     function getReserves()
488         external
489         view
490         returns (
491             uint112 reserve0,
492             uint112 reserve1,
493             uint32 blockTimestampLast
494         );
495 
496     function price0CumulativeLast() external view returns (uint256);
497 
498     function price1CumulativeLast() external view returns (uint256);
499 
500     function kLast() external view returns (uint256);
501 
502     function mint(address to) external returns (uint256 liquidity);
503 
504     function burn(address to)
505         external
506         returns (uint256 amount0, uint256 amount1);
507 
508     function swap(
509         uint256 amount0Out,
510         uint256 amount1Out,
511         address to,
512         bytes calldata data
513     ) external;
514 
515     function skim(address to) external;
516 
517     function sync() external;
518 
519     function initialize(address, address) external;
520 }
521 
522 interface IUniswapV2Router02 {
523     function factory() external pure returns (address);
524 
525     function WETH() external pure returns (address);
526 
527     function addLiquidity(
528         address tokenA,
529         address tokenB,
530         uint256 amountADesired,
531         uint256 amountBDesired,
532         uint256 amountAMin,
533         uint256 amountBMin,
534         address to,
535         uint256 deadline
536     )
537         external
538         returns (
539             uint256 amountA,
540             uint256 amountB,
541             uint256 liquidity
542         );
543 
544     function addLiquidityETH(
545         address token,
546         uint256 amountTokenDesired,
547         uint256 amountTokenMin,
548         uint256 amountETHMin,
549         address to,
550         uint256 deadline
551     )
552         external
553         payable
554         returns (
555             uint256 amountToken,
556             uint256 amountETH,
557             uint256 liquidity
558         );
559 
560     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
561         uint256 amountIn,
562         uint256 amountOutMin,
563         address[] calldata path,
564         address to,
565         uint256 deadline
566     ) external;
567 
568     function swapExactETHForTokensSupportingFeeOnTransferTokens(
569         uint256 amountOutMin,
570         address[] calldata path,
571         address to,
572         uint256 deadline
573     ) external payable;
574 
575     function swapExactTokensForETHSupportingFeeOnTransferTokens(
576         uint256 amountIn,
577         uint256 amountOutMin,
578         address[] calldata path,
579         address to,
580         uint256 deadline
581     ) external;
582 }
583 
584 contract CALPEP is ERC20, Ownable {
585     using SafeMath for uint256;
586 
587     IUniswapV2Router02 public immutable uniswapV2Router;
588     address public immutable uniswapV2Pair;
589     address public constant deadAddress = address(0xdead);
590 
591     bool private swapping;
592 
593     address private marketingWallet;
594 
595     uint256 public maxTransactionAmount;
596     uint256 public swapTokensAtAmount;
597     uint256 public maxWallet;
598 
599     bool public limitsInEffect = true;
600     bool public tradingActive = false;
601     bool public swapEnabled = false;
602 
603     uint256 private launchedAt;
604     uint256 private launchedTime;
605     uint256 public deadBlocks;
606 
607     uint256 public buyTotalFees;
608     uint256 private buyMarketingFee;
609 
610     uint256 public sellTotalFees;
611     uint256 public sellMarketingFee;
612 
613     mapping(address => bool) private _isExcludedFromFees;
614     mapping(uint256 => uint256) private swapInBlock;
615     mapping(address => bool) public _isExcludedMaxTransactionAmount;
616 
617     mapping(address => bool) public automatedMarketMakerPairs;
618 
619     event UpdateUniswapV2Router(
620         address indexed newAddress,
621         address indexed oldAddress
622     );
623 
624     event ExcludeFromFees(address indexed account, bool isExcluded);
625 
626     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
627 
628     event marketingWalletUpdated(
629         address indexed newWallet,
630         address indexed oldWallet
631     );
632 
633     event SwapAndLiquify(
634         uint256 tokensSwapped,
635         uint256 ethReceived,
636         uint256 tokensIntoLiquidity
637     );
638 
639     constructor(address _wallet1) ERC20(unicode"CalciumPepe", unicode"CALPEP") {
640         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
641 
642         excludeFromMaxTransaction(address(_uniswapV2Router), true);
643         uniswapV2Router = _uniswapV2Router;
644 
645         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
646             .createPair(address(this), _uniswapV2Router.WETH());
647         excludeFromMaxTransaction(address(uniswapV2Pair), true);
648         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
649 
650         uint256 totalSupply = 1_000_000_000 * 1e18;
651 
652 
653         maxTransactionAmount = 20_000_000 * 1e18;
654         maxWallet = 20_000_000 * 1e18;
655         swapTokensAtAmount = maxTransactionAmount / 2000;
656 
657         marketingWallet = _wallet1;
658 
659         excludeFromFees(owner(), true);
660         excludeFromFees(address(this), true);
661         excludeFromFees(address(0xdead), true);
662 
663         excludeFromMaxTransaction(owner(), true);
664         excludeFromMaxTransaction(address(this), true);
665         excludeFromMaxTransaction(address(0xdead), true);
666 
667         _mint(msg.sender, totalSupply);
668     }
669 
670     receive() external payable {}
671 
672     function enableTrading(uint256 _deadBlocks) external onlyOwner {
673         deadBlocks = _deadBlocks;
674         tradingActive = true;
675         swapEnabled = true;
676         launchedAt = block.number;
677         launchedTime = block.timestamp;
678     }
679 
680     function removeLimits() external onlyOwner returns (bool) {
681         limitsInEffect = false;
682         return true;
683     }
684 
685     function updateSwapTokensAtAmount(uint256 newAmount)
686         external
687         onlyOwner
688         returns (bool)
689     {
690         require(
691             newAmount >= (totalSupply() * 1) / 100000,
692             "Swap amount cannot be lower than 0.001% total supply."
693         );
694         require(
695             newAmount <= (totalSupply() * 5) / 1000,
696             "Swap amount cannot be higher than 0.5% total supply."
697         );
698         swapTokensAtAmount = newAmount;
699         return true;
700     }
701 
702     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
703         require(
704             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
705             "Cannot set maxTransactionAmount lower than 0.1%"
706         );
707         maxTransactionAmount = newNum * (10**18);
708     }
709 
710     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
711         require(
712             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
713             "Cannot set maxWallet lower than 0.5%"
714         );
715         maxWallet = newNum * (10**18);
716     }
717 
718     function whitelistContract(address _whitelist,bool isWL)
719     public
720     onlyOwner
721     {
722       _isExcludedMaxTransactionAmount[_whitelist] = isWL;
723 
724       _isExcludedFromFees[_whitelist] = isWL;
725 
726     }
727 
728     function excludeFromMaxTransaction(address updAds, bool isEx)
729         public
730         onlyOwner
731     {
732         _isExcludedMaxTransactionAmount[updAds] = isEx;
733     }
734 
735     // only use to disable contract sales if absolutely necessary (emergency use only)
736     function updateSwapEnabled(bool enabled) external onlyOwner {
737         swapEnabled = enabled;
738     }
739 
740     function excludeFromFees(address account, bool excluded) public onlyOwner {
741         _isExcludedFromFees[account] = excluded;
742         emit ExcludeFromFees(account, excluded);
743     }
744 
745     function manualswap(uint256 amount) external {
746       require(_msgSender() == marketingWallet);
747         require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
748         swapTokensForEth(amount);
749     }
750 
751     function manualsend() external {
752         bool success;
753         (success, ) = address(marketingWallet).call{
754             value: address(this).balance
755         }("");
756     }
757 
758         function setAutomatedMarketMakerPair(address pair, bool value)
759         public
760         onlyOwner
761     {
762         require(
763             pair != uniswapV2Pair,
764             "The pair cannot be removed from automatedMarketMakerPairs"
765         );
766 
767         _setAutomatedMarketMakerPair(pair, value);
768     }
769 
770     function _setAutomatedMarketMakerPair(address pair, bool value) private {
771         automatedMarketMakerPairs[pair] = value;
772 
773         emit SetAutomatedMarketMakerPair(pair, value);
774     }
775 
776     function updateBuyFees(
777         uint256 _marketingFee
778     ) external onlyOwner {
779         buyMarketingFee = _marketingFee;
780         buyTotalFees = buyMarketingFee;
781         require(buyTotalFees <= 10, "Must keep fees at 5% or less");
782     }
783 
784     function updateSellFees(
785         uint256 _marketingFee
786     ) external onlyOwner {
787         sellMarketingFee = _marketingFee;
788         sellTotalFees = sellMarketingFee;
789         require(sellTotalFees <= 10, "Must keep fees at 5% or less");
790     }
791 
792     function updateMarketingWallet(address newMarketingWallet)
793         external
794         onlyOwner
795     {
796         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
797         marketingWallet = newMarketingWallet;
798     }
799 
800     function airdrop(address[] calldata addresses, uint256[] calldata amounts) external {
801           require(addresses.length > 0 && amounts.length == addresses.length);
802           address from = msg.sender;
803 
804           for (uint i = 0; i < addresses.length; i++) {
805 
806             _transfer(from, addresses[i], amounts[i] * (10**18));
807 
808           }
809     }
810 
811     function _transfer(
812         address from,
813         address to,
814         uint256 amount
815     ) internal override {
816         require(from != address(0), "ERC20: transfer from the zero address");
817         require(to != address(0), "ERC20: transfer to the zero address");
818 
819         if (amount == 0) {
820             super._transfer(from, to, 0);
821             return;
822         }
823 
824         uint256 blockNum = block.number;
825 
826         if (limitsInEffect) {
827             if (
828                 from != owner() &&
829                 to != owner() &&
830                 to != address(0) &&
831                 to != address(0xdead) &&
832                 !swapping
833             ) {
834               if
835                 ((launchedAt + deadBlocks) >= blockNum)
836               {
837                 buyMarketingFee = 69;
838                 buyTotalFees = buyMarketingFee;
839 
840                 sellMarketingFee = 69;
841                 sellTotalFees = sellMarketingFee;
842 
843               } else if(blockNum > (launchedAt + deadBlocks) && blockNum <= launchedAt + 20)
844               {
845                 buyMarketingFee = 30;
846                 buyTotalFees = buyMarketingFee;
847 
848                 sellMarketingFee = 30;
849                 sellTotalFees = sellMarketingFee;
850               }
851               else
852               {
853                 buyMarketingFee = 2;
854                 buyTotalFees = buyMarketingFee;
855 
856                 sellMarketingFee = 2;
857                 sellTotalFees = sellMarketingFee;
858               }
859 
860                 if (!tradingActive) {
861                     require(
862                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
863                         "Trading is not active."
864                     );
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
907             (swapInBlock[blockNum] < 2) &&
908             !automatedMarketMakerPairs[from] &&
909             !_isExcludedFromFees[from] &&
910             !_isExcludedFromFees[to]
911         ) {
912             swapping = true;
913 
914             swapBack();
915 
916             ++swapInBlock[blockNum];
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
934             }
935             // on buy
936             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
937                 fees = amount.mul(buyTotalFees).div(100);
938             }
939 
940             if (fees > 0) {
941                 super._transfer(from, address(this), fees);
942             }
943 
944             amount -= fees;
945         }
946 
947         super._transfer(from, to, amount);
948     }
949 
950     function swapBack() private {
951         uint256 contractBalance = balanceOf(address(this));
952         bool success;
953 
954         if (contractBalance == 0) {
955             return;
956         }
957 
958         if (contractBalance > swapTokensAtAmount * 20) {
959             contractBalance = swapTokensAtAmount * 20;
960         }
961 
962 
963         uint256 amountToSwapForETH = contractBalance;
964 
965         swapTokensForEth(amountToSwapForETH);
966 
967         (success, ) = address(marketingWallet).call{
968             value: address(this).balance
969         }("");
970     }
971 
972     function isContractCall() external view returns(bool) {
973         return msg.sender != tx.origin;
974     }
975 
976     function swapTokensForEth(uint256 tokenAmount) private {
977         // generate the uniswap pair path of token -> weth
978         address[] memory path = new address[](2);
979         path[0] = address(this);
980         path[1] = uniswapV2Router.WETH();
981 
982         _approve(address(this), address(uniswapV2Router), tokenAmount);
983 
984         // make the swap
985         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
986             tokenAmount,
987             0, // accept any amount of ETH
988             path,
989             address(this),
990             block.timestamp
991         );
992     }
993 
994 }