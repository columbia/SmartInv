1 /*
2 $BILL IS GOIN TO THE MOON. BE LIKE $BILL
3 
4 Fresh Meme Meta Play on ERC20
5 
6 https://iambill.xyz/
7 
8 https://twitter.com/iambillcoin
9 
10 https://t.me/belikebillcoin
11 */
12 
13 // pragma solidity ^0.8.9; 
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 }
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23 
24     function balanceOf(address account) external view returns (uint256);
25 
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     function allowance(address owner, address spender) external view returns (uint256);
29 
30     function approve(address spender, uint256 amount) external returns (bool);
31 
32     function transferFrom(
33         address sender,
34         address recipient,
35         uint256 amount
36     ) external returns (bool);
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(
40         address indexed owner,
41         address indexed spender,
42         uint256 value
43     );
44 }
45 
46 contract Ownable is Context {
47     address private _owner;
48     address private _previousOwner;
49     event OwnershipTransferred(
50         address indexed previousOwner,
51         address indexed newOwner
52     );
53 
54     constructor() {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     function owner() public view returns (address) {
61         return _owner;
62     }
63 
64     modifier onlyOwner() {
65         require(_owner == _msgSender(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     function renounceOwnership() public virtual onlyOwner {
70         emit OwnershipTransferred(_owner, address(0));
71         _owner = address(0);
72     }
73 
74     function transferOwnership(address newOwner) public virtual onlyOwner {
75         require(newOwner != address(0), "Ownable: new owner is the zero address");
76         emit OwnershipTransferred(_owner, newOwner);
77         _owner = newOwner;
78     }
79 
80 }
81 
82 library SafeMath {
83     function add(uint256 a, uint256 b) internal pure returns (uint256) {
84         uint256 c = a + b;
85         require(c >= a, "SafeMath: addition overflow");
86         return c;
87     }
88 
89     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90         return sub(a, b, "SafeMath: subtraction overflow");
91     }
92 
93     function sub(
94         uint256 a,
95         uint256 b,
96         string memory errorMessage
97     ) internal pure returns (uint256) {
98         require(b <= a, errorMessage);
99         uint256 c = a - b;
100         return c;
101     }
102 
103     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104         if (a == 0) {
105             return 0;
106         }
107         uint256 c = a * b;
108         require(c / a == b, "SafeMath: multiplication overflow");
109         return c;
110     }
111 
112     function div(uint256 a, uint256 b) internal pure returns (uint256) {
113         return div(a, b, "SafeMath: division by zero");
114     }
115 
116     function div(
117         uint256 a,
118         uint256 b,
119         string memory errorMessage
120     ) internal pure returns (uint256) {
121         require(b > 0, errorMessage);
122         uint256 c = a / b;
123         return c;
124     }
125 }
126 
127 interface IUniswapV2Factory {
128     function createPair(address tokenA, address tokenB)
129         external
130         returns (address pair);
131 }
132 
133 interface IUniswapV2Router02 {
134     function swapExactTokensForETHSupportingFeeOnTransferTokens(
135         uint256 amountIn,
136         uint256 amountOutMin,
137         address[] calldata path,
138         address to,
139         uint256 deadline
140     ) external;
141 
142     function factory() external pure returns (address);
143 
144     function WETH() external pure returns (address);
145 
146     function addLiquidityETH(
147         address token,
148         uint256 amountTokenDesired,
149         uint256 amountTokenMin,
150         uint256 amountETHMin,
151         address to,
152         uint256 deadline
153     )
154         external
155         payable
156         returns (
157             uint256 amountToken,
158             uint256 amountETH,
159             uint256 liquidity
160         );
161 }
162 
163 contract BILL is Context, IERC20, Ownable {
164 
165     using SafeMath for uint256;
166 
167     string private constant _name = "Be Like Bill";
168     string private constant _symbol = "BILL";
169     uint8 private constant _decimals = 9;
170 
171     mapping(address => uint256) private _rOwned;
172     mapping(address => uint256) private _tOwned;
173     mapping(address => mapping(address => uint256)) private _allowances;
174     mapping(address => bool) private _isExcludedFromFee;
175     uint256 private constant MAX = ~uint256(0);
176     uint256 private constant _tTotal = 100000000000 * 10**9;
177     uint256 private _rTotal = (MAX - (MAX % _tTotal));
178     uint256 private _tFeeTotal;
179     uint256 private _redisFeeOnBuy = 0;
180     uint256 private _taxFeeOnBuy = 30;
181     uint256 private _redisFeeOnSell = 0;
182     uint256 private _taxFeeOnSell = 15;
183 
184     //Original Fee
185     uint256 private _redisFee = _redisFeeOnSell;
186     uint256 private _taxFee = _taxFeeOnSell;
187 
188     uint256 private _previousredisFee = _redisFee;
189     uint256 private _previoustaxFee = _taxFee;
190 
191     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
192     address payable private _marketingAddress = payable(0x1488524ED29Aa818f451CEDB1F62A203e98A2a96);
193 
194     IUniswapV2Router02 public uniswapV2Router;
195     address public uniswapV2Pair;
196 
197     bool private tradingOpen = true;
198     bool private inSwap = false;
199     bool private swapEnabled = true;
200 
201     uint256 public _maxTxAmount = 1000000000 * 10**9;
202     uint256 public _maxWalletSize = 2000000000 * 10**9;
203     uint256 public _swapTokensAtAmount = 100000000 * 10**9;
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
223         _isExcludedFromFee[_marketingAddress] = true;
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
249         public
250         override
251         returns (bool)
252     {
253         _transfer(_msgSender(), recipient, amount);
254         return true;
255     }
256 
257     function allowance(address owner, address spender)
258         public
259         view
260         override
261         returns (uint256)
262     {
263         return _allowances[owner][spender];
264     }
265 
266     function approve(address spender, uint256 amount)
267         public
268         override
269         returns (bool)
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
293         private
294         view
295         returns (uint256)
296     {
297         require(
298             rAmount <= _rTotal,
299             "Amount must be less than total reflections"
300         );
301         uint256 currentRate = _getRate();
302         return rAmount.div(currentRate);
303     }
304 
305     function removeAllFee() private {
306         if (_redisFee == 0 && _taxFee == 0) return;
307 
308         _previousredisFee = _redisFee;
309         _previoustaxFee = _taxFee;
310 
311         _redisFee = 0;
312         _taxFee = 0;
313     }
314 
315     function restoreAllFee() private {
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
351                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
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
380                 _taxFee = _taxFeeOnBuy;
381                 _redisFee = _redisFeeOnBuy;
382             }
383 
384             //Set Fee for Sells
385             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
386                 _taxFee = _taxFeeOnSell;
387                 _redisFee = _redisFeeOnSell;
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
410         _marketingAddress.transfer(amount);
411     }
412 
413     function setTrading(bool _tradingOpen) public onlyOwner {
414         tradingOpen = _tradingOpen;
415     }
416 
417     function manualswap() external {
418         require(_msgSender() == _marketingAddress);
419         uint256 contractBalance = balanceOf(address(this));
420         swapTokensForEth(contractBalance);
421     }
422 
423     function manualsend() external {
424         require(_msgSender() == _marketingAddress);
425         uint256 contractETHBalance = address(this).balance;
426         sendETHToFee(contractETHBalance);
427     }
428 
429     function blockBots(address[] memory bots_) public onlyOwner {
430         for (uint256 i = 0; i < bots_.length; i++) {
431             bots[bots_[i]] = true;
432         }
433     }
434 
435     function unblockBot(address notbot) public onlyOwner {
436         bots[notbot] = false;
437     }
438 
439     function _tokenTransfer(
440         address sender,
441         address recipient,
442         uint256 amount,
443         bool takeFee
444     ) private {
445         if (!takeFee) removeAllFee();
446         _transferStandard(sender, recipient, amount);
447         if (!takeFee) restoreAllFee();
448     }
449 
450     function _transferStandard(
451         address sender,
452         address recipient,
453         uint256 tAmount
454     ) private {
455         (
456             uint256 rAmount,
457             uint256 rTransferAmount,
458             uint256 rFee,
459             uint256 tTransferAmount,
460             uint256 tFee,
461             uint256 tTeam
462         ) = _getValues(tAmount);
463         _rOwned[sender] = _rOwned[sender].sub(rAmount);
464         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
465         _takeTeam(tTeam);
466         _reflectFee(rFee, tFee);
467         emit Transfer(sender, recipient, tTransferAmount);
468     }
469 
470     function _takeTeam(uint256 tTeam) private {
471         uint256 currentRate = _getRate();
472         uint256 rTeam = tTeam.mul(currentRate);
473         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
474     }
475 
476     function _reflectFee(uint256 rFee, uint256 tFee) private {
477         _rTotal = _rTotal.sub(rFee);
478         _tFeeTotal = _tFeeTotal.add(tFee);
479     }
480 
481     receive() external payable {}
482 
483     function _getValues(uint256 tAmount)
484         private
485         view
486         returns (
487             uint256,
488             uint256,
489             uint256,
490             uint256,
491             uint256,
492             uint256
493         )
494     {
495         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
496             _getTValues(tAmount, _redisFee, _taxFee);
497         uint256 currentRate = _getRate();
498         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
499             _getRValues(tAmount, tFee, tTeam, currentRate);
500         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
501     }
502 
503     function _getTValues(
504         uint256 tAmount,
505         uint256 redisFee,
506         uint256 taxFee
507     )
508         private
509         pure
510         returns (
511             uint256,
512             uint256,
513             uint256
514         )
515     {
516         uint256 tFee = tAmount.mul(redisFee).div(100);
517         uint256 tTeam = tAmount.mul(taxFee).div(100);
518         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
519         return (tTransferAmount, tFee, tTeam);
520     }
521 
522     function _getRValues(
523         uint256 tAmount,
524         uint256 tFee,
525         uint256 tTeam,
526         uint256 currentRate
527     )
528         private
529         pure
530         returns (
531             uint256,
532             uint256,
533             uint256
534         )
535     {
536         uint256 rAmount = tAmount.mul(currentRate);
537         uint256 rFee = tFee.mul(currentRate);
538         uint256 rTeam = tTeam.mul(currentRate);
539         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
540         return (rAmount, rTransferAmount, rFee);
541     }
542 
543     function _getRate() private view returns (uint256) {
544         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
545         return rSupply.div(tSupply);
546     }
547 
548     function _getCurrentSupply() private view returns (uint256, uint256) {
549         uint256 rSupply = _rTotal;
550         uint256 tSupply = _tTotal;
551         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
552         return (rSupply, tSupply);
553     }
554 
555     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
556         _redisFeeOnBuy = redisFeeOnBuy;
557         _redisFeeOnSell = redisFeeOnSell;
558         _taxFeeOnBuy = taxFeeOnBuy;
559         _taxFeeOnSell = taxFeeOnSell;
560     }
561 
562     //Set minimum tokens required to swap.
563     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
564         _swapTokensAtAmount = swapTokensAtAmount;
565     }
566 
567     //Set minimum tokens required to swap.
568     function toggleSwap(bool _swapEnabled) public onlyOwner {
569         swapEnabled = _swapEnabled;
570     }
571 
572     //Set maximum transaction
573     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
574         _maxTxAmount = maxTxAmount;
575     }
576 
577     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
578         _maxWalletSize = maxWalletSize;
579     }
580 
581 }