1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //  â–ˆâ–ˆâ–“ â–ˆâ–ˆâ–ˆâ–„    â–ˆ   â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–’â–“â–ˆâ–ˆâ–ˆâ–ˆâ–ˆ  â–ˆâ–ˆâ–€â–ˆâ–ˆâ–ˆ   â–ˆâ–ˆâ–ˆâ–„    â–ˆ  â–„â–„â–„       â–ˆâ–ˆâ–“       â–“â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–“â–ˆâ–ˆ   â–ˆâ–ˆâ–“â–“â–ˆâ–ˆâ–ˆâ–ˆâ–ˆ   â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ 
5 // â–“â–ˆâ–ˆâ–’ â–ˆâ–ˆ â–€â–ˆ   â–ˆ â–“â–ˆâ–ˆ   â–’ â–“â–ˆ   â–€ â–“â–ˆâ–ˆ â–’ â–ˆâ–ˆâ–’ â–ˆâ–ˆ â–€â–ˆ   â–ˆ â–’â–ˆâ–ˆâ–ˆâ–ˆâ–„    â–“â–ˆâ–ˆâ–’       â–“â–ˆ   â–€ â–’â–ˆâ–ˆ  â–ˆâ–ˆâ–’â–“â–ˆ   â–€ â–’â–ˆâ–ˆ    â–’ 
6 // â–’â–ˆâ–ˆâ–’â–“â–ˆâ–ˆ  â–€â–ˆ â–ˆâ–ˆâ–’â–’â–ˆâ–ˆâ–ˆâ–ˆ â–‘ â–’â–ˆâ–ˆâ–ˆ   â–“â–ˆâ–ˆ â–‘â–„â–ˆ â–’â–“â–ˆâ–ˆ  â–€â–ˆ â–ˆâ–ˆâ–’â–’â–ˆâ–ˆ  â–€â–ˆâ–„  â–’â–ˆâ–ˆâ–‘       â–’â–ˆâ–ˆâ–ˆ    â–’â–ˆâ–ˆ â–ˆâ–ˆâ–‘â–’â–ˆâ–ˆâ–ˆ   â–‘ â–“â–ˆâ–ˆâ–„   
7 // â–‘â–ˆâ–ˆâ–‘â–“â–ˆâ–ˆâ–’  â–â–Œâ–ˆâ–ˆâ–’â–‘â–“â–ˆâ–’  â–‘ â–’â–“â–ˆ  â–„ â–’â–ˆâ–ˆâ–€â–€â–ˆâ–„  â–“â–ˆâ–ˆâ–’  â–â–Œâ–ˆâ–ˆâ–’â–‘â–ˆâ–ˆâ–„â–„â–„â–„â–ˆâ–ˆ â–’â–ˆâ–ˆâ–‘       â–’â–“â–ˆ  â–„  â–‘ â–â–ˆâ–ˆâ–“â–‘â–’â–“â–ˆ  â–„   â–’   â–ˆâ–ˆâ–’
8 // â–‘â–ˆâ–ˆâ–‘â–’â–ˆâ–ˆâ–‘   â–“â–ˆâ–ˆâ–‘â–‘â–’â–ˆâ–‘    â–‘â–’â–ˆâ–ˆâ–ˆâ–ˆâ–’â–‘â–ˆâ–ˆâ–“ â–’â–ˆâ–ˆâ–’â–’â–ˆâ–ˆâ–‘   â–“â–ˆâ–ˆâ–‘ â–“â–ˆ   â–“â–ˆâ–ˆâ–’â–‘â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–’   â–‘â–’â–ˆâ–ˆâ–ˆâ–ˆâ–’ â–‘ â–ˆâ–ˆâ–’â–“â–‘â–‘â–’â–ˆâ–ˆâ–ˆâ–ˆâ–’â–’â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–’â–’
9 // â–‘â–“  â–‘ â–’â–‘   â–’ â–’  â–’ â–‘    â–‘â–‘ â–’â–‘ â–‘â–‘ â–’â–“ â–‘â–’â–“â–‘â–‘ â–’â–‘   â–’ â–’  â–’â–’   â–“â–’â–ˆâ–‘â–‘ â–’â–‘â–“  â–‘   â–‘â–‘ â–’â–‘ â–‘  â–ˆâ–ˆâ–’â–’â–’ â–‘â–‘ â–’â–‘ â–‘â–’ â–’â–“â–’ â–’ â–‘
10 //  â–’ â–‘â–‘ â–‘â–‘   â–‘ â–’â–‘ â–‘       â–‘ â–‘  â–‘  â–‘â–’ â–‘ â–’â–‘â–‘ â–‘â–‘   â–‘ â–’â–‘  â–’   â–’â–’ â–‘â–‘ â–‘ â–’  â–‘    â–‘ â–‘  â–‘â–“â–ˆâ–ˆ â–‘â–’â–‘  â–‘ â–‘  â–‘â–‘ â–‘â–’  â–‘ â–‘
11 //  â–’ â–‘   â–‘   â–‘ â–‘  â–‘ â–‘       â–‘     â–‘â–‘   â–‘    â–‘   â–‘ â–‘   â–‘   â–’     â–‘ â–‘         â–‘   â–’ â–’ â–‘â–‘     â–‘   â–‘  â–‘  â–‘  
12 //  â–‘           â–‘            â–‘  â–‘   â–‘              â–‘       â–‘  â–‘    â–‘  â–‘      â–‘  â–‘â–‘ â–‘        â–‘  â–‘      â–‘  
13 //                                                                               â–‘ â–‘                     
14 //
15 //*********************************************************************//
16 //*********************************************************************//
17   
18 //-------------DEPENDENCIES--------------------------//
19 
20 // File: @openzeppelin/contracts/utils/Address.sol
21 
22 
23 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
24 
25 pragma solidity ^0.8.1;
26 
27 /**
28  * @dev Collection of functions related to the address type
29  */
30 library Address {
31     /**
32      * @dev Returns true if account is a contract.
33      *
34      * [IMPORTANT]
35      * ====
36      * It is unsafe to assume that an address for which this function returns
37      * false is an externally-owned account (EOA) and not a contract.
38      *
39      * Among others, isContract will return false for the following
40      * types of addresses:
41      *
42      *  - an externally-owned account
43      *  - a contract in construction
44      *  - an address where a contract will be created
45      *  - an address where a contract lived, but was destroyed
46      * ====
47      *
48      * [IMPORTANT]
49      * ====
50      * You shouldn't rely on isContract to protect against flash loan attacks!
51      *
52      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
53      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
54      * constructor.
55      * ====
56      */
57     function isContract(address account) internal view returns (bool) {
58         // This method relies on extcodesize/address.code.length, which returns 0
59         // for contracts in construction, since the code is only stored at the end
60         // of the constructor execution.
61 
62         return account.code.length > 0;
63     }
64 
65     /**
66      * @dev Replacement for Solidity's transfer: sends amount wei to
67      * recipient, forwarding all available gas and reverting on errors.
68      *
69      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
70      * of certain opcodes, possibly making contracts go over the 2300 gas limit
71      * imposed by transfer, making them unable to receive funds via
72      * transfer. {sendValue} removes this limitation.
73      *
74      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
75      *
76      * IMPORTANT: because control is transferred to recipient, care must be
77      * taken to not create reentrancy vulnerabilities. Consider using
78      * {ReentrancyGuard} or the
79      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
80      */
81     function sendValue(address payable recipient, uint256 amount) internal {
82         require(address(this).balance >= amount, "Address: insufficient balance");
83 
84         (bool success, ) = recipient.call{value: amount}("");
85         require(success, "Address: unable to send value, recipient may have reverted");
86     }
87 
88     /**
89      * @dev Performs a Solidity function call using a low level call. A
90      * plain call is an unsafe replacement for a function call: use this
91      * function instead.
92      *
93      * If target reverts with a revert reason, it is bubbled up by this
94      * function (like regular Solidity function calls).
95      *
96      * Returns the raw returned data. To convert to the expected return value,
97      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
98      *
99      * Requirements:
100      *
101      * - target must be a contract.
102      * - calling target with data must not revert.
103      *
104      * _Available since v3.1._
105      */
106     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
107         return functionCall(target, data, "Address: low-level call failed");
108     }
109 
110     /**
111      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
112      * errorMessage as a fallback revert reason when target reverts.
113      *
114      * _Available since v3.1._
115      */
116     function functionCall(
117         address target,
118         bytes memory data,
119         string memory errorMessage
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, 0, errorMessage);
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
126      * but also transferring value wei to target.
127      *
128      * Requirements:
129      *
130      * - the calling contract must have an ETH balance of at least value.
131      * - the called Solidity function must be payable.
132      *
133      * _Available since v3.1._
134      */
135     function functionCallWithValue(
136         address target,
137         bytes memory data,
138         uint256 value
139     ) internal returns (bytes memory) {
140         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
145      * with errorMessage as a fallback revert reason when target reverts.
146      *
147      * _Available since v3.1._
148      */
149     function functionCallWithValue(
150         address target,
151         bytes memory data,
152         uint256 value,
153         string memory errorMessage
154     ) internal returns (bytes memory) {
155         require(address(this).balance >= value, "Address: insufficient balance for call");
156         require(isContract(target), "Address: call to non-contract");
157 
158         (bool success, bytes memory returndata) = target.call{value: value}(data);
159         return verifyCallResult(success, returndata, errorMessage);
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
164      * but performing a static call.
165      *
166      * _Available since v3.3._
167      */
168     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
169         return functionStaticCall(target, data, "Address: low-level static call failed");
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
174      * but performing a static call.
175      *
176      * _Available since v3.3._
177      */
178     function functionStaticCall(
179         address target,
180         bytes memory data,
181         string memory errorMessage
182     ) internal view returns (bytes memory) {
183         require(isContract(target), "Address: static call to non-contract");
184 
185         (bool success, bytes memory returndata) = target.staticcall(data);
186         return verifyCallResult(success, returndata, errorMessage);
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
191      * but performing a delegate call.
192      *
193      * _Available since v3.4._
194      */
195     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
196         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
201      * but performing a delegate call.
202      *
203      * _Available since v3.4._
204      */
205     function functionDelegateCall(
206         address target,
207         bytes memory data,
208         string memory errorMessage
209     ) internal returns (bytes memory) {
210         require(isContract(target), "Address: delegate call to non-contract");
211 
212         (bool success, bytes memory returndata) = target.delegatecall(data);
213         return verifyCallResult(success, returndata, errorMessage);
214     }
215 
216     /**
217      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
218      * revert reason using the provided one.
219      *
220      * _Available since v4.3._
221      */
222     function verifyCallResult(
223         bool success,
224         bytes memory returndata,
225         string memory errorMessage
226     ) internal pure returns (bytes memory) {
227         if (success) {
228             return returndata;
229         } else {
230             // Look for revert reason and bubble it up if present
231             if (returndata.length > 0) {
232                 // The easiest way to bubble the revert reason is using memory via assembly
233 
234                 assembly {
235                     let returndata_size := mload(returndata)
236                     revert(add(32, returndata), returndata_size)
237                 }
238             } else {
239                 revert(errorMessage);
240             }
241         }
242     }
243 }
244 
245 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
246 
247 
248 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
249 
250 pragma solidity ^0.8.0;
251 
252 /**
253  * @title ERC721 token receiver interface
254  * @dev Interface for any contract that wants to support safeTransfers
255  * from ERC721 asset contracts.
256  */
257 interface IERC721Receiver {
258     /**
259      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
260      * by operator from from, this function is called.
261      *
262      * It must return its Solidity selector to confirm the token transfer.
263      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
264      *
265      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
266      */
267     function onERC721Received(
268         address operator,
269         address from,
270         uint256 tokenId,
271         bytes calldata data
272     ) external returns (bytes4);
273 }
274 
275 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
276 
277 
278 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
279 
280 pragma solidity ^0.8.0;
281 
282 /**
283  * @dev Interface of the ERC165 standard, as defined in the
284  * https://eips.ethereum.org/EIPS/eip-165[EIP].
285  *
286  * Implementers can declare support of contract interfaces, which can then be
287  * queried by others ({ERC165Checker}).
288  *
289  * For an implementation, see {ERC165}.
290  */
291 interface IERC165 {
292     /**
293      * @dev Returns true if this contract implements the interface defined by
294      * interfaceId. See the corresponding
295      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
296      * to learn more about how these ids are created.
297      *
298      * This function call must use less than 30 000 gas.
299      */
300     function supportsInterface(bytes4 interfaceId) external view returns (bool);
301 }
302 
303 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
304 
305 
306 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
307 
308 pragma solidity ^0.8.0;
309 
310 
311 /**
312  * @dev Implementation of the {IERC165} interface.
313  *
314  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
315  * for the additional interface id that will be supported. For example:
316  *
317  * solidity
318  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
319  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
320  * }
321  * 
322  *
323  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
324  */
325 abstract contract ERC165 is IERC165 {
326     /**
327      * @dev See {IERC165-supportsInterface}.
328      */
329     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
330         return interfaceId == type(IERC165).interfaceId;
331     }
332 }
333 
334 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
335 
336 
337 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
338 
339 pragma solidity ^0.8.0;
340 
341 
342 /**
343  * @dev Required interface of an ERC721 compliant contract.
344  */
345 interface IERC721 is IERC165 {
346     /**
347      * @dev Emitted when tokenId token is transferred from from to to.
348      */
349     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
350 
351     /**
352      * @dev Emitted when owner enables approved to manage the tokenId token.
353      */
354     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
355 
356     /**
357      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
358      */
359     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
360 
361     /**
362      * @dev Returns the number of tokens in owner's account.
363      */
364     function balanceOf(address owner) external view returns (uint256 balance);
365 
366     /**
367      * @dev Returns the owner of the tokenId token.
368      *
369      * Requirements:
370      *
371      * - tokenId must exist.
372      */
373     function ownerOf(uint256 tokenId) external view returns (address owner);
374 
375     /**
376      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
377      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
378      *
379      * Requirements:
380      *
381      * - from cannot be the zero address.
382      * - to cannot be the zero address.
383      * - tokenId token must exist and be owned by from.
384      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
385      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
386      *
387      * Emits a {Transfer} event.
388      */
389     function safeTransferFrom(
390         address from,
391         address to,
392         uint256 tokenId
393     ) external;
394 
395     /**
396      * @dev Transfers tokenId token from from to to.
397      *
398      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
399      *
400      * Requirements:
401      *
402      * - from cannot be the zero address.
403      * - to cannot be the zero address.
404      * - tokenId token must be owned by from.
405      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
406      *
407      * Emits a {Transfer} event.
408      */
409     function transferFrom(
410         address from,
411         address to,
412         uint256 tokenId
413     ) external;
414 
415     /**
416      * @dev Gives permission to to to transfer tokenId token to another account.
417      * The approval is cleared when the token is transferred.
418      *
419      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
420      *
421      * Requirements:
422      *
423      * - The caller must own the token or be an approved operator.
424      * - tokenId must exist.
425      *
426      * Emits an {Approval} event.
427      */
428     function approve(address to, uint256 tokenId) external;
429 
430     /**
431      * @dev Returns the account approved for tokenId token.
432      *
433      * Requirements:
434      *
435      * - tokenId must exist.
436      */
437     function getApproved(uint256 tokenId) external view returns (address operator);
438 
439     /**
440      * @dev Approve or remove operator as an operator for the caller.
441      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
442      *
443      * Requirements:
444      *
445      * - The operator cannot be the caller.
446      *
447      * Emits an {ApprovalForAll} event.
448      */
449     function setApprovalForAll(address operator, bool _approved) external;
450 
451     /**
452      * @dev Returns if the operator is allowed to manage all of the assets of owner.
453      *
454      * See {setApprovalForAll}
455      */
456     function isApprovedForAll(address owner, address operator) external view returns (bool);
457 
458     /**
459      * @dev Safely transfers tokenId token from from to to.
460      *
461      * Requirements:
462      *
463      * - from cannot be the zero address.
464      * - to cannot be the zero address.
465      * - tokenId token must exist and be owned by from.
466      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
467      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
468      *
469      * Emits a {Transfer} event.
470      */
471     function safeTransferFrom(
472         address from,
473         address to,
474         uint256 tokenId,
475         bytes calldata data
476     ) external;
477 }
478 
479 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
480 
481 
482 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
483 
484 pragma solidity ^0.8.0;
485 
486 
487 /**
488  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
489  * @dev See https://eips.ethereum.org/EIPS/eip-721
490  */
491 interface IERC721Enumerable is IERC721 {
492     /**
493      * @dev Returns the total amount of tokens stored by the contract.
494      */
495     function totalSupply() external view returns (uint256);
496 
497     /**
498      * @dev Returns a token ID owned by owner at a given index of its token list.
499      * Use along with {balanceOf} to enumerate all of owner's tokens.
500      */
501     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
502 
503     /**
504      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
505      * Use along with {totalSupply} to enumerate all tokens.
506      */
507     function tokenByIndex(uint256 index) external view returns (uint256);
508 }
509 
510 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
511 
512 
513 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
514 
515 pragma solidity ^0.8.0;
516 
517 
518 /**
519  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
520  * @dev See https://eips.ethereum.org/EIPS/eip-721
521  */
522 interface IERC721Metadata is IERC721 {
523     /**
524      * @dev Returns the token collection name.
525      */
526     function name() external view returns (string memory);
527 
528     /**
529      * @dev Returns the token collection symbol.
530      */
531     function symbol() external view returns (string memory);
532 
533     /**
534      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
535      */
536     function tokenURI(uint256 tokenId) external view returns (string memory);
537 }
538 
539 // File: @openzeppelin/contracts/utils/Strings.sol
540 
541 
542 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
543 
544 pragma solidity ^0.8.0;
545 
546 /**
547  * @dev String operations.
548  */
549 library Strings {
550     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
551 
552     /**
553      * @dev Converts a uint256 to its ASCII string decimal representation.
554      */
555     function toString(uint256 value) internal pure returns (string memory) {
556         // Inspired by OraclizeAPI's implementation - MIT licence
557         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
558 
559         if (value == 0) {
560             return "0";
561         }
562         uint256 temp = value;
563         uint256 digits;
564         while (temp != 0) {
565             digits++;
566             temp /= 10;
567         }
568         bytes memory buffer = new bytes(digits);
569         while (value != 0) {
570             digits -= 1;
571             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
572             value /= 10;
573         }
574         return string(buffer);
575     }
576 
577     /**
578      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
579      */
580     function toHexString(uint256 value) internal pure returns (string memory) {
581         if (value == 0) {
582             return "0x00";
583         }
584         uint256 temp = value;
585         uint256 length = 0;
586         while (temp != 0) {
587             length++;
588             temp >>= 8;
589         }
590         return toHexString(value, length);
591     }
592 
593     /**
594      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
595      */
596     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
597         bytes memory buffer = new bytes(2 * length + 2);
598         buffer[0] = "0";
599         buffer[1] = "x";
600         for (uint256 i = 2 * length + 1; i > 1; --i) {
601             buffer[i] = _HEX_SYMBOLS[value & 0xf];
602             value >>= 4;
603         }
604         require(value == 0, "Strings: hex length insufficient");
605         return string(buffer);
606     }
607 }
608 
609 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
610 
611 
612 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
613 
614 pragma solidity ^0.8.0;
615 
616 /**
617  * @dev Contract module that helps prevent reentrant calls to a function.
618  *
619  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
620  * available, which can be applied to functions to make sure there are no nested
621  * (reentrant) calls to them.
622  *
623  * Note that because there is a single nonReentrant guard, functions marked as
624  * nonReentrant may not call one another. This can be worked around by making
625  * those functions private, and then adding external nonReentrant entry
626  * points to them.
627  *
628  * TIP: If you would like to learn more about reentrancy and alternative ways
629  * to protect against it, check out our blog post
630  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
631  */
632 abstract contract ReentrancyGuard {
633     // Booleans are more expensive than uint256 or any type that takes up a full
634     // word because each write operation emits an extra SLOAD to first read the
635     // slot's contents, replace the bits taken up by the boolean, and then write
636     // back. This is the compiler's defense against contract upgrades and
637     // pointer aliasing, and it cannot be disabled.
638 
639     // The values being non-zero value makes deployment a bit more expensive,
640     // but in exchange the refund on every call to nonReentrant will be lower in
641     // amount. Since refunds are capped to a percentage of the total
642     // transaction's gas, it is best to keep them low in cases like this one, to
643     // increase the likelihood of the full refund coming into effect.
644     uint256 private constant _NOT_ENTERED = 1;
645     uint256 private constant _ENTERED = 2;
646 
647     uint256 private _status;
648 
649     constructor() {
650         _status = _NOT_ENTERED;
651     }
652 
653     /**
654      * @dev Prevents a contract from calling itself, directly or indirectly.
655      * Calling a nonReentrant function from another nonReentrant
656      * function is not supported. It is possible to prevent this from happening
657      * by making the nonReentrant function external, and making it call a
658      * private function that does the actual work.
659      */
660     modifier nonReentrant() {
661         // On the first call to nonReentrant, _notEntered will be true
662         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
663 
664         // Any calls to nonReentrant after this point will fail
665         _status = _ENTERED;
666 
667         _;
668 
669         // By storing the original value once again, a refund is triggered (see
670         // https://eips.ethereum.org/EIPS/eip-2200)
671         _status = _NOT_ENTERED;
672     }
673 }
674 
675 // File: @openzeppelin/contracts/utils/Context.sol
676 
677 
678 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
679 
680 pragma solidity ^0.8.0;
681 
682 /**
683  * @dev Provides information about the current execution context, including the
684  * sender of the transaction and its data. While these are generally available
685  * via msg.sender and msg.data, they should not be accessed in such a direct
686  * manner, since when dealing with meta-transactions the account sending and
687  * paying for execution may not be the actual sender (as far as an application
688  * is concerned).
689  *
690  * This contract is only required for intermediate, library-like contracts.
691  */
692 abstract contract Context {
693     function _msgSender() internal view virtual returns (address) {
694         return msg.sender;
695     }
696 
697     function _msgData() internal view virtual returns (bytes calldata) {
698         return msg.data;
699     }
700 }
701 
702 // File: @openzeppelin/contracts/access/Ownable.sol
703 
704 
705 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
706 
707 pragma solidity ^0.8.0;
708 
709 
710 /**
711  * @dev Contract module which provides a basic access control mechanism, where
712  * there is an account (an owner) that can be granted exclusive access to
713  * specific functions.
714  *
715  * By default, the owner account will be the one that deploys the contract. This
716  * can later be changed with {transferOwnership}.
717  *
718  * This module is used through inheritance. It will make available the modifier
719  * onlyOwner, which can be applied to your functions to restrict their use to
720  * the owner.
721  */
722 abstract contract Ownable is Context {
723     address private _owner;
724 
725     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
726 
727     /**
728      * @dev Initializes the contract setting the deployer as the initial owner.
729      */
730     constructor() {
731         _transferOwnership(_msgSender());
732     }
733 
734     /**
735      * @dev Returns the address of the current owner.
736      */
737     function owner() public view virtual returns (address) {
738         return _owner;
739     }
740 
741     /**
742      * @dev Throws if called by any account other than the owner.
743      */
744     modifier onlyOwner() {
745         require(owner() == _msgSender(), "Ownable: caller is not the owner");
746         _;
747     }
748 
749     /**
750      * @dev Leaves the contract without owner. It will not be possible to call
751      * onlyOwner functions anymore. Can only be called by the current owner.
752      *
753      * NOTE: Renouncing ownership will leave the contract without an owner,
754      * thereby removing any functionality that is only available to the owner.
755      */
756     function renounceOwnership() public virtual onlyOwner {
757         _transferOwnership(address(0));
758     }
759 
760     /**
761      * @dev Transfers ownership of the contract to a new account (newOwner).
762      * Can only be called by the current owner.
763      */
764     function transferOwnership(address newOwner) public virtual onlyOwner {
765         require(newOwner != address(0), "Ownable: new owner is the zero address");
766         _transferOwnership(newOwner);
767     }
768 
769     /**
770      * @dev Transfers ownership of the contract to a new account (newOwner).
771      * Internal function without access restriction.
772      */
773     function _transferOwnership(address newOwner) internal virtual {
774         address oldOwner = _owner;
775         _owner = newOwner;
776         emit OwnershipTransferred(oldOwner, newOwner);
777     }
778 }
779 //-------------END DEPENDENCIES------------------------//
780 
781 
782   
783 // Rampp Contracts v2.1 (Teams.sol)
784 
785 pragma solidity ^0.8.0;
786 
787 /**
788 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
789 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
790 * This will easily allow cross-collaboration via Rampp.xyz.
791 **/
792 abstract contract Teams is Ownable{
793   mapping (address => bool) internal team;
794 
795   /**
796   * @dev Adds an address to the team. Allows them to execute protected functions
797   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
798   **/
799   function addToTeam(address _address) public onlyOwner {
800     require(_address != address(0), "Invalid address");
801     require(!inTeam(_address), "This address is already in your team.");
802   
803     team[_address] = true;
804   }
805 
806   /**
807   * @dev Removes an address to the team.
808   * @param _address the ETH address to remove, cannot be 0x and must be in team
809   **/
810   function removeFromTeam(address _address) public onlyOwner {
811     require(_address != address(0), "Invalid address");
812     require(inTeam(_address), "This address is not in your team currently.");
813   
814     team[_address] = false;
815   }
816 
817   /**
818   * @dev Check if an address is valid and active in the team
819   * @param _address ETH address to check for truthiness
820   **/
821   function inTeam(address _address)
822     public
823     view
824     returns (bool)
825   {
826     require(_address != address(0), "Invalid address to check.");
827     return team[_address] == true;
828   }
829 
830   /**
831   * @dev Throws if called by any account other than the owner or team member.
832   */
833   modifier onlyTeamOrOwner() {
834     bool _isOwner = owner() == _msgSender();
835     bool _isTeam = inTeam(_msgSender());
836     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
837     _;
838   }
839 }
840 
841 
842   
843   
844 /**
845  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
846  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
847  *
848  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
849  * 
850  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
851  *
852  * Does not support burning tokens to address(0).
853  */
854 contract ERC721A is
855   Context,
856   ERC165,
857   IERC721,
858   IERC721Metadata,
859   IERC721Enumerable
860 {
861   using Address for address;
862   using Strings for uint256;
863 
864   struct TokenOwnership {
865     address addr;
866     uint64 startTimestamp;
867   }
868 
869   struct AddressData {
870     uint128 balance;
871     uint128 numberMinted;
872   }
873 
874   uint256 private currentIndex;
875 
876   uint256 public immutable collectionSize;
877   uint256 public maxBatchSize;
878 
879   // Token name
880   string private _name;
881 
882   // Token symbol
883   string private _symbol;
884 
885   // Mapping from token ID to ownership details
886   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
887   mapping(uint256 => TokenOwnership) private _ownerships;
888 
889   // Mapping owner address to address data
890   mapping(address => AddressData) private _addressData;
891 
892   // Mapping from token ID to approved address
893   mapping(uint256 => address) private _tokenApprovals;
894 
895   // Mapping from owner to operator approvals
896   mapping(address => mapping(address => bool)) private _operatorApprovals;
897 
898   /**
899    * @dev
900    * maxBatchSize refers to how much a minter can mint at a time.
901    * collectionSize_ refers to how many tokens are in the collection.
902    */
903   constructor(
904     string memory name_,
905     string memory symbol_,
906     uint256 maxBatchSize_,
907     uint256 collectionSize_
908   ) {
909     require(
910       collectionSize_ > 0,
911       "ERC721A: collection must have a nonzero supply"
912     );
913     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
914     _name = name_;
915     _symbol = symbol_;
916     maxBatchSize = maxBatchSize_;
917     collectionSize = collectionSize_;
918     currentIndex = _startTokenId();
919   }
920 
921   /**
922   * To change the starting tokenId, please override this function.
923   */
924   function _startTokenId() internal view virtual returns (uint256) {
925     return 1;
926   }
927 
928   /**
929    * @dev See {IERC721Enumerable-totalSupply}.
930    */
931   function totalSupply() public view override returns (uint256) {
932     return _totalMinted();
933   }
934 
935   function currentTokenId() public view returns (uint256) {
936     return _totalMinted();
937   }
938 
939   function getNextTokenId() public view returns (uint256) {
940       return _totalMinted() + 1;
941   }
942 
943   /**
944   * Returns the total amount of tokens minted in the contract.
945   */
946   function _totalMinted() internal view returns (uint256) {
947     unchecked {
948       return currentIndex - _startTokenId();
949     }
950   }
951 
952   /**
953    * @dev See {IERC721Enumerable-tokenByIndex}.
954    */
955   function tokenByIndex(uint256 index) public view override returns (uint256) {
956     require(index < totalSupply(), "ERC721A: global index out of bounds");
957     return index;
958   }
959 
960   /**
961    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
962    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
963    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
964    */
965   function tokenOfOwnerByIndex(address owner, uint256 index)
966     public
967     view
968     override
969     returns (uint256)
970   {
971     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
972     uint256 numMintedSoFar = totalSupply();
973     uint256 tokenIdsIdx = 0;
974     address currOwnershipAddr = address(0);
975     for (uint256 i = 0; i < numMintedSoFar; i++) {
976       TokenOwnership memory ownership = _ownerships[i];
977       if (ownership.addr != address(0)) {
978         currOwnershipAddr = ownership.addr;
979       }
980       if (currOwnershipAddr == owner) {
981         if (tokenIdsIdx == index) {
982           return i;
983         }
984         tokenIdsIdx++;
985       }
986     }
987     revert("ERC721A: unable to get token of owner by index");
988   }
989 
990   /**
991    * @dev See {IERC165-supportsInterface}.
992    */
993   function supportsInterface(bytes4 interfaceId)
994     public
995     view
996     virtual
997     override(ERC165, IERC165)
998     returns (bool)
999   {
1000     return
1001       interfaceId == type(IERC721).interfaceId ||
1002       interfaceId == type(IERC721Metadata).interfaceId ||
1003       interfaceId == type(IERC721Enumerable).interfaceId ||
1004       super.supportsInterface(interfaceId);
1005   }
1006 
1007   /**
1008    * @dev See {IERC721-balanceOf}.
1009    */
1010   function balanceOf(address owner) public view override returns (uint256) {
1011     require(owner != address(0), "ERC721A: balance query for the zero address");
1012     return uint256(_addressData[owner].balance);
1013   }
1014 
1015   function _numberMinted(address owner) internal view returns (uint256) {
1016     require(
1017       owner != address(0),
1018       "ERC721A: number minted query for the zero address"
1019     );
1020     return uint256(_addressData[owner].numberMinted);
1021   }
1022 
1023   function ownershipOf(uint256 tokenId)
1024     internal
1025     view
1026     returns (TokenOwnership memory)
1027   {
1028     uint256 curr = tokenId;
1029 
1030     unchecked {
1031         if (_startTokenId() <= curr && curr < currentIndex) {
1032             TokenOwnership memory ownership = _ownerships[curr];
1033             if (ownership.addr != address(0)) {
1034                 return ownership;
1035             }
1036 
1037             // Invariant:
1038             // There will always be an ownership that has an address and is not burned
1039             // before an ownership that does not have an address and is not burned.
1040             // Hence, curr will not underflow.
1041             while (true) {
1042                 curr--;
1043                 ownership = _ownerships[curr];
1044                 if (ownership.addr != address(0)) {
1045                     return ownership;
1046                 }
1047             }
1048         }
1049     }
1050 
1051     revert("ERC721A: unable to determine the owner of token");
1052   }
1053 
1054   /**
1055    * @dev See {IERC721-ownerOf}.
1056    */
1057   function ownerOf(uint256 tokenId) public view override returns (address) {
1058     return ownershipOf(tokenId).addr;
1059   }
1060 
1061   /**
1062    * @dev See {IERC721Metadata-name}.
1063    */
1064   function name() public view virtual override returns (string memory) {
1065     return _name;
1066   }
1067 
1068   /**
1069    * @dev See {IERC721Metadata-symbol}.
1070    */
1071   function symbol() public view virtual override returns (string memory) {
1072     return _symbol;
1073   }
1074 
1075   /**
1076    * @dev See {IERC721Metadata-tokenURI}.
1077    */
1078   function tokenURI(uint256 tokenId)
1079     public
1080     view
1081     virtual
1082     override
1083     returns (string memory)
1084   {
1085     string memory baseURI = _baseURI();
1086     return
1087       bytes(baseURI).length > 0
1088         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1089         : "";
1090   }
1091 
1092   /**
1093    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1094    * token will be the concatenation of the baseURI and the tokenId. Empty
1095    * by default, can be overriden in child contracts.
1096    */
1097   function _baseURI() internal view virtual returns (string memory) {
1098     return "";
1099   }
1100 
1101   /**
1102    * @dev See {IERC721-approve}.
1103    */
1104   function approve(address to, uint256 tokenId) public override {
1105     address owner = ERC721A.ownerOf(tokenId);
1106     require(to != owner, "ERC721A: approval to current owner");
1107 
1108     require(
1109       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1110       "ERC721A: approve caller is not owner nor approved for all"
1111     );
1112 
1113     _approve(to, tokenId, owner);
1114   }
1115 
1116   /**
1117    * @dev See {IERC721-getApproved}.
1118    */
1119   function getApproved(uint256 tokenId) public view override returns (address) {
1120     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1121 
1122     return _tokenApprovals[tokenId];
1123   }
1124 
1125   /**
1126    * @dev See {IERC721-setApprovalForAll}.
1127    */
1128   function setApprovalForAll(address operator, bool approved) public override {
1129     require(operator != _msgSender(), "ERC721A: approve to caller");
1130 
1131     _operatorApprovals[_msgSender()][operator] = approved;
1132     emit ApprovalForAll(_msgSender(), operator, approved);
1133   }
1134 
1135   /**
1136    * @dev See {IERC721-isApprovedForAll}.
1137    */
1138   function isApprovedForAll(address owner, address operator)
1139     public
1140     view
1141     virtual
1142     override
1143     returns (bool)
1144   {
1145     return _operatorApprovals[owner][operator];
1146   }
1147 
1148   /**
1149    * @dev See {IERC721-transferFrom}.
1150    */
1151   function transferFrom(
1152     address from,
1153     address to,
1154     uint256 tokenId
1155   ) public override {
1156     _transfer(from, to, tokenId);
1157   }
1158 
1159   /**
1160    * @dev See {IERC721-safeTransferFrom}.
1161    */
1162   function safeTransferFrom(
1163     address from,
1164     address to,
1165     uint256 tokenId
1166   ) public override {
1167     safeTransferFrom(from, to, tokenId, "");
1168   }
1169 
1170   /**
1171    * @dev See {IERC721-safeTransferFrom}.
1172    */
1173   function safeTransferFrom(
1174     address from,
1175     address to,
1176     uint256 tokenId,
1177     bytes memory _data
1178   ) public override {
1179     _transfer(from, to, tokenId);
1180     require(
1181       _checkOnERC721Received(from, to, tokenId, _data),
1182       "ERC721A: transfer to non ERC721Receiver implementer"
1183     );
1184   }
1185 
1186   /**
1187    * @dev Returns whether tokenId exists.
1188    *
1189    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1190    *
1191    * Tokens start existing when they are minted (_mint),
1192    */
1193   function _exists(uint256 tokenId) internal view returns (bool) {
1194     return _startTokenId() <= tokenId && tokenId < currentIndex;
1195   }
1196 
1197   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1198     _safeMint(to, quantity, isAdminMint, "");
1199   }
1200 
1201   /**
1202    * @dev Mints quantity tokens and transfers them to to.
1203    *
1204    * Requirements:
1205    *
1206    * - there must be quantity tokens remaining unminted in the total collection.
1207    * - to cannot be the zero address.
1208    * - quantity cannot be larger than the max batch size.
1209    *
1210    * Emits a {Transfer} event.
1211    */
1212   function _safeMint(
1213     address to,
1214     uint256 quantity,
1215     bool isAdminMint,
1216     bytes memory _data
1217   ) internal {
1218     uint256 startTokenId = currentIndex;
1219     require(to != address(0), "ERC721A: mint to the zero address");
1220     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1221     require(!_exists(startTokenId), "ERC721A: token already minted");
1222 
1223     // For admin mints we do not want to enforce the maxBatchSize limit
1224     if (isAdminMint == false) {
1225         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1226     }
1227 
1228     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1229 
1230     AddressData memory addressData = _addressData[to];
1231     _addressData[to] = AddressData(
1232       addressData.balance + uint128(quantity),
1233       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1234     );
1235     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1236 
1237     uint256 updatedIndex = startTokenId;
1238 
1239     for (uint256 i = 0; i < quantity; i++) {
1240       emit Transfer(address(0), to, updatedIndex);
1241       require(
1242         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1243         "ERC721A: transfer to non ERC721Receiver implementer"
1244       );
1245       updatedIndex++;
1246     }
1247 
1248     currentIndex = updatedIndex;
1249     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1250   }
1251 
1252   /**
1253    * @dev Transfers tokenId from from to to.
1254    *
1255    * Requirements:
1256    *
1257    * - to cannot be the zero address.
1258    * - tokenId token must be owned by from.
1259    *
1260    * Emits a {Transfer} event.
1261    */
1262   function _transfer(
1263     address from,
1264     address to,
1265     uint256 tokenId
1266   ) private {
1267     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1268 
1269     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1270       getApproved(tokenId) == _msgSender() ||
1271       isApprovedForAll(prevOwnership.addr, _msgSender()));
1272 
1273     require(
1274       isApprovedOrOwner,
1275       "ERC721A: transfer caller is not owner nor approved"
1276     );
1277 
1278     require(
1279       prevOwnership.addr == from,
1280       "ERC721A: transfer from incorrect owner"
1281     );
1282     require(to != address(0), "ERC721A: transfer to the zero address");
1283 
1284     _beforeTokenTransfers(from, to, tokenId, 1);
1285 
1286     // Clear approvals from the previous owner
1287     _approve(address(0), tokenId, prevOwnership.addr);
1288 
1289     _addressData[from].balance -= 1;
1290     _addressData[to].balance += 1;
1291     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1292 
1293     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1294     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1295     uint256 nextTokenId = tokenId + 1;
1296     if (_ownerships[nextTokenId].addr == address(0)) {
1297       if (_exists(nextTokenId)) {
1298         _ownerships[nextTokenId] = TokenOwnership(
1299           prevOwnership.addr,
1300           prevOwnership.startTimestamp
1301         );
1302       }
1303     }
1304 
1305     emit Transfer(from, to, tokenId);
1306     _afterTokenTransfers(from, to, tokenId, 1);
1307   }
1308 
1309   /**
1310    * @dev Approve to to operate on tokenId
1311    *
1312    * Emits a {Approval} event.
1313    */
1314   function _approve(
1315     address to,
1316     uint256 tokenId,
1317     address owner
1318   ) private {
1319     _tokenApprovals[tokenId] = to;
1320     emit Approval(owner, to, tokenId);
1321   }
1322 
1323   uint256 public nextOwnerToExplicitlySet = 0;
1324 
1325   /**
1326    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1327    */
1328   function _setOwnersExplicit(uint256 quantity) internal {
1329     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1330     require(quantity > 0, "quantity must be nonzero");
1331     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1332 
1333     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1334     if (endIndex > collectionSize - 1) {
1335       endIndex = collectionSize - 1;
1336     }
1337     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1338     require(_exists(endIndex), "not enough minted yet for this cleanup");
1339     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1340       if (_ownerships[i].addr == address(0)) {
1341         TokenOwnership memory ownership = ownershipOf(i);
1342         _ownerships[i] = TokenOwnership(
1343           ownership.addr,
1344           ownership.startTimestamp
1345         );
1346       }
1347     }
1348     nextOwnerToExplicitlySet = endIndex + 1;
1349   }
1350 
1351   /**
1352    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1353    * The call is not executed if the target address is not a contract.
1354    *
1355    * @param from address representing the previous owner of the given token ID
1356    * @param to target address that will receive the tokens
1357    * @param tokenId uint256 ID of the token to be transferred
1358    * @param _data bytes optional data to send along with the call
1359    * @return bool whether the call correctly returned the expected magic value
1360    */
1361   function _checkOnERC721Received(
1362     address from,
1363     address to,
1364     uint256 tokenId,
1365     bytes memory _data
1366   ) private returns (bool) {
1367     if (to.isContract()) {
1368       try
1369         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1370       returns (bytes4 retval) {
1371         return retval == IERC721Receiver(to).onERC721Received.selector;
1372       } catch (bytes memory reason) {
1373         if (reason.length == 0) {
1374           revert("ERC721A: transfer to non ERC721Receiver implementer");
1375         } else {
1376           assembly {
1377             revert(add(32, reason), mload(reason))
1378           }
1379         }
1380       }
1381     } else {
1382       return true;
1383     }
1384   }
1385 
1386   /**
1387    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1388    *
1389    * startTokenId - the first token id to be transferred
1390    * quantity - the amount to be transferred
1391    *
1392    * Calling conditions:
1393    *
1394    * - When from and to are both non-zero, from's tokenId will be
1395    * transferred to to.
1396    * - When from is zero, tokenId will be minted for to.
1397    */
1398   function _beforeTokenTransfers(
1399     address from,
1400     address to,
1401     uint256 startTokenId,
1402     uint256 quantity
1403   ) internal virtual {}
1404 
1405   /**
1406    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1407    * minting.
1408    *
1409    * startTokenId - the first token id to be transferred
1410    * quantity - the amount to be transferred
1411    *
1412    * Calling conditions:
1413    *
1414    * - when from and to are both non-zero.
1415    * - from and to are never both zero.
1416    */
1417   function _afterTokenTransfers(
1418     address from,
1419     address to,
1420     uint256 startTokenId,
1421     uint256 quantity
1422   ) internal virtual {}
1423 }
1424 
1425 
1426 
1427   
1428 abstract contract Ramppable {
1429   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1430 
1431   modifier isRampp() {
1432       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1433       _;
1434   }
1435 }
1436 
1437 
1438   
1439   
1440 interface IERC20 {
1441   function allowance(address owner, address spender) external view returns (uint256);
1442   function transfer(address _to, uint256 _amount) external returns (bool);
1443   function balanceOf(address account) external view returns (uint256);
1444   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1445 }
1446 
1447 // File: WithdrawableV2
1448 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1449 // ERC-20 Payouts are limited to a single payout address. This feature 
1450 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1451 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1452 abstract contract WithdrawableV2 is Teams, Ramppable {
1453   struct acceptedERC20 {
1454     bool isActive;
1455     uint256 chargeAmount;
1456   }
1457 
1458   mapping(address => acceptedERC20) private allowedTokenContracts;
1459   address[] public payableAddresses = [RAMPPADDRESS,0x714Ba6F0d76770c30d094491C111407858d3B107];
1460   address[] public surchargePayableAddresses = [RAMPPADDRESS];
1461   address public erc20Payable = 0x714Ba6F0d76770c30d094491C111407858d3B107;
1462   uint256[] public payableFees = [5,95];
1463   uint256[] public surchargePayableFees = [100];
1464   uint256 public payableAddressCount = 2;
1465   uint256 public surchargePayableAddressCount = 1;
1466   uint256 public ramppSurchargeBalance = 0 ether;
1467   uint256 public ramppSurchargeFee = 0.001 ether;
1468   bool public onlyERC20MintingMode = false;
1469 
1470   /**
1471   * @dev Calculates the true payable balance of the contract as the
1472   * value on contract may be from ERC-20 mint surcharges and not 
1473   * public mint charges - which are not eligable for rev share & user withdrawl
1474   */
1475   function calcAvailableBalance() public view returns(uint256) {
1476     return address(this).balance - ramppSurchargeBalance;
1477   }
1478 
1479   function withdrawAll() public onlyTeamOrOwner {
1480       require(calcAvailableBalance() > 0);
1481       _withdrawAll();
1482   }
1483   
1484   function withdrawAllRampp() public isRampp {
1485       require(calcAvailableBalance() > 0);
1486       _withdrawAll();
1487   }
1488 
1489   function _withdrawAll() private {
1490       uint256 balance = calcAvailableBalance();
1491       
1492       for(uint i=0; i < payableAddressCount; i++ ) {
1493           _widthdraw(
1494               payableAddresses[i],
1495               (balance * payableFees[i]) / 100
1496           );
1497       }
1498   }
1499   
1500   function _widthdraw(address _address, uint256 _amount) private {
1501       (bool success, ) = _address.call{value: _amount}("");
1502       require(success, "Transfer failed.");
1503   }
1504 
1505   /**
1506   * @dev This function is similiar to the regular withdraw but operates only on the
1507   * balance that is available to surcharge payout addresses. This would be Rampp + partners
1508   **/
1509   function _withdrawAllSurcharges() private {
1510     uint256 balance = ramppSurchargeBalance;
1511     if(balance == 0) { return; }
1512     
1513     for(uint i=0; i < surchargePayableAddressCount; i++ ) {
1514         _widthdraw(
1515             surchargePayableAddresses[i],
1516             (balance * surchargePayableFees[i]) / 100
1517         );
1518     }
1519     ramppSurchargeBalance = 0 ether;
1520   }
1521 
1522   /**
1523   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1524   * in the event ERC-20 tokens are paid to the contract for mints. This will
1525   * send the tokens to the payout as well as payout the surcharge fee to Rampp
1526   * @param _tokenContract contract of ERC-20 token to withdraw
1527   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1528   */
1529   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1530     require(_amountToWithdraw > 0);
1531     IERC20 tokenContract = IERC20(_tokenContract);
1532     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1533     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1534     _withdrawAllSurcharges();
1535   }
1536 
1537   /**
1538   * @dev Allow Rampp to be able to withdraw only its ERC-20 payment surcharges from the contract.
1539   */
1540   function withdrawRamppSurcharges() public isRampp {
1541     require(ramppSurchargeBalance > 0, "WithdrawableV2: No Rampp surcharges in balance.");
1542     _withdrawAllSurcharges();
1543   }
1544 
1545    /**
1546   * @dev Helper function to increment Rampp surcharge balance when ERC-20 payment is made.
1547   */
1548   function addSurcharge() internal {
1549     ramppSurchargeBalance += ramppSurchargeFee;
1550   }
1551   
1552   /**
1553   * @dev Helper function to enforce Rampp surcharge fee when ERC-20 mint is made.
1554   */
1555   function hasSurcharge() internal returns(bool) {
1556     return msg.value == ramppSurchargeFee;
1557   }
1558 
1559   /**
1560   * @dev Set surcharge fee for using ERC-20 payments on contract
1561   * @param _newSurcharge is the new surcharge value of native currency in wei to facilitate ERC-20 payments
1562   */
1563   function setRamppSurcharge(uint256 _newSurcharge) public isRampp {
1564     ramppSurchargeFee = _newSurcharge;
1565   }
1566 
1567   /**
1568   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1569   * @param _erc20TokenContract address of ERC-20 contract in question
1570   */
1571   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1572     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1573   }
1574 
1575   /**
1576   * @dev get the value of tokens to transfer for user of an ERC-20
1577   * @param _erc20TokenContract address of ERC-20 contract in question
1578   */
1579   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1580     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1581     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1582   }
1583 
1584   /**
1585   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1586   * @param _erc20TokenContract address of ERC-20 contract in question
1587   * @param _isActive default status of if contract should be allowed to accept payments
1588   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1589   */
1590   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1591     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1592     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1593   }
1594 
1595   /**
1596   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1597   * it will assume the default value of zero. This should not be used to create new payment tokens.
1598   * @param _erc20TokenContract address of ERC-20 contract in question
1599   */
1600   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1601     allowedTokenContracts[_erc20TokenContract].isActive = true;
1602   }
1603 
1604   /**
1605   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1606   * it will assume the default value of zero. This should not be used to create new payment tokens.
1607   * @param _erc20TokenContract address of ERC-20 contract in question
1608   */
1609   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1610     allowedTokenContracts[_erc20TokenContract].isActive = false;
1611   }
1612 
1613   /**
1614   * @dev Enable only ERC-20 payments for minting on this contract
1615   */
1616   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1617     onlyERC20MintingMode = true;
1618   }
1619 
1620   /**
1621   * @dev Disable only ERC-20 payments for minting on this contract
1622   */
1623   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1624     onlyERC20MintingMode = false;
1625   }
1626 
1627   /**
1628   * @dev Set the payout of the ERC-20 token payout to a specific address
1629   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1630   */
1631   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1632     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1633     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1634     erc20Payable = _newErc20Payable;
1635   }
1636 
1637   /**
1638   * @dev Reset the Rampp surcharge total to zero regardless of value on contract currently.
1639   */
1640   function resetRamppSurchargeBalance() public isRampp {
1641     ramppSurchargeBalance = 0 ether;
1642   }
1643 
1644   /**
1645   * @dev Allows Rampp wallet to update its own reference as well as update
1646   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1647   * and since Rampp is always the first address this function is limited to the rampp payout only.
1648   * @param _newAddress updated Rampp Address
1649   */
1650   function setRamppAddress(address _newAddress) public isRampp {
1651     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1652     RAMPPADDRESS = _newAddress;
1653     payableAddresses[0] = _newAddress;
1654   }
1655 }
1656 
1657 
1658   
1659   
1660 // File: EarlyMintIncentive.sol
1661 // Allows the contract to have the first x tokens have a discount or
1662 // zero fee that can be calculated on the fly.
1663 abstract contract EarlyMintIncentive is Teams, ERC721A {
1664   uint256 public PRICE = 0.002 ether;
1665   uint256 public EARLY_MINT_PRICE = 0 ether;
1666   uint256 public earlyMintTokenIdCap = 333;
1667   bool public usingEarlyMintIncentive = true;
1668 
1669   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1670     usingEarlyMintIncentive = true;
1671   }
1672 
1673   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1674     usingEarlyMintIncentive = false;
1675   }
1676 
1677   /**
1678   * @dev Set the max token ID in which the cost incentive will be applied.
1679   * @param _newTokenIdCap max tokenId in which incentive will be applied
1680   */
1681   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyTeamOrOwner {
1682     require(_newTokenIdCap <= collectionSize, "Cannot set incentive tokenId cap larger than totaly supply.");
1683     require(_newTokenIdCap >= 1, "Cannot set tokenId cap to less than the first token");
1684     earlyMintTokenIdCap = _newTokenIdCap;
1685   }
1686 
1687   /**
1688   * @dev Set the incentive mint price
1689   * @param _feeInWei new price per token when in incentive range
1690   */
1691   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1692     EARLY_MINT_PRICE = _feeInWei;
1693   }
1694 
1695   /**
1696   * @dev Set the primary mint price - the base price when not under incentive
1697   * @param _feeInWei new price per token
1698   */
1699   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1700     PRICE = _feeInWei;
1701   }
1702 
1703   function getPrice(uint256 _count) public view returns (uint256) {
1704     require(_count > 0, "Must be minting at least 1 token.");
1705 
1706     // short circuit function if we dont need to even calc incentive pricing
1707     // short circuit if the current tokenId is also already over cap
1708     if(
1709       usingEarlyMintIncentive == false ||
1710       currentTokenId() > earlyMintTokenIdCap
1711     ) {
1712       return PRICE * _count;
1713     }
1714 
1715     uint256 endingTokenId = currentTokenId() + _count;
1716     // If qty to mint results in a final token ID less than or equal to the cap then
1717     // the entire qty is within free mint.
1718     if(endingTokenId  <= earlyMintTokenIdCap) {
1719       return EARLY_MINT_PRICE * _count;
1720     }
1721 
1722     // If the current token id is less than the incentive cap
1723     // and the ending token ID is greater than the incentive cap
1724     // we will be straddling the cap so there will be some amount
1725     // that are incentive and some that are regular fee.
1726     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
1727     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
1728 
1729     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1730   }
1731 }
1732 
1733   
1734   
1735 abstract contract RamppERC721A is 
1736     Ownable,
1737     Teams,
1738     ERC721A,
1739     WithdrawableV2,
1740     ReentrancyGuard 
1741     , EarlyMintIncentive 
1742      
1743     
1744 {
1745   constructor(
1746     string memory tokenName,
1747     string memory tokenSymbol
1748   ) ERC721A(tokenName, tokenSymbol, 2, 666) { }
1749     uint8 public CONTRACT_VERSION = 2;
1750     string public _baseTokenURI = "ipfs://bafybeicweexub6bmjrietn5rte5emquat5eau4xkqincnsec4zhgmfdhz4/";
1751 
1752     bool public mintingOpen = false;
1753     
1754     
1755     uint256 public MAX_WALLET_MINTS = 4;
1756 
1757   
1758     /////////////// Admin Mint Functions
1759     /**
1760      * @dev Mints a token to an address with a tokenURI.
1761      * This is owner only and allows a fee-free drop
1762      * @param _to address of the future owner of the token
1763      * @param _qty amount of tokens to drop the owner
1764      */
1765      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1766          require(_qty > 0, "Must mint at least 1 token.");
1767          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 666");
1768          _safeMint(_to, _qty, true);
1769      }
1770 
1771   
1772     /////////////// GENERIC MINT FUNCTIONS
1773     /**
1774     * @dev Mints a single token to an address.
1775     * fee may or may not be required*
1776     * @param _to address of the future owner of the token
1777     */
1778     function mintTo(address _to) public payable {
1779         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1780         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 666");
1781         require(mintingOpen == true, "Minting is not open right now!");
1782         
1783         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1784         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1785         
1786         _safeMint(_to, 1, false);
1787     }
1788 
1789     /**
1790     * @dev Mints tokens to an address in batch.
1791     * fee may or may not be required*
1792     * @param _to address of the future owner of the token
1793     * @param _amount number of tokens to mint
1794     */
1795     function mintToMultiple(address _to, uint256 _amount) public payable {
1796         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1797         require(_amount >= 1, "Must mint at least 1 token");
1798         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1799         require(mintingOpen == true, "Minting is not open right now!");
1800         
1801         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1802         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 666");
1803         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1804 
1805         _safeMint(_to, _amount, false);
1806     }
1807 
1808     /**
1809      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1810      * fee may or may not be required*
1811      * @param _to address of the future owner of the token
1812      * @param _amount number of tokens to mint
1813      * @param _erc20TokenContract erc-20 token contract to mint with
1814      */
1815     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1816       require(_amount >= 1, "Must mint at least 1 token");
1817       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1818       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 666");
1819       require(mintingOpen == true, "Minting is not open right now!");
1820       
1821       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1822 
1823       // ERC-20 Specific pre-flight checks
1824       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1825       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1826       IERC20 payableToken = IERC20(_erc20TokenContract);
1827 
1828       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1829       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1830       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
1831       
1832       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1833       require(transferComplete, "ERC-20 token was unable to be transferred");
1834       
1835       _safeMint(_to, _amount, false);
1836       addSurcharge();
1837     }
1838 
1839     function openMinting() public onlyTeamOrOwner {
1840         mintingOpen = true;
1841     }
1842 
1843     function stopMinting() public onlyTeamOrOwner {
1844         mintingOpen = false;
1845     }
1846 
1847   
1848 
1849   
1850     /**
1851     * @dev Check if wallet over MAX_WALLET_MINTS
1852     * @param _address address in question to check if minted count exceeds max
1853     */
1854     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1855         require(_amount >= 1, "Amount must be greater than or equal to 1");
1856         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1857     }
1858 
1859     /**
1860     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1861     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1862     */
1863     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
1864         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1865         MAX_WALLET_MINTS = _newWalletMax;
1866     }
1867     
1868 
1869   
1870     /**
1871      * @dev Allows owner to set Max mints per tx
1872      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1873      */
1874      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
1875          require(_newMaxMint >= 1, "Max mint must be at least 1");
1876          maxBatchSize = _newMaxMint;
1877      }
1878     
1879 
1880   
1881 
1882   function _baseURI() internal view virtual override returns(string memory) {
1883     return _baseTokenURI;
1884   }
1885 
1886   function baseTokenURI() public view returns(string memory) {
1887     return _baseTokenURI;
1888   }
1889 
1890   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
1891     _baseTokenURI = baseURI;
1892   }
1893 
1894   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1895     return ownershipOf(tokenId);
1896   }
1897 }
1898 
1899 
1900   
1901 // File: contracts/InfernalEyesContract.sol
1902 //SPDX-License-Identifier: MIT
1903 
1904 pragma solidity ^0.8.0;
1905 
1906 contract InfernalEyesContract is RamppERC721A {
1907     constructor() RamppERC721A("Infernal Eyes", "EYE"){}
1908 }
1909   
1910 //*********************************************************************//
1911 //*********************************************************************//  
1912 //                       Rampp v2.1.0
1913 //
1914 //         This smart contract was generated by rampp.xyz.
1915 //            Rampp allows creators like you to launch 
1916 //             large scale NFT communities without code!
1917 //
1918 //    Rampp is not responsible for the content of this contract and
1919 //        hopes it is being used in a responsible and kind way.  
1920 //       Rampp is not associated or affiliated with this project.                                                    
1921 //             Twitter: @Rampp_ ---- rampp.xyz
1922 //*********************************************************************//                                                     
1923 //*********************************************************************//