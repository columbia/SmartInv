1 /**
2 
3 
4 /*
5                                                             
6 https://t.me/HPOVS1Meth
7 
8 
9 https://twitter.com/HPOV1Meth
10 
11 */
12 
13 
14 // SPDX-License-Identifier: Unlicensed
15 pragma solidity ^0.8.9;
16 
17 
18 abstract contract Context {
19 function _msgSender() internal view virtual returns (address) {
20 return msg.sender;
21 }
22 }
23 
24 
25 interface IERC20 {
26 function totalSupply() external view returns (uint256);
27 
28 
29 function balanceOf(address account) external view returns (uint256);
30 
31 
32 function transfer(address recipient, uint256 amount) external returns (bool);
33 
34 
35 function allowance(address owner, address spender) external view returns (uint256);
36 
37 
38 function approve(address spender, uint256 amount) external returns (bool);
39 
40 
41 function transferFrom(
42 address sender,
43 address recipient,
44 uint256 amount
45 ) external returns (bool);
46 
47 
48 event Transfer(address indexed from, address indexed to, uint256 value);
49 event Approval(
50 address indexed owner,
51 address indexed spender,
52 uint256 value
53 );
54 }
55 
56 
57 contract Ownable is Context {
58 address private _owner;
59 address private _previousOwner;
60 event OwnershipTransferred(
61 address indexed previousOwner,
62 address indexed newOwner
63 );
64 
65 
66 constructor() {
67 address msgSender = _msgSender();
68 _owner = msgSender;
69 emit OwnershipTransferred(address(0), msgSender);
70 }
71 
72 
73 function owner() public view returns (address) {
74 return _owner;
75 }
76 
77 
78 modifier onlyOwner() {
79 require(_owner == _msgSender(), "Ownable: caller is not the owner");
80 _;
81 }
82 
83 
84 function renounceOwnership() public virtual onlyOwner {
85 emit OwnershipTransferred(_owner, address(0));
86 _owner = address(0);
87 }
88 
89 
90 function transferOwnership(address newOwner) public virtual onlyOwner {
91 require(newOwner != address(0), "Ownable: new owner is the zero address");
92 emit OwnershipTransferred(_owner, newOwner);
93 _owner = newOwner;
94 }
95 
96 
97 }
98 
99 
100 library SafeMath {
101 function add(uint256 a, uint256 b) internal pure returns (uint256) {
102 uint256 c = a + b;
103 require(c >= a, "SafeMath: addition overflow");
104 return c;
105 }
106 
107 
108 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109 return sub(a, b, "SafeMath: subtraction overflow");
110 }
111 
112 
113 function sub(
114 uint256 a,
115 uint256 b,
116 string memory errorMessage
117 ) internal pure returns (uint256) {
118 require(b <= a, errorMessage);
119 uint256 c = a - b;
120 return c;
121 }
122 
123 
124 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
125 if (a == 0) {
126 return 0;
127 }
128 uint256 c = a * b;
129 require(c / a == b, "SafeMath: multiplication overflow");
130 return c;
131 }
132 
133 
134 function div(uint256 a, uint256 b) internal pure returns (uint256) {
135 return div(a, b, "SafeMath: division by zero");
136 }
137 
138 
139 function div(
140 uint256 a,
141 uint256 b,
142 string memory errorMessage
143 ) internal pure returns (uint256) {
144 require(b > 0, errorMessage);
145 uint256 c = a / b;
146 return c;
147 }
148 }
149 
150 
151 interface IUniswapV2Factory {
152 function createPair(address tokenA, address tokenB)
153 external
154 returns (address pair);
155 }
156 
157 
158 interface IUniswapV2Router02 {
159 function swapExactTokensForETHSupportingFeeOnTransferTokens(
160 uint256 amountIn,
161 uint256 amountOutMin,
162 address[] calldata path,
163 address to,
164 uint256 deadline
165 ) external;
166 
167 
168 function factory() external pure returns (address);
169 
170 
171 function WETH() external pure returns (address);
172 
173 
174 function addLiquidityETH(
175 address token,
176 uint256 amountTokenDesired,
177 uint256 amountTokenMin,
178 uint256 amountETHMin,
179 address to,
180 uint256 deadline
181 )
182 external
183 payable
184 returns (
185 uint256 amountToken,
186 uint256 amountETH,
187 uint256 liquidity
188 );
189 }
190 
191 
192 contract HarrypotterobamaVitalik1meme is Context, IERC20, Ownable {
193 
194 
195 using SafeMath for uint256;
196 
197 
198 string private constant _name = "HarrypotterobamaVitalik1meme";
199 string private constant _symbol = "ETH";
200 uint8 private constant _decimals = 9;
201 
202 
203 mapping(address => uint256) private _rOwned;
204 mapping(address => uint256) private _tOwned;
205 mapping(address => mapping(address => uint256)) private _allowances;
206 mapping(address => bool) private _isExcludedFromFee;
207 uint256 private constant MAX = ~uint256(0);
208 uint256 private constant _tTotal = 100000000 * 10**9;
209 uint256 private _rTotal = (MAX - (MAX % _tTotal));
210 uint256 private _totalFee;
211 uint256 private _initFeeOnBuy = 0;
212 uint256 private _taxFeeOnBuy = 20;
213 uint256 private _initFeeOnSell = 0;
214 uint256 private _taxFeeOnSell = 30;
215 
216 
217 
218 
219 uint256 private _initFee = _initFeeOnSell;
220 uint256 private _taxFee = _taxFeeOnSell;
221 
222 
223 uint256 private _previousInitFee = _initFee;
224 uint256 private _previoustaxFee = _taxFee;
225 
226 
227 mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
228 address payable private _devWallet = payable(0x49535c1D240D0E2A97aB1cb9F3F411988B236307);
229 address payable private _marketingWallet = payable(0x49535c1D240D0E2A97aB1cb9F3F411988B236307);
230 
231 
232 IUniswapV2Router02 public uniswapV2Router;
233 address public uniswapV2Pair;
234 
235 
236 bool private inSwap = false;
237 bool private swapEnabled = true;
238 bool private openTrading = true;
239 
240 
241 uint256 public _maxTx = 2000000 * 10**9;
242 uint256 public _maxWallet = 2000000 * 10**9;
243 uint256 public _swapTokensAtAmount = 100 * 10**9;
244 
245 
246 event MaxTxAmountUpdated(uint256 _maxTx);
247 modifier lockTheSwap {
248 inSwap = false;
249 _;
250 inSwap = false;
251 }
252 
253 
254 constructor() {
255 
256 
257 _rOwned[_msgSender()] = _rTotal;
258 
259 
260 IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
261 uniswapV2Router = _uniswapV2Router;
262 uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
263 .createPair(address(this), _uniswapV2Router.WETH());
264 
265 
266 _isExcludedFromFee[owner()] = true;
267 _isExcludedFromFee[address(this)] = true;
268 _isExcludedFromFee[_devWallet] = true;
269 _isExcludedFromFee[_marketingWallet] = true;
270 
271 
272 emit Transfer(address(0), _msgSender(), _tTotal);
273 }
274 
275 
276 function name() public pure returns (string memory) {
277 return _name;
278 }
279 
280 
281 function symbol() public pure returns (string memory) {
282 return _symbol;
283 }
284 
285 
286 function decimals() public pure returns (uint8) {
287 return _decimals;
288 }
289 
290 
291 function totalSupply() public pure override returns (uint256) {
292 return _tTotal;
293 }
294 
295 
296 function balanceOf(address account) public view override returns (uint256) {
297 return tokenFromReflection(_rOwned[account]);
298 }
299 
300 
301 function transfer(address recipient, uint256 amount)
302 public
303 override
304 returns (bool)
305 {
306 _transfer(_msgSender(), recipient, amount);
307 return true;
308 }
309 
310 
311 function allowance(address owner, address spender)
312 public
313 view
314 override
315 returns (uint256)
316 {
317 return _allowances[owner][spender];
318 }
319 
320 
321 function approve(address spender, uint256 amount)
322 public
323 override
324 returns (bool)
325 {
326 _approve(_msgSender(), spender, amount);
327 return true;
328 }
329 
330 
331 function transferFrom(
332 address sender,
333 address recipient,
334 uint256 amount
335 ) public override returns (bool) {
336 _transfer(sender, recipient, amount);
337 _approve(
338 sender,
339 _msgSender(),
340 _allowances[sender][_msgSender()].sub(
341 amount,
342 "ERC20: transfer amount exceeds allowance"
343 )
344 );
345 return true;
346 }
347 
348 
349 function tokenFromReflection(uint256 rAmount)
350 private
351 view
352 returns (uint256)
353 {
354 require(
355 rAmount <= _rTotal,
356 "Amount must be less than total reflections"
357 );
358 uint256 currentRate = _getRate();
359 return rAmount.div(currentRate);
360 }
361 
362 
363 function removeAllFee() private {
364 if (_initFee == 0 && _taxFee == 0) return;
365 
366 
367 _previousInitFee = _initFee;
368 _previoustaxFee = _taxFee;
369 
370 
371 _initFee = 0;
372 _taxFee = 0;
373 }
374 
375 
376 function restoreAllFee() private {
377 _initFee = _previousInitFee;
378 _taxFee = _previoustaxFee;
379 }
380 
381 
382 function _approve(
383 address owner,
384 address spender,
385 uint256 amount
386 ) private {
387 require(owner != address(0), "ERC20: approve from the zero address");
388 require(spender != address(0), "ERC20: approve to the zero address");
389 _allowances[owner][spender] = amount;
390 emit Approval(owner, spender, amount);
391 }
392 
393 
394 function _transfer(
395 address from,
396 address to,
397 uint256 amount
398 ) private {
399 require(from != address(0), "ERC20: transfer from the zero address");
400 require(to != address(0), "ERC20: transfer to the zero address");
401 require(amount > 0, "Transfer amount must be greater than zero");
402 
403 
404 if (from != owner() && to != owner()) {
405 
406 
407 
408 
409 if (!openTrading) {
410 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
411 }
412 
413 
414 require(amount <= _maxTx, "TOKEN: Max Transaction Limit");
415 require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
416 
417 
418 if(to != uniswapV2Pair) {
419 require(balanceOf(to) + amount < _maxWallet, "TOKEN: Balance exceeds wallet size!");
420 }
421 
422 
423 uint256 contractTokenBalance = balanceOf(address(this));
424 bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
425 
426 
427 if(contractTokenBalance >= _maxTx)
428 {
429 contractTokenBalance = _maxTx;
430 }
431 
432 
433 if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
434 swapTokensForEth(contractTokenBalance);
435 uint256 contractETHBalance = address(this).balance;
436 if (contractETHBalance > 0) {
437 sendETHToFee(address(this).balance);
438 }
439 }
440 }
441 
442 
443 bool takeFee = true;
444 
445 
446 //Transfer Tokens
447 if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
448 takeFee = false;
449 } else {
450 
451 
452 //Set Fee for Buys
453 if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
454 _initFee = _initFeeOnBuy;
455 _taxFee = _taxFeeOnBuy;
456 }
457 
458 
459 //Set Fee for Sells
460 if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
461 _initFee = _initFeeOnSell;
462 _taxFee = _taxFeeOnSell;
463 }
464 
465 
466 }
467 
468 
469 _tokenTransfer(from, to, amount, takeFee);
470 }
471 
472 
473 function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
474 address[] memory path = new address[](2);
475 path[0] = address(this);
476 path[1] = uniswapV2Router.WETH();
477 _approve(address(this), address(uniswapV2Router), tokenAmount);
478 uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
479 tokenAmount,
480 0,
481 path,
482 address(this),
483 block.timestamp
484 );
485 }
486 
487 
488 function sendETHToFee(uint256 amount) private {
489 _marketingWallet.transfer(amount);
490 }
491 
492 
493 function setTrading(bool _openTrading) public onlyOwner {
494 openTrading = _openTrading;
495 }
496 
497 
498 function manualswap() external {
499 require(_msgSender() == _devWallet || _msgSender() == _marketingWallet);
500 uint256 contractBalance = balanceOf(address(this));
501 swapTokensForEth(contractBalance);
502 }
503 
504 
505 function manualsend() external {
506 require(_msgSender() == _devWallet || _msgSender() == _marketingWallet);
507 uint256 contractETHBalance = address(this).balance;
508 sendETHToFee(contractETHBalance);
509 }
510 
511 
512 function _tokenTransfer(
513 address sender,
514 address recipient,
515 uint256 amount,
516 bool takeFee
517 ) private {
518 if (!takeFee) removeAllFee();
519 _transferStandard(sender, recipient, amount);
520 if (!takeFee) restoreAllFee();
521 }
522 
523 
524 function _transferStandard(
525 address sender,
526 address recipient,
527 uint256 tAmount
528 ) private {
529 (
530 uint256 rAmount,
531 uint256 rTransferAmount,
532 uint256 rFee,
533 uint256 tTransferAmount,
534 uint256 tFee,
535 uint256 tTeam
536 ) = _getValues(tAmount);
537 _rOwned[sender] = _rOwned[sender].sub(rAmount);
538 _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
539 _takeTeam(tTeam);
540 _reflectFee(rFee, tFee);
541 emit Transfer(sender, recipient, tTransferAmount);
542 }
543 
544 
545 function _takeTeam(uint256 tTeam) private {
546 uint256 currentRate = _getRate();
547 uint256 rTeam = tTeam.mul(currentRate);
548 _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
549 }
550 
551 
552 function _reflectFee(uint256 rFee, uint256 tFee) private {
553 _rTotal = _rTotal.sub(rFee);
554 _totalFee = _totalFee.add(tFee);
555 }
556 
557 
558 receive() external payable {}
559 
560 
561 function _getValues(uint256 tAmount)
562 private
563 view
564 returns (
565 uint256,
566 uint256,
567 uint256,
568 uint256,
569 uint256,
570 uint256
571 )
572 {
573 (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
574 _getTValues(tAmount, _initFee, _taxFee);
575 uint256 currentRate = _getRate();
576 (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
577 _getRValues(tAmount, tFee, tTeam, currentRate);
578 return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
579 }
580 
581 
582 function _getTValues(
583 uint256 tAmount,
584 uint256 redisFee,
585 uint256 taxFee
586 )
587 private
588 pure
589 returns (
590 uint256,
591 uint256,
592 uint256
593 )
594 {
595 uint256 tFee = tAmount.mul(redisFee).div(100);
596 uint256 tTeam = tAmount.mul(taxFee).div(100);
597 uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
598 return (tTransferAmount, tFee, tTeam);
599 }
600 
601 
602 function _getRValues(
603 uint256 tAmount,
604 uint256 tFee,
605 uint256 tTeam,
606 uint256 currentRate
607 )
608 private
609 pure
610 returns (
611 uint256,
612 uint256,
613 uint256
614 )
615 {
616 uint256 rAmount = tAmount.mul(currentRate);
617 uint256 rFee = tFee.mul(currentRate);
618 uint256 rTeam = tTeam.mul(currentRate);
619 uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
620 return (rAmount, rTransferAmount, rFee);
621 }
622 
623 
624 function _getRate() private view returns (uint256) {
625 (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
626 return rSupply.div(tSupply);
627 }
628 
629 
630 function _getCurrentSupply() private view returns (uint256, uint256) {
631 uint256 rSupply = _rTotal;
632 uint256 tSupply = _tTotal;
633 if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
634 return (rSupply, tSupply);
635 }
636 
637 
638 function setTax(uint256 initOnBuy, uint256 initOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
639 _initFeeOnBuy = initOnBuy;
640 _initFeeOnSell = initOnSell;
641 _taxFeeOnBuy = taxFeeOnBuy;
642 _taxFeeOnSell = taxFeeOnSell;
643 }
644 
645 
646 function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
647 _swapTokensAtAmount = swapTokensAtAmount;
648 }
649 
650 
651 function toggleSwap(bool _swapEnabled) public onlyOwner {
652 swapEnabled = _swapEnabled;
653 }
654 
655 
656 function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
657 _maxTx = maxTxAmount;
658 }
659 
660 
661 function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
662 _maxWallet = maxWalletSize;
663 }
664 
665 
666 function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
667 for(uint256 i = 0; i < accounts.length; i++) {
668 _isExcludedFromFee[accounts[i]] = excluded;
669 }
670 }
671 
672 
673 function releaseMax() public onlyOwner {
674 _maxWallet = 100000000000000000000000000;
675 _maxTx = 100000000000000000000000000;
676 }
677 }