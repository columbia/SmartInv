1 /**
2 
3 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⡠⠤⠤⠤⠤⠤⠤⠤⠤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
4 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⠴⠖⠏⠋⢁⣀⣀⠤⠤⠤⠤⠤⠤⣀⣄⡀⠉⠑⠒⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
5 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⠾⢋⣉⣤⠔⠚⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠚⠶⣴⣍⡻⣶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6 ⠀⠀⠀⠀⠀⠀⠀⠀⣠⡾⢛⣠⡾⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⢦⣝⡿⣦⡀⠀⠀⠀⠀⠀⠀⠀
7 ⠀⠀⠀⠀⠀⠀⣠⡾⢋⣴⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⣎⠻⡦⡀⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⢀⣼⠋⢐⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢮⡈⢿⣆⠀⠀⠀⠀
9 ⠀⠀⠀⢀⡾⠁⣠⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠱⡄⠹⣧⠀⠀⠀
10 ⠀⠀⢠⡾⠁⡰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡆⠹⢧⠀⠀
11 ⠀⠀⣾⠁⢰⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣴⣶⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣶⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡄⢇⠀
12 ⠀⢸⡏⠀⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⠸⡄
13 ⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⢰⢧
14 ⢰⡛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠿⣿⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠿⣿⡿⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⡛⢰
15 ⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ⢸⡇
16 ⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ⢸⡇
17 ⠈⣦⠀⠀⠀⠀⠀⠀⠀⢀⣴⣶⠿⣿⠿⠷⠶⠷⠿⡾⠷⠾⠿⠿⢿⠾⠾⠿⠿⠾⢿⠾⠾⠿⠿⠿⢿⢷⣶⣄⠀⠀⠀⠀ ⠈
18 ⠀⢻⡄⠀⠀⠀⠀⠀⢀⣿⠟⠁⠀⣿⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⢸⠀    ⠈⢿⣧⠀⠀⠀ ⢻
19 ⠀⠘⣅⠀⠀⠀⠀⠀⢸⣿⣤⣤⣤⣿⣤⣤⣤⣤⣤⣧⣤⣤⣤⣤⣼⣤⣤⣤⣤⣤⣼⣤⣤⣤⣤⣤⣼⣤⣤⣼⣿⠀⠀⠀ ⢸⠀
20 ⠀⠀⠱⡀⠀⠀⠀⠀⠸⣿⡀⠀⠀⣿⠀⠀⠀⠀⠈⡇⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠘⠀    ⠀⣸⣿⠀⠀⠀⢠⠃⠀
21 ⠀⠀⠀⢱⡄⠀⠀⠀⠀⠻⣿⣴⣀⣿⣀⣀⣀⣀⣇⡀⠀⠀⣀⢸⡀⠀⠀⣀⣀⣸⣀⣀⣀⣀⣸⣀⣀⣀⣀⡴⡿⠃⠀⠀⢠⠃⠀⠀
22 ⠀⠀⠀⠀⢻⣦⡀⠀⠀⠀⠈⣏⡼⡅⠄⠒⢙⡟⠛⣏⠟⠛⠛⠛⠯⢭⡛⠛⠛⠋⠻⠉⠓⠲⠀⠬⢉⠀⡴⠁⠀⠀⠀⡰⠃⠀⠀⠀
23 ⠀⠀⠀⠀⠘⣿⡵⣄⠀⠀⠀⠙⠀⣇⢀⠀⣸⠀⠀⠈⠀⠀⠀⠀⠀⠀⠙⣇⠠⢰⡷⠦⠴⡄⠀⣼⢹⢀⠁⠀⠀⠀⢠⡼⠁⠀⠀⠀⠀
24 ⠀⠀⠀⠀⠀⣿⠓⢬⣦⡀⠀⠀⠀⢻⠸⠀⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡄⡜⠀⠀⠀⢾⠀⡇⠀⣿⠀⠀⢀⡴⢱⠁⠀⠀⠀⠀⠀
25 ⠀⠀⠀⠀⠀⢹⡤⡿⠈⢫⢲⣄⠀⠈⡆⢰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣧⡇⠀⠀⠀⢸⠀⡏⠀⡀⣠⣶⡭⢒⡇⠀⠀⠀⠀⠀⠀
26 ⠀⠀⠀⠀⠀⠸⣶⡇⠀⢸⣀⠞⠑⠲⣧⡎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⢸⡄⡧⠖⠉⠀⠈⠹⡏⡇⠀⠀⠀⠀⠀⠀
27 ⠀⠀⠀⠀⠀⠀⠈⠀⠀⠈⠁⠀⠀⠀⠃⠋⠉⠒⠢⢔⠄⢀⣀⣀⣀⣀⣀⠀⠀⠀⠀⡶⠚⠙⣧⠃⠀⠀⠀⠀⠀⡇⡇⠀⠀⠀⠀⠀⠀
28 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠃⠁⠀⠀⠀⠀⠀⠀
29 
30 Telegram: https://t.me/BrrrPortal
31 
32 Twitter: https://twitter.com/BrrrOfficial
33 
34 Bʀʀʀ sᴜᴘᴘʟʏ ɢᴏᴇs Bʀʀʀʀʀʀʀʀʀʀ
35 
36 */
37 
38 
39 // SPDX-License-Identifier: MIT
40 
41 pragma solidity 0.8.15;
42 
43 abstract contract Context {
44     function _msgSender() internal view virtual returns (address) {
45         return msg.sender;
46     }
47 
48     function _msgData() internal view virtual returns (bytes calldata) {
49         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
50         return msg.data;
51     }
52 }
53 
54 interface IERC20 {
55     /**
56      * @dev Returns the amount of tokens in existence.
57      */
58     function totalSupply() external view returns (uint256);
59 
60     /**
61      * @dev Returns the amount of tokens owned by `account`.
62      */
63     function balanceOf(address account) external view returns (uint256);
64 
65     /**
66      * @dev Moves `amount` tokens from the caller's account to `recipient`.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * Emits a {Transfer} event.
71      */
72     function transfer(address recipient, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Returns the remaining number of tokens that `spender` will be
76      * allowed to spend on behalf of `owner` through {transferFrom}. This is
77      * zero by default.
78      *
79      * This value changes when {approve} or {transferFrom} are called.
80      */
81     function allowance(address owner, address spender) external view returns (uint256);
82 
83     /**
84      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * IMPORTANT: Beware that changing an allowance with this method brings the risk
89      * that someone may use both the old and the new allowance by unfortunate
90      * transaction ordering. One possible solution to mitigate this race
91      * condition is to first reduce the spender's allowance to 0 and set the
92      * desired value afterwards:
93      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
94      *
95      * Emits an {Approval} event.
96      */
97     function approve(address spender, uint256 amount) external returns (bool);
98 
99     /**
100      * @dev Moves `amount` tokens from `sender` to `recipient` using the
101      * allowance mechanism. `amount` is then deducted from the caller's
102      * allowance.
103      *
104      * Returns a boolean value indicating whether the operation succeeded.
105      *
106      * Emits a {Transfer} event.
107      */
108     function transferFrom(
109         address sender,
110         address recipient,
111         uint256 amount
112     ) external returns (bool);
113 
114     /**
115      * @dev Emitted when `value` tokens are moved from one account (`from`) to
116      * another (`to`).
117      *
118      * Note that `value` may be zero.
119      */
120     event Transfer(address indexed from, address indexed to, uint256 value);
121 
122     /**
123      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
124      * a call to {approve}. `value` is the new allowance.
125      */
126     event Approval(address indexed owner, address indexed spender, uint256 value);
127 }
128 
129 interface IERC20Metadata is IERC20 {
130     /**
131      * @dev Returns the name of the token.
132      */
133     function name() external view returns (string memory);
134 
135     /**
136      * @dev Returns the symbol of the token.
137      */
138     function symbol() external view returns (string memory);
139 
140     /**
141      * @dev Returns the decimals places of the token.
142      */
143     function decimals() external view returns (uint8);
144 }
145 
146 contract ERC20 is Context, IERC20, IERC20Metadata {
147     mapping(address => uint256) private _balances;
148 
149     mapping(address => mapping(address => uint256)) private _allowances;
150 
151     uint256 private _totalSupply;
152 
153     string private _name;
154     string private _symbol;
155 
156     constructor(string memory name_, string memory symbol_) {
157         _name = name_;
158         _symbol = symbol_;
159     }
160 
161     function name() public view virtual override returns (string memory) {
162         return _name;
163     }
164 
165     function symbol() public view virtual override returns (string memory) {
166         return _symbol;
167     }
168 
169     function decimals() public view virtual override returns (uint8) {
170         return 18;
171     }
172 
173     function totalSupply() public view virtual override returns (uint256) {
174         return _totalSupply;
175     }
176 
177     function balanceOf(address account) public view virtual override returns (uint256) {
178         return _balances[account];
179     }
180 
181     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
182         _transfer(_msgSender(), recipient, amount);
183         return true;
184     }
185 
186     function allowance(address owner, address spender) public view virtual override returns (uint256) {
187         return _allowances[owner][spender];
188     }
189 
190     function approve(address spender, uint256 amount) public virtual override returns (bool) {
191         _approve(_msgSender(), spender, amount);
192         return true;
193     }
194 
195     function transferFrom(
196         address sender,
197         address recipient,
198         uint256 amount
199     ) public virtual override returns (bool) {
200         _transfer(sender, recipient, amount);
201 
202         uint256 currentAllowance = _allowances[sender][_msgSender()];
203         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
204         unchecked {
205             _approve(sender, _msgSender(), currentAllowance - amount);
206         }
207 
208         return true;
209     }
210 
211     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
212         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
213         return true;
214     }
215 
216     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
217         uint256 currentAllowance = _allowances[_msgSender()][spender];
218         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
219         unchecked {
220             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
221         }
222 
223         return true;
224     }
225 
226     function _transfer(
227         address sender,
228         address recipient,
229         uint256 amount
230     ) internal virtual {
231         require(sender != address(0), "ERC20: transfer from the zero address");
232         require(recipient != address(0), "ERC20: transfer to the zero address");
233 
234         uint256 senderBalance = _balances[sender];
235         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
236         unchecked {
237             _balances[sender] = senderBalance - amount;
238         }
239         _balances[recipient] += amount;
240 
241         emit Transfer(sender, recipient, amount);
242     }
243 
244     function _createInitialSupply(address account, uint256 amount) internal virtual {
245         require(account != address(0), "ERC20: mint to the zero address");
246 
247         _totalSupply += amount;
248         _balances[account] += amount;
249         emit Transfer(address(0), account, amount);
250     }
251 
252     function _approve(
253         address owner,
254         address spender,
255         uint256 amount
256     ) internal virtual {
257         require(owner != address(0), "ERC20: approve from the zero address");
258         require(spender != address(0), "ERC20: approve to the zero address");
259 
260         _allowances[owner][spender] = amount;
261         emit Approval(owner, spender, amount);
262     }
263 }
264 
265 contract Ownable is Context {
266     address private _owner;
267 
268     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
269 
270     constructor () {
271         address msgSender = _msgSender();
272         _owner = msgSender;
273         emit OwnershipTransferred(address(0), msgSender);
274     }
275 
276     function owner() public view returns (address) {
277         return _owner;
278     }
279 
280     modifier onlyOwner() {
281         require(_owner == _msgSender(), "Ownable: caller is not the owner");
282         _;
283     }
284 
285     function renounceOwnership() external virtual onlyOwner {
286         emit OwnershipTransferred(_owner, address(0));
287         _owner = address(0);
288     }
289 
290     function transferOwnership(address newOwner) public virtual onlyOwner {
291         require(newOwner != address(0), "Ownable: new owner is the zero address");
292         emit OwnershipTransferred(_owner, newOwner);
293         _owner = newOwner;
294     }
295 }
296 
297 interface IDexRouter {
298     function factory() external pure returns (address);
299     function WETH() external pure returns (address);
300 
301     function swapExactTokensForETHSupportingFeeOnTransferTokens(
302         uint amountIn,
303         uint amountOutMin,
304         address[] calldata path,
305         address to,
306         uint deadline
307     ) external;
308 
309     function swapExactETHForTokensSupportingFeeOnTransferTokens(
310         uint amountOutMin,
311         address[] calldata path,
312         address to,
313         uint deadline
314     ) external payable;
315 
316     function addLiquidityETH(
317         address token,
318         uint256 amountTokenDesired,
319         uint256 amountTokenMin,
320         uint256 amountETHMin,
321         address to,
322         uint256 deadline
323     )
324         external
325         payable
326         returns (
327             uint256 amountToken,
328             uint256 amountETH,
329             uint256 liquidity
330         );
331 }
332 
333 interface IDexFactory {
334     function createPair(address tokenA, address tokenB)
335         external
336         returns (address pair);
337 }
338 
339 contract Brrr is ERC20, Ownable {
340 
341     uint256 public maxBuyAmount;
342     uint256 public maxSellAmount;
343     uint256 public maxWalletAmount;
344 
345     IDexRouter public dexRouter;
346     address public lpPair;
347 
348     bool private swapping;
349     uint256 public swapTokensAtAmount;
350 
351     address marketingAddress;
352     address devAddress;
353 
354     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
355     uint256 public blockForPenaltyEnd;
356     mapping (address => bool) public boughtEarly;
357     uint256 public botsCaught;
358 
359     bool public limitsInEffect = true;
360     bool public tradingActive = false;
361     bool public swapEnabled = false;
362 
363      // Anti-bot and anti-whale mappings and variables
364     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
365     bool public transferDelayEnabled = true;
366 
367     uint256 public buyTotalFees;
368     uint256 public buyMarketingFee;
369     uint256 public buyLiquidityFee;
370     uint256 public buyDevFee;
371     uint256 public buyFreezeFee;
372 
373     uint256 public sellTotalFees;
374     uint256 public sellMarketingFee;
375     uint256 public sellLiquidityFee;
376     uint256 public sellDevFee;
377     uint256 public sellFreezeFee;
378 
379     uint256 public tokensForMarketing;
380     uint256 public tokensForLiquidity;
381     uint256 public tokensForDev;
382     uint256 public tokensForFreeze;
383 
384     /******************/
385 
386     // exlcude from fees and max transaction amount
387     mapping (address => bool) private _isExcludedFromFees;
388     mapping (address => bool) public _isExcludedMaxTransactionAmount;
389 
390     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
391     // could be subject to a maximum transfer amount
392     mapping (address => bool) public automatedMarketMakerPairs;
393 
394     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
395 
396     event EnabledTrading();
397 
398     event RemovedLimits();
399 
400     event ExcludeFromFees(address indexed account, bool isExcluded);
401 
402     event UpdatedMaxBuyAmount(uint256 newAmount);
403 
404     event UpdatedMaxSellAmount(uint256 newAmount);
405 
406     event UpdatedMaxWalletAmount(uint256 newAmount);
407 
408     event UpdatedMarketingAddress(address indexed newWallet);
409 
410     event MaxTransactionExclusion(address _address, bool excluded);
411 
412     event BuyBackTriggered(uint256 amount);
413 
414     event OwnerForcedSwapBack(uint256 timestamp);
415 
416     event CaughtEarlyBuyer(address sniper);
417 
418     event SwapAndLiquify(
419         uint256 tokensSwapped,
420         uint256 ethReceived,
421         uint256 tokensIntoLiquidity
422     );
423 
424     event TransferForeignToken(address token, uint256 amount);
425 
426     constructor() ERC20("Brrr", "Brrr") {
427 
428         address newOwner = msg.sender; // can leave alone if owner is deployer.
429 
430         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
431         dexRouter = _dexRouter;
432 
433         // create pair
434         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
435         _excludeFromMaxTransaction(address(lpPair), true);
436         _setAutomatedMarketMakerPair(address(lpPair), true);
437 
438         uint256 totalSupply = 1 * 1e6 * 1e18;
439 
440         maxBuyAmount = totalSupply * 2 / 100; // 2%
441         maxSellAmount = totalSupply * 2 / 100; // 2%
442         maxWalletAmount = totalSupply * 2 / 100; // 2%
443         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.5%
444 
445         buyMarketingFee = 0;
446         buyLiquidityFee = 0;
447         buyDevFee = 0;
448         buyFreezeFee = 2;
449         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyFreezeFee;
450 
451         sellMarketingFee = 4;
452         sellLiquidityFee = 0;
453         sellDevFee = 0;
454         sellFreezeFee = 2;
455         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellFreezeFee;
456 
457         _excludeFromMaxTransaction(newOwner, true);
458         _excludeFromMaxTransaction(address(this), true);
459         _excludeFromMaxTransaction(address(0xdead), true);
460 
461         excludeFromFees(newOwner, true);
462         excludeFromFees(address(this), true);
463         excludeFromFees(address(0xdead), true);
464 
465         marketingAddress = 0x7ecd5028618ED339aD672dD363a81f40999114C3;
466         devAddress = address(newOwner);
467 
468         _createInitialSupply(newOwner, totalSupply);
469         transferOwnership(newOwner);
470     }
471 
472     receive() external payable {}
473 
474     // only enable if no plan to airdrop
475 
476     function enableTrading() external onlyOwner {
477         require(!tradingActive, "Cannot reenable trading");
478         tradingActive = true;
479         swapEnabled = true;
480         tradingActiveBlock = block.number;
481         blockForPenaltyEnd = tradingActiveBlock + 1;
482         emit EnabledTrading();
483     }
484 
485     // remove limits after token is stable
486     function removeLimits() external onlyOwner {
487         limitsInEffect = false;
488         transferDelayEnabled = false;
489         emit RemovedLimits();
490     }
491 
492     function removeBoughtEarly(address wallet) external onlyOwner {
493         require(boughtEarly[wallet], "Wallet is already not flagged.");
494         boughtEarly[wallet] = false;
495     }
496 
497     // disable Transfer delay - cannot be reenabled
498     function disableTransferDelay() external onlyOwner {
499         transferDelayEnabled = false;
500     }
501 
502     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
503         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
504         maxBuyAmount = newNum * (10**18);
505         emit UpdatedMaxBuyAmount(maxBuyAmount);
506     }
507 
508     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
509         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
510         maxSellAmount = newNum * (10**18);
511         emit UpdatedMaxSellAmount(maxSellAmount);
512     }
513 
514     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
515         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
516         maxWalletAmount = newNum * (10**18);
517         emit UpdatedMaxWalletAmount(maxWalletAmount);
518     }
519 
520     // change the minimum amount of tokens to sell from fees
521     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
522   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
523   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
524   	    swapTokensAtAmount = newAmount;
525   	}
526 
527     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
528         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
529         emit MaxTransactionExclusion(updAds, isExcluded);
530     }
531 
532     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
533         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
534         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
535         for(uint256 i = 0; i < wallets.length; i++){
536             address wallet = wallets[i];
537             uint256 amount = amountsInTokens[i];
538             super._transfer(msg.sender, wallet, amount);
539         }
540     }
541 
542     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
543         if(!isEx){
544             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
545         }
546         _isExcludedMaxTransactionAmount[updAds] = isEx;
547     }
548 
549     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
550         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
551 
552         _setAutomatedMarketMakerPair(pair, value);
553         emit SetAutomatedMarketMakerPair(pair, value);
554     }
555 
556     function _setAutomatedMarketMakerPair(address pair, bool value) private {
557         automatedMarketMakerPairs[pair] = value;
558 
559         _excludeFromMaxTransaction(pair, value);
560 
561         emit SetAutomatedMarketMakerPair(pair, value);
562     }
563 
564     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _freezeFee) external onlyOwner {
565         buyMarketingFee = _marketingFee;
566         buyLiquidityFee = _liquidityFee;
567         buyDevFee = _devFee;
568         buyFreezeFee = _freezeFee;
569         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyFreezeFee;
570         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
571     }
572 
573     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _freezeFee) external onlyOwner {
574         sellMarketingFee = _marketingFee;
575         sellLiquidityFee = _liquidityFee;
576         sellDevFee = _devFee;
577         sellFreezeFee = _freezeFee;
578         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellFreezeFee;
579         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
580     }
581 
582     function returnToNormalTax() external onlyOwner {
583         sellMarketingFee = 0;
584         sellLiquidityFee = 3;
585         sellDevFee = 0;
586         sellFreezeFee = 3;
587         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellFreezeFee;
588         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
589 
590         buyMarketingFee = 0;
591         buyLiquidityFee = 3;
592         buyDevFee = 0;
593         buyFreezeFee = 3;
594         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyFreezeFee;
595         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
596     }
597 
598     function excludeFromFees(address account, bool excluded) public onlyOwner {
599         _isExcludedFromFees[account] = excluded;
600         emit ExcludeFromFees(account, excluded);
601     }
602 
603     function _transfer(address from, address to, uint256 amount) internal override {
604 
605         require(from != address(0), "ERC20: transfer from the zero address");
606         require(to != address(0), "ERC20: transfer to the zero address");
607         require(amount > 0, "amount must be greater than 0");
608 
609         if(!tradingActive){
610             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
611         }
612 
613         if(!earlyBuyPenaltyInEffect() && blockForPenaltyEnd > 0){
614             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
615         }
616 
617         if(limitsInEffect){
618             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
619 
620                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
621                 if (transferDelayEnabled){
622                     if (to != address(dexRouter) && to != address(lpPair)){
623                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
624                         _holderLastTransferTimestamp[tx.origin] = block.number;
625                         _holderLastTransferTimestamp[to] = block.number;
626                     }
627                 }
628 
629                 //when buy
630                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
631                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
632                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
633                 }
634                 //when sell
635                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
636                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
637                 }
638                 else if (!_isExcludedMaxTransactionAmount[to]){
639                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
640                 }
641             }
642         }
643 
644         uint256 contractTokenBalance = balanceOf(address(this));
645 
646         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
647 
648         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
649             swapping = true;
650 
651             swapBack();
652 
653             swapping = false;
654         }
655 
656         bool takeFee = true;
657         // if any account belongs to _isExcludedFromFee account then remove the fee
658         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
659             takeFee = false;
660         }
661 
662         uint256 fees = 0;
663         // only take fees on buys/sells, do not take on wallet transfers
664         if(takeFee){
665             // bot/sniper penalty.
666             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
667 
668                 if(!boughtEarly[to]){
669                     boughtEarly[to] = true;
670                     botsCaught += 1;
671                     emit CaughtEarlyBuyer(to);
672                 }
673 
674                 fees = amount * buyTotalFees / 100;
675         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
676                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
677                 tokensForDev += fees * buyDevFee / buyTotalFees;
678                 tokensForFreeze += fees * buyFreezeFee / buyTotalFees;
679             }
680 
681             // on sell
682             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
683                 fees = amount * sellTotalFees / 100;
684                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
685                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
686                 tokensForDev += fees * sellDevFee / sellTotalFees;
687                 tokensForFreeze += fees * sellFreezeFee / sellTotalFees;
688             }
689 
690             // on buy
691             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
692         	    fees = amount * buyTotalFees / 100;
693         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
694                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
695                 tokensForDev += fees * buyDevFee / buyTotalFees;
696                 tokensForFreeze += fees * buyFreezeFee / buyTotalFees;
697             }
698 
699             if(fees > 0){
700                 super._transfer(from, address(this), fees);
701             }
702 
703         	amount -= fees;
704         }
705 
706         super._transfer(from, to, amount);
707     }
708 
709     function earlyBuyPenaltyInEffect() public view returns (bool){
710         return block.number < blockForPenaltyEnd;
711     }
712 
713     function swapTokensForEth(uint256 tokenAmount) private {
714 
715         // generate the uniswap pair path of token -> weth
716         address[] memory path = new address[](2);
717         path[0] = address(this);
718         path[1] = dexRouter.WETH();
719 
720         _approve(address(this), address(dexRouter), tokenAmount);
721 
722         // make the swap
723         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
724             tokenAmount,
725             0, // accept any amount of ETH
726             path,
727             address(this),
728             block.timestamp
729         );
730     }
731 
732     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
733         // approve token transfer to cover all possible scenarios
734         _approve(address(this), address(dexRouter), tokenAmount);
735 
736         // add the liquidity
737         dexRouter.addLiquidityETH{value: ethAmount}(
738             address(this),
739             tokenAmount,
740             0, // slippage is unavoidable
741             0, // slippage is unavoidable
742             address(0xdead),
743             block.timestamp
744         );
745     }
746 
747     function swapBack() private {
748 
749         if(tokensForFreeze > 0 && balanceOf(address(this)) >= tokensForFreeze) {
750             super._transfer(address(this), address(0xdead), tokensForFreeze);
751         }
752         tokensForFreeze = 0;
753 
754         uint256 contractBalance = balanceOf(address(this));
755         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
756 
757         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
758 
759         if(contractBalance > swapTokensAtAmount * 20){
760             contractBalance = swapTokensAtAmount * 20;
761         }
762 
763         bool success;
764 
765         // Halve the amount of liquidity tokens
766         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
767 
768         swapTokensForEth(contractBalance - liquidityTokens);
769 
770         uint256 ethBalance = address(this).balance;
771         uint256 ethForLiquidity = ethBalance;
772 
773         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
774         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
775 
776         ethForLiquidity -= ethForMarketing + ethForDev;
777 
778         tokensForLiquidity = 0;
779         tokensForMarketing = 0;
780         tokensForDev = 0;
781         tokensForFreeze = 0;
782 
783         if(liquidityTokens > 0 && ethForLiquidity > 0){
784             addLiquidity(liquidityTokens, ethForLiquidity);
785         }
786 
787         (success,) = address(devAddress).call{value: ethForDev}("");
788 
789         (success,) = address(marketingAddress).call{value: address(this).balance}("");
790     }
791 
792     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
793         require(_token != address(0), "_token address cannot be 0");
794         require(_token != address(this), "Can't withdraw native tokens");
795         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
796         _sent = IERC20(_token).transfer(_to, _contractBalance);
797         emit TransferForeignToken(_token, _contractBalance);
798     }
799 
800     // withdraw ETH if stuck or someone sends to the address
801     function withdrawStuckETH() external onlyOwner {
802         bool success;
803         (success,) = address(msg.sender).call{value: address(this).balance}("");
804     }
805 
806     function setMarketingAddress(address _marketingAddress) external onlyOwner {
807         require(_marketingAddress != address(0), "_marketingAddress address cannot be 0");
808         marketingAddress = payable(_marketingAddress);
809     }
810 
811     function setDevAddress(address _devAddress) external onlyOwner {
812         require(_devAddress != address(0), "_devAddress address cannot be 0");
813         devAddress = payable(_devAddress);
814     }
815 
816     // force Swap back if slippage issues.
817     function forceSwapBack() external onlyOwner {
818         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
819         swapping = true;
820         swapBack();
821         swapping = false;
822         emit OwnerForcedSwapBack(block.timestamp);
823     }
824 
825     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
826     function buyBackTokens(uint256 amountInWei) external onlyOwner {
827         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
828 
829         address[] memory path = new address[](2);
830         path[0] = dexRouter.WETH();
831         path[1] = address(this);
832 
833         // make the swap
834         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
835             0, // accept any amount of Ethereum
836             path,
837             address(0xdead),
838             block.timestamp
839         );
840         emit BuyBackTriggered(amountInWei);
841     }
842 }