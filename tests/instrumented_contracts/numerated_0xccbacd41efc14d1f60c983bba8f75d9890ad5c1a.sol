1 /*
2 It's Anime season.
3 
4 
5 TG: https://t.me/LuffyEntry
6 
7 */
8 // SPDX-License-Identifier: MIT
9 
10 pragma solidity ^0.8.8;
11 
12  
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 }
18  
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21  
22     function balanceOf(address account) external view returns (uint256);
23  
24     function transfer(address recipient, uint256 amount) external returns (bool);
25  
26     function allowance(address owner, address spender) external view returns (uint256);
27  
28     function approve(address spender, uint256 amount) external returns (bool);
29  
30     function transferFrom(
31         address sender,
32         address recipient,
33         uint256 amount
34     ) external returns (bool);
35  
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(
38         address indexed owner,
39         address indexed spender,
40         uint256 value
41     );
42 }
43  
44 contract Ownable is Context {
45     address internal _owner;
46     address private _previousOwner;
47     event OwnershipTransferred(
48         address indexed previousOwner,
49         address indexed newOwner
50     );
51  
52     constructor() {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57  
58     function owner() public view returns (address) {
59         return _owner;
60     }
61  
62     modifier onlyOwner() {
63         require(_owner == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66  
67     function renounceOwnership() public virtual onlyOwner {
68         emit OwnershipTransferred(_owner, address(0));
69         _owner = address(0);
70     }
71  
72     function transferOwnership(address newOwner) public virtual onlyOwner {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77  
78 }
79 
80 library SafeMath {
81     function add(uint256 a, uint256 b) internal pure returns (uint256) {
82         uint256 c = a + b;
83         require(c >= a, "SafeMath: addition overflow");
84         return c;
85     }
86  
87     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88         return sub(a, b, "SafeMath: subtraction overflow");
89     }
90  
91     function sub(
92         uint256 a,
93         uint256 b,
94         string memory errorMessage
95     ) internal pure returns (uint256) {
96         require(b <= a, errorMessage);
97         uint256 c = a - b;
98         return c;
99     }
100  
101     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
102         if (a == 0) {
103             return 0;
104         }
105         uint256 c = a * b;
106         require(c / a == b, "SafeMath: multiplication overflow");
107         return c;
108     }
109  
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         return div(a, b, "SafeMath: division by zero");
112     }
113  
114     function div(
115         uint256 a,
116         uint256 b,
117         string memory errorMessage
118     ) internal pure returns (uint256) {
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         return c;
122     }
123 }
124  
125 interface IUniswapV2Factory {
126     function createPair(address tokenA, address tokenB)
127         external
128         returns (address pair);
129 }
130  
131 interface IUniswapV2Router02 {
132     function swapExactTokensForETHSupportingFeeOnTransferTokens(
133         uint256 amountIn,
134         uint256 amountOutMin,
135         address[] calldata path,
136         address to,
137         uint256 deadline
138     ) external;
139  
140     function factory() external pure returns (address);
141  
142     function WETH() external pure returns (address);
143  
144     function addLiquidityETH(
145         address token,
146         uint256 amountTokenDesired,
147         uint256 amountTokenMin,
148         uint256 amountETHMin,
149         address to,
150         uint256 deadline
151     )
152         external
153         payable
154         returns (
155             uint256 amountToken,
156             uint256 amountETH,
157             uint256 liquidity
158         );
159 }
160  
161 contract LUFFY is Context, IERC20, Ownable {
162  
163     using SafeMath for uint256;
164  
165     string private constant _name = "LUFFY COIN";
166     string private constant _symbol = "LUFFY";
167     uint8 private constant _decimals = 9;
168  
169     mapping(address => uint256) private _rOwned;
170     mapping(address => uint256) private _tOwned;
171     mapping(address => mapping(address => uint256)) private _allowances;
172     mapping(address => bool) private _isExcludedFromFee;
173     uint256 private constant MAX = ~uint256(0);
174     uint256 private constant _tTotal = 1000000 * 10**9;
175     uint256 private _rTotal = (MAX - (MAX % _tTotal));
176     uint256 private _tFeeTotal;
177     uint256 private _redisFeeOnBuy = 0;  
178     uint256 private _taxFeeOnBuy = 15;  
179     uint256 private _redisFeeOnSell = 0;  
180     uint256 private _taxFeeOnSell = 30;
181  
182     uint256 private _redisFee = _redisFeeOnSell;
183     uint256 private _taxFee = _taxFeeOnSell;
184  
185     uint256 private _previousredisFee = _redisFee;
186     uint256 private _previoustaxFee = _taxFee;
187  
188     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
189     address payable private _developmentAddress = payable(0xD265197adC32E86b047dEF06F10c1F6E15507305); 
190     address payable private _marketingAddress = payable(0xD265197adC32E86b047dEF06F10c1F6E15507305);
191  
192     IUniswapV2Router02 public uniswapV2Router;
193     address public uniswapV2Pair;
194  
195     bool private tradingOpen;
196     bool private inSwap = false;
197     bool private swapEnabled = true;
198  
199     uint256 public _maxTxAmount = _tTotal.mul(2).div(100);
200     uint256 public _maxWalletSize = _tTotal.mul(2).div(100); 
201     uint256 public _swapTokensAtAmount = _tTotal.mul(5).div(1000);
202  
203     event MaxTxAmountUpdated(uint256 _maxTxAmount);
204     modifier lockTheSwap {
205         inSwap = true;
206         _;
207         inSwap = false;
208     }
209  
210     constructor() {
211  
212         _rOwned[_msgSender()] = _rTotal;
213  
214         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
215         uniswapV2Router = _uniswapV2Router;
216         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
217             .createPair(address(this), _uniswapV2Router.WETH());
218  
219         _isExcludedFromFee[owner()] = true;
220         _isExcludedFromFee[address(this)] = true;
221         _isExcludedFromFee[_developmentAddress] = true;
222         _isExcludedFromFee[_marketingAddress] = true;
223  
224         emit Transfer(address(0), _msgSender(), _tTotal);
225     }
226  
227     function name() public pure returns (string memory) {
228         return _name;
229     }
230  
231     function symbol() public pure returns (string memory) {
232         return _symbol;
233     }
234  
235     function decimals() public pure returns (uint8) {
236         return _decimals;
237     }
238  
239     function totalSupply() public pure override returns (uint256) {
240         return _tTotal;
241     }
242  
243     function balanceOf(address account) public view override returns (uint256) {
244         return tokenFromReflection(_rOwned[account]);
245     }
246  
247     function transfer(address recipient, uint256 amount)
248         public
249         override
250         returns (bool)
251     {
252         _transfer(_msgSender(), recipient, amount);
253         return true;
254     }
255  
256     function allowance(address owner, address spender)
257         public
258         view
259         override
260         returns (uint256)
261     {
262         return _allowances[owner][spender];
263     }
264  
265     function approve(address spender, uint256 amount)
266         public
267         override
268         returns (bool)
269     {
270         _approve(_msgSender(), spender, amount);
271         return true;
272     }
273  
274     function transferFrom(
275         address sender,
276         address recipient,
277         uint256 amount
278     ) public override returns (bool) {
279         _transfer(sender, recipient, amount);
280         _approve(
281             sender,
282             _msgSender(),
283             _allowances[sender][_msgSender()].sub(
284                 amount,
285                 "ERC20: transfer amount exceeds allowance"
286             )
287         );
288         return true;
289     }
290  
291     function tokenFromReflection(uint256 rAmount)
292         private
293         view
294         returns (uint256)
295     {
296         require(
297             rAmount <= _rTotal,
298             "Amount must be less than total reflections"
299         );
300         uint256 currentRate = _getRate();
301         return rAmount.div(currentRate);
302     }
303  
304     function removeAllFee() private {
305         if (_redisFee == 0 && _taxFee == 0) return;
306  
307         _previousredisFee = _redisFee;
308         _previoustaxFee = _taxFee;
309  
310         _redisFee = 0;
311         _taxFee = 0;
312     }
313  
314     function restoreAllFee() private {
315         _redisFee = _previousredisFee;
316         _taxFee = _previoustaxFee;
317     }
318  
319     function _approve(
320         address owner,
321         address spender,
322         uint256 amount
323     ) private {
324         require(owner != address(0), "ERC20: approve from the zero address");
325         require(spender != address(0), "ERC20: approve to the zero address");
326         _allowances[owner][spender] = amount;
327         emit Approval(owner, spender, amount);
328     }
329  
330     function _transfer(
331         address from,
332         address to,
333         uint256 amount
334     ) private {
335         require(from != address(0), "ERC20: transfer from the zero address");
336         require(to != address(0), "ERC20: transfer to the zero address");
337         require(amount > 0, "Transfer amount must be greater than zero");
338  
339         if (from != owner() && to != owner()) {
340  
341             //Trade start check
342             if (!tradingOpen) {
343                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
344             }
345  
346             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
347             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
348  
349             if(to != uniswapV2Pair) {
350                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
351             }
352  
353             uint256 contractTokenBalance = balanceOf(address(this));
354             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
355  
356             if(contractTokenBalance >= _maxTxAmount)
357             {
358                 contractTokenBalance = _maxTxAmount;
359             }
360  
361             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
362                 swapTokensForEth(contractTokenBalance);
363                 uint256 contractETHBalance = address(this).balance;
364                 if (contractETHBalance > 0) {
365                     sendETHToFee(address(this).balance);
366                 }
367             }
368         }
369  
370         bool takeFee = true;
371  
372         //Transfer Tokens
373         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
374             takeFee = false;
375         } else {
376  
377             //Set Fee for Buys
378             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
379                 _redisFee = _redisFeeOnBuy;
380                 _taxFee = _taxFeeOnBuy;
381             }
382  
383             //Set Fee for Sells
384             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
385                 _redisFee = _redisFeeOnSell;
386                 _taxFee = _taxFeeOnSell;
387             }
388  
389         }
390  
391         _tokenTransfer(from, to, amount, takeFee);
392     }
393  
394     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
395         address[] memory path = new address[](2);
396         path[0] = address(this);
397         path[1] = uniswapV2Router.WETH();
398         _approve(address(this), address(uniswapV2Router), tokenAmount);
399         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
400             tokenAmount,
401             0,
402             path,
403             address(this),
404             block.timestamp
405         );
406     }
407  
408     function sendETHToFee(uint256 amount) private {
409         _marketingAddress.transfer(amount.mul(3).div(5));
410         _developmentAddress.transfer(amount.mul(2).div(5));
411     }
412  
413     function setTrading(bool _tradingOpen) public onlyOwner {
414         tradingOpen = _tradingOpen;
415     }
416  
417     function manualswap() external {
418         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
419         uint256 contractBalance = balanceOf(address(this));
420         swapTokensForEth(contractBalance);
421     }
422  
423     function manualsend() external {
424         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
425         uint256 contractETHBalance = address(this).balance;
426         sendETHToFee(contractETHBalance);
427     }
428  
429     function blockBots(address[] memory bots_) public onlyOwner {
430         for (uint256 i = 0; i < bots_.length; i++) {
431             bots[bots_[i]] = true;
432         }
433     }
434  
435     function unblockBot(address notbot) public onlyOwner {
436         bots[notbot] = false;
437     }
438  
439     function _tokenTransfer(
440         address sender,
441         address recipient,
442         uint256 amount,
443         bool takeFee
444     ) private {
445         if (!takeFee) removeAllFee();
446         _transferStandard(sender, recipient, amount);
447         if (!takeFee) restoreAllFee();
448     }
449  
450     function _transferStandard(
451         address sender,
452         address recipient,
453         uint256 tAmount
454     ) private {
455         (
456             uint256 rAmount,
457             uint256 rTransferAmount,
458             uint256 rFee,
459             uint256 tTransferAmount,
460             uint256 tFee,
461             uint256 tTeam
462         ) = _getValues(tAmount);
463         _rOwned[sender] = _rOwned[sender].sub(rAmount);
464         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
465         _takeTeam(tTeam);
466         _reflectFee(rFee, tFee);
467         emit Transfer(sender, recipient, tTransferAmount);
468     }
469  
470     function _takeTeam(uint256 tTeam) private {
471         uint256 currentRate = _getRate();
472         uint256 rTeam = tTeam.mul(currentRate);
473         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
474     }
475  
476     function _reflectFee(uint256 rFee, uint256 tFee) private {
477         _rTotal = _rTotal.sub(rFee);
478         _tFeeTotal = _tFeeTotal.add(tFee);
479     }
480  
481     receive() external payable {}
482  
483     function _getValues(uint256 tAmount)
484         private
485         view
486         returns (
487             uint256,
488             uint256,
489             uint256,
490             uint256,
491             uint256,
492             uint256
493         )
494     {
495         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
496             _getTValues(tAmount, _redisFee, _taxFee);
497         uint256 currentRate = _getRate();
498         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
499             _getRValues(tAmount, tFee, tTeam, currentRate);
500         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
501     }
502  
503     function _getTValues(
504         uint256 tAmount,
505         uint256 redisFee,
506         uint256 taxFee
507     )
508         private
509         pure
510         returns (
511             uint256,
512             uint256,
513             uint256
514         )
515     {
516         uint256 tFee = tAmount.mul(redisFee).div(100);
517         uint256 tTeam = tAmount.mul(taxFee).div(100);
518         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
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
540         return (rAmount, rTransferAmount, rFee);
541     }
542  
543     function _getRate() private view returns (uint256) {
544         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
545         return rSupply.div(tSupply);
546     }
547  
548     function _getCurrentSupply() private view returns (uint256, uint256) {
549         uint256 rSupply = _rTotal;
550         uint256 tSupply = _tTotal;
551         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
552         return (rSupply, tSupply);
553     }
554  
555     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
556         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 0, "Buy rewards must be between 0% and 0%");
557         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 99, "Buy tax must be between 0% and 99%");
558         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 0, "Sell rewards must be between 0% and 0%");
559         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 99, "Sell tax must be between 0% and 99%");
560 
561         _redisFeeOnBuy = redisFeeOnBuy;
562         _redisFeeOnSell = redisFeeOnSell;
563         _taxFeeOnBuy = taxFeeOnBuy;
564         _taxFeeOnSell = taxFeeOnSell;
565 
566     }
567  
568     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
569         _swapTokensAtAmount = swapTokensAtAmount;
570     }
571  
572     function toggleSwap(bool _swapEnabled) public onlyOwner {
573         swapEnabled = _swapEnabled;
574     }
575  
576     function setMaxTxnAmount(uint256 amountPercent) public onlyOwner {
577         require(amountPercent>0);
578         _maxTxAmount = (_tTotal * amountPercent ) / 100;
579     }
580 
581     function setMaxWalletSize(uint256 amountPercent) public onlyOwner {
582         require(amountPercent>0);
583         _maxWalletSize = (_tTotal * amountPercent ) / 100;
584     }
585 
586     function removeLimits() external onlyOwner{
587         _maxTxAmount = _tTotal;
588         _maxWalletSize = _tTotal;
589     }
590  
591     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
592         for(uint256 i = 0; i < accounts.length; i++) {
593             _isExcludedFromFee[accounts[i]] = excluded;
594         }
595     }
596 
597 }