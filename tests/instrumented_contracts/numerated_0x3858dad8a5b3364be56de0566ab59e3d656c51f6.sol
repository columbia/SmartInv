1 pragma solidity ^0.8.17;
2 pragma experimental ABIEncoderV2;
3 
4 // SPDX-License-Identifier:MIT
5 
6 interface IERC20 {
7     function totalSupply() external view returns (uint256);
8 
9     function balanceOf(address account) external view returns (uint256);
10 
11     function transfer(address recipient, uint256 amount)
12         external
13         returns (bool);
14 
15     function allowance(address owner, address spender)
16         external
17         view
18         returns (uint256);
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
29 
30     event Approval(
31         address indexed owner,
32         address indexed spender,
33         uint256 value
34     );
35 }
36 
37 abstract contract Context {
38     function _msgSender() internal view virtual returns (address payable) {
39         return payable(msg.sender);
40     }
41 }
42 
43 contract Ownable is Context {
44     address payable private _owner;
45     address payable private _previousOwner;
46     uint256 private _lockTime;
47 
48     event OwnershipTransferred(
49         address indexed previousOwner,
50         address indexed newOwner
51     );
52 
53     constructor() {
54         _owner = payable(0xE8ad74b7d646F733c3d7E293D75a18Cd8499Da65);
55         emit OwnershipTransferred(address(0), _owner);
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
69         _owner = payable(address(0));
70     }
71 
72     function transferOwnership(address payable newOwner)
73         public
74         virtual
75         onlyOwner
76     {
77         require(
78             newOwner != address(0),
79             "Ownable: new owner is the zero address"
80         );
81         emit OwnershipTransferred(_owner, newOwner);
82         _owner = newOwner;
83     }
84 }
85 
86 interface IDEXFactory {
87     function createPair(address tokenA, address tokenB)
88         external
89         returns (address pair);
90 }
91 
92 interface IDEXRouter01 {
93     function factory() external pure returns (address);
94 
95     function WETH() external pure returns (address);
96 
97     function addLiquidityETH(
98         address token,
99         uint256 amountTokenDesired,
100         uint256 amountTokenMin,
101         uint256 amountETHMin,
102         address to,
103         uint256 deadline
104     )
105         external
106         payable
107         returns (
108             uint256 amountToken,
109             uint256 amountETH,
110             uint256 liquidity
111         );
112 
113     function swapExactTokensForTokens(
114         uint256 amountIn,
115         uint256 amountOutMin,
116         address[] calldata path,
117         address to,
118         uint256 deadline
119     ) external returns (uint256[] memory amounts);
120 
121     function swapExactETHForTokens(
122         uint256 amountOutMin,
123         address[] calldata path,
124         address to,
125         uint256 deadline
126     ) external payable returns (uint256[] memory amounts);
127 
128     function swapExactTokensForETH(
129         uint256 amountIn,
130         uint256 amountOutMin,
131         address[] calldata path,
132         address to,
133         uint256 deadline
134     ) external returns (uint256[] memory amounts);
135 }
136 
137 interface IDEXRouter02 is IDEXRouter01 {
138     function swapExactETHForTokensSupportingFeeOnTransferTokens(
139         uint256 amountOutMin,
140         address[] calldata path,
141         address to,
142         uint256 deadline
143     ) external payable;
144 
145     function swapExactTokensForETHSupportingFeeOnTransferTokens(
146         uint256 amountIn,
147         uint256 amountOutMin,
148         address[] calldata path,
149         address to,
150         uint256 deadline
151     ) external;
152 }
153 
154 // change contract name with token name
155 contract NML is Context, IERC20, Ownable {
156     mapping(address => uint256) private _rOwned;
157     mapping(address => uint256) private _tOwned;
158     mapping(address => mapping(address => uint256)) private _allowances;
159     mapping(address => bool) private _isBlacklisted;
160     mapping(address => bool) private _antiBot;
161 
162     mapping(address => bool) private _isExcludedFromFee;
163     mapping(address => bool) private _isExcludeFromMaxWallet;
164     mapping(address => bool) private _isExcluded;
165 
166     address[] private _excluded;
167 
168     uint256 private constant MAX = ~uint256(0);
169     uint256 private _tTotal = 1_000_000_000_000 ether; // 1 trillion total supply
170     uint256 private _rTotal = (MAX - (MAX % _tTotal));
171     uint256 private _tFeeTotal;
172 
173     // change this when changing token name
174     string private _name = "NML"; // token name
175     string private _symbol = "NML"; // token ticker
176     uint8 private _decimals = 18; // token decimals
177 
178     IDEXRouter02 public DEXRouter;
179     address public DEXPair;
180     address payable public wheelWallet;
181     address payable public creatorWallet;
182     address payable public marketingWallet;
183     address payable public developmentWallet;
184     address public burnAddress = 0x000000000000000000000000000000000000dEaD;
185 
186     uint256 minTokenNumberToSell = 10000 ether; // 10000 max tx amount will trigger swap and add liquidity
187     uint256 public maxFee = 150; // 15% max fees limit per transaction
188     uint256 public maxWhaleFee = 490; // 49% max fees limit per transaction for whales
189     uint256 public maxTxAmountBuy = (_tTotal * 1) / 100; // 1% max transaction amount for buy
190     uint256 public maxTxAmountSell = (_tTotal * 1) / 100; // 1% max transaction amount for sell
191 
192     uint256 public burned = 0;
193     uint256 public maxBurn = 0;
194     uint256 public maxWallet;
195 
196     bool public swapAndLiquifyEnabled = false; // should be true to turn on to liquidate the pool
197     bool public reflectionFeesdiabled = false; // should be false to charge fee
198     bool inSwapAndLiquify = false;
199 
200     // buy tax fee
201     uint256 public reflectionFeeOnBuying = 50; // 5% will be distributed among holder as token divideneds
202     uint256 public liquidityFeeOnBuying = 50; // 5% will be added to the liquidity pool
203     uint256 public wheelWalletFeeOnBuying = 30; // 3% will go to the wheelWallet address
204     uint256 public creatorwalletFeeOnBuying = 10; // 1% will go to the creatorWallet address
205     uint256 public autoburnFeeOnBuying = 10; // 10% will go to the earth burn wallet address
206 
207     // sell tax fee
208     uint256 public reflectionFeeOnSelling = 50; // 5% will be distributed among holder as token divideneds
209     uint256 public liquidityFeeOnSelling = 50; // 5% will be added to the liquidity pool
210     uint256 public wheelWalletFeeOnSelling = 30; // 3% will go to the market address\
211     uint256 public creatorwalletFeeOnSelling = 10; // 1% will go to the creatorWallet address
212     uint256 public autoburnFeeOnSelling = 10; // 1% will go to the earth autoburn wallet address
213 
214     // whale tax fee
215     uint256 public reflectionFeeOnWhale = 50; // 5% will be distributed among holder as token divideneds
216     uint256 public liquidityFeeOnWhale = 150; // 15% will be added to the liquidity pool
217     uint256 public wheelWalletFeeOnWhale = 200; // 20% will go to the wheelWallet address
218     uint256 public creatorwalletFeeOnWhale = 10; // 1% will go to the creatorWallet address
219     uint256 public autoburnFeeOnWhale = 10; // 1% will go to the earth autoburn wallet address
220 
221     // normal tax fee
222     uint256 public reflectionFee = 0; // 0% will be distributed among holder as token divideneds
223     uint256 public liquidityFee = 0; // 0% will be added to the liquidity pool
224     uint256 public wheelWalletFee = 0; // 0% will go to the market address
225     uint256 public creatorwalletFee = 0; // 0% will go to the creatorWallet address
226     uint256 public autoburnFee = 0; // 0% will go to the earth autoburn wallet address
227 
228     // for smart contract use
229     uint256 private _currentreflectionFee;
230     uint256 private _currentLiquidityFee;
231     uint256 private _currentwheelWalletFee;
232     uint256 private _currentcreatorwalletFee;
233     uint256 private _currentautoburnFee;
234 
235     event SwapAndLiquifyEnabledUpdated(bool enabled);
236     event SwapAndLiquify(
237         uint256 tokensSwapped,
238         uint256 ethReceived,
239         uint256 tokensIntoLiqudity
240     );
241 
242     modifier lockTheSwap() {
243         inSwapAndLiquify = true;
244         _;
245         inSwapAndLiquify = false;
246     }
247 
248     constructor() {
249         maxBurn = (730 days) * (1 ether);
250         _rOwned[owner()] = _rTotal;
251         maxWallet = _tTotal / 100;
252 
253 
254         wheelWallet = payable(0xE0611f566d3a2658633C2475d5c5Bd8D0d1d74E7);
255         creatorWallet = payable(0x4C2bdCC7c534B72cd9E461523f89a0CEe29A425e);
256         marketingWallet = payable(0x0d92B793b5f006eb972888b67f9d71752CE3997d);
257         developmentWallet = payable(0xe453a97dE724E80890F454DfbC3e327Cc4740B1f);
258 
259 
260         IDEXRouter02 _DEXRouter = IDEXRouter02(
261             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D  // no change required
262         ); //testnet and mainnet
263         // Create a DEX pair for this new token
264         DEXPair = IDEXFactory(_DEXRouter.factory()).createPair(
265             address(this),
266             _DEXRouter.WETH()
267         );
268 
269         // set the rest of the contract variables
270         DEXRouter = _DEXRouter;
271 
272         _isExcludeFromMaxWallet[owner()] = true;
273         _isExcludeFromMaxWallet[address(this)] = true;
274         _isExcludeFromMaxWallet[wheelWallet] = true;
275         _isExcludeFromMaxWallet[creatorWallet] = true;
276         _isExcludeFromMaxWallet[address(DEXRouter)] = true;
277         _isExcludeFromMaxWallet[address(DEXPair)] = true;
278         _isExcludeFromMaxWallet[address(0)] = true;
279         _isExcludeFromMaxWallet[address(0xdead)] = true;
280         _isExcludeFromMaxWallet[address(marketingWallet)] = true;
281         _isExcludeFromMaxWallet[address(developmentWallet)] = true;
282 
283 
284 
285         //exclude owner and this contract from fee
286         _isExcludedFromFee[owner()] = true;
287         _isExcludedFromFee[address(this)] = true;
288 
289         emit Transfer(address(0), owner(), _tTotal);
290     }
291 
292     function name() external view returns (string memory) {
293         return _name;
294     }
295 
296     function symbol() external view returns (string memory) {
297         return _symbol;
298     }
299 
300     function decimals() external view returns (uint8) {
301         return _decimals;
302     }
303 
304     function totalSupply() external view override returns (uint256) {
305         return _tTotal;
306     }
307 
308     function balanceOf(address account) public view override returns (uint256) {
309         if (_isExcluded[account]) return _tOwned[account];
310         return tokenFromReflection(_rOwned[account]);
311     }
312 
313     function transfer(address recipient, uint256 amount)
314         public
315         override
316         returns (bool)
317     {
318         _transfer(_msgSender(), recipient, amount);
319         return true;
320     }
321 
322     function allowance(address owner, address spender)
323         public
324         view
325         override
326         returns (uint256)
327     {
328         return _allowances[owner][spender];
329     }
330 
331     function approve(address spender, uint256 amount)
332         public
333         override
334         returns (bool)
335     {
336         _approve(_msgSender(), spender, amount);
337         return true;
338     }
339 
340     function transferFrom(
341         address sender,
342         address recipient,
343         uint256 amount
344     ) public override returns (bool) {
345         _transfer(sender, recipient, amount);
346         _approve(
347             sender,
348             _msgSender(),
349             _allowances[sender][_msgSender()] - (amount)
350         );
351         return true;
352     }
353 
354     function increaseAllowance(address spender, uint256 addedValue)
355         public
356         virtual
357         returns (bool)
358     {
359         _approve(
360             _msgSender(),
361             spender,
362             _allowances[_msgSender()][spender] + (addedValue)
363         );
364         return true;
365     }
366 
367     function decreaseAllowance(address spender, uint256 subtractedValue)
368         public
369         virtual
370         returns (bool)
371     {
372         _approve(
373             _msgSender(),
374             spender,
375             _allowances[_msgSender()][spender] - (subtractedValue)
376         );
377         return true;
378     }
379 
380     function isExcludedFromReward(address account) public view returns (bool) {
381         return _isExcluded[account];
382     }
383 
384     function totalFees() public view returns (uint256) {
385         return _tFeeTotal;
386     }
387 
388     function deliver(uint256 tAmount) public {
389         address sender = _msgSender();
390         require(
391             !_isExcluded[sender],
392             "Excluded addresses cannot call this function"
393         );
394         uint256 rAmount = tAmount * (_getRate());
395         _rOwned[sender] = _rOwned[sender] - (rAmount);
396         _rTotal = _rTotal - (rAmount);
397         _tFeeTotal = _tFeeTotal + (tAmount);
398     }
399 
400     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
401         public
402         view
403         returns (uint256)
404     {
405         require(tAmount <= _tTotal, "Amount must be less than supply");
406         if (!deductTransferFee) {
407             uint256 rAmount = tAmount * (_getRate());
408             return rAmount;
409         } else {
410             uint256 rAmount = tAmount * (_getRate());
411             uint256 rTransferAmount = rAmount -
412                 (totalFeePerTx(tAmount) * (_getRate()));
413             return rTransferAmount;
414         }
415     }
416 
417     function tokenFromReflection(uint256 rAmount)
418         public
419         view
420         returns (uint256)
421     {
422         require(
423             rAmount <= _rTotal,
424             "Amount must be less than total reflections"
425         );
426         uint256 currentRate = _getRate();
427         return rAmount / (currentRate);
428     }
429 
430     function excludeFromReward(address account) external onlyOwner {
431         require(!_isExcluded[account], "Account is already excluded");
432         if (_rOwned[account] > 0) {
433             _tOwned[account] = tokenFromReflection(_rOwned[account]);
434         }
435         _isExcluded[account] = true;
436         _excluded.push(account);
437     }
438 
439     function includeInReward(address account) external onlyOwner {
440         require(_isExcluded[account], "Account is already excluded");
441         for (uint256 i = 0; i < _excluded.length; i++) {
442             if (_excluded[i] == account) {
443                 _excluded[i] = _excluded[_excluded.length - 1];
444                 _rOwned[account] = _tOwned[account] * (_getRate());
445                 _tOwned[account] = 0;
446                 _isExcluded[account] = false;
447                 _excluded.pop();
448                 break;
449             }
450         }
451     }
452 
453     function excludeFromFee(address account) external onlyOwner {
454         _isExcludedFromFee[account] = true;
455     }
456 
457     function setCreatorWallet(address newadd) external onlyOwner {
458         require(newadd != address(0), "cannot be 0");
459         creatorWallet = payable(newadd);
460     }
461     
462     function setWheelWallet(address newadd) external onlyOwner {
463         require(newadd != address(0), "cannot be 0");
464         wheelWallet = payable(newadd);
465     }
466 
467 
468     function blacklist(address[] memory accounts) external onlyOwner {
469         for (uint256 i = 0; i < accounts.length; i++) {
470             _isBlacklisted[accounts[i]] = true;
471         }
472     }
473 
474     function addBot(address[] memory accounts) external onlyOwner {
475         for (uint256 i = 0; i < accounts.length; i++) {
476             _antiBot[accounts[i]] = true;
477         }
478     }
479 
480     function removeBot(address[] memory accounts) external onlyOwner {
481         for (uint256 i = 0; i < accounts.length; i++) {
482             _antiBot[accounts[i]] = false;
483         }
484     }
485 
486     function removeBlacklist(address[] memory accounts) external onlyOwner {
487         for (uint256 i = 0; i < accounts.length; i++) {
488             _isBlacklisted[accounts[i]] = false;
489         }
490     }
491 
492     function includeInFee(address account) external onlyOwner {
493         _isExcludedFromFee[account] = false;
494     }
495 
496     function setMinTokenNumberToSell(uint256 _amount) external onlyOwner {
497         minTokenNumberToSell = _amount;
498     }
499 
500     function setmaxTxAmountBuy(uint256 _amount) external onlyOwner {
501         maxTxAmountBuy = _amount;
502     }
503 
504     function setmaxTxAmountSell(uint256 _amount) external onlyOwner {
505         maxTxAmountSell = _amount;
506     }
507 
508     function setSwapAndLiquifyEnabled(bool _state) external onlyOwner {
509         swapAndLiquifyEnabled = _state;
510         emit SwapAndLiquifyEnabledUpdated(_state);
511     }
512 
513     function setReflectionFees(bool _state) external onlyOwner {
514         reflectionFeesdiabled = _state;
515     }
516 
517     function setwheelWallet(address payable _wheelWallet) external onlyOwner {
518         require(
519             _wheelWallet != address(0),
520             "Market wallet cannot be address zero"
521         );
522         wheelWallet = _wheelWallet;
523     }
524 
525     function ExcludeMAXWallet(address payable _newWallet) external onlyOwner {
526         _isExcludeFromMaxWallet[_newWallet] = true;
527     }
528 
529     function includeMAXWallet(address payable _newWallet) external onlyOwner {
530         _isExcludeFromMaxWallet[_newWallet] = false;
531     }
532 
533     function setRoute(IDEXRouter02 _router, address _pair) external onlyOwner {
534         require(
535             address(_router) != address(0),
536             "Router adress cannot be address zero"
537         );
538         require(_pair != address(0), "Pair adress cannot be address zero");
539         DEXRouter = _router;
540         DEXPair = _pair;
541     }
542 
543     function withdrawETH(uint256 _amount) external onlyOwner {
544         require(address(this).balance >= _amount, "Invalid Amount");
545         payable(msg.sender).transfer(_amount);
546     }
547 
548     function withdrawToken(IERC20 _token, uint256 _amount) external onlyOwner {
549         require(_token.balanceOf(address(this)) >= _amount, "Invalid Amount");
550         _token.transfer(msg.sender, _amount);
551     }
552 
553     //to receive ETH from DEXRouter when swapping
554     receive() external payable {}
555 
556     function totalFeePerTx(uint256 tAmount) internal view returns (uint256) {
557         uint256 percentage = (tAmount *
558             (_currentreflectionFee +
559                 (_currentLiquidityFee) +
560                 (_currentwheelWalletFee) +
561                 (_currentcreatorwalletFee) +
562                 (_currentautoburnFee))) / (1e3);
563 
564         return percentage;
565     }
566 
567     function _reflectFee(uint256 tAmount) private {
568         uint256 tFee = (tAmount * (_currentreflectionFee)) / (1e3);
569         uint256 rFee = tFee * (_getRate());
570         _rTotal = _rTotal - (rFee);
571         _tFeeTotal = _tFeeTotal + (tFee);
572     }
573 
574     function _getRate() private view returns (uint256) {
575         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
576         return rSupply / (tSupply);
577     }
578 
579     function _getCurrentSupply() private view returns (uint256, uint256) {
580         uint256 rSupply = _rTotal;
581         uint256 tSupply = _tTotal;
582         for (uint256 i = 0; i < _excluded.length; i++) {
583             if (
584                 _rOwned[_excluded[i]] > rSupply ||
585                 _tOwned[_excluded[i]] > tSupply
586             ) return (_rTotal, _tTotal);
587             rSupply = rSupply - (_rOwned[_excluded[i]]);
588             tSupply = tSupply - (_tOwned[_excluded[i]]);
589         }
590         if (rSupply < _rTotal / (_tTotal)) return (_rTotal, _tTotal);
591         return (rSupply, tSupply);
592     }
593 
594     function _takeLiquidityPoolFee(uint256 tAmount, uint256 currentRate)
595         internal
596     {
597         uint256 tPoolFee = (tAmount * (_currentLiquidityFee)) / (1e3);
598         uint256 rPoolFee = tPoolFee * (currentRate);
599         _rOwned[address(this)] = _rOwned[address(this)] + (rPoolFee);
600         if (_isExcluded[address(this)])
601             _tOwned[address(this)] = _tOwned[address(this)] + (tPoolFee);
602         emit Transfer(_msgSender(), address(this), tPoolFee);
603     }
604 
605     function _takeWheelFee(uint256 tAmount, uint256 currentRate) internal {
606         uint256 tWheelFee = (tAmount * (_currentwheelWalletFee)) / (1e3);
607         uint256 rWheelFee = tWheelFee * (currentRate);
608         _rOwned[wheelWallet] = _rOwned[wheelWallet] + (rWheelFee);
609         if (_isExcluded[wheelWallet])
610             _tOwned[wheelWallet] = _tOwned[wheelWallet] + (tWheelFee);
611         emit Transfer(_msgSender(), wheelWallet, tWheelFee);
612     }
613 
614     function _takecreatorFee(uint256 tAmount, uint256 currentRate) internal {
615         uint256 tcreatorFee = (tAmount * (_currentcreatorwalletFee)) / (1e3);
616         uint256 rcreatorFee = tcreatorFee * (currentRate);
617         _rOwned[creatorWallet] = _rOwned[creatorWallet] + (rcreatorFee);
618         if (_isExcluded[creatorWallet])
619             _tOwned[creatorWallet] = _tOwned[creatorWallet] + (tcreatorFee);
620         emit Transfer(_msgSender(), creatorWallet, tcreatorFee);
621     }
622 
623     function _takeBurnFee(uint256 tAmount, uint256 currentRate) internal {
624         uint256 burnFee = (tAmount * (_currentautoburnFee)) / (1e3);
625         uint256 rBurnFee = burnFee * (currentRate);
626         _rOwned[burnAddress] = _rOwned[burnAddress] + (rBurnFee);
627         if (_isExcluded[burnAddress]) {
628             _tOwned[burnAddress] = _tOwned[burnAddress] + (burnFee);
629         }
630         burned = burned + burnFee;
631         emit Transfer(_msgSender(), burnAddress, burnFee);
632     }
633 
634     function Burn(uint256 tAmount) external onlyOwner {
635         uint256 currentRate = _getRate();
636         uint256 burnAmount = (tAmount);
637         uint256 rBurnAmount = burnAmount * (currentRate);
638         _rOwned[msg.sender] = _rOwned[msg.sender] - rBurnAmount;
639         if (_isExcluded[msg.sender]) {
640             _tOwned[msg.sender] = _tOwned[msg.sender] - (burnAmount);
641         }
642         _rOwned[burnAddress] = _rOwned[burnAddress] + (rBurnAmount);
643         if (_isExcluded[burnAddress]) {
644             _tOwned[burnAddress] = _tOwned[burnAddress] + (burnAmount);
645         }
646         burned = burned + tAmount;
647         emit Transfer(_msgSender(), burnAddress, burnAmount);
648     }
649 
650     function removeAllFee() private {
651         _currentreflectionFee = 0;
652         _currentLiquidityFee = 0;
653         _currentwheelWalletFee = 0;
654         _currentcreatorwalletFee = 0;
655         _currentautoburnFee = 0;
656     }
657 
658     function setBuyFee() private {
659         _currentreflectionFee = reflectionFeeOnBuying;
660         _currentLiquidityFee = liquidityFeeOnBuying;
661         _currentwheelWalletFee = wheelWalletFeeOnBuying;
662         _currentcreatorwalletFee = creatorwalletFeeOnBuying;
663         _currentautoburnFee = autoburnFeeOnBuying;
664     }
665 
666     function setSellFee() private {
667         _currentreflectionFee = reflectionFeeOnSelling;
668         _currentLiquidityFee = liquidityFeeOnSelling;
669         _currentwheelWalletFee = wheelWalletFeeOnSelling;
670         _currentcreatorwalletFee = creatorwalletFeeOnSelling;
671         _currentautoburnFee = autoburnFeeOnSelling;
672     }
673 
674     function setWhaleFee() private {
675         _currentreflectionFee = reflectionFeeOnWhale;
676         _currentLiquidityFee = liquidityFeeOnWhale;
677         _currentwheelWalletFee = wheelWalletFeeOnWhale;
678         _currentcreatorwalletFee = creatorwalletFeeOnWhale;
679         _currentautoburnFee = autoburnFeeOnWhale;
680     }
681 
682     function setNormalFee() private {
683         _currentreflectionFee = reflectionFee;
684         _currentLiquidityFee = liquidityFee;
685         _currentwheelWalletFee = wheelWalletFee;
686         _currentcreatorwalletFee = creatorwalletFee;
687         _currentautoburnFee = autoburnFee;
688     }
689 
690     //only owner can change BuyFeePercentages any time after deployment
691     function setBuyFeePercent(
692         uint256 _reflectionFee,
693         uint256 _liquidityFee,
694         uint256 _wheelWalletFee,
695         uint256 _creatorwalletFee,
696         uint256 _autoburnFee
697     ) external onlyOwner {
698         reflectionFeeOnBuying = _reflectionFee;
699         liquidityFeeOnBuying = _liquidityFee;
700         wheelWalletFeeOnBuying = _wheelWalletFee;
701         creatorwalletFeeOnBuying = _creatorwalletFee;
702         autoburnFeeOnBuying = _autoburnFee;
703         require(
704             reflectionFeeOnBuying +
705                 (liquidityFeeOnBuying) +
706                 (wheelWalletFeeOnBuying) +
707                 (creatorwalletFeeOnBuying) +
708                 (autoburnFeeOnBuying) <=
709                 maxFee,
710             "ERC20: Can not be greater than max fee"
711         );
712     }
713 
714     //only owner can change SellFeePercentages any time after deployment
715     function setSellFeePercent(
716         uint256 _reflectionFee,
717         uint256 _liquidityFee,
718         uint256 _wheelWalletFee,
719         uint256 _creatorwalletFee,
720         uint256 _autoburnFee
721     ) external onlyOwner {
722         reflectionFeeOnSelling = _reflectionFee;
723         liquidityFeeOnSelling = _liquidityFee;
724         wheelWalletFeeOnSelling = _wheelWalletFee;
725         creatorwalletFeeOnSelling = _creatorwalletFee;
726         autoburnFeeOnSelling = _autoburnFee;
727         require(
728             reflectionFeeOnSelling +
729                 (liquidityFeeOnSelling) +
730                 (creatorwalletFeeOnSelling) +
731                 (wheelWalletFeeOnSelling) +
732                 (autoburnFeeOnSelling) <=
733                 maxFee,
734             "ERC20: Can not be greater than max fee"
735         );
736     }
737 
738     function setWhaleFeePercent(
739         uint256 _reflectionFee,
740         uint256 _liquidityFee,
741         uint256 _wheelWalletFee,
742         uint256 _creatorwalletFee,
743         uint256 _autoburnFee
744     ) external onlyOwner {
745         reflectionFeeOnWhale = _reflectionFee;
746         liquidityFeeOnWhale = _liquidityFee;
747         wheelWalletFeeOnWhale = _wheelWalletFee;
748         creatorwalletFeeOnWhale = _creatorwalletFee;
749         autoburnFeeOnWhale = _autoburnFee;
750         require(
751             reflectionFeeOnWhale +
752                 (liquidityFeeOnWhale) +
753                 (creatorwalletFeeOnWhale) +
754                 (wheelWalletFeeOnWhale) +
755                 (autoburnFeeOnWhale) <=
756                 maxWhaleFee,
757             "ERC20: Can not be greater than max fee"
758         );
759     }
760 
761     //only owner can change NormalFeePercent any time after deployment
762     function setNormalFeePercent(
763         uint256 _reflectionFee,
764         uint256 _liquidityFee,
765         uint256 _wheelWalletFee,
766         uint256 _creatorwalletFee,
767         uint256 _autoburnFee
768     ) external onlyOwner {
769         reflectionFee = _reflectionFee;
770         liquidityFee = _liquidityFee;
771         wheelWalletFee = _wheelWalletFee;
772         creatorwalletFee = _creatorwalletFee;
773         autoburnFee = _autoburnFee;
774         require(
775             reflectionFee +
776                 (liquidityFee) +
777                 (wheelWalletFee) +
778                 (creatorwalletFee) +
779                 (autoburnFee) <=
780                 maxFee,
781             "ERC20: Can not be greater than max fee"
782         );
783     }
784 
785     function setMaxBurn(uint256 Amount) external onlyOwner {
786         maxBurn = Amount;
787     }
788 
789     function isExcludedFromFee(address account) public view returns (bool) {
790         return _isExcludedFromFee[account];
791     }
792 
793     function isBlacklisted(address account) public view returns (bool) {
794         return _isBlacklisted[account];
795     }
796 
797     function _approve(
798         address owner,
799         address spender,
800         uint256 amount
801     ) private {
802         require(owner != address(0), "ERC20: approve from the zero address");
803         require(spender != address(0), "ERC20: approve to the zero address");
804 
805         _allowances[owner][spender] = amount;
806         emit Approval(owner, spender, amount);
807     }
808 
809     function _transfer(
810         address from,
811         address to,
812         uint256 amount
813     ) private {
814         require(from != address(0), "ERC20: transfer from the zero address");
815         require(to != address(0), "ERC20: transfer to the zero address");
816         require(amount > 0, "ERC20: Transfer amount must be greater than zero");
817         require(!_isBlacklisted[from], "ERC20: Sender is blacklisted");
818         require(!_isBlacklisted[to], "ERC20: Recipient is blacklisted");
819 
820         // swap and liquify
821         swapAndLiquify(from, to);
822 
823         //indicates if fee should be deducted from transfer
824         bool takeFee = true;
825 
826         //if any account belongs to _isExcludedFromFee account then remove the fee
827         if (
828             _isExcludedFromFee[from] ||
829             _isExcludedFromFee[to] ||
830             reflectionFeesdiabled
831         ) {
832             takeFee = false;
833         }
834         if (!takeFee) {
835             removeAllFee();
836         }
837         // buying handler
838         else if (from == DEXPair) {
839             if (amount > maxTxAmountBuy) {
840                 setWhaleFee();
841             } else {
842                 setBuyFee();
843             }
844         }
845         // selling handler
846         else if (to == DEXPair) {
847             //anti Dump
848             if (_antiBot[from]) {
849                 setWhaleFee();
850             } else {
851                 if (amount > maxTxAmountSell) {
852                     setWhaleFee();
853                 } else {
854                     setSellFee();
855                 }
856             }
857         }
858         // normal transaction handler
859         else {
860             setNormalFee();
861         }
862 
863         if (burned >= maxBurn) {
864             _currentautoburnFee = 0;
865         }
866         //transfer amount, it will take tax
867         if (!_isExcludeFromMaxWallet[to]) {
868             require(
869                 balanceOf(to) + amount <= maxWallet,
870                 "Max Wallet limit reached"
871             );
872         }
873         _tokenTransfer(from, to, amount);
874     }
875 
876     //this method is responsible for taking all fee, if takeFee is true
877     function _tokenTransfer(
878         address sender,
879         address recipient,
880         uint256 amount
881     ) private {
882         if (_isExcluded[sender] && !_isExcluded[recipient]) {
883             _transferFromExcluded(sender, recipient, amount);
884         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
885             _transferToExcluded(sender, recipient, amount);
886         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
887             _transferBothExcluded(sender, recipient, amount);
888         } else {
889             _transferStandard(sender, recipient, amount);
890         }
891     }
892 
893     function _transferStandard(
894         address sender,
895         address recipient,
896         uint256 tAmount
897     ) private {
898         uint256 currentRate = _getRate();
899         uint256 tTransferAmount = tAmount - (totalFeePerTx(tAmount));
900         uint256 rAmount = tAmount * (currentRate);
901         uint256 rTransferAmount = rAmount -
902             (totalFeePerTx(tAmount) * (currentRate));
903         _rOwned[sender] = _rOwned[sender] - (rAmount);
904         _rOwned[recipient] = _rOwned[recipient] + (rTransferAmount);
905         if (_currentLiquidityFee > 0) {
906             _takeLiquidityPoolFee(tAmount, currentRate);
907         }
908         if (_currentreflectionFee > 0) {
909             _reflectFee(tAmount);
910         }
911         if (_currentwheelWalletFee > 0) {
912             _takeWheelFee(tAmount, currentRate);
913         }
914 
915         if (_currentcreatorwalletFee > 0) {
916             _takecreatorFee(tAmount, currentRate);
917         }
918         if (_currentautoburnFee > 0) {
919             _takeBurnFee(tAmount, currentRate);
920         }
921 
922         emit Transfer(sender, recipient, tTransferAmount);
923     }
924 
925     function _transferToExcluded(
926         address sender,
927         address recipient,
928         uint256 tAmount
929     ) private {
930         uint256 currentRate = _getRate();
931         uint256 tTransferAmount = tAmount - (totalFeePerTx(tAmount));
932         uint256 rAmount = tAmount * (currentRate);
933         uint256 rTransferAmount = rAmount -
934             (totalFeePerTx(tAmount) * (currentRate));
935         _rOwned[sender] = _rOwned[sender] - (rAmount);
936         _tOwned[recipient] = _tOwned[recipient] + (tTransferAmount);
937         _rOwned[recipient] = _rOwned[recipient] + (rTransferAmount);
938         if (_currentLiquidityFee > 0) {
939             _takeLiquidityPoolFee(tAmount, currentRate);
940         }
941         if (_currentwheelWalletFee > 0) {
942             _takeWheelFee(tAmount, currentRate);
943         }
944         if (_currentcreatorwalletFee > 0) {
945             _takecreatorFee(tAmount, currentRate);
946         }
947         if (_currentreflectionFee > 0) {
948             _reflectFee(tAmount);
949         }
950         if (_currentautoburnFee > 0) {
951             _takeBurnFee(tAmount, currentRate);
952         }
953         emit Transfer(sender, recipient, tTransferAmount);
954     }
955 
956     function _transferFromExcluded(
957         address sender,
958         address recipient,
959         uint256 tAmount
960     ) private {
961         uint256 currentRate = _getRate();
962         uint256 tTransferAmount = tAmount - (totalFeePerTx(tAmount));
963         uint256 rAmount = tAmount * (currentRate);
964         uint256 rTransferAmount = rAmount -
965             (totalFeePerTx(tAmount) * (currentRate));
966         _tOwned[sender] = _tOwned[sender] - (tAmount);
967         _rOwned[sender] = _rOwned[sender] - (rAmount);
968         _rOwned[recipient] = _rOwned[recipient] + (rTransferAmount);
969         if (_currentLiquidityFee > 0) {
970             _takeLiquidityPoolFee(tAmount, currentRate);
971         }
972         if (_currentwheelWalletFee > 0) {
973             _takeWheelFee(tAmount, currentRate);
974         }
975         if (_currentcreatorwalletFee > 0) {
976             _takecreatorFee(tAmount, currentRate);
977         }
978         if (_currentreflectionFee > 0) {
979             _reflectFee(tAmount);
980         }
981         if (_currentautoburnFee > 0) {
982             _takeBurnFee(tAmount, currentRate);
983         }
984         emit Transfer(sender, recipient, tTransferAmount);
985     }
986 
987     function _transferBothExcluded(
988         address sender,
989         address recipient,
990         uint256 tAmount
991     ) private {
992         uint256 currentRate = _getRate();
993         uint256 tTransferAmount = tAmount - (totalFeePerTx(tAmount));
994         uint256 rAmount = tAmount * (currentRate);
995         uint256 rTransferAmount = rAmount -
996             (totalFeePerTx(tAmount) * (currentRate));
997         _tOwned[sender] = _tOwned[sender] - (tAmount);
998         _rOwned[sender] = _rOwned[sender] - (rAmount);
999         _tOwned[recipient] = _tOwned[recipient] + (tTransferAmount);
1000         _rOwned[recipient] = _rOwned[recipient] + (rTransferAmount);
1001         if (_currentLiquidityFee > 0) {
1002             _takeLiquidityPoolFee(tAmount, currentRate);
1003         }
1004         if (_currentwheelWalletFee > 0) {
1005             _takeWheelFee(tAmount, currentRate);
1006         }
1007         if (_currentcreatorwalletFee > 0) {
1008             _takecreatorFee(tAmount, currentRate);
1009         }
1010         if (_currentreflectionFee > 0) {
1011             _reflectFee(tAmount);
1012         }
1013         if (_currentautoburnFee > 0) {
1014             _takeBurnFee(tAmount, currentRate);
1015         }
1016         emit Transfer(sender, recipient, tTransferAmount);
1017     }
1018 
1019     function swapAndLiquify(address from, address to) private {
1020         // is the token balance of this contract address over the min number of
1021         // tokens that we need to initiate a swap + liquidity lock?
1022         // also, don't get caught in a circular liquidity event.
1023         // also, don't swap & liquify if sender is DEX pair.
1024         uint256 contractTokenBalance = balanceOf(address(this));
1025 
1026         bool shouldSell = contractTokenBalance >= minTokenNumberToSell;
1027 
1028         if (
1029             !inSwapAndLiquify &&
1030             shouldSell &&
1031             from != DEXPair &&
1032             swapAndLiquifyEnabled &&
1033             !(from == address(this) && to == address(DEXPair)) // swap 1 time
1034         ) {
1035             // only sell for minTokenNumberToSell, decouple from _maxTxAmount
1036             // split the contract balance into 4 pieces
1037 
1038             contractTokenBalance = minTokenNumberToSell;
1039             // approve contract
1040             _approve(address(this), address(DEXRouter), contractTokenBalance);
1041 
1042             // add liquidity
1043             // split the contract balance into 2 pieces
1044 
1045             uint256 otherPiece = contractTokenBalance / (2);
1046             uint256 tokenAmountToBeSwapped = contractTokenBalance -
1047                 (otherPiece);
1048 
1049             uint256 initialBalance = address(this).balance;
1050 
1051             // now is to lock into staking pool
1052             Utils.swapTokensForEth(address(DEXRouter), tokenAmountToBeSwapped);
1053 
1054             // how much ETH did we just swap into?
1055 
1056             // capture the contract's current ETH balance.
1057             // this is so that we can capture exactly the amount of ETH that the
1058             // swap creates, and not make the liquidity event include any ETH that
1059             // has been manually sent to the contract
1060 
1061             uint256 ETHToBeAddedToLiquidity = address(this).balance -
1062                 (initialBalance);
1063 
1064             // add liquidity to DEX
1065             Utils.addLiquidity(
1066                 address(DEXRouter),
1067                 owner(),
1068                 otherPiece,
1069                 ETHToBeAddedToLiquidity
1070             );
1071 
1072             emit SwapAndLiquify(
1073                 tokenAmountToBeSwapped,
1074                 ETHToBeAddedToLiquidity,
1075                 otherPiece
1076             );
1077         }
1078     }
1079 }
1080 
1081 library Utils {
1082     function swapTokensForEth(address routerAddress, uint256 tokenAmount)
1083         internal
1084     {
1085         IDEXRouter02 DEXRouter = IDEXRouter02(routerAddress);
1086 
1087         // generate the DEX pair path of token -> weth
1088         address[] memory path = new address[](2);
1089         path[0] = address(this);
1090         path[1] = DEXRouter.WETH();
1091 
1092         // make the swap
1093         DEXRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1094             tokenAmount,
1095             0, // accept any amount of ETH
1096             path,
1097             address(this),
1098             block.timestamp + 300
1099         );
1100     }
1101 
1102     function addLiquidity(
1103         address routerAddress,
1104         address owner,
1105         uint256 tokenAmount,
1106         uint256 ethAmount
1107     ) internal {
1108         IDEXRouter02 DEXRouter = IDEXRouter02(routerAddress);
1109 
1110         // add the liquidity
1111         DEXRouter.addLiquidityETH{value: ethAmount}(
1112             address(this),
1113             tokenAmount,
1114             0, // slippage is unavoidable
1115             0, // slippage is unavoidable
1116             owner,
1117             block.timestamp + 300
1118         );
1119     }
1120 }