1 /**
2 A ronin was a samurai warrior in feudal Japan without a master or lord — known as a daimyo. A samurai could become a ronin in several different ways: his master might die or fall from power or the samurai might lose his master's favor or patronage and be cast off.
3 
4 
5 https://shibaronin.com
6 https://t.me/shibaronin
7 https://twitter.com/shiba_ronin
8 */
9 
10 
11 
12 pragma solidity ^0.8.4;
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
162 contract ShibaRonin is Context, IERC20, Ownable {///////////////////////////////////////////////////////////
163 
164     using SafeMath for uint256;
165 
166     string private constant _name = "ShibaRonin";//////////////////////////
167     string private constant _symbol = "SHONIN";//////////////////////////////////////////////////////////////////////////
168     uint8 private constant _decimals = 9;
169 
170     mapping(address => uint256) private _rOwned;
171     mapping(address => uint256) private _tOwned;
172     mapping(address => mapping(address => uint256)) private _allowances;
173     mapping(address => bool) private _isExcludedFromFee;
174     uint256 private constant MAX = ~uint256(0);
175     uint256 private constant _tTotal = 10000000 * 10**9;
176     uint256 private _rTotal = (MAX - (MAX % _tTotal));
177     uint256 private _tFeeTotal;
178 
179     //Buy Fee
180     uint256 private _redisFeeOnBuy = 1;////////////////////////////////////////////////////////////////////
181     uint256 private _taxFeeOnBuy = 11;//////////////////////////////////////////////////////////////////////
182 
183     //Sell Fee
184     uint256 private _redisFeeOnSell = 1;/////////////////////////////////////////////////////////////////////
185     uint256 private _taxFeeOnSell = 16;/////////////////////////////////////////////////////////////////////
186 
187     //Original Fee
188     uint256 private _redisFee = _redisFeeOnSell;
189     uint256 private _taxFee = _taxFeeOnSell;
190 
191     uint256 private _previousredisFee = _redisFee;
192     uint256 private _previoustaxFee = _taxFee;
193 
194     mapping(address => bool) public bots;
195     mapping(address => uint256) private cooldown;
196 
197     address payable private _developmentAddress = payable(0x44a8c837f7f1Eb632938c2D5cE7B64e6F326593a);/////////////////////////////////////////////////
198     address payable private _marketingAddress = payable(0xae3ff1bA3aa23350364397c038CAB00B4B113209);///////////////////////////////////////////////////
199 
200     IUniswapV2Router02 public uniswapV2Router;
201     address public uniswapV2Pair;
202 
203     bool private tradingOpen;
204     bool private inSwap = false;
205     bool private swapEnabled = true;
206 
207     uint256 public _maxTxAmount = 100000 * 10**9; //1%
208     uint256 public _maxWalletSize = 200000 * 10**9; //2%
209     uint256 public _swapTokensAtAmount = 10000 * 10**9; //0.1%
210 
211     event MaxTxAmountUpdated(uint256 _maxTxAmount);
212     modifier lockTheSwap {
213         inSwap = true;
214         _;
215         inSwap = false;
216     }
217 
218     constructor() {
219 
220         _rOwned[_msgSender()] = _rTotal;
221 
222         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);/////////////////////////////////////////////////
223         uniswapV2Router = _uniswapV2Router;
224         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
225             .createPair(address(this), _uniswapV2Router.WETH());
226 
227         _isExcludedFromFee[owner()] = true;
228         _isExcludedFromFee[address(this)] = true;
229         _isExcludedFromFee[_developmentAddress] = true;
230         _isExcludedFromFee[_marketingAddress] = true;
231 
232         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
233         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
234         bots[address(0x34822A742BDE3beF13acabF14244869841f06A73)] = true;
235         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
236         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
237         bots[address(0x8484eFcBDa76955463aa12e1d504D7C6C89321F8)] = true;
238         bots[address(0xe5265ce4D0a3B191431e1bac056d72b2b9F0Fe44)] = true;
239         bots[address(0x33F9Da98C57674B5FC5AE7349E3C732Cf2E6Ce5C)] = true;
240         bots[address(0xc59a8E2d2c476BA9122aa4eC19B4c5E2BBAbbC28)] = true;
241         bots[address(0x21053Ff2D9Fc37D4DB8687d48bD0b57581c1333D)] = true;
242         bots[address(0x4dd6A0D3191A41522B84BC6b65d17f6f5e6a4192)] = true;
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