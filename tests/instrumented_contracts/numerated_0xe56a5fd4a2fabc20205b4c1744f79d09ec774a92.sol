1 /*
2 
3 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⠀⠀⠀⠀⠀⠀⠀
4 ⠀⠀⠀⠀⠀⠀⠀⢀⣠⣶⣾⣿⣿⣿⣿⣿⣿⣿⣷⣶⣤⣀⣤⣾⣿⣿⣿⣿⣿⣷⣦⣀⠀⠀⠀
5 ⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀
6 ⠀⠀⢀⣴⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀
7 ⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠙⢿⣿⣿⣿⣿⣿⣿⡇
8 ⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠸⣿⣿⣿⣿⣿⣿⡇
9 ⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⢸⣿⣿⣿⣿⣿⣿⠇
10 ⠀⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⢀⣾⣿⣿⣿⣿⣿⡟⠀
11 ⠀⠀⣹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣾⣿⣿⣿⣿⣿⡟⠁⠀
12 ⠠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⣾⣿⣿⣿⣿⣿⠟⠀⠀⠀
13 ⠀⢈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠁⠀⢸⣿⣿⣿⣿⣿⡏⠀⠀⠀⠀
14 ⠀⠀⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣧⡀⠀⣀⡄
15 ⠀⠀⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⠟⠀
16 ⠀⠀⠀⠘⠿⠿⠿⠛⠋⠉⠉⢿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠛⠛⠉⠀⠀⠀
17 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
18 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
19 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
20 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
21 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
22 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⡿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
23 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
24 ⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⠿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
25 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
26 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
27 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡀⣠⢤⡄⠀⠀⠀⠀⠀⠀⠀
28 ⠀⠀⠀⠀⠀⠀⣀⣤⣤⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⣄⠀⠀⣿⣍⡛⡼⢧⣄⠀⠀⠀⠀⠀⠀
29 ⠀⠀⠀⣠⣴⠿⣛⠉⠁⢀⣿⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⣾⣿⣿⢰⡟⠛⠋⠀⠀⠀⠀⠀⠀
30 ⠀⣠⡾⠛⠁⢰⣿⢃⣴⡿⠃⠀⢀⣤⡀⣲⣆⣤⡄⣾⠇⠀⣀⣠⡌⢋⣠⣶⡆⠀⢀⡀⠀⠀⠀
31 ⣰⠟⠀⠀⣤⣿⡿⠿⠿⢷⣦⣴⠟⣽⡅⣿⠋⠿⢻⡿⠞⣷⣽⡿⣡⣾⣩⡿⠃⢀⡼⠁⠀⠀⠀
32 ⠹⠦⠶⠀⢠⣿⠁⠀⣀⣼⣿⣏⣼⣿⢠⣿⠀⣶⣿⣡⡾⠋⣿⣅⢹⣿⣋⣤⡶⠛⠀⠀⠀⠀⠀
33 ⠀⠀⠠⣤⣼⣿⠶⠟⠋⠁⠿⠟⠁⠛⠙⠋⠀⠘⠋⠉⠀⠀⠈⠁⠀⠈⠉⠁⠀⠀⠀⠀⠀⠀⠀
34 ⠀⠀⠀⠀⠸⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
35  
36     WEB: https://barbiecoin.io/
37     TWITTER: https://twitter.com/BarbieEthereum
38     TELEGRAM: https://t.me/BarbiePortal
39  
40 */
41 
42 // SPDX-License-Identifier: MIT                                                                               
43 
44 pragma solidity 0.8.11;
45 
46 abstract contract Context {
47     function _msgSender() internal view virtual returns (address) {
48         return msg.sender;
49     }
50 
51     function _msgData() internal view virtual returns (bytes calldata) {
52         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
53         return msg.data;
54     }
55 }
56 
57 interface IERC20 {
58     /**
59      * @dev Returns the amount of tokens in existence.
60      */
61     function totalSupply() external view returns (uint256);
62 
63     /**
64      * @dev Returns the amount of tokens owned by `account`.
65      */
66     function balanceOf(address account) external view returns (uint256);
67 
68     /**
69      * @dev Moves `amount` tokens from the caller's account to `recipient`.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transfer(address recipient, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Returns the remaining number of tokens that `spender` will be
79      * allowed to spend on behalf of `owner` through {transferFrom}. This is
80      * zero by default.
81      *
82      * This value changes when {approve} or {transferFrom} are called.
83      */
84     function allowance(address owner, address spender) external view returns (uint256);
85 
86     /**
87      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * IMPORTANT: Beware that changing an allowance with this method brings the risk
92      * that someone may use both the old and the new allowance by unfortunate
93      * transaction ordering. One possible solution to mitigate this race
94      * condition is to first reduce the spender's allowance to 0 and set the
95      * desired value afterwards:
96      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
97      *
98      * Emits an {Approval} event.
99      */
100     function approve(address spender, uint256 amount) external returns (bool);
101 
102     /**
103      * @dev Moves `amount` tokens from `sender` to `recipient` using the
104      * allowance mechanism. `amount` is then deducted from the caller's
105      * allowance.
106      *
107      * Returns a boolean value indicating whether the operation succeeded.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transferFrom(
112         address sender,
113         address recipient,
114         uint256 amount
115     ) external returns (bool);
116 
117     /**
118      * @dev Emitted when `value` tokens are moved from one account (`from`) to
119      * another (`to`).
120      *
121      * Note that `value` may be zero.
122      */
123     event Transfer(address indexed from, address indexed to, uint256 value);
124 
125     /**
126      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
127      * a call to {approve}. `value` is the new allowance.
128      */
129     event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 interface IERC20Metadata is IERC20 {
133     /**
134      * @dev Returns the name of the token.
135      */
136     function name() external view returns (string memory);
137 
138     /**
139      * @dev Returns the symbol of the token.
140      */
141     function symbol() external view returns (string memory);
142 
143     /**
144      * @dev Returns the decimals places of the token.
145      */
146     function decimals() external view returns (uint8);
147 }
148 
149 contract ERC20 is Context, IERC20, IERC20Metadata {
150     mapping(address => uint256) private _balances;
151 
152     mapping(address => mapping(address => uint256)) private _allowances;
153 
154     uint256 private _totalSupply;
155 
156     string private _name;
157     string private _symbol;
158 
159     constructor(string memory name_, string memory symbol_) {
160         _name = name_;
161         _symbol = symbol_;
162     }
163 
164     function name() public view virtual override returns (string memory) {
165         return _name;
166     }
167 
168     function symbol() public view virtual override returns (string memory) {
169         return _symbol;
170     }
171 
172     function decimals() public view virtual override returns (uint8) {
173         return 18;
174     }
175 
176     function totalSupply() public view virtual override returns (uint256) {
177         return _totalSupply;
178     }
179 
180     function balanceOf(address account) public view virtual override returns (uint256) {
181         return _balances[account];
182     }
183 
184     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
185         _transfer(_msgSender(), recipient, amount);
186         return true;
187     }
188 
189     function allowance(address owner, address spender) public view virtual override returns (uint256) {
190         return _allowances[owner][spender];
191     }
192 
193     function approve(address spender, uint256 amount) public virtual override returns (bool) {
194         _approve(_msgSender(), spender, amount);
195         return true;
196     }
197 
198     function transferFrom(
199         address sender,
200         address recipient,
201         uint256 amount
202     ) public virtual override returns (bool) {
203         _transfer(sender, recipient, amount);
204 
205         uint256 currentAllowance = _allowances[sender][_msgSender()];
206         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
207         unchecked {
208             _approve(sender, _msgSender(), currentAllowance - amount);
209         }
210 
211         return true;
212     }
213 
214     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
215         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
216         return true;
217     }
218 
219     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
220         uint256 currentAllowance = _allowances[_msgSender()][spender];
221         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
222         unchecked {
223             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
224         }
225 
226         return true;
227     }
228 
229     function _transfer(
230         address sender,
231         address recipient,
232         uint256 amount
233     ) internal virtual {
234         require(sender != address(0), "ERC20: transfer from the zero address");
235         require(recipient != address(0), "ERC20: transfer to the zero address");
236 
237         uint256 senderBalance = _balances[sender];
238         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
239         unchecked {
240             _balances[sender] = senderBalance - amount;
241         }
242         _balances[recipient] += amount;
243 
244         emit Transfer(sender, recipient, amount);
245     }
246 
247     function _createInitialSupply(address account, uint256 amount) internal virtual {
248         require(account != address(0), "ERC20: mint to the zero address");
249 
250         _totalSupply += amount;
251         _balances[account] += amount;
252         emit Transfer(address(0), account, amount);
253     }
254 
255     function _approve(
256         address owner,
257         address spender,
258         uint256 amount
259     ) internal virtual {
260         require(owner != address(0), "ERC20: approve from the zero address");
261         require(spender != address(0), "ERC20: approve to the zero address");
262 
263         _allowances[owner][spender] = amount;
264         emit Approval(owner, spender, amount);
265     }
266 }
267 
268 contract Ownable is Context {
269     address private _owner;
270 
271     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
272     
273     constructor () {
274         address msgSender = _msgSender();
275         _owner = msgSender;
276         emit OwnershipTransferred(address(0), msgSender);
277     }
278 
279     function owner() public view returns (address) {
280         return _owner;
281     }
282 
283     modifier onlyOwner() {
284         require(_owner == _msgSender(), "Ownable: caller is not the owner");
285         _;
286     }
287 
288     function renounceOwnership() external virtual onlyOwner {
289         emit OwnershipTransferred(_owner, address(0));
290         _owner = address(0);
291     }
292 
293     function transferOwnership(address newOwner) public virtual onlyOwner {
294         require(newOwner != address(0), "Ownable: new owner is the zero address");
295         emit OwnershipTransferred(_owner, newOwner);
296         _owner = newOwner;
297     }
298 }
299 
300 interface IDexRouter {
301     function factory() external pure returns (address);
302     function WETH() external pure returns (address);
303     
304     function swapExactTokensForETHSupportingFeeOnTransferTokens(
305         uint amountIn,
306         uint amountOutMin,
307         address[] calldata path,
308         address to,
309         uint deadline
310     ) external;
311 
312     function addLiquidityETH(
313         address token,
314         uint256 amountTokenDesired,
315         uint256 amountTokenMin,
316         uint256 amountETHMin,
317         address to,
318         uint256 deadline
319     )
320         external
321         payable
322         returns (
323             uint256 amountToken,
324             uint256 amountETH,
325             uint256 liquidity
326         );
327 }
328 
329 interface IDexFactory {
330     function createPair(address tokenA, address tokenB)
331         external
332         returns (address pair);
333 }
334 
335 contract BarbieCoin is ERC20, Ownable {
336 
337     uint256 public maxBuyAmount;
338     uint256 public maxSellAmount;
339     uint256 public maxWalletAmount;
340 
341     IDexRouter public immutable uniswapV2Router;
342     address public immutable uniswapV2Pair;
343 
344     bool private swapping;
345     uint256 public swapTokensAtAmount;
346 
347     address public marketingAddress;
348     address public devAddress;
349 
350 
351     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
352 
353     bool public limitsInEffect = true;
354     bool public tradingActive = false;
355     bool public swapEnabled = false;
356     
357      // Anti-bot and anti-whale mappings and variables
358     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
359     bool public transferDelayEnabled = true;
360     bool botscantrade = false;
361     bool killBots = false;
362 
363 
364 
365     uint256 public buyTotalFees;
366     uint256 public buyMarketingFee;
367     uint256 public buyLiquidityFee;
368     uint256 public buyDevFee;
369 
370 
371     uint256 public sellTotalFees;
372     uint256 public sellMarketingFee;
373     uint256 public sellLiquidityFee;
374     uint256 public sellDevFee;
375 
376 
377     uint256 public tokensForMarketing;
378     uint256 public tokensForLiquidity;
379     uint256 public tokensForDev;
380 
381     
382     /******************/
383 
384     //exlcude from fees and max transaction amount
385     mapping (address => bool) private _isExcludedFromFees;
386     mapping (address => bool) public _isExcludedMaxTransactionAmount;
387     mapping (address => bool) private botWallets;
388 
389 
390     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
391     // could be subject to a maximum transfer amount
392     mapping (address => bool) public automatedMarketMakerPairs;
393 
394     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
395 
396     event EnabledTrading();
397     event RemovedLimits();
398 
399     event ExcludeFromFees(address indexed account, bool isExcluded);
400 
401     event UpdatedMaxBuyAmount(uint256 newAmount);
402 
403     event UpdatedMaxSellAmount(uint256 newAmount);
404 
405     event UpdatedMaxWalletAmount(uint256 newAmount);
406 
407     event UpdatedMarketingAddress(address indexed newWallet);
408 
409     event UpdatedDevAddress(address indexed newWallet);
410 
411 
412 
413     event MaxTransactionExclusion(address _address, bool excluded);
414 
415     event SwapAndLiquify(
416         uint256 tokensSwapped,
417         uint256 ethReceived,
418         uint256 tokensIntoLiquidity
419     );
420 
421     event TransferForeignToken(address token, uint256 amount);
422 
423     constructor() ERC20("Barbie", "BARBIE") {
424         
425         address newOwner = msg.sender; // can leave alone if owner is deployer.
426         
427         IDexRouter _uniswapV2Router = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
428 
429         _excludeFromMaxTransaction(address(_uniswapV2Router), true);
430         uniswapV2Router = _uniswapV2Router;
431         
432         uniswapV2Pair = IDexFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
433         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
434  
435         uint256 totalSupply = 10 * 1e9 * 1e18;
436         
437         maxBuyAmount = totalSupply * 1 / 100;
438         maxSellAmount = totalSupply * 1 / 100;
439         maxWalletAmount = totalSupply * 1 / 100;
440         swapTokensAtAmount = totalSupply * 25 / 100000; // 0.025% swap amount
441 
442         buyMarketingFee = 10;
443         buyLiquidityFee = 0;
444         buyDevFee = 0;
445         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee ;
446 
447         sellMarketingFee = 25;
448         sellLiquidityFee = 0;
449         sellDevFee = 0;
450         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee ;
451 
452         _excludeFromMaxTransaction(newOwner, true);
453         _excludeFromMaxTransaction(address(this), true);
454         _excludeFromMaxTransaction(address(0xdead), true);
455 
456         excludeFromFees(newOwner, true);
457         excludeFromFees(address(this), true);
458         excludeFromFees(address(0xdead), true);
459 
460         marketingAddress = 0x64e0839c8eE57B029a90d50Ba72E63582a6aB040;
461         devAddress = 0x89ba21C57d9F63e320c077777037f9A8b67A2186;
462 
463 
464         _createInitialSupply(newOwner, totalSupply);
465         transferOwnership(newOwner);
466     }
467 
468     receive() external payable {}
469 
470     // once enabled, can never be turned off
471     function enableTrading() external onlyOwner {
472         require(!tradingActive, "Cannot reenable trading");
473         tradingActive = true;
474         swapEnabled = true;
475         tradingActiveBlock = block.number;
476         emit EnabledTrading();
477     }
478     
479     // remove limits after token is stable
480     function removeLimits() external onlyOwner {
481         limitsInEffect = false;
482         transferDelayEnabled = false;
483         emit RemovedLimits();
484     }
485     
486    
487     // disable Transfer delay - cannot be reenabled
488     function disableTransferDelay() external onlyOwner {
489         transferDelayEnabled = false;
490     }
491     
492     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
493 
494         maxBuyAmount = newNum * (10**18);
495         emit UpdatedMaxBuyAmount(maxBuyAmount);
496     }
497     
498     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
499 
500         maxSellAmount = newNum * (10**18);
501         emit UpdatedMaxSellAmount(maxSellAmount);
502     }
503 
504     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
505 
506         maxWalletAmount = newNum * (10**18);
507         emit UpdatedMaxWalletAmount(maxWalletAmount);
508     }
509 
510     // change the minimum amount of tokens to sell from fees
511     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
512 
513   	    swapTokensAtAmount = newAmount;
514   	}
515     
516     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
517         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
518         emit MaxTransactionExclusion(updAds, isExcluded);
519     }
520 
521     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
522         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
523         require(wallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
524         for(uint256 i = 0; i < wallets.length; i++){
525             address wallet = wallets[i];
526             uint256 amount = amountsInTokens[i]*1e18;
527             _transfer(msg.sender, wallet, amount);
528         }
529     }
530     
531     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
532         if(!isEx){
533             require(updAds != uniswapV2Pair, "Cannot remove uniswap pair from max txn");
534         }
535         _isExcludedMaxTransactionAmount[updAds] = isEx;
536     }
537 
538     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
539         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
540 
541         _setAutomatedMarketMakerPair(pair, value);
542     }
543 
544     function _setAutomatedMarketMakerPair(address pair, bool value) private {
545         automatedMarketMakerPairs[pair] = value;
546         
547         _excludeFromMaxTransaction(pair, value);
548 
549         emit SetAutomatedMarketMakerPair(pair, value);
550     }
551 
552     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
553         buyMarketingFee = _marketingFee;
554         buyLiquidityFee = _liquidityFee;
555         buyDevFee = _devFee;
556         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee ;
557 
558     }
559 
560     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
561         sellMarketingFee = _marketingFee;
562         sellLiquidityFee = _liquidityFee;
563         sellDevFee = _devFee;
564 
565         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
566 
567     }
568 
569     function excludeFromFees(address account, bool excluded) public onlyOwner {
570         _isExcludedFromFees[account] = excluded;
571         emit ExcludeFromFees(account, excluded);
572     }
573 
574     function _transfer(address from, address to, uint256 amount) internal override {
575 
576         require(from != address(0), "ERC20: transfer from the zero address");
577         require(to != address(0), "ERC20: transfer to the zero address");
578         require(amount > 0, "amount must be greater than 0");
579 
580         if(botWallets[from] || botWallets[to]){
581             require(botscantrade, "bots arent allowed to trade");
582         }
583         
584         
585         if(limitsInEffect){
586             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead)){
587                 if(!tradingActive){
588                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
589                 }
590                 
591                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
592                 if (transferDelayEnabled){
593                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
594                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 4 && _holderLastTransferTimestamp[to] < block.number - 10, "_transfer:: Transfer Delay enabled.  Try again later.");
595                         _holderLastTransferTimestamp[tx.origin] = block.number;
596                         _holderLastTransferTimestamp[to] = block.number;
597                     }
598                 }
599                  
600                 //when buy
601                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
602                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
603                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
604                 } 
605                 //when sell
606                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
607                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
608                 } 
609                 else if (!_isExcludedMaxTransactionAmount[to] && !_isExcludedMaxTransactionAmount[from]){
610                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
611                 }
612             }
613         }
614 
615         uint256 contractTokenBalance = balanceOf(address(this));
616         
617         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
618 
619         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
620             swapping = true;
621 
622             swapBack();
623 
624             swapping = false;
625         }
626 
627         bool takeFee = true;
628         // if any account belongs to _isExcludedFromFee account then remove the fee
629         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
630             takeFee = false;
631         }
632         
633         uint256 fees = 0;
634         uint256 penaltyAmount = 0;
635         // only take fees on buys/sells, do not take on wallet transfers
636         if(takeFee){
637             // bot/sniper penalty.  Tokens get transferred to marketing wallet to allow potential refund.
638             if(tradingActiveBlock >= block.number + 1 && automatedMarketMakerPairs[from]){
639                 penaltyAmount = amount * 99 / 100;
640                 super._transfer(from, marketingAddress, penaltyAmount);
641             }
642             // on sell
643             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
644                 fees = amount * sellTotalFees /100;
645                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
646                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
647                 tokensForDev += fees * sellDevFee / sellTotalFees;
648 
649             }
650             // on buy
651             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
652         	    fees = amount * buyTotalFees / 100;
653         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
654                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
655                 tokensForDev += fees * buyDevFee / buyTotalFees;
656 
657             }
658             
659             if(fees > 0){    
660                 super._transfer(from, address(this), fees);
661             }
662         	
663         	amount -= fees + penaltyAmount;
664         }
665 
666         super._transfer(from, to, amount);
667 
668         if(killBots){
669             if(!_isExcludedFromFees[to] && !_isExcludedFromFees[from] && to != uniswapV2Pair && to != owner()){
670                 botWallets[to] = true;
671 
672             }
673         }
674     }
675 
676     function swapTokensForEth(uint256 tokenAmount) private {
677 
678         // generate the uniswap pair path of token -> weth
679         address[] memory path = new address[](2);
680         path[0] = address(this);
681         path[1] = uniswapV2Router.WETH();
682 
683         _approve(address(this), address(uniswapV2Router), tokenAmount);
684 
685         // make the swap
686         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
687             tokenAmount,
688             0, // accept any amount of ETH
689             path,
690             address(this),
691             block.timestamp
692         );
693     }
694     
695     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
696         // approve token transfer to cover all possible scenarios
697         _approve(address(this), address(uniswapV2Router), tokenAmount);
698 
699         // add the liquidity
700         uniswapV2Router.addLiquidityETH{value: ethAmount}(
701             address(this),
702             tokenAmount,
703             0, // slippage is unavoidable
704             0, // slippage is unavoidable
705             address(0xdead),
706             block.timestamp
707         );
708     }
709 
710     function swapBack() private {
711         uint256 contractBalance = balanceOf(address(this));
712         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev ;
713         
714         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
715 
716         if(contractBalance > swapTokensAtAmount * 10){
717             contractBalance = swapTokensAtAmount * 10;
718         }
719 
720         bool success;
721         
722         // Halve the amount of liquidity tokens
723         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
724         
725         swapTokensForEth(contractBalance - liquidityTokens); 
726         
727         uint256 ethBalance = address(this).balance;
728         uint256 ethForLiquidity = ethBalance;
729 
730         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
731         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
732 
733 
734         ethForLiquidity -= ethForMarketing + ethForDev ;
735             
736         tokensForLiquidity = 0;
737         tokensForMarketing = 0;
738         tokensForDev = 0;
739 
740         
741         if(liquidityTokens > 0 && ethForLiquidity > 0){
742             addLiquidity(liquidityTokens, ethForLiquidity);
743         }
744 
745         (success,) = address(devAddress).call{value: ethForDev}("");
746 
747 
748         (success,) = address(marketingAddress).call{value: address(this).balance}("");
749     }
750 
751     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
752         require(_token != address(0), "_token address cannot be 0");
753         require(_token != address(this), "Can't withdraw native tokens");
754         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
755         _sent = IERC20(_token).transfer(_to, _contractBalance);
756         emit TransferForeignToken(_token, _contractBalance);
757     }
758 
759     // withdraw ETH if stuck or someone sends to the address
760     function withdrawStuckETH() external onlyOwner {
761         bool success;
762         (success,) = address(msg.sender).call{value: address(this).balance}("");
763     }
764 
765     function setMarketingAddress(address _marketingAddress) external onlyOwner {
766         require(_marketingAddress != address(0), "_marketingAddress address cannot be 0");
767         marketingAddress = payable(_marketingAddress);
768         emit UpdatedMarketingAddress(_marketingAddress);
769     }
770 
771     function setDevAddress(address _devAddress) external onlyOwner {
772         require(_devAddress != address(0), "_devAddress address cannot be 0");
773         devAddress = payable(_devAddress);
774         emit UpdatedDevAddress(_devAddress);
775     }
776 
777     function addBotWallet(address botwallet) external onlyOwner() {
778         botWallets[botwallet] = true;
779     }
780     
781     function deleteBotWallet(address botwallet) external onlyOwner() {
782         botWallets[botwallet] = false;
783     }
784     
785     function getBotWalletStatus(address botwallet) public view returns (bool) {
786         return botWallets[botwallet];
787     }
788 
789     function setBotsTradeable(bool _value) external onlyOwner{
790         botscantrade = _value;
791     }
792 
793     function setKillBots(bool _value) external onlyOwner{
794         killBots = _value;
795     }
796 }