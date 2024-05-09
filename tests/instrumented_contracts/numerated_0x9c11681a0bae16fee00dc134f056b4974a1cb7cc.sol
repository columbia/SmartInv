1 /**
2 
3 💀 REAPER 💀
4 
5 The Harvester of Dead Tokens
6 
7 Swap your tokens from a Dead Project and receive a 15% BONUS if you hold for at least 48 hours
8 
9 Turn your DUST into GOLD with REAPER
10 
11 🌐 https://www.reaper.vip
12 💬 https://t.me/reapertoken
13 🐦 https://twitter.com/thereapertoken
14 📜 https://reaper-1.gitbook.io/reaper.vip-whitepaper
15 
16 */
17 
18 // SPDX-License-Identifier: Unlicensed
19 pragma solidity ^0.8.9;
20 
21 interface IUniswapV2Router02 {
22     function swapExactTokensForETHSupportingFeeOnTransferTokens(
23         uint256 amountIn,
24         uint256 amountOutMin,
25         address[] calldata path,
26         address to,
27         uint256 deadline
28     ) external;
29 
30     function factory() external pure returns (address);
31 
32     function WETH() external pure returns (address);
33 }
34 
35 interface IUniswapV2Factory {
36     function createPair(
37         address tokenA,
38         address tokenB
39     ) external returns (address pair);
40 }
41 
42 abstract contract Context {
43     function _msgSender() internal view virtual returns (address) {
44         return msg.sender;
45     }
46 }
47 
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(
52         address indexed previousOwner,
53         address indexed newOwner
54     );
55 
56     /**
57      * @dev Initializes the contract setting the deployer as the initial owner.
58      */
59     constructor() {
60         _transferOwnership(_msgSender());
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         _checkOwner();
68         _;
69     }
70 
71     /**
72      * @dev Returns the address of the current owner.
73      */
74     function owner() public view virtual returns (address) {
75         return _owner;
76     }
77 
78     /**
79      * @dev Throws if the sender is not the owner.
80      */
81     function _checkOwner() internal view virtual {
82         require(owner() == _msgSender(), "Ownable: caller is not the owner");
83     }
84 
85     /**
86      * @dev Leaves the contract without owner. It will not be possible to call
87      * `onlyOwner` functions anymore. Can only be called by the current owner.
88      *
89      * NOTE: Renouncing ownership will leave the contract without an owner,
90      * thereby removing any functionality that is only available to the owner.
91      */
92     function renounceOwnership() public virtual onlyOwner {
93         _transferOwnership(address(0));
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Can only be called by the current owner.
99      */
100     function transferOwnership(address newOwner) public virtual onlyOwner {
101         require(
102             newOwner != address(0),
103             "Ownable: new owner is the zero address"
104         );
105         _transferOwnership(newOwner);
106     }
107 
108     /**
109      * @dev Transfers ownership of the contract to a new account (`newOwner`).
110      * Internal function without access restriction.
111      */
112     function _transferOwnership(address newOwner) internal virtual {
113         address oldOwner = _owner;
114         _owner = newOwner;
115         emit OwnershipTransferred(oldOwner, newOwner);
116     }
117 }
118 
119 /**
120  * @dev Interface of the ERC20 standard as defined in the EIP.
121  */
122 interface IERC20 {
123     /**
124      * @dev Emitted when `value` tokens are moved from one account (`from`) to
125      * another (`to`).
126      *
127      * Note that `value` may be zero.
128      */
129     event Transfer(address indexed from, address indexed to, uint256 value);
130 
131     /**
132      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
133      * a call to {approve}. `value` is the new allowance.
134      */
135     event Approval(
136         address indexed owner,
137         address indexed spender,
138         uint256 value
139     );
140 
141     /**
142      * @dev Returns the amount of tokens in existence.
143      */
144     function totalSupply() external view returns (uint256);
145 
146     /**
147      * @dev Returns the amount of tokens owned by `account`.
148      */
149     function balanceOf(address account) external view returns (uint256);
150 
151     /**
152      * @dev Moves `amount` tokens from the caller's account to `to`.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * Emits a {Transfer} event.
157      */
158     function transfer(address to, uint256 amount) external returns (bool);
159 
160     /**
161      * @dev Returns the remaining number of tokens that `spender` will be
162      * allowed to spend on behalf of `owner` through {transferFrom}. This is
163      * zero by default.
164      *
165      * This value changes when {approve} or {transferFrom} are called.
166      */
167     function allowance(
168         address owner,
169         address spender
170     ) external view returns (uint256);
171 
172     /**
173      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * IMPORTANT: Beware that changing an allowance with this method brings the risk
178      * that someone may use both the old and the new allowance by unfortunate
179      * transaction ordering. One possible solution to mitigate this race
180      * condition is to first reduce the spender's allowance to 0 and set the
181      * desired value afterwards:
182      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183      *
184      * Emits an {Approval} event.
185      */
186     function approve(address spender, uint256 amount) external returns (bool);
187 
188     /**
189      * @dev Moves `amount` tokens from `from` to `to` using the
190      * allowance mechanism. `amount` is then deducted from the caller's
191      * allowance.
192      *
193      * Returns a boolean value indicating whether the operation succeeded.
194      *
195      * Emits a {Transfer} event.
196      */
197     function transferFrom(
198         address from,
199         address to,
200         uint256 amount
201     ) external returns (bool);
202 }
203 
204 contract REAPER is IERC20, Ownable {
205     string private constant _name = "REAPER";
206     string private constant _symbol = "REAPER";
207     uint8 private constant _decimals = 9;
208 
209     uint256 private constant _totalSupply = 1000000000000 * 10 ** 9;
210     uint256 private constant _maxFee = 30; //Highest Tax can be set
211 
212     uint256 public _maxTxAmount = 5000000000 * 10 ** 9;
213     uint256 public _maxWalletSize = 5000000000 * 10 ** 9;
214     uint256 public _swapTokensAtAmount = 100000000 * 10 ** 9;
215     uint256 private _taxFeeOnBuy = 30; //Launch Tax - Final Buy Tax is 0
216     uint256 private _taxFeeOnSell = 30; //Launch Tax - Final Sell Tax is 8
217 
218     mapping(address => uint256) private _balances;
219     mapping(address => mapping(address => uint256)) private _allowances;
220     mapping(address => bool) private _isExcludedFromFee;
221 
222     address payable private constant _developmentAddress =
223         payable(0xB0938eda7C91E66564c5BDAc44471dCe2475Bb6F);
224     address payable private constant _marketingAddress =
225         payable(0x067fcEfB8C58cCdd2ed5D5e8f5E0607eC7cBa216);
226 
227     IUniswapV2Router02 public uniswapV2Router;
228     address public uniswapV2Pair;
229 
230     bool private inSwap = false;
231 
232     modifier lockTheSwap() {
233         inSwap = true;
234         _;
235         inSwap = false;
236     }
237 
238     constructor() {
239         _balances[_msgSender()] = _totalSupply;
240 
241         uniswapV2Router = IUniswapV2Router02(
242             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
243         );
244         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
245             address(this),
246             uniswapV2Router.WETH()
247         );
248 
249         _isExcludedFromFee[owner()] = true;
250         _isExcludedFromFee[address(this)] = true;
251         _isExcludedFromFee[_developmentAddress] = true;
252         _isExcludedFromFee[_marketingAddress] = true;
253 
254         emit Transfer(address(0), _msgSender(), _totalSupply);
255     }
256 
257     function name() public pure returns (string memory) {
258         return _name;
259     }
260 
261     function symbol() public pure returns (string memory) {
262         return _symbol;
263     }
264 
265     function decimals() public pure returns (uint8) {
266         return _decimals;
267     }
268 
269     function totalSupply() public pure override returns (uint256) {
270         return _totalSupply;
271     }
272 
273     function balanceOf(address account) public view override returns (uint256) {
274         return _balances[account];
275     }
276 
277     function transfer(
278         address recipient,
279         uint256 amount
280     ) public override returns (bool) {
281         _transfer(_msgSender(), recipient, amount);
282         return true;
283     }
284 
285     function allowance(
286         address owner,
287         address spender
288     ) public view override returns (uint256) {
289         return _allowances[owner][spender];
290     }
291 
292     function approve(
293         address spender,
294         uint256 amount
295     ) public override returns (bool) {
296         _approve(_msgSender(), spender, amount);
297         return true;
298     }
299 
300     function transferFrom(
301         address sender,
302         address recipient,
303         uint256 amount
304     ) public override returns (bool) {
305         uint256 currentAllowance = _allowances[sender][_msgSender()];
306         require(
307             currentAllowance >= amount,
308             "ERC20: transfer amount exceeds allowance"
309         );
310         unchecked {
311             _approve(sender, _msgSender(), currentAllowance - amount);
312         }
313         _transfer(sender, recipient, amount);
314         return true;
315     }
316 
317     // private
318 
319     function _approve(address owner, address spender, uint256 amount) private {
320         require(owner != address(0), "ERC20: approve from the zero address");
321         require(spender != address(0), "ERC20: approve to the zero address");
322         _allowances[owner][spender] = amount;
323         emit Approval(owner, spender, amount);
324     }
325 
326     function _transfer(address from, address to, uint256 amount) private {
327         require(from != address(0), "ERC20: transfer from the zero address");
328         require(to != address(0), "ERC20: transfer to the zero address");
329         require(amount > 0, "Transfer amount must be greater than zero");
330 
331         if (from != owner() && to != owner()) {
332             if (
333                 to != _marketingAddress &&
334                 from != _marketingAddress &&
335                 to != _developmentAddress &&
336                 from != _developmentAddress
337             ) {
338                 require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
339             }
340 
341             if (
342                 to != uniswapV2Pair &&
343                 to != _marketingAddress &&
344                 from != _marketingAddress &&
345                 to != _developmentAddress &&
346                 from != _developmentAddress
347             ) {
348                 require(
349                     balanceOf(to) + amount < _maxWalletSize,
350                     "TOKEN: Balance exceeds wallet size!"
351                 );
352             }
353             uint256 contractTokenBalance = balanceOf(address(this));
354 
355             if (contractTokenBalance >= _maxTxAmount) {
356                 contractTokenBalance = _maxTxAmount;
357             }
358 
359             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
360 
361             if (
362                 canSwap &&
363                 !inSwap &&
364                 from != uniswapV2Pair &&
365                 !_isExcludedFromFee[from] &&
366                 !_isExcludedFromFee[to]
367             ) {
368                 swapTokensForEth(contractTokenBalance);
369 
370                 uint256 contractETHBalance = address(this).balance;
371                 if (contractETHBalance > 0) {
372                     _marketingAddress.transfer(address(this).balance);
373                 }
374             }
375         }
376 
377         //Transfer Tokens
378         uint256 _taxFee = 0;
379         if (
380             (_isExcludedFromFee[from] || _isExcludedFromFee[to]) ||
381             (from != uniswapV2Pair && to != uniswapV2Pair)
382         ) {
383             _taxFee = 0;
384         } else {
385             //Set Fee for Buys
386             if (from == uniswapV2Pair && to != address(uniswapV2Router)) {
387                 _taxFee = _taxFeeOnBuy;
388             }
389 
390             //Set Fee for Sells
391             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
392                 _taxFee = _taxFeeOnSell;
393             }
394         }
395 
396         _tokenTransfer(from, to, amount, _taxFee);
397     }
398 
399     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
400         address[] memory path = new address[](2);
401         path[0] = address(this);
402         path[1] = uniswapV2Router.WETH();
403         _approve(address(this), address(uniswapV2Router), tokenAmount);
404         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
405             tokenAmount,
406             0,
407             path,
408             address(this),
409             block.timestamp
410         );
411     }
412 
413     function _tokenTransfer(
414         address sender,
415         address recipient,
416         uint256 amount,
417         uint256 tax
418     ) private {
419         uint256 tTeam = (amount * tax) / 100;
420         uint256 tTransferAmount = amount - tTeam;
421         _balances[sender] = _balances[sender] - amount;
422         _balances[recipient] = _balances[recipient] + tTransferAmount;
423         if (tTeam > 0) {
424             _balances[address(this)] = _balances[address(this)] + tTeam;
425             emit Transfer(sender, address(this), tTeam);
426         }
427         emit Transfer(sender, recipient, tTransferAmount);
428     }
429 
430     // onlyOwner external
431 
432     function setFee(
433         uint256 taxFeeOnBuy,
434         uint256 taxFeeOnSell
435     ) external onlyOwner {
436         require(taxFeeOnBuy <= _maxFee, "Fee is too high");
437         require(taxFeeOnSell <= _maxFee, "Fee is too high");
438 
439         _taxFeeOnBuy = taxFeeOnBuy;
440         _taxFeeOnSell = taxFeeOnSell;
441     }
442 
443     //Remove all TX and Wallet Limits
444     function removeLimits() external onlyOwner {
445         _maxTxAmount = _totalSupply;
446         _maxWalletSize = _totalSupply;
447     }
448 
449     //1% TX and Wallet Limits
450     function increaseLimits1() external onlyOwner {
451         _maxTxAmount = 10000000000 * 10 ** 9;
452         _maxWalletSize = 10000000000 * 10 ** 9;
453     }
454 
455     //2% TX and Wallet Limits
456     function increaseLimits2() external onlyOwner {
457         _maxTxAmount = 20000000000 * 10 ** 9;
458         _maxWalletSize = 20000000000 * 10 ** 9;
459     }
460 
461     //Set minimum tokens required to swap.
462     function setMinSwapTokensThreshold(
463         uint256 swapTokensAtAmount
464     ) external onlyOwner {
465         _swapTokensAtAmount = swapTokensAtAmount;
466     }
467 
468     function excludeMultipleAccountsFromFees(
469         address[] calldata accounts,
470         bool excluded
471     ) external onlyOwner {
472         for (uint256 i = 0; i < accounts.length; i++) {
473             _isExcludedFromFee[accounts[i]] = excluded;
474         }
475     }
476 
477     // Send the current ETH balance to the marketing address
478     function cleanContractETH() external {
479         uint256 contractETHBalance = address(this).balance;
480         if (contractETHBalance > 0) {
481             _marketingAddress.transfer(contractETHBalance);
482         }
483     }
484 
485     // Send the current token balance to the marketing address
486     function cleanContractTokens() external {
487         uint256 contractTokenBalance = balanceOf(address(this));
488         if (contractTokenBalance > 0) {
489             _tokenTransfer(
490                 address(this),
491                 _marketingAddress,
492                 contractTokenBalance,
493                 0
494             );
495         }
496     }
497 
498     receive() external payable {}
499 }