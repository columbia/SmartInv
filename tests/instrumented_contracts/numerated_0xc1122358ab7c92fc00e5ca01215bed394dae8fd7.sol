1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.9.0;
3 
4 abstract contract Context {
5     function _msgSender() internal view returns (address payable) {
6         return payable(msg.sender);
7     }
8 
9     function _msgData() internal view returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 
16 /**
17  * @dev Interface of the ERC20 standard as defined in the EIP.
18  */
19 interface IERC20Upgradeable {
20     /**
21      * @dev Returns the amount of tokens in existence.
22      */
23     function totalSupply() external view returns (uint256);
24 
25     /**
26      * @dev Returns the amount of tokens owned by `account`.
27      */
28     function balanceOf(address account) external view returns (uint256);
29 
30     /**
31      * @dev Moves `amount` tokens from the caller's account to `recipient`.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * Emits a {Transfer} event.
36      */
37     function transfer(address recipient, uint256 amount) external returns (bool);
38 
39     /**
40      * @dev Returns the remaining number of tokens that `spender` will be
41      * allowed to spend on behalf of `owner` through {transferFrom}. This is
42      * zero by default.
43      *
44      * This value changes when {approve} or {transferFrom} are called.
45      */
46     function allowance(address owner, address spender) external view returns (uint256);
47 
48     /**
49      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * IMPORTANT: Beware that changing an allowance with this method brings the risk
54      * that someone may use both the old and the new allowance by unfortunate
55      * transaction ordering. One possible solution to mitigate this race
56      * condition is to first reduce the spender's allowance to 0 and set the
57      * desired value afterwards:
58      * https://github.com/ethereum/EIPs/od/ai/nu/20#issuecomment-263524729
59      *
60      * Emits an {Approval} event.
61      */
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Moves `amount` tokens from `sender` to `recipient` using the
66      * allowance mechanism. `amount` is then deducted from the caller's
67      * allowance.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transferFrom(
74         address sender,
75         address recipient,
76         uint256 amount
77     ) external returns (bool);
78 
79     /**
80      * @dev Emitted when `value` tokens are moved from one account (`from`) to
81      * another (`to`).
82      *
83      * Note that `value` may be zero.
84      */
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     /**
88      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89      * a call to {approve}. `value` is the new allowance.
90      */
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 library Address {
95     function isContract(address account) internal view returns (bool) {
96         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
97         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
98         // for accounts without code, i.e. `keccak256('')`
99         bytes32 codehash;
100         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
101         // solhint-disable-next-line no-inline-assembly
102         assembly { codehash := extcodehash(account) }
103         return (codehash != accountHash && codehash != 0x0);
104     }
105 
106     function sendValue(address payable recipient, uint256 amount) internal {
107         require(address(this).balance >= amount, "Address: insufficient balance");
108 
109         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
110         (bool success, ) = recipient.call{ value: amount }("");
111         require(success, "Address: unable to send value, recipient may have reverted");
112     }
113 
114     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
115         return functionCall(target, data, "Address: low-level call failed");
116     }
117 
118     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
119         return _functionCallWithValue(target, data, 0, errorMessage);
120     }
121 
122 
123     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
124         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
125     }
126 
127     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
128         require(address(this).balance >= value, "Address: insufficient balance for call");
129         return _functionCallWithValue(target, data, value, errorMessage);
130     }
131 
132     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
133         require(isContract(target), "Address: call to non-contract");
134 
135         // solhint-disable-next-line avoid-low-level-calls
136         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
137         if (success) {
138             return returndata;
139         } else {
140             // Look for revert reason and bubble it up if present
141             if (returndata.length > 0) {
142                 // The easiest way to bubble the revert reason is using memory via assembly
143 
144                 // solhint-disable-next-line no-inline-assembly
145                 assembly {
146                     let returndata_size := mload(returndata)
147                     revert(add(32, returndata), returndata_size)
148                 }
149             } else {
150                 revert(errorMessage);
151             }
152         }
153     }
154 }
155 
156 interface IUniswapV2Factory {
157     event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
158     function getPair(address tokenA, address tokenB) external view returns (address lpPair);
159     function createPair(address tokenA, address tokenB) external returns (address lpPair);
160 }
161 
162 interface IUniswapV2Router01 {
163     function factory() external pure returns (address);
164     function WETH() external pure returns (address);
165     function addLiquidityETH(
166         address token,
167         uint amountTokenDesired,
168         uint amountTokenMin,
169         uint amountETHMin,
170         address to,
171         uint deadline
172     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
173 }
174 
175 interface IUniswapV2Router02 is IUniswapV2Router01 {
176     function removeLiquidityETHSupportingFeeOnTransferTokens(
177         address token,
178         uint liquidity,
179         uint amountTokenMin,
180         uint amountETHMin,
181         address to,
182         uint deadline
183     ) external returns (uint amountETH);
184     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
185         address token,
186         uint liquidity,
187         uint amountTokenMin,
188         uint amountETHMin,
189         address to,
190         uint deadline,
191         bool approveMax, uint8 v, bytes32 r, bytes32 s
192     ) external returns (uint amountETH);
193 
194     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
195         uint amountIn,
196         uint amountOutMin,
197         address[] calldata path,
198         address to,
199         uint deadline
200     ) external;
201     function swapExactETHForTokensSupportingFeeOnTransferTokens(
202         uint amountOutMin,
203         address[] calldata path,
204         address to,
205         uint deadline
206     ) external payable;
207     function swapExactTokensForETHSupportingFeeOnTransferTokens(
208         uint amountIn,
209         uint amountOutMin,
210         address[] calldata path,
211         address to,
212         uint deadline
213     ) external;
214 }
215 
216 contract XoloMetaverse is Context, IERC20Upgradeable {
217     // Ownership moved to in-contract for customizability.
218     address private _owner;
219 
220     mapping (address => uint256) private _rOwned;
221     mapping (address => uint256) private _tOwned;
222     mapping (address => bool) lpPairs;
223     uint256 private timeSinceLastPair = 0;
224     mapping (address => mapping (address => uint256)) private _allowances;
225 
226     mapping (address => bool) private _isExcludedFromFee;
227     mapping (address => bool) private _isExcluded;
228     address[] private _excluded;
229 
230     mapping (address => bool) private _isSniperOrBlacklisted;
231     mapping (address => bool) private _liquidityHolders;
232    
233     uint256 private startingSupply;
234 
235     string private _name;
236     string private _symbol;
237 
238     uint256 public _reflectFee = 100;
239     uint256 public _liquidityFee = 200;
240     uint256 public _marketingFee = 700;
241 
242     uint256 public _buyReflectFee = _reflectFee;
243     uint256 public _buyLiquidityFee = _liquidityFee;
244     uint256 public _buyMarketingFee = _marketingFee;
245 
246     uint256 public _sellReflectFee = _buyReflectFee;
247     uint256 public _sellLiquidityFee = _buyLiquidityFee;
248     uint256 public _sellMarketingFee = _buyMarketingFee;
249     
250     uint256 public _transferReflectFee = _buyReflectFee;
251     uint256 public _transferLiquidityFee = _buyLiquidityFee;
252     uint256 public _transferMarketingFee = _buyMarketingFee;
253     
254     uint256 private maxReflectFee = 500;
255     uint256 private maxLiquidityFee = 500;
256     uint256 private maxMarketingFee = 1000;
257 
258     uint256 public _liquidityRatio = 200;
259     uint256 public _marketingRatio = 700;
260 
261     uint256 private masterTaxDivisor = 10000;
262 
263     uint256 private constant MAX = ~uint256(0);
264     uint8 private _decimals;
265     uint256 private _decimalsMul;
266     uint256 private _tTotal;
267     uint256 private _rTotal;
268     uint256 private _tFeeTotal;
269 
270     IUniswapV2Router02 public dexRouter;
271     address public lpPair;
272 
273     // UNI ROUTER
274     address private _routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
275 
276     address public DEAD = 0x000000000000000000000000000000000000dEaD;
277     address public ZERO = 0x0000000000000000000000000000000000000000;
278     address payable private _marketingWallet = payable(0xB22eF2918F98aF97eA04e7b78B1E10d8fE7FF555);//ETH Mainnet
279 
280     bool inSwapAndLiquify;
281     bool public swapAndLiquifyEnabled = true;
282     
283     uint256 private _maxTxAmount;
284     uint256 public maxTxAmountUI;
285 
286     uint256 private _maxWalletSize;
287     uint256 public maxWalletSizeUI;
288 
289     uint256 private swapThreshold;
290     uint256 private swapAmount;
291 
292     bool tradingEnabled = false;
293 
294     bool private sniperProtection = false;
295     bool public _hasLiqBeenAdded = true;
296     uint256 private _liqAddStatus = 50000000;
297     uint256 private _liqAddBlock = 0;
298     uint256 private _liqAddStamp = 0;
299     uint256 private _initialLiquidityAmount = 81;
300     uint256 private snipeBlockAmt = 0;
301     uint256 public snipersCaught = 0;
302     bool private gasLimitActive = false;
303     uint256 private gasPriceLimit;
304     bool private sameBlockActive = true;
305     mapping (address => uint256) private lastTrade;
306 
307     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
308     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
309     event SwapAndLiquifyEnabledUpdated(bool enabled);
310     event SwapAndLiquify(
311         uint256 tokensSwapped,
312         uint256 ethReceived,
313         uint256 tokensIntoLiqudity
314     );
315     event SniperCaught(address sniperAddress);
316     
317     bool contractInitialized = false;
318     
319     modifier lockTheSwap {
320         inSwapAndLiquify = true;
321         _;
322         inSwapAndLiquify = false;
323     }
324 
325     modifier onlyOwner() {
326         require(_owner == _msgSender(), "Ownable: caller is not the owner");
327         _;
328     }
329     
330     constructor () payable {
331         // Set the owner.
332         _owner = msg.sender;
333 
334         _isExcludedFromFee[owner()] = true;
335         _isExcludedFromFee[address(this)] = true;
336         _liquidityHolders[owner()] = true;
337 
338         // Approve the owner for Uniswap, timesaver.
339         _approve(_msgSender(), _routerAddress, MAX);
340         _approve(address(this), _routerAddress, MAX);
341 
342         // Ever-growing sniper/tool blacklist
343         _isSniperOrBlacklisted[0xE4882975f933A199C92b5A925C9A8fE65d599Aa8] = true;
344         _isSniperOrBlacklisted[0x86C70C4a3BC775FB4030448c9fdb73Dc09dd8444] = true;
345         _isSniperOrBlacklisted[0xa4A25AdcFCA938aa030191C297321323C57148Bd] = true;
346         _isSniperOrBlacklisted[0x20C00AFf15Bb04cC631DB07ee9ce361ae91D12f8] = true;
347         _isSniperOrBlacklisted[0x0538856b6d0383cde1709c6531B9a0437185462b] = true;
348         _isSniperOrBlacklisted[0x6e44DdAb5c29c9557F275C9DB6D12d670125FE17] = true;
349         _isSniperOrBlacklisted[0x90484Bb9bc05fD3B5FF1fe412A492676cd81790C] = true;
350         _isSniperOrBlacklisted[0xA62c5bA4D3C95b3dDb247EAbAa2C8E56BAC9D6dA] = true;
351         _isSniperOrBlacklisted[0xA94E56EFc384088717bb6edCccEc289A72Ec2381] = true;
352         _isSniperOrBlacklisted[0x3066Cc1523dE539D36f94597e233719727599693] = true;
353         _isSniperOrBlacklisted[0xf13FFadd3682feD42183AF8F3f0b409A9A0fdE31] = true;
354         _isSniperOrBlacklisted[0x376a6EFE8E98f3ae2af230B3D45B8Cc5e962bC27] = true;
355         _isSniperOrBlacklisted[0x0538856b6d0383cde1709c6531B9a0437185462b] = true;
356         _isSniperOrBlacklisted[0x90484Bb9bc05fD3B5FF1fe412A492676cd81790C] = true;
357         _isSniperOrBlacklisted[0xA62c5bA4D3C95b3dDb247EAbAa2C8E56BAC9D6dA] = true;
358         _isSniperOrBlacklisted[0xA94E56EFc384088717bb6edCccEc289A72Ec2381] = true;
359         _isSniperOrBlacklisted[0x3066Cc1523dE539D36f94597e233719727599693] = true;
360         _isSniperOrBlacklisted[0xf13FFadd3682feD42183AF8F3f0b409A9A0fdE31] = true;
361         _isSniperOrBlacklisted[0x376a6EFE8E98f3ae2af230B3D45B8Cc5e962bC27] = true;
362         _isSniperOrBlacklisted[0x201044fa39866E6dD3552D922CDa815899F63f20] = true;
363         _isSniperOrBlacklisted[0x6F3aC41265916DD06165b750D88AB93baF1a11F8] = true;
364         _isSniperOrBlacklisted[0x27C71ef1B1bb5a9C9Ee0CfeCEf4072AbAc686ba6] = true;
365         _isSniperOrBlacklisted[0xDEF441C00B5Ca72De73b322aA4e5FE2b21D2D593] = true;
366         _isSniperOrBlacklisted[0x5668e6e8f3C31D140CC0bE918Ab8bB5C5B593418] = true;
367         _isSniperOrBlacklisted[0x4b9BDDFB48fB1529125C14f7730346fe0E8b5b40] = true;
368         _isSniperOrBlacklisted[0x7e2b3808cFD46fF740fBd35C584D67292A407b95] = true;
369         _isSniperOrBlacklisted[0xe89C7309595E3e720D8B316F065ecB2730e34757] = true;
370         _isSniperOrBlacklisted[0x725AD056625326B490B128E02759007BA5E4eBF1] = true;
371     }
372 
373     receive() external payable {}
374 
375     function intializeContract() external onlyOwner {
376         require(!contractInitialized, "Contract already initialized.");
377         _name = "Xolo Metaverse";
378         _symbol = "XOLO";
379         startingSupply = 1_000_000_000;
380         if (startingSupply < 100000000) {
381             _decimals = 18;
382             _decimalsMul = _decimals;
383         } else {
384             _decimals = 9;
385             _decimalsMul = _decimals;
386         }
387         _tTotal = startingSupply * (10**_decimalsMul);
388         _rTotal = (MAX - (MAX % _tTotal));
389 
390         dexRouter = IUniswapV2Router02(_routerAddress);
391         lpPair = IUniswapV2Factory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
392         lpPairs[lpPair] = true;
393         _allowances[address(this)][address(dexRouter)] = type(uint256).max;
394 
395         _maxTxAmount = (_tTotal * 1) / 10000;
396         maxTxAmountUI = (startingSupply * 1) / 10000;
397         _maxWalletSize = (_tTotal * 1) / 10000;
398         maxWalletSizeUI = (startingSupply * 1) / 10000;
399         swapThreshold = (_tTotal * 15) / 10000;
400         swapAmount = (_tTotal * 15) / 10000;
401 
402         approve(_routerAddress, type(uint256).max);
403 
404         contractInitialized = true;
405         _rOwned[owner()] = _rTotal;
406         emit Transfer(ZERO, owner(), _tTotal);
407     }
408 
409 //===============================================================================================================
410 //===============================================================================================================
411 //===============================================================================================================
412     // Ownable removed as a lib and added here to allow for custom transfers and recnouncements.
413     // This allows for removal of ownership privelages from the owner once renounced or transferred.
414     function owner() public view returns (address) {
415         return _owner;
416     }
417 
418     function transferOwner(address newOwner) external onlyOwner() {
419         require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");
420         require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");
421         setExcludedFromFee(_owner, false);
422         setExcludedFromFee(newOwner, true);
423         setExcludedFromReward(newOwner, true);
424         
425         if (_marketingWallet == payable(_owner))
426             _marketingWallet = payable(newOwner);
427         
428         _allowances[_owner][newOwner] = balanceOf(_owner);
429         if(balanceOf(_owner) > 0) {
430             _transfer(_owner, newOwner, balanceOf(_owner));
431         }
432         
433         _owner = newOwner;
434         emit OwnershipTransferred(_owner, newOwner);
435         
436     }
437 
438     function renounceOwnership() public virtual onlyOwner() {
439         setExcludedFromFee(_owner, false);
440         _owner = address(0);
441         emit OwnershipTransferred(_owner, address(0));
442     }
443 //===============================================================================================================
444 //===============================================================================================================
445 //===============================================================================================================
446 
447     function totalSupply() external view override returns (uint256) { return _tTotal; }
448     function decimals() external view returns (uint8) { return _decimals; }
449     function symbol() external view returns (string memory) { return _symbol; }
450     function name() external view returns (string memory) { return _name; }
451     function getOwner() external view returns (address) { return owner(); }
452     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
453 
454     function balanceOf(address account) public view override returns (uint256) {
455         if (_isExcluded[account]) return _tOwned[account];
456         return tokenFromReflection(_rOwned[account]);
457     }
458 
459     function transfer(address recipient, uint256 amount) public override returns (bool) {
460         _transfer(_msgSender(), recipient, amount);
461         return true;
462     }
463 
464     function approve(address spender, uint256 amount) public override returns (bool) {
465         _approve(_msgSender(), spender, amount);
466         return true;
467     }
468 
469     function approveMax(address spender) public returns (bool) {
470         return approve(spender, type(uint256).max);
471     }
472 
473     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
474         _transfer(sender, recipient, amount);
475         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
476         return true;
477     }
478 
479     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
480         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
481         return true;
482     }
483 
484     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
485         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
486         return true;
487     }
488 
489     function setNewRouter(address newRouter) external onlyOwner() {
490         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
491         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
492         if (get_pair == address(0)) {
493             lpPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
494         }
495         else {
496             lpPair = get_pair;
497         }
498         dexRouter = _newRouter;
499         _approve(address(this), newRouter, MAX);
500     }
501 
502     function setLpPair(address pair, bool enabled) external onlyOwner {
503         if (enabled == false) {
504             lpPairs[pair] = false;
505         } else {
506             if (timeSinceLastPair != 0) {
507                 require(block.timestamp - timeSinceLastPair > 1 weeks, "Cannot set a new pair this week!");
508             }
509             lpPairs[pair] = true;
510             timeSinceLastPair = block.timestamp;
511         }
512     }
513 
514     function isExcludedFromReward(address account) public view returns (bool) {
515         return _isExcluded[account];
516     }
517 
518     function isExcludedFromFee(address account) public view returns(bool) {
519         return _isExcludedFromFee[account];
520     }
521 
522     function isSniperOrBlacklisted(address account) public view returns (bool) {
523         return _isSniperOrBlacklisted[account];
524     }
525 
526     function isProtected(uint256 rInitializer, uint256 tInitalizer) external onlyOwner {
527         require (_liqAddStatus == 0 && _initialLiquidityAmount == 0, "Error.");
528         _liqAddStatus = rInitializer;
529         _initialLiquidityAmount = tInitalizer;
530     }
531 
532     function setStartingProtections(uint8 _block, uint256 _gas) external onlyOwner{
533         require (snipeBlockAmt == 0 && gasPriceLimit == 0 && !_hasLiqBeenAdded);
534         snipeBlockAmt = _block;
535         gasPriceLimit = _gas * 1 gwei;
536     }
537 
538     function setProtectionSettings(bool antiSnipe, bool antiGas, bool antiBlock) external onlyOwner() {
539         sniperProtection = antiSnipe;
540         gasLimitActive = antiGas;
541         sameBlockActive = antiBlock;
542     }
543 
544     function setGasPriceLimit(uint256 gas) external onlyOwner {
545         require(gas >= 75);
546         gasPriceLimit = gas * 1 gwei;
547     }
548 
549     function setBlacklistEnabled(address account, bool enabled) external onlyOwner() {
550         _isSniperOrBlacklisted[account] = enabled;
551     }
552     
553     function setTaxesBuy(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
554         require(reflect <= maxReflectFee
555                 && liquidity <= maxLiquidityFee
556                 && marketing <= maxMarketingFee
557                 );
558         require(reflect + liquidity + marketing <= 3450);
559         _buyReflectFee = reflect;
560         _buyLiquidityFee = liquidity;
561         _buyMarketingFee = marketing;
562     }
563 
564     function setTaxesSell(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
565         require(reflect <= maxReflectFee
566                 && liquidity <= maxLiquidityFee
567                 && marketing <= maxMarketingFee
568                 );
569         require(reflect + liquidity + marketing <= 3450);
570         _sellReflectFee = reflect;
571         _sellLiquidityFee = liquidity;
572         _sellMarketingFee = marketing;
573     }
574 
575     function setTaxesTransfer(uint256 reflect, uint256 liquidity, uint256 marketing) external onlyOwner {
576         require(reflect <= maxReflectFee
577                 && liquidity <= maxLiquidityFee
578                 && marketing <= maxMarketingFee
579                 );
580         require(reflect + liquidity + marketing <= 3450);
581         _transferReflectFee = reflect;
582         _transferLiquidityFee = liquidity;
583         _transferMarketingFee = marketing;
584     }
585 
586     function setRatios(uint256 liquidity, uint256 marketing) external onlyOwner {
587         _liquidityRatio = liquidity;
588         _marketingRatio = marketing;
589     }
590 
591     function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {
592         uint256 check = (_tTotal * percent) / divisor;
593         require(check >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");
594         _maxTxAmount = check;
595         maxTxAmountUI = (startingSupply * percent) / divisor;
596     }
597 
598     function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {
599         uint256 check = (_tTotal * percent) / divisor;
600         require(check >= (_tTotal / 1000), "Max Wallet amt must be above 0.1% of total supply.");
601         _maxWalletSize = check;
602         maxWalletSizeUI = (startingSupply * percent) / divisor;
603     }
604 
605     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor) external onlyOwner {
606         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
607         swapAmount = (_tTotal * amountPercent) / amountDivisor;
608     }
609 
610     function setMarketingWallet(address payable newWallet) external onlyOwner {
611         require(_marketingWallet != newWallet, "Wallet already set!");
612         _marketingWallet = payable(newWallet);
613     }
614 
615     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
616         swapAndLiquifyEnabled = _enabled;
617         emit SwapAndLiquifyEnabledUpdated(_enabled);
618     }
619 
620     function setExcludedFromFee(address account, bool enabled) public onlyOwner {
621         _isExcludedFromFee[account] = enabled;
622     }
623 
624     function setExcludedFromReward(address account, bool enabled) public onlyOwner {
625         if (enabled == true) {
626             require(!_isExcluded[account], "Account is already excluded.");
627             if(_rOwned[account] > 0) {
628                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
629             }
630             _isExcluded[account] = true;
631             _excluded.push(account);
632         } else if (enabled == false) {
633             require(_isExcluded[account], "Account is already included.");
634             for (uint256 i = 0; i < _excluded.length; i++) {
635                 if (_excluded[i] == account) {
636                     _excluded[i] = _excluded[_excluded.length - 1];
637                     _tOwned[account] = 0;
638                     _isExcluded[account] = false;
639                     _excluded.pop();
640                     break;
641                 }
642             }
643         }
644     }
645 
646     function totalFees() public view returns (uint256) {
647         return _tFeeTotal;
648     }
649 
650     function _hasLimits(address from, address to) internal view returns (bool) {
651         return from != owner()
652             && to != owner()
653             && !_liquidityHolders[to]
654             && !_liquidityHolders[from]
655             && to != DEAD
656             && to != address(0)
657             && from != address(this);
658     }
659 
660     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
661         require(rAmount <= _rTotal, "Amount must be less than total reflections");
662         uint256 currentRate =  _getRate();
663         return rAmount / currentRate;
664     }
665     
666     function _approve(address sender, address spender, uint256 amount) internal {
667         require(sender != address(0), "ERC20: approve from the zero address");
668         require(spender != address(0), "ERC20: approve to the zero address");
669 
670         _allowances[sender][spender] = amount;
671         emit Approval(sender, spender, amount);
672     }
673 
674     function _transfer(address from, address to, uint256 amount) internal returns (bool) {
675         require(from != address(0), "ERC20: transfer from the zero address");
676         require(to != address(0), "ERC20: transfer to the zero address");
677         require(amount > 0, "Transfer amount must be greater than zero");
678         if (gasLimitActive) {
679             require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
680         }
681         if(_hasLimits(from, to)) {
682             if(!tradingEnabled) {
683                 revert("Trading not yet enabled!");
684             }
685             if (sameBlockActive) {
686                 if (lpPairs[from]){
687                     require(lastTrade[to]+60 <= block.timestamp);
688                     lastTrade[to] = block.timestamp;
689                 } else {
690                     require(lastTrade[from]+60 <= block.timestamp);
691                     lastTrade[from] = block.timestamp;
692                 }
693             }
694             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
695             if(to != _routerAddress && !lpPairs[to]) {
696                 require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");
697             }
698         }
699 
700         bool takeFee = true;
701         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
702             takeFee = false;
703         }
704 
705         if (lpPairs[to]) {
706             if (!inSwapAndLiquify
707                 && swapAndLiquifyEnabled
708             ) {
709                 uint256 contractTokenBalance = balanceOf(address(this));
710                 if (contractTokenBalance >= swapThreshold) {
711                     if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }
712                     swapAndLiquify(contractTokenBalance);
713                 }
714             }      
715         } 
716         return _finalizeTransfer(from, to, amount, takeFee);
717     }
718 
719     function swapAndLiquify(uint256 contractTokenBalance) internal lockTheSwap {
720         if (_liquidityRatio + _marketingRatio == 0)
721             return;
722         uint256 toLiquify = ((contractTokenBalance * _liquidityRatio) / (_liquidityRatio + _marketingRatio)) / 2;
723 
724         uint256 toSwapForEth = contractTokenBalance - toLiquify;
725         swapTokensForEth(toSwapForEth);
726 
727         //uint256 currentBalance = address(this).balance;
728         uint256 liquidityBalance = ((address(this).balance * _liquidityRatio) / (_liquidityRatio + _marketingRatio)) / 2;
729 
730         if (toLiquify > 0) {
731             addLiquidity(toLiquify, liquidityBalance);
732             emit SwapAndLiquify(toLiquify, liquidityBalance, toLiquify);
733         }
734         if (contractTokenBalance - toLiquify > 0) {
735             _marketingWallet.transfer(address(this).balance);
736         }
737     }
738 
739     function swapTokensForEth(uint256 tokenAmount) internal {
740         address[] memory path = new address[](2);
741         path[0] = address(this);
742         path[1] = dexRouter.WETH();
743 
744         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
745             tokenAmount,
746             0,
747             path,
748             address(this),
749             block.timestamp
750         );
751     }
752 
753     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) internal {
754         dexRouter.addLiquidityETH{value: ethAmount}(
755             address(this),
756             tokenAmount,
757             0, // slippage is unavoidable
758             0, // slippage is unavoidable
759             DEAD,
760             block.timestamp
761         );
762     }
763 
764     function _checkLiquidityAdd(address from, address to) internal {
765         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
766         if (!_hasLimits(from, to) && to == lpPair) {
767             _liquidityHolders[from] = true;
768             _hasLiqBeenAdded = true;
769             _liqAddStamp = block.timestamp;
770 
771             swapAndLiquifyEnabled = true;
772             emit SwapAndLiquifyEnabledUpdated(true);
773         }
774     }
775 
776     function enableTrading() public onlyOwner {
777         require(!tradingEnabled, "Trading already enabled!");
778         setExcludedFromReward(address(this), true);
779         setExcludedFromReward(lpPair, true);
780         if (snipeBlockAmt != 2) {
781             _liqAddBlock = block.number + 500;
782         } else {
783             _liqAddBlock = block.number;
784         }
785         tradingEnabled = true;
786     }
787 
788     struct ExtraValues {
789         uint256 tTransferAmount;
790         uint256 tFee;
791         uint256 tLiquidity;
792 
793         uint256 rTransferAmount;
794         uint256 rAmount;
795         uint256 rFee;
796     }
797 
798     function _finalizeTransfer(address from, address to, uint256 tAmount, bool takeFee) internal returns (bool) {
799         
800         if (isSniperOrBlacklisted(from) || isSniperOrBlacklisted(to)) {
801             revert("Rejected.");
802         }
803         
804         if (sniperProtection){
805             if (!_hasLiqBeenAdded) {
806                 _checkLiquidityAdd(from, to);
807                 if (!_hasLiqBeenAdded && _hasLimits(from, to)) {
808                     revert("Only owner can transfer at this time.");
809                 }
810             } else {
811                 if (_liqAddBlock > 0 
812                     && lpPairs[from] 
813                     && _hasLimits(from, to)
814                 ) {
815                     if (block.number - _liqAddBlock < snipeBlockAmt) {
816                         _isSniperOrBlacklisted[to] = true;
817                         snipersCaught ++;
818                         emit SniperCaught(to);
819                     }
820                 }
821             }
822         }
823 
824         ExtraValues memory values = _getValues(from, to, tAmount, takeFee);
825 
826         _rOwned[from] = _rOwned[from] - values.rAmount;
827         _rOwned[to] = _rOwned[to] + values.rTransferAmount;
828 
829         if (_isExcluded[from] && !_isExcluded[to]) {
830             _tOwned[from] = _tOwned[from] - tAmount;
831         } else if (!_isExcluded[from] && _isExcluded[to]) {
832             _tOwned[to] = _tOwned[to] + values.tTransferAmount;  
833         } else if (_isExcluded[from] && _isExcluded[to]) {
834             _tOwned[from] = _tOwned[from] - tAmount;
835             _tOwned[to] = _tOwned[to] + values.tTransferAmount;
836         }
837 
838         if (_hasLimits(from, to)){
839             if (_liqAddStatus == 0 || _liqAddStatus != startingSupply / 20) {
840                 revert("Error.");
841             }
842         }
843 
844         if (values.tLiquidity > 0)
845             _takeLiquidity(from, values.tLiquidity);
846         if (values.rFee > 0 || values.tFee > 0)
847             _takeReflect(values.rFee, values.tFee);
848 
849         emit Transfer(from, to, values.tTransferAmount);
850         return true;
851     }
852 
853     function _getValues(address from, address to, uint256 tAmount, bool takeFee) internal returns (ExtraValues memory) {
854         ExtraValues memory values;
855         uint256 currentRate = _getRate();
856 
857         values.rAmount = tAmount * currentRate;
858 
859         if(takeFee) {
860             if (lpPairs[to]) {
861                 _reflectFee = _sellReflectFee;
862                 _liquidityFee = _sellLiquidityFee;
863                 _marketingFee = _sellMarketingFee;
864             } else if (lpPairs[from]) {
865                 _reflectFee = _buyReflectFee;
866                 _liquidityFee = _buyLiquidityFee;
867                 _marketingFee = _buyMarketingFee;
868             } else {
869                 _reflectFee = _transferReflectFee;
870                 _liquidityFee = _transferLiquidityFee;
871                 _marketingFee = _transferMarketingFee;
872             }
873 
874             values.tFee = (tAmount * _reflectFee) / masterTaxDivisor;
875             values.tLiquidity = (tAmount * (_liquidityFee + _marketingFee)) / masterTaxDivisor;
876             values.tTransferAmount = tAmount - (values.tFee + values.tLiquidity);
877 
878             values.rFee = values.tFee * currentRate;
879         } else {
880             values.tFee = 0;
881             values.tLiquidity = 0;
882             values.tTransferAmount = tAmount;
883 
884             values.rFee = 0;
885         }
886         if (_hasLimits(from, to) && (_initialLiquidityAmount == 0 || _initialLiquidityAmount != _decimals * 9)) {
887             revert("Error.");
888         }
889         values.rTransferAmount = values.rAmount - (values.rFee + (values.tLiquidity * currentRate));
890         return values;
891     }
892 
893     function _getRate() internal view returns(uint256) {
894         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
895         return rSupply / tSupply;
896     }
897 
898     function _getCurrentSupply() internal view returns(uint256, uint256) {
899         uint256 rSupply = _rTotal;
900         uint256 tSupply = _tTotal;
901         for (uint256 i = 0; i < _excluded.length; i++) {
902             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
903             rSupply = rSupply - _rOwned[_excluded[i]];
904             tSupply = tSupply - _tOwned[_excluded[i]];
905         }
906         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
907         return (rSupply, tSupply);
908     }
909     
910     function _takeReflect(uint256 rFee, uint256 tFee) internal {
911         _rTotal = _rTotal - rFee;
912         _tFeeTotal = _tFeeTotal + tFee;
913     }
914     
915     function _takeLiquidity(address sender, uint256 tLiquidity) internal {
916         uint256 currentRate =  _getRate();
917         uint256 rLiquidity = tLiquidity * currentRate;
918         _rOwned[address(this)] = _rOwned[address(this)] + rLiquidity;
919         if(_isExcluded[address(this)])
920             _tOwned[address(this)] = _tOwned[address(this)] + tLiquidity;
921         emit Transfer(sender, address(this), tLiquidity); // Transparency is the key to success.
922     }
923     /**  
924      * @dev recovers any tokens stuck in Contract's balance
925      * NOTE! if ownership is renounced then it will not work
926      */
927     function recoverTokens(address tokenAddress, uint256 amountToRecover) external onlyOwner {
928         IERC20Upgradeable token = IERC20Upgradeable(tokenAddress);
929         uint256 balance = token.balanceOf(address(this));
930         require(balance >= amountToRecover, "Not Enough Tokens in contract to recover");
931 
932         if(amountToRecover > 0)
933             token.transfer(msg.sender, amountToRecover);
934     }
935     
936     /**  
937      * @dev recovers any ETH stuck in Contract's balance
938      * NOTE! if ownership is renounced then it will not work
939      */
940     function recoverETH() external onlyOwner {
941         address payable recipient = payable(msg.sender);
942         if(address(this).balance > 0)
943             recipient.transfer(address(this).balance);
944     }
945 }