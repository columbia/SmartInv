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
19 pragma solidity 0.5.16;
20 pragma experimental ABIEncoderV2;
21 
22 // File: canonical-weth/contracts/WETH9.sol
23 
24 contract WETH9 {
25     string public name     = "Wrapped Ether";
26     string public symbol   = "WETH";
27     uint8  public decimals = 18;
28 
29     event  Approval(address indexed src, address indexed guy, uint wad);
30     event  Transfer(address indexed src, address indexed dst, uint wad);
31     event  Deposit(address indexed dst, uint wad);
32     event  Withdrawal(address indexed src, uint wad);
33 
34     mapping (address => uint)                       public  balanceOf;
35     mapping (address => mapping (address => uint))  public  allowance;
36 
37     function() external payable {
38         deposit();
39     }
40     function deposit() public payable {
41         balanceOf[msg.sender] += msg.value;
42         emit Deposit(msg.sender, msg.value);
43     }
44     function withdraw(uint wad) public {
45         require(balanceOf[msg.sender] >= wad);
46         balanceOf[msg.sender] -= wad;
47         msg.sender.transfer(wad);
48         emit Withdrawal(msg.sender, wad);
49     }
50 
51     function totalSupply() public view returns (uint) {
52         return address(this).balance;
53     }
54 
55     function approve(address guy, uint wad) public returns (bool) {
56         allowance[msg.sender][guy] = wad;
57         emit Approval(msg.sender, guy, wad);
58         return true;
59     }
60 
61     function transfer(address dst, uint wad) public returns (bool) {
62         return transferFrom(msg.sender, dst, wad);
63     }
64 
65     function transferFrom(address src, address dst, uint wad)
66         public
67         returns (bool)
68     {
69         require(balanceOf[src] >= wad);
70 
71         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
72             require(allowance[src][msg.sender] >= wad);
73             allowance[src][msg.sender] -= wad;
74         }
75 
76         balanceOf[src] -= wad;
77         balanceOf[dst] += wad;
78 
79         emit Transfer(src, dst, wad);
80 
81         return true;
82     }
83 }
84 
85 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
86 
87 /**
88  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
89  * the optional functions; to access them see {ERC20Detailed}.
90  */
91 interface IERC20 {
92     /**
93      * @dev Returns the amount of tokens in existence.
94      */
95     function totalSupply() external view returns (uint256);
96 
97     /**
98      * @dev Returns the amount of tokens owned by `account`.
99      */
100     function balanceOf(address account) external view returns (uint256);
101 
102     /**
103      * @dev Moves `amount` tokens from the caller's account to `recipient`.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transfer(address recipient, uint256 amount) external returns (bool);
110 
111     /**
112      * @dev Returns the remaining number of tokens that `spender` will be
113      * allowed to spend on behalf of `owner` through {transferFrom}. This is
114      * zero by default.
115      *
116      * This value changes when {approve} or {transferFrom} are called.
117      */
118     function allowance(address owner, address spender) external view returns (uint256);
119 
120     /**
121      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * IMPORTANT: Beware that changing an allowance with this method brings the risk
126      * that someone may use both the old and the new allowance by unfortunate
127      * transaction ordering. One possible solution to mitigate this race
128      * condition is to first reduce the spender's allowance to 0 and set the
129      * desired value afterwards:
130      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131      *
132      * Emits an {Approval} event.
133      */
134     function approve(address spender, uint256 amount) external returns (bool);
135 
136     /**
137      * @dev Moves `amount` tokens from `sender` to `recipient` using the
138      * allowance mechanism. `amount` is then deducted from the caller's
139      * allowance.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * Emits a {Transfer} event.
144      */
145     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
146 
147     /**
148      * @dev Emitted when `value` tokens are moved from one account (`from`) to
149      * another (`to`).
150      *
151      * Note that `value` may be zero.
152      */
153     event Transfer(address indexed from, address indexed to, uint256 value);
154 
155     /**
156      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
157      * a call to {approve}. `value` is the new allowance.
158      */
159     event Approval(address indexed owner, address indexed spender, uint256 value);
160 }
161 
162 // File: @openzeppelin/contracts/math/SafeMath.sol
163 
164 /**
165  * @dev Wrappers over Solidity's arithmetic operations with added overflow
166  * checks.
167  *
168  * Arithmetic operations in Solidity wrap on overflow. This can easily result
169  * in bugs, because programmers usually assume that an overflow raises an
170  * error, which is the standard behavior in high level programming languages.
171  * `SafeMath` restores this intuition by reverting the transaction when an
172  * operation overflows.
173  *
174  * Using this library instead of the unchecked operations eliminates an entire
175  * class of bugs, so it's recommended to use it always.
176  */
177 library SafeMath {
178     /**
179      * @dev Returns the addition of two unsigned integers, reverting on
180      * overflow.
181      *
182      * Counterpart to Solidity's `+` operator.
183      *
184      * Requirements:
185      * - Addition cannot overflow.
186      */
187     function add(uint256 a, uint256 b) internal pure returns (uint256) {
188         uint256 c = a + b;
189         require(c >= a, "SafeMath: addition overflow");
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the subtraction of two unsigned integers, reverting on
196      * overflow (when the result is negative).
197      *
198      * Counterpart to Solidity's `-` operator.
199      *
200      * Requirements:
201      * - Subtraction cannot overflow.
202      */
203     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
204         return sub(a, b, "SafeMath: subtraction overflow");
205     }
206 
207     /**
208      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
209      * overflow (when the result is negative).
210      *
211      * Counterpart to Solidity's `-` operator.
212      *
213      * Requirements:
214      * - Subtraction cannot overflow.
215      *
216      * _Available since v2.4.0._
217      */
218     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b <= a, errorMessage);
220         uint256 c = a - b;
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the multiplication of two unsigned integers, reverting on
227      * overflow.
228      *
229      * Counterpart to Solidity's `*` operator.
230      *
231      * Requirements:
232      * - Multiplication cannot overflow.
233      */
234     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
235         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
236         // benefit is lost if 'b' is also tested.
237         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
238         if (a == 0) {
239             return 0;
240         }
241 
242         uint256 c = a * b;
243         require(c / a == b, "SafeMath: multiplication overflow");
244 
245         return c;
246     }
247 
248     /**
249      * @dev Returns the integer division of two unsigned integers. Reverts on
250      * division by zero. The result is rounded towards zero.
251      *
252      * Counterpart to Solidity's `/` operator. Note: this function uses a
253      * `revert` opcode (which leaves remaining gas untouched) while Solidity
254      * uses an invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      * - The divisor cannot be zero.
258      */
259     function div(uint256 a, uint256 b) internal pure returns (uint256) {
260         return div(a, b, "SafeMath: division by zero");
261     }
262 
263     /**
264      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
265      * division by zero. The result is rounded towards zero.
266      *
267      * Counterpart to Solidity's `/` operator. Note: this function uses a
268      * `revert` opcode (which leaves remaining gas untouched) while Solidity
269      * uses an invalid opcode to revert (consuming all remaining gas).
270      *
271      * Requirements:
272      * - The divisor cannot be zero.
273      *
274      * _Available since v2.4.0._
275      */
276     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
277         // Solidity only automatically asserts when dividing by 0
278         require(b > 0, errorMessage);
279         uint256 c = a / b;
280         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
281 
282         return c;
283     }
284 
285     /**
286      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
287      * Reverts when dividing by zero.
288      *
289      * Counterpart to Solidity's `%` operator. This function uses a `revert`
290      * opcode (which leaves remaining gas untouched) while Solidity uses an
291      * invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      * - The divisor cannot be zero.
295      */
296     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
297         return mod(a, b, "SafeMath: modulo by zero");
298     }
299 
300     /**
301      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
302      * Reverts with custom message when dividing by zero.
303      *
304      * Counterpart to Solidity's `%` operator. This function uses a `revert`
305      * opcode (which leaves remaining gas untouched) while Solidity uses an
306      * invalid opcode to revert (consuming all remaining gas).
307      *
308      * Requirements:
309      * - The divisor cannot be zero.
310      *
311      * _Available since v2.4.0._
312      */
313     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
314         require(b != 0, errorMessage);
315         return a % b;
316     }
317 }
318 
319 // File: @openzeppelin/contracts/utils/Address.sol
320 
321 /**
322  * @dev Collection of functions related to the address type
323  */
324 library Address {
325     /**
326      * @dev Returns true if `account` is a contract.
327      *
328      * [IMPORTANT]
329      * ====
330      * It is unsafe to assume that an address for which this function returns
331      * false is an externally-owned account (EOA) and not a contract.
332      *
333      * Among others, `isContract` will return false for the following
334      * types of addresses:
335      *
336      *  - an externally-owned account
337      *  - a contract in construction
338      *  - an address where a contract will be created
339      *  - an address where a contract lived, but was destroyed
340      * ====
341      */
342     function isContract(address account) internal view returns (bool) {
343         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
344         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
345         // for accounts without code, i.e. `keccak256('')`
346         bytes32 codehash;
347         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
348         // solhint-disable-next-line no-inline-assembly
349         assembly { codehash := extcodehash(account) }
350         return (codehash != accountHash && codehash != 0x0);
351     }
352 
353     /**
354      * @dev Converts an `address` into `address payable`. Note that this is
355      * simply a type cast: the actual underlying value is not changed.
356      *
357      * _Available since v2.4.0._
358      */
359     function toPayable(address account) internal pure returns (address payable) {
360         return address(uint160(account));
361     }
362 
363     /**
364      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
365      * `recipient`, forwarding all available gas and reverting on errors.
366      *
367      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
368      * of certain opcodes, possibly making contracts go over the 2300 gas limit
369      * imposed by `transfer`, making them unable to receive funds via
370      * `transfer`. {sendValue} removes this limitation.
371      *
372      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
373      *
374      * IMPORTANT: because control is transferred to `recipient`, care must be
375      * taken to not create reentrancy vulnerabilities. Consider using
376      * {ReentrancyGuard} or the
377      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
378      *
379      * _Available since v2.4.0._
380      */
381     function sendValue(address payable recipient, uint256 amount) internal {
382         require(address(this).balance >= amount, "Address: insufficient balance");
383 
384         // solhint-disable-next-line avoid-call-value
385         (bool success, ) = recipient.call.value(amount)("");
386         require(success, "Address: unable to send value, recipient may have reverted");
387     }
388 }
389 
390 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
391 
392 /**
393  * @title SafeERC20
394  * @dev Wrappers around ERC20 operations that throw on failure (when the token
395  * contract returns false). Tokens that return no value (and instead revert or
396  * throw on failure) are also supported, non-reverting calls are assumed to be
397  * successful.
398  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
399  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
400  */
401 library SafeERC20 {
402     using SafeMath for uint256;
403     using Address for address;
404 
405     function safeTransfer(IERC20 token, address to, uint256 value) internal {
406         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
407     }
408 
409     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
410         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
411     }
412 
413     function safeApprove(IERC20 token, address spender, uint256 value) internal {
414         // safeApprove should only be called when setting an initial allowance,
415         // or when resetting it to zero. To increase and decrease it, use
416         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
417         // solhint-disable-next-line max-line-length
418         require((value == 0) || (token.allowance(address(this), spender) == 0),
419             "SafeERC20: approve from non-zero to non-zero allowance"
420         );
421         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
422     }
423 
424     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
425         uint256 newAllowance = token.allowance(address(this), spender).add(value);
426         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
427     }
428 
429     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
430         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
431         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
432     }
433 
434     /**
435      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
436      * on the return value: the return value is optional (but if data is returned, it must not be false).
437      * @param token The token targeted by the call.
438      * @param data The call data (encoded using abi.encode or one of its variants).
439      */
440     function callOptionalReturn(IERC20 token, bytes memory data) private {
441         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
442         // we're implementing it ourselves.
443 
444         // A Solidity high level call has three parts:
445         //  1. The target address is checked to verify it contains contract code
446         //  2. The call itself is made, and success asserted
447         //  3. The return value is decoded, which in turn checks the size of the returned data.
448         // solhint-disable-next-line max-line-length
449         require(address(token).isContract(), "SafeERC20: call to non-contract");
450 
451         // solhint-disable-next-line avoid-low-level-calls
452         (bool success, bytes memory returndata) = address(token).call(data);
453         require(success, "SafeERC20: low-level call failed");
454 
455         if (returndata.length > 0) { // Return data is optional
456             // solhint-disable-next-line max-line-length
457             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
458         }
459     }
460 }
461 
462 // File: contracts/protocol/v1/lib/P1Types.sol
463 
464 /**
465  * @title P1Types
466  * @author dYdX
467  *
468  * @dev Library for common types used in PerpetualV1 contracts.
469  */
470 library P1Types {
471     // ============ Structs ============
472 
473     /**
474      * @dev Used to represent the global index and each account's cached index.
475      *  Used to settle funding paymennts on a per-account basis.
476      */
477     struct Index {
478         uint32 timestamp;
479         bool isPositive;
480         uint128 value;
481     }
482 
483     /**
484      * @dev Used to track the signed margin balance and position balance values for each account.
485      */
486     struct Balance {
487         bool marginIsPositive;
488         bool positionIsPositive;
489         uint120 margin;
490         uint120 position;
491     }
492 
493     /**
494      * @dev Used to cache commonly-used variables that are relatively gas-intensive to obtain.
495      */
496     struct Context {
497         uint256 price;
498         uint256 minCollateral;
499         Index index;
500     }
501 
502     /**
503      * @dev Used by contracts implementing the I_P1Trader interface to return the result of a trade.
504      */
505     struct TradeResult {
506         uint256 marginAmount;
507         uint256 positionAmount;
508         bool isBuy; // From taker's perspective.
509         bytes32 traderFlags;
510     }
511 }
512 
513 // File: contracts/protocol/v1/intf/I_PerpetualV1.sol
514 
515 /**
516  * @title I_PerpetualV1
517  * @author dYdX
518  *
519  * @notice Interface for PerpetualV1.
520  */
521 interface I_PerpetualV1 {
522 
523     // ============ Structs ============
524 
525     struct TradeArg {
526         uint256 takerIndex;
527         uint256 makerIndex;
528         address trader;
529         bytes data;
530     }
531 
532     // ============ State-Changing Functions ============
533 
534     /**
535      * @notice Submits one or more trades between any number of accounts.
536      *
537      * @param  accounts  The sorted list of accounts that are involved in trades.
538      * @param  trades    The list of trades to execute in-order.
539      */
540     function trade(
541         address[] calldata accounts,
542         TradeArg[] calldata trades
543     )
544         external;
545 
546     /**
547      * @notice Withdraw the number of margin tokens equal to the value of the account at the time
548      *  that final settlement occurred.
549      */
550     function withdrawFinalSettlement()
551         external;
552 
553     /**
554      * @notice Deposit some amount of margin tokens from the msg.sender into an account.
555      *
556      * @param  account  The account for which to credit the deposit.
557      * @param  amount   the amount of tokens to deposit.
558      */
559     function deposit(
560         address account,
561         uint256 amount
562     )
563         external;
564 
565     /**
566      * @notice Withdraw some amount of margin tokens from an account to a destination address.
567      *
568      * @param  account      The account for which to debit the withdrawal.
569      * @param  destination  The address to which the tokens are transferred.
570      * @param  amount       The amount of tokens to withdraw.
571      */
572     function withdraw(
573         address account,
574         address destination,
575         uint256 amount
576     )
577         external;
578 
579     /**
580      * @notice Grants or revokes permission for another account to perform certain actions on behalf
581      *  of the sender.
582      *
583      * @param  operator  The account that is approved or disapproved.
584      * @param  approved  True for approval, false for disapproval.
585      */
586     function setLocalOperator(
587         address operator,
588         bool approved
589     )
590         external;
591 
592     // ============ Account Getters ============
593 
594     /**
595      * @notice Get the balance of an account, without accounting for changes in the index.
596      *
597      * @param  account  The address of the account to query the balances of.
598      * @return          The balances of the account.
599      */
600     function getAccountBalance(
601         address account
602     )
603         external
604         view
605         returns (P1Types.Balance memory);
606 
607     /**
608      * @notice Gets the most recently cached index of an account.
609      *
610      * @param  account  The address of the account to query the index of.
611      * @return          The index of the account.
612      */
613     function getAccountIndex(
614         address account
615     )
616         external
617         view
618         returns (P1Types.Index memory);
619 
620     /**
621      * @notice Gets the local operator status of an operator for a particular account.
622      *
623      * @param  account   The account to query the operator for.
624      * @param  operator  The address of the operator to query the status of.
625      * @return           True if the operator is a local operator of the account, false otherwise.
626      */
627     function getIsLocalOperator(
628         address account,
629         address operator
630     )
631         external
632         view
633         returns (bool);
634 
635     // ============ Global Getters ============
636 
637     /**
638      * @notice Gets the global operator status of an address.
639      *
640      * @param  operator  The address of the operator to query the status of.
641      * @return           True if the address is a global operator, false otherwise.
642      */
643     function getIsGlobalOperator(
644         address operator
645     )
646         external
647         view
648         returns (bool);
649 
650     /**
651      * @notice Gets the address of the ERC20 margin contract used for margin deposits.
652      *
653      * @return The address of the ERC20 token.
654      */
655     function getTokenContract()
656         external
657         view
658         returns (address);
659 
660     /**
661      * @notice Gets the current address of the price oracle contract.
662      *
663      * @return The address of the price oracle contract.
664      */
665     function getOracleContract()
666         external
667         view
668         returns (address);
669 
670     /**
671      * @notice Gets the current address of the funder contract.
672      *
673      * @return The address of the funder contract.
674      */
675     function getFunderContract()
676         external
677         view
678         returns (address);
679 
680     /**
681      * @notice Gets the most recently cached global index.
682      *
683      * @return The most recently cached global index.
684      */
685     function getGlobalIndex()
686         external
687         view
688         returns (P1Types.Index memory);
689 
690     /**
691      * @notice Gets minimum collateralization ratio of the protocol.
692      *
693      * @return The minimum-acceptable collateralization ratio, returned as a fixed-point number with
694      *  18 decimals of precision.
695      */
696     function getMinCollateral()
697         external
698         view
699         returns (uint256);
700 
701     /**
702      * @notice Gets the status of whether final-settlement was initiated by the Admin.
703      *
704      * @return True if final-settlement was enabled, false otherwise.
705      */
706     function getFinalSettlementEnabled()
707         external
708         view
709         returns (bool);
710 
711     // ============ Public Getters ============
712 
713     /**
714      * @notice Gets whether an address has permissions to operate an account.
715      *
716      * @param  account   The account to query.
717      * @param  operator  The address to query.
718      * @return           True if the operator has permission to operate the account,
719      *                   and false otherwise.
720      */
721     function hasAccountPermissions(
722         address account,
723         address operator
724     )
725         external
726         view
727         returns (bool);
728 
729     // ============ Authorized Getters ============
730 
731     /**
732      * @notice Gets the price returned by the oracle.
733      * @dev Only able to be called by global operators.
734      *
735      * @return The price returned by the current price oracle.
736      */
737     function getOraclePrice()
738         external
739         view
740         returns (uint256);
741 }
742 
743 // File: contracts/protocol/v1/proxies/P1Proxy.sol
744 
745 /**
746  * @title P1Proxy
747  * @author dYdX
748  *
749  * @notice Base contract for proxy contracts, which can be used to provide additional functionality
750  *  or restrictions when making calls to a Perpetual contract on behalf of a user.
751  */
752 contract P1Proxy {
753     using SafeERC20 for IERC20;
754 
755     /**
756      * @notice Sets the maximum allowance on the Perpetual contract. Must be called at least once
757      *  on a given Perpetual before deposits can be made.
758      * @dev Cannot be run in the constructor due to technical restrictions in Solidity.
759      */
760     function approveMaximumOnPerpetual(
761         address perpetual
762     )
763         external
764     {
765         IERC20 tokenContract = IERC20(I_PerpetualV1(perpetual).getTokenContract());
766 
767         // safeApprove requires unsetting the allowance first.
768         tokenContract.safeApprove(perpetual, 0);
769 
770         // Set the allowance to the highest possible value.
771         tokenContract.safeApprove(perpetual, uint256(-1));
772     }
773 }
774 
775 // File: contracts/protocol/lib/ReentrancyGuard.sol
776 
777 /**
778  * @title ReentrancyGuard
779  * @author dYdX
780  *
781  * @dev Updated ReentrancyGuard library designed to be used with Proxy Contracts.
782  */
783 contract ReentrancyGuard {
784     uint256 private constant NOT_ENTERED = 1;
785     uint256 private constant ENTERED = uint256(int256(-1));
786 
787     uint256 private _STATUS_;
788 
789     constructor () internal {
790         _STATUS_ = NOT_ENTERED;
791     }
792 
793     modifier nonReentrant() {
794         require(_STATUS_ != ENTERED, "ReentrancyGuard: reentrant call");
795         _STATUS_ = ENTERED;
796         _;
797         _STATUS_ = NOT_ENTERED;
798     }
799 }
800 
801 // File: contracts/protocol/v1/proxies/P1WethProxy.sol
802 
803 /**
804  * @title P1WethProxy
805  * @author dYdX
806  *
807  * @notice A proxy for depositing and withdrawing ETH to/from a Perpetual contract that uses WETH as
808  *  its margin token. The ETH will be wrapper and unwrapped by the proxy.
809  */
810 contract P1WethProxy is
811     P1Proxy,
812     ReentrancyGuard
813 {
814     // ============ Storage ============
815 
816     WETH9 public _WETH_;
817 
818     // ============ Constructor ============
819 
820     constructor (
821         address payable weth
822     )
823         public
824     {
825         _WETH_ = WETH9(weth);
826     }
827 
828     // ============ External Functions ============
829 
830     /**
831      * Fallback function. Disallows ether to be sent to this contract without data except when
832      * unwrapping WETH.
833      */
834     function ()
835         external
836         payable
837     {
838         require(
839             msg.sender == address(_WETH_),
840             "Cannot receive ETH"
841         );
842     }
843 
844     /**
845      * @notice Deposit ETH into a Perpetual, by first wrapping it as WETH. Any ETH paid to this
846      *  function will be converted and deposited.
847      *
848      * @param  perpetual  Address of the Perpetual contract to deposit to.
849      * @param  account    The account on the Perpetual for which to credit the deposit.
850      */
851     function depositEth(
852         address perpetual,
853         address account
854     )
855         external
856         payable
857         nonReentrant
858     {
859         WETH9 weth = _WETH_;
860         address marginToken = I_PerpetualV1(perpetual).getTokenContract();
861         require(
862             marginToken == address(weth),
863             "The perpetual does not use WETH for margin deposits"
864         );
865 
866         // Wrap ETH.
867         weth.deposit.value(msg.value)();
868 
869         // Deposit all WETH into the perpetual.
870         uint256 amount = weth.balanceOf(address(this));
871         I_PerpetualV1(perpetual).deposit(account, amount);
872     }
873 
874     /**
875      * @notice Withdraw ETH from a Perpetual, by first withdrawing and unwrapping WETH.
876      *
877      * @param  perpetual    Address of the Perpetual contract to withdraw from.
878      * @param  account      The account on the Perpetual to withdraw from.
879      * @param  destination  The address to send the withdrawn ETH to.
880      * @param  amount       The amount of ETH/WETH to withdraw.
881      */
882     function withdrawEth(
883         address perpetual,
884         address account,
885         address payable destination,
886         uint256 amount
887     )
888         external
889         nonReentrant
890     {
891         WETH9 weth = _WETH_;
892         address marginToken = I_PerpetualV1(perpetual).getTokenContract();
893         require(
894             marginToken == address(weth),
895             "The perpetual does not use WETH for margin deposits"
896         );
897 
898         require(
899             // Short-circuit if sender is the account owner.
900             msg.sender == account ||
901                 I_PerpetualV1(perpetual).hasAccountPermissions(account, msg.sender),
902             "Sender does not have withdraw permissions for the account"
903         );
904 
905         // Withdraw WETH from the perpetual.
906         I_PerpetualV1(perpetual).withdraw(account, address(this), amount);
907 
908         // Unwrap all WETH and send it as ETH to the provided destination.
909         uint256 balance = weth.balanceOf(address(this));
910         weth.withdraw(balance);
911         destination.transfer(balance);
912     }
913 }