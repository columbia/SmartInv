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
1139   event Swapped(
1140     address indexed fromAsset,
1141     address indexed toAsset,
1142     uint256 fromAmount,
1143     uint256 receivedAmount
1144   );
1145   event Bought(
1146     address indexed fromAsset,
1147     address indexed toAsset,
1148     uint256 amountSold,
1149     uint256 receivedAmount
1150   );
1151 
1152   constructor(ILendingPoolAddressesProvider addressesProvider)
1153     public
1154     FlashLoanReceiverBase(addressesProvider)
1155   {
1156     ORACLE = IPriceOracleGetter(addressesProvider.getPriceOracle());
1157   }
1158 
1159   /**
1160    * @dev Get the price of the asset from the oracle denominated in eth
1161    * @param asset address
1162    * @return eth price for the asset
1163    */
1164   function _getPrice(address asset) internal view returns (uint256) {
1165     return ORACLE.getAssetPrice(asset);
1166   }
1167 
1168   /**
1169    * @dev Get the decimals of an asset
1170    * @return number of decimals of the asset
1171    */
1172   function _getDecimals(IERC20Detailed asset) internal view returns (uint8) {
1173     uint8 decimals = asset.decimals();
1174     // Ensure 10**decimals won't overflow a uint256
1175     require(decimals <= 77, 'TOO_MANY_DECIMALS_ON_TOKEN');
1176     return decimals;
1177   }
1178 
1179   /**
1180    * @dev Get the aToken associated to the asset
1181    * @return address of the aToken
1182    */
1183   function _getReserveData(address asset) internal view returns (DataTypes.ReserveData memory) {
1184     return LENDING_POOL.getReserveData(asset);
1185   }
1186 
1187   function _pullATokenAndWithdraw(
1188     address reserve,
1189     address user,
1190     uint256 amount,
1191     PermitSignature memory permitSignature
1192   ) internal {
1193     IERC20WithPermit reserveAToken =
1194       IERC20WithPermit(_getReserveData(address(reserve)).aTokenAddress);
1195     _pullATokenAndWithdraw(reserve, reserveAToken, user, amount, permitSignature);
1196   }
1197 
1198   /**
1199    * @dev Pull the ATokens from the user
1200    * @param reserve address of the asset
1201    * @param reserveAToken address of the aToken of the reserve
1202    * @param user address
1203    * @param amount of tokens to be transferred to the contract
1204    * @param permitSignature struct containing the permit signature
1205    */
1206   function _pullATokenAndWithdraw(
1207     address reserve,
1208     IERC20WithPermit reserveAToken,
1209     address user,
1210     uint256 amount,
1211     PermitSignature memory permitSignature
1212   ) internal {
1213     // If deadline is set to zero, assume there is no signature for permit
1214     if (permitSignature.deadline != 0) {
1215       reserveAToken.permit(
1216         user,
1217         address(this),
1218         permitSignature.amount,
1219         permitSignature.deadline,
1220         permitSignature.v,
1221         permitSignature.r,
1222         permitSignature.s
1223       );
1224     }
1225 
1226     // transfer from user to adapter
1227     reserveAToken.safeTransferFrom(user, address(this), amount);
1228 
1229     // withdraw reserve
1230     require(
1231       LENDING_POOL.withdraw(reserve, amount, address(this)) == amount,
1232       'UNEXPECTED_AMOUNT_WITHDRAWN'
1233     );
1234   }
1235 
1236   /**
1237    * @dev Emergency rescue for token stucked on this contract, as failsafe mechanism
1238    * - Funds should never remain in this contract more time than during transactions
1239    * - Only callable by the owner
1240    */
1241   function rescueTokens(IERC20 token) external onlyOwner {
1242     token.safeTransfer(owner(), token.balanceOf(address(this)));
1243   }
1244 }
1245 
1246 
1247 // File contracts/protocol/libraries/helpers/Errors.sol
1248 
1249 pragma solidity 0.6.12;
1250 
1251 /**
1252  * @title Errors library
1253  * @author Aave
1254  * @notice Defines the error messages emitted by the different contracts of the Aave protocol
1255  * @dev Error messages prefix glossary:
1256  *  - VL = ValidationLogic
1257  *  - MATH = Math libraries
1258  *  - CT = Common errors between tokens (AToken, VariableDebtToken and StableDebtToken)
1259  *  - AT = AToken
1260  *  - SDT = StableDebtToken
1261  *  - VDT = VariableDebtToken
1262  *  - LP = LendingPool
1263  *  - LPAPR = LendingPoolAddressesProviderRegistry
1264  *  - LPC = LendingPoolConfiguration
1265  *  - RL = ReserveLogic
1266  *  - LPCM = LendingPoolCollateralManager
1267  *  - P = Pausable
1268  */
1269 library Errors {
1270   //common errors
1271   string public constant CALLER_NOT_POOL_ADMIN = '33'; // 'The caller must be the pool admin'
1272   string public constant BORROW_ALLOWANCE_NOT_ENOUGH = '59'; // User borrows on behalf, but allowance are too small
1273 
1274   //contract specific errors
1275   string public constant VL_INVALID_AMOUNT = '1'; // 'Amount must be greater than 0'
1276   string public constant VL_NO_ACTIVE_RESERVE = '2'; // 'Action requires an active reserve'
1277   string public constant VL_RESERVE_FROZEN = '3'; // 'Action cannot be performed because the reserve is frozen'
1278   string public constant VL_CURRENT_AVAILABLE_LIQUIDITY_NOT_ENOUGH = '4'; // 'The current liquidity is not enough'
1279   string public constant VL_NOT_ENOUGH_AVAILABLE_USER_BALANCE = '5'; // 'User cannot withdraw more than the available balance'
1280   string public constant VL_TRANSFER_NOT_ALLOWED = '6'; // 'Transfer cannot be allowed.'
1281   string public constant VL_BORROWING_NOT_ENABLED = '7'; // 'Borrowing is not enabled'
1282   string public constant VL_INVALID_INTEREST_RATE_MODE_SELECTED = '8'; // 'Invalid interest rate mode selected'
1283   string public constant VL_COLLATERAL_BALANCE_IS_0 = '9'; // 'The collateral balance is 0'
1284   string public constant VL_HEALTH_FACTOR_LOWER_THAN_LIQUIDATION_THRESHOLD = '10'; // 'Health factor is lesser than the liquidation threshold'
1285   string public constant VL_COLLATERAL_CANNOT_COVER_NEW_BORROW = '11'; // 'There is not enough collateral to cover a new borrow'
1286   string public constant VL_STABLE_BORROWING_NOT_ENABLED = '12'; // stable borrowing not enabled
1287   string public constant VL_COLLATERAL_SAME_AS_BORROWING_CURRENCY = '13'; // collateral is (mostly) the same currency that is being borrowed
1288   string public constant VL_AMOUNT_BIGGER_THAN_MAX_LOAN_SIZE_STABLE = '14'; // 'The requested amount is greater than the max loan size in stable rate mode
1289   string public constant VL_NO_DEBT_OF_SELECTED_TYPE = '15'; // 'for repayment of stable debt, the user needs to have stable debt, otherwise, he needs to have variable debt'
1290   string public constant VL_NO_EXPLICIT_AMOUNT_TO_REPAY_ON_BEHALF = '16'; // 'To repay on behalf of an user an explicit amount to repay is needed'
1291   string public constant VL_NO_STABLE_RATE_LOAN_IN_RESERVE = '17'; // 'User does not have a stable rate loan in progress on this reserve'
1292   string public constant VL_NO_VARIABLE_RATE_LOAN_IN_RESERVE = '18'; // 'User does not have a variable rate loan in progress on this reserve'
1293   string public constant VL_UNDERLYING_BALANCE_NOT_GREATER_THAN_0 = '19'; // 'The underlying balance needs to be greater than 0'
1294   string public constant VL_DEPOSIT_ALREADY_IN_USE = '20'; // 'User deposit is already being used as collateral'
1295   string public constant LP_NOT_ENOUGH_STABLE_BORROW_BALANCE = '21'; // 'User does not have any stable rate loan for this reserve'
1296   string public constant LP_INTEREST_RATE_REBALANCE_CONDITIONS_NOT_MET = '22'; // 'Interest rate rebalance conditions were not met'
1297   string public constant LP_LIQUIDATION_CALL_FAILED = '23'; // 'Liquidation call failed'
1298   string public constant LP_NOT_ENOUGH_LIQUIDITY_TO_BORROW = '24'; // 'There is not enough liquidity available to borrow'
1299   string public constant LP_REQUESTED_AMOUNT_TOO_SMALL = '25'; // 'The requested amount is too small for a FlashLoan.'
1300   string public constant LP_INCONSISTENT_PROTOCOL_ACTUAL_BALANCE = '26'; // 'The actual balance of the protocol is inconsistent'
1301   string public constant LP_CALLER_NOT_LENDING_POOL_CONFIGURATOR = '27'; // 'The caller of the function is not the lending pool configurator'
1302   string public constant LP_INCONSISTENT_FLASHLOAN_PARAMS = '28';
1303   string public constant CT_CALLER_MUST_BE_LENDING_POOL = '29'; // 'The caller of this function must be a lending pool'
1304   string public constant CT_CANNOT_GIVE_ALLOWANCE_TO_HIMSELF = '30'; // 'User cannot give allowance to himself'
1305   string public constant CT_TRANSFER_AMOUNT_NOT_GT_0 = '31'; // 'Transferred amount needs to be greater than zero'
1306   string public constant RL_RESERVE_ALREADY_INITIALIZED = '32'; // 'Reserve has already been initialized'
1307   string public constant LPC_RESERVE_LIQUIDITY_NOT_0 = '34'; // 'The liquidity of the reserve needs to be 0'
1308   string public constant LPC_INVALID_ATOKEN_POOL_ADDRESS = '35'; // 'The liquidity of the reserve needs to be 0'
1309   string public constant LPC_INVALID_STABLE_DEBT_TOKEN_POOL_ADDRESS = '36'; // 'The liquidity of the reserve needs to be 0'
1310   string public constant LPC_INVALID_VARIABLE_DEBT_TOKEN_POOL_ADDRESS = '37'; // 'The liquidity of the reserve needs to be 0'
1311   string public constant LPC_INVALID_STABLE_DEBT_TOKEN_UNDERLYING_ADDRESS = '38'; // 'The liquidity of the reserve needs to be 0'
1312   string public constant LPC_INVALID_VARIABLE_DEBT_TOKEN_UNDERLYING_ADDRESS = '39'; // 'The liquidity of the reserve needs to be 0'
1313   string public constant LPC_INVALID_ADDRESSES_PROVIDER_ID = '40'; // 'The liquidity of the reserve needs to be 0'
1314   string public constant LPC_INVALID_CONFIGURATION = '75'; // 'Invalid risk parameters for the reserve'
1315   string public constant LPC_CALLER_NOT_EMERGENCY_ADMIN = '76'; // 'The caller must be the emergency admin'
1316   string public constant LPAPR_PROVIDER_NOT_REGISTERED = '41'; // 'Provider is not registered'
1317   string public constant LPCM_HEALTH_FACTOR_NOT_BELOW_THRESHOLD = '42'; // 'Health factor is not below the threshold'
1318   string public constant LPCM_COLLATERAL_CANNOT_BE_LIQUIDATED = '43'; // 'The collateral chosen cannot be liquidated'
1319   string public constant LPCM_SPECIFIED_CURRENCY_NOT_BORROWED_BY_USER = '44'; // 'User did not borrow the specified currency'
1320   string public constant LPCM_NOT_ENOUGH_LIQUIDITY_TO_LIQUIDATE = '45'; // "There isn't enough liquidity available to liquidate"
1321   string public constant LPCM_NO_ERRORS = '46'; // 'No errors'
1322   string public constant LP_INVALID_FLASHLOAN_MODE = '47'; //Invalid flashloan mode selected
1323   string public constant MATH_MULTIPLICATION_OVERFLOW = '48';
1324   string public constant MATH_ADDITION_OVERFLOW = '49';
1325   string public constant MATH_DIVISION_BY_ZERO = '50';
1326   string public constant RL_LIQUIDITY_INDEX_OVERFLOW = '51'; //  Liquidity index overflows uint128
1327   string public constant RL_VARIABLE_BORROW_INDEX_OVERFLOW = '52'; //  Variable borrow index overflows uint128
1328   string public constant RL_LIQUIDITY_RATE_OVERFLOW = '53'; //  Liquidity rate overflows uint128
1329   string public constant RL_VARIABLE_BORROW_RATE_OVERFLOW = '54'; //  Variable borrow rate overflows uint128
1330   string public constant RL_STABLE_BORROW_RATE_OVERFLOW = '55'; //  Stable borrow rate overflows uint128
1331   string public constant CT_INVALID_MINT_AMOUNT = '56'; //invalid amount to mint
1332   string public constant LP_FAILED_REPAY_WITH_COLLATERAL = '57';
1333   string public constant CT_INVALID_BURN_AMOUNT = '58'; //invalid amount to burn
1334   string public constant LP_FAILED_COLLATERAL_SWAP = '60';
1335   string public constant LP_INVALID_EQUAL_ASSETS_TO_SWAP = '61';
1336   string public constant LP_REENTRANCY_NOT_ALLOWED = '62';
1337   string public constant LP_CALLER_MUST_BE_AN_ATOKEN = '63';
1338   string public constant LP_IS_PAUSED = '64'; // 'Pool is paused'
1339   string public constant LP_NO_MORE_RESERVES_ALLOWED = '65';
1340   string public constant LP_INVALID_FLASH_LOAN_EXECUTOR_RETURN = '66';
1341   string public constant RC_INVALID_LTV = '67';
1342   string public constant RC_INVALID_LIQ_THRESHOLD = '68';
1343   string public constant RC_INVALID_LIQ_BONUS = '69';
1344   string public constant RC_INVALID_DECIMALS = '70';
1345   string public constant RC_INVALID_RESERVE_FACTOR = '71';
1346   string public constant LPAPR_INVALID_ADDRESSES_PROVIDER_ID = '72';
1347   string public constant VL_INCONSISTENT_FLASHLOAN_PARAMS = '73';
1348   string public constant LP_INCONSISTENT_PARAMS_LENGTH = '74';
1349   string public constant UL_INVALID_INDEX = '77';
1350   string public constant LP_NOT_CONTRACT = '78';
1351   string public constant SDT_STABLE_DEBT_OVERFLOW = '79';
1352   string public constant SDT_BURN_EXCEEDS_BALANCE = '80';
1353 
1354   enum CollateralManagerErrors {
1355     NO_ERROR,
1356     NO_COLLATERAL_AVAILABLE,
1357     COLLATERAL_CANNOT_BE_LIQUIDATED,
1358     CURRRENCY_NOT_BORROWED,
1359     HEALTH_FACTOR_ABOVE_THRESHOLD,
1360     NOT_ENOUGH_LIQUIDITY,
1361     NO_ACTIVE_RESERVE,
1362     HEALTH_FACTOR_LOWER_THAN_LIQUIDATION_THRESHOLD,
1363     INVALID_EQUAL_ASSETS_TO_SWAP,
1364     FROZEN_RESERVE
1365   }
1366 }
1367 
1368 
1369 // File contracts/protocol/libraries/math/PercentageMath.sol
1370 
1371 pragma solidity 0.6.12;
1372 
1373 /**
1374  * @title PercentageMath library
1375  * @author Aave
1376  * @notice Provides functions to perform percentage calculations
1377  * @dev Percentages are defined by default with 2 decimals of precision (100.00). The precision is indicated by PERCENTAGE_FACTOR
1378  * @dev Operations are rounded half up
1379  **/
1380 
1381 library PercentageMath {
1382   uint256 constant PERCENTAGE_FACTOR = 1e4; //percentage plus two decimals
1383   uint256 constant HALF_PERCENT = PERCENTAGE_FACTOR / 2;
1384 
1385   /**
1386    * @dev Executes a percentage multiplication
1387    * @param value The value of which the percentage needs to be calculated
1388    * @param percentage The percentage of the value to be calculated
1389    * @return The percentage of value
1390    **/
1391   function percentMul(uint256 value, uint256 percentage) internal pure returns (uint256) {
1392     if (value == 0 || percentage == 0) {
1393       return 0;
1394     }
1395 
1396     require(
1397       value <= (type(uint256).max - HALF_PERCENT) / percentage,
1398       Errors.MATH_MULTIPLICATION_OVERFLOW
1399     );
1400 
1401     return (value * percentage + HALF_PERCENT) / PERCENTAGE_FACTOR;
1402   }
1403 
1404   /**
1405    * @dev Executes a percentage division
1406    * @param value The value of which the percentage needs to be calculated
1407    * @param percentage The percentage of the value to be calculated
1408    * @return The value divided the percentage
1409    **/
1410   function percentDiv(uint256 value, uint256 percentage) internal pure returns (uint256) {
1411     require(percentage != 0, Errors.MATH_DIVISION_BY_ZERO);
1412     uint256 halfPercentage = percentage / 2;
1413 
1414     require(
1415       value <= (type(uint256).max - halfPercentage) / PERCENTAGE_FACTOR,
1416       Errors.MATH_MULTIPLICATION_OVERFLOW
1417     );
1418 
1419     return (value * PERCENTAGE_FACTOR + halfPercentage) / percentage;
1420   }
1421 }
1422 
1423 
1424 // File contracts/interfaces/IParaSwapAugustus.sol
1425 
1426 pragma solidity 0.6.12;
1427 
1428 interface IParaSwapAugustus {
1429   function getTokenTransferProxy() external view returns (address);
1430 }
1431 
1432 
1433 // File contracts/interfaces/IParaSwapAugustusRegistry.sol
1434 
1435 pragma solidity 0.6.12;
1436 
1437 interface IParaSwapAugustusRegistry {
1438   function isValidAugustus(address augustus) external view returns (bool);
1439 }
1440 
1441 
1442 // File contracts/adapters/BaseParaSwapBuyAdapter.sol
1443 
1444 pragma solidity 0.6.12;
1445 
1446 
1447 
1448 
1449 
1450 
1451 /**
1452  * @title BaseParaSwapBuyAdapter
1453  * @notice Implements the logic for buying tokens on ParaSwap
1454  */
1455 abstract contract BaseParaSwapBuyAdapter is BaseParaSwapAdapter {
1456   using PercentageMath for uint256;
1457 
1458   IParaSwapAugustusRegistry public immutable AUGUSTUS_REGISTRY;
1459 
1460   constructor(
1461     ILendingPoolAddressesProvider addressesProvider,
1462     IParaSwapAugustusRegistry augustusRegistry
1463   ) public BaseParaSwapAdapter(addressesProvider) {
1464     // Do something on Augustus registry to check the right contract was passed
1465     require(!augustusRegistry.isValidAugustus(address(0)), "Not a valid Augustus address");
1466     AUGUSTUS_REGISTRY = augustusRegistry;
1467   }
1468 
1469   /**
1470    * @dev Swaps a token for another using ParaSwap
1471    * @param toAmountOffset Offset of toAmount in Augustus calldata if it should be overwritten, otherwise 0
1472    * @param paraswapData Data for Paraswap Adapter
1473    * @param assetToSwapFrom Address of the asset to be swapped from
1474    * @param assetToSwapTo Address of the asset to be swapped to
1475    * @param maxAmountToSwap Max amount to be swapped
1476    * @param amountToReceive Amount to be received from the swap
1477    * @return amountSold The amount sold during the swap
1478    */
1479   function _buyOnParaSwap(
1480     uint256 toAmountOffset,
1481     bytes memory paraswapData,
1482     IERC20Detailed assetToSwapFrom,
1483     IERC20Detailed assetToSwapTo,
1484     uint256 maxAmountToSwap,
1485     uint256 amountToReceive
1486   ) internal returns (uint256 amountSold) {
1487     (bytes memory buyCalldata, IParaSwapAugustus augustus) =
1488       abi.decode(paraswapData, (bytes, IParaSwapAugustus));
1489 
1490     require(AUGUSTUS_REGISTRY.isValidAugustus(address(augustus)), 'INVALID_AUGUSTUS');
1491 
1492     {
1493       uint256 fromAssetDecimals = _getDecimals(assetToSwapFrom);
1494       uint256 toAssetDecimals = _getDecimals(assetToSwapTo);
1495 
1496       uint256 fromAssetPrice = _getPrice(address(assetToSwapFrom));
1497       uint256 toAssetPrice = _getPrice(address(assetToSwapTo));
1498 
1499       uint256 expectedMaxAmountToSwap =
1500         amountToReceive
1501           .mul(toAssetPrice.mul(10**fromAssetDecimals))
1502           .div(fromAssetPrice.mul(10**toAssetDecimals))
1503           .percentMul(PercentageMath.PERCENTAGE_FACTOR.add(MAX_SLIPPAGE_PERCENT));
1504 
1505       require(maxAmountToSwap <= expectedMaxAmountToSwap, 'maxAmountToSwap exceed max slippage');
1506     }
1507 
1508     uint256 balanceBeforeAssetFrom = assetToSwapFrom.balanceOf(address(this));
1509     require(balanceBeforeAssetFrom >= maxAmountToSwap, 'INSUFFICIENT_BALANCE_BEFORE_SWAP');
1510     uint256 balanceBeforeAssetTo = assetToSwapTo.balanceOf(address(this));
1511 
1512     address tokenTransferProxy = augustus.getTokenTransferProxy();
1513     assetToSwapFrom.safeApprove(tokenTransferProxy, 0);
1514     assetToSwapFrom.safeApprove(tokenTransferProxy, maxAmountToSwap);
1515 
1516     if (toAmountOffset != 0) {
1517       // Ensure 256 bit (32 bytes) toAmountOffset value is within bounds of the
1518       // calldata, not overlapping with the first 4 bytes (function selector).
1519       require(
1520         toAmountOffset >= 4 && toAmountOffset <= buyCalldata.length.sub(32),
1521         'TO_AMOUNT_OFFSET_OUT_OF_RANGE'
1522       );
1523       // Overwrite the toAmount with the correct amount for the buy.
1524       // In memory, buyCalldata consists of a 256 bit length field, followed by
1525       // the actual bytes data, that is why 32 is added to the byte offset.
1526       assembly {
1527         mstore(add(buyCalldata, add(toAmountOffset, 32)), amountToReceive)
1528       }
1529     }
1530     (bool success, ) = address(augustus).call(buyCalldata);
1531     if (!success) {
1532       // Copy revert reason from call
1533       assembly {
1534         returndatacopy(0, 0, returndatasize())
1535         revert(0, returndatasize())
1536       }
1537     }
1538 
1539     uint256 balanceAfterAssetFrom = assetToSwapFrom.balanceOf(address(this));
1540     amountSold = balanceBeforeAssetFrom - balanceAfterAssetFrom;
1541     require(amountSold <= maxAmountToSwap, 'WRONG_BALANCE_AFTER_SWAP');
1542     uint256 amountReceived = assetToSwapTo.balanceOf(address(this)).sub(balanceBeforeAssetTo);
1543     require(amountReceived >= amountToReceive, 'INSUFFICIENT_AMOUNT_RECEIVED');
1544 
1545     emit Bought(address(assetToSwapFrom), address(assetToSwapTo), amountSold, amountReceived);
1546   }
1547 }
1548 
1549 
1550 // File contracts/dependencies/openzeppelin/contracts/ReentrancyGuard.sol
1551 
1552 
1553 pragma solidity >=0.6.0 <0.8.0;
1554 
1555 /**
1556  * @dev Contract module that helps prevent reentrant calls to a function.
1557  *
1558  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1559  * available, which can be applied to functions to make sure there are no nested
1560  * (reentrant) calls to them.
1561  *
1562  * Note that because there is a single `nonReentrant` guard, functions marked as
1563  * `nonReentrant` may not call one another. This can be worked around by making
1564  * those functions `private`, and then adding `external` `nonReentrant` entry
1565  * points to them.
1566  *
1567  * TIP: If you would like to learn more about reentrancy and alternative ways
1568  * to protect against it, check out our blog post
1569  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1570  */
1571 abstract contract ReentrancyGuard {
1572     // Booleans are more expensive than uint256 or any type that takes up a full
1573     // word because each write operation emits an extra SLOAD to first read the
1574     // slot's contents, replace the bits taken up by the boolean, and then write
1575     // back. This is the compiler's defense against contract upgrades and
1576     // pointer aliasing, and it cannot be disabled.
1577 
1578     // The values being non-zero value makes deployment a bit more expensive,
1579     // but in exchange the refund on every call to nonReentrant will be lower in
1580     // amount. Since refunds are capped to a percentage of the total
1581     // transaction's gas, it is best to keep them low in cases like this one, to
1582     // increase the likelihood of the full refund coming into effect.
1583     uint256 private constant _NOT_ENTERED = 1;
1584     uint256 private constant _ENTERED = 2;
1585 
1586     uint256 private _status;
1587 
1588     constructor () internal {
1589         _status = _NOT_ENTERED;
1590     }
1591 
1592     /**
1593      * @dev Prevents a contract from calling itself, directly or indirectly.
1594      * Calling a `nonReentrant` function from another `nonReentrant`
1595      * function is not supported. It is possible to prevent this from happening
1596      * by making the `nonReentrant` function external, and make it call a
1597      * `private` function that does the actual work.
1598      */
1599     modifier nonReentrant() {
1600         // On the first call to nonReentrant, _notEntered will be true
1601         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1602 
1603         // Any calls to nonReentrant after this point will fail
1604         _status = _ENTERED;
1605 
1606         _;
1607 
1608         // By storing the original value once again, a refund is triggered (see
1609         // https://eips.ethereum.org/EIPS/eip-2200)
1610         _status = _NOT_ENTERED;
1611     }
1612 }
1613 
1614 
1615 // File contracts/adapters/ParaSwapRepayAdapter.sol
1616 
1617 pragma solidity 0.6.12;
1618 
1619 
1620 
1621 
1622 
1623 
1624 
1625 
1626 
1627 /**
1628  * @title UniswapRepayAdapter
1629  * @notice Uniswap V2 Adapter to perform a repay of a debt with collateral.
1630  * @author Aave
1631  **/
1632 contract ParaSwapRepayAdapter is BaseParaSwapBuyAdapter, ReentrancyGuard {
1633   struct RepayParams {
1634     address collateralAsset;
1635     uint256 collateralAmount;
1636     uint256 rateMode;
1637     PermitSignature permitSignature;
1638     bool useEthPath;
1639   }
1640 
1641   constructor(
1642     ILendingPoolAddressesProvider addressesProvider,
1643     IParaSwapAugustusRegistry augustusRegistry
1644   ) public BaseParaSwapBuyAdapter(addressesProvider, augustusRegistry) {
1645     // This is only required to initialize BaseParaSwapBuyAdapter
1646   }
1647 
1648   /**
1649    * @dev Uses the received funds from the flash loan to repay a debt on the protocol on behalf of the user. Then pulls
1650    * the collateral from the user and swaps it to the debt asset to repay the flash loan.
1651    * The user should give this contract allowance to pull the ATokens in order to withdraw the underlying asset, swap it
1652    * and repay the flash loan.
1653    * Supports only one asset on the flash loan.
1654    * @param assets Address of collateral asset(Flash loan asset)
1655    * @param amounts Amount of flash loan taken
1656    * @param premiums Fee of the flash loan
1657    * @param initiator Address of the user
1658    * @param params Additional variadic field to include extra params. Expected parameters:
1659    *   IERC20Detailed debtAsset Address of the debt asset
1660    *   uint256 debtAmount Amount of debt to be repaid
1661    *   uint256 rateMode Rate modes of the debt to be repaid
1662    *   uint256 deadline Deadline for the permit signature
1663    *   uint256 debtRateMode Rate mode of the debt to be repaid
1664    *   bytes paraswapData Paraswap Data
1665    *                    * bytes buyCallData Call data for augustus
1666    *                    * IParaSwapAugustus augustus Address of Augustus Swapper
1667    *   PermitSignature permitParams Struct containing the permit signatures, set to all zeroes if not used
1668    */
1669   function executeOperation(
1670     address[] calldata assets,
1671     uint256[] calldata amounts,
1672     uint256[] calldata premiums,
1673     address initiator,
1674     bytes calldata params
1675   ) external override nonReentrant returns (bool) {
1676     require(msg.sender == address(LENDING_POOL), 'CALLER_MUST_BE_LENDING_POOL');
1677 
1678     require(
1679       assets.length == 1 && amounts.length == 1 && premiums.length == 1,
1680       'FLASHLOAN_MULTIPLE_ASSETS_NOT_SUPPORTED'
1681     );
1682 
1683     uint256 collateralAmount = amounts[0];
1684     uint256 premium = premiums[0];
1685     address initiatorLocal = initiator;
1686     
1687     IERC20Detailed collateralAsset = IERC20Detailed(assets[0]);
1688     
1689     _swapAndRepay(
1690       params,
1691       premium,
1692       initiatorLocal,
1693       collateralAsset,
1694       collateralAmount
1695     );
1696 
1697     return true;
1698   }
1699 
1700   /**
1701    * @dev Swaps the user collateral for the debt asset and then repay the debt on the protocol on behalf of the user
1702    * without using flash loans. This method can be used when the temporary transfer of the collateral asset to this
1703    * contract does not affect the user position.
1704    * The user should give this contract allowance to pull the ATokens in order to withdraw the underlying asset
1705    * @param collateralAsset Address of asset to be swapped
1706    * @param debtAsset Address of debt asset
1707    * @param collateralAmount max Amount of the collateral to be swapped
1708    * @param debtRepayAmount Amount of the debt to be repaid, or maximum amount when repaying entire debt
1709    * @param debtRateMode Rate mode of the debt to be repaid
1710    * @param buyAllBalanceOffset Set to offset of toAmount in Augustus calldata if wanting to pay entire debt, otherwise 0
1711    * @param paraswapData Data for Paraswap Adapter
1712    * @param permitSignature struct containing the permit signature
1713 
1714    */
1715   function swapAndRepay(
1716     IERC20Detailed collateralAsset,
1717     IERC20Detailed debtAsset,
1718     uint256 collateralAmount,
1719     uint256 debtRepayAmount,
1720     uint256 debtRateMode,
1721     uint256 buyAllBalanceOffset,
1722     bytes calldata paraswapData,
1723     PermitSignature calldata permitSignature
1724   ) external nonReentrant {
1725 
1726     debtRepayAmount = getDebtRepayAmount(
1727       debtAsset,
1728       debtRateMode,
1729       buyAllBalanceOffset,
1730       debtRepayAmount,
1731       msg.sender
1732     );
1733 
1734     // Pull aTokens from user
1735     _pullATokenAndWithdraw(address(collateralAsset), msg.sender, collateralAmount, permitSignature);
1736     //buy debt asset using collateral asset
1737     uint256 amountSold =
1738       _buyOnParaSwap(
1739         buyAllBalanceOffset,
1740         paraswapData,
1741         collateralAsset,
1742         debtAsset,
1743         collateralAmount,
1744         debtRepayAmount
1745       );
1746 
1747     uint256 collateralBalanceLeft = collateralAmount - amountSold;
1748 
1749     //deposit collateral back in the pool, if left after the swap(buy)
1750     if (collateralBalanceLeft > 0) {
1751       IERC20(collateralAsset).safeApprove(address(LENDING_POOL), 0);
1752       IERC20(collateralAsset).safeApprove(address(LENDING_POOL), collateralBalanceLeft);
1753       LENDING_POOL.deposit(address(collateralAsset), collateralBalanceLeft, msg.sender, 0);
1754     }
1755 
1756     // Repay debt. Approves 0 first to comply with tokens that implement the anti frontrunning approval fix
1757     IERC20(debtAsset).safeApprove(address(LENDING_POOL), 0);
1758     IERC20(debtAsset).safeApprove(address(LENDING_POOL), debtRepayAmount);
1759     LENDING_POOL.repay(address(debtAsset), debtRepayAmount, debtRateMode, msg.sender);
1760   }
1761 
1762   /**
1763    * @dev Perform the repay of the debt, pulls the initiator collateral and swaps to repay the flash loan
1764    * @param premium Fee of the flash loan
1765    * @param initiator Address of the user
1766    * @param collateralAsset Address of token to be swapped
1767    * @param collateralAmount Amount of the reserve to be swapped(flash loan amount)
1768    */
1769 
1770   function _swapAndRepay(
1771     bytes calldata params,
1772     uint256 premium,
1773     address initiator,
1774     IERC20Detailed collateralAsset,
1775     uint256 collateralAmount
1776   ) private {
1777 
1778     (
1779       IERC20Detailed debtAsset,
1780       uint256 debtRepayAmount,
1781       uint256 buyAllBalanceOffset,
1782       uint256 rateMode,
1783       bytes memory paraswapData,
1784       PermitSignature memory permitSignature
1785     ) = abi.decode(params, (IERC20Detailed, uint256, uint256, uint256, bytes, PermitSignature));
1786 
1787     debtRepayAmount = getDebtRepayAmount(
1788       debtAsset,
1789       rateMode,
1790       buyAllBalanceOffset,
1791       debtRepayAmount,
1792       initiator
1793     );
1794 
1795     uint256 amountSold =
1796       _buyOnParaSwap(
1797         buyAllBalanceOffset,
1798         paraswapData,
1799         collateralAsset,
1800         debtAsset,
1801         collateralAmount,
1802         debtRepayAmount
1803       );
1804 
1805     // Repay debt. Approves for 0 first to comply with tokens that implement the anti frontrunning approval fix.
1806     IERC20(debtAsset).safeApprove(address(LENDING_POOL), 0);
1807     IERC20(debtAsset).safeApprove(address(LENDING_POOL), debtRepayAmount);
1808     LENDING_POOL.repay(address(debtAsset), debtRepayAmount, rateMode, initiator);
1809 
1810     uint256 neededForFlashLoanRepay = amountSold.add(premium);
1811 
1812     // Pull aTokens from user
1813     _pullATokenAndWithdraw(
1814       address(collateralAsset),
1815       initiator,
1816       neededForFlashLoanRepay,
1817       permitSignature
1818     );
1819 
1820     // Repay flashloan. Approves for 0 first to comply with tokens that implement the anti frontrunning approval fix.
1821     IERC20(collateralAsset).safeApprove(address(LENDING_POOL), 0);
1822     IERC20(collateralAsset).safeApprove(address(LENDING_POOL), collateralAmount.add(premium));
1823   }
1824 
1825   function getDebtRepayAmount(
1826     IERC20Detailed debtAsset,
1827     uint256 rateMode,
1828     uint256 buyAllBalanceOffset,
1829     uint256 debtRepayAmount,
1830     address initiator
1831   ) private view returns (uint256) {
1832     DataTypes.ReserveData memory debtReserveData = _getReserveData(address(debtAsset));
1833 
1834     address debtToken =
1835       DataTypes.InterestRateMode(rateMode) == DataTypes.InterestRateMode.STABLE
1836         ? debtReserveData.stableDebtTokenAddress
1837         : debtReserveData.variableDebtTokenAddress;
1838 
1839     uint256 currentDebt = IERC20(debtToken).balanceOf(initiator);
1840 
1841     if (buyAllBalanceOffset != 0) {
1842       require(currentDebt <= debtRepayAmount, 'INSUFFICIENT_AMOUNT_TO_REPAY');
1843       debtRepayAmount = currentDebt;
1844     } else {
1845       require(debtRepayAmount <= currentDebt, 'INVALID_DEBT_REPAY_AMOUNT');
1846     }
1847 
1848     return debtRepayAmount;
1849   }
1850 }