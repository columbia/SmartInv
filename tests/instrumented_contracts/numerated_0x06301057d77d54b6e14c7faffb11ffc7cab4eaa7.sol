1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see {ERC20Detailed}.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
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
80 // File: @openzeppelin/contracts/math/SafeMath.sol
81 
82 pragma solidity ^0.5.0;
83 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations with added overflow
86  * checks.
87  *
88  * Arithmetic operations in Solidity wrap on overflow. This can easily result
89  * in bugs, because programmers usually assume that an overflow raises an
90  * error, which is the standard behavior in high level programming languages.
91  * `SafeMath` restores this intuition by reverting the transaction when an
92  * operation overflows.
93  *
94  * Using this library instead of the unchecked operations eliminates an entire
95  * class of bugs, so it's recommended to use it always.
96  */
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         return sub(a, b, "SafeMath: subtraction overflow");
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's `-` operator.
132      *
133      * Requirements:
134      * - Subtraction cannot overflow.
135      *
136      * _Available since v2.4.0._
137      */
138     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b <= a, errorMessage);
140         uint256 c = a - b;
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the multiplication of two unsigned integers, reverting on
147      * overflow.
148      *
149      * Counterpart to Solidity's `*` operator.
150      *
151      * Requirements:
152      * - Multiplication cannot overflow.
153      */
154     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
155         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
156         // benefit is lost if 'b' is also tested.
157         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
158         if (a == 0) {
159             return 0;
160         }
161 
162         uint256 c = a * b;
163         require(c / a == b, "SafeMath: multiplication overflow");
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the integer division of two unsigned integers. Reverts on
170      * division by zero. The result is rounded towards zero.
171      *
172      * Counterpart to Solidity's `/` operator. Note: this function uses a
173      * `revert` opcode (which leaves remaining gas untouched) while Solidity
174      * uses an invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      * - The divisor cannot be zero.
178      */
179     function div(uint256 a, uint256 b) internal pure returns (uint256) {
180         return div(a, b, "SafeMath: division by zero");
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      * - The divisor cannot be zero.
193      *
194      * _Available since v2.4.0._
195      */
196     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
197         // Solidity only automatically asserts when dividing by 0
198         require(b > 0, errorMessage);
199         uint256 c = a / b;
200         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * Reverts when dividing by zero.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      * - The divisor cannot be zero.
215      */
216     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
217         return mod(a, b, "SafeMath: modulo by zero");
218     }
219 
220     /**
221      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222      * Reverts with custom message when dividing by zero.
223      *
224      * Counterpart to Solidity's `%` operator. This function uses a `revert`
225      * opcode (which leaves remaining gas untouched) while Solidity uses an
226      * invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      * - The divisor cannot be zero.
230      *
231      * _Available since v2.4.0._
232      */
233     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b != 0, errorMessage);
235         return a % b;
236     }
237 }
238 
239 // File: @openzeppelin/contracts/utils/Address.sol
240 
241 pragma solidity ^0.5.5;
242 
243 /**
244  * @dev Collection of functions related to the address type
245  */
246 library Address {
247     /**
248      * @dev Returns true if `account` is a contract.
249      *
250      * This test is non-exhaustive, and there may be false-negatives: during the
251      * execution of a contract's constructor, its address will be reported as
252      * not containing a contract.
253      *
254      * IMPORTANT: It is unsafe to assume that an address for which this
255      * function returns false is an externally-owned account (EOA) and not a
256      * contract.
257      */
258     function isContract(address account) internal view returns (bool) {
259         // This method relies in extcodesize, which returns 0 for contracts in
260         // construction, since the code is only stored at the end of the
261         // constructor execution.
262 
263         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
264         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
265         // for accounts without code, i.e. `keccak256('')`
266         bytes32 codehash;
267         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
268         // solhint-disable-next-line no-inline-assembly
269         assembly { codehash := extcodehash(account) }
270         return (codehash != 0x0 && codehash != accountHash);
271     }
272 
273     /**
274      * @dev Converts an `address` into `address payable`. Note that this is
275      * simply a type cast: the actual underlying value is not changed.
276      *
277      * _Available since v2.4.0._
278      */
279     function toPayable(address account) internal pure returns (address payable) {
280         return address(uint160(account));
281     }
282 
283     /**
284      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
285      * `recipient`, forwarding all available gas and reverting on errors.
286      *
287      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
288      * of certain opcodes, possibly making contracts go over the 2300 gas limit
289      * imposed by `transfer`, making them unable to receive funds via
290      * `transfer`. {sendValue} removes this limitation.
291      *
292      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
293      *
294      * IMPORTANT: because control is transferred to `recipient`, care must be
295      * taken to not create reentrancy vulnerabilities. Consider using
296      * {ReentrancyGuard} or the
297      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
298      *
299      * _Available since v2.4.0._
300      */
301     function sendValue(address payable recipient, uint256 amount) internal {
302         require(address(this).balance >= amount, "Address: insufficient balance");
303 
304         // solhint-disable-next-line avoid-call-value
305         (bool success, ) = recipient.call.value(amount)("");
306         require(success, "Address: unable to send value, recipient may have reverted");
307     }
308 }
309 
310 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
311 
312 pragma solidity ^0.5.0;
313 
314 
315 
316 
317 /**
318  * @title SafeERC20
319  * @dev Wrappers around ERC20 operations that throw on failure (when the token
320  * contract returns false). Tokens that return no value (and instead revert or
321  * throw on failure) are also supported, non-reverting calls are assumed to be
322  * successful.
323  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
324  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
325  */
326 library SafeERC20 {
327     using SafeMath for uint256;
328     using Address for address;
329 
330     function safeTransfer(IERC20 token, address to, uint256 value) internal {
331         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
332     }
333 
334     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
335         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
336     }
337 
338     function safeApprove(IERC20 token, address spender, uint256 value) internal {
339         // safeApprove should only be called when setting an initial allowance,
340         // or when resetting it to zero. To increase and decrease it, use
341         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
342         // solhint-disable-next-line max-line-length
343         require((value == 0) || (token.allowance(address(this), spender) == 0),
344             "SafeERC20: approve from non-zero to non-zero allowance"
345         );
346         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
347     }
348 
349     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
350         uint256 newAllowance = token.allowance(address(this), spender).add(value);
351         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
352     }
353 
354     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
355         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
356         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
357     }
358 
359     /**
360      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
361      * on the return value: the return value is optional (but if data is returned, it must not be false).
362      * @param token The token targeted by the call.
363      * @param data The call data (encoded using abi.encode or one of its variants).
364      */
365     function callOptionalReturn(IERC20 token, bytes memory data) private {
366         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
367         // we're implementing it ourselves.
368 
369         // A Solidity high level call has three parts:
370         //  1. The target address is checked to verify it contains contract code
371         //  2. The call itself is made, and success asserted
372         //  3. The return value is decoded, which in turn checks the size of the returned data.
373         // solhint-disable-next-line max-line-length
374         require(address(token).isContract(), "SafeERC20: call to non-contract");
375 
376         // solhint-disable-next-line avoid-low-level-calls
377         (bool success, bytes memory returndata) = address(token).call(data);
378         require(success, "SafeERC20: low-level call failed");
379 
380         if (returndata.length > 0) { // Return data is optional
381             // solhint-disable-next-line max-line-length
382             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
383         }
384     }
385 }
386 
387 // File: contracts/constants/CommonConstants.sol
388 
389 pragma solidity ^0.5.0;
390 
391 contract CommonConstants {
392 
393     uint public constant EXCHANGE_RATE_BASE_RATE = 1e18;
394 
395 }
396 
397 // File: contracts/interfaces/InterestRateInterface.sol
398 
399 pragma solidity ^0.5.0;
400 
401 interface InterestRateInterface {
402 
403     /**
404       * @dev Returns the current interest rate for the given DMMA and corresponding total supply & active supply
405       *
406       * @param dmmTokenId The DMMA whose interest should be retrieved
407       * @param totalSupply The total supply fot he DMM token
408       * @param activeSupply The supply that's currently being lent by users
409       * @return The interest rate in APY, which is a number with 18 decimals
410       */
411     function getInterestRate(uint dmmTokenId, uint totalSupply, uint activeSupply) external view returns (uint);
412 
413 }
414 
415 // File: @openzeppelin/contracts/GSN/Context.sol
416 
417 pragma solidity ^0.5.0;
418 
419 /*
420  * @dev Provides information about the current execution context, including the
421  * sender of the transaction and its data. While these are generally available
422  * via msg.sender and msg.data, they should not be accessed in such a direct
423  * manner, since when dealing with GSN meta-transactions the account sending and
424  * paying for execution may not be the actual sender (as far as an application
425  * is concerned).
426  *
427  * This contract is only required for intermediate, library-like contracts.
428  */
429 contract Context {
430     // Empty internal constructor, to prevent people from mistakenly deploying
431     // an instance of this contract, which should be used via inheritance.
432     constructor () internal { }
433     // solhint-disable-previous-line no-empty-blocks
434 
435     function _msgSender() internal view returns (address payable) {
436         return msg.sender;
437     }
438 
439     function _msgData() internal view returns (bytes memory) {
440         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
441         return msg.data;
442     }
443 }
444 
445 // File: @openzeppelin/contracts/ownership/Ownable.sol
446 
447 pragma solidity ^0.5.0;
448 
449 /**
450  * @dev Contract module which provides a basic access control mechanism, where
451  * there is an account (an owner) that can be granted exclusive access to
452  * specific functions.
453  *
454  * This module is used through inheritance. It will make available the modifier
455  * `onlyOwner`, which can be applied to your functions to restrict their use to
456  * the owner.
457  */
458 contract Ownable is Context {
459     address private _owner;
460 
461     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
462 
463     /**
464      * @dev Initializes the contract setting the deployer as the initial owner.
465      */
466     constructor () internal {
467         _owner = _msgSender();
468         emit OwnershipTransferred(address(0), _owner);
469     }
470 
471     /**
472      * @dev Returns the address of the current owner.
473      */
474     function owner() public view returns (address) {
475         return _owner;
476     }
477 
478     /**
479      * @dev Throws if called by any account other than the owner.
480      */
481     modifier onlyOwner() {
482         require(isOwner(), "Ownable: caller is not the owner");
483         _;
484     }
485 
486     /**
487      * @dev Returns true if the caller is the current owner.
488      */
489     function isOwner() public view returns (bool) {
490         return _msgSender() == _owner;
491     }
492 
493     /**
494      * @dev Leaves the contract without owner. It will not be possible to call
495      * `onlyOwner` functions anymore. Can only be called by the current owner.
496      *
497      * NOTE: Renouncing ownership will leave the contract without an owner,
498      * thereby removing any functionality that is only available to the owner.
499      */
500     function renounceOwnership() public onlyOwner {
501         emit OwnershipTransferred(_owner, address(0));
502         _owner = address(0);
503     }
504 
505     /**
506      * @dev Transfers ownership of the contract to a new account (`newOwner`).
507      * Can only be called by the current owner.
508      */
509     function transferOwnership(address newOwner) public onlyOwner {
510         _transferOwnership(newOwner);
511     }
512 
513     /**
514      * @dev Transfers ownership of the contract to a new account (`newOwner`).
515      */
516     function _transferOwnership(address newOwner) internal {
517         require(newOwner != address(0), "Ownable: new owner is the zero address");
518         emit OwnershipTransferred(_owner, newOwner);
519         _owner = newOwner;
520     }
521 }
522 
523 // File: contracts/utils/Blacklistable.sol
524 
525 pragma solidity ^0.5.0;
526 
527 
528 /**
529  * @dev Allows accounts to be blacklisted by the owner of the contract.
530  *
531  *  Taken from USDC's contract for blacklisting certain addresses from owning and interacting with the token.
532  */
533 contract Blacklistable is Ownable {
534 
535     string public constant BLACKLISTED = "BLACKLISTED";
536 
537     mapping(address => bool) internal blacklisted;
538 
539     event Blacklisted(address indexed account);
540     event UnBlacklisted(address indexed account);
541     event BlacklisterChanged(address indexed newBlacklister);
542 
543     /**
544      * @dev Throws if called by any account other than the creator of this contract
545     */
546     modifier onlyBlacklister() {
547         require(msg.sender == owner(), "MUST_BE_BLACKLISTER");
548         _;
549     }
550 
551     /**
552      * @dev Throws if `account` is blacklisted
553      *
554      * @param account The address to check
555     */
556     modifier notBlacklisted(address account) {
557         require(blacklisted[account] == false, BLACKLISTED);
558         _;
559     }
560 
561     /**
562      * @dev Checks if `account` is blacklisted. Reverts with `BLACKLISTED` if blacklisted.
563     */
564     function checkNotBlacklisted(address account) public view {
565         require(!blacklisted[account], BLACKLISTED);
566     }
567 
568     /**
569      * @dev Checks if `account` is blacklisted
570      *
571      * @param account The address to check
572     */
573     function isBlacklisted(address account) public view returns (bool) {
574         return blacklisted[account];
575     }
576 
577     /**
578      * @dev Adds `account` to blacklist
579      *
580      * @param account The address to blacklist
581     */
582     function blacklist(address account) public onlyBlacklister {
583         blacklisted[account] = true;
584         emit Blacklisted(account);
585     }
586 
587     /**
588      * @dev Removes account from blacklist
589      *
590      * @param account The address to remove from the blacklist
591     */
592     function unBlacklist(address account) public onlyBlacklister {
593         blacklisted[account] = false;
594         emit UnBlacklisted(account);
595     }
596 
597 }
598 
599 // File: contracts/interfaces/IDmmController.sol
600 
601 pragma solidity ^0.5.0;
602 
603 
604 
605 interface IDmmController {
606 
607     event TotalSupplyIncreased(uint oldTotalSupply, uint newTotalSupply);
608     event TotalSupplyDecreased(uint oldTotalSupply, uint newTotalSupply);
609 
610     event AdminDeposit(address indexed sender, uint amount);
611     event AdminWithdraw(address indexed receiver, uint amount);
612 
613     function blacklistable() external view returns (Blacklistable);
614 
615     /**
616      * @dev Creates a new mToken using the provided data.
617      *
618      * @param underlyingToken   The token that should be wrapped to create a new DMMA
619      * @param symbol            The symbol of the new DMMA, IE mDAI or mUSDC
620      * @param name              The name of this token, IE `DMM: DAI`
621      * @param decimals          The number of decimals of the underlying token, and therefore the number for this DMMA
622      * @param minMintAmount     The minimum amount that can be minted for any given transaction.
623      * @param minRedeemAmount   The minimum amount that can be redeemed any given transaction.
624      * @param totalSupply       The initial total supply for this market.
625      */
626     function addMarket(
627         address underlyingToken,
628         string calldata symbol,
629         string calldata name,
630         uint8 decimals,
631         uint minMintAmount,
632         uint minRedeemAmount,
633         uint totalSupply
634     ) external;
635 
636     /**
637      * @dev Creates a new mToken using the already-existing token.
638      *
639      * @param dmmToken          The token that should be added to this controller.
640      * @param underlyingToken   The token that should be wrapped to create a new DMMA.
641      */
642     function addMarketFromExistingDmmToken(
643         address dmmToken,
644         address underlyingToken
645     ) external;
646 
647     /**
648      * @param newController The new controller who should receive ownership of the provided DMM token IDs.
649      */
650     function transferOwnershipToNewController(
651         address newController
652     ) external;
653 
654     /**
655      * @dev Enables the corresponding DMMA to allow minting new tokens.
656      *
657      * @param dmmTokenId  The DMMA that should be enabled.
658      */
659     function enableMarket(uint dmmTokenId) external;
660 
661     /**
662      * @dev Disables the corresponding DMMA from minting new tokens. This allows the market to close over time, since
663      *      users are only able to redeem tokens.
664      *
665      * @param dmmTokenId  The DMMA that should be disabled.
666      */
667     function disableMarket(uint dmmTokenId) external;
668 
669     /**
670      * @dev Sets a new contract that implements the `InterestRateInterface` interface.
671      *
672      * @param newInterestRateInterface  The new contract that implements the `InterestRateInterface` interface.
673      */
674     function setInterestRateInterface(address newInterestRateInterface) external;
675 
676     /**
677      * @dev Sets a new contract that implements the `IOffChainAssetValuator` interface.
678      *
679      * @param newOffChainAssetValuator The new contract that implements the `IOffChainAssetValuator` interface.
680      */
681     function setOffChainAssetValuator(address newOffChainAssetValuator) external;
682 
683     /**
684      * @dev Sets a new contract that implements the `IOffChainAssetValuator` interface.
685      *
686      * @param newOffChainCurrencyValuator The new contract that implements the `IOffChainAssetValuator` interface.
687      */
688     function setOffChainCurrencyValuator(address newOffChainCurrencyValuator) external;
689 
690     /**
691      * @dev Sets a new contract that implements the `UnderlyingTokenValuator` interface
692      *
693      * @param newUnderlyingTokenValuator The new contract that implements the `UnderlyingTokenValuator` interface
694      */
695     function setUnderlyingTokenValuator(address newUnderlyingTokenValuator) external;
696 
697     /**
698      * @dev Allows the owners of the DMM Ecosystem to withdraw funds from a DMMA. These withdrawn funds are then
699      *      allocated to real-world assets that will be used to pay interest into the DMMA.
700      *
701      * @param newMinCollateralization   The new min collateralization (with 18 decimals) at which the DMME must be in
702      *                                  order to add to the total supply of DMM.
703      */
704     function setMinCollateralization(uint newMinCollateralization) external;
705 
706     /**
707      * @dev Allows the owners of the DMM Ecosystem to withdraw funds from a DMMA. These withdrawn funds are then
708      *      allocated to real-world assets that will be used to pay interest into the DMMA.
709      *
710      * @param newMinReserveRatio   The new ratio (with 18 decimals) that is used to enforce a certain percentage of assets
711      *                          are kept in each DMMA.
712      */
713     function setMinReserveRatio(uint newMinReserveRatio) external;
714 
715     /**
716      * @dev Increases the max supply for the provided `dmmTokenId` by `amount`. This call reverts with
717      *      INSUFFICIENT_COLLATERAL if there isn't enough collateral in the Chainlink contract to cover the controller's
718      *      requirements for minimum collateral.
719      */
720     function increaseTotalSupply(uint dmmTokenId, uint amount) external;
721 
722     /**
723      * @dev Increases the max supply for the provided `dmmTokenId` by `amount`.
724      */
725     function decreaseTotalSupply(uint dmmTokenId, uint amount) external;
726 
727     /**
728      * @dev Allows the owners of the DMM Ecosystem to withdraw funds from a DMMA. These withdrawn funds are then
729      *      allocated to real-world assets that will be used to pay interest into the DMMA.
730      *
731      * @param dmmTokenId        The ID of the DMM token whose underlying will be funded.
732      * @param underlyingAmount  The amount underlying the DMM token that will be deposited into the DMMA.
733      */
734     function adminWithdrawFunds(uint dmmTokenId, uint underlyingAmount) external;
735 
736     /**
737      * @dev Allows the owners of the DMM Ecosystem to deposit funds into a DMMA. These funds are used to disburse
738      *      interest payments and add more liquidity to the specific market.
739      *
740      * @param dmmTokenId        The ID of the DMM token whose underlying will be funded.
741      * @param underlyingAmount  The amount underlying the DMM token that will be deposited into the DMMA.
742      */
743     function adminDepositFunds(uint dmmTokenId, uint underlyingAmount) external;
744 
745     /**
746      * @dev Gets the collateralization of the system assuming 1-year's worth of interest payments are due by dividing
747      *      the total value of all the collateralized assets plus the value of the underlying tokens in each DMMA by the
748      *      aggregate interest owed (plus the principal), assuming each DMMA was at maximum usage.
749      *
750      * @return  The 1-year collateralization of the system, as a number with 18 decimals. For example
751      *          `1010000000000000000` is 101% or 1.01.
752      */
753     function getTotalCollateralization() external view returns (uint);
754 
755     /**
756      * @dev Gets the current collateralization of the system assuming by dividing the total value of all the
757      *      collateralized assets plus the value of the underlying tokens in each DMMA by the aggregate interest owed
758      *      (plus the principal), using the current usage of each DMMA.
759      *
760      * @return  The active collateralization of the system, as a number with 18 decimals. For example
761      *          `1010000000000000000` is 101% or 1.01.
762      */
763     function getActiveCollateralization() external view returns (uint);
764 
765     /**
766      * @dev Gets the interest rate from the underlying token, IE DAI or USDC.
767      *
768      * @return  The current interest rate, represented using 18 decimals. Meaning `65000000000000000` is 6.5% APY or
769      *          0.065.
770      */
771     function getInterestRateByUnderlyingTokenAddress(address underlyingToken) external view returns (uint);
772 
773     /**
774      * @dev Gets the interest rate from the DMM token, IE DMM: DAI or DMM: USDC.
775      *
776      * @return  The current interest rate, represented using 18 decimals. Meaning, `65000000000000000` is 6.5% APY or
777      *          0.065.
778      */
779     function getInterestRateByDmmTokenId(uint dmmTokenId) external view returns (uint);
780 
781     /**
782      * @dev Gets the interest rate from the DMM token, IE DMM: DAI or DMM: USDC.
783      *
784      * @return  The current interest rate, represented using 18 decimals. Meaning, `65000000000000000` is 6.5% APY or
785      *          0.065.
786      */
787     function getInterestRateByDmmTokenAddress(address dmmToken) external view returns (uint);
788 
789     /**
790      * @dev Gets the exchange rate from the underlying to the DMM token, such that
791      *      `DMM: Token = underlying / exchangeRate`
792      *
793      * @return  The current exchange rate, represented using 18 decimals. Meaning, `200000000000000000` is 0.2.
794      */
795     function getExchangeRateByUnderlying(address underlyingToken) external view returns (uint);
796 
797     /**
798      * @dev Gets the exchange rate from the underlying to the DMM token, such that
799      *      `DMM: Token = underlying / exchangeRate`
800      *
801      * @return  The current exchange rate, represented using 18 decimals. Meaning, `200000000000000000` is 0.2.
802      */
803     function getExchangeRate(address dmmToken) external view returns (uint);
804 
805     /**
806      * @dev Gets the DMM token for the provided underlying token. For example, sending DAI returns DMM: DAI.
807      */
808     function getDmmTokenForUnderlying(address underlyingToken) external view returns (address);
809 
810     /**
811      * @dev Gets the underlying token for the provided DMM token. For example, sending DMM: DAI returns DAI.
812      */
813     function getUnderlyingTokenForDmm(address dmmToken) external view returns (address);
814 
815     /**
816      * @return True if the market is enabled for this DMMA or false if it is not enabled.
817      */
818     function isMarketEnabledByDmmTokenId(uint dmmTokenId) external view returns (bool);
819 
820     /**
821      * @return True if the market is enabled for this DMM token (IE DMM: DAI) or false if it is not enabled.
822      */
823     function isMarketEnabledByDmmTokenAddress(address dmmToken) external view returns (bool);
824 
825     /**
826      * @return True if the market is enabled for this underlying token (IE DAI) or false if it is not enabled.
827      */
828     function getTokenIdFromDmmTokenAddress(address dmmTokenAddress) external view returns (uint);
829 
830 }
831 
832 // File: contracts/interfaces/IDmmToken.sol
833 
834 pragma solidity ^0.5.0;
835 
836 
837 /**
838  * Basically an interface except, contains the implementation of the type-hashes for offline signature generation.
839  *
840  * This contract contains the signatures and documentation for all publicly-implemented functions in the DMM token.
841  */
842 interface IDmmToken {
843 
844     /*****************
845      * Events
846      */
847 
848     event Mint(address indexed minter, address indexed recipient, uint amount);
849     event Redeem(address indexed redeemer, address indexed recipient, uint amount);
850     event FeeTransfer(address indexed owner, address indexed recipient, uint amount);
851 
852     event TotalSupplyIncreased(uint oldTotalSupply, uint newTotalSupply);
853     event TotalSupplyDecreased(uint oldTotalSupply, uint newTotalSupply);
854 
855     event OffChainRequestValidated(address indexed owner, address indexed feeRecipient, uint nonce, uint expiry, uint feeAmount);
856 
857     /*****************
858      * Functions
859      */
860 
861     /**
862      * @dev The controller that deployed this parent
863      */
864     function controller() external view returns (IDmmController);
865 
866     /**
867      * @dev Returns the name of the token.
868      */
869     function name() external view returns (string memory);
870 
871     /**
872      * @dev Returns the symbol of the token, usually a shorter version of the
873      * name.
874      */
875     function symbol() external view returns (string memory);
876 
877     /**
878      * @dev Returns the number of decimals used to get its user representation.
879      * For example, if `decimals` equals `2`, a balance of `505` tokens should
880      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
881      *
882      * Tokens usually opt for a value of 18, imitating the relationship between
883      * Ether and Wei.
884      *
885      * NOTE: This information is only used for _display_ purposes: it in
886      * no way affects any of the arithmetic of the contract, including
887      * {IERC20-balanceOf} and {IERC20-transfer}.
888      */
889     function decimals() external view returns (uint8);
890 
891     /**
892      * @return  The min amount that can be minted in a single transaction. This amount corresponds with the number of
893      *          decimals that this token has.
894      */
895     function minMintAmount() external view returns (uint);
896 
897     /**
898      * @return  The min amount that can be redeemed from DMM to underlying in a single transaction. This amount
899      *          corresponds with the number of decimals that this token has.
900      */
901     function minRedeemAmount() external view returns (uint);
902 
903     /**
904       * @dev The amount of DMM that is in circulation (outside of this contract)
905       */
906     function activeSupply() external view returns (uint);
907 
908     /**
909      * @dev Attempts to add `amount` to the total supply by issuing the tokens to this contract. This call fires a
910      *      Transfer event from the 0x0 address to this contract.
911      */
912     function increaseTotalSupply(uint amount) external;
913 
914     /**
915      * @dev Attempts to remove `amount` from the total supply by destroying those tokens that are held in this
916      *      contract. This call reverts with TOO_MUCH_ACTIVE_SUPPLY if `amount` is not held in this contract.
917      */
918     function decreaseTotalSupply(uint amount) external;
919 
920     /**
921      * @dev An admin function that lets the ecosystem's organizers deposit the underlying token around which this DMMA
922      *      wraps to this contract. This is used to replenish liquidity and after interest payouts are made from the
923      *      real-world assets.
924      */
925     function depositUnderlying(uint underlyingAmount) external returns (bool);
926 
927     /**
928      * @dev An admin function that lets the ecosystem's organizers withdraw the underlying token around which this DMMA
929      *      wraps from this contract. This is used to withdraw deposited tokens, to be allocated to real-world assets
930      *      that produce income streams and can cover interest payments.
931      */
932     function withdrawUnderlying(uint underlyingAmount) external returns (bool);
933 
934     /**
935       * @dev The timestamp at which the exchange rate was last updated.
936       */
937     function exchangeRateLastUpdatedTimestamp() external view returns (uint);
938 
939     /**
940       * @dev The timestamp at which the exchange rate was last updated.
941       */
942     function exchangeRateLastUpdatedBlockNumber() external view returns (uint);
943 
944     /**
945      * @dev The exchange rate from underlying to DMM. Invert this number to go from DMM to underlying. This number
946      *      has 18 decimals.
947      */
948     function getCurrentExchangeRate() external view returns (uint);
949 
950     /**
951      * @dev The current nonce of the provided `owner`. This `owner` should be the signer for any gasless transactions.
952      */
953     function nonceOf(address owner) external view returns (uint);
954 
955     /**
956      * @dev Transfers the token around which this DMMA wraps from msg.sender to the DMMA contract. Then, sends the
957      *      corresponding amount of DMM to the msg.sender. Note, this call reverts with INSUFFICIENT_DMM_LIQUIDITY if
958      *      there is not enough DMM available to be minted.
959      *
960      * @param amount The amount of underlying to send to this DMMA for conversion to DMM.
961      * @return The amount of DMM minted.
962      */
963     function mint(uint amount) external returns (uint);
964 
965     /**
966      * @dev Transfers the token around which this DMMA wraps from sender to the DMMA contract. Then, sends the
967      *      corresponding amount of DMM to recipient. Note, an allowance must be set for sender for the underlying
968      *      token that is at least of size `amount` / `exchangeRate`. This call reverts with INSUFFICIENT_DMM_LIQUIDITY
969      *      if there is not enough DMM available to be minted. See #MINT_TYPE_HASH. This function gives the `owner` the
970      *      illusion of committing a gasless transaction, allowing a relayer to broadcast the transaction and
971      *      potentially collect a fee for doing so.
972      *
973      * @param owner         The user that signed the off-chain message.
974      * @param recipient     The address that will receive the newly-minted DMM tokens.
975      * @param nonce         An auto-incrementing integer that prevents replay attacks. See #nonceOf(address) to get the
976      *                      owner's current nonce.
977      * @param expiry        The timestamp, in unix seconds, at which the signed off-chain message expires. A value of 0
978      *                      means there is no expiration.
979      * @param amount        The amount of underlying that should be minted by `owner` and sent to `recipient`.
980      * @param feeAmount     The amount of DMM to be sent to feeRecipient for sending this transaction on behalf of
981      *                      owner. Can be 0, which means the user won't be charged a fee. Must be <= `amount`.
982      * @param feeRecipient  The address that should receive the fee. A value of 0x0 will send the fees to `msg.sender`.
983      *                      Note, no fees are sent if the feeAmount is 0, regardless of what feeRecipient is.
984      * @param v             The ECDSA V parameter.
985      * @param r             The ECDSA R parameter.
986      * @param s             The ECDSA S parameter.
987      * @return  The amount of DMM minted, minus the fees paid. To get the total amount minted, add the `feeAmount` to
988      *          the returned amount from this function call.
989      */
990     function mintFromGaslessRequest(
991         address owner,
992         address recipient,
993         uint nonce,
994         uint expiry,
995         uint amount,
996         uint feeAmount,
997         address feeRecipient,
998         uint8 v,
999         bytes32 r,
1000         bytes32 s
1001     ) external returns (uint);
1002 
1003     /**
1004      * @dev Transfers DMM from msg.sender to this DMMA contract. Then, sends the corresponding amount of token around
1005      *      which this DMMA wraps to the msg.sender. Note, this call reverts with INSUFFICIENT_UNDERLYING_LIQUIDITY if
1006      *      there is not enough DMM available to be redeemed.
1007      *
1008      * @param amount    The amount of DMM to be transferred from msg.sender to this DMMA.
1009      * @return          The amount of underlying redeemed.
1010      */
1011     function redeem(uint amount) external returns (uint);
1012 
1013     /**
1014      * @dev Transfers DMM from `owner` to the DMMA contract. Then, sends the corresponding amount of token around which
1015      *      this DMMA wraps to `recipient`. Note, an allowance must be set for sender for the underlying
1016      *      token that is at least of size `amount`. This call reverts with INSUFFICIENT_UNDERLYING_LIQUIDITY
1017      *      if there is not enough underlying available to be redeemed. See #REDEEM_TYPE_HASH. This function gives the
1018      *      `owner` the illusion of committing a gasless transaction, allowing a relayer to broadcast the transaction
1019      *      and potentially collect a fee for doing so.
1020      *
1021      * @param owner         The user that signed the off-chain message.
1022      * @param recipient     The address that will receive the newly-redeemed DMM tokens.
1023      * @param nonce         An auto-incrementing integer that prevents replay attacks. See #nonceOf(address) to get the
1024      *                      owner's current nonce.
1025      * @param expiry        The timestamp, in unix seconds, at which the signed off-chain message expires. A value of 0
1026      *                      means there is no expiration.
1027      * @param amount        The amount of DMM that should be redeemed for `owner` and sent to `recipient`.
1028      * @param feeAmount     The amount of DMM to be sent to feeRecipient for sending this transaction on behalf of
1029      *                      owner. Can be 0, which means the user won't be charged a fee. Must be <= `amount`
1030      * @param feeRecipient  The address that should receive the fee. A value of 0x0 will send the fees to `msg.sender`.
1031      *                      Note, no fees are sent if the feeAmount is 0, regardless of what feeRecipient is.
1032      * @param v             The ECDSA V parameter.
1033      * @param r             The ECDSA R parameter.
1034      * @param s             The ECDSA S parameter.
1035      * @return  The amount of underlying redeemed.
1036      */
1037     function redeemFromGaslessRequest(
1038         address owner,
1039         address recipient,
1040         uint nonce,
1041         uint expiry,
1042         uint amount,
1043         uint feeAmount,
1044         address feeRecipient,
1045         uint8 v,
1046         bytes32 r,
1047         bytes32 s
1048     ) external returns (uint);
1049 
1050     /**
1051      * @dev Sets an allowance for owner with spender using an offline-generated signature. This function allows a
1052      *      relayer to send the transaction, giving the owner the illusion of committing a gasless transaction. See
1053      *      #PERMIT_TYPEHASH.
1054      *
1055      * @param owner         The user that signed the off-chain message.
1056      * @param spender       The contract/wallet that can spend DMM tokens on behalf of owner.
1057      * @param nonce         An auto-incrementing integer that prevents replay attacks. See #nonceOf(address) to get the
1058      *                      owner's current nonce.
1059      * @param expiry        The timestamp, in unix seconds, at which the signed off-chain message expires. A value of 0
1060      *                      means there is no expiration.
1061      * @param allowed       True if the spender can spend funds on behalf of owner or false to revoke this privilege.
1062      * @param feeAmount     The amount of DMM to be sent to feeRecipient for sending this transaction on behalf of
1063      *                      owner. Can be 0, which means the user won't be charged a fee.
1064      * @param feeRecipient  The address that should receive the fee. A value of 0x0 will send the fees to `msg.sender`.
1065      *                      Note, no fees are sent if the feeAmount is 0, regardless of what feeRecipient is.
1066      * @param v             The ECDSA V parameter.
1067      * @param r             The ECDSA R parameter.
1068      * @param s             The ECDSA S parameter.
1069      */
1070     function permit(
1071         address owner,
1072         address spender,
1073         uint nonce,
1074         uint expiry,
1075         bool allowed,
1076         uint feeAmount,
1077         address feeRecipient,
1078         uint8 v,
1079         bytes32 r,
1080         bytes32 s
1081     ) external;
1082 
1083     /**
1084      * @dev Transfers DMM from the `owner` to `recipient` using an offline-generated signature. This function allows a
1085      *      relayer to send the transaction, giving the owner the illusion of committing a gasless transaction. See
1086      *      #TRANSFER_TYPEHASH. This function gives the `owner` the illusion of committing a gasless transaction,
1087      *      allowing a relayer to broadcast the transaction and potentially collect a fee for doing so.
1088      *
1089      * @param owner         The user that signed the off-chain message and originator of the transfer.
1090      * @param recipient     The address that will receive the transferred DMM tokens.
1091      * @param nonce         An auto-incrementing integer that prevents replay attacks. See #nonceOf(address) to get the
1092      *                      owner's current nonce.
1093      * @param expiry        The timestamp, in unix seconds, at which the signed off-chain message expires. A value of 0
1094      *                      means there is no expiration.
1095      * @param amount        The amount of DMM that should be transferred from `owner` and sent to `recipient`.
1096      * @param feeAmount     The amount of DMM to be sent to feeRecipient for sending this transaction on behalf of
1097      *                      owner. Can be 0, which means the user won't be charged a fee.
1098      * @param feeRecipient  The address that should receive the fee. A value of 0x0 will send the fees to `msg.sender`.
1099      *                      Note, no fees are sent if the feeAmount is 0, regardless of what feeRecipient is.
1100      * @param v             The ECDSA V parameter.
1101      * @param r             The ECDSA R parameter.
1102      * @param s             The ECDSA S parameter.
1103      * @return              True if the transfer was successful or false if it failed.
1104      */
1105     function transferFromGaslessRequest(
1106         address owner,
1107         address recipient,
1108         uint nonce,
1109         uint expiry,
1110         uint amount,
1111         uint feeAmount,
1112         address feeRecipient,
1113         uint8 v,
1114         bytes32 r,
1115         bytes32 s
1116     ) external;
1117 
1118 }
1119 
1120 // File: contracts/libs/DmmTokenLibrary.sol
1121 
1122 pragma solidity ^0.5.0;
1123 
1124 
1125 
1126 
1127 library DmmTokenLibrary {
1128 
1129     using SafeERC20 for IERC20;
1130     using SafeMath for uint;
1131 
1132     /*****************
1133      * Structs
1134      */
1135 
1136     struct Storage {
1137         uint exchangeRate;
1138         uint exchangeRateLastUpdatedTimestamp;
1139         uint exchangeRateLastUpdatedBlockNumber;
1140         mapping(address => uint) nonces;
1141     }
1142 
1143     /*****************
1144      * Events
1145      */
1146 
1147     event Mint(address indexed minter, address indexed recipient, uint amount);
1148     event Redeem(address indexed redeemer, address indexed recipient, uint amount);
1149     event FeeTransfer(address indexed owner, address indexed recipient, uint amount);
1150 
1151     event OffChainRequestValidated(address indexed owner, address indexed feeRecipient, uint nonce, uint expiry, uint feeAmount);
1152 
1153     /*****************
1154      * Public Constants
1155      */
1156 
1157     uint public constant INTEREST_RATE_BASE = 1e18;
1158     uint public constant SECONDS_IN_YEAR = 31536000; // 60 * 60 * 24 * 365
1159 
1160     /**********************
1161      * Public Functions
1162      */
1163 
1164     function amountToUnderlying(uint amount, uint exchangeRate, uint exchangeRateBaseRate) internal pure returns (uint) {
1165         return (amount.mul(exchangeRate)).div(exchangeRateBaseRate);
1166     }
1167 
1168     function underlyingToAmount(uint underlyingAmount, uint exchangeRate, uint exchangeRateBaseRate) internal pure returns (uint) {
1169         return (underlyingAmount.mul(exchangeRateBaseRate)).div(exchangeRate);
1170     }
1171 
1172     function accrueInterest(uint exchangeRate, uint interestRate, uint _seconds) internal pure returns (uint) {
1173         uint interestAccrued = INTEREST_RATE_BASE.add(((interestRate.mul(_seconds)).div(SECONDS_IN_YEAR)));
1174         return (exchangeRate.mul(interestAccrued)).div(INTEREST_RATE_BASE);
1175     }
1176 
1177     /***************************
1178      * Internal User Functions
1179      */
1180 
1181     function getCurrentExchangeRate(Storage storage _storage, uint interestRate) internal view returns (uint) {
1182         if (_storage.exchangeRateLastUpdatedTimestamp >= block.timestamp) {
1183             // The exchange rate has not changed yet
1184             return _storage.exchangeRate;
1185         } else {
1186             uint diffInSeconds = block.timestamp.sub(_storage.exchangeRateLastUpdatedTimestamp, "INVALID_BLOCK_TIMESTAMP");
1187             return accrueInterest(_storage.exchangeRate, interestRate, diffInSeconds);
1188         }
1189     }
1190 
1191     function updateExchangeRateIfNecessaryAndGet(IDmmToken token, Storage storage _storage) internal returns (uint) {
1192         uint previousExchangeRate = _storage.exchangeRate;
1193         uint dmmTokenInterestRate = token.controller().getInterestRateByDmmTokenAddress(address(token));
1194         uint currentExchangeRate = getCurrentExchangeRate(_storage, dmmTokenInterestRate);
1195         if (currentExchangeRate != previousExchangeRate) {
1196             _storage.exchangeRateLastUpdatedTimestamp = block.timestamp;
1197             _storage.exchangeRateLastUpdatedBlockNumber = block.number;
1198             _storage.exchangeRate = currentExchangeRate;
1199             return currentExchangeRate;
1200         } else {
1201             return currentExchangeRate;
1202         }
1203     }
1204 
1205     function validateOffChainMint(
1206         Storage storage _storage,
1207         bytes32 domainSeparator,
1208         bytes32 typeHash,
1209         address owner,
1210         address recipient,
1211         uint nonce,
1212         uint expiry,
1213         uint amount,
1214         uint feeAmount,
1215         address feeRecipient,
1216         uint8 v,
1217         bytes32 r,
1218         bytes32 s
1219     ) internal {
1220         bytes32 digest = keccak256(
1221             abi.encodePacked(
1222                 "\x19\x01",
1223                 domainSeparator,
1224                 keccak256(abi.encode(typeHash, owner, recipient, nonce, expiry, amount, feeAmount, feeRecipient))
1225             )
1226         );
1227 
1228         require(owner != address(0), "CANNOT_MINT_FROM_ZERO_ADDRESS");
1229         require(recipient != address(0), "CANNOT_MINT_TO_ZERO_ADDRESS");
1230         validateOffChainRequest(_storage, digest, owner, nonce, expiry, feeAmount, feeRecipient, v, r, s);
1231     }
1232 
1233     function validateOffChainRedeem(
1234         Storage storage _storage,
1235         bytes32 domainSeparator,
1236         bytes32 typeHash,
1237         address owner,
1238         address recipient,
1239         uint nonce,
1240         uint expiry,
1241         uint amount,
1242         uint feeAmount,
1243         address feeRecipient,
1244         uint8 v,
1245         bytes32 r,
1246         bytes32 s
1247     ) internal {
1248         bytes32 digest = keccak256(
1249             abi.encodePacked(
1250                 "\x19\x01",
1251                 domainSeparator,
1252                 keccak256(abi.encode(typeHash, owner, recipient, nonce, expiry, amount, feeAmount, feeRecipient))
1253             )
1254         );
1255 
1256         require(owner != address(0), "CANNOT_REDEEM_FROM_ZERO_ADDRESS");
1257         require(recipient != address(0), "CANNOT_REDEEM_TO_ZERO_ADDRESS");
1258         validateOffChainRequest(_storage, digest, owner, nonce, expiry, feeAmount, feeRecipient, v, r, s);
1259     }
1260 
1261     function validateOffChainPermit(
1262         Storage storage _storage,
1263         bytes32 domainSeparator,
1264         bytes32 typeHash,
1265         address owner,
1266         address spender,
1267         uint nonce,
1268         uint expiry,
1269         bool allowed,
1270         uint feeAmount,
1271         address feeRecipient,
1272         uint8 v,
1273         bytes32 r,
1274         bytes32 s
1275     ) internal {
1276         bytes32 digest = keccak256(
1277             abi.encodePacked(
1278                 "\x19\x01",
1279                 domainSeparator,
1280                 keccak256(abi.encode(typeHash, owner, spender, nonce, expiry, allowed, feeAmount, feeRecipient))
1281             )
1282         );
1283 
1284         require(owner != address(0), "CANNOT_APPROVE_FROM_ZERO_ADDRESS");
1285         require(spender != address(0), "CANNOT_APPROVE_TO_ZERO_ADDRESS");
1286         validateOffChainRequest(_storage, digest, owner, nonce, expiry, feeAmount, feeRecipient, v, r, s);
1287     }
1288 
1289     function validateOffChainTransfer(
1290         Storage storage _storage,
1291         bytes32 domainSeparator,
1292         bytes32 typeHash,
1293         address owner,
1294         address recipient,
1295         uint nonce,
1296         uint expiry,
1297         uint amount,
1298         uint feeAmount,
1299         address feeRecipient,
1300         uint8 v,
1301         bytes32 r,
1302         bytes32 s
1303     ) internal {
1304         bytes32 digest = keccak256(
1305             abi.encodePacked(
1306                 "\x19\x01",
1307                 domainSeparator,
1308                 keccak256(abi.encode(typeHash, owner, recipient, nonce, expiry, amount, feeAmount, feeRecipient))
1309             )
1310         );
1311 
1312         require(owner != address(0x0), "CANNOT_TRANSFER_FROM_ZERO_ADDRESS");
1313         require(recipient != address(0x0), "CANNOT_TRANSFER_TO_ZERO_ADDRESS");
1314         validateOffChainRequest(_storage, digest, owner, nonce, expiry, feeAmount, feeRecipient, v, r, s);
1315     }
1316 
1317     /***************************
1318      * Internal Admin Functions
1319      */
1320 
1321     function _depositUnderlying(IDmmToken token, address sender, uint underlyingAmount) internal returns (bool) {
1322         IERC20 underlyingToken = IERC20(token.controller().getUnderlyingTokenForDmm(address(token)));
1323         underlyingToken.safeTransferFrom(sender, address(token), underlyingAmount);
1324         return true;
1325     }
1326 
1327     function _withdrawUnderlying(IDmmToken token, address sender, uint underlyingAmount) internal returns (bool) {
1328         IERC20 underlyingToken = IERC20(token.controller().getUnderlyingTokenForDmm(address(token)));
1329         underlyingToken.safeTransfer(sender, underlyingAmount);
1330         return true;
1331     }
1332 
1333     /***************************
1334      * Private Functions
1335      */
1336 
1337     /**
1338      * @dev throws if the validation fails
1339      */
1340     function validateOffChainRequest(
1341         Storage storage _storage,
1342         bytes32 digest,
1343         address owner,
1344         uint nonce,
1345         uint expiry,
1346         uint feeAmount,
1347         address feeRecipient,
1348         uint8 v,
1349         bytes32 r,
1350         bytes32 s
1351     ) private {
1352         uint expectedNonce = _storage.nonces[owner];
1353 
1354         require(owner == ecrecover(digest, v, r, s), "INVALID_SIGNATURE");
1355         require(expiry == 0 || now <= expiry, "REQUEST_EXPIRED");
1356         require(nonce == expectedNonce, "INVALID_NONCE");
1357         if (feeAmount > 0) {
1358             require(feeRecipient != address(0x0), "INVALID_FEE_ADDRESS");
1359         }
1360 
1361         emit OffChainRequestValidated(
1362             owner,
1363             feeRecipient,
1364             expectedNonce,
1365             expiry,
1366             feeAmount
1367         );
1368         _storage.nonces[owner] += 1;
1369     }
1370 
1371 }
1372 
1373 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
1374 
1375 pragma solidity ^0.5.0;
1376 
1377 /**
1378  * @dev Contract module that helps prevent reentrant calls to a function.
1379  *
1380  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1381  * available, which can be applied to functions to make sure there are no nested
1382  * (reentrant) calls to them.
1383  *
1384  * Note that because there is a single `nonReentrant` guard, functions marked as
1385  * `nonReentrant` may not call one another. This can be worked around by making
1386  * those functions `private`, and then adding `external` `nonReentrant` entry
1387  * points to them.
1388  */
1389 contract ReentrancyGuard {
1390     // counter to allow mutex lock with only one SSTORE operation
1391     uint256 private _guardCounter;
1392 
1393     constructor () internal {
1394         // The counter starts at one to prevent changing it from zero to a non-zero
1395         // value, which is a more expensive operation.
1396         _guardCounter = 1;
1397     }
1398 
1399     /**
1400      * @dev Prevents a contract from calling itself, directly or indirectly.
1401      * Calling a `nonReentrant` function from another `nonReentrant`
1402      * function is not supported. It is possible to prevent this from happening
1403      * by making the `nonReentrant` function external, and make it call a
1404      * `private` function that does the actual work.
1405      */
1406     modifier nonReentrant() {
1407         _guardCounter += 1;
1408         uint256 localCounter = _guardCounter;
1409         _;
1410         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
1411     }
1412 }
1413 
1414 // File: contracts/interfaces/IOwnable.sol
1415 
1416 pragma solidity ^0.5.0;
1417 
1418 interface IOwnable {
1419 
1420     function owner() external view returns (address);
1421 
1422 }
1423 
1424 // File: contracts/interfaces/IPausable.sol
1425 
1426 pragma solidity ^0.5.0;
1427 
1428 interface IPausable {
1429 
1430     function paused() external view returns (bool);
1431 
1432 }
1433 
1434 // File: contracts/utils/ERC20.sol
1435 
1436 pragma solidity ^0.5.0;
1437 
1438 
1439 
1440 
1441 
1442 
1443 
1444 
1445 
1446 /**
1447  * @dev Implementation of the {IERC20} interface.
1448  *
1449  * This implementation is agnostic to the way tokens are created. This means
1450  * that a supply mechanism has to be added in a derived contract using {_mint}.
1451  * For a generic mechanism see {ERC20Mintable}.
1452  *
1453  * TIP: For a detailed writeup see our guide
1454  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1455  * to implement supply mechanisms].
1456  *
1457  * We have followed general OpenZeppelin guidelines: functions revert instead
1458  * of returning `false` on failure. This behavior is nonetheless conventional
1459  * and does not conflict with the expectations of ERC20 applications.
1460  *
1461  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1462  * This allows applications to reconstruct the allowance for all accounts just
1463  * by listening to said events. Other implementations of the EIP may not emit
1464  * these events, as it isn't required by the specification.
1465  *
1466  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1467  * functions have been added to mitigate the well-known issues around setting
1468  * allowances. See {IERC20-approve}.
1469  */
1470 contract ERC20 is Context, IERC20, ReentrancyGuard, Ownable {
1471 
1472     using SafeMath for uint256;
1473 
1474     mapping(address => uint256) internal _balances;
1475 
1476     mapping(address => mapping(address => uint256)) internal _allowances;
1477 
1478     uint256 internal _totalSupply;
1479 
1480     constructor() public {}
1481 
1482     /********************
1483      * Modifiers
1484      */
1485 
1486     modifier whenNotPaused() {
1487         require(!IPausable(pausable()).paused(), "ECOSYSTEM_PAUSED");
1488         _;
1489     }
1490 
1491     /**
1492      * @dev Throws if `account` is blacklisted
1493      *
1494      * @param account The address to check
1495     */
1496     modifier notBlacklisted(address account) {
1497         require(Blacklistable(blacklistable()).isBlacklisted(account) == false, "BLACKLISTED");
1498         _;
1499     }
1500 
1501     /********************
1502      * Public Functions
1503      */
1504 
1505     function pausable() public view returns (address);
1506 
1507     function blacklistable() public view returns (Blacklistable);
1508 
1509     /**
1510      * @dev See {IERC20-totalSupply}.
1511      */
1512     function totalSupply() public view returns (uint256) {
1513         return _totalSupply;
1514     }
1515 
1516     /**
1517      * @dev See {IERC20-balanceOf}.
1518      */
1519     function balanceOf(address account) public view returns (uint256) {
1520         return _balances[account];
1521     }
1522 
1523     /**
1524      * @dev See {IERC20-transfer}.
1525      *
1526      * Requirements:
1527      *
1528      * - `recipient` cannot be the zero address.
1529      * - the caller must have a balance of at least `amount`.
1530      */
1531     function transfer(
1532         address recipient,
1533         uint256 amount
1534     )
1535     nonReentrant
1536     public returns (bool) {
1537         _transfer(_msgSender(), recipient, amount);
1538         return true;
1539     }
1540 
1541     /**
1542      * @dev See {IERC20-allowance}.
1543      */
1544     function allowance(address owner, address spender) public view returns (uint256) {
1545         return _allowances[owner][spender];
1546     }
1547 
1548     /**
1549      * @dev See {IERC20-approve}.
1550      *
1551      * Requirements:
1552      *
1553      * - `spender` cannot be the zero address.
1554      */
1555     function approve(
1556         address spender,
1557         uint256 amount
1558     )
1559     public returns (bool) {
1560         _approve(_msgSender(), spender, amount);
1561         return true;
1562     }
1563 
1564     /**
1565      * @dev See {IERC20-transferFrom}.
1566      *
1567      * Emits an {Approval} event indicating the updated allowance. This is not
1568      * required by the EIP. See the note at the beginning of {ERC20};
1569      *
1570      * Requirements:
1571      * - `sender` and `recipient` cannot be the zero address.
1572      * - `sender` must have a balance of at least `amount`.
1573      * - the caller must have allowance for `sender`'s tokens of at least
1574      * `amount`.
1575      */
1576     function transferFrom(
1577         address sender,
1578         address recipient,
1579         uint256 amount
1580     )
1581     nonReentrant
1582     public returns (bool) {
1583         _transfer(sender, recipient, amount);
1584         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "TRANSFER_EXCEEDS_ALLOWANCE"));
1585         return true;
1586     }
1587 
1588     /**
1589      * @dev Atomically increases the allowance granted to `spender` by the caller.
1590      *
1591      * This is an alternative to {approve} that can be used as a mitigation for
1592      * problems described in {IERC20-approve}.
1593      *
1594      * Emits an {Approval} event indicating the updated allowance.
1595      *
1596      * Requirements:
1597      *
1598      * - `spender` cannot be the zero address.
1599      */
1600     function increaseAllowance(
1601         address spender,
1602         uint256 addedValue
1603     )
1604     notBlacklisted(_msgSender())
1605     notBlacklisted(spender)
1606     public returns (bool) {
1607         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1608         return true;
1609     }
1610 
1611     /**
1612      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1613      *
1614      * This is an alternative to {approve} that can be used as a mitigation for
1615      * problems described in {IERC20-approve}.
1616      *
1617      * Emits an {Approval} event indicating the updated allowance.
1618      *
1619      * Requirements:
1620      *
1621      * - `spender` cannot be the zero address.
1622      * - `spender` must have allowance for the caller of at least
1623      * `subtractedValue`.
1624      */
1625     function decreaseAllowance(
1626         address spender,
1627         uint256 subtractedValue
1628     )
1629     notBlacklisted(_msgSender())
1630     notBlacklisted(spender)
1631     public returns (bool) {
1632         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ALLOWANCE_BELOW_ZERO"));
1633         return true;
1634     }
1635 
1636     /**************************
1637      * Internal Functions
1638      */
1639 
1640     /**
1641      * @dev Moves tokens `amount` from `sender` to `recipient`.
1642      *
1643      * This is internal function is equivalent to {transfer}, and can be used to
1644      * e.g. implement automatic token fees, slashing mechanisms, etc.
1645      *
1646      * Emits a {Transfer} event.
1647      *
1648      * Requirements:
1649      *
1650      * - `sender` cannot be the zero address.
1651      * - `recipient` cannot be the zero address.
1652      * - `sender` must have a balance of at least `amount`.
1653      */
1654     function _transfer(address sender, address recipient, uint256 amount) internal {
1655         require(sender != address(0), "CANNOT_TRANSFER_FROM_ZERO_ADDRESS");
1656         require(recipient != address(0), "CANNOT_TRANSFER_TO_ZERO_ADDRESS");
1657 
1658         blacklistable().checkNotBlacklisted(_msgSender());
1659         blacklistable().checkNotBlacklisted(sender);
1660         blacklistable().checkNotBlacklisted(recipient);
1661 
1662         _balances[sender] = _balances[sender].sub(amount, "TRANSFER_EXCEEDS_BALANCE");
1663         _balances[recipient] = _balances[recipient].add(amount);
1664         emit Transfer(sender, recipient, amount);
1665     }
1666 
1667     /**
1668      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1669      *
1670      * This is internal function is equivalent to `approve`, and can be used to
1671      * e.g. set automatic allowances for certain subsystems, etc.
1672      *
1673      * Emits an {Approval} event.
1674      *
1675      * Requirements:
1676      *
1677      * - `owner` cannot be the zero address.
1678      * - `spender` cannot be the zero address.
1679      */
1680     function _approve(address owner, address spender, uint256 amount) internal {
1681         require(owner != address(0), "CANNOT_APPROVE_FROM_ZERO_ADDRESS");
1682         require(spender != address(0), "CANNOT_APPROVE_TO_ZERO_ADDRESS");
1683 
1684         blacklistable().checkNotBlacklisted(_msgSender());
1685         blacklistable().checkNotBlacklisted(owner);
1686         blacklistable().checkNotBlacklisted(spender);
1687 
1688         _allowances[owner][spender] = amount;
1689         emit Approval(owner, spender, amount);
1690     }
1691 
1692     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1693      * the total supply.
1694      *
1695      * Emits a {Transfer} event with `from` set to the zero address.
1696      */
1697     function mintToThisContract(uint256 amount) internal {
1698         address account = address(this);
1699         _totalSupply = _totalSupply.add(amount);
1700         _balances[account] = _balances[account].add(amount);
1701         emit Transfer(address(0), account, amount);
1702     }
1703 
1704     /**
1705     * @dev Destroys `amount` tokens from `account`, reducing the
1706     * total supply.
1707     *
1708     * Emits a {Transfer} event with `to` set to the zero address.
1709     *
1710     * Requirements
1711     *
1712     * - `address(this)` must have at least `amount` tokens.
1713     */
1714     function burnFromThisContract(uint256 amount) internal {
1715         address account = address(this);
1716         _balances[account] = _balances[account].sub(amount, "BURN_EXCEEDS_BALANCE");
1717         _totalSupply = _totalSupply.sub(amount);
1718         emit Transfer(account, address(0), amount);
1719     }
1720 
1721 }
1722 
1723 // File: contracts/impl/DmmToken.sol
1724 
1725 pragma solidity ^0.5.12;
1726 
1727 
1728 
1729 
1730 
1731 
1732 
1733 contract DmmToken is ERC20, IDmmToken, CommonConstants {
1734 
1735     using SafeERC20 for IERC20;
1736     using SafeMath for uint;
1737     using DmmTokenLibrary for *;
1738 
1739     /***************************
1740      * Public Constant Fields
1741      */
1742 
1743     // bytes32 public constant PERMIT_TYPE_HASH = keccak256("Permit(address holder,address spender,uint256 nonce,uint256 expiry,bool allowed,uint256 feeAmount,address feeRecipient)");
1744     bytes32 public constant PERMIT_TYPE_HASH = 0x22fa96956322098f6fd394e06f1b7e0f6930565923f9ad3d20802e9a2eb58fb1;
1745 
1746     // bytes32 public constant TRANSFER_TYPE_HASH = keccak256("Transfer(address owner,address recipient,uint256 nonce,uint256 expiry,uint amount,uint256 feeAmount,address feeRecipient)");
1747     bytes32 public constant TRANSFER_TYPE_HASH = 0x25166116e36b48414096856a22ea40032193e38f65136c76738e306be6abd587;
1748 
1749     // bytes32 public constant MINT_TYPE_HASH = keccak256("Mint(address owner,address recipient,uint256 nonce,uint256 expiry,uint256 amount,uint256 feeAmount,address feeRecipient)");
1750     bytes32 public constant MINT_TYPE_HASH = 0x82e81310e0eab12a427992778464769ef831d801011489bc90ed3ef82f2cb3d1;
1751 
1752     // bytes32 public constant REDEEM_TYPE_HASH = keccak256("Redeem(address owner,address recipient,uint256 nonce,uint256 expiry,uint256 amount,uint256 feeAmount,address feeRecipient)");
1753     bytes32 public constant REDEEM_TYPE_HASH = 0x24e7162538bf7f86bd3180c9ee9f60f06db3bd66eb344ea3b00f69b84af5ddcf;
1754 
1755     /*****************
1756      * Public Fields
1757      */
1758 
1759     string public symbol;
1760     string public name;
1761     uint8 public decimals;
1762     uint public minMintAmount;
1763     uint public minRedeemAmount;
1764 
1765     IDmmController public controller;
1766     bytes32 public domainSeparator;
1767 
1768     /*****************
1769      * Private Fields
1770      */
1771 
1772     DmmTokenLibrary.Storage private _storage;
1773 
1774     constructor(
1775         string memory _symbol,
1776         string memory _name,
1777         uint8 _decimals,
1778         uint _minMintAmount,
1779         uint _minRedeemAmount,
1780         uint _totalSupply,
1781         address _controller
1782     ) public {
1783         symbol = _symbol;
1784         name = _name;
1785         decimals = _decimals;
1786         minMintAmount = _minMintAmount;
1787         minRedeemAmount = _minRedeemAmount;
1788         controller = IDmmController(_controller);
1789 
1790         uint256 chainId;
1791         assembly {chainId := chainid()}
1792 
1793         domainSeparator = keccak256(abi.encode(
1794                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
1795                 keccak256(bytes(name)),
1796                 keccak256(bytes(/* version */ "1")),
1797                 chainId,
1798                 address(this)
1799             ));
1800 
1801         _storage = DmmTokenLibrary.Storage({
1802             exchangeRate : EXCHANGE_RATE_BASE_RATE,
1803             exchangeRateLastUpdatedTimestamp : block.timestamp,
1804             exchangeRateLastUpdatedBlockNumber : block.number
1805             });
1806 
1807         mintToThisContract(_totalSupply);
1808     }
1809 
1810     /********************
1811      * Modifiers
1812      */
1813 
1814     modifier isNotDisabled {
1815         require(controller.isMarketEnabledByDmmTokenAddress(address(this)), "MARKET_DISABLED");
1816         _;
1817     }
1818 
1819     /********************
1820      * Public Functions
1821      */
1822 
1823     function() payable external {
1824         revert("NO_DEFAULT_FUNCTION");
1825     }
1826 
1827     function pausable() public view returns (address) {
1828         return address(controller);
1829     }
1830 
1831     function blacklistable() public view returns (Blacklistable) {
1832         return controller.blacklistable();
1833     }
1834 
1835     function activeSupply() public view returns (uint) {
1836         return totalSupply().sub(balanceOf(address(this)));
1837     }
1838 
1839     function increaseTotalSupply(uint amount) public onlyOwner whenNotPaused {
1840         uint oldTotalSupply = _totalSupply;
1841         mintToThisContract(amount);
1842         emit TotalSupplyIncreased(oldTotalSupply, _totalSupply);
1843     }
1844 
1845     function decreaseTotalSupply(uint amount) public onlyOwner whenNotPaused {
1846         // If there's underflow, throw the specified error
1847         require(balanceOf(address(this)) >= amount, "TOO_MUCH_ACTIVE_SUPPLY");
1848         uint oldTotalSupply = _totalSupply;
1849         burnFromThisContract(amount);
1850         emit TotalSupplyDecreased(oldTotalSupply, _totalSupply);
1851     }
1852 
1853     function depositUnderlying(uint underlyingAmount) onlyOwner whenNotPaused public returns (bool) {
1854         return this._depositUnderlying(_msgSender(), underlyingAmount);
1855     }
1856 
1857     function withdrawUnderlying(uint underlyingAmount) onlyOwner whenNotPaused public returns (bool) {
1858         return this._withdrawUnderlying(_msgSender(), underlyingAmount);
1859     }
1860 
1861     function getCurrentExchangeRate() public view returns (uint) {
1862         return _storage.getCurrentExchangeRate(controller.getInterestRateByDmmTokenAddress(address(this)));
1863     }
1864 
1865     function exchangeRateLastUpdatedTimestamp() public view returns (uint) {
1866         return _storage.exchangeRateLastUpdatedTimestamp;
1867     }
1868 
1869     function exchangeRateLastUpdatedBlockNumber() public view returns (uint) {
1870         return _storage.exchangeRateLastUpdatedBlockNumber;
1871     }
1872 
1873     function nonceOf(address owner) public view returns (uint) {
1874         return _storage.nonces[owner];
1875     }
1876 
1877     function mint(
1878         uint underlyingAmount
1879     )
1880     whenNotPaused
1881     nonReentrant
1882     isNotDisabled
1883     public returns (uint) {
1884         return _mint(_msgSender(), _msgSender(), underlyingAmount);
1885     }
1886 
1887     function transferUnderlyingIn(address owner, uint underlyingAmount) internal {
1888         address underlyingToken = controller.getUnderlyingTokenForDmm(address(this));
1889         IERC20(underlyingToken).safeTransferFrom(owner, address(this), underlyingAmount);
1890     }
1891 
1892     function transferUnderlyingOut(address recipient, uint underlyingAmount) internal {
1893         address underlyingToken = controller.getUnderlyingTokenForDmm(address(this));
1894         IERC20(underlyingToken).transfer(recipient, underlyingAmount);
1895     }
1896 
1897     function mintFromGaslessRequest(
1898         address owner,
1899         address recipient,
1900         uint nonce,
1901         uint expiry,
1902         uint underlyingAmount,
1903         uint feeAmount,
1904         address feeRecipient,
1905         uint8 v,
1906         bytes32 r,
1907         bytes32 s
1908     )
1909     whenNotPaused
1910     nonReentrant
1911     isNotDisabled
1912     public returns (uint) {
1913         return _mintFromGaslessRequest(
1914             owner,
1915             recipient,
1916             nonce,
1917             expiry,
1918             underlyingAmount,
1919             feeAmount,
1920             feeRecipient,
1921             v,
1922             r,
1923             s
1924         );
1925     }
1926 
1927     function redeem(
1928         uint amount
1929     )
1930     whenNotPaused
1931     nonReentrant
1932     public returns (uint) {
1933         return _redeem(_msgSender(), _msgSender(), amount, /* shouldUseAllowance */ false);
1934     }
1935 
1936     function redeemFromGaslessRequest(
1937         address owner,
1938         address recipient,
1939         uint nonce,
1940         uint expiry,
1941         uint amount,
1942         uint feeAmount,
1943         address feeRecipient,
1944         uint8 v,
1945         bytes32 r,
1946         bytes32 s
1947     )
1948     whenNotPaused
1949     nonReentrant
1950     public returns (uint) {
1951         return _redeemFromGaslessRequest(
1952             owner,
1953             recipient,
1954             nonce,
1955             expiry,
1956             amount,
1957             feeAmount,
1958             feeRecipient,
1959             v,
1960             r,
1961             s
1962         );
1963     }
1964 
1965     function permit(
1966         address owner,
1967         address spender,
1968         uint nonce,
1969         uint expiry,
1970         bool allowed,
1971         uint feeAmount,
1972         address feeRecipient,
1973         uint8 v,
1974         bytes32 r,
1975         bytes32 s
1976     )
1977     whenNotPaused
1978     nonReentrant
1979     public {
1980         checkGaslessBlacklist(feeRecipient);
1981 
1982         _storage.validateOffChainPermit(domainSeparator, PERMIT_TYPE_HASH, owner, spender, nonce, expiry, allowed, feeAmount, feeRecipient, v, r, s);
1983 
1984         uint wad = allowed ? uint(- 1) : 0;
1985         _approve(owner, spender, wad);
1986 
1987         doFeeTransferForDmmIfNecessary(owner, feeRecipient, feeAmount);
1988     }
1989 
1990     function transferFromGaslessRequest(
1991         address owner,
1992         address recipient,
1993         uint nonce,
1994         uint expiry,
1995         uint amount,
1996         uint feeAmount,
1997         address feeRecipient,
1998         uint8 v,
1999         bytes32 r,
2000         bytes32 s
2001     )
2002     whenNotPaused
2003     nonReentrant
2004     public {
2005         checkGaslessBlacklist(feeRecipient);
2006 
2007         _storage.validateOffChainTransfer(domainSeparator, TRANSFER_TYPE_HASH, owner, recipient, nonce, expiry, amount, feeAmount, feeRecipient, v, r, s);
2008 
2009         uint amountLessFee = amount.sub(feeAmount, "FEE_TOO_LARGE");
2010         _transfer(owner, recipient, amountLessFee);
2011         doFeeTransferForDmmIfNecessary(owner, feeRecipient, feeAmount);
2012     }
2013 
2014     /************************************
2015      * Private & Internal Functions
2016      */
2017 
2018     function _mint(address owner, address recipient, uint underlyingAmount) internal returns (uint) {
2019         // No need to check if recipient or msgSender are blacklisted because `_transfer` checks it.
2020         blacklistable().checkNotBlacklisted(owner);
2021 
2022         uint currentExchangeRate = this.updateExchangeRateIfNecessaryAndGet(_storage);
2023         uint amount = underlyingAmount.underlyingToAmount(currentExchangeRate, EXCHANGE_RATE_BASE_RATE);
2024 
2025         require(balanceOf(address(this)) >= amount, "INSUFFICIENT_DMM_LIQUIDITY");
2026 
2027         // Transfer underlying to this contract
2028         transferUnderlyingIn(owner, underlyingAmount);
2029 
2030         // Transfer DMM to the recipient
2031         _transfer(address(this), recipient, amount);
2032 
2033         emit Mint(owner, recipient, amount);
2034 
2035         require(amount >= minMintAmount, "INSUFFICIENT_MINT_AMOUNT");
2036 
2037         return amount;
2038     }
2039 
2040     /**
2041      * @dev Note, right now all invocations of this function set `shouldUseAllowance` to `false`. Reason being, all
2042      *      calls are either done via explicit off-chain signatures (and therefore the owner and recipient are explicit;
2043      *      anyone can call the function), OR the msgSender is both the owner and recipient, in which case no allowance
2044      *      should be needed to redeem funds if the user is the spender of the same user's funds.
2045      */
2046     function _redeem(address owner, address recipient, uint amount, bool shouldUseAllowance) internal returns (uint) {
2047         // No need to check owner or msgSender for blacklist because `_transfer` covers them.
2048         blacklistable().checkNotBlacklisted(recipient);
2049 
2050         uint currentExchangeRate = this.updateExchangeRateIfNecessaryAndGet(_storage);
2051         uint underlyingAmount = amount.amountToUnderlying(currentExchangeRate, EXCHANGE_RATE_BASE_RATE);
2052 
2053         IERC20 underlyingToken = IERC20(this.controller().getUnderlyingTokenForDmm(address(this)));
2054         require(underlyingToken.balanceOf(address(this)) >= underlyingAmount, "INSUFFICIENT_UNDERLYING_LIQUIDITY");
2055 
2056         if (shouldUseAllowance) {
2057             uint newAllowance = allowance(owner, _msgSender()).sub(amount, "INSUFFICIENT_ALLOWANCE");
2058             _approve(owner, _msgSender(), newAllowance);
2059         }
2060         _transfer(owner, address(this), amount);
2061 
2062         // Transfer underlying to the recipient from this contract
2063         transferUnderlyingOut(recipient, underlyingAmount);
2064 
2065         emit Redeem(owner, recipient, amount);
2066 
2067         require(amount >= minRedeemAmount, "INSUFFICIENT_REDEEM_AMOUNT");
2068 
2069         return underlyingAmount;
2070     }
2071 
2072     function _mintFromGaslessRequest(
2073         address owner,
2074         address recipient,
2075         uint nonce,
2076         uint expiry,
2077         uint underlyingAmount,
2078         uint feeAmount,
2079         address feeRecipient,
2080         uint8 v,
2081         bytes32 r,
2082         bytes32 s
2083     ) internal returns (uint) {
2084         checkGaslessBlacklist(feeRecipient);
2085 
2086         // To avoid stack too deep issues, splitting the call into 2 parts is essential.
2087         _storage.validateOffChainMint(domainSeparator, MINT_TYPE_HASH, owner, recipient, nonce, expiry, underlyingAmount, feeAmount, feeRecipient, v, r, s);
2088 
2089         // Initially, we mint to this contract so we can send handle the fees.
2090         // We don't delegate the call for transferring the underlying in, because gasless requests are designed to
2091         // allow any relayer to broadcast the user's cryptographically-secure message.
2092         uint amount = _mint(owner, address(this), underlyingAmount);
2093         require(amount >= feeAmount, "FEE_TOO_LARGE");
2094 
2095         uint amountLessFee = amount.sub(feeAmount);
2096         require(amountLessFee >= minMintAmount, "INSUFFICIENT_MINT_AMOUNT");
2097 
2098         _transfer(address(this), recipient, amountLessFee);
2099 
2100         doFeeTransferForDmmIfNecessary(address(this), feeRecipient, feeAmount);
2101 
2102         return amountLessFee;
2103     }
2104 
2105     function _redeemFromGaslessRequest(
2106         address owner,
2107         address recipient,
2108         uint nonce,
2109         uint expiry,
2110         uint amount,
2111         uint feeAmount,
2112         address feeRecipient,
2113         uint8 v,
2114         bytes32 r,
2115         bytes32 s
2116     ) internal returns (uint) {
2117         checkGaslessBlacklist(feeRecipient);
2118 
2119         // To avoid stack too deep issues, splitting the call into 2 parts is essential.
2120         _storage.validateOffChainRedeem(domainSeparator, REDEEM_TYPE_HASH, owner, recipient, nonce, expiry, amount, feeAmount, feeRecipient, v, r, s);
2121 
2122         uint amountLessFee = amount.sub(feeAmount, "FEE_TOO_LARGE");
2123         require(amountLessFee >= minRedeemAmount, "INSUFFICIENT_REDEEM_AMOUNT");
2124 
2125         uint underlyingAmount = _redeem(owner, recipient, amountLessFee, /* shouldUseAllowance */ false);
2126         doFeeTransferForDmmIfNecessary(owner, feeRecipient, feeAmount);
2127 
2128         return underlyingAmount;
2129     }
2130 
2131     function checkGaslessBlacklist(address feeRecipient) private view {
2132         if (feeRecipient != address(0x0)) {
2133             blacklistable().checkNotBlacklisted(feeRecipient);
2134         }
2135     }
2136 
2137     function doFeeTransferForDmmIfNecessary(address owner, address feeRecipient, uint feeAmount) private {
2138         if (feeAmount > 0) {
2139             require(balanceOf(owner) >= feeAmount, "INSUFFICIENT_BALANCE_FOR_FEE");
2140             _transfer(owner, feeRecipient, feeAmount);
2141             emit FeeTransfer(owner, feeRecipient, feeAmount);
2142         }
2143     }
2144 
2145 }