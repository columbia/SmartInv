1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-19
3 */
4 
5 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
6 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
7 //@@@@@@@@@@@@@@@@@@##@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@*  %@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
8 //@@@@@@@@@@@@@@  @@@@    *@@@@@@@@@@@@@@  @@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@   .@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
9 //@@@@@@@@@@@# %@@@@@@@@@   @@ /@@@@@@@@@@  @@@@@@@@@@@@  @@@@@@@@@@@@@ /@  /@@  @@@@@ @@@@@   @@@@@@@@ @@@@@@@@@@@@@@@@@@@@./@*         .@@@@@@@@@@@@@@
10 //@@@@@@@@@@* @@@@@@@@@@@@  @@ @@@@@@@@@@@@ (@%   &@@@@@@  @@@,@@@@@@@ #@@@@%   @@@@@@ #@@@@         @@  @@@@@@@@@@@@@@@@. @/ @@@@@@@@@@@@  @@@@@@@@@@@@
11 //@@@@@@@@@@ /@@@@@@@@@@@@@      @  @@@    # @@@@@@@@@. @@ (@@@ @@@@@  @@@@@@@  @@@@@@  @@ &@@@@@@@@@  @ @@@@@@@  @@@@@@@/ @  @@@@@@@@@@@@@  @@@@@@@@@@@
12 //@@@@@@@@@@  @@@@@@@@@@@@    @@@@@@@@@@@@@   @@@@@@@@@@ @/ @@@& @@@/ @@@@@@@@  @@@@@@@   .@@@@@@@@@@@@ & @@@@@@  (@@@@@@  @  &@@@@@@@@@@@@@( @@@@@@@@@@
13 //@@@@@@@@@@@  .@@@@@.  ,@@@   @@@@@@@@@@@@   @@@@@@@@@  @@ .@@@  @@@ @@@@@@@@  @@@@@@@@ # @@@@@@@@@@@@@   @@@@@   @@@@@  @@@  @@@@@@@@@@@@@@  @@@@@@@@@
14 //@@@@@@@@@@@@@@@@@@@@@@@@@@%  @@@@@@@@@@@@@  %    ,@@  @@@  @@@@ @@@@ &@@@@@  (@@@@@@@@/   @@@@@@@@@@@* @  @@@* @ @@@@. @@@@# @@@@@@@@@@@@@@@  @@@@@@@@
15 //@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@  @ ,@@@@@@@@@@@@ *@@@@@ @@@@@@@@@@@@@@@@@@@@@@  @ %@@@@@@@  @@@@, @@ @@  @@  @@@@@@ @@@@@@@@@@@@@@@  @@@@@@@@
16 //@@@@@@@@@@ %@@@@@@@@@@@@@@ *@  @@@@@@@  &@@( @@@@@@@@@@@@ %@@@@@@@@@@@@@@@@@@@@@@@@@@@@* @@@@   @@@@@@@@@@@@@@@@# @  @@@@@@@ @@@@@@@@@@@@@@@  @@@@@@@@
17 //@@@@@@@@@@@@      .@@@@@@  @@@@       @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@   @@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@
18 //@@@@@@@@@@@@@@@@@@@@@*   %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
19 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
20 
21 // SPDX-License-Identifier: MIT
22 pragma solidity ^0.8.2;
23 
24 library Strings {
25     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
26 
27     /**
28      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
29      */
30     function toString(uint256 value) internal pure returns (string memory) {
31         // Inspired by OraclizeAPI's implementation - MIT licence
32         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
33 
34         if (value == 0) {
35             return "0";
36         }
37         uint256 temp = value;
38         uint256 digits;
39         while (temp != 0) {
40             digits++;
41             temp /= 10;
42         }
43         bytes memory buffer = new bytes(digits);
44         while (value != 0) {
45             digits -= 1;
46             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
47             value /= 10;
48         }
49         return string(buffer);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
54      */
55     function toHexString(uint256 value) internal pure returns (string memory) {
56         if (value == 0) {
57             return "0x00";
58         }
59         uint256 temp = value;
60         uint256 length = 0;
61         while (temp != 0) {
62             length++;
63             temp >>= 8;
64         }
65         return toHexString(value, length);
66     }
67 
68     /**
69      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
70      */
71     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
72         bytes memory buffer = new bytes(2 * length + 2);
73         buffer[0] = "0";
74         buffer[1] = "x";
75         for (uint256 i = 2 * length + 1; i > 1; --i) {
76             buffer[i] = _HEX_SYMBOLS[value & 0xf];
77             value >>= 4;
78         }
79         require(value == 0, "Strings: hex length insufficient");
80         return string(buffer);
81     }
82 }
83 
84 library Address {
85     /**
86      * @dev Returns true if `account` is a contract.
87      *
88      * [IMPORTANT]
89      * ====
90      * It is unsafe to assume that an address for which this function returns
91      * false is an externally-owned account (EOA) and not a contract.
92      *
93      * Among others, `isContract` will return false for the following
94      * types of addresses:
95      *
96      *  - an externally-owned account
97      *  - a contract in construction
98      *  - an address where a contract will be created
99      *  - an address where a contract lived, but was destroyed
100      * ====
101      *
102      * [IMPORTANT]
103      * ====
104      * You shouldn't rely on `isContract` to protect against flash loan attacks!
105      *
106      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
107      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
108      * constructor.
109      * ====
110      */
111     function isContract(address account) internal view returns (bool) {
112         // This method relies on extcodesize/address.code.length, which returns 0
113         // for contracts in construction, since the code is only stored at the end
114         // of the constructor execution.
115 
116         return account.code.length > 0;
117     }
118 
119     /**
120      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
121      * `recipient`, forwarding all available gas and reverting on errors.
122      *
123      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
124      * of certain opcodes, possibly making contracts go over the 2300 gas limit
125      * imposed by `transfer`, making them unable to receive funds via
126      * `transfer`. {sendValue} removes this limitation.
127      *
128      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
129      *
130      * IMPORTANT: because control is transferred to `recipient`, care must be
131      * taken to not create reentrancy vulnerabilities. Consider using
132      * {ReentrancyGuard} or the
133      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
134      */
135     function sendValue(address payable recipient, uint256 amount) internal {
136         require(address(this).balance >= amount, "Address: insufficient balance");
137 
138         (bool success, ) = recipient.call{value: amount}("");
139         require(success, "Address: unable to send value, recipient may have reverted");
140     }
141 
142     /**
143      * @dev Performs a Solidity function call using a low level `call`. A
144      * plain `call` is an unsafe replacement for a function call: use this
145      * function instead.
146      *
147      * If `target` reverts with a revert reason, it is bubbled up by this
148      * function (like regular Solidity function calls).
149      *
150      * Returns the raw returned data. To convert to the expected return value,
151      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
152      *
153      * Requirements:
154      *
155      * - `target` must be a contract.
156      * - calling `target` with `data` must not revert.
157      *
158      * _Available since v3.1._
159      */
160     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
161         return functionCall(target, data, "Address: low-level call failed");
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
166      * `errorMessage` as a fallback revert reason when `target` reverts.
167      *
168      * _Available since v3.1._
169      */
170     function functionCall(
171         address target,
172         bytes memory data,
173         string memory errorMessage
174     ) internal returns (bytes memory) {
175         return functionCallWithValue(target, data, 0, errorMessage);
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
180      * but also transferring `value` wei to `target`.
181      *
182      * Requirements:
183      *
184      * - the calling contract must have an ETH balance of at least `value`.
185      * - the called Solidity function must be `payable`.
186      *
187      * _Available since v3.1._
188      */
189     function functionCallWithValue(
190         address target,
191         bytes memory data,
192         uint256 value
193     ) internal returns (bytes memory) {
194         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
199      * with `errorMessage` as a fallback revert reason when `target` reverts.
200      *
201      * _Available since v3.1._
202      */
203     function functionCallWithValue(
204         address target,
205         bytes memory data,
206         uint256 value,
207         string memory errorMessage
208     ) internal returns (bytes memory) {
209         require(address(this).balance >= value, "Address: insufficient balance for call");
210         require(isContract(target), "Address: call to non-contract");
211 
212         (bool success, bytes memory returndata) = target.call{value: value}(data);
213         return verifyCallResult(success, returndata, errorMessage);
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
218      * but performing a static call.
219      *
220      * _Available since v3.3._
221      */
222     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
223         return functionStaticCall(target, data, "Address: low-level static call failed");
224     }
225 
226     /**
227      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
228      * but performing a static call.
229      *
230      * _Available since v3.3._
231      */
232     function functionStaticCall(
233         address target,
234         bytes memory data,
235         string memory errorMessage
236     ) internal view returns (bytes memory) {
237         require(isContract(target), "Address: static call to non-contract");
238 
239         (bool success, bytes memory returndata) = target.staticcall(data);
240         return verifyCallResult(success, returndata, errorMessage);
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
245      * but performing a delegate call.
246      *
247      * _Available since v3.4._
248      */
249     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
250         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
255      * but performing a delegate call.
256      *
257      * _Available since v3.4._
258      */
259     function functionDelegateCall(
260         address target,
261         bytes memory data,
262         string memory errorMessage
263     ) internal returns (bytes memory) {
264         require(isContract(target), "Address: delegate call to non-contract");
265 
266         (bool success, bytes memory returndata) = target.delegatecall(data);
267         return verifyCallResult(success, returndata, errorMessage);
268     }
269 
270     /**
271      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
272      * revert reason using the provided one.
273      *
274      * _Available since v4.3._
275      */
276     function verifyCallResult(
277         bool success,
278         bytes memory returndata,
279         string memory errorMessage
280     ) internal pure returns (bytes memory) {
281         if (success) {
282             return returndata;
283         } else {
284             // Look for revert reason and bubble it up if present
285             if (returndata.length > 0) {
286                 // The easiest way to bubble the revert reason is using memory via assembly
287 
288                 assembly {
289                     let returndata_size := mload(returndata)
290                     revert(add(32, returndata), returndata_size)
291                 }
292             } else {
293                 revert(errorMessage);
294             }
295         }
296     }
297 }
298 
299 
300 abstract contract Context {
301     function _msgSender() internal view virtual returns (address) {
302         return msg.sender;
303     }
304 
305     function _msgData() internal view virtual returns (bytes calldata) {
306         return msg.data;
307     }
308 }
309 
310 abstract contract Ownable is Context {
311     address private _owner;
312 
313     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
314 
315     /**
316      * @dev Initializes the contract setting the deployer as the initial owner.
317      */
318     constructor() {
319         _transferOwnership(_msgSender());
320     }
321 
322     /**
323      * @dev Returns the address of the current owner.
324      */
325     function owner() public view virtual returns (address) {
326         return _owner;
327     }
328 
329     /**
330      * @dev Throws if called by any account other than the owner.
331      */
332     modifier onlyOwner() {
333         require(owner() == _msgSender(), "Ownable: caller is not the owner");
334         _;
335     }
336 
337     /**
338      * @dev Leaves the contract without owner. It will not be possible to call
339      * `onlyOwner` functions anymore. Can only be called by the current owner.
340      *
341      * NOTE: Renouncing ownership will leave the contract without an owner,
342      * thereby removing any functionality that is only available to the owner.
343      */
344     function renounceOwnership() public virtual onlyOwner {
345         _transferOwnership(address(0));
346     }
347 
348     /**
349      * @dev Transfers ownership of the contract to a new account (`newOwner`).
350      * Can only be called by the current owner.
351      */
352     function transferOwnership(address newOwner) public virtual onlyOwner {
353         require(newOwner != address(0), "Ownable: new owner is the zero address");
354         _transferOwnership(newOwner);
355     }
356 
357     /**
358      * @dev Transfers ownership of the contract to a new account (`newOwner`).
359      * Internal function without access restriction.
360      */
361     function _transferOwnership(address newOwner) internal virtual {
362         address oldOwner = _owner;
363         _owner = newOwner;
364         emit OwnershipTransferred(oldOwner, newOwner);
365     }
366 }
367 
368 interface IERC165 {
369     /**
370      * @dev Returns true if this contract implements the interface defined by
371      * `interfaceId`. See the corresponding
372      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
373      * to learn more about how these ids are created.
374      *
375      * This function call must use less than 30 000 gas.
376      */
377     function supportsInterface(bytes4 interfaceId) external view returns (bool);
378 }
379 
380 abstract contract ERC165 is IERC165 {
381     /**
382      * @dev See {IERC165-supportsInterface}.
383      */
384     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
385         return interfaceId == type(IERC165).interfaceId;
386     }
387 }
388 
389 interface IERC721 is IERC165 {
390     /**
391      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
392      */
393     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
394 
395     /**
396      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
397      */
398     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
399 
400     /**
401      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
402      */
403     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
404 
405     /**
406      * @dev Returns the number of tokens in ``owner``'s account.
407      */
408     function balanceOf(address owner) external view returns (uint256 balance);
409 
410     /**
411      * @dev Returns the owner of the `tokenId` token.
412      *
413      * Requirements:
414      *
415      * - `tokenId` must exist.
416      */
417     function ownerOf(uint256 tokenId) external view returns (address owner);
418 
419     /**
420      * @dev Safely transfers `tokenId` token from `from` to `to`.
421      *
422      * Requirements:
423      *
424      * - `from` cannot be the zero address.
425      * - `to` cannot be the zero address.
426      * - `tokenId` token must exist and be owned by `from`.
427      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
428      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
429      *
430      * Emits a {Transfer} event.
431      */
432     function safeTransferFrom(
433         address from,
434         address to,
435         uint256 tokenId,
436         bytes calldata data
437     ) external;
438 
439     /**
440      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
441      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
442      *
443      * Requirements:
444      *
445      * - `from` cannot be the zero address.
446      * - `to` cannot be the zero address.
447      * - `tokenId` token must exist and be owned by `from`.
448      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
449      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
450      *
451      * Emits a {Transfer} event.
452      */
453     function safeTransferFrom(
454         address from,
455         address to,
456         uint256 tokenId
457     ) external;
458 
459     /**
460      * @dev Transfers `tokenId` token from `from` to `to`.
461      *
462      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
463      *
464      * Requirements:
465      *
466      * - `from` cannot be the zero address.
467      * - `to` cannot be the zero address.
468      * - `tokenId` token must be owned by `from`.
469      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
470      *
471      * Emits a {Transfer} event.
472      */
473     function transferFrom(
474         address from,
475         address to,
476         uint256 tokenId
477     ) external;
478 
479     /**
480      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
481      * The approval is cleared when the token is transferred.
482      *
483      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
484      *
485      * Requirements:
486      *
487      * - The caller must own the token or be an approved operator.
488      * - `tokenId` must exist.
489      *
490      * Emits an {Approval} event.
491      */
492     function approve(address to, uint256 tokenId) external;
493 
494     /**
495      * @dev Approve or remove `operator` as an operator for the caller.
496      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
497      *
498      * Requirements:
499      *
500      * - The `operator` cannot be the caller.
501      *
502      * Emits an {ApprovalForAll} event.
503      */
504     function setApprovalForAll(address operator, bool _approved) external;
505 
506     /**
507      * @dev Returns the account approved for `tokenId` token.
508      *
509      * Requirements:
510      *
511      * - `tokenId` must exist.
512      */
513     function getApproved(uint256 tokenId) external view returns (address operator);
514 
515     /**
516      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
517      *
518      * See {setApprovalForAll}
519      */
520     function isApprovedForAll(address owner, address operator) external view returns (bool);
521 }
522 
523 interface IERC721Receiver {
524     /**
525      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
526      * by `operator` from `from`, this function is called.
527      *
528      * It must return its Solidity selector to confirm the token transfer.
529      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
530      *
531      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
532      */
533     function onERC721Received(
534         address operator,
535         address from,
536         uint256 tokenId,
537         bytes calldata data
538     ) external returns (bytes4);
539 }
540 
541 interface IERC721Metadata is IERC721 {
542     /**
543      * @dev Returns the token collection name.
544      */
545     function name() external view returns (string memory);
546 
547     /**
548      * @dev Returns the token collection symbol.
549      */
550     function symbol() external view returns (string memory);
551 
552     /**
553      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
554      */
555     function tokenURI(uint256 tokenId) external view returns (string memory);
556 }
557 
558 interface IERC721Enumerable is IERC721 {
559     /**
560      * @dev Returns the total amount of tokens stored by the contract.
561      */
562     function totalSupply() external view returns (uint256);
563 
564     /**
565      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
566      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
567      */
568     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
569 
570     /**
571      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
572      * Use along with {totalSupply} to enumerate all tokens.
573      */
574     function tokenByIndex(uint256 index) external view returns (uint256);
575 }
576 
577 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
578     using Address for address;
579     using Strings for uint256;
580 
581     struct TokenOwnership {
582         address addr;
583         uint64 startTimestamp;
584     }
585 
586     struct AddressData {
587         uint128 balance;
588         uint128 numberMinted;
589     }
590 
591     uint256 internal currentIndex;
592 
593     // Token name
594     string private _name;
595 
596     // Token symbol
597     string private _symbol;
598 
599     // Mapping from token ID to ownership details
600     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
601     mapping(uint256 => TokenOwnership) internal _ownerships;
602 
603     // Mapping owner address to address data
604     mapping(address => AddressData) private _addressData;
605 
606     // Mapping from token ID to approved address
607     mapping(uint256 => address) private _tokenApprovals;
608 
609     // Mapping from owner to operator approvals
610     mapping(address => mapping(address => bool)) private _operatorApprovals;
611 
612     constructor(string memory name_, string memory symbol_) {
613         _name = name_;
614         _symbol = symbol_;
615     }
616 
617     /**
618      * @dev See {IERC721Enumerable-totalSupply}.
619      */
620     function totalSupply() public view override returns (uint256) {
621         return currentIndex;
622     }
623 
624     /**
625      * @dev See {IERC721Enumerable-tokenByIndex}.
626      */
627     function tokenByIndex(uint256 index) public view override returns (uint256) {
628         require(index < totalSupply(), 'ERC721A: global index out of bounds');
629         return index;
630     }
631 
632     /**
633      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
634      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
635      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
636      */
637     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
638         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
639         uint256 numMintedSoFar = totalSupply();
640         uint256 tokenIdsIdx;
641         address currOwnershipAddr;
642 
643         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
644         unchecked {
645             for (uint256 i; i < numMintedSoFar; i++) {
646                 TokenOwnership memory ownership = _ownerships[i];
647                 if (ownership.addr != address(0)) {
648                     currOwnershipAddr = ownership.addr;
649                 }
650                 if (currOwnershipAddr == owner) {
651                     if (tokenIdsIdx == index) {
652                         return i;
653                     }
654                     tokenIdsIdx++;
655                 }
656             }
657         }
658 
659         revert('ERC721A: unable to get token of owner by index');
660     }
661 
662     /**
663      * @dev See {IERC165-supportsInterface}.
664      */
665     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
666         return
667             interfaceId == type(IERC721).interfaceId ||
668             interfaceId == type(IERC721Metadata).interfaceId ||
669             interfaceId == type(IERC721Enumerable).interfaceId ||
670             super.supportsInterface(interfaceId);
671     }
672 
673     /**
674      * @dev See {IERC721-balanceOf}.
675      */
676     function balanceOf(address owner) public view override returns (uint256) {
677         require(owner != address(0), 'ERC721A: balance query for the zero address');
678         return uint256(_addressData[owner].balance);
679     }
680 
681     function _numberMinted(address owner) internal view returns (uint256) {
682         require(owner != address(0), 'ERC721A: number minted query for the zero address');
683         return uint256(_addressData[owner].numberMinted);
684     }
685 
686     /**
687      * Gas spent here starts off proportional to the maximum mint batch size.
688      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
689      */
690     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
691         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
692 
693         unchecked {
694             for (uint256 curr = tokenId; curr >= 0; curr--) {
695                 TokenOwnership memory ownership = _ownerships[curr];
696                 if (ownership.addr != address(0)) {
697                     return ownership;
698                 }
699             }
700         }
701 
702         revert('ERC721A: unable to determine the owner of token');
703     }
704 
705     /**
706      * @dev See {IERC721-ownerOf}.
707      */
708     function ownerOf(uint256 tokenId) public view override returns (address) {
709         return ownershipOf(tokenId).addr;
710     }
711 
712     /**
713      * @dev See {IERC721Metadata-name}.
714      */
715     function name() public view virtual override returns (string memory) {
716         return _name;
717     }
718 
719     /**
720      * @dev See {IERC721Metadata-symbol}.
721      */
722     function symbol() public view virtual override returns (string memory) {
723         return _symbol;
724     }
725 
726     /**
727      * @dev See {IERC721Metadata-tokenURI}.
728      */
729     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
730         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
731 
732         string memory baseURI = _baseURI();
733         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
734     }
735 
736     /**
737      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
738      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
739      * by default, can be overriden in child contracts.
740      */
741     function _baseURI() internal view virtual returns (string memory) {
742         return '';
743     }
744 
745     /**
746      * @dev See {IERC721-approve}.
747      */
748     function approve(address to, uint256 tokenId) public override {
749         address owner = ERC721A.ownerOf(tokenId);
750         require(to != owner, 'ERC721A: approval to current owner');
751 
752         require(
753             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
754             'ERC721A: approve caller is not owner nor approved for all'
755         );
756 
757         _approve(to, tokenId, owner);
758     }
759 
760     /**
761      * @dev See {IERC721-getApproved}.
762      */
763     function getApproved(uint256 tokenId) public view override returns (address) {
764         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
765 
766         return _tokenApprovals[tokenId];
767     }
768 
769     /**
770      * @dev See {IERC721-setApprovalForAll}.
771      */
772     function setApprovalForAll(address operator, bool approved) public override {
773         require(operator != _msgSender(), 'ERC721A: approve to caller');
774 
775         _operatorApprovals[_msgSender()][operator] = approved;
776         emit ApprovalForAll(_msgSender(), operator, approved);
777     }
778 
779     /**
780      * @dev See {IERC721-isApprovedForAll}.
781      */
782     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
783         return _operatorApprovals[owner][operator];
784     }
785 
786     /**
787      * @dev See {IERC721-transferFrom}.
788      */
789     function transferFrom(
790         address from,
791         address to,
792         uint256 tokenId
793     ) public override {
794         _transfer(from, to, tokenId);
795     }
796 
797     /**
798      * @dev See {IERC721-safeTransferFrom}.
799      */
800     function safeTransferFrom(
801         address from,
802         address to,
803         uint256 tokenId
804     ) public override {
805         safeTransferFrom(from, to, tokenId, '');
806     }
807 
808     /**
809      * @dev See {IERC721-safeTransferFrom}.
810      */
811     function safeTransferFrom(
812         address from,
813         address to,
814         uint256 tokenId,
815         bytes memory _data
816     ) public override {
817         _transfer(from, to, tokenId);
818         require(
819             _checkOnERC721Received(from, to, tokenId, _data),
820             'ERC721A: transfer to non ERC721Receiver implementer'
821         );
822     }
823 
824     /**
825      * @dev Returns whether `tokenId` exists.
826      *
827      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
828      *
829      * Tokens start existing when they are minted (`_mint`),
830      */
831     function _exists(uint256 tokenId) internal view returns (bool) {
832         return tokenId < currentIndex;
833     }
834 
835     function _safeMint(address to, uint256 quantity) internal {
836         _safeMint(to, quantity, '');
837     }
838 
839     /**
840      * @dev Safely mints `quantity` tokens and transfers them to `to`.
841      *
842      * Requirements:
843      *
844      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
845      * - `quantity` must be greater than 0.
846      *
847      * Emits a {Transfer} event.
848      */
849     function _safeMint(
850         address to,
851         uint256 quantity,
852         bytes memory _data
853     ) internal {
854         _mint(to, quantity, _data, true);
855     }
856 
857     /**
858      * @dev Mints `quantity` tokens and transfers them to `to`.
859      *
860      * Requirements:
861      *
862      * - `to` cannot be the zero address.
863      * - `quantity` must be greater than 0.
864      *
865      * Emits a {Transfer} event.
866      */
867     function _mint(
868         address to,
869         uint256 quantity,
870         bytes memory _data,
871         bool safe
872     ) internal {
873         uint256 startTokenId = currentIndex;
874         require(to != address(0), 'ERC721A: mint to the zero address');
875         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
876 
877         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
878 
879         // Overflows are incredibly unrealistic.
880         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
881         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
882         unchecked {
883             _addressData[to].balance += uint128(quantity);
884             _addressData[to].numberMinted += uint128(quantity);
885 
886             _ownerships[startTokenId].addr = to;
887             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
888 
889             uint256 updatedIndex = startTokenId;
890 
891             for (uint256 i; i < quantity; i++) {
892                 emit Transfer(address(0), to, updatedIndex);
893                 if (safe) {
894                     require(
895                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
896                         'ERC721A: transfer to non ERC721Receiver implementer'
897                     );
898                 }
899 
900                 updatedIndex++;
901             }
902 
903             currentIndex = updatedIndex;
904         }
905 
906         _afterTokenTransfers(address(0), to, startTokenId, quantity);
907     }
908 
909     /**
910      * @dev Transfers `tokenId` from `from` to `to`.
911      *
912      * Requirements:
913      *
914      * - `to` cannot be the zero address.
915      * - `tokenId` token must be owned by `from`.
916      *
917      * Emits a {Transfer} event.
918      */
919     function _transfer(
920         address from,
921         address to,
922         uint256 tokenId
923     ) private {
924         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
925 
926         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
927             getApproved(tokenId) == _msgSender() ||
928             isApprovedForAll(prevOwnership.addr, _msgSender()));
929 
930         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
931 
932         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
933         require(to != address(0), 'ERC721A: transfer to the zero address');
934 
935         _beforeTokenTransfers(from, to, tokenId, 1);
936 
937         // Clear approvals from the previous owner
938         _approve(address(0), tokenId, prevOwnership.addr);
939 
940         // Underflow of the sender's balance is impossible because we check for
941         // ownership above and the recipient's balance can't realistically overflow.
942         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
943         unchecked {
944             _addressData[from].balance -= 1;
945             _addressData[to].balance += 1;
946 
947             _ownerships[tokenId].addr = to;
948             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
949 
950             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
951             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
952             uint256 nextTokenId = tokenId + 1;
953             if (_ownerships[nextTokenId].addr == address(0)) {
954                 if (_exists(nextTokenId)) {
955                     _ownerships[nextTokenId].addr = prevOwnership.addr;
956                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
957                 }
958             }
959         }
960 
961         emit Transfer(from, to, tokenId);
962         _afterTokenTransfers(from, to, tokenId, 1);
963     }
964 
965     /**
966      * @dev Approve `to` to operate on `tokenId`
967      *
968      * Emits a {Approval} event.
969      */
970     function _approve(
971         address to,
972         uint256 tokenId,
973         address owner
974     ) private {
975         _tokenApprovals[tokenId] = to;
976         emit Approval(owner, to, tokenId);
977     }
978 
979     /**
980      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
981      * The call is not executed if the target address is not a contract.
982      *
983      * @param from address representing the previous owner of the given token ID
984      * @param to target address that will receive the tokens
985      * @param tokenId uint256 ID of the token to be transferred
986      * @param _data bytes optional data to send along with the call
987      * @return bool whether the call correctly returned the expected magic value
988      */
989     function _checkOnERC721Received(
990         address from,
991         address to,
992         uint256 tokenId,
993         bytes memory _data
994     ) private returns (bool) {
995         if (to.isContract()) {
996             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
997                 return retval == IERC721Receiver(to).onERC721Received.selector;
998             } catch (bytes memory reason) {
999                 if (reason.length == 0) {
1000                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1001                 } else {
1002                     assembly {
1003                         revert(add(32, reason), mload(reason))
1004                     }
1005                 }
1006             }
1007         } else {
1008             return true;
1009         }
1010     }
1011 
1012     /**
1013      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1014      *
1015      * startTokenId - the first token id to be transferred
1016      * quantity - the amount to be transferred
1017      *
1018      * Calling conditions:
1019      *
1020      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1021      * transferred to `to`.
1022      * - When `from` is zero, `tokenId` will be minted for `to`.
1023      */
1024     function _beforeTokenTransfers(
1025         address from,
1026         address to,
1027         uint256 startTokenId,
1028         uint256 quantity
1029     ) internal virtual {}
1030 
1031     /**
1032      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1033      * minting.
1034      *
1035      * startTokenId - the first token id to be transferred
1036      * quantity - the amount to be transferred
1037      *
1038      * Calling conditions:
1039      *
1040      * - when `from` and `to` are both non-zero.
1041      * - `from` and `to` are never both zero.
1042      */
1043     function _afterTokenTransfers(
1044         address from,
1045         address to,
1046         uint256 startTokenId,
1047         uint256 quantity
1048     ) internal virtual {}
1049 }
1050 
1051 abstract contract ReentrancyGuard {
1052     // Booleans are more expensive than uint256 or any type that takes up a full
1053     // word because each write operation emits an extra SLOAD to first read the
1054     // slot's contents, replace the bits taken up by the boolean, and then write
1055     // back. This is the compiler's defense against contract upgrades and
1056     // pointer aliasing, and it cannot be disabled.
1057 
1058     // The values being non-zero value makes deployment a bit more expensive,
1059     // but in exchange the refund on every call to nonReentrant will be lower in
1060     // amount. Since refunds are capped to a percentage of the total
1061     // transaction's gas, it is best to keep them low in cases like this one, to
1062     // increase the likelihood of the full refund coming into effect.
1063     uint256 private constant _NOT_ENTERED = 1;
1064     uint256 private constant _ENTERED = 2;
1065 
1066     uint256 private _status;
1067 
1068     constructor() {
1069         _status = _NOT_ENTERED;
1070     }
1071 
1072     /**
1073      * @dev Prevents a contract from calling itself, directly or indirectly.
1074      * Calling a `nonReentrant` function from another `nonReentrant`
1075      * function is not supported. It is possible to prevent this from happening
1076      * by making the `nonReentrant` function external, and making it call a
1077      * `private` function that does the actual work.
1078      */
1079     modifier nonReentrant() {
1080         // On the first call to nonReentrant, _notEntered will be true
1081         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1082 
1083         // Any calls to nonReentrant after this point will fail
1084         _status = _ENTERED;
1085 
1086         _;
1087 
1088         // By storing the original value once again, a refund is triggered (see
1089         // https://eips.ethereum.org/EIPS/eip-2200)
1090         _status = _NOT_ENTERED;
1091     }
1092 }
1093 
1094 
1095 
1096 contract goblindiedieNFT is ERC721A, Ownable, ReentrancyGuard {
1097     using Strings for uint256;
1098     string public _partslink;
1099     bool public byebye = false;
1100     uint256 public goblins = 10000;
1101     uint256 public goblinbyebye = 1;
1102     mapping(address => uint256) public howmanygobblins;
1103 
1104     constructor() ERC721A("goblindiedie", "GOBLINDIE") {}
1105 
1106     function _baseURI() internal view virtual override returns (string memory) {
1107         return _partslink;
1108     }
1109 
1110     function makingobblin() external nonReentrant {
1111         uint256 totalgobnlinsss = totalSupply();
1112         require(byebye);
1113         require(totalgobnlinsss + goblinbyebye <= goblins);
1114         require(msg.sender == tx.origin);
1115         require(howmanygobblins[msg.sender] < goblinbyebye);
1116         _safeMint(msg.sender, goblinbyebye);
1117         howmanygobblins[msg.sender] += goblinbyebye;
1118     }
1119 
1120     function makegoblinnnfly(address lords, uint256 _goblins) public onlyOwner {
1121         uint256 totalgobnlinsss = totalSupply();
1122         require(totalgobnlinsss + _goblins <= goblins);
1123         _safeMint(lords, _goblins);
1124     }
1125 
1126     function makegoblngobyebye(bool _bye) external onlyOwner {
1127         byebye = _bye;
1128     }
1129 
1130     function spredgobblins(uint256 _byebye) external onlyOwner {
1131         goblinbyebye = _byebye;
1132     }
1133 
1134     function makegobblinhaveparts(string memory parts) external onlyOwner {
1135         _partslink = parts;
1136     }
1137 
1138     function sumthinboutfunds() public payable onlyOwner {
1139     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1140         require(success);
1141     }
1142 }