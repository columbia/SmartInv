1 /**
2 The Maze | $MAZE
3 
4 Bet on adorable hamsters racing through thrilling mazes
5 */
6 
7 // SPDX-License-Identifier: Unlicensed
8 
9 //Twitter  :  https://twitter.com/TheMazeErc20
10 
11 //Telegram : https://t.me/TheMazeErc20
12 
13 //Website :  https://mazecoin.xyz/
14 
15 pragma solidity ^0.8.16;
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
75  
76     function transferOwnership(address newOwner) public virtual onlyOwner {
77         require(newOwner != address(0), "Ownable: new owner is the zero address");
78         emit OwnershipTransferred(_owner, newOwner);
79         _owner = newOwner;
80     }
81  
82 }
83  
84 library SafeMath {
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         require(c >= a, "SafeMath: addition overflow");
88         return c;
89     }
90  
91     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92         return sub(a, b, "SafeMath: subtraction overflow");
93     }
94  
95     function sub(
96         uint256 a,
97         uint256 b,
98         string memory errorMessage
99     ) internal pure returns (uint256) {
100         require(b <= a, errorMessage);
101         uint256 c = a - b;
102         return c;
103     }
104  
105     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
106         if (a == 0) {
107             return 0;
108         }
109         uint256 c = a * b;
110         require(c / a == b, "SafeMath: multiplication overflow");
111         return c;
112     }
113  
114     function div(uint256 a, uint256 b) internal pure returns (uint256) {
115         return div(a, b, "SafeMath: division by zero");
116     }
117  
118     function div(
119         uint256 a,
120         uint256 b,
121         string memory errorMessage
122     ) internal pure returns (uint256) {
123         require(b > 0, errorMessage);
124         uint256 c = a / b;
125         return c;
126     }
127 }
128  
129 interface IUniswapV2Factory {
130     function createPair(address tokenA, address tokenB)
131         external
132         returns (address pair);
133 }
134  
135 interface IUniswapV2Router02 {
136     function swapExactTokensForETHSupportingFeeOnTransferTokens(
137         uint256 amountIn,
138         uint256 amountOutMin,
139         address[] calldata path,
140         address to,
141         uint256 deadline
142     ) external;
143  
144     function factory() external pure returns (address);
145  
146     function WETH() external pure returns (address);
147  
148     function addLiquidityETH(
149         address token,
150         uint256 amountTokenDesired,
151         uint256 amountTokenMin,
152         uint256 amountETHMin,
153         address to,
154         uint256 deadline
155     )
156         external
157         payable
158         returns (
159             uint256 amountToken,
160             uint256 amountETH,
161             uint256 liquidity
162         );
163 }
164  
165 contract TheMaze is Context, IERC20, Ownable {
166  
167     using SafeMath for uint256;
168  
169     string private constant _name = "The Maze";
170     string private constant _symbol = "MAZE";
171     uint8 private constant _decimals = 9;
172  
173     mapping(address => uint256) private _rOwned;
174     mapping(address => uint256) private _tOwned;
175     mapping(address => mapping(address => uint256)) private _allowances;
176     mapping(address => bool) private _isExcludedFromFee;
177     uint256 private constant MAX = ~uint256(0);
178     uint256 private constant _tTotal = 10000000 * 10**9;
179     uint256 private _rTotal = (MAX - (MAX % _tTotal));
180     uint256 private _tFeeTotal;
181     uint256 private _redisFeeOnBuy = 0;  
182     uint256 private _taxFeeOnBuy = 20;
183     uint256 private _redisFeeOnSell = 0;
184     uint256 private _taxFeeOnSell = 20;
185     
186     uint256 private _redisFee = _redisFeeOnSell;
187     uint256 private _taxFee = _taxFeeOnSell;
188  
189     uint256 private _previousredisFee = _redisFee;
190     uint256 private _previoustaxFee = _taxFee;
191  
192     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
193     address payable private _developmentAddress = payable(0x563A4381D1C935C2A43d40f20F386beEa1afAC2b); 
194     address payable private _marketingAddress = payable(0x563A4381D1C935C2A43d40f20F386beEa1afAC2b);
195  
196     IUniswapV2Router02 public uniswapV2Router;
197     address public uniswapV2Pair;
198  
199     bool private tradingOpen = true;
200     bool private inSwap = false;
201     bool private swapEnabled = true;
202  
203     uint256 public _maxTxAmount = 200000 * 10**9; 
204     uint256 public _maxWalletSize = 200000 * 10**9; 
205     uint256 public _swapTokensAtAmount = 50000 * 10**9;
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
225         _isExcludedFromFee[_developmentAddress] = true;
226         _isExcludedFromFee[_marketingAddress] = true;
227  
228         emit Transfer(address(0), _msgSender(), _tTotal);
229     }
230  
231     function name() public pure returns (string memory) {
232         return _name;
233     }
234  
235     function symbol() public pure returns (string memory) {
236         return _symbol;
237     }
238  
239     function decimals() public pure returns (uint8) {
240         return _decimals;
241     }
242  
243     function totalSupply() public pure override returns (uint256) {
244         return _tTotal;
245     }
246  
247     function balanceOf(address account) public view override returns (uint256) {
248         return tokenFromReflection(_rOwned[account]);
249     }
250  
251     function transfer(address recipient, uint256 amount)
252         public
253         override
254         returns (bool)
255     {
256         _transfer(_msgSender(), recipient, amount);
257         return true;
258     }
259  
260     function allowance(address owner, address spender)
261         public
262         view
263         override
264         returns (uint256)
265     {
266         return _allowances[owner][spender];
267     }
268  
269     function approve(address spender, uint256 amount)
270         public
271         override
272         returns (bool)
273     {
274         _approve(_msgSender(), spender, amount);
275         return true;
276     }
277  
278     function transferFrom(
279         address sender,
280         address recipient,
281         uint256 amount
282     ) public override returns (bool) {
283         _transfer(sender, recipient, amount);
284         _approve(
285             sender,
286             _msgSender(),
287             _allowances[sender][_msgSender()].sub(
288                 amount,
289                 "ERC20: transfer amount exceeds allowance"
290             )
291         );
292         return true;
293     }
294  
295     function tokenFromReflection(uint256 rAmount)
296         private
297         view
298         returns (uint256)
299     {
300         require(
301             rAmount <= _rTotal,
302             "Amount must be less than total reflections"
303         );
304         uint256 currentRate = _getRate();
305         return rAmount.div(currentRate);
306     }
307  
308     function removeAllFee() private {
309         if (_redisFee == 0 && _taxFee == 0) return;
310  
311         _previousredisFee = _redisFee;
312         _previoustaxFee = _taxFee;
313  
314         _redisFee = 0;
315         _taxFee = 0;
316     }
317  
318     function restoreAllFee() private {
319         _redisFee = _previousredisFee;
320         _taxFee = _previoustaxFee;
321     }
322  
323     function _approve(
324         address owner,
325         address spender,
326         uint256 amount
327     ) private {
328         require(owner != address(0), "ERC20: approve from the zero address");
329         require(spender != address(0), "ERC20: approve to the zero address");
330         _allowances[owner][spender] = amount;
331         emit Approval(owner, spender, amount);
332     }
333  
334     function _transfer(
335         address from,
336         address to,
337         uint256 amount
338     ) private {
339         require(from != address(0), "ERC20: transfer from the zero address");
340         require(to != address(0), "ERC20: transfer to the zero address");
341         require(amount > 0, "Transfer amount must be greater than zero");
342  
343         if (from != owner() && to != owner()) {
344  
345             //Trade start check
346             if (!tradingOpen) {
347                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
348             }
349  
350             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
351             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
352  
353             if(to != uniswapV2Pair) {
354                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
355             }
356  
357             uint256 contractTokenBalance = balanceOf(address(this));
358             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
359  
360             if(contractTokenBalance >= _maxTxAmount)
361             {
362                 contractTokenBalance = _maxTxAmount;
363             }
364  
365             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
366                 swapTokensForEth(contractTokenBalance);
367                 uint256 contractETHBalance = address(this).balance;
368                 if (contractETHBalance > 0) {
369                     sendETHToFee(address(this).balance);
370                 }
371             }
372         }
373  
374         bool takeFee = true;
375  
376         //Transfer Tokens
377         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
378             takeFee = false;
379         } else {
380  
381             //Set Fee for Buys
382             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
383                 _redisFee = _redisFeeOnBuy;
384                 _taxFee = _taxFeeOnBuy;
385             }
386  
387             //Set Fee for Sells
388             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
389                 _redisFee = _redisFeeOnSell;
390                 _taxFee = _taxFeeOnSell;
391             }
392  
393         }
394  
395         _tokenTransfer(from, to, amount, takeFee);
396     }
397  
398     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
399         address[] memory path = new address[](2);
400         path[0] = address(this);
401         path[1] = uniswapV2Router.WETH();
402         _approve(address(this), address(uniswapV2Router), tokenAmount);
403         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
404             tokenAmount,
405             0,
406             path,
407             address(this),
408             block.timestamp
409         );
410     }
411  
412     function sendETHToFee(uint256 amount) private {
413         _marketingAddress.transfer(amount);
414     }
415  
416     function setTrading(bool _tradingOpen) public onlyOwner {
417         tradingOpen = _tradingOpen;
418     }
419  
420     function manualswap() external {
421         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
422         uint256 contractBalance = balanceOf(address(this));
423         swapTokensForEth(contractBalance);
424     }
425  
426     function manualsend() external {
427         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
428         uint256 contractETHBalance = address(this).balance;
429         sendETHToFee(contractETHBalance);
430     }
431  
432     function _tokenTransfer(
433         address sender,
434         address recipient,
435         uint256 amount,
436         bool takeFee
437     ) private {
438         if (!takeFee) removeAllFee();
439         _transferStandard(sender, recipient, amount);
440         if (!takeFee) restoreAllFee();
441     }
442  
443     function _transferStandard(
444         address sender,
445         address recipient,
446         uint256 tAmount
447     ) private {
448         (
449             uint256 rAmount,
450             uint256 rTransferAmount,
451             uint256 rFee,
452             uint256 tTransferAmount,
453             uint256 tFee,
454             uint256 tTeam
455         ) = _getValues(tAmount);
456         _rOwned[sender] = _rOwned[sender].sub(rAmount);
457         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
458         _takeTeam(tTeam);
459         _reflectFee(rFee, tFee);
460         emit Transfer(sender, recipient, tTransferAmount);
461     }
462  
463     function _takeTeam(uint256 tTeam) private {
464         uint256 currentRate = _getRate();
465         uint256 rTeam = tTeam.mul(currentRate);
466         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
467     }
468  
469     function _reflectFee(uint256 rFee, uint256 tFee) private {
470         _rTotal = _rTotal.sub(rFee);
471         _tFeeTotal = _tFeeTotal.add(tFee);
472     }
473  
474     receive() external payable {}
475  
476     function _getValues(uint256 tAmount)
477         private
478         view
479         returns (
480             uint256,
481             uint256,
482             uint256,
483             uint256,
484             uint256,
485             uint256
486         )
487     {
488         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
489             _getTValues(tAmount, _redisFee, _taxFee);
490         uint256 currentRate = _getRate();
491         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
492             _getRValues(tAmount, tFee, tTeam, currentRate);
493         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
494     }
495  
496     function _getTValues(
497         uint256 tAmount,
498         uint256 redisFee,
499         uint256 taxFee
500     )
501         private
502         pure
503         returns (
504             uint256,
505             uint256,
506             uint256
507         )
508     {
509         uint256 tFee = tAmount.mul(redisFee).div(100);
510         uint256 tTeam = tAmount.mul(taxFee).div(100);
511         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
512         return (tTransferAmount, tFee, tTeam);
513     }
514  
515     function _getRValues(
516         uint256 tAmount,
517         uint256 tFee,
518         uint256 tTeam,
519         uint256 currentRate
520     )
521         private
522         pure
523         returns (
524             uint256,
525             uint256,
526             uint256
527         )
528     {
529         uint256 rAmount = tAmount.mul(currentRate);
530         uint256 rFee = tFee.mul(currentRate);
531         uint256 rTeam = tTeam.mul(currentRate);
532         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
533         return (rAmount, rTransferAmount, rFee);
534     }
535  
536     function _getRate() private view returns (uint256) {
537         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
538         return rSupply.div(tSupply);
539     }
540  
541     function _getCurrentSupply() private view returns (uint256, uint256) {
542         uint256 rSupply = _rTotal;
543         uint256 tSupply = _tTotal;
544         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
545         return (rSupply, tSupply);
546     }
547  
548     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
549 
550         _redisFeeOnBuy = redisFeeOnBuy;
551         _redisFeeOnSell = redisFeeOnSell;
552         _taxFeeOnBuy = taxFeeOnBuy;
553         _taxFeeOnSell = taxFeeOnSell;
554 
555     }
556  
557     //Set minimum tokens required to swap.
558     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
559         _swapTokensAtAmount = swapTokensAtAmount;
560     }
561  
562     //Set minimum tokens required to swap.
563     function toggleSwap(bool _swapEnabled) public onlyOwner {
564         swapEnabled = _swapEnabled;
565     }
566  
567     //Set maximum transaction
568     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
569 	require(
570             maxTxAmount >= ((totalSupply() * 1) / 100),
571             "Cannot set maxTransactionAmount lower than 1%"
572         );
573 	_maxTxAmount = maxTxAmount;
574         
575     }
576  
577     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
578 	require(
579             maxWalletSize >= ((totalSupply() * 1) / 100),
580             "Cannot set maxWalletAmount lower than 1%"
581         );
582         _maxWalletSize = maxWalletSize;
583     }
584  
585     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
586         for(uint256 i = 0; i < accounts.length; i++) {
587             _isExcludedFromFee[accounts[i]] = excluded;
588         }
589     }
590 
591 }