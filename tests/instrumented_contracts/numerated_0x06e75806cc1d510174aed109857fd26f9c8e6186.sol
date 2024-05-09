1 /**
2                               Peace Aliens                                      
3                                                                                 
4                                _,╥≤≡∞Rªª▀▀████▄▄╓_                              
5                            ╓≡"`                  '╙▀φ,                          
6                         ╓M`                           `▀╗_                      
7                 _╓,_  ▄^             ,«ⁿ<,               `▀╖                    
8               ╓▀ ,▄ ª▌              ^ ,═_ ¼                 ╙▄                  
9              ╒ ╓^  █_ ▌            Γ /  ╘╕ ╕                  ▀╕                
10              ▌┌   ▌ ╙             Å A    ╘_╚                    ▌               
11             ▐ ▌  █                Γ┌      └                      █              
12             ╫ L ┌                  ╠                              L             
13             █ L █                  ╡                              ▐             
14             ╟ ▀╥▌                ┌%└╗                             ║             
15          '▓▓▌_,▓▌                ╙╖╖═                          _▄A╜▀▀▀▀▀▀▄      
16           '▓╬╬╬▓█   ╓▄_    ,                               _«^`        ▄▀       
17            ╘▓▓▓▓█▌  ████▄ ███_    ▄███  ,▄████▄▄         ╒^    _     ╓█         
18             ╘▓▓▓██  █Γ     ▀█▌   ████▀    ╙█████       ╒^ ,▄▓▓▓^    █^          
19              └▓▓╣█  ╟█_  _█         ▄L    ▐████`        Φ▓▓▓▓^    ▄▀            
20               `█▓█   ╚Ü╚▄██▌       ███▀æφ╬Ü╟██          ╘▓▀`   ▄A`              
21                 `█     ╙▀███      ▐█████▒▄▄▀              ▄*ª"                  
22                  ╫    ,,             ``` _               █                      
23                  ╞          ╓   ╓       ^r              ▄^                      
24                   ▀▄        'ⁿ`ª═`                   ▄#^                        
25                     "¥≥▄▄__                    _▄▄A"`                           
26                            `"""""ªªªª▀█▓▓▓▓█""                                  
27                        ▄╗             █▓▓▀╙█      ╓▀_   _                       
28                   ┌@╗_ ╟ ▀_      __,∞^^     ▀╗,_  ▌ ▌ ╓Ñ╫                       
29                    ╙▄'▄ █ █    /Γ               '█ ▐L▐M▐`                       
30                     `▌'▌█ █^`▓▀                 ⌐╪▌ ▀█ █                        
31                      █^^``▀▄╣▌╒                '▄_║^```_▌                       
32                      ╙"^`"▌`╜╒                  ╘▄▌φ^`_▄                        
33                       `▀ ` '▓                 '_ ▐  `█"                         
34                        ╫   ╒▌                  ▓ ╞    ▌                         
35                        ▌   ▓                   ╘ ╞    ▐                         
36                        █  ▓                     ▌Φ     L                        
37                         `█╬                     ╣▄    Ä                         
38                                                                                 
39                           https://peacealiens.com                               
40 **/
41 
42 // File: @openzeppelin/contracts/utils/Context.sol
43 
44 // SPDX-License-Identifier: MIT
45 
46 pragma solidity ^0.8.0;
47 
48 /**
49  * @dev Provides information about the current execution context, including the
50  * sender of the transaction and its data. While these are generally available
51  * via msg.sender and msg.data, they should not be accessed in such a direct
52  * manner, since when dealing with meta-transactions the account sending and
53  * paying for execution may not be the actual sender (as far as an application
54  * is concerned).
55  *
56  * This contract is only required for intermediate, library-like contracts.
57  */
58 abstract contract Context {
59     function _msgSender() internal view virtual returns (address) {
60         return msg.sender;
61     }
62 
63     function _msgData() internal view virtual returns (bytes calldata) {
64         return msg.data;
65     }
66 }
67 
68 // File: @openzeppelin/contracts/access/Ownable.sol
69 
70 pragma solidity ^0.8.0;
71 
72 
73 /**
74  * @dev Contract module which provides a basic access control mechanism, where
75  * there is an account (an owner) that can be granted exclusive access to
76  * specific functions.
77  *
78  * By default, the owner account will be the one that deploys the contract. This
79  * can later be changed with {transferOwnership}.
80  *
81  * This module is used through inheritance. It will make available the modifier
82  * `onlyOwner`, which can be applied to your functions to restrict their use to
83  * the owner.
84  */
85 abstract contract Ownable is Context {
86     address private _owner;
87 
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     /**
91      * @dev Initializes the contract setting the deployer as the initial owner.
92      */
93     constructor() {
94         _setOwner(_msgSender());
95     }
96 
97     /**
98      * @dev Returns the address of the current owner.
99      */
100     function owner() public view virtual returns (address) {
101         return _owner;
102     }
103 
104     /**
105      * @dev Throws if called by any account other than the owner.
106      */
107     modifier onlyOwner() {
108         require(owner() == _msgSender(), "Ownable: caller is not the owner");
109         _;
110     }
111 
112     /**
113      * @dev Leaves the contract without owner. It will not be possible to call
114      * `onlyOwner` functions anymore. Can only be called by the current owner.
115      *
116      * NOTE: Renouncing ownership will leave the contract without an owner,
117      * thereby removing any functionality that is only available to the owner.
118      */
119     function renounceOwnership() public virtual onlyOwner {
120         _setOwner(address(0));
121     }
122 
123     /**
124      * @dev Transfers ownership of the contract to a new account (`newOwner`).
125      * Can only be called by the current owner.
126      */
127     function transferOwnership(address newOwner) public virtual onlyOwner {
128         require(newOwner != address(0), "Ownable: new owner is the zero address");
129         _setOwner(newOwner);
130     }
131 
132     function _setOwner(address newOwner) private {
133         address oldOwner = _owner;
134         _owner = newOwner;
135         emit OwnershipTransferred(oldOwner, newOwner);
136     }
137 }
138 
139 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
140 
141 pragma solidity ^0.8.0;
142 
143 /**
144  * @dev Interface of the ERC165 standard, as defined in the
145  * https://eips.ethereum.org/EIPS/eip-165[EIP].
146  *
147  * Implementers can declare support of contract interfaces, which can then be
148  * queried by others ({ERC165Checker}).
149  *
150  * For an implementation, see {ERC165}.
151  */
152 interface IERC165 {
153     /**
154      * @dev Returns true if this contract implements the interface defined by
155      * `interfaceId`. See the corresponding
156      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
157      * to learn more about how these ids are created.
158      *
159      * This function call must use less than 30 000 gas.
160      */
161     function supportsInterface(bytes4 interfaceId) external view returns (bool);
162 }
163 
164 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
165 
166 pragma solidity ^0.8.0;
167 
168 
169 /**
170  * @dev Required interface of an ERC721 compliant contract.
171  */
172 interface IERC721 is IERC165 {
173     /**
174      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
175      */
176     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
177 
178     /**
179      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
180      */
181     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
182 
183     /**
184      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
185      */
186     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
187 
188     /**
189      * @dev Returns the number of tokens in ``owner``'s account.
190      */
191     function balanceOf(address owner) external view returns (uint256 balance);
192 
193     /**
194      * @dev Returns the owner of the `tokenId` token.
195      *
196      * Requirements:
197      *
198      * - `tokenId` must exist.
199      */
200     function ownerOf(uint256 tokenId) external view returns (address owner);
201 
202     /**
203      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
204      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
205      *
206      * Requirements:
207      *
208      * - `from` cannot be the zero address.
209      * - `to` cannot be the zero address.
210      * - `tokenId` token must exist and be owned by `from`.
211      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
212      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
213      *
214      * Emits a {Transfer} event.
215      */
216     function safeTransferFrom(
217         address from,
218         address to,
219         uint256 tokenId
220     ) external;
221 
222     /**
223      * @dev Transfers `tokenId` token from `from` to `to`.
224      *
225      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
226      *
227      * Requirements:
228      *
229      * - `from` cannot be the zero address.
230      * - `to` cannot be the zero address.
231      * - `tokenId` token must be owned by `from`.
232      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
233      *
234      * Emits a {Transfer} event.
235      */
236     function transferFrom(
237         address from,
238         address to,
239         uint256 tokenId
240     ) external;
241 
242     /**
243      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
244      * The approval is cleared when the token is transferred.
245      *
246      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
247      *
248      * Requirements:
249      *
250      * - The caller must own the token or be an approved operator.
251      * - `tokenId` must exist.
252      *
253      * Emits an {Approval} event.
254      */
255     function approve(address to, uint256 tokenId) external;
256 
257     /**
258      * @dev Returns the account approved for `tokenId` token.
259      *
260      * Requirements:
261      *
262      * - `tokenId` must exist.
263      */
264     function getApproved(uint256 tokenId) external view returns (address operator);
265 
266     /**
267      * @dev Approve or remove `operator` as an operator for the caller.
268      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
269      *
270      * Requirements:
271      *
272      * - The `operator` cannot be the caller.
273      *
274      * Emits an {ApprovalForAll} event.
275      */
276     function setApprovalForAll(address operator, bool _approved) external;
277 
278     /**
279      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
280      *
281      * See {setApprovalForAll}
282      */
283     function isApprovedForAll(address owner, address operator) external view returns (bool);
284 
285     /**
286      * @dev Safely transfers `tokenId` token from `from` to `to`.
287      *
288      * Requirements:
289      *
290      * - `from` cannot be the zero address.
291      * - `to` cannot be the zero address.
292      * - `tokenId` token must exist and be owned by `from`.
293      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
294      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
295      *
296      * Emits a {Transfer} event.
297      */
298     function safeTransferFrom(
299         address from,
300         address to,
301         uint256 tokenId,
302         bytes calldata data
303     ) external;
304 }
305 
306 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
307 
308 pragma solidity ^0.8.0;
309 
310 /**
311  * @title ERC721 token receiver interface
312  * @dev Interface for any contract that wants to support safeTransfers
313  * from ERC721 asset contracts.
314  */
315 interface IERC721Receiver {
316     /**
317      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
318      * by `operator` from `from`, this function is called.
319      *
320      * It must return its Solidity selector to confirm the token transfer.
321      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
322      *
323      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
324      */
325     function onERC721Received(
326         address operator,
327         address from,
328         uint256 tokenId,
329         bytes calldata data
330     ) external returns (bytes4);
331 }
332 
333 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
334 
335 pragma solidity ^0.8.0;
336 
337 
338 /**
339  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
340  * @dev See https://eips.ethereum.org/EIPS/eip-721
341  */
342 interface IERC721Metadata is IERC721 {
343     /**
344      * @dev Returns the token collection name.
345      */
346     function name() external view returns (string memory);
347 
348     /**
349      * @dev Returns the token collection symbol.
350      */
351     function symbol() external view returns (string memory);
352 
353     /**
354      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
355      */
356     function tokenURI(uint256 tokenId) external view returns (string memory);
357 }
358 
359 // File: @openzeppelin/contracts/utils/Address.sol
360 
361 pragma solidity ^0.8.0;
362 
363 /**
364  * @dev Collection of functions related to the address type
365  */
366 library Address {
367     /**
368      * @dev Returns true if `account` is a contract.
369      *
370      * [IMPORTANT]
371      * ====
372      * It is unsafe to assume that an address for which this function returns
373      * false is an externally-owned account (EOA) and not a contract.
374      *
375      * Among others, `isContract` will return false for the following
376      * types of addresses:
377      *
378      *  - an externally-owned account
379      *  - a contract in construction
380      *  - an address where a contract will be created
381      *  - an address where a contract lived, but was destroyed
382      * ====
383      */
384     function isContract(address account) internal view returns (bool) {
385         // This method relies on extcodesize, which returns 0 for contracts in
386         // construction, since the code is only stored at the end of the
387         // constructor execution.
388 
389         uint256 size;
390         assembly {
391             size := extcodesize(account)
392         }
393         return size > 0;
394     }
395 
396     /**
397      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
398      * `recipient`, forwarding all available gas and reverting on errors.
399      *
400      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
401      * of certain opcodes, possibly making contracts go over the 2300 gas limit
402      * imposed by `transfer`, making them unable to receive funds via
403      * `transfer`. {sendValue} removes this limitation.
404      *
405      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
406      *
407      * IMPORTANT: because control is transferred to `recipient`, care must be
408      * taken to not create reentrancy vulnerabilities. Consider using
409      * {ReentrancyGuard} or the
410      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
411      */
412     function sendValue(address payable recipient, uint256 amount) internal {
413         require(address(this).balance >= amount, "Address: insufficient balance");
414 
415         (bool success, ) = recipient.call{value: amount}("");
416         require(success, "Address: unable to send value, recipient may have reverted");
417     }
418 
419     /**
420      * @dev Performs a Solidity function call using a low level `call`. A
421      * plain `call` is an unsafe replacement for a function call: use this
422      * function instead.
423      *
424      * If `target` reverts with a revert reason, it is bubbled up by this
425      * function (like regular Solidity function calls).
426      *
427      * Returns the raw returned data. To convert to the expected return value,
428      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
429      *
430      * Requirements:
431      *
432      * - `target` must be a contract.
433      * - calling `target` with `data` must not revert.
434      *
435      * _Available since v3.1._
436      */
437     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
438         return functionCall(target, data, "Address: low-level call failed");
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
443      * `errorMessage` as a fallback revert reason when `target` reverts.
444      *
445      * _Available since v3.1._
446      */
447     function functionCall(
448         address target,
449         bytes memory data,
450         string memory errorMessage
451     ) internal returns (bytes memory) {
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
466     function functionCallWithValue(
467         address target,
468         bytes memory data,
469         uint256 value
470     ) internal returns (bytes memory) {
471         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
476      * with `errorMessage` as a fallback revert reason when `target` reverts.
477      *
478      * _Available since v3.1._
479      */
480     function functionCallWithValue(
481         address target,
482         bytes memory data,
483         uint256 value,
484         string memory errorMessage
485     ) internal returns (bytes memory) {
486         require(address(this).balance >= value, "Address: insufficient balance for call");
487         require(isContract(target), "Address: call to non-contract");
488 
489         (bool success, bytes memory returndata) = target.call{value: value}(data);
490         return verifyCallResult(success, returndata, errorMessage);
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
495      * but performing a static call.
496      *
497      * _Available since v3.3._
498      */
499     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
500         return functionStaticCall(target, data, "Address: low-level static call failed");
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
505      * but performing a static call.
506      *
507      * _Available since v3.3._
508      */
509     function functionStaticCall(
510         address target,
511         bytes memory data,
512         string memory errorMessage
513     ) internal view returns (bytes memory) {
514         require(isContract(target), "Address: static call to non-contract");
515 
516         (bool success, bytes memory returndata) = target.staticcall(data);
517         return verifyCallResult(success, returndata, errorMessage);
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
522      * but performing a delegate call.
523      *
524      * _Available since v3.4._
525      */
526     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
527         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
532      * but performing a delegate call.
533      *
534      * _Available since v3.4._
535      */
536     function functionDelegateCall(
537         address target,
538         bytes memory data,
539         string memory errorMessage
540     ) internal returns (bytes memory) {
541         require(isContract(target), "Address: delegate call to non-contract");
542 
543         (bool success, bytes memory returndata) = target.delegatecall(data);
544         return verifyCallResult(success, returndata, errorMessage);
545     }
546 
547     /**
548      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
549      * revert reason using the provided one.
550      *
551      * _Available since v4.3._
552      */
553     function verifyCallResult(
554         bool success,
555         bytes memory returndata,
556         string memory errorMessage
557     ) internal pure returns (bytes memory) {
558         if (success) {
559             return returndata;
560         } else {
561             // Look for revert reason and bubble it up if present
562             if (returndata.length > 0) {
563                 // The easiest way to bubble the revert reason is using memory via assembly
564 
565                 assembly {
566                     let returndata_size := mload(returndata)
567                     revert(add(32, returndata), returndata_size)
568                 }
569             } else {
570                 revert(errorMessage);
571             }
572         }
573     }
574 }
575 
576 // File: @openzeppelin/contracts/utils/Strings.sol
577 
578 pragma solidity ^0.8.0;
579 
580 /**
581  * @dev String operations.
582  */
583 library Strings {
584     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
585 
586     /**
587      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
588      */
589     function toString(uint256 value) internal pure returns (string memory) {
590         // Inspired by OraclizeAPI's implementation - MIT licence
591         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
592 
593         if (value == 0) {
594             return "0";
595         }
596         uint256 temp = value;
597         uint256 digits;
598         while (temp != 0) {
599             digits++;
600             temp /= 10;
601         }
602         bytes memory buffer = new bytes(digits);
603         while (value != 0) {
604             digits -= 1;
605             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
606             value /= 10;
607         }
608         return string(buffer);
609     }
610 
611     /**
612      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
613      */
614     function toHexString(uint256 value) internal pure returns (string memory) {
615         if (value == 0) {
616             return "0x00";
617         }
618         uint256 temp = value;
619         uint256 length = 0;
620         while (temp != 0) {
621             length++;
622             temp >>= 8;
623         }
624         return toHexString(value, length);
625     }
626 
627     /**
628      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
629      */
630     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
631         bytes memory buffer = new bytes(2 * length + 2);
632         buffer[0] = "0";
633         buffer[1] = "x";
634         for (uint256 i = 2 * length + 1; i > 1; --i) {
635             buffer[i] = _HEX_SYMBOLS[value & 0xf];
636             value >>= 4;
637         }
638         require(value == 0, "Strings: hex length insufficient");
639         return string(buffer);
640     }
641 }
642 
643 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
644 
645 pragma solidity ^0.8.0;
646 
647 
648 /**
649  * @dev Implementation of the {IERC165} interface.
650  *
651  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
652  * for the additional interface id that will be supported. For example:
653  *
654  * ```solidity
655  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
656  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
657  * }
658  * ```
659  *
660  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
661  */
662 abstract contract ERC165 is IERC165 {
663     /**
664      * @dev See {IERC165-supportsInterface}.
665      */
666     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
667         return interfaceId == type(IERC165).interfaceId;
668     }
669 }
670 
671 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
672 
673 pragma solidity ^0.8.0;
674 
675 
676 
677 
678 
679 
680 
681 
682 /**
683  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
684  * the Metadata extension, but not including the Enumerable extension, which is available separately as
685  * {ERC721Enumerable}.
686  */
687 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
688     using Address for address;
689     using Strings for uint256;
690 
691     // Token name
692     string private _name;
693 
694     // Token symbol
695     string private _symbol;
696 
697     // Mapping from token ID to owner address
698     mapping(uint256 => address) private _owners;
699 
700     // Mapping owner address to token count
701     mapping(address => uint256) private _balances;
702 
703     // Mapping from token ID to approved address
704     mapping(uint256 => address) private _tokenApprovals;
705 
706     // Mapping from owner to operator approvals
707     mapping(address => mapping(address => bool)) private _operatorApprovals;
708 
709     /**
710      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
711      */
712     constructor(string memory name_, string memory symbol_) {
713         _name = name_;
714         _symbol = symbol_;
715     }
716 
717     /**
718      * @dev See {IERC165-supportsInterface}.
719      */
720     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
721         return
722             interfaceId == type(IERC721).interfaceId ||
723             interfaceId == type(IERC721Metadata).interfaceId ||
724             super.supportsInterface(interfaceId);
725     }
726 
727     /**
728      * @dev See {IERC721-balanceOf}.
729      */
730     function balanceOf(address owner) public view virtual override returns (uint256) {
731         require(owner != address(0), "ERC721: balance query for the zero address");
732         return _balances[owner];
733     }
734 
735     /**
736      * @dev See {IERC721-ownerOf}.
737      */
738     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
739         address owner = _owners[tokenId];
740         require(owner != address(0), "ERC721: owner query for nonexistent token");
741         return owner;
742     }
743 
744     /**
745      * @dev See {IERC721Metadata-name}.
746      */
747     function name() public view virtual override returns (string memory) {
748         return _name;
749     }
750 
751     /**
752      * @dev See {IERC721Metadata-symbol}.
753      */
754     function symbol() public view virtual override returns (string memory) {
755         return _symbol;
756     }
757 
758     /**
759      * @dev See {IERC721Metadata-tokenURI}.
760      */
761     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
762         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
763 
764         string memory baseURI = _baseURI();
765         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
766     }
767 
768     /**
769      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
770      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
771      * by default, can be overriden in child contracts.
772      */
773     function _baseURI() internal view virtual returns (string memory) {
774         return "";
775     }
776 
777     /**
778      * @dev See {IERC721-approve}.
779      */
780     function approve(address to, uint256 tokenId) public virtual override {
781         address owner = ERC721.ownerOf(tokenId);
782         require(to != owner, "ERC721: approval to current owner");
783 
784         require(
785             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
786             "ERC721: approve caller is not owner nor approved for all"
787         );
788 
789         _approve(to, tokenId);
790     }
791 
792     /**
793      * @dev See {IERC721-getApproved}.
794      */
795     function getApproved(uint256 tokenId) public view virtual override returns (address) {
796         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
797 
798         return _tokenApprovals[tokenId];
799     }
800 
801     /**
802      * @dev See {IERC721-setApprovalForAll}.
803      */
804     function setApprovalForAll(address operator, bool approved) public virtual override {
805         require(operator != _msgSender(), "ERC721: approve to caller");
806 
807         _operatorApprovals[_msgSender()][operator] = approved;
808         emit ApprovalForAll(_msgSender(), operator, approved);
809     }
810 
811     /**
812      * @dev See {IERC721-isApprovedForAll}.
813      */
814     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
815         return _operatorApprovals[owner][operator];
816     }
817 
818     /**
819      * @dev See {IERC721-transferFrom}.
820      */
821     function transferFrom(
822         address from,
823         address to,
824         uint256 tokenId
825     ) public virtual override {
826         //solhint-disable-next-line max-line-length
827         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
828 
829         _transfer(from, to, tokenId);
830     }
831 
832     /**
833      * @dev See {IERC721-safeTransferFrom}.
834      */
835     function safeTransferFrom(
836         address from,
837         address to,
838         uint256 tokenId
839     ) public virtual override {
840         safeTransferFrom(from, to, tokenId, "");
841     }
842 
843     /**
844      * @dev See {IERC721-safeTransferFrom}.
845      */
846     function safeTransferFrom(
847         address from,
848         address to,
849         uint256 tokenId,
850         bytes memory _data
851     ) public virtual override {
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
874     function _safeTransfer(
875         address from,
876         address to,
877         uint256 tokenId,
878         bytes memory _data
879     ) internal virtual {
880         _transfer(from, to, tokenId);
881         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
882     }
883 
884     /**
885      * @dev Returns whether `tokenId` exists.
886      *
887      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
888      *
889      * Tokens start existing when they are minted (`_mint`),
890      * and stop existing when they are burned (`_burn`).
891      */
892     function _exists(uint256 tokenId) internal view virtual returns (bool) {
893         return _owners[tokenId] != address(0);
894     }
895 
896     /**
897      * @dev Returns whether `spender` is allowed to manage `tokenId`.
898      *
899      * Requirements:
900      *
901      * - `tokenId` must exist.
902      */
903     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
904         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
905         address owner = ERC721.ownerOf(tokenId);
906         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
907     }
908 
909     /**
910      * @dev Safely mints `tokenId` and transfers it to `to`.
911      *
912      * Requirements:
913      *
914      * - `tokenId` must not exist.
915      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
916      *
917      * Emits a {Transfer} event.
918      */
919     function _safeMint(address to, uint256 tokenId) internal virtual {
920         _safeMint(to, tokenId, "");
921     }
922 
923     /**
924      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
925      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
926      */
927     function _safeMint(
928         address to,
929         uint256 tokenId,
930         bytes memory _data
931     ) internal virtual {
932         _mint(to, tokenId);
933         require(
934             _checkOnERC721Received(address(0), to, tokenId, _data),
935             "ERC721: transfer to non ERC721Receiver implementer"
936         );
937     }
938 
939     /**
940      * @dev Mints `tokenId` and transfers it to `to`.
941      *
942      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
943      *
944      * Requirements:
945      *
946      * - `tokenId` must not exist.
947      * - `to` cannot be the zero address.
948      *
949      * Emits a {Transfer} event.
950      */
951     function _mint(address to, uint256 tokenId) internal virtual {
952         require(to != address(0), "ERC721: mint to the zero address");
953         require(!_exists(tokenId), "ERC721: token already minted");
954 
955         _beforeTokenTransfer(address(0), to, tokenId);
956 
957         _balances[to] += 1;
958         _owners[tokenId] = to;
959 
960         emit Transfer(address(0), to, tokenId);
961     }
962 
963     /**
964      * @dev Destroys `tokenId`.
965      * The approval is cleared when the token is burned.
966      *
967      * Requirements:
968      *
969      * - `tokenId` must exist.
970      *
971      * Emits a {Transfer} event.
972      */
973     function _burn(uint256 tokenId) internal virtual {
974         address owner = ERC721.ownerOf(tokenId);
975 
976         _beforeTokenTransfer(owner, address(0), tokenId);
977 
978         // Clear approvals
979         _approve(address(0), tokenId);
980 
981         _balances[owner] -= 1;
982         delete _owners[tokenId];
983 
984         emit Transfer(owner, address(0), tokenId);
985     }
986 
987     /**
988      * @dev Transfers `tokenId` from `from` to `to`.
989      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
990      *
991      * Requirements:
992      *
993      * - `to` cannot be the zero address.
994      * - `tokenId` token must be owned by `from`.
995      *
996      * Emits a {Transfer} event.
997      */
998     function _transfer(
999         address from,
1000         address to,
1001         uint256 tokenId
1002     ) internal virtual {
1003         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1004         require(to != address(0), "ERC721: transfer to the zero address");
1005 
1006         _beforeTokenTransfer(from, to, tokenId);
1007 
1008         // Clear approvals from the previous owner
1009         _approve(address(0), tokenId);
1010 
1011         _balances[from] -= 1;
1012         _balances[to] += 1;
1013         _owners[tokenId] = to;
1014 
1015         emit Transfer(from, to, tokenId);
1016     }
1017 
1018     /**
1019      * @dev Approve `to` to operate on `tokenId`
1020      *
1021      * Emits a {Approval} event.
1022      */
1023     function _approve(address to, uint256 tokenId) internal virtual {
1024         _tokenApprovals[tokenId] = to;
1025         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1026     }
1027 
1028     /**
1029      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1030      * The call is not executed if the target address is not a contract.
1031      *
1032      * @param from address representing the previous owner of the given token ID
1033      * @param to target address that will receive the tokens
1034      * @param tokenId uint256 ID of the token to be transferred
1035      * @param _data bytes optional data to send along with the call
1036      * @return bool whether the call correctly returned the expected magic value
1037      */
1038     function _checkOnERC721Received(
1039         address from,
1040         address to,
1041         uint256 tokenId,
1042         bytes memory _data
1043     ) private returns (bool) {
1044         if (to.isContract()) {
1045             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1046                 return retval == IERC721Receiver.onERC721Received.selector;
1047             } catch (bytes memory reason) {
1048                 if (reason.length == 0) {
1049                     revert("ERC721: transfer to non ERC721Receiver implementer");
1050                 } else {
1051                     assembly {
1052                         revert(add(32, reason), mload(reason))
1053                     }
1054                 }
1055             }
1056         } else {
1057             return true;
1058         }
1059     }
1060 
1061     /**
1062      * @dev Hook that is called before any token transfer. This includes minting
1063      * and burning.
1064      *
1065      * Calling conditions:
1066      *
1067      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1068      * transferred to `to`.
1069      * - When `from` is zero, `tokenId` will be minted for `to`.
1070      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1071      * - `from` and `to` are never both zero.
1072      *
1073      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1074      */
1075     function _beforeTokenTransfer(
1076         address from,
1077         address to,
1078         uint256 tokenId
1079     ) internal virtual {}
1080 }
1081 
1082 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1083 
1084 pragma solidity ^0.8.0;
1085 
1086 
1087 /**
1088  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1089  * @dev See https://eips.ethereum.org/EIPS/eip-721
1090  */
1091 interface IERC721Enumerable is IERC721 {
1092     /**
1093      * @dev Returns the total amount of tokens stored by the contract.
1094      */
1095     function totalSupply() external view returns (uint256);
1096 
1097     /**
1098      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1099      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1100      */
1101     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1102 
1103     /**
1104      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1105      * Use along with {totalSupply} to enumerate all tokens.
1106      */
1107     function tokenByIndex(uint256 index) external view returns (uint256);
1108 }
1109 
1110 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1111 
1112 pragma solidity ^0.8.0;
1113 
1114 
1115 
1116 /**
1117  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1118  * enumerability of all the token ids in the contract as well as all token ids owned by each
1119  * account.
1120  */
1121 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1122     // Mapping from owner to list of owned token IDs
1123     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1124 
1125     // Mapping from token ID to index of the owner tokens list
1126     mapping(uint256 => uint256) private _ownedTokensIndex;
1127 
1128     // Array with all token ids, used for enumeration
1129     uint256[] private _allTokens;
1130 
1131     // Mapping from token id to position in the allTokens array
1132     mapping(uint256 => uint256) private _allTokensIndex;
1133 
1134     /**
1135      * @dev See {IERC165-supportsInterface}.
1136      */
1137     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1138         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1139     }
1140 
1141     /**
1142      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1143      */
1144     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1145         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1146         return _ownedTokens[owner][index];
1147     }
1148 
1149     /**
1150      * @dev See {IERC721Enumerable-totalSupply}.
1151      */
1152     function totalSupply() public view virtual override returns (uint256) {
1153         return _allTokens.length;
1154     }
1155 
1156     /**
1157      * @dev See {IERC721Enumerable-tokenByIndex}.
1158      */
1159     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1160         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1161         return _allTokens[index];
1162     }
1163 
1164     /**
1165      * @dev Hook that is called before any token transfer. This includes minting
1166      * and burning.
1167      *
1168      * Calling conditions:
1169      *
1170      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1171      * transferred to `to`.
1172      * - When `from` is zero, `tokenId` will be minted for `to`.
1173      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1174      * - `from` cannot be the zero address.
1175      * - `to` cannot be the zero address.
1176      *
1177      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1178      */
1179     function _beforeTokenTransfer(
1180         address from,
1181         address to,
1182         uint256 tokenId
1183     ) internal virtual override {
1184         super._beforeTokenTransfer(from, to, tokenId);
1185 
1186         if (from == address(0)) {
1187             _addTokenToAllTokensEnumeration(tokenId);
1188         } else if (from != to) {
1189             _removeTokenFromOwnerEnumeration(from, tokenId);
1190         }
1191         if (to == address(0)) {
1192             _removeTokenFromAllTokensEnumeration(tokenId);
1193         } else if (to != from) {
1194             _addTokenToOwnerEnumeration(to, tokenId);
1195         }
1196     }
1197 
1198     /**
1199      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1200      * @param to address representing the new owner of the given token ID
1201      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1202      */
1203     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1204         uint256 length = ERC721.balanceOf(to);
1205         _ownedTokens[to][length] = tokenId;
1206         _ownedTokensIndex[tokenId] = length;
1207     }
1208 
1209     /**
1210      * @dev Private function to add a token to this extension's token tracking data structures.
1211      * @param tokenId uint256 ID of the token to be added to the tokens list
1212      */
1213     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1214         _allTokensIndex[tokenId] = _allTokens.length;
1215         _allTokens.push(tokenId);
1216     }
1217 
1218     /**
1219      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1220      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1221      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1222      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1223      * @param from address representing the previous owner of the given token ID
1224      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1225      */
1226     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1227         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1228         // then delete the last slot (swap and pop).
1229 
1230         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1231         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1232 
1233         // When the token to delete is the last token, the swap operation is unnecessary
1234         if (tokenIndex != lastTokenIndex) {
1235             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1236 
1237             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1238             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1239         }
1240 
1241         // This also deletes the contents at the last position of the array
1242         delete _ownedTokensIndex[tokenId];
1243         delete _ownedTokens[from][lastTokenIndex];
1244     }
1245 
1246     /**
1247      * @dev Private function to remove a token from this extension's token tracking data structures.
1248      * This has O(1) time complexity, but alters the order of the _allTokens array.
1249      * @param tokenId uint256 ID of the token to be removed from the tokens list
1250      */
1251     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1252         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1253         // then delete the last slot (swap and pop).
1254 
1255         uint256 lastTokenIndex = _allTokens.length - 1;
1256         uint256 tokenIndex = _allTokensIndex[tokenId];
1257 
1258         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1259         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1260         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1261         uint256 lastTokenId = _allTokens[lastTokenIndex];
1262 
1263         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1264         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1265 
1266         // This also deletes the contents at the last position of the array
1267         delete _allTokensIndex[tokenId];
1268         _allTokens.pop();
1269     }
1270 }
1271 
1272 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1273 
1274 pragma solidity ^0.8.0;
1275 
1276 // CAUTION
1277 // This version of SafeMath should only be used with Solidity 0.8 or later,
1278 // because it relies on the compiler's built in overflow checks.
1279 
1280 /**
1281  * @dev Wrappers over Solidity's arithmetic operations.
1282  *
1283  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1284  * now has built in overflow checking.
1285  */
1286 library SafeMath {
1287     /**
1288      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1289      *
1290      * _Available since v3.4._
1291      */
1292     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1293         unchecked {
1294             uint256 c = a + b;
1295             if (c < a) return (false, 0);
1296             return (true, c);
1297         }
1298     }
1299 
1300     /**
1301      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1302      *
1303      * _Available since v3.4._
1304      */
1305     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1306         unchecked {
1307             if (b > a) return (false, 0);
1308             return (true, a - b);
1309         }
1310     }
1311 
1312     /**
1313      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1314      *
1315      * _Available since v3.4._
1316      */
1317     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1318         unchecked {
1319             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1320             // benefit is lost if 'b' is also tested.
1321             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1322             if (a == 0) return (true, 0);
1323             uint256 c = a * b;
1324             if (c / a != b) return (false, 0);
1325             return (true, c);
1326         }
1327     }
1328 
1329     /**
1330      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1331      *
1332      * _Available since v3.4._
1333      */
1334     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1335         unchecked {
1336             if (b == 0) return (false, 0);
1337             return (true, a / b);
1338         }
1339     }
1340 
1341     /**
1342      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1343      *
1344      * _Available since v3.4._
1345      */
1346     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1347         unchecked {
1348             if (b == 0) return (false, 0);
1349             return (true, a % b);
1350         }
1351     }
1352 
1353     /**
1354      * @dev Returns the addition of two unsigned integers, reverting on
1355      * overflow.
1356      *
1357      * Counterpart to Solidity's `+` operator.
1358      *
1359      * Requirements:
1360      *
1361      * - Addition cannot overflow.
1362      */
1363     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1364         return a + b;
1365     }
1366 
1367     /**
1368      * @dev Returns the subtraction of two unsigned integers, reverting on
1369      * overflow (when the result is negative).
1370      *
1371      * Counterpart to Solidity's `-` operator.
1372      *
1373      * Requirements:
1374      *
1375      * - Subtraction cannot overflow.
1376      */
1377     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1378         return a - b;
1379     }
1380 
1381     /**
1382      * @dev Returns the multiplication of two unsigned integers, reverting on
1383      * overflow.
1384      *
1385      * Counterpart to Solidity's `*` operator.
1386      *
1387      * Requirements:
1388      *
1389      * - Multiplication cannot overflow.
1390      */
1391     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1392         return a * b;
1393     }
1394 
1395     /**
1396      * @dev Returns the integer division of two unsigned integers, reverting on
1397      * division by zero. The result is rounded towards zero.
1398      *
1399      * Counterpart to Solidity's `/` operator.
1400      *
1401      * Requirements:
1402      *
1403      * - The divisor cannot be zero.
1404      */
1405     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1406         return a / b;
1407     }
1408 
1409     /**
1410      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1411      * reverting when dividing by zero.
1412      *
1413      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1414      * opcode (which leaves remaining gas untouched) while Solidity uses an
1415      * invalid opcode to revert (consuming all remaining gas).
1416      *
1417      * Requirements:
1418      *
1419      * - The divisor cannot be zero.
1420      */
1421     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1422         return a % b;
1423     }
1424 
1425     /**
1426      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1427      * overflow (when the result is negative).
1428      *
1429      * CAUTION: This function is deprecated because it requires allocating memory for the error
1430      * message unnecessarily. For custom revert reasons use {trySub}.
1431      *
1432      * Counterpart to Solidity's `-` operator.
1433      *
1434      * Requirements:
1435      *
1436      * - Subtraction cannot overflow.
1437      */
1438     function sub(
1439         uint256 a,
1440         uint256 b,
1441         string memory errorMessage
1442     ) internal pure returns (uint256) {
1443         unchecked {
1444             require(b <= a, errorMessage);
1445             return a - b;
1446         }
1447     }
1448 
1449     /**
1450      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1451      * division by zero. The result is rounded towards zero.
1452      *
1453      * Counterpart to Solidity's `/` operator. Note: this function uses a
1454      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1455      * uses an invalid opcode to revert (consuming all remaining gas).
1456      *
1457      * Requirements:
1458      *
1459      * - The divisor cannot be zero.
1460      */
1461     function div(
1462         uint256 a,
1463         uint256 b,
1464         string memory errorMessage
1465     ) internal pure returns (uint256) {
1466         unchecked {
1467             require(b > 0, errorMessage);
1468             return a / b;
1469         }
1470     }
1471 
1472     /**
1473      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1474      * reverting with custom message when dividing by zero.
1475      *
1476      * CAUTION: This function is deprecated because it requires allocating memory for the error
1477      * message unnecessarily. For custom revert reasons use {tryMod}.
1478      *
1479      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1480      * opcode (which leaves remaining gas untouched) while Solidity uses an
1481      * invalid opcode to revert (consuming all remaining gas).
1482      *
1483      * Requirements:
1484      *
1485      * - The divisor cannot be zero.
1486      */
1487     function mod(
1488         uint256 a,
1489         uint256 b,
1490         string memory errorMessage
1491     ) internal pure returns (uint256) {
1492         unchecked {
1493             require(b > 0, errorMessage);
1494             return a % b;
1495         }
1496     }
1497 }
1498 
1499 // File: @openzeppelin/contracts/interfaces/IERC721.sol
1500 
1501 pragma solidity ^0.8.0;
1502 
1503 // File: contracts/PeaceAliens.sol
1504 
1505 pragma solidity ^0.8.4;
1506 
1507 contract PeaceAliens is ERC721Enumerable, Ownable {
1508 
1509     using SafeMath for uint256;
1510     using Strings for uint256;
1511 
1512     bool public _isSaleActive = false;
1513     bool public _isFriendSaleActive = false;
1514     string private _baseURIExtended;
1515     uint256 public maxMintablePerCall = 20;
1516     address[] public friendCommunities;
1517     uint256 public freePeaceAliensAvailable = 0;
1518 
1519     // Constants
1520     uint256 public constant MAX_SUPPLY = 8877;
1521     uint256 public NFT_PRICE = .03 ether;
1522     uint256 public MAX_NFT_PER_COMMUNITY_FRIEND = 1;
1523 
1524     event FriendSaleStarted();
1525     event FriendSaleStopped();
1526     event SaleStarted();
1527     event SaleStopped();
1528     event TokenMinted(uint256 supply);
1529 
1530     constructor() ERC721('Peace Aliens', 'ALIEN') {}
1531 
1532     function _baseURI() internal view virtual override returns (string memory) {
1533         return _baseURIExtended;
1534     }
1535 
1536     function getPeaceAliensByOwner(address _owner) public view returns (uint256[] memory) {
1537         uint256 tokenCount = balanceOf(_owner);
1538         uint256[] memory tokenIds = new uint256[](tokenCount);
1539         for (uint256 i; i < tokenCount; i++) {
1540             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1541         }
1542         return tokenIds;
1543     }
1544 
1545     function _baseMint (uint256 num_tokens, address to) internal {
1546         require(totalSupply().add(num_tokens) <= MAX_SUPPLY, 'Sale would exceed max supply');
1547         uint256 supply = totalSupply();
1548         for (uint i = 0; i < num_tokens; i++) {
1549             _safeMint(to, supply + i);
1550         }
1551         emit TokenMinted(totalSupply());
1552     }
1553 
1554     function mint(address _to, uint _count) public payable {
1555         require(_isSaleActive, 'Sale must be active to mint Peace Aliens');
1556         require(NFT_PRICE * _count <= msg.value, 'Not enough ether sent (check NFT_PRICE for current token price)');
1557         require(_count <= maxMintablePerCall, 'Exceeding max mintable limit for contract call');
1558         _baseMint(_count, _to);
1559     }
1560 
1561     function friendMint(address _friendCollection) external {
1562         require(_isFriendSaleActive, 'FriendSale must be active to mint Peace Aliens');
1563         
1564         // require that max number of Peace Aliens mintable for free has not been already reached
1565         require(freePeaceAliensAvailable >= 1, "Reached max number of free Peace Aliens mintable");
1566 
1567         // required that _friendCollection is in friendCommunities
1568         require(isAddressAFriendCommunity(_friendCollection), 'friendCollection needs to be in friend community');
1569 
1570         // required that sender has no more than MAX_NFT_PER_COMMUNITY_FRIEND NFTs
1571         require( this.balanceOf(msg.sender) < MAX_NFT_PER_COMMUNITY_FRIEND, "Max Peace Aliens mintable for free reached" );
1572 
1573         // require that sender has at least 1 NFT in friendCommunity
1574         IERC721 friendContract = IERC721(_friendCollection);
1575         uint256 balance = friendContract.balanceOf(msg.sender);
1576         require(balance >= 1, "Need to own at least one token from given collection");
1577         
1578         _baseMint(1, msg.sender);
1579         freePeaceAliensAvailable = freePeaceAliensAvailable - 1;
1580     }
1581 
1582     function isAddressAFriendCommunity(address c) public view returns (bool) {
1583         bool isFriend = false;
1584         for (uint i = 0; i < friendCommunities.length; i++) {
1585             if (c == friendCommunities[i]) {
1586                 isFriend = true;
1587                 break;
1588             }
1589         }
1590         return isFriend;
1591     }
1592 
1593     function ownerMint(address[] memory recipients, uint256[] memory amount) external onlyOwner {
1594         require(recipients.length == amount.length, 'Arrays needs to be of equal lenght');
1595         uint256 totalToMint = 0;
1596         for (uint256 i = 0; i < amount.length; i++) {
1597             totalToMint = totalToMint + amount[i];
1598         }
1599         require(totalSupply().add(totalToMint) <= MAX_SUPPLY, 'Mint will exceed total supply');
1600 
1601         for (uint256 i = 0; i < recipients.length; i++) {
1602             _baseMint(amount[i], recipients[i]);
1603         }
1604     }
1605 
1606     function pauseSale() external onlyOwner {
1607         _isSaleActive = false;
1608         emit SaleStopped();
1609     }
1610 
1611     function pauseFriendSale() external onlyOwner {
1612         _isFriendSaleActive = false;
1613         emit FriendSaleStopped();
1614     }
1615 
1616     function setBaseURI(string memory baseURI_) external onlyOwner {
1617         _baseURIExtended = baseURI_;
1618     }
1619 
1620     function setMaxMintablePerCall(uint256 newMax) external onlyOwner {
1621         maxMintablePerCall = newMax;
1622     }
1623 
1624     function setMaxNFtPerCommunityFriend(uint256 newMax) external onlyOwner {
1625         MAX_NFT_PER_COMMUNITY_FRIEND = newMax;
1626     }
1627 
1628     function setPrice(uint256 price) external onlyOwner {
1629         NFT_PRICE = price;
1630     }
1631 
1632     function setFreePeaceAliensAvailable(uint256 available) external onlyOwner {
1633         freePeaceAliensAvailable = available;
1634     }
1635 
1636     function setFriendCommunities (address[] memory collections) external onlyOwner {
1637         delete friendCommunities;
1638         friendCommunities = collections;
1639     }
1640 
1641     function startSale() external onlyOwner {
1642         _isSaleActive = true;
1643         emit SaleStarted();
1644     }
1645     
1646     function startFriendSale() external onlyOwner {
1647         _isFriendSaleActive = true;
1648         emit FriendSaleStarted();
1649     }
1650 
1651     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1652         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1653         return string(abi.encodePacked(_baseURI(), tokenId.toString()));
1654     }
1655 
1656     function withdraw() public onlyOwner {
1657         uint256 balance = address(this).balance;
1658         payable(msg.sender).transfer(balance);
1659     }
1660 }