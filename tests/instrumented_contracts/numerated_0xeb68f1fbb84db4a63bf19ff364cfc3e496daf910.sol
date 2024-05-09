1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 interface IERC165 {
6     /**
7      * @dev Returns true if this contract implements the interface defined by
8      * `interfaceId`. See the corresponding
9      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
10      * to learn more about how these ids are created.
11      *
12      * This function call must use less than 30 000 gas.
13      */
14     function supportsInterface(bytes4 interfaceId) external view returns (bool);
15 }
16 
17 interface IERC721 is IERC165 {
18     /**
19      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
20      */
21     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
22 
23     /**
24      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
25      */
26     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
27 
28     /**
29      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
30      */
31     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
32 
33     /**
34      * @dev Returns the number of tokens in ``owner``'s account.
35      */
36     function balanceOf(address owner) external view returns (uint256 balance);
37 
38     /**
39      * @dev Returns the owner of the `tokenId` token.
40      *
41      * Requirements:
42      *
43      * - `tokenId` must exist.
44      */
45     function ownerOf(uint256 tokenId) external view returns (address owner);
46 
47     /**
48      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
49      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
50      *
51      * Requirements:
52      *
53      * - `from` cannot be the zero address.
54      * - `to` cannot be the zero address.
55      * - `tokenId` token must exist and be owned by `from`.
56      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
57      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
58      *
59      * Emits a {Transfer} event.
60      */
61     function safeTransferFrom(
62         address from,
63         address to,
64         uint256 tokenId
65     ) external;
66 
67     /**
68      * @dev Transfers `tokenId` token from `from` to `to`.
69      *
70      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
71      *
72      * Requirements:
73      *
74      * - `from` cannot be the zero address.
75      * - `to` cannot be the zero address.
76      * - `tokenId` token must be owned by `from`.
77      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(
82         address from,
83         address to,
84         uint256 tokenId
85     ) external;
86 
87     /**
88      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
89      * The approval is cleared when the token is transferred.
90      *
91      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
92      *
93      * Requirements:
94      *
95      * - The caller must own the token or be an approved operator.
96      * - `tokenId` must exist.
97      *
98      * Emits an {Approval} event.
99      */
100     function approve(address to, uint256 tokenId) external;
101 
102     /**
103      * @dev Returns the account approved for `tokenId` token.
104      *
105      * Requirements:
106      *
107      * - `tokenId` must exist.
108      */
109     function getApproved(uint256 tokenId) external view returns (address operator);
110 
111     /**
112      * @dev Approve or remove `operator` as an operator for the caller.
113      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
114      *
115      * Requirements:
116      *
117      * - The `operator` cannot be the caller.
118      *
119      * Emits an {ApprovalForAll} event.
120      */
121     function setApprovalForAll(address operator, bool _approved) external;
122 
123     /**
124      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
125      *
126      * See {setApprovalForAll}
127      */
128     function isApprovedForAll(address owner, address operator) external view returns (bool);
129 
130     /**
131      * @dev Safely transfers `tokenId` token from `from` to `to`.
132      *
133      * Requirements:
134      *
135      * - `from` cannot be the zero address.
136      * - `to` cannot be the zero address.
137      * - `tokenId` token must exist and be owned by `from`.
138      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
139      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
140      *
141      * Emits a {Transfer} event.
142      */
143     function safeTransferFrom(
144         address from,
145         address to,
146         uint256 tokenId,
147         bytes calldata data
148     ) external;
149 }
150 
151 interface IERC721Receiver {
152     /**
153      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
154      * by `operator` from `from`, this function is called.
155      *
156      * It must return its Solidity selector to confirm the token transfer.
157      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
158      *
159      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
160      */
161     function onERC721Received(
162         address operator,
163         address from,
164         uint256 tokenId,
165         bytes calldata data
166     ) external returns (bytes4);
167 }
168 
169 interface IERC721Metadata is IERC721 {
170     /**
171      * @dev Returns the token collection name.
172      */
173     function name() external view returns (string memory);
174 
175     /**
176      * @dev Returns the token collection symbol.
177      */
178     function symbol() external view returns (string memory);
179 
180     /**
181      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
182      */
183     function tokenURI(uint256 tokenId) external view returns (string memory);
184 }
185 
186 interface IERC721Enumerable is IERC721 {
187     /**
188      * @dev Returns the total amount of tokens stored by the contract.
189      */
190     function totalSupply() external view returns (uint256);
191 
192     /**
193      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
194      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
195      */
196     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
197 
198     /**
199      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
200      * Use along with {totalSupply} to enumerate all tokens.
201      */
202     function tokenByIndex(uint256 index) external view returns (uint256);
203 }
204 
205 library Address {
206     /**
207      * @dev Returns true if `account` is a contract.
208      *
209      * [IMPORTANT]
210      * ====
211      * It is unsafe to assume that an address for which this function returns
212      * false is an externally-owned account (EOA) and not a contract.
213      *
214      * Among others, `isContract` will return false for the following
215      * types of addresses:
216      *
217      *  - an externally-owned account
218      *  - a contract in construction
219      *  - an address where a contract will be created
220      *  - an address where a contract lived, but was destroyed
221      * ====
222      */
223     function isContract(address account) internal view returns (bool) {
224         // This method relies on extcodesize, which returns 0 for contracts in
225         // construction, since the code is only stored at the end of the
226         // constructor execution.
227 
228         uint256 size;
229         assembly {
230             size := extcodesize(account)
231         }
232         return size > 0;
233     }
234 
235     /**
236      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
237      * `recipient`, forwarding all available gas and reverting on errors.
238      *
239      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
240      * of certain opcodes, possibly making contracts go over the 2300 gas limit
241      * imposed by `transfer`, making them unable to receive funds via
242      * `transfer`. {sendValue} removes this limitation.
243      *
244      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
245      *
246      * IMPORTANT: because control is transferred to `recipient`, care must be
247      * taken to not create reentrancy vulnerabilities. Consider using
248      * {ReentrancyGuard} or the
249      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
250      */
251     function sendValue(address payable recipient, uint256 amount) internal {
252         require(address(this).balance >= amount, "Address: insufficient balance");
253 
254         (bool success, ) = recipient.call{value: amount}("");
255         require(success, "Address: unable to send value, recipient may have reverted");
256     }
257 
258     /**
259      * @dev Performs a Solidity function call using a low level `call`. A
260      * plain `call` is an unsafe replacement for a function call: use this
261      * function instead.
262      *
263      * If `target` reverts with a revert reason, it is bubbled up by this
264      * function (like regular Solidity function calls).
265      *
266      * Returns the raw returned data. To convert to the expected return value,
267      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
268      *
269      * Requirements:
270      *
271      * - `target` must be a contract.
272      * - calling `target` with `data` must not revert.
273      *
274      * _Available since v3.1._
275      */
276     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
277         return functionCall(target, data, "Address: low-level call failed");
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
282      * `errorMessage` as a fallback revert reason when `target` reverts.
283      *
284      * _Available since v3.1._
285      */
286     function functionCall(
287         address target,
288         bytes memory data,
289         string memory errorMessage
290     ) internal returns (bytes memory) {
291         return functionCallWithValue(target, data, 0, errorMessage);
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
296      * but also transferring `value` wei to `target`.
297      *
298      * Requirements:
299      *
300      * - the calling contract must have an ETH balance of at least `value`.
301      * - the called Solidity function must be `payable`.
302      *
303      * _Available since v3.1._
304      */
305     function functionCallWithValue(
306         address target,
307         bytes memory data,
308         uint256 value
309     ) internal returns (bytes memory) {
310         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
315      * with `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCallWithValue(
320         address target,
321         bytes memory data,
322         uint256 value,
323         string memory errorMessage
324     ) internal returns (bytes memory) {
325         require(address(this).balance >= value, "Address: insufficient balance for call");
326         require(isContract(target), "Address: call to non-contract");
327 
328         (bool success, bytes memory returndata) = target.call{value: value}(data);
329         return verifyCallResult(success, returndata, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but performing a static call.
335      *
336      * _Available since v3.3._
337      */
338     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
339         return functionStaticCall(target, data, "Address: low-level static call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
344      * but performing a static call.
345      *
346      * _Available since v3.3._
347      */
348     function functionStaticCall(
349         address target,
350         bytes memory data,
351         string memory errorMessage
352     ) internal view returns (bytes memory) {
353         require(isContract(target), "Address: static call to non-contract");
354 
355         (bool success, bytes memory returndata) = target.staticcall(data);
356         return verifyCallResult(success, returndata, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but performing a delegate call.
362      *
363      * _Available since v3.4._
364      */
365     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
366         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
371      * but performing a delegate call.
372      *
373      * _Available since v3.4._
374      */
375     function functionDelegateCall(
376         address target,
377         bytes memory data,
378         string memory errorMessage
379     ) internal returns (bytes memory) {
380         require(isContract(target), "Address: delegate call to non-contract");
381 
382         (bool success, bytes memory returndata) = target.delegatecall(data);
383         return verifyCallResult(success, returndata, errorMessage);
384     }
385 
386     /**
387      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
388      * revert reason using the provided one.
389      *
390      * _Available since v4.3._
391      */
392     function verifyCallResult(
393         bool success,
394         bytes memory returndata,
395         string memory errorMessage
396     ) internal pure returns (bytes memory) {
397         if (success) {
398             return returndata;
399         } else {
400             // Look for revert reason and bubble it up if present
401             if (returndata.length > 0) {
402                 // The easiest way to bubble the revert reason is using memory via assembly
403 
404                 assembly {
405                     let returndata_size := mload(returndata)
406                     revert(add(32, returndata), returndata_size)
407                 }
408             } else {
409                 revert(errorMessage);
410             }
411         }
412     }
413 }
414 
415 abstract contract Context {
416     function _msgSender() internal view virtual returns (address) {
417         return msg.sender;
418     }
419 
420     function _msgData() internal view virtual returns (bytes calldata) {
421         return msg.data;
422     }
423 }
424 
425 abstract contract ReentrancyGuard {
426     // Booleans are more expensive than uint256 or any type that takes up a full
427     // word because each write operation emits an extra SLOAD to first read the
428     // slot's contents, replace the bits taken up by the boolean, and then write
429     // back. This is the compiler's defense against contract upgrades and
430     // pointer aliasing, and it cannot be disabled.
431 
432     // The values being non-zero value makes deployment a bit more expensive,
433     // but in exchange the refund on every call to nonReentrant will be lower in
434     // amount. Since refunds are capped to a percentage of the total
435     // transaction's gas, it is best to keep them low in cases like this one, to
436     // increase the likelihood of the full refund coming into effect.
437     uint256 private constant _NOT_ENTERED = 1;
438     uint256 private constant _ENTERED = 2;
439 
440     uint256 private _status;
441 
442     constructor() {
443         _status = _NOT_ENTERED;
444     }
445 
446     /**
447      * @dev Prevents a contract from calling itself, directly or indirectly.
448      * Calling a `nonReentrant` function from another `nonReentrant`
449      * function is not supported. It is possible to prevent this from happening
450      * by making the `nonReentrant` function external, and make it call a
451      * `private` function that does the actual work.
452      */
453     modifier nonReentrant() {
454         // On the first call to nonReentrant, _notEntered will be true
455         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
456 
457         // Any calls to nonReentrant after this point will fail
458         _status = _ENTERED;
459 
460         _;
461 
462         // By storing the original value once again, a refund is triggered (see
463         // https://eips.ethereum.org/EIPS/eip-2200)
464         _status = _NOT_ENTERED;
465     }
466 }
467 
468 library Strings {
469     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
470 
471     /**
472      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
473      */
474     function toString(uint256 value) internal pure returns (string memory) {
475         // Inspired by OraclizeAPI's implementation - MIT licence
476         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
477 
478         if (value == 0) {
479             return "0";
480         }
481         uint256 temp = value;
482         uint256 digits;
483         while (temp != 0) {
484             digits++;
485             temp /= 10;
486         }
487         bytes memory buffer = new bytes(digits);
488         while (value != 0) {
489             digits -= 1;
490             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
491             value /= 10;
492         }
493         return string(buffer);
494     }
495 
496     /**
497      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
498      */
499     function toHexString(uint256 value) internal pure returns (string memory) {
500         if (value == 0) {
501             return "0x00";
502         }
503         uint256 temp = value;
504         uint256 length = 0;
505         while (temp != 0) {
506             length++;
507             temp >>= 8;
508         }
509         return toHexString(value, length);
510     }
511 
512     /**
513      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
514      */
515     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
516         bytes memory buffer = new bytes(2 * length + 2);
517         buffer[0] = "0";
518         buffer[1] = "x";
519         for (uint256 i = 2 * length + 1; i > 1; --i) {
520             buffer[i] = _HEX_SYMBOLS[value & 0xf];
521             value >>= 4;
522         }
523         require(value == 0, "Strings: hex length insufficient");
524         return string(buffer);
525     }
526 }
527 
528 abstract contract ERC165 is IERC165 {
529     /**
530      * @dev See {IERC165-supportsInterface}.
531      */
532     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
533         return interfaceId == type(IERC165).interfaceId;
534     }
535 }
536 
537 abstract contract Ownable is Context {
538     address private _owner;
539 
540     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
541 
542     /**
543      * @dev Initializes the contract setting the deployer as the initial owner.
544      */
545     constructor() {
546         _setOwner(_msgSender());
547     }
548 
549     /**
550      * @dev Returns the address of the current owner.
551      */
552     function owner() public view virtual returns (address) {
553         return _owner;
554     }
555 
556     /**
557      * @dev Throws if called by any account other than the owner.
558      */
559     modifier onlyOwner() {
560         require(owner() == _msgSender(), "Ownable: caller is not the owner");
561         _;
562     }
563 
564     /**
565      * @dev Leaves the contract without owner. It will not be possible to call
566      * `onlyOwner` functions anymore. Can only be called by the current owner.
567      *
568      * NOTE: Renouncing ownership will leave the contract without an owner,
569      * thereby removing any functionality that is only available to the owner.
570      */
571     function renounceOwnership() public virtual onlyOwner {
572         _setOwner(address(0));
573     }
574 
575     /**
576      * @dev Transfers ownership of the contract to a new account (`newOwner`).
577      * Can only be called by the current owner.
578      */
579     function transferOwnership(address newOwner) public virtual onlyOwner {
580         require(newOwner != address(0), "Ownable: new owner is the zero address");
581         _setOwner(newOwner);
582     }
583 
584     function _setOwner(address newOwner) private {
585         address oldOwner = _owner;
586         _owner = newOwner;
587         emit OwnershipTransferred(oldOwner, newOwner);
588     }
589 }
590 
591 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
592     using Address for address;
593     using Strings for uint256;
594 
595     // Token name
596     string private _name;
597 
598     // Token symbol
599     string private _symbol;
600 
601     // Mapping from token ID to owner address
602     mapping(uint256 => address) private _owners;
603 
604     // Mapping owner address to token count
605     mapping(address => uint256) private _balances;
606 
607     // Mapping from token ID to approved address
608     mapping(uint256 => address) private _tokenApprovals;
609 
610     // Mapping from owner to operator approvals
611     mapping(address => mapping(address => bool)) private _operatorApprovals;
612 
613     /**
614      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
615      */
616     constructor(string memory name_, string memory symbol_) {
617         _name = name_;
618         _symbol = symbol_;
619     }
620 
621     /**
622      * @dev See {IERC165-supportsInterface}.
623      */
624     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
625         return
626         interfaceId == type(IERC721).interfaceId ||
627         interfaceId == type(IERC721Metadata).interfaceId ||
628         super.supportsInterface(interfaceId);
629     }
630 
631     /**
632      * @dev See {IERC721-balanceOf}.
633      */
634     function balanceOf(address owner) public view virtual override returns (uint256) {
635         require(owner != address(0), "ERC721: balance query for the zero address");
636         return _balances[owner];
637     }
638 
639     /**
640      * @dev See {IERC721-ownerOf}.
641      */
642     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
643         address owner = _owners[tokenId];
644         require(owner != address(0), "ERC721: owner query for nonexistent token");
645         return owner;
646     }
647 
648     /**
649      * @dev See {IERC721Metadata-name}.
650      */
651     function name() public view virtual override returns (string memory) {
652         return _name;
653     }
654 
655     /**
656      * @dev See {IERC721Metadata-symbol}.
657      */
658     function symbol() public view virtual override returns (string memory) {
659         return _symbol;
660     }
661 
662     /**
663      * @dev See {IERC721Metadata-tokenURI}.
664      */
665     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
666         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
667 
668         string memory baseURI = _baseURI();
669         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
670     }
671 
672     /**
673      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
674      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
675      * by default, can be overriden in child contracts.
676      */
677     function _baseURI() internal view virtual returns (string memory) {
678         return "";
679     }
680 
681     /**
682      * @dev See {IERC721-approve}.
683      */
684     function approve(address to, uint256 tokenId) public virtual override {
685         address owner = ERC721.ownerOf(tokenId);
686         require(to != owner, "ERC721: approval to current owner");
687 
688         require(
689             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
690             "ERC721: approve caller is not owner nor approved for all"
691         );
692 
693         _approve(to, tokenId);
694     }
695 
696     /**
697      * @dev See {IERC721-getApproved}.
698      */
699     function getApproved(uint256 tokenId) public view virtual override returns (address) {
700         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
701 
702         return _tokenApprovals[tokenId];
703     }
704 
705     /**
706      * @dev See {IERC721-setApprovalForAll}.
707      */
708     function setApprovalForAll(address operator, bool approved) public virtual override {
709         require(operator != _msgSender(), "ERC721: approve to caller");
710 
711         _operatorApprovals[_msgSender()][operator] = approved;
712         emit ApprovalForAll(_msgSender(), operator, approved);
713     }
714 
715     /**
716      * @dev See {IERC721-isApprovedForAll}.
717      */
718     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
719         return _operatorApprovals[owner][operator];
720     }
721 
722     /**
723      * @dev See {IERC721-transferFrom}.
724      */
725     function transferFrom(
726         address from,
727         address to,
728         uint256 tokenId
729     ) public virtual override {
730         //solhint-disable-next-line max-line-length
731         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
732 
733         _transfer(from, to, tokenId);
734     }
735 
736     /**
737      * @dev See {IERC721-safeTransferFrom}.
738      */
739     function safeTransferFrom(
740         address from,
741         address to,
742         uint256 tokenId
743     ) public virtual override {
744         safeTransferFrom(from, to, tokenId, "");
745     }
746 
747     /**
748      * @dev See {IERC721-safeTransferFrom}.
749      */
750     function safeTransferFrom(
751         address from,
752         address to,
753         uint256 tokenId,
754         bytes memory _data
755     ) public virtual override {
756         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
757         _safeTransfer(from, to, tokenId, _data);
758     }
759 
760     /**
761      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
762      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
763      *
764      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
765      *
766      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
767      * implement alternative mechanisms to perform token transfer, such as signature-based.
768      *
769      * Requirements:
770      *
771      * - `from` cannot be the zero address.
772      * - `to` cannot be the zero address.
773      * - `tokenId` token must exist and be owned by `from`.
774      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
775      *
776      * Emits a {Transfer} event.
777      */
778     function _safeTransfer(
779         address from,
780         address to,
781         uint256 tokenId,
782         bytes memory _data
783     ) internal virtual {
784         _transfer(from, to, tokenId);
785         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
786     }
787 
788     /**
789      * @dev Returns whether `tokenId` exists.
790      *
791      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
792      *
793      * Tokens start existing when they are minted (`_mint`),
794      * and stop existing when they are burned (`_burn`).
795      */
796     function _exists(uint256 tokenId) internal view virtual returns (bool) {
797         return _owners[tokenId] != address(0);
798     }
799 
800     /**
801      * @dev Returns whether `spender` is allowed to manage `tokenId`.
802      *
803      * Requirements:
804      *
805      * - `tokenId` must exist.
806      */
807     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
808         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
809         address owner = ERC721.ownerOf(tokenId);
810         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
811     }
812 
813     /**
814      * @dev Safely mints `tokenId` and transfers it to `to`.
815      *
816      * Requirements:
817      *
818      * - `tokenId` must not exist.
819      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
820      *
821      * Emits a {Transfer} event.
822      */
823     function _safeMint(address to, uint256 tokenId) internal virtual {
824         _safeMint(to, tokenId, "");
825     }
826 
827     /**
828      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
829      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
830      */
831     function _safeMint(
832         address to,
833         uint256 tokenId,
834         bytes memory _data
835     ) internal virtual {
836         _mint(to, tokenId);
837         require(
838             _checkOnERC721Received(address(0), to, tokenId, _data),
839             "ERC721: transfer to non ERC721Receiver implementer"
840         );
841     }
842 
843     /**
844      * @dev Mints `tokenId` and transfers it to `to`.
845      *
846      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
847      *
848      * Requirements:
849      *
850      * - `tokenId` must not exist.
851      * - `to` cannot be the zero address.
852      *
853      * Emits a {Transfer} event.
854      */
855     function _mint(address to, uint256 tokenId) internal virtual {
856         require(to != address(0), "ERC721: mint to the zero address");
857         require(!_exists(tokenId), "ERC721: token already minted");
858 
859         _beforeTokenTransfer(address(0), to, tokenId);
860 
861         _balances[to] += 1;
862         _owners[tokenId] = to;
863 
864         emit Transfer(address(0), to, tokenId);
865     }
866 
867     /**
868      * @dev Destroys `tokenId`.
869      * The approval is cleared when the token is burned.
870      *
871      * Requirements:
872      *
873      * - `tokenId` must exist.
874      *
875      * Emits a {Transfer} event.
876      */
877     function _burn(uint256 tokenId) internal virtual {
878         address owner = ERC721.ownerOf(tokenId);
879 
880         _beforeTokenTransfer(owner, address(0), tokenId);
881 
882         // Clear approvals
883         _approve(address(0), tokenId);
884 
885         _balances[owner] -= 1;
886         delete _owners[tokenId];
887 
888         emit Transfer(owner, address(0), tokenId);
889     }
890 
891     /**
892      * @dev Transfers `tokenId` from `from` to `to`.
893      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
894      *
895      * Requirements:
896      *
897      * - `to` cannot be the zero address.
898      * - `tokenId` token must be owned by `from`.
899      *
900      * Emits a {Transfer} event.
901      */
902     function _transfer(
903         address from,
904         address to,
905         uint256 tokenId
906     ) internal virtual {
907         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
908         require(to != address(0), "ERC721: transfer to the zero address");
909 
910         _beforeTokenTransfer(from, to, tokenId);
911 
912         // Clear approvals from the previous owner
913         _approve(address(0), tokenId);
914 
915         _balances[from] -= 1;
916         _balances[to] += 1;
917         _owners[tokenId] = to;
918 
919         emit Transfer(from, to, tokenId);
920     }
921 
922     /**
923      * @dev Approve `to` to operate on `tokenId`
924      *
925      * Emits a {Approval} event.
926      */
927     function _approve(address to, uint256 tokenId) internal virtual {
928         _tokenApprovals[tokenId] = to;
929         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
930     }
931 
932     /**
933      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
934      * The call is not executed if the target address is not a contract.
935      *
936      * @param from address representing the previous owner of the given token ID
937      * @param to target address that will receive the tokens
938      * @param tokenId uint256 ID of the token to be transferred
939      * @param _data bytes optional data to send along with the call
940      * @return bool whether the call correctly returned the expected magic value
941      */
942     function _checkOnERC721Received(
943         address from,
944         address to,
945         uint256 tokenId,
946         bytes memory _data
947     ) private returns (bool) {
948         if (to.isContract()) {
949             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
950                 return retval == IERC721Receiver.onERC721Received.selector;
951             } catch (bytes memory reason) {
952                 if (reason.length == 0) {
953                     revert("ERC721: transfer to non ERC721Receiver implementer");
954                 } else {
955                     assembly {
956                         revert(add(32, reason), mload(reason))
957                     }
958                 }
959             }
960         } else {
961             return true;
962         }
963     }
964 
965     /**
966      * @dev Hook that is called before any token transfer. This includes minting
967      * and burning.
968      *
969      * Calling conditions:
970      *
971      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
972      * transferred to `to`.
973      * - When `from` is zero, `tokenId` will be minted for `to`.
974      * - When `to` is zero, ``from``'s `tokenId` will be burned.
975      * - `from` and `to` are never both zero.
976      *
977      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
978      */
979     function _beforeTokenTransfer(
980         address from,
981         address to,
982         uint256 tokenId
983     ) internal virtual {}
984 }
985 
986 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
987     // Mapping from owner to list of owned token IDs
988     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
989 
990     // Mapping from token ID to index of the owner tokens list
991     mapping(uint256 => uint256) private _ownedTokensIndex;
992 
993     // Array with all token ids, used for enumeration
994     uint256[] private _allTokens;
995 
996     // Mapping from token id to position in the allTokens array
997     mapping(uint256 => uint256) private _allTokensIndex;
998 
999     /**
1000      * @dev See {IERC165-supportsInterface}.
1001      */
1002     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1003         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1004     }
1005 
1006     /**
1007      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1008      */
1009     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1010         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1011         return _ownedTokens[owner][index];
1012     }
1013 
1014     /**
1015      * @dev See {IERC721Enumerable-totalSupply}.
1016      */
1017     function totalSupply() public view virtual override returns (uint256) {
1018         return _allTokens.length;
1019     }
1020 
1021     /**
1022      * @dev See {IERC721Enumerable-tokenByIndex}.
1023      */
1024     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1025         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1026         return _allTokens[index];
1027     }
1028 
1029     /**
1030      * @dev Hook that is called before any token transfer. This includes minting
1031      * and burning.
1032      *
1033      * Calling conditions:
1034      *
1035      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1036      * transferred to `to`.
1037      * - When `from` is zero, `tokenId` will be minted for `to`.
1038      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1039      * - `from` cannot be the zero address.
1040      * - `to` cannot be the zero address.
1041      *
1042      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1043      */
1044     function _beforeTokenTransfer(
1045         address from,
1046         address to,
1047         uint256 tokenId
1048     ) internal virtual override {
1049         super._beforeTokenTransfer(from, to, tokenId);
1050 
1051         if (from == address(0)) {
1052             _addTokenToAllTokensEnumeration(tokenId);
1053         } else if (from != to) {
1054             _removeTokenFromOwnerEnumeration(from, tokenId);
1055         }
1056         if (to == address(0)) {
1057             _removeTokenFromAllTokensEnumeration(tokenId);
1058         } else if (to != from) {
1059             _addTokenToOwnerEnumeration(to, tokenId);
1060         }
1061     }
1062 
1063     /**
1064      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1065      * @param to address representing the new owner of the given token ID
1066      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1067      */
1068     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1069         uint256 length = ERC721.balanceOf(to);
1070         _ownedTokens[to][length] = tokenId;
1071         _ownedTokensIndex[tokenId] = length;
1072     }
1073 
1074     /**
1075      * @dev Private function to add a token to this extension's token tracking data structures.
1076      * @param tokenId uint256 ID of the token to be added to the tokens list
1077      */
1078     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1079         _allTokensIndex[tokenId] = _allTokens.length;
1080         _allTokens.push(tokenId);
1081     }
1082 
1083     /**
1084      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1085      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1086      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1087      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1088      * @param from address representing the previous owner of the given token ID
1089      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1090      */
1091     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1092         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1093         // then delete the last slot (swap and pop).
1094 
1095         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1096         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1097 
1098         // When the token to delete is the last token, the swap operation is unnecessary
1099         if (tokenIndex != lastTokenIndex) {
1100             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1101 
1102             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1103             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1104         }
1105 
1106         // This also deletes the contents at the last position of the array
1107         delete _ownedTokensIndex[tokenId];
1108         delete _ownedTokens[from][lastTokenIndex];
1109     }
1110 
1111     /**
1112      * @dev Private function to remove a token from this extension's token tracking data structures.
1113      * This has O(1) time complexity, but alters the order of the _allTokens array.
1114      * @param tokenId uint256 ID of the token to be removed from the tokens list
1115      */
1116     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1117         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1118         // then delete the last slot (swap and pop).
1119 
1120         uint256 lastTokenIndex = _allTokens.length - 1;
1121         uint256 tokenIndex = _allTokensIndex[tokenId];
1122 
1123         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1124         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1125         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1126         uint256 lastTokenId = _allTokens[lastTokenIndex];
1127 
1128         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1129         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1130 
1131         // This also deletes the contents at the last position of the array
1132         delete _allTokensIndex[tokenId];
1133         _allTokens.pop();
1134     }
1135 }
1136 
1137 contract ERC721CappedSale is ERC721Enumerable, Ownable, ReentrancyGuard {
1138 
1139     uint256 public _cap;
1140     uint256 public _maxBuyAmount;
1141     uint256 public _pricePerToken; // in wei
1142     address payable public _wallet;
1143 
1144     bool private _isSalePaused = false;
1145 
1146 
1147     constructor(
1148         string memory name_,
1149         string memory symbol_,
1150         uint256 initCap,
1151         uint256 initMaxBuyAmount,
1152         uint256 initPricePerToken,
1153         address payable initWallet
1154     ) ERC721(
1155         name_,
1156         symbol_
1157     ) {
1158         _cap = initCap;
1159         _maxBuyAmount = initMaxBuyAmount;
1160         _pricePerToken = initPricePerToken;
1161         _wallet = initWallet;
1162         _isSalePaused = true;
1163     }
1164 
1165 
1166     function mint(uint256 mintAmount) public payable nonReentrant {
1167         require(!isSalePaused(), "ERC721CappedSale: sale is paused");
1168         require(mintAmount > 0, "ERC721CappedSale: buy at least 1 NFT");
1169         require(mintAmount <= _maxBuyAmount, "ERC721CappedSale: its not allowed to buy this much");
1170         require(mintAmount <= nftsAvailable(), "ERC721CappedSale: not enough NFTs available");
1171         require((_pricePerToken * mintAmount) == msg.value, "ERC721CappedSale: exact value in ETH needed");
1172 
1173         for (uint256 i = 0; i < mintAmount; i++) {
1174             _mintToken(_msgSender());
1175         }
1176         payable(_wallet).transfer(msg.value);
1177     }
1178 
1179 
1180     function nftsAvailable() public view returns(uint256) {
1181         return _cap - totalSupply();
1182     }
1183 
1184     function cap() public view returns(uint256) {
1185         return _cap;
1186     }
1187 
1188     function isSalePaused() public view returns(bool) {
1189         return _isSalePaused;
1190     }
1191 
1192 
1193     function pauseSale() external onlyOwner {
1194         _isSalePaused = true;
1195     }
1196 
1197     function resumeSale() external onlyOwner {
1198         _isSalePaused = false;
1199     }
1200 
1201     /**
1202      * should not be necccesarry as the payed ETH are forwarded on minting
1203      **/
1204     function emergencyWithdraw() public onlyOwner {
1205         payable(msg.sender).transfer(address(this).balance);
1206     }
1207 
1208     /**
1209      * admin can mint for giveaways, airdrops etc
1210      **/
1211     function adminMint(uint256 mintAmount) public onlyOwner {
1212         require(mintAmount > 0, "ERC721CappedSale: buy at least 1 NFT");
1213         require(mintAmount <= nftsAvailable(), "ERC721CappedSale: not enough NFTs available");
1214         for (uint256 i = 0; i < mintAmount; i++) {
1215             _mintToken(_msgSender());
1216         }
1217     }
1218 
1219 
1220     function _mintToken(address destinationAddress) internal {
1221         uint256 newTokenID = totalSupply();
1222         require(!_exists(newTokenID), "ERC721CappedSale: Token already exist.");
1223         _safeMint(destinationAddress, newTokenID);
1224     }
1225 }
1226 
1227 
1228 contract CicadasNFT is ERC721CappedSale {
1229     using Strings for uint256;
1230 
1231     string private constant INIT__NFT_NAME = 'Cicadas';
1232     string private constant INIT__NFT_SYMBOL = 'CICADAS';
1233     string private constant INIT__UNREVEAL_URI = 'ipfs://QmYm4WThc5yCApjFTw8bCv5uCSfikheyKko6khSpAxPHPQ';
1234     uint256 private constant INIT__CAP = 10000;
1235     uint256 private constant INIT__MAX_BUY_AMOUNT = 20;
1236     uint256 private constant INIT__PRICE_PER_TOKEN = 10**17;
1237 
1238 
1239 
1240     // update that later
1241     address payable private constant INIT__WALLET = payable(0x10E7644e76Dad3684c65946afA762f1d2ff098cD);
1242     IERC721 private constant INIT_EA_NFT = IERC721(0xD1CDf1B4784fa299fECef87096E167a48c8BA042);
1243 
1244     IERC721 public _earlyAdopterNFT;
1245     uint256 public _earlyAdopterTime;
1246 
1247     bool public _isRevealed = false;
1248     string public _revealedTokenURI;
1249 
1250     uint256 public _idShift = 0;
1251     bool public _idShiftDone = false;
1252 
1253     bool public _eaSaleIsDone = false;
1254 
1255     // Mapping from early adopter token ids to early minted nfts
1256     mapping(uint256 => uint256) private _earlyAdoptersMinted;
1257 
1258     string private _tokenBaseURI = 'ipfs://QmRdCWCYG2NyhKDLoHrLqLvBUUy4MrNeCM8br4UhxzSLsK/';
1259 
1260     constructor(
1261     ) ERC721CappedSale(
1262         INIT__NFT_NAME,
1263         INIT__NFT_SYMBOL,
1264         INIT__CAP,
1265         INIT__MAX_BUY_AMOUNT,
1266         INIT__PRICE_PER_TOKEN,
1267         payable(msg.sender)  // update that later
1268     )
1269     {
1270         _earlyAdopterNFT = INIT_EA_NFT;
1271     }
1272 
1273 
1274     /**
1275      * @dev override ERC721
1276      **/
1277     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1278         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1279 
1280         if(!_isRevealed) {
1281             return INIT__UNREVEAL_URI;
1282         }
1283         string memory baseURI = _baseURI();
1284         uint256 shiftedTokenId = (tokenId+_idShift) % INIT__CAP;
1285         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, shiftedTokenId.toString(), string('.json'))) : "";
1286     }
1287 
1288     /**
1289      * @dev based on ERC721CappedSale mint function
1290      **/
1291     function earlyAdopterMint(uint256 mintAmount, uint256 earlyAdopterTokenId) public payable nonReentrant {
1292         require(!_eaSaleIsDone, "EarlyAdopter: early adopter sale is done"); // @dev changed this line
1293         require(!isSalePaused(), "ERC721CappedSale: sale is paused");
1294         require(mintAmount > 0, "ERC721CappedSale: buy at least 1 NFT");
1295         require(mintAmount <= _maxBuyAmount, "ERC721CappedSale: its not allowed to buy this much");
1296         require(mintAmount <= nftsAvailable(), "ERC721CappedSale: not enough NFTs available");
1297         require((_pricePerToken * mintAmount) == msg.value, "ERC721CappedSale: exact value in ETH needed");
1298 
1299         // @dev added this
1300         require(isOwnerOfTokenId(earlyAdopterTokenId), "EarlyAdopter: You dont own this token");
1301         require(getEarlyAdopterMaxAmount(earlyAdopterTokenId) >= mintAmount, "EarlyAdopter: You cant mint this much");
1302         reduceEarlyAdopterMaxAmount(earlyAdopterTokenId, mintAmount);
1303 
1304         for (uint256 i = 0; i < mintAmount; i++) {
1305             _mintToken(_msgSender());
1306         }
1307         payable(_wallet).transfer(msg.value);
1308     }
1309 
1310 
1311 
1312     function getEarlyAdopterMaxAmount(uint256 earlyAdopterTokenId) public view returns(uint256) {
1313         return INIT__MAX_BUY_AMOUNT - _earlyAdoptersMinted[earlyAdopterTokenId];
1314 
1315     }
1316 
1317     function reduceEarlyAdopterMaxAmount(uint256 earlyAdopterTokenId, uint256 mintAmount) internal {
1318         _earlyAdoptersMinted[earlyAdopterTokenId] = _earlyAdoptersMinted[earlyAdopterTokenId] + mintAmount;
1319     }
1320 
1321     function isOwnerOfTokenId(uint256 earlyAdopterTokenId) public view returns(bool) {
1322         return _msgSender() == _earlyAdopterNFT.ownerOf(earlyAdopterTokenId);
1323     }
1324 
1325 
1326     /**
1327      * @dev ERC721 override
1328      */
1329     function _baseURI() internal view override returns (string memory) {
1330         return _tokenBaseURI;
1331     }
1332 
1333     function setTokenBaseURI(string memory newBaseURI) public onlyOwner {
1334         _tokenBaseURI = newBaseURI;
1335     }
1336 
1337     function switchEaToRegularSale() public onlyOwner {
1338         _eaSaleIsDone = true;
1339     }
1340 
1341     function reveal() public onlyOwner {
1342         _isRevealed = true;
1343     }
1344 
1345     function shiftIds() public onlyOwner {
1346         require(!_idShiftDone, "ID shift is done");
1347         _idShiftDone = true;
1348         _idShift = block.timestamp % INIT__CAP;
1349     }
1350 
1351 }