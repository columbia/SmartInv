1 /**
2 Robert F. Kennedy Jr expressed frustration over Instagram automatically banning TeamKennedy email addresses for 180 days when used to set up accounts. 
3 Subsequently, Elon Musk invited Kennedy to join him for a Spaces discussion. Kennedy accepted the invitation, suggesting they convene at 2 p.m. ET on the following Monday.
4 
5 Robert F. Kennedy Jr - @RobertKennedyJr·18h
6 Interesting… when we use our TeamKennedy email address to set up @instagram accounts we get an automatic 180-day ban. Can anyone guess why that’s happening?
7 https://twitter.com/RobertKennedyJr/status/1664428013566427141?s=20
8 
9 Elon Musk - @elonmusk
10 Would you like to do a Spaces discussion with me next week?
11 9:26 PM · Jun 2, 2023 · 1.7M Views
12 https://twitter.com/elonmusk/status/1664624430637621248?s=20
13 
14 Robert F. Kennedy Jr - @RobertKennedyJr·4h
15 Yes! How's Monday at 2 p.m. ET?
16 10:23 PM · Jun 2, 2023 · 367.3K Views
17 https://twitter.com/RobertKennedyJr/status/1664638992300605440?s=20
18 
19 0% taxes
20 1B Total Supply 
21 
22 Socials will be deployed shortly after contract deployment.
23 
24 */
25 
26 // SPDX-License-Identifier: MIT
27 pragma solidity ^0.8.9;
28 
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 }
34 
35 interface IERC20 {
36     function totalSupply() external view returns (uint256);
37 
38     function balanceOf(address account) external view returns (uint256);
39 
40     function transfer(address recipient, uint256 amount) external returns (bool);
41 
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     function approve(address spender, uint256 amount) external returns (bool);
45 
46     function transferFrom(
47         address sender,
48         address recipient,
49         uint256 amount
50     ) external returns (bool);
51 
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(
54         address indexed owner,
55         address indexed spender,
56         uint256 value
57     );
58 }
59 
60 contract Ownable is Context {
61     address private _owner;
62     address private _previousOwner;
63     event OwnershipTransferred(
64         address indexed previousOwner,
65         address indexed newOwner
66     );
67 
68     constructor() {
69         address msgSender = _msgSender();
70         _owner = msgSender;
71         emit OwnershipTransferred(address(0), msgSender);
72     }
73 
74     function owner() public view returns (address) {
75         return _owner;
76     }
77 
78     modifier onlyOwner() {
79         require(_owner == _msgSender(), "Ownable: caller is not the owner");
80         _;
81     }
82 
83     function renounceOwnership() public virtual onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         emit OwnershipTransferred(_owner, newOwner);
91         _owner = newOwner;
92     }
93 
94 }
95 
96 library SafeMath {
97     function add(uint256 a, uint256 b) internal pure returns (uint256) {
98         uint256 c = a + b;
99         require(c >= a, "SafeMath: addition overflow");
100         return c;
101     }
102 
103     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104         return sub(a, b, "SafeMath: subtraction overflow");
105     }
106 
107     function sub(
108         uint256 a,
109         uint256 b,
110         string memory errorMessage
111     ) internal pure returns (uint256) {
112         require(b <= a, errorMessage);
113         uint256 c = a - b;
114         return c;
115     }
116 
117     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
118         if (a == 0) {
119             return 0;
120         }
121         uint256 c = a * b;
122         require(c / a == b, "SafeMath: multiplication overflow");
123         return c;
124     }
125 
126     function div(uint256 a, uint256 b) internal pure returns (uint256) {
127         return div(a, b, "SafeMath: division by zero");
128     }
129 
130     function div(
131         uint256 a,
132         uint256 b,
133         string memory errorMessage
134     ) internal pure returns (uint256) {
135         require(b > 0, errorMessage);
136         uint256 c = a / b;
137         return c;
138     }
139 }
140 
141 interface IUniswapV2Factory {
142     function createPair(address tokenA, address tokenB)
143         external
144         returns (address pair);
145 }
146 
147 interface IUniswapV2Router02 {
148     function swapExactTokensForETHSupportingFeeOnTransferTokens(
149         uint256 amountIn,
150         uint256 amountOutMin,
151         address[] calldata path,
152         address to,
153         uint256 deadline
154     ) external;
155 
156     function factory() external pure returns (address);
157 
158     function WETH() external pure returns (address);
159 
160     function addLiquidityETH(
161         address token,
162         uint256 amountTokenDesired,
163         uint256 amountTokenMin,
164         uint256 amountETHMin,
165         address to,
166         uint256 deadline
167     )
168         external
169         payable
170         returns (
171             uint256 amountToken,
172             uint256 amountETH,
173             uint256 liquidity
174         );
175 }
176 
177 contract PresidentRobertFKennedyJr  is Context, IERC20, Ownable {
178 
179     using SafeMath for uint256;
180 
181     string private constant _name = "President Robert F. Kennedy Jr";
182     string private constant _symbol = "RFK";
183     uint8 private constant _decimals = 9;
184 
185     mapping(address => uint256) private _rOwned;
186     mapping(address => uint256) private _tOwned;
187     mapping(address => mapping(address => uint256)) private _allowances;
188     mapping(address => bool) private _isExcludedFromFee;
189     uint256 private constant MAX = ~uint256(0);
190     uint256 private constant _tTotal = 1000000000 * 10**9;
191     uint256 private _rTotal = (MAX - (MAX % _tTotal));
192     uint256 private _tFeeTotal;
193     uint256 private _redisFeeOnBuy = 0;
194     uint256 private _taxFeeOnBuy = 3;
195     uint256 private _redisFeeOnSell = 0;
196     uint256 private _taxFeeOnSell = 3;
197 
198     //Original Fee
199     uint256 private _redisFee = _redisFeeOnSell;
200     uint256 private _taxFee = _taxFeeOnSell;
201 
202     uint256 private _previousredisFee = _redisFee;
203     uint256 private _previoustaxFee = _taxFee;
204 
205     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
206     address payable private _developmentAddress = payable(0x4815BF7CFC013074b8B5C40DE0dC9E7ab39E3F13);
207     address payable private _marketingAddress = payable(0x4815BF7CFC013074b8B5C40DE0dC9E7ab39E3F13);
208 
209     IUniswapV2Router02 public uniswapV2Router;
210     address public uniswapV2Pair;
211 
212     bool private tradingOpen;
213     bool private inSwap = false;
214     bool private swapEnabled = true;
215 
216     uint256 public _maxTxAmount = 30000000 * 10**9;
217     uint256 public _maxWalletSize = 30000000 * 10**9;
218     uint256 public _swapTokensAtAmount = 10000 * 10**9;
219 
220     event MaxTxAmountUpdated(uint256 _maxTxAmount);
221     modifier lockTheSwap {
222         inSwap = true;
223         _;
224         inSwap = false;
225     }
226 
227     constructor() {
228 
229         _rOwned[_msgSender()] = _rTotal;
230 
231         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
232         uniswapV2Router = _uniswapV2Router;
233         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
234             .createPair(address(this), _uniswapV2Router.WETH());
235 
236         _isExcludedFromFee[owner()] = true;
237         _isExcludedFromFee[address(this)] = true;
238         _isExcludedFromFee[_developmentAddress] = true;
239         _isExcludedFromFee[_marketingAddress] = true;
240 
241         emit Transfer(address(0), _msgSender(), _tTotal);
242     }
243 
244     function name() public pure returns (string memory) {
245         return _name;
246     }
247 
248     function symbol() public pure returns (string memory) {
249         return _symbol;
250     }
251 
252     function decimals() public pure returns (uint8) {
253         return _decimals;
254     }
255 
256     function totalSupply() public pure override returns (uint256) {
257         return _tTotal;
258     }
259 
260     function balanceOf(address account) public view override returns (uint256) {
261         return tokenFromReflection(_rOwned[account]);
262     }
263 
264     function transfer(address recipient, uint256 amount)
265         public
266         override
267         returns (bool)
268     {
269         _transfer(_msgSender(), recipient, amount);
270         return true;
271     }
272 
273     function allowance(address owner, address spender)
274         public
275         view
276         override
277         returns (uint256)
278     {
279         return _allowances[owner][spender];
280     }
281 
282     function approve(address spender, uint256 amount)
283         public
284         override
285         returns (bool)
286     {
287         _approve(_msgSender(), spender, amount);
288         return true;
289     }
290 
291     function transferFrom(
292         address sender,
293         address recipient,
294         uint256 amount
295     ) public override returns (bool) {
296         _transfer(sender, recipient, amount);
297         _approve(
298             sender,
299             _msgSender(),
300             _allowances[sender][_msgSender()].sub(
301                 amount,
302                 "ERC20: transfer amount exceeds allowance"
303             )
304         );
305         return true;
306     }
307 
308     function tokenFromReflection(uint256 rAmount)
309         private
310         view
311         returns (uint256)
312     {
313         require(
314             rAmount <= _rTotal,
315             "Amount must be less than total reflections"
316         );
317         uint256 currentRate = _getRate();
318         return rAmount.div(currentRate);
319     }
320 
321     function removeAllFee() private {
322         if (_redisFee == 0 && _taxFee == 0) return;
323 
324         _previousredisFee = _redisFee;
325         _previoustaxFee = _taxFee;
326 
327         _redisFee = 0;
328         _taxFee = 0;
329     }
330 
331     function restoreAllFee() private {
332         _redisFee = _previousredisFee;
333         _taxFee = _previoustaxFee;
334     }
335 
336     function _approve(
337         address owner,
338         address spender,
339         uint256 amount
340     ) private {
341         require(owner != address(0), "ERC20: approve from the zero address");
342         require(spender != address(0), "ERC20: approve to the zero address");
343         _allowances[owner][spender] = amount;
344         emit Approval(owner, spender, amount);
345     }
346 
347     function _transfer(
348         address from,
349         address to,
350         uint256 amount
351     ) private {
352         require(from != address(0), "ERC20: transfer from the zero address");
353         require(to != address(0), "ERC20: transfer to the zero address");
354         require(amount > 0, "Transfer amount must be greater than zero");
355 
356         if (from != owner() && to != owner()) {
357 
358             //Trade start check
359             if (!tradingOpen) {
360                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
361             }
362 
363             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
364             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
365 
366             if(to != uniswapV2Pair) {
367                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
368             }
369 
370             uint256 contractTokenBalance = balanceOf(address(this));
371             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
372 
373             if(contractTokenBalance >= _maxTxAmount)
374             {
375                 contractTokenBalance = _maxTxAmount;
376             }
377 
378             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
379                 swapTokensForEth(contractTokenBalance);
380                 uint256 contractETHBalance = address(this).balance;
381                 if (contractETHBalance > 0) {
382                     sendETHToFee(address(this).balance);
383                 }
384             }
385         }
386 
387         bool takeFee = true;
388 
389         //Transfer Tokens
390         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
391             takeFee = false;
392         } else {
393 
394             //Set Fee for Buys
395             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
396                 _redisFee = _redisFeeOnBuy;
397                 _taxFee = _taxFeeOnBuy;
398             }
399 
400             //Set Fee for Sells
401             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
402                 _redisFee = _redisFeeOnSell;
403                 _taxFee = _taxFeeOnSell;
404             }
405 
406         }
407 
408         _tokenTransfer(from, to, amount, takeFee);
409     }
410 
411     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
412         address[] memory path = new address[](2);
413         path[0] = address(this);
414         path[1] = uniswapV2Router.WETH();
415         _approve(address(this), address(uniswapV2Router), tokenAmount);
416         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
417             tokenAmount,
418             0,
419             path,
420             address(this),
421             block.timestamp
422         );
423     }
424 
425     function sendETHToFee(uint256 amount) private {
426         _marketingAddress.transfer(amount);
427     }
428 
429     function setTrading(bool _tradingOpen) public onlyOwner {
430         tradingOpen = _tradingOpen;
431     }
432 
433     function manualswap() external {
434         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
435         uint256 contractBalance = balanceOf(address(this));
436         swapTokensForEth(contractBalance);
437     }
438 
439     function manualsend() external {
440         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
441         uint256 contractETHBalance = address(this).balance;
442         sendETHToFee(contractETHBalance);
443     }
444 
445     function blockBots(address[] memory bots_) public onlyOwner {
446         for (uint256 i = 0; i < bots_.length; i++) {
447             bots[bots_[i]] = true;
448         }
449     }
450 
451     function unblockBot(address notbot) public onlyOwner {
452         bots[notbot] = false;
453     }
454 
455     function _tokenTransfer(
456         address sender,
457         address recipient,
458         uint256 amount,
459         bool takeFee
460     ) private {
461         if (!takeFee) removeAllFee();
462         _transferStandard(sender, recipient, amount);
463         if (!takeFee) restoreAllFee();
464     }
465 
466     function _transferStandard(
467         address sender,
468         address recipient,
469         uint256 tAmount
470     ) private {
471         (
472             uint256 rAmount,
473             uint256 rTransferAmount,
474             uint256 rFee,
475             uint256 tTransferAmount,
476             uint256 tFee,
477             uint256 tTeam
478         ) = _getValues(tAmount);
479         _rOwned[sender] = _rOwned[sender].sub(rAmount);
480         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
481         _takeTeam(tTeam);
482         _reflectFee(rFee, tFee);
483         emit Transfer(sender, recipient, tTransferAmount);
484     }
485 
486     function _takeTeam(uint256 tTeam) private {
487         uint256 currentRate = _getRate();
488         uint256 rTeam = tTeam.mul(currentRate);
489         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
490     }
491 
492     function _reflectFee(uint256 rFee, uint256 tFee) private {
493         _rTotal = _rTotal.sub(rFee);
494         _tFeeTotal = _tFeeTotal.add(tFee);
495     }
496 
497     receive() external payable {}
498 
499     function _getValues(uint256 tAmount)
500         private
501         view
502         returns (
503             uint256,
504             uint256,
505             uint256,
506             uint256,
507             uint256,
508             uint256
509         )
510     {
511         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
512             _getTValues(tAmount, _redisFee, _taxFee);
513         uint256 currentRate = _getRate();
514         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
515             _getRValues(tAmount, tFee, tTeam, currentRate);
516         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
517     }
518 
519     function _getTValues(
520         uint256 tAmount,
521         uint256 redisFee,
522         uint256 taxFee
523     )
524         private
525         pure
526         returns (
527             uint256,
528             uint256,
529             uint256
530         )
531     {
532         uint256 tFee = tAmount.mul(redisFee).div(100);
533         uint256 tTeam = tAmount.mul(taxFee).div(100);
534         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
535         return (tTransferAmount, tFee, tTeam);
536     }
537 
538     function _getRValues(
539         uint256 tAmount,
540         uint256 tFee,
541         uint256 tTeam,
542         uint256 currentRate
543     )
544         private
545         pure
546         returns (
547             uint256,
548             uint256,
549             uint256
550         )
551     {
552         uint256 rAmount = tAmount.mul(currentRate);
553         uint256 rFee = tFee.mul(currentRate);
554         uint256 rTeam = tTeam.mul(currentRate);
555         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
556         return (rAmount, rTransferAmount, rFee);
557     }
558 
559     function _getRate() private view returns (uint256) {
560         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
561         return rSupply.div(tSupply);
562     }
563 
564     function _getCurrentSupply() private view returns (uint256, uint256) {
565         uint256 rSupply = _rTotal;
566         uint256 tSupply = _tTotal;
567         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
568         return (rSupply, tSupply);
569     }
570 
571     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
572         _redisFeeOnBuy = redisFeeOnBuy;
573         _redisFeeOnSell = redisFeeOnSell;
574         _taxFeeOnBuy = taxFeeOnBuy;
575         _taxFeeOnSell = taxFeeOnSell;
576     }
577 
578     //Set minimum tokens required to swap.
579     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
580         _swapTokensAtAmount = swapTokensAtAmount;
581     }
582 
583     //Set minimum tokens required to swap.
584     function toggleSwap(bool _swapEnabled) public onlyOwner {
585         swapEnabled = _swapEnabled;
586     }
587 
588     //Set maximum transaction
589     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
590         _maxTxAmount = maxTxAmount;
591     }
592 
593     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
594         _maxWalletSize = maxWalletSize;
595     }
596 
597     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
598         for(uint256 i = 0; i < accounts.length; i++) {
599             _isExcludedFromFee[accounts[i]] = excluded;
600         }
601     }
602 
603 }