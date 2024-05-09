1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 
5 
6 
7 /**
8  * @dev Standard math utilities missing in the Solidity language.
9  */
10 library Math {
11     /**
12      * @dev Returns the largest of two numbers.
13      */
14     function max(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a >= b ? a : b;
16     }
17 
18     /**
19      * @dev Returns the smallest of two numbers.
20      */
21     function min(uint256 a, uint256 b) internal pure returns (uint256) {
22         return a < b ? a : b;
23     }
24 
25     /**
26      * @dev Returns the average of two numbers. The result is rounded towards
27      * zero.
28      */
29     function average(uint256 a, uint256 b) internal pure returns (uint256) {
30         // (a + b) / 2 can overflow.
31         return (a & b) + (a ^ b) / 2;
32     }
33 
34     /**
35      * @dev Returns the ceiling of the division of two numbers.
36      *
37      * This differs from standard division with `/` in that it rounds up instead
38      * of rounding down.
39      */
40     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
41         // (a + b - 1) / b can overflow on addition, so we distribute.
42         return a / b + (a % b == 0 ? 0 : 1);
43     }
44 }
45 
46 interface IUniswapV2Factory {
47     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
48 
49     function feeTo() external view returns (address);
50     function feeToSetter() external view returns (address);
51 
52     function getPair(address tokenA, address tokenB) external view returns (address pair);
53     function allPairs(uint) external view returns (address pair);
54     function allPairsLength() external view returns (uint);
55 
56     function createPair(address tokenA, address tokenB) external returns (address pair);
57 
58     function setFeeTo(address) external;
59     function setFeeToSetter(address) external;
60 }
61 
62 
63 interface IUniswapV2Router01 {
64     function factory() external pure returns (address);
65     function WETH() external pure returns (address);
66 
67     function addLiquidity(
68         address tokenA,
69         address tokenB,
70         uint amountADesired,
71         uint amountBDesired,
72         uint amountAMin,
73         uint amountBMin,
74         address to,
75         uint deadline
76     ) external returns (uint amountA, uint amountB, uint liquidity);
77     function addLiquidityETH(
78         address token,
79         uint amountTokenDesired,
80         uint amountTokenMin,
81         uint amountETHMin,
82         address to,
83         uint deadline
84     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
85     function removeLiquidity(
86         address tokenA,
87         address tokenB,
88         uint liquidity,
89         uint amountAMin,
90         uint amountBMin,
91         address to,
92         uint deadline
93     ) external returns (uint amountA, uint amountB);
94     function removeLiquidityETH(
95         address token,
96         uint liquidity,
97         uint amountTokenMin,
98         uint amountETHMin,
99         address to,
100         uint deadline
101     ) external returns (uint amountToken, uint amountETH);
102     function removeLiquidityWithPermit(
103         address tokenA,
104         address tokenB,
105         uint liquidity,
106         uint amountAMin,
107         uint amountBMin,
108         address to,
109         uint deadline,
110         bool approveMax, uint8 v, bytes32 r, bytes32 s
111     ) external returns (uint amountA, uint amountB);
112     function removeLiquidityETHWithPermit(
113         address token,
114         uint liquidity,
115         uint amountTokenMin,
116         uint amountETHMin,
117         address to,
118         uint deadline,
119         bool approveMax, uint8 v, bytes32 r, bytes32 s
120     ) external returns (uint amountToken, uint amountETH);
121     function swapExactTokensForTokens(
122         uint amountIn,
123         uint amountOutMin,
124         address[] calldata path,
125         address to,
126         uint deadline
127     ) external returns (uint[] memory amounts);
128     function swapTokensForExactTokens(
129         uint amountOut,
130         uint amountInMax,
131         address[] calldata path,
132         address to,
133         uint deadline
134     ) external returns (uint[] memory amounts);
135     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
136         external
137         payable
138         returns (uint[] memory amounts);
139     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
140         external
141         returns (uint[] memory amounts);
142     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
143         external
144         returns (uint[] memory amounts);
145     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
146         external
147         payable
148         returns (uint[] memory amounts);
149 
150     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
151     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
152     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
153     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
154     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
155 }
156 
157 
158 
159 // pragma solidity >=0.6.2;
160 
161 interface IUniswapV2Router02 is IUniswapV2Router01 {
162     function removeLiquidityETHSupportingFeeOnTransferTokens(
163         address token,
164         uint liquidity,
165         uint amountTokenMin,
166         uint amountETHMin,
167         address to,
168         uint deadline
169     ) external returns (uint amountETH);
170     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
171         address token,
172         uint liquidity,
173         uint amountTokenMin,
174         uint amountETHMin,
175         address to,
176         uint deadline,
177         bool approveMax, uint8 v, bytes32 r, bytes32 s
178     ) external returns (uint amountETH);
179 
180     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
181         uint amountIn,
182         uint amountOutMin,
183         address[] calldata path,
184         address to,
185         uint deadline
186     ) external;
187     function swapExactETHForTokensSupportingFeeOnTransferTokens(
188         uint amountOutMin,
189         address[] calldata path,
190         address to,
191         uint deadline
192     ) external payable;
193     function swapExactTokensForETHSupportingFeeOnTransferTokens(
194         uint amountIn,
195         uint amountOutMin,
196         address[] calldata path,
197         address to,
198         uint deadline
199     ) external;
200 }
201 
202 
203 interface RezerveExchange {
204      function exchangeReserve ( uint256 _amount ) external;
205      function flush() external;
206     
207 }
208 
209 
210 
211 
212 
213 interface IERC20 {
214 
215     function totalSupply() external view returns (uint256);
216 
217     /**
218      * @dev Returns the amount of tokens owned by `account`.
219      */
220     function balanceOf(address account) external view returns (uint256);
221 
222     /**
223      * @dev Moves `amount` tokens from the caller's account to `recipient`.
224      *
225      * Returns a boolean value indicating whether the operation succeeded.
226      *
227      * Emits a {Transfer} event.
228      */
229     function transfer(address recipient, uint256 amount) external returns (bool);
230 
231     /**
232      * @dev Returns the remaining number of tokens that `spender` will be
233      * allowed to spend on behalf of `owner` through {transferFrom}. This is
234      * zero by default.
235      *
236      * This value changes when {approve} or {transferFrom} are called.
237      */
238     function allowance(address owner, address spender) external view returns (uint256);
239 
240     /**
241      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
242      *
243      * Returns a boolean value indicating whether the operation succeeded.
244      *
245      * IMPORTANT: Beware that changing an allowance with this method brings the risk
246      * that someone may use both the old and the new allowance by unfortunate
247      * transaction ordering. One possible solution to mitigate this race
248      * condition is to first reduce the spender's allowance to 0 and set the
249      * desired value afterwards:
250      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
251      *
252      * Emits an {Approval} event.
253      */
254     function approve(address spender, uint256 amount) external returns (bool);
255 
256     /**
257      * @dev Moves `amount` tokens from `sender` to `recipient` using the
258      * allowance mechanism. `amount` is then deducted from the caller's
259      * allowance.
260      *
261      * Returns a boolean value indicating whether the operation succeeded.
262      *
263      * Emits a {Transfer} event.
264      */
265     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
266 
267     /**
268      * @dev Emitted when `value` tokens are moved from one account (`from`) to
269      * another (`to`).
270      *
271      * Note that `value` may be zero.
272      */
273     event Transfer(address indexed from, address indexed to, uint256 value);
274 
275     /**
276      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
277      * a call to {approve}. `value` is the new allowance.
278      */
279     event Approval(address indexed owner, address indexed spender, uint256 value);
280 }
281 
282 
283 
284 abstract contract Context {
285     function _msgSender() internal view virtual returns (address payable) {
286         return payable( msg.sender );
287     }
288 
289     function _msgData() internal view virtual returns (bytes memory) {
290         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
291         return msg.data;
292     }
293 }
294 
295 
296 /**
297  * @dev Collection of functions related to the address type
298  */
299 library Address {
300     /**
301      * @dev Returns true if `account` is a contract.
302      *
303      * [IMPORTANT]
304      * ====
305      * It is unsafe to assume that an address for which this function returns
306      * false is an externally-owned account (EOA) and not a contract.
307      *
308      * Among others, `isContract` will return false for the following
309      * types of addresses:
310      *
311      *  - an externally-owned account
312      *  - a contract in construction
313      *  - an address where a contract will be created
314      *  - an address where a contract lived, but was destroyed
315      * ====
316      */
317     function isContract(address account) internal view returns (bool) {
318         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
319         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
320         // for accounts without code, i.e. `keccak256('')`
321         bytes32 codehash;
322         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
323         // solhint-disable-next-line no-inline-assembly
324         assembly { codehash := extcodehash(account) }
325         return (codehash != accountHash && codehash != 0x0);
326     }
327 
328     /**
329      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
330      * `recipient`, forwarding all available gas and reverting on errors.
331      *
332      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
333      * of certain opcodes, possibly making contracts go over the 2300 gas limit
334      * imposed by `transfer`, making them unable to receive funds via
335      * `transfer`. {sendValue} removes this limitation.
336      *
337      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
338      *
339      * IMPORTANT: because control is transferred to `recipient`, care must be
340      * taken to not create reentrancy vulnerabilities. Consider using
341      * {ReentrancyGuard} or the
342      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
343      */
344     function sendValue(address payable recipient, uint256 amount) internal {
345         require(address(this).balance >= amount, "Address: insufficient balance");
346 
347         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
348         (bool success, ) = recipient.call{ value: amount }("");
349         require(success, "Address: unable to send value, recipient may have reverted");
350     }
351 
352     /**
353      * @dev Performs a Solidity function call using a low level `call`. A
354      * plain`call` is an unsafe replacement for a function call: use this
355      * function instead.
356      *
357      * If `target` reverts with a revert reason, it is bubbled up by this
358      * function (like regular Solidity function calls).
359      *
360      * Returns the raw returned data. To convert to the expected return value,
361      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
362      *
363      * Requirements:
364      *
365      * - `target` must be a contract.
366      * - calling `target` with `data` must not revert.
367      *
368      * _Available since v3.1._
369      */
370     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
371       return functionCall(target, data, "Address: low-level call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
376      * `errorMessage` as a fallback revert reason when `target` reverts.
377      *
378      * _Available since v3.1._
379      */
380     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
381         return _functionCallWithValue(target, data, 0, errorMessage);
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
386      * but also transferring `value` wei to `target`.
387      *
388      * Requirements:
389      *
390      * - the calling contract must have an ETH balance of at least `value`.
391      * - the called Solidity function must be `payable`.
392      *
393      * _Available since v3.1._
394      */
395     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
396         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
401      * with `errorMessage` as a fallback revert reason when `target` reverts.
402      *
403      * _Available since v3.1._
404      */
405     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
406         require(address(this).balance >= value, "Address: insufficient balance for call");
407         return _functionCallWithValue(target, data, value, errorMessage);
408     }
409 
410     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
411         require(isContract(target), "Address: call to non-contract");
412 
413         // solhint-disable-next-line avoid-low-level-calls
414         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
415         if (success) {
416             return returndata;
417         } else {
418             // Look for revert reason and bubble it up if present
419             if (returndata.length > 0) {
420                 // The easiest way to bubble the revert reason is using memory via assembly
421 
422                 // solhint-disable-next-line no-inline-assembly
423                 assembly {
424                     let returndata_size := mload(returndata)
425                     revert(add(32, returndata), returndata_size)
426                 }
427             } else {
428                 revert(errorMessage);
429             }
430         }
431     }
432 }
433 
434 /**
435  * @dev Contract module which provides a basic access control mechanism, where
436  * there is an account (an owner) that can be granted exclusive access to
437  * specific functions.
438  *
439  * By default, the owner account will be the one that deploys the contract. This
440  * can later be changed with {transferOwnership}.
441  *
442  * This module is used through inheritance. It will make available the modifier
443  * `onlyOwner`, which can be applied to your functions to restrict their use to
444  * the owner.
445  */
446 contract Ownable is Context {
447     address private _owner;
448     address private _previousOwner;
449     uint256 private _lockTime;
450 
451     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
452 
453     /**
454      * @dev Initializes the contract setting the deployer as the initial owner.
455      */
456     constructor ()  {
457         address msgSender = _msgSender();
458         _owner = msgSender;
459         emit OwnershipTransferred(address(0), msgSender);
460     }
461 
462     /**
463      * @dev Returns the address of the current owner.
464      */
465     function owner() public view returns (address) {
466         return _owner;
467     }
468 
469     /**
470      * @dev Throws if called by any account other than the owner.
471      */
472     modifier onlyOwner() {
473         require(_owner == _msgSender(), "Ownable: caller is not the owner");
474         _;
475     }
476 
477      /**
478      * @dev Leaves the contract without owner. It will not be possible to call
479      * `onlyOwner` functions anymore. Can only be called by the current owner.
480      *
481      * NOTE: Renouncing ownership will leave the contract without an owner,
482      * thereby removing any functionality that is only available to the owner.
483      */
484     function renounceOwnership() public virtual onlyOwner {
485         emit OwnershipTransferred(_owner, address(0));
486         _owner = address(0);
487     }
488 
489     /**
490      * @dev Transfers ownership of the contract to a new account (`newOwner`).
491      * Can only be called by the current owner.
492      */
493     function transferOwnership(address newOwner) public virtual onlyOwner {
494         require(newOwner != address(0), "Ownable: new owner is the zero address");
495         emit OwnershipTransferred(_owner, newOwner);
496         _owner = newOwner;
497     }
498 
499     function geUnlockTime() public view returns (uint256) {
500         return _lockTime;
501     }
502 
503     //Locks the contract for owner for the amount of time provided
504     function lock(uint256 time) public virtual onlyOwner {
505         _previousOwner = _owner;
506         _owner = address(0);
507         _lockTime = block.timestamp + time;
508         emit OwnershipTransferred(_owner, address(0));
509     }
510     
511     //Unlocks the contract for owner when _lockTime is exceeds
512     function unlock() public virtual {
513         require(_previousOwner == msg.sender, "You don't have permission to unlock");
514         require( block.timestamp > _lockTime , "Contract is locked until 7 days");
515         emit OwnershipTransferred(_owner, _previousOwner);
516         _owner = _previousOwner;
517         _previousOwner = address(0);
518     }
519 }
520 
521 
522 
523 contract Rezerve is Context, IERC20, Ownable {
524 	using Address for address;
525 
526 	mapping (address => mapping (address => uint256)) private _allowances;
527 	mapping (address => uint256) private balances;
528 	mapping (address => bool) private _isExcludedFromFee;
529 
530 	uint256 private _totalSupply = 21000000 * 10**9;
531 	uint256 private _tFeeTotal;
532 
533 	string private constant _name = "Rezerve";
534 	string private constant _symbol = "RZRV";
535 	uint8 private constant _decimals = 9;
536 
537 	uint256 public _taxFeeOnSale = 0;
538 	uint256 private _previousSellFee = _taxFeeOnSale;
539 
540 	uint256 public _taxFeeOnBuy = 10;
541 	uint256 private _previousBuyFee = _taxFeeOnBuy;
542 
543     uint256 public _burnFee = 2;
544 	uint256 private _previousBurnFee = _burnFee;
545 	
546 	uint256 public stakingSlice = 20;
547 
548 
549 	bool public saleTax = true;
550 
551 	mapping (address => uint256) public lastTrade;
552 	mapping (address => uint256) public lastBlock;
553 	mapping (address => bool)    public blacklist;
554 	mapping (address => bool)    public whitelist;
555 	mapping (address => bool)    public rezerveEcosystem;
556 	address public reserveStaking;
557 	address payable public reserveVault;
558 	address public reserveExchange;
559 	address public ReserveStakingReceiver;
560 	address public DAI;
561 
562 	IUniswapV2Router02 public immutable uniswapV2Router;
563 	address public uniswapV2RouterAddress;
564 	address public immutable uniswapV2Pair;
565 
566 	uint8 public action;
567 	bool public daiShield;
568 	bool public AutoSwap = false;
569 
570 	uint8 public lpPullPercentage = 70;
571 	bool public pauseContract = true;
572 	bool public stakingTax = true;
573 
574 	address public burnAddress = 0x000000000000000000000000000000000000dEaD;  
575 
576 	bool inSwapAndLiquify;
577 	bool public swapAndLiquifyEnabled = true;
578 
579 	uint256 public _maxTxAmount = 21000000  * 10**9;
580 	uint256 public numTokensSellToAddToLiquidity = 21000 * 10**9;
581 
582 	event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
583 	event SwapAndLiquifyEnabledUpdated(bool enabled);
584 	event SwapAndLiquify(
585 		uint256 tokensSwapped,
586 		uint256 ethReceived,
587 		uint256 tokensIntoLiqudity
588 	);
589 
590 	// ========== Modifiers ========== //
591 	modifier lockTheSwap {
592 		inSwapAndLiquify = true;
593 		_;
594 		inSwapAndLiquify = false;
595 	}
596 
597 	constructor () {
598 		//DAI = 0x9A702Da2aCeA529dE15f75b69d69e0E94bEFB73B;
599 		// DAI = 0x6980FF5a3BF5E429F520746EFA697525e8EaFB5C; // @audit - make sure this address is correct
600 		//uniswapV2RouterAddress = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
601                 balances[msg.sender] = _totalSupply;
602 		DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F; // testnet DAI
603 		uniswapV2RouterAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // @audit - make sure this address is correct
604 		IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(uniswapV2RouterAddress);
605 		 // Create a uniswap pair for this new token
606 		address pairAddress = IUniswapV2Factory(_uniswapV2Router.factory())
607 			.createPair(address(this), DAI );
608 		uniswapV2Pair = pairAddress;
609 		// UNCOMMENT THESE FOR ETHEREUM MAINNET
610 		//DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
611 
612 		// set the rest of the contract variables
613 		uniswapV2Router = _uniswapV2Router;
614 
615 		addRezerveEcosystemAddress(owner());
616 		addRezerveEcosystemAddress(address(this));
617 
618 		addToWhitelist(pairAddress);
619 
620 		//exclude owner and this contract from fee
621 		_isExcludedFromFee[owner()] = true;
622 		_isExcludedFromFee[address(this)] = true;
623 		_isExcludedFromFee[0x397c2dBe7af135eA95561acdd9E558E630410a84] = true; // @audit - make sure this address is correct
624 		daiShield = true;
625 		emit Transfer(address(0), _msgSender(), _totalSupply);
626 	}
627 
628 	// ========== View Functions ========== //
629 
630 	function thresholdMet () public view returns (bool) {
631 		return reserveBalance() > numTokensSellToAddToLiquidity ;
632 	}
633 	
634 	function reserveBalance () public view returns (uint256) {
635 		return balanceOf( address(this) );
636 	}
637 
638 	function name() public pure returns (string memory) {
639 		return _name;
640 	}
641 
642 	function symbol() public pure returns (string memory) {
643 		return _symbol;
644 	}
645 
646 	function decimals() public pure returns (uint8) {
647 		return _decimals;
648 	}
649 
650 	function totalSupply() public view override returns (uint256) {
651 		return _totalSupply;
652 	}
653 
654 	function balanceOf(address account) public view override returns (uint256) {
655 		return balances[account];
656 	}
657 
658 	function allowance(address owner, address spender) public view override returns (uint256) {
659 		return _allowances[owner][spender];
660 	}
661 
662 	function totalFees() public view returns (uint256) {
663 		return _tFeeTotal;
664 	}
665 
666 	function getLPBalance() public view returns(uint256){
667 		IERC20 _lp = IERC20 ( uniswapV2Pair);
668 		return _lp.balanceOf(address(this));
669 	}
670 
671 	function isExcludedFromFee(address account) public view returns(bool) {
672 		return _isExcludedFromFee[account];
673 	}
674 
675 	function checkDaiOwnership( address _address ) public view returns(bool){
676 		IERC20 _dai = IERC20(DAI);
677 		uint256 _daibalance = _dai.balanceOf(_address );
678 		return ( _daibalance > 0 );
679 	}
680 
681 	// ========== Mutative / Owner Functions ========== //
682 
683 	function transfer(address recipient, uint256 amount) public override returns (bool) {
684 		_transfer(_msgSender(), recipient, amount);
685 		return true;
686 	}
687 
688 	function approve(address spender, uint256 amount) public override returns (bool) {
689 		_approve(_msgSender(), spender, amount);
690 		return true;
691 	}
692 
693 	function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
694 		_approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount );
695 		_transfer(sender, recipient, amount);
696 		return true;
697 	}
698 
699 	//to receive ETH from uniswapV2Router when swaping
700 	receive() external payable {}
701 
702 	function setReserveExchange( address _address ) public onlyOwner {
703 		require(_address != address(0), "reserveExchange is zero address");
704 		reserveExchange = _address;
705 		excludeFromFee( _address );
706 		addRezerveEcosystemAddress(_address);
707 	}
708 
709 	function contractPauser() public onlyOwner {
710 		pauseContract = !pauseContract;
711 		AutoSwap = !AutoSwap;
712 		_approve(address(this), reserveExchange, ~uint256(0));
713 		_approve(address(this), uniswapV2Pair ,  ~uint256(0));
714 		_approve(address(this), uniswapV2RouterAddress, ~uint256(0));
715 		 
716 		IERC20 _dai = IERC20 ( DAI );
717 		_dai.approve( uniswapV2Pair, ~uint256(0) );
718 		_dai.approve( uniswapV2RouterAddress ,  ~uint256(0) );
719 		_dai.approve( reserveExchange ,  ~uint256(0) );
720 	}
721 
722 	function excludeFromFee(address account) public onlyOwner {
723 		_isExcludedFromFee[account] = true;
724 	}
725 
726 	function includeInFee(address account) public onlyOwner {
727 		_isExcludedFromFee[account] = false;
728 	}
729 
730 	function setSellFeePercent(uint256 sellFee) external onlyOwner() {
731 		require ( sellFee < 30 , "Tax too high" );
732 		_taxFeeOnSale = sellFee;
733 	}
734 
735 	function setBuyFeePercent(uint256 buyFee) external onlyOwner() {
736 		require ( buyFee < 11 , "Tax too high" );
737 		_taxFeeOnBuy = buyFee;
738 	}
739 	
740 	function setBurnFeePercent(uint256 burnFee) external onlyOwner() {
741 		require ( burnFee < 11 , "Burn too high" );
742 		_burnFee = burnFee;
743 	}
744 
745 	function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
746 		_maxTxAmount = (_totalSupply * maxTxPercent) / 10**6;
747 	}
748 
749 	function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
750 		swapAndLiquifyEnabled = _enabled;
751 		emit SwapAndLiquifyEnabledUpdated(_enabled);
752 	}
753 
754 	function setReserveStakingReceiver(address _address) public onlyOwner {
755 		require(_address != address(0), "ReserveStakingReceiver is zero address");
756 		ReserveStakingReceiver = _address;
757 		excludeFromFee( _address );
758 		addRezerveEcosystemAddress(_address);
759 	}
760 	
761 	function setReserveStaking ( address _address ) public onlyOwner {
762 		require(_address != address(0), "ReserveStaking is zero address");
763 		reserveStaking = _address;
764 		excludeFromFee( _address );
765 		addRezerveEcosystemAddress(_address);
766 	}
767 
768 	function setMinimumNumber (uint256 _min) public onlyOwner {
769 		numTokensSellToAddToLiquidity = _min * 10** 9;
770 	}
771 
772 	function daiShieldToggle () public onlyOwner {
773 		daiShield = !daiShield;
774 	}
775 	
776 	function AutoSwapToggle () public onlyOwner {
777 		AutoSwap = !AutoSwap;
778 	}
779 
780 	function addToBlacklist(address account) public onlyOwner {
781 		whitelist[account] = false;
782 		blacklist[account] = true;
783 	}
784 
785 	function removeFromBlacklist(address account) public onlyOwner {
786 		blacklist[account] = false;
787 	}
788 	
789 	// To be used for contracts that should never be blacklisted, but aren't part of the Rezerve ecosystem, such as the Uniswap pair
790 	function addToWhitelist(address account) public onlyOwner {
791 		blacklist[account] = false;
792 		whitelist[account] = true;
793 	}
794 
795 	function removeFromWhitelist(address account) public onlyOwner {
796 		whitelist[account] = false;
797 	}
798 
799 	// To be used if new contracts are added to the Rezerve ecosystem
800 	function addRezerveEcosystemAddress(address account) public onlyOwner {
801 		rezerveEcosystem[account] = true;
802 		addToWhitelist(account);
803 	}
804 
805 	function removeRezerveEcosystemAddress(address account) public onlyOwner {
806 		rezerveEcosystem[account] = false;
807 	}
808 
809 	function toggleStakingTax() public onlyOwner {
810 		stakingTax = !stakingTax;
811 	}
812 
813 	function withdrawLPTokens () public onlyOwner {
814 		IERC20 _uniswapV2Pair = IERC20 ( uniswapV2Pair );
815 		uint256 _lpbalance = _uniswapV2Pair.balanceOf(address(this));
816 		_uniswapV2Pair.transfer( msg.sender, _lpbalance );
817 	}
818 	
819 	function setLPPullPercentage ( uint8 _perc ) public onlyOwner {
820 		require ( _perc >9 && _perc <71);
821 		lpPullPercentage = _perc;
822 	}
823 
824 	function addToLP(uint256 tokenAmount, uint256 daiAmount) public onlyOwner {
825 		// approve token transfer to cover all possible scenarios
826 		_transfer ( msg.sender, address(this) , tokenAmount );
827 		_approve(address(this), address(uniswapV2Router), tokenAmount);
828 		
829 		IERC20 _dai = IERC20 ( DAI );
830 		_dai.approve(  address(uniswapV2Router), daiAmount);
831 		_dai.transferFrom ( msg.sender, address(this) , daiAmount );
832 		
833 		// add the liquidity
834 		uniswapV2Router.addLiquidity(
835 			address(this),
836 			DAI,
837 			tokenAmount,
838 			daiAmount,
839 			0, // slippage is unavoidable
840 			0, // slippage is unavoidable
841 			address(this),
842 			block.timestamp
843 		);
844 		contractPauser();
845 	}
846 
847 	function removeLP () public onlyOwner {
848 		saleTax = false;  
849 		IERC20 _uniswapV2Pair = IERC20 ( uniswapV2Pair );
850 		uint256 _lpbalance = _uniswapV2Pair.balanceOf(address(this));
851 		uint256 _perc = (_lpbalance * lpPullPercentage ) / 100;
852 		
853 		_uniswapV2Pair.approve( address(uniswapV2Router), _perc );
854 		uniswapV2Router.removeLiquidity(
855 			address(this),
856 			DAI,
857 			_perc,
858 			0,
859 			0,
860 			reserveExchange,
861 			block.timestamp + 3 minutes
862 		); 
863 		RezerveExchange _reserveexchange = RezerveExchange ( reserveExchange );
864 		_reserveexchange.flush();
865 	}
866 
867 	function _approve(address owner, address spender, uint256 amount) private {
868 		require(owner != address(0), "ERC20: approve from the zero address");
869 		require(spender != address(0), "ERC20: approve to the zero address");
870 
871 		_allowances[owner][spender] = amount;
872 		emit Approval(owner, spender, amount);
873 	}
874 
875 	// ========== Private / Internal Functions ========== //
876 
877 	function _transfer(
878 		address from,
879 		address to,
880 		uint256 amount
881 	) private {
882 		require(from != address(0), "ERC20: transfer from the zero address");
883 		require(to != address(0), "ERC20: transfer to the zero address");
884 		require(amount > 0, "Transfer amount must be greater than zero");
885 		require(!blacklist[from]);
886 		if (pauseContract) require (from == address(this) || from == owner());
887 
888 		if (!rezerveEcosystem[from]) {
889 			if(to == uniswapV2Pair && daiShield) require ( !checkDaiOwnership(from) );
890 			if(from == uniswapV2Pair) saleTax = false;
891 			if(to != owner())
892 				require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
893 
894 			if (!whitelist[from]) {
895 				if (lastBlock[from] == block.number) blacklist[from] = true;
896 				if (lastTrade[from] + 20 seconds > block.timestamp && !blacklist[from]) revert("Slowdown");
897 				lastBlock[from] = block.number;
898 				lastTrade[from] = block.timestamp;
899 			}
900 		}
901 
902 		action = 0;
903 
904 		if(from == uniswapV2Pair) action = 1;
905 		if(to == uniswapV2Pair) action = 2;
906 		// is the token balance of this contract address over the min number of
907 		// tokens that we need to initiate a swap + liquidity lock?
908 		// also, don't get caught in a circular liquidity event.
909 		// also, don't swap & liquify if sender is uniswap pair.
910 		
911 		uint256 contractTokenBalance = balanceOf(address(this));
912 		contractTokenBalance = Math.min(contractTokenBalance, numTokensSellToAddToLiquidity);
913 		bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
914 		if (
915 			overMinTokenBalance &&
916 			!inSwapAndLiquify &&
917 			from != uniswapV2Pair &&
918 			swapAndLiquifyEnabled &&
919 			AutoSwap
920 		) {
921 			swapIt(contractTokenBalance);
922 		}
923 		
924 		//indicates if fee should be deducted from transfer
925 		bool takeFee = true;
926 		
927 		//if any account belongs to _isExcludedFromFee account then remove the fee
928 		if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
929 			takeFee = false;
930 		}
931 		
932 		//transfer amount, it will take tax, burn, liquidity fee
933 		if (!blacklist[from])
934 			_tokenTransfer(from, to, amount, takeFee);
935 		else
936 			_tokenTransfer(from, to, 1, false);
937 	}
938 
939 	function swapIt(uint256 contractTokenBalance) internal lockTheSwap {
940 		uint256 _exchangeshare = contractTokenBalance;
941 		if (stakingTax) {
942 			_exchangeshare = ( _exchangeshare * 4 ) / 5;
943 			uint256 _stakingshare = contractTokenBalance - _exchangeshare;
944 			_tokenTransfer(address(this), ReserveStakingReceiver, _stakingshare, false);
945 		}
946 		swapTokensForDai(_exchangeshare);
947 	}
948 
949 	function swapTokensForDai(uint256 tokenAmount) internal {
950 		// generate the uniswap pair path of token -> DAI
951 		address[] memory path = new address[](2);
952 
953 		path[0] = address(this);
954 		path[1] = DAI;
955 		uniswapV2Router.swapExactTokensForTokens(
956 			tokenAmount,
957 			0, // accept any amount of DAI
958 			path,
959 			reserveExchange,
960 			block.timestamp + 3 minutes
961 		);
962 	}
963 	
964 	function setStakingSlice ( uint256 _slice ) public onlyOwner {
965 	    stakingSlice = _slice;
966 	}
967 	
968 	//this method is responsible for taking all fee, if takeFee is true
969 	function _tokenTransfer(
970 		address sender,
971 		address recipient,
972 		uint256 amount,
973 		bool takeFee
974 	) private {
975 		if(!takeFee)
976 			removeAllFee();
977 
978 		( uint256 transferAmount, uint256 sellFee, uint256 buyFee, uint256 burnFee ) = _getTxValues(amount);
979 		_tFeeTotal = _tFeeTotal + sellFee + buyFee + burnFee;
980 		uint256 stakingFee;
981 		if (stakingTax) {
982 		        uint256 stakingFeeB = (buyFee * stakingSlice )/100; 
983 		        uint256 stakingFeeS = (sellFee * stakingSlice )/100;
984 		        buyFee = buyFee - stakingFeeB; 
985 		        sellFee = sellFee - stakingFeeS;
986 		        stakingFee = stakingFeeB + stakingFeeS;
987 		
988 		}
989 		balances[sender] = balances[sender] - amount;
990 		balances[recipient] = balances[recipient] + transferAmount;
991 		balances[address(this)] = balances[address(this)] + sellFee + buyFee;
992 		balances[burnAddress] = balances[burnAddress] + burnFee;
993 		balances[ReserveStakingReceiver] = balances[ReserveStakingReceiver] + stakingFee;
994 
995 		emit Transfer(sender, recipient, transferAmount);
996 		
997 		if(!takeFee)
998 			restoreAllFee();
999 	}
1000 
1001 	function _getTxValues(uint256 tAmount) private returns (uint256, uint256, uint256, uint256) {
1002 		uint256 sellFee = calculateSellFee(tAmount);
1003 		uint256 buyFee = calculateBuyFee(tAmount);
1004 		uint256 burnFee = calculateBurnFee(tAmount);
1005 		uint256 tTransferAmount = tAmount - sellFee - buyFee - burnFee;
1006 		return (tTransferAmount, sellFee, buyFee, burnFee);
1007 	}
1008 
1009 	function calculateSellFee(uint256 _amount) private returns (uint256) {
1010 		if (!saleTax) {
1011 			saleTax = true;
1012 			return 0;
1013 		}
1014 		return( _amount * _taxFeeOnSale) / 10**2;
1015 	}
1016 
1017 	function calculateBuyFee(uint256 _amount) private view returns (uint256) {
1018 		if(action == 1)
1019 			return (_amount * _taxFeeOnBuy) / 10**2;
1020 
1021 		return 0;
1022 	}
1023 	
1024 	function calculateBurnFee(uint256 _amount) private view returns (uint256) {
1025 		if ( _burnFee > 0 )
1026 		return (_amount * _burnFee) / 10**2;
1027         return 0;
1028 		
1029 	}
1030 
1031 	function removeAllFee() private {
1032 		if(_taxFeeOnSale == 0 && _taxFeeOnBuy == 0  && _burnFee == 0 ) return;
1033 		
1034 		_previousSellFee = _taxFeeOnSale;
1035 		_previousBuyFee = _taxFeeOnBuy;
1036 		_previousBurnFee = _burnFee;
1037 		
1038 		_taxFeeOnSale = 0;
1039 		_taxFeeOnBuy = 0;
1040 		_burnFee = 0;
1041 	}
1042 
1043 	function restoreAllFee() private {
1044 		_taxFeeOnSale = _previousSellFee;
1045 		_taxFeeOnBuy = _previousBuyFee;
1046 		_burnFee = _previousBurnFee;
1047 	}
1048 }