1 /**
2 https://t.me/MRGREENETH
3 www.Mrgreentoken.cc
4 https://twitter.com/mrgreenerc
5 JOIN THE NEW META AND SOMETHING BIG IS COMING THE AIM IS TO HOLD AND ONLY SEE GREEN WITH MR.GREEN!
6 */
7 
8 // SPDX-License-Identifier: Unlicensed
9 pragma solidity ^0.8.14;
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18 
19     function balanceOf(address account) external view returns (uint256);
20 
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     function allowance(address owner, address spender) external view returns (uint256);
24 
25     function approve(address spender, uint256 amount) external returns (bool);
26 
27     function transferFrom(
28         address sender,
29         address recipient,
30         uint256 amount
31     ) external returns (bool);
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(
35         address indexed owner,
36         address indexed spender,
37         uint256 value
38     );
39 }
40 
41 contract Ownable is Context {
42     address private _owner;
43     address private _previousOwner;
44     event OwnershipTransferred(
45         address indexed previousOwner,
46         address indexed newOwner
47     );
48 
49     constructor() {
50         address msgSender = _msgSender();
51         _owner = msgSender;
52         emit OwnershipTransferred(address(0), msgSender);
53     }
54 
55     function owner() public view returns (address) {
56         return _owner;
57     }
58 
59     modifier onlyOwner() {
60         require(_owner == _msgSender(), "Ownable: caller is not the owner");
61         _;
62     }
63 
64     function renounceOwnership() public virtual onlyOwner {
65         emit OwnershipTransferred(_owner, address(0));
66         _owner = address(0);
67     }
68 
69     function transferOwnership(address newOwner) public virtual onlyOwner {
70         require(newOwner != address(0), "Ownable: new owner is the zero address");
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 
75 }
76 
77 library SafeMath {
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a, "SafeMath: addition overflow");
81         return c;
82     }
83 
84     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85         return sub(a, b, "SafeMath: subtraction overflow");
86     }
87 
88     function sub(
89         uint256 a,
90         uint256 b,
91         string memory errorMessage
92     ) internal pure returns (uint256) {
93         require(b <= a, errorMessage);
94         uint256 c = a - b;
95         return c;
96     }
97 
98     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99         if (a == 0) {
100             return 0;
101         }
102         uint256 c = a * b;
103         require(c / a == b, "SafeMath: multiplication overflow");
104         return c;
105     }
106 
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         return div(a, b, "SafeMath: division by zero");
109     }
110 
111     function div(
112         uint256 a,
113         uint256 b,
114         string memory errorMessage
115     ) internal pure returns (uint256) {
116         require(b > 0, errorMessage);
117         uint256 c = a / b;
118         return c;
119     }
120 }
121 
122 interface IUniswapV2Factory {
123     function createPair(address tokenA, address tokenB)
124         external
125         returns (address pair);
126 }
127 
128 interface IUniswapV2Router02 {
129     function swapExactTokensForETHSupportingFeeOnTransferTokens(
130         uint256 amountIn,
131         uint256 amountOutMin,
132         address[] calldata path,
133         address to,
134         uint256 deadline
135     ) external;
136 
137     function factory() external pure returns (address);
138 
139     function WETH() external pure returns (address);
140 
141     function addLiquidityETH(
142         address token,
143         uint256 amountTokenDesired,
144         uint256 amountTokenMin,
145         uint256 amountETHMin,
146         address to,
147         uint256 deadline
148     )
149         external
150         payable
151         returns (
152             uint256 amountToken,
153             uint256 amountETH,
154             uint256 liquidity
155         );
156 }
157 
158 contract MRGREEN is Context, IERC20, Ownable {
159 
160     using SafeMath for uint256;
161 
162     string private constant _name = "MR.GREEN";
163     string private constant _symbol = "MR.GREEN";
164     uint8 private constant _decimals = 9;
165 
166     mapping(address => uint256) private _rOwned;
167     mapping(address => uint256) private _tOwned;
168     mapping(address => mapping(address => uint256)) private _allowances;
169     mapping(address => bool) private _isExcludedFromFee;
170     uint256 private constant MAX = ~uint256(0);
171     uint256 private constant _tTotal = 100000000 * 10**9;
172     uint256 private _rTotal = (MAX - (MAX % _tTotal));
173     uint256 private _tFeeTotal;
174     uint256 private _redisFeeOnBuy = 0;
175     uint256 private _taxFeeOnBuy = 20;
176     uint256 private _redisFeeOnSell = 0;
177     uint256 private _taxFeeOnSell = 40;
178 
179     //Original Fee
180     uint256 private _redisFee = _redisFeeOnSell;
181     uint256 private _taxFee = _taxFeeOnSell;
182 
183     uint256 private _previousredisFee = _redisFee;
184     uint256 private _previoustaxFee = _taxFee;
185 
186     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
187     mapping (address => bool) public preTrader;
188     address payable private _developmentAddress = payable(0xDb1F4F87e95661d917A5cC51e835Ee7d3466a35d);
189     address payable private _marketingAddress = payable(0xDb1F4F87e95661d917A5cC51e835Ee7d3466a35d);
190 
191     IUniswapV2Router02 public uniswapV2Router;
192     address public uniswapV2Pair;
193 
194     bool private tradingOpen;
195     bool private inSwap = false;
196     bool private swapEnabled = true;
197 
198     uint256 public _maxTxAmount = 2000000 * 10**9;
199     uint256 public _maxWalletSize = 2000000 * 10**9;
200     uint256 public _swapTokensAtAmount = 50000 * 10**9;
201 
202     event MaxTxAmountUpdated(uint256 _maxTxAmount);
203     modifier lockTheSwap {
204         inSwap = true;
205         _;
206         inSwap = false;
207     }
208 
209     constructor() {
210 
211         _rOwned[_msgSender()] = _rTotal;
212 
213         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
214         uniswapV2Router = _uniswapV2Router;
215         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
216             .createPair(address(this), _uniswapV2Router.WETH());
217 
218         _isExcludedFromFee[owner()] = true;
219         _isExcludedFromFee[address(this)] = true;
220         _isExcludedFromFee[_developmentAddress] = true;
221         _isExcludedFromFee[_marketingAddress] = true;
222 
223         emit Transfer(address(0), _msgSender(), _tTotal);
224     }
225 
226     function name() public pure returns (string memory) {
227         return _name;
228     }
229 
230     function symbol() public pure returns (string memory) {
231         return _symbol;
232     }
233 
234     function decimals() public pure returns (uint8) {
235         return _decimals;
236     }
237 
238     function totalSupply() public pure override returns (uint256) {
239         return _tTotal;
240     }
241 
242     function balanceOf(address account) public view override returns (uint256) {
243         return tokenFromReflection(_rOwned[account]);
244     }
245 
246     function transfer(address recipient, uint256 amount)
247         public
248         override
249         returns (bool)
250     {
251         _transfer(_msgSender(), recipient, amount);
252         return true;
253     }
254 
255     function allowance(address owner, address spender)
256         public
257         view
258         override
259         returns (uint256)
260     {
261         return _allowances[owner][spender];
262     }
263 
264     function approve(address spender, uint256 amount)
265         public
266         override
267         returns (bool)
268     {
269         _approve(_msgSender(), spender, amount);
270         return true;
271     }
272 
273     function transferFrom(
274         address sender,
275         address recipient,
276         uint256 amount
277     ) public override returns (bool) {
278         _transfer(sender, recipient, amount);
279         _approve(
280             sender,
281             _msgSender(),
282             _allowances[sender][_msgSender()].sub(
283                 amount,
284                 "ERC20: transfer amount exceeds allowance"
285             )
286         );
287         return true;
288     }
289 
290     function tokenFromReflection(uint256 rAmount)
291         private
292         view
293         returns (uint256)
294     {
295         require(
296             rAmount <= _rTotal,
297             "Amount must be less than total reflections"
298         );
299         uint256 currentRate = _getRate();
300         return rAmount.div(currentRate);
301     }
302 
303     function removeAllFee() private {
304         if (_redisFee == 0 && _taxFee == 0) return;
305 
306         _previousredisFee = _redisFee;
307         _previoustaxFee = _taxFee;
308 
309         _redisFee = 0;
310         _taxFee = 0;
311     }
312 
313     function restoreAllFee() private {
314         _redisFee = _previousredisFee;
315         _taxFee = _previoustaxFee;
316     }
317 
318     function _approve(
319         address owner,
320         address spender,
321         uint256 amount
322     ) private {
323         require(owner != address(0), "ERC20: approve from the zero address");
324         require(spender != address(0), "ERC20: approve to the zero address");
325         _allowances[owner][spender] = amount;
326         emit Approval(owner, spender, amount);
327     }
328 
329     function _transfer(
330         address from,
331         address to,
332         uint256 amount
333     ) private {
334         require(from != address(0), "ERC20: transfer from the zero address");
335         require(to != address(0), "ERC20: transfer to the zero address");
336         require(amount > 0, "Transfer amount must be greater than zero");
337 
338         	if (from != owner() && to != owner() && !preTrader[from] && !preTrader[to]) {
339 
340             //Trade start check
341             if (!tradingOpen) {
342                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
343             }
344 
345             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
346             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
347 
348             if(to != uniswapV2Pair) {
349                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
350             }
351 
352             uint256 contractTokenBalance = balanceOf(address(this));
353             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
354 
355             if(contractTokenBalance >= _maxTxAmount)
356             {
357                 contractTokenBalance = _maxTxAmount;
358             }
359 
360             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
361                 swapTokensForEth(contractTokenBalance);
362                 uint256 contractETHBalance = address(this).balance;
363                 if (contractETHBalance > 0) {
364                     sendETHToFee(address(this).balance);
365                 }
366             }
367         }
368 
369         bool takeFee = true;
370 
371         //Transfer Tokens
372         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
373             takeFee = false;
374         } else {
375 
376             //Set Fee for Buys
377             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
378                 _redisFee = _redisFeeOnBuy;
379                 _taxFee = _taxFeeOnBuy;
380             }
381 
382             //Set Fee for Sells
383             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
384                 _redisFee = _redisFeeOnSell;
385                 _taxFee = _taxFeeOnSell;
386             }
387 
388         }
389 
390         _tokenTransfer(from, to, amount, takeFee);
391     }
392 
393     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
394         address[] memory path = new address[](2);
395         path[0] = address(this);
396         path[1] = uniswapV2Router.WETH();
397         _approve(address(this), address(uniswapV2Router), tokenAmount);
398         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
399             tokenAmount,
400             0,
401             path,
402             address(this),
403             block.timestamp
404         );
405     }
406 
407     function sendETHToFee(uint256 amount) private {
408         _marketingAddress.transfer(amount);
409     }
410 
411     function setTrading(bool _tradingOpen) public onlyOwner {
412         tradingOpen = _tradingOpen;
413     }
414 
415     function manualswap() external {
416         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
417         uint256 contractBalance = balanceOf(address(this));
418         swapTokensForEth(contractBalance);
419     }
420 
421     function manualsend() external {
422         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
423         uint256 contractETHBalance = address(this).balance;
424         sendETHToFee(contractETHBalance);
425     }
426 
427     function blockBots(address[] memory bots_) public onlyOwner {
428         for (uint256 i = 0; i < bots_.length; i++) {
429             bots[bots_[i]] = true;
430         }
431     }
432 
433     function unblockBot(address notbot) public onlyOwner {
434         bots[notbot] = false;
435     }
436 
437     function _tokenTransfer(
438         address sender,
439         address recipient,
440         uint256 amount,
441         bool takeFee
442     ) private {
443         if (!takeFee) removeAllFee();
444         _transferStandard(sender, recipient, amount);
445         if (!takeFee) restoreAllFee();
446     }
447 
448     function _transferStandard(
449         address sender,
450         address recipient,
451         uint256 tAmount
452     ) private {
453         (
454             uint256 rAmount,
455             uint256 rTransferAmount,
456             uint256 rFee,
457             uint256 tTransferAmount,
458             uint256 tFee,
459             uint256 tTeam
460         ) = _getValues(tAmount);
461         _rOwned[sender] = _rOwned[sender].sub(rAmount);
462         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
463         _takeTeam(tTeam);
464         _reflectFee(rFee, tFee);
465         emit Transfer(sender, recipient, tTransferAmount);
466     }
467 
468     function _takeTeam(uint256 tTeam) private {
469         uint256 currentRate = _getRate();
470         uint256 rTeam = tTeam.mul(currentRate);
471         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
472     }
473 
474     function _reflectFee(uint256 rFee, uint256 tFee) private {
475         _rTotal = _rTotal.sub(rFee);
476         _tFeeTotal = _tFeeTotal.add(tFee);
477     }
478 
479     receive() external payable {}
480 
481     function _getValues(uint256 tAmount)
482         private
483         view
484         returns (
485             uint256,
486             uint256,
487             uint256,
488             uint256,
489             uint256,
490             uint256
491         )
492     {
493         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
494             _getTValues(tAmount, _redisFee, _taxFee);
495         uint256 currentRate = _getRate();
496         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
497             _getRValues(tAmount, tFee, tTeam, currentRate);
498         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
499     }
500 
501     function _getTValues(
502         uint256 tAmount,
503         uint256 redisFee,
504         uint256 taxFee
505     )
506         private
507         pure
508         returns (
509             uint256,
510             uint256,
511             uint256
512         )
513     {
514         uint256 tFee = tAmount.mul(redisFee).div(100);
515         uint256 tTeam = tAmount.mul(taxFee).div(100);
516         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
517         return (tTransferAmount, tFee, tTeam);
518     }
519 
520     function _getRValues(
521         uint256 tAmount,
522         uint256 tFee,
523         uint256 tTeam,
524         uint256 currentRate
525     )
526         private
527         pure
528         returns (
529             uint256,
530             uint256,
531             uint256
532         )
533     {
534         uint256 rAmount = tAmount.mul(currentRate);
535         uint256 rFee = tFee.mul(currentRate);
536         uint256 rTeam = tTeam.mul(currentRate);
537         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
538         return (rAmount, rTransferAmount, rFee);
539     }
540 
541     function _getRate() private view returns (uint256) {
542         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
543         return rSupply.div(tSupply);
544     }
545 
546     function _getCurrentSupply() private view returns (uint256, uint256) {
547         uint256 rSupply = _rTotal;
548         uint256 tSupply = _tTotal;
549         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
550         return (rSupply, tSupply);
551     }
552 
553     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
554         _redisFeeOnBuy = redisFeeOnBuy;
555         _redisFeeOnSell = redisFeeOnSell;
556         _taxFeeOnBuy = taxFeeOnBuy;
557         _taxFeeOnSell = taxFeeOnSell;
558     }
559 
560     //Set minimum tokens required to swap.
561     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
562         _swapTokensAtAmount = swapTokensAtAmount;
563     }
564 
565     //Set minimum tokens required to swap.
566     function toggleSwap(bool _swapEnabled) public onlyOwner {
567         swapEnabled = _swapEnabled;
568     }
569 
570     //Set maximum transaction
571     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
572         _maxTxAmount = maxTxAmount;
573     }
574 
575     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
576         _maxWalletSize = maxWalletSize;
577     }
578 
579     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
580         for(uint256 i = 0; i < accounts.length; i++) {
581             _isExcludedFromFee[accounts[i]] = excluded;
582         }
583     }
584 
585     function allowPreTrading(address[] calldata accounts) public onlyOwner {
586         for(uint256 i = 0; i < accounts.length; i++) {
587                  preTrader[accounts[i]] = true;
588         }
589     }
590 
591     function removePreTrading(address[] calldata accounts) public onlyOwner {
592         for(uint256 i = 0; i < accounts.length; i++) {
593                  delete preTrader[accounts[i]];
594         }
595     }
596 }