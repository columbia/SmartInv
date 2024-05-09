1 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 /*
7                                                                .-'''-.                                              
8                                                               '   _    \            .---.                           
9 /|                  /|                                      /   /` '.   \ /|        |   |.--.   _..._               
10 ||                  ||    .-.          .-            .--./).   |     \  ' ||        |   ||__| .'     '.             
11 ||                  ||     \ \        / /           /.''\\ |   '      |  '||        |   |.--..   .-.   .            
12 ||  __        __    ||  __  \ \      / /           | |  | |\    \     / / ||  __    |   ||  ||  '   '  |            
13 ||/'__ '.  .:--.'.  ||/'__ '.\ \    / /             \`-' /  `.   ` ..' /  ||/'__ '. |   ||  ||  |   |  |.--------.  
14 |:/`  '. '/ |   \ | |:/`  '. '\ \  / /              /("'`      '-...-'`   |:/`  '. '|   ||  ||  |   |  ||____    |  
15 ||     | |`" __ | | ||     | | \ `  /               \ '---.               ||     | ||   ||  ||  |   |  |    /   /   
16 ||\    / ' .'.''| | ||\    / '  \  /                 /'""'.\              ||\    / '|   ||__||  |   |  |  .'   /    
17 |/\'..' / / /   | |_|/\'..' /   / /                 ||     ||             |/\'..' / '---'    |  |   |  | /    /___  
18 '  `'-'`  \ \._,\ '/'  `'-'`|`-' /                  \'. __//              '  `'-'`           |  |   |  ||         | 
19            `--'  `"          '..'                    `'---'                                  '--'   '--'|_________| 
20 */
21 
22 pragma solidity ^0.8.0;
23 
24 /**
25  * @dev Provides information about the current execution context, including the
26  * sender of the transaction and its data. While these are generally available
27  * via msg.sender and msg.data, they should not be accessed in such a direct
28  * manner, since when dealing with meta-transactions the account sending and
29  * paying for execution may not be the actual sender (as far as an application
30  * is concerned).
31  *
32  * This contract is only required for intermediate, library-like contracts.
33  */
34 abstract contract Context {
35     function _msgSender() internal view virtual returns (address) {
36         return msg.sender;
37     }
38 
39     function _msgData() internal view virtual returns (bytes calldata) {
40         return msg.data;
41     }
42 }
43 
44 
45 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
46 
47 
48 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
49 
50 
51 
52 /**
53  * @dev Contract module which provides a basic access control mechanism, where
54  * there is an account (an owner) that can be granted exclusive access to
55  * specific functions.
56  *
57  * By default, the owner account will be the one that deploys the contract. This
58  * can later be changed with {transferOwnership}.
59  *
60  * This module is used through inheritance. It will make available the modifier
61  * `onlyOwner`, which can be applied to your functions to restrict their use to
62  * the owner.
63  */
64 abstract contract Ownable is Context {
65     address private _owner;
66 
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     /**
70      * @dev Initializes the contract setting the deployer as the initial owner.
71      */
72     constructor() {
73         _transferOwnership(_msgSender());
74     }
75 
76     /**
77      * @dev Returns the address of the current owner.
78      */
79     function owner() public view virtual returns (address) {
80         return _owner;
81     }
82 
83     /**
84      * @dev Throws if called by any account other than the owner.
85      */
86     modifier onlyOwner() {
87         require(owner() == _msgSender(), "Ownable: caller is not the owner");
88         _;
89     }
90 
91     /**
92      * @dev Leaves the contract without owner. It will not be possible to call
93      * `onlyOwner` functions anymore. Can only be called by the current owner.
94      *
95      * NOTE: Renouncing ownership will leave the contract without an owner,
96      * thereby removing any functionality that is only available to the owner.
97      */
98     function renounceOwnership() public virtual onlyOwner {
99         _transferOwnership(address(0));
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Can only be called by the current owner.
105      */
106     function transferOwnership(address newOwner) public virtual onlyOwner {
107         require(newOwner != address(0), "Ownable: new owner is the zero address");
108         _transferOwnership(newOwner);
109     }
110 
111     /**
112      * @dev Transfers ownership of the contract to a new account (`newOwner`).
113      * Internal function without access restriction.
114      */
115     function _transferOwnership(address newOwner) internal virtual {
116         address oldOwner = _owner;
117         _owner = newOwner;
118         emit OwnershipTransferred(oldOwner, newOwner);
119     }
120 }
121 
122 
123 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
124 
125 
126 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
127 
128 
129 
130 /**
131  * @dev String operations.
132  */
133 library Strings {
134     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
135 
136     /**
137      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
138      */
139     function toString(uint256 value) internal pure returns (string memory) {
140         // Inspired by OraclizeAPI's implementation - MIT licence
141         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
142 
143         if (value == 0) {
144             return "0";
145         }
146         uint256 temp = value;
147         uint256 digits;
148         while (temp != 0) {
149             digits++;
150             temp /= 10;
151         }
152         bytes memory buffer = new bytes(digits);
153         while (value != 0) {
154             digits -= 1;
155             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
156             value /= 10;
157         }
158         return string(buffer);
159     }
160 
161     /**
162      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
163      */
164     function toHexString(uint256 value) internal pure returns (string memory) {
165         if (value == 0) {
166             return "0x00";
167         }
168         uint256 temp = value;
169         uint256 length = 0;
170         while (temp != 0) {
171             length++;
172             temp >>= 8;
173         }
174         return toHexString(value, length);
175     }
176 
177     /**
178      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
179      */
180     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
181         bytes memory buffer = new bytes(2 * length + 2);
182         buffer[0] = "0";
183         buffer[1] = "x";
184         for (uint256 i = 2 * length + 1; i > 1; --i) {
185             buffer[i] = _HEX_SYMBOLS[value & 0xf];
186             value >>= 4;
187         }
188         require(value == 0, "Strings: hex length insufficient");
189         return string(buffer);
190     }
191 }
192 
193 
194 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
195 
196 
197 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
198 
199 
200 
201 /**
202  * @dev Interface of the ERC165 standard, as defined in the
203  * https://eips.ethereum.org/EIPS/eip-165[EIP].
204  *
205  * Implementers can declare support of contract interfaces, which can then be
206  * queried by others ({ERC165Checker}).
207  *
208  * For an implementation, see {ERC165}.
209  */
210 interface IERC165 {
211     /**
212      * @dev Returns true if this contract implements the interface defined by
213      * `interfaceId`. See the corresponding
214      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
215      * to learn more about how these ids are created.
216      *
217      * This function call must use less than 30 000 gas.
218      */
219     function supportsInterface(bytes4 interfaceId) external view returns (bool);
220 }
221 
222 
223 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
224 
225 
226 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
227 
228 
229 
230 /**
231  * @dev Required interface of an ERC721 compliant contract.
232  */
233 interface IERC721 is IERC165 {
234     /**
235      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
236      */
237     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
238 
239     /**
240      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
241      */
242     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
243 
244     /**
245      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
246      */
247     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
248 
249     /**
250      * @dev Returns the number of tokens in ``owner``'s account.
251      */
252     function balanceOf(address owner) external view returns (uint256 balance);
253 
254     /**
255      * @dev Returns the owner of the `tokenId` token.
256      *
257      * Requirements:
258      *
259      * - `tokenId` must exist.
260      */
261     function ownerOf(uint256 tokenId) external view returns (address owner);
262 
263     /**
264      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
265      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
266      *
267      * Requirements:
268      *
269      * - `from` cannot be the zero address.
270      * - `to` cannot be the zero address.
271      * - `tokenId` token must exist and be owned by `from`.
272      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
273      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
274      *
275      * Emits a {Transfer} event.
276      */
277     function safeTransferFrom(
278         address from,
279         address to,
280         uint256 tokenId
281     ) external;
282 
283     /**
284      * @dev Transfers `tokenId` token from `from` to `to`.
285      *
286      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
287      *
288      * Requirements:
289      *
290      * - `from` cannot be the zero address.
291      * - `to` cannot be the zero address.
292      * - `tokenId` token must be owned by `from`.
293      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
294      *
295      * Emits a {Transfer} event.
296      */
297     function transferFrom(
298         address from,
299         address to,
300         uint256 tokenId
301     ) external;
302 
303     /**
304      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
305      * The approval is cleared when the token is transferred.
306      *
307      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
308      *
309      * Requirements:
310      *
311      * - The caller must own the token or be an approved operator.
312      * - `tokenId` must exist.
313      *
314      * Emits an {Approval} event.
315      */
316     function approve(address to, uint256 tokenId) external;
317 
318     /**
319      * @dev Returns the account approved for `tokenId` token.
320      *
321      * Requirements:
322      *
323      * - `tokenId` must exist.
324      */
325     function getApproved(uint256 tokenId) external view returns (address operator);
326 
327     /**
328      * @dev Approve or remove `operator` as an operator for the caller.
329      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
330      *
331      * Requirements:
332      *
333      * - The `operator` cannot be the caller.
334      *
335      * Emits an {ApprovalForAll} event.
336      */
337     function setApprovalForAll(address operator, bool _approved) external;
338 
339     /**
340      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
341      *
342      * See {setApprovalForAll}
343      */
344     function isApprovedForAll(address owner, address operator) external view returns (bool);
345 
346     /**
347      * @dev Safely transfers `tokenId` token from `from` to `to`.
348      *
349      * Requirements:
350      *
351      * - `from` cannot be the zero address.
352      * - `to` cannot be the zero address.
353      * - `tokenId` token must exist and be owned by `from`.
354      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
355      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
356      *
357      * Emits a {Transfer} event.
358      */
359     function safeTransferFrom(
360         address from,
361         address to,
362         uint256 tokenId,
363         bytes calldata data
364     ) external;
365 }
366 
367 
368 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
369 
370 
371 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
372 
373 
374 
375 /**
376  * @title ERC721 token receiver interface
377  * @dev Interface for any contract that wants to support safeTransfers
378  * from ERC721 asset contracts.
379  */
380 interface IERC721Receiver {
381     /**
382      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
383      * by `operator` from `from`, this function is called.
384      *
385      * It must return its Solidity selector to confirm the token transfer.
386      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
387      *
388      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
389      */
390     function onERC721Received(
391         address operator,
392         address from,
393         uint256 tokenId,
394         bytes calldata data
395     ) external returns (bytes4);
396 }
397 
398 
399 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
400 
401 
402 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
403 
404 
405 
406 /**
407  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
408  * @dev See https://eips.ethereum.org/EIPS/eip-721
409  */
410 interface IERC721Metadata is IERC721 {
411     /**
412      * @dev Returns the token collection name.
413      */
414     function name() external view returns (string memory);
415 
416     /**
417      * @dev Returns the token collection symbol.
418      */
419     function symbol() external view returns (string memory);
420 
421     /**
422      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
423      */
424     function tokenURI(uint256 tokenId) external view returns (string memory);
425 }
426 
427 
428 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
429 
430 
431 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
432 
433 
434 
435 /**
436  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
437  * @dev See https://eips.ethereum.org/EIPS/eip-721
438  */
439 interface IERC721Enumerable is IERC721 {
440     /**
441      * @dev Returns the total amount of tokens stored by the contract.
442      */
443     function totalSupply() external view returns (uint256);
444 
445     /**
446      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
447      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
448      */
449     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
450 
451     /**
452      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
453      * Use along with {totalSupply} to enumerate all tokens.
454      */
455     function tokenByIndex(uint256 index) external view returns (uint256);
456 }
457 
458 
459 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
460 
461 
462 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
463 
464 
465 
466 /**
467  * @dev Collection of functions related to the address type
468  */
469 library Address {
470     /**
471      * @dev Returns true if `account` is a contract.
472      *
473      * [IMPORTANT]
474      * ====
475      * It is unsafe to assume that an address for which this function returns
476      * false is an externally-owned account (EOA) and not a contract.
477      *
478      * Among others, `isContract` will return false for the following
479      * types of addresses:
480      *
481      *  - an externally-owned account
482      *  - a contract in construction
483      *  - an address where a contract will be created
484      *  - an address where a contract lived, but was destroyed
485      * ====
486      */
487     function isContract(address account) internal view returns (bool) {
488         // This method relies on extcodesize, which returns 0 for contracts in
489         // construction, since the code is only stored at the end of the
490         // constructor execution.
491 
492         uint256 size;
493         assembly {
494             size := extcodesize(account)
495         }
496         return size > 0;
497     }
498 
499     /**
500      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
501      * `recipient`, forwarding all available gas and reverting on errors.
502      *
503      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
504      * of certain opcodes, possibly making contracts go over the 2300 gas limit
505      * imposed by `transfer`, making them unable to receive funds via
506      * `transfer`. {sendValue} removes this limitation.
507      *
508      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
509      *
510      * IMPORTANT: because control is transferred to `recipient`, care must be
511      * taken to not create reentrancy vulnerabilities. Consider using
512      * {ReentrancyGuard} or the
513      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
514      */
515     function sendValue(address payable recipient, uint256 amount) internal {
516         require(address(this).balance >= amount, "Address: insufficient balance");
517 
518         (bool success, ) = recipient.call{value: amount}("");
519         require(success, "Address: unable to send value, recipient may have reverted");
520     }
521 
522     /**
523      * @dev Performs a Solidity function call using a low level `call`. A
524      * plain `call` is an unsafe replacement for a function call: use this
525      * function instead.
526      *
527      * If `target` reverts with a revert reason, it is bubbled up by this
528      * function (like regular Solidity function calls).
529      *
530      * Returns the raw returned data. To convert to the expected return value,
531      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
532      *
533      * Requirements:
534      *
535      * - `target` must be a contract.
536      * - calling `target` with `data` must not revert.
537      *
538      * _Available since v3.1._
539      */
540     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
541         return functionCall(target, data, "Address: low-level call failed");
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
546      * `errorMessage` as a fallback revert reason when `target` reverts.
547      *
548      * _Available since v3.1._
549      */
550     function functionCall(
551         address target,
552         bytes memory data,
553         string memory errorMessage
554     ) internal returns (bytes memory) {
555         return functionCallWithValue(target, data, 0, errorMessage);
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
560      * but also transferring `value` wei to `target`.
561      *
562      * Requirements:
563      *
564      * - the calling contract must have an ETH balance of at least `value`.
565      * - the called Solidity function must be `payable`.
566      *
567      * _Available since v3.1._
568      */
569     function functionCallWithValue(
570         address target,
571         bytes memory data,
572         uint256 value
573     ) internal returns (bytes memory) {
574         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
575     }
576 
577     /**
578      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
579      * with `errorMessage` as a fallback revert reason when `target` reverts.
580      *
581      * _Available since v3.1._
582      */
583     function functionCallWithValue(
584         address target,
585         bytes memory data,
586         uint256 value,
587         string memory errorMessage
588     ) internal returns (bytes memory) {
589         require(address(this).balance >= value, "Address: insufficient balance for call");
590         require(isContract(target), "Address: call to non-contract");
591 
592         (bool success, bytes memory returndata) = target.call{value: value}(data);
593         return verifyCallResult(success, returndata, errorMessage);
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
598      * but performing a static call.
599      *
600      * _Available since v3.3._
601      */
602     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
603         return functionStaticCall(target, data, "Address: low-level static call failed");
604     }
605 
606     /**
607      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
608      * but performing a static call.
609      *
610      * _Available since v3.3._
611      */
612     function functionStaticCall(
613         address target,
614         bytes memory data,
615         string memory errorMessage
616     ) internal view returns (bytes memory) {
617         require(isContract(target), "Address: static call to non-contract");
618 
619         (bool success, bytes memory returndata) = target.staticcall(data);
620         return verifyCallResult(success, returndata, errorMessage);
621     }
622 
623     /**
624      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
625      * but performing a delegate call.
626      *
627      * _Available since v3.4._
628      */
629     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
630         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
631     }
632 
633     /**
634      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
635      * but performing a delegate call.
636      *
637      * _Available since v3.4._
638      */
639     function functionDelegateCall(
640         address target,
641         bytes memory data,
642         string memory errorMessage
643     ) internal returns (bytes memory) {
644         require(isContract(target), "Address: delegate call to non-contract");
645 
646         (bool success, bytes memory returndata) = target.delegatecall(data);
647         return verifyCallResult(success, returndata, errorMessage);
648     }
649 
650     /**
651      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
652      * revert reason using the provided one.
653      *
654      * _Available since v4.3._
655      */
656     function verifyCallResult(
657         bool success,
658         bytes memory returndata,
659         string memory errorMessage
660     ) internal pure returns (bytes memory) {
661         if (success) {
662             return returndata;
663         } else {
664             // Look for revert reason and bubble it up if present
665             if (returndata.length > 0) {
666                 // The easiest way to bubble the revert reason is using memory via assembly
667 
668                 assembly {
669                     let returndata_size := mload(returndata)
670                     revert(add(32, returndata), returndata_size)
671                 }
672             } else {
673                 revert(errorMessage);
674             }
675         }
676     }
677 }
678 
679 
680 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
681 
682 
683 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
684 
685 
686 
687 /**
688  * @dev Implementation of the {IERC165} interface.
689  *
690  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
691  * for the additional interface id that will be supported. For example:
692  *
693  * ```solidity
694  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
695  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
696  * }
697  * ```
698  *
699  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
700  */
701 abstract contract ERC165 is IERC165 {
702     /**
703      * @dev See {IERC165-supportsInterface}.
704      */
705     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
706         return interfaceId == type(IERC165).interfaceId;
707     }
708 }
709 
710 
711 // File contracts/ERC721A.sol
712 
713 
714 // Creator: Chiru Labs
715 
716 
717 /**
718  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
719  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
720  *
721  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
722  *
723  * Does not support burning tokens to address(0).
724  *
725  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
726  */
727 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
728     using Address for address;
729     using Strings for uint256;
730 
731     struct TokenOwnership {
732         address addr;
733         uint64 startTimestamp;
734     }
735 
736     struct AddressData {
737         uint128 balance;
738         uint128 numberMinted;
739     }
740 
741     uint256 internal currentIndex = 1;
742 
743     // Token name
744     string private _name;
745 
746     // Token symbol
747     string private _symbol;
748 
749     // Mapping from token ID to ownership details
750     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
751     mapping(uint256 => TokenOwnership) internal _ownerships;
752 
753     // Mapping owner address to address data
754     mapping(address => AddressData) private _addressData;
755 
756     // Mapping from token ID to approved address
757     mapping(uint256 => address) private _tokenApprovals;
758 
759     // Mapping from owner to operator approvals
760     mapping(address => mapping(address => bool)) private _operatorApprovals;
761 
762     constructor(string memory name_, string memory symbol_) {
763         _name = name_;
764         _symbol = symbol_;
765     }
766 
767     /**
768      * @dev See {IERC721Enumerable-totalSupply}.
769      */
770     function totalSupply() public view override returns (uint256) {
771         return currentIndex;
772     }
773 
774     /**
775      * @dev See {IERC721Enumerable-tokenByIndex}.
776      */
777     function tokenByIndex(uint256 index) public view override returns (uint256) {
778         require(index < totalSupply(), 'ERC721A: global index out of bounds');
779         return index;
780     }
781 
782     /**
783      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
784      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
785      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
786      */
787     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
788         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
789         uint256 numMintedSoFar = totalSupply();
790         uint256 tokenIdsIdx = 0;
791         address currOwnershipAddr = address(0);
792         for (uint256 i = 0; i < numMintedSoFar; i++) {
793             TokenOwnership memory ownership = _ownerships[i];
794             if (ownership.addr != address(0)) {
795                 currOwnershipAddr = ownership.addr;
796             }
797             if (currOwnershipAddr == owner) {
798                 if (tokenIdsIdx == index) {
799                     return i;
800                 }
801                 tokenIdsIdx++;
802             }
803         }
804         revert('ERC721A: unable to get token of owner by index');
805     }
806 
807     /**
808      * @dev See {IERC165-supportsInterface}.
809      */
810     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
811         return
812             interfaceId == type(IERC721).interfaceId ||
813             interfaceId == type(IERC721Metadata).interfaceId ||
814             interfaceId == type(IERC721Enumerable).interfaceId ||
815             super.supportsInterface(interfaceId);
816     }
817 
818     /**
819      * @dev See {IERC721-balanceOf}.
820      */
821     function balanceOf(address owner) public view override returns (uint256) {
822         require(owner != address(0), 'ERC721A: balance query for the zero address');
823         return uint256(_addressData[owner].balance);
824     }
825 
826     function _numberMinted(address owner) internal view returns (uint256) {
827         require(owner != address(0), 'ERC721A: number minted query for the zero address');
828         return uint256(_addressData[owner].numberMinted);
829     }
830 
831     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
832         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
833 
834         for (uint256 curr = tokenId; ; curr--) {
835             TokenOwnership memory ownership = _ownerships[curr];
836             if (ownership.addr != address(0)) {
837                 return ownership;
838             }
839         }
840 
841         revert('ERC721A: unable to determine the owner of token');
842     }
843 
844     /**
845      * @dev See {IERC721-ownerOf}.
846      */
847     function ownerOf(uint256 tokenId) public view override returns (address) {
848         return ownershipOf(tokenId).addr;
849     }
850 
851     /**
852      * @dev See {IERC721Metadata-name}.
853      */
854     function name() public view virtual override returns (string memory) {
855         return _name;
856     }
857 
858     /**
859      * @dev See {IERC721Metadata-symbol}.
860      */
861     function symbol() public view virtual override returns (string memory) {
862         return _symbol;
863     }
864 
865     /**
866      * @dev See {IERC721Metadata-tokenURI}.
867      */
868     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
869         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
870 
871         string memory baseURI = _baseURI();
872         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
873     }
874 
875     /**
876      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
877      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
878      * by default, can be overriden in child contracts.
879      */
880     function _baseURI() internal view virtual returns (string memory) {
881         return '';
882     }
883 
884     /**
885      * @dev See {IERC721-approve}.
886      */
887     function approve(address to, uint256 tokenId) public override {
888         address owner = ERC721A.ownerOf(tokenId);
889         require(to != owner, 'ERC721A: approval to current owner');
890 
891         require(
892             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
893             'ERC721A: approve caller is not owner nor approved for all'
894         );
895 
896         _approve(to, tokenId, owner);
897     }
898 
899     /**
900      * @dev See {IERC721-getApproved}.
901      */
902     function getApproved(uint256 tokenId) public view override returns (address) {
903         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
904 
905         return _tokenApprovals[tokenId];
906     }
907 
908     /**
909      * @dev See {IERC721-setApprovalForAll}.
910      */
911     function setApprovalForAll(address operator, bool approved) public override {
912         require(operator != _msgSender(), 'ERC721A: approve to caller');
913 
914         _operatorApprovals[_msgSender()][operator] = approved;
915         emit ApprovalForAll(_msgSender(), operator, approved);
916     }
917 
918     /**
919      * @dev See {IERC721-isApprovedForAll}.
920      */
921     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
922         return _operatorApprovals[owner][operator];
923     }
924 
925     /**
926      * @dev See {IERC721-transferFrom}.
927      */
928     function transferFrom(
929         address from,
930         address to,
931         uint256 tokenId
932     ) public override {
933         _transfer(from, to, tokenId);
934     }
935 
936     /**
937      * @dev See {IERC721-safeTransferFrom}.
938      */
939     function safeTransferFrom(
940         address from,
941         address to,
942         uint256 tokenId
943     ) public override {
944         safeTransferFrom(from, to, tokenId, '');
945     }
946 
947     /**
948      * @dev See {IERC721-safeTransferFrom}.
949      */
950     function safeTransferFrom(
951         address from,
952         address to,
953         uint256 tokenId,
954         bytes memory _data
955     ) public override {
956         _transfer(from, to, tokenId);
957         require(
958             _checkOnERC721Received(from, to, tokenId, _data),
959             'ERC721A: transfer to non ERC721Receiver implementer'
960         );
961     }
962 
963     /**
964      * @dev Returns whether `tokenId` exists.
965      *
966      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
967      *
968      * Tokens start existing when they are minted (`_mint`),
969      */
970     function _exists(uint256 tokenId) internal view returns (bool) {
971         return tokenId < currentIndex;
972     }
973 
974     function _safeMint(address to, uint256 quantity) internal {
975         _safeMint(to, quantity, '');
976     }
977 
978     /**
979      * @dev Mints `quantity` tokens and transfers them to `to`.
980      *
981      * Requirements:
982      *
983      * - `to` cannot be the zero address.
984      * - `quantity` cannot be larger than the max batch size.
985      *
986      * Emits a {Transfer} event.
987      */
988     function _safeMint(
989         address to,
990         uint256 quantity,
991         bytes memory _data
992     ) internal {
993         uint256 startTokenId = currentIndex;
994         require(to != address(0), 'ERC721A: mint to the zero address');
995         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
996         require(!_exists(startTokenId), 'ERC721A: token already minted');
997         require(quantity > 0, 'ERC721A: quantity must be greater 0');
998 
999         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1000 
1001         AddressData memory addressData = _addressData[to];
1002         _addressData[to] = AddressData(
1003             addressData.balance + uint128(quantity),
1004             addressData.numberMinted + uint128(quantity)
1005         );
1006         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1007 
1008         uint256 updatedIndex = startTokenId;
1009 
1010         for (uint256 i = 0; i < quantity; i++) {
1011             emit Transfer(address(0), to, updatedIndex);
1012             require(
1013                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1014                 'ERC721A: transfer to non ERC721Receiver implementer'
1015             );
1016             updatedIndex++;
1017         }
1018 
1019         currentIndex = updatedIndex;
1020         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1021     }
1022 
1023     /**
1024      * @dev Transfers `tokenId` from `from` to `to`.
1025      *
1026      * Requirements:
1027      *
1028      * - `to` cannot be the zero address.
1029      * - `tokenId` token must be owned by `from`.
1030      *
1031      * Emits a {Transfer} event.
1032      */
1033     function _transfer(
1034         address from,
1035         address to,
1036         uint256 tokenId
1037     ) private {
1038         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1039 
1040         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1041             getApproved(tokenId) == _msgSender() ||
1042             isApprovedForAll(prevOwnership.addr, _msgSender()));
1043 
1044         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1045 
1046         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1047         require(to != address(0), 'ERC721A: transfer to the zero address');
1048 
1049         _beforeTokenTransfers(from, to, tokenId, 1);
1050 
1051         // Clear approvals from the previous owner
1052         _approve(address(0), tokenId, prevOwnership.addr);
1053 
1054         // Underflow of the sender's balance is impossible because we check for
1055         // ownership above and the recipient's balance can't realistically overflow.
1056         unchecked {
1057             _addressData[from].balance -= 1;
1058             _addressData[to].balance += 1;
1059         }
1060 
1061         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1062 
1063         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1064         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1065         uint256 nextTokenId = tokenId + 1;
1066         if (_ownerships[nextTokenId].addr == address(0)) {
1067             if (_exists(nextTokenId)) {
1068                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1069             }
1070         }
1071 
1072         emit Transfer(from, to, tokenId);
1073         _afterTokenTransfers(from, to, tokenId, 1);
1074     }
1075 
1076     /**
1077      * @dev Approve `to` to operate on `tokenId`
1078      *
1079      * Emits a {Approval} event.
1080      */
1081     function _approve(
1082         address to,
1083         uint256 tokenId,
1084         address owner
1085     ) private {
1086         _tokenApprovals[tokenId] = to;
1087         emit Approval(owner, to, tokenId);
1088     }
1089 
1090     /**
1091      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1092      * The call is not executed if the target address is not a contract.
1093      *
1094      * @param from address representing the previous owner of the given token ID
1095      * @param to target address that will receive the tokens
1096      * @param tokenId uint256 ID of the token to be transferred
1097      * @param _data bytes optional data to send along with the call
1098      * @return bool whether the call correctly returned the expected magic value
1099      */
1100     function _checkOnERC721Received(
1101         address from,
1102         address to,
1103         uint256 tokenId,
1104         bytes memory _data
1105     ) private returns (bool) {
1106         if (to.isContract()) {
1107             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1108                 return retval == IERC721Receiver(to).onERC721Received.selector;
1109             } catch (bytes memory reason) {
1110                 if (reason.length == 0) {
1111                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1112                 } else {
1113                     assembly {
1114                         revert(add(32, reason), mload(reason))
1115                     }
1116                 }
1117             }
1118         } else {
1119             return true;
1120         }
1121     }
1122 
1123     /**
1124      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1125      *
1126      * startTokenId - the first token id to be transferred
1127      * quantity - the amount to be transferred
1128      *
1129      * Calling conditions:
1130      *
1131      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1132      * transferred to `to`.
1133      * - When `from` is zero, `tokenId` will be minted for `to`.
1134      */
1135     function _beforeTokenTransfers(
1136         address from,
1137         address to,
1138         uint256 startTokenId,
1139         uint256 quantity
1140     ) internal virtual {}
1141 
1142     /**
1143      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1144      * minting.
1145      *
1146      * startTokenId - the first token id to be transferred
1147      * quantity - the amount to be transferred
1148      *
1149      * Calling conditions:
1150      *
1151      * - when `from` and `to` are both non-zero.
1152      * - `from` and `to` are never both zero.
1153      */
1154     function _afterTokenTransfers(
1155         address from,
1156         address to,
1157         uint256 startTokenId,
1158         uint256 quantity
1159     ) internal virtual {}
1160 }
1161 
1162 
1163 // File contracts/babygoblinz.sol
1164 
1165 
1166 contract babygoblinz is ERC721A, Ownable {
1167 
1168     string public baseURI = "";
1169     string public contractURI = "";
1170     string public constant baseExtension = ".json";
1171     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1172 
1173     uint256 public constant MAX_PER_TX_FREE = 2;
1174     uint256 public constant MAX_PER_TX = 5;
1175     uint256 public constant FREE_MAX_SUPPLY = 1000;
1176     uint256 public constant MAX_SUPPLY = 5000;
1177     uint256 public constant MAX_PER_WALLET = 10;
1178     uint256 public price = 0.0069 ether;
1179 
1180     bool public paused = true;
1181 
1182     constructor() ERC721A("baby goblinz", "babygoblinz") {}
1183 
1184     function mint(uint256 _amount) external payable {
1185         address _caller = _msgSender();
1186         uint256 ownerTokenCount = balanceOf(_caller);
1187         require(!paused, "Paused");
1188         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1189         require(_amount > 0, "No 0 mints");
1190         require(tx.origin == _caller, "No contracts");
1191         require(ownerTokenCount < MAX_PER_WALLET, "Exceeds max token count per wallet");
1192 
1193         if(FREE_MAX_SUPPLY >= totalSupply()){
1194             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1195         }else{
1196             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1197             require(_amount * price == msg.value, "Invalid funds provided");
1198         }
1199 
1200         _safeMint(_caller, _amount);
1201     }
1202 
1203     function setCost(uint256 _newCost) public onlyOwner {
1204         price = _newCost;
1205     }
1206 
1207     function isApprovedForAll(address owner, address operator)
1208         override
1209         public
1210         view
1211         returns (bool)
1212     {
1213         // Whitelist OpenSea proxy contract for easy trading.
1214         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1215         if (address(proxyRegistry.proxies(owner)) == operator) {
1216             return true;
1217         }
1218 
1219         return super.isApprovedForAll(owner, operator);
1220     }
1221 
1222     function withdraw() external onlyOwner {
1223         uint256 balance = address(this).balance;
1224         (bool success, ) = _msgSender().call{value: balance}("");
1225         require(success, "Failed to send");
1226     }
1227 
1228     function setupOS() external onlyOwner {
1229         _safeMint(_msgSender(), 1);
1230     }
1231 
1232     function pause(bool _state) external onlyOwner {
1233         paused = _state;
1234     }
1235 
1236     function setBaseURI(string memory baseURI_) external onlyOwner {
1237         baseURI = baseURI_;
1238     }
1239 
1240     function setContractURI(string memory _contractURI) external onlyOwner {
1241         contractURI = _contractURI;
1242     }
1243 
1244     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1245         require(_exists(_tokenId), "Token does not exist.");
1246         return bytes(baseURI).length > 0 ? string(
1247             abi.encodePacked(
1248               baseURI,
1249               Strings.toString(_tokenId),
1250               baseExtension
1251             )
1252         ) : "";
1253     }
1254 }
1255 
1256 contract OwnableDelegateProxy { }
1257 contract ProxyRegistry {
1258     mapping(address => OwnableDelegateProxy) public proxies;
1259 }