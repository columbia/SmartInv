1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity 0.8.7;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return payable(msg.sender);
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 /**
17  * @dev Contract module which provides a basic access control mechanism, where
18  * there is an account (an owner) that can be granted exclusive access to
19  * specific functions.
20  *
21  * By default, the owner account will be the one that deploys the contract. This
22  * can later be changed with {transferOwnership}.
23  *
24  * This module is used through inheritance. It will make available the modifier
25  * `onlyOwner`, which can be applied to your functions to restrict their use to
26  * the owner.
27  */
28 contract Ownable is Context {
29     address private _owner;
30     address private _previousOwner;
31     uint256 private _lockTime;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     /**
36      * @dev Initializes the contract setting the deployer as the initial owner.
37      */
38     constructor () {
39         address msgSender = _msgSender();
40         _owner = msgSender;
41         emit OwnershipTransferred(address(0), msgSender);
42     }
43 
44     /**
45      * @dev Returns the address of the current owner.
46      */
47     function owner() public view returns (address) {
48         return _owner;
49     }
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() {
55         require(_owner == _msgSender(), "Ownable: caller is not the owner");
56         _;
57     }
58 
59      /**
60      * @dev Leaves the contract without owner. It will not be possible to call
61      * `onlyOwner` functions anymore. Can only be called by the current owner.
62      *
63      * NOTE: Renouncing ownership will leave the contract without an owner,
64      * thereby removing any functionality that is only available to the owner.
65      */
66     function renounceOwnership() public virtual onlyOwner {
67         emit OwnershipTransferred(_owner, address(0));
68         _owner = address(0);
69     }
70 
71     /**
72      * @dev Transfers ownership of the contract to a new account (`newOwner`).
73      * Can only be called by the current owner.
74      */
75     function transferOwnership(address newOwner) public virtual onlyOwner {
76         require(newOwner != address(0), "Ownable: new owner is the zero address");
77         emit OwnershipTransferred(_owner, newOwner);
78         _owner = newOwner;
79     }
80 
81     function geUnlockTime() public view returns (uint256) {
82         return _lockTime;
83     }
84 
85     //Locks the contract for owner for the amount of time provided
86     function lock(uint256 time) public virtual onlyOwner {
87         _previousOwner = _owner;
88         _owner = address(0);
89         _lockTime = block.timestamp + time;
90         emit OwnershipTransferred(_owner, address(0));
91     }
92     
93     //Unlocks the contract for owner when _lockTime is exceeds
94     function unlock() public virtual {
95         require(_previousOwner == msg.sender, "You don't have permission to unlock");
96         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
97         emit OwnershipTransferred(_owner, _previousOwner);
98         _owner = _previousOwner;
99     }
100 }
101 
102 interface IERC20 {
103 
104     function totalSupply() external view returns (uint256);
105     function balanceOf(address account) external view returns (uint256);
106     function transfer(address recipient, uint256 amount) external returns (bool);
107     function allowance(address owner, address spender) external view returns (uint256);
108     function approve(address spender, uint256 amount) external returns (bool);
109     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
110     event Transfer(address indexed from, address indexed to, uint256 value);
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 
115 
116 /**
117  * @dev Wrappers over Solidity's arithmetic operations with added overflow
118  * checks.
119  *
120  * Arithmetic operations in Solidity wrap on overflow. This can easily result
121  * in bugs, because programmers usually assume that an overflow raises an
122  * error, which is the standard behavior in high level programming languages.
123  * `SafeMath` restores this intuition by reverting the transaction when an
124  * operation overflows.
125  *
126  * Using this library instead of the unchecked operations eliminates an entire
127  * class of bugs, so it's recommended to use it always.
128  */
129  
130 library SafeMath {
131    
132     function add(uint256 a, uint256 b) internal pure returns (uint256) {
133         uint256 c = a + b;
134         require(c >= a, "SafeMath: addition overflow");
135 
136         return c;
137     }
138    
139     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
140         return sub(a, b, "SafeMath: subtraction overflow");
141     }
142 
143     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
144         require(b <= a, errorMessage);
145         uint256 c = a - b;
146 
147         return c;
148     }
149 
150     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
152         // benefit is lost if 'b' is also tested.
153         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
154         if (a == 0) {
155             return 0;
156         }
157 
158         uint256 c = a * b;
159         require(c / a == b, "SafeMath: multiplication overflow");
160 
161         return c;
162     }
163 
164     function div(uint256 a, uint256 b) internal pure returns (uint256) {
165         return div(a, b, "SafeMath: division by zero");
166     }
167 
168     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b > 0, errorMessage);
170         uint256 c = a / b;
171         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
172 
173         return c;
174     }
175 
176     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
177         return mod(a, b, "SafeMath: modulo by zero");
178     }
179 
180 
181     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
182         require(b != 0, errorMessage);
183         return a % b;
184     }
185 }
186 
187 /**
188  * @dev Collection of functions related to the address type
189  */
190 library Address {
191     /**
192      * @dev Returns true if `account` is a contract.
193      *
194      * [IMPORTANT]
195      * ====
196      * It is unsafe to assume that an address for which this function returns
197      * false is an externally-owned account (EOA) and not a contract.
198      *
199      * Among others, `isContract` will return false for the following
200      * types of addresses:
201      *
202      *  - an externally-owned account
203      *  - a contract in construction
204      *  - an address where a contract will be created
205      *  - an address where a contract lived, but was destroyed
206      * ====
207      */
208     function isContract(address account) internal view returns (bool) {
209         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
210         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
211         // for accounts without code, i.e. `keccak256('')`
212         bytes32 codehash;
213         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
214         // solhint-disable-next-line no-inline-assembly
215         assembly { codehash := extcodehash(account) }
216         return (codehash != accountHash && codehash != 0x0);
217     }
218 
219     /**
220      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
221      * `recipient`, forwarding all available gas and reverting on errors.
222      *
223      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
224      * of certain opcodes, possibly making contracts go over the 2300 gas limit
225      * imposed by `transfer`, making them unable to receive funds via
226      * `transfer`. {sendValue} removes this limitation.
227      *
228      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
229      *
230      * IMPORTANT: because control is transferred to `recipient`, care must be
231      * taken to not create reentrancy vulnerabilities. Consider using
232      * {ReentrancyGuard} or the
233      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
234      */
235     function sendValue(address payable recipient, uint256 amount) internal {
236         require(address(this).balance >= amount, "Address: insufficient balance");
237 
238         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
239         (bool success, ) = recipient.call{ value: amount }("");
240         require(success, "Address: unable to send value, recipient may have reverted");
241     }
242 
243     /**
244      * @dev Performs a Solidity function call using a low level `call`. A
245      * plain`call` is an unsafe replacement for a function call: use this
246      * function instead.
247      *
248      * If `target` reverts with a revert reason, it is bubbled up by this
249      * function (like regular Solidity function calls).
250      *
251      * Returns the raw returned data. To convert to the expected return value,
252      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
253      *
254      * Requirements:
255      *
256      * - `target` must be a contract.
257      * - calling `target` with `data` must not revert.
258      *
259      * _Available since v3.1._
260      */
261     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
262       return functionCall(target, data, "Address: low-level call failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
267      * `errorMessage` as a fallback revert reason when `target` reverts.
268      *
269      * _Available since v3.1._
270      */
271     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
272         return _functionCallWithValue(target, data, 0, errorMessage);
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
277      * but also transferring `value` wei to `target`.
278      *
279      * Requirements:
280      *
281      * - the calling contract must have an ETH balance of at least `value`.
282      * - the called Solidity function must be `payable`.
283      *
284      * _Available since v3.1._
285      */
286     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
287         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
292      * with `errorMessage` as a fallback revert reason when `target` reverts.
293      *
294      * _Available since v3.1._
295      */
296     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
297         require(address(this).balance >= value, "Address: insufficient balance for call");
298         return _functionCallWithValue(target, data, value, errorMessage);
299     }
300 
301     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
302         require(isContract(target), "Address: call to non-contract");
303 
304         // solhint-disable-next-line avoid-low-level-calls
305         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
306         if (success) {
307             return returndata;
308         } else {
309             // Look for revert reason and bubble it up if present
310             if (returndata.length > 0) {
311                 // The easiest way to bubble the revert reason is using memory via assembly
312 
313                 // solhint-disable-next-line no-inline-assembly
314                 assembly {
315                     let returndata_size := mload(returndata)
316                     revert(add(32, returndata), returndata_size)
317                 }
318             } else {
319                 revert(errorMessage);
320             }
321         }
322     }
323 }
324 
325 // pragma solidity >=0.5.0;
326 
327 interface IUniswapV2Factory {
328     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
329 
330     function feeTo() external view returns (address);
331     function feeToSetter() external view returns (address);
332 
333     function getPair(address tokenA, address tokenB) external view returns (address pair);
334     function allPairs(uint) external view returns (address pair);
335     function allPairsLength() external view returns (uint);
336 
337     function createPair(address tokenA, address tokenB) external returns (address pair);
338 
339     function setFeeTo(address) external;
340     function setFeeToSetter(address) external;
341 }
342 
343 
344 // pragma solidity >=0.5.0;
345 
346 interface IUniswapV2Pair {
347     event Approval(address indexed owner, address indexed spender, uint value);
348     event Transfer(address indexed from, address indexed to, uint value);
349 
350     function name() external pure returns (string memory);
351     function symbol() external pure returns (string memory);
352     function decimals() external pure returns (uint8);
353     function totalSupply() external view returns (uint);
354     function balanceOf(address owner) external view returns (uint);
355     function allowance(address owner, address spender) external view returns (uint);
356 
357     function approve(address spender, uint value) external returns (bool);
358     function transfer(address to, uint value) external returns (bool);
359     function transferFrom(address from, address to, uint value) external returns (bool);
360 
361     function DOMAIN_SEPARATOR() external view returns (bytes32);
362     function PERMIT_TYPEHASH() external pure returns (bytes32);
363     function nonces(address owner) external view returns (uint);
364 
365     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
366 
367     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
368     event Swap(
369         address indexed sender,
370         uint amount0In,
371         uint amount1In,
372         uint amount0Out,
373         uint amount1Out,
374         address indexed to
375     );
376     event Sync(uint112 reserve0, uint112 reserve1);
377 
378     function MINIMUM_LIQUIDITY() external pure returns (uint);
379     function factory() external view returns (address);
380     function token0() external view returns (address);
381     function token1() external view returns (address);
382     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
383     function price0CumulativeLast() external view returns (uint);
384     function price1CumulativeLast() external view returns (uint);
385     function kLast() external view returns (uint);
386 
387     function burn(address to) external returns (uint amount0, uint amount1);
388     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
389     function skim(address to) external;
390     function sync() external;
391 
392     function initialize(address, address) external;
393 }
394 
395 // pragma solidity >=0.6.2;
396 
397 interface IUniswapV2Router01 {
398     function factory() external pure returns (address);
399     function WETH() external pure returns (address);
400 
401     function addLiquidity(
402         address tokenA,
403         address tokenB,
404         uint amountADesired,
405         uint amountBDesired,
406         uint amountAMin,
407         uint amountBMin,
408         address to,
409         uint deadline
410     ) external returns (uint amountA, uint amountB, uint liquidity);
411     function addLiquidityETH(
412         address token,
413         uint amountTokenDesired,
414         uint amountTokenMin,
415         uint amountETHMin,
416         address to,
417         uint deadline
418     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
419     function removeLiquidity(
420         address tokenA,
421         address tokenB,
422         uint liquidity,
423         uint amountAMin,
424         uint amountBMin,
425         address to,
426         uint deadline
427     ) external returns (uint amountA, uint amountB);
428     function removeLiquidityETH(
429         address token,
430         uint liquidity,
431         uint amountTokenMin,
432         uint amountETHMin,
433         address to,
434         uint deadline
435     ) external returns (uint amountToken, uint amountETH);
436     function removeLiquidityWithPermit(
437         address tokenA,
438         address tokenB,
439         uint liquidity,
440         uint amountAMin,
441         uint amountBMin,
442         address to,
443         uint deadline,
444         bool approveMax, uint8 v, bytes32 r, bytes32 s
445     ) external returns (uint amountA, uint amountB);
446     function removeLiquidityETHWithPermit(
447         address token,
448         uint liquidity,
449         uint amountTokenMin,
450         uint amountETHMin,
451         address to,
452         uint deadline,
453         bool approveMax, uint8 v, bytes32 r, bytes32 s
454     ) external returns (uint amountToken, uint amountETH);
455     function swapExactTokensForTokens(
456         uint amountIn,
457         uint amountOutMin,
458         address[] calldata path,
459         address to,
460         uint deadline
461     ) external returns (uint[] memory amounts);
462     function swapTokensForExactTokens(
463         uint amountOut,
464         uint amountInMax,
465         address[] calldata path,
466         address to,
467         uint deadline
468     ) external returns (uint[] memory amounts);
469     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
470         external
471         payable
472         returns (uint[] memory amounts);
473     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
474         external
475         returns (uint[] memory amounts);
476     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
477         external
478         returns (uint[] memory amounts);
479     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
480         external
481         payable
482         returns (uint[] memory amounts);
483 
484     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
485     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
486     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
487     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
488     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
489 }
490 
491 
492 
493 // pragma solidity >=0.6.2;
494 
495 interface IUniswapV2Router02 is IUniswapV2Router01 {
496     function removeLiquidityETHSupportingFeeOnTransferTokens(
497         address token,
498         uint liquidity,
499         uint amountTokenMin,
500         uint amountETHMin,
501         address to,
502         uint deadline
503     ) external returns (uint amountETH);
504     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
505         address token,
506         uint liquidity,
507         uint amountTokenMin,
508         uint amountETHMin,
509         address to,
510         uint deadline,
511         bool approveMax, uint8 v, bytes32 r, bytes32 s
512     ) external returns (uint amountETH);
513 
514     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
515         uint amountIn,
516         uint amountOutMin,
517         address[] calldata path,
518         address to,
519         uint deadline
520     ) external;
521     function swapExactETHForTokensSupportingFeeOnTransferTokens(
522         uint amountOutMin,
523         address[] calldata path,
524         address to,
525         uint deadline
526     ) external payable;
527     function swapExactTokensForETHSupportingFeeOnTransferTokens(
528         uint amountIn,
529         uint amountOutMin,
530         address[] calldata path,
531         address to,
532         uint deadline
533     ) external;
534 }
535 
536 
537 contract AMMO is Context, IERC20, Ownable {
538     using SafeMath for uint256;
539     using Address for address;
540 
541     mapping (address => uint256) private _rOwned;
542     mapping (address => uint256) private _tOwned;
543     mapping (address => mapping (address => uint256)) private _allowances;
544 
545     mapping (address => bool) private _isExcludedFromFee;
546     mapping (address => bool) private _isExcluded;
547     address[] private _excluded;
548    
549     uint256 private constant MAX = ~uint256(0);
550     uint256 private _tTotal = 4000000000 * (10**18);
551     uint256 private _rTotal = (MAX - (MAX % _tTotal));
552     uint256 private _tFeeTotal;
553 
554     string private _name = "Dogface AMMO token";
555     string private _symbol = "$AMMO";
556     uint8 private _decimals = 18;
557     
558     uint256 public _taxFee = 3;
559     uint256 private _previousTaxFee = _taxFee;
560     
561     uint256 public _liquidityFee = 2;
562     uint256 private _previousLiquidityFee = _liquidityFee;
563 
564     uint256 public _marketingFee = 4;
565     uint256 private _previousMarketingFee = _marketingFee;
566     address payable public marketingWallet = payable(0xe78dAb9780aD0136581ca4A81775d7e5258DA036);
567 
568     uint256 public _burnFee = 1;
569     uint256 private _previousBurnFee = _burnFee;
570     address public deadAddress = 0x000000000000000000000000000000000000dEaD;
571 
572     uint256 public minimumTokensBeforeSwap = 1000000 * 10**18;
573     uint256 public _maxTxAmount = 8000000 * 10**18;
574 
575     IUniswapV2Router02 public  uniswapV2Router;
576     address public  uniswapV2Pair;
577     
578     bool inSwapAndLiquify;
579     bool public swapAndLiquifyEnabled = true;
580     
581     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
582     event SwapAndLiquifyEnabledUpdated(bool enabled);
583     event SwapAndLiquify(
584         uint256 tokensSwapped,
585         uint256 ethReceived,
586         uint256 tokensIntoLiqudity
587     );
588     
589     modifier lockTheSwap {
590         inSwapAndLiquify = true;
591         _;
592         inSwapAndLiquify = false;
593     }
594     
595     constructor() {
596         _rOwned[owner()] = _rTotal;
597         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
598          // Create a uniswap pair for this new token
599         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
600             .createPair(address(this), _uniswapV2Router.WETH());
601 
602         // set the rest of the contract variables
603         uniswapV2Router = _uniswapV2Router;
604         
605         //exclude owner and this contract from fee
606         _isExcludedFromFee[owner()] = true;
607          _isExcludedFromFee[marketingWallet] = true;
608         _isExcludedFromFee[address(this)] = true;
609         
610         emit Transfer(address(0), owner(), _tTotal);
611     }
612 
613     function name() public view returns (string memory) {
614         return _name;
615     }
616 
617     function symbol() public view returns (string memory) {
618         return _symbol;
619     }
620 
621     function decimals() public view returns (uint8) {
622         return _decimals;
623     }
624 
625     function totalSupply() public view override returns (uint256) {
626         return _tTotal;
627     }
628 
629     function balanceOf(address account) public view override returns (uint256) {
630         if (_isExcluded[account]) return _tOwned[account];
631         return tokenFromReflection(_rOwned[account]);
632     }
633 
634     function transfer(address recipient, uint256 amount) public override returns (bool) {
635         _transfer(_msgSender(), recipient, amount);
636         return true;
637     }
638 
639     function allowance(address owner, address spender) public view override returns (uint256) {
640         return _allowances[owner][spender];
641     }
642 
643     function approve(address spender, uint256 amount) public override returns (bool) {
644         _approve(_msgSender(), spender, amount);
645         return true;
646     }
647 
648     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
649         _transfer(sender, recipient, amount);
650         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
651         return true;
652     }
653 
654     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
655         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
656         return true;
657     }
658 
659     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
660         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
661         return true;
662     }
663 
664     function isExcludedFromReward(address account) public view returns (bool) {
665         return _isExcluded[account];
666     }
667 
668     function deliver(uint256 tAmount) public {
669         address sender = _msgSender();
670         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
671         (uint256 rAmount,,,,,) = _getValues(tAmount);
672         _rOwned[sender] = _rOwned[sender].sub(rAmount);
673         _rTotal = _rTotal.sub(rAmount);
674         _tFeeTotal = _tFeeTotal.add(tAmount);
675     }
676 
677     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
678         require(tAmount <= _tTotal, "Amount must be less than supply");
679         if (!deductTransferFee) {
680             (uint256 rAmount,,,,,) = _getValues(tAmount);
681             return rAmount;
682         } else {
683             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
684             return rTransferAmount;
685         }
686     }
687 
688     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
689         require(rAmount <= _rTotal, "Amount must be less than total reflections");
690         uint256 currentRate =  _getRate();
691         return rAmount.div(currentRate);
692     }
693 
694     function excludeFromReward(address account) public onlyOwner() {
695         require(!_isExcluded[account], "Account is already excluded");
696         if(_rOwned[account] > 0) {
697             _tOwned[account] = tokenFromReflection(_rOwned[account]);
698         }
699         _isExcluded[account] = true;
700         _excluded.push(account);
701     }
702 
703     function includeInReward(address account) external onlyOwner() {
704         require(_isExcluded[account], "Account is already excluded");
705         for (uint256 i = 0; i < _excluded.length; i++) {
706             if (_excluded[i] == account) {
707                 _excluded[i] = _excluded[_excluded.length - 1];
708                 _tOwned[account] = 0;
709                 _isExcluded[account] = false;
710                 _excluded.pop();
711                 break;
712             }
713         }
714     }
715 
716     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
717         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
718         _tOwned[sender] = _tOwned[sender].sub(tAmount);
719         _rOwned[sender] = _rOwned[sender].sub(rAmount);
720         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
721         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
722         _takeLiquidity(tLiquidity);
723         _reflectFee(rFee, tFee);
724         emit Transfer(sender, recipient, tTransferAmount);
725     }
726 
727     function _reflectFee(uint256 rFee, uint256 tFee) private {
728         _rTotal = _rTotal.sub(rFee);
729         _tFeeTotal = _tFeeTotal.add(tFee);
730     }
731 
732     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
733         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
734         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
735         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
736     }
737 
738     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
739         uint256 tFee = calculateTaxFee(tAmount);
740         uint256 tLiquidity = calculateLiquidityFee(tAmount);
741         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
742         return (tTransferAmount, tFee, tLiquidity);
743     }
744 
745     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
746         uint256 rAmount = tAmount.mul(currentRate);
747         uint256 rFee = tFee.mul(currentRate);
748         uint256 rLiquidity = tLiquidity.mul(currentRate);
749         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
750         return (rAmount, rTransferAmount, rFee);
751     }
752 
753     function _getRate() private view returns(uint256) {
754         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
755         return rSupply.div(tSupply);
756     }
757 
758     function _getCurrentSupply() private view returns(uint256, uint256) {
759         uint256 rSupply = _rTotal;
760         uint256 tSupply = _tTotal;      
761         for (uint256 i = 0; i < _excluded.length; i++) {
762             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
763             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
764             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
765         }
766         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
767         return (rSupply, tSupply);
768     }
769     
770     function _takeLiquidity(uint256 tLiquidity) private {
771         uint256 currentRate =  _getRate();
772         uint256 rLiquidity = tLiquidity.mul(currentRate);
773         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
774         if(_isExcluded[address(this)])
775             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
776     }
777     
778     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
779         return _amount.mul(_taxFee).div(
780             10**2
781         );
782     }
783 
784     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
785         return _amount.mul(_liquidityFee).div(
786             10**2
787         );
788     }
789     
790     function removeAllFee() private {
791         if(_taxFee == 0 && _liquidityFee == 0 && _marketingFee==0 && _burnFee==0) return;
792         
793         _previousTaxFee = _taxFee;
794         _previousLiquidityFee = _liquidityFee;
795         _previousBurnFee = _burnFee;
796         _previousMarketingFee = _marketingFee;
797         
798         _taxFee = 0;
799         _liquidityFee = 0;
800         _marketingFee = 0;
801         _burnFee = 0;
802     }
803     
804     function restoreAllFee() private {
805        _taxFee = _previousTaxFee;
806        _liquidityFee = _previousLiquidityFee;
807        _burnFee = _previousBurnFee;
808        _marketingFee = _previousMarketingFee;
809     }
810     
811     function isExcludedFromFee(address account) public view returns(bool) {
812         return _isExcludedFromFee[account];
813     }
814 
815     function _approve(address owner, address spender, uint256 amount) private {
816         require(owner != address(0), "ERC20: approve from the zero address");
817         require(spender != address(0), "ERC20: approve to the zero address");
818 
819         _allowances[owner][spender] = amount;
820         emit Approval(owner, spender, amount);
821     }
822 
823     function _transfer(
824         address from,
825         address to,
826         uint256 amount
827     ) private {
828         require(from != address(0), "ERC20: transfer from the zero address");
829         require(amount > 0, "Transfer amount must be greater than zero");
830 
831         // is the token balance of this contract address over the min number of
832         // tokens that we need to initiate a swap + liquidity lock?
833         // also, don't get caught in a circular liquidity event.
834         // also, don't swap & liquify if sender is uniswap pair.
835         uint256 contractTokenBalance = balanceOf(address(this));        
836         bool overMinTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
837         if (
838             overMinTokenBalance &&
839             !inSwapAndLiquify &&
840             to == uniswapV2Pair &&
841             swapAndLiquifyEnabled
842         ) {
843             contractTokenBalance = minimumTokensBeforeSwap;
844             //add liquidity
845             swapAndLiquify(contractTokenBalance);
846         }
847         
848         //transfer amount, it will take tax, burn, liquidity fee
849         _tokenTransfer(from,to,amount);
850     }
851 
852     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
853         // tokens for liquidity
854         uint256 tokensForLiquidity = contractTokenBalance.mul(_liquidityFee).div(_liquidityFee.add(_marketingFee));
855         
856         // split the contract balance into halves
857         uint256 half = tokensForLiquidity.div(2);
858         uint256 otherHalf = tokensForLiquidity.sub(half);
859 
860         // capture the contract's current ETH balance.
861         // this is so that we can capture exactly the amount of ETH that the
862         // swap creates, and not make the liquidity event include any ETH that
863         // has been manually sent to the contract
864         uint256 initialBalance = address(this).balance;
865 
866         // swap tokens for ETH
867         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
868 
869         // how much ETH did we just swap into?
870         uint256 newBalance = address(this).balance.sub(initialBalance);
871 
872         // add liquidity to uniswap
873         addLiquidity(otherHalf, newBalance);
874 
875         //swap for marketing wallet
876         swapTokensForEth(contractTokenBalance.sub(tokensForLiquidity));
877         marketingWallet.transfer(address(this).balance);
878         
879         emit SwapAndLiquify(half, newBalance, otherHalf);
880     }
881 
882     function swapTokensForEth(uint256 tokenAmount) private {
883         // generate the uniswap pair path of token -> weth
884         address[] memory path = new address[](2);
885         path[0] = address(this);
886         path[1] = uniswapV2Router.WETH();
887 
888         _approve(address(this), address(uniswapV2Router), tokenAmount);
889 
890         // make the swap
891         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
892             tokenAmount,
893             0, // accept any amount of ETH
894             path,
895             address(this),
896             block.timestamp
897         );
898     }
899 
900     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
901         // approve token transfer to cover all possible scenarios
902         _approve(address(this), address(uniswapV2Router), tokenAmount);
903 
904         // add the liquidity
905         uniswapV2Router.addLiquidityETH{value: ethAmount}(
906             address(this),
907             tokenAmount,
908             0, // slippage is unavoidable
909             0, // slippage is unavoidable
910             owner(),
911             block.timestamp
912         );
913     }
914 
915     //this method is responsible for taking all fee, if takeFee is true
916     function _tokenTransfer(address sender, address recipient, uint256 amount) private 
917     {
918         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient])
919         {   
920            removeAllFee(); 
921         }
922         else  
923         {
924             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
925         }
926 
927         if (_isExcluded[sender] && !_isExcluded[recipient]) {
928             _transferFromExcluded(sender, recipient, amount);
929         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
930             _transferToExcluded(sender, recipient, amount);
931         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
932             _transferStandard(sender, recipient, amount);
933         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
934             _transferBothExcluded(sender, recipient, amount);
935         } else {
936             _transferStandard(sender, recipient, amount);
937         }
938         
939         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient])
940         {
941             restoreAllFee();
942         }
943     }
944 
945     function _transferStandard(address sender, address recipient, uint256 tAmount) private 
946     {
947         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
948         (tTransferAmount, rTransferAmount) = takeBurn(sender, tTransferAmount, rTransferAmount, tAmount);
949         (tTransferAmount, rTransferAmount) = takeMarketing(sender, tTransferAmount, rTransferAmount, tAmount);
950         _rOwned[sender] = _rOwned[sender].sub(rAmount);
951         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
952         _takeLiquidity(tLiquidity);
953         _reflectFee(rFee, tFee);
954         emit Transfer(sender, recipient, tTransferAmount);
955     }
956 
957     function takeMarketing(address sender, uint256 tTransferAmount, uint256 rTransferAmount, uint256 tAmount) private
958     returns (uint256, uint256)
959     {
960         if(_marketingFee==0) {  return(tTransferAmount, rTransferAmount); }
961         uint256 tMarketing = tAmount.div(100).mul(_marketingFee);
962         uint256 rMarketing = tMarketing.mul(_getRate());
963         rTransferAmount = rTransferAmount.sub(rMarketing);
964         tTransferAmount = tTransferAmount.sub(tMarketing);
965         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
966         emit Transfer(sender, address(this), tMarketing);
967         return(tTransferAmount, rTransferAmount); 
968     }
969 
970     function takeBurn(address sender, uint256 tTransferAmount, uint256 rTransferAmount, uint256 tAmount) private
971     returns (uint256, uint256)
972     {
973         if(_burnFee==0) {  return(tTransferAmount, rTransferAmount); }
974         uint256 tBurn = tAmount.div(100).mul(_burnFee);
975         uint256 rBurn = tBurn.mul(_getRate());
976         rTransferAmount = rTransferAmount.sub(rBurn);
977         tTransferAmount = tTransferAmount.sub(tBurn);
978         _rOwned[deadAddress] = _rOwned[deadAddress].add(rBurn);
979         emit Transfer(sender, deadAddress, tBurn);
980         return(tTransferAmount, rTransferAmount);
981     }
982 
983     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
984         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
985         _tOwned[sender] = _tOwned[sender].sub(tAmount);
986         _rOwned[sender] = _rOwned[sender].sub(rAmount);
987         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
988         _takeLiquidity(tLiquidity);
989         _reflectFee(rFee, tFee);
990         emit Transfer(sender, recipient, tTransferAmount);
991     }
992 
993     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
994         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
995         _rOwned[sender] = _rOwned[sender].sub(rAmount);
996         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
997         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
998         _takeLiquidity(tLiquidity);
999         _reflectFee(rFee, tFee);
1000         emit Transfer(sender, recipient, tTransferAmount);
1001     }
1002 
1003     function includeInFee(address account) public onlyOwner {
1004         _isExcludedFromFee[account] = false;
1005     }
1006 
1007     function excludeFromFee(address account) public onlyOwner {
1008         _isExcludedFromFee[account] = true;
1009     }
1010     
1011     function updateMarketingWallet(address payable newWallet) external onlyOwner() {
1012         marketingWallet = newWallet;
1013     }
1014    
1015     function updateFeePercent(uint256 taxFee, uint256 liquidityFee, uint256 marketingFee, uint256 burnFee) external onlyOwner() {
1016         require(taxFee.add(liquidityFee).add(marketingFee).add(burnFee) <= 10, "tax too high");
1017         _taxFee = taxFee;
1018         _liquidityFee = liquidityFee;
1019         _marketingFee = marketingFee;
1020         _burnFee = burnFee;
1021     }
1022     
1023     function updateMinimumTokensBeforeSwap(uint256 newAmount) external onlyOwner() {
1024         minimumTokensBeforeSwap = newAmount;
1025     }
1026     
1027     function updateMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1028         _maxTxAmount = maxTxAmount;
1029         require(_maxTxAmount > totalSupply().div(200), "value too low");
1030     }
1031     
1032     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1033         swapAndLiquifyEnabled = _enabled;
1034         emit SwapAndLiquifyEnabledUpdated(_enabled);
1035     }
1036 
1037      //to recieve ETH from uniswapV2Router when swaping
1038     receive() external payable {}
1039     
1040 }