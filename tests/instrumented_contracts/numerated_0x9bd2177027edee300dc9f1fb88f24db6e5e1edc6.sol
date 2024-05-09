1 // File: contracts/libraries/errors/JosephErrors.sol
2 
3 
4 pragma solidity 0.8.15;
5 
6 library JosephErrors {
7     // 400-499-joseph
8     //@notice IP Token Value which should be minted is too low
9     string public constant IP_TOKEN_MINT_AMOUNT_TOO_LOW = "IPOR_400";
10 
11     //@notice Amount which should be burned is too low
12     string public constant IP_TOKEN_BURN_AMOUNT_TOO_LOW = "IPOR_401";
13 
14     string public constant REDEEM_LP_UTILIZATION_EXCEEDED = "IPOR_402";
15     //@notice User cannot redeem underlying tokens because ipToken on his balance is too low
16     string public constant CANNOT_REDEEM_IP_TOKEN_TOO_LOW = "IPOR_403";
17 
18     string public constant CALLER_NOT_TREASURE_TRANSFERER = "IPOR_404";
19 
20     //@notice Incorrect Treasury Treasurer Address
21     string public constant INCORRECT_TREASURE_TREASURER = "IPOR_405";
22 
23     //@notice Sender is not a publication fee transferer, not match address defined in IporConfiguration in key MILTON_PUBLICATION_FEE_TRANSFERER
24     string public constant CALLER_NOT_PUBLICATION_FEE_TRANSFERER = "IPOR_406";
25 
26     //@notice Charlie Treasurer address is incorrect
27     string public constant INCORRECT_CHARLIE_TREASURER = "IPOR_407";
28 
29     string public constant STANLEY_BALANCE_IS_EMPTY = "IPOR_408";
30 
31     string public constant MILTON_STANLEY_RATIO = "IPOR_409";
32 }
33 
34 // File: contracts/libraries/errors/MiltonErrors.sol
35 
36 
37 pragma solidity 0.8.15;
38 
39 /// @title Errors which occur inside Milton's method execution.
40 library MiltonErrors {
41     // 300-399-milton
42     /// @notice Liquidity Pool balance is equal 0.
43     string public constant LIQUIDITY_POOL_IS_EMPTY = "IPOR_300";
44 
45     /// @notice Liquidity Pool balance is too low, should be equal or higher than 0.
46     string public constant LIQUIDITY_POOL_AMOUNT_TOO_LOW = "IPOR_301";
47 
48     /// @notice Liquidity Pool Utilization exceeded. Liquidity Pool utilization is higher than configured in Milton maximum liquidity pool utilization.
49     string public constant LP_UTILIZATION_EXCEEDED = "IPOR_302";
50 
51     /// @notice Liquidity Pool Utilization Per Leg exceeded. Liquidity Pool utilization per leg is higher than configured in Milton maximu liquidity pool utilization per leg.
52     string public constant LP_UTILIZATION_PER_LEG_EXCEEDED = "IPOR_303";
53 
54     /// @notice Liquidity Pool Balance is too high
55     string public constant LIQUIDITY_POOL_BALANCE_IS_TOO_HIGH = "IPOR_304";
56 
57     /// @notice Liquidity Pool account contribution is too high.
58     string public constant LP_ACCOUNT_CONTRIBUTION_IS_TOO_HIGH = "IPOR_305";
59 
60     /// @notice Swap id used in input has incorrect value (like 0) or not exists.
61     string public constant INCORRECT_SWAP_ID = "IPOR_306";
62 
63     /// @notice Swap has incorrect status.
64     string public constant INCORRECT_SWAP_STATUS = "IPOR_307";
65 
66     /// @notice Leverage given as a parameter when opening swap is lower than configured in Milton minimum leverage.
67     string public constant LEVERAGE_TOO_LOW = "IPOR_308";
68 
69     /// @notice Leverage given as a parameter when opening swap is higher than configured in Milton maxumum leverage.
70     string public constant LEVERAGE_TOO_HIGH = "IPOR_309";
71 
72     /// @notice Total amount given as a parameter when opening swap is too low. Cannot be equal zero.
73     string public constant TOTAL_AMOUNT_TOO_LOW = "IPOR_310";
74 
75     /// @notice Total amount given as a parameter when opening swap is lower than sum of liquidation deposit amount and ipor publication fee.
76     string public constant TOTAL_AMOUNT_LOWER_THAN_FEE = "IPOR_311";
77 
78     /// @notice Amount of collateral used to open swap is higher than configured in Milton max swap collateral amount
79     string public constant COLLATERAL_AMOUNT_TOO_HIGH = "IPOR_312";
80 
81     /// @notice Acceptable fixed interest rate defined by traded exceeded.
82     string public constant ACCEPTABLE_FIXED_INTEREST_RATE_EXCEEDED = "IPOR_313";
83 
84     /// @notice Swap Notional Amount is higher than Total Notional for specific leg.
85     string public constant SWAP_NOTIONAL_HIGHER_THAN_TOTAL_NOTIONAL = "IPOR_314";
86 
87     /// @notice Number of swaps per leg which are going to be liquidated is too high, is higher than configured in Milton liquidation leg limit.
88     string public constant LIQUIDATION_LEG_LIMIT_EXCEEDED = "IPOR_315";
89 
90     /// @notice Sum of SOAP and Liquidity Pool Balance is lower than zero.
91     /// @dev SOAP can be negative, Sum of SOAP and Liquidity Pool Balance can be negative, but this is undesirable.
92     string public constant SOAP_AND_LP_BALANCE_SUM_IS_TOO_LOW = "IPOR_316";
93 
94     /// @notice Calculation timestamp is earlier than last SOAP rebalance timestamp.
95     string public constant CALC_TIMESTAMP_LOWER_THAN_SOAP_REBALANCE_TIMESTAMP = "IPOR_317";
96 
97     /// @notice Calculation timestamp is lower than  Swap's open timestamp.
98     string public constant CALC_TIMESTAMP_LOWER_THAN_SWAP_OPEN_TIMESTAMP = "IPOR_318";
99 
100     /// @notice Closing timestamp is lower than Swap's open timestamp.
101     string public constant CLOSING_TIMESTAMP_LOWER_THAN_SWAP_OPEN_TIMESTAMP = "IPOR_319";
102 
103     /// @notice Swap cannot be closed because liquidity pool is too low for payid out cash. Situation should never happen where Liquidity Pool is insolvent.
104     string public constant CANNOT_CLOSE_SWAP_LP_IS_TOO_LOW = "IPOR_320";
105 
106     /// @notice Swap cannot be closed because sender is not an owner of derivative and derivative maturity not achieved.
107     string public constant CANNOT_CLOSE_SWAP_SENDER_IS_NOT_BUYER_AND_NO_MATURITY = "IPOR_321";
108 
109     /// @notice Interest from Strategy is below zero.
110     string public constant INTEREST_FROM_STRATEGY_BELOW_ZERO = "IPOR_322";
111 
112     /// @notice Accrued Liquidity Pool is equal zero.
113     string public constant LIQUIDITY_POOL_ACCRUED_IS_EQUAL_ZERO = "IPOR_323";
114 
115     /// @notice During spread calculation - Exponential Weighted Moving Variance cannot be higher than 1.
116     string public constant SPREAD_EMVAR_CANNOT_BE_HIGHER_THAN_ONE = "IPOR_324";
117 
118     /// @notice During spread calculation - Alpha param cannot be higher than 1.
119     string public constant SPREAD_ALPHA_CANNOT_BE_HIGHER_THAN_ONE = "IPOR_325";
120 
121     /// @notice IPOR publication fee balance is too low.
122     string public constant PUBLICATION_FEE_BALANCE_IS_TOO_LOW = "IPOR_326";
123 
124     /// @notice The caller must be the Joseph (Smart Contract responsible for managing Milton's tokens and balances).
125     string public constant CALLER_NOT_JOSEPH = "IPOR_327";
126 
127     /// @notice Deposit amount is too low.
128     string public constant DEPOSIT_AMOUNT_IS_TOO_LOW = "IPOR_328";
129 
130     /// @notice Vault balance is lower than deposit value.
131     string public constant VAULT_BALANCE_LOWER_THAN_DEPOSIT_VALUE = "IPOR_329";
132 
133     /// @notice Treasury balance is too low.
134     string public constant TREASURY_BALANCE_IS_TOO_LOW = "IPOR_330";
135 }
136 
137 // File: contracts/libraries/errors/IporErrors.sol
138 
139 
140 pragma solidity 0.8.15;
141 
142 library IporErrors {
143     // 000-199 - general codes
144 
145     /// @notice General problem, address is wrong
146     string public constant WRONG_ADDRESS = "IPOR_000";
147 
148     /// @notice General problem. Wrong decimals
149     string public constant WRONG_DECIMALS = "IPOR_001";
150 
151     string public constant ADDRESSES_MISMATCH = "IPOR_002";
152 
153     //@notice Trader doesnt have enought tokens to execute transaction
154     string public constant ASSET_BALANCE_TOO_LOW = "IPOR_003";
155 
156     string public constant VALUE_NOT_GREATER_THAN_ZERO = "IPOR_004";
157 
158     string public constant INPUT_ARRAYS_LENGTH_MISMATCH = "IPOR_005";
159 
160     //@notice Amount is too low to transfer
161     string public constant NOT_ENOUGH_AMOUNT_TO_TRANSFER = "IPOR_006";
162 
163     //@notice msg.sender is not an appointed owner, so cannot confirm his appointment to be an owner of a specific smart contract
164     string public constant SENDER_NOT_APPOINTED_OWNER = "IPOR_007";
165 
166     //only milton can have access to function
167     string public constant CALLER_NOT_MILTON = "IPOR_008";
168 
169     string public constant CHUNK_SIZE_EQUAL_ZERO = "IPOR_009";
170 
171     string public constant CHUNK_SIZE_TOO_BIG = "IPOR_010";
172 }
173 
174 // File: @openzeppelin/contracts/utils/Context.sol
175 
176 
177 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @dev Provides information about the current execution context, including the
183  * sender of the transaction and its data. While these are generally available
184  * via msg.sender and msg.data, they should not be accessed in such a direct
185  * manner, since when dealing with meta-transactions the account sending and
186  * paying for execution may not be the actual sender (as far as an application
187  * is concerned).
188  *
189  * This contract is only required for intermediate, library-like contracts.
190  */
191 abstract contract Context {
192     function _msgSender() internal view virtual returns (address) {
193         return msg.sender;
194     }
195 
196     function _msgData() internal view virtual returns (bytes calldata) {
197         return msg.data;
198     }
199 }
200 
201 // File: @openzeppelin/contracts/access/Ownable.sol
202 
203 
204 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
205 
206 pragma solidity ^0.8.0;
207 
208 
209 /**
210  * @dev Contract module which provides a basic access control mechanism, where
211  * there is an account (an owner) that can be granted exclusive access to
212  * specific functions.
213  *
214  * By default, the owner account will be the one that deploys the contract. This
215  * can later be changed with {transferOwnership}.
216  *
217  * This module is used through inheritance. It will make available the modifier
218  * `onlyOwner`, which can be applied to your functions to restrict their use to
219  * the owner.
220  */
221 abstract contract Ownable is Context {
222     address private _owner;
223 
224     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
225 
226     /**
227      * @dev Initializes the contract setting the deployer as the initial owner.
228      */
229     constructor() {
230         _transferOwnership(_msgSender());
231     }
232 
233     /**
234      * @dev Throws if called by any account other than the owner.
235      */
236     modifier onlyOwner() {
237         _checkOwner();
238         _;
239     }
240 
241     /**
242      * @dev Returns the address of the current owner.
243      */
244     function owner() public view virtual returns (address) {
245         return _owner;
246     }
247 
248     /**
249      * @dev Throws if the sender is not the owner.
250      */
251     function _checkOwner() internal view virtual {
252         require(owner() == _msgSender(), "Ownable: caller is not the owner");
253     }
254 
255     /**
256      * @dev Leaves the contract without owner. It will not be possible to call
257      * `onlyOwner` functions anymore. Can only be called by the current owner.
258      *
259      * NOTE: Renouncing ownership will leave the contract without an owner,
260      * thereby removing any functionality that is only available to the owner.
261      */
262     function renounceOwnership() public virtual onlyOwner {
263         _transferOwnership(address(0));
264     }
265 
266     /**
267      * @dev Transfers ownership of the contract to a new account (`newOwner`).
268      * Can only be called by the current owner.
269      */
270     function transferOwnership(address newOwner) public virtual onlyOwner {
271         require(newOwner != address(0), "Ownable: new owner is the zero address");
272         _transferOwnership(newOwner);
273     }
274 
275     /**
276      * @dev Transfers ownership of the contract to a new account (`newOwner`).
277      * Internal function without access restriction.
278      */
279     function _transferOwnership(address newOwner) internal virtual {
280         address oldOwner = _owner;
281         _owner = newOwner;
282         emit OwnershipTransferred(oldOwner, newOwner);
283     }
284 }
285 
286 // File: contracts/security/IporOwnable.sol
287 
288 
289 pragma solidity 0.8.15;
290 
291 
292 
293 contract IporOwnable is Ownable {
294     address private _appointedOwner;
295 
296     event AppointedToTransferOwnership(address indexed appointedOwner);
297 
298     function transferOwnership(address appointedOwner) public override onlyOwner {
299         require(appointedOwner != address(0), IporErrors.WRONG_ADDRESS);
300         _appointedOwner = appointedOwner;
301         emit AppointedToTransferOwnership(appointedOwner);
302     }
303 
304     function confirmTransferOwnership() external onlyAppointedOwner {
305         _appointedOwner = address(0);
306         _transferOwnership(_msgSender());
307     }
308 
309     modifier onlyAppointedOwner() {
310         require(_appointedOwner == _msgSender(), IporErrors.SENDER_NOT_APPOINTED_OWNER);
311         _;
312     }
313 }
314 
315 // File: @openzeppelin/contracts/utils/Address.sol
316 
317 
318 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
319 
320 pragma solidity ^0.8.1;
321 
322 /**
323  * @dev Collection of functions related to the address type
324  */
325 library Address {
326     /**
327      * @dev Returns true if `account` is a contract.
328      *
329      * [IMPORTANT]
330      * ====
331      * It is unsafe to assume that an address for which this function returns
332      * false is an externally-owned account (EOA) and not a contract.
333      *
334      * Among others, `isContract` will return false for the following
335      * types of addresses:
336      *
337      *  - an externally-owned account
338      *  - a contract in construction
339      *  - an address where a contract will be created
340      *  - an address where a contract lived, but was destroyed
341      * ====
342      *
343      * [IMPORTANT]
344      * ====
345      * You shouldn't rely on `isContract` to protect against flash loan attacks!
346      *
347      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
348      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
349      * constructor.
350      * ====
351      */
352     function isContract(address account) internal view returns (bool) {
353         // This method relies on extcodesize/address.code.length, which returns 0
354         // for contracts in construction, since the code is only stored at the end
355         // of the constructor execution.
356 
357         return account.code.length > 0;
358     }
359 
360     /**
361      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
362      * `recipient`, forwarding all available gas and reverting on errors.
363      *
364      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
365      * of certain opcodes, possibly making contracts go over the 2300 gas limit
366      * imposed by `transfer`, making them unable to receive funds via
367      * `transfer`. {sendValue} removes this limitation.
368      *
369      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
370      *
371      * IMPORTANT: because control is transferred to `recipient`, care must be
372      * taken to not create reentrancy vulnerabilities. Consider using
373      * {ReentrancyGuard} or the
374      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
375      */
376     function sendValue(address payable recipient, uint256 amount) internal {
377         require(address(this).balance >= amount, "Address: insufficient balance");
378 
379         (bool success, ) = recipient.call{value: amount}("");
380         require(success, "Address: unable to send value, recipient may have reverted");
381     }
382 
383     /**
384      * @dev Performs a Solidity function call using a low level `call`. A
385      * plain `call` is an unsafe replacement for a function call: use this
386      * function instead.
387      *
388      * If `target` reverts with a revert reason, it is bubbled up by this
389      * function (like regular Solidity function calls).
390      *
391      * Returns the raw returned data. To convert to the expected return value,
392      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
393      *
394      * Requirements:
395      *
396      * - `target` must be a contract.
397      * - calling `target` with `data` must not revert.
398      *
399      * _Available since v3.1._
400      */
401     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
402         return functionCall(target, data, "Address: low-level call failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
407      * `errorMessage` as a fallback revert reason when `target` reverts.
408      *
409      * _Available since v3.1._
410      */
411     function functionCall(
412         address target,
413         bytes memory data,
414         string memory errorMessage
415     ) internal returns (bytes memory) {
416         return functionCallWithValue(target, data, 0, errorMessage);
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
421      * but also transferring `value` wei to `target`.
422      *
423      * Requirements:
424      *
425      * - the calling contract must have an ETH balance of at least `value`.
426      * - the called Solidity function must be `payable`.
427      *
428      * _Available since v3.1._
429      */
430     function functionCallWithValue(
431         address target,
432         bytes memory data,
433         uint256 value
434     ) internal returns (bytes memory) {
435         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
440      * with `errorMessage` as a fallback revert reason when `target` reverts.
441      *
442      * _Available since v3.1._
443      */
444     function functionCallWithValue(
445         address target,
446         bytes memory data,
447         uint256 value,
448         string memory errorMessage
449     ) internal returns (bytes memory) {
450         require(address(this).balance >= value, "Address: insufficient balance for call");
451         require(isContract(target), "Address: call to non-contract");
452 
453         (bool success, bytes memory returndata) = target.call{value: value}(data);
454         return verifyCallResult(success, returndata, errorMessage);
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
459      * but performing a static call.
460      *
461      * _Available since v3.3._
462      */
463     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
464         return functionStaticCall(target, data, "Address: low-level static call failed");
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
469      * but performing a static call.
470      *
471      * _Available since v3.3._
472      */
473     function functionStaticCall(
474         address target,
475         bytes memory data,
476         string memory errorMessage
477     ) internal view returns (bytes memory) {
478         require(isContract(target), "Address: static call to non-contract");
479 
480         (bool success, bytes memory returndata) = target.staticcall(data);
481         return verifyCallResult(success, returndata, errorMessage);
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
486      * but performing a delegate call.
487      *
488      * _Available since v3.4._
489      */
490     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
491         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
496      * but performing a delegate call.
497      *
498      * _Available since v3.4._
499      */
500     function functionDelegateCall(
501         address target,
502         bytes memory data,
503         string memory errorMessage
504     ) internal returns (bytes memory) {
505         require(isContract(target), "Address: delegate call to non-contract");
506 
507         (bool success, bytes memory returndata) = target.delegatecall(data);
508         return verifyCallResult(success, returndata, errorMessage);
509     }
510 
511     /**
512      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
513      * revert reason using the provided one.
514      *
515      * _Available since v4.3._
516      */
517     function verifyCallResult(
518         bool success,
519         bytes memory returndata,
520         string memory errorMessage
521     ) internal pure returns (bytes memory) {
522         if (success) {
523             return returndata;
524         } else {
525             // Look for revert reason and bubble it up if present
526             if (returndata.length > 0) {
527                 // The easiest way to bubble the revert reason is using memory via assembly
528                 /// @solidity memory-safe-assembly
529                 assembly {
530                     let returndata_size := mload(returndata)
531                     revert(add(32, returndata), returndata_size)
532                 }
533             } else {
534                 revert(errorMessage);
535             }
536         }
537     }
538 }
539 
540 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
541 
542 
543 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
544 
545 pragma solidity ^0.8.0;
546 
547 /**
548  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
549  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
550  *
551  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
552  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
553  * need to send a transaction, and thus is not required to hold Ether at all.
554  */
555 interface IERC20Permit {
556     /**
557      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
558      * given ``owner``'s signed approval.
559      *
560      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
561      * ordering also apply here.
562      *
563      * Emits an {Approval} event.
564      *
565      * Requirements:
566      *
567      * - `spender` cannot be the zero address.
568      * - `deadline` must be a timestamp in the future.
569      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
570      * over the EIP712-formatted function arguments.
571      * - the signature must use ``owner``'s current nonce (see {nonces}).
572      *
573      * For more information on the signature format, see the
574      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
575      * section].
576      */
577     function permit(
578         address owner,
579         address spender,
580         uint256 value,
581         uint256 deadline,
582         uint8 v,
583         bytes32 r,
584         bytes32 s
585     ) external;
586 
587     /**
588      * @dev Returns the current nonce for `owner`. This value must be
589      * included whenever a signature is generated for {permit}.
590      *
591      * Every successful call to {permit} increases ``owner``'s nonce by one. This
592      * prevents a signature from being used multiple times.
593      */
594     function nonces(address owner) external view returns (uint256);
595 
596     /**
597      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
598      */
599     // solhint-disable-next-line func-name-mixedcase
600     function DOMAIN_SEPARATOR() external view returns (bytes32);
601 }
602 
603 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
604 
605 
606 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
607 
608 pragma solidity ^0.8.0;
609 
610 /**
611  * @dev Interface of the ERC20 standard as defined in the EIP.
612  */
613 interface IERC20 {
614     /**
615      * @dev Emitted when `value` tokens are moved from one account (`from`) to
616      * another (`to`).
617      *
618      * Note that `value` may be zero.
619      */
620     event Transfer(address indexed from, address indexed to, uint256 value);
621 
622     /**
623      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
624      * a call to {approve}. `value` is the new allowance.
625      */
626     event Approval(address indexed owner, address indexed spender, uint256 value);
627 
628     /**
629      * @dev Returns the amount of tokens in existence.
630      */
631     function totalSupply() external view returns (uint256);
632 
633     /**
634      * @dev Returns the amount of tokens owned by `account`.
635      */
636     function balanceOf(address account) external view returns (uint256);
637 
638     /**
639      * @dev Moves `amount` tokens from the caller's account to `to`.
640      *
641      * Returns a boolean value indicating whether the operation succeeded.
642      *
643      * Emits a {Transfer} event.
644      */
645     function transfer(address to, uint256 amount) external returns (bool);
646 
647     /**
648      * @dev Returns the remaining number of tokens that `spender` will be
649      * allowed to spend on behalf of `owner` through {transferFrom}. This is
650      * zero by default.
651      *
652      * This value changes when {approve} or {transferFrom} are called.
653      */
654     function allowance(address owner, address spender) external view returns (uint256);
655 
656     /**
657      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
658      *
659      * Returns a boolean value indicating whether the operation succeeded.
660      *
661      * IMPORTANT: Beware that changing an allowance with this method brings the risk
662      * that someone may use both the old and the new allowance by unfortunate
663      * transaction ordering. One possible solution to mitigate this race
664      * condition is to first reduce the spender's allowance to 0 and set the
665      * desired value afterwards:
666      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
667      *
668      * Emits an {Approval} event.
669      */
670     function approve(address spender, uint256 amount) external returns (bool);
671 
672     /**
673      * @dev Moves `amount` tokens from `from` to `to` using the
674      * allowance mechanism. `amount` is then deducted from the caller's
675      * allowance.
676      *
677      * Returns a boolean value indicating whether the operation succeeded.
678      *
679      * Emits a {Transfer} event.
680      */
681     function transferFrom(
682         address from,
683         address to,
684         uint256 amount
685     ) external returns (bool);
686 }
687 
688 // File: contracts/interfaces/IIpToken.sol
689 
690 
691 pragma solidity 0.8.15;
692 
693 
694 /// @title Interface of ipToken - Liquidity Pool Token managed by Joseph in IPOR Protocol for a given asset.
695 /// For more information refer to the documentation https://ipor-labs.gitbook.io/ipor-labs/automated-market-maker/liquidity-provisioning#liquidity-tokens
696 interface IIpToken is IERC20 {
697     /// @notice Gets the asset / stablecoin address which is assocciated with particular ipToken smart contract instance
698     /// @return asset / stablecoin address
699     function getAsset() external view returns (address);
700 
701     /// @notice Sets Joseph's address. Owner only
702     /// @dev only Joseph can mint or burn ipTokens. Function emits `JosephChanged` event.
703     /// @param newJoseph Joseph's address
704     function setJoseph(address newJoseph) external;
705 
706     /// @notice Creates the ipTokens in the `amount` given and assigns them to the `account`
707     /// @dev Emits {Transfer} from ERC20 asset and {Mint} event from ipToken
708     /// @param account to which the created ipTokens were assigned
709     /// @param amount volume of ipTokens created
710     function mint(address account, uint256 amount) external;
711 
712     /// @notice Burns the `amount` of ipTokens from `account`, reducing the total supply
713     /// @dev Emits {Transfer} from ERC20 asset and {Burn} event from ipToken
714     /// @param account from which burned ipTokens are taken
715     /// @param amount volume of ipTokens that will be burned, represented in 18 decimals
716     function burn(address account, uint256 amount) external;
717 
718     /// @notice Emmited after the `amount` ipTokens were mint and transferred to `account`.
719     /// @param account address where ipTokens are transferred after minting
720     /// @param amount of ipTokens minted, represented in 18 decimals
721     event Mint(address indexed account, uint256 amount);
722 
723     /// @notice Emmited after `amount` ipTokens were transferred from `account` and burnt.
724     /// @param account address from which ipTokens are transferred to be burned
725     /// @param amount volume of ipTokens burned
726     event Burn(address indexed account, uint256 amount);
727 
728     /// @notice Emmited when Joseph address is changed by its owner.
729     /// @param changedBy account address that changed Joseph's address
730     /// @param oldJoseph old address of Joseph
731     /// @param newJoseph new address of Joseph
732     event JosephChanged(
733         address indexed changedBy,
734         address indexed oldJoseph,
735         address indexed newJoseph
736     );
737 }
738 
739 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
740 
741 
742 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
743 
744 pragma solidity ^0.8.0;
745 
746 
747 /**
748  * @dev Interface for the optional metadata functions from the ERC20 standard.
749  *
750  * _Available since v4.1._
751  */
752 interface IERC20Metadata is IERC20 {
753     /**
754      * @dev Returns the name of the token.
755      */
756     function name() external view returns (string memory);
757 
758     /**
759      * @dev Returns the symbol of the token.
760      */
761     function symbol() external view returns (string memory);
762 
763     /**
764      * @dev Returns the decimals places of the token.
765      */
766     function decimals() external view returns (uint8);
767 }
768 
769 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
770 
771 
772 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
773 
774 pragma solidity ^0.8.0;
775 
776 
777 
778 
779 /**
780  * @dev Implementation of the {IERC20} interface.
781  *
782  * This implementation is agnostic to the way tokens are created. This means
783  * that a supply mechanism has to be added in a derived contract using {_mint}.
784  * For a generic mechanism see {ERC20PresetMinterPauser}.
785  *
786  * TIP: For a detailed writeup see our guide
787  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
788  * to implement supply mechanisms].
789  *
790  * We have followed general OpenZeppelin Contracts guidelines: functions revert
791  * instead returning `false` on failure. This behavior is nonetheless
792  * conventional and does not conflict with the expectations of ERC20
793  * applications.
794  *
795  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
796  * This allows applications to reconstruct the allowance for all accounts just
797  * by listening to said events. Other implementations of the EIP may not emit
798  * these events, as it isn't required by the specification.
799  *
800  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
801  * functions have been added to mitigate the well-known issues around setting
802  * allowances. See {IERC20-approve}.
803  */
804 contract ERC20 is Context, IERC20, IERC20Metadata {
805     mapping(address => uint256) private _balances;
806 
807     mapping(address => mapping(address => uint256)) private _allowances;
808 
809     uint256 private _totalSupply;
810 
811     string private _name;
812     string private _symbol;
813 
814     /**
815      * @dev Sets the values for {name} and {symbol}.
816      *
817      * The default value of {decimals} is 18. To select a different value for
818      * {decimals} you should overload it.
819      *
820      * All two of these values are immutable: they can only be set once during
821      * construction.
822      */
823     constructor(string memory name_, string memory symbol_) {
824         _name = name_;
825         _symbol = symbol_;
826     }
827 
828     /**
829      * @dev Returns the name of the token.
830      */
831     function name() public view virtual override returns (string memory) {
832         return _name;
833     }
834 
835     /**
836      * @dev Returns the symbol of the token, usually a shorter version of the
837      * name.
838      */
839     function symbol() public view virtual override returns (string memory) {
840         return _symbol;
841     }
842 
843     /**
844      * @dev Returns the number of decimals used to get its user representation.
845      * For example, if `decimals` equals `2`, a balance of `505` tokens should
846      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
847      *
848      * Tokens usually opt for a value of 18, imitating the relationship between
849      * Ether and Wei. This is the value {ERC20} uses, unless this function is
850      * overridden;
851      *
852      * NOTE: This information is only used for _display_ purposes: it in
853      * no way affects any of the arithmetic of the contract, including
854      * {IERC20-balanceOf} and {IERC20-transfer}.
855      */
856     function decimals() public view virtual override returns (uint8) {
857         return 18;
858     }
859 
860     /**
861      * @dev See {IERC20-totalSupply}.
862      */
863     function totalSupply() public view virtual override returns (uint256) {
864         return _totalSupply;
865     }
866 
867     /**
868      * @dev See {IERC20-balanceOf}.
869      */
870     function balanceOf(address account) public view virtual override returns (uint256) {
871         return _balances[account];
872     }
873 
874     /**
875      * @dev See {IERC20-transfer}.
876      *
877      * Requirements:
878      *
879      * - `to` cannot be the zero address.
880      * - the caller must have a balance of at least `amount`.
881      */
882     function transfer(address to, uint256 amount) public virtual override returns (bool) {
883         address owner = _msgSender();
884         _transfer(owner, to, amount);
885         return true;
886     }
887 
888     /**
889      * @dev See {IERC20-allowance}.
890      */
891     function allowance(address owner, address spender) public view virtual override returns (uint256) {
892         return _allowances[owner][spender];
893     }
894 
895     /**
896      * @dev See {IERC20-approve}.
897      *
898      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
899      * `transferFrom`. This is semantically equivalent to an infinite approval.
900      *
901      * Requirements:
902      *
903      * - `spender` cannot be the zero address.
904      */
905     function approve(address spender, uint256 amount) public virtual override returns (bool) {
906         address owner = _msgSender();
907         _approve(owner, spender, amount);
908         return true;
909     }
910 
911     /**
912      * @dev See {IERC20-transferFrom}.
913      *
914      * Emits an {Approval} event indicating the updated allowance. This is not
915      * required by the EIP. See the note at the beginning of {ERC20}.
916      *
917      * NOTE: Does not update the allowance if the current allowance
918      * is the maximum `uint256`.
919      *
920      * Requirements:
921      *
922      * - `from` and `to` cannot be the zero address.
923      * - `from` must have a balance of at least `amount`.
924      * - the caller must have allowance for ``from``'s tokens of at least
925      * `amount`.
926      */
927     function transferFrom(
928         address from,
929         address to,
930         uint256 amount
931     ) public virtual override returns (bool) {
932         address spender = _msgSender();
933         _spendAllowance(from, spender, amount);
934         _transfer(from, to, amount);
935         return true;
936     }
937 
938     /**
939      * @dev Atomically increases the allowance granted to `spender` by the caller.
940      *
941      * This is an alternative to {approve} that can be used as a mitigation for
942      * problems described in {IERC20-approve}.
943      *
944      * Emits an {Approval} event indicating the updated allowance.
945      *
946      * Requirements:
947      *
948      * - `spender` cannot be the zero address.
949      */
950     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
951         address owner = _msgSender();
952         _approve(owner, spender, allowance(owner, spender) + addedValue);
953         return true;
954     }
955 
956     /**
957      * @dev Atomically decreases the allowance granted to `spender` by the caller.
958      *
959      * This is an alternative to {approve} that can be used as a mitigation for
960      * problems described in {IERC20-approve}.
961      *
962      * Emits an {Approval} event indicating the updated allowance.
963      *
964      * Requirements:
965      *
966      * - `spender` cannot be the zero address.
967      * - `spender` must have allowance for the caller of at least
968      * `subtractedValue`.
969      */
970     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
971         address owner = _msgSender();
972         uint256 currentAllowance = allowance(owner, spender);
973         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
974         unchecked {
975             _approve(owner, spender, currentAllowance - subtractedValue);
976         }
977 
978         return true;
979     }
980 
981     /**
982      * @dev Moves `amount` of tokens from `from` to `to`.
983      *
984      * This internal function is equivalent to {transfer}, and can be used to
985      * e.g. implement automatic token fees, slashing mechanisms, etc.
986      *
987      * Emits a {Transfer} event.
988      *
989      * Requirements:
990      *
991      * - `from` cannot be the zero address.
992      * - `to` cannot be the zero address.
993      * - `from` must have a balance of at least `amount`.
994      */
995     function _transfer(
996         address from,
997         address to,
998         uint256 amount
999     ) internal virtual {
1000         require(from != address(0), "ERC20: transfer from the zero address");
1001         require(to != address(0), "ERC20: transfer to the zero address");
1002 
1003         _beforeTokenTransfer(from, to, amount);
1004 
1005         uint256 fromBalance = _balances[from];
1006         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1007         unchecked {
1008             _balances[from] = fromBalance - amount;
1009         }
1010         _balances[to] += amount;
1011 
1012         emit Transfer(from, to, amount);
1013 
1014         _afterTokenTransfer(from, to, amount);
1015     }
1016 
1017     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1018      * the total supply.
1019      *
1020      * Emits a {Transfer} event with `from` set to the zero address.
1021      *
1022      * Requirements:
1023      *
1024      * - `account` cannot be the zero address.
1025      */
1026     function _mint(address account, uint256 amount) internal virtual {
1027         require(account != address(0), "ERC20: mint to the zero address");
1028 
1029         _beforeTokenTransfer(address(0), account, amount);
1030 
1031         _totalSupply += amount;
1032         _balances[account] += amount;
1033         emit Transfer(address(0), account, amount);
1034 
1035         _afterTokenTransfer(address(0), account, amount);
1036     }
1037 
1038     /**
1039      * @dev Destroys `amount` tokens from `account`, reducing the
1040      * total supply.
1041      *
1042      * Emits a {Transfer} event with `to` set to the zero address.
1043      *
1044      * Requirements:
1045      *
1046      * - `account` cannot be the zero address.
1047      * - `account` must have at least `amount` tokens.
1048      */
1049     function _burn(address account, uint256 amount) internal virtual {
1050         require(account != address(0), "ERC20: burn from the zero address");
1051 
1052         _beforeTokenTransfer(account, address(0), amount);
1053 
1054         uint256 accountBalance = _balances[account];
1055         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1056         unchecked {
1057             _balances[account] = accountBalance - amount;
1058         }
1059         _totalSupply -= amount;
1060 
1061         emit Transfer(account, address(0), amount);
1062 
1063         _afterTokenTransfer(account, address(0), amount);
1064     }
1065 
1066     /**
1067      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1068      *
1069      * This internal function is equivalent to `approve`, and can be used to
1070      * e.g. set automatic allowances for certain subsystems, etc.
1071      *
1072      * Emits an {Approval} event.
1073      *
1074      * Requirements:
1075      *
1076      * - `owner` cannot be the zero address.
1077      * - `spender` cannot be the zero address.
1078      */
1079     function _approve(
1080         address owner,
1081         address spender,
1082         uint256 amount
1083     ) internal virtual {
1084         require(owner != address(0), "ERC20: approve from the zero address");
1085         require(spender != address(0), "ERC20: approve to the zero address");
1086 
1087         _allowances[owner][spender] = amount;
1088         emit Approval(owner, spender, amount);
1089     }
1090 
1091     /**
1092      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1093      *
1094      * Does not update the allowance amount in case of infinite allowance.
1095      * Revert if not enough allowance is available.
1096      *
1097      * Might emit an {Approval} event.
1098      */
1099     function _spendAllowance(
1100         address owner,
1101         address spender,
1102         uint256 amount
1103     ) internal virtual {
1104         uint256 currentAllowance = allowance(owner, spender);
1105         if (currentAllowance != type(uint256).max) {
1106             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1107             unchecked {
1108                 _approve(owner, spender, currentAllowance - amount);
1109             }
1110         }
1111     }
1112 
1113     /**
1114      * @dev Hook that is called before any transfer of tokens. This includes
1115      * minting and burning.
1116      *
1117      * Calling conditions:
1118      *
1119      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1120      * will be transferred to `to`.
1121      * - when `from` is zero, `amount` tokens will be minted for `to`.
1122      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1123      * - `from` and `to` are never both zero.
1124      *
1125      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1126      */
1127     function _beforeTokenTransfer(
1128         address from,
1129         address to,
1130         uint256 amount
1131     ) internal virtual {}
1132 
1133     /**
1134      * @dev Hook that is called after any transfer of tokens. This includes
1135      * minting and burning.
1136      *
1137      * Calling conditions:
1138      *
1139      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1140      * has been transferred to `to`.
1141      * - when `from` is zero, `amount` tokens have been minted for `to`.
1142      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1143      * - `from` and `to` are never both zero.
1144      *
1145      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1146      */
1147     function _afterTokenTransfer(
1148         address from,
1149         address to,
1150         uint256 amount
1151     ) internal virtual {}
1152 }
1153 
1154 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
1155 
1156 
1157 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
1158 
1159 pragma solidity ^0.8.0;
1160 
1161 
1162 
1163 
1164 /**
1165  * @title SafeERC20
1166  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1167  * contract returns false). Tokens that return no value (and instead revert or
1168  * throw on failure) are also supported, non-reverting calls are assumed to be
1169  * successful.
1170  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1171  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1172  */
1173 library SafeERC20 {
1174     using Address for address;
1175 
1176     function safeTransfer(
1177         IERC20 token,
1178         address to,
1179         uint256 value
1180     ) internal {
1181         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1182     }
1183 
1184     function safeTransferFrom(
1185         IERC20 token,
1186         address from,
1187         address to,
1188         uint256 value
1189     ) internal {
1190         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1191     }
1192 
1193     /**
1194      * @dev Deprecated. This function has issues similar to the ones found in
1195      * {IERC20-approve}, and its usage is discouraged.
1196      *
1197      * Whenever possible, use {safeIncreaseAllowance} and
1198      * {safeDecreaseAllowance} instead.
1199      */
1200     function safeApprove(
1201         IERC20 token,
1202         address spender,
1203         uint256 value
1204     ) internal {
1205         // safeApprove should only be called when setting an initial allowance,
1206         // or when resetting it to zero. To increase and decrease it, use
1207         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1208         require(
1209             (value == 0) || (token.allowance(address(this), spender) == 0),
1210             "SafeERC20: approve from non-zero to non-zero allowance"
1211         );
1212         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1213     }
1214 
1215     function safeIncreaseAllowance(
1216         IERC20 token,
1217         address spender,
1218         uint256 value
1219     ) internal {
1220         uint256 newAllowance = token.allowance(address(this), spender) + value;
1221         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1222     }
1223 
1224     function safeDecreaseAllowance(
1225         IERC20 token,
1226         address spender,
1227         uint256 value
1228     ) internal {
1229         unchecked {
1230             uint256 oldAllowance = token.allowance(address(this), spender);
1231             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1232             uint256 newAllowance = oldAllowance - value;
1233             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1234         }
1235     }
1236 
1237     function safePermit(
1238         IERC20Permit token,
1239         address owner,
1240         address spender,
1241         uint256 value,
1242         uint256 deadline,
1243         uint8 v,
1244         bytes32 r,
1245         bytes32 s
1246     ) internal {
1247         uint256 nonceBefore = token.nonces(owner);
1248         token.permit(owner, spender, value, deadline, v, r, s);
1249         uint256 nonceAfter = token.nonces(owner);
1250         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1251     }
1252 
1253     /**
1254      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1255      * on the return value: the return value is optional (but if data is returned, it must not be false).
1256      * @param token The token targeted by the call.
1257      * @param data The call data (encoded using abi.encode or one of its variants).
1258      */
1259     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1260         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1261         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1262         // the target address contains contract code and also asserts for success in the low-level call.
1263 
1264         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1265         if (returndata.length > 0) {
1266             // Return data is optional
1267             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1268         }
1269     }
1270 }
1271 
1272 // File: contracts/tokens/IpToken.sol
1273 
1274 
1275 pragma solidity 0.8.15;
1276 
1277 
1278 
1279 
1280 
1281 
1282 
1283 
1284 contract IpToken is IporOwnable, IIpToken, ERC20 {
1285     using SafeERC20 for IERC20;
1286 
1287     address private immutable _asset;
1288 
1289     uint8 private immutable _decimals;
1290 
1291     address private _joseph;
1292 
1293     modifier onlyJoseph() {
1294         require(_msgSender() == _joseph, MiltonErrors.CALLER_NOT_JOSEPH);
1295         _;
1296     }
1297 
1298     constructor(
1299         string memory name,
1300         string memory symbol,
1301         address asset
1302     ) ERC20(name, symbol) {
1303         require(address(0) != asset, IporErrors.WRONG_ADDRESS);
1304         _asset = asset;
1305         _decimals = 18;
1306     }
1307 
1308     function decimals() public view override returns (uint8) {
1309         return _decimals;
1310     }
1311 
1312     function getAsset() external view override returns (address) {
1313         return _asset;
1314     }
1315 
1316     function setJoseph(address newJoseph) external override onlyOwner {
1317         require(newJoseph != address(0), IporErrors.WRONG_ADDRESS);
1318         address oldJoseph = _joseph;
1319         _joseph = newJoseph;
1320         emit JosephChanged(_msgSender(), oldJoseph, newJoseph);
1321     }
1322 
1323     function mint(address account, uint256 amount) external override onlyJoseph {
1324         require(amount > 0, JosephErrors.IP_TOKEN_MINT_AMOUNT_TOO_LOW);
1325         _mint(account, amount);
1326         emit Mint(account, amount);
1327     }
1328 
1329     function burn(address account, uint256 amount) external override onlyJoseph {
1330         require(amount > 0, JosephErrors.IP_TOKEN_BURN_AMOUNT_TOO_LOW);
1331         _burn(account, amount);
1332         emit Burn(account, amount);
1333     }
1334 }
1335 
1336 contract IpTokenUsdt is IpToken {
1337     constructor(
1338         string memory name,
1339         string memory symbol,
1340         address asset
1341     ) IpToken(name, symbol, asset) {}
1342 }