1 /**
2  __      __     ____       ____       ____       ______      ____       ________     
3 /\ \  __/\ \   /\  _`\    /\  _`\    /\  _`\    /\__  _\    /\  _`\    /\_____  \    
4 \ \ \/\ \ \ \  \ \ \L\_\  \ \ \L\ \  \ \ \L\ \  \/_/\ \/    \ \ \L\_\  \/____//'/'   
5  \ \ \ \ \ \ \  \ \  _\L   \ \  _ <'  \ \  _ <'    \ \ \     \ \  _\L       //'/'    
6   \ \ \_/ \_\ \  \ \ \L\ \  \ \ \L\ \  \ \ \L\ \    \_\ \__   \ \ \L\ \    //'/'___  
7    \ `\___x___/   \ \____/   \ \____/   \ \____/    /\_____\   \ \____/    /\_______\
8     '\/__//__/     \/___/     \/___/     \/___/     \/_____/    \/___/     \/_______/
9 
10 Web 1.0 gave us basic websites, Web 2.0 gave us social networks, and today we have an Internet of Value: Web 3.0.
11 
12 https://www.webbiezeth.com/
13 https://medium.com/@webbiezeth
14 https://twitter.com/webbiezeth
15 
16 4% Buy/Sell Tax
17 */
18 
19 // SPDX-License-Identifier: UNLICENSED
20 pragma solidity ^0.8.4;
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 }
27 
28 interface IERC20 {
29     function totalSupply() external view returns (uint256);
30 
31     function balanceOf(address account) external view returns (uint256);
32 
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     function approve(address spender, uint256 amount) external returns (bool);
38 
39     function transferFrom(
40         address sender,
41         address recipient,
42         uint256 amount
43     ) external returns (bool);
44 
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     event Approval(
47         address indexed owner,
48         address indexed spender,
49         uint256 value
50     );
51 }
52 
53 contract Ownable is Context {
54     address private _owner;
55     address private _previousOwner;
56     event OwnershipTransferred(
57         address indexed previousOwner,
58         address indexed newOwner
59     );
60 
61     constructor() {
62         address msgSender = _msgSender();
63         _owner = msgSender;
64         emit OwnershipTransferred(address(0), msgSender);
65     }
66 
67     function owner() public view returns (address) {
68         return _owner;
69     }
70 
71     modifier onlyOwner() {
72         require(_owner == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     function renounceOwnership() public virtual onlyOwner {
77         emit OwnershipTransferred(_owner, address(0));
78         _owner = address(0);
79     }
80 
81     function transferOwnership(address newOwner) public virtual onlyOwner {
82         require(newOwner != address(0), "Ownable: new owner is the zero address");
83         emit OwnershipTransferred(_owner, newOwner);
84         _owner = newOwner;
85     }
86 
87 }
88 
89 library SafeMath {
90     function add(uint256 a, uint256 b) internal pure returns (uint256) {
91         uint256 c = a + b;
92         require(c >= a, "SafeMath: addition overflow");
93         return c;
94     }
95 
96     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97         return sub(a, b, "SafeMath: subtraction overflow");
98     }
99 
100     function sub(
101         uint256 a,
102         uint256 b,
103         string memory errorMessage
104     ) internal pure returns (uint256) {
105         require(b <= a, errorMessage);
106         uint256 c = a - b;
107         return c;
108     }
109 
110     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
111         if (a == 0) {
112             return 0;
113         }
114         uint256 c = a * b;
115         require(c / a == b, "SafeMath: multiplication overflow");
116         return c;
117     }
118 
119     function div(uint256 a, uint256 b) internal pure returns (uint256) {
120         return div(a, b, "SafeMath: division by zero");
121     }
122 
123     function div(
124         uint256 a,
125         uint256 b,
126         string memory errorMessage
127     ) internal pure returns (uint256) {
128         require(b > 0, errorMessage);
129         uint256 c = a / b;
130         return c;
131     }
132 }
133 
134 interface IUniswapV2Factory {
135     function createPair(address tokenA, address tokenB)
136         external
137         returns (address pair);
138 }
139 
140 interface IUniswapV2Router02 {
141     function swapExactTokensForETHSupportingFeeOnTransferTokens(
142         uint256 amountIn,
143         uint256 amountOutMin,
144         address[] calldata path,
145         address to,
146         uint256 deadline
147     ) external;
148 
149     function factory() external pure returns (address);
150 
151     function WETH() external pure returns (address);
152 
153     function addLiquidityETH(
154         address token,
155         uint256 amountTokenDesired,
156         uint256 amountTokenMin,
157         uint256 amountETHMin,
158         address to,
159         uint256 deadline
160     )
161         external
162         payable
163         returns (
164             uint256 amountToken,
165             uint256 amountETH,
166             uint256 liquidity
167         );
168 }
169 
170 contract Webbiez is Context, IERC20, Ownable {///////////////////////////////////////////////////////////
171 
172     using SafeMath for uint256;
173 
174     string private constant _name = "Webbiez";//////////////////////////
175     string private constant _symbol = "WBZ";//////////////////////////////////////////////////////////////////////////
176     uint8 private constant _decimals = 9;
177 
178     mapping(address => uint256) private _rOwned;
179     mapping(address => uint256) private _tOwned;
180     mapping(address => mapping(address => uint256)) private _allowances;
181     mapping(address => bool) private _isExcludedFromFee;
182     uint256 private constant MAX = ~uint256(0);
183     uint256 private constant _tTotal = 1000000000 * 10**9;
184     uint256 private _rTotal = (MAX - (MAX % _tTotal));
185     uint256 private _tFeeTotal;
186 
187     //Buy Fee
188     uint256 private _redisFeeOnBuy = 0;////////////////////////////////////////////////////////////////////
189     uint256 private _taxFeeOnBuy = 4;//////////////////////////////////////////////////////////////////////
190 
191     //Sell Fee
192     uint256 private _redisFeeOnSell = 0;/////////////////////////////////////////////////////////////////////
193     uint256 private _taxFeeOnSell = 4;/////////////////////////////////////////////////////////////////////
194 
195     //Original Fee
196     uint256 private _redisFee = _redisFeeOnSell;
197     uint256 private _taxFee = _taxFeeOnSell;
198 
199     uint256 private _previousredisFee = _redisFee;
200     uint256 private _previoustaxFee = _taxFee;
201 
202     mapping(address => bool) public bots;
203     mapping(address => uint256) private cooldown;
204 
205     address payable private _developmentAddress = payable(0x2c5B16642e1F7Bf18bA478060A6d73730A9A2F1e);/////////////////////////////////////////////////
206     address payable private _marketingAddress = payable(0x2c5B16642e1F7Bf18bA478060A6d73730A9A2F1e);///////////////////////////////////////////////////
207 
208     IUniswapV2Router02 public uniswapV2Router;
209     address public uniswapV2Pair;
210 
211     bool private tradingOpen;
212     bool private inSwap = false;
213     bool private swapEnabled = true;
214 
215     uint256 public _maxTxAmount = 10000000 * 10**9; //1%
216     uint256 public _maxWalletSize = 30000000 * 10**9; //3%
217     uint256 public _swapTokensAtAmount = 2000000 * 10**9; //.4%
218 
219     event MaxTxAmountUpdated(uint256 _maxTxAmount);
220     modifier lockTheSwap {
221         inSwap = true;
222         _;
223         inSwap = false;
224     }
225 
226     constructor() {
227 
228         _rOwned[_msgSender()] = _rTotal;
229 
230         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);/////////////////////////////////////////////////
231         uniswapV2Router = _uniswapV2Router;
232         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
233             .createPair(address(this), _uniswapV2Router.WETH());
234 
235         _isExcludedFromFee[owner()] = true;
236         _isExcludedFromFee[address(this)] = true;
237         _isExcludedFromFee[_developmentAddress] = true;
238         _isExcludedFromFee[_marketingAddress] = true;
239 
240 
241 
242 
243         emit Transfer(address(0), _msgSender(), _tTotal);
244     }
245 
246     function name() public pure returns (string memory) {
247         return _name;
248     }
249 
250     function symbol() public pure returns (string memory) {
251         return _symbol;
252     }
253 
254     function decimals() public pure returns (uint8) {
255         return _decimals;
256     }
257 
258     function totalSupply() public pure override returns (uint256) {
259         return _tTotal;
260     }
261 
262     function balanceOf(address account) public view override returns (uint256) {
263         return tokenFromReflection(_rOwned[account]);
264     }
265 
266     function transfer(address recipient, uint256 amount)
267         public
268         override
269         returns (bool)
270     {
271         _transfer(_msgSender(), recipient, amount);
272         return true;
273     }
274 
275     function allowance(address owner, address spender)
276         public
277         view
278         override
279         returns (uint256)
280     {
281         return _allowances[owner][spender];
282     }
283 
284     function approve(address spender, uint256 amount)
285         public
286         override
287         returns (bool)
288     {
289         _approve(_msgSender(), spender, amount);
290         return true;
291     }
292 
293     function transferFrom(
294         address sender,
295         address recipient,
296         uint256 amount
297     ) public override returns (bool) {
298         _transfer(sender, recipient, amount);
299         _approve(
300             sender,
301             _msgSender(),
302             _allowances[sender][_msgSender()].sub(
303                 amount,
304                 "ERC20: transfer amount exceeds allowance"
305             )
306         );
307         return true;
308     }
309 
310     function tokenFromReflection(uint256 rAmount)
311         private
312         view
313         returns (uint256)
314     {
315         require(
316             rAmount <= _rTotal,
317             "Amount must be less than total reflections"
318         );
319         uint256 currentRate = _getRate();
320         return rAmount.div(currentRate);
321     }
322 
323     function removeAllFee() private {
324         if (_redisFee == 0 && _taxFee == 0) return;
325 
326         _previousredisFee = _redisFee;
327         _previoustaxFee = _taxFee;
328 
329         _redisFee = 0;
330         _taxFee = 0;
331     }
332 
333     function restoreAllFee() private {
334         _redisFee = _previousredisFee;
335         _taxFee = _previoustaxFee;
336     }
337 
338     function _approve(
339         address owner,
340         address spender,
341         uint256 amount
342     ) private {
343         require(owner != address(0), "ERC20: approve from the zero address");
344         require(spender != address(0), "ERC20: approve to the zero address");
345         _allowances[owner][spender] = amount;
346         emit Approval(owner, spender, amount);
347     }
348 
349     function _transfer(
350         address from,
351         address to,
352         uint256 amount
353     ) private {
354         require(from != address(0), "ERC20: transfer from the zero address");
355         require(to != address(0), "ERC20: transfer to the zero address");
356         require(amount > 0, "Transfer amount must be greater than zero");
357 
358         if (from != owner() && to != owner()) {
359 
360             //Trade start check
361             if (!tradingOpen) {
362                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
363             }
364 
365             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
366             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
367 
368             if(to != uniswapV2Pair) {
369                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
370             }
371 
372             uint256 contractTokenBalance = balanceOf(address(this));
373             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
374 
375             if(contractTokenBalance >= _maxTxAmount)
376             {
377                 contractTokenBalance = _maxTxAmount;
378             }
379 
380             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
381                 swapTokensForEth(contractTokenBalance);
382                 uint256 contractETHBalance = address(this).balance;
383                 if (contractETHBalance > 0) {
384                     sendETHToFee(address(this).balance);
385                 }
386             }
387         }
388 
389         bool takeFee = true;
390 
391         //Transfer Tokens
392         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
393             takeFee = false;
394         } else {
395 
396             //Set Fee for Buys
397             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
398                 _redisFee = _redisFeeOnBuy;
399                 _taxFee = _taxFeeOnBuy;
400             }
401 
402             //Set Fee for Sells
403             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
404                 _redisFee = _redisFeeOnSell;
405                 _taxFee = _taxFeeOnSell;
406             }
407 
408         }
409 
410         _tokenTransfer(from, to, amount, takeFee);
411     }
412 
413     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
414         address[] memory path = new address[](2);
415         path[0] = address(this);
416         path[1] = uniswapV2Router.WETH();
417         _approve(address(this), address(uniswapV2Router), tokenAmount);
418         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
419             tokenAmount,
420             0,
421             path,
422             address(this),
423             block.timestamp
424         );
425     }
426 
427     function sendETHToFee(uint256 amount) private {
428         _developmentAddress.transfer(amount.div(2));
429         _marketingAddress.transfer(amount.div(2));
430     }
431 
432     function setTrading(bool _tradingOpen) public onlyOwner {
433         tradingOpen = _tradingOpen;
434     }
435 
436     function manualswap() external {
437         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
438         uint256 contractBalance = balanceOf(address(this));
439         swapTokensForEth(contractBalance);
440     }
441 
442     function manualsend() external {
443         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
444         uint256 contractETHBalance = address(this).balance;
445         sendETHToFee(contractETHBalance);
446     }
447 
448     function blockBots(address[] memory bots_) public onlyOwner {
449         for (uint256 i = 0; i < bots_.length; i++) {
450             bots[bots_[i]] = true;
451         }
452     }
453 
454     function unblockBot(address notbot) public onlyOwner {
455         bots[notbot] = false;
456     }
457 
458     function _tokenTransfer(
459         address sender,
460         address recipient,
461         uint256 amount,
462         bool takeFee
463     ) private {
464         if (!takeFee) removeAllFee();
465         _transferStandard(sender, recipient, amount);
466         if (!takeFee) restoreAllFee();
467     }
468 
469     function _transferStandard(
470         address sender,
471         address recipient,
472         uint256 tAmount
473     ) private {
474         (
475             uint256 rAmount,
476             uint256 rTransferAmount,
477             uint256 rFee,
478             uint256 tTransferAmount,
479             uint256 tFee,
480             uint256 tTeam
481         ) = _getValues(tAmount);
482         _rOwned[sender] = _rOwned[sender].sub(rAmount);
483         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
484         _takeTeam(tTeam);
485         _reflectFee(rFee, tFee);
486         emit Transfer(sender, recipient, tTransferAmount);
487     }
488 
489     function _takeTeam(uint256 tTeam) private {
490         uint256 currentRate = _getRate();
491         uint256 rTeam = tTeam.mul(currentRate);
492         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
493     }
494 
495     function _reflectFee(uint256 rFee, uint256 tFee) private {
496         _rTotal = _rTotal.sub(rFee);
497         _tFeeTotal = _tFeeTotal.add(tFee);
498     }
499 
500     receive() external payable {}
501 
502     function _getValues(uint256 tAmount)
503         private
504         view
505         returns (
506             uint256,
507             uint256,
508             uint256,
509             uint256,
510             uint256,
511             uint256
512         )
513     {
514         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
515             _getTValues(tAmount, _redisFee, _taxFee);
516         uint256 currentRate = _getRate();
517         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
518             _getRValues(tAmount, tFee, tTeam, currentRate);
519 
520         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
521     }
522 
523     function _getTValues(
524         uint256 tAmount,
525         uint256 redisFee,
526         uint256 taxFee
527     )
528         private
529         pure
530         returns (
531             uint256,
532             uint256,
533             uint256
534         )
535     {
536         uint256 tFee = tAmount.mul(redisFee).div(100);
537         uint256 tTeam = tAmount.mul(taxFee).div(100);
538         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
539 
540         return (tTransferAmount, tFee, tTeam);
541     }
542 
543     function _getRValues(
544         uint256 tAmount,
545         uint256 tFee,
546         uint256 tTeam,
547         uint256 currentRate
548     )
549         private
550         pure
551         returns (
552             uint256,
553             uint256,
554             uint256
555         )
556     {
557         uint256 rAmount = tAmount.mul(currentRate);
558         uint256 rFee = tFee.mul(currentRate);
559         uint256 rTeam = tTeam.mul(currentRate);
560         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
561 
562         return (rAmount, rTransferAmount, rFee);
563     }
564 
565     function _getRate() private view returns (uint256) {
566         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
567 
568         return rSupply.div(tSupply);
569     }
570 
571     function _getCurrentSupply() private view returns (uint256, uint256) {
572         uint256 rSupply = _rTotal;
573         uint256 tSupply = _tTotal;
574         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
575 
576         return (rSupply, tSupply);
577     }
578 
579     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
580         _redisFeeOnBuy = redisFeeOnBuy;
581         _redisFeeOnSell = redisFeeOnSell;
582 
583         _taxFeeOnBuy = taxFeeOnBuy;
584         _taxFeeOnSell = taxFeeOnSell;
585     }
586 
587     //Set minimum tokens required to swap.
588     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
589         _swapTokensAtAmount = swapTokensAtAmount;
590     }
591 
592     //Set minimum tokens required to swap.
593     function toggleSwap(bool _swapEnabled) public onlyOwner {
594         swapEnabled = _swapEnabled;
595     }
596 
597 
598     //Set MAx transaction
599     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
600         _maxTxAmount = maxTxAmount;
601     }
602 
603     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
604         _maxWalletSize = maxWalletSize;
605     }
606 
607     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
608         for(uint256 i = 0; i < accounts.length; i++) {
609             _isExcludedFromFee[accounts[i]] = excluded;
610         }
611     }
612 }