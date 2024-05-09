1 // SPDX-License-Identifier: MIT
2 /*
3                     ......                                      .......                                                           
4                 .cx0XX0kxoolc:,.                            .:dOKXXKOxdollc;..                                                    
5                ;0WMXx;... ...,;;;,,.                       'OWMNko:'.. ...';:;,,.                                                 
6               '0MMK;              .'''.                   .kMMXc               .'''..                                             
7               :NMWl                   ....                ,KMMx.                   .....                                          
8               ;XMN:                      ....             '0MMo                       ....                                        
9               .OMWo                    ..';cddllllc:;'.   .xMMx.              ...........,;,........                              
10                lWMO.              .':ok0XNWMMMMMMMMMMNKkl. :XMK,             ,OKKKKKKKKKXKXNXKXKKKKK0Oxo;.                        
11                .kMWl           .cx0NMMMMMMMMMMMMMMMMMMMMMK:.dWWd.           ,0MMMMMMMMMMMMMMMMMMMMMMMMMMW0,                       
12                 '0MX:       .:kXMMMMMMMMMNXXXNWMMMMMMMMMMM0'.kMNl.         ,KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMx.                      
13                  ,0MK;    .oKWMMMMMMWKxl;'....,lKMMMMMMMMMX; .OMX0c       ,KMMMMMMMNxccccccccclxXMMMMMMMMWo                       
14                   ,0MK: .oXMMMMMMMXd;.          :NMMMWWXXKx.  .kWMXl     ,KMMMMMMMNl           .xMMMMMMMWx.                       
15                    .kWXk0MMMMMMMXo.             .llc:;'..''.   .dXWNd.  ;KMMMMMMMNo..........':kNMMMMMWXo.                        
16                     .xWMMMMMMMWx'                          ..   ..lXWk';KMMMMMMMMWK0000000KKXWMMMMMMXk:...                        
17                     'OWMMMMMMNo.                            .'.    ,OWXNMMMMMMMMMMMMMMMMMMMMMMMMMMW0;    .'.                      
18                    'OMMMMMMMWo                                ''    .kMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWO,     .'                     
19                   .xWMMMMMMMNl              ,lc;'.             .,,. ;KMMMMMMMNxlolllooooox0WMMMMMMMMMd      .'.                   
20                   :NMMMMMMMMMNx,          ,xNMMMNKOx;           .,;lKMMMMMMMNl            .xMMMMMMMMWl        ,'                  
21                   oMMMMMMMMMWXNXd'     .:kNMMMMMMMXo.             cNMMMMMMMMWk,          .:0MMMMMMMNd.         ,,                 
22                   oWMMMMMMMMWXNMMXd:cokXWMMMMMMWKo.             ;xKMMMMMMMWXNMNx:,,,;;cld0NMMMMMMW0:            ,;                
23                   'OMMMMMMMMMMMMMMMMMMMMMMMMMXk:.              ;KMMMMMMMMMMWWMMMMWWWMMMMMMMMMMMW0c.              ::               
24                    .dXMMMMMMMMMMMMMMMMMMMNKxc.                ;KMMMMMMMMMMMMMMMMMMMMMMMMMMMMN0d;.                .o:              
25                      .cdOKNWWMMMWWNXK0XMWO;                  ;0WWWWWWWWMWWWWWWWWWWWWMMMW0xo:'.                    :k'             
26                          ..',;;;,,'....l0NXd;.               .''''''''lXx,''''''''',cONWO:.                       .Oo             
27                                         .;xXN0o,.                     ,Kx.            ,dKWKd;.                    .kO'            
28                                            .ckNN0o;.                  cNO.              .:xXWKd:.                 ;XK,            
29                                               .ckXWKkl;.            .cXMk.                 .:xKWXko:'.           :0M0'            
30                                                  .:d0NWX0xol::;;::cd0WMX:                     .;oOXWN0kdlc:;;:coONMNo             
31                                                      ':okKNWMMMMMMMMMNk,                          .;lx0XWMMMMMMMMNO:              
32                                                          ..,:loooool:'                                ..,:cloool:'                
33 */ 
34 
35 // File: @openzeppelin/contracts/utils/Strings.sol
36 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
37 
38 pragma solidity ^0.8.4;
39 
40 /**
41  * @dev String operations.
42  */
43 library Strings {
44     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
45 
46     /**
47      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
48      */
49     function toString(uint256 value) internal pure returns (string memory) {
50         // Inspired by OraclizeAPI's implementation - MIT licence
51         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
52 
53         if (value == 0) {
54             return "0";
55         }
56         uint256 temp = value;
57         uint256 digits;
58         while (temp != 0) {
59             digits++;
60             temp /= 10;
61         }
62         bytes memory buffer = new bytes(digits);
63         while (value != 0) {
64             digits -= 1;
65             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
66             value /= 10;
67         }
68         return string(buffer);
69     }
70 
71     /**
72      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
73      */
74     function toHexString(uint256 value) internal pure returns (string memory) {
75         if (value == 0) {
76             return "0x00";
77         }
78         uint256 temp = value;
79         uint256 length = 0;
80         while (temp != 0) {
81             length++;
82             temp >>= 8;
83         }
84         return toHexString(value, length);
85     }
86 
87     /**
88      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
89      */
90     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
91         bytes memory buffer = new bytes(2 * length + 2);
92         buffer[0] = "0";
93         buffer[1] = "x";
94         for (uint256 i = 2 * length + 1; i > 1; --i) {
95             buffer[i] = _HEX_SYMBOLS[value & 0xf];
96             value >>= 4;
97         }
98         require(value == 0, "Strings: hex length insufficient");
99         return string(buffer);
100     }
101 }
102 
103 // File: @openzeppelin/contracts/utils/Context.sol
104 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
105 /**
106  * @dev Provides information about the current execution context, including the
107  * sender of the transaction and its data. While these are generally available
108  * via msg.sender and msg.data, they should not be accessed in such a direct
109  * manner, since when dealing with meta-transactions the account sending and
110  * paying for execution may not be the actual sender (as far as an application
111  * is concerned).
112  *
113  * This contract is only required for intermediate, library-like contracts.
114  */
115 abstract contract Context {
116     function _msgSender() internal view virtual returns (address) {
117         return msg.sender;
118     }
119 
120     function _msgData() internal view virtual returns (bytes calldata) {
121         return msg.data;
122     }
123 }
124 
125 // File: @openzeppelin/contracts/utils/Address.sol
126 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
127 
128 /**
129  * @dev Collection of functions related to the address type
130  */
131 library Address {
132     /**
133      * @dev Returns true if `account` is a contract.
134      *
135      * [IMPORTANT]
136      * ====
137      * It is unsafe to assume that an address for which this function returns
138      * false is an externally-owned account (EOA) and not a contract.
139      *
140      * Among others, `isContract` will return false for the following
141      * types of addresses:
142      *
143      *  - an externally-owned account
144      *  - a contract in construction
145      *  - an address where a contract will be created
146      *  - an address where a contract lived, but was destroyed
147      * ====
148      *
149      * [IMPORTANT]
150      * ====
151      * You shouldn't rely on `isContract` to protect against flash loan attacks!
152      *
153      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
154      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
155      * constructor.
156      * ====
157      */
158     function isContract(address account) internal view returns (bool) {
159         // This method relies on extcodesize/address.code.length, which returns 0
160         // for contracts in construction, since the code is only stored at the end
161         // of the constructor execution.
162 
163         return account.code.length > 0;
164     }
165 
166     /**
167      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
168      * `recipient`, forwarding all available gas and reverting on errors.
169      *
170      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
171      * of certain opcodes, possibly making contracts go over the 2300 gas limit
172      * imposed by `transfer`, making them unable to receive funds via
173      * `transfer`. {sendValue} removes this limitation.
174      *
175      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
176      *
177      * IMPORTANT: because control is transferred to `recipient`, care must be
178      * taken to not create reentrancy vulnerabilities. Consider using
179      * {ReentrancyGuard} or the
180      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
181      */
182     function sendValue(address payable recipient, uint256 amount) internal {
183         require(address(this).balance >= amount, "Address: insufficient balance");
184 
185         (bool success, ) = recipient.call{value: amount}("");
186         require(success, "Address: unable to send value, recipient may have reverted");
187     }
188 
189     /**
190      * @dev Performs a Solidity function call using a low level `call`. A
191      * plain `call` is an unsafe replacement for a function call: use this
192      * function instead.
193      *
194      * If `target` reverts with a revert reason, it is bubbled up by this
195      * function (like regular Solidity function calls).
196      *
197      * Returns the raw returned data. To convert to the expected return value,
198      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
199      *
200      * Requirements:
201      *
202      * - `target` must be a contract.
203      * - calling `target` with `data` must not revert.
204      *
205      * _Available since v3.1._
206      */
207     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
208         return functionCall(target, data, "Address: low-level call failed");
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
213      * `errorMessage` as a fallback revert reason when `target` reverts.
214      *
215      * _Available since v3.1._
216      */
217     function functionCall(
218         address target,
219         bytes memory data,
220         string memory errorMessage
221     ) internal returns (bytes memory) {
222         return functionCallWithValue(target, data, 0, errorMessage);
223     }
224 
225     /**
226      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
227      * but also transferring `value` wei to `target`.
228      *
229      * Requirements:
230      *
231      * - the calling contract must have an ETH balance of at least `value`.
232      * - the called Solidity function must be `payable`.
233      *
234      * _Available since v3.1._
235      */
236     function functionCallWithValue(
237         address target,
238         bytes memory data,
239         uint256 value
240     ) internal returns (bytes memory) {
241         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
246      * with `errorMessage` as a fallback revert reason when `target` reverts.
247      *
248      * _Available since v3.1._
249      */
250     function functionCallWithValue(
251         address target,
252         bytes memory data,
253         uint256 value,
254         string memory errorMessage
255     ) internal returns (bytes memory) {
256         require(address(this).balance >= value, "Address: insufficient balance for call");
257         require(isContract(target), "Address: call to non-contract");
258 
259         (bool success, bytes memory returndata) = target.call{value: value}(data);
260         return verifyCallResult(success, returndata, errorMessage);
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
265      * but performing a static call.
266      *
267      * _Available since v3.3._
268      */
269     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
270         return functionStaticCall(target, data, "Address: low-level static call failed");
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
275      * but performing a static call.
276      *
277      * _Available since v3.3._
278      */
279     function functionStaticCall(
280         address target,
281         bytes memory data,
282         string memory errorMessage
283     ) internal view returns (bytes memory) {
284         require(isContract(target), "Address: static call to non-contract");
285 
286         (bool success, bytes memory returndata) = target.staticcall(data);
287         return verifyCallResult(success, returndata, errorMessage);
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
292      * but performing a delegate call.
293      *
294      * _Available since v3.4._
295      */
296     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
297         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
302      * but performing a delegate call.
303      *
304      * _Available since v3.4._
305      */
306     function functionDelegateCall(
307         address target,
308         bytes memory data,
309         string memory errorMessage
310     ) internal returns (bytes memory) {
311         require(isContract(target), "Address: delegate call to non-contract");
312 
313         (bool success, bytes memory returndata) = target.delegatecall(data);
314         return verifyCallResult(success, returndata, errorMessage);
315     }
316 
317     /**
318      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
319      * revert reason using the provided one.
320      *
321      * _Available since v4.3._
322      */
323     function verifyCallResult(
324         bool success,
325         bytes memory returndata,
326         string memory errorMessage
327     ) internal pure returns (bytes memory) {
328         if (success) {
329             return returndata;
330         } else {
331             // Look for revert reason and bubble it up if present
332             if (returndata.length > 0) {
333                 // The easiest way to bubble the revert reason is using memory via assembly
334 
335                 assembly {
336                     let returndata_size := mload(returndata)
337                     revert(add(32, returndata), returndata_size)
338                 }
339             } else {
340                 revert(errorMessage);
341             }
342         }
343     }
344 }
345 
346 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
347 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
348 
349 /**
350  * @title ERC721 token receiver interface
351  * @dev Interface for any contract that wants to support safeTransfers
352  * from ERC721 asset contracts.
353  */
354 interface IERC721Receiver {
355     /**
356      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
357      * by `operator` from `from`, this function is called.
358      *
359      * It must return its Solidity selector to confirm the token transfer.
360      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
361      *
362      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
363      */
364     function onERC721Received(
365         address operator,
366         address from,
367         uint256 tokenId,
368         bytes calldata data
369     ) external returns (bytes4);
370 }
371 
372 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
373 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
374 
375 /**
376  * @dev Interface of the ERC165 standard, as defined in the
377  * https://eips.ethereum.org/EIPS/eip-165[EIP].
378  *
379  * Implementers can declare support of contract interfaces, which can then be
380  * queried by others ({ERC165Checker}).
381  *
382  * For an implementation, see {ERC165}.
383  */
384 interface IERC165 {
385     /**
386      * @dev Returns true if this contract implements the interface defined by
387      * `interfaceId`. See the corresponding
388      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
389      * to learn more about how these ids are created.
390      *
391      * This function call must use less than 30 000 gas.
392      */
393     function supportsInterface(bytes4 interfaceId) external view returns (bool);
394 }
395 
396 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
397 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
398 
399 /**
400  * @dev Implementation of the {IERC165} interface.
401  *
402  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
403  * for the additional interface id that will be supported. For example:
404  *
405  * ```solidity
406  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
407  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
408  * }
409  * ```
410  *
411  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
412  */
413 abstract contract ERC165 is IERC165 {
414     /**
415      * @dev See {IERC165-supportsInterface}.
416      */
417     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
418         return interfaceId == type(IERC165).interfaceId;
419     }
420 }
421 
422 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
423 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
424 
425 /**
426  * @dev Required interface of an ERC721 compliant contract.
427  */
428 interface IERC721 is IERC165 {
429     /**
430      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
431      */
432     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
433 
434     /**
435      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
436      */
437     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
438 
439     /**
440      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
441      */
442     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
443 
444     /**
445      * @dev Returns the number of tokens in ``owner``'s account.
446      */
447     function balanceOf(address owner) external view returns (uint256 balance);
448 
449     /**
450      * @dev Returns the owner of the `tokenId` token.
451      *
452      * Requirements:
453      *
454      * - `tokenId` must exist.
455      */
456     function ownerOf(uint256 tokenId) external view returns (address owner);
457 
458     /**
459      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
460      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
461      *
462      * Requirements:
463      *
464      * - `from` cannot be the zero address.
465      * - `to` cannot be the zero address.
466      * - `tokenId` token must exist and be owned by `from`.
467      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
468      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
469      *
470      * Emits a {Transfer} event.
471      */
472     function safeTransferFrom(
473         address from,
474         address to,
475         uint256 tokenId
476     ) external;
477 
478     /**
479      * @dev Transfers `tokenId` token from `from` to `to`.
480      *
481      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
482      *
483      * Requirements:
484      *
485      * - `from` cannot be the zero address.
486      * - `to` cannot be the zero address.
487      * - `tokenId` token must be owned by `from`.
488      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
489      *
490      * Emits a {Transfer} event.
491      */
492     function transferFrom(
493         address from,
494         address to,
495         uint256 tokenId
496     ) external;
497 
498     /**
499      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
500      * The approval is cleared when the token is transferred.
501      *
502      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
503      *
504      * Requirements:
505      *
506      * - The caller must own the token or be an approved operator.
507      * - `tokenId` must exist.
508      *
509      * Emits an {Approval} event.
510      */
511     function approve(address to, uint256 tokenId) external;
512 
513     /**
514      * @dev Returns the account approved for `tokenId` token.
515      *
516      * Requirements:
517      *
518      * - `tokenId` must exist.
519      */
520     function getApproved(uint256 tokenId) external view returns (address operator);
521 
522     /**
523      * @dev Approve or remove `operator` as an operator for the caller.
524      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
525      *
526      * Requirements:
527      *
528      * - The `operator` cannot be the caller.
529      *
530      * Emits an {ApprovalForAll} event.
531      */
532     function setApprovalForAll(address operator, bool _approved) external;
533 
534     /**
535      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
536      *
537      * See {setApprovalForAll}
538      */
539     function isApprovedForAll(address owner, address operator) external view returns (bool);
540 
541     /**
542      * @dev Safely transfers `tokenId` token from `from` to `to`.
543      *
544      * Requirements:
545      *
546      * - `from` cannot be the zero address.
547      * - `to` cannot be the zero address.
548      * - `tokenId` token must exist and be owned by `from`.
549      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
550      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
551      *
552      * Emits a {Transfer} event.
553      */
554     function safeTransferFrom(
555         address from,
556         address to,
557         uint256 tokenId,
558         bytes calldata data
559     ) external;
560 }
561 
562 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
563 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
564 
565 
566 /**
567  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
568  * @dev See https://eips.ethereum.org/EIPS/eip-721
569  */
570 interface IERC721Metadata is IERC721 {
571     /**
572      * @dev Returns the token collection name.
573      */
574     function name() external view returns (string memory);
575 
576     /**
577      * @dev Returns the token collection symbol.
578      */
579     function symbol() external view returns (string memory);
580 
581     /**
582      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
583      */
584     function tokenURI(uint256 tokenId) external view returns (string memory);
585 }
586 
587 error ApprovalCallerNotOwnerNorApproved();
588 error ApprovalQueryForNonexistentToken();
589 error ApproveToCaller();
590 error ApprovalToCurrentOwner();
591 error BalanceQueryForZeroAddress();
592 error MintToZeroAddress();
593 error MintZeroQuantity();
594 error OwnerQueryForNonexistentToken();
595 error TransferCallerNotOwnerNorApproved();
596 error TransferFromIncorrectOwner();
597 error TransferToNonERC721ReceiverImplementer();
598 error TransferToZeroAddress();
599 error URIQueryForNonexistentToken();
600 
601 /**
602  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
603  * the Metadata extension. Built to optimize for lower gas during batch mints.
604  *
605  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
606  *
607  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
608  *
609  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
610  */
611  abstract contract IERC20 {
612  
613     function insRewardOnPurchase(address _user, uint256 _tokenId)  virtual public;
614 	function stopRewardOnPurchase(address _user, uint256 _tokenId)  virtual public;
615     
616     function claimTokenNftRewardMint (address _owner) public virtual returns (uint256 reward);
617     //function claimTokenRewardBuyingExtras (address _owner, uint256 priceInTokens) public virtual returns (bool exito);
618 
619 }
620 
621 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
622     using Address for address;
623     using Strings for uint256;
624 
625     // Compiler will pack this into a single 256bit word.
626     struct TokenOwnership {
627         // The address of the owner.
628         address addr;
629         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
630         uint64 startTimestamp;
631         // Whether the token has been burned.
632        // bool burned;
633     }
634 
635     // Compiler will pack this into a single 256bit word.
636     struct AddressData {
637         // Realistically, 2**64-1 is more than enough.
638         uint64 balance;
639         // Keeps track of mint count with minimal overhead for tokenomics.
640         uint64 numberMinted;
641         // Keeps track of burn count with minimal overhead for tokenomics.
642         //uint64 numberBurned;
643         // For miscellaneous variable(s) pertaining to the address
644         // (e.g. number of whitelist mint slots used).
645         // If there are multiple variables, please pack them into a uint64.
646         //uint64 aux;
647     }
648 
649     // The tokenId of the next token to be minted.
650     uint256 internal _currentIndex;
651 
652     // The number of tokens burned.
653     //uint256 internal _burnCounter;
654 
655     // Token name
656     string private _name;
657 
658     // Token symbol
659     string private _symbol;
660 
661     // Mapping from token ID to ownership details
662     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
663     mapping(uint256 => TokenOwnership) internal _ownerships;
664 
665     // Mapping owner address to address data
666     mapping(address => AddressData) private _addressData;
667 
668     // Mapping from token ID to approved address
669     mapping(uint256 => address) private _tokenApprovals;
670 
671     // Mapping from owner to operator approvals
672     mapping(address => mapping(address => bool)) private _operatorApprovals;
673 
674 /* CUSTOM VARS */
675     address public admin;
676     uint256 constant public MAX_SUPPLY = 3000;
677     string public baseURI = "ipfs://QmW8bM5G712LwthWgHSsG3YcsoyFDT3CBJ3yxaFip4GmPe/";
678     mapping (address => uint256 []) internal tokenIdsOwnedBy;
679     mapping(address => bool) private whiteList;
680     bool public whiteListIsOn = true;
681     bool public mintingIsLive = false;
682 
683 
684 constructor(string memory name_, string memory symbol_) {
685         _name = name_;
686         _symbol = symbol_;
687         _currentIndex = _startTokenId();
688         admin = msg.sender;
689     }
690 
691     /**
692      * To change the starting tokenId, please override this function.
693      */
694     function _startTokenId() internal view virtual returns (uint256) {
695         return 1;
696     }
697 
698     /**
699      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
700      */
701     function totalSupply() public view returns (uint256) {
702         // Counter underflow is impossible as _burnCounter cannot be incremented
703         // more than _currentIndex - _startTokenId() times
704         unchecked {
705             return _currentIndex  - _startTokenId();//- _burnCounter
706         }
707     }
708 
709     /**
710      * Returns the total amount of tokens minted in the contract.
711      */
712     function _totalMinted() internal view returns (uint256) {
713         // Counter underflow is impossible as _currentIndex does not decrement,
714         // and it is initialized to _startTokenId()
715         unchecked {
716             return _currentIndex - _startTokenId();
717         }
718     }
719 
720     /**
721      * @dev See {IERC165-supportsInterface}.
722      */
723     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
724         return
725             interfaceId == type(IERC721).interfaceId ||
726             interfaceId == type(IERC721Metadata).interfaceId ||
727             super.supportsInterface(interfaceId);
728     }
729 
730     /**
731      * @dev See {IERC721-balanceOf}.
732      */
733     function balanceOf(address owner) public view override returns (uint256) {
734         if (owner == address(0)) revert BalanceQueryForZeroAddress();
735         return uint256(_addressData[owner].balance);
736     }
737 
738     /**
739      * Returns the number of tokens minted by `owner`.
740      */
741     function _numberMinted(address owner) internal view returns (uint256) {
742         return uint256(_addressData[owner].numberMinted);
743     }
744 
745     /**
746      * Returns the number of tokens burned by or on behalf of `owner`.
747      
748     function _numberBurned(address owner) internal view returns (uint256) {
749         return uint256(_addressData[owner].numberBurned);
750     }
751     */
752     /**
753      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
754      
755     function _getAux(address owner) internal view returns (uint64) {
756         return _addressData[owner].aux;
757     }
758     */
759     /**
760      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
761      * If there are multiple variables, please pack them into a uint64.
762     
763     function _setAux(address owner, uint64 aux) internal {
764         _addressData[owner].aux = aux;
765     }
766      */
767     /**
768      * Gas spent here starts off proportional to the maximum mint batch size.
769      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
770      */
771     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
772         uint256 curr = tokenId;
773 
774         unchecked {
775             if (_startTokenId() <= curr && curr < _currentIndex) {
776                 TokenOwnership memory ownership = _ownerships[curr];
777                // if (!ownership.burned) {
778                     if (ownership.addr != address(0)) {
779                         return ownership;
780                     }
781                     // Invariant:
782                     // There will always be an ownership that has an address and is not burned
783                     // before an ownership that does not have an address and is not burned.
784                     // Hence, curr will not underflow.
785                     while (true) {
786                         curr--;
787                         ownership = _ownerships[curr];
788                         if (ownership.addr != address(0)) {
789                             return ownership;
790                         }
791                     }
792                 }
793             //}
794         }
795         revert OwnerQueryForNonexistentToken();
796     }
797 
798     /**
799      * @dev See {IERC721-ownerOf}.
800      */
801     function ownerOf(uint256 tokenId) public view override returns (address) {
802         return _ownershipOf(tokenId).addr;
803     }
804 
805     /**
806      * @dev See {IERC721Metadata-name}.
807      */
808     function name() public view virtual override returns (string memory) {
809         return _name;
810     }
811 
812     /**
813      * @dev See {IERC721Metadata-symbol}.
814      */
815     function symbol() public view virtual override returns (string memory) {
816         return _symbol;
817     }
818 
819     /**
820      * @dev See {IERC721Metadata-tokenURI}.
821      */
822     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
823         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
824 
825         //string memory baseURI = _baseURI();
826         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
827     }
828 
829     /**
830      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
831      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
832      * by default, can be overriden in child contracts.
833      
834     function _baseURI() internal view virtual returns (string memory) {
835         return baseURI;
836     }
837     */
838 
839     /**
840      * @dev See {IERC721-approve}.
841      */
842     function approve(address to, uint256 tokenId) public override {
843         address owner = ERC721A.ownerOf(tokenId);
844         if (to == owner) revert ApprovalToCurrentOwner();
845 
846         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
847             revert ApprovalCallerNotOwnerNorApproved();
848         }
849 
850         _approve(to, tokenId, owner);
851     }
852 
853     /**
854      * @dev See {IERC721-getApproved}.
855      */
856     function getApproved(uint256 tokenId) public view override returns (address) {
857         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
858 
859         return _tokenApprovals[tokenId];
860     }
861 
862     /**
863      * @dev See {IERC721-setApprovalForAll}.
864      */
865     function setApprovalForAll(address operator, bool approved) public virtual override {
866         if (operator == _msgSender()) revert ApproveToCaller();
867 
868         _operatorApprovals[_msgSender()][operator] = approved;
869         emit ApprovalForAll(_msgSender(), operator, approved);
870     }
871 
872     /**
873      * @dev See {IERC721-isApprovedForAll}.
874      */
875     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
876         return _operatorApprovals[owner][operator];
877     }
878 
879     /**
880      * @dev See {IERC721-transferFrom}.
881      */
882     function transferFrom(
883         address from,
884         address to,
885         uint256 tokenId
886     ) public virtual override {
887         _transfer(from, to, tokenId);
888     }
889 
890     /**
891      * @dev See {IERC721-safeTransferFrom}.
892      */
893     function safeTransferFrom(
894         address from,
895         address to,
896         uint256 tokenId
897     ) public virtual override {
898         safeTransferFrom(from, to, tokenId, '');
899     }
900 
901     /**
902      * @dev See {IERC721-safeTransferFrom}.
903      */
904     function safeTransferFrom(
905         address from,
906         address to,
907         uint256 tokenId,
908         bytes memory _data
909     ) public virtual override {
910         _transfer(from, to, tokenId);
911         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
912             revert TransferToNonERC721ReceiverImplementer();
913         }
914     }
915 
916     /**
917      * @dev Returns whether `tokenId` exists.
918      *
919      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
920      *
921      * Tokens start existing when they are minted (`_mint`),
922      */
923     function _exists(uint256 tokenId) internal view returns (bool) {
924         return _startTokenId() <= tokenId && tokenId < _currentIndex;
925            // && !_ownerships[tokenId].burned;
926     }
927 
928     function _safeMint(address to, uint256 quantity) internal {
929         _safeMint(to, quantity, '');
930     }
931 
932     /**
933      * @dev Safely mints `quantity` tokens and transfers them to `to`.
934      *
935      * Requirements:
936      *
937      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
938      * - `quantity` must be greater than 0.
939      *
940      * Emits a {Transfer} event.
941      */
942     function _safeMint(
943         address to,
944         uint256 quantity,
945         bytes memory _data
946     ) internal {
947         _mint(to, quantity, _data, true);
948     }
949 
950     /**
951      * @dev Mints `quantity` tokens and transfers them to `to`.
952      *
953      * Requirements:
954      *
955      * - `to` cannot be the zero address.
956      * - `quantity` must be greater than 0.
957      *
958      * Emits a {Transfer} event.
959      */
960     function _mint(
961         address to,
962         uint256 quantity,
963         bytes memory _data,
964         bool safe
965     ) internal {
966         uint256 startTokenId = _currentIndex;
967         if (to == address(0)) revert MintToZeroAddress();
968         if (quantity == 0) revert MintZeroQuantity();
969 
970         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
971 
972         // Overflows are incredibly unrealistic.
973         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
974         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
975         unchecked {
976             _addressData[to].balance += uint64(quantity);
977             _addressData[to].numberMinted += uint64(quantity);
978 
979             _ownerships[startTokenId].addr = to;
980             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
981 
982             uint256 updatedIndex = startTokenId;
983             uint256 end = updatedIndex + quantity;
984 
985             if (safe && to.isContract()) {
986                 do {
987                     emit Transfer(address(0), to, updatedIndex);
988                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
989                         revert TransferToNonERC721ReceiverImplementer();
990                     }
991                 } while (updatedIndex != end);
992                 // Reentrancy protection
993                 if (_currentIndex != startTokenId) revert();
994             } else {
995                 do {
996                     //RIO 
997                     tokenIdsOwnedBy[to].push(updatedIndex);
998                     // Cyber reward are not active on minting
999                     // cyberToken.insRewardOnPurchase(to, updatedIndex); 
1000                     emit Transfer(address(0), to, updatedIndex++);
1001 
1002                 } while (updatedIndex != end);
1003             }
1004             _currentIndex = updatedIndex;
1005         }
1006         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1007     }
1008 
1009     /**
1010      * @dev Transfers `tokenId` from `from` to `to`.
1011      *
1012      * Requirements:
1013      *
1014      * - `to` cannot be the zero address.
1015      * - `tokenId` token must be owned by `from`.
1016      *
1017      * Emits a {Transfer} event.
1018      */
1019     function _transfer(
1020         address from,
1021         address to,
1022         uint256 tokenId
1023     ) private {
1024         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1025 
1026         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1027 
1028         bool isApprovedOrOwner = (_msgSender() == from ||
1029             isApprovedForAll(from, _msgSender()) ||
1030             getApproved(tokenId) == _msgSender());
1031 
1032         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1033         if (to == address(0)) revert TransferToZeroAddress();
1034 
1035         _beforeTokenTransfers(from, to, tokenId, 1);
1036 
1037         // Clear approvals from the previous owner
1038         _approve(address(0), tokenId, from);
1039 
1040         // Underflow of the sender's balance is impossible because we check for
1041         // ownership above and the recipient's balance can't realistically overflow.
1042         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1043         unchecked {
1044             _addressData[from].balance -= 1;
1045             _addressData[to].balance += 1;
1046 
1047             TokenOwnership storage currSlot = _ownerships[tokenId];
1048             currSlot.addr = to;
1049             currSlot.startTimestamp = uint64(block.timestamp);
1050 
1051             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1052             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1053             uint256 nextTokenId = tokenId + 1;
1054             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1055             if (nextSlot.addr == address(0)) {
1056                 // This will suffice for checking _exists(nextTokenId),
1057                 // as a burned slot cannot contain the zero address.
1058                 if (nextTokenId != _currentIndex) {
1059                     nextSlot.addr = from;
1060                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1061                 }
1062             }
1063             
1064      
1065         }
1066             //RIO delete preview ownership array
1067             for(uint index = 0;index < tokenIdsOwnedBy[from].length;index++){
1068                 if(tokenIdsOwnedBy[from][index]==tokenId){
1069                 delete tokenIdsOwnedBy[from][index];
1070             break;
1071             }
1072            }
1073             tokenIdsOwnedBy[to].push(tokenId);
1074             if(cyberIsLive==true){
1075             cyberToken.stopRewardOnPurchase(from,tokenId);
1076             cyberToken.insRewardOnPurchase(to, tokenId);
1077             }
1078         emit Transfer(from, to, tokenId);
1079         _afterTokenTransfers(from, to, tokenId, 1);
1080     }
1081 
1082     
1083     /**
1084      * @dev Approve `to` to operate on `tokenId`
1085      *
1086      * Emits a {Approval} event.
1087      */
1088     function _approve(
1089         address to,
1090         uint256 tokenId,
1091         address owner
1092     ) private {
1093         _tokenApprovals[tokenId] = to;
1094         emit Approval(owner, to, tokenId);
1095     }
1096 
1097     /**
1098      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1099      *
1100      * @param from address representing the previous owner of the given token ID
1101      * @param to target address that will receive the tokens
1102      * @param tokenId uint256 ID of the token to be transferred
1103      * @param _data bytes optional data to send along with the call
1104      * @return bool whether the call correctly returned the expected magic value
1105      */
1106     function _checkContractOnERC721Received(
1107         address from,
1108         address to,
1109         uint256 tokenId,
1110         bytes memory _data
1111     ) private returns (bool) {
1112         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1113             return retval == IERC721Receiver(to).onERC721Received.selector;
1114         } catch (bytes memory reason) {
1115             if (reason.length == 0) {
1116                 revert TransferToNonERC721ReceiverImplementer();
1117             } else {
1118                 assembly {
1119                     revert(add(32, reason), mload(reason))
1120                 }
1121             }
1122         }
1123     }
1124 
1125     /**
1126      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1127      * And also called before burning one token.
1128      *
1129      * startTokenId - the first token id to be transferred
1130      * quantity - the amount to be transferred
1131      *
1132      * Calling conditions:
1133      *
1134      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1135      * transferred to `to`.
1136      * - When `from` is zero, `tokenId` will be minted for `to`.
1137      * - When `to` is zero, `tokenId` will be burned by `from`.
1138      * - `from` and `to` are never both zero.
1139      */
1140     function _beforeTokenTransfers(
1141         address from,
1142         address to,
1143         uint256 startTokenId,
1144         uint256 quantity
1145     ) internal virtual {}
1146 
1147     /**
1148      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1149      * minting.
1150      * And also called after one token has been burned.
1151      *
1152      * startTokenId - the first token id to be transferred
1153      * quantity - the amount to be transferred
1154      *
1155      * Calling conditions:
1156      *
1157      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1158      * transferred to `to`.
1159      * - When `from` is zero, `tokenId` has been minted for `to`.
1160      * - When `to` is zero, `tokenId` has been burned by `from`.
1161      * - `from` and `to` are never both zero.
1162      */
1163     function _afterTokenTransfers(
1164         address from,
1165         address to,
1166         uint256 startTokenId,
1167         uint256 quantity
1168     ) internal virtual {}
1169    
1170 
1171     function mintTokenNFT ()  external returns (bool success){
1172          require((mintingIsLive) ,"Minting is not yet available");
1173          require(totalSupply()+1 <= MAX_SUPPLY,"Collection is not more available");
1174 
1175 
1176         if(whiteListIsOn==true){
1177             require (whiteList[msg.sender],"Address is not whiteListed");
1178             require ((tokenIdsOwnedBy[msg.sender].length + 1) <= 1,"WhiteListed can get only one NFT");
1179         } else {
1180             require ((tokenIdsOwnedBy[msg.sender].length + 1) <= 2,"Can get only 2 NFT");
1181         }
1182         _safeMint(msg.sender,1,'');
1183          
1184         return true;
1185     }
1186     function mintTokenAdmin (uint256 _numTokens)  external returns (bool success){
1187         require(msg.sender == admin,"Only admin can act here");
1188         _safeMint(msg.sender,_numTokens,'');
1189         return true;
1190     }
1191      /* CONTRACT CUSTOM FUNCTIONS */
1192     function includeToWhiteList(address[] memory _wallets ) public {
1193         require(msg.sender == admin,"Only admin can act here");
1194         for(uint8 i = 0; i < _wallets.length; i++) {
1195             whiteList[_wallets[i]] = true;
1196         }
1197     }
1198     
1199     function setWhitelistStatus(bool _status) public {
1200         require(msg.sender == admin,"Only admin can act here");
1201         whiteListIsOn = _status;
1202         mintingIsLive = true;
1203     }
1204         /* Reveal the collection*/
1205     function setBaseURIpfs (string memory _baseUri)  external  returns (bool success){
1206         require(msg.sender == admin,"Only Admin can act this operation");
1207         baseURI = _baseUri;
1208         return true;
1209     }
1210 
1211     function getTokenIdsOwnedBy(address  _owner) virtual public view returns (uint256 [] memory){
1212 	   return tokenIdsOwnedBy[_owner];
1213 	}
1214     
1215 
1216       /**
1217      * Cyber token interactions : each NFT Ownership permits to claim daily $Cyber 
1218      **/
1219 
1220     bool public cyberIsLive = false;
1221     IERC20 public cyberToken;
1222     
1223     function setCyberAddress(address cyber)  public  {
1224     require(msg.sender == admin,"Only admin can act here");
1225      cyberToken = IERC20(cyber);
1226     }
1227 
1228     function setCyberClaimable()  public  {
1229     require(msg.sender == admin,"Only admin can act here");
1230     cyberIsLive = true;
1231     }
1232     function claimTokenNftRewardMint() virtual public{
1233         require(cyberIsLive,"Claim Not yet available");
1234 	    cyberToken.claimTokenNftRewardMint(msg.sender);
1235 	}
1236 
1237 }
1238 contract NFT_Token is ERC721A {
1239     
1240   //Name symbol   
1241     constructor() ERC721A("CyberBoyz3000", "CB3000")  {
1242 
1243     }
1244 }