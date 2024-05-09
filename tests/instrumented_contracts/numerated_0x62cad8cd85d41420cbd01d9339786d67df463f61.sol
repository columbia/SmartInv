1 /**
2 	Daddy Token $DADDY
3 
4     $DADDY was created by a team of fathers in the crypto space who’ve come together 
5     to highlight the mental health issues fatherless victims deal with and to celebrate 
6     the importance of fatherhood. It is a space for women in crypto to feel comfortable 
7     to discuss mental health and feel welcomed without judgment. 
8 
9     TG: https://t.me/daddytokenentry 
10 */
11 
12 // SPDX-License-Identifier: unlicense
13 
14 pragma solidity ^0.8.7;
15  
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 }
21  
22 interface IERC20 {
23     function totalSupply() external view returns (uint256);
24  
25     function balanceOf(address account) external view returns (uint256);
26  
27     function transfer(address recipient, uint256 amount) external returns (bool);
28  
29     function allowance(address owner, address spender) external view returns (uint256);
30  
31     function approve(address spender, uint256 amount) external returns (bool);
32  
33     function transferFrom(
34         address sender,
35         address recipient,
36         uint256 amount
37     ) external returns (bool);
38  
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     event Approval(
41         address indexed owner,
42         address indexed spender,
43         uint256 value
44     );
45 }
46  
47 contract Ownable is Context {
48     address private _owner;
49     address private _previousOwner;
50     event OwnershipTransferred(
51         address indexed previousOwner,
52         address indexed newOwner
53     );
54  
55     constructor() {
56         address msgSender = _msgSender();
57         _owner = msgSender;
58         emit OwnershipTransferred(address(0), msgSender);
59     }
60  
61     function owner() public view returns (address) {
62         return _owner;
63     }
64  
65     modifier onlyOwner() {
66         require(_owner == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69  
70     function renounceOwnership() public virtual onlyOwner {
71         emit OwnershipTransferred(_owner, address(0));
72         _owner = address(0);
73     }
74  
75     function transferOwnership(address newOwner) public virtual onlyOwner {
76         require(newOwner != address(0), "Ownable: new owner is the zero address");
77         emit OwnershipTransferred(_owner, newOwner);
78         _owner = newOwner;
79     }
80  
81 }
82  
83 library SafeMath {
84     function add(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a + b;
86         require(c >= a, "SafeMath: addition overflow");
87         return c;
88     }
89  
90     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
91         return sub(a, b, "SafeMath: subtraction overflow");
92     }
93  
94     function sub(
95         uint256 a,
96         uint256 b,
97         string memory errorMessage
98     ) internal pure returns (uint256) {
99         require(b <= a, errorMessage);
100         uint256 c = a - b;
101         return c;
102     }
103  
104     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
105         if (a == 0) {
106             return 0;
107         }
108         uint256 c = a * b;
109         require(c / a == b, "SafeMath: multiplication overflow");
110         return c;
111     }
112  
113     function div(uint256 a, uint256 b) internal pure returns (uint256) {
114         return div(a, b, "SafeMath: division by zero");
115     }
116  
117     function div(
118         uint256 a,
119         uint256 b,
120         string memory errorMessage
121     ) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         return c;
125     }
126 }
127  
128 interface IUniswapV2Factory {
129     function createPair(address tokenA, address tokenB)
130         external
131         returns (address pair);
132 }
133  
134 interface IUniswapV2Router02 {
135     function swapExactTokensForETHSupportingFeeOnTransferTokens(
136         uint256 amountIn,
137         uint256 amountOutMin,
138         address[] calldata path,
139         address to,
140         uint256 deadline
141     ) external;
142  
143     function factory() external pure returns (address);
144  
145     function WETH() external pure returns (address);
146  
147     function addLiquidityETH(
148         address token,
149         uint256 amountTokenDesired,
150         uint256 amountTokenMin,
151         uint256 amountETHMin,
152         address to,
153         uint256 deadline
154     )
155         external
156         payable
157         returns (
158             uint256 amountToken,
159             uint256 amountETH,
160             uint256 liquidity
161         );
162 }
163  
164 contract DaddyToken is Context, IERC20, Ownable {
165  
166     using SafeMath for uint256;
167  
168     string private constant _name = "DADDY";//
169     string private constant _symbol = "DADDY";//
170     uint8 private constant _decimals = 9;
171  
172     mapping(address => uint256) private _rOwned;
173     mapping(address => uint256) private _tOwned;
174     mapping(address => mapping(address => uint256)) private _allowances;
175     mapping(address => bool) private _isExcludedFromFee;
176     uint256 private constant MAX = ~uint256(0);
177     uint256 private constant _tTotal = 1000000000000 * 10**9;
178     uint256 private _rTotal = (MAX - (MAX % _tTotal));
179     uint256 private _tFeeTotal;
180     uint256 public launchBlock;
181  
182     //Buy Fee
183     uint256 private _redisFeeOnBuy = 0;//
184     uint256 private _taxFeeOnBuy = 9;//
185  
186     //Sell Fee
187     uint256 private _redisFeeOnSell = 0;//
188     uint256 private _taxFeeOnSell = 21;//
189  
190     //Original Fee
191     uint256 private _redisFee = _redisFeeOnSell;
192     uint256 private _taxFee = _taxFeeOnSell;
193  
194     uint256 private _previousredisFee = _redisFee;
195     uint256 private _previoustaxFee = _taxFee;
196  
197     mapping(address => bool) public bots;
198     mapping(address => uint256) private cooldown;
199  
200     address payable private _developmentAddress = payable(0x6BCeeB693DffcEa039Ff6A8B9316ac97Aec0570A);//
201     address payable private _marketingAddress = payable(0x271226561464f6F1A8c53A660352aF90465D5601);//
202  
203     IUniswapV2Router02 public uniswapV2Router;
204     address public uniswapV2Pair;
205  
206     bool private tradingOpen;
207     bool private inSwap = false;
208     bool private swapEnabled = true;
209  
210     uint256 public _maxTxAmount = 4000000000 * 10**9; //
211     uint256 public _maxWalletSize = 10000000000 * 10**9; //
212     uint256 public _swapTokensAtAmount = 100000000 * 10**9; //
213  
214     event MaxTxAmountUpdated(uint256 _maxTxAmount);
215     modifier lockTheSwap {
216         inSwap = true;
217         _;
218         inSwap = false;
219     }
220  
221     constructor() {
222  
223         _rOwned[_msgSender()] = _rTotal;
224  
225         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
226         uniswapV2Router = _uniswapV2Router;
227         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
228             .createPair(address(this), _uniswapV2Router.WETH());
229  
230         _isExcludedFromFee[owner()] = true;
231         _isExcludedFromFee[address(this)] = true;
232         _isExcludedFromFee[_developmentAddress] = true;
233         _isExcludedFromFee[_marketingAddress] = true;
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
360             if(block.number <= launchBlock+1 && from == uniswapV2Pair && to != address(uniswapV2Router) && to != address(this)){   
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