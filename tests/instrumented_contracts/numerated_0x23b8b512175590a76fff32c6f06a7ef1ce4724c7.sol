1 pragma solidity ^0.8.6;
2 // SPDX-License-Identifier: Unlicensed
3 
4 
5 interface IERC20 {
6 
7     function totalSupply() external view returns (uint256);
8 
9     /**
10      * @dev Returns the amount of tokens owned by `account`.
11      */
12     function balanceOf(address account) external view returns (uint256);
13 
14     /**
15      * @dev Moves `amount` tokens from the caller's account to `recipient`.
16      *
17      * Returns a boolean value indicating whether the operation succeeded.
18      *
19      * Emits a {Transfer} event.
20      */
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     /**
24      * @dev Returns the remaining number of tokens that `spender` will be
25      * allowed to spend on behalf of `owner` through {transferFrom}. This is
26      * zero by default.
27      *
28      * This value changes when {approve} or {transferFrom} are called.
29      */
30     function allowance(address owner, address spender) external view returns (uint256);
31 
32     /**
33      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * IMPORTANT: Beware that changing an allowance with this method brings the risk
38      * that someone may use both the old and the new allowance by unfortunate
39      * transaction ordering. One possible solution to mitigate this race
40      * condition is to first reduce the spender's allowance to 0 and set the
41      * desired value afterwards:
42      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
43      *
44      * Emits an {Approval} event.
45      */
46     function approve(address spender, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Moves `amount` tokens from `sender` to `recipient` using the
50      * allowance mechanism. `amount` is then deducted from the caller's
51      * allowance.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Emitted when `value` tokens are moved from one account (`from`) to
61      * another (`to`).
62      *
63      * Note that `value` may be zero.
64      */
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 
67     /**
68      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
69      * a call to {approve}. `value` is the new allowance.
70      */
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 
75 
76 abstract contract Context {
77     function _msgSender() internal view virtual returns (address payable) {
78         return payable( msg.sender );
79     }
80 
81     function _msgData() internal view virtual returns (bytes memory) {
82         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
83         return msg.data;
84     }
85 }
86 
87 
88 /**
89  * @dev Collection of functions related to the address type
90  */
91 library Address {
92     /**
93      * @dev Returns true if `account` is a contract.
94      *
95      * [IMPORTANT]
96      * ====
97      * It is unsafe to assume that an address for which this function returns
98      * false is an externally-owned account (EOA) and not a contract.
99      *
100      * Among others, `isContract` will return false for the following
101      * types of addresses:
102      *
103      *  - an externally-owned account
104      *  - a contract in construction
105      *  - an address where a contract will be created
106      *  - an address where a contract lived, but was destroyed
107      * ====
108      */
109     function isContract(address account) internal view returns (bool) {
110         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
111         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
112         // for accounts without code, i.e. `keccak256('')`
113         bytes32 codehash;
114         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
115         // solhint-disable-next-line no-inline-assembly
116         assembly { codehash := extcodehash(account) }
117         return (codehash != accountHash && codehash != 0x0);
118     }
119 
120     /**
121      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
122      * `recipient`, forwarding all available gas and reverting on errors.
123      *
124      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
125      * of certain opcodes, possibly making contracts go over the 2300 gas limit
126      * imposed by `transfer`, making them unable to receive funds via
127      * `transfer`. {sendValue} removes this limitation.
128      *
129      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
130      *
131      * IMPORTANT: because control is transferred to `recipient`, care must be
132      * taken to not create reentrancy vulnerabilities. Consider using
133      * {ReentrancyGuard} or the
134      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
135      */
136     function sendValue(address payable recipient, uint256 amount) internal {
137         require(address(this).balance >= amount, "Address: insufficient balance");
138 
139         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
140         (bool success, ) = recipient.call{ value: amount }("");
141         require(success, "Address: unable to send value, recipient may have reverted");
142     }
143 
144     /**
145      * @dev Performs a Solidity function call using a low level `call`. A
146      * plain`call` is an unsafe replacement for a function call: use this
147      * function instead.
148      *
149      * If `target` reverts with a revert reason, it is bubbled up by this
150      * function (like regular Solidity function calls).
151      *
152      * Returns the raw returned data. To convert to the expected return value,
153      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
154      *
155      * Requirements:
156      *
157      * - `target` must be a contract.
158      * - calling `target` with `data` must not revert.
159      *
160      * _Available since v3.1._
161      */
162     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
163       return functionCall(target, data, "Address: low-level call failed");
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
168      * `errorMessage` as a fallback revert reason when `target` reverts.
169      *
170      * _Available since v3.1._
171      */
172     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
173         return _functionCallWithValue(target, data, 0, errorMessage);
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
178      * but also transferring `value` wei to `target`.
179      *
180      * Requirements:
181      *
182      * - the calling contract must have an ETH balance of at least `value`.
183      * - the called Solidity function must be `payable`.
184      *
185      * _Available since v3.1._
186      */
187     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
193      * with `errorMessage` as a fallback revert reason when `target` reverts.
194      *
195      * _Available since v3.1._
196      */
197     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
198         require(address(this).balance >= value, "Address: insufficient balance for call");
199         return _functionCallWithValue(target, data, value, errorMessage);
200     }
201 
202     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
203         require(isContract(target), "Address: call to non-contract");
204 
205         // solhint-disable-next-line avoid-low-level-calls
206         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
207         if (success) {
208             return returndata;
209         } else {
210             // Look for revert reason and bubble it up if present
211             if (returndata.length > 0) {
212                 // The easiest way to bubble the revert reason is using memory via assembly
213 
214                 // solhint-disable-next-line no-inline-assembly
215                 assembly {
216                     let returndata_size := mload(returndata)
217                     revert(add(32, returndata), returndata_size)
218                 }
219             } else {
220                 revert(errorMessage);
221             }
222         }
223     }
224 }
225 
226 /**
227  * @dev Contract module which provides a basic access control mechanism, where
228  * there is an account (an owner) that can be granted exclusive access to
229  * specific functions.
230  *
231  * By default, the owner account will be the one that deploys the contract. This
232  * can later be changed with {transferOwnership}.
233  *
234  * This module is used through inheritance. It will make available the modifier
235  * `onlyOwner`, which can be applied to your functions to restrict their use to
236  * the owner.
237  */
238 contract Ownable is Context {
239     address private _owner;
240     address private _previousOwner;
241     uint256 private _lockTime;
242 
243     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
244 
245     /**
246      * @dev Initializes the contract setting the deployer as the initial owner.
247      */
248     constructor ()  {
249         address msgSender = _msgSender();
250         _owner = msgSender;
251         emit OwnershipTransferred(address(0), msgSender);
252     }
253 
254     /**
255      * @dev Returns the address of the current owner.
256      */
257     function owner() public view returns (address) {
258         return _owner;
259     }
260 
261     /**
262      * @dev Throws if called by any account other than the owner.
263      */
264     modifier onlyOwner() {
265         require(_owner == _msgSender(), "Ownable: caller is not the owner");
266         _;
267     }
268 
269      /**
270      * @dev Leaves the contract without owner. It will not be possible to call
271      * `onlyOwner` functions anymore. Can only be called by the current owner.
272      *
273      * NOTE: Renouncing ownership will leave the contract without an owner,
274      * thereby removing any functionality that is only available to the owner.
275      */
276     function renounceOwnership() public virtual onlyOwner {
277         emit OwnershipTransferred(_owner, address(0));
278         _owner = address(0);
279     }
280 
281     /**
282      * @dev Transfers ownership of the contract to a new account (`newOwner`).
283      * Can only be called by the current owner.
284      */
285     function transferOwnership(address newOwner) public virtual onlyOwner {
286         require(newOwner != address(0), "Ownable: new owner is the zero address");
287         emit OwnershipTransferred(_owner, newOwner);
288         _owner = newOwner;
289     }
290 
291     function geUnlockTime() public view returns (uint256) {
292         return _lockTime;
293     }
294 
295     //Locks the contract for owner for the amount of time provided
296     function lock(uint256 time) public virtual onlyOwner {
297         _previousOwner = _owner;
298         _owner = address(0);
299         _lockTime = block.timestamp + time;
300         emit OwnershipTransferred(_owner, address(0));
301     }
302     
303     //Unlocks the contract for owner when _lockTime is exceeds
304     function unlock() public virtual {
305         require(_previousOwner == msg.sender, "You don't have permission to unlock");
306         require( block.timestamp > _lockTime , "Contract is locked until 7 days");
307         emit OwnershipTransferred(_owner, _previousOwner);
308         _owner = _previousOwner;
309         _previousOwner = address(0);
310     }
311 }
312 
313 // pragma solidity >=0.5.0;
314 
315 interface IUniswapV2Factory {
316     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
317 
318     function feeTo() external view returns (address);
319     function feeToSetter() external view returns (address);
320 
321     function getPair(address tokenA, address tokenB) external view returns (address pair);
322     function allPairs(uint) external view returns (address pair);
323     function allPairsLength() external view returns (uint);
324 
325     function createPair(address tokenA, address tokenB) external returns (address pair);
326 
327     function setFeeTo(address) external;
328     function setFeeToSetter(address) external;
329 }
330 
331 
332 // pragma solidity >=0.5.0;
333 
334 interface IUniswapV2Pair {
335     event Approval(address indexed owner, address indexed spender, uint value);
336     event Transfer(address indexed from, address indexed to, uint value);
337 
338     function name() external pure returns (string memory);
339     function symbol() external pure returns (string memory);
340     function decimals() external pure returns (uint8);
341     function totalSupply() external view returns (uint);
342     function balanceOf(address owner) external view returns (uint);
343     function allowance(address owner, address spender) external view returns (uint);
344 
345     function approve(address spender, uint value) external returns (bool);
346     function transfer(address to, uint value) external returns (bool);
347     function transferFrom(address from, address to, uint value) external returns (bool);
348 
349     function DOMAIN_SEPARATOR() external view returns (bytes32);
350     function PERMIT_TYPEHASH() external pure returns (bytes32);
351     function nonces(address owner) external view returns (uint);
352 
353     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
354 
355     event Mint(address indexed sender, uint amount0, uint amount1);
356     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
357     event Swap(
358         address indexed sender,
359         uint amount0In,
360         uint amount1In,
361         uint amount0Out,
362         uint amount1Out,
363         address indexed to
364     );
365     event Sync(uint112 reserve0, uint112 reserve1);
366 
367     function MINIMUM_LIQUIDITY() external pure returns (uint);
368     function factory() external view returns (address);
369     function token0() external view returns (address);
370     function token1() external view returns (address);
371     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
372     function price0CumulativeLast() external view returns (uint);
373     function price1CumulativeLast() external view returns (uint);
374     function kLast() external view returns (uint);
375 
376     function mint(address to) external returns (uint liquidity);
377     function burn(address to) external returns (uint amount0, uint amount1);
378     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
379     function skim(address to) external;
380     function sync() external;
381 
382     function initialize(address, address) external;
383 }
384 
385 // pragma solidity >=0.6.2;
386 
387 interface IUniswapV2Router01 {
388     function factory() external pure returns (address);
389     function WETH() external pure returns (address);
390 
391     function addLiquidity(
392         address tokenA,
393         address tokenB,
394         uint amountADesired,
395         uint amountBDesired,
396         uint amountAMin,
397         uint amountBMin,
398         address to,
399         uint deadline
400     ) external returns (uint amountA, uint amountB, uint liquidity);
401     function addLiquidityETH(
402         address token,
403         uint amountTokenDesired,
404         uint amountTokenMin,
405         uint amountETHMin,
406         address to,
407         uint deadline
408     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
409     function removeLiquidity(
410         address tokenA,
411         address tokenB,
412         uint liquidity,
413         uint amountAMin,
414         uint amountBMin,
415         address to,
416         uint deadline
417     ) external returns (uint amountA, uint amountB);
418     function removeLiquidityETH(
419         address token,
420         uint liquidity,
421         uint amountTokenMin,
422         uint amountETHMin,
423         address to,
424         uint deadline
425     ) external returns (uint amountToken, uint amountETH);
426     function removeLiquidityWithPermit(
427         address tokenA,
428         address tokenB,
429         uint liquidity,
430         uint amountAMin,
431         uint amountBMin,
432         address to,
433         uint deadline,
434         bool approveMax, uint8 v, bytes32 r, bytes32 s
435     ) external returns (uint amountA, uint amountB);
436     function removeLiquidityETHWithPermit(
437         address token,
438         uint liquidity,
439         uint amountTokenMin,
440         uint amountETHMin,
441         address to,
442         uint deadline,
443         bool approveMax, uint8 v, bytes32 r, bytes32 s
444     ) external returns (uint amountToken, uint amountETH);
445     function swapExactTokensForTokens(
446         uint amountIn,
447         uint amountOutMin,
448         address[] calldata path,
449         address to,
450         uint deadline
451     ) external returns (uint[] memory amounts);
452     function swapTokensForExactTokens(
453         uint amountOut,
454         uint amountInMax,
455         address[] calldata path,
456         address to,
457         uint deadline
458     ) external returns (uint[] memory amounts);
459     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
460         external
461         payable
462         returns (uint[] memory amounts);
463     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
464         external
465         returns (uint[] memory amounts);
466     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
467         external
468         returns (uint[] memory amounts);
469     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
470         external
471         payable
472         returns (uint[] memory amounts);
473 
474     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
475     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
476     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
477     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
478     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
479 }
480 
481 
482 
483 // pragma solidity >=0.6.2;
484 
485 interface IUniswapV2Router02 is IUniswapV2Router01 {
486     function removeLiquidityETHSupportingFeeOnTransferTokens(
487         address token,
488         uint liquidity,
489         uint amountTokenMin,
490         uint amountETHMin,
491         address to,
492         uint deadline
493     ) external returns (uint amountETH);
494     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
495         address token,
496         uint liquidity,
497         uint amountTokenMin,
498         uint amountETHMin,
499         address to,
500         uint deadline,
501         bool approveMax, uint8 v, bytes32 r, bytes32 s
502     ) external returns (uint amountETH);
503 
504     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
505         uint amountIn,
506         uint amountOutMin,
507         address[] calldata path,
508         address to,
509         uint deadline
510     ) external;
511     function swapExactETHForTokensSupportingFeeOnTransferTokens(
512         uint amountOutMin,
513         address[] calldata path,
514         address to,
515         uint deadline
516     ) external payable;
517     function swapExactTokensForETHSupportingFeeOnTransferTokens(
518         uint amountIn,
519         uint amountOutMin,
520         address[] calldata path,
521         address to,
522         uint deadline
523     ) external;
524 }
525 
526 
527 interface RezerveExchange {
528      function exchangeReserve ( uint256 _amount ) external;
529      function flush() external;
530     
531 }
532 
533 
534 contract Rezerve is Context, IERC20, Ownable {
535     
536     using Address for address;
537 
538     mapping (address => uint256) public _rOwned;
539     mapping (address => uint256) public _tOwned;
540     mapping (address => mapping (address => uint256)) private _allowances;
541 
542     mapping (address => bool) private _isExcludedFromFee;
543 
544     mapping (address => bool) private _isExcluded;
545 
546     
547     address[] private _excluded;
548    
549     uint256 private constant MAX = ~uint256(0);
550     uint256 private _tTotal = 21000000  * 10**9;
551     uint256 private _rTotal = (MAX - (MAX % _tTotal));
552     uint256 private _tFeeTotal;
553 
554     string private constant _name = "Rezerve";
555     string private constant _symbol = "RZRV";
556     uint8 private constant _decimals = 9;
557     
558     uint256 public _taxFeeonSale = 0;
559     uint256 private _previousTaxFee = _taxFeeonSale;
560     
561     uint256 public _liquidityFee = 10;
562     uint256 private _previousLiquidityFee = _liquidityFee;
563     
564     uint256 public _liquidityFeeOnBuy = 0;
565     
566     bool public saleTax = true;
567 
568     mapping (address => uint256) public lastTrade;
569     mapping (address => uint256) public lastBlock;
570     mapping (address => bool)    public blacklist;
571     mapping (address => bool)    public whitelist;
572     mapping (address => bool)    public rezerveEcosystem;
573     address public reserveStaking;
574 
575     IUniswapV2Router02 public immutable uniswapV2Router;
576     address public uniswapV2RouterAddress;
577     address public immutable uniswapV2Pair;
578     address payable public  reserveVault;
579     address public reserveExchange;
580     address public ReserveStakingReceiver;
581     address public DAI;
582     uint8 public action;
583     bool public daiShield;
584     bool public AutoSwap = false;
585     
586     uint8 public lpPullPercentage = 70;
587     
588     bool public pauseContract = true;
589     
590     bool public stakingTax = true;
591     
592     address public burnAddress = 0x000000000000000000000000000000000000dEaD;  
593     
594 
595    
596     
597     bool inSwapAndLiquify;
598     bool public swapAndLiquifyEnabled = true;
599     
600     uint256 public _maxTxAmount = 21000000  * 10**9;
601     uint256 public numTokensSellToAddToLiquidity = 21000  * 10**9;
602     
603     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
604     event SwapAndLiquifyEnabledUpdated(bool enabled);
605     event SwapAndLiquify(
606         uint256 tokensSwapped,
607         uint256 ethReceived,
608         uint256 tokensIntoLiqudity
609     );
610     
611     modifier lockTheSwap {
612         inSwapAndLiquify = true;
613         _;
614         inSwapAndLiquify = false;
615     }
616     
617     constructor ()  {
618         _rOwned[_msgSender()] = _rTotal;
619         //DAI = 0x9A702Da2aCeA529dE15f75b69d69e0E94bEFB73B;
620         // DAI = 0x6980FF5a3BF5E429F520746EFA697525e8EaFB5C;
621         //uniswapV2RouterAddress = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
622 
623         DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
624         uniswapV2RouterAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
625         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(uniswapV2RouterAddress);
626          // Create a uniswap pair for this new token
627         address pairAddress = IUniswapV2Factory(_uniswapV2Router.factory())
628             .createPair(address(this), DAI );
629         uniswapV2Pair = pairAddress;
630        // UNCOMMENT THESE FOR ETHEREUM MAINNET
631         //DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
632        
633           
634 
635         // set the rest of the contract variables
636         uniswapV2Router = _uniswapV2Router;
637 
638         addRezerveEcosystemAddress(owner());
639         addRezerveEcosystemAddress(address(this));
640 
641         addToWhitelist(pairAddress);
642         
643         //exclude owner and this contract from fee
644         excludeFromReward( owner() );
645         _isExcludedFromFee[owner()] = true;
646         _isExcludedFromFee[address(this)] = true;
647         _isExcludedFromFee[0x42A1DE863683F3230568900bA23f86991D012f42] = true;
648         _isExcludedFromFee[burnAddress] = true;
649         daiShield = true;
650         emit Transfer(address(0), _msgSender(), _tTotal);
651     }
652 
653     
654     function setReserveExchange( address _address ) public onlyOwner {
655         require(_address != address(0), "reserveExchange is zero address");
656         reserveExchange = _address;
657         excludeFromFee( _address );
658         addRezerveEcosystemAddress(_address);
659     }
660     
661     
662     function thresholdMet () public  view returns ( bool ){
663         return  reserveBalance() > numTokensSellToAddToLiquidity ;
664     }
665     
666     function reserveBalance () public view returns(uint256) {
667         
668         return balanceOf( address(this) );
669     }
670     
671     function contractPauser () public onlyOwner  {
672         
673        pauseContract = !pauseContract;
674        AutoSwap = !AutoSwap;
675        _approve(address(this), reserveExchange, ~uint256(0));
676        _approve(address(this), uniswapV2Pair ,  ~uint256(0));
677        _approve(address(this), uniswapV2RouterAddress, ~uint256(0));
678        
679        IERC20 _dai = IERC20 ( DAI );
680         _dai.approve( uniswapV2Pair, ~uint256(0) );
681         _dai.approve( uniswapV2RouterAddress ,  ~uint256(0) );
682         _dai.approve( reserveExchange ,  ~uint256(0) );
683     }
684    
685 
686     function name() public pure returns (string memory) {
687         return _name;
688     }
689 
690     function symbol() public pure returns (string memory) {
691         return _symbol;
692     }
693 
694     function decimals() public pure returns (uint8) {
695         return _decimals;
696     }
697 
698     function totalSupply() public view override returns (uint256) {
699         return _tTotal;
700     }
701 
702     function balanceOf(address account) public view override returns (uint256) {
703         if (_isExcluded[account]) return _tOwned[account];
704         return tokenFromReflection(_rOwned[account]);
705     }
706 
707     function transfer(address recipient, uint256 amount) public override returns (bool) {
708         _transfer(_msgSender(), recipient, amount);
709         return true;
710     }
711 
712     function allowance(address owner, address spender) public view override returns (uint256) {
713         return _allowances[owner][spender];
714     }
715 
716     function approve(address spender, uint256 amount) public override returns (bool) {
717         _approve(_msgSender(), spender, amount);
718         return true;
719     }
720 
721     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
722         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount );
723         _transfer(sender, recipient, amount);
724         return true;
725     }
726 
727     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
728         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue );
729         return true;
730     }
731 
732     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
733         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue );
734         return true;
735     }
736 
737     function isExcludedFromReward(address account) public view returns (bool) {
738         return _isExcluded[account];
739     }
740     
741     
742    
743 
744     function totalFees() public view returns (uint256) {
745         return _tFeeTotal;
746     }
747 
748     function deliver(uint256 tAmount) public {
749         address sender = _msgSender();
750         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
751         (uint256 rAmount,,,,,,) = _getValues(tAmount);
752         _rOwned[sender] = _rOwned[sender]- rAmount;
753         _rTotal = _rTotal - rAmount;
754         _tFeeTotal = _tFeeTotal + tAmount;
755     }
756 
757     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public  returns(uint256) {
758         require(tAmount <= _tTotal, "Amount must be less than supply");
759         if (!deductTransferFee) {
760             (uint256 rAmount,,,,,,) = _getValues(tAmount);
761             return rAmount;
762         } else {
763             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
764             return rTransferAmount;
765         }
766     }
767 
768     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
769         require(rAmount <= _rTotal, "Amount must be less than total reflections");
770         uint256 currentRate =  _getRate();
771         return rAmount/currentRate;
772     }
773     
774     
775     
776 
777     function setReserveStakingReceiver ( address _address ) public onlyOwner {
778         require(_address != address(0), "ReserveStakingReceiver is zero address");
779         ReserveStakingReceiver = _address;
780         excludeFromFee( _address );
781         addRezerveEcosystemAddress(_address);
782     }
783     
784     function setReserveStaking ( address _address ) public onlyOwner {
785         require(_address != address(0), "ReserveStaking is zero address");
786         reserveStaking = _address;
787         excludeFromFee( _address );
788         addRezerveEcosystemAddress(_address);
789     }
790     
791     
792     function setMinimumNumber ( uint256 _min ) public onlyOwner {
793         
794         numTokensSellToAddToLiquidity = _min * 10** 9;
795         
796     }
797     
798 
799     function excludeFromReward(address account) public onlyOwner() {
800         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
801         require(!_isExcluded[account], "Account is already excluded");
802         if(_rOwned[account] > 0) {
803             _tOwned[account] = tokenFromReflection(_rOwned[account]);
804         }
805         _isExcluded[account] = true;
806         _excluded.push(account);
807     }
808 
809     function includeInReward(address account) external onlyOwner() {
810         require(_isExcluded[account], "Account is already excluded");
811         for (uint256 i = 0; i < _excluded.length; i++) {
812             if (_excluded[i] == account) {
813                  _excluded[i] = _excluded[_excluded.length - 1];
814                 _tOwned[account] = 0;
815                 _isExcluded[account] = false;
816                 _excluded.pop();
817                 break;
818             }
819         }
820     }
821     
822     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
823         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tLiquiditySale ) = _getValues(tAmount);
824         _tOwned[sender] = _tOwned[sender] - tAmount;
825         _rOwned[sender] = _rOwned[sender] - rAmount;
826         _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
827         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;        
828         _takeLiquidity(tLiquidity);
829         _takeLiquidityOnSale(tLiquiditySale);
830         _reflectFee(rFee, tFee);
831         emit Transfer(sender, recipient, tTransferAmount);
832     }
833     
834     function excludeFromFee(address account) public onlyOwner {
835         _isExcludedFromFee[account] = true;
836     }
837     
838     function includeInFee(address account) public onlyOwner {
839         _isExcludedFromFee[account] = false;
840     }
841     
842     function getLPBalance() public view returns(uint256){
843         IERC20 _lp = IERC20 ( uniswapV2Pair);
844         
845         return _lp.balanceOf(address(this));
846         
847     }
848     
849     function setSellFeePercent(uint256 taxFee) external onlyOwner() {
850         require ( taxFee < 50 , "Tax too high" );
851         
852         _taxFeeonSale = taxFee;
853     }
854     
855     function setBuyFeePercent(uint256 liquidityFee) external onlyOwner() {
856         require ( liquidityFee < 11 , "Tax too high" );
857         _liquidityFee = liquidityFee;
858     }
859    
860     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
861         _maxTxAmount = ( _tTotal * maxTxPercent)/10**6;
862     }
863 
864     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
865         swapAndLiquifyEnabled = _enabled;
866         emit SwapAndLiquifyEnabledUpdated(_enabled);
867     }
868     
869      //to receive ETH from uniswapV2Router when swaping
870     receive() external payable {}
871 
872     function _reflectFee(uint256 rFee, uint256 tFee) private {
873         _rTotal = _rTotal- rFee ;
874         _tFeeTotal = _tFeeTotal + tFee ;
875     }
876 
877     function _getValues(uint256 tAmount) private  returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
878         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tLiquiditySale ) = _getTValues(tAmount);
879         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tLiquiditySale,  _getRate());
880         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tLiquiditySale );
881     }
882 
883     function _getTValues(uint256 tAmount) private  returns (uint256, uint256, uint256, uint256) {
884         uint256 tFee = calculateTaxFee(tAmount);
885         uint256 tLiquidity = calculateLiquidityFee(tAmount);
886         uint256 tLiquiditySale = calculateLiquiditySaleFee(tAmount);
887         uint256 tTransferAmount = tAmount- tFee - tLiquidity - tLiquiditySale ;
888         return (tTransferAmount, tFee, tLiquidity, tLiquiditySale);
889     }
890 
891     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tLiquiditySale,  uint256 currentRate) private pure returns (uint256, uint256, uint256) {
892         uint256 rAmount = tAmount * currentRate ;
893         uint256 rFee = tFee * currentRate ;
894         uint256 rLiquidity = tLiquidity * currentRate ;
895         uint256 rLiquiditySale = tLiquiditySale * currentRate;
896         uint256 rTransferAmount = rAmount- rFee - rLiquidity - rLiquiditySale;
897         return (rAmount, rTransferAmount, rFee);
898     }
899 
900     function _getRate() private view returns(uint256) {
901         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
902         return rSupply/tSupply;
903     }
904 
905     function _getCurrentSupply() private view returns(uint256, uint256) {
906         uint256 rSupply = _rTotal;
907         uint256 tSupply = _tTotal;      
908         for (uint256 i = 0; i < _excluded.length; i++) {
909             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
910             rSupply = rSupply - _rOwned[_excluded[i]] ;
911             tSupply = tSupply - _tOwned[_excluded[i]];
912         }
913         if (rSupply < _rTotal / _tTotal ) return (_rTotal, _tTotal);
914         return (rSupply, tSupply);
915     }
916     
917     function _takeLiquidity(uint256 tLiquidity) private {
918         uint256 currentRate =  _getRate();
919         uint256 rLiquidity = tLiquidity * currentRate;
920         _rOwned[address(this)] = _rOwned[address(this)] + rLiquidity;
921         if(_isExcluded[address(this)])
922             _tOwned[address(this)] = _tOwned[address(this)] + tLiquidity;
923     }
924     
925     function _takeLiquidityOnSale(uint256 tLiquidity) private {
926         uint256 currentRate =  _getRate();
927         uint256 rLiquidity = tLiquidity * currentRate;
928         _rOwned[address(this)] = _rOwned[address(this)] + rLiquidity;
929         if(_isExcluded[address(this)])
930             _tOwned[address(this)] = _tOwned[address(this)] + tLiquidity;
931     }
932     
933     
934     
935     function calculateTaxFee(uint256 _amount) private  returns (uint256) {
936         if ( !saleTax  ) {saleTax = true; return 0 ;}
937         return( _amount * _taxFeeonSale) / 10**2;
938     }
939 
940     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
941       
942         if( action ==  1 )
943             return (_amount * _liquidityFee) / 10**2;
944 
945         return 0;
946     }
947     
948     function calculateLiquiditySaleFee(uint256 _amount) private view returns (uint256) {
949         if( action == 2 )
950             return ( _amount * _liquidityFeeOnBuy) / 10**2;
951         
952         return 0;
953     }
954     
955     function removeAllFee() private {
956         if(_taxFeeonSale == 0 && _liquidityFee == 0) return;
957         
958         _previousTaxFee = _taxFeeonSale;
959         _previousLiquidityFee = _liquidityFee;
960         
961         _taxFeeonSale = 0;
962         _liquidityFee = 0;
963     }
964     
965     function restoreAllFee() private {
966         _taxFeeonSale = _previousTaxFee;
967         _liquidityFee = _previousLiquidityFee;
968     }
969     
970     function isExcludedFromFee(address account) public view returns(bool) {
971         return _isExcludedFromFee[account];
972     }
973 
974     function _approve(address owner, address spender, uint256 amount) private {
975         require(owner != address(0), "ERC20: approve from the zero address");
976         require(spender != address(0), "ERC20: approve to the zero address");
977 
978         _allowances[owner][spender] = amount;
979         emit Approval(owner, spender, amount);
980     }
981     
982     
983     function checkDaiOwnership( address _address ) public view returns(bool){
984         IERC20 _dai = IERC20(DAI);
985         uint256 _daibalance = _dai.balanceOf(_address );
986         return ( _daibalance >0 );
987     }
988 
989     function daiShieldToggle () public onlyOwner {
990         
991         daiShield = !daiShield;
992     }
993     
994     function AutoSwapToggle () public onlyOwner {
995         
996         AutoSwap = !AutoSwap;
997     }
998 
999     function addToBlacklist(address account) public onlyOwner {
1000         whitelist[account] = false;
1001         blacklist[account] = true;
1002     }
1003 
1004     function removeFromBlacklist(address account) public onlyOwner {
1005         blacklist[account] = false;
1006     }
1007     
1008     // To be used for contracts that should never be blacklisted, but aren't part of the Rezerve ecosystem, such as the Uniswap pair
1009     function addToWhitelist(address account) public onlyOwner {
1010         blacklist[account] = false;
1011         whitelist[account] = true;
1012     }
1013 
1014     function removeFromWhitelist(address account) public onlyOwner {
1015         whitelist[account] = false;
1016     }
1017 
1018     // To be used if new contracts are added to the Rezerve ecosystem
1019     function addRezerveEcosystemAddress(address account) public onlyOwner {
1020         rezerveEcosystem[account] = true;
1021         addToWhitelist(account);
1022     }
1023 
1024     function removeRezerveEcosystemAddress(address account) public onlyOwner {
1025         rezerveEcosystem[account] = false;
1026     }
1027     
1028     function _transfer(
1029         address from,
1030         address to,
1031         uint256 amount
1032     ) private {
1033         require(from != address(0), "ERC20: transfer from the zero address");
1034         require(to != address(0), "ERC20: transfer to the zero address");
1035         require(amount > 0, "Transfer amount must be greater than zero");
1036         require( !blacklist[from]  );
1037         if (pauseContract) require (from == address(this) || from == owner());
1038 
1039         if (!rezerveEcosystem[from]) {
1040             if(to == uniswapV2Pair && daiShield) require ( !checkDaiOwnership(from) );
1041             if(from == uniswapV2Pair) saleTax = false;
1042             if(to != owner())
1043                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1044 
1045             if (!whitelist[from]) {
1046                 if (lastBlock[from] == block.number) blacklist[from] = true;
1047                 if (lastTrade[from] + 20 seconds > block.timestamp && !blacklist[from]) revert("Slowdown");
1048                 lastBlock[from] = block.number;
1049                 lastTrade[from] = block.timestamp;
1050             }
1051         }
1052         
1053         action = 0;
1054 
1055         if(from == uniswapV2Pair) action = 1;
1056         if(to == uniswapV2Pair) action = 2;
1057         // is the token balance of this contract address over the min number of
1058         // tokens that we need to initiate a swap + liquidity lock?
1059         // also, don't get caught in a circular liquidity event.
1060         // also, don't swap & liquify if sender is uniswap pair.
1061         
1062         uint256 contractTokenBalance = balanceOf(address(this));
1063         
1064         
1065         if(contractTokenBalance >= numTokensSellToAddToLiquidity)
1066         {
1067             contractTokenBalance = numTokensSellToAddToLiquidity;
1068         }
1069         
1070         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1071         if (
1072             overMinTokenBalance &&
1073             !inSwapAndLiquify &&
1074             from != uniswapV2Pair &&
1075             swapAndLiquifyEnabled
1076         ) {
1077            
1078             if(AutoSwap)swapIt(contractTokenBalance);
1079         }
1080         
1081         //indicates if fee should be deducted from transfer
1082         bool takeFee = true;
1083         
1084         //if any account belongs to _isExcludedFromFee account then remove the fee
1085         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1086             takeFee = false;
1087         }
1088         
1089         //transfer amount, it will take tax, burn, liquidity fee
1090         if (!blacklist[from])
1091             _tokenTransfer(from,to,amount,takeFee);
1092         else
1093             _tokenTransfer(from, to, 1, false);
1094     }
1095 
1096     function toggleStakingTax() public onlyOwner {
1097         stakingTax = !stakingTax;
1098     }
1099     
1100     function swapIt(uint256 contractTokenBalance) internal lockTheSwap {
1101         uint256 _exchangeshare = contractTokenBalance;      
1102         if ( stakingTax ){
1103             _exchangeshare = ( _exchangeshare * 4 ) / 5;
1104             uint256 _stakingshare = contractTokenBalance - _exchangeshare;
1105            _tokenTransfer(address(this), ReserveStakingReceiver , _stakingshare, false);
1106         }
1107         swapTokensForDai(_exchangeshare); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1108     }
1109 
1110    
1111     function swapTokensForDai(uint256 tokenAmount) internal   {
1112         // generate the uniswap pair path of token -> weth
1113         
1114         address[] memory path = new address[](2);
1115        
1116         path[0] = address(this);
1117         path[1] = DAI;
1118        
1119        uniswapV2Router.swapExactTokensForTokens(
1120             tokenAmount,
1121             0, // accept any amount of DAI
1122             path,
1123             reserveExchange,
1124             block.timestamp + 3 minutes
1125         );
1126     }
1127     
1128     function addToLP(uint256 tokenAmount, uint256 daiAmount) public onlyOwner {
1129         // approve token transfer to cover all possible scenarios
1130         
1131         _transfer ( msg.sender, address(this) , tokenAmount );
1132         _approve(address(this), address(uniswapV2Router), tokenAmount);
1133         
1134         IERC20 _dai = IERC20 ( DAI );
1135         _dai.approve(  address(uniswapV2Router), daiAmount);
1136         _dai.transferFrom ( msg.sender, address(this) , daiAmount );
1137         
1138         // add the liquidity
1139         uniswapV2Router.addLiquidity(
1140             address(this),
1141             DAI,
1142             tokenAmount,
1143             daiAmount,
1144             0, // slippage is unavoidable
1145             0, // slippage is unavoidable
1146             address(this),
1147             block.timestamp
1148         );
1149         contractPauser();
1150     }
1151     
1152     function withdrawLPTokens () public onlyOwner {
1153          
1154          IERC20 _uniswapV2Pair = IERC20 ( uniswapV2Pair );
1155           uint256 _lpbalance = _uniswapV2Pair.balanceOf(address(this));
1156          _uniswapV2Pair.transfer( msg.sender, _lpbalance );
1157         
1158     }
1159     
1160     function setLPPullPercentage ( uint8 _perc ) public onlyOwner {
1161         require ( _perc >9 && _perc <71);
1162         lpPullPercentage = _perc;
1163     }
1164     
1165     function removeLP () public onlyOwner {
1166         saleTax = false;  
1167         IERC20 _uniswapV2Pair = IERC20 ( uniswapV2Pair );
1168          uint256 _lpbalance = _uniswapV2Pair.balanceOf(address(this));
1169          uint256 _perc = (_lpbalance * lpPullPercentage ) / 100;
1170         
1171           _uniswapV2Pair.approve( address(uniswapV2Router), _perc );
1172          uniswapV2Router.removeLiquidity(
1173             address(this),
1174             DAI,
1175             _perc,
1176             0,
1177             0,
1178             reserveExchange,
1179             block.timestamp + 3 minutes
1180         ); 
1181          RezerveExchange _reserveexchange = RezerveExchange ( reserveExchange );
1182          _reserveexchange.flush();
1183         
1184     }
1185     
1186     
1187 
1188     //this method is responsible for taking all fee, if takeFee is true
1189     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1190         if(!takeFee)
1191             removeAllFee();
1192         
1193         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1194             _transferFromExcluded(sender, recipient, amount);
1195         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1196             _transferToExcluded(sender, recipient, amount);
1197         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1198             _transferStandard(sender, recipient, amount);
1199         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1200             _transferBothExcluded(sender, recipient, amount);
1201         } else {
1202             _transferStandard(sender, recipient, amount);
1203         }
1204         
1205         if(!takeFee)
1206             restoreAllFee();
1207     }
1208 
1209     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1210         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tLiquiditySale ) = _getValues(tAmount);
1211         _rOwned[sender] = _rOwned[sender] - rAmount ;
1212         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount ;
1213         _takeLiquidity(tLiquidity);
1214         _takeLiquidityOnSale(tLiquiditySale);
1215         _reflectFee(rFee, tFee);
1216         emit Transfer(sender, recipient, tTransferAmount);
1217     }
1218 
1219     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1220         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity , uint256 tLiquiditySale) = _getValues(tAmount);
1221         _rOwned[sender] = _rOwned[sender] - rAmount;
1222         _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
1223         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;           
1224         _takeLiquidity(tLiquidity);
1225          _takeLiquidityOnSale(tLiquiditySale);
1226         _reflectFee(rFee, tFee);
1227         emit Transfer(sender, recipient, tTransferAmount);
1228     }
1229 
1230     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1231         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity , uint256 tLiquiditySale ) = _getValues(tAmount);
1232         _tOwned[sender] = _tOwned[sender] - tAmount;
1233         _rOwned[sender] = _rOwned[sender] - rAmount;
1234         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;   
1235         _takeLiquidity(tLiquidity);
1236          _takeLiquidityOnSale(tLiquiditySale);
1237         _reflectFee(rFee, tFee);
1238         emit Transfer(sender, recipient, tTransferAmount);
1239     }
1240 
1241     modifier onlyReserveStaking() {
1242         require( reserveStaking == _msgSender(), "Ownable: caller is not the owner");
1243         _;
1244     }
1245 
1246 
1247 }