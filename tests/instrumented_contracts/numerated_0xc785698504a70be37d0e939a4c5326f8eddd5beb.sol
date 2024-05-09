1 // WWW.QUBYCOIN.IO
2 // @QUBYERC
3 // SPDX-License-Identifier: MIT
4    pragma solidity ^0.8.15;
5  
6    abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 }
11  
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14  
15     function balanceOf(address account) external view returns (uint256);
16  
17     function transfer(address recipient, uint256 amount) external returns (bool);
18  
19     function allowance(address owner, address spender) external view returns (uint256);
20  
21     function approve(address spender, uint256 amount) external returns (bool);
22  
23     function transferFrom(
24         address sender,
25         address recipient,
26         uint256 amount
27     ) external returns (bool);
28  
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(
31         address indexed owner,
32         address indexed spender,
33         uint256 value
34     );
35 }
36  
37 contract Ownable is Context {
38     address private _owner;
39     address private _previousOwner;
40     event OwnershipTransferred(
41         address indexed previousOwner,
42         address indexed newOwner
43     );
44  
45     constructor() {
46         address msgSender = _msgSender();
47         _owner = msgSender;
48         emit OwnershipTransferred(address(0), msgSender);
49     }
50  
51     function owner() public view returns (address) {
52         return _owner;
53     }
54  
55     modifier onlyOwner() {
56         require(_owner == _msgSender(), "Ownable: caller is not the owner");
57         _;
58     }
59  
60     function renounceOwnership() public virtual onlyOwner {
61         emit OwnershipTransferred(_owner, address(0));
62         _owner = address(0);
63     }
64  
65     function transferOwnership(address newOwner) public virtual onlyOwner {
66         require(newOwner != address(0), "Ownable: new owner is the zero address");
67         emit OwnershipTransferred(_owner, newOwner);
68         _owner = newOwner;
69     }
70  
71 }
72  
73 library SafeMath {
74     function add(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a + b;
76         require(c >= a, "SafeMath: addition overflow");
77         return c;
78     }
79  
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         return sub(a, b, "SafeMath: subtraction overflow");
82     }
83  
84     function sub(
85         uint256 a,
86         uint256 b,
87         string memory errorMessage
88     ) internal pure returns (uint256) {
89         require(b <= a, errorMessage);
90         uint256 c = a - b;
91         return c;
92     }
93  
94     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
95         if (a == 0) {
96             return 0;
97         }
98         uint256 c = a * b;
99         require(c / a == b, "SafeMath: multiplication overflow");
100         return c;
101     }
102  
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106  
107     function div(
108         uint256 a,
109         uint256 b,
110         string memory errorMessage
111     ) internal pure returns (uint256) {
112         require(b > 0, errorMessage);
113         uint256 c = a / b;
114         return c;
115     }
116 }
117  
118 interface IUniswapV2Factory {
119     function createPair(address tokenA, address tokenB)
120         external
121         returns (address pair);
122 }
123  
124 interface IUniswapV2Router02 {
125     function swapExactTokensForETHSupportingFeeOnTransferTokens(
126         uint256 amountIn,
127         uint256 amountOutMin,
128         address[] calldata path,
129         address to,
130         uint256 deadline
131     ) external;
132  
133     function factory() external pure returns (address);
134  
135     function WETH() external pure returns (address);
136  
137     function addLiquidityETH(
138         address token,
139         uint256 amountTokenDesired,
140         uint256 amountTokenMin,
141         uint256 amountETHMin,
142         address to,
143         uint256 deadline
144     )
145         external
146         payable
147         returns (
148             uint256 amountToken,
149             uint256 amountETH,
150             uint256 liquidity
151         );
152 }
153  
154 contract QUBY is Context, IERC20, Ownable {
155  
156     using SafeMath for uint256;
157  
158     string private constant _name = "QUBY"; 
159     string private constant _symbol = "QUBY"; 
160     uint8 private constant _decimals = 9;
161  
162     mapping(address => uint256) private _rOwned;
163     mapping(address => uint256) private _tOwned;
164     mapping(address => mapping(address => uint256)) private _allowances;
165     mapping(address => bool) private _isExcludedFromFee;
166     uint256 private constant MAX = ~uint256(0);
167 
168     uint256 private constant _tTotal = 100000000 * 10**9; 
169     uint256 private _rTotal = (MAX - (MAX % _tTotal));
170     uint256 private _tFeeTotal;
171  
172     //Buy Fee
173     uint256 private _feeOnBuy = 0;  
174     uint256 private _taxOnBuy = 19;  
175  
176     //Sell Fee
177     uint256 private _feeOnSell = 0; 
178     uint256 private _taxOnSell = 19;  
179 
180     uint256 public totalFees;
181  
182     //Original Fee
183     uint256 private _redisFee = _feeOnSell;
184     uint256 private _taxFee = _taxOnSell;
185  
186     uint256 private _previousredisFee = _redisFee;
187     uint256 private _previoustaxFee = _taxFee;
188  
189     mapping(address => uint256) private cooldown;
190  
191     address payable private _developmentWalletAddress = payable(0x45abc6e29C2458D03855436B18ab934F4c6F2734);
192     address payable private _marketingWalletAddress = payable(0x45abc6e29C2458D03855436B18ab934F4c6F2734);
193  
194     IUniswapV2Router02 public uniswapV2Router;
195     address public uniswapV2Pair;
196  
197     bool private tradingOpen = false;
198     bool private inSwap = false;
199     bool private swapEnabled = true;
200  
201     uint256 public _maxTxAmount = 2000000 * 10**9;
202     uint256 public _maxWalletSize = 2000000 * 10**9;
203     uint256 public _swapTokensAtAmount = 10000 * 10**9; 
204  
205     event MaxTxAmountUpdated(uint256 _maxTxAmount);
206     modifier lockTheSwap {
207         inSwap = true;
208         _;
209         inSwap = false;
210     }
211  
212     constructor() {
213  
214         _rOwned[_msgSender()] = _rTotal;
215  
216         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
217         uniswapV2Router = _uniswapV2Router;
218         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
219             .createPair(address(this), _uniswapV2Router.WETH());
220  
221         _isExcludedFromFee[owner()] = true;
222         _isExcludedFromFee[address(this)] = true;
223         _isExcludedFromFee[_developmentWalletAddress] = true;
224         _isExcludedFromFee[_marketingWalletAddress] = true;
225  
226  
227         emit Transfer(address(0), _msgSender(), _tTotal);
228     }
229  
230     function name() public pure returns (string memory) {
231         return _name;
232     }
233  
234     function symbol() public pure returns (string memory) {
235         return _symbol;
236     }
237  
238     function decimals() public pure returns (uint8) {
239         return _decimals;
240     }
241  
242     function totalSupply() public pure override returns (uint256) {
243         return _tTotal;
244     }
245  
246     function balanceOf(address account) public view override returns (uint256) {
247         return tokenFromReflection(_rOwned[account]);
248     }
249  
250     function transfer(address recipient, uint256 amount)
251         public
252         override
253         returns (bool)
254     {
255         _transfer(_msgSender(), recipient, amount);
256         return true;
257     }
258  
259     function allowance(address owner, address spender)
260         public
261         view
262         override
263         returns (uint256)
264     {
265         return _allowances[owner][spender];
266     }
267  
268     function approve(address spender, uint256 amount)
269         public
270         override
271         returns (bool)
272     {
273         _approve(_msgSender(), spender, amount);
274         return true;
275     }
276  
277     function transferFrom(
278         address sender,
279         address recipient,
280         uint256 amount
281     ) public override returns (bool) {
282         _transfer(sender, recipient, amount);
283         _approve(
284             sender,
285             _msgSender(),
286             _allowances[sender][_msgSender()].sub(
287                 amount,
288                 "ERC20: transfer amount exceeds allowance"
289             )
290         );
291         return true;
292     }
293  
294     function tokenFromReflection(uint256 rAmount)
295         private
296         view
297         returns (uint256)
298     {
299         require(
300             rAmount <= _rTotal,
301             "Amount must be less than total reflections"
302         );
303         uint256 currentRate = _getRate();
304         return rAmount.div(currentRate);
305     }
306  
307     function removeAllFee() private {
308         if (_redisFee == 0 && _taxFee == 0) return;
309  
310         _previousredisFee = _redisFee;
311         _previoustaxFee = _taxFee;
312  
313         _redisFee = 0;
314         _taxFee = 0;
315     }
316  
317     function restoreAllFee() private {
318         _redisFee = _previousredisFee;
319         _taxFee = _previoustaxFee;
320     }
321  
322     function _approve(
323         address owner,
324         address spender,
325         uint256 amount
326     ) private {
327         require(owner != address(0), "ERC20: approve from the zero address");
328         require(spender != address(0), "ERC20: approve to the zero address");
329         _allowances[owner][spender] = amount;
330         emit Approval(owner, spender, amount);
331     }
332  
333     function _transfer(
334         address from,
335         address to,
336         uint256 amount
337     ) private {
338         require(from != address(0), "ERC20: transfer from the zero address");
339         require(to != address(0), "ERC20: transfer to the zero address");
340         require(amount > 0, "Transfer amount must be greater than zero");
341  
342         if (from != owner() && to != owner()) {
343  
344             //Trade start check
345             if (!tradingOpen) {
346                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
347             }
348  
349             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
350  
351             if(to != uniswapV2Pair) {
352                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
353             }
354  
355             uint256 contractTokenBalance = balanceOf(address(this));
356             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
357  
358             if(contractTokenBalance >= _maxTxAmount)
359             {
360                 contractTokenBalance = _maxTxAmount;
361             }
362  
363             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
364                 swapTokensForEth(contractTokenBalance);
365                 uint256 contractETHBalance = address(this).balance;
366                 if (contractETHBalance > 0) {
367                     sendETHToFee(address(this).balance);
368                 }
369             }
370         }
371  
372         bool takeFee = true;
373  
374         //Transfer Tokens
375         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
376             takeFee = false;
377         } else {
378  
379             //Set Fee for Buys
380             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
381                 _redisFee = _feeOnBuy;
382                 _taxFee = _taxOnBuy;
383             }
384  
385             //Set Fee for Sells
386             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
387                 _redisFee = _feeOnSell;
388                 _taxFee = _taxOnSell;
389             }
390  
391         }
392  
393         _tokenTransfer(from, to, amount, takeFee);
394     }
395  
396     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
397         address[] memory path = new address[](2);
398         path[0] = address(this);
399         path[1] = uniswapV2Router.WETH();
400         _approve(address(this), address(uniswapV2Router), tokenAmount);
401         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
402             tokenAmount,
403             0,
404             path,
405             address(this),
406             block.timestamp
407         );
408     }
409  
410     function sendETHToFee(uint256 amount) private {
411         _marketingWalletAddress.transfer(amount);
412     }
413  
414     function setTrading(bool _tradingOpen) public onlyOwner {
415         tradingOpen = _tradingOpen;
416     }
417  
418     function _tokenTransfer(
419         address sender,
420         address recipient,
421         uint256 amount,
422         bool takeFee
423     ) private {
424         if (!takeFee) removeAllFee();
425         _transferStandard(sender, recipient, amount);
426         if (!takeFee) restoreAllFee();
427     }
428  
429     function _transferStandard(
430         address sender,
431         address recipient,
432         uint256 tAmount
433     ) private {
434         (
435             uint256 rAmount,
436             uint256 rTransferAmount,
437             uint256 rFee,
438             uint256 tTransferAmount,
439             uint256 tFee,
440             uint256 tTeam
441         ) = _getValues(tAmount);
442         _rOwned[sender] = _rOwned[sender].sub(rAmount);
443         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
444         _takeTeam(tTeam);
445         _reflectFee(rFee, tFee);
446         emit Transfer(sender, recipient, tTransferAmount);
447     }
448  
449     function _takeTeam(uint256 tTeam) private {
450         uint256 currentRate = _getRate();
451         uint256 rTeam = tTeam.mul(currentRate);
452         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
453     }
454  
455     function _reflectFee(uint256 rFee, uint256 tFee) private {
456         _rTotal = _rTotal.sub(rFee);
457         _tFeeTotal = _tFeeTotal.add(tFee);
458     }
459  
460     receive() external payable {}
461  
462     function _getValues(uint256 tAmount)
463         private
464         view
465         returns (
466             uint256,
467             uint256,
468             uint256,
469             uint256,
470             uint256,
471             uint256
472         )
473     {
474         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
475             _getTValues(tAmount, _redisFee, _taxFee);
476         uint256 currentRate = _getRate();
477         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
478             _getRValues(tAmount, tFee, tTeam, currentRate);
479  
480         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
481     }
482  
483     function _getTValues(
484         uint256 tAmount,
485         uint256 redisFee,
486         uint256 taxFee
487     )
488         private
489         pure
490         returns (
491             uint256,
492             uint256,
493             uint256
494         )
495     {
496         uint256 tFee = tAmount.mul(redisFee).div(100);
497         uint256 tTeam = tAmount.mul(taxFee).div(100);
498         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
499  
500         return (tTransferAmount, tFee, tTeam);
501     }
502  
503     function _getRValues(
504         uint256 tAmount,
505         uint256 tFee,
506         uint256 tTeam,
507         uint256 currentRate
508     )
509         private
510         pure
511         returns (
512             uint256,
513             uint256,
514             uint256
515         )
516     {
517         uint256 rAmount = tAmount.mul(currentRate);
518         uint256 rFee = tFee.mul(currentRate);
519         uint256 rTeam = tTeam.mul(currentRate);
520         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
521  
522         return (rAmount, rTransferAmount, rFee);
523     }
524  
525     function _getRate() private view returns (uint256) {
526         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
527  
528         return rSupply.div(tSupply);
529     }
530  
531     function _getCurrentSupply() private view returns (uint256, uint256) {
532         uint256 rSupply = _rTotal;
533         uint256 tSupply = _tTotal;
534         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
535  
536         return (rSupply, tSupply);
537     }
538  
539     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
540         _feeOnBuy = redisFeeOnBuy;
541         _feeOnSell = redisFeeOnSell;
542         _taxOnBuy = taxFeeOnBuy;
543         _taxOnSell = taxFeeOnSell;
544         totalFees = _feeOnBuy + _feeOnSell + _taxOnBuy + _taxOnSell;
545         require(totalFees <= 100, "");
546     }
547  
548     //Set minimum tokens required to swap.
549     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
550         _swapTokensAtAmount = swapTokensAtAmount;
551     }
552  
553     //Set minimum tokens required to swap.
554     function toggleSwap(bool _swapEnabled) public onlyOwner {
555         swapEnabled = _swapEnabled;
556     }
557     
558     function noLimit() external onlyOwner{
559         _maxTxAmount = _tTotal;
560         _maxWalletSize = _tTotal;
561     }
562  
563     //Set max buy amount 
564     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
565         _maxTxAmount = maxTxAmount;
566     }
567 
568     //Set max wallet amount 
569     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
570         _maxWalletSize = maxWalletSize;
571     }
572 
573 }