1 /*
2 Telegram
3 https://t.me/NoName_erc
4 
5 
6 Take a look at No Name (@Noname_erc):
7  https://twitter.com/Noname_erc?t=vq-M65TpKz1Dlkbr5XiRRw&s=35
8 
9 Website
10 noname.finance
11 */
12 
13 //SPDX-License-Identifier: MIT
14 
15 pragma solidity ^0.8.12;
16 
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 }
23  
24 
25 contract Ownable is Context {
26     address private _owner;
27     address private _previousOwner;
28     event OwnershipTransferred(
29         address indexed previousOwner,
30         address indexed newOwner
31     );
32  
33     constructor() {
34         address msgSender = _msgSender();
35         _owner = msgSender;
36         emit OwnershipTransferred(address(0), msgSender);
37     }
38  
39     function owner() public view returns (address) {
40         return _owner;
41     }
42  
43     modifier onlyOwner() {
44         require(_owner == _msgSender(), "Ownable: caller is not the owner");
45         _;
46     }
47  
48     function renounceOwnership() public virtual onlyOwner {
49         emit OwnershipTransferred(_owner, address(0));
50         _owner = address(0);
51     }
52  
53     function transferOwnership(address newOwner) public virtual onlyOwner {
54         require(newOwner != address(0), "Ownable: new owner is the zero address");
55         emit OwnershipTransferred(_owner, newOwner);
56         _owner = newOwner;
57     }
58  
59 }
60 
61 
62 
63 interface IERC20 {
64     function totalSupply() external view returns (uint256);
65  
66     function balanceOf(address account) external view returns (uint256);
67  
68     function transfer(address recipient, uint256 amount) external returns (bool);
69  
70     function allowance(address owner, address spender) external view returns (uint256);
71  
72     function approve(address spender, uint256 amount) external returns (bool);
73  
74     function transferFrom(
75         address sender,
76         address recipient,
77         uint256 amount
78     ) external returns (bool);
79  
80     event Transfer(address indexed from, address indexed to, uint256 value);
81     event Approval(
82         address indexed owner,
83         address indexed spender,
84         uint256 value
85     );
86 }
87 
88 interface IUniswapV2Factory {
89     function createPair(address tokenA, address tokenB)
90         external
91         returns (address pair);
92 }
93  
94 interface IUniswapV2Router02 {
95     function swapExactTokensForETHSupportingFeeOnTransferTokens(
96         uint256 amountIn,
97         uint256 amountOutMin,
98         address[] calldata path,
99         address to,
100         uint256 deadline
101     ) external;
102  
103     function factory() external pure returns (address);
104  
105     function WETH() external pure returns (address);
106  
107     function addLiquidityETH(
108         address token,
109         uint256 amountTokenDesired,
110         uint256 amountTokenMin,
111         uint256 amountETHMin,
112         address to,
113         uint256 deadline
114     )
115         external
116         payable
117         returns (
118             uint256 amountToken,
119             uint256 amountETH,
120             uint256 liquidity
121         );
122 }
123  
124 library SafeMath {
125     function add(uint256 a, uint256 b) internal pure returns (uint256) {
126         uint256 c = a + b;
127         require(c >= a, "SafeMath: addition overflow");
128         return c;
129     }
130  
131     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132         return sub(a, b, "SafeMath: subtraction overflow");
133     }
134  
135     function sub(
136         uint256 a,
137         uint256 b,
138         string memory errorMessage
139     ) internal pure returns (uint256) {
140         require(b <= a, errorMessage);
141         uint256 c = a - b;
142         return c;
143     }
144  
145     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
146         if (a == 0) {
147             return 0;
148         }
149         uint256 c = a * b;
150         require(c / a == b, "SafeMath: multiplication overflow");
151         return c;
152     }
153  
154     function div(uint256 a, uint256 b) internal pure returns (uint256) {
155         return div(a, b, "SafeMath: division by zero");
156     }
157  
158     function div(
159         uint256 a,
160         uint256 b,
161         string memory errorMessage
162     ) internal pure returns (uint256) {
163         require(b > 0, errorMessage);
164         uint256 c = a / b;
165         return c;
166     }
167 }
168  
169 
170  
171 contract Name is Context, IERC20, Ownable {
172  
173     using SafeMath for uint256;
174  
175     string private constant _name = "No Name"; 
176     string private constant _symbol = "$NN"; 
177     uint8 private constant _decimals = 9;
178  
179     mapping(address => uint256) private _rOwned;
180     mapping(address => uint256) private _tOwned;
181     mapping(address => mapping(address => uint256)) private _allowances;
182     mapping(address => bool) private _isExcludedFromFee;
183     uint256 private constant MAX = ~uint256(0);
184 
185     uint256 private constant _tTotal = 1000000000 * 10**9; 
186     uint256 private _rTotal = (MAX - (MAX % _tTotal));
187     uint256 private _tFeeTotal;
188  
189     //Buy Fee
190     uint256 private _feeOnBuy = 0;  
191     uint256 private _taxOnBuy = 25;   
192  
193     //Sell Fee
194     uint256 private _feeOnSell = 0; 
195     uint256 private _taxOnSell = 40;  
196 
197     uint256 public totalFees;
198  
199     //Original Fee
200     uint256 private _redisFee = _feeOnSell;
201     uint256 private _taxFee = _taxOnSell;
202  
203     uint256 private _previousredisFee = _redisFee;
204     uint256 private _previoustaxFee = _taxFee;
205  
206     mapping(address => uint256) private cooldown;
207  
208     address payable private _developmentWalletAddress = payable(0x10Ee5836A2E7537082bf6774A62DB7Efadc97f56);
209     address payable private _marketingWalletAddress = payable(0x10Ee5836A2E7537082bf6774A62DB7Efadc97f56);
210  
211     IUniswapV2Router02 public uniswapV2Router;
212     address public uniswapV2Pair;
213  
214     bool private tradingOpen;
215     bool private inSwap = false;
216     bool private swapEnabled = true;
217  
218     uint256 public _maxTxAmount = 20000000 * 10**9;
219     uint256 public _maxWalletSize = 20000000 * 10**9; 
220     uint256 public _swapTokensAtAmount = 10000 * 10**9; 
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
240         _isExcludedFromFee[_developmentWalletAddress] = true;
241         _isExcludedFromFee[_marketingWalletAddress] = true;
242  
243  
244         emit Transfer(address(0), _msgSender(), _tTotal);
245     }
246  
247     function name() public pure returns (string memory) {
248         return _name;
249     }
250  
251     function symbol() public pure returns (string memory) {
252         return _symbol;
253     }
254  
255     function decimals() public pure returns (uint8) {
256         return _decimals;
257     }
258  
259     function totalSupply() public pure override returns (uint256) {
260         return _tTotal;
261     }
262  
263     function balanceOf(address account) public view override returns (uint256) {
264         return tokenFromReflection(_rOwned[account]);
265     }
266  
267     function transfer(address recipient, uint256 amount)
268         public
269         override
270         returns (bool)
271     {
272         _transfer(_msgSender(), recipient, amount);
273         return true;
274     }
275  
276     function allowance(address owner, address spender)
277         public
278         view
279         override
280         returns (uint256)
281     {
282         return _allowances[owner][spender];
283     }
284  
285     function approve(address spender, uint256 amount)
286         public
287         override
288         returns (bool)
289     {
290         _approve(_msgSender(), spender, amount);
291         return true;
292     }
293  
294     function transferFrom(
295         address sender,
296         address recipient,
297         uint256 amount
298     ) public override returns (bool) {
299         _transfer(sender, recipient, amount);
300         _approve(
301             sender,
302             _msgSender(),
303             _allowances[sender][_msgSender()].sub(
304                 amount,
305                 "ERC20: transfer amount exceeds allowance"
306             )
307         );
308         return true;
309     }
310  
311     function tokenFromReflection(uint256 rAmount)
312         private
313         view
314         returns (uint256)
315     {
316         require(
317             rAmount <= _rTotal,
318             "Amount must be less than total reflections"
319         );
320         uint256 currentRate = _getRate();
321         return rAmount.div(currentRate);
322     }
323  
324     function removeAllFee() private {
325         if (_redisFee == 0 && _taxFee == 0) return;
326  
327         _previousredisFee = _redisFee;
328         _previoustaxFee = _taxFee;
329  
330         _redisFee = 0;
331         _taxFee = 0;
332     }
333  
334     function restoreAllFee() private {
335         _redisFee = _previousredisFee;
336         _taxFee = _previoustaxFee;
337     }
338  
339     function _approve(
340         address owner,
341         address spender,
342         uint256 amount
343     ) private {
344         require(owner != address(0), "ERC20: approve from the zero address");
345         require(spender != address(0), "ERC20: approve to the zero address");
346         _allowances[owner][spender] = amount;
347         emit Approval(owner, spender, amount);
348     }
349  
350     function _transfer(
351         address from,
352         address to,
353         uint256 amount
354     ) private {
355         require(from != address(0), "ERC20: transfer from the zero address");
356         require(to != address(0), "ERC20: transfer to the zero address");
357         require(amount > 0, "Transfer amount must be greater than zero");
358  
359         if (from != owner() && to != owner()) {
360  
361             //Trade start check
362             if (!tradingOpen) {
363                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
364             }
365  
366             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
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
398                 _redisFee = _feeOnBuy;
399                 _taxFee = _taxOnBuy;
400             }
401  
402             //Set Fee for Sells
403             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
404                 _redisFee = _feeOnSell;
405                 _taxFee = _taxOnSell;
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
428         _developmentWalletAddress.transfer(amount.div(2));
429         _marketingWalletAddress.transfer(amount.div(2));
430     }
431  
432     function setTrading(bool _tradingOpen) public onlyOwner {
433         tradingOpen = _tradingOpen;
434     }
435  
436     function manualswap() external {
437         require(_msgSender() == _developmentWalletAddress || _msgSender() == _marketingWalletAddress);
438         uint256 contractBalance = balanceOf(address(this));
439         swapTokensForEth(contractBalance);
440     }
441  
442     function manualsend() external {
443         require(_msgSender() == _developmentWalletAddress || _msgSender() == _marketingWalletAddress);
444         uint256 contractETHBalance = address(this).balance;
445         sendETHToFee(contractETHBalance);
446     }
447  
448     function _tokenTransfer(
449         address sender,
450         address recipient,
451         uint256 amount,
452         bool takeFee
453     ) private {
454         if (!takeFee) removeAllFee();
455         _transferStandard(sender, recipient, amount);
456         if (!takeFee) restoreAllFee();
457     }
458  
459     function _transferStandard(
460         address sender,
461         address recipient,
462         uint256 tAmount
463     ) private {
464         (
465             uint256 rAmount,
466             uint256 rTransferAmount,
467             uint256 rFee,
468             uint256 tTransferAmount,
469             uint256 tFee,
470             uint256 tTeam
471         ) = _getValues(tAmount);
472         _rOwned[sender] = _rOwned[sender].sub(rAmount);
473         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
474         _takeTeam(tTeam);
475         _reflectFee(rFee, tFee);
476         emit Transfer(sender, recipient, tTransferAmount);
477     }
478  
479     function _takeTeam(uint256 tTeam) private {
480         uint256 currentRate = _getRate();
481         uint256 rTeam = tTeam.mul(currentRate);
482         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
483     }
484  
485     function _reflectFee(uint256 rFee, uint256 tFee) private {
486         _rTotal = _rTotal.sub(rFee);
487         _tFeeTotal = _tFeeTotal.add(tFee);
488     }
489  
490     receive() external payable {}
491  
492     function _getValues(uint256 tAmount)
493         private
494         view
495         returns (
496             uint256,
497             uint256,
498             uint256,
499             uint256,
500             uint256,
501             uint256
502         )
503     {
504         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
505             _getTValues(tAmount, _redisFee, _taxFee);
506         uint256 currentRate = _getRate();
507         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
508             _getRValues(tAmount, tFee, tTeam, currentRate);
509  
510         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
511     }
512  
513     function _getTValues(
514         uint256 tAmount,
515         uint256 redisFee,
516         uint256 taxFee
517     )
518         private
519         pure
520         returns (
521             uint256,
522             uint256,
523             uint256
524         )
525     {
526         uint256 tFee = tAmount.mul(redisFee).div(100);
527         uint256 tTeam = tAmount.mul(taxFee).div(100);
528         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
529  
530         return (tTransferAmount, tFee, tTeam);
531     }
532  
533     function _getRValues(
534         uint256 tAmount,
535         uint256 tFee,
536         uint256 tTeam,
537         uint256 currentRate
538     )
539         private
540         pure
541         returns (
542             uint256,
543             uint256,
544             uint256
545         )
546     {
547         uint256 rAmount = tAmount.mul(currentRate);
548         uint256 rFee = tFee.mul(currentRate);
549         uint256 rTeam = tTeam.mul(currentRate);
550         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
551  
552         return (rAmount, rTransferAmount, rFee);
553     }
554  
555     function _getRate() private view returns (uint256) {
556         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
557  
558         return rSupply.div(tSupply);
559     }
560  
561     function _getCurrentSupply() private view returns (uint256, uint256) {
562         uint256 rSupply = _rTotal;
563         uint256 tSupply = _tTotal;
564         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
565  
566         return (rSupply, tSupply);
567     }
568  
569     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
570         _feeOnBuy = redisFeeOnBuy;
571         _feeOnSell = redisFeeOnSell;
572         _taxOnBuy = taxFeeOnBuy;
573         _taxOnSell = taxFeeOnSell;
574         totalFees = _feeOnBuy + _feeOnSell + _taxOnBuy + _taxOnSell;
575         require(totalFees <= 100, "Must keep fees at 100% or less");
576     }
577  
578     //Set minimum tokens required to swap.
579     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
580         _swapTokensAtAmount = swapTokensAtAmount;
581     }
582  
583     //Set minimum tokens required to swap.
584     function toggleSwap(bool _swapEnabled) public onlyOwner {
585         swapEnabled = _swapEnabled;
586     }
587  
588  
589     //Set max buy amount 
590     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
591         _maxTxAmount = maxTxAmount;
592     }
593 
594     //Set max wallet amount 
595     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
596         _maxWalletSize = maxWalletSize;
597     }
598 
599     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
600         for(uint256 i = 0; i < accounts.length; i++) {
601             _isExcludedFromFee[accounts[i]] = excluded;
602         }
603     }
604 }