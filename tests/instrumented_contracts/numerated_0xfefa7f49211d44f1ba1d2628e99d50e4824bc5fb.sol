1 //Satsuki Inu
2 
3 //Official Links:
4 
5 //Telegram:
6 //https://t.me/SatsukiInu
7 
8 //Website: 
9 //https://www.SatsukiInu.com
10 
11 //*/
12 
13 // SPDX-License-Identifier: Unlicensed
14 
15 pragma solidity ^0.8.4;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 }
22 
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25 
26     function balanceOf(address account) external view returns (uint256);
27 
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     function allowance(address owner, address spender) external view returns (uint256);
31 
32     function approve(address spender, uint256 amount) external returns (bool);
33 
34     function transferFrom(
35         address sender,
36         address recipient,
37         uint256 amount
38     ) external returns (bool);
39 
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     event Approval(
42         address indexed owner,
43         address indexed spender,
44         uint256 value
45     );
46 }
47 
48 contract Ownable is Context {
49     address private _owner;
50     address private _previousOwner;
51     event OwnershipTransferred(
52         address indexed previousOwner,
53         address indexed newOwner
54     );
55 
56     constructor() {
57         address msgSender = _msgSender();
58         _owner = msgSender;
59         emit OwnershipTransferred(address(0), msgSender);
60     }
61 
62     function owner() public view returns (address) {
63         return _owner;
64     }
65 
66     modifier onlyOwner() {
67         require(_owner == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     function renounceOwnership() public virtual onlyOwner {
72         emit OwnershipTransferred(_owner, address(0));
73         _owner = address(0);
74     }
75 }
76 
77 library SafeMath {
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a, "SafeMath: addition overflow");
81         return c;
82     }
83 
84     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85         return sub(a, b, "SafeMath: subtraction overflow");
86     }
87 
88     function sub(
89         uint256 a,
90         uint256 b,
91         string memory errorMessage
92     ) internal pure returns (uint256) {
93         require(b <= a, errorMessage);
94         uint256 c = a - b;
95         return c;
96     }
97 
98     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99         if (a == 0) {
100             return 0;
101         }
102         uint256 c = a * b;
103         require(c / a == b, "SafeMath: multiplication overflow");
104         return c;
105     }
106 
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         return div(a, b, "SafeMath: division by zero");
109     }
110 
111     function div(
112         uint256 a,
113         uint256 b,
114         string memory errorMessage
115     ) internal pure returns (uint256) {
116         require(b > 0, errorMessage);
117         uint256 c = a / b;
118         return c;
119     }
120 }
121 
122 interface IUniswapV2Factory {
123     function createPair(address tokenA, address tokenB)
124         external
125         returns (address pair);
126 }
127 
128 interface IUniswapV2Router02 {
129     function swapExactTokensForETHSupportingFeeOnTransferTokens(
130         uint256 amountIn,
131         uint256 amountOutMin,
132         address[] calldata path,
133         address to,
134         uint256 deadline
135     ) external;
136 
137     function factory() external pure returns (address);
138 
139     function WETH() external pure returns (address);
140 
141     function addLiquidityETH(
142         address token,
143         uint256 amountTokenDesired,
144         uint256 amountTokenMin,
145         uint256 amountETHMin,
146         address to,
147         uint256 deadline
148     )
149         external
150         payable
151         returns (
152             uint256 amountToken,
153             uint256 amountETH,
154             uint256 liquidity
155         );
156 }
157 
158 contract SatsukiInu is Context, IERC20, Ownable {
159     
160     using SafeMath for uint256;
161 
162     string private constant _name = "Satsuki Inu";
163     string private constant _symbol = "SINU";
164     uint8 private constant _decimals = 9;
165 
166     mapping(address => uint256) private _rOwned;
167     mapping(address => uint256) private _tOwned;
168     mapping(address => mapping(address => uint256)) private _allowances;
169     mapping(address => bool) private _isExcludedFromFee;
170     uint256 private constant MAX = ~uint256(0);
171     uint256 private constant _tTotal = 100000000000000 * 10**9;
172     uint256 private _rTotal = (MAX - (MAX % _tTotal));
173     uint256 private _tFeeTotal;
174     
175     //Buy Fee
176     uint256 private _redisFeeOnBuy = 2;
177     uint256 private _taxFeeOnBuy = 9;
178     
179     //Sell Fee
180     uint256 private _redisFeeOnSell = 2;
181     uint256 private _taxFeeOnSell = 9;
182     
183     //Original Fee
184     uint256 private _redisFee = _redisFeeOnSell;
185     uint256 private _taxFee = _taxFeeOnSell;
186     
187     uint256 private _previousredisFee = _redisFee;
188     uint256 private _previoustaxFee = _taxFee;
189     
190     mapping(address => bool) public bots;
191     mapping (address => bool) public preTrader;
192     mapping(address => uint256) private cooldown;
193     
194     address payable private _marketingAddress = payable(0x8Cd78d24ca80B4F4D8030A6AF47D68bf751c143E);
195     
196     IUniswapV2Router02 public uniswapV2Router;
197     address public uniswapV2Pair;
198     
199     bool private tradingOpen;
200     bool private inSwap = false;
201     bool private swapEnabled = true;
202     
203     uint256 public _maxTxAmount = 500000000000 * 10**9; //0.5% of total supply per txn
204     uint256 public _maxWalletSize = 1500000000000 * 10**9; //1.25% of total supply
205     uint256 public _swapTokensAtAmount = 10000000000 * 10**9; //0.1% 
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
218         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
219         uniswapV2Router = _uniswapV2Router;
220         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
221             .createPair(address(this), _uniswapV2Router.WETH());
222 
223         _isExcludedFromFee[owner()] = true;
224         _isExcludedFromFee[address(this)] = true;
225         _isExcludedFromFee[_marketingAddress] = true;
226         
227         preTrader[owner()] = true;
228         
229         bots[address(0x00000000000000000000000000000000001)] = true;
230         
231 
232         emit Transfer(address(0), _msgSender(), _tTotal);
233     }
234 
235     function name() public pure returns (string memory) {
236         return _name;
237     }
238 
239     function symbol() public pure returns (string memory) {
240         return _symbol;
241     }
242 
243     function decimals() public pure returns (uint8) {
244         return _decimals;
245     }
246 
247     function totalSupply() public pure override returns (uint256) {
248         return _tTotal;
249     }
250 
251     function balanceOf(address account) public view override returns (uint256) {
252         return tokenFromReflection(_rOwned[account]);
253     }
254 
255     function transfer(address recipient, uint256 amount)
256         public
257         override
258         returns (bool)
259     {
260         _transfer(_msgSender(), recipient, amount);
261         return true;
262     }
263 
264     function allowance(address owner, address spender)
265         public
266         view
267         override
268         returns (uint256)
269     {
270         return _allowances[owner][spender];
271     }
272 
273     function approve(address spender, uint256 amount)
274         public
275         override
276         returns (bool)
277     {
278         _approve(_msgSender(), spender, amount);
279         return true;
280     }
281 
282     function transferFrom(
283         address sender,
284         address recipient,
285         uint256 amount
286     ) public override returns (bool) {
287         _transfer(sender, recipient, amount);
288         _approve(
289             sender,
290             _msgSender(),
291             _allowances[sender][_msgSender()].sub(
292                 amount,
293                 "ERC20: transfer amount exceeds allowance"
294             )
295         );
296         return true;
297     }
298 
299     function tokenFromReflection(uint256 rAmount)
300         private
301         view
302         returns (uint256)
303     {
304         require(
305             rAmount <= _rTotal,
306             "Amount must be less than total reflections"
307         );
308         uint256 currentRate = _getRate();
309         return rAmount.div(currentRate);
310     }
311 
312     function removeAllFee() private {
313         if (_redisFee == 0 && _taxFee == 0) return;
314     
315         _previousredisFee = _redisFee;
316         _previoustaxFee = _taxFee;
317         
318         _redisFee = 0;
319         _taxFee = 0;
320     }
321 
322     function restoreAllFee() private {
323         _redisFee = _previousredisFee;
324         _taxFee = _previoustaxFee;
325     }
326 
327     function _approve(
328         address owner,
329         address spender,
330         uint256 amount
331     ) private {
332         require(owner != address(0), "ERC20: approve from the zero address");
333         require(spender != address(0), "ERC20: approve to the zero address");
334         _allowances[owner][spender] = amount;
335         emit Approval(owner, spender, amount);
336     }
337 
338     function _transfer(
339         address from,
340         address to,
341         uint256 amount
342     ) private {
343         require(from != address(0), "ERC20: transfer from the zero address");
344         require(to != address(0), "ERC20: transfer to the zero address");
345         require(amount > 0, "Transfer amount must be greater than zero");
346 
347         if (from != owner() && to != owner()) {
348             
349             //Trade start check
350             if (!tradingOpen) {
351                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
352             }
353               
354             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
355             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
356             
357             if(to != uniswapV2Pair) {
358                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
359             }
360             
361             uint256 contractTokenBalance = balanceOf(address(this));
362             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
363 
364             if(contractTokenBalance >= _maxTxAmount)
365             {
366                 contractTokenBalance = _maxTxAmount;
367             }
368             
369             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled) {
370                 swapTokensForEth(contractTokenBalance);
371                 uint256 contractETHBalance = address(this).balance;
372                 if (contractETHBalance > 0) {
373                     sendETHToFee(address(this).balance);
374                 }
375             }
376         }
377         
378         bool takeFee = true;
379 
380         //Transfer Tokens
381         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
382             takeFee = false;
383         } else {
384             
385             //Set Fee for Buys
386             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
387                 _redisFee = _redisFeeOnBuy;
388                 _taxFee = _taxFeeOnBuy;
389             }
390     
391             //Set Fee for Sells
392             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
393                 _redisFee = _redisFeeOnSell;
394                 _taxFee = _taxFeeOnSell;
395             }
396             
397         }
398 
399         _tokenTransfer(from, to, amount, takeFee);
400     }
401 
402     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
403         address[] memory path = new address[](2);
404         path[0] = address(this);
405         path[1] = uniswapV2Router.WETH();
406         _approve(address(this), address(uniswapV2Router), tokenAmount);
407         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
408             tokenAmount,
409             0,
410             path,
411             address(this),
412             block.timestamp
413         );
414     }
415 
416     function sendETHToFee(uint256 amount) private {
417         _marketingAddress.transfer(amount);
418     }
419 
420     function setTrading(bool _tradingOpen) public onlyOwner {
421         tradingOpen = _tradingOpen;
422     }
423 
424     function manualswap() external {
425         require(_msgSender() == _marketingAddress);
426         uint256 contractBalance = balanceOf(address(this));
427         swapTokensForEth(contractBalance);
428     }
429 
430     function manualsend() external {
431         require(_msgSender() == _marketingAddress);
432         uint256 contractETHBalance = address(this).balance;
433         sendETHToFee(contractETHBalance);
434     }
435 
436     function blockBots(address[] memory bots_) public onlyOwner {
437         for (uint256 i = 0; i < bots_.length; i++) {
438             bots[bots_[i]] = true;
439         }
440     }
441 
442     function unblockBot(address notbot) public onlyOwner {
443         bots[notbot] = false;
444     }
445 
446     function _tokenTransfer(
447         address sender,
448         address recipient,
449         uint256 amount,
450         bool takeFee
451     ) private {
452         if (!takeFee) removeAllFee();
453         _transferStandard(sender, recipient, amount);
454         if (!takeFee) restoreAllFee();
455     }
456 
457     function _transferStandard(
458         address sender,
459         address recipient,
460         uint256 tAmount
461     ) private {
462         (
463             uint256 rAmount,
464             uint256 rTransferAmount,
465             uint256 rFee,
466             uint256 tTransferAmount,
467             uint256 tFee,
468             uint256 tTeam
469         ) = _getValues(tAmount);
470         _rOwned[sender] = _rOwned[sender].sub(rAmount);
471         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
472         _takeTeam(tTeam);
473         _reflectFee(rFee, tFee);
474         emit Transfer(sender, recipient, tTransferAmount);
475     }
476 
477     function _takeTeam(uint256 tTeam) private {
478         uint256 currentRate = _getRate();
479         uint256 rTeam = tTeam.mul(currentRate);
480         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
481     }
482 
483     function _reflectFee(uint256 rFee, uint256 tFee) private {
484         _rTotal = _rTotal.sub(rFee);
485         _tFeeTotal = _tFeeTotal.add(tFee);
486     }
487 
488     receive() external payable {}
489 
490     function _getValues(uint256 tAmount)
491         private
492         view
493         returns (
494             uint256,
495             uint256,
496             uint256,
497             uint256,
498             uint256,
499             uint256
500         )
501     {
502         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
503             _getTValues(tAmount, _redisFee, _taxFee);
504         uint256 currentRate = _getRate();
505         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
506             _getRValues(tAmount, tFee, tTeam, currentRate);
507         
508         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
509     }
510 
511     function _getTValues(
512         uint256 tAmount,
513         uint256 redisFee,
514         uint256 taxFee
515     )
516         private
517         pure
518         returns (
519             uint256,
520             uint256,
521             uint256
522         )
523     {
524         uint256 tFee = tAmount.mul(redisFee).div(100);
525         uint256 tTeam = tAmount.mul(taxFee).div(100);
526         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
527 
528         return (tTransferAmount, tFee, tTeam);
529     }
530 
531     function _getRValues(
532         uint256 tAmount,
533         uint256 tFee,
534         uint256 tTeam,
535         uint256 currentRate
536     )
537         private
538         pure
539         returns (
540             uint256,
541             uint256,
542             uint256
543         )
544     {
545         uint256 rAmount = tAmount.mul(currentRate);
546         uint256 rFee = tFee.mul(currentRate);
547         uint256 rTeam = tTeam.mul(currentRate);
548         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
549 
550         return (rAmount, rTransferAmount, rFee);
551     }
552 
553     function _getRate() private view returns (uint256) {
554         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
555 
556         return rSupply.div(tSupply);
557     }
558 
559     function _getCurrentSupply() private view returns (uint256, uint256) {
560         uint256 rSupply = _rTotal;
561         uint256 tSupply = _tTotal;
562         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
563     
564         return (rSupply, tSupply);
565     }
566     
567     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
568         _redisFeeOnBuy = redisFeeOnBuy;
569         _redisFeeOnSell = redisFeeOnSell;
570         
571         _taxFeeOnBuy = taxFeeOnBuy;
572         _taxFeeOnSell = taxFeeOnSell;
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
585     //Set MAx transaction
586     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
587         _maxTxAmount = maxTxAmount;
588     }
589     
590     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
591         _maxWalletSize = maxWalletSize;
592     }
593  
594     function allowPreTrading(address account, bool allowed) public onlyOwner {
595         require(preTrader[account] != allowed, "TOKEN: Already enabled.");
596         preTrader[account] = allowed;
597     }
598 }