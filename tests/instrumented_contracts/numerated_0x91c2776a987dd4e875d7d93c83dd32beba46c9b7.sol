1 /**
2 Singularity (SGL)
3 
4 t.me/singularityERC
5 
6 twitter.com/singularity_erc
7 
8 https://medium.com/@singularity_ERC
9 
10 */
11 // SPDX-License-Identifier: Unlicensed
12 pragma solidity ^0.8.9;
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
162 contract Singularity is Context, IERC20, Ownable {
163 
164     using SafeMath for uint256;
165 
166     string private constant _name = "Singularity";
167     string private constant _symbol = "SGL";
168     uint8 private constant _decimals = 9;
169 
170     mapping(address => uint256) private _rOwned;
171     mapping(address => uint256) private _tOwned;
172     mapping(address => mapping(address => uint256)) private _allowances;
173     mapping(address => bool) private _isExcludedFromFee;
174     uint256 private constant MAX = ~uint256(0);
175     uint256 private constant _tTotal = 1000000000 * 10**9;
176     uint256 private _rTotal = (MAX - (MAX % _tTotal));
177     uint256 private _tFeeTotal;
178     uint256 private _redisFeeOnBuy = 0;
179     uint256 private _taxFeeOnBuy = 10;
180     uint256 private _redisFeeOnSell = 0;
181     uint256 private _taxFeeOnSell = 40;
182 
183     //Original Fee
184     uint256 private _redisFee = _redisFeeOnSell;
185     uint256 private _taxFee = _taxFeeOnSell;
186 
187     uint256 private _previousredisFee = _redisFee;
188     uint256 private _previoustaxFee = _taxFee;
189 
190     address payable private _developmentAddress = payable(0xcE5b611530313ec3c8a6dF585D0206C8721bbaa9);
191     address payable private _marketingAddress = payable(0xcE5b611530313ec3c8a6dF585D0206C8721bbaa9);
192 
193     IUniswapV2Router02 public uniswapV2Router;
194     address public uniswapV2Pair;
195 
196     bool private tradingOpen = true;
197     bool private inSwap = false;
198     bool private swapEnabled = true;
199 
200     uint256 public _maxTxAmount = _tTotal;
201     uint256 public _maxWalletSize = _tTotal*2/100;
202     uint256 public _swapTokensAtAmount = _tTotal*4/1000;
203 
204     event MaxTxAmountUpdated(uint256 _maxTxAmount);
205     modifier lockTheSwap {
206         inSwap = true;
207         _;
208         inSwap = false;
209     }
210 
211     constructor() {
212 
213         _rOwned[_msgSender()] = _rTotal;
214 
215         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
216         uniswapV2Router = _uniswapV2Router;
217         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
218             .createPair(address(this), _uniswapV2Router.WETH());
219 
220         _isExcludedFromFee[owner()] = true;
221         _isExcludedFromFee[address(this)] = true;
222         _isExcludedFromFee[_marketingAddress] = true;
223 
224         emit Transfer(address(0), _msgSender(), _tTotal);
225     }
226 
227     function name() public pure returns (string memory) {
228         return _name;
229     }
230 
231     function symbol() public pure returns (string memory) {
232         return _symbol;
233     }
234 
235     function decimals() public pure returns (uint8) {
236         return _decimals;
237     }
238 
239     function totalSupply() public pure override returns (uint256) {
240         return _tTotal;
241     }
242 
243     function balanceOf(address account) public view override returns (uint256) {
244         return tokenFromReflection(_rOwned[account]);
245     }
246 
247     function transfer(address recipient, uint256 amount)
248         public
249         override
250         returns (bool)
251     {
252         _transfer(_msgSender(), recipient, amount);
253         return true;
254     }
255 
256     function allowance(address owner, address spender)
257         public
258         view
259         override
260         returns (uint256)
261     {
262         return _allowances[owner][spender];
263     }
264 
265     function approve(address spender, uint256 amount)
266         public
267         override
268         returns (bool)
269     {
270         _approve(_msgSender(), spender, amount);
271         return true;
272     }
273 
274     function transferFrom(
275         address sender,
276         address recipient,
277         uint256 amount
278     ) public override returns (bool) {
279         _transfer(sender, recipient, amount);
280         _approve(
281             sender,
282             _msgSender(),
283             _allowances[sender][_msgSender()].sub(
284                 amount,
285                 "ERC20: transfer amount exceeds allowance"
286             )
287         );
288         return true;
289     }
290 
291     function tokenFromReflection(uint256 rAmount)
292         private
293         view
294         returns (uint256)
295     {
296         require(
297             rAmount <= _rTotal,
298             "Amount must be less than total reflections"
299         );
300         uint256 currentRate = _getRate();
301         return rAmount.div(currentRate);
302     }
303 
304     function removeAllFee() private {
305         if (_redisFee == 0 && _taxFee == 0) return;
306 
307         _previousredisFee = _redisFee;
308         _previoustaxFee = _taxFee;
309 
310         _redisFee = 0;
311         _taxFee = 0;
312     }
313 
314     function restoreAllFee() private {
315         _redisFee = _previousredisFee;
316         _taxFee = _previoustaxFee;
317     }
318 
319     function _approve(
320         address owner,
321         address spender,
322         uint256 amount
323     ) private {
324         require(owner != address(0), "ERC20: approve from the zero address");
325         require(spender != address(0), "ERC20: approve to the zero address");
326         _allowances[owner][spender] = amount;
327         emit Approval(owner, spender, amount);
328     }
329 
330     function _transfer(
331         address from,
332         address to,
333         uint256 amount
334     ) private {
335         require(from != address(0), "ERC20: transfer from the zero address");
336         require(to != address(0), "ERC20: transfer to the zero address");
337         require(amount > 0, "Transfer amount must be greater than zero");
338 
339         if (from != owner() && to != owner()) {
340 
341             //Trade start check
342             if (!tradingOpen) {
343                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
344             }
345 
346             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
347 
348             if(to != uniswapV2Pair) {
349                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
350             }
351 
352             uint256 contractTokenBalance = balanceOf(address(this));
353             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
354 
355             if(contractTokenBalance >= _swapTokensAtAmount*2)
356             {
357                 contractTokenBalance = _swapTokensAtAmount*2;
358             }
359 
360             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
361                 swapTokensForEth(contractTokenBalance);
362                 uint256 contractETHBalance = address(this).balance;
363                 if (contractETHBalance > 100000000000000000) {
364                     sendETHToFee(contractETHBalance);
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
411     function manualsend() external {
412         sendETHToFee(address(this).balance);
413     }
414 
415     function toggleSwap (bool _swapEnabled) external {
416         swapEnabled = _swapEnabled;
417     }
418 
419     function _tokenTransfer(
420         address sender,
421         address recipient,
422         uint256 amount,
423         bool takeFee
424     ) private {
425         if (!takeFee) removeAllFee();
426         _transferStandard(sender, recipient, amount);
427         if (!takeFee) restoreAllFee();
428     }
429 
430     function _transferStandard(
431         address sender,
432         address recipient,
433         uint256 tAmount
434     ) private {
435         (
436             uint256 rAmount,
437             uint256 rTransferAmount,
438             uint256 rFee,
439             uint256 tTransferAmount,
440             uint256 tFee,
441             uint256 tTeam
442         ) = _getValues(tAmount);
443         _rOwned[sender] = _rOwned[sender].sub(rAmount);
444         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
445         _takeTeam(tTeam);
446         _reflectFee(rFee, tFee);
447         emit Transfer(sender, recipient, tTransferAmount);
448     }
449 
450     function _takeTeam(uint256 tTeam) private {
451         uint256 currentRate = _getRate();
452         uint256 rTeam = tTeam.mul(currentRate);
453         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
454     }
455 
456     function _reflectFee(uint256 rFee, uint256 tFee) private {
457         _rTotal = _rTotal.sub(rFee);
458         _tFeeTotal = _tFeeTotal.add(tFee);
459     }
460 
461     receive() external payable {}
462 
463     function _getValues(uint256 tAmount)
464         private
465         view
466         returns (
467             uint256,
468             uint256,
469             uint256,
470             uint256,
471             uint256,
472             uint256
473         )
474     {
475         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
476             _getTValues(tAmount, _redisFee, _taxFee);
477         uint256 currentRate = _getRate();
478         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
479             _getRValues(tAmount, tFee, tTeam, currentRate);
480         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
481     }
482 
483     function _getTValues(
484         uint256 tAmount,
485         uint256 redisFee,
486         uint256 taxFee
487     )
488         private
489         pure
490         returns (
491             uint256,
492             uint256,
493             uint256
494         )
495     {
496         uint256 tFee = tAmount.mul(redisFee).div(100);
497         uint256 tTeam = tAmount.mul(taxFee).div(100);
498         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
499         return (tTransferAmount, tFee, tTeam);
500     }
501 
502     function _getRValues(
503         uint256 tAmount,
504         uint256 tFee,
505         uint256 tTeam,
506         uint256 currentRate
507     )
508         private
509         pure
510         returns (
511             uint256,
512             uint256,
513             uint256
514         )
515     {
516         uint256 rAmount = tAmount.mul(currentRate);
517         uint256 rFee = tFee.mul(currentRate);
518         uint256 rTeam = tTeam.mul(currentRate);
519         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
520         return (rAmount, rTransferAmount, rFee);
521     }
522 
523     function _getRate() private view returns (uint256) {
524         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
525         return rSupply.div(tSupply);
526     }
527 
528     function _getCurrentSupply() private view returns (uint256, uint256) {
529         uint256 rSupply = _rTotal;
530         uint256 tSupply = _tTotal;
531         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
532         return (rSupply, tSupply);
533     }
534 
535     function setBuyAndSellFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
536         _redisFeeOnBuy = redisFeeOnBuy;
537         _redisFeeOnSell = redisFeeOnSell;
538         _taxFeeOnBuy = taxFeeOnBuy;
539         _taxFeeOnSell = taxFeeOnSell;
540         require (_redisFeeOnBuy+_redisFeeOnSell+_taxFeeOnBuy+_taxFeeOnSell <= 25);
541     }
542 
543     //Set maximum transaction
544     function setMaxTransactionAmount(uint256 maxTxAmount) public onlyOwner {
545         _maxTxAmount = _tTotal*maxTxAmount/100;
546         require (_maxTxAmount >= _tTotal/100);
547     }
548 
549     function setMaxWalletLimit(uint256 maxWalletSize) public onlyOwner {
550         _maxWalletSize = _tTotal*maxWalletSize/100;
551          require (_maxWalletSize >= _tTotal/100);
552     }
553 
554 }