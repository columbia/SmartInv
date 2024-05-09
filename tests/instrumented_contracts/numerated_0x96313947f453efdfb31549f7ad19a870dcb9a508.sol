1 /**
2 Welcome to Verified Doge - $VDOGE
3 ‍
4 The $VDOGE platform is a crypto-alpha ecosystem, empowering users to vote for legit crypto
5 influencers & trusted alpha that is easier to find.
6 
7 Website :- https://www.verifieddoge.com
8 Twitter :- https://twitter.com/vdoge_eth
9 Telegram :- https://t.me/verifieddoge
10 
11 
12 */
13 //SPDX-License-Identifier: UNLICENSED
14 pragma solidity ^0.8.4;
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
164 contract VerifiedDoge is Context, IERC20, Ownable {
165  
166     using SafeMath for uint256;
167  
168     string private constant _name = "VerifiedDoge"; 
169     string private constant _symbol = "VDOGE"; 
170     uint8 private constant _decimals = 9;
171  
172     mapping(address => uint256) private _rOwned;
173     mapping(address => uint256) private _tOwned;
174     mapping(address => mapping(address => uint256)) private _allowances;
175     mapping(address => bool) private _isExcludedFromFee;
176     uint256 private constant MAX = ~uint256(0);
177 
178     uint256 private constant _tTotal = 1000000000 * 10**9; 
179     uint256 private _rTotal = (MAX - (MAX % _tTotal));
180     uint256 private _tFeeTotal;
181  
182     //Buy Fee
183     uint256 private _redisFeeOnBuy = 2;  
184     uint256 private _taxFeeOnBuy = 5;   
185  
186     //Sell Fee
187     uint256 private _redisFeeOnSell = 2; 
188     uint256 private _taxFeeOnSell = 8;  
189 
190     uint256 public totalFees;
191  
192     //Original Fee
193     uint256 private _redisFee = _redisFeeOnSell;
194     uint256 private _taxFee = _taxFeeOnSell;
195  
196     uint256 private _previousredisFee = _redisFee;
197     uint256 private _previoustaxFee = _taxFee;
198  
199     mapping(address => uint256) private cooldown;
200  
201     address payable private _developmentAddress = payable(0xb58F5C00EfAc521C22E7F76206Ba3Ee62d785755);
202     address payable private _marketingAddress = payable(0xb58F5C00EfAc521C22E7F76206Ba3Ee62d785755);
203  
204     IUniswapV2Router02 public uniswapV2Router;
205     address public uniswapV2Pair;
206  
207     bool private tradingOpen;
208     bool private inSwap = false;
209     bool private swapEnabled = true;
210  
211     uint256 public _maxTxAmount = 10000000 * 10**9;
212     uint256 public _maxWalletSize = 10000000 * 10**9; 
213     uint256 public _swapTokensAtAmount = 10000 * 10**9; 
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
226         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
227         uniswapV2Router = _uniswapV2Router;
228         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
229             .createPair(address(this), _uniswapV2Router.WETH());
230  
231         _isExcludedFromFee[owner()] = true;
232         _isExcludedFromFee[address(this)] = true;
233         _isExcludedFromFee[_developmentAddress] = true;
234         _isExcludedFromFee[_marketingAddress] = true;
235  
236  
237         emit Transfer(address(0), _msgSender(), _tTotal);
238     }
239  
240     function name() public pure returns (string memory) {
241         return _name;
242     }
243  
244     function symbol() public pure returns (string memory) {
245         return _symbol;
246     }
247  
248     function decimals() public pure returns (uint8) {
249         return _decimals;
250     }
251  
252     function totalSupply() public pure override returns (uint256) {
253         return _tTotal;
254     }
255  
256     function balanceOf(address account) public view override returns (uint256) {
257         return tokenFromReflection(_rOwned[account]);
258     }
259  
260     function transfer(address recipient, uint256 amount)
261         public
262         override
263         returns (bool)
264     {
265         _transfer(_msgSender(), recipient, amount);
266         return true;
267     }
268  
269     function allowance(address owner, address spender)
270         public
271         view
272         override
273         returns (uint256)
274     {
275         return _allowances[owner][spender];
276     }
277  
278     function approve(address spender, uint256 amount)
279         public
280         override
281         returns (bool)
282     {
283         _approve(_msgSender(), spender, amount);
284         return true;
285     }
286  
287     function transferFrom(
288         address sender,
289         address recipient,
290         uint256 amount
291     ) public override returns (bool) {
292         _transfer(sender, recipient, amount);
293         _approve(
294             sender,
295             _msgSender(),
296             _allowances[sender][_msgSender()].sub(
297                 amount,
298                 "ERC20: transfer amount exceeds allowance"
299             )
300         );
301         return true;
302     }
303  
304     function tokenFromReflection(uint256 rAmount)
305         private
306         view
307         returns (uint256)
308     {
309         require(
310             rAmount <= _rTotal,
311             "Amount must be less than total reflections"
312         );
313         uint256 currentRate = _getRate();
314         return rAmount.div(currentRate);
315     }
316  
317     function removeAllFee() private {
318         if (_redisFee == 0 && _taxFee == 0) return;
319  
320         _previousredisFee = _redisFee;
321         _previoustaxFee = _taxFee;
322  
323         _redisFee = 0;
324         _taxFee = 0;
325     }
326  
327     function restoreAllFee() private {
328         _redisFee = _previousredisFee;
329         _taxFee = _previoustaxFee;
330     }
331  
332     function _approve(
333         address owner,
334         address spender,
335         uint256 amount
336     ) private {
337         require(owner != address(0), "ERC20: approve from the zero address");
338         require(spender != address(0), "ERC20: approve to the zero address");
339         _allowances[owner][spender] = amount;
340         emit Approval(owner, spender, amount);
341     }
342  
343     function _transfer(
344         address from,
345         address to,
346         uint256 amount
347     ) private {
348         require(from != address(0), "ERC20: transfer from the zero address");
349         require(to != address(0), "ERC20: transfer to the zero address");
350         require(amount > 0, "Transfer amount must be greater than zero");
351  
352         if (from != owner() && to != owner()) {
353  
354             //Trade start check
355             if (!tradingOpen) {
356                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
357             }
358  
359             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
360  
361             if(to != uniswapV2Pair) {
362                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
363             }
364  
365             uint256 contractTokenBalance = balanceOf(address(this));
366             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
367  
368             if(contractTokenBalance >= _maxTxAmount)
369             {
370                 contractTokenBalance = _maxTxAmount;
371             }
372  
373             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
374                 swapTokensForEth(contractTokenBalance);
375                 uint256 contractETHBalance = address(this).balance;
376                 if (contractETHBalance > 0) {
377                     sendETHToFee(address(this).balance);
378                 }
379             }
380         }
381  
382         bool takeFee = true;
383  
384         //Transfer Tokens
385         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
386             takeFee = false;
387         } else {
388  
389             //Set Fee for Buys
390             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
391                 _redisFee = _redisFeeOnBuy;
392                 _taxFee = _taxFeeOnBuy;
393             }
394  
395             //Set Fee for Sells
396             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
397                 _redisFee = _redisFeeOnSell;
398                 _taxFee = _taxFeeOnSell;
399             }
400  
401         }
402  
403         _tokenTransfer(from, to, amount, takeFee);
404     }
405  
406     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
407         address[] memory path = new address[](2);
408         path[0] = address(this);
409         path[1] = uniswapV2Router.WETH();
410         _approve(address(this), address(uniswapV2Router), tokenAmount);
411         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
412             tokenAmount,
413             0,
414             path,
415             address(this),
416             block.timestamp
417         );
418     }
419  
420     function sendETHToFee(uint256 amount) private {
421         _developmentAddress.transfer(amount.div(2));
422         _marketingAddress.transfer(amount.div(2));
423     }
424  
425     function setTrading(bool _tradingOpen) public onlyOwner {
426         tradingOpen = _tradingOpen;
427     }
428  
429     function manualswap() external {
430         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
431         uint256 contractBalance = balanceOf(address(this));
432         swapTokensForEth(contractBalance);
433     }
434  
435     function manualsend() external {
436         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
437         uint256 contractETHBalance = address(this).balance;
438         sendETHToFee(contractETHBalance);
439     }
440  
441     function _tokenTransfer(
442         address sender,
443         address recipient,
444         uint256 amount,
445         bool takeFee
446     ) private {
447         if (!takeFee) removeAllFee();
448         _transferStandard(sender, recipient, amount);
449         if (!takeFee) restoreAllFee();
450     }
451  
452     function _transferStandard(
453         address sender,
454         address recipient,
455         uint256 tAmount
456     ) private {
457         (
458             uint256 rAmount,
459             uint256 rTransferAmount,
460             uint256 rFee,
461             uint256 tTransferAmount,
462             uint256 tFee,
463             uint256 tTeam
464         ) = _getValues(tAmount);
465         _rOwned[sender] = _rOwned[sender].sub(rAmount);
466         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
467         _takeTeam(tTeam);
468         _reflectFee(rFee, tFee);
469         emit Transfer(sender, recipient, tTransferAmount);
470     }
471  
472     function _takeTeam(uint256 tTeam) private {
473         uint256 currentRate = _getRate();
474         uint256 rTeam = tTeam.mul(currentRate);
475         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
476     }
477  
478     function _reflectFee(uint256 rFee, uint256 tFee) private {
479         _rTotal = _rTotal.sub(rFee);
480         _tFeeTotal = _tFeeTotal.add(tFee);
481     }
482  
483     receive() external payable {}
484  
485     function _getValues(uint256 tAmount)
486         private
487         view
488         returns (
489             uint256,
490             uint256,
491             uint256,
492             uint256,
493             uint256,
494             uint256
495         )
496     {
497         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
498             _getTValues(tAmount, _redisFee, _taxFee);
499         uint256 currentRate = _getRate();
500         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
501             _getRValues(tAmount, tFee, tTeam, currentRate);
502  
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
522  
523         return (tTransferAmount, tFee, tTeam);
524     }
525  
526     function _getRValues(
527         uint256 tAmount,
528         uint256 tFee,
529         uint256 tTeam,
530         uint256 currentRate
531     )
532         private
533         pure
534         returns (
535             uint256,
536             uint256,
537             uint256
538         )
539     {
540         uint256 rAmount = tAmount.mul(currentRate);
541         uint256 rFee = tFee.mul(currentRate);
542         uint256 rTeam = tTeam.mul(currentRate);
543         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
544  
545         return (rAmount, rTransferAmount, rFee);
546     }
547  
548     function _getRate() private view returns (uint256) {
549         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
550  
551         return rSupply.div(tSupply);
552     }
553  
554     function _getCurrentSupply() private view returns (uint256, uint256) {
555         uint256 rSupply = _rTotal;
556         uint256 tSupply = _tTotal;
557         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
558  
559         return (rSupply, tSupply);
560     }
561  
562     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
563         _redisFeeOnBuy = redisFeeOnBuy;
564         _redisFeeOnSell = redisFeeOnSell;
565         _taxFeeOnBuy = taxFeeOnBuy;
566         _taxFeeOnSell = taxFeeOnSell;
567         totalFees = _redisFeeOnBuy + _redisFeeOnSell + _taxFeeOnBuy + _taxFeeOnSell;
568         require(totalFees <= 15, "Must keep fees at 15% or less");
569     }
570  
571     //Set minimum tokens required to swap.
572     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
573         _swapTokensAtAmount = swapTokensAtAmount;
574     }
575  
576     //Set minimum tokens required to swap.
577     function toggleSwap(bool _swapEnabled) public onlyOwner {
578         swapEnabled = _swapEnabled;
579     }
580  
581  
582     //Set max buy amount 
583     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
584         _maxTxAmount = maxTxAmount;
585     }
586 
587     //Set max wallet amount 
588     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
589         _maxWalletSize = maxWalletSize;
590     }
591 
592     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
593         for(uint256 i = 0; i < accounts.length; i++) {
594             _isExcludedFromFee[accounts[i]] = excluded;
595         }
596     }
597 }