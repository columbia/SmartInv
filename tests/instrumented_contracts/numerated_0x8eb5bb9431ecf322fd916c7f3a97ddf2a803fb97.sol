1 /**
2 
3 
4 /*
5 
6 
7 http://www.TrendErc.io
8 
9 http://t.me/TrendErc
10 
11 https://twitter.com/ErcTrend
12 
13 */
14 
15 //SPDX-License-Identifier: UNLICENSED
16 pragma solidity ^0.8.9;
17  
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 }
23  
24 interface IERC20 {
25     function totalSupply() external view returns (uint256);
26  
27     function balanceOf(address account) external view returns (uint256);
28  
29     function transfer(address recipient, uint256 amount) external returns (bool);
30  
31     function allowance(address owner, address spender) external view returns (uint256);
32  
33     function approve(address spender, uint256 amount) external returns (bool);
34  
35     function transferFrom(
36         address sender,
37         address recipient,
38         uint256 amount
39     ) external returns (bool);
40  
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event Approval(
43         address indexed owner,
44         address indexed spender,
45         uint256 value
46     );
47 }
48  
49 contract Ownable is Context {
50     address private _owner;
51     address private _previousOwner;
52     event OwnershipTransferred(
53         address indexed previousOwner,
54         address indexed newOwner
55     );
56  
57     constructor() {
58         address msgSender = _msgSender();
59         _owner = msgSender;
60         emit OwnershipTransferred(address(0), msgSender);
61     }
62  
63     function owner() public view returns (address) {
64         return _owner;
65     }
66  
67     modifier onlyOwner() {
68         require(_owner == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71  
72     function renounceOwnership() public virtual onlyOwner {
73         emit OwnershipTransferred(_owner, address(0));
74         _owner = address(0);
75     }
76  
77     function transferOwnership(address newOwner) public virtual onlyOwner {
78         require(newOwner != address(0), "Ownable: new owner is the zero address");
79         emit OwnershipTransferred(_owner, newOwner);
80         _owner = newOwner;
81     }
82  
83 }
84  
85 library SafeMath {
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a + b;
88         require(c >= a, "SafeMath: addition overflow");
89         return c;
90     }
91  
92     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93         return sub(a, b, "SafeMath: subtraction overflow");
94     }
95  
96     function sub(
97         uint256 a,
98         uint256 b,
99         string memory errorMessage
100     ) internal pure returns (uint256) {
101         require(b <= a, errorMessage);
102         uint256 c = a - b;
103         return c;
104     }
105  
106     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107         if (a == 0) {
108             return 0;
109         }
110         uint256 c = a * b;
111         require(c / a == b, "SafeMath: multiplication overflow");
112         return c;
113     }
114  
115     function div(uint256 a, uint256 b) internal pure returns (uint256) {
116         return div(a, b, "SafeMath: division by zero");
117     }
118  
119     function div(
120         uint256 a,
121         uint256 b,
122         string memory errorMessage
123     ) internal pure returns (uint256) {
124         require(b > 0, errorMessage);
125         uint256 c = a / b;
126         return c;
127     }
128 }
129  
130 interface IUniswapV2Factory {
131     function createPair(address tokenA, address tokenB)
132         external
133         returns (address pair);
134 }
135  
136 interface IUniswapV2Router02 {
137     function swapExactTokensForETHSupportingFeeOnTransferTokens(
138         uint256 amountIn,
139         uint256 amountOutMin,
140         address[] calldata path,
141         address to,
142         uint256 deadline
143     ) external;
144  
145     function factory() external pure returns (address);
146  
147     function WETH() external pure returns (address);
148  
149     function addLiquidityETH(
150         address token,
151         uint256 amountTokenDesired,
152         uint256 amountTokenMin,
153         uint256 amountETHMin,
154         address to,
155         uint256 deadline
156     )
157         external
158         payable
159         returns (
160             uint256 amountToken,
161             uint256 amountETH,
162             uint256 liquidity
163         );
164 }
165  
166 contract TREND is Context, IERC20, Ownable {
167  
168     using SafeMath for uint256;
169  
170     string private constant _name = "Trend"; 
171     string private constant _symbol = "TREND"; 
172     uint8 private constant _decimals = 9;
173  
174     mapping(address => uint256) private _rOwned;
175     mapping(address => uint256) private _tOwned;
176     mapping(address => mapping(address => uint256)) private _allowances;
177     mapping(address => bool) private _isExcludedFromFee;
178     uint256 private constant MAX = ~uint256(0);
179 
180     uint256 private constant _tTotal = 1000000000000 * 10**9; 
181     uint256 private _rTotal = (MAX - (MAX % _tTotal));
182     uint256 private _tFeeTotal;
183  
184     //Buy Fee
185     uint256 private _feeOnBuy = 0;  
186     uint256 private _taxOnBuy = 30;   
187  
188     //Sell Fee
189     uint256 private _feeOnSell = 0; 
190     uint256 private _taxOnSell = 30;  
191 
192     uint256 public totalFees;
193  
194     //Original Fee
195     uint256 private _redisFee = _feeOnSell;
196     uint256 private _taxFee = _taxOnSell;
197  
198     uint256 private _previousredisFee = _redisFee;
199     uint256 private _previoustaxFee = _taxFee;
200  
201     mapping(address => uint256) private cooldown;
202  
203     address payable private _developmentWalletAddress = payable(0xA7c23F06A539738c98b6e11277bBAC361f4f531E);
204     address payable private _marketingWalletAddress = payable(0xfC09d27F94cEAA3216b5e1F439f82525B35cC737);
205  
206     IUniswapV2Router02 public uniswapV2Router;
207     address public uniswapV2Pair;
208  
209     bool private tradingOpen = false;
210     bool private inSwap = false;
211     bool private swapEnabled = true;
212  
213     uint256 public _maxTxAmount = 20000000000 * 10**9;
214     uint256 public _maxWalletSize = 20000000000 * 10**9;
215     uint256 public _swapTokensAtAmount = 10000 * 10**9; 
216  
217     event MaxTxAmountUpdated(uint256 _maxTxAmount);
218     modifier lockTheSwap {
219         inSwap = true;
220         _;
221         inSwap = false;
222     }
223  
224     constructor() {
225  
226         _rOwned[_msgSender()] = _rTotal;
227  
228         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
229         uniswapV2Router = _uniswapV2Router;
230         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
231             .createPair(address(this), _uniswapV2Router.WETH());
232  
233         _isExcludedFromFee[owner()] = true;
234         _isExcludedFromFee[address(this)] = true;
235         _isExcludedFromFee[_developmentWalletAddress] = true;
236         _isExcludedFromFee[_marketingWalletAddress] = true;
237  
238  
239         emit Transfer(address(0), _msgSender(), _tTotal);
240     }
241  
242     function name() public pure returns (string memory) {
243         return _name;
244     }
245  
246     function symbol() public pure returns (string memory) {
247         return _symbol;
248     }
249  
250     function decimals() public pure returns (uint8) {
251         return _decimals;
252     }
253  
254     function totalSupply() public pure override returns (uint256) {
255         return _tTotal;
256     }
257  
258     function balanceOf(address account) public view override returns (uint256) {
259         return tokenFromReflection(_rOwned[account]);
260     }
261  
262     function transfer(address recipient, uint256 amount)
263         public
264         override
265         returns (bool)
266     {
267         _transfer(_msgSender(), recipient, amount);
268         return true;
269     }
270  
271     function allowance(address owner, address spender)
272         public
273         view
274         override
275         returns (uint256)
276     {
277         return _allowances[owner][spender];
278     }
279  
280     function approve(address spender, uint256 amount)
281         public
282         override
283         returns (bool)
284     {
285         _approve(_msgSender(), spender, amount);
286         return true;
287     }
288  
289     function transferFrom(
290         address sender,
291         address recipient,
292         uint256 amount
293     ) public override returns (bool) {
294         _transfer(sender, recipient, amount);
295         _approve(
296             sender,
297             _msgSender(),
298             _allowances[sender][_msgSender()].sub(
299                 amount,
300                 "ERC20: transfer amount exceeds allowance"
301             )
302         );
303         return true;
304     }
305  
306     function tokenFromReflection(uint256 rAmount)
307         private
308         view
309         returns (uint256)
310     {
311         require(
312             rAmount <= _rTotal,
313             "Amount must be less than total reflections"
314         );
315         uint256 currentRate = _getRate();
316         return rAmount.div(currentRate);
317     }
318  
319     function removeAllFee() private {
320         if (_redisFee == 0 && _taxFee == 0) return;
321  
322         _previousredisFee = _redisFee;
323         _previoustaxFee = _taxFee;
324  
325         _redisFee = 0;
326         _taxFee = 0;
327     }
328  
329     function restoreAllFee() private {
330         _redisFee = _previousredisFee;
331         _taxFee = _previoustaxFee;
332     }
333  
334     function _approve(
335         address owner,
336         address spender,
337         uint256 amount
338     ) private {
339         require(owner != address(0), "ERC20: approve from the zero address");
340         require(spender != address(0), "ERC20: approve to the zero address");
341         _allowances[owner][spender] = amount;
342         emit Approval(owner, spender, amount);
343     }
344  
345     function _transfer(
346         address from,
347         address to,
348         uint256 amount
349     ) private {
350         require(from != address(0), "ERC20: transfer from the zero address");
351         require(to != address(0), "ERC20: transfer to the zero address");
352         require(amount > 0, "Transfer amount must be greater than zero");
353  
354         if (from != owner() && to != owner()) {
355  
356             //Trade start check
357             if (!tradingOpen) {
358                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
359             }
360  
361             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
362  
363             if(to != uniswapV2Pair) {
364                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
365             }
366  
367             uint256 contractTokenBalance = balanceOf(address(this));
368             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
369  
370             if(contractTokenBalance >= _maxTxAmount)
371             {
372                 contractTokenBalance = _maxTxAmount;
373             }
374  
375             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
376                 swapTokensForEth(contractTokenBalance);
377                 uint256 contractETHBalance = address(this).balance;
378                 if (contractETHBalance > 0) {
379                     sendETHToFee(address(this).balance);
380                 }
381             }
382         }
383  
384         bool takeFee = true;
385  
386         //Transfer Tokens
387         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
388             takeFee = false;
389         } else {
390  
391             //Set Fee for Buys
392             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
393                 _redisFee = _feeOnBuy;
394                 _taxFee = _taxOnBuy;
395             }
396  
397             //Set Fee for Sells
398             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
399                 _redisFee = _feeOnSell;
400                 _taxFee = _taxOnSell;
401             }
402  
403         }
404  
405         _tokenTransfer(from, to, amount, takeFee);
406     }
407  
408     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
409         address[] memory path = new address[](2);
410         path[0] = address(this);
411         path[1] = uniswapV2Router.WETH();
412         _approve(address(this), address(uniswapV2Router), tokenAmount);
413         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
414             tokenAmount,
415             0,
416             path,
417             address(this),
418             block.timestamp
419         );
420     }
421  
422     function sendETHToFee(uint256 amount) private {
423         _marketingWalletAddress.transfer(amount);
424     }
425  
426     function setTrading(bool _tradingOpen) public onlyOwner {
427         tradingOpen = _tradingOpen;
428     }
429  
430     function _tokenTransfer(
431         address sender,
432         address recipient,
433         uint256 amount,
434         bool takeFee
435     ) private {
436         if (!takeFee) removeAllFee();
437         _transferStandard(sender, recipient, amount);
438         if (!takeFee) restoreAllFee();
439     }
440  
441     function _transferStandard(
442         address sender,
443         address recipient,
444         uint256 tAmount
445     ) private {
446         (
447             uint256 rAmount,
448             uint256 rTransferAmount,
449             uint256 rFee,
450             uint256 tTransferAmount,
451             uint256 tFee,
452             uint256 tTeam
453         ) = _getValues(tAmount);
454         _rOwned[sender] = _rOwned[sender].sub(rAmount);
455         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
456         _takeTeam(tTeam);
457         _reflectFee(rFee, tFee);
458         emit Transfer(sender, recipient, tTransferAmount);
459     }
460  
461     function _takeTeam(uint256 tTeam) private {
462         uint256 currentRate = _getRate();
463         uint256 rTeam = tTeam.mul(currentRate);
464         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
465     }
466  
467     function _reflectFee(uint256 rFee, uint256 tFee) private {
468         _rTotal = _rTotal.sub(rFee);
469         _tFeeTotal = _tFeeTotal.add(tFee);
470     }
471  
472     receive() external payable {}
473  
474     function _getValues(uint256 tAmount)
475         private
476         view
477         returns (
478             uint256,
479             uint256,
480             uint256,
481             uint256,
482             uint256,
483             uint256
484         )
485     {
486         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
487             _getTValues(tAmount, _redisFee, _taxFee);
488         uint256 currentRate = _getRate();
489         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
490             _getRValues(tAmount, tFee, tTeam, currentRate);
491  
492         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
493     }
494  
495     function _getTValues(
496         uint256 tAmount,
497         uint256 redisFee,
498         uint256 taxFee
499     )
500         private
501         pure
502         returns (
503             uint256,
504             uint256,
505             uint256
506         )
507     {
508         uint256 tFee = tAmount.mul(redisFee).div(100);
509         uint256 tTeam = tAmount.mul(taxFee).div(100);
510         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
511  
512         return (tTransferAmount, tFee, tTeam);
513     }
514  
515     function _getRValues(
516         uint256 tAmount,
517         uint256 tFee,
518         uint256 tTeam,
519         uint256 currentRate
520     )
521         private
522         pure
523         returns (
524             uint256,
525             uint256,
526             uint256
527         )
528     {
529         uint256 rAmount = tAmount.mul(currentRate);
530         uint256 rFee = tFee.mul(currentRate);
531         uint256 rTeam = tTeam.mul(currentRate);
532         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
533  
534         return (rAmount, rTransferAmount, rFee);
535     }
536  
537     function _getRate() private view returns (uint256) {
538         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
539  
540         return rSupply.div(tSupply);
541     }
542  
543     function _getCurrentSupply() private view returns (uint256, uint256) {
544         uint256 rSupply = _rTotal;
545         uint256 tSupply = _tTotal;
546         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
547  
548         return (rSupply, tSupply);
549     }
550  
551     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
552         _feeOnBuy = redisFeeOnBuy;
553         _feeOnSell = redisFeeOnSell;
554         _taxOnBuy = taxFeeOnBuy;
555         _taxOnSell = taxFeeOnSell;
556         totalFees = _feeOnBuy + _feeOnSell + _taxOnBuy + _taxOnSell;
557         require(totalFees <= 100, "");
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
570     function noLimit() external onlyOwner{
571         _maxTxAmount = _tTotal;
572         _maxWalletSize = _tTotal;
573     }
574  
575     //Set max buy amount 
576     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
577         _maxTxAmount = maxTxAmount;
578     }
579 
580     //Set max wallet amount 
581     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
582         _maxWalletSize = maxWalletSize;
583     }
584 
585 }