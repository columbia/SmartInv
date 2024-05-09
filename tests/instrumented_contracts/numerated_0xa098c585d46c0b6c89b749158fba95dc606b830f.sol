1 /**
2 
3 _______/\\\\\_______/\\\________/\\\_____/\\\\\\\\\_____/\\\________/\\\_        
4  _____/\\\///\\\____\/\\\_____/\\\//____/\\\\\\\\\\\\\__\///\\\____/\\\/__       
5   ___/\\\/__\///\\\__\/\\\__/\\\//______/\\\/////////\\\___\///\\\/\\\/____      
6    __/\\\______\//\\\_\/\\\\\\//\\\_____\/\\\_______\/\\\_____\///\\\/______     
7     _\/\\\_______\/\\\_\/\\\//_\//\\\____\/\\\\\\\\\\\\\\\_______\/\\\_______    
8      _\//\\\______/\\\__\/\\\____\//\\\___\/\\\/////////\\\_______\/\\\_______   
9       __\///\\\__/\\\____\/\\\_____\//\\\__\/\\\_______\/\\\_______\/\\\_______  
10        ____\///\\\\\/_____\/\\\______\//\\\_\/\\\_______\/\\\_______\/\\\_______ 
11         ______\/////_______\///________\///__\///________\///________\///________
12                                                            
13 */
14 
15 // SPDX-License-Identifier: unlicense
16 
17 pragma solidity ^0.8.7;
18  
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 }
24  
25 interface IERC20 {
26     function totalSupply() external view returns (uint256);
27  
28     function balanceOf(address account) external view returns (uint256);
29  
30     function transfer(address recipient, uint256 amount) external returns (bool);
31  
32     function allowance(address owner, address spender) external view returns (uint256);
33  
34     function approve(address spender, uint256 amount) external returns (bool);
35  
36     function transferFrom(
37         address sender,
38         address recipient,
39         uint256 amount
40     ) external returns (bool);
41  
42     event Transfer(address indexed from, address indexed to, uint256 value);
43     event Approval(
44         address indexed owner,
45         address indexed spender,
46         uint256 value
47     );
48 }
49  
50 contract Ownable is Context {
51     address private _owner;
52     address private _previousOwner;
53     event OwnershipTransferred(
54         address indexed previousOwner,
55         address indexed newOwner
56     );
57  
58     constructor() {
59         address msgSender = _msgSender();
60         _owner = msgSender;
61         emit OwnershipTransferred(address(0), msgSender);
62     }
63  
64     function owner() public view returns (address) {
65         return _owner;
66     }
67  
68     modifier onlyOwner() {
69         require(_owner == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72  
73     function renounceOwnership() public virtual onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77  
78     function transferOwnership(address newOwner) public virtual onlyOwner {
79         require(newOwner != address(0), "Ownable: new owner is the zero address");
80         emit OwnershipTransferred(_owner, newOwner);
81         _owner = newOwner;
82     }
83  
84 }
85  
86 library SafeMath {
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a, "SafeMath: addition overflow");
90         return c;
91     }
92  
93     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
94         return sub(a, b, "SafeMath: subtraction overflow");
95     }
96  
97     function sub(
98         uint256 a,
99         uint256 b,
100         string memory errorMessage
101     ) internal pure returns (uint256) {
102         require(b <= a, errorMessage);
103         uint256 c = a - b;
104         return c;
105     }
106  
107     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108         if (a == 0) {
109             return 0;
110         }
111         uint256 c = a * b;
112         require(c / a == b, "SafeMath: multiplication overflow");
113         return c;
114     }
115  
116     function div(uint256 a, uint256 b) internal pure returns (uint256) {
117         return div(a, b, "SafeMath: division by zero");
118     }
119  
120     function div(
121         uint256 a,
122         uint256 b,
123         string memory errorMessage
124     ) internal pure returns (uint256) {
125         require(b > 0, errorMessage);
126         uint256 c = a / b;
127         return c;
128     }
129 }
130  
131 interface IUniswapV2Factory {
132     function createPair(address tokenA, address tokenB)
133         external
134         returns (address pair);
135 }
136  
137 interface IUniswapV2Router02 {
138     function swapExactTokensForETHSupportingFeeOnTransferTokens(
139         uint256 amountIn,
140         uint256 amountOutMin,
141         address[] calldata path,
142         address to,
143         uint256 deadline
144     ) external;
145  
146     function factory() external pure returns (address);
147  
148     function WETH() external pure returns (address);
149  
150     function addLiquidityETH(
151         address token,
152         uint256 amountTokenDesired,
153         uint256 amountTokenMin,
154         uint256 amountETHMin,
155         address to,
156         uint256 deadline
157     )
158         external
159         payable
160         returns (
161             uint256 amountToken,
162             uint256 amountETH,
163             uint256 liquidity
164         );
165 }
166  
167 contract OkayToken is Context, IERC20, Ownable {
168  
169     using SafeMath for uint256;
170  
171     string private constant _name = "OKAY";//
172     string private constant _symbol = "OKAY";//
173     uint8 private constant _decimals = 9;
174  
175     mapping(address => uint256) private _rOwned;
176     mapping(address => uint256) private _tOwned;
177     mapping(address => mapping(address => uint256)) private _allowances;
178     mapping(address => bool) private _isExcludedFromFee;
179     uint256 private constant MAX = ~uint256(0);
180     uint256 private constant _tTotal = 1000000000000000 * 10**9;
181     uint256 private _rTotal = (MAX - (MAX % _tTotal));
182     uint256 private _tFeeTotal;
183     uint256 public launchBlock;
184  
185     //Buy Fee
186     uint256 public _redisFeeOnBuy = 2;//
187     uint256 public _taxFeeOnBuy = 10;//
188  
189     //Sell Fee
190     uint256 public _redisFeeOnSell = 2;//
191     uint256 public _taxFeeOnSell = 10;//
192  
193     //Original Fee
194     uint256 private _redisFee = _redisFeeOnSell;
195     uint256 private _taxFee = _taxFeeOnSell;
196  
197     uint256 private _previousredisFee = _redisFee;
198     uint256 private _previoustaxFee = _taxFee;
199  
200     mapping(address => bool) public bots;
201     mapping(address => uint256) private cooldown;
202  
203     address payable private _developmentAddress = payable(0x7149CcF62B988E5169EdA3ffEd77EcE6712CF150);//
204     address payable private _marketingAddress = payable(0xf678D08c67c57De2E97006fF4a2660dA06318886);//
205  
206     IUniswapV2Router02 public uniswapV2Router;
207     address public uniswapV2Pair;
208  
209     bool private tradingOpen;
210     bool private inSwap = false;
211     bool private swapEnabled = true;
212  
213     uint256 public _maxTxAmount = 10000000000000 * 10**9; //
214     uint256 public _maxWalletSize = 30000000000000 * 10**9; //
215     uint256 public _swapTokensAtAmount = 100000000000 * 10**9; //
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
235         _isExcludedFromFee[_developmentAddress] = true;
236         _isExcludedFromFee[_marketingAddress] = true;
237   
238         emit Transfer(address(0), _msgSender(), _tTotal);
239     }
240  
241     function name() public pure returns (string memory) {
242         return _name;
243     }
244  
245     function symbol() public pure returns (string memory) {
246         return _symbol;
247     }
248  
249     function decimals() public pure returns (uint8) {
250         return _decimals;
251     }
252  
253     function totalSupply() public pure override returns (uint256) {
254         return _tTotal;
255     }
256  
257     function balanceOf(address account) public view override returns (uint256) {
258         return tokenFromReflection(_rOwned[account]);
259     }
260  
261     function transfer(address recipient, uint256 amount)
262         public
263         override
264         returns (bool)
265     {
266         _transfer(_msgSender(), recipient, amount);
267         return true;
268     }
269  
270     function allowance(address owner, address spender)
271         public
272         view
273         override
274         returns (uint256)
275     {
276         return _allowances[owner][spender];
277     }
278  
279     function approve(address spender, uint256 amount)
280         public
281         override
282         returns (bool)
283     {
284         _approve(_msgSender(), spender, amount);
285         return true;
286     }
287  
288     function transferFrom(
289         address sender,
290         address recipient,
291         uint256 amount
292     ) public override returns (bool) {
293         _transfer(sender, recipient, amount);
294         _approve(
295             sender,
296             _msgSender(),
297             _allowances[sender][_msgSender()].sub(
298                 amount,
299                 "ERC20: transfer amount exceeds allowance"
300             )
301         );
302         return true;
303     }
304  
305     function tokenFromReflection(uint256 rAmount)
306         private
307         view
308         returns (uint256)
309     {
310         require(
311             rAmount <= _rTotal,
312             "Amount must be less than total reflections"
313         );
314         uint256 currentRate = _getRate();
315         return rAmount.div(currentRate);
316     }
317  
318     function removeAllFee() private {
319         if (_redisFee == 0 && _taxFee == 0) return;
320  
321         _previousredisFee = _redisFee;
322         _previoustaxFee = _taxFee;
323  
324         _redisFee = 0;
325         _taxFee = 0;
326     }
327  
328     function restoreAllFee() private {
329         _redisFee = _previousredisFee;
330         _taxFee = _previoustaxFee;
331     }
332  
333     function _approve(
334         address owner,
335         address spender,
336         uint256 amount
337     ) private {
338         require(owner != address(0), "ERC20: approve from the zero address");
339         require(spender != address(0), "ERC20: approve to the zero address");
340         _allowances[owner][spender] = amount;
341         emit Approval(owner, spender, amount);
342     }
343  
344     function _transfer(
345         address from,
346         address to,
347         uint256 amount
348     ) private {
349         require(from != address(0), "ERC20: transfer from the zero address");
350         require(to != address(0), "ERC20: transfer to the zero address");
351         require(amount > 0, "Transfer amount must be greater than zero");
352  
353         if (from != owner() && to != owner()) {
354  
355             //Trade start check
356             if (!tradingOpen) {
357                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
358             }
359  
360             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
361             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
362  
363             if(block.number <= launchBlock+2 && from == uniswapV2Pair && to != address(uniswapV2Router) && to != address(this)){   
364                 bots[to] = true;
365             } 
366  
367             if(to != uniswapV2Pair) {
368                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
369             }
370  
371             uint256 contractTokenBalance = balanceOf(address(this));
372             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
373  
374             if(contractTokenBalance >= _maxTxAmount)
375             {
376                 contractTokenBalance = _maxTxAmount;
377             }
378  
379             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
380                 swapTokensForEth(contractTokenBalance);
381                 uint256 contractETHBalance = address(this).balance;
382                 if (contractETHBalance > 0) {
383                     sendETHToFee(address(this).balance);
384                 }
385             }
386         }
387  
388         bool takeFee = true;
389  
390         //Transfer Tokens
391         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
392             takeFee = false;
393         } else {
394  
395             //Set Fee for Buys
396             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
397                 _redisFee = _redisFeeOnBuy;
398                 _taxFee = _taxFeeOnBuy;
399             }
400  
401             //Set Fee for Sells
402             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
403                 _redisFee = _redisFeeOnSell;
404                 _taxFee = _taxFeeOnSell;
405             }
406  
407         }
408  
409         _tokenTransfer(from, to, amount, takeFee);
410     }
411  
412     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
413         address[] memory path = new address[](2);
414         path[0] = address(this);
415         path[1] = uniswapV2Router.WETH();
416         _approve(address(this), address(uniswapV2Router), tokenAmount);
417         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
418             tokenAmount,
419             0,
420             path,
421             address(this),
422             block.timestamp
423         );
424     }
425  
426     function sendETHToFee(uint256 amount) private {
427         _developmentAddress.transfer(amount.div(2));
428         _marketingAddress.transfer(amount.div(2));
429     }
430  
431     function setTrading(bool _tradingOpen) public onlyOwner {
432         tradingOpen = _tradingOpen;
433         launchBlock = block.number;
434     }
435  
436     function manualswap() external {
437         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
438         uint256 contractBalance = balanceOf(address(this));
439         swapTokensForEth(contractBalance);
440     }
441  
442     function manualsend() external {
443         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
444         uint256 contractETHBalance = address(this).balance;
445         sendETHToFee(contractETHBalance);
446     }
447  
448     function blockBots(address[] memory bots_) public onlyOwner {
449         for (uint256 i = 0; i < bots_.length; i++) {
450             bots[bots_[i]] = true;
451         }
452     }
453  
454     function unblockBot(address notbot) public onlyOwner {
455         bots[notbot] = false;
456     }
457  
458     function _tokenTransfer(
459         address sender,
460         address recipient,
461         uint256 amount,
462         bool takeFee
463     ) private {
464         if (!takeFee) removeAllFee();
465         _transferStandard(sender, recipient, amount);
466         if (!takeFee) restoreAllFee();
467     }
468  
469     function _transferStandard(
470         address sender,
471         address recipient,
472         uint256 tAmount
473     ) private {
474         (
475             uint256 rAmount,
476             uint256 rTransferAmount,
477             uint256 rFee,
478             uint256 tTransferAmount,
479             uint256 tFee,
480             uint256 tTeam
481         ) = _getValues(tAmount);
482         _rOwned[sender] = _rOwned[sender].sub(rAmount);
483         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
484         _takeTeam(tTeam);
485         _reflectFee(rFee, tFee);
486         emit Transfer(sender, recipient, tTransferAmount);
487     }
488  
489     function _takeTeam(uint256 tTeam) private {
490         uint256 currentRate = _getRate();
491         uint256 rTeam = tTeam.mul(currentRate);
492         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
493     }
494  
495     function _reflectFee(uint256 rFee, uint256 tFee) private {
496         _rTotal = _rTotal.sub(rFee);
497         _tFeeTotal = _tFeeTotal.add(tFee);
498     }
499  
500     receive() external payable {}
501  
502     function _getValues(uint256 tAmount)
503         private
504         view
505         returns (
506             uint256,
507             uint256,
508             uint256,
509             uint256,
510             uint256,
511             uint256
512         )
513     {
514         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
515             _getTValues(tAmount, _redisFee, _taxFee);
516         uint256 currentRate = _getRate();
517         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
518             _getRValues(tAmount, tFee, tTeam, currentRate);
519  
520         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
521     }
522  
523     function _getTValues(
524         uint256 tAmount,
525         uint256 redisFee,
526         uint256 taxFee
527     )
528         private
529         pure
530         returns (
531             uint256,
532             uint256,
533             uint256
534         )
535     {
536         uint256 tFee = tAmount.mul(redisFee).div(100);
537         uint256 tTeam = tAmount.mul(taxFee).div(100);
538         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
539  
540         return (tTransferAmount, tFee, tTeam);
541     }
542  
543     function _getRValues(
544         uint256 tAmount,
545         uint256 tFee,
546         uint256 tTeam,
547         uint256 currentRate
548     )
549         private
550         pure
551         returns (
552             uint256,
553             uint256,
554             uint256
555         )
556     {
557         uint256 rAmount = tAmount.mul(currentRate);
558         uint256 rFee = tFee.mul(currentRate);
559         uint256 rTeam = tTeam.mul(currentRate);
560         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
561  
562         return (rAmount, rTransferAmount, rFee);
563     }
564  
565     function _getRate() private view returns (uint256) {
566         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
567  
568         return rSupply.div(tSupply);
569     }
570  
571     function _getCurrentSupply() private view returns (uint256, uint256) {
572         uint256 rSupply = _rTotal;
573         uint256 tSupply = _tTotal;
574         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
575  
576         return (rSupply, tSupply);
577     }
578  
579     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
580         _redisFeeOnBuy = redisFeeOnBuy;
581         _redisFeeOnSell = redisFeeOnSell;
582  
583         _taxFeeOnBuy = taxFeeOnBuy;
584         _taxFeeOnSell = taxFeeOnSell;
585     }
586  
587     //Set minimum tokens required to swap.
588     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
589         _swapTokensAtAmount = swapTokensAtAmount;
590     }
591  
592     //Set minimum tokens required to swap.
593     function toggleSwap(bool _swapEnabled) public onlyOwner {
594         swapEnabled = _swapEnabled;
595     }
596  
597  
598     //Set maximum transaction
599     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
600         _maxTxAmount = maxTxAmount;
601     }
602  
603     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
604         _maxWalletSize = maxWalletSize;
605     }
606  
607     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
608         for(uint256 i = 0; i < accounts.length; i++) {
609             _isExcludedFromFee[accounts[i]] = excluded;
610         }
611     }
612 }