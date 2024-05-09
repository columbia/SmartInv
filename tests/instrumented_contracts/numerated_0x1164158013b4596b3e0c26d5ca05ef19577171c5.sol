1 /*
2 https://www.bitcoin3.info/
3 
4 https://t.me/officialbitcoin3
5 
6 hi! if you are a degen or even just an gambling addicted investor,
7 bitcoin 3.0 might be for you. don't flip your car, house, wife, kids
8 or other valuable asset. consider it a degen play and a fun movement.
9 
10 always refresh the website for my announcements. this is the way i comunicate with you.
11 
12 
13 $BTC3.0
14 */
15 
16 // pragma solidity ^0.8.9; 
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
166 contract BTC3 is Context, IERC20, Ownable {
167 
168     using SafeMath for uint256;
169 
170     string private constant _name = "BTC3.0";
171     string private constant _symbol = "BTC3.0";
172     uint8 private constant _decimals = 9;
173 
174     mapping(address => uint256) private _rOwned;
175     mapping(address => uint256) private _tOwned;
176     mapping(address => mapping(address => uint256)) private _allowances;
177     mapping(address => bool) private _isExcludedFromFee;
178     uint256 private constant MAX = ~uint256(0);
179     uint256 private constant _tTotal = 21000000 * 10**9;
180     uint256 private _rTotal = (MAX - (MAX % _tTotal));
181     uint256 private _tFeeTotal;
182     uint256 private _redisFeeOnBuy = 0;
183     uint256 private _taxFeeOnBuy = 21;
184     uint256 private _redisFeeOnSell = 0;
185     uint256 private _taxFeeOnSell = 21;
186 
187     //Original Fee
188     uint256 private _redisFee = _redisFeeOnSell;
189     uint256 private _taxFee = _taxFeeOnSell;
190 
191     uint256 private _previousredisFee = _redisFee;
192     uint256 private _previoustaxFee = _taxFee;
193 
194     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
195     address payable private _marketingAddress = payable(0x376ecb4722Cd9D85F9A4Db02958B25904B77bB72);
196 
197     IUniswapV2Router02 public uniswapV2Router;
198     address public uniswapV2Pair;
199 
200     bool private limitsEffect = true;
201     bool private tradingOpen = true;
202     bool private inSwap = false;
203     bool private swapEnabled = true;
204 
205     uint256 public _maxTxnAmount = 420000 * 10**9;
206     uint256 public _maxWallet = 420000 * 10**9;
207     uint256 public _swapTokensAtAmnt = 21000 * 10**9;
208 
209     event MaxTxAmountUpdated(uint256 _maxTxAmount);
210     modifier lockTheSwap {
211         inSwap = true;
212         _;
213         inSwap = false;
214     }
215 
216     constructor() {
217 
218         _rOwned[_msgSender()] = _rTotal;
219 
220         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
221         uniswapV2Router = _uniswapV2Router;
222         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
223             .createPair(address(this), _uniswapV2Router.WETH());
224 
225         _isExcludedFromFee[owner()] = true;
226         _isExcludedFromFee[address(this)] = true;
227         _isExcludedFromFee[_marketingAddress] = true;
228 
229         emit Transfer(address(0), _msgSender(), _tTotal);
230     }
231 
232     function name() public pure returns (string memory) {
233         return _name;
234     }
235 
236     function symbol() public pure returns (string memory) {
237         return _symbol;
238     }
239 
240     function decimals() public pure returns (uint8) {
241         return _decimals;
242     }
243 
244     function totalSupply() public pure override returns (uint256) {
245         return _tTotal;
246     }
247 
248     function balanceOf(address account) public view override returns (uint256) {
249         return tokenFromReflection(_rOwned[account]);
250     }
251 
252     function transfer(address recipient, uint256 amount)
253         public
254         override
255         returns (bool)
256     {
257         _transfer(_msgSender(), recipient, amount);
258         return true;
259     }
260 
261     function allowance(address owner, address spender)
262         public
263         view
264         override
265         returns (uint256)
266     {
267         return _allowances[owner][spender];
268     }
269 
270     function approve(address spender, uint256 amount)
271         public
272         override
273         returns (bool)
274     {
275         _approve(_msgSender(), spender, amount);
276         return true;
277     }
278 
279     function transferFrom(
280         address sender,
281         address recipient,
282         uint256 amount
283     ) public override returns (bool) {
284         _transfer(sender, recipient, amount);
285         _approve(
286             sender,
287             _msgSender(),
288             _allowances[sender][_msgSender()].sub(
289                 amount,
290                 "ERC20: transfer amount exceeds allowance"
291             )
292         );
293         return true;
294     }
295 
296     function tokenFromReflection(uint256 rAmount)
297         private
298         view
299         returns (uint256)
300     {
301         require(
302             rAmount <= _rTotal,
303             "Amount must be less than total reflections"
304         );
305         uint256 currentRate = _getRate();
306         return rAmount.div(currentRate);
307     }
308 
309     function removeAllFee() private {
310         if (_redisFee == 0 && _taxFee == 0) return;
311 
312         _previousredisFee = _redisFee;
313         _previoustaxFee = _taxFee;
314 
315         _redisFee = 0;
316         _taxFee = 0;
317     }
318 
319     function restoreAllFee() private {
320         _redisFee = _previousredisFee;
321         _taxFee = _previoustaxFee;
322     }
323 
324     function _approve(
325         address owner,
326         address spender,
327         uint256 amount
328     ) private {
329         require(owner != address(0), "ERC20: approve from the zero address");
330         require(spender != address(0), "ERC20: approve to the zero address");
331         _allowances[owner][spender] = amount;
332         emit Approval(owner, spender, amount);
333     }
334 
335     function _transfer(
336         address from,
337         address to,
338         uint256 amount
339     ) private {
340         require(from != address(0), "ERC20: transfer from the zero address");
341         require(to != address(0), "ERC20: transfer to the zero address");
342         require(amount > 0, "Transfer amount must be greater than zero");
343 
344         if (from != owner() && to != owner()) {
345 
346             //Trade start check
347             if (!tradingOpen) {
348                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
349             }
350             if(limitsEffect) {
351                 require(amount <= _maxTxnAmount, "TOKEN: Max Transaction Limit");
352             
353 
354                 if(to != uniswapV2Pair) {
355                     require(balanceOf(to) + amount < _maxWallet, "TOKEN: Balance exceeds wallet size!");
356                 }
357             }
358 
359             uint256 contractTokenBalance = balanceOf(address(this));
360             bool canSwap = contractTokenBalance >= _swapTokensAtAmnt;
361 
362             if(contractTokenBalance >= _maxTxnAmount)
363             {
364                 contractTokenBalance = _maxTxnAmount;
365             }
366 
367             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
368                 swapTokensForEth(contractTokenBalance);
369                 uint256 contractETHBalance = address(this).balance;
370                 if (contractETHBalance > 0) {
371                     sendETHToFee(address(this).balance);
372                 }
373             }
374         }
375 
376         bool takeFee = true;
377 
378         //Transfer Tokens
379         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
380             takeFee = false;
381         } else {
382 
383             //Set Fee for Buys
384             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
385                 _taxFee = _taxFeeOnBuy;
386                 _redisFee = _redisFeeOnBuy;
387             }
388 
389             //Set Fee for Sells
390             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
391                 _taxFee = _taxFeeOnSell;
392                 _redisFee = _redisFeeOnSell;
393             }
394 
395         }
396 
397         _tokenTransfer(from, to, amount, takeFee);
398     }
399 
400     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
401         address[] memory path = new address[](2);
402         path[0] = address(this);
403         path[1] = uniswapV2Router.WETH();
404         _approve(address(this), address(uniswapV2Router), tokenAmount);
405         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
406             tokenAmount,
407             0,
408             path,
409             address(this),
410             block.timestamp
411         );
412     }
413 
414     function sendETHToFee(uint256 amount) private {
415         _marketingAddress.transfer(amount);
416     }
417 
418     function setTrading(bool _tradingOpen) public onlyOwner {
419         tradingOpen = _tradingOpen;
420     }
421 
422     function manualswap() external {
423         require(_msgSender() == _marketingAddress);
424         uint256 contractBalance = balanceOf(address(this));
425         swapTokensForEth(contractBalance);
426     }
427 
428     function manualsend() external {
429         require(_msgSender() == _marketingAddress);
430         uint256 contractETHBalance = address(this).balance;
431         sendETHToFee(contractETHBalance);
432     }
433 
434     function _tokenTransfer(
435         address sender,
436         address recipient,
437         uint256 amount,
438         bool takeFee
439     ) private {
440         if (!takeFee) removeAllFee();
441         _transferStandard(sender, recipient, amount);
442         if (!takeFee) restoreAllFee();
443     }
444 
445     function _transferStandard(
446         address sender,
447         address recipient,
448         uint256 tAmount
449     ) private {
450         (
451             uint256 rAmount,
452             uint256 rTransferAmount,
453             uint256 rFee,
454             uint256 tTransferAmount,
455             uint256 tFee,
456             uint256 tTeam
457         ) = _getValues(tAmount);
458         _rOwned[sender] = _rOwned[sender].sub(rAmount);
459         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
460         _takeTeam(tTeam);
461         _reflectFee(rFee, tFee);
462         emit Transfer(sender, recipient, tTransferAmount);
463     }
464 
465     function _takeTeam(uint256 tTeam) private {
466         uint256 currentRate = _getRate();
467         uint256 rTeam = tTeam.mul(currentRate);
468         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
469     }
470 
471     function _reflectFee(uint256 rFee, uint256 tFee) private {
472         _rTotal = _rTotal.sub(rFee);
473         _tFeeTotal = _tFeeTotal.add(tFee);
474     }
475 
476     receive() external payable {}
477 
478     function _getValues(uint256 tAmount)
479         private
480         view
481         returns (
482             uint256,
483             uint256,
484             uint256,
485             uint256,
486             uint256,
487             uint256
488         )
489     {
490         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
491             _getTValues(tAmount, _redisFee, _taxFee);
492         uint256 currentRate = _getRate();
493         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
494             _getRValues(tAmount, tFee, tTeam, currentRate);
495         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
496     }
497 
498     function _getTValues(
499         uint256 tAmount,
500         uint256 redisFee,
501         uint256 taxFee
502     )
503         private
504         pure
505         returns (
506             uint256,
507             uint256,
508             uint256
509         )
510     {
511         uint256 tFee = tAmount.mul(redisFee).div(100);
512         uint256 tTeam = tAmount.mul(taxFee).div(100);
513         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
514         return (tTransferAmount, tFee, tTeam);
515     }
516 
517     function _getRValues(
518         uint256 tAmount,
519         uint256 tFee,
520         uint256 tTeam,
521         uint256 currentRate
522     )
523         private
524         pure
525         returns (
526             uint256,
527             uint256,
528             uint256
529         )
530     {
531         uint256 rAmount = tAmount.mul(currentRate);
532         uint256 rFee = tFee.mul(currentRate);
533         uint256 rTeam = tTeam.mul(currentRate);
534         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
535         return (rAmount, rTransferAmount, rFee);
536     }
537 
538     function _getRate() private view returns (uint256) {
539         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
540         return rSupply.div(tSupply);
541     }
542 
543     function _getCurrentSupply() private view returns (uint256, uint256) {
544         uint256 rSupply = _rTotal;
545         uint256 tSupply = _tTotal;
546         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
547         return (rSupply, tSupply);
548     }
549 
550     function toggleSwap(bool _swapEnabled) public onlyOwner {
551         swapEnabled = _swapEnabled;
552     }
553 
554     function removeLimits() public onlyOwner {
555         limitsEffect = false;
556     }
557 
558     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
559         _redisFeeOnBuy = redisFeeOnBuy;
560         _redisFeeOnSell = redisFeeOnSell;
561         _taxFeeOnBuy = taxFeeOnBuy;
562         _taxFeeOnSell = taxFeeOnSell;
563     }
564 
565      function setMaxWallet(uint256 maxWalletSize) public onlyOwner {
566         _maxWallet = maxWalletSize;
567     }
568 
569     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
570         _swapTokensAtAmnt = swapTokensAtAmount;
571     }
572 
573 
574     function setMaxTxAmount(uint256 maxTxAmount) public onlyOwner {
575         _maxTxnAmount = maxTxAmount;
576     }
577 
578 }