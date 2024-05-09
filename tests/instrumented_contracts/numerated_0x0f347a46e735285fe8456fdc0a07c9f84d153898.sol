1 pragma solidity ^0.8.10;
2 // SPDX-License-Identifier: MIT
3 
4 pragma experimental ABIEncoderV2;
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 abstract contract Ownable is Context {
16     address private _owner;
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19     constructor() {
20         _transferOwnership(_msgSender());
21     }
22 
23     function owner() public view virtual returns (address) {
24         return _owner;
25     }
26     modifier onlyOwner() {
27         require(owner() == _msgSender(), "Ownable: caller is not the owner");
28         _;
29     }
30     function renounceOwnership() public virtual onlyOwner {
31         _transferOwnership(address(0));
32     }
33     function transferOwnership(address newOwner) public virtual onlyOwner {
34         require(newOwner != address(0), "Ownable: new owner is the zero address");
35         _transferOwnership(newOwner);
36     }
37 
38     function _transferOwnership(address newOwner) internal virtual {
39         address oldOwner = _owner;
40         _owner = newOwner;
41         emit OwnershipTransferred(oldOwner, newOwner);
42     }
43 }
44 
45 interface IERC20 {
46     function totalSupply() external view returns (uint256);
47     function balanceOf(address account) external view returns (uint256);
48     function transfer(address recipient, uint256 amount) external returns (bool);
49     function allowance(address owner, address spender) external view returns (uint256);
50     function approve(address spender, uint256 amount) external returns (bool);
51     function transferFrom(
52         address sender,
53         address recipient,
54         uint256 amount
55     ) external returns (bool);
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 interface IERC20Metadata is IERC20 {
60     function name() external view returns (string memory);
61     function symbol() external view returns (string memory);
62     function decimals() external view returns (uint8);
63 }
64 
65 contract ERC20 is Context, IERC20, IERC20Metadata {
66     mapping(address => uint256) private _balances;
67 
68     mapping(address => mapping(address => uint256)) private _allowances;
69 
70     uint256 private _totalSupply;
71     string private _name;
72     string private _symbol;
73     constructor(string memory name_, string memory symbol_) {
74         _name = name_;
75         _symbol = symbol_;
76     }
77     function name() public view virtual override returns (string memory) {
78         return _name;
79     }
80     function symbol() public view virtual override returns (string memory) {
81         return _symbol;
82     }
83     function decimals() public view virtual override returns (uint8) {
84         return 18;
85     }
86 
87     function totalSupply() public view virtual override returns (uint256) {
88         return _totalSupply;
89     }
90     function balanceOf(address account) public view virtual override returns (uint256) {
91         return _balances[account];
92     }
93 
94     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
95         _transfer(_msgSender(), recipient, amount);
96         return true;
97     }
98     function allowance(address owner, address spender) public view virtual override returns (uint256) {
99         return _allowances[owner][spender];
100     }
101     function approve(address spender, uint256 amount) public virtual override returns (bool) {
102         _approve(_msgSender(), spender, amount);
103         return true;
104     }
105 
106     function transferFrom(
107         address sender,
108         address recipient,
109         uint256 amount
110     ) public virtual override returns (bool) {
111         _transfer(sender, recipient, amount);
112 
113         uint256 currentAllowance = _allowances[sender][_msgSender()];
114         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
115         unchecked {
116             _approve(sender, _msgSender(), currentAllowance - amount);
117         }
118 
119         return true;
120     }
121 
122     function _transfer(
123         address sender,
124         address recipient,
125         uint256 amount
126     ) internal virtual {
127         require(sender != address(0), "ERC20: transfer from the zero address");
128         require(recipient != address(0), "ERC20: transfer to the zero address");
129 
130         _beforeTokenTransfer(sender, recipient, amount);
131 
132         uint256 senderBalance = _balances[sender];
133         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
134         unchecked {
135             _balances[sender] = senderBalance - amount;
136         }
137         _balances[recipient] += amount;
138 
139         emit Transfer(sender, recipient, amount);
140 
141         _afterTokenTransfer(sender, recipient, amount);
142     }
143 
144     function _mint(address account, uint256 amount) internal virtual {
145         require(account != address(0), "ERC20: mint to the zero address");
146 
147         _beforeTokenTransfer(address(0), account, amount);
148 
149         _totalSupply += amount;
150         _balances[account] += amount;
151         emit Transfer(address(0), account, amount);
152 
153         _afterTokenTransfer(address(0), account, amount);
154     }
155 
156     function _approve(
157         address owner,
158         address spender,
159         uint256 amount
160     ) internal virtual {
161         require(owner != address(0), "ERC20: approve from the zero address");
162         require(spender != address(0), "ERC20: approve to the zero address");
163 
164         _allowances[owner][spender] = amount;
165         emit Approval(owner, spender, amount);
166     }
167 
168     function _beforeTokenTransfer(
169         address from,
170         address to,
171         uint256 amount
172     ) internal virtual {}
173 
174     function _afterTokenTransfer(
175         address from,
176         address to,
177         uint256 amount
178     ) internal virtual {}
179 }
180 
181 library SafeMath {
182     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
183         unchecked {
184             uint256 c = a + b;
185             if (c < a) return (false, 0);
186             return (true, c);
187         }
188     }
189 
190     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
191         unchecked {
192             if (b > a) return (false, 0);
193             return (true, a - b);
194         }
195     }
196     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
197         unchecked {
198             if (a == 0) return (true, 0);
199             uint256 c = a * b;
200             if (c / a != b) return (false, 0);
201             return (true, c);
202         }
203     }
204     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
205         unchecked {
206             if (b == 0) return (false, 0);
207             return (true, a / b);
208         }
209     }
210 
211     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
212         unchecked {
213             if (b == 0) return (false, 0);
214             return (true, a % b);
215         }
216     }
217     function add(uint256 a, uint256 b) internal pure returns (uint256) {
218         return a + b;
219     }
220     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
221         return a - b;
222     }
223     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
224         return a * b;
225     }
226     function div(uint256 a, uint256 b) internal pure returns (uint256) {
227         return a / b;
228     }
229     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
230         return a % b;
231     }
232     function sub(
233         uint256 a,
234         uint256 b,
235         string memory errorMessage
236     ) internal pure returns (uint256) {
237         unchecked {
238             require(b <= a, errorMessage);
239             return a - b;
240         }
241     }
242     function div(
243         uint256 a,
244         uint256 b,
245         string memory errorMessage
246     ) internal pure returns (uint256) {
247         unchecked {
248             require(b > 0, errorMessage);
249             return a / b;
250         }
251     }
252 
253     function mod(
254         uint256 a,
255         uint256 b,
256         string memory errorMessage
257     ) internal pure returns (uint256) {
258         unchecked {
259             require(b > 0, errorMessage);
260             return a % b;
261         }
262     }
263 }
264 
265 interface IUniswapV2Factory {
266     event PairCreated(
267         address indexed token0,
268         address indexed token1,
269         address pair,
270         uint256
271     );
272 
273     function createPair(address tokenA, address tokenB)
274         external
275         returns (address pair);
276 }
277 
278 interface IUniswapV2Router02 {
279     function factory() external pure returns (address);
280 
281     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
282         uint256 amountIn,
283         uint256 amountOutMin,
284         address[] calldata path,
285         address to,
286         uint256 deadline
287     ) external;
288 }
289 
290 contract Koshu is ERC20, Ownable {
291     using SafeMath for uint256;
292 
293     IUniswapV2Router02 public immutable uniswapV2Router;
294     address public immutable uniswapV2Pair;
295     address public constant deadAddress = address(0xdead);
296     address public DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
297 
298     bool private swapping;
299 
300     address public devWallet;
301 
302     uint256 public maxTransactionAmount;
303     uint256 public swapTokensAtAmount;
304     uint256 public maxWallet;
305 
306     bool public limitsInEffect = true;
307     bool public tradingActive = false;
308     bool public swapEnabled = false;
309 
310     uint256 public buyTotalFees;
311     uint256 public buyDevFee;
312     uint256 public buyLiquidityFee;
313 
314     uint256 public sellTotalFees;
315     uint256 public sellDevFee;
316     uint256 public sellLiquidityFee;
317 
318     mapping(address => bool) private _isExcludedFromFees;
319     mapping(address => bool) public _isExcludedMaxTransactionAmount;
320 
321 
322     event ExcludeFromFees(address indexed account, bool isExcluded);
323 
324     event devWalletUpdated(
325         address indexed newWallet,
326         address indexed oldWallet
327     );
328 
329     constructor() ERC20("Koshu Misaka", "Koshu") {
330         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
331             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
332         );
333 
334         excludeFromMaxTransaction(address(_uniswapV2Router), true);
335         uniswapV2Router = _uniswapV2Router;
336 
337         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
338             .createPair(address(this), DAI);
339         excludeFromMaxTransaction(address(uniswapV2Pair), true);
340 
341 
342         uint256 _buyDevFee = 6;
343         uint256 _buyLiquidityFee = 0;
344 
345         uint256 _sellDevFee = 6;
346         uint256 _sellLiquidityFee = 0;
347 
348         uint256 totalSupply = 100_000_000_000 * 1e18;
349 
350         maxTransactionAmount =  totalSupply * 2 / 100;
351         maxWallet = totalSupply * 2 / 100;
352         swapTokensAtAmount = (totalSupply * 5) / 10000;
353 
354         buyDevFee = _buyDevFee;
355         buyLiquidityFee = _buyLiquidityFee;
356         buyTotalFees = buyDevFee + buyLiquidityFee;
357 
358         sellDevFee = _sellDevFee;
359         sellLiquidityFee = _sellLiquidityFee;
360         sellTotalFees = sellDevFee + sellLiquidityFee;
361 
362         devWallet = address(0x37f681323AE7eeD30449E804607702020a97d4B6); 
363 
364         excludeFromFees(owner(), true);
365         excludeFromFees(address(this), true);
366         excludeFromFees(address(0xdead), true);
367 
368         excludeFromMaxTransaction(owner(), true);
369         excludeFromMaxTransaction(address(this), true);
370         excludeFromMaxTransaction(address(0xdead), true);
371         _mint(msg.sender, totalSupply);
372     }
373 
374     receive() external payable {}
375 
376     function enableTrading() external onlyOwner {
377         tradingActive = true;
378         swapEnabled = true;
379     }
380 
381     function removeLimits() external onlyOwner returns (bool) {
382         limitsInEffect = false;
383         return true;
384     }
385 
386     function updateSwapTokensAtAmount(uint256 newAmount)
387         external
388         onlyOwner
389         returns (bool)
390     {
391         require(
392             newAmount >= (totalSupply() * 1) / 100000,
393             "Swap amount cannot be lower than 0.001% total supply."
394         );
395         require(
396             newAmount <= (totalSupply() * 5) / 1000,
397             "Swap amount cannot be higher than 0.5% total supply."
398         );
399         swapTokensAtAmount = newAmount;
400         return true;
401     }
402 
403     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
404         require(
405             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
406             "Cannot set maxTransactionAmount lower than 0.1%"
407         );
408         maxTransactionAmount = newNum * (10**18);
409     }
410 
411     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
412         require(
413             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
414             "Cannot set maxWallet lower than 0.5%"
415         );
416         maxWallet = newNum * (10**18);
417     }
418 
419     function excludeFromMaxTransaction(address updAds, bool isEx)
420         public
421         onlyOwner
422     {
423         _isExcludedMaxTransactionAmount[updAds] = isEx;
424     }
425 
426     function updateSwapEnabled(bool enabled) external onlyOwner {
427         swapEnabled = enabled;
428     }
429 
430     function updateBuyFees(
431         uint256 _devFee,
432         uint256 _liquidityFee
433     ) external onlyOwner {
434         buyDevFee = _devFee;
435         buyLiquidityFee = _liquidityFee;
436         buyTotalFees = buyDevFee + buyLiquidityFee;
437         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
438     }
439 
440     function updateSellFees(
441         uint256 _devFee,
442         uint256 _liquidityFee
443     ) external onlyOwner {
444         sellDevFee = _devFee;
445         sellLiquidityFee = _liquidityFee;
446         sellTotalFees = sellDevFee + sellLiquidityFee;
447         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
448     }
449 
450     function excludeFromFees(address account, bool excluded) public onlyOwner {
451         _isExcludedFromFees[account] = excluded;
452         emit ExcludeFromFees(account, excluded);
453     }
454 
455     function updateDevWallet(address newDevWallet)
456         external
457         onlyOwner
458     {
459         emit devWalletUpdated(newDevWallet, devWallet);
460         devWallet = newDevWallet;
461     }
462 
463 
464     function isExcludedFromFees(address account) public view returns (bool) {
465         return _isExcludedFromFees[account];
466     }
467 
468     function _transfer(
469         address from,
470         address to,
471         uint256 amount
472     ) internal override {
473         require(from != address(0), "ERC20: transfer from the zero address");
474         require(to != address(0), "ERC20: transfer to the zero address");
475 
476         if (amount == 0) {
477             super._transfer(from, to, 0);
478             return;
479         }
480 
481         if (limitsInEffect) {
482             if (
483                 from != owner() &&
484                 to != owner() &&
485                 to != address(0) &&
486                 to != address(0xdead) &&
487                 !swapping
488             ) {
489                 if (!tradingActive) {
490                     require(
491                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
492                         "Trading is not active."
493                     );
494                 }
495 
496                 if (
497                     from == uniswapV2Pair &&
498                     !_isExcludedMaxTransactionAmount[to]
499                 ) {
500                     require(
501                         amount <= maxTransactionAmount,
502                         "Buy transfer amount exceeds the maxTransactionAmount."
503                     );
504                     require(
505                         amount + balanceOf(to) <= maxWallet,
506                         "Max wallet exceeded"
507                     );
508                 }
509                 else if (!_isExcludedMaxTransactionAmount[to]) {
510                     require(
511                         amount + balanceOf(to) <= maxWallet,
512                         "Max wallet exceeded"
513                     );
514                 }
515             }
516         }
517 
518         uint256 contractTokenBalance = balanceOf(address(this));
519 
520         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
521 
522         if (
523             canSwap &&
524             swapEnabled &&
525             !swapping &&
526             to == uniswapV2Pair &&
527             !_isExcludedFromFees[from] &&
528             !_isExcludedFromFees[to]
529         ) {
530             swapping = true;
531 
532             swapBack();
533 
534             swapping = false;
535         }
536 
537         bool takeFee = !swapping;
538         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
539             takeFee = false;
540         }
541 
542         uint256 fees = 0;
543         uint256 tokensForLiquidity = 0;
544         uint256 tokensForDev = 0;
545         if (takeFee) {
546             if (to == uniswapV2Pair && sellTotalFees > 0) {
547                 fees = amount.mul(sellTotalFees).div(100);
548                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
549                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
550             }
551             else if (from == uniswapV2Pair && buyTotalFees > 0) {
552                 fees = amount.mul(buyTotalFees).div(100);
553                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
554                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
555             }
556 
557             if (fees> 0) {
558                 super._transfer(from, address(this), fees);
559             }
560             if (tokensForLiquidity > 0) {
561                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
562             }
563 
564             amount -= fees;
565         }
566 
567         super._transfer(from, to, amount);
568     }
569 
570     function swapTokensForDAI(uint256 tokenAmount) private {
571         address[] memory path = new address[](2);
572         path[0] = address(this);
573         path[1] = DAI;
574 
575         _approve(address(this), address(uniswapV2Router), tokenAmount);
576 
577         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
578             tokenAmount,
579             0,
580             path,
581             devWallet,
582             block.timestamp
583         );
584     }
585 
586     function swapBack() private {
587         uint256 contractBalance = balanceOf(address(this));
588         if (contractBalance == 0) {
589             return;
590         }
591 
592         if (contractBalance > swapTokensAtAmount * 20) {
593             contractBalance = swapTokensAtAmount * 20;
594         }
595 
596         swapTokensForDAI(contractBalance);
597     }
598 
599 }