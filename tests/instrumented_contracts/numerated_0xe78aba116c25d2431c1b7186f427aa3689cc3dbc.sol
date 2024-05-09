1 /**
2 
3 Website: https://dogeshit.io
4 TG:      https://t.me/dogeshiteth
5 Twitter: https://twitter.com/dogeshiteth
6 
7 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣤⡀⠀⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣤⣤⣄⠀⠀⠀
9 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣷⣶⣶
10 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣴⣶⣶⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟
11 ⠀⠀⠀⠀⣀⠀⠀⠀⣠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠛⠛⠁⠀
12 ⠀⠀⠀⢰⣿⣷⣦⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁⠀⠀⠀⠀⠀
13 ⠀⠀⠀⠀⠉⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀
14 ⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀
15 ⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
16 ⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⡇⠀⠀⢿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
17 ⠀⠀⢀⡄⠀⠀⠀⠀⠈⠻⣿⣿⣿⠇⠀⠀⢸⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
18 ⠀⣀⢼⣿⣦⡄⠀⠀⠀⢰⣿⣿⠏⠀⠀⠀⠈⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
19 ⠼⠿⠿⠿⠿⠿⠆⠀⠀⠿⠿⠏⠀⠀⠀⠀⠀⠹⠿⠿⠀
20 
21 
22 
23 **/
24 // SPDX-License-Identifier: MIT
25 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
26 pragma experimental ABIEncoderV2;
27 
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes calldata) {
34         return msg.data;
35     }
36 }
37 
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     constructor() {
44         _transferOwnership(_msgSender());
45     }
46 
47     function owner() public view virtual returns (address) {
48         return _owner;
49     }
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
60     function transferOwnership(address newOwner) public virtual onlyOwner {
61         require(newOwner != address(0), "Ownable: new owner is the zero address");
62         _transferOwnership(newOwner);
63     }
64 
65     function _transferOwnership(address newOwner) internal virtual {
66         address oldOwner = _owner;
67         _owner = newOwner;
68         emit OwnershipTransferred(oldOwner, newOwner);
69     }
70 }
71 
72 interface IERC20 {
73 
74     function totalSupply() external view returns (uint256);
75 
76     function balanceOf(address account) external view returns (uint256);
77 
78     function transfer(address recipient, uint256 amount) external returns (bool);
79 
80     function allowance(address owner, address spender) external view returns (uint256);
81 
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     function transferFrom(
85         address sender,
86         address recipient,
87         uint256 amount
88     ) external returns (bool);
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
104 contract ERC20 is Context, IERC20, IERC20Metadata {
105     mapping(address => uint256) private _balances;
106 
107     mapping(address => mapping(address => uint256)) private _allowances;
108 
109     uint256 private _totalSupply;
110 
111     string private _name;
112     string private _symbol;
113 
114     constructor(string memory name_, string memory symbol_) {
115         _name = name_;
116         _symbol = symbol_;
117     }
118 
119     function name() public view virtual override returns (string memory) {
120         return _name;
121     }
122 
123     function symbol() public view virtual override returns (string memory) {
124         return _symbol;
125     }
126 
127     function decimals() public view virtual override returns (uint8) {
128         return 18;
129     }
130 
131     function totalSupply() public view virtual override returns (uint256) {
132         return _totalSupply;
133     }
134 
135     function balanceOf(address account) public view virtual override returns (uint256) {
136         return _balances[account];
137     }
138 
139     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
140         _transfer(_msgSender(), recipient, amount);
141         return true;
142     }
143 
144     function allowance(address owner, address spender) public view virtual override returns (uint256) {
145         return _allowances[owner][spender];
146     }
147 
148     function approve(address spender, uint256 amount) public virtual override returns (bool) {
149         _approve(_msgSender(), spender, amount);
150         return true;
151     }
152 
153     function transferFrom(
154         address sender,
155         address recipient,
156         uint256 amount
157     ) public virtual override returns (bool) {
158         _transfer(sender, recipient, amount);
159 
160         uint256 currentAllowance = _allowances[sender][_msgSender()];
161         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
162         unchecked {
163             _approve(sender, _msgSender(), currentAllowance - amount);
164         }
165 
166         return true;
167     }
168 
169     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
170         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
171         return true;
172     }
173 
174     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
175         uint256 currentAllowance = _allowances[_msgSender()][spender];
176         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
177         unchecked {
178             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
179         }
180 
181         return true;
182     }
183 
184     function _transfer(
185         address sender,
186         address recipient,
187         uint256 amount
188     ) internal virtual {
189         require(sender != address(0), "ERC20: transfer from the zero address");
190         require(recipient != address(0), "ERC20: transfer to the zero address");
191 
192         _beforeTokenTransfer(sender, recipient, amount);
193 
194         uint256 senderBalance = _balances[sender];
195         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
196         unchecked {
197             _balances[sender] = senderBalance - amount;
198         }
199         _balances[recipient] += amount;
200 
201         emit Transfer(sender, recipient, amount);
202 
203         _afterTokenTransfer(sender, recipient, amount);
204     }
205 
206     function _mint(address account, uint256 amount) internal virtual {
207         require(account != address(0), "ERC20: mint to the zero address");
208 
209         _beforeTokenTransfer(address(0), account, amount);
210 
211         _totalSupply += amount;
212         _balances[account] += amount;
213         emit Transfer(address(0), account, amount);
214 
215         _afterTokenTransfer(address(0), account, amount);
216     }
217 
218     function _burn(address account, uint256 amount) internal virtual {
219         require(account != address(0), "ERC20: burn from the zero address");
220 
221         _beforeTokenTransfer(account, address(0), amount);
222 
223         uint256 accountBalance = _balances[account];
224         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
225         unchecked {
226             _balances[account] = accountBalance - amount;
227         }
228         _totalSupply -= amount;
229 
230         emit Transfer(account, address(0), amount);
231 
232         _afterTokenTransfer(account, address(0), amount);
233     }
234 
235     function _approve(
236         address owner,
237         address spender,
238         uint256 amount
239     ) internal virtual {
240         require(owner != address(0), "ERC20: approve from the zero address");
241         require(spender != address(0), "ERC20: approve to the zero address");
242 
243         _allowances[owner][spender] = amount;
244         emit Approval(owner, spender, amount);
245     }
246 
247     function _beforeTokenTransfer(
248         address from,
249         address to,
250         uint256 amount
251     ) internal virtual {}
252 
253     function _afterTokenTransfer(
254         address from,
255         address to,
256         uint256 amount
257     ) internal virtual {}
258 }
259 
260 library SafeMath {
261 
262     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
263         unchecked {
264             uint256 c = a + b;
265             if (c < a) return (false, 0);
266             return (true, c);
267         }
268     }
269 
270     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
271         unchecked {
272             if (b > a) return (false, 0);
273             return (true, a - b);
274         }
275     }
276 
277     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
278         unchecked {
279             if (a == 0) return (true, 0);
280             uint256 c = a * b;
281             if (c / a != b) return (false, 0);
282             return (true, c);
283         }
284     }
285 
286     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
287         unchecked {
288             if (b == 0) return (false, 0);
289             return (true, a / b);
290         }
291     }
292 
293     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
294         unchecked {
295             if (b == 0) return (false, 0);
296             return (true, a % b);
297         }
298     }
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
342     function mod(
343         uint256 a,
344         uint256 b,
345         string memory errorMessage
346     ) internal pure returns (uint256) {
347         unchecked {
348             require(b > 0, errorMessage);
349             return a % b;
350         }
351     }
352 }
353 
354 interface IUniswapV2Factory {
355     event PairCreated(
356         address indexed token0,
357         address indexed token1,
358         address pair,
359         uint256
360     );
361 
362     function feeTo() external view returns (address);
363 
364     function feeToSetter() external view returns (address);
365 
366     function getPair(address tokenA, address tokenB)
367         external
368         view
369         returns (address pair);
370 
371     function allPairs(uint256) external view returns (address pair);
372 
373     function allPairsLength() external view returns (uint256);
374 
375     function createPair(address tokenA, address tokenB)
376         external
377         returns (address pair);
378 
379     function setFeeTo(address) external;
380 
381     function setFeeToSetter(address) external;
382 }
383 
384 interface IUniswapV2Pair {
385     event Approval(
386         address indexed owner,
387         address indexed spender,
388         uint256 value
389     );
390     event Transfer(address indexed from, address indexed to, uint256 value);
391 
392     function name() external pure returns (string memory);
393 
394     function symbol() external pure returns (string memory);
395 
396     function decimals() external pure returns (uint8);
397 
398     function totalSupply() external view returns (uint256);
399 
400     function balanceOf(address owner) external view returns (uint256);
401 
402     function allowance(address owner, address spender)
403         external
404         view
405         returns (uint256);
406 
407     function approve(address spender, uint256 value) external returns (bool);
408 
409     function transfer(address to, uint256 value) external returns (bool);
410 
411     function transferFrom(
412         address from,
413         address to,
414         uint256 value
415     ) external returns (bool);
416 
417     function DOMAIN_SEPARATOR() external view returns (bytes32);
418 
419     function PERMIT_TYPEHASH() external pure returns (bytes32);
420 
421     function nonces(address owner) external view returns (uint256);
422 
423     function permit(
424         address owner,
425         address spender,
426         uint256 value,
427         uint256 deadline,
428         uint8 v,
429         bytes32 r,
430         bytes32 s
431     ) external;
432 
433     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
434     event Burn(
435         address indexed sender,
436         uint256 amount0,
437         uint256 amount1,
438         address indexed to
439     );
440     event Swap(
441         address indexed sender,
442         uint256 amount0In,
443         uint256 amount1In,
444         uint256 amount0Out,
445         uint256 amount1Out,
446         address indexed to
447     );
448     event Sync(uint112 reserve0, uint112 reserve1);
449 
450     function MINIMUM_LIQUIDITY() external pure returns (uint256);
451 
452     function factory() external view returns (address);
453 
454     function token0() external view returns (address);
455 
456     function token1() external view returns (address);
457 
458     function getReserves()
459         external
460         view
461         returns (
462             uint112 reserve0,
463             uint112 reserve1,
464             uint32 blockTimestampLast
465         );
466 
467     function price0CumulativeLast() external view returns (uint256);
468 
469     function price1CumulativeLast() external view returns (uint256);
470 
471     function kLast() external view returns (uint256);
472 
473     function mint(address to) external returns (uint256 liquidity);
474 
475     function burn(address to)
476         external
477         returns (uint256 amount0, uint256 amount1);
478 
479     function swap(
480         uint256 amount0Out,
481         uint256 amount1Out,
482         address to,
483         bytes calldata data
484     ) external;
485 
486     function skim(address to) external;
487 
488     function sync() external;
489 
490     function initialize(address, address) external;
491 }
492 
493 interface IUniswapV2Router02 {
494     function factory() external pure returns (address);
495 
496     function WETH() external pure returns (address);
497 
498     function addLiquidity(
499         address tokenA,
500         address tokenB,
501         uint256 amountADesired,
502         uint256 amountBDesired,
503         uint256 amountAMin,
504         uint256 amountBMin,
505         address to,
506         uint256 deadline
507     )
508         external
509         returns (
510             uint256 amountA,
511             uint256 amountB,
512             uint256 liquidity
513         );
514 
515     function addLiquidityETH(
516         address token,
517         uint256 amountTokenDesired,
518         uint256 amountTokenMin,
519         uint256 amountETHMin,
520         address to,
521         uint256 deadline
522     )
523         external
524         payable
525         returns (
526             uint256 amountToken,
527             uint256 amountETH,
528             uint256 liquidity
529         );
530 
531     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
532         uint256 amountIn,
533         uint256 amountOutMin,
534         address[] calldata path,
535         address to,
536         uint256 deadline
537     ) external;
538 
539     function swapExactETHForTokensSupportingFeeOnTransferTokens(
540         uint256 amountOutMin,
541         address[] calldata path,
542         address to,
543         uint256 deadline
544     ) external payable;
545 
546     function swapExactTokensForETHSupportingFeeOnTransferTokens(
547         uint256 amountIn,
548         uint256 amountOutMin,
549         address[] calldata path,
550         address to,
551         uint256 deadline
552     ) external;
553 }
554 
555 contract Dogeshit is ERC20, Ownable {
556     using SafeMath for uint256;
557 
558     IUniswapV2Router02 public immutable uniswapV2Router;
559     address public immutable uniswapV2Pair;
560     address public constant deadAddress = address(0xdead);
561 
562     bool private swapping;
563 
564     address public marketingWallet;
565     address public devWallet;
566     address public liqWallet;
567 
568     uint256 public maxTransactionAmount;
569     uint256 public swapTokensAtAmount;
570     uint256 public maxWallet;
571 
572     bool public limitsInEffect = true;
573     bool public tradingActive = false;
574     bool public swapEnabled = false;
575 
576     // Anti-bot and anti-whale mappings and variables
577     mapping(address => uint256) private _holderLastTransferTimestamp;
578     bool public transferDelayEnabled = true;
579 
580     uint256 public buyTotalFees;
581     uint256 public buyMarketingFee;
582     uint256 public buyLiquidityFee;
583     uint256 public buyDevFee;
584 
585     uint256 public sellTotalFees;
586     uint256 public sellMarketingFee;
587     uint256 public sellLiquidityFee;
588     uint256 public sellDevFee;
589 
590     uint256 public tokensForMarketing;
591     uint256 public tokensForLiquidity;
592     uint256 public tokensForDev;
593 
594     mapping(address => bool) private _isExcludedFromFees;
595     mapping(address => bool) public _isExcludedMaxTransactionAmount;
596 
597     mapping(address => bool) public automatedMarketMakerPairs;
598 
599     event UpdateUniswapV2Router(
600         address indexed newAddress,
601         address indexed oldAddress
602     );
603 
604     event ExcludeFromFees(address indexed account, bool isExcluded);
605 
606     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
607 
608     event marketingWalletUpdated(
609         address indexed newWallet,
610         address indexed oldWallet
611     );
612 
613     event devWalletUpdated(
614         address indexed newWallet,
615         address indexed oldWallet
616     );
617 
618     event liqWalletUpdated(
619         address indexed newWallet,
620         address indexed oldWallet
621     );
622 
623     event SwapAndLiquify(
624         uint256 tokensSwapped,
625         uint256 ethReceived,
626         uint256 tokensIntoLiquidity
627     );
628 
629     constructor() ERC20("Dogeshit", "SHIT") {
630         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
631             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
632         );
633 
634         excludeFromMaxTransaction(address(_uniswapV2Router), true);
635         uniswapV2Router = _uniswapV2Router;
636 
637         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
638             .createPair(address(this), _uniswapV2Router.WETH());
639         excludeFromMaxTransaction(address(uniswapV2Pair), true);
640         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
641 
642         uint256 _buyMarketingFee = 3;
643         uint256 _buyLiquidityFee = 1;
644         uint256 _buyDevFee = 0;
645 
646         uint256 _sellMarketingFee = 3;
647         uint256 _sellLiquidityFee = 1;
648         uint256 _sellDevFee = 0;
649 
650         uint256 totalSupply = 1_000_000 * 1e18;
651 
652         maxTransactionAmount = 10_000 * 1e18; // 1% from total supply maxTransactionAmountTxn
653         maxWallet = 20_000 * 1e18; // 2% from total supply maxWallet
654         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
655 
656         buyMarketingFee = _buyMarketingFee;
657         buyLiquidityFee = _buyLiquidityFee;
658         buyDevFee = _buyDevFee;
659         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
660 
661         sellMarketingFee = _sellMarketingFee;
662         sellLiquidityFee = _sellLiquidityFee;
663         sellDevFee = _sellDevFee;
664         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
665 
666         marketingWallet = address(0xDEAD5D322907894B50A4CBbc3658009758dd4dfC);
667         devWallet = address(0xDEAD5D322907894B50A4CBbc3658009758dd4dfC);
668         liqWallet = address(0xDEAD5D322907894B50A4CBbc3658009758dd4dfC);
669 
670         // exclude from paying fees or having max transaction amount
671         excludeFromFees(owner(), true);
672         excludeFromFees(address(this), true);
673         excludeFromFees(address(0xdead), true);
674 
675         excludeFromMaxTransaction(owner(), true);
676         excludeFromMaxTransaction(address(this), true);
677         excludeFromMaxTransaction(address(0xdead), true);
678 
679         _mint(msg.sender, totalSupply);
680     }
681 
682     receive() external payable {}
683 
684     function enableTrading() external onlyOwner {
685         tradingActive = true;
686         swapEnabled = true;
687     }
688 
689     // remove limits after token is stable
690     function removeLimits() external onlyOwner returns (bool) {
691         limitsInEffect = false;
692         return true;
693     }
694 
695     // disable Transfer delay - cannot be reenabled
696     function disableTransferDelay() external onlyOwner returns (bool) {
697         transferDelayEnabled = false;
698         return true;
699     }
700 
701     // change the minimum amount of tokens to sell from fees
702     function updateSwapTokensAtAmount(uint256 newAmount)
703         external
704         onlyOwner
705         returns (bool)
706     {
707         require(
708             newAmount >= (totalSupply() * 1) / 100000,
709             "Swap amount cannot be lower than 0.001% total supply."
710         );
711         require(
712             newAmount <= (totalSupply() * 5) / 1000,
713             "Swap amount cannot be higher than 0.5% total supply."
714         );
715         swapTokensAtAmount = newAmount;
716         return true;
717     }
718 
719     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
720         require(
721             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
722             "Cannot set maxTransactionAmount lower than 0.1%"
723         );
724         maxTransactionAmount = newNum * (10**18);
725     }
726 
727     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
728         require(
729             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
730             "Cannot set maxWallet lower than 0.5%"
731         );
732         maxWallet = newNum * (10**18);
733     }
734 
735     function excludeFromMaxTransaction(address updAds, bool isEx)
736         public
737         onlyOwner
738     {
739         _isExcludedMaxTransactionAmount[updAds] = isEx;
740     }
741 
742     // only use to disable contract sales if absolutely necessary (emergency use only)
743     function updateSwapEnabled(bool enabled) external onlyOwner {
744         swapEnabled = enabled;
745     }
746 
747     function updateBuyFees(
748         uint256 _marketingFee,
749         uint256 _liquidityFee,
750         uint256 _devFee
751     ) external onlyOwner {
752         buyMarketingFee = _marketingFee;
753         buyLiquidityFee = _liquidityFee;
754         buyDevFee = _devFee;
755         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
756         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
757     }
758 
759     function updateSellFees(
760         uint256 _marketingFee,
761         uint256 _liquidityFee,
762         uint256 _devFee
763     ) external onlyOwner {
764         sellMarketingFee = _marketingFee;
765         sellLiquidityFee = _liquidityFee;
766         sellDevFee = _devFee;
767         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
768         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
769     }
770 
771     function excludeFromFees(address account, bool excluded) public onlyOwner {
772         _isExcludedFromFees[account] = excluded;
773         emit ExcludeFromFees(account, excluded);
774     }
775 
776     function setAutomatedMarketMakerPair(address pair, bool value)
777         public
778         onlyOwner
779     {
780         require(
781             pair != uniswapV2Pair,
782             "The pair cannot be removed from automatedMarketMakerPairs"
783         );
784 
785         _setAutomatedMarketMakerPair(pair, value);
786     }
787 
788     function _setAutomatedMarketMakerPair(address pair, bool value) private {
789         automatedMarketMakerPairs[pair] = value;
790 
791         emit SetAutomatedMarketMakerPair(pair, value);
792     }
793 
794     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
795         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
796         marketingWallet = newMarketingWallet;
797     }
798 
799     function updateDevWallet(address newWallet) external onlyOwner {
800         emit devWalletUpdated(newWallet, devWallet);
801         devWallet = newWallet;
802     }
803 
804     function updateLiqWallet(address newLiqWallet) external onlyOwner {
805         emit liqWalletUpdated(newLiqWallet, liqWallet);
806         liqWallet = newLiqWallet;
807     }
808 
809     function isExcludedFromFees(address account) public view returns (bool) {
810         return _isExcludedFromFees[account];
811     }
812 
813     event BoughtEarly(address indexed sniper);
814 
815     function _transfer(
816         address from,
817         address to,
818         uint256 amount
819     ) internal override {
820         require(from != address(0), "ERC20: transfer from the zero address");
821         require(to != address(0), "ERC20: transfer to the zero address");
822 
823         if (amount == 0) {
824             super._transfer(from, to, 0);
825             return;
826         }
827 
828         if (limitsInEffect) {
829             if (
830                 from != owner() &&
831                 to != owner() &&
832                 to != address(0) &&
833                 to != address(0xdead) &&
834                 !swapping
835             ) {
836                 if (!tradingActive) {
837                     require(
838                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
839                         "Trading is not active."
840                     );
841                 }
842 
843                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
844                 if (transferDelayEnabled) {
845                     if (
846                         to != owner() &&
847                         to != address(uniswapV2Router) &&
848                         to != address(uniswapV2Pair)
849                     ) {
850                         require(
851                             _holderLastTransferTimestamp[tx.origin] <
852                                 block.number,
853                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
854                         );
855                         _holderLastTransferTimestamp[tx.origin] = block.number;
856                     }
857                 }
858 
859                 //when buy
860                 if (
861                     automatedMarketMakerPairs[from] &&
862                     !_isExcludedMaxTransactionAmount[to]
863                 ) {
864                     require(
865                         amount <= maxTransactionAmount,
866                         "Buy transfer amount exceeds the maxTransactionAmount."
867                     );
868                     require(
869                         amount + balanceOf(to) <= maxWallet,
870                         "Max wallet exceeded"
871                     );
872                 }
873                 //when sell
874                 else if (
875                     automatedMarketMakerPairs[to] &&
876                     !_isExcludedMaxTransactionAmount[from]
877                 ) {
878                     require(
879                         amount <= maxTransactionAmount,
880                         "Sell transfer amount exceeds the maxTransactionAmount."
881                     );
882                 } else if (!_isExcludedMaxTransactionAmount[to]) {
883                     require(
884                         amount + balanceOf(to) <= maxWallet,
885                         "Max wallet exceeded"
886                     );
887                 }
888             }
889         }
890 
891         uint256 contractTokenBalance = balanceOf(address(this));
892 
893         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
894 
895         if (
896             canSwap &&
897             swapEnabled &&
898             !swapping &&
899             !automatedMarketMakerPairs[from] &&
900             !_isExcludedFromFees[from] &&
901             !_isExcludedFromFees[to]
902         ) {
903             swapping = true;
904 
905             swapBack();
906 
907             swapping = false;
908         }
909 
910         bool takeFee = !swapping;
911 
912         // if any account belongs to _isExcludedFromFee account then remove the fee
913         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
914             takeFee = false;
915         }
916 
917         uint256 fees = 0;
918         // only take fees on buys/sells, do not take on wallet transfers
919         if (takeFee) {
920             // on sell
921             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
922                 fees = amount.mul(sellTotalFees).div(100);
923                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
924                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
925                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
926             }
927             // on buy
928             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
929                 fees = amount.mul(buyTotalFees).div(100);
930                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
931                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
932                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
933             }
934 
935             if (fees > 0) {
936                 super._transfer(from, address(this), fees);
937             }
938 
939             amount -= fees;
940         }
941 
942         super._transfer(from, to, amount);
943     }
944 
945     function swapTokensForEth(uint256 tokenAmount) private {
946         // generate the uniswap pair path of token -> weth
947         address[] memory path = new address[](2);
948         path[0] = address(this);
949         path[1] = uniswapV2Router.WETH();
950 
951         _approve(address(this), address(uniswapV2Router), tokenAmount);
952 
953         // make the swap
954         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
955             tokenAmount,
956             0, // accept any amount of ETH
957             path,
958             address(this),
959             block.timestamp
960         );
961     }
962 
963     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
964         // approve token transfer to cover all possible scenarios
965         _approve(address(this), address(uniswapV2Router), tokenAmount);
966 
967         // add the liquidity
968         uniswapV2Router.addLiquidityETH{value: ethAmount}(
969             address(this),
970             tokenAmount,
971             0, // slippage is unavoidable
972             0, // slippage is unavoidable
973             liqWallet,
974             block.timestamp
975         );
976     }
977 
978     function swapBack() private {
979         uint256 contractBalance = balanceOf(address(this));
980         uint256 totalTokensToSwap = tokensForLiquidity +
981             tokensForMarketing +
982             tokensForDev;
983         bool success;
984 
985         if (contractBalance == 0 || totalTokensToSwap == 0) {
986             return;
987         }
988 
989         if (contractBalance > swapTokensAtAmount * 20) {
990             contractBalance = swapTokensAtAmount * 20;
991         }
992 
993         // Halve the amount of liquidity tokens
994         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
995             totalTokensToSwap /
996             2;
997         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
998 
999         uint256 initialETHBalance = address(this).balance;
1000 
1001         swapTokensForEth(amountToSwapForETH);
1002 
1003         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1004 
1005         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1006             totalTokensToSwap
1007         );
1008         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1009 
1010         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1011 
1012         tokensForLiquidity = 0;
1013         tokensForMarketing = 0;
1014         tokensForDev = 0;
1015 
1016         (success, ) = address(devWallet).call{value: ethForDev}("");
1017 
1018         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1019             addLiquidity(liquidityTokens, ethForLiquidity);
1020             emit SwapAndLiquify(
1021                 amountToSwapForETH,
1022                 ethForLiquidity,
1023                 tokensForLiquidity
1024             );
1025         }
1026 
1027         (success, ) = address(marketingWallet).call{
1028             value: address(this).balance
1029         }("");
1030     }
1031 }