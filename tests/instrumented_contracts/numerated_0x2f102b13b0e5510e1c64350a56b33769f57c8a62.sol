1 /*
2 
3 Common Cents (CMCNT)
4 
5 Website:
6 https://commoncentscoin.io
7 
8 Twitter:
9 https://twitter.com/CommonCentsio
10 
11 Telegram:
12 https://t.me/CommonCentsCoin
13 
14 */
15 
16 // SPDX-License-Identifier: MIT
17 pragma solidity ^0.8.4;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 }
24 
25 interface IERC20 {
26     function totalSupply() external view returns (uint256);
27 
28     function balanceOf(address account) external view returns (uint256);
29 
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     function allowance(address owner, address spender) external view returns (uint256);
33 
34     function approve(address spender, uint256 amount) external returns (bool);
35 
36     function transferFrom(
37         address sender,
38         address recipient,
39         uint256 amount
40     ) external returns (bool);
41 
42     event Transfer(address indexed from, address indexed to, uint256 value);
43     event Approval(
44         address indexed owner,
45         address indexed spender,
46         uint256 value
47     );
48 }
49 
50 contract Ownable is Context {
51     address private _owner;
52     address private _previousOwner;
53     event OwnershipTransferred(
54         address indexed previousOwner,
55         address indexed newOwner
56     );
57 
58     constructor() {
59         address msgSender = _msgSender();
60         _owner = msgSender;
61         emit OwnershipTransferred(address(0), msgSender);
62     }
63 
64     function owner() public view returns (address) {
65         return _owner;
66     }
67 
68     modifier onlyOwner() {
69         require(_owner == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     function renounceOwnership() public virtual onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77 
78     function transferOwnership(address newOwner) public virtual onlyOwner {
79         require(newOwner != address(0), "Ownable: new owner is the zero address");
80         emit OwnershipTransferred(_owner, newOwner);
81         _owner = newOwner;
82     }
83 }
84 
85 library SafeMath {
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a + b;
88         require(c >= a, "SafeMath: addition overflow");
89         return c;
90     }
91 
92     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93         return sub(a, b, "SafeMath: subtraction overflow");
94     }
95 
96     function sub(
97         uint256 a,
98         uint256 b,
99         string memory errorMessage
100     ) internal pure returns (uint256) {
101         require(b <= a, errorMessage);
102         uint256 c = a - b;
103         return c;
104     }
105 
106     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107         if (a == 0) {
108             return 0;
109         }
110         uint256 c = a * b;
111         require(c / a == b, "SafeMath: multiplication overflow");
112         return c;
113     }
114 
115     function div(uint256 a, uint256 b) internal pure returns (uint256) {
116         return div(a, b, "SafeMath: division by zero");
117     }
118 
119     function div(
120         uint256 a,
121         uint256 b,
122         string memory errorMessage
123     ) internal pure returns (uint256) {
124         require(b > 0, errorMessage);
125         uint256 c = a / b;
126         return c;
127     }
128 }
129 
130 interface IUniswapV2Factory {
131     function createPair(address tokenA, address tokenB)
132         external
133         returns (address pair);
134 }
135 
136 interface IUniswapV2Router02 {
137     function swapExactTokensForETHSupportingFeeOnTransferTokens(
138         uint256 amountIn,
139         uint256 amountOutMin,
140         address[] calldata path,
141         address to,
142         uint256 deadline
143     ) external;
144 
145     function swapExactETHForTokensSupportingFeeOnTransferTokens(
146         uint amountOutMin,
147         address[] calldata path,
148         address to,
149         uint deadline
150     ) external payable;
151 
152     function factory() external pure returns (address);
153 
154     function WETH() external pure returns (address);
155 
156     function addLiquidityETH(
157         address token,
158         uint256 amountTokenDesired,
159         uint256 amountTokenMin,
160         uint256 amountETHMin,
161         address to,
162         uint256 deadline
163     )
164         external
165         payable
166         returns (
167             uint256 amountToken,
168             uint256 amountETH,
169             uint256 liquidity
170         );
171 }
172 
173 contract CommonCents is Context, IERC20, Ownable {
174     
175     using SafeMath for uint256;
176 
177     string private constant _name = "Common Cents";
178     string private constant _symbol = "CMCNT";
179     uint8 private constant _decimals = 18;
180 
181     mapping(address => uint256) private _rOwned;
182     mapping(address => mapping(address => uint256)) private _allowances;
183     mapping(address => bool) private _isExcludedFromFee;
184     uint256 private constant MAX = ~uint256(0);
185     uint256 private constant _tTotal = 1000000000 * 10**18;
186     uint256 private _rTotal = (MAX - (MAX % _tTotal));
187     uint256 private _tFeeTotal;
188     
189     //Buy Fee
190     uint256 private _redisFeeOnBuy = 1;
191     uint256 private _taxFeeOnBuy = 800; //8%
192 
193     //Sell Fee
194     uint256 private _redisFeeOnSell = 1;
195     uint256 private _taxFeeOnSell = 800; //8%
196 
197     //Original Fee
198     uint256 private _redisFee = _redisFeeOnSell;
199     uint256 private _taxFee = _taxFeeOnSell.div(100);
200     
201     uint256 private _previousredisFee = _redisFee;
202     uint256 private _previoustaxFee = _taxFee;
203 
204     mapping(address => bool) public bots;
205     mapping(address => bool) public preTrader;
206 
207     mapping (uint256 => address) private taxWallets;
208     mapping (uint256 => uint256) private taxWalletAllocs;
209 
210     IUniswapV2Router02 public uniswapV2Router;
211     address public uniswapV2Pair;
212     
213     bool private tradingOpen;
214     bool private inSwap = false;
215     bool private swapEnabled = true;
216     
217     uint256 public _maxTxAmount = _tTotal.mul(20).div(10000); //0.20%
218     uint256 public _maxWalletSize = _tTotal.mul(50).div(10000); //0.50%
219     uint256 public _cSwapTokensAtAmount = _tTotal.mul(5).div(10000); //0.05%
220     uint256 public _cSwapTokensMaxAmount = _tTotal.mul(10).div(10000); //0.1%
221 
222     event MaxTxAmountUpdated(uint256 _maxTxAmount);
223     modifier lockTheSwap {
224         inSwap = true;
225         _;
226         inSwap = false;
227     }
228 
229     constructor() {
230         
231         _rOwned[_msgSender()] = _rTotal;
232         
233         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
234         uniswapV2Router = _uniswapV2Router;
235         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
236 
237         taxWallets[1] = 0x561ab7c63Cb9ebc2852c6c0C885A80E38298a050; //Marketing
238         taxWallets[2] = 0xa56aA6ee1449cee11503881Aa767F41BD0fA7c82; //Development
239         taxWallets[3] = 0x1705d2364f9c8b446aE3b453029221E2246258A9; //Political
240 
241         taxWalletAllocs[1] = 5;
242         taxWalletAllocs[2] = 2;
243         taxWalletAllocs[3] = 1;
244 
245         _isExcludedFromFee[owner()] = true;
246         _isExcludedFromFee[address(this)] = true;
247         _isExcludedFromFee[taxWallets[1]] = true;
248         _isExcludedFromFee[taxWallets[2]] = true;
249         _isExcludedFromFee[taxWallets[3]] = true;
250         
251         emit Transfer(address(0), _msgSender(), _tTotal);
252     }
253 
254     function name() public pure returns (string memory) {
255         return _name;
256     }
257 
258     function symbol() public pure returns (string memory) {
259         return _symbol;
260     }
261 
262     function decimals() public pure returns (uint8) {
263         return _decimals;
264     }
265 
266     function totalSupply() public pure override returns (uint256) {
267         return _tTotal;
268     }
269 
270     function balanceOf(address account) public view override returns (uint256) {
271         return tokenFromReflection(_rOwned[account]);
272     }
273 
274     function transfer(address recipient, uint256 amount)
275         public
276         override
277         returns (bool)
278     {
279         _transfer(_msgSender(), recipient, amount);
280         return true;
281     }
282 
283     function allowance(address owner, address spender)
284         public
285         view
286         override
287         returns (uint256)
288     {
289         return _allowances[owner][spender];
290     }
291 
292     function approve(address spender, uint256 amount)
293         public
294         override
295         returns (bool)
296     {
297         _approve(_msgSender(), spender, amount);
298         return true;
299     }
300 
301     function transferFrom(
302         address sender,
303         address recipient,
304         uint256 amount
305     ) public override returns (bool) {
306         _transfer(sender, recipient, amount);
307         _approve(
308             sender,
309             _msgSender(),
310             _allowances[sender][_msgSender()].sub(
311                 amount,
312                 "ERC20: transfer amount exceeds allowance"
313             )
314         );
315         return true;
316     }
317 
318     function tokenFromReflection(uint256 rAmount)
319         private
320         view
321         returns (uint256)
322     {
323         require(
324             rAmount <= _rTotal,
325             "Amount must be less than total reflections"
326         );
327         uint256 currentRate = _getRate();
328         return rAmount.div(currentRate);
329     }
330 
331     function removeAllFee() private {
332         if (_redisFee == 0 && _taxFee == 0) return;
333     
334         _previousredisFee = _redisFee;
335         _previoustaxFee = _taxFee;
336         
337         _redisFee = 0;
338         _taxFee = 0;
339     }
340 
341     function restoreAllFee() private {
342         _redisFee = _previousredisFee;
343         _taxFee = _previoustaxFee;
344     }
345 
346     function _approve(
347         address owner,
348         address spender,
349         uint256 amount
350     ) private {
351         require(owner != address(0), "ERC20: approve from the zero address");
352         require(spender != address(0), "ERC20: approve to the zero address");
353         _allowances[owner][spender] = amount;
354         emit Approval(owner, spender, amount);
355     }
356 
357     function _transfer(
358         address from,
359         address to,
360         uint256 amount
361     ) private {
362         require(from != address(0), "ERC20: transfer from the zero address");
363         require(to != address(0), "ERC20: transfer to the zero address");
364         require(amount > 0, "Transfer amount must be greater than zero");
365 
366         bool takeFee = false;
367         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
368             
369             takeFee = true;
370 
371             //Trade start check
372             if(!tradingOpen) {
373                 require(preTrader[from], "TOKEN: Trading not open yet");
374             }
375             
376             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
377             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
378             
379             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
380                 require(balanceOf(to) + amount <= _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
381             }
382 
383             //BUY
384             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
385 
386                 _redisFee = _redisFeeOnBuy;
387                 _taxFee = _taxFeeOnBuy.div(100);
388 
389             } else if(to == uniswapV2Pair && from != address(uniswapV2Router)) { //SELL
390             
391                 _redisFee = _redisFeeOnSell;
392                 _taxFee = _taxFeeOnSell.div(100);
393 
394                 //Check token balance for performing tax distributions
395                 uint256 contractTokenBalance = balanceOf(address(this));
396 
397                 if(contractTokenBalance >= _cSwapTokensMaxAmount) {
398                     contractTokenBalance = _cSwapTokensMaxAmount;
399                 }
400                 
401                 if (contractTokenBalance >= _cSwapTokensAtAmount && !inSwap && swapEnabled) {
402                     processDistributions(contractTokenBalance);
403                 }
404             }
405 
406             //No tax on transfers
407             if(from != uniswapV2Pair && to != uniswapV2Pair) {
408                 takeFee = false;
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
430     function processDistributions(uint256 tokens) private {
431         uint256 initialETHBalance = address(this).balance;
432         swapTokensForEth(tokens);
433         uint256 newETHBalance = address(this).balance.sub(initialETHBalance);
434 
435         //Send to taxWallet
436         uint256 totalAllocation = taxWalletAllocs[1] + taxWalletAllocs[2] + taxWalletAllocs[3];
437         payable(taxWallets[1]).transfer(newETHBalance*taxWalletAllocs[1]/totalAllocation);
438         payable(taxWallets[2]).transfer(newETHBalance*taxWalletAllocs[2]/totalAllocation);
439         payable(taxWallets[3]).transfer(newETHBalance*taxWalletAllocs[3]/totalAllocation);
440 
441     }
442 
443     function _tokenTransfer(
444         address sender,
445         address recipient,
446         uint256 amount,
447         bool takeFee
448     ) private {
449         if (!takeFee) removeAllFee();
450         _transferStandard(sender, recipient, amount);
451         if (!takeFee) restoreAllFee();
452     }
453 
454     function _transferStandard(
455         address sender,
456         address recipient,
457         uint256 tAmount
458     ) private {
459         (
460             uint256 rAmount,
461             uint256 rTransferAmount,
462             uint256 rFee,
463             uint256 tTransferAmount,
464             uint256 tFee,
465             uint256 tTeam
466         ) = _getValues(tAmount);
467         _rOwned[sender] = _rOwned[sender].sub(rAmount);
468         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
469         _takeTeam(tTeam);
470         _reflectFee(rFee, tFee);
471         emit Transfer(sender, recipient, tTransferAmount);
472     }
473 
474     function _takeTeam(uint256 tTeam) private {
475         uint256 currentRate = _getRate();
476         uint256 rTeam = tTeam.mul(currentRate);
477         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
478     }
479 
480     function _reflectFee(uint256 rFee, uint256 tFee) private {
481         _rTotal = _rTotal.sub(rFee);
482         _tFeeTotal = _tFeeTotal.add(tFee);
483     }
484 
485     receive() external payable {}
486 
487     function _getValues(uint256 tAmount)
488         private
489         view
490         returns (
491             uint256,
492             uint256,
493             uint256,
494             uint256,
495             uint256,
496             uint256
497         )
498     {
499         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
500             _getTValues(tAmount, _redisFee, _taxFee);
501         uint256 currentRate = _getRate();
502         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
503             _getRValues(tAmount, tFee, tTeam, currentRate);
504         
505         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
506     }
507 
508     function _getTValues(
509         uint256 tAmount,
510         uint256 redisFee,
511         uint256 taxFee
512     )
513         private
514         pure
515         returns (
516             uint256,
517             uint256,
518             uint256
519         )
520     {
521         uint256 tFee = tAmount.mul(redisFee).div(100);
522         uint256 tTeam = tAmount.mul(taxFee).div(100);
523         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
524 
525         return (tTransferAmount, tFee, tTeam);
526     }
527 
528     function _getRValues(
529         uint256 tAmount,
530         uint256 tFee,
531         uint256 tTeam,
532         uint256 currentRate
533     )
534         private
535         pure
536         returns (
537             uint256,
538             uint256,
539             uint256
540         )
541     {
542         uint256 rAmount = tAmount.mul(currentRate);
543         uint256 rFee = tFee.mul(currentRate);
544         uint256 rTeam = tTeam.mul(currentRate);
545         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
546 
547         return (rAmount, rTransferAmount, rFee);
548     }
549 
550     function _getRate() private view returns (uint256) {
551         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
552 
553         return rSupply.div(tSupply);
554     }
555 
556     function _getCurrentSupply() private view returns (uint256, uint256) {
557         uint256 rSupply = _rTotal;
558         uint256 tSupply = _tTotal;
559         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
560     
561         return (rSupply, tSupply);
562     }
563     
564     /**
565      * @dev Opens trading
566      */
567     function setTrading(bool _tradingOpen) external onlyOwner {
568         tradingOpen = _tradingOpen;
569     }
570 
571     /**
572      * @dev Triggers the tax handling functionality for manual use. Enter 0 to processDistribute on all contract balance
573      */
574     function manualDistributeTax(uint256 _tokens) external onlyOwner {
575         uint256 tokens = _tokens;
576         if(_tokens == 0) {
577             tokens = balanceOf(address(this));
578         }
579         processDistributions(tokens);
580     }
581 
582     /**
583      * @dev Block any potential bots or snipers from transferring tokens
584      */
585     function blockBots(address[] memory bots_) external onlyOwner {
586         for (uint256 i = 0; i < bots_.length; i++) {
587             bots[bots_[i]] = true;
588         }
589     }
590 
591     /**
592      * @dev Unblock bots
593      */
594     function unblockBot(address notbot) external onlyOwner {
595         bots[notbot] = false;
596     }
597 
598     /**
599      * @dev Set fee for the project
600      */
601     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) external onlyOwner {
602         
603         //Hard cap check to prevent honeypot
604         require(_redisFeeOnBuy + _taxFeeOnBuy <= 10, "Cannot set tax more than 10%");
605         require(_redisFeeOnSell + _taxFeeOnSell <= 10, "Cannot set tax more than 10%");
606         
607         _redisFeeOnBuy = redisFeeOnBuy;
608         _redisFeeOnSell = redisFeeOnSell;
609         
610         _taxFeeOnBuy = taxFeeOnBuy;
611         _taxFeeOnSell = taxFeeOnSell;
612     
613     }
614     
615     /**
616      * @dev Bypass any fee or limits
617      */
618     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
619         for(uint256 i = 0; i < accounts.length; i++) {
620             _isExcludedFromFee[accounts[i]] = excluded;
621         }
622     }
623 
624     /**
625      * @dev Set minimum tokens required for contract to swap for Smooth tax Distribution
626      */
627     function setContractMinTokensToSwap(uint256 tokens) external onlyOwner {
628         _cSwapTokensAtAmount = tokens;
629     }
630 
631     /**
632      * @dev Set maximum tokens contract can swap at once for Smooth tax Distribution
633      */
634     function setContractSwapMaxTokens(uint256 tokens) external onlyOwner {
635         _cSwapTokensMaxAmount = tokens;
636     }
637 
638     /**
639      * @dev Set tax wallets
640      */
641     function setTaxWallets(uint256 taxWalletID, address addr, uint256 percent) external onlyOwner {
642         taxWallets[taxWalletID] = addr;
643         taxWalletAllocs[taxWalletID] = percent;
644     }
645     
646     /**
647      * @dev Set whether contract should distribute tax automatically
648      */    
649     function toggleSwap(bool _swapEnabled) external onlyOwner {
650         swapEnabled = _swapEnabled;
651     }
652     
653     /**
654      * @dev Set maximum amount of tokens an address can buy at once
655      */   
656     function setMaxTxnAmount(uint256 maxTxAmount) external onlyOwner {
657         require(maxTxAmount >= _tTotal.mul(1).div(10000), "Cannot set less than 0.01% of supply");
658         _maxTxAmount = maxTxAmount;
659     }
660        
661     /**
662      * @dev Set how much each wallet can hold
663      */   
664     function setMaxWalletSize(uint256 maxWalletSize) external onlyOwner {
665         require(maxWalletSize >= _tTotal.mul(1).div(10000), "Cannot set less than 0.01% of supply");
666         _maxWalletSize = maxWalletSize;
667     }
668  
669     /**
670     * @dev Allow wallets to operate when trade open
671     */   
672     function allowPreTrading(address account, bool allowed) external onlyOwner {
673         require(preTrader[account] != allowed, "TOKEN: Already enabled.");
674         preTrader[account] = allowed;
675     }
676 
677     /**
678      * @dev Airdrop to multiple wallets
679      */   
680     function multiSend(address[] calldata addresses, uint256[] calldata amounts) external onlyOwner {
681         require(addresses.length == amounts.length, "Must be the same length");
682         for(uint256 i = 0; i < addresses.length; i++) {
683             _transfer(_msgSender(), addresses[i], amounts[i] * 10**18);
684         }
685     }
686 
687     /**
688      * @dev Claim any stuck eth/tokens from contract
689      */   
690     function claimStuckTokens(address _token) external onlyOwner {
691         if(_token == address(0x0)) {
692             payable(owner()).transfer(address(this).balance);
693             return;
694         }
695         IERC20 erc20token = IERC20(_token);
696         uint256 balance = erc20token.balanceOf(address(this));
697         erc20token.transfer(owner(), balance);
698     }
699     
700 }