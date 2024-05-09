1 /**
2 
3   sSSs   .S    S.    .S_SSSs     .S_sSSs      sSSs_sSSs     .S     S.          .S   .S_sSSs     .S       S.   
4  d%%SP  .SS    SS.  .SS~SSSSS   .SS~YS%%b    d%%SP~YS%%b   .SS     SS.        .SS  .SS~YS%%b   .SS       SS.  
5 d%S'    S%S    S%S  S%S   SSSS  S%S   `S%b  d%S'     `S%b  S%S     S%S        S%S  S%S   `S%b  S%S       S%S  
6 S%|     S%S    S%S  S%S    S%S  S%S    S%S  S%S       S%S  S%S     S%S        S%S  S%S    S%S  S%S       S%S  
7 S&S     S%S SSSS%S  S%S SSSS%S  S%S    S&S  S&S       S&S  S%S     S%S        S&S  S%S    S&S  S&S       S&S  
8 Y&Ss    S&S  SSS&S  S&S  SSS%S  S&S    S&S  S&S       S&S  S&S     S&S        S&S  S&S    S&S  S&S       S&S  
9 `S&&S   S&S    S&S  S&S    S&S  S&S    S&S  S&S       S&S  S&S     S&S        S&S  S&S    S&S  S&S       S&S  
10   `S*S  S&S    S&S  S&S    S&S  S&S    S&S  S&S       S&S  S&S     S&S        S&S  S&S    S&S  S&S       S&S  
11    l*S  S*S    S*S  S*S    S&S  S*S    d*S  S*b       d*S  S*S     S*S        S*S  S*S    S*S  S*b       d*S  
12   .S*P  S*S    S*S  S*S    S*S  S*S   .S*S  S*S.     .S*S  S*S  .  S*S        S*S  S*S    S*S  S*S.     .S*S  
13 sSS*S   S*S    S*S  S*S    S*S  S*S_sdSSS    SSSbs_sdSSS   S*S_sSs_S*S        S*S  S*S    S*S   SSSbs_sdSSS   
14 YSS'    SSS    S*S  SSS    S*S  DONT~FADE      DONT~FADE    SSS~SSS~S*S        S*S  S*S    SSS    DONT~FADE    
15                SP          SP                                                 SP   SP                         
16                Y           Y                                                  Y    Y                          
17                                                                                                               
18  https://t.me/ShadowInuOfficial
19 */
20 
21 pragma solidity ^0.8.17;
22 // SPDX-License-Identifier: Unlicensed
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 }
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31 
32     function balanceOf(address account) external view returns (uint256);
33 
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     function approve(address spender, uint256 amount) external returns (bool);
39 
40     function transferFrom(
41         address sender,
42         address recipient,
43         uint256 amount
44     ) external returns (bool);
45 
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(
48         address indexed owner,
49         address indexed spender,
50         uint256 value
51     );
52 }
53 
54 contract Ownable is Context {
55     address private _owner;
56     address private _previousOwner;
57     event OwnershipTransferred(
58         address indexed previousOwner,
59         address indexed newOwner
60     );
61 
62     constructor() {
63         address msgSender = _msgSender();
64         _owner = msgSender;
65         emit OwnershipTransferred(address(0), msgSender);
66     }
67 
68     function owner() public view returns (address) {
69         return _owner;
70     }
71 
72     modifier onlyOwner() {
73         require(_owner == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     function renounceOwnership() public virtual onlyOwner {
78         emit OwnershipTransferred(_owner, address(0));
79         _owner = address(0);
80     }
81 
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         emit OwnershipTransferred(_owner, newOwner);
85         _owner = newOwner;
86     }
87 
88 }
89 
90 library SafeMath {
91     function add(uint256 a, uint256 b) internal pure returns (uint256) {
92         uint256 c = a + b;
93         require(c >= a, "SafeMath: addition overflow");
94         return c;
95     }
96 
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         return sub(a, b, "SafeMath: subtraction overflow");
99     }
100 
101     function sub(
102         uint256 a,
103         uint256 b,
104         string memory errorMessage
105     ) internal pure returns (uint256) {
106         require(b <= a, errorMessage);
107         uint256 c = a - b;
108         return c;
109     }
110 
111     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
112         if (a == 0) {
113             return 0;
114         }
115         uint256 c = a * b;
116         require(c / a == b, "SafeMath: multiplication overflow");
117         return c;
118     }
119 
120     function div(uint256 a, uint256 b) internal pure returns (uint256) {
121         return div(a, b, "SafeMath: division by zero");
122     }
123 
124     function div(
125         uint256 a,
126         uint256 b,
127         string memory errorMessage
128     ) internal pure returns (uint256) {
129         require(b > 0, errorMessage);
130         uint256 c = a / b;
131         return c;
132     }
133 }
134 
135 interface IUniswapV2Factory {
136     function createPair(address tokenA, address tokenB)
137         external
138         returns (address pair);
139 }
140 
141 interface IUniswapV2Router02 {
142     function swapExactTokensForETHSupportingFeeOnTransferTokens(
143         uint256 amountIn,
144         uint256 amountOutMin,
145         address[] calldata path,
146         address to,
147         uint256 deadline
148     ) external;
149 
150     function factory() external pure returns (address);
151 
152     function WETH() external pure returns (address);
153 
154     function addLiquidityETH(
155         address token,
156         uint256 amountTokenDesired,
157         uint256 amountTokenMin,
158         uint256 amountETHMin,
159         address to,
160         uint256 deadline
161     )
162         external
163         payable
164         returns (
165             uint256 amountToken,
166             uint256 amountETH,
167             uint256 liquidity
168         );
169 }
170 
171 contract SHADOWINU is Context, IERC20, Ownable {
172 
173     using SafeMath for uint256;
174 
175     string private constant _name = "Shadow Inu";
176     string private constant _symbol = "SHADOW INU";
177     uint8 private constant _decimals = 9;
178 
179     mapping(address => uint256) private _rOwned;
180     mapping(address => uint256) private _tOwned;
181     mapping(address => mapping(address => uint256)) private _allowances;
182     mapping(address => bool) private _isExcludedFromFee;
183     uint256 private constant MAX = ~uint256(0);
184     uint256 private constant _tTotal = 100000000 * 10**_decimals;
185     uint256 private _rTotal = (MAX - (MAX % _tTotal));
186     uint256 private _tFeeTotal;
187     uint256 private _redisFeeOnBuy = 0;
188     uint256 private _taxFeeOnBuy = 3;
189     uint256 private _redisFeeOnSell = 0;
190     uint256 private _taxFeeOnSell = 3;
191 
192     //Original Fee
193     uint256 private _redisFee = _redisFeeOnSell;
194     uint256 private _taxFee = _taxFeeOnSell;
195 
196     uint256 private _previousredisFee = _redisFee;
197     uint256 private _previoustaxFee = _taxFee;
198 
199     mapping(address => bool) public bots; 
200     mapping (address => uint256) public _buyMap;
201     mapping (address => bool) public preTrader;
202     address private developmentAddress;
203     address private marketingAddress;
204     address private devFeeAddress1;
205     address private devFeeAddress2;
206 
207     IUniswapV2Router02 public uniswapV2Router;
208     address public uniswapV2Pair;
209 
210     bool private tradingOpen;
211     bool private inSwap = false;
212     bool private swapEnabled = true;
213 
214     uint256 public _maxTxAmount = 1000000 * 10**_decimals;
215     uint256 public _maxWalletSize = 1000000 * 10**_decimals;
216     uint256 public _swapTokensAtAmount = 150000 * 10**_decimals;
217 
218     struct Distribution {
219         uint256 development;
220         uint256 marketing;
221         uint256 devFee;
222     }
223 
224     Distribution public distribution;
225 
226     event MaxTxAmountUpdated(uint256 _maxTxAmount);
227     modifier lockTheSwap {
228         inSwap = true;
229         _;
230         inSwap = false;
231     }
232 
233     constructor(address developmentAddr, address marketingAddr, address devFeeAddr1, address devFeeAddr2) {
234         developmentAddress = developmentAddr;
235         marketingAddress = marketingAddr;
236         devFeeAddress1 = devFeeAddr1;
237         devFeeAddress2 = devFeeAddr2;
238         _rOwned[_msgSender()] = _rTotal;
239 
240         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
241         uniswapV2Router = _uniswapV2Router;
242         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
243             .createPair(address(this), _uniswapV2Router.WETH());
244 
245         _isExcludedFromFee[owner()] = true;
246         _isExcludedFromFee[address(this)] = true;
247         _isExcludedFromFee[devFeeAddress1] = true;
248         _isExcludedFromFee[devFeeAddress2] = true;
249         _isExcludedFromFee[marketingAddress] = true;
250         _isExcludedFromFee[developmentAddress] = true;
251 
252         distribution = Distribution(32, 32, 36);
253 
254         emit Transfer(address(0), _msgSender(), _tTotal);
255     }
256 
257     function name() public pure returns (string memory) {
258         return _name;
259     }
260 
261     function symbol() public pure returns (string memory) {
262         return _symbol;
263     }
264 
265     function decimals() public pure returns (uint8) {
266         return _decimals;
267     }
268 
269     function totalSupply() public pure override returns (uint256) {
270         return _tTotal;
271     }
272 
273     function balanceOf(address account) public view override returns (uint256) {
274         return tokenFromReflection(_rOwned[account]);
275     }
276 
277     function transfer(address recipient, uint256 amount)
278         public
279         override
280         returns (bool)
281     {
282         _transfer(_msgSender(), recipient, amount);
283         return true;
284     }
285 
286     function allowance(address owner, address spender)
287         public
288         view
289         override
290         returns (uint256)
291     {
292         return _allowances[owner][spender];
293     }
294 
295     function approve(address spender, uint256 amount)
296         public
297         override
298         returns (bool)
299     {
300         _approve(_msgSender(), spender, amount);
301         return true;
302     }
303 
304     function transferFrom(
305         address sender,
306         address recipient,
307         uint256 amount
308     ) public override returns (bool) {
309         _transfer(sender, recipient, amount);
310         _approve(
311             sender,
312             _msgSender(),
313             _allowances[sender][_msgSender()].sub(
314                 amount,
315                 "ERC20: transfer amount exceeds allowance"
316             )
317         );
318         return true;
319     }
320 
321     function tokenFromReflection(uint256 rAmount)
322         private
323         view
324         returns (uint256)
325     {
326         require(
327             rAmount <= _rTotal,
328             "Amount must be less than total reflections"
329         );
330         uint256 currentRate = _getRate();
331         return rAmount.div(currentRate);
332     }
333 
334     function removeAllFee() private {
335         if (_redisFee == 0 && _taxFee == 0) return;
336 
337         _previousredisFee = _redisFee;
338         _previoustaxFee = _taxFee;
339 
340         _redisFee = 0;
341         _taxFee = 0;
342     }
343 
344     function restoreAllFee() private {
345         _redisFee = _previousredisFee;
346         _taxFee = _previoustaxFee;
347     }
348 
349     function _approve(
350         address owner,
351         address spender,
352         uint256 amount
353     ) private {
354         require(owner != address(0), "ERC20: approve from the zero address");
355         require(spender != address(0), "ERC20: approve to the zero address");
356         _allowances[owner][spender] = amount;
357         emit Approval(owner, spender, amount);
358     }
359 
360     function _transfer(
361         address from,
362         address to,
363         uint256 amount
364     ) private {
365         require(from != address(0), "ERC20: transfer from the zero address");
366         require(to != address(0), "ERC20: transfer to the zero address");
367         require(amount > 0, "Transfer amount must be greater than zero");
368 
369         if (from != owner() && to != owner() && !preTrader[from] && !preTrader[to]) {
370 
371             //Trade start check
372             if (!tradingOpen) {
373                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
374             }
375 
376             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
377             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
378 
379             if(to != uniswapV2Pair) {
380                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
381             }
382 
383             uint256 contractTokenBalance = balanceOf(address(this));
384             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
385 
386             if(contractTokenBalance >= _maxTxAmount)
387             {
388                 contractTokenBalance = _maxTxAmount;
389             }
390 
391             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
392                 swapTokensForEth(contractTokenBalance);
393                 uint256 contractETHBalance = address(this).balance;
394                 if (contractETHBalance > 0) {
395                     sendETHToFee(address(this).balance);
396                 }
397             }
398         }
399 
400         bool takeFee = true;
401 
402         //Transfer Tokens
403         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
404             takeFee = false;
405         } else {
406 
407             //Set Fee for Buys
408             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
409                 _redisFee = _redisFeeOnBuy;
410                 _taxFee = _taxFeeOnBuy;
411             }
412 
413             //Set Fee for Sells
414             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
415                 _redisFee = _redisFeeOnSell;
416                 _taxFee = _taxFeeOnSell;
417             }
418 
419         }
420 
421         _tokenTransfer(from, to, amount, takeFee);
422     }
423 
424     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
425         address[] memory path = new address[](2);
426         path[0] = address(this);
427         path[1] = uniswapV2Router.WETH();
428         _approve(address(this), address(uniswapV2Router), tokenAmount);
429         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
430             tokenAmount,
431             0,
432             path,
433             address(this),
434             block.timestamp
435         );
436     }
437 
438     function sendETHToFee(uint256 amount) private lockTheSwap {
439         uint256 distributionEth = amount;
440         uint256 marketingShare = distributionEth.mul(distribution.marketing).div(100);
441         uint256 devFeeShare = distributionEth.mul(distribution.devFee).div(100).div(2);
442         uint256 developmentShare = distributionEth.mul(distribution.development).div(100);
443         payable(marketingAddress).transfer(marketingShare);
444         payable(devFeeAddress1).transfer(devFeeShare);
445         payable(devFeeAddress2).transfer(devFeeShare);
446         payable(developmentAddress).transfer(developmentShare);
447     }
448 
449     function setTrading(bool _tradingOpen) public onlyOwner {
450         tradingOpen = _tradingOpen;
451     }
452 
453     function manualswap() external {
454         require(_msgSender() == developmentAddress || _msgSender() == marketingAddress || _msgSender() == devFeeAddress1 || _msgSender() == devFeeAddress2);
455         uint256 contractBalance = balanceOf(address(this));
456         swapTokensForEth(contractBalance);
457     }
458 
459     function manualsend() external {
460         require(_msgSender() == developmentAddress || _msgSender() == marketingAddress || _msgSender() == devFeeAddress1 || _msgSender() == devFeeAddress2);
461         uint256 contractETHBalance = address(this).balance;
462         sendETHToFee(contractETHBalance);
463     }
464 
465     function blockBots(address[] memory bots_) public onlyOwner {
466         for (uint256 i = 0; i < bots_.length; i++) {
467             bots[bots_[i]] = true;
468         }
469     }
470 
471     function unblockBot(address notbot) public onlyOwner {
472         bots[notbot] = false;
473     }
474 
475     function _tokenTransfer(
476         address sender,
477         address recipient,
478         uint256 amount,
479         bool takeFee
480     ) private {
481         if (!takeFee) removeAllFee();
482         _transferStandard(sender, recipient, amount);
483         if (!takeFee) restoreAllFee();
484     }
485 
486     function _transferStandard(
487         address sender,
488         address recipient,
489         uint256 tAmount
490     ) private {
491         (
492             uint256 rAmount,
493             uint256 rTransferAmount,
494             uint256 rFee,
495             uint256 tTransferAmount,
496             uint256 tFee,
497             uint256 tTeam
498         ) = _getValues(tAmount);
499         _rOwned[sender] = _rOwned[sender].sub(rAmount);
500         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
501         _takeTeam(tTeam);
502         _reflectFee(rFee, tFee);
503         emit Transfer(sender, recipient, tTransferAmount);
504     }
505 
506     function setDistribution(uint256 development, uint256 marketing, uint256 devFee) external onlyOwner {        
507         distribution.development = development;
508         distribution.marketing = marketing;
509         distribution.devFee = devFee;
510     }
511 
512     function _takeTeam(uint256 tTeam) private {
513         uint256 currentRate = _getRate();
514         uint256 rTeam = tTeam.mul(currentRate);
515         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
516     }
517 
518     function _reflectFee(uint256 rFee, uint256 tFee) private {
519         _rTotal = _rTotal.sub(rFee);
520         _tFeeTotal = _tFeeTotal.add(tFee);
521     }
522 
523     receive() external payable {
524     }
525 
526     function _getValues(uint256 tAmount)
527         private
528         view
529         returns (
530             uint256,
531             uint256,
532             uint256,
533             uint256,
534             uint256,
535             uint256
536         )
537     {
538         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
539             _getTValues(tAmount, _redisFee, _taxFee);
540         uint256 currentRate = _getRate();
541         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
542             _getRValues(tAmount, tFee, tTeam, currentRate);
543         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
544     }
545 
546     function _getTValues(
547         uint256 tAmount,
548         uint256 redisFee,
549         uint256 taxFee
550     )
551         private
552         pure
553         returns (
554             uint256,
555             uint256,
556             uint256
557         )
558     {
559         uint256 tFee = tAmount.mul(redisFee).div(100);
560         uint256 tTeam = tAmount.mul(taxFee).div(100);
561         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
562         return (tTransferAmount, tFee, tTeam);
563     }
564 
565     function _getRValues(
566         uint256 tAmount,
567         uint256 tFee,
568         uint256 tTeam,
569         uint256 currentRate
570     )
571         private
572         pure
573         returns (
574             uint256,
575             uint256,
576             uint256
577         )
578     {
579         uint256 rAmount = tAmount.mul(currentRate);
580         uint256 rFee = tFee.mul(currentRate);
581         uint256 rTeam = tTeam.mul(currentRate);
582         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
583         return (rAmount, rTransferAmount, rFee);
584     }
585 
586     function _getRate() private view returns (uint256) {
587         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
588         return rSupply.div(tSupply);
589     }
590 
591     function _getCurrentSupply() private view returns (uint256, uint256) {
592         uint256 rSupply = _rTotal;
593         uint256 tSupply = _tTotal;
594         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
595         return (rSupply, tSupply);
596     }
597 
598     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
599         _redisFeeOnBuy = redisFeeOnBuy;
600         _redisFeeOnSell = redisFeeOnSell;
601         _taxFeeOnBuy = taxFeeOnBuy;
602         _taxFeeOnSell = taxFeeOnSell;
603     }
604 
605     //Set minimum tokens required to swap.
606     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
607         _swapTokensAtAmount = swapTokensAtAmount;
608     }
609 
610     //Set minimum tokens required to swap.
611     function toggleSwap(bool _swapEnabled) public onlyOwner {
612         swapEnabled = _swapEnabled;
613     }
614 
615     //Set maximum transaction
616     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
617         _maxTxAmount = maxTxAmount;
618     }
619 
620     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
621         _maxWalletSize = maxWalletSize;
622     }
623 
624     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
625         for(uint256 i = 0; i < accounts.length; i++) {
626             _isExcludedFromFee[accounts[i]] = excluded;
627         }
628     }
629 
630     function allowPreTrading(address[] calldata accounts) public onlyOwner {
631         for(uint256 i = 0; i < accounts.length; i++) {
632                  preTrader[accounts[i]] = true;
633         }
634     }
635 
636     function removePreTrading(address[] calldata accounts) public onlyOwner {
637         for(uint256 i = 0; i < accounts.length; i++) {
638                  delete preTrader[accounts[i]];
639         }
640     }
641 }