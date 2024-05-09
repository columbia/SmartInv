1 // SPDX-License-Identifier: MIT
2 
3 /**
4  __ _    ___ _ ___   ___      
5 (_ / \| | | | \ |     | |\|| |
6 __)\_X|_|_|_|_/_|_   _|_| ||_|
7 
8 SQUIDI INU // SQUIDI
9 
10 https://squidi.io
11 
12 http://t.me/squidi_eth
13 http://twitter.com/squidi_eth
14 https://www.instagram.com/squidi_eth
15 https://discord.com/invite/KDGH4yEDww
16 
17 
18 ❤️ xoxo ❤️
19 
20 Bambi 
21 
22 */
23 
24 
25 pragma solidity ^0.8.9;
26  
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 }
32  
33 interface IERC20 {
34     function totalSupply() external view returns (uint256);
35  
36     function balanceOf(address account) external view returns (uint256);
37  
38     function transfer(address recipient, uint256 amount) external returns (bool);
39  
40     function allowance(address owner, address spender) external view returns (uint256);
41  
42     function approve(address spender, uint256 amount) external returns (bool);
43  
44     function transferFrom(
45         address sender,
46         address recipient,
47         uint256 amount
48     ) external returns (bool);
49  
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(
52         address indexed owner,
53         address indexed spender,
54         uint256 value
55     );
56 }
57  
58 contract Ownable is Context {
59     address private _owner;
60     address private _previousOwner;
61     event OwnershipTransferred(
62         address indexed previousOwner,
63         address indexed newOwner
64     );
65  
66     constructor() {
67         address msgSender = _msgSender();
68         _owner = msgSender;
69         emit OwnershipTransferred(address(0), msgSender);
70     }
71  
72     function owner() public view returns (address) {
73         return _owner;
74     }
75  
76     modifier onlyOwner() {
77         require(_owner == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80  
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85  
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         emit OwnershipTransferred(_owner, newOwner);
89         _owner = newOwner;
90     }
91  
92 }
93  
94 library SafeMath {
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         uint256 c = a + b;
97         require(c >= a, "SafeMath: addition overflow");
98         return c;
99     }
100  
101     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102         return sub(a, b, "SafeMath: subtraction overflow");
103     }
104  
105     function sub(
106         uint256 a,
107         uint256 b,
108         string memory errorMessage
109     ) internal pure returns (uint256) {
110         require(b <= a, errorMessage);
111         uint256 c = a - b;
112         return c;
113     }
114  
115     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116         if (a == 0) {
117             return 0;
118         }
119         uint256 c = a * b;
120         require(c / a == b, "SafeMath: multiplication overflow");
121         return c;
122     }
123  
124     function div(uint256 a, uint256 b) internal pure returns (uint256) {
125         return div(a, b, "SafeMath: division by zero");
126     }
127  
128     function div(
129         uint256 a,
130         uint256 b,
131         string memory errorMessage
132     ) internal pure returns (uint256) {
133         require(b > 0, errorMessage);
134         uint256 c = a / b;
135         return c;
136     }
137 }
138  
139 interface IUniswapV2Factory {
140     function createPair(address tokenA, address tokenB)
141         external
142         returns (address pair);
143 }
144  
145 interface IUniswapV2Router02 {
146     function swapExactTokensForETHSupportingFeeOnTransferTokens(
147         uint256 amountIn,
148         uint256 amountOutMin,
149         address[] calldata path,
150         address to,
151         uint256 deadline
152     ) external;
153  
154     function factory() external pure returns (address);
155  
156     function WETH() external pure returns (address);
157  
158     function addLiquidityETH(
159         address token,
160         uint256 amountTokenDesired,
161         uint256 amountTokenMin,
162         uint256 amountETHMin,
163         address to,
164         uint256 deadline
165     )
166         external
167         payable
168         returns (
169             uint256 amountToken,
170             uint256 amountETH,
171             uint256 liquidity
172         );
173 }
174  
175 contract SQUIDI is Context, IERC20, Ownable {
176  
177     using SafeMath for uint256;
178  
179     string private constant _name = "Squidi Inu";//
180     string private constant _symbol = "SQUIDI";//
181     uint8 private constant _decimals = 9;
182  
183     mapping(address => uint256) private _rOwned;
184     mapping(address => uint256) private _tOwned;
185     mapping(address => mapping(address => uint256)) private _allowances;
186     mapping(address => bool) private _isExcludedFromFee;
187     uint256 private constant MAX = ~uint256(0);
188     uint256 private constant _tTotal = 100000000000000000000 * 10**9;
189     uint256 private _rTotal = (MAX - (MAX % _tTotal));
190     uint256 private _tFeeTotal;
191     uint256 public launchBlock;
192  
193     //Buy Fee
194     uint256 private _redisFeeOnBuy = 1;//
195     uint256 private _taxFeeOnBuy = 14;//
196  
197     //Sell Fee
198     uint256 private _redisFeeOnSell = 1;//
199     uint256 private _taxFeeOnSell = 24;//
200 
201 
202  
203     //Original Fee
204     uint256 private _redisFee = _redisFeeOnSell;
205     uint256 private _taxFee = _taxFeeOnSell;
206  
207     uint256 private _previousredisFee = _redisFee;
208     uint256 private _previoustaxFee = _taxFee;
209  
210     mapping(address => bool) public bots;
211     mapping(address => uint256) private cooldown;
212  
213     address payable private _charityliqAddress = payable(0x97D81049398454A7184f4B651C5ff7De3EC3BA8F);//
214     address payable private _marketingAddress = payable(0xeFDCF937E28d04bb8A3e837157Cd99Ac9C72c91F);//
215  
216     IUniswapV2Router02 public uniswapV2Router;
217     address public uniswapV2Pair;
218  
219     bool private tradingOpen;
220     bool private inSwap = false;
221     bool private swapEnabled = true;
222  
223     uint256 public _maxTxAmount = 500000000000001000 * 10**9; //
224     uint256 public _maxWalletSize = 500000000000001000 * 10**9; //
225     uint256 public _swapTokensAtAmount = 10000000000000000 * 10**9; //
226  
227     event MaxTxAmountUpdated(uint256 _maxTxAmount);
228     modifier lockTheSwap {
229         inSwap = true;
230         _;
231         inSwap = false;
232     }
233  
234     constructor() {
235  
236         _rOwned[_msgSender()] = _rTotal;
237  
238         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
239         uniswapV2Router = _uniswapV2Router;
240         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
241             .createPair(address(this), _uniswapV2Router.WETH());
242  
243         _isExcludedFromFee[owner()] = true;
244         _isExcludedFromFee[address(this)] = true;
245         _isExcludedFromFee[_charityliqAddress] = true;
246         _isExcludedFromFee[_marketingAddress] = true;
247  
248         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
249         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
250  
251  
252         emit Transfer(address(0), _msgSender(), _tTotal);
253     }
254  
255     function name() public pure returns (string memory) {
256         return _name;
257     }
258  
259     function symbol() public pure returns (string memory) {
260         return _symbol;
261     }
262  
263     function decimals() public pure returns (uint8) {
264         return _decimals;
265     }
266  
267     function totalSupply() public pure override returns (uint256) {
268         return _tTotal;
269     }
270  
271     function balanceOf(address account) public view override returns (uint256) {
272         return tokenFromReflection(_rOwned[account]);
273     }
274  
275     function transfer(address recipient, uint256 amount)
276         public
277         override
278         returns (bool)
279     {
280         _transfer(_msgSender(), recipient, amount);
281         return true;
282     }
283  
284     function allowance(address owner, address spender)
285         public
286         view
287         override
288         returns (uint256)
289     {
290         return _allowances[owner][spender];
291     }
292  
293     function approve(address spender, uint256 amount)
294         public
295         override
296         returns (bool)
297     {
298         _approve(_msgSender(), spender, amount);
299         return true;
300     }
301  
302     function transferFrom(
303         address sender,
304         address recipient,
305         uint256 amount
306     ) public override returns (bool) {
307         _transfer(sender, recipient, amount);
308         _approve(
309             sender,
310             _msgSender(),
311             _allowances[sender][_msgSender()].sub(
312                 amount,
313                 "ERC20: transfer amount exceeds allowance"
314             )
315         );
316         return true;
317     }
318  
319     function tokenFromReflection(uint256 rAmount)
320         private
321         view
322         returns (uint256)
323     {
324         require(
325             rAmount <= _rTotal,
326             "Amount must be less than total reflections"
327         );
328         uint256 currentRate = _getRate();
329         return rAmount.div(currentRate);
330     }
331  
332     function removeAllFee() private {
333         if (_redisFee == 0 && _taxFee == 0) return;
334  
335         _previousredisFee = _redisFee;
336         _previoustaxFee = _taxFee;
337  
338         _redisFee = 0;
339         _taxFee = 0;
340     }
341  
342     function restoreAllFee() private {
343         _redisFee = _previousredisFee;
344         _taxFee = _previoustaxFee;
345     }
346  
347     function _approve(
348         address owner,
349         address spender,
350         uint256 amount
351     ) private {
352         require(owner != address(0), "ERC20: approve from the zero address");
353         require(spender != address(0), "ERC20: approve to the zero address");
354         _allowances[owner][spender] = amount;
355         emit Approval(owner, spender, amount);
356     }
357  
358     function _transfer(
359         address from,
360         address to,
361         uint256 amount
362     ) private {
363         require(from != address(0), "ERC20: transfer from the zero address");
364         require(to != address(0), "ERC20: transfer to the zero address");
365         require(amount > 0, "Transfer amount must be greater than zero");
366  
367         if (from != owner() && to != owner()) {
368  
369             //Trade start check
370             if (!tradingOpen) {
371                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
372             }
373  
374             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
375             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
376  
377             if(block.number <= launchBlock && from == uniswapV2Pair && to != address(uniswapV2Router) && to != address(this)){   
378                 bots[to] = true;
379             } 
380  
381             if(to != uniswapV2Pair) {
382                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
383             }
384  
385             uint256 contractTokenBalance = balanceOf(address(this));
386             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
387  
388             if(contractTokenBalance >= _maxTxAmount)
389             {
390                 contractTokenBalance = _maxTxAmount;
391             }
392  
393             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
394                 swapTokensForEth(contractTokenBalance);
395                 uint256 contractETHBalance = address(this).balance;
396                 if (contractETHBalance > 0) {
397                     sendETHToFee(address(this).balance);
398                 }
399             }
400         }
401  
402         bool takeFee = true;
403  
404         //Transfer Tokens
405         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
406             takeFee = false;
407         } else {
408  
409             //Set Fee for Buys
410             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
411                 _redisFee = _redisFeeOnBuy;
412                 _taxFee = _taxFeeOnBuy;
413             }
414  
415             //Set Fee for Sells
416             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
417                 _redisFee = _redisFeeOnSell;
418                 _taxFee = _taxFeeOnSell;
419             }
420  
421         }
422  
423         _tokenTransfer(from, to, amount, takeFee);
424     }
425  
426     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
427         address[] memory path = new address[](2);
428         path[0] = address(this);
429         path[1] = uniswapV2Router.WETH();
430         _approve(address(this), address(uniswapV2Router), tokenAmount);
431         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
432             tokenAmount,
433             0,
434             path,
435             address(this),
436             block.timestamp
437         );
438     }
439  
440     function sendETHToFee(uint256 amount) private {
441         _charityliqAddress.transfer(amount.div(2));
442         _marketingAddress.transfer(amount.div(2));
443     }
444  
445     function setTrading(bool _tradingOpen) public onlyOwner {
446         tradingOpen = _tradingOpen;
447         launchBlock = block.number;
448     }
449  
450     function manualswap() external {
451         require(_msgSender() == _charityliqAddress || _msgSender() == _marketingAddress);
452         uint256 contractBalance = balanceOf(address(this));
453         swapTokensForEth(contractBalance);
454     }
455  
456     function manualsend() external {
457         require(_msgSender() == _charityliqAddress || _msgSender() == _marketingAddress);
458         uint256 contractETHBalance = address(this).balance;
459         sendETHToFee(contractETHBalance);
460     }
461  
462     function blockBots(address[] memory bots_) public onlyOwner {
463         for (uint256 i = 0; i < bots_.length; i++) {
464             bots[bots_[i]] = true;
465         }
466     }
467  
468     function unblockBot(address notbot) public onlyOwner {
469         bots[notbot] = false;
470     }
471  
472     function _tokenTransfer(
473         address sender,
474         address recipient,
475         uint256 amount,
476         bool takeFee
477     ) private {
478         if (!takeFee) removeAllFee();
479         _transferStandard(sender, recipient, amount);
480         if (!takeFee) restoreAllFee();
481     }
482  
483     function _transferStandard(
484         address sender,
485         address recipient,
486         uint256 tAmount
487     ) private {
488         (
489             uint256 rAmount,
490             uint256 rTransferAmount,
491             uint256 rFee,
492             uint256 tTransferAmount,
493             uint256 tFee,
494             uint256 tTeam
495         ) = _getValues(tAmount);
496         _rOwned[sender] = _rOwned[sender].sub(rAmount);
497         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
498         _takeTeam(tTeam);
499         _reflectFee(rFee, tFee);
500         emit Transfer(sender, recipient, tTransferAmount);
501     }
502  
503     function _takeTeam(uint256 tTeam) private {
504         uint256 currentRate = _getRate();
505         uint256 rTeam = tTeam.mul(currentRate);
506         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
507     }
508  
509     function _reflectFee(uint256 rFee, uint256 tFee) private {
510         _rTotal = _rTotal.sub(rFee);
511         _tFeeTotal = _tFeeTotal.add(tFee);
512     }
513  
514     receive() external payable {}
515  
516     function _getValues(uint256 tAmount)
517         private
518         view
519         returns (
520             uint256,
521             uint256,
522             uint256,
523             uint256,
524             uint256,
525             uint256
526         )
527     {
528         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
529             _getTValues(tAmount, _redisFee, _taxFee);
530         uint256 currentRate = _getRate();
531         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
532             _getRValues(tAmount, tFee, tTeam, currentRate);
533  
534         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
535     }
536  
537     function _getTValues(
538         uint256 tAmount,
539         uint256 redisFee,
540         uint256 taxFee
541     )
542         private
543         pure
544         returns (
545             uint256,
546             uint256,
547             uint256
548         )
549     {
550         uint256 tFee = tAmount.mul(redisFee).div(100);
551         uint256 tTeam = tAmount.mul(taxFee).div(100);
552         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
553  
554         return (tTransferAmount, tFee, tTeam);
555     }
556  
557     function _getRValues(
558         uint256 tAmount,
559         uint256 tFee,
560         uint256 tTeam,
561         uint256 currentRate
562     )
563         private
564         pure
565         returns (
566             uint256,
567             uint256,
568             uint256
569         )
570     {
571         uint256 rAmount = tAmount.mul(currentRate);
572         uint256 rFee = tFee.mul(currentRate);
573         uint256 rTeam = tTeam.mul(currentRate);
574         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
575  
576         return (rAmount, rTransferAmount, rFee);
577     }
578  
579     function _getRate() private view returns (uint256) {
580         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
581  
582         return rSupply.div(tSupply);
583     }
584  
585     function _getCurrentSupply() private view returns (uint256, uint256) {
586         uint256 rSupply = _rTotal;
587         uint256 tSupply = _tTotal;
588         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
589  
590         return (rSupply, tSupply);
591     }
592  
593     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
594         _redisFeeOnBuy = redisFeeOnBuy;
595         _redisFeeOnSell = redisFeeOnSell;
596  
597         _taxFeeOnBuy = taxFeeOnBuy;
598         _taxFeeOnSell = taxFeeOnSell;
599     }
600  
601     //Set minimum tokens required to swap.
602     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
603         _swapTokensAtAmount = swapTokensAtAmount;
604     }
605  
606     //Set minimum tokens required to swap.
607     function toggleSwap(bool _swapEnabled) public onlyOwner {
608         swapEnabled = _swapEnabled;
609     }
610  
611  
612     //Set maximum transaction
613     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
614         _maxTxAmount = maxTxAmount;
615     }
616  
617     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
618         _maxWalletSize = maxWalletSize;
619     }
620  
621     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
622         for(uint256 i = 0; i < accounts.length; i++) {
623             _isExcludedFromFee[accounts[i]] = excluded;
624         }
625     }
626 }