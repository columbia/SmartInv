1 /**
2 https://kombatinuverse.io
3 https://t.me/kombatinuverse
4 https://twitter.com/kombatinuverse
5 */
6 
7 pragma solidity ^0.8.4;
8  
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 }
14  
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17  
18     function balanceOf(address account) external view returns (uint256);
19  
20     function transfer(address recipient, uint256 amount) external returns (bool);
21  
22     function allowance(address owner, address spender) external view returns (uint256);
23  
24     function approve(address spender, uint256 amount) external returns (bool);
25  
26     function transferFrom(
27         address sender,
28         address recipient,
29         uint256 amount
30     ) external returns (bool);
31  
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(
34         address indexed owner,
35         address indexed spender,
36         uint256 value
37     );
38 }
39  
40 contract Ownable is Context {
41     address private _owner;
42     address private _previousOwner;
43     event OwnershipTransferred(
44         address indexed previousOwner,
45         address indexed newOwner
46     );
47  
48     constructor() {
49         address msgSender = _msgSender();
50         _owner = msgSender;
51         emit OwnershipTransferred(address(0), msgSender);
52     }
53  
54     function owner() public view returns (address) {
55         return _owner;
56     }
57  
58     modifier onlyOwner() {
59         require(_owner == _msgSender(), "Ownable: caller is not the owner");
60         _;
61     }
62  
63     function renounceOwnership() public virtual onlyOwner {
64         emit OwnershipTransferred(_owner, address(0));
65         _owner = address(0);
66     }
67  
68     function transferOwnership(address newOwner) public virtual onlyOwner {
69         require(newOwner != address(0), "Ownable: new owner is the zero address");
70         emit OwnershipTransferred(_owner, newOwner);
71         _owner = newOwner;
72     }
73  
74 }
75  
76 library SafeMath {
77     function add(uint256 a, uint256 b) internal pure returns (uint256) {
78         uint256 c = a + b;
79         require(c >= a, "SafeMath: addition overflow");
80         return c;
81     }
82  
83     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84         return sub(a, b, "SafeMath: subtraction overflow");
85     }
86  
87     function sub(
88         uint256 a,
89         uint256 b,
90         string memory errorMessage
91     ) internal pure returns (uint256) {
92         require(b <= a, errorMessage);
93         uint256 c = a - b;
94         return c;
95     }
96  
97     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98         if (a == 0) {
99             return 0;
100         }
101         uint256 c = a * b;
102         require(c / a == b, "SafeMath: multiplication overflow");
103         return c;
104     }
105  
106     function div(uint256 a, uint256 b) internal pure returns (uint256) {
107         return div(a, b, "SafeMath: division by zero");
108     }
109  
110     function div(
111         uint256 a,
112         uint256 b,
113         string memory errorMessage
114     ) internal pure returns (uint256) {
115         require(b > 0, errorMessage);
116         uint256 c = a / b;
117         return c;
118     }
119 }
120  
121 interface IUniswapV2Factory {
122     function createPair(address tokenA, address tokenB)
123         external
124         returns (address pair);
125 }
126  
127 interface IUniswapV2Router02 {
128     function swapExactTokensForETHSupportingFeeOnTransferTokens(
129         uint256 amountIn,
130         uint256 amountOutMin,
131         address[] calldata path,
132         address to,
133         uint256 deadline
134     ) external;
135  
136     function factory() external pure returns (address);
137  
138     function WETH() external pure returns (address);
139  
140     function addLiquidityETH(
141         address token,
142         uint256 amountTokenDesired,
143         uint256 amountTokenMin,
144         uint256 amountETHMin,
145         address to,
146         uint256 deadline
147     )
148         external
149         payable
150         returns (
151             uint256 amountToken,
152             uint256 amountETH,
153             uint256 liquidity
154         );
155 }
156  
157 contract Kinuverse is Context, IERC20, Ownable {
158  
159     using SafeMath for uint256;
160  
161     string private constant _name = "Kinuverse";//
162     string private constant _symbol = "KINU";//
163     uint8 private constant _decimals = 9;
164  
165     mapping(address => uint256) private _rOwned;
166     mapping(address => uint256) private _tOwned;
167     mapping(address => mapping(address => uint256)) private _allowances;
168     mapping(address => bool) private _isExcludedFromFee;
169     uint256 private constant MAX = ~uint256(0);
170     uint256 private constant _tTotal = 10000000 * 10**9;
171     uint256 private _rTotal = (MAX - (MAX % _tTotal));
172     uint256 private _tFeeTotal;
173     uint256 public launchBlock;
174  
175     //Buy Fee
176     uint256 private _redisFeeOnBuy = 0;//
177     uint256 private _taxFeeOnBuy = 13;//
178  
179     //Sell Fee
180     uint256 private _redisFeeOnSell = 0;//
181     uint256 private _taxFeeOnSell = 17;//
182  
183     //Original Fee
184     uint256 private _redisFee = _redisFeeOnSell;
185     uint256 private _taxFee = _taxFeeOnSell;
186  
187     uint256 private _previousredisFee = _redisFee;
188     uint256 private _previoustaxFee = _taxFee;
189  
190     mapping(address => bool) public bots;
191     mapping(address => uint256) private cooldown;
192  
193     address payable private _developmentAddress = payable(0x19Bde2D28F54A7D65Dd7CA9515a42880577411C1);//
194     address payable private _marketingAddress = payable(0x55D81CE2e13C729014f43943Ae59DFf4DB28cce6);//
195  
196     IUniswapV2Router02 public uniswapV2Router;
197     address public uniswapV2Pair;
198  
199     bool private tradingOpen;
200     bool private inSwap = false;
201     bool private swapEnabled = true;
202  
203     uint256 public _maxTxAmount = 30000 * 10**9; //
204     uint256 public _maxWalletSize = 60000 * 10**9; //
205     uint256 public _swapTokensAtAmount = 10000 * 10**9; //
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
228         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
229         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
230         bots[address(0x34822A742BDE3beF13acabF14244869841f06A73)] = true;
231         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
232         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
233         bots[address(0x8484eFcBDa76955463aa12e1d504D7C6C89321F8)] = true;
234         bots[address(0xe5265ce4D0a3B191431e1bac056d72b2b9F0Fe44)] = true;
235         bots[address(0x33F9Da98C57674B5FC5AE7349E3C732Cf2E6Ce5C)] = true;
236         bots[address(0xc59a8E2d2c476BA9122aa4eC19B4c5E2BBAbbC28)] = true;
237         bots[address(0x21053Ff2D9Fc37D4DB8687d48bD0b57581c1333D)] = true;
238         bots[address(0x4dd6A0D3191A41522B84BC6b65d17f6f5e6a4192)] = true;
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
364             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
365  
366             if(block.number <= launchBlock && from == uniswapV2Pair && to != address(uniswapV2Router) && to != address(this)){   
367                 bots[to] = true;
368             } 
369  
370             if(to != uniswapV2Pair) {
371                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
372             }
373  
374             uint256 contractTokenBalance = balanceOf(address(this));
375             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
376  
377             if(contractTokenBalance >= _maxTxAmount)
378             {
379                 contractTokenBalance = _maxTxAmount;
380             }
381  
382             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
383                 swapTokensForEth(contractTokenBalance);
384                 uint256 contractETHBalance = address(this).balance;
385                 if (contractETHBalance > 0) {
386                     sendETHToFee(address(this).balance);
387                 }
388             }
389         }
390  
391         bool takeFee = true;
392  
393         //Transfer Tokens
394         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
395             takeFee = false;
396         } else {
397  
398             //Set Fee for Buys
399             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
400                 _redisFee = _redisFeeOnBuy;
401                 _taxFee = _taxFeeOnBuy;
402             }
403  
404             //Set Fee for Sells
405             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
406                 _redisFee = _redisFeeOnSell;
407                 _taxFee = _taxFeeOnSell;
408             }
409  
410         }
411  
412         _tokenTransfer(from, to, amount, takeFee);
413     }
414  
415     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
416         address[] memory path = new address[](2);
417         path[0] = address(this);
418         path[1] = uniswapV2Router.WETH();
419         _approve(address(this), address(uniswapV2Router), tokenAmount);
420         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
421             tokenAmount,
422             0,
423             path,
424             address(this),
425             block.timestamp
426         );
427     }
428  
429     function sendETHToFee(uint256 amount) private {
430         _developmentAddress.transfer(amount.div(2));
431         _marketingAddress.transfer(amount.div(2));
432     }
433  
434     function setTrading(bool _tradingOpen) public onlyOwner {
435         tradingOpen = _tradingOpen;
436         launchBlock = block.number;
437     }
438  
439     function manualswap() external {
440         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
441         uint256 contractBalance = balanceOf(address(this));
442         swapTokensForEth(contractBalance);
443     }
444  
445     function manualsend() external {
446         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
447         uint256 contractETHBalance = address(this).balance;
448         sendETHToFee(contractETHBalance);
449     }
450  
451     function blockBots(address[] memory bots_) public onlyOwner {
452         for (uint256 i = 0; i < bots_.length; i++) {
453             bots[bots_[i]] = true;
454         }
455     }
456  
457     function unblockBot(address notbot) public onlyOwner {
458         bots[notbot] = false;
459     }
460  
461     function _tokenTransfer(
462         address sender,
463         address recipient,
464         uint256 amount,
465         bool takeFee
466     ) private {
467         if (!takeFee) removeAllFee();
468         _transferStandard(sender, recipient, amount);
469         if (!takeFee) restoreAllFee();
470     }
471  
472     function _transferStandard(
473         address sender,
474         address recipient,
475         uint256 tAmount
476     ) private {
477         (
478             uint256 rAmount,
479             uint256 rTransferAmount,
480             uint256 rFee,
481             uint256 tTransferAmount,
482             uint256 tFee,
483             uint256 tTeam
484         ) = _getValues(tAmount);
485         _rOwned[sender] = _rOwned[sender].sub(rAmount);
486         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
487         _takeTeam(tTeam);
488         _reflectFee(rFee, tFee);
489         emit Transfer(sender, recipient, tTransferAmount);
490     }
491  
492     function _takeTeam(uint256 tTeam) private {
493         uint256 currentRate = _getRate();
494         uint256 rTeam = tTeam.mul(currentRate);
495         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
496     }
497  
498     function _reflectFee(uint256 rFee, uint256 tFee) private {
499         _rTotal = _rTotal.sub(rFee);
500         _tFeeTotal = _tFeeTotal.add(tFee);
501     }
502  
503     receive() external payable {}
504  
505     function _getValues(uint256 tAmount)
506         private
507         view
508         returns (
509             uint256,
510             uint256,
511             uint256,
512             uint256,
513             uint256,
514             uint256
515         )
516     {
517         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
518             _getTValues(tAmount, _redisFee, _taxFee);
519         uint256 currentRate = _getRate();
520         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
521             _getRValues(tAmount, tFee, tTeam, currentRate);
522  
523         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
524     }
525  
526     function _getTValues(
527         uint256 tAmount,
528         uint256 redisFee,
529         uint256 taxFee
530     )
531         private
532         pure
533         returns (
534             uint256,
535             uint256,
536             uint256
537         )
538     {
539         uint256 tFee = tAmount.mul(redisFee).div(100);
540         uint256 tTeam = tAmount.mul(taxFee).div(100);
541         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
542  
543         return (tTransferAmount, tFee, tTeam);
544     }
545  
546     function _getRValues(
547         uint256 tAmount,
548         uint256 tFee,
549         uint256 tTeam,
550         uint256 currentRate
551     )
552         private
553         pure
554         returns (
555             uint256,
556             uint256,
557             uint256
558         )
559     {
560         uint256 rAmount = tAmount.mul(currentRate);
561         uint256 rFee = tFee.mul(currentRate);
562         uint256 rTeam = tTeam.mul(currentRate);
563         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
564  
565         return (rAmount, rTransferAmount, rFee);
566     }
567  
568     function _getRate() private view returns (uint256) {
569         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
570  
571         return rSupply.div(tSupply);
572     }
573  
574     function _getCurrentSupply() private view returns (uint256, uint256) {
575         uint256 rSupply = _rTotal;
576         uint256 tSupply = _tTotal;
577         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
578  
579         return (rSupply, tSupply);
580     }
581  
582     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
583         _redisFeeOnBuy = redisFeeOnBuy;
584         _redisFeeOnSell = redisFeeOnSell;
585  
586         _taxFeeOnBuy = taxFeeOnBuy;
587         _taxFeeOnSell = taxFeeOnSell;
588     }
589  
590     //Set minimum tokens required to swap.
591     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
592         _swapTokensAtAmount = swapTokensAtAmount;
593     }
594  
595     //Set minimum tokens required to swap.
596     function toggleSwap(bool _swapEnabled) public onlyOwner {
597         swapEnabled = _swapEnabled;
598     }
599  
600  
601     //Set maximum transaction
602     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
603         _maxTxAmount = maxTxAmount;
604     }
605  
606     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
607         _maxWalletSize = maxWalletSize;
608     }
609  
610     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
611         for(uint256 i = 0; i < accounts.length; i++) {
612             _isExcludedFromFee[accounts[i]] = excluded;
613         }
614     }
615 }