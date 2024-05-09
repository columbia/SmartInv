1 /**
2  *Submitted for verification at BscScan.com on 2022-08-27
3 */
4 
5 //SPDX-License-Identifier: GPL-3.0
6 pragma solidity ^0.8.0;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes calldata) {
14         return msg.data;
15     }
16 }
17 abstract contract Ownable is Context {
18     address private _owner;
19 
20     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22     /**
23      * @dev Initializes the contract setting the deployer as the initial owner.
24      */
25     constructor() {
26         _transferOwnership(_msgSender());
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         _checkOwner();
34         _;
35     }
36 
37     /**
38      * @dev Returns the address of the current owner.
39      */
40     function owner() public view virtual returns (address) {
41         return _owner;
42     }
43 
44     /**
45      * @dev Throws if the sender is not the owner.
46      */
47     function _checkOwner() internal view virtual {
48         require(owner() == _msgSender(), "Ownable: caller is not the owner");
49     }
50 
51     /**
52      * @dev Leaves the contract without owner. It will not be possible to call
53      * `onlyOwner` functions anymore. Can only be called by the current owner.
54      *
55      * NOTE: Renouncing ownership will leave the contract without an owner,
56      * thereby removing any functionality that is only available to the owner.
57      */
58     function renounceOwnership() public virtual onlyOwner {
59         _transferOwnership(address(0));
60     }
61 
62     /**
63      * @dev Transfers ownership of the contract to a new account (`newOwner`).
64      * Can only be called by the current owner.
65      */
66     function transferOwnership(address newOwner) public virtual onlyOwner {
67         require(newOwner != address(0), "Ownable: new owner is the zero address");
68         _transferOwnership(newOwner);
69     }
70 
71     /**
72      * @dev Transfers ownership of the contract to a new account (`newOwner`).
73      * Internal function without access restriction.
74      */
75     function _transferOwnership(address newOwner) internal virtual {
76         address oldOwner = _owner;
77         _owner = newOwner;
78         emit OwnershipTransferred(oldOwner, newOwner);
79     }
80 }
81 library Counters {
82     struct Counter {
83         // This variable should never be directly accessed by users of the library: interactions must be restricted to
84         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
85         // this feature: see https://github.com/ethereum/solidity/issues/4637
86         uint256 _value; // default: 0
87     }
88 
89     function current(Counter storage counter) internal view returns (uint256) {
90         return counter._value;
91     }
92 
93     function increment(Counter storage counter) internal {
94         unchecked {
95             counter._value += 1;
96         }
97     }
98 
99     function decrement(Counter storage counter) internal {
100         uint256 value = counter._value;
101         require(value > 0, "Counter: decrement overflow");
102         unchecked {
103             counter._value = value - 1;
104         }
105     }
106 
107     function reset(Counter storage counter) internal {
108         counter._value = 0;
109     }
110 }
111 
112 library Address {
113     /**
114      * @dev Returns true if `account` is a contract.
115      *
116      * [IMPORTANT]
117      * ====
118      * It is unsafe to assume that an address for which this function returns
119      * false is an externally-owned account (EOA) and not a contract.
120      *
121      * Among others, `isContract` will return false for the following
122      * types of addresses:
123      *
124      *  - an externally-owned account
125      *  - a contract in construction
126      *  - an address where a contract will be created
127      *  - an address where a contract lived, but was destroyed
128      * ====
129      *
130      * [IMPORTANT]
131      * ====
132      * You shouldn't rely on `isContract` to protect against flash loan attacks!
133      *
134      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
135      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
136      * constructor.
137      * ====
138      */
139     function isContract(address account) internal view returns (bool) {
140         // This method relies on extcodesize/address.code.length, which returns 0
141         // for contracts in construction, since the code is only stored at the end
142         // of the constructor execution.
143 
144         return account.code.length > 0;
145     }
146 
147     /**
148      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
149      * `recipient`, forwarding all available gas and reverting on errors.
150      *
151      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
152      * of certain opcodes, possibly making contracts go over the 2300 gas limit
153      * imposed by `transfer`, making them unable to receive funds via
154      * `transfer`. {sendValue} removes this limitation.
155      *
156      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
157      *
158      * IMPORTANT: because control is transferred to `recipient`, care must be
159      * taken to not create reentrancy vulnerabilities. Consider using
160      * {ReentrancyGuard} or the
161      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
162      */
163     function sendValue(address payable recipient, uint256 amount) internal {
164         require(address(this).balance >= amount, "Address: insufficient balance");
165 
166         (bool success, ) = recipient.call{value: amount}("");
167         require(success, "Address: unable to send value, recipient may have reverted");
168     }
169 
170     /**
171      * @dev Performs a Solidity function call using a low level `call`. A
172      * plain `call` is an unsafe replacement for a function call: use this
173      * function instead.
174      *
175      * If `target` reverts with a revert reason, it is bubbled up by this
176      * function (like regular Solidity function calls).
177      *
178      * Returns the raw returned data. To convert to the expected return value,
179      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
180      *
181      * Requirements:
182      *
183      * - `target` must be a contract.
184      * - calling `target` with `data` must not revert.
185      *
186      * _Available since v3.1._
187      */
188     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
189         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
194      * `errorMessage` as a fallback revert reason when `target` reverts.
195      *
196      * _Available since v3.1._
197      */
198     function functionCall(
199         address target,
200         bytes memory data,
201         string memory errorMessage
202     ) internal returns (bytes memory) {
203         return functionCallWithValue(target, data, 0, errorMessage);
204     }
205 
206     /**
207      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
208      * but also transferring `value` wei to `target`.
209      *
210      * Requirements:
211      *
212      * - the calling contract must have an ETH balance of at least `value`.
213      * - the called Solidity function must be `payable`.
214      *
215      * _Available since v3.1._
216      */
217     function functionCallWithValue(
218         address target,
219         bytes memory data,
220         uint256 value
221     ) internal returns (bytes memory) {
222         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
223     }
224 
225     /**
226      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
227      * with `errorMessage` as a fallback revert reason when `target` reverts.
228      *
229      * _Available since v3.1._
230      */
231     function functionCallWithValue(
232         address target,
233         bytes memory data,
234         uint256 value,
235         string memory errorMessage
236     ) internal returns (bytes memory) {
237         require(address(this).balance >= value, "Address: insufficient balance for call");
238         (bool success, bytes memory returndata) = target.call{value: value}(data);
239         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
244      * but performing a static call.
245      *
246      * _Available since v3.3._
247      */
248     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
249         return functionStaticCall(target, data, "Address: low-level static call failed");
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
254      * but performing a static call.
255      *
256      * _Available since v3.3._
257      */
258     function functionStaticCall(
259         address target,
260         bytes memory data,
261         string memory errorMessage
262     ) internal view returns (bytes memory) {
263         (bool success, bytes memory returndata) = target.staticcall(data);
264         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
269      * but performing a delegate call.
270      *
271      * _Available since v3.4._
272      */
273     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
274         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
279      * but performing a delegate call.
280      *
281      * _Available since v3.4._
282      */
283     function functionDelegateCall(
284         address target,
285         bytes memory data,
286         string memory errorMessage
287     ) internal returns (bytes memory) {
288         (bool success, bytes memory returndata) = target.delegatecall(data);
289         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
290     }
291 
292     /**
293      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
294      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
295      *
296      * _Available since v4.8._
297      */
298     function verifyCallResultFromTarget(
299         address target,
300         bool success,
301         bytes memory returndata,
302         string memory errorMessage
303     ) internal view returns (bytes memory) {
304         if (success) {
305             if (returndata.length == 0) {
306                 // only check isContract if the call was successful and the return data is empty
307                 // otherwise we already know that it was a contract
308                 require(isContract(target), "Address: call to non-contract");
309             }
310             return returndata;
311         } else {
312             _revert(returndata, errorMessage);
313         }
314     }
315 
316     /**
317      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
318      * revert reason or using the provided one.
319      *
320      * _Available since v4.3._
321      */
322     function verifyCallResult(
323         bool success,
324         bytes memory returndata,
325         string memory errorMessage
326     ) internal pure returns (bytes memory) {
327         if (success) {
328             return returndata;
329         } else {
330             _revert(returndata, errorMessage);
331         }
332     }
333 
334     function _revert(bytes memory returndata, string memory errorMessage) private pure {
335         // Look for revert reason and bubble it up if present
336         if (returndata.length > 0) {
337             // The easiest way to bubble the revert reason is using memory via assembly
338             /// @solidity memory-safe-assembly
339             assembly {
340                 let returndata_size := mload(returndata)
341                 revert(add(32, returndata), returndata_size)
342             }
343         } else {
344             revert(errorMessage);
345         }
346     }
347 }
348 
349 library Strings {
350     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
351     uint8 private constant _ADDRESS_LENGTH = 20;
352 
353     /**
354      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
355      */
356     function toString(uint256 value) internal pure returns (string memory) {
357         // Inspired by OraclizeAPI's implementation - MIT licence
358         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
359 
360         if (value == 0) {
361             return "0";
362         }
363         uint256 temp = value;
364         uint256 digits;
365         while (temp != 0) {
366             digits++;
367             temp /= 10;
368         }
369         bytes memory buffer = new bytes(digits);
370         while (value != 0) {
371             digits -= 1;
372             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
373             value /= 10;
374         }
375         return string(buffer);
376     }
377 
378     /**
379      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
380      */
381     function toHexString(uint256 value) internal pure returns (string memory) {
382         if (value == 0) {
383             return "0x00";
384         }
385         uint256 temp = value;
386         uint256 length = 0;
387         while (temp != 0) {
388             length++;
389             temp >>= 8;
390         }
391         return toHexString(value, length);
392     }
393 
394     /**
395      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
396      */
397     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
398         bytes memory buffer = new bytes(2 * length + 2);
399         buffer[0] = "0";
400         buffer[1] = "x";
401         for (uint256 i = 2 * length + 1; i > 1; --i) {
402             buffer[i] = _HEX_SYMBOLS[value & 0xf];
403             value >>= 4;
404         }
405         require(value == 0, "Strings: hex length insufficient");
406         return string(buffer);
407     }
408 
409     /**
410      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
411      */
412     function toHexString(address addr) internal pure returns (string memory) {
413         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
414     }
415 }
416 interface IERC721Receiver {
417     /**
418      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
419      * by `operator` from `from`, this function is called.
420      *
421      * It must return its Solidity selector to confirm the token transfer.
422      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
423      *
424      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
425      */
426     function onERC721Received(
427         address operator,
428         address from,
429         uint256 tokenId,
430         bytes calldata data
431     ) external returns (bytes4);
432 }
433 
434 interface IERC165 {
435     /**
436      * @dev Returns true if this contract implements the interface defined by
437      * `interfaceId`. See the corresponding
438      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
439      * to learn more about how these ids are created.
440      *
441      * This function call must use less than 30 000 gas.
442      */
443     function supportsInterface(bytes4 interfaceId) external view returns (bool);
444 }
445 
446 interface IERC721 is IERC165 {
447     /**
448      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
449      */
450     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
451 
452     /**
453      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
454      */
455     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
456 
457     /**
458      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
459      */
460     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
461 
462     /**
463      * @dev Returns the number of tokens in ``owner``'s account.
464      */
465     function balanceOf(address owner) external view returns (uint256 balance);
466 
467     /**
468      * @dev Returns the owner of the `tokenId` token.
469      *
470      * Requirements:
471      *
472      * - `tokenId` must exist.
473      */
474     function ownerOf(uint256 tokenId) external view returns (address owner);
475 
476     /**
477      * @dev Safely transfers `tokenId` token from `from` to `to`.
478      *
479      * Requirements:
480      *
481      * - `from` cannot be the zero address.
482      * - `to` cannot be the zero address.
483      * - `tokenId` token must exist and be owned by `from`.
484      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
485      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
486      *
487      * Emits a {Transfer} event.
488      */
489     function safeTransferFrom(
490         address from,
491         address to,
492         uint256 tokenId,
493         bytes calldata data
494     ) external;
495 
496     /**
497      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
498      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
499      *
500      * Requirements:
501      *
502      * - `from` cannot be the zero address.
503      * - `to` cannot be the zero address.
504      * - `tokenId` token must exist and be owned by `from`.
505      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
506      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
507      *
508      * Emits a {Transfer} event.
509      */
510     function safeTransferFrom(
511         address from,
512         address to,
513         uint256 tokenId
514     ) external;
515 
516     /**
517      * @dev Transfers `tokenId` token from `from` to `to`.
518      *
519      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
520      *
521      * Requirements:
522      *
523      * - `from` cannot be the zero address.
524      * - `to` cannot be the zero address.
525      * - `tokenId` token must be owned by `from`.
526      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
527      *
528      * Emits a {Transfer} event.
529      */
530     function transferFrom(
531         address from,
532         address to,
533         uint256 tokenId
534     ) external;
535 
536     /**
537      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
538      * The approval is cleared when the token is transferred.
539      *
540      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
541      *
542      * Requirements:
543      *
544      * - The caller must own the token or be an approved operator.
545      * - `tokenId` must exist.
546      *
547      * Emits an {Approval} event.
548      */
549     function approve(address to, uint256 tokenId) external;
550 
551     /**
552      * @dev Approve or remove `operator` as an operator for the caller.
553      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
554      *
555      * Requirements:
556      *
557      * - The `operator` cannot be the caller.
558      *
559      * Emits an {ApprovalForAll} event.
560      */
561     function setApprovalForAll(address operator, bool _approved) external;
562 
563     /**
564      * @dev Returns the account approved for `tokenId` token.
565      *
566      * Requirements:
567      *
568      * - `tokenId` must exist.
569      */
570     function getApproved(uint256 tokenId) external view returns (address operator);
571 
572     /**
573      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
574      *
575      * See {setApprovalForAll}
576      */
577     function isApprovedForAll(address owner, address operator) external view returns (bool);
578 }
579 
580 abstract contract ERC165 is IERC165 {
581     /**
582      * @dev See {IERC165-supportsInterface}.
583      */
584     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
585         return interfaceId == type(IERC165).interfaceId;
586     }
587 }
588 
589 interface IERC721Metadata is IERC721 {
590     /**
591      * @dev Returns the token collection name.
592      */
593     function name() external view returns (string memory);
594 
595     /**
596      * @dev Returns the token collection symbol.
597      */
598     function symbol() external view returns (string memory);
599 
600     /**
601      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
602      */
603     function tokenURI(uint256 tokenId) external view returns (string memory);
604 }
605 
606 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
607     using Address for address;
608     using Strings for uint256;
609 
610     // Token name
611     string private _name;
612 
613     // Token symbol
614     string private _symbol;
615 
616     // Mapping from token ID to owner address
617     mapping(uint256 => address) private _owners;
618 
619     // Mapping owner address to token count
620     mapping(address => uint256) private _balances;
621 
622     // Mapping from token ID to approved address
623     mapping(uint256 => address) private _tokenApprovals;
624 
625     // Mapping from owner to operator approvals
626     mapping(address => mapping(address => bool)) private _operatorApprovals;
627 
628     /**
629      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
630      */
631     constructor(string memory name_, string memory symbol_) {
632         _name = name_;
633         _symbol = symbol_;
634     }
635 
636     /**
637      * @dev See {IERC165-supportsInterface}.
638      */
639     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
640         return
641             interfaceId == type(IERC721).interfaceId ||
642             interfaceId == type(IERC721Metadata).interfaceId ||
643             super.supportsInterface(interfaceId);
644     }
645 
646     /**
647      * @dev See {IERC721-balanceOf}.
648      */
649     function balanceOf(address owner) public view virtual override returns (uint256) {
650         require(owner != address(0), "ERC721: address zero is not a valid owner");
651         return _balances[owner];
652     }
653 
654     /**
655      * @dev See {IERC721-ownerOf}.
656      */
657     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
658         address owner = _owners[tokenId];
659         require(owner != address(0), "ERC721: invalid token ID");
660         return owner;
661     }
662 
663     /**
664      * @dev See {IERC721Metadata-name}.
665      */
666     function name() public view virtual override returns (string memory) {
667         return _name;
668     }
669 
670     /**
671      * @dev See {IERC721Metadata-symbol}.
672      */
673     function symbol() public view virtual override returns (string memory) {
674         return _symbol;
675     }
676 
677     /**
678      * @dev See {IERC721Metadata-tokenURI}.
679      */
680     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
681         _requireMinted(tokenId);
682 
683         string memory baseURI = _baseURI();
684         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
685     }
686 
687     /**
688      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
689      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
690      * by default, can be overridden in child contracts.
691      */
692     function _baseURI() internal view virtual returns (string memory) {
693         return "";
694     }
695 
696     /**
697      * @dev See {IERC721-approve}.
698      */
699     function approve(address to, uint256 tokenId) public virtual override {
700         address owner = ERC721.ownerOf(tokenId);
701         require(to != owner, "ERC721: approval to current owner");
702 
703         require(
704             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
705             "ERC721: approve caller is not token owner nor approved for all"
706         );
707 
708         _approve(to, tokenId);
709     }
710 
711     /**
712      * @dev See {IERC721-getApproved}.
713      */
714     function getApproved(uint256 tokenId) public view virtual override returns (address) {
715         _requireMinted(tokenId);
716 
717         return _tokenApprovals[tokenId];
718     }
719 
720     /**
721      * @dev See {IERC721-setApprovalForAll}.
722      */
723     function setApprovalForAll(address operator, bool approved) public virtual override {
724         _setApprovalForAll(_msgSender(), operator, approved);
725     }
726 
727     /**
728      * @dev See {IERC721-isApprovedForAll}.
729      */
730     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
731         return _operatorApprovals[owner][operator];
732     }
733 
734     /**
735      * @dev See {IERC721-transferFrom}.
736      */
737     function transferFrom(
738         address from,
739         address to,
740         uint256 tokenId
741     ) public virtual override {
742         //solhint-disable-next-line max-line-length
743         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
744 
745         _transfer(from, to, tokenId);
746     }
747 
748     /**
749      * @dev See {IERC721-safeTransferFrom}.
750      */
751     function safeTransferFrom(
752         address from,
753         address to,
754         uint256 tokenId
755     ) public virtual override {
756         safeTransferFrom(from, to, tokenId, "");
757     }
758 
759     /**
760      * @dev See {IERC721-safeTransferFrom}.
761      */
762     function safeTransferFrom(
763         address from,
764         address to,
765         uint256 tokenId,
766         bytes memory data
767     ) public virtual override {
768         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
769         _safeTransfer(from, to, tokenId, data);
770     }
771 
772     /**
773      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
774      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
775      *
776      * `data` is additional data, it has no specified format and it is sent in call to `to`.
777      *
778      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
779      * implement alternative mechanisms to perform token transfer, such as signature-based.
780      *
781      * Requirements:
782      *
783      * - `from` cannot be the zero address.
784      * - `to` cannot be the zero address.
785      * - `tokenId` token must exist and be owned by `from`.
786      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
787      *
788      * Emits a {Transfer} event.
789      */
790     function _safeTransfer(
791         address from,
792         address to,
793         uint256 tokenId,
794         bytes memory data
795     ) internal virtual {
796         _transfer(from, to, tokenId);
797         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
798     }
799 
800     /**
801      * @dev Returns whether `tokenId` exists.
802      *
803      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
804      *
805      * Tokens start existing when they are minted (`_mint`),
806      * and stop existing when they are burned (`_burn`).
807      */
808     function _exists(uint256 tokenId) internal view virtual returns (bool) {
809         return _owners[tokenId] != address(0);
810     }
811 
812     /**
813      * @dev Returns whether `spender` is allowed to manage `tokenId`.
814      *
815      * Requirements:
816      *
817      * - `tokenId` must exist.
818      */
819     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
820         address owner = ERC721.ownerOf(tokenId);
821         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
822     }
823 
824     /**
825      * @dev Safely mints `tokenId` and transfers it to `to`.
826      *
827      * Requirements:
828      *
829      * - `tokenId` must not exist.
830      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
831      *
832      * Emits a {Transfer} event.
833      */
834     function _safeMint(address to, uint256 tokenId) internal virtual {
835         _safeMint(to, tokenId, "");
836     }
837 
838     /**
839      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
840      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
841      */
842     function _safeMint(
843         address to,
844         uint256 tokenId,
845         bytes memory data
846     ) internal virtual {
847         _mint(to, tokenId);
848         require(
849             _checkOnERC721Received(address(0), to, tokenId, data),
850             "ERC721: transfer to non ERC721Receiver implementer"
851         );
852     }
853 
854     /**
855      * @dev Mints `tokenId` and transfers it to `to`.
856      *
857      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
858      *
859      * Requirements:
860      *
861      * - `tokenId` must not exist.
862      * - `to` cannot be the zero address.
863      *
864      * Emits a {Transfer} event.
865      */
866     function _mint(address to, uint256 tokenId) internal virtual {
867         require(to != address(0), "ERC721: mint to the zero address");
868         require(!_exists(tokenId), "ERC721: token already minted");
869 
870         _beforeTokenTransfer(address(0), to, tokenId);
871 
872         _balances[to] += 1;
873         _owners[tokenId] = to;
874 
875         emit Transfer(address(0), to, tokenId);
876 
877         _afterTokenTransfer(address(0), to, tokenId);
878     }
879 
880     /**
881      * @dev Destroys `tokenId`.
882      * The approval is cleared when the token is burned.
883      *
884      * Requirements:
885      *
886      * - `tokenId` must exist.
887      *
888      * Emits a {Transfer} event.
889      */
890     function _burn(uint256 tokenId) internal virtual {
891         address owner = ERC721.ownerOf(tokenId);
892 
893         _beforeTokenTransfer(owner, address(0), tokenId);
894 
895         // Clear approvals
896         _approve(address(0), tokenId);
897 
898         _balances[owner] -= 1;
899         delete _owners[tokenId];
900 
901         emit Transfer(owner, address(0), tokenId);
902 
903         _afterTokenTransfer(owner, address(0), tokenId);
904     }
905 
906     /**
907      * @dev Transfers `tokenId` from `from` to `to`.
908      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
909      *
910      * Requirements:
911      *
912      * - `to` cannot be the zero address.
913      * - `tokenId` token must be owned by `from`.
914      *
915      * Emits a {Transfer} event.
916      */
917     function _transfer(
918         address from,
919         address to,
920         uint256 tokenId
921     ) internal virtual {
922         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
923         require(to != address(0), "ERC721: transfer to the zero address");
924 
925         _beforeTokenTransfer(from, to, tokenId);
926 
927         // Clear approvals from the previous owner
928         _approve(address(0), tokenId);
929 
930         _balances[from] -= 1;
931         _balances[to] += 1;
932         _owners[tokenId] = to;
933 
934         emit Transfer(from, to, tokenId);
935 
936         _afterTokenTransfer(from, to, tokenId);
937     }
938 
939     /**
940      * @dev Approve `to` to operate on `tokenId`
941      *
942      * Emits an {Approval} event.
943      */
944     function _approve(address to, uint256 tokenId) internal virtual {
945         _tokenApprovals[tokenId] = to;
946         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
947     }
948 
949     /**
950      * @dev Approve `operator` to operate on all of `owner` tokens
951      *
952      * Emits an {ApprovalForAll} event.
953      */
954     function _setApprovalForAll(
955         address owner,
956         address operator,
957         bool approved
958     ) internal virtual {
959         require(owner != operator, "ERC721: approve to caller");
960         _operatorApprovals[owner][operator] = approved;
961         emit ApprovalForAll(owner, operator, approved);
962     }
963 
964     /**
965      * @dev Reverts if the `tokenId` has not been minted yet.
966      */
967     function _requireMinted(uint256 tokenId) internal view virtual {
968         require(_exists(tokenId), "ERC721: invalid token ID");
969     }
970 
971     /**
972      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
973      * The call is not executed if the target address is not a contract.
974      *
975      * @param from address representing the previous owner of the given token ID
976      * @param to target address that will receive the tokens
977      * @param tokenId uint256 ID of the token to be transferred
978      * @param data bytes optional data to send along with the call
979      * @return bool whether the call correctly returned the expected magic value
980      */
981     function _checkOnERC721Received(
982         address from,
983         address to,
984         uint256 tokenId,
985         bytes memory data
986     ) private returns (bool) {
987         if (to.isContract()) {
988             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
989                 return retval == IERC721Receiver.onERC721Received.selector;
990             } catch (bytes memory reason) {
991                 if (reason.length == 0) {
992                     revert("ERC721: transfer to non ERC721Receiver implementer");
993                 } else {
994                     /// @solidity memory-safe-assembly
995                     assembly {
996                         revert(add(32, reason), mload(reason))
997                     }
998                 }
999             }
1000         } else {
1001             return true;
1002         }
1003     }
1004 
1005     /**
1006      * @dev Hook that is called before any token transfer. This includes minting
1007      * and burning.
1008      *
1009      * Calling conditions:
1010      *
1011      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1012      * transferred to `to`.
1013      * - When `from` is zero, `tokenId` will be minted for `to`.
1014      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1015      * - `from` and `to` are never both zero.
1016      *
1017      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1018      */
1019     function _beforeTokenTransfer(
1020         address from,
1021         address to,
1022         uint256 tokenId
1023     ) internal virtual {}
1024 
1025     /**
1026      * @dev Hook that is called after any transfer of tokens. This includes
1027      * minting and burning.
1028      *
1029      * Calling conditions:
1030      *
1031      * - when `from` and `to` are both non-zero.
1032      * - `from` and `to` are never both zero.
1033      *
1034      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1035      */
1036     function _afterTokenTransfer(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) internal virtual {}
1041 }
1042 interface IERC4907 {
1043     // Logged when the user of a token assigns a new user or updates expires
1044     /// @notice Emitted when the `user` of an NFT or the `expires` of the `user` is changed
1045     /// The zero address for user indicates that there is no user address
1046     event UpdateUser(uint256 indexed tokenId, address indexed user, uint64 expires);
1047 
1048     /// @notice set the user and expires of a NFT
1049     /// @dev The zero address indicates there is no user 
1050     /// Throws if `tokenId` is not valid NFT
1051     /// @param user  The new user of the NFT
1052     /// @param expires  UNIX timestamp, The new user could use the NFT before expires
1053     function setUser(uint256 tokenId, address user, uint64 expires) external ;
1054 
1055     /// @notice Get the user address of an NFT
1056     /// @dev The zero address indicates that there is no user or the user is expired
1057     /// @param tokenId The NFT to get the user address for
1058     /// @return The user address for this NFT
1059     function userOf(uint256 tokenId) external view returns(address);
1060 
1061     /// @notice Get the user expires of an NFT
1062     /// @dev The zero value indicates that there is no user 
1063     /// @param tokenId The NFT to get the user expires for
1064     /// @return The user expires for this NFT
1065     function userExpires(uint256 tokenId) external view returns(uint256);
1066 }
1067 
1068 contract ERC4907 is ERC721, IERC4907 {
1069     struct UserInfo 
1070     {
1071         address user;   // address of user role
1072         uint64 expires; // unix timestamp, user expires
1073     }
1074 
1075     mapping (uint256  => UserInfo) internal _users;
1076 
1077     constructor(string memory name_, string memory symbol_)
1078      ERC721(name_,symbol_)
1079      {         
1080      }
1081     
1082     /// @notice set the user and expires of a NFT
1083     /// @dev The zero address indicates there is no user 
1084     /// Throws if `tokenId` is not valid NFT
1085     /// @param user  The new user of the NFT
1086     /// @param expires  UNIX timestamp, The new user could use the NFT before expires
1087     function setUser(uint256 tokenId, address user, uint64 expires) public virtual override{
1088         require(_isApprovedOrOwner(msg.sender, tokenId),"ERC721: transfer caller is not owner nor approved");
1089         UserInfo storage info =  _users[tokenId];
1090         info.user = user;
1091         info.expires = expires;
1092         emit UpdateUser(tokenId,user,expires);
1093     }
1094 
1095     /// @notice Get the user address of an NFT
1096     /// @dev The zero address indicates that there is no user or the user is expired
1097     /// @param tokenId The NFT to get the user address for
1098     /// @return The user address for this NFT
1099     function userOf(uint256 tokenId)public view virtual override returns(address){
1100         if( uint256(_users[tokenId].expires) >=  block.timestamp){
1101             return  _users[tokenId].user; 
1102         }
1103         else{
1104             return address(0);
1105         }
1106     }
1107 
1108     /// @notice Get the user expires of an NFT
1109     /// @dev The zero value indicates that there is no user 
1110     /// @param tokenId The NFT to get the user expires for
1111     /// @return The user expires for this NFT
1112     function userExpires(uint256 tokenId) public view virtual override returns(uint256){
1113         return _users[tokenId].expires;
1114     }
1115 
1116     /// @dev See {IERC165-supportsInterface}.
1117     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1118         return interfaceId == type(IERC4907).interfaceId || super.supportsInterface(interfaceId);
1119     }
1120 
1121     function _beforeTokenTransfer(
1122         address from,
1123         address to,
1124         uint256 tokenId
1125     ) internal virtual override{
1126         super._beforeTokenTransfer(from, to, tokenId);
1127 
1128         if (from != to && _users[tokenId].user != address(0)) {
1129             delete _users[tokenId];
1130             emit UpdateUser(tokenId, address(0), 0);
1131         }
1132     }
1133 }
1134 
1135 interface IERC721Enumerable is IERC721 {
1136     /**
1137      * @dev Returns the total amount of tokens stored by the contract.
1138      */
1139     function totalSupply() external view returns (uint256);
1140 
1141     /**
1142      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1143      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1144      */
1145     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1146 
1147     /**
1148      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1149      * Use along with {totalSupply} to enumerate all tokens.
1150      */
1151     function tokenByIndex(uint256 index) external view returns (uint256);
1152 }
1153 
1154 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1155     // Mapping from owner to list of owned token IDs
1156     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1157 
1158     // Mapping from token ID to index of the owner tokens list
1159     mapping(uint256 => uint256) private _ownedTokensIndex;
1160 
1161     // Array with all token ids, used for enumeration
1162     uint256[] private _allTokens;
1163 
1164     // Mapping from token id to position in the allTokens array
1165     mapping(uint256 => uint256) private _allTokensIndex;
1166 
1167     /**
1168      * @dev See {IERC165-supportsInterface}.
1169      */
1170     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1171         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1172     }
1173 
1174     /**
1175      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1176      */
1177     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1178         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1179         return _ownedTokens[owner][index];
1180     }
1181 
1182     /**
1183      * @dev See {IERC721Enumerable-totalSupply}.
1184      */
1185     function totalSupply() public view virtual override returns (uint256) {
1186         return _allTokens.length;
1187     }
1188 
1189     /**
1190      * @dev See {IERC721Enumerable-tokenByIndex}.
1191      */
1192     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1193         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1194         return _allTokens[index];
1195     }
1196 
1197     /**
1198      * @dev Hook that is called before any token transfer. This includes minting
1199      * and burning.
1200      *
1201      * Calling conditions:
1202      *
1203      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1204      * transferred to `to`.
1205      * - When `from` is zero, `tokenId` will be minted for `to`.
1206      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1207      * - `from` cannot be the zero address.
1208      * - `to` cannot be the zero address.
1209      *
1210      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1211      */
1212     function _beforeTokenTransfer(
1213         address from,
1214         address to,
1215         uint256 tokenId
1216     ) internal virtual override {
1217         super._beforeTokenTransfer(from, to, tokenId);
1218 
1219         if (from == address(0)) {
1220             _addTokenToAllTokensEnumeration(tokenId);
1221         } else if (from != to) {
1222             _removeTokenFromOwnerEnumeration(from, tokenId);
1223         }
1224         if (to == address(0)) {
1225             _removeTokenFromAllTokensEnumeration(tokenId);
1226         } else if (to != from) {
1227             _addTokenToOwnerEnumeration(to, tokenId);
1228         }
1229     }
1230 
1231     /**
1232      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1233      * @param to address representing the new owner of the given token ID
1234      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1235      */
1236     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1237         uint256 length = ERC721.balanceOf(to);
1238         _ownedTokens[to][length] = tokenId;
1239         _ownedTokensIndex[tokenId] = length;
1240     }
1241 
1242     /**
1243      * @dev Private function to add a token to this extension's token tracking data structures.
1244      * @param tokenId uint256 ID of the token to be added to the tokens list
1245      */
1246     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1247         _allTokensIndex[tokenId] = _allTokens.length;
1248         _allTokens.push(tokenId);
1249     }
1250 
1251     /**
1252      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1253      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1254      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1255      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1256      * @param from address representing the previous owner of the given token ID
1257      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1258      */
1259     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1260         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1261         // then delete the last slot (swap and pop).
1262 
1263         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1264         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1265 
1266         // When the token to delete is the last token, the swap operation is unnecessary
1267         if (tokenIndex != lastTokenIndex) {
1268             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1269 
1270             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1271             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1272         }
1273 
1274         // This also deletes the contents at the last position of the array
1275         delete _ownedTokensIndex[tokenId];
1276         delete _ownedTokens[from][lastTokenIndex];
1277     }
1278 
1279     /**
1280      * @dev Private function to remove a token from this extension's token tracking data structures.
1281      * This has O(1) time complexity, but alters the order of the _allTokens array.
1282      * @param tokenId uint256 ID of the token to be removed from the tokens list
1283      */
1284     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1285         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1286         // then delete the last slot (swap and pop).
1287 
1288         uint256 lastTokenIndex = _allTokens.length - 1;
1289         uint256 tokenIndex = _allTokensIndex[tokenId];
1290 
1291         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1292         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1293         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1294         uint256 lastTokenId = _allTokens[lastTokenIndex];
1295 
1296         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1297         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1298 
1299         // This also deletes the contents at the last position of the array
1300         delete _allTokensIndex[tokenId];
1301         _allTokens.pop();
1302     }
1303 }
1304 
1305 contract AstroboyNFT is ERC4907, ERC721Enumerable, Ownable {
1306     using Strings for uint256;
1307     using Counters for Counters.Counter;
1308     bytes32 private constant MINTER_ROLE = keccak256("MINTER_ROLE");
1309     uint256 public immutable maxSupply;
1310     Counters.Counter private tokenIds;
1311     string private baseURI;
1312     
1313 
1314     constructor(uint256 _maxSupply) ERC4907("MC Astroboy NFT", "MCAstro") {
1315         maxSupply = _maxSupply;
1316     }
1317 
1318     function _beforeTokenTransfer(
1319         address from,
1320         address to,
1321         uint256 tokenId
1322     ) internal override(ERC4907, ERC721Enumerable) {
1323         super._beforeTokenTransfer(from, to, tokenId);
1324     }
1325 
1326     function supportsInterface(bytes4 interfaceId)
1327         public
1328         view
1329         override(ERC4907, ERC721Enumerable)
1330         returns (bool)
1331     {
1332         return super.supportsInterface(interfaceId);
1333     }
1334 
1335     function setBaseURI(string memory _baseUri) public onlyOwner {
1336         baseURI = _baseUri;
1337     }
1338 
1339     
1340 
1341     function createNFT(address to) public onlyOwner returns (uint256) {
1342         require(totalSupply() < maxSupply, "MCAstro: the limit has been reached");
1343         return _mintNFT(to);
1344     }
1345 
1346     function tokenURI(uint256 tokenId)
1347         public
1348         view
1349         virtual
1350         override
1351         returns (string memory)
1352     {
1353         require(_exists(tokenId), "MCAstro: URI query for nonexistent token");
1354         return
1355             string(
1356                 abi.encodePacked(baseURI, tokenId.toString(), ".json")
1357             );
1358     }
1359 
1360     function _mintNFT(address to) private returns (uint256) {
1361         tokenIds.increment();
1362         uint256 newItemId = tokenIds.current();
1363         _safeMint(to, newItemId);
1364         return newItemId;
1365     }
1366 }