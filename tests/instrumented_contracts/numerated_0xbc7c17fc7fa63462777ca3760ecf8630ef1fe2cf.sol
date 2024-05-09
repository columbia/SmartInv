1 /**
2 Sheena Inu, the mother of Shiba Inu. 
3 
4 https://t.me/SheenaInuErc
5 https://twitter.com/SheenaInuErc
6 
7 */
8 // SPDX-License-Identifier: Unlicensed
9 pragma solidity ^0.8.9;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19 
20     function balanceOf(address account) external view returns (uint256);
21 
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24     function allowance(address owner, address spender) external view returns (uint256);
25 
26     function approve(address spender, uint256 amount) external returns (bool);
27 
28     function transferFrom(
29         address sender,
30         address recipient,
31         uint256 amount
32     ) external returns (bool);
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(
36         address indexed owner,
37         address indexed spender,
38         uint256 value
39     );
40 }
41 
42 contract Ownable is Context {
43     address private _owner;
44     address private _previousOwner;
45     event OwnershipTransferred(
46         address indexed previousOwner,
47         address indexed newOwner
48     );
49 
50     constructor() {
51         address msgSender = _msgSender();
52         _owner = msgSender;
53         emit OwnershipTransferred(address(0), msgSender);
54     }
55 
56     function owner() public view returns (address) {
57         return _owner;
58     }
59 
60     modifier onlyOwner() {
61         require(_owner == _msgSender(), "Ownable: caller is not the owner");
62         _;
63     }
64 
65     function renounceOwnership() public virtual onlyOwner {
66         emit OwnershipTransferred(_owner, address(0));
67         _owner = address(0);
68     }
69 
70     function transferOwnership(address newOwner) public virtual onlyOwner {
71         require(newOwner != address(0), "Ownable: new owner is the zero address");
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 
76 }
77 
78 library SafeMath {
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         require(c >= a, "SafeMath: addition overflow");
82         return c;
83     }
84 
85     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86         return sub(a, b, "SafeMath: subtraction overflow");
87     }
88 
89     function sub(
90         uint256 a,
91         uint256 b,
92         string memory errorMessage
93     ) internal pure returns (uint256) {
94         require(b <= a, errorMessage);
95         uint256 c = a - b;
96         return c;
97     }
98 
99     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
100         if (a == 0) {
101             return 0;
102         }
103         uint256 c = a * b;
104         require(c / a == b, "SafeMath: multiplication overflow");
105         return c;
106     }
107 
108     function div(uint256 a, uint256 b) internal pure returns (uint256) {
109         return div(a, b, "SafeMath: division by zero");
110     }
111 
112     function div(
113         uint256 a,
114         uint256 b,
115         string memory errorMessage
116     ) internal pure returns (uint256) {
117         require(b > 0, errorMessage);
118         uint256 c = a / b;
119         return c;
120     }
121 }
122 
123 interface IUniswapV2Factory {
124     function createPair(address tokenA, address tokenB)
125         external
126         returns (address pair);
127 }
128 
129 interface IUniswapV2Router02 {
130     function swapExactTokensForETHSupportingFeeOnTransferTokens(
131         uint256 amountIn,
132         uint256 amountOutMin,
133         address[] calldata path,
134         address to,
135         uint256 deadline
136     ) external;
137 
138     function factory() external pure returns (address);
139 
140     function WETH() external pure returns (address);
141 
142     function addLiquidityETH(
143         address token,
144         uint256 amountTokenDesired,
145         uint256 amountTokenMin,
146         uint256 amountETHMin,
147         address to,
148         uint256 deadline
149     )
150         external
151         payable
152         returns (
153             uint256 amountToken,
154             uint256 amountETH,
155             uint256 liquidity
156         );
157 }
158 
159 contract SheenaInu is Context, IERC20, Ownable {
160 
161     using SafeMath for uint256;
162 
163     string private constant _name = "Sheena Inu";
164     string private constant _symbol = "SHEENA";
165     uint8 private constant _decimals = 9;
166 
167     mapping(address => uint256) private _rOwned;
168     mapping(address => uint256) private _tOwned;
169     mapping(address => mapping(address => uint256)) private _allowances;
170     mapping(address => bool) private _isExcludedFromFee;
171     uint256 private constant MAX = ~uint256(0);
172     uint256 private constant _tTotal = 1000000 * 10**9;
173     uint256 private _rTotal = (MAX - (MAX % _tTotal));
174     uint256 private _tFeeTotal;
175     uint256 private _redisFeeOnBuy = 0;
176     uint256 private _taxFeeOnBuy = 30;
177     uint256 private _redisFeeOnSell = 0;
178     uint256 private _taxFeeOnSell = 50;
179 
180     //Original Fee
181     uint256 private _redisFee = _redisFeeOnSell;
182     uint256 private _taxFee = _taxFeeOnSell;
183 
184     uint256 private _previousredisFee = _redisFee;
185     uint256 private _previoustaxFee = _taxFee;
186 
187     address payable private _developmentAddress = payable(msg.sender);
188     address payable private _marketingAddress = payable(msg.sender);
189 
190     IUniswapV2Router02 public uniswapV2Router;
191     address public uniswapV2Pair;
192 
193     bool private tradingOpen = true;
194     bool private inSwap = false;
195     bool private swapEnabled = true;
196 
197      uint256 public _maxTxAmount = _tTotal*2/100;
198     uint256 public _maxWalletSize = _tTotal*2/100;
199     uint256 public _swapTokensAtAmount = _tTotal*3/1000;
200 
201     event MaxTxAmountUpdated(uint256 _maxTxAmount);
202     modifier lockTheSwap {
203         inSwap = true;
204         _;
205         inSwap = false;
206     }
207 
208     constructor() {
209 
210         _rOwned[_msgSender()] = _rTotal;
211 
212         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
213         uniswapV2Router = _uniswapV2Router;
214         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
215             .createPair(address(this), _uniswapV2Router.WETH());
216 
217         _isExcludedFromFee[owner()] = true;
218         _isExcludedFromFee[address(this)] = true;
219         _isExcludedFromFee[_marketingAddress] = true;
220 
221         emit Transfer(address(0), _msgSender(), _tTotal);
222     }
223 
224     function name() public pure returns (string memory) {
225         return _name;
226     }
227 
228     function symbol() public pure returns (string memory) {
229         return _symbol;
230     }
231 
232     function decimals() public pure returns (uint8) {
233         return _decimals;
234     }
235 
236     function totalSupply() public pure override returns (uint256) {
237         return _tTotal;
238     }
239 
240     function balanceOf(address account) public view override returns (uint256) {
241         return tokenFromReflection(_rOwned[account]);
242     }
243 
244     function transfer(address recipient, uint256 amount)
245         public
246         override
247         returns (bool)
248     {
249         _transfer(_msgSender(), recipient, amount);
250         return true;
251     }
252 
253     function allowance(address owner, address spender)
254         public
255         view
256         override
257         returns (uint256)
258     {
259         return _allowances[owner][spender];
260     }
261 
262     function approve(address spender, uint256 amount)
263         public
264         override
265         returns (bool)
266     {
267         _approve(_msgSender(), spender, amount);
268         return true;
269     }
270 
271     function transferFrom(
272         address sender,
273         address recipient,
274         uint256 amount
275     ) public override returns (bool) {
276         _transfer(sender, recipient, amount);
277         _approve(
278             sender,
279             _msgSender(),
280             _allowances[sender][_msgSender()].sub(
281                 amount,
282                 "ERC20: transfer amount exceeds allowance"
283             )
284         );
285         return true;
286     }
287 
288     function tokenFromReflection(uint256 rAmount)
289         private
290         view
291         returns (uint256)
292     {
293         require(
294             rAmount <= _rTotal,
295             "Amount must be less than total reflections"
296         );
297         uint256 currentRate = _getRate();
298         return rAmount.div(currentRate);
299     }
300 
301     function removeAllFee() private {
302         if (_redisFee == 0 && _taxFee == 0) return;
303 
304         _previousredisFee = _redisFee;
305         _previoustaxFee = _taxFee;
306 
307         _redisFee = 0;
308         _taxFee = 0;
309     }
310 
311     function restoreAllFee() private {
312         _redisFee = _previousredisFee;
313         _taxFee = _previoustaxFee;
314     }
315 
316     function _approve(
317         address owner,
318         address spender,
319         uint256 amount
320     ) private {
321         require(owner != address(0), "ERC20: approve from the zero address");
322         require(spender != address(0), "ERC20: approve to the zero address");
323         _allowances[owner][spender] = amount;
324         emit Approval(owner, spender, amount);
325     }
326 
327     function _transfer(
328         address from,
329         address to,
330         uint256 amount
331     ) private {
332         require(from != address(0), "ERC20: transfer from the zero address");
333         require(to != address(0), "ERC20: transfer to the zero address");
334         require(amount > 0, "Transfer amount must be greater than zero");
335 
336         if (from != owner() && to != owner()) {
337 
338             //Trade start check
339             if (!tradingOpen) {
340                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
341             }
342 
343             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
344 
345             if(to != uniswapV2Pair) {
346                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
347             }
348 
349             uint256 contractTokenBalance = balanceOf(address(this));
350             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
351 
352             if(contractTokenBalance >= _swapTokensAtAmount*2)
353             {
354                 contractTokenBalance = _swapTokensAtAmount*2;
355             }
356 
357             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
358                 swapTokensForEth(contractTokenBalance);
359                 uint256 contractETHBalance = address(this).balance;
360                 if (contractETHBalance > 100000000000000000) {
361                     sendETHToFee(contractETHBalance);
362                 }
363             }
364         }
365 
366         bool takeFee = true;
367 
368         //Transfer Tokens
369         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
370             takeFee = false;
371         } else {
372 
373             //Set Fee for Buys
374             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
375                 _redisFee = _redisFeeOnBuy;
376                 _taxFee = _taxFeeOnBuy;
377             }
378 
379             //Set Fee for Sells
380             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
381                 _redisFee = _redisFeeOnSell;
382                 _taxFee = _taxFeeOnSell;
383             }
384 
385         }
386 
387         _tokenTransfer(from, to, amount, takeFee);
388     }
389 
390     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
391         address[] memory path = new address[](2);
392         path[0] = address(this);
393         path[1] = uniswapV2Router.WETH();
394         _approve(address(this), address(uniswapV2Router), tokenAmount);
395         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
396             tokenAmount,
397             0,
398             path,
399             address(this),
400             block.timestamp
401         );
402     }
403 
404     function sendETHToFee(uint256 amount) private {
405         _marketingAddress.transfer(amount);
406     }
407 
408     function manualsend() external {
409         sendETHToFee(address(this).balance);
410     }
411 
412     function manualSwap(uint256 percent) external {
413         uint256 contractTokenBalance = balanceOf(address(this));
414         uint256 swapamount = contractTokenBalance*percent/100;
415         swapTokensForEth(swapamount);
416     }
417 
418     function toggleSwap (bool _swapEnabled) external {
419         swapEnabled = _swapEnabled;
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
483         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
484     }
485 
486     function _getTValues(
487         uint256 tAmount,
488         uint256 redisFee,
489         uint256 taxFee
490     )
491         private
492         pure
493         returns (
494             uint256,
495             uint256,
496             uint256
497         )
498     {
499         uint256 tFee = tAmount.mul(redisFee).div(100);
500         uint256 tTeam = tAmount.mul(taxFee).div(100);
501         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
502         return (tTransferAmount, tFee, tTeam);
503     }
504 
505     function _getRValues(
506         uint256 tAmount,
507         uint256 tFee,
508         uint256 tTeam,
509         uint256 currentRate
510     )
511         private
512         pure
513         returns (
514             uint256,
515             uint256,
516             uint256
517         )
518     {
519         uint256 rAmount = tAmount.mul(currentRate);
520         uint256 rFee = tFee.mul(currentRate);
521         uint256 rTeam = tTeam.mul(currentRate);
522         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
523         return (rAmount, rTransferAmount, rFee);
524     }
525 
526     function _getRate() private view returns (uint256) {
527         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
528         return rSupply.div(tSupply);
529     }
530 
531     function _getCurrentSupply() private view returns (uint256, uint256) {
532         uint256 rSupply = _rTotal;
533         uint256 tSupply = _tTotal;
534         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
535         return (rSupply, tSupply);
536     }
537 
538     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
539         _redisFeeOnBuy = redisFeeOnBuy;
540         _redisFeeOnSell = redisFeeOnSell;
541         _taxFeeOnBuy = taxFeeOnBuy;
542         _taxFeeOnSell = taxFeeOnSell;
543         require (_redisFeeOnBuy+_redisFeeOnSell+_taxFeeOnBuy+_taxFeeOnSell <= 98);
544     }
545 
546     //Set maximum transaction
547     function setMaxTxnAndWalletSize(uint256 maxTxAmount, uint256 maxWalletSize) public onlyOwner {
548         require (_maxTxAmount >= _tTotal/100 && _maxWalletSize >= _tTotal/100,"Must be more than 1%");
549         _maxTxAmount = _tTotal*maxTxAmount/100;
550         _maxWalletSize = _tTotal*maxWalletSize/100;
551     }
552 
553 }