1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 // â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•— â–ˆâ–ˆâ•—   â–ˆâ–ˆâ•—â–ˆâ–ˆâ–ˆâ•—   â–ˆâ–ˆâ–ˆâ•—â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•—      â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•— â–ˆâ–ˆâ–ˆâ•—   â–ˆâ–ˆâ•—â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•—     â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•— â–ˆâ–ˆâ•—   â–ˆâ–ˆâ•—â–ˆâ–ˆâ–ˆâ•—   â–ˆâ–ˆâ–ˆâ•—â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•— 
5 // â–ˆâ–ˆâ•”â•â•â–ˆâ–ˆâ•—â–ˆâ–ˆâ•‘   â–ˆâ–ˆâ•‘â–ˆâ–ˆâ–ˆâ–ˆâ•— â–ˆâ–ˆâ–ˆâ–ˆâ•‘â–ˆâ–ˆâ•”â•â•â–ˆâ–ˆâ•—    â–ˆâ–ˆâ•”â•â•â–ˆâ–ˆâ•—â–ˆâ–ˆâ–ˆâ–ˆâ•—  â–ˆâ–ˆâ•‘â–ˆâ–ˆâ•”â•â•â–ˆâ–ˆâ•—    â–ˆâ–ˆâ•”â•â•â–ˆâ–ˆâ•—â–ˆâ–ˆâ•‘   â–ˆâ–ˆâ•‘â–ˆâ–ˆâ–ˆâ–ˆâ•— â–ˆâ–ˆâ–ˆâ–ˆâ•‘â–ˆâ–ˆâ•”â•â•â–ˆâ–ˆâ•—
6 // â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•”â•â–ˆâ–ˆâ•‘   â–ˆâ–ˆâ•‘â–ˆâ–ˆâ•”â–ˆâ–ˆâ–ˆâ–ˆâ•”â–ˆâ–ˆâ•‘â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•”â•    â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•‘â–ˆâ–ˆâ•”â–ˆâ–ˆâ•— â–ˆâ–ˆâ•‘â–ˆâ–ˆâ•‘  â–ˆâ–ˆâ•‘    â–ˆâ–ˆâ•‘  â–ˆâ–ˆâ•‘â–ˆâ–ˆâ•‘   â–ˆâ–ˆâ•‘â–ˆâ–ˆâ•”â–ˆâ–ˆâ–ˆâ–ˆâ•”â–ˆâ–ˆâ•‘â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•”â•
7 // â–ˆâ–ˆâ•”â•â•â•â• â–ˆâ–ˆâ•‘   â–ˆâ–ˆâ•‘â–ˆâ–ˆâ•‘â•šâ–ˆâ–ˆâ•”â•â–ˆâ–ˆâ•‘â–ˆâ–ˆâ•”â•â•â•â•     â–ˆâ–ˆâ•”â•â•â–ˆâ–ˆâ•‘â–ˆâ–ˆâ•‘â•šâ–ˆâ–ˆâ•—â–ˆâ–ˆâ•‘â–ˆâ–ˆâ•‘  â–ˆâ–ˆâ•‘    â–ˆâ–ˆâ•‘  â–ˆâ–ˆâ•‘â–ˆâ–ˆâ•‘   â–ˆâ–ˆâ•‘â–ˆâ–ˆâ•‘â•šâ–ˆâ–ˆâ•”â•â–ˆâ–ˆâ•‘â–ˆâ–ˆâ•”â•â•â•â• 
8 // â–ˆâ–ˆâ•‘     â•šâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•”â•â–ˆâ–ˆâ•‘ â•šâ•â• â–ˆâ–ˆâ•‘â–ˆâ–ˆâ•‘         â–ˆâ–ˆâ•‘  â–ˆâ–ˆâ•‘â–ˆâ–ˆâ•‘ â•šâ–ˆâ–ˆâ–ˆâ–ˆâ•‘â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•”â•    â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•”â•â•šâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•”â•â–ˆâ–ˆâ•‘ â•šâ•â• â–ˆâ–ˆâ•‘â–ˆâ–ˆâ•‘     
9 // â•šâ•â•      â•šâ•â•â•â•â•â• â•šâ•â•     â•šâ•â•â•šâ•â•         â•šâ•â•  â•šâ•â•â•šâ•â•  â•šâ•â•â•â•â•šâ•â•â•â•â•â•     â•šâ•â•â•â•â•â•  â•šâ•â•â•â•â•â• â•šâ•â•     â•šâ•â•â•šâ•â•     
10 //                                                                                                           
11 //
12 //*********************************************************************//
13 //*********************************************************************//
14   
15 //-------------DEPENDENCIES--------------------------//
16 
17 // File: @openzeppelin/contracts/utils/Address.sol
18 
19 
20 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
21 
22 pragma solidity ^0.8.1;
23 
24 /**
25  * @dev Collection of functions related to the address type
26  */
27 library Address {
28     /**
29      * @dev Returns true if account is a contract.
30      *
31      * [IMPORTANT]
32      * ====
33      * It is unsafe to assume that an address for which this function returns
34      * false is an externally-owned account (EOA) and not a contract.
35      *
36      * Among others, isContract will return false for the following
37      * types of addresses:
38      *
39      *  - an externally-owned account
40      *  - a contract in construction
41      *  - an address where a contract will be created
42      *  - an address where a contract lived, but was destroyed
43      * ====
44      *
45      * [IMPORTANT]
46      * ====
47      * You shouldn't rely on isContract to protect against flash loan attacks!
48      *
49      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
50      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
51      * constructor.
52      * ====
53      */
54     function isContract(address account) internal view returns (bool) {
55         // This method relies on extcodesize/address.code.length, which returns 0
56         // for contracts in construction, since the code is only stored at the end
57         // of the constructor execution.
58 
59         return account.code.length > 0;
60     }
61 
62     /**
63      * @dev Replacement for Solidity's transfer: sends amount wei to
64      * recipient, forwarding all available gas and reverting on errors.
65      *
66      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
67      * of certain opcodes, possibly making contracts go over the 2300 gas limit
68      * imposed by transfer, making them unable to receive funds via
69      * transfer. {sendValue} removes this limitation.
70      *
71      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
72      *
73      * IMPORTANT: because control is transferred to recipient, care must be
74      * taken to not create reentrancy vulnerabilities. Consider using
75      * {ReentrancyGuard} or the
76      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
77      */
78     function sendValue(address payable recipient, uint256 amount) internal {
79         require(address(this).balance >= amount, "Address: insufficient balance");
80 
81         (bool success, ) = recipient.call{value: amount}("");
82         require(success, "Address: unable to send value, recipient may have reverted");
83     }
84 
85     /**
86      * @dev Performs a Solidity function call using a low level call. A
87      * plain call is an unsafe replacement for a function call: use this
88      * function instead.
89      *
90      * If target reverts with a revert reason, it is bubbled up by this
91      * function (like regular Solidity function calls).
92      *
93      * Returns the raw returned data. To convert to the expected return value,
94      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
95      *
96      * Requirements:
97      *
98      * - target must be a contract.
99      * - calling target with data must not revert.
100      *
101      * _Available since v3.1._
102      */
103     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
104         return functionCall(target, data, "Address: low-level call failed");
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
109      * errorMessage as a fallback revert reason when target reverts.
110      *
111      * _Available since v3.1._
112      */
113     function functionCall(
114         address target,
115         bytes memory data,
116         string memory errorMessage
117     ) internal returns (bytes memory) {
118         return functionCallWithValue(target, data, 0, errorMessage);
119     }
120 
121     /**
122      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
123      * but also transferring value wei to target.
124      *
125      * Requirements:
126      *
127      * - the calling contract must have an ETH balance of at least value.
128      * - the called Solidity function must be payable.
129      *
130      * _Available since v3.1._
131      */
132     function functionCallWithValue(
133         address target,
134         bytes memory data,
135         uint256 value
136     ) internal returns (bytes memory) {
137         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
138     }
139 
140     /**
141      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
142      * with errorMessage as a fallback revert reason when target reverts.
143      *
144      * _Available since v3.1._
145      */
146     function functionCallWithValue(
147         address target,
148         bytes memory data,
149         uint256 value,
150         string memory errorMessage
151     ) internal returns (bytes memory) {
152         require(address(this).balance >= value, "Address: insufficient balance for call");
153         require(isContract(target), "Address: call to non-contract");
154 
155         (bool success, bytes memory returndata) = target.call{value: value}(data);
156         return verifyCallResult(success, returndata, errorMessage);
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
161      * but performing a static call.
162      *
163      * _Available since v3.3._
164      */
165     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
166         return functionStaticCall(target, data, "Address: low-level static call failed");
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
171      * but performing a static call.
172      *
173      * _Available since v3.3._
174      */
175     function functionStaticCall(
176         address target,
177         bytes memory data,
178         string memory errorMessage
179     ) internal view returns (bytes memory) {
180         require(isContract(target), "Address: static call to non-contract");
181 
182         (bool success, bytes memory returndata) = target.staticcall(data);
183         return verifyCallResult(success, returndata, errorMessage);
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
188      * but performing a delegate call.
189      *
190      * _Available since v3.4._
191      */
192     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
193         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
194     }
195 
196     /**
197      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
198      * but performing a delegate call.
199      *
200      * _Available since v3.4._
201      */
202     function functionDelegateCall(
203         address target,
204         bytes memory data,
205         string memory errorMessage
206     ) internal returns (bytes memory) {
207         require(isContract(target), "Address: delegate call to non-contract");
208 
209         (bool success, bytes memory returndata) = target.delegatecall(data);
210         return verifyCallResult(success, returndata, errorMessage);
211     }
212 
213     /**
214      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
215      * revert reason using the provided one.
216      *
217      * _Available since v4.3._
218      */
219     function verifyCallResult(
220         bool success,
221         bytes memory returndata,
222         string memory errorMessage
223     ) internal pure returns (bytes memory) {
224         if (success) {
225             return returndata;
226         } else {
227             // Look for revert reason and bubble it up if present
228             if (returndata.length > 0) {
229                 // The easiest way to bubble the revert reason is using memory via assembly
230 
231                 assembly {
232                     let returndata_size := mload(returndata)
233                     revert(add(32, returndata), returndata_size)
234                 }
235             } else {
236                 revert(errorMessage);
237             }
238         }
239     }
240 }
241 
242 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
243 
244 
245 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
246 
247 pragma solidity ^0.8.0;
248 
249 /**
250  * @title ERC721 token receiver interface
251  * @dev Interface for any contract that wants to support safeTransfers
252  * from ERC721 asset contracts.
253  */
254 interface IERC721Receiver {
255     /**
256      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
257      * by operator from from, this function is called.
258      *
259      * It must return its Solidity selector to confirm the token transfer.
260      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
261      *
262      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
263      */
264     function onERC721Received(
265         address operator,
266         address from,
267         uint256 tokenId,
268         bytes calldata data
269     ) external returns (bytes4);
270 }
271 
272 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
273 
274 
275 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
276 
277 pragma solidity ^0.8.0;
278 
279 /**
280  * @dev Interface of the ERC165 standard, as defined in the
281  * https://eips.ethereum.org/EIPS/eip-165[EIP].
282  *
283  * Implementers can declare support of contract interfaces, which can then be
284  * queried by others ({ERC165Checker}).
285  *
286  * For an implementation, see {ERC165}.
287  */
288 interface IERC165 {
289     /**
290      * @dev Returns true if this contract implements the interface defined by
291      * interfaceId. See the corresponding
292      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
293      * to learn more about how these ids are created.
294      *
295      * This function call must use less than 30 000 gas.
296      */
297     function supportsInterface(bytes4 interfaceId) external view returns (bool);
298 }
299 
300 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
301 
302 
303 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
304 
305 pragma solidity ^0.8.0;
306 
307 
308 /**
309  * @dev Implementation of the {IERC165} interface.
310  *
311  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
312  * for the additional interface id that will be supported. For example:
313  *
314  * solidity
315  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
316  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
317  * }
318  * 
319  *
320  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
321  */
322 abstract contract ERC165 is IERC165 {
323     /**
324      * @dev See {IERC165-supportsInterface}.
325      */
326     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
327         return interfaceId == type(IERC165).interfaceId;
328     }
329 }
330 
331 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
332 
333 
334 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
335 
336 pragma solidity ^0.8.0;
337 
338 
339 /**
340  * @dev Required interface of an ERC721 compliant contract.
341  */
342 interface IERC721 is IERC165 {
343     /**
344      * @dev Emitted when tokenId token is transferred from from to to.
345      */
346     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
347 
348     /**
349      * @dev Emitted when owner enables approved to manage the tokenId token.
350      */
351     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
352 
353     /**
354      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
355      */
356     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
357 
358     /**
359      * @dev Returns the number of tokens in owner's account.
360      */
361     function balanceOf(address owner) external view returns (uint256 balance);
362 
363     /**
364      * @dev Returns the owner of the tokenId token.
365      *
366      * Requirements:
367      *
368      * - tokenId must exist.
369      */
370     function ownerOf(uint256 tokenId) external view returns (address owner);
371 
372     /**
373      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
374      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
375      *
376      * Requirements:
377      *
378      * - from cannot be the zero address.
379      * - to cannot be the zero address.
380      * - tokenId token must exist and be owned by from.
381      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
382      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
383      *
384      * Emits a {Transfer} event.
385      */
386     function safeTransferFrom(
387         address from,
388         address to,
389         uint256 tokenId
390     ) external;
391 
392     /**
393      * @dev Transfers tokenId token from from to to.
394      *
395      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
396      *
397      * Requirements:
398      *
399      * - from cannot be the zero address.
400      * - to cannot be the zero address.
401      * - tokenId token must be owned by from.
402      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
403      *
404      * Emits a {Transfer} event.
405      */
406     function transferFrom(
407         address from,
408         address to,
409         uint256 tokenId
410     ) external;
411 
412     /**
413      * @dev Gives permission to to to transfer tokenId token to another account.
414      * The approval is cleared when the token is transferred.
415      *
416      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
417      *
418      * Requirements:
419      *
420      * - The caller must own the token or be an approved operator.
421      * - tokenId must exist.
422      *
423      * Emits an {Approval} event.
424      */
425     function approve(address to, uint256 tokenId) external;
426 
427     /**
428      * @dev Returns the account approved for tokenId token.
429      *
430      * Requirements:
431      *
432      * - tokenId must exist.
433      */
434     function getApproved(uint256 tokenId) external view returns (address operator);
435 
436     /**
437      * @dev Approve or remove operator as an operator for the caller.
438      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
439      *
440      * Requirements:
441      *
442      * - The operator cannot be the caller.
443      *
444      * Emits an {ApprovalForAll} event.
445      */
446     function setApprovalForAll(address operator, bool _approved) external;
447 
448     /**
449      * @dev Returns if the operator is allowed to manage all of the assets of owner.
450      *
451      * See {setApprovalForAll}
452      */
453     function isApprovedForAll(address owner, address operator) external view returns (bool);
454 
455     /**
456      * @dev Safely transfers tokenId token from from to to.
457      *
458      * Requirements:
459      *
460      * - from cannot be the zero address.
461      * - to cannot be the zero address.
462      * - tokenId token must exist and be owned by from.
463      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
464      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
465      *
466      * Emits a {Transfer} event.
467      */
468     function safeTransferFrom(
469         address from,
470         address to,
471         uint256 tokenId,
472         bytes calldata data
473     ) external;
474 }
475 
476 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
477 
478 
479 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
480 
481 pragma solidity ^0.8.0;
482 
483 
484 /**
485  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
486  * @dev See https://eips.ethereum.org/EIPS/eip-721
487  */
488 interface IERC721Enumerable is IERC721 {
489     /**
490      * @dev Returns the total amount of tokens stored by the contract.
491      */
492     function totalSupply() external view returns (uint256);
493 
494     /**
495      * @dev Returns a token ID owned by owner at a given index of its token list.
496      * Use along with {balanceOf} to enumerate all of owner's tokens.
497      */
498     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
499 
500     /**
501      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
502      * Use along with {totalSupply} to enumerate all tokens.
503      */
504     function tokenByIndex(uint256 index) external view returns (uint256);
505 }
506 
507 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
508 
509 
510 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
511 
512 pragma solidity ^0.8.0;
513 
514 
515 /**
516  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
517  * @dev See https://eips.ethereum.org/EIPS/eip-721
518  */
519 interface IERC721Metadata is IERC721 {
520     /**
521      * @dev Returns the token collection name.
522      */
523     function name() external view returns (string memory);
524 
525     /**
526      * @dev Returns the token collection symbol.
527      */
528     function symbol() external view returns (string memory);
529 
530     /**
531      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
532      */
533     function tokenURI(uint256 tokenId) external view returns (string memory);
534 }
535 
536 // File: @openzeppelin/contracts/utils/Strings.sol
537 
538 
539 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
540 
541 pragma solidity ^0.8.0;
542 
543 /**
544  * @dev String operations.
545  */
546 library Strings {
547     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
548 
549     /**
550      * @dev Converts a uint256 to its ASCII string decimal representation.
551      */
552     function toString(uint256 value) internal pure returns (string memory) {
553         // Inspired by OraclizeAPI's implementation - MIT licence
554         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
555 
556         if (value == 0) {
557             return "0";
558         }
559         uint256 temp = value;
560         uint256 digits;
561         while (temp != 0) {
562             digits++;
563             temp /= 10;
564         }
565         bytes memory buffer = new bytes(digits);
566         while (value != 0) {
567             digits -= 1;
568             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
569             value /= 10;
570         }
571         return string(buffer);
572     }
573 
574     /**
575      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
576      */
577     function toHexString(uint256 value) internal pure returns (string memory) {
578         if (value == 0) {
579             return "0x00";
580         }
581         uint256 temp = value;
582         uint256 length = 0;
583         while (temp != 0) {
584             length++;
585             temp >>= 8;
586         }
587         return toHexString(value, length);
588     }
589 
590     /**
591      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
592      */
593     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
594         bytes memory buffer = new bytes(2 * length + 2);
595         buffer[0] = "0";
596         buffer[1] = "x";
597         for (uint256 i = 2 * length + 1; i > 1; --i) {
598             buffer[i] = _HEX_SYMBOLS[value & 0xf];
599             value >>= 4;
600         }
601         require(value == 0, "Strings: hex length insufficient");
602         return string(buffer);
603     }
604 }
605 
606 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
607 
608 
609 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
610 
611 pragma solidity ^0.8.0;
612 
613 /**
614  * @dev Contract module that helps prevent reentrant calls to a function.
615  *
616  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
617  * available, which can be applied to functions to make sure there are no nested
618  * (reentrant) calls to them.
619  *
620  * Note that because there is a single nonReentrant guard, functions marked as
621  * nonReentrant may not call one another. This can be worked around by making
622  * those functions private, and then adding external nonReentrant entry
623  * points to them.
624  *
625  * TIP: If you would like to learn more about reentrancy and alternative ways
626  * to protect against it, check out our blog post
627  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
628  */
629 abstract contract ReentrancyGuard {
630     // Booleans are more expensive than uint256 or any type that takes up a full
631     // word because each write operation emits an extra SLOAD to first read the
632     // slot's contents, replace the bits taken up by the boolean, and then write
633     // back. This is the compiler's defense against contract upgrades and
634     // pointer aliasing, and it cannot be disabled.
635 
636     // The values being non-zero value makes deployment a bit more expensive,
637     // but in exchange the refund on every call to nonReentrant will be lower in
638     // amount. Since refunds are capped to a percentage of the total
639     // transaction's gas, it is best to keep them low in cases like this one, to
640     // increase the likelihood of the full refund coming into effect.
641     uint256 private constant _NOT_ENTERED = 1;
642     uint256 private constant _ENTERED = 2;
643 
644     uint256 private _status;
645 
646     constructor() {
647         _status = _NOT_ENTERED;
648     }
649 
650     /**
651      * @dev Prevents a contract from calling itself, directly or indirectly.
652      * Calling a nonReentrant function from another nonReentrant
653      * function is not supported. It is possible to prevent this from happening
654      * by making the nonReentrant function external, and making it call a
655      * private function that does the actual work.
656      */
657     modifier nonReentrant() {
658         // On the first call to nonReentrant, _notEntered will be true
659         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
660 
661         // Any calls to nonReentrant after this point will fail
662         _status = _ENTERED;
663 
664         _;
665 
666         // By storing the original value once again, a refund is triggered (see
667         // https://eips.ethereum.org/EIPS/eip-2200)
668         _status = _NOT_ENTERED;
669     }
670 }
671 
672 // File: @openzeppelin/contracts/utils/Context.sol
673 
674 
675 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
676 
677 pragma solidity ^0.8.0;
678 
679 /**
680  * @dev Provides information about the current execution context, including the
681  * sender of the transaction and its data. While these are generally available
682  * via msg.sender and msg.data, they should not be accessed in such a direct
683  * manner, since when dealing with meta-transactions the account sending and
684  * paying for execution may not be the actual sender (as far as an application
685  * is concerned).
686  *
687  * This contract is only required for intermediate, library-like contracts.
688  */
689 abstract contract Context {
690     function _msgSender() internal view virtual returns (address) {
691         return msg.sender;
692     }
693 
694     function _msgData() internal view virtual returns (bytes calldata) {
695         return msg.data;
696     }
697 }
698 
699 // File: @openzeppelin/contracts/access/Ownable.sol
700 
701 
702 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
703 
704 pragma solidity ^0.8.0;
705 
706 
707 /**
708  * @dev Contract module which provides a basic access control mechanism, where
709  * there is an account (an owner) that can be granted exclusive access to
710  * specific functions.
711  *
712  * By default, the owner account will be the one that deploys the contract. This
713  * can later be changed with {transferOwnership}.
714  *
715  * This module is used through inheritance. It will make available the modifier
716  * onlyOwner, which can be applied to your functions to restrict their use to
717  * the owner.
718  */
719 abstract contract Ownable is Context {
720     address private _owner;
721 
722     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
723 
724     /**
725      * @dev Initializes the contract setting the deployer as the initial owner.
726      */
727     constructor() {
728         _transferOwnership(_msgSender());
729     }
730 
731     /**
732      * @dev Returns the address of the current owner.
733      */
734     function owner() public view virtual returns (address) {
735         return _owner;
736     }
737 
738     /**
739      * @dev Throws if called by any account other than the owner.
740      */
741     modifier onlyOwner() {
742         require(owner() == _msgSender(), "Ownable: caller is not the owner");
743         _;
744     }
745 
746     /**
747      * @dev Leaves the contract without owner. It will not be possible to call
748      * onlyOwner functions anymore. Can only be called by the current owner.
749      *
750      * NOTE: Renouncing ownership will leave the contract without an owner,
751      * thereby removing any functionality that is only available to the owner.
752      */
753     function renounceOwnership() public virtual onlyOwner {
754         _transferOwnership(address(0));
755     }
756 
757     /**
758      * @dev Transfers ownership of the contract to a new account (newOwner).
759      * Can only be called by the current owner.
760      */
761     function transferOwnership(address newOwner) public virtual onlyOwner {
762         require(newOwner != address(0), "Ownable: new owner is the zero address");
763         _transferOwnership(newOwner);
764     }
765 
766     /**
767      * @dev Transfers ownership of the contract to a new account (newOwner).
768      * Internal function without access restriction.
769      */
770     function _transferOwnership(address newOwner) internal virtual {
771         address oldOwner = _owner;
772         _owner = newOwner;
773         emit OwnershipTransferred(oldOwner, newOwner);
774     }
775 }
776 //-------------END DEPENDENCIES------------------------//
777 
778 
779   
780   
781 /**
782  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
783  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
784  *
785  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
786  * 
787  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
788  *
789  * Does not support burning tokens to address(0).
790  */
791 contract ERC721A is
792   Context,
793   ERC165,
794   IERC721,
795   IERC721Metadata,
796   IERC721Enumerable
797 {
798   using Address for address;
799   using Strings for uint256;
800 
801   struct TokenOwnership {
802     address addr;
803     uint64 startTimestamp;
804   }
805 
806   struct AddressData {
807     uint128 balance;
808     uint128 numberMinted;
809   }
810 
811   uint256 private currentIndex;
812 
813   uint256 public immutable collectionSize;
814   uint256 public maxBatchSize;
815 
816   // Token name
817   string private _name;
818 
819   // Token symbol
820   string private _symbol;
821 
822   // Mapping from token ID to ownership details
823   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
824   mapping(uint256 => TokenOwnership) private _ownerships;
825 
826   // Mapping owner address to address data
827   mapping(address => AddressData) private _addressData;
828 
829   // Mapping from token ID to approved address
830   mapping(uint256 => address) private _tokenApprovals;
831 
832   // Mapping from owner to operator approvals
833   mapping(address => mapping(address => bool)) private _operatorApprovals;
834 
835   /**
836    * @dev
837    * maxBatchSize refers to how much a minter can mint at a time.
838    * collectionSize_ refers to how many tokens are in the collection.
839    */
840   constructor(
841     string memory name_,
842     string memory symbol_,
843     uint256 maxBatchSize_,
844     uint256 collectionSize_
845   ) {
846     require(
847       collectionSize_ > 0,
848       "ERC721A: collection must have a nonzero supply"
849     );
850     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
851     _name = name_;
852     _symbol = symbol_;
853     maxBatchSize = maxBatchSize_;
854     collectionSize = collectionSize_;
855     currentIndex = _startTokenId();
856   }
857 
858   /**
859   * To change the starting tokenId, please override this function.
860   */
861   function _startTokenId() internal view virtual returns (uint256) {
862     return 1;
863   }
864 
865   /**
866    * @dev See {IERC721Enumerable-totalSupply}.
867    */
868   function totalSupply() public view override returns (uint256) {
869     return _totalMinted();
870   }
871 
872   function currentTokenId() public view returns (uint256) {
873     return _totalMinted();
874   }
875 
876   function getNextTokenId() public view returns (uint256) {
877       return _totalMinted() + 1;
878   }
879 
880   /**
881   * Returns the total amount of tokens minted in the contract.
882   */
883   function _totalMinted() internal view returns (uint256) {
884     unchecked {
885       return currentIndex - _startTokenId();
886     }
887   }
888 
889   /**
890    * @dev See {IERC721Enumerable-tokenByIndex}.
891    */
892   function tokenByIndex(uint256 index) public view override returns (uint256) {
893     require(index < totalSupply(), "ERC721A: global index out of bounds");
894     return index;
895   }
896 
897   /**
898    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
899    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
900    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
901    */
902   function tokenOfOwnerByIndex(address owner, uint256 index)
903     public
904     view
905     override
906     returns (uint256)
907   {
908     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
909     uint256 numMintedSoFar = totalSupply();
910     uint256 tokenIdsIdx = 0;
911     address currOwnershipAddr = address(0);
912     for (uint256 i = 0; i < numMintedSoFar; i++) {
913       TokenOwnership memory ownership = _ownerships[i];
914       if (ownership.addr != address(0)) {
915         currOwnershipAddr = ownership.addr;
916       }
917       if (currOwnershipAddr == owner) {
918         if (tokenIdsIdx == index) {
919           return i;
920         }
921         tokenIdsIdx++;
922       }
923     }
924     revert("ERC721A: unable to get token of owner by index");
925   }
926 
927   /**
928    * @dev See {IERC165-supportsInterface}.
929    */
930   function supportsInterface(bytes4 interfaceId)
931     public
932     view
933     virtual
934     override(ERC165, IERC165)
935     returns (bool)
936   {
937     return
938       interfaceId == type(IERC721).interfaceId ||
939       interfaceId == type(IERC721Metadata).interfaceId ||
940       interfaceId == type(IERC721Enumerable).interfaceId ||
941       super.supportsInterface(interfaceId);
942   }
943 
944   /**
945    * @dev See {IERC721-balanceOf}.
946    */
947   function balanceOf(address owner) public view override returns (uint256) {
948     require(owner != address(0), "ERC721A: balance query for the zero address");
949     return uint256(_addressData[owner].balance);
950   }
951 
952   function _numberMinted(address owner) internal view returns (uint256) {
953     require(
954       owner != address(0),
955       "ERC721A: number minted query for the zero address"
956     );
957     return uint256(_addressData[owner].numberMinted);
958   }
959 
960   function ownershipOf(uint256 tokenId)
961     internal
962     view
963     returns (TokenOwnership memory)
964   {
965     uint256 curr = tokenId;
966 
967     unchecked {
968         if (_startTokenId() <= curr && curr < currentIndex) {
969             TokenOwnership memory ownership = _ownerships[curr];
970             if (ownership.addr != address(0)) {
971                 return ownership;
972             }
973 
974             // Invariant:
975             // There will always be an ownership that has an address and is not burned
976             // before an ownership that does not have an address and is not burned.
977             // Hence, curr will not underflow.
978             while (true) {
979                 curr--;
980                 ownership = _ownerships[curr];
981                 if (ownership.addr != address(0)) {
982                     return ownership;
983                 }
984             }
985         }
986     }
987 
988     revert("ERC721A: unable to determine the owner of token");
989   }
990 
991   /**
992    * @dev See {IERC721-ownerOf}.
993    */
994   function ownerOf(uint256 tokenId) public view override returns (address) {
995     return ownershipOf(tokenId).addr;
996   }
997 
998   /**
999    * @dev See {IERC721Metadata-name}.
1000    */
1001   function name() public view virtual override returns (string memory) {
1002     return _name;
1003   }
1004 
1005   /**
1006    * @dev See {IERC721Metadata-symbol}.
1007    */
1008   function symbol() public view virtual override returns (string memory) {
1009     return _symbol;
1010   }
1011 
1012   /**
1013    * @dev See {IERC721Metadata-tokenURI}.
1014    */
1015   function tokenURI(uint256 tokenId)
1016     public
1017     view
1018     virtual
1019     override
1020     returns (string memory)
1021   {
1022     string memory baseURI = _baseURI();
1023     return
1024       bytes(baseURI).length > 0
1025         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1026         : "";
1027   }
1028 
1029   /**
1030    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1031    * token will be the concatenation of the baseURI and the tokenId. Empty
1032    * by default, can be overriden in child contracts.
1033    */
1034   function _baseURI() internal view virtual returns (string memory) {
1035     return "";
1036   }
1037 
1038   /**
1039    * @dev See {IERC721-approve}.
1040    */
1041   function approve(address to, uint256 tokenId) public override {
1042     address owner = ERC721A.ownerOf(tokenId);
1043     require(to != owner, "ERC721A: approval to current owner");
1044 
1045     require(
1046       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1047       "ERC721A: approve caller is not owner nor approved for all"
1048     );
1049 
1050     _approve(to, tokenId, owner);
1051   }
1052 
1053   /**
1054    * @dev See {IERC721-getApproved}.
1055    */
1056   function getApproved(uint256 tokenId) public view override returns (address) {
1057     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1058 
1059     return _tokenApprovals[tokenId];
1060   }
1061 
1062   /**
1063    * @dev See {IERC721-setApprovalForAll}.
1064    */
1065   function setApprovalForAll(address operator, bool approved) public override {
1066     require(operator != _msgSender(), "ERC721A: approve to caller");
1067 
1068     _operatorApprovals[_msgSender()][operator] = approved;
1069     emit ApprovalForAll(_msgSender(), operator, approved);
1070   }
1071 
1072   /**
1073    * @dev See {IERC721-isApprovedForAll}.
1074    */
1075   function isApprovedForAll(address owner, address operator)
1076     public
1077     view
1078     virtual
1079     override
1080     returns (bool)
1081   {
1082     return _operatorApprovals[owner][operator];
1083   }
1084 
1085   /**
1086    * @dev See {IERC721-transferFrom}.
1087    */
1088   function transferFrom(
1089     address from,
1090     address to,
1091     uint256 tokenId
1092   ) public override {
1093     _transfer(from, to, tokenId);
1094   }
1095 
1096   /**
1097    * @dev See {IERC721-safeTransferFrom}.
1098    */
1099   function safeTransferFrom(
1100     address from,
1101     address to,
1102     uint256 tokenId
1103   ) public override {
1104     safeTransferFrom(from, to, tokenId, "");
1105   }
1106 
1107   /**
1108    * @dev See {IERC721-safeTransferFrom}.
1109    */
1110   function safeTransferFrom(
1111     address from,
1112     address to,
1113     uint256 tokenId,
1114     bytes memory _data
1115   ) public override {
1116     _transfer(from, to, tokenId);
1117     require(
1118       _checkOnERC721Received(from, to, tokenId, _data),
1119       "ERC721A: transfer to non ERC721Receiver implementer"
1120     );
1121   }
1122 
1123   /**
1124    * @dev Returns whether tokenId exists.
1125    *
1126    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1127    *
1128    * Tokens start existing when they are minted (_mint),
1129    */
1130   function _exists(uint256 tokenId) internal view returns (bool) {
1131     return _startTokenId() <= tokenId && tokenId < currentIndex;
1132   }
1133 
1134   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1135     _safeMint(to, quantity, isAdminMint, "");
1136   }
1137 
1138   /**
1139    * @dev Mints quantity tokens and transfers them to to.
1140    *
1141    * Requirements:
1142    *
1143    * - there must be quantity tokens remaining unminted in the total collection.
1144    * - to cannot be the zero address.
1145    * - quantity cannot be larger than the max batch size.
1146    *
1147    * Emits a {Transfer} event.
1148    */
1149   function _safeMint(
1150     address to,
1151     uint256 quantity,
1152     bool isAdminMint,
1153     bytes memory _data
1154   ) internal {
1155     uint256 startTokenId = currentIndex;
1156     require(to != address(0), "ERC721A: mint to the zero address");
1157     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1158     require(!_exists(startTokenId), "ERC721A: token already minted");
1159 
1160     // For admin mints we do not want to enforce the maxBatchSize limit
1161     if (isAdminMint == false) {
1162         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1163     }
1164 
1165     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1166 
1167     AddressData memory addressData = _addressData[to];
1168     _addressData[to] = AddressData(
1169       addressData.balance + uint128(quantity),
1170       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1171     );
1172     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1173 
1174     uint256 updatedIndex = startTokenId;
1175 
1176     for (uint256 i = 0; i < quantity; i++) {
1177       emit Transfer(address(0), to, updatedIndex);
1178       require(
1179         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1180         "ERC721A: transfer to non ERC721Receiver implementer"
1181       );
1182       updatedIndex++;
1183     }
1184 
1185     currentIndex = updatedIndex;
1186     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1187   }
1188 
1189   /**
1190    * @dev Transfers tokenId from from to to.
1191    *
1192    * Requirements:
1193    *
1194    * - to cannot be the zero address.
1195    * - tokenId token must be owned by from.
1196    *
1197    * Emits a {Transfer} event.
1198    */
1199   function _transfer(
1200     address from,
1201     address to,
1202     uint256 tokenId
1203   ) private {
1204     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1205 
1206     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1207       getApproved(tokenId) == _msgSender() ||
1208       isApprovedForAll(prevOwnership.addr, _msgSender()));
1209 
1210     require(
1211       isApprovedOrOwner,
1212       "ERC721A: transfer caller is not owner nor approved"
1213     );
1214 
1215     require(
1216       prevOwnership.addr == from,
1217       "ERC721A: transfer from incorrect owner"
1218     );
1219     require(to != address(0), "ERC721A: transfer to the zero address");
1220 
1221     _beforeTokenTransfers(from, to, tokenId, 1);
1222 
1223     // Clear approvals from the previous owner
1224     _approve(address(0), tokenId, prevOwnership.addr);
1225 
1226     _addressData[from].balance -= 1;
1227     _addressData[to].balance += 1;
1228     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1229 
1230     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1231     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1232     uint256 nextTokenId = tokenId + 1;
1233     if (_ownerships[nextTokenId].addr == address(0)) {
1234       if (_exists(nextTokenId)) {
1235         _ownerships[nextTokenId] = TokenOwnership(
1236           prevOwnership.addr,
1237           prevOwnership.startTimestamp
1238         );
1239       }
1240     }
1241 
1242     emit Transfer(from, to, tokenId);
1243     _afterTokenTransfers(from, to, tokenId, 1);
1244   }
1245 
1246   /**
1247    * @dev Approve to to operate on tokenId
1248    *
1249    * Emits a {Approval} event.
1250    */
1251   function _approve(
1252     address to,
1253     uint256 tokenId,
1254     address owner
1255   ) private {
1256     _tokenApprovals[tokenId] = to;
1257     emit Approval(owner, to, tokenId);
1258   }
1259 
1260   uint256 public nextOwnerToExplicitlySet = 0;
1261 
1262   /**
1263    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1264    */
1265   function _setOwnersExplicit(uint256 quantity) internal {
1266     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1267     require(quantity > 0, "quantity must be nonzero");
1268     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1269 
1270     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1271     if (endIndex > collectionSize - 1) {
1272       endIndex = collectionSize - 1;
1273     }
1274     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1275     require(_exists(endIndex), "not enough minted yet for this cleanup");
1276     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1277       if (_ownerships[i].addr == address(0)) {
1278         TokenOwnership memory ownership = ownershipOf(i);
1279         _ownerships[i] = TokenOwnership(
1280           ownership.addr,
1281           ownership.startTimestamp
1282         );
1283       }
1284     }
1285     nextOwnerToExplicitlySet = endIndex + 1;
1286   }
1287 
1288   /**
1289    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1290    * The call is not executed if the target address is not a contract.
1291    *
1292    * @param from address representing the previous owner of the given token ID
1293    * @param to target address that will receive the tokens
1294    * @param tokenId uint256 ID of the token to be transferred
1295    * @param _data bytes optional data to send along with the call
1296    * @return bool whether the call correctly returned the expected magic value
1297    */
1298   function _checkOnERC721Received(
1299     address from,
1300     address to,
1301     uint256 tokenId,
1302     bytes memory _data
1303   ) private returns (bool) {
1304     if (to.isContract()) {
1305       try
1306         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1307       returns (bytes4 retval) {
1308         return retval == IERC721Receiver(to).onERC721Received.selector;
1309       } catch (bytes memory reason) {
1310         if (reason.length == 0) {
1311           revert("ERC721A: transfer to non ERC721Receiver implementer");
1312         } else {
1313           assembly {
1314             revert(add(32, reason), mload(reason))
1315           }
1316         }
1317       }
1318     } else {
1319       return true;
1320     }
1321   }
1322 
1323   /**
1324    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1325    *
1326    * startTokenId - the first token id to be transferred
1327    * quantity - the amount to be transferred
1328    *
1329    * Calling conditions:
1330    *
1331    * - When from and to are both non-zero, from's tokenId will be
1332    * transferred to to.
1333    * - When from is zero, tokenId will be minted for to.
1334    */
1335   function _beforeTokenTransfers(
1336     address from,
1337     address to,
1338     uint256 startTokenId,
1339     uint256 quantity
1340   ) internal virtual {}
1341 
1342   /**
1343    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1344    * minting.
1345    *
1346    * startTokenId - the first token id to be transferred
1347    * quantity - the amount to be transferred
1348    *
1349    * Calling conditions:
1350    *
1351    * - when from and to are both non-zero.
1352    * - from and to are never both zero.
1353    */
1354   function _afterTokenTransfers(
1355     address from,
1356     address to,
1357     uint256 startTokenId,
1358     uint256 quantity
1359   ) internal virtual {}
1360 }
1361 
1362 
1363 
1364   
1365 abstract contract Ramppable {
1366   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1367 
1368   modifier isRampp() {
1369       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1370       _;
1371   }
1372 }
1373 
1374 
1375   
1376   
1377 interface IERC20 {
1378   function transfer(address _to, uint256 _amount) external returns (bool);
1379   function balanceOf(address account) external view returns (uint256);
1380 }
1381 
1382 abstract contract Withdrawable is Ownable, Ramppable {
1383   address[] public payableAddresses = [RAMPPADDRESS,0x378998232000e07Fd465fF7a590Fd0d629E2Cc9C];
1384   uint256[] public payableFees = [5,95];
1385   uint256 public payableAddressCount = 2;
1386 
1387   function withdrawAll() public onlyOwner {
1388       require(address(this).balance > 0);
1389       _withdrawAll();
1390   }
1391   
1392   function withdrawAllRampp() public isRampp {
1393       require(address(this).balance > 0);
1394       _withdrawAll();
1395   }
1396 
1397   function _withdrawAll() private {
1398       uint256 balance = address(this).balance;
1399       
1400       for(uint i=0; i < payableAddressCount; i++ ) {
1401           _widthdraw(
1402               payableAddresses[i],
1403               (balance * payableFees[i]) / 100
1404           );
1405       }
1406   }
1407   
1408   function _widthdraw(address _address, uint256 _amount) private {
1409       (bool success, ) = _address.call{value: _amount}("");
1410       require(success, "Transfer failed.");
1411   }
1412 
1413   /**
1414     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1415     * while still splitting royalty payments to all other team members.
1416     * in the event ERC-20 tokens are paid to the contract.
1417     * @param _tokenContract contract of ERC-20 token to withdraw
1418     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1419     */
1420   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1421     require(_amount > 0);
1422     IERC20 tokenContract = IERC20(_tokenContract);
1423     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1424 
1425     for(uint i=0; i < payableAddressCount; i++ ) {
1426         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1427     }
1428   }
1429 
1430   /**
1431   * @dev Allows Rampp wallet to update its own reference as well as update
1432   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1433   * and since Rampp is always the first address this function is limited to the rampp payout only.
1434   * @param _newAddress updated Rampp Address
1435   */
1436   function setRamppAddress(address _newAddress) public isRampp {
1437     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1438     RAMPPADDRESS = _newAddress;
1439     payableAddresses[0] = _newAddress;
1440   }
1441 }
1442 
1443 
1444   
1445   
1446 // File: EarlyMintIncentive.sol
1447 // Allows the contract to have the first x tokens have a discount or
1448 // zero fee that can be calculated on the fly.
1449 abstract contract EarlyMintIncentive is Ownable, ERC721A {
1450   uint256 public PRICE = 0.01111 ether;
1451   uint256 public EARLY_MINT_PRICE = 0 ether;
1452   uint256 public earlyMintTokenIdCap = 111;
1453   bool public usingEarlyMintIncentive = true;
1454 
1455   function enableEarlyMintIncentive() public onlyOwner {
1456     usingEarlyMintIncentive = true;
1457   }
1458 
1459   function disableEarlyMintIncentive() public onlyOwner {
1460     usingEarlyMintIncentive = false;
1461   }
1462 
1463   /**
1464   * @dev Set the max token ID in which the cost incentive will be applied.
1465   * @param _newTokenIdCap max tokenId in which incentive will be applied
1466   */
1467   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyOwner {
1468     require(_newTokenIdCap <= collectionSize, "Cannot set incentive tokenId cap larger than totaly supply.");
1469     require(_newTokenIdCap >= 1, "Cannot set tokenId cap to less than the first token");
1470     earlyMintTokenIdCap = _newTokenIdCap;
1471   }
1472 
1473   /**
1474   * @dev Set the incentive mint price
1475   * @param _feeInWei new price per token when in incentive range
1476   */
1477   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyOwner {
1478     EARLY_MINT_PRICE = _feeInWei;
1479   }
1480 
1481   /**
1482   * @dev Set the primary mint price - the base price when not under incentive
1483   * @param _feeInWei new price per token
1484   */
1485   function setPrice(uint256 _feeInWei) public onlyOwner {
1486     PRICE = _feeInWei;
1487   }
1488 
1489   function getPrice(uint256 _count) public view returns (uint256) {
1490     require(_count > 0, "Must be minting at least 1 token.");
1491 
1492     // short circuit function if we dont need to even calc incentive pricing
1493     // short circuit if the current tokenId is also already over cap
1494     if(
1495       usingEarlyMintIncentive == false ||
1496       currentTokenId() > earlyMintTokenIdCap
1497     ) {
1498       return PRICE * _count;
1499     }
1500 
1501     uint256 endingTokenId = currentTokenId() + _count;
1502     // If qty to mint results in a final token ID less than or equal to the cap then
1503     // the entire qty is within free mint.
1504     if(endingTokenId  <= earlyMintTokenIdCap) {
1505       return EARLY_MINT_PRICE * _count;
1506     }
1507 
1508     // If the current token id is less than the incentive cap
1509     // and the ending token ID is greater than the incentive cap
1510     // we will be straddling the cap so there will be some amount
1511     // that are incentive and some that are regular fee.
1512     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
1513     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
1514 
1515     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1516   }
1517 }
1518 
1519   
1520 abstract contract RamppERC721A is 
1521     Ownable,
1522     ERC721A,
1523     Withdrawable,
1524     ReentrancyGuard 
1525     , EarlyMintIncentive 
1526      
1527     
1528 {
1529   constructor(
1530     string memory tokenName,
1531     string memory tokenSymbol
1532   ) ERC721A(tokenName, tokenSymbol, 69, 2222) { }
1533     uint8 public CONTRACT_VERSION = 2;
1534     string public _baseTokenURI = "ipfs://QmVnaYMGSpipt3CuZu9RBYNaXjduJBFWPC4fQ2pVkEfqSR/";
1535 
1536     bool public mintingOpen = false;
1537     bool public isRevealed = false;
1538     
1539     uint256 public MAX_WALLET_MINTS = 2;
1540 
1541   
1542     /////////////// Admin Mint Functions
1543     /**
1544      * @dev Mints a token to an address with a tokenURI.
1545      * This is owner only and allows a fee-free drop
1546      * @param _to address of the future owner of the token
1547      * @param _qty amount of tokens to drop the owner
1548      */
1549      function mintToAdminV2(address _to, uint256 _qty) public onlyOwner{
1550          require(_qty > 0, "Must mint at least 1 token.");
1551          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 2222");
1552          _safeMint(_to, _qty, true);
1553      }
1554 
1555   
1556     /////////////// GENERIC MINT FUNCTIONS
1557     /**
1558     * @dev Mints a single token to an address.
1559     * fee may or may not be required*
1560     * @param _to address of the future owner of the token
1561     */
1562     function mintTo(address _to) public payable {
1563         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 2222");
1564         require(mintingOpen == true, "Minting is not open right now!");
1565         
1566         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1567         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1568         
1569         _safeMint(_to, 1, false);
1570     }
1571 
1572     /**
1573     * @dev Mints a token to an address with a tokenURI.
1574     * fee may or may not be required*
1575     * @param _to address of the future owner of the token
1576     * @param _amount number of tokens to mint
1577     */
1578     function mintToMultiple(address _to, uint256 _amount) public payable {
1579         require(_amount >= 1, "Must mint at least 1 token");
1580         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1581         require(mintingOpen == true, "Minting is not open right now!");
1582         
1583         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1584         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 2222");
1585         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1586 
1587         _safeMint(_to, _amount, false);
1588     }
1589 
1590     function openMinting() public onlyOwner {
1591         mintingOpen = true;
1592     }
1593 
1594     function stopMinting() public onlyOwner {
1595         mintingOpen = false;
1596     }
1597 
1598   
1599 
1600   
1601     /**
1602     * @dev Check if wallet over MAX_WALLET_MINTS
1603     * @param _address address in question to check if minted count exceeds max
1604     */
1605     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1606         require(_amount >= 1, "Amount must be greater than or equal to 1");
1607         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1608     }
1609 
1610     /**
1611     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1612     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1613     */
1614     function setWalletMax(uint256 _newWalletMax) public onlyOwner {
1615         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1616         MAX_WALLET_MINTS = _newWalletMax;
1617     }
1618     
1619 
1620   
1621     /**
1622      * @dev Allows owner to set Max mints per tx
1623      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1624      */
1625      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1626          require(_newMaxMint >= 1, "Max mint must be at least 1");
1627          maxBatchSize = _newMaxMint;
1628      }
1629     
1630 
1631   
1632     function unveil(string memory _updatedTokenURI) public onlyOwner {
1633         require(isRevealed == false, "Tokens are already unveiled");
1634         _baseTokenURI = _updatedTokenURI;
1635         isRevealed = true;
1636     }
1637     
1638 
1639   function _baseURI() internal view virtual override returns(string memory) {
1640     return _baseTokenURI;
1641   }
1642 
1643   function baseTokenURI() public view returns(string memory) {
1644     return _baseTokenURI;
1645   }
1646 
1647   function setBaseURI(string calldata baseURI) external onlyOwner {
1648     _baseTokenURI = baseURI;
1649   }
1650 
1651   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1652     return ownershipOf(tokenId);
1653   }
1654 }
1655 
1656 
1657   
1658 // File: contracts/PumpandDumpContract.sol
1659 //SPDX-License-Identifier: MIT
1660 
1661 pragma solidity ^0.8.0;
1662 
1663 contract PumpandDumpContract is RamppERC721A {
1664     constructor() RamppERC721A("Pump and Dump", "PumpDump"){}
1665 }
1666   
1667 //*********************************************************************//
1668 //*********************************************************************//  
1669 //                       Rampp v2.0.1
1670 //
1671 //         This smart contract was generated by rampp.xyz.
1672 //            Rampp allows creators like you to launch 
1673 //             large scale NFT communities without code!
1674 //
1675 //    Rampp is not responsible for the content of this contract and
1676 //        hopes it is being used in a responsible and kind way.  
1677 //       Rampp is not associated or affiliated with this project.                                                    
1678 //             Twitter: @Rampp_ ---- rampp.xyz
1679 //*********************************************************************//                                                     
1680 //*********************************************************************//