1 // File: ElderGods.sol
2 
3 
4 pragma solidity 0.8.17;
5 
6 library Address {
7     /**
8      * @dev Returns true if `account` is a contract.
9      *
10      * [IMPORTANT]
11      * ====
12      * It is unsafe to assume that an address for which this function returns
13      * false is an externally-owned account (EOA) and not a contract.
14      *
15      * Among others, `isContract` will return false for the following
16      * types of addresses:
17      *
18      *  - an externally-owned account
19      *  - a contract in construction
20      *  - an address where a contract will be created
21      *  - an address where a contract lived, but was destroyed
22      * ====
23      *
24      * [IMPORTANT]
25      * ====
26      * You shouldn't rely on `isContract` to protect against flash loan attacks!
27      *
28      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
29      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
30      * constructor.
31      * ====
32      */
33     function isContract(address account) internal view returns (bool) {
34         // This method relies on extcodesize/address.code.length, which returns 0
35         // for contracts in construction, since the code is only stored at the end
36         // of the constructor execution.
37 
38         return account.code.length > 0;
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         (bool success, ) = recipient.call{value: amount}("");
61         require(success, "Address: unable to send value, recipient may have reverted");
62     }
63 
64     /**
65      * @dev Performs a Solidity function call using a low level `call`. A
66      * plain `call` is an unsafe replacement for a function call: use this
67      * function instead.
68      *
69      * If `target` reverts with a revert reason, it is bubbled up by this
70      * function (like regular Solidity function calls).
71      *
72      * Returns the raw returned data. To convert to the expected return value,
73      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
74      *
75      * Requirements:
76      *
77      * - `target` must be a contract.
78      * - calling `target` with `data` must not revert.
79      *
80      * _Available since v3.1._
81      */
82     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
83         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
84     }
85 
86     /**
87      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
88      * `errorMessage` as a fallback revert reason when `target` reverts.
89      *
90      * _Available since v3.1._
91      */
92     function functionCall(
93         address target,
94         bytes memory data,
95         string memory errorMessage
96     ) internal returns (bytes memory) {
97         return functionCallWithValue(target, data, 0, errorMessage);
98     }
99 
100     /**
101      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
102      * but also transferring `value` wei to `target`.
103      *
104      * Requirements:
105      *
106      * - the calling contract must have an ETH balance of at least `value`.
107      * - the called Solidity function must be `payable`.
108      *
109      * _Available since v3.1._
110      */
111     function functionCallWithValue(
112         address target,
113         bytes memory data,
114         uint256 value
115     ) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
117     }
118 
119     /**
120      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
121      * with `errorMessage` as a fallback revert reason when `target` reverts.
122      *
123      * _Available since v3.1._
124      */
125     function functionCallWithValue(
126         address target,
127         bytes memory data,
128         uint256 value,
129         string memory errorMessage
130     ) internal returns (bytes memory) {
131         require(address(this).balance >= value, "Address: insufficient balance for call");
132         (bool success, bytes memory returndata) = target.call{value: value}(data);
133         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
134     }
135 
136     /**
137      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
138      * but performing a static call.
139      *
140      * _Available since v3.3._
141      */
142     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
143         return functionStaticCall(target, data, "Address: low-level static call failed");
144     }
145 
146     /**
147      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
148      * but performing a static call.
149      *
150      * _Available since v3.3._
151      */
152     function functionStaticCall(
153         address target,
154         bytes memory data,
155         string memory errorMessage
156     ) internal view returns (bytes memory) {
157         (bool success, bytes memory returndata) = target.staticcall(data);
158         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
163      * but performing a delegate call.
164      *
165      * _Available since v3.4._
166      */
167     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
168         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
173      * but performing a delegate call.
174      *
175      * _Available since v3.4._
176      */
177     function functionDelegateCall(
178         address target,
179         bytes memory data,
180         string memory errorMessage
181     ) internal returns (bytes memory) {
182         (bool success, bytes memory returndata) = target.delegatecall(data);
183         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
184     }
185 
186     /**
187      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
188      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
189      *
190      * _Available since v4.8._
191      */
192     function verifyCallResultFromTarget(
193         address target,
194         bool success,
195         bytes memory returndata,
196         string memory errorMessage
197     ) internal view returns (bytes memory) {
198         if (success) {
199             if (returndata.length == 0) {
200                 // only check isContract if the call was successful and the return data is empty
201                 // otherwise we already know that it was a contract
202                 require(isContract(target), "Address: call to non-contract");
203             }
204             return returndata;
205         } else {
206             _revert(returndata, errorMessage);
207         }
208     }
209 
210     /**
211      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
212      * revert reason or using the provided one.
213      *
214      * _Available since v4.3._
215      */
216     function verifyCallResult(
217         bool success,
218         bytes memory returndata,
219         string memory errorMessage
220     ) internal pure returns (bytes memory) {
221         if (success) {
222             return returndata;
223         } else {
224             _revert(returndata, errorMessage);
225         }
226     }
227 
228     function _revert(bytes memory returndata, string memory errorMessage) private pure {
229         // Look for revert reason and bubble it up if present
230         if (returndata.length > 0) {
231             // The easiest way to bubble the revert reason is using memory via assembly
232             /// @solidity memory-safe-assembly
233             assembly {
234                 let returndata_size := mload(returndata)
235                 revert(add(32, returndata), returndata_size)
236             }
237         } else {
238             revert(errorMessage);
239         }
240     }
241 }
242 
243 abstract contract Context {
244     function _msgSender() internal view virtual returns (address) {
245         return msg.sender;
246     }
247 
248     function _msgData() internal view virtual returns (bytes calldata) {
249         return msg.data;
250     }
251 }
252 
253 library Strings {
254     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
255     uint8 private constant _ADDRESS_LENGTH = 20;
256 
257     /**
258      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
259      */
260     function toString(uint256 value) internal pure returns (string memory) {
261         // Inspired by OraclizeAPI's implementation - MIT licence
262         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
263 
264         if (value == 0) {
265             return "0";
266         }
267         uint256 temp = value;
268         uint256 digits;
269         while (temp != 0) {
270             digits++;
271             temp /= 10;
272         }
273         bytes memory buffer = new bytes(digits);
274         while (value != 0) {
275             digits -= 1;
276             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
277             value /= 10;
278         }
279         return string(buffer);
280     }
281 
282     /**
283      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
284      */
285     function toHexString(uint256 value) internal pure returns (string memory) {
286         if (value == 0) {
287             return "0x00";
288         }
289         uint256 temp = value;
290         uint256 length = 0;
291         while (temp != 0) {
292             length++;
293             temp >>= 8;
294         }
295         return toHexString(value, length);
296     }
297 
298     /**
299      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
300      */
301     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
302         bytes memory buffer = new bytes(2 * length + 2);
303         buffer[0] = "0";
304         buffer[1] = "x";
305         for (uint256 i = 2 * length + 1; i > 1; --i) {
306             buffer[i] = _HEX_SYMBOLS[value & 0xf];
307             value >>= 4;
308         }
309         require(value == 0, "Strings: hex length insufficient");
310         return string(buffer);
311     }
312 
313     /**
314      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
315      */
316     function toHexString(address addr) internal pure returns (string memory) {
317         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
318     }
319 }
320 
321 abstract contract Ownable is Context {
322     address private _owner;
323 
324     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
325 
326     /**
327      * @dev Initializes the contract setting the deployer as the initial owner.
328      */
329     constructor() {
330         _transferOwnership(_msgSender());
331     }
332 
333     /**
334      * @dev Throws if called by any account other than the owner.
335      */
336     modifier onlyOwner() {
337         _checkOwner();
338         _;
339     }
340 
341     /**
342      * @dev Returns the address of the current owner.
343      */
344     function owner() public view virtual returns (address) {
345         return _owner;
346     }
347 
348     /**
349      * @dev Throws if the sender is not the owner.
350      */
351     function _checkOwner() internal view virtual {
352         require(owner() == _msgSender(), "Ownable: caller is not the owner");
353     }
354 
355     /**
356      * @dev Leaves the contract without owner. It will not be possible to call
357      * `onlyOwner` functions anymore. Can only be called by the current owner.
358      *
359      * NOTE: Renouncing ownership will leave the contract without an owner,
360      * thereby removing any functionality that is only available to the owner.
361      */
362     function renounceOwnership() public virtual onlyOwner {
363         _transferOwnership(address(0));
364     }
365 
366     /**
367      * @dev Transfers ownership of the contract to a new account (`newOwner`).
368      * Can only be called by the current owner.
369      */
370     function transferOwnership(address newOwner) public virtual onlyOwner {
371         require(newOwner != address(0), "Ownable: new owner is the zero address");
372         _transferOwnership(newOwner);
373     }
374 
375     /**
376      * @dev Transfers ownership of the contract to a new account (`newOwner`).
377      * Internal function without access restriction.
378      */
379     function _transferOwnership(address newOwner) internal virtual {
380         address oldOwner = _owner;
381         _owner = newOwner;
382         emit OwnershipTransferred(oldOwner, newOwner);
383     }
384 }
385 
386 interface IERC165 {
387     /**
388      * @dev Returns true if this contract implements the interface defined by
389      * `interfaceId`. See the corresponding
390      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
391      * to learn more about how these ids are created.
392      *
393      * This function call must use less than 30 000 gas.
394      */
395     function supportsInterface(bytes4 interfaceId) external view returns (bool);
396 }
397 
398 abstract contract ERC165 is IERC165 {
399     /**
400      * @dev See {IERC165-supportsInterface}.
401      */
402     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
403         return interfaceId == type(IERC165).interfaceId;
404     }
405 }
406 
407 interface IERC721 is IERC165 {
408     /**
409      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
410      */
411     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
412 
413     /**
414      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
415      */
416     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
417 
418     /**
419      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
420      */
421     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
422 
423     /**
424      * @dev Returns the number of tokens in ``owner``'s account.
425      */
426     function balanceOf(address owner) external view returns (uint256 balance);
427 
428     /**
429      * @dev Returns the owner of the `tokenId` token.
430      *
431      * Requirements:
432      *
433      * - `tokenId` must exist.
434      */
435     function ownerOf(uint256 tokenId) external view returns (address owner);
436 
437     /**
438      * @dev Safely transfers `tokenId` token from `from` to `to`.
439      *
440      * Requirements:
441      *
442      * - `from` cannot be the zero address.
443      * - `to` cannot be the zero address.
444      * - `tokenId` token must exist and be owned by `from`.
445      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
446      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
447      *
448      * Emits a {Transfer} event.
449      */
450     function safeTransferFrom(
451         address from,
452         address to,
453         uint256 tokenId,
454         bytes calldata data
455     ) external;
456 
457     /**
458      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
459      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
460      *
461      * Requirements:
462      *
463      * - `from` cannot be the zero address.
464      * - `to` cannot be the zero address.
465      * - `tokenId` token must exist and be owned by `from`.
466      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
467      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
468      *
469      * Emits a {Transfer} event.
470      */
471     function safeTransferFrom(
472         address from,
473         address to,
474         uint256 tokenId
475     ) external;
476 
477     /**
478      * @dev Transfers `tokenId` token from `from` to `to`.
479      *
480      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
481      *
482      * Requirements:
483      *
484      * - `from` cannot be the zero address.
485      * - `to` cannot be the zero address.
486      * - `tokenId` token must be owned by `from`.
487      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
488      *
489      * Emits a {Transfer} event.
490      */
491     function transferFrom(
492         address from,
493         address to,
494         uint256 tokenId
495     ) external;
496 
497     /**
498      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
499      * The approval is cleared when the token is transferred.
500      *
501      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
502      *
503      * Requirements:
504      *
505      * - The caller must own the token or be an approved operator.
506      * - `tokenId` must exist.
507      *
508      * Emits an {Approval} event.
509      */
510     function approve(address to, uint256 tokenId) external;
511 
512     /**
513      * @dev Approve or remove `operator` as an operator for the caller.
514      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
515      *
516      * Requirements:
517      *
518      * - The `operator` cannot be the caller.
519      *
520      * Emits an {ApprovalForAll} event.
521      */
522     function setApprovalForAll(address operator, bool _approved) external;
523 
524     /**
525      * @dev Returns the account approved for `tokenId` token.
526      *
527      * Requirements:
528      *
529      * - `tokenId` must exist.
530      */
531     function getApproved(uint256 tokenId) external view returns (address operator);
532 
533     /**
534      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
535      *
536      * See {setApprovalForAll}
537      */
538     function isApprovedForAll(address owner, address operator) external view returns (bool);
539 }
540 
541 interface IERC721Receiver {
542     /**
543      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
544      * by `operator` from `from`, this function is called.
545      *
546      * It must return its Solidity selector to confirm the token transfer.
547      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
548      *
549      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
550      */
551     function onERC721Received(
552         address operator,
553         address from,
554         uint256 tokenId,
555         bytes calldata data
556     ) external returns (bytes4);
557 }
558 
559 interface IERC721Metadata is IERC721 {
560     /**
561      * @dev Returns the token collection name.
562      */
563     function name() external view returns (string memory);
564 
565     /**
566      * @dev Returns the token collection symbol.
567      */
568     function symbol() external view returns (string memory);
569 
570     /**
571      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
572      */
573     function tokenURI(uint256 tokenId) external view returns (string memory);
574 }
575 
576 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
577     using Address for address;
578     using Strings for uint256;
579 
580     // Token name
581     string private _name;
582 
583     // Token symbol
584     string private _symbol;
585 
586     // Mapping from token ID to owner address
587     mapping(uint256 => address) private _owners;
588 
589     // Mapping owner address to token count
590     mapping(address => uint256) private _balances;
591 
592     // Mapping from token ID to approved address
593     mapping(uint256 => address) private _tokenApprovals;
594 
595     // Mapping from owner to operator approvals
596     mapping(address => mapping(address => bool)) private _operatorApprovals;
597 
598     /**
599      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
600      */
601     constructor(string memory name_, string memory symbol_) {
602         _name = name_;
603         _symbol = symbol_;
604     }
605 
606     /**
607      * @dev See {IERC165-supportsInterface}.
608      */
609     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
610         return
611             interfaceId == type(IERC721).interfaceId ||
612             interfaceId == type(IERC721Metadata).interfaceId ||
613             super.supportsInterface(interfaceId);
614     }
615 
616     /**
617      * @dev See {IERC721-balanceOf}.
618      */
619     function balanceOf(address owner) public view virtual override returns (uint256) {
620         require(owner != address(0), "ERC721: address zero is not a valid owner");
621         return _balances[owner];
622     }
623 
624     /**
625      * @dev See {IERC721-ownerOf}.
626      */
627     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
628         address owner = _owners[tokenId];
629         require(owner != address(0), "ERC721: invalid token ID");
630         return owner;
631     }
632 
633     /**
634      * @dev See {IERC721Metadata-name}.
635      */
636     function name() public view virtual override returns (string memory) {
637         return _name;
638     }
639 
640     /**
641      * @dev See {IERC721Metadata-symbol}.
642      */
643     function symbol() public view virtual override returns (string memory) {
644         return _symbol;
645     }
646 
647     /**
648      * @dev See {IERC721Metadata-tokenURI}.
649      */
650     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
651         _requireMinted(tokenId);
652 
653         string memory baseURI = _baseURI();
654         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
655     }
656 
657     /**
658      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
659      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
660      * by default, can be overridden in child contracts.
661      */
662     function _baseURI() internal view virtual returns (string memory) {
663         return "";
664     }
665 
666     /**
667      * @dev See {IERC721-approve}.
668      */
669     function approve(address to, uint256 tokenId) public virtual override {
670         address owner = ERC721.ownerOf(tokenId);
671         require(to != owner, "ERC721: approval to current owner");
672 
673         require(
674             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
675             "ERC721: approve caller is not token owner or approved for all"
676         );
677 
678         _approve(to, tokenId);
679     }
680 
681     /**
682      * @dev See {IERC721-getApproved}.
683      */
684     function getApproved(uint256 tokenId) public view virtual override returns (address) {
685         _requireMinted(tokenId);
686 
687         return _tokenApprovals[tokenId];
688     }
689 
690     /**
691      * @dev See {IERC721-setApprovalForAll}.
692      */
693     function setApprovalForAll(address operator, bool approved) public virtual override {
694         _setApprovalForAll(_msgSender(), operator, approved);
695     }
696 
697     /**
698      * @dev See {IERC721-isApprovedForAll}.
699      */
700     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
701         return _operatorApprovals[owner][operator];
702     }
703 
704     /**
705      * @dev See {IERC721-transferFrom}.
706      */
707     function transferFrom(
708         address from,
709         address to,
710         uint256 tokenId
711     ) public virtual override {
712         //solhint-disable-next-line max-line-length
713         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
714 
715         _transfer(from, to, tokenId);
716     }
717 
718     /**
719      * @dev See {IERC721-safeTransferFrom}.
720      */
721     function safeTransferFrom(
722         address from,
723         address to,
724         uint256 tokenId
725     ) public virtual override {
726         safeTransferFrom(from, to, tokenId, "");
727     }
728 
729     /**
730      * @dev See {IERC721-safeTransferFrom}.
731      */
732     function safeTransferFrom(
733         address from,
734         address to,
735         uint256 tokenId,
736         bytes memory data
737     ) public virtual override {
738         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
739         _safeTransfer(from, to, tokenId, data);
740     }
741 
742     /**
743      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
744      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
745      *
746      * `data` is additional data, it has no specified format and it is sent in call to `to`.
747      *
748      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
749      * implement alternative mechanisms to perform token transfer, such as signature-based.
750      *
751      * Requirements:
752      *
753      * - `from` cannot be the zero address.
754      * - `to` cannot be the zero address.
755      * - `tokenId` token must exist and be owned by `from`.
756      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
757      *
758      * Emits a {Transfer} event.
759      */
760     function _safeTransfer(
761         address from,
762         address to,
763         uint256 tokenId,
764         bytes memory data
765     ) internal virtual {
766         _transfer(from, to, tokenId);
767         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
768     }
769 
770     /**
771      * @dev Returns whether `tokenId` exists.
772      *
773      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
774      *
775      * Tokens start existing when they are minted (`_mint`),
776      * and stop existing when they are burned (`_burn`).
777      */
778     function _exists(uint256 tokenId) internal view virtual returns (bool) {
779         return _owners[tokenId] != address(0);
780     }
781 
782     /**
783      * @dev Returns whether `spender` is allowed to manage `tokenId`.
784      *
785      * Requirements:
786      *
787      * - `tokenId` must exist.
788      */
789     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
790         address owner = ERC721.ownerOf(tokenId);
791         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
792     }
793 
794     /**
795      * @dev Safely mints `tokenId` and transfers it to `to`.
796      *
797      * Requirements:
798      *
799      * - `tokenId` must not exist.
800      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
801      *
802      * Emits a {Transfer} event.
803      */
804     function _safeMint(address to, uint256 tokenId) internal virtual {
805         _safeMint(to, tokenId, "");
806     }
807 
808     /**
809      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
810      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
811      */
812     function _safeMint(
813         address to,
814         uint256 tokenId,
815         bytes memory data
816     ) internal virtual {
817         _mint(to, tokenId);
818         require(
819             _checkOnERC721Received(address(0), to, tokenId, data),
820             "ERC721: transfer to non ERC721Receiver implementer"
821         );
822     }
823 
824     /**
825      * @dev Mints `tokenId` and transfers it to `to`.
826      *
827      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
828      *
829      * Requirements:
830      *
831      * - `tokenId` must not exist.
832      * - `to` cannot be the zero address.
833      *
834      * Emits a {Transfer} event.
835      */
836     function _mint(address to, uint256 tokenId) internal virtual {
837         require(to != address(0), "ERC721: mint to the zero address");
838         require(!_exists(tokenId), "ERC721: token already minted");
839 
840         _beforeTokenTransfer(address(0), to, tokenId);
841 
842         _balances[to] += 1;
843         _owners[tokenId] = to;
844 
845         emit Transfer(address(0), to, tokenId);
846 
847         _afterTokenTransfer(address(0), to, tokenId);
848     }
849 
850     /**
851      * @dev Destroys `tokenId`.
852      * The approval is cleared when the token is burned.
853      * This is an internal function that does not check if the sender is authorized to operate on the token.
854      *
855      * Requirements:
856      *
857      * - `tokenId` must exist.
858      *
859      * Emits a {Transfer} event.
860      */
861     function _burn(uint256 tokenId) internal virtual {
862         address owner = ERC721.ownerOf(tokenId);
863 
864         _beforeTokenTransfer(owner, address(0), tokenId);
865 
866         // Clear approvals
867         delete _tokenApprovals[tokenId];
868 
869         _balances[owner] -= 1;
870         delete _owners[tokenId];
871 
872         emit Transfer(owner, address(0), tokenId);
873 
874         _afterTokenTransfer(owner, address(0), tokenId);
875     }
876 
877     /**
878      * @dev Transfers `tokenId` from `from` to `to`.
879      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
880      *
881      * Requirements:
882      *
883      * - `to` cannot be the zero address.
884      * - `tokenId` token must be owned by `from`.
885      *
886      * Emits a {Transfer} event.
887      */
888     function _transfer(
889         address from,
890         address to,
891         uint256 tokenId
892     ) internal virtual {
893         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
894         require(to != address(0), "ERC721: transfer to the zero address");
895 
896         _beforeTokenTransfer(from, to, tokenId);
897 
898         // Clear approvals from the previous owner
899         delete _tokenApprovals[tokenId];
900 
901         _balances[from] -= 1;
902         _balances[to] += 1;
903         _owners[tokenId] = to;
904 
905         emit Transfer(from, to, tokenId);
906 
907         _afterTokenTransfer(from, to, tokenId);
908     }
909 
910     /**
911      * @dev Approve `to` to operate on `tokenId`
912      *
913      * Emits an {Approval} event.
914      */
915     function _approve(address to, uint256 tokenId) internal virtual {
916         _tokenApprovals[tokenId] = to;
917         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
918     }
919 
920     /**
921      * @dev Approve `operator` to operate on all of `owner` tokens
922      *
923      * Emits an {ApprovalForAll} event.
924      */
925     function _setApprovalForAll(
926         address owner,
927         address operator,
928         bool approved
929     ) internal virtual {
930         require(owner != operator, "ERC721: approve to caller");
931         _operatorApprovals[owner][operator] = approved;
932         emit ApprovalForAll(owner, operator, approved);
933     }
934 
935     /**
936      * @dev Reverts if the `tokenId` has not been minted yet.
937      */
938     function _requireMinted(uint256 tokenId) internal view virtual {
939         require(_exists(tokenId), "ERC721: invalid token ID");
940     }
941 
942     /**
943      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
944      * The call is not executed if the target address is not a contract.
945      *
946      * @param from address representing the previous owner of the given token ID
947      * @param to target address that will receive the tokens
948      * @param tokenId uint256 ID of the token to be transferred
949      * @param data bytes optional data to send along with the call
950      * @return bool whether the call correctly returned the expected magic value
951      */
952     function _checkOnERC721Received(
953         address from,
954         address to,
955         uint256 tokenId,
956         bytes memory data
957     ) private returns (bool) {
958         if (to.isContract()) {
959             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
960                 return retval == IERC721Receiver.onERC721Received.selector;
961             } catch (bytes memory reason) {
962                 if (reason.length == 0) {
963                     revert("ERC721: transfer to non ERC721Receiver implementer");
964                 } else {
965                     /// @solidity memory-safe-assembly
966                     assembly {
967                         revert(add(32, reason), mload(reason))
968                     }
969                 }
970             }
971         } else {
972             return true;
973         }
974     }
975 
976     /**
977      * @dev Hook that is called before any token transfer. This includes minting
978      * and burning.
979      *
980      * Calling conditions:
981      *
982      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
983      * transferred to `to`.
984      * - When `from` is zero, `tokenId` will be minted for `to`.
985      * - When `to` is zero, ``from``'s `tokenId` will be burned.
986      * - `from` and `to` are never both zero.
987      *
988      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
989      */
990     function _beforeTokenTransfer(
991         address from,
992         address to,
993         uint256 tokenId
994     ) internal virtual {}
995 
996     /**
997      * @dev Hook that is called after any transfer of tokens. This includes
998      * minting and burning.
999      *
1000      * Calling conditions:
1001      *
1002      * - when `from` and `to` are both non-zero.
1003      * - `from` and `to` are never both zero.
1004      *
1005      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1006      */
1007     function _afterTokenTransfer(
1008         address from,
1009         address to,
1010         uint256 tokenId
1011     ) internal virtual {}
1012 }
1013 
1014 interface IERC721Enumerable is IERC721 {
1015     /**
1016      * @dev Returns the total amount of tokens stored by the contract.
1017      */
1018     function totalSupply() external view returns (uint256);
1019 
1020     /**
1021      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1022      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1023      */
1024     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1025 
1026     /**
1027      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1028      * Use along with {totalSupply} to enumerate all tokens.
1029      */
1030     function tokenByIndex(uint256 index) external view returns (uint256);
1031 }
1032 
1033 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1034     // Mapping from owner to list of owned token IDs
1035     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1036 
1037     // Mapping from token ID to index of the owner tokens list
1038     mapping(uint256 => uint256) private _ownedTokensIndex;
1039 
1040     // Array with all token ids, used for enumeration
1041     uint256[] private _allTokens;
1042 
1043     // Mapping from token id to position in the allTokens array
1044     mapping(uint256 => uint256) private _allTokensIndex;
1045 
1046     /**
1047      * @dev See {IERC165-supportsInterface}.
1048      */
1049     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1050         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1051     }
1052 
1053     /**
1054      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1055      */
1056     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1057         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1058         return _ownedTokens[owner][index];
1059     }
1060 
1061     /**
1062      * @dev See {IERC721Enumerable-totalSupply}.
1063      */
1064     function totalSupply() public view virtual override returns (uint256) {
1065         return _allTokens.length;
1066     }
1067 
1068     /**
1069      * @dev See {IERC721Enumerable-tokenByIndex}.
1070      */
1071     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1072         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1073         return _allTokens[index];
1074     }
1075 
1076     /**
1077      * @dev Hook that is called before any token transfer. This includes minting
1078      * and burning.
1079      *
1080      * Calling conditions:
1081      *
1082      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1083      * transferred to `to`.
1084      * - When `from` is zero, `tokenId` will be minted for `to`.
1085      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1086      * - `from` cannot be the zero address.
1087      * - `to` cannot be the zero address.
1088      *
1089      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1090      */
1091     function _beforeTokenTransfer(
1092         address from,
1093         address to,
1094         uint256 tokenId
1095     ) internal virtual override {
1096         super._beforeTokenTransfer(from, to, tokenId);
1097 
1098         if (from == address(0)) {
1099             _addTokenToAllTokensEnumeration(tokenId);
1100         } else if (from != to) {
1101             _removeTokenFromOwnerEnumeration(from, tokenId);
1102         }
1103         if (to == address(0)) {
1104             _removeTokenFromAllTokensEnumeration(tokenId);
1105         } else if (to != from) {
1106             _addTokenToOwnerEnumeration(to, tokenId);
1107         }
1108     }
1109 
1110     /**
1111      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1112      * @param to address representing the new owner of the given token ID
1113      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1114      */
1115     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1116         uint256 length = ERC721.balanceOf(to);
1117         _ownedTokens[to][length] = tokenId;
1118         _ownedTokensIndex[tokenId] = length;
1119     }
1120 
1121     /**
1122      * @dev Private function to add a token to this extension's token tracking data structures.
1123      * @param tokenId uint256 ID of the token to be added to the tokens list
1124      */
1125     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1126         _allTokensIndex[tokenId] = _allTokens.length;
1127         _allTokens.push(tokenId);
1128     }
1129 
1130     /**
1131      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1132      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1133      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1134      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1135      * @param from address representing the previous owner of the given token ID
1136      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1137      */
1138     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1139         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1140         // then delete the last slot (swap and pop).
1141 
1142         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1143         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1144 
1145         // When the token to delete is the last token, the swap operation is unnecessary
1146         if (tokenIndex != lastTokenIndex) {
1147             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1148 
1149             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1150             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1151         }
1152 
1153         // This also deletes the contents at the last position of the array
1154         delete _ownedTokensIndex[tokenId];
1155         delete _ownedTokens[from][lastTokenIndex];
1156     }
1157 
1158     /**
1159      * @dev Private function to remove a token from this extension's token tracking data structures.
1160      * This has O(1) time complexity, but alters the order of the _allTokens array.
1161      * @param tokenId uint256 ID of the token to be removed from the tokens list
1162      */
1163     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1164         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1165         // then delete the last slot (swap and pop).
1166 
1167         uint256 lastTokenIndex = _allTokens.length - 1;
1168         uint256 tokenIndex = _allTokensIndex[tokenId];
1169 
1170         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1171         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1172         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1173         uint256 lastTokenId = _allTokens[lastTokenIndex];
1174 
1175         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1176         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1177 
1178         // This also deletes the contents at the last position of the array
1179         delete _allTokensIndex[tokenId];
1180         _allTokens.pop();
1181     }
1182 }
1183 
1184 interface IERC20 {
1185     /**
1186      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1187      * another (`to`).
1188      *
1189      * Note that `value` may be zero.
1190      */
1191     event Transfer(address indexed from, address indexed to, uint256 value);
1192 
1193     /**
1194      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1195      * a call to {approve}. `value` is the new allowance.
1196      */
1197     event Approval(address indexed owner, address indexed spender, uint256 value);
1198 
1199     /**
1200      * @dev Returns the amount of tokens in existence.
1201      */
1202     function totalSupply() external view returns (uint256);
1203 
1204     /**
1205      * @dev Returns the amount of tokens owned by `account`.
1206      */
1207     function balanceOf(address account) external view returns (uint256);
1208 
1209     /**
1210      * @dev Moves `amount` tokens from the caller's account to `to`.
1211      *
1212      * Returns a boolean value indicating whether the operation succeeded.
1213      *
1214      * Emits a {Transfer} event.
1215      */
1216     function transfer(address to, uint256 amount) external returns (bool);
1217 
1218     /**
1219      * @dev Returns the remaining number of tokens that `spender` will be
1220      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1221      * zero by default.
1222      *
1223      * This value changes when {approve} or {transferFrom} are called.
1224      */
1225     function allowance(address owner, address spender) external view returns (uint256);
1226 
1227     /**
1228      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1229      *
1230      * Returns a boolean value indicating whether the operation succeeded.
1231      *
1232      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1233      * that someone may use both the old and the new allowance by unfortunate
1234      * transaction ordering. One possible solution to mitigate this race
1235      * condition is to first reduce the spender's allowance to 0 and set the
1236      * desired value afterwards:
1237      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1238      *
1239      * Emits an {Approval} event.
1240      */
1241     function approve(address spender, uint256 amount) external returns (bool);
1242 
1243     /**
1244      * @dev Moves `amount` tokens from `from` to `to` using the
1245      * allowance mechanism. `amount` is then deducted from the caller's
1246      * allowance.
1247      *
1248      * Returns a boolean value indicating whether the operation succeeded.
1249      *
1250      * Emits a {Transfer} event.
1251      */
1252     function transferFrom(
1253         address from,
1254         address to,
1255         uint256 amount
1256     ) external returns (bool);
1257 }
1258 
1259 interface IERC20Permit {
1260     /**
1261      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1262      * given ``owner``'s signed approval.
1263      *
1264      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1265      * ordering also apply here.
1266      *
1267      * Emits an {Approval} event.
1268      *
1269      * Requirements:
1270      *
1271      * - `spender` cannot be the zero address.
1272      * - `deadline` must be a timestamp in the future.
1273      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1274      * over the EIP712-formatted function arguments.
1275      * - the signature must use ``owner``'s current nonce (see {nonces}).
1276      *
1277      * For more information on the signature format, see the
1278      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1279      * section].
1280      */
1281     function permit(
1282         address owner,
1283         address spender,
1284         uint256 value,
1285         uint256 deadline,
1286         uint8 v,
1287         bytes32 r,
1288         bytes32 s
1289     ) external;
1290 
1291     /**
1292      * @dev Returns the current nonce for `owner`. This value must be
1293      * included whenever a signature is generated for {permit}.
1294      *
1295      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1296      * prevents a signature from being used multiple times.
1297      */
1298     function nonces(address owner) external view returns (uint256);
1299 
1300     /**
1301      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1302      */
1303     // solhint-disable-next-line func-name-mixedcase
1304     function DOMAIN_SEPARATOR() external view returns (bytes32);
1305 }
1306 
1307 library SafeERC20 {
1308     using Address for address;
1309 
1310     function safeTransfer(
1311         IERC20 token,
1312         address to,
1313         uint256 value
1314     ) internal {
1315         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1316     }
1317 
1318     function safeTransferFrom(
1319         IERC20 token,
1320         address from,
1321         address to,
1322         uint256 value
1323     ) internal {
1324         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1325     }
1326 
1327     /**
1328      * @dev Deprecated. This function has issues similar to the ones found in
1329      * {IERC20-approve}, and its usage is discouraged.
1330      *
1331      * Whenever possible, use {safeIncreaseAllowance} and
1332      * {safeDecreaseAllowance} instead.
1333      */
1334     function safeApprove(
1335         IERC20 token,
1336         address spender,
1337         uint256 value
1338     ) internal {
1339         // safeApprove should only be called when setting an initial allowance,
1340         // or when resetting it to zero. To increase and decrease it, use
1341         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1342         require(
1343             (value == 0) || (token.allowance(address(this), spender) == 0),
1344             "SafeERC20: approve from non-zero to non-zero allowance"
1345         );
1346         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1347     }
1348 
1349     function safeIncreaseAllowance(
1350         IERC20 token,
1351         address spender,
1352         uint256 value
1353     ) internal {
1354         uint256 newAllowance = token.allowance(address(this), spender) + value;
1355         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1356     }
1357 
1358     function safeDecreaseAllowance(
1359         IERC20 token,
1360         address spender,
1361         uint256 value
1362     ) internal {
1363         unchecked {
1364             uint256 oldAllowance = token.allowance(address(this), spender);
1365             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1366             uint256 newAllowance = oldAllowance - value;
1367             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1368         }
1369     }
1370 
1371     function safePermit(
1372         IERC20Permit token,
1373         address owner,
1374         address spender,
1375         uint256 value,
1376         uint256 deadline,
1377         uint8 v,
1378         bytes32 r,
1379         bytes32 s
1380     ) internal {
1381         uint256 nonceBefore = token.nonces(owner);
1382         token.permit(owner, spender, value, deadline, v, r, s);
1383         uint256 nonceAfter = token.nonces(owner);
1384         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1385     }
1386 
1387     /**
1388      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1389      * on the return value: the return value is optional (but if data is returned, it must not be false).
1390      * @param token The token targeted by the call.
1391      * @param data The call data (encoded using abi.encode or one of its variants).
1392      */
1393     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1394         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1395         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1396         // the target address contains contract code and also asserts for success in the low-level call.
1397 
1398         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1399         if (returndata.length > 0) {
1400             // Return data is optional
1401             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1402         }
1403     }
1404 }
1405 
1406 abstract contract ReentrancyGuard {
1407     // Booleans are more expensive than uint256 or any type that takes up a full
1408     // word because each write operation emits an extra SLOAD to first read the
1409     // slot's contents, replace the bits taken up by the boolean, and then write
1410     // back. This is the compiler's defense against contract upgrades and
1411     // pointer aliasing, and it cannot be disabled.
1412 
1413     // The values being non-zero value makes deployment a bit more expensive,
1414     // but in exchange the refund on every call to nonReentrant will be lower in
1415     // amount. Since refunds are capped to a percentage of the total
1416     // transaction's gas, it is best to keep them low in cases like this one, to
1417     // increase the likelihood of the full refund coming into effect.
1418     uint256 private constant _NOT_ENTERED = 1;
1419     uint256 private constant _ENTERED = 2;
1420 
1421     uint256 private _status;
1422 
1423     constructor() {
1424         _status = _NOT_ENTERED;
1425     }
1426 
1427     /**
1428      * @dev Prevents a contract from calling itself, directly or indirectly.
1429      * Calling a `nonReentrant` function from another `nonReentrant`
1430      * function is not supported. It is possible to prevent this from happening
1431      * by making the `nonReentrant` function external, and making it call a
1432      * `private` function that does the actual work.
1433      */
1434     modifier nonReentrant() {
1435         _nonReentrantBefore();
1436         _;
1437         _nonReentrantAfter();
1438     }
1439 
1440     function _nonReentrantBefore() private {
1441         // On the first call to nonReentrant, _notEntered will be true
1442         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1443 
1444         // Any calls to nonReentrant after this point will fail
1445         _status = _ENTERED;
1446     }
1447 
1448     function _nonReentrantAfter() private {
1449         // By storing the original value once again, a refund is triggered (see
1450         // https://eips.ethereum.org/EIPS/eip-2200)
1451         _status = _NOT_ENTERED;
1452     }
1453 }
1454 
1455 interface IInfiniGods {
1456     function getTokenRarity(uint256 tokenId) external view returns (uint8);
1457 }
1458 
1459 interface IERC4907 {
1460 
1461     // Logged when the user of an NFT is changed or expires is changed
1462     /// @notice Emitted when the `user` of an NFT or the `expires` of the `user` is changed
1463     /// The zero address for user indicates that there is no user address
1464     event UpdateUser(uint256 indexed tokenId, address indexed user, uint64 expires);
1465 
1466     /// @notice set the user and expires of an NFT
1467     /// @dev The zero address indicates there is no user
1468     /// Throws if `tokenId` is not valid NFT
1469     /// @param user  The new user of the NFT
1470     /// @param expires  UNIX timestamp, The new user could use the NFT before expires
1471     function setUser(uint256 tokenId, address user, uint64 expires) external;
1472 
1473     /// @notice Get the user address of an NFT
1474     /// @dev The zero address indicates that there is no user or the user is expired
1475     /// @param tokenId The NFT to get the user address for
1476     /// @return The user address for this NFT
1477     function userOf(uint256 tokenId) external view returns(address);
1478 
1479     /// @notice Get the user expires of an NFT
1480     /// @dev The zero value indicates that there is no user
1481     /// @param tokenId The NFT to get the user expires for
1482     /// @return The user expires for this NFT
1483     function userExpires(uint256 tokenId) external view returns(uint256);
1484 }
1485 
1486 contract ElderGODS is ERC721Enumerable, Ownable, IERC4907, ReentrancyGuard {
1487     using Address for address payable;
1488     using Strings for uint256;
1489     using SafeERC20 for IERC20;
1490 
1491     mapping (uint256  => bool) public isSloth; 
1492 
1493     mapping (uint256 => uint256) public mintedAmount; // mapping of InfiniGods Token Id -> how many minted (max 2)
1494     mapping (uint256 => bool) public hasMinted;
1495 
1496     uint256 private constant MAX_SUPPLY = 4488;
1497     uint256 private constant MAX_MINT = 4228;
1498 
1499     address public immutable INFINIGODS;
1500 
1501     uint256 private slothAirdropTokenCount;
1502     uint256 private normalAirdropTokenCount;
1503 
1504     uint256 private constant sale_start_time = 1669914000; // Dec 1 @ 1200 EST
1505     uint256 private sale_end_time = 1670518800;   // Dec 8 @ 1200 EST
1506     bool public sale_active = true;
1507 
1508     string private notRevealedURI;
1509     bool public revealed;
1510     string private baseURI_;
1511     string private baseExtension_;
1512 
1513     address private treasury;
1514 
1515     constructor (string memory name_, string memory symbol_, address _ig) ERC721(name_, symbol_) {
1516         INFINIGODS = _ig;
1517         allowedTokens[WETH] = true;
1518     }
1519 
1520     function airdropSloth(uint256 gasLimit) external onlyOwner nonReentrant {
1521         address to;
1522 
1523         for (uint256 x = slothAirdropTokenCount + 1; x <= IERC721Enumerable(INFINIGODS).totalSupply() && gasleft() > gasLimit;) {
1524             if (IInfiniGods(INFINIGODS).getTokenRarity(x) == 1) {
1525                 slothAirdropTokenCount = x;
1526                 to = IERC721(INFINIGODS).ownerOf(x);
1527                 _safeMint(to, totalSupply() + 1);
1528                 isSloth[totalSupply()] = true;
1529             }
1530             unchecked {
1531                 ++x;
1532             }
1533         }
1534     }
1535 
1536     function airdropStandard(uint256 gasLimit) external onlyOwner nonReentrant {
1537         address to;
1538         for (uint256 x = normalAirdropTokenCount + 1; x <= IERC721Enumerable(INFINIGODS).totalSupply() && gasleft() > gasLimit;) {
1539             if (IInfiniGods(INFINIGODS).getTokenRarity(x) == 1) {
1540                 normalAirdropTokenCount = x;
1541                 to = IERC721(INFINIGODS).ownerOf(x);
1542                 for (uint256 i; i < 4;) {
1543                     _safeMint(to, totalSupply() + 1);
1544                     unchecked {
1545                         ++i;
1546                     }
1547                 }
1548             }
1549             unchecked {
1550                 ++ x;
1551             }
1552         }
1553     }
1554 
1555     function mint(uint256[] memory _tokenId, uint256 amount) external nonReentrant {
1556         require(totalSupply() + amount <= MAX_MINT && totalSupply() + amount <= MAX_SUPPLY, "GODS: Supply would be exceeded");
1557         require(block.timestamp >= sale_start_time, "GODS: Mint has not started");
1558         require(block.timestamp <= sale_end_time, "GODS: Mint has finished");
1559         require(sale_active, "GODS: Sale is paused");
1560         uint256 mintAbility;
1561         for (uint256 i; i < _tokenId.length;) {
1562             require(IERC721(INFINIGODS).ownerOf(_tokenId[i]) == _msgSender(), "GODS: Caller not owner of token");
1563             if (IInfiniGods(INFINIGODS).getTokenRarity(_tokenId[i]) == 0) {
1564                 if (!hasMinted[_tokenId[i]]) {
1565                     mintAbility += 1;
1566                 }
1567             }
1568             unchecked {
1569                 ++i;
1570             }
1571         }
1572         require(mintAbility >= amount, "GODS: Not enough mint ability");
1573         uint256 count = amount;
1574         while (count > 0) {
1575             for (uint256 y; y < _tokenId.length;) {
1576                 if (!hasMinted[_tokenId[y]]) {
1577                     count -= 1;
1578                     hasMinted[_tokenId[y]] = true;
1579                 }
1580                 unchecked {
1581                     ++y;
1582                 }
1583             }
1584         }
1585         for (uint256 z; z < amount; z ++) {
1586             _safeMint(_msgSender(), totalSupply() + 1);
1587         }
1588     }
1589 
1590     function returnToTreasury(uint256 gasLimit) external onlyOwner nonReentrant {
1591         require(block.timestamp >= sale_end_time, "GODS: Sale has not finished");
1592         require(treasury != address(0), "GODS: To address(0)");
1593         while (totalSupply() <= MAX_SUPPLY && gasleft() > gasLimit) {
1594             _safeMint(treasury, totalSupply() + 1);
1595         }
1596     }
1597 
1598     function changeSaleStatus(bool value) external onlyOwner {
1599         sale_active = value;
1600     }
1601 
1602     function changeEndTime(uint256 new_end_time) external onlyOwner {
1603         sale_end_time = new_end_time;
1604     }
1605 
1606     function reveal(bool value) external onlyOwner {
1607         revealed = value;
1608     }
1609 
1610     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1611         _requireMinted(tokenId);
1612         if (revealed) {
1613             return bytes(baseURI_).length > 0 ? string(abi.encodePacked(baseURI_, tokenId.toString(), baseExtension_)) : "";
1614         } else {
1615             return notRevealedURI;
1616         }
1617     }
1618 
1619     function getConfig() external view returns (uint256[2] memory) {
1620         return [sale_start_time, sale_end_time];
1621     }
1622 
1623     function getAvailable(uint256[] memory _tokenIds) external view returns (uint256[] memory) {
1624         uint256[] memory result = new uint256[](_tokenIds.length);
1625         for (uint i = 0; i < _tokenIds.length;) {
1626             if (IInfiniGods(INFINIGODS).getTokenRarity(_tokenIds[i]) == 0 && !hasMinted[_tokenIds[i]]) {
1627                 result[i] = 1;
1628             }
1629             unchecked {
1630                 ++i;
1631             }
1632         }
1633         return result;
1634     }
1635 
1636     function getUserTokens(address user) public view returns (uint256[] memory) {
1637         uint256 balance = IERC721(INFINIGODS).balanceOf(user);
1638         uint256[] memory result = new uint256[](balance);
1639 
1640         for (uint i = 0; i < balance;) {
1641             result[i] = IERC721Enumerable(INFINIGODS).tokenOfOwnerByIndex(user, i);
1642             unchecked {
1643                 ++i;
1644             }
1645         }
1646         return result;
1647     }
1648 
1649     /// @dev EIP4907
1650 
1651     uint256 public godsFee;
1652     uint256 private constant denominator = 1000;
1653     bool public canRent;
1654 
1655     address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
1656 
1657     mapping (address => bool) public allowedTokens;
1658 
1659     struct Rent {
1660         address user;
1661         uint64 expires;
1662     }
1663 
1664     mapping (uint256 => Rent) public rent;
1665 
1666     struct RentBids {
1667         uint256 tokenId;
1668         uint256 price;
1669         address user;
1670         uint256 expiry;
1671         address payToken;
1672         uint64 duration;
1673     }
1674 
1675     mapping (uint256 => RentBids) public rentBids;
1676     uint256 public rentBidsCounter;
1677 
1678     struct RentableItems {
1679         uint256 price;
1680         address lender;
1681         uint64 expiry;
1682         address payToken;
1683         uint64 duration;
1684     }
1685 
1686     mapping (uint256 => RentableItems) public rentableItems;
1687 
1688     event BidPlaced(uint256 indexed bidId, uint256 tokenId, uint64 expiry, uint64 duration, uint256 price, address token);
1689     event BidDeleted(uint256 bidId);
1690     event NFTListedForRent(uint256 tokenId, uint64 expiry, uint64 duration, uint256 price, address token);
1691     event NFTDeletedFromRent(uint256 tokenId);
1692 
1693     modifier rentability() {
1694         require(canRent, "GODS: Rent is currently disabled");
1695         _;
1696     }
1697 
1698     function setUser(uint256 tokenId, address user, uint64 expires) public override rentability {
1699         require(_msgSender() == ownerOf(tokenId), "GODS: Not owner");
1700         _setUser(tokenId, user, expires);
1701     }
1702 
1703     function _setUser(uint256 tokenId, address _user, uint64 _expires) internal {
1704         _requireMinted(tokenId);
1705         require(rent[tokenId].user == address(0) || rent[tokenId].expires < block.timestamp, "GODS: Currently Rented");
1706         rent[tokenId] = Rent({
1707             user: _user,
1708             expires: _expires
1709         });
1710         emit UpdateUser(tokenId, _user, _expires);
1711     }
1712 
1713     function userOf(uint256 tokenId) external view returns (address) {
1714         _requireMinted(tokenId);
1715         if (rent[tokenId].expires >= block.timestamp) {
1716             return rent[tokenId].user;
1717         } else {
1718             return ownerOf(tokenId);
1719         }
1720     }
1721 
1722     function userExpires(uint256 tokenId) external view returns(uint256) {
1723         _requireMinted(tokenId);
1724         return rent[tokenId].expires;
1725     }
1726 
1727     function putForRent(uint256 _tokenId, uint64 _expiry, uint64 _duration, uint256 _price, address _token) external rentability {
1728         _requireMinted(_tokenId);
1729         require(allowedTokens[_token], "GODS: Unrecognised token");
1730         require(_msgSender() == ownerOf(_tokenId), "GODS: Not Authorised");
1731         require(rent[_tokenId].user == address(0) || rent[_tokenId].expires < block.timestamp, "GODS: Currently Rented");
1732         rentableItems[_tokenId] = RentableItems({
1733             price: _price,
1734             lender: _msgSender(),
1735             expiry: _expiry,
1736             payToken: _token,
1737             duration: _duration
1738         });
1739         emit NFTListedForRent(_tokenId, _expiry, _duration, _price, _token);
1740     }
1741 
1742     function deleteFromRent(uint256 _tokenId) external {
1743         _requireMinted(_tokenId);
1744         require(_msgSender() == ownerOf(_tokenId), "GODS: Not Authorised");
1745         rentableItems[_tokenId].expiry = 0;
1746         emit NFTDeletedFromRent(_tokenId);
1747     }
1748 
1749     function acceptRent(uint256 _tokenId) external rentability nonReentrant {
1750         _requireMinted(_tokenId);
1751         require(_msgSender() != ownerOf(_tokenId), "GODS: Cannot rent own token");
1752         require(ownerOf(_tokenId) == rentableItems[_tokenId].lender, "GODS: Lender cannot rent");
1753         require(rentableItems[_tokenId].expiry >= block.timestamp, "GODS: Offer expired");
1754         rentableItems[_tokenId].expiry = 0;
1755         uint256 cost = rentableItems[_tokenId].price;
1756         if (godsFee > 0) {
1757             uint256 toOwner = cost * (denominator - godsFee) / denominator;
1758             uint256 toTreasury = cost * (godsFee) / denominator;
1759             IERC20(rentableItems[_tokenId].payToken).safeTransferFrom(_msgSender(), ownerOf(_tokenId), toOwner);
1760             if (toTreasury > 0) {
1761                 IERC20(rentableItems[_tokenId].payToken).safeTransferFrom(_msgSender(), treasury, toTreasury);
1762             }
1763         } else {
1764             IERC20(rentableItems[_tokenId].payToken).safeTransferFrom(_msgSender(), ownerOf(_tokenId), cost);
1765         }
1766         _setUser(_tokenId, _msgSender(), uint64(block.timestamp + rentableItems[_tokenId].duration));
1767     }
1768 
1769     function placeBid(uint256 _tokenId, uint64 _expiry, uint64 _duration, uint256 _price, address _token) external rentability {
1770         _requireMinted(_tokenId);
1771         require(allowedTokens[_token], "GODS: Unrecognised token");
1772         require(_expiry >= block.timestamp, "GODS: Invalid expiry");
1773         rentBidsCounter ++;
1774         rentBids[rentBidsCounter] = RentBids({
1775             tokenId: _tokenId,
1776             price: _price,
1777             user: _msgSender(),
1778             expiry: _expiry,
1779             payToken: _token,
1780             duration: _duration
1781         });
1782         emit BidPlaced(rentBidsCounter, _tokenId, _expiry, _duration, _price, _token);
1783     }
1784 
1785     function deleteBid(uint256 bidId) external {
1786         require(_msgSender() == rentBids[bidId].user, "GODS: Not authorised");
1787         require(block.timestamp >= rentBids[bidId].expiry, "GODS: Bid expired");
1788         rentBids[bidId].expiry = 0;
1789         emit BidDeleted(bidId);
1790     }
1791 
1792     function acceptBid(uint256 bidId) external rentability nonReentrant {
1793         RentBids memory bid = rentBids[bidId];
1794         require(ownerOf(bid.tokenId) == _msgSender(), "GODS: Caller is not the owner");
1795         require(rent[bid.tokenId].user == address(0) || rent[bid.tokenId].expires < block.timestamp, "GODS: Currently Rented");
1796         require(bid.expiry >= block.timestamp, "GODS: Bid expired");
1797         rentBids[bidId].expiry = 0;
1798         uint256 cost = bid.price;
1799         if (godsFee > 0) {
1800             uint256 toOwner = cost * (denominator - godsFee) / denominator;
1801             uint256 toTreasury = cost * (godsFee) / denominator;
1802             IERC20(bid.payToken).safeTransferFrom(bid.user, ownerOf(bid.tokenId), toOwner);
1803             if (toTreasury > 0) {
1804                 IERC20(bid.payToken).safeTransferFrom(bid.user, treasury, toTreasury);
1805             }
1806         } else {
1807             IERC20(bid.payToken).safeTransferFrom(bid.user, ownerOf(bid.tokenId), cost);
1808         }
1809         setUser(bid.tokenId, bid.user, uint64(block.timestamp) + bid.duration);
1810     } 
1811     
1812     /// @dev onlyOwner
1813 
1814     function modifyAllowedTokens(address[] calldata tokenList, bool value) external onlyOwner {
1815         for (uint256 i; i < tokenList.length;) {
1816             allowedTokens[tokenList[i]] = value;
1817             unchecked {
1818                 ++i;
1819             }
1820         }
1821         assert(allowedTokens[WETH] == true);
1822     }
1823 
1824     function changeTreasuryAddress(address _newTreasury) external onlyOwner {
1825         treasury = _newTreasury;
1826     }
1827 
1828     function changeRentFee(uint256 _newFee) external onlyOwner {
1829         require(_newFee < denominator, "GODS: Fee too high");
1830         godsFee = _newFee;
1831     }
1832 
1833     function setRentStatus(bool status) external onlyOwner {
1834         canRent = status;
1835     }
1836 
1837     function setBaseURI(string memory _base) external onlyOwner {
1838         baseURI_ = _base;
1839     }
1840 
1841     function setBaseExtension(string memory _ext) external onlyOwner {
1842         baseExtension_ = _ext;
1843     }
1844 
1845     function setNotRevealedURI(string memory _newURI) external onlyOwner {
1846         notRevealedURI = _newURI;
1847     }
1848 
1849     function withdrawFunds() external onlyOwner {
1850         payable(owner()).sendValue(address(this).balance);
1851     }
1852 
1853     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable) returns (bool) {
1854         return
1855             interfaceId == type(IERC4907).interfaceId ||
1856             super.supportsInterface(interfaceId);
1857     }
1858 }