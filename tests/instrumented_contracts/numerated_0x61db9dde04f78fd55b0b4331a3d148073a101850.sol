1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
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
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev Contract module which provides a basic access control mechanism, where
29  * there is an account (an owner) that can be granted exclusive access to
30  * specific functions.
31  *
32  * By default, the owner account will be the one that deploys the contract. This
33  * can later be changed with {transferOwnership}.
34  *
35  * This module is used through inheritance. It will make available the modifier
36  * `onlyOwner`, which can be applied to your functions to restrict their use to
37  * the owner.
38  */
39 abstract contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor() {
48         _setOwner(_msgSender());
49     }
50 
51     /**
52      * @dev Returns the address of the current owner.
53      */
54     function owner() public view virtual returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(owner() == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     /**
67      * @dev Leaves the contract without owner. It will not be possible to call
68      * `onlyOwner` functions anymore. Can only be called by the current owner.
69      *
70      * NOTE: Renouncing ownership will leave the contract without an owner,
71      * thereby removing any functionality that is only available to the owner.
72      */
73     function renounceOwnership() public virtual onlyOwner {
74         _setOwner(address(0));
75     }
76 
77     /**
78      * @dev Transfers ownership of the contract to a new account (`newOwner`).
79      * Can only be called by the current owner.
80      */
81     function transferOwnership(address newOwner) public virtual onlyOwner {
82         require(newOwner != address(0), "Ownable: new owner is the zero address");
83         _setOwner(newOwner);
84     }
85 
86     function _setOwner(address newOwner) private {
87         address oldOwner = _owner;
88         _owner = newOwner;
89         emit OwnershipTransferred(oldOwner, newOwner);
90     }
91 }
92 
93 pragma solidity ^0.8.0;
94 
95 /**
96  * @title PaymentSplitter
97  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
98  * that the Ether will be split in this way, since it is handled transparently by the contract.
99  *
100  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
101  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
102  * an amount proportional to the percentage of total shares they were assigned.
103  *
104  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
105  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
106  * function.
107  */
108 contract PaymentSplitter is Context {
109     event PayeeAdded(address account, uint256 shares);
110     event PaymentReleased(address to, uint256 amount);
111     event PaymentReceived(address from, uint256 amount);
112 
113     uint256 private _totalShares;
114     uint256 private _totalReleased;
115 
116     mapping(address => uint256) private _shares;
117     mapping(address => uint256) private _released;
118     address[] private _payees;
119 
120     /**
121      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
122      * the matching position in the `shares` array.
123      *
124      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
125      * duplicates in `payees`.
126      */
127     constructor(address[] memory payees, uint256[] memory shares_) payable {
128         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
129         require(payees.length > 0, "PaymentSplitter: no payees");
130 
131         for (uint256 i = 0; i < payees.length; i++) {
132             _addPayee(payees[i], shares_[i]);
133         }
134     }
135 
136     /**
137      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
138      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
139      * reliability of the events, and not the actual splitting of Ether.
140      *
141      * To learn more about this see the Solidity documentation for
142      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
143      * functions].
144      */
145     receive() external payable virtual {
146         emit PaymentReceived(_msgSender(), msg.value);
147     }
148 
149     /**
150      * @dev Getter for the total shares held by payees.
151      */
152     function totalShares() public view returns (uint256) {
153         return _totalShares;
154     }
155 
156     /**
157      * @dev Getter for the total amount of Ether already released.
158      */
159     function totalReleased() public view returns (uint256) {
160         return _totalReleased;
161     }
162 
163     /**
164      * @dev Getter for the amount of shares held by an account.
165      */
166     function shares(address account) public view returns (uint256) {
167         return _shares[account];
168     }
169 
170     /**
171      * @dev Getter for the amount of Ether already released to a payee.
172      */
173     function released(address account) public view returns (uint256) {
174         return _released[account];
175     }
176 
177     /**
178      * @dev Getter for the address of the payee number `index`.
179      */
180     function payee(uint256 index) public view returns (address) {
181         return _payees[index];
182     }
183 
184     /**
185      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
186      * total shares and their previous withdrawals.
187      */
188     function release(address payable account) public virtual {
189         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
190 
191         uint256 totalReceived = address(this).balance + _totalReleased;
192         uint256 payment = (totalReceived * _shares[account]) / _totalShares - _released[account];
193 
194         require(payment != 0, "PaymentSplitter: account is not due payment");
195 
196         _released[account] = _released[account] + payment;
197         _totalReleased = _totalReleased + payment;
198 
199         Address.sendValue(account, payment);
200         emit PaymentReleased(account, payment);
201     }
202 
203     /**
204      * @dev Add a new payee to the contract.
205      * @param account The address of the payee to add.
206      * @param shares_ The number of shares owned by the payee.
207      */
208     function _addPayee(address account, uint256 shares_) private {
209         require(account != address(0), "PaymentSplitter: account is the zero address");
210         require(shares_ > 0, "PaymentSplitter: shares are 0");
211         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
212 
213         _payees.push(account);
214         _shares[account] = shares_;
215         _totalShares = _totalShares + shares_;
216         emit PayeeAdded(account, shares_);
217     }
218 }
219 
220 pragma solidity ^0.8.0;
221 
222 /**
223  * @dev Interface of the ERC165 standard, as defined in the
224  * https://eips.ethereum.org/EIPS/eip-165[EIP].
225  *
226  * Implementers can declare support of contract interfaces, which can then be
227  * queried by others ({ERC165Checker}).
228  *
229  * For an implementation, see {ERC165}.
230  */
231 interface IERC165 {
232     /**
233      * @dev Returns true if this contract implements the interface defined by
234      * `interfaceId`. See the corresponding
235      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
236      * to learn more about how these ids are created.
237      *
238      * This function call must use less than 30 000 gas.
239      */
240     function supportsInterface(bytes4 interfaceId) external view returns (bool);
241 }
242 
243 pragma solidity ^0.8.0;
244 
245 /**
246  * @dev Required interface of an ERC721 compliant contract.
247  */
248 interface IERC721 is IERC165 {
249     /**
250      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
251      */
252     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
253 
254     /**
255      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
256      */
257     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
258 
259     /**
260      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
261      */
262     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
263 
264     /**
265      * @dev Returns the number of tokens in ``owner``'s account.
266      */
267     function balanceOf(address owner) external view returns (uint256 balance);
268 
269     /**
270      * @dev Returns the owner of the `tokenId` token.
271      *
272      * Requirements:
273      *
274      * - `tokenId` must exist.
275      */
276     function ownerOf(uint256 tokenId) external view returns (address owner);
277 
278     /**
279      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
280      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
281      *
282      * Requirements:
283      *
284      * - `from` cannot be the zero address.
285      * - `to` cannot be the zero address.
286      * - `tokenId` token must exist and be owned by `from`.
287      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
288      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
289      *
290      * Emits a {Transfer} event.
291      */
292     function safeTransferFrom(
293         address from,
294         address to,
295         uint256 tokenId
296     ) external;
297 
298     /**
299      * @dev Transfers `tokenId` token from `from` to `to`.
300      *
301      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
302      *
303      * Requirements:
304      *
305      * - `from` cannot be the zero address.
306      * - `to` cannot be the zero address.
307      * - `tokenId` token must be owned by `from`.
308      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
309      *
310      * Emits a {Transfer} event.
311      */
312     function transferFrom(
313         address from,
314         address to,
315         uint256 tokenId
316     ) external;
317 
318     /**
319      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
320      * The approval is cleared when the token is transferred.
321      *
322      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
323      *
324      * Requirements:
325      *
326      * - The caller must own the token or be an approved operator.
327      * - `tokenId` must exist.
328      *
329      * Emits an {Approval} event.
330      */
331     function approve(address to, uint256 tokenId) external;
332 
333     /**
334      * @dev Returns the account approved for `tokenId` token.
335      *
336      * Requirements:
337      *
338      * - `tokenId` must exist.
339      */
340     function getApproved(uint256 tokenId) external view returns (address operator);
341 
342     /**
343      * @dev Approve or remove `operator` as an operator for the caller.
344      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
345      *
346      * Requirements:
347      *
348      * - The `operator` cannot be the caller.
349      *
350      * Emits an {ApprovalForAll} event.
351      */
352     function setApprovalForAll(address operator, bool _approved) external;
353 
354     /**
355      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
356      *
357      * See {setApprovalForAll}
358      */
359     function isApprovedForAll(address owner, address operator) external view returns (bool);
360 
361     /**
362      * @dev Safely transfers `tokenId` token from `from` to `to`.
363      *
364      * Requirements:
365      *
366      * - `from` cannot be the zero address.
367      * - `to` cannot be the zero address.
368      * - `tokenId` token must exist and be owned by `from`.
369      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
370      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
371      *
372      * Emits a {Transfer} event.
373      */
374     function safeTransferFrom(
375         address from,
376         address to,
377         uint256 tokenId,
378         bytes calldata data
379     ) external;
380 }
381 
382 pragma solidity ^0.8.0;
383 
384 /**
385  * @title ERC721 token receiver interface
386  * @dev Interface for any contract that wants to support safeTransfers
387  * from ERC721 asset contracts.
388  */
389 interface IERC721Receiver {
390     /**
391      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
392      * by `operator` from `from`, this function is called.
393      *
394      * It must return its Solidity selector to confirm the token transfer.
395      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
396      *
397      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
398      */
399     function onERC721Received(
400         address operator,
401         address from,
402         uint256 tokenId,
403         bytes calldata data
404     ) external returns (bytes4);
405 }
406 
407 pragma solidity ^0.8.0;
408 
409 /**
410  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
411  * @dev See https://eips.ethereum.org/EIPS/eip-721
412  */
413 interface IERC721Enumerable is IERC721 {
414     /**
415      * @dev Returns the total amount of tokens stored by the contract.
416      */
417     function totalSupply() external view returns (uint256);
418 
419     /**
420      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
421      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
422      */
423     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
424 
425     /**
426      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
427      * Use along with {totalSupply} to enumerate all tokens.
428      */
429     function tokenByIndex(uint256 index) external view returns (uint256);
430 }
431 
432 pragma solidity ^0.8.0;
433 
434 /**
435  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
436  * @dev See https://eips.ethereum.org/EIPS/eip-721
437  */
438 interface IERC721Metadata is IERC721 {
439     /**
440      * @dev Returns the token collection name.
441      */
442     function name() external view returns (string memory);
443 
444     /**
445      * @dev Returns the token collection symbol.
446      */
447     function symbol() external view returns (string memory);
448 
449     /**
450      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
451      */
452     function tokenURI(uint256 tokenId) external view returns (string memory);
453 }
454 
455 pragma solidity ^0.8.0;
456 
457 /**
458  * @dev Collection of functions related to the address type
459  */
460 library Address {
461     /**
462      * @dev Returns true if `account` is a contract.
463      *
464      * [IMPORTANT]
465      * ====
466      * It is unsafe to assume that an address for which this function returns
467      * false is an externally-owned account (EOA) and not a contract.
468      *
469      * Among others, `isContract` will return false for the following
470      * types of addresses:
471      *
472      *  - an externally-owned account
473      *  - a contract in construction
474      *  - an address where a contract will be created
475      *  - an address where a contract lived, but was destroyed
476      * ====
477      */
478     function isContract(address account) internal view returns (bool) {
479         // This method relies on extcodesize, which returns 0 for contracts in
480         // construction, since the code is only stored at the end of the
481         // constructor execution.
482 
483         uint256 size;
484         assembly {
485             size := extcodesize(account)
486         }
487         return size > 0;
488     }
489 
490     /**
491      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
492      * `recipient`, forwarding all available gas and reverting on errors.
493      *
494      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
495      * of certain opcodes, possibly making contracts go over the 2300 gas limit
496      * imposed by `transfer`, making them unable to receive funds via
497      * `transfer`. {sendValue} removes this limitation.
498      *
499      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
500      *
501      * IMPORTANT: because control is transferred to `recipient`, care must be
502      * taken to not create reentrancy vulnerabilities. Consider using
503      * {ReentrancyGuard} or the
504      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
505      */
506     function sendValue(address payable recipient, uint256 amount) internal {
507         require(address(this).balance >= amount, "Address: insufficient balance");
508 
509         (bool success, ) = recipient.call{value: amount}("");
510         require(success, "Address: unable to send value, recipient may have reverted");
511     }
512 
513     /**
514      * @dev Performs a Solidity function call using a low level `call`. A
515      * plain `call` is an unsafe replacement for a function call: use this
516      * function instead.
517      *
518      * If `target` reverts with a revert reason, it is bubbled up by this
519      * function (like regular Solidity function calls).
520      *
521      * Returns the raw returned data. To convert to the expected return value,
522      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
523      *
524      * Requirements:
525      *
526      * - `target` must be a contract.
527      * - calling `target` with `data` must not revert.
528      *
529      * _Available since v3.1._
530      */
531     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
532         return functionCall(target, data, "Address: low-level call failed");
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
537      * `errorMessage` as a fallback revert reason when `target` reverts.
538      *
539      * _Available since v3.1._
540      */
541     function functionCall(
542         address target,
543         bytes memory data,
544         string memory errorMessage
545     ) internal returns (bytes memory) {
546         return functionCallWithValue(target, data, 0, errorMessage);
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
551      * but also transferring `value` wei to `target`.
552      *
553      * Requirements:
554      *
555      * - the calling contract must have an ETH balance of at least `value`.
556      * - the called Solidity function must be `payable`.
557      *
558      * _Available since v3.1._
559      */
560     function functionCallWithValue(
561         address target,
562         bytes memory data,
563         uint256 value
564     ) internal returns (bytes memory) {
565         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
566     }
567 
568     /**
569      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
570      * with `errorMessage` as a fallback revert reason when `target` reverts.
571      *
572      * _Available since v3.1._
573      */
574     function functionCallWithValue(
575         address target,
576         bytes memory data,
577         uint256 value,
578         string memory errorMessage
579     ) internal returns (bytes memory) {
580         require(address(this).balance >= value, "Address: insufficient balance for call");
581         require(isContract(target), "Address: call to non-contract");
582 
583         (bool success, bytes memory returndata) = target.call{value: value}(data);
584         return verifyCallResult(success, returndata, errorMessage);
585     }
586 
587     /**
588      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
589      * but performing a static call.
590      *
591      * _Available since v3.3._
592      */
593     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
594         return functionStaticCall(target, data, "Address: low-level static call failed");
595     }
596 
597     /**
598      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
599      * but performing a static call.
600      *
601      * _Available since v3.3._
602      */
603     function functionStaticCall(
604         address target,
605         bytes memory data,
606         string memory errorMessage
607     ) internal view returns (bytes memory) {
608         require(isContract(target), "Address: static call to non-contract");
609 
610         (bool success, bytes memory returndata) = target.staticcall(data);
611         return verifyCallResult(success, returndata, errorMessage);
612     }
613 
614     /**
615      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
616      * but performing a delegate call.
617      *
618      * _Available since v3.4._
619      */
620     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
621         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
626      * but performing a delegate call.
627      *
628      * _Available since v3.4._
629      */
630     function functionDelegateCall(
631         address target,
632         bytes memory data,
633         string memory errorMessage
634     ) internal returns (bytes memory) {
635         require(isContract(target), "Address: delegate call to non-contract");
636 
637         (bool success, bytes memory returndata) = target.delegatecall(data);
638         return verifyCallResult(success, returndata, errorMessage);
639     }
640 
641     /**
642      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
643      * revert reason using the provided one.
644      *
645      * _Available since v4.3._
646      */
647     function verifyCallResult(
648         bool success,
649         bytes memory returndata,
650         string memory errorMessage
651     ) internal pure returns (bytes memory) {
652         if (success) {
653             return returndata;
654         } else {
655             // Look for revert reason and bubble it up if present
656             if (returndata.length > 0) {
657                 // The easiest way to bubble the revert reason is using memory via assembly
658 
659                 assembly {
660                     let returndata_size := mload(returndata)
661                     revert(add(32, returndata), returndata_size)
662                 }
663             } else {
664                 revert(errorMessage);
665             }
666         }
667     }
668 }
669 
670 pragma solidity ^0.8.0;
671 
672 /**
673  * @dev String operations.
674  */
675 library Strings {
676     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
677 
678     /**
679      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
680      */
681     function toString(uint256 value) internal pure returns (string memory) {
682         // Inspired by OraclizeAPI's implementation - MIT licence
683         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
684 
685         if (value == 0) {
686             return "0";
687         }
688         uint256 temp = value;
689         uint256 digits;
690         while (temp != 0) {
691             digits++;
692             temp /= 10;
693         }
694         bytes memory buffer = new bytes(digits);
695         while (value != 0) {
696             digits -= 1;
697             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
698             value /= 10;
699         }
700         return string(buffer);
701     }
702 
703     /**
704      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
705      */
706     function toHexString(uint256 value) internal pure returns (string memory) {
707         if (value == 0) {
708             return "0x00";
709         }
710         uint256 temp = value;
711         uint256 length = 0;
712         while (temp != 0) {
713             length++;
714             temp >>= 8;
715         }
716         return toHexString(value, length);
717     }
718 
719     /**
720      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
721      */
722     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
723         bytes memory buffer = new bytes(2 * length + 2);
724         buffer[0] = "0";
725         buffer[1] = "x";
726         for (uint256 i = 2 * length + 1; i > 1; --i) {
727             buffer[i] = _HEX_SYMBOLS[value & 0xf];
728             value >>= 4;
729         }
730         require(value == 0, "Strings: hex length insufficient");
731         return string(buffer);
732     }
733 }
734 
735 pragma solidity ^0.8.0;
736 
737 /**
738  * @dev Implementation of the {IERC165} interface.
739  *
740  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
741  * for the additional interface id that will be supported. For example:
742  *
743  * ```solidity
744  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
745  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
746  * }
747  * ```
748  *
749  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
750  */
751 abstract contract ERC165 is IERC165 {
752     /**
753      * @dev See {IERC165-supportsInterface}.
754      */
755     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
756         return interfaceId == type(IERC165).interfaceId;
757     }
758 }
759 
760 pragma solidity ^0.8.0;
761 
762 // CAUTION
763 // This version of SafeMath should only be used with Solidity 0.8 or later,
764 // because it relies on the compiler's built in overflow checks.
765 
766 /**
767  * @dev Wrappers over Solidity's arithmetic operations.
768  *
769  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
770  * now has built in overflow checking.
771  */
772 library SafeMath {
773     /**
774      * @dev Returns the addition of two unsigned integers, with an overflow flag.
775      *
776      * _Available since v3.4._
777      */
778     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
779         unchecked {
780             uint256 c = a + b;
781             if (c < a) return (false, 0);
782             return (true, c);
783         }
784     }
785 
786     /**
787      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
788      *
789      * _Available since v3.4._
790      */
791     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
792         unchecked {
793             if (b > a) return (false, 0);
794             return (true, a - b);
795         }
796     }
797 
798     /**
799      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
800      *
801      * _Available since v3.4._
802      */
803     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
804         unchecked {
805             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
806             // benefit is lost if 'b' is also tested.
807             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
808             if (a == 0) return (true, 0);
809             uint256 c = a * b;
810             if (c / a != b) return (false, 0);
811             return (true, c);
812         }
813     }
814 
815     /**
816      * @dev Returns the division of two unsigned integers, with a division by zero flag.
817      *
818      * _Available since v3.4._
819      */
820     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
821         unchecked {
822             if (b == 0) return (false, 0);
823             return (true, a / b);
824         }
825     }
826 
827     /**
828      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
829      *
830      * _Available since v3.4._
831      */
832     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
833         unchecked {
834             if (b == 0) return (false, 0);
835             return (true, a % b);
836         }
837     }
838 
839     /**
840      * @dev Returns the addition of two unsigned integers, reverting on
841      * overflow.
842      *
843      * Counterpart to Solidity's `+` operator.
844      *
845      * Requirements:
846      *
847      * - Addition cannot overflow.
848      */
849     function add(uint256 a, uint256 b) internal pure returns (uint256) {
850         return a + b;
851     }
852 
853     /**
854      * @dev Returns the subtraction of two unsigned integers, reverting on
855      * overflow (when the result is negative).
856      *
857      * Counterpart to Solidity's `-` operator.
858      *
859      * Requirements:
860      *
861      * - Subtraction cannot overflow.
862      */
863     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
864         return a - b;
865     }
866 
867     /**
868      * @dev Returns the multiplication of two unsigned integers, reverting on
869      * overflow.
870      *
871      * Counterpart to Solidity's `*` operator.
872      *
873      * Requirements:
874      *
875      * - Multiplication cannot overflow.
876      */
877     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
878         return a * b;
879     }
880 
881     /**
882      * @dev Returns the integer division of two unsigned integers, reverting on
883      * division by zero. The result is rounded towards zero.
884      *
885      * Counterpart to Solidity's `/` operator.
886      *
887      * Requirements:
888      *
889      * - The divisor cannot be zero.
890      */
891     function div(uint256 a, uint256 b) internal pure returns (uint256) {
892         return a / b;
893     }
894 
895     /**
896      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
897      * reverting when dividing by zero.
898      *
899      * Counterpart to Solidity's `%` operator. This function uses a `revert`
900      * opcode (which leaves remaining gas untouched) while Solidity uses an
901      * invalid opcode to revert (consuming all remaining gas).
902      *
903      * Requirements:
904      *
905      * - The divisor cannot be zero.
906      */
907     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
908         return a % b;
909     }
910 
911     /**
912      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
913      * overflow (when the result is negative).
914      *
915      * CAUTION: This function is deprecated because it requires allocating memory for the error
916      * message unnecessarily. For custom revert reasons use {trySub}.
917      *
918      * Counterpart to Solidity's `-` operator.
919      *
920      * Requirements:
921      *
922      * - Subtraction cannot overflow.
923      */
924     function sub(
925         uint256 a,
926         uint256 b,
927         string memory errorMessage
928     ) internal pure returns (uint256) {
929         unchecked {
930             require(b <= a, errorMessage);
931             return a - b;
932         }
933     }
934 
935     /**
936      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
937      * division by zero. The result is rounded towards zero.
938      *
939      * Counterpart to Solidity's `/` operator. Note: this function uses a
940      * `revert` opcode (which leaves remaining gas untouched) while Solidity
941      * uses an invalid opcode to revert (consuming all remaining gas).
942      *
943      * Requirements:
944      *
945      * - The divisor cannot be zero.
946      */
947     function div(
948         uint256 a,
949         uint256 b,
950         string memory errorMessage
951     ) internal pure returns (uint256) {
952         unchecked {
953             require(b > 0, errorMessage);
954             return a / b;
955         }
956     }
957 
958     /**
959      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
960      * reverting with custom message when dividing by zero.
961      *
962      * CAUTION: This function is deprecated because it requires allocating memory for the error
963      * message unnecessarily. For custom revert reasons use {tryMod}.
964      *
965      * Counterpart to Solidity's `%` operator. This function uses a `revert`
966      * opcode (which leaves remaining gas untouched) while Solidity uses an
967      * invalid opcode to revert (consuming all remaining gas).
968      *
969      * Requirements:
970      *
971      * - The divisor cannot be zero.
972      */
973     function mod(
974         uint256 a,
975         uint256 b,
976         string memory errorMessage
977     ) internal pure returns (uint256) {
978         unchecked {
979             require(b > 0, errorMessage);
980             return a % b;
981         }
982     }
983 }
984 
985 pragma solidity ^0.8.0;
986 
987 /*************************
988 * @author: Squeebo       *
989 * @license: BSD-3-Clause *
990 **************************/
991 
992 contract Delegated is Ownable{
993   mapping(address => bool) internal _delegates;
994 
995   constructor(){
996     _delegates[owner()] = true;
997   }
998 
999   modifier onlyDelegates {
1000     require(_delegates[msg.sender], "Invalid delegate" );
1001     _;
1002   }
1003 
1004   //onlyOwner
1005   function isDelegate( address addr ) external view onlyOwner returns ( bool ){
1006     return _delegates[addr];
1007   }
1008 
1009   function setDelegate( address addr, bool isDelegate_ ) external onlyOwner{
1010     _delegates[addr] = isDelegate_;
1011   }
1012 }
1013 
1014 pragma solidity ^0.8.0;
1015 
1016 /*************************
1017 * @author: Squeebo       *
1018 * @license: BSD-3-Clause *
1019 **************************/
1020 
1021 abstract contract ERC721B is Context, ERC165, IERC721, IERC721Metadata {
1022     using Address for address;
1023 
1024     // Token name
1025     string private _name;
1026 
1027     // Token symbol
1028     string private _symbol;
1029 
1030     // Mapping from token ID to owner address
1031     address[] internal _owners;
1032 
1033     // Mapping from token ID to approved address
1034     mapping(uint256 => address) private _tokenApprovals;
1035 
1036     // Mapping from owner to operator approvals
1037     mapping(address => mapping(address => bool)) private _operatorApprovals;
1038 
1039     /**
1040      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1041      */
1042     constructor(string memory name_, string memory symbol_) {
1043         _name = name_;
1044         _symbol = symbol_;
1045     }
1046 
1047     /**
1048      * @dev See {IERC165-supportsInterface}.
1049      */
1050     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1051         return
1052             interfaceId == type(IERC721).interfaceId ||
1053             interfaceId == type(IERC721Metadata).interfaceId ||
1054             super.supportsInterface(interfaceId);
1055     }
1056 
1057     /**
1058      * @dev See {IERC721-balanceOf}.
1059      */
1060     function balanceOf(address owner) public view virtual override returns (uint256) {
1061         require(owner != address(0), "ERC721: balance query for the zero address");
1062 
1063         uint count = 0;
1064         uint length = _owners.length;
1065         for( uint i = 0; i < length; ++i ){
1066           if( owner == _owners[i] ){
1067             ++count;
1068           }
1069         }
1070 
1071         delete length;
1072         return count;
1073     }
1074 
1075     /**
1076      * @dev See {IERC721-ownerOf}.
1077      */
1078     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1079         address owner = _owners[tokenId];
1080         require(owner != address(0), "ERC721: owner query for nonexistent token");
1081         return owner;
1082     }
1083 
1084     /**
1085      * @dev See {IERC721Metadata-name}.
1086      */
1087     function name() public view virtual override returns (string memory) {
1088         return _name;
1089     }
1090 
1091     /**
1092      * @dev See {IERC721Metadata-symbol}.
1093      */
1094     function symbol() public view virtual override returns (string memory) {
1095         return _symbol;
1096     }
1097 
1098     /**
1099      * @dev See {IERC721-approve}.
1100      */
1101     function approve(address to, uint256 tokenId) public virtual override {
1102         address owner = ERC721B.ownerOf(tokenId);
1103         require(to != owner, "ERC721: approval to current owner");
1104 
1105         require(
1106             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1107             "ERC721: approve caller is not owner nor approved for all"
1108         );
1109 
1110         _approve(to, tokenId);
1111     }
1112 
1113     /**
1114      * @dev See {IERC721-getApproved}.
1115      */
1116     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1117         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1118 
1119         return _tokenApprovals[tokenId];
1120     }
1121 
1122     /**
1123      * @dev See {IERC721-setApprovalForAll}.
1124      */
1125     function setApprovalForAll(address operator, bool approved) public virtual override {
1126         require(operator != _msgSender(), "ERC721: approve to caller");
1127 
1128         _operatorApprovals[_msgSender()][operator] = approved;
1129         emit ApprovalForAll(_msgSender(), operator, approved);
1130     }
1131 
1132     /**
1133      * @dev See {IERC721-isApprovedForAll}.
1134      */
1135     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1136         return _operatorApprovals[owner][operator];
1137     }
1138 
1139 
1140     /**
1141      * @dev See {IERC721-transferFrom}.
1142      */
1143     function transferFrom(
1144         address from,
1145         address to,
1146         uint256 tokenId
1147     ) public virtual override {
1148         //solhint-disable-next-line max-line-length
1149         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1150 
1151         _transfer(from, to, tokenId);
1152     }
1153 
1154     /**
1155      * @dev See {IERC721-safeTransferFrom}.
1156      */
1157     function safeTransferFrom(
1158         address from,
1159         address to,
1160         uint256 tokenId
1161     ) public virtual override {
1162         safeTransferFrom(from, to, tokenId, "");
1163     }
1164 
1165     /**
1166      * @dev See {IERC721-safeTransferFrom}.
1167      */
1168     function safeTransferFrom(
1169         address from,
1170         address to,
1171         uint256 tokenId,
1172         bytes memory _data
1173     ) public virtual override {
1174         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1175         _safeTransfer(from, to, tokenId, _data);
1176     }
1177 
1178     /**
1179      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1180      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1181      *
1182      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1183      *
1184      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1185      * implement alternative mechanisms to perform token transfer, such as signature-based.
1186      *
1187      * Requirements:
1188      *
1189      * - `from` cannot be the zero address.
1190      * - `to` cannot be the zero address.
1191      * - `tokenId` token must exist and be owned by `from`.
1192      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1193      *
1194      * Emits a {Transfer} event.
1195      */
1196     function _safeTransfer(
1197         address from,
1198         address to,
1199         uint256 tokenId,
1200         bytes memory _data
1201     ) internal virtual {
1202         _transfer(from, to, tokenId);
1203         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1204     }
1205 
1206     /**
1207      * @dev Returns whether `tokenId` exists.
1208      *
1209      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1210      *
1211      * Tokens start existing when they are minted (`_mint`),
1212      * and stop existing when they are burned (`_burn`).
1213      */
1214     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1215         return tokenId < _owners.length && _owners[tokenId] != address(0);
1216     }
1217 
1218     /**
1219      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1220      *
1221      * Requirements:
1222      *
1223      * - `tokenId` must exist.
1224      */
1225     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1226         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1227         address owner = ERC721B.ownerOf(tokenId);
1228         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1229     }
1230 
1231     /**
1232      * @dev Safely mints `tokenId` and transfers it to `to`.
1233      *
1234      * Requirements:
1235      *
1236      * - `tokenId` must not exist.
1237      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1238      *
1239      * Emits a {Transfer} event.
1240      */
1241     function _safeMint(address to, uint256 tokenId) internal virtual {
1242         _safeMint(to, tokenId, "");
1243     }
1244 
1245 
1246     /**
1247      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1248      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1249      */
1250     function _safeMint(
1251         address to,
1252         uint256 tokenId,
1253         bytes memory _data
1254     ) internal virtual {
1255         _mint(to, tokenId);
1256         require(
1257             _checkOnERC721Received(address(0), to, tokenId, _data),
1258             "ERC721: transfer to non ERC721Receiver implementer"
1259         );
1260     }
1261 
1262     /**
1263      * @dev Mints `tokenId` and transfers it to `to`.
1264      *
1265      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1266      *
1267      * Requirements:
1268      *
1269      * - `tokenId` must not exist.
1270      * - `to` cannot be the zero address.
1271      *
1272      * Emits a {Transfer} event.
1273      */
1274     function _mint(address to, uint256 tokenId) internal virtual {
1275         require(to != address(0), "ERC721: mint to the zero address");
1276         require(!_exists(tokenId), "ERC721: token already minted");
1277 
1278         _beforeTokenTransfer(address(0), to, tokenId);
1279         _owners.push(to);
1280 
1281         emit Transfer(address(0), to, tokenId);
1282     }
1283 
1284     /**
1285      * @dev Destroys `tokenId`.
1286      * The approval is cleared when the token is burned.
1287      *
1288      * Requirements:
1289      *
1290      * - `tokenId` must exist.
1291      *
1292      * Emits a {Transfer} event.
1293      */
1294     function _burn(uint256 tokenId) internal virtual {
1295         address owner = ERC721B.ownerOf(tokenId);
1296 
1297         _beforeTokenTransfer(owner, address(0), tokenId);
1298 
1299         // Clear approvals
1300         _approve(address(0), tokenId);
1301         _owners[tokenId] = address(0);
1302 
1303         emit Transfer(owner, address(0), tokenId);
1304     }
1305 
1306     /**
1307      * @dev Transfers `tokenId` from `from` to `to`.
1308      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1309      *
1310      * Requirements:
1311      *
1312      * - `to` cannot be the zero address.
1313      * - `tokenId` token must be owned by `from`.
1314      *
1315      * Emits a {Transfer} event.
1316      */
1317     function _transfer(
1318         address from,
1319         address to,
1320         uint256 tokenId
1321     ) internal virtual {
1322         require(ERC721B.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1323         require(to != address(0), "ERC721: transfer to the zero address");
1324 
1325         _beforeTokenTransfer(from, to, tokenId);
1326 
1327         // Clear approvals from the previous owner
1328         _approve(address(0), tokenId);
1329         _owners[tokenId] = to;
1330 
1331         emit Transfer(from, to, tokenId);
1332     }
1333 
1334     /**
1335      * @dev Approve `to` to operate on `tokenId`
1336      *
1337      * Emits a {Approval} event.
1338      */
1339     function _approve(address to, uint256 tokenId) internal virtual {
1340         _tokenApprovals[tokenId] = to;
1341         emit Approval(ERC721B.ownerOf(tokenId), to, tokenId);
1342     }
1343 
1344 
1345     /**
1346      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1347      * The call is not executed if the target address is not a contract.
1348      *
1349      * @param from address representing the previous owner of the given token ID
1350      * @param to target address that will receive the tokens
1351      * @param tokenId uint256 ID of the token to be transferred
1352      * @param _data bytes optional data to send along with the call
1353      * @return bool whether the call correctly returned the expected magic value
1354      */
1355     function _checkOnERC721Received(
1356         address from,
1357         address to,
1358         uint256 tokenId,
1359         bytes memory _data
1360     ) private returns (bool) {
1361         if (to.isContract()) {
1362             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1363                 return retval == IERC721Receiver.onERC721Received.selector;
1364             } catch (bytes memory reason) {
1365                 if (reason.length == 0) {
1366                     revert("ERC721: transfer to non ERC721Receiver implementer");
1367                 } else {
1368                     assembly {
1369                         revert(add(32, reason), mload(reason))
1370                     }
1371                 }
1372             }
1373         } else {
1374             return true;
1375         }
1376     }
1377 
1378     /**
1379      * @dev Hook that is called before any token transfer. This includes minting
1380      * and burning.
1381      *
1382      * Calling conditions:
1383      *
1384      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1385      * transferred to `to`.
1386      * - When `from` is zero, `tokenId` will be minted for `to`.
1387      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1388      * - `from` and `to` are never both zero.
1389      *
1390      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1391      */
1392     function _beforeTokenTransfer(
1393         address from,
1394         address to,
1395         uint256 tokenId
1396     ) internal virtual {}
1397 }
1398 
1399 pragma solidity ^0.8.0;
1400 
1401 /*************************
1402 * @author: Squeebo       *
1403 * @license: BSD-3-Clause *
1404 **************************/
1405 
1406 /**
1407  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1408  * enumerability of all the token ids in the contract as well as all token ids owned by each
1409  * account.
1410  */
1411 abstract contract ERC721EnumerableB is ERC721B, IERC721Enumerable {
1412     /**
1413      * @dev See {IERC165-supportsInterface}.
1414      */
1415     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721B) returns (bool) {
1416         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1417     }
1418 
1419     /**
1420      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1421      */
1422     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
1423         require(index < ERC721B.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1424 
1425         uint count;
1426         uint length = _owners.length;
1427         for( uint i; i < length; ++i ){
1428             if( owner == _owners[i] ){
1429                 if( count == index ){
1430                     delete count;
1431                     delete length;
1432                     return i;
1433                 }
1434                 else
1435                     ++count;
1436             }
1437         }
1438 
1439         delete count;
1440         delete length;
1441         require(false, "ERC721Enumerable: owner index out of bounds");
1442     }
1443 
1444     /**
1445      * @dev See {IERC721Enumerable-totalSupply}.
1446      */
1447     function totalSupply() public view virtual override returns (uint256) {
1448         return _owners.length;
1449     }
1450 
1451     /**
1452      * @dev See {IERC721Enumerable-tokenByIndex}.
1453      */
1454     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1455         require(index < ERC721EnumerableB.totalSupply(), "ERC721Enumerable: global index out of bounds");
1456         return index;
1457     }
1458 }
1459 
1460 pragma solidity ^0.8.0;
1461 
1462 /****************************************
1463  * @author: Squeebo                     *
1464  * @team:   X-11                        *
1465  ****************************************
1466  *   Blimpie-ERC721 provides low-gas    *
1467  *           mints + transfers          *
1468  ****************************************/
1469 
1470 contract AHMC is Delegated, ERC721EnumerableB, PaymentSplitter {
1471   using Strings for uint;
1472 
1473   uint public MAX_SUPPLY = 1111;
1474 
1475   bool public isActive   = false;
1476   uint public maxOrder   = 11;
1477   uint public price      = 0.11 ether;
1478 
1479   string private _baseTokenURI = '';
1480   string private _tokenURISuffix = '';
1481 
1482   mapping(address => uint[]) private _balances;
1483 
1484   address[] private addressList = [
1485     0x13d86B7a637B9378d3646FA50De24e4e8fd78393,
1486     0xB7edf3Cbb58ecb74BdE6298294c7AAb339F3cE4a
1487   ];
1488   uint[] private shareList = [
1489     84,
1490     16
1491   ];
1492 
1493   constructor()
1494     Delegated()
1495     ERC721B("APE HARMONY MONSTER CLUB", "AHMC")
1496     PaymentSplitter(addressList, shareList)  {
1497   }
1498 
1499   //external
1500   fallback() external payable {}
1501 
1502   function mint( uint quantity ) external payable {
1503     require( isActive,                      "Sale is not active"        );
1504     require( quantity <= maxOrder,          "Order too big"             );
1505     require( msg.value >= price * quantity, "Ether sent is not correct" );
1506 
1507     uint256 supply = totalSupply();
1508     require( supply + quantity <= MAX_SUPPLY, "Mint/order exceeds supply" );
1509     for(uint i = 0; i < quantity; ++i){
1510       _safeMint( msg.sender, supply++, "" );
1511     }
1512   }
1513 
1514   //external delegated
1515   function gift(uint[] calldata quantity, address[] calldata recipient) external onlyDelegates{
1516     require(quantity.length == recipient.length, "Must provide equal quantities and recipients" );
1517 
1518     uint totalQuantity = 0;
1519     uint256 supply = totalSupply();
1520     for(uint i = 0; i < quantity.length; ++i){
1521       totalQuantity += quantity[i];
1522     }
1523     require( supply + totalQuantity <= MAX_SUPPLY, "Mint/order exceeds supply" );
1524     delete totalQuantity;
1525 
1526     for(uint i = 0; i < recipient.length; ++i){
1527       for(uint j = 0; j < quantity[i]; ++j){
1528         _safeMint( recipient[i], supply++, "Sent with love" );
1529       }
1530     }
1531   }
1532 
1533   function setActive(bool isActive_) external onlyDelegates{
1534     if( isActive != isActive_ )
1535       isActive = isActive_;
1536   }
1537 
1538   function setMaxOrder(uint maxOrder_) external onlyDelegates{
1539     if( maxOrder != maxOrder_ )
1540       maxOrder = maxOrder_;
1541   }
1542 
1543   function setPrice(uint price_ ) external onlyDelegates{
1544     if( price != price_ )
1545       price = price_;
1546   }
1547 
1548   function setBaseURI(string calldata _newBaseURI, string calldata _newSuffix) external onlyDelegates{
1549     _baseTokenURI = _newBaseURI;
1550     _tokenURISuffix = _newSuffix;
1551   }
1552 
1553 
1554   //external owner
1555   function setMaxSupply(uint maxSupply) external onlyOwner{
1556     if( MAX_SUPPLY != maxSupply ){
1557       require(maxSupply >= totalSupply(), "Specified supply is lower than current balance" );
1558       MAX_SUPPLY = maxSupply;
1559     }
1560   }
1561 
1562 
1563   //public
1564   function balanceOf(address owner) public view virtual override returns (uint256) {
1565     require(owner != address(0), "ERC721: balance query for the zero address");
1566     return _balances[owner].length;
1567   }
1568 
1569   function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
1570     require(index < ERC721B.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1571     return _balances[owner][index];
1572   }
1573 
1574   function tokenURI(uint tokenId) external view virtual override returns (string memory) {
1575     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1576     return string(abi.encodePacked(_baseTokenURI, tokenId.toString(), _tokenURISuffix));
1577   }
1578 
1579 
1580   //internal
1581   function _beforeTokenTransfer(
1582       address from,
1583       address to,
1584       uint256 tokenId
1585   ) internal override virtual {
1586     address zero = address(0);
1587     if( from != zero || to == zero ){
1588       //find this token and remove it
1589       uint length = _balances[from].length;
1590       for( uint i; i < length; ++i ){
1591         if( _balances[from][i] == tokenId ){
1592           _balances[from][i] = _balances[from][length - 1];
1593           _balances[from].pop();
1594           break;
1595         }
1596       }
1597       delete length;
1598     }
1599 
1600     if( from == zero || to != zero ){
1601       _balances[to].push( tokenId );
1602     }
1603   }
1604 }