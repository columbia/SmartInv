1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.7;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(
63         address sender,
64         address recipient,
65         uint256 amount
66     ) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 // File: @openzeppelin/contracts/utils/Strings.sol
84 /**
85  * @dev String operations.
86  */
87 library Strings {
88     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
89 
90     /**
91      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
92      */
93     function toString(uint256 value) internal pure returns (string memory) {
94         // Inspired by OraclizeAPI's implementation - MIT licence
95         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
96 
97         if (value == 0) {
98             return "0";
99         }
100         uint256 temp = value;
101         uint256 digits;
102         while (temp != 0) {
103             digits++;
104             temp /= 10;
105         }
106         bytes memory buffer = new bytes(digits);
107         while (value != 0) {
108             digits -= 1;
109             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
110             value /= 10;
111         }
112         return string(buffer);
113     }
114 
115     /**
116      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
117      */
118     function toHexString(uint256 value) internal pure returns (string memory) {
119         if (value == 0) {
120             return "0x00";
121         }
122         uint256 temp = value;
123         uint256 length = 0;
124         while (temp != 0) {
125             length++;
126             temp >>= 8;
127         }
128         return toHexString(value, length);
129     }
130 
131     /**
132      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
133      */
134     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
135         bytes memory buffer = new bytes(2 * length + 2);
136         buffer[0] = "0";
137         buffer[1] = "x";
138         for (uint256 i = 2 * length + 1; i > 1; --i) {
139             buffer[i] = _HEX_SYMBOLS[value & 0xf];
140             value >>= 4;
141         }
142         require(value == 0, "Strings: hex length insufficient");
143         return string(buffer);
144     }
145 }
146 
147 // File: @openzeppelin/contracts/utils/Context.sol
148 /**
149  * @dev Provides information about the current execution context, including the
150  * sender of the transaction and its data. While these are generally available
151  * via msg.sender and msg.data, they should not be accessed in such a direct
152  * manner, since when dealing with meta-transactions the account sending and
153  * paying for execution may not be the actual sender (as far as an application
154  * is concerned).
155  *
156  * This contract is only required for intermediate, library-like contracts.
157  */
158 abstract contract Context {
159     function _msgSender() internal view virtual returns (address) {
160         return msg.sender;
161     }
162 
163     function _msgData() internal view virtual returns (bytes calldata) {
164         return msg.data;
165     }
166 }
167 
168 // File: @openzeppelin/contracts/utils/Address.sol
169 
170 /**
171  * @dev Collection of functions related to the address type
172  */
173 library Address {
174     /**
175      * @dev Returns true if `account` is a contract.
176      *
177      * [IMPORTANT]
178      * ====
179      * It is unsafe to assume that an address for which this function returns
180      * false is an externally-owned account (EOA) and not a contract.
181      *
182      * Among others, `isContract` will return false for the following
183      * types of addresses:
184      *
185      *  - an externally-owned account
186      *  - a contract in construction
187      *  - an address where a contract will be created
188      *  - an address where a contract lived, but was destroyed
189      * ====
190      */
191     function isContract(address account) internal view returns (bool) {
192         // This method relies on extcodesize, which returns 0 for contracts in
193         // construction, since the code is only stored at the end of the
194         // constructor execution.
195 
196         uint256 size;
197         assembly {
198             size := extcodesize(account)
199         }
200         return size > 0;
201     }
202 
203     /**
204      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
205      * `recipient`, forwarding all available gas and reverting on errors.
206      *
207      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
208      * of certain opcodes, possibly making contracts go over the 2300 gas limit
209      * imposed by `transfer`, making them unable to receive funds via
210      * `transfer`. {sendValue} removes this limitation.
211      *
212      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
213      *
214      * IMPORTANT: because control is transferred to `recipient`, care must be
215      * taken to not create reentrancy vulnerabilities. Consider using
216      * {ReentrancyGuard} or the
217      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
218      */
219     function sendValue(address payable recipient, uint256 amount) internal {
220         require(address(this).balance >= amount, "Address: insufficient balance");
221 
222         (bool success, ) = recipient.call{value: amount}("");
223         require(success, "Address: unable to send value, recipient may have reverted");
224     }
225 
226     /**
227      * @dev Performs a Solidity function call using a low level `call`. A
228      * plain `call` is an unsafe replacement for a function call: use this
229      * function instead.
230      *
231      * If `target` reverts with a revert reason, it is bubbled up by this
232      * function (like regular Solidity function calls).
233      *
234      * Returns the raw returned data. To convert to the expected return value,
235      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
236      *
237      * Requirements:
238      *
239      * - `target` must be a contract.
240      * - calling `target` with `data` must not revert.
241      *
242      * _Available since v3.1._
243      */
244     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
245         return functionCall(target, data, "Address: low-level call failed");
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
250      * `errorMessage` as a fallback revert reason when `target` reverts.
251      *
252      * _Available since v3.1._
253      */
254     function functionCall(
255         address target,
256         bytes memory data,
257         string memory errorMessage
258     ) internal returns (bytes memory) {
259         return functionCallWithValue(target, data, 0, errorMessage);
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
264      * but also transferring `value` wei to `target`.
265      *
266      * Requirements:
267      *
268      * - the calling contract must have an ETH balance of at least `value`.
269      * - the called Solidity function must be `payable`.
270      *
271      * _Available since v3.1._
272      */
273     function functionCallWithValue(
274         address target,
275         bytes memory data,
276         uint256 value
277     ) internal returns (bytes memory) {
278         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
283      * with `errorMessage` as a fallback revert reason when `target` reverts.
284      *
285      * _Available since v3.1._
286      */
287     function functionCallWithValue(
288         address target,
289         bytes memory data,
290         uint256 value,
291         string memory errorMessage
292     ) internal returns (bytes memory) {
293         require(address(this).balance >= value, "Address: insufficient balance for call");
294         require(isContract(target), "Address: call to non-contract");
295 
296         (bool success, bytes memory returndata) = target.call{value: value}(data);
297         return verifyCallResult(success, returndata, errorMessage);
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
302      * but performing a static call.
303      *
304      * _Available since v3.3._
305      */
306     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
307         return functionStaticCall(target, data, "Address: low-level static call failed");
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
312      * but performing a static call.
313      *
314      * _Available since v3.3._
315      */
316     function functionStaticCall(
317         address target,
318         bytes memory data,
319         string memory errorMessage
320     ) internal view returns (bytes memory) {
321         require(isContract(target), "Address: static call to non-contract");
322 
323         (bool success, bytes memory returndata) = target.staticcall(data);
324         return verifyCallResult(success, returndata, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but performing a delegate call.
330      *
331      * _Available since v3.4._
332      */
333     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
334         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
339      * but performing a delegate call.
340      *
341      * _Available since v3.4._
342      */
343     function functionDelegateCall(
344         address target,
345         bytes memory data,
346         string memory errorMessage
347     ) internal returns (bytes memory) {
348         require(isContract(target), "Address: delegate call to non-contract");
349 
350         (bool success, bytes memory returndata) = target.delegatecall(data);
351         return verifyCallResult(success, returndata, errorMessage);
352     }
353 
354     /**
355      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
356      * revert reason using the provided one.
357      *
358      * _Available since v4.3._
359      */
360     function verifyCallResult(
361         bool success,
362         bytes memory returndata,
363         string memory errorMessage
364     ) internal pure returns (bytes memory) {
365         if (success) {
366             return returndata;
367         } else {
368             // Look for revert reason and bubble it up if present
369             if (returndata.length > 0) {
370                 // The easiest way to bubble the revert reason is using memory via assembly
371 
372                 assembly {
373                     let returndata_size := mload(returndata)
374                     revert(add(32, returndata), returndata_size)
375                 }
376             } else {
377                 revert(errorMessage);
378             }
379         }
380     }
381 }
382 
383 // File: @openzeppelin/contracts/utils/Counters.sol
384 /**
385  * @title Counters
386  * @author Matt Condon (@shrugs)
387  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
388  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
389  *
390  * Include with `using Counters for Counters.Counter;`
391  */
392 library Counters {
393     struct Counter {
394         // This variable should never be directly accessed by users of the library: interactions must be restricted to
395         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
396         // this feature: see https://github.com/ethereum/solidity/issues/4637
397         uint256 _value; // default: 0
398     }
399 
400     function current(Counter storage counter) internal view returns (uint256) {
401         return counter._value;
402     }
403 
404     function increment(Counter storage counter) internal {
405         unchecked {
406             counter._value += 1;
407         }
408     }
409 
410     function decrement(Counter storage counter) internal {
411         uint256 value = counter._value;
412         require(value > 0, "Counter: decrement overflow");
413         unchecked {
414             counter._value = value - 1;
415         }
416     }
417 
418     function reset(Counter storage counter) internal {
419         counter._value = 0;
420     }
421 }
422 
423 // File: @openzeppelin/contracts/access/Ownable.sol
424 /**
425  * @dev Contract module which provides a basic access control mechanism, where
426  * there is an account (an owner) that can be granted exclusive access to
427  * specific functions.
428  *
429  * By default, the owner account will be the one that deploys the contract. This
430  * can later be changed with {transferOwnership}.
431  *
432  * This module is used through inheritance. It will make available the modifier
433  * `onlyOwner`, which can be applied to your functions to restrict their use to
434  * the owner.
435  */
436 abstract contract Ownable is Context {
437     address private _owner;
438 
439     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
440 
441     /**
442      * @dev Initializes the contract setting the deployer as the initial owner.
443      */
444     constructor() {
445         _setOwner(_msgSender());
446     }
447 
448     /**
449      * @dev Returns the address of the current owner.
450      */
451     function owner() public view virtual returns (address) {
452         return _owner;
453     }
454 
455     /**
456      * @dev Throws if called by any account other than the owner.
457      */
458     modifier onlyOwner() {
459         require(owner() == _msgSender(), "Ownable: caller is not the owner");
460         _;
461     }
462 
463     /**
464      * @dev Leaves the contract without owner. It will not be possible to call
465      * `onlyOwner` functions anymore. Can only be called by the current owner.
466      *
467      * NOTE: Renouncing ownership will leave the contract without an owner,
468      * thereby removing any functionality that is only available to the owner.
469      */
470     function renounceOwnership() public virtual onlyOwner {
471         _setOwner(address(0));
472     }
473 
474     /**
475      * @dev Transfers ownership of the contract to a new account (`newOwner`).
476      * Can only be called by the current owner.
477      */
478     function transferOwnership(address newOwner) public virtual onlyOwner {
479         require(newOwner != address(0), "Ownable: new owner is the zero address");
480         _setOwner(newOwner);
481     }
482 
483     function _setOwner(address newOwner) private {
484         address oldOwner = _owner;
485         _owner = newOwner;
486         emit OwnershipTransferred(oldOwner, newOwner);
487     }
488 }
489 
490 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
491 /**
492  * @title ERC721 token receiver interface
493  * @dev Interface for any contract that wants to support safeTransfers
494  * from ERC721 asset contracts.
495  */
496 interface IERC721Receiver {
497     /**
498      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
499      * by `operator` from `from`, this function is called.
500      *
501      * It must return its Solidity selector to confirm the token transfer.
502      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
503      *
504      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
505      */
506     function onERC721Received(
507         address operator,
508         address from,
509         uint256 tokenId,
510         bytes calldata data
511     ) external returns (bytes4);
512 }
513 
514 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
515 /**
516  * @dev Interface of the ERC165 standard, as defined in the
517  * https://eips.ethereum.org/EIPS/eip-165[EIP].
518  *
519  * Implementers can declare support of contract interfaces, which can then be
520  * queried by others ({ERC165Checker}).
521  *
522  * For an implementation, see {ERC165}.
523  */
524 interface IERC165 {
525     /**
526      * @dev Returns true if this contract implements the interface defined by
527      * `interfaceId`. See the corresponding
528      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
529      * to learn more about how these ids are created.
530      *
531      * This function call must use less than 30 000 gas.
532      */
533     function supportsInterface(bytes4 interfaceId) external view returns (bool);
534 }
535 
536 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
537 /**
538  * @dev Required interface of an ERC721 compliant contract.
539  */
540 interface IERC721 is IERC165 {
541     /**
542      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
543      */
544     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
545 
546     /**
547      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
548      */
549     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
550 
551     /**
552      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
553      */
554     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
555 
556     /**
557      * @dev Returns the number of tokens in ``owner``'s account.
558      */
559     function balanceOf(address owner) external view returns (uint256 balance);
560 
561     /**
562      * @dev Returns the owner of the `tokenId` token.
563      *
564      * Requirements:
565      *
566      * - `tokenId` must exist.
567      */
568     function ownerOf(uint256 tokenId) external view returns (address owner);
569 
570     /**
571      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
572      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
573      *
574      * Requirements:
575      *
576      * - `from` cannot be the zero address.
577      * - `to` cannot be the zero address.
578      * - `tokenId` token must exist and be owned by `from`.
579      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
580      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
581      *
582      * Emits a {Transfer} event.
583      */
584     function safeTransferFrom(
585         address from,
586         address to,
587         uint256 tokenId
588     ) external;
589 
590     /**
591      * @dev Transfers `tokenId` token from `from` to `to`.
592      *
593      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
594      *
595      * Requirements:
596      *
597      * - `from` cannot be the zero address.
598      * - `to` cannot be the zero address.
599      * - `tokenId` token must be owned by `from`.
600      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
601      *
602      * Emits a {Transfer} event.
603      */
604     function transferFrom(
605         address from,
606         address to,
607         uint256 tokenId
608     ) external;
609 
610     /**
611      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
612      * The approval is cleared when the token is transferred.
613      *
614      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
615      *
616      * Requirements:
617      *
618      * - The caller must own the token or be an approved operator.
619      * - `tokenId` must exist.
620      *
621      * Emits an {Approval} event.
622      */
623     function approve(address to, uint256 tokenId) external;
624 
625     /**
626      * @dev Returns the account approved for `tokenId` token.
627      *
628      * Requirements:
629      *
630      * - `tokenId` must exist.
631      */
632     function getApproved(uint256 tokenId) external view returns (address operator);
633 
634     /**
635      * @dev Approve or remove `operator` as an operator for the caller.
636      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
637      *
638      * Requirements:
639      *
640      * - The `operator` cannot be the caller.
641      *
642      * Emits an {ApprovalForAll} event.
643      */
644     function setApprovalForAll(address operator, bool _approved) external;
645 
646     /**
647      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
648      *
649      * See {setApprovalForAll}
650      */
651     function isApprovedForAll(address owner, address operator) external view returns (bool);
652 
653     /**
654      * @dev Safely transfers `tokenId` token from `from` to `to`.
655      *
656      * Requirements:
657      *
658      * - `from` cannot be the zero address.
659      * - `to` cannot be the zero address.
660      * - `tokenId` token must exist and be owned by `from`.
661      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
662      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
663      *
664      * Emits a {Transfer} event.
665      */
666     function safeTransferFrom(
667         address from,
668         address to,
669         uint256 tokenId,
670         bytes calldata data
671     ) external;
672 }
673 
674 
675 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
676 /**
677  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
678  * @dev See https://eips.ethereum.org/EIPS/eip-721
679  */
680 interface IERC721Enumerable is IERC721 {
681     /**
682      * @dev Returns the total amount of tokens stored by the contract.
683      */
684     function totalSupply() external view returns (uint256);
685 
686     /**
687      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
688      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
689      */
690     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
691 
692     /**
693      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
694      * Use along with {totalSupply} to enumerate all tokens.
695      */
696     function tokenByIndex(uint256 index) external view returns (uint256);
697 }
698 
699 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
700 /**
701  * @dev Implementation of the {IERC165} interface.
702  *
703  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
704  * for the additional interface id that will be supported. For example:
705  *
706  * ```solidity
707  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
708  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
709  * }
710  * ```
711  *
712  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
713  */
714 abstract contract ERC165 is IERC165 {
715     /**
716      * @dev See {IERC165-supportsInterface}.
717      */
718     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
719         return interfaceId == type(IERC165).interfaceId;
720     }
721 }
722 
723 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
724 /**
725  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
726  * @dev See https://eips.ethereum.org/EIPS/eip-721
727  */
728 interface IERC721Metadata is IERC721 {
729     /**
730      * @dev Returns the token collection name.
731      */
732     function name() external view returns (string memory);
733 
734     /**
735      * @dev Returns the token collection symbol.
736      */
737     function symbol() external view returns (string memory);
738 
739     /**
740      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
741      */
742     function tokenURI(uint256 tokenId) external view returns (string memory);
743 }
744 
745 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
746 /**
747  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
748  * the Metadata extension, but not including the Enumerable extension, which is available separately as
749  * {ERC721Enumerable}.
750  */
751 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
752     using Address for address;
753     using Strings for uint256;
754 
755     // Token name
756     string private _name;
757 
758     // Token symbol
759     string private _symbol;
760 
761     // Mapping from token ID to owner address
762     mapping(uint256 => address) private _owners;
763 
764     // Mapping owner address to token count
765     mapping(address => uint256) private _balances;
766 
767     // Mapping from token ID to approved address
768     mapping(uint256 => address) private _tokenApprovals;
769 
770     // Mapping from owner to operator approvals
771     mapping(address => mapping(address => bool)) private _operatorApprovals;
772 
773     /**
774      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
775      */
776     constructor(string memory name_, string memory symbol_) {
777         _name = name_;
778         _symbol = symbol_;
779     }
780 
781     /**
782      * @dev See {IERC165-supportsInterface}.
783      */
784     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
785         return
786             interfaceId == type(IERC721).interfaceId ||
787             interfaceId == type(IERC721Metadata).interfaceId ||
788             super.supportsInterface(interfaceId);
789     }
790 
791     /**
792      * @dev See {IERC721-balanceOf}.
793      */
794     function balanceOf(address owner) public view virtual override returns (uint256) {
795         require(owner != address(0), "ERC721: balance query for the zero address");
796         return _balances[owner];
797     }
798 
799     /**
800      * @dev See {IERC721-ownerOf}.
801      */
802     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
803         address owner = _owners[tokenId];
804         require(owner != address(0), "ERC721: owner query for nonexistent token");
805         return owner;
806     }
807 
808     /**
809      * @dev See {IERC721Metadata-name}.
810      */
811     function name() public view virtual override returns (string memory) {
812         return _name;
813     }
814 
815     /**
816      * @dev See {IERC721Metadata-symbol}.
817      */
818     function symbol() public view virtual override returns (string memory) {
819         return _symbol;
820     }
821 
822     /**
823      * @dev See {IERC721Metadata-tokenURI}.
824      */
825     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
826         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
827 
828         string memory baseURI = _baseURI();
829         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
830     }
831 
832     /**
833      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
834      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
835      * by default, can be overriden in child contracts.
836      */
837     function _baseURI() internal view virtual returns (string memory) {
838         return "";
839     }
840 
841     /**
842      * @dev See {IERC721-approve}.
843      */
844     function approve(address to, uint256 tokenId) public virtual override {
845         address owner = ERC721.ownerOf(tokenId);
846         require(to != owner, "ERC721: approval to current owner");
847 
848         require(
849             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
850             "ERC721: approve caller is not owner nor approved for all"
851         );
852 
853         _approve(to, tokenId);
854     }
855 
856     /**
857      * @dev See {IERC721-getApproved}.
858      */
859     function getApproved(uint256 tokenId) public view virtual override returns (address) {
860         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
861 
862         return _tokenApprovals[tokenId];
863     }
864 
865     /**
866      * @dev See {IERC721-setApprovalForAll}.
867      */
868     function setApprovalForAll(address operator, bool approved) public virtual override {
869         require(operator != _msgSender(), "ERC721: approve to caller");
870 
871         _operatorApprovals[_msgSender()][operator] = approved;
872         emit ApprovalForAll(_msgSender(), operator, approved);
873     }
874 
875     /**
876      * @dev See {IERC721-isApprovedForAll}.
877      */
878     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
879         return _operatorApprovals[owner][operator];
880     }
881 
882     /**
883      * @dev See {IERC721-transferFrom}.
884      */
885     function transferFrom(
886         address from,
887         address to,
888         uint256 tokenId
889     ) public virtual override {
890         //solhint-disable-next-line max-line-length
891         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
892 
893         _transfer(from, to, tokenId);
894     }
895 
896     /**
897      * @dev See {IERC721-safeTransferFrom}.
898      */
899     function safeTransferFrom(
900         address from,
901         address to,
902         uint256 tokenId
903     ) public virtual override {
904         safeTransferFrom(from, to, tokenId, "");
905     }
906 
907     /**
908      * @dev See {IERC721-safeTransferFrom}.
909      */
910     function safeTransferFrom(
911         address from,
912         address to,
913         uint256 tokenId,
914         bytes memory _data
915     ) public virtual override {
916         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
917         _safeTransfer(from, to, tokenId, _data);
918     }
919 
920     /**
921      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
922      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
923      *
924      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
925      *
926      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
927      * implement alternative mechanisms to perform token transfer, such as signature-based.
928      *
929      * Requirements:
930      *
931      * - `from` cannot be the zero address.
932      * - `to` cannot be the zero address.
933      * - `tokenId` token must exist and be owned by `from`.
934      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
935      *
936      * Emits a {Transfer} event.
937      */
938     function _safeTransfer(
939         address from,
940         address to,
941         uint256 tokenId,
942         bytes memory _data
943     ) internal virtual {
944         _transfer(from, to, tokenId);
945         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
946     }
947 
948     /**
949      * @dev Returns whether `tokenId` exists.
950      *
951      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
952      *
953      * Tokens start existing when they are minted (`_mint`),
954      * and stop existing when they are burned (`_burn`).
955      */
956     function _exists(uint256 tokenId) internal view virtual returns (bool) {
957         return _owners[tokenId] != address(0);
958     }
959 
960     /**
961      * @dev Returns whether `spender` is allowed to manage `tokenId`.
962      *
963      * Requirements:
964      *
965      * - `tokenId` must exist.
966      */
967     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
968         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
969         address owner = ERC721.ownerOf(tokenId);
970         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
971     }
972 
973     /**
974      * @dev Safely mints `tokenId` and transfers it to `to`.
975      *
976      * Requirements:
977      *
978      * - `tokenId` must not exist.
979      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
980      *
981      * Emits a {Transfer} event.
982      */
983     function _safeMint(address to, uint256 tokenId) internal virtual {
984         _safeMint(to, tokenId, "");
985     }
986 
987     /**
988      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
989      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
990      */
991     function _safeMint(
992         address to,
993         uint256 tokenId,
994         bytes memory _data
995     ) internal virtual {
996         _mint(to, tokenId);
997         require(
998             _checkOnERC721Received(address(0), to, tokenId, _data),
999             "ERC721: transfer to non ERC721Receiver implementer"
1000         );
1001     }
1002 
1003     /**
1004      * @dev Mints `tokenId` and transfers it to `to`.
1005      *
1006      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1007      *
1008      * Requirements:
1009      *
1010      * - `tokenId` must not exist.
1011      * - `to` cannot be the zero address.
1012      *
1013      * Emits a {Transfer} event.
1014      */
1015     function _mint(address to, uint256 tokenId) internal virtual {
1016         require(to != address(0), "ERC721: mint to the zero address");
1017         require(!_exists(tokenId), "ERC721: token already minted");
1018 
1019         _beforeTokenTransfer(address(0), to, tokenId);
1020 
1021         _balances[to] += 1;
1022         _owners[tokenId] = to;
1023 
1024         emit Transfer(address(0), to, tokenId);
1025     }
1026 
1027     /**
1028      * @dev Destroys `tokenId`.
1029      * The approval is cleared when the token is burned.
1030      *
1031      * Requirements:
1032      *
1033      * - `tokenId` must exist.
1034      *
1035      * Emits a {Transfer} event.
1036      */
1037     function _burn(uint256 tokenId) internal virtual {
1038         address owner = ERC721.ownerOf(tokenId);
1039 
1040         _beforeTokenTransfer(owner, address(0), tokenId);
1041 
1042         // Clear approvals
1043         _approve(address(0), tokenId);
1044 
1045         _balances[owner] -= 1;
1046         delete _owners[tokenId];
1047 
1048         emit Transfer(owner, address(0), tokenId);
1049     }
1050 
1051     /**
1052      * @dev Transfers `tokenId` from `from` to `to`.
1053      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1054      *
1055      * Requirements:
1056      *
1057      * - `to` cannot be the zero address.
1058      * - `tokenId` token must be owned by `from`.
1059      *
1060      * Emits a {Transfer} event.
1061      */
1062     function _transfer(
1063         address from,
1064         address to,
1065         uint256 tokenId
1066     ) internal virtual {
1067         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1068         require(to != address(0), "ERC721: transfer to the zero address");
1069 
1070         _beforeTokenTransfer(from, to, tokenId);
1071 
1072         // Clear approvals from the previous owner
1073         _approve(address(0), tokenId);
1074 
1075         _balances[from] -= 1;
1076         _balances[to] += 1;
1077         _owners[tokenId] = to;
1078 
1079         emit Transfer(from, to, tokenId);
1080     }
1081 
1082     /**
1083      * @dev Approve `to` to operate on `tokenId`
1084      *
1085      * Emits a {Approval} event.
1086      */
1087     function _approve(address to, uint256 tokenId) internal virtual {
1088         _tokenApprovals[tokenId] = to;
1089         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1090     }
1091 
1092     /**
1093      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1094      * The call is not executed if the target address is not a contract.
1095      *
1096      * @param from address representing the previous owner of the given token ID
1097      * @param to target address that will receive the tokens
1098      * @param tokenId uint256 ID of the token to be transferred
1099      * @param _data bytes optional data to send along with the call
1100      * @return bool whether the call correctly returned the expected magic value
1101      */
1102     function _checkOnERC721Received(
1103         address from,
1104         address to,
1105         uint256 tokenId,
1106         bytes memory _data
1107     ) private returns (bool) {
1108         if (to.isContract()) {
1109             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1110                 return retval == IERC721Receiver.onERC721Received.selector;
1111             } catch (bytes memory reason) {
1112                 if (reason.length == 0) {
1113                     revert("ERC721: transfer to non ERC721Receiver implementer");
1114                 } else {
1115                     assembly {
1116                         revert(add(32, reason), mload(reason))
1117                     }
1118                 }
1119             }
1120         } else {
1121             return true;
1122         }
1123     }
1124 
1125     /**
1126      * @dev Hook that is called before any token transfer. This includes minting
1127      * and burning.
1128      *
1129      * Calling conditions:
1130      *
1131      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1132      * transferred to `to`.
1133      * - When `from` is zero, `tokenId` will be minted for `to`.
1134      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1135      * - `from` and `to` are never both zero.
1136      *
1137      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1138      */
1139     function _beforeTokenTransfer(
1140         address from,
1141         address to,
1142         uint256 tokenId
1143     ) internal virtual {}
1144 }
1145 
1146 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1147 
1148 /**
1149  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1150  * enumerability of all the token ids in the contract as well as all token ids owned by each
1151  * account.
1152  */
1153 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1154     // Mapping from owner to list of owned token IDs
1155     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1156 
1157     // Mapping from token ID to index of the owner tokens list
1158     mapping(uint256 => uint256) private _ownedTokensIndex;
1159 
1160     // Array with all token ids, used for enumeration
1161     uint256[] private _allTokens;
1162 
1163     // Mapping from token id to position in the allTokens array
1164     mapping(uint256 => uint256) private _allTokensIndex;
1165 
1166     /**
1167      * @dev See {IERC165-supportsInterface}.
1168      */
1169     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1170         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1171     }
1172 
1173     /**
1174      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1175      */
1176     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1177         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1178         return _ownedTokens[owner][index];
1179     }
1180 
1181     /**
1182      * @dev See {IERC721Enumerable-totalSupply}.
1183      */
1184     function totalSupply() public view virtual override returns (uint256) {
1185         return _allTokens.length;
1186     }
1187 
1188     /**
1189      * @dev See {IERC721Enumerable-tokenByIndex}.
1190      */
1191     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1192         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1193         return _allTokens[index];
1194     }
1195 
1196     /**
1197      * @dev Hook that is called before any token transfer. This includes minting
1198      * and burning.
1199      *
1200      * Calling conditions:
1201      *
1202      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1203      * transferred to `to`.
1204      * - When `from` is zero, `tokenId` will be minted for `to`.
1205      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1206      * - `from` cannot be the zero address.
1207      * - `to` cannot be the zero address.
1208      *
1209      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1210      */
1211     function _beforeTokenTransfer(
1212         address from,
1213         address to,
1214         uint256 tokenId
1215     ) internal virtual override {
1216         super._beforeTokenTransfer(from, to, tokenId);
1217 
1218         if (from == address(0)) {
1219             _addTokenToAllTokensEnumeration(tokenId);
1220         } else if (from != to) {
1221             _removeTokenFromOwnerEnumeration(from, tokenId);
1222         }
1223         if (to == address(0)) {
1224             _removeTokenFromAllTokensEnumeration(tokenId);
1225         } else if (to != from) {
1226             _addTokenToOwnerEnumeration(to, tokenId);
1227         }
1228     }
1229 
1230     /**
1231      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1232      * @param to address representing the new owner of the given token ID
1233      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1234      */
1235     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1236         uint256 length = ERC721.balanceOf(to);
1237         _ownedTokens[to][length] = tokenId;
1238         _ownedTokensIndex[tokenId] = length;
1239     }
1240 
1241     /**
1242      * @dev Private function to add a token to this extension's token tracking data structures.
1243      * @param tokenId uint256 ID of the token to be added to the tokens list
1244      */
1245     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1246         _allTokensIndex[tokenId] = _allTokens.length;
1247         _allTokens.push(tokenId);
1248     }
1249 
1250     /**
1251      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1252      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1253      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1254      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1255      * @param from address representing the previous owner of the given token ID
1256      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1257      */
1258     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1259         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1260         // then delete the last slot (swap and pop).
1261 
1262         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1263         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1264 
1265         // When the token to delete is the last token, the swap operation is unnecessary
1266         if (tokenIndex != lastTokenIndex) {
1267             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1268 
1269             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1270             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1271         }
1272 
1273         // This also deletes the contents at the last position of the array
1274         delete _ownedTokensIndex[tokenId];
1275         delete _ownedTokens[from][lastTokenIndex];
1276     }
1277 
1278     /**
1279      * @dev Private function to remove a token from this extension's token tracking data structures.
1280      * This has O(1) time complexity, but alters the order of the _allTokens array.
1281      * @param tokenId uint256 ID of the token to be removed from the tokens list
1282      */
1283     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1284         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1285         // then delete the last slot (swap and pop).
1286 
1287         uint256 lastTokenIndex = _allTokens.length - 1;
1288         uint256 tokenIndex = _allTokensIndex[tokenId];
1289 
1290         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1291         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1292         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1293         uint256 lastTokenId = _allTokens[lastTokenIndex];
1294 
1295         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1296         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1297 
1298         // This also deletes the contents at the last position of the array
1299         delete _allTokensIndex[tokenId];
1300         _allTokens.pop();
1301     }
1302 }
1303 
1304 
1305 contract BlackInBackKat is ERC721Enumerable, Ownable 
1306 {
1307     string private baseURI;
1308     string private upgradeURI;
1309 
1310     uint256 public itemPrice = 0.08 ether;
1311     uint256 public _reserved = 70;
1312     uint256 public _total_supply = 4444;
1313     uint256 public _max_per_tx = 4;
1314     uint256 public _max_per_wallet_presale = 2;
1315 
1316     bool public isPresaleActive = false;
1317     bool public isPublicSaleActive = false;
1318     bool public isUpgradeActive = false;
1319 
1320     // KATz
1321     address public KATz;
1322 
1323     // upgrade kat
1324     uint256 public upgradePrice = 44 ether;
1325     mapping (uint256 => bool) public upgradeTokens;
1326     
1327     // withdraw addresses
1328     address t1 = 0x84F584Eb25587853A06608257B2a71065134bdC2;
1329     address t2 = 0x7F0bDE63F90D8Aa39c8964c92FD6e92D3AaD9148;
1330 
1331     constructor () ERC721("Black In Back Kat", "BIBK") 
1332     {
1333     }
1334 
1335     modifier onlyPresale() {
1336         require(isPresaleActive, "presale not active");
1337         _;
1338     }
1339 
1340     modifier onlyPublicSale() {
1341         require(isPublicSaleActive, "public sale not active");
1342         _;
1343     }
1344 
1345     // presale
1346     mapping(address => bool) private _presaleEligible1;
1347     mapping(address => bool) private _presaleEligible2;
1348     mapping(address => uint256) private _presaleClaimed;
1349     mapping(address => uint256) private _totalClaimed;
1350 
1351     mapping(uint256 => address) private _kat_minter;
1352     
1353     function addToPresaleList1(address[] calldata addresses) external onlyOwner 
1354     {
1355         for(uint256 i = 0; i < addresses.length; i++) 
1356         {
1357             require(addresses[i] != address(0), "null address");
1358             require(!_presaleEligible1[addresses[i]], "duplicate");
1359             _presaleEligible1[addresses[i]] = true;
1360             _presaleClaimed[addresses[i]] = 0;
1361         }
1362     }
1363 
1364     function removeFromPresaleList1(address[] calldata addresses) external onlyOwner 
1365     {
1366         for(uint256 i = 0; i < addresses.length; i++) 
1367         {
1368             require(addresses[i] != address(0), "null address");
1369             require(_presaleEligible1[addresses[i]], "not in presale");
1370             _presaleEligible1[addresses[i]] = false;
1371         }
1372     }
1373 
1374     function addToPresaleList2(address[] calldata addresses) external onlyOwner 
1375     {
1376         for(uint256 i = 0; i < addresses.length; i++) 
1377         {
1378             require(addresses[i] != address(0), "null address");
1379             require(!_presaleEligible2[addresses[i]], "duplicate");
1380             _presaleEligible2[addresses[i]] = true;
1381         }
1382     }
1383 
1384     function removeFromPresaleList2(address[] calldata addresses) external onlyOwner 
1385     {
1386         for(uint256 i = 0; i < addresses.length; i++) 
1387         {
1388             require(addresses[i] != address(0), "null address");
1389             require(_presaleEligible2[addresses[i]], "not in presale");
1390             _presaleEligible2[addresses[i]] = false;
1391         }
1392     }
1393 
1394     function isEligibleForPresale(address addr) public view returns (bool) 
1395     {
1396         require(addr != address(0), "null address");
1397 
1398         return getMaxClaimPresale(addr) > 0;
1399     }
1400 
1401     function getMaxClaimPresale(address addr) public view returns (uint256) 
1402 	{
1403         require(addr != address(0), "null address");
1404 
1405         uint256 max_presale_mint = 0;
1406 
1407         if(_presaleEligible1[addr])
1408         {
1409             max_presale_mint += 1;
1410         }
1411 
1412         if(_presaleEligible2[addr])
1413         {
1414             max_presale_mint += 1;
1415         }
1416 
1417 		return max_presale_mint;
1418 	}
1419 
1420     function getPresaleClaimed(address addr) public view returns (uint256) 
1421     {
1422         require(addr != address(0), "null address");
1423         
1424         return _presaleClaimed[addr];
1425     }
1426 
1427     function hasClaimedPresale(address addr) external view returns (bool) 
1428     {
1429         require(addr != address(0), "null address");
1430     
1431         return _presaleClaimed[addr] == getMaxClaimPresale(addr);
1432     }
1433 
1434     // mint
1435     function mintReserved(address addr, uint numberOfMints)
1436         public onlyOwner 
1437     {
1438         require(addr != address(0),                                                 "null address");
1439         require(totalSupply() < _total_supply,                                      "sold out");
1440         require(_reserved - numberOfMints >= 0,                                     "Maximum amount already minted.");
1441 
1442         for(uint i = 0; i < numberOfMints; i++)
1443         {
1444             uint256 tokenId = totalSupply() + 1;
1445             _kat_minter[tokenId] = addr;
1446             _safeMint(addr, totalSupply() + 1);
1447         }
1448 
1449         _reserved -= numberOfMints;
1450     }
1451 
1452     function mintPresale(uint numberOfMints)
1453         public payable onlyPresale
1454     {
1455         uint256 max_claim_presale = getMaxClaimPresale(msg.sender);
1456         require(isEligibleForPresale(msg.sender),                                   "not eligible for presale");
1457         require(_presaleClaimed[msg.sender] < max_claim_presale,                    "already claimed");
1458         require(totalSupply() < _total_supply,                                      "sold out");
1459         require(totalSupply() + numberOfMints <= _total_supply - _reserved,         "Maximum amount already minted.");
1460         require(numberOfMints > 0,                                                  "gas fee for nothing, don't accept this request."); //(づ￣ ³￣)づ
1461         require(numberOfMints <= max_claim_presale - _presaleClaimed[msg.sender],   "You cant mint more than 2 at a time.");
1462         require(msg.value == itemPrice * numberOfMints,                             "insufficient ETH");
1463         
1464         for(uint i = 0; i < numberOfMints; i++)
1465         {
1466             uint256 tokenId = totalSupply() + 1;
1467             _kat_minter[tokenId] = msg.sender;
1468             _presaleClaimed[msg.sender] += 1;
1469             _safeMint(msg.sender, tokenId);
1470         }
1471     }
1472 
1473     function mint(uint numberOfMints)
1474         public payable onlyPublicSale
1475     {
1476         require(totalSupply() < _total_supply,                                      "sold out");
1477         require(totalSupply() + numberOfMints <= _total_supply - _reserved,         "Maximum amount already minted.");
1478         require(numberOfMints > 0,                                                  "gas fee for nothing, don't accept this request."); //(づ￣ ³￣)づ
1479         require(numberOfMints <= _max_per_tx,                                       "You cant mint more than 4 at a time.");
1480         require(msg.value == itemPrice * numberOfMints,                             "insufficient ETH");
1481         
1482         for(uint i = 0; i < numberOfMints; i++)
1483         {
1484             uint256 tokenId = totalSupply() + 1;
1485             _kat_minter[tokenId] = msg.sender;
1486             _safeMint(msg.sender, totalSupply() + 1);
1487         }
1488     }
1489 
1490     // upgrade
1491     function upgrade(uint256 tokenId) public
1492     {
1493         address from = msg.sender;
1494         require(isUpgradeActive,                                                    "upgrade hasn't started yet");
1495         require(KATz != address(0),                                                 "KATz contract address need be set");
1496         require(ownerOf(tokenId) == from,                                           "does not own the token");
1497         require(upgradeTokens[tokenId] == false,                                    "token must be the one that hasn't been upgraded.");
1498         require(IERC20(KATz).balanceOf(from) >= upgradePrice,                       "insufficient KATz");
1499         
1500         IERC20(KATz).transferFrom(msg.sender, owner(), upgradePrice);
1501     
1502         upgradeTokens[tokenId] = true;
1503     }
1504 
1505     function _baseURI() internal view override returns (string memory) 
1506     {
1507         return baseURI;
1508     }
1509 
1510     function tokenURI(uint256 tokenId) public view override returns (string memory) 
1511     {
1512         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1513 
1514         string memory uri = upgradeTokens[tokenId] ? upgradeURI : _baseURI();
1515         return bytes(uri).length > 0 ? string(abi.encodePacked(uri, toString(tokenId))) : "";
1516     }
1517 
1518     function walletOfOwner(address _owner) public view returns(uint256[] memory) 
1519     {
1520         uint256 tokenCount = balanceOf(_owner);
1521         uint256[] memory tokensId = new uint256[](tokenCount);
1522         
1523         for(uint256 i; i < tokenCount; i++)
1524         {
1525             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1526         }
1527         
1528         return tokensId;
1529     }
1530     
1531     function getKatMinter(uint256 tokenId) view public returns (address)
1532     {
1533         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1534         return _kat_minter[tokenId];
1535     }
1536     
1537     function isKatUpgrade(uint256 tokenId) view public returns (bool)
1538     {
1539         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1540         return upgradeTokens[tokenId];
1541     }
1542 
1543     // admin
1544     function setBaseURI(string memory uri) public onlyOwner 
1545     {
1546         baseURI = uri;
1547     }
1548 
1549     function setUpgradeURI(string memory uri) public onlyOwner 
1550     {
1551         upgradeURI = uri;
1552     }
1553 
1554     function togglePresaleStatus() external onlyOwner 
1555     {
1556         isPresaleActive = !isPresaleActive;
1557     }
1558 
1559     function togglePublicSaleStatus() external onlyOwner 
1560     {
1561         isPublicSaleActive = !isPublicSaleActive;
1562     }
1563     
1564     function toggleUpgradeStatus() external onlyOwner 
1565     {
1566         isUpgradeActive = !isUpgradeActive;
1567     }
1568 
1569     function setKATz(address addr) public payable onlyOwner
1570     {
1571         KATz = addr;
1572     }
1573 
1574     //Just incase something bad happen ʕノ•ᴥ•ʔノ ︵ ┻━┻
1575     function setItemPrice(uint256 _price) public onlyOwner 
1576     {
1577 		itemPrice = _price;
1578 	}
1579 
1580     function setUpgradePrice(uint256 _price) public onlyOwner 
1581     {
1582 		upgradePrice = _price;
1583 	}
1584 	
1585     function upgradeKatToken(uint256 tokenId, bool val) public onlyOwner 
1586     {
1587         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1588         
1589         upgradeTokens[tokenId] = val;
1590     }
1591 
1592     function setClaimedPresale(address addr, uint256 number) public onlyOwner 
1593     {
1594         require(addr != address(0), "null address");
1595         _presaleClaimed[addr] = number;
1596     }
1597 
1598     function cashOut() public onlyOwner 
1599     {
1600         uint256 _each = address(this).balance / 2;
1601         require(payable(t1).send(_each));
1602         require(payable(t2).send(_each));
1603     }
1604         
1605     /**
1606      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1607      */
1608     function toString(uint256 value) internal pure returns (string memory) 
1609     {
1610         // Inspired by OraclizeAPI's implementation - MIT licence
1611         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1612 
1613         if (value == 0) {
1614             return "0";
1615         }
1616         uint256 temp = value;
1617         uint256 digits;
1618         while (temp != 0) {
1619             digits++;
1620             temp /= 10;
1621         }
1622         bytes memory buffer = new bytes(digits);
1623         while (value != 0) {
1624             digits -= 1;
1625             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1626             value /= 10;
1627         }
1628         return string(buffer);
1629     }
1630 }