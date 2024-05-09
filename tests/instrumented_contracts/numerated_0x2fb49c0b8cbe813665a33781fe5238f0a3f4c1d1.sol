1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 Exa Dark Sideræl Musk
6 
7 ELON MUSK x GRIMES baby girl 
8 
9 Y MUSK (Exa Dark Sideræl Musk)
10 
11 TELEGRAM:
12 
13 https://t.me/exadarketh
14 https://t.me/exadarketh
15 https://t.me/exadarketh
16 https://t.me/exadarketh
17 
18 
19 */
20 
21 
22 pragma solidity ^0.8.9;
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
172 contract EXADARK is Context, IERC20, Ownable {
173  
174     using SafeMath for uint256;
175  
176     string private constant _name = "Exa Dark Siderael Musk";//
177     string private constant _symbol = "EXA DARK";//
178     uint8 private constant _decimals = 9;
179  
180     mapping(address => uint256) private _rOwned;
181     mapping(address => uint256) private _tOwned;
182     mapping(address => mapping(address => uint256)) private _allowances;
183     mapping(address => bool) private _isExcludedFromFee;
184     uint256 private constant MAX = ~uint256(0);
185     uint256 private constant _tTotal = 69000000000000000000000 * 10**9;
186     uint256 private _rTotal = (MAX - (MAX % _tTotal));
187     uint256 private _tFeeTotal;
188     uint256 public launchBlock;
189  
190     //Buy Fee
191     uint256 private _redisFeeOnBuy = 0;//
192     uint256 private _taxFeeOnBuy = 11;//
193  
194     //Sell Fee
195     uint256 private _redisFeeOnSell = 0;//
196     uint256 private _taxFeeOnSell = 24;//
197 
198 
199  
200     //Original Fee
201     uint256 private _redisFee = _redisFeeOnSell;
202     uint256 private _taxFee = _taxFeeOnSell;
203  
204     uint256 private _previousredisFee = _redisFee;
205     uint256 private _previoustaxFee = _taxFee;
206  
207     mapping(address => bool) public bots;
208     mapping(address => uint256) private cooldown;
209  
210     address payable private _devAddress = payable(0x08E2E790442259a9D455599CF327318138d82084);//
211     address payable private _marketingAddress = payable(0xc7cE5FfCeC227cD0c0E30245Bd304618388B0B43);//
212  
213     IUniswapV2Router02 public uniswapV2Router;
214     address public uniswapV2Pair;
215  
216     bool private tradingOpen;
217     bool private inSwap = false;
218     bool private swapEnabled = true;
219  
220     uint256 public _maxTxAmount = 345000000001000000000 * 10**9; //
221     uint256 public _maxWalletSize = 690000000002000000000 * 10**9; //
222     uint256 public _swapTokensAtAmount = 10000000000000000 * 10**9; //
223  
224     event MaxTxAmountUpdated(uint256 _maxTxAmount);
225     modifier lockTheSwap {
226         inSwap = true;
227         _;
228         inSwap = false;
229     }
230  
231     constructor() {
232  
233         _rOwned[_msgSender()] = _rTotal;
234  
235         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
236         uniswapV2Router = _uniswapV2Router;
237         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
238             .createPair(address(this), _uniswapV2Router.WETH());
239  
240         _isExcludedFromFee[owner()] = true;
241         _isExcludedFromFee[address(this)] = true;
242         _isExcludedFromFee[_devAddress] = true;
243         _isExcludedFromFee[_marketingAddress] = true;
244  
245         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
246         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
247  
248  
249         emit Transfer(address(0), _msgSender(), _tTotal);
250     }
251  
252     function name() public pure returns (string memory) {
253         return _name;
254     }
255  
256     function symbol() public pure returns (string memory) {
257         return _symbol;
258     }
259  
260     function decimals() public pure returns (uint8) {
261         return _decimals;
262     }
263  
264     function totalSupply() public pure override returns (uint256) {
265         return _tTotal;
266     }
267  
268     function balanceOf(address account) public view override returns (uint256) {
269         return tokenFromReflection(_rOwned[account]);
270     }
271  
272     function transfer(address recipient, uint256 amount)
273         public
274         override
275         returns (bool)
276     {
277         _transfer(_msgSender(), recipient, amount);
278         return true;
279     }
280  
281     function allowance(address owner, address spender)
282         public
283         view
284         override
285         returns (uint256)
286     {
287         return _allowances[owner][spender];
288     }
289  
290     function approve(address spender, uint256 amount)
291         public
292         override
293         returns (bool)
294     {
295         _approve(_msgSender(), spender, amount);
296         return true;
297     }
298  
299     function transferFrom(
300         address sender,
301         address recipient,
302         uint256 amount
303     ) public override returns (bool) {
304         _transfer(sender, recipient, amount);
305         _approve(
306             sender,
307             _msgSender(),
308             _allowances[sender][_msgSender()].sub(
309                 amount,
310                 "ERC20: transfer amount exceeds allowance"
311             )
312         );
313         return true;
314     }
315  
316     function tokenFromReflection(uint256 rAmount)
317         private
318         view
319         returns (uint256)
320     {
321         require(
322             rAmount <= _rTotal,
323             "Amount must be less than total reflections"
324         );
325         uint256 currentRate = _getRate();
326         return rAmount.div(currentRate);
327     }
328  
329     function removeAllFee() private {
330         if (_redisFee == 0 && _taxFee == 0) return;
331  
332         _previousredisFee = _redisFee;
333         _previoustaxFee = _taxFee;
334  
335         _redisFee = 0;
336         _taxFee = 0;
337     }
338  
339     function restoreAllFee() private {
340         _redisFee = _previousredisFee;
341         _taxFee = _previoustaxFee;
342     }
343  
344     function _approve(
345         address owner,
346         address spender,
347         uint256 amount
348     ) private {
349         require(owner != address(0), "ERC20: approve from the zero address");
350         require(spender != address(0), "ERC20: approve to the zero address");
351         _allowances[owner][spender] = amount;
352         emit Approval(owner, spender, amount);
353     }
354  
355     function _transfer(
356         address from,
357         address to,
358         uint256 amount
359     ) private {
360         require(from != address(0), "ERC20: transfer from the zero address");
361         require(to != address(0), "ERC20: transfer to the zero address");
362         require(amount > 0, "Transfer amount must be greater than zero");
363  
364         if (from != owner() && to != owner()) {
365  
366             //Trade start check
367             if (!tradingOpen) {
368                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
369             }
370  
371             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
372             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
373  
374             if(block.number <= launchBlock && from == uniswapV2Pair && to != address(uniswapV2Router) && to != address(this)){   
375                 bots[to] = true;
376             } 
377  
378             if(to != uniswapV2Pair) {
379                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
380             }
381  
382             uint256 contractTokenBalance = balanceOf(address(this));
383             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
384  
385             if(contractTokenBalance >= _maxTxAmount)
386             {
387                 contractTokenBalance = _maxTxAmount;
388             }
389  
390             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
391                 swapTokensForEth(contractTokenBalance);
392                 uint256 contractETHBalance = address(this).balance;
393                 if (contractETHBalance > 0) {
394                     sendETHToFee(address(this).balance);
395                 }
396             }
397         }
398  
399         bool takeFee = true;
400  
401         //Transfer Tokens
402         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
403             takeFee = false;
404         } else {
405  
406             //Set Fee for Buys
407             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
408                 _redisFee = _redisFeeOnBuy;
409                 _taxFee = _taxFeeOnBuy;
410             }
411  
412             //Set Fee for Sells
413             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
414                 _redisFee = _redisFeeOnSell;
415                 _taxFee = _taxFeeOnSell;
416             }
417  
418         }
419  
420         _tokenTransfer(from, to, amount, takeFee);
421     }
422  
423     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
424         address[] memory path = new address[](2);
425         path[0] = address(this);
426         path[1] = uniswapV2Router.WETH();
427         _approve(address(this), address(uniswapV2Router), tokenAmount);
428         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
429             tokenAmount,
430             0,
431             path,
432             address(this),
433             block.timestamp
434         );
435     }
436  
437     function sendETHToFee(uint256 amount) private {
438         _devAddress.transfer(amount.div(2));
439         _marketingAddress.transfer(amount.div(2));
440     }
441  
442     function setTrading(bool _tradingOpen) public onlyOwner {
443         tradingOpen = _tradingOpen;
444         launchBlock = block.number;
445     }
446  
447     function manualswap() external {
448         require(_msgSender() == _devAddress || _msgSender() == _marketingAddress);
449         uint256 contractBalance = balanceOf(address(this));
450         swapTokensForEth(contractBalance);
451     }
452  
453     function manualsend() external {
454         require(_msgSender() == _devAddress || _msgSender() == _marketingAddress);
455         uint256 contractETHBalance = address(this).balance;
456         sendETHToFee(contractETHBalance);
457     }
458  
459     function blockBots(address[] memory bots_) public onlyOwner {
460         for (uint256 i = 0; i < bots_.length; i++) {
461             bots[bots_[i]] = true;
462         }
463     }
464  
465     function unblockBot(address notbot) public onlyOwner {
466         bots[notbot] = false;
467     }
468  
469     function _tokenTransfer(
470         address sender,
471         address recipient,
472         uint256 amount,
473         bool takeFee
474     ) private {
475         if (!takeFee) removeAllFee();
476         _transferStandard(sender, recipient, amount);
477         if (!takeFee) restoreAllFee();
478     }
479  
480     function _transferStandard(
481         address sender,
482         address recipient,
483         uint256 tAmount
484     ) private {
485         (
486             uint256 rAmount,
487             uint256 rTransferAmount,
488             uint256 rFee,
489             uint256 tTransferAmount,
490             uint256 tFee,
491             uint256 tTeam
492         ) = _getValues(tAmount);
493         _rOwned[sender] = _rOwned[sender].sub(rAmount);
494         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
495         _takeTeam(tTeam);
496         _reflectFee(rFee, tFee);
497         emit Transfer(sender, recipient, tTransferAmount);
498     }
499  
500     function _takeTeam(uint256 tTeam) private {
501         uint256 currentRate = _getRate();
502         uint256 rTeam = tTeam.mul(currentRate);
503         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
504     }
505  
506     function _reflectFee(uint256 rFee, uint256 tFee) private {
507         _rTotal = _rTotal.sub(rFee);
508         _tFeeTotal = _tFeeTotal.add(tFee);
509     }
510  
511     receive() external payable {}
512  
513     function _getValues(uint256 tAmount)
514         private
515         view
516         returns (
517             uint256,
518             uint256,
519             uint256,
520             uint256,
521             uint256,
522             uint256
523         )
524     {
525         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
526             _getTValues(tAmount, _redisFee, _taxFee);
527         uint256 currentRate = _getRate();
528         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
529             _getRValues(tAmount, tFee, tTeam, currentRate);
530  
531         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
532     }
533  
534     function _getTValues(
535         uint256 tAmount,
536         uint256 redisFee,
537         uint256 taxFee
538     )
539         private
540         pure
541         returns (
542             uint256,
543             uint256,
544             uint256
545         )
546     {
547         uint256 tFee = tAmount.mul(redisFee).div(100);
548         uint256 tTeam = tAmount.mul(taxFee).div(100);
549         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
550  
551         return (tTransferAmount, tFee, tTeam);
552     }
553  
554     function _getRValues(
555         uint256 tAmount,
556         uint256 tFee,
557         uint256 tTeam,
558         uint256 currentRate
559     )
560         private
561         pure
562         returns (
563             uint256,
564             uint256,
565             uint256
566         )
567     {
568         uint256 rAmount = tAmount.mul(currentRate);
569         uint256 rFee = tFee.mul(currentRate);
570         uint256 rTeam = tTeam.mul(currentRate);
571         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
572  
573         return (rAmount, rTransferAmount, rFee);
574     }
575  
576     function _getRate() private view returns (uint256) {
577         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
578  
579         return rSupply.div(tSupply);
580     }
581  
582     function _getCurrentSupply() private view returns (uint256, uint256) {
583         uint256 rSupply = _rTotal;
584         uint256 tSupply = _tTotal;
585         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
586  
587         return (rSupply, tSupply);
588     }
589  
590     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
591         _redisFeeOnBuy = redisFeeOnBuy;
592         _redisFeeOnSell = redisFeeOnSell;
593  
594         _taxFeeOnBuy = taxFeeOnBuy;
595         _taxFeeOnSell = taxFeeOnSell;
596     }
597  
598     //Set minimum tokens required to swap.
599     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
600         _swapTokensAtAmount = swapTokensAtAmount;
601     }
602  
603     //Set minimum tokens required to swap.
604     function toggleSwap(bool _swapEnabled) public onlyOwner {
605         swapEnabled = _swapEnabled;
606     }
607  
608  
609     //Set maximum transaction
610     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
611         _maxTxAmount = maxTxAmount;
612     }
613  
614     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
615         _maxWalletSize = maxWalletSize;
616     }
617  
618     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
619         for(uint256 i = 0; i < accounts.length; i++) {
620             _isExcludedFromFee[accounts[i]] = excluded;
621         }
622     }
623 }