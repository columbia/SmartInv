1 pragma solidity ^0.8.0;
2 
3 
4 interface IUniswapV2Router01 {
5     function factory() external pure returns (address);
6     function WETH() external pure returns (address);
7 
8     function addLiquidity(
9         address tokenA,
10         address tokenB,
11         uint amountADesired,
12         uint amountBDesired,
13         uint amountAMin,
14         uint amountBMin,
15         address to,
16         uint deadline
17     ) external returns (uint amountA, uint amountB, uint liquidity);
18     function addLiquidityETH(
19         address token,
20         uint amountTokenDesired,
21         uint amountTokenMin,
22         uint amountETHMin,
23         address to,
24         uint deadline
25     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
26     function removeLiquidity(
27         address tokenA,
28         address tokenB,
29         uint liquidity,
30         uint amountAMin,
31         uint amountBMin,
32         address to,
33         uint deadline
34     ) external returns (uint amountA, uint amountB);
35     function removeLiquidityETH(
36         address token,
37         uint liquidity,
38         uint amountTokenMin,
39         uint amountETHMin,
40         address to,
41         uint deadline
42     ) external returns (uint amountToken, uint amountETH);
43     function removeLiquidityWithPermit(
44         address tokenA,
45         address tokenB,
46         uint liquidity,
47         uint amountAMin,
48         uint amountBMin,
49         address to,
50         uint deadline,
51         bool approveMax, uint8 v, bytes32 r, bytes32 s
52     ) external returns (uint amountA, uint amountB);
53     function removeLiquidityETHWithPermit(
54         address token,
55         uint liquidity,
56         uint amountTokenMin,
57         uint amountETHMin,
58         address to,
59         uint deadline,
60         bool approveMax, uint8 v, bytes32 r, bytes32 s
61     ) external returns (uint amountToken, uint amountETH);
62     function swapExactTokensForTokens(
63         uint amountIn,
64         uint amountOutMin,
65         address[] calldata path,
66         address to,
67         uint deadline
68     ) external returns (uint[] memory amounts);
69     function swapTokensForExactTokens(
70         uint amountOut,
71         uint amountInMax,
72         address[] calldata path,
73         address to,
74         uint deadline
75     ) external returns (uint[] memory amounts);
76     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
77         external
78         payable
79         returns (uint[] memory amounts);
80     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
81         external
82         returns (uint[] memory amounts);
83     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
84         external
85         returns (uint[] memory amounts);
86     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
87         external
88         payable
89         returns (uint[] memory amounts);
90 
91     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
92     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
93     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
94     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
95     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
96 }
97 // SPDX-License-Identifier: MIT
98 
99 interface IUniswapV2Router02 is IUniswapV2Router01 {
100     function removeLiquidityETHSupportingFeeOnTransferTokens(
101         address token,
102         uint liquidity,
103         uint amountTokenMin,
104         uint amountETHMin,
105         address to,
106         uint deadline
107     ) external returns (uint amountETH);
108     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
109         address token,
110         uint liquidity,
111         uint amountTokenMin,
112         uint amountETHMin,
113         address to,
114         uint deadline,
115         bool approveMax, uint8 v, bytes32 r, bytes32 s
116     ) external returns (uint amountETH);
117 
118     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
119         uint amountIn,
120         uint amountOutMin,
121         address[] calldata path,
122         address to,
123         uint deadline
124     ) external;
125     function swapExactETHForTokensSupportingFeeOnTransferTokens(
126         uint amountOutMin,
127         address[] calldata path,
128         address to,
129         uint deadline
130     ) external payable;
131     function swapExactTokensForETHSupportingFeeOnTransferTokens(
132         uint amountIn,
133         uint amountOutMin,
134         address[] calldata path,
135         address to,
136         uint deadline
137     ) external;
138 }
139 
140 /**
141  * @dev Provides information about the current execution context, including the
142  * sender of the transaction and its data. While these are generally available
143  * via msg.sender and msg.data, they should not be accessed in such a direct
144  * manner, since when dealing with meta-transactions the account sending and
145  * paying for execution may not be the actual sender (as far as an application
146  * is concerned).
147  *
148  * This contract is only required for intermediate, library-like contracts.
149  */
150 abstract contract Context {
151     function _msgSender() internal view virtual returns (address) {
152         return msg.sender;
153     }
154 
155     function _msgData() internal view virtual returns (bytes calldata) {
156         return msg.data;
157     }
158 }
159 
160 
161 /**
162  * @dev Interface of the ERC20 standard as defined in the EIP.
163  */
164 interface IERC20 {
165     /**
166      * @dev Returns the amount of tokens in existence.
167      */
168     function totalSupply() external view returns (uint256);
169 
170     /**
171      * @dev Returns the amount of tokens owned by `account`.
172      */
173     function balanceOf(address account) external view returns (uint256);
174 
175     /**
176      * @dev Moves `amount` tokens from the caller's account to `recipient`.
177      *
178      * Returns a boolean value indicating whether the operation succeeded.
179      *
180      * Emits a {Transfer} event.
181      */
182     function transfer(address recipient, uint256 amount) external returns (bool);
183 
184     /**
185      * @dev Returns the remaining number of tokens that `spender` will be
186      * allowed to spend on behalf of `owner` through {transferFrom}. This is
187      * zero by default.
188      *
189      * This value changes when {approve} or {transferFrom} are called.
190      */
191     function allowance(address owner, address spender) external view returns (uint256);
192 
193     /**
194      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
195      *
196      * Returns a boolean value indicating whether the operation succeeded.
197      *
198      * IMPORTANT: Beware that changing an allowance with this method brings the risk
199      * that someone may use both the old and the new allowance by unfortunate
200      * transaction ordering. One possible solution to mitigate this race
201      * condition is to first reduce the spender's allowance to 0 and set the
202      * desired value afterwards:
203      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204      *
205      * Emits an {Approval} event.
206      */
207     function approve(address spender, uint256 amount) external returns (bool);
208 
209     /**
210      * @dev Moves `amount` tokens from `sender` to `recipient` using the
211      * allowance mechanism. `amount` is then deducted from the caller's
212      * allowance.
213      *
214      * Returns a boolean value indicating whether the operation succeeded.
215      *
216      * Emits a {Transfer} event.
217      */
218     function transferFrom(
219         address sender,
220         address recipient,
221         uint256 amount
222     ) external returns (bool);
223 
224     /**
225      * @dev Emitted when `value` tokens are moved from one account (`from`) to
226      * another (`to`).
227      *
228      * Note that `value` may be zero.
229      */
230     event Transfer(address indexed from, address indexed to, uint256 value);
231 
232     /**
233      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
234      * a call to {approve}. `value` is the new allowance.
235      */
236     event Approval(address indexed owner, address indexed spender, uint256 value);
237 }
238 
239 
240 contract WEAPON is Context, IERC20{
241 
242     uint256 private _txLimit;
243     uint256 private _limitTime;
244     
245     bool private _swapping;
246 
247     bool public tradingEnabled = false;
248     bool public stakingEnabled = false;
249 
250     mapping (address => bool) private _isPool;
251 
252     mapping (address => uint256) private _balances;
253     mapping (address => uint256) private _stakedBalances;
254     mapping (address => uint256) private _stakeExpireTime;
255     mapping (address => uint256) private _stakeBeginTime;
256     mapping (address => mapping (address => uint256)) private _allowances;
257 
258     uint256 private _totalSupply = 10 * 10**6 * 10**9; 
259 
260     string private _name = "Megaweapon";
261     string private _symbol = "$WEAPON";
262     uint8 private _decimals = 9;
263     uint8 private _buyTax = 10;
264     uint8 private _sellTax = 10;
265 
266     address private _lp;
267     address payable private _devWallet;
268     address payable private _stakingContract;
269     address private _uniRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
270     address private _pair = address(0);
271 
272     IUniswapV2Router02 private UniV2Router;
273 
274     constructor(address dev) {
275         _lp = _msgSender();
276         _balances[_lp] = _totalSupply;
277         UniV2Router = IUniswapV2Router02(_uniRouter);
278         _devWallet = payable(dev);
279     }
280 
281     event Stake(address indexed _staker, uint256 amount, uint256 stakeTime, uint256 stakeExpire);
282     event Reconcile(address indexed _staker, uint256 amount, bool isLoss);
283 
284 
285     modifier lockSwap {
286         _swapping = true;
287         _;
288         _swapping = false;
289     }
290 
291     function name() public view returns (string memory) {
292         return _name;
293     }
294 
295     function symbol() public view returns (string memory) {
296         return _symbol;
297     }
298 
299     function decimals() public view returns (uint8) {
300         return _decimals;
301     }
302 
303     function totalSupply() public view override returns (uint256) {
304         return _totalSupply;
305     }
306 
307     function balanceOf(address account) public view override returns (uint256) {
308         return availableBalanceOf(account);
309     }
310 
311     function stakedBalanceOf(address account) public view returns (uint256) {
312         if (stakingEnabled && _stakeExpireTime[account] > block.timestamp) {
313             return _stakedBalances[account];    
314         }
315         else return 0;        
316     }
317 
318     function availableBalanceOf(address account) public view returns (uint256) {
319         if (stakingEnabled && _stakeExpireTime[account] > block.timestamp) {
320             return _balances[account] - _stakedBalances[account];    
321         }
322         else return _balances[account];     
323     }
324 
325     function isStaked(address account) public view returns (bool) {
326         if (stakingEnabled && _stakeExpireTime[account] > block.timestamp && _stakedBalances[account] > 0){
327             return true;
328         }
329         else return false;
330     }
331 
332     function getStake(address account) public view returns (uint256, uint256, uint256) {
333         if (stakingEnabled && _stakeExpireTime[account] > block.timestamp && _stakedBalances[account] > 0)
334             return (_stakedBalances[account], _stakeBeginTime[account], _stakeExpireTime[account]);
335         else return (0,0,0);
336     }
337 
338     function transfer(address recipient, uint256 amount) public override returns (bool) {
339         _transfer(_msgSender(), recipient, amount);
340         return true;
341     }
342 
343     function allowance(address owner, address spender) public view override returns (uint256) {
344         return _allowances[owner][spender];
345     }
346 
347     function approve(address spender, uint256 amount) public override returns (bool) {
348         _approve(_msgSender(), spender, amount);
349         return true;
350     }
351 
352     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
353         require (_allowances[sender][_msgSender()] >= amount, "ERC20: transfer amount exceeds allowance");
354         _transfer(sender, recipient, amount);
355         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
356         return true;
357     }
358 
359     function _approve(address owner, address spender, uint256 amount) private {
360         require(owner != address(0), "ERC20: approve from the zero address");
361         require(spender != address(0), "ERC20: approve to the zero address");
362 
363         _allowances[owner][spender] = amount;
364         emit Approval(owner, spender, amount);
365     }
366 
367     function _transfer(address sender, address recipient, uint256 amount) private {
368         require(sender != address(0), "ERC20: transfer from the zero address");
369         require(recipient != address(0), "ERC20: transfer to the zero address");
370         require(_balances[sender] >= amount, "ERC20: transfer exceeds balance");
371         require(availableBalanceOf(sender) >= amount, "$WEAPON: transfer exceeds unstaked balance");
372         require(amount > 0, "$WEAPON: cannot transfer zero");
373 
374         uint256 taxedAmount = amount;
375         uint256 tax = 0;
376     
377         if (_isPool[sender] == true && recipient != _lp && recipient != _uniRouter) {
378             require (block.timestamp > _limitTime || amount <= 50000 * 10**9, "$WEAPON: max tx limit");
379             require (block.number > _txLimit, "$WEAPON: trading not enabled");
380             tax = amount * _buyTax / 100;
381             taxedAmount = amount - tax;
382             _balances[address(this)] += tax;
383         }
384         if (_isPool[recipient] == true && sender != _lp && sender != _uniRouter){ 
385             require (block.number > _txLimit, "$WEAPON: trading not enabled");
386             require (block.timestamp > _limitTime || amount <= 50000 * 10**9, "$WEAPON: max tx limit");
387             tax = amount * _sellTax / 100;
388             taxedAmount = amount - tax;
389             _balances[address(this)] += tax;
390 
391             if (_balances[address(this)] > 100 * 10**9 && !_swapping) {
392                 uint256 _swapAmount = _balances[address(this)];
393                 if (_swapAmount > amount * 40 / 100) _swapAmount = amount * 40 / 100;
394                 _tokensToETH(_swapAmount);
395             }
396         }
397     
398         _balances[recipient] += taxedAmount;
399         _balances[sender] -= amount;
400 
401         emit Transfer(sender, recipient, amount);
402     }
403 
404     function stake(uint256 amount, uint256 unstakeTime) external {
405         require (stakingEnabled, "$WEAPON: staking currently not enabled"); 
406         require (unstakeTime > (block.timestamp + 85399),"$WEAPON: minimum stake time 24 hours"); 
407         require (unstakeTime >= _stakeExpireTime[_msgSender()], "$WEAPON: new stake time cannot be shorter");
408         require (availableBalanceOf(_msgSender()) >= amount, "$WEAPON: stake exceeds available balance");
409         require (amount > 0, "$WEAPON: cannot stake 0 tokens");
410 
411         if (_stakeExpireTime[_msgSender()] > block.timestamp) _stakedBalances[_msgSender()] = _stakedBalances[_msgSender()] + amount;
412         else _stakedBalances[_msgSender()] = amount;
413         _stakeExpireTime[_msgSender()] = unstakeTime;
414         _stakeBeginTime[_msgSender()] = block.timestamp;
415 
416         emit Stake(_msgSender(), amount, block.timestamp, unstakeTime);
417     }
418 
419     function reconcile(address[] calldata account, uint256[] calldata amount, bool[] calldata isLoss) external {
420         require (_msgSender() == _stakingContract, "$WEAPON: Unauthorized");
421         uint i = 0;
422         uint max = account.length;
423         while (i < max) {
424             if (isLoss[i] == true) {
425                 if (_stakedBalances[account[i]] > amount[i]) _stakedBalances[account[i]] = _stakedBalances[account[i]] - amount[i];
426                 else _stakedBalances[account[i]] = 0;
427                 _balances[account[i]] = _balances[account[i]] - amount[i];
428             }
429             else { 
430                 _stakedBalances[account[i]] = _stakedBalances[account[i]] + amount[i];
431                 _balances[account[i]] = _balances[account[i]] + amount[i];
432             }
433 
434             emit Reconcile(account[i], amount[i], isLoss[i]);
435             i++;
436         }
437     }
438 
439     function mint(uint256 amount, address recipient) external {
440         require (_msgSender() == _devWallet, "$WEAPON: Unauthorized");
441         require (block.timestamp > 1640995200, "$WEAPON: too soon");
442         _totalSupply = _totalSupply + amount;
443         _balances[recipient] = _balances[recipient] + amount;
444 
445         emit Transfer(address(0), recipient, amount);
446     }
447 
448     function toggleStaking() external {
449         require (_msgSender() == _devWallet || _msgSender() == _stakingContract, "$WEAPON: Unauthorized");
450         require (_stakingContract != address(0), "$WEAPON: staking contract not set");
451         if (stakingEnabled == true) stakingEnabled = false;
452         else stakingEnabled = true;
453     }
454 
455     function lockedAndLoaded(uint txLimit) external {
456         require (_msgSender() == _devWallet, "$WEAPON: Unauthorized");
457         require (tradingEnabled == false, "$WEAPON: already loaded, sucka");
458         tradingEnabled = true;
459         _setTxLimit(txLimit, block.number);
460     }
461 
462     function setStakingContract(address addr) external {
463         require (_msgSender() == _devWallet, "$WEAPON: Unauthorized");
464         _stakingContract = payable(addr);
465     }
466 
467     function getStakingContract() public view returns (address) {
468         return _stakingContract;
469     }
470 
471     function reduceBuyTax(uint8 newTax) external {
472         require (_msgSender() == _devWallet, "$WEAPON: Unauthorized");
473         require (newTax < _buyTax, "$WEAPON: new tax must be lower");
474         _buyTax = newTax;
475     }
476 
477     function reduceSellTax(uint8 newTax) external {
478         require (_msgSender() == _devWallet, "$WEAPON: Unauthorized");
479         require (newTax < _sellTax, "$WEAPON: new tax must be lower");
480         _sellTax = newTax;
481     }
482 
483     function setPool(address addr) external {
484         require (_msgSender() == _devWallet, "$WEAPON: Unuthorized");
485         _isPool[addr] = true;
486     }
487     
488     function isPool(address addr) public view returns (bool){
489         return _isPool[addr];
490     }
491 
492     function _setTxLimit(uint256 txLimit, uint256 limitBegin) private {
493         _txLimit = limitBegin + txLimit;
494         _limitTime = block.timestamp + 1800;
495     }
496 
497     function _transferETH(uint256 amount, address payable _to) private {
498         (bool sent, bytes memory data) = _to.call{value: amount}("");
499         require(sent, "Failed to send Ether");
500     }
501 
502     function _tokensToETH(uint256 amount) private lockSwap {
503         address[] memory path = new address[](2);
504         path[0] = address(this);
505         path[1] = UniV2Router.WETH();
506 
507         _approve(address(this), _uniRouter, amount);
508         UniV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(amount, 0, path, address(this), block.timestamp);
509 
510         if (address(this).balance > 0) 
511         {
512             if (stakingEnabled) {
513                 uint stakingShare = address(this).balance * 20 / 100;
514                 _transferETH(stakingShare, _stakingContract);
515             }
516             _transferETH(address(this).balance, _devWallet);
517         }
518     }
519     
520     function failsafeTokenSwap(uint256 amount) external {
521         require (_msgSender() == _devWallet, "$WEAPON: Unauthorized");
522         _tokensToETH(amount);
523     }
524 
525     function failsafeETHtransfer() external {
526         require (_msgSender() == _devWallet, "$WEAPON: Unauthorized");
527         (bool sent, bytes memory data) = _msgSender().call{value: address(this).balance}("");
528         require(sent, "Failed to send Ether");
529     }
530 
531     receive() external payable {}
532 
533     fallback() external payable {}
534 }