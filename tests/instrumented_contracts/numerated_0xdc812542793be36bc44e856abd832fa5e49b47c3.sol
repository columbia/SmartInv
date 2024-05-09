1 /**
2 
3  _____                           ___           _   
4 /  ___|                         |_  |         | |  
5 \ `--. _   _ _ __   ___ _ __      | | ___  ___| |_ 
6  `--. \ | | | '_ \ / _ \ '__|     | |/ _ \/ _ \ __|
7 /\__/ / |_| | |_) |  __/ |    /\__/ /  __/  __/ |_ 
8 \____/ \__,_| .__/ \___|_|    \____/ \___|\___|\__|
9             | |                                    
10             |_|         
11 
12 Is it a Bird?
13 Is it a Plane?
14 
15 No It's SUPER JEET!!!
16 
17 https://www.superjeet.net
18 https://twitter.com/superjeets
19 https://t.me/SuperJeetToken
20 
21 1 Million Tokens
22 2% Max Wallet
23 
24 */
25 
26 // SPDX-License-Identifier: Unlicensed
27 pragma solidity ^0.8.9;
28 
29 interface IUniswapV2Router02 {
30     function swapExactTokensForETHSupportingFeeOnTransferTokens(
31         uint256 amountIn,
32         uint256 amountOutMin,
33         address[] calldata path,
34         address to,
35         uint256 deadline
36     ) external;
37 
38     function factory() external pure returns (address);
39 
40     function WETH() external pure returns (address);
41 }
42 
43 interface IUniswapV2Factory {
44     function createPair(
45         address tokenA,
46         address tokenB
47     ) external returns (address pair);
48 }
49 
50 abstract contract Context {
51     function _msgSender() internal view virtual returns (address) {
52         return msg.sender;
53     }
54 }
55 
56 abstract contract Ownable is Context {
57     address private _owner;
58 
59     event OwnershipTransferred(
60         address indexed previousOwner,
61         address indexed newOwner
62     );
63 
64     /**
65      * @dev Initializes the contract setting the deployer as the initial owner.
66      */
67     constructor() {
68         _transferOwnership(_msgSender());
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         _checkOwner();
76         _;
77     }
78 
79     /**
80      * @dev Returns the address of the current owner.
81      */
82     function owner() public view virtual returns (address) {
83         return _owner;
84     }
85 
86     /**
87      * @dev Throws if the sender is not the owner.
88      */
89     function _checkOwner() internal view virtual {
90         require(owner() == _msgSender(), "Ownable: caller is not the owner");
91     }
92 
93     /**
94      * @dev Leaves the contract without owner. It will not be possible to call
95      * `onlyOwner` functions anymore. Can only be called by the current owner.
96      *
97      * NOTE: Renouncing ownership will leave the contract without an owner,
98      * thereby removing any functionality that is only available to the owner.
99      */
100     function renounceOwnership() public virtual onlyOwner {
101         _transferOwnership(address(0));
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Can only be called by the current owner.
107      */
108     function transferOwnership(address newOwner) public virtual onlyOwner {
109         require(
110             newOwner != address(0),
111             "Ownable: new owner is the zero address"
112         );
113         _transferOwnership(newOwner);
114     }
115 
116     /**
117      * @dev Transfers ownership of the contract to a new account (`newOwner`).
118      * Internal function without access restriction.
119      */
120     function _transferOwnership(address newOwner) internal virtual {
121         address oldOwner = _owner;
122         _owner = newOwner;
123         emit OwnershipTransferred(oldOwner, newOwner);
124     }
125 }
126 
127 /**
128  * @dev Interface of the ERC20 standard as defined in the EIP.
129  */
130 interface IERC20 {
131     /**
132      * @dev Emitted when `value` tokens are moved from one account (`from`) to
133      * another (`to`).
134      *
135      * Note that `value` may be zero.
136      */
137     event Transfer(address indexed from, address indexed to, uint256 value);
138 
139     /**
140      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
141      * a call to {approve}. `value` is the new allowance.
142      */
143     event Approval(
144         address indexed owner,
145         address indexed spender,
146         uint256 value
147     );
148 
149     /**
150      * @dev Returns the amount of tokens in existence.
151      */
152     function totalSupply() external view returns (uint256);
153 
154     /**
155      * @dev Returns the amount of tokens owned by `account`.
156      */
157     function balanceOf(address account) external view returns (uint256);
158 
159     /**
160      * @dev Moves `amount` tokens from the caller's account to `to`.
161      *
162      * Returns a boolean value indicating whether the operation succeeded.
163      *
164      * Emits a {Transfer} event.
165      */
166     function transfer(address to, uint256 amount) external returns (bool);
167 
168     /**
169      * @dev Returns the remaining number of tokens that `spender` will be
170      * allowed to spend on behalf of `owner` through {transferFrom}. This is
171      * zero by default.
172      *
173      * This value changes when {approve} or {transferFrom} are called.
174      */
175     function allowance(
176         address owner,
177         address spender
178     ) external view returns (uint256);
179 
180     /**
181      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
182      *
183      * Returns a boolean value indicating whether the operation succeeded.
184      *
185      * IMPORTANT: Beware that changing an allowance with this method brings the risk
186      * that someone may use both the old and the new allowance by unfortunate
187      * transaction ordering. One possible solution to mitigate this race
188      * condition is to first reduce the spender's allowance to 0 and set the
189      * desired value afterwards:
190      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191      *
192      * Emits an {Approval} event.
193      */
194     function approve(address spender, uint256 amount) external returns (bool);
195 
196     /**
197      * @dev Moves `amount` tokens from `from` to `to` using the
198      * allowance mechanism. `amount` is then deducted from the caller's
199      * allowance.
200      *
201      * Returns a boolean value indicating whether the operation succeeded.
202      *
203      * Emits a {Transfer} event.
204      */
205     function transferFrom(
206         address from,
207         address to,
208         uint256 amount
209     ) external returns (bool);
210 }
211 
212 contract JEET is IERC20, Ownable {
213     string private constant _name = "SUPER JEET";
214     string private constant _symbol = "JEET";
215     uint8 private constant _decimals = 9;
216 
217     uint256 private constant _totalSupply = 1000000 * 10 ** 9;
218     uint256 private constant _maxFee = 15; // Max Fee that can be set
219     uint256 private _taxFeeOnBuy = 0; // Buy Fee
220     uint256 private _taxFeeOnSell = 2; // Jeet Fee
221 
222     mapping(address => uint256) private _balances;
223     mapping(address => mapping(address => uint256)) private _allowances;
224     mapping(address => bool) private _isExcludedFromFee;
225 
226     address payable private constant _developmentAddress =
227         payable(0x7F53450e30cF1c2dA08Bcacfd306e87A9BcbBd6C);
228     address payable private constant _marketingAddress =
229         payable(0xfc83C7078A9Dd0438848Af892033A7135bA57154);
230 
231     IUniswapV2Router02 public uniswapV2Router;
232     address public uniswapV2Pair;
233 
234     bool private inSwap = false;
235 
236     uint256 public _maxTxAmount = 20000 * 10 ** 9;
237     uint256 public _maxWalletSize = 20000 * 10 ** 9;
238     uint256 public _swapTokensAtAmount = 500 * 10 ** 9;
239 
240     modifier lockTheSwap() {
241         inSwap = true;
242         _;
243         inSwap = false;
244     }
245 
246     constructor() {
247         _balances[_msgSender()] = _totalSupply;
248 
249         uniswapV2Router = IUniswapV2Router02(
250             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
251         );
252         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
253             address(this),
254             uniswapV2Router.WETH()
255         );
256 
257         _isExcludedFromFee[owner()] = true;
258         _isExcludedFromFee[address(this)] = true;
259         _isExcludedFromFee[_developmentAddress] = true;
260         _isExcludedFromFee[_marketingAddress] = true;
261 
262         emit Transfer(address(0), _msgSender(), _totalSupply);
263     }
264 
265     function name() public pure returns (string memory) {
266         return _name;
267     }
268 
269     function symbol() public pure returns (string memory) {
270         return _symbol;
271     }
272 
273     function decimals() public pure returns (uint8) {
274         return _decimals;
275     }
276 
277     function totalSupply() public pure override returns (uint256) {
278         return _totalSupply;
279     }
280 
281     function balanceOf(address account) public view override returns (uint256) {
282         return _balances[account];
283     }
284 
285     function transfer(
286         address recipient,
287         uint256 amount
288     ) public override returns (bool) {
289         _transfer(_msgSender(), recipient, amount);
290         return true;
291     }
292 
293     function allowance(
294         address owner,
295         address spender
296     ) public view override returns (uint256) {
297         return _allowances[owner][spender];
298     }
299 
300     function approve(
301         address spender,
302         uint256 amount
303     ) public override returns (bool) {
304         _approve(_msgSender(), spender, amount);
305         return true;
306     }
307 
308     function transferFrom(
309         address sender,
310         address recipient,
311         uint256 amount
312     ) public override returns (bool) {
313         uint256 currentAllowance = _allowances[sender][_msgSender()];
314         require(
315             currentAllowance >= amount,
316             "ERC20: transfer amount exceeds allowance"
317         );
318         unchecked {
319             _approve(sender, _msgSender(), currentAllowance - amount);
320         }
321         _transfer(sender, recipient, amount);
322         return true;
323     }
324 
325     // private
326 
327     function _approve(address owner, address spender, uint256 amount) private {
328         require(owner != address(0), "ERC20: approve from the zero address");
329         require(spender != address(0), "ERC20: approve to the zero address");
330         _allowances[owner][spender] = amount;
331         emit Approval(owner, spender, amount);
332     }
333 
334     function _transfer(address from, address to, uint256 amount) private {
335         require(from != address(0), "ERC20: transfer from the zero address");
336         require(to != address(0), "ERC20: transfer to the zero address");
337         require(amount > 0, "Transfer amount must be greater than zero");
338 
339         if (from != owner() && to != owner()) {
340             if (
341                 to != _marketingAddress &&
342                 from != _marketingAddress &&
343                 to != _developmentAddress &&
344                 from != _developmentAddress
345             ) {
346                 require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
347             }
348 
349             if (
350                 to != uniswapV2Pair &&
351                 to != _marketingAddress &&
352                 from != _marketingAddress &&
353                 to != _developmentAddress &&
354                 from != _developmentAddress
355             ) {
356                 require(
357                     balanceOf(to) + amount < _maxWalletSize,
358                     "TOKEN: Balance exceeds wallet size!"
359                 );
360             }
361             uint256 contractTokenBalance = balanceOf(address(this));
362 
363             if (contractTokenBalance >= _maxTxAmount) {
364                 contractTokenBalance = _maxTxAmount;
365             }
366 
367             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
368 
369             if (
370                 canSwap &&
371                 !inSwap &&
372                 from != uniswapV2Pair &&
373                 !_isExcludedFromFee[from] &&
374                 !_isExcludedFromFee[to]
375             ) {
376                 swapTokensForEth(contractTokenBalance);
377 
378                 uint256 contractETHBalance = address(this).balance;
379                 if (contractETHBalance > 0) {
380                     _marketingAddress.transfer(address(this).balance);
381                 }
382             }
383         }
384 
385         //Transfer Tokens
386         uint256 _taxFee = 0;
387         if (
388             (_isExcludedFromFee[from] || _isExcludedFromFee[to]) ||
389             (from != uniswapV2Pair && to != uniswapV2Pair)
390         ) {
391             _taxFee = 0;
392         } else {
393             //Set Fee for Buys
394             if (from == uniswapV2Pair && to != address(uniswapV2Router)) {
395                 _taxFee = _taxFeeOnBuy;
396             }
397 
398             //Set Fee for Sells
399             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
400                 _taxFee = _taxFeeOnSell;
401             }
402         }
403 
404         _tokenTransfer(from, to, amount, _taxFee);
405     }
406 
407     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
408         address[] memory path = new address[](2);
409         path[0] = address(this);
410         path[1] = uniswapV2Router.WETH();
411         _approve(address(this), address(uniswapV2Router), tokenAmount);
412         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
413             tokenAmount,
414             0,
415             path,
416             address(this),
417             block.timestamp
418         );
419     }
420 
421     function _tokenTransfer(
422         address sender,
423         address recipient,
424         uint256 amount,
425         uint256 tax
426     ) private {
427         uint256 tTeam = (amount * tax) / 100;
428         uint256 tTransferAmount = amount - tTeam;
429         _balances[sender] = _balances[sender] - amount;
430         _balances[recipient] = _balances[recipient] + tTransferAmount;
431         if (tTeam > 0) {
432             _balances[address(this)] = _balances[address(this)] + tTeam;
433             emit Transfer(sender, address(this), tTeam);
434         }
435         emit Transfer(sender, recipient, tTransferAmount);
436     }
437 
438     // onlyOwner external
439 
440     function setFee(
441         uint256 taxFeeOnBuy,
442         uint256 taxFeeOnSell
443     ) external onlyOwner {
444         require(taxFeeOnBuy <= _maxFee, "Fee is too high");
445         require(taxFeeOnSell <= _maxFee, "Fee is too high");
446 
447         _taxFeeOnBuy = taxFeeOnBuy;
448         _taxFeeOnSell = taxFeeOnSell;
449     }
450 
451     //Set minimum tokens required to swap.
452     function setMinSwapTokensThreshold(
453         uint256 swapTokensAtAmount
454     ) external onlyOwner {
455         _swapTokensAtAmount = swapTokensAtAmount;
456     }
457 
458     function excludeMultipleAccountsFromFees(
459         address[] calldata accounts,
460         bool excluded
461     ) external onlyOwner {
462         for (uint256 i = 0; i < accounts.length; i++) {
463             _isExcludedFromFee[accounts[i]] = excluded;
464         }
465     }
466 
467     receive() external payable {}
468 }