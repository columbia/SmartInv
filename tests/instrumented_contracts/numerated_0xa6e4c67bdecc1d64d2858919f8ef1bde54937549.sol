1 /**
2 Old Bitcoin (OB)
3 
4 Supply: 1,000,000 OB
5 
6 Tax: 0 Tax (Final)
7 
8 CA: Renounced (Final)
9 
10 t.me/oldbitcoinob
11 
12 twitter.com/oldbitcoinob
13 
14 */
15 // SPDX-License-Identifier: Unlicensed
16 pragma solidity ^0.8.9;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 }
23 
24 interface IERC20 {
25     function totalSupply() external view returns (uint256);
26 
27     function balanceOf(address account) external view returns (uint256);
28 
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     function allowance(address owner, address spender) external view returns (uint256);
32 
33     function approve(address spender, uint256 amount) external returns (bool);
34 
35     function transferFrom(
36         address sender,
37         address recipient,
38         uint256 amount
39     ) external returns (bool);
40 
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event Approval(
43         address indexed owner,
44         address indexed spender,
45         uint256 value
46     );
47 }
48 
49 contract Ownable is Context {
50     address private _owner;
51     address private _previousOwner;
52     event OwnershipTransferred(
53         address indexed previousOwner,
54         address indexed newOwner
55     );
56 
57     constructor() {
58         address msgSender = _msgSender();
59         _owner = msgSender;
60         emit OwnershipTransferred(address(0), msgSender);
61     }
62 
63     function owner() public view returns (address) {
64         return _owner;
65     }
66 
67     modifier onlyOwner() {
68         require(_owner == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     function renounceOwnership() public virtual onlyOwner {
73         emit OwnershipTransferred(_owner, address(0));
74         _owner = address(0);
75     }
76 
77     function transferOwnership(address newOwner) public virtual onlyOwner {
78         require(newOwner != address(0), "Ownable: new owner is the zero address");
79         emit OwnershipTransferred(_owner, newOwner);
80         _owner = newOwner;
81     }
82 
83 }
84 
85 library SafeMath {
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a + b;
88         require(c >= a, "SafeMath: addition overflow");
89         return c;
90     }
91 
92     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93         return sub(a, b, "SafeMath: subtraction overflow");
94     }
95 
96     function sub(
97         uint256 a,
98         uint256 b,
99         string memory errorMessage
100     ) internal pure returns (uint256) {
101         require(b <= a, errorMessage);
102         uint256 c = a - b;
103         return c;
104     }
105 
106     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107         if (a == 0) {
108             return 0;
109         }
110         uint256 c = a * b;
111         require(c / a == b, "SafeMath: multiplication overflow");
112         return c;
113     }
114 
115     function div(uint256 a, uint256 b) internal pure returns (uint256) {
116         return div(a, b, "SafeMath: division by zero");
117     }
118 
119     function div(
120         uint256 a,
121         uint256 b,
122         string memory errorMessage
123     ) internal pure returns (uint256) {
124         require(b > 0, errorMessage);
125         uint256 c = a / b;
126         return c;
127     }
128 }
129 
130 interface IUniswapV2Factory {
131     function createPair(address tokenA, address tokenB)
132         external
133         returns (address pair);
134 }
135 
136 interface IUniswapV2Router02 {
137     function swapExactTokensForETHSupportingFeeOnTransferTokens(
138         uint256 amountIn,
139         uint256 amountOutMin,
140         address[] calldata path,
141         address to,
142         uint256 deadline
143     ) external;
144 
145     function factory() external pure returns (address);
146 
147     function WETH() external pure returns (address);
148 
149     function addLiquidityETH(
150         address token,
151         uint256 amountTokenDesired,
152         uint256 amountTokenMin,
153         uint256 amountETHMin,
154         address to,
155         uint256 deadline
156     )
157         external
158         payable
159         returns (
160             uint256 amountToken,
161             uint256 amountETH,
162             uint256 liquidity
163         );
164 }
165 
166 contract OB is Context, IERC20, Ownable {
167 
168     using SafeMath for uint256;
169 
170     string private constant _name = "Old Bitcoin";
171     string private constant _symbol = "OB";
172     uint8 private constant _decimals = 9;
173 
174     mapping(address => uint256) private _rOwned;
175     mapping(address => uint256) private _tOwned;
176     mapping(address => mapping(address => uint256)) private _allowances;
177     mapping(address => bool) private _isExcludedFromFee;
178     uint256 private constant MAX = ~uint256(0);
179     uint256 private constant _tTotal = 1000000 * 10**9;
180     uint256 private _rTotal = (MAX - (MAX % _tTotal));
181     uint256 private _tFeeTotal;
182     uint256 private _redisFeeOnBuy = 0;
183     uint256 private _taxFeeOnBuy = 10;
184     uint256 private _redisFeeOnSell = 0;
185     uint256 private _taxFeeOnSell = 20;
186 
187     //Original Fee
188     uint256 private _redisFee = _redisFeeOnSell;
189     uint256 private _taxFee = _taxFeeOnSell;
190 
191     uint256 private _previousredisFee = _redisFee;
192     uint256 private _previoustaxFee = _taxFee;
193 
194     address payable private _developmentAddress = payable(0x9A6e2BAB7642B887fbA89005B142B1a6c1011eD1);
195     address payable private _marketingAddress = payable(0x9A6e2BAB7642B887fbA89005B142B1a6c1011eD1);
196 
197     IUniswapV2Router02 public uniswapV2Router;
198     address public uniswapV2Pair;
199 
200     bool private tradingOpen = true;
201     bool private inSwap = false;
202     bool private swapEnabled = true;
203 
204     uint256 public _maxTxAmount = _tTotal/100;
205     uint256 public _maxWalletSize = _tTotal*2/100;
206     uint256 public _swapTokensAtAmount = _tTotal*3/1000;
207 
208     event MaxTxAmountUpdated(uint256 _maxTxAmount);
209     modifier lockTheSwap {
210         inSwap = true;
211         _;
212         inSwap = false;
213     }
214 
215     constructor() {
216 
217         _rOwned[_msgSender()] = _rTotal;
218 
219         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
220         uniswapV2Router = _uniswapV2Router;
221         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
222             .createPair(address(this), _uniswapV2Router.WETH());
223 
224         _isExcludedFromFee[owner()] = true;
225         _isExcludedFromFee[address(this)] = true;
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
351 
352             if(to != uniswapV2Pair) {
353                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
354             }
355 
356             uint256 contractTokenBalance = balanceOf(address(this));
357             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
358 
359             if(contractTokenBalance >= _swapTokensAtAmount*2)
360             {
361                 contractTokenBalance = _swapTokensAtAmount*2;
362             }
363 
364             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
365                 swapTokensForEth(contractTokenBalance);
366                 uint256 contractETHBalance = address(this).balance;
367                 if (contractETHBalance > 100000000000000000) {
368                     sendETHToFee(contractETHBalance);
369                 }
370             }
371         }
372 
373         bool takeFee = true;
374 
375         //Transfer Tokens
376         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
377             takeFee = false;
378         } else {
379 
380             //Set Fee for Buys
381             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
382                 _redisFee = _redisFeeOnBuy;
383                 _taxFee = _taxFeeOnBuy;
384             }
385 
386             //Set Fee for Sells
387             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
388                 _redisFee = _redisFeeOnSell;
389                 _taxFee = _taxFeeOnSell;
390             }
391 
392         }
393 
394         _tokenTransfer(from, to, amount, takeFee);
395     }
396 
397     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
398         address[] memory path = new address[](2);
399         path[0] = address(this);
400         path[1] = uniswapV2Router.WETH();
401         _approve(address(this), address(uniswapV2Router), tokenAmount);
402         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
403             tokenAmount,
404             0,
405             path,
406             address(this),
407             block.timestamp
408         );
409     }
410 
411     function sendETHToFee(uint256 amount) private {
412         _marketingAddress.transfer(amount);
413     }
414 
415     function manualsend() external {
416         sendETHToFee(address(this).balance);
417     }
418 
419     function manualSwap(uint256 percent) external {
420         uint256 contractTokenBalance = balanceOf(address(this));
421         uint256 swapamount = contractTokenBalance*percent/100;
422         swapTokensForEth(swapamount);
423     }
424 
425     function toggleSwap (bool _swapEnabled) external {
426         swapEnabled = _swapEnabled;
427     }
428 
429     function _tokenTransfer(
430         address sender,
431         address recipient,
432         uint256 amount,
433         bool takeFee
434     ) private {
435         if (!takeFee) removeAllFee();
436         _transferStandard(sender, recipient, amount);
437         if (!takeFee) restoreAllFee();
438     }
439 
440     function _transferStandard(
441         address sender,
442         address recipient,
443         uint256 tAmount
444     ) private {
445         (
446             uint256 rAmount,
447             uint256 rTransferAmount,
448             uint256 rFee,
449             uint256 tTransferAmount,
450             uint256 tFee,
451             uint256 tTeam
452         ) = _getValues(tAmount);
453         _rOwned[sender] = _rOwned[sender].sub(rAmount);
454         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
455         _takeTeam(tTeam);
456         _reflectFee(rFee, tFee);
457         emit Transfer(sender, recipient, tTransferAmount);
458     }
459 
460     function _takeTeam(uint256 tTeam) private {
461         uint256 currentRate = _getRate();
462         uint256 rTeam = tTeam.mul(currentRate);
463         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
464     }
465 
466     function _reflectFee(uint256 rFee, uint256 tFee) private {
467         _rTotal = _rTotal.sub(rFee);
468         _tFeeTotal = _tFeeTotal.add(tFee);
469     }
470 
471     receive() external payable {}
472 
473     function _getValues(uint256 tAmount)
474         private
475         view
476         returns (
477             uint256,
478             uint256,
479             uint256,
480             uint256,
481             uint256,
482             uint256
483         )
484     {
485         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
486             _getTValues(tAmount, _redisFee, _taxFee);
487         uint256 currentRate = _getRate();
488         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
489             _getRValues(tAmount, tFee, tTeam, currentRate);
490         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
491     }
492 
493     function _getTValues(
494         uint256 tAmount,
495         uint256 redisFee,
496         uint256 taxFee
497     )
498         private
499         pure
500         returns (
501             uint256,
502             uint256,
503             uint256
504         )
505     {
506         uint256 tFee = tAmount.mul(redisFee).div(100);
507         uint256 tTeam = tAmount.mul(taxFee).div(100);
508         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
509         return (tTransferAmount, tFee, tTeam);
510     }
511 
512     function _getRValues(
513         uint256 tAmount,
514         uint256 tFee,
515         uint256 tTeam,
516         uint256 currentRate
517     )
518         private
519         pure
520         returns (
521             uint256,
522             uint256,
523             uint256
524         )
525     {
526         uint256 rAmount = tAmount.mul(currentRate);
527         uint256 rFee = tFee.mul(currentRate);
528         uint256 rTeam = tTeam.mul(currentRate);
529         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
530         return (rAmount, rTransferAmount, rFee);
531     }
532 
533     function _getRate() private view returns (uint256) {
534         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
535         return rSupply.div(tSupply);
536     }
537 
538     function _getCurrentSupply() private view returns (uint256, uint256) {
539         uint256 rSupply = _rTotal;
540         uint256 tSupply = _tTotal;
541         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
542         return (rSupply, tSupply);
543     }
544 
545     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
546         _redisFeeOnBuy = redisFeeOnBuy;
547         _redisFeeOnSell = redisFeeOnSell;
548         _taxFeeOnBuy = taxFeeOnBuy;
549         _taxFeeOnSell = taxFeeOnSell;
550         require (_redisFeeOnBuy+_redisFeeOnSell+_taxFeeOnBuy+_taxFeeOnSell <= 25);
551     }
552 
553     //Set maximum transaction
554     function setMaxTxnAndWalletSize(uint256 maxTxAmount, uint256 maxWalletSize) public onlyOwner {
555         require (_maxTxAmount >= _tTotal/100 && _maxWalletSize >= _tTotal/100,"Must be more than 1%");
556         _maxTxAmount = _tTotal*maxTxAmount/100;
557         _maxWalletSize = _tTotal*maxWalletSize/100;
558     }
559 
560 }