1 /*
2     TG: https://t.me/XAII_erc20
3     TWITTER: https://twitter.com/XAII_ERC20
4     WEB: https://xaii-eth.com/
5 */
6 
7 // SPDX-License-Identifier: Unlicensed
8 pragma solidity ^0.8.9;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18 
19     function balanceOf(address account) external view returns (uint256);
20 
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     function allowance(address owner, address spender) external view returns (uint256);
24 
25     function approve(address spender, uint256 amount) external returns (bool);
26 
27     function transferFrom(
28         address sender,
29         address recipient,
30         uint256 amount
31     ) external returns (bool);
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(
35         address indexed owner,
36         address indexed spender,
37         uint256 value
38     );  
39 }
40 
41 contract Ownable is Context {
42     address private _owner;
43     address private _previousOwner;
44     event OwnershipTransferred(
45         address indexed previousOwner,
46         address indexed newOwner
47     );
48 
49     constructor() {
50         address msgSender = _msgSender();
51         _owner = msgSender;
52         emit OwnershipTransferred(address(0), msgSender);
53     }
54 
55     function owner() public view returns (address) {
56         return _owner;
57     }
58 
59     modifier onlyOwner() {
60         require(_owner == _msgSender(), "Ownable: caller is not the owner");
61         _;
62     }
63 
64     function renounceOwnership() public virtual onlyOwner {
65         emit OwnershipTransferred(_owner, address(0));
66         _owner = address(0);
67     }
68 
69     function transferOwnership(address newOwner) public virtual onlyOwner {
70         require(newOwner != address(0), "Ownable: new owner is the zero address");
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 
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
158 contract XAEAXII is Context, IERC20, Ownable {
159 
160     using SafeMath for uint256;
161 
162     string private constant _name = unicode"X Æ A-XII";
163     string private constant _symbol = unicode"XAII";
164     uint8 private constant _decimals = 9;
165  
166     mapping(address => uint256) private _rOwned;
167     mapping(address => uint256) private _tOwned;
168     mapping(address => mapping(address => uint256)) private _allowances;
169     mapping(address => bool) private _isExcludedFromFee;
170     uint256 private constant MAX = ~uint256(0);
171     uint256 private constant _tTotal = 100_000_000 * 10**_decimals;
172     uint256 private _rTotal = (MAX - (MAX % _tTotal));
173     uint256 private _tFeeTotal;
174     uint256 private _redisFeeOnBuy = 0;
175     uint256 private _taxFeeOnBuy = 20;
176     uint256 private _redisFeeOnSell = 0;
177     uint256 private _taxFeeOnSell = 30;
178 
179     uint256 private _redisFee = _redisFeeOnSell;
180     uint256 private _taxFee = _taxFeeOnSell;
181 
182     uint256 private _previousredisFee = _redisFee;
183     uint256 private _previoustaxFee = _taxFee;
184 
185     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
186     address payable private _developmentAddress = payable(0x33B4f16f641A6747231E10Bc4eeA4366c9A42b0C);
187     address payable private _marketingAddress = payable(0x2b8F6294C71cccF76d0966a091EA0a630aa7F7f1);
188 
189     IUniswapV2Router02 public uniswapV2Router;
190     address public uniswapV2Pair;
191 
192     bool private tradingOpen = true;
193     bool private inSwap = false;
194     bool private swapEnabled = true;
195 
196     uint256 public _maxTxAmount =  2 * (_tTotal/100);
197     uint256 public _maxWalletSize = 2 * (_tTotal/100);
198     uint256 public _swapTokensAtAmount = 1 *(_tTotal/1000);
199 
200     event MaxTxAmountUpdated(uint256 _maxTxAmount);
201     modifier lockTheSwap {
202         inSwap = true;
203         _; 
204         inSwap = false;
205     }
206 
207     constructor() {
208         _rOwned[_msgSender()] = _rTotal;
209         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
210         uniswapV2Router = _uniswapV2Router;
211         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
212             .createPair(address(this), _uniswapV2Router.WETH());
213 
214         _isExcludedFromFee[owner()] = true;
215         _isExcludedFromFee[address(this)] = true;
216         _isExcludedFromFee[_developmentAddress] = true;
217         _isExcludedFromFee[_marketingAddress] = true;
218 
219         emit Transfer(address(0), _msgSender(), _tTotal);
220     }
221 
222     function name() public pure returns (string memory) {
223         return _name;
224     }
225 
226     function symbol() public pure returns (string memory) {
227         return _symbol;
228     }
229 
230     function decimals() public pure returns (uint8) {
231         return _decimals;
232     }
233 
234     function totalSupply() public pure override returns (uint256) {
235         return _tTotal;
236     }
237 
238     function balanceOf(address account) public view override returns (uint256) {
239         return tokenFromReflection(_rOwned[account]);
240     }
241 
242     function transfer(address recipient, uint256 amount)
243         public
244         override
245         returns (bool)
246     {
247         _transfer(_msgSender(), recipient, amount);
248         return true;
249     }
250 
251     function allowance(address owner, address spender)
252         public
253         view
254         override
255         returns (uint256)
256     {
257         return _allowances[owner][spender];
258     }
259 
260     function approve(address spender, uint256 amount)
261         public
262         override
263         returns (bool)
264     {
265         _approve(_msgSender(), spender, amount);
266         return true;
267     }
268 
269     function transferFrom(
270         address sender,
271         address recipient,
272         uint256 amount
273     ) public override returns (bool) {
274         _transfer(sender, recipient, amount);
275         _approve(
276             sender,
277             _msgSender(),
278             _allowances[sender][_msgSender()].sub(
279                 amount,
280                 "ERC20: transfer amount exceeds allowance"
281             )
282         );
283         return true;
284     }
285 
286     function tokenFromReflection(uint256 rAmount)
287         private
288         view
289         returns (uint256)
290     {
291         require(
292             rAmount <= _rTotal,
293             "Amount must be less than total reflections"
294         );
295         uint256 currentRate = _getRate();
296         return rAmount.div(currentRate);
297     }
298 
299     function removeAllFee() private {
300         if (_redisFee == 0 && _taxFee == 0) return;
301 
302         _previousredisFee = _redisFee;
303         _previoustaxFee = _taxFee;
304 
305         _redisFee = 0;
306         _taxFee = 0;
307     }
308 
309     function restoreAllFee() private {
310         _redisFee = _previousredisFee;
311         _taxFee = _previoustaxFee;
312     }
313 
314     function _approve(
315         address owner,
316         address spender,
317         uint256 amount
318     ) private {
319         require(owner != address(0), "ERC20: approve from the zero address");
320         require(spender != address(0), "ERC20: approve to the zero address");
321         _allowances[owner][spender] = amount;
322         emit Approval(owner, spender, amount);
323     }
324 
325     function _transfer(
326         address from,
327         address to,
328         uint256 amount
329     ) private {
330         require(from != address(0), "ERC20: transfer from the zero address");
331         require(to != address(0), "ERC20: transfer to the zero address");
332         require(amount > 0, "Transfer amount must be greater than zero");
333 
334         if (from != owner() && to != owner()) {
335 
336             //Trade start check
337             if (!tradingOpen) {
338                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
339             }
340 
341             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
342             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
343 
344             if(to != uniswapV2Pair) {
345                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
346             }
347 
348             uint256 contractTokenBalance = balanceOf(address(this));
349             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
350 
351             if(contractTokenBalance >= _maxTxAmount)
352             {
353                 contractTokenBalance = _maxTxAmount;
354             }
355 
356             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
357                 swapTokensForEth(contractTokenBalance);
358                 uint256 contractETHBalance = address(this).balance;
359                 if (contractETHBalance > 0) {
360                     sendETHToFee(address(this).balance);
361                 }
362             }
363         }
364 
365         bool takeFee = true;
366 
367         //Transfer Tokens
368         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
369             takeFee = false;
370         } else {
371 
372             //Set Fee for Buys
373             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
374                 _redisFee = _redisFeeOnBuy;
375                 _taxFee = _taxFeeOnBuy;
376             }
377 
378             //Set Fee for Sells
379             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
380                 _redisFee = _redisFeeOnSell;
381                 _taxFee = _taxFeeOnSell;
382             }
383 
384         }
385 
386         _tokenTransfer(from, to, amount, takeFee);
387     }
388 
389     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
390         address[] memory path = new address[](2);
391         path[0] = address(this);
392         path[1] = uniswapV2Router.WETH();
393         _approve(address(this), address(uniswapV2Router), tokenAmount);
394         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
395             tokenAmount,
396             0,
397             path,
398             address(this),
399             block.timestamp
400         );
401     }
402 
403     function sendETHToFee(uint256 amount) private {
404         _marketingAddress.transfer(amount);
405     }
406 
407     function setTrading(bool _tradingOpen) public onlyOwner {
408         tradingOpen = _tradingOpen;
409     }
410 
411     function manualswap() external {
412         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
413         uint256 contractBalance = balanceOf(address(this));
414         swapTokensForEth(contractBalance);
415     }
416 
417     function manualsend() external {
418         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
419         uint256 contractETHBalance = address(this).balance;
420         sendETHToFee(contractETHBalance);
421     }
422 
423     function _tokenTransfer(
424         address sender,
425         address recipient,
426         uint256 amount,
427         bool takeFee
428     ) private {
429         if (!takeFee) removeAllFee();
430         _transferStandard(sender, recipient, amount);
431         if (!takeFee) restoreAllFee();
432     }
433 
434     function _transferStandard(
435         address sender,
436         address recipient,
437         uint256 tAmount
438     ) private {
439         (
440             uint256 rAmount,
441             uint256 rTransferAmount,
442             uint256 rFee,
443             uint256 tTransferAmount,
444             uint256 tFee,
445             uint256 tTeam
446         ) = _getValues(tAmount);
447         _rOwned[sender] = _rOwned[sender].sub(rAmount);
448         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
449         _takeTeam(tTeam);
450         _reflectFee(rFee, tFee);
451         emit Transfer(sender, recipient, tTransferAmount);
452     }
453 
454     function _takeTeam(uint256 tTeam) private {
455         uint256 currentRate = _getRate();
456         uint256 rTeam = tTeam.mul(currentRate);
457         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
458     }
459 
460     function _reflectFee(uint256 rFee, uint256 tFee) private {
461         _rTotal = _rTotal.sub(rFee);
462         _tFeeTotal = _tFeeTotal.add(tFee);
463     }
464 
465     receive() external payable {}
466 
467     function _getValues(uint256 tAmount)
468         private
469         view
470         returns (
471             uint256,
472             uint256,
473             uint256,
474             uint256,
475             uint256,
476             uint256
477         )
478     {
479         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
480             _getTValues(tAmount, _redisFee, _taxFee);
481         uint256 currentRate = _getRate();
482         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
483             _getRValues(tAmount, tFee, tTeam, currentRate);
484         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
485     }
486 
487     function _getTValues(
488         uint256 tAmount,
489         uint256 redisFee,
490         uint256 taxFee
491     )
492         private
493         pure
494         returns (
495             uint256,
496             uint256,
497             uint256
498         )
499     {
500         uint256 tFee = tAmount.mul(redisFee).div(100);
501         uint256 tTeam = tAmount.mul(taxFee).div(100);
502         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
503         return (tTransferAmount, tFee, tTeam);
504     }
505 
506     function _getRValues(
507         uint256 tAmount,
508         uint256 tFee,
509         uint256 tTeam,
510         uint256 currentRate
511     )
512         private
513         pure
514         returns (
515             uint256,
516             uint256,
517             uint256
518         )
519     {
520         uint256 rAmount = tAmount.mul(currentRate);
521         uint256 rFee = tFee.mul(currentRate);
522         uint256 rTeam = tTeam.mul(currentRate);
523         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
524         return (rAmount, rTransferAmount, rFee);
525     }
526 
527     function _getRate() private view returns (uint256) {
528         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
529         return rSupply.div(tSupply);
530     }
531 
532     function _getCurrentSupply() private view returns (uint256, uint256) {
533         uint256 rSupply = _rTotal;
534         uint256 tSupply = _tTotal;
535         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
536         return (rSupply, tSupply);
537     }
538 
539     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
540         _redisFeeOnBuy = redisFeeOnBuy;
541         _redisFeeOnSell = redisFeeOnSell;
542         _taxFeeOnBuy = taxFeeOnBuy;
543         _taxFeeOnSell = taxFeeOnSell;
544     }
545 
546     //Set minimum tokens required to swap.
547     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
548         _swapTokensAtAmount = swapTokensAtAmount;
549     }
550 
551     //Set minimum tokens required to swap.
552     function toggleSwap(bool _swapEnabled) public onlyOwner {
553         swapEnabled = _swapEnabled;
554     }
555 
556     //Set maximum transaction
557     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
558         _maxTxAmount = maxTxAmount;
559     }
560 
561     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
562         _maxWalletSize = maxWalletSize;
563     }
564 
565     function setMaxAll() public onlyOwner {
566         _maxWalletSize = _tTotal;
567         _maxTxAmount = _tTotal;
568     }
569 }