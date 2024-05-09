1 // File: erc-20.sol
2 
3 /*
4 
5 ┌─┐┌─┐┌─┐┌┬┐┌─┐┬─┐┬┌─┐  ┌─┐┬─┐┌─┐┌┬┐┌─┐┌─┐┌─┐┬  
6 ├┤ └─┐│ │ │ ├┤ ├┬┘││    ├─┘├┬┘│ │ │ │ ││  │ ││  
7 └─┘└─┘└─┘ ┴ └─┘┴└─┴└─┘  ┴  ┴└─└─┘ ┴ └─┘└─┘└─┘┴─┘
8 
9 esoteric lphub verifier: 0x11e9a4d6850b7c8e5b9bb083693a0dbe2401a632#code
10 
11 esodao: 0xa94bfdb1c74721846908ea31fba0b7918e2c7ed9
12 
13 esogovernance: 0x647e44610cb6dd6a1913657416457de839403ed1
14 
15 esobank: 0x627b2c7309e822dfd4e0e1f9cdeb171ee18fe023
16 
17 */
18 
19 pragma solidity ^0.8.4;
20 
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 }
26 
27 interface IERC20 {
28     function totalSupply() external view returns (uint256);
29 
30     function balanceOf(address account) external view returns (uint256);
31 
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     function approve(address spender, uint256 amount) external returns (bool);
37 
38     function transferFrom(
39         address sender,
40         address recipient,
41         uint256 amount
42     ) external returns (bool);
43 
44     event Transfer(address indexed from, address indexed to, uint256 value);
45     event Approval(
46         address indexed owner,
47         address indexed spender,
48         uint256 value
49     );
50 }
51 
52 contract Ownable is Context {
53     address private _owner;
54     address private _previousOwner;
55     event OwnershipTransferred(
56         address indexed previousOwner,
57         address indexed newOwner
58     );
59 
60     constructor() {
61         address msgSender = _msgSender();
62         _owner = msgSender;
63         emit OwnershipTransferred(address(0), msgSender);
64     }
65 
66     function owner() public view returns (address) {
67         return _owner;
68     }
69 
70     modifier onlyOwner() {
71         require(_owner == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     function renounceOwnership() public virtual onlyOwner {
76         emit OwnershipTransferred(_owner, address(0));
77         _owner = address(0);
78     }
79 
80     function transferOwnership(address newOwner) public virtual onlyOwner {
81         require(newOwner != address(0), "Ownable: new owner is the zero address");
82         emit OwnershipTransferred(_owner, newOwner);
83         _owner = newOwner;
84     }
85 
86 }
87 
88 library SafeMath {
89     function add(uint256 a, uint256 b) internal pure returns (uint256) {
90         uint256 c = a + b;
91         require(c >= a, "SafeMath: addition overflow");
92         return c;
93     }
94 
95     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96         return sub(a, b, "SafeMath: subtraction overflow");
97     }
98 
99     function sub(
100         uint256 a,
101         uint256 b,
102         string memory errorMessage
103     ) internal pure returns (uint256) {
104         require(b <= a, errorMessage);
105         uint256 c = a - b;
106         return c;
107     }
108 
109     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
110         if (a == 0) {
111             return 0;
112         }
113         uint256 c = a * b;
114         require(c / a == b, "SafeMath: multiplication overflow");
115         return c;
116     }
117 
118     function div(uint256 a, uint256 b) internal pure returns (uint256) {
119         return div(a, b, "SafeMath: division by zero");
120     }
121 
122     function div(
123         uint256 a,
124         uint256 b,
125         string memory errorMessage
126     ) internal pure returns (uint256) {
127         require(b > 0, errorMessage);
128         uint256 c = a / b;
129         return c;
130     }
131 }
132 
133 interface IUniswapV2Factory {
134     function createPair(address tokenA, address tokenB)
135         external
136         returns (address pair);
137 }
138 
139 interface IUniswapV2Router02 {
140     function swapExactTokensForETHSupportingFeeOnTransferTokens(
141         uint256 amountIn,
142         uint256 amountOutMin,
143         address[] calldata path,
144         address to,
145         uint256 deadline
146     ) external;
147 
148     function factory() external pure returns (address);
149 
150     function WETH() external pure returns (address);
151 
152     function addLiquidityETH(
153         address token,
154         uint256 amountTokenDesired,
155         uint256 amountTokenMin,
156         uint256 amountETHMin,
157         address to,
158         uint256 deadline
159     )
160         external
161         payable
162         returns (
163             uint256 amountToken,
164             uint256 amountETH,
165             uint256 liquidity
166         );
167 }
168 
169 contract esotericprotocol is Context, IERC20, Ownable {///////////////////////////////////////////////////////////
170 
171     using SafeMath for uint256;
172 
173     string private constant _name = "Esoteric Protocol";//////////////////////////
174     string private constant _symbol = "ESOP";//////////////////////////////////////////////////////////////////////////
175     uint8 private constant _decimals = 9;
176 
177     mapping(address => uint256) private _rOwned;
178     mapping(address => uint256) private _tOwned;
179     mapping(address => mapping(address => uint256)) private _allowances;
180     mapping(address => bool) private _isExcludedFromFee;
181     uint256 private constant MAX = ~uint256(0);
182     uint256 private constant _tTotal = 10000000 * 10**9;
183     uint256 private _rTotal = (MAX - (MAX % _tTotal));
184     uint256 private _tFeeTotal;
185 
186     uint256 private _redisFeeOnBuy = 0;////////////////////////////////////////////////////////////////////
187     uint256 private _taxFeeOnBuy = 2;//////////////////////////////////////////////////////////////////////
188 
189     uint256 private _redisFeeOnSell = 0;/////////////////////////////////////////////////////////////////////
190     uint256 private _taxFeeOnSell = 2;/////////////////////////////////////////////////////////////////////
191 
192     uint256 private _redisFee = _redisFeeOnSell;
193     uint256 private _taxFee = _taxFeeOnSell;
194 
195     uint256 private _previousredisFee = _redisFee;
196     uint256 private _previoustaxFee = _taxFee;
197 
198     mapping(address => bool) public bots;
199     mapping(address => uint256) private cooldown;
200 
201     address payable private _developmentAddress = payable(0x09E5723C3C78B6213635ff69E7347aB077558E18);/////////////////////////////////////////////////
202     address payable private _marketingAddress = payable(0x09E5723C3C78B6213635ff69E7347aB077558E18);///////////////////////////////////////////////////
203 
204     IUniswapV2Router02 public uniswapV2Router;
205     address public uniswapV2Pair;
206 
207     bool private tradingOpen;
208     bool private inSwap = false;
209     bool private swapEnabled = true;
210 
211     uint256 public _maxTxAmount = 200000 * 10**9; //2%
212     uint256 public _maxWalletSize = 200000 * 10**9; //2%
213     uint256 public _swapTokensAtAmount = 15000 * 10**9; 
214 
215     event MaxTxAmountUpdated(uint256 _maxTxAmount);
216     modifier lockTheSwap {
217         inSwap = true;
218         _;
219         inSwap = false;
220     }
221 
222     constructor() {
223 
224         _rOwned[_msgSender()] = _rTotal;
225 
226         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);/////////////////////////////////////////////////
227         uniswapV2Router = _uniswapV2Router;
228         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
229             .createPair(address(this), _uniswapV2Router.WETH());
230 
231         _isExcludedFromFee[owner()] = true;
232         _isExcludedFromFee[address(this)] = true;
233         _isExcludedFromFee[_developmentAddress] = true;
234         _isExcludedFromFee[_marketingAddress] = true;
235 
236         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
237         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
238         bots[address(0x34822A742BDE3beF13acabF14244869841f06A73)] = true;
239         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
240         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
241         bots[address(0x8484eFcBDa76955463aa12e1d504D7C6C89321F8)] = true;
242         bots[address(0xe5265ce4D0a3B191431e1bac056d72b2b9F0Fe44)] = true;
243         bots[address(0x33F9Da98C57674B5FC5AE7349E3C732Cf2E6Ce5C)] = true;
244         bots[address(0xc59a8E2d2c476BA9122aa4eC19B4c5E2BBAbbC28)] = true;
245         bots[address(0x21053Ff2D9Fc37D4DB8687d48bD0b57581c1333D)] = true;
246         bots[address(0x4dd6A0D3191A41522B84BC6b65d17f6f5e6a4192)] = true;     
247 
248         emit Transfer(address(0), _msgSender(), _tTotal);
249     }
250 
251     function name() public pure returns (string memory) {
252         return _name;
253     }
254 
255     function symbol() public pure returns (string memory) {
256         return _symbol;
257     }
258 
259     function decimals() public pure returns (uint8) {
260         return _decimals;
261     }
262 
263     function totalSupply() public pure override returns (uint256) {
264         return _tTotal;
265     }
266 
267     function balanceOf(address account) public view override returns (uint256) {
268         return tokenFromReflection(_rOwned[account]);
269     }
270 
271     function transfer(address recipient, uint256 amount)
272         public
273         override
274         returns (bool)
275     {
276         _transfer(_msgSender(), recipient, amount);
277         return true;
278     }
279 
280     function allowance(address owner, address spender)
281         public
282         view
283         override
284         returns (uint256)
285     {
286         return _allowances[owner][spender];
287     }
288 
289     function approve(address spender, uint256 amount)
290         public
291         override
292         returns (bool)
293     {
294         _approve(_msgSender(), spender, amount);
295         return true;
296     }
297 
298     function transferFrom(
299         address sender,
300         address recipient,
301         uint256 amount
302     ) public override returns (bool) {
303         _transfer(sender, recipient, amount);
304         _approve(
305             sender,
306             _msgSender(),
307             _allowances[sender][_msgSender()].sub(
308                 amount,
309                 "ERC20: transfer amount exceeds allowance"
310             )
311         );
312         return true;
313     }
314 
315     function tokenFromReflection(uint256 rAmount)
316         private
317         view
318         returns (uint256)
319     {
320         require(
321             rAmount <= _rTotal,
322             "Amount must be less than total reflections"
323         );
324         uint256 currentRate = _getRate();
325         return rAmount.div(currentRate);
326     }
327 
328     function removeAllFee() private {
329         if (_redisFee == 0 && _taxFee == 0) return;
330 
331         _previousredisFee = _redisFee;
332         _previoustaxFee = _taxFee;
333 
334         _redisFee = 0;
335         _taxFee = 2;
336     }
337 
338     function restoreAllFee() private {
339         _redisFee = _previousredisFee;
340         _taxFee = _previoustaxFee;
341     }
342 
343     function _approve(
344         address owner,
345         address spender,
346         uint256 amount
347     ) private {
348         require(owner != address(0), "ERC20: approve from the zero address");
349         require(spender != address(0), "ERC20: approve to the zero address");
350         _allowances[owner][spender] = amount;
351         emit Approval(owner, spender, amount);
352     }
353 
354     function _transfer(
355         address from,
356         address to,
357         uint256 amount
358     ) private {
359         require(from != address(0), "ERC20: transfer from the zero address");
360         require(to != address(0), "ERC20: transfer to the zero address");
361         require(amount > 0, "Transfer amount must be greater than zero");
362 
363         if (from != owner() && to != owner()) {
364 
365             //Trade start check
366             if (!tradingOpen) {
367                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
368             }
369 
370             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
371             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
372 
373             if(to != uniswapV2Pair) {
374                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
375             }
376 
377             uint256 contractTokenBalance = balanceOf(address(this));
378             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
379 
380             if(contractTokenBalance >= _maxTxAmount)
381             {
382                 contractTokenBalance = _maxTxAmount;
383             }
384 
385             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
386                 swapTokensForEth(contractTokenBalance);
387                 uint256 contractETHBalance = address(this).balance;
388                 if (contractETHBalance > 0) {
389                     sendETHToFee(address(this).balance);
390                 }
391             }
392         }
393 
394         bool takeFee = true;
395 
396         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
397             takeFee = false;
398         } else {
399 
400             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
401                 _redisFee = _redisFeeOnBuy;
402                 _taxFee = _taxFeeOnBuy;
403             }
404 
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
589     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
590         _swapTokensAtAmount = swapTokensAtAmount;
591     }
592 
593     function toggleSwap(bool _swapEnabled) public onlyOwner {
594         swapEnabled = _swapEnabled;
595     }
596 
597     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
598         _maxTxAmount = maxTxAmount;
599     }
600 
601     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
602         _maxWalletSize = maxWalletSize;
603     }
604 
605     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
606         for(uint256 i = 0; i < accounts.length; i++) {
607             _isExcludedFromFee[accounts[i]] = excluded;
608         }
609     }
610 }