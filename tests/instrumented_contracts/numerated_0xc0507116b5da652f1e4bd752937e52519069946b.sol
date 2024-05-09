1 /**
2 https://t.me/shibariumbridgeERC
3 https://twitter.com/shibariumbridge
4 https://shibarium-bridge.gitbook.io/shibarium-bridge-erc/
5 https://medium.com/@shibariumbridge
6 shibariumbridge.org
7 
8 bridge will be live on app.shibariumbridge.org
9 **/
10 //SPDX-License-Identifier: MIT
11 
12 pragma solidity ^0.8.12;
13 
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 }
20  
21 
22 contract Ownable is Context {
23     address private _owner;
24     address private _previousOwner;
25     event OwnershipTransferred(
26         address indexed previousOwner,
27         address indexed newOwner
28     );
29  
30     constructor() {
31         address msgSender = _msgSender();
32         _owner = msgSender;
33         emit OwnershipTransferred(address(0), msgSender);
34     }
35  
36     function owner() public view returns (address) {
37         return _owner;
38     }
39  
40     modifier onlyOwner() {
41         require(_owner == _msgSender(), "Ownable: caller is not the owner");
42         _;
43     }
44  
45     function renounceOwnership() public virtual onlyOwner {
46         emit OwnershipTransferred(_owner, address(0));
47         _owner = address(0);
48     }
49  
50     function transferOwnership(address newOwner) public virtual onlyOwner {
51         require(newOwner != address(0), "Ownable: new owner is the zero address");
52         emit OwnershipTransferred(_owner, newOwner);
53         _owner = newOwner;
54     }
55  
56 }
57 
58 
59 
60 interface IERC20 {
61     function totalSupply() external view returns (uint256);
62  
63     function balanceOf(address account) external view returns (uint256);
64  
65     function transfer(address recipient, uint256 amount) external returns (bool);
66  
67     function allowance(address owner, address spender) external view returns (uint256);
68  
69     function approve(address spender, uint256 amount) external returns (bool);
70  
71     function transferFrom(
72         address sender,
73         address recipient,
74         uint256 amount
75     ) external returns (bool);
76  
77     event Transfer(address indexed from, address indexed to, uint256 value);
78     event Approval(
79         address indexed owner,
80         address indexed spender,
81         uint256 value
82     );
83 }
84 
85 interface IUniswapV2Factory {
86     function createPair(address tokenA, address tokenB)
87         external
88         returns (address pair);
89 }
90  
91 interface IUniswapV2Router02 {
92     function swapExactTokensForETHSupportingFeeOnTransferTokens(
93         uint256 amountIn,
94         uint256 amountOutMin,
95         address[] calldata path,
96         address to,
97         uint256 deadline
98     ) external;
99  
100     function factory() external pure returns (address);
101  
102     function WETH() external pure returns (address);
103  
104     function addLiquidityETH(
105         address token,
106         uint256 amountTokenDesired,
107         uint256 amountTokenMin,
108         uint256 amountETHMin,
109         address to,
110         uint256 deadline
111     )
112         external
113         payable
114         returns (
115             uint256 amountToken,
116             uint256 amountETH,
117             uint256 liquidity
118         );
119 }
120  
121 library SafeMath {
122     function add(uint256 a, uint256 b) internal pure returns (uint256) {
123         uint256 c = a + b;
124         require(c >= a, "SafeMath: addition overflow");
125         return c;
126     }
127  
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         return sub(a, b, "SafeMath: subtraction overflow");
130     }
131  
132     function sub(
133         uint256 a,
134         uint256 b,
135         string memory errorMessage
136     ) internal pure returns (uint256) {
137         require(b <= a, errorMessage);
138         uint256 c = a - b;
139         return c;
140     }
141  
142     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
143         if (a == 0) {
144             return 0;
145         }
146         uint256 c = a * b;
147         require(c / a == b, "SafeMath: multiplication overflow");
148         return c;
149     }
150  
151     function div(uint256 a, uint256 b) internal pure returns (uint256) {
152         return div(a, b, "SafeMath: division by zero");
153     }
154  
155     function div(
156         uint256 a,
157         uint256 b,
158         string memory errorMessage
159     ) internal pure returns (uint256) {
160         require(b > 0, errorMessage);
161         uint256 c = a / b;
162         return c;
163     }
164 }
165  
166 
167  
168 contract shibariumbridge is Context, IERC20, Ownable {
169  
170     using SafeMath for uint256;
171  
172     string private constant _name = "Shibarium Bridge"; 
173     string private constant _symbol = "SHIBRG"; 
174     uint8 private constant _decimals = 9;
175  
176     mapping(address => uint256) private _rOwned;
177     mapping(address => uint256) private _tOwned;
178     mapping(address => mapping(address => uint256)) private _allowances;
179     mapping(address => bool) private _isExcludedFromFee;
180     uint256 private constant MAX = ~uint256(0);
181 
182     uint256 private constant _tTotal = 1000000000 * 10**9; 
183     uint256 private _rTotal = (MAX - (MAX % _tTotal));
184     uint256 private _tFeeTotal;
185  
186     //Buy Fee
187     uint256 private _feeOnBuy = 0;  
188     uint256 private _taxOnBuy = 50;   
189  
190     //Sell Fee
191     uint256 private _feeOnSell = 0; 
192     uint256 private _taxOnSell = 50;  
193 
194     uint256 public totalFees;
195  
196     //Original Fee
197     uint256 private _redisFee = _feeOnSell;
198     uint256 private _taxFee = _taxOnSell;
199  
200     uint256 private _previousredisFee = _redisFee;
201     uint256 private _previoustaxFee = _taxFee;
202  
203     mapping(address => uint256) private cooldown;
204  
205     address payable private _developmentWalletAddress = payable(0xA7D04ad3BA39DaCc9658d8b07e6013741fB56193);
206     address payable private _marketingWalletAddress = payable(0xA7D04ad3BA39DaCc9658d8b07e6013741fB56193);
207  
208     IUniswapV2Router02 public uniswapV2Router;
209     address public uniswapV2Pair;
210  
211     bool private tradingOpen;
212     bool private inSwap = false;
213     bool private swapEnabled = true;
214  
215     uint256 public _maxTxAmount = 40000000 * 10**9;
216     uint256 public _maxWalletSize = 40000000 * 10**9; 
217     uint256 public _swapTokensAtAmount = 10000 * 10**9; 
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
230         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
231         uniswapV2Router = _uniswapV2Router;
232         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
233             .createPair(address(this), _uniswapV2Router.WETH());
234  
235         _isExcludedFromFee[owner()] = true;
236         _isExcludedFromFee[address(this)] = true;
237         _isExcludedFromFee[_developmentWalletAddress] = true;
238         _isExcludedFromFee[_marketingWalletAddress] = true;
239  
240  
241         emit Transfer(address(0), _msgSender(), _tTotal);
242     }
243  
244     function name() public pure returns (string memory) {
245         return _name;
246     }
247  
248     function symbol() public pure returns (string memory) {
249         return _symbol;
250     }
251  
252     function decimals() public pure returns (uint8) {
253         return _decimals;
254     }
255  
256     function totalSupply() public pure override returns (uint256) {
257         return _tTotal;
258     }
259  
260     function balanceOf(address account) public view override returns (uint256) {
261         return tokenFromReflection(_rOwned[account]);
262     }
263  
264     function transfer(address recipient, uint256 amount)
265         public
266         override
267         returns (bool)
268     {
269         _transfer(_msgSender(), recipient, amount);
270         return true;
271     }
272  
273     function allowance(address owner, address spender)
274         public
275         view
276         override
277         returns (uint256)
278     {
279         return _allowances[owner][spender];
280     }
281  
282     function approve(address spender, uint256 amount)
283         public
284         override
285         returns (bool)
286     {
287         _approve(_msgSender(), spender, amount);
288         return true;
289     }
290  
291     function transferFrom(
292         address sender,
293         address recipient,
294         uint256 amount
295     ) public override returns (bool) {
296         _transfer(sender, recipient, amount);
297         _approve(
298             sender,
299             _msgSender(),
300             _allowances[sender][_msgSender()].sub(
301                 amount,
302                 "ERC20: transfer amount exceeds allowance"
303             )
304         );
305         return true;
306     }
307  
308     function tokenFromReflection(uint256 rAmount)
309         private
310         view
311         returns (uint256)
312     {
313         require(
314             rAmount <= _rTotal,
315             "Amount must be less than total reflections"
316         );
317         uint256 currentRate = _getRate();
318         return rAmount.div(currentRate);
319     }
320  
321     function removeAllFee() private {
322         if (_redisFee == 0 && _taxFee == 0) return;
323  
324         _previousredisFee = _redisFee;
325         _previoustaxFee = _taxFee;
326  
327         _redisFee = 0;
328         _taxFee = 0;
329     }
330  
331     function restoreAllFee() private {
332         _redisFee = _previousredisFee;
333         _taxFee = _previoustaxFee;
334     }
335  
336     function _approve(
337         address owner,
338         address spender,
339         uint256 amount
340     ) private {
341         require(owner != address(0), "ERC20: approve from the zero address");
342         require(spender != address(0), "ERC20: approve to the zero address");
343         _allowances[owner][spender] = amount;
344         emit Approval(owner, spender, amount);
345     }
346  
347     function _transfer(
348         address from,
349         address to,
350         uint256 amount
351     ) private {
352         require(from != address(0), "ERC20: transfer from the zero address");
353         require(to != address(0), "ERC20: transfer to the zero address");
354         require(amount > 0, "Transfer amount must be greater than zero");
355  
356         if (from != owner() && to != owner()) {
357  
358             //Trade start check
359             if (!tradingOpen) {
360                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
361             }
362  
363             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
364  
365             if(to != uniswapV2Pair) {
366                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
367             }
368  
369             uint256 contractTokenBalance = balanceOf(address(this));
370             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
371  
372             if(contractTokenBalance >= _maxTxAmount)
373             {
374                 contractTokenBalance = _maxTxAmount;
375             }
376  
377             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
378                 swapTokensForEth(contractTokenBalance);
379                 uint256 contractETHBalance = address(this).balance;
380                 if (contractETHBalance > 0) {
381                     sendETHToFee(address(this).balance);
382                 }
383             }
384         }
385  
386         bool takeFee = true;
387  
388         //Transfer Tokens
389         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
390             takeFee = false;
391         } else {
392  
393             //Set Fee for Buys
394             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
395                 _redisFee = _feeOnBuy;
396                 _taxFee = _taxOnBuy;
397             }
398  
399             //Set Fee for Sells
400             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
401                 _redisFee = _feeOnSell;
402                 _taxFee = _taxOnSell;
403             }
404  
405         }
406  
407         _tokenTransfer(from, to, amount, takeFee);
408     }
409  
410     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
411         address[] memory path = new address[](2);
412         path[0] = address(this);
413         path[1] = uniswapV2Router.WETH();
414         _approve(address(this), address(uniswapV2Router), tokenAmount);
415         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
416             tokenAmount,
417             0,
418             path,
419             address(this),
420             block.timestamp
421         );
422     }
423  
424     function sendETHToFee(uint256 amount) private {
425         _developmentWalletAddress.transfer(amount.div(2));
426         _marketingWalletAddress.transfer(amount.div(2));
427     }
428  
429     function setTrading(bool _tradingOpen) public onlyOwner {
430         tradingOpen = _tradingOpen;
431     }
432  
433     function manualswap() external {
434         require(_msgSender() == _developmentWalletAddress || _msgSender() == _marketingWalletAddress);
435         uint256 contractBalance = balanceOf(address(this));
436         swapTokensForEth(contractBalance);
437     }
438  
439     function manualsend() external {
440         require(_msgSender() == _developmentWalletAddress || _msgSender() == _marketingWalletAddress);
441         uint256 contractETHBalance = address(this).balance;
442         sendETHToFee(contractETHBalance);
443     }
444  
445     function _tokenTransfer(
446         address sender,
447         address recipient,
448         uint256 amount,
449         bool takeFee
450     ) private {
451         if (!takeFee) removeAllFee();
452         _transferStandard(sender, recipient, amount);
453         if (!takeFee) restoreAllFee();
454     }
455  
456     function _transferStandard(
457         address sender,
458         address recipient,
459         uint256 tAmount
460     ) private {
461         (
462             uint256 rAmount,
463             uint256 rTransferAmount,
464             uint256 rFee,
465             uint256 tTransferAmount,
466             uint256 tFee,
467             uint256 tTeam
468         ) = _getValues(tAmount);
469         _rOwned[sender] = _rOwned[sender].sub(rAmount);
470         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
471         _takeTeam(tTeam);
472         _reflectFee(rFee, tFee);
473         emit Transfer(sender, recipient, tTransferAmount);
474     }
475  
476     function _takeTeam(uint256 tTeam) private {
477         uint256 currentRate = _getRate();
478         uint256 rTeam = tTeam.mul(currentRate);
479         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
480     }
481  
482     function _reflectFee(uint256 rFee, uint256 tFee) private {
483         _rTotal = _rTotal.sub(rFee);
484         _tFeeTotal = _tFeeTotal.add(tFee);
485     }
486  
487     receive() external payable {}
488  
489     function _getValues(uint256 tAmount)
490         private
491         view
492         returns (
493             uint256,
494             uint256,
495             uint256,
496             uint256,
497             uint256,
498             uint256
499         )
500     {
501         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
502             _getTValues(tAmount, _redisFee, _taxFee);
503         uint256 currentRate = _getRate();
504         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
505             _getRValues(tAmount, tFee, tTeam, currentRate);
506  
507         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
508     }
509  
510     function _getTValues(
511         uint256 tAmount,
512         uint256 redisFee,
513         uint256 taxFee
514     )
515         private
516         pure
517         returns (
518             uint256,
519             uint256,
520             uint256
521         )
522     {
523         uint256 tFee = tAmount.mul(redisFee).div(100);
524         uint256 tTeam = tAmount.mul(taxFee).div(100);
525         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
526  
527         return (tTransferAmount, tFee, tTeam);
528     }
529  
530     function _getRValues(
531         uint256 tAmount,
532         uint256 tFee,
533         uint256 tTeam,
534         uint256 currentRate
535     )
536         private
537         pure
538         returns (
539             uint256,
540             uint256,
541             uint256
542         )
543     {
544         uint256 rAmount = tAmount.mul(currentRate);
545         uint256 rFee = tFee.mul(currentRate);
546         uint256 rTeam = tTeam.mul(currentRate);
547         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
548  
549         return (rAmount, rTransferAmount, rFee);
550     }
551  
552     function _getRate() private view returns (uint256) {
553         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
554  
555         return rSupply.div(tSupply);
556     }
557  
558     function _getCurrentSupply() private view returns (uint256, uint256) {
559         uint256 rSupply = _rTotal;
560         uint256 tSupply = _tTotal;
561         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
562  
563         return (rSupply, tSupply);
564     }
565  
566     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
567         _feeOnBuy = redisFeeOnBuy;
568         _feeOnSell = redisFeeOnSell;
569         _taxOnBuy = taxFeeOnBuy;
570         _taxOnSell = taxFeeOnSell;
571         totalFees = _feeOnBuy + _feeOnSell + _taxOnBuy + _taxOnSell;
572         require(totalFees <= 100, "Must keep fees at 100% or less");
573     }
574  
575     //Set minimum tokens required to swap.
576     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
577         _swapTokensAtAmount = swapTokensAtAmount;
578     }
579  
580     //Set minimum tokens required to swap.
581     function toggleSwap(bool _swapEnabled) public onlyOwner {
582         swapEnabled = _swapEnabled;
583     }
584  
585  
586     //Set max buy amount 
587     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
588         _maxTxAmount = maxTxAmount;
589     }
590 
591     //Set max wallet amount 
592     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
593         _maxWalletSize = maxWalletSize;
594     }
595 
596     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
597         for(uint256 i = 0; i < accounts.length; i++) {
598             _isExcludedFromFee[accounts[i]] = excluded;
599         }
600     }
601 }