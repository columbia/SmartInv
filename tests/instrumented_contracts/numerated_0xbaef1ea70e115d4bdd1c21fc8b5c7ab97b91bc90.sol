1 /**
2 
3 Join Pei Pei on his quest to become the most powerful memecoin in 
4 Asia and match the success of PePe, his American brother!
5 
6 Website : https://peipeicoin.com
7 Telegram: https://t.me/PeiPei_Token
8 Twitter : https://twitter.com/PeiPeiToken 
9 
10 */
11 
12 // SPDX-License-Identifier: Unlicensed
13 
14 pragma solidity 0.8.17;
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
130     external
131     returns (address pair);
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
155     external
156     payable
157     returns (
158         uint256 amountToken,
159         uint256 amountETH,
160         uint256 liquidity
161     );
162 }
163 
164 contract PeiPei is Context, IERC20, Ownable {
165 
166     using SafeMath for uint256;
167 
168     string private constant _name = unicode"佩佩";
169     string private constant _symbol = "PeiPei";
170     uint8 private constant _decimals = 9;
171 
172     mapping(address => uint256) private _rOwned;
173     mapping(address => uint256) private _tOwned;
174     mapping(address => mapping(address => uint256)) private _allowances;
175     mapping(address => bool) public _isExcludedFromFee;
176     uint256 private constant MAX = ~uint256(0);
177     uint256 private constant _tTotal = 1000000000 * 10**9;
178     uint256 private _rTotal = (MAX - (MAX % _tTotal));
179     uint256 public _tFeeTotal;
180     uint256 public _redisFeeOnBuy = 0;
181     uint256 public _taxFeeOnBuy = 3;
182     uint256 public _redisFeeOnSell = 0;
183     uint256 public _taxFeeOnSell = 8;
184 
185     uint256 public _redisFee = _redisFeeOnSell;
186     uint256 public _taxFee = _taxFeeOnSell;
187 
188     uint256 private _previousredisFee = _redisFee;
189     uint256 public _previoustaxFee = _taxFee;
190 
191     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
192     address payable private _taxAddress = payable(_msgSender());
193 
194     IUniswapV2Router02 public uniswapV2Router;
195     address public uniswapV2Pair;
196 
197     bool public tradingOpen = false;
198     bool private inSwap = false;
199     bool public swapEnabled = true;
200 
201     uint256 public _maxTxAmount = 10000000 * 10**9;
202     uint256 public _maxWalletSize = 30000000 * 10**9;
203     uint256 public _swapTokensAtAmount = 300000 * 10**9;
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
216         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
217         uniswapV2Router = _uniswapV2Router;
218         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
219         .createPair(address(this), _uniswapV2Router.WETH());
220 
221         _isExcludedFromFee[owner()] = true;
222         _isExcludedFromFee[address(this)] = true;
223         _isExcludedFromFee[_taxAddress] = true;
224 
225         emit Transfer(address(0), _msgSender(), _tTotal);
226     }
227 
228     function name() public pure returns (string memory) {
229         return _name;
230     }
231 
232     function symbol() public pure returns (string memory) {
233         return _symbol;
234     }
235 
236     function decimals() public pure returns (uint8) {
237         return _decimals;
238     }
239 
240     function totalSupply() public pure override returns (uint256) {
241         return _tTotal;
242     }
243 
244     function balanceOf(address account) public view override returns (uint256) {
245         return tokenFromReflection(_rOwned[account]);
246     }
247 
248     function transfer(address recipient, uint256 amount)
249     public
250     override
251     returns (bool)
252     {
253         _transfer(_msgSender(), recipient, amount);
254         return true;
255     }
256 
257     function allowance(address owner, address spender)
258     public
259     view
260     override
261     returns (uint256)
262     {
263         return _allowances[owner][spender];
264     }
265 
266     function approve(address spender, uint256 amount)
267     public
268     override
269     returns (bool)
270     {
271         _approve(_msgSender(), spender, amount);
272         return true;
273     }
274 
275     function transferFrom(
276         address sender,
277         address recipient,
278         uint256 amount
279     ) public override returns (bool) {
280         _transfer(sender, recipient, amount);
281         _approve(
282             sender,
283             _msgSender(),
284             _allowances[sender][_msgSender()].sub(
285                 amount,
286                 "ERC20: transfer amount exceeds allowance"
287             )
288         );
289         return true;
290     }
291 
292     function tokenFromReflection(uint256 rAmount)
293     private
294     view
295     returns (uint256)
296     {
297         require(
298             rAmount <= _rTotal,
299             "Amount must be less than total reflections"
300         );
301         uint256 currentRate = _getRate();
302         return rAmount.div(currentRate);
303     }
304 
305     function removeAllFee() public {
306         if (_redisFee == 0 && _taxFee == 0) return;
307 
308         _previousredisFee = _redisFee;
309         _previoustaxFee = _taxFee;
310 
311         _redisFee = 0;
312         _taxFee = 0;
313     }
314 
315     function restoreAllFee() public {
316         _redisFee = _previousredisFee;
317         _taxFee = _previoustaxFee;
318     }
319 
320     function _approve(
321         address owner,
322         address spender,
323         uint256 amount
324     ) private {
325         require(owner != address(0), "ERC20: approve from the zero address");
326         require(spender != address(0), "ERC20: approve to the zero address");
327         _allowances[owner][spender] = amount;
328         emit Approval(owner, spender, amount);
329     }
330 
331     function _transfer(
332         address from,
333         address to,
334         uint256 amount
335     ) private {
336         require(from != address(0), "ERC20: transfer from the zero address");
337         require(to != address(0), "ERC20: transfer to the zero address");
338         require(amount > 0, "Transfer amount must be greater than zero");
339 
340         if (from != owner() && to != owner()) {
341 
342             //Trade start check
343             if (!tradingOpen) {
344                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
345             }
346 
347             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
348             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
349 
350             if(to != uniswapV2Pair) {
351                 require(balanceOf(to) + amount <= _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
352             }
353 
354             uint256 contractTokenBalance = balanceOf(address(this));
355             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
356 
357             if(contractTokenBalance >= _maxTxAmount)
358             {
359                 contractTokenBalance = _maxTxAmount;
360             }
361 
362             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
363                 swapTokensForEth(contractTokenBalance);
364                 uint256 contractETHBalance = address(this).balance;
365                 if (contractETHBalance > 0) {
366                     sendETHToFee(address(this).balance);
367                 }
368             }
369         }
370 
371         bool takeFee = true;
372 
373         //Transfer Tokens
374         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
375             takeFee = false;
376         } else {
377 
378             //Set Fee for Buys
379             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
380                 _redisFee = _redisFeeOnBuy;
381                 _taxFee = _taxFeeOnBuy;
382             }
383 
384             //Set Fee for Sells
385             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
386                 _redisFee = _redisFeeOnSell;
387                 _taxFee = _taxFeeOnSell;
388             }
389 
390         }
391 
392         _tokenTransfer(from, to, amount, takeFee);
393     }
394 
395     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
396         address[] memory path = new address[](2);
397         path[0] = address(this);
398         path[1] = uniswapV2Router.WETH();
399         _approve(address(this), address(uniswapV2Router), tokenAmount);
400         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
401             tokenAmount,
402             0,
403             path,
404             address(this),
405             block.timestamp
406         );
407     }
408 
409     function sendETHToFee(uint256 amount) private {
410         _taxAddress.transfer(amount);
411     }
412 
413     function setTrading(bool _tradingOpen) public onlyOwner {
414         tradingOpen = _tradingOpen;
415     }
416 
417     function manualsend() external {
418         require(_msgSender() == _taxAddress);
419         uint256 contractETHBalance = address(this).balance;
420         sendETHToFee(contractETHBalance);
421     }
422 
423     function clearStuckToken(address tokenAddress, uint256 tokens) public returns (bool) {
424         require(_msgSender() == _taxAddress);
425      if(tokens == 0){
426             tokens = IERC20(tokenAddress).balanceOf(address(this));
427         }
428         return IERC20(tokenAddress).transfer(msg.sender, tokens);
429     }
430 
431     function updateTaxAddress(address payable newTaxAddress) external onlyOwner {
432         require(
433             newTaxAddress != address(0),
434             "You Cannot set Tax Wallet to zero address"
435         );
436 
437         _taxAddress = newTaxAddress;
438     }
439 
440     function blockBots(address[] memory bots_) public onlyOwner {
441         for (uint256 i = 0; i < bots_.length; i++) {
442             bots[bots_[i]] = true;
443         }
444     }
445 
446     function unblockBot(address notbot) public onlyOwner {
447         bots[notbot] = false;
448     }
449 
450     function _tokenTransfer(
451         address sender,
452         address recipient,
453         uint256 amount,
454         bool takeFee
455     ) private {
456         if (!takeFee) removeAllFee();
457         _transferStandard(sender, recipient, amount);
458         if (!takeFee) restoreAllFee();
459     }
460 
461     function _transferStandard(
462         address sender,
463         address recipient,
464         uint256 tAmount
465     ) private {
466         (
467         uint256 rAmount,
468         uint256 rTransferAmount,
469         uint256 rFee,
470         uint256 tTransferAmount,
471         uint256 tFee,
472         uint256 tTeam
473         ) = _getValues(tAmount);
474         _rOwned[sender] = _rOwned[sender].sub(rAmount);
475         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
476         _takeTeam(tTeam);
477         _reflectFee(rFee, tFee);
478         emit Transfer(sender, recipient, tTransferAmount);
479     }
480 
481     function _takeTeam(uint256 tTeam) private {
482         uint256 currentRate = _getRate();
483         uint256 rTeam = tTeam.mul(currentRate);
484         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
485     }
486 
487     function _reflectFee(uint256 rFee, uint256 tFee) private {
488         _rTotal = _rTotal.sub(rFee);
489         _tFeeTotal = _tFeeTotal.add(tFee);
490     }
491 
492     receive() external payable {}
493 
494     function _getValues(uint256 tAmount)
495     private
496     view
497     returns (
498         uint256,
499         uint256,
500         uint256,
501         uint256,
502         uint256,
503         uint256
504     )
505     {
506         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
507         _getTValues(tAmount, _redisFee, _taxFee);
508         uint256 currentRate = _getRate();
509         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
510         _getRValues(tAmount, tFee, tTeam, currentRate);
511         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
512     }
513 
514     function _getTValues(
515         uint256 tAmount,
516         uint256 redisFee,
517         uint256 taxFee
518     )
519     private
520     pure
521     returns (
522         uint256,
523         uint256,
524         uint256
525     )
526     {
527         uint256 tFee = tAmount.mul(redisFee).div(100);
528         uint256 tTeam = tAmount.mul(taxFee).div(100);
529         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
530         return (tTransferAmount, tFee, tTeam);
531     }
532 
533     function _getRValues(
534         uint256 tAmount,
535         uint256 tFee,
536         uint256 tTeam,
537         uint256 currentRate
538     )
539     private
540     pure
541     returns (
542         uint256,
543         uint256,
544         uint256
545     )
546     {
547         uint256 rAmount = tAmount.mul(currentRate);
548         uint256 rFee = tFee.mul(currentRate);
549         uint256 rTeam = tTeam.mul(currentRate);
550         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
551         return (rAmount, rTransferAmount, rFee);
552     }
553 
554     function _getRate() private view returns (uint256) {
555         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
556         return rSupply.div(tSupply);
557     }
558 
559     function _getCurrentSupply() private view returns (uint256, uint256) {
560         uint256 rSupply = _rTotal;
561         uint256 tSupply = _tTotal;
562         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
563         return (rSupply, tSupply);
564     }
565 
566     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
567         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 0, "Is 0%");
568         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 3, "The buy tax cannot exceed 3%"); // Will be modified to 2% prior to renouncing the ownership.
569         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 0, "Is 0%");
570         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 8, "The sell tax cannot exceed 8%"); // Will be modified to 2% prior to renouncing the ownership.
571 
572         _redisFeeOnBuy = redisFeeOnBuy;
573         _redisFeeOnSell = redisFeeOnSell;
574         _taxFeeOnBuy = taxFeeOnBuy;
575         _taxFeeOnSell = taxFeeOnSell;
576     }
577 
578     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
579         _swapTokensAtAmount = swapTokensAtAmount;
580     }
581 
582     function setSwapBack(bool _swapEnabled) public onlyOwner {
583         swapEnabled = _swapEnabled;
584     }
585 
586     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
587         _maxTxAmount = maxTxAmount;
588     }
589 
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