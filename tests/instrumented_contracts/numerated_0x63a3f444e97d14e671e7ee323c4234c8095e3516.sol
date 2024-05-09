1 // SPDX-License-Identifier: agpl-3.0
2 pragma solidity 0.6.12;
3 pragma experimental ABIEncoderV2;
4 
5 
6 interface IBaseUniswapAdapter {
7   event Swapped(address fromAsset, address toAsset, uint256 fromAmount, uint256 receivedAmount);
8 
9   struct PermitSignature {
10     uint256 amount;
11     uint256 deadline;
12     uint8 v;
13     bytes32 r;
14     bytes32 s;
15   }
16 
17   struct AmountCalc {
18     uint256 calculatedAmount;
19     uint256 relativePrice;
20     uint256 amountInUsd;
21     uint256 amountOutUsd;
22     address[] path;
23   }
24 
25   function WETH_ADDRESS() external returns (address);
26 
27   function MAX_SLIPPAGE_PERCENT() external returns (uint256);
28 
29   function FLASHLOAN_PREMIUM_TOTAL() external returns (uint256);
30 
31   function USD_ADDRESS() external returns (address);
32 
33   function ORACLE() external returns (IPriceOracleGetter);
34 
35   function UNISWAP_ROUTER() external returns (IUniswapV2Router02);
36 
37   /**
38    * @dev Given an input asset amount, returns the maximum output amount of the other asset and the prices
39    * @param amountIn Amount of reserveIn
40    * @param reserveIn Address of the asset to be swap from
41    * @param reserveOut Address of the asset to be swap to
42    * @return uint256 Amount out of the reserveOut
43    * @return uint256 The price of out amount denominated in the reserveIn currency (18 decimals)
44    * @return uint256 In amount of reserveIn value denominated in USD (8 decimals)
45    * @return uint256 Out amount of reserveOut value denominated in USD (8 decimals)
46    * @return address[] The exchange path
47    */
48   function getAmountsOut(
49     uint256 amountIn,
50     address reserveIn,
51     address reserveOut
52   )
53     external
54     view
55     returns (
56       uint256,
57       uint256,
58       uint256,
59       uint256,
60       address[] memory
61     );
62 
63   /**
64    * @dev Returns the minimum input asset amount required to buy the given output asset amount and the prices
65    * @param amountOut Amount of reserveOut
66    * @param reserveIn Address of the asset to be swap from
67    * @param reserveOut Address of the asset to be swap to
68    * @return uint256 Amount in of the reserveIn
69    * @return uint256 The price of in amount denominated in the reserveOut currency (18 decimals)
70    * @return uint256 In amount of reserveIn value denominated in USD (8 decimals)
71    * @return uint256 Out amount of reserveOut value denominated in USD (8 decimals)
72    * @return address[] The exchange path
73    */
74   function getAmountsIn(
75     uint256 amountOut,
76     address reserveIn,
77     address reserveOut
78   )
79     external
80     view
81     returns (
82       uint256,
83       uint256,
84       uint256,
85       uint256,
86       address[] memory
87     );
88 }
89 
90 
91 
92 /**
93  * @title IFlashLoanReceiver interface
94  * @notice Interface for the Aave fee IFlashLoanReceiver.
95  * @author Aave
96  * @dev implement this interface to develop a flashloan-compatible flashLoanReceiver contract
97  **/
98 interface IFlashLoanReceiver {
99   function executeOperation(
100     address[] calldata assets,
101     uint256[] calldata amounts,
102     uint256[] calldata premiums,
103     address initiator,
104     bytes calldata params
105   ) external returns (bool);
106 
107   function ADDRESSES_PROVIDER() external view returns (ILendingPoolAddressesProvider);
108 
109   function LENDING_POOL() external view returns (ILendingPool);
110 }
111 
112 abstract contract FlashLoanReceiverBase is IFlashLoanReceiver {
113   using SafeERC20 for IERC20;
114   using SafeMath for uint256;
115 
116   ILendingPoolAddressesProvider public immutable override ADDRESSES_PROVIDER;
117   ILendingPool public immutable override LENDING_POOL;
118 
119   constructor(ILendingPoolAddressesProvider provider) public {
120     ADDRESSES_PROVIDER = provider;
121     LENDING_POOL = ILendingPool(provider.getLendingPool());
122   }
123 }
124 
125 
126 interface IPriceOracleGetter {
127   /**
128    * @dev returns the asset price in ETH
129    * @param asset the address of the asset
130    * @return the ETH price of the asset
131    **/
132   function getAssetPrice(address asset) external view returns (uint256);
133 }
134 
135 interface IUniswapV2Router02 {
136   function swapExactTokensForTokens(
137     uint256 amountIn,
138     uint256 amountOutMin,
139     address[] calldata path,
140     address to,
141     uint256 deadline
142   ) external returns (uint256[] memory amounts);
143 
144   function swapTokensForExactTokens(
145     uint amountOut,
146     uint amountInMax,
147     address[] calldata path,
148     address to,
149     uint deadline
150   ) external returns (uint256[] memory amounts);
151 
152   function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
153 
154   function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
155 }
156 
157 library DataTypes {
158   // refer to the whitepaper, section 1.1 basic concepts for a formal description of these properties.
159   struct ReserveData {
160     //stores the reserve configuration
161     ReserveConfigurationMap configuration;
162     //the liquidity index. Expressed in ray
163     uint128 liquidityIndex;
164     //variable borrow index. Expressed in ray
165     uint128 variableBorrowIndex;
166     //the current supply rate. Expressed in ray
167     uint128 currentLiquidityRate;
168     //the current variable borrow rate. Expressed in ray
169     uint128 currentVariableBorrowRate;
170     //the current stable borrow rate. Expressed in ray
171     uint128 currentStableBorrowRate;
172     uint40 lastUpdateTimestamp;
173     //tokens addresses
174     address aTokenAddress;
175     address stableDebtTokenAddress;
176     address variableDebtTokenAddress;
177     //address of the interest rate strategy
178     address interestRateStrategyAddress;
179     //the id of the reserve. Represents the position in the list of the active reserves
180     uint8 id;
181   }
182 
183   struct ReserveConfigurationMap {
184     //bit 0-15: LTV
185     //bit 16-31: Liq. threshold
186     //bit 32-47: Liq. bonus
187     //bit 48-55: Decimals
188     //bit 56: Reserve is active
189     //bit 57: reserve is frozen
190     //bit 58: borrowing is enabled
191     //bit 59: stable rate borrowing enabled
192     //bit 60-63: reserved
193     //bit 64-79: reserve factor
194     uint256 data;
195   }
196 
197   struct UserConfigurationMap {
198     uint256 data;
199   }
200 
201   enum InterestRateMode {NONE, STABLE, VARIABLE}
202 }
203 
204 
205 /**
206  * @title LendingPoolAddressesProvider contract
207  * @dev Main registry of addresses part of or connected to the protocol, including permissioned roles
208  * - Acting also as factory of proxies and admin of those, so with right to change its implementations
209  * - Owned by the Aave Governance
210  * @author Aave
211  **/
212 interface ILendingPoolAddressesProvider {
213   event MarketIdSet(string newMarketId);
214   event LendingPoolUpdated(address indexed newAddress);
215   event ConfigurationAdminUpdated(address indexed newAddress);
216   event EmergencyAdminUpdated(address indexed newAddress);
217   event LendingPoolConfiguratorUpdated(address indexed newAddress);
218   event LendingPoolCollateralManagerUpdated(address indexed newAddress);
219   event PriceOracleUpdated(address indexed newAddress);
220   event LendingRateOracleUpdated(address indexed newAddress);
221   event ProxyCreated(bytes32 id, address indexed newAddress);
222   event AddressSet(bytes32 id, address indexed newAddress, bool hasProxy);
223 
224   function getMarketId() external view returns (string memory);
225 
226   function setMarketId(string calldata marketId) external;
227 
228   function setAddress(bytes32 id, address newAddress) external;
229 
230   function setAddressAsProxy(bytes32 id, address impl) external;
231 
232   function getAddress(bytes32 id) external view returns (address);
233 
234   function getLendingPool() external view returns (address);
235 
236   function setLendingPoolImpl(address pool) external;
237 
238   function getLendingPoolConfigurator() external view returns (address);
239 
240   function setLendingPoolConfiguratorImpl(address configurator) external;
241 
242   function getLendingPoolCollateralManager() external view returns (address);
243 
244   function setLendingPoolCollateralManager(address manager) external;
245 
246   function getPoolAdmin() external view returns (address);
247 
248   function setPoolAdmin(address admin) external;
249 
250   function getEmergencyAdmin() external view returns (address);
251 
252   function setEmergencyAdmin(address admin) external;
253 
254   function getPriceOracle() external view returns (address);
255 
256   function setPriceOracle(address priceOracle) external;
257 
258   function getLendingRateOracle() external view returns (address);
259 
260   function setLendingRateOracle(address lendingRateOracle) external;
261 }
262 
263 /*
264  * @dev Provides information about the current execution context, including the
265  * sender of the transaction and its data. While these are generally available
266  * via msg.sender and msg.data, they should not be accessed in such a direct
267  * manner, since when dealing with GSN meta-transactions the account sending and
268  * paying for execution may not be the actual sender (as far as an application
269  * is concerned).
270  *
271  * This contract is only required for intermediate, library-like contracts.
272  */
273 abstract contract Context {
274   function _msgSender() internal virtual view returns (address payable) {
275     return msg.sender;
276   }
277 
278   function _msgData() internal virtual view returns (bytes memory) {
279     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
280     return msg.data;
281   }
282 }
283 
284 
285 /**
286  * @dev Contract module which provides a basic access control mechanism, where
287  * there is an account (an owner) that can be granted exclusive access to
288  * specific functions.
289  *
290  * By default, the owner account will be the one that deploys the contract. This
291  * can later be changed with {transferOwnership}.
292  *
293  * This module is used through inheritance. It will make available the modifier
294  * `onlyOwner`, which can be applied to your functions to restrict their use to
295  * the owner.
296  */
297 contract Ownable is Context {
298   address private _owner;
299 
300   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
301 
302   /**
303    * @dev Initializes the contract setting the deployer as the initial owner.
304    */
305   constructor() internal {
306     address msgSender = _msgSender();
307     _owner = msgSender;
308     emit OwnershipTransferred(address(0), msgSender);
309   }
310 
311   /**
312    * @dev Returns the address of the current owner.
313    */
314   function owner() public view returns (address) {
315     return _owner;
316   }
317 
318   /**
319    * @dev Throws if called by any account other than the owner.
320    */
321   modifier onlyOwner() {
322     require(_owner == _msgSender(), 'Ownable: caller is not the owner');
323     _;
324   }
325 
326   /**
327    * @dev Leaves the contract without owner. It will not be possible to call
328    * `onlyOwner` functions anymore. Can only be called by the current owner.
329    *
330    * NOTE: Renouncing ownership will leave the contract without an owner,
331    * thereby removing any functionality that is only available to the owner.
332    */
333   function renounceOwnership() public virtual onlyOwner {
334     emit OwnershipTransferred(_owner, address(0));
335     _owner = address(0);
336   }
337 
338   /**
339    * @dev Transfers ownership of the contract to a new account (`newOwner`).
340    * Can only be called by the current owner.
341    */
342   function transferOwnership(address newOwner) public virtual onlyOwner {
343     require(newOwner != address(0), 'Ownable: new owner is the zero address');
344     emit OwnershipTransferred(_owner, newOwner);
345     _owner = newOwner;
346   }
347 }
348 
349 /**
350  * @dev Collection of functions related to the address type
351  */
352 library Address {
353   /**
354    * @dev Returns true if `account` is a contract.
355    *
356    * [IMPORTANT]
357    * ====
358    * It is unsafe to assume that an address for which this function returns
359    * false is an externally-owned account (EOA) and not a contract.
360    *
361    * Among others, `isContract` will return false for the following
362    * types of addresses:
363    *
364    *  - an externally-owned account
365    *  - a contract in construction
366    *  - an address where a contract will be created
367    *  - an address where a contract lived, but was destroyed
368    * ====
369    */
370   function isContract(address account) internal view returns (bool) {
371     // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
372     // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
373     // for accounts without code, i.e. `keccak256('')`
374     bytes32 codehash;
375     bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
376     // solhint-disable-next-line no-inline-assembly
377     assembly {
378       codehash := extcodehash(account)
379     }
380     return (codehash != accountHash && codehash != 0x0);
381   }
382 
383   /**
384    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
385    * `recipient`, forwarding all available gas and reverting on errors.
386    *
387    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
388    * of certain opcodes, possibly making contracts go over the 2300 gas limit
389    * imposed by `transfer`, making them unable to receive funds via
390    * `transfer`. {sendValue} removes this limitation.
391    *
392    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
393    *
394    * IMPORTANT: because control is transferred to `recipient`, care must be
395    * taken to not create reentrancy vulnerabilities. Consider using
396    * {ReentrancyGuard} or the
397    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
398    */
399   function sendValue(address payable recipient, uint256 amount) internal {
400     require(address(this).balance >= amount, 'Address: insufficient balance');
401 
402     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
403     (bool success, ) = recipient.call{value: amount}('');
404     require(success, 'Address: unable to send value, recipient may have reverted');
405   }
406 }
407 
408 
409 
410 /**
411  * @title SafeERC20
412  * @dev Wrappers around ERC20 operations that throw on failure (when the token
413  * contract returns false). Tokens that return no value (and instead revert or
414  * throw on failure) are also supported, non-reverting calls are assumed to be
415  * successful.
416  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
417  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
418  */
419 library SafeERC20 {
420   using SafeMath for uint256;
421   using Address for address;
422 
423   function safeTransfer(
424     IERC20 token,
425     address to,
426     uint256 value
427   ) internal {
428     callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
429   }
430 
431   function safeTransferFrom(
432     IERC20 token,
433     address from,
434     address to,
435     uint256 value
436   ) internal {
437     callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
438   }
439 
440   function safeApprove(
441     IERC20 token,
442     address spender,
443     uint256 value
444   ) internal {
445     require(
446       (value == 0) || (token.allowance(address(this), spender) == 0),
447       'SafeERC20: approve from non-zero to non-zero allowance'
448     );
449     callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
450   }
451 
452   function callOptionalReturn(IERC20 token, bytes memory data) private {
453     require(address(token).isContract(), 'SafeERC20: call to non-contract');
454 
455     // solhint-disable-next-line avoid-low-level-calls
456     (bool success, bytes memory returndata) = address(token).call(data);
457     require(success, 'SafeERC20: low-level call failed');
458 
459     if (returndata.length > 0) {
460       // Return data is optional
461       // solhint-disable-next-line max-line-length
462       require(abi.decode(returndata, (bool)), 'SafeERC20: ERC20 operation did not succeed');
463     }
464   }
465 }
466 
467 /**
468  * @dev Interface of the ERC20 standard as defined in the EIP.
469  */
470 interface IERC20 {
471   /**
472    * @dev Returns the amount of tokens in existence.
473    */
474   function totalSupply() external view returns (uint256);
475 
476   /**
477    * @dev Returns the amount of tokens owned by `account`.
478    */
479   function balanceOf(address account) external view returns (uint256);
480 
481   /**
482    * @dev Moves `amount` tokens from the caller's account to `recipient`.
483    *
484    * Returns a boolean value indicating whether the operation succeeded.
485    *
486    * Emits a {Transfer} event.
487    */
488   function transfer(address recipient, uint256 amount) external returns (bool);
489 
490   /**
491    * @dev Returns the remaining number of tokens that `spender` will be
492    * allowed to spend on behalf of `owner` through {transferFrom}. This is
493    * zero by default.
494    *
495    * This value changes when {approve} or {transferFrom} are called.
496    */
497   function allowance(address owner, address spender) external view returns (uint256);
498 
499   /**
500    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
501    *
502    * Returns a boolean value indicating whether the operation succeeded.
503    *
504    * IMPORTANT: Beware that changing an allowance with this method brings the risk
505    * that someone may use both the old and the new allowance by unfortunate
506    * transaction ordering. One possible solution to mitigate this race
507    * condition is to first reduce the spender's allowance to 0 and set the
508    * desired value afterwards:
509    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
510    *
511    * Emits an {Approval} event.
512    */
513   function approve(address spender, uint256 amount) external returns (bool);
514 
515   /**
516    * @dev Moves `amount` tokens from `sender` to `recipient` using the
517    * allowance mechanism. `amount` is then deducted from the caller's
518    * allowance.
519    *
520    * Returns a boolean value indicating whether the operation succeeded.
521    *
522    * Emits a {Transfer} event.
523    */
524   function transferFrom(
525     address sender,
526     address recipient,
527     uint256 amount
528   ) external returns (bool);
529 
530   /**
531    * @dev Emitted when `value` tokens are moved from one account (`from`) to
532    * another (`to`).
533    *
534    * Note that `value` may be zero.
535    */
536   event Transfer(address indexed from, address indexed to, uint256 value);
537 
538   /**
539    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
540    * a call to {approve}. `value` is the new allowance.
541    */
542   event Approval(address indexed owner, address indexed spender, uint256 value);
543 }
544 
545 
546 
547 interface IERC20Detailed is IERC20 {
548   function name() external view returns (string memory);
549 
550   function symbol() external view returns (string memory);
551 
552   function decimals() external view returns (uint8);
553 }
554 
555 interface IERC20WithPermit is IERC20 {
556   function permit(
557     address owner,
558     address spender,
559     uint256 value,
560     uint256 deadline,
561     uint8 v,
562     bytes32 r,
563     bytes32 s
564   ) external;
565 }
566 
567 /**
568  * @dev Wrappers over Solidity's arithmetic operations with added overflow
569  * checks.
570  *
571  * Arithmetic operations in Solidity wrap on overflow. This can easily result
572  * in bugs, because programmers usually assume that an overflow raises an
573  * error, which is the standard behavior in high level programming languages.
574  * `SafeMath` restores this intuition by reverting the transaction when an
575  * operation overflows.
576  *
577  * Using this library instead of the unchecked operations eliminates an entire
578  * class of bugs, so it's recommended to use it always.
579  */
580 library SafeMath {
581   /**
582    * @dev Returns the addition of two unsigned integers, reverting on
583    * overflow.
584    *
585    * Counterpart to Solidity's `+` operator.
586    *
587    * Requirements:
588    * - Addition cannot overflow.
589    */
590   function add(uint256 a, uint256 b) internal pure returns (uint256) {
591     uint256 c = a + b;
592     require(c >= a, 'SafeMath: addition overflow');
593 
594     return c;
595   }
596 
597   /**
598    * @dev Returns the subtraction of two unsigned integers, reverting on
599    * overflow (when the result is negative).
600    *
601    * Counterpart to Solidity's `-` operator.
602    *
603    * Requirements:
604    * - Subtraction cannot overflow.
605    */
606   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
607     return sub(a, b, 'SafeMath: subtraction overflow');
608   }
609 
610   /**
611    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
612    * overflow (when the result is negative).
613    *
614    * Counterpart to Solidity's `-` operator.
615    *
616    * Requirements:
617    * - Subtraction cannot overflow.
618    */
619   function sub(
620     uint256 a,
621     uint256 b,
622     string memory errorMessage
623   ) internal pure returns (uint256) {
624     require(b <= a, errorMessage);
625     uint256 c = a - b;
626 
627     return c;
628   }
629 
630   /**
631    * @dev Returns the multiplication of two unsigned integers, reverting on
632    * overflow.
633    *
634    * Counterpart to Solidity's `*` operator.
635    *
636    * Requirements:
637    * - Multiplication cannot overflow.
638    */
639   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
640     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
641     // benefit is lost if 'b' is also tested.
642     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
643     if (a == 0) {
644       return 0;
645     }
646 
647     uint256 c = a * b;
648     require(c / a == b, 'SafeMath: multiplication overflow');
649 
650     return c;
651   }
652 
653   /**
654    * @dev Returns the integer division of two unsigned integers. Reverts on
655    * division by zero. The result is rounded towards zero.
656    *
657    * Counterpart to Solidity's `/` operator. Note: this function uses a
658    * `revert` opcode (which leaves remaining gas untouched) while Solidity
659    * uses an invalid opcode to revert (consuming all remaining gas).
660    *
661    * Requirements:
662    * - The divisor cannot be zero.
663    */
664   function div(uint256 a, uint256 b) internal pure returns (uint256) {
665     return div(a, b, 'SafeMath: division by zero');
666   }
667 
668   /**
669    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
670    * division by zero. The result is rounded towards zero.
671    *
672    * Counterpart to Solidity's `/` operator. Note: this function uses a
673    * `revert` opcode (which leaves remaining gas untouched) while Solidity
674    * uses an invalid opcode to revert (consuming all remaining gas).
675    *
676    * Requirements:
677    * - The divisor cannot be zero.
678    */
679   function div(
680     uint256 a,
681     uint256 b,
682     string memory errorMessage
683   ) internal pure returns (uint256) {
684     // Solidity only automatically asserts when dividing by 0
685     require(b > 0, errorMessage);
686     uint256 c = a / b;
687     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
688 
689     return c;
690   }
691 
692   /**
693    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
694    * Reverts when dividing by zero.
695    *
696    * Counterpart to Solidity's `%` operator. This function uses a `revert`
697    * opcode (which leaves remaining gas untouched) while Solidity uses an
698    * invalid opcode to revert (consuming all remaining gas).
699    *
700    * Requirements:
701    * - The divisor cannot be zero.
702    */
703   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
704     return mod(a, b, 'SafeMath: modulo by zero');
705   }
706 
707   /**
708    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
709    * Reverts with custom message when dividing by zero.
710    *
711    * Counterpart to Solidity's `%` operator. This function uses a `revert`
712    * opcode (which leaves remaining gas untouched) while Solidity uses an
713    * invalid opcode to revert (consuming all remaining gas).
714    *
715    * Requirements:
716    * - The divisor cannot be zero.
717    */
718   function mod(
719     uint256 a,
720     uint256 b,
721     string memory errorMessage
722   ) internal pure returns (uint256) {
723     require(b != 0, errorMessage);
724     return a % b;
725   }
726 }
727 
728 /**
729  * @title Errors library
730  * @author Aave
731  * @notice Defines the error messages emitted by the different contracts of the Aave protocol
732  * @dev Error messages prefix glossary:
733  *  - VL = ValidationLogic
734  *  - MATH = Math libraries
735  *  - CT = Common errors between tokens (AToken, VariableDebtToken and StableDebtToken)
736  *  - AT = AToken
737  *  - SDT = StableDebtToken
738  *  - VDT = VariableDebtToken
739  *  - LP = LendingPool
740  *  - LPAPR = LendingPoolAddressesProviderRegistry
741  *  - LPC = LendingPoolConfiguration
742  *  - RL = ReserveLogic
743  *  - LPCM = LendingPoolCollateralManager
744  *  - P = Pausable
745  */
746 library Errors {
747   //common errors
748   string public constant CALLER_NOT_POOL_ADMIN = '33'; // 'The caller must be the pool admin'
749   string public constant BORROW_ALLOWANCE_NOT_ENOUGH = '59'; // User borrows on behalf, but allowance are too small
750 
751   //contract specific errors
752   string public constant VL_INVALID_AMOUNT = '1'; // 'Amount must be greater than 0'
753   string public constant VL_NO_ACTIVE_RESERVE = '2'; // 'Action requires an active reserve'
754   string public constant VL_RESERVE_FROZEN = '3'; // 'Action cannot be performed because the reserve is frozen'
755   string public constant VL_CURRENT_AVAILABLE_LIQUIDITY_NOT_ENOUGH = '4'; // 'The current liquidity is not enough'
756   string public constant VL_NOT_ENOUGH_AVAILABLE_USER_BALANCE = '5'; // 'User cannot withdraw more than the available balance'
757   string public constant VL_TRANSFER_NOT_ALLOWED = '6'; // 'Transfer cannot be allowed.'
758   string public constant VL_BORROWING_NOT_ENABLED = '7'; // 'Borrowing is not enabled'
759   string public constant VL_INVALID_INTEREST_RATE_MODE_SELECTED = '8'; // 'Invalid interest rate mode selected'
760   string public constant VL_COLLATERAL_BALANCE_IS_0 = '9'; // 'The collateral balance is 0'
761   string public constant VL_HEALTH_FACTOR_LOWER_THAN_LIQUIDATION_THRESHOLD = '10'; // 'Health factor is lesser than the liquidation threshold'
762   string public constant VL_COLLATERAL_CANNOT_COVER_NEW_BORROW = '11'; // 'There is not enough collateral to cover a new borrow'
763   string public constant VL_STABLE_BORROWING_NOT_ENABLED = '12'; // stable borrowing not enabled
764   string public constant VL_COLLATERAL_SAME_AS_BORROWING_CURRENCY = '13'; // collateral is (mostly) the same currency that is being borrowed
765   string public constant VL_AMOUNT_BIGGER_THAN_MAX_LOAN_SIZE_STABLE = '14'; // 'The requested amount is greater than the max loan size in stable rate mode
766   string public constant VL_NO_DEBT_OF_SELECTED_TYPE = '15'; // 'for repayment of stable debt, the user needs to have stable debt, otherwise, he needs to have variable debt'
767   string public constant VL_NO_EXPLICIT_AMOUNT_TO_REPAY_ON_BEHALF = '16'; // 'To repay on behalf of an user an explicit amount to repay is needed'
768   string public constant VL_NO_STABLE_RATE_LOAN_IN_RESERVE = '17'; // 'User does not have a stable rate loan in progress on this reserve'
769   string public constant VL_NO_VARIABLE_RATE_LOAN_IN_RESERVE = '18'; // 'User does not have a variable rate loan in progress on this reserve'
770   string public constant VL_UNDERLYING_BALANCE_NOT_GREATER_THAN_0 = '19'; // 'The underlying balance needs to be greater than 0'
771   string public constant VL_DEPOSIT_ALREADY_IN_USE = '20'; // 'User deposit is already being used as collateral'
772   string public constant LP_NOT_ENOUGH_STABLE_BORROW_BALANCE = '21'; // 'User does not have any stable rate loan for this reserve'
773   string public constant LP_INTEREST_RATE_REBALANCE_CONDITIONS_NOT_MET = '22'; // 'Interest rate rebalance conditions were not met'
774   string public constant LP_LIQUIDATION_CALL_FAILED = '23'; // 'Liquidation call failed'
775   string public constant LP_NOT_ENOUGH_LIQUIDITY_TO_BORROW = '24'; // 'There is not enough liquidity available to borrow'
776   string public constant LP_REQUESTED_AMOUNT_TOO_SMALL = '25'; // 'The requested amount is too small for a FlashLoan.'
777   string public constant LP_INCONSISTENT_PROTOCOL_ACTUAL_BALANCE = '26'; // 'The actual balance of the protocol is inconsistent'
778   string public constant LP_CALLER_NOT_LENDING_POOL_CONFIGURATOR = '27'; // 'The caller of the function is not the lending pool configurator'
779   string public constant LP_INCONSISTENT_FLASHLOAN_PARAMS = '28';
780   string public constant CT_CALLER_MUST_BE_LENDING_POOL = '29'; // 'The caller of this function must be a lending pool'
781   string public constant CT_CANNOT_GIVE_ALLOWANCE_TO_HIMSELF = '30'; // 'User cannot give allowance to himself'
782   string public constant CT_TRANSFER_AMOUNT_NOT_GT_0 = '31'; // 'Transferred amount needs to be greater than zero'
783   string public constant RL_RESERVE_ALREADY_INITIALIZED = '32'; // 'Reserve has already been initialized'
784   string public constant LPC_RESERVE_LIQUIDITY_NOT_0 = '34'; // 'The liquidity of the reserve needs to be 0'
785   string public constant LPC_INVALID_ATOKEN_POOL_ADDRESS = '35'; // 'The liquidity of the reserve needs to be 0'
786   string public constant LPC_INVALID_STABLE_DEBT_TOKEN_POOL_ADDRESS = '36'; // 'The liquidity of the reserve needs to be 0'
787   string public constant LPC_INVALID_VARIABLE_DEBT_TOKEN_POOL_ADDRESS = '37'; // 'The liquidity of the reserve needs to be 0'
788   string public constant LPC_INVALID_STABLE_DEBT_TOKEN_UNDERLYING_ADDRESS = '38'; // 'The liquidity of the reserve needs to be 0'
789   string public constant LPC_INVALID_VARIABLE_DEBT_TOKEN_UNDERLYING_ADDRESS = '39'; // 'The liquidity of the reserve needs to be 0'
790   string public constant LPC_INVALID_ADDRESSES_PROVIDER_ID = '40'; // 'The liquidity of the reserve needs to be 0'
791   string public constant LPC_INVALID_CONFIGURATION = '75'; // 'Invalid risk parameters for the reserve'
792   string public constant LPC_CALLER_NOT_EMERGENCY_ADMIN = '76'; // 'The caller must be the emergency admin'
793   string public constant LPAPR_PROVIDER_NOT_REGISTERED = '41'; // 'Provider is not registered'
794   string public constant LPCM_HEALTH_FACTOR_NOT_BELOW_THRESHOLD = '42'; // 'Health factor is not below the threshold'
795   string public constant LPCM_COLLATERAL_CANNOT_BE_LIQUIDATED = '43'; // 'The collateral chosen cannot be liquidated'
796   string public constant LPCM_SPECIFIED_CURRENCY_NOT_BORROWED_BY_USER = '44'; // 'User did not borrow the specified currency'
797   string public constant LPCM_NOT_ENOUGH_LIQUIDITY_TO_LIQUIDATE = '45'; // "There isn't enough liquidity available to liquidate"
798   string public constant LPCM_NO_ERRORS = '46'; // 'No errors'
799   string public constant LP_INVALID_FLASHLOAN_MODE = '47'; //Invalid flashloan mode selected
800   string public constant MATH_MULTIPLICATION_OVERFLOW = '48';
801   string public constant MATH_ADDITION_OVERFLOW = '49';
802   string public constant MATH_DIVISION_BY_ZERO = '50';
803   string public constant RL_LIQUIDITY_INDEX_OVERFLOW = '51'; //  Liquidity index overflows uint128
804   string public constant RL_VARIABLE_BORROW_INDEX_OVERFLOW = '52'; //  Variable borrow index overflows uint128
805   string public constant RL_LIQUIDITY_RATE_OVERFLOW = '53'; //  Liquidity rate overflows uint128
806   string public constant RL_VARIABLE_BORROW_RATE_OVERFLOW = '54'; //  Variable borrow rate overflows uint128
807   string public constant RL_STABLE_BORROW_RATE_OVERFLOW = '55'; //  Stable borrow rate overflows uint128
808   string public constant CT_INVALID_MINT_AMOUNT = '56'; //invalid amount to mint
809   string public constant LP_FAILED_REPAY_WITH_COLLATERAL = '57';
810   string public constant CT_INVALID_BURN_AMOUNT = '58'; //invalid amount to burn
811   string public constant LP_FAILED_COLLATERAL_SWAP = '60';
812   string public constant LP_INVALID_EQUAL_ASSETS_TO_SWAP = '61';
813   string public constant LP_REENTRANCY_NOT_ALLOWED = '62';
814   string public constant LP_CALLER_MUST_BE_AN_ATOKEN = '63';
815   string public constant LP_IS_PAUSED = '64'; // 'Pool is paused'
816   string public constant LP_NO_MORE_RESERVES_ALLOWED = '65';
817   string public constant LP_INVALID_FLASH_LOAN_EXECUTOR_RETURN = '66';
818   string public constant RC_INVALID_LTV = '67';
819   string public constant RC_INVALID_LIQ_THRESHOLD = '68';
820   string public constant RC_INVALID_LIQ_BONUS = '69';
821   string public constant RC_INVALID_DECIMALS = '70';
822   string public constant RC_INVALID_RESERVE_FACTOR = '71';
823   string public constant LPAPR_INVALID_ADDRESSES_PROVIDER_ID = '72';
824   string public constant VL_INCONSISTENT_FLASHLOAN_PARAMS = '73';
825   string public constant LP_INCONSISTENT_PARAMS_LENGTH = '74';
826   string public constant UL_INVALID_INDEX = '77';
827   string public constant LP_NOT_CONTRACT = '78';
828   string public constant SDT_STABLE_DEBT_OVERFLOW = '79';
829   string public constant SDT_BURN_EXCEEDS_BALANCE = '80';
830 
831   enum CollateralManagerErrors {
832     NO_ERROR,
833     NO_COLLATERAL_AVAILABLE,
834     COLLATERAL_CANNOT_BE_LIQUIDATED,
835     CURRRENCY_NOT_BORROWED,
836     HEALTH_FACTOR_ABOVE_THRESHOLD,
837     NOT_ENOUGH_LIQUIDITY,
838     NO_ACTIVE_RESERVE,
839     HEALTH_FACTOR_LOWER_THAN_LIQUIDATION_THRESHOLD,
840     INVALID_EQUAL_ASSETS_TO_SWAP,
841     FROZEN_RESERVE
842   }
843 }
844 
845 interface ILendingPool {
846   /**
847    * @dev Emitted on deposit()
848    * @param reserve The address of the underlying asset of the reserve
849    * @param user The address initiating the deposit
850    * @param onBehalfOf The beneficiary of the deposit, receiving the aTokens
851    * @param amount The amount deposited
852    * @param referral The referral code used
853    **/
854   event Deposit(
855     address indexed reserve,
856     address user,
857     address indexed onBehalfOf,
858     uint256 amount,
859     uint16 indexed referral
860   );
861 
862   /**
863    * @dev Emitted on withdraw()
864    * @param reserve The address of the underlyng asset being withdrawn
865    * @param user The address initiating the withdrawal, owner of aTokens
866    * @param to Address that will receive the underlying
867    * @param amount The amount to be withdrawn
868    **/
869   event Withdraw(address indexed reserve, address indexed user, address indexed to, uint256 amount);
870 
871   /**
872    * @dev Emitted on borrow() and flashLoan() when debt needs to be opened
873    * @param reserve The address of the underlying asset being borrowed
874    * @param user The address of the user initiating the borrow(), receiving the funds on borrow() or just
875    * initiator of the transaction on flashLoan()
876    * @param onBehalfOf The address that will be getting the debt
877    * @param amount The amount borrowed out
878    * @param borrowRateMode The rate mode: 1 for Stable, 2 for Variable
879    * @param borrowRate The numeric rate at which the user has borrowed
880    * @param referral The referral code used
881    **/
882   event Borrow(
883     address indexed reserve,
884     address user,
885     address indexed onBehalfOf,
886     uint256 amount,
887     uint256 borrowRateMode,
888     uint256 borrowRate,
889     uint16 indexed referral
890   );
891 
892   /**
893    * @dev Emitted on repay()
894    * @param reserve The address of the underlying asset of the reserve
895    * @param user The beneficiary of the repayment, getting his debt reduced
896    * @param repayer The address of the user initiating the repay(), providing the funds
897    * @param amount The amount repaid
898    **/
899   event Repay(
900     address indexed reserve,
901     address indexed user,
902     address indexed repayer,
903     uint256 amount
904   );
905 
906   /**
907    * @dev Emitted on swapBorrowRateMode()
908    * @param reserve The address of the underlying asset of the reserve
909    * @param user The address of the user swapping his rate mode
910    * @param rateMode The rate mode that the user wants to swap to
911    **/
912   event Swap(address indexed reserve, address indexed user, uint256 rateMode);
913 
914   /**
915    * @dev Emitted on setUserUseReserveAsCollateral()
916    * @param reserve The address of the underlying asset of the reserve
917    * @param user The address of the user enabling the usage as collateral
918    **/
919   event ReserveUsedAsCollateralEnabled(address indexed reserve, address indexed user);
920 
921   /**
922    * @dev Emitted on setUserUseReserveAsCollateral()
923    * @param reserve The address of the underlying asset of the reserve
924    * @param user The address of the user enabling the usage as collateral
925    **/
926   event ReserveUsedAsCollateralDisabled(address indexed reserve, address indexed user);
927 
928   /**
929    * @dev Emitted on rebalanceStableBorrowRate()
930    * @param reserve The address of the underlying asset of the reserve
931    * @param user The address of the user for which the rebalance has been executed
932    **/
933   event RebalanceStableBorrowRate(address indexed reserve, address indexed user);
934 
935   /**
936    * @dev Emitted on flashLoan()
937    * @param target The address of the flash loan receiver contract
938    * @param initiator The address initiating the flash loan
939    * @param asset The address of the asset being flash borrowed
940    * @param amount The amount flash borrowed
941    * @param premium The fee flash borrowed
942    * @param referralCode The referral code used
943    **/
944   event FlashLoan(
945     address indexed target,
946     address indexed initiator,
947     address indexed asset,
948     uint256 amount,
949     uint256 premium,
950     uint16 referralCode
951   );
952 
953   /**
954    * @dev Emitted when the pause is triggered.
955    */
956   event Paused();
957 
958   /**
959    * @dev Emitted when the pause is lifted.
960    */
961   event Unpaused();
962 
963   /**
964    * @dev Emitted when a borrower is liquidated. This event is emitted by the LendingPool via
965    * LendingPoolCollateral manager using a DELEGATECALL
966    * This allows to have the events in the generated ABI for LendingPool.
967    * @param collateralAsset The address of the underlying asset used as collateral, to receive as result of the liquidation
968    * @param debtAsset The address of the underlying borrowed asset to be repaid with the liquidation
969    * @param user The address of the borrower getting liquidated
970    * @param debtToCover The debt amount of borrowed `asset` the liquidator wants to cover
971    * @param liquidatedCollateralAmount The amount of collateral received by the liiquidator
972    * @param liquidator The address of the liquidator
973    * @param receiveAToken `true` if the liquidators wants to receive the collateral aTokens, `false` if he wants
974    * to receive the underlying collateral asset directly
975    **/
976   event LiquidationCall(
977     address indexed collateralAsset,
978     address indexed debtAsset,
979     address indexed user,
980     uint256 debtToCover,
981     uint256 liquidatedCollateralAmount,
982     address liquidator,
983     bool receiveAToken
984   );
985 
986   /**
987    * @dev Emitted when the state of a reserve is updated. NOTE: This event is actually declared
988    * in the ReserveLogic library and emitted in the updateInterestRates() function. Since the function is internal,
989    * the event will actually be fired by the LendingPool contract. The event is therefore replicated here so it
990    * gets added to the LendingPool ABI
991    * @param reserve The address of the underlying asset of the reserve
992    * @param liquidityRate The new liquidity rate
993    * @param stableBorrowRate The new stable borrow rate
994    * @param variableBorrowRate The new variable borrow rate
995    * @param liquidityIndex The new liquidity index
996    * @param variableBorrowIndex The new variable borrow index
997    **/
998   event ReserveDataUpdated(
999     address indexed reserve,
1000     uint256 liquidityRate,
1001     uint256 stableBorrowRate,
1002     uint256 variableBorrowRate,
1003     uint256 liquidityIndex,
1004     uint256 variableBorrowIndex
1005   );
1006 
1007   /**
1008    * @dev Deposits an `amount` of underlying asset into the reserve, receiving in return overlying aTokens.
1009    * - E.g. User deposits 100 USDC and gets in return 100 aUSDC
1010    * @param asset The address of the underlying asset to deposit
1011    * @param amount The amount to be deposited
1012    * @param onBehalfOf The address that will receive the aTokens, same as msg.sender if the user
1013    *   wants to receive them on his own wallet, or a different address if the beneficiary of aTokens
1014    *   is a different wallet
1015    * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
1016    *   0 if the action is executed directly by the user, without any middle-man
1017    **/
1018   function deposit(
1019     address asset,
1020     uint256 amount,
1021     address onBehalfOf,
1022     uint16 referralCode
1023   ) external;
1024 
1025   /**
1026    * @dev Withdraws an `amount` of underlying asset from the reserve, burning the equivalent aTokens owned
1027    * E.g. User has 100 aUSDC, calls withdraw() and receives 100 USDC, burning the 100 aUSDC
1028    * @param asset The address of the underlying asset to withdraw
1029    * @param amount The underlying amount to be withdrawn
1030    *   - Send the value type(uint256).max in order to withdraw the whole aToken balance
1031    * @param to Address that will receive the underlying, same as msg.sender if the user
1032    *   wants to receive it on his own wallet, or a different address if the beneficiary is a
1033    *   different wallet
1034    * @return The final amount withdrawn
1035    **/
1036   function withdraw(
1037     address asset,
1038     uint256 amount,
1039     address to
1040   ) external returns (uint256);
1041 
1042   /**
1043    * @dev Allows users to borrow a specific `amount` of the reserve underlying asset, provided that the borrower
1044    * already deposited enough collateral, or he was given enough allowance by a credit delegator on the
1045    * corresponding debt token (StableDebtToken or VariableDebtToken)
1046    * - E.g. User borrows 100 USDC passing as `onBehalfOf` his own address, receiving the 100 USDC in his wallet
1047    *   and 100 stable/variable debt tokens, depending on the `interestRateMode`
1048    * @param asset The address of the underlying asset to borrow
1049    * @param amount The amount to be borrowed
1050    * @param interestRateMode The interest rate mode at which the user wants to borrow: 1 for Stable, 2 for Variable
1051    * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
1052    *   0 if the action is executed directly by the user, without any middle-man
1053    * @param onBehalfOf Address of the user who will receive the debt. Should be the address of the borrower itself
1054    * calling the function if he wants to borrow against his own collateral, or the address of the credit delegator
1055    * if he has been given credit delegation allowance
1056    **/
1057   function borrow(
1058     address asset,
1059     uint256 amount,
1060     uint256 interestRateMode,
1061     uint16 referralCode,
1062     address onBehalfOf
1063   ) external;
1064 
1065   /**
1066    * @notice Repays a borrowed `amount` on a specific reserve, burning the equivalent debt tokens owned
1067    * - E.g. User repays 100 USDC, burning 100 variable/stable debt tokens of the `onBehalfOf` address
1068    * @param asset The address of the borrowed underlying asset previously borrowed
1069    * @param amount The amount to repay
1070    * - Send the value type(uint256).max in order to repay the whole debt for `asset` on the specific `debtMode`
1071    * @param rateMode The interest rate mode at of the debt the user wants to repay: 1 for Stable, 2 for Variable
1072    * @param onBehalfOf Address of the user who will get his debt reduced/removed. Should be the address of the
1073    * user calling the function if he wants to reduce/remove his own debt, or the address of any other
1074    * other borrower whose debt should be removed
1075    * @return The final amount repaid
1076    **/
1077   function repay(
1078     address asset,
1079     uint256 amount,
1080     uint256 rateMode,
1081     address onBehalfOf
1082   ) external returns (uint256);
1083 
1084   /**
1085    * @dev Allows a borrower to swap his debt between stable and variable mode, or viceversa
1086    * @param asset The address of the underlying asset borrowed
1087    * @param rateMode The rate mode that the user wants to swap to
1088    **/
1089   function swapBorrowRateMode(address asset, uint256 rateMode) external;
1090 
1091   /**
1092    * @dev Rebalances the stable interest rate of a user to the current stable rate defined on the reserve.
1093    * - Users can be rebalanced if the following conditions are satisfied:
1094    *     1. Usage ratio is above 95%
1095    *     2. the current deposit APY is below REBALANCE_UP_THRESHOLD * maxVariableBorrowRate, which means that too much has been
1096    *        borrowed at a stable rate and depositors are not earning enough
1097    * @param asset The address of the underlying asset borrowed
1098    * @param user The address of the user to be rebalanced
1099    **/
1100   function rebalanceStableBorrowRate(address asset, address user) external;
1101 
1102   /**
1103    * @dev Allows depositors to enable/disable a specific deposited asset as collateral
1104    * @param asset The address of the underlying asset deposited
1105    * @param useAsCollateral `true` if the user wants to use the deposit as collateral, `false` otherwise
1106    **/
1107   function setUserUseReserveAsCollateral(address asset, bool useAsCollateral) external;
1108 
1109   /**
1110    * @dev Function to liquidate a non-healthy position collateral-wise, with Health Factor below 1
1111    * - The caller (liquidator) covers `debtToCover` amount of debt of the user getting liquidated, and receives
1112    *   a proportionally amount of the `collateralAsset` plus a bonus to cover market risk
1113    * @param collateralAsset The address of the underlying asset used as collateral, to receive as result of the liquidation
1114    * @param debtAsset The address of the underlying borrowed asset to be repaid with the liquidation
1115    * @param user The address of the borrower getting liquidated
1116    * @param debtToCover The debt amount of borrowed `asset` the liquidator wants to cover
1117    * @param receiveAToken `true` if the liquidators wants to receive the collateral aTokens, `false` if he wants
1118    * to receive the underlying collateral asset directly
1119    **/
1120   function liquidationCall(
1121     address collateralAsset,
1122     address debtAsset,
1123     address user,
1124     uint256 debtToCover,
1125     bool receiveAToken
1126   ) external;
1127 
1128   /**
1129    * @dev Allows smartcontracts to access the liquidity of the pool within one transaction,
1130    * as long as the amount taken plus a fee is returned.
1131    * IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept into consideration.
1132    * For further details please visit https://developers.aave.com
1133    * @param receiverAddress The address of the contract receiving the funds, implementing the IFlashLoanReceiver interface
1134    * @param assets The addresses of the assets being flash-borrowed
1135    * @param amounts The amounts amounts being flash-borrowed
1136    * @param modes Types of the debt to open if the flash loan is not returned:
1137    *   0 -> Don't open any debt, just revert if funds can't be transferred from the receiver
1138    *   1 -> Open debt at stable rate for the value of the amount flash-borrowed to the `onBehalfOf` address
1139    *   2 -> Open debt at variable rate for the value of the amount flash-borrowed to the `onBehalfOf` address
1140    * @param onBehalfOf The address  that will receive the debt in the case of using on `modes` 1 or 2
1141    * @param params Variadic packed params to pass to the receiver as extra information
1142    * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
1143    *   0 if the action is executed directly by the user, without any middle-man
1144    **/
1145   function flashLoan(
1146     address receiverAddress,
1147     address[] calldata assets,
1148     uint256[] calldata amounts,
1149     uint256[] calldata modes,
1150     address onBehalfOf,
1151     bytes calldata params,
1152     uint16 referralCode
1153   ) external;
1154 
1155   /**
1156    * @dev Returns the user account data across all the reserves
1157    * @param user The address of the user
1158    * @return totalCollateralETH the total collateral in ETH of the user
1159    * @return totalDebtETH the total debt in ETH of the user
1160    * @return availableBorrowsETH the borrowing power left of the user
1161    * @return currentLiquidationThreshold the liquidation threshold of the user
1162    * @return ltv the loan to value of the user
1163    * @return healthFactor the current health factor of the user
1164    **/
1165   function getUserAccountData(address user)
1166     external
1167     view
1168     returns (
1169       uint256 totalCollateralETH,
1170       uint256 totalDebtETH,
1171       uint256 availableBorrowsETH,
1172       uint256 currentLiquidationThreshold,
1173       uint256 ltv,
1174       uint256 healthFactor
1175     );
1176 
1177   function initReserve(
1178     address reserve,
1179     address aTokenAddress,
1180     address stableDebtAddress,
1181     address variableDebtAddress,
1182     address interestRateStrategyAddress
1183   ) external;
1184 
1185   function setReserveInterestRateStrategyAddress(address reserve, address rateStrategyAddress)
1186     external;
1187 
1188   function setConfiguration(address reserve, uint256 configuration) external;
1189 
1190   /**
1191    * @dev Returns the configuration of the reserve
1192    * @param asset The address of the underlying asset of the reserve
1193    * @return The configuration of the reserve
1194    **/
1195   function getConfiguration(address asset)
1196     external
1197     view
1198     returns (DataTypes.ReserveConfigurationMap memory);
1199 
1200   /**
1201    * @dev Returns the configuration of the user across all the reserves
1202    * @param user The user address
1203    * @return The configuration of the user
1204    **/
1205   function getUserConfiguration(address user)
1206     external
1207     view
1208     returns (DataTypes.UserConfigurationMap memory);
1209 
1210   /**
1211    * @dev Returns the normalized income normalized income of the reserve
1212    * @param asset The address of the underlying asset of the reserve
1213    * @return The reserve's normalized income
1214    */
1215   function getReserveNormalizedIncome(address asset) external view returns (uint256);
1216 
1217   /**
1218    * @dev Returns the normalized variable debt per unit of asset
1219    * @param asset The address of the underlying asset of the reserve
1220    * @return The reserve normalized variable debt
1221    */
1222   function getReserveNormalizedVariableDebt(address asset) external view returns (uint256);
1223 
1224   /**
1225    * @dev Returns the state and configuration of the reserve
1226    * @param asset The address of the underlying asset of the reserve
1227    * @return The state of the reserve
1228    **/
1229   function getReserveData(address asset) external view returns (DataTypes.ReserveData memory);
1230 
1231   function finalizeTransfer(
1232     address asset,
1233     address from,
1234     address to,
1235     uint256 amount,
1236     uint256 balanceFromAfter,
1237     uint256 balanceToBefore
1238   ) external;
1239 
1240   function getReservesList() external view returns (address[] memory);
1241 
1242   function getAddressesProvider() external view returns (ILendingPoolAddressesProvider);
1243 
1244   function setPause(bool val) external;
1245 
1246   function paused() external view returns (bool);
1247 }
1248 
1249 /**
1250  * @title PercentageMath library
1251  * @author Aave
1252  * @notice Provides functions to perform percentage calculations
1253  * @dev Percentages are defined by default with 2 decimals of precision (100.00). The precision is indicated by PERCENTAGE_FACTOR
1254  * @dev Operations are rounded half up
1255  **/
1256 
1257 library PercentageMath {
1258   uint256 constant PERCENTAGE_FACTOR = 1e4; //percentage plus two decimals
1259   uint256 constant HALF_PERCENT = PERCENTAGE_FACTOR / 2;
1260 
1261   /**
1262    * @dev Executes a percentage multiplication
1263    * @param value The value of which the percentage needs to be calculated
1264    * @param percentage The percentage of the value to be calculated
1265    * @return The percentage of value
1266    **/
1267   function percentMul(uint256 value, uint256 percentage) internal pure returns (uint256) {
1268     if (value == 0 || percentage == 0) {
1269       return 0;
1270     }
1271 
1272     require(
1273       value <= (type(uint256).max - HALF_PERCENT) / percentage,
1274       Errors.MATH_MULTIPLICATION_OVERFLOW
1275     );
1276 
1277     return (value * percentage + HALF_PERCENT) / PERCENTAGE_FACTOR;
1278   }
1279 
1280   /**
1281    * @dev Executes a percentage division
1282    * @param value The value of which the percentage needs to be calculated
1283    * @param percentage The percentage of the value to be calculated
1284    * @return The value divided the percentage
1285    **/
1286   function percentDiv(uint256 value, uint256 percentage) internal pure returns (uint256) {
1287     require(percentage != 0, Errors.MATH_DIVISION_BY_ZERO);
1288     uint256 halfPercentage = percentage / 2;
1289 
1290     require(
1291       value <= (type(uint256).max - halfPercentage) / PERCENTAGE_FACTOR,
1292       Errors.MATH_MULTIPLICATION_OVERFLOW
1293     );
1294 
1295     return (value * PERCENTAGE_FACTOR + halfPercentage) / percentage;
1296   }
1297 }
1298 
1299 /**
1300  * @title BaseUniswapAdapter
1301  * @notice Implements the logic for performing assets swaps in Uniswap V2
1302  * @author Aave
1303  **/
1304 abstract contract BaseUniswapAdapter is FlashLoanReceiverBase, IBaseUniswapAdapter, Ownable {
1305   using SafeMath for uint256;
1306   using PercentageMath for uint256;
1307   using SafeERC20 for IERC20;
1308 
1309   // Max slippage percent allowed
1310   uint256 public constant override MAX_SLIPPAGE_PERCENT = 3000; // 30%
1311   // FLash Loan fee set in lending pool
1312   uint256 public constant override FLASHLOAN_PREMIUM_TOTAL = 9;
1313   // USD oracle asset address
1314   address public constant override USD_ADDRESS = 0x10F7Fc1F91Ba351f9C629c5947AD69bD03C05b96;
1315 
1316   //  address public constant WETH_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; mainnet
1317   //  address public constant WETH_ADDRESS = 0xd0a1e359811322d97991e03f863a0c30c2cf029c; kovan
1318 
1319   address public immutable override WETH_ADDRESS;
1320   IPriceOracleGetter public immutable override ORACLE;
1321   IUniswapV2Router02 public immutable override UNISWAP_ROUTER;
1322 
1323   constructor(
1324     ILendingPoolAddressesProvider addressesProvider,
1325     IUniswapV2Router02 uniswapRouter,
1326     address wethAddress
1327   ) public FlashLoanReceiverBase(addressesProvider) {
1328     ORACLE = IPriceOracleGetter(addressesProvider.getPriceOracle());
1329     UNISWAP_ROUTER = uniswapRouter;
1330     WETH_ADDRESS = wethAddress;
1331   }
1332 
1333   /**
1334    * @dev Given an input asset amount, returns the maximum output amount of the other asset and the prices
1335    * @param amountIn Amount of reserveIn
1336    * @param reserveIn Address of the asset to be swap from
1337    * @param reserveOut Address of the asset to be swap to
1338    * @return uint256 Amount out of the reserveOut
1339    * @return uint256 The price of out amount denominated in the reserveIn currency (18 decimals)
1340    * @return uint256 In amount of reserveIn value denominated in USD (8 decimals)
1341    * @return uint256 Out amount of reserveOut value denominated in USD (8 decimals)
1342    */
1343   function getAmountsOut(
1344     uint256 amountIn,
1345     address reserveIn,
1346     address reserveOut
1347   )
1348     external
1349     view
1350     override
1351     returns (
1352       uint256,
1353       uint256,
1354       uint256,
1355       uint256,
1356       address[] memory
1357     )
1358   {
1359     AmountCalc memory results = _getAmountsOutData(reserveIn, reserveOut, amountIn);
1360 
1361     return (
1362       results.calculatedAmount,
1363       results.relativePrice,
1364       results.amountInUsd,
1365       results.amountOutUsd,
1366       results.path
1367     );
1368   }
1369 
1370   /**
1371    * @dev Returns the minimum input asset amount required to buy the given output asset amount and the prices
1372    * @param amountOut Amount of reserveOut
1373    * @param reserveIn Address of the asset to be swap from
1374    * @param reserveOut Address of the asset to be swap to
1375    * @return uint256 Amount in of the reserveIn
1376    * @return uint256 The price of in amount denominated in the reserveOut currency (18 decimals)
1377    * @return uint256 In amount of reserveIn value denominated in USD (8 decimals)
1378    * @return uint256 Out amount of reserveOut value denominated in USD (8 decimals)
1379    */
1380   function getAmountsIn(
1381     uint256 amountOut,
1382     address reserveIn,
1383     address reserveOut
1384   )
1385     external
1386     view
1387     override
1388     returns (
1389       uint256,
1390       uint256,
1391       uint256,
1392       uint256,
1393       address[] memory
1394     )
1395   {
1396     AmountCalc memory results = _getAmountsInData(reserveIn, reserveOut, amountOut);
1397 
1398     return (
1399       results.calculatedAmount,
1400       results.relativePrice,
1401       results.amountInUsd,
1402       results.amountOutUsd,
1403       results.path
1404     );
1405   }
1406 
1407   /**
1408    * @dev Swaps an exact `amountToSwap` of an asset to another
1409    * @param assetToSwapFrom Origin asset
1410    * @param assetToSwapTo Destination asset
1411    * @param amountToSwap Exact amount of `assetToSwapFrom` to be swapped
1412    * @param minAmountOut the min amount of `assetToSwapTo` to be received from the swap
1413    * @return the amount received from the swap
1414    */
1415   function _swapExactTokensForTokens(
1416     address assetToSwapFrom,
1417     address assetToSwapTo,
1418     uint256 amountToSwap,
1419     uint256 minAmountOut,
1420     bool useEthPath
1421   ) internal returns (uint256) {
1422     uint256 fromAssetDecimals = _getDecimals(assetToSwapFrom);
1423     uint256 toAssetDecimals = _getDecimals(assetToSwapTo);
1424 
1425     uint256 fromAssetPrice = _getPrice(assetToSwapFrom);
1426     uint256 toAssetPrice = _getPrice(assetToSwapTo);
1427 
1428     uint256 expectedMinAmountOut =
1429       amountToSwap
1430         .mul(fromAssetPrice.mul(10**toAssetDecimals))
1431         .div(toAssetPrice.mul(10**fromAssetDecimals))
1432         .percentMul(PercentageMath.PERCENTAGE_FACTOR.sub(MAX_SLIPPAGE_PERCENT));
1433 
1434     require(expectedMinAmountOut < minAmountOut, 'minAmountOut exceed max slippage');
1435 
1436     // Approves the transfer for the swap. Approves for 0 first to comply with tokens that implement the anti frontrunning approval fix.
1437     IERC20(assetToSwapFrom).safeApprove(address(UNISWAP_ROUTER), 0);
1438     IERC20(assetToSwapFrom).safeApprove(address(UNISWAP_ROUTER), amountToSwap);
1439 
1440     address[] memory path;
1441     if (useEthPath) {
1442       path = new address[](3);
1443       path[0] = assetToSwapFrom;
1444       path[1] = WETH_ADDRESS;
1445       path[2] = assetToSwapTo;
1446     } else {
1447       path = new address[](2);
1448       path[0] = assetToSwapFrom;
1449       path[1] = assetToSwapTo;
1450     }
1451     uint256[] memory amounts =
1452       UNISWAP_ROUTER.swapExactTokensForTokens(
1453         amountToSwap,
1454         minAmountOut,
1455         path,
1456         address(this),
1457         block.timestamp
1458       );
1459 
1460     emit Swapped(assetToSwapFrom, assetToSwapTo, amounts[0], amounts[amounts.length - 1]);
1461 
1462     return amounts[amounts.length - 1];
1463   }
1464 
1465   /**
1466    * @dev Receive an exact amount `amountToReceive` of `assetToSwapTo` tokens for as few `assetToSwapFrom` tokens as
1467    * possible.
1468    * @param assetToSwapFrom Origin asset
1469    * @param assetToSwapTo Destination asset
1470    * @param maxAmountToSwap Max amount of `assetToSwapFrom` allowed to be swapped
1471    * @param amountToReceive Exact amount of `assetToSwapTo` to receive
1472    * @return the amount swapped
1473    */
1474   function _swapTokensForExactTokens(
1475     address assetToSwapFrom,
1476     address assetToSwapTo,
1477     uint256 maxAmountToSwap,
1478     uint256 amountToReceive,
1479     bool useEthPath
1480   ) internal returns (uint256) {
1481     uint256 fromAssetDecimals = _getDecimals(assetToSwapFrom);
1482     uint256 toAssetDecimals = _getDecimals(assetToSwapTo);
1483 
1484     uint256 fromAssetPrice = _getPrice(assetToSwapFrom);
1485     uint256 toAssetPrice = _getPrice(assetToSwapTo);
1486 
1487     uint256 expectedMaxAmountToSwap =
1488       amountToReceive
1489         .mul(toAssetPrice.mul(10**fromAssetDecimals))
1490         .div(fromAssetPrice.mul(10**toAssetDecimals))
1491         .percentMul(PercentageMath.PERCENTAGE_FACTOR.add(MAX_SLIPPAGE_PERCENT));
1492 
1493     require(maxAmountToSwap < expectedMaxAmountToSwap, 'maxAmountToSwap exceed max slippage');
1494 
1495     // Approves the transfer for the swap. Approves for 0 first to comply with tokens that implement the anti frontrunning approval fix.
1496     IERC20(assetToSwapFrom).safeApprove(address(UNISWAP_ROUTER), 0);
1497     IERC20(assetToSwapFrom).safeApprove(address(UNISWAP_ROUTER), maxAmountToSwap);
1498 
1499     address[] memory path;
1500     if (useEthPath) {
1501       path = new address[](3);
1502       path[0] = assetToSwapFrom;
1503       path[1] = WETH_ADDRESS;
1504       path[2] = assetToSwapTo;
1505     } else {
1506       path = new address[](2);
1507       path[0] = assetToSwapFrom;
1508       path[1] = assetToSwapTo;
1509     }
1510 
1511     uint256[] memory amounts =
1512       UNISWAP_ROUTER.swapTokensForExactTokens(
1513         amountToReceive,
1514         maxAmountToSwap,
1515         path,
1516         address(this),
1517         block.timestamp
1518       );
1519 
1520     emit Swapped(assetToSwapFrom, assetToSwapTo, amounts[0], amounts[amounts.length - 1]);
1521 
1522     return amounts[0];
1523   }
1524 
1525   /**
1526    * @dev Get the price of the asset from the oracle denominated in eth
1527    * @param asset address
1528    * @return eth price for the asset
1529    */
1530   function _getPrice(address asset) internal view returns (uint256) {
1531     return ORACLE.getAssetPrice(asset);
1532   }
1533 
1534   /**
1535    * @dev Get the decimals of an asset
1536    * @return number of decimals of the asset
1537    */
1538   function _getDecimals(address asset) internal view returns (uint256) {
1539     return IERC20Detailed(asset).decimals();
1540   }
1541 
1542   /**
1543    * @dev Get the aToken associated to the asset
1544    * @return address of the aToken
1545    */
1546   function _getReserveData(address asset) internal view returns (DataTypes.ReserveData memory) {
1547     return LENDING_POOL.getReserveData(asset);
1548   }
1549 
1550   /**
1551    * @dev Pull the ATokens from the user
1552    * @param reserve address of the asset
1553    * @param reserveAToken address of the aToken of the reserve
1554    * @param user address
1555    * @param amount of tokens to be transferred to the contract
1556    * @param permitSignature struct containing the permit signature
1557    */
1558   function _pullAToken(
1559     address reserve,
1560     address reserveAToken,
1561     address user,
1562     uint256 amount,
1563     PermitSignature memory permitSignature
1564   ) internal {
1565     if (_usePermit(permitSignature)) {
1566       IERC20WithPermit(reserveAToken).permit(
1567         user,
1568         address(this),
1569         permitSignature.amount,
1570         permitSignature.deadline,
1571         permitSignature.v,
1572         permitSignature.r,
1573         permitSignature.s
1574       );
1575     }
1576 
1577     // transfer from user to adapter
1578     IERC20(reserveAToken).safeTransferFrom(user, address(this), amount);
1579 
1580     // withdraw reserve
1581     LENDING_POOL.withdraw(reserve, amount, address(this));
1582   }
1583 
1584   /**
1585    * @dev Tells if the permit method should be called by inspecting if there is a valid signature.
1586    * If signature params are set to 0, then permit won't be called.
1587    * @param signature struct containing the permit signature
1588    * @return whether or not permit should be called
1589    */
1590   function _usePermit(PermitSignature memory signature) internal pure returns (bool) {
1591     return
1592       !(uint256(signature.deadline) == uint256(signature.v) && uint256(signature.deadline) == 0);
1593   }
1594 
1595   /**
1596    * @dev Calculates the value denominated in USD
1597    * @param reserve Address of the reserve
1598    * @param amount Amount of the reserve
1599    * @param decimals Decimals of the reserve
1600    * @return whether or not permit should be called
1601    */
1602   function _calcUsdValue(
1603     address reserve,
1604     uint256 amount,
1605     uint256 decimals
1606   ) internal view returns (uint256) {
1607     uint256 ethUsdPrice = _getPrice(USD_ADDRESS);
1608     uint256 reservePrice = _getPrice(reserve);
1609 
1610     return amount.mul(reservePrice).div(10**decimals).mul(ethUsdPrice).div(10**18);
1611   }
1612 
1613   /**
1614    * @dev Given an input asset amount, returns the maximum output amount of the other asset
1615    * @param reserveIn Address of the asset to be swap from
1616    * @param reserveOut Address of the asset to be swap to
1617    * @param amountIn Amount of reserveIn
1618    * @return Struct containing the following information:
1619    *   uint256 Amount out of the reserveOut
1620    *   uint256 The price of out amount denominated in the reserveIn currency (18 decimals)
1621    *   uint256 In amount of reserveIn value denominated in USD (8 decimals)
1622    *   uint256 Out amount of reserveOut value denominated in USD (8 decimals)
1623    */
1624   function _getAmountsOutData(
1625     address reserveIn,
1626     address reserveOut,
1627     uint256 amountIn
1628   ) internal view returns (AmountCalc memory) {
1629     // Subtract flash loan fee
1630     uint256 finalAmountIn = amountIn.sub(amountIn.mul(FLASHLOAN_PREMIUM_TOTAL).div(10000));
1631 
1632     address[] memory simplePath = new address[](2);
1633     simplePath[0] = reserveIn;
1634     simplePath[1] = reserveOut;
1635 
1636     uint256[] memory amountsWithoutWeth;
1637     uint256[] memory amountsWithWeth;
1638 
1639     address[] memory pathWithWeth = new address[](3);
1640     if (reserveIn != WETH_ADDRESS && reserveOut != WETH_ADDRESS) {
1641       pathWithWeth[0] = reserveIn;
1642       pathWithWeth[1] = WETH_ADDRESS;
1643       pathWithWeth[2] = reserveOut;
1644 
1645       try UNISWAP_ROUTER.getAmountsOut(finalAmountIn, pathWithWeth) returns (
1646         uint256[] memory resultsWithWeth
1647       ) {
1648         amountsWithWeth = resultsWithWeth;
1649       } catch {
1650         amountsWithWeth = new uint256[](3);
1651       }
1652     } else {
1653       amountsWithWeth = new uint256[](3);
1654     }
1655 
1656     uint256 bestAmountOut;
1657     try UNISWAP_ROUTER.getAmountsOut(finalAmountIn, simplePath) returns (
1658       uint256[] memory resultAmounts
1659     ) {
1660       amountsWithoutWeth = resultAmounts;
1661 
1662       bestAmountOut = (amountsWithWeth[2] > amountsWithoutWeth[1])
1663         ? amountsWithWeth[2]
1664         : amountsWithoutWeth[1];
1665     } catch {
1666       amountsWithoutWeth = new uint256[](2);
1667       bestAmountOut = amountsWithWeth[2];
1668     }
1669 
1670     uint256 reserveInDecimals = _getDecimals(reserveIn);
1671     uint256 reserveOutDecimals = _getDecimals(reserveOut);
1672 
1673     uint256 outPerInPrice =
1674       finalAmountIn.mul(10**18).mul(10**reserveOutDecimals).div(
1675         bestAmountOut.mul(10**reserveInDecimals)
1676       );
1677 
1678     return
1679       AmountCalc(
1680         bestAmountOut,
1681         outPerInPrice,
1682         _calcUsdValue(reserveIn, amountIn, reserveInDecimals),
1683         _calcUsdValue(reserveOut, bestAmountOut, reserveOutDecimals),
1684         (bestAmountOut == 0) ? new address[](2) : (bestAmountOut == amountsWithoutWeth[1])
1685           ? simplePath
1686           : pathWithWeth
1687       );
1688   }
1689 
1690   /**
1691    * @dev Returns the minimum input asset amount required to buy the given output asset amount
1692    * @param reserveIn Address of the asset to be swap from
1693    * @param reserveOut Address of the asset to be swap to
1694    * @param amountOut Amount of reserveOut
1695    * @return Struct containing the following information:
1696    *   uint256 Amount in of the reserveIn
1697    *   uint256 The price of in amount denominated in the reserveOut currency (18 decimals)
1698    *   uint256 In amount of reserveIn value denominated in USD (8 decimals)
1699    *   uint256 Out amount of reserveOut value denominated in USD (8 decimals)
1700    */
1701   function _getAmountsInData(
1702     address reserveIn,
1703     address reserveOut,
1704     uint256 amountOut
1705   ) internal view returns (AmountCalc memory) {
1706     (uint256[] memory amounts, address[] memory path) =
1707       _getAmountsInAndPath(reserveIn, reserveOut, amountOut);
1708 
1709     // Add flash loan fee
1710     uint256 finalAmountIn = amounts[0].add(amounts[0].mul(FLASHLOAN_PREMIUM_TOTAL).div(10000));
1711 
1712     uint256 reserveInDecimals = _getDecimals(reserveIn);
1713     uint256 reserveOutDecimals = _getDecimals(reserveOut);
1714 
1715     uint256 inPerOutPrice =
1716       amountOut.mul(10**18).mul(10**reserveInDecimals).div(
1717         finalAmountIn.mul(10**reserveOutDecimals)
1718       );
1719 
1720     return
1721       AmountCalc(
1722         finalAmountIn,
1723         inPerOutPrice,
1724         _calcUsdValue(reserveIn, finalAmountIn, reserveInDecimals),
1725         _calcUsdValue(reserveOut, amountOut, reserveOutDecimals),
1726         path
1727       );
1728   }
1729 
1730   /**
1731    * @dev Calculates the input asset amount required to buy the given output asset amount
1732    * @param reserveIn Address of the asset to be swap from
1733    * @param reserveOut Address of the asset to be swap to
1734    * @param amountOut Amount of reserveOut
1735    * @return uint256[] amounts Array containing the amountIn and amountOut for a swap
1736    */
1737   function _getAmountsInAndPath(
1738     address reserveIn,
1739     address reserveOut,
1740     uint256 amountOut
1741   ) internal view returns (uint256[] memory, address[] memory) {
1742     address[] memory simplePath = new address[](2);
1743     simplePath[0] = reserveIn;
1744     simplePath[1] = reserveOut;
1745 
1746     uint256[] memory amountsWithoutWeth;
1747     uint256[] memory amountsWithWeth;
1748     address[] memory pathWithWeth = new address[](3);
1749 
1750     if (reserveIn != WETH_ADDRESS && reserveOut != WETH_ADDRESS) {
1751       pathWithWeth[0] = reserveIn;
1752       pathWithWeth[1] = WETH_ADDRESS;
1753       pathWithWeth[2] = reserveOut;
1754 
1755       try UNISWAP_ROUTER.getAmountsIn(amountOut, pathWithWeth) returns (
1756         uint256[] memory resultsWithWeth
1757       ) {
1758         amountsWithWeth = resultsWithWeth;
1759       } catch {
1760         amountsWithWeth = new uint256[](3);
1761       }
1762     } else {
1763       amountsWithWeth = new uint256[](3);
1764     }
1765 
1766     try UNISWAP_ROUTER.getAmountsIn(amountOut, simplePath) returns (
1767       uint256[] memory resultAmounts
1768     ) {
1769       amountsWithoutWeth = resultAmounts;
1770 
1771       return
1772         (amountsWithWeth[2] > amountsWithoutWeth[1])
1773           ? (amountsWithWeth, pathWithWeth)
1774           : (amountsWithoutWeth, simplePath);
1775     } catch {
1776       return (amountsWithWeth, pathWithWeth);
1777     }
1778   }
1779 
1780   /**
1781    * @dev Calculates the input asset amount required to buy the given output asset amount
1782    * @param reserveIn Address of the asset to be swap from
1783    * @param reserveOut Address of the asset to be swap to
1784    * @param amountOut Amount of reserveOut
1785    * @return uint256[] amounts Array containing the amountIn and amountOut for a swap
1786    */
1787   function _getAmountsIn(
1788     address reserveIn,
1789     address reserveOut,
1790     uint256 amountOut,
1791     bool useEthPath
1792   ) internal view returns (uint256[] memory) {
1793     address[] memory path;
1794 
1795     if (useEthPath) {
1796       path = new address[](3);
1797       path[0] = reserveIn;
1798       path[1] = WETH_ADDRESS;
1799       path[2] = reserveOut;
1800     } else {
1801       path = new address[](2);
1802       path[0] = reserveIn;
1803       path[1] = reserveOut;
1804     }
1805 
1806     return UNISWAP_ROUTER.getAmountsIn(amountOut, path);
1807   }
1808 
1809   /**
1810    * @dev Emergency rescue for token stucked on this contract, as failsafe mechanism
1811    * - Funds should never remain in this contract more time than during transactions
1812    * - Only callable by the owner
1813    **/
1814   function rescueTokens(IERC20 token) external onlyOwner {
1815     token.transfer(owner(), token.balanceOf(address(this)));
1816   }
1817 }
1818 
1819 /**
1820  * @title UniswapLiquiditySwapAdapter
1821  * @notice Uniswap V2 Adapter to swap liquidity.
1822  * @author Aave
1823  **/
1824 contract UniswapLiquiditySwapAdapter is BaseUniswapAdapter {
1825   struct PermitParams {
1826     uint256[] amount;
1827     uint256[] deadline;
1828     uint8[] v;
1829     bytes32[] r;
1830     bytes32[] s;
1831   }
1832 
1833   struct SwapParams {
1834     address[] assetToSwapToList;
1835     uint256[] minAmountsToReceive;
1836     bool[] swapAllBalance;
1837     PermitParams permitParams;
1838     bool[] useEthPath;
1839   }
1840 
1841   constructor(
1842     ILendingPoolAddressesProvider addressesProvider,
1843     IUniswapV2Router02 uniswapRouter,
1844     address wethAddress
1845   ) public BaseUniswapAdapter(addressesProvider, uniswapRouter, wethAddress) {}
1846 
1847   /**
1848    * @dev Swaps the received reserve amount from the flash loan into the asset specified in the params.
1849    * The received funds from the swap are then deposited into the protocol on behalf of the user.
1850    * The user should give this contract allowance to pull the ATokens in order to withdraw the underlying asset and
1851    * repay the flash loan.
1852    * @param assets Address of asset to be swapped
1853    * @param amounts Amount of the asset to be swapped
1854    * @param premiums Fee of the flash loan
1855    * @param initiator Address of the user
1856    * @param params Additional variadic field to include extra params. Expected parameters:
1857    *   address[] assetToSwapToList List of the addresses of the reserve to be swapped to and deposited
1858    *   uint256[] minAmountsToReceive List of min amounts to be received from the swap
1859    *   bool[] swapAllBalance Flag indicating if all the user balance should be swapped
1860    *   uint256[] permitAmount List of amounts for the permit signature
1861    *   uint256[] deadline List of deadlines for the permit signature
1862    *   uint8[] v List of v param for the permit signature
1863    *   bytes32[] r List of r param for the permit signature
1864    *   bytes32[] s List of s param for the permit signature
1865    */
1866   function executeOperation(
1867     address[] calldata assets,
1868     uint256[] calldata amounts,
1869     uint256[] calldata premiums,
1870     address initiator,
1871     bytes calldata params
1872   ) external override returns (bool) {
1873     require(msg.sender == address(LENDING_POOL), 'CALLER_MUST_BE_LENDING_POOL');
1874 
1875     SwapParams memory decodedParams = _decodeParams(params);
1876 
1877     require(
1878       assets.length == decodedParams.assetToSwapToList.length &&
1879         assets.length == decodedParams.minAmountsToReceive.length &&
1880         assets.length == decodedParams.swapAllBalance.length &&
1881         assets.length == decodedParams.permitParams.amount.length &&
1882         assets.length == decodedParams.permitParams.deadline.length &&
1883         assets.length == decodedParams.permitParams.v.length &&
1884         assets.length == decodedParams.permitParams.r.length &&
1885         assets.length == decodedParams.permitParams.s.length &&
1886         assets.length == decodedParams.useEthPath.length,
1887       'INCONSISTENT_PARAMS'
1888     );
1889 
1890     for (uint256 i = 0; i < assets.length; i++) {
1891       _swapLiquidity(
1892         assets[i],
1893         decodedParams.assetToSwapToList[i],
1894         amounts[i],
1895         premiums[i],
1896         initiator,
1897         decodedParams.minAmountsToReceive[i],
1898         decodedParams.swapAllBalance[i],
1899         PermitSignature(
1900           decodedParams.permitParams.amount[i],
1901           decodedParams.permitParams.deadline[i],
1902           decodedParams.permitParams.v[i],
1903           decodedParams.permitParams.r[i],
1904           decodedParams.permitParams.s[i]
1905         ),
1906         decodedParams.useEthPath[i]
1907       );
1908     }
1909 
1910     return true;
1911   }
1912 
1913   struct SwapAndDepositLocalVars {
1914     uint256 i;
1915     uint256 aTokenInitiatorBalance;
1916     uint256 amountToSwap;
1917     uint256 receivedAmount;
1918     address aToken;
1919   }
1920 
1921   /**
1922    * @dev Swaps an amount of an asset to another and deposits the new asset amount on behalf of the user without using
1923    * a flash loan. This method can be used when the temporary transfer of the collateral asset to this contract
1924    * does not affect the user position.
1925    * The user should give this contract allowance to pull the ATokens in order to withdraw the underlying asset and
1926    * perform the swap.
1927    * @param assetToSwapFromList List of addresses of the underlying asset to be swap from
1928    * @param assetToSwapToList List of addresses of the underlying asset to be swap to and deposited
1929    * @param amountToSwapList List of amounts to be swapped. If the amount exceeds the balance, the total balance is used for the swap
1930    * @param minAmountsToReceive List of min amounts to be received from the swap
1931    * @param permitParams List of struct containing the permit signatures
1932    *   uint256 permitAmount Amount for the permit signature
1933    *   uint256 deadline Deadline for the permit signature
1934    *   uint8 v param for the permit signature
1935    *   bytes32 r param for the permit signature
1936    *   bytes32 s param for the permit signature
1937    * @param useEthPath true if the swap needs to occur using ETH in the routing, false otherwise
1938    */
1939   function swapAndDeposit(
1940     address[] calldata assetToSwapFromList,
1941     address[] calldata assetToSwapToList,
1942     uint256[] calldata amountToSwapList,
1943     uint256[] calldata minAmountsToReceive,
1944     PermitSignature[] calldata permitParams,
1945     bool[] calldata useEthPath
1946   ) external {
1947     require(
1948       assetToSwapFromList.length == assetToSwapToList.length &&
1949         assetToSwapFromList.length == amountToSwapList.length &&
1950         assetToSwapFromList.length == minAmountsToReceive.length &&
1951         assetToSwapFromList.length == permitParams.length,
1952       'INCONSISTENT_PARAMS'
1953     );
1954 
1955     SwapAndDepositLocalVars memory vars;
1956 
1957     for (vars.i = 0; vars.i < assetToSwapFromList.length; vars.i++) {
1958       vars.aToken = _getReserveData(assetToSwapFromList[vars.i]).aTokenAddress;
1959 
1960       vars.aTokenInitiatorBalance = IERC20(vars.aToken).balanceOf(msg.sender);
1961       vars.amountToSwap = amountToSwapList[vars.i] > vars.aTokenInitiatorBalance
1962         ? vars.aTokenInitiatorBalance
1963         : amountToSwapList[vars.i];
1964 
1965       _pullAToken(
1966         assetToSwapFromList[vars.i],
1967         vars.aToken,
1968         msg.sender,
1969         vars.amountToSwap,
1970         permitParams[vars.i]
1971       );
1972 
1973       vars.receivedAmount = _swapExactTokensForTokens(
1974         assetToSwapFromList[vars.i],
1975         assetToSwapToList[vars.i],
1976         vars.amountToSwap,
1977         minAmountsToReceive[vars.i],
1978         useEthPath[vars.i]
1979       );
1980 
1981       // Deposit new reserve
1982       IERC20(assetToSwapToList[vars.i]).safeApprove(address(LENDING_POOL), 0);
1983       IERC20(assetToSwapToList[vars.i]).safeApprove(address(LENDING_POOL), vars.receivedAmount);
1984       LENDING_POOL.deposit(assetToSwapToList[vars.i], vars.receivedAmount, msg.sender, 0);
1985     }
1986   }
1987 
1988   /**
1989    * @dev Swaps an `amountToSwap` of an asset to another and deposits the funds on behalf of the initiator.
1990    * @param assetFrom Address of the underlying asset to be swap from
1991    * @param assetTo Address of the underlying asset to be swap to and deposited
1992    * @param amount Amount from flash loan
1993    * @param premium Premium of the flash loan
1994    * @param minAmountToReceive Min amount to be received from the swap
1995    * @param swapAllBalance Flag indicating if all the user balance should be swapped
1996    * @param permitSignature List of struct containing the permit signature
1997    * @param useEthPath true if the swap needs to occur using ETH in the routing, false otherwise
1998    */
1999    
2000   struct SwapLiquidityLocalVars {
2001    address aToken;
2002    uint256 aTokenInitiatorBalance;
2003    uint256 amountToSwap;
2004    uint256 receivedAmount;
2005    uint256 flashLoanDebt;
2006    uint256 amountToPull;
2007   }
2008   
2009   function _swapLiquidity(
2010     address assetFrom,
2011     address assetTo,
2012     uint256 amount,
2013     uint256 premium,
2014     address initiator,
2015     uint256 minAmountToReceive,
2016     bool swapAllBalance,
2017     PermitSignature memory permitSignature,
2018     bool useEthPath
2019   ) internal {
2020     
2021     SwapLiquidityLocalVars memory vars;
2022     
2023     vars.aToken = _getReserveData(assetFrom).aTokenAddress;
2024 
2025     vars.aTokenInitiatorBalance = IERC20(vars.aToken).balanceOf(initiator);
2026     vars.amountToSwap =
2027       swapAllBalance && vars.aTokenInitiatorBalance.sub(premium) <= amount
2028         ? vars.aTokenInitiatorBalance.sub(premium)
2029         : amount;
2030 
2031     vars.receivedAmount =
2032       _swapExactTokensForTokens(assetFrom, assetTo, vars.amountToSwap, minAmountToReceive, useEthPath);
2033 
2034     // Deposit new reserve
2035     IERC20(assetTo).safeApprove(address(LENDING_POOL), 0);
2036     IERC20(assetTo).safeApprove(address(LENDING_POOL), vars.receivedAmount);
2037     LENDING_POOL.deposit(assetTo, vars.receivedAmount, initiator, 0);
2038 
2039     vars.flashLoanDebt = amount.add(premium);
2040     vars.amountToPull = vars.amountToSwap.add(premium);
2041 
2042     _pullAToken(assetFrom, vars.aToken, initiator, vars.amountToPull, permitSignature);
2043 
2044     // Repay flash loan
2045     IERC20(assetFrom).safeApprove(address(LENDING_POOL), 0);
2046     IERC20(assetFrom).safeApprove(address(LENDING_POOL), vars.flashLoanDebt);
2047   }
2048 
2049   /**
2050    * @dev Decodes the information encoded in the flash loan params
2051    * @param params Additional variadic field to include extra params. Expected parameters:
2052    *   address[] assetToSwapToList List of the addresses of the reserve to be swapped to and deposited
2053    *   uint256[] minAmountsToReceive List of min amounts to be received from the swap
2054    *   bool[] swapAllBalance Flag indicating if all the user balance should be swapped
2055    *   uint256[] permitAmount List of amounts for the permit signature
2056    *   uint256[] deadline List of deadlines for the permit signature
2057    *   uint8[] v List of v param for the permit signature
2058    *   bytes32[] r List of r param for the permit signature
2059    *   bytes32[] s List of s param for the permit signature
2060    *   bool[] useEthPath true if the swap needs to occur using ETH in the routing, false otherwise
2061    * @return SwapParams struct containing decoded params
2062    */
2063   function _decodeParams(bytes memory params) internal pure returns (SwapParams memory) {
2064     (
2065       address[] memory assetToSwapToList,
2066       uint256[] memory minAmountsToReceive,
2067       bool[] memory swapAllBalance,
2068       uint256[] memory permitAmount,
2069       uint256[] memory deadline,
2070       uint8[] memory v,
2071       bytes32[] memory r,
2072       bytes32[] memory s,
2073       bool[] memory useEthPath
2074     ) =
2075       abi.decode(
2076         params,
2077         (address[], uint256[], bool[], uint256[], uint256[], uint8[], bytes32[], bytes32[], bool[])
2078       );
2079 
2080     return
2081       SwapParams(
2082         assetToSwapToList,
2083         minAmountsToReceive,
2084         swapAllBalance,
2085         PermitParams(permitAmount, deadline, v, r, s),
2086         useEthPath
2087       );
2088   }
2089 }