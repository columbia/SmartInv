1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 interface IERC721Receiver {
5     /**
6      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
7      * by `operator` from `from`, this function is called.
8      *
9      * It must return its Solidity selector to confirm the token transfer.
10      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
11      *
12      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
13      */
14     function onERC721Received(
15         address operator,
16         address from,
17         uint256 tokenId,
18         bytes calldata data
19     ) external returns (bytes4);
20 }
21 
22 
23 interface IERC165 {
24     /**
25      * @dev Returns true if this contract implements the interface defined by
26      * `interfaceId`. See the corresponding
27      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
28      * to learn more about how these ids are created.
29      *
30      * This function call must use less than 30 000 gas.
31      */
32     function supportsInterface(bytes4 interfaceId) external view returns (bool);
33 }
34 
35 abstract contract ERC165 is IERC165 {
36     /**
37      * @dev See {IERC165-supportsInterface}.
38      */
39     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
40         return interfaceId == type(IERC165).interfaceId;
41     }
42 }
43 
44 interface IERC721 is IERC165 {
45     /**
46      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
47      */
48     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
49 
50     /**
51      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
52      */
53     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
54 
55     /**
56      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
57      */
58     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
59 
60     /**
61      * @dev Returns the number of tokens in ``owner``'s account.
62      */
63     function balanceOf(address owner) external view returns (uint256 balance);
64 
65     /**
66      * @dev Returns the owner of the `tokenId` token.
67      *
68      * Requirements:
69      *
70      * - `tokenId` must exist.
71      */
72     function ownerOf(uint256 tokenId) external view returns (address owner);
73 
74     /**
75      * @dev Safely transfers `tokenId` token from `from` to `to`.
76      *
77      * Requirements:
78      *
79      * - `from` cannot be the zero address.
80      * - `to` cannot be the zero address.
81      * - `tokenId` token must exist and be owned by `from`.
82      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
83      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
84      *
85      * Emits a {Transfer} event.
86      */
87     function safeTransferFrom(
88         address from,
89         address to,
90         uint256 tokenId,
91         bytes calldata data
92     ) external;
93 
94     /**
95      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
96      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
97      *
98      * Requirements:
99      *
100      * - `from` cannot be the zero address.
101      * - `to` cannot be the zero address.
102      * - `tokenId` token must exist and be owned by `from`.
103      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
104      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
105      *
106      * Emits a {Transfer} event.
107      */
108     function safeTransferFrom(
109         address from,
110         address to,
111         uint256 tokenId
112     ) external;
113 
114     /**
115      * @dev Transfers `tokenId` token from `from` to `to`.
116      *
117      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
118      *
119      * Requirements:
120      *
121      * - `from` cannot be the zero address.
122      * - `to` cannot be the zero address.
123      * - `tokenId` token must be owned by `from`.
124      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
125      *
126      * Emits a {Transfer} event.
127      */
128     function transferFrom(
129         address from,
130         address to,
131         uint256 tokenId
132     ) external;
133 
134     /**
135      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
136      * The approval is cleared when the token is transferred.
137      *
138      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
139      *
140      * Requirements:
141      *
142      * - The caller must own the token or be an approved operator.
143      * - `tokenId` must exist.
144      *
145      * Emits an {Approval} event.
146      */
147     function approve(address to, uint256 tokenId) external;
148 
149     /**
150      * @dev Approve or remove `operator` as an operator for the caller.
151      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
152      *
153      * Requirements:
154      *
155      * - The `operator` cannot be the caller.
156      *
157      * Emits an {ApprovalForAll} event.
158      */
159     function setApprovalForAll(address operator, bool _approved) external;
160 
161     /**
162      * @dev Returns the account approved for `tokenId` token.
163      *
164      * Requirements:
165      *
166      * - `tokenId` must exist.
167      */
168     function getApproved(uint256 tokenId) external view returns (address operator);
169 
170     /**
171      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
172      *
173      * See {setApprovalForAll}
174      */
175     function isApprovedForAll(address owner, address operator) external view returns (bool);
176 }
177 
178 interface IERC721Metadata is IERC721 {
179     /**
180      * @dev Returns the token collection name.
181      */
182     function name() external view returns (string memory);
183 
184     /**
185      * @dev Returns the token collection symbol.
186      */
187     function symbol() external view returns (string memory);
188 
189     /**
190      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
191      */
192     function tokenURI(uint256 tokenId) external view returns (string memory);
193 }
194 
195 library Strings {
196     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
197 
198     /**
199      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
200      */
201     function toString(uint256 value) internal pure returns (string memory) {
202         // Inspired by OraclizeAPI's implementation - MIT licence
203         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
204 
205         if (value == 0) {
206             return "0";
207         }
208         uint256 temp = value;
209         uint256 digits;
210         while (temp != 0) {
211             digits++;
212             temp /= 10;
213         }
214         bytes memory buffer = new bytes(digits);
215         while (value != 0) {
216             digits -= 1;
217             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
218             value /= 10;
219         }
220         return string(buffer);
221     }
222 
223     /**
224      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
225      */
226     function toHexString(uint256 value) internal pure returns (string memory) {
227         if (value == 0) {
228             return "0x00";
229         }
230         uint256 temp = value;
231         uint256 length = 0;
232         while (temp != 0) {
233             length++;
234             temp >>= 8;
235         }
236         return toHexString(value, length);
237     }
238 
239     /**
240      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
241      */
242     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
243         bytes memory buffer = new bytes(2 * length + 2);
244         buffer[0] = "0";
245         buffer[1] = "x";
246         for (uint256 i = 2 * length + 1; i > 1; --i) {
247             buffer[i] = _HEX_SYMBOLS[value & 0xf];
248             value >>= 4;
249         }
250         require(value == 0, "Strings: hex length insufficient");
251         return string(buffer);
252     }
253 }
254 
255 
256 abstract contract Context {
257     function _msgSender() internal view virtual returns (address) {
258         return msg.sender;
259     }
260 
261     function _msgData() internal view virtual returns (bytes calldata) {
262         return msg.data;
263     }
264 }
265 
266 
267 abstract contract Ownable is Context {
268     address private _owner;
269 
270     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
271 
272     /**
273      * @dev Initializes the contract setting the deployer as the initial owner.
274      */
275     constructor() {
276         _transferOwnership(_msgSender());
277     }
278 
279     /**
280      * @dev Returns the address of the current owner.
281      */
282     function owner() public view virtual returns (address) {
283         return _owner;
284     }
285 
286     /**
287      * @dev Throws if called by any account other than the owner.
288      */
289     modifier onlyOwner() {
290         require(owner() == _msgSender(), "Ownable: caller is not the owner");
291         _;
292     }
293 
294     /**
295      * @dev Leaves the contract without owner. It will not be possible to call
296      * `onlyOwner` functions anymore. Can only be called by the current owner.
297      *
298      * NOTE: Renouncing ownership will leave the contract without an owner,
299      * thereby removing any functionality that is only available to the owner.
300      */
301     function renounceOwnership() public virtual onlyOwner {
302         _transferOwnership(address(0));
303     }
304 
305     /**
306      * @dev Transfers ownership of the contract to a new account (`newOwner`).
307      * Can only be called by the current owner.
308      */
309     function transferOwnership(address newOwner) public virtual onlyOwner {
310         require(newOwner != address(0), "Ownable: new owner is the zero address");
311         _transferOwnership(newOwner);
312     }
313 
314     /**
315      * @dev Transfers ownership of the contract to a new account (`newOwner`).
316      * Internal function without access restriction.
317      */
318     function _transferOwnership(address newOwner) internal virtual {
319         address oldOwner = _owner;
320         _owner = newOwner;
321         emit OwnershipTransferred(oldOwner, newOwner);
322     }
323 }
324 
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
528 
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
540 
541 interface IERC721A is IERC721, IERC721Metadata {
542     /**
543      * The caller must own the token or be an approved operator.
544      */
545     error ApprovalCallerNotOwnerNorApproved();
546 
547     /**
548      * The token does not exist.
549      */
550     error ApprovalQueryForNonexistentToken();
551 
552     /**
553      * The caller cannot approve to their own address.
554      */
555     error ApproveToCaller();
556 
557     /**
558      * The caller cannot approve to the current owner.
559      */
560     error ApprovalToCurrentOwner();
561 
562     /**
563      * Cannot query the balance for the zero address.
564      */
565     error BalanceQueryForZeroAddress();
566 
567     /**
568      * Cannot mint to the zero address.
569      */
570     error MintToZeroAddress();
571 
572     /**
573      * The quantity of tokens minted must be more than zero.
574      */
575     error MintZeroQuantity();
576 
577     /**
578      * The token does not exist.
579      */
580     error OwnerQueryForNonexistentToken();
581 
582     /**
583      * The caller must own the token or be an approved operator.
584      */
585     error TransferCallerNotOwnerNorApproved();
586 
587     /**
588      * The token must be owned by `from`.
589      */
590     error TransferFromIncorrectOwner();
591 
592     /**
593      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
594      */
595     error TransferToNonERC721ReceiverImplementer();
596 
597     /**
598      * Cannot transfer to the zero address.
599      */
600     error TransferToZeroAddress();
601 
602     /**
603      * The token does not exist.
604      */
605     error URIQueryForNonexistentToken();
606 
607     // Compiler will pack this into a single 256bit word.
608     struct TokenOwnership {
609         // The address of the owner.
610         address addr;
611         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
612         uint64 startTimestamp;
613         // Whether the token has been burned.
614         bool burned;
615     }
616 
617     // Compiler will pack this into a single 256bit word.
618     struct AddressData {
619         // Realistically, 2**64-1 is more than enough.
620         uint64 balance;
621         // Keeps track of mint count with minimal overhead for tokenomics.
622         uint64 numberMinted;
623         // Keeps track of burn count with minimal overhead for tokenomics.
624         uint64 numberBurned;
625         // For miscellaneous variable(s) pertaining to the address
626         // (e.g. number of whitelist mint slots used).
627         // If there are multiple variables, please pack them into a uint64.
628         uint64 aux;
629     }
630 
631     /**
632      * @dev Returns the total amount of tokens stored by the contract.
633      * 
634      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
635      */
636     function totalSupply() external view returns (uint256);
637 }
638 
639 contract ERC721A is Context, ERC165, IERC721A {
640     using Address for address;
641     using Strings for uint256;
642 
643     // The tokenId of the next token to be minted.
644     uint256 internal _currentIndex;
645 
646     // The number of tokens burned.
647     uint256 internal _burnCounter;
648 
649     // Token name
650     string private _name;
651 
652     // Token symbol
653     string private _symbol;
654 
655     // Mapping from token ID to ownership details
656     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
657     mapping(uint256 => TokenOwnership) internal _ownerships;
658 
659     // Mapping owner address to address data
660     mapping(address => AddressData) private _addressData;
661 
662     // Mapping from token ID to approved address
663     mapping(uint256 => address) private _tokenApprovals;
664 
665     // Mapping from owner to operator approvals
666     mapping(address => mapping(address => bool)) private _operatorApprovals;
667 
668     constructor(string memory name_, string memory symbol_) {
669         _name = name_;
670         _symbol = symbol_;
671         _currentIndex = _startTokenId();
672     }
673 
674     /**
675      * To change the starting tokenId, please override this function.
676      */
677     function _startTokenId() internal view virtual returns (uint256) {
678         return 0;
679     }
680 
681     /**
682      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
683      */
684     function totalSupply() public view override returns (uint256) {
685         // Counter underflow is impossible as _burnCounter cannot be incremented
686         // more than _currentIndex - _startTokenId() times
687         unchecked {
688             return _currentIndex - _burnCounter - _startTokenId();
689         }
690     }
691 
692     /**
693      * Returns the total amount of tokens minted in the contract.
694      */
695     function _totalMinted() internal view returns (uint256) {
696         // Counter underflow is impossible as _currentIndex does not decrement,
697         // and it is initialized to _startTokenId()
698         unchecked {
699             return _currentIndex - _startTokenId();
700         }
701     }
702 
703     /**
704      * @dev See {IERC165-supportsInterface}.
705      */
706     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
707         return
708             interfaceId == type(IERC721).interfaceId ||
709             interfaceId == type(IERC721Metadata).interfaceId ||
710             super.supportsInterface(interfaceId);
711     }
712 
713     /**
714      * @dev See {IERC721-balanceOf}.
715      */
716     function balanceOf(address owner) public view override returns (uint256) {
717         if (owner == address(0)) revert BalanceQueryForZeroAddress();
718         return uint256(_addressData[owner].balance);
719     }
720 
721     /**
722      * Returns the number of tokens minted by `owner`.
723      */
724     function _numberMinted(address owner) internal view returns (uint256) {
725         return uint256(_addressData[owner].numberMinted);
726     }
727 
728     /**
729      * Returns the number of tokens burned by or on behalf of `owner`.
730      */
731     function _numberBurned(address owner) internal view returns (uint256) {
732         return uint256(_addressData[owner].numberBurned);
733     }
734 
735     /**
736      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
737      */
738     function _getAux(address owner) internal view returns (uint64) {
739         return _addressData[owner].aux;
740     }
741 
742     /**
743      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
744      * If there are multiple variables, please pack them into a uint64.
745      */
746     function _setAux(address owner, uint64 aux) internal {
747         _addressData[owner].aux = aux;
748     }
749 
750     /**
751      * Gas spent here starts off proportional to the maximum mint batch size.
752      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
753      */
754     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
755         uint256 curr = tokenId;
756 
757         unchecked {
758             if (_startTokenId() <= curr) if (curr < _currentIndex) {
759                 TokenOwnership memory ownership = _ownerships[curr];
760                 if (!ownership.burned) {
761                     if (ownership.addr != address(0)) {
762                         return ownership;
763                     }
764                     // Invariant:
765                     // There will always be an ownership that has an address and is not burned
766                     // before an ownership that does not have an address and is not burned.
767                     // Hence, curr will not underflow.
768                     while (true) {
769                         curr--;
770                         ownership = _ownerships[curr];
771                         if (ownership.addr != address(0)) {
772                             return ownership;
773                         }
774                     }
775                 }
776             }
777         }
778         revert OwnerQueryForNonexistentToken();
779     }
780 
781     /**
782      * @dev See {IERC721-ownerOf}.
783      */
784     function ownerOf(uint256 tokenId) public view override returns (address) {
785         return _ownershipOf(tokenId).addr;
786     }
787 
788     /**
789      * @dev See {IERC721Metadata-name}.
790      */
791     function name() public view virtual override returns (string memory) {
792         return _name;
793     }
794 
795     /**
796      * @dev See {IERC721Metadata-symbol}.
797      */
798     function symbol() public view virtual override returns (string memory) {
799         return _symbol;
800     }
801 
802     /**
803      * @dev See {IERC721Metadata-tokenURI}.
804      */
805     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
806         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
807 
808         string memory baseURI = _baseURI();
809         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
810     }
811 
812     /**
813      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
814      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
815      * by default, can be overriden in child contracts.
816      */
817     function _baseURI() internal view virtual returns (string memory) {
818         return '';
819     }
820 
821     /**
822      * @dev See {IERC721-approve}.
823      */
824     function approve(address to, uint256 tokenId) public override {
825         address owner = ERC721A.ownerOf(tokenId);
826         if (to == owner) revert ApprovalToCurrentOwner();
827 
828         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
829             revert ApprovalCallerNotOwnerNorApproved();
830         }
831 
832         _approve(to, tokenId, owner);
833     }
834 
835     /**
836      * @dev See {IERC721-getApproved}.
837      */
838     function getApproved(uint256 tokenId) public view override returns (address) {
839         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
840 
841         return _tokenApprovals[tokenId];
842     }
843 
844     /**
845      * @dev See {IERC721-setApprovalForAll}.
846      */
847     function setApprovalForAll(address operator, bool approved) public virtual override {
848         if (operator == _msgSender()) revert ApproveToCaller();
849 
850         _operatorApprovals[_msgSender()][operator] = approved;
851         emit ApprovalForAll(_msgSender(), operator, approved);
852     }
853 
854     /**
855      * @dev See {IERC721-isApprovedForAll}.
856      */
857     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
858         return _operatorApprovals[owner][operator];
859     }
860 
861     /**
862      * @dev See {IERC721-transferFrom}.
863      */
864     function transferFrom(
865         address from,
866         address to,
867         uint256 tokenId
868     ) public virtual override {
869         _transfer(from, to, tokenId);
870     }
871 
872     /**
873      * @dev See {IERC721-safeTransferFrom}.
874      */
875     function safeTransferFrom(
876         address from,
877         address to,
878         uint256 tokenId
879     ) public virtual override {
880         safeTransferFrom(from, to, tokenId, '');
881     }
882 
883     /**
884      * @dev See {IERC721-safeTransferFrom}.
885      */
886     function safeTransferFrom(
887         address from,
888         address to,
889         uint256 tokenId,
890         bytes memory _data
891     ) public virtual override {
892         _transfer(from, to, tokenId);
893         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
894             revert TransferToNonERC721ReceiverImplementer();
895         }
896     }
897 
898     /**
899      * @dev Returns whether `tokenId` exists.
900      *
901      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
902      *
903      * Tokens start existing when they are minted (`_mint`),
904      */
905     function _exists(uint256 tokenId) internal view returns (bool) {
906         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
907     }
908 
909     /**
910      * @dev Equivalent to `_safeMint(to, quantity, '')`.
911      */
912     function _safeMint(address to, uint256 quantity) internal {
913         _safeMint(to, quantity, '');
914     }
915 
916     /**
917      * @dev Safely mints `quantity` tokens and transfers them to `to`.
918      *
919      * Requirements:
920      *
921      * - If `to` refers to a smart contract, it must implement
922      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
923      * - `quantity` must be greater than 0.
924      *
925      * Emits a {Transfer} event.
926      */
927     function _safeMint(
928         address to,
929         uint256 quantity,
930         bytes memory _data
931     ) internal {
932         uint256 startTokenId = _currentIndex;
933         if (to == address(0)) revert MintToZeroAddress();
934         if (quantity == 0) revert MintZeroQuantity();
935 
936         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
937 
938         // Overflows are incredibly unrealistic.
939         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
940         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
941         unchecked {
942             _addressData[to].balance += uint64(quantity);
943             _addressData[to].numberMinted += uint64(quantity);
944 
945             _ownerships[startTokenId].addr = to;
946             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
947 
948             uint256 updatedIndex = startTokenId;
949             uint256 end = updatedIndex + quantity;
950 
951             if (to.isContract()) {
952                 do {
953                     emit Transfer(address(0), to, updatedIndex);
954                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
955                         revert TransferToNonERC721ReceiverImplementer();
956                     }
957                 } while (updatedIndex < end);
958                 // Reentrancy protection
959                 if (_currentIndex != startTokenId) revert();
960             } else {
961                 do {
962                     emit Transfer(address(0), to, updatedIndex++);
963                 } while (updatedIndex < end);
964             }
965             _currentIndex = updatedIndex;
966         }
967         _afterTokenTransfers(address(0), to, startTokenId, quantity);
968     }
969 
970     /**
971      * @dev Mints `quantity` tokens and transfers them to `to`.
972      *
973      * Requirements:
974      *
975      * - `to` cannot be the zero address.
976      * - `quantity` must be greater than 0.
977      *
978      * Emits a {Transfer} event.
979      */
980     function _mint(address to, uint256 quantity) internal {
981         uint256 startTokenId = _currentIndex;
982         if (to == address(0)) revert MintToZeroAddress();
983         if (quantity == 0) revert MintZeroQuantity();
984 
985         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
986 
987         // Overflows are incredibly unrealistic.
988         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
989         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
990         unchecked {
991             _addressData[to].balance += uint64(quantity);
992             _addressData[to].numberMinted += uint64(quantity);
993 
994             _ownerships[startTokenId].addr = to;
995             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
996 
997             uint256 updatedIndex = startTokenId;
998             uint256 end = updatedIndex + quantity;
999 
1000             do {
1001                 emit Transfer(address(0), to, updatedIndex++);
1002             } while (updatedIndex < end);
1003 
1004             _currentIndex = updatedIndex;
1005         }
1006         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1007     }
1008 
1009     /**
1010      * @dev Transfers `tokenId` from `from` to `to`.
1011      *
1012      * Requirements:
1013      *
1014      * - `to` cannot be the zero address.
1015      * - `tokenId` token must be owned by `from`.
1016      *
1017      * Emits a {Transfer} event.
1018      */
1019     function _transfer(
1020         address from,
1021         address to,
1022         uint256 tokenId
1023     ) private {
1024         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1025 
1026         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1027 
1028         bool isApprovedOrOwner = (_msgSender() == from ||
1029             isApprovedForAll(from, _msgSender()) ||
1030             getApproved(tokenId) == _msgSender());
1031 
1032         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1033         if (to == address(0)) revert TransferToZeroAddress();
1034 
1035         _beforeTokenTransfers(from, to, tokenId, 1);
1036 
1037         // Clear approvals from the previous owner
1038         _approve(address(0), tokenId, from);
1039 
1040         // Underflow of the sender's balance is impossible because we check for
1041         // ownership above and the recipient's balance can't realistically overflow.
1042         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1043         unchecked {
1044             _addressData[from].balance -= 1;
1045             _addressData[to].balance += 1;
1046 
1047             TokenOwnership storage currSlot = _ownerships[tokenId];
1048             currSlot.addr = to;
1049             currSlot.startTimestamp = uint64(block.timestamp);
1050 
1051             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1052             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1053             uint256 nextTokenId = tokenId + 1;
1054             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1055             if (nextSlot.addr == address(0)) {
1056                 // This will suffice for checking _exists(nextTokenId),
1057                 // as a burned slot cannot contain the zero address.
1058                 if (nextTokenId != _currentIndex) {
1059                     nextSlot.addr = from;
1060                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1061                 }
1062             }
1063         }
1064 
1065         emit Transfer(from, to, tokenId);
1066         _afterTokenTransfers(from, to, tokenId, 1);
1067     }
1068 
1069     /**
1070      * @dev Equivalent to `_burn(tokenId, false)`.
1071      */
1072     function _burn(uint256 tokenId) internal virtual {
1073         _burn(tokenId, false);
1074     }
1075 
1076     /**
1077      * @dev Destroys `tokenId`.
1078      * The approval is cleared when the token is burned.
1079      *
1080      * Requirements:
1081      *
1082      * - `tokenId` must exist.
1083      *
1084      * Emits a {Transfer} event.
1085      */
1086     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1087         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1088 
1089         address from = prevOwnership.addr;
1090 
1091         if (approvalCheck) {
1092             bool isApprovedOrOwner = (_msgSender() == from ||
1093                 isApprovedForAll(from, _msgSender()) ||
1094                 getApproved(tokenId) == _msgSender());
1095 
1096             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1097         }
1098 
1099         _beforeTokenTransfers(from, address(0), tokenId, 1);
1100 
1101         // Clear approvals from the previous owner
1102         _approve(address(0), tokenId, from);
1103 
1104         // Underflow of the sender's balance is impossible because we check for
1105         // ownership above and the recipient's balance can't realistically overflow.
1106         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1107         unchecked {
1108             AddressData storage addressData = _addressData[from];
1109             addressData.balance -= 1;
1110             addressData.numberBurned += 1;
1111 
1112             // Keep track of who burned the token, and the timestamp of burning.
1113             TokenOwnership storage currSlot = _ownerships[tokenId];
1114             currSlot.addr = from;
1115             currSlot.startTimestamp = uint64(block.timestamp);
1116             currSlot.burned = true;
1117 
1118             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1119             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1120             uint256 nextTokenId = tokenId + 1;
1121             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1122             if (nextSlot.addr == address(0)) {
1123                 // This will suffice for checking _exists(nextTokenId),
1124                 // as a burned slot cannot contain the zero address.
1125                 if (nextTokenId != _currentIndex) {
1126                     nextSlot.addr = from;
1127                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1128                 }
1129             }
1130         }
1131 
1132         emit Transfer(from, address(0), tokenId);
1133         _afterTokenTransfers(from, address(0), tokenId, 1);
1134 
1135         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1136         unchecked {
1137             _burnCounter++;
1138         }
1139     }
1140 
1141     /**
1142      * @dev Approve `to` to operate on `tokenId`
1143      *
1144      * Emits a {Approval} event.
1145      */
1146     function _approve(
1147         address to,
1148         uint256 tokenId,
1149         address owner
1150     ) private {
1151         _tokenApprovals[tokenId] = to;
1152         emit Approval(owner, to, tokenId);
1153     }
1154 
1155     /**
1156      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1157      *
1158      * @param from address representing the previous owner of the given token ID
1159      * @param to target address that will receive the tokens
1160      * @param tokenId uint256 ID of the token to be transferred
1161      * @param _data bytes optional data to send along with the call
1162      * @return bool whether the call correctly returned the expected magic value
1163      */
1164     function _checkContractOnERC721Received(
1165         address from,
1166         address to,
1167         uint256 tokenId,
1168         bytes memory _data
1169     ) private returns (bool) {
1170         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1171             return retval == IERC721Receiver(to).onERC721Received.selector;
1172         } catch (bytes memory reason) {
1173             if (reason.length == 0) {
1174                 revert TransferToNonERC721ReceiverImplementer();
1175             } else {
1176                 assembly {
1177                     revert(add(32, reason), mload(reason))
1178                 }
1179             }
1180         }
1181     }
1182 
1183     /**
1184      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1185      * And also called before burning one token.
1186      *
1187      * startTokenId - the first token id to be transferred
1188      * quantity - the amount to be transferred
1189      *
1190      * Calling conditions:
1191      *
1192      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1193      * transferred to `to`.
1194      * - When `from` is zero, `tokenId` will be minted for `to`.
1195      * - When `to` is zero, `tokenId` will be burned by `from`.
1196      * - `from` and `to` are never both zero.
1197      */
1198     function _beforeTokenTransfers(
1199         address from,
1200         address to,
1201         uint256 startTokenId,
1202         uint256 quantity
1203     ) internal virtual {}
1204 
1205     /**
1206      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1207      * minting.
1208      * And also called after one token has been burned.
1209      *
1210      * startTokenId - the first token id to be transferred
1211      * quantity - the amount to be transferred
1212      *
1213      * Calling conditions:
1214      *
1215      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1216      * transferred to `to`.
1217      * - When `from` is zero, `tokenId` has been minted for `to`.
1218      * - When `to` is zero, `tokenId` has been burned by `from`.
1219      * - `from` and `to` are never both zero.
1220      */
1221     function _afterTokenTransfers(
1222         address from,
1223         address to,
1224         uint256 startTokenId,
1225         uint256 quantity
1226     ) internal virtual {}
1227 }
1228 
1229 interface IProof {
1230     function verification(address _address,string memory signedMessage) external view returns (bool);
1231 }
1232 
1233 contract ElderTorch is ERC721A, Ownable {
1234     using Strings for uint256;
1235     
1236     IProof private Proof;
1237 
1238     bool public revealed = false;
1239     uint256 public SaleTime = 1657065600;
1240     uint256 public PublicSaleTime = 1657076400;
1241     
1242     address constant receiver = 0xD146e86E62DdDc70B9d02cfb00434400cF58c0BF;
1243     
1244     // Constants
1245     uint256 public constant MAX_TOTALSUPPLY = 10000; 
1246     uint256 public constant MAX_SUPPLY = 9900; 
1247     uint256 public constant MAX_FREESUPPLY = 8000; 
1248     
1249     
1250     uint256 public constant maxBalance = 5 ; 
1251     uint256 public constant maxFreeMint = 2 ; 
1252 
1253     uint256 public mintPrice = 0.016 ether; 
1254 
1255     string baseURI; 
1256     string public notRevealedUri;
1257     string public baseExtension = ".json"; 
1258 
1259     mapping(uint256 => string) private _tokenURIs;
1260     mapping(address => uint256) private mintQuantity;
1261 
1262     uint256 public freeAmount; 
1263     uint256 public paymentAmount; 
1264 
1265     event mintPayable(address from, address to,uint256 amount, uint256 tokenQuantity);
1266 
1267     constructor(string memory initBaseURI, string memory initNotRevealedUri)
1268         ERC721A("Elder Torch", "")
1269     {
1270         setBaseURI(initBaseURI);
1271         setNotRevealedURI(initNotRevealedUri);
1272     }
1273 
1274     function mintElderTorch(uint256 tokenQuantity,string memory signedMessage) public payable {
1275        
1276         require(
1277             totalSupply() + tokenQuantity <= MAX_SUPPLY,
1278             "Sale would exceed max supply"
1279         );
1280         
1281       
1282         require((Proof.verification(msg.sender,signedMessage) == true && block.timestamp >= SaleTime )|| block.timestamp >= PublicSaleTime, "Sale must be active to mint Elder Torch");
1283         
1284         
1285         require(
1286             mintQuantity[msg.sender] + tokenQuantity <= maxBalance,
1287             "Sale would exceed max balance"
1288         );
1289         
1290 
1291         mintQuantity[msg.sender] += tokenQuantity;
1292 
1293         if(mintQuantity[msg.sender] > maxFreeMint || (freeAmount + tokenQuantity) > MAX_FREESUPPLY){
1294            
1295             require(tokenQuantity <= maxBalance - maxFreeMint, "Sale would exceed max times");
1296            
1297             require((paymentAmount + tokenQuantity) <= (MAX_SUPPLY - MAX_FREESUPPLY) ,"Not enough times");
1298 
1299             if((freeAmount + tokenQuantity) > MAX_FREESUPPLY && freeAmount < MAX_FREESUPPLY){
1300 
1301                 uint256 quantity =  tokenQuantity - (MAX_FREESUPPLY - freeAmount);   
1302                 require(
1303                    quantity * mintPrice <= msg.value,
1304                     "Not enough ether sent"
1305                 );
1306                 emit mintPayable(msg.sender, address(this), quantity * mintPrice, quantity);
1307                 paymentAmount += quantity;
1308 
1309             }else{
1310 
1311                 require(
1312                     tokenQuantity * mintPrice <= msg.value,
1313                     "Not enough ether sent"
1314                 );
1315                 emit mintPayable(msg.sender, address(this), tokenQuantity * mintPrice, tokenQuantity );
1316                 paymentAmount += tokenQuantity;
1317             }
1318             
1319 
1320         }else{
1321             
1322             require(tokenQuantity <= maxFreeMint, "Sale would exceed max times");
1323   
1324             require((freeAmount + tokenQuantity) <= MAX_FREESUPPLY ,"Not enough free times");
1325             
1326             freeAmount += tokenQuantity;
1327         }
1328         
1329        
1330         _safeMint(msg.sender, tokenQuantity);        
1331     }
1332 
1333 
1334     function safeMint(address to, uint256 tokenQuantity) public onlyOwner {
1335         _safeMint(to, tokenQuantity);
1336     }
1337 
1338 
1339     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
1340     {
1341         require(
1342             _exists(tokenId),
1343             "ERC721Metadata: URI query for nonexistent token"
1344         );
1345         if (revealed == false) {
1346             return notRevealedUri;
1347         }
1348 
1349         string memory _tokenURI = _tokenURIs[tokenId];
1350         string memory base = _baseURI();
1351 
1352         // If there is no base URI, return the token URI.
1353         if (bytes(base).length == 0) {
1354             return _tokenURI;
1355         }
1356         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1357         if (bytes(_tokenURI).length > 0) {
1358             return string(abi.encodePacked(base, _tokenURI));
1359         }
1360         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1361         return
1362             string(abi.encodePacked(base, tokenId.toString(), baseExtension));
1363     }
1364 
1365     function setProofContract(address _address) external onlyOwner {
1366         Proof = IProof(_address);
1367     }
1368    
1369     function flipReveal() public onlyOwner {
1370         revealed = !revealed;
1371     }
1372 
1373      // internal
1374     function _baseURI() internal view virtual override returns (string memory) {
1375         return baseURI;
1376     }
1377     
1378     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1379         notRevealedUri = _notRevealedURI;
1380     }
1381 
1382     
1383     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1384         baseURI = _newBaseURI;
1385     }
1386     
1387     function setBaseExtension(string memory _newBaseExtension) public onlyOwner
1388     {
1389         baseExtension = _newBaseExtension;
1390     }
1391 
1392     function setSaleTime(uint256 _timestamp) public onlyOwner {
1393         SaleTime = _timestamp;
1394         PublicSaleTime = _timestamp + 3 * 3600;
1395     }
1396 
1397     function setPublicSaleTime(uint256 _timestamp) public onlyOwner {
1398         PublicSaleTime = _timestamp;
1399     }
1400     
1401     function setMintPrice(uint256 _mintPrice) public onlyOwner {
1402         mintPrice = _mintPrice;
1403     }
1404     
1405     function withdraw() public onlyOwner {
1406         uint256 balance = address(this).balance;
1407         payable(receiver).transfer(balance);
1408     }
1409 
1410     
1411     function getBalance() public view returns(uint256) {
1412         return address(this).balance;
1413     }
1414     
1415     function getMintQuantity() public view returns(uint256){
1416         return mintQuantity[msg.sender];
1417     }
1418 
1419     
1420     function getFreeQuantity() public view returns(uint256){
1421         return MAX_FREESUPPLY - freeAmount;
1422     }
1423 
1424     function getPaymentQuantity() public view returns(uint256){
1425         return MAX_SUPPLY - MAX_FREESUPPLY - paymentAmount;
1426     }
1427 
1428     
1429     
1430 }