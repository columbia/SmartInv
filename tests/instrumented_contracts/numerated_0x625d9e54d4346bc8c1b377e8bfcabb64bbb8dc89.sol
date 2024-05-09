1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-04
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Contract module which provides a basic access control mechanism, where
33  * there is an account (an owner) that can be granted exclusive access to
34  * specific functions.
35  *
36  * By default, the owner account will be the one that deploys the contract. This
37  * can later be changed with {transferOwnership}.
38  *
39  * This module is used through inheritance. It will make available the modifier
40  * `onlyOwner`, which can be applied to your functions to restrict their use to
41  * the owner.
42  */
43 abstract contract Ownable is Context {
44     address private _owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev Initializes the contract setting the deployer as the initial owner.
50      */
51     constructor() {
52         _setOwner(_msgSender());
53     }
54 
55     /**
56      * @dev Returns the address of the current owner.
57      */
58     function owner() public view virtual returns (address) {
59         return _owner;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(owner() == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     /**
71      * @dev Leaves the contract without owner. It will not be possible to call
72      * `onlyOwner` functions anymore. Can only be called by the current owner.
73      *
74      * NOTE: Renouncing ownership will leave the contract without an owner,
75      * thereby removing any functionality that is only available to the owner.
76      */
77     function renounceOwnership() public virtual onlyOwner {
78         _setOwner(address(0));
79     }
80 
81     /**
82      * @dev Transfers ownership of the contract to a new account (`newOwner`).
83      * Can only be called by the current owner.
84      */
85     function transferOwnership(address newOwner) public virtual onlyOwner {
86         require(newOwner != address(0), "Ownable: new owner is the zero address");
87         _setOwner(newOwner);
88     }
89 
90     function _setOwner(address newOwner) private {
91         address oldOwner = _owner;
92         _owner = newOwner;
93         emit OwnershipTransferred(oldOwner, newOwner);
94     }
95 }
96 
97 pragma solidity ^0.8.0;
98 
99 /**
100  * @title PaymentSplitter
101  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
102  * that the Ether will be split in this way, since it is handled transparently by the contract.
103  *
104  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
105  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
106  * an amount proportional to the percentage of total shares they were assigned.
107  *
108  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
109  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
110  * function.
111  */
112 contract PaymentSplitter is Context {
113     event PayeeAdded(address account, uint256 shares);
114     event PaymentReleased(address to, uint256 amount);
115     event PaymentReceived(address from, uint256 amount);
116 
117     uint256 private _totalShares;
118     uint256 private _totalReleased;
119 
120     mapping(address => uint256) private _shares;
121     mapping(address => uint256) private _released;
122     address[] private _payees;
123 
124     /**
125      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
126      * the matching position in the `shares` array.
127      *
128      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
129      * duplicates in `payees`.
130      */
131     constructor(address[] memory payees, uint256[] memory shares_) payable {
132         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
133         require(payees.length > 0, "PaymentSplitter: no payees");
134 
135         for (uint256 i = 0; i < payees.length; i++) {
136             _addPayee(payees[i], shares_[i]);
137         }
138     }
139 
140     /**
141      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
142      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
143      * reliability of the events, and not the actual splitting of Ether.
144      *
145      * To learn more about this see the Solidity documentation for
146      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
147      * functions].
148      */
149     receive() external payable virtual {
150         emit PaymentReceived(_msgSender(), msg.value);
151     }
152 
153     /**
154      * @dev Getter for the total shares held by payees.
155      */
156     function totalShares() public view returns (uint256) {
157         return _totalShares;
158     }
159 
160     /**
161      * @dev Getter for the total amount of Ether already released.
162      */
163     function totalReleased() public view returns (uint256) {
164         return _totalReleased;
165     }
166 
167     /**
168      * @dev Getter for the amount of shares held by an account.
169      */
170     function shares(address account) public view returns (uint256) {
171         return _shares[account];
172     }
173 
174     /**
175      * @dev Getter for the amount of Ether already released to a payee.
176      */
177     function released(address account) public view returns (uint256) {
178         return _released[account];
179     }
180 
181     /**
182      * @dev Getter for the address of the payee number `index`.
183      */
184     function payee(uint256 index) public view returns (address) {
185         return _payees[index];
186     }
187 
188     /**
189      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
190      * total shares and their previous withdrawals.
191      */
192     function release(address payable account) public virtual {
193         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
194 
195         uint256 totalReceived = address(this).balance + _totalReleased;
196         uint256 payment = (totalReceived * _shares[account]) / _totalShares - _released[account];
197 
198         require(payment != 0, "PaymentSplitter: account is not due payment");
199 
200         _released[account] = _released[account] + payment;
201         _totalReleased = _totalReleased + payment;
202 
203         Address.sendValue(account, payment);
204         emit PaymentReleased(account, payment);
205     }
206 
207     /**
208      * @dev Add a new payee to the contract.
209      * @param account The address of the payee to add.
210      * @param shares_ The number of shares owned by the payee.
211      */
212     function _addPayee(address account, uint256 shares_) private {
213         require(account != address(0), "PaymentSplitter: account is the zero address");
214         require(shares_ > 0, "PaymentSplitter: shares are 0");
215         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
216 
217         _payees.push(account);
218         _shares[account] = shares_;
219         _totalShares = _totalShares + shares_;
220         emit PayeeAdded(account, shares_);
221     }
222 }
223 
224 pragma solidity ^0.8.0;
225 
226 /**
227  * @dev Interface of the ERC165 standard, as defined in the
228  * https://eips.ethereum.org/EIPS/eip-165[EIP].
229  *
230  * Implementers can declare support of contract interfaces, which can then be
231  * queried by others ({ERC165Checker}).
232  *
233  * For an implementation, see {ERC165}.
234  */
235 interface IERC165 {
236     /**
237      * @dev Returns true if this contract implements the interface defined by
238      * `interfaceId`. See the corresponding
239      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
240      * to learn more about how these ids are created.
241      *
242      * This function call must use less than 30 000 gas.
243      */
244     function supportsInterface(bytes4 interfaceId) external view returns (bool);
245 }
246 
247 pragma solidity ^0.8.0;
248 
249 /**
250  * @dev Required interface of an ERC721 compliant contract.
251  */
252 interface IERC721 is IERC165 {
253     /**
254      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
255      */
256     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
257 
258     /**
259      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
260      */
261     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
262 
263     /**
264      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
265      */
266     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
267 
268     /**
269      * @dev Returns the number of tokens in ``owner``'s account.
270      */
271     function balanceOf(address owner) external view returns (uint256 balance);
272 
273     /**
274      * @dev Returns the owner of the `tokenId` token.
275      *
276      * Requirements:
277      *
278      * - `tokenId` must exist.
279      */
280     function ownerOf(uint256 tokenId) external view returns (address owner);
281 
282     /**
283      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
284      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
285      *
286      * Requirements:
287      *
288      * - `from` cannot be the zero address.
289      * - `to` cannot be the zero address.
290      * - `tokenId` token must exist and be owned by `from`.
291      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
292      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
293      *
294      * Emits a {Transfer} event.
295      */
296     function safeTransferFrom(
297         address from,
298         address to,
299         uint256 tokenId
300     ) external;
301 
302     /**
303      * @dev Transfers `tokenId` token from `from` to `to`.
304      *
305      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
306      *
307      * Requirements:
308      *
309      * - `from` cannot be the zero address.
310      * - `to` cannot be the zero address.
311      * - `tokenId` token must be owned by `from`.
312      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
313      *
314      * Emits a {Transfer} event.
315      */
316     function transferFrom(
317         address from,
318         address to,
319         uint256 tokenId
320     ) external;
321 
322     /**
323      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
324      * The approval is cleared when the token is transferred.
325      *
326      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
327      *
328      * Requirements:
329      *
330      * - The caller must own the token or be an approved operator.
331      * - `tokenId` must exist.
332      *
333      * Emits an {Approval} event.
334      */
335     function approve(address to, uint256 tokenId) external;
336 
337     /**
338      * @dev Returns the account approved for `tokenId` token.
339      *
340      * Requirements:
341      *
342      * - `tokenId` must exist.
343      */
344     function getApproved(uint256 tokenId) external view returns (address operator);
345 
346     /**
347      * @dev Approve or remove `operator` as an operator for the caller.
348      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
349      *
350      * Requirements:
351      *
352      * - The `operator` cannot be the caller.
353      *
354      * Emits an {ApprovalForAll} event.
355      */
356     function setApprovalForAll(address operator, bool _approved) external;
357 
358     /**
359      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
360      *
361      * See {setApprovalForAll}
362      */
363     function isApprovedForAll(address owner, address operator) external view returns (bool);
364 
365     /**
366      * @dev Safely transfers `tokenId` token from `from` to `to`.
367      *
368      * Requirements:
369      *
370      * - `from` cannot be the zero address.
371      * - `to` cannot be the zero address.
372      * - `tokenId` token must exist and be owned by `from`.
373      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
374      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
375      *
376      * Emits a {Transfer} event.
377      */
378     function safeTransferFrom(
379         address from,
380         address to,
381         uint256 tokenId,
382         bytes calldata data
383     ) external;
384 }
385 
386 pragma solidity ^0.8.0;
387 
388 /**
389  * @title ERC721 token receiver interface
390  * @dev Interface for any contract that wants to support safeTransfers
391  * from ERC721 asset contracts.
392  */
393 interface IERC721Receiver {
394     /**
395      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
396      * by `operator` from `from`, this function is called.
397      *
398      * It must return its Solidity selector to confirm the token transfer.
399      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
400      *
401      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
402      */
403     function onERC721Received(
404         address operator,
405         address from,
406         uint256 tokenId,
407         bytes calldata data
408     ) external returns (bytes4);
409 }
410 
411 pragma solidity ^0.8.0;
412 
413 /**
414  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
415  * @dev See https://eips.ethereum.org/EIPS/eip-721
416  */
417 interface IERC721Enumerable is IERC721 {
418     /**
419      * @dev Returns the total amount of tokens stored by the contract.
420      */
421     function totalSupply() external view returns (uint256);
422 
423     /**
424      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
425      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
426      */
427     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
428 
429     /**
430      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
431      * Use along with {totalSupply} to enumerate all tokens.
432      */
433     function tokenByIndex(uint256 index) external view returns (uint256);
434 }
435 
436 pragma solidity ^0.8.0;
437 
438 /**
439  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
440  * @dev See https://eips.ethereum.org/EIPS/eip-721
441  */
442 interface IERC721Metadata is IERC721 {
443     /**
444      * @dev Returns the token collection name.
445      */
446     function name() external view returns (string memory);
447 
448     /**
449      * @dev Returns the token collection symbol.
450      */
451     function symbol() external view returns (string memory);
452 
453     /**
454      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
455      */
456     function tokenURI(uint256 tokenId) external view returns (string memory);
457 }
458 
459 pragma solidity ^0.8.0;
460 
461 /**
462  * @dev Collection of functions related to the address type
463  */
464 library Address {
465     /**
466      * @dev Returns true if `account` is a contract.
467      *
468      * [IMPORTANT]
469      * ====
470      * It is unsafe to assume that an address for which this function returns
471      * false is an externally-owned account (EOA) and not a contract.
472      *
473      * Among others, `isContract` will return false for the following
474      * types of addresses:
475      *
476      *  - an externally-owned account
477      *  - a contract in construction
478      *  - an address where a contract will be created
479      *  - an address where a contract lived, but was destroyed
480      * ====
481      */
482     function isContract(address account) internal view returns (bool) {
483         // This method relies on extcodesize, which returns 0 for contracts in
484         // construction, since the code is only stored at the end of the
485         // constructor execution.
486 
487         uint256 size;
488         assembly {
489             size := extcodesize(account)
490         }
491         return size > 0;
492     }
493 
494     /**
495      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
496      * `recipient`, forwarding all available gas and reverting on errors.
497      *
498      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
499      * of certain opcodes, possibly making contracts go over the 2300 gas limit
500      * imposed by `transfer`, making them unable to receive funds via
501      * `transfer`. {sendValue} removes this limitation.
502      *
503      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
504      *
505      * IMPORTANT: because control is transferred to `recipient`, care must be
506      * taken to not create reentrancy vulnerabilities. Consider using
507      * {ReentrancyGuard} or the
508      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
509      */
510     function sendValue(address payable recipient, uint256 amount) internal {
511         require(address(this).balance >= amount, "Address: insufficient balance");
512 
513         (bool success, ) = recipient.call{value: amount}("");
514         require(success, "Address: unable to send value, recipient may have reverted");
515     }
516 
517     /**
518      * @dev Performs a Solidity function call using a low level `call`. A
519      * plain `call` is an unsafe replacement for a function call: use this
520      * function instead.
521      *
522      * If `target` reverts with a revert reason, it is bubbled up by this
523      * function (like regular Solidity function calls).
524      *
525      * Returns the raw returned data. To convert to the expected return value,
526      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
527      *
528      * Requirements:
529      *
530      * - `target` must be a contract.
531      * - calling `target` with `data` must not revert.
532      *
533      * _Available since v3.1._
534      */
535     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
536         return functionCall(target, data, "Address: low-level call failed");
537     }
538 
539     /**
540      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
541      * `errorMessage` as a fallback revert reason when `target` reverts.
542      *
543      * _Available since v3.1._
544      */
545     function functionCall(
546         address target,
547         bytes memory data,
548         string memory errorMessage
549     ) internal returns (bytes memory) {
550         return functionCallWithValue(target, data, 0, errorMessage);
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
555      * but also transferring `value` wei to `target`.
556      *
557      * Requirements:
558      *
559      * - the calling contract must have an ETH balance of at least `value`.
560      * - the called Solidity function must be `payable`.
561      *
562      * _Available since v3.1._
563      */
564     function functionCallWithValue(
565         address target,
566         bytes memory data,
567         uint256 value
568     ) internal returns (bytes memory) {
569         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
570     }
571 
572     /**
573      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
574      * with `errorMessage` as a fallback revert reason when `target` reverts.
575      *
576      * _Available since v3.1._
577      */
578     function functionCallWithValue(
579         address target,
580         bytes memory data,
581         uint256 value,
582         string memory errorMessage
583     ) internal returns (bytes memory) {
584         require(address(this).balance >= value, "Address: insufficient balance for call");
585         require(isContract(target), "Address: call to non-contract");
586 
587         (bool success, bytes memory returndata) = target.call{value: value}(data);
588         return verifyCallResult(success, returndata, errorMessage);
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
593      * but performing a static call.
594      *
595      * _Available since v3.3._
596      */
597     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
598         return functionStaticCall(target, data, "Address: low-level static call failed");
599     }
600 
601     /**
602      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
603      * but performing a static call.
604      *
605      * _Available since v3.3._
606      */
607     function functionStaticCall(
608         address target,
609         bytes memory data,
610         string memory errorMessage
611     ) internal view returns (bytes memory) {
612         require(isContract(target), "Address: static call to non-contract");
613 
614         (bool success, bytes memory returndata) = target.staticcall(data);
615         return verifyCallResult(success, returndata, errorMessage);
616     }
617 
618     /**
619      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
620      * but performing a delegate call.
621      *
622      * _Available since v3.4._
623      */
624     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
625         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
626     }
627 
628     /**
629      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
630      * but performing a delegate call.
631      *
632      * _Available since v3.4._
633      */
634     function functionDelegateCall(
635         address target,
636         bytes memory data,
637         string memory errorMessage
638     ) internal returns (bytes memory) {
639         require(isContract(target), "Address: delegate call to non-contract");
640 
641         (bool success, bytes memory returndata) = target.delegatecall(data);
642         return verifyCallResult(success, returndata, errorMessage);
643     }
644 
645     /**
646      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
647      * revert reason using the provided one.
648      *
649      * _Available since v4.3._
650      */
651     function verifyCallResult(
652         bool success,
653         bytes memory returndata,
654         string memory errorMessage
655     ) internal pure returns (bytes memory) {
656         if (success) {
657             return returndata;
658         } else {
659             // Look for revert reason and bubble it up if present
660             if (returndata.length > 0) {
661                 // The easiest way to bubble the revert reason is using memory via assembly
662 
663                 assembly {
664                     let returndata_size := mload(returndata)
665                     revert(add(32, returndata), returndata_size)
666                 }
667             } else {
668                 revert(errorMessage);
669             }
670         }
671     }
672 }
673 
674 pragma solidity ^0.8.0;
675 
676 /**
677  * @dev String operations.
678  */
679 library Strings {
680     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
681 
682     /**
683      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
684      */
685     function toString(uint256 value) internal pure returns (string memory) {
686         // Inspired by OraclizeAPI's implementation - MIT licence
687         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
688 
689         if (value == 0) {
690             return "0";
691         }
692         uint256 temp = value;
693         uint256 digits;
694         while (temp != 0) {
695             digits++;
696             temp /= 10;
697         }
698         bytes memory buffer = new bytes(digits);
699         while (value != 0) {
700             digits -= 1;
701             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
702             value /= 10;
703         }
704         return string(buffer);
705     }
706 
707     /**
708      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
709      */
710     function toHexString(uint256 value) internal pure returns (string memory) {
711         if (value == 0) {
712             return "0x00";
713         }
714         uint256 temp = value;
715         uint256 length = 0;
716         while (temp != 0) {
717             length++;
718             temp >>= 8;
719         }
720         return toHexString(value, length);
721     }
722 
723     /**
724      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
725      */
726     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
727         bytes memory buffer = new bytes(2 * length + 2);
728         buffer[0] = "0";
729         buffer[1] = "x";
730         for (uint256 i = 2 * length + 1; i > 1; --i) {
731             buffer[i] = _HEX_SYMBOLS[value & 0xf];
732             value >>= 4;
733         }
734         require(value == 0, "Strings: hex length insufficient");
735         return string(buffer);
736     }
737 }
738 
739 pragma solidity ^0.8.0;
740 
741 /**
742  * @dev Implementation of the {IERC165} interface.
743  *
744  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
745  * for the additional interface id that will be supported. For example:
746  *
747  * ```solidity
748  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
749  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
750  * }
751  * ```
752  *
753  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
754  */
755 abstract contract ERC165 is IERC165 {
756     /**
757      * @dev See {IERC165-supportsInterface}.
758      */
759     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
760         return interfaceId == type(IERC165).interfaceId;
761     }
762 }
763 
764 pragma solidity ^0.8.0;
765 
766 // CAUTION
767 // This version of SafeMath should only be used with Solidity 0.8 or later,
768 // because it relies on the compiler's built in overflow checks.
769 
770 /**
771  * @dev Wrappers over Solidity's arithmetic operations.
772  *
773  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
774  * now has built in overflow checking.
775  */
776 library SafeMath {
777     /**
778      * @dev Returns the addition of two unsigned integers, with an overflow flag.
779      *
780      * _Available since v3.4._
781      */
782     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
783         unchecked {
784             uint256 c = a + b;
785             if (c < a) return (false, 0);
786             return (true, c);
787         }
788     }
789 
790     /**
791      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
792      *
793      * _Available since v3.4._
794      */
795     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
796         unchecked {
797             if (b > a) return (false, 0);
798             return (true, a - b);
799         }
800     }
801 
802     /**
803      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
804      *
805      * _Available since v3.4._
806      */
807     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
808         unchecked {
809             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
810             // benefit is lost if 'b' is also tested.
811             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
812             if (a == 0) return (true, 0);
813             uint256 c = a * b;
814             if (c / a != b) return (false, 0);
815             return (true, c);
816         }
817     }
818 
819     /**
820      * @dev Returns the division of two unsigned integers, with a division by zero flag.
821      *
822      * _Available since v3.4._
823      */
824     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
825         unchecked {
826             if (b == 0) return (false, 0);
827             return (true, a / b);
828         }
829     }
830 
831     /**
832      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
833      *
834      * _Available since v3.4._
835      */
836     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
837         unchecked {
838             if (b == 0) return (false, 0);
839             return (true, a % b);
840         }
841     }
842 
843     /**
844      * @dev Returns the addition of two unsigned integers, reverting on
845      * overflow.
846      *
847      * Counterpart to Solidity's `+` operator.
848      *
849      * Requirements:
850      *
851      * - Addition cannot overflow.
852      */
853     function add(uint256 a, uint256 b) internal pure returns (uint256) {
854         return a + b;
855     }
856 
857     /**
858      * @dev Returns the subtraction of two unsigned integers, reverting on
859      * overflow (when the result is negative).
860      *
861      * Counterpart to Solidity's `-` operator.
862      *
863      * Requirements:
864      *
865      * - Subtraction cannot overflow.
866      */
867     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
868         return a - b;
869     }
870 
871     /**
872      * @dev Returns the multiplication of two unsigned integers, reverting on
873      * overflow.
874      *
875      * Counterpart to Solidity's `*` operator.
876      *
877      * Requirements:
878      *
879      * - Multiplication cannot overflow.
880      */
881     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
882         return a * b;
883     }
884 
885     /**
886      * @dev Returns the integer division of two unsigned integers, reverting on
887      * division by zero. The result is rounded towards zero.
888      *
889      * Counterpart to Solidity's `/` operator.
890      *
891      * Requirements:
892      *
893      * - The divisor cannot be zero.
894      */
895     function div(uint256 a, uint256 b) internal pure returns (uint256) {
896         return a / b;
897     }
898 
899     /**
900      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
901      * reverting when dividing by zero.
902      *
903      * Counterpart to Solidity's `%` operator. This function uses a `revert`
904      * opcode (which leaves remaining gas untouched) while Solidity uses an
905      * invalid opcode to revert (consuming all remaining gas).
906      *
907      * Requirements:
908      *
909      * - The divisor cannot be zero.
910      */
911     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
912         return a % b;
913     }
914 
915     /**
916      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
917      * overflow (when the result is negative).
918      *
919      * CAUTION: This function is deprecated because it requires allocating memory for the error
920      * message unnecessarily. For custom revert reasons use {trySub}.
921      *
922      * Counterpart to Solidity's `-` operator.
923      *
924      * Requirements:
925      *
926      * - Subtraction cannot overflow.
927      */
928     function sub(
929         uint256 a,
930         uint256 b,
931         string memory errorMessage
932     ) internal pure returns (uint256) {
933         unchecked {
934             require(b <= a, errorMessage);
935             return a - b;
936         }
937     }
938 
939     /**
940      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
941      * division by zero. The result is rounded towards zero.
942      *
943      * Counterpart to Solidity's `/` operator. Note: this function uses a
944      * `revert` opcode (which leaves remaining gas untouched) while Solidity
945      * uses an invalid opcode to revert (consuming all remaining gas).
946      *
947      * Requirements:
948      *
949      * - The divisor cannot be zero.
950      */
951     function div(
952         uint256 a,
953         uint256 b,
954         string memory errorMessage
955     ) internal pure returns (uint256) {
956         unchecked {
957             require(b > 0, errorMessage);
958             return a / b;
959         }
960     }
961 
962     /**
963      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
964      * reverting with custom message when dividing by zero.
965      *
966      * CAUTION: This function is deprecated because it requires allocating memory for the error
967      * message unnecessarily. For custom revert reasons use {tryMod}.
968      *
969      * Counterpart to Solidity's `%` operator. This function uses a `revert`
970      * opcode (which leaves remaining gas untouched) while Solidity uses an
971      * invalid opcode to revert (consuming all remaining gas).
972      *
973      * Requirements:
974      *
975      * - The divisor cannot be zero.
976      */
977     function mod(
978         uint256 a,
979         uint256 b,
980         string memory errorMessage
981     ) internal pure returns (uint256) {
982         unchecked {
983             require(b > 0, errorMessage);
984             return a % b;
985         }
986     }
987 }
988 
989 pragma solidity ^0.8.0;
990 
991 contract Delegated is Ownable{
992   mapping(address => bool) internal _delegates;
993 
994   constructor(){
995     _delegates[owner()] = true;
996   }
997 
998   modifier onlyDelegates {
999     require(_delegates[msg.sender], "Invalid delegate" );
1000     _;
1001   }
1002 
1003   //onlyOwner
1004   function isDelegate( address addr ) external view onlyOwner returns ( bool ){
1005     return _delegates[addr];
1006   }
1007 
1008   function setDelegate( address addr, bool isDelegate_ ) external onlyOwner{
1009     _delegates[addr] = isDelegate_;
1010   }
1011 }
1012 
1013 pragma solidity ^0.8.0;
1014 
1015 abstract contract ERC721B is Context, ERC165, IERC721, IERC721Metadata {
1016     using Address for address;
1017 
1018     // Token name
1019     string private _name;
1020 
1021     // Token symbol
1022     string private _symbol;
1023 
1024     // Mapping from token ID to owner address
1025     address[] internal _owners;
1026 
1027     // Mapping from token ID to approved address
1028     mapping(uint256 => address) private _tokenApprovals;
1029 
1030     // Mapping from owner to operator approvals
1031     mapping(address => mapping(address => bool)) private _operatorApprovals;
1032 
1033     /**
1034      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1035      */
1036     constructor(string memory name_, string memory symbol_) {
1037         _name = name_;
1038         _symbol = symbol_;
1039     }
1040 
1041     /**
1042      * @dev See {IERC165-supportsInterface}.
1043      */
1044     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1045         return
1046             interfaceId == type(IERC721).interfaceId ||
1047             interfaceId == type(IERC721Metadata).interfaceId ||
1048             super.supportsInterface(interfaceId);
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-balanceOf}.
1053      */
1054     function balanceOf(address owner) public view virtual override returns (uint256) {
1055         require(owner != address(0), "ERC721: balance query for the zero address");
1056 
1057         uint count = 0;
1058         uint length = _owners.length;
1059         for( uint i = 0; i < length; ++i ){
1060           if( owner == _owners[i] ){
1061             ++count;
1062           }
1063         }
1064 
1065         delete length;
1066         return count;
1067     }
1068 
1069     /**
1070      * @dev See {IERC721-ownerOf}.
1071      */
1072     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1073         address owner = _owners[tokenId];
1074         require(owner != address(0), "ERC721: owner query for nonexistent token");
1075         return owner;
1076     }
1077 
1078     /**
1079      * @dev See {IERC721Metadata-name}.
1080      */
1081     function name() public view virtual override returns (string memory) {
1082         return _name;
1083     }
1084 
1085     /**
1086      * @dev See {IERC721Metadata-symbol}.
1087      */
1088     function symbol() public view virtual override returns (string memory) {
1089         return _symbol;
1090     }
1091 
1092     /**
1093      * @dev See {IERC721-approve}.
1094      */
1095     function approve(address to, uint256 tokenId) public virtual override {
1096         address owner = ERC721B.ownerOf(tokenId);
1097         require(to != owner, "ERC721: approval to current owner");
1098 
1099         require(
1100             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1101             "ERC721: approve caller is not owner nor approved for all"
1102         );
1103 
1104         _approve(to, tokenId);
1105     }
1106 
1107     /**
1108      * @dev See {IERC721-getApproved}.
1109      */
1110     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1111         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1112 
1113         return _tokenApprovals[tokenId];
1114     }
1115 
1116     /**
1117      * @dev See {IERC721-setApprovalForAll}.
1118      */
1119     function setApprovalForAll(address operator, bool approved) public virtual override {
1120         require(operator != _msgSender(), "ERC721: approve to caller");
1121 
1122         _operatorApprovals[_msgSender()][operator] = approved;
1123         emit ApprovalForAll(_msgSender(), operator, approved);
1124     }
1125 
1126     /**
1127      * @dev See {IERC721-isApprovedForAll}.
1128      */
1129     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1130         return _operatorApprovals[owner][operator];
1131     }
1132 
1133 
1134     /**
1135      * @dev See {IERC721-transferFrom}.
1136      */
1137     function transferFrom(
1138         address from,
1139         address to,
1140         uint256 tokenId
1141     ) public virtual override {
1142         //solhint-disable-next-line max-line-length
1143         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1144 
1145         _transfer(from, to, tokenId);
1146     }
1147 
1148     /**
1149      * @dev See {IERC721-safeTransferFrom}.
1150      */
1151     function safeTransferFrom(
1152         address from,
1153         address to,
1154         uint256 tokenId
1155     ) public virtual override {
1156         safeTransferFrom(from, to, tokenId, "");
1157     }
1158 
1159     /**
1160      * @dev See {IERC721-safeTransferFrom}.
1161      */
1162     function safeTransferFrom(
1163         address from,
1164         address to,
1165         uint256 tokenId,
1166         bytes memory _data
1167     ) public virtual override {
1168         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1169         _safeTransfer(from, to, tokenId, _data);
1170     }
1171 
1172     /**
1173      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1174      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1175      *
1176      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1177      *
1178      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1179      * implement alternative mechanisms to perform token transfer, such as signature-based.
1180      *
1181      * Requirements:
1182      *
1183      * - `from` cannot be the zero address.
1184      * - `to` cannot be the zero address.
1185      * - `tokenId` token must exist and be owned by `from`.
1186      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1187      *
1188      * Emits a {Transfer} event.
1189      */
1190     function _safeTransfer(
1191         address from,
1192         address to,
1193         uint256 tokenId,
1194         bytes memory _data
1195     ) internal virtual {
1196         _transfer(from, to, tokenId);
1197         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1198     }
1199 
1200     /**
1201      * @dev Returns whether `tokenId` exists.
1202      *
1203      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1204      *
1205      * Tokens start existing when they are minted (`_mint`),
1206      * and stop existing when they are burned (`_burn`).
1207      */
1208     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1209         return tokenId < _owners.length && _owners[tokenId] != address(0);
1210     }
1211 
1212     /**
1213      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1214      *
1215      * Requirements:
1216      *
1217      * - `tokenId` must exist.
1218      */
1219     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1220         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1221         address owner = ERC721B.ownerOf(tokenId);
1222         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1223     }
1224 
1225     /**
1226      * @dev Safely mints `tokenId` and transfers it to `to`.
1227      *
1228      * Requirements:
1229      *
1230      * - `tokenId` must not exist.
1231      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1232      *
1233      * Emits a {Transfer} event.
1234      */
1235     function _safeMint(address to, uint256 tokenId) internal virtual {
1236         _safeMint(to, tokenId, "");
1237     }
1238 
1239 
1240     /**
1241      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1242      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1243      */
1244     function _safeMint(
1245         address to,
1246         uint256 tokenId,
1247         bytes memory _data
1248     ) internal virtual {
1249         _mint(to, tokenId);
1250         require(
1251             _checkOnERC721Received(address(0), to, tokenId, _data),
1252             "ERC721: transfer to non ERC721Receiver implementer"
1253         );
1254     }
1255 
1256     /**
1257      * @dev Mints `tokenId` and transfers it to `to`.
1258      *
1259      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1260      *
1261      * Requirements:
1262      *
1263      * - `tokenId` must not exist.
1264      * - `to` cannot be the zero address.
1265      *
1266      * Emits a {Transfer} event.
1267      */
1268     function _mint(address to, uint256 tokenId) internal virtual {
1269         require(to != address(0), "ERC721: mint to the zero address");
1270         require(!_exists(tokenId), "ERC721: token already minted");
1271 
1272         _beforeTokenTransfer(address(0), to, tokenId);
1273         _owners.push(to);
1274 
1275         emit Transfer(address(0), to, tokenId);
1276     }
1277 
1278     /**
1279      * @dev Destroys `tokenId`.
1280      * The approval is cleared when the token is burned.
1281      *
1282      * Requirements:
1283      *
1284      * - `tokenId` must exist.
1285      *
1286      * Emits a {Transfer} event.
1287      */
1288     function _burn(uint256 tokenId) internal virtual {
1289         address owner = ERC721B.ownerOf(tokenId);
1290 
1291         _beforeTokenTransfer(owner, address(0), tokenId);
1292 
1293         // Clear approvals
1294         _approve(address(0), tokenId);
1295         _owners[tokenId] = address(0);
1296 
1297         emit Transfer(owner, address(0), tokenId);
1298     }
1299 
1300     /**
1301      * @dev Transfers `tokenId` from `from` to `to`.
1302      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1303      *
1304      * Requirements:
1305      *
1306      * - `to` cannot be the zero address.
1307      * - `tokenId` token must be owned by `from`.
1308      *
1309      * Emits a {Transfer} event.
1310      */
1311     function _transfer(
1312         address from,
1313         address to,
1314         uint256 tokenId
1315     ) internal virtual {
1316         require(ERC721B.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1317         require(to != address(0), "ERC721: transfer to the zero address");
1318 
1319         _beforeTokenTransfer(from, to, tokenId);
1320 
1321         // Clear approvals from the previous owner
1322         _approve(address(0), tokenId);
1323         _owners[tokenId] = to;
1324 
1325         emit Transfer(from, to, tokenId);
1326     }
1327 
1328     /**
1329      * @dev Approve `to` to operate on `tokenId`
1330      *
1331      * Emits a {Approval} event.
1332      */
1333     function _approve(address to, uint256 tokenId) internal virtual {
1334         _tokenApprovals[tokenId] = to;
1335         emit Approval(ERC721B.ownerOf(tokenId), to, tokenId);
1336     }
1337 
1338 
1339     /**
1340      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1341      * The call is not executed if the target address is not a contract.
1342      *
1343      * @param from address representing the previous owner of the given token ID
1344      * @param to target address that will receive the tokens
1345      * @param tokenId uint256 ID of the token to be transferred
1346      * @param _data bytes optional data to send along with the call
1347      * @return bool whether the call correctly returned the expected magic value
1348      */
1349     function _checkOnERC721Received(
1350         address from,
1351         address to,
1352         uint256 tokenId,
1353         bytes memory _data
1354     ) private returns (bool) {
1355         if (to.isContract()) {
1356             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1357                 return retval == IERC721Receiver.onERC721Received.selector;
1358             } catch (bytes memory reason) {
1359                 if (reason.length == 0) {
1360                     revert("ERC721: transfer to non ERC721Receiver implementer");
1361                 } else {
1362                     assembly {
1363                         revert(add(32, reason), mload(reason))
1364                     }
1365                 }
1366             }
1367         } else {
1368             return true;
1369         }
1370     }
1371 
1372     /**
1373      * @dev Hook that is called before any token transfer. This includes minting
1374      * and burning.
1375      *
1376      * Calling conditions:
1377      *
1378      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1379      * transferred to `to`.
1380      * - When `from` is zero, `tokenId` will be minted for `to`.
1381      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1382      * - `from` and `to` are never both zero.
1383      *
1384      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1385      */
1386     function _beforeTokenTransfer(
1387         address from,
1388         address to,
1389         uint256 tokenId
1390     ) internal virtual {}
1391 }
1392 
1393 pragma solidity ^0.8.0;
1394 /**
1395  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1396  * enumerability of all the token ids in the contract as well as all token ids owned by each
1397  * account.
1398  */
1399 abstract contract ERC721EnumerableB is ERC721B, IERC721Enumerable {
1400     /**
1401      * @dev See {IERC165-supportsInterface}.
1402      */
1403     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721B) returns (bool) {
1404         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1405     }
1406 
1407     /**
1408      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1409      */
1410     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
1411         require(index < ERC721B.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1412 
1413         uint count;
1414         uint length = _owners.length;
1415         for( uint i; i < length; ++i ){
1416             if( owner == _owners[i] ){
1417                 if( count == index ){
1418                     delete count;
1419                     delete length;
1420                     return i;
1421                 }
1422                 else
1423                     ++count;
1424             }
1425         }
1426 
1427         delete count;
1428         delete length;
1429         require(false, "ERC721Enumerable: owner index out of bounds");
1430     }
1431 
1432     /**
1433      * @dev See {IERC721Enumerable-totalSupply}.
1434      */
1435     function totalSupply() public view virtual override returns (uint256) {
1436         return _owners.length;
1437     }
1438 
1439     /**
1440      * @dev See {IERC721Enumerable-tokenByIndex}.
1441      */
1442     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1443         require(index < ERC721EnumerableB.totalSupply(), "ERC721Enumerable: global index out of bounds");
1444         return index;
1445     }
1446 }
1447 
1448 pragma solidity ^0.8.0;
1449 //▄▄▄▄▄ ▄ .▄▄▄▄ .    ·▄▄▄      ▄▄▄   ▄▄ •       ▄▄▄▄▄▄▄▄▄▄▄▄▄ . ▐ ▄      ▄▄· ▄• ▄▌▄▄▌  ▄▄▄▄▄
1450 //•██  ██▪▐█▀▄.▀·    ▐▄▄·▪     ▀▄ █·▐█ ▀ ▪▪     •██  •██  ▀▄.▀·•█▌▐█    ▐█ ▌▪█▪██▌██•  •██  
1451 // ▐█.▪██▀▐█▐▀▀▪▄    ██▪  ▄█▀▄ ▐▀▀▄ ▄█ ▀█▄ ▄█▀▄  ▐█.▪ ▐█.▪▐▀▀▪▄▐█▐▐▌    ██ ▄▄█▌▐█▌██▪   ▐█.▪
1452 // ▐█▌·██▌▐▀▐█▄▄▌    ██▌.▐█▌.▐▌▐█•█▌▐█▄▪▐█▐█▌.▐▌ ▐█▌· ▐█▌·▐█▄▄▌██▐█▌    ▐███▌▐█▄█▌▐█▌▐▌ ▐█▌·
1453 // ▀▀▀ ▀▀▀ · ▀▀▀     ▀▀▀  ▀█▄▀▪.▀  ▀·▀▀▀▀  ▀█▄▀▪ ▀▀▀  ▀▀▀  ▀▀▀ ▀▀ █▪    ·▀▀▀  ▀▀▀ .▀▀▀  ▀▀▀ 
1454 //Ánthrōpos métron...Man is the measure of all things
1455 
1456 contract TFC is Delegated, ERC721EnumerableB, PaymentSplitter {
1457   using Strings for uint;
1458 
1459   uint public MAX_SUPPLY = 3333;
1460 
1461   bool public isActive   = true;
1462   uint public maxSummon   = 3;
1463   uint public price      = 0 ether;
1464 
1465   string private _baseTokenURI = '';
1466   string private _tokenURISuffix = '';
1467 
1468   mapping(address => uint[]) private _balances;
1469 
1470   address[] private addressList = [0x5058B704C352980ece01720cE7A5a1b49469A460];
1471   uint[] private shareList = [100];
1472 
1473   constructor()
1474     Delegated()
1475     ERC721B("The Forgotten Cult", "TFC")
1476     PaymentSplitter(addressList, shareList)  {
1477   }
1478 
1479   //external
1480   fallback() external payable {}
1481 
1482   function mint( uint quantity ) external payable {
1483     require( isActive,                      "Sale is not active"        );
1484     require( quantity <= maxSummon,          "Summon too big"             );
1485     require( msg.value >= price * quantity, "Ether sent is not correct" );
1486 
1487     uint256 supply = totalSupply();
1488     require( supply + quantity <= MAX_SUPPLY, "Summon/order exceeds supply" );
1489     for(uint i = 0; i < quantity; ++i){
1490       _safeMint( msg.sender, supply++, "" );
1491     }
1492   }
1493 
1494   //external delegated
1495   function gift(uint[] calldata quantity, address[] calldata recipient) external onlyDelegates{
1496     require(quantity.length == recipient.length, "Must provide equal quantities and recipients" );
1497 
1498     uint totalQuantity = 0;
1499     uint256 supply = totalSupply();
1500     for(uint i = 0; i < quantity.length; ++i){
1501       totalQuantity += quantity[i];
1502     }
1503     require( supply + totalQuantity <= MAX_SUPPLY, "Mint/order exceeds supply" );
1504     delete totalQuantity;
1505 
1506     for(uint i = 0; i < recipient.length; ++i){
1507       for(uint j = 0; j < quantity[i]; ++j){
1508         _safeMint( recipient[i], supply++, "Sent with love" );
1509       }
1510     }
1511   }
1512 
1513   function setActive(bool isActive_) external onlyDelegates{
1514     if( isActive != isActive_ )
1515       isActive = isActive_;
1516   }
1517 
1518   function setSummon (uint maxOrder_) external onlyDelegates{
1519     if( maxSummon != maxOrder_ )
1520       maxSummon = maxOrder_;
1521   }
1522 
1523   function setPrice(uint price_ ) external onlyDelegates{
1524     if( price != price_ )
1525       price = price_;
1526   }
1527 
1528   function setBaseURI(string calldata _newBaseURI, string calldata _newSuffix) external onlyDelegates{
1529     _baseTokenURI = _newBaseURI;
1530     _tokenURISuffix = _newSuffix;
1531   }
1532 
1533 
1534   //external owner
1535   function setMaxSupply(uint maxSupply) external onlyOwner{
1536     if( MAX_SUPPLY != maxSupply ){
1537       require(maxSupply >= totalSupply(), "Specified supply is lower than current balance" );
1538       MAX_SUPPLY = maxSupply;
1539     }
1540   }
1541 
1542 
1543   //public
1544   function balanceOf(address owner) public view virtual override returns (uint256) {
1545     require(owner != address(0), "ERC721: balance query for the zero address");
1546     return _balances[owner].length;
1547   }
1548 
1549   function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
1550     require(index < ERC721B.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1551     return _balances[owner][index];
1552   }
1553 
1554   function tokenURI(uint tokenId) external view virtual override returns (string memory) {
1555     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1556     return string(abi.encodePacked(_baseTokenURI, tokenId.toString(), _tokenURISuffix));
1557   }
1558 
1559 
1560   //internal
1561   function _beforeTokenTransfer(
1562       address from,
1563       address to,
1564       uint256 tokenId
1565   ) internal override virtual {
1566     address zero = address(0);
1567     if( from != zero || to == zero ){
1568       //find this token and remove it
1569       uint length = _balances[from].length;
1570       for( uint i; i < length; ++i ){
1571         if( _balances[from][i] == tokenId ){
1572           _balances[from][i] = _balances[from][length - 1];
1573           _balances[from].pop();
1574           break;
1575         }
1576       }
1577       delete length;
1578     }
1579 
1580     if( from == zero || to != zero ){
1581       _balances[to].push( tokenId );
1582     }
1583   }
1584 }