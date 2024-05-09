1 // File: contracts/assets/IOperatorFilterRegistry.sol
2 
3 
4 pragma solidity ^0.8.2;
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
8     function register(address registrant) external;
9     function registerAndSubscribe(address registrant, address subscription) external;
10     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
11     function unregister(address addr) external;
12     function updateOperator(address registrant, address operator, bool filtered) external;
13     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
14     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
15     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
16     function subscribe(address registrant, address registrantToSubscribe) external;
17     function unsubscribe(address registrant, bool copyExistingEntries) external;
18     function subscriptionOf(address addr) external returns (address registrant);
19     function subscribers(address registrant) external returns (address[] memory);
20     function subscriberAt(address registrant, uint256 index) external returns (address);
21     function copyEntriesOf(address registrant, address registrantToCopy) external;
22     function isOperatorFiltered(address registrant, address operator) external returns (bool);
23     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
24     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
25     function filteredOperators(address addr) external returns (address[] memory);
26     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
27     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
28     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
29     function isRegistered(address addr) external returns (bool);
30     function codeHashOf(address addr) external returns (bytes32);
31 }
32 // File: contracts/assets/OperatorFilterer.sol
33 
34 
35 pragma solidity ^0.8.2;
36 
37 
38 /**
39  * @title  OperatorFilterer
40  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
41  *         registrant's entries in the OperatorFilterRegistry.
42  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
43  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
44  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
45  */
46 abstract contract OperatorFilterer {
47     error OperatorNotAllowed(address operator);
48 
49     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
50         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
51 
52     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
53         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
54         // will not revert, but the contract will need to be registered with the registry once it is deployed in
55         // order for the modifier to filter addresses.
56         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
57             if (subscribe) {
58                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
59             } else {
60                 if (subscriptionOrRegistrantToCopy != address(0)) {
61                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
62                 } else {
63                     OPERATOR_FILTER_REGISTRY.register(address(this));
64                 }
65             }
66         }
67     }
68 
69     modifier onlyAllowedOperator(address from) virtual {
70         // Allow spending tokens from addresses with balance
71         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
72         // from an EOA.
73         if (from != msg.sender) {
74             _checkFilterOperator(msg.sender);
75         }
76         _;
77     }
78 
79     modifier onlyAllowedOperatorApproval(address operator) virtual {
80         _checkFilterOperator(operator);
81         _;
82     }
83 
84     function _checkFilterOperator(address operator) internal view virtual {
85         // Check registry code length to facilitate testing in environments without a deployed registry.
86         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
87             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
88                 revert OperatorNotAllowed(operator);
89             }
90         }
91     }
92 }
93 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol
94 
95 
96 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
97 
98 pragma solidity ^0.8.0;
99 
100 // CAUTION
101 // This version of SafeMath should only be used with Solidity 0.8 or later,
102 // because it relies on the compiler's built in overflow checks.
103 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations.
106  *
107  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
108  * now has built in overflow checking.
109  */
110 library SafeMath {
111     /**
112      * @dev Returns the addition of two unsigned integers, with an overflow flag.
113      *
114      * _Available since v3.4._
115      */
116     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
117         unchecked {
118             uint256 c = a + b;
119             if (c < a) return (false, 0);
120             return (true, c);
121         }
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
126      *
127      * _Available since v3.4._
128      */
129     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
130         unchecked {
131             if (b > a) return (false, 0);
132             return (true, a - b);
133         }
134     }
135 
136     /**
137      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
138      *
139      * _Available since v3.4._
140      */
141     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
142         unchecked {
143             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
144             // benefit is lost if 'b' is also tested.
145             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
146             if (a == 0) return (true, 0);
147             uint256 c = a * b;
148             if (c / a != b) return (false, 0);
149             return (true, c);
150         }
151     }
152 
153     /**
154      * @dev Returns the division of two unsigned integers, with a division by zero flag.
155      *
156      * _Available since v3.4._
157      */
158     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
159         unchecked {
160             if (b == 0) return (false, 0);
161             return (true, a / b);
162         }
163     }
164 
165     /**
166      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
167      *
168      * _Available since v3.4._
169      */
170     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
171         unchecked {
172             if (b == 0) return (false, 0);
173             return (true, a % b);
174         }
175     }
176 
177     /**
178      * @dev Returns the addition of two unsigned integers, reverting on
179      * overflow.
180      *
181      * Counterpart to Solidity's `+` operator.
182      *
183      * Requirements:
184      *
185      * - Addition cannot overflow.
186      */
187     function add(uint256 a, uint256 b) internal pure returns (uint256) {
188         return a + b;
189     }
190 
191     /**
192      * @dev Returns the subtraction of two unsigned integers, reverting on
193      * overflow (when the result is negative).
194      *
195      * Counterpart to Solidity's `-` operator.
196      *
197      * Requirements:
198      *
199      * - Subtraction cannot overflow.
200      */
201     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
202         return a - b;
203     }
204 
205     /**
206      * @dev Returns the multiplication of two unsigned integers, reverting on
207      * overflow.
208      *
209      * Counterpart to Solidity's `*` operator.
210      *
211      * Requirements:
212      *
213      * - Multiplication cannot overflow.
214      */
215     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
216         return a * b;
217     }
218 
219     /**
220      * @dev Returns the integer division of two unsigned integers, reverting on
221      * division by zero. The result is rounded towards zero.
222      *
223      * Counterpart to Solidity's `/` operator.
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function div(uint256 a, uint256 b) internal pure returns (uint256) {
230         return a / b;
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
235      * reverting when dividing by zero.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
246         return a % b;
247     }
248 
249     /**
250      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
251      * overflow (when the result is negative).
252      *
253      * CAUTION: This function is deprecated because it requires allocating memory for the error
254      * message unnecessarily. For custom revert reasons use {trySub}.
255      *
256      * Counterpart to Solidity's `-` operator.
257      *
258      * Requirements:
259      *
260      * - Subtraction cannot overflow.
261      */
262     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
263         unchecked {
264             require(b <= a, errorMessage);
265             return a - b;
266         }
267     }
268 
269     /**
270      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
271      * division by zero. The result is rounded towards zero.
272      *
273      * Counterpart to Solidity's `/` operator. Note: this function uses a
274      * `revert` opcode (which leaves remaining gas untouched) while Solidity
275      * uses an invalid opcode to revert (consuming all remaining gas).
276      *
277      * Requirements:
278      *
279      * - The divisor cannot be zero.
280      */
281     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
282         unchecked {
283             require(b > 0, errorMessage);
284             return a / b;
285         }
286     }
287 
288     /**
289      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
290      * reverting with custom message when dividing by zero.
291      *
292      * CAUTION: This function is deprecated because it requires allocating memory for the error
293      * message unnecessarily. For custom revert reasons use {tryMod}.
294      *
295      * Counterpart to Solidity's `%` operator. This function uses a `revert`
296      * opcode (which leaves remaining gas untouched) while Solidity uses an
297      * invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      *
301      * - The divisor cannot be zero.
302      */
303     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
304         unchecked {
305             require(b > 0, errorMessage);
306             return a % b;
307         }
308     }
309 }
310 
311 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
312 
313 
314 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
315 
316 pragma solidity ^0.8.0;
317 
318 /**
319  * @dev String operations.
320  */
321 library Strings {
322     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
323     uint8 private constant _ADDRESS_LENGTH = 20;
324 
325     /**
326      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
327      */
328     function toString(uint256 value) internal pure returns (string memory) {
329         // Inspired by OraclizeAPI's implementation - MIT licence
330         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
331 
332         if (value == 0) {
333             return "0";
334         }
335         uint256 temp = value;
336         uint256 digits;
337         while (temp != 0) {
338             digits++;
339             temp /= 10;
340         }
341         bytes memory buffer = new bytes(digits);
342         while (value != 0) {
343             digits -= 1;
344             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
345             value /= 10;
346         }
347         return string(buffer);
348     }
349 
350     /**
351      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
352      */
353     function toHexString(uint256 value) internal pure returns (string memory) {
354         if (value == 0) {
355             return "0x00";
356         }
357         uint256 temp = value;
358         uint256 length = 0;
359         while (temp != 0) {
360             length++;
361             temp >>= 8;
362         }
363         return toHexString(value, length);
364     }
365 
366     /**
367      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
368      */
369     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
370         bytes memory buffer = new bytes(2 * length + 2);
371         buffer[0] = "0";
372         buffer[1] = "x";
373         for (uint256 i = 2 * length + 1; i > 1; --i) {
374             buffer[i] = _HEX_SYMBOLS[value & 0xf];
375             value >>= 4;
376         }
377         require(value == 0, "Strings: hex length insufficient");
378         return string(buffer);
379     }
380 
381     /**
382      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
383      */
384     function toHexString(address addr) internal pure returns (string memory) {
385         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
386     }
387 }
388 
389 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
390 
391 
392 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 /**
397  * @dev Provides information about the current execution context, including the
398  * sender of the transaction and its data. While these are generally available
399  * via msg.sender and msg.data, they should not be accessed in such a direct
400  * manner, since when dealing with meta-transactions the account sending and
401  * paying for execution may not be the actual sender (as far as an application
402  * is concerned).
403  *
404  * This contract is only required for intermediate, library-like contracts.
405  */
406 abstract contract Context {
407     function _msgSender() internal view virtual returns (address) {
408         return msg.sender;
409     }
410 
411     function _msgData() internal view virtual returns (bytes calldata) {
412         return msg.data;
413     }
414 }
415 
416 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
417 
418 
419 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
420 
421 pragma solidity ^0.8.0;
422 
423 
424 /**
425  * @dev Contract module which provides a basic access control mechanism, where
426  * there is an account (an owner) that can be granted exclusive access to
427  * specific functions.
428  *
429  * By default, the owner account will be the one that deploys the contract. This
430  * can later be changed with {transferOwnership}.
431  *
432  * This module is used through inheritance. It will make available the modifier
433  * `onlyOwner`, which can be applied to your functions to restrict their use to
434  * the owner.
435  */
436 abstract contract Ownable is Context {
437     address private _owner;
438 
439     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
440 
441     /**
442      * @dev Initializes the contract setting the deployer as the initial owner.
443      */
444     constructor() {
445         _transferOwnership(_msgSender());
446     }
447 
448     /**
449      * @dev Throws if called by any account other than the owner.
450      */
451     modifier onlyOwner() {
452         _checkOwner();
453         _;
454     }
455 
456     /**
457      * @dev Returns the address of the current owner.
458      */
459     function owner() public view virtual returns (address) {
460         return _owner;
461     }
462 
463     /**
464      * @dev Throws if the sender is not the owner.
465      */
466     function _checkOwner() internal view virtual {
467         require(owner() == _msgSender(), "Ownable: caller is not the owner");
468     }
469 
470     /**
471      * @dev Leaves the contract without owner. It will not be possible to call
472      * `onlyOwner` functions anymore. Can only be called by the current owner.
473      *
474      * NOTE: Renouncing ownership will leave the contract without an owner,
475      * thereby removing any functionality that is only available to the owner.
476      */
477     function renounceOwnership() public virtual onlyOwner {
478         _transferOwnership(address(0));
479     }
480 
481     /**
482      * @dev Transfers ownership of the contract to a new account (`newOwner`).
483      * Can only be called by the current owner.
484      */
485     function transferOwnership(address newOwner) public virtual onlyOwner {
486         require(newOwner != address(0), "Ownable: new owner is the zero address");
487         _transferOwnership(newOwner);
488     }
489 
490     /**
491      * @dev Transfers ownership of the contract to a new account (`newOwner`).
492      * Internal function without access restriction.
493      */
494     function _transferOwnership(address newOwner) internal virtual {
495         address oldOwner = _owner;
496         _owner = newOwner;
497         emit OwnershipTransferred(oldOwner, newOwner);
498     }
499 }
500 
501 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
502 
503 
504 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
505 
506 pragma solidity ^0.8.1;
507 
508 /**
509  * @dev Collection of functions related to the address type
510  */
511 library Address {
512     /**
513      * @dev Returns true if `account` is a contract.
514      *
515      * [IMPORTANT]
516      * ====
517      * It is unsafe to assume that an address for which this function returns
518      * false is an externally-owned account (EOA) and not a contract.
519      *
520      * Among others, `isContract` will return false for the following
521      * types of addresses:
522      *
523      *  - an externally-owned account
524      *  - a contract in construction
525      *  - an address where a contract will be created
526      *  - an address where a contract lived, but was destroyed
527      * ====
528      *
529      * [IMPORTANT]
530      * ====
531      * You shouldn't rely on `isContract` to protect against flash loan attacks!
532      *
533      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
534      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
535      * constructor.
536      * ====
537      */
538     function isContract(address account) internal view returns (bool) {
539         // This method relies on extcodesize/address.code.length, which returns 0
540         // for contracts in construction, since the code is only stored at the end
541         // of the constructor execution.
542 
543         return account.code.length > 0;
544     }
545 
546     /**
547      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
548      * `recipient`, forwarding all available gas and reverting on errors.
549      *
550      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
551      * of certain opcodes, possibly making contracts go over the 2300 gas limit
552      * imposed by `transfer`, making them unable to receive funds via
553      * `transfer`. {sendValue} removes this limitation.
554      *
555      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
556      *
557      * IMPORTANT: because control is transferred to `recipient`, care must be
558      * taken to not create reentrancy vulnerabilities. Consider using
559      * {ReentrancyGuard} or the
560      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
561      */
562     function sendValue(address payable recipient, uint256 amount) internal {
563         require(address(this).balance >= amount, "Address: insufficient balance");
564 
565         (bool success, ) = recipient.call{value: amount}("");
566         require(success, "Address: unable to send value, recipient may have reverted");
567     }
568 
569     /**
570      * @dev Performs a Solidity function call using a low level `call`. A
571      * plain `call` is an unsafe replacement for a function call: use this
572      * function instead.
573      *
574      * If `target` reverts with a revert reason, it is bubbled up by this
575      * function (like regular Solidity function calls).
576      *
577      * Returns the raw returned data. To convert to the expected return value,
578      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
579      *
580      * Requirements:
581      *
582      * - `target` must be a contract.
583      * - calling `target` with `data` must not revert.
584      *
585      * _Available since v3.1._
586      */
587     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
588         return functionCall(target, data, "Address: low-level call failed");
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
593      * `errorMessage` as a fallback revert reason when `target` reverts.
594      *
595      * _Available since v3.1._
596      */
597     function functionCall(
598         address target,
599         bytes memory data,
600         string memory errorMessage
601     ) internal returns (bytes memory) {
602         return functionCallWithValue(target, data, 0, errorMessage);
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
607      * but also transferring `value` wei to `target`.
608      *
609      * Requirements:
610      *
611      * - the calling contract must have an ETH balance of at least `value`.
612      * - the called Solidity function must be `payable`.
613      *
614      * _Available since v3.1._
615      */
616     function functionCallWithValue(
617         address target,
618         bytes memory data,
619         uint256 value
620     ) internal returns (bytes memory) {
621         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
626      * with `errorMessage` as a fallback revert reason when `target` reverts.
627      *
628      * _Available since v3.1._
629      */
630     function functionCallWithValue(
631         address target,
632         bytes memory data,
633         uint256 value,
634         string memory errorMessage
635     ) internal returns (bytes memory) {
636         require(address(this).balance >= value, "Address: insufficient balance for call");
637         require(isContract(target), "Address: call to non-contract");
638 
639         (bool success, bytes memory returndata) = target.call{value: value}(data);
640         return verifyCallResult(success, returndata, errorMessage);
641     }
642 
643     /**
644      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
645      * but performing a static call.
646      *
647      * _Available since v3.3._
648      */
649     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
650         return functionStaticCall(target, data, "Address: low-level static call failed");
651     }
652 
653     /**
654      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
655      * but performing a static call.
656      *
657      * _Available since v3.3._
658      */
659     function functionStaticCall(
660         address target,
661         bytes memory data,
662         string memory errorMessage
663     ) internal view returns (bytes memory) {
664         require(isContract(target), "Address: static call to non-contract");
665 
666         (bool success, bytes memory returndata) = target.staticcall(data);
667         return verifyCallResult(success, returndata, errorMessage);
668     }
669 
670     /**
671      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
672      * but performing a delegate call.
673      *
674      * _Available since v3.4._
675      */
676     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
677         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
678     }
679 
680     /**
681      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
682      * but performing a delegate call.
683      *
684      * _Available since v3.4._
685      */
686     function functionDelegateCall(
687         address target,
688         bytes memory data,
689         string memory errorMessage
690     ) internal returns (bytes memory) {
691         require(isContract(target), "Address: delegate call to non-contract");
692 
693         (bool success, bytes memory returndata) = target.delegatecall(data);
694         return verifyCallResult(success, returndata, errorMessage);
695     }
696 
697     /**
698      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
699      * revert reason using the provided one.
700      *
701      * _Available since v4.3._
702      */
703     function verifyCallResult(
704         bool success,
705         bytes memory returndata,
706         string memory errorMessage
707     ) internal pure returns (bytes memory) {
708         if (success) {
709             return returndata;
710         } else {
711             // Look for revert reason and bubble it up if present
712             if (returndata.length > 0) {
713                 // The easiest way to bubble the revert reason is using memory via assembly
714                 /// @solidity memory-safe-assembly
715                 assembly {
716                     let returndata_size := mload(returndata)
717                     revert(add(32, returndata), returndata_size)
718                 }
719             } else {
720                 revert(errorMessage);
721             }
722         }
723     }
724 }
725 
726 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
727 
728 
729 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
730 
731 pragma solidity ^0.8.0;
732 
733 /**
734  * @title ERC721 token receiver interface
735  * @dev Interface for any contract that wants to support safeTransfers
736  * from ERC721 asset contracts.
737  */
738 interface IERC721Receiver {
739     /**
740      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
741      * by `operator` from `from`, this function is called.
742      *
743      * It must return its Solidity selector to confirm the token transfer.
744      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
745      *
746      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
747      */
748     function onERC721Received(
749         address operator,
750         address from,
751         uint256 tokenId,
752         bytes calldata data
753     ) external returns (bytes4);
754 }
755 
756 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
757 
758 
759 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
760 
761 pragma solidity ^0.8.0;
762 
763 /**
764  * @dev Interface of the ERC165 standard, as defined in the
765  * https://eips.ethereum.org/EIPS/eip-165[EIP].
766  *
767  * Implementers can declare support of contract interfaces, which can then be
768  * queried by others ({ERC165Checker}).
769  *
770  * For an implementation, see {ERC165}.
771  */
772 interface IERC165 {
773     /**
774      * @dev Returns true if this contract implements the interface defined by
775      * `interfaceId`. See the corresponding
776      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
777      * to learn more about how these ids are created.
778      *
779      * This function call must use less than 30 000 gas.
780      */
781     function supportsInterface(bytes4 interfaceId) external view returns (bool);
782 }
783 
784 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/interfaces/IERC2981.sol
785 
786 
787 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
788 
789 pragma solidity ^0.8.0;
790 
791 
792 /**
793  * @dev Interface for the NFT Royalty Standard.
794  *
795  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
796  * support for royalty payments across all NFT marketplaces and ecosystem participants.
797  *
798  * _Available since v4.5._
799  */
800 interface IERC2981 is IERC165 {
801     /**
802      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
803      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
804      */
805     function royaltyInfo(
806         uint256 tokenId,
807         uint256 salePrice
808     ) external view returns (address receiver, uint256 royaltyAmount);
809 }
810 
811 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
812 
813 
814 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
815 
816 pragma solidity ^0.8.0;
817 
818 
819 /**
820  * @dev Implementation of the {IERC165} interface.
821  *
822  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
823  * for the additional interface id that will be supported. For example:
824  *
825  * ```solidity
826  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
827  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
828  * }
829  * ```
830  *
831  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
832  */
833 abstract contract ERC165 is IERC165 {
834     /**
835      * @dev See {IERC165-supportsInterface}.
836      */
837     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
838         return interfaceId == type(IERC165).interfaceId;
839     }
840 }
841 
842 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/common/ERC2981.sol
843 
844 
845 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
846 
847 pragma solidity ^0.8.0;
848 
849 
850 
851 /**
852  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
853  *
854  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
855  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
856  *
857  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
858  * fee is specified in basis points by default.
859  *
860  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
861  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
862  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
863  *
864  * _Available since v4.5._
865  */
866 abstract contract ERC2981 is IERC2981, ERC165 {
867     struct RoyaltyInfo {
868         address receiver;
869         uint96 royaltyFraction;
870     }
871 
872     RoyaltyInfo private _defaultRoyaltyInfo;
873     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
874 
875     /**
876      * @dev See {IERC165-supportsInterface}.
877      */
878     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
879         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
880     }
881 
882     /**
883      * @inheritdoc IERC2981
884      */
885     function royaltyInfo(uint256 tokenId, uint256 salePrice) public view virtual override returns (address, uint256) {
886         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[tokenId];
887 
888         if (royalty.receiver == address(0)) {
889             royalty = _defaultRoyaltyInfo;
890         }
891 
892         uint256 royaltyAmount = (salePrice * royalty.royaltyFraction) / _feeDenominator();
893 
894         return (royalty.receiver, royaltyAmount);
895     }
896 
897     /**
898      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
899      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
900      * override.
901      */
902     function _feeDenominator() internal pure virtual returns (uint96) {
903         return 10000;
904     }
905 
906     /**
907      * @dev Sets the royalty information that all ids in this contract will default to.
908      *
909      * Requirements:
910      *
911      * - `receiver` cannot be the zero address.
912      * - `feeNumerator` cannot be greater than the fee denominator.
913      */
914     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
915         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
916         require(receiver != address(0), "ERC2981: invalid receiver");
917 
918         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
919     }
920 
921     /**
922      * @dev Removes default royalty information.
923      */
924     function _deleteDefaultRoyalty() internal virtual {
925         delete _defaultRoyaltyInfo;
926     }
927 
928     /**
929      * @dev Sets the royalty information for a specific token id, overriding the global default.
930      *
931      * Requirements:
932      *
933      * - `receiver` cannot be the zero address.
934      * - `feeNumerator` cannot be greater than the fee denominator.
935      */
936     function _setTokenRoyalty(uint256 tokenId, address receiver, uint96 feeNumerator) internal virtual {
937         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
938         require(receiver != address(0), "ERC2981: Invalid parameters");
939 
940         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
941     }
942 
943     /**
944      * @dev Resets royalty information for the token id back to the global default.
945      */
946     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
947         delete _tokenRoyaltyInfo[tokenId];
948     }
949 }
950 
951 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
952 
953 
954 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
955 
956 pragma solidity ^0.8.0;
957 
958 
959 /**
960  * @dev Required interface of an ERC721 compliant contract.
961  */
962 interface IERC721 is IERC165 {
963     /**
964      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
965      */
966     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
967 
968     /**
969      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
970      */
971     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
972 
973     /**
974      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
975      */
976     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
977 
978     /**
979      * @dev Returns the number of tokens in ``owner``'s account.
980      */
981     function balanceOf(address owner) external view returns (uint256 balance);
982 
983     /**
984      * @dev Returns the owner of the `tokenId` token.
985      *
986      * Requirements:
987      *
988      * - `tokenId` must exist.
989      */
990     function ownerOf(uint256 tokenId) external view returns (address owner);
991 
992     /**
993      * @dev Safely transfers `tokenId` token from `from` to `to`.
994      *
995      * Requirements:
996      *
997      * - `from` cannot be the zero address.
998      * - `to` cannot be the zero address.
999      * - `tokenId` token must exist and be owned by `from`.
1000      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1001      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function safeTransferFrom(
1006         address from,
1007         address to,
1008         uint256 tokenId,
1009         bytes calldata data
1010     ) external;
1011 
1012     /**
1013      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1014      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1015      *
1016      * Requirements:
1017      *
1018      * - `from` cannot be the zero address.
1019      * - `to` cannot be the zero address.
1020      * - `tokenId` token must exist and be owned by `from`.
1021      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1022      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1023      *
1024      * Emits a {Transfer} event.
1025      */
1026     function safeTransferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) external;
1031 
1032     /**
1033      * @dev Transfers `tokenId` token from `from` to `to`.
1034      *
1035      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1036      *
1037      * Requirements:
1038      *
1039      * - `from` cannot be the zero address.
1040      * - `to` cannot be the zero address.
1041      * - `tokenId` token must be owned by `from`.
1042      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1043      *
1044      * Emits a {Transfer} event.
1045      */
1046     function transferFrom(
1047         address from,
1048         address to,
1049         uint256 tokenId
1050     ) external;
1051 
1052     /**
1053      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1054      * The approval is cleared when the token is transferred.
1055      *
1056      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1057      *
1058      * Requirements:
1059      *
1060      * - The caller must own the token or be an approved operator.
1061      * - `tokenId` must exist.
1062      *
1063      * Emits an {Approval} event.
1064      */
1065     function approve(address to, uint256 tokenId) external;
1066 
1067     /**
1068      * @dev Approve or remove `operator` as an operator for the caller.
1069      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1070      *
1071      * Requirements:
1072      *
1073      * - The `operator` cannot be the caller.
1074      *
1075      * Emits an {ApprovalForAll} event.
1076      */
1077     function setApprovalForAll(address operator, bool _approved) external;
1078 
1079     /**
1080      * @dev Returns the account approved for `tokenId` token.
1081      *
1082      * Requirements:
1083      *
1084      * - `tokenId` must exist.
1085      */
1086     function getApproved(uint256 tokenId) external view returns (address operator);
1087 
1088     /**
1089      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1090      *
1091      * See {setApprovalForAll}
1092      */
1093     function isApprovedForAll(address owner, address operator) external view returns (bool);
1094 }
1095 
1096 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1097 
1098 
1099 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1100 
1101 pragma solidity ^0.8.0;
1102 
1103 
1104 /**
1105  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1106  * @dev See https://eips.ethereum.org/EIPS/eip-721
1107  */
1108 interface IERC721Enumerable is IERC721 {
1109     /**
1110      * @dev Returns the total amount of tokens stored by the contract.
1111      */
1112     function totalSupply() external view returns (uint256);
1113 
1114     /**
1115      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1116      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1117      */
1118     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1119 
1120     /**
1121      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1122      * Use along with {totalSupply} to enumerate all tokens.
1123      */
1124     function tokenByIndex(uint256 index) external view returns (uint256);
1125 }
1126 
1127 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1128 
1129 
1130 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1131 
1132 pragma solidity ^0.8.0;
1133 
1134 
1135 /**
1136  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1137  * @dev See https://eips.ethereum.org/EIPS/eip-721
1138  */
1139 interface IERC721Metadata is IERC721 {
1140     /**
1141      * @dev Returns the token collection name.
1142      */
1143     function name() external view returns (string memory);
1144 
1145     /**
1146      * @dev Returns the token collection symbol.
1147      */
1148     function symbol() external view returns (string memory);
1149 
1150     /**
1151      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1152      */
1153     function tokenURI(uint256 tokenId) external view returns (string memory);
1154 }
1155 
1156 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1157 
1158 
1159 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1160 
1161 pragma solidity ^0.8.0;
1162 
1163 
1164 
1165 
1166 
1167 
1168 
1169 
1170 /**
1171  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1172  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1173  * {ERC721Enumerable}.
1174  */
1175 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1176     using Address for address;
1177     using Strings for uint256;
1178 
1179     // Token name
1180     string private _name;
1181 
1182     // Token symbol
1183     string private _symbol;
1184 
1185     // Mapping from token ID to owner address
1186     mapping(uint256 => address) private _owners;
1187 
1188     // Mapping owner address to token count
1189     mapping(address => uint256) private _balances;
1190 
1191     // Mapping from token ID to approved address
1192     mapping(uint256 => address) private _tokenApprovals;
1193 
1194     // Mapping from owner to operator approvals
1195     mapping(address => mapping(address => bool)) private _operatorApprovals;
1196 
1197     /**
1198      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1199      */
1200     constructor(string memory name_, string memory symbol_) {
1201         _name = name_;
1202         _symbol = symbol_;
1203     }
1204 
1205     /**
1206      * @dev See {IERC165-supportsInterface}.
1207      */
1208     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1209         return
1210             interfaceId == type(IERC721).interfaceId ||
1211             interfaceId == type(IERC721Metadata).interfaceId ||
1212             super.supportsInterface(interfaceId);
1213     }
1214 
1215     /**
1216      * @dev See {IERC721-balanceOf}.
1217      */
1218     function balanceOf(address owner) public view virtual override returns (uint256) {
1219         require(owner != address(0), "ERC721: address zero is not a valid owner");
1220         return _balances[owner];
1221     }
1222 
1223     /**
1224      * @dev See {IERC721-ownerOf}.
1225      */
1226     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1227         address owner = _owners[tokenId];
1228         require(owner != address(0), "ERC721: invalid token ID");
1229         return owner;
1230     }
1231 
1232     /**
1233      * @dev See {IERC721Metadata-name}.
1234      */
1235     function name() public view virtual override returns (string memory) {
1236         return _name;
1237     }
1238 
1239     /**
1240      * @dev See {IERC721Metadata-symbol}.
1241      */
1242     function symbol() public view virtual override returns (string memory) {
1243         return _symbol;
1244     }
1245 
1246     /**
1247      * @dev See {IERC721Metadata-tokenURI}.
1248      */
1249     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1250         _requireMinted(tokenId);
1251 
1252         string memory baseURI = _baseURI();
1253         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1254     }
1255 
1256     /**
1257      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1258      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1259      * by default, can be overridden in child contracts.
1260      */
1261     function _baseURI() internal view virtual returns (string memory) {
1262         return "";
1263     }
1264 
1265     /**
1266      * @dev See {IERC721-approve}.
1267      */
1268     function approve(address to, uint256 tokenId) public virtual override {
1269         address owner = ERC721.ownerOf(tokenId);
1270         require(to != owner, "ERC721: approval to current owner");
1271 
1272         require(
1273             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1274             "ERC721: approve caller is not token owner or approved for all"
1275         );
1276 
1277         _approve(to, tokenId);
1278     }
1279 
1280     /**
1281      * @dev See {IERC721-getApproved}.
1282      */
1283     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1284         _requireMinted(tokenId);
1285 
1286         return _tokenApprovals[tokenId];
1287     }
1288 
1289     /**
1290      * @dev See {IERC721-setApprovalForAll}.
1291      */
1292     function setApprovalForAll(address operator, bool approved) public virtual override {
1293         _setApprovalForAll(_msgSender(), operator, approved);
1294     }
1295 
1296     /**
1297      * @dev See {IERC721-isApprovedForAll}.
1298      */
1299     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1300         return _operatorApprovals[owner][operator];
1301     }
1302 
1303     /**
1304      * @dev See {IERC721-transferFrom}.
1305      */
1306     function transferFrom(
1307         address from,
1308         address to,
1309         uint256 tokenId
1310     ) public virtual override {
1311         //solhint-disable-next-line max-line-length
1312         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1313 
1314         _transfer(from, to, tokenId);
1315     }
1316 
1317     /**
1318      * @dev See {IERC721-safeTransferFrom}.
1319      */
1320     function safeTransferFrom(
1321         address from,
1322         address to,
1323         uint256 tokenId
1324     ) public virtual override {
1325         safeTransferFrom(from, to, tokenId, "");
1326     }
1327 
1328     /**
1329      * @dev See {IERC721-safeTransferFrom}.
1330      */
1331     function safeTransferFrom(
1332         address from,
1333         address to,
1334         uint256 tokenId,
1335         bytes memory data
1336     ) public virtual override {
1337         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1338         _safeTransfer(from, to, tokenId, data);
1339     }
1340 
1341     /**
1342      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1343      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1344      *
1345      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1346      *
1347      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1348      * implement alternative mechanisms to perform token transfer, such as signature-based.
1349      *
1350      * Requirements:
1351      *
1352      * - `from` cannot be the zero address.
1353      * - `to` cannot be the zero address.
1354      * - `tokenId` token must exist and be owned by `from`.
1355      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1356      *
1357      * Emits a {Transfer} event.
1358      */
1359     function _safeTransfer(
1360         address from,
1361         address to,
1362         uint256 tokenId,
1363         bytes memory data
1364     ) internal virtual {
1365         _transfer(from, to, tokenId);
1366         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1367     }
1368 
1369     /**
1370      * @dev Returns whether `tokenId` exists.
1371      *
1372      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1373      *
1374      * Tokens start existing when they are minted (`_mint`),
1375      * and stop existing when they are burned (`_burn`).
1376      */
1377     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1378         return _owners[tokenId] != address(0);
1379     }
1380 
1381     /**
1382      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1383      *
1384      * Requirements:
1385      *
1386      * - `tokenId` must exist.
1387      */
1388     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1389         address owner = ERC721.ownerOf(tokenId);
1390         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1391     }
1392 
1393     /**
1394      * @dev Safely mints `tokenId` and transfers it to `to`.
1395      *
1396      * Requirements:
1397      *
1398      * - `tokenId` must not exist.
1399      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1400      *
1401      * Emits a {Transfer} event.
1402      */
1403     function _safeMint(address to, uint256 tokenId) internal virtual {
1404         _safeMint(to, tokenId, "");
1405     }
1406 
1407     /**
1408      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1409      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1410      */
1411     function _safeMint(
1412         address to,
1413         uint256 tokenId,
1414         bytes memory data
1415     ) internal virtual {
1416         _mint(to, tokenId);
1417         require(
1418             _checkOnERC721Received(address(0), to, tokenId, data),
1419             "ERC721: transfer to non ERC721Receiver implementer"
1420         );
1421     }
1422 
1423     /**
1424      * @dev Mints `tokenId` and transfers it to `to`.
1425      *
1426      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1427      *
1428      * Requirements:
1429      *
1430      * - `tokenId` must not exist.
1431      * - `to` cannot be the zero address.
1432      *
1433      * Emits a {Transfer} event.
1434      */
1435     function _mint(address to, uint256 tokenId) internal virtual {
1436         require(to != address(0), "ERC721: mint to the zero address");
1437         require(!_exists(tokenId), "ERC721: token already minted");
1438 
1439         _beforeTokenTransfer(address(0), to, tokenId);
1440 
1441         _balances[to] += 1;
1442         _owners[tokenId] = to;
1443 
1444         emit Transfer(address(0), to, tokenId);
1445 
1446         _afterTokenTransfer(address(0), to, tokenId);
1447     }
1448 
1449     /**
1450      * @dev Destroys `tokenId`.
1451      * The approval is cleared when the token is burned.
1452      * This is an internal function that does not check if the sender is authorized to operate on the token.
1453      *
1454      * Requirements:
1455      *
1456      * - `tokenId` must exist.
1457      *
1458      * Emits a {Transfer} event.
1459      */
1460     function _burn(uint256 tokenId) internal virtual {
1461         address owner = ERC721.ownerOf(tokenId);
1462 
1463         _beforeTokenTransfer(owner, address(0), tokenId);
1464 
1465         // Clear approvals
1466         delete _tokenApprovals[tokenId];
1467 
1468         _balances[owner] -= 1;
1469         delete _owners[tokenId];
1470 
1471         emit Transfer(owner, address(0), tokenId);
1472 
1473         _afterTokenTransfer(owner, address(0), tokenId);
1474     }
1475 
1476     /**
1477      * @dev Transfers `tokenId` from `from` to `to`.
1478      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1479      *
1480      * Requirements:
1481      *
1482      * - `to` cannot be the zero address.
1483      * - `tokenId` token must be owned by `from`.
1484      *
1485      * Emits a {Transfer} event.
1486      */
1487     function _transfer(
1488         address from,
1489         address to,
1490         uint256 tokenId
1491     ) internal virtual {
1492         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1493         require(to != address(0), "ERC721: transfer to the zero address");
1494 
1495         _beforeTokenTransfer(from, to, tokenId);
1496 
1497         // Clear approvals from the previous owner
1498         delete _tokenApprovals[tokenId];
1499 
1500         _balances[from] -= 1;
1501         _balances[to] += 1;
1502         _owners[tokenId] = to;
1503 
1504         emit Transfer(from, to, tokenId);
1505 
1506         _afterTokenTransfer(from, to, tokenId);
1507     }
1508 
1509     /**
1510      * @dev Approve `to` to operate on `tokenId`
1511      *
1512      * Emits an {Approval} event.
1513      */
1514     function _approve(address to, uint256 tokenId) internal virtual {
1515         _tokenApprovals[tokenId] = to;
1516         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1517     }
1518 
1519     /**
1520      * @dev Approve `operator` to operate on all of `owner` tokens
1521      *
1522      * Emits an {ApprovalForAll} event.
1523      */
1524     function _setApprovalForAll(
1525         address owner,
1526         address operator,
1527         bool approved
1528     ) internal virtual {
1529         require(owner != operator, "ERC721: approve to caller");
1530         _operatorApprovals[owner][operator] = approved;
1531         emit ApprovalForAll(owner, operator, approved);
1532     }
1533 
1534     /**
1535      * @dev Reverts if the `tokenId` has not been minted yet.
1536      */
1537     function _requireMinted(uint256 tokenId) internal view virtual {
1538         require(_exists(tokenId), "ERC721: invalid token ID");
1539     }
1540 
1541     /**
1542      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1543      * The call is not executed if the target address is not a contract.
1544      *
1545      * @param from address representing the previous owner of the given token ID
1546      * @param to target address that will receive the tokens
1547      * @param tokenId uint256 ID of the token to be transferred
1548      * @param data bytes optional data to send along with the call
1549      * @return bool whether the call correctly returned the expected magic value
1550      */
1551     function _checkOnERC721Received(
1552         address from,
1553         address to,
1554         uint256 tokenId,
1555         bytes memory data
1556     ) private returns (bool) {
1557         if (to.isContract()) {
1558             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1559                 return retval == IERC721Receiver.onERC721Received.selector;
1560             } catch (bytes memory reason) {
1561                 if (reason.length == 0) {
1562                     revert("ERC721: transfer to non ERC721Receiver implementer");
1563                 } else {
1564                     /// @solidity memory-safe-assembly
1565                     assembly {
1566                         revert(add(32, reason), mload(reason))
1567                     }
1568                 }
1569             }
1570         } else {
1571             return true;
1572         }
1573     }
1574 
1575     /**
1576      * @dev Hook that is called before any token transfer. This includes minting
1577      * and burning.
1578      *
1579      * Calling conditions:
1580      *
1581      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1582      * transferred to `to`.
1583      * - When `from` is zero, `tokenId` will be minted for `to`.
1584      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1585      * - `from` and `to` are never both zero.
1586      *
1587      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1588      */
1589     function _beforeTokenTransfer(
1590         address from,
1591         address to,
1592         uint256 tokenId
1593     ) internal virtual {}
1594 
1595     /**
1596      * @dev Hook that is called after any transfer of tokens. This includes
1597      * minting and burning.
1598      *
1599      * Calling conditions:
1600      *
1601      * - when `from` and `to` are both non-zero.
1602      * - `from` and `to` are never both zero.
1603      *
1604      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1605      */
1606     function _afterTokenTransfer(
1607         address from,
1608         address to,
1609         uint256 tokenId
1610     ) internal virtual {}
1611 }
1612 
1613 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1614 
1615 
1616 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1617 
1618 pragma solidity ^0.8.0;
1619 
1620 
1621 
1622 /**
1623  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1624  * enumerability of all the token ids in the contract as well as all token ids owned by each
1625  * account.
1626  */
1627 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1628     // Mapping from owner to list of owned token IDs
1629     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1630 
1631     // Mapping from token ID to index of the owner tokens list
1632     mapping(uint256 => uint256) private _ownedTokensIndex;
1633 
1634     // Array with all token ids, used for enumeration
1635     uint256[] private _allTokens;
1636 
1637     // Mapping from token id to position in the allTokens array
1638     mapping(uint256 => uint256) private _allTokensIndex;
1639 
1640     /**
1641      * @dev See {IERC165-supportsInterface}.
1642      */
1643     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1644         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1645     }
1646 
1647     /**
1648      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1649      */
1650     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1651         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1652         return _ownedTokens[owner][index];
1653     }
1654 
1655     /**
1656      * @dev See {IERC721Enumerable-totalSupply}.
1657      */
1658     function totalSupply() public view virtual override returns (uint256) {
1659         return _allTokens.length;
1660     }
1661 
1662     /**
1663      * @dev See {IERC721Enumerable-tokenByIndex}.
1664      */
1665     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1666         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1667         return _allTokens[index];
1668     }
1669 
1670     /**
1671      * @dev Hook that is called before any token transfer. This includes minting
1672      * and burning.
1673      *
1674      * Calling conditions:
1675      *
1676      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1677      * transferred to `to`.
1678      * - When `from` is zero, `tokenId` will be minted for `to`.
1679      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1680      * - `from` cannot be the zero address.
1681      * - `to` cannot be the zero address.
1682      *
1683      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1684      */
1685     function _beforeTokenTransfer(
1686         address from,
1687         address to,
1688         uint256 tokenId
1689     ) internal virtual override {
1690         super._beforeTokenTransfer(from, to, tokenId);
1691 
1692         if (from == address(0)) {
1693             _addTokenToAllTokensEnumeration(tokenId);
1694         } else if (from != to) {
1695             _removeTokenFromOwnerEnumeration(from, tokenId);
1696         }
1697         if (to == address(0)) {
1698             _removeTokenFromAllTokensEnumeration(tokenId);
1699         } else if (to != from) {
1700             _addTokenToOwnerEnumeration(to, tokenId);
1701         }
1702     }
1703 
1704     /**
1705      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1706      * @param to address representing the new owner of the given token ID
1707      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1708      */
1709     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1710         uint256 length = ERC721.balanceOf(to);
1711         _ownedTokens[to][length] = tokenId;
1712         _ownedTokensIndex[tokenId] = length;
1713     }
1714 
1715     /**
1716      * @dev Private function to add a token to this extension's token tracking data structures.
1717      * @param tokenId uint256 ID of the token to be added to the tokens list
1718      */
1719     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1720         _allTokensIndex[tokenId] = _allTokens.length;
1721         _allTokens.push(tokenId);
1722     }
1723 
1724     /**
1725      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1726      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1727      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1728      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1729      * @param from address representing the previous owner of the given token ID
1730      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1731      */
1732     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1733         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1734         // then delete the last slot (swap and pop).
1735 
1736         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1737         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1738 
1739         // When the token to delete is the last token, the swap operation is unnecessary
1740         if (tokenIndex != lastTokenIndex) {
1741             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1742 
1743             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1744             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1745         }
1746 
1747         // This also deletes the contents at the last position of the array
1748         delete _ownedTokensIndex[tokenId];
1749         delete _ownedTokens[from][lastTokenIndex];
1750     }
1751 
1752     /**
1753      * @dev Private function to remove a token from this extension's token tracking data structures.
1754      * This has O(1) time complexity, but alters the order of the _allTokens array.
1755      * @param tokenId uint256 ID of the token to be removed from the tokens list
1756      */
1757     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1758         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1759         // then delete the last slot (swap and pop).
1760 
1761         uint256 lastTokenIndex = _allTokens.length - 1;
1762         uint256 tokenIndex = _allTokensIndex[tokenId];
1763 
1764         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1765         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1766         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1767         uint256 lastTokenId = _allTokens[lastTokenIndex];
1768 
1769         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1770         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1771 
1772         // This also deletes the contents at the last position of the array
1773         delete _allTokensIndex[tokenId];
1774         _allTokens.pop();
1775     }
1776 }
1777 
1778 // File: contracts/assets/IERC721A.sol
1779 
1780 
1781 // ERC721A Contracts v4.2.0
1782 // Creator: Chiru Labs
1783 
1784 pragma solidity ^0.8.4;
1785 
1786 /**
1787  * @dev Interface of ERC721A.
1788  */
1789 interface IERC721A {
1790     /**
1791      * The caller must own the token or be an approved operator.
1792      */
1793     error ApprovalCallerNotOwnerNorApproved();
1794 
1795     /**
1796      * The token does not exist.
1797      */
1798     error ApprovalQueryForNonexistentToken();
1799 
1800     /**
1801      * The caller cannot approve to their own address.
1802      */
1803     error ApproveToCaller();
1804 
1805     /**
1806      * Cannot query the balance for the zero address.
1807      */
1808     error BalanceQueryForZeroAddress();
1809 
1810     /**
1811      * Cannot mint to the zero address.
1812      */
1813     error MintToZeroAddress();
1814 
1815     /**
1816      * The quantity of tokens minted must be more than zero.
1817      */
1818     error MintZeroQuantity();
1819 
1820     /**
1821      * The token does not exist.
1822      */
1823     error OwnerQueryForNonexistentToken();
1824 
1825     /**
1826      * The caller must own the token or be an approved operator.
1827      */
1828     error TransferCallerNotOwnerNorApproved();
1829 
1830     /**
1831      * The token must be owned by `from`.
1832      */
1833     error TransferFromIncorrectOwner();
1834 
1835     /**
1836      * Cannot safely transfer to a contract that does not implement the
1837      * ERC721Receiver interface.
1838      */
1839     error TransferToNonERC721ReceiverImplementer();
1840 
1841     /**
1842      * Cannot transfer to the zero address.
1843      */
1844     error TransferToZeroAddress();
1845 
1846     /**
1847      * The token does not exist.
1848      */
1849     error URIQueryForNonexistentToken();
1850 
1851     /**
1852      * The `quantity` minted with ERC2309 exceeds the safety limit.
1853      */
1854     error MintERC2309QuantityExceedsLimit();
1855 
1856     /**
1857      * The `extraData` cannot be set on an unintialized ownership slot.
1858      */
1859     error OwnershipNotInitializedForExtraData();
1860 
1861     // =============================================================
1862     //                            STRUCTS
1863     // =============================================================
1864 
1865     struct TokenOwnership {
1866         // The address of the owner.
1867         address addr;
1868         // Stores the start time of ownership with minimal overhead for tokenomics.
1869         uint64 startTimestamp;
1870         // Whether the token has been burned.
1871         bool burned;
1872         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1873         uint24 extraData;
1874     }
1875 
1876     // =============================================================
1877     //                         TOKEN COUNTERS
1878     // =============================================================
1879 
1880     /**
1881      * @dev Returns the total number of tokens in existence.
1882      * Burned tokens will reduce the count.
1883      * To get the total number of tokens minted, please see {_totalMinted}.
1884      */
1885     function totalSupply() external view returns (uint256);
1886 
1887     // =============================================================
1888     //                            IERC165
1889     // =============================================================
1890 
1891     /**
1892      * @dev Returns true if this contract implements the interface defined by
1893      * `interfaceId`. See the corresponding
1894      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1895      * to learn more about how these ids are created.
1896      *
1897      * This function call must use less than 30000 gas.
1898      */
1899     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1900 
1901     // =============================================================
1902     //                            IERC721
1903     // =============================================================
1904 
1905     /**
1906      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1907      */
1908     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1909 
1910     /**
1911      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1912      */
1913     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1914 
1915     /**
1916      * @dev Emitted when `owner` enables or disables
1917      * (`approved`) `operator` to manage all of its assets.
1918      */
1919     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1920 
1921     /**
1922      * @dev Returns the number of tokens in `owner`'s account.
1923      */
1924     function balanceOf(address owner) external view returns (uint256 balance);
1925 
1926     /**
1927      * @dev Returns the owner of the `tokenId` token.
1928      *
1929      * Requirements:
1930      *
1931      * - `tokenId` must exist.
1932      */
1933     function ownerOf(uint256 tokenId) external view returns (address owner);
1934 
1935     /**
1936      * @dev Safely transfers `tokenId` token from `from` to `to`,
1937      * checking first that contract recipients are aware of the ERC721 protocol
1938      * to prevent tokens from being forever locked.
1939      *
1940      * Requirements:
1941      *
1942      * - `from` cannot be the zero address.
1943      * - `to` cannot be the zero address.
1944      * - `tokenId` token must exist and be owned by `from`.
1945      * - If the caller is not `from`, it must be have been allowed to move
1946      * this token by either {approve} or {setApprovalForAll}.
1947      * - If `to` refers to a smart contract, it must implement
1948      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1949      *
1950      * Emits a {Transfer} event.
1951      */
1952     function safeTransferFrom(
1953         address from,
1954         address to,
1955         uint256 tokenId,
1956         bytes calldata data
1957     ) external;
1958 
1959     /**
1960      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1961      */
1962     function safeTransferFrom(
1963         address from,
1964         address to,
1965         uint256 tokenId
1966     ) external;
1967 
1968     /**
1969      * @dev Transfers `tokenId` from `from` to `to`.
1970      *
1971      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1972      * whenever possible.
1973      *
1974      * Requirements:
1975      *
1976      * - `from` cannot be the zero address.
1977      * - `to` cannot be the zero address.
1978      * - `tokenId` token must be owned by `from`.
1979      * - If the caller is not `from`, it must be approved to move this token
1980      * by either {approve} or {setApprovalForAll}.
1981      *
1982      * Emits a {Transfer} event.
1983      */
1984     function transferFrom(
1985         address from,
1986         address to,
1987         uint256 tokenId
1988     ) external;
1989 
1990     /**
1991      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1992      * The approval is cleared when the token is transferred.
1993      *
1994      * Only a single account can be approved at a time, so approving the
1995      * zero address clears previous approvals.
1996      *
1997      * Requirements:
1998      *
1999      * - The caller must own the token or be an approved operator.
2000      * - `tokenId` must exist.
2001      *
2002      * Emits an {Approval} event.
2003      */
2004     function approve(address to, uint256 tokenId) external;
2005 
2006     /**
2007      * @dev Approve or remove `operator` as an operator for the caller.
2008      * Operators can call {transferFrom} or {safeTransferFrom}
2009      * for any token owned by the caller.
2010      *
2011      * Requirements:
2012      *
2013      * - The `operator` cannot be the caller.
2014      *
2015      * Emits an {ApprovalForAll} event.
2016      */
2017     function setApprovalForAll(address operator, bool _approved) external;
2018 
2019     /**
2020      * @dev Returns the account approved for `tokenId` token.
2021      *
2022      * Requirements:
2023      *
2024      * - `tokenId` must exist.
2025      */
2026     function getApproved(uint256 tokenId) external view returns (address operator);
2027 
2028     /**
2029      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2030      *
2031      * See {setApprovalForAll}.
2032      */
2033     function isApprovedForAll(address owner, address operator) external view returns (bool);
2034 
2035     // =============================================================
2036     //                        IERC721Metadata
2037     // =============================================================
2038 
2039     /**
2040      * @dev Returns the token collection name.
2041      */
2042     function name() external view returns (string memory);
2043 
2044     /**
2045      * @dev Returns the token collection symbol.
2046      */
2047     function symbol() external view returns (string memory);
2048 
2049     /**
2050      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2051      */
2052     function tokenURI(uint256 tokenId) external view returns (string memory);
2053 
2054     // =============================================================
2055     //                           IERC2309
2056     // =============================================================
2057 
2058     /**
2059      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
2060      * (inclusive) is transferred from `from` to `to`, as defined in the
2061      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
2062      *
2063      * See {_mintERC2309} for more details.
2064      */
2065     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
2066 }
2067 // File: contracts/assets/ERC721A.sol
2068 
2069 
2070 // ERC721A Contracts v4.2.0
2071 // Creator: Chiru Labs
2072 
2073 pragma solidity ^0.8.4;
2074 
2075 
2076 /**
2077  * @dev Interface of ERC721 token receiver.
2078  */
2079 interface ERC721A__IERC721Receiver {
2080     function onERC721Received(
2081         address operator,
2082         address from,
2083         uint256 tokenId,
2084         bytes calldata data
2085     ) external returns (bytes4);
2086 }
2087 
2088 /**
2089  * @title ERC721A
2090  *
2091  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
2092  * Non-Fungible Token Standard, including the Metadata extension.
2093  * Optimized for lower gas during batch mints.
2094  *
2095  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
2096  * starting from `_startTokenId()`.
2097  *
2098  * Assumptions:
2099  *
2100  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
2101  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
2102  */
2103 contract ERC721A is IERC721A {
2104     // Reference type for token approval.
2105     struct TokenApprovalRef {
2106         address value;
2107     }
2108 
2109     // =============================================================
2110     //                           CONSTANTS
2111     // =============================================================
2112 
2113     // Mask of an entry in packed address data.
2114     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
2115 
2116     // The bit position of `numberMinted` in packed address data.
2117     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
2118 
2119     // The bit position of `numberBurned` in packed address data.
2120     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
2121 
2122     // The bit position of `aux` in packed address data.
2123     uint256 private constant _BITPOS_AUX = 192;
2124 
2125     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
2126     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
2127 
2128     // The bit position of `startTimestamp` in packed ownership.
2129     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
2130 
2131     // The bit mask of the `burned` bit in packed ownership.
2132     uint256 private constant _BITMASK_BURNED = 1 << 224;
2133 
2134     // The bit position of the `nextInitialized` bit in packed ownership.
2135     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
2136 
2137     // The bit mask of the `nextInitialized` bit in packed ownership.
2138     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
2139 
2140     // The bit position of `extraData` in packed ownership.
2141     uint256 private constant _BITPOS_EXTRA_DATA = 232;
2142 
2143     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
2144     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
2145 
2146     // The mask of the lower 160 bits for addresses.
2147     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
2148 
2149     // The maximum `quantity` that can be minted with {_mintERC2309}.
2150     // This limit is to prevent overflows on the address data entries.
2151     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
2152     // is required to cause an overflow, which is unrealistic.
2153     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
2154 
2155     // The `Transfer` event signature is given by:
2156     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
2157     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
2158         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
2159 
2160     // =============================================================
2161     //                            STORAGE
2162     // =============================================================
2163 
2164     // The next token ID to be minted.
2165     uint256 private _currentIndex;
2166 
2167     // The number of tokens burned.
2168     uint256 private _burnCounter;
2169 
2170     // Token name
2171     string private _name;
2172 
2173     // Token symbol
2174     string private _symbol;
2175 
2176     // Mapping from token ID to ownership details
2177     // An empty struct value does not necessarily mean the token is unowned.
2178     // See {_packedOwnershipOf} implementation for details.
2179     //
2180     // Bits Layout:
2181     // - [0..159]   `addr`
2182     // - [160..223] `startTimestamp`
2183     // - [224]      `burned`
2184     // - [225]      `nextInitialized`
2185     // - [232..255] `extraData`
2186     mapping(uint256 => uint256) private _packedOwnerships;
2187 
2188     // Mapping owner address to address data.
2189     //
2190     // Bits Layout:
2191     // - [0..63]    `balance`
2192     // - [64..127]  `numberMinted`
2193     // - [128..191] `numberBurned`
2194     // - [192..255] `aux`
2195     mapping(address => uint256) private _packedAddressData;
2196 
2197     // Mapping from token ID to approved address.
2198     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
2199 
2200     // Mapping from owner to operator approvals
2201     mapping(address => mapping(address => bool)) private _operatorApprovals;
2202 
2203     // =============================================================
2204     //                          CONSTRUCTOR
2205     // =============================================================
2206 
2207     constructor(string memory name_, string memory symbol_) {
2208         _name = name_;
2209         _symbol = symbol_;
2210         _currentIndex = _startTokenId();
2211     }
2212 
2213     // =============================================================
2214     //                   TOKEN COUNTING OPERATIONS
2215     // =============================================================
2216 
2217     /**
2218      * @dev Returns the starting token ID.
2219      * To change the starting token ID, please override this function.
2220      */
2221     function _startTokenId() internal view virtual returns (uint256) {
2222         return 0;
2223     }
2224 
2225     /**
2226      * @dev Returns the next token ID to be minted.
2227      */
2228     function _nextTokenId() internal view virtual returns (uint256) {
2229         return _currentIndex;
2230     }
2231 
2232     /**
2233      * @dev Returns the total number of tokens in existence.
2234      * Burned tokens will reduce the count.
2235      * To get the total number of tokens minted, please see {_totalMinted}.
2236      */
2237     function totalSupply() public view virtual override returns (uint256) {
2238         // Counter underflow is impossible as _burnCounter cannot be incremented
2239         // more than `_currentIndex - _startTokenId()` times.
2240         unchecked {
2241             return _currentIndex - _burnCounter - _startTokenId();
2242         }
2243     }
2244 
2245     /**
2246      * @dev Returns the total amount of tokens minted in the contract.
2247      */
2248     function _totalMinted() internal view virtual returns (uint256) {
2249         // Counter underflow is impossible as `_currentIndex` does not decrement,
2250         // and it is initialized to `_startTokenId()`.
2251         unchecked {
2252             return _currentIndex - _startTokenId();
2253         }
2254     }
2255 
2256     /**
2257      * @dev Returns the total number of tokens burned.
2258      */
2259     function _totalBurned() internal view virtual returns (uint256) {
2260         return _burnCounter;
2261     }
2262 
2263     // =============================================================
2264     //                    ADDRESS DATA OPERATIONS
2265     // =============================================================
2266 
2267     /**
2268      * @dev Returns the number of tokens in `owner`'s account.
2269      */
2270     function balanceOf(address owner) public view virtual override returns (uint256) {
2271         if (owner == address(0)) revert BalanceQueryForZeroAddress();
2272         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
2273     }
2274 
2275     /**
2276      * Returns the number of tokens minted by `owner`.
2277      */
2278     function _numberMinted(address owner) internal view returns (uint256) {
2279         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
2280     }
2281 
2282     /**
2283      * Returns the number of tokens burned by or on behalf of `owner`.
2284      */
2285     function _numberBurned(address owner) internal view returns (uint256) {
2286         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
2287     }
2288 
2289     /**
2290      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
2291      */
2292     function _getAux(address owner) internal view returns (uint64) {
2293         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
2294     }
2295 
2296     /**
2297      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
2298      * If there are multiple variables, please pack them into a uint64.
2299      */
2300     function _setAux(address owner, uint64 aux) internal virtual {
2301         uint256 packed = _packedAddressData[owner];
2302         uint256 auxCasted;
2303         // Cast `aux` with assembly to avoid redundant masking.
2304         assembly {
2305             auxCasted := aux
2306         }
2307         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
2308         _packedAddressData[owner] = packed;
2309     }
2310 
2311     // =============================================================
2312     //                            IERC165
2313     // =============================================================
2314 
2315     /**
2316      * @dev Returns true if this contract implements the interface defined by
2317      * `interfaceId`. See the corresponding
2318      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
2319      * to learn more about how these ids are created.
2320      *
2321      * This function call must use less than 30000 gas.
2322      */
2323     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2324         // The interface IDs are constants representing the first 4 bytes
2325         // of the XOR of all function selectors in the interface.
2326         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
2327         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
2328         return
2329             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
2330             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
2331             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
2332     }
2333 
2334     // =============================================================
2335     //                        IERC721Metadata
2336     // =============================================================
2337 
2338     /**
2339      * @dev Returns the token collection name.
2340      */
2341     function name() public view virtual override returns (string memory) {
2342         return _name;
2343     }
2344 
2345     /**
2346      * @dev Returns the token collection symbol.
2347      */
2348     function symbol() public view virtual override returns (string memory) {
2349         return _symbol;
2350     }
2351 
2352     /**
2353      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2354      */
2355     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2356         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2357 
2358         string memory baseURI = _baseURI();
2359         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
2360     }
2361 
2362     /**
2363      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2364      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2365      * by default, it can be overridden in child contracts.
2366      */
2367     function _baseURI() internal view virtual returns (string memory) {
2368         return '';
2369     }
2370 
2371     // =============================================================
2372     //                     OWNERSHIPS OPERATIONS
2373     // =============================================================
2374 
2375     /**
2376      * @dev Returns the owner of the `tokenId` token.
2377      *
2378      * Requirements:
2379      *
2380      * - `tokenId` must exist.
2381      */
2382     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2383         return address(uint160(_packedOwnershipOf(tokenId)));
2384     }
2385 
2386     /**
2387      * @dev Gas spent here starts off proportional to the maximum mint batch size.
2388      * It gradually moves to O(1) as tokens get transferred around over time.
2389      */
2390     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
2391         return _unpackedOwnership(_packedOwnershipOf(tokenId));
2392     }
2393 
2394     /**
2395      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
2396      */
2397     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
2398         return _unpackedOwnership(_packedOwnerships[index]);
2399     }
2400 
2401     /**
2402      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
2403      */
2404     function _initializeOwnershipAt(uint256 index) internal virtual {
2405         if (_packedOwnerships[index] == 0) {
2406             _packedOwnerships[index] = _packedOwnershipOf(index);
2407         }
2408     }
2409 
2410     /**
2411      * Returns the packed ownership data of `tokenId`.
2412      */
2413     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
2414         uint256 curr = tokenId;
2415 
2416         unchecked {
2417             if (_startTokenId() <= curr)
2418                 if (curr < _currentIndex) {
2419                     uint256 packed = _packedOwnerships[curr];
2420                     // If not burned.
2421                     if (packed & _BITMASK_BURNED == 0) {
2422                         // Invariant:
2423                         // There will always be an initialized ownership slot
2424                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
2425                         // before an unintialized ownership slot
2426                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
2427                         // Hence, `curr` will not underflow.
2428                         //
2429                         // We can directly compare the packed value.
2430                         // If the address is zero, packed will be zero.
2431                         while (packed == 0) {
2432                             packed = _packedOwnerships[--curr];
2433                         }
2434                         return packed;
2435                     }
2436                 }
2437         }
2438         revert OwnerQueryForNonexistentToken();
2439     }
2440 
2441     /**
2442      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
2443      */
2444     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
2445         ownership.addr = address(uint160(packed));
2446         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
2447         ownership.burned = packed & _BITMASK_BURNED != 0;
2448         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
2449     }
2450 
2451     /**
2452      * @dev Packs ownership data into a single uint256.
2453      */
2454     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
2455         assembly {
2456             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2457             owner := and(owner, _BITMASK_ADDRESS)
2458             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
2459             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
2460         }
2461     }
2462 
2463     /**
2464      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
2465      */
2466     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
2467         // For branchless setting of the `nextInitialized` flag.
2468         assembly {
2469             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
2470             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
2471         }
2472     }
2473 
2474     // =============================================================
2475     //                      APPROVAL OPERATIONS
2476     // =============================================================
2477 
2478     /**
2479      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2480      * The approval is cleared when the token is transferred.
2481      *
2482      * Only a single account can be approved at a time, so approving the
2483      * zero address clears previous approvals.
2484      *
2485      * Requirements:
2486      *
2487      * - The caller must own the token or be an approved operator.
2488      * - `tokenId` must exist.
2489      *
2490      * Emits an {Approval} event.
2491      */
2492     function approve(address to, uint256 tokenId) public virtual override {
2493         address owner = ownerOf(tokenId);
2494 
2495         if (_msgSenderERC721A() != owner)
2496             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2497                 revert ApprovalCallerNotOwnerNorApproved();
2498             }
2499 
2500         _tokenApprovals[tokenId].value = to;
2501         emit Approval(owner, to, tokenId);
2502     }
2503 
2504     /**
2505      * @dev Returns the account approved for `tokenId` token.
2506      *
2507      * Requirements:
2508      *
2509      * - `tokenId` must exist.
2510      */
2511     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2512         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2513 
2514         return _tokenApprovals[tokenId].value;
2515     }
2516 
2517     /**
2518      * @dev Approve or remove `operator` as an operator for the caller.
2519      * Operators can call {transferFrom} or {safeTransferFrom}
2520      * for any token owned by the caller.
2521      *
2522      * Requirements:
2523      *
2524      * - The `operator` cannot be the caller.
2525      *
2526      * Emits an {ApprovalForAll} event.
2527      */
2528     function setApprovalForAll(address operator, bool approved) public virtual override {
2529         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
2530 
2531         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2532         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2533     }
2534 
2535     /**
2536      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2537      *
2538      * See {setApprovalForAll}.
2539      */
2540     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2541         return _operatorApprovals[owner][operator];
2542     }
2543 
2544     /**
2545      * @dev Returns whether `tokenId` exists.
2546      *
2547      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2548      *
2549      * Tokens start existing when they are minted. See {_mint}.
2550      */
2551     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2552         return
2553             _startTokenId() <= tokenId &&
2554             tokenId < _currentIndex && // If within bounds,
2555             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
2556     }
2557 
2558     /**
2559      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
2560      */
2561     function _isSenderApprovedOrOwner(
2562         address approvedAddress,
2563         address owner,
2564         address msgSender
2565     ) private pure returns (bool result) {
2566         assembly {
2567             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2568             owner := and(owner, _BITMASK_ADDRESS)
2569             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2570             msgSender := and(msgSender, _BITMASK_ADDRESS)
2571             // `msgSender == owner || msgSender == approvedAddress`.
2572             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2573         }
2574     }
2575 
2576     /**
2577      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2578      */
2579     function _getApprovedSlotAndAddress(uint256 tokenId)
2580         private
2581         view
2582         returns (uint256 approvedAddressSlot, address approvedAddress)
2583     {
2584         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2585         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
2586         assembly {
2587             approvedAddressSlot := tokenApproval.slot
2588             approvedAddress := sload(approvedAddressSlot)
2589         }
2590     }
2591 
2592     // =============================================================
2593     //                      TRANSFER OPERATIONS
2594     // =============================================================
2595 
2596     /**
2597      * @dev Transfers `tokenId` from `from` to `to`.
2598      *
2599      * Requirements:
2600      *
2601      * - `from` cannot be the zero address.
2602      * - `to` cannot be the zero address.
2603      * - `tokenId` token must be owned by `from`.
2604      * - If the caller is not `from`, it must be approved to move this token
2605      * by either {approve} or {setApprovalForAll}.
2606      *
2607      * Emits a {Transfer} event.
2608      */
2609     function transferFrom(
2610         address from,
2611         address to,
2612         uint256 tokenId
2613     ) public virtual override {
2614         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2615 
2616         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2617 
2618         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2619 
2620         // The nested ifs save around 20+ gas over a compound boolean condition.
2621         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2622             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2623 
2624         if (to == address(0)) revert TransferToZeroAddress();
2625 
2626         _beforeTokenTransfers(from, to, tokenId, 1);
2627 
2628         // Clear approvals from the previous owner.
2629         assembly {
2630             if approvedAddress {
2631                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2632                 sstore(approvedAddressSlot, 0)
2633             }
2634         }
2635 
2636         // Underflow of the sender's balance is impossible because we check for
2637         // ownership above and the recipient's balance can't realistically overflow.
2638         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2639         unchecked {
2640             // We can directly increment and decrement the balances.
2641             --_packedAddressData[from]; // Updates: `balance -= 1`.
2642             ++_packedAddressData[to]; // Updates: `balance += 1`.
2643 
2644             // Updates:
2645             // - `address` to the next owner.
2646             // - `startTimestamp` to the timestamp of transfering.
2647             // - `burned` to `false`.
2648             // - `nextInitialized` to `true`.
2649             _packedOwnerships[tokenId] = _packOwnershipData(
2650                 to,
2651                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2652             );
2653 
2654             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2655             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2656                 uint256 nextTokenId = tokenId + 1;
2657                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2658                 if (_packedOwnerships[nextTokenId] == 0) {
2659                     // If the next slot is within bounds.
2660                     if (nextTokenId != _currentIndex) {
2661                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2662                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2663                     }
2664                 }
2665             }
2666         }
2667 
2668         emit Transfer(from, to, tokenId);
2669         _afterTokenTransfers(from, to, tokenId, 1);
2670     }
2671 
2672     /**
2673      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2674      */
2675     function safeTransferFrom(
2676         address from,
2677         address to,
2678         uint256 tokenId
2679     ) public virtual override {
2680         safeTransferFrom(from, to, tokenId, '');
2681     }
2682 
2683     /**
2684      * @dev Safely transfers `tokenId` token from `from` to `to`.
2685      *
2686      * Requirements:
2687      *
2688      * - `from` cannot be the zero address.
2689      * - `to` cannot be the zero address.
2690      * - `tokenId` token must exist and be owned by `from`.
2691      * - If the caller is not `from`, it must be approved to move this token
2692      * by either {approve} or {setApprovalForAll}.
2693      * - If `to` refers to a smart contract, it must implement
2694      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2695      *
2696      * Emits a {Transfer} event.
2697      */
2698     function safeTransferFrom(
2699         address from,
2700         address to,
2701         uint256 tokenId,
2702         bytes memory _data
2703     ) public virtual override {
2704         transferFrom(from, to, tokenId);
2705         if (to.code.length != 0)
2706             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2707                 revert TransferToNonERC721ReceiverImplementer();
2708             }
2709     }
2710 
2711     /**
2712      * @dev Hook that is called before a set of serially-ordered token IDs
2713      * are about to be transferred. This includes minting.
2714      * And also called before burning one token.
2715      *
2716      * `startTokenId` - the first token ID to be transferred.
2717      * `quantity` - the amount to be transferred.
2718      *
2719      * Calling conditions:
2720      *
2721      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2722      * transferred to `to`.
2723      * - When `from` is zero, `tokenId` will be minted for `to`.
2724      * - When `to` is zero, `tokenId` will be burned by `from`.
2725      * - `from` and `to` are never both zero.
2726      */
2727     function _beforeTokenTransfers(
2728         address from,
2729         address to,
2730         uint256 startTokenId,
2731         uint256 quantity
2732     ) internal virtual {}
2733 
2734     /**
2735      * @dev Hook that is called after a set of serially-ordered token IDs
2736      * have been transferred. This includes minting.
2737      * And also called after one token has been burned.
2738      *
2739      * `startTokenId` - the first token ID to be transferred.
2740      * `quantity` - the amount to be transferred.
2741      *
2742      * Calling conditions:
2743      *
2744      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2745      * transferred to `to`.
2746      * - When `from` is zero, `tokenId` has been minted for `to`.
2747      * - When `to` is zero, `tokenId` has been burned by `from`.
2748      * - `from` and `to` are never both zero.
2749      */
2750     function _afterTokenTransfers(
2751         address from,
2752         address to,
2753         uint256 startTokenId,
2754         uint256 quantity
2755     ) internal virtual {}
2756 
2757     /**
2758      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2759      *
2760      * `from` - Previous owner of the given token ID.
2761      * `to` - Target address that will receive the token.
2762      * `tokenId` - Token ID to be transferred.
2763      * `_data` - Optional data to send along with the call.
2764      *
2765      * Returns whether the call correctly returned the expected magic value.
2766      */
2767     function _checkContractOnERC721Received(
2768         address from,
2769         address to,
2770         uint256 tokenId,
2771         bytes memory _data
2772     ) private returns (bool) {
2773         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2774             bytes4 retval
2775         ) {
2776             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2777         } catch (bytes memory reason) {
2778             if (reason.length == 0) {
2779                 revert TransferToNonERC721ReceiverImplementer();
2780             } else {
2781                 assembly {
2782                     revert(add(32, reason), mload(reason))
2783                 }
2784             }
2785         }
2786     }
2787 
2788     // =============================================================
2789     //                        MINT OPERATIONS
2790     // =============================================================
2791 
2792     /**
2793      * @dev Mints `quantity` tokens and transfers them to `to`.
2794      *
2795      * Requirements:
2796      *
2797      * - `to` cannot be the zero address.
2798      * - `quantity` must be greater than 0.
2799      *
2800      * Emits a {Transfer} event for each mint.
2801      */
2802     function _mint(address to, uint256 quantity) internal virtual {
2803         uint256 startTokenId = _currentIndex;
2804         if (quantity == 0) revert MintZeroQuantity();
2805 
2806         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2807 
2808         // Overflows are incredibly unrealistic.
2809         // `balance` and `numberMinted` have a maximum limit of 2**64.
2810         // `tokenId` has a maximum limit of 2**256.
2811         unchecked {
2812             // Updates:
2813             // - `balance += quantity`.
2814             // - `numberMinted += quantity`.
2815             //
2816             // We can directly add to the `balance` and `numberMinted`.
2817             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2818 
2819             // Updates:
2820             // - `address` to the owner.
2821             // - `startTimestamp` to the timestamp of minting.
2822             // - `burned` to `false`.
2823             // - `nextInitialized` to `quantity == 1`.
2824             _packedOwnerships[startTokenId] = _packOwnershipData(
2825                 to,
2826                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2827             );
2828 
2829             uint256 toMasked;
2830             uint256 end = startTokenId + quantity;
2831 
2832             // Use assembly to loop and emit the `Transfer` event for gas savings.
2833             assembly {
2834                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2835                 toMasked := and(to, _BITMASK_ADDRESS)
2836                 // Emit the `Transfer` event.
2837                 log4(
2838                     0, // Start of data (0, since no data).
2839                     0, // End of data (0, since no data).
2840                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2841                     0, // `address(0)`.
2842                     toMasked, // `to`.
2843                     startTokenId // `tokenId`.
2844                 )
2845 
2846                 for {
2847                     let tokenId := add(startTokenId, 1)
2848                 } iszero(eq(tokenId, end)) {
2849                     tokenId := add(tokenId, 1)
2850                 } {
2851                     // Emit the `Transfer` event. Similar to above.
2852                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2853                 }
2854             }
2855             if (toMasked == 0) revert MintToZeroAddress();
2856 
2857             _currentIndex = end;
2858         }
2859         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2860     }
2861 
2862     /**
2863      * @dev Mints `quantity` tokens and transfers them to `to`.
2864      *
2865      * This function is intended for efficient minting only during contract creation.
2866      *
2867      * It emits only one {ConsecutiveTransfer} as defined in
2868      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2869      * instead of a sequence of {Transfer} event(s).
2870      *
2871      * Calling this function outside of contract creation WILL make your contract
2872      * non-compliant with the ERC721 standard.
2873      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2874      * {ConsecutiveTransfer} event is only permissible during contract creation.
2875      *
2876      * Requirements:
2877      *
2878      * - `to` cannot be the zero address.
2879      * - `quantity` must be greater than 0.
2880      *
2881      * Emits a {ConsecutiveTransfer} event.
2882      */
2883     function _mintERC2309(address to, uint256 quantity) internal virtual {
2884         uint256 startTokenId = _currentIndex;
2885         if (to == address(0)) revert MintToZeroAddress();
2886         if (quantity == 0) revert MintZeroQuantity();
2887         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2888 
2889         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2890 
2891         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2892         unchecked {
2893             // Updates:
2894             // - `balance += quantity`.
2895             // - `numberMinted += quantity`.
2896             //
2897             // We can directly add to the `balance` and `numberMinted`.
2898             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2899 
2900             // Updates:
2901             // - `address` to the owner.
2902             // - `startTimestamp` to the timestamp of minting.
2903             // - `burned` to `false`.
2904             // - `nextInitialized` to `quantity == 1`.
2905             _packedOwnerships[startTokenId] = _packOwnershipData(
2906                 to,
2907                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2908             );
2909 
2910             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2911 
2912             _currentIndex = startTokenId + quantity;
2913         }
2914         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2915     }
2916 
2917     /**
2918      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2919      *
2920      * Requirements:
2921      *
2922      * - If `to` refers to a smart contract, it must implement
2923      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2924      * - `quantity` must be greater than 0.
2925      *
2926      * See {_mint}.
2927      *
2928      * Emits a {Transfer} event for each mint.
2929      */
2930     function _safeMint(
2931         address to,
2932         uint256 quantity,
2933         bytes memory _data
2934     ) internal virtual {
2935         _mint(to, quantity);
2936 
2937         unchecked {
2938             if (to.code.length != 0) {
2939                 uint256 end = _currentIndex;
2940                 uint256 index = end - quantity;
2941                 do {
2942                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2943                         revert TransferToNonERC721ReceiverImplementer();
2944                     }
2945                 } while (index < end);
2946                 // Reentrancy protection.
2947                 if (_currentIndex != end) revert();
2948             }
2949         }
2950     }
2951 
2952     /**
2953      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2954      */
2955     function _safeMint(address to, uint256 quantity) internal virtual {
2956         _safeMint(to, quantity, '');
2957     }
2958 
2959     // =============================================================
2960     //                        BURN OPERATIONS
2961     // =============================================================
2962 
2963     /**
2964      * @dev Equivalent to `_burn(tokenId, false)`.
2965      */
2966     function _burn(uint256 tokenId) internal virtual {
2967         _burn(tokenId, false);
2968     }
2969 
2970     /**
2971      * @dev Destroys `tokenId`.
2972      * The approval is cleared when the token is burned.
2973      *
2974      * Requirements:
2975      *
2976      * - `tokenId` must exist.
2977      *
2978      * Emits a {Transfer} event.
2979      */
2980     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2981         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2982 
2983         address from = address(uint160(prevOwnershipPacked));
2984 
2985         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2986 
2987         if (approvalCheck) {
2988             // The nested ifs save around 20+ gas over a compound boolean condition.
2989             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2990                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2991         }
2992 
2993         _beforeTokenTransfers(from, address(0), tokenId, 1);
2994 
2995         // Clear approvals from the previous owner.
2996         assembly {
2997             if approvedAddress {
2998                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2999                 sstore(approvedAddressSlot, 0)
3000             }
3001         }
3002 
3003         // Underflow of the sender's balance is impossible because we check for
3004         // ownership above and the recipient's balance can't realistically overflow.
3005         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
3006         unchecked {
3007             // Updates:
3008             // - `balance -= 1`.
3009             // - `numberBurned += 1`.
3010             //
3011             // We can directly decrement the balance, and increment the number burned.
3012             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
3013             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
3014 
3015             // Updates:
3016             // - `address` to the last owner.
3017             // - `startTimestamp` to the timestamp of burning.
3018             // - `burned` to `true`.
3019             // - `nextInitialized` to `true`.
3020             _packedOwnerships[tokenId] = _packOwnershipData(
3021                 from,
3022                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
3023             );
3024 
3025             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
3026             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
3027                 uint256 nextTokenId = tokenId + 1;
3028                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
3029                 if (_packedOwnerships[nextTokenId] == 0) {
3030                     // If the next slot is within bounds.
3031                     if (nextTokenId != _currentIndex) {
3032                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
3033                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
3034                     }
3035                 }
3036             }
3037         }
3038 
3039         emit Transfer(from, address(0), tokenId);
3040         _afterTokenTransfers(from, address(0), tokenId, 1);
3041 
3042         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
3043         unchecked {
3044             _burnCounter++;
3045         }
3046     }
3047 
3048     // =============================================================
3049     //                     EXTRA DATA OPERATIONS
3050     // =============================================================
3051 
3052     /**
3053      * @dev Directly sets the extra data for the ownership data `index`.
3054      */
3055     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
3056         uint256 packed = _packedOwnerships[index];
3057         if (packed == 0) revert OwnershipNotInitializedForExtraData();
3058         uint256 extraDataCasted;
3059         // Cast `extraData` with assembly to avoid redundant masking.
3060         assembly {
3061             extraDataCasted := extraData
3062         }
3063         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
3064         _packedOwnerships[index] = packed;
3065     }
3066 
3067     /**
3068      * @dev Called during each token transfer to set the 24bit `extraData` field.
3069      * Intended to be overridden by the cosumer contract.
3070      *
3071      * `previousExtraData` - the value of `extraData` before transfer.
3072      *
3073      * Calling conditions:
3074      *
3075      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
3076      * transferred to `to`.
3077      * - When `from` is zero, `tokenId` will be minted for `to`.
3078      * - When `to` is zero, `tokenId` will be burned by `from`.
3079      * - `from` and `to` are never both zero.
3080      */
3081     function _extraData(
3082         address from,
3083         address to,
3084         uint24 previousExtraData
3085     ) internal view virtual returns (uint24) {}
3086 
3087     /**
3088      * @dev Returns the next extra data for the packed ownership data.
3089      * The returned result is shifted into position.
3090      */
3091     function _nextExtraData(
3092         address from,
3093         address to,
3094         uint256 prevOwnershipPacked
3095     ) private view returns (uint256) {
3096         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
3097         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
3098     }
3099 
3100     // =============================================================
3101     //                       OTHER OPERATIONS
3102     // =============================================================
3103 
3104     /**
3105      * @dev Returns the message sender (defaults to `msg.sender`).
3106      *
3107      * If you are writing GSN compatible contracts, you need to override this function.
3108      */
3109     function _msgSenderERC721A() internal view virtual returns (address) {
3110         return msg.sender;
3111     }
3112 
3113     /**
3114      * @dev Converts a uint256 to its ASCII string decimal representation.
3115      */
3116     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
3117         assembly {
3118             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
3119             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
3120             // We will need 1 32-byte word to store the length,
3121             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
3122             ptr := add(mload(0x40), 128)
3123             // Update the free memory pointer to allocate.
3124             mstore(0x40, ptr)
3125 
3126             // Cache the end of the memory to calculate the length later.
3127             let end := ptr
3128 
3129             // We write the string from the rightmost digit to the leftmost digit.
3130             // The following is essentially a do-while loop that also handles the zero case.
3131             // Costs a bit more than early returning for the zero case,
3132             // but cheaper in terms of deployment and overall runtime costs.
3133             for {
3134                 // Initialize and perform the first pass without check.
3135                 let temp := value
3136                 // Move the pointer 1 byte leftwards to point to an empty character slot.
3137                 ptr := sub(ptr, 1)
3138                 // Write the character to the pointer.
3139                 // The ASCII index of the '0' character is 48.
3140                 mstore8(ptr, add(48, mod(temp, 10)))
3141                 temp := div(temp, 10)
3142             } temp {
3143                 // Keep dividing `temp` until zero.
3144                 temp := div(temp, 10)
3145             } {
3146                 // Body of the for loop.
3147                 ptr := sub(ptr, 1)
3148                 mstore8(ptr, add(48, mod(temp, 10)))
3149             }
3150 
3151             let length := sub(end, ptr)
3152             // Move the pointer 32 bytes leftwards to make room for the length.
3153             ptr := sub(ptr, 32)
3154             // Store the length.
3155             mstore(ptr, length)
3156         }
3157     }
3158 }
3159 // File: contracts/WonderPetsNFT.sol
3160 
3161 // SPDX-License-Identifier: MIT
3162 pragma solidity ^0.8.4;
3163 
3164 
3165 
3166 
3167 
3168 
3169 
3170 
3171 
3172 
3173 
3174 contract WonderPetsNFT is ERC721A, Ownable, ERC2981,OperatorFilterer{
3175     using SafeMath for uint256;
3176     using Strings for uint256;
3177   
3178     ERC721Enumerable public  WGM;
3179     uint256 public constant maxSupply = 1500;
3180     uint256 public  maxClaimAmount = 500;
3181     uint256 public  maxMintAmount = 20;
3182     uint256 public  totalClaimed = 0;
3183     uint256 public  cost = 0.02 ether;
3184 
3185     string private baseTokenUri;
3186     string private revealBaseTokenUri;
3187 
3188     bool public paused = false;
3189     bool public revealed=false;
3190     
3191     mapping (uint256 => bool) public WGMClaimed;
3192 
3193     constructor(
3194         string memory _name,
3195         string memory _symbol,
3196         string memory _initBaseURI,
3197         address _WGMAddress
3198     )   ERC721A(_name, _symbol)
3199         OperatorFilterer(address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6), true)
3200     {
3201         WGM = ERC721Enumerable(_WGMAddress);
3202         setRevealBaseURI(_initBaseURI);
3203     }
3204 
3205     function mint(address _to,uint256 _quantity) public payable {
3206         require(!paused, "WonderPets :: Not Yet Active.");
3207         require((totalSupply() + _quantity) <= maxSupply, "WonderPets :: Beyond Max Supply");
3208         require(_quantity <= maxMintAmount, "WonderPets :: Beyond Max Mint");
3209         if (msg.sender != owner()) {
3210             require(msg.value >= (cost * _quantity), "WonderPets :: Payment is below the price");
3211         }
3212 
3213         _safeMint(_to, _quantity);
3214     }
3215 
3216     function claim() public {
3217         require(!paused, "WonderPets :: Not Yet Active.");
3218         require(totalSupply() < maxSupply, "WonderPets :: Beyond Max Supply");
3219         require(totalClaimed  < maxClaimAmount, "WonderPets :: Beyond Max Supply");
3220         require(tokenstoClaim(msg.sender) >0 ,"WonderPets :: Nothing to claim");
3221 
3222         uint256 ownerTokenCount = WGM.balanceOf(msg.sender);
3223         uint256  _amount =0;
3224         uint256 wtid;
3225         for (uint256 i; i < ownerTokenCount; i++) {
3226             wtid = WGM.tokenOfOwnerByIndex(msg.sender, i);
3227             if(WGMClaimed[wtid] == false && (totalClaimed + _amount) < maxClaimAmount
3228                && (totalSupply() + _amount) < maxSupply){
3229                 _amount++;
3230                 WGMClaimed[wtid]=true;
3231             }
3232         }
3233 
3234         require(_amount> 0,"WonderPets :: Nothing to claim");
3235         require((_amount + totalClaimed) <= maxClaimAmount,"WonderPets :: Beyond Max Supply");
3236         require((_amount + totalSupply()) <= maxSupply,"WonderPets :: Beyond Max Supply");
3237         _safeMint(msg.sender, _amount);
3238         totalClaimed = totalClaimed + _amount ;
3239     }
3240 
3241     function tokenstoClaim(address _owner) public view returns (uint256)
3242     {
3243         uint256 ownerTokenCount = WGM.balanceOf(_owner);
3244         uint256 tid;
3245         uint256 tkns =0;
3246         for (uint256 i; i < ownerTokenCount; i++) {
3247             tid = WGM.tokenOfOwnerByIndex(_owner, i);
3248             if(WGMClaimed[tid] == false){
3249                 tkns++;
3250             }
3251         }
3252         return tkns;
3253     }
3254 
3255     function _baseURI() internal view virtual override returns (string memory) {
3256         return baseTokenUri;
3257     }
3258 
3259     //return uri for certain token
3260     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
3261         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
3262 
3263         //uint256 trueId = tokenId + 1;
3264 
3265         //string memory baseURI = _baseURI();
3266         if(revealed == false)
3267             return revealBaseTokenUri;
3268         else
3269             return bytes(baseTokenUri).length > 0 ? string(abi.encodePacked(baseTokenUri, tokenId.toString(),  ".json")) : "";
3270     }
3271 
3272     function setBaseURI(string memory _baseTokenUri) public onlyOwner{
3273         baseTokenUri = _baseTokenUri;
3274     }
3275 
3276     function setRevealBaseURI(string memory _baseTokenUri) public onlyOwner{
3277         revealBaseTokenUri = _baseTokenUri;
3278     }
3279 
3280     function reveal() external onlyOwner{
3281         revealed=true;
3282     }
3283 
3284     function togglePause() external onlyOwner{
3285         paused = !paused;
3286     }
3287 
3288     function setCost(uint256 _newCost) public onlyOwner {
3289         cost = _newCost;
3290     }
3291     
3292     function setMaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
3293         maxMintAmount = _newmaxMintAmount;
3294     }
3295     function setmaxClaimAmount(uint256 _newmaxClaimAmount) public onlyOwner {
3296         maxClaimAmount = _newmaxClaimAmount;
3297     }
3298 
3299      function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981) returns (bool) {
3300         return
3301             ERC721A.supportsInterface(interfaceId) ||
3302             ERC2981.supportsInterface(interfaceId);
3303     }
3304 
3305     function setDefaultRoyalty(address receiver,uint96 feeNumerator) external onlyOwner {
3306         _setDefaultRoyalty(receiver, feeNumerator);
3307     }
3308 
3309     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
3310         require(revealed,"WonderPets :: You are not able to list item for sale at this stage.");
3311         super.setApprovalForAll(operator, approved);
3312     }
3313 
3314     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
3315          super.approve(operator, tokenId);
3316     }
3317 
3318     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
3319         super.transferFrom(from, to, tokenId);
3320     }
3321 
3322     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
3323         super.safeTransferFrom(from, to, tokenId);
3324     }
3325 
3326     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override onlyAllowedOperator(from){
3327         super.safeTransferFrom(from, to, tokenId, data);
3328     }
3329 
3330     function withdraw() public onlyOwner {
3331      require(payable(msg.sender).send(address(this).balance));
3332     }
3333 }