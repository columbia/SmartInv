1 //https://t.me/DONERC20//
2 //presidentdonaldtrump.info//
3 //https://twitter.com/presidentdonerc//
4 pragma solidity ^0.8.9; 
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 }
11 
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14 
15     function balanceOf(address account) external view returns (uint256);
16 
17     function transfer(address recipient, uint256 amount) external returns (bool);
18 
19     function allowance(address owner, address spender) external view returns (uint256);
20 
21     function approve(address spender, uint256 amount) external returns (bool);
22 
23     function transferFrom(
24         address sender,
25         address recipient,
26         uint256 amount
27     ) external returns (bool);
28 
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(
31         address indexed owner,
32         address indexed spender,
33         uint256 value
34     );
35 }
36 
37 contract Ownable is Context {
38     address private _owner;
39     address private _previousOwner;
40     event OwnershipTransferred(
41         address indexed previousOwner,
42         address indexed newOwner
43     );
44 
45     constructor() {
46         address msgSender = _msgSender();
47         _owner = msgSender;
48         emit OwnershipTransferred(address(0), msgSender);
49     }
50 
51     function owner() public view returns (address) {
52         return _owner;
53     }
54 
55     modifier onlyOwner() {
56         require(_owner == _msgSender(), "Ownable: caller is not the owner");
57         _;
58     }
59 
60     function renounceOwnership() public virtual onlyOwner {
61         emit OwnershipTransferred(_owner, address(0));
62         _owner = address(0);
63     }
64 
65     function transferOwnership(address newOwner) public virtual onlyOwner {
66         require(newOwner != address(0), "Ownable: new owner is the zero address");
67         emit OwnershipTransferred(_owner, newOwner);
68         _owner = newOwner;
69     }
70 
71 }
72 
73 library SafeMath {
74     function add(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a + b;
76         require(c >= a, "SafeMath: addition overflow");
77         return c;
78     }
79 
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         return sub(a, b, "SafeMath: subtraction overflow");
82     }
83 
84     function sub(
85         uint256 a,
86         uint256 b,
87         string memory errorMessage
88     ) internal pure returns (uint256) {
89         require(b <= a, errorMessage);
90         uint256 c = a - b;
91         return c;
92     }
93 
94     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
95         if (a == 0) {
96             return 0;
97         }
98         uint256 c = a * b;
99         require(c / a == b, "SafeMath: multiplication overflow");
100         return c;
101     }
102 
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     function div(
108         uint256 a,
109         uint256 b,
110         string memory errorMessage
111     ) internal pure returns (uint256) {
112         require(b > 0, errorMessage);
113         uint256 c = a / b;
114         return c;
115     }
116 }
117 
118 interface IUniswapV2Factory {
119     function createPair(address tokenA, address tokenB)
120         external
121         returns (address pair);
122 }
123 
124 interface IUniswapV2Router02 {
125     function swapExactTokensForETHSupportingFeeOnTransferTokens(
126         uint256 amountIn,
127         uint256 amountOutMin,
128         address[] calldata path,
129         address to,
130         uint256 deadline
131     ) external;
132 
133     function factory() external pure returns (address);
134 
135     function WETH() external pure returns (address);
136 
137     function addLiquidityETH(
138         address token,
139         uint256 amountTokenDesired,
140         uint256 amountTokenMin,
141         uint256 amountETHMin,
142         address to,
143         uint256 deadline
144     )
145         external
146         payable
147         returns (
148             uint256 amountToken,
149             uint256 amountETH,
150             uint256 liquidity
151         );
152 }
153 
154 contract DON is Context, IERC20, Ownable {
155 
156     using SafeMath for uint256;
157 
158     string private constant _name = "President Donald Trump";
159     string private constant _symbol = "DON";
160     uint8 private constant _decimals = 9;
161 
162     mapping(address => uint256) private _rOwned;
163     mapping(address => uint256) private _tOwned;
164     mapping(address => mapping(address => uint256)) private _allowances;
165     mapping(address => bool) private _isExcludedFromFee;
166     uint256 private constant MAX = ~uint256(0);
167     uint256 private constant _tTotal = 1000000000000000 * 10**9;
168     uint256 private _rTotal = (MAX - (MAX % _tTotal));
169     uint256 private _tFeeTotal;
170     uint256 private _redisFeeOnBuy = 0;
171     uint256 private _taxFeeOnBuy = 0;
172     uint256 private _redisFeeOnSell = 0;
173     uint256 private _taxFeeOnSell = 0;
174 
175     //Original Fee
176     uint256 private _redisFee = _redisFeeOnSell;
177     uint256 private _taxFee = _taxFeeOnSell;
178 
179     uint256 private _previousredisFee = _redisFee;
180     uint256 private _previoustaxFee = _taxFee;
181 
182     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
183     address payable private _developmentAddress = payable(0x226c9789Ef08ED999484ED642172CbB296E93871);
184     address payable private _marketingAddress = payable(0x226c9789Ef08ED999484ED642172CbB296E93871);
185 
186     IUniswapV2Router02 public uniswapV2Router;
187     address public uniswapV2Pair;
188 
189     bool private tradingOpen = true;
190     bool private inSwap = false;
191     bool private swapEnabled = true;
192 
193     uint256 public _maxTxAmount = _tTotal.div(100).mul(2);
194     uint256 public _maxWalletSize = _tTotal.div(100).mul(3);
195     uint256 public _swapTokensAtAmount = _tTotal.div(1000);
196     uint256 public _maxContractSell = _tTotal.div(1000).mul(3);
197 
198     event MaxTxAmountUpdated(uint256 _maxTxAmount);
199     modifier lockTheSwap {
200         inSwap = true;
201         _;
202         inSwap = false;
203     }
204 
205     constructor() {
206 
207         _rOwned[_msgSender()] = _rTotal;
208 
209         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
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
314     function changeMaxContractSell(uint256 amount) public onlyOwner {
315         _maxContractSell = amount * 10 ** 9;
316     }
317 
318     function _approve(
319         address owner,
320         address spender,
321         uint256 amount
322     ) private {
323         require(owner != address(0), "ERC20: approve from the zero address");
324         require(spender != address(0), "ERC20: approve to the zero address");
325         _allowances[owner][spender] = amount;
326         emit Approval(owner, spender, amount);
327     }
328 
329     function _transfer(
330         address from,
331         address to,
332         uint256 amount
333     ) private {
334         require(from != address(0), "ERC20: transfer from the zero address");
335         require(to != address(0), "ERC20: transfer to the zero address");
336         require(amount > 0, "Transfer amount must be greater than zero");
337 
338         if (from != owner() && to != owner()) {
339 
340             //Trade start check
341             if (!tradingOpen) {
342                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
343             }
344 
345             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
346             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
347 
348             if(to != uniswapV2Pair) {
349                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
350             }
351 
352             uint256 contractTokenBalance = balanceOf(address(this));
353             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
354 
355             if(contractTokenBalance >= _maxContractSell)
356             {
357                 contractTokenBalance = _maxContractSell;
358             }
359 
360             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
361                 swapTokensForEth(contractTokenBalance);
362                 uint256 contractETHBalance = address(this).balance;
363                 if (contractETHBalance > 0) {
364                     sendETHToFee(address(this).balance);
365                 }
366             }
367         }
368 
369         bool takeFee = true;
370 
371         //Transfer Tokens
372         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
373             takeFee = false;
374         } else {
375 
376             //Set Fee for Buys
377             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
378                 _redisFee = _redisFeeOnBuy;
379                 _taxFee = _taxFeeOnBuy;
380             }
381 
382             //Set Fee for Sells
383             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
384                 _redisFee = _redisFeeOnSell;
385                 _taxFee = _taxFeeOnSell;
386             }
387 
388         }
389 
390         _tokenTransfer(from, to, amount, takeFee);
391     }
392 
393     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
394         address[] memory path = new address[](2);
395         path[0] = address(this);
396         path[1] = uniswapV2Router.WETH();
397         _approve(address(this), address(uniswapV2Router), tokenAmount);
398         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
399             tokenAmount,
400             0,
401             path,
402             address(this),
403             block.timestamp
404         );
405     }
406 
407     function sendETHToFee(uint256 amount) private {
408         _marketingAddress.transfer(amount);
409     }
410 
411     function setTrading(bool _tradingOpen) public onlyOwner {
412         tradingOpen = _tradingOpen;
413     }
414 
415     function manualswap() external {
416         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
417         uint256 contractBalance = balanceOf(address(this));
418         swapTokensForEth(contractBalance);
419     }
420 
421     function manualsend() external {
422         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
423         uint256 contractETHBalance = address(this).balance;
424         sendETHToFee(contractETHBalance);
425     }
426 
427     function blockBots(address[] memory bots_) public onlyOwner {
428         for (uint256 i = 0; i < bots_.length; i++) {
429             bots[bots_[i]] = true;
430         }
431     }
432 
433     function unblockBot(address notbot) public onlyOwner {
434         bots[notbot] = false;
435     }
436 
437     function _tokenTransfer(
438         address sender,
439         address recipient,
440         uint256 amount,
441         bool takeFee
442     ) private {
443         if (!takeFee) removeAllFee();
444         _transferStandard(sender, recipient, amount);
445         if (!takeFee) restoreAllFee();
446     }
447 
448     function _transferStandard(
449         address sender,
450         address recipient,
451         uint256 tAmount
452     ) private {
453         (
454             uint256 rAmount,
455             uint256 rTransferAmount,
456             uint256 rFee,
457             uint256 tTransferAmount,
458             uint256 tFee,
459             uint256 tTeam
460         ) = _getValues(tAmount);
461         _rOwned[sender] = _rOwned[sender].sub(rAmount);
462         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
463         _takeTeam(tTeam);
464         _reflectFee(rFee, tFee);
465         emit Transfer(sender, recipient, tTransferAmount);
466     }
467 
468     function _takeTeam(uint256 tTeam) private {
469         uint256 currentRate = _getRate();
470         uint256 rTeam = tTeam.mul(currentRate);
471         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
472     }
473 
474     function _reflectFee(uint256 rFee, uint256 tFee) private {
475         _rTotal = _rTotal.sub(rFee);
476         _tFeeTotal = _tFeeTotal.add(tFee);
477     }
478 
479     receive() external payable {}
480 
481     function _getValues(uint256 tAmount)
482         private
483         view
484         returns (
485             uint256,
486             uint256,
487             uint256,
488             uint256,
489             uint256,
490             uint256
491         )
492     {
493         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
494             _getTValues(tAmount, _redisFee, _taxFee);
495         uint256 currentRate = _getRate();
496         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
497             _getRValues(tAmount, tFee, tTeam, currentRate);
498         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
499     }
500 
501     function _getTValues(
502         uint256 tAmount,
503         uint256 redisFee,
504         uint256 taxFee
505     )
506         private
507         pure
508         returns (
509             uint256,
510             uint256,
511             uint256
512         )
513     {
514         uint256 tFee = tAmount.mul(redisFee).div(100);
515         uint256 tTeam = tAmount.mul(taxFee).div(100);
516         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
517         return (tTransferAmount, tFee, tTeam);
518     }
519 
520     function _getRValues(
521         uint256 tAmount,
522         uint256 tFee,
523         uint256 tTeam,
524         uint256 currentRate
525     )
526         private
527         pure
528         returns (
529             uint256,
530             uint256,
531             uint256
532         )
533     {
534         uint256 rAmount = tAmount.mul(currentRate);
535         uint256 rFee = tFee.mul(currentRate);
536         uint256 rTeam = tTeam.mul(currentRate);
537         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
538         return (rAmount, rTransferAmount, rFee);
539     }
540 
541     function _getRate() private view returns (uint256) {
542         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
543         return rSupply.div(tSupply);
544     }
545 
546     function _getCurrentSupply() private view returns (uint256, uint256) {
547         uint256 rSupply = _rTotal;
548         uint256 tSupply = _tTotal;
549         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
550         return (rSupply, tSupply);
551     }
552 
553     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
554         _redisFeeOnBuy = redisFeeOnBuy;
555         _redisFeeOnSell = redisFeeOnSell;
556         _taxFeeOnBuy = taxFeeOnBuy;
557         _taxFeeOnSell = taxFeeOnSell;
558     }
559 
560     //Set minimum tokens required to swap.
561     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
562         _swapTokensAtAmount = swapTokensAtAmount;
563     }
564 
565     //Set minimum tokens required to swap.
566     function toggleSwap(bool _swapEnabled) public onlyOwner {
567         swapEnabled = _swapEnabled;
568     }
569 
570     //Set maximum transaction
571     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
572         _maxTxAmount = maxTxAmount;
573     }
574 
575     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
576         _maxWalletSize = maxWalletSize;
577     }
578 
579     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
580         for(uint256 i = 0; i < accounts.length; i++) {
581             _isExcludedFromFee[accounts[i]] = excluded;
582         }
583     }
584 
585 }