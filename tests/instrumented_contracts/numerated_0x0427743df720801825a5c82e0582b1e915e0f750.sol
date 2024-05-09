1 // File: contracts/UsesMon.sol
2 
3 //  : AGPL-3.0-or-later
4 
5 pragma solidity ^0.6.8;
6 
7 interface UsesMon {
8   struct Mon {
9       // the original address this monster went to
10       address summoner;
11 
12       // the unique ID associated with parent 1 of this monster
13       uint256 parent1Id;
14 
15       // the unique ID associated with parent 2 of this monster
16       uint256 parent2Id;
17 
18       // the address of the contract that minted this monster
19       address minterContract;
20 
21       // the id of this monster within its specific contract
22       uint256 contractOrder;
23 
24       // the generation of this monster
25       uint256 gen;
26 
27       // used to calculate statistics and other things
28       uint256 bits;
29 
30       // tracks the experience of this monster
31       uint256 exp;
32 
33       // the monster's rarity
34       uint256 rarity;
35   }
36 }
37 
38 // File: @openzeppelin/contracts/GSN/Context.sol
39 
40 //  : (MIT AND AGPL-3.0-or-later)
41 
42 pragma solidity ^0.6.0;
43 
44 /*
45  * @dev Provides information about the current execution context, including the
46  * sender of the transaction and its data. While these are generally available
47  * via msg.sender and msg.data, they should not be accessed in such a direct
48  * manner, since when dealing with GSN meta-transactions the account sending and
49  * paying for execution may not be the actual sender (as far as an application
50  * is concerned).
51  *
52  * This contract is only required for intermediate, library-like contracts.
53  */
54 abstract contract Context {
55     function _msgSender() internal view virtual returns (address payable) {
56         return msg.sender;
57     }
58 
59     function _msgData() internal view virtual returns (bytes memory) {
60         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
61         return msg.data;
62     }
63 }
64 
65 // File: @openzeppelin/contracts/introspection/IERC165.sol
66 
67 //  : (MIT AND AGPL-3.0-or-later)
68 
69 pragma solidity ^0.6.0;
70 
71 /**
72  * @dev Interface of the ERC165 standard, as defined in the
73  * https://eips.ethereum.org/EIPS/eip-165[EIP].
74  *
75  * Implementers can declare support of contract interfaces, which can then be
76  * queried by others ({ERC165Checker}).
77  *
78  * For an implementation, see {ERC165}.
79  */
80 interface IERC165 {
81     /**
82      * @dev Returns true if this contract implements the interface defined by
83      * `interfaceId`. See the corresponding
84      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
85      * to learn more about how these ids are created.
86      *
87      * This function call must use less than 30 000 gas.
88      */
89     function supportsInterface(bytes4 interfaceId) external view returns (bool);
90 }
91 
92 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
93 
94 //  : (MIT AND AGPL-3.0-or-later)
95 
96 pragma solidity ^0.6.2;
97 
98 
99 /**
100  * @dev Required interface of an ERC721 compliant contract.
101  */
102 interface IERC721 is IERC165 {
103     /**
104      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
105      */
106     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
107 
108     /**
109      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
110      */
111     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
112 
113     /**
114      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
115      */
116     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
117 
118     /**
119      * @dev Returns the number of tokens in ``owner``'s account.
120      */
121     function balanceOf(address owner) external view returns (uint256 balance);
122 
123     /**
124      * @dev Returns the owner of the `tokenId` token.
125      *
126      * Requirements:
127      *
128      * - `tokenId` must exist.
129      */
130     function ownerOf(uint256 tokenId) external view returns (address owner);
131 
132     /**
133      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
134      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
135      *
136      * Requirements:
137      *
138      * - `from` cannot be the zero address.
139      * - `to` cannot be the zero address.
140      * - `tokenId` token must exist and be owned by `from`.
141      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
142      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
143      *
144      * Emits a {Transfer} event.
145      */
146     function safeTransferFrom(address from, address to, uint256 tokenId) external;
147 
148     /**
149      * @dev Transfers `tokenId` token from `from` to `to`.
150      *
151      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
152      *
153      * Requirements:
154      *
155      * - `from` cannot be the zero address.
156      * - `to` cannot be the zero address.
157      * - `tokenId` token must be owned by `from`.
158      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
159      *
160      * Emits a {Transfer} event.
161      */
162     function transferFrom(address from, address to, uint256 tokenId) external;
163 
164     /**
165      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
166      * The approval is cleared when the token is transferred.
167      *
168      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
169      *
170      * Requirements:
171      *
172      * - The caller must own the token or be an approved operator.
173      * - `tokenId` must exist.
174      *
175      * Emits an {Approval} event.
176      */
177     function approve(address to, uint256 tokenId) external;
178 
179     /**
180      * @dev Returns the account approved for `tokenId` token.
181      *
182      * Requirements:
183      *
184      * - `tokenId` must exist.
185      */
186     function getApproved(uint256 tokenId) external view returns (address operator);
187 
188     /**
189      * @dev Approve or remove `operator` as an operator for the caller.
190      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
191      *
192      * Requirements:
193      *
194      * - The `operator` cannot be the caller.
195      *
196      * Emits an {ApprovalForAll} event.
197      */
198     function setApprovalForAll(address operator, bool _approved) external;
199 
200     /**
201      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
202      *
203      * See {setApprovalForAll}
204      */
205     function isApprovedForAll(address owner, address operator) external view returns (bool);
206 
207     /**
208       * @dev Safely transfers `tokenId` token from `from` to `to`.
209       *
210       * Requirements:
211       *
212      * - `from` cannot be the zero address.
213      * - `to` cannot be the zero address.
214       * - `tokenId` token must exist and be owned by `from`.
215       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
216       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
217       *
218       * Emits a {Transfer} event.
219       */
220     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
221 }
222 
223 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
224 
225 //  : (MIT AND AGPL-3.0-or-later)
226 
227 pragma solidity ^0.6.2;
228 
229 
230 /**
231  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
232  * @dev See https://eips.ethereum.org/EIPS/eip-721
233  */
234 interface IERC721Metadata is IERC721 {
235 
236     /**
237      * @dev Returns the token collection name.
238      */
239     function name() external view returns (string memory);
240 
241     /**
242      * @dev Returns the token collection symbol.
243      */
244     function symbol() external view returns (string memory);
245 
246     /**
247      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
248      */
249     function tokenURI(uint256 tokenId) external view returns (string memory);
250 }
251 
252 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
253 
254 //  : (MIT AND AGPL-3.0-or-later)
255 
256 pragma solidity ^0.6.2;
257 
258 
259 /**
260  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
261  * @dev See https://eips.ethereum.org/EIPS/eip-721
262  */
263 interface IERC721Enumerable is IERC721 {
264 
265     /**
266      * @dev Returns the total amount of tokens stored by the contract.
267      */
268     function totalSupply() external view returns (uint256);
269 
270     /**
271      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
272      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
273      */
274     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
275 
276     /**
277      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
278      * Use along with {totalSupply} to enumerate all tokens.
279      */
280     function tokenByIndex(uint256 index) external view returns (uint256);
281 }
282 
283 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
284 
285 //  : (MIT AND AGPL-3.0-or-later)
286 
287 pragma solidity ^0.6.0;
288 
289 /**
290  * @title ERC721 token receiver interface
291  * @dev Interface for any contract that wants to support safeTransfers
292  * from ERC721 asset contracts.
293  */
294 interface IERC721Receiver {
295     /**
296      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
297      * by `operator` from `from`, this function is called.
298      *
299      * It must return its Solidity selector to confirm the token transfer.
300      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
301      *
302      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
303      */
304     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
305     external returns (bytes4);
306 }
307 
308 // File: @openzeppelin/contracts/introspection/ERC165.sol
309 
310 //  : (MIT AND AGPL-3.0-or-later)
311 
312 pragma solidity ^0.6.0;
313 
314 
315 /**
316  * @dev Implementation of the {IERC165} interface.
317  *
318  * Contracts may inherit from this and call {_registerInterface} to declare
319  * their support of an interface.
320  */
321 contract ERC165 is IERC165 {
322     /*
323      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
324      */
325     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
326 
327     /**
328      * @dev Mapping of interface ids to whether or not it's supported.
329      */
330     mapping(bytes4 => bool) private _supportedInterfaces;
331 
332     constructor () internal {
333         // Derived contracts need only register support for their own interfaces,
334         // we register support for ERC165 itself here
335         _registerInterface(_INTERFACE_ID_ERC165);
336     }
337 
338     /**
339      * @dev See {IERC165-supportsInterface}.
340      *
341      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
342      */
343     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
344         return _supportedInterfaces[interfaceId];
345     }
346 
347     /**
348      * @dev Registers the contract as an implementer of the interface defined by
349      * `interfaceId`. Support of the actual ERC165 interface is automatic and
350      * registering its interface id is not required.
351      *
352      * See {IERC165-supportsInterface}.
353      *
354      * Requirements:
355      *
356      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
357      */
358     function _registerInterface(bytes4 interfaceId) internal virtual {
359         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
360         _supportedInterfaces[interfaceId] = true;
361     }
362 }
363 
364 // File: @openzeppelin/contracts/math/SafeMath.sol
365 
366 //  : (MIT AND AGPL-3.0-or-later)
367 
368 pragma solidity ^0.6.0;
369 
370 /**
371  * @dev Wrappers over Solidity's arithmetic operations with added overflow
372  * checks.
373  *
374  * Arithmetic operations in Solidity wrap on overflow. This can easily result
375  * in bugs, because programmers usually assume that an overflow raises an
376  * error, which is the standard behavior in high level programming languages.
377  * `SafeMath` restores this intuition by reverting the transaction when an
378  * operation overflows.
379  *
380  * Using this library instead of the unchecked operations eliminates an entire
381  * class of bugs, so it's recommended to use it always.
382  */
383 library SafeMath {
384     /**
385      * @dev Returns the addition of two unsigned integers, reverting on
386      * overflow.
387      *
388      * Counterpart to Solidity's `+` operator.
389      *
390      * Requirements:
391      *
392      * - Addition cannot overflow.
393      */
394     function add(uint256 a, uint256 b) internal pure returns (uint256) {
395         uint256 c = a + b;
396         require(c >= a, "SafeMath: addition overflow");
397 
398         return c;
399     }
400 
401     /**
402      * @dev Returns the subtraction of two unsigned integers, reverting on
403      * overflow (when the result is negative).
404      *
405      * Counterpart to Solidity's `-` operator.
406      *
407      * Requirements:
408      *
409      * - Subtraction cannot overflow.
410      */
411     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
412         return sub(a, b, "SafeMath: subtraction overflow");
413     }
414 
415     /**
416      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
417      * overflow (when the result is negative).
418      *
419      * Counterpart to Solidity's `-` operator.
420      *
421      * Requirements:
422      *
423      * - Subtraction cannot overflow.
424      */
425     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
426         require(b <= a, errorMessage);
427         uint256 c = a - b;
428 
429         return c;
430     }
431 
432     /**
433      * @dev Returns the multiplication of two unsigned integers, reverting on
434      * overflow.
435      *
436      * Counterpart to Solidity's `*` operator.
437      *
438      * Requirements:
439      *
440      * - Multiplication cannot overflow.
441      */
442     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
443         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
444         // benefit is lost if 'b' is also tested.
445         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
446         if (a == 0) {
447             return 0;
448         }
449 
450         uint256 c = a * b;
451         require(c / a == b, "SafeMath: multiplication overflow");
452 
453         return c;
454     }
455 
456     /**
457      * @dev Returns the integer division of two unsigned integers. Reverts on
458      * division by zero. The result is rounded towards zero.
459      *
460      * Counterpart to Solidity's `/` operator. Note: this function uses a
461      * `revert` opcode (which leaves remaining gas untouched) while Solidity
462      * uses an invalid opcode to revert (consuming all remaining gas).
463      *
464      * Requirements:
465      *
466      * - The divisor cannot be zero.
467      */
468     function div(uint256 a, uint256 b) internal pure returns (uint256) {
469         return div(a, b, "SafeMath: division by zero");
470     }
471 
472     /**
473      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
474      * division by zero. The result is rounded towards zero.
475      *
476      * Counterpart to Solidity's `/` operator. Note: this function uses a
477      * `revert` opcode (which leaves remaining gas untouched) while Solidity
478      * uses an invalid opcode to revert (consuming all remaining gas).
479      *
480      * Requirements:
481      *
482      * - The divisor cannot be zero.
483      */
484     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
485         require(b > 0, errorMessage);
486         uint256 c = a / b;
487         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
488 
489         return c;
490     }
491 
492     /**
493      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
494      * Reverts when dividing by zero.
495      *
496      * Counterpart to Solidity's `%` operator. This function uses a `revert`
497      * opcode (which leaves remaining gas untouched) while Solidity uses an
498      * invalid opcode to revert (consuming all remaining gas).
499      *
500      * Requirements:
501      *
502      * - The divisor cannot be zero.
503      */
504     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
505         return mod(a, b, "SafeMath: modulo by zero");
506     }
507 
508     /**
509      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
510      * Reverts with custom message when dividing by zero.
511      *
512      * Counterpart to Solidity's `%` operator. This function uses a `revert`
513      * opcode (which leaves remaining gas untouched) while Solidity uses an
514      * invalid opcode to revert (consuming all remaining gas).
515      *
516      * Requirements:
517      *
518      * - The divisor cannot be zero.
519      */
520     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
521         require(b != 0, errorMessage);
522         return a % b;
523     }
524 }
525 
526 // File: @openzeppelin/contracts/utils/Address.sol
527 
528 //  : (MIT AND AGPL-3.0-or-later)
529 
530 pragma solidity ^0.6.2;
531 
532 /**
533  * @dev Collection of functions related to the address type
534  */
535 library Address {
536     /**
537      * @dev Returns true if `account` is a contract.
538      *
539      * [IMPORTANT]
540      * ====
541      * It is unsafe to assume that an address for which this function returns
542      * false is an externally-owned account (EOA) and not a contract.
543      *
544      * Among others, `isContract` will return false for the following
545      * types of addresses:
546      *
547      *  - an externally-owned account
548      *  - a contract in construction
549      *  - an address where a contract will be created
550      *  - an address where a contract lived, but was destroyed
551      * ====
552      */
553     function isContract(address account) internal view returns (bool) {
554         // This method relies in extcodesize, which returns 0 for contracts in
555         // construction, since the code is only stored at the end of the
556         // constructor execution.
557 
558         uint256 size;
559         // solhint-disable-next-line no-inline-assembly
560         assembly { size := extcodesize(account) }
561         return size > 0;
562     }
563 
564     /**
565      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
566      * `recipient`, forwarding all available gas and reverting on errors.
567      *
568      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
569      * of certain opcodes, possibly making contracts go over the 2300 gas limit
570      * imposed by `transfer`, making them unable to receive funds via
571      * `transfer`. {sendValue} removes this limitation.
572      *
573      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
574      *
575      * IMPORTANT: because control is transferred to `recipient`, care must be
576      * taken to not create reentrancy vulnerabilities. Consider using
577      * {ReentrancyGuard} or the
578      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
579      */
580     function sendValue(address payable recipient, uint256 amount) internal {
581         require(address(this).balance >= amount, "Address: insufficient balance");
582 
583         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
584         (bool success, ) = recipient.call{ value: amount }("");
585         require(success, "Address: unable to send value, recipient may have reverted");
586     }
587 
588     /**
589      * @dev Performs a Solidity function call using a low level `call`. A
590      * plain`call` is an unsafe replacement for a function call: use this
591      * function instead.
592      *
593      * If `target` reverts with a revert reason, it is bubbled up by this
594      * function (like regular Solidity function calls).
595      *
596      * Returns the raw returned data. To convert to the expected return value,
597      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
598      *
599      * Requirements:
600      *
601      * - `target` must be a contract.
602      * - calling `target` with `data` must not revert.
603      *
604      * _Available since v3.1._
605      */
606     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
607       return functionCall(target, data, "Address: low-level call failed");
608     }
609 
610     /**
611      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
612      * `errorMessage` as a fallback revert reason when `target` reverts.
613      *
614      * _Available since v3.1._
615      */
616     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
617         return _functionCallWithValue(target, data, 0, errorMessage);
618     }
619 
620     /**
621      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
622      * but also transferring `value` wei to `target`.
623      *
624      * Requirements:
625      *
626      * - the calling contract must have an ETH balance of at least `value`.
627      * - the called Solidity function must be `payable`.
628      *
629      * _Available since v3.1._
630      */
631     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
632         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
633     }
634 
635     /**
636      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
637      * with `errorMessage` as a fallback revert reason when `target` reverts.
638      *
639      * _Available since v3.1._
640      */
641     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
642         require(address(this).balance >= value, "Address: insufficient balance for call");
643         return _functionCallWithValue(target, data, value, errorMessage);
644     }
645 
646     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
647         require(isContract(target), "Address: call to non-contract");
648 
649         // solhint-disable-next-line avoid-low-level-calls
650         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
651         if (success) {
652             return returndata;
653         } else {
654             // Look for revert reason and bubble it up if present
655             if (returndata.length > 0) {
656                 // The easiest way to bubble the revert reason is using memory via assembly
657 
658                 // solhint-disable-next-line no-inline-assembly
659                 assembly {
660                     let returndata_size := mload(returndata)
661                     revert(add(32, returndata), returndata_size)
662                 }
663             } else {
664                 revert(errorMessage);
665             }
666         }
667     }
668 }
669 
670 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
671 
672 //  : (MIT AND AGPL-3.0-or-later)
673 
674 pragma solidity ^0.6.0;
675 
676 /**
677  * @dev Library for managing
678  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
679  * types.
680  *
681  * Sets have the following properties:
682  *
683  * - Elements are added, removed, and checked for existence in constant time
684  * (O(1)).
685  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
686  *
687  * ```
688  * contract Example {
689  *     // Add the library methods
690  *     using EnumerableSet for EnumerableSet.AddressSet;
691  *
692  *     // Declare a set state variable
693  *     EnumerableSet.AddressSet private mySet;
694  * }
695  * ```
696  *
697  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
698  * (`UintSet`) are supported.
699  */
700 library EnumerableSet {
701     // To implement this library for multiple types with as little code
702     // repetition as possible, we write it in terms of a generic Set type with
703     // bytes32 values.
704     // The Set implementation uses private functions, and user-facing
705     // implementations (such as AddressSet) are just wrappers around the
706     // underlying Set.
707     // This means that we can only create new EnumerableSets for types that fit
708     // in bytes32.
709 
710     struct Set {
711         // Storage of set values
712         bytes32[] _values;
713 
714         // Position of the value in the `values` array, plus 1 because index 0
715         // means a value is not in the set.
716         mapping (bytes32 => uint256) _indexes;
717     }
718 
719     /**
720      * @dev Add a value to a set. O(1).
721      *
722      * Returns true if the value was added to the set, that is if it was not
723      * already present.
724      */
725     function _add(Set storage set, bytes32 value) private returns (bool) {
726         if (!_contains(set, value)) {
727             set._values.push(value);
728             // The value is stored at length-1, but we add 1 to all indexes
729             // and use 0 as a sentinel value
730             set._indexes[value] = set._values.length;
731             return true;
732         } else {
733             return false;
734         }
735     }
736 
737     /**
738      * @dev Removes a value from a set. O(1).
739      *
740      * Returns true if the value was removed from the set, that is if it was
741      * present.
742      */
743     function _remove(Set storage set, bytes32 value) private returns (bool) {
744         // We read and store the value's index to prevent multiple reads from the same storage slot
745         uint256 valueIndex = set._indexes[value];
746 
747         if (valueIndex != 0) { // Equivalent to contains(set, value)
748             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
749             // the array, and then remove the last element (sometimes called as 'swap and pop').
750             // This modifies the order of the array, as noted in {at}.
751 
752             uint256 toDeleteIndex = valueIndex - 1;
753             uint256 lastIndex = set._values.length - 1;
754 
755             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
756             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
757 
758             bytes32 lastvalue = set._values[lastIndex];
759 
760             // Move the last value to the index where the value to delete is
761             set._values[toDeleteIndex] = lastvalue;
762             // Update the index for the moved value
763             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
764 
765             // Delete the slot where the moved value was stored
766             set._values.pop();
767 
768             // Delete the index for the deleted slot
769             delete set._indexes[value];
770 
771             return true;
772         } else {
773             return false;
774         }
775     }
776 
777     /**
778      * @dev Returns true if the value is in the set. O(1).
779      */
780     function _contains(Set storage set, bytes32 value) private view returns (bool) {
781         return set._indexes[value] != 0;
782     }
783 
784     /**
785      * @dev Returns the number of values on the set. O(1).
786      */
787     function _length(Set storage set) private view returns (uint256) {
788         return set._values.length;
789     }
790 
791    /**
792     * @dev Returns the value stored at position `index` in the set. O(1).
793     *
794     * Note that there are no guarantees on the ordering of values inside the
795     * array, and it may change when more values are added or removed.
796     *
797     * Requirements:
798     *
799     * - `index` must be strictly less than {length}.
800     */
801     function _at(Set storage set, uint256 index) private view returns (bytes32) {
802         require(set._values.length > index, "EnumerableSet: index out of bounds");
803         return set._values[index];
804     }
805 
806     // AddressSet
807 
808     struct AddressSet {
809         Set _inner;
810     }
811 
812     /**
813      * @dev Add a value to a set. O(1).
814      *
815      * Returns true if the value was added to the set, that is if it was not
816      * already present.
817      */
818     function add(AddressSet storage set, address value) internal returns (bool) {
819         return _add(set._inner, bytes32(uint256(value)));
820     }
821 
822     /**
823      * @dev Removes a value from a set. O(1).
824      *
825      * Returns true if the value was removed from the set, that is if it was
826      * present.
827      */
828     function remove(AddressSet storage set, address value) internal returns (bool) {
829         return _remove(set._inner, bytes32(uint256(value)));
830     }
831 
832     /**
833      * @dev Returns true if the value is in the set. O(1).
834      */
835     function contains(AddressSet storage set, address value) internal view returns (bool) {
836         return _contains(set._inner, bytes32(uint256(value)));
837     }
838 
839     /**
840      * @dev Returns the number of values in the set. O(1).
841      */
842     function length(AddressSet storage set) internal view returns (uint256) {
843         return _length(set._inner);
844     }
845 
846    /**
847     * @dev Returns the value stored at position `index` in the set. O(1).
848     *
849     * Note that there are no guarantees on the ordering of values inside the
850     * array, and it may change when more values are added or removed.
851     *
852     * Requirements:
853     *
854     * - `index` must be strictly less than {length}.
855     */
856     function at(AddressSet storage set, uint256 index) internal view returns (address) {
857         return address(uint256(_at(set._inner, index)));
858     }
859 
860 
861     // UintSet
862 
863     struct UintSet {
864         Set _inner;
865     }
866 
867     /**
868      * @dev Add a value to a set. O(1).
869      *
870      * Returns true if the value was added to the set, that is if it was not
871      * already present.
872      */
873     function add(UintSet storage set, uint256 value) internal returns (bool) {
874         return _add(set._inner, bytes32(value));
875     }
876 
877     /**
878      * @dev Removes a value from a set. O(1).
879      *
880      * Returns true if the value was removed from the set, that is if it was
881      * present.
882      */
883     function remove(UintSet storage set, uint256 value) internal returns (bool) {
884         return _remove(set._inner, bytes32(value));
885     }
886 
887     /**
888      * @dev Returns true if the value is in the set. O(1).
889      */
890     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
891         return _contains(set._inner, bytes32(value));
892     }
893 
894     /**
895      * @dev Returns the number of values on the set. O(1).
896      */
897     function length(UintSet storage set) internal view returns (uint256) {
898         return _length(set._inner);
899     }
900 
901    /**
902     * @dev Returns the value stored at position `index` in the set. O(1).
903     *
904     * Note that there are no guarantees on the ordering of values inside the
905     * array, and it may change when more values are added or removed.
906     *
907     * Requirements:
908     *
909     * - `index` must be strictly less than {length}.
910     */
911     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
912         return uint256(_at(set._inner, index));
913     }
914 }
915 
916 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
917 
918 //  : (MIT AND AGPL-3.0-or-later)
919 
920 pragma solidity ^0.6.0;
921 
922 /**
923  * @dev Library for managing an enumerable variant of Solidity's
924  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
925  * type.
926  *
927  * Maps have the following properties:
928  *
929  * - Entries are added, removed, and checked for existence in constant time
930  * (O(1)).
931  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
932  *
933  * ```
934  * contract Example {
935  *     // Add the library methods
936  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
937  *
938  *     // Declare a set state variable
939  *     EnumerableMap.UintToAddressMap private myMap;
940  * }
941  * ```
942  *
943  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
944  * supported.
945  */
946 library EnumerableMap {
947     // To implement this library for multiple types with as little code
948     // repetition as possible, we write it in terms of a generic Map type with
949     // bytes32 keys and values.
950     // The Map implementation uses private functions, and user-facing
951     // implementations (such as Uint256ToAddressMap) are just wrappers around
952     // the underlying Map.
953     // This means that we can only create new EnumerableMaps for types that fit
954     // in bytes32.
955 
956     struct MapEntry {
957         bytes32 _key;
958         bytes32 _value;
959     }
960 
961     struct Map {
962         // Storage of map keys and values
963         MapEntry[] _entries;
964 
965         // Position of the entry defined by a key in the `entries` array, plus 1
966         // because index 0 means a key is not in the map.
967         mapping (bytes32 => uint256) _indexes;
968     }
969 
970     /**
971      * @dev Adds a key-value pair to a map, or updates the value for an existing
972      * key. O(1).
973      *
974      * Returns true if the key was added to the map, that is if it was not
975      * already present.
976      */
977     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
978         // We read and store the key's index to prevent multiple reads from the same storage slot
979         uint256 keyIndex = map._indexes[key];
980 
981         if (keyIndex == 0) { // Equivalent to !contains(map, key)
982             map._entries.push(MapEntry({ _key: key, _value: value }));
983             // The entry is stored at length-1, but we add 1 to all indexes
984             // and use 0 as a sentinel value
985             map._indexes[key] = map._entries.length;
986             return true;
987         } else {
988             map._entries[keyIndex - 1]._value = value;
989             return false;
990         }
991     }
992 
993     /**
994      * @dev Removes a key-value pair from a map. O(1).
995      *
996      * Returns true if the key was removed from the map, that is if it was present.
997      */
998     function _remove(Map storage map, bytes32 key) private returns (bool) {
999         // We read and store the key's index to prevent multiple reads from the same storage slot
1000         uint256 keyIndex = map._indexes[key];
1001 
1002         if (keyIndex != 0) { // Equivalent to contains(map, key)
1003             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1004             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1005             // This modifies the order of the array, as noted in {at}.
1006 
1007             uint256 toDeleteIndex = keyIndex - 1;
1008             uint256 lastIndex = map._entries.length - 1;
1009 
1010             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1011             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1012 
1013             MapEntry storage lastEntry = map._entries[lastIndex];
1014 
1015             // Move the last entry to the index where the entry to delete is
1016             map._entries[toDeleteIndex] = lastEntry;
1017             // Update the index for the moved entry
1018             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1019 
1020             // Delete the slot where the moved entry was stored
1021             map._entries.pop();
1022 
1023             // Delete the index for the deleted slot
1024             delete map._indexes[key];
1025 
1026             return true;
1027         } else {
1028             return false;
1029         }
1030     }
1031 
1032     /**
1033      * @dev Returns true if the key is in the map. O(1).
1034      */
1035     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1036         return map._indexes[key] != 0;
1037     }
1038 
1039     /**
1040      * @dev Returns the number of key-value pairs in the map. O(1).
1041      */
1042     function _length(Map storage map) private view returns (uint256) {
1043         return map._entries.length;
1044     }
1045 
1046    /**
1047     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1048     *
1049     * Note that there are no guarantees on the ordering of entries inside the
1050     * array, and it may change when more entries are added or removed.
1051     *
1052     * Requirements:
1053     *
1054     * - `index` must be strictly less than {length}.
1055     */
1056     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1057         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1058 
1059         MapEntry storage entry = map._entries[index];
1060         return (entry._key, entry._value);
1061     }
1062 
1063     /**
1064      * @dev Returns the value associated with `key`.  O(1).
1065      *
1066      * Requirements:
1067      *
1068      * - `key` must be in the map.
1069      */
1070     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1071         return _get(map, key, "EnumerableMap: nonexistent key");
1072     }
1073 
1074     /**
1075      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1076      */
1077     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1078         uint256 keyIndex = map._indexes[key];
1079         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1080         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1081     }
1082 
1083     // UintToAddressMap
1084 
1085     struct UintToAddressMap {
1086         Map _inner;
1087     }
1088 
1089     /**
1090      * @dev Adds a key-value pair to a map, or updates the value for an existing
1091      * key. O(1).
1092      *
1093      * Returns true if the key was added to the map, that is if it was not
1094      * already present.
1095      */
1096     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1097         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1098     }
1099 
1100     /**
1101      * @dev Removes a value from a set. O(1).
1102      *
1103      * Returns true if the key was removed from the map, that is if it was present.
1104      */
1105     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1106         return _remove(map._inner, bytes32(key));
1107     }
1108 
1109     /**
1110      * @dev Returns true if the key is in the map. O(1).
1111      */
1112     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1113         return _contains(map._inner, bytes32(key));
1114     }
1115 
1116     /**
1117      * @dev Returns the number of elements in the map. O(1).
1118      */
1119     function length(UintToAddressMap storage map) internal view returns (uint256) {
1120         return _length(map._inner);
1121     }
1122 
1123    /**
1124     * @dev Returns the element stored at position `index` in the set. O(1).
1125     * Note that there are no guarantees on the ordering of values inside the
1126     * array, and it may change when more values are added or removed.
1127     *
1128     * Requirements:
1129     *
1130     * - `index` must be strictly less than {length}.
1131     */
1132     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1133         (bytes32 key, bytes32 value) = _at(map._inner, index);
1134         return (uint256(key), address(uint256(value)));
1135     }
1136 
1137     /**
1138      * @dev Returns the value associated with `key`.  O(1).
1139      *
1140      * Requirements:
1141      *
1142      * - `key` must be in the map.
1143      */
1144     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1145         return address(uint256(_get(map._inner, bytes32(key))));
1146     }
1147 
1148     /**
1149      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1150      */
1151     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1152         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1153     }
1154 }
1155 
1156 // File: @openzeppelin/contracts/utils/Strings.sol
1157 
1158 //  : (MIT AND AGPL-3.0-or-later)
1159 
1160 pragma solidity ^0.6.0;
1161 
1162 /**
1163  * @dev String operations.
1164  */
1165 library Strings {
1166     /**
1167      * @dev Converts a `uint256` to its ASCII `string` representation.
1168      */
1169     function toString(uint256 value) internal pure returns (string memory) {
1170         // Inspired by OraclizeAPI's implementation - MIT licence
1171         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1172 
1173         if (value == 0) {
1174             return "0";
1175         }
1176         uint256 temp = value;
1177         uint256 digits;
1178         while (temp != 0) {
1179             digits++;
1180             temp /= 10;
1181         }
1182         bytes memory buffer = new bytes(digits);
1183         uint256 index = digits - 1;
1184         temp = value;
1185         while (temp != 0) {
1186             buffer[index--] = byte(uint8(48 + temp % 10));
1187             temp /= 10;
1188         }
1189         return string(buffer);
1190     }
1191 }
1192 
1193 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1194 
1195 //  : (MIT AND AGPL-3.0-or-later)
1196 
1197 pragma solidity ^0.6.0;
1198 
1199 
1200 
1201 
1202 
1203 
1204 
1205 
1206 
1207 
1208 
1209 
1210 /**
1211  * @title ERC721 Non-Fungible Token Standard basic implementation
1212  * @dev see https://eips.ethereum.org/EIPS/eip-721
1213  */
1214 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1215     using SafeMath for uint256;
1216     using Address for address;
1217     using EnumerableSet for EnumerableSet.UintSet;
1218     using EnumerableMap for EnumerableMap.UintToAddressMap;
1219     using Strings for uint256;
1220 
1221     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1222     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1223     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1224 
1225     // Mapping from holder address to their (enumerable) set of owned tokens
1226     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1227 
1228     // Enumerable mapping from token ids to their owners
1229     EnumerableMap.UintToAddressMap private _tokenOwners;
1230 
1231     // Mapping from token ID to approved address
1232     mapping (uint256 => address) private _tokenApprovals;
1233 
1234     // Mapping from owner to operator approvals
1235     mapping (address => mapping (address => bool)) private _operatorApprovals;
1236 
1237     // Token name
1238     string private _name;
1239 
1240     // Token symbol
1241     string private _symbol;
1242 
1243     // Optional mapping for token URIs
1244     mapping (uint256 => string) private _tokenURIs;
1245 
1246     // Base URI
1247     string private _baseURI;
1248 
1249     /*
1250      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1251      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1252      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1253      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1254      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1255      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1256      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1257      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1258      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1259      *
1260      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1261      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1262      */
1263     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1264 
1265     /*
1266      *     bytes4(keccak256('name()')) == 0x06fdde03
1267      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1268      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1269      *
1270      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1271      */
1272     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1273 
1274     /*
1275      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1276      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1277      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1278      *
1279      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1280      */
1281     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1282 
1283     /**
1284      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1285      */
1286     constructor (string memory name, string memory symbol) public {
1287         _name = name;
1288         _symbol = symbol;
1289 
1290         // register the supported interfaces to conform to ERC721 via ERC165
1291         _registerInterface(_INTERFACE_ID_ERC721);
1292         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1293         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1294     }
1295 
1296     /**
1297      * @dev See {IERC721-balanceOf}.
1298      */
1299     function balanceOf(address owner) public view override returns (uint256) {
1300         require(owner != address(0), "ERC721: balance query for the zero address");
1301 
1302         return _holderTokens[owner].length();
1303     }
1304 
1305     /**
1306      * @dev See {IERC721-ownerOf}.
1307      */
1308     function ownerOf(uint256 tokenId) public view override returns (address) {
1309         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1310     }
1311 
1312     /**
1313      * @dev See {IERC721Metadata-name}.
1314      */
1315     function name() public view override returns (string memory) {
1316         return _name;
1317     }
1318 
1319     /**
1320      * @dev See {IERC721Metadata-symbol}.
1321      */
1322     function symbol() public view override returns (string memory) {
1323         return _symbol;
1324     }
1325 
1326     /**
1327      * @dev See {IERC721Metadata-tokenURI}.
1328      */
1329     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1330         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1331 
1332         string memory _tokenURI = _tokenURIs[tokenId];
1333 
1334         // If there is no base URI, return the token URI.
1335         if (bytes(_baseURI).length == 0) {
1336             return _tokenURI;
1337         }
1338         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1339         if (bytes(_tokenURI).length > 0) {
1340             return string(abi.encodePacked(_baseURI, _tokenURI));
1341         }
1342         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1343         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1344     }
1345 
1346     /**
1347     * @dev Returns the base URI set via {_setBaseURI}. This will be
1348     * automatically added as a prefix in {tokenURI} to each token's URI, or
1349     * to the token ID if no specific URI is set for that token ID.
1350     */
1351     function baseURI() public view returns (string memory) {
1352         return _baseURI;
1353     }
1354 
1355     /**
1356      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1357      */
1358     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1359         return _holderTokens[owner].at(index);
1360     }
1361 
1362     /**
1363      * @dev See {IERC721Enumerable-totalSupply}.
1364      */
1365     function totalSupply() public view override returns (uint256) {
1366         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1367         return _tokenOwners.length();
1368     }
1369 
1370     /**
1371      * @dev See {IERC721Enumerable-tokenByIndex}.
1372      */
1373     function tokenByIndex(uint256 index) public view override returns (uint256) {
1374         (uint256 tokenId, ) = _tokenOwners.at(index);
1375         return tokenId;
1376     }
1377 
1378     /**
1379      * @dev See {IERC721-approve}.
1380      */
1381     function approve(address to, uint256 tokenId) public virtual override {
1382         address owner = ownerOf(tokenId);
1383         require(to != owner, "ERC721: approval to current owner");
1384 
1385         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1386             "ERC721: approve caller is not owner nor approved for all"
1387         );
1388 
1389         _approve(to, tokenId);
1390     }
1391 
1392     /**
1393      * @dev See {IERC721-getApproved}.
1394      */
1395     function getApproved(uint256 tokenId) public view override returns (address) {
1396         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1397 
1398         return _tokenApprovals[tokenId];
1399     }
1400 
1401     /**
1402      * @dev See {IERC721-setApprovalForAll}.
1403      */
1404     function setApprovalForAll(address operator, bool approved) public virtual override {
1405         require(operator != _msgSender(), "ERC721: approve to caller");
1406 
1407         _operatorApprovals[_msgSender()][operator] = approved;
1408         emit ApprovalForAll(_msgSender(), operator, approved);
1409     }
1410 
1411     /**
1412      * @dev See {IERC721-isApprovedForAll}.
1413      */
1414     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1415         return _operatorApprovals[owner][operator];
1416     }
1417 
1418     /**
1419      * @dev See {IERC721-transferFrom}.
1420      */
1421     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1422         //solhint-disable-next-line max-line-length
1423         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1424 
1425         _transfer(from, to, tokenId);
1426     }
1427 
1428     /**
1429      * @dev See {IERC721-safeTransferFrom}.
1430      */
1431     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1432         safeTransferFrom(from, to, tokenId, "");
1433     }
1434 
1435     /**
1436      * @dev See {IERC721-safeTransferFrom}.
1437      */
1438     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1439         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1440         _safeTransfer(from, to, tokenId, _data);
1441     }
1442 
1443     /**
1444      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1445      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1446      *
1447      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1448      *
1449      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1450      * implement alternative mechanisms to perform token transfer, such as signature-based.
1451      *
1452      * Requirements:
1453      *
1454      * - `from` cannot be the zero address.
1455      * - `to` cannot be the zero address.
1456      * - `tokenId` token must exist and be owned by `from`.
1457      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1458      *
1459      * Emits a {Transfer} event.
1460      */
1461     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1462         _transfer(from, to, tokenId);
1463         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1464     }
1465 
1466     /**
1467      * @dev Returns whether `tokenId` exists.
1468      *
1469      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1470      *
1471      * Tokens start existing when they are minted (`_mint`),
1472      * and stop existing when they are burned (`_burn`).
1473      */
1474     function _exists(uint256 tokenId) internal view returns (bool) {
1475         return _tokenOwners.contains(tokenId);
1476     }
1477 
1478     /**
1479      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1480      *
1481      * Requirements:
1482      *
1483      * - `tokenId` must exist.
1484      */
1485     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1486         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1487         address owner = ownerOf(tokenId);
1488         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1489     }
1490 
1491     /**
1492      * @dev Safely mints `tokenId` and transfers it to `to`.
1493      *
1494      * Requirements:
1495      d*
1496      * - `tokenId` must not exist.
1497      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1498      *
1499      * Emits a {Transfer} event.
1500      */
1501     function _safeMint(address to, uint256 tokenId) internal virtual {
1502         _safeMint(to, tokenId, "");
1503     }
1504 
1505     /**
1506      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1507      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1508      */
1509     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1510         _mint(to, tokenId);
1511         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1512     }
1513 
1514     /**
1515      * @dev Mints `tokenId` and transfers it to `to`.
1516      *
1517      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1518      *
1519      * Requirements:
1520      *
1521      * - `tokenId` must not exist.
1522      * - `to` cannot be the zero address.
1523      *
1524      * Emits a {Transfer} event.
1525      */
1526     function _mint(address to, uint256 tokenId) internal virtual {
1527         require(to != address(0), "ERC721: mint to the zero address");
1528         require(!_exists(tokenId), "ERC721: token already minted");
1529 
1530         _beforeTokenTransfer(address(0), to, tokenId);
1531 
1532         _holderTokens[to].add(tokenId);
1533 
1534         _tokenOwners.set(tokenId, to);
1535 
1536         emit Transfer(address(0), to, tokenId);
1537     }
1538 
1539     /**
1540      * @dev Destroys `tokenId`.
1541      * The approval is cleared when the token is burned.
1542      *
1543      * Requirements:
1544      *
1545      * - `tokenId` must exist.
1546      *
1547      * Emits a {Transfer} event.
1548      */
1549     function _burn(uint256 tokenId) internal virtual {
1550         address owner = ownerOf(tokenId);
1551 
1552         _beforeTokenTransfer(owner, address(0), tokenId);
1553 
1554         // Clear approvals
1555         _approve(address(0), tokenId);
1556 
1557         // Clear metadata (if any)
1558         if (bytes(_tokenURIs[tokenId]).length != 0) {
1559             delete _tokenURIs[tokenId];
1560         }
1561 
1562         _holderTokens[owner].remove(tokenId);
1563 
1564         _tokenOwners.remove(tokenId);
1565 
1566         emit Transfer(owner, address(0), tokenId);
1567     }
1568 
1569     /**
1570      * @dev Transfers `tokenId` from `from` to `to`.
1571      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1572      *
1573      * Requirements:
1574      *
1575      * - `to` cannot be the zero address.
1576      * - `tokenId` token must be owned by `from`.
1577      *
1578      * Emits a {Transfer} event.
1579      */
1580     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1581         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1582         require(to != address(0), "ERC721: transfer to the zero address");
1583 
1584         _beforeTokenTransfer(from, to, tokenId);
1585 
1586         // Clear approvals from the previous owner
1587         _approve(address(0), tokenId);
1588 
1589         _holderTokens[from].remove(tokenId);
1590         _holderTokens[to].add(tokenId);
1591 
1592         _tokenOwners.set(tokenId, to);
1593 
1594         emit Transfer(from, to, tokenId);
1595     }
1596 
1597     /**
1598      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1599      *
1600      * Requirements:
1601      *
1602      * - `tokenId` must exist.
1603      */
1604     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1605         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1606         _tokenURIs[tokenId] = _tokenURI;
1607     }
1608 
1609     /**
1610      * @dev Internal function to set the base URI for all token IDs. It is
1611      * automatically added as a prefix to the value returned in {tokenURI},
1612      * or to the token ID if {tokenURI} is empty.
1613      */
1614     function _setBaseURI(string memory baseURI_) internal virtual {
1615         _baseURI = baseURI_;
1616     }
1617 
1618     /**
1619      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1620      * The call is not executed if the target address is not a contract.
1621      *
1622      * @param from address representing the previous owner of the given token ID
1623      * @param to target address that will receive the tokens
1624      * @param tokenId uint256 ID of the token to be transferred
1625      * @param _data bytes optional data to send along with the call
1626      * @return bool whether the call correctly returned the expected magic value
1627      */
1628     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1629         private returns (bool)
1630     {
1631         if (!to.isContract()) {
1632             return true;
1633         }
1634         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1635             IERC721Receiver(to).onERC721Received.selector,
1636             _msgSender(),
1637             from,
1638             tokenId,
1639             _data
1640         ), "ERC721: transfer to non ERC721Receiver implementer");
1641         bytes4 retval = abi.decode(returndata, (bytes4));
1642         return (retval == _ERC721_RECEIVED);
1643     }
1644 
1645     function _approve(address to, uint256 tokenId) private {
1646         _tokenApprovals[tokenId] = to;
1647         emit Approval(ownerOf(tokenId), to, tokenId);
1648     }
1649 
1650     /**
1651      * @dev Hook that is called before any token transfer. This includes minting
1652      * and burning.
1653      *
1654      * Calling conditions:
1655      *
1656      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1657      * transferred to `to`.
1658      * - When `from` is zero, `tokenId` will be minted for `to`.
1659      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1660      * - `from` cannot be the zero address.
1661      * - `to` cannot be the zero address.
1662      *
1663      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1664      */
1665     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1666 }
1667 
1668 // File: @openzeppelin/contracts/token/ERC721/ERC721Burnable.sol
1669 
1670 //  : (MIT AND AGPL-3.0-or-later)
1671 
1672 pragma solidity ^0.6.0;
1673 
1674 
1675 
1676 /**
1677  * @title ERC721 Burnable Token
1678  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1679  */
1680 abstract contract ERC721Burnable is Context, ERC721 {
1681     /**
1682      * @dev Burns `tokenId`. See {ERC721-_burn}.
1683      *
1684      * Requirements:
1685      *
1686      * - The caller must own `tokenId` or be an approved operator.
1687      */
1688     function burn(uint256 tokenId) public virtual {
1689         //solhint-disable-next-line max-line-length
1690         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1691         _burn(tokenId);
1692     }
1693 }
1694 
1695 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1696 
1697 //  : (MIT AND AGPL-3.0-or-later)
1698 
1699 pragma solidity ^0.6.0;
1700 
1701 /**
1702  * @dev Interface of the ERC20 standard as defined in the EIP.
1703  */
1704 interface IERC20 {
1705     /**
1706      * @dev Returns the amount of tokens in existence.
1707      */
1708     function totalSupply() external view returns (uint256);
1709 
1710     /**
1711      * @dev Returns the amount of tokens owned by `account`.
1712      */
1713     function balanceOf(address account) external view returns (uint256);
1714 
1715     /**
1716      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1717      *
1718      * Returns a boolean value indicating whether the operation succeeded.
1719      *
1720      * Emits a {Transfer} event.
1721      */
1722     function transfer(address recipient, uint256 amount) external returns (bool);
1723 
1724     /**
1725      * @dev Returns the remaining number of tokens that `spender` will be
1726      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1727      * zero by default.
1728      *
1729      * This value changes when {approve} or {transferFrom} are called.
1730      */
1731     function allowance(address owner, address spender) external view returns (uint256);
1732 
1733     /**
1734      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1735      *
1736      * Returns a boolean value indicating whether the operation succeeded.
1737      *
1738      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1739      * that someone may use both the old and the new allowance by unfortunate
1740      * transaction ordering. One possible solution to mitigate this race
1741      * condition is to first reduce the spender's allowance to 0 and set the
1742      * desired value afterwards:
1743      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1744      *
1745      * Emits an {Approval} event.
1746      */
1747     function approve(address spender, uint256 amount) external returns (bool);
1748 
1749     /**
1750      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1751      * allowance mechanism. `amount` is then deducted from the caller's
1752      * allowance.
1753      *
1754      * Returns a boolean value indicating whether the operation succeeded.
1755      *
1756      * Emits a {Transfer} event.
1757      */
1758     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1759 
1760     /**
1761      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1762      * another (`to`).
1763      *
1764      * Note that `value` may be zero.
1765      */
1766     event Transfer(address indexed from, address indexed to, uint256 value);
1767 
1768     /**
1769      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1770      * a call to {approve}. `value` is the new allowance.
1771      */
1772     event Approval(address indexed owner, address indexed spender, uint256 value);
1773 }
1774 
1775 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
1776 
1777 //  : (MIT AND AGPL-3.0-or-later)
1778 
1779 pragma solidity ^0.6.0;
1780 
1781 
1782 
1783 
1784 /**
1785  * @title SafeERC20
1786  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1787  * contract returns false). Tokens that return no value (and instead revert or
1788  * throw on failure) are also supported, non-reverting calls are assumed to be
1789  * successful.
1790  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1791  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1792  */
1793 library SafeERC20 {
1794     using SafeMath for uint256;
1795     using Address for address;
1796 
1797     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1798         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1799     }
1800 
1801     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1802         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1803     }
1804 
1805     /**
1806      * @dev Deprecated. This function has issues similar to the ones found in
1807      * {IERC20-approve}, and its usage is discouraged.
1808      *
1809      * Whenever possible, use {safeIncreaseAllowance} and
1810      * {safeDecreaseAllowance} instead.
1811      */
1812     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1813         // safeApprove should only be called when setting an initial allowance,
1814         // or when resetting it to zero. To increase and decrease it, use
1815         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1816         // solhint-disable-next-line max-line-length
1817         require((value == 0) || (token.allowance(address(this), spender) == 0),
1818             "SafeERC20: approve from non-zero to non-zero allowance"
1819         );
1820         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1821     }
1822 
1823     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1824         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1825         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1826     }
1827 
1828     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1829         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1830         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1831     }
1832 
1833     /**
1834      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1835      * on the return value: the return value is optional (but if data is returned, it must not be false).
1836      * @param token The token targeted by the call.
1837      * @param data The call data (encoded using abi.encode or one of its variants).
1838      */
1839     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1840         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1841         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1842         // the target address contains contract code and also asserts for success in the low-level call.
1843 
1844         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1845         if (returndata.length > 0) { // Return data is optional
1846             // solhint-disable-next-line max-line-length
1847             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1848         }
1849     }
1850 }
1851 
1852 // File: @openzeppelin/contracts/utils/Counters.sol
1853 
1854 //  : (MIT AND AGPL-3.0-or-later)
1855 
1856 pragma solidity ^0.6.0;
1857 
1858 
1859 /**
1860  * @title Counters
1861  * @author Matt Condon (@shrugs)
1862  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1863  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1864  *
1865  * Include with `using Counters for Counters.Counter;`
1866  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1867  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1868  * directly accessed.
1869  */
1870 library Counters {
1871     using SafeMath for uint256;
1872 
1873     struct Counter {
1874         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1875         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1876         // this feature: see https://github.com/ethereum/solidity/issues/4637
1877         uint256 _value; // default: 0
1878     }
1879 
1880     function current(Counter storage counter) internal view returns (uint256) {
1881         return counter._value;
1882     }
1883 
1884     function increment(Counter storage counter) internal {
1885         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1886         counter._value += 1;
1887     }
1888 
1889     function decrement(Counter storage counter) internal {
1890         counter._value = counter._value.sub(1);
1891     }
1892 }
1893 
1894 // File: @openzeppelin/contracts/access/AccessControl.sol
1895 
1896 //  : (MIT AND AGPL-3.0-or-later)
1897 
1898 pragma solidity ^0.6.0;
1899 
1900 
1901 
1902 
1903 /**
1904  * @dev Contract module that allows children to implement role-based access
1905  * control mechanisms.
1906  *
1907  * Roles are referred to by their `bytes32` identifier. These should be exposed
1908  * in the external API and be unique. The best way to achieve this is by
1909  * using `public constant` hash digests:
1910  *
1911  * ```
1912  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1913  * ```
1914  *
1915  * Roles can be used to represent a set of permissions. To restrict access to a
1916  * function call, use {hasRole}:
1917  *
1918  * ```
1919  * function foo() public {
1920  *     require(hasRole(MY_ROLE, msg.sender));
1921  *     ...
1922  * }
1923  * ```
1924  *
1925  * Roles can be granted and revoked dynamically via the {grantRole} and
1926  * {revokeRole} functions. Each role has an associated admin role, and only
1927  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1928  *
1929  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1930  * that only accounts with this role will be able to grant or revoke other
1931  * roles. More complex role relationships can be created by using
1932  * {_setRoleAdmin}.
1933  *
1934  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1935  * grant and revoke this role. Extra precautions should be taken to secure
1936  * accounts that have been granted it.
1937  */
1938 abstract contract AccessControl is Context {
1939     using EnumerableSet for EnumerableSet.AddressSet;
1940     using Address for address;
1941 
1942     struct RoleData {
1943         EnumerableSet.AddressSet members;
1944         bytes32 adminRole;
1945     }
1946 
1947     mapping (bytes32 => RoleData) private _roles;
1948 
1949     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1950 
1951     /**
1952      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1953      *
1954      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1955      * {RoleAdminChanged} not being emitted signaling this.
1956      *
1957      * _Available since v3.1._
1958      */
1959     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1960 
1961     /**
1962      * @dev Emitted when `account` is granted `role`.
1963      *
1964      * `sender` is the account that originated the contract call, an admin role
1965      * bearer except when using {_setupRole}.
1966      */
1967     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1968 
1969     /**
1970      * @dev Emitted when `account` is revoked `role`.
1971      *
1972      * `sender` is the account that originated the contract call:
1973      *   - if using `revokeRole`, it is the admin role bearer
1974      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1975      */
1976     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1977 
1978     /**
1979      * @dev Returns `true` if `account` has been granted `role`.
1980      */
1981     function hasRole(bytes32 role, address account) public view returns (bool) {
1982         return _roles[role].members.contains(account);
1983     }
1984 
1985     /**
1986      * @dev Returns the number of accounts that have `role`. Can be used
1987      * together with {getRoleMember} to enumerate all bearers of a role.
1988      */
1989     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1990         return _roles[role].members.length();
1991     }
1992 
1993     /**
1994      * @dev Returns one of the accounts that have `role`. `index` must be a
1995      * value between 0 and {getRoleMemberCount}, non-inclusive.
1996      *
1997      * Role bearers are not sorted in any particular way, and their ordering may
1998      * change at any point.
1999      *
2000      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
2001      * you perform all queries on the same block. See the following
2002      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
2003      * for more information.
2004      */
2005     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
2006         return _roles[role].members.at(index);
2007     }
2008 
2009     /**
2010      * @dev Returns the admin role that controls `role`. See {grantRole} and
2011      * {revokeRole}.
2012      *
2013      * To change a role's admin, use {_setRoleAdmin}.
2014      */
2015     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
2016         return _roles[role].adminRole;
2017     }
2018 
2019     /**
2020      * @dev Grants `role` to `account`.
2021      *
2022      * If `account` had not been already granted `role`, emits a {RoleGranted}
2023      * event.
2024      *
2025      * Requirements:
2026      *
2027      * - the caller must have ``role``'s admin role.
2028      */
2029     function grantRole(bytes32 role, address account) public virtual {
2030         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
2031 
2032         _grantRole(role, account);
2033     }
2034 
2035     /**
2036      * @dev Revokes `role` from `account`.
2037      *
2038      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2039      *
2040      * Requirements:
2041      *
2042      * - the caller must have ``role``'s admin role.
2043      */
2044     function revokeRole(bytes32 role, address account) public virtual {
2045         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
2046 
2047         _revokeRole(role, account);
2048     }
2049 
2050     /**
2051      * @dev Revokes `role` from the calling account.
2052      *
2053      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2054      * purpose is to provide a mechanism for accounts to lose their privileges
2055      * if they are compromised (such as when a trusted device is misplaced).
2056      *
2057      * If the calling account had been granted `role`, emits a {RoleRevoked}
2058      * event.
2059      *
2060      * Requirements:
2061      *
2062      * - the caller must be `account`.
2063      */
2064     function renounceRole(bytes32 role, address account) public virtual {
2065         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
2066 
2067         _revokeRole(role, account);
2068     }
2069 
2070     /**
2071      * @dev Grants `role` to `account`.
2072      *
2073      * If `account` had not been already granted `role`, emits a {RoleGranted}
2074      * event. Note that unlike {grantRole}, this function doesn't perform any
2075      * checks on the calling account.
2076      *
2077      * [WARNING]
2078      * ====
2079      * This function should only be called from the constructor when setting
2080      * up the initial roles for the system.
2081      *
2082      * Using this function in any other way is effectively circumventing the admin
2083      * system imposed by {AccessControl}.
2084      * ====
2085      */
2086     function _setupRole(bytes32 role, address account) internal virtual {
2087         _grantRole(role, account);
2088     }
2089 
2090     /**
2091      * @dev Sets `adminRole` as ``role``'s admin role.
2092      *
2093      * Emits a {RoleAdminChanged} event.
2094      */
2095     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
2096         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
2097         _roles[role].adminRole = adminRole;
2098     }
2099 
2100     function _grantRole(bytes32 role, address account) private {
2101         if (_roles[role].members.add(account)) {
2102             emit RoleGranted(role, account, _msgSender());
2103         }
2104     }
2105 
2106     function _revokeRole(bytes32 role, address account) private {
2107         if (_roles[role].members.remove(account)) {
2108             emit RoleRevoked(role, account, _msgSender());
2109         }
2110     }
2111 }
2112 
2113 // File: contracts/MonMinter.sol
2114 
2115 //  : AGPL-3.0-or-later
2116 
2117 pragma solidity ^0.6.8;
2118 pragma experimental ABIEncoderV2;
2119 
2120 
2121 
2122 
2123 
2124 
2125 
2126 contract MonMinter is ERC721Burnable, AccessControl, UsesMon {
2127 
2128   modifier onlyAdmin {
2129     require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Not admin");
2130     _;
2131   }
2132 
2133   modifier onlyMinter {
2134     require(hasRole(MINTER_ROLE, msg.sender), "Not minter");
2135     _;
2136   }
2137 
2138   using SafeERC20 for IERC20;
2139   using Counters for Counters.Counter;
2140 
2141   bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
2142   Counters.Counter private monIds;
2143 
2144   mapping(uint256 => Mon) public monRecords;
2145 
2146   mapping(uint256 => string) public rarityTable;
2147 
2148   constructor() public ERC721("0xmons.xyz", "0XMON") {
2149 
2150     // Give caller admin permissions
2151     _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
2152 
2153     // Make the caller admin a minter
2154     grantRole(MINTER_ROLE, msg.sender);
2155 
2156     // Send monster #0 to the caller
2157     mintMonster(
2158       // to
2159       msg.sender,
2160       // parent1Id
2161       0,
2162       // parent2Id
2163       0,
2164       // minterContract
2165       address(this),
2166       // contractOrder
2167       0,
2168       // gen
2169       0,
2170       // bits
2171       0,
2172       // exp
2173       0,
2174       // rarity
2175       0
2176       );
2177   }
2178 
2179   // Mints a monster to an address and sets its data
2180   function mintMonster(address to,
2181                        uint256 parent1Id,
2182                        uint256 parent2Id,
2183                        address minterContract,
2184                        uint256 contractOrder,
2185                        uint256 gen,
2186                        uint256 bits,
2187                        uint256 exp,
2188                        uint256 rarity
2189                       ) public onlyMinter returns (uint256) {
2190     uint256 currId = monIds.current();
2191     monIds.increment();
2192     monRecords[currId] = Mon(
2193       to,
2194       parent1Id,
2195       parent2Id,
2196       minterContract,
2197       contractOrder,
2198       gen,
2199       bits,
2200       exp,
2201       rarity
2202     );
2203     _safeMint(to, currId);
2204     return(currId);
2205   }
2206 
2207   // Modifies the data of a monster
2208   function modifyMon(uint256 id,
2209                      bool ignoreZeros,
2210                      uint256 parent1Id,
2211                      uint256 parent2Id,
2212                      address minterContract,
2213                      uint256 contractOrder,
2214                      uint256 gen,
2215                      uint256 bits,
2216                      uint256 exp,
2217                      uint256 rarity
2218   ) public onlyMinter {
2219     Mon storage currMon = monRecords[id];
2220     if (ignoreZeros) {
2221       if (parent1Id != 0) {
2222         currMon.parent1Id = parent1Id;
2223       }
2224       if (parent2Id != 0) {
2225         currMon.parent2Id = parent2Id;
2226       }
2227       if (minterContract != address(0)) {
2228         currMon.minterContract = minterContract;
2229       }
2230       if (contractOrder != 0) {
2231         currMon.contractOrder = contractOrder;
2232       }
2233       if (gen != 0) {
2234         currMon.gen = gen;
2235       }
2236       if (bits != 0) {
2237         currMon.bits = bits;
2238       }
2239       if (exp != 0) {
2240         currMon.exp = exp;
2241       }
2242       if (rarity != 0) {
2243         currMon.rarity = rarity;
2244       }
2245     }
2246     else {
2247       currMon.parent1Id = parent1Id;
2248       currMon.parent2Id = parent2Id;
2249       currMon.minterContract = minterContract;
2250       currMon.contractOrder = contractOrder;
2251       currMon.gen = gen;
2252       currMon.bits = bits;
2253       currMon.exp = exp;
2254       currMon.rarity = rarity;
2255     }
2256   }
2257 
2258   // Modifies the tokenURI of a monster
2259   function setTokenURI(uint256 id, string memory uri) public onlyMinter {
2260     _setTokenURI(id, uri);
2261   }
2262 
2263   // Sets the base URI
2264   function setBaseURI(string memory uri) public onlyAdmin {
2265     _setBaseURI(uri);
2266   }
2267 
2268   // Rescues tokens locked in the contract
2269   function moveTokens(address tokenAddress, address to, uint256 numTokens) public onlyAdmin {
2270     IERC20 _token = IERC20(tokenAddress);
2271     _token.safeTransfer(to, numTokens);
2272   }
2273 
2274   // Updates the mapping of rarity codes to strings
2275   function setRarityTitle(uint256 code, string memory s) public onlyAdmin {
2276     rarityTable[code] = s;
2277   }
2278 
2279   // Allows admin to add new minters
2280   function setMinterRole(address a) public onlyAdmin {
2281     grantRole(MINTER_ROLE, a);
2282   }
2283 }