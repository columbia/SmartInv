1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-25
3 */
4 //Daddy Elon Tweeted Meme Tennis
5 //0% Tax Play. Send it higher than Vitalik's tweet!
6 //https://t.me/memetennisportal
7 
8 //SPDX-License-Identifier: UNLICENSED
9 pragma solidity ^0.8.4;
10  
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16  
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19  
20     function balanceOf(address account) external view returns (uint256);
21  
22     function transfer(address recipient, uint256 amount) external returns (bool);
23  
24     function allowance(address owner, address spender) external view returns (uint256);
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
42 contract Ownable is Context {
43     address private _owner;
44     address private _previousOwner;
45     event OwnershipTransferred(
46         address indexed previousOwner,
47         address indexed newOwner
48     );
49  
50     constructor() {
51         address msgSender = _msgSender();
52         _owner = msgSender;
53         emit OwnershipTransferred(address(0), msgSender);
54     }
55  
56     function owner() public view returns (address) {
57         return _owner;
58     }
59  
60     modifier onlyOwner() {
61         require(_owner == _msgSender(), "Ownable: caller is not the owner");
62         _;
63     }
64  
65     function renounceOwnership() public virtual onlyOwner {
66         emit OwnershipTransferred(_owner, address(0));
67         _owner = address(0);
68     }
69  
70     function transferOwnership(address newOwner) public virtual onlyOwner {
71         require(newOwner != address(0), "Ownable: new owner is the zero address");
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75  
76 }
77  
78 library SafeMath {
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         require(c >= a, "SafeMath: addition overflow");
82         return c;
83     }
84  
85     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86         return sub(a, b, "SafeMath: subtraction overflow");
87     }
88  
89     function sub(
90         uint256 a,
91         uint256 b,
92         string memory errorMessage
93     ) internal pure returns (uint256) {
94         require(b <= a, errorMessage);
95         uint256 c = a - b;
96         return c;
97     }
98  
99     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
100         if (a == 0) {
101             return 0;
102         }
103         uint256 c = a * b;
104         require(c / a == b, "SafeMath: multiplication overflow");
105         return c;
106     }
107  
108     function div(uint256 a, uint256 b) internal pure returns (uint256) {
109         return div(a, b, "SafeMath: division by zero");
110     }
111  
112     function div(
113         uint256 a,
114         uint256 b,
115         string memory errorMessage
116     ) internal pure returns (uint256) {
117         require(b > 0, errorMessage);
118         uint256 c = a / b;
119         return c;
120     }
121 }
122  
123 interface IUniswapV2Factory {
124     function createPair(address tokenA, address tokenB)
125         external
126         returns (address pair);
127 }
128  
129 interface IUniswapV2Router02 {
130     function swapExactTokensForETHSupportingFeeOnTransferTokens(
131         uint256 amountIn,
132         uint256 amountOutMin,
133         address[] calldata path,
134         address to,
135         uint256 deadline
136     ) external;
137  
138     function factory() external pure returns (address);
139  
140     function WETH() external pure returns (address);
141  
142     function addLiquidityETH(
143         address token,
144         uint256 amountTokenDesired,
145         uint256 amountTokenMin,
146         uint256 amountETHMin,
147         address to,
148         uint256 deadline
149     )
150         external
151         payable
152         returns (
153             uint256 amountToken,
154             uint256 amountETH,
155             uint256 liquidity
156         );
157 }
158  
159 contract MemeTennis is Context, IERC20, Ownable {
160  
161     using SafeMath for uint256;
162  
163     string private constant _name = "Meme Tennis";
164     string private constant _symbol = "MTennis";
165     uint8 private constant _decimals = 9;
166  
167     mapping(address => uint256) private _rOwned;
168     mapping(address => uint256) private _tOwned;
169     mapping(address => mapping(address => uint256)) private _allowances;
170     mapping(address => bool) private _isExcludedFromFee;
171     uint256 private constant MAX = ~uint256(0);
172 
173     uint256 private constant _tTotal = 1000000000 * 10**9;
174     uint256 private _rTotal = (MAX - (MAX % _tTotal));
175     uint256 private _tFeeTotal;
176  
177     //Buy Fee
178     uint256 private _redisFeeOnBuy = 0;  
179     uint256 private _taxFeeOnBuy = 3;   
180  
181     //Sell Fee
182     uint256 private _redisFeeOnSell = 0; 
183     uint256 private _taxFeeOnSell = 3;  
184 
185     uint256 public totalFees;
186  
187     //Original Fee
188     uint256 private _redisFee = _redisFeeOnSell;
189     uint256 private _taxFee = _taxFeeOnSell;
190  
191     uint256 private _previousredisFee = _redisFee;
192     uint256 private _previoustaxFee = _taxFee;
193  
194     mapping(address => uint256) private cooldown;
195  
196     address payable private _developmentAddress = payable(0x7b6C7dadDa6820436708851E8E082b83fCeFe2dF);
197     address payable private _marketingAddress = payable(0x7b6C7dadDa6820436708851E8E082b83fCeFe2dF);
198  
199     IUniswapV2Router02 public uniswapV2Router;
200     address public uniswapV2Pair;
201  
202     bool private tradingOpen;
203     bool private inSwap = false;
204     bool private swapEnabled = true;
205  
206     uint256 public _maxTxAmount = 20000000 * 10**9; 
207     uint256 public _maxWalletSize = 20000000 * 10**9; 
208     uint256 public _swapTokensAtAmount = 10000 * 10**9; 
209  
210     event MaxTxAmountUpdated(uint256 _maxTxAmount);
211     modifier lockTheSwap {
212         inSwap = true;
213         _;
214         inSwap = false;
215     }
216  
217     constructor() {
218  
219         _rOwned[_msgSender()] = _rTotal;
220  
221         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
222         uniswapV2Router = _uniswapV2Router;
223         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
224             .createPair(address(this), _uniswapV2Router.WETH());
225  
226         _isExcludedFromFee[owner()] = true;
227         _isExcludedFromFee[address(this)] = true;
228         _isExcludedFromFee[_developmentAddress] = true;
229         _isExcludedFromFee[_marketingAddress] = true;
230  
231  
232         emit Transfer(address(0), _msgSender(), _tTotal);
233     }
234  
235     function name() public pure returns (string memory) {
236         return _name;
237     }
238  
239     function symbol() public pure returns (string memory) {
240         return _symbol;
241     }
242  
243     function decimals() public pure returns (uint8) {
244         return _decimals;
245     }
246  
247     function totalSupply() public pure override returns (uint256) {
248         return _tTotal;
249     }
250  
251     function balanceOf(address account) public view override returns (uint256) {
252         return tokenFromReflection(_rOwned[account]);
253     }
254  
255     function transfer(address recipient, uint256 amount)
256         public
257         override
258         returns (bool)
259     {
260         _transfer(_msgSender(), recipient, amount);
261         return true;
262     }
263  
264     function allowance(address owner, address spender)
265         public
266         view
267         override
268         returns (uint256)
269     {
270         return _allowances[owner][spender];
271     }
272  
273     function approve(address spender, uint256 amount)
274         public
275         override
276         returns (bool)
277     {
278         _approve(_msgSender(), spender, amount);
279         return true;
280     }
281  
282     function transferFrom(
283         address sender,
284         address recipient,
285         uint256 amount
286     ) public override returns (bool) {
287         _transfer(sender, recipient, amount);
288         _approve(
289             sender,
290             _msgSender(),
291             _allowances[sender][_msgSender()].sub(
292                 amount,
293                 "ERC20: transfer amount exceeds allowance"
294             )
295         );
296         return true;
297     }
298  
299     function tokenFromReflection(uint256 rAmount)
300         private
301         view
302         returns (uint256)
303     {
304         require(
305             rAmount <= _rTotal,
306             "Amount must be less than total reflections"
307         );
308         uint256 currentRate = _getRate();
309         return rAmount.div(currentRate);
310     }
311  
312     function removeAllFee() private {
313         if (_redisFee == 0 && _taxFee == 0) return;
314  
315         _previousredisFee = _redisFee;
316         _previoustaxFee = _taxFee;
317  
318         _redisFee = 0;
319         _taxFee = 0;
320     }
321  
322     function restoreAllFee() private {
323         _redisFee = _previousredisFee;
324         _taxFee = _previoustaxFee;
325     }
326  
327     function _approve(
328         address owner,
329         address spender,
330         uint256 amount
331     ) private {
332         require(owner != address(0), "ERC20: approve from the zero address");
333         require(spender != address(0), "ERC20: approve to the zero address");
334         _allowances[owner][spender] = amount;
335         emit Approval(owner, spender, amount);
336     }
337  
338     function _transfer(
339         address from,
340         address to,
341         uint256 amount
342     ) private {
343         require(from != address(0), "ERC20: transfer from the zero address");
344         require(to != address(0), "ERC20: transfer to the zero address");
345         require(amount > 0, "Transfer amount must be greater than zero");
346  
347         if (from != owner() && to != owner()) {
348  
349             //Trade start check
350             if (!tradingOpen) {
351                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
352             }
353  
354             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
355  
356             if(to != uniswapV2Pair) {
357                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
358             }
359  
360             uint256 contractTokenBalance = balanceOf(address(this));
361             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
362  
363             if(contractTokenBalance >= _maxTxAmount)
364             {
365                 contractTokenBalance = _maxTxAmount;
366             }
367  
368             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
369                 swapTokensForEth(contractTokenBalance);
370                 uint256 contractETHBalance = address(this).balance;
371                 if (contractETHBalance > 0) {
372                     sendETHToFee(address(this).balance);
373                 }
374             }
375         }
376  
377         bool takeFee = true;
378  
379         //Transfer Tokens
380         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
381             takeFee = false;
382         } else {
383  
384             //Set Fee for Buys
385             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
386                 _redisFee = _redisFeeOnBuy;
387                 _taxFee = _taxFeeOnBuy;
388             }
389  
390             //Set Fee for Sells
391             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
392                 _redisFee = _redisFeeOnSell;
393                 _taxFee = _taxFeeOnSell;
394             }
395  
396         }
397  
398         _tokenTransfer(from, to, amount, takeFee);
399     }
400  
401     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
402         address[] memory path = new address[](2);
403         path[0] = address(this);
404         path[1] = uniswapV2Router.WETH();
405         _approve(address(this), address(uniswapV2Router), tokenAmount);
406         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
407             tokenAmount,
408             0,
409             path,
410             address(this),
411             block.timestamp
412         );
413     }
414  
415     function sendETHToFee(uint256 amount) private {
416         _developmentAddress.transfer(amount.div(2));
417         _marketingAddress.transfer(amount.div(2));
418     }
419  
420     function setTrading(bool _tradingOpen) public onlyOwner {
421         tradingOpen = _tradingOpen;
422     }
423  
424     function manualswap() external {
425         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
426         uint256 contractBalance = balanceOf(address(this));
427         swapTokensForEth(contractBalance);
428     }
429  
430     function manualsend() external {
431         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
432         uint256 contractETHBalance = address(this).balance;
433         sendETHToFee(contractETHBalance);
434     }
435  
436     function _tokenTransfer(
437         address sender,
438         address recipient,
439         uint256 amount,
440         bool takeFee
441     ) private {
442         if (!takeFee) removeAllFee();
443         _transferStandard(sender, recipient, amount);
444         if (!takeFee) restoreAllFee();
445     }
446  
447     function _transferStandard(
448         address sender,
449         address recipient,
450         uint256 tAmount
451     ) private {
452         (
453             uint256 rAmount,
454             uint256 rTransferAmount,
455             uint256 rFee,
456             uint256 tTransferAmount,
457             uint256 tFee,
458             uint256 tTeam
459         ) = _getValues(tAmount);
460         _rOwned[sender] = _rOwned[sender].sub(rAmount);
461         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
462         _takeTeam(tTeam);
463         _reflectFee(rFee, tFee);
464         emit Transfer(sender, recipient, tTransferAmount);
465     }
466  
467     function _takeTeam(uint256 tTeam) private {
468         uint256 currentRate = _getRate();
469         uint256 rTeam = tTeam.mul(currentRate);
470         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
471     }
472  
473     function _reflectFee(uint256 rFee, uint256 tFee) private {
474         _rTotal = _rTotal.sub(rFee);
475         _tFeeTotal = _tFeeTotal.add(tFee);
476     }
477  
478     receive() external payable {}
479  
480     function _getValues(uint256 tAmount)
481         private
482         view
483         returns (
484             uint256,
485             uint256,
486             uint256,
487             uint256,
488             uint256,
489             uint256
490         )
491     {
492         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
493             _getTValues(tAmount, _redisFee, _taxFee);
494         uint256 currentRate = _getRate();
495         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
496             _getRValues(tAmount, tFee, tTeam, currentRate);
497  
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
517  
518         return (tTransferAmount, tFee, tTeam);
519     }
520  
521     function _getRValues(
522         uint256 tAmount,
523         uint256 tFee,
524         uint256 tTeam,
525         uint256 currentRate
526     )
527         private
528         pure
529         returns (
530             uint256,
531             uint256,
532             uint256
533         )
534     {
535         uint256 rAmount = tAmount.mul(currentRate);
536         uint256 rFee = tFee.mul(currentRate);
537         uint256 rTeam = tTeam.mul(currentRate);
538         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
539  
540         return (rAmount, rTransferAmount, rFee);
541     }
542  
543     function _getRate() private view returns (uint256) {
544         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
545  
546         return rSupply.div(tSupply);
547     }
548  
549     function _getCurrentSupply() private view returns (uint256, uint256) {
550         uint256 rSupply = _rTotal;
551         uint256 tSupply = _tTotal;
552         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
553  
554         return (rSupply, tSupply);
555     }
556  
557     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
558         _redisFeeOnBuy = redisFeeOnBuy;
559         _redisFeeOnSell = redisFeeOnSell;
560         _taxFeeOnBuy = taxFeeOnBuy;
561         _taxFeeOnSell = taxFeeOnSell;
562         totalFees = _redisFeeOnBuy + _redisFeeOnSell + _taxFeeOnBuy + _taxFeeOnSell;
563         require(totalFees <= 10, "Must keep fees at 10% or less");
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
576  
577     //Set max buy amount 
578     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
579         _maxTxAmount = maxTxAmount;
580     }
581 
582     //Set max wallet amount 
583     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
584         _maxWalletSize = maxWalletSize;
585     }
586 
587     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
588         for(uint256 i = 0; i < accounts.length; i++) {
589             _isExcludedFromFee[accounts[i]] = excluded;
590         }
591     }
592 }