1 /**
2     Twitter: https://twitter.com/Penguin_MPG
3     Telegram: https://t.me/MurderPenguin
4  */
5 
6 // SPDX-License-Identifier: MIT
7 pragma solidity ^0.8.13;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Emitted when `value` tokens are moved from one account (`from`) to
15      * another (`to`).
16      *
17      * Note that `value` may be zero.
18      */
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     /**
22      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
23      * a call to {approve}. `value` is the new allowance.
24      */
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 
27     /**
28      * @dev Returns the amount of tokens in existence.
29      */
30     function totalSupply() external view returns (uint256);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `to`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address to, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     /**
56      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * IMPORTANT: Beware that changing an allowance with this method brings the risk
61      * that someone may use both the old and the new allowance by unfortunate
62      * transaction ordering. One possible solution to mitigate this race
63      * condition is to first reduce the spender's allowance to 0 and set the
64      * desired value afterwards:
65      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66      *
67      * Emits an {Approval} event.
68      */
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Moves `amount` tokens from `from` to `to` using the
73      * allowance mechanism. `amount` is then deducted from the caller's
74      * allowance.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(
81         address from,
82         address to,
83         uint256 amount
84     ) external returns (bool);
85 }
86 
87 interface IIGLOO {
88     function balanceOf(address account) external returns (uint256);
89     function transfer(address to, uint256 amount) external returns (bool);
90     function resetLastFreeze(address account) external;
91 }
92 
93 /**
94  * @dev Provides information about the current execution context, including the
95  * sender of the transaction and its data. While these are generally available
96  * via msg.sender and msg.data, they should not be accessed in such a direct
97  * manner, since when dealing with meta-transactions the account sending and
98  * paying for execution may not be the actual sender (as far as an application
99  * is concerned).
100  *
101  * This contract is only required for intermediate, library-like contracts.
102  */
103 abstract contract Context {
104     function _msgSender() internal view virtual returns (address) {
105         return msg.sender;
106     }
107 
108     function _msgData() internal view virtual returns (bytes calldata) {
109         return msg.data;
110     }
111 }
112 
113 /**
114  * @dev Contract module which provides a basic access control mechanism, where
115  * there is an account (an owner) that can be granted exclusive access to
116  * specific functions.
117  *
118  * By default, the owner account will be the one that deploys the contract. This
119  * can later be changed with {transferOwnership}.
120  *
121  * This module is used through inheritance. It will make available the modifier
122  * `onlyOwner`, which can be applied to your functions to restrict their use to
123  * the owner.
124  */
125 abstract contract Ownable is Context {
126     address private _owner;
127 
128     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
129 
130     /**
131      * @dev Initializes the contract setting the deployer as the initial owner.
132      */
133     constructor() {
134         _transferOwnership(_msgSender());
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the owner.
139      */
140     modifier onlyOwner() {
141         _checkOwner();
142         _;
143     }
144 
145     /**
146      * @dev Returns the address of the current owner.
147      */
148     function owner() public view virtual returns (address) {
149         return _owner;
150     }
151 
152     /**
153      * @dev Throws if the sender is not the owner.
154      */
155     function _checkOwner() internal view virtual {
156         require(owner() == _msgSender(), "Ownable: caller is not the owner");
157     }
158 
159     /**
160      * @dev Leaves the contract without owner. It will not be possible to call
161      * `onlyOwner` functions anymore. Can only be called by the current owner.
162      *
163      * NOTE: Renouncing ownership will leave the contract without an owner,
164      * thereby removing any functionality that is only available to the owner.
165      */
166     function renounceOwnership() public virtual onlyOwner {
167         _transferOwnership(address(0));
168     }
169 
170     /**
171      * @dev Transfers ownership of the contract to a new account (`newOwner`).
172      * Can only be called by the current owner.
173      */
174     function transferOwnership(address newOwner) public virtual onlyOwner {
175         require(newOwner != address(0), "Ownable: new owner is the zero address");
176         _transferOwnership(newOwner);
177     }
178 
179     /**
180      * @dev Transfers ownership of the contract to a new account (`newOwner`).
181      * Internal function without access restriction.
182      */
183     function _transferOwnership(address newOwner) internal virtual {
184         address oldOwner = _owner;
185         _owner = newOwner;
186         emit OwnershipTransferred(oldOwner, newOwner);
187     }
188 }
189 
190 interface IRouter {
191     function factory() external pure returns (address);
192     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
193     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
194     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
195 }
196 
197 interface IxIGLOO {
198     function deposit() external payable;
199 }
200 
201 interface IFactory {
202     function getPair(address tokenA, address tokenB) external view returns (address pair);
203     function createPair(address tokenA, address tokenB) external returns (address pair);
204 }
205 
206 contract IGLOO is IERC20, Ownable {
207     string public constant _name = "IGLOO";
208     string public constant _symbol = "IGLOO";
209     uint8 public constant _decimals = 18;
210 
211     uint256 public _totalSupply = 100000000 * (10 ** 18);
212     mapping (address => uint256) public _balances;
213     mapping (address => mapping (address => uint256)) public _allowances;
214 
215     mapping (address => uint256) public _lastFreeze;
216     address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
217     mapping (address => bool) public noTax;
218     mapping (address => bool) public noMax;
219     mapping (address => bool) public blacklist;
220     address public treasury;
221     address public dexPair;
222     uint256 public buyFee = 0;
223     uint256 public sellFee = 2500;
224     uint256 private _tokens = 0;
225     IRouter public router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
226     address public icebox;
227     bool private _swapping;
228     bool public tradingPaused = true;
229     uint256 public maxTx = 2000000 * (10 ** 18);
230     uint256 public maxWallet = 2000000 * (10 ** 18);
231     IxIGLOO staking;
232 
233     modifier swapping() {
234         _swapping = true;
235         _;
236         _swapping = false;
237     }
238 
239     constructor (address _treasury) {
240         treasury = _treasury;
241         dexPair = IFactory(router.factory()).createPair(WETH, address(this));
242         _allowances[address(this)][address(router)] = type(uint256).max;
243 
244         noTax[msg.sender] = true;
245         noMax[msg.sender] = true;
246         noMax[address(dexPair)] = true;
247         noMax[address(this)] = true;
248         noMax[address(0)] = true;
249         noMax[address(router)] = true;
250         noMax[0xD152f549545093347A162Dce210e7293f1452150] = true;
251 
252         approve(address(router), type(uint256).max);
253         approve(address(dexPair), type(uint256).max);
254 
255         _balances[msg.sender] = _totalSupply;
256         emit Transfer(address(0), msg.sender, _totalSupply);
257     }
258 
259     function resetLastFreeze(address account) external {
260         require(msg.sender == icebox);
261         _lastFreeze[account] = block.timestamp;
262     }
263 
264     function totalSupply() external view override returns (uint256) {
265         return _totalSupply;
266     }
267 
268     function decimals() external pure returns (uint8) {
269         return _decimals;
270     }
271 
272     function symbol() external pure returns (string memory) {
273         return _symbol;
274     }
275 
276     function name() external pure returns (string memory) {
277         return _name;
278     }
279 
280     function getOwner() external view returns (address) {
281         return owner();
282     }
283 
284     function balanceOf(address account) public view override returns (uint256) {
285         return _balances[account];
286     }
287 
288     function allowance(address holder, address spender) external view override returns (uint256) {
289         return _allowances[holder][spender];
290     }
291 
292     function approve(address spender, uint256 amount) public override returns (bool) {
293         _allowances[msg.sender][spender] = amount;
294         emit Approval(msg.sender, spender, amount);
295         return true;
296     }
297 
298     function approveMax(address spender) external returns (bool) {
299         return approve(spender, _totalSupply);
300     }
301 
302     function transfer(address recipient, uint256 amount) external override returns (bool) {
303         return _transferFrom(msg.sender, recipient, amount);
304     }
305 
306     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
307         if (_allowances[sender][msg.sender] != _totalSupply) {
308             require(_allowances[sender][msg.sender] >= amount, "Insufficient allowance");
309             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
310         }
311 
312         return _transferFrom(sender, recipient, amount);
313     }
314 
315     function _transferFrom(address sender, address recipient, uint256 amount) private returns (bool) {
316         require(!tradingPaused || sender == owner(), "Trading paused");
317         require((!blacklist[sender] && !blacklist[recipient]) || sender == owner(), "Address blacklisted");
318         if (_swapping) {
319             require(maxTx >= amount || noMax[recipient] || sender == owner(), "Max triggered");
320             require(maxWallet >= amount + _balances[recipient] || noMax[recipient] || sender == owner(), "Max triggered");
321             return _basicTransfer(sender, recipient, amount);
322         }
323 
324         bool _sell = recipient == dexPair || recipient == address(router);
325 
326         if (_sell) {
327             if (msg.sender != dexPair && !_swapping && _tokens > 0) _payTreasury();
328         }
329 
330         require(_balances[sender] >= amount, "Insufficient balance");
331         _balances[sender] = _balances[sender] - amount;
332 
333         uint256 amountReceived = (((sender == dexPair || sender == address(router)) || (recipient == dexPair || recipient == address(router))) ? !noTax[sender] && !noTax[recipient] : false) ? _calcAmount(sender, recipient, amount) : amount;
334         require(maxTx >= amountReceived || noMax[recipient] || sender == owner(), "Max triggered");
335         require(maxWallet >= amountReceived + _balances[recipient] || noMax[recipient] || sender == owner(), "Max triggered");
336 
337         _balances[recipient] = _balances[recipient] + amountReceived;
338 
339         emit Transfer(sender, recipient, amountReceived);
340         return true;
341     }
342 
343     function _basicTransfer(address sender, address recipient, uint256 amount) private returns (bool) {
344         require(_balances[sender] >= amount, "Insufficient balance");
345         _balances[sender] = _balances[sender] - amount;
346         _balances[recipient] = _balances[recipient] + amount;
347 
348         return true;
349     }
350 
351     function _calcAmount(address sender, address receiver, uint256 amount) private returns (uint256) {
352         bool _sell = receiver == dexPair || receiver == address(router);
353         uint256 _sellFee = sellFee;
354         if (_sell) {
355             _sellFee = reqSellTax(sender);
356         }
357         uint256 _fee = _sell ? _sellFee : buyFee;
358         uint256 _tax = amount * _fee / 10000;
359         if (_fee > 0) {
360             _tokens += _tax;
361             _balances[address(this)] = _balances[address(this)] + _tax;
362             emit Transfer(sender, address(this), _tax);
363         }
364         return amount - _tax;
365     }
366 
367     function _payTreasury() private swapping {
368         address[] memory path = new address[](2);
369         path[0] = address(this);
370         path[1] = WETH;
371         uint256 _preview = address(this).balance;
372         router.swapExactTokensForETHSupportingFeeOnTransferTokens(balanceOf(address(this)), 0, path, address(this), block.timestamp);
373         uint256 _net = address(this).balance - _preview;
374         if (_net > 0) {
375             payable(treasury).call{value: _net * 7000 / 10000}("");
376             staking.deposit{value: _net * 3000 / 10000}();
377         }
378         _tokens = 0;
379     }
380 
381     function setTreasury(address _treasury) external onlyOwner {
382         treasury = _treasury;
383     }
384 
385     function setStaking(address _xigloo) external onlyOwner {
386         staking = IxIGLOO(_xigloo);
387     }
388 
389     function setIcebox(address _icebox) external onlyOwner {
390         icebox = _icebox;
391     }
392 
393     function setNoTax(address _wallet, bool _value) external onlyOwner {
394         noTax[_wallet] = _value;
395     }
396 
397     function reqNoTax(address _wallet) external view returns (bool) {
398         return noTax[_wallet];
399     }
400 
401     function setNoMax(address _wallet, bool _value) external onlyOwner {
402         noMax[_wallet] = _value;
403     }
404 
405     function reqNoMax(address _wallet) external view returns (bool) {
406         return noMax[_wallet];
407     }
408 
409     function setMaxTx(uint256 _maxTx) external onlyOwner {
410         maxTx = _maxTx;
411     }
412 
413     function reqMaxTx() external view returns (uint256) {
414         return maxTx;
415     }
416 
417     function setMaxWallet(uint256 _maxWallet) external onlyOwner {
418         maxWallet = _maxWallet;
419     }
420 
421     function reqMaxWallet() external view returns (uint256) {
422         return maxWallet;
423     }
424 
425     function setBlacklist(address _wallet, bool _value) external onlyOwner {
426         blacklist[_wallet] = _value;
427     }
428 
429     function reqBlacklist(address _wallet) external view returns (bool) {
430         return blacklist[_wallet];
431     }
432 
433     function setTradingPaused(bool _tradingPaused) external onlyOwner {
434         tradingPaused = _tradingPaused;
435     }
436 
437     function reqTradingPaused() external view returns (bool) {
438         return tradingPaused;
439     }
440 
441     function setBuyTax(uint256 _buyFee) external onlyOwner {
442         require(_buyFee <= 10000);
443         buyFee = _buyFee;
444     }
445 
446     function reqBuyTax() external view returns (uint256) {
447         return buyFee;
448     }
449 
450     function setSellTax(uint256 _sellFee) external onlyOwner {
451         require(_sellFee <= 10000);
452         sellFee = _sellFee;
453     }
454 
455     function reqSellTax(address _wallet) public view returns (uint256) {
456         uint256 _sellFee = sellFee;
457         if (_lastFreeze[_wallet] > 0) {
458             uint256 _days = (100 * ((block.timestamp - _lastFreeze[_wallet]) / 86400));
459             if (9900 >= _days) {
460                 _sellFee = 9900 - _days;
461                 if (_sellFee < sellFee) {
462                     _sellFee = sellFee;
463                 }
464             } else {
465                 _sellFee = sellFee;
466             }
467         }
468         return _sellFee;
469     }
470 
471     function reqLastFreeze(address _wallet) external view returns (uint256) {
472         return _lastFreeze[_wallet];
473     }
474 
475     function reqDexPair() external view returns (address) {
476         return dexPair;
477     }
478 
479     function reqTreasury() external view returns (address) {
480         return treasury;
481     }
482 
483     function transferETH() external onlyOwner {
484         payable(msg.sender).call{value: address(this).balance}("");
485     }
486 
487     function transferERC(address token) external onlyOwner {
488         IERC20 Token = IERC20(token);
489         Token.transfer(msg.sender, Token.balanceOf(address(this)));
490     }
491 
492     receive() external payable {}
493 }