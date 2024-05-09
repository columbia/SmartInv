1 /**
2 
3 WEB: https://www.acasbot.io/
4 TWITTER/X: https://twitter.com/ACASerc
5 TELEGRAM: https://t.me/acas_eth
6 GITBOOK: https://along-came-a-spider.gitbook.io/thesis/
7 
8            ;               ,           
9          ,;                 '.         
10         ;:                   :;        
11        ::                     ::       
12        ::                     ::       
13        ':                     :        
14         :.                    :        
15      ;' ::                   ::  '     
16     .'  ';                   ;'  '.    
17    ::    :;                 ;:    ::   
18    ;      :;.             ,;:     ::   
19    :;      :;:           ,;"      ::   
20    ::.      ':;  ..,.;  ;:'     ,.;:   
21     "'"...   '::,::::: ;:   .;.;""'    
22         '"""....;:::::;,;.;"""         
23     .:::.....'"':::::::'",...;::::;.   
24    ;:' '""'"";.,;:::::;.'""""""  ':;   
25   ::'         ;::;:::;::..         :;  
26  ::         ,;:::::::::::;:..       :: 
27  ;'     ,;;:;::::::::::::::;";..    ':.
28 ::     ;:"  ::::::::::::::::  ":     ::
29  :.    ::   ::::::::::::::::   :     ; 
30   ;    ::   ::::::::::::::::   :    ;  
31    '   ::   :::::::::::::::'  ,:   '   
32     '  ::    :::::::::::::"   ::       
33        ::     ':::::::::"'    ::       
34        ':       """""""'      ::       
35         ::                   ;:        
36         ':;                 ;:"        
37           ';              ,;'          
38             "'           '"            
39               '
40 
41 
42 */
43 
44 //SPDX-License-Identifier: UNLICENCED
45 
46 
47 
48 pragma solidity ^0.8.16;
49 
50 abstract contract Context {
51     function _msgSender() internal view virtual returns (address) {
52         return msg.sender;
53     }
54 }
55 
56 interface IERC20 {
57     function totalSupply() external view returns (uint256);
58 
59     function balanceOf(address account) external view returns (uint256);
60 
61     function transfer(address recipient, uint256 amount) external returns (bool);
62 
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72 
73     event Transfer(address indexed from, address indexed to, uint256 value);
74     event Approval(
75         address indexed owner,
76         address indexed spender,
77         uint256 value
78     );
79 }
80 
81 contract Ownable is Context {
82     address private _owner;
83     address private _previousOwner;
84     event OwnershipTransferred(
85         address indexed previousOwner,
86         address indexed newOwner
87     );
88 
89     constructor() {
90         address msgSender = _msgSender();
91         _owner = msgSender;
92         emit OwnershipTransferred(address(0), msgSender);
93     }
94 
95     function owner() public view returns (address) {
96         return _owner;
97     }
98 
99     modifier onlyOwner() {
100         require(_owner == _msgSender(), "Ownable: caller is not the owner");
101         _;
102     }
103 
104     function renounceOwnership() public virtual onlyOwner {
105         emit OwnershipTransferred(_owner, address(0));
106         _owner = address(0);
107     }
108 
109     function transferOwnership(address newOwner) public virtual onlyOwner {
110         require(newOwner != address(0), "Ownable: new owner is the zero address");
111         emit OwnershipTransferred(_owner, newOwner);
112         _owner = newOwner;
113     }
114 
115 }
116 
117 library SafeMath {
118     function add(uint256 a, uint256 b) internal pure returns (uint256) {
119         uint256 c = a + b;
120         require(c >= a, "SafeMath: addition overflow");
121         return c;
122     }
123 
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         return sub(a, b, "SafeMath: subtraction overflow");
126     }
127 
128     function sub(
129         uint256 a,
130         uint256 b,
131         string memory errorMessage
132     ) internal pure returns (uint256) {
133         require(b <= a, errorMessage);
134         uint256 c = a - b;
135         return c;
136     }
137 
138     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
139         if (a == 0) {
140             return 0;
141         }
142         uint256 c = a * b;
143         require(c / a == b, "SafeMath: multiplication overflow");
144         return c;
145     }
146 
147     function div(uint256 a, uint256 b) internal pure returns (uint256) {
148         return div(a, b, "SafeMath: division by zero");
149     }
150 
151     function div(
152         uint256 a,
153         uint256 b,
154         string memory errorMessage
155     ) internal pure returns (uint256) {
156         require(b > 0, errorMessage);
157         uint256 c = a / b;
158         return c;
159     }
160 }
161 
162 interface IUniswapV2Factory {
163     function createPair(address tokenA, address tokenB)
164         external
165         returns (address pair);
166 }
167 
168 interface IUniswapV2Router02 {
169     function swapExactTokensForETHSupportingFeeOnTransferTokens(
170         uint256 amountIn,
171         uint256 amountOutMin,
172         address[] calldata path,
173         address to,
174         uint256 deadline
175     ) external;
176 
177     function factory() external pure returns (address);
178 
179     function WETH() external pure returns (address);
180 
181     function addLiquidityETH(
182         address token,
183         uint256 amountTokenDesired,
184         uint256 amountTokenMin,
185         uint256 amountETHMin,
186         address to,
187         uint256 deadline
188     )
189         external
190         payable
191         returns (
192             uint256 amountToken,
193             uint256 amountETH,
194             uint256 liquidity
195         );
196 }
197 
198 contract ACAS is Context, IERC20, Ownable {
199 
200     using SafeMath for uint256;
201 
202     string private constant _name = "Along Came a Spider";
203     string private constant _symbol = "SPIDER";
204     uint8 private constant _decimals = 9;
205 
206     mapping(address => uint256) private _rOwned;
207     mapping(address => uint256) private _tOwned;
208     mapping(address => mapping(address => uint256)) private _allowances;
209     mapping(address => bool) private _isExcludedFromFee;
210     uint256 private constant MAX = ~uint256(0);
211     uint256 private constant _tTotal = 420690000 * 10**9;
212     uint256 private _rTotal = (MAX - (MAX % _tTotal));
213     uint256 private _tFeeTotal;
214     uint256 private _redisFeeOnBuy = 0;
215     uint256 private _taxFeeOnBuy = 20;
216     uint256 private _redisFeeOnSell = 0;
217     uint256 private _taxFeeOnSell = 25;
218 
219     //Original Fee
220     uint256 private _redisFee = _redisFeeOnSell;
221     uint256 private _taxFee = _taxFeeOnSell;
222 
223     uint256 private _previousredisFee = _redisFee;
224     uint256 private _previoustaxFee = _taxFee;
225 
226     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
227     address payable private _developmentAddress = payable(msg.sender);
228     address payable private _marketingAddress = payable(msg.sender);
229 
230     IUniswapV2Router02 public uniswapV2Router;
231     address public uniswapV2Pair;
232  
233     bool private tradingOpen = true;
234     bool private inSwap = false;
235     bool private swapEnabled = true;
236 
237     uint256 public _maxTxAmount = 8413800 * 10**9;
238     uint256 public _maxWalletSize = 8413800 * 10**9;
239     uint256 public _swapTokensAtAmount = 8413800 * 10**9;
240 
241     event MaxTxAmountUpdated(uint256 _maxTxAmount);
242     modifier lockTheSwap {
243         inSwap = true;
244         _;
245         inSwap = false;
246     }
247 
248     constructor() {
249 
250         _rOwned[_msgSender()] = _rTotal;
251 
252         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
253         uniswapV2Router = _uniswapV2Router;
254         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
255             .createPair(address(this), _uniswapV2Router.WETH());
256 
257         _isExcludedFromFee[owner()] = true;
258         _isExcludedFromFee[address(this)] = true;
259         _isExcludedFromFee[_developmentAddress] = true;
260         _isExcludedFromFee[_marketingAddress] = true;
261 
262         emit Transfer(address(0), _msgSender(), _tTotal);
263     }
264 
265     function name() public pure returns (string memory) {
266         return _name;
267     }
268 
269     function symbol() public pure returns (string memory) {
270         return _symbol;
271     }
272 
273     function decimals() public pure returns (uint8) {
274         return _decimals;
275     }
276 
277     function totalSupply() public pure override returns (uint256) {
278         return _tTotal;
279     }
280 
281     function balanceOf(address account) public view override returns (uint256) {
282         return tokenFromReflection(_rOwned[account]);
283     }
284 
285     function transfer(address recipient, uint256 amount)
286         public
287         override
288         returns (bool)
289     {
290         _transfer(_msgSender(), recipient, amount);
291         return true;
292     }
293 
294     function allowance(address owner, address spender)
295         public
296         view
297         override
298         returns (uint256)
299     {
300         return _allowances[owner][spender];
301     }
302 
303     function approve(address spender, uint256 amount)
304         public
305         override
306         returns (bool)
307     {
308         _approve(_msgSender(), spender, amount);
309         return true;
310     }
311 
312     function transferFrom(
313         address sender,
314         address recipient,
315         uint256 amount
316     ) public override returns (bool) {
317         _transfer(sender, recipient, amount);
318         _approve(
319             sender,
320             _msgSender(),
321             _allowances[sender][_msgSender()].sub(
322                 amount,
323                 "ERC20: transfer amount exceeds allowance"
324             )
325         );
326         return true;
327     }
328 
329     function tokenFromReflection(uint256 rAmount)
330         private
331         view
332         returns (uint256)
333     {
334         require(
335             rAmount <= _rTotal,
336             "Amount must be less than total reflections"
337         );
338         uint256 currentRate = _getRate();
339         return rAmount.div(currentRate);
340     }
341 
342     function removeAllFee() private {
343         if (_redisFee == 0 && _taxFee == 0) return;
344 
345         _previousredisFee = _redisFee;
346         _previoustaxFee = _taxFee;
347 
348         _redisFee = 0;
349         _taxFee = 0;
350     }
351 
352     function restoreAllFee() private {
353         _redisFee = _previousredisFee;
354         _taxFee = _previoustaxFee;
355     }
356 
357     function _approve(
358         address owner,
359         address spender,
360         uint256 amount
361     ) private {
362         require(owner != address(0), "ERC20: approve from the zero address");
363         require(spender != address(0), "ERC20: approve to the zero address");
364         _allowances[owner][spender] = amount;
365         emit Approval(owner, spender, amount);
366     }
367 
368     function _transfer(
369         address from,
370         address to,
371         uint256 amount
372     ) private {
373         require(from != address(0), "ERC20: transfer from the zero address");
374         require(to != address(0), "ERC20: transfer to the zero address");
375         require(amount > 0, "Transfer amount must be greater than zero");
376 
377         if (from != owner() && to != owner()) {
378 
379             //Trade start check
380             if (!tradingOpen) {
381                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
382             }
383 
384             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
385             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
386 
387             if(to != uniswapV2Pair) {
388                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
389             }
390 
391             uint256 contractTokenBalance = balanceOf(address(this));
392             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
393 
394             if(contractTokenBalance >= _maxTxAmount)
395             {
396                 contractTokenBalance = _maxTxAmount;
397             }
398 
399             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
400                 swapTokensForEth(contractTokenBalance);
401                 uint256 contractETHBalance = address(this).balance;
402                 if (contractETHBalance > 0) {
403                     sendETHToFee(address(this).balance);
404                 }
405             }
406         }
407 
408         bool takeFee = true;
409 
410         //Transfer Tokens
411         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
412             takeFee = false;
413         } else {
414 
415             //Set Fee for Buys
416             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
417                 _redisFee = _redisFeeOnBuy;
418                 _taxFee = _taxFeeOnBuy;
419             }
420 
421             //Set Fee for Sells
422             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
423                 _redisFee = _redisFeeOnSell;
424                 _taxFee = _taxFeeOnSell;
425             }
426 
427         }
428 
429         _tokenTransfer(from, to, amount, takeFee);
430     }
431 
432     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
433         address[] memory path = new address[](2);
434         path[0] = address(this);
435         path[1] = uniswapV2Router.WETH();
436         _approve(address(this), address(uniswapV2Router), tokenAmount);
437         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
438             tokenAmount,
439             0,
440             path,
441             address(this),
442             block.timestamp
443         );
444     }
445 
446     function sendETHToFee(uint256 amount) private {
447         _marketingAddress.transfer(amount);
448     }
449 
450     function setTrading(bool _tradingOpen) public onlyOwner {
451         tradingOpen = _tradingOpen;
452     }
453 
454     function manualswap() external {
455         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
456         uint256 contractBalance = balanceOf(address(this));
457         swapTokensForEth(contractBalance);
458     }
459 
460     function manualsend() external {
461         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
462         uint256 contractETHBalance = address(this).balance;
463         sendETHToFee(contractETHBalance);
464     }
465 
466     function blockbots(address[] memory bots_) public onlyOwner {
467         for (uint256 i = 0; i < bots_.length; i++) {
468             bots[bots_[i]] = true;
469         }
470     }
471 
472     function unblackaddress(address notbot) public onlyOwner {
473         bots[notbot] = false;
474     }
475 
476     function _tokenTransfer(
477         address sender,
478         address recipient,
479         uint256 amount,
480         bool takeFee
481     ) private {
482         if (!takeFee) removeAllFee();
483         _transferStandard(sender, recipient, amount);
484         if (!takeFee) restoreAllFee();
485     }
486 
487     function _transferStandard(
488         address sender,
489         address recipient,
490         uint256 tAmount
491     ) private {
492         (
493             uint256 rAmount,
494             uint256 rTransferAmount,
495             uint256 rFee,
496             uint256 tTransferAmount,
497             uint256 tFee,
498             uint256 tTeam
499         ) = _getValues(tAmount);
500         _rOwned[sender] = _rOwned[sender].sub(rAmount);
501         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
502         _takeTeam(tTeam);
503         _reflectFee(rFee, tFee);
504         emit Transfer(sender, recipient, tTransferAmount);
505     }
506 
507     function _takeTeam(uint256 tTeam) private {
508         uint256 currentRate = _getRate();
509         uint256 rTeam = tTeam.mul(currentRate);
510         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
511     }
512 
513     function _reflectFee(uint256 rFee, uint256 tFee) private {
514         _rTotal = _rTotal.sub(rFee);
515         _tFeeTotal = _tFeeTotal.add(tFee);
516     }
517 
518     receive() external payable {}
519 
520     function _getValues(uint256 tAmount)
521         private
522         view
523         returns (
524             uint256,
525             uint256,
526             uint256,
527             uint256,
528             uint256,
529             uint256
530         )
531     {
532         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
533             _getTValues(tAmount, _redisFee, _taxFee);
534         uint256 currentRate = _getRate();
535         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
536             _getRValues(tAmount, tFee, tTeam, currentRate);
537         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
538     }
539 
540     function _getTValues(
541         uint256 tAmount,
542         uint256 redisFee,
543         uint256 taxFee
544     )
545         private
546         pure
547         returns (
548             uint256,
549             uint256,
550             uint256
551         )
552     {
553         uint256 tFee = tAmount.mul(redisFee).div(100);
554         uint256 tTeam = tAmount.mul(taxFee).div(100);
555         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
556         return (tTransferAmount, tFee, tTeam);
557     }
558 
559     function _getRValues(
560         uint256 tAmount,
561         uint256 tFee,
562         uint256 tTeam,
563         uint256 currentRate
564     )
565         private
566         pure
567         returns (
568             uint256,
569             uint256,
570             uint256
571         )
572     {
573         uint256 rAmount = tAmount.mul(currentRate);
574         uint256 rFee = tFee.mul(currentRate);
575         uint256 rTeam = tTeam.mul(currentRate);
576         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
577         return (rAmount, rTransferAmount, rFee);
578     }
579 
580     function _getRate() private view returns (uint256) {
581         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
582         return rSupply.div(tSupply);
583     }
584 
585     function _getCurrentSupply() private view returns (uint256, uint256) {
586         uint256 rSupply = _rTotal;
587         uint256 tSupply = _tTotal;
588         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
589         return (rSupply, tSupply);
590     }
591 
592     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
593         _redisFeeOnBuy = redisFeeOnBuy;
594         _redisFeeOnSell = redisFeeOnSell;
595         _taxFeeOnBuy = taxFeeOnBuy;
596         _taxFeeOnSell = taxFeeOnSell;
597     }
598 
599     //Set minimum tokens required to swap.
600     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
601         _swapTokensAtAmount = swapTokensAtAmount;
602     }
603 
604     //Set minimum tokens required to swap.
605     function toggleSwap(bool _swapEnabled) public onlyOwner {
606         swapEnabled = _swapEnabled;
607     }
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
623 
624 }