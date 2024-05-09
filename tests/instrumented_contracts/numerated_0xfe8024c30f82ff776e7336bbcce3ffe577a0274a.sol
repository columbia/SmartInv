1 // WELCOME TO THE ABSOLUTE MADHOUSE - MURICA! 
2 // OUR FOUNDATION IS UNBREAKABLE, STRONGER THAN BIDEN'S SPINE! IF YOU'RE HERE TO RIDE THE ROCKET SHIP TO THE MOON INSTEAD OF CLINGING TO USELESS TOKENS, THEN YOU'RE IN THE RIGHT CRYPTO JUNGLE! 
3 // SMASH THAT FOLLOW BUTTON ON OUR SOCIALS LIKE IT'S THE LAST BUTTON ON EARTH, PILE INTO THIS MONSTROUS PROJECT LIKE IT'S YOUR LAST MEAL, AND CANNONBALL INTO THE FREEDOM-FILLED OCEAN OF UNBRIDLED POTENTIAL! LET'S GOOOOO!
4 
5 // TG: http://t.me/MURICAETH
6 // Twitter: http://twitter.com/MuricaUSA1
7 
8 // SPDX-License-Identifier: MIT
9 
10 pragma solidity ^0.8.9;
11 
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 abstract contract Context {
81     //function _msgSender() internal view virtual returns (address payable) {
82     function _msgSender() internal view virtual returns (address) {
83         return msg.sender;
84     }
85 
86     function _msgData() internal view virtual returns (bytes memory) {
87         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
88         return msg.data;
89     }
90 }
91 
92 /**
93  * @dev Collection of functions related to the address type
94  */
95 library Address {
96     /**
97      * @dev Returns true if `account` is a contract.
98      *
99      * [IMPORTANT]
100      * ====
101      * It is unsafe to assume that an address for which this function returns
102      * false is an externally-owned account (EOA) and not a contract.
103      *
104      * Among others, `isContract` will return false for the following
105      * types of addresses:
106      *
107      *  - an externally-owned account
108      *  - a contract in construction
109      *  - an address where a contract will be created
110      *  - an address where a contract lived, but was destroyed
111      * ====
112      */
113     function isContract(address account) internal view returns (bool) {
114         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
115         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
116         // for accounts without code, i.e. `keccak256('')`
117         bytes32 codehash;
118         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
119         // solhint-disable-next-line no-inline-assembly
120         assembly {
121             codehash := extcodehash(account)
122         }
123         return (codehash != accountHash && codehash != 0x0);
124     }
125 
126     /**
127      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
128      * `recipient`, forwarding all available gas and reverting on errors.
129      *
130      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
131      * of certain opcodes, possibly making contracts go over the 2300 gas limit
132      * imposed by `transfer`, making them unable to receive funds via
133      * `transfer`. {sendValue} removes this limitation.
134      *
135      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
136      *
137      * IMPORTANT: because control is transferred to `recipient`, care must be
138      * taken to not create reentrancy vulnerabilities. Consider using
139      * {ReentrancyGuard} or the
140      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
141      */
142     function sendValue(address payable recipient, uint256 amount) internal {
143         require(address(this).balance >= amount, "Address: insufficient balance");
144 
145         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
146         (bool success, ) = recipient.call{value: amount}("");
147         require(success, "Address: unable to send value, recipient may have reverted");
148     }
149 
150     /**
151      * @dev Performs a Solidity function call using a low level `call`. A
152      * plain`call` is an unsafe replacement for a function call: use this
153      * function instead.
154      *
155      * If `target` reverts with a revert reason, it is bubbled up by this
156      * function (like regular Solidity function calls).
157      *
158      * Returns the raw returned data. To convert to the expected return value,
159      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
160      *
161      * Requirements:
162      *
163      * - `target` must be a contract.
164      * - calling `target` with `data` must not revert.
165      *
166      * _Available since v3.1._
167      */
168     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
169         return functionCall(target, data, "Address: low-level call failed");
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
174      * `errorMessage` as a fallback revert reason when `target` reverts.
175      *
176      * _Available since v3.1._
177      */
178     function functionCall(
179         address target,
180         bytes memory data,
181         string memory errorMessage
182     ) internal returns (bytes memory) {
183         return _functionCallWithValue(target, data, 0, errorMessage);
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
188      * but also transferring `value` wei to `target`.
189      *
190      * Requirements:
191      *
192      * - the calling contract must have an ETH balance of at least `value`.
193      * - the called Solidity function must be `payable`.
194      *
195      * _Available since v3.1._
196      */
197     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
198         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
203      * with `errorMessage` as a fallback revert reason when `target` reverts.
204      *
205      * _Available since v3.1._
206      */
207     function functionCallWithValue(
208         address target,
209         bytes memory data,
210         uint256 value,
211         string memory errorMessage
212     ) internal returns (bytes memory) {
213         require(address(this).balance >= value, "Address: insufficient balance for call");
214         return _functionCallWithValue(target, data, value, errorMessage);
215     }
216 
217     function _functionCallWithValue(
218         address target,
219         bytes memory data,
220         uint256 weiValue,
221         string memory errorMessage
222     ) private returns (bytes memory) {
223         require(isContract(target), "Address: call to non-contract");
224 
225         // solhint-disable-next-line avoid-low-level-calls
226         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
227         if (success) {
228             return returndata;
229         } else {
230             // Look for revert reason and bubble it up if present
231             if (returndata.length > 0) {
232                 // The easiest way to bubble the revert reason is using memory via assembly
233 
234                 // solhint-disable-next-line no-inline-assembly
235                 assembly {
236                     let returndata_size := mload(returndata)
237                     revert(add(32, returndata), returndata_size)
238                 }
239             } else {
240                 revert(errorMessage);
241             }
242         }
243     }
244 }
245 
246 /**
247  * @dev Contract module which provides a basic access control mechanism, where
248  * there is an account (an owner) that can be granted exclusive access to
249  * specific functions.
250  *
251  * By default, the owner account will be the one that deploys the contract. This
252  * can later be changed with {transferOwnership}.
253  *
254  * This module is used through inheritance. It will make available the modifier
255  * `onlyOwner`, which can be applied to your functions to restrict their use to
256  * the owner.
257  */
258 contract Ownable is Context {
259     address private _owner;
260     address private _previousOwner;
261     uint256 private _lockTime;
262 
263     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
264 
265     /**
266      * @dev Initializes the contract setting the deployer as the initial owner.
267      */
268     constructor() {
269         address msgSender = _msgSender();
270         _owner = msgSender;
271         emit OwnershipTransferred(address(0), msgSender);
272     }
273 
274     /**
275      * @dev Returns the address of the current owner.
276      */
277     function owner() public view returns (address) {
278         return _owner;
279     }
280 
281     /**
282      * @dev Throws if called by any account other than the owner.
283      */
284     modifier onlyOwner() {
285         require(_owner == _msgSender(), "Ownable: caller is not the owner");
286         _;
287     }
288 
289     /**
290      * @dev Leaves the contract without owner. It will not be possible to call
291      * `onlyOwner` functions anymore. Can only be called by the current owner.
292      *
293      * NOTE: Renouncing ownership will leave the contract without an owner,
294      * thereby removing any functionality that is only available to the owner.
295      */
296     function renounceOwnership() public virtual onlyOwner {
297         emit OwnershipTransferred(_owner, address(0));
298         _owner = address(0);
299     }
300 
301     /**
302      * @dev Transfers ownership of the contract to a new account (`newOwner`).
303      * Can only be called by the current owner.
304      */
305     function transferOwnership(address newOwner) public virtual onlyOwner {
306         require(newOwner != address(0), "Ownable: new owner is the zero address");
307         emit OwnershipTransferred(_owner, newOwner);
308         _owner = newOwner;
309     }
310 }
311 
312 interface IUniswapV2Factory {
313     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
314 
315     function feeTo() external view returns (address);
316 
317     function feeToSetter() external view returns (address);
318 
319     function getPair(address tokenA, address tokenB) external view returns (address pair);
320 
321     function allPairs(uint) external view returns (address pair);
322 
323     function allPairsLength() external view returns (uint);
324 
325     function createPair(address tokenA, address tokenB) external returns (address pair);
326 
327     function setFeeTo(address) external;
328 
329     function setFeeToSetter(address) external;
330 }
331 
332 interface IUniswapV2Pair {
333     event Approval(address indexed owner, address indexed spender, uint value);
334     event Transfer(address indexed from, address indexed to, uint value);
335 
336     function name() external pure returns (string memory);
337 
338     function symbol() external pure returns (string memory);
339 
340     function decimals() external pure returns (uint8);
341 
342     function totalSupply() external view returns (uint);
343 
344     function balanceOf(address owner) external view returns (uint);
345 
346     function allowance(address owner, address spender) external view returns (uint);
347 
348     function approve(address spender, uint value) external returns (bool);
349 
350     function transfer(address to, uint value) external returns (bool);
351 
352     function transferFrom(address from, address to, uint value) external returns (bool);
353 
354     function DOMAIN_SEPARATOR() external view returns (bytes32);
355 
356     function PERMIT_TYPEHASH() external pure returns (bytes32);
357 
358     function nonces(address owner) external view returns (uint);
359 
360     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
361 
362     event Mint(address indexed sender, uint amount0, uint amount1);
363     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
364     event Swap(
365         address indexed sender,
366         uint amount0In,
367         uint amount1In,
368         uint amount0Out,
369         uint amount1Out,
370         address indexed to
371     );
372     event Sync(uint112 reserve0, uint112 reserve1);
373 
374     function MINIMUM_LIQUIDITY() external pure returns (uint);
375 
376     function factory() external view returns (address);
377 
378     function token0() external view returns (address);
379 
380     function token1() external view returns (address);
381 
382     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
383 
384     function price0CumulativeLast() external view returns (uint);
385 
386     function price1CumulativeLast() external view returns (uint);
387 
388     function kLast() external view returns (uint);
389 
390     function mint(address to) external returns (uint liquidity);
391 
392     function burn(address to) external returns (uint amount0, uint amount1);
393 
394     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
395 
396     function skim(address to) external;
397 
398     function sync() external;
399 
400     function initialize(address, address) external;
401 }
402 
403 interface IUniswapV2Router01 {
404     function factory() external pure returns (address);
405 
406     function WETH() external pure returns (address);
407 
408     function addLiquidity(
409         address tokenA,
410         address tokenB,
411         uint amountADesired,
412         uint amountBDesired,
413         uint amountAMin,
414         uint amountBMin,
415         address to,
416         uint deadline
417     ) external returns (uint amountA, uint amountB, uint liquidity);
418 
419     function addLiquidityETH(
420         address token,
421         uint amountTokenDesired,
422         uint amountTokenMin,
423         uint amountETHMin,
424         address to,
425         uint deadline
426     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
427 
428     function removeLiquidity(
429         address tokenA,
430         address tokenB,
431         uint liquidity,
432         uint amountAMin,
433         uint amountBMin,
434         address to,
435         uint deadline
436     ) external returns (uint amountA, uint amountB);
437 
438     function removeLiquidityETH(
439         address token,
440         uint liquidity,
441         uint amountTokenMin,
442         uint amountETHMin,
443         address to,
444         uint deadline
445     ) external returns (uint amountToken, uint amountETH);
446 
447     function removeLiquidityWithPermit(
448         address tokenA,
449         address tokenB,
450         uint liquidity,
451         uint amountAMin,
452         uint amountBMin,
453         address to,
454         uint deadline,
455         bool approveMax,
456         uint8 v,
457         bytes32 r,
458         bytes32 s
459     ) external returns (uint amountA, uint amountB);
460 
461     function removeLiquidityETHWithPermit(
462         address token,
463         uint liquidity,
464         uint amountTokenMin,
465         uint amountETHMin,
466         address to,
467         uint deadline,
468         bool approveMax,
469         uint8 v,
470         bytes32 r,
471         bytes32 s
472     ) external returns (uint amountToken, uint amountETH);
473 
474     function swapExactTokensForTokens(
475         uint amountIn,
476         uint amountOutMin,
477         address[] calldata path,
478         address to,
479         uint deadline
480     ) external returns (uint[] memory amounts);
481 
482     function swapTokensForExactTokens(
483         uint amountOut,
484         uint amountInMax,
485         address[] calldata path,
486         address to,
487         uint deadline
488     ) external returns (uint[] memory amounts);
489 
490     function swapExactETHForTokens(
491         uint amountOutMin,
492         address[] calldata path,
493         address to,
494         uint deadline
495     ) external payable returns (uint[] memory amounts);
496 
497     function swapTokensForExactETH(
498         uint amountOut,
499         uint amountInMax,
500         address[] calldata path,
501         address to,
502         uint deadline
503     ) external returns (uint[] memory amounts);
504 
505     function swapExactTokensForETH(
506         uint amountIn,
507         uint amountOutMin,
508         address[] calldata path,
509         address to,
510         uint deadline
511     ) external returns (uint[] memory amounts);
512 
513     function swapETHForExactTokens(
514         uint amountOut,
515         address[] calldata path,
516         address to,
517         uint deadline
518     ) external payable returns (uint[] memory amounts);
519 
520     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
521 
522     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
523 
524     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
525 
526     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
527 
528     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
529 }
530 
531 interface IUniswapV2Router02 is IUniswapV2Router01 {
532     function removeLiquidityETHSupportingFeeOnTransferTokens(
533         address token,
534         uint liquidity,
535         uint amountTokenMin,
536         uint amountETHMin,
537         address to,
538         uint deadline
539     ) external returns (uint amountETH);
540 
541     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
542         address token,
543         uint liquidity,
544         uint amountTokenMin,
545         uint amountETHMin,
546         address to,
547         uint deadline,
548         bool approveMax,
549         uint8 v,
550         bytes32 r,
551         bytes32 s
552     ) external returns (uint amountETH);
553 
554     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
555         uint amountIn,
556         uint amountOutMin,
557         address[] calldata path,
558         address to,
559         uint deadline
560     ) external;
561 
562     function swapExactETHForTokensSupportingFeeOnTransferTokens(
563         uint amountOutMin,
564         address[] calldata path,
565         address to,
566         uint deadline
567     ) external payable;
568 
569     function swapExactTokensForETHSupportingFeeOnTransferTokens(
570         uint amountIn,
571         uint amountOutMin,
572         address[] calldata path,
573         address to,
574         uint deadline
575     ) external;
576 }
577 
578 interface IAirdrop {
579     function airdrop(address recipient, uint256 amount) external;
580 }
581 
582 contract MURICA is Context, IERC20, Ownable {
583     using Address for address;
584 
585     mapping(address => uint256) private _rOwned;
586     mapping(address => uint256) private _tOwned;
587     mapping(address => mapping(address => uint256)) private _allowances;
588 
589     mapping(address => bool) private _isExcludedFromFee;
590 
591     mapping(address => bool) private _isExcluded;
592     address[] private _excluded;
593 
594     mapping(address => bool) private botWallets;
595     bool constant botscantrade = false;
596 
597     bool public canTrade = false;
598 
599     uint256 private constant MAX = ~uint256(0);
600     uint256 private constant _tTotal = 471776000000000 * 10 ** 9;
601     address public constant burningAddress = 0x000000000000000000000000000000000000dEaD;
602     uint256 private _rTotal = (MAX - (MAX % _tTotal));
603     uint256 private _tFeeTotal;
604     address public marketingWallet;
605     address public devWallet;
606     address private migrationWallet;
607     address public uniswapPair;
608 
609     string private constant _name = "MURICA";
610     string private constant _symbol = "MURICA";
611     uint8 private constant _decimals = 9;
612 
613     uint256 public _taxFee = 4;
614     uint256 private _previousTaxFee = _taxFee;
615 
616     uint256 public _liquidityFee = 1;
617     uint256 private _previousLiquidityFee = _liquidityFee;
618 
619     IUniswapV2Router02 public immutable uniswapV2Router;
620     address public uniswapV2Pair;
621 
622     bool inSwapAndLiquify;
623     bool public swapAndLiquifyEnabled = true;
624 
625     uint256 public _maxTxAmount = 471776000000000 * 10 ** 9;
626     uint256 public numTokensSellToAddToLiquidity = 47177600000 * 10 ** 9;
627 
628     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
629     event SwapAndLiquifyEnabledUpdated(bool enabled);
630     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
631 
632     modifier lockTheSwap() {
633         inSwapAndLiquify = true;
634         _;
635         inSwapAndLiquify = false;
636     }
637 
638     constructor() {
639         _rOwned[_msgSender()] = _rTotal;
640 
641         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UNISWAP ROUTER
642         if(IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this),_uniswapV2Router.WETH()) == address(0)){
643             // Create a uniswap pair for this new token
644             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
645                 address(this),
646                 _uniswapV2Router.WETH()
647             );
648         } else {
649             uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this),_uniswapV2Router.WETH());
650         }
651 
652         // set the rest of the contract variables
653         uniswapV2Router = _uniswapV2Router;
654 
655         //exclude owner and this contract from fee
656         _isExcludedFromFee[owner()] = true;
657         _isExcludedFromFee[address(this)] = true;
658 
659         emit Transfer(address(0), _msgSender(), _tTotal);
660     }
661 
662     function name() external pure returns (string memory) {
663         return _name;
664     }
665 
666     function symbol() external pure returns (string memory) {
667         return _symbol;
668     }
669 
670     function decimals() external pure returns (uint8) {
671         return _decimals;
672     }
673 
674     function totalSupply() external view override returns (uint256) {
675         uint256 burnedAmount = tokenFromReflection(_rOwned[burningAddress]);
676         return _tTotal - burnedAmount;
677     }
678 
679     function balanceOf(address account) public view override returns (uint256) {
680         if (account == burningAddress) return 0;
681         if (_isExcluded[account]) return _tOwned[account];
682         return tokenFromReflection(_rOwned[account]);
683     }
684 
685     function transfer(address recipient, uint256 amount) external override returns (bool) {
686         _transfer(_msgSender(), recipient, amount);
687         return true;
688     }
689 
690     function allowance(address owner, address spender) external view override returns (uint256) {
691         return _allowances[owner][spender];
692     }
693 
694     function approve(address spender, uint256 amount) external override returns (bool) {
695         _approve(_msgSender(), spender, amount);
696         return true;
697     }
698 
699     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
700         require(amount <= _allowances[sender][_msgSender()], "ERC20: transfer amount exceeds allowance");
701         _transfer(sender, recipient, amount);
702         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
703         return true;
704     }
705 
706     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
707         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
708         return true;
709     }
710 
711     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
712         require(subtractedValue <= _allowances[_msgSender()][spender], "ERC20: decreased allowance below zero");
713         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
714         return true;
715     }
716 
717     function isExcludedFromReward(address account) external view returns (bool) {
718         return _isExcluded[account];
719     }
720 
721     function totalFees() external view returns (uint256) {
722         return _tFeeTotal;
723     }
724 
725     function airdrop(address recipient, uint256 amount) external onlyOwner {
726         removeAllFee();
727         _transfer(_msgSender(), recipient, amount * 10 ** 9);
728         restoreAllFee();
729     }
730 
731     function airdropInternal(address recipient, uint256 amount) internal {
732         removeAllFee();
733         _transfer(_msgSender(), recipient, amount);
734         restoreAllFee();
735     }
736 
737     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner {
738         uint256 iterator = 0;
739         require(newholders.length == amounts.length, "must be the same length");
740         while (iterator < newholders.length) {
741             airdropInternal(newholders[iterator], amounts[iterator] * 10 ** 9);
742             iterator += 1;
743         }
744     }
745 
746     function deliver(uint256 tAmount) external {
747         address sender = _msgSender();
748         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
749         (uint256 rAmount, , , , , ) = _getValues(tAmount);
750         _rOwned[sender] -= rAmount;
751         _rTotal -= rAmount;
752         _tFeeTotal += tAmount;
753     }
754 
755     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) external view returns (uint256) {
756         require(tAmount <= _tTotal, "Amount must be less than supply");
757         if (!deductTransferFee) {
758             (uint256 rAmount, , , , , ) = _getValues(tAmount);
759             return rAmount;
760         } else {
761             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
762             return rTransferAmount;
763         }
764     }
765 
766     function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
767         require(rAmount <= _rTotal, "Amount must be less than total reflections");
768         uint256 currentRate = _getRate();
769         return rAmount / currentRate;
770     }
771 
772     function excludeFromReward(address account) external onlyOwner {
773         require(account != burningAddress, "We can not exclude burning address.");
774         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
775         require(!_isExcluded[account], "Account is already excluded");
776         if (_rOwned[account] > 0) {
777             _tOwned[account] = tokenFromReflection(_rOwned[account]);
778         }
779         _isExcluded[account] = true;
780         _excluded.push(account);
781     }
782 
783     function includeInReward(address account) external onlyOwner {
784         require(_isExcluded[account], "Account is already excluded");
785         for (uint256 i = 0; i < _excluded.length; i++) {
786             if (_excluded[i] == account) {
787                 _excluded[i] = _excluded[_excluded.length - 1];
788                 _tOwned[account] = 0;
789                 _isExcluded[account] = false;
790                 _excluded.pop();
791                 break;
792             }
793         }
794     }
795 
796     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
797         (
798             uint256 rAmount,
799             uint256 rTransferAmount,
800             uint256 rFee,
801             uint256 tTransferAmount,
802             uint256 tFee,
803             uint256 tLiquidity
804         ) = _getValues(tAmount);
805         _tOwned[sender] -= tAmount;
806         _rOwned[sender] -= rAmount;
807         _tOwned[recipient] += tTransferAmount;
808         _rOwned[recipient] += rTransferAmount;
809         _takeLiquidity(tLiquidity);
810         _reflectFee(rFee, tFee);
811         emit Transfer(sender, recipient, tTransferAmount);
812     }
813 
814     function excludeFromFee(address account) external onlyOwner {
815         _isExcludedFromFee[account] = true;
816     }
817 
818     function includeInFee(address account) external onlyOwner {
819         _isExcludedFromFee[account] = false;
820     }
821 
822     function setMarketingWallet(address walletAddress) external onlyOwner {
823         marketingWallet = walletAddress;
824     }
825 
826     function setDevWallet(address walletAddress) external onlyOwner {
827         devWallet = walletAddress;
828     }
829 
830     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner {
831         require(SwapThresholdAmount > 471776000, "Swap Threshold Amount cannot be less than 471 Million and 776 Thousand");
832         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10 ** 9;
833     }
834 
835     function claimTokens() external onlyOwner {
836         // make sure we capture all BNB that may or may not be sent to this contract
837         payable(devWallet).transfer(address(this).balance);
838     }
839 
840     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner {
841         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
842     }
843 
844     function clearStuckBalance(address payable walletaddress) external onlyOwner {
845         walletaddress.transfer(address(this).balance);
846     }
847 
848     function addBotWallet(address botwallet) external onlyOwner {
849         botWallets[botwallet] = true;
850     }
851 
852     function removeBotWallet(address botwallet) external onlyOwner {
853         botWallets[botwallet] = false;
854     }
855 
856     function getBotWalletStatus(address botwallet) external view returns (bool) {
857         return botWallets[botwallet];
858     }
859 
860     function allowtrading() external onlyOwner {
861         canTrade = true;
862     }
863 
864     function setMigrationWallet(address walletAddress) external onlyOwner {
865         migrationWallet = walletAddress;
866     }
867 
868     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
869         swapAndLiquifyEnabled = _enabled;
870         emit SwapAndLiquifyEnabledUpdated(_enabled);
871     }
872 
873     //to recieve ETH from uniswapV2Router when swaping
874     receive() external payable {}
875 
876     function _reflectFee(uint256 rFee, uint256 tFee) private {
877         _rTotal -= rFee;
878         _tFeeTotal += tFee;
879     }
880 
881     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
882         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
883         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
884         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
885     }
886 
887     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
888         uint256 tFee = calculateTaxFee(tAmount);
889         uint256 tLiquidity = calculateLiquidityFee(tAmount);
890         uint256 tTransferAmount = tAmount - tFee - tLiquidity;
891         return (tTransferAmount, tFee, tLiquidity);
892     }
893 
894     function _getRValues(
895         uint256 tAmount,
896         uint256 tFee,
897         uint256 tLiquidity,
898         uint256 currentRate
899     ) private pure returns (uint256, uint256, uint256) {
900         uint256 rAmount = tAmount * currentRate;
901         uint256 rFee = tFee * currentRate;
902         uint256 rLiquidity = tLiquidity * currentRate;
903         uint256 rTransferAmount = rAmount - rFee - rLiquidity;
904         return (rAmount, rTransferAmount, rFee);
905     }
906 
907     function _getRate() private view returns (uint256) {
908         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
909         return rSupply / tSupply;
910     }
911 
912     function _getCurrentSupply() private view returns (uint256, uint256) {
913         uint256 rSupply = _rTotal;
914         uint256 tSupply = _tTotal;
915         for (uint256 i = 0; i < _excluded.length; i++) {
916             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
917             rSupply -= _rOwned[_excluded[i]];
918             tSupply -= _tOwned[_excluded[i]];
919         }
920         if (rSupply < (_rTotal / _tTotal)) return (_rTotal, _tTotal);
921         return (rSupply, tSupply);
922     }
923 
924     function _takeLiquidity(uint256 tLiquidity) private {
925         uint256 currentRate = _getRate();
926         uint256 rLiquidity = tLiquidity * currentRate;
927         _rOwned[address(this)] += rLiquidity;
928         if (_isExcluded[address(this)]) _tOwned[address(this)] += tLiquidity;
929     }
930 
931     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
932         return (_amount * _taxFee) / (10 ** 2);
933     }
934 
935     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
936         return (_amount * _liquidityFee) / (10 ** 2);
937     }
938 
939     function removeAllFee() private {
940         if (_taxFee == 0 && _liquidityFee == 0) return;
941 
942         _previousTaxFee = _taxFee;
943         _previousLiquidityFee = _liquidityFee;
944 
945         _taxFee = 0;
946         _liquidityFee = 0;
947     }
948 
949     function restoreAllFee() private {
950         _taxFee = _previousTaxFee;
951         _liquidityFee = _previousLiquidityFee;
952     }
953 
954     function isExcludedFromFee(address account) external view returns (bool) {
955         return _isExcludedFromFee[account];
956     }
957 
958     function _approve(address owner, address spender, uint256 amount) private {
959         require(owner != address(0), "ERC20: approve from the zero address");
960         require(spender != address(0), "ERC20: approve to the zero address");
961 
962         _allowances[owner][spender] = amount;
963         emit Approval(owner, spender, amount);
964     }
965 
966     function _transfer(address from, address to, uint256 amount) private {
967         require(from != address(0), "ERC20: transfer from the zero address");
968         require(to != address(0), "ERC20: transfer to the zero address");
969         require(amount > 0, "Transfer amount must be greater than zero");
970         if (from != owner() && to != owner())
971             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
972 
973         // is the token balance of this contract address over the min number of
974         // tokens that we need to initiate a swap + liquidity lock?
975         // also, don't get caught in a circular liquidity event.
976         // also, don't swap & liquify if sender is uniswap pair.
977         uint256 contractTokenBalance = balanceOf(address(this));
978 
979         if (contractTokenBalance >= _maxTxAmount) {
980             contractTokenBalance = _maxTxAmount;
981         }
982 
983         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
984         if (overMinTokenBalance && !inSwapAndLiquify && from != uniswapV2Pair && swapAndLiquifyEnabled) {
985             contractTokenBalance = numTokensSellToAddToLiquidity;
986             //add liquidity
987             swapAndLiquify(contractTokenBalance);
988         }
989 
990         //indicates if fee should be deducted from transfer
991         bool takeFee = true;
992 
993         //if any account belongs to _isExcludedFromFee account then remove the fee
994         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
995             takeFee = false;
996         }
997 
998         //transfer amount, it will take tax, liquidity fee
999         _tokenTransfer(from, to, amount, takeFee);
1000     }
1001 
1002     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1003         // split the contract balance into liquidity, marketing and treasury quotas
1004 
1005         uint256 convertQuota = (contractTokenBalance * 3) / 4;
1006         
1007         uint256 liquHalf = contractTokenBalance - convertQuota;
1008 
1009 
1010         // swap tokens for ETH
1011 
1012         swapTokensForEth(convertQuota);
1013 
1014         // how much ETH did we just swap into?
1015         uint256 newBalance = address(this).balance;
1016         uint256 marketingshare = (newBalance * 4) / 9;
1017         payable(marketingWallet).transfer(marketingshare);
1018         uint256 afterMarketBalance = newBalance - marketingshare;
1019         uint256 treasshare = (afterMarketBalance * 4) / 5;
1020         payable(devWallet).transfer(treasshare);
1021         uint256 afterDevBalance = afterMarketBalance - treasshare;
1022 
1023         // add liquidity to uniswap
1024         addLiquidity(liquHalf, afterDevBalance);
1025 
1026         emit SwapAndLiquify(liquHalf, afterDevBalance, liquHalf);
1027     }
1028 
1029     function swapTokensForEth(uint256 tokenAmount) private {
1030         // generate the uniswap pair path of token -> weth
1031         address[] memory path = new address[](2);
1032         path[0] = address(this);
1033         path[1] = uniswapV2Router.WETH();
1034 
1035         _approve(address(this), address(uniswapV2Router), tokenAmount);
1036 
1037         // make the swap
1038         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1039             tokenAmount,
1040             0, // accept any amount of ETH
1041             path,
1042             address(this),
1043             block.timestamp
1044         );
1045     }
1046 
1047     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1048         // approve token transfer to cover all possible scenarios
1049         _approve(address(this), address(uniswapV2Router), tokenAmount);
1050 
1051         // add the liquidity
1052         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1053             address(this),
1054             tokenAmount,
1055             0, // slippage is unavoidable
1056             0, // slippage is unavoidable
1057             owner(),
1058             block.timestamp
1059         );
1060     }
1061 
1062     //this method is responsible for taking all fee, if takeFee is true
1063     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1064         if (!canTrade) {
1065             require(sender == owner() || sender == migrationWallet); // only owner allowed to trade or add liquidity
1066         }
1067 
1068         if (botWallets[sender] || botWallets[recipient]) {
1069             require(botscantrade, "bots arent allowed to trade");
1070         }
1071 
1072         if (!takeFee) removeAllFee();
1073 
1074         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1075             _transferFromExcluded(sender, recipient, amount);
1076         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1077             _transferToExcluded(sender, recipient, amount);
1078         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1079             _transferStandard(sender, recipient, amount);
1080         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1081             _transferBothExcluded(sender, recipient, amount);
1082         } else {
1083             _transferStandard(sender, recipient, amount);
1084         }
1085 
1086         if (!takeFee) restoreAllFee();
1087     }
1088 
1089     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1090         (
1091             uint256 rAmount,
1092             uint256 rTransferAmount,
1093             uint256 rFee,
1094             uint256 tTransferAmount,
1095             uint256 tFee,
1096             uint256 tLiquidity
1097         ) = _getValues(tAmount);
1098         _rOwned[sender] -= rAmount;
1099         _rOwned[recipient] += rTransferAmount;
1100         _takeLiquidity(tLiquidity);
1101         _reflectFee(rFee, tFee);
1102         emit Transfer(sender, recipient, tTransferAmount);
1103     }
1104 
1105     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1106         (
1107             uint256 rAmount,
1108             uint256 rTransferAmount,
1109             uint256 rFee,
1110             uint256 tTransferAmount,
1111             uint256 tFee,
1112             uint256 tLiquidity
1113         ) = _getValues(tAmount);
1114         _rOwned[sender] -= rAmount;
1115         _tOwned[recipient] += tTransferAmount;
1116         _rOwned[recipient] += rTransferAmount;
1117         _takeLiquidity(tLiquidity);
1118         _reflectFee(rFee, tFee);
1119         emit Transfer(sender, recipient, tTransferAmount);
1120     }
1121 
1122     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1123         (
1124             uint256 rAmount,
1125             uint256 rTransferAmount,
1126             uint256 rFee,
1127             uint256 tTransferAmount,
1128             uint256 tFee,
1129             uint256 tLiquidity
1130         ) = _getValues(tAmount);
1131         _tOwned[sender] -= tAmount;
1132         _rOwned[sender] -= rAmount;
1133         _rOwned[recipient] += rTransferAmount;
1134         _takeLiquidity(tLiquidity);
1135         _reflectFee(rFee, tFee);
1136         emit Transfer(sender, recipient, tTransferAmount);
1137     }
1138 }