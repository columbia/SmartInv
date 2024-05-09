1 /*
2 Ghostface Shiba $GFSHIB
3 Telegram: https://t.me/ghostfaceshiba
4 Website: https://ghostfaceshiba.com/
5 Twitter: https://twitter.com/GhostFaceShiba
6 
7                               ┌▄▄              ,▄▄
8                               ╟███▓▄╓∞═^*══w▄█▓██▓
9                               ╟▓▓▀⌠╓▄▄█████▄╗¿▀▓▓▓
10                              ╒█╜╓▓████████████▓╗"▀▄
11                             ▄▌ ╬▓███╜ ╙██▌""▓██▓▓,╙█,
12                            ▀▀ ╬▓▓▓▓"   ▓█    ▓▓▓▓╣ ▐▓▄
13                           ██▌ ╢▒█▀     ██µ    ╙██▒[ ▄▄▄
14                          ▓▓▓▌ ╢▀█▄▄▄▄██▄▄██▄▄▄▄██▒`▐▓▓▓
15                   ▄████▄  ███▄ ║▒╢▓▓▓▓▓▀╙▀▓▓▓▓╣╣╣"╓███▀
16                   ▀██▀██   ▀███▄ ╜╢╢╢▓▓▄ ▓▓╢╣▒╝╙,▄███└
17                ,  "██▓▓▓▄    ▀███▄▄,`╙╙╜╜╜╙",▄▄███▀▀
18              ▄██▄  ▓▓▓▓▓▓▄▄▄▄█▄▄▀▀████████████▀▀╓▄█▓▓▓▓█▄
19            ▄███▀    ▓▓▓▓▓▓▓▓▓▓▓▓▓██████████████▓▓▓▓▓▓▓▓▓▓█
20          ▄██▀└       "▓▓▓▓▓▓▀╓▓▓████████████████▓▓▄▀▀▓▓▓▓▓▓
21        ▄█▀▀              ╙╙",▓▓██████████████████▓▓   ▓▓▓▓▓█
22       └                     █▓▓██████████████████▌▓█  ▐█████
23                             ▓▓▓██████████████████▌▓▓   █████
24                            ▐▓▓▓██████████████████╣▓▓
25                            ▐▓▓▓▓▓███████████████╣▓▓▓          █,
26                            ]▓▓▓▓▓▓▓▓▓███████▓╣▓▓▓▓▓▌╒,     ,▄▓▓▓
27                             ▓▓▓▓▓▓▓▀▓▓▓▓▓▓▓▓▀▓▓▓▓▓▓ ▓▓▓███▓▓▓▓▓▓'
28                             ╘▓▓▓▓▓▓▓▓r,  ╒▄▓█▓▓▓▓▓▌ ▀▓▓▓▓▓▓▓▓▓▓"
29                               ▀▓▓▓▓▓\▄█  j▓▓▓▓▓▓▓▓     "╙▀▀╙'
30                                   ═▀▀▀    ██████▀
31                                            '└└¬
32  
33 */
34 // SPDX-License-Identifier: Unlicensed
35 
36 pragma solidity ^0.8.7;
37 
38 library Address {
39     /**
40      * C U ON THE MOON
41      */
42     function isContract(address account) internal view returns (bool) {
43         bytes32 codehash;
44         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
45         assembly { codehash := extcodehash(account) }
46         return (codehash != accountHash && codehash != 0x0);
47     }
48     function sendValue(address payable recipient, uint256 amount) internal {
49         require(address(this).balance >= amount, "Address: insufficient balance");
50 
51         (bool success, ) = recipient.call{ value: amount }("");
52         require(success, "Address: unable to send value, recipient may have reverted");
53     }
54     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
55       return functionCall(target, data, "Address: low-level call failed");
56     }
57     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
58         return _functionCallWithValue(target, data, 0, errorMessage);
59     }
60     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
61         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
62     }
63     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
64         require(address(this).balance >= value, "Address: insufficient balance for call");
65         return _functionCallWithValue(target, data, value, errorMessage);
66     }
67 
68     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
69         require(isContract(target), "Address: call to non-contract");
70         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
71         if (success) {
72             return returndata;
73         } else {
74             if (returndata.length > 0) {
75                 assembly {
76                     let returndata_size := mload(returndata)
77                     revert(add(32, returndata), returndata_size)
78                 }
79             } else {
80                 revert(errorMessage);
81             }
82         }
83     }
84 }
85 abstract contract Context {
86     function _msgSender() internal view returns (address payable) {
87         return payable(msg.sender);
88     }
89 
90     function _msgData() internal view returns (bytes memory) {
91         this;
92         return msg.data;
93     }
94 }
95 
96 interface IERC20 {
97     function totalSupply() external view returns (uint256);
98     function balanceOf(address account) external view returns (uint256);
99     function transfer(address recipient, uint256 amount) external returns (bool);
100     function allowance(address owner, address spender) external view returns (uint256);
101     function approve(address spender, uint256 amount) external returns (bool);
102     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
103     event Transfer(address indexed from, address indexed to, uint256 value);
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 interface IDEXFactory {
108     function createPair(address tokenA, address tokenB) external returns (address pair);
109 }
110 
111 interface IDEXRouter {
112     function factory() external pure returns (address);
113     function WETH() external pure returns (address);
114 
115     function addLiquidityETH(
116         address token,
117         uint amountTokenDesired,
118         uint amountTokenMin,
119         uint amountETHMin,
120         address to,
121         uint deadline
122     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
123 
124     function swapExactTokensForETHSupportingFeeOnTransferTokens(
125         uint amountIn,
126         uint amountOutMin,
127         address[] calldata path,
128         address to,
129         uint deadline
130     ) external;
131 }
132 
133 contract Ownable is Context {
134     address private _owner;
135 
136     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
137     constructor () {
138         address msgSender = _msgSender();
139         _owner = msgSender;
140         emit OwnershipTransferred(address(0), msgSender);
141     }
142     function owner() public view returns (address) {
143         return _owner;
144     }
145     modifier onlyOwner() {
146         require(_owner == _msgSender(), "Ownable: caller is not the owner");
147         _;
148     }
149     function renounceOwnership() public virtual onlyOwner {
150         emit OwnershipTransferred(_owner, address(0));
151         _owner = address(0);
152     }
153     function transferOwnership(address newOwner) public virtual onlyOwner {
154         require(newOwner != address(0), "Ownable: new owner is the zero address");
155         emit OwnershipTransferred(_owner, newOwner);
156         _owner = newOwner;
157     }
158 }
159 
160 contract GhostfaceShiba is IERC20, Ownable {
161     using Address for address;
162     
163     address DEAD = 0x000000000000000000000000000000000000dEaD;
164     address ZERO = 0x0000000000000000000000000000000000000000;
165 
166     string constant _name = "Ghostface Shiba";
167     string constant _symbol = "GFSHIB";
168     uint8 constant _decimals = 9;
169 
170     uint256 _totalSupply = 1_000_000_000 * (10 ** _decimals);
171     uint256 _maxBuyTxAmount = (_totalSupply * 1) / 2000;
172     uint256 _maxSellTxAmount = (_totalSupply * 1) / 500;
173     uint256 _maxWalletSize = (_totalSupply * 2) / 100;
174 
175     mapping (address => uint256) _balances;
176     mapping (address => mapping (address => uint256)) _allowances;
177     mapping (address => uint256) public lastSell;
178     mapping (address => uint256) public lastBuy;
179 
180     mapping (address => bool) isFeeExempt;
181     mapping (address => bool) isTxLimitExempt;
182     mapping (address => bool) liquidityCreator;
183 
184     uint256 marketingFee = 800;
185     uint256 liquidityFee = 200;
186     uint256 totalFee = marketingFee + liquidityFee;
187     uint256 sellBias = 0;
188     uint256 feeDenominator = 10000;
189 
190     address payable public liquidityFeeReceiver = payable(0x03A7C3c57B1366DdE691F0F2c8c4F113Bc0eEAE3);
191     address payable public marketingFeeReceiver = payable(0x03A7C3c57B1366DdE691F0F2c8c4F113Bc0eEAE3);
192 
193     IDEXRouter public router;
194     address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
195     mapping (address => bool) liquidityPools;
196     mapping (address => uint256) public protected;
197     bool protectionEnabled = true;
198     bool protectionDisabled = false;
199     uint256 protectionLimit;
200     uint256 public protectionCount;
201     uint256 protectionTimer;
202 
203     address public pair;
204 
205     uint256 public launchedAt;
206     uint256 public launchedTime;
207     uint256 public deadBlocks;
208     bool startBullRun = false;
209     bool pauseDisabled = false;
210     uint256 public rateLimit = 2;
211 
212     bool public swapEnabled = false;
213     bool processEnabled = true;
214     uint256 public swapThreshold = _totalSupply / 1000;
215     uint256 public swapMinimum = _totalSupply / 10000;
216     bool inSwap;
217     modifier swapping() { inSwap = true; _; inSwap = false; }
218     
219     mapping (address => bool) teamMember;
220     
221     modifier onlyTeam() {
222         require(teamMember[_msgSender()] || msg.sender == owner(), "Caller is not a team member");
223         _;
224     }
225     
226     event ProtectedWallet(address, address, uint256, uint8);
227 
228     constructor () {
229         router = IDEXRouter(routerAddress);
230         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
231         liquidityPools[pair] = true;
232         _allowances[owner()][routerAddress] = type(uint256).max;
233         _allowances[address(this)][routerAddress] = type(uint256).max;
234 
235         isFeeExempt[owner()] = true;
236         liquidityCreator[owner()] = true;
237 
238         isTxLimitExempt[address(this)] = true;
239         isTxLimitExempt[owner()] = true;
240         isTxLimitExempt[routerAddress] = true;
241         isTxLimitExempt[DEAD] = true;
242 
243         _balances[owner()] = _totalSupply;
244 
245         emit Transfer(address(0), owner(), _totalSupply);
246     }
247 
248     receive() external payable { }
249 
250     function totalSupply() external view override returns (uint256) { return _totalSupply; }
251     function decimals() external pure returns (uint8) { return _decimals; }
252     function symbol() external pure returns (string memory) { return _symbol; }
253     function name() external pure returns (string memory) { return _name; }
254     function getOwner() external view returns (address) { return owner(); }
255     function maxBuyTxTokens() external view returns (uint256) { return _maxBuyTxAmount / (10 ** _decimals); }
256     function maxSellTxTokens() external view returns (uint256) { return _maxSellTxAmount / (10 ** _decimals); }
257     function maxWalletTokens() external view returns (uint256) { return _maxWalletSize / (10 ** _decimals); }
258     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
259     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
260 
261     function approve(address spender, uint256 amount) public override returns (bool) {
262         _allowances[msg.sender][spender] = amount;
263         emit Approval(msg.sender, spender, amount);
264         return true;
265     }
266 
267     function approveMax(address spender) external returns (bool) {
268         return approve(spender, type(uint256).max);
269     }
270     
271     function setTeamMember(address _team, bool _enabled) external onlyOwner {
272         teamMember[_team] = _enabled;
273     }
274     
275     function airdrop(address[] calldata addresses, uint256[] calldata amounts) external onlyOwner {
276         require(addresses.length > 0 && amounts.length == addresses.length);
277         address from = msg.sender;
278 
279         for (uint i = 0; i < addresses.length; i++) {
280             if(!liquidityPools[addresses[i]] && !liquidityCreator[addresses[i]]) {
281                 _basicTransfer(from, addresses[i], amounts[i] * (10 ** _decimals));
282             }
283         }
284     }
285     
286     function clearStuckBalance(uint256 amountPercentage, address adr) external onlyTeam {
287         uint256 amountETH = address(this).balance;
288         payable(adr).transfer((amountETH * amountPercentage) / 100);
289     }
290     
291     function openTrading(uint256 _deadBlocks, uint256 _protection, uint256 _limit) external onlyTeam {
292         require(!startBullRun && _deadBlocks < 10);
293         deadBlocks = _deadBlocks;
294         startBullRun = true;
295         launchedAt = block.number;
296         protectionTimer = block.timestamp + _protection;
297         protectionLimit = _limit * (10 ** _decimals);
298     }
299     
300     function pauseTrading() external onlyTeam {
301         require(!pauseDisabled);
302         startBullRun = false;
303     }
304     
305     function disablePause() external onlyTeam {
306         pauseDisabled = true;
307         startBullRun = true;
308     }
309     
310     function setProtection(bool _protect, uint256 _addTime) external onlyTeam {
311         require(!protectionDisabled);
312         protectionEnabled = _protect;
313         require(_addTime < 1 days);
314         protectionTimer += _addTime;
315     }
316     
317     function disableProtection() external onlyTeam {
318         protectionDisabled = true;
319         protectionEnabled = false;
320     }
321     
322     function protectWallet(address[] calldata _wallets, bool _protect) external onlyTeam {
323         if (_protect) {
324             require(protectionEnabled);
325         }
326         
327         for (uint i = 0; i < _wallets.length; i++) {
328             
329             if (_protect) {
330                 protectionCount++;
331                 emit ProtectedWallet(tx.origin, _wallets[i], block.number, 2);
332             }
333             else {
334                 if (protected[_wallets[i]] != 0)
335                     protectionCount--;      
336             }
337             protected[_wallets[i]] = _protect ? block.number : 0;
338         }
339     }
340 
341     function transfer(address recipient, uint256 amount) external override returns (bool) {
342         return _transferFrom(msg.sender, recipient, amount);
343     }
344 
345     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
346         if(_allowances[sender][msg.sender] != type(uint256).max){
347             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
348         }
349 
350         return _transferFrom(sender, recipient, amount);
351     }
352 
353     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
354         require(sender != address(0), "BEP20: transfer from 0x0");
355         require(recipient != address(0), "BEP20: transfer to 0x0");
356         require(amount > 0, "Amount must be > zero");
357         require(_balances[sender] >= amount, "Insufficient balance");
358         if(!launched() && liquidityPools[recipient]){ require(liquidityCreator[sender], "Liquidity not added yet."); launch(); }
359         if(!startBullRun){ require(liquidityCreator[sender] || liquidityCreator[recipient], "Trading not open yet."); }
360 
361         checkTxLimit(sender, recipient, amount);
362         
363         if (!liquidityPools[recipient] && recipient != DEAD) {
364             if (!isTxLimitExempt[recipient]) {
365                 checkWalletLimit(recipient, amount);
366             }
367         }
368         
369         if(protectionEnabled && protectionTimer > block.timestamp) {
370             if(liquidityPools[sender] && tx.origin != recipient && protected[recipient] == 0) {
371                 protected[recipient] = block.number;
372                 protectionCount++;
373                 emit ProtectedWallet(tx.origin, recipient, block.number, 0);
374             }
375         }
376         
377         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
378 
379         _balances[sender] = _balances[sender] - amount;
380 
381         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(recipient, amount) : amount;
382         
383         if(shouldSwapBack(recipient)){ if (amount > 0) swapBack(amount); }
384         
385         _balances[recipient] = _balances[recipient] + amountReceived;
386 
387         emit Transfer(sender, recipient, amountReceived);
388         return true;
389     }
390     
391     function launched() internal view returns (bool) {
392         return launchedAt != 0;
393     }
394 
395     function launch() internal {
396         launchedAt = block.number;
397         launchedTime = block.timestamp;
398         swapEnabled = true;
399     }
400 
401     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
402         _balances[sender] = _balances[sender] - amount;
403         _balances[recipient] = _balances[recipient] + amount;
404         emit Transfer(sender, recipient, amount);
405         return true;
406     }
407     
408     function checkWalletLimit(address recipient, uint256 amount) internal view {
409         uint256 walletLimit = _maxWalletSize;
410         require(_balances[recipient] + amount <= walletLimit, "Transfer amount exceeds the bag size.");
411     }
412 
413     function checkTxLimit(address sender, address recipient, uint256 amount) internal {
414         require(isTxLimitExempt[sender] || amount <= (liquidityPools[sender] ? _maxBuyTxAmount : _maxSellTxAmount), "TX Limit Exceeded");
415         require(isTxLimitExempt[sender] || lastBuy[recipient] + rateLimit <= block.number, "Transfer rate limit exceeded.");
416         
417         if (protected[sender] != 0){
418             require(amount <= protectionLimit * (10 ** _decimals) && lastSell[sender] == 0 && protectionTimer > block.timestamp, "Wallet protected, please contact support.");
419             lastSell[sender] = block.number;
420         }
421         
422         if (liquidityPools[recipient]) {
423             lastSell[sender] = block.number;
424         } else if (shouldTakeFee(sender)) {
425             if (protectionEnabled && protectionTimer > block.timestamp && lastBuy[tx.origin] == block.number && protected[recipient] == 0) {
426                 protected[recipient] = block.number;
427                 emit ProtectedWallet(tx.origin, recipient, block.number, 1);
428             }
429             lastBuy[recipient] = block.number;
430             if (tx.origin != recipient)
431                 lastBuy[tx.origin] = block.number;
432         }
433     }
434 
435     function shouldTakeFee(address sender) internal view returns (bool) {
436         return !isFeeExempt[sender];
437     }
438 
439     function getTotalFee(bool selling) public view returns (uint256) {
440         if(launchedAt + deadBlocks >= block.number){ return feeDenominator - 1; }
441         if (selling) return totalFee + sellBias;
442         return totalFee - sellBias;
443     }
444 
445     function takeFee(address recipient, uint256 amount) internal returns (uint256) {
446         bool selling = liquidityPools[recipient];
447         uint256 feeAmount = (amount * getTotalFee(selling)) / feeDenominator;
448         
449         _balances[address(this)] += feeAmount;
450     
451         return amount - feeAmount;
452     }
453 
454     function shouldSwapBack(address recipient) internal view returns (bool) {
455         return !liquidityPools[msg.sender]
456         && !inSwap
457         && swapEnabled
458         && liquidityPools[recipient]
459         && _balances[address(this)] >= swapMinimum;
460     }
461 
462     function swapBack(uint256 amount) internal swapping {
463         uint256 amountToSwap = amount < swapThreshold ? amount : swapThreshold;
464         if (_balances[address(this)] < amountToSwap) amountToSwap = _balances[address(this)];
465         
466         uint256 amountToLiquify = (amountToSwap * liquidityFee / 2) / totalFee;
467         amountToSwap -= amountToLiquify;
468 
469         address[] memory path = new address[](2);
470         path[0] = address(this);
471         path[1] = router.WETH();
472         
473         uint256 balanceBefore = address(this).balance;
474 
475         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
476             amountToSwap,
477             0,
478             path,
479             address(this),
480             block.timestamp
481         );
482 
483         uint256 amountBNB = address(this).balance - balanceBefore;
484         uint256 totalBNBFee = totalFee - (liquidityFee / 2);
485 
486         uint256 amountBNBLiquidity = (amountBNB * liquidityFee / 2) / totalBNBFee;
487         uint256 amountBNBMarketing = amountBNB - amountBNBLiquidity;
488         
489         if (amountBNBMarketing > 0)
490             marketingFeeReceiver.transfer(amountBNBMarketing);
491         
492         if(amountToLiquify > 0){
493             router.addLiquidityETH{value: amountBNBLiquidity}(
494                 address(this),
495                 amountToLiquify,
496                 0,
497                 0,
498                 liquidityFeeReceiver,
499                 block.timestamp
500             );
501         }
502 
503         emit FundsDistributed(amountBNBMarketing, amountBNBLiquidity, amountToLiquify);
504     }
505     
506     function addLiquidityPool(address lp, bool isPool) external onlyOwner {
507         require(lp != pair, "Can't alter current liquidity pair");
508         liquidityPools[lp] = isPool;
509     }
510 
511     function setRateLimit(uint256 rate) external onlyOwner {
512         require(rate <= 60 seconds);
513         rateLimit = rate;
514     }
515 
516     function setTxLimit(uint256 buyNumerator, uint256 sellNumerator, uint256 divisor) external onlyOwner {
517         require(buyNumerator > 0 && sellNumerator > 0 && divisor > 0 && divisor <= 10000);
518         _maxBuyTxAmount = (_totalSupply * buyNumerator) / divisor;
519         _maxSellTxAmount = (_totalSupply * sellNumerator) / divisor;
520     }
521     
522     function setMaxWallet(uint256 numerator, uint256 divisor) external onlyOwner() {
523         require(numerator > 0 && divisor > 0 && divisor <= 10000);
524         _maxWalletSize = (_totalSupply * numerator) / divisor;
525     }
526 
527     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
528         isFeeExempt[holder] = exempt;
529     }
530 
531     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
532         isTxLimitExempt[holder] = exempt;
533     }
534 
535     function setFees(uint256 _liquidityFee, uint256 _marketingFee, uint256 _sellBias, uint256 _feeDenominator) external onlyOwner {
536         liquidityFee = _liquidityFee;
537         marketingFee = _marketingFee;
538         totalFee = _marketingFee + _liquidityFee;
539         sellBias = _sellBias;
540         feeDenominator = _feeDenominator;
541         require(totalFee < feeDenominator / 2);
542     }
543 
544     function setFeeReceivers(address _liquidityFeeReceiver, address _marketingFeeReceiver) external onlyOwner {
545         liquidityFeeReceiver = payable(_liquidityFeeReceiver);
546         marketingFeeReceiver = payable(_marketingFeeReceiver);
547     }
548 
549     function setSwapBackSettings(bool _enabled, bool _processEnabled, uint256 _denominator, uint256 _swapMinimum) external onlyOwner {
550         require(_denominator > 0);
551         swapEnabled = _enabled;
552         processEnabled = _processEnabled;
553         swapThreshold = _totalSupply / _denominator;
554         swapMinimum = _swapMinimum * (10 ** _decimals);
555     }
556 
557     function getCirculatingSupply() public view returns (uint256) {
558         return _totalSupply - (balanceOf(DEAD) + balanceOf(ZERO));
559     }
560 
561     event FundsDistributed(uint256 marketingBNB, uint256 liquidityBNB, uint256 liquidityTokens);
562     //C U ON THE MOON
563 }