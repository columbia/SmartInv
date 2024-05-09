1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.20;
4 
5 library Address {
6     function isContract(address account) internal view returns (bool) {
7         return account.code.length > 0;
8     }
9     function sendValue(address payable recipient, uint256 amount) internal {
10         require(address(this).balance >= amount, "Address: insufficient balance");
11 
12         (bool success, ) = recipient.call{value: amount}("");
13         require(success, "Address: unable to send value, recipient may have reverted");
14     }
15     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
16         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
17     }
18     function functionCall(
19         address target,
20         bytes memory data,
21         string memory errorMessage
22     ) internal returns (bytes memory) {
23         return functionCallWithValue(target, data, 0, errorMessage);
24     }
25     function functionCallWithValue(
26         address target,
27         bytes memory data,
28         uint256 value
29     ) internal returns (bytes memory) {
30         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
31     }
32     function functionCallWithValue(
33         address target,
34         bytes memory data,
35         uint256 value,
36         string memory errorMessage
37     ) internal returns (bytes memory) {
38         require(address(this).balance >= value, "Address: insufficient balance for call");
39         (bool success, bytes memory returndata) = target.call{value: value}(data);
40         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
41     }
42     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
43         return functionStaticCall(target, data, "Address: low-level static call failed");
44     }
45     function functionStaticCall(
46         address target,
47         bytes memory data,
48         string memory errorMessage
49     ) internal view returns (bytes memory) {
50         (bool success, bytes memory returndata) = target.staticcall(data);
51         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
52     }
53     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
54         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
55     }
56     function functionDelegateCall(
57         address target,
58         bytes memory data,
59         string memory errorMessage
60     ) internal returns (bytes memory) {
61         (bool success, bytes memory returndata) = target.delegatecall(data);
62         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
63     }
64     function verifyCallResultFromTarget(
65         address target,
66         bool success,
67         bytes memory returndata,
68         string memory errorMessage
69     ) internal view returns (bytes memory) {
70         if (success) {
71             if (returndata.length == 0) {
72                 // only check isContract if the call was successful and the return data is empty
73                 // otherwise we already know that it was a contract
74                 require(isContract(target), "Address: call to non-contract");
75             }
76             return returndata;
77         } else {
78             _revert(returndata, errorMessage);
79         }
80     }
81     function verifyCallResult(
82         bool success,
83         bytes memory returndata,
84         string memory errorMessage
85     ) internal pure returns (bytes memory) {
86         if (success) {
87             return returndata;
88         } else {
89             _revert(returndata, errorMessage);
90         }
91     }
92     function _revert(bytes memory returndata, string memory errorMessage) private pure {
93         // Look for revert reason and bubble it up if present
94         if (returndata.length > 0) {
95             // The easiest way to bubble the revert reason is using memory via assembly
96             /// @solidity memory-safe-assembly
97             assembly {
98                 let returndata_size := mload(returndata)
99                 revert(add(32, returndata), returndata_size)
100             }
101         } else {
102             revert(errorMessage);
103         }
104     }
105 }
106 
107 abstract contract Context {
108     function _msgSender() internal view virtual returns (address) {
109         return msg.sender;
110     }
111     function _msgData() internal view virtual returns (bytes calldata) {
112         return msg.data;
113     }
114 }
115 
116 interface IERC20 {
117     function totalSupply() external view returns (uint256);
118     function balanceOf(address account) external view returns (uint256);
119     function transfer(address recipient, uint256 amount) external returns (bool);
120     function allowance(address owner, address spender) external view returns (uint256);
121     function approve(address spender, uint256 amount) external returns (bool);
122     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
123     event Transfer(address indexed from, address indexed to, uint256 value);
124     event Approval(address indexed owner, address indexed spender, uint256 value);
125 }
126 
127 interface IDEXFactory {
128     function createPair(address tokenA, address tokenB) external returns (address pair);
129 }
130 
131 interface IDEXRouter {
132     function factory() external pure returns (address);
133     function WETH() external pure returns (address);
134 
135     function addLiquidityETH(
136         address token,
137         uint amountTokenDesired,
138         uint amountTokenMin,
139         uint amountETHMin,
140         address to,
141         uint deadline
142     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
143 
144     function swapExactTokensForETHSupportingFeeOnTransferTokens(
145         uint amountIn,
146         uint amountOutMin,
147         address[] calldata path,
148         address to,
149         uint deadline
150     ) external;
151 }
152 
153 abstract contract Ownable is Context {
154     address private _owner;
155 
156     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
157 
158     constructor() {
159         _transferOwnership(_msgSender());
160     }
161     modifier onlyOwner() {
162         _checkOwner();
163         _;
164     }
165     function owner() public view virtual returns (address) {
166         return _owner;
167     }
168     function _checkOwner() internal view virtual {
169         require(owner() == _msgSender(), "Ownable: caller is not the owner");
170     }
171     function renounceOwnership() public virtual onlyOwner {
172         _transferOwnership(address(0));
173     }
174     function transferOwnership(address newOwner) public virtual onlyOwner {
175         require(newOwner != address(0), "Ownable: new owner is the zero address");
176         _transferOwnership(newOwner);
177     }
178     function _transferOwnership(address newOwner) internal virtual {
179         address oldOwner = _owner;
180         _owner = newOwner;
181         emit OwnershipTransferred(oldOwner, newOwner);
182     }
183 }
184 
185 contract Timmy is IERC20, Ownable {
186     using Address for address;
187 
188     address DEAD = 0x000000000000000000000000000000000000dEaD;
189     address ZERO = 0x0000000000000000000000000000000000000000;
190 
191     string constant _name = "TIMMY";
192     string constant _symbol = "TIMMY";
193     uint8 constant _decimals = 18;
194 
195     uint256 _totalSupply = 690000000000 * (10 ** _decimals);
196     uint256 _maxBuyTxAmount = _totalSupply;
197     uint256 _maxSellTxAmount = _totalSupply;
198     uint256 _maxWalletSize = _totalSupply;
199 
200     mapping (address => uint256) _balances;
201     mapping (address => mapping (address => uint256)) _allowances;
202 
203     mapping (address => bool) public isFeeExempt;
204     mapping (address => bool) public isTxLimitExempt;
205     mapping (address => bool) public liquidityCreator;
206 
207     uint256 marketingFee = 0;
208     uint256 marketingSellFee = 0;
209     uint256 totalBuyFee = marketingFee;
210     uint256 totalSellFee = marketingSellFee;
211     uint256 feeDenominator = 10000;
212     bool public transferTax = false;
213 
214     address payable private marketingFeeReceiver;
215 
216     IDEXRouter public router;
217     address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
218     mapping (address => bool) liquidityPools;
219 
220     address public pair;
221 
222     uint256 public launchedAt;
223     uint256 public launchedTime;
224     bool startBullRun = false;
225     bool pauseDisabled = false;
226 
227     bool public swapEnabled = false;
228     uint256 public swapThreshold = _totalSupply / 1000;
229     uint256 public swapMinimum = _totalSupply / 10000;
230     bool inSwap;
231     modifier swapping() { inSwap = true; _; inSwap = false; }
232 
233     mapping (address => bool) teamMember;
234 
235     modifier onlyTeam() {
236         require(teamMember[_msgSender()] || msg.sender == owner(), "Caller is not a team member");
237         _;
238     }
239 
240     constructor (address _marketingWallet) {
241         router = IDEXRouter(routerAddress);
242         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
243         liquidityPools[pair] = true;
244         _allowances[owner()][routerAddress] = type(uint256).max;
245         _allowances[address(this)][routerAddress] = type(uint256).max;
246 
247         isFeeExempt[owner()] = true;
248         liquidityCreator[owner()] = true;
249 
250         marketingFeeReceiver = payable(_marketingWallet);
251 
252         isTxLimitExempt[address(this)] = true;
253         isTxLimitExempt[owner()] = true;
254         isTxLimitExempt[routerAddress] = true;
255         isTxLimitExempt[DEAD] = true;
256 
257         _balances[owner()] = _totalSupply;
258 
259         emit Transfer(address(0), owner(), _totalSupply);
260     }
261 
262     receive() external payable { }
263 
264     function totalSupply() external view override returns (uint256) { return _totalSupply; }
265     function decimals() external pure returns (uint8) { return _decimals; }
266     function symbol() external pure returns (string memory) { return _symbol; }
267     function name() external pure returns (string memory) { return _name; }
268     function getOwner() external view returns (address) { return owner(); }
269     function maxBuyTxTokens() external view returns (uint256) { return _maxBuyTxAmount / (10 ** _decimals); }
270     function maxSellTxTokens() external view returns (uint256) { return _maxSellTxAmount / (10 ** _decimals); }
271     function maxWalletTokens() external view returns (uint256) { return _maxWalletSize / (10 ** _decimals); }
272     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
273     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
274 
275     function approve(address spender, uint256 amount) public override returns (bool) {
276         _allowances[msg.sender][spender] = amount;
277         emit Approval(msg.sender, spender, amount);
278         return true;
279     }
280 
281     function approveMax(address spender) external returns (bool) {
282         return approve(spender, type(uint256).max);
283     }
284 
285     function setTeamMember(address _team, bool _enabled) external onlyOwner {
286         teamMember[_team] = _enabled;
287     }
288 
289     function airdrop(address[] calldata addresses, uint256[] calldata amounts) external onlyOwner {
290         require(addresses.length > 0 && amounts.length == addresses.length);
291         address from = msg.sender;
292 
293         for (uint i = 0; i < addresses.length; i++) {
294             if(!liquidityPools[addresses[i]] && !liquidityCreator[addresses[i]]) {
295                 _basicTransfer(from, addresses[i], amounts[i] * (10 ** _decimals));
296             }
297         }
298     }
299 
300     function clearStuckBalance(uint256 amountPercentage, address adr) external onlyTeam {
301         uint256 amountETH = address(this).balance;
302 
303         if(amountETH > 0) {
304             (bool sent, ) = adr.call{value: (amountETH * amountPercentage) / 100}("");
305             require(sent,"Failed to transfer funds");
306         }
307     }
308 
309     function manualswap(uint256 amount) external {
310         require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
311 
312           address[] memory path = new address[](2);
313         path[0] = address(this);
314         path[1] = router.WETH();
315 
316         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
317             amount,
318             0,
319             path,
320             address(this),
321             block.timestamp
322         );
323     }
324 
325     function manualsend() external {
326         bool success;
327         (success, ) = address(marketingFeeReceiver).call{
328             value: address(this).balance
329         }("");
330     }
331 
332     function openTrading() external onlyTeam {
333         require(!startBullRun);
334         startBullRun = true;
335         marketingFee = 9800;
336         marketingSellFee = 9800;
337         totalBuyFee = marketingFee;
338         totalSellFee = marketingSellFee;
339 
340         launchedAt = block.number;
341         launchedTime = block.timestamp;
342     }
343 
344     function transfer(address recipient, uint256 amount) external override returns (bool) {
345         return _transferFrom(msg.sender, recipient, amount);
346     }
347 
348     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
349         if(_allowances[sender][msg.sender] != type(uint256).max){
350             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
351         }
352 
353         return _transferFrom(sender, recipient, amount);
354     }
355 
356     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
357         require(sender != address(0), "ERC20: transfer from 0x0");
358         require(recipient != address(0), "ERC20: transfer to 0x0");
359         require(amount > 0, "Amount must be > zero");
360         require(_balances[sender] >= amount, "Insufficient balance");
361         if(!launched() && liquidityPools[recipient]){ require(liquidityCreator[sender], "Liquidity not added yet."); }
362         if(!startBullRun){ require(liquidityCreator[sender] || liquidityCreator[recipient], "Trading not open yet."); }
363 
364         checkTxLimit(sender, recipient, amount);
365 
366         if (!liquidityPools[recipient] && recipient != DEAD) {
367             if (!isTxLimitExempt[recipient]) {
368                 checkWalletLimit(recipient, amount);
369             }
370         }
371 
372         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
373 
374         _balances[sender] = _balances[sender] - amount;
375 
376         uint256 amountReceived = amount;
377 
378         if(shouldTakeFee(sender, recipient)) {
379             amountReceived = takeFee(recipient, amount);
380             if(shouldSwapBack(recipient) && amount > 0) swapBack(amount);
381         }
382 
383         _balances[recipient] = _balances[recipient] + amountReceived;
384 
385         emit Transfer(sender, recipient, amountReceived);
386         return true;
387     }
388 
389     function launched() internal view returns (bool) {
390         return launchedAt != 0;
391     }
392 
393     function launch() external onlyTeam {
394         launchedAt = block.number;
395         launchedTime = block.timestamp;
396         swapEnabled = true;
397 
398         marketingFee = 1000;
399         marketingSellFee = 9900;
400         totalBuyFee = marketingFee;
401         totalSellFee = marketingSellFee;
402 
403         _maxBuyTxAmount =   13800000000  * 1e18;
404         _maxWalletSize =   13800000000  * 1e18;
405     }
406 
407     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
408         _balances[sender] = _balances[sender] - amount;
409         _balances[recipient] = _balances[recipient] + amount;
410         emit Transfer(sender, recipient, amount);
411         return true;
412     }
413 
414     function checkWalletLimit(address recipient, uint256 amount) internal view {
415         uint256 walletLimit = _maxWalletSize;
416         require(_balances[recipient] + amount <= walletLimit, "Transfer amount exceeds the bag size.");
417     }
418 
419     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
420         if (isTxLimitExempt[sender] || isTxLimitExempt[recipient]) return;
421         require(amount <= (liquidityPools[sender] ? _maxBuyTxAmount : _maxSellTxAmount), "TX Limit Exceeded");
422 
423     }
424 
425     function shouldTakeFee(address sender, address recipient) public view returns (bool) {
426         if(!transferTax && !liquidityPools[recipient] && !liquidityPools[sender]) return false;
427         return !isFeeExempt[sender] && !isFeeExempt[recipient];
428     }
429 
430     function getTotalFee(bool selling) public view returns (uint256) {
431         if (selling) return totalSellFee;
432         return totalBuyFee;
433     }
434 
435     function takeFee(address recipient, uint256 amount) internal returns (uint256) {
436         bool selling = liquidityPools[recipient];
437         uint256 feeAmount = (amount * getTotalFee(selling)) / feeDenominator;
438 
439         _balances[address(this)] += feeAmount;
440 
441         return amount - feeAmount;
442     }
443 
444     function shouldSwapBack(address recipient) internal view returns (bool) {
445         return !liquidityPools[msg.sender]
446         && !inSwap
447         && swapEnabled
448         && liquidityPools[recipient]
449         && _balances[address(this)] >= swapMinimum
450         && totalBuyFee + totalSellFee > 0;
451     }
452 
453     function swapBack(uint256 amount) internal swapping {
454         uint256 amountToSwap = amount < swapThreshold ? amount : swapThreshold;
455         if (_balances[address(this)] < amountToSwap) amountToSwap = _balances[address(this)];
456 
457         address[] memory path = new address[](2);
458         path[0] = address(this);
459         path[1] = router.WETH();
460 
461         uint256 balanceBefore = address(this).balance;
462 
463         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
464             amountToSwap,
465             0,
466             path,
467             address(this),
468             block.timestamp
469         );
470 
471         uint256 amountETH = address(this).balance - balanceBefore;
472 
473         uint256 amountETHMarketing = amountETH;
474 
475         if (amountETHMarketing > 0) {
476             (bool sentMarketing, ) = marketingFeeReceiver.call{value: amountETHMarketing}("");
477             if(!sentMarketing) {
478                 //Failed to transfer to marketing wallet
479             }
480         }
481 
482         emit FundsDistributed(amountETHMarketing);
483     }
484 
485     function addLiquidityPool(address lp, bool isPool) external onlyOwner {
486         require(lp != pair, "Can't alter current liquidity pair");
487         liquidityPools[lp] = isPool;
488     }
489 
490 
491     function setTxLimit(uint256 buyNumerator, uint256 sellNumerator, uint256 divisor) external onlyOwner {
492        require(buyNumerator > 0 && sellNumerator > 0 && divisor > 0 && divisor <= 10000);
493        _maxBuyTxAmount = (_totalSupply * buyNumerator) / divisor;
494        _maxSellTxAmount = (_totalSupply * sellNumerator) / divisor;
495    }
496 
497     function setMaxWallet(uint256 numerator, uint256 divisor) external onlyOwner() {
498         require(numerator > 0 && divisor > 0 && divisor <= 10000);
499         _maxWalletSize = (_totalSupply * numerator) / divisor;
500     }
501 
502     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
503         isFeeExempt[holder] = exempt;
504     }
505 
506     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
507         isTxLimitExempt[holder] = exempt;
508     }
509 
510     function setFees(uint256 _marketingFee, uint256 _marketingSellFee, uint256 _feeDenominator) external onlyOwner {
511         marketingFee = _marketingFee;
512         marketingSellFee = _marketingSellFee;
513         totalBuyFee = _marketingFee;
514         totalSellFee = _marketingSellFee;
515         feeDenominator = _feeDenominator;
516         require(totalBuyFee <= feeDenominator, "Fees too high");
517         emit FeesSet(totalBuyFee, totalSellFee, feeDenominator);
518     }
519 
520     function toggleTransferTax() external onlyOwner {
521         transferTax = !transferTax;
522     }
523 
524     function setFeeReceivers(address _marketingFeeReceiver) external onlyOwner {
525         marketingFeeReceiver = payable(_marketingFeeReceiver);
526     }
527 
528     function setSwapBackSettings(bool _enabled, uint256 _denominator, uint256 _swapMinimum) external onlyOwner {
529         require(_denominator > 0);
530         swapEnabled = _enabled;
531         swapThreshold = _totalSupply / _denominator;
532         swapMinimum = _swapMinimum * (10 ** _decimals);
533     }
534 
535     function getCirculatingSupply() public view returns (uint256) {
536         return _totalSupply - (balanceOf(DEAD) + balanceOf(ZERO));
537     }
538 
539     event FundsDistributed(uint256 marketingETH);
540     event FeesSet(uint256 totalBuyFees, uint256 totalSellFees, uint256 denominator);
541 }