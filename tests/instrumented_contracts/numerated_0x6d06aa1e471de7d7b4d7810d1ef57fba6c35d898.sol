1 /**
2         SHAPE DAO...... Helping Shinja, One Ape At A Time....
3         https://t.me/The_One_and_Only_Portal
4         
5         WARNING!!!!  If you buy before the contract is released in telegram, you will be Blackslisted.  NO exceptions
6 */
7 
8 
9 
10 //SPDX-License-Identifier: UNLICENSED
11 pragma solidity ^0.8.4;
12  
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 }
18  
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21  
22     function balanceOf(address account) external view returns (uint256);
23  
24     function transfer(address recipient, uint256 amount) external returns (bool);
25  
26     function allowance(address owner, address spender) external view returns (uint256);
27  
28     function approve(address spender, uint256 amount) external returns (bool);
29  
30     function transferFrom(
31         address sender,
32         address recipient,
33         uint256 amount
34     ) external returns (bool);
35  
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(
38         address indexed owner,
39         address indexed spender,
40         uint256 value
41     );
42 }
43  
44 contract Ownable is Context {
45     address private _owner;
46     address private _previousOwner;
47     event OwnershipTransferred(
48         address indexed previousOwner,
49         address indexed newOwner
50     );
51  
52     constructor() {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57  
58     function owner() public view returns (address) {
59         return _owner;
60     }
61  
62     modifier onlyOwner() {
63         require(_owner == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66  
67     function renounceOwnership() public virtual onlyOwner {
68         emit OwnershipTransferred(_owner, address(0));
69         _owner = address(0);
70     }
71  
72     function transferOwnership(address newOwner) public virtual onlyOwner {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77  
78 }
79  
80 library SafeMath {
81     function add(uint256 a, uint256 b) internal pure returns (uint256) {
82         uint256 c = a + b;
83         require(c >= a, "SafeMath: addition overflow");
84         return c;
85     }
86  
87     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88         return sub(a, b, "SafeMath: subtraction overflow");
89     }
90  
91     function sub(
92         uint256 a,
93         uint256 b,
94         string memory errorMessage
95     ) internal pure returns (uint256) {
96         require(b <= a, errorMessage);
97         uint256 c = a - b;
98         return c;
99     }
100  
101     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
102         if (a == 0) {
103             return 0;
104         }
105         uint256 c = a * b;
106         require(c / a == b, "SafeMath: multiplication overflow");
107         return c;
108     }
109  
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         return div(a, b, "SafeMath: division by zero");
112     }
113  
114     function div(
115         uint256 a,
116         uint256 b,
117         string memory errorMessage
118     ) internal pure returns (uint256) {
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         return c;
122     }
123 }
124  
125 interface IUniswapV2Factory {
126     function createPair(address tokenA, address tokenB)
127         external
128         returns (address pair);
129 }
130  
131 interface IUniswapV2Router02 {
132     function swapExactTokensForETHSupportingFeeOnTransferTokens(
133         uint256 amountIn,
134         uint256 amountOutMin,
135         address[] calldata path,
136         address to,
137         uint256 deadline
138     ) external;
139  
140     function factory() external pure returns (address);
141  
142     function WETH() external pure returns (address);
143  
144     function addLiquidityETH(
145         address token,
146         uint256 amountTokenDesired,
147         uint256 amountTokenMin,
148         uint256 amountETHMin,
149         address to,
150         uint256 deadline
151     )
152         external
153         payable
154         returns (
155             uint256 amountToken,
156             uint256 amountETH,
157             uint256 liquidity
158         );
159 }
160  
161 contract SHAPE is Context, IERC20, Ownable {
162  
163     using SafeMath for uint256;
164  
165     string private constant _name = "SHAPE DAO";//
166     string private constant _symbol = "SHAPE";//
167     uint8 private constant _decimals = 9;
168  
169     mapping(address => uint256) private _rOwned;
170     mapping(address => uint256) private _tOwned;
171     mapping(address => mapping(address => uint256)) private _allowances;
172     mapping(address => bool) private _isExcludedFromFee;
173     uint256 private constant MAX = ~uint256(0);
174     uint256 private constant _tTotal = 4206900008008 * 10**9;
175     uint256 private _rTotal = (MAX - (MAX % _tTotal));
176     uint256 private _tFeeTotal;
177     uint256 public launchBlock;
178  
179     //Buy Fee
180     uint256 private _redisFeeOnBuy = 0;//
181     uint256 private _taxFeeOnBuy = 5;//
182  
183     //Sell Fee
184     uint256 private _redisFeeOnSell = 0;//
185     uint256 private _taxFeeOnSell = 99;//
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
197     address payable private _developmentAddress = payable(0xc103D9Eda2C93f065988189dD5C87D6216938ab2);//
198     address payable private _marketingAddress = payable(0x5F088249bbEC1251639d01a087e0AD3763Cf81CD);//
199  
200     IUniswapV2Router02 public uniswapV2Router;
201     address public uniswapV2Pair;
202  
203     bool private tradingOpen;
204     bool private inSwap = false;
205     bool private swapEnabled = true;
206  
207     uint256 public _maxTxAmount = 12000000000 * 10**9; //
208     uint256 public _maxWalletSize = 42000000000 * 10**9; //
209     uint256 public _swapTokensAtAmount = 100000000 * 10**9; //
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
222         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
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
370             if(block.number <= launchBlock && from == uniswapV2Pair && to != address(uniswapV2Router) && to != address(this)){   
371                 bots[to] = true;
372             } 
373  
374             if(to != uniswapV2Pair) {
375                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
376             }
377  
378             uint256 contractTokenBalance = balanceOf(address(this));
379             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
380  
381             if(contractTokenBalance >= _maxTxAmount)
382             {
383                 contractTokenBalance = _maxTxAmount;
384             }
385  
386             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
387                 swapTokensForEth(contractTokenBalance);
388                 uint256 contractETHBalance = address(this).balance;
389                 if (contractETHBalance > 0) {
390                     sendETHToFee(address(this).balance);
391                 }
392             }
393         }
394  
395         bool takeFee = true;
396  
397         //Transfer Tokens
398         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
399             takeFee = false;
400         } else {
401  
402             //Set Fee for Buys
403             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
404                 _redisFee = _redisFeeOnBuy;
405                 _taxFee = _taxFeeOnBuy;
406             }
407  
408             //Set Fee for Sells
409             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
410                 _redisFee = _redisFeeOnSell;
411                 _taxFee = _taxFeeOnSell;
412             }
413  
414         }
415  
416         _tokenTransfer(from, to, amount, takeFee);
417     }
418  
419     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
420         address[] memory path = new address[](2);
421         path[0] = address(this);
422         path[1] = uniswapV2Router.WETH();
423         _approve(address(this), address(uniswapV2Router), tokenAmount);
424         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
425             tokenAmount,
426             0,
427             path,
428             address(this),
429             block.timestamp
430         );
431     }
432  
433     function sendETHToFee(uint256 amount) private {
434         _developmentAddress.transfer(amount.div(2));
435         _marketingAddress.transfer(amount.div(2));
436     }
437  
438     function setTrading(bool _tradingOpen) public onlyOwner {
439         tradingOpen = _tradingOpen;
440         launchBlock = block.number;
441     }
442  
443     function manualswap() external {
444         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
445         uint256 contractBalance = balanceOf(address(this));
446         swapTokensForEth(contractBalance);
447     }
448  
449     function manualsend() external {
450         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
451         uint256 contractETHBalance = address(this).balance;
452         sendETHToFee(contractETHBalance);
453     }
454  
455     function blockBots(address[] memory bots_) public onlyOwner {
456         for (uint256 i = 0; i < bots_.length; i++) {
457             bots[bots_[i]] = true;
458         }
459     }
460  
461     function unblockBot(address notbot) public onlyOwner {
462         bots[notbot] = false;
463     }
464  
465     function _tokenTransfer(
466         address sender,
467         address recipient,
468         uint256 amount,
469         bool takeFee
470     ) private {
471         if (!takeFee) removeAllFee();
472         _transferStandard(sender, recipient, amount);
473         if (!takeFee) restoreAllFee();
474     }
475  
476     function _transferStandard(
477         address sender,
478         address recipient,
479         uint256 tAmount
480     ) private {
481         (
482             uint256 rAmount,
483             uint256 rTransferAmount,
484             uint256 rFee,
485             uint256 tTransferAmount,
486             uint256 tFee,
487             uint256 tTeam
488         ) = _getValues(tAmount);
489         _rOwned[sender] = _rOwned[sender].sub(rAmount);
490         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
491         _takeTeam(tTeam);
492         _reflectFee(rFee, tFee);
493         emit Transfer(sender, recipient, tTransferAmount);
494     }
495  
496     function _takeTeam(uint256 tTeam) private {
497         uint256 currentRate = _getRate();
498         uint256 rTeam = tTeam.mul(currentRate);
499         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
500     }
501  
502     function _reflectFee(uint256 rFee, uint256 tFee) private {
503         _rTotal = _rTotal.sub(rFee);
504         _tFeeTotal = _tFeeTotal.add(tFee);
505     }
506  
507     receive() external payable {}
508  
509     function _getValues(uint256 tAmount)
510         private
511         view
512         returns (
513             uint256,
514             uint256,
515             uint256,
516             uint256,
517             uint256,
518             uint256
519         )
520     {
521         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
522             _getTValues(tAmount, _redisFee, _taxFee);
523         uint256 currentRate = _getRate();
524         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
525             _getRValues(tAmount, tFee, tTeam, currentRate);
526  
527         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
528     }
529  
530     function _getTValues(
531         uint256 tAmount,
532         uint256 redisFee,
533         uint256 taxFee
534     )
535         private
536         pure
537         returns (
538             uint256,
539             uint256,
540             uint256
541         )
542     {
543         uint256 tFee = tAmount.mul(redisFee).div(100);
544         uint256 tTeam = tAmount.mul(taxFee).div(100);
545         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
546  
547         return (tTransferAmount, tFee, tTeam);
548     }
549  
550     function _getRValues(
551         uint256 tAmount,
552         uint256 tFee,
553         uint256 tTeam,
554         uint256 currentRate
555     )
556         private
557         pure
558         returns (
559             uint256,
560             uint256,
561             uint256
562         )
563     {
564         uint256 rAmount = tAmount.mul(currentRate);
565         uint256 rFee = tFee.mul(currentRate);
566         uint256 rTeam = tTeam.mul(currentRate);
567         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
568  
569         return (rAmount, rTransferAmount, rFee);
570     }
571  
572     function _getRate() private view returns (uint256) {
573         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
574  
575         return rSupply.div(tSupply);
576     }
577  
578     function _getCurrentSupply() private view returns (uint256, uint256) {
579         uint256 rSupply = _rTotal;
580         uint256 tSupply = _tTotal;
581         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
582  
583         return (rSupply, tSupply);
584     }
585  
586     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
587         _redisFeeOnBuy = redisFeeOnBuy;
588         _redisFeeOnSell = redisFeeOnSell;
589  
590         _taxFeeOnBuy = taxFeeOnBuy;
591         _taxFeeOnSell = taxFeeOnSell;
592     }
593  
594     //Set minimum tokens required to swap.
595     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
596         _swapTokensAtAmount = swapTokensAtAmount;
597     }
598  
599     //Set minimum tokens required to swap.
600     function toggleSwap(bool _swapEnabled) public onlyOwner {
601         swapEnabled = _swapEnabled;
602     }
603  
604  
605     //Set maximum transaction
606     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
607         _maxTxAmount = maxTxAmount;
608     }
609  
610     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
611         _maxWalletSize = maxWalletSize;
612     }
613  
614     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
615         for(uint256 i = 0; i < accounts.length; i++) {
616             _isExcludedFromFee[accounts[i]] = excluded;
617         }
618     }
619 }