1 /*
2 
3 In a cozy digital corner, a group of close-knit friends, all passionate about memes, stumbled upon an intriguing idea.
4 As they sat together, savoring their favorite drinks, the topic of Dogecoin, the internet-famous cryptocurrency, naturally arose. 
5 With infectious laughter, one of them proposed, "What if we create our own memecoin, something akin to Dogecoin but with its own unique charm? 
6 Let's call it D09ecoin and, just for fun, assign it a contract address starting with 0xD09e on the Ethereum network!"
7 
8 Telegram - https://t.me/d09ecoin
9 Twitter - https://twitter.com/d09ecoin
10 Web - https://d09ecoin.com
11 */
12 
13 //* SPDX-License-Identifier: Unlicensed
14 
15 pragma solidity ^0.8.9;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 }
22 
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25     function balanceOf(address account) external view returns (uint256);
26     function transfer(address recipient, uint256 amount) external returns (bool);
27     function allowance(address owner, address spender) external view returns (uint256);
28     function approve(address spender, uint256 amount) external returns (bool);
29     function transferFrom(
30         address sender,
31         address recipient,
32         uint256 amount
33     ) external returns (bool);
34 
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(
37         address indexed owner,
38         address indexed spender,
39         uint256 value
40     );
41 }
42 
43 contract Ownable is Context {
44     address private _owner;
45     address private _previousOwner;
46     event OwnershipTransferred(
47         address indexed previousOwner,
48         address indexed newOwner
49     );
50 
51     constructor() {
52         address msgSender = _msgSender();
53         _owner = msgSender;
54         emit OwnershipTransferred(address(0), msgSender);
55     }
56 
57     function owner() public view returns (address) {
58         return _owner;
59     }
60 
61     modifier onlyOwner() {
62         require(_owner == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     function renounceOwnership() public virtual onlyOwner {
67         emit OwnershipTransferred(_owner, address(0));
68         _owner = address(0);
69     }
70 
71     function transferOwnership(address newOwner) public virtual onlyOwner {
72         require(newOwner != address(0), "Ownable: new owner is the zero address");
73         emit OwnershipTransferred(_owner, newOwner);
74         _owner = newOwner;
75     }
76 
77 }
78 
79 library SafeMath {
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         uint256 c = a + b;
82         require(c >= a, "SafeMath: addition overflow");
83         return c;
84     }
85 
86     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87         return sub(a, b, "SafeMath: subtraction overflow");
88     }
89 
90     function sub(
91         uint256 a,
92         uint256 b,
93         string memory errorMessage
94     ) internal pure returns (uint256) {
95         require(b <= a, errorMessage);
96         uint256 c = a - b;
97         return c;
98     }
99 
100     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101         if (a == 0) {
102             return 0;
103         }
104         uint256 c = a * b;
105         require(c / a == b, "SafeMath: multiplication overflow");
106         return c;
107     }
108 
109     function div(uint256 a, uint256 b) internal pure returns (uint256) {
110         return div(a, b, "SafeMath: division by zero");
111     }
112 
113     function div(
114         uint256 a,
115         uint256 b,
116         string memory errorMessage
117     ) internal pure returns (uint256) {
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         return c;
121     }
122 }
123 
124 interface IUniswapV2Factory {
125     function createPair(address tokenA, address tokenB)
126         external
127         returns (address pair);
128 }
129 
130 interface IUniswapV2Router02 {
131     function swapExactTokensForETHSupportingFeeOnTransferTokens(
132         uint256 amountIn,
133         uint256 amountOutMin,
134         address[] calldata path,
135         address to,
136         uint256 deadline
137     ) external;
138 
139     function factory() external pure returns (address);
140 
141     function WETH() external pure returns (address);
142 
143     function addLiquidityETH(
144         address token,
145         uint256 amountTokenDesired,
146         uint256 amountTokenMin,
147         uint256 amountETHMin,
148         address to,
149         uint256 deadline
150     )
151         external
152         payable
153         returns (
154             uint256 amountToken,
155             uint256 amountETH,
156             uint256 liquidity
157         );
158 }
159 
160 contract DOGECOIN is Context, IERC20, Ownable {
161 
162     using SafeMath for uint256;
163 
164     string private constant _name = "D09ECOIN";
165     string private constant _symbol = "D09e";
166     uint8 private constant _decimals = 9;
167 
168     mapping(address => uint256) private _rOwned;
169     mapping(address => uint256) private _tOwned;
170     mapping(address => mapping(address => uint256)) private _allowances;
171     mapping(address => bool) private _isExcludedFromFee;
172     uint256 private constant MAX = ~uint256(0);
173     uint256 private constant _tTotal = 1000000000 * 10**9;
174     uint256 private _rTotal = (MAX - (MAX % _tTotal));
175     uint256 private _tFeeTotal;
176     uint256 private _redisFeeOnBuy = 0;
177     uint256 private _taxFeeOnBuy = 20;
178     uint256 private _redisFeeOnSell = 0;
179     uint256 private _taxFeeOnSell = 40;
180 
181     //Original Fee
182     uint256 private _redisFee = _redisFeeOnSell;
183     uint256 private _taxFee = _taxFeeOnSell;
184 
185     uint256 private _previousredisFee = _redisFee;
186     uint256 private _previoustaxFee = _taxFee;
187 
188     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
189     address payable private _developmentAddress = payable(0x5f311781a790684c4Cd55aDdf34aCC9ABDe66ed3);
190     address payable private _marketingAddress = payable(0x5f311781a790684c4Cd55aDdf34aCC9ABDe66ed3);
191 
192     IUniswapV2Router02 public uniswapV2Router;
193     address public uniswapV2Pair;
194 
195     bool private tradingOpen = false;
196     bool private inSwap = false;
197     bool private swapEnabled = true;
198 
199     uint256 public _maxTxAmount =  2 * (_tTotal/100);
200     uint256 public _maxWalletSize = 2 * (_tTotal/100);
201     uint256 public _swapTokensAtAmount = 5 *(_tTotal/1000);
202 
203     event MaxTxAmountUpdated(uint256 _maxTxAmount);
204     modifier lockTheSwap {
205         inSwap = true;
206         _;
207         inSwap = false;
208     }
209 
210     constructor() {
211 
212         _rOwned[_msgSender()] = _rTotal;
213 
214         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
215         uniswapV2Router = _uniswapV2Router;
216         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
217             .createPair(address(this), _uniswapV2Router.WETH());
218 
219         _isExcludedFromFee[owner()] = true;
220         _isExcludedFromFee[address(this)] = true;
221         _isExcludedFromFee[_developmentAddress] = true;
222         _isExcludedFromFee[_marketingAddress] = true;
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
409         _marketingAddress.transfer(amount);
410     }
411 
412     function setTrading(bool _tradingOpen) public onlyOwner {
413         tradingOpen = _tradingOpen;
414     }
415 
416     function manualswap() external {
417         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
418         uint256 contractBalance = balanceOf(address(this));
419         swapTokensForEth(contractBalance);
420     }
421 
422     function manualsend() external {
423         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
424         uint256 contractETHBalance = address(this).balance;
425         sendETHToFee(contractETHBalance);
426     }
427 
428     function blockBots(address[] memory bots_) public onlyOwner {
429         for (uint256 i = 0; i < bots_.length; i++) {
430             bots[bots_[i]] = true;
431         }
432     }
433 
434     function blockSingleBot(address thebot) public onlyOwner {
435         bots[thebot] = true;
436     }
437 
438     function unblockBot(address notbot) public onlyOwner {
439         bots[notbot] = false;
440     }
441 
442     function _tokenTransfer(
443         address sender,
444         address recipient,
445         uint256 amount,
446         bool takeFee
447     ) private {
448         if (!takeFee) removeAllFee();
449         _transferStandard(sender, recipient, amount);
450         if (!takeFee) restoreAllFee();
451     }
452 
453     function _transferStandard(
454         address sender,
455         address recipient,
456         uint256 tAmount
457     ) private {
458         (
459             uint256 rAmount,
460             uint256 rTransferAmount,
461             uint256 rFee,
462             uint256 tTransferAmount,
463             uint256 tFee,
464             uint256 tTeam
465         ) = _getValues(tAmount);
466         _rOwned[sender] = _rOwned[sender].sub(rAmount);
467         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
468         _takeTeam(tTeam);
469         _reflectFee(rFee, tFee);
470         emit Transfer(sender, recipient, tTransferAmount);
471     }
472 
473     function _takeTeam(uint256 tTeam) private {
474         uint256 currentRate = _getRate();
475         uint256 rTeam = tTeam.mul(currentRate);
476         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
477     }
478 
479     function _reflectFee(uint256 rFee, uint256 tFee) private {
480         _rTotal = _rTotal.sub(rFee);
481         _tFeeTotal = _tFeeTotal.add(tFee);
482     }
483 
484     receive() external payable {}
485 
486     function _getValues(uint256 tAmount)
487         private
488         view
489         returns (
490             uint256,
491             uint256,
492             uint256,
493             uint256,
494             uint256,
495             uint256
496         )
497     {
498         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
499             _getTValues(tAmount, _redisFee, _taxFee);
500         uint256 currentRate = _getRate();
501         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
502             _getRValues(tAmount, tFee, tTeam, currentRate);
503         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
504     }
505 
506     function _getTValues(
507         uint256 tAmount,
508         uint256 redisFee,
509         uint256 taxFee
510     )
511         private
512         pure
513         returns (
514             uint256,
515             uint256,
516             uint256
517         )
518     {
519         uint256 tFee = tAmount.mul(redisFee).div(100);
520         uint256 tTeam = tAmount.mul(taxFee).div(100);
521         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
522         return (tTransferAmount, tFee, tTeam);
523     }
524 
525     function _getRValues(
526         uint256 tAmount,
527         uint256 tFee,
528         uint256 tTeam,
529         uint256 currentRate
530     )
531         private
532         pure
533         returns (
534             uint256,
535             uint256,
536             uint256
537         )
538     {
539         uint256 rAmount = tAmount.mul(currentRate);
540         uint256 rFee = tFee.mul(currentRate);
541         uint256 rTeam = tTeam.mul(currentRate);
542         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
543         return (rAmount, rTransferAmount, rFee);
544     }
545 
546     function _getRate() private view returns (uint256) {
547         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
548         return rSupply.div(tSupply);
549     }
550 
551     function _getCurrentSupply() private view returns (uint256, uint256) {
552         uint256 rSupply = _rTotal;
553         uint256 tSupply = _tTotal;
554         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
555         return (rSupply, tSupply);
556     }
557 
558     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
559         _redisFeeOnBuy = redisFeeOnBuy;
560         _redisFeeOnSell = redisFeeOnSell;
561         _taxFeeOnBuy = taxFeeOnBuy;
562         _taxFeeOnSell = taxFeeOnSell;
563     }
564 
565     //Set minimum tokens required to swap.
566     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
567         _swapTokensAtAmount = swapTokensAtAmount;
568     }
569 
570     //Set minimum tokens required to swap.
571     function toggleSwap(bool _swapEnabled) public onlyOwner {
572         swapEnabled = _swapEnabled;
573     }
574 
575     //Set maximum transaction
576     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
577         _maxTxAmount = maxTxAmount;
578     }
579 
580     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
581         _maxWalletSize = maxWalletSize;
582     }
583 
584 }