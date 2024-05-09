1 /*
2 
3 TG - https://t.me/Hound_erc
4 Website - http://questionhound.pro
5 
6 */
7 
8 //SPDX-License-Identifier: MIT
9 
10 pragma solidity ^0.8.12;
11 
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 }
18  
19 
20 contract Ownable is Context {
21     address private _owner;
22     address private _previousOwner;
23     event OwnershipTransferred(
24         address indexed previousOwner,
25         address indexed newOwner
26     );
27  
28     constructor() {
29         address msgSender = _msgSender();
30         _owner = msgSender;
31         emit OwnershipTransferred(address(0), msgSender);
32     }
33  
34     function owner() public view returns (address) {
35         return _owner;
36     }
37  
38     modifier onlyOwner() {
39         require(_owner == _msgSender(), "Ownable: caller is not the owner");
40         _;
41     }
42  
43     function renounceOwnership() public virtual onlyOwner {
44         emit OwnershipTransferred(_owner, address(0));
45         _owner = address(0);
46     }
47  
48     function transferOwnership(address newOwner) public virtual onlyOwner {
49         require(newOwner != address(0), "Ownable: new owner is the zero address");
50         emit OwnershipTransferred(_owner, newOwner);
51         _owner = newOwner;
52     }
53  
54 }
55 
56 
57 
58 interface IERC20 {
59     function totalSupply() external view returns (uint256);
60  
61     function balanceOf(address account) external view returns (uint256);
62  
63     function transfer(address recipient, uint256 amount) external returns (bool);
64  
65     function allowance(address owner, address spender) external view returns (uint256);
66  
67     function approve(address spender, uint256 amount) external returns (bool);
68  
69     function transferFrom(
70         address sender,
71         address recipient,
72         uint256 amount
73     ) external returns (bool);
74  
75     event Transfer(address indexed from, address indexed to, uint256 value);
76     event Approval(
77         address indexed owner,
78         address indexed spender,
79         uint256 value
80     );
81 }
82 
83 interface IUniswapV2Factory {
84     function createPair(address tokenA, address tokenB)
85         external
86         returns (address pair);
87 }
88  
89 interface IUniswapV2Router02 {
90     function swapExactTokensForETHSupportingFeeOnTransferTokens(
91         uint256 amountIn,
92         uint256 amountOutMin,
93         address[] calldata path,
94         address to,
95         uint256 deadline
96     ) external;
97  
98     function factory() external pure returns (address);
99  
100     function WETH() external pure returns (address);
101  
102     function addLiquidityETH(
103         address token,
104         uint256 amountTokenDesired,
105         uint256 amountTokenMin,
106         uint256 amountETHMin,
107         address to,
108         uint256 deadline
109     )
110         external
111         payable
112         returns (
113             uint256 amountToken,
114             uint256 amountETH,
115             uint256 liquidity
116         );
117 }
118  
119 library SafeMath {
120     function add(uint256 a, uint256 b) internal pure returns (uint256) {
121         uint256 c = a + b;
122         require(c >= a, "SafeMath: addition overflow");
123         return c;
124     }
125  
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         return sub(a, b, "SafeMath: subtraction overflow");
128     }
129  
130     function sub(
131         uint256 a,
132         uint256 b,
133         string memory errorMessage
134     ) internal pure returns (uint256) {
135         require(b <= a, errorMessage);
136         uint256 c = a - b;
137         return c;
138     }
139  
140     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
141         if (a == 0) {
142             return 0;
143         }
144         uint256 c = a * b;
145         require(c / a == b, "SafeMath: multiplication overflow");
146         return c;
147     }
148  
149     function div(uint256 a, uint256 b) internal pure returns (uint256) {
150         return div(a, b, "SafeMath: division by zero");
151     }
152  
153     function div(
154         uint256 a,
155         uint256 b,
156         string memory errorMessage
157     ) internal pure returns (uint256) {
158         require(b > 0, errorMessage);
159         uint256 c = a / b;
160         return c;
161     }
162 }
163  
164 
165  
166 contract Hound is Context, IERC20, Ownable {
167  
168     using SafeMath for uint256;
169  
170     string private constant _name = "Question Hound"; 
171     string private constant _symbol = "Hound"; 
172     uint8 private constant _decimals = 9;
173  
174     mapping(address => uint256) private _rOwned;
175     mapping(address => uint256) private _tOwned;
176     mapping(address => mapping(address => uint256)) private _allowances;
177     mapping(address => bool) private _isExcludedFromFee;
178     uint256 private constant MAX = ~uint256(0);
179 
180     uint256 private constant _tTotal = 1000000000 * 10**9; 
181     uint256 private _rTotal = (MAX - (MAX % _tTotal));
182     uint256 private _tFeeTotal;
183  
184     //Buy Fee
185     uint256 private _feeOnBuy = 0;  
186     uint256 private _taxOnBuy = 10;   
187  
188     //Sell Fee
189     uint256 private _feeOnSell = 0; 
190     uint256 private _taxOnSell = 20;  
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
203     address payable private _developmentWalletAddress = payable(0xf1C08185B466DebA72a7f60620689a8F017cCf0B);
204     address payable private _marketingWalletAddress = payable(0xf1C08185B466DebA72a7f60620689a8F017cCf0B);
205  
206     IUniswapV2Router02 public uniswapV2Router;
207     address public uniswapV2Pair;
208  
209     bool private tradingOpen;
210     bool private inSwap = false;
211     bool private swapEnabled = true;
212  
213     uint256 public _maxTxAmount = 10000000 * 10**9;
214     uint256 public _maxWalletSize = 20000000 * 10**9; 
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
228         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
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
423         _developmentWalletAddress.transfer(amount.div(2));
424         _marketingWalletAddress.transfer(amount.div(2));
425     }
426  
427     function setTrading(bool _tradingOpen) public onlyOwner {
428         tradingOpen = _tradingOpen;
429     }
430  
431     function manualswap() external {
432         require(_msgSender() == _developmentWalletAddress || _msgSender() == _marketingWalletAddress);
433         uint256 contractBalance = balanceOf(address(this));
434         swapTokensForEth(contractBalance);
435     }
436  
437     function manualsend() external {
438         require(_msgSender() == _developmentWalletAddress || _msgSender() == _marketingWalletAddress);
439         uint256 contractETHBalance = address(this).balance;
440         sendETHToFee(contractETHBalance);
441     }
442  
443     function _tokenTransfer(
444         address sender,
445         address recipient,
446         uint256 amount,
447         bool takeFee
448     ) private {
449         if (!takeFee) removeAllFee();
450         _transferStandard(sender, recipient, amount);
451         if (!takeFee) restoreAllFee();
452     }
453  
454     function _transferStandard(
455         address sender,
456         address recipient,
457         uint256 tAmount
458     ) private {
459         (
460             uint256 rAmount,
461             uint256 rTransferAmount,
462             uint256 rFee,
463             uint256 tTransferAmount,
464             uint256 tFee,
465             uint256 tTeam
466         ) = _getValues(tAmount);
467         _rOwned[sender] = _rOwned[sender].sub(rAmount);
468         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
469         _takeTeam(tTeam);
470         _reflectFee(rFee, tFee);
471         emit Transfer(sender, recipient, tTransferAmount);
472     }
473  
474     function _takeTeam(uint256 tTeam) private {
475         uint256 currentRate = _getRate();
476         uint256 rTeam = tTeam.mul(currentRate);
477         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
478     }
479  
480     function _reflectFee(uint256 rFee, uint256 tFee) private {
481         _rTotal = _rTotal.sub(rFee);
482         _tFeeTotal = _tFeeTotal.add(tFee);
483     }
484  
485     receive() external payable {}
486  
487     function _getValues(uint256 tAmount)
488         private
489         view
490         returns (
491             uint256,
492             uint256,
493             uint256,
494             uint256,
495             uint256,
496             uint256
497         )
498     {
499         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
500             _getTValues(tAmount, _redisFee, _taxFee);
501         uint256 currentRate = _getRate();
502         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
503             _getRValues(tAmount, tFee, tTeam, currentRate);
504  
505         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
506     }
507  
508     function _getTValues(
509         uint256 tAmount,
510         uint256 redisFee,
511         uint256 taxFee
512     )
513         private
514         pure
515         returns (
516             uint256,
517             uint256,
518             uint256
519         )
520     {
521         uint256 tFee = tAmount.mul(redisFee).div(100);
522         uint256 tTeam = tAmount.mul(taxFee).div(100);
523         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
524  
525         return (tTransferAmount, tFee, tTeam);
526     }
527  
528     function _getRValues(
529         uint256 tAmount,
530         uint256 tFee,
531         uint256 tTeam,
532         uint256 currentRate
533     )
534         private
535         pure
536         returns (
537             uint256,
538             uint256,
539             uint256
540         )
541     {
542         uint256 rAmount = tAmount.mul(currentRate);
543         uint256 rFee = tFee.mul(currentRate);
544         uint256 rTeam = tTeam.mul(currentRate);
545         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
546  
547         return (rAmount, rTransferAmount, rFee);
548     }
549  
550     function _getRate() private view returns (uint256) {
551         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
552  
553         return rSupply.div(tSupply);
554     }
555  
556     function _getCurrentSupply() private view returns (uint256, uint256) {
557         uint256 rSupply = _rTotal;
558         uint256 tSupply = _tTotal;
559         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
560  
561         return (rSupply, tSupply);
562     }
563  
564     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
565         _feeOnBuy = redisFeeOnBuy;
566         _feeOnSell = redisFeeOnSell;
567         _taxOnBuy = taxFeeOnBuy;
568         _taxOnSell = taxFeeOnSell;
569         totalFees = _feeOnBuy + _feeOnSell + _taxOnBuy + _taxOnSell;
570         require(totalFees <= 100, "Must keep fees at 100% or less");
571     }
572  
573     //Set minimum tokens required to swap.
574     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
575         _swapTokensAtAmount = swapTokensAtAmount;
576     }
577  
578     //Set minimum tokens required to swap.
579     function toggleSwap(bool _swapEnabled) public onlyOwner {
580         swapEnabled = _swapEnabled;
581     }
582  
583  
584     //Set max buy amount 
585     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
586         _maxTxAmount = maxTxAmount;
587     }
588 
589     //Set max wallet amount 
590     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
591         _maxWalletSize = maxWalletSize;
592     }
593 
594     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
595         for(uint256 i = 0; i < accounts.length; i++) {
596             _isExcludedFromFee[accounts[i]] = excluded;
597         }
598     }
599 }