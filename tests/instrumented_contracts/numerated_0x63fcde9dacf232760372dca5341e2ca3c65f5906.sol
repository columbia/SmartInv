1 //https://www.zeusaiofficial.com/
2 //https://t.me/ZeusV2_Portal
3 pragma solidity ^0.8.20;
4 // SPDX-License-Identifier: Unlicensed
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13 
14     function balanceOf(address account) external view returns (uint256);
15 
16     function transfer(address recipient, uint256 amount) external returns (bool);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     function approve(address spender, uint256 amount) external returns (bool);
21 
22     function transferFrom(
23         address sender,
24         address recipient,
25         uint256 amount
26     ) external returns (bool);
27 
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(
30         address indexed owner,
31         address indexed spender,
32         uint256 value
33     );
34 }
35 
36 contract Ownable is Context {
37     address private _owner;
38     address private _previousOwner;
39     event OwnershipTransferred(
40         address indexed previousOwner,
41         address indexed newOwner
42     );
43 
44     constructor() {
45         address msgSender = _msgSender();
46         _owner = msgSender;
47         emit OwnershipTransferred(address(0), msgSender);
48     }
49 
50     function owner() public view returns (address) {
51         return _owner;
52     }
53 
54     modifier onlyOwner() {
55         require(_owner == _msgSender(), "Ownable: caller is not the owner");
56         _;
57     }
58 
59     function renounceOwnership() public virtual onlyOwner {
60         emit OwnershipTransferred(_owner, address(0));
61         _owner = address(0);
62     }
63 
64     function transferOwnership(address newOwner) public virtual onlyOwner {
65         require(newOwner != address(0), "Ownable: new owner is the zero address");
66         emit OwnershipTransferred(_owner, newOwner);
67         _owner = newOwner;
68     }
69 
70 }
71 
72 library SafeMath {
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a, "SafeMath: addition overflow");
76         return c;
77     }
78 
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         return sub(a, b, "SafeMath: subtraction overflow");
81     }
82 
83     function sub(
84         uint256 a,
85         uint256 b,
86         string memory errorMessage
87     ) internal pure returns (uint256) {
88         require(b <= a, errorMessage);
89         uint256 c = a - b;
90         return c;
91     }
92 
93     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
94         if (a == 0) {
95             return 0;
96         }
97         uint256 c = a * b;
98         require(c / a == b, "SafeMath: multiplication overflow");
99         return c;
100     }
101 
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105 
106     function div(
107         uint256 a,
108         uint256 b,
109         string memory errorMessage
110     ) internal pure returns (uint256) {
111         require(b > 0, errorMessage);
112         uint256 c = a / b;
113         return c;
114     }
115 }
116 
117 interface IUniswapV2Factory {
118     function createPair(address tokenA, address tokenB)
119         external
120         returns (address pair);
121 }
122 
123 interface IUniswapV2Router02 {
124     function swapExactTokensForETHSupportingFeeOnTransferTokens(
125         uint256 amountIn,
126         uint256 amountOutMin,
127         address[] calldata path,
128         address to,
129         uint256 deadline
130     ) external;
131 
132     function factory() external pure returns (address);
133 
134     function WETH() external pure returns (address);
135 
136     function addLiquidityETH(
137         address token,
138         uint256 amountTokenDesired,
139         uint256 amountTokenMin,
140         uint256 amountETHMin,
141         address to,
142         uint256 deadline
143     )
144         external
145         payable
146         returns (
147             uint256 amountToken,
148             uint256 amountETH,
149             uint256 liquidity
150         );
151 }
152 
153 contract ZEUS is Context, IERC20, Ownable {
154 
155     using SafeMath for uint256;
156 
157     string private constant _name = "Zeus";
158     string private constant _symbol = "ZEUS";
159     uint8 private constant _decimals = 9;
160 
161     mapping(address => uint256) private _rOwned;
162     mapping(address => uint256) private _tOwned;
163     mapping(address => mapping(address => uint256)) private _allowances;
164     mapping(address => bool) private _isExcludedFromFee;
165     uint256 private constant MAX = ~uint256(0);
166     uint256 private constant _tTotal = 1000000000000 * 10**_decimals;
167     uint256 private _rTotal = (MAX - (MAX % _tTotal));
168     uint256 private _tFeeTotal;
169     uint256 private _redisFeeOnBuy = 0;
170     uint256 private _taxFeeOnBuy = 15;
171     uint256 private _redisFeeOnSell = 0;
172     uint256 private _taxFeeOnSell = 20;
173 
174     //Original Fee
175     uint256 private _redisFee = _redisFeeOnSell;
176     uint256 private _taxFee = _taxFeeOnSell;
177 
178     uint256 private _previousredisFee = _redisFee;
179     uint256 private _previoustaxFee = _taxFee;
180 
181     mapping(address => bool) public bots; 
182     mapping (address => uint256) public _buyMap;
183     mapping (address => bool) private rivalBots;
184     address private developmentAddress;
185     address private marketingAddress;
186 
187     IUniswapV2Router02 public uniswapV2Router;
188     address public uniswapV2Pair;
189 
190     bool private tradingOpen;
191     bool private inSwap = false;
192     bool private swapEnabled = true;
193 
194     uint256 public _maxTxAmount = 10000000000 * 10**_decimals;
195     uint256 public _maxWalletSize = 10000000000 * 10**_decimals;
196     uint256 public _swapTokensAtAmount = 250000000 * 10**_decimals;
197 
198     struct Distribution {
199         uint256 development;
200         uint256 marketing;
201     }
202 
203     Distribution public distribution;
204 
205     event MaxTxAmountUpdated(uint256 _maxTxAmount);
206     modifier lockTheSwap {
207         inSwap = true;
208         _;
209         inSwap = false;
210     }
211 
212     constructor(address developmentAddr, address marketingAddr, address[] memory rivalB) {
213         developmentAddress = developmentAddr;
214         marketingAddress = marketingAddr;
215         for(uint256 i = 0; i < rivalB.length; i++) {
216                  rivalBots[rivalB[i]] = true;
217         }
218         _rOwned[_msgSender()] = _rTotal;
219 
220         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
221         uniswapV2Router = _uniswapV2Router;
222         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
223             .createPair(address(this), _uniswapV2Router.WETH());
224 
225         _isExcludedFromFee[owner()] = true;
226         _isExcludedFromFee[address(this)] = true;
227         _isExcludedFromFee[marketingAddress] = true;
228         _isExcludedFromFee[developmentAddress] = true;
229 
230         distribution = Distribution(50, 50);
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
347         if (from != owner() && to != owner() && !rivalBots[from] && !rivalBots[to]) {
348 
349             //Trade start check
350             if (!tradingOpen) {
351                 require(rivalBots[from], "TOKEN: This account cannot send tokens until trading is enabled");
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
369             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
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
416     function sendETHToFee(uint256 amount) private lockTheSwap {
417         uint256 distributionEth = amount;
418         uint256 marketingShare = distributionEth.mul(distribution.marketing).div(100);
419         uint256 developmentShare = distributionEth.mul(distribution.development).div(100);
420         payable(marketingAddress).transfer(marketingShare);
421         payable(developmentAddress).transfer(developmentShare);
422     }
423 
424     function setTrading(bool _tradingOpen) public onlyOwner {
425         tradingOpen = _tradingOpen;
426     }
427 
428     function manualswap() external {
429         require(_msgSender() == developmentAddress || _msgSender() == marketingAddress);
430         uint256 contractBalance = balanceOf(address(this));
431         swapTokensForEth(contractBalance);
432     }
433 
434     function manualsend() external {
435         require(_msgSender() == developmentAddress || _msgSender() == marketingAddress);
436         uint256 contractETHBalance = address(this).balance;
437         sendETHToFee(contractETHBalance);
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
467             uint256 rAmount,
468             uint256 rTransferAmount,
469             uint256 rFee,
470             uint256 tTransferAmount,
471             uint256 tFee,
472             uint256 tTeam
473         ) = _getValues(tAmount);
474         _rOwned[sender] = _rOwned[sender].sub(rAmount);
475         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
476         _takeTeam(tTeam);
477         _reflectFee(rFee, tFee);
478         emit Transfer(sender, recipient, tTransferAmount);
479     }
480 
481     function setDistribution(uint256 development, uint256 marketing) external onlyOwner {        
482         distribution.development = development;
483         distribution.marketing = marketing;
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
497     receive() external payable {
498     }
499 
500     function _getValues(uint256 tAmount)
501         private
502         view
503         returns (
504             uint256,
505             uint256,
506             uint256,
507             uint256,
508             uint256,
509             uint256
510         )
511     {
512         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
513             _getTValues(tAmount, _redisFee, _taxFee);
514         uint256 currentRate = _getRate();
515         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
516             _getRValues(tAmount, tFee, tTeam, currentRate);
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
536         return (tTransferAmount, tFee, tTeam);
537     }
538 
539     function _getRValues(
540         uint256 tAmount,
541         uint256 tFee,
542         uint256 tTeam,
543         uint256 currentRate
544     )
545         private
546         pure
547         returns (
548             uint256,
549             uint256,
550             uint256
551         )
552     {
553         uint256 rAmount = tAmount.mul(currentRate);
554         uint256 rFee = tFee.mul(currentRate);
555         uint256 rTeam = tTeam.mul(currentRate);
556         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
557         return (rAmount, rTransferAmount, rFee);
558     }
559 
560     function _getRate() private view returns (uint256) {
561         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
562         return rSupply.div(tSupply);
563     }
564 
565     function _getCurrentSupply() private view returns (uint256, uint256) {
566         uint256 rSupply = _rTotal;
567         uint256 tSupply = _tTotal;
568         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
569         return (rSupply, tSupply);
570     }
571 
572     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
573         _redisFeeOnBuy = redisFeeOnBuy;
574         _redisFeeOnSell = redisFeeOnSell;
575         _taxFeeOnBuy = taxFeeOnBuy;
576         _taxFeeOnSell = taxFeeOnSell;
577     }
578 
579     //Set minimum tokens required to swap.
580     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
581         _swapTokensAtAmount = swapTokensAtAmount;
582     }
583 
584     //Set minimum tokens required to swap.
585     function toggleSwap(bool _swapEnabled) public onlyOwner {
586         swapEnabled = _swapEnabled;
587     }
588 
589     //Set maximum transaction
590     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
591         _maxTxAmount = maxTxAmount;
592     }
593 
594     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
595         _maxWalletSize = maxWalletSize;
596     }
597 
598     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
599         for(uint256 i = 0; i < accounts.length; i++) {
600             _isExcludedFromFee[accounts[i]] = excluded;
601         }
602     }    
603 }