1 pragma solidity ^0.7.1;
2 //SPDX-License-Identifier: UNLICENSED
3 
4 /* New ERC23 contract interface */
5 
6 interface IErc223 {
7     function totalSupply() external view returns (uint);
8 
9     function balanceOf(address who) external view returns (uint);
10 
11     function transfer(address to, uint value) external returns (bool ok);
12     function transfer(address to, uint value, bytes memory data) external returns (bool ok);
13     
14     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
15 }
16 
17 /**
18 * @title Contract that will work with ERC223 tokens.
19 */
20 
21 interface IErc223ReceivingContract {
22     /**
23      * @dev Standard ERC223 function that will handle incoming token transfers.
24      *
25      * @param _from  Token sender address.
26      * @param _value Amount of tokens.
27      * @param _data  Transaction metadata.
28      */
29     function tokenFallback(address _from, uint _value, bytes memory _data) external returns (bool ok);
30 }
31 
32 
33 interface IErc20 {
34     function totalSupply() external view returns (uint);
35     function balanceOf(address tokenOwner) external view returns (uint balance);
36     function transfer(address to, uint tokens) external returns (bool success);
37 
38     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
39     function approve(address spender, uint tokens) external returns (bool success);
40     function transferFrom(address from, address to, uint tokens) external returns (bool success);
41 
42     event Transfer(address indexed from, address indexed to, uint tokens);
43     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
44 }
45 
46 
47 
48 
49 /**
50  * @dev Collection of functions related to the address type
51  */
52 library Address {
53     /**
54      * @dev Returns true if `account` is a contract.
55      *
56      * [IMPORTANT]
57      * ====
58      * It is unsafe to assume that an address for which this function returns
59      * false is an externally-owned account (EOA) and not a contract.
60      *
61      * Among others, `isContract` will return false for the following
62      * types of addresses:
63      *
64      *  - an externally-owned account
65      *  - a contract in construction
66      *  - an address where a contract will be created
67      *  - an address where a contract lived, but was destroyed
68      * ====
69      */
70     function isContract(address account) internal view returns (bool) {
71         // This method relies on extcodesize, which returns 0 for contracts in
72         // construction, since the code is only stored at the end of the
73         // constructor execution.
74 
75         uint256 size;
76         // solhint-disable-next-line no-inline-assembly
77         assembly { size := extcodesize(account) }
78         return size > 0;
79     }
80 
81     /**
82      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
83      * `recipient`, forwarding all available gas and reverting on errors.
84      *
85      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
86      * of certain opcodes, possibly making contracts go over the 2300 gas limit
87      * imposed by `transfer`, making them unable to receive funds via
88      * `transfer`. {sendValue} removes this limitation.
89      *
90      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
91      *
92      * IMPORTANT: because control is transferred to `recipient`, care must be
93      * taken to not create reentrancy vulnerabilities. Consider using
94      * {ReentrancyGuard} or the
95      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
96      */
97     function sendValue(address payable recipient, uint256 amount) internal {
98         require(address(this).balance >= amount, "Address: insufficient balance");
99 
100         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
101         (bool success, ) = recipient.call{ value: amount }("");
102         require(success, "Address: unable to send value, recipient may have reverted");
103     }
104 
105     /**
106      * @dev Performs a Solidity function call using a low level `call`. A
107      * plain`call` is an unsafe replacement for a function call: use this
108      * function instead.
109      *
110      * If `target` reverts with a revert reason, it is bubbled up by this
111      * function (like regular Solidity function calls).
112      *
113      * Returns the raw returned data. To convert to the expected return value,
114      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
115      *
116      * Requirements:
117      *
118      * - `target` must be a contract.
119      * - calling `target` with `data` must not revert.
120      *
121      * _Available since v3.1._
122      */
123     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
124       return functionCall(target, data, "Address: low-level call failed");
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
129      * `errorMessage` as a fallback revert reason when `target` reverts.
130      *
131      * _Available since v3.1._
132      */
133     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
134         return functionCallWithValue(target, data, 0, errorMessage);
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
139      * but also transferring `value` wei to `target`.
140      *
141      * Requirements:
142      *
143      * - the calling contract must have an ETH balance of at least `value`.
144      * - the called Solidity function must be `payable`.
145      *
146      * _Available since v3.1._
147      */
148     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
149         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
150     }
151 
152     /**
153      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
154      * with `errorMessage` as a fallback revert reason when `target` reverts.
155      *
156      * _Available since v3.1._
157      */
158     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
159         require(address(this).balance >= value, "Address: insufficient balance for call");
160         require(isContract(target), "Address: call to non-contract");
161 
162         // solhint-disable-next-line avoid-low-level-calls
163         (bool success, bytes memory returndata) = target.call{ value: value }(data);
164         return _verifyCallResult(success, returndata, errorMessage);
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
169      * but performing a static call.
170      *
171      * _Available since v3.3._
172      */
173     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
174         return functionStaticCall(target, data, "Address: low-level static call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
179      * but performing a static call.
180      *
181      * _Available since v3.3._
182      */
183     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
184         require(isContract(target), "Address: static call to non-contract");
185 
186         // solhint-disable-next-line avoid-low-level-calls
187         (bool success, bytes memory returndata) = target.staticcall(data);
188         return _verifyCallResult(success, returndata, errorMessage);
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
193      * but performing a delegate call.
194      *
195      * _Available since v3.4._
196      */
197     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
198         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
203      * but performing a delegate call.
204      *
205      * _Available since v3.4._
206      */
207     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
208         require(isContract(target), "Address: delegate call to non-contract");
209 
210         // solhint-disable-next-line avoid-low-level-calls
211         (bool success, bytes memory returndata) = target.delegatecall(data);
212         return _verifyCallResult(success, returndata, errorMessage);
213     }
214 
215     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
216         if (success) {
217             return returndata;
218         } else {
219             // Look for revert reason and bubble it up if present
220             if (returndata.length > 0) {
221                 // The easiest way to bubble the revert reason is using memory via assembly
222 
223                 // solhint-disable-next-line no-inline-assembly
224                 assembly {
225                     let returndata_size := mload(returndata)
226                     revert(add(32, returndata), returndata_size)
227                 }
228             } else {
229                 revert(errorMessage);
230             }
231         }
232     }
233 }
234 
235 
236 
237 interface IShyftCacheGraph {
238     function getTrustChannelManagerAddress() external view returns(address result);
239 
240     function compileCacheGraph(address _identifiedAddress, uint16 _idx) external;
241 
242     function getKycCanSend( address _senderIdentifiedAddress,
243                             address _receiverIdentifiedAddress,
244                             uint256 _amount,
245                             uint256 _bip32X_type,
246                             bool _requiredConsentFromAllParties,
247                             bool _payForDirty) external returns (uint8 result);
248 
249     function getActiveConsentedTrustChannelBitFieldForPair( address _senderIdentifiedAddress,
250                                                             address _receiverIdentifiedAddress) external returns (uint32 result);
251 
252     function getActiveTrustChannelBitFieldForPair(  address _senderIdentifiedAddress,
253                                                     address _receiverIdentifiedAddress) external returns (uint32 result);
254 
255     function getActiveConsentedTrustChannelRoutePossible(   address _firstAddress,
256                                                             address _secondAddress,
257                                                             address _trustChannelAddress) external view returns (bool result);
258 
259     function getActiveTrustChannelRoutePossible(address _firstAddress,
260                                                 address _secondAddress,
261                                                 address _trustChannelAddress) external view returns (bool result);
262 
263     function getRelativeTrustLevelOnlyClean(address _senderIdentifiedAddress,
264                                             address _receiverIdentifiedAddress,
265                                             uint256 _amount,
266                                             uint256 _bip32X_type,
267                                             bool _requiredConsentFromAllParties,
268                                             bool _requiredActive) external returns (int16 relativeTrustLevel, int16 externalTrustLevel);
269 
270     function calculateRelativeTrustLevel(   uint32 _trustChannelIndex,
271                                             uint256 _foundChannelRulesBitField,
272                                             address _senderIdentifiedAddress,
273                                             address _receiverIdentifiedAddress,
274                                             uint256 _amount,
275                                             uint256 _bip32X_type,
276                                             bool _requiredConsentFromAllParties,
277                                             bool _requiredActive) external returns(int16 relativeTrustLevel, int16 externalTrustLevel);
278 }
279 
280 
281 
282 interface IShyftKycContractRegistry  {
283     function isShyftKycContract(address _addr) external view returns (bool result);
284     function getCurrentContractAddress() external view returns (address);
285     function getContractAddressOfVersion(uint _version) external view returns (address);
286     function getContractVersionOfAddress(address _address) external view returns (uint256 result);
287 
288     function getAllTokenLocations(address _addr, uint256 _bip32X_type) external view returns (bool[] memory resultLocations, uint256 resultNumFound);
289     function getAllTokenLocationsAndBalances(address _addr, uint256 _bip32X_type) external view returns (bool[] memory resultLocations, uint256[] memory resultBalances, uint256 resultNumFound, uint256 resultTotalBalance);
290 }
291 
292 
293 
294 /// @dev Inheritable constants for token types
295 
296 contract TokenConstants {
297 
298     //@note: reference from https://github.com/satoshilabs/slips/blob/master/slip-0044.md
299     // hd chaincodes are 31 bits (max integer value = 2147483647)
300 
301     //@note: reference from https://chainid.network/
302     // ethereum-compatible chaincodes are 32 bits
303 
304     // given these, the final "nativeType" needs to be a mix of both.
305 
306     uint256 constant TestNetTokenOffset = 2**128;
307     uint256 constant PrivateNetTokenOffset = 2**192;
308 
309     uint256 constant ShyftTokenType = 7341;
310     uint256 constant EtherTokenType = 60;
311     uint256 constant EtherClassicTokenType = 61;
312     uint256 constant RootstockTokenType = 30;
313 
314     //Shyft Testnets
315     uint256 constant BridgeTownTokenType = TestNetTokenOffset + 0;
316 
317     //Ethereum Testnets
318     uint256 constant GoerliTokenType = 5;
319     uint256 constant KovanTokenType = 42;
320     uint256 constant RinkebyTokenType = 4;
321     uint256 constant RopstenTokenType = 3;
322 
323     //Ethereum Classic Testnets
324     uint256 constant KottiTokenType = 6;
325 
326     //Rootstock Testnets
327     uint256 constant RootstockTestnetTokenType = 31;
328 
329     //@note:@here:@deploy: need to hardcode test and/or privatenet for deploy on various blockchains
330     bool constant IsTestnet = false;
331     bool constant IsPrivatenet = false;
332 }
333 // pragma experimental ABIEncoderV2;
334 
335 
336 
337 
338 
339 
340 
341 
342 
343 
344 
345 /**
346  * @dev Library for managing
347  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
348  * types.
349  *
350  * Sets have the following properties:
351  *
352  * - Elements are added, removed, and checked for existence in constant time
353  * (O(1)).
354  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
355  *
356  * ```
357  * contract Example {
358  *     // Add the library methods
359  *     using EnumerableSet for EnumerableSet.AddressSet;
360  *
361  *     // Declare a set state variable
362  *     EnumerableSet.AddressSet private mySet;
363  * }
364  * ```
365  *
366  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
367  * and `uint256` (`UintSet`) are supported.
368  */
369 library EnumerableSet {
370     // To implement this library for multiple types with as little code
371     // repetition as possible, we write it in terms of a generic Set type with
372     // bytes32 values.
373     // The Set implementation uses private functions, and user-facing
374     // implementations (such as AddressSet) are just wrappers around the
375     // underlying Set.
376     // This means that we can only create new EnumerableSets for types that fit
377     // in bytes32.
378 
379     struct Set {
380         // Storage of set values
381         bytes32[] _values;
382 
383         // Position of the value in the `values` array, plus 1 because index 0
384         // means a value is not in the set.
385         mapping (bytes32 => uint256) _indexes;
386     }
387 
388     /**
389      * @dev Add a value to a set. O(1).
390      *
391      * Returns true if the value was added to the set, that is if it was not
392      * already present.
393      */
394     function _add(Set storage set, bytes32 value) private returns (bool) {
395         if (!_contains(set, value)) {
396             set._values.push(value);
397             // The value is stored at length-1, but we add 1 to all indexes
398             // and use 0 as a sentinel value
399             set._indexes[value] = set._values.length;
400             return true;
401         } else {
402             return false;
403         }
404     }
405 
406     /**
407      * @dev Removes a value from a set. O(1).
408      *
409      * Returns true if the value was removed from the set, that is if it was
410      * present.
411      */
412     function _remove(Set storage set, bytes32 value) private returns (bool) {
413         // We read and store the value's index to prevent multiple reads from the same storage slot
414         uint256 valueIndex = set._indexes[value];
415 
416         if (valueIndex != 0) { // Equivalent to contains(set, value)
417             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
418             // the array, and then remove the last element (sometimes called as 'swap and pop').
419             // This modifies the order of the array, as noted in {at}.
420 
421             uint256 toDeleteIndex = valueIndex - 1;
422             uint256 lastIndex = set._values.length - 1;
423 
424             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
425             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
426 
427             bytes32 lastvalue = set._values[lastIndex];
428 
429             // Move the last value to the index where the value to delete is
430             set._values[toDeleteIndex] = lastvalue;
431             // Update the index for the moved value
432             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
433 
434             // Delete the slot where the moved value was stored
435             set._values.pop();
436 
437             // Delete the index for the deleted slot
438             delete set._indexes[value];
439 
440             return true;
441         } else {
442             return false;
443         }
444     }
445 
446     /**
447      * @dev Returns true if the value is in the set. O(1).
448      */
449     function _contains(Set storage set, bytes32 value) private view returns (bool) {
450         return set._indexes[value] != 0;
451     }
452 
453     /**
454      * @dev Returns the number of values on the set. O(1).
455      */
456     function _length(Set storage set) private view returns (uint256) {
457         return set._values.length;
458     }
459 
460    /**
461     * @dev Returns the value stored at position `index` in the set. O(1).
462     *
463     * Note that there are no guarantees on the ordering of values inside the
464     * array, and it may change when more values are added or removed.
465     *
466     * Requirements:
467     *
468     * - `index` must be strictly less than {length}.
469     */
470     function _at(Set storage set, uint256 index) private view returns (bytes32) {
471         require(set._values.length > index, "EnumerableSet: index out of bounds");
472         return set._values[index];
473     }
474 
475     // Bytes32Set
476 
477     struct Bytes32Set {
478         Set _inner;
479     }
480 
481     /**
482      * @dev Add a value to a set. O(1).
483      *
484      * Returns true if the value was added to the set, that is if it was not
485      * already present.
486      */
487     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
488         return _add(set._inner, value);
489     }
490 
491     /**
492      * @dev Removes a value from a set. O(1).
493      *
494      * Returns true if the value was removed from the set, that is if it was
495      * present.
496      */
497     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
498         return _remove(set._inner, value);
499     }
500 
501     /**
502      * @dev Returns true if the value is in the set. O(1).
503      */
504     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
505         return _contains(set._inner, value);
506     }
507 
508     /**
509      * @dev Returns the number of values in the set. O(1).
510      */
511     function length(Bytes32Set storage set) internal view returns (uint256) {
512         return _length(set._inner);
513     }
514 
515    /**
516     * @dev Returns the value stored at position `index` in the set. O(1).
517     *
518     * Note that there are no guarantees on the ordering of values inside the
519     * array, and it may change when more values are added or removed.
520     *
521     * Requirements:
522     *
523     * - `index` must be strictly less than {length}.
524     */
525     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
526         return _at(set._inner, index);
527     }
528 
529     // AddressSet
530 
531     struct AddressSet {
532         Set _inner;
533     }
534 
535     /**
536      * @dev Add a value to a set. O(1).
537      *
538      * Returns true if the value was added to the set, that is if it was not
539      * already present.
540      */
541     function add(AddressSet storage set, address value) internal returns (bool) {
542         return _add(set._inner, bytes32(uint256(uint160(value))));
543     }
544 
545     /**
546      * @dev Removes a value from a set. O(1).
547      *
548      * Returns true if the value was removed from the set, that is if it was
549      * present.
550      */
551     function remove(AddressSet storage set, address value) internal returns (bool) {
552         return _remove(set._inner, bytes32(uint256(uint160(value))));
553     }
554 
555     /**
556      * @dev Returns true if the value is in the set. O(1).
557      */
558     function contains(AddressSet storage set, address value) internal view returns (bool) {
559         return _contains(set._inner, bytes32(uint256(uint160(value))));
560     }
561 
562     /**
563      * @dev Returns the number of values in the set. O(1).
564      */
565     function length(AddressSet storage set) internal view returns (uint256) {
566         return _length(set._inner);
567     }
568 
569    /**
570     * @dev Returns the value stored at position `index` in the set. O(1).
571     *
572     * Note that there are no guarantees on the ordering of values inside the
573     * array, and it may change when more values are added or removed.
574     *
575     * Requirements:
576     *
577     * - `index` must be strictly less than {length}.
578     */
579     function at(AddressSet storage set, uint256 index) internal view returns (address) {
580         return address(uint160(uint256(_at(set._inner, index))));
581     }
582 
583 
584     // UintSet
585 
586     struct UintSet {
587         Set _inner;
588     }
589 
590     /**
591      * @dev Add a value to a set. O(1).
592      *
593      * Returns true if the value was added to the set, that is if it was not
594      * already present.
595      */
596     function add(UintSet storage set, uint256 value) internal returns (bool) {
597         return _add(set._inner, bytes32(value));
598     }
599 
600     /**
601      * @dev Removes a value from a set. O(1).
602      *
603      * Returns true if the value was removed from the set, that is if it was
604      * present.
605      */
606     function remove(UintSet storage set, uint256 value) internal returns (bool) {
607         return _remove(set._inner, bytes32(value));
608     }
609 
610     /**
611      * @dev Returns true if the value is in the set. O(1).
612      */
613     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
614         return _contains(set._inner, bytes32(value));
615     }
616 
617     /**
618      * @dev Returns the number of values on the set. O(1).
619      */
620     function length(UintSet storage set) internal view returns (uint256) {
621         return _length(set._inner);
622     }
623 
624    /**
625     * @dev Returns the value stored at position `index` in the set. O(1).
626     *
627     * Note that there are no guarantees on the ordering of values inside the
628     * array, and it may change when more values are added or removed.
629     *
630     * Requirements:
631     *
632     * - `index` must be strictly less than {length}.
633     */
634     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
635         return uint256(_at(set._inner, index));
636     }
637 }
638 
639 
640 
641 
642 
643 
644 /*
645  * @dev Provides information about the current execution context, including the
646  * sender of the transaction and its data. While these are generally available
647  * via msg.sender and msg.data, they should not be accessed in such a direct
648  * manner, since when dealing with GSN meta-transactions the account sending and
649  * paying for execution may not be the actual sender (as far as an application
650  * is concerned).
651  *
652  * This contract is only required for intermediate, library-like contracts.
653  */
654 abstract contract Context {
655     function _msgSender() internal view virtual returns (address payable) {
656         return msg.sender;
657     }
658 
659     function _msgData() internal view virtual returns (bytes memory) {
660         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
661         return msg.data;
662     }
663 }
664 
665 
666 /**
667  * @dev Contract module that allows children to implement role-based access
668  * control mechanisms.
669  *
670  * Roles are referred to by their `bytes32` identifier. These should be exposed
671  * in the external API and be unique. The best way to achieve this is by
672  * using `public constant` hash digests:
673  *
674  * ```
675  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
676  * ```
677  *
678  * Roles can be used to represent a set of permissions. To restrict access to a
679  * function call, use {hasRole}:
680  *
681  * ```
682  * function foo() public {
683  *     require(hasRole(MY_ROLE, msg.sender));
684  *     ...
685  * }
686  * ```
687  *
688  * Roles can be granted and revoked dynamically via the {grantRole} and
689  * {revokeRole} functions. Each role has an associated admin role, and only
690  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
691  *
692  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
693  * that only accounts with this role will be able to grant or revoke other
694  * roles. More complex role relationships can be created by using
695  * {_setRoleAdmin}.
696  *
697  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
698  * grant and revoke this role. Extra precautions should be taken to secure
699  * accounts that have been granted it.
700  */
701 abstract contract AccessControl is Context {
702     using EnumerableSet for EnumerableSet.AddressSet;
703     using Address for address;
704 
705     struct RoleData {
706         EnumerableSet.AddressSet members;
707         bytes32 adminRole;
708     }
709 
710     mapping (bytes32 => RoleData) private _roles;
711 
712     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
713 
714     /**
715      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
716      *
717      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
718      * {RoleAdminChanged} not being emitted signaling this.
719      *
720      * _Available since v3.1._
721      */
722     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
723 
724     /**
725      * @dev Emitted when `account` is granted `role`.
726      *
727      * `sender` is the account that originated the contract call, an admin role
728      * bearer except when using {_setupRole}.
729      */
730     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
731 
732     /**
733      * @dev Emitted when `account` is revoked `role`.
734      *
735      * `sender` is the account that originated the contract call:
736      *   - if using `revokeRole`, it is the admin role bearer
737      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
738      */
739     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
740 
741     /**
742      * @dev Returns `true` if `account` has been granted `role`.
743      */
744     function hasRole(bytes32 role, address account) public view returns (bool) {
745         return _roles[role].members.contains(account);
746     }
747 
748     /**
749      * @dev Returns the number of accounts that have `role`. Can be used
750      * together with {getRoleMember} to enumerate all bearers of a role.
751      */
752     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
753         return _roles[role].members.length();
754     }
755 
756     /**
757      * @dev Returns one of the accounts that have `role`. `index` must be a
758      * value between 0 and {getRoleMemberCount}, non-inclusive.
759      *
760      * Role bearers are not sorted in any particular way, and their ordering may
761      * change at any point.
762      *
763      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
764      * you perform all queries on the same block. See the following
765      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
766      * for more information.
767      */
768     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
769         return _roles[role].members.at(index);
770     }
771 
772     /**
773      * @dev Returns the admin role that controls `role`. See {grantRole} and
774      * {revokeRole}.
775      *
776      * To change a role's admin, use {_setRoleAdmin}.
777      */
778     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
779         return _roles[role].adminRole;
780     }
781 
782     /**
783      * @dev Grants `role` to `account`.
784      *
785      * If `account` had not been already granted `role`, emits a {RoleGranted}
786      * event.
787      *
788      * Requirements:
789      *
790      * - the caller must have ``role``'s admin role.
791      */
792     function grantRole(bytes32 role, address account) public virtual {
793         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
794 
795         _grantRole(role, account);
796     }
797 
798     /**
799      * @dev Revokes `role` from `account`.
800      *
801      * If `account` had been granted `role`, emits a {RoleRevoked} event.
802      *
803      * Requirements:
804      *
805      * - the caller must have ``role``'s admin role.
806      */
807     function revokeRole(bytes32 role, address account) public virtual {
808         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
809 
810         _revokeRole(role, account);
811     }
812 
813     /**
814      * @dev Revokes `role` from the calling account.
815      *
816      * Roles are often managed via {grantRole} and {revokeRole}: this function's
817      * purpose is to provide a mechanism for accounts to lose their privileges
818      * if they are compromised (such as when a trusted device is misplaced).
819      *
820      * If the calling account had been granted `role`, emits a {RoleRevoked}
821      * event.
822      *
823      * Requirements:
824      *
825      * - the caller must be `account`.
826      */
827     function renounceRole(bytes32 role, address account) public virtual {
828         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
829 
830         _revokeRole(role, account);
831     }
832 
833     /**
834      * @dev Grants `role` to `account`.
835      *
836      * If `account` had not been already granted `role`, emits a {RoleGranted}
837      * event. Note that unlike {grantRole}, this function doesn't perform any
838      * checks on the calling account.
839      *
840      * [WARNING]
841      * ====
842      * This function should only be called from the constructor when setting
843      * up the initial roles for the system.
844      *
845      * Using this function in any other way is effectively circumventing the admin
846      * system imposed by {AccessControl}.
847      * ====
848      */
849     function _setupRole(bytes32 role, address account) internal virtual {
850         _grantRole(role, account);
851     }
852 
853     /**
854      * @dev Sets `adminRole` as ``role``'s admin role.
855      *
856      * Emits a {RoleAdminChanged} event.
857      */
858     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
859         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
860         _roles[role].adminRole = adminRole;
861     }
862 
863     function _grantRole(bytes32 role, address account) private {
864         if (_roles[role].members.add(account)) {
865             emit RoleGranted(role, account, _msgSender());
866         }
867     }
868 
869     function _revokeRole(bytes32 role, address account) private {
870         if (_roles[role].members.remove(account)) {
871             emit RoleRevoked(role, account, _msgSender());
872         }
873     }
874 }
875 
876 
877 
878 
879 
880 
881 
882 
883 
884 /**
885  * @dev Interface of the ERC20 standard as defined in the EIP.
886  */
887 interface IERC20 {
888     /**
889      * @dev Returns the amount of tokens in existence.
890      */
891     function totalSupply() external view returns (uint256);
892 
893     /**
894      * @dev Returns the amount of tokens owned by `account`.
895      */
896     function balanceOf(address account) external view returns (uint256);
897 
898     /**
899      * @dev Moves `amount` tokens from the caller's account to `recipient`.
900      *
901      * Returns a boolean value indicating whether the operation succeeded.
902      *
903      * Emits a {Transfer} event.
904      */
905     function transfer(address recipient, uint256 amount) external returns (bool);
906 
907     /**
908      * @dev Returns the remaining number of tokens that `spender` will be
909      * allowed to spend on behalf of `owner` through {transferFrom}. This is
910      * zero by default.
911      *
912      * This value changes when {approve} or {transferFrom} are called.
913      */
914     function allowance(address owner, address spender) external view returns (uint256);
915 
916     /**
917      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
918      *
919      * Returns a boolean value indicating whether the operation succeeded.
920      *
921      * IMPORTANT: Beware that changing an allowance with this method brings the risk
922      * that someone may use both the old and the new allowance by unfortunate
923      * transaction ordering. One possible solution to mitigate this race
924      * condition is to first reduce the spender's allowance to 0 and set the
925      * desired value afterwards:
926      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
927      *
928      * Emits an {Approval} event.
929      */
930     function approve(address spender, uint256 amount) external returns (bool);
931 
932     /**
933      * @dev Moves `amount` tokens from `sender` to `recipient` using the
934      * allowance mechanism. `amount` is then deducted from the caller's
935      * allowance.
936      *
937      * Returns a boolean value indicating whether the operation succeeded.
938      *
939      * Emits a {Transfer} event.
940      */
941     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
942 
943     /**
944      * @dev Emitted when `value` tokens are moved from one account (`from`) to
945      * another (`to`).
946      *
947      * Note that `value` may be zero.
948      */
949     event Transfer(address indexed from, address indexed to, uint256 value);
950 
951     /**
952      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
953      * a call to {approve}. `value` is the new allowance.
954      */
955     event Approval(address indexed owner, address indexed spender, uint256 value);
956 }
957 
958 
959 
960 
961 
962 /**
963  * @dev Wrappers over Solidity's arithmetic operations with added overflow
964  * checks.
965  *
966  * Arithmetic operations in Solidity wrap on overflow. This can easily result
967  * in bugs, because programmers usually assume that an overflow raises an
968  * error, which is the standard behavior in high level programming languages.
969  * `SafeMath` restores this intuition by reverting the transaction when an
970  * operation overflows.
971  *
972  * Using this library instead of the unchecked operations eliminates an entire
973  * class of bugs, so it's recommended to use it always.
974  */
975 library SafeMath {
976     /**
977      * @dev Returns the addition of two unsigned integers, with an overflow flag.
978      *
979      * _Available since v3.4._
980      */
981     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
982         uint256 c = a + b;
983         if (c < a) return (false, 0);
984         return (true, c);
985     }
986 
987     /**
988      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
989      *
990      * _Available since v3.4._
991      */
992     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
993         if (b > a) return (false, 0);
994         return (true, a - b);
995     }
996 
997     /**
998      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
999      *
1000      * _Available since v3.4._
1001      */
1002     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1003         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1004         // benefit is lost if 'b' is also tested.
1005         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1006         if (a == 0) return (true, 0);
1007         uint256 c = a * b;
1008         if (c / a != b) return (false, 0);
1009         return (true, c);
1010     }
1011 
1012     /**
1013      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1014      *
1015      * _Available since v3.4._
1016      */
1017     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1018         if (b == 0) return (false, 0);
1019         return (true, a / b);
1020     }
1021 
1022     /**
1023      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1024      *
1025      * _Available since v3.4._
1026      */
1027     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1028         if (b == 0) return (false, 0);
1029         return (true, a % b);
1030     }
1031 
1032     /**
1033      * @dev Returns the addition of two unsigned integers, reverting on
1034      * overflow.
1035      *
1036      * Counterpart to Solidity's `+` operator.
1037      *
1038      * Requirements:
1039      *
1040      * - Addition cannot overflow.
1041      */
1042     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1043         uint256 c = a + b;
1044         require(c >= a, "SafeMath: addition overflow");
1045         return c;
1046     }
1047 
1048     /**
1049      * @dev Returns the subtraction of two unsigned integers, reverting on
1050      * overflow (when the result is negative).
1051      *
1052      * Counterpart to Solidity's `-` operator.
1053      *
1054      * Requirements:
1055      *
1056      * - Subtraction cannot overflow.
1057      */
1058     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1059         require(b <= a, "SafeMath: subtraction overflow");
1060         return a - b;
1061     }
1062 
1063     /**
1064      * @dev Returns the multiplication of two unsigned integers, reverting on
1065      * overflow.
1066      *
1067      * Counterpart to Solidity's `*` operator.
1068      *
1069      * Requirements:
1070      *
1071      * - Multiplication cannot overflow.
1072      */
1073     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1074         if (a == 0) return 0;
1075         uint256 c = a * b;
1076         require(c / a == b, "SafeMath: multiplication overflow");
1077         return c;
1078     }
1079 
1080     /**
1081      * @dev Returns the integer division of two unsigned integers, reverting on
1082      * division by zero. The result is rounded towards zero.
1083      *
1084      * Counterpart to Solidity's `/` operator. Note: this function uses a
1085      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1086      * uses an invalid opcode to revert (consuming all remaining gas).
1087      *
1088      * Requirements:
1089      *
1090      * - The divisor cannot be zero.
1091      */
1092     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1093         require(b > 0, "SafeMath: division by zero");
1094         return a / b;
1095     }
1096 
1097     /**
1098      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1099      * reverting when dividing by zero.
1100      *
1101      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1102      * opcode (which leaves remaining gas untouched) while Solidity uses an
1103      * invalid opcode to revert (consuming all remaining gas).
1104      *
1105      * Requirements:
1106      *
1107      * - The divisor cannot be zero.
1108      */
1109     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1110         require(b > 0, "SafeMath: modulo by zero");
1111         return a % b;
1112     }
1113 
1114     /**
1115      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1116      * overflow (when the result is negative).
1117      *
1118      * CAUTION: This function is deprecated because it requires allocating memory for the error
1119      * message unnecessarily. For custom revert reasons use {trySub}.
1120      *
1121      * Counterpart to Solidity's `-` operator.
1122      *
1123      * Requirements:
1124      *
1125      * - Subtraction cannot overflow.
1126      */
1127     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1128         require(b <= a, errorMessage);
1129         return a - b;
1130     }
1131 
1132     /**
1133      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1134      * division by zero. The result is rounded towards zero.
1135      *
1136      * CAUTION: This function is deprecated because it requires allocating memory for the error
1137      * message unnecessarily. For custom revert reasons use {tryDiv}.
1138      *
1139      * Counterpart to Solidity's `/` operator. Note: this function uses a
1140      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1141      * uses an invalid opcode to revert (consuming all remaining gas).
1142      *
1143      * Requirements:
1144      *
1145      * - The divisor cannot be zero.
1146      */
1147     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1148         require(b > 0, errorMessage);
1149         return a / b;
1150     }
1151 
1152     /**
1153      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1154      * reverting with custom message when dividing by zero.
1155      *
1156      * CAUTION: This function is deprecated because it requires allocating memory for the error
1157      * message unnecessarily. For custom revert reasons use {tryMod}.
1158      *
1159      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1160      * opcode (which leaves remaining gas untouched) while Solidity uses an
1161      * invalid opcode to revert (consuming all remaining gas).
1162      *
1163      * Requirements:
1164      *
1165      * - The divisor cannot be zero.
1166      */
1167     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1168         require(b > 0, errorMessage);
1169         return a % b;
1170     }
1171 }
1172 
1173 
1174 
1175 /**
1176  * @title SafeERC20
1177  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1178  * contract returns false). Tokens that return no value (and instead revert or
1179  * throw on failure) are also supported, non-reverting calls are assumed to be
1180  * successful.
1181  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1182  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1183  */
1184 library SafeERC20 {
1185     using SafeMath for uint256;
1186     using Address for address;
1187 
1188     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1189         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1190     }
1191 
1192     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1193         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1194     }
1195 
1196     /**
1197      * @dev Deprecated. This function has issues similar to the ones found in
1198      * {IERC20-approve}, and its usage is discouraged.
1199      *
1200      * Whenever possible, use {safeIncreaseAllowance} and
1201      * {safeDecreaseAllowance} instead.
1202      */
1203     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1204         // safeApprove should only be called when setting an initial allowance,
1205         // or when resetting it to zero. To increase and decrease it, use
1206         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1207         // solhint-disable-next-line max-line-length
1208         require((value == 0) || (token.allowance(address(this), spender) == 0),
1209             "SafeERC20: approve from non-zero to non-zero allowance"
1210         );
1211         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1212     }
1213 
1214     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1215         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1216         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1217     }
1218 
1219     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1220         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1221         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1222     }
1223 
1224     /**
1225      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1226      * on the return value: the return value is optional (but if data is returned, it must not be false).
1227      * @param token The token targeted by the call.
1228      * @param data The call data (encoded using abi.encode or one of its variants).
1229      */
1230     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1231         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1232         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1233         // the target address contains contract code and also asserts for success in the low-level call.
1234 
1235         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1236         if (returndata.length > 0) { // Return data is optional
1237             // solhint-disable-next-line max-line-length
1238             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1239         }
1240     }
1241 }
1242 
1243 
1244 
1245 
1246 
1247 
1248 
1249 
1250 
1251 
1252 
1253 interface IShyftKycContract is IErc20, IErc223ReceivingContract {
1254     function balanceOf(address tokenOwner) external view override returns (uint balance);
1255     function totalSupply() external view override returns (uint);
1256     function transfer(address to, uint tokens) external override returns (bool success);
1257 
1258     function getShyftCacheGraphAddress() external view returns (address result);
1259 
1260     function getNativeTokenType() external view returns (uint256 result);
1261 
1262     function withdrawNative(address payable _to, uint256 _value) external returns (bool ok);
1263     function withdrawToExternalContract(address _to, uint256 _value, uint256 _gasAmount) external returns (bool ok);
1264     function withdrawToShyftKycContract(address _shyftKycContractAddress, address _to, uint256 _value) external returns (bool ok);
1265 
1266     function mintBip32X(address _to, uint256 _amount, uint256 _bip32X_type) external;
1267     function burnFromBip32X(address _account, uint256 _amount, uint256 _bip32X_type) external;
1268 
1269     function migrateFromKycContract(address _to) external payable returns(bool result);
1270     function updateContract(address _addr) external returns (bool);
1271 
1272     function transferBip32X(address _to, uint256 _value, uint256 _bip32X_type) external returns (bool result);
1273     function allowanceBip32X(address _tokenOwner, address _spender, uint256 _bip32X_type) external view returns (uint remaining);
1274     function approveBip32X(address _spender, uint _tokens, uint256 _bip32X_type) external returns (bool success);
1275     function transferFromBip32X(address _from, address _to, uint _tokens, uint256 _bip32X_type) external returns (bool success);
1276 
1277     function transferFromErc20TokenToBip32X(address _erc20ContractAddress, uint256 _value) external returns (bool ok);
1278     function withdrawTokenBip32XToErc20(address _erc20ContractAddress, address _to, uint256 _value) external returns (bool ok);
1279 
1280     function getBalanceBip32X(address _identifiedAddress, uint256 _bip32X_type) external view returns (uint256 balance);
1281     function getTotalSupplyBip32X(uint256 _bip32X_type) external view returns (uint256 balance);
1282 
1283     function getBip32XTypeForContractAddress(address _contractAddress) external view returns (uint256 bip32X_type);
1284 
1285     function kycSend(address _identifiedAddress, uint256 _amount, uint256 _bip32X_type, bool _requiredConsentFromAllParties, bool _payForDirty) external returns (uint8 result);
1286 
1287     function getOnlyAcceptsKycInput(address _identifiedAddress) external view returns (bool result);
1288     function getOnlyAcceptsKycInputPermanently(address _identifiedAddress) external view returns (bool result);
1289 }
1290 
1291 
1292 
1293 /// @dev | Shyft Core :: Shyft Kyc Contract
1294 ///      |
1295 ///      | This contract is the nucleus of all of the Shyft stack. This current v1 version has basic functionality for upgrading and connects to the Shyft Cache Graph via Routing for further system expansion.
1296 ///      |
1297 ///      | It should be noted that all payable functions should utilize revert, as they are dealing with assets.
1298 ///      |
1299 ///      | "Bip32X" & Synthetics - Here we're using an extension of the Bip32 standard that effectively uses a hash of contract address & "chainId" to allow any erc20/erc223 contract to allow assets to move through Shyft's opt-in compliance rails.
1300 ///      | Ex. Ethereum = 60
1301 ///      | Shyft Network = 7341
1302 ///      |
1303 ///      | This contract is built so that when the totalSupply is asked for, much like transfer et al., it only references the ShyftTokenType. For getting the native balance of any specific Bip32X token, you'd call "getTotalSupplyBip32X" with the proper contract address.
1304 ///      |
1305 ///      | "Auto Migration"
1306 ///      | This contract was built with the philosophy that while there needs to be *some* upgrade path, unilaterally changing the existing contract address for Users is a bad idea in practice. Instead, we use a versioning system with the ability for users to set flags to automatically upgrade their liquidity on send into this particular contract, to any other contracts that have been updated so far (in a recursive manner).
1307 ///      |
1308 ///      | Auto-Migration of assets flow:
1309 ///      | 1. registry contract is set up
1310 ///      | 2. upgrade is called by registry contract
1311 ///      | 3. calls to fallback looks to see if upgrade is set
1312 ///      | 4. if so it asks the registry for the current contract address
1313 ///      | 5. it then uses the "migrateFromKycContract", which on the receiver's end will update the _to address passed in with the progression and now has the value from the "migrateFromKycContract"'s payable and thus the native fuel, to back the token increase to the _to's account.
1314 ///      |
1315 ///      |
1316 ///      | What's Next (V2 notes):
1317 ///      |
1318 ///      | "Shyft Safe" - timelocked assets that will work with Byfrost
1319 ///      | "Shyft Byfrost" - economic finality bridge infrastructure
1320 ///      |
1321 ///      | Compliance Channels:
1322 ///      | Addresses that only accept kyc input should be able to receive packages by the bridge that are only kyc'd across byfrost.
1323 ///      | Ultimate accountability chain could be difficult, though a hash map of critical ipfs resources of chain data could suffice.
1324 ///      | This would be the same issue as data accountability by trying to leverage multiple chains for data sales as well.
1325 
1326 contract ShyftKycContract is IShyftKycContract, TokenConstants, AccessControl {
1327     /// @dev Event for migration to another shyft kyc contract (of higher or equal version).
1328     event EVT_migrateToKycContract(address indexed updatedShyftKycContractAddress, uint256 updatedContractBalance, address indexed kycContractAddress, address indexed to, uint256 _amount);
1329     /// @dev Event for migration to another shyft kyc contract (from lower or equal version).
1330     event EVT_migrateFromContract(address indexed sendingKycContract, uint256 totalSupplyBip32X, uint256 msgValue, uint256 thisBalance);
1331 
1332     /// @dev Event for receipt of native assets.
1333     event EVT_receivedNativeBalance(address indexed _from, uint256 _value);
1334 
1335     /// @dev Event for withdraw to address.
1336     event EVT_WithdrawToAddress(address _from, address _to, uint256 _value);
1337     /// @dev Event for withdraw to external contract (w/ Erc223 fallbacks).
1338     event EVT_WithdrawToExternalContract(address _from, address _to, uint256 _value);
1339     /// @dev Event for withdraw to a specific shyft smart contract.
1340     event EVT_WithdrawToShyftKycContract(address _from, address _to, uint256 _value);
1341 
1342     /// @dev Event for transfer and minting of Bip32X type assets.
1343     event EVT_TransferAndMintBip32X(address contractAddress, address msgSender, uint256 value, uint256 indexed bip32X_type);
1344 
1345     /// @dev Event for transfer and burning of Bip32X type assets.
1346     event EVT_TransferAndBurnBip32X(address contractAddress, address msgSender, address to, uint256 value, uint256 indexed bip32X_type);
1347 
1348     /// @dev Event for transfer of Bip32X type.
1349     event EVT_TransferBip32X(address indexed from, address indexed to, uint256 tokens, uint256 indexed bip32X_type);
1350 
1351     /// @dev Event for approval of Bip32X type.
1352     event EVT_ApprovalBip32X(address indexed tokenOwner, address indexed spender, uint256 tokens, uint256 indexed bip32X_type);
1353 
1354     /* ERC223 events */
1355     /// @dev Event for Erc223-based Token Fallback.
1356     event EVT_Erc223TokenFallback(address _from, uint256 _value, bytes _data);
1357 
1358     /* v1 Upgrade events */
1359     /// @dev Event for setting of emergency responder.
1360     event EVT_setV1EmergencyResponder(address _emergencyResponder);
1361 
1362     /// @dev Event for redemption of incorrectly sent assets.
1363     event EVT_redeemIncorrectlySentAsset(address indexed _destination, uint256 _amount);
1364 
1365     /// @dev Event for upgrading of assets from the v1 Contract
1366     event EVT_UpgradeFromV1(address indexed _originAddress, address indexed _userAddress, uint256 _value);
1367 
1368     using SafeMath for uint256;
1369     using SafeERC20 for IERC20;
1370 
1371     /// @dev Mapping of total supply specific bip32x assets.
1372     mapping(uint256 => uint256) totalSupplyBip32X;
1373     /// @dev Mapping of users to their balances of specific bip32x assets.
1374     mapping(address => mapping(uint256 => uint256)) balances;
1375     /// @dev Mapping of users to users with amount of allowance set for specific bip32x assets.
1376     mapping(address => mapping(address => mapping(uint256 => uint256))) allowed;
1377 
1378     /// @dev Mapping of users to whether they have set auto-upgrade enabled.
1379     mapping(address => bool) autoUpgradeEnabled;
1380     /// @dev Mapping of users to whether they Accepts Kyc Input only.
1381     mapping(address => bool) onlyAcceptsKycInput;
1382     /// @dev Mapping of users to whether their Accepts Kyc Input option is locked permanently.
1383     mapping(address => bool) lockOnlyAcceptsKycInputPermanently;
1384 
1385     /// @dev mutex lock, prevent recursion in functions that use external function calls
1386     bool locked;
1387 
1388     /// @dev Whether there has been an upgrade from this contract.
1389     bool public hasBeenUpdated;
1390     /// @dev The address of the next upgraded Shyft Kyc Contract.
1391     address public updatedShyftKycContractAddress;
1392     /// @dev The address of the Shyft Kyc Registry contract.
1393     address public shyftKycContractRegistryAddress;
1394 
1395     /// @dev The address of the Shyft Cache Graph contract.
1396     address public shyftCacheGraphAddress = address(0);
1397 
1398     /// @dev The signature for triggering 'tokenFallback' in erc223 receiver contracts.
1399     bytes4 constant shyftKycContractSig = bytes4(keccak256("fromShyftKycContract(address,address,uint256,uint256)")); // function signature
1400 
1401     /// @dev The origin of the Byfrost link, if this contract is used as such. follows chainId.
1402     bool public byfrostOrigin;
1403     /// @dev Flag for whether the Byfrost state has been set.
1404     bool public setByfrostOrigin;
1405 
1406     /// @dev The owner of this contract.
1407     address public owner;
1408     /// @dev The native Bip32X type of this network. Ethereum is 60, Shyft is 7341, etc.
1409     uint256 nativeBip32X_type;
1410 
1411     /// @dev The name of the minter role for implementing AccessControl
1412     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1413 
1414     //@note:@v1Upgrade:
1415     /// @dev total number of SHFT tokens that have been upgraded from v1.
1416     uint256 public v1TotalUpgradeAmount;
1417 
1418     /// @dev emergency responder address - able to **only** send back tokens incorrectly sent via the erc20-based transfer(address,uint256) vs the erc223-based (actual "migration" of the SHFT tokens) to the v1 contract address.
1419     address public emergencyResponder;
1420 
1421     /// @dev "Machine" (autonomous smart contract) Consent Helper address - this is the one that is able to set specific contracts to accept only kyc input
1422 
1423     address public machineConsentHelperAddress;
1424 
1425     /// @param _nativeBip32X_type The native Bip32X type of this network. Ethereum is 60, Shyft is 7341, etc.
1426     /// @dev Invoke the constructor for ShyftSafe, which sets the owner and nativeBip32X_type class variables
1427 
1428     /// @dev This contract uses the AccessControl library (for minting tokens only by designated minter).
1429     /// @dev The account that deploys the contract will be granted the default admin role
1430     /// @dev which will let it grant minter roles to other accounts.
1431     /// @dev After deploying the contract, the the deployer should grant the minter role to a desired address
1432     /// @dev by calling `grantRole(bytes32 role, address account)`
1433     /// @dev Revoking the role is done by calling `revokeRole(bytes32 role, address account)`
1434 
1435     constructor(uint256 _nativeBip32X_type) {
1436         owner = msg.sender;
1437 
1438         nativeBip32X_type = _nativeBip32X_type;
1439 
1440         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1441     }
1442 
1443     /// @dev Gets the native bip32x token (should correspond to "chainid")
1444     /// @return result the native bip32x token (should correspond to "chainid")
1445 
1446     function getNativeTokenType() public override view returns (uint256 result) {
1447         return nativeBip32X_type;
1448     }
1449 
1450     /// @param _tokenAmount The amount of tokens to be allocated.
1451     /// @param _bip32X_type The Bip32X type that represents the synthetic tokens that will be allocated.
1452     /// @param _distributionContract The public address of the distribution contract, that the tokens are allocated for.
1453     /// @dev Set by the owner, this functions sets it such that this contract was deployed on a Byfrost arm of the Shyft Network (on Ethereum for example). With this is a token grant that this contract should make to a specific distribution contract (ie. in the case of the initial Shyft Network launch, we have a small allocation originating on the Ethereum network).
1454     /// @notice | for created kyc contracts on other chains, they can be instantiated with specific bip32X_type amounts
1455     ///         | (for example, the shyft distribution contract on eth vs. shyft native)
1456     ///         |  '  uint256 bip32X_type = uint256(keccak256(abi.encodePacked(nativeBip32X_type, _erc20ContractAddress)));
1457     ///         |  '  bip32X_type = uint256(keccak256(abi.encodePacked(nativeBip32X_type, msg.sender)));
1458     ///         | the bip32X_type is formed by the hash of the native bip32x type (which is unique per-platform, as it depends on
1459     ///         | the deployed contract address) - byfrost only touches non-replay networks.
1460     ///         | so the formula for the bip32X_type would be HASH [ byfrost main chain bip32X_type ] & [ byfrost main chain kyc contract address ]
1461     ///         | these minted tokens are given to the distribution contract for further distribution. This is all this contract
1462     ///         | needs to know about the distribution contract.
1463     /// @return result
1464     ///    | 2 = set byfrost as origin
1465     ///    | 1 = already set byfrost origin
1466     ///    | 0 = not owner
1467 
1468     function setByfrostNetwork(uint256 _tokenAmount, uint256 _bip32X_type, address _distributionContract) public returns (uint8 result) {
1469         if (msg.sender == owner) {
1470             if (setByfrostOrigin == false) {
1471                 byfrostOrigin = true;
1472                 setByfrostOrigin = true;
1473 
1474                 balances[_distributionContract][_bip32X_type] = balances[_distributionContract][_bip32X_type].add(_tokenAmount);
1475                 totalSupplyBip32X[_bip32X_type] = totalSupplyBip32X[_bip32X_type].add(_tokenAmount);
1476 
1477                 //set byfrost as origin
1478                 return 2;
1479             } else {
1480                 //already set
1481                 return 1;
1482             }
1483         } else {
1484             //not owner
1485             return 0;
1486         }
1487     }
1488 
1489     /// @dev Set by the owner, this function sets it such that this contract was deployed on the primary Shyft Network. No further calls to setByfrostNetwork may be made.
1490     /// @return result
1491     ///    | 2 = set primary network
1492     ///    | 1 = already set byfrost origin
1493     ///    | 0 = not owner
1494 
1495     function setPrimaryNetwork() public returns (uint8 result) {
1496         if (msg.sender == owner) {
1497             if (setByfrostOrigin == false) {
1498                 setByfrostOrigin = true;
1499 
1500                 //set primary network
1501                 return 2;
1502             } else {
1503                 //already set byfrost origin
1504                 return 1;
1505             }
1506         } else {
1507             //not owner
1508             return 0;
1509         }
1510     }
1511 
1512     /// @dev Removes the owner (creator of this contract)'s control completely. Functions such as linking the registry & cachegraph (& shyftSafe's setBridge), and importantly initializing this as a byfrost contract, are triggered by the owner, and as such a setting phase and afterwards triggering this function could be seen as a completely appropriate workflow.
1513     /// @return true if the owner is removed successfully
1514     function removeOwner() public returns (bool) {
1515         require(msg.sender == owner, "not owner");
1516 
1517         owner = address(0);
1518         return true;
1519     }
1520 
1521     /// @param _shyftCacheGraphAddress The smart contract address for the Shyft CacheGraph that should be linked.
1522     /// @dev Links Shyft CacheGraph to this contract's function flow.
1523     /// @return result
1524     ///    | 0: not owner
1525     ///    | 1: set shyft cache graph address
1526 
1527     function setShyftCacheGraphAddress(address _shyftCacheGraphAddress) public returns (uint8 result) {
1528         require(_shyftCacheGraphAddress != address(0), "address cannot be zero");
1529         if (owner == msg.sender) {
1530             shyftCacheGraphAddress = _shyftCacheGraphAddress;
1531 
1532             //cacheGraph contract address set
1533             return 1;
1534         } else {
1535             //not owner
1536             return 0;
1537         }
1538     }
1539 
1540     function getShyftCacheGraphAddress() public view override returns (address result) {
1541         return shyftCacheGraphAddress;
1542     }
1543 
1544     //---------------- Cache Graph Utilization ----------------//
1545 
1546     /// @param _identifiedAddress The public address for the recipient to send assets (tokens) to.
1547     /// @param _amount The amount of assets that will be sent.
1548     /// @param _bip32X_type The bip32X type of the assets that will be sent. These are synthetic (wrapped) assets, based on atomic locking.
1549     /// @param _requiredConsentFromAllParties Whether to match the routing algorithm on the "consented" layer which indicates 2 way buy in of counterparty's attestation(s)
1550     /// @param _payForDirty Whether the sender will pay the additional cost to unify a cachegraph's relationships (if not, it will not complete).
1551     /// @dev | Performs a "kyc send", which is an automatic search between addresses for counterparty relationships within Trust Channels (whos rules dictate accessibility for auditing/enforcement/jurisdiction/etc.). If there is a match, the designated amount of assets is sent to the recipient.
1552     ///      | As there are accessor methods to check whether or not the counterparty's cachegraph is "dirty", there is little need to pass a "true" unless the transaction is critical (eg. DeFi atomic flash wrap) and there is a chance that there will need to be a unification pass before the transaction can pass with full assurety.
1553     /// @notice | If the recipient has flags set to indicate that they *only* want to receive assets from kyc sources, *all* of the regular transfer functions will block except this one, and this one only passes on success.
1554     /// @return result
1555     ///    | 0 = not enough balance to send
1556     ///    | 1 = consent required
1557     ///    | 2 = transfer cannot be processed due to transfer rules
1558     ///    | 3 = successful transfer
1559 
1560     function kycSend(address _identifiedAddress, uint256 _amount, uint256 _bip32X_type, bool _requiredConsentFromAllParties, bool _payForDirty) public override returns (uint8 result) {
1561         if (balances[msg.sender][_bip32X_type] >= _amount) {
1562             if (onlyAcceptsKycInput[_identifiedAddress] == false || (onlyAcceptsKycInput[_identifiedAddress] == true && _requiredConsentFromAllParties == true)) {
1563                 IShyftCacheGraph shyftCacheGraph = IShyftCacheGraph(shyftCacheGraphAddress);
1564 
1565                 uint8 kycCanSendResult = shyftCacheGraph.getKycCanSend(msg.sender, _identifiedAddress, _amount, _bip32X_type, _requiredConsentFromAllParties, _payForDirty);
1566 
1567                 //getKycCanSend return 3 = can transfer successfully
1568                 if (kycCanSendResult == 3) {
1569                     balances[msg.sender][_bip32X_type] = balances[msg.sender][_bip32X_type].sub(_amount);
1570                     balances[_identifiedAddress][_bip32X_type] = balances[_identifiedAddress][_bip32X_type].add(_amount);
1571 
1572                     //successful transfer
1573                     return 3;
1574                 } else {
1575                     //transfer cannot be processed due to transfer rules
1576                     return 2;
1577                 }
1578             } else {
1579                 //consent required
1580                 return 1;
1581             }
1582         } else {
1583             //not enough balance to send
1584             return 0;
1585         }
1586     }
1587 
1588     //---------------- Shyft KYC balances, fallback, send, receive, and withdrawal ----------------//
1589 
1590 
1591     /// @dev mutex locks transactions ordering so that multiple chained calls cannot complete out of order.
1592 
1593     modifier mutex() {
1594         require(locked == false, "mutex failed :: already locked");
1595 
1596         locked = true;
1597         _;
1598         locked = false;
1599     }
1600 
1601     /// @param _addr The Shyft Kyc Contract Registry address to set to.
1602     /// @dev Upgrades the contract. Can only be called by a pre-set Shyft Kyc Contract Registry contract. Can only be called once.
1603     /// @return returns true if the function passes, otherwise reverts if the message sender is not the shyft kyc registry contract.
1604 
1605     function updateContract(address _addr) public override returns (bool) {
1606         require(msg.sender == shyftKycContractRegistryAddress, "message sender must by registry contract");
1607         require(hasBeenUpdated == false, "contract has already been updated");
1608         require(_addr != address(0), "new kyc contract address cannot equal zero");
1609 
1610         hasBeenUpdated = true;
1611         updatedShyftKycContractAddress = _addr;
1612         return true;
1613     }
1614 
1615     /// @param _addr The Shyft Kyc Contract Registry address to set to.
1616     /// @dev Sets the Shyft Kyc Contract Registry address, so this contract can be upgraded.
1617     /// @return returns true if the function passes, otherwise reverts if the message sender is not the owner (deployer) of this contract, or the registry is zero, or the registry has already been set.
1618 
1619     function setShyftKycContractRegistryAddress(address _addr) public returns (bool) {
1620         require(msg.sender == owner, "not owner");
1621         require(_addr != address(0), "kyc registry address cannot equal zero");
1622         require(shyftKycContractRegistryAddress == address(0), "kyc registry address must not have already been set");
1623 
1624         shyftKycContractRegistryAddress = _addr;
1625         return true;
1626     }
1627 
1628     /// @param _to The destination address to withdraw to.
1629     /// @dev Withdraws all assets of this User to a specific address (only native assets, ie. Ether on Ethereum, Shyft on Shyft Network).
1630     /// @return balance the number of tokens of that specific bip32x type in the user's account
1631 
1632     function withdrawAllNative(address payable _to) public returns (uint) {
1633         uint _bal = balances[msg.sender][nativeBip32X_type];
1634         withdrawNative(_to, _bal);
1635         return _bal;
1636     }
1637 
1638     /// @param _identifiedAddress The address of the User.
1639     /// @param _bip32X_type The Bip32X type to check.
1640     /// @dev Gets balance for Shyft KYC token type & synthetics for a specfic user.
1641     /// @return balance the number of tokens of that specific bip32x type in the user's account
1642 
1643     function getBalanceBip32X(address _identifiedAddress, uint256 _bip32X_type) public view override returns (uint256 balance) {
1644         return balances[_identifiedAddress][_bip32X_type];
1645     }
1646 
1647     /// @param _bip32X_type The Bip32X type to check.
1648     /// @dev Gets the total supply for a specific bip32x token.
1649     /// @return balance the number of tokens of that specific bip32x type in this contract
1650 
1651     function getTotalSupplyBip32X(uint256 _bip32X_type) public view override returns (uint256 balance) {
1652         return totalSupplyBip32X[_bip32X_type];
1653     }
1654 
1655     /// @param _contractAddress The contract address to get the bip32x type from.
1656     /// @dev Gets the Bip32X Type for a specific contract address.
1657     /// @notice Doesn't check for contract status on the address (bytecode in contract) as that is super expensive for this form of call, so this *will* return a result for a regular non-contract address as well.
1658     /// @return bip32X_type the bip32x type for this specific contract
1659 
1660     function getBip32XTypeForContractAddress(address _contractAddress) public view override returns (uint256 bip32X_type) {
1661         return uint256(keccak256(abi.encodePacked(nativeBip32X_type, _contractAddress)));
1662     }
1663 
1664     /// @dev This fallback function applies value to nativeBip32X_type Token (Ether on Ethereum, Shyft on Shyft Network, etc). It also uses auto-upgrade logic so that users can automatically have their coins in the latest wallet (if everything is opted in across all contracts by the user).
1665 
1666     receive() external payable {
1667         //@note: this is the auto-upgrade path, which is an opt-in service to the users to be able to send any or all tokens
1668         // to an upgraded kycContract.
1669         if (hasBeenUpdated && autoUpgradeEnabled[msg.sender]) {
1670             //@note: to prevent tokens from ever getting "stuck", this contract can only send to itself in a very
1671             // specific manner.
1672             //
1673             // for example, the "withdrawNative" function will output native fuel to a destination.
1674             // If it was sent to this contract, this function will trigger and know that the msg.sender is
1675             // the originating kycContract.
1676 
1677             if (msg.sender != address(this)) {
1678                 // stop the process if the message sender has set a flag that only allows kyc input
1679                 require(onlyAcceptsKycInput[msg.sender] == false, "must send to recipient via trust channel");
1680 
1681                 // burn tokens in this contract
1682                 uint256 existingSenderBalance = balances[msg.sender][nativeBip32X_type];
1683 
1684                 balances[msg.sender][nativeBip32X_type] = 0;
1685                 totalSupplyBip32X[nativeBip32X_type] = totalSupplyBip32X[nativeBip32X_type].sub(existingSenderBalance);
1686 
1687                 //~70k gas for the contract "call"
1688                 //and 90k gas for the value transfer within this.
1689                 // total = ~160k+checks gas to perform this transaction.
1690                 bool didTransferSender = migrateToKycContract(updatedShyftKycContractAddress, msg.sender, existingSenderBalance.add(msg.value));
1691 
1692                 if (didTransferSender == true) {
1693 
1694                 } else {
1695                     //@note: reverts since a transactional event has occurred.
1696                     revert("error in migration to kyc contract [user-origin]");
1697                 }
1698             } else {
1699                 //****************************************************************************************************//
1700                 //@note: This *must* be the only route where tx.origin has to matter.
1701                 //****************************************************************************************************//
1702 
1703                 // duplicating the logic here for higher deploy cost vs. lower transactional costs (consider user costs
1704                 // where all users would want to migrate)
1705 
1706                 // burn tokens in this contract
1707                 uint256 existingOriginBalance = balances[tx.origin][nativeBip32X_type];
1708 
1709                 balances[tx.origin][nativeBip32X_type] = 0;
1710                 totalSupplyBip32X[nativeBip32X_type] = totalSupplyBip32X[nativeBip32X_type].sub(existingOriginBalance);
1711 
1712                 //~70k gas for the contract "call"
1713                 //and 90k gas for the value transfer within this.
1714                 // total = ~160k+checks gas to perform this transaction.
1715 
1716                 bool didTransferOrigin = migrateToKycContract(updatedShyftKycContractAddress, tx.origin, existingOriginBalance.add(msg.value));
1717 
1718                 if (didTransferOrigin == true) {
1719 
1720                 } else {
1721                     //@note: reverts since a transactional event has occurred.
1722                     revert("error in migration to updated contract [self-origin]");
1723                 }
1724             }
1725         } else {
1726             //@note: never accept this contract sending raw value to this fallback function, unless explicit cases
1727             // have been met.
1728             //@note: public addresses do not count as kyc'd addresses
1729             if (msg.sender != address(this) && onlyAcceptsKycInput[msg.sender] == true) {
1730                 revert("must send to recipient via trust channel");
1731             }
1732 
1733             balances[msg.sender][nativeBip32X_type] = balances[msg.sender][nativeBip32X_type].add(msg.value);
1734             totalSupplyBip32X[nativeBip32X_type] = totalSupplyBip32X[nativeBip32X_type].add(msg.value);
1735 
1736             emit EVT_receivedNativeBalance(msg.sender, msg.value);
1737         }
1738     }
1739 
1740     /// @param _kycContractAddress The Shyft Kyc Contract to migrate to.
1741     /// @param _to The user's address to migrate to
1742     /// @param _amount The amount of tokens to migrate.
1743     /// @dev Internal function to migrates the user's assets to another Shyft Kyc Contract. This function is called from the fallback to allocate tokens properly to the upgraded contract.
1744     /// @return result
1745     ///    | true = transfer complete
1746     ///    | false = transfer did not complete
1747 
1748     function migrateToKycContract(address _kycContractAddress, address _to, uint256 _amount) internal returns (bool result) {
1749 
1750         // call upgraded contract so that tokens are forwarded to the new contract under _to's account.
1751         IShyftKycContract updatedKycContract = IShyftKycContract(updatedShyftKycContractAddress);
1752 
1753         emit EVT_migrateToKycContract(updatedShyftKycContractAddress, address(updatedShyftKycContractAddress).balance, _kycContractAddress, _to, _amount);
1754 
1755         // sending to ShyftKycContracts only; migrateFromKycContract uses ~75830 - 21000 gas to execute,
1756         // with a registry lookup, so adding in a bit more for future contracts.
1757         bool transferResult = updatedKycContract.migrateFromKycContract{value: _amount, gas: 100000}(_to);
1758 
1759         if (transferResult == true) {
1760             //transfer complete
1761             return true;
1762         } else {
1763             //transfer did not complete
1764             return false;
1765         }
1766     }
1767 
1768     /// @param _to The user's address to migrate to.
1769     /// @dev | Migrates the user's assets from another Shyft Kyc Contract. The following conditions have to pass:
1770     ///      | a) message sender is a shyft kyc contract,
1771     ///      | b) sending shyft kyc contract is not of a later version than this one
1772     ///      | c) user on this shyft kyc contract have no restrictions on only accepting KYC input (will ease in v2)
1773     /// @return result
1774     ///    | true = migration completed successfully
1775     ///    | [revert] = reverts on any situation that fails on the above parameters
1776 
1777     function migrateFromKycContract(address _to) public payable override returns (bool result) {
1778         //@note: doing a very strict check to make sure no unwanted additional tokens can be created.
1779         // the way this work is that this.balance is updated *before* this code runs.
1780         // thus, as long as we've always updated totalSupplyBip32X when we've created or destroyed tokens, we'll
1781         // always be able to check against this.balance.
1782 
1783         //regarding an issue found:
1784         //"Smart contracts, though they may not expect it, can receive ether forcibly, or could be deployed at an
1785         // address that already received some ether."
1786         // from:
1787         // "require(totalSupplyBip32X[nativeBip32X_type].add(msg.value) == address(this).balance);"
1788         //
1789         // the worst case scenario in some non-atomic calls (without going through withdrawToShyftKycContract for example)
1790         // is that someone self-destructs a contract and forcibly sends ether to this address, before this is triggered by
1791         // someone using it.
1792 
1793         // solution:
1794         // we cannot do a simple equality check for address(this).balance. instead, we use an less-than-or-equal-to, as
1795         // when the worst case above occurs, the total supply of this synthetic will be less than the balance within this
1796         // contract.
1797 
1798         require(totalSupplyBip32X[nativeBip32X_type].add(msg.value) <= address(this).balance, "could not migrate funds due to insufficient backing balance");
1799 
1800         bool doContinue = true;
1801 
1802         IShyftKycContractRegistry contractRegistry = IShyftKycContractRegistry(shyftKycContractRegistryAddress);
1803 
1804         // check if only using a known kyc contract communication cycle, then verify the message sender is a kyc contract.
1805         if (contractRegistry.isShyftKycContract(address(msg.sender)) == false) {
1806             doContinue = false;
1807         } else {
1808             // only allow migration from equal or older versions of Shyft Kyc Contracts, via registry lookup.
1809             if (contractRegistry.getContractVersionOfAddress(address(msg.sender)) > contractRegistry.getContractVersionOfAddress(address(this))) {
1810                 doContinue = false;
1811             }
1812         }
1813 
1814         // block transfers if the recipient only allows kyc input
1815         if (onlyAcceptsKycInput[_to] == true) {
1816             doContinue = false;
1817         }
1818 
1819         if (doContinue == true) {
1820             emit EVT_migrateFromContract(msg.sender, totalSupplyBip32X[nativeBip32X_type], msg.value, address(this).balance);
1821 
1822             balances[_to][nativeBip32X_type] = balances[_to][nativeBip32X_type].add(msg.value);
1823             totalSupplyBip32X[nativeBip32X_type] = totalSupplyBip32X[nativeBip32X_type].add(msg.value);
1824 
1825             //transfer complete
1826             return true;
1827         } else {
1828             //kyc contract not in registry
1829             //@note: transactional event has occurred, so revert() is necessary
1830             revert("kyc contract is not in registry, or must use trust channels");
1831             //return false;
1832         }
1833     }
1834 
1835     /// @param _onlyAcceptsKycInputValue Whether to accept only Kyc Input.
1836     /// @dev Sets whether to accept only Kyc Input in the future.
1837     /// @return result
1838     ///    | true = updated onlyAcceptsKycInput
1839     ///    | false = cannot modify onlyAcceptsKycInput, as it is locked permanently by user
1840 
1841     function setOnlyAcceptsKycInput(bool _onlyAcceptsKycInputValue) public returns (bool result) {
1842         if (lockOnlyAcceptsKycInputPermanently[msg.sender] == false) {
1843             onlyAcceptsKycInput[msg.sender] = _onlyAcceptsKycInputValue;
1844 
1845             //updated onlyAcceptsKycInput
1846             return true;
1847         } else {
1848 
1849             //cannot modify onlyAcceptsKycInput, as it is locked permanently by user
1850             return false;
1851         }
1852     }
1853 
1854     /// @dev Gets whether the user has set Accepts Kyc Input.
1855     /// @return result
1856     ///    | true = set lock for onlyAcceptsKycInput
1857     ///    | false = already set lock for onlyAcceptsKycInput
1858 
1859     function setLockOnlyAcceptsKycInputPermanently() public returns (bool result) {
1860         if (lockOnlyAcceptsKycInputPermanently[msg.sender] == false) {
1861             lockOnlyAcceptsKycInputPermanently[msg.sender] = true;
1862             //set lock for onlyAcceptsKycInput
1863             return true;
1864         } else {
1865             //already set lock for onlyAcceptsKycInput
1866             return false;
1867         }
1868     }
1869 
1870     /// @param _machineConsentHelperAddress The address of the Machine Consent Helper.
1871     /// @dev Sets the Machine Consent Helper address. This address can lock kyc inputs for contracts permanently, for use in compliant DeFi pools.
1872     /// @return result
1873     ///    | true = set machine consent helper address
1874     ///    | false = cannot set machine consent helper address, either not the Owner, the address input is 0x0, or the machine helper address has already been set by the Owner.
1875 
1876     function setMachineConsentHelperAddress(address _machineConsentHelperAddress) public returns (bool result) {
1877         require(msg.sender == owner, "not owner");
1878         require(_machineConsentHelperAddress != address(0), "machine consent helper address cannot equal zero");
1879         require(machineConsentHelperAddress == address(0), "machine consent helper address must not have already been set");
1880 
1881         machineConsentHelperAddress = _machineConsentHelperAddress;
1882 
1883         // set machine consent helper address
1884         return true;
1885     }
1886 
1887     /// @param _contractAddress The contract address to lock only accepts kyc input permanently
1888     /// @dev Sets the Machine Consent Helper address. This address can lock kyc inputs for contracts permanently, for use in compliant DeFi pools.
1889     /// @return result
1890     ///    | true = set only accepts kyc input permanently for the contract
1891     ///    | false = not a contract address, or no machine (autonomous smart contract) consent helper found
1892 
1893     function lockContractToOnlyAcceptsKycInputPermanently(address _contractAddress) public returns (bool result) {
1894         // check for machine consent helper as the sender.
1895         if (msg.sender == machineConsentHelperAddress) {
1896             // make sure this is a contract address (has code in it)
1897             if (isContractAddress(_contractAddress)) {
1898                 // forces only accepting KYC input from this point on.
1899                 onlyAcceptsKycInput[_contractAddress] = true;
1900                 lockOnlyAcceptsKycInputPermanently[_contractAddress] = true;
1901 
1902                 // set only accepts kyc input permanently for the contract
1903                 return true;
1904             } else {
1905                 // not a contract address
1906                 return false;
1907             }
1908         } else {
1909             // no machine consent helper found
1910             return false;
1911         }
1912     }
1913 
1914     /// @param _identifiedAddress The public address to check.
1915     /// @dev Gets whether the user has set Accepts Kyc Input.
1916     /// @return result whether the user has set Accepts Kyc Input
1917 
1918     function getOnlyAcceptsKycInput(address _identifiedAddress) public view override returns (bool result) {
1919         return onlyAcceptsKycInput[_identifiedAddress];
1920     }
1921 
1922     /// @param _identifiedAddress The public address to check.
1923     /// @dev Gets whether the user has set Accepts Kyc Input permanently (whether on or off).
1924     /// @return result whether the user has set Accepts Kyc Input permanently (whether on or off)
1925 
1926     function getOnlyAcceptsKycInputPermanently(address _identifiedAddress) public view override returns (bool result) {
1927         return lockOnlyAcceptsKycInputPermanently[_identifiedAddress];
1928     }
1929 
1930     //---------------- Token Upgrades ----------------//
1931 
1932 
1933     //****************************************************************************************************************//
1934     //@note: instead of explicitly returning, assign return value to variable allows the code after the _;
1935     // in the mutex modifier to be run!
1936     //****************************************************************************************************************//
1937 
1938     /// @param _value The amount of tokens to upgrade.
1939     /// @dev Upgrades the user's tokens by sending them to the next contract (which will do the same). Sets auto upgrade for the user as well.
1940     /// @return result
1941     ///    | 3 = withdrew correctly
1942     ///    | 2 = could not withdraw
1943     ///    | 1 = not enough balance
1944     ///    | 0 = contract has not been updated
1945 
1946     function upgradeNativeTokens(uint256 _value) mutex public returns (uint256 result) {
1947         //check if it's been updated
1948         if (hasBeenUpdated == true) {
1949             //make sure the msg.sender has enough synthetic fuel to transfer
1950             if (balances[msg.sender][nativeBip32X_type] >= _value) {
1951                 autoUpgradeEnabled[msg.sender] = true;
1952 
1953                 //then proceed to send to address(this) to initiate the autoUpgrade
1954                 // to the new contract.
1955                 bool withdrawResult = _withdrawToShyftKycContract(updatedShyftKycContractAddress, msg.sender, _value);
1956                 if (withdrawResult == true) {
1957                     //withdrew correctly
1958                     result = 3;
1959                 } else {
1960                     //could not withdraw
1961                     result = 2;
1962                 }
1963             } else {
1964                 //not enough balance
1965                 result = 1;
1966             }
1967         } else {
1968             //contract has not been updated
1969             result = 0;
1970         }
1971     }
1972 
1973     /// @param _autoUpgrade Whether the tokens should be automatically upgraded when sent to this contract.
1974     /// @dev Sets auto upgrade for the message sender, for fallback functionality to upgrade tokens on receipt. The only reason a user would want to call this function is to modify behaviour *after* this contract has been updated, thus allowing choice.
1975 
1976     function setAutoUpgrade(bool _autoUpgrade) public {
1977         autoUpgradeEnabled[msg.sender] = _autoUpgrade;
1978     }
1979 
1980     function isContractAddress(address _potentialContractAddress) internal returns (bool result) {
1981         uint codeLength;
1982 
1983         //retrieve the size of the code on target address, this needs assembly
1984         assembly {
1985             codeLength := extcodesize(_potentialContractAddress)
1986         }
1987 
1988         //check to see if there's any code (contract) or not.
1989         if (codeLength == 0) {
1990             return false;
1991         } else {
1992             return true;
1993         }
1994     }
1995 
1996     //---------------- Native withdrawal / transfer functions ----------------//
1997 
1998     /// @param _to The destination payable address to send to.
1999     /// @param _value The amount of tokens to transfer.
2000     /// @dev Transfers native tokens (based on the current native Bip32X type, ex Shyft = 7341, Ethereum = 1) to the user's wallet.
2001     /// @notice 30k gas limit for transfers.
2002     /// @return ok
2003     ///    | true = native tokens withdrawn properly
2004     ///    | false = the user does not have enough balance, or found a smart contract address instead of a payable address.
2005 
2006     function withdrawNative(address payable _to, uint256 _value) mutex public override returns (bool ok) {
2007         if (balances[msg.sender][nativeBip32X_type] >= _value) {
2008             //makes sure it's sending to a native (non-contract) address
2009             if (isContractAddress(_to) == false) {
2010                 balances[msg.sender][nativeBip32X_type] = balances[msg.sender][nativeBip32X_type].sub(_value);
2011                 totalSupplyBip32X[nativeBip32X_type] = totalSupplyBip32X[nativeBip32X_type].sub(_value);
2012 
2013                 //@note: this is going to a regular account. the existing balance has already been reduced,
2014                 // and as such the only thing to do is to send the actual Shyft fuel (or Ether, etc) to the
2015                 // target address.
2016 
2017                 _to.transfer(_value);
2018 
2019                 emit EVT_WithdrawToAddress(msg.sender, _to, _value);
2020                 ok = true;
2021             } else {
2022                 ok = false;
2023             }
2024         } else {
2025             ok = false;
2026         }
2027     }
2028 
2029     /// @param _to The destination smart contract address to send to.
2030     /// @param _value The amount of tokens to transfer.
2031     /// @param _gasAmount The amount of gas for the transfer (>30k is a different receiver gas type beyond normal accounting + 1 event)
2032     /// @dev Transfers SHFT tokens to another external contract.
2033     /// @notice 30k gas limit for transfers should be used unless there are specific reasons otherwise.
2034     /// @return ok
2035     ///    | true = tokens withdrawn properly to another contract
2036     ///    | false = the user does not have enough balance, or not a contract address
2037 
2038     function withdrawToExternalContract(address _to, uint256 _value, uint256 _gasAmount) mutex public override returns (bool ok) {
2039         if (balances[msg.sender][nativeBip32X_type] >= _value) {
2040             if (isContractAddress(_to)) {
2041                 balances[msg.sender][nativeBip32X_type] = balances[msg.sender][nativeBip32X_type].sub(_value);
2042                 totalSupplyBip32X[nativeBip32X_type] = totalSupplyBip32X[nativeBip32X_type].sub(_value);
2043 
2044                 //this will fail when sending to contracts with fallback functions that consume more than 20000 gas
2045 
2046                 (bool success, ) = _to.call{value: _value, gas: _gasAmount}("");
2047 
2048                 if (success == true) {
2049                     emit EVT_WithdrawToExternalContract(msg.sender, _to, _value);
2050 
2051                     // tokens withdrawn properly to another contract
2052                     ok = true;
2053                 } else {
2054                     //@note:@here: needs revert() due to asset transactions already having occurred
2055                     revert("could not withdraw to an external contract");
2056                     //ok = false;
2057                 }
2058             } else {
2059                 // not a contract address
2060                 ok = false;
2061             }
2062         } else {
2063             // user does not have enough balance
2064             ok = false;
2065         }
2066     }
2067 
2068     /// @param _shyftKycContractAddress The address of the Shyft Kyc Contract that is being send to.
2069     /// @param _to The destination address to send to.
2070     /// @param _value The amount of tokens to transfer.
2071     /// @dev Transfers SHFT tokens to another Shyft Kyc contract.
2072     /// @notice 120k gas limit for transfers.
2073     /// @return ok
2074     ///    | true = tokens withdrawn properly to another Kyc Contract.
2075     ///    | false = the user does not have enough balance, not a valid ShyftKycContract via registry lookup, or not a correct shyft contract address, or receiver only accepts kyc input.
2076 
2077     function withdrawToShyftKycContract(address _shyftKycContractAddress, address _to, uint256 _value) mutex public override returns (bool ok) {
2078         return _withdrawToShyftKycContract(_shyftKycContractAddress, _to, _value);
2079     }
2080 
2081     function _withdrawToShyftKycContract(address _shyftKycContractAddress, address _to, uint256 _value) internal returns (bool ok) {
2082         if (balances[msg.sender][nativeBip32X_type] >= _value) {
2083             if (isContractAddress(_shyftKycContractAddress) == true) {
2084                 IShyftKycContractRegistry contractRegistry = IShyftKycContractRegistry(shyftKycContractRegistryAddress);
2085 
2086                 // check if only using a known kyc contract communication cycle, then verify the message sender is a kyc contract.
2087                 if (contractRegistry.isShyftKycContract(_shyftKycContractAddress) == true) {
2088                     IShyftKycContract receivingShyftKycContract = IShyftKycContract(_shyftKycContractAddress);
2089 
2090                     if (receivingShyftKycContract.getOnlyAcceptsKycInput(_to) == false) {
2091                         balances[msg.sender][nativeBip32X_type] = balances[msg.sender][nativeBip32X_type].sub(_value);
2092                         totalSupplyBip32X[nativeBip32X_type] = totalSupplyBip32X[nativeBip32X_type].sub(_value);
2093 
2094                         // sending to ShyftKycContracts only; migrateFromKycContract uses ~75830 - 21000 gas to execute,
2095                         // with a registry lookup. Adding 50k more just in case there are other checks in the v2.
2096                         if (receivingShyftKycContract.migrateFromKycContract{gas: 120000, value: _value}(_to) == false) {
2097                             revert("could not migrate from shyft kyc contract");
2098                         }
2099 
2100                         emit EVT_WithdrawToShyftKycContract(msg.sender, _to, _value);
2101 
2102                         ok = true;
2103                     } else {
2104                         // receiver only accepts kyc input
2105                         ok = false;
2106                     }
2107                 } else {
2108                     // is not a valid ShyftKycContract via registry lookup.
2109                     ok = false;
2110                 }
2111             } else {
2112                 // not a smart contract
2113                 ok = false;
2114             }
2115         } else {
2116             ok = false;
2117         }
2118     }
2119 
2120     //---------------- ERC 223 receiver ----------------//
2121 
2122     /// @param _from The address of the origin.
2123     /// @param _value The address of the recipient.
2124     /// @param _data The bytes data of any ERC223 transfer function.
2125     /// @dev Token fallback method to receive assets. ERC223 functionality. This version does allow for one specific (origin) contract to transfer tokens to it.
2126     /// @return ok returns true if the checks pass and there are enough allowed + actual tokens to transfer to the recipient.
2127 
2128     function tokenFallback(address _from, uint _value, bytes memory _data) mutex public override returns (bool ok) {
2129         // block transfers if the recipient only allows kyc input, check other factors
2130         require(onlyAcceptsKycInput[_from] == false, "recipient address must not require only kyc'd input");
2131 
2132         IShyftKycContractRegistry contractRegistry = IShyftKycContractRegistry(shyftKycContractRegistryAddress);
2133 
2134         // if kyc registry exists, check if only using a known kyc contract communication cycle, then verify the message
2135         // sender is a kyc contract.
2136         if (shyftKycContractRegistryAddress != address(0) && contractRegistry.isShyftKycContract(address(msg.sender)) == true) {
2137             if (contractRegistry.getContractVersionOfAddress(address(msg.sender)) == 0) {
2138                 // 1: the msg.sender will be the smart contract of origin.
2139                 // 2: the sender has sent to this address.
2140                 // 3: the only data we have is the "from" that is unique, this is the initial msg.sender of the transaction chain.
2141                 // 4: consider the main purpose of the send to be upgrading anyhow
2142                 // 5: this contract will now have a balance in the other one, which it never needs to move (very important if there were issues with the act of person<->person transfer).
2143                 // 6: this contract will then *mint* the balance into being, into the sender's account.
2144 
2145                 bytes4 tokenSig;
2146 
2147                 //make sure we have enough bytes to determine a signature
2148                 if (_data.length >= 4) {
2149                     tokenSig = bytes4(uint32(bytes4(bytes1(_data[3])) >> 24) + uint32(bytes4(bytes1(_data[2])) >> 16) + uint32(bytes4(bytes1(_data[1])) >> 8) + uint32(bytes4(bytes1(_data[0]))));
2150                 }
2151 
2152                 // reject the transaction if the token signature is a "withdrawToExternalContract" event from the v0 contract.
2153                 // as this update has zero issues
2154                 if (tokenSig != shyftKycContractSig) {
2155                     balances[_from][ShyftTokenType] = balances[_from][ShyftTokenType].add(_value);
2156                     totalSupplyBip32X[ShyftTokenType] = totalSupplyBip32X[ShyftTokenType].add(_value);
2157 
2158                     v1TotalUpgradeAmount = v1TotalUpgradeAmount.add(_value);
2159 
2160                     emit EVT_TransferAndMintBip32X(msg.sender, _from, _value, ShyftTokenType);
2161                     emit EVT_UpgradeFromV1(msg.sender, _from, _value);
2162 
2163                     ok = true;
2164                 } else {
2165                     revert("cannot process a withdrawToExternalContract event from the v0 contract.");
2166                 }
2167 
2168             } else {
2169                 revert("cannot process fallback from Shyft Kyc Contract of a revision not equal to 0, in this version of Shyft Core");
2170             }
2171         }
2172     }
2173 
2174     //---------------- ERC 20 ----------------//
2175 
2176     /// @param _who The address of the user.
2177     /// @dev Gets the balance for the SHFT token type for a specific user.
2178     /// @return the balance of the SHFT token type for the user
2179 
2180     function balanceOf(address _who) public view override returns (uint) {
2181         return balances[_who][ShyftTokenType];
2182     }
2183 
2184     /// @dev Gets the name of the token.
2185     /// @return _name of the token.
2186 
2187     function name() public pure returns (string memory _name) {
2188         return "Shyft [ Wrapped ]";
2189     }
2190 
2191     /// @dev Gets the symbol of the token.
2192     /// @return _symbol the symbol of the token
2193 
2194     function symbol() public pure returns (string memory _symbol) {
2195         //@note: "SFT" is the 3 letter variant
2196         return "SHFT";
2197     }
2198 
2199     /// @dev Gets the number of decimals of the token.
2200     /// @return _decimals number of decimals of the token.
2201 
2202     function decimals() public pure returns (uint8 _decimals) {
2203         return 18;
2204     }
2205 
2206     /// @dev Gets the number of SHFT tokens available.
2207     /// @return result total supply of SHFT tokens
2208 
2209     function totalSupply() public view override returns (uint256 result) {
2210         return getTotalSupplyBip32X(ShyftTokenType);
2211     }
2212 
2213     /// @param _to The address of the origin.
2214     /// @param _value The address of the recipient.
2215     /// @dev Transfers assets to destination, with ERC20 functionality. (basic ERC20 functionality, but blocks transactions if Only Accepts Kyc Input is set to true.)
2216     /// @return ok returns true if the checks pass and there are enough allowed + actual tokens to transfer to the recipient.
2217 
2218     function transfer(address _to, uint256 _value) public override returns (bool ok) {
2219         // block transfers if the recipient only allows kyc input, check other factors
2220         if (onlyAcceptsKycInput[_to] == false && balances[msg.sender][ShyftTokenType] >= _value) {
2221             balances[msg.sender][ShyftTokenType] = balances[msg.sender][ShyftTokenType].sub(_value);
2222 
2223             balances[_to][ShyftTokenType] = balances[_to][ShyftTokenType].add(_value);
2224 
2225             emit Transfer(msg.sender, _to, _value);
2226 
2227             return true;
2228         } else {
2229             return false;
2230         }
2231     }
2232 
2233     /// @param _tokenOwner The address of the origin.
2234     /// @param _spender The address of the recipient.
2235     /// @dev Get the current allowance for the basic Shyft token type. (basic ERC20 functionality)
2236     /// @return remaining the current allowance for the basic Shyft token type for a specific user
2237 
2238     function allowance(address _tokenOwner, address _spender) public view override returns (uint remaining) {
2239        return allowed[_tokenOwner][_spender][ShyftTokenType];
2240     }
2241 
2242 
2243     /// @param _spender The address of the recipient.
2244     /// @param _tokens The amount of tokens to transfer.
2245     /// @dev Allows pre-approving assets to be sent to a participant. (basic ERC20 functionality)
2246     /// @notice This (standard) function known to have an issue.
2247     /// @return success whether the approve function completed successfully
2248 
2249     function approve(address _spender, uint _tokens) public override returns (bool success) {
2250         allowed[msg.sender][_spender][ShyftTokenType] = _tokens;
2251 
2252         //example of issue:
2253         //user a has 20 tokens allowed from zero :: no incentive to frontrun
2254         //user a has +2 tokens allowed from 20 :: frontrunning would deplete 20 and add 2 :: incentive there.
2255 
2256         emit Approval(msg.sender, _spender, _tokens);
2257 
2258         return true;
2259     }
2260 
2261     /// @param _from The address of the origin.
2262     /// @param _to The address of the recipient.
2263     /// @param _tokens The amount of tokens to transfer.
2264     /// @dev Performs the withdrawal of pre-approved assets. (basic ERC20 functionality, but blocks transactions if Only Accepts Kyc Input is set to true.)
2265     /// @return success returns true if the checks pass and there are enough allowed + actual tokens to transfer to the recipient.
2266 
2267     function transferFrom(address _from, address _to, uint _tokens) public override returns (bool success) {
2268         // block transfers if the recipient only allows kyc input, check other factors
2269         if (onlyAcceptsKycInput[_to] == false && allowed[_from][msg.sender][ShyftTokenType] >= _tokens && balances[_from][ShyftTokenType] >= _tokens) {
2270             allowed[_from][msg.sender][ShyftTokenType] = allowed[_from][msg.sender][ShyftTokenType].sub(_tokens);
2271 
2272             balances[_from][ShyftTokenType] = balances[_from][ShyftTokenType].sub(_tokens);
2273             balances[_to][ShyftTokenType] = balances[_to][ShyftTokenType].add(_tokens);
2274 
2275             emit Transfer(_from, _to, _tokens);
2276             emit Approval(_from, msg.sender, allowed[_from][msg.sender][ShyftTokenType]);
2277 
2278             return true;
2279         } else {
2280             return false;
2281         }
2282     }
2283 
2284     //---------------- ERC20 Burnable/Mintable ----------------//
2285 
2286     /// @param _to The address of the receiver of minted tokens.
2287     /// @param _amount The amount of minted tokens.
2288     /// @dev Mints tokens to a specific address. Called only by an account with a minter role.
2289     /// @notice Has Shyft Opt-in Compliance feature-sets for expansion/mvp capabilities.
2290 
2291     function mint(address _to, uint256 _amount) public {
2292         require(_to != address(0), "ShyftKycContract: mint to the zero address");
2293         require(hasRole(MINTER_ROLE, msg.sender), "ShyftKycContract: must have minter role to mint");
2294 
2295         // @note: for the initial deploy we'll be able to provide an mvp implementation, and I've made it quite difficult
2296         // for the user to constrain themselves to kyc-only mode, especially before we have custom interfaces.
2297 
2298         // checks for Shyft opt-in compliance feature-sets to enforce kyc trust channel groupings.
2299         if (onlyAcceptsKycInput[_to] == true) {
2300             //make sure that there is a cache graph linked, otherwise revert.
2301             if (shyftCacheGraphAddress != address(0)) {
2302                 IShyftCacheGraph shyftCacheGraph = IShyftCacheGraph(shyftCacheGraphAddress);
2303 
2304                 //checks on consent-driven trust channels that the end user and the relayer have in common
2305                 uint8 kycCanSendResult = shyftCacheGraph.getKycCanSend(msg.sender, _to, _amount, ShyftTokenType, true, false);
2306 
2307                 //if there are any matches
2308                 if (kycCanSendResult == 3) {
2309                     // continue on
2310                 } else {
2311                     // or revert if there are no matches found.
2312                     revert("ShyftKycContract: mint to KYC only address within Trust Channel groupings");
2313                 }
2314             } else {
2315                 revert("ShyftKycContract: mint to KYC only address within Trust Channel groupings");
2316             }
2317         }
2318 
2319         totalSupplyBip32X[ShyftTokenType] = totalSupplyBip32X[ShyftTokenType].add(_amount);
2320         balances[_to][ShyftTokenType] = balances[_to][ShyftTokenType].add(_amount);
2321 
2322         emit Transfer(address(0), _to, _amount);
2323     }
2324 
2325     /// @param _account The address from which to burn tokens tokens.
2326     /// @param _amount The amount of burned tokens.
2327     /// @dev Burns tokens from a specific address, deducting from the caller's allowance.
2328     /// @dev The caller must have allowance for `accounts`'s tokens of at least `amount`.
2329 
2330     function burnFrom(address _account, uint256 _amount) public {
2331         require(_account != address(0), "ShyftKycContract: burn from the zero address");
2332         uint256 currentAllowance = allowed[_account][msg.sender][ShyftTokenType];
2333         require(currentAllowance >= _amount, "ShyftKycContract: burn amount exceeds allowance");
2334         uint256 accountBalance = balances[_account][ShyftTokenType];
2335         require(accountBalance >= _amount, "ShyftKycContract: burn amount exceeds balance");
2336 
2337         allowed[_account][msg.sender][ShyftTokenType] = currentAllowance.sub(_amount);
2338 
2339         emit Approval(_account, msg.sender, allowed[_account][msg.sender][ShyftTokenType]);
2340 
2341         balances[_account][ShyftTokenType] = accountBalance.sub(_amount);
2342         totalSupplyBip32X[ShyftTokenType] = totalSupplyBip32X[ShyftTokenType].sub(_amount);
2343 
2344         emit Transfer(_account, address(0), _amount);
2345     }
2346 
2347     //---------------- Bip32X Burnable/Mintable ----------------//
2348 
2349     /// @param _to The address of the receiver of minted tokens.
2350     /// @param _amount The amount of minted tokens.
2351     /// @param _bip32X_type The Bip32X type of the token.
2352     /// @dev Mints tokens to a specific address. Called only by an account with a minter role.
2353     /// @notice Has Shyft Opt-in Compliance feature-sets for expansion/mvp capabilities.
2354 
2355     function mintBip32X(address _to, uint256 _amount, uint256 _bip32X_type) public override {
2356         require(_to != address(0), "ShyftKycContract: mint to the zero address");
2357         require(hasRole(MINTER_ROLE, msg.sender), "ShyftKycContract: must have minter role to mint");
2358 
2359         // @note: for the initial deploy we'll be able to provide an mvp implementation, and I've made it quite difficult
2360         // for the user to constrain themselves to kyc-only mode, especially before we have custom interfaces.
2361 
2362         // checks for Shyft opt-in compliance feature-sets to enforce kyc trust channel groupings.
2363         if (onlyAcceptsKycInput[_to] == true) {
2364             //make sure that there is a cache graph linked, otherwise revert.
2365             if (shyftCacheGraphAddress != address(0)) {
2366                 IShyftCacheGraph shyftCacheGraph = IShyftCacheGraph(shyftCacheGraphAddress);
2367 
2368                 //checks on consent-driven trust channels that the end user and the relayer have in common
2369                 uint8 kycCanSendResult = shyftCacheGraph.getKycCanSend(msg.sender, _to, _amount, _bip32X_type, true, false);
2370 
2371                 //if there are any matches
2372                 if (kycCanSendResult == 3) {
2373                     // continue on
2374                 } else {
2375                     // or revert if there are no matches found.
2376                     revert("ShyftKycContract: mint to KYC only address within Trust Channel groupings");
2377                 }
2378             } else {
2379                 revert("ShyftKycContract: mint to KYC only address within Trust Channel groupings");
2380             }
2381         }
2382 
2383         totalSupplyBip32X[_bip32X_type] = totalSupplyBip32X[_bip32X_type].add(_amount);
2384         balances[_to][_bip32X_type] = balances[_to][_bip32X_type].add(_amount);
2385 
2386 
2387         emit EVT_TransferBip32X(address(0), _to, _amount, _bip32X_type);
2388     }
2389 
2390     /// @param _account The address from which to burn tokens tokens.
2391     /// @param _amount The amount of burned tokens.
2392     /// @param _bip32X_type The Bip32X type of the token.
2393     /// @dev Burns tokens from a specific address, deducting from the caller's allowance.
2394     /// @dev The caller must have allowance for `accounts`'s tokens of at least `amount`.
2395 
2396     function burnFromBip32X(address _account, uint256 _amount, uint256 _bip32X_type) public override {
2397         require(_account != address(0), "ShyftKycContract: burn from the zero address");
2398         uint256 currentAllowance = allowed[_account][msg.sender][_bip32X_type];
2399         require(currentAllowance >= _amount, "ShyftKycContract: burn amount exceeds allowance");
2400         uint256 accountBalance = balances[_account][_bip32X_type];
2401         require(accountBalance >= _amount, "ShyftKycContract: burn amount exceeds balance");
2402 
2403         allowed[_account][msg.sender][_bip32X_type] = currentAllowance.sub(_amount);
2404 
2405         emit EVT_ApprovalBip32X(_account, msg.sender, allowed[_account][msg.sender][_bip32X_type], _bip32X_type);
2406 
2407         balances[_account][_bip32X_type] = accountBalance.sub(_amount);
2408         totalSupplyBip32X[_bip32X_type] = totalSupplyBip32X[_bip32X_type].sub(_amount);
2409 
2410         emit EVT_TransferBip32X(_account, address(0), _amount, _bip32X_type);
2411     }
2412 
2413     //---------------- Shyft Token Transfer / Approval [KycContract] ----------------//
2414 
2415     /// @param _to The address of the recipient.
2416     /// @param _value The amount of tokens to transfer.
2417     /// @param _bip32X_type The Bip32X type of the asset to transfer.
2418     /// @dev | Transfers assets from one Shyft user to another, with restrictions on the transfer if the recipient has enabled Only Accept KYC Input.
2419     /// @return result returns true if the transaction completes, reverts if it does not.
2420 
2421     function transferBip32X(address _to, uint256 _value, uint256 _bip32X_type) public override returns (bool result) {
2422         // block transfers if the recipient only allows kyc input
2423         require(onlyAcceptsKycInput[_to] == false, "recipient must not only accept kyc'd input");
2424         require(balances[msg.sender][_bip32X_type] >= _value, "not enough balance");
2425 
2426         balances[msg.sender][_bip32X_type] = balances[msg.sender][_bip32X_type].sub(_value);
2427         balances[_to][_bip32X_type] = balances[_to][_bip32X_type].add(_value);
2428 
2429         emit EVT_TransferBip32X(msg.sender, _to, _value, _bip32X_type);
2430         return true;
2431     }
2432 
2433     /// @param _tokenOwner The address of the origin.
2434     /// @param _spender The address of the recipient.
2435     /// @param _bip32X_type The Bip32X type of the token.
2436     /// @dev Get the current allowance for the basic Shyft token type. (basic ERC20 functionality, Bip32X assets)
2437     /// @return remaining the current allowance for the basic Shyft token type for a specific user
2438 
2439     function allowanceBip32X(address _tokenOwner, address _spender, uint256 _bip32X_type) public view override returns (uint remaining) {
2440         return allowed[_tokenOwner][_spender][_bip32X_type];
2441     }
2442 
2443 
2444     /// @param _spender The address of the recipient.
2445     /// @param _tokens The amount of tokens to transfer.
2446     /// @param _bip32X_type The Bip32X type of the token.
2447     /// @dev Allows pre-approving assets to be sent to a participant. (basic ERC20 functionality, Bip32X assets)
2448     /// @notice This (standard) function known to have an issue.
2449     /// @return success whether the approve function completed successfully
2450 
2451     function approveBip32X(address _spender, uint _tokens, uint256 _bip32X_type) public override returns (bool success) {
2452         allowed[msg.sender][_spender][_bip32X_type] = _tokens;
2453 
2454         //example of issue:
2455         //user a has 20 tokens allowed from zero :: no incentive to frontrun
2456         //user a has +2 tokens allowed from 20 :: frontrunning would deplete 20 and add 2 :: incentive there.
2457 
2458         emit EVT_ApprovalBip32X(msg.sender, _spender, _tokens, _bip32X_type);
2459 
2460         return true;
2461     }
2462 
2463     /// @param _from The address of the origin.
2464     /// @param _to The address of the recipient.
2465     /// @param _tokens The amount of tokens to transfer.
2466     /// @param _bip32X_type The Bip32X type of the token.
2467     /// @dev Performs the withdrawal of pre-approved assets. (basic ERC20 functionality, but blocks transactions if Only Accepts Kyc Input is set to true, Bip32X assets)
2468     /// @return success returns true if the checks pass and there are enough allowed + actual tokens to transfer to the recipient.
2469 
2470     function transferFromBip32X(address _from, address _to, uint _tokens, uint256 _bip32X_type) public override returns (bool success) {
2471         // block transfers if the recipient only allows kyc input, check other factors
2472         if (onlyAcceptsKycInput[_to] == false && allowed[_from][msg.sender][_bip32X_type] >= _tokens && balances[_from][ShyftTokenType] >= _tokens) {
2473             allowed[_from][msg.sender][_bip32X_type] = allowed[_from][msg.sender][_bip32X_type].sub(_tokens);
2474 
2475             balances[_from][_bip32X_type] = balances[_from][_bip32X_type].sub(_tokens);
2476             balances[_to][_bip32X_type] = balances[_to][_bip32X_type].add(_tokens);
2477 
2478             emit EVT_TransferBip32X(_from, _to, _tokens, _bip32X_type);
2479             emit EVT_ApprovalBip32X(_from, msg.sender, allowed[_from][msg.sender][_bip32X_type], _bip32X_type);
2480 
2481             return true;
2482         } else {
2483             return false;
2484         }
2485     }
2486 
2487     //---------------- Shyft Token Transfer [Erc20] ----------------//
2488 
2489     /// @param _erc20ContractAddress The address of the ERC20 contract.
2490     /// @param _value The amount of tokens to transfer.
2491     /// @dev | Transfers assets from any Erc20 contract to a Bip32X type Shyft synthetic asset. Mints the current synthetic balance.
2492     /// @return ok returns true if the transaction completes, reverts if it does not
2493 
2494     function transferFromErc20TokenToBip32X(address _erc20ContractAddress, uint256 _value) mutex public override returns (bool ok) {
2495         require(_erc20ContractAddress != address(this), "cannot transfer from this contract");
2496 
2497         // block transfers if the recipient only allows kyc input, check other factors
2498         require(onlyAcceptsKycInput[msg.sender] == false, "recipient must not only accept kyc'd input");
2499 
2500         IERC20 erc20Contract = IERC20(_erc20ContractAddress);
2501 
2502         if (erc20Contract.allowance(msg.sender, address(this)) >= _value) {
2503             erc20Contract.safeTransferFrom(msg.sender, address(this), _value);
2504             //@note: using _erc20ContractAddress in the keccak hash since _erc20ContractAddress will be where
2505             // the tokens are created and managed.
2506             //
2507             // thus, this fallback will not function properly with abstracted synthetics (including this contract)
2508             // hence the initial require() check above to prevent this behaviour.
2509 
2510             uint256 bip32X_type = uint256(keccak256(abi.encodePacked(nativeBip32X_type, _erc20ContractAddress)));
2511             balances[msg.sender][bip32X_type] = balances[msg.sender][bip32X_type].add(_value);
2512             totalSupplyBip32X[bip32X_type] = totalSupplyBip32X[bip32X_type].add(_value);
2513 
2514             emit EVT_TransferAndMintBip32X(_erc20ContractAddress, msg.sender, _value, bip32X_type);
2515 
2516             //transfer successful
2517             ok = true;
2518         } else {
2519             //not enough allowance
2520         }
2521     }
2522 
2523     /// @param _erc20ContractAddress The address of the ERC20 contract that
2524     /// @param _to The address of the recipient.
2525     /// @param _value The amount of tokens to transfer.
2526     /// @dev | Withdraws a Bip32X type Shyft synthetic asset into its origin ERC20 contract. Burns the current synthetic balance.
2527     ///      | Cannot withdraw Bip32X type into an incorrect destination contract (as the hash will not match).
2528     /// @return ok returns true if the transaction completes, reverts if it does not
2529 
2530     function withdrawTokenBip32XToErc20(address _erc20ContractAddress, address _to, uint256 _value) mutex public override returns (bool ok) {
2531         uint256 bip32X_type = uint256(keccak256(abi.encodePacked(nativeBip32X_type, _erc20ContractAddress)));
2532 
2533         require(balances[msg.sender][bip32X_type] >= _value, "not enough balance");
2534 
2535         balances[msg.sender][bip32X_type] = balances[msg.sender][bip32X_type].sub(_value);
2536         totalSupplyBip32X[bip32X_type] = totalSupplyBip32X[bip32X_type].sub(_value);
2537 
2538         IERC20 erc20Contract = IERC20(_erc20ContractAddress);
2539 
2540         erc20Contract.safeTransfer(_to, _value);
2541 
2542         emit EVT_TransferAndBurnBip32X(_erc20ContractAddress, msg.sender, _to, _value, bip32X_type);
2543 
2544         ok = true;
2545     }
2546 
2547     //@note:@v1Upgrade:
2548     //---------------- Emergency Upgrade Requirements ----------------//
2549 
2550     // issue with the ethereum-based march 26th launch was that the transfer() function is the only way to move tokens,
2551     // **but** the function naming convention of erc223 (which allows this functionality with a specific receiver built
2552     // into this) is also "transfer" with the caveat that the function signature is:
2553     // [erc20] transfer(address,uint256) vs [erc223] transfer(address,uint256,bytes).
2554     //
2555     // given this, there is a high likelihood that a subset of users will incorrectly trigger this upgrade function,
2556     // leaving their coins isolated in the ERC20-ish mechanism vs being properly upgraded.
2557     //
2558     // as such, we're introducing an administrator-triggered differentiation into a "spendable" address for these tokens,
2559     // with the obvious caveat that this maneuver costs ETH on the redemption side.
2560 
2561 
2562     /// @param _emergencyResponder The address of the v1 emergency responder.
2563     /// @dev Sets the emergency responder (address responsible for sending back incorrectly-sent transfer functions)
2564     /// @return result
2565     ///    | 1 = set emergency responder correctly
2566     ///    | 0 = not owner
2567 
2568     function setV1EmergencyErc20RedemptionResponder(address _emergencyResponder) public returns(uint8 result) {
2569         if (msg.sender == owner) {
2570             emergencyResponder = _emergencyResponder;
2571 
2572             emit EVT_setV1EmergencyResponder(_emergencyResponder);
2573             // set emergency responder correctly
2574             return 1;
2575         } else {
2576             // not owner
2577             return 0;
2578         }
2579     }
2580 
2581     /// @dev Gets the incorrectly-sent erc20 balance (the difference between what has been associated to this contract via the upgrade function vs the erc20-based "transfer(address,uint256)" function.
2582     /// @return result
2583     ///    | [amount] = incorrectly sent asset balance.
2584     ///    | 0 = registry not set up properly, or 0 balance.
2585 
2586     function getIncorrectlySentAssetsBalance() public view returns(uint256 result) {
2587         IShyftKycContractRegistry contractRegistry = IShyftKycContractRegistry(shyftKycContractRegistryAddress);
2588 
2589         address ethMarch26KycContractAddress = contractRegistry.getContractAddressOfVersion(0);
2590 
2591         if (ethMarch26KycContractAddress != address(0)) {
2592 
2593             IERC20 march26Erc20 = IERC20(ethMarch26KycContractAddress);
2594 
2595             uint256 currentBalance = march26Erc20.balanceOf(address(this));
2596 
2597             uint256 incorrectlySentAssetBalance = currentBalance.sub(v1TotalUpgradeAmount);
2598 
2599             return incorrectlySentAssetBalance;
2600         } else {
2601             //registry not set up properly
2602             return 0;
2603         }
2604     }
2605 
2606     /// @param _destination The destination for the redeemed assets.
2607     /// @param _amount The amount of the assets to redeem.
2608     /// @dev Redeems assets to specific destinations. As there is no tracking functionality that will not break the gas expectations, there is an external mechanism to redeem assets correctly off-chain based on the transaction receipts.
2609     /// @return result
2610     ///    | 4 = redeemed assets correctly
2611     ///    | [revert] = erc20-based "transfer(address,uint256" function did not return okay
2612     ///    | 2 = did not have enough tokens in incorrectly-sent balance account to redeem
2613     ///    | 1 = registry not set up properly
2614     ///    | 0 = not responder
2615 
2616     function responderRedeemIncorrectlySentAssets(address _destination, uint256 _amount) public returns(uint8 result) {
2617         if (msg.sender == emergencyResponder) {
2618             IShyftKycContractRegistry contractRegistry = IShyftKycContractRegistry(shyftKycContractRegistryAddress);
2619 
2620             address ethMarch26KycContractAddress = contractRegistry.getContractAddressOfVersion(0);
2621 
2622             if (ethMarch26KycContractAddress != address(0)) {
2623                 IERC20 march26Erc20 = IERC20(ethMarch26KycContractAddress);
2624 
2625                 uint256 currentBalance = march26Erc20.balanceOf(address(this));
2626 
2627                 uint256 incorrectlySentAssetBalance = currentBalance.sub(v1TotalUpgradeAmount);
2628 
2629                 if (_amount <= incorrectlySentAssetBalance) {
2630                     bool success = march26Erc20.transfer(_destination, _amount);
2631 
2632                     if (success == true) {
2633                         emit EVT_redeemIncorrectlySentAsset(_destination, _amount);
2634 
2635                         //redeemed assets correctly
2636                         return 4;
2637                     } else {
2638                         //must revert since transactional action has occurred
2639                         revert("erc20 transfer event did not succeed");
2640                         //                    return 3;
2641                     }
2642                 } else {
2643                     //did not have enough tokens in incorrectly-sent balance account to redeem
2644                     return 2;
2645                 }
2646             } else {
2647                 //registry not set up properly
2648                 return 1;
2649             }
2650         } else {
2651             //not responder
2652             return 0;
2653         }
2654     }
2655 }