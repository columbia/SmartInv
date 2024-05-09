1 // File: @openzeppelin/contracts/utils/Counters.sol
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @title Counters
6  * @author Matt Condon (@shrugs)
7  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
8  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
9  *
10  * Include with `using Counters for Counters.Counter;`
11  */
12 library Counters {
13     struct Counter {
14         // This variable should never be directly accessed by users of the library: interactions must be restricted to
15         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
16         // this feature: see https://github.com/ethereum/solidity/issues/4637
17         uint256 _value; // default: 0
18     }
19 
20     function current(Counter storage counter) internal view returns (uint256) {
21         return counter._value;
22     }
23 
24     function increment(Counter storage counter) internal {
25         unchecked {
26             counter._value += 1;
27         }
28     }
29 
30     function decrement(Counter storage counter) internal {
31         uint256 value = counter._value;
32         require(value > 0, "Counter: decrement overflow");
33         unchecked {
34             counter._value = value - 1;
35         }
36     }
37 
38     function reset(Counter storage counter) internal {
39         counter._value = 0;
40     }
41 }
42 
43 // File: contracts/WithLimitedSupply.sol
44 
45 
46 pragma solidity ^0.8.0;
47 
48 
49 /// @author 1001.digital 
50 /// @title A token tracker that limits the token supply and increments token IDs on each new mint.
51 abstract contract WithLimitedSupply {
52     using Counters for Counters.Counter;
53 
54     // Keeps track of how many we have minted
55     Counters.Counter private _tokenCount;
56 
57     /// @dev The maximum count of tokens this token tracker will hold.
58     uint256 private _maxSupply;
59 
60     /// Instanciate the contract
61     /// @param totalSupply_ how many tokens this collection should hold
62     constructor (uint256 totalSupply_) {
63         _maxSupply = totalSupply_;
64     }
65 
66     /// @dev Get the max Supply
67     /// @return the maximum token count
68     function maxSupply() public view returns (uint256) {
69         return _maxSupply;
70     }
71 
72     /// @dev Get the current token count
73     /// @return the created token count
74     function tokenCount() public view returns (uint256) {
75         return _tokenCount.current();
76     }
77 
78     /// @dev Check whether tokens are still available
79     /// @return the available token count
80     function availableTokenCount() public view returns (uint256) {
81         return maxSupply() - tokenCount();
82     }
83 
84     /// @dev Increment the token count and fetch the latest count
85     /// @return the next token id
86     function nextToken() internal virtual ensureAvailability returns (uint256) {
87         uint256 token = _tokenCount.current();
88 
89         _tokenCount.increment();
90 
91         return token;
92     }
93 
94     /// @dev Check whether another token is still available
95     modifier ensureAvailability() {
96         require(availableTokenCount() > 0, "No more tokens available");
97         _;
98     }
99 
100     /// @param amount Check whether number of tokens are still available
101     /// @dev Check whether tokens are still available
102     modifier ensureAvailabilityFor(uint256 amount) {
103         require(availableTokenCount() >= amount, "Requested number of tokens not available");
104         _;
105     }
106 }
107 // File: contracts/RandomlyAssigned.sol
108 
109 
110 pragma solidity ^0.8.0;
111 
112 
113 /// @author 1001.digital
114 /// @title Randomly assign tokenIDs from a given set of tokens.
115 abstract contract RandomlyAssigned is WithLimitedSupply {
116     // Used for random index assignment
117     mapping(uint256 => uint256) private tokenMatrix;
118 
119     // The initial token ID
120     uint256 private startFrom;
121 
122     /// Instanciate the contract
123     /// @param _maxSupply how many tokens this collection should hold
124     /// @param _startFrom the tokenID with which to start counting
125     constructor (uint256 _maxSupply, uint256 _startFrom)
126         WithLimitedSupply(_maxSupply)
127     {
128         startFrom = _startFrom;
129     }
130 
131     /// Get the next token ID
132     /// @dev Randomly gets a new token ID and keeps track of the ones that are still available.
133     /// @return the next token ID
134     function nextToken() internal override ensureAvailability returns (uint256) {
135         uint256 maxIndex = maxSupply() - tokenCount();
136         uint256 random = uint256(keccak256(
137             abi.encodePacked(
138                 msg.sender,
139                 block.coinbase,
140                 block.difficulty,
141                 block.gaslimit,
142                 block.timestamp
143             )
144         )) % maxIndex;
145 
146         uint256 value = 0;
147         if (tokenMatrix[random] == 0) {
148             // If this matrix position is empty, set the value to the generated random number.
149             value = random;
150         } else {
151             // Otherwise, use the previously stored number from the matrix.
152             value = tokenMatrix[random];
153         }
154 
155         // If the last available tokenID is still unused...
156         if (tokenMatrix[maxIndex - 1] == 0) {
157             // ...store that ID in the current matrix position.
158             tokenMatrix[random] = maxIndex - 1;
159         } else {
160             // ...otherwise copy over the stored number to the current matrix position.
161             tokenMatrix[random] = tokenMatrix[maxIndex - 1];
162         }
163 
164         // Increment counts
165         super.nextToken();
166 
167         return value + startFrom;
168     }
169 }
170 
171 // File: @openzeppelin/contracts/utils/Context.sol
172 
173 
174 
175 pragma solidity ^0.8.0;
176 
177 /**
178  * @dev Provides information about the current execution context, including the
179  * sender of the transaction and its data. While these are generally available
180  * via msg.sender and msg.data, they should not be accessed in such a direct
181  * manner, since when dealing with meta-transactions the account sending and
182  * paying for execution may not be the actual sender (as far as an application
183  * is concerned).
184  *
185  * This contract is only required for intermediate, library-like contracts.
186  */
187 abstract contract Context {
188     function _msgSender() internal view virtual returns (address) {
189         return msg.sender;
190     }
191 
192     function _msgData() internal view virtual returns (bytes calldata) {
193         return msg.data;
194     }
195 }
196 
197 // File: @openzeppelin/contracts/access/Ownable.sol
198 
199 
200 
201 pragma solidity ^0.8.0;
202 
203 
204 /**
205  * @dev Contract module which provides a basic access control mechanism, where
206  * there is an account (an owner) that can be granted exclusive access to
207  * specific functions.
208  *
209  * By default, the owner account will be the one that deploys the contract. This
210  * can later be changed with {transferOwnership}.
211  *
212  * This module is used through inheritance. It will make available the modifier
213  * `onlyOwner`, which can be applied to your functions to restrict their use to
214  * the owner.
215  */
216 abstract contract Ownable is Context {
217     address private _owner;
218 
219     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
220 
221     /**
222      * @dev Initializes the contract setting the deployer as the initial owner.
223      */
224     constructor() {
225         _setOwner(_msgSender());
226     }
227 
228     /**
229      * @dev Returns the address of the current owner.
230      */
231     function owner() public view virtual returns (address) {
232         return _owner;
233     }
234 
235     /**
236      * @dev Throws if called by any account other than the owner.
237      */
238     modifier onlyOwner() {
239         require(owner() == _msgSender(), "Ownable: caller is not the owner");
240         _;
241     }
242 
243     /**
244      * @dev Leaves the contract without owner. It will not be possible to call
245      * `onlyOwner` functions anymore. Can only be called by the current owner.
246      *
247      * NOTE: Renouncing ownership will leave the contract without an owner,
248      * thereby removing any functionality that is only available to the owner.
249      */
250     function renounceOwnership() public virtual onlyOwner {
251         _setOwner(address(0));
252     }
253 
254     /**
255      * @dev Transfers ownership of the contract to a new account (`newOwner`).
256      * Can only be called by the current owner.
257      */
258     function transferOwnership(address newOwner) public virtual onlyOwner {
259         require(newOwner != address(0), "Ownable: new owner is the zero address");
260         _setOwner(newOwner);
261     }
262 
263     function _setOwner(address newOwner) private {
264         address oldOwner = _owner;
265         _owner = newOwner;
266         emit OwnershipTransferred(oldOwner, newOwner);
267     }
268 }
269 
270 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
271 
272 
273 
274 pragma solidity ^0.8.0;
275 
276 /**
277  * @dev Interface of the ERC165 standard, as defined in the
278  * https://eips.ethereum.org/EIPS/eip-165[EIP].
279  *
280  * Implementers can declare support of contract interfaces, which can then be
281  * queried by others ({ERC165Checker}).
282  *
283  * For an implementation, see {ERC165}.
284  */
285 interface IERC165 {
286     /**
287      * @dev Returns true if this contract implements the interface defined by
288      * `interfaceId`. See the corresponding
289      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
290      * to learn more about how these ids are created.
291      *
292      * This function call must use less than 30 000 gas.
293      */
294     function supportsInterface(bytes4 interfaceId) external view returns (bool);
295 }
296 
297 
298 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
299 
300 
301 
302 pragma solidity ^0.8.0;
303 
304 
305 /**
306  * @dev Required interface of an ERC721 compliant contract.
307  */
308 interface IERC721 is IERC165 {
309     /**
310      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
311      */
312     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
313 
314     /**
315      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
316      */
317     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
318 
319     /**
320      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
321      */
322     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
323 
324     /**
325      * @dev Returns the number of tokens in ``owner``'s account.
326      */
327     function balanceOf(address owner) external view returns (uint256 balance);
328 
329     /**
330      * @dev Returns the owner of the `tokenId` token.
331      *
332      * Requirements:
333      *
334      * - `tokenId` must exist.
335      */
336     function ownerOf(uint256 tokenId) external view returns (address owner);
337 
338     /**
339      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
340      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
341      *
342      * Requirements:
343      *
344      * - `from` cannot be the zero address.
345      * - `to` cannot be the zero address.
346      * - `tokenId` token must exist and be owned by `from`.
347      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
348      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
349      *
350      * Emits a {Transfer} event.
351      */
352     function safeTransferFrom(
353         address from,
354         address to,
355         uint256 tokenId
356     ) external;
357 
358     /**
359      * @dev Transfers `tokenId` token from `from` to `to`.
360      *
361      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
362      *
363      * Requirements:
364      *
365      * - `from` cannot be the zero address.
366      * - `to` cannot be the zero address.
367      * - `tokenId` token must be owned by `from`.
368      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
369      *
370      * Emits a {Transfer} event.
371      */
372     function transferFrom(
373         address from,
374         address to,
375         uint256 tokenId
376     ) external;
377 
378     /**
379      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
380      * The approval is cleared when the token is transferred.
381      *
382      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
383      *
384      * Requirements:
385      *
386      * - The caller must own the token or be an approved operator.
387      * - `tokenId` must exist.
388      *
389      * Emits an {Approval} event.
390      */
391     function approve(address to, uint256 tokenId) external;
392 
393     /**
394      * @dev Returns the account approved for `tokenId` token.
395      *
396      * Requirements:
397      *
398      * - `tokenId` must exist.
399      */
400     function getApproved(uint256 tokenId) external view returns (address operator);
401 
402     /**
403      * @dev Approve or remove `operator` as an operator for the caller.
404      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
405      *
406      * Requirements:
407      *
408      * - The `operator` cannot be the caller.
409      *
410      * Emits an {ApprovalForAll} event.
411      */
412     function setApprovalForAll(address operator, bool _approved) external;
413 
414     /**
415      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
416      *
417      * See {setApprovalForAll}
418      */
419     function isApprovedForAll(address owner, address operator) external view returns (bool);
420 
421     /**
422      * @dev Safely transfers `tokenId` token from `from` to `to`.
423      *
424      * Requirements:
425      *
426      * - `from` cannot be the zero address.
427      * - `to` cannot be the zero address.
428      * - `tokenId` token must exist and be owned by `from`.
429      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
430      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
431      *
432      * Emits a {Transfer} event.
433      */
434     function safeTransferFrom(
435         address from,
436         address to,
437         uint256 tokenId,
438         bytes calldata data
439     ) external;
440 }
441 
442 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
443 
444 
445 
446 pragma solidity ^0.8.0;
447 
448 
449 /**
450  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
451  * @dev See https://eips.ethereum.org/EIPS/eip-721
452  */
453 interface IERC721Enumerable is IERC721 {
454     /**
455      * @dev Returns the total amount of tokens stored by the contract.
456      */
457     function totalSupply() external view returns (uint256);
458 
459     /**
460      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
461      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
462      */
463     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
464 
465     /**
466      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
467      * Use along with {totalSupply} to enumerate all tokens.
468      */
469     function tokenByIndex(uint256 index) external view returns (uint256);
470 }
471 
472 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
473 
474 
475 
476 pragma solidity ^0.8.0;
477 
478 
479 /**
480  * @dev Implementation of the {IERC165} interface.
481  *
482  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
483  * for the additional interface id that will be supported. For example:
484  *
485  * ```solidity
486  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
487  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
488  * }
489  * ```
490  *
491  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
492  */
493 abstract contract ERC165 is IERC165 {
494     /**
495      * @dev See {IERC165-supportsInterface}.
496      */
497     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
498         return interfaceId == type(IERC165).interfaceId;
499     }
500 }
501 
502 // File: @openzeppelin/contracts/utils/Strings.sol
503 
504 
505 
506 pragma solidity ^0.8.0;
507 
508 /**
509  * @dev String operations.
510  */
511 library Strings {
512     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
513 
514     /**
515      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
516      */
517     function toString(uint256 value) internal pure returns (string memory) {
518         // Inspired by OraclizeAPI's implementation - MIT licence
519         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
520 
521         if (value == 0) {
522             return "0";
523         }
524         uint256 temp = value;
525         uint256 digits;
526         while (temp != 0) {
527             digits++;
528             temp /= 10;
529         }
530         bytes memory buffer = new bytes(digits);
531         while (value != 0) {
532             digits -= 1;
533             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
534             value /= 10;
535         }
536         return string(buffer);
537     }
538 
539     /**
540      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
541      */
542     function toHexString(uint256 value) internal pure returns (string memory) {
543         if (value == 0) {
544             return "0x00";
545         }
546         uint256 temp = value;
547         uint256 length = 0;
548         while (temp != 0) {
549             length++;
550             temp >>= 8;
551         }
552         return toHexString(value, length);
553     }
554 
555     /**
556      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
557      */
558     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
559         bytes memory buffer = new bytes(2 * length + 2);
560         buffer[0] = "0";
561         buffer[1] = "x";
562         for (uint256 i = 2 * length + 1; i > 1; --i) {
563             buffer[i] = _HEX_SYMBOLS[value & 0xf];
564             value >>= 4;
565         }
566         require(value == 0, "Strings: hex length insufficient");
567         return string(buffer);
568     }
569 }
570 
571 // File: @openzeppelin/contracts/utils/Address.sol
572 
573 
574 
575 pragma solidity ^0.8.0;
576 
577 /**
578  * @dev Collection of functions related to the address type
579  */
580 library Address {
581     /**
582      * @dev Returns true if `account` is a contract.
583      *
584      * [IMPORTANT]
585      * ====
586      * It is unsafe to assume that an address for which this function returns
587      * false is an externally-owned account (EOA) and not a contract.
588      *
589      * Among others, `isContract` will return false for the following
590      * types of addresses:
591      *
592      *  - an externally-owned account
593      *  - a contract in construction
594      *  - an address where a contract will be created
595      *  - an address where a contract lived, but was destroyed
596      * ====
597      */
598     function isContract(address account) internal view returns (bool) {
599         // This method relies on extcodesize, which returns 0 for contracts in
600         // construction, since the code is only stored at the end of the
601         // constructor execution.
602 
603         uint256 size;
604         assembly {
605             size := extcodesize(account)
606         }
607         return size > 0;
608     }
609 
610     /**
611      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
612      * `recipient`, forwarding all available gas and reverting on errors.
613      *
614      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
615      * of certain opcodes, possibly making contracts go over the 2300 gas limit
616      * imposed by `transfer`, making them unable to receive funds via
617      * `transfer`. {sendValue} removes this limitation.
618      *
619      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
620      *
621      * IMPORTANT: because control is transferred to `recipient`, care must be
622      * taken to not create reentrancy vulnerabilities. Consider using
623      * {ReentrancyGuard} or the
624      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
625      */
626     function sendValue(address payable recipient, uint256 amount) internal {
627         require(address(this).balance >= amount, "Address: insufficient balance");
628 
629         (bool success, ) = recipient.call{value: amount}("");
630         require(success, "Address: unable to send value, recipient may have reverted");
631     }
632 
633     /**
634      * @dev Performs a Solidity function call using a low level `call`. A
635      * plain `call` is an unsafe replacement for a function call: use this
636      * function instead.
637      *
638      * If `target` reverts with a revert reason, it is bubbled up by this
639      * function (like regular Solidity function calls).
640      *
641      * Returns the raw returned data. To convert to the expected return value,
642      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
643      *
644      * Requirements:
645      *
646      * - `target` must be a contract.
647      * - calling `target` with `data` must not revert.
648      *
649      * _Available since v3.1._
650      */
651     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
652         return functionCall(target, data, "Address: low-level call failed");
653     }
654 
655     /**
656      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
657      * `errorMessage` as a fallback revert reason when `target` reverts.
658      *
659      * _Available since v3.1._
660      */
661     function functionCall(
662         address target,
663         bytes memory data,
664         string memory errorMessage
665     ) internal returns (bytes memory) {
666         return functionCallWithValue(target, data, 0, errorMessage);
667     }
668 
669     /**
670      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
671      * but also transferring `value` wei to `target`.
672      *
673      * Requirements:
674      *
675      * - the calling contract must have an ETH balance of at least `value`.
676      * - the called Solidity function must be `payable`.
677      *
678      * _Available since v3.1._
679      */
680     function functionCallWithValue(
681         address target,
682         bytes memory data,
683         uint256 value
684     ) internal returns (bytes memory) {
685         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
686     }
687 
688     /**
689      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
690      * with `errorMessage` as a fallback revert reason when `target` reverts.
691      *
692      * _Available since v3.1._
693      */
694     function functionCallWithValue(
695         address target,
696         bytes memory data,
697         uint256 value,
698         string memory errorMessage
699     ) internal returns (bytes memory) {
700         require(address(this).balance >= value, "Address: insufficient balance for call");
701         require(isContract(target), "Address: call to non-contract");
702 
703         (bool success, bytes memory returndata) = target.call{value: value}(data);
704         return verifyCallResult(success, returndata, errorMessage);
705     }
706 
707     /**
708      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
709      * but performing a static call.
710      *
711      * _Available since v3.3._
712      */
713     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
714         return functionStaticCall(target, data, "Address: low-level static call failed");
715     }
716 
717     /**
718      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
719      * but performing a static call.
720      *
721      * _Available since v3.3._
722      */
723     function functionStaticCall(
724         address target,
725         bytes memory data,
726         string memory errorMessage
727     ) internal view returns (bytes memory) {
728         require(isContract(target), "Address: static call to non-contract");
729 
730         (bool success, bytes memory returndata) = target.staticcall(data);
731         return verifyCallResult(success, returndata, errorMessage);
732     }
733 
734     /**
735      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
736      * but performing a delegate call.
737      *
738      * _Available since v3.4._
739      */
740     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
741         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
742     }
743 
744     /**
745      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
746      * but performing a delegate call.
747      *
748      * _Available since v3.4._
749      */
750     function functionDelegateCall(
751         address target,
752         bytes memory data,
753         string memory errorMessage
754     ) internal returns (bytes memory) {
755         require(isContract(target), "Address: delegate call to non-contract");
756 
757         (bool success, bytes memory returndata) = target.delegatecall(data);
758         return verifyCallResult(success, returndata, errorMessage);
759     }
760 
761     /**
762      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
763      * revert reason using the provided one.
764      *
765      * _Available since v4.3._
766      */
767     function verifyCallResult(
768         bool success,
769         bytes memory returndata,
770         string memory errorMessage
771     ) internal pure returns (bytes memory) {
772         if (success) {
773             return returndata;
774         } else {
775             // Look for revert reason and bubble it up if present
776             if (returndata.length > 0) {
777                 // The easiest way to bubble the revert reason is using memory via assembly
778 
779                 assembly {
780                     let returndata_size := mload(returndata)
781                     revert(add(32, returndata), returndata_size)
782                 }
783             } else {
784                 revert(errorMessage);
785             }
786         }
787     }
788 }
789 
790 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
791 pragma solidity ^0.8.0;
792 /**
793  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
794  * @dev See https://eips.ethereum.org/EIPS/eip-721
795  */
796 interface IERC721Metadata is IERC721 {
797     /**
798      * @dev Returns the token collection name.
799      */
800     function name() external view returns (string memory);
801 
802     /**
803      * @dev Returns the token collection symbol.
804      */
805     function symbol() external view returns (string memory);
806 
807     /**
808      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
809      */
810     function tokenURI(uint256 tokenId) external view returns (string memory);
811 }
812 
813 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
814 
815 
816 
817 pragma solidity ^0.8.0;
818 
819 /**
820  * @title ERC721 token receiver interface
821  * @dev Interface for any contract that wants to support safeTransfers
822  * from ERC721 asset contracts.
823  */
824 interface IERC721Receiver {
825     /**
826      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
827      * by `operator` from `from`, this function is called.
828      *
829      * It must return its Solidity selector to confirm the token transfer.
830      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
831      *
832      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
833      */
834     function onERC721Received(
835         address operator,
836         address from,
837         uint256 tokenId,
838         bytes calldata data
839     ) external returns (bytes4);
840 }
841 
842 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
843 
844 
845 
846 pragma solidity ^0.8.0;
847 
848 
849 
850 
851 
852 
853 
854 
855 /**
856  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
857  * the Metadata extension, but not including the Enumerable extension, which is available separately as
858  * {ERC721Enumerable}.
859  */
860 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
861     using Address for address;
862     using Strings for uint256;
863 
864     // Token name
865     string private _name;
866 
867     // Token symbol
868     string private _symbol;
869 
870     // Mapping from token ID to owner address
871     mapping(uint256 => address) private _owners;
872 
873     // Mapping owner address to token count
874     mapping(address => uint256) private _balances;
875 
876     // Mapping from token ID to approved address
877     mapping(uint256 => address) private _tokenApprovals;
878 
879     // Mapping from owner to operator approvals
880     mapping(address => mapping(address => bool)) private _operatorApprovals;
881 
882     /**
883      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
884      */
885     constructor(string memory name_, string memory symbol_) {
886         _name = name_;
887         _symbol = symbol_;
888     }
889 
890     /**
891      * @dev See {IERC165-supportsInterface}.
892      */
893     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
894         return
895             interfaceId == type(IERC721).interfaceId ||
896             interfaceId == type(IERC721Metadata).interfaceId ||
897             super.supportsInterface(interfaceId);
898     }
899 
900     /**
901      * @dev See {IERC721-balanceOf}.
902      */
903     function balanceOf(address owner) public view virtual override returns (uint256) {
904         require(owner != address(0), "ERC721: balance query for the zero address");
905         return _balances[owner];
906     }
907 
908     /**
909      * @dev See {IERC721-ownerOf}.
910      */
911     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
912         address owner = _owners[tokenId];
913         require(owner != address(0), "ERC721: owner query for nonexistent token");
914         return owner;
915     }
916 
917     /**
918      * @dev See {IERC721Metadata-name}.
919      */
920     function name() public view virtual override returns (string memory) {
921         return _name;
922     }
923 
924     /**
925      * @dev See {IERC721Metadata-symbol}.
926      */
927     function symbol() public view virtual override returns (string memory) {
928         return _symbol;
929     }
930 
931     /**
932      * @dev See {IERC721Metadata-tokenURI}.
933      */
934     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
935         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
936 
937         string memory baseURI = _baseURI();
938         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
939     }
940 
941     /**
942      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
943      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
944      * by default, can be overriden in child contracts.
945      */
946     function _baseURI() internal view virtual returns (string memory) {
947         return "";
948     }
949 
950     /**
951      * @dev See {IERC721-approve}.
952      */
953     function approve(address to, uint256 tokenId) public virtual override {
954         address owner = ERC721.ownerOf(tokenId);
955         require(to != owner, "ERC721: approval to current owner");
956 
957         require(
958             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
959             "ERC721: approve caller is not owner nor approved for all"
960         );
961 
962         _approve(to, tokenId);
963     }
964 
965     /**
966      * @dev See {IERC721-getApproved}.
967      */
968     function getApproved(uint256 tokenId) public view virtual override returns (address) {
969         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
970 
971         return _tokenApprovals[tokenId];
972     }
973 
974     /**
975      * @dev See {IERC721-setApprovalForAll}.
976      */
977     function setApprovalForAll(address operator, bool approved) public virtual override {
978         require(operator != _msgSender(), "ERC721: approve to caller");
979 
980         _operatorApprovals[_msgSender()][operator] = approved;
981         emit ApprovalForAll(_msgSender(), operator, approved);
982     }
983 
984     /**
985      * @dev See {IERC721-isApprovedForAll}.
986      */
987     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
988         return _operatorApprovals[owner][operator];
989     }
990 
991     /**
992      * @dev See {IERC721-transferFrom}.
993      */
994     function transferFrom(
995         address from,
996         address to,
997         uint256 tokenId
998     ) public virtual override {
999         //solhint-disable-next-line max-line-length
1000         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1001 
1002         _transfer(from, to, tokenId);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-safeTransferFrom}.
1007      */
1008     function safeTransferFrom(
1009         address from,
1010         address to,
1011         uint256 tokenId
1012     ) public virtual override {
1013         safeTransferFrom(from, to, tokenId, "");
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-safeTransferFrom}.
1018      */
1019     function safeTransferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId,
1023         bytes memory _data
1024     ) public virtual override {
1025         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1026         _safeTransfer(from, to, tokenId, _data);
1027     }
1028 
1029     /**
1030      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1031      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1032      *
1033      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1034      *
1035      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1036      * implement alternative mechanisms to perform token transfer, such as signature-based.
1037      *
1038      * Requirements:
1039      *
1040      * - `from` cannot be the zero address.
1041      * - `to` cannot be the zero address.
1042      * - `tokenId` token must exist and be owned by `from`.
1043      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1044      *
1045      * Emits a {Transfer} event.
1046      */
1047     function _safeTransfer(
1048         address from,
1049         address to,
1050         uint256 tokenId,
1051         bytes memory _data
1052     ) internal virtual {
1053         _transfer(from, to, tokenId);
1054         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1055     }
1056 
1057     /**
1058      * @dev Returns whether `tokenId` exists.
1059      *
1060      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1061      *
1062      * Tokens start existing when they are minted (`_mint`),
1063      * and stop existing when they are burned (`_burn`).
1064      */
1065     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1066         return _owners[tokenId] != address(0);
1067     }
1068 
1069     /**
1070      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1071      *
1072      * Requirements:
1073      *
1074      * - `tokenId` must exist.
1075      */
1076     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1077         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1078         address owner = ERC721.ownerOf(tokenId);
1079         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1080     }
1081 
1082     /**
1083      * @dev Safely mints `tokenId` and transfers it to `to`.
1084      *
1085      * Requirements:
1086      *
1087      * - `tokenId` must not exist.
1088      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _safeMint(address to, uint256 tokenId) internal virtual {
1093         _safeMint(to, tokenId, "");
1094     }
1095 
1096     /**
1097      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1098      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1099      */
1100     function _safeMint(
1101         address to,
1102         uint256 tokenId,
1103         bytes memory _data
1104     ) internal virtual {
1105         _mint(to, tokenId);
1106         require(
1107             _checkOnERC721Received(address(0), to, tokenId, _data),
1108             "ERC721: transfer to non ERC721Receiver implementer"
1109         );
1110     }
1111 
1112     /**
1113      * @dev Mints `tokenId` and transfers it to `to`.
1114      *
1115      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1116      *
1117      * Requirements:
1118      *
1119      * - `tokenId` must not exist.
1120      * - `to` cannot be the zero address.
1121      *
1122      * Emits a {Transfer} event.
1123      */
1124     function _mint(address to, uint256 tokenId) internal virtual {
1125         require(to != address(0), "ERC721: mint to the zero address");
1126         require(!_exists(tokenId), "ERC721: token already minted");
1127 
1128         _beforeTokenTransfer(address(0), to, tokenId);
1129 
1130         _balances[to] += 1;
1131         _owners[tokenId] = to;
1132 
1133         emit Transfer(address(0), to, tokenId);
1134     }
1135 
1136     /**
1137      * @dev Destroys `tokenId`.
1138      * The approval is cleared when the token is burned.
1139      *
1140      * Requirements:
1141      *
1142      * - `tokenId` must exist.
1143      *
1144      * Emits a {Transfer} event.
1145      */
1146     function _burn(uint256 tokenId) internal virtual {
1147         address owner = ERC721.ownerOf(tokenId);
1148 
1149         _beforeTokenTransfer(owner, address(0), tokenId);
1150 
1151         // Clear approvals
1152         _approve(address(0), tokenId);
1153 
1154         _balances[owner] -= 1;
1155         delete _owners[tokenId];
1156 
1157         emit Transfer(owner, address(0), tokenId);
1158     }
1159 
1160     /**
1161      * @dev Transfers `tokenId` from `from` to `to`.
1162      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1163      *
1164      * Requirements:
1165      *
1166      * - `to` cannot be the zero address.
1167      * - `tokenId` token must be owned by `from`.
1168      *
1169      * Emits a {Transfer} event.
1170      */
1171     function _transfer(
1172         address from,
1173         address to,
1174         uint256 tokenId
1175     ) internal virtual {
1176         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1177         require(to != address(0), "ERC721: transfer to the zero address");
1178 
1179         _beforeTokenTransfer(from, to, tokenId);
1180 
1181         // Clear approvals from the previous owner
1182         _approve(address(0), tokenId);
1183 
1184         _balances[from] -= 1;
1185         _balances[to] += 1;
1186         _owners[tokenId] = to;
1187 
1188         emit Transfer(from, to, tokenId);
1189     }
1190 
1191     /**
1192      * @dev Approve `to` to operate on `tokenId`
1193      *
1194      * Emits a {Approval} event.
1195      */
1196     function _approve(address to, uint256 tokenId) internal virtual {
1197         _tokenApprovals[tokenId] = to;
1198         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1199     }
1200 
1201     /**
1202      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1203      * The call is not executed if the target address is not a contract.
1204      *
1205      * @param from address representing the previous owner of the given token ID
1206      * @param to target address that will receive the tokens
1207      * @param tokenId uint256 ID of the token to be transferred
1208      * @param _data bytes optional data to send along with the call
1209      * @return bool whether the call correctly returned the expected magic value
1210      */
1211     function _checkOnERC721Received(
1212         address from,
1213         address to,
1214         uint256 tokenId,
1215         bytes memory _data
1216     ) private returns (bool) {
1217         if (to.isContract()) {
1218             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1219                 return retval == IERC721Receiver.onERC721Received.selector;
1220             } catch (bytes memory reason) {
1221                 if (reason.length == 0) {
1222                     revert("ERC721: transfer to non ERC721Receiver implementer");
1223                 } else {
1224                     assembly {
1225                         revert(add(32, reason), mload(reason))
1226                     }
1227                 }
1228             }
1229         } else {
1230             return true;
1231         }
1232     }
1233 
1234     /**
1235      * @dev Hook that is called before any token transfer. This includes minting
1236      * and burning.
1237      *
1238      * Calling conditions:
1239      *
1240      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1241      * transferred to `to`.
1242      * - When `from` is zero, `tokenId` will be minted for `to`.
1243      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1244      * - `from` and `to` are never both zero.
1245      *
1246      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1247      */
1248     function _beforeTokenTransfer(
1249         address from,
1250         address to,
1251         uint256 tokenId
1252     ) internal virtual {}
1253 }
1254 
1255 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1256 
1257 
1258 
1259 pragma solidity ^0.8.0;
1260 
1261 
1262 
1263 /**
1264  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1265  * enumerability of all the token ids in the contract as well as all token ids owned by each
1266  * account.
1267  */
1268 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1269     // Mapping from owner to list of owned token IDs
1270     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1271 
1272     // Mapping from token ID to index of the owner tokens list
1273     mapping(uint256 => uint256) private _ownedTokensIndex;
1274 
1275     // Array with all token ids, used for enumeration
1276     uint256[] private _allTokens;
1277 
1278     // Mapping from token id to position in the allTokens array
1279     mapping(uint256 => uint256) private _allTokensIndex;
1280 
1281     /**
1282      * @dev See {IERC165-supportsInterface}.
1283      */
1284     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1285         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1286     }
1287 
1288     /**
1289      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1290      */
1291     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1292         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1293         return _ownedTokens[owner][index];
1294     }
1295 
1296     /**
1297      * @dev See {IERC721Enumerable-totalSupply}.
1298      */
1299     function totalSupply() public view virtual override returns (uint256) {
1300         return _allTokens.length;
1301     }
1302 
1303     /**
1304      * @dev See {IERC721Enumerable-tokenByIndex}.
1305      */
1306     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1307         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1308         return _allTokens[index];
1309     }
1310 
1311     /**
1312      * @dev Hook that is called before any token transfer. This includes minting
1313      * and burning.
1314      *
1315      * Calling conditions:
1316      *
1317      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1318      * transferred to `to`.
1319      * - When `from` is zero, `tokenId` will be minted for `to`.
1320      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1321      * - `from` cannot be the zero address.
1322      * - `to` cannot be the zero address.
1323      *
1324      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1325      */
1326     function _beforeTokenTransfer(
1327         address from,
1328         address to,
1329         uint256 tokenId
1330     ) internal virtual override {
1331         super._beforeTokenTransfer(from, to, tokenId);
1332 
1333         if (from == address(0)) {
1334             _addTokenToAllTokensEnumeration(tokenId);
1335         } else if (from != to) {
1336             _removeTokenFromOwnerEnumeration(from, tokenId);
1337         }
1338         if (to == address(0)) {
1339             _removeTokenFromAllTokensEnumeration(tokenId);
1340         } else if (to != from) {
1341             _addTokenToOwnerEnumeration(to, tokenId);
1342         }
1343     }
1344 
1345     /**
1346      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1347      * @param to address representing the new owner of the given token ID
1348      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1349      */
1350     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1351         uint256 length = ERC721.balanceOf(to);
1352         _ownedTokens[to][length] = tokenId;
1353         _ownedTokensIndex[tokenId] = length;
1354     }
1355 
1356     /**
1357      * @dev Private function to add a token to this extension's token tracking data structures.
1358      * @param tokenId uint256 ID of the token to be added to the tokens list
1359      */
1360     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1361         _allTokensIndex[tokenId] = _allTokens.length;
1362         _allTokens.push(tokenId);
1363     }
1364 
1365     /**
1366      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1367      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1368      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1369      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1370      * @param from address representing the previous owner of the given token ID
1371      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1372      */
1373     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1374         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1375         // then delete the last slot (swap and pop).
1376 
1377         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1378         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1379 
1380         // When the token to delete is the last token, the swap operation is unnecessary
1381         if (tokenIndex != lastTokenIndex) {
1382             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1383 
1384             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1385             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1386         }
1387 
1388         // This also deletes the contents at the last position of the array
1389         delete _ownedTokensIndex[tokenId];
1390         delete _ownedTokens[from][lastTokenIndex];
1391     }
1392 
1393     /**
1394      * @dev Private function to remove a token from this extension's token tracking data structures.
1395      * This has O(1) time complexity, but alters the order of the _allTokens array.
1396      * @param tokenId uint256 ID of the token to be removed from the tokens list
1397      */
1398     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1399         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1400         // then delete the last slot (swap and pop).
1401 
1402         uint256 lastTokenIndex = _allTokens.length - 1;
1403         uint256 tokenIndex = _allTokensIndex[tokenId];
1404 
1405         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1406         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1407         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1408         uint256 lastTokenId = _allTokens[lastTokenIndex];
1409 
1410         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1411         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1412 
1413         // This also deletes the contents at the last position of the array
1414         delete _allTokensIndex[tokenId];
1415         _allTokens.pop();
1416     }
1417 }
1418 
1419 //SPDX-License-Identifier: MIT
1420 pragma solidity ^0.8.0;
1421 
1422 contract SunBlocks is ERC721Enumerable, Ownable, RandomlyAssigned {
1423   using Strings for uint256;
1424   
1425   string public baseExtension = ".json";
1426   uint256 public cost = 0.0277 ether;
1427   uint256 public maxBlocksSupply = 555;
1428   uint256 public maxMintAmount = 10;
1429   bool public paused = false;
1430 
1431   uint public publicSupplyMinted = 0;
1432   uint public publicMaxSupply = 485;
1433 
1434   uint public presaleSupplyMinted = 0;
1435   uint public presaleMaxSupply = 70;
1436 
1437   mapping(address => uint256) public presaleList;
1438   
1439   string public baseURI;
1440 
1441   constructor(
1442   ) ERC721("SunBlocks", "SBLOCKS")
1443   RandomlyAssigned(555, 1) {
1444   }
1445 
1446   // internal
1447   function _baseURI() internal view virtual override returns (string memory) {
1448     return baseURI;
1449   }
1450 
1451   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1452     baseURI = _newBaseURI;
1453   }
1454 
1455   // public
1456   function mint(uint256 _mintAmount) public payable {
1457     require(!paused);
1458     require(_mintAmount > 0);
1459     require(_mintAmount <= maxMintAmount);
1460     require(totalSupply() + _mintAmount <= maxBlocksSupply);
1461     require(publicSupplyMinted + _mintAmount <= publicMaxSupply);
1462     require(msg.value >= cost * _mintAmount);
1463 
1464     for (uint256 i = 1; i <= _mintAmount; i++) {
1465       uint256 mintIndex = nextToken();
1466 
1467       _safeMint(_msgSender(), mintIndex);
1468     }
1469 
1470     publicSupplyMinted = publicSupplyMinted + _mintAmount;
1471   }
1472 
1473   function presaleMint(uint256 _mintAmount) public payable {
1474       require(!paused);
1475       require(_mintAmount > 0);
1476       require(_mintAmount <= maxMintAmount);
1477       require(totalSupply() + _mintAmount <= maxBlocksSupply);
1478       require(presaleSupplyMinted + _mintAmount <= presaleMaxSupply);
1479 
1480       uint256 senderLimit = presaleList[msg.sender];
1481 
1482       require(senderLimit > 0, "You have no tokens left");
1483       require(_mintAmount <= senderLimit, "Your max token holding exceeded");
1484 
1485 
1486       for (uint256 i = 0; i < _mintAmount; i++) {
1487         uint256 mintIndex = nextToken();
1488         _safeMint(_msgSender(), mintIndex);
1489         senderLimit -= 1;
1490       }
1491 
1492       presaleSupplyMinted = presaleSupplyMinted + _mintAmount;
1493       presaleList[msg.sender] = senderLimit;
1494   }
1495 
1496 
1497   function addPresaleList(
1498       address[] calldata _addrs,
1499       uint256[] calldata _limit
1500   ) public onlyOwner {
1501       require(_addrs.length == _limit.length);
1502       for (uint256 i = 0; i < _addrs.length; i++) {
1503           presaleList[_addrs[i]] = _limit[i];
1504       }
1505   }
1506 
1507   function walletOfOwner(address _owner)
1508     public
1509     view
1510     returns (uint256[] memory)
1511   {
1512     uint256 ownerTokenCount = balanceOf(_owner);
1513     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1514     for (uint256 i; i < ownerTokenCount; i++) {
1515       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1516     }
1517     return tokenIds;
1518   }
1519 
1520   function tokenURI(uint256 tokenId)
1521     public
1522     view
1523     virtual
1524     override
1525     returns (string memory)
1526   {
1527     require(
1528       _exists(tokenId),
1529       "ERC721Metadata: URI query for nonexistent token"
1530     );
1531 
1532     string memory currentBaseURI = _baseURI();
1533     return bytes(currentBaseURI).length > 0
1534         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1535         : "";
1536   }
1537 
1538   //only owner
1539 
1540   function withdraw() public payable onlyOwner {
1541     require(payable(msg.sender).send(address(this).balance));
1542   }
1543 }