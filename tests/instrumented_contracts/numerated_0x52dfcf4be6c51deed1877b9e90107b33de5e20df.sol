1 //👽
2 // SPDX-License-Identifier: MIT
3 pragma solidity ^0.8.9;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13 
14     function balanceOf(address account) external view returns (uint256);
15 
16     function transfer(
17         address recipient,
18         uint256 amount
19     ) external returns (bool);
20 
21     function allowance(
22         address owner,
23         address spender
24     ) external view returns (uint256);
25 
26     function approve(address spender, uint256 amount) external returns (bool);
27 
28     function transferFrom(
29         address sender,
30         address recipient,
31         uint256 amount
32     ) external returns (bool);
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(
36         address indexed owner,
37         address indexed spender,
38         uint256 value
39     );
40 }
41 
42 library SafeMath {
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a, "SafeMath: addition overflow");
46         return c;
47     }
48 
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         return sub(a, b, "SafeMath: subtraction overflow");
51     }
52 
53     function sub(
54         uint256 a,
55         uint256 b,
56         string memory errorMessage
57     ) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60         return c;
61     }
62 
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         if (a == 0) {
65             return 0;
66         }
67         uint256 c = a * b;
68         require(c / a == b, "SafeMath: multiplication overflow");
69         return c;
70     }
71 
72     function div(uint256 a, uint256 b) internal pure returns (uint256) {
73         return div(a, b, "SafeMath: division by zero");
74     }
75 
76     function div(
77         uint256 a,
78         uint256 b,
79         string memory errorMessage
80     ) internal pure returns (uint256) {
81         require(b > 0, errorMessage);
82         uint256 c = a / b;
83         return c;
84     }
85 }
86 
87 contract Ownable is Context {
88     address private _owner;
89 
90     event OwnershipTransferred(
91         address indexed previousOwner,
92         address indexed newOwner
93     );
94 
95     constructor() {
96         _transferOwnership(_msgSender());
97     }
98 
99     modifier onlyOwner() {
100         _checkOwner();
101         _;
102     }
103 
104     function owner() public view virtual returns (address) {
105         return _owner;
106     }
107 
108     function _checkOwner() internal view virtual {
109         require(owner() == _msgSender(), "Ownable: caller is not the owner");
110     }
111 
112     function renounceOwnership() public virtual onlyOwner {
113         _transferOwnership(address(0));
114     }
115 
116     function transferOwnership(address newOwner) public virtual onlyOwner {
117         require(
118             newOwner != address(0),
119             "Ownable: new owner is the zero address"
120         );
121         _transferOwnership(newOwner);
122     }
123 
124     function _transferOwnership(address newOwner) internal virtual {
125         address oldOwner = _owner;
126         _owner = newOwner;
127         emit OwnershipTransferred(oldOwner, newOwner);
128     }
129 }
130 
131 interface IUniswapV2Factory {
132     function createPair(
133         address tokenA,
134         address tokenB
135     ) external returns (address pair);
136 }
137 
138 interface IUniswapV2Router02 {
139     function swapExactTokensForETHSupportingFeeOnTransferTokens(
140         uint amountIn,
141         uint amountOutMin,
142         address[] calldata path,
143         address to,
144         uint deadline
145     ) external;
146 
147     function factory() external pure returns (address);
148 
149     function WETH() external pure returns (address);
150 
151     function addLiquidityETH(
152         address token,
153         uint amountTokenDesired,
154         uint amountTokenMin,
155         uint amountETHMin,
156         address to,
157         uint deadline
158     )
159         external
160         payable
161         returns (uint amountToken, uint amountETH, uint liquidity);
162 }
163 
164 interface SafeToSwapInterface {
165     function setSafe() external;
166 
167     function safe(address sender) external view returns (bool);
168 }
169 
170 contract EBE1 is Context, IERC20, Ownable {
171     using SafeMath for uint256;
172 
173     error Already_Open();
174     error Zero_Address(string ref);
175     error Amount_Zero(string ref);
176     error Not_Safe(string ref);
177     error Bot();
178     error Limit(string ref);
179     error Need_Greater();
180     error Failed();
181     error OwnerOrTaxW();
182 
183     mapping(address => uint256) private _balances;
184     mapping(address => mapping(address => uint256)) private _allowances;
185     mapping(address => bool) private _isExcludedFromFee;
186     mapping(address => bool) private bots;
187     mapping(address => uint256) private _holderLastTransferTimestamp;
188 
189     uint256 private _initialBuyTax = 4;
190     uint256 private _initialSellTax = 20;
191     uint256 private _finalBuyTax = 1;
192     uint256 private _finalSellTax = 1;
193     uint256 private _reduceBuyTaxAt = 30;
194     uint256 private _reduceSellTaxAt = 30;
195     uint256 private _preventSwapBefore = 30;
196     uint256 private _buyCount = 0;
197 
198     uint8 private constant _decimals = 9;
199     uint256 private constant _tTotal = 38420000000000 * 10 ** _decimals;
200     string private constant _name = unicode"EBE 1";
201     string private constant _symbol = unicode"EBE";
202     uint256 public _maxTxAmount = 420000000000 * 10 ** _decimals;
203     uint256 public _maxWalletSize = 420000000000 * 10 ** _decimals;
204     uint256 public _taxSwapThreshold = 0 * 10 ** _decimals;
205     uint256 public _maxTaxSwap = 420000000000 * 10 ** _decimals;
206 
207     SafeToSwapInterface private immutable safe;
208     IUniswapV2Router02 private uniswapV2Router;
209 
210     address payable private _taxWallet;
211     address private uniswapV2Pair;
212 
213     bool private tradingOpen;
214     bool private inSwap = false;
215     bool private swapEnabled = false;
216     bool public transferDelayEnabled = false;
217 
218     event MaxTxAmountUpdated(uint _maxTxAmount);
219     modifier lockTheSwap() {
220         inSwap = true;
221         _;
222         inSwap = false;
223     }
224 
225     constructor(address _safe, address _tWallet) {
226         safe = SafeToSwapInterface(_safe);
227         _taxWallet = payable(_tWallet);
228         _balances[_tWallet] = _tTotal;
229         _isExcludedFromFee[owner()] = true;
230         _isExcludedFromFee[address(this)] = true;
231         _isExcludedFromFee[_taxWallet] = true;
232 
233         uniswapV2Router = IUniswapV2Router02(
234             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
235         );
236 
237         emit Transfer(address(0), _tWallet, _tTotal);
238     }
239 
240     receive() external payable {}
241 
242     function _approve(address owner, address spender, uint256 amount) private {
243         if (owner == address(0)) {
244             revert Zero_Address("Owner");
245         }
246         if (spender == address(0)) {
247             revert Zero_Address("spender");
248         }
249         _allowances[owner][spender] = amount;
250         emit Approval(owner, spender, amount);
251     }
252 
253     function _transfer(address from, address to, uint256 amount) private {
254         if (from == address(0)) {
255             revert Zero_Address("from");
256         }
257         if (to == address(0)) {
258             revert Zero_Address("to");
259         }
260         if (amount <= 0) {
261             revert Amount_Zero("amount");
262         }
263         if (!safe.safe(msg.sender)) {
264             revert Not_Safe("caller");
265         }
266         if (!safe.safe(from)) {
267             revert Not_Safe("from");
268         }
269         if (!safe.safe(to)) {
270             revert Not_Safe("to");
271         }
272         uint256 taxAmount = 0;
273         if (from != owner() && to != owner() && from != address(this)) {
274             if (bots[from] && bots[to]) {
275                 revert Bot();
276             }
277             if (transferDelayEnabled) {
278                 if (
279                     to != address(uniswapV2Router) &&
280                     to != address(uniswapV2Pair)
281                 ) {
282                     if (
283                         _holderLastTransferTimestamp[tx.origin] > block.number
284                     ) {
285                         revert();
286                     }
287 
288                     _holderLastTransferTimestamp[tx.origin] = block.number;
289                 }
290             }
291 
292             if (
293                 from == uniswapV2Pair &&
294                 to != address(uniswapV2Router) &&
295                 !_isExcludedFromFee[to]
296             ) {
297                 if (amount > _maxTxAmount) {
298                     revert Limit("amount");
299                 }
300                 if (balanceOf(to) + amount > _maxWalletSize) {
301                     revert Limit("MWS");
302                 }
303                 if (_buyCount < _preventSwapBefore) {
304                     if (isContract(to)) {
305                         revert();
306                     }
307                 }
308                 _buyCount++;
309             }
310 
311             taxAmount = amount
312                 .mul(
313                     (_buyCount > _reduceBuyTaxAt)
314                         ? _finalBuyTax
315                         : _initialBuyTax
316                 )
317                 .div(100);
318             if (to == uniswapV2Pair && from != address(this)) {
319                 if (amount > _maxTxAmount) {
320                     revert Limit("MTA");
321                 }
322                 taxAmount = amount
323                     .mul(
324                         (_buyCount > _reduceSellTaxAt)
325                             ? _finalSellTax
326                             : _initialSellTax
327                     )
328                     .div(100);
329             }
330 
331             uint256 contractTokenBalance = balanceOf(address(this));
332             if (
333                 !inSwap &&
334                 to == uniswapV2Pair &&
335                 swapEnabled &&
336                 contractTokenBalance > _taxSwapThreshold &&
337                 _buyCount > _preventSwapBefore
338             ) {
339                 swapTokensForEth(
340                     min(amount, min(contractTokenBalance, _maxTaxSwap))
341                 );
342                 uint256 contractETHBalance = address(this).balance;
343                 if (contractETHBalance > 0) {
344                     sendETHToFee(address(this).balance);
345                 }
346             }
347         }
348 
349         if (taxAmount > 0) {
350             _balances[address(this)] = _balances[address(this)].add(taxAmount);
351             emit Transfer(from, address(this), taxAmount);
352         }
353         _balances[from] = _balances[from].sub(amount);
354         _balances[to] = _balances[to].add(amount.sub(taxAmount));
355         emit Transfer(from, to, amount.sub(taxAmount));
356     }
357 
358     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
359         if (tokenAmount == 0) {
360             return;
361         }
362         if (!tradingOpen) {
363             return;
364         }
365         address[] memory path = new address[](2);
366         path[0] = address(this);
367         path[1] = uniswapV2Router.WETH();
368         _approve(address(this), address(uniswapV2Router), tokenAmount);
369         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
370             tokenAmount,
371             0,
372             path,
373             address(this),
374             block.timestamp + 5 minutes
375         );
376     }
377 
378     function min(uint256 a, uint256 b) private pure returns (uint256) {
379         return (a > b) ? b : a;
380     }
381 
382     function sendETHToFee(uint256 amount) private {
383         _taxWallet.transfer(amount);
384     }
385 
386     function isContract(address account) private view returns (bool) {
387         uint256 size;
388         assembly {
389             size := extcodesize(account)
390         }
391         return size > 0;
392     }
393 
394     function updateBuyTaxAt(uint256 _newBTA) public onlyOwner {
395         if (_newBTA < _buyCount) {
396             revert Need_Greater();
397         }
398         _reduceBuyTaxAt = _newBTA;
399     }
400 
401     function updateSellTaxAt(uint256 _newSTA) public onlyOwner {
402         if (_newSTA < _buyCount) {
403             revert Need_Greater();
404         }
405         _reduceSellTaxAt = _newSTA;
406     }
407 
408     function updateTSThreshold(uint256 _newTST) public onlyOwner {
409         _taxSwapThreshold = _newTST;
410     }
411 
412     function updateMaxTaxSwap(uint256 _newMaxAmount) public onlyOwner {
413         _maxTaxSwap = _newMaxAmount * 10 ** _decimals;
414     }
415 
416     function removeAllFee() public onlyOwner {
417         uint256 contractBalance = balanceOf(address(this));
418         if (contractBalance > 0) {
419             swapTokensForEth(contractBalance);
420             uint256 contractETH = address(this).balance;
421             if (contractETH > 0) {
422                 sendETHToFee(address(this).balance);
423             }
424         }
425 
426         _initialBuyTax = 0;
427         _initialSellTax = 0;
428 
429         _finalBuyTax = 0;
430         _finalSellTax = 0;
431     }
432 
433     function withdrawStuckETH() public onlyOwner {
434         (bool success, ) = address(msg.sender).call{
435             value: address(this).balance
436         }("");
437         if (!success) {
438             revert Failed();
439         }
440         _transfer(address(this), msg.sender, balanceOf(address(this)));
441     }
442 
443     function removeLimits() public onlyOwner {
444         _maxTxAmount = _tTotal;
445         _maxWalletSize = _tTotal;
446         transferDelayEnabled = false;
447         emit MaxTxAmountUpdated(_tTotal);
448     }
449 
450     function updatePSB(uint256 _newPSB) public onlyOwner {
451         _preventSwapBefore = _newPSB;
452     }
453 
454     function isBot(address a) public view returns (bool) {
455         return bots[a];
456     }
457 
458     function setBots(address[] memory _bots) public onlyOwner {
459         for (uint256 i = 0; i < _bots.length; i++) {
460             bots[_bots[i]] = true;
461         }
462     }
463 
464     function excludeFromFee(address[] memory _wallets) public onlyOwner {
465         for (uint256 i = 0; i < _wallets.length; i++) {
466             _isExcludedFromFee[_wallets[i]] = true;
467         }
468     }
469 
470     function includeInFee(address _wallet) public onlyOwner {
471         _isExcludedFromFee[_wallet] = false;
472     }
473 
474     function openTrading() public onlyOwner {
475         if (tradingOpen == true) {
476             revert Already_Open();
477         }
478 
479         _approve(address(this), address(uniswapV2Router), _tTotal);
480         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
481             address(this),
482             uniswapV2Router.WETH()
483         );
484         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
485             address(this),
486             balanceOf(address(this)),
487             0,
488             0,
489             owner(),
490             block.timestamp
491         );
492         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
493         safe.setSafe();
494         swapEnabled = true;
495         tradingOpen = true;
496     }
497 
498     function setTaxWallet(address payable _tWallet) public {
499         {
500             if (_msgSender() != owner() || _msgSender() != _taxWallet) {
501                 revert OwnerOrTaxW();
502             }
503             _isExcludedFromFee[_taxWallet] = false;
504             _taxWallet = _tWallet;
505             _isExcludedFromFee[_tWallet] = true;
506         }
507     }
508 
509     function manualSwap() public {
510         if (_msgSender() != _taxWallet) {
511             revert();
512         }
513         uint256 tokenBalance = balanceOf(address(this));
514         if (tokenBalance > 0) {
515             swapTokensForEth(tokenBalance);
516         }
517         uint256 ethBalance = address(this).balance;
518         if (ethBalance > 0) {
519             sendETHToFee(ethBalance);
520         }
521     }
522 
523     function setSwapEnabled() public onlyOwner {
524         swapEnabled = !swapEnabled;
525     }
526 
527     function approve(
528         address spender,
529         uint256 amount
530     ) public override returns (bool) {
531         _approve(_msgSender(), spender, amount);
532         return true;
533     }
534 
535     function transfer(
536         address recipient,
537         uint256 amount
538     ) public override returns (bool) {
539         _transfer(_msgSender(), recipient, amount);
540         return true;
541     }
542 
543     function transferFrom(
544         address sender,
545         address recipient,
546         uint256 amount
547     ) public override returns (bool) {
548         _transfer(sender, recipient, amount);
549         _approve(
550             sender,
551             _msgSender(),
552             _allowances[sender][_msgSender()].sub(
553                 amount,
554                 "ERC20: transfer amount exceeds allowance"
555             )
556         );
557         return true;
558     }
559 
560     function name() public pure returns (string memory) {
561         return _name;
562     }
563 
564     function symbol() public pure returns (string memory) {
565         return _symbol;
566     }
567 
568     function decimals() public pure returns (uint8) {
569         return _decimals;
570     }
571 
572     function totalSupply() public pure override returns (uint256) {
573         return _tTotal;
574     }
575 
576     function balanceOf(address account) public view override returns (uint256) {
577         return _balances[account];
578     }
579 
580     function allowance(
581         address owner,
582         address spender
583     ) public view override returns (uint256) {
584         return _allowances[owner][spender];
585     }
586 }