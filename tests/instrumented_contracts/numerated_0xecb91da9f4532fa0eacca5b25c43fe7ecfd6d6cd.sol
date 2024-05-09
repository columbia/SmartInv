1 // SPDX-License-Identifier: Unlicensed
2 
3 // Telegram - https://t.me/UniToolsERC
4 
5 // Sniper Bot - https://t.me/UniToolsSniperBot
6 
7 // Website - https://unitoolserc.com
8 
9 // Twitter - https://x.com/UniToolsERC
10 
11 
12 pragma solidity 0.8.19;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 }
19 
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22 
23     function balanceOf(address account) external view returns (uint256);
24 
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     function allowance(address owner, address spender) external view returns (uint256);
28 
29     function approve(address spender, uint256 amount) external returns (bool);
30 
31     function transferFrom(
32         address sender,
33         address recipient,
34         uint256 amount
35     ) external returns (bool);
36 
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(
39         address indexed owner,
40         address indexed spender,
41         uint256 value
42     );
43 }
44 
45 contract Ownable is Context {
46     address private _owner;
47     address private _previousOwner;
48     event OwnershipTransferred(
49         address indexed previousOwner,
50         address indexed newOwner
51     );
52 
53     constructor() {
54         address msgSender = _msgSender();
55         _owner = msgSender;
56         emit OwnershipTransferred(address(0), msgSender);
57     }
58 
59     function owner() public view returns (address) {
60         return _owner;
61     }
62 
63     modifier onlyOwner() {
64         require(_owner == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     function renounceOwnership() public virtual onlyOwner {
69         emit OwnershipTransferred(_owner, address(0));
70         _owner = address(0);
71     }
72 
73     function transferOwnership(address newOwner) public virtual onlyOwner {
74         require(newOwner != address(0), "Ownable: new owner is the zero address");
75         emit OwnershipTransferred(_owner, newOwner);
76         _owner = newOwner;
77     }
78 
79 }
80 
81 library SafeMath {
82     function add(uint256 a, uint256 b) internal pure returns (uint256) {
83         uint256 c = a + b;
84         require(c >= a, "SafeMath: addition overflow");
85         return c;
86     }
87 
88     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89         return sub(a, b, "SafeMath: subtraction overflow");
90     }
91 
92     function sub(
93         uint256 a,
94         uint256 b,
95         string memory errorMessage
96     ) internal pure returns (uint256) {
97         require(b <= a, errorMessage);
98         uint256 c = a - b;
99         return c;
100     }
101 
102     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103         if (a == 0) {
104             return 0;
105         }
106         uint256 c = a * b;
107         require(c / a == b, "SafeMath: multiplication overflow");
108         return c;
109     }
110 
111     function div(uint256 a, uint256 b) internal pure returns (uint256) {
112         return div(a, b, "SafeMath: division by zero");
113     }
114 
115     function div(
116         uint256 a,
117         uint256 b,
118         string memory errorMessage
119     ) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         return c;
123     }
124 }
125 
126 interface IUniswapV2Factory {
127     function createPair(address tokenA, address tokenB)
128         external
129         returns (address pair);
130 }
131 
132 interface IUniswapV2Router02 {
133     function swapExactTokensForETHSupportingFeeOnTransferTokens(
134         uint256 amountIn,
135         uint256 amountOutMin,
136         address[] calldata path,
137         address to,
138         uint256 deadline
139     ) external;
140 
141     function factory() external pure returns (address);
142 
143     function WETH() external pure returns (address);
144 
145     function addLiquidityETH(
146         address token,
147         uint256 amountTokenDesired,
148         uint256 amountTokenMin,
149         uint256 amountETHMin,
150         address to,
151         uint256 deadline
152     )
153         external
154         payable
155         returns (
156             uint256 amountToken,
157             uint256 amountETH,
158             uint256 liquidity
159         );
160 }
161 
162 contract UniTools is Context, IERC20, Ownable {
163 
164     using SafeMath for uint256;
165 
166     string private constant _name = "UniTools";
167     string private constant _symbol = "UNIT";
168     uint8 private constant _decimals = 9;
169 
170     mapping(address => uint256) private _rOwned;
171     mapping(address => uint256) private _tOwned;
172     mapping(address => mapping(address => uint256)) private _allowances;
173     mapping(address => bool) private _isExcludedFromFee;
174     uint256 private constant MAX = ~uint256(0);
175     uint256 private constant _tTotal = 100000000 * 10**9;
176     uint256 private _rTotal = (MAX - (MAX % _tTotal));
177     uint256 private _tFeeTotal;
178     uint256 private _redisFeeOnBuy = 0;
179     uint256 private _taxFeeOnBuy = 10;
180     uint256 private _redisFeeOnSell = 0;
181     uint256 private _taxFeeOnSell = 20;
182 
183     //Original Fee
184     uint256 private _redisFee = _redisFeeOnSell;
185     uint256 private _taxFee = _taxFeeOnSell;
186 
187     uint256 private _previousredisFee = _redisFee;
188     uint256 private _previoustaxFee = _taxFee;
189 
190     mapping (address => uint256) public _buyMap;
191     address payable private _developmentAddress = payable(0x438070ac1DDF00484C25D8A2Dd537A5E00e6F6a7);
192     address payable private _marketingAddress = payable(0x438070ac1DDF00484C25D8A2Dd537A5E00e6F6a7);
193 
194 
195     IUniswapV2Router02 public uniswapV2Router;
196     address public uniswapV2Pair;
197 
198     bool private tradingOpen = true;
199     bool private inSwap = false;
200     bool private swapEnabled = true;
201 
202     uint256 public _maxTxAmount = 3000000 * 10**9;
203     uint256 public _maxWalletSize = 3000000 * 10**9;
204     uint256 public _swapTokensAtAmount = 800000 * 10**9;
205 
206     event MaxTxAmountUpdated(uint256 _maxTxAmount);
207     modifier lockTheSwap {
208         inSwap = true;
209         _;
210         inSwap = false;
211     }
212 
213     constructor() {
214 
215         _rOwned[_msgSender()] = _rTotal;
216 
217         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
218         uniswapV2Router = _uniswapV2Router;
219         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
220             .createPair(address(this), _uniswapV2Router.WETH());
221 
222         _isExcludedFromFee[owner()] = true;
223         _isExcludedFromFee[address(this)] = true;
224         _isExcludedFromFee[_developmentAddress] = true;
225         _isExcludedFromFee[_marketingAddress] = true;
226 
227         emit Transfer(address(0), _msgSender(), _tTotal);
228     }
229 
230     function name() public pure returns (string memory) {
231         return _name;
232     }
233 
234     function symbol() public pure returns (string memory) {
235         return _symbol;
236     }
237 
238     function decimals() public pure returns (uint8) {
239         return _decimals;
240     }
241 
242     function totalSupply() public pure override returns (uint256) {
243         return _tTotal;
244     }
245 
246     function balanceOf(address account) public view override returns (uint256) {
247         return tokenFromReflection(_rOwned[account]);
248     }
249 
250     function transfer(address recipient, uint256 amount)
251         public
252         override
253         returns (bool)
254     {
255         _transfer(_msgSender(), recipient, amount);
256         return true;
257     }
258 
259     function allowance(address owner, address spender)
260         public
261         view
262         override
263         returns (uint256)
264     {
265         return _allowances[owner][spender];
266     }
267 
268     function approve(address spender, uint256 amount)
269         public
270         override
271         returns (bool)
272     {
273         _approve(_msgSender(), spender, amount);
274         return true;
275     }
276 
277     function transferFrom(
278         address sender,
279         address recipient,
280         uint256 amount
281     ) public override returns (bool) {
282         _transfer(sender, recipient, amount);
283         _approve(
284             sender,
285             _msgSender(),
286             _allowances[sender][_msgSender()].sub(
287                 amount,
288                 "ERC20: transfer amount exceeds allowance"
289             )
290         );
291         return true;
292     }
293 
294     function tokenFromReflection(uint256 rAmount)
295         private
296         view
297         returns (uint256)
298     {
299         require(
300             rAmount <= _rTotal,
301             "Amount must be less than total reflections"
302         );
303         uint256 currentRate = _getRate();
304         return rAmount.div(currentRate);
305     }
306 
307     function removeAllFee() private {
308         if (_redisFee == 0 && _taxFee == 0) return;
309 
310         _previousredisFee = _redisFee;
311         _previoustaxFee = _taxFee;
312 
313         _redisFee = 0;
314         _taxFee = 0;
315     }
316 
317     function restoreAllFee() private {
318         _redisFee = _previousredisFee;
319         _taxFee = _previoustaxFee;
320     }
321 
322     function _approve(
323         address owner,
324         address spender,
325         uint256 amount
326     ) private {
327         require(owner != address(0), "ERC20: approve from the zero address");
328         require(spender != address(0), "ERC20: approve to the zero address");
329         _allowances[owner][spender] = amount;
330         emit Approval(owner, spender, amount);
331     }
332 
333     function _transfer(
334         address from,
335         address to,
336         uint256 amount
337     ) private {
338         require(from != address(0), "ERC20: transfer from the zero address");
339         require(to != address(0), "ERC20: transfer to the zero address");
340         require(amount > 0, "Transfer amount must be greater than zero");
341 
342         if (from != owner() && to != owner()) {
343 
344             //Trade start check
345             if (!tradingOpen) {
346                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
347             }
348 
349             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
350 
351             if(to != uniswapV2Pair) {
352                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
353             }
354 
355             uint256 contractTokenBalance = balanceOf(address(this));
356             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
357 
358             if(contractTokenBalance >= _maxTxAmount)
359             {
360                 contractTokenBalance = _maxTxAmount;
361             }
362 
363             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
364                 swapTokensForEth(contractTokenBalance);
365                 uint256 contractETHBalance = address(this).balance;
366                 if (contractETHBalance > 0) {
367                     sendETHToFee(address(this).balance);
368                 }
369             }
370         }
371 
372         bool takeFee = true;
373 
374         //Transfer Tokens
375         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
376             takeFee = false;
377         } else {
378 
379             //Set Fee for Buys
380             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
381                 _redisFee = _redisFeeOnBuy;
382                 _taxFee = _taxFeeOnBuy;
383             }
384 
385             //Set Fee for Sells
386             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
387                 _redisFee = _redisFeeOnSell;
388                 _taxFee = _taxFeeOnSell;
389             }
390 
391         }
392 
393         _tokenTransfer(from, to, amount, takeFee);
394     }
395 
396     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
397         address[] memory path = new address[](2);
398         path[0] = address(this);
399         path[1] = uniswapV2Router.WETH();
400         _approve(address(this), address(uniswapV2Router), tokenAmount);
401         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
402             tokenAmount,
403             0,
404             path,
405             address(this),
406             block.timestamp
407         );
408     }
409 
410     function sendETHToFee(uint256 amount) private {
411         _marketingAddress.transfer(amount);
412     }
413 
414     function setTrading(bool _tradingOpen) public onlyOwner {
415         tradingOpen = _tradingOpen;
416     }
417 
418     function manualswap() external {
419         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
420         uint256 contractBalance = balanceOf(address(this));
421         swapTokensForEth(contractBalance);
422     }
423 
424     function manualsend() external {
425         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
426         uint256 contractETHBalance = address(this).balance;
427         sendETHToFee(contractETHBalance);
428     }
429 
430     function _tokenTransfer(
431         address sender,
432         address recipient,
433         uint256 amount,
434         bool takeFee
435     ) private {
436         if (!takeFee) removeAllFee();
437         _transferStandard(sender, recipient, amount);
438         if (!takeFee) restoreAllFee();
439     }
440 
441     function _transferStandard(
442         address sender,
443         address recipient,
444         uint256 tAmount
445     ) private {
446         (
447             uint256 rAmount,
448             uint256 rTransferAmount,
449             uint256 rFee,
450             uint256 tTransferAmount,
451             uint256 tFee,
452             uint256 tTeam
453         ) = _getValues(tAmount);
454         _rOwned[sender] = _rOwned[sender].sub(rAmount);
455         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
456         _takeTeam(tTeam);
457         _reflectFee(rFee, tFee);
458         emit Transfer(sender, recipient, tTransferAmount);
459     }
460 
461     function _takeTeam(uint256 tTeam) private {
462         uint256 currentRate = _getRate();
463         uint256 rTeam = tTeam.mul(currentRate);
464         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
465     }
466 
467     function _reflectFee(uint256 rFee, uint256 tFee) private {
468         _rTotal = _rTotal.sub(rFee);
469         _tFeeTotal = _tFeeTotal.add(tFee);
470     }
471 
472     receive() external payable {}
473 
474     function _getValues(uint256 tAmount)
475         private
476         view
477         returns (
478             uint256,
479             uint256,
480             uint256,
481             uint256,
482             uint256,
483             uint256
484         )
485     {
486         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
487             _getTValues(tAmount, _redisFee, _taxFee);
488         uint256 currentRate = _getRate();
489         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
490             _getRValues(tAmount, tFee, tTeam, currentRate);
491         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
492     }
493 
494     function _getTValues(
495         uint256 tAmount,
496         uint256 redisFee,
497         uint256 taxFee
498     )
499         private
500         pure
501         returns (
502             uint256,
503             uint256,
504             uint256
505         )
506     {
507         uint256 tFee = tAmount.mul(redisFee).div(100);
508         uint256 tTeam = tAmount.mul(taxFee).div(100);
509         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
510         return (tTransferAmount, tFee, tTeam);
511     }
512 
513     function _getRValues(
514         uint256 tAmount,
515         uint256 tFee,
516         uint256 tTeam,
517         uint256 currentRate
518     )
519         private
520         pure
521         returns (
522             uint256,
523             uint256,
524             uint256
525         )
526     {
527         uint256 rAmount = tAmount.mul(currentRate);
528         uint256 rFee = tFee.mul(currentRate);
529         uint256 rTeam = tTeam.mul(currentRate);
530         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
531         return (rAmount, rTransferAmount, rFee);
532     }
533 
534     function _getRate() private view returns (uint256) {
535         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
536         return rSupply.div(tSupply);
537     }
538 
539     function _getCurrentSupply() private view returns (uint256, uint256) {
540         uint256 rSupply = _rTotal;
541         uint256 tSupply = _tTotal;
542         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
543         return (rSupply, tSupply);
544     }
545 
546     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
547         _redisFeeOnBuy = redisFeeOnBuy;
548         _redisFeeOnSell = redisFeeOnSell;
549         _taxFeeOnBuy = taxFeeOnBuy;
550         _taxFeeOnSell = taxFeeOnSell;
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
563     //Set maximum transaction
564     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
565         _maxTxAmount = maxTxAmount;
566     }
567 
568     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
569         _maxWalletSize = maxWalletSize;
570     }
571 
572     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
573         for(uint256 i = 0; i < accounts.length; i++) {
574             _isExcludedFromFee[accounts[i]] = excluded;
575         }
576     }
577 
578 }