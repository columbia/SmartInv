1 //https://t.me/PepeShibaTG
2 
3 // pragma solidity ^0.8.9; 
4 
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
153 contract PEPESHIBA is Context, IERC20, Ownable {
154 
155     using SafeMath for uint256;
156 
157     string private constant _name = "Pepe Shiba";
158     string private constant _symbol = "PEPESHIBA";
159     uint8 private constant _decimals = 9;
160 
161     mapping(address => uint256) private _rOwned;
162     mapping(address => uint256) private _tOwned;
163     mapping(address => mapping(address => uint256)) private _allowances;
164     mapping(address => bool) private _isExcludedFromFee;
165     uint256 private constant MAX = ~uint256(0);
166     uint256 private constant _tTotal = 1000000000000 * 10**9;
167     uint256 private _rTotal = (MAX - (MAX % _tTotal));
168     uint256 private _tFeeTotal;
169     uint256 private _redisFeeOnBuy = 0;
170     uint256 private _taxFeeOnBuy = 25;
171     uint256 private _redisFeeOnSell = 0;
172     uint256 private _taxFeeOnSell = 50;
173 
174     //Original Fee
175     uint256 private _redisFee = _redisFeeOnSell;
176     uint256 private _taxFee = _taxFeeOnSell;
177 
178     uint256 private _previousredisFee = _redisFee;
179     uint256 private _previoustaxFee = _taxFee;
180 
181     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
182     address payable private _developmentAddress = payable(0x24715fAF3871821C7AD46D55bE8F723d23A82D7B);
183     address payable private _marketingAddress = payable(0x24715fAF3871821C7AD46D55bE8F723d23A82D7B);
184 
185     IUniswapV2Router02 public uniswapV2Router;
186     address public uniswapV2Pair;
187 
188     bool private tradingOpen = true;
189     bool private inSwap = false;
190     bool private swapEnabled = true;
191 
192     uint256 public _maxTxAmount = 20000000000 * 10**9;
193     uint256 public _maxWalletSize = 30000000000 * 10**9;
194     uint256 public _swapTokensAtAmount = 1000000000 * 10**9;
195 
196     event MaxTxAmountUpdated(uint256 _maxTxAmount);
197     modifier lockTheSwap {
198         inSwap = true;
199         _;
200         inSwap = false;
201     }
202 
203     constructor() {
204 
205         _rOwned[_msgSender()] = _rTotal;
206 
207         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
208         uniswapV2Router = _uniswapV2Router;
209         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
210             .createPair(address(this), _uniswapV2Router.WETH());
211 
212         _isExcludedFromFee[owner()] = true;
213         _isExcludedFromFee[address(this)] = true;
214         _isExcludedFromFee[_developmentAddress] = true;
215         _isExcludedFromFee[_marketingAddress] = true;
216 
217         emit Transfer(address(0), _msgSender(), _tTotal);
218     }
219 
220     function name() public pure returns (string memory) {
221         return _name;
222     }
223 
224     function symbol() public pure returns (string memory) {
225         return _symbol;
226     }
227 
228     function decimals() public pure returns (uint8) {
229         return _decimals;
230     }
231 
232     function totalSupply() public pure override returns (uint256) {
233         return _tTotal;
234     }
235 
236     function balanceOf(address account) public view override returns (uint256) {
237         return tokenFromReflection(_rOwned[account]);
238     }
239 
240     function transfer(address recipient, uint256 amount)
241         public
242         override
243         returns (bool)
244     {
245         _transfer(_msgSender(), recipient, amount);
246         return true;
247     }
248 
249     function allowance(address owner, address spender)
250         public
251         view
252         override
253         returns (uint256)
254     {
255         return _allowances[owner][spender];
256     }
257 
258     function approve(address spender, uint256 amount)
259         public
260         override
261         returns (bool)
262     {
263         _approve(_msgSender(), spender, amount);
264         return true;
265     }
266 
267     function transferFrom(
268         address sender,
269         address recipient,
270         uint256 amount
271     ) public override returns (bool) {
272         _transfer(sender, recipient, amount);
273         _approve(
274             sender,
275             _msgSender(),
276             _allowances[sender][_msgSender()].sub(
277                 amount,
278                 "ERC20: transfer amount exceeds allowance"
279             )
280         );
281         return true;
282     }
283 
284     function tokenFromReflection(uint256 rAmount)
285         private
286         view
287         returns (uint256)
288     {
289         require(
290             rAmount <= _rTotal,
291             "Amount must be less than total reflections"
292         );
293         uint256 currentRate = _getRate();
294         return rAmount.div(currentRate);
295     }
296 
297     function removeAllFee() private {
298         if (_redisFee == 0 && _taxFee == 0) return;
299 
300         _previousredisFee = _redisFee;
301         _previoustaxFee = _taxFee;
302 
303         _redisFee = 0;
304         _taxFee = 0;
305     }
306 
307     function restoreAllFee() private {
308         _redisFee = _previousredisFee;
309         _taxFee = _previoustaxFee;
310     }
311 
312     function _approve(
313         address owner,
314         address spender,
315         uint256 amount
316     ) private {
317         require(owner != address(0), "ERC20: approve from the zero address");
318         require(spender != address(0), "ERC20: approve to the zero address");
319         _allowances[owner][spender] = amount;
320         emit Approval(owner, spender, amount);
321     }
322 
323     function _transfer(
324         address from,
325         address to,
326         uint256 amount
327     ) private {
328         require(from != address(0), "ERC20: transfer from the zero address");
329         require(to != address(0), "ERC20: transfer to the zero address");
330         require(amount > 0, "Transfer amount must be greater than zero");
331 
332         if (from != owner() && to != owner()) {
333 
334             //Trade start check
335             if (!tradingOpen) {
336                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
337             }
338 
339             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
340             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
341 
342             if(to != uniswapV2Pair) {
343                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
344             }
345 
346             uint256 contractTokenBalance = balanceOf(address(this));
347             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
348 
349             if(contractTokenBalance >= _maxTxAmount)
350             {
351                 contractTokenBalance = _maxTxAmount;
352             }
353 
354             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
355                 swapTokensForEth(contractTokenBalance);
356                 uint256 contractETHBalance = address(this).balance;
357                 if (contractETHBalance > 0) {
358                     sendETHToFee(address(this).balance);
359                 }
360             }
361         }
362 
363         bool takeFee = true;
364 
365         //Transfer Tokens
366         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
367             takeFee = false;
368         } else {
369 
370             //Set Fee for Buys
371             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
372                 _redisFee = _redisFeeOnBuy;
373                 _taxFee = _taxFeeOnBuy;
374             }
375 
376             //Set Fee for Sells
377             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
378                 _redisFee = _redisFeeOnSell;
379                 _taxFee = _taxFeeOnSell;
380             }
381 
382         }
383 
384         _tokenTransfer(from, to, amount, takeFee);
385     }
386 
387     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
388         address[] memory path = new address[](2);
389         path[0] = address(this);
390         path[1] = uniswapV2Router.WETH();
391         _approve(address(this), address(uniswapV2Router), tokenAmount);
392         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
393             tokenAmount,
394             0,
395             path,
396             address(this),
397             block.timestamp
398         );
399     }
400 
401     function sendETHToFee(uint256 amount) private {
402         _marketingAddress.transfer(amount);
403     }
404 
405     function setTrading(bool _tradingOpen) public onlyOwner {
406         tradingOpen = _tradingOpen;
407     }
408 
409     function manualswap() external {
410         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
411         uint256 contractBalance = balanceOf(address(this));
412         swapTokensForEth(contractBalance);
413     }
414 
415     function manualsend() external {
416         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
417         uint256 contractETHBalance = address(this).balance;
418         sendETHToFee(contractETHBalance);
419     }
420 
421     function blockBots(address[] memory bots_) public onlyOwner {
422         for (uint256 i = 0; i < bots_.length; i++) {
423             bots[bots_[i]] = true;
424         }
425     }
426 
427     function unblockBot(address notbot) public onlyOwner {
428         bots[notbot] = false;
429     }
430 
431     function _tokenTransfer(
432         address sender,
433         address recipient,
434         uint256 amount,
435         bool takeFee
436     ) private {
437         if (!takeFee) removeAllFee();
438         _transferStandard(sender, recipient, amount);
439         if (!takeFee) restoreAllFee();
440     }
441 
442     function _transferStandard(
443         address sender,
444         address recipient,
445         uint256 tAmount
446     ) private {
447         (
448             uint256 rAmount,
449             uint256 rTransferAmount,
450             uint256 rFee,
451             uint256 tTransferAmount,
452             uint256 tFee,
453             uint256 tTeam
454         ) = _getValues(tAmount);
455         _rOwned[sender] = _rOwned[sender].sub(rAmount);
456         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
457         _takeTeam(tTeam);
458         _reflectFee(rFee, tFee);
459         emit Transfer(sender, recipient, tTransferAmount);
460     }
461 
462     function _takeTeam(uint256 tTeam) private {
463         uint256 currentRate = _getRate();
464         uint256 rTeam = tTeam.mul(currentRate);
465         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
466     }
467 
468     function _reflectFee(uint256 rFee, uint256 tFee) private {
469         _rTotal = _rTotal.sub(rFee);
470         _tFeeTotal = _tFeeTotal.add(tFee);
471     }
472 
473     receive() external payable {}
474 
475     function _getValues(uint256 tAmount)
476         private
477         view
478         returns (
479             uint256,
480             uint256,
481             uint256,
482             uint256,
483             uint256,
484             uint256
485         )
486     {
487         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
488             _getTValues(tAmount, _redisFee, _taxFee);
489         uint256 currentRate = _getRate();
490         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
491             _getRValues(tAmount, tFee, tTeam, currentRate);
492         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
493     }
494 
495     function _getTValues(
496         uint256 tAmount,
497         uint256 redisFee,
498         uint256 taxFee
499     )
500         private
501         pure
502         returns (
503             uint256,
504             uint256,
505             uint256
506         )
507     {
508         uint256 tFee = tAmount.mul(redisFee).div(100);
509         uint256 tTeam = tAmount.mul(taxFee).div(100);
510         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
511         return (tTransferAmount, tFee, tTeam);
512     }
513 
514     function _getRValues(
515         uint256 tAmount,
516         uint256 tFee,
517         uint256 tTeam,
518         uint256 currentRate
519     )
520         private
521         pure
522         returns (
523             uint256,
524             uint256,
525             uint256
526         )
527     {
528         uint256 rAmount = tAmount.mul(currentRate);
529         uint256 rFee = tFee.mul(currentRate);
530         uint256 rTeam = tTeam.mul(currentRate);
531         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
532         return (rAmount, rTransferAmount, rFee);
533     }
534 
535     function _getRate() private view returns (uint256) {
536         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
537         return rSupply.div(tSupply);
538     }
539 
540     function _getCurrentSupply() private view returns (uint256, uint256) {
541         uint256 rSupply = _rTotal;
542         uint256 tSupply = _tTotal;
543         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
544         return (rSupply, tSupply);
545     }
546 
547     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
548         _redisFeeOnBuy = redisFeeOnBuy;
549         _redisFeeOnSell = redisFeeOnSell;
550         _taxFeeOnBuy = taxFeeOnBuy;
551         _taxFeeOnSell = taxFeeOnSell;
552     }
553 
554     //Set minimum tokens required to swap.
555     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
556         _swapTokensAtAmount = swapTokensAtAmount;
557     }
558 
559     //Set minimum tokens required to swap.
560     function toggleSwap(bool _swapEnabled) public onlyOwner {
561         swapEnabled = _swapEnabled;
562     }
563 
564     //Set maximum transaction
565     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
566         _maxTxAmount = maxTxAmount;
567     }
568 
569     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
570         _maxWalletSize = maxWalletSize;
571     }
572 
573     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
574         for(uint256 i = 0; i < accounts.length; i++) {
575             _isExcludedFromFee[accounts[i]] = excluded;
576         }
577     }
578 
579 }