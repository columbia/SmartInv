1 pragma solidity ^0.8.4;
2  
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 }
8  
9 interface IERC20 {
10     function totalSupply() external view returns (uint256);
11  
12     function balanceOf(address account) external view returns (uint256);
13  
14     function transfer(address recipient, uint256 amount) external returns (bool);
15  
16     function allowance(address owner, address spender) external view returns (uint256);
17  
18     function approve(address spender, uint256 amount) external returns (bool);
19  
20     function transferFrom(
21         address sender,
22         address recipient,
23         uint256 amount
24     ) external returns (bool);
25  
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(
28         address indexed owner,
29         address indexed spender,
30         uint256 value
31     );
32 }
33  
34 contract Ownable is Context {
35     address private _owner;
36     address private _previousOwner;
37     event OwnershipTransferred(
38         address indexed previousOwner,
39         address indexed newOwner
40     );
41  
42     constructor() {
43         address msgSender = _msgSender();
44         _owner = msgSender;
45         emit OwnershipTransferred(address(0), msgSender);
46     }
47  
48     function owner() public view returns (address) {
49         return _owner;
50     }
51  
52     modifier onlyOwner() {
53         require(_owner == _msgSender(), "Ownable: caller is not the owner");
54         _;
55     }
56  
57     function renounceOwnership() public virtual onlyOwner {
58         emit OwnershipTransferred(_owner, address(0));
59         _owner = address(0);
60     }
61  
62     function transferOwnership(address newOwner) public virtual onlyOwner {
63         require(newOwner != address(0), "Ownable: new owner is the zero address");
64         emit OwnershipTransferred(_owner, newOwner);
65         _owner = newOwner;
66     }
67  
68 }
69  
70 library SafeMath {
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         require(c >= a, "SafeMath: addition overflow");
74         return c;
75     }
76  
77     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78         return sub(a, b, "SafeMath: subtraction overflow");
79     }
80  
81     function sub(
82         uint256 a,
83         uint256 b,
84         string memory errorMessage
85     ) internal pure returns (uint256) {
86         require(b <= a, errorMessage);
87         uint256 c = a - b;
88         return c;
89     }
90  
91     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
92         if (a == 0) {
93             return 0;
94         }
95         uint256 c = a * b;
96         require(c / a == b, "SafeMath: multiplication overflow");
97         return c;
98     }
99  
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103  
104     function div(
105         uint256 a,
106         uint256 b,
107         string memory errorMessage
108     ) internal pure returns (uint256) {
109         require(b > 0, errorMessage);
110         uint256 c = a / b;
111         return c;
112     }
113 }
114  
115 interface IUniswapV2Factory {
116     function createPair(address tokenA, address tokenB)
117         external
118         returns (address pair);
119 }
120  
121 interface IUniswapV2Router02 {
122     function swapExactTokensForETHSupportingFeeOnTransferTokens(
123         uint256 amountIn,
124         uint256 amountOutMin,
125         address[] calldata path,
126         address to,
127         uint256 deadline
128     ) external;
129  
130     function factory() external pure returns (address);
131  
132     function WETH() external pure returns (address);
133  
134     function addLiquidityETH(
135         address token,
136         uint256 amountTokenDesired,
137         uint256 amountTokenMin,
138         uint256 amountETHMin,
139         address to,
140         uint256 deadline
141     )
142         external
143         payable
144         returns (
145             uint256 amountToken,
146             uint256 amountETH,
147             uint256 liquidity
148         );
149 }
150  
151 contract ShibKong is Context, IERC20, Ownable {
152  
153     using SafeMath for uint256;
154  
155     string private constant _name = "ShibKong";//
156     string private constant _symbol = "SKONG";//
157     uint8 private constant _decimals = 9;
158  
159     mapping(address => uint256) private _rOwned;
160     mapping(address => uint256) private _tOwned;
161     mapping(address => mapping(address => uint256)) private _allowances;
162     mapping(address => bool) private _isExcludedFromFee;
163     uint256 private constant MAX = ~uint256(0);
164     uint256 private constant _tTotal = 1000000000000 * 10**9;
165     uint256 private _rTotal = (MAX - (MAX % _tTotal));
166     uint256 private _tFeeTotal;
167     uint256 public launchBlock;
168  
169     //Buy Fee
170     uint256 private _redisFeeOnBuy = 0;//
171     uint256 private _taxFeeOnBuy = 9;//
172  
173     //Sell Fee
174     uint256 private _redisFeeOnSell = 0;//
175     uint256 private _taxFeeOnSell = 20;//
176  
177     //Original Fee
178     uint256 private _redisFee = _redisFeeOnSell;
179     uint256 private _taxFee = _taxFeeOnSell;
180  
181     uint256 private _previousredisFee = _redisFee;
182     uint256 private _previoustaxFee = _taxFee;
183  
184     mapping(address => bool) public bots;
185     mapping(address => uint256) private cooldown;
186  
187     address payable private _developmentAddress = payable(0xe5d7Fb1bdF8047361296b0311ADF24a0f86d8E05);//
188     address payable private _marketingAddress = payable(0x865aA7Cfae1432449c5Ba941819c1D6A9c2a0439);//
189  
190     IUniswapV2Router02 public uniswapV2Router;
191     address public uniswapV2Pair;
192  
193     bool private tradingOpen;
194     bool private inSwap = false;
195     bool private swapEnabled = true;
196  
197     uint256 public _maxTxAmount = 5000000000 * 10**9; //
198     uint256 public _maxWalletSize = 10000000000 * 10**9; //
199     uint256 public _swapTokensAtAmount = 10000 * 10**9; //
200  
201     event MaxTxAmountUpdated(uint256 _maxTxAmount);
202     modifier lockTheSwap {
203         inSwap = true;
204         _;
205         inSwap = false;
206     }
207  
208     constructor() {
209  
210         _rOwned[_msgSender()] = _rTotal;
211  
212         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
213         uniswapV2Router = _uniswapV2Router;
214         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
215             .createPair(address(this), _uniswapV2Router.WETH());
216  
217         _isExcludedFromFee[owner()] = true;
218         _isExcludedFromFee[address(this)] = true;
219         _isExcludedFromFee[_developmentAddress] = true;
220         _isExcludedFromFee[_marketingAddress] = true;
221  
222         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
223         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
224         bots[address(0x34822A742BDE3beF13acabF14244869841f06A73)] = true;
225         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
226         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
227         bots[address(0x8484eFcBDa76955463aa12e1d504D7C6C89321F8)] = true;
228         bots[address(0xe5265ce4D0a3B191431e1bac056d72b2b9F0Fe44)] = true;
229         bots[address(0x33F9Da98C57674B5FC5AE7349E3C732Cf2E6Ce5C)] = true;
230         bots[address(0xc59a8E2d2c476BA9122aa4eC19B4c5E2BBAbbC28)] = true;
231         bots[address(0x21053Ff2D9Fc37D4DB8687d48bD0b57581c1333D)] = true;
232         bots[address(0x4dd6A0D3191A41522B84BC6b65d17f6f5e6a4192)] = true;
233  
234  
235         emit Transfer(address(0), _msgSender(), _tTotal);
236     }
237  
238     function name() public pure returns (string memory) {
239         return _name;
240     }
241  
242     function symbol() public pure returns (string memory) {
243         return _symbol;
244     }
245  
246     function decimals() public pure returns (uint8) {
247         return _decimals;
248     }
249  
250     function totalSupply() public pure override returns (uint256) {
251         return _tTotal;
252     }
253  
254     function balanceOf(address account) public view override returns (uint256) {
255         return tokenFromReflection(_rOwned[account]);
256     }
257  
258     function transfer(address recipient, uint256 amount)
259         public
260         override
261         returns (bool)
262     {
263         _transfer(_msgSender(), recipient, amount);
264         return true;
265     }
266  
267     function allowance(address owner, address spender)
268         public
269         view
270         override
271         returns (uint256)
272     {
273         return _allowances[owner][spender];
274     }
275  
276     function approve(address spender, uint256 amount)
277         public
278         override
279         returns (bool)
280     {
281         _approve(_msgSender(), spender, amount);
282         return true;
283     }
284  
285     function transferFrom(
286         address sender,
287         address recipient,
288         uint256 amount
289     ) public override returns (bool) {
290         _transfer(sender, recipient, amount);
291         _approve(
292             sender,
293             _msgSender(),
294             _allowances[sender][_msgSender()].sub(
295                 amount,
296                 "ERC20: transfer amount exceeds allowance"
297             )
298         );
299         return true;
300     }
301  
302     function tokenFromReflection(uint256 rAmount)
303         private
304         view
305         returns (uint256)
306     {
307         require(
308             rAmount <= _rTotal,
309             "Amount must be less than total reflections"
310         );
311         uint256 currentRate = _getRate();
312         return rAmount.div(currentRate);
313     }
314  
315     function removeAllFee() private {
316         if (_redisFee == 0 && _taxFee == 0) return;
317  
318         _previousredisFee = _redisFee;
319         _previoustaxFee = _taxFee;
320  
321         _redisFee = 0;
322         _taxFee = 0;
323     }
324  
325     function restoreAllFee() private {
326         _redisFee = _previousredisFee;
327         _taxFee = _previoustaxFee;
328     }
329  
330     function _approve(
331         address owner,
332         address spender,
333         uint256 amount
334     ) private {
335         require(owner != address(0), "ERC20: approve from the zero address");
336         require(spender != address(0), "ERC20: approve to the zero address");
337         _allowances[owner][spender] = amount;
338         emit Approval(owner, spender, amount);
339     }
340  
341     function _transfer(
342         address from,
343         address to,
344         uint256 amount
345     ) private {
346         require(from != address(0), "ERC20: transfer from the zero address");
347         require(to != address(0), "ERC20: transfer to the zero address");
348         require(amount > 0, "Transfer amount must be greater than zero");
349  
350         if (from != owner() && to != owner()) {
351  
352             //Trade start check
353             if (!tradingOpen) {
354                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
355             }
356  
357             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
358             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
359  
360             if(block.number <= launchBlock && from == uniswapV2Pair && to != address(uniswapV2Router) && to != address(this)){   
361                 bots[to] = true;
362             } 
363  
364             if(to != uniswapV2Pair) {
365                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
366             }
367  
368             uint256 contractTokenBalance = balanceOf(address(this));
369             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
370  
371             if(contractTokenBalance >= _maxTxAmount)
372             {
373                 contractTokenBalance = _maxTxAmount;
374             }
375  
376             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
377                 swapTokensForEth(contractTokenBalance);
378                 uint256 contractETHBalance = address(this).balance;
379                 if (contractETHBalance > 0) {
380                     sendETHToFee(address(this).balance);
381                 }
382             }
383         }
384  
385         bool takeFee = true;
386  
387         //Transfer Tokens
388         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
389             takeFee = false;
390         } else {
391  
392             //Set Fee for Buys
393             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
394                 _redisFee = _redisFeeOnBuy;
395                 _taxFee = _taxFeeOnBuy;
396             }
397  
398             //Set Fee for Sells
399             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
400                 _redisFee = _redisFeeOnSell;
401                 _taxFee = _taxFeeOnSell;
402             }
403  
404         }
405  
406         _tokenTransfer(from, to, amount, takeFee);
407     }
408  
409     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
410         address[] memory path = new address[](2);
411         path[0] = address(this);
412         path[1] = uniswapV2Router.WETH();
413         _approve(address(this), address(uniswapV2Router), tokenAmount);
414         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
415             tokenAmount,
416             0,
417             path,
418             address(this),
419             block.timestamp
420         );
421     }
422  
423     function sendETHToFee(uint256 amount) private {
424         _developmentAddress.transfer(amount.div(2));
425         _marketingAddress.transfer(amount.div(2));
426     }
427  
428     function setTrading(bool _tradingOpen) public onlyOwner {
429         tradingOpen = _tradingOpen;
430         launchBlock = block.number;
431     }
432  
433     function manualswap() external {
434         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
435         uint256 contractBalance = balanceOf(address(this));
436         swapTokensForEth(contractBalance);
437     }
438  
439     function manualsend() external {
440         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
441         uint256 contractETHBalance = address(this).balance;
442         sendETHToFee(contractETHBalance);
443     }
444  
445     function blockBots(address[] memory bots_) public onlyOwner {
446         for (uint256 i = 0; i < bots_.length; i++) {
447             bots[bots_[i]] = true;
448         }
449     }
450  
451     function unblockBot(address notbot) public onlyOwner {
452         bots[notbot] = false;
453     }
454  
455     function _tokenTransfer(
456         address sender,
457         address recipient,
458         uint256 amount,
459         bool takeFee
460     ) private {
461         if (!takeFee) removeAllFee();
462         _transferStandard(sender, recipient, amount);
463         if (!takeFee) restoreAllFee();
464     }
465  
466     function _transferStandard(
467         address sender,
468         address recipient,
469         uint256 tAmount
470     ) private {
471         (
472             uint256 rAmount,
473             uint256 rTransferAmount,
474             uint256 rFee,
475             uint256 tTransferAmount,
476             uint256 tFee,
477             uint256 tTeam
478         ) = _getValues(tAmount);
479         _rOwned[sender] = _rOwned[sender].sub(rAmount);
480         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
481         _takeTeam(tTeam);
482         _reflectFee(rFee, tFee);
483         emit Transfer(sender, recipient, tTransferAmount);
484     }
485  
486     function _takeTeam(uint256 tTeam) private {
487         uint256 currentRate = _getRate();
488         uint256 rTeam = tTeam.mul(currentRate);
489         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
490     }
491  
492     function _reflectFee(uint256 rFee, uint256 tFee) private {
493         _rTotal = _rTotal.sub(rFee);
494         _tFeeTotal = _tFeeTotal.add(tFee);
495     }
496  
497     receive() external payable {}
498  
499     function _getValues(uint256 tAmount)
500         private
501         view
502         returns (
503             uint256,
504             uint256,
505             uint256,
506             uint256,
507             uint256,
508             uint256
509         )
510     {
511         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
512             _getTValues(tAmount, _redisFee, _taxFee);
513         uint256 currentRate = _getRate();
514         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
515             _getRValues(tAmount, tFee, tTeam, currentRate);
516  
517         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
518     }
519  
520     function _getTValues(
521         uint256 tAmount,
522         uint256 redisFee,
523         uint256 taxFee
524     )
525         private
526         pure
527         returns (
528             uint256,
529             uint256,
530             uint256
531         )
532     {
533         uint256 tFee = tAmount.mul(redisFee).div(100);
534         uint256 tTeam = tAmount.mul(taxFee).div(100);
535         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
536  
537         return (tTransferAmount, tFee, tTeam);
538     }
539  
540     function _getRValues(
541         uint256 tAmount,
542         uint256 tFee,
543         uint256 tTeam,
544         uint256 currentRate
545     )
546         private
547         pure
548         returns (
549             uint256,
550             uint256,
551             uint256
552         )
553     {
554         uint256 rAmount = tAmount.mul(currentRate);
555         uint256 rFee = tFee.mul(currentRate);
556         uint256 rTeam = tTeam.mul(currentRate);
557         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
558  
559         return (rAmount, rTransferAmount, rFee);
560     }
561  
562     function _getRate() private view returns (uint256) {
563         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
564  
565         return rSupply.div(tSupply);
566     }
567  
568     function _getCurrentSupply() private view returns (uint256, uint256) {
569         uint256 rSupply = _rTotal;
570         uint256 tSupply = _tTotal;
571         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
572  
573         return (rSupply, tSupply);
574     }
575  
576     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
577         _redisFeeOnBuy = redisFeeOnBuy;
578         _redisFeeOnSell = redisFeeOnSell;
579  
580         _taxFeeOnBuy = taxFeeOnBuy;
581         _taxFeeOnSell = taxFeeOnSell;
582     }
583  
584     //Set minimum tokens required to swap.
585     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
586         _swapTokensAtAmount = swapTokensAtAmount;
587     }
588  
589     //Set minimum tokens required to swap.
590     function toggleSwap(bool _swapEnabled) public onlyOwner {
591         swapEnabled = _swapEnabled;
592     }
593  
594  
595     //Set maximum transaction
596     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
597         _maxTxAmount = maxTxAmount;
598     }
599  
600     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
601         _maxWalletSize = maxWalletSize;
602     }
603  
604     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
605         for(uint256 i = 0; i < accounts.length; i++) {
606             _isExcludedFromFee[accounts[i]] = excluded;
607         }
608     }
609 }