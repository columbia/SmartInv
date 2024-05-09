1 /**
2  *Submitted for verification at Etherscan.io on
3 */
4 
5 //SPDX-License-Identifier: UNLICENSED
6 pragma solidity ^0.8.4;
7  
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 }
13  
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16  
17     function balanceOf(address account) external view returns (uint256);
18  
19     function transfer(address recipient, uint256 amount) external returns (bool);
20  
21     function allowance(address owner, address spender) external view returns (uint256);
22  
23     function approve(address spender, uint256 amount) external returns (bool);
24  
25     function transferFrom(
26         address sender,
27         address recipient,
28         uint256 amount
29     ) external returns (bool);
30  
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(
33         address indexed owner,
34         address indexed spender,
35         uint256 value
36     );
37 }
38  
39 contract Ownable is Context {
40     address private _owner;
41     address private _previousOwner;
42     event OwnershipTransferred(
43         address indexed previousOwner,
44         address indexed newOwner
45     );
46  
47     constructor() {
48         address msgSender = _msgSender();
49         _owner = msgSender;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52  
53     function owner() public view returns (address) {
54         return _owner;
55     }
56  
57     modifier onlyOwner() {
58         require(_owner == _msgSender(), "Ownable: caller is not the owner");
59         _;
60     }
61  
62     function renounceOwnership() public virtual onlyOwner {
63         emit OwnershipTransferred(_owner, address(0));
64         _owner = address(0);
65     }
66  
67     function transferOwnership(address newOwner) public virtual onlyOwner {
68         require(newOwner != address(0), "Ownable: new owner is the zero address");
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72  
73 }
74  
75 library SafeMath {
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a, "SafeMath: addition overflow");
79         return c;
80     }
81  
82     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83         return sub(a, b, "SafeMath: subtraction overflow");
84     }
85  
86     function sub(
87         uint256 a,
88         uint256 b,
89         string memory errorMessage
90     ) internal pure returns (uint256) {
91         require(b <= a, errorMessage);
92         uint256 c = a - b;
93         return c;
94     }
95  
96     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97         if (a == 0) {
98             return 0;
99         }
100         uint256 c = a * b;
101         require(c / a == b, "SafeMath: multiplication overflow");
102         return c;
103     }
104  
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108  
109     function div(
110         uint256 a,
111         uint256 b,
112         string memory errorMessage
113     ) internal pure returns (uint256) {
114         require(b > 0, errorMessage);
115         uint256 c = a / b;
116         return c;
117     }
118 }
119  
120 interface IUniswapV2Factory {
121     function createPair(address tokenA, address tokenB)
122         external
123         returns (address pair);
124 }
125  
126 interface IUniswapV2Router02 {
127     function swapExactTokensForETHSupportingFeeOnTransferTokens(
128         uint256 amountIn,
129         uint256 amountOutMin,
130         address[] calldata path,
131         address to,
132         uint256 deadline
133     ) external;
134  
135     function factory() external pure returns (address);
136  
137     function WETH() external pure returns (address);
138  
139     function addLiquidityETH(
140         address token,
141         uint256 amountTokenDesired,
142         uint256 amountTokenMin,
143         uint256 amountETHMin,
144         address to,
145         uint256 deadline
146     )
147         external
148         payable
149         returns (
150             uint256 amountToken,
151             uint256 amountETH,
152             uint256 liquidity
153         );
154 }
155  
156 contract protocol is Context, IERC20, Ownable {
157  
158     using SafeMath for uint256;
159  
160     string private constant _name = "247 Protocol"; 
161     string private constant _symbol = "247"; 
162     uint8 private constant _decimals = 9;
163  
164     mapping(address => uint256) private _rOwned;
165     mapping(address => uint256) private _tOwned;
166     mapping(address => mapping(address => uint256)) private _allowances;
167     mapping(address => bool) private _isExcludedFromFee;
168     uint256 private constant MAX = ~uint256(0);
169 
170     uint256 private constant _tTotal = 1000000000 * 10**9; 
171     uint256 private _rTotal = (MAX - (MAX % _tTotal));
172     uint256 private _tFeeTotal;
173  
174     //Buy Fee
175     uint256 private _redisFeeOnBuy = 0;  
176     uint256 private _taxFeeOnBuy = 5;   
177  
178     //Sell Fee
179     uint256 private _redisFeeOnSell = 0; 
180     uint256 private _taxFeeOnSell = 5;  
181 
182     uint256 public totalFees;
183  
184     //Original Fee
185     uint256 private _redisFee = _redisFeeOnSell;
186     uint256 private _taxFee = _taxFeeOnSell;
187  
188     uint256 private _previousredisFee = _redisFee;
189     uint256 private _previoustaxFee = _taxFee;
190  
191     mapping(address => uint256) private cooldown;
192  
193     address payable private _developmentAddress = payable(0xA794a9D7489E005B9eDa59dFB2417c186088E897);
194     address payable private _marketingAddress = payable(0xA794a9D7489E005B9eDa59dFB2417c186088E897);
195  
196     IUniswapV2Router02 public uniswapV2Router;
197     address public uniswapV2Pair;
198  
199     bool private tradingOpen;
200     bool private inSwap = false;
201     bool private swapEnabled = true;
202  
203     uint256 public _maxTxAmount = 10000000 * 10**9;
204     uint256 public _maxWalletSize = 10000000 * 10**9; 
205     uint256 public _swapTokensAtAmount = 10000 * 10**9; 
206  
207     event MaxTxAmountUpdated(uint256 _maxTxAmount);
208     modifier lockTheSwap {
209         inSwap = true;
210         _;
211         inSwap = false;
212     }
213  
214     constructor() {
215  
216         _rOwned[_msgSender()] = _rTotal;
217  
218         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
219         uniswapV2Router = _uniswapV2Router;
220         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
221             .createPair(address(this), _uniswapV2Router.WETH());
222  
223         _isExcludedFromFee[owner()] = true;
224         _isExcludedFromFee[address(this)] = true;
225         _isExcludedFromFee[_developmentAddress] = true;
226         _isExcludedFromFee[_marketingAddress] = true;
227  
228  
229         emit Transfer(address(0), _msgSender(), _tTotal);
230     }
231  
232     function name() public pure returns (string memory) {
233         return _name;
234     }
235  
236     function symbol() public pure returns (string memory) {
237         return _symbol;
238     }
239  
240     function decimals() public pure returns (uint8) {
241         return _decimals;
242     }
243  
244     function totalSupply() public pure override returns (uint256) {
245         return _tTotal;
246     }
247  
248     function balanceOf(address account) public view override returns (uint256) {
249         return tokenFromReflection(_rOwned[account]);
250     }
251  
252     function transfer(address recipient, uint256 amount)
253         public
254         override
255         returns (bool)
256     {
257         _transfer(_msgSender(), recipient, amount);
258         return true;
259     }
260  
261     function allowance(address owner, address spender)
262         public
263         view
264         override
265         returns (uint256)
266     {
267         return _allowances[owner][spender];
268     }
269  
270     function approve(address spender, uint256 amount)
271         public
272         override
273         returns (bool)
274     {
275         _approve(_msgSender(), spender, amount);
276         return true;
277     }
278  
279     function transferFrom(
280         address sender,
281         address recipient,
282         uint256 amount
283     ) public override returns (bool) {
284         _transfer(sender, recipient, amount);
285         _approve(
286             sender,
287             _msgSender(),
288             _allowances[sender][_msgSender()].sub(
289                 amount,
290                 "ERC20: transfer amount exceeds allowance"
291             )
292         );
293         return true;
294     }
295  
296     function tokenFromReflection(uint256 rAmount)
297         private
298         view
299         returns (uint256)
300     {
301         require(
302             rAmount <= _rTotal,
303             "Amount must be less than total reflections"
304         );
305         uint256 currentRate = _getRate();
306         return rAmount.div(currentRate);
307     }
308  
309     function removeAllFee() private {
310         if (_redisFee == 0 && _taxFee == 0) return;
311  
312         _previousredisFee = _redisFee;
313         _previoustaxFee = _taxFee;
314  
315         _redisFee = 0;
316         _taxFee = 0;
317     }
318  
319     function restoreAllFee() private {
320         _redisFee = _previousredisFee;
321         _taxFee = _previoustaxFee;
322     }
323  
324     function _approve(
325         address owner,
326         address spender,
327         uint256 amount
328     ) private {
329         require(owner != address(0), "ERC20: approve from the zero address");
330         require(spender != address(0), "ERC20: approve to the zero address");
331         _allowances[owner][spender] = amount;
332         emit Approval(owner, spender, amount);
333     }
334  
335     function _transfer(
336         address from,
337         address to,
338         uint256 amount
339     ) private {
340         require(from != address(0), "ERC20: transfer from the zero address");
341         require(to != address(0), "ERC20: transfer to the zero address");
342         require(amount > 0, "Transfer amount must be greater than zero");
343  
344         if (from != owner() && to != owner()) {
345  
346             //Trade start check
347             if (!tradingOpen) {
348                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
349             }
350  
351             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
352  
353             if(to != uniswapV2Pair) {
354                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
355             }
356  
357             uint256 contractTokenBalance = balanceOf(address(this));
358             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
359  
360             if(contractTokenBalance >= _maxTxAmount)
361             {
362                 contractTokenBalance = _maxTxAmount;
363             }
364  
365             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
366                 swapTokensForEth(contractTokenBalance);
367                 uint256 contractETHBalance = address(this).balance;
368                 if (contractETHBalance > 0) {
369                     sendETHToFee(address(this).balance);
370                 }
371             }
372         }
373  
374         bool takeFee = true;
375  
376         //Transfer Tokens
377         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
378             takeFee = false;
379         } else {
380  
381             //Set Fee for Buys
382             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
383                 _redisFee = _redisFeeOnBuy;
384                 _taxFee = _taxFeeOnBuy;
385             }
386  
387             //Set Fee for Sells
388             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
389                 _redisFee = _redisFeeOnSell;
390                 _taxFee = _taxFeeOnSell;
391             }
392  
393         }
394  
395         _tokenTransfer(from, to, amount, takeFee);
396     }
397  
398     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
399         address[] memory path = new address[](2);
400         path[0] = address(this);
401         path[1] = uniswapV2Router.WETH();
402         _approve(address(this), address(uniswapV2Router), tokenAmount);
403         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
404             tokenAmount,
405             0,
406             path,
407             address(this),
408             block.timestamp
409         );
410     }
411  
412     function sendETHToFee(uint256 amount) private {
413         _developmentAddress.transfer(amount.div(2));
414         _marketingAddress.transfer(amount.div(2));
415     }
416  
417     function setTrading(bool _tradingOpen) public onlyOwner {
418         tradingOpen = _tradingOpen;
419     }
420  
421     function manualswap() external {
422         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
423         uint256 contractBalance = balanceOf(address(this));
424         swapTokensForEth(contractBalance);
425     }
426  
427     function manualsend() external {
428         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
429         uint256 contractETHBalance = address(this).balance;
430         sendETHToFee(contractETHBalance);
431     }
432  
433     function _tokenTransfer(
434         address sender,
435         address recipient,
436         uint256 amount,
437         bool takeFee
438     ) private {
439         if (!takeFee) removeAllFee();
440         _transferStandard(sender, recipient, amount);
441         if (!takeFee) restoreAllFee();
442     }
443  
444     function _transferStandard(
445         address sender,
446         address recipient,
447         uint256 tAmount
448     ) private {
449         (
450             uint256 rAmount,
451             uint256 rTransferAmount,
452             uint256 rFee,
453             uint256 tTransferAmount,
454             uint256 tFee,
455             uint256 tTeam
456         ) = _getValues(tAmount);
457         _rOwned[sender] = _rOwned[sender].sub(rAmount);
458         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
459         _takeTeam(tTeam);
460         _reflectFee(rFee, tFee);
461         emit Transfer(sender, recipient, tTransferAmount);
462     }
463  
464     function _takeTeam(uint256 tTeam) private {
465         uint256 currentRate = _getRate();
466         uint256 rTeam = tTeam.mul(currentRate);
467         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
468     }
469  
470     function _reflectFee(uint256 rFee, uint256 tFee) private {
471         _rTotal = _rTotal.sub(rFee);
472         _tFeeTotal = _tFeeTotal.add(tFee);
473     }
474  
475     receive() external payable {}
476  
477     function _getValues(uint256 tAmount)
478         private
479         view
480         returns (
481             uint256,
482             uint256,
483             uint256,
484             uint256,
485             uint256,
486             uint256
487         )
488     {
489         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
490             _getTValues(tAmount, _redisFee, _taxFee);
491         uint256 currentRate = _getRate();
492         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
493             _getRValues(tAmount, tFee, tTeam, currentRate);
494  
495         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
496     }
497  
498     function _getTValues(
499         uint256 tAmount,
500         uint256 redisFee,
501         uint256 taxFee
502     )
503         private
504         pure
505         returns (
506             uint256,
507             uint256,
508             uint256
509         )
510     {
511         uint256 tFee = tAmount.mul(redisFee).div(100);
512         uint256 tTeam = tAmount.mul(taxFee).div(100);
513         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
514  
515         return (tTransferAmount, tFee, tTeam);
516     }
517  
518     function _getRValues(
519         uint256 tAmount,
520         uint256 tFee,
521         uint256 tTeam,
522         uint256 currentRate
523     )
524         private
525         pure
526         returns (
527             uint256,
528             uint256,
529             uint256
530         )
531     {
532         uint256 rAmount = tAmount.mul(currentRate);
533         uint256 rFee = tFee.mul(currentRate);
534         uint256 rTeam = tTeam.mul(currentRate);
535         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
536  
537         return (rAmount, rTransferAmount, rFee);
538     }
539  
540     function _getRate() private view returns (uint256) {
541         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
542  
543         return rSupply.div(tSupply);
544     }
545  
546     function _getCurrentSupply() private view returns (uint256, uint256) {
547         uint256 rSupply = _rTotal;
548         uint256 tSupply = _tTotal;
549         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
550  
551         return (rSupply, tSupply);
552     }
553  
554     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
555         _redisFeeOnBuy = redisFeeOnBuy;
556         _redisFeeOnSell = redisFeeOnSell;
557         _taxFeeOnBuy = taxFeeOnBuy;
558         _taxFeeOnSell = taxFeeOnSell;
559         totalFees = _redisFeeOnBuy + _redisFeeOnSell + _taxFeeOnBuy + _taxFeeOnSell;
560         require(totalFees <= 10, "Must keep fees at 10% or less");
561     }
562  
563     //Set minimum tokens required to swap.
564     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
565         _swapTokensAtAmount = swapTokensAtAmount;
566     }
567  
568     //Set minimum tokens required to swap.
569     function toggleSwap(bool _swapEnabled) public onlyOwner {
570         swapEnabled = _swapEnabled;
571     }
572  
573  
574     //Set max buy amount 
575     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
576         _maxTxAmount = maxTxAmount;
577     }
578 
579     //Set max wallet amount 
580     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
581         _maxWalletSize = maxWalletSize;
582     }
583 
584     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
585         for(uint256 i = 0; i < accounts.length; i++) {
586             _isExcludedFromFee[accounts[i]] = excluded;
587         }
588     }
589 }