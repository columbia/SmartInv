1 /*  
2 BBBBBBBBBBBBBBBBB   RRRRRRRRRRRRRRRRR        OOOOOOOOO     KKKKKKKKK    KKKKKKKEEEEEEEEEEEEEEEEEEEEEE
3 B::::::::::::::::B  R::::::::::::::::R     OO:::::::::OO   K:::::::K    K:::::KE::::::::::::::::::::E
4 B::::::BBBBBB:::::B R::::::RRRRRR:::::R  OO:::::::::::::OO K:::::::K    K:::::KE::::::::::::::::::::E
5 BB:::::B     B:::::BRR:::::R     R:::::RO:::::::OOO:::::::OK:::::::K   K::::::KEE::::::EEEEEEEEE::::E
6   B::::B     B:::::B  R::::R     R:::::RO::::::O   O::::::OKK::::::K  K:::::KKK  E:::::E       EEEEEE
7   B::::B     B:::::B  R::::R     R:::::RO:::::O     O:::::O  K:::::K K:::::K     E:::::E             
8   B::::BBBBBB:::::B   R::::RRRRRR:::::R O:::::O     O:::::O  K::::::K:::::K      E::::::EEEEEEEEEE   
9   B:::::::::::::BB    R:::::::::::::RR  O:::::O     O:::::O  K:::::::::::K       E:::::::::::::::E   
10   B::::BBBBBB:::::B   R::::RRRRRR:::::R O:::::O     O:::::O  K:::::::::::K       E:::::::::::::::E   
11   B::::B     B:::::B  R::::R     R:::::RO:::::O     O:::::O  K::::::K:::::K      E::::::EEEEEEEEEE   
12   B::::B     B:::::B  R::::R     R:::::RO:::::O     O:::::O  K:::::K K:::::K     E:::::E             
13   B::::B     B:::::B  R::::R     R:::::RO::::::O   O::::::OKK::::::K  K:::::KKK  E:::::E       EEEEEE
14 BB:::::BBBBBB::::::BRR:::::R     R:::::RO:::::::OOO:::::::OK:::::::K   K::::::KEE::::::EEEEEEEE:::::E
15 B:::::::::::::::::B R::::::R     R:::::R OO:::::::::::::OO K:::::::K    K:::::KE::::::::::::::::::::E
16 B::::::::::::::::B  R::::::R     R:::::R   OO:::::::::OO   K:::::::K    K:::::KE::::::::::::::::::::E
17 BBBBBBBBBBBBBBBBB   RRRRRRRR     RRRRRRR     OOOOOOOOO     KKKKKKKKK    KKKKKKKEEEEEEEEEEEEEEEEEEEEEE
18  */
19             
20 /*     
21        
22        - https://brokecoin.club
23        - https://t.me/brokecoinerc
24        - @BROKECOINERC | https://twitter.com/brokecoinerc 
25        
26 */
27 
28 /**
29 */
30 
31 // SPDX-License-Identifier: Unlicensed
32 pragma solidity ^0.8.17;
33  
34 abstract contract Context {
35     function _msgSender() internal view virtual returns (address) {
36         return msg.sender;
37     }
38 }
39  
40 interface IERC20 {
41     function totalSupply() external view returns (uint256);
42  
43     function balanceOf(address account) external view returns (uint256);
44  
45     function transfer(address recipient, uint256 amount) external returns (bool);
46  
47     function allowance(address owner, address spender) external view returns (uint256);
48  
49     function approve(address spender, uint256 amount) external returns (bool);
50  
51     function transferFrom(
52         address sender,
53         address recipient,
54         uint256 amount
55     ) external returns (bool);
56  
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     event Approval(
59         address indexed owner,
60         address indexed spender,
61         uint256 value
62     );
63 }
64  
65 contract Ownable is Context {
66     address private _owner;
67     address private _previousOwner;
68     event OwnershipTransferred(
69         address indexed previousOwner,
70         address indexed newOwner
71     );
72  
73     constructor() {
74         address msgSender = _msgSender();
75         _owner = msgSender;
76         emit OwnershipTransferred(address(0), msgSender);
77     }
78  
79     function owner() public view returns (address) {
80         return _owner;
81     }
82  
83     modifier onlyOwner() {
84         require(_owner == _msgSender(), "Ownable: caller is not the owner");
85         _;
86     }
87  
88     function renounceOwnership() public virtual onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92  
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         emit OwnershipTransferred(_owner, newOwner);
96         _owner = newOwner;
97     }
98  
99 }
100  
101 library SafeMath {
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a, "SafeMath: addition overflow");
105         return c;
106     }
107  
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         return sub(a, b, "SafeMath: subtraction overflow");
110     }
111  
112     function sub(
113         uint256 a,
114         uint256 b,
115         string memory errorMessage
116     ) internal pure returns (uint256) {
117         require(b <= a, errorMessage);
118         uint256 c = a - b;
119         return c;
120     }
121  
122     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
123         if (a == 0) {
124             return 0;
125         }
126         uint256 c = a * b;
127         require(c / a == b, "SafeMath: multiplication overflow");
128         return c;
129     }
130  
131     function div(uint256 a, uint256 b) internal pure returns (uint256) {
132         return div(a, b, "SafeMath: division by zero");
133     }
134  
135     function div(
136         uint256 a,
137         uint256 b,
138         string memory errorMessage
139     ) internal pure returns (uint256) {
140         require(b > 0, errorMessage);
141         uint256 c = a / b;
142         return c;
143     }
144 }
145  
146 interface IUniswapV2Factory {
147     function createPair(address tokenA, address tokenB)
148         external
149         returns (address pair);
150 }
151  
152 interface IUniswapV2Router02 {
153     function swapExactTokensForETHSupportingFeeOnTransferTokens(
154         uint256 amountIn,
155         uint256 amountOutMin,
156         address[] calldata path,
157         address to,
158         uint256 deadline
159     ) external;
160  
161     function factory() external pure returns (address);
162  
163     function WETH() external pure returns (address);
164  
165     function addLiquidityETH(
166         address token,
167         uint256 amountTokenDesired,
168         uint256 amountTokenMin,
169         uint256 amountETHMin,
170         address to,
171         uint256 deadline
172     )
173         external
174         payable
175         returns (
176             uint256 amountToken,
177             uint256 amountETH,
178             uint256 liquidity
179         );
180 }
181  
182 contract BrokeCoin is Context, IERC20, Ownable {
183  
184     using SafeMath for uint256;
185  
186     string private constant _name = "Broke Coin";
187     string private constant _symbol = "BROKE";
188     uint8 private constant _decimals = 9;
189  
190     mapping(address => uint256) private _rOwned;
191     mapping(address => uint256) private _tOwned;
192     mapping(address => mapping(address => uint256)) private _allowances;
193     mapping(address => bool) private _isExcludedFromFee;
194     uint256 private constant MAX = ~uint256(0);
195     uint256 private constant _tTotal = 500000000000 * 10**9; //Total Supply
196     uint256 private _rTotal = (MAX - (MAX % _tTotal));
197     uint256 private _tFeeTotal;
198     uint256 private _redisFeeOnBuy = 0;  //rewards buyers from other buy tax
199     uint256 private _taxFeeOnBuy = 0;    //Main Buy Tax
200     uint256 private _redisFeeOnSell = 0;  //rewards buyers from other Sell tax
201     uint256 private _taxFeeOnSell = 0;   //Main sell Tax
202  
203     //Original Fee
204     uint256 private _redisFee = _redisFeeOnSell;
205     uint256 private _taxFee = _taxFeeOnSell;
206  
207     uint256 private _previousredisFee = _redisFee;
208     uint256 private _previoustaxFee = _taxFee;
209  
210     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
211     address payable private _developmentAddress = payable(0xE7f0ed5C60f14e12bD28eD065559A276161A9337); //Dev Address
212     address payable private _marketingAddress = payable(0x5d865F771abBE5D9729f49F21d49056B11615AD1); // Marketing Address
213  
214     IUniswapV2Router02 public uniswapV2Router;
215     address public uniswapV2Pair;
216  
217     bool private tradingOpen;
218     bool private inSwap = false;
219     bool private swapEnabled = true;
220  
221     uint256 public _maxTxAmount = 50000000000000000000 * 10**9; 
222     uint256 public _maxWalletSize = 500000000000 * 10**9; 
223     uint256 public _swapTokensAtAmount = 10000 * 10**9;
224  
225     event MaxTxAmountUpdated(uint256 _maxTxAmount);
226     modifier lockTheSwap {
227         inSwap = true;
228         _;
229         inSwap = false;
230     }
231  
232     constructor() {
233  
234         _rOwned[_msgSender()] = _rTotal;
235  
236         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
237         uniswapV2Router = _uniswapV2Router;
238         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
239             .createPair(address(this), _uniswapV2Router.WETH());
240  
241         _isExcludedFromFee[owner()] = true;
242         _isExcludedFromFee[address(this)] = true;
243         _isExcludedFromFee[_developmentAddress] = true;
244         _isExcludedFromFee[_marketingAddress] = true;
245  
246         emit Transfer(address(0), _msgSender(), _tTotal);
247     }
248 
249     function name() public pure returns (string memory) {
250         return _name;
251     }
252  
253     function symbol() public pure returns (string memory) {
254         return _symbol;
255     }
256  
257     function decimals() public pure returns (uint8) {
258         return _decimals;
259     }
260  
261     function totalSupply() public pure override returns (uint256) {
262         return _tTotal;
263     }
264  
265     function balanceOf(address account) public view override returns (uint256) {
266         return tokenFromReflection(_rOwned[account]);
267     }
268  
269     function transfer(address recipient, uint256 amount)
270         public
271         override
272         returns (bool)
273     {
274         _transfer(_msgSender(), recipient, amount);
275         return true;
276     }
277  
278     function allowance(address owner, address spender)
279         public
280         view
281         override
282         returns (uint256)
283     {
284         return _allowances[owner][spender];
285     }
286  
287     function approve(address spender, uint256 amount)
288         public
289         override
290         returns (bool)
291     {
292         _approve(_msgSender(), spender, amount);
293         return true;
294     }
295  
296     function transferFrom(
297         address sender,
298         address recipient,
299         uint256 amount
300     ) public override returns (bool) {
301         _transfer(sender, recipient, amount);
302         _approve(
303             sender,
304             _msgSender(),
305             _allowances[sender][_msgSender()].sub(
306                 amount,
307                 "ERC20: transfer amount exceeds allowance"
308             )
309         );
310         return true;
311     }
312  
313     function tokenFromReflection(uint256 rAmount)
314         private
315         view
316         returns (uint256)
317     {
318         require(
319             rAmount <= _rTotal,
320             "Amount must be less than total reflections"
321         );
322         uint256 currentRate = _getRate();
323         return rAmount.div(currentRate);
324     }
325  
326     function removeAllFee() private {
327         if (_redisFee == 0 && _taxFee == 0) return;
328  
329         _previousredisFee = _redisFee;
330         _previoustaxFee = _taxFee;
331  
332         _redisFee = 0;
333         _taxFee = 0;
334     }
335  
336     function restoreAllFee() private {
337         _redisFee = _previousredisFee;
338         _taxFee = _previoustaxFee;
339     }
340  
341     function _approve(
342         address owner,
343         address spender,
344         uint256 amount
345     ) private {
346         require(owner != address(0), "ERC20: approve from the zero address");
347         require(spender != address(0), "ERC20: approve to the zero address");
348         _allowances[owner][spender] = amount;
349         emit Approval(owner, spender, amount);
350     }
351  
352     function _transfer(
353         address from,
354         address to,
355         uint256 amount
356     ) private {
357         require(from != address(0), "ERC20: transfer from the zero address");
358         require(to != address(0), "ERC20: transfer to the zero address");
359         require(amount > 0, "Transfer amount must be greater than zero");
360  
361         if (from != owner() && to != owner()) {
362  
363             //Trade start check
364             if (!tradingOpen) {
365                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
366             }
367  
368             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
369             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
370  
371             if(to != uniswapV2Pair) {
372                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
373             }
374  
375             uint256 contractTokenBalance = balanceOf(address(this));
376             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
377  
378             if(contractTokenBalance >= _maxTxAmount)
379             {
380                 contractTokenBalance = _maxTxAmount;
381             }
382  
383             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
384                 swapTokensForEth(contractTokenBalance);
385                 uint256 contractETHBalance = address(this).balance;
386                 if (contractETHBalance > 0) {
387                     sendETHToFee(address(this).balance);
388                 }
389             }
390         }
391  
392         bool takeFee = true;
393  
394         //Transfer Tokens
395         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
396             takeFee = false;
397         } else {
398  
399             //Set Fee for Buys
400             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
401                 _redisFee = _redisFeeOnBuy;
402                 _taxFee = _taxFeeOnBuy;
403             }
404  
405             //Set Fee for Sells
406             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
407                 _redisFee = _redisFeeOnSell;
408                 _taxFee = _taxFeeOnSell;
409             }
410  
411         }
412  
413         _tokenTransfer(from, to, amount, takeFee);
414     }
415  
416     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
417         address[] memory path = new address[](2);
418         path[0] = address(this);
419         path[1] = uniswapV2Router.WETH();
420         _approve(address(this), address(uniswapV2Router), tokenAmount);
421         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
422             tokenAmount,
423             0,
424             path,
425             address(this),
426             block.timestamp
427         );
428     }
429  
430     function sendETHToFee(uint256 amount) private {
431         _marketingAddress.transfer(amount);
432     }
433 
434     ///Enables Trading
435     function setTrading(bool _tradingOpen) public onlyOwner {
436         tradingOpen = _tradingOpen;
437     }
438 
439     ///Withdrawls any eth that's sent to this contract
440     function manualswap() external {
441         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
442         uint256 contractBalance = balanceOf(address(this));
443         swapTokensForEth(contractBalance);
444     }
445 
446     ///Withdrawls any erc20 that's sent to this contract
447     function manualsend() external {
448         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
449         uint256 contractETHBalance = address(this).balance;
450         sendETHToFee(contractETHBalance);
451     }
452 
453     ///Input must be ["address","address"]
454     function blockBots(address[] memory bots_) public onlyOwner {
455         for (uint256 i = 0; i < bots_.length; i++) {
456             bots[bots_[i]] = true;
457         }
458     }
459 
460     ///Removes 1 address as bot
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
526         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
527     }
528  
529     function _getTValues(
530         uint256 tAmount,
531         uint256 redisFee,
532         uint256 taxFee
533     )
534         private
535         pure
536         returns (
537             uint256,
538             uint256,
539             uint256
540         )
541     {
542         uint256 tFee = tAmount.mul(redisFee).div(100);
543         uint256 tTeam = tAmount.mul(taxFee).div(100);
544         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
545         return (tTransferAmount, tFee, tTeam);
546     }
547  
548     function _getRValues(
549         uint256 tAmount,
550         uint256 tFee,
551         uint256 tTeam,
552         uint256 currentRate
553     )
554         private
555         pure
556         returns (
557             uint256,
558             uint256,
559             uint256
560         )
561     {
562         uint256 rAmount = tAmount.mul(currentRate);
563         uint256 rFee = tFee.mul(currentRate);
564         uint256 rTeam = tTeam.mul(currentRate);
565         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
566         return (rAmount, rTransferAmount, rFee);
567     }
568  
569     function _getRate() private view returns (uint256) {
570         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
571         return rSupply.div(tSupply);
572     }
573  
574     function _getCurrentSupply() private view returns (uint256, uint256) {
575         uint256 rSupply = _rTotal;
576         uint256 tSupply = _tTotal;
577         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
578         return (rSupply, tSupply);
579     }
580 
581     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
582         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 4, "Buy rewards must be between 0% and 4%");
583         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 99, "Buy tax must be between 0% and 99%");
584         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 4, "Sell rewards must be between 0% and 4%");
585         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 99, "Sell tax must be between 0% and 99%");
586 
587         _redisFeeOnBuy = redisFeeOnBuy;
588         _redisFeeOnSell = redisFeeOnSell;
589         _taxFeeOnBuy = taxFeeOnBuy;
590         _taxFeeOnSell = taxFeeOnSell;
591 
592     }
593  
594     ///Set minimum tokens required to swap.
595     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
596         _swapTokensAtAmount = swapTokensAtAmount;
597     }
598  
599     ///Set minimum tokens required to swap.
600     function toggleSwap(bool _swapEnabled) public onlyOwner {
601         swapEnabled = _swapEnabled;
602     }
603  
604     ///Set maximum transaction
605     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
606            _maxTxAmount = maxTxAmount;
607         
608     }
609 
610     ///Set maximum wallet size
611     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
612         _maxWalletSize = maxWalletSize;
613     }
614 
615     ///This allows for other accounts to avoid the tax / walletsize / txn amount
616     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
617         for(uint256 i = 0; i < accounts.length; i++) {
618             _isExcludedFromFee[accounts[i]] = excluded;
619         }
620     }
621 
622 }