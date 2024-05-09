1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.4;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 }
9 
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12 
13     function balanceOf(address account) external view returns (uint256);
14 
15     function transfer(address recipient, uint256 amount) external returns (bool);
16 
17     function allowance(address owner, address spender) external view returns (uint256);
18 
19     function approve(address spender, uint256 amount) external returns (bool);
20 
21     function transferFrom(
22         address sender,
23         address recipient,
24         uint256 amount
25     ) external returns (bool);
26 
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(
29         address indexed owner,
30         address indexed spender,
31         uint256 value
32     );
33 }
34 
35 contract Ownable is Context {
36     address private _owner;
37     address private _previousOwner;
38     event OwnershipTransferred(
39         address indexed previousOwner,
40         address indexed newOwner
41     );
42 
43     constructor() {
44         address msgSender = _msgSender();
45         _owner = msgSender;
46         emit OwnershipTransferred(address(0), msgSender);
47     }
48 
49     function owner() public view returns (address) {
50         return _owner;
51     }
52 
53     modifier onlyOwner() {
54         require(_owner == _msgSender(), "Ownable: caller is not the owner");
55         _;
56     }
57 
58     function renounceOwnership() public virtual onlyOwner {
59         emit OwnershipTransferred(_owner, address(0));
60         _owner = address(0);
61     }
62 
63     function transferOwnership(address newOwner) public virtual onlyOwner {
64         require(newOwner != address(0), "Ownable: new owner is the zero address");
65         emit OwnershipTransferred(_owner, newOwner);
66         _owner = newOwner;
67     }
68 
69 }
70 
71 library SafeMath {
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a, "SafeMath: addition overflow");
75         return c;
76     }
77 
78     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79         return sub(a, b, "SafeMath: subtraction overflow");
80     }
81 
82     function sub(
83         uint256 a,
84         uint256 b,
85         string memory errorMessage
86     ) internal pure returns (uint256) {
87         require(b <= a, errorMessage);
88         uint256 c = a - b;
89         return c;
90     }
91 
92     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93         if (a == 0) {
94             return 0;
95         }
96         uint256 c = a * b;
97         require(c / a == b, "SafeMath: multiplication overflow");
98         return c;
99     }
100 
101     function div(uint256 a, uint256 b) internal pure returns (uint256) {
102         return div(a, b, "SafeMath: division by zero");
103     }
104 
105     function div(
106         uint256 a,
107         uint256 b,
108         string memory errorMessage
109     ) internal pure returns (uint256) {
110         require(b > 0, errorMessage);
111         uint256 c = a / b;
112         return c;
113     }
114 }
115 
116 interface IUniswapV2Factory {
117     function createPair(address tokenA, address tokenB)
118         external
119         returns (address pair);
120 }
121 
122 interface IUniswapV2Router02 {
123     function swapExactTokensForETHSupportingFeeOnTransferTokens(
124         uint256 amountIn,
125         uint256 amountOutMin,
126         address[] calldata path,
127         address to,
128         uint256 deadline
129     ) external;
130 
131     function factory() external pure returns (address);
132 
133     function WETH() external pure returns (address);
134 
135     function addLiquidityETH(
136         address token,
137         uint256 amountTokenDesired,
138         uint256 amountTokenMin,
139         uint256 amountETHMin,
140         address to,
141         uint256 deadline
142     )
143         external
144         payable
145         returns (
146             uint256 amountToken,
147             uint256 amountETH,
148             uint256 liquidity
149         );
150 }
151 
152 contract $PEEPEE is Context, IERC20, Ownable {///////////////////////////////////////////////////////////
153 
154     using SafeMath for uint256;
155 
156     string private constant _name = "Pee-Pee";//////////////////////////
157     string private constant _symbol = "$PEE-PEE";//////////////////////////////////////////////////////////////////////
158     uint8 private constant _decimals = 9;
159 
160     mapping(address => uint256) private _rOwned;
161     mapping(address => uint256) private _tOwned;
162     mapping(address => mapping(address => uint256)) private _allowances;
163     mapping(address => bool) private _isExcludedFromFee;
164     uint256 private constant MAX = ~uint256(0);
165     uint256 private constant _tTotal = 100000000 * 10**9;
166     uint256 private _rTotal = (MAX - (MAX % _tTotal));
167     uint256 private _tFeeTotal;
168 
169     //Buy Fee
170     uint256 private _redisFeeOnBuy = 0;////////////////////////////////////////////////////////////////////
171     uint256 private _taxFeeOnBuy = 20;//////////////////////////////////////////////////////////////////////
172 
173     //Sell Fee
174     uint256 private _redisFeeOnSell = 0;/////////////////////////////////////////////////////////////////////
175     uint256 private _taxFeeOnSell = 20;/////////////////////////////////////////////////////////////////////
176 
177     //Original Fee
178     uint256 private _redisFee = _redisFeeOnSell;
179     uint256 private _taxFee = _taxFeeOnSell;
180 
181     uint256 private _previousredisFee = _redisFee;
182     uint256 private _previoustaxFee = _taxFee;
183 
184     mapping(address => bool) public bots;
185     mapping(address => uint256) private cooldown;
186 
187     address payable private _developmentAddress = payable(0x078bd1b42D9d5B3E1C8C008951c7414898E2Acda);/////////////////////////////////////////////////
188     address payable private _marketingAddress = payable(0x078bd1b42D9d5B3E1C8C008951c7414898E2Acda);///////////////////////////////////////////////////
189 
190     IUniswapV2Router02 public uniswapV2Router;
191     address public uniswapV2Pair;
192 
193     bool private tradingOpen;
194     bool private inSwap = false;
195     bool private swapEnabled = true;
196 
197     uint256 public _maxTxAmount = 2250000 * 10**9; //2.25%
198     uint256 public _maxWalletSize = 2250000 * 10**9; //2.25%
199     uint256 public _swapTokensAtAmount = 200000 * 10**9; //.1%
200 
201     event MaxTxAmountUpdated(uint256 _maxTxAmount);
202     modifier lockTheSwap {
203         inSwap = true;
204         _;
205         inSwap = false;
206     }
207 
208     constructor() {
209 
210         _rOwned[_msgSender()] = _rTotal;
211 
212         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);/////////////////////////////////////////////////
213         uniswapV2Router = _uniswapV2Router;
214         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
215             .createPair(address(this), _uniswapV2Router.WETH());
216 
217         _isExcludedFromFee[owner()] = true;
218         _isExcludedFromFee[address(this)] = true;
219         _isExcludedFromFee[_developmentAddress] = true;
220         _isExcludedFromFee[_marketingAddress] = true;  
221 
222         emit Transfer(address(0), _msgSender(), _tTotal);
223     }
224 
225     function name() public pure returns (string memory) {
226         return _name;
227     }
228 
229     function symbol() public pure returns (string memory) {
230         return _symbol;
231     }
232 
233     function decimals() public pure returns (uint8) {
234         return _decimals;
235     }
236 
237     function totalSupply() public pure override returns (uint256) {
238         return _tTotal;
239     }
240 
241     function balanceOf(address account) public view override returns (uint256) {
242         return tokenFromReflection(_rOwned[account]);
243     }
244 
245     function transfer(address recipient, uint256 amount)
246         public
247         override
248         returns (bool)
249     {
250         _transfer(_msgSender(), recipient, amount);
251         return true;
252     }
253 
254     function allowance(address owner, address spender)
255         public
256         view
257         override
258         returns (uint256)
259     {
260         return _allowances[owner][spender];
261     }
262 
263     function approve(address spender, uint256 amount)
264         public
265         override
266         returns (bool)
267     {
268         _approve(_msgSender(), spender, amount);
269         return true;
270     }
271 
272     function transferFrom(
273         address sender,
274         address recipient,
275         uint256 amount
276     ) public override returns (bool) {
277         _transfer(sender, recipient, amount);
278         _approve(
279             sender,
280             _msgSender(),
281             _allowances[sender][_msgSender()].sub(
282                 amount,
283                 "ERC20: transfer amount exceeds allowance"
284             )
285         );
286         return true;
287     }
288 
289     function tokenFromReflection(uint256 rAmount)
290         private
291         view
292         returns (uint256)
293     {
294         require(
295             rAmount <= _rTotal,
296             "Amount must be less than total reflections"
297         );
298         uint256 currentRate = _getRate();
299         return rAmount.div(currentRate);
300     }
301 
302     function removeAllFee() private {
303         if (_redisFee == 0 && _taxFee == 0) return;
304 
305         _previousredisFee = _redisFee;
306         _previoustaxFee = _taxFee;
307 
308         _redisFee = 0;
309         _taxFee = 0;
310     }
311 
312     function restoreAllFee() private {
313         _redisFee = _previousredisFee;
314         _taxFee = _previoustaxFee;
315     }
316 
317     function _approve(
318         address owner,
319         address spender,
320         uint256 amount
321     ) private {
322         require(owner != address(0), "ERC20: approve from the zero address");
323         require(spender != address(0), "ERC20: approve to the zero address");
324         _allowances[owner][spender] = amount;
325         emit Approval(owner, spender, amount);
326     }
327 
328     function _transfer(
329         address from,
330         address to,
331         uint256 amount
332     ) private {
333         require(from != address(0), "ERC20: transfer from the zero address");
334         require(to != address(0), "ERC20: transfer to the zero address");
335         require(amount > 0, "Transfer amount must be greater than zero");
336 
337         if (from != owner() && to != owner()) {
338 
339             //Trade start check
340             if (!tradingOpen) {
341                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
342             }
343 
344             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
345             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
346 
347             if(to != uniswapV2Pair) {
348                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
349             }
350 
351             uint256 contractTokenBalance = balanceOf(address(this));
352             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
353 
354             if(contractTokenBalance >= _maxTxAmount)
355             {
356                 contractTokenBalance = _maxTxAmount;
357             }
358 
359             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
360                 swapTokensForEth(contractTokenBalance);
361                 uint256 contractETHBalance = address(this).balance;
362                 if (contractETHBalance > 0) {
363                     sendETHToFee(address(this).balance);
364                 }
365             }
366         }
367 
368         bool takeFee = true;
369 
370         //Transfer Tokens
371         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
372             takeFee = false;
373         } else {
374 
375             //Set Fee for Buys
376             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
377                 _redisFee = _redisFeeOnBuy;
378                 _taxFee = _taxFeeOnBuy;
379             }
380 
381             //Set Fee for Sells
382             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
383                 _redisFee = _redisFeeOnSell;
384                 _taxFee = _taxFeeOnSell;
385             }
386 
387         }
388 
389         _tokenTransfer(from, to, amount, takeFee);
390     }
391 
392     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
393         address[] memory path = new address[](2);
394         path[0] = address(this);
395         path[1] = uniswapV2Router.WETH();
396         _approve(address(this), address(uniswapV2Router), tokenAmount);
397         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
398             tokenAmount,
399             0,
400             path,
401             address(this),
402             block.timestamp
403         );
404     }
405 
406     function sendETHToFee(uint256 amount) private {
407         _developmentAddress.transfer(amount.div(2));
408         _marketingAddress.transfer(amount.div(2));
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
498 
499         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
500     }
501 
502     function _getTValues(
503         uint256 tAmount,
504         uint256 redisFee,
505         uint256 taxFee
506     )
507         private
508         pure
509         returns (
510             uint256,
511             uint256,
512             uint256
513         )
514     {
515         uint256 tFee = tAmount.mul(redisFee).div(100);
516         uint256 tTeam = tAmount.mul(taxFee).div(100);
517         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
518 
519         return (tTransferAmount, tFee, tTeam);
520     }
521 
522     function _getRValues(
523         uint256 tAmount,
524         uint256 tFee,
525         uint256 tTeam,
526         uint256 currentRate
527     )
528         private
529         pure
530         returns (
531             uint256,
532             uint256,
533             uint256
534         )
535     {
536         uint256 rAmount = tAmount.mul(currentRate);
537         uint256 rFee = tFee.mul(currentRate);
538         uint256 rTeam = tTeam.mul(currentRate);
539         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
540 
541         return (rAmount, rTransferAmount, rFee);
542     }
543 
544     function _getRate() private view returns (uint256) {
545         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
546 
547         return rSupply.div(tSupply);
548     }
549 
550     function _getCurrentSupply() private view returns (uint256, uint256) {
551         uint256 rSupply = _rTotal;
552         uint256 tSupply = _tTotal;
553         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
554 
555         return (rSupply, tSupply);
556     }
557 
558     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
559         _redisFeeOnBuy = redisFeeOnBuy;
560         _redisFeeOnSell = redisFeeOnSell;
561 
562         _taxFeeOnBuy = taxFeeOnBuy;
563         _taxFeeOnSell = taxFeeOnSell;
564     }
565 
566     //Set minimum tokens required to swap.
567     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
568         _swapTokensAtAmount = swapTokensAtAmount;
569     }
570 
571     //Set minimum tokens required to swap.
572     function toggleSwap(bool _swapEnabled) public onlyOwner {
573         swapEnabled = _swapEnabled;
574     }
575 
576     //Set MAx transaction
577     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
578         _maxTxAmount = maxTxAmount;
579     }
580 
581     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
582         _maxWalletSize = maxWalletSize;
583     }
584 
585     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
586         for(uint256 i = 0; i < accounts.length; i++) {
587             _isExcludedFromFee[accounts[i]] = excluded;
588         }
589     }
590 }