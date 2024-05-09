1 // File: contracts/WTA.sol
2 
3 
4 
5 pragma solidity 0.8.15;
6 
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(
62         address sender,
63         address recipient,
64         uint256 amount
65     ) external returns (bool);
66 
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to {approve}. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 abstract contract Context {
82     function _msgSender() internal view virtual returns (address) {
83         return msg.sender;
84     }
85 
86     function _msgData() internal view virtual returns (bytes calldata) {
87         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
88         return msg.data;
89     }
90 }
91 interface IERC20Metadata is IERC20 {
92     /**
93      * @dev Returns the name of the token.
94      */
95     function name() external view returns (string memory);
96 
97     /**
98      * @dev Returns the symbol of the token.
99      */
100     function symbol() external view returns (string memory);
101 
102     /**
103      * @dev Returns the decimals places of the token.
104      */
105     function decimals() external view returns (uint8);
106 }
107 
108 
109 contract ERC20 is Context, IERC20, IERC20Metadata {
110     mapping(address => uint256) private _balances;
111 
112     mapping(address => mapping(address => uint256)) private _allowances;
113 
114     uint256 private _totalSupply;
115 
116     string private _name;
117     string private _symbol;
118 
119     constructor(string memory name_, string memory symbol_) {
120         _name = name_;
121         _symbol = symbol_;
122     }
123 
124     function name() public view virtual override returns (string memory) {
125         return _name;
126     }
127 
128     function symbol() public view virtual override returns (string memory) {
129         return _symbol;
130     }
131 
132     function decimals() public view virtual override returns (uint8) {
133         return 18;
134     }
135 
136     function totalSupply() public view virtual override returns (uint256) {
137         return _totalSupply;
138     }
139 
140     function balanceOf(address account) public view virtual override returns (uint256) {
141         return _balances[account];
142     }
143 
144     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
145         _transfer(_msgSender(), recipient, amount);
146         return true;
147     }
148 
149     function allowance(address owner, address spender) public view virtual override returns (uint256) {
150         return _allowances[owner][spender];
151     }
152 
153     function approve(address spender, uint256 amount) public virtual override returns (bool) {
154         _approve(_msgSender(), spender, amount);
155         return true;
156     }
157 
158     function transferFrom(
159         address sender,
160         address recipient,
161         uint256 amount
162     ) public virtual override returns (bool) {
163         _transfer(sender, recipient, amount);
164 
165         uint256 currentAllowance = _allowances[sender][_msgSender()];
166         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
167         unchecked {
168             _approve(sender, _msgSender(), currentAllowance - amount);
169         }
170 
171         return true;
172     }
173 
174     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
175         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
176         return true;
177     }
178 
179     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
180         uint256 currentAllowance = _allowances[_msgSender()][spender];
181         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
182         unchecked {
183             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
184         }
185 
186         return true;
187     }
188 
189     function _transfer(
190         address sender,
191         address recipient,
192         uint256 amount
193     ) internal virtual {
194         require(sender != address(0), "ERC20: transfer from the zero address");
195         require(recipient != address(0), "ERC20: transfer to the zero address");
196 
197         uint256 senderBalance = _balances[sender];
198         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
199         unchecked {
200             _balances[sender] = senderBalance - amount;
201         }
202         _balances[recipient] += amount;
203 
204         emit Transfer(sender, recipient, amount);
205     }
206 
207     function _createInitialSupply(address account, uint256 amount) internal virtual {
208         require(account != address(0), "ERC20: mint to the zero address");
209 
210         _totalSupply += amount;
211         _balances[account] += amount;
212         emit Transfer(address(0), account, amount);
213     }
214 
215     function _burn(address account, uint256 amount) internal virtual {
216         require(account != address(0), "ERC20: burn from the zero address");
217         uint256 accountBalance = _balances[account];
218         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
219         unchecked {
220             _balances[account] = accountBalance - amount;
221             // Overflow not possible: amount <= accountBalance <= totalSupply.
222             _totalSupply -= amount;
223         }
224 
225         emit Transfer(account, address(0), amount);
226     }
227 
228     function _approve(
229         address owner,
230         address spender,
231         uint256 amount
232     ) internal virtual {
233         require(owner != address(0), "ERC20: approve from the zero address");
234         require(spender != address(0), "ERC20: approve to the zero address");
235 
236         _allowances[owner][spender] = amount;
237         emit Approval(owner, spender, amount);
238     }
239 }
240 
241 
242 contract Ownable is Context {
243     address private _owner;
244 
245     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
246 
247     constructor () {
248         address msgSender = _msgSender();
249         _owner = msgSender;
250         emit OwnershipTransferred(address(0), msgSender);
251     }
252 
253     function owner() public view returns (address) {
254         return _owner;
255     }
256 
257     modifier onlyOwner() {
258         require(_owner == _msgSender(), "Ownable: caller is not the owner");
259         _;
260     }
261 
262     function renounceOwnership() external virtual onlyOwner {
263         emit OwnershipTransferred(_owner, address(0));
264         _owner = address(0);
265     }
266 
267     function transferOwnership(address newOwner) public virtual onlyOwner {
268         require(newOwner != address(0), "Ownable: new owner is the zero address");
269         emit OwnershipTransferred(_owner, newOwner);
270         _owner = newOwner;
271     }
272 }
273 interface IDexRouter {
274     function factory() external pure returns (address);
275     function WETH() external pure returns (address);
276 
277     function swapExactTokensForETHSupportingFeeOnTransferTokens(
278         uint amountIn,
279         uint amountOutMin,
280         address[] calldata path,
281         address to,
282         uint deadline
283     ) external;
284 
285     function swapExactETHForTokensSupportingFeeOnTransferTokens(
286         uint amountOutMin,
287         address[] calldata path,
288         address to,
289         uint deadline
290     ) external payable;
291 
292     function addLiquidityETH(
293         address token,
294         uint256 amountTokenDesired,
295         uint256 amountTokenMin,
296         uint256 amountETHMin,
297         address to,
298         uint256 deadline
299     )
300         external
301         payable
302         returns (
303             uint256 amountToken,
304             uint256 amountETH,
305             uint256 liquidity
306         );
307 }
308 
309 interface IDexFactory {
310     function createPair(address tokenA, address tokenB)
311         external
312         returns (address pair);
313 }
314 
315 contract WTA is ERC20, Ownable {
316 
317     uint256 public maxBuyAmount;
318     uint256 public maxSellAmount;
319     uint256 public maxWalletAmount;
320 
321     IDexRouter public dexRouter;
322     address public lpPair;
323 
324     bool private swapping;
325     uint256 public swapTokensAtAmount;
326 
327     address operationsAddress =  0xe76236a86d43b3e5db9EbD4166096eAFb4Bd641C;
328     address devAddress;
329     address LockAddress = 0x71B5759d73262FBb223956913ecF4ecC51057641; //pinksale Lock
330 
331     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
332     uint256 public blockForPenaltyEnd;
333     mapping (address => bool) public boughtEarly;
334     uint256 public botsCaught;
335 
336     mapping(address => uint256) public lastBought;
337     uint256 public earlySellerPeriod = 3; //3 blocks are around 36 seconds
338     bool private botIsSellingEarly = false;
339 
340     bool public limitsInEffect = true;
341     bool public tradingActive = false;
342     bool public swapEnabled = false;
343      // Anti-bot and anti-whale mappings and variables
344     uint256 public buyTotalFees;
345     uint256 public buyOperationsFee;
346     uint256 public buyLiquidityFee;
347     uint256 public buyDevFee;
348     uint256 public buyBurnFee;
349 
350     uint256 public sellTotalFees;
351     uint256 public sellOperationsFee;
352     uint256 public sellLiquidityFee;
353     uint256 public sellDevFee;
354     uint256 public sellBurnFee;
355 
356     uint256 public tokensForOperations;
357     uint256 public tokensForLiquidity;
358     uint256 public tokensForDev;
359     uint256 public tokensForBurn;
360 
361     address[] private blackListed=[0x8C4b4dB82EB8C8BC9b2bdf65D7b137A7AEE012D0,0xD7ed05a4868F9deFd2d7eEB8C94d867445Daa408,0x4d9AA579edb764aeaD194Cb63B1454fB3Eea98Ce,0x01D5EA3634837d15D5b4d03A3271B43b809f3C15,0x020804b8e8828F01461b9827149dc40d245cE9A2,0x6db7030dBd67017211C97B77bEbBdad413b76817,0xe57d677FB4aDA64C8ab37C4ad3A102daE7625187,0xcE1909cd1A767829E5fa72d85B66943A07F15fc3,0xB97E25d525Bc2AEAB2769950dE3fE3c28a06F8f3,0x7809b5C38D8891c873521F89D613BC30d8186b19,0xDAC0Be47Dc3aF3E762c8190f7B21A89FE4479a2c,0x030B84179F28652113610a7bb7294170fd59EE69,0x6DE69ccAF4CD380901Ae3DE0B764c8209843f6F5,0xD578eCb9c319E4b39674b994AFB09784afbe1643,0x6495F444c18B37b263EA6E68e4297A9E068B00ff,0x6d2d843dD7a97BBb5DA00F3C3D97551fb8E57c2E,0xe57d677FB4aDA64C8ab37C4ad3A102daE7625187,0xfa5454619BaE1Cb21d8BA55902850eF82fe75F48,0x5e74B1c5d1497E73bb6ce3FdFB9C57296B0c9F66,0x4AfF47B7a1C7FC02935d404a28e9eC0Ce51686b3,0x25399C6B0C4F79bA2061457F4778CD6b8be4C29c,0xc4B80eAc762C65cE57736F8F9E2aD59126c8161B,0xbFf1CB69005Fdbf306C9678CBD40464Dd6f76006,0x2B883dc7489418F262994900204c34Cd3009714f,0x227062f0bC20102ad8bE757E1dD922aE2dC6ca42,0x7457A890e5aaB98a9f1B881E5EAeAf06F9D731bD,0x408B43dA31C09973C8Ca53cC16492cE2ccC40eC2,0x4Ba88dAa27AaDdaae67b25479F6296Cf6C46bc62,0x8e5ca1872062bEE63b8a46493F6dE36D4870Ff88,0xD09D7D8a5E4e57c9b0371c2C7e06D9895D6c4bf7,0xB65C4e32EC6706ffb494A6F5848545a5cCC724d1,0xC82aD63C66F32068D64409bC9052FbbC7B657C21,0x6C56F0eE051Bd4d0cD3aBC86b223D44c96B314B3,0xB43B6F53508F1C392D7FbeCe826d20A1C373Eea8,0xB72055Bd5A65Be52Cd94C52B10Ec590F8aACd96C,0x2c582a485CD50CF749f05df2b042858258b4861B,0xD74aa0d8cc822182cB4b51E346718c46B5d8Bd96,0xbb9FA5c4A1F59ec98f7d602D7b1711690dF013E3,0xa8F28C267d5ef59A8a6833Be35dc487839BFA0E1,0x109711D70c1a6BF8C5a04C9CB623aeaBA347E178,0x809295D8903CE177398D59e52387cd2cf6774162,0x3765E014EBCD2f5cDEa4baC4E24A1E439D385284,0x21FAff3cA9c8d201f30F0dc05cab3633707C7796,0xC4D6CB8CA661bcae7C66351045dcc72085E77616,0xB24e111931c74Beae75e71e07173057155CB0f95,0xD09D7D8a5E4e57c9b0371c2C7e06D9895D6c4bf7,0x47714087fc391E456B3Db6722E679Fbf87658b26,0x2152E07a6aC31e634cec19C2D6F9D743Dbc31328,0x4B27EA8f0a0fEB2442Fb1299F78447d527f57dAd,0x260DDd66A2FA67090537832Dde871b249c27215E,0x6908Cc437c8BEA5c19A81e487A1528635EC2b197,0xE9c2fC4355136851A609a676A3cB76f965e962B7,0x2b18aD0c9501660f5b0e717eb2cE7691bE423D2A,0x94cDF0949209C3e9b9D711A343A1832bEa2bF46B,0x7CF74383F30Fc7537621C0f1FC9D8F01554DD7F2,0x18a75c982c7b2E77627DCBAA4B797875B7A6811c];
362 
363     /******************/
364 
365     // exlcude from fees and max transaction amount
366     mapping (address => bool) private _isExcludedFromFees;
367     mapping (address => bool) public _isExcludedMaxTransactionAmount;
368 
369     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
370     // could be subject to a maximum transfer amount
371     mapping (address => bool) public automatedMarketMakerPairs;
372 
373     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
374 
375     event EnabledTrading();
376 
377     event RemovedLimits();
378 
379     event ExcludeFromFees(address indexed account, bool isExcluded);
380 
381     event UpdatedMaxBuyAmount(uint256 newAmount);
382 
383     event UpdatedMaxSellAmount(uint256 newAmount);
384 
385     event UpdatedMaxWalletAmount(uint256 newAmount);
386 
387     event UpdatedOperationsAddress(address indexed newWallet);
388 
389     event MaxTransactionExclusion(address _address, bool excluded);
390 
391     event BuyBackTriggered(uint256 amount);
392 
393     event OwnerForcedSwapBack(uint256 timestamp);
394 
395     event CaughtEarlyBuyer(address sniper);
396 
397     event SwapAndLiquify(
398         uint256 tokensSwapped,
399         uint256 ethReceived,
400         uint256 tokensIntoLiquidity
401     );
402 
403     event TransferForeignToken(address token, uint256 amount);
404 
405     
406     constructor() ERC20("WTA", "WTA") {
407 
408         address newOwner = msg.sender; // can leave alone if owner is deployer.
409 
410         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
411         dexRouter = _dexRouter;
412 
413         // create pair
414         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
415         _excludeFromMaxTransaction(address(lpPair), true);
416         _setAutomatedMarketMakerPair(address(lpPair), true);
417 
418         uint256 totalSupply = 3 * 1e6 * 1e18;
419 
420         maxBuyAmount = 20000 *1e18;
421         maxSellAmount = 20000 *1e18;
422         maxWalletAmount = 20000 *1e18;
423         swapTokensAtAmount = totalSupply * 2 / 10000;
424 
425         buyOperationsFee = 40;
426         buyLiquidityFee = 0;
427         buyDevFee = 0;
428         buyBurnFee = 0;
429         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
430 
431         sellOperationsFee = 40;
432         sellLiquidityFee = 0;
433         sellDevFee = 0;
434         sellBurnFee = 0;
435         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
436 
437         _excludeFromMaxTransaction(newOwner, true);
438         _excludeFromMaxTransaction(address(this), true);
439         _excludeFromMaxTransaction(address(0xdead), true);
440         _excludeFromMaxTransaction(operationsAddress, true);
441 
442         excludeFromFees(newOwner, true);
443         excludeFromFees(address(this), true);
444         excludeFromFees(address(0xdead), true);
445         excludeFromFees(operationsAddress,true);
446 
447         excludeFromFees(LockAddress,true);
448         _excludeFromMaxTransaction(LockAddress, true);
449 
450         devAddress = address(newOwner);
451 
452         _createInitialSupply(newOwner, totalSupply);
453         transferOwnership(newOwner);
454 
455         massManageBoughtEarly(blackListed,true);
456     }
457 
458     receive() external payable {}
459     fallback() external payable {}
460 
461     // only enable if no plan to airdrop
462 
463     function enableTrading(uint256 deadBlocks) external onlyOwner {
464         require(!tradingActive, "Cannot reenable trading");
465         tradingActive = true;
466         swapEnabled = true;
467         tradingActiveBlock = block.number;
468         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
469         emit EnabledTrading();
470     }
471 
472     // remove limits after token is stable
473     function removeLimits() external onlyOwner {
474         limitsInEffect = false;
475         emit RemovedLimits();
476     }
477 
478     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
479         boughtEarly[wallet] = flag;
480     }
481 
482     function massManageBoughtEarly(address[] memory wallets, bool flag) public onlyOwner {
483         for(uint256 i = 0; i < wallets.length; i++){
484             boughtEarly[wallets[i]] = flag;
485         }
486     }
487 
488      function updateEarlySellerPeriod(uint256 _newPeriod) external onlyOwner {
489         earlySellerPeriod = _newPeriod;
490     }
491 
492     // change the minimum amount of tokens to sell from fees
493     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
494   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
495   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
496   	    swapTokensAtAmount = newAmount;
497   	}
498 
499     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
500         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
501         emit MaxTransactionExclusion(updAds, isExcluded);
502     }
503 
504 
505     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
506         if(!isEx){
507             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
508         }
509         _isExcludedMaxTransactionAmount[updAds] = isEx;
510     }
511 
512 
513     function _setAutomatedMarketMakerPair(address pair, bool value) private {
514         automatedMarketMakerPairs[pair] = value;
515 
516         _excludeFromMaxTransaction(pair, value);
517 
518         emit SetAutomatedMarketMakerPair(pair, value);
519     }
520 
521     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
522         buyOperationsFee = _operationsFee;
523         buyLiquidityFee = _liquidityFee;
524         buyDevFee = _devFee;
525         buyBurnFee = _burnFee;
526         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
527         require(buyTotalFees <= 150, "Must keep fees at 15% or less");
528     }
529 
530     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
531         sellOperationsFee = _operationsFee;
532         sellLiquidityFee = _liquidityFee;
533         sellDevFee = _devFee;
534         sellBurnFee = _burnFee;
535         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
536         require(sellTotalFees <= 200, "Must keep fees at 20% or less");
537     }
538 
539     function excludeFromFees(address account, bool excluded) public onlyOwner {
540         _isExcludedFromFees[account] = excluded;
541         emit ExcludeFromFees(account, excluded);
542     }
543 
544     function isSellingEarly(address _from) private view returns(bool){
545         if (block.number <= lastBought[_from] + earlySellerPeriod){
546            
547             return(true);
548         }else{
549             return(false);
550         }
551     }
552 
553     function _transfer(address from, address to, uint256 amount) internal override {
554 
555         require(from != address(0), "ERC20: transfer from the zero address");
556         require(to != address(0), "ERC20: transfer to the zero address");
557         require(amount > 0, "amount must be greater than 0");
558 
559         if(!tradingActive){
560             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
561         }
562 
563         if(blockForPenaltyEnd > 0){
564             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
565         }
566 
567         if(limitsInEffect){
568             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){  
569                 
570                 //when buy
571                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
572                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
573                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
574                         
575                 }
576                 //when sell
577                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
578                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
579                         
580                 }
581                 else if (!_isExcludedMaxTransactionAmount[to]){
582                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
583                 }
584             }
585         }
586 
587         uint256 contractTokenBalance = balanceOf(address(this));
588 
589         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
590    
591 
592         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
593             swapping = true;
594 
595             
596            
597             swapBack();
598 
599            
600 
601             swapping = false;
602         }
603 
604         bool takeFee = true;
605         // if any account belongs to _isExcludedFromFee account then remove the fee
606         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
607             takeFee = false;
608         }
609 
610         uint256 fees = 0;
611         // only take fees on buys/sells, do not take on wallet transfers
612         if(takeFee){
613             // bot/sniper penalty.
614             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
615                
616                 if(!boughtEarly[to]){
617                     boughtEarly[to] = true;
618                     botsCaught += 1;
619                     emit CaughtEarlyBuyer(to);
620                 }
621                  
622 
623                 fees = amount * 999 / 1000;
624         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
625                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
626                 tokensForDev += fees * buyDevFee / buyTotalFees;
627                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
628             }
629 
630              // on sell BOT
631             else if (isSellingEarly(from) && automatedMarketMakerPairs[to] &&  !automatedMarketMakerPairs[from] && sellTotalFees > 0){
632                 
633 
634                 
635 
636                 if(!boughtEarly[from]){
637                     boughtEarly[from] = true;
638                     botsCaught += 1;
639                     emit CaughtEarlyBuyer(from);
640                 }
641                 
642 
643                 fees =  amount* 999 / 1000; //99% of the token is transferred
644                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
645                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
646                 tokensForDev += fees * sellDevFee / sellTotalFees;
647                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
648 
649                 botIsSellingEarly = true;
650                 
651 
652               
653             }
654 
655             // on sell
656             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
657             
658                 fees = amount * sellTotalFees / 1000;
659                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
660                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
661                 tokensForDev += fees * sellDevFee / sellTotalFees;
662                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
663             }
664 
665             // on buy
666             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
667                 
668         	    fees = amount * buyTotalFees / 1000;
669         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
670                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
671                 tokensForDev += fees * buyDevFee / buyTotalFees;
672                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
673 
674                 lastBought[to]=block.number;
675             }
676             //on wallet transfer
677             else{
678                 fees = 0;
679                 tokensForOperations += fees; 
680             }
681 
682             if(fees > 0){
683               
684                 if(botIsSellingEarly){
685                     botIsSellingEarly= false;
686                 } 
687                 super._transfer(from, address(this), fees);
688                 
689             }
690            
691            
692 
693         	amount -= fees;
694             
695         }
696         
697         super._transfer(from, to, amount);
698         
699         
700     }
701 
702     function earlyBuyPenaltyInEffect() public view returns (bool){
703         return block.number < blockForPenaltyEnd;
704     }
705 
706     function swapTokensForEth(uint256 tokenAmount) private {
707 
708         // generate the uniswap pair path of token -> weth
709         address[] memory path = new address[](2);
710         path[0] = address(this);
711         path[1] = dexRouter.WETH();
712 
713         _approve(address(this), address(dexRouter), tokenAmount);
714 
715         // make the swap
716      
717         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
718             tokenAmount,
719             0, // accept any amount of ETH
720             path,
721             address(this),
722             block.timestamp
723         );
724     }
725 
726     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
727         // approve token transfer to cover all possible scenarios
728         _approve(address(this), address(dexRouter), tokenAmount);
729 
730         // add the liquidity
731         dexRouter.addLiquidityETH{value: ethAmount}(
732             address(this),
733             tokenAmount,
734             0, // slippage is unavoidable
735             0, // slippage is unavoidable
736             address(0xdead),
737             block.timestamp
738         );
739     }
740 
741     function swapBack() private {
742 
743         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
744             _burn(address(this), tokensForBurn);
745         }
746         tokensForBurn = 0;
747 
748         uint256 contractBalance = balanceOf(address(this));
749         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
750 
751         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
752 
753         if(contractBalance > swapTokensAtAmount * 20){
754             contractBalance = swapTokensAtAmount * 20;
755         }
756 
757         bool success;
758 
759         // Halve the amount of liquidity tokens
760         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
761 
762         swapTokensForEth(contractBalance - liquidityTokens);
763 
764         uint256 ethBalance = address(this).balance;
765         uint256 ethForLiquidity = ethBalance;
766 
767         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
768         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
769 
770         ethForLiquidity -= ethForOperations + ethForDev;
771 
772         tokensForLiquidity = 0;
773         tokensForOperations = 0;
774         tokensForDev = 0;
775         tokensForBurn = 0;
776 
777         if(liquidityTokens > 0 && ethForLiquidity > 0){
778             addLiquidity(liquidityTokens, ethForLiquidity);
779         }
780 
781         (success,) = address(devAddress).call{value: ethForDev}("");
782         
783         (success,) = address(operationsAddress).call{value: address(this).balance}("");
784     }
785 
786 
787     // withdraw ETH if stuck or someone sends to the address
788     function withdrawStuckETH() external onlyOwner {
789         bool success;
790         (success,) = address(msg.sender).call{value: address(this).balance}("");
791     }
792 
793     function setOperationsAddress(address _operationsAddress) external onlyOwner {
794         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
795         operationsAddress = payable(_operationsAddress);
796     }
797 
798     function setDevAddress(address _devAddress) external onlyOwner {
799         require(_devAddress != address(0), "_devAddress address cannot be 0");
800         devAddress = payable(_devAddress);
801     }
802 
803     // force Swap back if slippage issues.
804     function forceSwapBack() external onlyOwner {
805         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
806         swapping = true;
807         swapBack();
808         swapping = false;
809         emit OwnerForcedSwapBack(block.timestamp);
810     }
811 }