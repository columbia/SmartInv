1 /**
2  
3 ██████╗░░█████╗░███╗░░██╗████████╗██╗░░██╗███████╗░█████╗░███╗░░██╗
4 ██╔══██╗██╔══██╗████╗░██║╚══██╔══╝██║░░██║██╔════╝██╔══██╗████╗░██║
5 ██████╔╝███████║██╔██╗██║░░░██║░░░███████║█████╗░░██║░░██║██╔██╗██║
6 ██╔═══╝░██╔══██║██║╚████║░░░██║░░░██╔══██║██╔══╝░░██║░░██║██║╚████║
7 ██║░░░░░██║░░██║██║░╚███║░░░██║░░░██║░░██║███████╗╚█████╔╝██║░╚███║
8 ╚═╝░░░░░╚═╝░░╚═╝╚═╝░░╚══╝░░░╚═╝░░░╚═╝░░╚═╝╚══════╝░╚════╝░╚═╝░░╚══╝
9 
10 ██████╗░██╗░░░██╗░██████╗██╗███╗░░██╗███████╗░██████╗░██████╗  ░█████╗░██╗░░░░░██╗░░░██╗██████╗░
11 ██╔══██╗██║░░░██║██╔════╝██║████╗░██║██╔════╝██╔════╝██╔════╝  ██╔══██╗██║░░░░░██║░░░██║██╔══██╗
12 ██████╦╝██║░░░██║╚█████╗░██║██╔██╗██║█████╗░░╚█████╗░╚█████╗░  ██║░░╚═╝██║░░░░░██║░░░██║██████╦╝
13 ██╔══██╗██║░░░██║░╚═══██╗██║██║╚████║██╔══╝░░░╚═══██╗░╚═══██╗  ██║░░██╗██║░░░░░██║░░░██║██╔══██╗
14 ██████╦╝╚██████╔╝██████╔╝██║██║░╚███║███████╗██████╔╝██████╔╝  ╚█████╔╝███████╗╚██████╔╝██████╦╝
15 ╚═════╝░░╚═════╝░╚═════╝░╚═╝╚═╝░░╚══╝╚══════╝╚═════╝░╚═════╝░  ░╚════╝░╚══════╝░╚═════╝░╚═════╝░                                                                                                                                                                                                              
16                                                                                                                                                                                                                                                                                                                                                                                                                                 
17 */
18 
19 
20 
21 // SPDX-License-Identifier: MIT
22 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev Provides information about the current execution context, including the
28  * sender of the transaction and its data. While these are generally available
29  * via msg.sender and msg.data, they should not be accessed in such a direct
30  * manner, since when dealing with meta-transactions the account sending and
31  * paying for execution may not be the actual sender (as far as an application
32  * is concerned).
33  *
34  * This contract is only required for intermediate, library-like contracts.
35  */
36 abstract contract Context {
37     function _msgSender() internal view virtual returns (address) {
38         return msg.sender;
39     }
40 
41     function _msgData() internal view virtual returns (bytes calldata) {
42         return msg.data;
43     }
44 }
45 
46 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
47 
48 pragma solidity ^0.8.0;
49 
50 /**
51  * @dev Interface of the ERC165 standard, as defined in the
52  * https://eips.ethereum.org/EIPS/eip-165[EIP].
53  *
54  * Implementers can declare support of contract interfaces, which can then be
55  * queried by others ({ERC165Checker}).
56  *
57  * For an implementation, see {ERC165}.
58  */
59 interface IERC165 {
60     /**
61      * @dev Returns true if this contract implements the interface defined by
62      * `interfaceId`. See the corresponding
63      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
64      * to learn more about how these ids are created.
65      *
66      * This function call must use less than 30 000 gas.
67      */
68     function supportsInterface(bytes4 interfaceId) external view returns (bool);
69 }
70 
71 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
72 
73 pragma solidity ^0.8.0;
74 
75 /**
76  * @dev Required interface of an ERC721 compliant contract.
77  */
78 interface IERC721 is IERC165 {
79     /**
80      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
83 
84     /**
85      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
86      */
87     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
88 
89     /**
90      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
91      */
92     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
93 
94     /**
95      * @dev Returns the number of tokens in ``owner``'s account.
96      */
97     function balanceOf(address owner) external view returns (uint256 balance);
98 
99     /**
100      * @dev Returns the owner of the `tokenId` token.
101      *
102      * Requirements:
103      *
104      * - `tokenId` must exist.
105      */
106     function ownerOf(uint256 tokenId) external view returns (address owner);
107 
108     /**
109      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
110      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
111      *
112      * Requirements:
113      *
114      * - `from` cannot be the zero address.
115      * - `to` cannot be the zero address.
116      * - `tokenId` token must exist and be owned by `from`.
117      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
118      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
119      *
120      * Emits a {Transfer} event.
121      */
122     function safeTransferFrom(
123         address from,
124         address to,
125         uint256 tokenId
126     ) external;
127 
128     /**
129      * @dev Transfers `tokenId` token from `from` to `to`.
130      *
131      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
132      *
133      * Requirements:
134      *
135      * - `from` cannot be the zero address.
136      * - `to` cannot be the zero address.
137      * - `tokenId` token must be owned by `from`.
138      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
139      *
140      * Emits a {Transfer} event.
141      */
142     function transferFrom(
143         address from,
144         address to,
145         uint256 tokenId
146     ) external;
147 
148     /**
149      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
150      * The approval is cleared when the token is transferred.
151      *
152      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
153      *
154      * Requirements:
155      *
156      * - The caller must own the token or be an approved operator.
157      * - `tokenId` must exist.
158      *
159      * Emits an {Approval} event.
160      */
161     function approve(address to, uint256 tokenId) external;
162 
163     /**
164      * @dev Returns the account approved for `tokenId` token.
165      *
166      * Requirements:
167      *
168      * - `tokenId` must exist.
169      */
170     function getApproved(uint256 tokenId) external view returns (address operator);
171 
172     /**
173      * @dev Approve or remove `operator` as an operator for the caller.
174      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
175      *
176      * Requirements:
177      *
178      * - The `operator` cannot be the caller.
179      *
180      * Emits an {ApprovalForAll} event.
181      */
182     function setApprovalForAll(address operator, bool _approved) external;
183 
184     /**
185      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
186      *
187      * See {setApprovalForAll}
188      */
189     function isApprovedForAll(address owner, address operator) external view returns (bool);
190 
191     /**
192      * @dev Safely transfers `tokenId` token from `from` to `to`.
193      *
194      * Requirements:
195      *
196      * - `from` cannot be the zero address.
197      * - `to` cannot be the zero address.
198      * - `tokenId` token must exist and be owned by `from`.
199      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
200      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
201      *
202      * Emits a {Transfer} event.
203      */
204     function safeTransferFrom(
205         address from,
206         address to,
207         uint256 tokenId,
208         bytes calldata data
209     ) external;
210 }
211 
212 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
213 
214 pragma solidity ^0.8.0;
215 
216 /**
217  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
218  * @dev See https://eips.ethereum.org/EIPS/eip-721
219  */
220 interface IERC721Metadata is IERC721 {
221     /**
222      * @dev Returns the token collection name.
223      */
224     function name() external view returns (string memory);
225 
226     /**
227      * @dev Returns the token collection symbol.
228      */
229     function symbol() external view returns (string memory);
230 
231     /**
232      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
233      */
234     function tokenURI(uint256 tokenId) external view returns (string memory);
235 }
236 
237 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
238 
239 pragma solidity ^0.8.0;
240 
241 /**
242  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
243  * @dev See https://eips.ethereum.org/EIPS/eip-721
244  */
245 interface IERC721Enumerable is IERC721 {
246     /**
247      * @dev Returns the total amount of tokens stored by the contract.
248      */
249     function totalSupply() external view returns (uint256);
250 
251     /**
252      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
253      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
254      */
255     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
256 
257     /**
258      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
259      * Use along with {totalSupply} to enumerate all tokens.
260      */
261     function tokenByIndex(uint256 index) external view returns (uint256);
262 }
263 
264 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
265 
266 pragma solidity ^0.8.0;
267 
268 /**
269  * @title ERC721 token receiver interface
270  * @dev Interface for any contract that wants to support safeTransfers
271  * from ERC721 asset contracts.
272  */
273 interface IERC721Receiver {
274     /**
275      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
276      * by `operator` from `from`, this function is called.
277      *
278      * It must return its Solidity selector to confirm the token transfer.
279      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
280      *
281      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
282      */
283     function onERC721Received(
284         address operator,
285         address from,
286         uint256 tokenId,
287         bytes calldata data
288     ) external returns (bytes4);
289 }
290 
291 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
292 
293 pragma solidity ^0.8.0;
294 
295 /**
296  * @dev Implementation of the {IERC165} interface.
297  *
298  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
299  * for the additional interface id that will be supported. For example:
300  *
301  * ```solidity
302  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
303  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
304  * }
305  * ```
306  *
307  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
308  */
309 abstract contract ERC165 is IERC165 {
310     /**
311      * @dev See {IERC165-supportsInterface}.
312      */
313     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
314         return interfaceId == type(IERC165).interfaceId;
315     }
316 }
317 
318 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
319 
320 pragma solidity ^0.8.0;
321 
322 // CAUTION
323 // This version of SafeMath should only be used with Solidity 0.8 or later,
324 // because it relies on the compiler's built in overflow checks.
325 
326 /**
327  * @dev Wrappers over Solidity's arithmetic operations.
328  *
329  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
330  * now has built in overflow checking.
331  */
332 library SafeMath {
333     /**
334      * @dev Returns the addition of two unsigned integers, with an overflow flag.
335      *
336      * _Available since v3.4._
337      */
338     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
339         unchecked {
340             uint256 c = a + b;
341             if (c < a) return (false, 0);
342             return (true, c);
343         }
344     }
345 
346     /**
347      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
348      *
349      * _Available since v3.4._
350      */
351     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
352         unchecked {
353             if (b > a) return (false, 0);
354             return (true, a - b);
355         }
356     }
357 
358     /**
359      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
360      *
361      * _Available since v3.4._
362      */
363     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
364         unchecked {
365             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
366             // benefit is lost if 'b' is also tested.
367             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
368             if (a == 0) return (true, 0);
369             uint256 c = a * b;
370             if (c / a != b) return (false, 0);
371             return (true, c);
372         }
373     }
374 
375     /**
376      * @dev Returns the division of two unsigned integers, with a division by zero flag.
377      *
378      * _Available since v3.4._
379      */
380     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
381         unchecked {
382             if (b == 0) return (false, 0);
383             return (true, a / b);
384         }
385     }
386 
387     /**
388      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
389      *
390      * _Available since v3.4._
391      */
392     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
393         unchecked {
394             if (b == 0) return (false, 0);
395             return (true, a % b);
396         }
397     }
398 
399     /**
400      * @dev Returns the addition of two unsigned integers, reverting on
401      * overflow.
402      *
403      * Counterpart to Solidity's `+` operator.
404      *
405      * Requirements:
406      *
407      * - Addition cannot overflow.
408      */
409     function add(uint256 a, uint256 b) internal pure returns (uint256) {
410         return a + b;
411     }
412 
413     /**
414      * @dev Returns the subtraction of two unsigned integers, reverting on
415      * overflow (when the result is negative).
416      *
417      * Counterpart to Solidity's `-` operator.
418      *
419      * Requirements:
420      *
421      * - Subtraction cannot overflow.
422      */
423     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
424         return a - b;
425     }
426 
427     /**
428      * @dev Returns the multiplication of two unsigned integers, reverting on
429      * overflow.
430      *
431      * Counterpart to Solidity's `*` operator.
432      *
433      * Requirements:
434      *
435      * - Multiplication cannot overflow.
436      */
437     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
438         return a * b;
439     }
440 
441     /**
442      * @dev Returns the integer division of two unsigned integers, reverting on
443      * division by zero. The result is rounded towards zero.
444      *
445      * Counterpart to Solidity's `/` operator.
446      *
447      * Requirements:
448      *
449      * - The divisor cannot be zero.
450      */
451     function div(uint256 a, uint256 b) internal pure returns (uint256) {
452         return a / b;
453     }
454 
455     /**
456      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
457      * reverting when dividing by zero.
458      *
459      * Counterpart to Solidity's `%` operator. This function uses a `revert`
460      * opcode (which leaves remaining gas untouched) while Solidity uses an
461      * invalid opcode to revert (consuming all remaining gas).
462      *
463      * Requirements:
464      *
465      * - The divisor cannot be zero.
466      */
467     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
468         return a % b;
469     }
470 
471     /**
472      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
473      * overflow (when the result is negative).
474      *
475      * CAUTION: This function is deprecated because it requires allocating memory for the error
476      * message unnecessarily. For custom revert reasons use {trySub}.
477      *
478      * Counterpart to Solidity's `-` operator.
479      *
480      * Requirements:
481      *
482      * - Subtraction cannot overflow.
483      */
484     function sub(
485         uint256 a,
486         uint256 b,
487         string memory errorMessage
488     ) internal pure returns (uint256) {
489         unchecked {
490             require(b <= a, errorMessage);
491             return a - b;
492         }
493     }
494 
495     /**
496      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
497      * division by zero. The result is rounded towards zero.
498      *
499      * Counterpart to Solidity's `/` operator. Note: this function uses a
500      * `revert` opcode (which leaves remaining gas untouched) while Solidity
501      * uses an invalid opcode to revert (consuming all remaining gas).
502      *
503      * Requirements:
504      *
505      * - The divisor cannot be zero.
506      */
507     function div(
508         uint256 a,
509         uint256 b,
510         string memory errorMessage
511     ) internal pure returns (uint256) {
512         unchecked {
513             require(b > 0, errorMessage);
514             return a / b;
515         }
516     }
517 
518     /**
519      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
520      * reverting with custom message when dividing by zero.
521      *
522      * CAUTION: This function is deprecated because it requires allocating memory for the error
523      * message unnecessarily. For custom revert reasons use {tryMod}.
524      *
525      * Counterpart to Solidity's `%` operator. This function uses a `revert`
526      * opcode (which leaves remaining gas untouched) while Solidity uses an
527      * invalid opcode to revert (consuming all remaining gas).
528      *
529      * Requirements:
530      *
531      * - The divisor cannot be zero.
532      */
533     function mod(
534         uint256 a,
535         uint256 b,
536         string memory errorMessage
537     ) internal pure returns (uint256) {
538         unchecked {
539             require(b > 0, errorMessage);
540             return a % b;
541         }
542     }
543 }
544 
545 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
546 
547 pragma solidity ^0.8.0;
548 
549 /**
550  * @dev Collection of functions related to the address type
551  */
552 library Address {
553     /**
554      * @dev Returns true if `account` is a contract.
555      *
556      * [IMPORTANT]
557      * ====
558      * It is unsafe to assume that an address for which this function returns
559      * false is an externally-owned account (EOA) and not a contract.
560      *
561      * Among others, `isContract` will return false for the following
562      * types of addresses:
563      *
564      *  - an externally-owned account
565      *  - a contract in construction
566      *  - an address where a contract will be created
567      *  - an address where a contract lived, but was destroyed
568      * ====
569      *
570      * [IMPORTANT]
571      * ====
572      * You shouldn't rely on `isContract` to protect against flash loan attacks!
573      *
574      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
575      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
576      * constructor.
577      * ====
578      */
579     function isContract(address account) internal view returns (bool) {
580         // This method relies on extcodesize/address.code.length, which returns 0
581         // for contracts in construction, since the code is only stored at the end
582         // of the constructor execution.
583 
584         return account.code.length > 0;
585     }
586 
587     /**
588      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
589      * `recipient`, forwarding all available gas and reverting on errors.
590      *
591      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
592      * of certain opcodes, possibly making contracts go over the 2300 gas limit
593      * imposed by `transfer`, making them unable to receive funds via
594      * `transfer`. {sendValue} removes this limitation.
595      *
596      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
597      *
598      * IMPORTANT: because control is transferred to `recipient`, care must be
599      * taken to not create reentrancy vulnerabilities. Consider using
600      * {ReentrancyGuard} or the
601      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
602      */
603     function sendValue(address payable recipient, uint256 amount) internal {
604         require(address(this).balance >= amount, "Address: insufficient balance");
605 
606         (bool success, ) = recipient.call{value: amount}("");
607         require(success, "Address: unable to send value, recipient may have reverted");
608     }
609 
610     /**
611      * @dev Performs a Solidity function call using a low level `call`. A
612      * plain `call` is an unsafe replacement for a function call: use this
613      * function instead.
614      *
615      * If `target` reverts with a revert reason, it is bubbled up by this
616      * function (like regular Solidity function calls).
617      *
618      * Returns the raw returned data. To convert to the expected return value,
619      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
620      *
621      * Requirements:
622      *
623      * - `target` must be a contract.
624      * - calling `target` with `data` must not revert.
625      *
626      * _Available since v3.1._
627      */
628     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
629         return functionCall(target, data, "Address: low-level call failed");
630     }
631 
632     /**
633      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
634      * `errorMessage` as a fallback revert reason when `target` reverts.
635      *
636      * _Available since v3.1._
637      */
638     function functionCall(
639         address target,
640         bytes memory data,
641         string memory errorMessage
642     ) internal returns (bytes memory) {
643         return functionCallWithValue(target, data, 0, errorMessage);
644     }
645 
646     /**
647      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
648      * but also transferring `value` wei to `target`.
649      *
650      * Requirements:
651      *
652      * - the calling contract must have an ETH balance of at least `value`.
653      * - the called Solidity function must be `payable`.
654      *
655      * _Available since v3.1._
656      */
657     function functionCallWithValue(
658         address target,
659         bytes memory data,
660         uint256 value
661     ) internal returns (bytes memory) {
662         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
663     }
664 
665     /**
666      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
667      * with `errorMessage` as a fallback revert reason when `target` reverts.
668      *
669      * _Available since v3.1._
670      */
671     function functionCallWithValue(
672         address target,
673         bytes memory data,
674         uint256 value,
675         string memory errorMessage
676     ) internal returns (bytes memory) {
677         require(address(this).balance >= value, "Address: insufficient balance for call");
678         require(isContract(target), "Address: call to non-contract");
679 
680         (bool success, bytes memory returndata) = target.call{value: value}(data);
681         return verifyCallResult(success, returndata, errorMessage);
682     }
683 
684     /**
685      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
686      * but performing a static call.
687      *
688      * _Available since v3.3._
689      */
690     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
691         return functionStaticCall(target, data, "Address: low-level static call failed");
692     }
693 
694     /**
695      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
696      * but performing a static call.
697      *
698      * _Available since v3.3._
699      */
700     function functionStaticCall(
701         address target,
702         bytes memory data,
703         string memory errorMessage
704     ) internal view returns (bytes memory) {
705         require(isContract(target), "Address: static call to non-contract");
706 
707         (bool success, bytes memory returndata) = target.staticcall(data);
708         return verifyCallResult(success, returndata, errorMessage);
709     }
710 
711     /**
712      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
713      * but performing a delegate call.
714      *
715      * _Available since v3.4._
716      */
717     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
718         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
719     }
720 
721     /**
722      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
723      * but performing a delegate call.
724      *
725      * _Available since v3.4._
726      */
727     function functionDelegateCall(
728         address target,
729         bytes memory data,
730         string memory errorMessage
731     ) internal returns (bytes memory) {
732         require(isContract(target), "Address: delegate call to non-contract");
733 
734         (bool success, bytes memory returndata) = target.delegatecall(data);
735         return verifyCallResult(success, returndata, errorMessage);
736     }
737 
738     /**
739      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
740      * revert reason using the provided one.
741      *
742      * _Available since v4.3._
743      */
744     function verifyCallResult(
745         bool success,
746         bytes memory returndata,
747         string memory errorMessage
748     ) internal pure returns (bytes memory) {
749         if (success) {
750             return returndata;
751         } else {
752             // Look for revert reason and bubble it up if present
753             if (returndata.length > 0) {
754                 // The easiest way to bubble the revert reason is using memory via assembly
755 
756                 assembly {
757                     let returndata_size := mload(returndata)
758                     revert(add(32, returndata), returndata_size)
759                 }
760             } else {
761                 revert(errorMessage);
762             }
763         }
764     }
765 }
766 
767 // OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)
768 
769 pragma solidity ^0.8.0;
770 
771 /**
772  * @dev Library for managing
773  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
774  * types.
775  *
776  * Sets have the following properties:
777  *
778  * - Elements are added, removed, and checked for existence in constant time
779  * (O(1)).
780  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
781  *
782  * ```
783  * contract Example {
784  *     // Add the library methods
785  *     using EnumerableSet for EnumerableSet.AddressSet;
786  *
787  *     // Declare a set state variable
788  *     EnumerableSet.AddressSet private mySet;
789  * }
790  * ```
791  *
792  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
793  * and `uint256` (`UintSet`) are supported.
794  */
795 library EnumerableSet {
796     // To implement this library for multiple types with as little code
797     // repetition as possible, we write it in terms of a generic Set type with
798     // bytes32 values.
799     // The Set implementation uses private functions, and user-facing
800     // implementations (such as AddressSet) are just wrappers around the
801     // underlying Set.
802     // This means that we can only create new EnumerableSets for types that fit
803     // in bytes32.
804 
805     struct Set {
806         // Storage of set values
807         bytes32[] _values;
808         // Position of the value in the `values` array, plus 1 because index 0
809         // means a value is not in the set.
810         mapping(bytes32 => uint256) _indexes;
811     }
812 
813     /**
814      * @dev Add a value to a set. O(1).
815      *
816      * Returns true if the value was added to the set, that is if it was not
817      * already present.
818      */
819     function _add(Set storage set, bytes32 value) private returns (bool) {
820         if (!_contains(set, value)) {
821             set._values.push(value);
822             // The value is stored at length-1, but we add 1 to all indexes
823             // and use 0 as a sentinel value
824             set._indexes[value] = set._values.length;
825             return true;
826         } else {
827             return false;
828         }
829     }
830 
831     /**
832      * @dev Removes a value from a set. O(1).
833      *
834      * Returns true if the value was removed from the set, that is if it was
835      * present.
836      */
837     function _remove(Set storage set, bytes32 value) private returns (bool) {
838         // We read and store the value's index to prevent multiple reads from the same storage slot
839         uint256 valueIndex = set._indexes[value];
840 
841         if (valueIndex != 0) {
842             // Equivalent to contains(set, value)
843             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
844             // the array, and then remove the last element (sometimes called as 'swap and pop').
845             // This modifies the order of the array, as noted in {at}.
846 
847             uint256 toDeleteIndex = valueIndex - 1;
848             uint256 lastIndex = set._values.length - 1;
849 
850             if (lastIndex != toDeleteIndex) {
851                 bytes32 lastvalue = set._values[lastIndex];
852 
853                 // Move the last value to the index where the value to delete is
854                 set._values[toDeleteIndex] = lastvalue;
855                 // Update the index for the moved value
856                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
857             }
858 
859             // Delete the slot where the moved value was stored
860             set._values.pop();
861 
862             // Delete the index for the deleted slot
863             delete set._indexes[value];
864 
865             return true;
866         } else {
867             return false;
868         }
869     }
870 
871     /**
872      * @dev Returns true if the value is in the set. O(1).
873      */
874     function _contains(Set storage set, bytes32 value) private view returns (bool) {
875         return set._indexes[value] != 0;
876     }
877 
878     /**
879      * @dev Returns the number of values on the set. O(1).
880      */
881     function _length(Set storage set) private view returns (uint256) {
882         return set._values.length;
883     }
884 
885     /**
886      * @dev Returns the value stored at position `index` in the set. O(1).
887      *
888      * Note that there are no guarantees on the ordering of values inside the
889      * array, and it may change when more values are added or removed.
890      *
891      * Requirements:
892      *
893      * - `index` must be strictly less than {length}.
894      */
895     function _at(Set storage set, uint256 index) private view returns (bytes32) {
896         return set._values[index];
897     }
898 
899     /**
900      * @dev Return the entire set in an array
901      *
902      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
903      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
904      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
905      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
906      */
907     function _values(Set storage set) private view returns (bytes32[] memory) {
908         return set._values;
909     }
910 
911     // Bytes32Set
912 
913     struct Bytes32Set {
914         Set _inner;
915     }
916 
917     /**
918      * @dev Add a value to a set. O(1).
919      *
920      * Returns true if the value was added to the set, that is if it was not
921      * already present.
922      */
923     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
924         return _add(set._inner, value);
925     }
926 
927     /**
928      * @dev Removes a value from a set. O(1).
929      *
930      * Returns true if the value was removed from the set, that is if it was
931      * present.
932      */
933     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
934         return _remove(set._inner, value);
935     }
936 
937     /**
938      * @dev Returns true if the value is in the set. O(1).
939      */
940     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
941         return _contains(set._inner, value);
942     }
943 
944     /**
945      * @dev Returns the number of values in the set. O(1).
946      */
947     function length(Bytes32Set storage set) internal view returns (uint256) {
948         return _length(set._inner);
949     }
950 
951     /**
952      * @dev Returns the value stored at position `index` in the set. O(1).
953      *
954      * Note that there are no guarantees on the ordering of values inside the
955      * array, and it may change when more values are added or removed.
956      *
957      * Requirements:
958      *
959      * - `index` must be strictly less than {length}.
960      */
961     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
962         return _at(set._inner, index);
963     }
964 
965     /**
966      * @dev Return the entire set in an array
967      *
968      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
969      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
970      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
971      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
972      */
973     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
974         return _values(set._inner);
975     }
976 
977     // AddressSet
978 
979     struct AddressSet {
980         Set _inner;
981     }
982 
983     /**
984      * @dev Add a value to a set. O(1).
985      *
986      * Returns true if the value was added to the set, that is if it was not
987      * already present.
988      */
989     function add(AddressSet storage set, address value) internal returns (bool) {
990         return _add(set._inner, bytes32(uint256(uint160(value))));
991     }
992 
993     /**
994      * @dev Removes a value from a set. O(1).
995      *
996      * Returns true if the value was removed from the set, that is if it was
997      * present.
998      */
999     function remove(AddressSet storage set, address value) internal returns (bool) {
1000         return _remove(set._inner, bytes32(uint256(uint160(value))));
1001     }
1002 
1003     /**
1004      * @dev Returns true if the value is in the set. O(1).
1005      */
1006     function contains(AddressSet storage set, address value) internal view returns (bool) {
1007         return _contains(set._inner, bytes32(uint256(uint160(value))));
1008     }
1009 
1010     /**
1011      * @dev Returns the number of values in the set. O(1).
1012      */
1013     function length(AddressSet storage set) internal view returns (uint256) {
1014         return _length(set._inner);
1015     }
1016 
1017     /**
1018      * @dev Returns the value stored at position `index` in the set. O(1).
1019      *
1020      * Note that there are no guarantees on the ordering of values inside the
1021      * array, and it may change when more values are added or removed.
1022      *
1023      * Requirements:
1024      *
1025      * - `index` must be strictly less than {length}.
1026      */
1027     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1028         return address(uint160(uint256(_at(set._inner, index))));
1029     }
1030 
1031     /**
1032      * @dev Return the entire set in an array
1033      *
1034      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1035      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1036      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1037      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1038      */
1039     function values(AddressSet storage set) internal view returns (address[] memory) {
1040         bytes32[] memory store = _values(set._inner);
1041         address[] memory result;
1042 
1043         assembly {
1044             result := store
1045         }
1046 
1047         return result;
1048     }
1049 
1050     // UintSet
1051 
1052     struct UintSet {
1053         Set _inner;
1054     }
1055 
1056     /**
1057      * @dev Add a value to a set. O(1).
1058      *
1059      * Returns true if the value was added to the set, that is if it was not
1060      * already present.
1061      */
1062     function add(UintSet storage set, uint256 value) internal returns (bool) {
1063         return _add(set._inner, bytes32(value));
1064     }
1065 
1066     /**
1067      * @dev Removes a value from a set. O(1).
1068      *
1069      * Returns true if the value was removed from the set, that is if it was
1070      * present.
1071      */
1072     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1073         return _remove(set._inner, bytes32(value));
1074     }
1075 
1076     /**
1077      * @dev Returns true if the value is in the set. O(1).
1078      */
1079     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1080         return _contains(set._inner, bytes32(value));
1081     }
1082 
1083     /**
1084      * @dev Returns the number of values on the set. O(1).
1085      */
1086     function length(UintSet storage set) internal view returns (uint256) {
1087         return _length(set._inner);
1088     }
1089 
1090     /**
1091      * @dev Returns the value stored at position `index` in the set. O(1).
1092      *
1093      * Note that there are no guarantees on the ordering of values inside the
1094      * array, and it may change when more values are added or removed.
1095      *
1096      * Requirements:
1097      *
1098      * - `index` must be strictly less than {length}.
1099      */
1100     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1101         return uint256(_at(set._inner, index));
1102     }
1103 
1104     /**
1105      * @dev Return the entire set in an array
1106      *
1107      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1108      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1109      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1110      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1111      */
1112     function values(UintSet storage set) internal view returns (uint256[] memory) {
1113         bytes32[] memory store = _values(set._inner);
1114         uint256[] memory result;
1115 
1116         assembly {
1117             result := store
1118         }
1119 
1120         return result;
1121     }
1122 }
1123 
1124 // OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableMap.sol)
1125 
1126 pragma solidity ^0.8.0;
1127 
1128 /**
1129  * @dev Library for managing an enumerable variant of Solidity's
1130  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1131  * type.
1132  *
1133  * Maps have the following properties:
1134  *
1135  * - Entries are added, removed, and checked for existence in constant time
1136  * (O(1)).
1137  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1138  *
1139  * ```
1140  * contract Example {
1141  *     // Add the library methods
1142  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1143  *
1144  *     // Declare a set state variable
1145  *     EnumerableMap.UintToAddressMap private myMap;
1146  * }
1147  * ```
1148  *
1149  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1150  * supported.
1151  */
1152 library EnumerableMap {
1153     using EnumerableSet for EnumerableSet.Bytes32Set;
1154 
1155     // To implement this library for multiple types with as little code
1156     // repetition as possible, we write it in terms of a generic Map type with
1157     // bytes32 keys and values.
1158     // The Map implementation uses private functions, and user-facing
1159     // implementations (such as Uint256ToAddressMap) are just wrappers around
1160     // the underlying Map.
1161     // This means that we can only create new EnumerableMaps for types that fit
1162     // in bytes32.
1163 
1164     struct Map {
1165         // Storage of keys
1166         EnumerableSet.Bytes32Set _keys;
1167         mapping(bytes32 => bytes32) _values;
1168     }
1169 
1170     /**
1171      * @dev Adds a key-value pair to a map, or updates the value for an existing
1172      * key. O(1).
1173      *
1174      * Returns true if the key was added to the map, that is if it was not
1175      * already present.
1176      */
1177     function _set(
1178         Map storage map,
1179         bytes32 key,
1180         bytes32 value
1181     ) private returns (bool) {
1182         map._values[key] = value;
1183         return map._keys.add(key);
1184     }
1185 
1186     /**
1187      * @dev Removes a key-value pair from a map. O(1).
1188      *
1189      * Returns true if the key was removed from the map, that is if it was present.
1190      */
1191     function _remove(Map storage map, bytes32 key) private returns (bool) {
1192         delete map._values[key];
1193         return map._keys.remove(key);
1194     }
1195 
1196     /**
1197      * @dev Returns true if the key is in the map. O(1).
1198      */
1199     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1200         return map._keys.contains(key);
1201     }
1202 
1203     /**
1204      * @dev Returns the number of key-value pairs in the map. O(1).
1205      */
1206     function _length(Map storage map) private view returns (uint256) {
1207         return map._keys.length();
1208     }
1209 
1210     /**
1211      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1212      *
1213      * Note that there are no guarantees on the ordering of entries inside the
1214      * array, and it may change when more entries are added or removed.
1215      *
1216      * Requirements:
1217      *
1218      * - `index` must be strictly less than {length}.
1219      */
1220     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1221         bytes32 key = map._keys.at(index);
1222         return (key, map._values[key]);
1223     }
1224 
1225     /**
1226      * @dev Tries to returns the value associated with `key`.  O(1).
1227      * Does not revert if `key` is not in the map.
1228      */
1229     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1230         bytes32 value = map._values[key];
1231         if (value == bytes32(0)) {
1232             return (_contains(map, key), bytes32(0));
1233         } else {
1234             return (true, value);
1235         }
1236     }
1237 
1238     /**
1239      * @dev Returns the value associated with `key`.  O(1).
1240      *
1241      * Requirements:
1242      *
1243      * - `key` must be in the map.
1244      */
1245     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1246         bytes32 value = map._values[key];
1247         require(value != 0 || _contains(map, key), "EnumerableMap: nonexistent key");
1248         return value;
1249     }
1250 
1251     /**
1252      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1253      *
1254      * CAUTION: This function is deprecated because it requires allocating memory for the error
1255      * message unnecessarily. For custom revert reasons use {_tryGet}.
1256      */
1257     function _get(
1258         Map storage map,
1259         bytes32 key,
1260         string memory errorMessage
1261     ) private view returns (bytes32) {
1262         bytes32 value = map._values[key];
1263         require(value != 0 || _contains(map, key), errorMessage);
1264         return value;
1265     }
1266 
1267     // UintToAddressMap
1268 
1269     struct UintToAddressMap {
1270         Map _inner;
1271     }
1272 
1273     /**
1274      * @dev Adds a key-value pair to a map, or updates the value for an existing
1275      * key. O(1).
1276      *
1277      * Returns true if the key was added to the map, that is if it was not
1278      * already present.
1279      */
1280     function set(
1281         UintToAddressMap storage map,
1282         uint256 key,
1283         address value
1284     ) internal returns (bool) {
1285         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1286     }
1287 
1288     /**
1289      * @dev Removes a value from a set. O(1).
1290      *
1291      * Returns true if the key was removed from the map, that is if it was present.
1292      */
1293     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1294         return _remove(map._inner, bytes32(key));
1295     }
1296 
1297     /**
1298      * @dev Returns true if the key is in the map. O(1).
1299      */
1300     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1301         return _contains(map._inner, bytes32(key));
1302     }
1303 
1304     /**
1305      * @dev Returns the number of elements in the map. O(1).
1306      */
1307     function length(UintToAddressMap storage map) internal view returns (uint256) {
1308         return _length(map._inner);
1309     }
1310 
1311     /**
1312      * @dev Returns the element stored at position `index` in the set. O(1).
1313      * Note that there are no guarantees on the ordering of values inside the
1314      * array, and it may change when more values are added or removed.
1315      *
1316      * Requirements:
1317      *
1318      * - `index` must be strictly less than {length}.
1319      */
1320     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1321         (bytes32 key, bytes32 value) = _at(map._inner, index);
1322         return (uint256(key), address(uint160(uint256(value))));
1323     }
1324 
1325     /**
1326      * @dev Tries to returns the value associated with `key`.  O(1).
1327      * Does not revert if `key` is not in the map.
1328      *
1329      * _Available since v3.4._
1330      */
1331     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1332         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1333         return (success, address(uint160(uint256(value))));
1334     }
1335 
1336     /**
1337      * @dev Returns the value associated with `key`.  O(1).
1338      *
1339      * Requirements:
1340      *
1341      * - `key` must be in the map.
1342      */
1343     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1344         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1345     }
1346 
1347     /**
1348      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1349      *
1350      * CAUTION: This function is deprecated because it requires allocating memory for the error
1351      * message unnecessarily. For custom revert reasons use {tryGet}.
1352      */
1353     function get(
1354         UintToAddressMap storage map,
1355         uint256 key,
1356         string memory errorMessage
1357     ) internal view returns (address) {
1358         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1359     }
1360 }
1361 
1362 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1363 
1364 pragma solidity ^0.8.0;
1365 
1366 /**
1367  * @dev String operations.
1368  */
1369 library Strings {
1370     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1371 
1372     /**
1373      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1374      */
1375     function toString(uint256 value) internal pure returns (string memory) {
1376         // Inspired by OraclizeAPI's implementation - MIT licence
1377         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1378 
1379         if (value == 0) {
1380             return "0";
1381         }
1382         uint256 temp = value;
1383         uint256 digits;
1384         while (temp != 0) {
1385             digits++;
1386             temp /= 10;
1387         }
1388         bytes memory buffer = new bytes(digits);
1389         while (value != 0) {
1390             digits -= 1;
1391             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1392             value /= 10;
1393         }
1394         return string(buffer);
1395     }
1396 
1397     /**
1398      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1399      */
1400     function toHexString(uint256 value) internal pure returns (string memory) {
1401         if (value == 0) {
1402             return "0x00";
1403         }
1404         uint256 temp = value;
1405         uint256 length = 0;
1406         while (temp != 0) {
1407             length++;
1408             temp >>= 8;
1409         }
1410         return toHexString(value, length);
1411     }
1412 
1413     /**
1414      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1415      */
1416     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1417         bytes memory buffer = new bytes(2 * length + 2);
1418         buffer[0] = "0";
1419         buffer[1] = "x";
1420         for (uint256 i = 2 * length + 1; i > 1; --i) {
1421             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1422             value >>= 4;
1423         }
1424         require(value == 0, "Strings: hex length insufficient");
1425         return string(buffer);
1426     }
1427 }
1428 
1429 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1430 
1431 pragma solidity ^0.8.0;
1432 
1433 
1434 /**
1435  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1436  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1437  * {ERC721Enumerable}.
1438  */
1439 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1440     using Address for address;
1441     using Strings for uint256;
1442 
1443     // Token name
1444     string private _name;
1445 
1446     // Token symbol
1447     string private _symbol;
1448 
1449     // Base URI
1450     string private _baseURI = "";
1451 
1452     // Mapping from token ID to owner address
1453     mapping(uint256 => address) private _owners;
1454 
1455     // Mapping owner address to token count
1456     mapping(address => uint256) private _balances;
1457 
1458     // Mapping from token ID to approved address
1459     mapping(uint256 => address) private _tokenApprovals;
1460 
1461     // Mapping from owner to operator approvals
1462     mapping(address => mapping(address => bool)) private _operatorApprovals;
1463 
1464     // Fonction to lock the sale of the NFT 
1465     bool public isSecondaryMarketOpen = false;
1466     mapping(address => bool) public whitelistTransfer;
1467 
1468 
1469     /**
1470      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1471      */
1472     constructor(string memory name_, string memory symbol_) {
1473         _name = name_;
1474         _symbol = symbol_;
1475     }
1476 
1477     // Fonction to lock the sale of the NFT or to unlock
1478     function _changeSecondaryMarketState() internal virtual {
1479         isSecondaryMarketOpen = !isSecondaryMarketOpen;
1480     }
1481 
1482     // Fonction add or remove address from transfer Whitelist
1483     function _modifyAuthorizedSellers(address[] memory addresses, bool state) internal virtual {
1484         for (uint256 i = 0; i < addresses.length; i++) {
1485             whitelistTransfer[addresses[i]] = state;
1486         }
1487     }
1488 
1489     // View Function to check if an adress is present on the map whiteListTransfer
1490     function _isWhitelistTransfer(address addr) internal view virtual returns (bool) {
1491         return whitelistTransfer[addr];
1492     }
1493 
1494     /**
1495      * @dev See {IERC165-supportsInterface}.
1496      */
1497     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1498         return
1499             interfaceId == type(IERC721).interfaceId ||
1500             interfaceId == type(IERC721Metadata).interfaceId ||
1501             super.supportsInterface(interfaceId);
1502     }
1503 
1504     /**
1505      * @dev See {IERC721-balanceOf}.
1506      */
1507     function balanceOf(address owner) public view virtual override returns (uint256) {
1508         require(owner != address(0), "ERC721: balance query for the zero address");
1509         return _balances[owner];
1510     }
1511 
1512     /**
1513      * @dev See {IERC721-ownerOf}.
1514      */
1515     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1516         address owner = _owners[tokenId];
1517         require(owner != address(0), "ERC721: owner query for nonexistent token");
1518         return owner;
1519     }
1520 
1521     /**
1522      * @dev See {IERC721Metadata-name}.
1523      */
1524     function name() public view virtual override returns (string memory) {
1525         return _name;
1526     }
1527 
1528     /**
1529      * @dev See {IERC721Metadata-symbol}.
1530      */
1531     function symbol() public view virtual override returns (string memory) {
1532         return _symbol;
1533     }
1534 
1535     /**
1536      * @dev See {IERC721Metadata-tokenURI}.
1537      */
1538     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1539         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1540 
1541         string memory baseURI_ = baseURI();
1542         return bytes(baseURI_).length > 0 ? string(abi.encodePacked(baseURI_, tokenId.toString())) : "";
1543     }
1544 
1545     function baseURI() public view virtual returns (string memory) {
1546         return _baseURI;
1547     }
1548 
1549     function _setBaseURI(string memory baseURI_) internal virtual {
1550         _baseURI = baseURI_;
1551     }
1552 
1553     /**
1554      * @dev See {IERC721-approve}.
1555      */
1556     function approve(address to, uint256 tokenId) public virtual override {
1557         address owner = ERC721.ownerOf(tokenId);
1558         require(to != owner, "ERC721: approval to current owner");
1559 
1560         require(
1561             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1562             "ERC721: approve caller is not owner nor approved for all"
1563         );
1564 
1565         _approve(to, tokenId);
1566     }
1567 
1568     /**
1569      * @dev See {IERC721-getApproved}.
1570      */
1571     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1572         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1573 
1574         return _tokenApprovals[tokenId];
1575     }
1576 
1577     /**
1578      * @dev See {IERC721-setApprovalForAll}.
1579      */
1580     function setApprovalForAll(address operator, bool approved) public virtual override {
1581         _setApprovalForAll(_msgSender(), operator, approved);
1582     }
1583 
1584     /**
1585      * @dev See {IERC721-isApprovedForAll}.
1586      */
1587     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1588         return _operatorApprovals[owner][operator];
1589     }
1590 
1591     /**
1592      * @dev See {IERC721-transferFrom}.
1593      */
1594     function transferFrom(
1595         address from,
1596         address to,
1597         uint256 tokenId
1598     ) public virtual override {
1599         //solhint-disable-next-line max-line-length
1600         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1601 
1602         _transfer(from, to, tokenId);
1603     }
1604 
1605     /**
1606      * @dev See {IERC721-safeTransferFrom}.
1607      */
1608     function safeTransferFrom(
1609         address from,
1610         address to,
1611         uint256 tokenId
1612     ) public virtual override {
1613         safeTransferFrom(from, to, tokenId, "");
1614     }
1615 
1616     /**
1617      * @dev See {IERC721-safeTransferFrom}.
1618      */
1619     function safeTransferFrom(
1620         address from,
1621         address to,
1622         uint256 tokenId,
1623         bytes memory _data
1624     ) public virtual override {
1625         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1626         _safeTransfer(from, to, tokenId, _data);
1627     }
1628 
1629     /**
1630      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1631      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1632      *
1633      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1634      *
1635      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1636      * implement alternative mechanisms to perform token transfer, such as signature-based.
1637      *
1638      * Requirements:
1639      *
1640      * - `from` cannot be the zero address.
1641      * - `to` cannot be the zero address.
1642      * - `tokenId` token must exist and be owned by `from`.
1643      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1644      *
1645      * Emits a {Transfer} event.
1646      */
1647     function _safeTransfer(
1648         address from,
1649         address to,
1650         uint256 tokenId,
1651         bytes memory _data
1652     ) internal virtual {
1653         _transfer(from, to, tokenId);
1654         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1655     }
1656 
1657     /**
1658      * @dev Returns whether `tokenId` exists.
1659      *
1660      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1661      *
1662      * Tokens start existing when they are minted (`_mint`),
1663      * and stop existing when they are burned (`_burn`).
1664      */
1665     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1666         return _owners[tokenId] != address(0);
1667     }
1668 
1669     /**
1670      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1671      *
1672      * Requirements:
1673      *
1674      * - `tokenId` must exist.
1675      */
1676     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1677         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1678         address owner = ERC721.ownerOf(tokenId);
1679         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1680     }
1681 
1682     /**
1683      * @dev Safely mints `tokenId` and transfers it to `to`.
1684      *
1685      * Requirements:
1686      *
1687      * - `tokenId` must not exist.
1688      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1689      *
1690      * Emits a {Transfer} event.
1691      */
1692     function _safeMint(address to, uint256 tokenId) internal virtual {
1693         _safeMint(to, tokenId, "");
1694     }
1695 
1696     /**
1697      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1698      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1699      */
1700     function _safeMint(
1701         address to,
1702         uint256 tokenId,
1703         bytes memory _data
1704     ) internal virtual {
1705         _mint(to, tokenId);
1706         require(
1707             _checkOnERC721Received(address(0), to, tokenId, _data),
1708             "ERC721: transfer to non ERC721Receiver implementer"
1709         );
1710     }
1711 
1712     /**
1713      * @dev Mints `tokenId` and transfers it to `to`.
1714      *
1715      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1716      *
1717      * Requirements:
1718      *
1719      * - `tokenId` must not exist.
1720      * - `to` cannot be the zero address.
1721      *
1722      * Emits a {Transfer} event.
1723      */
1724     function _mint(address to, uint256 tokenId) internal virtual {
1725         require(to != address(0), "ERC721: mint to the zero address");
1726         require(!_exists(tokenId), "ERC721: token already minted");
1727 
1728         _beforeTokenTransfer(address(0), to, tokenId);
1729 
1730         _balances[to] += 1;
1731         _owners[tokenId] = to;
1732 
1733         emit Transfer(address(0), to, tokenId);
1734 
1735         _afterTokenTransfer(address(0), to, tokenId);
1736     }
1737 
1738     /**
1739      * @dev Destroys `tokenId`.
1740      * The approval is cleared when the token is burned.
1741      *
1742      * Requirements:
1743      *
1744      * - `tokenId` must exist.
1745      *
1746      * Emits a {Transfer} event.
1747      */
1748     function _burn(uint256 tokenId) internal virtual {
1749         address owner = ERC721.ownerOf(tokenId);
1750 
1751         _beforeTokenTransfer(owner, address(0), tokenId);
1752 
1753         // Clear approvals
1754         _approve(address(0), tokenId);
1755 
1756         _balances[owner] -= 1;
1757         delete _owners[tokenId];
1758 
1759         emit Transfer(owner, address(0), tokenId);
1760 
1761         _afterTokenTransfer(owner, address(0), tokenId);
1762     }
1763 
1764     /**
1765      * @dev Transfers `tokenId` from `from` to `to`.
1766      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1767      *
1768      * Requirements:
1769      *
1770      * - `to` cannot be the zero address.
1771      * - `tokenId` token must be owned by `from`.
1772      *
1773      * Emits a {Transfer} event.
1774      */
1775     function _transfer(
1776         address from,
1777         address to,
1778         uint256 tokenId
1779     ) internal virtual {
1780         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1781         require(to != address(0), "ERC721: transfer to the zero address");
1782         //require(isSecondaryMarketOpen == true, "Secondary Market sale is not open");
1783         if (isSecondaryMarketOpen == false){
1784             require(whitelistTransfer[from], "Transfer is not authorized for the Sender : contact the project team to be on the Whitelist");
1785         }
1786         _beforeTokenTransfer(from, to, tokenId);
1787 
1788         // Clear approvals from the previous owner
1789         _approve(address(0), tokenId);
1790 
1791         _balances[from] -= 1;
1792         _balances[to] += 1;
1793         _owners[tokenId] = to;
1794 
1795         emit Transfer(from, to, tokenId);
1796 
1797         _afterTokenTransfer(from, to, tokenId);
1798     }
1799 
1800     /**
1801      * @dev Approve `to` to operate on `tokenId`
1802      *
1803      * Emits a {Approval} event.
1804      */
1805     function _approve(address to, uint256 tokenId) internal virtual {
1806         _tokenApprovals[tokenId] = to;
1807         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1808     }
1809 
1810     /**
1811      * @dev Approve `operator` to operate on all of `owner` tokens
1812      *
1813      * Emits a {ApprovalForAll} event.
1814      */
1815     function _setApprovalForAll(
1816         address owner,
1817         address operator,
1818         bool approved
1819     ) internal virtual {
1820         require(owner != operator, "ERC721: approve to caller");
1821         _operatorApprovals[owner][operator] = approved;
1822         emit ApprovalForAll(owner, operator, approved);
1823     }
1824 
1825     /**
1826      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1827      * The call is not executed if the target address is not a contract.
1828      *
1829      * @param from address representing the previous owner of the given token ID
1830      * @param to target address that will receive the tokens
1831      * @param tokenId uint256 ID of the token to be transferred
1832      * @param _data bytes optional data to send along with the call
1833      * @return bool whether the call correctly returned the expected magic value
1834      */
1835     function _checkOnERC721Received(
1836         address from,
1837         address to,
1838         uint256 tokenId,
1839         bytes memory _data
1840     ) private returns (bool) {
1841         if (to.isContract()) {
1842             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1843                 return retval == IERC721Receiver.onERC721Received.selector;
1844             } catch (bytes memory reason) {
1845                 if (reason.length == 0) {
1846                     revert("ERC721: transfer to non ERC721Receiver implementer");
1847                 } else {
1848                     assembly {
1849                         revert(add(32, reason), mload(reason))
1850                     }
1851                 }
1852             }
1853         } else {
1854             return true;
1855         }
1856     }
1857 
1858     /**
1859      * @dev Hook that is called before any token transfer. This includes minting
1860      * and burning.
1861      *
1862      * Calling conditions:
1863      *
1864      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1865      * transferred to `to`.
1866      * - When `from` is zero, `tokenId` will be minted for `to`.
1867      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1868      * - `from` and `to` are never both zero.
1869      *
1870      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1871      */
1872     function _beforeTokenTransfer(
1873         address from,
1874         address to,
1875         uint256 tokenId
1876     ) internal virtual {}
1877 
1878     /**
1879      * @dev Hook that is called after any transfer of tokens. This includes
1880      * minting and burning.
1881      *
1882      * Calling conditions:
1883      *
1884      * - when `from` and `to` are both non-zero.
1885      * - `from` and `to` are never both zero.
1886      *
1887      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1888      */
1889     function _afterTokenTransfer(
1890         address from,
1891         address to,
1892         uint256 tokenId
1893     ) internal virtual {}
1894 }
1895 
1896 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1897 
1898 pragma solidity ^0.8.0;
1899 
1900 /**
1901  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1902  * enumerability of all the token ids in the contract as well as all token ids owned by each
1903  * account.
1904  */
1905 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1906     // Mapping from owner to list of owned token IDs
1907     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1908 
1909     // Mapping from token ID to index of the owner tokens list
1910     mapping(uint256 => uint256) private _ownedTokensIndex;
1911 
1912     // Array with all token ids, used for enumeration
1913     uint256[] private _allTokens;
1914 
1915     // Mapping from token id to position in the allTokens array
1916     mapping(uint256 => uint256) private _allTokensIndex;
1917 
1918     /**
1919      * @dev See {IERC165-supportsInterface}.
1920      */
1921     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1922         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1923     }
1924 
1925     /**
1926      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1927      */
1928     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1929         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1930         return _ownedTokens[owner][index];
1931     }
1932 
1933     /**
1934      * @dev See {IERC721Enumerable-totalSupply}.
1935      */
1936     function totalSupply() public view virtual override returns (uint256) {
1937         return _allTokens.length;
1938     }
1939 
1940     /**
1941      * @dev See {IERC721Enumerable-tokenByIndex}.
1942      */
1943     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1944         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1945         return _allTokens[index];
1946     }
1947 
1948     /**
1949      * @dev Hook that is called before any token transfer. This includes minting
1950      * and burning.
1951      *
1952      * Calling conditions:
1953      *
1954      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1955      * transferred to `to`.
1956      * - When `from` is zero, `tokenId` will be minted for `to`.
1957      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1958      * - `from` cannot be the zero address.
1959      * - `to` cannot be the zero address.
1960      *
1961      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1962      */
1963     function _beforeTokenTransfer(
1964         address from,
1965         address to,
1966         uint256 tokenId
1967     ) internal virtual override {
1968         super._beforeTokenTransfer(from, to, tokenId);
1969 
1970         if (from == address(0)) {
1971             _addTokenToAllTokensEnumeration(tokenId);
1972         } else if (from != to) {
1973             _removeTokenFromOwnerEnumeration(from, tokenId);
1974         }
1975         if (to == address(0)) {
1976             _removeTokenFromAllTokensEnumeration(tokenId);
1977         } else if (to != from) {
1978             _addTokenToOwnerEnumeration(to, tokenId);
1979         }
1980     }
1981 
1982     /**
1983      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1984      * @param to address representing the new owner of the given token ID
1985      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1986      */
1987     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1988         uint256 length = ERC721.balanceOf(to);
1989         _ownedTokens[to][length] = tokenId;
1990         _ownedTokensIndex[tokenId] = length;
1991     }
1992 
1993     /**
1994      * @dev Private function to add a token to this extension's token tracking data structures.
1995      * @param tokenId uint256 ID of the token to be added to the tokens list
1996      */
1997     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1998         _allTokensIndex[tokenId] = _allTokens.length;
1999         _allTokens.push(tokenId);
2000     }
2001 
2002     /**
2003      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2004      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2005      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2006      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2007      * @param from address representing the previous owner of the given token ID
2008      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2009      */
2010     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2011         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2012         // then delete the last slot (swap and pop).
2013 
2014         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2015         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2016 
2017         // When the token to delete is the last token, the swap operation is unnecessary
2018         if (tokenIndex != lastTokenIndex) {
2019             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2020 
2021             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2022             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2023         }
2024 
2025         // This also deletes the contents at the last position of the array
2026         delete _ownedTokensIndex[tokenId];
2027         delete _ownedTokens[from][lastTokenIndex];
2028     }
2029 
2030     /**
2031      * @dev Private function to remove a token from this extension's token tracking data structures.
2032      * This has O(1) time complexity, but alters the order of the _allTokens array.
2033      * @param tokenId uint256 ID of the token to be removed from the tokens list
2034      */
2035     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2036         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2037         // then delete the last slot (swap and pop).
2038 
2039         uint256 lastTokenIndex = _allTokens.length - 1;
2040         uint256 tokenIndex = _allTokensIndex[tokenId];
2041 
2042         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2043         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2044         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2045         uint256 lastTokenId = _allTokens[lastTokenIndex];
2046 
2047         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2048         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2049 
2050         // This also deletes the contents at the last position of the array
2051         delete _allTokensIndex[tokenId];
2052         _allTokens.pop();
2053     }
2054 }
2055 
2056 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
2057 
2058 pragma solidity ^0.8.0;
2059 
2060 /**
2061  * @dev Contract module which provides a basic access control mechanism, where
2062  * there is an account (an owner) that can be granted exclusive access to
2063  * specific functions.
2064  *
2065  * By default, the owner account will be the one that deploys the contract. This
2066  * can later be changed with {transferOwnership}.
2067  *
2068  * This module is used through inheritance. It will make available the modifier
2069  * `onlyOwner`, which can be applied to your functions to restrict their use to
2070  * the owner.
2071  */
2072 abstract contract Ownable is Context {
2073     address private _owner;
2074 
2075     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2076 
2077     /**
2078      * @dev Initializes the contract setting the deployer as the initial owner.
2079      */
2080     constructor() {
2081         _transferOwnership(_msgSender());
2082     }
2083 
2084     /**
2085      * @dev Returns the address of the current owner.
2086      */
2087     function owner() public view virtual returns (address) {
2088         return _owner;
2089     }
2090 
2091     /**
2092      * @dev Throws if called by any account other than the owner.
2093      */
2094     modifier onlyOwner() {
2095         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2096         _;
2097     }
2098 
2099     /**
2100      * @dev Leaves the contract without owner. It will not be possible to call
2101      * `onlyOwner` functions anymore. Can only be called by the current owner.
2102      *
2103      * NOTE: Renouncing ownership will leave the contract without an owner,
2104      * thereby removing any functionality that is only available to the owner.
2105      */
2106     function renounceOwnership() public virtual onlyOwner {
2107         _transferOwnership(address(0));
2108     }
2109 
2110     /**
2111      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2112      * Can only be called by the current owner.
2113      */
2114     function transferOwnership(address newOwner) public virtual onlyOwner {
2115         require(newOwner != address(0), "Ownable: new owner is the zero address");
2116         _transferOwnership(newOwner);
2117     }
2118 
2119     /**
2120      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2121      * Internal function without access restriction.
2122      */
2123     function _transferOwnership(address newOwner) internal virtual {
2124         address oldOwner = _owner;
2125         _owner = newOwner;
2126         emit OwnershipTransferred(oldOwner, newOwner);
2127     }
2128 }
2129 
2130 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
2131 
2132 pragma solidity ^0.8.0;
2133 
2134 /**
2135  * @dev Interface of the ERC20 standard as defined in the EIP.
2136  */
2137 interface IERC20 {
2138     /**
2139      * @dev Returns the amount of tokens in existence.
2140      */
2141     function totalSupply() external view returns (uint256);
2142 
2143     /**
2144      * @dev Returns the amount of tokens owned by `account`.
2145      */
2146     function balanceOf(address account) external view returns (uint256);
2147 
2148     /**
2149      * @dev Moves `amount` tokens from the caller's account to `recipient`.
2150      *
2151      * Returns a boolean value indicating whether the operation succeeded.
2152      *
2153      * Emits a {Transfer} event.
2154      */
2155     function transfer(address recipient, uint256 amount) external returns (bool);
2156 
2157     /**
2158      * @dev Returns the remaining number of tokens that `spender` will be
2159      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2160      * zero by default.
2161      *
2162      * This value changes when {approve} or {transferFrom} are called.
2163      */
2164     function allowance(address owner, address spender) external view returns (uint256);
2165 
2166     /**
2167      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2168      *
2169      * Returns a boolean value indicating whether the operation succeeded.
2170      *
2171      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2172      * that someone may use both the old and the new allowance by unfortunate
2173      * transaction ordering. One possible solution to mitigate this race
2174      * condition is to first reduce the spender's allowance to 0 and set the
2175      * desired value afterwards:
2176      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2177      *
2178      * Emits an {Approval} event.
2179      */
2180     function approve(address spender, uint256 amount) external returns (bool);
2181 
2182     /**
2183      * @dev Moves `amount` tokens from `sender` to `recipient` using the
2184      * allowance mechanism. `amount` is then deducted from the caller's
2185      * allowance.
2186      *
2187      * Returns a boolean value indicating whether the operation succeeded.
2188      *
2189      * Emits a {Transfer} event.
2190      */
2191     function transferFrom(
2192         address sender,
2193         address recipient,
2194         uint256 amount
2195     ) external returns (bool);
2196 
2197     /**
2198      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2199      * another (`to`).
2200      *
2201      * Note that `value` may be zero.
2202      */
2203     event Transfer(address indexed from, address indexed to, uint256 value);
2204 
2205     /**
2206      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2207      * a call to {approve}. `value` is the new allowance.
2208      */
2209     event Approval(address indexed owner, address indexed spender, uint256 value);
2210 }
2211 
2212 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
2213 
2214 pragma solidity ^0.8.0;
2215 
2216 
2217 /**
2218  * @title SafeERC20
2219  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2220  * contract returns false). Tokens that return no value (and instead revert or
2221  * throw on failure) are also supported, non-reverting calls are assumed to be
2222  * successful.
2223  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2224  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2225  */
2226 library SafeERC20 {
2227     using Address for address;
2228 
2229     function safeTransfer(
2230         IERC20 token,
2231         address to,
2232         uint256 value
2233     ) internal {
2234         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
2235     }
2236 
2237     function safeTransferFrom(
2238         IERC20 token,
2239         address from,
2240         address to,
2241         uint256 value
2242     ) internal {
2243         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
2244     }
2245 
2246     /**
2247      * @dev Deprecated. This function has issues similar to the ones found in
2248      * {IERC20-approve}, and its usage is discouraged.
2249      *
2250      * Whenever possible, use {safeIncreaseAllowance} and
2251      * {safeDecreaseAllowance} instead.
2252      */
2253     function safeApprove(
2254         IERC20 token,
2255         address spender,
2256         uint256 value
2257     ) internal {
2258         // safeApprove should only be called when setting an initial allowance,
2259         // or when resetting it to zero. To increase and decrease it, use
2260         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2261         require(
2262             (value == 0) || (token.allowance(address(this), spender) == 0),
2263             "SafeERC20: approve from non-zero to non-zero allowance"
2264         );
2265         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
2266     }
2267 
2268     function safeIncreaseAllowance(
2269         IERC20 token,
2270         address spender,
2271         uint256 value
2272     ) internal {
2273         uint256 newAllowance = token.allowance(address(this), spender) + value;
2274         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2275     }
2276 
2277     function safeDecreaseAllowance(
2278         IERC20 token,
2279         address spender,
2280         uint256 value
2281     ) internal {
2282         unchecked {
2283             uint256 oldAllowance = token.allowance(address(this), spender);
2284             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
2285             uint256 newAllowance = oldAllowance - value;
2286             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2287         }
2288     }
2289 
2290     /**
2291      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2292      * on the return value: the return value is optional (but if data is returned, it must not be false).
2293      * @param token The token targeted by the call.
2294      * @param data The call data (encoded using abi.encode or one of its variants).
2295      */
2296     function _callOptionalReturn(IERC20 token, bytes memory data) private {
2297         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2298         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
2299         // the target address contains contract code and also asserts for success in the low-level call.
2300 
2301         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
2302         if (returndata.length > 0) {
2303             // Return data is optional
2304             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
2305         }
2306     }
2307 }
2308 
2309 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
2310 
2311 pragma solidity ^0.8.0;
2312 
2313 /**
2314  * @title PaymentSplitter
2315  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
2316  * that the Ether will be split in this way, since it is handled transparently by the contract.
2317  *
2318  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
2319  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
2320  * an amount proportional to the percentage of total shares they were assigned.
2321  *
2322  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
2323  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
2324  * function.
2325  *
2326  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
2327  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
2328  * to run tests before sending real value to this contract.
2329  */
2330 contract PaymentSplitter is Context {
2331     event PayeeAdded(address account, uint256 shares);
2332     event PaymentReleased(address to, uint256 amount);
2333     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
2334     event PaymentReceived(address from, uint256 amount);
2335 
2336     uint256 private _totalShares;
2337     uint256 private _totalReleased;
2338 
2339     mapping(address => uint256) private _shares;
2340     mapping(address => uint256) private _released;
2341     address[] private _payees;
2342 
2343     mapping(IERC20 => uint256) private _erc20TotalReleased;
2344     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
2345 
2346     /**
2347      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
2348      * the matching position in the `shares` array.
2349      *
2350      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
2351      * duplicates in `payees`.
2352      */
2353     constructor(address[] memory payees, uint256[] memory shares_) payable {
2354         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
2355         require(payees.length > 0, "PaymentSplitter: no payees");
2356 
2357         for (uint256 i = 0; i < payees.length; i++) {
2358             _addPayee(payees[i], shares_[i]);
2359         }
2360     }
2361 
2362     /**
2363      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
2364      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
2365      * reliability of the events, and not the actual splitting of Ether.
2366      *
2367      * To learn more about this see the Solidity documentation for
2368      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
2369      * functions].
2370      */
2371     receive() external payable virtual {
2372         emit PaymentReceived(_msgSender(), msg.value);
2373     }
2374 
2375     /**
2376      * @dev Getter for the total shares held by payees.
2377      */
2378     function totalShares() public view returns (uint256) {
2379         return _totalShares;
2380     }
2381 
2382     /**
2383      * @dev Getter for the total amount of Ether already released.
2384      */
2385     function totalReleased() public view returns (uint256) {
2386         return _totalReleased;
2387     }
2388 
2389     /**
2390      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
2391      * contract.
2392      */
2393     function totalReleased(IERC20 token) public view returns (uint256) {
2394         return _erc20TotalReleased[token];
2395     }
2396 
2397     /**
2398      * @dev Getter for the amount of shares held by an account.
2399      */
2400     function shares(address account) public view returns (uint256) {
2401         return _shares[account];
2402     }
2403 
2404     /**
2405      * @dev Getter for the amount of Ether already released to a payee.
2406      */
2407     function released(address account) public view returns (uint256) {
2408         return _released[account];
2409     }
2410 
2411     /**
2412      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
2413      * IERC20 contract.
2414      */
2415     function released(IERC20 token, address account) public view returns (uint256) {
2416         return _erc20Released[token][account];
2417     }
2418 
2419     /**
2420      * @dev Getter for the address of the payee number `index`.
2421      */
2422     function payee(uint256 index) public view returns (address) {
2423         return _payees[index];
2424     }
2425 
2426     /**
2427      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
2428      * total shares and their previous withdrawals.
2429      */
2430     function release(address payable account) public virtual {
2431         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2432 
2433         uint256 totalReceived = address(this).balance + totalReleased();
2434         uint256 payment = _pendingPayment(account, totalReceived, released(account));
2435 
2436         require(payment != 0, "PaymentSplitter: account is not due payment");
2437 
2438         _released[account] += payment;
2439         _totalReleased += payment;
2440 
2441         Address.sendValue(account, payment);
2442         emit PaymentReleased(account, payment);
2443     }
2444     
2445     /**
2446      * @dev Can modify the shares own by the team.
2447      * They triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
2448      * total shares and their previous withdrawals.
2449      * After the transfer the new shares are setup
2450      */
2451     function _modifyShares(address[] memory oldPayees,address[] memory newPayees , uint256[] memory shares_) internal virtual {
2452         // triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the total shares and their previous withdrawals.
2453         for (uint256 i = 0; i < oldPayees.length; i++) {
2454             require(_shares[oldPayees[i]] > 0, "PaymentSplitter: account has no shares");
2455             uint256 totalReceived = address(this).balance + totalReleased();
2456             uint256 payment = _pendingPayment(oldPayees[i], totalReceived, released(oldPayees[i]));
2457 
2458             if (payment != 0){
2459                 _released[oldPayees[i]] += payment;
2460                 _totalReleased += payment;
2461                 Address.sendValue(payable(oldPayees[i]), payment);
2462                 emit PaymentReleased(oldPayees[i], payment);
2463             } 
2464             _released[oldPayees[i]] = 0;
2465             _shares[oldPayees[i]] = 0;
2466         }
2467         // refresh the shares variable to start as a new team shares
2468         _totalShares = 0;
2469         _totalReleased = 0;
2470 
2471         // Update des shares for the Payees @dev wants
2472         require(newPayees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
2473         require(newPayees.length > 0, "PaymentSplitter: no payees");
2474         for (uint256 i = 0; i < newPayees.length; i++) {
2475             _addPayee(newPayees[i], shares_[i]);
2476         }
2477     }
2478 
2479     /**
2480      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
2481      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
2482      * contract.
2483      */
2484     function release(IERC20 token, address account) public virtual {
2485         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2486 
2487         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
2488         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
2489 
2490         require(payment != 0, "PaymentSplitter: account is not due payment");
2491 
2492         _erc20Released[token][account] += payment;
2493         _erc20TotalReleased[token] += payment;
2494 
2495         SafeERC20.safeTransfer(token, account, payment);
2496         emit ERC20PaymentReleased(token, account, payment);
2497     }
2498 
2499     /**
2500      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
2501      * already released amounts.
2502      */
2503     function _pendingPayment(
2504         address account,
2505         uint256 totalReceived,
2506         uint256 alreadyReleased
2507     ) private view returns (uint256) {
2508         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
2509     }
2510 
2511     /**
2512      * @dev Add a new payee to the contract.
2513      * @param account The address of the payee to add.
2514      * @param shares_ The number of shares owned by the payee.
2515      */
2516     function _addPayee(address account, uint256 shares_) private {
2517         require(account != address(0), "PaymentSplitter: account is the zero address");
2518         require(shares_ > 0, "PaymentSplitter: shares are 0");
2519         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
2520 
2521         _payees.push(account);
2522         _shares[account] = shares_;
2523         _totalShares = _totalShares + shares_;
2524         emit PayeeAdded(account, shares_);
2525     }
2526 }
2527 
2528 // File: contracts/PantheonBusinessClub.sol
2529 pragma solidity ^0.8.0;
2530 
2531 /**
2532  * @title Panthéon Business Club contract
2533  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
2534  */
2535 contract PantheonBusinessClub is ERC721Enumerable, Ownable, PaymentSplitter {
2536     using SafeMath for uint256;
2537 
2538     // The base price is set here.
2539     uint256 public nftPrice = 350000000000000000; // 0.35 ETH
2540 
2541     // Repartition of ETH earned
2542     uint256[] private _teamShares = [16, 16, 12, 36, 20];
2543     address[] public _team = [
2544         0x17482Fa6221f7A6c8453901711d6E2cb3C1355E7,
2545         0xa2D23B0C857E802B97c99bD006Bd707139bAef9A,
2546         0x645AEe5D605b09350BA2135EB340759357E0fA20,
2547         0x0EefcD4C37C78eD786971EC822a1DA6977B08EaC,
2548         0x0d9A8d33428bB813Ea81D32B57A632C532057Fd5
2549     ];
2550 
2551     // Only 20 Pantheon Cards can be purchased per transaction.
2552     uint256 public constant maxNumPurchase = 20;
2553 
2554     // Only 8888 total member card will be generated
2555     uint256 public MAX_TOKENS = 8888;
2556 
2557     // Number of token allowed for the Presale 
2558     uint256 public totalEarlyAccessTokensAllowed = 500;
2559     // List of address whitelisted for the Presale
2560     mapping(address => bool) private earlyAccessAllowList;
2561     // Number max allow during stages
2562     uint256 public stage = 0;
2563     uint256 private stage2 = 2222;
2564     uint256 private stage3 = 3333;
2565     uint256 private stage4 = 4444;
2566     uint256 private stage5 = 5555;
2567     uint256 private stage6 = 6666;
2568     uint256 private stage7 = 7777;
2569     // List of addresse allowed for different stages
2570     mapping(address => bool) private whitelistStage2;
2571     mapping(address => bool) private whitelistStage3;
2572     mapping(address => bool) private whitelistStage4;
2573     mapping(address => bool) private whitelistStage5;
2574     mapping(address => bool) private whitelistStage6;
2575     mapping(address => bool) private whitelistStage7;
2576 
2577     // Burn variable true or false if you want people to be able to burn tokens
2578     bool public isBurnEnabled = false;
2579     event ChangeBurnState(bool _isBurnEnabled);
2580 
2581     //The hash of the concatented hash string of all the images.
2582     string public provenance = '';
2583 
2584     /**
2585      * The state of the sale:
2586      * 0 = closed
2587      * 1 = EA
2588      * 2 = WL2, 3 = WL3, 4 = WL4, 5 = WL5, 6 = WL6, 7 = WL7
2589      * 8 = stage
2590      * 9 = open
2591      */
2592     uint256 public saleState = 0;
2593 
2594     constructor() 
2595         ERC721("PantheonBusinessClub", "PBC") 
2596         PaymentSplitter(_team, _teamShares) 
2597     {
2598         setBaseURI('ipfs://QmaWqGvPUVeBRfEc39RRqZ9Hm91kx4qfZiFgGS6TgPbEe7/');
2599         _safeMint(msg.sender, totalSupply());
2600     }
2601 
2602     /**
2603      * Set URL of the NFT
2604      */
2605     function setBaseURI(string memory baseURI) public onlyOwner {
2606         _setBaseURI(baseURI);
2607     }
2608 
2609     /**
2610      * Modify Shares in paymentSplitter
2611      */
2612     function modifyShares(uint256[] memory shares_) public onlyOwner {
2613         _modifyShares(_team, _team, shares_);
2614     }
2615 
2616     /**
2617      * Modify Shares and Team addresses in paymentSplitter
2618      */
2619     function modifyTeamAndShares(address[] memory oldPayees,address[] memory newPayees , uint256[] memory shares_) public onlyOwner {
2620         _modifyShares(oldPayees, newPayees, shares_);
2621         _team = newPayees;
2622     }
2623 
2624     /**
2625      * Lock or unlock the transfer of tokens
2626      */
2627     function changeSecondaryMarketState() public onlyOwner {
2628         _changeSecondaryMarketState();
2629     }
2630 
2631     /**
2632      * Modify authorized transfer whitelist
2633      */
2634     function modifyAuthorizedSellers(address[] memory addresses, bool state) public onlyOwner {
2635         _modifyAuthorizedSellers(addresses, state);
2636     }
2637 
2638     /**
2639      * retrait des eth stockés dans le smart contrat par le contract Owner
2640      */  
2641     function withdraw() public onlyOwner {
2642         uint256 balance = address(this).balance;
2643         payable(msg.sender).transfer(balance);
2644     }
2645 
2646     /**
2647      * Set some tokens aside.
2648      */
2649     function reserveTokens(uint256 number) public onlyOwner {
2650         require(
2651             totalSupply().add(number) <= MAX_TOKENS,
2652             'Reservation would exceed max supply'
2653         );
2654         uint256 i;
2655         for (i = 0; i < number; i++) {
2656             _safeMint(msg.sender, totalSupply() + i);
2657         }
2658     }
2659 
2660     /**
2661      * Ability for people to burn their tokens
2662      */
2663     function burn(uint256 tokenId) external {
2664         require(isBurnEnabled, "Pantheon: burning disabled");
2665         require(
2666             _isApprovedOrOwner(msg.sender, tokenId),
2667             "Pantheon: burn caller is not owner"
2668         );
2669         _burn(tokenId);
2670         totalSupply().sub(1);
2671     }
2672 
2673     /**
2674      * Ability for people to burn their tokens
2675      */
2676     function burnRemainingTokens(uint256 tokenNb) external onlyOwner {
2677         require(MAX_TOKENS - tokenNb >= totalSupply(), 'Invalid state');
2678         MAX_TOKENS = MAX_TOKENS - tokenNb;
2679     }
2680 
2681     /**
2682      * Set the state of the sale.
2683      */
2684     function setSaleState(uint256 newState) public onlyOwner {
2685         require(newState >= 0 && newState <= 9, 'Invalid state');
2686         saleState = newState;
2687     }
2688 
2689     function setProvenanceHash(string memory hash) public onlyOwner {
2690         provenance = hash;
2691     }
2692 
2693     function setPrice(uint256 value) public onlyOwner {
2694         nftPrice = value;
2695     }
2696     function setStage(uint256 value) public onlyOwner {
2697         stage = value;
2698     }
2699     
2700     function setBurnState(bool _isBurnEnabled) external onlyOwner {
2701         isBurnEnabled = _isBurnEnabled;
2702         emit ChangeBurnState(_isBurnEnabled);
2703     }
2704 
2705     /**
2706      * Early Access Member list for the presale
2707      */
2708     function changeEarlyAccessMembers(address[] memory addresses, bool state)
2709         public
2710         onlyOwner
2711     {
2712         for (uint256 i = 0; i < addresses.length; i++) {
2713             earlyAccessAllowList[addresses[i]] = state;
2714         }
2715     }
2716 
2717     /**
2718      * Allow users to remove themselves from the whitelist
2719      */
2720     function removeEarlyAccessMemberHimself()
2721         public
2722     {
2723         require(
2724             earlyAccessAllowList[msg.sender],
2725             'Sender is not on the early access list'
2726         );
2727         earlyAccessAllowList[msg.sender] = false;
2728     }
2729 
2730     function isWhitelistTransfer(address addr) public view returns (bool) {
2731         return _isWhitelistTransfer(addr);
2732     }
2733 
2734     /**
2735      * Whitelist functions for stages
2736      */
2737     function changeWhitelistMembersForStage(address[] memory addresses, uint256 stageNumber, bool state)
2738         public
2739         onlyOwner
2740     {
2741         if (stageNumber == 2) {
2742             for (uint256 i = 0; i < addresses.length; i++) {
2743                 whitelistStage2[addresses[i]] = state;
2744             }
2745         } else if (stageNumber == 3) {
2746             for (uint256 i = 0; i < addresses.length; i++) {
2747                 whitelistStage3[addresses[i]] = state;
2748             }
2749         } else if (stageNumber == 4) {
2750             for (uint256 i = 0; i < addresses.length; i++) {
2751                 whitelistStage4[addresses[i]] = state;
2752             }
2753         } else if (stageNumber == 5) {
2754             for (uint256 i = 0; i < addresses.length; i++) {
2755                 whitelistStage5[addresses[i]] = state;
2756             }
2757         } else if (stageNumber == 6) {
2758             for (uint256 i = 0; i < addresses.length; i++) {
2759                 whitelistStage6[addresses[i]] = state;
2760             }
2761         } else if (stageNumber == 7) {
2762             for (uint256 i = 0; i < addresses.length; i++) {
2763                 whitelistStage7[addresses[i]] = state;
2764             }
2765         }
2766     }
2767 
2768     function isWhitelistForStage(address addr, uint256 stageNumber) public view returns (bool) {
2769         if (stageNumber == 2) {
2770             return whitelistStage2[addr];
2771         } else if (stageNumber == 3) {
2772             return whitelistStage3[addr];
2773         } else if (stageNumber == 4) {
2774             return whitelistStage4[addr];
2775         } else if (stageNumber == 5) {
2776             return whitelistStage5[addr];
2777         } else if (stageNumber == 6) {
2778             return whitelistStage6[addr];
2779         } else if (stageNumber == 7) {
2780             return whitelistStage7[addr];
2781         }
2782     }
2783 
2784 
2785     function _checkEarlyAccess(address sender, uint256 numberOfTokens)
2786         internal
2787         view
2788     {
2789         uint256 supply = totalSupply();
2790         if (saleState == 1) {
2791             require(
2792                 earlyAccessAllowList[sender],
2793                 'Sender is not on the early access list'
2794             );
2795             require(
2796                 supply + numberOfTokens <= totalEarlyAccessTokensAllowed,
2797                 'Minting would exceed total allowed for early access'
2798             );
2799         } else if (saleState == 2) {
2800             require(
2801                 whitelistStage2[sender],
2802                 'Sender is not on the Whitelist'
2803             );
2804             require(
2805                 supply + numberOfTokens <= stage2,
2806                 'Minting would exceed total allowed for early access'
2807             );
2808         } else if (saleState == 3) {
2809             require(
2810                 whitelistStage3[sender],
2811                 'Sender is not on the Whitelist'
2812             );
2813             require(
2814                 supply + numberOfTokens <= stage3,
2815                 'Minting would exceed total allowed for early access'
2816             );
2817         } else if (saleState == 4) {
2818             require(
2819                 whitelistStage4[sender],
2820                 'Sender is not on the Whitelist'
2821             );
2822             require(
2823                 supply + numberOfTokens <= stage4,
2824                 'Minting would exceed total allowed for early access'
2825             );
2826         } else if (saleState == 5) {
2827             require(
2828                 whitelistStage5[sender],
2829                 'Sender is not on the early access list'
2830             );
2831             require(
2832                 supply + numberOfTokens <= stage5,
2833                 'Minting would exceed total allowed for early access'
2834             );
2835         } else if (saleState == 6) {
2836             require(
2837                 whitelistStage6[sender],
2838                 'Sender is not on the early access list'
2839             );
2840             require(
2841                 supply + numberOfTokens <= stage6,
2842                 'Minting would exceed total allowed for early access'
2843             );
2844         } else if (saleState == 7) {
2845             require(
2846                 whitelistStage7[sender],
2847                 'Sender is not on the early access list'
2848             );
2849             require(
2850                 supply + numberOfTokens <= stage7,
2851                 'Minting would exceed total allowed for early access'
2852             );
2853         }
2854     }
2855 
2856     /**
2857      * Verify if we are on the whitelist or not
2858      */
2859     function checkIfWhitelist(address addr) public view returns (bool) {
2860         return earlyAccessAllowList[addr];
2861     }
2862 
2863     /**
2864      * Number of token max you can mint with 1 transaction
2865      * You can make unlimmited number of transactions
2866      */
2867     function _checkNumberOfTokens(uint256 numberOfTokens) internal pure {
2868         require(
2869             numberOfTokens <= maxNumPurchase,
2870             'Can only mint 20 tokens at a time'
2871         ); 
2872     }
2873 
2874     /**
2875      * Mints an NFT
2876      */
2877     function mintPBC(uint256 numberOfTokens) public payable {
2878         require(
2879             saleState == 1 || saleState == 2 || saleState == 3 || saleState == 4 || saleState == 5 || saleState == 6 || saleState == 7 || saleState == 8 || saleState == 9,
2880             'Sale must be active to mint'
2881         );
2882         if (saleState == 1 || saleState == 2 || saleState == 3 || saleState == 4 || saleState == 5 || saleState == 6 || saleState == 7) {
2883             _checkEarlyAccess(msg.sender, numberOfTokens);
2884             _checkNumberOfTokens(numberOfTokens);
2885         } else if (saleState == 8) {
2886             _checkNumberOfTokens(numberOfTokens);
2887             require(
2888             totalSupply().add(numberOfTokens) <= stage,
2889             'Purchase would exceed stage supply, confirm with the project team the maximum card available for this stage'
2890             );
2891         } else if (saleState == 9) {
2892             _checkNumberOfTokens(numberOfTokens);
2893         }
2894         require(
2895             totalSupply().add(numberOfTokens) <= MAX_TOKENS,
2896             'Purchase would exceed max supply'
2897         );
2898         require(
2899             nftPrice.mul(numberOfTokens) <= msg.value,
2900             'Ether value sent is not correct'
2901         );
2902 
2903         for (uint256 i = 0; i < numberOfTokens; i++) {
2904             uint256 mintIndex = totalSupply();
2905             _safeMint(msg.sender, mintIndex);
2906         }
2907     }
2908 
2909     /**
2910      * Mint on wallet list
2911      */
2912     function mintG(address[] memory addresses, uint256 nbCard) public onlyOwner {
2913         require(
2914             totalSupply().add(addresses.length * nbCard) <= MAX_TOKENS,
2915             'Reservation would exceed max supply'
2916         );
2917         uint256 i;
2918         for (i = 0; i < addresses.length; i++) {
2919             uint256 j;
2920             for (j = 0; j < nbCard; j++) {
2921              uint256 mintIndex = totalSupply();
2922             _safeMint(addresses[i], mintIndex);
2923             }
2924         }
2925     }
2926 
2927 }