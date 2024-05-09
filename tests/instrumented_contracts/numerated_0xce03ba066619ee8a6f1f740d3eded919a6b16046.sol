1 //SPDX-License-Identifier: MIT
2 
3 /* 
4 Telegram : https://t.me/TeleBetPortal
5 Website : https://telebet.app/
6 Twitter : https://twitter.com/TeleBetETH
7 
8 APP : https://t.me/telebeterc_bot
9 */
10 
11 pragma solidity ^0.8.20;
12 
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 }
19 
20 contract Ownable is Context {
21     address private _owner;
22     address private _previousOwner;
23     event OwnershipTransferred(
24         address indexed previousOwner,
25         address indexed newOwner
26     );
27  
28     constructor() {
29         address msgSender = _msgSender();
30         _owner = msgSender;
31         emit OwnershipTransferred(address(0), msgSender);
32     }
33  
34     function owner() public view returns (address) {
35         return _owner;
36     }
37  
38     modifier onlyOwner() {
39         require(_owner == _msgSender(), "Ownable: caller is not the owner");
40         _;
41     }
42  
43     function renounceOwnership() public virtual onlyOwner {
44         emit OwnershipTransferred(_owner, address(0));
45         _owner = address(0);
46     }
47  
48     function transferOwnership(address newOwner) public virtual onlyOwner {
49         require(newOwner != address(0), "Ownable: new owner is the zero address");
50         emit OwnershipTransferred(_owner, newOwner);
51         _owner = newOwner;
52     }
53  
54 }
55 
56 interface IERC20 {
57     function totalSupply() external view returns (uint256);
58  
59     function balanceOf(address account) external view returns (uint256);
60  
61     function transfer(address recipient, uint256 amount) external returns (bool);
62  
63     function allowance(address owner, address spender) external view returns (uint256);
64  
65     function approve(address spender, uint256 amount) external returns (bool);
66  
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72  
73     event Transfer(address indexed from, address indexed to, uint256 value);
74     event Approval(
75         address indexed owner,
76         address indexed spender,
77         uint256 value
78     );
79 }
80 
81 interface IUniswapV2Factory {
82     function createPair(address tokenA, address tokenB)
83         external
84         returns (address pair);
85 }
86  
87 interface IUniswapV2Router02 {
88     function swapExactTokensForETHSupportingFeeOnTransferTokens(
89         uint256 amountIn,
90         uint256 amountOutMin,
91         address[] calldata path,
92         address to,
93         uint256 deadline
94     ) external;
95  
96     function factory() external pure returns (address);
97  
98     function WETH() external pure returns (address);
99  
100     function addLiquidityETH(
101         address token,
102         uint256 amountTokenDesired,
103         uint256 amountTokenMin,
104         uint256 amountETHMin,
105         address to,
106         uint256 deadline
107     )
108         external
109         payable
110         returns (
111             uint256 amountToken,
112             uint256 amountETH,
113             uint256 liquidity
114         );
115 }
116  
117 library SafeMath {
118     function add(uint256 a, uint256 b) internal pure returns (uint256) {
119         uint256 c = a + b;
120         require(c >= a, "SafeMath: addition overflow");
121         return c;
122     }
123  
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         return sub(a, b, "SafeMath: subtraction overflow");
126     }
127  
128     function sub(
129         uint256 a,
130         uint256 b,
131         string memory errorMessage
132     ) internal pure returns (uint256) {
133         require(b <= a, errorMessage);
134         uint256 c = a - b;
135         return c;
136     }
137  
138     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
139         if (a == 0) {
140             return 0;
141         }
142         uint256 c = a * b;
143         require(c / a == b, "SafeMath: multiplication overflow");
144         return c;
145     }
146  
147     function div(uint256 a, uint256 b) internal pure returns (uint256) {
148         return div(a, b, "SafeMath: division by zero");
149     }
150  
151     function div(
152         uint256 a,
153         uint256 b,
154         string memory errorMessage
155     ) internal pure returns (uint256) {
156         require(b > 0, errorMessage);
157         uint256 c = a / b;
158         return c;
159     }
160 }
161  
162 
163  
164 contract TELEBET is Context, IERC20, Ownable {
165  
166     using SafeMath for uint256;
167  
168     string private constant _name = "TeleBet"; 
169     string private constant _symbol = "TBET"; 
170     uint8 private constant _decimals = 18;
171  
172     mapping(address => uint256) private _rOwned;
173     mapping(address => uint256) private _tOwned;
174     mapping(address => mapping(address => uint256)) private _allowances;
175     mapping(address => bool) private _isExcludedFromFee;
176     uint256 private constant MAX = ~uint256(0);
177 
178     uint256 private constant _tTotal = 1000000 * 10**18; 
179     uint256 private _rTotal = (MAX - (MAX % _tTotal));
180     uint256 private _tFeeTotal;
181  
182     //Buy Fee
183     uint256 private _feeOnBuy = 0;  
184     uint256 private _taxOnBuy = 15;   
185  
186     //Sell Fee
187     uint256 private _feeOnSell = 0; 
188     uint256 private _taxOnSell = 30;  
189 
190     uint256 public totalFees;
191  
192     //Original Fee
193     uint256 private _redisFee = _feeOnSell;
194     uint256 private _taxFee = _taxOnSell;
195  
196     uint256 private _previousredisFee = _redisFee;
197     uint256 private _previoustaxFee = _taxFee;
198  
199     mapping(address => uint256) private cooldown;
200  
201     address payable private _marketingWalletAddress = payable(0x9877b6b51416bE0FA4EcAF0B86A5327526b7b431 );
202  
203     IUniswapV2Router02 public uniswapV2Router;
204     address public uniswapV2Pair;
205  
206     bool private tradingOpen;
207     bool private inSwap = false;
208     bool private swapEnabled = true;
209  
210     uint256 public _maxTxAmount = 10000 * 10**18;
211     uint256 public _maxWalletSize = 10000 * 10**18; 
212     uint256 public _swapTokensAtAmount = 10000 * 10**18; 
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
225         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
226         uniswapV2Router = _uniswapV2Router;
227         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
228             .createPair(address(this), _uniswapV2Router.WETH());
229  
230         _isExcludedFromFee[owner()] = true;
231         _isExcludedFromFee[address(this)] = true;
232         _isExcludedFromFee[_marketingWalletAddress] = true;
233  
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
358  
359             if(to != uniswapV2Pair) {
360                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
361             }
362  
363             uint256 contractTokenBalance = balanceOf(address(this));
364             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
365  
366             if(contractTokenBalance >= _maxTxAmount)
367             {
368                 contractTokenBalance = _maxTxAmount;
369             }
370  
371             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
372                 if(amount >= _swapTokensAtAmount) {
373                     swapTokensForEth(_swapTokensAtAmount);
374                 } else {
375                     swapTokensForEth(amount);
376                 }
377             }
378         }
379  
380         bool takeFee = true;
381  
382         //Transfer Tokens
383         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
384             takeFee = false;
385         } else {
386  
387             //Set Fee for Buys
388             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
389                 _redisFee = _feeOnBuy;
390                 _taxFee = _taxOnBuy;
391             }
392  
393             //Set Fee for Sells
394             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
395                 _redisFee = _feeOnSell;
396                 _taxFee = _taxOnSell;
397             }
398  
399         }
400  
401         _tokenTransfer(from, to, amount, takeFee);
402     }
403  
404     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
405         address[] memory path = new address[](2);
406         path[0] = address(this);
407         path[1] = uniswapV2Router.WETH();
408         _approve(address(this), address(uniswapV2Router), tokenAmount);
409         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
410             tokenAmount,
411             0,
412             path,
413             address(_marketingWalletAddress),
414             block.timestamp
415         );
416     }
417  
418     function setTrading(bool _tradingOpen) public onlyOwner {
419         tradingOpen = _tradingOpen;
420     }
421  
422     function _tokenTransfer(
423         address sender,
424         address recipient,
425         uint256 amount,
426         bool takeFee
427     ) private {
428         if (!takeFee) removeAllFee();
429         _transferStandard(sender, recipient, amount);
430         if (!takeFee) restoreAllFee();
431     }
432  
433     function _transferStandard(
434         address sender,
435         address recipient,
436         uint256 tAmount
437     ) private {
438         (
439             uint256 rAmount,
440             uint256 rTransferAmount,
441             uint256 rFee,
442             uint256 tTransferAmount,
443             uint256 tFee,
444             uint256 tTeam
445         ) = _getValues(tAmount);
446         _rOwned[sender] = _rOwned[sender].sub(rAmount);
447         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
448         _takeTeam(tTeam);
449         _reflectFee(rFee, tFee);
450         emit Transfer(sender, recipient, tTransferAmount);
451     }
452  
453     function _takeTeam(uint256 tTeam) private {
454         uint256 currentRate = _getRate();
455         uint256 rTeam = tTeam.mul(currentRate);
456         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
457     }
458  
459     function _reflectFee(uint256 rFee, uint256 tFee) private {
460         _rTotal = _rTotal.sub(rFee);
461         _tFeeTotal = _tFeeTotal.add(tFee);
462     }
463  
464     receive() external payable {}
465  
466     function _getValues(uint256 tAmount)
467         private
468         view
469         returns (
470             uint256,
471             uint256,
472             uint256,
473             uint256,
474             uint256,
475             uint256
476         )
477     {
478         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
479             _getTValues(tAmount, _redisFee, _taxFee);
480         uint256 currentRate = _getRate();
481         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
482             _getRValues(tAmount, tFee, tTeam, currentRate);
483  
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
503  
504         return (tTransferAmount, tFee, tTeam);
505     }
506  
507     function _getRValues(
508         uint256 tAmount,
509         uint256 tFee,
510         uint256 tTeam,
511         uint256 currentRate
512     )
513         private
514         pure
515         returns (
516             uint256,
517             uint256,
518             uint256
519         )
520     {
521         uint256 rAmount = tAmount.mul(currentRate);
522         uint256 rFee = tFee.mul(currentRate);
523         uint256 rTeam = tTeam.mul(currentRate);
524         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
525  
526         return (rAmount, rTransferAmount, rFee);
527     }
528  
529     function _getRate() private view returns (uint256) {
530         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
531  
532         return rSupply.div(tSupply);
533     }
534  
535     function _getCurrentSupply() private view returns (uint256, uint256) {
536         uint256 rSupply = _rTotal;
537         uint256 tSupply = _tTotal;
538         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
539  
540         return (rSupply, tSupply);
541     }
542  
543     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
544         _feeOnBuy = redisFeeOnBuy;
545         _feeOnSell = redisFeeOnSell;
546         _taxOnBuy = taxFeeOnBuy;
547         _taxOnSell = taxFeeOnSell;
548         totalFees = _feeOnBuy + _feeOnSell + _taxOnBuy + _taxOnSell;
549         require(totalFees <= 100, "Must keep fees at 100% or less");
550     }
551  
552     //Set minimum tokens required to swap.
553     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
554         _swapTokensAtAmount = swapTokensAtAmount;
555     }
556  
557     //Set minimum tokens required to swap.
558     function toggleSwap(bool _swapEnabled) public onlyOwner {
559         swapEnabled = _swapEnabled;
560     }
561  
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