1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 /**
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 pragma solidity ^0.8.0;
23 /**
24  * @dev Contract module which provides a basic access control mechanism, where
25  * there is an account (an owner) that can be granted exclusive access to
26  * specific functions.
27  *
28  * By default, the owner account will be the one that deploys the contract. This
29  * can later be changed with {transferOwnership}.
30  *
31  * This module is used through inheritance. It will make available the modifier
32  * `onlyOwner`, which can be applied to your functions to restrict their use to
33  * the owner.
34  */
35 abstract contract Ownable is Context {
36     address private _owner;
37     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38     /**
39      * @dev Initializes the contract setting the deployer as the initial owner.
40      */
41     constructor() {
42         _setOwner(_msgSender());
43     }
44     /**
45      * @dev Returns the address of the current owner.
46      */
47     function owner() public view virtual returns (address) {
48         return _owner;
49     }
50     /**
51      * @dev Throws if called by any account other than the owner.
52      */
53     modifier onlyOwner() {
54         require(owner() == _msgSender(), "Ownable: caller is not the owner");
55         _;
56     }
57     /**
58      * @dev Leaves the contract without owner. It will not be possible to call
59      * `onlyOwner` functions anymore. Can only be called by the current owner.
60      *
61      * NOTE: Renouncing ownership will leave the contract without an owner,
62      * thereby removing any functionality that is only available to the owner.
63      */
64     function renounceOwnership() public virtual onlyOwner {
65         _setOwner(address(0));
66     }
67     /**
68      * @dev Transfers ownership of the contract to a new account (`newOwner`).
69      * Can only be called by the current owner.
70      */
71     function transferOwnership(address newOwner) public virtual onlyOwner {
72         require(newOwner != address(0), "Ownable: new owner is the zero address");
73         _setOwner(newOwner);
74     }
75     function _setOwner(address newOwner) private {
76         address oldOwner = _owner;
77         _owner = newOwner;
78         emit OwnershipTransferred(oldOwner, newOwner);
79     }
80 }
81 pragma solidity ^0.8.0;
82 /**
83  * @title PaymentSplitter
84  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
85  * that the Ether will be split in this way, since it is handled transparently by the contract.
86  *
87  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
88  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
89  * an amount proportional to the percentage of total shares they were assigned.
90  *
91  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
92  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
93  * function.
94  */
95 contract PaymentSplitter is Context {
96     event PayeeAdded(address account, uint256 shares);
97     event PaymentReleased(address to, uint256 amount);
98     event PaymentReceived(address from, uint256 amount);
99     uint256 private _totalShares;
100     uint256 private _totalReleased;
101     mapping(address => uint256) private _shares;
102     mapping(address => uint256) private _released;
103     address[] private _payees;
104     /**
105      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
106      * the matching position in the `shares` array.
107      *
108      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
109      * duplicates in `payees`.
110      */
111     constructor(address[] memory payees, uint256[] memory shares_) payable {
112         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
113         require(payees.length > 0, "PaymentSplitter: no payees");
114 
115         for (uint256 i = 0; i < payees.length; i++) {
116             _addPayee(payees[i], shares_[i]);
117         }
118     }
119     /**
120      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
121      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
122      * reliability of the events, and not the actual splitting of Ether.
123      *
124      * To learn more about this see the Solidity documentation for
125      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
126      * functions].
127      */
128     receive() external payable virtual {
129         emit PaymentReceived(_msgSender(), msg.value);
130     }
131     /**
132      * @dev Getter for the total shares held by payees.
133      */
134     function totalShares() public view returns (uint256) {
135         return _totalShares;
136     }
137     /**
138      * @dev Getter for the total amount of Ether already released.
139      */
140     function totalReleased() public view returns (uint256) {
141         return _totalReleased;
142     }
143     /**
144      * @dev Getter for the amount of shares held by an account.
145      */
146     function shares(address account) public view returns (uint256) {
147         return _shares[account];
148     }
149     /**
150      * @dev Getter for the amount of Ether already released to a payee.
151      */
152     function released(address account) public view returns (uint256) {
153         return _released[account];
154     }
155     /**
156      * @dev Getter for the address of the payee number `index`.
157      */
158     function payee(uint256 index) public view returns (address) {
159         return _payees[index];
160     }
161     /**
162      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
163      * total shares and their previous withdrawals.
164      */
165     function release(address payable account) public virtual {
166         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
167 
168         uint256 totalReceived = address(this).balance + _totalReleased;
169         uint256 payment = (totalReceived * _shares[account]) / _totalShares - _released[account];
170 
171         require(payment != 0, "PaymentSplitter: account is not due payment");
172 
173         _released[account] = _released[account] + payment;
174         _totalReleased = _totalReleased + payment;
175 
176         Address.sendValue(account, payment);
177         emit PaymentReleased(account, payment);
178     }
179     /**
180      * @dev Add a new payee to the contract.
181      * @param account The address of the payee to add.
182      * @param shares_ The number of shares owned by the payee.
183      */
184     function _addPayee(address account, uint256 shares_) private {
185         require(account != address(0), "PaymentSplitter: account is the zero address");
186         require(shares_ > 0, "PaymentSplitter: shares are 0");
187         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
188 
189         _payees.push(account);
190         _shares[account] = shares_;
191         _totalShares = _totalShares + shares_;
192         emit PayeeAdded(account, shares_);
193     }
194 }
195 pragma solidity ^0.8.0;
196 /**
197  * @dev Interface of the ERC165 standard, as defined in the
198  * https://eips.ethereum.org/EIPS/eip-165[EIP].
199  *
200  * Implementers can declare support of contract interfaces, which can then be
201  * queried by others ({ERC165Checker}).
202  *
203  * For an implementation, see {ERC165}.
204  */
205 interface IERC165 {
206     /**
207      * @dev Returns true if this contract implements the interface defined by
208      * `interfaceId`. See the corresponding
209      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
210      * to learn more about how these ids are created.
211      *
212      * This function call must use less than 30 000 gas.
213      */
214     function supportsInterface(bytes4 interfaceId) external view returns (bool);
215 }
216 pragma solidity ^0.8.0;
217 /**
218  * @dev Required interface of an ERC721 compliant contract.
219  */
220 interface IERC721 is IERC165 {
221     /**
222      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
223      */
224     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
225     /**
226      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
227      */
228     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
229     /**
230      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
231      */
232     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
233     /**
234      * @dev Returns the number of tokens in ``owner``'s account.
235      */
236     function balanceOf(address owner) external view returns (uint256 balance);
237     /**
238      * @dev Returns the owner of the `tokenId` token.
239      *
240      * Requirements:
241      *
242      * - `tokenId` must exist.
243      */
244     function ownerOf(uint256 tokenId) external view returns (address owner);
245     /**
246      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
247      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
248      *
249      * Requirements:
250      *
251      * - `from` cannot be the zero address.
252      * - `to` cannot be the zero address.
253      * - `tokenId` token must exist and be owned by `from`.
254      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
255      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
256      *
257      * Emits a {Transfer} event.
258      */
259     function safeTransferFrom(
260         address from,
261         address to,
262         uint256 tokenId
263     ) external;
264     /**
265      * @dev Transfers `tokenId` token from `from` to `to`.
266      *
267      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
268      *
269      * Requirements:
270      *
271      * - `from` cannot be the zero address.
272      * - `to` cannot be the zero address.
273      * - `tokenId` token must be owned by `from`.
274      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
275      *
276      * Emits a {Transfer} event.
277      */
278     function transferFrom(
279         address from,
280         address to,
281         uint256 tokenId
282     ) external;
283     /**
284      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
285      * The approval is cleared when the token is transferred.
286      *
287      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
288      *
289      * Requirements:
290      *
291      * - The caller must own the token or be an approved operator.
292      * - `tokenId` must exist.
293      *
294      * Emits an {Approval} event.
295      */
296     function approve(address to, uint256 tokenId) external;
297     /**
298      * @dev Returns the account approved for `tokenId` token.
299      *
300      * Requirements:
301      *
302      * - `tokenId` must exist.
303      */
304     function getApproved(uint256 tokenId) external view returns (address operator);
305     /**
306      * @dev Approve or remove `operator` as an operator for the caller.
307      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
308      *
309      * Requirements:
310      *
311      * - The `operator` cannot be the caller.
312      *
313      * Emits an {ApprovalForAll} event.
314      */
315     function setApprovalForAll(address operator, bool _approved) external;
316     /**
317      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
318      *
319      * See {setApprovalForAll}
320      */
321     function isApprovedForAll(address owner, address operator) external view returns (bool);
322     /**
323      * @dev Safely transfers `tokenId` token from `from` to `to`.
324      *
325      * Requirements:
326      *
327      * - `from` cannot be the zero address.
328      * - `to` cannot be the zero address.
329      * - `tokenId` token must exist and be owned by `from`.
330      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
331      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
332      *
333      * Emits a {Transfer} event.
334      */
335     function safeTransferFrom(
336         address from,
337         address to,
338         uint256 tokenId,
339         bytes calldata data
340     ) external;
341 }
342 pragma solidity ^0.8.0;
343 /**
344  * @title ERC721 token receiver interface
345  * @dev Interface for any contract that wants to support safeTransfers
346  * from ERC721 asset contracts.
347  */
348 interface IERC721Receiver {
349     /**
350      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
351      * by `operator` from `from`, this function is called.
352      *
353      * It must return its Solidity selector to confirm the token transfer.
354      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
355      *
356      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
357      */
358     function onERC721Received(
359         address operator,
360         address from,
361         uint256 tokenId,
362         bytes calldata data
363     ) external returns (bytes4);
364 }
365 pragma solidity ^0.8.0;
366 /**
367  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
368  * @dev See https://eips.ethereum.org/EIPS/eip-721
369  */
370 interface IERC721Enumerable is IERC721 {
371     /**
372      * @dev Returns the total amount of tokens stored by the contract.
373      */
374     function totalSupply() external view returns (uint256);
375 
376     /**
377      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
378      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
379      */
380     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
381 
382     /**
383      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
384      * Use along with {totalSupply} to enumerate all tokens.
385      */
386     function tokenByIndex(uint256 index) external view returns (uint256);
387 }
388 pragma solidity ^0.8.0;
389 /**
390  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
391  * @dev See https://eips.ethereum.org/EIPS/eip-721
392  */
393 interface IERC721Metadata is IERC721 {
394     /**
395      * @dev Returns the token collection name.
396      */
397     function name() external view returns (string memory);
398 
399     /**
400      * @dev Returns the token collection symbol.
401      */
402     function symbol() external view returns (string memory);
403 
404     /**
405      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
406      */
407     function tokenURI(uint256 tokenId) external view returns (string memory);
408 }
409 pragma solidity ^0.8.0;
410 /**
411  * @dev Collection of functions related to the address type
412  */
413 library Address {
414     /**
415      * @dev Returns true if `account` is a contract.
416      *
417      * [IMPORTANT]
418      * ====
419      * It is unsafe to assume that an address for which this function returns
420      * false is an externally-owned account (EOA) and not a contract.
421      *
422      * Among others, `isContract` will return false for the following
423      * types of addresses:
424      *
425      *  - an externally-owned account
426      *  - a contract in construction
427      *  - an address where a contract will be created
428      *  - an address where a contract lived, but was destroyed
429      * ====
430      */
431     function isContract(address account) internal view returns (bool) {
432         // This method relies on extcodesize, which returns 0 for contracts in
433         // construction, since the code is only stored at the end of the
434         // constructor execution.
435 
436         uint256 size;
437         assembly {
438             size := extcodesize(account)
439         }
440         return size > 0;
441     }
442     /**
443      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
444      * `recipient`, forwarding all available gas and reverting on errors.
445      *
446      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
447      * of certain opcodes, possibly making contracts go over the 2300 gas limit
448      * imposed by `transfer`, making them unable to receive funds via
449      * `transfer`. {sendValue} removes this limitation.
450      *
451      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
452      *
453      * IMPORTANT: because control is transferred to `recipient`, care must be
454      * taken to not create reentrancy vulnerabilities. Consider using
455      * {ReentrancyGuard} or the
456      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
457      */
458     function sendValue(address payable recipient, uint256 amount) internal {
459         require(address(this).balance >= amount, "Address: insufficient balance");
460 
461         (bool success, ) = recipient.call{value: amount}("");
462         require(success, "Address: unable to send value, recipient may have reverted");
463     }
464     /**
465      * @dev Performs a Solidity function call using a low level `call`. A
466      * plain `call` is an unsafe replacement for a function call: use this
467      * function instead.
468      *
469      * If `target` reverts with a revert reason, it is bubbled up by this
470      * function (like regular Solidity function calls).
471      *
472      * Returns the raw returned data. To convert to the expected return value,
473      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
474      *
475      * Requirements:
476      *
477      * - `target` must be a contract.
478      * - calling `target` with `data` must not revert.
479      *
480      * _Available since v3.1._
481      */
482     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
483         return functionCall(target, data, "Address: low-level call failed");
484     }
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
487      * `errorMessage` as a fallback revert reason when `target` reverts.
488      *
489      * _Available since v3.1._
490      */
491     function functionCall(
492         address target,
493         bytes memory data,
494         string memory errorMessage
495     ) internal returns (bytes memory) {
496         return functionCallWithValue(target, data, 0, errorMessage);
497     }
498     /**
499      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
500      * but also transferring `value` wei to `target`.
501      *
502      * Requirements:
503      *
504      * - the calling contract must have an ETH balance of at least `value`.
505      * - the called Solidity function must be `payable`.
506      *
507      * _Available since v3.1._
508      */
509     function functionCallWithValue(
510         address target,
511         bytes memory data,
512         uint256 value
513     ) internal returns (bytes memory) {
514         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
515     }
516     /**
517      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
518      * with `errorMessage` as a fallback revert reason when `target` reverts.
519      *
520      * _Available since v3.1._
521      */
522     function functionCallWithValue(
523         address target,
524         bytes memory data,
525         uint256 value,
526         string memory errorMessage
527     ) internal returns (bytes memory) {
528         require(address(this).balance >= value, "Address: insufficient balance for call");
529         require(isContract(target), "Address: call to non-contract");
530 
531         (bool success, bytes memory returndata) = target.call{value: value}(data);
532         return verifyCallResult(success, returndata, errorMessage);
533     }
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
536      * but performing a static call.
537      *
538      * _Available since v3.3._
539      */
540     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
541         return functionStaticCall(target, data, "Address: low-level static call failed");
542     }
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
545      * but performing a static call.
546      *
547      * _Available since v3.3._
548      */
549     function functionStaticCall(
550         address target,
551         bytes memory data,
552         string memory errorMessage
553     ) internal view returns (bytes memory) {
554         require(isContract(target), "Address: static call to non-contract");
555 
556         (bool success, bytes memory returndata) = target.staticcall(data);
557         return verifyCallResult(success, returndata, errorMessage);
558     }
559     /**
560      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
561      * but performing a delegate call.
562      *
563      * _Available since v3.4._
564      */
565     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
566         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
567     }
568     /**
569      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
570      * but performing a delegate call.
571      *
572      * _Available since v3.4._
573      */
574     function functionDelegateCall(
575         address target,
576         bytes memory data,
577         string memory errorMessage
578     ) internal returns (bytes memory) {
579         require(isContract(target), "Address: delegate call to non-contract");
580 
581         (bool success, bytes memory returndata) = target.delegatecall(data);
582         return verifyCallResult(success, returndata, errorMessage);
583     }
584     /**
585      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
586      * revert reason using the provided one.
587      *
588      * _Available since v4.3._
589      */
590     function verifyCallResult(
591         bool success,
592         bytes memory returndata,
593         string memory errorMessage
594     ) internal pure returns (bytes memory) {
595         if (success) {
596             return returndata;
597         } else {
598             // Look for revert reason and bubble it up if present
599             if (returndata.length > 0) {
600                 // The easiest way to bubble the revert reason is using memory via assembly
601 
602                 assembly {
603                     let returndata_size := mload(returndata)
604                     revert(add(32, returndata), returndata_size)
605                 }
606             } else {
607                 revert(errorMessage);
608             }
609         }
610     }
611 }
612 pragma solidity ^0.8.0;
613 /**
614  * @dev String operations.
615  */
616 library Strings {
617     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
618 
619     /**
620      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
621      */
622     function toString(uint256 value) internal pure returns (string memory) {
623         // Inspired by OraclizeAPI's implementation - MIT licence
624         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
625 
626         if (value == 0) {
627             return "0";
628         }
629         uint256 temp = value;
630         uint256 digits;
631         while (temp != 0) {
632             digits++;
633             temp /= 10;
634         }
635         bytes memory buffer = new bytes(digits);
636         while (value != 0) {
637             digits -= 1;
638             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
639             value /= 10;
640         }
641         return string(buffer);
642     }
643     /**
644      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
645      */
646     function toHexString(uint256 value) internal pure returns (string memory) {
647         if (value == 0) {
648             return "0x00";
649         }
650         uint256 temp = value;
651         uint256 length = 0;
652         while (temp != 0) {
653             length++;
654             temp >>= 8;
655         }
656         return toHexString(value, length);
657     }
658     /**
659      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
660      */
661     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
662         bytes memory buffer = new bytes(2 * length + 2);
663         buffer[0] = "0";
664         buffer[1] = "x";
665         for (uint256 i = 2 * length + 1; i > 1; --i) {
666             buffer[i] = _HEX_SYMBOLS[value & 0xf];
667             value >>= 4;
668         }
669         require(value == 0, "Strings: hex length insufficient");
670         return string(buffer);
671     }
672 }
673 pragma solidity ^0.8.0;
674 /**
675  * @dev Implementation of the {IERC165} interface.
676  *
677  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
678  * for the additional interface id that will be supported. For example:
679  *
680  * ```solidity
681  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
682  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
683  * }
684  * ```
685  *
686  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
687  */
688 abstract contract ERC165 is IERC165 {
689     /**
690      * @dev See {IERC165-supportsInterface}.
691      */
692     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
693         return interfaceId == type(IERC165).interfaceId;
694     }
695 }
696 pragma solidity ^0.8.0;
697 // CAUTION
698 // This version of SafeMath should only be used with Solidity 0.8 or later,
699 // because it relies on the compiler's built in overflow checks.
700 
701 /**
702  * @dev Wrappers over Solidity's arithmetic operations.
703  *
704  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
705  * now has built in overflow checking.
706  */
707 library SafeMath {
708     /**
709      * @dev Returns the addition of two unsigned integers, with an overflow flag.
710      *
711      * _Available since v3.4._
712      */
713     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
714         unchecked {
715             uint256 c = a + b;
716             if (c < a) return (false, 0);
717             return (true, c);
718         }
719     }
720     /**
721      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
722      *
723      * _Available since v3.4._
724      */
725     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
726         unchecked {
727             if (b > a) return (false, 0);
728             return (true, a - b);
729         }
730     }
731     /**
732      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
733      *
734      * _Available since v3.4._
735      */
736     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
737         unchecked {
738             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
739             // benefit is lost if 'b' is also tested.
740             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
741             if (a == 0) return (true, 0);
742             uint256 c = a * b;
743             if (c / a != b) return (false, 0);
744             return (true, c);
745         }
746     }
747     /**
748      * @dev Returns the division of two unsigned integers, with a division by zero flag.
749      *
750      * _Available since v3.4._
751      */
752     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
753         unchecked {
754             if (b == 0) return (false, 0);
755             return (true, a / b);
756         }
757     }
758     /**
759      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
760      *
761      * _Available since v3.4._
762      */
763     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
764         unchecked {
765             if (b == 0) return (false, 0);
766             return (true, a % b);
767         }
768     }
769     /**
770      * @dev Returns the addition of two unsigned integers, reverting on
771      * overflow.
772      *
773      * Counterpart to Solidity's `+` operator.
774      *
775      * Requirements:
776      *
777      * - Addition cannot overflow.
778      */
779     function add(uint256 a, uint256 b) internal pure returns (uint256) {
780         return a + b;
781     }
782     /**
783      * @dev Returns the subtraction of two unsigned integers, reverting on
784      * overflow (when the result is negative).
785      *
786      * Counterpart to Solidity's `-` operator.
787      *
788      * Requirements:
789      *
790      * - Subtraction cannot overflow.
791      */
792     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
793         return a - b;
794     }
795     /**
796      * @dev Returns the multiplication of two unsigned integers, reverting on
797      * overflow.
798      *
799      * Counterpart to Solidity's `*` operator.
800      *
801      * Requirements:
802      *
803      * - Multiplication cannot overflow.
804      */
805     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
806         return a * b;
807     }
808     /**
809      * @dev Returns the integer division of two unsigned integers, reverting on
810      * division by zero. The result is rounded towards zero.
811      *
812      * Counterpart to Solidity's `/` operator.
813      *
814      * Requirements:
815      *
816      * - The divisor cannot be zero.
817      */
818     function div(uint256 a, uint256 b) internal pure returns (uint256) {
819         return a / b;
820     }
821     /**
822      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
823      * reverting when dividing by zero.
824      *
825      * Counterpart to Solidity's `%` operator. This function uses a `revert`
826      * opcode (which leaves remaining gas untouched) while Solidity uses an
827      * invalid opcode to revert (consuming all remaining gas).
828      *
829      * Requirements:
830      *
831      * - The divisor cannot be zero.
832      */
833     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
834         return a % b;
835     }
836     /**
837      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
838      * overflow (when the result is negative).
839      *
840      * CAUTION: This function is deprecated because it requires allocating memory for the error
841      * message unnecessarily. For custom revert reasons use {trySub}.
842      *
843      * Counterpart to Solidity's `-` operator.
844      *
845      * Requirements:
846      *
847      * - Subtraction cannot overflow.
848      */
849     function sub(
850         uint256 a,
851         uint256 b,
852         string memory errorMessage
853     ) internal pure returns (uint256) {
854         unchecked {
855             require(b <= a, errorMessage);
856             return a - b;
857         }
858     }
859     /**
860      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
861      * division by zero. The result is rounded towards zero.
862      *
863      * Counterpart to Solidity's `/` operator. Note: this function uses a
864      * `revert` opcode (which leaves remaining gas untouched) while Solidity
865      * uses an invalid opcode to revert (consuming all remaining gas).
866      *
867      * Requirements:
868      *
869      * - The divisor cannot be zero.
870      */
871     function div(
872         uint256 a,
873         uint256 b,
874         string memory errorMessage
875     ) internal pure returns (uint256) {
876         unchecked {
877             require(b > 0, errorMessage);
878             return a / b;
879         }
880     }
881     /**
882      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
883      * reverting with custom message when dividing by zero.
884      *
885      * CAUTION: This function is deprecated because it requires allocating memory for the error
886      * message unnecessarily. For custom revert reasons use {tryMod}.
887      *
888      * Counterpart to Solidity's `%` operator. This function uses a `revert`
889      * opcode (which leaves remaining gas untouched) while Solidity uses an
890      * invalid opcode to revert (consuming all remaining gas).
891      *
892      * Requirements:
893      *
894      * - The divisor cannot be zero.
895      */
896     function mod(
897         uint256 a,
898         uint256 b,
899         string memory errorMessage
900     ) internal pure returns (uint256) {
901         unchecked {
902             require(b > 0, errorMessage);
903             return a % b;
904         }
905     }
906 }
907 pragma solidity ^0.8.0;
908 contract Delegated is Ownable{
909   mapping(address => bool) internal _delegates;
910   constructor(){
911     _delegates[owner()] = true;
912   }
913   modifier onlyDelegates {
914     require(_delegates[msg.sender], "Invalid delegate" );
915     _;
916   }
917   //onlyOwner
918   function isDelegate( address addr ) external view onlyOwner returns ( bool ){
919     return _delegates[addr];
920   }
921   function setDelegate( address addr, bool isDelegate_ ) external onlyOwner{
922     _delegates[addr] = isDelegate_;
923   }
924 }
925 pragma solidity ^0.8.0;
926 abstract contract ERC721B is Context, ERC165, IERC721, IERC721Metadata {
927     using Address for address;
928     // Token name
929     string private _name;
930     // Token symbol
931     string private _symbol;
932     // Mapping from token ID to owner address
933     address[] internal _owners;
934     // Mapping from token ID to approved address
935     mapping(uint256 => address) private _tokenApprovals;
936 
937     // Mapping from owner to operator approvals
938     mapping(address => mapping(address => bool)) private _operatorApprovals;
939     /**
940      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
941      */
942     constructor(string memory name_, string memory symbol_) {
943         _name = name_;
944         _symbol = symbol_;
945     }
946     /**
947      * @dev See {IERC165-supportsInterface}.
948      */
949     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
950         return
951             interfaceId == type(IERC721).interfaceId ||
952             interfaceId == type(IERC721Metadata).interfaceId ||
953             super.supportsInterface(interfaceId);
954     }
955     /**
956      * @dev See {IERC721-balanceOf}.
957      */
958     function balanceOf(address owner) public view virtual override returns (uint256) {
959         require(owner != address(0), "ERC721: balance query for the zero address");
960 
961         uint count = 0;
962         uint length = _owners.length;
963         for( uint i = 0; i < length; ++i ){
964           if( owner == _owners[i] ){
965             ++count;
966           }
967         }
968 
969         delete length;
970         return count;
971     }
972     /**
973      * @dev See {IERC721-ownerOf}.
974      */
975     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
976         address owner = _owners[tokenId];
977         require(owner != address(0), "ERC721: owner query for nonexistent token");
978         return owner;
979     }
980     /**
981      * @dev See {IERC721Metadata-name}.
982      */
983     function name() public view virtual override returns (string memory) {
984         return _name;
985     }
986     /**
987      * @dev See {IERC721Metadata-symbol}.
988      */
989     function symbol() public view virtual override returns (string memory) {
990         return _symbol;
991     }
992     /**
993      * @dev See {IERC721-approve}.
994      */
995     function approve(address to, uint256 tokenId) public virtual override {
996         address owner = ERC721B.ownerOf(tokenId);
997         require(to != owner, "ERC721: approval to current owner");
998 
999         require(
1000             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1001             "ERC721: approve caller is not owner nor approved for all"
1002         );
1003 
1004         _approve(to, tokenId);
1005     }
1006     /**
1007      * @dev See {IERC721-getApproved}.
1008      */
1009     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1010         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1011 
1012         return _tokenApprovals[tokenId];
1013     }
1014     /**
1015      * @dev See {IERC721-setApprovalForAll}.
1016      */
1017     function setApprovalForAll(address operator, bool approved) public virtual override {
1018         require(operator != _msgSender(), "ERC721: approve to caller");
1019 
1020         _operatorApprovals[_msgSender()][operator] = approved;
1021         emit ApprovalForAll(_msgSender(), operator, approved);
1022     }
1023     /**
1024      * @dev See {IERC721-isApprovedForAll}.
1025      */
1026     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1027         return _operatorApprovals[owner][operator];
1028     }
1029     /**
1030      * @dev See {IERC721-transferFrom}.
1031      */
1032     function transferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) public virtual override {
1037         //solhint-disable-next-line max-line-length
1038         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1039 
1040         _transfer(from, to, tokenId);
1041     }
1042     /**
1043      * @dev See {IERC721-safeTransferFrom}.
1044      */
1045     function safeTransferFrom(
1046         address from,
1047         address to,
1048         uint256 tokenId
1049     ) public virtual override {
1050         safeTransferFrom(from, to, tokenId, "");
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-safeTransferFrom}.
1055      */
1056     function safeTransferFrom(
1057         address from,
1058         address to,
1059         uint256 tokenId,
1060         bytes memory _data
1061     ) public virtual override {
1062         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1063         _safeTransfer(from, to, tokenId, _data);
1064     }
1065     /**
1066      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1067      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1068      *
1069      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1070      *
1071      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1072      * implement alternative mechanisms to perform token transfer, such as signature-based.
1073      *
1074      * Requirements:
1075      *
1076      * - `from` cannot be the zero address.
1077      * - `to` cannot be the zero address.
1078      * - `tokenId` token must exist and be owned by `from`.
1079      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1080      *
1081      * Emits a {Transfer} event.
1082      */
1083     function _safeTransfer(
1084         address from,
1085         address to,
1086         uint256 tokenId,
1087         bytes memory _data
1088     ) internal virtual {
1089         _transfer(from, to, tokenId);
1090         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1091     }
1092     /**
1093      * @dev Returns whether `tokenId` exists.
1094      *
1095      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1096      *
1097      * Tokens start existing when they are minted (`_mint`),
1098      * and stop existing when they are burned (`_burn`).
1099      */
1100     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1101         return tokenId < _owners.length && _owners[tokenId] != address(0);
1102     }
1103     /**
1104      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1105      *
1106      * Requirements:
1107      *
1108      * - `tokenId` must exist.
1109      */
1110     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1111         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1112         address owner = ERC721B.ownerOf(tokenId);
1113         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1114     }
1115     /**
1116      * @dev Safely mints `tokenId` and transfers it to `to`.
1117      *
1118      * Requirements:
1119      *
1120      * - `tokenId` must not exist.
1121      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1122      *
1123      * Emits a {Transfer} event.
1124      */
1125     function _safeMint(address to, uint256 tokenId) internal virtual {
1126         _safeMint(to, tokenId, "");
1127     }
1128     /**
1129      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1130      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1131      */
1132     function _safeMint(
1133         address to,
1134         uint256 tokenId,
1135         bytes memory _data
1136     ) internal virtual {
1137         _mint(to, tokenId);
1138         require(
1139             _checkOnERC721Received(address(0), to, tokenId, _data),
1140             "ERC721: transfer to non ERC721Receiver implementer"
1141         );
1142     }
1143     /**
1144      * @dev Mints `tokenId` and transfers it to `to`.
1145      *
1146      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1147      *
1148      * Requirements:
1149      *
1150      * - `tokenId` must not exist.
1151      * - `to` cannot be the zero address.
1152      *
1153      * Emits a {Transfer} event.
1154      */
1155     function _mint(address to, uint256 tokenId) internal virtual {
1156         require(to != address(0), "ERC721: mint to the zero address");
1157         require(!_exists(tokenId), "ERC721: token already minted");
1158 
1159         _beforeTokenTransfer(address(0), to, tokenId);
1160         _owners.push(to);
1161 
1162         emit Transfer(address(0), to, tokenId);
1163     }
1164     /**
1165      * @dev Destroys `tokenId`.
1166      * The approval is cleared when the token is burned.
1167      *
1168      * Requirements:
1169      *
1170      * - `tokenId` must exist.
1171      *
1172      * Emits a {Transfer} event.
1173      */
1174     function _burn(uint256 tokenId) internal virtual {
1175         address owner = ERC721B.ownerOf(tokenId);
1176 
1177         _beforeTokenTransfer(owner, address(0), tokenId);
1178 
1179         // Clear approvals
1180         _approve(address(0), tokenId);
1181         _owners[tokenId] = address(0);
1182 
1183         emit Transfer(owner, address(0), tokenId);
1184     }
1185     /**
1186      * @dev Transfers `tokenId` from `from` to `to`.
1187      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1188      *
1189      * Requirements:
1190      *
1191      * - `to` cannot be the zero address.
1192      * - `tokenId` token must be owned by `from`.
1193      *
1194      * Emits a {Transfer} event.
1195      */
1196     function _transfer(
1197         address from,
1198         address to,
1199         uint256 tokenId
1200     ) internal virtual {
1201         require(ERC721B.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1202         require(to != address(0), "ERC721: transfer to the zero address");
1203 
1204         _beforeTokenTransfer(from, to, tokenId);
1205 
1206         // Clear approvals from the previous owner
1207         _approve(address(0), tokenId);
1208         _owners[tokenId] = to;
1209 
1210         emit Transfer(from, to, tokenId);
1211     }
1212     /**
1213      * @dev Approve `to` to operate on `tokenId`
1214      *
1215      * Emits a {Approval} event.
1216      */
1217     function _approve(address to, uint256 tokenId) internal virtual {
1218         _tokenApprovals[tokenId] = to;
1219         emit Approval(ERC721B.ownerOf(tokenId), to, tokenId);
1220     }
1221     /**
1222      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1223      * The call is not executed if the target address is not a contract.
1224      *
1225      * @param from address representing the previous owner of the given token ID
1226      * @param to target address that will receive the tokens
1227      * @param tokenId uint256 ID of the token to be transferred
1228      * @param _data bytes optional data to send along with the call
1229      * @return bool whether the call correctly returned the expected magic value
1230      */
1231     function _checkOnERC721Received(
1232         address from,
1233         address to,
1234         uint256 tokenId,
1235         bytes memory _data
1236     ) private returns (bool) {
1237         if (to.isContract()) {
1238             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1239                 return retval == IERC721Receiver.onERC721Received.selector;
1240             } catch (bytes memory reason) {
1241                 if (reason.length == 0) {
1242                     revert("ERC721: transfer to non ERC721Receiver implementer");
1243                 } else {
1244                     assembly {
1245                         revert(add(32, reason), mload(reason))
1246                     }
1247                 }
1248             }
1249         } else {
1250             return true;
1251         }
1252     }
1253     /**
1254      * @dev Hook that is called before any token transfer. This includes minting
1255      * and burning.
1256      *
1257      * Calling conditions:
1258      *
1259      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1260      * transferred to `to`.
1261      * - When `from` is zero, `tokenId` will be minted for `to`.
1262      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1263      * - `from` and `to` are never both zero.
1264      *
1265      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1266      */
1267     function _beforeTokenTransfer(
1268         address from,
1269         address to,
1270         uint256 tokenId
1271     ) internal virtual {}
1272 }
1273 pragma solidity ^0.8.0;
1274 /**
1275  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1276  * enumerability of all the token ids in the contract as well as all token ids owned by each
1277  * account.
1278  */
1279 abstract contract ERC721EnumerableB is ERC721B, IERC721Enumerable {
1280     /**
1281      * @dev See {IERC165-supportsInterface}.
1282      */
1283     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721B) returns (bool) {
1284         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1285     }
1286     /**
1287      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1288      */
1289     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
1290         require(index < ERC721B.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1291         uint count;
1292         uint length = _owners.length;
1293         for( uint i; i < length; ++i ){
1294             if( owner == _owners[i] ){
1295                 if( count == index ){
1296                     delete count;
1297                     delete length;
1298                     return i;
1299                 }
1300                 else
1301                     ++count;
1302             }
1303         }
1304 
1305         delete count;
1306         delete length;
1307         require(false, "ERC721Enumerable: owner index out of bounds");
1308     }
1309     /**
1310      * @dev See {IERC721Enumerable-totalSupply}.
1311      */
1312     function totalSupply() public view virtual override returns (uint256) {
1313         return _owners.length;
1314     }
1315     /**
1316      * @dev See {IERC721Enumerable-tokenByIndex}.
1317      */
1318     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1319         require(index < ERC721EnumerableB.totalSupply(), "ERC721Enumerable: global index out of bounds");
1320         return index;
1321     }
1322 }
1323 pragma solidity ^0.8.0;
1324 //▄▄▄▄▄ ▄ .▄▄▄▄ .    ·▄▄▄      ▄▄▄   ▄▄ •       ▄▄▄▄▄▄▄▄▄▄▄▄▄ . ▐ ▄      ▄▄· ▄• ▄▌▄▄▌  ▄▄▄▄▄
1325 //•██  ██▪▐█▀▄.▀·    ▐▄▄·▪     ▀▄ █·▐█ ▀ ▪▪     •██  •██  ▀▄.▀·•█▌▐█    ▐█ ▌▪█▪██▌██•  •██  
1326 // ▐█.▪██▀▐█▐▀▀▪▄    ██▪  ▄█▀▄ ▐▀▀▄ ▄█ ▀█▄ ▄█▀▄  ▐█.▪ ▐█.▪▐▀▀▪▄▐█▐▐▌    ██ ▄▄█▌▐█▌██▪   ▐█.▪
1327 // ▐█▌·██▌▐▀▐█▄▄▌    ██▌.▐█▌.▐▌▐█•█▌▐█▄▪▐█▐█▌.▐▌ ▐█▌· ▐█▌·▐█▄▄▌██▐█▌    ▐███▌▐█▄█▌▐█▌▐▌ ▐█▌·
1328 // ▀▀▀ ▀▀▀ · ▀▀▀     ▀▀▀  ▀█▄▀▪.▀  ▀·▀▀▀▀  ▀█▄▀▪ ▀▀▀  ▀▀▀  ▀▀▀ ▀▀ █▪    ·▀▀▀  ▀▀▀ .▀▀▀  ▀▀▀ 
1329 //Ánthrōpos métron...Man is the measure of all things
1330 contract TFCContract {
1331     function ownerOf(uint256 tokenId) public view virtual returns (address) {}
1332 }
1333 contract Oracles is Delegated, ERC721EnumerableB, PaymentSplitter {
1334   using Strings for uint;
1335   TFCContract tfcContract;
1336   uint public MAX_SUPPLY = 3333;
1337   bool public isActive   = false;
1338   bool public isClaimActive = true;
1339   uint public maxSummon   = 5;
1340   uint public price      = 0.015 ether;
1341   string private _baseTokenURI = '';
1342   string private _tokenURISuffix = '';
1343   mapping(address => uint[]) private _balances;
1344   mapping (uint256 => bool) public claimed;
1345   address[] private addressList = [0x5058B704C352980ece01720cE7A5a1b49469A460];
1346   uint[] private shareList = [100];
1347   constructor(address tfcAddress)
1348     Delegated()
1349     ERC721B("The Forgotten Cult Oracles", "TFCO")
1350     PaymentSplitter(addressList, shareList)  {
1351         tfcContract = TFCContract(tfcAddress);
1352   }
1353   //external
1354   fallback() external payable {}
1355   // public minting
1356 	function Summon (uint quantity) external payable {
1357 	uint256 s = totalSupply();
1358 	require(isActive, "Public Minting is Closed" );
1359 	require(quantity > 0, "What" );
1360 	require(quantity <= maxSummon, "Don't be greedy" );
1361 	require(s + quantity <= MAX_SUPPLY, "Max Supply has been hit" );
1362 	require(msg.value >= price * quantity);
1363 	for (uint256 i = 0; i < quantity; ++i) {
1364 	_safeMint(msg.sender, s + i, "");
1365 	}
1366 	delete s;
1367   }
1368     // Claim
1369     function isDeityClaimed(uint256 deityId) public view returns (bool) {
1370         require(deityId < 3332 && deityId > 0, "Invalid Deity id");
1371         return claimed[deityId];
1372     }
1373     function DeityFreeClaim(uint256[] calldata deityIds) external {
1374         uint256 supply = totalSupply();
1375         require(isClaimActive, 'Claim not active');
1376 
1377         for (uint256 i = 0; i < deityIds.length; i++) {
1378             require(tfcContract.ownerOf(deityIds[i]) == msg.sender, "Not the Deity owner");
1379             require(claimed[deityIds[i]] == false, 'Deity already used');
1380         }
1381 
1382         for (uint256 i = 0; i < deityIds.length; i++) {
1383             // Start index at 0
1384             claimed[deityIds[i]] = true;
1385             _mint(msg.sender, supply + i + 0);
1386         }
1387     }
1388     function toggleClaimActive() external onlyOwner {
1389         isClaimActive = !isClaimActive;
1390     }
1391   //external delegated
1392   function setActive(bool isActive_) external onlyDelegates{
1393     if( isActive != isActive_ )
1394       isActive = isActive_;
1395   }
1396   function setSummon (uint maxOrder_) external onlyDelegates{
1397     if( maxSummon != maxOrder_ )
1398       maxSummon = maxOrder_;
1399   }
1400   function setPrice(uint price_ ) external onlyDelegates{
1401     if( price != price_ )
1402       price = price_;
1403   }
1404   function setBaseURI(string calldata _newBaseURI, string calldata _newSuffix) external onlyDelegates{
1405     _baseTokenURI = _newBaseURI;
1406     _tokenURISuffix = _newSuffix;
1407   }
1408   //external owner
1409   function setMaxSupply(uint maxSupply) external onlyOwner{
1410     if( MAX_SUPPLY != maxSupply ){
1411       require(maxSupply >= totalSupply(), "Specified supply is lower than current balance" );
1412       MAX_SUPPLY = maxSupply;
1413     }
1414       }
1415    function withdraw() external onlyOwner {
1416 	(bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1417 	require(success);
1418 	}  
1419   //public
1420   function balanceOf(address owner) public view virtual override returns (uint256) {
1421     require(owner != address(0), "ERC721: balance query for the zero address");
1422     return _balances[owner].length;
1423   }
1424   function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
1425     require(index < ERC721B.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1426     return _balances[owner][index];
1427   }
1428   function tokenURI(uint tokenId) external view virtual override returns (string memory) {
1429     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1430     return string(abi.encodePacked(_baseTokenURI, tokenId.toString(), _tokenURISuffix));
1431   }
1432   //internal
1433   function _beforeTokenTransfer(
1434       address from,
1435       address to,
1436       uint256 tokenId
1437   ) internal override virtual {
1438     address zero = address(0);
1439     if( from != zero || to == zero ){
1440       //find this token and remove it
1441       uint length = _balances[from].length;
1442       for( uint i; i < length; ++i ){
1443         if( _balances[from][i] == tokenId ){
1444           _balances[from][i] = _balances[from][length - 1];
1445           _balances[from].pop();
1446           break;
1447         }
1448       }
1449       delete length;
1450     }
1451     if( from == zero || to != zero ){
1452       _balances[to].push( tokenId );
1453     }
1454   }
1455 }