1 /**
2 Telegram: https://t.me/mayhemportal
3 Twitter: https://twitter.com/Mayhem_ERC
4 Website: https://projectmayhem.agency/
5 
6 
7 Introducing "Project Mayhem" - a captivating crypto endeavor that lets you step into the shoes of a corrupt politician, wielding unparalleled power and influence. 
8 In a world where politicians have long exploited their positions to manipulate tax systems and wreak havoc on economies, it's time for you to embrace the dark side.
9 
10 Project Mayhem unveils a collection of NFTs like no other. These exclusive tokens represent notorious politicians, embodying their unscrupulous tactics, 
11 manipulative strategies, and their ability to control the financial realm.
12 
13 But here's where the allure intensifies. As the owner of a politician NFT, you gain the exhilarating privilege of molding the tax landscape. 
14 However, there's a twist – to exercise your authority and alter the state of ERC20 taxes, you must burn your NFT, symbolizing the sacrifice of your corrupt alter ego.
15 
16 Picture yourself at the epicenter of a clandestine network, where you can bend the rules and shape tax policies to your advantage. By willingly relinquishing your NFT, 
17 you unleash a profound transformation, exerting your influence over the ERC20 native currency that fuels Project Mayhem.
18 
19 Gone are the days of being at the mercy of politicians. Project Mayhem empowers you to embrace your inner manipulator and mold the financial destiny of the ecosystem. 
20 Through the act of burning your NFT, you transcend conventional boundaries and cement your role as the ultimate corrupt politician, 
21 leaving an indelible mark on the tax landscape.
22 
23 Seize the opportunity to indulge in the allure of power, to manipulate and subvert the system to your advantage. 
24 Project Mayhem beckons you to embrace the darkness within and exploit the very mechanisms that have long plagued society. 
25 Are you prepared to embrace your alter ego and embark on a journey where corruption knows no bounds? The path to power and manipulation awaits your command.
26 */
27 
28 // SPDX-License-Identifier: UNLICENSED
29 
30 pragma solidity ^0.8.18;
31 
32 interface IERC20 {
33     function totalSupply() external view returns (uint256);
34     function decimals() external view returns (uint8);
35     function symbol() external view returns (string memory);
36     function name() external view returns (string memory);
37     function getOwner() external view returns (address);
38     function balanceOf(address account) external view returns (uint256);
39     function transfer(address recipient, uint256 amount) external returns (bool);
40     function allowance(address _owner, address spender) external view returns (uint256);
41     function approve(address spender, uint256 amount) external returns (bool);
42     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
43     
44     event Transfer(address indexed from, address indexed to, uint256 value);
45     event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 interface IEnactMayhem {
49     function setBuyFeeAndCollectionAddress(uint256 _marketingFee, address collectionAddress) external;
50     function setSellFeeAndCollectionAddress(uint256 newFee, address collectionAddress) external;
51     function setBuyFee(uint256 newFee) external;
52     function setSellFee(uint256 newFee) external;
53     function setCollectionAddress(address collectionAddress) external;
54     function setLiqBuyFee(uint256 newFee) external;
55     function setLiqSellFee(uint256 newFee) external;
56     function setBuyBuyBackFee(uint256 newFee) external;
57     function setSellBuyBackFee(uint256 newFee) external;
58     function killdozer(uint256 buyMarketing, uint256 sellMarketing, uint256 buyLiquidity, uint256 sellLiquidity, uint256 buyBuyBack, uint256 sellBuyBack) external;
59 }
60 
61 abstract contract Ownable {
62     address internal owner;
63     address private _previousOwner;
64     uint256 private _lockTime;
65 
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     constructor(address _owner) {
69         owner = _owner;
70     }
71 
72     modifier onlyOwner() {
73         require(isOwner(msg.sender), "!OWNER"); _;
74     }
75 
76     function isOwner(address account) public view returns (bool) {
77         return account == owner;
78     }
79 
80     function transferOwnership(address newOwner) public virtual onlyOwner {
81         require(newOwner != address(0), "Ownable: new owner is the zero address");
82         emit OwnershipTransferred(owner, newOwner);
83         owner = newOwner;
84     }
85 
86     function getUnlockTime() public view returns (uint256) {
87         return _lockTime;
88     }
89 
90     function Ownershiplock(uint256 time) public virtual onlyOwner {
91         _previousOwner = owner;
92         owner = address(0);
93         _lockTime = block.timestamp + time;
94         emit OwnershipTransferred(owner, address(0));
95     }
96 
97     function Ownershipunlock() public virtual {
98         require(_previousOwner == msg.sender, "You don't have permission to unlock");
99         require(block.timestamp > _lockTime , "Contract is locked");
100         emit OwnershipTransferred(owner, _previousOwner);
101         owner = _previousOwner;
102     }
103 }
104 
105 /**
106  * Router Interfaces
107  */
108 
109 interface IDEXFactory {
110     function createPair(address tokenA, address tokenB) external returns (address pair);
111 }
112 
113 interface IDEXRouter {
114     function factory() external pure returns (address);
115     function WETH() external pure returns (address);
116 
117     function addLiquidity(
118         address tokenA,
119         address tokenB,
120         uint amountADesired,
121         uint amountBDesired,
122         uint amountAMin,
123         uint amountBMin,
124         address to,
125         uint deadline
126     ) external returns (uint amountA, uint amountB, uint liquidity);
127 
128     function addLiquidityETH(
129         address token,
130         uint amountTokenDesired,
131         uint amountTokenMin,
132         uint amountETHMin,
133         address to,
134         uint deadline
135     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
136 
137     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
138         uint amountIn,
139         uint amountOutMin,
140         address[] calldata path,
141         address to,
142         uint deadline
143     ) external;
144 
145     function swapExactETHForTokensSupportingFeeOnTransferTokens(
146         uint amountOutMin,
147         address[] calldata path,
148         address to,
149         uint deadline
150     ) external payable;
151 
152     function swapExactTokensForETHSupportingFeeOnTransferTokens(
153         uint amountIn,
154         uint amountOutMin,
155         address[] calldata path,
156         address to,
157         uint deadline
158     ) external;
159 }
160 
161 /**
162  * Contract Code
163  */
164 
165 contract Mayhem is IERC20, Ownable, IEnactMayhem {
166 
167     address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
168     address DEAD = 0x000000000000000000000000000000000000dEaD;
169     address ZERO = 0x0000000000000000000000000000000000000000;
170 
171     string constant _name = "Project Mayhem"; // 
172     string constant _symbol = "Mayhem"; // 
173     uint8 constant _decimals = 9;
174     uint256 _totalSupply = 1 * 10**9 * 10**_decimals;
175 
176     mapping (address => uint256) _balances;
177     mapping (address => mapping (address => uint256)) _allowances;
178     mapping (address => bool) public isFeeExempt;
179     mapping (address => bool) public isTxLimitExempt;
180     
181     // Detailed Fees
182     uint256 public liqFee;
183     uint256 public marketingFee;
184     uint256 public buybackFee;
185     uint256 public totalFee;
186     address public erc1155Contract;
187 
188     uint256 public BuyliquidityFee    = 10;
189     uint256 public BuymarketingFee    = 10;
190     uint256 public BuybuybackFee      = 10;
191     uint256 public BuytotalFee        = BuyliquidityFee + BuymarketingFee + BuybuybackFee;
192 
193     uint256 public SellliquidityFee    = 10;
194     uint256 public SellmarketingFee    = 10;
195     uint256 public SellbuybackFee      = 10;
196     uint256 public SelltotalFee        = SellliquidityFee + SellmarketingFee + SellbuybackFee;
197 
198     // Max wallet & Transaction
199     uint256 public _maxBuyTxAmount = _totalSupply / (100) * (2); // 2%
200     uint256 public _maxSellTxAmount = _totalSupply / (100) * (2); // 2%
201     uint256 public _maxWalletToken = _totalSupply / (100) * (2); // 2%
202 
203     // Fees receivers
204     address public autoLiquidityReceiver = 0x000000000000000000000000000000000000dEaD;
205     address public feeCollectionAddress = 0xBF70750c72559D641eBAe083F69E54e8603a2d9a;
206     address public buybackFeeReceiver = 0xBF70750c72559D641eBAe083F69E54e8603a2d9a;
207 	address public stucketh = 0xBF70750c72559D641eBAe083F69E54e8603a2d9a;
208 
209     IDEXRouter public router;
210     address public pair;
211 
212     bool public swapEnabled = true;
213     uint256 public swapThreshold = _totalSupply / 1000 * 1; // 0.1%
214     uint256 public maxSwapSize = _totalSupply / 100 * 1; //1%
215     uint256 public tokensToSell;
216 
217     bool inSwap;
218     modifier swapping() { inSwap = true; _; inSwap = false; }
219 
220     modifier onlyOwnerOrAuthorized() {
221         require(msg.sender == owner || msg.sender == address(erc1155Contract), "Unauthorized");
222         _;
223     }
224   
225     constructor () Ownable(msg.sender) {
226         owner = msg.sender;
227         erc1155Contract = address(0x0);
228 
229         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
230         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
231         _allowances[address(this)][address(router)] = type(uint256).max;
232 
233 
234         isFeeExempt[msg.sender] = true;
235         isTxLimitExempt[msg.sender] = true;
236         feeCollectionAddress = address(0x0);
237 
238         _balances[msg.sender] = _totalSupply;
239         emit Transfer(address(0), msg.sender, _totalSupply);
240     }
241 
242     receive() external payable { }
243       
244     function totalSupply() external view override returns (uint256) { return _totalSupply; }
245     function decimals() external pure override returns (uint8) { return _decimals; }
246     function symbol() external pure override returns (string memory) { return _symbol; }
247     function name() external pure override returns (string memory) { return _name; }
248     function getOwner() external view override returns (address) { return owner; }
249     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
250     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
251     function approve(address spender, uint256 amount) public override returns (bool) {
252         _allowances[msg.sender][spender] = amount;
253         emit Approval(msg.sender, spender, amount);
254         return true;
255     }
256     
257     function approveMax(address spender) external returns (bool) {
258         return approve(spender, type(uint256).max);
259     }
260 
261     function transfer(address recipient, uint256 amount) external override returns (bool) {
262         return _transferFrom(msg.sender, recipient, amount);
263     }
264 
265     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
266         if(_allowances[sender][msg.sender] != type(uint256).max){
267             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
268         }
269 
270         return _transferFrom(sender, recipient, amount);
271     }
272 
273     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
274         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
275 
276         if(sender == pair){
277             buyFees();
278         }
279 
280         if(recipient == pair){
281             sellFees();
282         }
283 
284         if (sender != owner && recipient != address(this) && recipient != address(DEAD) && recipient != pair || isTxLimitExempt[recipient]){
285             uint256 heldTokens = balanceOf(recipient);
286             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
287 
288         // Checks max transaction limit
289         if(sender == pair){
290             require(amount <= _maxBuyTxAmount || isTxLimitExempt[recipient], "TX Limit Exceeded");
291         }
292         
293         if(recipient == pair){
294             require(amount <= _maxSellTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
295         }
296         //Exchange tokens
297         if(shouldSwapBack()){ swapBack(); }
298 
299         _balances[sender] = _balances[sender] - amount;
300 
301         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(recipient, amount) : amount;
302         _balances[recipient] = _balances[recipient] + amountReceived;
303 
304         emit Transfer(sender, recipient, amountReceived);
305         return true;
306     }
307     
308     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
309         _balances[sender] = _balances[sender] - amount;
310         _balances[recipient] = _balances[recipient] + (amount);
311         emit Transfer(sender, recipient, amount);
312         return true;
313     }
314 
315     // Internal Functions
316     function buyFees() internal{
317         liqFee    = BuyliquidityFee;
318         marketingFee    = BuymarketingFee;
319         buybackFee      = BuybuybackFee;
320         totalFee        = BuytotalFee;
321     }
322 
323     function sellFees() internal{
324         liqFee    = SellliquidityFee;
325         marketingFee    = SellmarketingFee;
326         buybackFee      = SellbuybackFee;
327         totalFee        = SelltotalFee;
328     }
329 
330     function shouldTakeFee(address sender) internal view returns (bool) {
331         return !isFeeExempt[sender];
332     }
333 
334     function takeFee(address sender, uint256 amount) internal returns (uint256) {
335         uint256 feeAmount = amount / 100 * (totalFee);
336 
337         _balances[address(this)] = _balances[address(this)] + (feeAmount);
338         emit Transfer(sender, address(this), feeAmount);
339 
340         return amount - (feeAmount);
341     }
342   
343     function shouldSwapBack() internal view returns (bool) {
344         return msg.sender != pair
345         && !inSwap
346         && swapEnabled
347         && _balances[address(this)] >= swapThreshold;
348     }
349 
350     function swapBack() internal swapping {
351         uint256 contractTokenBalance = balanceOf(address(this));
352         if(contractTokenBalance >= maxSwapSize){
353             tokensToSell = maxSwapSize;            
354         }
355         else{
356             tokensToSell = contractTokenBalance;
357         }
358 
359         uint256 amountToLiquify = tokensToSell / (totalFee) * (liqFee) / (2);
360         uint256 amountToSwap = tokensToSell - (amountToLiquify);
361 
362         address[] memory path = new address[](2);
363         path[0] = address(this);
364         path[1] = WETH;
365 
366         uint256 balanceBefore = address(this).balance;
367 
368         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
369             amountToSwap,
370             0,
371             path,
372             address(this),
373             block.timestamp
374         );
375 
376         uint256 amountETH = address(this).balance - (balanceBefore);
377 
378         uint256 totalETHFee = totalFee - (liqFee / (2));
379         
380         uint256 amountETHLiquidity = amountETH * (liqFee) / (totalETHFee) / (2);
381         uint256 amountETHbuyback = amountETH * (buybackFee) / (totalETHFee);
382         uint256 amountETHMarketing = amountETH * (marketingFee) / (totalETHFee);
383 
384         (bool MarketingSuccess,) = payable(feeCollectionAddress).call{value: amountETHMarketing, gas: 30000}("");
385         require(MarketingSuccess, "receiver rejected ETH transfer");
386         (bool buybackSuccess,) = payable(buybackFeeReceiver).call{value: amountETHbuyback, gas: 30000}("");
387         require(buybackSuccess, "receiver rejected ETH transfer");
388 
389         addLiquidity(amountToLiquify, amountETHLiquidity);
390     }
391 
392     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
393     if(tokenAmount > 0){
394             router.addLiquidityETH{value: ethAmount}(
395                 address(this),
396                 tokenAmount,
397                 0,
398                 0,
399                 autoLiquidityReceiver,
400                 block.timestamp
401             );
402             emit AutoLiquify(ethAmount, tokenAmount);
403         }
404     }
405 
406     // External Functions
407     function checkSwapThreshold() external view returns (uint256) {
408         return swapThreshold;
409     }
410     
411     function checkMaxWalletToken() external view returns (uint256) {
412         return _maxWalletToken;
413     }
414     
415     function checkMaxBuyTxAmount() external view returns (uint256) {
416         return _maxBuyTxAmount;
417     }
418     
419     function checkMaxSellTxAmount() external view returns (uint256) {
420         return _maxSellTxAmount;
421     }
422 
423     function isNotInSwap() external view returns (bool) {
424         return !inSwap;
425     }
426 
427     // Only Owner allowed
428     function setBuyFees(uint256 _liquidityFee, uint256 _buybackFee, uint256 _marketingFee) external onlyOwner {
429 		require (_liquidityFee <= 5, "Fee can't exceed 5%");
430 		require (_buybackFee <= 5, "Fee can't exceed 5%");
431 		require (_marketingFee <= 5, "Fee can't exceed 5%");
432         BuyliquidityFee = _liquidityFee;
433         BuybuybackFee = _buybackFee;
434         BuymarketingFee = _marketingFee;
435         BuytotalFee = _liquidityFee + (_buybackFee) + (_marketingFee);
436     }
437 
438 
439     // Set functions on receivers and taxes only callable by owner or NFT
440 
441 
442     function setBuyFeeAndCollectionAddress(uint256 _marketingFee, address collectionAddress) external onlyOwnerOrAuthorized {
443 		require (_marketingFee <= 5, "Fee can't exceed 5%");
444         BuymarketingFee = _marketingFee;
445         feeCollectionAddress = collectionAddress;
446         BuytotalFee = BuyliquidityFee + BuymarketingFee + BuybuybackFee;
447     }
448 
449     function setBuyFee(uint256 _marketingFee) external onlyOwnerOrAuthorized {
450 		require (_marketingFee <= 5, "Fee can't exceed 5%");
451         BuymarketingFee = _marketingFee;
452         BuytotalFee = BuyliquidityFee + BuymarketingFee + BuybuybackFee;
453     }
454 
455     function setSellFee(uint256 _marketingFee) external onlyOwnerOrAuthorized {
456 		require (_marketingFee <= 5, "Fee can't exceed 5%");
457         SellmarketingFee = _marketingFee;
458         SelltotalFee = SellliquidityFee + SellmarketingFee + SellbuybackFee;
459     }
460 
461     function setSellFeeAndCollectionAddress(uint256 _marketingFee, address collectionAddress) external onlyOwnerOrAuthorized {
462 		require (_marketingFee <= 5, "Fee can't exceed 5%");
463         SellmarketingFee = _marketingFee;
464         feeCollectionAddress = collectionAddress;
465         SelltotalFee = SellliquidityFee + SellmarketingFee + SellbuybackFee;
466     }
467 
468     function setLiqBuyFee(uint256 newFee) external onlyOwnerOrAuthorized {
469 		require (newFee <= 5, "Fee can't exceed 5%");
470         BuyliquidityFee = newFee;
471         BuytotalFee = BuyliquidityFee + BuymarketingFee + BuybuybackFee;
472     }
473 
474     function setLiqSellFee(uint256 newFee) external onlyOwnerOrAuthorized {
475 		require (newFee <= 5, "Fee can't exceed 5%");
476         SellliquidityFee = newFee;
477         SelltotalFee = SellliquidityFee + SellmarketingFee + SellbuybackFee;
478     }
479 
480     function setBuyBuyBackFee(uint256 newFee) external onlyOwnerOrAuthorized {
481 		require (newFee <= 5, "Fee can't exceed 5%");
482         BuybuybackFee = newFee;
483         BuytotalFee = BuyliquidityFee + BuymarketingFee + BuybuybackFee;
484     }
485 
486     function setSellBuyBackFee(uint256 newFee) external onlyOwnerOrAuthorized {
487 		require (newFee <= 5, "Fee can't exceed 5%");
488         SellbuybackFee = newFee;
489         SelltotalFee = SellliquidityFee + SellmarketingFee + SellbuybackFee;
490     }
491 
492     function setCollectionAddress(address collectionAddress) external onlyOwnerOrAuthorized {
493         feeCollectionAddress = collectionAddress;
494     }
495 
496     function setERC1155Contract(address _erc1155Contract) external onlyOwnerOrAuthorized {
497         erc1155Contract = _erc1155Contract;
498     }
499 
500     function killdozer(uint256 buyMarketing, uint256 sellMarketing, uint256 buyLiquidity, uint256 sellLiquidity, uint256 buyBuyBack, uint256 sellBuyBack) external onlyOwnerOrAuthorized {
501 		require (buyMarketing <= 5, "Fee can't exceed 5%");
502 		require (sellMarketing <= 5, "Fee can't exceed 5%");
503 		require (buyLiquidity <= 5, "Fee can't exceed 5%");
504 		require (sellLiquidity <= 5, "Fee can't exceed 5%");
505 		require (buyBuyBack <= 5, "Fee can't exceed 5%");
506 		require (sellBuyBack <= 5, "Fee can't exceed 5%");
507         BuymarketingFee = buyMarketing;
508         SellmarketingFee = sellMarketing;
509         BuyliquidityFee = buyLiquidity;
510         SellliquidityFee = sellLiquidity;
511         BuybuybackFee = buyBuyBack;
512         SellbuybackFee = sellBuyBack;
513         BuytotalFee = BuyliquidityFee + BuymarketingFee + BuybuybackFee;
514         SelltotalFee = SellliquidityFee + SellmarketingFee + SellbuybackFee;
515     }
516 
517     function setSellFees(uint256 _liquidityFee, uint256 _buybackFee, uint256 _marketingFee) external onlyOwner {
518 		require (_liquidityFee <= 5, "Fee can't exceed 5%");
519 		require (_buybackFee <= 5, "Fee can't exceed 5%");
520 		require (_marketingFee <= 5, "Fee can't exceed 5%");
521         SellliquidityFee = _liquidityFee;
522         SellbuybackFee = _buybackFee;
523         SellmarketingFee = _marketingFee;
524         SelltotalFee = _liquidityFee + (_buybackFee) + (_marketingFee);
525     }
526     
527     function setFeeReceivers(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _buybackFeeReceiver) external onlyOwner {
528         autoLiquidityReceiver = _autoLiquidityReceiver;
529         feeCollectionAddress = _marketingFeeReceiver;
530         buybackFeeReceiver = _buybackFeeReceiver;
531     }
532 
533     function setSwapBackSettings(bool _enabled, uint256 _percentage_min_base10000, uint256 _percentage_max_base10000) external onlyOwner {
534         swapEnabled = _enabled;
535         swapThreshold = _totalSupply / (10000) * (_percentage_min_base10000);
536         maxSwapSize = _totalSupply / (10000) * (_percentage_max_base10000);
537     }
538 
539     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
540         isFeeExempt[holder] = exempt;
541     }
542     
543     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
544         isTxLimitExempt[holder] = exempt;
545     }
546 	
547     function ownerSetLimits(uint256 maxBuyTXPercentage_base1000, uint256 maxSellTXPercentage_base1000, uint256 maxWallPercent_base1000) external onlyOwner {
548         require(maxBuyTXPercentage_base1000 >=5, "Cannot set Max Transaction below 0.5%");
549 		require(maxSellTXPercentage_base1000 >=5, "Cannot set Max Transaction below 0.5%");
550         require(maxWallPercent_base1000 >=10, "Cannot set Max Wallet below 1%");
551         _maxWalletToken = _totalSupply / (1000) * (maxWallPercent_base1000);
552 		_maxSellTxAmount = _totalSupply / (1000) * (maxSellTXPercentage_base1000);
553 		_maxBuyTxAmount = _totalSupply / (1000) * (maxBuyTXPercentage_base1000);
554     }
555 	
556     function setMaxWalletPercent_base1000(uint256 maxWallPercent_base1000) external onlyOwner {
557         require(maxWallPercent_base1000 >=10, "Cannot set Max Wallet below 1%");
558         _maxWalletToken = _totalSupply / (1000) * (maxWallPercent_base1000);
559     }
560 
561     function setMaxBuyTxPercent_base1000(uint256 maxBuyTXPercentage_base1000) external onlyOwner {
562 		require(maxBuyTXPercentage_base1000 >=5, "Cannot set Max Transaction below 0.5%");
563         _maxBuyTxAmount = _totalSupply / (1000) * (maxBuyTXPercentage_base1000);
564     }
565 
566     function setMaxSellTxPercent_base1000(uint256 maxSellTXPercentage_base1000) external onlyOwner {
567 		require(maxSellTXPercentage_base1000 >=5, "Cannot set Max Transaction below 0.5%");
568         _maxSellTxAmount = _totalSupply / (1000) * (maxSellTXPercentage_base1000);
569     }
570 
571     // Stuck Balances Functions
572     function rescueToken(address tokenAddress, uint256 tokens) public returns (bool success) {
573         return IERC20(tokenAddress).transfer(stucketh, tokens);
574     }
575 
576     function clearStuckBalance(uint256 amountPercentage) external {
577         uint256 amountETH = address(this).balance;
578         payable(stucketh).transfer(amountETH * amountPercentage / 100);
579     }
580 
581     event AutoLiquify(uint256 amountETH, uint256 amountTokens);
582 
583 }