1 /**
2 */
3 
4 /*
5 Exa Dark Sideræl
6 A Meme Project by @DetectiveCalls
7 
8 An ERC token to honor the birth of Elon Musk and Grimes’ second child, EXA DARK SIDERÆL.
9 
10 
11 Total Tax 10% 
12 Max buy 100,000 Tokens
13 Max Wallet 200,000 Tokens
14 Liquidity will be locked for 30 days.
15 
16 
17 Telegram : https://t.me/ExaDarkSideraelERC
18 
19 */
20 
21 // SPDX-License-Identifier: UNLICENSED
22 pragma solidity ^0.8.4;
23 
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 }
29 
30 interface IERC20 {
31     function totalSupply() external view returns (uint256);
32 
33     function balanceOf(address account) external view returns (uint256);
34 
35     function transfer(address recipient, uint256 amount) external returns (bool);
36 
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     function approve(address spender, uint256 amount) external returns (bool);
40 
41     function transferFrom(
42         address sender,
43         address recipient,
44         uint256 amount
45     ) external returns (bool);
46 
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     event Approval(
49         address indexed owner,
50         address indexed spender,
51         uint256 value
52     );
53 }
54 
55 contract Ownable is Context {
56     address private _owner;
57     address private _previousOwner;
58     event OwnershipTransferred(
59         address indexed previousOwner,
60         address indexed newOwner
61     );
62 
63     constructor() {
64         address msgSender = _msgSender();
65         _owner = msgSender;
66         emit OwnershipTransferred(address(0), msgSender);
67     }
68 
69     function owner() public view returns (address) {
70         return _owner;
71     }
72 
73     modifier onlyOwner() {
74         require(_owner == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     function renounceOwnership() public virtual onlyOwner {
79         emit OwnershipTransferred(_owner, address(0));
80         _owner = address(0);
81     }
82 
83     function transferOwnership(address newOwner) public virtual onlyOwner {
84         require(newOwner != address(0), "Ownable: new owner is the zero address");
85         emit OwnershipTransferred(_owner, newOwner);
86         _owner = newOwner;
87     }
88 
89 }
90 
91 library SafeMath {
92     function add(uint256 a, uint256 b) internal pure returns (uint256) {
93         uint256 c = a + b;
94         require(c >= a, "SafeMath: addition overflow");
95         return c;
96     }
97 
98     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
99         return sub(a, b, "SafeMath: subtraction overflow");
100     }
101 
102     function sub(
103         uint256 a,
104         uint256 b,
105         string memory errorMessage
106     ) internal pure returns (uint256) {
107         require(b <= a, errorMessage);
108         uint256 c = a - b;
109         return c;
110     }
111 
112     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
113         if (a == 0) {
114             return 0;
115         }
116         uint256 c = a * b;
117         require(c / a == b, "SafeMath: multiplication overflow");
118         return c;
119     }
120 
121     function div(uint256 a, uint256 b) internal pure returns (uint256) {
122         return div(a, b, "SafeMath: division by zero");
123     }
124 
125     function div(
126         uint256 a,
127         uint256 b,
128         string memory errorMessage
129     ) internal pure returns (uint256) {
130         require(b > 0, errorMessage);
131         uint256 c = a / b;
132         return c;
133     }
134 }
135 
136 interface IUniswapV2Factory {
137     function createPair(address tokenA, address tokenB)
138         external
139         returns (address pair);
140 }
141 
142 interface IUniswapV2Router02 {
143     function swapExactTokensForETHSupportingFeeOnTransferTokens(
144         uint256 amountIn,
145         uint256 amountOutMin,
146         address[] calldata path,
147         address to,
148         uint256 deadline
149     ) external;
150 
151     function factory() external pure returns (address);
152 
153     function WETH() external pure returns (address);
154 
155     function addLiquidityETH(
156         address token,
157         uint256 amountTokenDesired,
158         uint256 amountTokenMin,
159         uint256 amountETHMin,
160         address to,
161         uint256 deadline
162     )
163         external
164         payable
165         returns (
166             uint256 amountToken,
167             uint256 amountETH,
168             uint256 liquidity
169         );
170 }
171 
172 contract ExaDarkSiderael is Context, IERC20, Ownable {///////////////////////////////////////////////////////////
173 
174     using SafeMath for uint256;
175 
176     string private constant _name = "ExaDarkSiderael";//////////////////////////
177     string private constant _symbol = "EDS";//////////////////////////////////////////////////////////////////////////
178     uint8 private constant _decimals = 9;
179 
180     mapping(address => uint256) private _rOwned;
181     mapping(address => uint256) private _tOwned;
182     mapping(address => mapping(address => uint256)) private _allowances;
183     mapping(address => bool) private _isExcludedFromFee;
184     uint256 private constant MAX = ~uint256(0);
185     uint256 private constant _tTotal = 10000000 * 10**9;
186     uint256 private _rTotal = (MAX - (MAX % _tTotal));
187     uint256 private _tFeeTotal;
188 
189     //Buy Fee
190     uint256 private _redisFeeOnBuy = 1;////////////////////////////////////////////////////////////////////
191     uint256 private _taxFeeOnBuy = 12;//////////////////////////////////////////////////////////////////////
192 
193     //Sell Fee
194     uint256 private _redisFeeOnSell = 1;/////////////////////////////////////////////////////////////////////
195     uint256 private _taxFeeOnSell = 12;/////////////////////////////////////////////////////////////////////
196 
197     //Original Fee
198     uint256 private _redisFee = _redisFeeOnSell;
199     uint256 private _taxFee = _taxFeeOnSell;
200 
201     uint256 private _previousredisFee = _redisFee;
202     uint256 private _previoustaxFee = _taxFee;
203 
204     mapping(address => bool) public bots;
205     mapping(address => uint256) private cooldown;
206 
207     address payable private _developmentAddress = payable(0x2eDf7c739d4a29bA6eE727C81dA56579aeC5D472);/////////////////////////////////////////////////
208     address payable private _marketingAddress = payable(0x2eDf7c739d4a29bA6eE727C81dA56579aeC5D472);///////////////////////////////////////////////////
209 
210     IUniswapV2Router02 public uniswapV2Router;
211     address public uniswapV2Pair;
212 
213     bool private tradingOpen;
214     bool private inSwap = false;
215     bool private swapEnabled = true;
216 
217     uint256 public _maxTxAmount = 100000 * 10**9; //1%
218     uint256 public _maxWalletSize = 200000 * 10**9; //1%
219     uint256 public _swapTokensAtAmount = 40000 * 10**9; //.4%
220 
221     event MaxTxAmountUpdated(uint256 _maxTxAmount);
222     modifier lockTheSwap {
223         inSwap = true;
224         _;
225         inSwap = false;
226     }
227 
228     constructor() {
229 
230         _rOwned[_msgSender()] = _rTotal;
231 
232         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);/////////////////////////////////////////////////
233         uniswapV2Router = _uniswapV2Router;
234         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
235             .createPair(address(this), _uniswapV2Router.WETH());
236 
237         _isExcludedFromFee[owner()] = true;
238         _isExcludedFromFee[address(this)] = true;
239         _isExcludedFromFee[_developmentAddress] = true;
240         _isExcludedFromFee[_marketingAddress] = true;
241 
242 
243 
244 
245         emit Transfer(address(0), _msgSender(), _tTotal);
246     }
247 
248     function name() public pure returns (string memory) {
249         return _name;
250     }
251 
252     function symbol() public pure returns (string memory) {
253         return _symbol;
254     }
255 
256     function decimals() public pure returns (uint8) {
257         return _decimals;
258     }
259 
260     function totalSupply() public pure override returns (uint256) {
261         return _tTotal;
262     }
263 
264     function balanceOf(address account) public view override returns (uint256) {
265         return tokenFromReflection(_rOwned[account]);
266     }
267 
268     function transfer(address recipient, uint256 amount)
269         public
270         override
271         returns (bool)
272     {
273         _transfer(_msgSender(), recipient, amount);
274         return true;
275     }
276 
277     function allowance(address owner, address spender)
278         public
279         view
280         override
281         returns (uint256)
282     {
283         return _allowances[owner][spender];
284     }
285 
286     function approve(address spender, uint256 amount)
287         public
288         override
289         returns (bool)
290     {
291         _approve(_msgSender(), spender, amount);
292         return true;
293     }
294 
295     function transferFrom(
296         address sender,
297         address recipient,
298         uint256 amount
299     ) public override returns (bool) {
300         _transfer(sender, recipient, amount);
301         _approve(
302             sender,
303             _msgSender(),
304             _allowances[sender][_msgSender()].sub(
305                 amount,
306                 "ERC20: transfer amount exceeds allowance"
307             )
308         );
309         return true;
310     }
311 
312     function tokenFromReflection(uint256 rAmount)
313         private
314         view
315         returns (uint256)
316     {
317         require(
318             rAmount <= _rTotal,
319             "Amount must be less than total reflections"
320         );
321         uint256 currentRate = _getRate();
322         return rAmount.div(currentRate);
323     }
324 
325     function removeAllFee() private {
326         if (_redisFee == 0 && _taxFee == 0) return;
327 
328         _previousredisFee = _redisFee;
329         _previoustaxFee = _taxFee;
330 
331         _redisFee = 0;
332         _taxFee = 0;
333     }
334 
335     function restoreAllFee() private {
336         _redisFee = _previousredisFee;
337         _taxFee = _previoustaxFee;
338     }
339 
340     function _approve(
341         address owner,
342         address spender,
343         uint256 amount
344     ) private {
345         require(owner != address(0), "ERC20: approve from the zero address");
346         require(spender != address(0), "ERC20: approve to the zero address");
347         _allowances[owner][spender] = amount;
348         emit Approval(owner, spender, amount);
349     }
350 
351     function _transfer(
352         address from,
353         address to,
354         uint256 amount
355     ) private {
356         require(from != address(0), "ERC20: transfer from the zero address");
357         require(to != address(0), "ERC20: transfer to the zero address");
358         require(amount > 0, "Transfer amount must be greater than zero");
359 
360         if (from != owner() && to != owner()) {
361 
362             //Trade start check
363             if (!tradingOpen) {
364                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
365             }
366 
367             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
368             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
369 
370             if(to != uniswapV2Pair) {
371                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
372             }
373 
374             uint256 contractTokenBalance = balanceOf(address(this));
375             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
376 
377             if(contractTokenBalance >= _maxTxAmount)
378             {
379                 contractTokenBalance = _maxTxAmount;
380             }
381 
382             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
383                 swapTokensForEth(contractTokenBalance);
384                 uint256 contractETHBalance = address(this).balance;
385                 if (contractETHBalance > 0) {
386                     sendETHToFee(address(this).balance);
387                 }
388             }
389         }
390 
391         bool takeFee = true;
392 
393         //Transfer Tokens
394         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
395             takeFee = false;
396         } else {
397 
398             //Set Fee for Buys
399             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
400                 _redisFee = _redisFeeOnBuy;
401                 _taxFee = _taxFeeOnBuy;
402             }
403 
404             //Set Fee for Sells
405             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
406                 _redisFee = _redisFeeOnSell;
407                 _taxFee = _taxFeeOnSell;
408             }
409 
410         }
411 
412         _tokenTransfer(from, to, amount, takeFee);
413     }
414 
415     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
416         address[] memory path = new address[](2);
417         path[0] = address(this);
418         path[1] = uniswapV2Router.WETH();
419         _approve(address(this), address(uniswapV2Router), tokenAmount);
420         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
421             tokenAmount,
422             0,
423             path,
424             address(this),
425             block.timestamp
426         );
427     }
428 
429     function sendETHToFee(uint256 amount) private {
430         _developmentAddress.transfer(amount.div(2));
431         _marketingAddress.transfer(amount.div(2));
432     }
433 
434     function setTrading(bool _tradingOpen) public onlyOwner {
435         tradingOpen = _tradingOpen;
436     }
437 
438     function manualswap() external {
439         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
440         uint256 contractBalance = balanceOf(address(this));
441         swapTokensForEth(contractBalance);
442     }
443 
444     function manualsend() external {
445         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
446         uint256 contractETHBalance = address(this).balance;
447         sendETHToFee(contractETHBalance);
448     }
449 
450     function blockBots(address[] memory bots_) public onlyOwner {
451         for (uint256 i = 0; i < bots_.length; i++) {
452             bots[bots_[i]] = true;
453         }
454     }
455 
456     function unblockBot(address notbot) public onlyOwner {
457         bots[notbot] = false;
458     }
459 
460     function _tokenTransfer(
461         address sender,
462         address recipient,
463         uint256 amount,
464         bool takeFee
465     ) private {
466         if (!takeFee) removeAllFee();
467         _transferStandard(sender, recipient, amount);
468         if (!takeFee) restoreAllFee();
469     }
470 
471     function _transferStandard(
472         address sender,
473         address recipient,
474         uint256 tAmount
475     ) private {
476         (
477             uint256 rAmount,
478             uint256 rTransferAmount,
479             uint256 rFee,
480             uint256 tTransferAmount,
481             uint256 tFee,
482             uint256 tTeam
483         ) = _getValues(tAmount);
484         _rOwned[sender] = _rOwned[sender].sub(rAmount);
485         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
486         _takeTeam(tTeam);
487         _reflectFee(rFee, tFee);
488         emit Transfer(sender, recipient, tTransferAmount);
489     }
490 
491     function _takeTeam(uint256 tTeam) private {
492         uint256 currentRate = _getRate();
493         uint256 rTeam = tTeam.mul(currentRate);
494         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
495     }
496 
497     function _reflectFee(uint256 rFee, uint256 tFee) private {
498         _rTotal = _rTotal.sub(rFee);
499         _tFeeTotal = _tFeeTotal.add(tFee);
500     }
501 
502     receive() external payable {}
503 
504     function _getValues(uint256 tAmount)
505         private
506         view
507         returns (
508             uint256,
509             uint256,
510             uint256,
511             uint256,
512             uint256,
513             uint256
514         )
515     {
516         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
517             _getTValues(tAmount, _redisFee, _taxFee);
518         uint256 currentRate = _getRate();
519         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
520             _getRValues(tAmount, tFee, tTeam, currentRate);
521 
522         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
523     }
524 
525     function _getTValues(
526         uint256 tAmount,
527         uint256 redisFee,
528         uint256 taxFee
529     )
530         private
531         pure
532         returns (
533             uint256,
534             uint256,
535             uint256
536         )
537     {
538         uint256 tFee = tAmount.mul(redisFee).div(100);
539         uint256 tTeam = tAmount.mul(taxFee).div(100);
540         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
541 
542         return (tTransferAmount, tFee, tTeam);
543     }
544 
545     function _getRValues(
546         uint256 tAmount,
547         uint256 tFee,
548         uint256 tTeam,
549         uint256 currentRate
550     )
551         private
552         pure
553         returns (
554             uint256,
555             uint256,
556             uint256
557         )
558     {
559         uint256 rAmount = tAmount.mul(currentRate);
560         uint256 rFee = tFee.mul(currentRate);
561         uint256 rTeam = tTeam.mul(currentRate);
562         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
563 
564         return (rAmount, rTransferAmount, rFee);
565     }
566 
567     function _getRate() private view returns (uint256) {
568         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
569 
570         return rSupply.div(tSupply);
571     }
572 
573     function _getCurrentSupply() private view returns (uint256, uint256) {
574         uint256 rSupply = _rTotal;
575         uint256 tSupply = _tTotal;
576         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
577 
578         return (rSupply, tSupply);
579     }
580 
581     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
582         _redisFeeOnBuy = redisFeeOnBuy;
583         _redisFeeOnSell = redisFeeOnSell;
584 
585         _taxFeeOnBuy = taxFeeOnBuy;
586         _taxFeeOnSell = taxFeeOnSell;
587     }
588 
589     //Set minimum tokens required to swap.
590     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
591         _swapTokensAtAmount = swapTokensAtAmount;
592     }
593 
594     //Set minimum tokens required to swap.
595     function toggleSwap(bool _swapEnabled) public onlyOwner {
596         swapEnabled = _swapEnabled;
597     }
598 
599 
600     //Set MAx transaction
601     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
602         _maxTxAmount = maxTxAmount;
603     }
604 
605     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
606         _maxWalletSize = maxWalletSize;
607     }
608 
609     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
610         for(uint256 i = 0; i < accounts.length; i++) {
611             _isExcludedFromFee[accounts[i]] = excluded;
612         }
613     }
614 }