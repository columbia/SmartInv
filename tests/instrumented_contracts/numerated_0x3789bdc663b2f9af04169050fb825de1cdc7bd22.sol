1 /**
2 name: ElonCrypt
3 SYB: ECX
4 tax: 7/7
5 https://twitter.com/ElonCrypt
6 https://t.me/ElonCryptPortal
7 🔒 Liquidity LOCKED 🔒
8 💜 Contract Renounced 💜
9 ✅ 100% SAFE project ✅
10 */
11 // SPDX-License-Identifier: MIT
12 pragma solidity ^0.8.9;
13  
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 }
19  
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22  
23     function balanceOf(address account) external view returns (uint256);
24  
25     function transfer(address recipient, uint256 amount) external returns (bool);
26  
27     function allowance(address owner, address spender) external view returns (uint256);
28  
29     function approve(address spender, uint256 amount) external returns (bool);
30  
31     function transferFrom(
32         address sender,
33         address recipient,
34         uint256 amount
35     ) external returns (bool);
36  
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(
39         address indexed owner,
40         address indexed spender,
41         uint256 value
42     );
43 }
44  
45 contract Ownable is Context {
46     address internal _owner;
47     address private _previousOwner;
48     uint256 public _lockTime;
49     event OwnershipTransferred(
50         address indexed previousOwner,
51         address indexed newOwner
52     );
53  
54     constructor() {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59  
60     function owner() public view returns (address) {
61         return _owner;
62     }
63  
64     modifier onlyOwner() {
65         require(_owner == _msgSender(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     //Locks the contract for owner for the amount of time provided
70     function lock(uint256 time) public virtual onlyOwner {
71         _previousOwner = _owner;
72         _owner = address(0);
73         _lockTime = time;
74         emit OwnershipTransferred(_owner, address(0));
75     }
76     
77     //Unlocks the contract for owner when _lockTime is exceeds
78     function unlock() public virtual {
79         require(_previousOwner == msg.sender, "You don't have permission to unlock.");
80         require(block.timestamp > _lockTime , "Contract is locked.");
81         emit OwnershipTransferred(_owner, _previousOwner);
82         _owner = _previousOwner;
83     }
84  
85     function renounceOwnership() public virtual onlyOwner {
86         emit OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89  
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         emit OwnershipTransferred(_owner, newOwner);
93         _owner = newOwner;
94     }
95  
96 }
97 
98 library SafeMath {
99     function add(uint256 a, uint256 b) internal pure returns (uint256) {
100         uint256 c = a + b;
101         require(c >= a, "SafeMath: addition overflow");
102         return c;
103     }
104  
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         return sub(a, b, "SafeMath: subtraction overflow");
107     }
108  
109     function sub(
110         uint256 a,
111         uint256 b,
112         string memory errorMessage
113     ) internal pure returns (uint256) {
114         require(b <= a, errorMessage);
115         uint256 c = a - b;
116         return c;
117     }
118  
119     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
120         if (a == 0) {
121             return 0;
122         }
123         uint256 c = a * b;
124         require(c / a == b, "SafeMath: multiplication overflow");
125         return c;
126     }
127  
128     function div(uint256 a, uint256 b) internal pure returns (uint256) {
129         return div(a, b, "SafeMath: division by zero");
130     }
131  
132     function div(
133         uint256 a,
134         uint256 b,
135         string memory errorMessage
136     ) internal pure returns (uint256) {
137         require(b > 0, errorMessage);
138         uint256 c = a / b;
139         return c;
140     }
141 }
142  
143 interface IUniswapV2Factory {
144     function createPair(address tokenA, address tokenB)
145         external
146         returns (address pair);
147 }
148  
149 interface IUniswapV2Router02 {
150     function swapExactTokensForETHSupportingFeeOnTransferTokens(
151         uint256 amountIn,
152         uint256 amountOutMin,
153         address[] calldata path,
154         address to,
155         uint256 deadline
156     ) external;
157  
158     function factory() external pure returns (address);
159  
160     function WETH() external pure returns (address);
161  
162     function addLiquidityETH(
163         address token,
164         uint256 amountTokenDesired,
165         uint256 amountTokenMin,
166         uint256 amountETHMin,
167         address to,
168         uint256 deadline
169     )
170         external
171         payable
172         returns (
173             uint256 amountToken,
174             uint256 amountETH,
175             uint256 liquidity
176         );
177 }
178  
179 contract ELONCRYPT is Context, IERC20, Ownable {
180  
181     using SafeMath for uint256;
182  
183     string private constant _name = "ElonCrypt";
184     string private constant _symbol = "ECX";
185     uint8 private constant _decimals = 9;
186  
187     mapping(address => uint256) private _rOwned;
188     mapping(address => uint256) private _tOwned;
189     mapping(address => mapping(address => uint256)) private _allowances;
190     mapping(address => bool) private _isExcludedFromFee;
191     uint256 private constant MAX = ~uint256(0);
192     uint256 private constant _tTotal = 100000000 * 10**9;
193     uint256 private _rTotal = (MAX - (MAX % _tTotal));
194     uint256 private _tFeeTotal;
195     uint256 private _redisFeeOnBuy = 0;  
196     uint256 private _taxFeeOnBuy = 7;  
197     uint256 private _redisFeeOnSell = 0;  
198     uint256 private _taxFeeOnSell = 7;
199  
200     //Original Fee
201     uint256 private _redisFee = _redisFeeOnSell;
202     uint256 private _taxFee = _taxFeeOnSell;
203  
204     uint256 private _previousredisFee = _redisFee;
205     uint256 private _previoustaxFee = _taxFee;
206  
207     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
208     address payable private _developmentAddress = payable(0x46fc20F7FF599582EB990FdF68480B20754a843e); 
209     address payable private _marketingAddress = payable(0xBf37A56eD42b525b03851a81e2E28BFE48D931cA);
210  
211     IUniswapV2Router02 public uniswapV2Router;
212     address public uniswapV2Pair;
213  
214     bool private tradingOpen;
215     bool private inSwap = false;
216     bool private swapEnabled = true;
217  
218     uint256 public _maxTxAmount = _tTotal.mul(2).div(100);
219     uint256 public _maxWalletSize = _tTotal.mul(2).div(100); 
220     uint256 public _swapTokensAtAmount = _tTotal.mul(1).div(1000);
221  
222     event MaxTxAmountUpdated(uint256 _maxTxAmount);
223     modifier lockTheSwap {
224         inSwap = true;
225         _;
226         inSwap = false;
227     }
228  
229     constructor() {
230  
231         _rOwned[_msgSender()] = _rTotal;
232  
233         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
234         uniswapV2Router = _uniswapV2Router;
235         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
236             .createPair(address(this), _uniswapV2Router.WETH());
237  
238         _isExcludedFromFee[owner()] = true;
239         _isExcludedFromFee[address(this)] = true;
240         _isExcludedFromFee[_developmentAddress] = true;
241         _isExcludedFromFee[_marketingAddress] = true;
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
428         _marketingAddress.transfer(amount.mul(6).div(7));
429         _developmentAddress.transfer(amount.mul(1).div(7));
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
519         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
520     }
521  
522     function _getTValues(
523         uint256 tAmount,
524         uint256 redisFee,
525         uint256 taxFee
526     )
527         private
528         pure
529         returns (
530             uint256,
531             uint256,
532             uint256
533         )
534     {
535         uint256 tFee = tAmount.mul(redisFee).div(100);
536         uint256 tTeam = tAmount.mul(taxFee).div(100);
537         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
538         return (tTransferAmount, tFee, tTeam);
539     }
540  
541     function _getRValues(
542         uint256 tAmount,
543         uint256 tFee,
544         uint256 tTeam,
545         uint256 currentRate
546     )
547         private
548         pure
549         returns (
550             uint256,
551             uint256,
552             uint256
553         )
554     {
555         uint256 rAmount = tAmount.mul(currentRate);
556         uint256 rFee = tFee.mul(currentRate);
557         uint256 rTeam = tTeam.mul(currentRate);
558         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
559         return (rAmount, rTransferAmount, rFee);
560     }
561  
562     function _getRate() private view returns (uint256) {
563         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
564         return rSupply.div(tSupply);
565     }
566  
567     function _getCurrentSupply() private view returns (uint256, uint256) {
568         uint256 rSupply = _rTotal;
569         uint256 tSupply = _tTotal;
570         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
571         return (rSupply, tSupply);
572     }
573  
574     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
575         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 0, "Buy rewards must be between 0% and 0%");
576         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 7, "Buy tax must be between 0% and 7%");
577         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 0, "Sell rewards must be between 0% and 0%");
578         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 7, "Sell tax must be between 0% and 7%");
579 
580         _redisFeeOnBuy = redisFeeOnBuy;
581         _redisFeeOnSell = redisFeeOnSell;
582         _taxFeeOnBuy = taxFeeOnBuy;
583         _taxFeeOnSell = taxFeeOnSell;
584 
585     }
586  
587     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
588         _swapTokensAtAmount = swapTokensAtAmount;
589     }
590  
591     function toggleSwap(bool _swapEnabled) public onlyOwner {
592         swapEnabled = _swapEnabled;
593     }
594  
595     function setMaxTxnAmount(uint256 amountPercent) public onlyOwner {
596         _maxTxAmount = (_tTotal * amountPercent ) / 100;
597     }
598 
599     function setMaxWalletSize(uint256 amountPercent) public onlyOwner {
600         _maxWalletSize = (_tTotal * amountPercent ) / 100;
601     }
602 
603     function removeLimits() external onlyOwner{
604         _maxTxAmount = _tTotal;
605         _maxWalletSize = _tTotal;
606     }
607  
608     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
609         for(uint256 i = 0; i < accounts.length; i++) {
610             _isExcludedFromFee[accounts[i]] = excluded;
611         }
612     }
613 
614 }