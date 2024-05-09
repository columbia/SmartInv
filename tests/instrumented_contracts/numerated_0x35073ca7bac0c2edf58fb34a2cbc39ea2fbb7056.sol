1 // SPDX-License-Identifier: UNLICENSED
2 
3 /*
4 
5 TELEGRAM: 
6 https://t.me/torwalletapp
7 
8 WEBSITE: 
9 https://torwallet.app/
10 
11 */
12 
13 
14 pragma solidity 0.8.18;
15 
16 library SafeMath {
17     function add(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a + b;
19         require(c >= a, "SafeMath: addition overflow");
20 
21         return c;
22     }
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         return sub(a, b, "SafeMath: subtraction overflow");
25     }
26     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
27         require(b <= a, errorMessage);
28         uint256 c = a - b;
29 
30         return c;
31     }
32     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33         if (a == 0) {
34             return 0;
35         }
36 
37         uint256 c = a * b;
38         require(c / a == b, "SafeMath: multiplication overflow");
39 
40         return c;
41     }
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         return div(a, b, "SafeMath: division by zero");
44     }
45     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b > 0, errorMessage);
47         uint256 c = a / b;
48         return c;
49     }
50 }
51 
52 interface BEP20 {
53     function totalSupply() external view returns (uint256);
54     function decimals() external view returns (uint8);
55     function symbol() external view returns (string memory);
56     function name() external view returns (string memory);    function getOwner() external view returns (address);
57     function balanceOf(address account) external view returns (uint256);
58     function transfer(address recipient, uint256 amount) external returns (bool);
59     function allowance(address _owner, address spender) external view returns (uint256);
60     function approve(address spender, uint256 amount) external returns (bool);
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62     event Transfer(address indexed from, address indexed to, uint256 value);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 abstract contract Auth {
67     address internal owner;
68     address internal potentialOwner;
69     mapping (address => bool) internal authorizations;
70 
71     event Authorize_Wallet(address Wallet, bool Status);
72 
73     event OwnershipRenounced(address indexed previousOwner);
74 
75     event OwnershipTransferred(
76         address indexed previousOwner,
77         address indexed newOwner
78     );
79 
80 
81     constructor(address _owner) {
82         owner = _owner;
83         authorizations[_owner] = true;
84     }
85 
86     modifier onlyOwner() {
87         require(isOwner(msg.sender), "!OWNER"); _;
88     }
89 
90     modifier authorized() {
91         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
92     }
93 
94     function authorize(address adr) external onlyOwner {
95         authorizations[adr] = true;
96         emit Authorize_Wallet(adr,true);
97     }
98 
99     function unauthorize(address adr) external onlyOwner {
100         require(adr != owner, "OWNER cant be unauthorized");
101         authorizations[adr] = false;
102         emit Authorize_Wallet(adr,false);
103     }
104 
105     function isOwner(address account) public view returns (bool) {
106         return account == owner;
107     }
108 
109     function isAuthorized(address adr) public view returns (bool) {
110         return authorizations[adr];
111     }
112 
113     function renounceOwnership() public onlyOwner {
114         emit OwnershipRenounced(owner);
115         owner = address(0);
116     }
117 
118     function transferOwnership(address newOwner) public onlyOwner {
119         _transferOwnership(newOwner);
120     }
121 
122     function _transferOwnership(address newOwner) internal {
123         require(newOwner != address(0));
124         emit OwnershipTransferred(owner, newOwner);
125         owner = newOwner;
126     }
127 }
128 
129 interface IDEXFactory {
130     function createPair(address tokenA, address tokenB) external returns (address pair);
131 }
132 
133 interface IDEXRouter {
134     function factory() external pure returns (address);
135     function WETH() external pure returns (address);
136 
137     function addLiquidity(
138         address tokenA,
139         address tokenB,
140         uint amountADesired,
141         uint amountBDesired,
142         uint amountAMin,
143         uint amountBMin,
144         address to,
145         uint deadline
146     ) external returns (uint amountA, uint amountB, uint liquidity);
147 
148     function addLiquidityETH(
149         address token,
150         uint amountTokenDesired,
151         uint amountTokenMin,
152         uint amountETHMin,
153         address to,
154         uint deadline
155     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
156 
157     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
158         uint amountIn,
159         uint amountOutMin,
160         address[] calldata path,
161         address to,
162         uint deadline
163     ) external;
164 
165     function swapExactETHForTokensSupportingFeeOnTransferTokens(
166         uint amountOutMin,
167         address[] calldata path,
168         address to,
169         uint deadline
170     ) external payable;
171 
172     function swapExactTokensForETHSupportingFeeOnTransferTokens(
173         uint amountIn,
174         uint amountOutMin,
175         address[] calldata path,
176         address to,
177         uint deadline
178     ) external;
179 }
180 
181 interface InterfaceLP {
182     function sync() external;
183 }
184 
185 contract TorWallet is BEP20, Auth {
186     using SafeMath for uint256;
187 
188     address immutable WBNB;
189     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
190     address constant ZERO = 0x0000000000000000000000000000000000000000;
191 
192     string constant _name = "Tor Wallet";
193     string constant _symbol = "TOR";
194     uint8 constant _decimals = 18;
195 
196     uint256 public _totalSupply = 1 * 10**7 * 10**_decimals;
197 
198     uint256 public _maxTxAmount = _totalSupply / 100; // 1%
199     uint256 public _maxWalletToken = _totalSupply / 50; // 2%
200 
201     mapping (address => uint256) public balanceOf;
202     mapping (address => mapping (address => uint256)) _allowances;
203 
204     mapping (address => bool) public isFeeExempt;
205     mapping (address => bool) public isTxLimitExempt;
206     mapping (address => bool) public isWalletLimitExempt;
207 
208     uint256 public liquidityFee = 0;
209     uint256 public marketingFee = 0;
210     uint256 public buybackFee = 0;
211     uint256 public burnFee = 0;
212     uint256 public totalFee = marketingFee + liquidityFee + buybackFee + burnFee;
213     uint256 public constant feeDenominator = 1000;
214 
215     uint256 sellMultiplier = 100;
216     uint256 buyMultiplier = 100;
217     uint256 transferMultiplier = 25;
218 
219     address public marketingFeeReceiver;
220     address public buybackFeeReceiver;
221 
222     IDEXRouter public router;
223     address public immutable pair;
224 
225     InterfaceLP public pairContract;
226     uint256 public lastSync;
227 
228     bool public tradingOpen = false;
229     bool public burnEnabled = false;
230     uint256 public launchedAt;
231 
232     bool public swapEnabled = true;
233     uint256 public swapThreshold = _totalSupply / 1000;
234     bool inSwap;
235     modifier swapping() { inSwap = true; _; inSwap = false; }
236 
237     constructor () Auth(msg.sender) {
238         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
239         //router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); testnet
240         WBNB = router.WETH();
241 
242         pair = IDEXFactory(router.factory()).createPair(WBNB, address(this));
243         pairContract = InterfaceLP(pair);
244         lastSync = block.timestamp;
245 
246         _allowances[address(this)][address(router)] = type(uint256).max;
247 
248         marketingFeeReceiver = msg.sender;
249         buybackFeeReceiver = msg.sender;
250 
251         isFeeExempt[msg.sender] = true;
252 
253         isTxLimitExempt[msg.sender] = true;
254         isTxLimitExempt[DEAD] = true;
255         isTxLimitExempt[ZERO] = true;
256 
257         isWalletLimitExempt[msg.sender] = true;
258         isWalletLimitExempt[address(this)] = true;
259         isWalletLimitExempt[DEAD] = true;
260 
261         balanceOf[msg.sender] = _totalSupply;
262         emit Transfer(address(0), msg.sender, _totalSupply);
263     }
264 
265     receive() external payable { }
266 
267     function totalSupply() external view override returns (uint256) { return _totalSupply; }
268     function decimals() external pure override returns (uint8) { return _decimals; }
269     function symbol() external pure override returns (string memory) { return _symbol; }
270     function name() external pure override returns (string memory) { return _name; }   function getOwner() external view override returns (address) { return owner; }
271     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
272 
273     function approve(address spender, uint256 amount) public override returns (bool) {
274         _allowances[msg.sender][spender] = amount;
275         emit Approval(msg.sender, spender, amount);
276         return true;
277     }
278 
279     function approveMax(address spender) external returns (bool) {
280         return approve(spender, type(uint256).max);
281     }
282 
283     function transfer(address recipient, uint256 amount) external override returns (bool) {
284         return _transferFrom(msg.sender, recipient, amount);
285     }
286 
287     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
288         if(_allowances[sender][msg.sender] != type(uint256).max){
289             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
290         }
291 
292         return _transferFrom(sender, recipient, amount);
293     }
294 
295     function setMaxWalletPercent_base10000(uint256 maxWallPercent_base10000) external onlyOwner {
296         require(maxWallPercent_base10000 >= 10,"Cannot set max wallet less than 0.1%");
297         _maxWalletToken = (_totalSupply * maxWallPercent_base10000 ) / 10000;
298         emit config_MaxWallet(_maxWalletToken);
299     }
300     function setMaxTxPercent_base10000(uint256 maxTXPercentage_base10000) external onlyOwner {
301         require(maxTXPercentage_base10000 >= 10,"Cannot set max transaction less than 0.1%");
302         _maxTxAmount = (_totalSupply * maxTXPercentage_base10000 ) / 10000;
303         emit config_MaxTransaction(_maxTxAmount);
304     }
305 
306     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
307         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
308 
309         if(!authorizations[sender] && !authorizations[recipient]){
310             require(tradingOpen,"Trading not open yet");
311         }
312 
313         if (!authorizations[sender] && !isWalletLimitExempt[sender] && !isWalletLimitExempt[recipient] && recipient != pair) {
314             require((balanceOf[recipient] + amount) <= _maxWalletToken,"max wallet limit reached");
315         }
316     
317         // Checks max transaction limit
318         require((amount <= _maxTxAmount) || isTxLimitExempt[sender] || isTxLimitExempt[recipient], "Max TX Limit Exceeded");
319 
320         if(shouldSwapBack()){ swapBack(); }
321 
322         balanceOf[sender] = balanceOf[sender].sub(amount, "Insufficient Balance");
323 
324         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
325 
326         balanceOf[recipient] = balanceOf[recipient].add(amountReceived);
327 
328 
329         emit Transfer(sender, recipient, amountReceived);
330         return true;
331     }
332     
333     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
334         balanceOf[sender] = balanceOf[sender].sub(amount, "Insufficient Balance");
335         balanceOf[recipient] = balanceOf[recipient].add(amount);
336         emit Transfer(sender, recipient, amount);
337         return true;
338     }
339 
340     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
341         if(amount == 0 || totalFee == 0){
342             return amount;
343         }
344 
345         uint256 multiplier = transferMultiplier;
346 
347         if(recipient == pair) {
348             multiplier = sellMultiplier;
349         } else if(sender == pair) {
350             multiplier = buyMultiplier;
351         }
352 
353         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
354         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
355         uint256 contractTokens = feeAmount.sub(burnTokens);
356 
357         if(contractTokens > 0){
358             balanceOf[address(this)] = balanceOf[address(this)].add(contractTokens);
359             emit Transfer(sender, address(this), contractTokens);
360         }
361         
362         if(burnTokens > 0){
363             _totalSupply = _totalSupply.sub(burnTokens);
364             emit Transfer(sender, ZERO, burnTokens);  
365         }
366 
367         return amount.sub(feeAmount);
368     }
369 
370     function shouldSwapBack() internal view returns (bool) {
371         return msg.sender != pair
372         && !inSwap
373         && swapEnabled
374         && balanceOf[address(this)] >= swapThreshold;
375     }
376 
377     function clearStuckToken(address tokenAddress, uint256 tokens) external authorized returns (bool success) {
378         require(tokenAddress != address(this),"Cannot withdraw native token");
379         if(tokenAddress == pair){
380             require(block.timestamp > launchedAt + 500 days,"Locked for 1 year");
381         }
382 
383         if(tokens == 0){
384             tokens = BEP20(tokenAddress).balanceOf(address(this));
385         }
386 
387         emit clearToken(tokenAddress, tokens);
388 
389         return BEP20(tokenAddress).transfer(msg.sender, tokens);
390     }
391 
392     // switch Trading
393     function tradingEnable() external onlyOwner {
394         require(!tradingOpen,"Trading already open");
395         tradingOpen = true;
396         launchedAt = block.timestamp;
397         emit config_TradingStatus(tradingOpen);
398     }
399 
400     function disableBurns() external onlyOwner {
401         burnEnabled = false;
402     }
403 
404     function enableBurns() external onlyOwner {
405         burnEnabled = true;
406     }
407 
408     function swapBack() internal swapping {
409 
410         uint256 totalETHFee = totalFee - burnFee;
411 
412         uint256 amountToLiquify = (swapThreshold * liquidityFee)/(totalETHFee * 2);
413         uint256 amountToSwap = swapThreshold - amountToLiquify;
414 
415         address[] memory path = new address[](2);
416         path[0] = address(this);
417         path[1] = WBNB;
418 
419         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
420             amountToSwap,
421             0,
422             path,
423             address(this),
424             block.timestamp
425         );
426 
427         uint256 amountBNB = address(this).balance;
428 
429          totalETHFee = totalETHFee - (liquidityFee / 2);
430         
431         uint256 amountBNBLiquidity = (amountBNB * liquidityFee) / (totalETHFee * 2);
432         uint256 amountBNBMarketing = (amountBNB * marketingFee) / totalETHFee;
433         uint256 amountBNBbuyback = (amountBNB * buybackFee) / totalETHFee;
434 
435         payable(marketingFeeReceiver).transfer(amountBNBMarketing);
436         payable(buybackFeeReceiver).transfer(amountBNBbuyback);
437 
438         if(amountToLiquify > 0){
439             router.addLiquidityETH{value: amountBNBLiquidity}(
440                 address(this),
441                 amountToLiquify,
442                 0,
443                 0,
444                 address(this),
445                 block.timestamp
446             );
447             emit AutoLiquify(amountBNBLiquidity, amountToLiquify);
448         }
449     }
450 
451     function manage_FeeExempt(address[] calldata addresses, bool status) external authorized {
452         require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
453         for (uint256 i=0; i < addresses.length; ++i) {
454             isFeeExempt[addresses[i]] = status;
455             emit Wallet_feeExempt(addresses[i], status);
456         }
457     }
458 
459     function manage_TxLimitExempt(address[] calldata addresses, bool status) external authorized {
460         require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
461         for (uint256 i=0; i < addresses.length; ++i) {
462             isTxLimitExempt[addresses[i]] = status;
463             emit Wallet_txExempt(addresses[i], status);
464         }
465     }
466 
467     function manage_WalletLimitExempt(address[] calldata addresses, bool status) external authorized {
468         require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
469         for (uint256 i=0; i < addresses.length; ++i) {
470             isWalletLimitExempt[addresses[i]] = status;
471             emit Wallet_holdingExempt(addresses[i], status);
472         }
473     }
474 
475     function update_fees() internal {
476         require(totalFee.mul(buyMultiplier).div(100) <= 150, "Buy tax cannot be more than 15%");
477         require(totalFee.mul(sellMultiplier).div(100) <= 150, "Sell tax cannot be more than 15%");
478         require(totalFee.mul(sellMultiplier + buyMultiplier).div(100) <= 200, "Buy+Sell tax cannot be more than 20%");
479         require(totalFee.mul(transferMultiplier).div(100) <= 100, "Transfer Tax cannot be more than 10%");
480 
481         emit UpdateFee( uint8(totalFee.mul(buyMultiplier).div(100)),
482             uint8(totalFee.mul(sellMultiplier).div(100)),
483             uint8(totalFee.mul(transferMultiplier).div(100))
484             );
485     }
486 
487     function setMultipliers(uint256 _buy, uint256 _sell, uint256 _trans) external authorized {
488         sellMultiplier = _sell;
489         buyMultiplier = _buy;
490         transferMultiplier = _trans;
491 
492         update_fees();
493     }
494 
495     function setFees_base1000(uint256 _liquidityFee,  uint256 _marketingFee, uint256 _buybackFee, uint256 _burnFee) external onlyOwner {
496         liquidityFee = _liquidityFee;
497         marketingFee = _marketingFee;
498         buybackFee = _buybackFee;
499         burnFee = _burnFee;
500         totalFee = _liquidityFee + _marketingFee + _buybackFee + _burnFee;
501         
502         update_fees();
503     }
504 
505     function setFeeReceivers(address _marketingFeeReceiver, address _buybackFeeReceiver) external onlyOwner {
506         require(_marketingFeeReceiver != address(0),"Marketing fee address cannot be zero address");
507         require(_buybackFeeReceiver != address(0),"buyback fee address cannot be zero address");
508 
509         marketingFeeReceiver = _marketingFeeReceiver;
510         buybackFeeReceiver = _buybackFeeReceiver;
511 
512         emit Set_Wallets(marketingFeeReceiver, buybackFeeReceiver);
513     }
514 
515     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
516         require(_amount >= 1 * 10**_decimals, "Amount is less than one token");
517         require(_amount < (_totalSupply/10), "Amount too high");
518 
519         swapEnabled = _enabled;
520         swapThreshold = _amount;
521 
522         emit config_SwapSettings(swapThreshold, swapEnabled);
523     }
524     
525     function getCirculatingSupply() public view returns (uint256) {
526         return (_totalSupply - balanceOf[DEAD] - balanceOf[ZERO]);
527     }
528 /*
529     function LPBurn(uint256 percent_base10000) public authorized returns (bool){
530         require(percent_base10000 <= 1000, "May not nuke more than 10% of tokens in LP");
531         require(block.timestamp > lastSync + 5 minutes, "Too soon");
532         require(burnEnabled,"Burns are disabled");
533 
534         uint256 lp_tokens = this.balanceOf(pair);
535         uint256 lp_burn = lp_tokens.mul(percent_base10000).div(10_000);
536 
537         if (lp_burn > 0){
538             _basicTransfer(pair,DEAD,lp_burn);
539             pairContract.sync();
540             return true;
541         }
542 
543         return false;
544     }   
545 */
546 
547 event AutoLiquify(uint256 amountBNB, uint256 amountTokens);
548 event UpdateFee(uint8 Buy, uint8 Sell, uint8 Transfer);
549 event Wallet_feeExempt(address Wallet, bool Status);
550 event Wallet_txExempt(address Wallet, bool Status);
551 event Wallet_holdingExempt(address Wallet, bool Status);
552 event Wallet_blacklist(address Wallet, bool Status);
553 
554 event BalanceClear(uint256 amount);
555 event clearToken(address TokenAddressCleared, uint256 Amount);
556 
557 event Set_Wallets(address MarketingWallet, address buybackWallet);
558 
559 event config_MaxWallet(uint256 maxWallet);
560 event config_MaxTransaction(uint256 maxWallet);
561 event config_TradingStatus(bool Status);
562 event config_LaunchMode(bool Status);
563 event config_BlacklistMode(bool Status);
564 event config_SwapSettings(uint256 Amount, bool Enabled);
565 
566 }