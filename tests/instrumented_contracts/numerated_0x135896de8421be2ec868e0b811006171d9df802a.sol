1 // Sources flattened with hardhat v2.3.0 https://hardhat.org
2 
3 // File contracts/dependencies/openzeppelin/contracts/SafeMath.sol
4 
5 // SPDX-License-Identifier: agpl-3.0
6 pragma solidity 0.6.12;
7 
8 /**
9  * @dev Wrappers over Solidity's arithmetic operations with added overflow
10  * checks.
11  *
12  * Arithmetic operations in Solidity wrap on overflow. This can easily result
13  * in bugs, because programmers usually assume that an overflow raises an
14  * error, which is the standard behavior in high level programming languages.
15  * `SafeMath` restores this intuition by reverting the transaction when an
16  * operation overflows.
17  *
18  * Using this library instead of the unchecked operations eliminates an entire
19  * class of bugs, so it's recommended to use it always.
20  */
21 library SafeMath {
22   /**
23    * @dev Returns the addition of two unsigned integers, reverting on
24    * overflow.
25    *
26    * Counterpart to Solidity's `+` operator.
27    *
28    * Requirements:
29    * - Addition cannot overflow.
30    */
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     require(c >= a, 'SafeMath: addition overflow');
34 
35     return c;
36   }
37 
38   /**
39    * @dev Returns the subtraction of two unsigned integers, reverting on
40    * overflow (when the result is negative).
41    *
42    * Counterpart to Solidity's `-` operator.
43    *
44    * Requirements:
45    * - Subtraction cannot overflow.
46    */
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     return sub(a, b, 'SafeMath: subtraction overflow');
49   }
50 
51   /**
52    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
53    * overflow (when the result is negative).
54    *
55    * Counterpart to Solidity's `-` operator.
56    *
57    * Requirements:
58    * - Subtraction cannot overflow.
59    */
60   function sub(
61     uint256 a,
62     uint256 b,
63     string memory errorMessage
64   ) internal pure returns (uint256) {
65     require(b <= a, errorMessage);
66     uint256 c = a - b;
67 
68     return c;
69   }
70 
71   /**
72    * @dev Returns the multiplication of two unsigned integers, reverting on
73    * overflow.
74    *
75    * Counterpart to Solidity's `*` operator.
76    *
77    * Requirements:
78    * - Multiplication cannot overflow.
79    */
80   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
81     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
82     // benefit is lost if 'b' is also tested.
83     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
84     if (a == 0) {
85       return 0;
86     }
87 
88     uint256 c = a * b;
89     require(c / a == b, 'SafeMath: multiplication overflow');
90 
91     return c;
92   }
93 
94   /**
95    * @dev Returns the integer division of two unsigned integers. Reverts on
96    * division by zero. The result is rounded towards zero.
97    *
98    * Counterpart to Solidity's `/` operator. Note: this function uses a
99    * `revert` opcode (which leaves remaining gas untouched) while Solidity
100    * uses an invalid opcode to revert (consuming all remaining gas).
101    *
102    * Requirements:
103    * - The divisor cannot be zero.
104    */
105   function div(uint256 a, uint256 b) internal pure returns (uint256) {
106     return div(a, b, 'SafeMath: division by zero');
107   }
108 
109   /**
110    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111    * division by zero. The result is rounded towards zero.
112    *
113    * Counterpart to Solidity's `/` operator. Note: this function uses a
114    * `revert` opcode (which leaves remaining gas untouched) while Solidity
115    * uses an invalid opcode to revert (consuming all remaining gas).
116    *
117    * Requirements:
118    * - The divisor cannot be zero.
119    */
120   function div(
121     uint256 a,
122     uint256 b,
123     string memory errorMessage
124   ) internal pure returns (uint256) {
125     // Solidity only automatically asserts when dividing by 0
126     require(b > 0, errorMessage);
127     uint256 c = a / b;
128     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
129 
130     return c;
131   }
132 
133   /**
134    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
135    * Reverts when dividing by zero.
136    *
137    * Counterpart to Solidity's `%` operator. This function uses a `revert`
138    * opcode (which leaves remaining gas untouched) while Solidity uses an
139    * invalid opcode to revert (consuming all remaining gas).
140    *
141    * Requirements:
142    * - The divisor cannot be zero.
143    */
144   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
145     return mod(a, b, 'SafeMath: modulo by zero');
146   }
147 
148   /**
149    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
150    * Reverts with custom message when dividing by zero.
151    *
152    * Counterpart to Solidity's `%` operator. This function uses a `revert`
153    * opcode (which leaves remaining gas untouched) while Solidity uses an
154    * invalid opcode to revert (consuming all remaining gas).
155    *
156    * Requirements:
157    * - The divisor cannot be zero.
158    */
159   function mod(
160     uint256 a,
161     uint256 b,
162     string memory errorMessage
163   ) internal pure returns (uint256) {
164     require(b != 0, errorMessage);
165     return a % b;
166   }
167 }
168 
169 
170 // File contracts/dependencies/openzeppelin/contracts/IERC20.sol
171 
172 pragma solidity 0.6.12;
173 
174 /**
175  * @dev Interface of the ERC20 standard as defined in the EIP.
176  */
177 interface IERC20 {
178   /**
179    * @dev Returns the amount of tokens in existence.
180    */
181   function totalSupply() external view returns (uint256);
182 
183   /**
184    * @dev Returns the amount of tokens owned by `account`.
185    */
186   function balanceOf(address account) external view returns (uint256);
187 
188   /**
189    * @dev Moves `amount` tokens from the caller's account to `recipient`.
190    *
191    * Returns a boolean value indicating whether the operation succeeded.
192    *
193    * Emits a {Transfer} event.
194    */
195   function transfer(address recipient, uint256 amount) external returns (bool);
196 
197   /**
198    * @dev Returns the remaining number of tokens that `spender` will be
199    * allowed to spend on behalf of `owner` through {transferFrom}. This is
200    * zero by default.
201    *
202    * This value changes when {approve} or {transferFrom} are called.
203    */
204   function allowance(address owner, address spender) external view returns (uint256);
205 
206   /**
207    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
208    *
209    * Returns a boolean value indicating whether the operation succeeded.
210    *
211    * IMPORTANT: Beware that changing an allowance with this method brings the risk
212    * that someone may use both the old and the new allowance by unfortunate
213    * transaction ordering. One possible solution to mitigate this race
214    * condition is to first reduce the spender's allowance to 0 and set the
215    * desired value afterwards:
216    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
217    *
218    * Emits an {Approval} event.
219    */
220   function approve(address spender, uint256 amount) external returns (bool);
221 
222   /**
223    * @dev Moves `amount` tokens from `sender` to `recipient` using the
224    * allowance mechanism. `amount` is then deducted from the caller's
225    * allowance.
226    *
227    * Returns a boolean value indicating whether the operation succeeded.
228    *
229    * Emits a {Transfer} event.
230    */
231   function transferFrom(
232     address sender,
233     address recipient,
234     uint256 amount
235   ) external returns (bool);
236 
237   /**
238    * @dev Emitted when `value` tokens are moved from one account (`from`) to
239    * another (`to`).
240    *
241    * Note that `value` may be zero.
242    */
243   event Transfer(address indexed from, address indexed to, uint256 value);
244 
245   /**
246    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
247    * a call to {approve}. `value` is the new allowance.
248    */
249   event Approval(address indexed owner, address indexed spender, uint256 value);
250 }
251 
252 
253 // File contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
254 
255 pragma solidity 0.6.12;
256 
257 interface IERC20Detailed is IERC20 {
258   function name() external view returns (string memory);
259 
260   function symbol() external view returns (string memory);
261 
262   function decimals() external view returns (uint8);
263 }
264 
265 
266 // File contracts/dependencies/openzeppelin/contracts/Address.sol
267 
268 pragma solidity 0.6.12;
269 
270 /**
271  * @dev Collection of functions related to the address type
272  */
273 library Address {
274   /**
275    * @dev Returns true if `account` is a contract.
276    *
277    * [IMPORTANT]
278    * ====
279    * It is unsafe to assume that an address for which this function returns
280    * false is an externally-owned account (EOA) and not a contract.
281    *
282    * Among others, `isContract` will return false for the following
283    * types of addresses:
284    *
285    *  - an externally-owned account
286    *  - a contract in construction
287    *  - an address where a contract will be created
288    *  - an address where a contract lived, but was destroyed
289    * ====
290    */
291   function isContract(address account) internal view returns (bool) {
292     // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
293     // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
294     // for accounts without code, i.e. `keccak256('')`
295     bytes32 codehash;
296     bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
297     // solhint-disable-next-line no-inline-assembly
298     assembly {
299       codehash := extcodehash(account)
300     }
301     return (codehash != accountHash && codehash != 0x0);
302   }
303 
304   /**
305    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
306    * `recipient`, forwarding all available gas and reverting on errors.
307    *
308    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
309    * of certain opcodes, possibly making contracts go over the 2300 gas limit
310    * imposed by `transfer`, making them unable to receive funds via
311    * `transfer`. {sendValue} removes this limitation.
312    *
313    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
314    *
315    * IMPORTANT: because control is transferred to `recipient`, care must be
316    * taken to not create reentrancy vulnerabilities. Consider using
317    * {ReentrancyGuard} or the
318    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
319    */
320   function sendValue(address payable recipient, uint256 amount) internal {
321     require(address(this).balance >= amount, 'Address: insufficient balance');
322 
323     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
324     (bool success, ) = recipient.call{value: amount}('');
325     require(success, 'Address: unable to send value, recipient may have reverted');
326   }
327 }
328 
329 
330 // File contracts/dependencies/openzeppelin/contracts/SafeERC20.sol
331 
332 
333 pragma solidity 0.6.12;
334 
335 
336 
337 /**
338  * @title SafeERC20
339  * @dev Wrappers around ERC20 operations that throw on failure (when the token
340  * contract returns false). Tokens that return no value (and instead revert or
341  * throw on failure) are also supported, non-reverting calls are assumed to be
342  * successful.
343  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
344  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
345  */
346 library SafeERC20 {
347   using SafeMath for uint256;
348   using Address for address;
349 
350   function safeTransfer(
351     IERC20 token,
352     address to,
353     uint256 value
354   ) internal {
355     callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
356   }
357 
358   function safeTransferFrom(
359     IERC20 token,
360     address from,
361     address to,
362     uint256 value
363   ) internal {
364     callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
365   }
366 
367   function safeApprove(
368     IERC20 token,
369     address spender,
370     uint256 value
371   ) internal {
372     require(
373       (value == 0) || (token.allowance(address(this), spender) == 0),
374       'SafeERC20: approve from non-zero to non-zero allowance'
375     );
376     callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
377   }
378 
379   function callOptionalReturn(IERC20 token, bytes memory data) private {
380     require(address(token).isContract(), 'SafeERC20: call to non-contract');
381 
382     // solhint-disable-next-line avoid-low-level-calls
383     (bool success, bytes memory returndata) = address(token).call(data);
384     require(success, 'SafeERC20: low-level call failed');
385 
386     if (returndata.length > 0) {
387       // Return data is optional
388       // solhint-disable-next-line max-line-length
389       require(abi.decode(returndata, (bool)), 'SafeERC20: ERC20 operation did not succeed');
390     }
391   }
392 }
393 
394 
395 // File contracts/dependencies/openzeppelin/contracts/Context.sol
396 
397 pragma solidity 0.6.12;
398 
399 /*
400  * @dev Provides information about the current execution context, including the
401  * sender of the transaction and its data. While these are generally available
402  * via msg.sender and msg.data, they should not be accessed in such a direct
403  * manner, since when dealing with GSN meta-transactions the account sending and
404  * paying for execution may not be the actual sender (as far as an application
405  * is concerned).
406  *
407  * This contract is only required for intermediate, library-like contracts.
408  */
409 abstract contract Context {
410   function _msgSender() internal view virtual returns (address payable) {
411     return msg.sender;
412   }
413 
414   function _msgData() internal view virtual returns (bytes memory) {
415     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
416     return msg.data;
417   }
418 }
419 
420 
421 // File contracts/dependencies/openzeppelin/contracts/Ownable.sol
422 
423 
424 pragma solidity ^0.6.0;
425 
426 /**
427  * @dev Contract module which provides a basic access control mechanism, where
428  * there is an account (an owner) that can be granted exclusive access to
429  * specific functions.
430  *
431  * By default, the owner account will be the one that deploys the contract. This
432  * can later be changed with {transferOwnership}.
433  *
434  * This module is used through inheritance. It will make available the modifier
435  * `onlyOwner`, which can be applied to your functions to restrict their use to
436  * the owner.
437  */
438 contract Ownable is Context {
439   address private _owner;
440 
441   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
442 
443   /**
444    * @dev Initializes the contract setting the deployer as the initial owner.
445    */
446   constructor() internal {
447     address msgSender = _msgSender();
448     _owner = msgSender;
449     emit OwnershipTransferred(address(0), msgSender);
450   }
451 
452   /**
453    * @dev Returns the address of the current owner.
454    */
455   function owner() public view returns (address) {
456     return _owner;
457   }
458 
459   /**
460    * @dev Throws if called by any account other than the owner.
461    */
462   modifier onlyOwner() {
463     require(_owner == _msgSender(), 'Ownable: caller is not the owner');
464     _;
465   }
466 
467   /**
468    * @dev Leaves the contract without owner. It will not be possible to call
469    * `onlyOwner` functions anymore. Can only be called by the current owner.
470    *
471    * NOTE: Renouncing ownership will leave the contract without an owner,
472    * thereby removing any functionality that is only available to the owner.
473    */
474   function renounceOwnership() public virtual onlyOwner {
475     emit OwnershipTransferred(_owner, address(0));
476     _owner = address(0);
477   }
478 
479   /**
480    * @dev Transfers ownership of the contract to a new account (`newOwner`).
481    * Can only be called by the current owner.
482    */
483   function transferOwnership(address newOwner) public virtual onlyOwner {
484     require(newOwner != address(0), 'Ownable: new owner is the zero address');
485     emit OwnershipTransferred(_owner, newOwner);
486     _owner = newOwner;
487   }
488 }
489 
490 
491 // File contracts/interfaces/ILendingPoolAddressesProvider.sol
492 
493 pragma solidity 0.6.12;
494 
495 /**
496  * @title LendingPoolAddressesProvider contract
497  * @dev Main registry of addresses part of or connected to the protocol, including permissioned roles
498  * - Acting also as factory of proxies and admin of those, so with right to change its implementations
499  * - Owned by the Aave Governance
500  * @author Aave
501  **/
502 interface ILendingPoolAddressesProvider {
503   event MarketIdSet(string newMarketId);
504   event LendingPoolUpdated(address indexed newAddress);
505   event ConfigurationAdminUpdated(address indexed newAddress);
506   event EmergencyAdminUpdated(address indexed newAddress);
507   event LendingPoolConfiguratorUpdated(address indexed newAddress);
508   event LendingPoolCollateralManagerUpdated(address indexed newAddress);
509   event PriceOracleUpdated(address indexed newAddress);
510   event LendingRateOracleUpdated(address indexed newAddress);
511   event ProxyCreated(bytes32 id, address indexed newAddress);
512   event AddressSet(bytes32 id, address indexed newAddress, bool hasProxy);
513 
514   function getMarketId() external view returns (string memory);
515 
516   function setMarketId(string calldata marketId) external;
517 
518   function setAddress(bytes32 id, address newAddress) external;
519 
520   function setAddressAsProxy(bytes32 id, address impl) external;
521 
522   function getAddress(bytes32 id) external view returns (address);
523 
524   function getLendingPool() external view returns (address);
525 
526   function setLendingPoolImpl(address pool) external;
527 
528   function getLendingPoolConfigurator() external view returns (address);
529 
530   function setLendingPoolConfiguratorImpl(address configurator) external;
531 
532   function getLendingPoolCollateralManager() external view returns (address);
533 
534   function setLendingPoolCollateralManager(address manager) external;
535 
536   function getPoolAdmin() external view returns (address);
537 
538   function setPoolAdmin(address admin) external;
539 
540   function getEmergencyAdmin() external view returns (address);
541 
542   function setEmergencyAdmin(address admin) external;
543 
544   function getPriceOracle() external view returns (address);
545 
546   function setPriceOracle(address priceOracle) external;
547 
548   function getLendingRateOracle() external view returns (address);
549 
550   function setLendingRateOracle(address lendingRateOracle) external;
551 }
552 
553 
554 // File contracts/protocol/libraries/types/DataTypes.sol
555 
556 pragma solidity 0.6.12;
557 
558 library DataTypes {
559   // refer to the whitepaper, section 1.1 basic concepts for a formal description of these properties.
560   struct ReserveData {
561     //stores the reserve configuration
562     ReserveConfigurationMap configuration;
563     //the liquidity index. Expressed in ray
564     uint128 liquidityIndex;
565     //variable borrow index. Expressed in ray
566     uint128 variableBorrowIndex;
567     //the current supply rate. Expressed in ray
568     uint128 currentLiquidityRate;
569     //the current variable borrow rate. Expressed in ray
570     uint128 currentVariableBorrowRate;
571     //the current stable borrow rate. Expressed in ray
572     uint128 currentStableBorrowRate;
573     uint40 lastUpdateTimestamp;
574     //tokens addresses
575     address aTokenAddress;
576     address stableDebtTokenAddress;
577     address variableDebtTokenAddress;
578     //address of the interest rate strategy
579     address interestRateStrategyAddress;
580     //the id of the reserve. Represents the position in the list of the active reserves
581     uint8 id;
582   }
583 
584   struct ReserveConfigurationMap {
585     //bit 0-15: LTV
586     //bit 16-31: Liq. threshold
587     //bit 32-47: Liq. bonus
588     //bit 48-55: Decimals
589     //bit 56: Reserve is active
590     //bit 57: reserve is frozen
591     //bit 58: borrowing is enabled
592     //bit 59: stable rate borrowing enabled
593     //bit 60-63: reserved
594     //bit 64-79: reserve factor
595     uint256 data;
596   }
597 
598   struct UserConfigurationMap {
599     uint256 data;
600   }
601 
602   enum InterestRateMode {NONE, STABLE, VARIABLE}
603 }
604 
605 
606 // File contracts/interfaces/IPriceOracleGetter.sol
607 
608 pragma solidity 0.6.12;
609 
610 /**
611  * @title IPriceOracleGetter interface
612  * @notice Interface for the Aave price oracle.
613  **/
614 
615 interface IPriceOracleGetter {
616   /**
617    * @dev returns the asset price in ETH
618    * @param asset the address of the asset
619    * @return the ETH price of the asset
620    **/
621   function getAssetPrice(address asset) external view returns (uint256);
622 }
623 
624 
625 // File contracts/interfaces/IERC20WithPermit.sol
626 
627 pragma solidity 0.6.12;
628 
629 interface IERC20WithPermit is IERC20 {
630   function permit(
631     address owner,
632     address spender,
633     uint256 value,
634     uint256 deadline,
635     uint8 v,
636     bytes32 r,
637     bytes32 s
638   ) external;
639 }
640 
641 
642 // File contracts/interfaces/ILendingPool.sol
643 
644 pragma solidity 0.6.12;
645 pragma experimental ABIEncoderV2;
646 
647 
648 interface ILendingPool {
649   /**
650    * @dev Emitted on deposit()
651    * @param reserve The address of the underlying asset of the reserve
652    * @param user The address initiating the deposit
653    * @param onBehalfOf The beneficiary of the deposit, receiving the aTokens
654    * @param amount The amount deposited
655    * @param referral The referral code used
656    **/
657   event Deposit(
658     address indexed reserve,
659     address user,
660     address indexed onBehalfOf,
661     uint256 amount,
662     uint16 indexed referral
663   );
664 
665   /**
666    * @dev Emitted on withdraw()
667    * @param reserve The address of the underlyng asset being withdrawn
668    * @param user The address initiating the withdrawal, owner of aTokens
669    * @param to Address that will receive the underlying
670    * @param amount The amount to be withdrawn
671    **/
672   event Withdraw(address indexed reserve, address indexed user, address indexed to, uint256 amount);
673 
674   /**
675    * @dev Emitted on borrow() and flashLoan() when debt needs to be opened
676    * @param reserve The address of the underlying asset being borrowed
677    * @param user The address of the user initiating the borrow(), receiving the funds on borrow() or just
678    * initiator of the transaction on flashLoan()
679    * @param onBehalfOf The address that will be getting the debt
680    * @param amount The amount borrowed out
681    * @param borrowRateMode The rate mode: 1 for Stable, 2 for Variable
682    * @param borrowRate The numeric rate at which the user has borrowed
683    * @param referral The referral code used
684    **/
685   event Borrow(
686     address indexed reserve,
687     address user,
688     address indexed onBehalfOf,
689     uint256 amount,
690     uint256 borrowRateMode,
691     uint256 borrowRate,
692     uint16 indexed referral
693   );
694 
695   /**
696    * @dev Emitted on repay()
697    * @param reserve The address of the underlying asset of the reserve
698    * @param user The beneficiary of the repayment, getting his debt reduced
699    * @param repayer The address of the user initiating the repay(), providing the funds
700    * @param amount The amount repaid
701    **/
702   event Repay(
703     address indexed reserve,
704     address indexed user,
705     address indexed repayer,
706     uint256 amount
707   );
708 
709   /**
710    * @dev Emitted on swapBorrowRateMode()
711    * @param reserve The address of the underlying asset of the reserve
712    * @param user The address of the user swapping his rate mode
713    * @param rateMode The rate mode that the user wants to swap to
714    **/
715   event Swap(address indexed reserve, address indexed user, uint256 rateMode);
716 
717   /**
718    * @dev Emitted on setUserUseReserveAsCollateral()
719    * @param reserve The address of the underlying asset of the reserve
720    * @param user The address of the user enabling the usage as collateral
721    **/
722   event ReserveUsedAsCollateralEnabled(address indexed reserve, address indexed user);
723 
724   /**
725    * @dev Emitted on setUserUseReserveAsCollateral()
726    * @param reserve The address of the underlying asset of the reserve
727    * @param user The address of the user enabling the usage as collateral
728    **/
729   event ReserveUsedAsCollateralDisabled(address indexed reserve, address indexed user);
730 
731   /**
732    * @dev Emitted on rebalanceStableBorrowRate()
733    * @param reserve The address of the underlying asset of the reserve
734    * @param user The address of the user for which the rebalance has been executed
735    **/
736   event RebalanceStableBorrowRate(address indexed reserve, address indexed user);
737 
738   /**
739    * @dev Emitted on flashLoan()
740    * @param target The address of the flash loan receiver contract
741    * @param initiator The address initiating the flash loan
742    * @param asset The address of the asset being flash borrowed
743    * @param amount The amount flash borrowed
744    * @param premium The fee flash borrowed
745    * @param referralCode The referral code used
746    **/
747   event FlashLoan(
748     address indexed target,
749     address indexed initiator,
750     address indexed asset,
751     uint256 amount,
752     uint256 premium,
753     uint16 referralCode
754   );
755 
756   /**
757    * @dev Emitted when the pause is triggered.
758    */
759   event Paused();
760 
761   /**
762    * @dev Emitted when the pause is lifted.
763    */
764   event Unpaused();
765 
766   /**
767    * @dev Emitted when a borrower is liquidated. This event is emitted by the LendingPool via
768    * LendingPoolCollateral manager using a DELEGATECALL
769    * This allows to have the events in the generated ABI for LendingPool.
770    * @param collateralAsset The address of the underlying asset used as collateral, to receive as result of the liquidation
771    * @param debtAsset The address of the underlying borrowed asset to be repaid with the liquidation
772    * @param user The address of the borrower getting liquidated
773    * @param debtToCover The debt amount of borrowed `asset` the liquidator wants to cover
774    * @param liquidatedCollateralAmount The amount of collateral received by the liiquidator
775    * @param liquidator The address of the liquidator
776    * @param receiveAToken `true` if the liquidators wants to receive the collateral aTokens, `false` if he wants
777    * to receive the underlying collateral asset directly
778    **/
779   event LiquidationCall(
780     address indexed collateralAsset,
781     address indexed debtAsset,
782     address indexed user,
783     uint256 debtToCover,
784     uint256 liquidatedCollateralAmount,
785     address liquidator,
786     bool receiveAToken
787   );
788 
789   /**
790    * @dev Emitted when the state of a reserve is updated. NOTE: This event is actually declared
791    * in the ReserveLogic library and emitted in the updateInterestRates() function. Since the function is internal,
792    * the event will actually be fired by the LendingPool contract. The event is therefore replicated here so it
793    * gets added to the LendingPool ABI
794    * @param reserve The address of the underlying asset of the reserve
795    * @param liquidityRate The new liquidity rate
796    * @param stableBorrowRate The new stable borrow rate
797    * @param variableBorrowRate The new variable borrow rate
798    * @param liquidityIndex The new liquidity index
799    * @param variableBorrowIndex The new variable borrow index
800    **/
801   event ReserveDataUpdated(
802     address indexed reserve,
803     uint256 liquidityRate,
804     uint256 stableBorrowRate,
805     uint256 variableBorrowRate,
806     uint256 liquidityIndex,
807     uint256 variableBorrowIndex
808   );
809 
810   /**
811    * @dev Deposits an `amount` of underlying asset into the reserve, receiving in return overlying aTokens.
812    * - E.g. User deposits 100 USDC and gets in return 100 aUSDC
813    * @param asset The address of the underlying asset to deposit
814    * @param amount The amount to be deposited
815    * @param onBehalfOf The address that will receive the aTokens, same as msg.sender if the user
816    *   wants to receive them on his own wallet, or a different address if the beneficiary of aTokens
817    *   is a different wallet
818    * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
819    *   0 if the action is executed directly by the user, without any middle-man
820    **/
821   function deposit(
822     address asset,
823     uint256 amount,
824     address onBehalfOf,
825     uint16 referralCode
826   ) external;
827 
828   /**
829    * @dev Withdraws an `amount` of underlying asset from the reserve, burning the equivalent aTokens owned
830    * E.g. User has 100 aUSDC, calls withdraw() and receives 100 USDC, burning the 100 aUSDC
831    * @param asset The address of the underlying asset to withdraw
832    * @param amount The underlying amount to be withdrawn
833    *   - Send the value type(uint256).max in order to withdraw the whole aToken balance
834    * @param to Address that will receive the underlying, same as msg.sender if the user
835    *   wants to receive it on his own wallet, or a different address if the beneficiary is a
836    *   different wallet
837    * @return The final amount withdrawn
838    **/
839   function withdraw(
840     address asset,
841     uint256 amount,
842     address to
843   ) external returns (uint256);
844 
845   /**
846    * @dev Allows users to borrow a specific `amount` of the reserve underlying asset, provided that the borrower
847    * already deposited enough collateral, or he was given enough allowance by a credit delegator on the
848    * corresponding debt token (StableDebtToken or VariableDebtToken)
849    * - E.g. User borrows 100 USDC passing as `onBehalfOf` his own address, receiving the 100 USDC in his wallet
850    *   and 100 stable/variable debt tokens, depending on the `interestRateMode`
851    * @param asset The address of the underlying asset to borrow
852    * @param amount The amount to be borrowed
853    * @param interestRateMode The interest rate mode at which the user wants to borrow: 1 for Stable, 2 for Variable
854    * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
855    *   0 if the action is executed directly by the user, without any middle-man
856    * @param onBehalfOf Address of the user who will receive the debt. Should be the address of the borrower itself
857    * calling the function if he wants to borrow against his own collateral, or the address of the credit delegator
858    * if he has been given credit delegation allowance
859    **/
860   function borrow(
861     address asset,
862     uint256 amount,
863     uint256 interestRateMode,
864     uint16 referralCode,
865     address onBehalfOf
866   ) external;
867 
868   /**
869    * @notice Repays a borrowed `amount` on a specific reserve, burning the equivalent debt tokens owned
870    * - E.g. User repays 100 USDC, burning 100 variable/stable debt tokens of the `onBehalfOf` address
871    * @param asset The address of the borrowed underlying asset previously borrowed
872    * @param amount The amount to repay
873    * - Send the value type(uint256).max in order to repay the whole debt for `asset` on the specific `debtMode`
874    * @param rateMode The interest rate mode at of the debt the user wants to repay: 1 for Stable, 2 for Variable
875    * @param onBehalfOf Address of the user who will get his debt reduced/removed. Should be the address of the
876    * user calling the function if he wants to reduce/remove his own debt, or the address of any other
877    * other borrower whose debt should be removed
878    * @return The final amount repaid
879    **/
880   function repay(
881     address asset,
882     uint256 amount,
883     uint256 rateMode,
884     address onBehalfOf
885   ) external returns (uint256);
886 
887   /**
888    * @dev Allows a borrower to swap his debt between stable and variable mode, or viceversa
889    * @param asset The address of the underlying asset borrowed
890    * @param rateMode The rate mode that the user wants to swap to
891    **/
892   function swapBorrowRateMode(address asset, uint256 rateMode) external;
893 
894   /**
895    * @dev Rebalances the stable interest rate of a user to the current stable rate defined on the reserve.
896    * - Users can be rebalanced if the following conditions are satisfied:
897    *     1. Usage ratio is above 95%
898    *     2. the current deposit APY is below REBALANCE_UP_THRESHOLD * maxVariableBorrowRate, which means that too much has been
899    *        borrowed at a stable rate and depositors are not earning enough
900    * @param asset The address of the underlying asset borrowed
901    * @param user The address of the user to be rebalanced
902    **/
903   function rebalanceStableBorrowRate(address asset, address user) external;
904 
905   /**
906    * @dev Allows depositors to enable/disable a specific deposited asset as collateral
907    * @param asset The address of the underlying asset deposited
908    * @param useAsCollateral `true` if the user wants to use the deposit as collateral, `false` otherwise
909    **/
910   function setUserUseReserveAsCollateral(address asset, bool useAsCollateral) external;
911 
912   /**
913    * @dev Function to liquidate a non-healthy position collateral-wise, with Health Factor below 1
914    * - The caller (liquidator) covers `debtToCover` amount of debt of the user getting liquidated, and receives
915    *   a proportionally amount of the `collateralAsset` plus a bonus to cover market risk
916    * @param collateralAsset The address of the underlying asset used as collateral, to receive as result of the liquidation
917    * @param debtAsset The address of the underlying borrowed asset to be repaid with the liquidation
918    * @param user The address of the borrower getting liquidated
919    * @param debtToCover The debt amount of borrowed `asset` the liquidator wants to cover
920    * @param receiveAToken `true` if the liquidators wants to receive the collateral aTokens, `false` if he wants
921    * to receive the underlying collateral asset directly
922    **/
923   function liquidationCall(
924     address collateralAsset,
925     address debtAsset,
926     address user,
927     uint256 debtToCover,
928     bool receiveAToken
929   ) external;
930 
931   /**
932    * @dev Allows smartcontracts to access the liquidity of the pool within one transaction,
933    * as long as the amount taken plus a fee is returned.
934    * IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept into consideration.
935    * For further details please visit https://developers.aave.com
936    * @param receiverAddress The address of the contract receiving the funds, implementing the IFlashLoanReceiver interface
937    * @param assets The addresses of the assets being flash-borrowed
938    * @param amounts The amounts amounts being flash-borrowed
939    * @param modes Types of the debt to open if the flash loan is not returned:
940    *   0 -> Don't open any debt, just revert if funds can't be transferred from the receiver
941    *   1 -> Open debt at stable rate for the value of the amount flash-borrowed to the `onBehalfOf` address
942    *   2 -> Open debt at variable rate for the value of the amount flash-borrowed to the `onBehalfOf` address
943    * @param onBehalfOf The address  that will receive the debt in the case of using on `modes` 1 or 2
944    * @param params Variadic packed params to pass to the receiver as extra information
945    * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
946    *   0 if the action is executed directly by the user, without any middle-man
947    **/
948   function flashLoan(
949     address receiverAddress,
950     address[] calldata assets,
951     uint256[] calldata amounts,
952     uint256[] calldata modes,
953     address onBehalfOf,
954     bytes calldata params,
955     uint16 referralCode
956   ) external;
957 
958   /**
959    * @dev Returns the user account data across all the reserves
960    * @param user The address of the user
961    * @return totalCollateralETH the total collateral in ETH of the user
962    * @return totalDebtETH the total debt in ETH of the user
963    * @return availableBorrowsETH the borrowing power left of the user
964    * @return currentLiquidationThreshold the liquidation threshold of the user
965    * @return ltv the loan to value of the user
966    * @return healthFactor the current health factor of the user
967    **/
968   function getUserAccountData(address user)
969     external
970     view
971     returns (
972       uint256 totalCollateralETH,
973       uint256 totalDebtETH,
974       uint256 availableBorrowsETH,
975       uint256 currentLiquidationThreshold,
976       uint256 ltv,
977       uint256 healthFactor
978     );
979 
980   function initReserve(
981     address reserve,
982     address aTokenAddress,
983     address stableDebtAddress,
984     address variableDebtAddress,
985     address interestRateStrategyAddress
986   ) external;
987 
988   function setReserveInterestRateStrategyAddress(address reserve, address rateStrategyAddress)
989     external;
990 
991   function setConfiguration(address reserve, uint256 configuration) external;
992 
993   /**
994    * @dev Returns the configuration of the reserve
995    * @param asset The address of the underlying asset of the reserve
996    * @return The configuration of the reserve
997    **/
998   function getConfiguration(address asset)
999     external
1000     view
1001     returns (DataTypes.ReserveConfigurationMap memory);
1002 
1003   /**
1004    * @dev Returns the configuration of the user across all the reserves
1005    * @param user The user address
1006    * @return The configuration of the user
1007    **/
1008   function getUserConfiguration(address user)
1009     external
1010     view
1011     returns (DataTypes.UserConfigurationMap memory);
1012 
1013   /**
1014    * @dev Returns the normalized income normalized income of the reserve
1015    * @param asset The address of the underlying asset of the reserve
1016    * @return The reserve's normalized income
1017    */
1018   function getReserveNormalizedIncome(address asset) external view returns (uint256);
1019 
1020   /**
1021    * @dev Returns the normalized variable debt per unit of asset
1022    * @param asset The address of the underlying asset of the reserve
1023    * @return The reserve normalized variable debt
1024    */
1025   function getReserveNormalizedVariableDebt(address asset) external view returns (uint256);
1026 
1027   /**
1028    * @dev Returns the state and configuration of the reserve
1029    * @param asset The address of the underlying asset of the reserve
1030    * @return The state of the reserve
1031    **/
1032   function getReserveData(address asset) external view returns (DataTypes.ReserveData memory);
1033 
1034   function finalizeTransfer(
1035     address asset,
1036     address from,
1037     address to,
1038     uint256 amount,
1039     uint256 balanceFromAfter,
1040     uint256 balanceToBefore
1041   ) external;
1042 
1043   function getReservesList() external view returns (address[] memory);
1044 
1045   function getAddressesProvider() external view returns (ILendingPoolAddressesProvider);
1046 
1047   function setPause(bool val) external;
1048 
1049   function paused() external view returns (bool);
1050 }
1051 
1052 
1053 // File contracts/flashloan/interfaces/IFlashLoanReceiver.sol
1054 
1055 pragma solidity 0.6.12;
1056 
1057 
1058 /**
1059  * @title IFlashLoanReceiver interface
1060  * @notice Interface for the Aave fee IFlashLoanReceiver.
1061  * @author Aave
1062  * @dev implement this interface to develop a flashloan-compatible flashLoanReceiver contract
1063  **/
1064 interface IFlashLoanReceiver {
1065   function executeOperation(
1066     address[] calldata assets,
1067     uint256[] calldata amounts,
1068     uint256[] calldata premiums,
1069     address initiator,
1070     bytes calldata params
1071   ) external returns (bool);
1072 
1073   function ADDRESSES_PROVIDER() external view returns (ILendingPoolAddressesProvider);
1074 
1075   function LENDING_POOL() external view returns (ILendingPool);
1076 }
1077 
1078 
1079 // File contracts/flashloan/base/FlashLoanReceiverBase.sol
1080 
1081 pragma solidity 0.6.12;
1082 
1083 
1084 
1085 
1086 
1087 
1088 abstract contract FlashLoanReceiverBase is IFlashLoanReceiver {
1089   using SafeERC20 for IERC20;
1090   using SafeMath for uint256;
1091 
1092   ILendingPoolAddressesProvider public immutable override ADDRESSES_PROVIDER;
1093   ILendingPool public immutable override LENDING_POOL;
1094 
1095   constructor(ILendingPoolAddressesProvider provider) public {
1096     ADDRESSES_PROVIDER = provider;
1097     LENDING_POOL = ILendingPool(provider.getLendingPool());
1098   }
1099 }
1100 
1101 
1102 // File contracts/adapters/BaseParaSwapAdapter.sol
1103 
1104 pragma solidity 0.6.12;
1105 
1106 
1107 
1108 
1109 
1110 
1111 
1112 
1113 
1114 
1115 /**
1116  * @title BaseParaSwapAdapter
1117  * @notice Utility functions for adapters using ParaSwap
1118  * @author Jason Raymond Bell
1119  */
1120 abstract contract BaseParaSwapAdapter is FlashLoanReceiverBase, Ownable {
1121   using SafeMath for uint256;
1122   using SafeERC20 for IERC20;
1123   using SafeERC20 for IERC20Detailed;
1124   using SafeERC20 for IERC20WithPermit;
1125 
1126   struct PermitSignature {
1127     uint256 amount;
1128     uint256 deadline;
1129     uint8 v;
1130     bytes32 r;
1131     bytes32 s;
1132   }
1133 
1134   // Max slippage percent allowed
1135   uint256 public constant MAX_SLIPPAGE_PERCENT = 3000; // 30%
1136 
1137   IPriceOracleGetter public immutable ORACLE;
1138 
1139   event Swapped(address indexed fromAsset, address indexed toAsset, uint256 fromAmount, uint256 receivedAmount);
1140 
1141   constructor(
1142     ILendingPoolAddressesProvider addressesProvider
1143   ) public FlashLoanReceiverBase(addressesProvider) {
1144     ORACLE = IPriceOracleGetter(addressesProvider.getPriceOracle());
1145   }
1146 
1147   /**
1148    * @dev Get the price of the asset from the oracle denominated in eth
1149    * @param asset address
1150    * @return eth price for the asset
1151    */
1152   function _getPrice(address asset) internal view returns (uint256) {
1153     return ORACLE.getAssetPrice(asset);
1154   }
1155 
1156   /**
1157    * @dev Get the decimals of an asset
1158    * @return number of decimals of the asset
1159    */
1160   function _getDecimals(IERC20Detailed asset) internal view returns (uint8) {
1161     uint8 decimals = asset.decimals();
1162     // Ensure 10**decimals won't overflow a uint256
1163     require(decimals <= 77, 'TOO_MANY_DECIMALS_ON_TOKEN');
1164     return decimals;
1165   }
1166 
1167   /**
1168    * @dev Get the aToken associated to the asset
1169    * @return address of the aToken
1170    */
1171   function _getReserveData(address asset) internal view returns (DataTypes.ReserveData memory) {
1172     return LENDING_POOL.getReserveData(asset);
1173   }
1174 
1175   /**
1176    * @dev Pull the ATokens from the user
1177    * @param reserve address of the asset
1178    * @param reserveAToken address of the aToken of the reserve
1179    * @param user address
1180    * @param amount of tokens to be transferred to the contract
1181    * @param permitSignature struct containing the permit signature
1182    */
1183   function _pullATokenAndWithdraw(
1184     address reserve,
1185     IERC20WithPermit reserveAToken,
1186     address user,
1187     uint256 amount,
1188     PermitSignature memory permitSignature
1189   ) internal {
1190     // If deadline is set to zero, assume there is no signature for permit
1191     if (permitSignature.deadline != 0) {
1192       reserveAToken.permit(
1193         user,
1194         address(this),
1195         permitSignature.amount,
1196         permitSignature.deadline,
1197         permitSignature.v,
1198         permitSignature.r,
1199         permitSignature.s
1200       );
1201     }
1202 
1203     // transfer from user to adapter
1204     reserveAToken.safeTransferFrom(user, address(this), amount);
1205 
1206     // withdraw reserve
1207     require(
1208       LENDING_POOL.withdraw(reserve, amount, address(this)) == amount,
1209       'UNEXPECTED_AMOUNT_WITHDRAWN'
1210     );
1211   }
1212 
1213   /**
1214    * @dev Emergency rescue for token stucked on this contract, as failsafe mechanism
1215    * - Funds should never remain in this contract more time than during transactions
1216    * - Only callable by the owner
1217    */
1218   function rescueTokens(IERC20 token) external onlyOwner {
1219     token.safeTransfer(owner(), token.balanceOf(address(this)));
1220   }
1221 }
1222 
1223 
1224 // File contracts/protocol/libraries/helpers/Errors.sol
1225 
1226 pragma solidity 0.6.12;
1227 
1228 /**
1229  * @title Errors library
1230  * @author Aave
1231  * @notice Defines the error messages emitted by the different contracts of the Aave protocol
1232  * @dev Error messages prefix glossary:
1233  *  - VL = ValidationLogic
1234  *  - MATH = Math libraries
1235  *  - CT = Common errors between tokens (AToken, VariableDebtToken and StableDebtToken)
1236  *  - AT = AToken
1237  *  - SDT = StableDebtToken
1238  *  - VDT = VariableDebtToken
1239  *  - LP = LendingPool
1240  *  - LPAPR = LendingPoolAddressesProviderRegistry
1241  *  - LPC = LendingPoolConfiguration
1242  *  - RL = ReserveLogic
1243  *  - LPCM = LendingPoolCollateralManager
1244  *  - P = Pausable
1245  */
1246 library Errors {
1247   //common errors
1248   string public constant CALLER_NOT_POOL_ADMIN = '33'; // 'The caller must be the pool admin'
1249   string public constant BORROW_ALLOWANCE_NOT_ENOUGH = '59'; // User borrows on behalf, but allowance are too small
1250 
1251   //contract specific errors
1252   string public constant VL_INVALID_AMOUNT = '1'; // 'Amount must be greater than 0'
1253   string public constant VL_NO_ACTIVE_RESERVE = '2'; // 'Action requires an active reserve'
1254   string public constant VL_RESERVE_FROZEN = '3'; // 'Action cannot be performed because the reserve is frozen'
1255   string public constant VL_CURRENT_AVAILABLE_LIQUIDITY_NOT_ENOUGH = '4'; // 'The current liquidity is not enough'
1256   string public constant VL_NOT_ENOUGH_AVAILABLE_USER_BALANCE = '5'; // 'User cannot withdraw more than the available balance'
1257   string public constant VL_TRANSFER_NOT_ALLOWED = '6'; // 'Transfer cannot be allowed.'
1258   string public constant VL_BORROWING_NOT_ENABLED = '7'; // 'Borrowing is not enabled'
1259   string public constant VL_INVALID_INTEREST_RATE_MODE_SELECTED = '8'; // 'Invalid interest rate mode selected'
1260   string public constant VL_COLLATERAL_BALANCE_IS_0 = '9'; // 'The collateral balance is 0'
1261   string public constant VL_HEALTH_FACTOR_LOWER_THAN_LIQUIDATION_THRESHOLD = '10'; // 'Health factor is lesser than the liquidation threshold'
1262   string public constant VL_COLLATERAL_CANNOT_COVER_NEW_BORROW = '11'; // 'There is not enough collateral to cover a new borrow'
1263   string public constant VL_STABLE_BORROWING_NOT_ENABLED = '12'; // stable borrowing not enabled
1264   string public constant VL_COLLATERAL_SAME_AS_BORROWING_CURRENCY = '13'; // collateral is (mostly) the same currency that is being borrowed
1265   string public constant VL_AMOUNT_BIGGER_THAN_MAX_LOAN_SIZE_STABLE = '14'; // 'The requested amount is greater than the max loan size in stable rate mode
1266   string public constant VL_NO_DEBT_OF_SELECTED_TYPE = '15'; // 'for repayment of stable debt, the user needs to have stable debt, otherwise, he needs to have variable debt'
1267   string public constant VL_NO_EXPLICIT_AMOUNT_TO_REPAY_ON_BEHALF = '16'; // 'To repay on behalf of an user an explicit amount to repay is needed'
1268   string public constant VL_NO_STABLE_RATE_LOAN_IN_RESERVE = '17'; // 'User does not have a stable rate loan in progress on this reserve'
1269   string public constant VL_NO_VARIABLE_RATE_LOAN_IN_RESERVE = '18'; // 'User does not have a variable rate loan in progress on this reserve'
1270   string public constant VL_UNDERLYING_BALANCE_NOT_GREATER_THAN_0 = '19'; // 'The underlying balance needs to be greater than 0'
1271   string public constant VL_DEPOSIT_ALREADY_IN_USE = '20'; // 'User deposit is already being used as collateral'
1272   string public constant LP_NOT_ENOUGH_STABLE_BORROW_BALANCE = '21'; // 'User does not have any stable rate loan for this reserve'
1273   string public constant LP_INTEREST_RATE_REBALANCE_CONDITIONS_NOT_MET = '22'; // 'Interest rate rebalance conditions were not met'
1274   string public constant LP_LIQUIDATION_CALL_FAILED = '23'; // 'Liquidation call failed'
1275   string public constant LP_NOT_ENOUGH_LIQUIDITY_TO_BORROW = '24'; // 'There is not enough liquidity available to borrow'
1276   string public constant LP_REQUESTED_AMOUNT_TOO_SMALL = '25'; // 'The requested amount is too small for a FlashLoan.'
1277   string public constant LP_INCONSISTENT_PROTOCOL_ACTUAL_BALANCE = '26'; // 'The actual balance of the protocol is inconsistent'
1278   string public constant LP_CALLER_NOT_LENDING_POOL_CONFIGURATOR = '27'; // 'The caller of the function is not the lending pool configurator'
1279   string public constant LP_INCONSISTENT_FLASHLOAN_PARAMS = '28';
1280   string public constant CT_CALLER_MUST_BE_LENDING_POOL = '29'; // 'The caller of this function must be a lending pool'
1281   string public constant CT_CANNOT_GIVE_ALLOWANCE_TO_HIMSELF = '30'; // 'User cannot give allowance to himself'
1282   string public constant CT_TRANSFER_AMOUNT_NOT_GT_0 = '31'; // 'Transferred amount needs to be greater than zero'
1283   string public constant RL_RESERVE_ALREADY_INITIALIZED = '32'; // 'Reserve has already been initialized'
1284   string public constant LPC_RESERVE_LIQUIDITY_NOT_0 = '34'; // 'The liquidity of the reserve needs to be 0'
1285   string public constant LPC_INVALID_ATOKEN_POOL_ADDRESS = '35'; // 'The liquidity of the reserve needs to be 0'
1286   string public constant LPC_INVALID_STABLE_DEBT_TOKEN_POOL_ADDRESS = '36'; // 'The liquidity of the reserve needs to be 0'
1287   string public constant LPC_INVALID_VARIABLE_DEBT_TOKEN_POOL_ADDRESS = '37'; // 'The liquidity of the reserve needs to be 0'
1288   string public constant LPC_INVALID_STABLE_DEBT_TOKEN_UNDERLYING_ADDRESS = '38'; // 'The liquidity of the reserve needs to be 0'
1289   string public constant LPC_INVALID_VARIABLE_DEBT_TOKEN_UNDERLYING_ADDRESS = '39'; // 'The liquidity of the reserve needs to be 0'
1290   string public constant LPC_INVALID_ADDRESSES_PROVIDER_ID = '40'; // 'The liquidity of the reserve needs to be 0'
1291   string public constant LPC_INVALID_CONFIGURATION = '75'; // 'Invalid risk parameters for the reserve'
1292   string public constant LPC_CALLER_NOT_EMERGENCY_ADMIN = '76'; // 'The caller must be the emergency admin'
1293   string public constant LPAPR_PROVIDER_NOT_REGISTERED = '41'; // 'Provider is not registered'
1294   string public constant LPCM_HEALTH_FACTOR_NOT_BELOW_THRESHOLD = '42'; // 'Health factor is not below the threshold'
1295   string public constant LPCM_COLLATERAL_CANNOT_BE_LIQUIDATED = '43'; // 'The collateral chosen cannot be liquidated'
1296   string public constant LPCM_SPECIFIED_CURRENCY_NOT_BORROWED_BY_USER = '44'; // 'User did not borrow the specified currency'
1297   string public constant LPCM_NOT_ENOUGH_LIQUIDITY_TO_LIQUIDATE = '45'; // "There isn't enough liquidity available to liquidate"
1298   string public constant LPCM_NO_ERRORS = '46'; // 'No errors'
1299   string public constant LP_INVALID_FLASHLOAN_MODE = '47'; //Invalid flashloan mode selected
1300   string public constant MATH_MULTIPLICATION_OVERFLOW = '48';
1301   string public constant MATH_ADDITION_OVERFLOW = '49';
1302   string public constant MATH_DIVISION_BY_ZERO = '50';
1303   string public constant RL_LIQUIDITY_INDEX_OVERFLOW = '51'; //  Liquidity index overflows uint128
1304   string public constant RL_VARIABLE_BORROW_INDEX_OVERFLOW = '52'; //  Variable borrow index overflows uint128
1305   string public constant RL_LIQUIDITY_RATE_OVERFLOW = '53'; //  Liquidity rate overflows uint128
1306   string public constant RL_VARIABLE_BORROW_RATE_OVERFLOW = '54'; //  Variable borrow rate overflows uint128
1307   string public constant RL_STABLE_BORROW_RATE_OVERFLOW = '55'; //  Stable borrow rate overflows uint128
1308   string public constant CT_INVALID_MINT_AMOUNT = '56'; //invalid amount to mint
1309   string public constant LP_FAILED_REPAY_WITH_COLLATERAL = '57';
1310   string public constant CT_INVALID_BURN_AMOUNT = '58'; //invalid amount to burn
1311   string public constant LP_FAILED_COLLATERAL_SWAP = '60';
1312   string public constant LP_INVALID_EQUAL_ASSETS_TO_SWAP = '61';
1313   string public constant LP_REENTRANCY_NOT_ALLOWED = '62';
1314   string public constant LP_CALLER_MUST_BE_AN_ATOKEN = '63';
1315   string public constant LP_IS_PAUSED = '64'; // 'Pool is paused'
1316   string public constant LP_NO_MORE_RESERVES_ALLOWED = '65';
1317   string public constant LP_INVALID_FLASH_LOAN_EXECUTOR_RETURN = '66';
1318   string public constant RC_INVALID_LTV = '67';
1319   string public constant RC_INVALID_LIQ_THRESHOLD = '68';
1320   string public constant RC_INVALID_LIQ_BONUS = '69';
1321   string public constant RC_INVALID_DECIMALS = '70';
1322   string public constant RC_INVALID_RESERVE_FACTOR = '71';
1323   string public constant LPAPR_INVALID_ADDRESSES_PROVIDER_ID = '72';
1324   string public constant VL_INCONSISTENT_FLASHLOAN_PARAMS = '73';
1325   string public constant LP_INCONSISTENT_PARAMS_LENGTH = '74';
1326   string public constant UL_INVALID_INDEX = '77';
1327   string public constant LP_NOT_CONTRACT = '78';
1328   string public constant SDT_STABLE_DEBT_OVERFLOW = '79';
1329   string public constant SDT_BURN_EXCEEDS_BALANCE = '80';
1330 
1331   enum CollateralManagerErrors {
1332     NO_ERROR,
1333     NO_COLLATERAL_AVAILABLE,
1334     COLLATERAL_CANNOT_BE_LIQUIDATED,
1335     CURRRENCY_NOT_BORROWED,
1336     HEALTH_FACTOR_ABOVE_THRESHOLD,
1337     NOT_ENOUGH_LIQUIDITY,
1338     NO_ACTIVE_RESERVE,
1339     HEALTH_FACTOR_LOWER_THAN_LIQUIDATION_THRESHOLD,
1340     INVALID_EQUAL_ASSETS_TO_SWAP,
1341     FROZEN_RESERVE
1342   }
1343 }
1344 
1345 
1346 // File contracts/protocol/libraries/math/PercentageMath.sol
1347 
1348 pragma solidity 0.6.12;
1349 
1350 /**
1351  * @title PercentageMath library
1352  * @author Aave
1353  * @notice Provides functions to perform percentage calculations
1354  * @dev Percentages are defined by default with 2 decimals of precision (100.00). The precision is indicated by PERCENTAGE_FACTOR
1355  * @dev Operations are rounded half up
1356  **/
1357 
1358 library PercentageMath {
1359   uint256 constant PERCENTAGE_FACTOR = 1e4; //percentage plus two decimals
1360   uint256 constant HALF_PERCENT = PERCENTAGE_FACTOR / 2;
1361 
1362   /**
1363    * @dev Executes a percentage multiplication
1364    * @param value The value of which the percentage needs to be calculated
1365    * @param percentage The percentage of the value to be calculated
1366    * @return The percentage of value
1367    **/
1368   function percentMul(uint256 value, uint256 percentage) internal pure returns (uint256) {
1369     if (value == 0 || percentage == 0) {
1370       return 0;
1371     }
1372 
1373     require(
1374       value <= (type(uint256).max - HALF_PERCENT) / percentage,
1375       Errors.MATH_MULTIPLICATION_OVERFLOW
1376     );
1377 
1378     return (value * percentage + HALF_PERCENT) / PERCENTAGE_FACTOR;
1379   }
1380 
1381   /**
1382    * @dev Executes a percentage division
1383    * @param value The value of which the percentage needs to be calculated
1384    * @param percentage The percentage of the value to be calculated
1385    * @return The value divided the percentage
1386    **/
1387   function percentDiv(uint256 value, uint256 percentage) internal pure returns (uint256) {
1388     require(percentage != 0, Errors.MATH_DIVISION_BY_ZERO);
1389     uint256 halfPercentage = percentage / 2;
1390 
1391     require(
1392       value <= (type(uint256).max - halfPercentage) / PERCENTAGE_FACTOR,
1393       Errors.MATH_MULTIPLICATION_OVERFLOW
1394     );
1395 
1396     return (value * PERCENTAGE_FACTOR + halfPercentage) / percentage;
1397   }
1398 }
1399 
1400 
1401 // File contracts/interfaces/IParaSwapAugustus.sol
1402 
1403 pragma solidity 0.6.12;
1404 
1405 interface IParaSwapAugustus {
1406   function getTokenTransferProxy() external view returns (address);
1407 }
1408 
1409 
1410 // File contracts/interfaces/IParaSwapAugustusRegistry.sol
1411 
1412 pragma solidity 0.6.12;
1413 
1414 interface IParaSwapAugustusRegistry {
1415   function isValidAugustus(address augustus) external view returns (bool);
1416 }
1417 
1418 
1419 // File contracts/adapters/BaseParaSwapSellAdapter.sol
1420 
1421 pragma solidity 0.6.12;
1422 
1423 
1424 
1425 
1426 
1427 
1428 /**
1429  * @title BaseParaSwapSellAdapter
1430  * @notice Implements the logic for selling tokens on ParaSwap
1431  * @author Jason Raymond Bell
1432  */
1433 abstract contract BaseParaSwapSellAdapter is BaseParaSwapAdapter {
1434   using PercentageMath for uint256;
1435 
1436   IParaSwapAugustusRegistry public immutable AUGUSTUS_REGISTRY;
1437 
1438   constructor(
1439     ILendingPoolAddressesProvider addressesProvider,
1440     IParaSwapAugustusRegistry augustusRegistry
1441   ) public BaseParaSwapAdapter(addressesProvider) {
1442     // Do something on Augustus registry to check the right contract was passed
1443     require(!augustusRegistry.isValidAugustus(address(0)));
1444     AUGUSTUS_REGISTRY = augustusRegistry;
1445   }
1446 
1447   /**
1448    * @dev Swaps a token for another using ParaSwap
1449    * @param fromAmountOffset Offset of fromAmount in Augustus calldata if it should be overwritten, otherwise 0
1450    * @param swapCalldata Calldata for ParaSwap's AugustusSwapper contract
1451    * @param augustus Address of ParaSwap's AugustusSwapper contract
1452    * @param assetToSwapFrom Address of the asset to be swapped from
1453    * @param assetToSwapTo Address of the asset to be swapped to
1454    * @param amountToSwap Amount to be swapped
1455    * @param minAmountToReceive Minimum amount to be received from the swap
1456    * @return amountReceived The amount received from the swap
1457    */
1458   function _sellOnParaSwap(
1459     uint256 fromAmountOffset,
1460     bytes memory swapCalldata,
1461     IParaSwapAugustus augustus,
1462     IERC20Detailed assetToSwapFrom,
1463     IERC20Detailed assetToSwapTo,
1464     uint256 amountToSwap,
1465     uint256 minAmountToReceive
1466   ) internal returns (uint256 amountReceived) {
1467     require(AUGUSTUS_REGISTRY.isValidAugustus(address(augustus)), 'INVALID_AUGUSTUS');
1468 
1469     {
1470       uint256 fromAssetDecimals = _getDecimals(assetToSwapFrom);
1471       uint256 toAssetDecimals = _getDecimals(assetToSwapTo);
1472 
1473       uint256 fromAssetPrice = _getPrice(address(assetToSwapFrom));
1474       uint256 toAssetPrice = _getPrice(address(assetToSwapTo));
1475 
1476       uint256 expectedMinAmountOut =
1477         amountToSwap
1478           .mul(fromAssetPrice.mul(10**toAssetDecimals))
1479           .div(toAssetPrice.mul(10**fromAssetDecimals))
1480           .percentMul(PercentageMath.PERCENTAGE_FACTOR - MAX_SLIPPAGE_PERCENT);
1481 
1482       require(expectedMinAmountOut <= minAmountToReceive, 'MIN_AMOUNT_EXCEEDS_MAX_SLIPPAGE');
1483     }
1484 
1485     uint256 balanceBeforeAssetFrom = assetToSwapFrom.balanceOf(address(this));
1486     require(balanceBeforeAssetFrom >= amountToSwap, 'INSUFFICIENT_BALANCE_BEFORE_SWAP');
1487     uint256 balanceBeforeAssetTo = assetToSwapTo.balanceOf(address(this));
1488 
1489     address tokenTransferProxy = augustus.getTokenTransferProxy();
1490     assetToSwapFrom.safeApprove(tokenTransferProxy, 0);
1491     assetToSwapFrom.safeApprove(tokenTransferProxy, amountToSwap);
1492 
1493     if (fromAmountOffset != 0) {
1494       // Ensure 256 bit (32 bytes) fromAmount value is within bounds of the
1495       // calldata, not overlapping with the first 4 bytes (function selector).
1496       require(fromAmountOffset >= 4 &&
1497         fromAmountOffset <= swapCalldata.length.sub(32),
1498         'FROM_AMOUNT_OFFSET_OUT_OF_RANGE');
1499       // Overwrite the fromAmount with the correct amount for the swap.
1500       // In memory, swapCalldata consists of a 256 bit length field, followed by
1501       // the actual bytes data, that is why 32 is added to the byte offset.
1502       assembly {
1503         mstore(add(swapCalldata, add(fromAmountOffset, 32)), amountToSwap)
1504       }
1505     }
1506     (bool success,) = address(augustus).call(swapCalldata);
1507     if (!success) {
1508       // Copy revert reason from call
1509       assembly {
1510         returndatacopy(0, 0, returndatasize())
1511         revert(0, returndatasize())
1512       }
1513     }
1514     require(assetToSwapFrom.balanceOf(address(this)) == balanceBeforeAssetFrom - amountToSwap, 'WRONG_BALANCE_AFTER_SWAP');
1515     amountReceived = assetToSwapTo.balanceOf(address(this)).sub(balanceBeforeAssetTo);
1516     require(amountReceived >= minAmountToReceive, 'INSUFFICIENT_AMOUNT_RECEIVED');
1517 
1518     emit Swapped(
1519       address(assetToSwapFrom),
1520       address(assetToSwapTo),
1521       amountToSwap,
1522       amountReceived
1523     );
1524   }
1525 }
1526 
1527 
1528 // File contracts/dependencies/openzeppelin/contracts/ReentrancyGuard.sol
1529 
1530 
1531 pragma solidity >=0.6.0 <0.8.0;
1532 
1533 /**
1534  * @dev Contract module that helps prevent reentrant calls to a function.
1535  *
1536  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1537  * available, which can be applied to functions to make sure there are no nested
1538  * (reentrant) calls to them.
1539  *
1540  * Note that because there is a single `nonReentrant` guard, functions marked as
1541  * `nonReentrant` may not call one another. This can be worked around by making
1542  * those functions `private`, and then adding `external` `nonReentrant` entry
1543  * points to them.
1544  *
1545  * TIP: If you would like to learn more about reentrancy and alternative ways
1546  * to protect against it, check out our blog post
1547  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1548  */
1549 abstract contract ReentrancyGuard {
1550     // Booleans are more expensive than uint256 or any type that takes up a full
1551     // word because each write operation emits an extra SLOAD to first read the
1552     // slot's contents, replace the bits taken up by the boolean, and then write
1553     // back. This is the compiler's defense against contract upgrades and
1554     // pointer aliasing, and it cannot be disabled.
1555 
1556     // The values being non-zero value makes deployment a bit more expensive,
1557     // but in exchange the refund on every call to nonReentrant will be lower in
1558     // amount. Since refunds are capped to a percentage of the total
1559     // transaction's gas, it is best to keep them low in cases like this one, to
1560     // increase the likelihood of the full refund coming into effect.
1561     uint256 private constant _NOT_ENTERED = 1;
1562     uint256 private constant _ENTERED = 2;
1563 
1564     uint256 private _status;
1565 
1566     constructor () internal {
1567         _status = _NOT_ENTERED;
1568     }
1569 
1570     /**
1571      * @dev Prevents a contract from calling itself, directly or indirectly.
1572      * Calling a `nonReentrant` function from another `nonReentrant`
1573      * function is not supported. It is possible to prevent this from happening
1574      * by making the `nonReentrant` function external, and make it call a
1575      * `private` function that does the actual work.
1576      */
1577     modifier nonReentrant() {
1578         // On the first call to nonReentrant, _notEntered will be true
1579         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1580 
1581         // Any calls to nonReentrant after this point will fail
1582         _status = _ENTERED;
1583 
1584         _;
1585 
1586         // By storing the original value once again, a refund is triggered (see
1587         // https://eips.ethereum.org/EIPS/eip-2200)
1588         _status = _NOT_ENTERED;
1589     }
1590 }
1591 
1592 
1593 // File contracts/adapters/ParaSwapLiquiditySwapAdapter.sol
1594 
1595 pragma solidity 0.6.12;
1596 
1597 
1598 
1599 
1600 
1601 
1602 
1603 /**
1604  * @title ParaSwapLiquiditySwapAdapter
1605  * @notice Adapter to swap liquidity using ParaSwap.
1606  * @author Jason Raymond Bell
1607  */
1608 contract ParaSwapLiquiditySwapAdapter is BaseParaSwapSellAdapter, ReentrancyGuard {
1609   constructor(
1610     ILendingPoolAddressesProvider addressesProvider,
1611     IParaSwapAugustusRegistry augustusRegistry
1612   ) public BaseParaSwapSellAdapter(addressesProvider, augustusRegistry) {
1613     // This is only required to initialize BaseParaSwapSellAdapter
1614   }
1615 
1616   /**
1617    * @dev Swaps the received reserve amount from the flash loan into the asset specified in the params.
1618    * The received funds from the swap are then deposited into the protocol on behalf of the user.
1619    * The user should give this contract allowance to pull the ATokens in order to withdraw the underlying asset and repay the flash loan.
1620    * @param assets Address of the underlying asset to be swapped from
1621    * @param amounts Amount of the flash loan i.e. maximum amount to swap
1622    * @param premiums Fee of the flash loan
1623    * @param initiator Account that initiated the flash loan
1624    * @param params Additional variadic field to include extra params. Expected parameters:
1625    *   address assetToSwapTo Address of the underlying asset to be swapped to and deposited
1626    *   uint256 minAmountToReceive Min amount to be received from the swap
1627    *   uint256 swapAllBalanceOffset Set to offset of fromAmount in Augustus calldata if wanting to swap all balance, otherwise 0
1628    *   bytes swapCalldata Calldata for ParaSwap's AugustusSwapper contract
1629    *   address augustus Address of ParaSwap's AugustusSwapper contract
1630    *   PermitSignature permitParams Struct containing the permit signatures, set to all zeroes if not used
1631    */
1632   function executeOperation(
1633     address[] calldata assets,
1634     uint256[] calldata amounts,
1635     uint256[] calldata premiums,
1636     address initiator,
1637     bytes calldata params
1638   ) external override nonReentrant returns (bool) {
1639     require(msg.sender == address(LENDING_POOL), 'CALLER_MUST_BE_LENDING_POOL');
1640     require(
1641       assets.length == 1 && amounts.length == 1 && premiums.length == 1,
1642       'FLASHLOAN_MULTIPLE_ASSETS_NOT_SUPPORTED'
1643     );
1644 
1645     uint256 flashLoanAmount = amounts[0];
1646     uint256 premium = premiums[0];
1647     address initiatorLocal = initiator;
1648     IERC20Detailed assetToSwapFrom = IERC20Detailed(assets[0]);
1649     (
1650       IERC20Detailed assetToSwapTo,
1651       uint256 minAmountToReceive,
1652       uint256 swapAllBalanceOffset,
1653       bytes memory swapCalldata,
1654       IParaSwapAugustus augustus,
1655       PermitSignature memory permitParams
1656     ) = abi.decode(params, (
1657       IERC20Detailed,
1658       uint256,
1659       uint256,
1660       bytes,
1661       IParaSwapAugustus,
1662       PermitSignature
1663     ));
1664 
1665     _swapLiquidity(
1666       swapAllBalanceOffset,
1667       swapCalldata,
1668       augustus,
1669       permitParams,
1670       flashLoanAmount,
1671       premium,
1672       initiatorLocal,
1673       assetToSwapFrom,
1674       assetToSwapTo,
1675       minAmountToReceive
1676     );
1677 
1678     return true;
1679   }
1680 
1681   /**
1682    * @dev Swaps an amount of an asset to another and deposits the new asset amount on behalf of the user without using a flash loan.
1683    * This method can be used when the temporary transfer of the collateral asset to this contract does not affect the user position.
1684    * The user should give this contract allowance to pull the ATokens in order to withdraw the underlying asset and perform the swap.
1685    * @param assetToSwapFrom Address of the underlying asset to be swapped from
1686    * @param assetToSwapTo Address of the underlying asset to be swapped to and deposited
1687    * @param amountToSwap Amount to be swapped, or maximum amount when swapping all balance
1688    * @param minAmountToReceive Minimum amount to be received from the swap
1689    * @param swapAllBalanceOffset Set to offset of fromAmount in Augustus calldata if wanting to swap all balance, otherwise 0
1690    * @param swapCalldata Calldata for ParaSwap's AugustusSwapper contract
1691    * @param augustus Address of ParaSwap's AugustusSwapper contract
1692    * @param permitParams Struct containing the permit signatures, set to all zeroes if not used
1693    */
1694   function swapAndDeposit(
1695     IERC20Detailed assetToSwapFrom,
1696     IERC20Detailed assetToSwapTo,
1697     uint256 amountToSwap,
1698     uint256 minAmountToReceive,
1699     uint256 swapAllBalanceOffset,
1700     bytes calldata swapCalldata,
1701     IParaSwapAugustus augustus,
1702     PermitSignature calldata permitParams
1703   ) external nonReentrant {
1704     IERC20WithPermit aToken =
1705       IERC20WithPermit(_getReserveData(address(assetToSwapFrom)).aTokenAddress);
1706 
1707     if (swapAllBalanceOffset != 0) {
1708       uint256 balance = aToken.balanceOf(msg.sender);
1709       require(balance <= amountToSwap, 'INSUFFICIENT_AMOUNT_TO_SWAP');
1710       amountToSwap = balance;
1711     }
1712 
1713     _pullATokenAndWithdraw(
1714       address(assetToSwapFrom),
1715       aToken,
1716       msg.sender,
1717       amountToSwap,
1718       permitParams
1719     );
1720 
1721     uint256 amountReceived = _sellOnParaSwap(
1722       swapAllBalanceOffset,
1723       swapCalldata,
1724       augustus,
1725       assetToSwapFrom,
1726       assetToSwapTo,
1727       amountToSwap,
1728       minAmountToReceive
1729     );
1730 
1731     assetToSwapTo.safeApprove(address(LENDING_POOL), 0);
1732     assetToSwapTo.safeApprove(address(LENDING_POOL), amountReceived);
1733     LENDING_POOL.deposit(address(assetToSwapTo), amountReceived, msg.sender, 0);
1734   }
1735 
1736   /**
1737    * @dev Swaps an amount of an asset to another and deposits the funds on behalf of the initiator.
1738    * @param swapAllBalanceOffset Set to offset of fromAmount in Augustus calldata if wanting to swap all balance, otherwise 0
1739    * @param swapCalldata Calldata for ParaSwap's AugustusSwapper contract
1740    * @param augustus Address of ParaSwap's AugustusSwapper contract
1741    * @param permitParams Struct containing the permit signatures, set to all zeroes if not used
1742    * @param flashLoanAmount Amount of the flash loan i.e. maximum amount to swap
1743    * @param premium Fee of the flash loan
1744    * @param initiator Account that initiated the flash loan
1745    * @param assetToSwapFrom Address of the underyling asset to be swapped from
1746    * @param assetToSwapTo Address of the underlying asset to be swapped to and deposited
1747    * @param minAmountToReceive Min amount to be received from the swap
1748    */
1749   function _swapLiquidity (
1750     uint256 swapAllBalanceOffset,
1751     bytes memory swapCalldata,
1752     IParaSwapAugustus augustus,
1753     PermitSignature memory permitParams,
1754     uint256 flashLoanAmount,
1755     uint256 premium,
1756     address initiator,
1757     IERC20Detailed assetToSwapFrom,
1758     IERC20Detailed assetToSwapTo,
1759     uint256 minAmountToReceive
1760   ) internal {
1761     IERC20WithPermit aToken =
1762       IERC20WithPermit(_getReserveData(address(assetToSwapFrom)).aTokenAddress);
1763     uint256 amountToSwap = flashLoanAmount;
1764 
1765     uint256 balance = aToken.balanceOf(initiator);
1766     if (swapAllBalanceOffset != 0) {
1767       uint256 balanceToSwap = balance.sub(premium);
1768       require(balanceToSwap <= amountToSwap, 'INSUFFICIENT_AMOUNT_TO_SWAP');
1769       amountToSwap = balanceToSwap;
1770     } else {
1771       require(balance >= amountToSwap.add(premium), 'INSUFFICIENT_ATOKEN_BALANCE');
1772     }
1773 
1774     uint256 amountReceived = _sellOnParaSwap(
1775       swapAllBalanceOffset,
1776       swapCalldata,
1777       augustus,
1778       assetToSwapFrom,
1779       assetToSwapTo,
1780       amountToSwap,
1781       minAmountToReceive
1782     );
1783 
1784     assetToSwapTo.safeApprove(address(LENDING_POOL), 0);
1785     assetToSwapTo.safeApprove(address(LENDING_POOL), amountReceived);
1786     LENDING_POOL.deposit(address(assetToSwapTo), amountReceived, initiator, 0);
1787 
1788     _pullATokenAndWithdraw(
1789       address(assetToSwapFrom),
1790       aToken,
1791       initiator,
1792       amountToSwap.add(premium),
1793       permitParams
1794     );
1795 
1796     // Repay flash loan
1797     assetToSwapFrom.safeApprove(address(LENDING_POOL), 0);
1798     assetToSwapFrom.safeApprove(address(LENDING_POOL), flashLoanAmount.add(premium));
1799   }
1800 }