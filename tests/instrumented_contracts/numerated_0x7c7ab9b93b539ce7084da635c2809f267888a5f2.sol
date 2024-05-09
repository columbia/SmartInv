1 /**
2  *Submitted for verification at Etherscan.io on 2022-01-03
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.0;
7 interface IERC721Receiver {
8     /**
9      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
10      * by `operator` from `from`, this function is called.
11      *
12      * It must return its Solidity selector to confirm the token transfer.
13      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
14      *
15      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
16      */
17     function onERC721Received(
18         address operator,
19         address from,
20         uint256 tokenId,
21         bytes calldata data
22     ) external returns (bytes4);
23 }
24 pragma solidity ^0.8.0;
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes calldata) {
31         return msg.data;
32     }
33 }
34 pragma solidity ^0.8.0;
35 interface IERC165 {
36     /**
37      * @dev Returns true if this contract implements the interface defined by
38      * `interfaceId`. See the corresponding
39      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
40      * to learn more about how these ids are created.
41      *
42      * This function call must use less than 30 000 gas.
43      */
44     function supportsInterface(bytes4 interfaceId) external view returns (bool);
45 }
46 pragma solidity ^0.8.0;
47 library Address {
48     /**
49      * @dev Returns true if `account` is a contract.
50      *
51      * [IMPORTANT]
52      * ====
53      * It is unsafe to assume that an address for which this function returns
54      * false is an externally-owned account (EOA) and not a contract.
55      *
56      * Among others, `isContract` will return false for the following
57      * types of addresses:
58      *
59      *  - an externally-owned account
60      *  - a contract in construction
61      *  - an address where a contract will be created
62      *  - an address where a contract lived, but was destroyed
63      * ====
64      */
65     function isContract(address account) internal view returns (bool) {
66         // This method relies on extcodesize, which returns 0 for contracts in
67         // construction, since the code is only stored at the end of the
68         // constructor execution.
69 
70         uint256 size;
71         assembly {
72             size := extcodesize(account)
73         }
74         return size > 0;
75     }
76 
77     /**
78      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
79      * `recipient`, forwarding all available gas and reverting on errors.
80      *
81      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
82      * of certain opcodes, possibly making contracts go over the 2300 gas limit
83      * imposed by `transfer`, making them unable to receive funds via
84      * `transfer`. {sendValue} removes this limitation.
85      *
86      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
87      *
88      * IMPORTANT: because control is transferred to `recipient`, care must be
89      * taken to not create reentrancy vulnerabilities. Consider using
90      * {ReentrancyGuard} or the
91      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
92      */
93     function sendValue(address payable recipient, uint256 amount) internal {
94         require(address(this).balance >= amount, "Address: insufficient balance");
95 
96         (bool success, ) = recipient.call{value: amount}("");
97         require(success, "Address: unable to send value, recipient may have reverted");
98     }
99 
100     /**
101      * @dev Performs a Solidity function call using a low level `call`. A
102      * plain `call` is an unsafe replacement for a function call: use this
103      * function instead.
104      *
105      * If `target` reverts with a revert reason, it is bubbled up by this
106      * function (like regular Solidity function calls).
107      *
108      * Returns the raw returned data. To convert to the expected return value,
109      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
110      *
111      * Requirements:
112      *
113      * - `target` must be a contract.
114      * - calling `target` with `data` must not revert.
115      *
116      * _Available since v3.1._
117      */
118     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
119         return functionCall(target, data, "Address: low-level call failed");
120     }
121 
122     /**
123      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
124      * `errorMessage` as a fallback revert reason when `target` reverts.
125      *
126      * _Available since v3.1._
127      */
128     function functionCall(
129         address target,
130         bytes memory data,
131         string memory errorMessage
132     ) internal returns (bytes memory) {
133         return functionCallWithValue(target, data, 0, errorMessage);
134     }
135 
136     /**
137      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
138      * but also transferring `value` wei to `target`.
139      *
140      * Requirements:
141      *
142      * - the calling contract must have an ETH balance of at least `value`.
143      * - the called Solidity function must be `payable`.
144      *
145      * _Available since v3.1._
146      */
147     function functionCallWithValue(
148         address target,
149         bytes memory data,
150         uint256 value
151     ) internal returns (bytes memory) {
152         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
157      * with `errorMessage` as a fallback revert reason when `target` reverts.
158      *
159      * _Available since v3.1._
160      */
161     function functionCallWithValue(
162         address target,
163         bytes memory data,
164         uint256 value,
165         string memory errorMessage
166     ) internal returns (bytes memory) {
167         require(address(this).balance >= value, "Address: insufficient balance for call");
168         require(isContract(target), "Address: call to non-contract");
169 
170         (bool success, bytes memory returndata) = target.call{value: value}(data);
171         return verifyCallResult(success, returndata, errorMessage);
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
176      * but performing a static call.
177      *
178      * _Available since v3.3._
179      */
180     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
181         return functionStaticCall(target, data, "Address: low-level static call failed");
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
186      * but performing a static call.
187      *
188      * _Available since v3.3._
189      */
190     function functionStaticCall(
191         address target,
192         bytes memory data,
193         string memory errorMessage
194     ) internal view returns (bytes memory) {
195         require(isContract(target), "Address: static call to non-contract");
196 
197         (bool success, bytes memory returndata) = target.staticcall(data);
198         return verifyCallResult(success, returndata, errorMessage);
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
203      * but performing a delegate call.
204      *
205      * _Available since v3.4._
206      */
207     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
208         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
213      * but performing a delegate call.
214      *
215      * _Available since v3.4._
216      */
217     function functionDelegateCall(
218         address target,
219         bytes memory data,
220         string memory errorMessage
221     ) internal returns (bytes memory) {
222         require(isContract(target), "Address: delegate call to non-contract");
223 
224         (bool success, bytes memory returndata) = target.delegatecall(data);
225         return verifyCallResult(success, returndata, errorMessage);
226     }
227 
228     /**
229      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
230      * revert reason using the provided one.
231      *
232      * _Available since v4.3._
233      */
234     function verifyCallResult(
235         bool success,
236         bytes memory returndata,
237         string memory errorMessage
238     ) internal pure returns (bytes memory) {
239         if (success) {
240             return returndata;
241         } else {
242             // Look for revert reason and bubble it up if present
243             if (returndata.length > 0) {
244                 // The easiest way to bubble the revert reason is using memory via assembly
245 
246                 assembly {
247                     let returndata_size := mload(returndata)
248                     revert(add(32, returndata), returndata_size)
249                 }
250             } else {
251                 revert(errorMessage);
252             }
253         }
254     }
255 }
256 pragma solidity ^0.8.0;
257 library Strings {
258     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
259 
260     /**
261      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
262      */
263     function toString(uint256 value) internal pure returns (string memory) {
264         // Inspired by OraclizeAPI's implementation - MIT licence
265         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
266 
267         if (value == 0) {
268             return "0";
269         }
270         uint256 temp = value;
271         uint256 digits;
272         while (temp != 0) {
273             digits++;
274             temp /= 10;
275         }
276         bytes memory buffer = new bytes(digits);
277         while (value != 0) {
278             digits -= 1;
279             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
280             value /= 10;
281         }
282         return string(buffer);
283     }
284 
285     /**
286      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
287      */
288     function toHexString(uint256 value) internal pure returns (string memory) {
289         if (value == 0) {
290             return "0x00";
291         }
292         uint256 temp = value;
293         uint256 length = 0;
294         while (temp != 0) {
295             length++;
296             temp >>= 8;
297         }
298         return toHexString(value, length);
299     }
300 
301     /**
302      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
303      */
304     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
305         bytes memory buffer = new bytes(2 * length + 2);
306         buffer[0] = "0";
307         buffer[1] = "x";
308         for (uint256 i = 2 * length + 1; i > 1; --i) {
309             buffer[i] = _HEX_SYMBOLS[value & 0xf];
310             value >>= 4;
311         }
312         require(value == 0, "Strings: hex length insufficient");
313         return string(buffer);
314     }
315 }
316 
317 pragma solidity ^0.8.0;
318 library Counters {
319     struct Counter {
320         // This variable should never be directly accessed by users of the library: interactions must be restricted to
321         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
322         // this feature: see https://github.com/ethereum/solidity/issues/4637
323         uint256 _value; // default: 0
324     }
325 
326     function current(Counter storage counter) internal view returns (uint256) {
327         return counter._value;
328     }
329 
330     function increment(Counter storage counter) internal {
331         unchecked {
332             counter._value += 1;
333         }
334     }
335 
336     function decrement(Counter storage counter) internal {
337         uint256 value = counter._value;
338         require(value > 0, "Counter: decrement overflow");
339         unchecked {
340             counter._value = value - 1;
341         }
342     }
343 
344     function reset(Counter storage counter) internal {
345         counter._value = 0;
346     }
347 }
348 
349 abstract contract ERC165 is IERC165 {
350     /**
351      * @dev See {IERC165-supportsInterface}.
352      */
353     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
354         return interfaceId == type(IERC165).interfaceId;
355     }
356 }
357 
358 abstract contract Ownable is Context {
359     address private _owner;
360 
361     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
362 
363     /**
364      * @dev Initializes the contract setting the deployer as the initial owner.
365      */
366     constructor() {
367         _transferOwnership(_msgSender());
368     }
369 
370     /**
371      * @dev Returns the address of the current owner.
372      */
373     function owner() public view virtual returns (address) {
374         return _owner;
375     }
376 
377     /**
378      * @dev Throws if called by any account other than the owner.
379      */
380     modifier onlyOwner() {
381         require(owner() == _msgSender(), "Ownable: caller is not the owner");
382         _;
383     }
384 
385     /**
386      * @dev Leaves the contract without owner. It will not be possible to call
387      * `onlyOwner` functions anymore. Can only be called by the current owner.
388      *
389      * NOTE: Renouncing ownership will leave the contract without an owner,
390      * thereby removing any functionality that is only available to the owner.
391      */
392     function renounceOwnership() public virtual onlyOwner {
393         _transferOwnership(address(0));
394     }
395 
396     /**
397      * @dev Transfers ownership of the contract to a new account (`newOwner`).
398      * Can only be called by the current owner.
399      */
400     function transferOwnership(address newOwner) public virtual onlyOwner {
401         require(newOwner != address(0), "Ownable: new owner is the zero address");
402         _transferOwnership(newOwner);
403     }
404 
405     /**
406      * @dev Transfers ownership of the contract to a new account (`newOwner`).
407      * Internal function without access restriction.
408      */
409     function _transferOwnership(address newOwner) internal virtual {
410         address oldOwner = _owner;
411         _owner = newOwner;
412         emit OwnershipTransferred(oldOwner, newOwner);
413     }
414 }
415 
416 pragma solidity ^0.8.0;
417 interface IERC721 is IERC165 {
418     /**
419      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
420      */
421     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
422 
423     /**
424      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
425      */
426     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
427 
428     /**
429      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
430      */
431     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
432 
433     /**
434      * @dev Returns the number of tokens in ``owner``'s account.
435      */
436     function balanceOf(address owner) external view returns (uint256 balance);
437 
438     /**
439      * @dev Returns the owner of the `tokenId` token.
440      *
441      * Requirements:
442      *
443      * - `tokenId` must exist.
444      */
445     function ownerOf(uint256 tokenId) external view returns (address owner);
446 
447     /**
448      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
449      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
450      *
451      * Requirements:
452      *
453      * - `from` cannot be the zero address.
454      * - `to` cannot be the zero address.
455      * - `tokenId` token must exist and be owned by `from`.
456      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
457      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
458      *
459      * Emits a {Transfer} event.
460      */
461     function safeTransferFrom(
462         address from,
463         address to,
464         uint256 tokenId
465     ) external;
466 
467     /**
468      * @dev Transfers `tokenId` token from `from` to `to`.
469      *
470      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
471      *
472      * Requirements:
473      *
474      * - `from` cannot be the zero address.
475      * - `to` cannot be the zero address.
476      * - `tokenId` token must be owned by `from`.
477      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
478      *
479      * Emits a {Transfer} event.
480      */
481     function transferFrom(
482         address from,
483         address to,
484         uint256 tokenId
485     ) external;
486 
487     /**
488      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
489      * The approval is cleared when the token is transferred.
490      *
491      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
492      *
493      * Requirements:
494      *
495      * - The caller must own the token or be an approved operator.
496      * - `tokenId` must exist.
497      *
498      * Emits an {Approval} event.
499      */
500     function approve(address to, uint256 tokenId) external;
501 
502     /**
503      * @dev Returns the account approved for `tokenId` token.
504      *
505      * Requirements:
506      *
507      * - `tokenId` must exist.
508      */
509     function getApproved(uint256 tokenId) external view returns (address operator);
510 
511     /**
512      * @dev Approve or remove `operator` as an operator for the caller.
513      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
514      *
515      * Requirements:
516      *
517      * - The `operator` cannot be the caller.
518      *
519      * Emits an {ApprovalForAll} event.
520      */
521     function setApprovalForAll(address operator, bool _approved) external;
522 
523     /**
524      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
525      *
526      * See {setApprovalForAll}
527      */
528     function isApprovedForAll(address owner, address operator) external view returns (bool);
529 
530     /**
531      * @dev Safely transfers `tokenId` token from `from` to `to`.
532      *
533      * Requirements:
534      *
535      * - `from` cannot be the zero address.
536      * - `to` cannot be the zero address.
537      * - `tokenId` token must exist and be owned by `from`.
538      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
539      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
540      *
541      * Emits a {Transfer} event.
542      */
543     function safeTransferFrom(
544         address from,
545         address to,
546         uint256 tokenId,
547         bytes calldata data
548     ) external;
549 }
550 
551 pragma solidity ^0.8.0;
552 interface IERC721Metadata is IERC721 {
553     /**
554      * @dev Returns the token collection name.
555      */
556     function name() external view returns (string memory);
557 
558     /**
559      * @dev Returns the token collection symbol.
560      */
561     function symbol() external view returns (string memory);
562 
563     /**
564      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
565      */
566     function tokenURI(uint256 tokenId) external view returns (string memory);
567 }
568 
569 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
570     using Address for address;
571     using Strings for uint256;
572 
573     // Token name
574     string private _name;
575 
576     // Token symbol
577     string private _symbol;
578 
579     // Mapping from token ID to owner address
580     mapping(uint256 => address) private _owners;
581 
582     // Mapping owner address to token count
583     mapping(address => uint256) private _balances;
584 
585     // Mapping from token ID to approved address
586     mapping(uint256 => address) private _tokenApprovals;
587 
588     // Mapping from owner to operator approvals
589     mapping(address => mapping(address => bool)) private _operatorApprovals;
590 
591     /**
592      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
593      */
594     constructor(string memory name_, string memory symbol_) {
595         _name = name_;
596         _symbol = symbol_;
597     }
598 
599     /**
600      * @dev See {IERC165-supportsInterface}.
601      */
602     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
603         return
604             interfaceId == type(IERC721).interfaceId ||
605             interfaceId == type(IERC721Metadata).interfaceId ||
606             super.supportsInterface(interfaceId);
607     }
608 
609     /**
610      * @dev See {IERC721-balanceOf}.
611      */
612     function balanceOf(address owner) public view virtual override returns (uint256) {
613         require(owner != address(0), "ERC721: balance query for the zero address");
614         return _balances[owner];
615     }
616 
617     /**
618      * @dev See {IERC721-ownerOf}.
619      */
620     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
621         address owner = _owners[tokenId];
622         require(owner != address(0), "ERC721: owner query for nonexistent token");
623         return owner;
624     }
625 
626     /**
627      * @dev See {IERC721Metadata-name}.
628      */
629     function name() public view virtual override returns (string memory) {
630         return _name;
631     }
632 
633     /**
634      * @dev See {IERC721Metadata-symbol}.
635      */
636     function symbol() public view virtual override returns (string memory) {
637         return _symbol;
638     }
639 
640     /**
641      * @dev See {IERC721Metadata-tokenURI}.
642      */
643     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
644         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
645 
646         string memory baseURI = _baseURI();
647         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
648     }
649 
650     /**
651      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
652      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
653      * by default, can be overriden in child contracts.
654      */
655     function _baseURI() internal view virtual returns (string memory) {
656         return "";
657     }
658 
659     /**
660      * @dev See {IERC721-approve}.
661      */
662     function approve(address to, uint256 tokenId) public virtual override {
663         address owner = ERC721.ownerOf(tokenId);
664         require(to != owner, "ERC721: approval to current owner");
665 
666         require(
667             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
668             "ERC721: approve caller is not owner nor approved for all"
669         );
670 
671         _approve(to, tokenId);
672     }
673 
674     /**
675      * @dev See {IERC721-getApproved}.
676      */
677     function getApproved(uint256 tokenId) public view virtual override returns (address) {
678         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
679 
680         return _tokenApprovals[tokenId];
681     }
682 
683     /**
684      * @dev See {IERC721-setApprovalForAll}.
685      */
686     function setApprovalForAll(address operator, bool approved) public virtual override {
687         _setApprovalForAll(_msgSender(), operator, approved);
688     }
689 
690     /**
691      * @dev See {IERC721-isApprovedForAll}.
692      */
693     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
694         return _operatorApprovals[owner][operator];
695     }
696 
697     /**
698      * @dev See {IERC721-transferFrom}.
699      */
700     function transferFrom(
701         address from,
702         address to,
703         uint256 tokenId
704     ) public virtual override {
705         //solhint-disable-next-line max-line-length
706         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
707 
708         _transfer(from, to, tokenId);
709     }
710 
711     /**
712      * @dev See {IERC721-safeTransferFrom}.
713      */
714     function safeTransferFrom(
715         address from,
716         address to,
717         uint256 tokenId
718     ) public virtual override {
719         safeTransferFrom(from, to, tokenId, "");
720     }
721 
722     /**
723      * @dev See {IERC721-safeTransferFrom}.
724      */
725     function safeTransferFrom(
726         address from,
727         address to,
728         uint256 tokenId,
729         bytes memory _data
730     ) public virtual override {
731         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
732         _safeTransfer(from, to, tokenId, _data);
733     }
734 
735     /**
736      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
737      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
738      *
739      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
740      *
741      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
742      * implement alternative mechanisms to perform token transfer, such as signature-based.
743      *
744      * Requirements:
745      *
746      * - `from` cannot be the zero address.
747      * - `to` cannot be the zero address.
748      * - `tokenId` token must exist and be owned by `from`.
749      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
750      *
751      * Emits a {Transfer} event.
752      */
753     function _safeTransfer(
754         address from,
755         address to,
756         uint256 tokenId,
757         bytes memory _data
758     ) internal virtual {
759         _transfer(from, to, tokenId);
760         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
761     }
762 
763     /**
764      * @dev Returns whether `tokenId` exists.
765      *
766      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
767      *
768      * Tokens start existing when they are minted (`_mint`),
769      * and stop existing when they are burned (`_burn`).
770      */
771     function _exists(uint256 tokenId) internal view virtual returns (bool) {
772         return _owners[tokenId] != address(0);
773     }
774 
775     /**
776      * @dev Returns whether `spender` is allowed to manage `tokenId`.
777      *
778      * Requirements:
779      *
780      * - `tokenId` must exist.
781      */
782     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
783         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
784         address owner = ERC721.ownerOf(tokenId);
785         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
786     }
787 
788     /**
789      * @dev Safely mints `tokenId` and transfers it to `to`.
790      *
791      * Requirements:
792      *
793      * - `tokenId` must not exist.
794      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
795      *
796      * Emits a {Transfer} event.
797      */
798     function _safeMint(address to, uint256 tokenId) internal virtual {
799         _safeMint(to, tokenId, "");
800     }
801 
802     /**
803      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
804      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
805      */
806     function _safeMint(
807         address to,
808         uint256 tokenId,
809         bytes memory _data
810     ) internal virtual {
811         _mint(to, tokenId);
812         require(
813             _checkOnERC721Received(address(0), to, tokenId, _data),
814             "ERC721: transfer to non ERC721Receiver implementer"
815         );
816     }
817 
818     /**
819      * @dev Mints `tokenId` and transfers it to `to`.
820      *
821      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
822      *
823      * Requirements:
824      *
825      * - `tokenId` must not exist.
826      * - `to` cannot be the zero address.
827      *
828      * Emits a {Transfer} event.
829      */
830     function _mint(address to, uint256 tokenId) internal virtual {
831         require(to != address(0), "ERC721: mint to the zero address");
832         require(!_exists(tokenId), "ERC721: token already minted");
833 
834         _beforeTokenTransfer(address(0), to, tokenId);
835 
836         _balances[to] += 1;
837         _owners[tokenId] = to;
838 
839         emit Transfer(address(0), to, tokenId);
840     }
841 
842     /**
843      * @dev Destroys `tokenId`.
844      * The approval is cleared when the token is burned.
845      *
846      * Requirements:
847      *
848      * - `tokenId` must exist.
849      *
850      * Emits a {Transfer} event.
851      */
852     function _burn(uint256 tokenId) internal virtual {
853         address owner = ERC721.ownerOf(tokenId);
854 
855         _beforeTokenTransfer(owner, address(0), tokenId);
856 
857         // Clear approvals
858         _approve(address(0), tokenId);
859 
860         _balances[owner] -= 1;
861         delete _owners[tokenId];
862 
863         emit Transfer(owner, address(0), tokenId);
864     }
865 
866     /**
867      * @dev Transfers `tokenId` from `from` to `to`.
868      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
869      *
870      * Requirements:
871      *
872      * - `to` cannot be the zero address.
873      * - `tokenId` token must be owned by `from`.
874      *
875      * Emits a {Transfer} event.
876      */
877     function _transfer(
878         address from,
879         address to,
880         uint256 tokenId
881     ) internal virtual {
882         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
883         require(to != address(0), "ERC721: transfer to the zero address");
884 
885         _beforeTokenTransfer(from, to, tokenId);
886 
887         // Clear approvals from the previous owner
888         _approve(address(0), tokenId);
889 
890         _balances[from] -= 1;
891         _balances[to] += 1;
892         _owners[tokenId] = to;
893 
894         emit Transfer(from, to, tokenId);
895     }
896 
897     /**
898      * @dev Approve `to` to operate on `tokenId`
899      *
900      * Emits a {Approval} event.
901      */
902     function _approve(address to, uint256 tokenId) internal virtual {
903         _tokenApprovals[tokenId] = to;
904         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
905     }
906 
907     /**
908      * @dev Approve `operator` to operate on all of `owner` tokens
909      *
910      * Emits a {ApprovalForAll} event.
911      */
912     function _setApprovalForAll(
913         address owner,
914         address operator,
915         bool approved
916     ) internal virtual {
917         require(owner != operator, "ERC721: approve to caller");
918         _operatorApprovals[owner][operator] = approved;
919         emit ApprovalForAll(owner, operator, approved);
920     }
921 
922     /**
923      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
924      * The call is not executed if the target address is not a contract.
925      *
926      * @param from address representing the previous owner of the given token ID
927      * @param to target address that will receive the tokens
928      * @param tokenId uint256 ID of the token to be transferred
929      * @param _data bytes optional data to send along with the call
930      * @return bool whether the call correctly returned the expected magic value
931      */
932     function _checkOnERC721Received(
933         address from,
934         address to,
935         uint256 tokenId,
936         bytes memory _data
937     ) private returns (bool) {
938         if (to.isContract()) {
939             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
940                 return retval == IERC721Receiver.onERC721Received.selector;
941             } catch (bytes memory reason) {
942                 if (reason.length == 0) {
943                     revert("ERC721: transfer to non ERC721Receiver implementer");
944                 } else {
945                     assembly {
946                         revert(add(32, reason), mload(reason))
947                     }
948                 }
949             }
950         } else {
951             return true;
952         }
953     }
954 
955     /**
956      * @dev Hook that is called before any token transfer. This includes minting
957      * and burning.
958      *
959      * Calling conditions:
960      *
961      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
962      * transferred to `to`.
963      * - When `from` is zero, `tokenId` will be minted for `to`.
964      * - When `to` is zero, ``from``'s `tokenId` will be burned.
965      * - `from` and `to` are never both zero.
966      *
967      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
968      */
969     function _beforeTokenTransfer(
970         address from,
971         address to,
972         uint256 tokenId
973     ) internal virtual {}
974 }
975 
976 pragma solidity ^0.8.0;
977 contract Melty is ERC721, Ownable {
978     using Strings for uint256;
979     using Counters for Counters.Counter;
980 
981     Counters.Counter private _tokenSupply;
982 
983     uint256 public constant MAX_SUPPLY = 3333;
984     string baseURI;
985     string public baseExtension = ".json";
986     bool public paused = true;
987     bool public staffPurchaced = false;
988 
989     constructor(
990         string memory _name,
991         string memory _symbol,
992         string memory _initBaseURI
993     ) ERC721 (_name, _symbol){
994         baseURI = _initBaseURI;
995     }
996 
997     //PUBLIC
998     // This is the new mint function leveraging the counter library
999     function mint(uint256 _mintAmount) public payable {
1000 
1001         uint256 mintIndex = _tokenSupply.current() + 1; // Start IDs at 1
1002 
1003         require(!paused, "Melties are paused!");
1004         require(_mintAmount > 0, "Cant order negative number");
1005         require(mintIndex + _mintAmount <= MAX_SUPPLY, "This order would exceed the max supply");
1006 
1007         require(_mintAmount <= maxMintAmount(mintIndex), "This order exceeds max mint amount for the current stage");
1008         require(msg.value >= price(mintIndex) * _mintAmount, "This order doesn't meet the price requirement for the current stage");
1009 
1010 
1011         for (uint256 i = 0; i < _mintAmount; i++){
1012             _safeMint(msg.sender, mintIndex + i);
1013             _tokenSupply.increment();
1014         }
1015     }
1016 
1017     //Staff access 10 (must get before sold out)
1018     function adminMint() public onlyOwner {
1019         require(!staffPurchaced, "Staff order has already been fuffiled"); 
1020         require(_tokenSupply.current() + 10 <= MAX_SUPPLY, "Exceeds max supply");
1021 
1022         uint256 mintIndex = _tokenSupply.current() + 1;
1023         for (uint256 i = 0; i < 10; i++) { 
1024             
1025             _safeMint(msg.sender, mintIndex + i);
1026             _tokenSupply.increment();
1027         }
1028     }
1029 
1030 
1031     // How many left
1032     function remainingSupply() public view returns (uint256) {
1033         return MAX_SUPPLY - _tokenSupply.current();
1034     }
1035 
1036     // How many minted
1037     function tokenSupply() public view returns (uint256) {
1038         return _tokenSupply.current();
1039     }
1040 
1041     function tokenURI(uint256 tokenId)
1042     public
1043     view
1044     virtual
1045     override
1046     returns (string memory)
1047     {
1048         require(
1049             _exists(tokenId),
1050             "ERC721Metadata: URI query for nonexistent token"
1051         );
1052 
1053         string memory currentBaseURI = _baseURI();
1054         return bytes(currentBaseURI).length > 0
1055             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1056             : "";
1057     }
1058 
1059     // Internal
1060     function _baseURI() internal view virtual override returns (string memory) {
1061         return baseURI;
1062     }
1063 
1064     function price(uint256 _supply) internal pure returns (uint256 _cost){
1065       if(_supply < 333){
1066         return 0 ether;
1067       }else{
1068           return 0.02 ether;
1069       }
1070     } 
1071 
1072     function maxMintAmount(uint256 _supply) internal pure returns (uint256 _maxMintAmount){
1073       if(_supply < 333){
1074           return 3;
1075       }else{
1076         return 10;
1077       }
1078     }
1079 
1080     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1081         baseURI = _newBaseURI;
1082     }
1083 
1084     function pause(bool _state) public onlyOwner{
1085         paused = _state;
1086     }
1087 
1088     function withdraw() public payable onlyOwner {
1089     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1090     require(os);
1091   }
1092 }