1 // SPDX-License-Identifier: UNLICENSED
2 //https://t.me/SHINUportal/4
3 pragma solidity ^0.8.4;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13 
14     function balanceOf(address account) external view returns (uint256);
15 
16     function transfer(address recipient, uint256 amount) external returns (bool);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     function approve(address spender, uint256 amount) external returns (bool);
21 
22     function transferFrom(
23         address sender,
24         address recipient,
25         uint256 amount
26     ) external returns (bool);
27 
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(
30         address indexed owner,
31         address indexed spender,
32         uint256 value
33     );
34 }
35 
36 contract Ownable is Context {
37     address private _owner;
38     address private _previousOwner;
39     event OwnershipTransferred(
40         address indexed previousOwner,
41         address indexed newOwner
42     );
43 
44     constructor() {
45         address msgSender = _msgSender();
46         _owner = msgSender;
47         emit OwnershipTransferred(address(0), msgSender);
48     }
49 
50     function owner() public view returns (address) {
51         return _owner;
52     }
53 
54     modifier onlyOwner() {
55         require(_owner == _msgSender(), "Ownable: caller is not the owner");
56         _;
57     }
58 
59     function renounceOwnership() public virtual onlyOwner {
60         emit OwnershipTransferred(_owner, address(0));
61         _owner = address(0);
62     }
63 
64     function transferOwnership(address newOwner) public virtual onlyOwner {
65         require(newOwner != address(0), "Ownable: new owner is the zero address");
66         emit OwnershipTransferred(_owner, newOwner);
67         _owner = newOwner;
68     }
69 
70 }
71 
72 library SafeMath {
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a, "SafeMath: addition overflow");
76         return c;
77     }
78 
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         return sub(a, b, "SafeMath: subtraction overflow");
81     }
82 
83     function sub(
84         uint256 a,
85         uint256 b,
86         string memory errorMessage
87     ) internal pure returns (uint256) {
88         require(b <= a, errorMessage);
89         uint256 c = a - b;
90         return c;
91     }
92 
93     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
94         if (a == 0) {
95             return 0;
96         }
97         uint256 c = a * b;
98         require(c / a == b, "SafeMath: multiplication overflow");
99         return c;
100     }
101 
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105 
106     function div(
107         uint256 a,
108         uint256 b,
109         string memory errorMessage
110     ) internal pure returns (uint256) {
111         require(b > 0, errorMessage);
112         uint256 c = a / b;
113         return c;
114     }
115 }
116 
117 interface IUniswapV2Factory {
118     function createPair(address tokenA, address tokenB)
119         external
120         returns (address pair);
121 }
122 
123 interface IUniswapV2Router02 {
124     function swapExactTokensForETHSupportingFeeOnTransferTokens(
125         uint256 amountIn,
126         uint256 amountOutMin,
127         address[] calldata path,
128         address to,
129         uint256 deadline
130     ) external;
131 
132     function factory() external pure returns (address);
133 
134     function WETH() external pure returns (address);
135 
136     function addLiquidityETH(
137         address token,
138         uint256 amountTokenDesired,
139         uint256 amountTokenMin,
140         uint256 amountETHMin,
141         address to,
142         uint256 deadline
143     )
144         external
145         payable
146         returns (
147             uint256 amountToken,
148             uint256 amountETH,
149             uint256 liquidity
150         );
151 }
152 
153 contract SHINU is Context, IERC20, Ownable {///////////////////////////////////////////////////////////
154 
155     using SafeMath for uint256;
156 
157     string private constant _name = "SHE INU";//////////////////////////
158     string private constant _symbol = "SHINU";//////////////////////////////////////////////////////////////////////////
159     uint8 private constant _decimals = 9;
160 
161     mapping(address => uint256) private _rOwned;
162     mapping(address => uint256) private _tOwned;
163     mapping(address => mapping(address => uint256)) private _allowances;
164     mapping(address => bool) private _isExcludedFromFee;
165     uint256 private constant MAX = ~uint256(0);
166     uint256 private constant _tTotal = 10000000 * 10**9;
167     uint256 private _rTotal = (MAX - (MAX % _tTotal));
168     uint256 private _tFeeTotal;
169 
170     //Buy Fee
171     uint256 private _redisFeeOnBuy = 0;////////////////////////////////////////////////////////////////////
172     uint256 private _taxFeeOnBuy = 8;//////////////////////////////////////////////////////////////////////
173 
174     //Sell Fee
175     uint256 private _redisFeeOnSell = 0;/////////////////////////////////////////////////////////////////////
176     uint256 private _taxFeeOnSell = 8;/////////////////////////////////////////////////////////////////////
177 
178     //Original Fee
179     uint256 private _redisFee = _redisFeeOnSell;
180     uint256 private _taxFee = _taxFeeOnSell;
181 
182     uint256 private _previousredisFee = _redisFee;
183     uint256 private _previoustaxFee = _taxFee;
184 
185     mapping(address => bool) public bots;
186     mapping(address => uint256) private cooldown;
187 
188     address payable private _developmentAddress = payable(0xa80A3E0bf76542B98aEBa1e8FE5FF661B58fB655);/////////////////////////////////////////////////
189     address payable private _marketingAddress = payable(0xa80A3E0bf76542B98aEBa1e8FE5FF661B58fB655);///////////////////////////////////////////////////
190 
191     IUniswapV2Router02 public uniswapV2Router;
192     address public uniswapV2Pair;
193 
194     bool private tradingOpen;
195     bool private inSwap = false;
196     bool private swapEnabled = true;
197 
198     uint256 public _maxTxAmount = 100000 * 10**9; //1%
199     uint256 public _maxWalletSize = 100000 * 10**9; //1%
200     uint256 public _swapTokensAtAmount = 10000 * 10**9; //1%
201 
202     event MaxTxAmountUpdated(uint256 _maxTxAmount);
203     modifier lockTheSwap {
204         inSwap = true;
205         _;
206         inSwap = false;
207     }
208 
209     constructor() {
210 
211         _rOwned[_msgSender()] = _rTotal;
212 
213         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);/////////////////////////////////////////////////
214         uniswapV2Router = _uniswapV2Router;
215         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
216             .createPair(address(this), _uniswapV2Router.WETH());
217 
218         _isExcludedFromFee[owner()] = true;
219         _isExcludedFromFee[address(this)] = true;
220         _isExcludedFromFee[_developmentAddress] = true;
221         _isExcludedFromFee[_marketingAddress] = true;
222 
223         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
224         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
225         bots[address(0x34822A742BDE3beF13acabF14244869841f06A73)] = true;
226         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
227         bots[address(0x69611A66d0CF67e5Ddd1957e6499b5C5A3E44845)] = true;
228         bots[address(0x8484eFcBDa76955463aa12e1d504D7C6C89321F8)] = true;
229         bots[address(0xe5265ce4D0a3B191431e1bac056d72b2b9F0Fe44)] = true;
230         bots[address(0x33F9Da98C57674B5FC5AE7349E3C732Cf2E6Ce5C)] = true;
231         bots[address(0xc59a8E2d2c476BA9122aa4eC19B4c5E2BBAbbC28)] = true;
232         bots[address(0x21053Ff2D9Fc37D4DB8687d48bD0b57581c1333D)] = true;
233         bots[address(0x4dd6A0D3191A41522B84BC6b65d17f6f5e6a4192)] = true;     
234 
235         emit Transfer(address(0), _msgSender(), _tTotal);
236     }
237 
238     function name() public pure returns (string memory) {
239         return _name;
240     }
241 
242     function symbol() public pure returns (string memory) {
243         return _symbol;
244     }
245 
246     function decimals() public pure returns (uint8) {
247         return _decimals;
248     }
249 
250     function totalSupply() public pure override returns (uint256) {
251         return _tTotal;
252     }
253 
254     function balanceOf(address account) public view override returns (uint256) {
255         return tokenFromReflection(_rOwned[account]);
256     }
257 
258     function transfer(address recipient, uint256 amount)
259         public
260         override
261         returns (bool)
262     {
263         _transfer(_msgSender(), recipient, amount);
264         return true;
265     }
266 
267     function allowance(address owner, address spender)
268         public
269         view
270         override
271         returns (uint256)
272     {
273         return _allowances[owner][spender];
274     }
275 
276     function approve(address spender, uint256 amount)
277         public
278         override
279         returns (bool)
280     {
281         _approve(_msgSender(), spender, amount);
282         return true;
283     }
284 
285     function transferFrom(
286         address sender,
287         address recipient,
288         uint256 amount
289     ) public override returns (bool) {
290         _transfer(sender, recipient, amount);
291         _approve(
292             sender,
293             _msgSender(),
294             _allowances[sender][_msgSender()].sub(
295                 amount,
296                 "ERC20: transfer amount exceeds allowance"
297             )
298         );
299         return true;
300     }
301 
302     function tokenFromReflection(uint256 rAmount)
303         private
304         view
305         returns (uint256)
306     {
307         require(
308             rAmount <= _rTotal,
309             "Amount must be less than total reflections"
310         );
311         uint256 currentRate = _getRate();
312         return rAmount.div(currentRate);
313     }
314 
315     function removeAllFee() private {
316         if (_redisFee == 0 && _taxFee == 0) return;
317 
318         _previousredisFee = _redisFee;
319         _previoustaxFee = _taxFee;
320 
321         _redisFee = 0;
322         _taxFee = 0;
323     }
324 
325     function restoreAllFee() private {
326         _redisFee = _previousredisFee;
327         _taxFee = _previoustaxFee;
328     }
329 
330     function _approve(
331         address owner,
332         address spender,
333         uint256 amount
334     ) private {
335         require(owner != address(0), "ERC20: approve from the zero address");
336         require(spender != address(0), "ERC20: approve to the zero address");
337         _allowances[owner][spender] = amount;
338         emit Approval(owner, spender, amount);
339     }
340 
341     function _transfer(
342         address from,
343         address to,
344         uint256 amount
345     ) private {
346         require(from != address(0), "ERC20: transfer from the zero address");
347         require(to != address(0), "ERC20: transfer to the zero address");
348         require(amount > 0, "Transfer amount must be greater than zero");
349 
350         if (from != owner() && to != owner()) {
351 
352             //Trade start check
353             if (!tradingOpen) {
354                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
355             }
356 
357             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
358             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
359 
360             if(to != uniswapV2Pair) {
361                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
362             }
363 
364             uint256 contractTokenBalance = balanceOf(address(this));
365             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
366 
367             if(contractTokenBalance >= _maxTxAmount)
368             {
369                 contractTokenBalance = _maxTxAmount;
370             }
371 
372             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
373                 swapTokensForEth(contractTokenBalance);
374                 uint256 contractETHBalance = address(this).balance;
375                 if (contractETHBalance > 0) {
376                     sendETHToFee(address(this).balance);
377                 }
378             }
379         }
380 
381         bool takeFee = true;
382 
383         //Transfer Tokens
384         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
385             takeFee = false;
386         } else {
387 
388             //Set Fee for Buys
389             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
390                 _redisFee = _redisFeeOnBuy;
391                 _taxFee = _taxFeeOnBuy;
392             }
393 
394             //Set Fee for Sells
395             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
396                 _redisFee = _redisFeeOnSell;
397                 _taxFee = _taxFeeOnSell;
398             }
399 
400         }
401 
402         _tokenTransfer(from, to, amount, takeFee);
403     }
404 
405     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
406         address[] memory path = new address[](2);
407         path[0] = address(this);
408         path[1] = uniswapV2Router.WETH();
409         _approve(address(this), address(uniswapV2Router), tokenAmount);
410         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
411             tokenAmount,
412             0,
413             path,
414             address(this),
415             block.timestamp
416         );
417     }
418 
419     function sendETHToFee(uint256 amount) private {
420         _developmentAddress.transfer(amount.div(2));
421         _marketingAddress.transfer(amount.div(2));
422     }
423 
424     function setTrading(bool _tradingOpen) public onlyOwner {
425         tradingOpen = _tradingOpen;
426     }
427 
428     function manualswap() external {
429         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
430         uint256 contractBalance = balanceOf(address(this));
431         swapTokensForEth(contractBalance);
432     }
433 
434     function manualsend() external {
435         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
436         uint256 contractETHBalance = address(this).balance;
437         sendETHToFee(contractETHBalance);
438     }
439 
440     function blockBots(address[] memory bots_) public onlyOwner {
441         for (uint256 i = 0; i < bots_.length; i++) {
442             bots[bots_[i]] = true;
443         }
444     }
445 
446     function unblockBot(address notbot) public onlyOwner {
447         bots[notbot] = false;
448     }
449 
450     function _tokenTransfer(
451         address sender,
452         address recipient,
453         uint256 amount,
454         bool takeFee
455     ) private {
456         if (!takeFee) removeAllFee();
457         _transferStandard(sender, recipient, amount);
458         if (!takeFee) restoreAllFee();
459     }
460 
461     function _transferStandard(
462         address sender,
463         address recipient,
464         uint256 tAmount
465     ) private {
466         (
467             uint256 rAmount,
468             uint256 rTransferAmount,
469             uint256 rFee,
470             uint256 tTransferAmount,
471             uint256 tFee,
472             uint256 tTeam
473         ) = _getValues(tAmount);
474         _rOwned[sender] = _rOwned[sender].sub(rAmount);
475         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
476         _takeTeam(tTeam);
477         _reflectFee(rFee, tFee);
478         emit Transfer(sender, recipient, tTransferAmount);
479     }
480 
481     function _takeTeam(uint256 tTeam) private {
482         uint256 currentRate = _getRate();
483         uint256 rTeam = tTeam.mul(currentRate);
484         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
485     }
486 
487     function _reflectFee(uint256 rFee, uint256 tFee) private {
488         _rTotal = _rTotal.sub(rFee);
489         _tFeeTotal = _tFeeTotal.add(tFee);
490     }
491 
492     receive() external payable {}
493 
494     function _getValues(uint256 tAmount)
495         private
496         view
497         returns (
498             uint256,
499             uint256,
500             uint256,
501             uint256,
502             uint256,
503             uint256
504         )
505     {
506         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
507             _getTValues(tAmount, _redisFee, _taxFee);
508         uint256 currentRate = _getRate();
509         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
510             _getRValues(tAmount, tFee, tTeam, currentRate);
511 
512         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
513     }
514 
515     function _getTValues(
516         uint256 tAmount,
517         uint256 redisFee,
518         uint256 taxFee
519     )
520         private
521         pure
522         returns (
523             uint256,
524             uint256,
525             uint256
526         )
527     {
528         uint256 tFee = tAmount.mul(redisFee).div(100);
529         uint256 tTeam = tAmount.mul(taxFee).div(100);
530         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
531 
532         return (tTransferAmount, tFee, tTeam);
533     }
534 
535     function _getRValues(
536         uint256 tAmount,
537         uint256 tFee,
538         uint256 tTeam,
539         uint256 currentRate
540     )
541         private
542         pure
543         returns (
544             uint256,
545             uint256,
546             uint256
547         )
548     {
549         uint256 rAmount = tAmount.mul(currentRate);
550         uint256 rFee = tFee.mul(currentRate);
551         uint256 rTeam = tTeam.mul(currentRate);
552         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
553 
554         return (rAmount, rTransferAmount, rFee);
555     }
556 
557     function _getRate() private view returns (uint256) {
558         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
559 
560         return rSupply.div(tSupply);
561     }
562 
563     function _getCurrentSupply() private view returns (uint256, uint256) {
564         uint256 rSupply = _rTotal;
565         uint256 tSupply = _tTotal;
566         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
567 
568         return (rSupply, tSupply);
569     }
570 
571     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
572         _redisFeeOnBuy = redisFeeOnBuy;
573         _redisFeeOnSell = redisFeeOnSell;
574 
575         _taxFeeOnBuy = taxFeeOnBuy;
576         _taxFeeOnSell = taxFeeOnSell;
577     }
578 
579     //Set minimum tokens required to swap.
580     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
581         _swapTokensAtAmount = swapTokensAtAmount;
582     }
583 
584     //Set minimum tokens required to swap.
585     function toggleSwap(bool _swapEnabled) public onlyOwner {
586         swapEnabled = _swapEnabled;
587     }
588 
589     //Set MAx transaction
590     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
591         _maxTxAmount = maxTxAmount;
592     }
593 
594     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
595         _maxWalletSize = maxWalletSize;
596     }
597 
598     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
599         for(uint256 i = 0; i < accounts.length; i++) {
600             _isExcludedFromFee[accounts[i]] = excluded;
601         }
602     }
603 }