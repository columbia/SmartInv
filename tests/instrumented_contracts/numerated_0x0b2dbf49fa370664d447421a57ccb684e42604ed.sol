1 // Telegram - https://t.me/sybot_official
2 // Website - https://sybot.xyz/
3 // Twitter - https://twitter.com/sybotxyz
4 // The next level of airdrop farming with randomised IP addresses 
5 
6 /*
7                                                 ,                               
8                                                @@@.                             
9                                       @@*     @@@                               
10                                       @@@   *@@@                                
11                                        @@@  @@@   %@@@@@&                       
12                                         (@@@@&&@@@@&                            
13                                ##,,,,,,,,,,,,*&.                                
14                    %,,,#,%,,,,,,,,,,,,,,,,,,,,,,,,,,,#                          
15                 /,,,,%,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*****                       
16                ,,,/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*******                    
17             *,,,,,,,/%%*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,***,,,,,,,,              
18           /,,,,&,/         ,,,,,,,,,,,,,,*        &,,,,,,,,,,,,,,,*             
19          ,,,,,(,,     %    /,,,,,,,,,,,%     *      .,,&,,,,,,,,,,,/            
20        %,,,,,,,,,,/       %,,,,,,,,,,,,%             ,,,/,,,,,,,,,,,*,          
21        ,,,,,,,*,,,,,,,,,,,,....,#,,,,,,,,(        &,,,,,**,,,,,,,,,,,**.        
22       &**,,,,,/,,,,...........,,,,,,,..*%%(,,,,,,,,,,,,**&,,,,,,,,,,,,***\/      
23       &***,,,,,&,............,*,,,.........,,,,,,,,,,****#,,,,,,,,,,,,,****     
24        *****,,*...........................,,,,***********%,,,,,,,,,,,,,,*****   
25         **&..............................,,,,************&,,,,,,,,,,,,,,,****   
26       &.................................,,,(***********&*%,,,,,,,,,,,,,,,*****  
27     %...................................,,,*******&******&,,,,,,,,,,,,,,,*****  
28     ....................................,,****************,,,,,,,,,,,,,******%  
29     &..................................,,,*,,**************,,,,,,,**********(   
30       ................................,,,,,,,,,,,,***********,,,**********\/     
31         ,..........................,,,,,,,,,,,,,,,,,,************%&%%&/**#      
32              (,.............,,,,,*%,,,,,,,,,,,,,,,,,,,,,******************      
33                ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*****************     
34               (,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,****************&    
35               ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,***************    
36              %,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,***************    
37  %(          &,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,**************    
38  &**,,,,,,,,*#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,***********\/(%    
39    ****,,,,***,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,..%**\/......     
40      &********#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,..,,....,,,,,,*....
41         *******%,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#..,,,,,,,,,,,,,,,,* 
42            &*****,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#..,,,,,,,,,,,,,,,,   
43                 ((/,,,,,,,,,,,,,,,,,,*************, ,*****..,,,,,,,,,,,,,,,%    
44                      #************************************..,,,,,,,,,,,,,*      
45                          /*************************%/     ,.,,,,,,,,,,&         
46                        ,,,,,,,,%(*******\/(&,                %.,,,,&             
47                      &.........,,,,,,,,,...
48 
49 */                                
50 
51 
52 
53 
54 // SPDX-License-Identifier: Unlicensed
55 pragma solidity ^0.8.17;
56  
57 abstract contract Context {
58     function _msgSender() internal view virtual returns (address) {
59         return msg.sender;
60     }
61 }
62  
63 interface IERC20 {
64     function totalSupply() external view returns (uint256);
65  
66     function balanceOf(address account) external view returns (uint256);
67  
68     function transfer(address recipient, uint256 amount) external returns (bool);
69  
70     function allowance(address owner, address spender) external view returns (uint256);
71  
72     function approve(address spender, uint256 amount) external returns (bool);
73  
74     function transferFrom(
75         address sender,
76         address recipient,
77         uint256 amount
78     ) external returns (bool);
79  
80     event Transfer(address indexed from, address indexed to, uint256 value);
81     event Approval(
82         address indexed owner,
83         address indexed spender,
84         uint256 value
85     );
86 }
87  
88 contract Ownable is Context {
89     address private _owner;
90     address private _previousOwner;
91     event OwnershipTransferred(
92         address indexed previousOwner,
93         address indexed newOwner
94     );
95  
96     constructor() {
97         address msgSender = _msgSender();
98         _owner = msgSender;
99         emit OwnershipTransferred(address(0), msgSender);
100     }
101  
102     function owner() public view returns (address) {
103         return _owner;
104     }
105  
106     modifier onlyOwner() {
107         require(_owner == _msgSender(), "Ownable: caller is not the owner");
108         _;
109     }
110  
111     function renounceOwnership() public virtual onlyOwner {
112         emit OwnershipTransferred(_owner, address(0));
113         _owner = address(0);
114     }
115  
116     function transferOwnership(address newOwner) public virtual onlyOwner {
117         require(newOwner != address(0), "Ownable: new owner is the zero address");
118         emit OwnershipTransferred(_owner, newOwner);
119         _owner = newOwner;
120     }
121  
122 }
123  
124 library SafeMath {
125     function add(uint256 a, uint256 b) internal pure returns (uint256) {
126         uint256 c = a + b;
127         require(c >= a, "SafeMath: addition overflow");
128         return c;
129     }
130  
131     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132         return sub(a, b, "SafeMath: subtraction overflow");
133     }
134  
135     function sub(
136         uint256 a,
137         uint256 b,
138         string memory errorMessage
139     ) internal pure returns (uint256) {
140         require(b <= a, errorMessage);
141         uint256 c = a - b;
142         return c;
143     }
144  
145     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
146         if (a == 0) {
147             return 0;
148         }
149         uint256 c = a * b;
150         require(c / a == b, "SafeMath: multiplication overflow");
151         return c;
152     }
153  
154     function div(uint256 a, uint256 b) internal pure returns (uint256) {
155         return div(a, b, "SafeMath: division by zero");
156     }
157  
158     function div(
159         uint256 a,
160         uint256 b,
161         string memory errorMessage
162     ) internal pure returns (uint256) {
163         require(b > 0, errorMessage);
164         uint256 c = a / b;
165         return c;
166     }
167 }
168  
169 interface IUniswapV2Factory {
170     function createPair(address tokenA, address tokenB)
171         external
172         returns (address pair);
173 }
174  
175 interface IUniswapV2Router02 {
176     function swapExactTokensForETHSupportingFeeOnTransferTokens(
177         uint256 amountIn,
178         uint256 amountOutMin,
179         address[] calldata path,
180         address to,
181         uint256 deadline
182     ) external;
183  
184     function factory() external pure returns (address);
185  
186     function WETH() external pure returns (address);
187  
188     function addLiquidityETH(
189         address token,
190         uint256 amountTokenDesired,
191         uint256 amountTokenMin,
192         uint256 amountETHMin,
193         address to,
194         uint256 deadline
195     )
196         external
197         payable
198         returns (
199             uint256 amountToken,
200             uint256 amountETH,
201             uint256 liquidity
202         );
203 }
204  
205 contract SYBOT is Context, IERC20, Ownable {
206  
207     using SafeMath for uint256;
208  
209     string private constant _name = "SYBOT";
210     string private constant _symbol = "SYBOT";
211     uint8 private constant _decimals = 9;
212  
213     mapping(address => uint256) private _rOwned;
214     mapping(address => uint256) private _tOwned;
215     mapping(address => mapping(address => uint256)) private _allowances;
216     mapping(address => bool) private _isExcludedFromFee;
217     uint256 private constant MAX = ~uint256(0);
218     uint256 private constant _tTotal = 100000000 * 10**9;
219     uint256 private _rTotal = (MAX - (MAX % _tTotal));
220     uint256 private _tFeeTotal;
221     uint256 private _redisFeeOnBuy = 0;  
222     uint256 private _taxFeeOnBuy = 0;  
223     uint256 private _redisFeeOnSell = 0;  
224     uint256 private _taxFeeOnSell = 0;
225  
226     //Original Fee
227     uint256 private _redisFee = _redisFeeOnSell;
228     uint256 private _taxFee = _taxFeeOnSell;
229  
230     uint256 private _previousredisFee = _redisFee;
231     uint256 private _previoustaxFee = _taxFee;
232  
233     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
234     address payable private _developmentAddress = payable(0x0); 
235     address payable private _marketingAddress = payable(0x0);
236  
237     IUniswapV2Router02 public uniswapV2Router;
238     address public uniswapV2Pair;
239  
240     bool private tradingOpen;
241     bool private inSwap = false;
242     bool private swapEnabled = true;
243  
244     uint256 public _maxTxAmount = 5000000 * 10**9; 
245     uint256 public _maxWalletSize = 5000000 * 10**9; 
246     uint256 public _swapTokensAtAmount = 1000 * 10**9;
247  
248     event MaxTxAmountUpdated(uint256 _maxTxAmount);
249     modifier lockTheSwap {
250         inSwap = true;
251         _;
252         inSwap = false;
253     }
254  
255     constructor() {
256  
257         _rOwned[_msgSender()] = _rTotal;
258  
259         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
260         uniswapV2Router = _uniswapV2Router;
261         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
262             .createPair(address(this), _uniswapV2Router.WETH());
263  
264         _isExcludedFromFee[owner()] = true;
265         _isExcludedFromFee[address(this)] = true;
266         _isExcludedFromFee[_developmentAddress] = true;
267         _isExcludedFromFee[_marketingAddress] = true;
268  
269         emit Transfer(address(0), _msgSender(), _tTotal);
270     }
271  
272     function name() public pure returns (string memory) {
273         return _name;
274     }
275  
276     function symbol() public pure returns (string memory) {
277         return _symbol;
278     }
279  
280     function decimals() public pure returns (uint8) {
281         return _decimals;
282     }
283  
284     function totalSupply() public pure override returns (uint256) {
285         return _tTotal;
286     }
287  
288     function balanceOf(address account) public view override returns (uint256) {
289         return tokenFromReflection(_rOwned[account]);
290     }
291  
292     function transfer(address recipient, uint256 amount)
293         public
294         override
295         returns (bool)
296     {
297         _transfer(_msgSender(), recipient, amount);
298         return true;
299     }
300  
301     function allowance(address owner, address spender)
302         public
303         view
304         override
305         returns (uint256)
306     {
307         return _allowances[owner][spender];
308     }
309  
310     function approve(address spender, uint256 amount)
311         public
312         override
313         returns (bool)
314     {
315         _approve(_msgSender(), spender, amount);
316         return true;
317     }
318  
319     function transferFrom(
320         address sender,
321         address recipient,
322         uint256 amount
323     ) public override returns (bool) {
324         _transfer(sender, recipient, amount);
325         _approve(
326             sender,
327             _msgSender(),
328             _allowances[sender][_msgSender()].sub(
329                 amount,
330                 "ERC20: transfer amount exceeds allowance"
331             )
332         );
333         return true;
334     }
335  
336     function tokenFromReflection(uint256 rAmount)
337         private
338         view
339         returns (uint256)
340     {
341         require(
342             rAmount <= _rTotal,
343             "Amount must be less than total reflections"
344         );
345         uint256 currentRate = _getRate();
346         return rAmount.div(currentRate);
347     }
348  
349     function removeAllFee() private {
350         if (_redisFee == 0 && _taxFee == 0) return;
351  
352         _previousredisFee = _redisFee;
353         _previoustaxFee = _taxFee;
354  
355         _redisFee = 0;
356         _taxFee = 0;
357     }
358  
359     function restoreAllFee() private {
360         _redisFee = _previousredisFee;
361         _taxFee = _previoustaxFee;
362     }
363  
364     function _approve(
365         address owner,
366         address spender,
367         uint256 amount
368     ) private {
369         require(owner != address(0), "ERC20: approve from the zero address");
370         require(spender != address(0), "ERC20: approve to the zero address");
371         _allowances[owner][spender] = amount;
372         emit Approval(owner, spender, amount);
373     }
374  
375     function _transfer(
376         address from,
377         address to,
378         uint256 amount
379     ) private {
380         require(from != address(0), "ERC20: transfer from the zero address");
381         require(to != address(0), "ERC20: transfer to the zero address");
382         require(amount > 0, "Transfer amount must be greater than zero");
383  
384         if (from != owner() && to != owner()) {
385  
386             //Trade start check
387             if (!tradingOpen) {
388                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
389             }
390  
391             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
392             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
393  
394             if(to != uniswapV2Pair) {
395                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
396             }
397  
398             uint256 contractTokenBalance = balanceOf(address(this));
399             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
400  
401             if(contractTokenBalance >= _maxTxAmount)
402             {
403                 contractTokenBalance = _maxTxAmount;
404             }
405  
406             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
407                 swapTokensForEth(contractTokenBalance);
408                 uint256 contractETHBalance = address(this).balance;
409                 if (contractETHBalance > 0) {
410                     sendETHToFee(address(this).balance);
411                 }
412             }
413         }
414  
415         bool takeFee = true;
416  
417         //Transfer Tokens
418         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
419             takeFee = false;
420         } else {
421  
422             //Set Fee for Buys
423             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
424                 _redisFee = _redisFeeOnBuy;
425                 _taxFee = _taxFeeOnBuy;
426             }
427  
428             //Set Fee for Sells
429             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
430                 _redisFee = _redisFeeOnSell;
431                 _taxFee = _taxFeeOnSell;
432             }
433  
434         }
435  
436         _tokenTransfer(from, to, amount, takeFee);
437     }
438  
439     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
440         address[] memory path = new address[](2);
441         path[0] = address(this);
442         path[1] = uniswapV2Router.WETH();
443         _approve(address(this), address(uniswapV2Router), tokenAmount);
444         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
445             tokenAmount,
446             0,
447             path,
448             address(this),
449             block.timestamp
450         );
451     }
452  
453     function sendETHToFee(uint256 amount) private {
454         _marketingAddress.transfer(amount);
455     }
456  
457     function setTrading(bool _tradingOpen) public onlyOwner {
458         tradingOpen = _tradingOpen;
459     }
460  
461     function manualswap() external {
462         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
463         uint256 contractBalance = balanceOf(address(this));
464         swapTokensForEth(contractBalance);
465     }
466  
467     function manualsend() external {
468         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
469         uint256 contractETHBalance = address(this).balance;
470         sendETHToFee(contractETHBalance);
471     }
472  
473     function blockBots(address[] memory bots_) public onlyOwner {
474         for (uint256 i = 0; i < bots_.length; i++) {
475             bots[bots_[i]] = true;
476         }
477     }
478  
479     function unblockBot(address notbot) public onlyOwner {
480         bots[notbot] = false;
481     }
482  
483     function _tokenTransfer(
484         address sender,
485         address recipient,
486         uint256 amount,
487         bool takeFee
488     ) private {
489         if (!takeFee) removeAllFee();
490         _transferStandard(sender, recipient, amount);
491         if (!takeFee) restoreAllFee();
492     }
493  
494     function _transferStandard(
495         address sender,
496         address recipient,
497         uint256 tAmount
498     ) private {
499         (
500             uint256 rAmount,
501             uint256 rTransferAmount,
502             uint256 rFee,
503             uint256 tTransferAmount,
504             uint256 tFee,
505             uint256 tTeam
506         ) = _getValues(tAmount);
507         _rOwned[sender] = _rOwned[sender].sub(rAmount);
508         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
509         _takeTeam(tTeam);
510         _reflectFee(rFee, tFee);
511         emit Transfer(sender, recipient, tTransferAmount);
512     }
513  
514     function _takeTeam(uint256 tTeam) private {
515         uint256 currentRate = _getRate();
516         uint256 rTeam = tTeam.mul(currentRate);
517         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
518     }
519  
520     function _reflectFee(uint256 rFee, uint256 tFee) private {
521         _rTotal = _rTotal.sub(rFee);
522         _tFeeTotal = _tFeeTotal.add(tFee);
523     }
524  
525     receive() external payable {}
526  
527     function _getValues(uint256 tAmount)
528         private
529         view
530         returns (
531             uint256,
532             uint256,
533             uint256,
534             uint256,
535             uint256,
536             uint256
537         )
538     {
539         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
540             _getTValues(tAmount, _redisFee, _taxFee);
541         uint256 currentRate = _getRate();
542         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
543             _getRValues(tAmount, tFee, tTeam, currentRate);
544         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
545     }
546  
547     function _getTValues(
548         uint256 tAmount,
549         uint256 redisFee,
550         uint256 taxFee
551     )
552         private
553         pure
554         returns (
555             uint256,
556             uint256,
557             uint256
558         )
559     {
560         uint256 tFee = tAmount.mul(redisFee).div(100);
561         uint256 tTeam = tAmount.mul(taxFee).div(100);
562         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
563         return (tTransferAmount, tFee, tTeam);
564     }
565  
566     function _getRValues(
567         uint256 tAmount,
568         uint256 tFee,
569         uint256 tTeam,
570         uint256 currentRate
571     )
572         private
573         pure
574         returns (
575             uint256,
576             uint256,
577             uint256
578         )
579     {
580         uint256 rAmount = tAmount.mul(currentRate);
581         uint256 rFee = tFee.mul(currentRate);
582         uint256 rTeam = tTeam.mul(currentRate);
583         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
584         return (rAmount, rTransferAmount, rFee);
585     }
586  
587     function _getRate() private view returns (uint256) {
588         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
589         return rSupply.div(tSupply);
590     }
591  
592     function _getCurrentSupply() private view returns (uint256, uint256) {
593         uint256 rSupply = _rTotal;
594         uint256 tSupply = _tTotal;
595         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
596         return (rSupply, tSupply);
597     }
598  
599     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
600         require(redisFeeOnBuy >= 0 && redisFeeOnBuy <= 4, "Buy rewards must be between 0% and 4%");
601         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 99, "Buy tax must be between 0% and 99%");
602         require(redisFeeOnSell >= 0 && redisFeeOnSell <= 4, "Sell rewards must be between 0% and 4%");
603         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 99, "Sell tax must be between 0% and 99%");
604 
605         _redisFeeOnBuy = redisFeeOnBuy;
606         _redisFeeOnSell = redisFeeOnSell;
607         _taxFeeOnBuy = taxFeeOnBuy;
608         _taxFeeOnSell = taxFeeOnSell;
609 
610     }
611  
612     //Set minimum tokens required to swap.
613     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
614         _swapTokensAtAmount = swapTokensAtAmount;
615     }
616  
617     //Set minimum tokens required to swap.
618     function toggleSwap(bool _swapEnabled) public onlyOwner {
619         swapEnabled = _swapEnabled;
620     }
621  
622     //Set maximum transaction
623     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
624            _maxTxAmount = maxTxAmount;
625         
626     }
627  
628     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
629         _maxWalletSize = maxWalletSize;
630     }
631  
632     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
633         for(uint256 i = 0; i < accounts.length; i++) {
634             _isExcludedFromFee[accounts[i]] = excluded;
635         }
636     }
637 
638 }