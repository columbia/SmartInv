1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.11;
3 pragma experimental ABIEncoderV2;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 interface IERC165 {
26     /**
27      * @dev Returns true if this contract implements the interface defined by
28      * `interfaceId`. See the corresponding
29      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
30      * to learn more about how these ids are created.
31      *
32      * This function call must use less than 30 000 gas.
33      */
34     function supportsInterface(bytes4 interfaceId) external view returns (bool);
35 }
36 /**
37  * @dev Required interface of an ERC721 compliant contract.
38  */
39 interface IERC721 is IERC165 {
40     /**
41      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
42      */
43     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
44     /**
45      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
46      */
47     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
48     /**
49      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
50      */
51     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
52     /**
53      * @dev Returns the number of tokens in ``owner``'s account.
54      */
55     function balanceOf(address owner) external view returns (uint256 balance);
56     /**
57      * @dev Returns the owner of the `tokenId` token.
58      *
59      * Requirements:
60      *
61      * - `tokenId` must exist.
62      */
63     function ownerOf(uint256 tokenId) external view returns (address owner);
64     /**
65      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
66      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
67      *
68      * Requirements:
69      *
70      * - `from` cannot be the zero address.
71      * - `to` cannot be the zero address.
72      * - `tokenId` token must exist and be owned by `from`.
73      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
74      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
75      *
76      * Emits a {Transfer} event.
77      */
78     function safeTransferFrom(address from, address to, uint256 tokenId) external;
79     /**
80      * @dev Transfers `tokenId` token from `from` to `to`.
81      *
82      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
83      *
84      * Requirements:
85      *
86      * - `from` cannot be the zero address.
87      * - `to` cannot be the zero address.
88      * - `tokenId` token must be owned by `from`.
89      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address from, address to, uint256 tokenId) external;
94     /**
95      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
96      * The approval is cleared when the token is transferred.
97      *
98      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
99      *
100      * Requirements:
101      *
102      * - The caller must own the token or be an approved operator.
103      * - `tokenId` must exist.
104      *
105      * Emits an {Approval} event.
106      */
107     function approve(address to, uint256 tokenId) external;
108     /**
109      * @dev Returns the account approved for `tokenId` token.
110      *
111      * Requirements:
112      *
113      * - `tokenId` must exist.
114      */
115     function getApproved(uint256 tokenId) external view returns (address operator);
116     /**
117      * @dev Approve or remove `operator` as an operator for the caller.
118      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
119      *
120      * Requirements:
121      *
122      * - The `operator` cannot be the caller.
123      *
124      * Emits an {ApprovalForAll} event.
125      */
126     function setApprovalForAll(address operator, bool _approved) external;
127     /**
128      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
129      *
130      * See {setApprovalForAll}
131      */
132     function isApprovedForAll(address owner, address operator) external view returns (bool);
133     /**
134       * @dev Safely transfers `tokenId` token from `from` to `to`.
135       *
136       * Requirements:
137       *
138       * - `from` cannot be the zero address.
139       * - `to` cannot be the zero address.
140       * - `tokenId` token must exist and be owned by `from`.
141       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
142       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
143       *
144       * Emits a {Transfer} event.
145       */
146     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
147 }
148 /**
149  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
150  * @dev See https://eips.ethereum.org/EIPS/eip-721
151  */
152 interface IERC721Metadata is IERC721 {
153     /**
154      * @dev Returns the token collection name.
155      */
156     function name() external view returns (string memory);
157     /**
158      * @dev Returns the token collection symbol.
159      */
160     function symbol() external view returns (string memory);
161     /**
162      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
163      */
164     function tokenURI(uint256 tokenId) external view returns (string memory);
165 }
166 
167 /**
168  * @title ERC721 token receiver interface
169  * @dev Interface for any contract that wants to support safeTransfers
170  * from ERC721 asset contracts.
171  */
172 interface IERC721Receiver {
173     /**
174      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
175      * by `operator` from `from`, this function is called.
176      *
177      * It must return its Solidity selector to confirm the token transfer.
178      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
179      *
180      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
181      */
182     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
183 }
184 
185 /**
186  * @dev Implementation of the {IERC165} interface.
187  *
188  * Contracts may inherit from this and call {_registerInterface} to declare
189  * their support of an interface.
190  */
191 abstract contract ERC165 is IERC165 {
192     /*
193      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
194      */
195     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
196     /**
197      * @dev Mapping of interface ids to whether or not it's supported.
198      */
199     mapping(bytes4 => bool) private _supportedInterfaces;
200     constructor () {
201         // Derived contracts need only register support for their own interfaces,
202         // we register support for ERC165 itself here
203         _registerInterface(_INTERFACE_ID_ERC165);
204     }
205     /**
206      * @dev See {IERC165-supportsInterface}.
207      *
208      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
209      */
210     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
211         return _supportedInterfaces[interfaceId];
212     }
213     /**
214      * @dev Registers the contract as an implementer of the interface defined by
215      * `interfaceId`. Support of the actual ERC165 interface is automatic and
216      * registering its interface id is not required.
217      *
218      * See {IERC165-supportsInterface}.
219      *
220      * Requirements:
221      *
222      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
223      */
224     function _registerInterface(bytes4 interfaceId) internal virtual {
225         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
226         _supportedInterfaces[interfaceId] = true;
227     }
228 }
229 
230 /**
231  * @dev Wrappers over Solidity's arithmetic operations with added overflow
232  * checks.
233  *
234  * Arithmetic operations in Solidity wrap on overflow. This can easily result
235  * in bugs, because programmers usually assume that an overflow raises an
236  * error, which is the standard behavior in high level programming languages.
237  * `SafeMath` restores this intuition by reverting the transaction when an
238  * operation overflows.
239  *
240  * Using this library instead of the unchecked operations eliminates an entire
241  * class of bugs, so it's recommended to use it always.
242  */
243 library SafeMath {
244     /**
245      * @dev Returns the addition of two unsigned integers, with an overflow flag.
246      *
247      * _Available since v3.4._
248      */
249     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
250         uint256 c = a + b;
251         if (c < a) return (false, 0);
252         return (true, c);
253     }
254     /**
255      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
256      *
257      * _Available since v3.4._
258      */
259     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
260         if (b > a) return (false, 0);
261         return (true, a - b);
262     }
263     /**
264      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
265      *
266      * _Available since v3.4._
267      */
268     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
269         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
270         // benefit is lost if 'b' is also tested.
271         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
272         if (a == 0) return (true, 0);
273         uint256 c = a * b;
274         if (c / a != b) return (false, 0);
275         return (true, c);
276     }
277     /**
278      * @dev Returns the division of two unsigned integers, with a division by zero flag.
279      *
280      * _Available since v3.4._
281      */
282     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
283         if (b == 0) return (false, 0);
284         return (true, a / b);
285     }
286     /**
287      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
288      *
289      * _Available since v3.4._
290      */
291     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
292         if (b == 0) return (false, 0);
293         return (true, a % b);
294     }
295     /**
296      * @dev Returns the addition of two unsigned integers, reverting on
297      * overflow.
298      *
299      * Counterpart to Solidity's `+` operator.
300      *
301      * Requirements:
302      *
303      * - Addition cannot overflow.
304      */
305     function add(uint256 a, uint256 b) internal pure returns (uint256) {
306         uint256 c = a + b;
307         require(c >= a, "SafeMath: addition overflow");
308         return c;
309     }
310     /**
311      * @dev Returns the subtraction of two unsigned integers, reverting on
312      * overflow (when the result is negative).
313      *
314      * Counterpart to Solidity's `-` operator.
315      *
316      * Requirements:
317      *
318      * - Subtraction cannot overflow.
319      */
320     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
321         require(b <= a, "SafeMath: subtraction overflow");
322         return a - b;
323     }
324     /**
325      * @dev Returns the multiplication of two unsigned integers, reverting on
326      * overflow.
327      *
328      * Counterpart to Solidity's `*` operator.
329      *
330      * Requirements:
331      *
332      * - Multiplication cannot overflow.
333      */
334     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
335         if (a == 0) return 0;
336         uint256 c = a * b;
337         require(c / a == b, "SafeMath: multiplication overflow");
338         return c;
339     }
340     /**
341      * @dev Returns the integer division of two unsigned integers, reverting on
342      * division by zero. The result is rounded towards zero.
343      *
344      * Counterpart to Solidity's `/` operator. Note: this function uses a
345      * `revert` opcode (which leaves remaining gas untouched) while Solidity
346      * uses an invalid opcode to revert (consuming all remaining gas).
347      *
348      * Requirements:
349      *
350      * - The divisor cannot be zero.
351      */
352     function div(uint256 a, uint256 b) internal pure returns (uint256) {
353         require(b > 0, "SafeMath: division by zero");
354         return a / b;
355     }
356     /**
357      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
358      * reverting when dividing by zero.
359      *
360      * Counterpart to Solidity's `%` operator. This function uses a `revert`
361      * opcode (which leaves remaining gas untouched) while Solidity uses an
362      * invalid opcode to revert (consuming all remaining gas).
363      *
364      * Requirements:
365      *
366      * - The divisor cannot be zero.
367      */
368     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
369         require(b > 0, "SafeMath: modulo by zero");
370         return a % b;
371     }
372     /**
373      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
374      * overflow (when the result is negative).
375      *
376      * CAUTION: This function is deprecated because it requires allocating memory for the error
377      * message unnecessarily. For custom revert reasons use {trySub}.
378      *
379      * Counterpart to Solidity's `-` operator.
380      *
381      * Requirements:
382      *
383      * - Subtraction cannot overflow.
384      */
385     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
386         require(b <= a, errorMessage);
387         return a - b;
388     }
389     /**
390      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
391      * division by zero. The result is rounded towards zero.
392      *
393      * CAUTION: This function is deprecated because it requires allocating memory for the error
394      * message unnecessarily. For custom revert reasons use {tryDiv}.
395      *
396      * Counterpart to Solidity's `/` operator. Note: this function uses a
397      * `revert` opcode (which leaves remaining gas untouched) while Solidity
398      * uses an invalid opcode to revert (consuming all remaining gas).
399      *
400      * Requirements:
401      *
402      * - The divisor cannot be zero.
403      */
404     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
405         require(b > 0, errorMessage);
406         return a / b;
407     }
408     /**
409      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
410      * reverting with custom message when dividing by zero.
411      *
412      * CAUTION: This function is deprecated because it requires allocating memory for the error
413      * message unnecessarily. For custom revert reasons use {tryMod}.
414      *
415      * Counterpart to Solidity's `%` operator. This function uses a `revert`
416      * opcode (which leaves remaining gas untouched) while Solidity uses an
417      * invalid opcode to revert (consuming all remaining gas).
418      *
419      * Requirements:
420      *
421      * - The divisor cannot be zero.
422      */
423     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
424         require(b > 0, errorMessage);
425         return a % b;
426     }
427 }
428 
429 /**
430  * @dev Collection of functions related to the address Serial
431  */
432 library Address {
433     /**
434      * @dev Returns true if `account` is a contract.
435      *
436      * [IMPORTANT]
437      * ====
438      * It is unsafe to assume that an address for which this function returns
439      * false is an externally-owned account (EOA) and not a contract.
440      *
441      * Among others, `isContract` will return false for the following
442      * Serials of addresses:
443      *
444      *  - an externally-owned account
445      *  - a contract in construction
446      *  - an address where a contract will be created
447      *  - an address where a contract lived, but was destroyed
448      * ====
449      */
450     function isContract(address account) internal view returns (bool) {
451         // This method relies on extcodesize, which returns 0 for contracts in
452         // construction, since the code is only stored at the end of the
453         // constructor execution.
454         uint256 size;
455         // solhint-disable-next-line no-inline-assembly
456         assembly {size := extcodesize(account)}
457         return size > 0;
458     }
459     /**
460      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
461      * `recipient`, forwarding all available gas and reverting on errors.
462      *
463      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
464      * of certain opcodes, possibly making contracts go over the 2300 gas limit
465      * imposed by `transfer`, making them unable to receive funds via
466      * `transfer`. {sendValue} removes this limitation.
467      *
468      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
469      *
470      * IMPORTANT: because control is transferred to `recipient`, care must be
471      * taken to not create reentrancy vulnerabilities. Consider using
472      * {ReentrancyGuard} or the
473      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
474      */
475     function sendValue(address payable recipient, uint256 amount) internal {
476         require(address(this).balance >= amount, "Address: insufficient balance");
477         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
478         (bool success,) = recipient.call{value : amount}("");
479         require(success, "Address: unable to send value, recipient may have reverted");
480     }
481     /**
482      * @dev Performs a Solidity function call using a low level `call`. A
483      * plain`call` is an unsafe replacement for a function call: use this
484      * function instead.
485      *
486      * If `target` reverts with a revert reason, it is bubbled up by this
487      * function (like regular Solidity function calls).
488      *
489      * Returns the raw returned data. To convert to the expected return value,
490      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
491      *
492      * Requirements:
493      *
494      * - `target` must be a contract.
495      * - calling `target` with `data` must not revert.
496      *
497      * _Available since v3.1._
498      */
499     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
500         return functionCall(target, data, "Address: low-level call failed");
501     }
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
504      * `errorMessage` as a fallback revert reason when `target` reverts.
505      *
506      * _Available since v3.1._
507      */
508     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
509         return functionCallWithValue(target, data, 0, errorMessage);
510     }
511     /**
512      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
513      * but also transferring `value` wei to `target`.
514      *
515      * Requirements:
516      *
517      * - the calling contract must have an ETH balance of at least `value`.
518      * - the called Solidity function must be `payable`.
519      *
520      * _Available since v3.1._
521      */
522     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
523         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
524     }
525     /**
526      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
527      * with `errorMessage` as a fallback revert reason when `target` reverts.
528      *
529      * _Available since v3.1._
530      */
531     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
532         require(address(this).balance >= value, "Address: insufficient balance for call");
533         require(isContract(target), "Address: call to non-contract");
534         // solhint-disable-next-line avoid-low-level-calls
535         (bool success, bytes memory returndata) = target.call{value : value}(data);
536         return _verifyCallResult(success, returndata, errorMessage);
537     }
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
540      * but performing a static call.
541      *
542      * _Available since v3.3._
543      */
544     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
545         return functionStaticCall(target, data, "Address: low-level static call failed");
546     }
547     /**
548      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
549      * but performing a static call.
550      *
551      * _Available since v3.3._
552      */
553     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
554         require(isContract(target), "Address: static call to non-contract");
555         // solhint-disable-next-line avoid-low-level-calls
556         (bool success, bytes memory returndata) = target.staticcall(data);
557         return _verifyCallResult(success, returndata, errorMessage);
558     }
559     /**
560      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
561      * but performing a delegate call.
562      *
563      * _Available since v3.4._
564      */
565     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
566         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
567     }
568     /**
569      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
570      * but performing a delegate call.
571      *
572      * _Available since v3.4._
573      */
574     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
575         require(isContract(target), "Address: delegate call to non-contract");
576         // solhint-disable-next-line avoid-low-level-calls
577         (bool success, bytes memory returndata) = target.delegatecall(data);
578         return _verifyCallResult(success, returndata, errorMessage);
579     }
580 
581     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns (bytes memory) {
582         if (success) {
583             return returndata;
584         } else {
585             // Look for revert reason and bubble it up if present
586             if (returndata.length > 0) {
587                 // The easiest way to bubble the revert reason is using memory via assembly
588                 // solhint-disable-next-line no-inline-assembly
589                 assembly {
590                     let returndata_size := mload(returndata)
591                     revert(add(32, returndata), returndata_size)
592                 }
593             } else {
594                 revert(errorMessage);
595             }
596         }
597     }
598 }
599 
600 /**
601  * @dev String operations.
602  */
603 library Strings {
604     /**
605      * @dev Converts a `uint256` to its ASCII `string` representation.
606      */
607     function toString(uint256 value) internal pure returns (string memory) {
608         // Inspired by OraclizeAPI's implementation - MIT licence
609         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
610         if (value == 0) {
611             return "0";
612         }
613         uint256 temp = value;
614         uint256 digits;
615         while (temp != 0) {
616             digits++;
617             temp /= 10;
618         }
619         bytes memory buffer = new bytes(digits);
620         while (value != 0) {
621             digits -= 1;
622             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
623             value /= 10;
624         }
625         return string(buffer);
626     }
627 }
628 
629     error ApprovalCallerNotOwnerNorApproved();
630     error ApprovalQueryForNonexistentToken();
631     error ApproveToCaller();
632     error ApprovalToCurrentOwner();
633     error BalanceQueryForZeroAddress();
634     error MintedQueryForZeroAddress();
635     error BurnedQueryForZeroAddress();
636     error AuxQueryForZeroAddress();
637     error MintToZeroAddress();
638     error MintZeroQuantity();
639     error OwnerIndexOutOfBounds();
640     error OwnerQueryForNonexistentToken();
641     error TokenIndexOutOfBounds();
642     error TransferCallerNotOwnerNorApproved();
643     error TransferFromIncorrectOwner();
644     error TransferToNonERC721ReceiverImplementer();
645     error TransferToZeroAddress();
646     error URIQueryForNonexistentToken();
647 
648 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
649     using Address for address;
650     using Strings for uint256;
651 
652     // Compiler will pack this into a single 256bit word.
653     struct TokenOwnership {
654         // The address of the owner.
655         address addr;
656         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
657         uint64 startTimestamp;
658         // Whether the token has been burned.
659         bool burned;
660     }
661 
662     // Compiler will pack this into a single 256bit word.
663     struct AddressData {
664         // Realistically, 2**64-1 is more than enough.
665         uint64 balance;
666         // Keeps track of mint count with minimal overhead for tokenomics.
667         uint64 numberMinted;
668         // Keeps track of burn count with minimal overhead for tokenomics.
669         uint64 numberBurned;
670         // For miscellaneous variable(s) pertaining to the address
671         // (e.g. number of whitelist mint slots used).
672         // If there are multiple variables, please pack them into a uint64.
673         uint64 aux;
674     }
675 
676     // The tokenId of the next token to be minted.
677     uint256 internal _currentIndex;
678 
679     // The number of tokens burned.
680     uint256 internal _burnCounter;
681 
682     // Token name
683     string private _name;
684 
685     // Token symbol
686     string private _symbol;
687 
688     // Mapping from token ID to ownership details
689     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
690     mapping(uint256 => TokenOwnership) internal _ownerships;
691 
692     // Mapping owner address to address data
693     mapping(address => AddressData) private _addressData;
694 
695     // Mapping from token ID to approved address
696     mapping(uint256 => address) private _tokenApprovals;
697 
698     // Mapping from owner to operator approvals
699     mapping(address => mapping(address => bool)) private _operatorApprovals;
700 
701     // Base URI
702     string private _baseURI;
703 
704     constructor(string memory name_, string memory symbol_) {
705         _name = name_;
706         _symbol = symbol_;
707         _currentIndex = _startTokenId();
708     }
709 
710     /**
711      * To change the starting tokenId, please override this function.
712      */
713     function _startTokenId() internal view virtual returns (uint256) {
714         return 1;
715     }
716 
717     function _setBaseURI(string memory baseURI_) internal virtual {
718         _baseURI = baseURI_;
719     }
720     /**
721      * @dev See {IERC721Enumerable-totalSupply}.
722      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
723      */
724     function totalSupply() public view returns (uint256) {
725         // Counter underflow is impossible as _burnCounter cannot be incremented
726         // more than _currentIndex - _startTokenId() times
727     unchecked {
728         return _currentIndex - _burnCounter - _startTokenId();
729     }
730     }
731 
732     /**
733      * Returns the total amount of tokens minted in the contract.
734      */
735     function _totalMinted() internal view returns (uint256) {
736         // Counter underflow is impossible as _currentIndex does not decrement,
737         // and it is initialized to _startTokenId()
738     unchecked {
739         return _currentIndex - _startTokenId();
740     }
741     }
742 
743     /**
744      * @dev See {IERC165-supportsInterface}.
745      */
746     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
747         return
748         interfaceId == type(IERC721).interfaceId ||
749     interfaceId == type(IERC721Metadata).interfaceId ||
750     super.supportsInterface(interfaceId);
751     }
752 
753     /**
754      * @dev See {IERC721-balanceOf}.
755      */
756     function balanceOf(address owner) public view override returns (uint256) {
757         if (owner == address(0)) revert BalanceQueryForZeroAddress();
758         return uint256(_addressData[owner].balance);
759     }
760 
761     /**
762      * Returns the number of tokens minted by `owner`.
763      */
764     function _numberMinted(address owner) internal view returns (uint256) {
765         if (owner == address(0)) revert MintedQueryForZeroAddress();
766         return uint256(_addressData[owner].numberMinted);
767     }
768 
769     /**
770      * Returns the number of tokens burned by or on behalf of `owner`.
771      */
772     function _numberBurned(address owner) internal view returns (uint256) {
773         if (owner == address(0)) revert BurnedQueryForZeroAddress();
774         return uint256(_addressData[owner].numberBurned);
775     }
776 
777     /**
778      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
779      */
780     function _getAux(address owner) internal view returns (uint64) {
781         if (owner == address(0)) revert AuxQueryForZeroAddress();
782         return _addressData[owner].aux;
783     }
784 
785     /**
786      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
787      * If there are multiple variables, please pack them into a uint64.
788      */
789     function _setAux(address owner, uint64 aux) internal {
790         if (owner == address(0)) revert AuxQueryForZeroAddress();
791         _addressData[owner].aux = aux;
792     }
793 
794     /**
795      * Gas spent here starts off proportional to the maximum mint batch size.
796      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
797      */
798     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
799         uint256 curr = tokenId;
800 
801     unchecked {
802         if (_startTokenId() <= curr && curr < _currentIndex) {
803             TokenOwnership memory ownership = _ownerships[curr];
804             if (!ownership.burned) {
805                 if (ownership.addr != address(0)) {
806                     return ownership;
807                 }
808                 // Invariant:
809                 // There will always be an ownership that has an address and is not burned
810                 // before an ownership that does not have an address and is not burned.
811                 // Hence, curr will not underflow.
812                 while (true) {
813                     curr--;
814                     ownership = _ownerships[curr];
815                     if (ownership.addr != address(0)) {
816                         return ownership;
817                     }
818                 }
819             }
820         }
821     }
822         revert OwnerQueryForNonexistentToken();
823     }
824 
825     /**
826      * @dev See {IERC721-ownerOf}.
827      */
828     function ownerOf(uint256 tokenId) public view override returns (address) {
829         require(_exists(tokenId), "token not exist");
830         return ownershipOf(tokenId).addr;
831     }
832 
833     /**
834      * @dev See {IERC721Metadata-name}.
835      */
836     function name() public view virtual override returns (string memory) {
837         return _name;
838     }
839 
840     /**
841      * @dev See {IERC721Metadata-symbol}.
842      */
843     function symbol() public view virtual override returns (string memory) {
844         return _symbol;
845     }
846 
847     /**
848      * @dev See {IERC721Metadata-tokenURI}.
849      */
850     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
851         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
852 
853         string memory baseURI_ = baseURI();
854         return bytes(baseURI_).length != 0 ? string(abi.encodePacked(baseURI_, tokenId.toString())) : '';
855     }
856 
857     /**
858      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
859      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
860      * by default, can be overriden in child contracts.
861      */
862     function baseURI() internal view virtual returns (string memory) {
863         return _baseURI;
864     }
865 
866     /**
867      * @dev See {IERC721-approve}.
868      */
869     function approve(address to, uint256 tokenId) public override {
870         address owner = ERC721A.ownerOf(tokenId);
871         if (to == owner) revert ApprovalToCurrentOwner();
872 
873         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
874             revert ApprovalCallerNotOwnerNorApproved();
875         }
876 
877         _approve(to, tokenId, owner);
878     }
879 
880     /**
881      * @dev See {IERC721-getApproved}.
882      */
883     function getApproved(uint256 tokenId) public view override returns (address) {
884         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
885 
886         return _tokenApprovals[tokenId];
887     }
888 
889     /**
890      * @dev See {IERC721-setApprovalForAll}.
891      */
892     function setApprovalForAll(address operator, bool approved) public override {
893         if (operator == _msgSender()) revert ApproveToCaller();
894 
895         _operatorApprovals[_msgSender()][operator] = approved;
896         emit ApprovalForAll(_msgSender(), operator, approved);
897     }
898 
899     /**
900      * @dev See {IERC721-isApprovedForAll}.
901      */
902     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
903         return _operatorApprovals[owner][operator];
904     }
905 
906     /**
907      * @dev See {IERC721-transferFrom}.
908      */
909     function transferFrom(
910         address from,
911         address to,
912         uint256 tokenId
913     ) public virtual override {
914         _transfer(from, to, tokenId);
915     }
916 
917     /**
918      * @dev See {IERC721-safeTransferFrom}.
919      */
920     function safeTransferFrom(
921         address from,
922         address to,
923         uint256 tokenId
924     ) public virtual override {
925         safeTransferFrom(from, to, tokenId, '');
926     }
927 
928     /**
929      * @dev See {IERC721-safeTransferFrom}.
930      */
931     function safeTransferFrom(
932         address from,
933         address to,
934         uint256 tokenId,
935         bytes memory _data
936     ) public virtual override {
937         _transfer(from, to, tokenId);
938         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
939             revert TransferToNonERC721ReceiverImplementer();
940         }
941     }
942 
943     /**
944      * @dev Returns whether `tokenId` exists.
945      *
946      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
947      *
948      * Tokens start existing when they are minted (`_mint`),
949      */
950     function _exists(uint256 tokenId) internal view returns (bool) {
951         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
952         !_ownerships[tokenId].burned;
953     }
954 
955     function _safeMint(address to, uint256 quantity) internal {
956         _safeMint(to, quantity, '');
957     }
958 
959     /**
960      * @dev Safely mints `quantity` tokens and transfers them to `to`.
961      *
962      * Requirements:
963      *
964      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
965      * - `quantity` must be greater than 0.
966      *
967      * Emits a {Transfer} event.
968      */
969     function _safeMint(
970         address to,
971         uint256 quantity,
972         bytes memory _data
973     ) internal {
974         _mint(to, quantity, _data, true);
975     }
976 
977     /**
978      * @dev Mints `quantity` tokens and transfers them to `to`.
979      *
980      * Requirements:
981      *
982      * - `to` cannot be the zero address.
983      * - `quantity` must be greater than 0.
984      *
985      * Emits a {Transfer} event.
986      */
987     function _mint(
988         address to,
989         uint256 quantity,
990         bytes memory _data,
991         bool safe
992     ) internal {
993         uint256 startTokenId = _currentIndex;
994         if (to == address(0)) revert MintToZeroAddress();
995         if (quantity == 0) revert MintZeroQuantity();
996 
997         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
998 
999         // Overflows are incredibly unrealistic.
1000         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1001         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1002     unchecked {
1003         _addressData[to].balance += uint64(quantity);
1004         _addressData[to].numberMinted += uint64(quantity);
1005 
1006         _ownerships[startTokenId].addr = to;
1007         _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1008 
1009         uint256 updatedIndex = startTokenId;
1010         uint256 end = updatedIndex + quantity;
1011 
1012         if (safe && to.isContract()) {
1013             do {
1014                 emit Transfer(address(0), to, updatedIndex);
1015                 if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1016                     revert TransferToNonERC721ReceiverImplementer();
1017                 }
1018             }
1019             while (updatedIndex != end);
1020             // Reentrancy protection
1021             if (_currentIndex != startTokenId) revert();
1022         } else {
1023             do {
1024                 emit Transfer(address(0), to, updatedIndex++);
1025             }
1026             while (updatedIndex != end);
1027         }
1028         _currentIndex = updatedIndex;
1029     }
1030         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1031     }
1032 
1033     /**
1034      * @dev Transfers `tokenId` from `from` to `to`.
1035      *
1036      * Requirements:
1037      *
1038      * - `to` cannot be the zero address.
1039      * - `tokenId` token must be owned by `from`.
1040      *
1041      * Emits a {Transfer} event.
1042      */
1043     function _transfer(
1044         address from,
1045         address to,
1046         uint256 tokenId
1047     ) private {
1048         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1049 
1050         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1051         isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1052         getApproved(tokenId) == _msgSender());
1053 
1054         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1055         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1056         if (to == address(0)) revert TransferToZeroAddress();
1057 
1058         _beforeTokenTransfers(from, to, tokenId, 1);
1059 
1060         // Clear approvals from the previous owner
1061         _approve(address(0), tokenId, prevOwnership.addr);
1062 
1063         // Underflow of the sender's balance is impossible because we check for
1064         // ownership above and the recipient's balance can't realistically overflow.
1065         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1066     unchecked {
1067         _addressData[from].balance -= 1;
1068         _addressData[to].balance += 1;
1069 
1070         _ownerships[tokenId].addr = to;
1071         _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1072 
1073         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1074         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1075         uint256 nextTokenId = tokenId + 1;
1076         if (_ownerships[nextTokenId].addr == address(0)) {
1077             // This will suffice for checking _exists(nextTokenId),
1078             // as a burned slot cannot contain the zero address.
1079             if (nextTokenId < _currentIndex) {
1080                 _ownerships[nextTokenId].addr = prevOwnership.addr;
1081                 _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1082             }
1083         }
1084     }
1085 
1086         emit Transfer(from, to, tokenId);
1087         _afterTokenTransfers(from, to, tokenId, 1);
1088     }
1089 
1090     /**
1091      * @dev Destroys `tokenId`.
1092      * The approval is cleared when the token is burned.
1093      *
1094      * Requirements:
1095      *
1096      * - `tokenId` must exist.
1097      *
1098      * Emits a {Transfer} event.
1099      */
1100     function _burn(uint256 tokenId) internal virtual {
1101         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1102 
1103         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1104 
1105         // Clear approvals from the previous owner
1106         _approve(address(0), tokenId, prevOwnership.addr);
1107 
1108         // Underflow of the sender's balance is impossible because we check for
1109         // ownership above and the recipient's balance can't realistically overflow.
1110         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1111     unchecked {
1112         _addressData[prevOwnership.addr].balance -= 1;
1113         _addressData[prevOwnership.addr].numberBurned += 1;
1114 
1115         // Keep track of who burned the token, and the timestamp of burning.
1116         _ownerships[tokenId].addr = prevOwnership.addr;
1117         _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1118         _ownerships[tokenId].burned = true;
1119 
1120         // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1121         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1122         uint256 nextTokenId = tokenId + 1;
1123         if (_ownerships[nextTokenId].addr == address(0)) {
1124             // This will suffice for checking _exists(nextTokenId),
1125             // as a burned slot cannot contain the zero address.
1126             if (nextTokenId < _currentIndex) {
1127                 _ownerships[nextTokenId].addr = prevOwnership.addr;
1128                 _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1129             }
1130         }
1131     }
1132 
1133         emit Transfer(prevOwnership.addr, address(0), tokenId);
1134         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1135 
1136         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1137     unchecked {
1138         _burnCounter++;
1139     }
1140     }
1141 
1142     /**
1143      * @dev Approve `to` to operate on `tokenId`
1144      *
1145      * Emits a {Approval} event.
1146      */
1147     function _approve(
1148         address to,
1149         uint256 tokenId,
1150         address owner
1151     ) private {
1152         _tokenApprovals[tokenId] = to;
1153         emit Approval(owner, to, tokenId);
1154     }
1155 
1156     /**
1157      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1158      *
1159      * @param from address representing the previous owner of the given token ID
1160      * @param to target address that will receive the tokens
1161      * @param tokenId uint256 ID of the token to be transferred
1162      * @param _data bytes optional data to send along with the call
1163      * @return bool whether the call correctly returned the expected magic value
1164      */
1165     function _checkContractOnERC721Received(
1166         address from,
1167         address to,
1168         uint256 tokenId,
1169         bytes memory _data
1170     ) private returns (bool) {
1171         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1172             return retval == IERC721Receiver(to).onERC721Received.selector;
1173         } catch (bytes memory reason) {
1174             if (reason.length == 0) {
1175                 revert TransferToNonERC721ReceiverImplementer();
1176             } else {
1177                 assembly {
1178                     revert(add(32, reason), mload(reason))
1179                 }
1180             }
1181         }
1182     }
1183 
1184     /**
1185      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1186      * And also called before burning one token.
1187      *
1188      * startTokenId - the first token id to be transferred
1189      * quantity - the amount to be transferred
1190      *
1191      * Calling conditions:
1192      *
1193      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1194      * transferred to `to`.
1195      * - When `from` is zero, `tokenId` will be minted for `to`.
1196      * - When `to` is zero, `tokenId` will be burned by `from`.
1197      * - `from` and `to` are never both zero.
1198      */
1199     function _beforeTokenTransfers(
1200         address from,
1201         address to,
1202         uint256 startTokenId,
1203         uint256 quantity
1204     ) internal virtual {}
1205 
1206     /**
1207      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1208      * minting.
1209      * And also called after one token has been burned.
1210      *
1211      * startTokenId - the first token id to be transferred
1212      * quantity - the amount to be transferred
1213      *
1214      * Calling conditions:
1215      *
1216      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1217      * transferred to `to`.
1218      * - When `from` is zero, `tokenId` has been minted for `to`.
1219      * - When `to` is zero, `tokenId` has been burned by `from`.
1220      * - `from` and `to` are never both zero.
1221      */
1222     function _afterTokenTransfers(
1223         address from,
1224         address to,
1225         uint256 startTokenId,
1226         uint256 quantity
1227     ) internal virtual {}
1228 }
1229 
1230 /**
1231  * @dev Contract module which provides a basic access control mechanism, where
1232  * there is an account (an owner) that can be granted exclusive access to
1233  * specific functions.
1234  *
1235  * By default, the owner account will be the one that deploys the contract. This
1236  * can later be changed with {transferOwnership}.
1237  *
1238  * This module is used through inheritance. It will make available the modifier
1239  * `onlyOwner`, which can be applied to your functions to restrict their use to
1240  * the owner.
1241  */
1242 abstract contract Ownable is Context {
1243     address private _owner;
1244 
1245     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1246     /**
1247      * @dev Initializes the contract setting the deployer as the initial owner.
1248      */
1249     constructor ()  {
1250         address msgSender = _msgSender();
1251         _owner = msgSender;
1252         emit OwnershipTransferred(address(0), msgSender);
1253     }
1254     /**
1255      * @dev Returns the address of the current owner.
1256      */
1257     function owner() public view virtual returns (address) {
1258         return _owner;
1259     }
1260     /**
1261      * @dev Throws if called by any account other than the owner.
1262      */
1263     modifier onlyOwner() {
1264         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1265         _;
1266     }
1267     /**
1268      * @dev Leaves the contract without owner. It will not be possible to call
1269      * `onlyOwner` functions anymore. Can only be called by the current owner.
1270      *
1271      * NOTE: Renouncing ownership will leave the contract without an owner,
1272      * thereby removing any functionality that is only available to the owner.
1273      */
1274     function renounceOwnership() public virtual onlyOwner {
1275         emit OwnershipTransferred(_owner, address(0));
1276         _owner = address(0);
1277     }
1278     /**
1279      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1280      * Can only be called by the current owner.
1281      */
1282     function transferOwnership(address newOwner) public virtual onlyOwner {
1283         require(newOwner != address(0), "Ownable: new owner is the zero address");
1284         emit OwnershipTransferred(_owner, newOwner);
1285         _owner = newOwner;
1286     }
1287 }
1288 
1289 abstract contract OwnerCheck is Ownable {
1290     mapping(address => bool) public operatorMap;
1291     uint8 private unlocked = 1;
1292 
1293     event SetOperator(address addr, bool auth);
1294 
1295     modifier onlyOperator() {
1296         require(isOperator(msg.sender), "caller is not the operator");
1297         _;
1298     }
1299 
1300     modifier lock() {
1301         require(unlocked == 1, 'Contract: LOCKED');
1302         unlocked = 0;
1303         _;
1304         unlocked = 1;
1305     }
1306 
1307     function setOperator(address addr, bool auth) public onlyOwner {
1308         operatorMap[addr] = auth;
1309         emit SetOperator(addr, auth);
1310     }
1311 
1312     function isOperator(address addr) public view returns (bool) {
1313         return operatorMap[addr];
1314     }
1315 
1316 }
1317 
1318 interface IERC20 {
1319     function transfer(address recipient, uint256 amount) external returns (bool);
1320 
1321     function transferFrom(
1322         address sender,
1323         address recipient,
1324         uint256 amount
1325     ) external returns (bool);
1326 }
1327 
1328 library SafeERC20 {
1329     using Address for address;
1330 
1331     function safeTransfer(
1332         IERC20 token,
1333         address to,
1334         uint256 value
1335     ) internal {
1336         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1337     }
1338 
1339     function safeTransferFrom(
1340         IERC20 token,
1341         address from,
1342         address to,
1343         uint256 value
1344     ) internal {
1345         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1346     }
1347 
1348     /**
1349      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1350      * on the return value: the return value is optional (but if data is returned, it must not be false).
1351      * @param token The token targeted by the call.
1352      * @param data The call data (encoded using abi.encode or one of its variants).
1353      */
1354     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1355         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1356         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1357         // the target address contains contract code and also asserts for success in the low-level call.
1358 
1359         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1360         if (returndata.length > 0) {
1361             // Return data is optional
1362             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1363         }
1364     }
1365 }
1366 
1367 library EnumerableSet {
1368     // To implement this library for multiple types with as little code
1369     // repetition as possible, we write it in terms of a generic Set type with
1370     // bytes32 values.
1371     // The Set implementation uses private functions, and user-facing
1372     // implementations (such as AddressSet) are just wrappers around the
1373     // underlying Set.
1374     // This means that we can only create new EnumerableSets for types that fit
1375     // in bytes32.
1376 
1377     struct Set {
1378         // Storage of set values
1379         bytes32[] _values;
1380 
1381         // Position of the value in the `values` array, plus 1 because index 0
1382         // means a value is not in the set.
1383         mapping(bytes32 => uint256) _indexes;
1384     }
1385 
1386     /**
1387      * @dev Add a value to a set. O(1).
1388      *
1389      * Returns true if the value was added to the set, that is if it was not
1390      * already present.
1391      */
1392     function _add(Set storage set, bytes32 value) private returns (bool) {
1393         if (!_contains(set, value)) {
1394             set._values.push(value);
1395             // The value is stored at length-1, but we add 1 to all indexes
1396             // and use 0 as a sentinel value
1397             set._indexes[value] = set._values.length;
1398             return true;
1399         } else {
1400             return false;
1401         }
1402     }
1403 
1404     /**
1405      * @dev Removes a value from a set. O(1).
1406      *
1407      * Returns true if the value was removed from the set, that is if it was
1408      * present.
1409      */
1410     function _remove(Set storage set, bytes32 value) private returns (bool) {
1411         // We read and store the value's index to prevent multiple reads from the same storage slot
1412         uint256 valueIndex = set._indexes[value];
1413 
1414         if (valueIndex != 0) {// Equivalent to contains(set, value)
1415             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1416             // the array, and then remove the last element (sometimes called as 'swap and pop').
1417             // This modifies the order of the array, as noted in {at}.
1418 
1419             uint256 toDeleteIndex = valueIndex - 1;
1420             uint256 lastIndex = set._values.length - 1;
1421 
1422             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1423             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1424 
1425             bytes32 lastvalue = set._values[lastIndex];
1426 
1427             // Move the last value to the index where the value to delete is
1428             set._values[toDeleteIndex] = lastvalue;
1429             // Update the index for the moved value
1430             set._indexes[lastvalue] = toDeleteIndex + 1;
1431             // All indexes are 1-based
1432 
1433             // Delete the slot where the moved value was stored
1434             set._values.pop();
1435 
1436             // Delete the index for the deleted slot
1437             delete set._indexes[value];
1438 
1439             return true;
1440         } else {
1441             return false;
1442         }
1443     }
1444 
1445     /**
1446      * @dev Returns true if the value is in the set. O(1).
1447      */
1448     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1449         return set._indexes[value] != 0;
1450     }
1451 
1452     /**
1453      * @dev Returns the number of values on the set. O(1).
1454      */
1455     function _length(Set storage set) private view returns (uint256) {
1456         return set._values.length;
1457     }
1458 
1459     /**
1460      * @dev Returns the value stored at position `index` in the set. O(1).
1461     *
1462     * Note that there are no guarantees on the ordering of values inside the
1463     * array, and it may change when more values are added or removed.
1464     *
1465     * Requirements:
1466     *
1467     * - `index` must be strictly less than {length}.
1468     */
1469     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1470         require(set._values.length > index, "EnumerableSet: index out of bounds");
1471         return set._values[index];
1472     }
1473 
1474     // Bytes32Set
1475 
1476     struct Bytes32Set {
1477         Set _inner;
1478     }
1479 
1480     /**
1481      * @dev Add a value to a set. O(1).
1482      *
1483      * Returns true if the value was added to the set, that is if it was not
1484      * already present.
1485      */
1486     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1487         return _add(set._inner, value);
1488     }
1489 
1490     /**
1491      * @dev Removes a value from a set. O(1).
1492      *
1493      * Returns true if the value was removed from the set, that is if it was
1494      * present.
1495      */
1496     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1497         return _remove(set._inner, value);
1498     }
1499 
1500     /**
1501      * @dev Returns true if the value is in the set. O(1).
1502      */
1503     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1504         return _contains(set._inner, value);
1505     }
1506 
1507     /**
1508      * @dev Returns the number of values in the set. O(1).
1509      */
1510     function length(Bytes32Set storage set) internal view returns (uint256) {
1511         return _length(set._inner);
1512     }
1513 
1514     /**
1515      * @dev Returns the value stored at position `index` in the set. O(1).
1516     *
1517     * Note that there are no guarantees on the ordering of values inside the
1518     * array, and it may change when more values are added or removed.
1519     *
1520     * Requirements:
1521     *
1522     * - `index` must be strictly less than {length}.
1523     */
1524     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1525         return _at(set._inner, index);
1526     }
1527 
1528     // AddressSet
1529 
1530     struct AddressSet {
1531         Set _inner;
1532     }
1533 
1534     /**
1535      * @dev Add a value to a set. O(1).
1536      *
1537      * Returns true if the value was added to the set, that is if it was not
1538      * already present.
1539      */
1540     function add(AddressSet storage set, address value) internal returns (bool) {
1541         return _add(set._inner, bytes32(uint256(uint160(value))));
1542     }
1543 
1544     /**
1545      * @dev Removes a value from a set. O(1).
1546      *
1547      * Returns true if the value was removed from the set, that is if it was
1548      * present.
1549      */
1550     function remove(AddressSet storage set, address value) internal returns (bool) {
1551         return _remove(set._inner, bytes32(uint256(uint160(value))));
1552     }
1553 
1554     /**
1555      * @dev Returns true if the value is in the set. O(1).
1556      */
1557     function contains(AddressSet storage set, address value) internal view returns (bool) {
1558         return _contains(set._inner, bytes32(uint256(uint160(value))));
1559     }
1560 
1561     /**
1562      * @dev Returns the number of values in the set. O(1).
1563      */
1564     function length(AddressSet storage set) internal view returns (uint256) {
1565         return _length(set._inner);
1566     }
1567 
1568     /**
1569      * @dev Returns the value stored at position `index` in the set. O(1).
1570     *
1571     * Note that there are no guarantees on the ordering of values inside the
1572     * array, and it may change when more values are added or removed.
1573     *
1574     * Requirements:
1575     *
1576     * - `index` must be strictly less than {length}.
1577     */
1578     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1579         return address(uint160(uint256(_at(set._inner, index))));
1580     }
1581 
1582 
1583     // UintSet
1584 
1585     struct UintSet {
1586         Set _inner;
1587     }
1588 
1589     /**
1590      * @dev Add a value to a set. O(1).
1591      *
1592      * Returns true if the value was added to the set, that is if it was not
1593      * already present.
1594      */
1595     function add(UintSet storage set, uint256 value) internal returns (bool) {
1596         return _add(set._inner, bytes32(value));
1597     }
1598 
1599     /**
1600      * @dev Removes a value from a set. O(1).
1601      *
1602      * Returns true if the value was removed from the set, that is if it was
1603      * present.
1604      */
1605     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1606         return _remove(set._inner, bytes32(value));
1607     }
1608 
1609     /**
1610      * @dev Returns true if the value is in the set. O(1).
1611      */
1612     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1613         return _contains(set._inner, bytes32(value));
1614     }
1615 
1616     /**
1617      * @dev Returns the number of values on the set. O(1).
1618      */
1619     function length(UintSet storage set) internal view returns (uint256) {
1620         return _length(set._inner);
1621     }
1622 
1623     /**
1624      * @dev Returns the value stored at position `index` in the set. O(1).
1625     *
1626     * Note that there are no guarantees on the ordering of values inside the
1627     * array, and it may change when more values are added or removed.
1628     *
1629     * Requirements:
1630     *
1631     * - `index` must be strictly less than {length}.
1632     */
1633     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1634         return uint256(_at(set._inner, index));
1635     }
1636 }
1637 
1638 interface IProps is IERC721 {
1639     function currentIndex() external view returns (uint256);
1640 
1641     function mint(address to, uint256 count) external;
1642 }
1643 
1644 contract Dialoger is ERC721A, OwnerCheck {
1645     using SafeMath for uint256;
1646     using Strings for uint256;
1647     using SafeERC20 for IERC20;
1648     using EnumerableSet for EnumerableSet.UintSet;
1649 
1650     //pack to one slot
1651     bool public publicSales = false;
1652     address public signer = 0xB82Dda08bFcE8C51F1e37ebE9bc8D7d4Bc0547Ba;
1653     address payable public ethBeneficiary = payable(0xB50bFA113D7A6B44c1857866e06F0B5483D7B92e);
1654     address public metaBeneficiary = 0x2848562b3fabA0C03A24a0369ce19D6B69fEbBAb;
1655     uint8 public preSaleCountOnce = 3;
1656     uint8 public publicSaleCountOnce = 10;
1657     uint16 public maxCount = 10000;
1658     uint32 public REVEAL_TIMESTAMP;
1659     IERC20 public metaToken = IERC20(0x364fcd7325C035CC4F2cdE8b6c8D7Df5e7Db6589);
1660     IProps public props;
1661     uint32 public hour48 = 60 * 60 * 48;
1662 
1663     string public PROVENANCE;
1664     uint256 public price = 0.35e18;
1665     //card id include dialoger and props,dialoger cardId 1-10000,props cardId>=20000
1666     mapping(address => EnumerableSet.UintSet) private lockCardIds;
1667     mapping(uint256 => uint256) public lockTime;
1668     mapping(address => uint256) public alreadyMinted;
1669     mapping(address => uint256) public nonce;
1670 
1671     event PublicSale(address user, uint256 start, uint8 count);
1672     event PreSale(address user, uint256 start, uint256 count);
1673     event MintProps(address user, uint256 cardId, uint256 pay, uint32[] depositCardIds, uint32[] existCardIds);
1674     event LockCard(address user, uint32[] cardIds);
1675     event UnlockCard(address user, uint32[] cardIds);
1676 
1677     constructor(string memory _name, string memory _symbol) ERC721A(_name, _symbol) {
1678         _setBaseURI("https://storage.googleapis.com/");
1679     }
1680 
1681     function mintProps(uint32[] calldata depositCardIds, uint32[] calldata existCardIds, bytes32 r, bytes32 s, uint8 v, uint256 mintPrice) external lock {
1682         uint8 count = uint8(depositCardIds.length + existCardIds.length);
1683         address sender = msg.sender;
1684         require(signer == ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(sender, block.chainid, address(this), count, mintPrice, nonce[sender])))), v, r, s), "sign");
1685         nonce[sender]++;
1686         //transfer dialoger and props card here first
1687         lockCardIn(sender, depositCardIds);
1688         checkCard(sender, existCardIds);
1689 
1690         metaToken.safeTransferFrom(sender, metaBeneficiary, mintPrice);
1691 
1692         uint256 cardId = props.currentIndex();
1693         props.mint(sender, count);
1694         emit MintProps(sender, cardId, mintPrice, depositCardIds, existCardIds);
1695     }
1696 
1697     function checkCard(address sender, uint32[] calldata cardIds) private {
1698         for (uint i = 0; i < cardIds.length; i++) {
1699             uint256 card = uint256(cardIds[i]);
1700             require(lockCardIds[sender].contains(card), "not own");
1701             require((lockTime[card] + hour48) < uint32(block.timestamp), "cannot use");
1702             lockTime[card] = uint32(block.timestamp);
1703         }
1704     }
1705 
1706     function lockCardIn(address sender, uint32[] calldata cardIds) private {
1707         for (uint256 i = 0; i < cardIds.length; i++) {
1708             uint256 cardId = uint256(cardIds[i]);
1709             if (cardId < _currentIndex) {
1710                 safeTransferFrom(sender, address(this), cardId);
1711             } else {
1712                 props.safeTransferFrom(sender, address(this), cardId);
1713             }
1714 
1715             lockCardIds[sender].add(cardId);
1716             lockTime[cardId] = block.timestamp;
1717         }
1718     }
1719 
1720     function unlockCard(uint32[] calldata cardIds) public lock {
1721         address sender = msg.sender;
1722         for (uint i = 0; i < cardIds.length; i++) {
1723             uint256 cardId = uint256(cardIds[i]);
1724             require(lockCardIds[sender].contains(cardId), "not contain this card");
1725             require(lockTime[cardId] + hour48 < block.timestamp, "cannot unlock");
1726             require(lockCardIds[sender].remove(cardId), "remove false");
1727             delete lockTime[cardId];
1728 
1729             if (cardId < _currentIndex) {
1730                 this.safeTransferFrom(address(this), sender, cardId);
1731             } else {
1732                 props.safeTransferFrom(address(this), sender, cardId);
1733             }
1734         }
1735         emit UnlockCard(sender, cardIds);
1736     }
1737 
1738     function preSale(bytes32 r, bytes32 s, uint8 v, uint8 count) external payable lock {
1739         require(!publicSales && (totalSupply() <= maxCount), "not started or stopped");
1740 
1741         address sender = msg.sender;
1742         require(uint8(alreadyMinted[sender]) + count <= preSaleCountOnce, 'minted');
1743 
1744         require(signer == ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(sender, block.chainid, address(this), count)))), v, r, s), "sign");
1745 
1746         alreadyMinted[sender] += uint256(count);
1747         uint256 needPay = price * count;
1748         require(needPay == msg.value, 'eth wrong');
1749         ethBeneficiary.transfer(needPay);
1750         uint256 cardId = totalSupply() + 1;
1751         _mint(sender, count, new bytes(0), false);
1752         emit PreSale(sender, cardId, count);
1753     }
1754 
1755     function publicSale(uint8 count) external payable lock {
1756         require(publicSales && (totalSupply() <= maxCount), "not start or sold out");
1757         address sender = msg.sender;
1758         uint256 cardId = totalSupply() + 1;
1759         require(count <= publicSaleCountOnce, "too much");
1760 
1761         uint256 needPay = price * count;
1762         require(needPay == msg.value, 'eth wrong');
1763         ethBeneficiary.transfer(needPay);
1764 
1765         _mint(sender, count, new bytes(0), false);
1766         emit PublicSale(sender, cardId, count);
1767     }
1768 
1769     function mint(address to, uint256 count) external onlyOperator {
1770         _mint(to, count, new bytes(0), false);
1771     }
1772 
1773     function setBaseTokenURI(string memory baseTokenURI) external onlyOperator {
1774         _setBaseURI(baseTokenURI);
1775     }
1776 
1777     function getBaseURI() public view returns (string memory){
1778         return baseURI();
1779     }
1780 
1781     function getLockCardLength(address user) public view returns (uint){
1782         return lockCardIds[user].length();
1783     }
1784 
1785     function getLockCardId(address user, uint cardIndex) public view returns (uint){
1786         return lockCardIds[user].at(cardIndex);
1787     }
1788 
1789     function getLockCard(address user) public view returns (uint[] memory ret){
1790         uint len = lockCardIds[user].length();
1791         ret = new uint[](len);
1792         for (uint i = 0; i < len; i++) {
1793             ret[i] = lockCardIds[user].at(i);
1794         }
1795     }
1796 
1797     function getCanUsed(address user) public view returns (uint[] memory ret){
1798         uint len = lockCardIds[user].length();
1799         uint[] memory temp = new uint[](len);
1800         uint count;
1801         for (uint i = 0; i < len; i++) {
1802             uint card = lockCardIds[user].at(i);
1803             if (lockTime[card] + hour48 < block.timestamp) {
1804                 temp[i] = card;
1805                 count++;
1806             }
1807         }
1808         ret = new uint[](count);
1809         uint j = 0;
1810         for (uint i = 0; i < len; i++) {
1811             if (temp[i] > 0) {
1812                 ret[j] = temp[i];
1813                 j++;
1814             }
1815         }
1816     }
1817 
1818     function setPrice(uint256 _price) external onlyOperator {
1819         price = _price;
1820     }
1821 
1822     function setBeneficiary(address payable _ethBeneficiary, address _metaBeneficiary) external onlyOperator {
1823         ethBeneficiary = _ethBeneficiary;
1824         metaBeneficiary = _metaBeneficiary;
1825     }
1826 
1827     function setSigner(address _signer) external onlyOperator {
1828         signer = _signer;
1829     }
1830 
1831     function setPublicSales(bool _publicSales) external onlyOperator {
1832         publicSales = _publicSales;
1833     }
1834 
1835     function setPreSaleCountOnce(uint8 _preSaleCountOnce) external onlyOperator {
1836         preSaleCountOnce = _preSaleCountOnce;
1837     }
1838 
1839     function setPublicSaleCountOnce(uint8 _publicSaleCountOnce) external onlyOperator {
1840         publicSaleCountOnce = _publicSaleCountOnce;
1841     }
1842 
1843     function setMaxCount(uint16 _maxCount) external onlyOperator {
1844         maxCount = _maxCount;
1845     }
1846 
1847     function setProps(IProps _props) external onlyOperator {
1848         props = _props;
1849     }
1850 
1851     function setMetaToken(IERC20 _metaToken) external onlyOperator {
1852         metaToken = _metaToken;
1853     }
1854 
1855     function setHour48(uint32 _hour48) external onlyOperator {
1856         hour48 = _hour48;
1857     }
1858 
1859     function onERC721Received(
1860         address,
1861         address,
1862         uint256,
1863         bytes memory
1864     ) public pure returns (bytes4) {
1865         return this.onERC721Received.selector;
1866     }
1867 
1868     function setRevealTimestamp(uint32 revealTimeStamp) public onlyOperator {
1869         REVEAL_TIMESTAMP = revealTimeStamp;
1870     }
1871 
1872     function setProvenanceHash(string memory provenanceHash) public onlyOperator {
1873         PROVENANCE = provenanceHash;
1874     }
1875 }