1 /*
2 
3     Copyright 2020 dYdX Trading Inc.
4 
5     Licensed under the Apache License, Version 2.0 (the "License");
6     you may not use this file except in compliance with the License.
7     You may obtain a copy of the License at
8 
9     http://www.apache.org/licenses/LICENSE-2.0
10 
11     Unless required by applicable law or agreed to in writing, software
12     distributed under the License is distributed on an "AS IS" BASIS,
13     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14     See the License for the specific language governing permissions and
15     limitations under the License.
16 
17 */
18 
19 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
20 
21 pragma solidity 0.5.16;
22 pragma experimental ABIEncoderV2;
23 
24 /**
25  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
26  * the optional functions; to access them see {ERC20Detailed}.
27  */
28 interface IERC20 {
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `recipient`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address recipient, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `sender` to `recipient` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Emitted when `value` tokens are moved from one account (`from`) to
86      * another (`to`).
87      *
88      * Note that `value` may be zero.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94      * a call to {approve}. `value` is the new allowance.
95      */
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 // File: @openzeppelin/contracts/math/SafeMath.sol
100 
101 /**
102  * @dev Wrappers over Solidity's arithmetic operations with added overflow
103  * checks.
104  *
105  * Arithmetic operations in Solidity wrap on overflow. This can easily result
106  * in bugs, because programmers usually assume that an overflow raises an
107  * error, which is the standard behavior in high level programming languages.
108  * `SafeMath` restores this intuition by reverting the transaction when an
109  * operation overflows.
110  *
111  * Using this library instead of the unchecked operations eliminates an entire
112  * class of bugs, so it's recommended to use it always.
113  */
114 library SafeMath {
115     /**
116      * @dev Returns the addition of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `+` operator.
120      *
121      * Requirements:
122      * - Addition cannot overflow.
123      */
124     function add(uint256 a, uint256 b) internal pure returns (uint256) {
125         uint256 c = a + b;
126         require(c >= a, "SafeMath: addition overflow");
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      * - Subtraction cannot overflow.
139      */
140     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141         return sub(a, b, "SafeMath: subtraction overflow");
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      * - Subtraction cannot overflow.
152      *
153      * _Available since v2.4.0._
154      */
155     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b <= a, errorMessage);
157         uint256 c = a - b;
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the multiplication of two unsigned integers, reverting on
164      * overflow.
165      *
166      * Counterpart to Solidity's `*` operator.
167      *
168      * Requirements:
169      * - Multiplication cannot overflow.
170      */
171     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
172         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
173         // benefit is lost if 'b' is also tested.
174         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
175         if (a == 0) {
176             return 0;
177         }
178 
179         uint256 c = a * b;
180         require(c / a == b, "SafeMath: multiplication overflow");
181 
182         return c;
183     }
184 
185     /**
186      * @dev Returns the integer division of two unsigned integers. Reverts on
187      * division by zero. The result is rounded towards zero.
188      *
189      * Counterpart to Solidity's `/` operator. Note: this function uses a
190      * `revert` opcode (which leaves remaining gas untouched) while Solidity
191      * uses an invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      * - The divisor cannot be zero.
195      */
196     function div(uint256 a, uint256 b) internal pure returns (uint256) {
197         return div(a, b, "SafeMath: division by zero");
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      * - The divisor cannot be zero.
210      *
211      * _Available since v2.4.0._
212      */
213     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
214         // Solidity only automatically asserts when dividing by 0
215         require(b > 0, errorMessage);
216         uint256 c = a / b;
217         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
218 
219         return c;
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * Reverts when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      * - The divisor cannot be zero.
232      */
233     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
234         return mod(a, b, "SafeMath: modulo by zero");
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * Reverts with custom message when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      * - The divisor cannot be zero.
247      *
248      * _Available since v2.4.0._
249      */
250     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
251         require(b != 0, errorMessage);
252         return a % b;
253     }
254 }
255 
256 // File: @openzeppelin/contracts/utils/Address.sol
257 
258 /**
259  * @dev Collection of functions related to the address type
260  */
261 library Address {
262     /**
263      * @dev Returns true if `account` is a contract.
264      *
265      * [IMPORTANT]
266      * ====
267      * It is unsafe to assume that an address for which this function returns
268      * false is an externally-owned account (EOA) and not a contract.
269      *
270      * Among others, `isContract` will return false for the following
271      * types of addresses:
272      *
273      *  - an externally-owned account
274      *  - a contract in construction
275      *  - an address where a contract will be created
276      *  - an address where a contract lived, but was destroyed
277      * ====
278      */
279     function isContract(address account) internal view returns (bool) {
280         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
281         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
282         // for accounts without code, i.e. `keccak256('')`
283         bytes32 codehash;
284         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
285         // solhint-disable-next-line no-inline-assembly
286         assembly { codehash := extcodehash(account) }
287         return (codehash != accountHash && codehash != 0x0);
288     }
289 
290     /**
291      * @dev Converts an `address` into `address payable`. Note that this is
292      * simply a type cast: the actual underlying value is not changed.
293      *
294      * _Available since v2.4.0._
295      */
296     function toPayable(address account) internal pure returns (address payable) {
297         return address(uint160(account));
298     }
299 
300     /**
301      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
302      * `recipient`, forwarding all available gas and reverting on errors.
303      *
304      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
305      * of certain opcodes, possibly making contracts go over the 2300 gas limit
306      * imposed by `transfer`, making them unable to receive funds via
307      * `transfer`. {sendValue} removes this limitation.
308      *
309      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
310      *
311      * IMPORTANT: because control is transferred to `recipient`, care must be
312      * taken to not create reentrancy vulnerabilities. Consider using
313      * {ReentrancyGuard} or the
314      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
315      *
316      * _Available since v2.4.0._
317      */
318     function sendValue(address payable recipient, uint256 amount) internal {
319         require(address(this).balance >= amount, "Address: insufficient balance");
320 
321         // solhint-disable-next-line avoid-call-value
322         (bool success, ) = recipient.call.value(amount)("");
323         require(success, "Address: unable to send value, recipient may have reverted");
324     }
325 }
326 
327 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
328 
329 /**
330  * @title SafeERC20
331  * @dev Wrappers around ERC20 operations that throw on failure (when the token
332  * contract returns false). Tokens that return no value (and instead revert or
333  * throw on failure) are also supported, non-reverting calls are assumed to be
334  * successful.
335  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
336  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
337  */
338 library SafeERC20 {
339     using SafeMath for uint256;
340     using Address for address;
341 
342     function safeTransfer(IERC20 token, address to, uint256 value) internal {
343         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
344     }
345 
346     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
347         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
348     }
349 
350     function safeApprove(IERC20 token, address spender, uint256 value) internal {
351         // safeApprove should only be called when setting an initial allowance,
352         // or when resetting it to zero. To increase and decrease it, use
353         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
354         // solhint-disable-next-line max-line-length
355         require((value == 0) || (token.allowance(address(this), spender) == 0),
356             "SafeERC20: approve from non-zero to non-zero allowance"
357         );
358         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
359     }
360 
361     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
362         uint256 newAllowance = token.allowance(address(this), spender).add(value);
363         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
364     }
365 
366     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
367         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
368         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
369     }
370 
371     /**
372      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
373      * on the return value: the return value is optional (but if data is returned, it must not be false).
374      * @param token The token targeted by the call.
375      * @param data The call data (encoded using abi.encode or one of its variants).
376      */
377     function callOptionalReturn(IERC20 token, bytes memory data) private {
378         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
379         // we're implementing it ourselves.
380 
381         // A Solidity high level call has three parts:
382         //  1. The target address is checked to verify it contains contract code
383         //  2. The call itself is made, and success asserted
384         //  3. The return value is decoded, which in turn checks the size of the returned data.
385         // solhint-disable-next-line max-line-length
386         require(address(token).isContract(), "SafeERC20: call to non-contract");
387 
388         // solhint-disable-next-line avoid-low-level-calls
389         (bool success, bytes memory returndata) = address(token).call(data);
390         require(success, "SafeERC20: low-level call failed");
391 
392         if (returndata.length > 0) { // Return data is optional
393             // solhint-disable-next-line max-line-length
394             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
395         }
396     }
397 }
398 
399 // File: contracts/external/I_ExchangeWrapper.sol
400 
401 /**
402  * @title I_ExchangeWrapper
403  * @author dYdX
404  *
405  * @notice Interface for exchange wrappers, used to trade ERC20 tokens.
406  */
407 interface I_ExchangeWrapper {
408 
409     // ============ Public Functions ============
410 
411     /**
412      * Exchange some amount of takerToken for makerToken.
413      *
414      * @param  tradeOriginator      Address of the initiator of the trade (however, this value
415      *                              cannot always be trusted as it is set at the discretion of the
416      *                              msg.sender)
417      * @param  receiver             Address to set allowance on once the trade has completed
418      * @param  makerToken           Address of makerToken, the token to receive
419      * @param  takerToken           Address of takerToken, the token to pay
420      * @param  requestedFillAmount  Amount of takerToken being paid
421      * @param  orderData            Arbitrary bytes data for any information to pass to the exchange
422      * @return                      The amount of makerToken received
423      */
424     function exchange(
425         address tradeOriginator,
426         address receiver,
427         address makerToken,
428         address takerToken,
429         uint256 requestedFillAmount,
430         bytes calldata orderData
431     )
432         external
433         returns (uint256);
434 
435     /**
436      * Get amount of takerToken required to buy a certain amount of makerToken for a given trade.
437      * Should match the takerToken amount used in exchangeForAmount. If the order cannot provide
438      * exactly desiredMakerToken, then it must return the price to buy the minimum amount greater
439      * than desiredMakerToken
440      *
441      * @param  makerToken         Address of makerToken, the token to receive
442      * @param  takerToken         Address of takerToken, the token to pay
443      * @param  desiredMakerToken  Amount of makerToken requested
444      * @param  orderData          Arbitrary bytes data for any information to pass to the exchange
445      * @return                    Amount of takerToken the needed to complete the exchange
446      */
447     function getExchangeCost(
448         address makerToken,
449         address takerToken,
450         uint256 desiredMakerToken,
451         bytes calldata orderData
452     )
453         external
454         view
455         returns (uint256);
456 }
457 
458 // File: contracts/protocol/v1/lib/P1Types.sol
459 
460 /**
461  * @title P1Types
462  * @author dYdX
463  *
464  * @dev Library for common types used in PerpetualV1 contracts.
465  */
466 library P1Types {
467     // ============ Structs ============
468 
469     /**
470      * @dev Used to represent the global index and each account's cached index.
471      *  Used to settle funding paymennts on a per-account basis.
472      */
473     struct Index {
474         uint32 timestamp;
475         bool isPositive;
476         uint128 value;
477     }
478 
479     /**
480      * @dev Used to track the signed margin balance and position balance values for each account.
481      */
482     struct Balance {
483         bool marginIsPositive;
484         bool positionIsPositive;
485         uint120 margin;
486         uint120 position;
487     }
488 
489     /**
490      * @dev Used to cache commonly-used variables that are relatively gas-intensive to obtain.
491      */
492     struct Context {
493         uint256 price;
494         uint256 minCollateral;
495         Index index;
496     }
497 
498     /**
499      * @dev Used by contracts implementing the I_P1Trader interface to return the result of a trade.
500      */
501     struct TradeResult {
502         uint256 marginAmount;
503         uint256 positionAmount;
504         bool isBuy; // From taker's perspective.
505         bytes32 traderFlags;
506     }
507 }
508 
509 // File: contracts/protocol/v1/intf/I_PerpetualV1.sol
510 
511 /**
512  * @title I_PerpetualV1
513  * @author dYdX
514  *
515  * @notice Interface for PerpetualV1.
516  */
517 interface I_PerpetualV1 {
518 
519     // ============ Structs ============
520 
521     struct TradeArg {
522         uint256 takerIndex;
523         uint256 makerIndex;
524         address trader;
525         bytes data;
526     }
527 
528     // ============ State-Changing Functions ============
529 
530     /**
531      * @notice Submits one or more trades between any number of accounts.
532      *
533      * @param  accounts  The sorted list of accounts that are involved in trades.
534      * @param  trades    The list of trades to execute in-order.
535      */
536     function trade(
537         address[] calldata accounts,
538         TradeArg[] calldata trades
539     )
540         external;
541 
542     /**
543      * @notice Withdraw the number of margin tokens equal to the value of the account at the time
544      *  that final settlement occurred.
545      */
546     function withdrawFinalSettlement()
547         external;
548 
549     /**
550      * @notice Deposit some amount of margin tokens from the msg.sender into an account.
551      *
552      * @param  account  The account for which to credit the deposit.
553      * @param  amount   the amount of tokens to deposit.
554      */
555     function deposit(
556         address account,
557         uint256 amount
558     )
559         external;
560 
561     /**
562      * @notice Withdraw some amount of margin tokens from an account to a destination address.
563      *
564      * @param  account      The account for which to debit the withdrawal.
565      * @param  destination  The address to which the tokens are transferred.
566      * @param  amount       The amount of tokens to withdraw.
567      */
568     function withdraw(
569         address account,
570         address destination,
571         uint256 amount
572     )
573         external;
574 
575     /**
576      * @notice Grants or revokes permission for another account to perform certain actions on behalf
577      *  of the sender.
578      *
579      * @param  operator  The account that is approved or disapproved.
580      * @param  approved  True for approval, false for disapproval.
581      */
582     function setLocalOperator(
583         address operator,
584         bool approved
585     )
586         external;
587 
588     // ============ Account Getters ============
589 
590     /**
591      * @notice Get the balance of an account, without accounting for changes in the index.
592      *
593      * @param  account  The address of the account to query the balances of.
594      * @return          The balances of the account.
595      */
596     function getAccountBalance(
597         address account
598     )
599         external
600         view
601         returns (P1Types.Balance memory);
602 
603     /**
604      * @notice Gets the most recently cached index of an account.
605      *
606      * @param  account  The address of the account to query the index of.
607      * @return          The index of the account.
608      */
609     function getAccountIndex(
610         address account
611     )
612         external
613         view
614         returns (P1Types.Index memory);
615 
616     /**
617      * @notice Gets the local operator status of an operator for a particular account.
618      *
619      * @param  account   The account to query the operator for.
620      * @param  operator  The address of the operator to query the status of.
621      * @return           True if the operator is a local operator of the account, false otherwise.
622      */
623     function getIsLocalOperator(
624         address account,
625         address operator
626     )
627         external
628         view
629         returns (bool);
630 
631     // ============ Global Getters ============
632 
633     /**
634      * @notice Gets the global operator status of an address.
635      *
636      * @param  operator  The address of the operator to query the status of.
637      * @return           True if the address is a global operator, false otherwise.
638      */
639     function getIsGlobalOperator(
640         address operator
641     )
642         external
643         view
644         returns (bool);
645 
646     /**
647      * @notice Gets the address of the ERC20 margin contract used for margin deposits.
648      *
649      * @return The address of the ERC20 token.
650      */
651     function getTokenContract()
652         external
653         view
654         returns (address);
655 
656     /**
657      * @notice Gets the current address of the price oracle contract.
658      *
659      * @return The address of the price oracle contract.
660      */
661     function getOracleContract()
662         external
663         view
664         returns (address);
665 
666     /**
667      * @notice Gets the current address of the funder contract.
668      *
669      * @return The address of the funder contract.
670      */
671     function getFunderContract()
672         external
673         view
674         returns (address);
675 
676     /**
677      * @notice Gets the most recently cached global index.
678      *
679      * @return The most recently cached global index.
680      */
681     function getGlobalIndex()
682         external
683         view
684         returns (P1Types.Index memory);
685 
686     /**
687      * @notice Gets minimum collateralization ratio of the protocol.
688      *
689      * @return The minimum-acceptable collateralization ratio, returned as a fixed-point number with
690      *  18 decimals of precision.
691      */
692     function getMinCollateral()
693         external
694         view
695         returns (uint256);
696 
697     /**
698      * @notice Gets the status of whether final-settlement was initiated by the Admin.
699      *
700      * @return True if final-settlement was enabled, false otherwise.
701      */
702     function getFinalSettlementEnabled()
703         external
704         view
705         returns (bool);
706 
707     // ============ Public Getters ============
708 
709     /**
710      * @notice Gets whether an address has permissions to operate an account.
711      *
712      * @param  account   The account to query.
713      * @param  operator  The address to query.
714      * @return           True if the operator has permission to operate the account,
715      *                   and false otherwise.
716      */
717     function hasAccountPermissions(
718         address account,
719         address operator
720     )
721         external
722         view
723         returns (bool);
724 
725     // ============ Authorized Getters ============
726 
727     /**
728      * @notice Gets the price returned by the oracle.
729      * @dev Only able to be called by global operators.
730      *
731      * @return The price returned by the current price oracle.
732      */
733     function getOraclePrice()
734         external
735         view
736         returns (uint256);
737 }
738 
739 // File: contracts/protocol/v1/proxies/P1CurrencyConverterProxy.sol
740 
741 /**
742  * @title P1CurrencyConverterProxy
743  * @author dYdX
744  *
745  * @notice Proxy contract which executes a trade via an ExchangeWrapper before making a deposit
746  *  or after making a withdrawal.
747  */
748 contract P1CurrencyConverterProxy {
749     using SafeERC20 for IERC20;
750 
751     // ============ Events ============
752 
753     event LogConvertedDeposit(
754         address indexed account,
755         address source,
756         address perpetual,
757         address exchangeWrapper,
758         address tokenFrom,
759         address tokenTo,
760         uint256 tokenFromAmount,
761         uint256 tokenToAmount
762     );
763 
764     event LogConvertedWithdrawal(
765         address indexed account,
766         address destination,
767         address perpetual,
768         address exchangeWrapper,
769         address tokenFrom,
770         address tokenTo,
771         uint256 tokenFromAmount,
772         uint256 tokenToAmount
773     );
774 
775     // ============ State-Changing Functions ============
776 
777     /**
778      * @notice Sets the maximum allowance on the Perpetual contract. Must be called at least once
779      *  on a given Perpetual before deposits can be made.
780      * @dev Cannot be run in the constructor due to technical restrictions in Solidity.
781      */
782     function approveMaximumOnPerpetual(
783         address perpetual
784     )
785         external
786     {
787         IERC20 tokenContract = IERC20(I_PerpetualV1(perpetual).getTokenContract());
788 
789         // safeApprove requires unsetting the allowance first.
790         tokenContract.safeApprove(perpetual, 0);
791 
792         // Set the allowance to the highest possible value.
793         tokenContract.safeApprove(perpetual, uint256(-1));
794     }
795 
796     /**
797      * @notice Make a margin deposit to a Perpetual, after converting funds to the margin currency.
798      *  Funds will be withdrawn from the sender and deposited into the specified account.
799      * @dev Emits LogConvertedDeposit event.
800      *
801      * @param  account          The account for which to credit the deposit.
802      * @param  perpetual        The PerpetualV1 contract to deposit to.
803      * @param  exchangeWrapper  The ExchangeWrapper contract to trade with.
804      * @param  tokenFrom        The token to convert from.
805      * @param  tokenFromAmount  The amount of `tokenFrom` tokens to deposit.
806      * @param  data             Trade parameters for the ExchangeWrapper.
807      */
808     function deposit(
809         address account,
810         address perpetual,
811         address exchangeWrapper,
812         address tokenFrom,
813         uint256 tokenFromAmount,
814         bytes calldata data
815     )
816         external
817         returns (uint256)
818     {
819         I_PerpetualV1 perpetualContract = I_PerpetualV1(perpetual);
820         address tokenTo = perpetualContract.getTokenContract();
821         address self = address(this);
822 
823         // Send fromToken to the ExchangeWrapper.
824         //
825         // TODO: Take possible ERC20 fee into account.
826         IERC20(tokenFrom).safeTransferFrom(
827             msg.sender,
828             exchangeWrapper,
829             tokenFromAmount
830         );
831 
832         // Convert fromToken to toToken on the ExchangeWrapper.
833         I_ExchangeWrapper exchangeWrapperContract = I_ExchangeWrapper(exchangeWrapper);
834         uint256 tokenToAmount = exchangeWrapperContract.exchange(
835             msg.sender,
836             self,
837             tokenTo,
838             tokenFrom,
839             tokenFromAmount,
840             data
841         );
842 
843         // Receive toToken from the ExchangeWrapper.
844         IERC20(tokenTo).safeTransferFrom(
845             exchangeWrapper,
846             self,
847             tokenToAmount
848         );
849 
850         // Deposit toToken to the Perpetual.
851         perpetualContract.deposit(
852             account,
853             tokenToAmount
854         );
855 
856         // Log the result.
857         emit LogConvertedDeposit(
858             account,
859             msg.sender,
860             perpetual,
861             exchangeWrapper,
862             tokenFrom,
863             tokenTo,
864             tokenFromAmount,
865             tokenToAmount
866         );
867 
868         return tokenToAmount;
869     }
870 
871     /**
872      * @notice Withdraw margin from a Perpetual, then convert the funds to another currency. Funds
873      *  will be withdrawn from the specified account and transfered to the specified destination.
874      * @dev Emits LogConvertedWithdrawal event.
875      *
876      * @param  account          The account to withdraw from.
877      * @param  destination      The address to send the withdrawn funds to.
878      * @param  perpetual        The PerpetualV1 contract to withdraw from to.
879      * @param  exchangeWrapper  The ExchangeWrapper contract to trade with.
880      * @param  tokenTo          The token to convert to.
881      * @param  tokenFromAmount  The amount of `tokenFrom` tokens to withdraw.
882      * @param  data             Trade parameters for the ExchangeWrapper.
883      */
884     function withdraw(
885         address account,
886         address destination,
887         address perpetual,
888         address exchangeWrapper,
889         address tokenTo,
890         uint256 tokenFromAmount,
891         bytes calldata data
892     )
893         external
894         returns (uint256)
895     {
896         I_PerpetualV1 perpetualContract = I_PerpetualV1(perpetual);
897         address tokenFrom = perpetualContract.getTokenContract();
898         address self = address(this);
899 
900         // Verify that the sender has permission to withdraw from the account.
901         require(
902             account == msg.sender || perpetualContract.hasAccountPermissions(account, msg.sender),
903             "msg.sender cannot operate the account"
904         );
905 
906         // Withdraw fromToken from the Perpetual.
907         perpetualContract.withdraw(
908             account,
909             exchangeWrapper,
910             tokenFromAmount
911         );
912 
913         // Convert fromToken to toToken on the ExchangeWrapper.
914         I_ExchangeWrapper exchangeWrapperContract = I_ExchangeWrapper(exchangeWrapper);
915         uint256 tokenToAmount = exchangeWrapperContract.exchange(
916             msg.sender,
917             self,
918             tokenTo,
919             tokenFrom,
920             tokenFromAmount,
921             data
922         );
923 
924         // Transfer toToken from the ExchangeWrapper to the destination address.
925         IERC20(tokenTo).safeTransferFrom(
926             exchangeWrapper,
927             destination,
928             tokenToAmount
929         );
930 
931         // Log the result.
932         emit LogConvertedWithdrawal(
933             account,
934             destination,
935             perpetual,
936             exchangeWrapper,
937             tokenFrom,
938             tokenTo,
939             tokenFromAmount,
940             tokenToAmount
941         );
942 
943         return tokenToAmount;
944     }
945 }