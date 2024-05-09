1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.8.9;
3  
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 }
9  
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12  
13     function balanceOf(address account) external view returns (uint256);
14  
15     function transfer(address recipient, uint256 amount) external returns (bool);
16  
17     function allowance(address owner, address spender) external view returns (uint256);
18  
19     function approve(address spender, uint256 amount) external returns (bool);
20  
21     function transferFrom(
22         address sender,
23         address recipient,
24         uint256 amount
25     ) external returns (bool);
26  
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(
29         address indexed owner,
30         address indexed spender,
31         uint256 value
32     );
33 }
34  
35 contract Ownable is Context {
36     address private _owner;
37     address private _previousOwner;
38     event OwnershipTransferred(
39         address indexed previousOwner,
40         address indexed newOwner
41     );
42  
43     constructor() {
44         address msgSender = _msgSender();
45         _owner = msgSender;
46         emit OwnershipTransferred(address(0), msgSender);
47     }
48  
49     function owner() public view returns (address) {
50         return _owner;
51     }
52  
53     modifier onlyOwner() {
54         require(_owner == _msgSender(), "Ownable: caller is not the owner");
55         _;
56     }
57  
58     function renounceOwnership() public virtual onlyOwner {
59         emit OwnershipTransferred(_owner, address(0));
60         _owner = address(0);
61     }
62  
63     function transferOwnership(address newOwner) public virtual onlyOwner {
64         require(newOwner != address(0), "Ownable: new owner is the zero address");
65         emit OwnershipTransferred(_owner, newOwner);
66         _owner = newOwner;
67     }
68  
69 }
70  
71 library SafeMath {
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a, "SafeMath: addition overflow");
75         return c;
76     }
77  
78     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79         return sub(a, b, "SafeMath: subtraction overflow");
80     }
81  
82     function sub(
83         uint256 a,
84         uint256 b,
85         string memory errorMessage
86     ) internal pure returns (uint256) {
87         require(b <= a, errorMessage);
88         uint256 c = a - b;
89         return c;
90     }
91  
92     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93         if (a == 0) {
94             return 0;
95         }
96         uint256 c = a * b;
97         require(c / a == b, "SafeMath: multiplication overflow");
98         return c;
99     }
100  
101     function div(uint256 a, uint256 b) internal pure returns (uint256) {
102         return div(a, b, "SafeMath: division by zero");
103     }
104  
105     function div(
106         uint256 a,
107         uint256 b,
108         string memory errorMessage
109     ) internal pure returns (uint256) {
110         require(b > 0, errorMessage);
111         uint256 c = a / b;
112         return c;
113     }
114 }
115  
116 interface IUniswapV2Factory {
117     function createPair(address tokenA, address tokenB)
118         external
119         returns (address pair);
120 }
121  
122 interface IUniswapV2Router02 {
123     function swapExactTokensForETHSupportingFeeOnTransferTokens(
124         uint256 amountIn,
125         uint256 amountOutMin,
126         address[] calldata path,
127         address to,
128         uint256 deadline
129     ) external;
130  
131     function factory() external pure returns (address);
132  
133     function WETH() external pure returns (address);
134  
135     function addLiquidityETH(
136         address token,
137         uint256 amountTokenDesired,
138         uint256 amountTokenMin,
139         uint256 amountETHMin,
140         address to,
141         uint256 deadline
142     )
143         external
144         payable
145         returns (
146             uint256 amountToken,
147             uint256 amountETH,
148             uint256 liquidity
149         );
150 }
151  
152 contract RouletteBot is Context, IERC20, Ownable {
153  
154     using SafeMath for uint256;
155  
156     string private constant _name = "RouletteBot";
157     string private constant _symbol = "ROULETTEBOT";
158     uint8 private constant _decimals = 18;
159  
160     mapping(address => uint256) private _rOwned;
161     mapping(address => uint256) private _tOwned;
162     mapping(address => mapping(address => uint256)) private _allowances;
163     mapping(address => bool) private _isExcludedFromFee;
164     uint256 private constant MAX = ~uint256(0);
165     uint256 private constant _tTotal = 10000000 * 10**18;
166     uint256 private _rTotal = (MAX - (MAX % _tTotal));
167     uint256 private _tFeeTotal;
168     uint256 private _redisFeeOnBuy = 0;  
169     uint256 private _taxFeeOnBuy = 5;  
170     uint256 private _redisFeeOnSell = 0;  
171     uint256 private _taxFeeOnSell = 5;
172  
173     //Original Fee
174     uint256 private _redisFee = _redisFeeOnSell;
175     uint256 private _taxFee = _taxFeeOnSell;
176  
177     uint256 private _previousredisFee = _redisFee;
178     uint256 private _previoustaxFee = _taxFee;
179  
180     mapping(address => bool) public bots; 
181     mapping (address => uint256) public _buyMap;
182     
183     address payable private _teamAddress = payable(0x4E97880c1a971ea806a4953a3e682459fF673846); 
184     address payable private _marketingAddress = payable(0x3DbE8A35010902747d0B26aC6D414208085148BF);
185     address payable private _depositGameAddress = payable(0x6DbB5d4F1487B8c3a6352D7aC40883281BF4D5fd);
186     address payable private _withdrawGameAddress = payable(0x8E0459A4bD2D71a5213324cEF512C65A1c053D13);
187     address payable private _poolGameAddress = payable(0x79280ef11eC8EAB42357E873697b95Da59870B84);
188  
189     IUniswapV2Router02 public uniswapV2Router;
190     address public uniswapV2Pair;
191  
192     bool private tradingOpen;
193     bool private inSwap = false;
194     bool private swapEnabled = true;
195  
196     uint256 public _maxTxAmount = 100000 * 10**18; 
197     uint256 public _maxWalletSize = 100000 * 10**18; 
198     uint256 public _swapTokensAtAmount = 100 * 10**18;
199  
200     event MaxTxAmountUpdated(uint256 _maxTxAmount);
201     modifier lockTheSwap {
202         inSwap = true;
203         _;
204         inSwap = false;
205     }
206  
207     constructor() {
208  
209         _rOwned[_msgSender()] = _rTotal;
210  
211         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
212         uniswapV2Router = _uniswapV2Router;
213         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
214             .createPair(address(this), _uniswapV2Router.WETH());
215  
216         _isExcludedFromFee[owner()] = true;
217         _isExcludedFromFee[address(this)] = true;
218         _isExcludedFromFee[_teamAddress] = true;
219         _isExcludedFromFee[_marketingAddress] = true;
220         _isExcludedFromFee[_depositGameAddress] = true;
221         _isExcludedFromFee[_withdrawGameAddress] = true;
222         _isExcludedFromFee[_poolGameAddress] = true;
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
409          uint256 halfAmount = amount / 2;
410 
411         _marketingAddress.transfer(halfAmount);
412         _teamAddress.transfer(halfAmount);
413     }
414  
415     function setTrading(bool _tradingOpen) public onlyOwner {
416         tradingOpen = _tradingOpen;
417     }
418  
419     function manualswap() external {
420         require(_msgSender() == _teamAddress || _msgSender() == _marketingAddress);
421         uint256 contractBalance = balanceOf(address(this));
422         swapTokensForEth(contractBalance);
423     }
424  
425     function manualsend() external {
426         require(_msgSender() == _teamAddress || _msgSender() == _marketingAddress);
427         uint256 contractETHBalance = address(this).balance;
428         sendETHToFee(contractETHBalance);
429     }
430  
431     function blockBots(address[] memory bots_) public onlyOwner {
432         for (uint256 i = 0; i < bots_.length; i++) {
433             bots[bots_[i]] = true;
434         }
435     }
436  
437     function unblockBot(address notbot) public onlyOwner {
438         bots[notbot] = false;
439     }
440  
441     function _tokenTransfer(
442         address sender,
443         address recipient,
444         uint256 amount,
445         bool takeFee
446     ) private {
447         if (!takeFee) removeAllFee();
448         _transferStandard(sender, recipient, amount);
449         if (!takeFee) restoreAllFee();
450     }
451  
452     function _transferStandard(
453         address sender,
454         address recipient,
455         uint256 tAmount
456     ) private {
457         (
458             uint256 rAmount,
459             uint256 rTransferAmount,
460             uint256 rFee,
461             uint256 tTransferAmount,
462             uint256 tFee,
463             uint256 tTeam
464         ) = _getValues(tAmount);
465         _rOwned[sender] = _rOwned[sender].sub(rAmount);
466         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
467         _takeTeam(tTeam);
468         _reflectFee(rFee, tFee);
469         emit Transfer(sender, recipient, tTransferAmount);
470     }
471  
472     function _takeTeam(uint256 tTeam) private {
473         uint256 currentRate = _getRate();
474         uint256 rTeam = tTeam.mul(currentRate);
475         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
476     }
477  
478     function _reflectFee(uint256 rFee, uint256 tFee) private {
479         _rTotal = _rTotal.sub(rFee);
480         _tFeeTotal = _tFeeTotal.add(tFee);
481     }
482  
483     receive() external payable {}
484  
485     function _getValues(uint256 tAmount)
486         private
487         view
488         returns (
489             uint256,
490             uint256,
491             uint256,
492             uint256,
493             uint256,
494             uint256
495         )
496     {
497         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
498             _getTValues(tAmount, _redisFee, _taxFee);
499         uint256 currentRate = _getRate();
500         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
501             _getRValues(tAmount, tFee, tTeam, currentRate);
502         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
503     }
504  
505     function _getTValues(
506         uint256 tAmount,
507         uint256 redisFee,
508         uint256 taxFee
509     )
510         private
511         pure
512         returns (
513             uint256,
514             uint256,
515             uint256
516         )
517     {
518         uint256 tFee = tAmount.mul(redisFee).div(100);
519         uint256 tTeam = tAmount.mul(taxFee).div(100);
520         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
521         return (tTransferAmount, tFee, tTeam);
522     }
523  
524     function _getRValues(
525         uint256 tAmount,
526         uint256 tFee,
527         uint256 tTeam,
528         uint256 currentRate
529     )
530         private
531         pure
532         returns (
533             uint256,
534             uint256,
535             uint256
536         )
537     {
538         uint256 rAmount = tAmount.mul(currentRate);
539         uint256 rFee = tFee.mul(currentRate);
540         uint256 rTeam = tTeam.mul(currentRate);
541         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
542         return (rAmount, rTransferAmount, rFee);
543     }
544  
545     function _getRate() private view returns (uint256) {
546         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
547         return rSupply.div(tSupply);
548     }
549  
550     function _getCurrentSupply() private view returns (uint256, uint256) {
551         uint256 rSupply = _rTotal;
552         uint256 tSupply = _tTotal;
553         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
554         return (rSupply, tSupply);
555     }
556  
557     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
558         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 4, "Buy rewards must be between 0% and 4%");
559         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 98, "Buy tax must be between 0% and 98%");
560         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 4, "Sell rewards must be between 0% and 4%");
561         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 98, "Sell tax must be between 0% and 98%");
562 
563         _redisFeeOnBuy = redisFeeOnBuy;
564         _redisFeeOnSell = redisFeeOnSell;
565         _taxFeeOnBuy = taxFeeOnBuy;
566         _taxFeeOnSell = taxFeeOnSell;
567 
568     }
569  
570     //Set minimum tokens required to swap.
571     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
572         _swapTokensAtAmount = swapTokensAtAmount;
573     }
574  
575     //Set minimum tokens required to swap.
576     function toggleSwap(bool _swapEnabled) public onlyOwner {
577         swapEnabled = _swapEnabled;
578     }
579  
580     //Set maximum transaction
581     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
582            _maxTxAmount = maxTxAmount;
583         
584     }
585  
586     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
587         _maxWalletSize = maxWalletSize;
588     }
589  
590     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
591         for(uint256 i = 0; i < accounts.length; i++) {
592             _isExcludedFromFee[accounts[i]] = excluded;
593         }
594     }
595 
596 }