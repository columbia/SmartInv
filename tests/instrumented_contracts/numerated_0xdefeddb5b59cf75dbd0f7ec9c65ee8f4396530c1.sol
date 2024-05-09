1 // SPDX-License-Identifier: MIT
2 // Sources flattened with hardhat v2.9.9 https://hardhat.org
3 
4 // File contracts/abstracts/Committee.sol
5 
6 
7 pragma solidity ^0.8.0;
8 
9 abstract contract Committee {
10     address public committee;
11 
12     struct CallData {
13         address target;
14         bytes data;
15     }
16 
17     modifier onlyCommittee() {
18         require(msg.sender == committee, "FORBIDDEN");
19         _;
20     }
21 
22     function setCommittee(address _committee) external onlyCommittee {
23         committee = _committee;
24     }
25 
26     function multiCall(CallData[] calldata callData) external onlyCommittee {
27         for (uint256 i; i < callData.length; i++) {
28             (bool success, ) = callData[i].target.call(callData[i].data);
29             require(success, "Transaction call failed");
30         }
31     }
32 }
33 
34 
35 // File contracts/interfaces/IBurnable.sol
36 
37 
38 pragma solidity ^0.8.0;
39 
40 interface IBurnable {
41     // support ERC20, ERC721
42     function burn(uint256) external;
43 
44     // support ERC20, ERC721
45     function burnFrom(address, uint256) external;
46 
47     //support ERC1155
48     function burn(
49         address account,
50         uint256 id,
51         uint256 amount
52     ) external;
53 
54     //support ERC1155
55     function burnBatch(
56         address account,
57         uint256[] calldata ids,
58         uint256[] calldata amounts
59     ) external;
60 }
61 
62 
63 // File contracts/interfaces/INativeWrap.sol
64 
65 
66 pragma solidity ^0.8.0;
67 
68 interface INativeWrap {
69     function deposit() external payable;
70 
71     function withdraw(uint256 _value) external;
72 }
73 
74 
75 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.7.0
76 
77 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
78 
79 pragma solidity ^0.8.0;
80 
81 /**
82  * @dev Interface of the ERC20 standard as defined in the EIP.
83  */
84 interface IERC20 {
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87      * another (`to`).
88      *
89      * Note that `value` may be zero.
90      */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95      * a call to {approve}. `value` is the new allowance.
96      */
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 
99     /**
100      * @dev Returns the amount of tokens in existence.
101      */
102     function totalSupply() external view returns (uint256);
103 
104     /**
105      * @dev Returns the amount of tokens owned by `account`.
106      */
107     function balanceOf(address account) external view returns (uint256);
108 
109     /**
110      * @dev Moves `amount` tokens from the caller's account to `to`.
111      *
112      * Returns a boolean value indicating whether the operation succeeded.
113      *
114      * Emits a {Transfer} event.
115      */
116     function transfer(address to, uint256 amount) external returns (bool);
117 
118     /**
119      * @dev Returns the remaining number of tokens that `spender` will be
120      * allowed to spend on behalf of `owner` through {transferFrom}. This is
121      * zero by default.
122      *
123      * This value changes when {approve} or {transferFrom} are called.
124      */
125     function allowance(address owner, address spender) external view returns (uint256);
126 
127     /**
128      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
129      *
130      * Returns a boolean value indicating whether the operation succeeded.
131      *
132      * IMPORTANT: Beware that changing an allowance with this method brings the risk
133      * that someone may use both the old and the new allowance by unfortunate
134      * transaction ordering. One possible solution to mitigate this race
135      * condition is to first reduce the spender's allowance to 0 and set the
136      * desired value afterwards:
137      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138      *
139      * Emits an {Approval} event.
140      */
141     function approve(address spender, uint256 amount) external returns (bool);
142 
143     /**
144      * @dev Moves `amount` tokens from `from` to `to` using the
145      * allowance mechanism. `amount` is then deducted from the caller's
146      * allowance.
147      *
148      * Returns a boolean value indicating whether the operation succeeded.
149      *
150      * Emits a {Transfer} event.
151      */
152     function transferFrom(
153         address from,
154         address to,
155         uint256 amount
156     ) external returns (bool);
157 }
158 
159 
160 // File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.7.0
161 
162 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
163 
164 pragma solidity ^0.8.0;
165 
166 /**
167  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
168  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
169  *
170  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
171  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
172  * need to send a transaction, and thus is not required to hold Ether at all.
173  */
174 interface IERC20Permit {
175     /**
176      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
177      * given ``owner``'s signed approval.
178      *
179      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
180      * ordering also apply here.
181      *
182      * Emits an {Approval} event.
183      *
184      * Requirements:
185      *
186      * - `spender` cannot be the zero address.
187      * - `deadline` must be a timestamp in the future.
188      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
189      * over the EIP712-formatted function arguments.
190      * - the signature must use ``owner``'s current nonce (see {nonces}).
191      *
192      * For more information on the signature format, see the
193      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
194      * section].
195      */
196     function permit(
197         address owner,
198         address spender,
199         uint256 value,
200         uint256 deadline,
201         uint8 v,
202         bytes32 r,
203         bytes32 s
204     ) external;
205 
206     /**
207      * @dev Returns the current nonce for `owner`. This value must be
208      * included whenever a signature is generated for {permit}.
209      *
210      * Every successful call to {permit} increases ``owner``'s nonce by one. This
211      * prevents a signature from being used multiple times.
212      */
213     function nonces(address owner) external view returns (uint256);
214 
215     /**
216      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
217      */
218     // solhint-disable-next-line func-name-mixedcase
219     function DOMAIN_SEPARATOR() external view returns (bytes32);
220 }
221 
222 
223 // File @openzeppelin/contracts/utils/Address.sol@v4.7.0
224 
225 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
226 
227 pragma solidity ^0.8.1;
228 
229 /**
230  * @dev Collection of functions related to the address type
231  */
232 library Address {
233     /**
234      * @dev Returns true if `account` is a contract.
235      *
236      * [IMPORTANT]
237      * ====
238      * It is unsafe to assume that an address for which this function returns
239      * false is an externally-owned account (EOA) and not a contract.
240      *
241      * Among others, `isContract` will return false for the following
242      * types of addresses:
243      *
244      *  - an externally-owned account
245      *  - a contract in construction
246      *  - an address where a contract will be created
247      *  - an address where a contract lived, but was destroyed
248      * ====
249      *
250      * [IMPORTANT]
251      * ====
252      * You shouldn't rely on `isContract` to protect against flash loan attacks!
253      *
254      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
255      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
256      * constructor.
257      * ====
258      */
259     function isContract(address account) internal view returns (bool) {
260         // This method relies on extcodesize/address.code.length, which returns 0
261         // for contracts in construction, since the code is only stored at the end
262         // of the constructor execution.
263 
264         return account.code.length > 0;
265     }
266 
267     /**
268      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
269      * `recipient`, forwarding all available gas and reverting on errors.
270      *
271      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
272      * of certain opcodes, possibly making contracts go over the 2300 gas limit
273      * imposed by `transfer`, making them unable to receive funds via
274      * `transfer`. {sendValue} removes this limitation.
275      *
276      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
277      *
278      * IMPORTANT: because control is transferred to `recipient`, care must be
279      * taken to not create reentrancy vulnerabilities. Consider using
280      * {ReentrancyGuard} or the
281      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
282      */
283     function sendValue(address payable recipient, uint256 amount) internal {
284         require(address(this).balance >= amount, "Address: insufficient balance");
285 
286         (bool success, ) = recipient.call{value: amount}("");
287         require(success, "Address: unable to send value, recipient may have reverted");
288     }
289 
290     /**
291      * @dev Performs a Solidity function call using a low level `call`. A
292      * plain `call` is an unsafe replacement for a function call: use this
293      * function instead.
294      *
295      * If `target` reverts with a revert reason, it is bubbled up by this
296      * function (like regular Solidity function calls).
297      *
298      * Returns the raw returned data. To convert to the expected return value,
299      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
300      *
301      * Requirements:
302      *
303      * - `target` must be a contract.
304      * - calling `target` with `data` must not revert.
305      *
306      * _Available since v3.1._
307      */
308     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
309         return functionCall(target, data, "Address: low-level call failed");
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
314      * `errorMessage` as a fallback revert reason when `target` reverts.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(
319         address target,
320         bytes memory data,
321         string memory errorMessage
322     ) internal returns (bytes memory) {
323         return functionCallWithValue(target, data, 0, errorMessage);
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
328      * but also transferring `value` wei to `target`.
329      *
330      * Requirements:
331      *
332      * - the calling contract must have an ETH balance of at least `value`.
333      * - the called Solidity function must be `payable`.
334      *
335      * _Available since v3.1._
336      */
337     function functionCallWithValue(
338         address target,
339         bytes memory data,
340         uint256 value
341     ) internal returns (bytes memory) {
342         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
347      * with `errorMessage` as a fallback revert reason when `target` reverts.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(
352         address target,
353         bytes memory data,
354         uint256 value,
355         string memory errorMessage
356     ) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         require(isContract(target), "Address: call to non-contract");
359 
360         (bool success, bytes memory returndata) = target.call{value: value}(data);
361         return verifyCallResult(success, returndata, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but performing a static call.
367      *
368      * _Available since v3.3._
369      */
370     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
371         return functionStaticCall(target, data, "Address: low-level static call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
376      * but performing a static call.
377      *
378      * _Available since v3.3._
379      */
380     function functionStaticCall(
381         address target,
382         bytes memory data,
383         string memory errorMessage
384     ) internal view returns (bytes memory) {
385         require(isContract(target), "Address: static call to non-contract");
386 
387         (bool success, bytes memory returndata) = target.staticcall(data);
388         return verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
393      * but performing a delegate call.
394      *
395      * _Available since v3.4._
396      */
397     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
398         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
403      * but performing a delegate call.
404      *
405      * _Available since v3.4._
406      */
407     function functionDelegateCall(
408         address target,
409         bytes memory data,
410         string memory errorMessage
411     ) internal returns (bytes memory) {
412         require(isContract(target), "Address: delegate call to non-contract");
413 
414         (bool success, bytes memory returndata) = target.delegatecall(data);
415         return verifyCallResult(success, returndata, errorMessage);
416     }
417 
418     /**
419      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
420      * revert reason using the provided one.
421      *
422      * _Available since v4.3._
423      */
424     function verifyCallResult(
425         bool success,
426         bytes memory returndata,
427         string memory errorMessage
428     ) internal pure returns (bytes memory) {
429         if (success) {
430             return returndata;
431         } else {
432             // Look for revert reason and bubble it up if present
433             if (returndata.length > 0) {
434                 // The easiest way to bubble the revert reason is using memory via assembly
435                 /// @solidity memory-safe-assembly
436                 assembly {
437                     let returndata_size := mload(returndata)
438                     revert(add(32, returndata), returndata_size)
439                 }
440             } else {
441                 revert(errorMessage);
442             }
443         }
444     }
445 }
446 
447 
448 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.7.0
449 
450 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
451 
452 pragma solidity ^0.8.0;
453 
454 
455 
456 /**
457  * @title SafeERC20
458  * @dev Wrappers around ERC20 operations that throw on failure (when the token
459  * contract returns false). Tokens that return no value (and instead revert or
460  * throw on failure) are also supported, non-reverting calls are assumed to be
461  * successful.
462  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
463  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
464  */
465 library SafeERC20 {
466     using Address for address;
467 
468     function safeTransfer(
469         IERC20 token,
470         address to,
471         uint256 value
472     ) internal {
473         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
474     }
475 
476     function safeTransferFrom(
477         IERC20 token,
478         address from,
479         address to,
480         uint256 value
481     ) internal {
482         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
483     }
484 
485     /**
486      * @dev Deprecated. This function has issues similar to the ones found in
487      * {IERC20-approve}, and its usage is discouraged.
488      *
489      * Whenever possible, use {safeIncreaseAllowance} and
490      * {safeDecreaseAllowance} instead.
491      */
492     function safeApprove(
493         IERC20 token,
494         address spender,
495         uint256 value
496     ) internal {
497         // safeApprove should only be called when setting an initial allowance,
498         // or when resetting it to zero. To increase and decrease it, use
499         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
500         require(
501             (value == 0) || (token.allowance(address(this), spender) == 0),
502             "SafeERC20: approve from non-zero to non-zero allowance"
503         );
504         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
505     }
506 
507     function safeIncreaseAllowance(
508         IERC20 token,
509         address spender,
510         uint256 value
511     ) internal {
512         uint256 newAllowance = token.allowance(address(this), spender) + value;
513         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
514     }
515 
516     function safeDecreaseAllowance(
517         IERC20 token,
518         address spender,
519         uint256 value
520     ) internal {
521         unchecked {
522             uint256 oldAllowance = token.allowance(address(this), spender);
523             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
524             uint256 newAllowance = oldAllowance - value;
525             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
526         }
527     }
528 
529     function safePermit(
530         IERC20Permit token,
531         address owner,
532         address spender,
533         uint256 value,
534         uint256 deadline,
535         uint8 v,
536         bytes32 r,
537         bytes32 s
538     ) internal {
539         uint256 nonceBefore = token.nonces(owner);
540         token.permit(owner, spender, value, deadline, v, r, s);
541         uint256 nonceAfter = token.nonces(owner);
542         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
543     }
544 
545     /**
546      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
547      * on the return value: the return value is optional (but if data is returned, it must not be false).
548      * @param token The token targeted by the call.
549      * @param data The call data (encoded using abi.encode or one of its variants).
550      */
551     function _callOptionalReturn(IERC20 token, bytes memory data) private {
552         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
553         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
554         // the target address contains contract code and also asserts for success in the low-level call.
555 
556         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
557         if (returndata.length > 0) {
558             // Return data is optional
559             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
560         }
561     }
562 }
563 
564 
565 // File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.7.0
566 
567 // OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableSet.sol)
568 
569 pragma solidity ^0.8.0;
570 
571 /**
572  * @dev Library for managing
573  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
574  * types.
575  *
576  * Sets have the following properties:
577  *
578  * - Elements are added, removed, and checked for existence in constant time
579  * (O(1)).
580  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
581  *
582  * ```
583  * contract Example {
584  *     // Add the library methods
585  *     using EnumerableSet for EnumerableSet.AddressSet;
586  *
587  *     // Declare a set state variable
588  *     EnumerableSet.AddressSet private mySet;
589  * }
590  * ```
591  *
592  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
593  * and `uint256` (`UintSet`) are supported.
594  *
595  * [WARNING]
596  * ====
597  *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
598  *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
599  *
600  *  In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an array of EnumerableSet.
601  * ====
602  */
603 library EnumerableSet {
604     // To implement this library for multiple types with as little code
605     // repetition as possible, we write it in terms of a generic Set type with
606     // bytes32 values.
607     // The Set implementation uses private functions, and user-facing
608     // implementations (such as AddressSet) are just wrappers around the
609     // underlying Set.
610     // This means that we can only create new EnumerableSets for types that fit
611     // in bytes32.
612 
613     struct Set {
614         // Storage of set values
615         bytes32[] _values;
616         // Position of the value in the `values` array, plus 1 because index 0
617         // means a value is not in the set.
618         mapping(bytes32 => uint256) _indexes;
619     }
620 
621     /**
622      * @dev Add a value to a set. O(1).
623      *
624      * Returns true if the value was added to the set, that is if it was not
625      * already present.
626      */
627     function _add(Set storage set, bytes32 value) private returns (bool) {
628         if (!_contains(set, value)) {
629             set._values.push(value);
630             // The value is stored at length-1, but we add 1 to all indexes
631             // and use 0 as a sentinel value
632             set._indexes[value] = set._values.length;
633             return true;
634         } else {
635             return false;
636         }
637     }
638 
639     /**
640      * @dev Removes a value from a set. O(1).
641      *
642      * Returns true if the value was removed from the set, that is if it was
643      * present.
644      */
645     function _remove(Set storage set, bytes32 value) private returns (bool) {
646         // We read and store the value's index to prevent multiple reads from the same storage slot
647         uint256 valueIndex = set._indexes[value];
648 
649         if (valueIndex != 0) {
650             // Equivalent to contains(set, value)
651             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
652             // the array, and then remove the last element (sometimes called as 'swap and pop').
653             // This modifies the order of the array, as noted in {at}.
654 
655             uint256 toDeleteIndex = valueIndex - 1;
656             uint256 lastIndex = set._values.length - 1;
657 
658             if (lastIndex != toDeleteIndex) {
659                 bytes32 lastValue = set._values[lastIndex];
660 
661                 // Move the last value to the index where the value to delete is
662                 set._values[toDeleteIndex] = lastValue;
663                 // Update the index for the moved value
664                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
665             }
666 
667             // Delete the slot where the moved value was stored
668             set._values.pop();
669 
670             // Delete the index for the deleted slot
671             delete set._indexes[value];
672 
673             return true;
674         } else {
675             return false;
676         }
677     }
678 
679     /**
680      * @dev Returns true if the value is in the set. O(1).
681      */
682     function _contains(Set storage set, bytes32 value) private view returns (bool) {
683         return set._indexes[value] != 0;
684     }
685 
686     /**
687      * @dev Returns the number of values on the set. O(1).
688      */
689     function _length(Set storage set) private view returns (uint256) {
690         return set._values.length;
691     }
692 
693     /**
694      * @dev Returns the value stored at position `index` in the set. O(1).
695      *
696      * Note that there are no guarantees on the ordering of values inside the
697      * array, and it may change when more values are added or removed.
698      *
699      * Requirements:
700      *
701      * - `index` must be strictly less than {length}.
702      */
703     function _at(Set storage set, uint256 index) private view returns (bytes32) {
704         return set._values[index];
705     }
706 
707     /**
708      * @dev Return the entire set in an array
709      *
710      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
711      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
712      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
713      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
714      */
715     function _values(Set storage set) private view returns (bytes32[] memory) {
716         return set._values;
717     }
718 
719     // Bytes32Set
720 
721     struct Bytes32Set {
722         Set _inner;
723     }
724 
725     /**
726      * @dev Add a value to a set. O(1).
727      *
728      * Returns true if the value was added to the set, that is if it was not
729      * already present.
730      */
731     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
732         return _add(set._inner, value);
733     }
734 
735     /**
736      * @dev Removes a value from a set. O(1).
737      *
738      * Returns true if the value was removed from the set, that is if it was
739      * present.
740      */
741     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
742         return _remove(set._inner, value);
743     }
744 
745     /**
746      * @dev Returns true if the value is in the set. O(1).
747      */
748     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
749         return _contains(set._inner, value);
750     }
751 
752     /**
753      * @dev Returns the number of values in the set. O(1).
754      */
755     function length(Bytes32Set storage set) internal view returns (uint256) {
756         return _length(set._inner);
757     }
758 
759     /**
760      * @dev Returns the value stored at position `index` in the set. O(1).
761      *
762      * Note that there are no guarantees on the ordering of values inside the
763      * array, and it may change when more values are added or removed.
764      *
765      * Requirements:
766      *
767      * - `index` must be strictly less than {length}.
768      */
769     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
770         return _at(set._inner, index);
771     }
772 
773     /**
774      * @dev Return the entire set in an array
775      *
776      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
777      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
778      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
779      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
780      */
781     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
782         return _values(set._inner);
783     }
784 
785     // AddressSet
786 
787     struct AddressSet {
788         Set _inner;
789     }
790 
791     /**
792      * @dev Add a value to a set. O(1).
793      *
794      * Returns true if the value was added to the set, that is if it was not
795      * already present.
796      */
797     function add(AddressSet storage set, address value) internal returns (bool) {
798         return _add(set._inner, bytes32(uint256(uint160(value))));
799     }
800 
801     /**
802      * @dev Removes a value from a set. O(1).
803      *
804      * Returns true if the value was removed from the set, that is if it was
805      * present.
806      */
807     function remove(AddressSet storage set, address value) internal returns (bool) {
808         return _remove(set._inner, bytes32(uint256(uint160(value))));
809     }
810 
811     /**
812      * @dev Returns true if the value is in the set. O(1).
813      */
814     function contains(AddressSet storage set, address value) internal view returns (bool) {
815         return _contains(set._inner, bytes32(uint256(uint160(value))));
816     }
817 
818     /**
819      * @dev Returns the number of values in the set. O(1).
820      */
821     function length(AddressSet storage set) internal view returns (uint256) {
822         return _length(set._inner);
823     }
824 
825     /**
826      * @dev Returns the value stored at position `index` in the set. O(1).
827      *
828      * Note that there are no guarantees on the ordering of values inside the
829      * array, and it may change when more values are added or removed.
830      *
831      * Requirements:
832      *
833      * - `index` must be strictly less than {length}.
834      */
835     function at(AddressSet storage set, uint256 index) internal view returns (address) {
836         return address(uint160(uint256(_at(set._inner, index))));
837     }
838 
839     /**
840      * @dev Return the entire set in an array
841      *
842      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
843      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
844      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
845      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
846      */
847     function values(AddressSet storage set) internal view returns (address[] memory) {
848         bytes32[] memory store = _values(set._inner);
849         address[] memory result;
850 
851         /// @solidity memory-safe-assembly
852         assembly {
853             result := store
854         }
855 
856         return result;
857     }
858 
859     // UintSet
860 
861     struct UintSet {
862         Set _inner;
863     }
864 
865     /**
866      * @dev Add a value to a set. O(1).
867      *
868      * Returns true if the value was added to the set, that is if it was not
869      * already present.
870      */
871     function add(UintSet storage set, uint256 value) internal returns (bool) {
872         return _add(set._inner, bytes32(value));
873     }
874 
875     /**
876      * @dev Removes a value from a set. O(1).
877      *
878      * Returns true if the value was removed from the set, that is if it was
879      * present.
880      */
881     function remove(UintSet storage set, uint256 value) internal returns (bool) {
882         return _remove(set._inner, bytes32(value));
883     }
884 
885     /**
886      * @dev Returns true if the value is in the set. O(1).
887      */
888     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
889         return _contains(set._inner, bytes32(value));
890     }
891 
892     /**
893      * @dev Returns the number of values on the set. O(1).
894      */
895     function length(UintSet storage set) internal view returns (uint256) {
896         return _length(set._inner);
897     }
898 
899     /**
900      * @dev Returns the value stored at position `index` in the set. O(1).
901      *
902      * Note that there are no guarantees on the ordering of values inside the
903      * array, and it may change when more values are added or removed.
904      *
905      * Requirements:
906      *
907      * - `index` must be strictly less than {length}.
908      */
909     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
910         return uint256(_at(set._inner, index));
911     }
912 
913     /**
914      * @dev Return the entire set in an array
915      *
916      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
917      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
918      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
919      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
920      */
921     function values(UintSet storage set) internal view returns (uint256[] memory) {
922         bytes32[] memory store = _values(set._inner);
923         uint256[] memory result;
924 
925         /// @solidity memory-safe-assembly
926         assembly {
927             result := store
928         }
929 
930         return result;
931     }
932 }
933 
934 
935 // File @openzeppelin/contracts/utils/Context.sol@v4.7.0
936 
937 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
938 
939 pragma solidity ^0.8.0;
940 
941 /**
942  * @dev Provides information about the current execution context, including the
943  * sender of the transaction and its data. While these are generally available
944  * via msg.sender and msg.data, they should not be accessed in such a direct
945  * manner, since when dealing with meta-transactions the account sending and
946  * paying for execution may not be the actual sender (as far as an application
947  * is concerned).
948  *
949  * This contract is only required for intermediate, library-like contracts.
950  */
951 abstract contract Context {
952     function _msgSender() internal view virtual returns (address) {
953         return msg.sender;
954     }
955 
956     function _msgData() internal view virtual returns (bytes calldata) {
957         return msg.data;
958     }
959 }
960 
961 
962 // File @openzeppelin/contracts/security/Pausable.sol@v4.7.0
963 
964 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
965 
966 pragma solidity ^0.8.0;
967 
968 /**
969  * @dev Contract module which allows children to implement an emergency stop
970  * mechanism that can be triggered by an authorized account.
971  *
972  * This module is used through inheritance. It will make available the
973  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
974  * the functions of your contract. Note that they will not be pausable by
975  * simply including this module, only once the modifiers are put in place.
976  */
977 abstract contract Pausable is Context {
978     /**
979      * @dev Emitted when the pause is triggered by `account`.
980      */
981     event Paused(address account);
982 
983     /**
984      * @dev Emitted when the pause is lifted by `account`.
985      */
986     event Unpaused(address account);
987 
988     bool private _paused;
989 
990     /**
991      * @dev Initializes the contract in unpaused state.
992      */
993     constructor() {
994         _paused = false;
995     }
996 
997     /**
998      * @dev Modifier to make a function callable only when the contract is not paused.
999      *
1000      * Requirements:
1001      *
1002      * - The contract must not be paused.
1003      */
1004     modifier whenNotPaused() {
1005         _requireNotPaused();
1006         _;
1007     }
1008 
1009     /**
1010      * @dev Modifier to make a function callable only when the contract is paused.
1011      *
1012      * Requirements:
1013      *
1014      * - The contract must be paused.
1015      */
1016     modifier whenPaused() {
1017         _requirePaused();
1018         _;
1019     }
1020 
1021     /**
1022      * @dev Returns true if the contract is paused, and false otherwise.
1023      */
1024     function paused() public view virtual returns (bool) {
1025         return _paused;
1026     }
1027 
1028     /**
1029      * @dev Throws if the contract is paused.
1030      */
1031     function _requireNotPaused() internal view virtual {
1032         require(!paused(), "Pausable: paused");
1033     }
1034 
1035     /**
1036      * @dev Throws if the contract is not paused.
1037      */
1038     function _requirePaused() internal view virtual {
1039         require(paused(), "Pausable: not paused");
1040     }
1041 
1042     /**
1043      * @dev Triggers stopped state.
1044      *
1045      * Requirements:
1046      *
1047      * - The contract must not be paused.
1048      */
1049     function _pause() internal virtual whenNotPaused {
1050         _paused = true;
1051         emit Paused(_msgSender());
1052     }
1053 
1054     /**
1055      * @dev Returns to normal state.
1056      *
1057      * Requirements:
1058      *
1059      * - The contract must be paused.
1060      */
1061     function _unpause() internal virtual whenPaused {
1062         _paused = false;
1063         emit Unpaused(_msgSender());
1064     }
1065 }
1066 
1067 
1068 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.7.0
1069 
1070 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1071 
1072 pragma solidity ^0.8.0;
1073 
1074 /**
1075  * @dev Contract module that helps prevent reentrant calls to a function.
1076  *
1077  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1078  * available, which can be applied to functions to make sure there are no nested
1079  * (reentrant) calls to them.
1080  *
1081  * Note that because there is a single `nonReentrant` guard, functions marked as
1082  * `nonReentrant` may not call one another. This can be worked around by making
1083  * those functions `private`, and then adding `external` `nonReentrant` entry
1084  * points to them.
1085  *
1086  * TIP: If you would like to learn more about reentrancy and alternative ways
1087  * to protect against it, check out our blog post
1088  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1089  */
1090 abstract contract ReentrancyGuard {
1091     // Booleans are more expensive than uint256 or any type that takes up a full
1092     // word because each write operation emits an extra SLOAD to first read the
1093     // slot's contents, replace the bits taken up by the boolean, and then write
1094     // back. This is the compiler's defense against contract upgrades and
1095     // pointer aliasing, and it cannot be disabled.
1096 
1097     // The values being non-zero value makes deployment a bit more expensive,
1098     // but in exchange the refund on every call to nonReentrant will be lower in
1099     // amount. Since refunds are capped to a percentage of the total
1100     // transaction's gas, it is best to keep them low in cases like this one, to
1101     // increase the likelihood of the full refund coming into effect.
1102     uint256 private constant _NOT_ENTERED = 1;
1103     uint256 private constant _ENTERED = 2;
1104 
1105     uint256 private _status;
1106 
1107     constructor() {
1108         _status = _NOT_ENTERED;
1109     }
1110 
1111     /**
1112      * @dev Prevents a contract from calling itself, directly or indirectly.
1113      * Calling a `nonReentrant` function from another `nonReentrant`
1114      * function is not supported. It is possible to prevent this from happening
1115      * by making the `nonReentrant` function external, and making it call a
1116      * `private` function that does the actual work.
1117      */
1118     modifier nonReentrant() {
1119         // On the first call to nonReentrant, _notEntered will be true
1120         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1121 
1122         // Any calls to nonReentrant after this point will fail
1123         _status = _ENTERED;
1124 
1125         _;
1126 
1127         // By storing the original value once again, a refund is triggered (see
1128         // https://eips.ethereum.org/EIPS/eip-2200)
1129         _status = _NOT_ENTERED;
1130     }
1131 }
1132 
1133 
1134 // File contracts/BridgeERC20V2.sol
1135 
1136 
1137 pragma solidity ^0.8.0;
1138 
1139 
1140 
1141 
1142 
1143 
1144 
1145 
1146 contract BridgeERC20V2 is Committee, Pausable, ReentrancyGuard {
1147     using SafeERC20 for IERC20;
1148     using EnumerableSet for EnumerableSet.UintSet;
1149 
1150     enum FEE_TYPE {
1151         NO_FEE,
1152         FIX,
1153         PERCENTAGE
1154     }
1155 
1156     enum TOKEN_STRATEGY {
1157         LOCK,
1158         BURN
1159     }
1160 
1161     struct ERC20BridgeInfo {
1162         IERC20 token;
1163         address feeReceiver;
1164         // if fee type is PERCENTAGE it will be divided by 10,000 (50 mean 0.5%) else it mean fix rate
1165         uint256 fee;
1166         FEE_TYPE feeType;
1167         TOKEN_STRATEGY strategy;
1168         address receiver;
1169     }
1170 
1171     address public wrapNative;
1172 
1173     mapping(IERC20 => EnumerableSet.UintSet) private _destChains;
1174 
1175     mapping(IERC20 => ERC20BridgeInfo) public bridgeInfoByToken;
1176 
1177     event Bridge(address indexed token, address indexed from, uint256 amount, uint256 indexed destChainID);
1178 
1179     event AddDestChainID(address indexed token, uint256 indexed chainID);
1180     event RemoveDestChainID(address indexed token, uint256 indexed chainID);
1181 
1182     event SetToken(address indexed token);
1183     event WrapNativeSet(address indexed sender, address indexed from, address indexed to);
1184     event DeleteToken(address indexed token);
1185 
1186     constructor(
1187         address _committee,
1188         address _wrapNative,
1189         ERC20BridgeInfo[] memory _tokens,
1190         uint256[][] memory _destChainIDs
1191     ) {
1192         for (uint256 i; i < _tokens.length; i++) {
1193             _setToken(_tokens[i]);
1194             for (uint256 j; j < _destChainIDs[i].length; j++) {
1195                 _addDestChainID(_tokens[i].token, _destChainIDs[i][j]);
1196             }
1197         }
1198         committee = _committee;
1199         wrapNative = _wrapNative;
1200     }
1201 
1202     ///////////////////////////////// setter /////////////////////////////////////
1203 
1204     function pause() external onlyCommittee {
1205         _pause();
1206     }
1207 
1208     function unpause() external onlyCommittee {
1209         _unpause();
1210     }
1211 
1212     function addDestChainID(IERC20 _token, uint256 _destChainID) public onlyCommittee {
1213         _addDestChainID(_token, _destChainID);
1214     }
1215 
1216     function removeDestChainID(IERC20 _token, uint256 _destChainID) external onlyCommittee {
1217         _destChains[_token].remove(_destChainID);
1218         emit RemoveDestChainID(address(_token), _destChainID);
1219     }
1220 
1221     function getDestChains(IERC20 _token) external view returns (uint256[] memory) {
1222         uint256 length = _destChains[_token].length();
1223         uint256[] memory results = new uint256[](length);
1224         for (uint256 i; i < length; i++) {
1225             results[i] = _destChains[_token].at(i);
1226         }
1227         return results;
1228     }
1229 
1230     function setToken(ERC20BridgeInfo memory _bridgeInfo) public onlyCommittee {
1231         _setToken(_bridgeInfo);
1232     }
1233 
1234     function setWrapNative(address _wrapNative) external onlyCommittee {
1235         require(_wrapNative != address(0));
1236         emit WrapNativeSet(msg.sender, wrapNative, _wrapNative);
1237         wrapNative = _wrapNative;
1238     }
1239 
1240     function deleteToken(IERC20 _token) external onlyCommittee {
1241         require(address(_token) != address(0));
1242         delete bridgeInfoByToken[_token];
1243         emit DeleteToken(address(_token));
1244     }
1245 
1246     function _addDestChainID(IERC20 _token, uint256 _destChainID) private {
1247         _destChains[_token].add(_destChainID);
1248         emit AddDestChainID(address(_token), _destChainID);
1249     }
1250 
1251     function _setToken(ERC20BridgeInfo memory _bridgeInfo) private {
1252         require(address(_bridgeInfo.token) != address(0));
1253         bridgeInfoByToken[_bridgeInfo.token] = _bridgeInfo;
1254         emit SetToken(address(_bridgeInfo.token));
1255     }
1256 
1257     //////////////////////////////////////////////////////////////////////////////
1258 
1259     function bridge(
1260         IERC20 _token,
1261         uint256 _amount,
1262         uint256 _destChainID
1263     ) external whenNotPaused nonReentrant {
1264         _bridge(_token, _amount, _destChainID, false);
1265     }
1266 
1267     function bridge(uint256 _destChainID) external payable whenNotPaused nonReentrant {
1268         INativeWrap(wrapNative).deposit{ value: msg.value }();
1269         _bridge(IERC20(wrapNative), msg.value, _destChainID, true);
1270     }
1271 
1272     function _bridge(
1273         IERC20 _token,
1274         uint256 _amount,
1275         uint256 _destChainID,
1276         bool _isNative
1277     ) private {
1278         require(!_isContract(msg.sender), "IS_CONTRACT");
1279         require(address(bridgeInfoByToken[_token].token) != address(0), "TOKEN_IS_NOT_SET");
1280         require(_destChains[_token].contains(_destChainID), "CHAIN_NOT_SUPPORTED");
1281 
1282         ERC20BridgeInfo memory bridgeInfo = bridgeInfoByToken[_token];
1283 
1284         uint256 fee = _computeFeeByFeeType(bridgeInfo.feeType, _amount, bridgeInfo.fee);
1285 
1286         uint256 totalAmount = _amount - fee;
1287 
1288         if (_isNative) {
1289             if (bridgeInfo.strategy == TOKEN_STRATEGY.LOCK) {
1290                 _token.safeTransfer(bridgeInfo.receiver, totalAmount);
1291             }
1292             if (bridgeInfo.feeType != FEE_TYPE.NO_FEE && fee > 0) {
1293                 _token.safeTransfer(bridgeInfo.feeReceiver, fee);
1294             }
1295         } else {
1296             if (bridgeInfo.strategy == TOKEN_STRATEGY.LOCK) {
1297                 _token.safeTransferFrom(msg.sender, bridgeInfo.receiver, totalAmount);
1298             } else {
1299                 IBurnable(address(_token)).burnFrom(msg.sender, totalAmount);
1300             }
1301             if (bridgeInfo.feeType != FEE_TYPE.NO_FEE && fee > 0) {
1302                 _token.safeTransferFrom(msg.sender, bridgeInfo.feeReceiver, fee);
1303             }
1304         }
1305 
1306         emit Bridge(address(bridgeInfo.token), msg.sender, totalAmount, _destChainID);
1307     }
1308 
1309     function _computeFeeByFeeType(
1310         FEE_TYPE feeType,
1311         uint256 _amount,
1312         uint256 _fee
1313     ) private pure returns (uint256) {
1314         if (feeType == FEE_TYPE.FIX) {
1315             return _fee;
1316         } else if (feeType == FEE_TYPE.PERCENTAGE) {
1317             return (_amount * _fee) / 10000;
1318         }
1319         return 0;
1320     }
1321 
1322     function computeFeeByFeeType(IERC20 _token, uint256 _amount) public view returns (uint256) {
1323         return _computeFeeByFeeType(bridgeInfoByToken[_token].feeType, _amount, bridgeInfoByToken[_token].fee);
1324     }
1325 
1326     function _isContract(address _account) private view returns (bool) {
1327         uint32 size;
1328         assembly {
1329             size := extcodesize(_account)
1330         }
1331         return size > 0;
1332     }
1333 }