1 //SPDX-License-Identifier: MIT
2 
3 /*
4 🌚 The AIO Bot (All-in-One Bot) is a revolutionary solution designed to streamline and simplify your daily tasks on the Ethereum network. 
5   It harnesses the power of artificial intelligence and blockchain technology to provide a comprehensive and versatile toolset that caters to various needs within the Ethereum ecosystem.
6 
7  🌚 AIO BOT : https://t.me/AIOSystemBot
8  📱 Telegram : https://t.me/AIOETH
9  🌐 Website : https://aiobot.app/
10  🐦 Twitter : https://twitter.com/AIOBotETH
11 
12 
13 */
14 pragma solidity ^0.8.20;
15 
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 }
22 
23 contract Ownable is Context {
24     address private _owner;
25     address private _previousOwner;
26     event OwnershipTransferred(
27         address indexed previousOwner,
28         address indexed newOwner
29     );
30  
31     constructor() {
32         address msgSender = _msgSender();
33         _owner = msgSender;
34         emit OwnershipTransferred(address(0), msgSender);
35     }
36  
37     function owner() public view returns (address) {
38         return _owner;
39     }
40  
41     modifier onlyOwner() {
42         require(_owner == _msgSender(), "Ownable: caller is not the owner");
43         _;
44     }
45  
46     function renounceOwnership() public virtual onlyOwner {
47         emit OwnershipTransferred(_owner, address(0));
48         _owner = address(0);
49     }
50  
51     function transferOwnership(address newOwner) public virtual onlyOwner {
52         require(newOwner != address(0), "Ownable: new owner is the zero address");
53         emit OwnershipTransferred(_owner, newOwner);
54         _owner = newOwner;
55     }
56  
57 }
58 
59 interface IERC20 {
60     function totalSupply() external view returns (uint256);
61  
62     function balanceOf(address account) external view returns (uint256);
63  
64     function transfer(address recipient, uint256 amount) external returns (bool);
65  
66     function allowance(address owner, address spender) external view returns (uint256);
67  
68     function approve(address spender, uint256 amount) external returns (bool);
69  
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75  
76     event Transfer(address indexed from, address indexed to, uint256 value);
77     event Approval(
78         address indexed owner,
79         address indexed spender,
80         uint256 value
81     );
82 }
83 
84 interface IUniswapV2Factory {
85     function createPair(address tokenA, address tokenB)
86         external
87         returns (address pair);
88 }
89  
90 interface IUniswapV2Router02 {
91     function swapExactTokensForETHSupportingFeeOnTransferTokens(
92         uint256 amountIn,
93         uint256 amountOutMin,
94         address[] calldata path,
95         address to,
96         uint256 deadline
97     ) external;
98  
99     function factory() external pure returns (address);
100  
101     function WETH() external pure returns (address);
102  
103     function addLiquidityETH(
104         address token,
105         uint256 amountTokenDesired,
106         uint256 amountTokenMin,
107         uint256 amountETHMin,
108         address to,
109         uint256 deadline
110     )
111         external
112         payable
113         returns (
114             uint256 amountToken,
115             uint256 amountETH,
116             uint256 liquidity
117         );
118 }
119  
120 library SafeMath {
121     function add(uint256 a, uint256 b) internal pure returns (uint256) {
122         uint256 c = a + b;
123         require(c >= a, "SafeMath: addition overflow");
124         return c;
125     }
126  
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         return sub(a, b, "SafeMath: subtraction overflow");
129     }
130  
131     function sub(
132         uint256 a,
133         uint256 b,
134         string memory errorMessage
135     ) internal pure returns (uint256) {
136         require(b <= a, errorMessage);
137         uint256 c = a - b;
138         return c;
139     }
140  
141     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
142         if (a == 0) {
143             return 0;
144         }
145         uint256 c = a * b;
146         require(c / a == b, "SafeMath: multiplication overflow");
147         return c;
148     }
149  
150     function div(uint256 a, uint256 b) internal pure returns (uint256) {
151         return div(a, b, "SafeMath: division by zero");
152     }
153  
154     function div(
155         uint256 a,
156         uint256 b,
157         string memory errorMessage
158     ) internal pure returns (uint256) {
159         require(b > 0, errorMessage);
160         uint256 c = a / b;
161         return c;
162     }
163 }
164  
165 contract AIOBot is Context, IERC20, Ownable {
166  
167     using SafeMath for uint256;
168  
169     string private constant _name = "AIO Bot"; 
170     string private constant _symbol = "AIO"; 
171     uint8 private constant _decimals = 9;
172  
173     mapping(address => uint256) private _rOwned;
174     mapping(address => uint256) private _tOwned;
175     mapping(address => mapping(address => uint256)) private _allowances;
176     mapping(address => bool) private _isExcludedFromFee;
177     uint256 private constant MAX = ~uint256(0);
178 
179     uint256 private constant _tTotal = 1000000 * 10**18; 
180     uint256 private _rTotal = (MAX - (MAX % _tTotal));
181     uint256 private _tFeeTotal;
182  
183     //Buy Fee
184     uint256 private _feeOnBuy = 0;  
185     uint256 private _taxOnBuy = 15;   
186  
187     //Sell Fee
188     uint256 private _feeOnSell = 0;
189     uint256 private _taxOnSell = 35;  
190 
191     uint256 public totalFees;
192  
193     //Original Fee
194     uint256 private _redisFee = _feeOnSell;
195     uint256 private _taxFee = _taxOnSell;
196  
197     uint256 private _previousredisFee = _redisFee;
198     uint256 private _previoustaxFee = _taxFee;
199  
200     mapping(address => uint256) private cooldown;
201  
202     address payable private _marketingWalletAddress = payable(0xcD4F7b523FDee5B33268D311b8B49437610F87c4 );
203  
204     IUniswapV2Router02 public uniswapV2Router;
205     address public uniswapV2Pair;
206  
207     bool private tradingOpen;
208     bool private inSwap = false;
209     bool private swapEnabled = true;
210  
211     uint256 public _maxTxAmount = 10000 * 10**18;
212     uint256 public _maxWalletSize = 10000 * 10**18; 
213     uint256 public _swapTokensAtAmount = 10000 * 10**18; 
214  
215     event MaxTxAmountUpdated(uint256 _maxTxAmount);
216     modifier lockTheSwap {
217         inSwap = true;
218         _;
219         inSwap = false;
220     }
221  
222     constructor() {
223  
224         _rOwned[_msgSender()] = _rTotal;
225  
226         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
227         uniswapV2Router = _uniswapV2Router;
228         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
229             .createPair(address(this), _uniswapV2Router.WETH());
230  
231         _isExcludedFromFee[owner()] = true;
232         _isExcludedFromFee[address(this)] = true;
233         _isExcludedFromFee[_marketingWalletAddress] = true;
234  
235  
236         emit Transfer(address(0), _msgSender(), _tTotal);
237     }
238  
239     function name() public pure returns (string memory) {
240         return _name;
241     }
242  
243     function symbol() public pure returns (string memory) {
244         return _symbol;
245     }
246  
247     function decimals() public pure returns (uint8) {
248         return _decimals;
249     }
250  
251     function totalSupply() public pure override returns (uint256) {
252         return _tTotal;
253     }
254  
255     function balanceOf(address account) public view override returns (uint256) {
256         return tokenFromReflection(_rOwned[account]);
257     }
258  
259     function transfer(address recipient, uint256 amount)
260         public
261         override
262         returns (bool)
263     {
264         _transfer(_msgSender(), recipient, amount);
265         return true;
266     }
267  
268     function allowance(address owner, address spender)
269         public
270         view
271         override
272         returns (uint256)
273     {
274         return _allowances[owner][spender];
275     }
276  
277     function approve(address spender, uint256 amount)
278         public
279         override
280         returns (bool)
281     {
282         _approve(_msgSender(), spender, amount);
283         return true;
284     }
285  
286     function transferFrom(
287         address sender,
288         address recipient,
289         uint256 amount
290     ) public override returns (bool) {
291         _transfer(sender, recipient, amount);
292         _approve(
293             sender,
294             _msgSender(),
295             _allowances[sender][_msgSender()].sub(
296                 amount,
297                 "ERC20: transfer amount exceeds allowance"
298             )
299         );
300         return true;
301     }
302  
303     function tokenFromReflection(uint256 rAmount)
304         private
305         view
306         returns (uint256)
307     {
308         require(
309             rAmount <= _rTotal,
310             "Amount must be less than total reflections"
311         );
312         uint256 currentRate = _getRate();
313         return rAmount.div(currentRate);
314     }
315  
316     function removeAllFee() private {
317         if (_redisFee == 0 && _taxFee == 0) return;
318  
319         _previousredisFee = _redisFee;
320         _previoustaxFee = _taxFee;
321  
322         _redisFee = 0;
323         _taxFee = 0;
324     }
325  
326     function restoreAllFee() private {
327         _redisFee = _previousredisFee;
328         _taxFee = _previoustaxFee;
329     }
330  
331     function _approve(
332         address owner,
333         address spender,
334         uint256 amount
335     ) private {
336         require(owner != address(0), "ERC20: approve from the zero address");
337         require(spender != address(0), "ERC20: approve to the zero address");
338         _allowances[owner][spender] = amount;
339         emit Approval(owner, spender, amount);
340     }
341  
342     function _transfer(
343         address from,
344         address to,
345         uint256 amount
346     ) private {
347         require(from != address(0), "ERC20: transfer from the zero address");
348         require(to != address(0), "ERC20: transfer to the zero address");
349         require(amount > 0, "Transfer amount must be greater than zero");
350  
351         if (from != owner() && to != owner()) {
352  
353             //Trade start check
354             if (!tradingOpen) {
355                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
356             }
357  
358             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
359  
360             if(to != uniswapV2Pair) {
361                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
362             }
363  
364             uint256 contractTokenBalance = balanceOf(address(this));
365             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
366  
367             if(contractTokenBalance >= _maxTxAmount)
368             {
369                 contractTokenBalance = _maxTxAmount;
370             }
371  
372             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
373                 if(amount >= _swapTokensAtAmount) {
374                     swapTokensForEth(_swapTokensAtAmount);
375                 } else {
376                     swapTokensForEth(amount);
377                 }
378             }
379         }
380  
381         bool takeFee = true;
382  
383         //Transfer Tokens
384         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
385             takeFee = false;
386         } else {
387  
388             //Set Fee for Buys
389             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
390                 _redisFee = _feeOnBuy;
391                 _taxFee = _taxOnBuy;
392             }
393  
394             //Set Fee for Sells
395             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
396                 _redisFee = _feeOnSell;
397                 _taxFee = _taxOnSell;
398             }
399  
400         }
401  
402         _tokenTransfer(from, to, amount, takeFee);
403     }
404  
405     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
406         address[] memory path = new address[](2);
407         path[0] = address(this);
408         path[1] = uniswapV2Router.WETH();
409         _approve(address(this), address(uniswapV2Router), tokenAmount);
410         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
411             tokenAmount,
412             0,
413             path,
414             address(_marketingWalletAddress),
415             block.timestamp
416         );
417     }
418  
419     function setTrading(bool _tradingOpen) public onlyOwner {
420         tradingOpen = _tradingOpen;
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
484  
485         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
486     }
487  
488     function _getTValues(
489         uint256 tAmount,
490         uint256 redisFee,
491         uint256 taxFee
492     )
493         private
494         pure
495         returns (
496             uint256,
497             uint256,
498             uint256
499         )
500     {
501         uint256 tFee = tAmount.mul(redisFee).div(100);
502         uint256 tTeam = tAmount.mul(taxFee).div(100);
503         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
504  
505         return (tTransferAmount, tFee, tTeam);
506     }
507  
508     function _getRValues(
509         uint256 tAmount,
510         uint256 tFee,
511         uint256 tTeam,
512         uint256 currentRate
513     )
514         private
515         pure
516         returns (
517             uint256,
518             uint256,
519             uint256
520         )
521     {
522         uint256 rAmount = tAmount.mul(currentRate);
523         uint256 rFee = tFee.mul(currentRate);
524         uint256 rTeam = tTeam.mul(currentRate);
525         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
526  
527         return (rAmount, rTransferAmount, rFee);
528     }
529  
530     function _getRate() private view returns (uint256) {
531         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
532  
533         return rSupply.div(tSupply);
534     }
535  
536     function _getCurrentSupply() private view returns (uint256, uint256) {
537         uint256 rSupply = _rTotal;
538         uint256 tSupply = _tTotal;
539         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
540  
541         return (rSupply, tSupply);
542     }
543  
544     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
545         _feeOnBuy = redisFeeOnBuy;
546         _feeOnSell = redisFeeOnSell;
547         _taxOnBuy = taxFeeOnBuy;
548         _taxOnSell = taxFeeOnSell;
549         totalFees = _feeOnBuy + _feeOnSell + _taxOnBuy + _taxOnSell;
550         require(totalFees <= 100, "Must keep fees at 100% or less");
551     }
552  
553     //Set minimum tokens required to swap.
554     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
555         _swapTokensAtAmount = swapTokensAtAmount;
556     }
557  
558     //Set minimum tokens required to swap.
559     function toggleSwap(bool _swapEnabled) public onlyOwner {
560         swapEnabled = _swapEnabled;
561     }
562  
563     //Set max buy amount 
564     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
565         _maxTxAmount = maxTxAmount;
566     }
567 
568     //Set max wallet amount 
569     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
570         _maxWalletSize = maxWalletSize;
571     }
572 
573     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
574         for(uint256 i = 0; i < accounts.length; i++) {
575             _isExcludedFromFee[accounts[i]] = excluded;
576         }
577     }
578 }