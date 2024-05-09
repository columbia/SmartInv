1 //website : https://AresHistory.com
2 //twitter : https://twitter.com/AresHistory
3 //tg : https://t.me/AresEntry
4 // SPDX-License-Identifier: Unlicensed
5 pragma solidity ^0.8.18;
6  
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 }
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14     function balanceOf(address account) external view returns (uint256);
15     function transfer(address recipient, uint256 amount) external returns (bool);
16     function allowance(address owner, address spender) external view returns (uint256);
17     function approve(address spender, uint256 amount) external returns (bool);
18     function transferFrom(
19         address sender,
20         address recipient,
21         uint256 amount
22     ) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(
25         address indexed owner,
26         address indexed spender,
27         uint256 value
28     );
29 }
30 contract Ownable is Context {
31     address private _owner;
32     address private _previousOwner;
33     event OwnershipTransferred(
34         address indexed previousOwner,
35         address indexed newOwner
36     );
37     constructor() {
38         address msgSender = _msgSender();
39         _owner = msgSender;
40         emit OwnershipTransferred(address(0), msgSender);
41     }
42     function owner() public view returns (address) {
43         return _owner;
44     }
45     modifier onlyOwner() {
46         require(_owner == _msgSender(), "Ownable: caller is not the owner");
47         _;
48     }
49     function renounceOwnership() public virtual onlyOwner {
50         emit OwnershipTransferred(_owner, address(0));
51         _owner = address(0);
52     }
53  
54     function transferOwnership(address newOwner) public virtual onlyOwner {
55         require(newOwner != address(0), "Ownable: new owner is the zero address");
56         emit OwnershipTransferred(_owner, newOwner);
57         _owner = newOwner;
58     }
59 }
60 library SafeMath {
61     function add(uint256 a, uint256 b) internal pure returns (uint256) {
62         uint256 c = a + b;
63         require(c >= a, "SafeMath: addition overflow");
64         return c;
65     }
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         return sub(a, b, "SafeMath: subtraction overflow");
68     }
69     function sub(
70         uint256 a,
71         uint256 b,
72         string memory errorMessage
73     ) internal pure returns (uint256) {
74         require(b <= a, errorMessage);
75         uint256 c = a - b;
76         return c;
77     }
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         if (a == 0) {
80             return 0;
81         }
82         uint256 c = a * b;
83         require(c / a == b, "SafeMath: multiplication overflow");
84         return c;
85     }
86     function div(uint256 a, uint256 b) internal pure returns (uint256) {
87         return div(a, b, "SafeMath: division by zero");
88     }
89     function div(
90         uint256 a,
91         uint256 b,
92         string memory errorMessage
93     ) internal pure returns (uint256) {
94         require(b > 0, errorMessage);
95         uint256 c = a / b;
96         return c;
97     }
98 }
99 interface IUniswapV2Factory {
100     function createPair(address tokenA, address tokenB)
101         external
102         returns (address pair);
103 }
104 interface IUniswapV2Router02 {
105     function swapExactTokensForETHSupportingFeeOnTransferTokens(
106         uint256 amountIn,
107         uint256 amountOutMin,
108         address[] calldata path,
109         address to,
110         uint256 deadline
111     ) external;
112     function factory() external pure returns (address);
113     function WETH() external pure returns (address);
114     function addLiquidityETH(
115         address token,
116         uint256 amountTokenDesired,
117         uint256 amountTokenMin,
118         uint256 amountETHMin,
119         address to,
120         uint256 deadline
121     )
122         external
123         payable
124         returns (
125             uint256 amountToken,
126             uint256 amountETH,
127             uint256 liquidity
128         );
129 }
130 contract AresHistory is Context, IERC20, Ownable {
131     using SafeMath for uint256;
132     string private constant _name = "Ares History";
133     string private constant _symbol = "AH";
134     uint8 private constant _decimals = 9;
135     mapping(address => uint256) private _rOwned;
136     mapping(address => uint256) private _tOwned;
137     mapping(address => mapping(address => uint256)) private _allowances;
138     mapping(address => bool) private _isExcludedFromFee;
139     uint256 private constant MAX = ~uint256(0);
140     uint256 private constant _tTotal = 1000000000 * 10**9;
141     uint256 private _rTotal = (MAX - (MAX % _tTotal));
142     uint256 private _tFeeTotal;
143     uint256 private _redisFeeOnBuy = 0;  
144     uint256 private _taxFeeOnBuy = 20;  
145     uint256 private _redisFeeOnSell = 0;  
146     uint256 private _taxFeeOnSell = 99;
147  
148     //Original Fee
149     uint256 private _redisFee = _redisFeeOnSell;
150     uint256 private _taxFee = _taxFeeOnSell;
151  
152     uint256 private _previousredisFee = _redisFee;
153     uint256 private _previoustaxFee = _taxFee;
154  
155     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
156     address payable private _developmentAddress = payable(0xb95C4Cd58919578acB9bfFc51559733A880E4D4B); 
157     address payable private _marketingAddress = payable(0xb696Ae88BA420fCdb746FD10A6C6AeE8AADcb775);
158  
159     IUniswapV2Router02 public uniswapV2Router;
160     address public uniswapV2Pair;
161  
162     bool private tradingOpen;
163     bool private inSwap = false;
164     bool private swapEnabled = true;
165  
166     uint256 public _maxTxAmount = 20000000 * 10**9; 
167     uint256 public _maxWalletSize = 20000000 * 10**9; 
168     uint256 public _swapTokensAtAmount = 10000000 * 10**9;
169  
170     event MaxTxAmountUpdated(uint256 _maxTxAmount);
171     modifier lockTheSwap {
172         inSwap = true;
173         _;
174         inSwap = false;
175     }
176  
177     constructor() {
178  
179         _rOwned[_msgSender()] = _rTotal;
180  
181         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
182         uniswapV2Router = _uniswapV2Router;
183         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
184             .createPair(address(this), _uniswapV2Router.WETH());
185  
186         _isExcludedFromFee[owner()] = true;
187         _isExcludedFromFee[address(this)] = true;
188         _isExcludedFromFee[_developmentAddress] = true;
189         _isExcludedFromFee[_marketingAddress] = true;
190  
191         emit Transfer(address(0), _msgSender(), _tTotal);
192     }
193  
194     function name() public pure returns (string memory) {
195         return _name;
196     }
197  
198     function symbol() public pure returns (string memory) {
199         return _symbol;
200     }
201  
202     function decimals() public pure returns (uint8) {
203         return _decimals;
204     }
205  
206     function totalSupply() public pure override returns (uint256) {
207         return _tTotal;
208     }
209  
210     function balanceOf(address account) public view override returns (uint256) {
211         return tokenFromReflection(_rOwned[account]);
212     }
213  
214     function transfer(address recipient, uint256 amount)
215         public
216         override
217         returns (bool)
218     {
219         _transfer(_msgSender(), recipient, amount);
220         return true;
221     }
222  
223     function allowance(address owner, address spender)
224         public
225         view
226         override
227         returns (uint256)
228     {
229         return _allowances[owner][spender];
230     }
231  
232     function approve(address spender, uint256 amount)
233         public
234         override
235         returns (bool)
236     {
237         _approve(_msgSender(), spender, amount);
238         return true;
239     }
240  
241     function transferFrom(
242         address sender,
243         address recipient,
244         uint256 amount
245     ) public override returns (bool) {
246         _transfer(sender, recipient, amount);
247         _approve(
248             sender,
249             _msgSender(),
250             _allowances[sender][_msgSender()].sub(
251                 amount,
252                 "ERC20: transfer amount exceeds allowance"
253             )
254         );
255         return true;
256     }
257  
258     function tokenFromReflection(uint256 rAmount)
259         private
260         view
261         returns (uint256)
262     {
263         require(
264             rAmount <= _rTotal,
265             "Amount must be less than total reflections"
266         );
267         uint256 currentRate = _getRate();
268         return rAmount.div(currentRate);
269     }
270  
271     function removeAllFee() private {
272         if (_redisFee == 0 && _taxFee == 0) return;
273  
274         _previousredisFee = _redisFee;
275         _previoustaxFee = _taxFee;
276  
277         _redisFee = 0;
278         _taxFee = 0;
279     }
280  
281     function restoreAllFee() private {
282         _redisFee = _previousredisFee;
283         _taxFee = _previoustaxFee;
284     }
285  
286     function _approve(
287         address owner,
288         address spender,
289         uint256 amount
290     ) private {
291         require(owner != address(0), "ERC20: approve from the zero address");
292         require(spender != address(0), "ERC20: approve to the zero address");
293         _allowances[owner][spender] = amount;
294         emit Approval(owner, spender, amount);
295     }
296  
297     function _transfer(
298         address from,
299         address to,
300         uint256 amount
301     ) private {
302         require(from != address(0), "ERC20: transfer from the zero address");
303         require(to != address(0), "ERC20: transfer to the zero address");
304         require(amount > 0, "Transfer amount must be greater than zero");
305  
306         if (from != owner() && to != owner()) {
307  
308             //Trade start check
309             if (!tradingOpen) {
310                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
311             }
312  
313             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
314             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
315  
316             if(to != uniswapV2Pair) {
317                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
318             }
319  
320             uint256 contractTokenBalance = balanceOf(address(this));
321             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
322  
323             if(contractTokenBalance >= _swapTokensAtAmount)
324             {
325                 contractTokenBalance = _swapTokensAtAmount;
326             }
327  
328             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
329                 swapTokensForEth(contractTokenBalance);
330                 uint256 contractETHBalance = address(this).balance;
331                 if (contractETHBalance > 0) {
332                     sendETHToFee(address(this).balance);
333                 }
334             }
335         }
336  
337         bool takeFee = true;
338  
339         //Transfer Tokens
340         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
341             takeFee = false;
342         } else {
343  
344             //Set Fee for Buys
345             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
346                 _redisFee = _redisFeeOnBuy;
347                 _taxFee = _taxFeeOnBuy;
348             }
349  
350             //Set Fee for Sells
351             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
352                 _redisFee = _redisFeeOnSell;
353                 _taxFee = _taxFeeOnSell;
354             }
355  
356         }
357  
358         _tokenTransfer(from, to, amount, takeFee);
359     }
360  
361     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
362         address[] memory path = new address[](2);
363         path[0] = address(this);
364         path[1] = uniswapV2Router.WETH();
365         _approve(address(this), address(uniswapV2Router), tokenAmount);
366         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
367             tokenAmount,
368             0,
369             path,
370             address(this),
371             block.timestamp
372         );
373     }
374  
375     function sendETHToFee(uint256 amount) private {
376         _marketingAddress.transfer(amount/2);
377         _developmentAddress.transfer(amount/2);
378     }
379  
380     function enableTrading(bool _tradingOpen) public onlyOwner {
381         tradingOpen = _tradingOpen;
382     }
383  
384     function manualswap() external {
385         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
386         uint256 contractBalance = balanceOf(address(this));
387         swapTokensForEth(contractBalance);
388     }
389  
390     function manualsend() external {
391         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
392         uint256 contractETHBalance = address(this).balance;
393         sendETHToFee(contractETHBalance);
394     }
395  
396     function addBots(address[] memory bots_,bool _status) public onlyOwner {
397         for (uint256 i = 0; i < bots_.length; i++) {
398             bots[bots_[i]] = _status;
399         }
400     }
401  
402     function removeBot(address notbot) public onlyOwner {
403         bots[notbot] = false;
404     }
405  
406     function _tokenTransfer(
407         address sender,
408         address recipient,
409         uint256 amount,
410         bool takeFee
411     ) private {
412         if (!takeFee) removeAllFee();
413         _transferStandard(sender, recipient, amount);
414         if (!takeFee) restoreAllFee();
415     }
416  
417     function _transferStandard(
418         address sender,
419         address recipient,
420         uint256 tAmount
421     ) private {
422         (
423             uint256 rAmount,
424             uint256 rTransferAmount,
425             uint256 rFee,
426             uint256 tTransferAmount,
427             uint256 tFee,
428             uint256 tTeam
429         ) = _getValues(tAmount);
430         _rOwned[sender] = _rOwned[sender].sub(rAmount);
431         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
432         _takeTeam(tTeam);
433         _reflectFee(rFee, tFee);
434         emit Transfer(sender, recipient, tTransferAmount);
435     }
436  
437     function _takeTeam(uint256 tTeam) private {
438         uint256 currentRate = _getRate();
439         uint256 rTeam = tTeam.mul(currentRate);
440         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
441     }
442  
443     function _reflectFee(uint256 rFee, uint256 tFee) private {
444         _rTotal = _rTotal.sub(rFee);
445         _tFeeTotal = _tFeeTotal.add(tFee);
446     }
447  
448     receive() external payable {}
449  
450     function _getValues(uint256 tAmount)
451         private
452         view
453         returns (
454             uint256,
455             uint256,
456             uint256,
457             uint256,
458             uint256,
459             uint256
460         )
461     {
462         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
463             _getTValues(tAmount, _redisFee, _taxFee);
464         uint256 currentRate = _getRate();
465         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
466             _getRValues(tAmount, tFee, tTeam, currentRate);
467         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
468     }
469  
470     function _getTValues(
471         uint256 tAmount,
472         uint256 redisFee,
473         uint256 taxFee
474     )
475         private
476         pure
477         returns (
478             uint256,
479             uint256,
480             uint256
481         )
482     {
483         uint256 tFee = tAmount.mul(redisFee).div(100);
484         uint256 tTeam = tAmount.mul(taxFee).div(100);
485         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
486         return (tTransferAmount, tFee, tTeam);
487     }
488  
489     function _getRValues(
490         uint256 tAmount,
491         uint256 tFee,
492         uint256 tTeam,
493         uint256 currentRate
494     )
495         private
496         pure
497         returns (
498             uint256,
499             uint256,
500             uint256
501         )
502     {
503         uint256 rAmount = tAmount.mul(currentRate);
504         uint256 rFee = tFee.mul(currentRate);
505         uint256 rTeam = tTeam.mul(currentRate);
506         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
507         return (rAmount, rTransferAmount, rFee);
508     }
509  
510     function _getRate() private view returns (uint256) {
511         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
512         return rSupply.div(tSupply);
513     }
514  
515     function _getCurrentSupply() private view returns (uint256, uint256) {
516         uint256 rSupply = _rTotal;
517         uint256 tSupply = _tTotal;
518         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
519         return (rSupply, tSupply);
520     }
521  
522     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
523         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 4, "Buy rewards must be between 0% and 4%");
524         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 98, "Buy tax must be between 0% and 98%");
525         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 4, "Sell rewards must be between 0% and 4%");
526         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 98, "Sell tax must be between 0% and 98%");
527 
528         _redisFeeOnBuy = redisFeeOnBuy;
529         _redisFeeOnSell = redisFeeOnSell;
530         _taxFeeOnBuy = taxFeeOnBuy;
531         _taxFeeOnSell = taxFeeOnSell;
532 
533     }
534  
535     //Set minimum tokens required to swap.
536     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
537         _swapTokensAtAmount = swapTokensAtAmount;
538     }
539  
540     //Set minimum tokens required to swap.
541     function toggleSwap(bool _swapEnabled) public onlyOwner {
542         swapEnabled = _swapEnabled;
543     }
544  
545     //Set maximum transaction
546     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
547            _maxTxAmount = maxTxAmount;
548         
549     }
550  
551     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
552         _maxWalletSize = maxWalletSize;
553     }
554  
555     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
556         for(uint256 i = 0; i < accounts.length; i++) {
557             _isExcludedFromFee[accounts[i]] = excluded;
558         }
559     }
560 }