1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 library Address {
5     /**
6      * @dev Returns true if `account` is a contract.
7      *
8      * [IMPORTANT]
9      * ====
10      * It is unsafe to assume that an address for which this function returns
11      * false is an externally-owned account (EOA) and not a contract.
12      *
13      * Among others, `isContract` will return false for the following
14      * types of addresses:
15      *
16      *  - an externally-owned account
17      *  - a contract in construction
18      *  - an address where a contract will be created
19      *  - an address where a contract lived, but was destroyed
20      * ====
21      *
22      * [IMPORTANT]
23      * ====
24      * You shouldn't rely on `isContract` to protect against flash loan attacks!
25      *
26      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
27      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
28      * constructor.
29      * ====
30      */
31     function isContract(address account) internal view returns (bool) {
32         // This method relies on extcodesize/address.code.length, which returns 0
33         // for contracts in construction, since the code is only stored at the end
34         // of the constructor execution.
35 
36         return account.code.length > 0;
37     }
38 
39     /**
40      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
41      * `recipient`, forwarding all available gas and reverting on errors.
42      *
43      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
44      * of certain opcodes, possibly making contracts go over the 2300 gas limit
45      * imposed by `transfer`, making them unable to receive funds via
46      * `transfer`. {sendValue} removes this limitation.
47      *
48      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
49      *
50      * IMPORTANT: because control is transferred to `recipient`, care must be
51      * taken to not create reentrancy vulnerabilities. Consider using
52      * {ReentrancyGuard} or the
53      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
54      */
55     function sendValue(address payable recipient, uint256 amount) internal {
56         require(address(this).balance >= amount, "Address: insufficient balance");
57 
58         (bool success, ) = recipient.call{value: amount}("");
59         require(success, "Address: unable to send value, recipient may have reverted");
60     }
61 
62     /**
63      * @dev Performs a Solidity function call using a low level `call`. A
64      * plain `call` is an unsafe replacement for a function call: use this
65      * function instead.
66      *
67      * If `target` reverts with a revert reason, it is bubbled up by this
68      * function (like regular Solidity function calls).
69      *
70      * Returns the raw returned data. To convert to the expected return value,
71      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
72      *
73      * Requirements:
74      *
75      * - `target` must be a contract.
76      * - calling `target` with `data` must not revert.
77      *
78      * _Available since v3.1._
79      */
80     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
81         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
82     }
83 
84     /**
85      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
86      * `errorMessage` as a fallback revert reason when `target` reverts.
87      *
88      * _Available since v3.1._
89      */
90     function functionCall(
91         address target,
92         bytes memory data,
93         string memory errorMessage
94     ) internal returns (bytes memory) {
95         return functionCallWithValue(target, data, 0, errorMessage);
96     }
97 
98     /**
99      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
100      * but also transferring `value` wei to `target`.
101      *
102      * Requirements:
103      *
104      * - the calling contract must have an ETH balance of at least `value`.
105      * - the called Solidity function must be `payable`.
106      *
107      * _Available since v3.1._
108      */
109     function functionCallWithValue(
110         address target,
111         bytes memory data,
112         uint256 value
113     ) internal returns (bytes memory) {
114         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
115     }
116 
117     /**
118      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
119      * with `errorMessage` as a fallback revert reason when `target` reverts.
120      *
121      * _Available since v3.1._
122      */
123     function functionCallWithValue(
124         address target,
125         bytes memory data,
126         uint256 value,
127         string memory errorMessage
128     ) internal returns (bytes memory) {
129         require(address(this).balance >= value, "Address: insufficient balance for call");
130         (bool success, bytes memory returndata) = target.call{value: value}(data);
131         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
132     }
133 
134     /**
135      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
136      * but performing a static call.
137      *
138      * _Available since v3.3._
139      */
140     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
141         return functionStaticCall(target, data, "Address: low-level static call failed");
142     }
143 
144     /**
145      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
146      * but performing a static call.
147      *
148      * _Available since v3.3._
149      */
150     function functionStaticCall(
151         address target,
152         bytes memory data,
153         string memory errorMessage
154     ) internal view returns (bytes memory) {
155         (bool success, bytes memory returndata) = target.staticcall(data);
156         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
161      * but performing a delegate call.
162      *
163      * _Available since v3.4._
164      */
165     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
166         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
171      * but performing a delegate call.
172      *
173      * _Available since v3.4._
174      */
175     function functionDelegateCall(
176         address target,
177         bytes memory data,
178         string memory errorMessage
179     ) internal returns (bytes memory) {
180         (bool success, bytes memory returndata) = target.delegatecall(data);
181         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
182     }
183 
184     /**
185      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
186      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
187      *
188      * _Available since v4.8._
189      */
190     function verifyCallResultFromTarget(
191         address target,
192         bool success,
193         bytes memory returndata,
194         string memory errorMessage
195     ) internal view returns (bytes memory) {
196         if (success) {
197             if (returndata.length == 0) {
198                 // only check isContract if the call was successful and the return data is empty
199                 // otherwise we already know that it was a contract
200                 require(isContract(target), "Address: call to non-contract");
201             }
202             return returndata;
203         } else {
204             _revert(returndata, errorMessage);
205         }
206     }
207 
208     /**
209      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
210      * revert reason or using the provided one.
211      *
212      * _Available since v4.3._
213      */
214     function verifyCallResult(
215         bool success,
216         bytes memory returndata,
217         string memory errorMessage
218     ) internal pure returns (bytes memory) {
219         if (success) {
220             return returndata;
221         } else {
222             _revert(returndata, errorMessage);
223         }
224     }
225 
226     function _revert(bytes memory returndata, string memory errorMessage) private pure {
227         // Look for revert reason and bubble it up if present
228         if (returndata.length > 0) {
229             // The easiest way to bubble the revert reason is using memory via assembly
230             /// @solidity memory-safe-assembly
231             assembly {
232                 let returndata_size := mload(returndata)
233                 revert(add(32, returndata), returndata_size)
234             }
235         } else {
236             revert(errorMessage);
237         }
238     }
239 }
240 
241 abstract contract Context {
242     function _msgSender() internal view virtual returns (address) {
243         return msg.sender;
244     }
245 
246     function _msgData() internal view virtual returns (bytes calldata) {
247         return msg.data;
248     }
249 }
250 
251 library Strings {
252     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
253     uint8 private constant _ADDRESS_LENGTH = 20;
254 
255     /**
256      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
257      */
258     function toString(uint256 value) internal pure returns (string memory) {
259         // Inspired by OraclizeAPI's implementation - MIT licence
260         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
261 
262         if (value == 0) {
263             return "0";
264         }
265         uint256 temp = value;
266         uint256 digits;
267         while (temp != 0) {
268             digits++;
269             temp /= 10;
270         }
271         bytes memory buffer = new bytes(digits);
272         while (value != 0) {
273             digits -= 1;
274             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
275             value /= 10;
276         }
277         return string(buffer);
278     }
279 
280     /**
281      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
282      */
283     function toHexString(uint256 value) internal pure returns (string memory) {
284         if (value == 0) {
285             return "0x00";
286         }
287         uint256 temp = value;
288         uint256 length = 0;
289         while (temp != 0) {
290             length++;
291             temp >>= 8;
292         }
293         return toHexString(value, length);
294     }
295 
296     /**
297      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
298      */
299     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
300         bytes memory buffer = new bytes(2 * length + 2);
301         buffer[0] = "0";
302         buffer[1] = "x";
303         for (uint256 i = 2 * length + 1; i > 1; --i) {
304             buffer[i] = _HEX_SYMBOLS[value & 0xf];
305             value >>= 4;
306         }
307         require(value == 0, "Strings: hex length insufficient");
308         return string(buffer);
309     }
310 
311     /**
312      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
313      */
314     function toHexString(address addr) internal pure returns (string memory) {
315         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
316     }
317 }
318 
319 abstract contract Ownable is Context {
320     address private _owner;
321 
322     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
323 
324     /**
325      * @dev Initializes the contract setting the deployer as the initial owner.
326      */
327     constructor() {
328         _transferOwnership(_msgSender());
329     }
330 
331     /**
332      * @dev Throws if called by any account other than the owner.
333      */
334     modifier onlyOwner() {
335         _checkOwner();
336         _;
337     }
338 
339     /**
340      * @dev Returns the address of the current owner.
341      */
342     function owner() public view virtual returns (address) {
343         return _owner;
344     }
345 
346     /**
347      * @dev Throws if the sender is not the owner.
348      */
349     function _checkOwner() internal view virtual {
350         require(owner() == _msgSender(), "Ownable: caller is not the owner");
351     }
352 
353     /**
354      * @dev Leaves the contract without owner. It will not be possible to call
355      * `onlyOwner` functions anymore. Can only be called by the current owner.
356      *
357      * NOTE: Renouncing ownership will leave the contract without an owner,
358      * thereby removing any functionality that is only available to the owner.
359      */
360     function renounceOwnership() public virtual onlyOwner {
361         _transferOwnership(address(0));
362     }
363 
364     /**
365      * @dev Transfers ownership of the contract to a new account (`newOwner`).
366      * Can only be called by the current owner.
367      */
368     function transferOwnership(address newOwner) public virtual onlyOwner {
369         require(newOwner != address(0), "Ownable: new owner is the zero address");
370         _transferOwnership(newOwner);
371     }
372 
373     /**
374      * @dev Transfers ownership of the contract to a new account (`newOwner`).
375      * Internal function without access restriction.
376      */
377     function _transferOwnership(address newOwner) internal virtual {
378         address oldOwner = _owner;
379         _owner = newOwner;
380         emit OwnershipTransferred(oldOwner, newOwner);
381     }
382 }
383 
384 interface IERC165 {
385     /**
386      * @dev Returns true if this contract implements the interface defined by
387      * `interfaceId`. See the corresponding
388      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
389      * to learn more about how these ids are created.
390      *
391      * This function call must use less than 30 000 gas.
392      */
393     function supportsInterface(bytes4 interfaceId) external view returns (bool);
394 }
395 
396 abstract contract ERC165 is IERC165 {
397     /**
398      * @dev See {IERC165-supportsInterface}.
399      */
400     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
401         return interfaceId == type(IERC165).interfaceId;
402     }
403 }
404 
405 interface IERC721 is IERC165 {
406     /**
407      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
408      */
409     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
410 
411     /**
412      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
413      */
414     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
415 
416     /**
417      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
418      */
419     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
420 
421     /**
422      * @dev Returns the number of tokens in ``owner``'s account.
423      */
424     function balanceOf(address owner) external view returns (uint256 balance);
425 
426     /**
427      * @dev Returns the owner of the `tokenId` token.
428      *
429      * Requirements:
430      *
431      * - `tokenId` must exist.
432      */
433     function ownerOf(uint256 tokenId) external view returns (address owner);
434 
435     /**
436      * @dev Safely transfers `tokenId` token from `from` to `to`.
437      *
438      * Requirements:
439      *
440      * - `from` cannot be the zero address.
441      * - `to` cannot be the zero address.
442      * - `tokenId` token must exist and be owned by `from`.
443      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
444      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
445      *
446      * Emits a {Transfer} event.
447      */
448     function safeTransferFrom(
449         address from,
450         address to,
451         uint256 tokenId,
452         bytes calldata data
453     ) external;
454 
455     /**
456      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
457      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
458      *
459      * Requirements:
460      *
461      * - `from` cannot be the zero address.
462      * - `to` cannot be the zero address.
463      * - `tokenId` token must exist and be owned by `from`.
464      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
465      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
466      *
467      * Emits a {Transfer} event.
468      */
469     function safeTransferFrom(
470         address from,
471         address to,
472         uint256 tokenId
473     ) external;
474 
475     /**
476      * @dev Transfers `tokenId` token from `from` to `to`.
477      *
478      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
479      *
480      * Requirements:
481      *
482      * - `from` cannot be the zero address.
483      * - `to` cannot be the zero address.
484      * - `tokenId` token must be owned by `from`.
485      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
486      *
487      * Emits a {Transfer} event.
488      */
489     function transferFrom(
490         address from,
491         address to,
492         uint256 tokenId
493     ) external;
494 
495     /**
496      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
497      * The approval is cleared when the token is transferred.
498      *
499      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
500      *
501      * Requirements:
502      *
503      * - The caller must own the token or be an approved operator.
504      * - `tokenId` must exist.
505      *
506      * Emits an {Approval} event.
507      */
508     function approve(address to, uint256 tokenId) external;
509 
510     /**
511      * @dev Approve or remove `operator` as an operator for the caller.
512      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
513      *
514      * Requirements:
515      *
516      * - The `operator` cannot be the caller.
517      *
518      * Emits an {ApprovalForAll} event.
519      */
520     function setApprovalForAll(address operator, bool _approved) external;
521 
522     /**
523      * @dev Returns the account approved for `tokenId` token.
524      *
525      * Requirements:
526      *
527      * - `tokenId` must exist.
528      */
529     function getApproved(uint256 tokenId) external view returns (address operator);
530 
531     /**
532      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
533      *
534      * See {setApprovalForAll}
535      */
536     function isApprovedForAll(address owner, address operator) external view returns (bool);
537 }
538 
539 interface IERC721Receiver {
540     /**
541      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
542      * by `operator` from `from`, this function is called.
543      *
544      * It must return its Solidity selector to confirm the token transfer.
545      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
546      *
547      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
548      */
549     function onERC721Received(
550         address operator,
551         address from,
552         uint256 tokenId,
553         bytes calldata data
554     ) external returns (bytes4);
555 }
556 
557 interface IERC721Metadata is IERC721 {
558     /**
559      * @dev Returns the token collection name.
560      */
561     function name() external view returns (string memory);
562 
563     /**
564      * @dev Returns the token collection symbol.
565      */
566     function symbol() external view returns (string memory);
567 
568     /**
569      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
570      */
571     function tokenURI(uint256 tokenId) external view returns (string memory);
572 }
573 
574 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
575     using Address for address;
576     using Strings for uint256;
577 
578     // Token name
579     string private _name;
580 
581     // Token symbol
582     string private _symbol;
583 
584     // Mapping from token ID to owner address
585     mapping(uint256 => address) private _owners;
586 
587     // Mapping owner address to token count
588     mapping(address => uint256) private _balances;
589 
590     // Mapping from token ID to approved address
591     mapping(uint256 => address) private _tokenApprovals;
592 
593     // Mapping from owner to operator approvals
594     mapping(address => mapping(address => bool)) private _operatorApprovals;
595 
596     /**
597      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
598      */
599     constructor(string memory name_, string memory symbol_) {
600         _name = name_;
601         _symbol = symbol_;
602     }
603 
604     /**
605      * @dev See {IERC165-supportsInterface}.
606      */
607     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
608         return
609             interfaceId == type(IERC721).interfaceId ||
610             interfaceId == type(IERC721Metadata).interfaceId ||
611             super.supportsInterface(interfaceId);
612     }
613 
614     /**
615      * @dev See {IERC721-balanceOf}.
616      */
617     function balanceOf(address owner) public view virtual override returns (uint256) {
618         require(owner != address(0), "ERC721: address zero is not a valid owner");
619         return _balances[owner];
620     }
621 
622     /**
623      * @dev See {IERC721-ownerOf}.
624      */
625     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
626         address owner = _owners[tokenId];
627         require(owner != address(0), "ERC721: invalid token ID");
628         return owner;
629     }
630 
631     /**
632      * @dev See {IERC721Metadata-name}.
633      */
634     function name() public view virtual override returns (string memory) {
635         return _name;
636     }
637 
638     /**
639      * @dev See {IERC721Metadata-symbol}.
640      */
641     function symbol() public view virtual override returns (string memory) {
642         return _symbol;
643     }
644 
645     /**
646      * @dev See {IERC721Metadata-tokenURI}.
647      */
648     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
649         _requireMinted(tokenId);
650 
651         string memory baseURI = _baseURI();
652         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
653     }
654 
655     /**
656      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
657      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
658      * by default, can be overridden in child contracts.
659      */
660     function _baseURI() internal view virtual returns (string memory) {
661         return "";
662     }
663 
664     /**
665      * @dev See {IERC721-approve}.
666      */
667     function approve(address to, uint256 tokenId) public virtual override {
668         address owner = ERC721.ownerOf(tokenId);
669         require(to != owner, "ERC721: approval to current owner");
670 
671         require(
672             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
673             "ERC721: approve caller is not token owner or approved for all"
674         );
675 
676         _approve(to, tokenId);
677     }
678 
679     /**
680      * @dev See {IERC721-getApproved}.
681      */
682     function getApproved(uint256 tokenId) public view virtual override returns (address) {
683         _requireMinted(tokenId);
684 
685         return _tokenApprovals[tokenId];
686     }
687 
688     /**
689      * @dev See {IERC721-setApprovalForAll}.
690      */
691     function setApprovalForAll(address operator, bool approved) public virtual override {
692         _setApprovalForAll(_msgSender(), operator, approved);
693     }
694 
695     /**
696      * @dev See {IERC721-isApprovedForAll}.
697      */
698     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
699         return _operatorApprovals[owner][operator];
700     }
701 
702     /**
703      * @dev See {IERC721-transferFrom}.
704      */
705     function transferFrom(
706         address from,
707         address to,
708         uint256 tokenId
709     ) public virtual override {
710         //solhint-disable-next-line max-line-length
711         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
712 
713         _transfer(from, to, tokenId);
714     }
715 
716     /**
717      * @dev See {IERC721-safeTransferFrom}.
718      */
719     function safeTransferFrom(
720         address from,
721         address to,
722         uint256 tokenId
723     ) public virtual override {
724         safeTransferFrom(from, to, tokenId, "");
725     }
726 
727     /**
728      * @dev See {IERC721-safeTransferFrom}.
729      */
730     function safeTransferFrom(
731         address from,
732         address to,
733         uint256 tokenId,
734         bytes memory data
735     ) public virtual override {
736         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
737         _safeTransfer(from, to, tokenId, data);
738     }
739 
740     /**
741      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
742      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
743      *
744      * `data` is additional data, it has no specified format and it is sent in call to `to`.
745      *
746      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
747      * implement alternative mechanisms to perform token transfer, such as signature-based.
748      *
749      * Requirements:
750      *
751      * - `from` cannot be the zero address.
752      * - `to` cannot be the zero address.
753      * - `tokenId` token must exist and be owned by `from`.
754      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
755      *
756      * Emits a {Transfer} event.
757      */
758     function _safeTransfer(
759         address from,
760         address to,
761         uint256 tokenId,
762         bytes memory data
763     ) internal virtual {
764         _transfer(from, to, tokenId);
765         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
766     }
767 
768     /**
769      * @dev Returns whether `tokenId` exists.
770      *
771      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
772      *
773      * Tokens start existing when they are minted (`_mint`),
774      * and stop existing when they are burned (`_burn`).
775      */
776     function _exists(uint256 tokenId) internal view virtual returns (bool) {
777         return _owners[tokenId] != address(0);
778     }
779 
780     /**
781      * @dev Returns whether `spender` is allowed to manage `tokenId`.
782      *
783      * Requirements:
784      *
785      * - `tokenId` must exist.
786      */
787     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
788         address owner = ERC721.ownerOf(tokenId);
789         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
790     }
791 
792     /**
793      * @dev Safely mints `tokenId` and transfers it to `to`.
794      *
795      * Requirements:
796      *
797      * - `tokenId` must not exist.
798      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
799      *
800      * Emits a {Transfer} event.
801      */
802     function _safeMint(address to, uint256 tokenId) internal virtual {
803         _safeMint(to, tokenId, "");
804     }
805 
806     /**
807      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
808      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
809      */
810     function _safeMint(
811         address to,
812         uint256 tokenId,
813         bytes memory data
814     ) internal virtual {
815         _mint(to, tokenId);
816         require(
817             _checkOnERC721Received(address(0), to, tokenId, data),
818             "ERC721: transfer to non ERC721Receiver implementer"
819         );
820     }
821 
822     /**
823      * @dev Mints `tokenId` and transfers it to `to`.
824      *
825      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
826      *
827      * Requirements:
828      *
829      * - `tokenId` must not exist.
830      * - `to` cannot be the zero address.
831      *
832      * Emits a {Transfer} event.
833      */
834     function _mint(address to, uint256 tokenId) internal virtual {
835         require(to != address(0), "ERC721: mint to the zero address");
836         require(!_exists(tokenId), "ERC721: token already minted");
837 
838         _beforeTokenTransfer(address(0), to, tokenId);
839 
840         _balances[to] += 1;
841         _owners[tokenId] = to;
842 
843         emit Transfer(address(0), to, tokenId);
844 
845         _afterTokenTransfer(address(0), to, tokenId);
846     }
847 
848     /**
849      * @dev Destroys `tokenId`.
850      * The approval is cleared when the token is burned.
851      * This is an internal function that does not check if the sender is authorized to operate on the token.
852      *
853      * Requirements:
854      *
855      * - `tokenId` must exist.
856      *
857      * Emits a {Transfer} event.
858      */
859     function _burn(uint256 tokenId) internal virtual {
860         address owner = ERC721.ownerOf(tokenId);
861 
862         _beforeTokenTransfer(owner, address(0), tokenId);
863 
864         // Clear approvals
865         delete _tokenApprovals[tokenId];
866 
867         _balances[owner] -= 1;
868         delete _owners[tokenId];
869 
870         emit Transfer(owner, address(0), tokenId);
871 
872         _afterTokenTransfer(owner, address(0), tokenId);
873     }
874 
875     /**
876      * @dev Transfers `tokenId` from `from` to `to`.
877      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
878      *
879      * Requirements:
880      *
881      * - `to` cannot be the zero address.
882      * - `tokenId` token must be owned by `from`.
883      *
884      * Emits a {Transfer} event.
885      */
886     function _transfer(
887         address from,
888         address to,
889         uint256 tokenId
890     ) internal virtual {
891         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
892         require(to != address(0), "ERC721: transfer to the zero address");
893 
894         _beforeTokenTransfer(from, to, tokenId);
895 
896         // Clear approvals from the previous owner
897         delete _tokenApprovals[tokenId];
898 
899         _balances[from] -= 1;
900         _balances[to] += 1;
901         _owners[tokenId] = to;
902 
903         emit Transfer(from, to, tokenId);
904 
905         _afterTokenTransfer(from, to, tokenId);
906     }
907 
908     /**
909      * @dev Approve `to` to operate on `tokenId`
910      *
911      * Emits an {Approval} event.
912      */
913     function _approve(address to, uint256 tokenId) internal virtual {
914         _tokenApprovals[tokenId] = to;
915         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
916     }
917 
918     /**
919      * @dev Approve `operator` to operate on all of `owner` tokens
920      *
921      * Emits an {ApprovalForAll} event.
922      */
923     function _setApprovalForAll(
924         address owner,
925         address operator,
926         bool approved
927     ) internal virtual {
928         require(owner != operator, "ERC721: approve to caller");
929         _operatorApprovals[owner][operator] = approved;
930         emit ApprovalForAll(owner, operator, approved);
931     }
932 
933     /**
934      * @dev Reverts if the `tokenId` has not been minted yet.
935      */
936     function _requireMinted(uint256 tokenId) internal view virtual {
937         require(_exists(tokenId), "ERC721: invalid token ID");
938     }
939 
940     /**
941      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
942      * The call is not executed if the target address is not a contract.
943      *
944      * @param from address representing the previous owner of the given token ID
945      * @param to target address that will receive the tokens
946      * @param tokenId uint256 ID of the token to be transferred
947      * @param data bytes optional data to send along with the call
948      * @return bool whether the call correctly returned the expected magic value
949      */
950     function _checkOnERC721Received(
951         address from,
952         address to,
953         uint256 tokenId,
954         bytes memory data
955     ) private returns (bool) {
956         if (to.isContract()) {
957             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
958                 return retval == IERC721Receiver.onERC721Received.selector;
959             } catch (bytes memory reason) {
960                 if (reason.length == 0) {
961                     revert("ERC721: transfer to non ERC721Receiver implementer");
962                 } else {
963                     /// @solidity memory-safe-assembly
964                     assembly {
965                         revert(add(32, reason), mload(reason))
966                     }
967                 }
968             }
969         } else {
970             return true;
971         }
972     }
973 
974     /**
975      * @dev Hook that is called before any token transfer. This includes minting
976      * and burning.
977      *
978      * Calling conditions:
979      *
980      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
981      * transferred to `to`.
982      * - When `from` is zero, `tokenId` will be minted for `to`.
983      * - When `to` is zero, ``from``'s `tokenId` will be burned.
984      * - `from` and `to` are never both zero.
985      *
986      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
987      */
988     function _beforeTokenTransfer(
989         address from,
990         address to,
991         uint256 tokenId
992     ) internal virtual {}
993 
994     /**
995      * @dev Hook that is called after any transfer of tokens. This includes
996      * minting and burning.
997      *
998      * Calling conditions:
999      *
1000      * - when `from` and `to` are both non-zero.
1001      * - `from` and `to` are never both zero.
1002      *
1003      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1004      */
1005     function _afterTokenTransfer(
1006         address from,
1007         address to,
1008         uint256 tokenId
1009     ) internal virtual {}
1010 }
1011 
1012 interface IERC721Enumerable is IERC721 {
1013     /**
1014      * @dev Returns the total amount of tokens stored by the contract.
1015      */
1016     function totalSupply() external view returns (uint256);
1017 
1018     /**
1019      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1020      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1021      */
1022     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1023 
1024     /**
1025      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1026      * Use along with {totalSupply} to enumerate all tokens.
1027      */
1028     function tokenByIndex(uint256 index) external view returns (uint256);
1029 }
1030 
1031 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1032     // Mapping from owner to list of owned token IDs
1033     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1034 
1035     // Mapping from token ID to index of the owner tokens list
1036     mapping(uint256 => uint256) private _ownedTokensIndex;
1037 
1038     // Array with all token ids, used for enumeration
1039     uint256[] private _allTokens;
1040 
1041     // Mapping from token id to position in the allTokens array
1042     mapping(uint256 => uint256) private _allTokensIndex;
1043 
1044     /**
1045      * @dev See {IERC165-supportsInterface}.
1046      */
1047     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1048         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1049     }
1050 
1051     /**
1052      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1053      */
1054     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1055         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1056         return _ownedTokens[owner][index];
1057     }
1058 
1059     /**
1060      * @dev See {IERC721Enumerable-totalSupply}.
1061      */
1062     function totalSupply() public view virtual override returns (uint256) {
1063         return _allTokens.length;
1064     }
1065 
1066     /**
1067      * @dev See {IERC721Enumerable-tokenByIndex}.
1068      */
1069     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1070         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1071         return _allTokens[index];
1072     }
1073 
1074     /**
1075      * @dev Hook that is called before any token transfer. This includes minting
1076      * and burning.
1077      *
1078      * Calling conditions:
1079      *
1080      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1081      * transferred to `to`.
1082      * - When `from` is zero, `tokenId` will be minted for `to`.
1083      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1084      * - `from` cannot be the zero address.
1085      * - `to` cannot be the zero address.
1086      *
1087      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1088      */
1089     function _beforeTokenTransfer(
1090         address from,
1091         address to,
1092         uint256 tokenId
1093     ) internal virtual override {
1094         super._beforeTokenTransfer(from, to, tokenId);
1095 
1096         if (from == address(0)) {
1097             _addTokenToAllTokensEnumeration(tokenId);
1098         } else if (from != to) {
1099             _removeTokenFromOwnerEnumeration(from, tokenId);
1100         }
1101         if (to == address(0)) {
1102             _removeTokenFromAllTokensEnumeration(tokenId);
1103         } else if (to != from) {
1104             _addTokenToOwnerEnumeration(to, tokenId);
1105         }
1106     }
1107 
1108     /**
1109      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1110      * @param to address representing the new owner of the given token ID
1111      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1112      */
1113     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1114         uint256 length = ERC721.balanceOf(to);
1115         _ownedTokens[to][length] = tokenId;
1116         _ownedTokensIndex[tokenId] = length;
1117     }
1118 
1119     /**
1120      * @dev Private function to add a token to this extension's token tracking data structures.
1121      * @param tokenId uint256 ID of the token to be added to the tokens list
1122      */
1123     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1124         _allTokensIndex[tokenId] = _allTokens.length;
1125         _allTokens.push(tokenId);
1126     }
1127 
1128     /**
1129      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1130      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1131      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1132      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1133      * @param from address representing the previous owner of the given token ID
1134      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1135      */
1136     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1137         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1138         // then delete the last slot (swap and pop).
1139 
1140         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1141         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1142 
1143         // When the token to delete is the last token, the swap operation is unnecessary
1144         if (tokenIndex != lastTokenIndex) {
1145             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1146 
1147             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1148             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1149         }
1150 
1151         // This also deletes the contents at the last position of the array
1152         delete _ownedTokensIndex[tokenId];
1153         delete _ownedTokens[from][lastTokenIndex];
1154     }
1155 
1156     /**
1157      * @dev Private function to remove a token from this extension's token tracking data structures.
1158      * This has O(1) time complexity, but alters the order of the _allTokens array.
1159      * @param tokenId uint256 ID of the token to be removed from the tokens list
1160      */
1161     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1162         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1163         // then delete the last slot (swap and pop).
1164 
1165         uint256 lastTokenIndex = _allTokens.length - 1;
1166         uint256 tokenIndex = _allTokensIndex[tokenId];
1167 
1168         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1169         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1170         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1171         uint256 lastTokenId = _allTokens[lastTokenIndex];
1172 
1173         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1174         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1175 
1176         // This also deletes the contents at the last position of the array
1177         delete _allTokensIndex[tokenId];
1178         _allTokens.pop();
1179     }
1180 }
1181 
1182 interface IERC20 {
1183     /**
1184      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1185      * another (`to`).
1186      *
1187      * Note that `value` may be zero.
1188      */
1189     event Transfer(address indexed from, address indexed to, uint256 value);
1190 
1191     /**
1192      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1193      * a call to {approve}. `value` is the new allowance.
1194      */
1195     event Approval(address indexed owner, address indexed spender, uint256 value);
1196 
1197     /**
1198      * @dev Returns the amount of tokens in existence.
1199      */
1200     function totalSupply() external view returns (uint256);
1201 
1202     /**
1203      * @dev Returns the amount of tokens owned by `account`.
1204      */
1205     function balanceOf(address account) external view returns (uint256);
1206 
1207     /**
1208      * @dev Moves `amount` tokens from the caller's account to `to`.
1209      *
1210      * Returns a boolean value indicating whether the operation succeeded.
1211      *
1212      * Emits a {Transfer} event.
1213      */
1214     function transfer(address to, uint256 amount) external returns (bool);
1215 
1216     /**
1217      * @dev Returns the remaining number of tokens that `spender` will be
1218      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1219      * zero by default.
1220      *
1221      * This value changes when {approve} or {transferFrom} are called.
1222      */
1223     function allowance(address owner, address spender) external view returns (uint256);
1224 
1225     /**
1226      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1227      *
1228      * Returns a boolean value indicating whether the operation succeeded.
1229      *
1230      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1231      * that someone may use both the old and the new allowance by unfortunate
1232      * transaction ordering. One possible solution to mitigate this race
1233      * condition is to first reduce the spender's allowance to 0 and set the
1234      * desired value afterwards:
1235      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1236      *
1237      * Emits an {Approval} event.
1238      */
1239     function approve(address spender, uint256 amount) external returns (bool);
1240 
1241     /**
1242      * @dev Moves `amount` tokens from `from` to `to` using the
1243      * allowance mechanism. `amount` is then deducted from the caller's
1244      * allowance.
1245      *
1246      * Returns a boolean value indicating whether the operation succeeded.
1247      *
1248      * Emits a {Transfer} event.
1249      */
1250     function transferFrom(
1251         address from,
1252         address to,
1253         uint256 amount
1254     ) external returns (bool);
1255 }
1256 
1257 interface IERC20Permit {
1258     /**
1259      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1260      * given ``owner``'s signed approval.
1261      *
1262      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1263      * ordering also apply here.
1264      *
1265      * Emits an {Approval} event.
1266      *
1267      * Requirements:
1268      *
1269      * - `spender` cannot be the zero address.
1270      * - `deadline` must be a timestamp in the future.
1271      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1272      * over the EIP712-formatted function arguments.
1273      * - the signature must use ``owner``'s current nonce (see {nonces}).
1274      *
1275      * For more information on the signature format, see the
1276      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1277      * section].
1278      */
1279     function permit(
1280         address owner,
1281         address spender,
1282         uint256 value,
1283         uint256 deadline,
1284         uint8 v,
1285         bytes32 r,
1286         bytes32 s
1287     ) external;
1288 
1289     /**
1290      * @dev Returns the current nonce for `owner`. This value must be
1291      * included whenever a signature is generated for {permit}.
1292      *
1293      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1294      * prevents a signature from being used multiple times.
1295      */
1296     function nonces(address owner) external view returns (uint256);
1297 
1298     /**
1299      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1300      */
1301     // solhint-disable-next-line func-name-mixedcase
1302     function DOMAIN_SEPARATOR() external view returns (bytes32);
1303 }
1304 
1305 library SafeERC20 {
1306     using Address for address;
1307 
1308     function safeTransfer(
1309         IERC20 token,
1310         address to,
1311         uint256 value
1312     ) internal {
1313         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1314     }
1315 
1316     function safeTransferFrom(
1317         IERC20 token,
1318         address from,
1319         address to,
1320         uint256 value
1321     ) internal {
1322         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1323     }
1324 
1325     /**
1326      * @dev Deprecated. This function has issues similar to the ones found in
1327      * {IERC20-approve}, and its usage is discouraged.
1328      *
1329      * Whenever possible, use {safeIncreaseAllowance} and
1330      * {safeDecreaseAllowance} instead.
1331      */
1332     function safeApprove(
1333         IERC20 token,
1334         address spender,
1335         uint256 value
1336     ) internal {
1337         // safeApprove should only be called when setting an initial allowance,
1338         // or when resetting it to zero. To increase and decrease it, use
1339         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1340         require(
1341             (value == 0) || (token.allowance(address(this), spender) == 0),
1342             "SafeERC20: approve from non-zero to non-zero allowance"
1343         );
1344         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1345     }
1346 
1347     function safeIncreaseAllowance(
1348         IERC20 token,
1349         address spender,
1350         uint256 value
1351     ) internal {
1352         uint256 newAllowance = token.allowance(address(this), spender) + value;
1353         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1354     }
1355 
1356     function safeDecreaseAllowance(
1357         IERC20 token,
1358         address spender,
1359         uint256 value
1360     ) internal {
1361         unchecked {
1362             uint256 oldAllowance = token.allowance(address(this), spender);
1363             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1364             uint256 newAllowance = oldAllowance - value;
1365             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1366         }
1367     }
1368 
1369     function safePermit(
1370         IERC20Permit token,
1371         address owner,
1372         address spender,
1373         uint256 value,
1374         uint256 deadline,
1375         uint8 v,
1376         bytes32 r,
1377         bytes32 s
1378     ) internal {
1379         uint256 nonceBefore = token.nonces(owner);
1380         token.permit(owner, spender, value, deadline, v, r, s);
1381         uint256 nonceAfter = token.nonces(owner);
1382         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1383     }
1384 
1385     /**
1386      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1387      * on the return value: the return value is optional (but if data is returned, it must not be false).
1388      * @param token The token targeted by the call.
1389      * @param data The call data (encoded using abi.encode or one of its variants).
1390      */
1391     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1392         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1393         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1394         // the target address contains contract code and also asserts for success in the low-level call.
1395 
1396         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1397         if (returndata.length > 0) {
1398             // Return data is optional
1399             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1400         }
1401     }
1402 }
1403 
1404 abstract contract ReentrancyGuard {
1405     // Booleans are more expensive than uint256 or any type that takes up a full
1406     // word because each write operation emits an extra SLOAD to first read the
1407     // slot's contents, replace the bits taken up by the boolean, and then write
1408     // back. This is the compiler's defense against contract upgrades and
1409     // pointer aliasing, and it cannot be disabled.
1410 
1411     // The values being non-zero value makes deployment a bit more expensive,
1412     // but in exchange the refund on every call to nonReentrant will be lower in
1413     // amount. Since refunds are capped to a percentage of the total
1414     // transaction's gas, it is best to keep them low in cases like this one, to
1415     // increase the likelihood of the full refund coming into effect.
1416     uint256 private constant _NOT_ENTERED = 1;
1417     uint256 private constant _ENTERED = 2;
1418 
1419     uint256 private _status;
1420 
1421     constructor() {
1422         _status = _NOT_ENTERED;
1423     }
1424 
1425     /**
1426      * @dev Prevents a contract from calling itself, directly or indirectly.
1427      * Calling a `nonReentrant` function from another `nonReentrant`
1428      * function is not supported. It is possible to prevent this from happening
1429      * by making the `nonReentrant` function external, and making it call a
1430      * `private` function that does the actual work.
1431      */
1432     modifier nonReentrant() {
1433         _nonReentrantBefore();
1434         _;
1435         _nonReentrantAfter();
1436     }
1437 
1438     function _nonReentrantBefore() private {
1439         // On the first call to nonReentrant, _notEntered will be true
1440         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1441 
1442         // Any calls to nonReentrant after this point will fail
1443         _status = _ENTERED;
1444     }
1445 
1446     function _nonReentrantAfter() private {
1447         // By storing the original value once again, a refund is triggered (see
1448         // https://eips.ethereum.org/EIPS/eip-2200)
1449         _status = _NOT_ENTERED;
1450     }
1451 }
1452 
1453 interface IElderGods {
1454     function isSloth(uint256 tokenId) external view returns (bool);
1455 }
1456 
1457 interface IERC4907 {
1458 
1459     // Logged when the user of an NFT is changed or expires is changed
1460     /// @notice Emitted when the `user` of an NFT or the `expires` of the `user` is changed
1461     /// The zero address for user indicates that there is no user address
1462     event UpdateUser(uint256 indexed tokenId, address indexed user, uint64 expires);
1463 
1464     /// @notice set the user and expires of an NFT
1465     /// @dev The zero address indicates there is no user
1466     /// Throws if `tokenId` is not valid NFT
1467     /// @param user  The new user of the NFT
1468     /// @param expires  UNIX timestamp, The new user could use the NFT before expires
1469     function setUser(uint256 tokenId, address user, uint64 expires) external;
1470 
1471     /// @notice Get the user address of an NFT
1472     /// @dev The zero address indicates that there is no user or the user is expired
1473     /// @param tokenId The NFT to get the user address for
1474     /// @return The user address for this NFT
1475     function userOf(uint256 tokenId) external view returns(address);
1476 
1477     /// @notice Get the user expires of an NFT
1478     /// @dev The zero value indicates that there is no user
1479     /// @param tokenId The NFT to get the user expires for
1480     /// @return The user expires for this NFT
1481     function userExpires(uint256 tokenId) external view returns(uint256);
1482 }
1483 
1484 interface IOperatorFilterRegistry {
1485     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1486     function register(address registrant) external;
1487     function registerAndSubscribe(address registrant, address subscription) external;
1488     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1489     function unregister(address addr) external;
1490     function updateOperator(address registrant, address operator, bool filtered) external;
1491     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1492     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1493     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1494     function subscribe(address registrant, address registrantToSubscribe) external;
1495     function unsubscribe(address registrant, bool copyExistingEntries) external;
1496     function subscriptionOf(address addr) external returns (address registrant);
1497     function subscribers(address registrant) external returns (address[] memory);
1498     function subscriberAt(address registrant, uint256 index) external returns (address);
1499     function copyEntriesOf(address registrant, address registrantToCopy) external;
1500     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1501     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1502     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1503     function filteredOperators(address addr) external returns (address[] memory);
1504     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1505     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1506     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1507     function isRegistered(address addr) external returns (bool);
1508     function codeHashOf(address addr) external returns (bytes32);
1509 }
1510 
1511 abstract contract OperatorFilterer {
1512     error OperatorNotAllowed(address operator);
1513 
1514     IOperatorFilterRegistry public OPERATOR_FILTER_REGISTRY =
1515         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1516 
1517     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1518         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1519         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1520         // order for the modifier to filter addresses.
1521         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1522             if (subscribe) {
1523                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1524             } else {
1525                 if (subscriptionOrRegistrantToCopy != address(0)) {
1526                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1527                 } else {
1528                     OPERATOR_FILTER_REGISTRY.register(address(this));
1529                 }
1530             }
1531         }
1532     }
1533 
1534     modifier onlyAllowedOperator(address from) virtual {
1535         // Allow spending tokens from addresses with balance
1536         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1537         // from an EOA.
1538         if (from != msg.sender) {
1539             _checkFilterOperator(msg.sender);
1540         }
1541         _;
1542     }
1543 
1544     modifier onlyAllowedOperatorApproval(address operator) virtual {
1545         _checkFilterOperator(operator);
1546         _;
1547     }
1548 
1549     function _checkFilterOperator(address operator) internal view virtual {
1550         // Check registry code length to facilitate testing in environments without a deployed registry.
1551         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1552             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1553                 revert OperatorNotAllowed(operator);
1554             }
1555         }
1556     }
1557 }
1558 
1559 /**
1560  * @title  DefaultOperatorFilterer
1561  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1562  */
1563 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1564     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1565 
1566     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1567 }
1568 
1569 contract ElderGODS is ERC721Enumerable, Ownable, IERC4907, ReentrancyGuard, DefaultOperatorFilterer {
1570     using Address for address payable;
1571     using Strings for uint256;
1572     using SafeERC20 for IERC20;
1573 
1574     mapping (uint256  => bool) public isSloth; 
1575 
1576     uint256 private constant MAX_SUPPLY = 4488;
1577 
1578     address public immutable ELDERGODS_old;
1579 
1580     uint256 private airdropTokenCount;
1581 
1582     string private baseURI_;
1583     string private baseExtension_ = ".json";
1584 
1585     address private treasury = 0xB85e653e74060b092eF14C410d5FDf397bEc856d;
1586 
1587     constructor (string memory name_, string memory symbol_, address _ig) ERC721(name_, symbol_) {
1588         ELDERGODS_old = _ig;
1589         allowedTokens[WETH] = true;
1590         allowedTokens[address(0)] = true;
1591         treasury = 0xB85e653e74060b092eF14C410d5FDf397bEc856d;
1592     }
1593 
1594     function airdrop(uint256 gasLimit) external onlyOwner nonReentrant {
1595         address to;
1596         uint256 last;
1597         for (uint256 x = airdropTokenCount + 1; x <= IERC721Enumerable(ELDERGODS_old).totalSupply() && gasleft() > gasLimit;) {
1598             to = IERC721(ELDERGODS_old).ownerOf(x);
1599             if (IElderGods(ELDERGODS_old).isSloth(x)) {
1600                 isSloth[x] = true;
1601             }
1602             _safeMint(to, x);
1603             last = x;
1604             unchecked {
1605                 ++ x;
1606             }
1607         }
1608         airdropTokenCount = last;
1609     }
1610 
1611     function getEldersSupply() external view returns (uint256) {
1612         return IERC721Enumerable(ELDERGODS_old).totalSupply();
1613     }
1614 
1615     function returnToTreasury(uint256 gasLimit) external onlyOwner nonReentrant {
1616         require(totalSupply() >= IERC721Enumerable(ELDERGODS_old).totalSupply(), "GODS: Not all airdropped");
1617         require(treasury != address(0), "GODS: To address(0)");
1618         while (totalSupply() <= MAX_SUPPLY && gasleft() > gasLimit) {
1619             _safeMint(treasury, totalSupply() + 1);
1620         }
1621     }
1622 
1623     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1624         _requireMinted(tokenId);
1625         return bytes(baseURI_).length > 0 ? string(abi.encodePacked(baseURI_, tokenId.toString(), baseExtension_)) : "";
1626     }
1627 
1628     /// @dev EIP4907
1629 
1630     uint256 public godsFee;
1631     uint256 private constant denominator = 1000;
1632     bool public canRent;
1633 
1634     address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
1635 
1636     mapping (address => bool) public allowedTokens;
1637 
1638     struct Rent {
1639         address user;
1640         uint64 expires;
1641     }
1642 
1643     mapping (uint256 => Rent) public rent;
1644 
1645     struct RentBids {
1646         uint256 tokenId;
1647         uint256 price;
1648         address user;
1649         uint256 expiry;
1650         address payToken;
1651         uint64 duration;
1652     }
1653 
1654     mapping (uint256 => RentBids) public rentBids;
1655     uint256 public rentBidsCounter;
1656 
1657     struct RentableItems {
1658         uint256 price;
1659         address lender;
1660         uint64 expiry;
1661         address payToken;
1662         uint64 duration;
1663     }
1664 
1665     mapping (uint256 => RentableItems) public rentableItems;
1666 
1667     event BidPlaced(uint256 indexed bidId, uint256 tokenId, uint64 expiry, uint64 duration, uint256 price, address token);
1668     event BidDeleted(uint256 bidId);
1669     event NFTListedForRent(uint256 tokenId, uint64 expiry, uint64 duration, uint256 price, address token);
1670     event NFTDeletedFromRent(uint256 tokenId);
1671 
1672     modifier rentability() {
1673         require(canRent, "GODS: Rent is currently disabled");
1674         _;
1675     }
1676 
1677     function setUser(uint256 tokenId, address user, uint64 expires) public override rentability {
1678         require(_msgSender() == ownerOf(tokenId), "GODS: Not owner");
1679         _setUser(tokenId, user, expires);
1680     }
1681 
1682     function _setUser(uint256 tokenId, address _user, uint64 _expires) internal {
1683         _requireMinted(tokenId);
1684         require(rent[tokenId].user == address(0) || rent[tokenId].expires < block.timestamp, "GODS: Currently Rented");
1685         rent[tokenId] = Rent({
1686             user: _user,
1687             expires: _expires
1688         });
1689         emit UpdateUser(tokenId, _user, _expires);
1690     }
1691 
1692     function userOf(uint256 tokenId) external view returns (address) {
1693         _requireMinted(tokenId);
1694         return rent[tokenId].expires < block.timestamp ? address(0) : rent[tokenId].user;
1695     }
1696 
1697     function userExpires(uint256 tokenId) external view returns(uint256) {
1698         _requireMinted(tokenId);
1699         return rent[tokenId].expires < block.timestamp ? 0 : rent[tokenId].expires;
1700     }
1701 
1702     function putForRent(uint256 _tokenId, uint64 _expiry, uint64 _duration, uint256 _price, address _token) external rentability {
1703         _requireMinted(_tokenId);
1704         require(allowedTokens[_token], "GODS: Unrecognised token");
1705         require(_msgSender() == ownerOf(_tokenId), "GODS: Not Authorised");
1706         require(_price >= denominator, "GODS: Price too small");
1707         require(rent[_tokenId].user == address(0) || rent[_tokenId].expires < block.timestamp, "GODS: Currently Rented");
1708         rentableItems[_tokenId] = RentableItems({
1709             price: _price,
1710             lender: _msgSender(),
1711             expiry: _expiry,
1712             payToken: _token,
1713             duration: _duration
1714         });
1715         emit NFTListedForRent(_tokenId, _expiry, _duration, _price, _token);
1716     }
1717 
1718     function deleteFromRent(uint256 _tokenId) external {
1719         _requireMinted(_tokenId);
1720         require(_msgSender() == ownerOf(_tokenId), "GODS: Not Authorised");
1721         rentableItems[_tokenId].expiry = 0;
1722         emit NFTDeletedFromRent(_tokenId);
1723     }
1724 
1725     function acceptRent(uint256 _tokenId) external payable rentability nonReentrant {
1726         _requireMinted(_tokenId);
1727         require(_msgSender() != ownerOf(_tokenId), "GODS: Cannot rent own token");
1728         require(ownerOf(_tokenId) == rentableItems[_tokenId].lender, "GODS: Lender cannot rent");
1729         require(rentableItems[_tokenId].expiry >= block.timestamp, "GODS: Offer expired");
1730         rentableItems[_tokenId].expiry = 0;
1731         uint256 cost = rentableItems[_tokenId].price;
1732         if (godsFee > 0) {
1733             uint256 toOwner = cost * (denominator - godsFee) / denominator;
1734             uint256 toTreasury = cost - toOwner;
1735             if (rentableItems[_tokenId].payToken == address(0)) {
1736                 require(msg.value == rentableItems[_tokenId].price, "GODS: Incorrect amount payed");
1737                 (bool sent,) = ownerOf(_tokenId).call{value: address(this).balance}("");
1738                 require(sent, "Failed to send Ether");
1739             } else {
1740                 IERC20(rentableItems[_tokenId].payToken).safeTransferFrom(_msgSender(), ownerOf(_tokenId), toOwner);
1741                 if (toTreasury > 0) {
1742                     IERC20(rentableItems[_tokenId].payToken).safeTransferFrom(_msgSender(), treasury, toTreasury);
1743                 }
1744             }
1745         } else {
1746             if (rentableItems[_tokenId].payToken == address(0)) {
1747                 (bool sent,) = ownerOf(_tokenId).call{value: address(this).balance}("");
1748                 require(sent, "Failed to send Ether");
1749             } else {
1750                 IERC20(rentableItems[_tokenId].payToken).safeTransferFrom(_msgSender(), ownerOf(_tokenId), cost);
1751             }
1752         }
1753         _setUser(_tokenId, _msgSender(), uint64(block.timestamp + rentableItems[_tokenId].duration));
1754     }
1755 
1756     function placeBid(uint256 _tokenId, uint64 _expiry, uint64 _duration, uint256 _price, address _token) external rentability {
1757         _requireMinted(_tokenId);
1758         require(allowedTokens[_token] && _token != address(0), "GODS: Unrecognised token");
1759         require(_expiry >= block.timestamp, "GODS: Invalid expiry");
1760         require(_price >= denominator, "GODS: Fee too small");
1761         rentBidsCounter ++;
1762         rentBids[rentBidsCounter] = RentBids({
1763             tokenId: _tokenId,
1764             price: _price,
1765             user: _msgSender(),
1766             expiry: _expiry,
1767             payToken: _token,
1768             duration: _duration
1769         });
1770         emit BidPlaced(rentBidsCounter, _tokenId, _expiry, _duration, _price, _token);
1771     }
1772 
1773     function deleteBid(uint256 bidId) external {
1774         require(_msgSender() == rentBids[bidId].user, "GODS: Not authorised");
1775         require(block.timestamp >= rentBids[bidId].expiry, "GODS: Bid expired");
1776         rentBids[bidId].expiry = 0;
1777         emit BidDeleted(bidId);
1778     }
1779 
1780     function acceptBid(uint256 bidId) external rentability nonReentrant {
1781         RentBids memory bid = rentBids[bidId];
1782         require(ownerOf(bid.tokenId) == _msgSender(), "GODS: Caller is not the owner");
1783         require(rent[bid.tokenId].user == address(0) || rent[bid.tokenId].expires < block.timestamp, "GODS: Currently Rented");
1784         require(bid.expiry >= block.timestamp, "GODS: Bid expired");
1785         rentBids[bidId].expiry = 0;
1786         uint256 cost = bid.price;
1787         if (godsFee > 0) {
1788             uint256 toOwner = cost * (denominator - godsFee) / denominator;
1789             uint256 toTreasury = cost - toOwner;
1790             IERC20(bid.payToken).safeTransferFrom(bid.user, ownerOf(bid.tokenId), toOwner);
1791             if (toTreasury > 0) {
1792                 IERC20(bid.payToken).safeTransferFrom(bid.user, treasury, toTreasury);
1793             }
1794         } else {
1795             IERC20(bid.payToken).safeTransferFrom(bid.user, ownerOf(bid.tokenId), cost);
1796         }
1797         setUser(bid.tokenId, bid.user, uint64(block.timestamp) + bid.duration);
1798     } 
1799     
1800     /// @dev onlyOwner
1801 
1802     function modifyAllowedTokens(address[] calldata tokenList, bool value) external onlyOwner {
1803         for (uint256 i; i < tokenList.length;) {
1804             allowedTokens[tokenList[i]] = value;
1805             unchecked {
1806                 ++i;
1807             }
1808         }
1809         assert(allowedTokens[WETH] == true);
1810     }
1811 
1812     function changeTreasuryAddress(address _newTreasury) external onlyOwner {
1813         treasury = _newTreasury;
1814     }
1815 
1816     function changeRentFee(uint256 _newFee) external onlyOwner {
1817         require(_newFee < denominator, "GODS: Fee too high");
1818         godsFee = _newFee;
1819     }
1820 
1821     function setRentStatus(bool status) external onlyOwner {
1822         canRent = status;
1823     }
1824 
1825     function setBaseURI(string memory _base) external onlyOwner {
1826         baseURI_ = _base;
1827     }
1828 
1829     function setBaseExtension(string memory _ext) external onlyOwner {
1830         baseExtension_ = _ext;
1831     }
1832 
1833     function withdrawFunds() external onlyOwner {
1834         (bool sent,) = owner().call{value: address(this).balance}("");
1835         require(sent, "Failed to send Ether");
1836     }
1837 
1838     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable) returns (bool) {
1839         return
1840             interfaceId == type(IERC4907).interfaceId ||
1841             super.supportsInterface(interfaceId);
1842     }
1843 
1844     /// @dev OperatorFilterRegistry
1845 
1846     function setApprovalForAll(address operator, bool approved) public override(IERC721, ERC721) onlyAllowedOperatorApproval(operator) {
1847         super.setApprovalForAll(operator, approved);
1848     }
1849 
1850     function approve(address operator, uint256 tokenId) public override(IERC721, ERC721) onlyAllowedOperatorApproval(operator) {
1851         super.approve(operator, tokenId);
1852     }
1853 
1854     function transferFrom(address from, address to, uint256 tokenId) public override(IERC721, ERC721) onlyAllowedOperator(from) {
1855         super.transferFrom(from, to, tokenId);
1856     }
1857 
1858     function safeTransferFrom(address from, address to, uint256 tokenId) public override(IERC721, ERC721) onlyAllowedOperator(from) {
1859         super.safeTransferFrom(from, to, tokenId);
1860     }
1861 
1862     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1863         public
1864         override(IERC721, ERC721)
1865         onlyAllowedOperator(from)
1866     {
1867         super.safeTransferFrom(from, to, tokenId, data);
1868     }
1869 
1870     function changeOperatorFilterRegistryAddress(address newRegistry) external onlyOwner {
1871         OperatorFilterer.OPERATOR_FILTER_REGISTRY = IOperatorFilterRegistry(newRegistry);
1872     }
1873 
1874     receive() external payable {
1875         revert("GODS: Unrecognised method");
1876     }
1877 
1878     fallback() external payable {
1879         revert("GODS: Unrecognised method");
1880     }
1881 }