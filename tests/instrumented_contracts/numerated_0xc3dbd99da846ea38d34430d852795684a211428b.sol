1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 interface IERC20Metadata is IERC20 {
17     function name() external view returns (string memory);
18     function symbol() external view returns (string memory);
19     function decimals() external view returns (uint8);
20 }
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 contract ERC20 is Context, IERC20, IERC20Metadata {
33     mapping(address => uint256) private _balances;
34     mapping(address => mapping(address => uint256)) private _allowances;
35 
36     uint256 private _totalSupply;
37 
38     string private _name;
39     string private _symbol;
40 
41     constructor(string memory name_, string memory symbol_) {
42         _name = name_;
43         _symbol = symbol_;
44     }
45 
46     function name() public view virtual override returns (string memory) {
47         return _name;
48     }
49 
50     function symbol() public view virtual override returns (string memory) {
51         return _symbol;
52     }
53 
54     function decimals() public view virtual override returns (uint8) {
55         return 18;
56     }
57 
58     function totalSupply() public view virtual override returns (uint256) {
59         return _totalSupply;
60     }
61 
62     function balanceOf(address account) public view virtual override returns (uint256) {
63         return _balances[account];
64     }
65 
66     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
67         _transfer(_msgSender(), recipient, amount);
68         return true;
69     }
70 
71     function allowance(address owner, address spender) public view virtual override returns (uint256) {
72         return _allowances[owner][spender];
73     }
74 
75     function approve(address spender, uint256 amount) public virtual override returns (bool) {
76         _approve(_msgSender(), spender, amount);
77         return true;
78     }
79 
80     function transferFrom(
81         address sender,
82         address recipient,
83         uint256 amount
84     ) public virtual override returns (bool) {
85         _transfer(sender, recipient, amount);
86 
87         uint256 currentAllowance = _allowances[sender][_msgSender()];
88         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
89         unchecked {
90             _approve(sender, _msgSender(), currentAllowance - amount);
91         }
92         return true;
93     }
94 
95     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
96         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
97         return true;
98     }
99 
100     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
101         uint256 currentAllowance = _allowances[_msgSender()][spender];
102         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
103         unchecked {
104             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
105         }
106         return true;
107     }
108 
109     function _transfer(
110         address sender,
111         address recipient,
112         uint256 amount
113     ) internal virtual {
114         require(sender != address(0), "ERC20: transfer from the zero address");
115         require(recipient != address(0), "ERC20: transfer to the zero address");
116 
117         _beforeTokenTransfer(sender, recipient, amount);
118 
119         uint256 senderBalance = _balances[sender];
120         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
121         unchecked {
122             _balances[sender] = senderBalance - amount;
123         }
124         _balances[recipient] += amount;
125 
126         emit Transfer(sender, recipient, amount);
127 
128         _afterTokenTransfer(sender, recipient, amount);
129     }
130 
131     function _mint(address account, uint256 amount) internal virtual {
132         require(account != address(0), "ERC20: mint to the zero address");
133 
134         _beforeTokenTransfer(address(0), account, amount);
135 
136         _totalSupply += amount;
137         _balances[account] += amount;
138         emit Transfer(address(0), account, amount);
139 
140         _afterTokenTransfer(address(0), account, amount);
141     }
142 
143     function _burn(address account, uint256 amount) internal virtual {
144         require(account != address(0), "ERC20: burn from the zero address");
145 
146         _beforeTokenTransfer(account, address(0), amount);
147 
148         uint256 accountBalance = _balances[account];
149         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
150         unchecked {
151             _balances[account] = accountBalance - amount;
152         }
153         _totalSupply -= amount;
154 
155         emit Transfer(account, address(0), amount);
156 
157         _afterTokenTransfer(account, address(0), amount);
158     }
159 
160     function _approve(
161         address owner,
162         address spender,
163         uint256 amount
164     ) internal virtual {
165         require(owner != address(0), "ERC20: approve from the zero address");
166         require(spender != address(0), "ERC20: approve to the zero address");
167 
168         _allowances[owner][spender] = amount;
169         emit Approval(owner, spender, amount);
170     }
171 
172     function _beforeTokenTransfer(
173         address from,
174         address to,
175         uint256 amount
176     ) internal virtual {}
177 
178     function _afterTokenTransfer(
179         address from,
180         address to,
181         uint256 amount
182     ) internal virtual {}
183 }
184 
185 abstract contract Ownable is Context {
186     address private _owner;
187 
188     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
189 
190     constructor() {
191         _setOwner(_msgSender());
192     }
193 
194     function owner() public view virtual returns (address) {
195         return _owner;
196     }
197 
198     modifier onlyOwner() {
199         require(owner() == _msgSender(), "Ownable: caller is not the owner");
200         _;
201     }
202 
203     function renounceOwnership() public virtual onlyOwner {
204         _setOwner(address(0));
205     }
206 
207     function transferOwnership(address newOwner) public virtual onlyOwner {
208         require(newOwner != address(0), "Ownable: new owner is the zero address");
209         _setOwner(newOwner);
210     }
211 
212     function _setOwner(address newOwner) private {
213         address oldOwner = _owner;
214         _owner = newOwner;
215         emit OwnershipTransferred(oldOwner, newOwner);
216     }
217 }
218 
219 // CAUTION
220 // This version of SafeMath should only be used with Solidity 0.8 or later,
221 // because it relies on the compiler's built in overflow checks.
222 
223 library SafeMath {
224 
225     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
226         unchecked {
227             uint256 c = a + b;
228             if (c < a) return (false, 0);
229             return (true, c);
230         }
231     }
232 
233     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
234         unchecked {
235             if (b > a) return (false, 0);
236             return (true, a - b);
237         }
238     }
239 
240     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
241         unchecked {
242             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
243             // benefit is lost if 'b' is also tested.
244             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
245             if (a == 0) return (true, 0);
246             uint256 c = a * b;
247             if (c / a != b) return (false, 0);
248             return (true, c);
249         }
250     }
251 
252     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
253         unchecked {
254             if (b == 0) return (false, 0);
255             return (true, a / b);
256         }
257     }
258 
259     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
260         unchecked {
261             if (b == 0) return (false, 0);
262             return (true, a % b);
263         }
264     }
265 
266     function add(uint256 a, uint256 b) internal pure returns (uint256) {
267         return a + b;
268     }
269 
270     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
271         return a - b;
272     }
273 
274     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
275         return a * b;
276     }
277 
278     function div(uint256 a, uint256 b) internal pure returns (uint256) {
279         return a / b;
280     }
281 
282     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
283         return a % b;
284     }
285 
286     function sub(
287         uint256 a,
288         uint256 b,
289         string memory errorMessage
290     ) internal pure returns (uint256) {
291         unchecked {
292             require(b <= a, errorMessage);
293             return a - b;
294         }
295     }
296 
297     function div(
298         uint256 a,
299         uint256 b,
300         string memory errorMessage
301     ) internal pure returns (uint256) {
302         unchecked {
303             require(b > 0, errorMessage);
304             return a / b;
305         }
306     }
307 
308     function mod(
309         uint256 a,
310         uint256 b,
311         string memory errorMessage
312     ) internal pure returns (uint256) {
313         unchecked {
314             require(b > 0, errorMessage);
315             return a % b;
316         }
317     }
318 }
319 
320 interface DexFactory {
321     function createPair(address tokenA, address tokenB) external returns (address pair);
322 }
323 
324 interface DexRouter {
325     function factory() external pure returns (address);
326 
327     function WETH() external pure returns (address);
328 
329     function addLiquidityETH(
330         address token,
331         uint256 amountTokenDesired,
332         uint256 amountTokenMin,
333         uint256 amountETHMin,
334         address to,
335         uint256 deadline
336     )
337         external
338         payable
339         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
340 
341     function swapExactTokensForETHSupportingFeeOnTransferTokens(
342         uint256 amountIn,
343         uint256 amountOutMin,
344         address[] calldata path,
345         address to,
346         uint256 deadline
347     ) external;
348 }
349 
350 contract LYF is ERC20, Ownable {
351     using SafeMath for uint256;
352 
353 
354     uint256 private constant _totalSupply = 120_000_000 * 1e18;
355 
356     //Router
357     DexRouter public immutable uniswapRouter;
358     address public immutable pairAddress;
359 
360     //Buy Taxes
361     uint256 public BuyFinanceTax = 20;
362     uint256 public BuyTreasury = 13;
363     uint256 public BuyFoundation = 17;
364     uint256 public BuyRewards = 10;
365     uint256 public BuyAutoLiquidity = 0;
366 
367     uint256 public buyTaxes = BuyFinanceTax + BuyTreasury + BuyFoundation+ BuyRewards + BuyAutoLiquidity;
368 
369     //Sell Taxes
370     uint256 public SellFinanceTax = 25;
371     uint256 public SellTreasury = 15;
372     uint256 public SellFoundation = 20;
373     uint256 public SellRewards = 10;
374     uint256 public SellAutoLiquidity = 10;
375 
376     uint256 public sellTaxes = SellFinanceTax + SellTreasury + SellFoundation + SellRewards + SellAutoLiquidity;
377 
378     //Transfer Taxes
379     uint256 public transferTaxes = 0;
380 
381     //Whitelisting from taxes and trading limits
382     mapping(address => bool) private whitelisted;
383 
384     //Blacklist wallets
385     mapping(address => bool) private blacklisted;
386 
387     //Swapping
388     uint256 public swapTokensAtAmount = _totalSupply / 100000; //Collect 0.001% of total supply to swap to taxes
389     bool public swapAndLiquifyEnabled = true;
390     bool public isSwapping = false;
391     bool public tradingEnabled = false;
392     uint256 public startTradingBlock;
393 
394     //Wallets
395 
396     address payable public FinanceAddress = payable(0x313DF74b4C441c1aD253D89Bb172141B8bA213b1);
397     address payable public TreasuryAddress = payable(0x92C2a076680c0B47f717ac587bf0b895Dde3B252);
398     address payable public FoundationAddress = payable(0xE4752A7EBC1948Cb8E01234df49e6e576e1931e3);
399     address payable public RewardsAddress = payable(0x16dDbD8D5C7E11Fb7a819B55D6A78E03A909d828);
400 
401     //Events
402     event FinanceAddressChanged(address indexed _trWallet); 
403     event TreasuryAddressChanged(address indexed _trWallet);
404     event FoundationAddressChanged(address indexed _trWallet);
405     event RewardsAddressChanged(address indexed _trWallet);
406     event BuyFeesUpdated(uint256 indexed newBuyFinanceTax, uint256 newBuyTreasury, uint256 newBuyFoundation, uint256 newBuyRewards, uint256 newBuyAutoLiquidity);
407     event SellFeesUpdated(uint256 indexed newSellFinanceTax, uint256 newSellTreasury, uint256 newSellFoundation, uint256 newSellRewards, uint256 newSellAutoLiquidity);
408     event SwapThresholdUpdated(uint256 indexed _newThreshold);
409     event InternalSwapStatusUpdated(bool indexed _status);
410     event Whitelist(address indexed _target, bool indexed _status);
411     event Blacklist(address indexed _target, bool indexed _status);
412     event SwapAndLiquify(
413         uint256 tokensSwapped,
414         uint256 ethReceived,
415         uint256 tokensIntoLiqudity
416     );
417 
418     constructor() ERC20("Lillian Token", "LYF") {
419 
420         uniswapRouter = DexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
421         pairAddress = DexFactory(uniswapRouter.factory()).createPair(
422             address(this),
423             uniswapRouter.WETH()
424         );
425         whitelisted[msg.sender] = true;
426         whitelisted[address(uniswapRouter)] = true;
427         whitelisted[FoundationAddress] = true;
428         whitelisted[TreasuryAddress] = true;
429         whitelisted[FinanceAddress] = true;
430         whitelisted[RewardsAddress] = true;
431         whitelisted[address(this)] = true;       
432         _mint(0xeCe1129c4518dA93C802648d5220D34Bcc7e9AC0, _totalSupply);
433 
434     }
435 
436     function setFinanceAddress(address _newaddress) external onlyOwner {
437         require(_newaddress != address(0), "can not set marketing to dead wallet");
438         FinanceAddress = payable(_newaddress);
439         emit FinanceAddressChanged(_newaddress);
440     }
441 
442     function setTreasuryAddress(address _newaddress) external onlyOwner {
443         require(_newaddress != address(0), "can not set marketing to dead wallet");
444         TreasuryAddress = payable(_newaddress);
445         emit TreasuryAddressChanged(_newaddress);
446     }
447 
448     function setFoundationAddress(address _newaddress) external onlyOwner {
449         require(_newaddress != address(0), "can not set marketing to dead wallet");
450         FoundationAddress = payable(_newaddress);
451         emit FoundationAddressChanged(_newaddress);
452     }
453 
454     function setRewardsAddress(address _newaddress) external onlyOwner {
455         require(_newaddress != address(0), "can not set marketing to dead wallet");
456         RewardsAddress = payable(_newaddress);
457         emit RewardsAddressChanged(_newaddress);
458     }
459 
460     function enableTrading() external onlyOwner {
461         require(!tradingEnabled, "Trading is already enabled");
462         tradingEnabled = true;
463         startTradingBlock = block.number;
464     }
465 
466     function disableTrading() external onlyOwner {
467         require(tradingEnabled, "Trading is already disabled");
468         tradingEnabled = false;
469     }
470 
471     function setBuyTaxes(uint256 _newBuyFinanceTax, uint256 _newBuyTreasury, uint256 _newBuyFoundation, uint256 _newBuyRewards, uint256 _newBuyAutoLiquidity) external onlyOwner {
472         BuyFinanceTax = _newBuyFinanceTax;
473         BuyTreasury = _newBuyTreasury;
474         BuyFoundation = _newBuyFoundation;
475         BuyRewards = _newBuyRewards;
476         BuyAutoLiquidity = _newBuyAutoLiquidity;
477         buyTaxes = BuyFinanceTax.add(BuyTreasury).add(BuyFoundation).add(BuyRewards).add(BuyAutoLiquidity);
478         emit BuyFeesUpdated(BuyFinanceTax, BuyTreasury, BuyFoundation, BuyRewards, BuyAutoLiquidity);
479     }
480 
481     function setSellTaxes(uint256 _newSellFinanceTax, uint256 _newSellTreasury, uint256 _newSellFoundation, uint256 _newSellRewards, uint256 _newSellAutoLiquidity) external onlyOwner {
482         SellFinanceTax = _newSellFinanceTax;
483         SellTreasury = _newSellTreasury;
484         SellFoundation = _newSellFoundation;
485         SellRewards = _newSellRewards;
486         SellAutoLiquidity = _newSellAutoLiquidity;
487         sellTaxes = SellFinanceTax.add(SellTreasury).add(SellFoundation).add(SellRewards).add(SellAutoLiquidity);
488         emit SellFeesUpdated(SellFinanceTax, SellTreasury, SellFoundation, SellRewards, SellAutoLiquidity);
489     }
490 
491     function setSwapTokensAtAmount(uint256 _newAmount) external onlyOwner {
492         require(_newAmount > 0 && _newAmount <= (_totalSupply * 5) / 1000, "Minimum swap amount must be greater than 0 and less than 0.5% of total supply!");
493         swapTokensAtAmount = _newAmount;
494         emit SwapThresholdUpdated(swapTokensAtAmount);
495     }
496 
497     function toggleSwapping() external onlyOwner {
498         swapAndLiquifyEnabled = (swapAndLiquifyEnabled) ? false : true;
499     }
500 
501     function setWhitelistStatus(address _wallet, bool _status) external onlyOwner {
502         whitelisted[_wallet] = _status;
503         emit Whitelist(_wallet, _status);
504     }
505 
506     function setBlacklist(address _address, bool _isBlacklisted) external onlyOwner {
507         blacklisted[_address] = _isBlacklisted;
508         emit Blacklist(_address, _isBlacklisted);
509     }
510 
511     function checkWhitelist(address _wallet) external view returns (bool) {
512         return whitelisted[_wallet];
513     }
514 
515     function checkBlacklist(address _address) external view returns (bool) {
516         return blacklisted[_address];
517     }
518 
519     // this function is reponsible for managing tax, if _from or _to is whitelisted, we simply return _amount and skip all the limitations
520     function _takeTax(
521         address _from,
522         address _to,
523         uint256 _amount
524     ) internal returns (uint256) {
525         if (whitelisted[_from] || whitelisted[_to]) {
526             return _amount;
527         }
528         uint256 totalTax = transferTaxes;
529 
530         if (_to == pairAddress) {
531             totalTax = sellTaxes;
532         } else if (_from == pairAddress) {
533             totalTax = buyTaxes;
534         }
535 
536         uint256 tax = 0;
537         if (totalTax > 0) {
538             tax = (_amount * totalTax) / 1000;
539             super._transfer(_from, address(this), tax);
540         }
541         return (_amount - tax);
542     }
543 
544 function _transfer(
545     address _from,
546     address _to,
547     uint256 _amount
548 ) internal virtual override {
549     require(_from != address(0), "transfer from address zero");
550     require(_to != address(0), "transfer to address zero");
551     require(_amount > 0, "Transfer amount must be greater than zero");
552     require(!blacklisted[_from], "Transfer from blacklisted address");
553     require(!blacklisted[_to], "Transfer to blacklisted address");
554     uint256 toTransfer = _takeTax(_from, _to, _amount);
555 
556     bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
557     if (
558         !whitelisted[_from] &&
559         !whitelisted[_to] &&
560         !blacklisted[_from] &&
561         !blacklisted[_to] 
562     ) {
563         require(tradingEnabled, "Trading not active");
564         if (
565             pairAddress == _to &&
566             swapAndLiquifyEnabled &&
567             canSwap &&
568             !isSwapping
569         ) {
570             internalSwap();
571         }
572     }
573     super._transfer(_from, _to, toTransfer);
574 }
575 
576     function internalSwap() internal {
577     isSwapping = true;
578     uint256 taxAmount = balanceOf(address(this)); 
579     if (taxAmount == 0) {
580         return;
581     }
582 
583     uint256 totalFee = (buyTaxes).add(sellTaxes);
584 
585     uint256 FinanceShare =(BuyFinanceTax).add(SellFinanceTax);
586     uint256 TreasuryShare = (BuyTreasury).add(SellTreasury);
587     uint256 FoundationShare =(BuyFoundation).add(SellFoundation);
588     uint256 RewardsShare =(BuyRewards).add(SellRewards);
589     uint256 LiquidityShare =(BuyAutoLiquidity).add(SellAutoLiquidity);
590 
591     if (LiquidityShare == 0) {
592         totalFee = FinanceShare.add(TreasuryShare).add(FoundationShare).add(RewardsShare);
593     }
594 
595     uint256 halfLPTokens = 0;
596     if (totalFee > 0) {
597         halfLPTokens = taxAmount.mul(LiquidityShare).div(totalFee).div(2);
598     }
599     uint256 swapTokens = taxAmount.sub(halfLPTokens);
600     uint256 initialBalance = address(this).balance;
601     swapToETH(swapTokens);
602     uint256 newBalance = address(this).balance.sub(initialBalance);
603 
604     uint256 ethForLiquidity = 0;
605     if (LiquidityShare > 0) {
606         ethForLiquidity = newBalance.mul(LiquidityShare).div(totalFee).div(2);
607     
608     addLiquidity(halfLPTokens, ethForLiquidity);
609     emit SwapAndLiquify(halfLPTokens, ethForLiquidity, halfLPTokens);
610     }
611     uint256 ethForFinance = newBalance.mul(FinanceShare).div(totalFee);
612     uint256 ethForTreasury = newBalance.mul(TreasuryShare).div(totalFee);
613     uint256 ethForFoundation = newBalance.mul(FoundationShare).div(totalFee);
614     uint256 ethForRewards = newBalance.mul(RewardsShare).div(totalFee);
615 
616     transferToAddressETH(FinanceAddress, ethForFinance);
617     transferToAddressETH(TreasuryAddress, ethForTreasury);
618     transferToAddressETH(FoundationAddress, ethForFoundation);
619     transferToAddressETH(RewardsAddress, ethForRewards);
620 
621     isSwapping = false;
622 }
623 
624     function transferToAddressETH(address payable recipient, uint256 amount) private 
625     {
626         recipient.transfer(amount);
627     }    
628 
629     function swapToETH(uint256 _amount) internal {
630         address[] memory path = new address[](2);
631         path[0] = address(this);
632         path[1] = uniswapRouter.WETH();
633         _approve(address(this), address(uniswapRouter), _amount);
634         uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
635             _amount,
636             0,
637             path,
638             address(this),
639             block.timestamp
640         );
641     }
642     
643     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
644         // approve token transfer to cover all possible scenarios
645         _approve(address(this), address(uniswapRouter), tokenAmount);
646 
647         // add the liquidity
648         uniswapRouter.addLiquidityETH{value: ethAmount}(
649             address(this),
650             tokenAmount,
651             0, // slippage is unavoidable
652             0, // slippage is unavoidable
653             owner(),
654             block.timestamp
655         );
656     }
657 
658     function withdrawStuckETH() external onlyOwner {
659         uint256 balance = address(this).balance;
660         require(balance > 0, "No ETH available to withdraw");
661 
662         (bool success, ) = address(msg.sender).call{value: balance}("");
663         require(success, "transferring ETH failed");
664     }
665 
666     function withdrawStuckTokens(address ERC20_token) external onlyOwner {
667         require(ERC20_token != address(this), "Owner cannot claim native tokens");
668 
669         uint256 tokenBalance = IERC20(ERC20_token).balanceOf(address(this));
670         require(tokenBalance > 0, "No tokens available to withdraw");
671 
672         bool success = IERC20(ERC20_token).transfer(msg.sender, tokenBalance);
673         require(success, "transferring tokens failed!");
674     }
675 
676     receive() external payable {}
677 }