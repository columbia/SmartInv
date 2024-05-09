1 /**
2 https://linktr.ee/opmerc
3 */
4 
5 
6 
7 // SPDX-License-Identifier: Unlicensed
8 pragma solidity ^0.8.9;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 }
15  
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18 
19     function balanceOf(address account) external view returns (uint256);
20 
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     function allowance(address owner, address spender) external view returns (uint256);
24 
25     function approve(address spender, uint256 amount) external returns (bool);
26 
27     function transferFrom(
28         address sender,
29         address recipient,
30         uint256 amount
31     ) external returns (bool);
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(
35         address indexed owner,
36         address indexed spender,
37         uint256 value
38     );  
39 }
40 
41 contract Ownable is Context {
42     address private _owner;
43     address private _previousOwner;
44     event OwnershipTransferred(
45         address indexed previousOwner,
46         address indexed newOwner
47     );
48 
49     constructor() {
50         address msgSender = _msgSender();
51         _owner = msgSender;
52         emit OwnershipTransferred(address(0), msgSender);
53     }
54 
55     function owner() public view returns (address) {
56         return _owner;
57     }
58 
59     modifier onlyOwner() {
60         require(_owner == _msgSender(), "Ownable: caller is not the owner");
61         _;
62     }
63 
64     function renounceOwnership() public virtual onlyOwner {
65         emit OwnershipTransferred(_owner, address(0));
66         _owner = address(0);
67     }
68 
69     function transferOwnership(address newOwner) public virtual onlyOwner {
70         require(newOwner != address(0), "Ownable: new owner is the zero address");
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 
75 }
76 
77 library SafeMath {
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a, "SafeMath: addition overflow");
81         return c;
82     }
83 
84     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85         return sub(a, b, "SafeMath: subtraction overflow");
86     }
87 
88     function sub(
89         uint256 a,
90         uint256 b,
91         string memory errorMessage
92     ) internal pure returns (uint256) {
93         require(b <= a, errorMessage);
94         uint256 c = a - b;
95         return c;
96     }
97 
98     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99         if (a == 0) {
100             return 0;
101         }
102         uint256 c = a * b;
103         require(c / a == b, "SafeMath: multiplication overflow");
104         return c;
105     }
106 
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         return div(a, b, "SafeMath: division by zero");
109     }
110 
111     function div(
112         uint256 a,
113         uint256 b,
114         string memory errorMessage
115     ) internal pure returns (uint256) {
116         require(b > 0, errorMessage);
117         uint256 c = a / b;
118         return c;
119     }
120 }
121 
122 interface IUniswapV2Factory {
123     function createPair(address tokenA, address tokenB)
124         external
125         returns (address pair);
126 }
127 
128 interface IUniswapV2Router02 {
129     function swapExactTokensForETHSupportingFeeOnTransferTokens(
130         uint256 amountIn,
131         uint256 amountOutMin,
132         address[] calldata path,
133         address to,
134         address referrer,
135         uint256 deadline
136     ) external;
137 
138     function factory() external pure returns (address);
139 
140     function WETH() external pure returns (address);
141 }
142 
143 contract OnePunchMan is Context, IERC20, Ownable {
144 
145     using SafeMath for uint256;
146 
147     string private constant _name = unicode"One Punch Man";
148     string private constant _symbol = unicode"OPM";
149     uint8 private constant _decimals = 9;
150  
151     mapping(address => uint256) private _rOwned;
152     mapping(address => uint256) private _tOwned;
153     mapping(address => mapping(address => uint256)) private _allowances;
154     mapping(address => bool) private _isExcludedFromFee;
155     uint256 private constant MAX = ~uint256(0);
156     uint256 private constant _tTotal = 110_000_000_000 * 10**_decimals;
157     uint256 private _rTotal = (MAX - (MAX % _tTotal));
158     uint256 private _tFeeTotal;
159     uint256 private _redisFeeOnBuy = 0;
160     uint256 private _taxFeeOnBuy = 15;
161     uint256 private _redisFeeOnSell = 0;
162     uint256 private _taxFeeOnSell = 55;
163   
164     uint256 private _redisFee = _redisFeeOnSell;
165     uint256 private _taxFee = _taxFeeOnSell;
166 
167     uint256 private _previousredisFee = _redisFee;
168     uint256 private _previoustaxFee = _taxFee;
169 
170     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
171     address payable private _developmentAddress = payable(0xD656794E4f6b3cD04290a21947a66300BA0Faa8d);
172     address payable private _marketingAddress = payable(0xD656794E4f6b3cD04290a21947a66300BA0Faa8d);
173 
174     IUniswapV2Router02 public uniswapV2Router;
175     address public uniswapV2Pair;
176 
177     bool private tradingOpen = true;
178     bool private inSwap = false;
179     bool private swapEnabled = true;
180 
181     uint256 public _maxTxAmount =  2 * (_tTotal/100);
182     uint256 public _maxWalletSize = 2 * (_tTotal/100);
183     uint256 public _swapTokensAtAmount = 20 *(_tTotal/1000);
184 
185     event MaxTxAmountUpdated(uint256 _maxTxAmount);
186     modifier lockTheSwap {
187         inSwap = true;
188         _; 
189         inSwap = false;
190     }
191 
192     constructor() {
193         _rOwned[_msgSender()] = _rTotal;
194 
195         _isExcludedFromFee[owner()] = true;
196         _isExcludedFromFee[address(this)] = true;
197         _isExcludedFromFee[_developmentAddress] = true;
198         _isExcludedFromFee[_marketingAddress] = true;
199 
200         emit Transfer(address(0), _msgSender(), _tTotal);
201     }
202 
203     function name() public pure returns (string memory) {
204         return _name;
205     }
206 
207     function symbol() public pure returns (string memory) {
208         return _symbol;
209     }
210 
211     function decimals() public pure returns (uint8) {
212         return _decimals;
213     }
214 
215     function totalSupply() public pure override returns (uint256) {
216         return _tTotal;
217     }
218 
219     function balanceOf(address account) public view override returns (uint256) {
220         return tokenFromReflection(_rOwned[account]);
221     }
222 
223     function transfer(address recipient, uint256 amount)
224         public
225         override
226         returns (bool)
227     {
228         _transfer(_msgSender(), recipient, amount);
229         return true;
230     }
231 
232     function allowance(address owner, address spender)
233         public
234         view
235         override
236         returns (uint256)
237     {
238         return _allowances[owner][spender];
239     }
240 
241     function approve(address spender, uint256 amount)
242         public
243         override
244         returns (bool)
245     {
246         _approve(_msgSender(), spender, amount);
247         return true;
248     }
249 
250     function transferFrom(
251         address sender,
252         address recipient,
253         uint256 amount
254     ) public override returns (bool) {
255         _transfer(sender, recipient, amount);
256         _approve(
257             sender,
258             _msgSender(),
259             _allowances[sender][_msgSender()].sub(
260                 amount,
261                 "ERC20: transfer amount exceeds allowance"
262             )
263         );
264         return true;
265     }
266 
267     function tokenFromReflection(uint256 rAmount)
268         private
269         view
270         returns (uint256)
271     {
272         require(
273             rAmount <= _rTotal,
274             "Amount must be less than total reflections"
275         );
276         uint256 currentRate = _getRate();
277         return rAmount.div(currentRate);
278     }
279 
280     function removeAllFee() private {
281         if (_redisFee == 0 && _taxFee == 0) return;
282 
283         _previousredisFee = _redisFee;
284         _previoustaxFee = _taxFee;
285 
286         _redisFee = 0;
287         _taxFee = 0;
288     }
289 
290     function restoreAllFee() private {
291         _redisFee = _previousredisFee;
292         _taxFee = _previoustaxFee;
293     }
294 
295     function _approve(
296         address owner,
297         address spender,
298         uint256 amount
299     ) private {
300         require(owner != address(0), "ERC20: approve from the zero address");
301         require(spender != address(0), "ERC20: approve to the zero address");
302         _allowances[owner][spender] = amount;
303         emit Approval(owner, spender, amount);
304     }
305 
306     function _transfer(
307         address from,
308         address to,
309         uint256 amount
310     ) private {
311         require(from != address(0), "ERC20: transfer from the zero address");
312         require(to != address(0), "ERC20: transfer to the zero address");
313         require(amount > 0, "Transfer amount must be greater than zero");
314 
315         if (from != owner() && to != owner()) {
316 
317             //Trade start check
318             if (!tradingOpen) {
319                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
320             }
321 
322             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
323             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
324 
325             if(to != uniswapV2Pair) {
326                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
327             }
328 
329             uint256 contractTokenBalance = balanceOf(address(this));
330             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
331 
332             if(contractTokenBalance >= _maxTxAmount)
333             {
334                 contractTokenBalance = _maxTxAmount;
335             }
336 
337             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
338                 swapTokensForEth(contractTokenBalance);
339                 uint256 contractETHBalance = address(this).balance;
340                 if (contractETHBalance > 0) {
341                     sendETHToFee(address(this).balance);
342                 }
343             }
344         }
345 
346         bool takeFee = true;
347 
348         //Transfer Tokens
349         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
350             takeFee = false;
351         } else {
352 
353             //Set Fee for Buys
354             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
355                 _redisFee = _redisFeeOnBuy;
356                 _taxFee = _taxFeeOnBuy;
357             }
358 
359             //Set Fee for Sells
360             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
361                 _redisFee = _redisFeeOnSell;
362                 _taxFee = _taxFeeOnSell;
363             }
364 
365         }
366 
367         _tokenTransfer(from, to, amount, takeFee);
368     }
369 
370     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
371         address[] memory path = new address[](2);
372         path[0] = address(this);
373         path[1] = uniswapV2Router.WETH();
374         _approve(address(this), address(uniswapV2Router), tokenAmount);
375         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
376             tokenAmount,
377             0,
378             path,
379             address(this),
380             0x0000000000000000000000000000000000000000,
381             block.timestamp
382         );
383     }
384 
385     function sendETHToFee(uint256 amount) private {
386         _marketingAddress.transfer(amount);
387     }
388     //Camelot Dex Router 0xc873fEcbd354f5A56E00E710B90EF4201db2448d
389     function setTrading(bool _tradingOpen) public onlyOwner {
390         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
391         uniswapV2Router = _uniswapV2Router;
392         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
393             .createPair(address(this), _uniswapV2Router.WETH());
394         tradingOpen = _tradingOpen;
395     }
396 
397     function manualswap() external {
398         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
399         uint256 contractBalance = balanceOf(address(this));
400         swapTokensForEth(contractBalance);
401     }
402 
403     function manualsend() external {
404         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
405         uint256 contractETHBalance = address(this).balance;
406         sendETHToFee(contractETHBalance);
407     }
408 
409     function _tokenTransfer(
410         address sender,
411         address recipient,
412         uint256 amount,
413         bool takeFee
414     ) private {
415         if (!takeFee) removeAllFee();
416         _transferStandard(sender, recipient, amount);
417         if (!takeFee) restoreAllFee();
418     }
419 
420     function _transferStandard(
421         address sender,
422         address recipient,
423         uint256 tAmount
424     ) private {
425         (
426             uint256 rAmount,
427             uint256 rTransferAmount,
428             uint256 rFee,
429             uint256 tTransferAmount,
430             uint256 tFee,
431             uint256 tTeam
432         ) = _getValues(tAmount);
433         _rOwned[sender] = _rOwned[sender].sub(rAmount);
434         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
435         _takeTeam(tTeam);
436         _reflectFee(rFee, tFee);
437         emit Transfer(sender, recipient, tTransferAmount);
438     }
439 
440     function _takeTeam(uint256 tTeam) private {
441         uint256 currentRate = _getRate();
442         uint256 rTeam = tTeam.mul(currentRate);
443         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
444     }
445 
446     function _reflectFee(uint256 rFee, uint256 tFee) private {
447         _rTotal = _rTotal.sub(rFee);
448         _tFeeTotal = _tFeeTotal.add(tFee);
449     }
450 
451     receive() external payable {}
452 
453     function _getValues(uint256 tAmount)
454         private
455         view
456         returns (
457             uint256,
458             uint256,
459             uint256,
460             uint256,
461             uint256,
462             uint256
463         )
464     {
465         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
466             _getTValues(tAmount, _redisFee, _taxFee);
467         uint256 currentRate = _getRate();
468         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
469             _getRValues(tAmount, tFee, tTeam, currentRate);
470         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
471     }
472 
473     function _getTValues(
474         uint256 tAmount,
475         uint256 redisFee,
476         uint256 taxFee
477     )
478         private
479         pure
480         returns (
481             uint256,
482             uint256,
483             uint256
484         )
485     {
486         uint256 tFee = tAmount.mul(redisFee).div(100);
487         uint256 tTeam = tAmount.mul(taxFee).div(100);
488         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
489         return (tTransferAmount, tFee, tTeam);
490     }
491 
492     function _getRValues(
493         uint256 tAmount,
494         uint256 tFee,
495         uint256 tTeam,
496         uint256 currentRate
497     )
498         private
499         pure
500         returns (
501             uint256,
502             uint256,
503             uint256
504         )
505     {
506         uint256 rAmount = tAmount.mul(currentRate);
507         uint256 rFee = tFee.mul(currentRate);
508         uint256 rTeam = tTeam.mul(currentRate);
509         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
510         return (rAmount, rTransferAmount, rFee);
511     }
512 
513     function _getRate() private view returns (uint256) {
514         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
515         return rSupply.div(tSupply);
516     }
517 
518     function _getCurrentSupply() private view returns (uint256, uint256) {
519         uint256 rSupply = _rTotal;
520         uint256 tSupply = _tTotal;
521         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
522         return (rSupply, tSupply);
523     }
524 
525     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
526         _redisFeeOnBuy = redisFeeOnBuy;
527         _redisFeeOnSell = redisFeeOnSell;
528         _taxFeeOnBuy = taxFeeOnBuy;
529         _taxFeeOnSell = taxFeeOnSell;
530     }
531 
532     //Set minimum tokens required to swap.
533     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
534         _swapTokensAtAmount = swapTokensAtAmount;
535     }
536 
537     //Set minimum tokens required to swap.
538     function toggleSwap(bool _swapEnabled) public onlyOwner {
539         swapEnabled = _swapEnabled;
540     }
541 
542     //Set maximum transaction
543     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
544         _maxTxAmount = maxTxAmount;
545     }
546 
547     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
548         _maxWalletSize = maxWalletSize;
549     }
550 
551     function setMaxAll() public onlyOwner {
552         _maxWalletSize = _tTotal;
553         _maxTxAmount = _tTotal;
554     }
555 }