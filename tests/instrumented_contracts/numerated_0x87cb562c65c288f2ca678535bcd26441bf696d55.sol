1 /*
2 
3 $$$$$$$\   $$$$$$\   $$$$$$\  $$\      $$\                  
4 $$  __$$\ $$  __$$\ $$  __$$\ $$$\    $$$ |                 
5 $$ |  $$ |$$ /  $$ |$$ /  $$ |$$$$\  $$$$ |                 
6 $$ |  $$ |$$ |  $$ |$$ |  $$ |$$\$$\$$ $$ |                 
7 $$ |  $$ |$$ |  $$ |$$ |  $$ |$$ \$$$  $$ |                 
8 $$ |  $$ |$$ |  $$ |$$ |  $$ |$$ |\$  /$$ |                 
9 $$$$$$$  | $$$$$$  | $$$$$$  |$$ | \_/ $$ |                 
10 \_______/  \______/  \______/ \__|     \__|                 
11                                                             
12                                                             
13                                                             
14  $$$$$$\   $$$$$$\ $$$$$$$$\                                
15 $$  __$$\ $$  __$$\\__$$  __|                               
16 $$ /  \__|$$ /  $$ |  $$ |                                  
17 $$ |      $$$$$$$$ |  $$ |                                  
18 $$ |      $$  __$$ |  $$ |                                  
19 $$ |  $$\ $$ |  $$ |  $$ |                                  
20 \$$$$$$  |$$ |  $$ |  $$ |                                  
21  \______/ \__|  \__|  \__|                                  
22                                                             
23                                                             
24                                                             
25 $$$$$$$\  $$$$$$$$\  $$$$$$\   $$$$$$\  $$\   $$\ $$$$$$$$\ 
26 $$  __$$\ $$  _____|$$  __$$\ $$  __$$\ $$ |  $$ |$$  _____|
27 $$ |  $$ |$$ |      $$ /  \__|$$ /  \__|$$ |  $$ |$$ |      
28 $$$$$$$  |$$$$$\    \$$$$$$\  $$ |      $$ |  $$ |$$$$$\    
29 $$  __$$< $$  __|    \____$$\ $$ |      $$ |  $$ |$$  __|   
30 $$ |  $$ |$$ |      $$\   $$ |$$ |  $$\ $$ |  $$ |$$ |      
31 $$ |  $$ |$$$$$$$$\ \$$$$$$  |\$$$$$$  |\$$$$$$  |$$$$$$$$\ 
32 \__|  \__|\________| \______/  \______/  \______/ \________|
33                                                  
34 */
35 
36 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.0.0
37 
38 // SPDX-License-Identifier: MIT
39 
40 pragma solidity ^0.8.0;
41 
42 /**
43  * @dev Interface of the ERC20 standard as defined in the EIP.
44  */
45 interface IERC20 {
46     /**
47      * @dev Returns the amount of tokens in existence.
48      */
49     function totalSupply() external view returns (uint256);
50 
51     /**
52      * @dev Returns the amount of tokens owned by `account`.
53      */
54     function balanceOf(address account) external view returns (uint256);
55 
56     /**
57      * @dev Moves `amount` tokens from the caller's account to `recipient`.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transfer(address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Returns the remaining number of tokens that `spender` will be
67      * allowed to spend on behalf of `owner` through {transferFrom}. This is
68      * zero by default.
69      *
70      * This value changes when {approve} or {transferFrom} are called.
71      */
72     function allowance(address owner, address spender) external view returns (uint256);
73 
74     /**
75      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * IMPORTANT: Beware that changing an allowance with this method brings the risk
80      * that someone may use both the old and the new allowance by unfortunate
81      * transaction ordering. One possible solution to mitigate this race
82      * condition is to first reduce the spender's allowance to 0 and set the
83      * desired value afterwards:
84      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
85      *
86      * Emits an {Approval} event.
87      */
88     function approve(address spender, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Moves `amount` tokens from `sender` to `recipient` using the
92      * allowance mechanism. `amount` is then deducted from the caller's
93      * allowance.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
100 
101     /**
102      * @dev Emitted when `value` tokens are moved from one account (`from`) to
103      * another (`to`).
104      *
105      * Note that `value` may be zero.
106      */
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 
109     /**
110      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
111      * a call to {approve}. `value` is the new allowance.
112      */
113     event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 
117 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.0.0
118 
119 
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Interface of the ERC165 standard, as defined in the
125  * https://eips.ethereum.org/EIPS/eip-165[EIP].
126  *
127  * Implementers can declare support of contract interfaces, which can then be
128  * queried by others ({ERC165Checker}).
129  *
130  * For an implementation, see {ERC165}.
131  */
132 interface IERC165 {
133     /**
134      * @dev Returns true if this contract implements the interface defined by
135      * `interfaceId`. See the corresponding
136      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
137      * to learn more about how these ids are created.
138      *
139      * This function call must use less than 30 000 gas.
140      */
141     function supportsInterface(bytes4 interfaceId) external view returns (bool);
142 }
143 
144 
145 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.0.0
146 
147 
148 
149 pragma solidity ^0.8.0;
150 
151 /**
152  * @dev Required interface of an ERC721 compliant contract.
153  */
154 interface IERC721 is IERC165 {
155     /**
156      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
157      */
158     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
159 
160     /**
161      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
162      */
163     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
164 
165     /**
166      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
167      */
168     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
169 
170     /**
171      * @dev Returns the number of tokens in ``owner``'s account.
172      */
173     function balanceOf(address owner) external view returns (uint256 balance);
174 
175     /**
176      * @dev Returns the owner of the `tokenId` token.
177      *
178      * Requirements:
179      *
180      * - `tokenId` must exist.
181      */
182     function ownerOf(uint256 tokenId) external view returns (address owner);
183 
184     /**
185      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
186      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
187      *
188      * Requirements:
189      *
190      * - `from` cannot be the zero address.
191      * - `to` cannot be the zero address.
192      * - `tokenId` token must exist and be owned by `from`.
193      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
194      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
195      *
196      * Emits a {Transfer} event.
197      */
198     function safeTransferFrom(address from, address to, uint256 tokenId) external;
199 
200     /**
201      * @dev Transfers `tokenId` token from `from` to `to`.
202      *
203      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
204      *
205      * Requirements:
206      *
207      * - `from` cannot be the zero address.
208      * - `to` cannot be the zero address.
209      * - `tokenId` token must be owned by `from`.
210      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
211      *
212      * Emits a {Transfer} event.
213      */
214     function transferFrom(address from, address to, uint256 tokenId) external;
215 
216     /**
217      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
218      * The approval is cleared when the token is transferred.
219      *
220      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
221      *
222      * Requirements:
223      *
224      * - The caller must own the token or be an approved operator.
225      * - `tokenId` must exist.
226      *
227      * Emits an {Approval} event.
228      */
229     function approve(address to, uint256 tokenId) external;
230 
231     /**
232      * @dev Returns the account approved for `tokenId` token.
233      *
234      * Requirements:
235      *
236      * - `tokenId` must exist.
237      */
238     function getApproved(uint256 tokenId) external view returns (address operator);
239 
240     /**
241      * @dev Approve or remove `operator` as an operator for the caller.
242      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
243      *
244      * Requirements:
245      *
246      * - The `operator` cannot be the caller.
247      *
248      * Emits an {ApprovalForAll} event.
249      */
250     function setApprovalForAll(address operator, bool _approved) external;
251 
252     /**
253      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
254      *
255      * See {setApprovalForAll}
256      */
257     function isApprovedForAll(address owner, address operator) external view returns (bool);
258 
259     /**
260       * @dev Safely transfers `tokenId` token from `from` to `to`.
261       *
262       * Requirements:
263       *
264       * - `from` cannot be the zero address.
265       * - `to` cannot be the zero address.
266       * - `tokenId` token must exist and be owned by `from`.
267       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
268       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
269       *
270       * Emits a {Transfer} event.
271       */
272     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
273 }
274 
275 
276 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.0.0
277 
278 
279 
280 pragma solidity ^0.8.0;
281 
282 /**
283  * @title ERC721 token receiver interface
284  * @dev Interface for any contract that wants to support safeTransfers
285  * from ERC721 asset contracts.
286  */
287 interface IERC721Receiver {
288     /**
289      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
290      * by `operator` from `from`, this function is called.
291      *
292      * It must return its Solidity selector to confirm the token transfer.
293      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
294      *
295      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
296      */
297     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
298 }
299 
300 
301 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.0.0
302 
303 
304 
305 pragma solidity ^0.8.0;
306 
307 /**
308  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
309  * @dev See https://eips.ethereum.org/EIPS/eip-721
310  */
311 interface IERC721Metadata is IERC721 {
312 
313     /**
314      * @dev Returns the token collection name.
315      */
316     function name() external view returns (string memory);
317 
318     /**
319      * @dev Returns the token collection symbol.
320      */
321     function symbol() external view returns (string memory);
322 
323     /**
324      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
325      */
326     function tokenURI(uint256 tokenId) external view returns (string memory);
327 }
328 
329 
330 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.0.0
331 
332 
333 
334 pragma solidity ^0.8.0;
335 
336 /**
337  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
338  * @dev See https://eips.ethereum.org/EIPS/eip-721
339  */
340 interface IERC721Enumerable is IERC721 {
341 
342     /**
343      * @dev Returns the total amount of tokens stored by the contract.
344      */
345     function totalSupply() external view returns (uint256);
346 
347     /**
348      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
349      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
350      */
351     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
352 
353     /**
354      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
355      * Use along with {totalSupply} to enumerate all tokens.
356      */
357     function tokenByIndex(uint256 index) external view returns (uint256);
358 }
359 
360 
361 // File @openzeppelin/contracts/utils/Address.sol@v4.0.0
362 
363 
364 
365 pragma solidity ^0.8.0;
366 
367 /**
368  * @dev Collection of functions related to the address type
369  */
370 library Address {
371     /**
372      * @dev Returns true if `account` is a contract.
373      *
374      * [IMPORTANT]
375      * ====
376      * It is unsafe to assume that an address for which this function returns
377      * false is an externally-owned account (EOA) and not a contract.
378      *
379      * Among others, `isContract` will return false for the following
380      * types of addresses:
381      *
382      *  - an externally-owned account
383      *  - a contract in construction
384      *  - an address where a contract will be created
385      *  - an address where a contract lived, but was destroyed
386      * ====
387      */
388     function isContract(address account) internal view returns (bool) {
389         // This method relies on extcodesize, which returns 0 for contracts in
390         // construction, since the code is only stored at the end of the
391         // constructor execution.
392 
393         uint256 size;
394         // solhint-disable-next-line no-inline-assembly
395         assembly { size := extcodesize(account) }
396         return size > 0;
397     }
398 
399     /**
400      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
401      * `recipient`, forwarding all available gas and reverting on errors.
402      *
403      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
404      * of certain opcodes, possibly making contracts go over the 2300 gas limit
405      * imposed by `transfer`, making them unable to receive funds via
406      * `transfer`. {sendValue} removes this limitation.
407      *
408      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
409      *
410      * IMPORTANT: because control is transferred to `recipient`, care must be
411      * taken to not create reentrancy vulnerabilities. Consider using
412      * {ReentrancyGuard} or the
413      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
414      */
415     function sendValue(address payable recipient, uint256 amount) internal {
416         require(address(this).balance >= amount, "Address: insufficient balance");
417 
418         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
419         (bool success, ) = recipient.call{ value: amount }("");
420         require(success, "Address: unable to send value, recipient may have reverted");
421     }
422 
423     /**
424      * @dev Performs a Solidity function call using a low level `call`. A
425      * plain`call` is an unsafe replacement for a function call: use this
426      * function instead.
427      *
428      * If `target` reverts with a revert reason, it is bubbled up by this
429      * function (like regular Solidity function calls).
430      *
431      * Returns the raw returned data. To convert to the expected return value,
432      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
433      *
434      * Requirements:
435      *
436      * - `target` must be a contract.
437      * - calling `target` with `data` must not revert.
438      *
439      * _Available since v3.1._
440      */
441     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
442       return functionCall(target, data, "Address: low-level call failed");
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
447      * `errorMessage` as a fallback revert reason when `target` reverts.
448      *
449      * _Available since v3.1._
450      */
451     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
452         return functionCallWithValue(target, data, 0, errorMessage);
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
457      * but also transferring `value` wei to `target`.
458      *
459      * Requirements:
460      *
461      * - the calling contract must have an ETH balance of at least `value`.
462      * - the called Solidity function must be `payable`.
463      *
464      * _Available since v3.1._
465      */
466     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
467         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
472      * with `errorMessage` as a fallback revert reason when `target` reverts.
473      *
474      * _Available since v3.1._
475      */
476     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
477         require(address(this).balance >= value, "Address: insufficient balance for call");
478         require(isContract(target), "Address: call to non-contract");
479 
480         // solhint-disable-next-line avoid-low-level-calls
481         (bool success, bytes memory returndata) = target.call{ value: value }(data);
482         return _verifyCallResult(success, returndata, errorMessage);
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
487      * but performing a static call.
488      *
489      * _Available since v3.3._
490      */
491     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
492         return functionStaticCall(target, data, "Address: low-level static call failed");
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
497      * but performing a static call.
498      *
499      * _Available since v3.3._
500      */
501     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
502         require(isContract(target), "Address: static call to non-contract");
503 
504         // solhint-disable-next-line avoid-low-level-calls
505         (bool success, bytes memory returndata) = target.staticcall(data);
506         return _verifyCallResult(success, returndata, errorMessage);
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
511      * but performing a delegate call.
512      *
513      * _Available since v3.4._
514      */
515     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
516         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
521      * but performing a delegate call.
522      *
523      * _Available since v3.4._
524      */
525     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
526         require(isContract(target), "Address: delegate call to non-contract");
527 
528         // solhint-disable-next-line avoid-low-level-calls
529         (bool success, bytes memory returndata) = target.delegatecall(data);
530         return _verifyCallResult(success, returndata, errorMessage);
531     }
532 
533     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
534         if (success) {
535             return returndata;
536         } else {
537             // Look for revert reason and bubble it up if present
538             if (returndata.length > 0) {
539                 // The easiest way to bubble the revert reason is using memory via assembly
540 
541                 // solhint-disable-next-line no-inline-assembly
542                 assembly {
543                     let returndata_size := mload(returndata)
544                     revert(add(32, returndata), returndata_size)
545                 }
546             } else {
547                 revert(errorMessage);
548             }
549         }
550     }
551 }
552 
553 
554 // File @openzeppelin/contracts/utils/Context.sol@v4.0.0
555 
556 
557 
558 pragma solidity ^0.8.0;
559 
560 /*
561  * @dev Provides information about the current execution context, including the
562  * sender of the transaction and its data. While these are generally available
563  * via msg.sender and msg.data, they should not be accessed in such a direct
564  * manner, since when dealing with meta-transactions the account sending and
565  * paying for execution may not be the actual sender (as far as an application
566  * is concerned).
567  *
568  * This contract is only required for intermediate, library-like contracts.
569  */
570 abstract contract Context {
571     function _msgSender() internal view virtual returns (address) {
572         return msg.sender;
573     }
574 
575     function _msgData() internal view virtual returns (bytes calldata) {
576         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
577         return msg.data;
578     }
579 }
580 
581 
582 // File @openzeppelin/contracts/utils/Strings.sol@v4.0.0
583 
584 
585 
586 pragma solidity ^0.8.0;
587 
588 /**
589  * @dev String operations.
590  */
591 library Strings {
592     bytes16 private constant alphabet = "0123456789abcdef";
593 
594     /**
595      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
596      */
597     function toString(uint256 value) internal pure returns (string memory) {
598         // Inspired by OraclizeAPI's implementation - MIT licence
599         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
600 
601         if (value == 0) {
602             return "0";
603         }
604         uint256 temp = value;
605         uint256 digits;
606         while (temp != 0) {
607             digits++;
608             temp /= 10;
609         }
610         bytes memory buffer = new bytes(digits);
611         while (value != 0) {
612             digits -= 1;
613             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
614             value /= 10;
615         }
616         return string(buffer);
617     }
618 
619     /**
620      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
621      */
622     function toHexString(uint256 value) internal pure returns (string memory) {
623         if (value == 0) {
624             return "0x00";
625         }
626         uint256 temp = value;
627         uint256 length = 0;
628         while (temp != 0) {
629             length++;
630             temp >>= 8;
631         }
632         return toHexString(value, length);
633     }
634 
635     /**
636      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
637      */
638     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
639         bytes memory buffer = new bytes(2 * length + 2);
640         buffer[0] = "0";
641         buffer[1] = "x";
642         for (uint256 i = 2 * length + 1; i > 1; --i) {
643             buffer[i] = alphabet[value & 0xf];
644             value >>= 4;
645         }
646         require(value == 0, "Strings: hex length insufficient");
647         return string(buffer);
648     }
649 
650 }
651 
652 
653 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.0.0
654 
655 
656 
657 pragma solidity ^0.8.0;
658 
659 /**
660  * @dev Implementation of the {IERC165} interface.
661  *
662  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
663  * for the additional interface id that will be supported. For example:
664  *
665  * ```solidity
666  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
667  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
668  * }
669  * ```
670  *
671  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
672  */
673 abstract contract ERC165 is IERC165 {
674     /**
675      * @dev See {IERC165-supportsInterface}.
676      */
677     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
678         return interfaceId == type(IERC165).interfaceId;
679     }
680 }
681 
682 
683 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.0.0
684 
685 
686 
687 pragma solidity ^0.8.0;
688 
689 
690 
691 
692 
693 
694 
695 
696 /**
697  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
698  * the Metadata extension, but not including the Enumerable extension, which is available separately as
699  * {ERC721Enumerable}.
700  */
701 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
702     using Address for address;
703     using Strings for uint256;
704 
705     // Token name
706     string private _name;
707 
708     // Token symbol
709     string private _symbol;
710 
711     // Mapping from token ID to owner address
712     mapping (uint256 => address) private _owners;
713 
714     // Mapping owner address to token count
715     mapping (address => uint256) private _balances;
716 
717     // Mapping from token ID to approved address
718     mapping (uint256 => address) private _tokenApprovals;
719 
720     // Mapping from owner to operator approvals
721     mapping (address => mapping (address => bool)) private _operatorApprovals;
722 
723     /**
724      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
725      */
726     constructor (string memory name_, string memory symbol_) {
727         _name = name_;
728         _symbol = symbol_;
729     }
730 
731     /**
732      * @dev See {IERC165-supportsInterface}.
733      */
734     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
735         return interfaceId == type(IERC721).interfaceId
736             || interfaceId == type(IERC721Metadata).interfaceId
737             || super.supportsInterface(interfaceId);
738     }
739 
740     /**
741      * @dev See {IERC721-balanceOf}.
742      */
743     function balanceOf(address owner) public view virtual override returns (uint256) {
744         require(owner != address(0), "ERC721: balance query for the zero address");
745         return _balances[owner];
746     }
747 
748     /**
749      * @dev See {IERC721-ownerOf}.
750      */
751     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
752         address owner = _owners[tokenId];
753         require(owner != address(0), "ERC721: owner query for nonexistent token");
754         return owner;
755     }
756 
757     /**
758      * @dev See {IERC721Metadata-name}.
759      */
760     function name() public view virtual override returns (string memory) {
761         return _name;
762     }
763 
764     /**
765      * @dev See {IERC721Metadata-symbol}.
766      */
767     function symbol() public view virtual override returns (string memory) {
768         return _symbol;
769     }
770 
771     /**
772      * @dev See {IERC721Metadata-tokenURI}.
773      */
774     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
775         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
776 
777         string memory baseURI = _baseURI();
778         return bytes(baseURI).length > 0
779             ? string(abi.encodePacked(baseURI, tokenId.toString()))
780             : '';
781     }
782 
783     /**
784      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
785      * in child contracts.
786      */
787     function _baseURI() internal view virtual returns (string memory) {
788         return "";
789     }
790 
791     /**
792      * @dev See {IERC721-approve}.
793      */
794     function approve(address to, uint256 tokenId) public virtual override {
795         address owner = ERC721.ownerOf(tokenId);
796         require(to != owner, "ERC721: approval to current owner");
797 
798         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
799             "ERC721: approve caller is not owner nor approved for all"
800         );
801 
802         _approve(to, tokenId);
803     }
804 
805     /**
806      * @dev See {IERC721-getApproved}.
807      */
808     function getApproved(uint256 tokenId) public view virtual override returns (address) {
809         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
810 
811         return _tokenApprovals[tokenId];
812     }
813 
814     /**
815      * @dev See {IERC721-setApprovalForAll}.
816      */
817     function setApprovalForAll(address operator, bool approved) public virtual override {
818         require(operator != _msgSender(), "ERC721: approve to caller");
819 
820         _operatorApprovals[_msgSender()][operator] = approved;
821         emit ApprovalForAll(_msgSender(), operator, approved);
822     }
823 
824     /**
825      * @dev See {IERC721-isApprovedForAll}.
826      */
827     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
828         return _operatorApprovals[owner][operator];
829     }
830 
831     /**
832      * @dev See {IERC721-transferFrom}.
833      */
834     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
835         //solhint-disable-next-line max-line-length
836         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
837 
838         _transfer(from, to, tokenId);
839     }
840 
841     /**
842      * @dev See {IERC721-safeTransferFrom}.
843      */
844     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
845         safeTransferFrom(from, to, tokenId, "");
846     }
847 
848     /**
849      * @dev See {IERC721-safeTransferFrom}.
850      */
851     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
852         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
853         _safeTransfer(from, to, tokenId, _data);
854     }
855 
856     /**
857      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
858      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
859      *
860      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
861      *
862      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
863      * implement alternative mechanisms to perform token transfer, such as signature-based.
864      *
865      * Requirements:
866      *
867      * - `from` cannot be the zero address.
868      * - `to` cannot be the zero address.
869      * - `tokenId` token must exist and be owned by `from`.
870      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
871      *
872      * Emits a {Transfer} event.
873      */
874     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
875         _transfer(from, to, tokenId);
876         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
877     }
878 
879     /**
880      * @dev Returns whether `tokenId` exists.
881      *
882      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
883      *
884      * Tokens start existing when they are minted (`_mint`),
885      * and stop existing when they are burned (`_burn`).
886      */
887     function _exists(uint256 tokenId) internal view virtual returns (bool) {
888         return _owners[tokenId] != address(0);
889     }
890 
891     /**
892      * @dev Returns whether `spender` is allowed to manage `tokenId`.
893      *
894      * Requirements:
895      *
896      * - `tokenId` must exist.
897      */
898     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
899         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
900         address owner = ERC721.ownerOf(tokenId);
901         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
902     }
903 
904     /**
905      * @dev Safely mints `tokenId` and transfers it to `to`.
906      *
907      * Requirements:
908      *
909      * - `tokenId` must not exist.
910      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
911      *
912      * Emits a {Transfer} event.
913      */
914     function _safeMint(address to, uint256 tokenId) internal virtual {
915         _safeMint(to, tokenId, "");
916     }
917 
918     /**
919      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
920      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
921      */
922     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
923         _mint(to, tokenId);
924         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
925     }
926 
927     /**
928      * @dev Mints `tokenId` and transfers it to `to`.
929      *
930      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
931      *
932      * Requirements:
933      *
934      * - `tokenId` must not exist.
935      * - `to` cannot be the zero address.
936      *
937      * Emits a {Transfer} event.
938      */
939     function _mint(address to, uint256 tokenId) internal virtual {
940         require(to != address(0), "ERC721: mint to the zero address");
941         require(!_exists(tokenId), "ERC721: token already minted");
942 
943         _beforeTokenTransfer(address(0), to, tokenId);
944 
945         _balances[to] += 1;
946         _owners[tokenId] = to;
947 
948         emit Transfer(address(0), to, tokenId);
949     }
950 
951     /**
952      * @dev Destroys `tokenId`.
953      * The approval is cleared when the token is burned.
954      *
955      * Requirements:
956      *
957      * - `tokenId` must exist.
958      *
959      * Emits a {Transfer} event.
960      */
961     function _burn(uint256 tokenId) internal virtual {
962         address owner = ERC721.ownerOf(tokenId);
963 
964         _beforeTokenTransfer(owner, address(0), tokenId);
965 
966         // Clear approvals
967         _approve(address(0), tokenId);
968 
969         _balances[owner] -= 1;
970         delete _owners[tokenId];
971 
972         emit Transfer(owner, address(0), tokenId);
973     }
974 
975     /**
976      * @dev Transfers `tokenId` from `from` to `to`.
977      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
978      *
979      * Requirements:
980      *
981      * - `to` cannot be the zero address.
982      * - `tokenId` token must be owned by `from`.
983      *
984      * Emits a {Transfer} event.
985      */
986     function _transfer(address from, address to, uint256 tokenId) internal virtual {
987         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
988         require(to != address(0), "ERC721: transfer to the zero address");
989 
990         _beforeTokenTransfer(from, to, tokenId);
991 
992         // Clear approvals from the previous owner
993         _approve(address(0), tokenId);
994 
995         _balances[from] -= 1;
996         _balances[to] += 1;
997         _owners[tokenId] = to;
998 
999         emit Transfer(from, to, tokenId);
1000     }
1001 
1002     /**
1003      * @dev Approve `to` to operate on `tokenId`
1004      *
1005      * Emits a {Approval} event.
1006      */
1007     function _approve(address to, uint256 tokenId) internal virtual {
1008         _tokenApprovals[tokenId] = to;
1009         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1010     }
1011 
1012     /**
1013      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1014      * The call is not executed if the target address is not a contract.
1015      *
1016      * @param from address representing the previous owner of the given token ID
1017      * @param to target address that will receive the tokens
1018      * @param tokenId uint256 ID of the token to be transferred
1019      * @param _data bytes optional data to send along with the call
1020      * @return bool whether the call correctly returned the expected magic value
1021      */
1022     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1023         private returns (bool)
1024     {
1025         if (to.isContract()) {
1026             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1027                 return retval == IERC721Receiver(to).onERC721Received.selector;
1028             } catch (bytes memory reason) {
1029                 if (reason.length == 0) {
1030                     revert("ERC721: transfer to non ERC721Receiver implementer");
1031                 } else {
1032                     // solhint-disable-next-line no-inline-assembly
1033                     assembly {
1034                         revert(add(32, reason), mload(reason))
1035                     }
1036                 }
1037             }
1038         } else {
1039             return true;
1040         }
1041     }
1042 
1043     /**
1044      * @dev Hook that is called before any token transfer. This includes minting
1045      * and burning.
1046      *
1047      * Calling conditions:
1048      *
1049      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1050      * transferred to `to`.
1051      * - When `from` is zero, `tokenId` will be minted for `to`.
1052      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1053      * - `from` cannot be the zero address.
1054      * - `to` cannot be the zero address.
1055      *
1056      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1057      */
1058     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1059 }
1060 
1061 
1062 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.0.0
1063 
1064 
1065 
1066 pragma solidity ^0.8.0;
1067 
1068 
1069 /**
1070  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1071  * enumerability of all the token ids in the contract as well as all token ids owned by each
1072  * account.
1073  */
1074 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1075     // Mapping from owner to list of owned token IDs
1076     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1077 
1078     // Mapping from token ID to index of the owner tokens list
1079     mapping(uint256 => uint256) private _ownedTokensIndex;
1080 
1081     // Array with all token ids, used for enumeration
1082     uint256[] private _allTokens;
1083 
1084     // Mapping from token id to position in the allTokens array
1085     mapping(uint256 => uint256) private _allTokensIndex;
1086 
1087     /**
1088      * @dev See {IERC165-supportsInterface}.
1089      */
1090     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1091         return interfaceId == type(IERC721Enumerable).interfaceId
1092             || super.supportsInterface(interfaceId);
1093     }
1094 
1095     /**
1096      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1097      */
1098     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1099         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1100         return _ownedTokens[owner][index];
1101     }
1102 
1103     /**
1104      * @dev See {IERC721Enumerable-totalSupply}.
1105      */
1106     function totalSupply() public view virtual override returns (uint256) {
1107         return _allTokens.length;
1108     }
1109 
1110     /**
1111      * @dev See {IERC721Enumerable-tokenByIndex}.
1112      */
1113     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1114         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1115         return _allTokens[index];
1116     }
1117 
1118     /**
1119      * @dev Hook that is called before any token transfer. This includes minting
1120      * and burning.
1121      *
1122      * Calling conditions:
1123      *
1124      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1125      * transferred to `to`.
1126      * - When `from` is zero, `tokenId` will be minted for `to`.
1127      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1128      * - `from` cannot be the zero address.
1129      * - `to` cannot be the zero address.
1130      *
1131      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1132      */
1133     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1134         super._beforeTokenTransfer(from, to, tokenId);
1135 
1136         if (from == address(0)) {
1137             _addTokenToAllTokensEnumeration(tokenId);
1138         } else if (from != to) {
1139             _removeTokenFromOwnerEnumeration(from, tokenId);
1140         }
1141         if (to == address(0)) {
1142             _removeTokenFromAllTokensEnumeration(tokenId);
1143         } else if (to != from) {
1144             _addTokenToOwnerEnumeration(to, tokenId);
1145         }
1146     }
1147 
1148     /**
1149      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1150      * @param to address representing the new owner of the given token ID
1151      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1152      */
1153     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1154         uint256 length = ERC721.balanceOf(to);
1155         _ownedTokens[to][length] = tokenId;
1156         _ownedTokensIndex[tokenId] = length;
1157     }
1158 
1159     /**
1160      * @dev Private function to add a token to this extension's token tracking data structures.
1161      * @param tokenId uint256 ID of the token to be added to the tokens list
1162      */
1163     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1164         _allTokensIndex[tokenId] = _allTokens.length;
1165         _allTokens.push(tokenId);
1166     }
1167 
1168     /**
1169      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1170      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1171      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1172      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1173      * @param from address representing the previous owner of the given token ID
1174      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1175      */
1176     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1177         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1178         // then delete the last slot (swap and pop).
1179 
1180         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1181         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1182 
1183         // When the token to delete is the last token, the swap operation is unnecessary
1184         if (tokenIndex != lastTokenIndex) {
1185             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1186 
1187             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1188             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1189         }
1190 
1191         // This also deletes the contents at the last position of the array
1192         delete _ownedTokensIndex[tokenId];
1193         delete _ownedTokens[from][lastTokenIndex];
1194     }
1195 
1196     /**
1197      * @dev Private function to remove a token from this extension's token tracking data structures.
1198      * This has O(1) time complexity, but alters the order of the _allTokens array.
1199      * @param tokenId uint256 ID of the token to be removed from the tokens list
1200      */
1201     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1202         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1203         // then delete the last slot (swap and pop).
1204 
1205         uint256 lastTokenIndex = _allTokens.length - 1;
1206         uint256 tokenIndex = _allTokensIndex[tokenId];
1207 
1208         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1209         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1210         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1211         uint256 lastTokenId = _allTokens[lastTokenIndex];
1212 
1213         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1214         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1215 
1216         // This also deletes the contents at the last position of the array
1217         delete _allTokensIndex[tokenId];
1218         _allTokens.pop();
1219     }
1220 }
1221 
1222 
1223 // File contracts/ERC721OnOpenSea.sol
1224 
1225 
1226 
1227 pragma solidity ^0.8.0;
1228 
1229 interface ProxyRegistry {
1230     function proxies(address) external view returns (address);
1231 }
1232 
1233 /**
1234  * @dev helper contract to allow gasless OpenSea listings
1235  */
1236 contract ERC721OnOpenSea is ERC721Enumerable {
1237     address public proxyRegistryAddress;
1238 
1239     constructor(
1240         string memory name,
1241         string memory symbol,
1242         address registryProxyAddress_
1243     ) ERC721(name, symbol) {
1244         proxyRegistryAddress = registryProxyAddress_;
1245     }
1246 
1247     function isApprovedForAll(address owner, address operator)
1248         public
1249         view
1250         override
1251         returns (bool)
1252     {
1253         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1254 
1255         if (address(proxyRegistry.proxies(owner)) == operator) {
1256             return true;
1257         }
1258 
1259         return super.isApprovedForAll(owner, operator);
1260     }
1261 }
1262 
1263 
1264 // File contracts/interfaces/IUniswapV2Router02Minimal.sol
1265 
1266 
1267 
1268 pragma solidity ^0.8.0;
1269 
1270 interface IUniswapV2Router02Minimal {
1271     function WETH() external pure returns (address);
1272     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1273         uint256 amountOutMin,
1274         address[] calldata path,
1275         address to,
1276         uint256 deadline
1277     ) external payable;
1278 }
1279 
1280 
1281 // File contracts/interfaces/IDoomCat.sol
1282 
1283 
1284 
1285 pragma solidity ^0.8.0;
1286 
1287 interface IDoomCat {
1288     function mint(address, uint256) external;
1289     function swapAndBurn(uint256) external;
1290 }
1291 
1292 
1293 // File contracts/DoomCatRescue.sol
1294 
1295 
1296 
1297 pragma solidity ^0.8.0;
1298 
1299 /**
1300  * @dev we rescue the cats
1301  */
1302 contract DoomCatRescue {
1303     // reference to, basically, self
1304     IDoomCat private _doomCat;
1305 
1306     // total number of cats that exist
1307     uint256 public immutable totalCats;
1308 
1309     // how many cats initially existed to be rescued
1310     uint256 private immutable _remainingCatsInitial;
1311 
1312     // how many cats are left to be rescued
1313     uint256 public remainingCats;
1314 
1315     // when rescues can begin
1316     uint256 public immutable rescueStartTime;
1317 
1318     // initial price of rescues
1319     uint256 public immutable rescuePriceInitial;
1320 
1321     // current price of rescues
1322     uint256 public rescuePrice;
1323 
1324     // amount of rescue price increases
1325     uint256 public immutable rescuePriceIncrement;
1326 
1327     // amount of cats to rescue before price increase is triggered
1328     uint256 public immutable rescueTrancheSize;
1329 
1330     // how many blocks must exist between rescues for a given address
1331     uint256 public immutable rescueRateLimit;
1332 
1333     // track last block that an address performed a rescue
1334     mapping(address => uint256) public rescueLastBlock;
1335 
1336     // how many funds have been collected for rescues (resets every tranche)
1337     uint256 private collectedRescueFunds;
1338 
1339     event Rescue(address indexed rescuer, uint256 tokenId, uint256 price);
1340 
1341     constructor(
1342         IDoomCat doomCat_,
1343         uint256[2] memory catDetails_,
1344         uint256[5] memory rescueDetails_
1345     ) {
1346         _doomCat = doomCat_;
1347 
1348         totalCats = catDetails_[0];
1349         _remainingCatsInitial = catDetails_[1];
1350         remainingCats = catDetails_[1];
1351 
1352         rescuePriceInitial = rescueDetails_[0];
1353         rescuePrice = rescueDetails_[0];
1354         rescuePriceIncrement = rescueDetails_[1];
1355         rescueTrancheSize = rescueDetails_[2];
1356         rescueStartTime = rescueDetails_[3];
1357         rescueRateLimit = rescueDetails_[4];
1358     }
1359 
1360     /**
1361      * @dev public function to rescue a cat
1362      */
1363     function rescue() public payable {
1364         // require that rescues have globally started
1365         require(block.timestamp >= rescueStartTime, "too early");
1366         
1367         // require that address has passed their rate limit
1368         require(
1369             block.number >= rescueLastBlock[msg.sender] + rescueRateLimit,
1370             "too soon"
1371         );
1372 
1373         // require that there are cats left to be rescued
1374         require(remainingCats > 0, "no cats left");
1375 
1376         // require that the correct amount is paid (at minimum)
1377         require(msg.value >= rescuePrice, "value too low");
1378 
1379         // update address' last block rate limit tracker
1380         rescueLastBlock[msg.sender] = block.number;
1381 
1382         // grab the current rescue price (for use after updating `rescuePrice`)
1383         uint256 currentRescuePrice = rescuePrice;
1384 
1385         // update the amount of funds that have been used for rescues
1386         collectedRescueFunds += currentRescuePrice;
1387 
1388         // decrement remaining cats
1389         remainingCats--;
1390 
1391         // if we are at a tranch boundary, OR, there are no remaining cats, then
1392         // we want to update the price and swap & burn all collected ETH from previous
1393         // tranche
1394         if (
1395             (_remainingCatsInitial - remainingCats) % rescueTrancheSize == 0 ||
1396             remainingCats == 0
1397         ) {
1398             // if there are no more cats, set rescuePrice at 0 for cleanup sake
1399             if (remainingCats == 0) {
1400                 rescuePrice = 0;
1401             } else {
1402                 // otherwise, increment rescuePrice by the increment amount
1403                 rescuePrice += rescuePriceIncrement;
1404             }
1405 
1406             // swap and burn collected funds
1407             _doomCat.swapAndBurn(collectedRescueFunds);
1408 
1409             // reset collected funds back to 0
1410             collectedRescueFunds = 0;
1411         }
1412 
1413         // get the tokenId for the cat to mint, mint it
1414         uint256 tokenId = totalCats - remainingCats;
1415         _doomCat.mint(msg.sender, tokenId);
1416 
1417         // if the user overpaid, refund their Ether
1418         if (msg.value > currentRescuePrice) {
1419             payable(msg.sender).transfer(msg.value - currentRescuePrice);
1420         }
1421 
1422         emit Rescue(msg.sender, tokenId, rescuePrice);
1423     }
1424 }
1425 
1426 
1427 // File contracts/DoomCatAuction.sol
1428 
1429 
1430 
1431 pragma solidity ^0.8.0;
1432 
1433 /**
1434  * @dev we auction the genesis cats
1435  */
1436 contract DoomCatAuction {
1437     // reference to, basically, self
1438     IDoomCat private _doomCat;
1439 
1440     // number of total genesis cats
1441     uint256 public immutable genesisCats;
1442 
1443     // start time of the first auction
1444     uint64 public immutable auctionsStart;
1445 
1446     // how long auctions last
1447     uint64 public immutable auctionsDuration;
1448 
1449     // time between end of one auction, and beginning of next auction
1450     uint64 public immutable auctionsDistance;
1451 
1452     // number of total auctions to perform
1453     uint64 public immutable auctionsCount;
1454 
1455     // number of cats being auctioned off per auction
1456     uint64 public immutable auctionsCatsPerAuction;
1457 
1458     // minimum bid increase amount
1459     uint64 public immutable auctionsBidIncrement;
1460 
1461     // track number of bids that have been placed for a cat
1462     mapping(uint256 => uint256) public bidCount;
1463 
1464     // track the highest bid amount for a cat
1465     mapping(uint256 => uint256) public highBidAmount;
1466 
1467     // track the owner of the highest bid for a cat
1468     mapping(uint256 => address) public highBidOwner;
1469 
1470     // track all of the bids (per address) for cats
1471     mapping(uint256 => mapping(address => uint256)) public bidsByTokenByAddress;
1472 
1473     event Bid(
1474         address indexed account,
1475         uint256 catId,
1476         uint256 amount,
1477         uint256 bidCount
1478     );
1479     event WithdrawLowBid(
1480         address indexed account,
1481         uint256 catId,
1482         uint256 amount
1483     );
1484     event ClaimWinningBid(
1485         address indexed account,
1486         uint256 catId,
1487         uint256 amount
1488     );
1489 
1490     constructor(IDoomCat doomCat_, uint64[6] memory auctionsDetails_) {
1491         _doomCat = doomCat_;
1492 
1493         genesisCats = auctionsDetails_[3] * auctionsDetails_[4];
1494 
1495         auctionsStart = auctionsDetails_[0];
1496         auctionsDuration = auctionsDetails_[1];
1497         auctionsDistance = auctionsDetails_[2];
1498         auctionsCount = auctionsDetails_[3];
1499         auctionsCatsPerAuction = auctionsDetails_[4];
1500         auctionsBidIncrement = auctionsDetails_[5];
1501 
1502         require(auctionsDetails_[0] >= block.timestamp, "too late");
1503     }
1504 
1505     /**
1506      * @dev helper function which returns two integers:
1507      * 1) startId: the ID of a cat which signifies the "lowest" ID of the most recent (or current) auction set
1508      * 2) endId: the ID of a cat which signifies the "highest" ID of the most recent (or current) auction set
1509      * if (startId > endId), that means that no auction is currently happening, but exposes
1510      *   information about the most recently completed auction
1511      * if (startId <= endId), that means that an auction is currently happening, for that range of IDs
1512      */
1513     function auctionsState() public view returns (uint256, uint256) {
1514         uint64 checkedAuctions = 0;
1515         uint256 startId = 0;
1516         uint256 endId = 0;
1517 
1518         // loop through each auction
1519         while (checkedAuctions <= auctionsCount) {
1520             // calculate the start time of the current auction iteration
1521             uint64 auctionStart =
1522                 auctionsStart +
1523                     (checkedAuctions * (auctionsDuration + auctionsDistance));
1524 
1525             // if the auction starts in the future, we're done with this while loop
1526             if (auctionStart > block.timestamp) {
1527                 break;
1528             }
1529             // otherwise, the auction is currently in progress, or over
1530 
1531             // regardless of in progress or over, we need to calculate the startID
1532             // which is done by multiplying our auction iteration by number of cats
1533             // per auction plus 1 because cat ids start at 1
1534             startId = checkedAuctions * auctionsCatsPerAuction + 1;
1535 
1536             // add duration to start time, compare to current timestamp, to see if
1537             // we're currently in auction
1538             if (auctionStart + auctionsDuration > block.timestamp) {
1539                 // if we're in an auction, break the loop and don't update endId
1540                 break;
1541             } else {
1542                 // if the auction ended in the past, update endId
1543                 endId =
1544                     checkedAuctions *
1545                     auctionsCatsPerAuction +
1546                     auctionsCatsPerAuction;
1547             }
1548 
1549             // iterate
1550             checkedAuctions++;
1551         }
1552 
1553         return (startId, endId);
1554     }
1555 
1556     /**
1557      * @dev how many genesis cats are remaining
1558      */
1559     function remainingGenesisCats() public view returns (uint256) {
1560         (, uint256 endId) = auctionsState();
1561         return genesisCats - endId;
1562     }
1563 
1564     /**
1565      * @dev place a bid for a cat, referenced by its index in the current auction
1566      */
1567     function bid(uint64 index) public payable {
1568         (uint256 startId, uint256 endId) = auctionsState();
1569 
1570         // bids can only be placed while in an auction
1571         require(startId > endId, "not in auction");
1572 
1573         // cats are referenced by their index in the auction
1574         require(index < auctionsCatsPerAuction, "bad index");
1575         uint256 catId = startId + index;
1576 
1577         // users may increase their bid by sending the difference of the total amount
1578         // they want to bid, and their current bid
1579         uint256 newBid = bidsByTokenByAddress[catId][msg.sender] + msg.value;
1580 
1581         // make sure their new bid covers the bid increment amount
1582         require(
1583             newBid >= highBidAmount[catId] + auctionsBidIncrement,
1584             "not enough"
1585         );
1586 
1587         // increment the bid count
1588         bidCount[catId] += 1;
1589 
1590         // set the high bid amount
1591         highBidAmount[catId] = newBid;
1592 
1593         // set the high bid owner
1594         highBidOwner[catId] = msg.sender;
1595 
1596         // set the user's bid on this cat (for withdraws, later)
1597         bidsByTokenByAddress[catId][msg.sender] = newBid;
1598 
1599         emit Bid(msg.sender, catId, newBid, bidCount[catId]);
1600     }
1601 
1602     /**
1603      * @dev bids which have been outbid can be "withdrawn" and their Ether returned
1604      * highest current bid cannot be withdrawn
1605      */
1606     function withdrawLowBid(uint256 catId) public {
1607         // if user is the current highest bid for the cat, no can withdraw
1608         require(msg.sender != highBidOwner[catId], "can't withdraw high bid");
1609 
1610         // get reference to their bid amount
1611         uint256 bidAmount = bidsByTokenByAddress[catId][msg.sender];
1612 
1613         // make sure the user actually has funds to withdraw
1614         require(bidAmount > 0, "nothing to withdraw");
1615 
1616         // reset their amount for this cat to 0
1617         bidsByTokenByAddress[catId][msg.sender] = 0;
1618 
1619         // send the user their funds
1620         payable(msg.sender).transfer(bidAmount);
1621 
1622         emit WithdrawLowBid(msg.sender, catId, bidAmount);
1623     }
1624 
1625     /**
1626      * @dev when auction is over, highest bid can claim their cat!
1627      */
1628     function claimWinningBid(uint256 catId) public {
1629         // confirm that the cat being claimed belongs to a completed auction
1630         (, uint256 endId) = auctionsState();
1631         require(catId <= endId, "cat not claimable");
1632 
1633         // if no bids have been placed on a cat, they can be claimed first-come-first-serve
1634         if (highBidOwner[catId] != address(0)) {
1635             // otherwise, require that user is the owner of highest bid
1636             require(msg.sender == highBidOwner[catId], "not winning bid");
1637         }
1638 
1639         // mint that cat
1640         _doomCat.mint(msg.sender, catId);
1641 
1642         // only swap & burn if a bid actually exists
1643         if (highBidAmount[catId] > 0) {
1644             _doomCat.swapAndBurn(highBidAmount[catId]);
1645         }
1646 
1647         emit ClaimWinningBid(msg.sender, catId, highBidAmount[catId]);
1648     }
1649 }
1650 
1651 
1652 // File contracts/DoomCat.sol
1653 
1654 
1655 
1656 pragma solidity ^0.8.0;
1657 
1658 
1659 
1660 
1661 
1662 
1663 /**
1664  * @dev we like the cats
1665  */
1666 contract DoomCat is IDoomCat, DoomCatRescue, DoomCatAuction, ERC721OnOpenSea {
1667     string private __baseURI;
1668     
1669     // there's an owner, but they can only update the BaseURI
1670     address public owner;
1671 
1672     // track the cat names here
1673     mapping(uint256 => string) public catNames;
1674 
1675     // how much does a name change cost
1676     uint256 public nameChangePrice;
1677 
1678     // reference to the token (HATE) that all funds will be swapped into
1679     address public immutable HATE;
1680 
1681     // reference to the address where all swapped HATE will be burned to
1682     address public immutable burn;
1683 
1684     // uniswap router address
1685     IUniswapV2Router02Minimal public immutable uniswapV2Router;
1686     
1687     // events for public functions
1688     event NameCat(address indexed account, uint256 catId, string name);
1689     event UpdateBaseURI(string baseURI);
1690     event RevokeOwner();
1691 
1692     constructor(
1693         address[4] memory addresses,
1694         string memory baseURI_,
1695         uint32 normalCats_,
1696         uint256[5] memory rescueDetails_,
1697         uint64[6] memory auctionsDetails_,
1698         uint256 nameChangePrice_
1699     )
1700         ERC721OnOpenSea("DoomCatRescue", "DOOM", addresses[3])
1701         DoomCatRescue(
1702             IDoomCat(address(this)),
1703             [
1704                 uint256(
1705                     auctionsDetails_[3] * auctionsDetails_[4] + normalCats_
1706                 ),
1707                 normalCats_
1708             ],
1709             rescueDetails_
1710         )
1711         DoomCatAuction(IDoomCat(address(this)), auctionsDetails_)
1712     {
1713         HATE = addresses[0];
1714         uniswapV2Router = IUniswapV2Router02Minimal(addresses[1]);
1715         burn = addresses[2];
1716         __baseURI = baseURI_;
1717         owner = msg.sender;
1718         nameChangePrice = nameChangePrice_;
1719     }
1720 
1721     /**
1722      * @dev override OZ ERC721 _baseURI() function
1723      */
1724     function _baseURI() internal view virtual override returns (string memory) {
1725         return __baseURI;
1726     }
1727 
1728     /**
1729      * @dev we want to be able to update this later, to fully decentralize it
1730      */
1731     function updateBaseURI(string calldata baseURI) public {
1732         require(msg.sender == owner, "not owner");
1733         __baseURI = baseURI;
1734         emit UpdateBaseURI(baseURI);
1735     }
1736 
1737     /**
1738      * @dev after getting baseURI into it's final form, revoke ownership
1739      */
1740     function revokeOwner() public {
1741         require(msg.sender == owner, "not owner");
1742         owner = address(0);
1743         emit RevokeOwner();
1744     }
1745 
1746     /**
1747      * @dev mint a new token to recipient with specified id, but only from current contract
1748      */
1749     function mint(address to_, uint256 tokenId_) public override {
1750         require(msg.sender == address(this), "can't mint");
1751         _mint(to_, tokenId_);
1752     }
1753 
1754     /**
1755      * @dev given an amount of Ether, swap all for HATE and send to burn address
1756      */
1757     function swapAndBurn(uint256 _amount) public override {
1758         require(msg.sender == address(this), "can't swap and burn");
1759 
1760         address[] memory path = new address[](2);
1761         path[0] = uniswapV2Router.WETH();
1762         path[1] = HATE;
1763 
1764         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
1765             value: _amount
1766         }(0, path, burn, block.timestamp);
1767     }
1768 
1769     /**
1770      * @dev owner of a cat can name a cat, once
1771      */
1772     function nameCat(uint256 catId, string calldata catName) external {
1773         require(ownerOf(catId) == msg.sender, "not your cat");
1774 
1775         // can only name a cat if it's not already named
1776         bytes memory currentName = bytes(catNames[catId]);
1777         require(currentName.length == 0, "already named");
1778 
1779         catNames[catId] = catName;
1780         IERC20(HATE).transferFrom(msg.sender, burn, nameChangePrice);
1781 
1782         emit NameCat(msg.sender, catId, catName);
1783     }
1784 }