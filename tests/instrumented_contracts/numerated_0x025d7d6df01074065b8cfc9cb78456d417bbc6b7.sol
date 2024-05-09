1 // SPDX-License-Identifier: MIT
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
43 
44 /**
45  * @dev String operations.
46  */
47 library Strings {
48     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
49 
50     /**
51      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
52      */
53     function toString(uint256 value) internal pure returns (string memory) {
54         // Inspired by OraclizeAPI's implementation - MIT licence
55         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
56 
57         if (value == 0) {
58             return "0";
59         }
60         uint256 temp = value;
61         uint256 digits;
62         while (temp != 0) {
63             digits++;
64             temp /= 10;
65         }
66         bytes memory buffer = new bytes(digits);
67         while (value != 0) {
68             digits -= 1;
69             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
70             value /= 10;
71         }
72         return string(buffer);
73     }
74 
75     /**
76      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
77      */
78     function toHexString(uint256 value) internal pure returns (string memory) {
79         if (value == 0) {
80             return "0x00";
81         }
82         uint256 temp = value;
83         uint256 length = 0;
84         while (temp != 0) {
85             length++;
86             temp >>= 8;
87         }
88         return toHexString(value, length);
89     }
90 
91     /**
92      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
93      */
94     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
95         bytes memory buffer = new bytes(2 * length + 2);
96         buffer[0] = "0";
97         buffer[1] = "x";
98         for (uint256 i = 2 * length + 1; i > 1; --i) {
99             buffer[i] = _HEX_SYMBOLS[value & 0xf];
100             value >>= 4;
101         }
102         require(value == 0, "Strings: hex length insufficient");
103         return string(buffer);
104     }
105 }
106 
107 
108 /**
109  * @dev Provides information about the current execution context, including the
110  * sender of the transaction and its data. While these are generally available
111  * via msg.sender and msg.data, they should not be accessed in such a direct
112  * manner, since when dealing with meta-transactions the account sending and
113  * paying for execution may not be the actual sender (as far as an application
114  * is concerned).
115  *
116  * This contract is only required for intermediate, library-like contracts.
117  */
118 abstract contract Context {
119     function _msgSender() internal view virtual returns (address) {
120         return msg.sender;
121     }
122 
123     function _msgData() internal view virtual returns (bytes calldata) {
124         return msg.data;
125     }
126 }
127 
128 /**
129  * @dev Contract module which provides a basic access control mechanism, where
130  * there is an account (an owner) that can be granted exclusive access to
131  * specific functions.
132  *
133  * By default, the owner account will be the one that deploys the contract. This
134  * can later be changed with {transferOwnership}.
135  *
136  * This module is used through inheritance. It will make available the modifier
137  * `onlyOwner`, which can be applied to your functions to restrict their use to
138  * the owner.
139  */
140 abstract contract Ownable is Context {
141     address private _owner;
142 
143     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
144 
145     /**
146      * @dev Initializes the contract setting the deployer as the initial owner.
147      */
148     constructor() {
149         _transferOwnership(_msgSender());
150     }
151 
152     /**
153      * @dev Returns the address of the current owner.
154      */
155     function owner() public view virtual returns (address) {
156         return _owner;
157     }
158 
159     /**
160      * @dev Throws if called by any account other than the owner.
161      */
162     modifier onlyOwner() {
163         require(owner() == _msgSender(), "Ownable: caller is not the owner");
164         _;
165     }
166 
167     /**
168      * @dev Leaves the contract without owner. It will not be possible to call
169      * `onlyOwner` functions anymore. Can only be called by the current owner.
170      *
171      * NOTE: Renouncing ownership will leave the contract without an owner,
172      * thereby removing any functionality that is only available to the owner.
173      */
174     function renounceOwnership() public virtual onlyOwner {
175         _transferOwnership(address(0));
176     }
177 
178     /**
179      * @dev Transfers ownership of the contract to a new account (`newOwner`).
180      * Can only be called by the current owner.
181      */
182     function transferOwnership(address newOwner) public virtual onlyOwner {
183         require(newOwner != address(0), "Ownable: new owner is the zero address");
184         _transferOwnership(newOwner);
185     }
186 
187     /**
188      * @dev Transfers ownership of the contract to a new account (`newOwner`).
189      * Internal function without access restriction.
190      */
191     function _transferOwnership(address newOwner) internal virtual {
192         address oldOwner = _owner;
193         _owner = newOwner;
194         emit OwnershipTransferred(oldOwner, newOwner);
195     }
196 }
197 
198 
199 /**
200  * @dev Collection of functions related to the address type
201  */
202 library Address {
203     /**
204      * @dev Returns true if `account` is a contract.
205      *
206      * [IMPORTANT]
207      * ====
208      * It is unsafe to assume that an address for which this function returns
209      * false is an externally-owned account (EOA) and not a contract.
210      *
211      * Among others, `isContract` will return false for the following
212      * types of addresses:
213      *
214      *  - an externally-owned account
215      *  - a contract in construction
216      *  - an address where a contract will be created
217      *  - an address where a contract lived, but was destroyed
218      * ====
219      *
220      * [IMPORTANT]
221      * ====
222      * You shouldn't rely on `isContract` to protect against flash loan attacks!
223      *
224      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
225      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
226      * constructor.
227      * ====
228      */
229     function isContract(address account) internal view returns (bool) {
230         // This method relies on extcodesize/address.code.length, which returns 0
231         // for contracts in construction, since the code is only stored at the end
232         // of the constructor execution.
233 
234         return account.code.length > 0;
235     }
236 
237     /**
238      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
239      * `recipient`, forwarding all available gas and reverting on errors.
240      *
241      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
242      * of certain opcodes, possibly making contracts go over the 2300 gas limit
243      * imposed by `transfer`, making them unable to receive funds via
244      * `transfer`. {sendValue} removes this limitation.
245      *
246      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
247      *
248      * IMPORTANT: because control is transferred to `recipient`, care must be
249      * taken to not create reentrancy vulnerabilities. Consider using
250      * {ReentrancyGuard} or the
251      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
252      */
253     function sendValue(address payable recipient, uint256 amount) internal {
254         require(address(this).balance >= amount, "Address: insufficient balance");
255 
256         (bool success, ) = recipient.call{value: amount}("");
257         require(success, "Address: unable to send value, recipient may have reverted");
258     }
259 
260     /**
261      * @dev Performs a Solidity function call using a low level `call`. A
262      * plain `call` is an unsafe replacement for a function call: use this
263      * function instead.
264      *
265      * If `target` reverts with a revert reason, it is bubbled up by this
266      * function (like regular Solidity function calls).
267      *
268      * Returns the raw returned data. To convert to the expected return value,
269      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
270      *
271      * Requirements:
272      *
273      * - `target` must be a contract.
274      * - calling `target` with `data` must not revert.
275      *
276      * _Available since v3.1._
277      */
278     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
279         return functionCall(target, data, "Address: low-level call failed");
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
284      * `errorMessage` as a fallback revert reason when `target` reverts.
285      *
286      * _Available since v3.1._
287      */
288     function functionCall(
289         address target,
290         bytes memory data,
291         string memory errorMessage
292     ) internal returns (bytes memory) {
293         return functionCallWithValue(target, data, 0, errorMessage);
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
298      * but also transferring `value` wei to `target`.
299      *
300      * Requirements:
301      *
302      * - the calling contract must have an ETH balance of at least `value`.
303      * - the called Solidity function must be `payable`.
304      *
305      * _Available since v3.1._
306      */
307     function functionCallWithValue(
308         address target,
309         bytes memory data,
310         uint256 value
311     ) internal returns (bytes memory) {
312         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
317      * with `errorMessage` as a fallback revert reason when `target` reverts.
318      *
319      * _Available since v3.1._
320      */
321     function functionCallWithValue(
322         address target,
323         bytes memory data,
324         uint256 value,
325         string memory errorMessage
326     ) internal returns (bytes memory) {
327         require(address(this).balance >= value, "Address: insufficient balance for call");
328         require(isContract(target), "Address: call to non-contract");
329 
330         (bool success, bytes memory returndata) = target.call{value: value}(data);
331         return verifyCallResult(success, returndata, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but performing a static call.
337      *
338      * _Available since v3.3._
339      */
340     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
341         return functionStaticCall(target, data, "Address: low-level static call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
346      * but performing a static call.
347      *
348      * _Available since v3.3._
349      */
350     function functionStaticCall(
351         address target,
352         bytes memory data,
353         string memory errorMessage
354     ) internal view returns (bytes memory) {
355         require(isContract(target), "Address: static call to non-contract");
356 
357         (bool success, bytes memory returndata) = target.staticcall(data);
358         return verifyCallResult(success, returndata, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but performing a delegate call.
364      *
365      * _Available since v3.4._
366      */
367     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
368         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
373      * but performing a delegate call.
374      *
375      * _Available since v3.4._
376      */
377     function functionDelegateCall(
378         address target,
379         bytes memory data,
380         string memory errorMessage
381     ) internal returns (bytes memory) {
382         require(isContract(target), "Address: delegate call to non-contract");
383 
384         (bool success, bytes memory returndata) = target.delegatecall(data);
385         return verifyCallResult(success, returndata, errorMessage);
386     }
387 
388     /**
389      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
390      * revert reason using the provided one.
391      *
392      * _Available since v4.3._
393      */
394     function verifyCallResult(
395         bool success,
396         bytes memory returndata,
397         string memory errorMessage
398     ) internal pure returns (bytes memory) {
399         if (success) {
400             return returndata;
401         } else {
402             // Look for revert reason and bubble it up if present
403             if (returndata.length > 0) {
404                 // The easiest way to bubble the revert reason is using memory via assembly
405 
406                 assembly {
407                     let returndata_size := mload(returndata)
408                     revert(add(32, returndata), returndata_size)
409                 }
410             } else {
411                 revert(errorMessage);
412             }
413         }
414     }
415 }
416 
417 
418 /**
419  * @title ERC721 token receiver interface
420  * @dev Interface for any contract that wants to support safeTransfers
421  * from ERC721 asset contracts.
422  */
423 interface IERC721Receiver {
424     /**
425      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
426      * by `operator` from `from`, this function is called.
427      *
428      * It must return its Solidity selector to confirm the token transfer.
429      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
430      *
431      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
432      */
433     function onERC721Received(
434         address operator,
435         address from,
436         uint256 tokenId,
437         bytes calldata data
438     ) external returns (bytes4);
439 }
440 
441 
442 /**
443  * @dev Interface of the ERC165 standard, as defined in the
444  * https://eips.ethereum.org/EIPS/eip-165[EIP].
445  *
446  * Implementers can declare support of contract interfaces, which can then be
447  * queried by others ({ERC165Checker}).
448  *
449  * For an implementation, see {ERC165}.
450  */
451 interface IERC165 {
452     /**
453      * @dev Returns true if this contract implements the interface defined by
454      * `interfaceId`. See the corresponding
455      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
456      * to learn more about how these ids are created.
457      *
458      * This function call must use less than 30 000 gas.
459      */
460     function supportsInterface(bytes4 interfaceId) external view returns (bool);
461 }
462 
463 
464 /**
465  * @dev Implementation of the {IERC165} interface.
466  *
467  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
468  * for the additional interface id that will be supported. For example:
469  *
470  * ```solidity
471  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
472  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
473  * }
474  * ```
475  *
476  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
477  */
478 abstract contract ERC165 is IERC165 {
479     /**
480      * @dev See {IERC165-supportsInterface}.
481      */
482     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
483         return interfaceId == type(IERC165).interfaceId;
484     }
485 }
486 
487 
488 /**
489  * @dev Required interface of an ERC721 compliant contract.
490  */
491 interface IERC721 is IERC165 {
492     /**
493      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
494      */
495     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
496 
497     /**
498      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
499      */
500     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
501 
502     /**
503      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
504      */
505     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
506 
507     /**
508      * @dev Returns the number of tokens in ``owner``'s account.
509      */
510     function balanceOf(address owner) external view returns (uint256 balance);
511 
512     /**
513      * @dev Returns the owner of the `tokenId` token.
514      *
515      * Requirements:
516      *
517      * - `tokenId` must exist.
518      */
519     function ownerOf(uint256 tokenId) external view returns (address owner);
520 
521     /**
522      * @dev Safely transfers `tokenId` token from `from` to `to`.
523      *
524      * Requirements:
525      *
526      * - `from` cannot be the zero address.
527      * - `to` cannot be the zero address.
528      * - `tokenId` token must exist and be owned by `from`.
529      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
530      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
531      *
532      * Emits a {Transfer} event.
533      */
534     function safeTransferFrom(
535         address from,
536         address to,
537         uint256 tokenId,
538         bytes calldata data
539     ) external;
540 
541     /**
542      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
543      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
544      *
545      * Requirements:
546      *
547      * - `from` cannot be the zero address.
548      * - `to` cannot be the zero address.
549      * - `tokenId` token must exist and be owned by `from`.
550      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
551      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
552      *
553      * Emits a {Transfer} event.
554      */
555     function safeTransferFrom(
556         address from,
557         address to,
558         uint256 tokenId
559     ) external;
560 
561     /**
562      * @dev Transfers `tokenId` token from `from` to `to`.
563      *
564      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
565      *
566      * Requirements:
567      *
568      * - `from` cannot be the zero address.
569      * - `to` cannot be the zero address.
570      * - `tokenId` token must be owned by `from`.
571      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
572      *
573      * Emits a {Transfer} event.
574      */
575     function transferFrom(
576         address from,
577         address to,
578         uint256 tokenId
579     ) external;
580 
581     /**
582      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
583      * The approval is cleared when the token is transferred.
584      *
585      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
586      *
587      * Requirements:
588      *
589      * - The caller must own the token or be an approved operator.
590      * - `tokenId` must exist.
591      *
592      * Emits an {Approval} event.
593      */
594     function approve(address to, uint256 tokenId) external;
595 
596     /**
597      * @dev Approve or remove `operator` as an operator for the caller.
598      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
599      *
600      * Requirements:
601      *
602      * - The `operator` cannot be the caller.
603      *
604      * Emits an {ApprovalForAll} event.
605      */
606     function setApprovalForAll(address operator, bool _approved) external;
607 
608     /**
609      * @dev Returns the account approved for `tokenId` token.
610      *
611      * Requirements:
612      *
613      * - `tokenId` must exist.
614      */
615     function getApproved(uint256 tokenId) external view returns (address operator);
616 
617     /**
618      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
619      *
620      * See {setApprovalForAll}
621      */
622     function isApprovedForAll(address owner, address operator) external view returns (bool);
623 }
624 
625 
626 
627 /**
628  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
629  * @dev See https://eips.ethereum.org/EIPS/eip-721
630  */
631 interface IERC721Enumerable is IERC721 {
632     /**
633      * @dev Returns the total amount of tokens stored by the contract.
634      */
635     function totalSupply() external view returns (uint256);
636 
637     /**
638      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
639      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
640      */
641     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
642 
643     /**
644      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
645      * Use along with {totalSupply} to enumerate all tokens.
646      */
647     function tokenByIndex(uint256 index) external view returns (uint256);
648 }
649 
650 
651 /**
652  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
653  * @dev See https://eips.ethereum.org/EIPS/eip-721
654  */
655 interface IERC721Metadata is IERC721 {
656     /**
657      * @dev Returns the token collection name.
658      */
659     function name() external view returns (string memory);
660 
661     /**
662      * @dev Returns the token collection symbol.
663      */
664     function symbol() external view returns (string memory);
665 
666     /**
667      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
668      */
669     function tokenURI(uint256 tokenId) external view returns (string memory);
670 }
671 
672 /**
673  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
674  * the Metadata extension, but not including the Enumerable extension, which is available separately as
675  * {ERC721Enumerable}.
676  */
677 contract ERC721 is Ownable , ERC165, IERC721, IERC721Metadata {
678     using Address for address;
679     using Strings for uint256;
680 
681     // Token name
682     string private _name;
683 
684     // Token symbol
685     string private _symbol;
686 
687     // Mapping from token ID to owner address
688     mapping(uint256 => address) private _owners;
689 
690     // Mapping owner address to token count
691     mapping(address => uint256) private _balances;
692 
693     // Mapping from token ID to approved address
694     mapping(uint256 => address) private _tokenApprovals;
695 
696     // Mapping from owner to operator approvals
697     mapping(address => mapping(address => bool)) private _operatorApprovals;
698 
699     /**
700      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
701      */
702     constructor(string memory name_, string memory symbol_) {
703         _name = name_;
704         _symbol = symbol_;
705     }
706 
707     /**
708      * @dev See {IERC165-supportsInterface}.
709      */
710     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
711         return
712             interfaceId == type(IERC721).interfaceId ||
713             interfaceId == type(IERC721Metadata).interfaceId ||
714             super.supportsInterface(interfaceId);
715     }
716 
717     /**
718      * @dev See {IERC721-balanceOf}.
719      */
720     function balanceOf(address owner) public view virtual override returns (uint256) {
721         require(owner != address(0), "ERC721: balance query for the zero address");
722         return _balances[owner];
723     }
724 
725     /**
726      * @dev See {IERC721-ownerOf}.
727      */
728     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
729         address owner = _owners[tokenId];
730         require(owner != address(0), "ERC721: owner query for nonexistent token");
731         return owner;
732     }
733 
734     /**
735      * @dev See {IERC721Metadata-name}.
736      */
737     function name() public view virtual override returns (string memory) {
738         return _name;
739     }
740 
741     /**
742      * @dev See {IERC721Metadata-symbol}.
743      */
744     function symbol() public view virtual override returns (string memory) {
745         return _symbol;
746     }
747 
748     /**
749      * @dev See {IERC721Metadata-tokenURI}.
750      */
751     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
752         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
753 
754         string memory baseURI = _baseURI();
755         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
756     }
757 
758     /**
759      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
760      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
761      * by default, can be overridden in child contracts.
762      */
763     function _baseURI() internal view virtual returns (string memory) {
764         return "";
765     }
766 
767     /**
768      * @dev See {IERC721-approve}.
769      */
770     function approve(address to, uint256 tokenId) public virtual override {
771         address owner = ERC721.ownerOf(tokenId);
772         require(to != owner, "ERC721: approval to current owner");
773 
774         require(
775             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
776             "ERC721: approve caller is not owner nor approved for all"
777         );
778 
779         _approve(to, tokenId);
780     }
781 
782     /**
783      * @dev See {IERC721-getApproved}.
784      */
785     function getApproved(uint256 tokenId) public view virtual override returns (address) {
786         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
787 
788         return _tokenApprovals[tokenId];
789     }
790 
791     /**
792      * @dev See {IERC721-setApprovalForAll}.
793      */
794     function setApprovalForAll(address operator, bool approved) public virtual override {
795         _setApprovalForAll(_msgSender(), operator, approved);
796     }
797 
798     /**
799      * @dev See {IERC721-isApprovedForAll}.
800      */
801     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
802         return _operatorApprovals[owner][operator];
803     }
804 
805     /**
806      * @dev See {IERC721-transferFrom}.
807      */
808     function transferFrom(
809         address from,
810         address to,
811         uint256 tokenId
812     ) public virtual override {
813         //solhint-disable-next-line max-line-length
814         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
815 
816         _transfer(from, to, tokenId);
817     }
818 
819     /**
820      * @dev See {IERC721-safeTransferFrom}.
821      */
822     function safeTransferFrom(
823         address from,
824         address to,
825         uint256 tokenId
826     ) public virtual override {
827         safeTransferFrom(from, to, tokenId, "");
828     }
829 
830     /**
831      * @dev See {IERC721-safeTransferFrom}.
832      */
833     function safeTransferFrom(
834         address from,
835         address to,
836         uint256 tokenId,
837         bytes memory _data
838     ) public virtual override {
839         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
840         _safeTransfer(from, to, tokenId, _data);
841     }
842 
843     /**
844      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
845      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
846      *
847      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
848      *
849      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
850      * implement alternative mechanisms to perform token transfer, such as signature-based.
851      *
852      * Requirements:
853      *
854      * - `from` cannot be the zero address.
855      * - `to` cannot be the zero address.
856      * - `tokenId` token must exist and be owned by `from`.
857      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
858      *
859      * Emits a {Transfer} event.
860      */
861     function _safeTransfer(
862         address from,
863         address to,
864         uint256 tokenId,
865         bytes memory _data
866     ) internal virtual {
867         _transfer(from, to, tokenId);
868         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
869     }
870 
871     /**
872      * @dev Returns whether `tokenId` exists.
873      *
874      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
875      *
876      * Tokens start existing when they are minted (`_mint`),
877      * and stop existing when they are burned (`_burn`).
878      */
879     function _exists(uint256 tokenId) internal view virtual returns (bool) {
880         return _owners[tokenId] != address(0);
881     }
882 
883     /**
884      * @dev Returns whether `spender` is allowed to manage `tokenId`.
885      *
886      * Requirements:
887      *
888      * - `tokenId` must exist.
889      */
890     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
891         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
892         address owner = ERC721.ownerOf(tokenId);
893         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
894     }
895 
896     /**
897      * @dev Safely mints `tokenId` and transfers it to `to`.
898      *
899      * Requirements:
900      *
901      * - `tokenId` must not exist.
902      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
903      *
904      * Emits a {Transfer} event.
905      */
906     function _safeMint(address to, uint256 tokenId) internal virtual {
907         _safeMint(to, tokenId, "");
908     }
909 
910     /**
911      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
912      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
913      */
914     function _safeMint(
915         address to,
916         uint256 tokenId,
917         bytes memory _data
918     ) internal virtual {
919         _mint(to, tokenId);
920         require(
921             _checkOnERC721Received(address(0), to, tokenId, _data),
922             "ERC721: transfer to non ERC721Receiver implementer"
923         );
924     }
925 
926     /**
927      * @dev Mints `tokenId` and transfers it to `to`.
928      *
929      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
930      *
931      * Requirements:
932      *
933      * - `tokenId` must not exist.
934      * - `to` cannot be the zero address.
935      *
936      * Emits a {Transfer} event.
937      */
938     function _mint(address to, uint256 tokenId) internal virtual {
939         require(to != address(0), "ERC721: mint to the zero address");
940         require(!_exists(tokenId), "ERC721: token already minted");
941 
942         _beforeTokenTransfer(address(0), to, tokenId);
943 
944         _balances[to] += 1;
945         _owners[tokenId] = to;
946 
947         emit Transfer(address(0), to, tokenId);
948 
949         _afterTokenTransfer(address(0), to, tokenId);
950     }
951 
952     /**
953      * @dev Destroys `tokenId`.
954      * The approval is cleared when the token is burned.
955      *
956      * Requirements:
957      *
958      * - `tokenId` must exist.
959      *
960      * Emits a {Transfer} event.
961      */
962     function _burn(uint256 tokenId) internal virtual {
963         address owner = ERC721.ownerOf(tokenId);
964 
965         _beforeTokenTransfer(owner, address(0), tokenId);
966 
967         // Clear approvals
968         _approve(address(0), tokenId);
969 
970         _balances[owner] -= 1;
971         delete _owners[tokenId];
972 
973         emit Transfer(owner, address(0), tokenId);
974 
975         _afterTokenTransfer(owner, address(0), tokenId);
976     }
977 
978     /**
979      * @dev Transfers `tokenId` from `from` to `to`.
980      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
981      *
982      * Requirements:
983      *
984      * - `to` cannot be the zero address.
985      * - `tokenId` token must be owned by `from`.
986      *
987      * Emits a {Transfer} event.
988      */
989     function _transfer(
990         address from,
991         address to,
992         uint256 tokenId
993     ) internal virtual {
994         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
995         require(to != address(0), "ERC721: transfer to the zero address");
996 
997         _beforeTokenTransfer(from, to, tokenId);
998 
999         // Clear approvals from the previous owner
1000         _approve(address(0), tokenId);
1001 
1002         _balances[from] -= 1;
1003         _balances[to] += 1;
1004         _owners[tokenId] = to;
1005 
1006         emit Transfer(from, to, tokenId);
1007 
1008         _afterTokenTransfer(from, to, tokenId);
1009     }
1010 
1011     /**
1012      * @dev Approve `to` to operate on `tokenId`
1013      *
1014      * Emits a {Approval} event.
1015      */
1016     function _approve(address to, uint256 tokenId) internal virtual {
1017         _tokenApprovals[tokenId] = to;
1018         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1019     }
1020 
1021     /**
1022      * @dev Approve `operator` to operate on all of `owner` tokens
1023      *
1024      * Emits a {ApprovalForAll} event.
1025      */
1026     function _setApprovalForAll(
1027         address owner,
1028         address operator,
1029         bool approved
1030     ) internal virtual {
1031         require(owner != operator, "ERC721: approve to caller");
1032         _operatorApprovals[owner][operator] = approved;
1033         emit ApprovalForAll(owner, operator, approved);
1034     }
1035 
1036     /**
1037      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1038      * The call is not executed if the target address is not a contract.
1039      *
1040      * @param from address representing the previous owner of the given token ID
1041      * @param to target address that will receive the tokens
1042      * @param tokenId uint256 ID of the token to be transferred
1043      * @param _data bytes optional data to send along with the call
1044      * @return bool whether the call correctly returned the expected magic value
1045      */
1046     function _checkOnERC721Received(
1047         address from,
1048         address to,
1049         uint256 tokenId,
1050         bytes memory _data
1051     ) private returns (bool) {
1052         if (to.isContract()) {
1053             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1054                 return retval == IERC721Receiver.onERC721Received.selector;
1055             } catch (bytes memory reason) {
1056                 if (reason.length == 0) {
1057                     revert("ERC721: transfer to non ERC721Receiver implementer");
1058                 } else {
1059                     assembly {
1060                         revert(add(32, reason), mload(reason))
1061                     }
1062                 }
1063             }
1064         } else {
1065             return true;
1066         }
1067     }
1068 
1069     /**
1070      * @dev Hook that is called before any token transfer. This includes minting
1071      * and burning.
1072      *
1073      * Calling conditions:
1074      *
1075      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1076      * transferred to `to`.
1077      * - When `from` is zero, `tokenId` will be minted for `to`.
1078      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1079      * - `from` and `to` are never both zero.
1080      *
1081      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1082      */
1083     function _beforeTokenTransfer(
1084         address from,
1085         address to,
1086         uint256 tokenId
1087     ) internal virtual {}
1088 
1089     /**
1090      * @dev Hook that is called after any transfer of tokens. This includes
1091      * minting and burning.
1092      *
1093      * Calling conditions:
1094      *
1095      * - when `from` and `to` are both non-zero.
1096      * - `from` and `to` are never both zero.
1097      *
1098      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1099      */
1100     function _afterTokenTransfer(
1101         address from,
1102         address to,
1103         uint256 tokenId
1104     ) internal virtual {}
1105 }
1106 
1107 
1108 /**
1109  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1110  * enumerability of all the token ids in the contract as well as all token ids owned by each
1111  * account.
1112  */
1113 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1114     // Mapping from owner to list of owned token IDs
1115     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1116 
1117     // Mapping from token ID to index of the owner tokens list
1118     mapping(uint256 => uint256) private _ownedTokensIndex;
1119 
1120     // Array with all token ids, used for enumeration
1121     uint256[] private _allTokens;
1122 
1123     // Mapping from token id to position in the allTokens array
1124     mapping(uint256 => uint256) private _allTokensIndex;
1125 
1126     /**
1127      * @dev See {IERC165-supportsInterface}.
1128      */
1129     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1130         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1131     }
1132 
1133     /**
1134      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1135      */
1136     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1137         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1138         return _ownedTokens[owner][index];
1139     }
1140 
1141     /**
1142      * @dev See {IERC721Enumerable-totalSupply}.
1143      */
1144     function totalSupply() public view virtual override returns (uint256) {
1145         return _allTokens.length;
1146     }
1147 
1148     /**
1149      * @dev See {IERC721Enumerable-tokenByIndex}.
1150      */
1151     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1152         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1153         return _allTokens[index];
1154     }
1155 
1156     /**
1157      * @dev Hook that is called before any token transfer. This includes minting
1158      * and burning.
1159      *
1160      * Calling conditions:
1161      *
1162      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1163      * transferred to `to`.
1164      * - When `from` is zero, `tokenId` will be minted for `to`.
1165      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1166      * - `from` cannot be the zero address.
1167      * - `to` cannot be the zero address.
1168      *
1169      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1170      */
1171     function _beforeTokenTransfer(
1172         address from,
1173         address to,
1174         uint256 tokenId
1175     ) internal virtual override {
1176         super._beforeTokenTransfer(from, to, tokenId);
1177 
1178         if (from == address(0)) {
1179             _addTokenToAllTokensEnumeration(tokenId);
1180         } else if (from != to) {
1181             _removeTokenFromOwnerEnumeration(from, tokenId);
1182         }
1183         if (to == address(0)) {
1184             _removeTokenFromAllTokensEnumeration(tokenId);
1185         } else if (to != from) {
1186             _addTokenToOwnerEnumeration(to, tokenId);
1187         }
1188     }
1189 
1190     /**
1191      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1192      * @param to address representing the new owner of the given token ID
1193      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1194      */
1195     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1196         uint256 length = ERC721.balanceOf(to);
1197         _ownedTokens[to][length] = tokenId;
1198         _ownedTokensIndex[tokenId] = length;
1199     }
1200 
1201     /**
1202      * @dev Private function to add a token to this extension's token tracking data structures.
1203      * @param tokenId uint256 ID of the token to be added to the tokens list
1204      */
1205     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1206         _allTokensIndex[tokenId] = _allTokens.length;
1207         _allTokens.push(tokenId);
1208     }
1209 
1210     /**
1211      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1212      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1213      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1214      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1215      * @param from address representing the previous owner of the given token ID
1216      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1217      */
1218     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1219         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1220         // then delete the last slot (swap and pop).
1221 
1222         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1223         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1224 
1225         // When the token to delete is the last token, the swap operation is unnecessary
1226         if (tokenIndex != lastTokenIndex) {
1227             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1228 
1229             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1230             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1231         }
1232 
1233         // This also deletes the contents at the last position of the array
1234         delete _ownedTokensIndex[tokenId];
1235         delete _ownedTokens[from][lastTokenIndex];
1236     }
1237 
1238     /**
1239      * @dev Private function to remove a token from this extension's token tracking data structures.
1240      * This has O(1) time complexity, but alters the order of the _allTokens array.
1241      * @param tokenId uint256 ID of the token to be removed from the tokens list
1242      */
1243     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1244         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1245         // then delete the last slot (swap and pop).
1246 
1247         uint256 lastTokenIndex = _allTokens.length - 1;
1248         uint256 tokenIndex = _allTokensIndex[tokenId];
1249 
1250         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1251         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1252         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1253         uint256 lastTokenId = _allTokens[lastTokenIndex];
1254 
1255         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1256         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1257 
1258         // This also deletes the contents at the last position of the array
1259         delete _allTokensIndex[tokenId];
1260         _allTokens.pop();
1261     }
1262 }
1263 
1264 
1265 /**
1266  * @dev ERC721 token with storage based token URI management.
1267  */
1268 abstract contract ERC721URIStorage is ERC721Enumerable{
1269     using Strings for uint256;
1270 
1271     bool public isStart;
1272 
1273     string openedUrl;
1274 
1275     uint lastOpenTokenId;
1276 
1277     // Optional mapping for token URIs
1278     mapping(uint256 => string) private _tokenURIs;
1279 
1280 
1281     function start() external onlyOwner {
1282        isStart = !isStart;
1283     }
1284 
1285 
1286     function open(string memory url, uint lastTokenId) external onlyOwner {
1287         if(0 == bytes(openedUrl).length){
1288             openedUrl = url;
1289         }
1290 
1291         require(0 < lastTokenId && lastOpenTokenId < lastTokenId && lastTokenId <= totalSupply(), 'Invalid tokenid');
1292 
1293         lastOpenTokenId = lastTokenId;
1294     }
1295 
1296     /**
1297      * @dev See {IERC721Metadata-tokenURI}.
1298      */
1299     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1300         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1301 
1302         if (bytes(openedUrl).length > 0 && tokenId <= lastOpenTokenId) {
1303             return string(abi.encodePacked(openedUrl, '/', tokenId.toString()));
1304         }
1305 
1306         return _baseURI();
1307     }
1308 
1309     /**
1310      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1311      *
1312      * Requirements:
1313      *
1314      * - `tokenId` must exist.
1315      */
1316     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1317         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1318         _tokenURIs[tokenId] = _tokenURI;
1319     }
1320 
1321     /**
1322      * @dev Destroys `tokenId`.
1323      * The approval is cleared when the token is burned.
1324      *
1325      * Requirements:
1326      *
1327      * - `tokenId` must exist.
1328      *
1329      * Emits a {Transfer} event.
1330      */
1331     function _burn(uint256 tokenId) internal virtual override {
1332         super._burn(tokenId);
1333 
1334         if (bytes(_tokenURIs[tokenId]).length != 0) {
1335             delete _tokenURIs[tokenId];
1336         }
1337     }
1338 }
1339 
1340 
1341 contract YGMint is ERC721URIStorage{
1342     using Counters for Counters.Counter;
1343 
1344     Counters.Counter private _tokenIdCounter = Counters.Counter(1);
1345 
1346     uint mintTotal = 6666;
1347 
1348     uint teamMax = 666;
1349     uint teamMint = 0;
1350 
1351     uint mintMax = 12;
1352     uint mintFee = 10;
1353 
1354     uint mintEveryAmount = 12 * 10 ** 17;
1355     uint firstLeave = 1 * 10 ** 17;
1356     uint secondtLeave = 5 * 10 ** 16;
1357 
1358 
1359     mapping(address => bool) public isMint;
1360 
1361     mapping(address => address payable) recommender;
1362 
1363 
1364 
1365     constructor() ERC721("YGM", "YGM") {
1366 
1367     }
1368 
1369     function _baseURI() internal pure override returns (string memory) {
1370         return "ipfs://QmPAcZGzXzcrCfs399nASK2SJGEByjZr3atBpGML4vzfj1";
1371     }
1372 
1373 
1374     function getAmount(uint mintCount) external view returns(uint){
1375         require(totalSupply() + mintCount <= mintTotal, 'Maximum mint quantity exceeded');
1376         address minter = _msgSender();
1377         uint balanceMiner = balanceOf(minter);
1378         uint balanceWill = balanceMiner + mintCount;
1379         require(0 < mintCount && balanceWill <= mintMax, 'Invalid quantity');
1380         if(balanceWill > mintFee){
1381             if(balanceMiner < mintFee){
1382                 uint feeCount = mintFee - balanceMiner;
1383                 return feeCount * mintEveryAmount;
1384             }else{
1385                 return 0;
1386             }
1387         }else{
1388             return mintCount * mintEveryAmount;
1389         }
1390     }
1391 
1392 
1393 
1394     function safeMint(address payable _recommender, uint mintCount) external payable checkRecommender(_recommender){
1395 
1396         require(isStart, 'Not started');
1397 
1398         require(totalSupply() + mintCount <= mintTotal, 'Maximum mint quantity exceeded');
1399 
1400         address  minter = _msgSender();
1401         uint balanceMiner = balanceOf(minter);
1402         uint balanceWill = balanceMiner + mintCount;
1403         require(0 < mintCount && balanceWill <= mintMax, 'Invalid quantity');
1404 
1405 
1406         if(balanceWill > mintFee){
1407             if(balanceMiner < mintFee){
1408                 uint feeCount = mintFee - balanceMiner;
1409                 uint mintAmount = feeCount * mintEveryAmount;
1410                 require(mintAmount <= msg.value, 'Insufficient payment quantity');
1411                 if(mintAmount < msg.value){
1412                     payable(minter).transfer(msg.value - mintAmount);
1413                 }
1414                 rewardRecommender(minter, feeCount);
1415             }
1416         }else{
1417             uint mintAmount = mintCount * mintEveryAmount;
1418             require(mintAmount <= msg.value, 'Insufficient payment quantity');
1419             if(mintAmount < msg.value){
1420                 payable(minter).transfer(msg.value - mintAmount);
1421             }
1422             rewardRecommender(minter, mintCount);
1423         }
1424 
1425 
1426         for(uint i = 0; i < mintCount; i++){
1427             uint256 tokenId = _tokenIdCounter.current();
1428             _tokenIdCounter.increment();
1429             _safeMint(minter, tokenId);
1430         }
1431 
1432         if(!isMint[minter]){
1433             isMint[minter] = true;
1434         }
1435 
1436     }
1437 
1438 
1439 
1440 
1441 
1442     function mint(address to, uint count) external onlyOwner {
1443 
1444         require(teamMint < teamMax, 'Mint end');
1445 
1446         for(uint i = 0; i < count; i++){
1447             uint256 tokenId = _tokenIdCounter.current();
1448             _tokenIdCounter.increment();
1449             _safeMint(to, tokenId);
1450             teamMint += 1;
1451         }
1452 
1453         if(!isMint[to]){
1454             isMint[to] = true;
1455         }
1456     }
1457 
1458 
1459     function withdrawal(address payable to, uint amount) external onlyOwner {
1460         require(address(0) != to, "To can not be zero");
1461         to.transfer(amount);
1462     }
1463 
1464 
1465     function rewardRecommender(address minter, uint count) private {
1466         address zero = address(0);
1467 
1468         address payable firstRecommender = recommender[minter];
1469         if(zero != firstRecommender && isMint[firstRecommender]){
1470             firstRecommender.transfer(firstLeave * count);
1471         }
1472 
1473 
1474         address payable secondRecommender = recommender[firstRecommender];
1475         if(zero != secondRecommender && isMint[secondRecommender]){
1476             secondRecommender.transfer(secondtLeave * count);
1477         }
1478     }
1479 
1480 
1481     modifier checkRecommender(address payable _recommender){
1482 
1483         if(recommender[msg.sender] == address(0)){
1484             require(address(0) != _recommender, "Recommender can not be zero");
1485             require(msg.sender != _recommender, "Recommender can not to be same");
1486             require(isMint[_recommender], "Recommender no mint");
1487             recommender[msg.sender] = _recommender;
1488         }
1489         
1490         _;
1491     }
1492 
1493 }