1 //⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⢔⢒⡿⠯⠥⢦⣦⣾⣄⠀⠀⠀⠀⠀⠀⠀
2 //⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⢮⠊⠁⠀⠀⠀⠀⠈⠉⠛⠳⡀⠀⠀⠀⠀⠀
3 //⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣧⣿⣝⡴⡔⠀⠀⠀⠀⠀⠀⠀⠀⠘⡀⠀⠀⠀⠀
4 //⠀⠀⠀⠀⠀⠀⠀⣀⣀⣦⣶⣿⣿⣯⣿⢽⠁⢰⣢⣶⣦⣌⠠⠴⠆⠘⣀⠀⠀⠀
5 //⠀⠀⠀⠀⢀⠔⠁⠀⢂⠘⢻⢛⣛⠿⣝⠁⠀⠼⣁⡴⣖⣫⠙⠙⠿⡳⡅⠀⠀⠀
6 //⠀⠀⠀⢀⠂⠰⠀⠀⠈⡄⢠⢓⣺⢇⡇⣊⠐⠀⠉⠁⠲⠒⠀⠀⠀⠑⠅⠀⠀⠀
7 //⠀⠀⠀⣨⠀⡇⠀⠀⠀⠰⢸⠄⠄⣸⣷⡦⣄⢤⠄⢄⡀⣀⠤⠠⡀⠀⠈⡄⠀⠀
8 //⠀⠀⢠⠁⠙⣇⠀⠀⠀⠀⢾⠘⢠⣿⣟⣿⣿⣪⣮⣶⣸⣮⣖⣢⣌⠁⠀⠁⠀⠀
9 //⠀⠀⢸⠀⠀⢹⠀⠀⠀⠀⠸⠀⢝⣻⣯⣿⢿⡫⢺⡩⠍⣉⣉⣨⡗⠉⠂⠊⠀⠀
10 //⠀⠀⡈⠂⠀⣾⠀⠀⠀⠀⠀⠆⡸⣹⡿⣿⣯⣷⣱⣙⠫⠧⠷⣦⠀⠀⠀⠀⠀⠀
11 //⠀⢠⠇⠀⠀⢉⠀⠀⠀⠀⠀⠈⠕⣻⣿⣿⣿⣟⣿⣿⡷⣶⣾⠿⠒⡁⠀⠀⠀⠀
12 //⠀⠀⠀⠀⠀⠈⡇⠀⠀⠀⠀⠀⠈⢇⠻⠽⣿⡿⢟⣿⣻⡟⠁⠰⣯⡕⡰⠀⠀⠀
13 //⠀⠀⠀⠀⠀⠀⢩⠀⠀⠀⠀⠀⢀⠬⣍⠱⠨⠯⠛⠙⢏⠀⢀⡀⣨⡀⠤⢚⠀⠀
14 //⠀⠀⠀⠀⠀⠀⠀⢂⠀⠀⠀⠀⠀⢠⠁⠀⠀⠀⠀⠀⢸⠄⠰⡶⠲⢦⠓⠍⠀⠀
15 //⠀⠀⠀⠀⠀⠀⠀⠀⠡⡀⠀⠀⠀⠀⠀⠀⡄⠀⢀⠄⠊⠉⠙⠑⠒⠊⠉⠀⠀
16 
17 
18 // SPDX-License-Identifier: MIT
19 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
20 pragma experimental ABIEncoderV2;
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 abstract contract Ownable is Context {
33     address private _owner;
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     constructor() {
38         _transferOwnership(_msgSender());
39     }
40 
41     function owner() public view virtual returns (address) {
42         return _owner;
43     }
44 
45     modifier onlyOwner() {
46         require(owner() == _msgSender(), "Ownable: caller is not the owner");
47         _;
48     }
49 
50 
51     function renounceOwnership() public virtual onlyOwner {
52         _transferOwnership(address(0));
53     }
54 
55     function transferOwnership(address newOwner) public virtual onlyOwner {
56         require(newOwner != address(0), "Ownable: new owner is the zero address");
57         _transferOwnership(newOwner);
58     }
59 
60 
61     function _transferOwnership(address newOwner) internal virtual {
62         address oldOwner = _owner;
63         _owner = newOwner;
64         emit OwnershipTransferred(oldOwner, newOwner);
65     }
66 }
67 
68 interface IERC20 {
69 
70     function totalSupply() external view returns (uint256);
71 
72     function balanceOf(address account) external view returns (uint256);
73 
74 
75     function transfer(address recipient, uint256 amount) external returns (bool);
76 
77 
78     function allowance(address owner, address spender) external view returns (uint256);
79 
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82 
83     function transferFrom(
84         address sender,
85         address recipient,
86         uint256 amount
87     ) external returns (bool);
88 
89 
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 interface IERC20Metadata is IERC20 {
96 
97     function name() external view returns (string memory);
98 
99     function symbol() external view returns (string memory);
100 
101     function decimals() external view returns (uint8);
102 }
103 
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
115 
116     constructor(string memory name_, string memory symbol_) {
117         _name = name_;
118         _symbol = symbol_;
119     }
120 
121 
122     function name() public view virtual override returns (string memory) {
123         return _name;
124     }
125 
126 
127     function symbol() public view virtual override returns (string memory) {
128         return _symbol;
129     }
130 
131 
132     function decimals() public view virtual override returns (uint8) {
133         return 18;
134     }
135 
136 
137     function totalSupply() public view virtual override returns (uint256) {
138         return _totalSupply;
139     }
140 
141     function balanceOf(address account) public view virtual override returns (uint256) {
142         return _balances[account];
143     }
144 
145     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
146         _transfer(_msgSender(), recipient, amount);
147         return true;
148     }
149 
150 
151     function allowance(address owner, address spender) public view virtual override returns (uint256) {
152         return _allowances[owner][spender];
153     }
154 
155     function approve(address spender, uint256 amount) public virtual override returns (bool) {
156         _approve(_msgSender(), spender, amount);
157         return true;
158     }
159 
160     function transferFrom(
161         address sender,
162         address recipient,
163         uint256 amount
164     ) public virtual override returns (bool) {
165         _transfer(sender, recipient, amount);
166 
167         uint256 currentAllowance = _allowances[sender][_msgSender()];
168         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
169         unchecked {
170             _approve(sender, _msgSender(), currentAllowance - amount);
171         }
172 
173         return true;
174     }
175 
176     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
177         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
178         return true;
179     }
180 
181     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
182         uint256 currentAllowance = _allowances[_msgSender()][spender];
183         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
184         unchecked {
185             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
186         }
187 
188         return true;
189     }
190 
191     function _transfer(
192         address sender,
193         address recipient,
194         uint256 amount
195     ) internal virtual {
196         require(sender != address(0), "ERC20: transfer from the zero address");
197         require(recipient != address(0), "ERC20: transfer to the zero address");
198 
199         _beforeTokenTransfer(sender, recipient, amount);
200 
201         uint256 senderBalance = _balances[sender];
202         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
203         unchecked {
204             _balances[sender] = senderBalance - amount;
205         }
206         _balances[recipient] += amount;
207 
208         emit Transfer(sender, recipient, amount);
209 
210         _afterTokenTransfer(sender, recipient, amount);
211     }
212 
213     function _mint(address account, uint256 amount) internal virtual {
214         require(account != address(0), "ERC20: mint to the zero address");
215 
216         _beforeTokenTransfer(address(0), account, amount);
217 
218         _totalSupply += amount;
219         _balances[account] += amount;
220         emit Transfer(address(0), account, amount);
221 
222         _afterTokenTransfer(address(0), account, amount);
223     }
224 
225     function _burn(address account, uint256 amount) internal virtual {
226         require(account != address(0), "ERC20: burn from the zero address");
227 
228         _beforeTokenTransfer(account, address(0), amount);
229 
230         uint256 accountBalance = _balances[account];
231         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
232         unchecked {
233             _balances[account] = accountBalance - amount;
234         }
235         _totalSupply -= amount;
236 
237         emit Transfer(account, address(0), amount);
238 
239         _afterTokenTransfer(account, address(0), amount);
240     }
241 
242     function _approve(
243         address owner,
244         address spender,
245         uint256 amount
246     ) internal virtual {
247         require(owner != address(0), "ERC20: approve from the zero address");
248         require(spender != address(0), "ERC20: approve to the zero address");
249 
250         _allowances[owner][spender] = amount;
251         emit Approval(owner, spender, amount);
252     }
253 
254     function _beforeTokenTransfer(
255         address from,
256         address to,
257         uint256 amount
258     ) internal virtual {}
259 
260     function _afterTokenTransfer(
261         address from,
262         address to,
263         uint256 amount
264     ) internal virtual {}
265 }
266 
267 
268 library SafeMath {
269 
270     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
271         unchecked {
272             uint256 c = a + b;
273             if (c < a) return (false, 0);
274             return (true, c);
275         }
276     }
277 
278     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
279         unchecked {
280             if (b > a) return (false, 0);
281             return (true, a - b);
282         }
283     }
284 
285 
286     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
287         unchecked {
288             if (a == 0) return (true, 0);
289             uint256 c = a * b;
290             if (c / a != b) return (false, 0);
291             return (true, c);
292         }
293     }
294 
295     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
296         unchecked {
297             if (b == 0) return (false, 0);
298             return (true, a / b);
299         }
300     }
301 
302     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
303         unchecked {
304             if (b == 0) return (false, 0);
305             return (true, a % b);
306         }
307     }
308 
309 
310     function add(uint256 a, uint256 b) internal pure returns (uint256) {
311         return a + b;
312     }
313 
314     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
315         return a - b;
316     }
317 
318     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
319         return a * b;
320     }
321 
322     function div(uint256 a, uint256 b) internal pure returns (uint256) {
323         return a / b;
324     }
325 
326     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
327         return a % b;
328     }
329 
330     function sub(
331         uint256 a,
332         uint256 b,
333         string memory errorMessage
334     ) internal pure returns (uint256) {
335         unchecked {
336             require(b <= a, errorMessage);
337             return a - b;
338         }
339     }
340 
341     function div(
342         uint256 a,
343         uint256 b,
344         string memory errorMessage
345     ) internal pure returns (uint256) {
346         unchecked {
347             require(b > 0, errorMessage);
348             return a / b;
349         }
350     }
351 
352 
353     function mod(
354         uint256 a,
355         uint256 b,
356         string memory errorMessage
357     ) internal pure returns (uint256) {
358         unchecked {
359             require(b > 0, errorMessage);
360             return a % b;
361         }
362     }
363 }
364 
365 
366 interface IUniswapV2Factory {
367     event PairCreated(
368         address indexed token0,
369         address indexed token1,
370         address pair,
371         uint256
372     );
373 
374     function feeTo() external view returns (address);
375 
376     function feeToSetter() external view returns (address);
377 
378     function getPair(address tokenA, address tokenB)
379         external
380         view
381         returns (address pair);
382 
383     function allPairs(uint256) external view returns (address pair);
384 
385     function allPairsLength() external view returns (uint256);
386 
387     function createPair(address tokenA, address tokenB)
388         external
389         returns (address pair);
390 
391     function setFeeTo(address) external;
392 
393     function setFeeToSetter(address) external;
394 }
395 
396 
397 interface IUniswapV2Pair {
398     event Approval(
399         address indexed owner,
400         address indexed spender,
401         uint256 value
402     );
403     event Transfer(address indexed from, address indexed to, uint256 value);
404 
405     function name() external pure returns (string memory);
406 
407     function symbol() external pure returns (string memory);
408 
409     function decimals() external pure returns (uint8);
410 
411     function totalSupply() external view returns (uint256);
412 
413     function balanceOf(address owner) external view returns (uint256);
414 
415     function allowance(address owner, address spender)
416         external
417         view
418         returns (uint256);
419 
420     function approve(address spender, uint256 value) external returns (bool);
421 
422     function transfer(address to, uint256 value) external returns (bool);
423 
424     function transferFrom(
425         address from,
426         address to,
427         uint256 value
428     ) external returns (bool);
429 
430     function DOMAIN_SEPARATOR() external view returns (bytes32);
431 
432     function PERMIT_TYPEHASH() external pure returns (bytes32);
433 
434     function nonces(address owner) external view returns (uint256);
435 
436     function permit(
437         address owner,
438         address spender,
439         uint256 value,
440         uint256 deadline,
441         uint8 v,
442         bytes32 r,
443         bytes32 s
444     ) external;
445 
446     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
447     event Burn(
448         address indexed sender,
449         uint256 amount0,
450         uint256 amount1,
451         address indexed to
452     );
453     event Swap(
454         address indexed sender,
455         uint256 amount0In,
456         uint256 amount1In,
457         uint256 amount0Out,
458         uint256 amount1Out,
459         address indexed to
460     );
461     event Sync(uint112 reserve0, uint112 reserve1);
462 
463     function MINIMUM_LIQUIDITY() external pure returns (uint256);
464 
465     function factory() external view returns (address);
466 
467     function token0() external view returns (address);
468 
469     function token1() external view returns (address);
470 
471     function getReserves()
472         external
473         view
474         returns (
475             uint112 reserve0,
476             uint112 reserve1,
477             uint32 blockTimestampLast
478         );
479 
480     function price0CumulativeLast() external view returns (uint256);
481 
482     function price1CumulativeLast() external view returns (uint256);
483 
484     function kLast() external view returns (uint256);
485 
486     function mint(address to) external returns (uint256 liquidity);
487 
488     function burn(address to)
489         external
490         returns (uint256 amount0, uint256 amount1);
491 
492     function swap(
493         uint256 amount0Out,
494         uint256 amount1Out,
495         address to,
496         bytes calldata data
497     ) external;
498 
499     function skim(address to) external;
500 
501     function sync() external;
502 
503     function initialize(address, address) external;
504 }
505 
506 
507 interface IUniswapV2Router02 {
508     function factory() external pure returns (address);
509 
510     function WETH() external pure returns (address);
511 
512     function addLiquidity(
513         address tokenA,
514         address tokenB,
515         uint256 amountADesired,
516         uint256 amountBDesired,
517         uint256 amountAMin,
518         uint256 amountBMin,
519         address to,
520         uint256 deadline
521     )
522         external
523         returns (
524             uint256 amountA,
525             uint256 amountB,
526             uint256 liquidity
527         );
528 
529     function addLiquidityETH(
530         address token,
531         uint256 amountTokenDesired,
532         uint256 amountTokenMin,
533         uint256 amountETHMin,
534         address to,
535         uint256 deadline
536     )
537         external
538         payable
539         returns (
540             uint256 amountToken,
541             uint256 amountETH,
542             uint256 liquidity
543         );
544 
545     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
546         uint256 amountIn,
547         uint256 amountOutMin,
548         address[] calldata path,
549         address to,
550         uint256 deadline
551     ) external;
552 
553     function swapExactETHForTokensSupportingFeeOnTransferTokens(
554         uint256 amountOutMin,
555         address[] calldata path,
556         address to,
557         uint256 deadline
558     ) external payable;
559 
560     function swapExactTokensForETHSupportingFeeOnTransferTokens(
561         uint256 amountIn,
562         uint256 amountOutMin,
563         address[] calldata path,
564         address to,
565         uint256 deadline
566     ) external;
567 }
568 
569 
570 contract JEW is ERC20, Ownable {
571     using SafeMath for uint256;
572 
573     IUniswapV2Router02 public immutable uniswapV2Router;
574     address public immutable uniswapV2Pair;
575     address public constant deadAddress = address(0xdead);
576 
577     bool private swapping;
578 
579     address private marketingWallet;
580     address private developmentWallet;
581 
582     uint256 public maxTransactionAmount;
583     uint256 public swapTokensAtAmount;
584     uint256 public maxWallet;
585 
586     uint256 public percentForLPBurn = 0; 
587     bool public lpBurnEnabled = false;
588     uint256 public lpBurnFrequency = 3600 seconds;
589     uint256 public lastLpBurnTime;
590 
591     uint256 public manualBurnFrequency = 30 minutes;
592     uint256 public lastManualLpBurnTime;
593 
594     bool public limitsInEffect = true;
595     bool public tradingActive = false;
596     bool public swapEnabled = true;
597 
598     mapping(address => uint256) private _holderLastTransferTimestamp; 
599     bool public transferDelayEnabled = true;
600 
601     uint256 public buyTotalFees;
602     uint256 public buyMarketingFee;
603     uint256 public buyLiquidityFee;
604     uint256 public buyDevelopmentFee;
605 
606     uint256 public sellTotalFees;
607     uint256 public sellMarketingFee;
608     uint256 public sellLiquidityFee;
609     uint256 public sellDevelopmentFee;
610 
611     uint256 public tokensForMarketing;
612     uint256 public tokensForLiquidity;
613     uint256 public tokensForDev;
614 
615     mapping(address => bool) private _isExcludedFromFees;
616     mapping(address => bool) public _isExcludedMaxTransactionAmount;
617 
618     mapping(address => bool) public automatedMarketMakerPairs;
619 
620     event UpdateUniswapV2Router(
621         address indexed newAddress,
622         address indexed oldAddress
623     );
624 
625     event ExcludeFromFees(address indexed account, bool isExcluded);
626 
627     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
628 
629     event marketingWalletUpdated(
630         address indexed newWallet,
631         address indexed oldWallet
632     );
633 
634     event developmentWalletUpdated(
635         address indexed newWallet,
636         address indexed oldWallet
637     );
638 
639     event SwapAndLiquify(
640         uint256 tokensSwapped,
641         uint256 ethReceived,
642         uint256 tokensIntoLiquidity
643     );
644 
645     event AutoNukeLP();
646 
647     event ManualNukeLP();
648 
649     constructor() ERC20("Happy Merchant", "JEW") {
650         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
651             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
652         );
653 
654         excludeFromMaxTransaction(address(_uniswapV2Router), true);
655         uniswapV2Router = _uniswapV2Router;
656 
657         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
658             .createPair(address(this), _uniswapV2Router.WETH());
659         excludeFromMaxTransaction(address(uniswapV2Pair), true);
660         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
661 
662         uint256 _buyMarketingFee = 0;
663         uint256 _buyLiquidityFee = 0;
664         uint256 _buyDevelopmentFee = 0;
665 
666         uint256 _sellMarketingFee = 0;
667         uint256 _sellLiquidityFee = 0;
668         uint256 _sellDevelopmentFee = 0;
669 
670         uint256 totalSupply = 18_000_000 * 1e18;
671 
672         maxTransactionAmount = 18_000_000 * 1e18;
673         maxWallet = 18_000_000 * 1e18;
674         swapTokensAtAmount = (totalSupply * 10) / 10000;
675 
676         buyMarketingFee = _buyMarketingFee;
677         buyLiquidityFee = _buyLiquidityFee;
678         buyDevelopmentFee = _buyDevelopmentFee;
679         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
680 
681         sellMarketingFee = _sellMarketingFee;
682         sellLiquidityFee = _sellLiquidityFee;
683         sellDevelopmentFee = _sellDevelopmentFee;
684         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
685 
686         marketingWallet = address(0x02a54094F727D1D83788e70C68937bde195A480C); 
687         developmentWallet = address(0x02a54094F727D1D83788e70C68937bde195A480C); 
688 
689         excludeFromFees(owner(), true);
690         excludeFromFees(address(this), true);
691         excludeFromFees(address(0xdead), true);
692 
693         excludeFromMaxTransaction(owner(), true);
694         excludeFromMaxTransaction(address(this), true);
695         excludeFromMaxTransaction(address(0xdead), true);
696 
697         _mint(msg.sender, totalSupply);
698     }
699 
700     receive() external payable {}
701 
702     function enableTrading() external onlyOwner {
703         tradingActive = true;
704         swapEnabled = true;
705         lastLpBurnTime = block.timestamp;
706     }
707 
708     function removeLimits() external onlyOwner returns (bool) {
709         limitsInEffect = false;
710         return true;
711     }
712 
713     function disableTransferDelay() external onlyOwner returns (bool) {
714         transferDelayEnabled = false;
715         return true;
716     }
717 
718     function updateSwapTokensAtAmount(uint256 newAmount)
719         external
720         onlyOwner
721         returns (bool)
722     {
723         require(
724             newAmount >= (totalSupply() * 1) / 100000,
725             "Swap amount cannot be lower than 0.001% total supply."
726         );
727         require(
728             newAmount <= (totalSupply() * 5) / 1000,
729             "Swap amount cannot be higher than 0.5% total supply."
730         );
731         swapTokensAtAmount = newAmount;
732         return true;
733     }
734 
735     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
736         require(
737             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
738             "Cannot set maxTransactionAmount lower than 0.1%"
739         );
740         maxTransactionAmount = newNum * (10**18);
741     }
742 
743     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
744         require(
745             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
746             "Cannot set maxWallet lower than 0.5%"
747         );
748         maxWallet = newNum * (10**18);
749     }
750 
751     function excludeFromMaxTransaction(address updAds, bool isEx)
752         public
753         onlyOwner
754     {
755         _isExcludedMaxTransactionAmount[updAds] = isEx;
756     }
757 
758     function updateSwapEnabled(bool enabled) external onlyOwner {
759         swapEnabled = enabled;
760     }
761 
762     function updateBuyFees(
763         uint256 _marketingFee,
764         uint256 _liquidityFee,
765         uint256 _developmentFee
766     ) external onlyOwner {
767         buyMarketingFee = _marketingFee;
768         buyLiquidityFee = _liquidityFee;
769         buyDevelopmentFee = _developmentFee;
770         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
771         require(buyTotalFees <= 20, "Must keep fees at 35% or less");
772     }
773 
774     function updateSellFees(
775         uint256 _marketingFee,
776         uint256 _liquidityFee,
777         uint256 _developmentFee
778     ) external onlyOwner {
779         sellMarketingFee = _marketingFee;
780         sellLiquidityFee = _liquidityFee;
781         sellDevelopmentFee = _developmentFee;
782         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
783         require(sellTotalFees <= 20, "Must keep fees at 40% or less");
784     }
785 
786     function excludeFromFees(address account, bool excluded) public onlyOwner {
787         _isExcludedFromFees[account] = excluded;
788         emit ExcludeFromFees(account, excluded);
789     }
790 
791     function setAutomatedMarketMakerPair(address pair, bool value)
792         public
793         onlyOwner
794     {
795         require(
796             pair != uniswapV2Pair,
797             "The pair cannot be removed from automatedMarketMakerPairs"
798         );
799 
800         _setAutomatedMarketMakerPair(pair, value);
801     }
802 
803     function _setAutomatedMarketMakerPair(address pair, bool value) private {
804         automatedMarketMakerPairs[pair] = value;
805 
806         emit SetAutomatedMarketMakerPair(pair, value);
807     }
808 
809     function updateMarketingWalletInfo(address newMarketingWallet)
810         external
811         onlyOwner
812     {
813         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
814         marketingWallet = newMarketingWallet;
815     }
816 
817     function updateDevelopmentWalletInfo(address newWallet) external onlyOwner {
818         emit developmentWalletUpdated(newWallet, developmentWallet);
819         developmentWallet = newWallet;
820     }
821 
822     function isExcludedFromFees(address account) public view returns (bool) {
823         return _isExcludedFromFees[account];
824     }
825 
826     event BoughtEarly(address indexed sniper);
827 
828     function _transfer(
829         address from,
830         address to,
831         uint256 amount
832     ) internal override {
833         require(from != address(0), "ERC20: transfer from the zero address");
834         require(to != address(0), "ERC20: transfer to the zero address");
835 
836         if (amount == 0) {
837             super._transfer(from, to, 0);
838             return;
839         }
840 
841         if (limitsInEffect) {
842             if (
843                 from != owner() &&
844                 to != owner() &&
845                 to != address(0) &&
846                 to != address(0xdead) &&
847                 !swapping
848             ) {
849                 if (!tradingActive) {
850                     require(
851                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
852                         "Trading is not active."
853                     );
854                 }
855 
856                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
857                 if (transferDelayEnabled) {
858                     if (
859                         to != owner() &&
860                         to != address(uniswapV2Router) &&
861                         to != address(uniswapV2Pair)
862                     ) {
863                         require(
864                             _holderLastTransferTimestamp[tx.origin] <
865                                 block.number,
866                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
867                         );
868                         _holderLastTransferTimestamp[tx.origin] = block.number;
869                     }
870                 }
871 
872                 //when buy
873                 if (
874                     automatedMarketMakerPairs[from] &&
875                     !_isExcludedMaxTransactionAmount[to]
876                 ) {
877                     require(
878                         amount <= maxTransactionAmount,
879                         "Buy transfer amount exceeds the maxTransactionAmount."
880                     );
881                     require(
882                         amount + balanceOf(to) <= maxWallet,
883                         "Max wallet exceeded"
884                     );
885                 }
886                 //when sell
887                 else if (
888                     automatedMarketMakerPairs[to] &&
889                     !_isExcludedMaxTransactionAmount[from]
890                 ) {
891                     require(
892                         amount <= maxTransactionAmount,
893                         "Sell transfer amount exceeds the maxTransactionAmount."
894                     );
895                 } else if (!_isExcludedMaxTransactionAmount[to]) {
896                     require(
897                         amount + balanceOf(to) <= maxWallet,
898                         "Max wallet exceeded"
899                     );
900                 }
901             }
902         }
903 
904         uint256 contractTokenBalance = balanceOf(address(this));
905 
906         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
907 
908         if (
909             canSwap &&
910             swapEnabled &&
911             !swapping &&
912             !automatedMarketMakerPairs[from] &&
913             !_isExcludedFromFees[from] &&
914             !_isExcludedFromFees[to]
915         ) {
916             swapping = true;
917 
918             swapBack();
919 
920             swapping = false;
921         }
922 
923         if (
924             !swapping &&
925             automatedMarketMakerPairs[to] &&
926             lpBurnEnabled &&
927             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
928             !_isExcludedFromFees[from]
929         ) {
930             autoBurnLiquidityPairTokens();
931         }
932 
933         bool takeFee = !swapping;
934 
935         // if any account belongs to _isExcludedFromFee account then remove the fee
936         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
937             takeFee = false;
938         }
939 
940         uint256 fees = 0;
941         // only take fees on buys/sells, do not take on wallet transfers
942         if (takeFee) {
943             // on sell
944             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
945                 fees = amount.mul(sellTotalFees).div(100);
946                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
947                 tokensForDev += (fees * sellDevelopmentFee) / sellTotalFees;
948                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
949             }
950             // on buy
951             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
952                 fees = amount.mul(buyTotalFees).div(100);
953                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
954                 tokensForDev += (fees * buyDevelopmentFee) / buyTotalFees;
955                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
956             }
957 
958             if (fees > 0) {
959                 super._transfer(from, address(this), fees);
960             }
961 
962             amount -= fees;
963         }
964 
965         super._transfer(from, to, amount);
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
996             deadAddress,
997             block.timestamp
998         );
999     }
1000 
1001     function swapBack() private {
1002         uint256 contractBalance = balanceOf(address(this));
1003         uint256 totalTokensToSwap = tokensForLiquidity +
1004             tokensForMarketing +
1005             tokensForDev;
1006         bool success;
1007 
1008         if (contractBalance == 0 || totalTokensToSwap == 0) {
1009             return;
1010         }
1011 
1012         if (contractBalance > swapTokensAtAmount * 20) {
1013             contractBalance = swapTokensAtAmount * 20;
1014         }
1015 
1016         // Halve the amount of liquidity tokens
1017         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1018             totalTokensToSwap /
1019             2;
1020         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1021 
1022         uint256 initialETHBalance = address(this).balance;
1023 
1024         swapTokensForEth(amountToSwapForETH);
1025 
1026         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1027 
1028         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1029             totalTokensToSwap
1030         );
1031         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1032 
1033         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1034 
1035         tokensForLiquidity = 0;
1036         tokensForMarketing = 0;
1037         tokensForDev = 0;
1038 
1039         (success, ) = address(developmentWallet).call{value: ethForDev}("");
1040 
1041         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1042             addLiquidity(liquidityTokens, ethForLiquidity);
1043             emit SwapAndLiquify(
1044                 amountToSwapForETH,
1045                 ethForLiquidity,
1046                 tokensForLiquidity
1047             );
1048         }
1049 
1050         (success, ) = address(marketingWallet).call{
1051             value: address(this).balance
1052         }("");
1053     }
1054 
1055     function setAutoLPBurnSettings(
1056         uint256 _frequencyInSeconds,
1057         uint256 _percent,
1058         bool _Enabled
1059     ) external onlyOwner {
1060         require(
1061             _frequencyInSeconds >= 600,
1062             "cannot set buyback more often than every 10 minutes"
1063         );
1064         require(
1065             _percent <= 1000 && _percent >= 0,
1066             "Must set auto LP burn percent between 0% and 10%"
1067         );
1068         lpBurnFrequency = _frequencyInSeconds;
1069         percentForLPBurn = _percent;
1070         lpBurnEnabled = _Enabled;
1071     }
1072 
1073     function autoBurnLiquidityPairTokens() internal returns (bool) {
1074         lastLpBurnTime = block.timestamp;
1075 
1076         // get balance of liquidity pair
1077         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1078 
1079         // calculate amount to burn
1080         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1081             10000
1082         );
1083 
1084         // pull tokens from pancakePair liquidity and move to dead address permanently
1085         if (amountToBurn > 0) {
1086             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1087         }
1088 
1089         //sync price since this is not in a swap transaction!
1090         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1091         pair.sync();
1092         emit AutoNukeLP();
1093         return true;
1094     }
1095 
1096     function manualBurnLiquidityPairTokens(uint256 percent)
1097         external
1098         onlyOwner
1099         returns (bool)
1100     {
1101         require(
1102             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1103             "Must wait for cooldown to finish"
1104         );
1105         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1106         lastManualLpBurnTime = block.timestamp;
1107 
1108         // get balance of liquidity pair
1109         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1110 
1111         // calculate amount to burn
1112         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1113 
1114         // pull tokens from pancakePair liquidity and move to dead address permanently
1115         if (amountToBurn > 0) {
1116             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1117         }
1118 
1119         //sync price since this is not in a swap transaction!
1120         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1121         pair.sync();
1122         emit ManualNukeLP();
1123         return true;
1124     }
1125 }