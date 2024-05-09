1 // TG: https://t.me/dragonballERC
2 // TW: https://twitter.com/dragonballERC
3 // Web: https://dragonballerc.com
4 
5 // SPDX-License-Identifier: Unlicensed
6 pragma solidity ^0.8.9;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 }
13  
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16 
17     function balanceOf(address account) external view returns (uint256);
18 
19     function transfer(address recipient, uint256 amount) external returns (bool);
20 
21     function allowance(address owner, address spender) external view returns (uint256);
22 
23     function approve(address spender, uint256 amount) external returns (bool);
24 
25     function transferFrom(
26         address sender,
27         address recipient,
28         uint256 amount
29     ) external returns (bool);
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(
33         address indexed owner,
34         address indexed spender,
35         uint256 value
36     );  
37 }
38 
39 contract Ownable is Context {
40     address private _owner;
41     address private _previousOwner;
42     event OwnershipTransferred(
43         address indexed previousOwner,
44         address indexed newOwner
45     );
46 
47     constructor() {
48         address msgSender = _msgSender();
49         _owner = msgSender;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52 
53     function owner() public view returns (address) {
54         return _owner;
55     }
56 
57     modifier onlyOwner() {
58         require(_owner == _msgSender(), "Ownable: caller is not the owner");
59         _;
60     }
61 
62     function renounceOwnership() public virtual onlyOwner {
63         emit OwnershipTransferred(_owner, address(0));
64         _owner = address(0);
65     }
66 
67     function transferOwnership(address newOwner) public virtual onlyOwner {
68         require(newOwner != address(0), "Ownable: new owner is the zero address");
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 
73 }
74 
75 library SafeMath {
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a, "SafeMath: addition overflow");
79         return c;
80     }
81 
82     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83         return sub(a, b, "SafeMath: subtraction overflow");
84     }
85 
86     function sub(
87         uint256 a,
88         uint256 b,
89         string memory errorMessage
90     ) internal pure returns (uint256) {
91         require(b <= a, errorMessage);
92         uint256 c = a - b;
93         return c;
94     }
95 
96     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97         if (a == 0) {
98             return 0;
99         }
100         uint256 c = a * b;
101         require(c / a == b, "SafeMath: multiplication overflow");
102         return c;
103     }
104 
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     function div(
110         uint256 a,
111         uint256 b,
112         string memory errorMessage
113     ) internal pure returns (uint256) {
114         require(b > 0, errorMessage);
115         uint256 c = a / b;
116         return c;
117     }
118 }
119 
120 interface IUniswapV2Factory {
121     function createPair(address tokenA, address tokenB)
122         external
123         returns (address pair);
124 }
125 
126 interface IUniswapV2Router02 {
127     function swapExactTokensForETHSupportingFeeOnTransferTokens(
128         uint256 amountIn,
129         uint256 amountOutMin,
130         address[] calldata path,
131         address to,
132         address referrer,
133         uint256 deadline
134     ) external;
135 
136     function factory() external pure returns (address);
137 
138     function WETH() external pure returns (address);
139 }
140 
141 contract DragonBall is Context, IERC20, Ownable {
142 
143     using SafeMath for uint256;
144 
145     string private constant _name = unicode"Dragon Ball Z";
146     string private constant _symbol = unicode"DBZ";
147     uint8 private constant _decimals = 9;
148  
149     mapping(address => uint256) private _rOwned;
150     mapping(address => uint256) private _tOwned;
151     mapping(address => mapping(address => uint256)) private _allowances;
152     mapping(address => bool) private _isExcludedFromFee;
153     uint256 private constant MAX = ~uint256(0);
154     uint256 private constant _tTotal = 110_000_000_000 * 10**_decimals;
155     uint256 private _rTotal = (MAX - (MAX % _tTotal));
156     uint256 private _tFeeTotal;
157     uint256 private _redisFeeOnBuy = 0;
158     uint256 private _taxFeeOnBuy = 30;
159     uint256 private _redisFeeOnSell = 0;
160     uint256 private _taxFeeOnSell = 30;
161   
162     uint256 private _redisFee = _redisFeeOnSell;
163     uint256 private _taxFee = _taxFeeOnSell;
164 
165     uint256 private _previousredisFee = _redisFee;
166     uint256 private _previoustaxFee = _taxFee;
167 
168     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
169     address payable private _developmentAddress = payable(0x5a47CCBda6CFa1CAdecE256E6367979c2A18A133);
170     address payable private _marketingAddress = payable(0x5a47CCBda6CFa1CAdecE256E6367979c2A18A133);
171 
172     IUniswapV2Router02 public uniswapV2Router;
173     address public uniswapV2Pair;
174 
175     bool private tradingOpen = true;
176     bool private inSwap = false;
177     bool private swapEnabled = true;
178 
179     uint256 public _maxTxAmount =  2 * (_tTotal/100);
180     uint256 public _maxWalletSize = 2 * (_tTotal/100);
181     uint256 public _swapTokensAtAmount = 20 *(_tTotal/1000);
182 
183     event MaxTxAmountUpdated(uint256 _maxTxAmount);
184     modifier lockTheSwap {
185         inSwap = true;
186         _; 
187         inSwap = false;
188     }
189 
190     constructor() {
191         _rOwned[_msgSender()] = _rTotal;
192 
193         _isExcludedFromFee[owner()] = true;
194         _isExcludedFromFee[address(this)] = true;
195         _isExcludedFromFee[_developmentAddress] = true;
196         _isExcludedFromFee[_marketingAddress] = true;
197 
198         emit Transfer(address(0), _msgSender(), _tTotal);
199     }
200 
201     function name() public pure returns (string memory) {
202         return _name;
203     }
204 
205     function symbol() public pure returns (string memory) {
206         return _symbol;
207     }
208 
209     function decimals() public pure returns (uint8) {
210         return _decimals;
211     }
212 
213     function totalSupply() public pure override returns (uint256) {
214         return _tTotal;
215     }
216 
217     function balanceOf(address account) public view override returns (uint256) {
218         return tokenFromReflection(_rOwned[account]);
219     }
220 
221     function transfer(address recipient, uint256 amount)
222         public
223         override
224         returns (bool)
225     {
226         _transfer(_msgSender(), recipient, amount);
227         return true;
228     }
229 
230     function allowance(address owner, address spender)
231         public
232         view
233         override
234         returns (uint256)
235     {
236         return _allowances[owner][spender];
237     }
238 
239     function approve(address spender, uint256 amount)
240         public
241         override
242         returns (bool)
243     {
244         _approve(_msgSender(), spender, amount);
245         return true;
246     }
247 
248     function transferFrom(
249         address sender,
250         address recipient,
251         uint256 amount
252     ) public override returns (bool) {
253         _transfer(sender, recipient, amount);
254         _approve(
255             sender,
256             _msgSender(),
257             _allowances[sender][_msgSender()].sub(
258                 amount,
259                 "ERC20: transfer amount exceeds allowance"
260             )
261         );
262         return true;
263     }
264 
265     function tokenFromReflection(uint256 rAmount)
266         private
267         view
268         returns (uint256)
269     {
270         require(
271             rAmount <= _rTotal,
272             "Amount must be less than total reflections"
273         );
274         uint256 currentRate = _getRate();
275         return rAmount.div(currentRate);
276     }
277 
278     function removeAllFee() private {
279         if (_redisFee == 0 && _taxFee == 0) return;
280 
281         _previousredisFee = _redisFee;
282         _previoustaxFee = _taxFee;
283 
284         _redisFee = 0;
285         _taxFee = 0;
286     }
287 
288     function restoreAllFee() private {
289         _redisFee = _previousredisFee;
290         _taxFee = _previoustaxFee;
291     }
292 
293     function _approve(
294         address owner,
295         address spender,
296         uint256 amount
297     ) private {
298         require(owner != address(0), "ERC20: approve from the zero address");
299         require(spender != address(0), "ERC20: approve to the zero address");
300         _allowances[owner][spender] = amount;
301         emit Approval(owner, spender, amount);
302     }
303 
304     function _transfer(
305         address from,
306         address to,
307         uint256 amount
308     ) private {
309         require(from != address(0), "ERC20: transfer from the zero address");
310         require(to != address(0), "ERC20: transfer to the zero address");
311         require(amount > 0, "Transfer amount must be greater than zero");
312 
313         if (from != owner() && to != owner()) {
314 
315             //Trade start check
316             if (!tradingOpen) {
317                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
318             }
319 
320             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
321             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
322 
323             if(to != uniswapV2Pair) {
324                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
325             }
326 
327             uint256 contractTokenBalance = balanceOf(address(this));
328             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
329 
330             if(contractTokenBalance >= _maxTxAmount)
331             {
332                 contractTokenBalance = _maxTxAmount;
333             }
334 
335             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
336                 swapTokensForEth(contractTokenBalance);
337                 uint256 contractETHBalance = address(this).balance;
338                 if (contractETHBalance > 0) {
339                     sendETHToFee(address(this).balance);
340                 }
341             }
342         }
343 
344         bool takeFee = true;
345 
346         //Transfer Tokens
347         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
348             takeFee = false;
349         } else {
350 
351             //Set Fee for Buys
352             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
353                 _redisFee = _redisFeeOnBuy;
354                 _taxFee = _taxFeeOnBuy;
355             }
356 
357             //Set Fee for Sells
358             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
359                 _redisFee = _redisFeeOnSell;
360                 _taxFee = _taxFeeOnSell;
361             }
362 
363         }
364 
365         _tokenTransfer(from, to, amount, takeFee);
366     }
367 
368     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
369         address[] memory path = new address[](2);
370         path[0] = address(this);
371         path[1] = uniswapV2Router.WETH();
372         _approve(address(this), address(uniswapV2Router), tokenAmount);
373         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
374             tokenAmount,
375             0,
376             path,
377             address(this),
378             0x0000000000000000000000000000000000000000,
379             block.timestamp
380         );
381     }
382 
383     function sendETHToFee(uint256 amount) private {
384         _marketingAddress.transfer(amount);
385     }
386     //Camelot Dex Router 0xc873fEcbd354f5A56E00E710B90EF4201db2448d
387     function setTrading(bool _tradingOpen) public onlyOwner {
388         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
389         uniswapV2Router = _uniswapV2Router;
390         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
391             .createPair(address(this), _uniswapV2Router.WETH());
392         tradingOpen = _tradingOpen;
393     }
394 
395     function manualswap() external {
396         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
397         uint256 contractBalance = balanceOf(address(this));
398         swapTokensForEth(contractBalance);
399     }
400 
401     function manualsend() external {
402         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
403         uint256 contractETHBalance = address(this).balance;
404         sendETHToFee(contractETHBalance);
405     }
406 
407     function _tokenTransfer(
408         address sender,
409         address recipient,
410         uint256 amount,
411         bool takeFee
412     ) private {
413         if (!takeFee) removeAllFee();
414         _transferStandard(sender, recipient, amount);
415         if (!takeFee) restoreAllFee();
416     }
417 
418     function _transferStandard(
419         address sender,
420         address recipient,
421         uint256 tAmount
422     ) private {
423         (
424             uint256 rAmount,
425             uint256 rTransferAmount,
426             uint256 rFee,
427             uint256 tTransferAmount,
428             uint256 tFee,
429             uint256 tTeam
430         ) = _getValues(tAmount);
431         _rOwned[sender] = _rOwned[sender].sub(rAmount);
432         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
433         _takeTeam(tTeam);
434         _reflectFee(rFee, tFee);
435         emit Transfer(sender, recipient, tTransferAmount);
436     }
437 
438     function _takeTeam(uint256 tTeam) private {
439         uint256 currentRate = _getRate();
440         uint256 rTeam = tTeam.mul(currentRate);
441         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
442     }
443 
444     function _reflectFee(uint256 rFee, uint256 tFee) private {
445         _rTotal = _rTotal.sub(rFee);
446         _tFeeTotal = _tFeeTotal.add(tFee);
447     }
448 
449     receive() external payable {}
450 
451     function _getValues(uint256 tAmount)
452         private
453         view
454         returns (
455             uint256,
456             uint256,
457             uint256,
458             uint256,
459             uint256,
460             uint256
461         )
462     {
463         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
464             _getTValues(tAmount, _redisFee, _taxFee);
465         uint256 currentRate = _getRate();
466         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
467             _getRValues(tAmount, tFee, tTeam, currentRate);
468         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
469     }
470 
471     function _getTValues(
472         uint256 tAmount,
473         uint256 redisFee,
474         uint256 taxFee
475     )
476         private
477         pure
478         returns (
479             uint256,
480             uint256,
481             uint256
482         )
483     {
484         uint256 tFee = tAmount.mul(redisFee).div(100);
485         uint256 tTeam = tAmount.mul(taxFee).div(100);
486         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
487         return (tTransferAmount, tFee, tTeam);
488     }
489 
490     function _getRValues(
491         uint256 tAmount,
492         uint256 tFee,
493         uint256 tTeam,
494         uint256 currentRate
495     )
496         private
497         pure
498         returns (
499             uint256,
500             uint256,
501             uint256
502         )
503     {
504         uint256 rAmount = tAmount.mul(currentRate);
505         uint256 rFee = tFee.mul(currentRate);
506         uint256 rTeam = tTeam.mul(currentRate);
507         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
508         return (rAmount, rTransferAmount, rFee);
509     }
510 
511     function _getRate() private view returns (uint256) {
512         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
513         return rSupply.div(tSupply);
514     }
515 
516     function _getCurrentSupply() private view returns (uint256, uint256) {
517         uint256 rSupply = _rTotal;
518         uint256 tSupply = _tTotal;
519         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
520         return (rSupply, tSupply);
521     }
522 
523     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
524         _redisFeeOnBuy = redisFeeOnBuy;
525         _redisFeeOnSell = redisFeeOnSell;
526         _taxFeeOnBuy = taxFeeOnBuy;
527         _taxFeeOnSell = taxFeeOnSell;
528     }
529 
530     //Set minimum tokens required to swap.
531     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
532         _swapTokensAtAmount = swapTokensAtAmount;
533     }
534 
535     //Set minimum tokens required to swap.
536     function toggleSwap(bool _swapEnabled) public onlyOwner {
537         swapEnabled = _swapEnabled;
538     }
539 
540     //Set maximum transaction
541     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
542         _maxTxAmount = maxTxAmount;
543     }
544 
545     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
546         _maxWalletSize = maxWalletSize;
547     }
548 
549     function setMaxAll() public onlyOwner {
550         _maxWalletSize = _tTotal;
551         _maxTxAmount = _tTotal;
552     }
553 }