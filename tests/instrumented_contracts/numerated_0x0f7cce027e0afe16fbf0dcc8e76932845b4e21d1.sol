1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 /*                                                                                      
5 * @dev Collection of functions related to the address type
6 */
7 library Address {
8     /**
9      * @dev Returns true if `account` is a contract.
10      *
11      * [IMPORTANT]
12      * ====
13      * It is unsafe to assume that an address for which this function returns
14      * false is an externally-owned account (EOA) and not a contract.
15      *
16      * Among others, `isContract` will return false for the following
17      * types of addresses:
18      *
19      *  - an externally-owned account
20      *  - a contract in construction
21      *  - an address where a contract will be created
22      *  - an address where a contract lived, but was destroyed
23      * ====
24      *
25      * [IMPORTANT]
26      * ====
27      * You shouldn't rely on `isContract` to protect against flash loan attacks!
28      *
29      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
30      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
31      * constructor.
32      * ====
33      */
34     function isContract(address account) internal view returns (bool) {
35         // This method relies on extcodesize/address.code.length, which returns 0
36         // for contracts in construction, since the code is only stored at the end
37         // of the constructor execution.
38 
39         return account.code.length > 0;
40     }
41 
42     /**
43      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
44      * `recipient`, forwarding all available gas and reverting on errors.
45      *
46      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
47      * of certain opcodes, possibly making contracts go over the 2300 gas limit
48      * imposed by `transfer`, making them unable to receive funds via
49      * `transfer`. {sendValue} removes this limitation.
50      *
51      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
52      *
53      * IMPORTANT: because control is transferred to `recipient`, care must be
54      * taken to not create reentrancy vulnerabilities. Consider using
55      * {ReentrancyGuard} or the
56      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
57      */
58     function sendValue(address payable recipient, uint256 amount) internal {
59         require(address(this).balance >= amount, "Address: insufficient balance");
60 
61         (bool success, ) = recipient.call{value: amount}("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain `call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84         return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(
94         address target,
95         bytes memory data,
96         string memory errorMessage
97     ) internal returns (bytes memory) {
98         return functionCallWithValue(target, data, 0, errorMessage);
99     }
100 
101     /**
102      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
103      * but also transferring `value` wei to `target`.
104      *
105      * Requirements:
106      *
107      * - the calling contract must have an ETH balance of at least `value`.
108      * - the called Solidity function must be `payable`.
109      *
110      * _Available since v3.1._
111      */
112     function functionCallWithValue(
113         address target,
114         bytes memory data,
115         uint256 value
116     ) internal returns (bytes memory) {
117         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
118     }
119 
120     /**
121      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
122      * with `errorMessage` as a fallback revert reason when `target` reverts.
123      *
124      * _Available since v3.1._
125      */
126     function functionCallWithValue(
127         address target,
128         bytes memory data,
129         uint256 value,
130         string memory errorMessage
131     ) internal returns (bytes memory) {
132         require(address(this).balance >= value, "Address: insufficient balance for call");
133         require(isContract(target), "Address: call to non-contract");
134 
135         (bool success, bytes memory returndata) = target.call{value: value}(data);
136         return verifyCallResult(success, returndata, errorMessage);
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
141      * but performing a static call.
142      *
143      * _Available since v3.3._
144      */
145     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
146         return functionStaticCall(target, data, "Address: low-level static call failed");
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
151      * but performing a static call.
152      *
153      * _Available since v3.3._
154      */
155     function functionStaticCall(
156         address target,
157         bytes memory data,
158         string memory errorMessage
159     ) internal view returns (bytes memory) {
160         require(isContract(target), "Address: static call to non-contract");
161 
162         (bool success, bytes memory returndata) = target.staticcall(data);
163         return verifyCallResult(success, returndata, errorMessage);
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
168      * but performing a delegate call.
169      *
170      * _Available since v3.4._
171      */
172     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
173         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
178      * but performing a delegate call.
179      *
180      * _Available since v3.4._
181      */
182     function functionDelegateCall(
183         address target,
184         bytes memory data,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         require(isContract(target), "Address: delegate call to non-contract");
188 
189         (bool success, bytes memory returndata) = target.delegatecall(data);
190         return verifyCallResult(success, returndata, errorMessage);
191     }
192 
193     /**
194      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
195      * revert reason using the provided one.
196      *
197      * _Available since v4.3._
198      */
199     function verifyCallResult(
200         bool success,
201         bytes memory returndata,
202         string memory errorMessage
203     ) internal pure returns (bytes memory) {
204         if (success) {
205             return returndata;
206         } else {
207             // Look for revert reason and bubble it up if present
208             if (returndata.length > 0) {
209                 // The easiest way to bubble the revert reason is using memory via assembly
210                 /// @solidity memory-safe-assembly
211                 assembly {
212                     let returndata_size := mload(returndata)
213                     revert(add(32, returndata), returndata_size)
214                 }
215             } else {
216                 revert(errorMessage);
217             }
218         }
219     }
220 }
221 
222 abstract contract Context {
223     function _msgSender() internal view virtual returns (address) {
224         return msg.sender;
225     }
226 
227     function _msgData() internal view virtual returns (bytes calldata) {
228         return msg.data;
229     }
230 }
231 
232 interface IERC721A {
233     /**
234      * The caller must own the token or be an approved operator.
235      */
236     error ApprovalCallerNotOwnerNorApproved();
237 
238     /**
239      * The token does not exist.
240      */
241     error ApprovalQueryForNonexistentToken();
242 
243     /**
244      * The caller cannot approve to their own address.
245      */
246     error ApproveToCaller();
247 
248     /**
249      * Cannot query the balance for the zero address.
250      */
251     error BalanceQueryForZeroAddress();
252 
253     /**
254      * Cannot mint to the zero address.
255      */
256     error MintToZeroAddress();
257 
258     /**
259      * The quantity of tokens minted must be more than zero.
260      */
261     error MintZeroQuantity();
262 
263     /**
264      * The token does not exist.
265      */
266     error OwnerQueryForNonexistentToken();
267 
268     /**
269      * The caller must own the token or be an approved operator.
270      */
271     error TransferCallerNotOwnerNorApproved();
272 
273     /**
274      * The token must be owned by `from`.
275      */
276     error TransferFromIncorrectOwner();
277 
278     /**
279      * Cannot safely transfer to a contract that does not implement the
280      * ERC721Receiver interface.
281      */
282     error TransferToNonERC721ReceiverImplementer();
283 
284     /**
285      * Cannot transfer to the zero address.
286      */
287     error TransferToZeroAddress();
288 
289     /**
290      * The token does not exist.
291      */
292     error URIQueryForNonexistentToken();
293 
294     /**
295      * The `quantity` minted with ERC2309 exceeds the safety limit.
296      */
297     error MintERC2309QuantityExceedsLimit();
298 
299     /**
300      * The `extraData` cannot be set on an unintialized ownership slot.
301      */
302     error OwnershipNotInitializedForExtraData();
303 
304     // =============================================================
305     //                            STRUCTS
306     // =============================================================
307 
308     struct TokenOwnership {
309         // The address of the owner.
310         address addr;
311         // Stores the start time of ownership with minimal overhead for tokenomics.
312         uint64 startTimestamp;
313         // Whether the token has been burned.
314         bool burned;
315         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
316         uint24 extraData;
317     }
318 
319     // =============================================================
320     //                         TOKEN COUNTERS
321     // =============================================================
322 
323     /**
324      * @dev Returns the total number of tokens in existence.
325      * Burned tokens will reduce the count.
326      * To get the total number of tokens minted, please see {_totalMinted}.
327      */
328     function totalSupply() external view returns (uint256);
329 
330     // =============================================================
331     //                            IERC165
332     // =============================================================
333 
334     /**
335      * @dev Returns true if this contract implements the interface defined by
336      * `interfaceId`. See the corresponding
337      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
338      * to learn more about how these ids are created.
339      *
340      * This function call must use less than 30000 gas.
341      */
342     function supportsInterface(bytes4 interfaceId) external view returns (bool);
343 
344     // =============================================================
345     //                            IERC721
346     // =============================================================
347 
348     /**
349      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
350      */
351     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
352 
353     /**
354      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
355      */
356     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
357 
358     /**
359      * @dev Emitted when `owner` enables or disables
360      * (`approved`) `operator` to manage all of its assets.
361      */
362     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
363 
364     /**
365      * @dev Returns the number of tokens in `owner`'s account.
366      */
367     function balanceOf(address owner) external view returns (uint256 balance);
368 
369     /**
370      * @dev Returns the owner of the `tokenId` token.
371      *
372      * Requirements:
373      *
374      * - `tokenId` must exist.
375      */
376     function ownerOf(uint256 tokenId) external view returns (address owner);
377 
378     /**
379      * @dev Safely transfers `tokenId` token from `from` to `to`,
380      * checking first that contract recipients are aware of the ERC721 protocol
381      * to prevent tokens from being forever locked.
382      *
383      * Requirements:
384      *
385      * - `from` cannot be the zero address.
386      * - `to` cannot be the zero address.
387      * - `tokenId` token must exist and be owned by `from`.
388      * - If the caller is not `from`, it must be have been allowed to move
389      * this token by either {approve} or {setApprovalForAll}.
390      * - If `to` refers to a smart contract, it must implement
391      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
392      *
393      * Emits a {Transfer} event.
394      */
395     function safeTransferFrom(
396         address from,
397         address to,
398         uint256 tokenId,
399         bytes calldata data
400     ) external;
401 
402     /**
403      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
404      */
405     function safeTransferFrom(
406         address from,
407         address to,
408         uint256 tokenId
409     ) external;
410 
411     /**
412      * @dev Transfers `tokenId` from `from` to `to`.
413      *
414      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
415      * whenever possible.
416      *
417      * Requirements:
418      *
419      * - `from` cannot be the zero address.
420      * - `to` cannot be the zero address.
421      * - `tokenId` token must be owned by `from`.
422      * - If the caller is not `from`, it must be approved to move this token
423      * by either {approve} or {setApprovalForAll}.
424      *
425      * Emits a {Transfer} event.
426      */
427     function transferFrom(
428         address from,
429         address to,
430         uint256 tokenId
431     ) external;
432 
433     /**
434      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
435      * The approval is cleared when the token is transferred.
436      *
437      * Only a single account can be approved at a time, so approving the
438      * zero address clears previous approvals.
439      *
440      * Requirements:
441      *
442      * - The caller must own the token or be an approved operator.
443      * - `tokenId` must exist.
444      *
445      * Emits an {Approval} event.
446      */
447     function approve(address to, uint256 tokenId) external;
448 
449     /**
450      * @dev Approve or remove `operator` as an operator for the caller.
451      * Operators can call {transferFrom} or {safeTransferFrom}
452      * for any token owned by the caller.
453      *
454      * Requirements:
455      *
456      * - The `operator` cannot be the caller.
457      *
458      * Emits an {ApprovalForAll} event.
459      */
460     function setApprovalForAll(address operator, bool _approved) external;
461 
462     /**
463      * @dev Returns the account approved for `tokenId` token.
464      *
465      * Requirements:
466      *
467      * - `tokenId` must exist.
468      */
469     function getApproved(uint256 tokenId) external view returns (address operator);
470 
471     /**
472      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
473      *
474      * See {setApprovalForAll}.
475      */
476     function isApprovedForAll(address owner, address operator) external view returns (bool);
477 
478     // =============================================================
479     //                        IERC721Metadata
480     // =============================================================
481 
482     /**
483      * @dev Returns the token collection name.
484      */
485     function name() external view returns (string memory);
486 
487     /**
488      * @dev Returns the token collection symbol.
489      */
490     function symbol() external view returns (string memory);
491 
492     /**
493      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
494      */
495     function tokenURI(uint256 tokenId) external view returns (string memory);
496 
497     // =============================================================
498     //                           IERC2309
499     // =============================================================
500 
501     /**
502      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
503      * (inclusive) is transferred from `from` to `to`, as defined in the
504      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
505      *
506      * See {_mintERC2309} for more details.
507      */
508     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
509 }
510 
511 interface IERC20Permit {
512     /**
513      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
514      * given ``owner``'s signed approval.
515      *
516      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
517      * ordering also apply here.
518      *
519      * Emits an {Approval} event.
520      *
521      * Requirements:
522      *
523      * - `spender` cannot be the zero address.
524      * - `deadline` must be a timestamp in the future.
525      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
526      * over the EIP712-formatted function arguments.
527      * - the signature must use ``owner``'s current nonce (see {nonces}).
528      *
529      * For more information on the signature format, see the
530      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
531      * section].
532      */
533     function permit(
534         address owner,
535         address spender,
536         uint256 value,
537         uint256 deadline,
538         uint8 v,
539         bytes32 r,
540         bytes32 s
541     ) external;
542 
543     /**
544      * @dev Returns the current nonce for `owner`. This value must be
545      * included whenever a signature is generated for {permit}.
546      *
547      * Every successful call to {permit} increases ``owner``'s nonce by one. This
548      * prevents a signature from being used multiple times.
549      */
550     function nonces(address owner) external view returns (uint256);
551 
552     /**
553      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
554      */
555     // solhint-disable-next-line func-name-mixedcase
556     function DOMAIN_SEPARATOR() external view returns (bytes32);
557 }
558 
559 interface IERC20 {
560     /**
561      * @dev Emitted when `value` tokens are moved from one account (`from`) to
562      * another (`to`).
563      *
564      * Note that `value` may be zero.
565      */
566     event Transfer(address indexed from, address indexed to, uint256 value);
567 
568     /**
569      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
570      * a call to {approve}. `value` is the new allowance.
571      */
572     event Approval(address indexed owner, address indexed spender, uint256 value);
573 
574     /**
575      * @dev Returns the amount of tokens in existence.
576      */
577     function totalSupply() external view returns (uint256);
578 
579     /**
580      * @dev Returns the amount of tokens owned by `account`.
581      */
582     function balanceOf(address account) external view returns (uint256);
583 
584     /**
585      * @dev Moves `amount` tokens from the caller's account to `to`.
586      *
587      * Returns a boolean value indicating whether the operation succeeded.
588      *
589      * Emits a {Transfer} event.
590      */
591     function transfer(address to, uint256 amount) external returns (bool);
592 
593     /**
594      * @dev Returns the remaining number of tokens that `spender` will be
595      * allowed to spend on behalf of `owner` through {transferFrom}. This is
596      * zero by default.
597      *
598      * This value changes when {approve} or {transferFrom} are called.
599      */
600     function allowance(address owner, address spender) external view returns (uint256);
601 
602     /**
603      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
604      *
605      * Returns a boolean value indicating whether the operation succeeded.
606      *
607      * IMPORTANT: Beware that changing an allowance with this method brings the risk
608      * that someone may use both the old and the new allowance by unfortunate
609      * transaction ordering. One possible solution to mitigate this race
610      * condition is to first reduce the spender's allowance to 0 and set the
611      * desired value afterwards:
612      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
613      *
614      * Emits an {Approval} event.
615      */
616     function approve(address spender, uint256 amount) external returns (bool);
617 
618     /**
619      * @dev Moves `amount` tokens from `from` to `to` using the
620      * allowance mechanism. `amount` is then deducted from the caller's
621      * allowance.
622      *
623      * Returns a boolean value indicating whether the operation succeeded.
624      *
625      * Emits a {Transfer} event.
626      */
627     function transferFrom(
628         address from,
629         address to,
630         uint256 amount
631     ) external returns (bool);
632 }
633 
634 library SafeERC20 {
635     using Address for address;
636 
637     function safeTransfer(
638         IERC20 token,
639         address to,
640         uint256 value
641     ) internal {
642         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
643     }
644 
645     function safeTransferFrom(
646         IERC20 token,
647         address from,
648         address to,
649         uint256 value
650     ) internal {
651         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
652     }
653 
654     /**
655      * @dev Deprecated. This function has issues similar to the ones found in
656      * {IERC20-approve}, and its usage is discouraged.
657      *
658      * Whenever possible, use {safeIncreaseAllowance} and
659      * {safeDecreaseAllowance} instead.
660      */
661     function safeApprove(
662         IERC20 token,
663         address spender,
664         uint256 value
665     ) internal {
666         // safeApprove should only be called when setting an initial allowance,
667         // or when resetting it to zero. To increase and decrease it, use
668         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
669         require(
670             (value == 0) || (token.allowance(address(this), spender) == 0),
671             "SafeERC20: approve from non-zero to non-zero allowance"
672         );
673         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
674     }
675 
676     function safeIncreaseAllowance(
677         IERC20 token,
678         address spender,
679         uint256 value
680     ) internal {
681         uint256 newAllowance = token.allowance(address(this), spender) + value;
682         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
683     }
684 
685     function safeDecreaseAllowance(
686         IERC20 token,
687         address spender,
688         uint256 value
689     ) internal {
690         unchecked {
691             uint256 oldAllowance = token.allowance(address(this), spender);
692             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
693             uint256 newAllowance = oldAllowance - value;
694             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
695         }
696     }
697 
698     function safePermit(
699         IERC20Permit token,
700         address owner,
701         address spender,
702         uint256 value,
703         uint256 deadline,
704         uint8 v,
705         bytes32 r,
706         bytes32 s
707     ) internal {
708         uint256 nonceBefore = token.nonces(owner);
709         token.permit(owner, spender, value, deadline, v, r, s);
710         uint256 nonceAfter = token.nonces(owner);
711         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
712     }
713 
714     /**
715      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
716      * on the return value: the return value is optional (but if data is returned, it must not be false).
717      * @param token The token targeted by the call.
718      * @param data The call data (encoded using abi.encode or one of its variants).
719      */
720     function _callOptionalReturn(IERC20 token, bytes memory data) private {
721         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
722         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
723         // the target address contains contract code and also asserts for success in the low-level call.
724 
725         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
726         if (returndata.length > 0) {
727             // Return data is optional
728             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
729         }
730     }
731 }
732 
733 library Strings {
734     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
735     uint8 private constant _ADDRESS_LENGTH = 20;
736 
737     /**
738      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
739      */
740     function toString(uint256 value) internal pure returns (string memory) {
741         // Inspired by OraclizeAPI's implementation - MIT licence
742         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
743 
744         if (value == 0) {
745             return "0";
746         }
747         uint256 temp = value;
748         uint256 digits;
749         while (temp != 0) {
750             digits++;
751             temp /= 10;
752         }
753         bytes memory buffer = new bytes(digits);
754         while (value != 0) {
755             digits -= 1;
756             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
757             value /= 10;
758         }
759         return string(buffer);
760     }
761 
762     /**
763      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
764      */
765     function toHexString(uint256 value) internal pure returns (string memory) {
766         if (value == 0) {
767             return "0x00";
768         }
769         uint256 temp = value;
770         uint256 length = 0;
771         while (temp != 0) {
772             length++;
773             temp >>= 8;
774         }
775         return toHexString(value, length);
776     }
777 
778     /**
779      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
780      */
781     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
782         bytes memory buffer = new bytes(2 * length + 2);
783         buffer[0] = "0";
784         buffer[1] = "x";
785         for (uint256 i = 2 * length + 1; i > 1; --i) {
786             buffer[i] = _HEX_SYMBOLS[value & 0xf];
787             value >>= 4;
788         }
789         require(value == 0, "Strings: hex length insufficient");
790         return string(buffer);
791     }
792 
793     /**
794      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
795      */
796     function toHexString(address addr) internal pure returns (string memory) {
797         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
798     }
799 }
800 
801 abstract contract Ownable is Context {
802     address private _owner;
803 
804     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
805 
806     /**
807      * @dev Initializes the contract setting the deployer as the initial owner.
808      */
809     constructor() {
810         _transferOwnership(_msgSender());
811     }
812 
813     /**
814      * @dev Throws if called by any account other than the owner.
815      */
816     modifier onlyOwner() {
817         _checkOwner();
818         _;
819     }
820 
821     /**
822      * @dev Returns the address of the current owner.
823      */
824     function owner() public view virtual returns (address) {
825         return _owner;
826     }
827 
828     /**
829      * @dev Throws if the sender is not the owner.
830      */
831     function _checkOwner() internal view virtual {
832         require(owner() == _msgSender(), "Ownable: caller is not the owner");
833     }
834 
835     /**
836      * @dev Leaves the contract without owner. It will not be possible to call
837      * `onlyOwner` functions anymore. Can only be called by the current owner.
838      *
839      * NOTE: Renouncing ownership will leave the contract without an owner,
840      * thereby removing any functionality that is only available to the owner.
841      */
842     function renounceOwnership() public virtual onlyOwner {
843         _transferOwnership(address(0));
844     }
845 
846     /**
847      * @dev Transfers ownership of the contract to a new account (`newOwner`).
848      * Can only be called by the current owner.
849      */
850     function transferOwnership(address newOwner) public virtual onlyOwner {
851         require(newOwner != address(0), "Ownable: new owner is the zero address");
852         _transferOwnership(newOwner);
853     }
854 
855     /**
856      * @dev Transfers ownership of the contract to a new account (`newOwner`).
857      * Internal function without access restriction.
858      */
859     function _transferOwnership(address newOwner) internal virtual {
860         address oldOwner = _owner;
861         _owner = newOwner;
862         emit OwnershipTransferred(oldOwner, newOwner);
863     }
864 }
865 
866 library ECDSA {
867     enum RecoverError {
868         NoError,
869         InvalidSignature,
870         InvalidSignatureLength,
871         InvalidSignatureS,
872         InvalidSignatureV
873     }
874 
875     function _throwError(RecoverError error) private pure {
876         if (error == RecoverError.NoError) {
877             return; // no error: do nothing
878         } else if (error == RecoverError.InvalidSignature) {
879             revert("ECDSA: invalid signature");
880         } else if (error == RecoverError.InvalidSignatureLength) {
881             revert("ECDSA: invalid signature length");
882         } else if (error == RecoverError.InvalidSignatureS) {
883             revert("ECDSA: invalid signature 's' value");
884         } else if (error == RecoverError.InvalidSignatureV) {
885             revert("ECDSA: invalid signature 'v' value");
886         }
887     }
888 
889     /**
890      * @dev Returns the address that signed a hashed message (`hash`) with
891      * `signature` or error string. This address can then be used for verification purposes.
892      *
893      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
894      * this function rejects them by requiring the `s` value to be in the lower
895      * half order, and the `v` value to be either 27 or 28.
896      *
897      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
898      * verification to be secure: it is possible to craft signatures that
899      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
900      * this is by receiving a hash of the original message (which may otherwise
901      * be too long), and then calling {toEthSignedMessageHash} on it.
902      *
903      * Documentation for signature generation:
904      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
905      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
906      *
907      * _Available since v4.3._
908      */
909     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
910         // Check the signature length
911         // - case 65: r,s,v signature (standard)
912         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
913         if (signature.length == 65) {
914             bytes32 r;
915             bytes32 s;
916             uint8 v;
917             // ecrecover takes the signature parameters, and the only way to get them
918             // currently is to use assembly.
919             /// @solidity memory-safe-assembly
920             assembly {
921                 r := mload(add(signature, 0x20))
922                 s := mload(add(signature, 0x40))
923                 v := byte(0, mload(add(signature, 0x60)))
924             }
925             return tryRecover(hash, v, r, s);
926         } else if (signature.length == 64) {
927             bytes32 r;
928             bytes32 vs;
929             // ecrecover takes the signature parameters, and the only way to get them
930             // currently is to use assembly.
931             /// @solidity memory-safe-assembly
932             assembly {
933                 r := mload(add(signature, 0x20))
934                 vs := mload(add(signature, 0x40))
935             }
936             return tryRecover(hash, r, vs);
937         } else {
938             return (address(0), RecoverError.InvalidSignatureLength);
939         }
940     }
941 
942     /**
943      * @dev Returns the address that signed a hashed message (`hash`) with
944      * `signature`. This address can then be used for verification purposes.
945      *
946      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
947      * this function rejects them by requiring the `s` value to be in the lower
948      * half order, and the `v` value to be either 27 or 28.
949      *
950      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
951      * verification to be secure: it is possible to craft signatures that
952      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
953      * this is by receiving a hash of the original message (which may otherwise
954      * be too long), and then calling {toEthSignedMessageHash} on it.
955      */
956     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
957         (address recovered, RecoverError error) = tryRecover(hash, signature);
958         _throwError(error);
959         return recovered;
960     }
961 
962     /**
963      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
964      *
965      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
966      *
967      * _Available since v4.3._
968      */
969     function tryRecover(
970         bytes32 hash,
971         bytes32 r,
972         bytes32 vs
973     ) internal pure returns (address, RecoverError) {
974         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
975         uint8 v = uint8((uint256(vs) >> 255) + 27);
976         return tryRecover(hash, v, r, s);
977     }
978 
979     /**
980      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
981      *
982      * _Available since v4.2._
983      */
984     function recover(
985         bytes32 hash,
986         bytes32 r,
987         bytes32 vs
988     ) internal pure returns (address) {
989         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
990         _throwError(error);
991         return recovered;
992     }
993 
994     /**
995      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
996      * `r` and `s` signature fields separately.
997      *
998      * _Available since v4.3._
999      */
1000     function tryRecover(
1001         bytes32 hash,
1002         uint8 v,
1003         bytes32 r,
1004         bytes32 s
1005     ) internal pure returns (address, RecoverError) {
1006         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1007         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1008         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1009         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1010         //
1011         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1012         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1013         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1014         // these malleable signatures as well.
1015         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1016             return (address(0), RecoverError.InvalidSignatureS);
1017         }
1018         if (v != 27 && v != 28) {
1019             return (address(0), RecoverError.InvalidSignatureV);
1020         }
1021 
1022         // If the signature is valid (and not malleable), return the signer address
1023         address signer = ecrecover(hash, v, r, s);
1024         if (signer == address(0)) {
1025             return (address(0), RecoverError.InvalidSignature);
1026         }
1027 
1028         return (signer, RecoverError.NoError);
1029     }
1030 
1031     /**
1032      * @dev Overload of {ECDSA-recover} that receives the `v`,
1033      * `r` and `s` signature fields separately.
1034      */
1035     function recover(
1036         bytes32 hash,
1037         uint8 v,
1038         bytes32 r,
1039         bytes32 s
1040     ) internal pure returns (address) {
1041         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1042         _throwError(error);
1043         return recovered;
1044     }
1045 
1046     /**
1047      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1048      * produces hash corresponding to the one signed with the
1049      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1050      * JSON-RPC method as part of EIP-191.
1051      *
1052      * See {recover}.
1053      */
1054     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1055         // 32 is the length in bytes of hash,
1056         // enforced by the type signature above
1057         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1058     }
1059 
1060     /**
1061      * @dev Returns an Ethereum Signed Message, created from `s`. This
1062      * produces hash corresponding to the one signed with the
1063      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1064      * JSON-RPC method as part of EIP-191.
1065      *
1066      * See {recover}.
1067      */
1068     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1069         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1070     }
1071 
1072     /**
1073      * @dev Returns an Ethereum Signed Typed Data, created from a
1074      * `domainSeparator` and a `structHash`. This produces hash corresponding
1075      * to the one signed with the
1076      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1077      * JSON-RPC method as part of EIP-712.
1078      *
1079      * See {recover}.
1080      */
1081     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1082         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1083     }
1084 }
1085 
1086 /**
1087  * @dev Interface of ERC721 token receiver.
1088  */
1089 interface ERC721A__IERC721Receiver {
1090     function onERC721Received(
1091         address operator,
1092         address from,
1093         uint256 tokenId,
1094         bytes calldata data
1095     ) external returns (bytes4);
1096 }
1097 
1098 /**
1099  * @dev Interface of ERC721AQueryable.
1100  */
1101 interface IERC721AQueryable is IERC721A {
1102     /**
1103      * Invalid query range (`start` >= `stop`).
1104      */
1105     error InvalidQueryRange();
1106 
1107     /**
1108      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1109      *
1110      * If the `tokenId` is out of bounds:
1111      *
1112      * - `addr = address(0)`
1113      * - `startTimestamp = 0`
1114      * - `burned = false`
1115      * - `extraData = 0`
1116      *
1117      * If the `tokenId` is burned:
1118      *
1119      * - `addr = <Address of owner before token was burned>`
1120      * - `startTimestamp = <Timestamp when token was burned>`
1121      * - `burned = true`
1122      * - `extraData = <Extra data when token was burned>`
1123      *
1124      * Otherwise:
1125      *
1126      * - `addr = <Address of owner>`
1127      * - `startTimestamp = <Timestamp of start of ownership>`
1128      * - `burned = false`
1129      * - `extraData = <Extra data at start of ownership>`
1130      */
1131     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1132 
1133     /**
1134      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1135      * See {ERC721AQueryable-explicitOwnershipOf}
1136      */
1137     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1138 
1139     /**
1140      * @dev Returns an array of token IDs owned by `owner`,
1141      * in the range [`start`, `stop`)
1142      * (i.e. `start <= tokenId < stop`).
1143      *
1144      * This function allows for tokens to be queried if the collection
1145      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1146      *
1147      * Requirements:
1148      *
1149      * - `start < stop`
1150      */
1151     function tokensOfOwnerIn(
1152         address owner,
1153         uint256 start,
1154         uint256 stop
1155     ) external view returns (uint256[] memory);
1156 
1157     /**
1158      * @dev Returns an array of token IDs owned by `owner`.
1159      *
1160      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1161      * It is meant to be called off-chain.
1162      *
1163      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1164      * multiple smaller scans if the collection is large enough to cause
1165      * an out-of-gas error (10K collections should be fine).
1166      */
1167     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1168 }
1169 
1170 /**
1171  * @title ERC721A
1172  *
1173  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1174  * Non-Fungible Token Standard, including the Metadata extension.
1175  * Optimized for lower gas during batch mints.
1176  *
1177  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1178  * starting from `_startTokenId()`.
1179  *
1180  * Assumptions:
1181  *
1182  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1183  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1184  */
1185 contract ERC721A is IERC721A {
1186     // Reference type for token approval.
1187     struct TokenApprovalRef {
1188         address value;
1189     }
1190 
1191     // =============================================================
1192     //                           CONSTANTS
1193     // =============================================================
1194 
1195     // Mask of an entry in packed address data.
1196     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1197 
1198     // The bit position of `numberMinted` in packed address data.
1199     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1200 
1201     // The bit position of `numberBurned` in packed address data.
1202     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1203 
1204     // The bit position of `aux` in packed address data.
1205     uint256 private constant _BITPOS_AUX = 192;
1206 
1207     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1208     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1209 
1210     // The bit position of `startTimestamp` in packed ownership.
1211     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1212 
1213     // The bit mask of the `burned` bit in packed ownership.
1214     uint256 private constant _BITMASK_BURNED = 1 << 224;
1215 
1216     // The bit position of the `nextInitialized` bit in packed ownership.
1217     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1218 
1219     // The bit mask of the `nextInitialized` bit in packed ownership.
1220     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1221 
1222     // The bit position of `extraData` in packed ownership.
1223     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1224 
1225     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1226     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1227 
1228     // The mask of the lower 160 bits for addresses.
1229     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1230 
1231     // The maximum `quantity` that can be minted with {_mintERC2309}.
1232     // This limit is to prevent overflows on the address data entries.
1233     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1234     // is required to cause an overflow, which is unrealistic.
1235     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1236 
1237     // The `Transfer` event signature is given by:
1238     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1239     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1240         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1241 
1242     // =============================================================
1243     //                            STORAGE
1244     // =============================================================
1245 
1246     // The next token ID to be minted.
1247     uint256 private _currentIndex;
1248 
1249     // The number of tokens burned.
1250     uint256 private _burnCounter;
1251 
1252     // Token name
1253     string private _name;
1254 
1255     // Token symbol
1256     string private _symbol;
1257 
1258     // Mapping from token ID to ownership details
1259     // An empty struct value does not necessarily mean the token is unowned.
1260     // See {_packedOwnershipOf} implementation for details.
1261     //
1262     // Bits Layout:
1263     // - [0..159]   `addr`
1264     // - [160..223] `startTimestamp`
1265     // - [224]      `burned`
1266     // - [225]      `nextInitialized`
1267     // - [232..255] `extraData`
1268     mapping(uint256 => uint256) private _packedOwnerships;
1269 
1270     // Mapping owner address to address data.
1271     //
1272     // Bits Layout:
1273     // - [0..63]    `balance`
1274     // - [64..127]  `numberMinted`
1275     // - [128..191] `numberBurned`
1276     // - [192..255] `aux`
1277     mapping(address => uint256) private _packedAddressData;
1278 
1279     // Mapping from token ID to approved address.
1280     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1281 
1282     // Mapping from owner to operator approvals
1283     mapping(address => mapping(address => bool)) private _operatorApprovals;
1284 
1285     // =============================================================
1286     //                          CONSTRUCTOR
1287     // =============================================================
1288 
1289     constructor(string memory name_, string memory symbol_) {
1290         _name = name_;
1291         _symbol = symbol_;
1292         _currentIndex = _startTokenId();
1293     }
1294 
1295     // =============================================================
1296     //                   TOKEN COUNTING OPERATIONS
1297     // =============================================================
1298 
1299     /**
1300      * @dev Returns the starting token ID.
1301      * To change the starting token ID, please override this function.
1302      */
1303     function _startTokenId() internal view virtual returns (uint256) {
1304         return 1;
1305     }
1306 
1307     /**
1308      * @dev Returns the next token ID to be minted.
1309      */
1310     function _nextTokenId() internal view virtual returns (uint256) {
1311         return _currentIndex;
1312     }
1313 
1314     /**
1315      * @dev Returns the total number of tokens in existence.
1316      * Burned tokens will reduce the count.
1317      * To get the total number of tokens minted, please see {_totalMinted}.
1318      */
1319     function totalSupply() public view virtual override returns (uint256) {
1320         // Counter underflow is impossible as _burnCounter cannot be incremented
1321         // more than `_currentIndex - _startTokenId()` times.
1322         unchecked {
1323             return _currentIndex - _burnCounter - _startTokenId();
1324         }
1325     }
1326 
1327     /**
1328      * @dev Returns the total amount of tokens minted in the contract.
1329      */
1330     function _totalMinted() internal view virtual returns (uint256) {
1331         // Counter underflow is impossible as `_currentIndex` does not decrement,
1332         // and it is initialized to `_startTokenId()`.
1333         unchecked {
1334             return _currentIndex - _startTokenId();
1335         }
1336     }
1337 
1338     /**
1339      * @dev Returns the total number of tokens burned.
1340      */
1341     function _totalBurned() internal view virtual returns (uint256) {
1342         return _burnCounter;
1343     }
1344 
1345     // =============================================================
1346     //                    ADDRESS DATA OPERATIONS
1347     // =============================================================
1348 
1349     /**
1350      * @dev Returns the number of tokens in `owner`'s account.
1351      */
1352     function balanceOf(address owner) public view virtual override returns (uint256) {
1353         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1354         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1355     }
1356 
1357     /**
1358      * Returns the number of tokens minted by `owner`.
1359      */
1360     function _numberMinted(address owner) internal view returns (uint256) {
1361         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1362     }
1363 
1364     /**
1365      * Returns the number of tokens burned by or on behalf of `owner`.
1366      */
1367     function _numberBurned(address owner) internal view returns (uint256) {
1368         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1369     }
1370 
1371     /**
1372      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1373      */
1374     function _getAux(address owner) internal view returns (uint64) {
1375         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1376     }
1377 
1378     /**
1379      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1380      * If there are multiple variables, please pack them into a uint64.
1381      */
1382     function _setAux(address owner, uint64 aux) internal virtual {
1383         uint256 packed = _packedAddressData[owner];
1384         uint256 auxCasted;
1385         // Cast `aux` with assembly to avoid redundant masking.
1386         assembly {
1387             auxCasted := aux
1388         }
1389         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1390         _packedAddressData[owner] = packed;
1391     }
1392 
1393     // =============================================================
1394     //                            IERC165
1395     // =============================================================
1396 
1397     /**
1398      * @dev Returns true if this contract implements the interface defined by
1399      * `interfaceId`. See the corresponding
1400      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1401      * to learn more about how these ids are created.
1402      *
1403      * This function call must use less than 30000 gas.
1404      */
1405     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1406         // The interface IDs are constants representing the first 4 bytes
1407         // of the XOR of all function selectors in the interface.
1408         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1409         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1410         return
1411             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1412             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1413             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1414     }
1415 
1416     // =============================================================
1417     //                        IERC721Metadata
1418     // =============================================================
1419 
1420     /**
1421      * @dev Returns the token collection name.
1422      */
1423     function name() public view virtual override returns (string memory) {
1424         return _name;
1425     }
1426 
1427     /**
1428      * @dev Returns the token collection symbol.
1429      */
1430     function symbol() public view virtual override returns (string memory) {
1431         return _symbol;
1432     }
1433 
1434     /**
1435      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1436      */
1437     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1438         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1439 
1440         string memory baseURI = _baseURI();
1441         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1442     }
1443 
1444     /**
1445      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1446      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1447      * by default, it can be overridden in child contracts.
1448      */
1449     function _baseURI() internal view virtual returns (string memory) {
1450         return '';
1451     }
1452 
1453     // =============================================================
1454     //                     OWNERSHIPS OPERATIONS
1455     // =============================================================
1456 
1457     /**
1458      * @dev Returns the owner of the `tokenId` token.
1459      *
1460      * Requirements:
1461      *
1462      * - `tokenId` must exist.
1463      */
1464     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1465         return address(uint160(_packedOwnershipOf(tokenId)));
1466     }
1467 
1468     /**
1469      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1470      * It gradually moves to O(1) as tokens get transferred around over time.
1471      */
1472     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1473         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1474     }
1475 
1476     /**
1477      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1478      */
1479     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1480         return _unpackedOwnership(_packedOwnerships[index]);
1481     }
1482 
1483     /**
1484      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1485      */
1486     function _initializeOwnershipAt(uint256 index) internal virtual {
1487         if (_packedOwnerships[index] == 0) {
1488             _packedOwnerships[index] = _packedOwnershipOf(index);
1489         }
1490     }
1491 
1492     /**
1493      * Returns the packed ownership data of `tokenId`.
1494      */
1495     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1496         uint256 curr = tokenId;
1497 
1498         unchecked {
1499             if (_startTokenId() <= curr)
1500                 if (curr < _currentIndex) {
1501                     uint256 packed = _packedOwnerships[curr];
1502                     // If not burned.
1503                     if (packed & _BITMASK_BURNED == 0) {
1504                         // Invariant:
1505                         // There will always be an initialized ownership slot
1506                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1507                         // before an unintialized ownership slot
1508                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1509                         // Hence, `curr` will not underflow.
1510                         //
1511                         // We can directly compare the packed value.
1512                         // If the address is zero, packed will be zero.
1513                         while (packed == 0) {
1514                             packed = _packedOwnerships[--curr];
1515                         }
1516                         return packed;
1517                     }
1518                 }
1519         }
1520         revert OwnerQueryForNonexistentToken();
1521     }
1522 
1523     /**
1524      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1525      */
1526     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1527         ownership.addr = address(uint160(packed));
1528         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1529         ownership.burned = packed & _BITMASK_BURNED != 0;
1530         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1531     }
1532 
1533     /**
1534      * @dev Packs ownership data into a single uint256.
1535      */
1536     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1537         assembly {
1538             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1539             owner := and(owner, _BITMASK_ADDRESS)
1540             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1541             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1542         }
1543     }
1544 
1545     /**
1546      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1547      */
1548     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1549         // For branchless setting of the `nextInitialized` flag.
1550         assembly {
1551             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1552             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1553         }
1554     }
1555 
1556     // =============================================================
1557     //                      APPROVAL OPERATIONS
1558     // =============================================================
1559 
1560     /**
1561      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1562      * The approval is cleared when the token is transferred.
1563      *
1564      * Only a single account can be approved at a time, so approving the
1565      * zero address clears previous approvals.
1566      *
1567      * Requirements:
1568      *
1569      * - The caller must own the token or be an approved operator.
1570      * - `tokenId` must exist.
1571      *
1572      * Emits an {Approval} event.
1573      */
1574     function approve(address to, uint256 tokenId) public virtual override {
1575         address owner = ownerOf(tokenId);
1576 
1577         if (_msgSenderERC721A() != owner)
1578             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1579                 revert ApprovalCallerNotOwnerNorApproved();
1580             }
1581 
1582         _tokenApprovals[tokenId].value = to;
1583         emit Approval(owner, to, tokenId);
1584     }
1585 
1586     /**
1587      * @dev Returns the account approved for `tokenId` token.
1588      *
1589      * Requirements:
1590      *
1591      * - `tokenId` must exist.
1592      */
1593     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1594         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1595 
1596         return _tokenApprovals[tokenId].value;
1597     }
1598 
1599     /**
1600      * @dev Approve or remove `operator` as an operator for the caller.
1601      * Operators can call {transferFrom} or {safeTransferFrom}
1602      * for any token owned by the caller.
1603      *
1604      * Requirements:
1605      *
1606      * - The `operator` cannot be the caller.
1607      *
1608      * Emits an {ApprovalForAll} event.
1609      */
1610     function setApprovalForAll(address operator, bool approved) public virtual override {
1611         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1612 
1613         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1614         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1615     }
1616 
1617     /**
1618      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1619      *
1620      * See {setApprovalForAll}.
1621      */
1622     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1623         return _operatorApprovals[owner][operator];
1624     }
1625 
1626     /**
1627      * @dev Returns whether `tokenId` exists.
1628      *
1629      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1630      *
1631      * Tokens start existing when they are minted. See {_mint}.
1632      */
1633     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1634         return
1635             _startTokenId() <= tokenId &&
1636             tokenId < _currentIndex && // If within bounds,
1637             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1638     }
1639 
1640     /**
1641      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1642      */
1643     function _isSenderApprovedOrOwner(
1644         address approvedAddress,
1645         address owner,
1646         address msgSender
1647     ) private pure returns (bool result) {
1648         assembly {
1649             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1650             owner := and(owner, _BITMASK_ADDRESS)
1651             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1652             msgSender := and(msgSender, _BITMASK_ADDRESS)
1653             // `msgSender == owner || msgSender == approvedAddress`.
1654             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1655         }
1656     }
1657 
1658     /**
1659      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1660      */
1661     function _getApprovedSlotAndAddress(uint256 tokenId)
1662         private
1663         view
1664         returns (uint256 approvedAddressSlot, address approvedAddress)
1665     {
1666         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1667         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1668         assembly {
1669             approvedAddressSlot := tokenApproval.slot
1670             approvedAddress := sload(approvedAddressSlot)
1671         }
1672     }
1673 
1674     // =============================================================
1675     //                      TRANSFER OPERATIONS
1676     // =============================================================
1677 
1678     /**
1679      * @dev Transfers `tokenId` from `from` to `to`.
1680      *
1681      * Requirements:
1682      *
1683      * - `from` cannot be the zero address.
1684      * - `to` cannot be the zero address.
1685      * - `tokenId` token must be owned by `from`.
1686      * - If the caller is not `from`, it must be approved to move this token
1687      * by either {approve} or {setApprovalForAll}.
1688      *
1689      * Emits a {Transfer} event.
1690      */
1691     function transferFrom(
1692         address from,
1693         address to,
1694         uint256 tokenId
1695     ) public virtual override {
1696         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1697 
1698         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1699 
1700         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1701 
1702         // The nested ifs save around 20+ gas over a compound boolean condition.
1703         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1704             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1705 
1706         if (to == address(0)) revert TransferToZeroAddress();
1707 
1708         _beforeTokenTransfers(from, to, tokenId, 1);
1709 
1710         // Clear approvals from the previous owner.
1711         assembly {
1712             if approvedAddress {
1713                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1714                 sstore(approvedAddressSlot, 0)
1715             }
1716         }
1717 
1718         // Underflow of the sender's balance is impossible because we check for
1719         // ownership above and the recipient's balance can't realistically overflow.
1720         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1721         unchecked {
1722             // We can directly increment and decrement the balances.
1723             --_packedAddressData[from]; // Updates: `balance -= 1`.
1724             ++_packedAddressData[to]; // Updates: `balance += 1`.
1725 
1726             // Updates:
1727             // - `address` to the next owner.
1728             // - `startTimestamp` to the timestamp of transfering.
1729             // - `burned` to `false`.
1730             // - `nextInitialized` to `true`.
1731             _packedOwnerships[tokenId] = _packOwnershipData(
1732                 to,
1733                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1734             );
1735 
1736             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1737             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1738                 uint256 nextTokenId = tokenId + 1;
1739                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1740                 if (_packedOwnerships[nextTokenId] == 0) {
1741                     // If the next slot is within bounds.
1742                     if (nextTokenId != _currentIndex) {
1743                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1744                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1745                     }
1746                 }
1747             }
1748         }
1749 
1750         emit Transfer(from, to, tokenId);
1751         _afterTokenTransfers(from, to, tokenId, 1);
1752     }
1753 
1754     /**
1755      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1756      */
1757     function safeTransferFrom(
1758         address from,
1759         address to,
1760         uint256 tokenId
1761     ) public virtual override {
1762         safeTransferFrom(from, to, tokenId, '');
1763     }
1764 
1765     /**
1766      * @dev Safely transfers `tokenId` token from `from` to `to`.
1767      *
1768      * Requirements:
1769      *
1770      * - `from` cannot be the zero address.
1771      * - `to` cannot be the zero address.
1772      * - `tokenId` token must exist and be owned by `from`.
1773      * - If the caller is not `from`, it must be approved to move this token
1774      * by either {approve} or {setApprovalForAll}.
1775      * - If `to` refers to a smart contract, it must implement
1776      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1777      *
1778      * Emits a {Transfer} event.
1779      */
1780     function safeTransferFrom(
1781         address from,
1782         address to,
1783         uint256 tokenId,
1784         bytes memory _data
1785     ) public virtual override {
1786         transferFrom(from, to, tokenId);
1787         if (to.code.length != 0)
1788             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1789                 revert TransferToNonERC721ReceiverImplementer();
1790             }
1791     }
1792 
1793     /**
1794      * @dev Hook that is called before a set of serially-ordered token IDs
1795      * are about to be transferred. This includes minting.
1796      * And also called before burning one token.
1797      *
1798      * `startTokenId` - the first token ID to be transferred.
1799      * `quantity` - the amount to be transferred.
1800      *
1801      * Calling conditions:
1802      *
1803      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1804      * transferred to `to`.
1805      * - When `from` is zero, `tokenId` will be minted for `to`.
1806      * - When `to` is zero, `tokenId` will be burned by `from`.
1807      * - `from` and `to` are never both zero.
1808      */
1809     function _beforeTokenTransfers(
1810         address from,
1811         address to,
1812         uint256 startTokenId,
1813         uint256 quantity
1814     ) internal virtual {}
1815 
1816     /**
1817      * @dev Hook that is called after a set of serially-ordered token IDs
1818      * have been transferred. This includes minting.
1819      * And also called after one token has been burned.
1820      *
1821      * `startTokenId` - the first token ID to be transferred.
1822      * `quantity` - the amount to be transferred.
1823      *
1824      * Calling conditions:
1825      *
1826      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1827      * transferred to `to`.
1828      * - When `from` is zero, `tokenId` has been minted for `to`.
1829      * - When `to` is zero, `tokenId` has been burned by `from`.
1830      * - `from` and `to` are never both zero.
1831      */
1832     function _afterTokenTransfers(
1833         address from,
1834         address to,
1835         uint256 startTokenId,
1836         uint256 quantity
1837     ) internal virtual {}
1838 
1839     /**
1840      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1841      *
1842      * `from` - Previous owner of the given token ID.
1843      * `to` - Target address that will receive the token.
1844      * `tokenId` - Token ID to be transferred.
1845      * `_data` - Optional data to send along with the call.
1846      *
1847      * Returns whether the call correctly returned the expected magic value.
1848      */
1849     function _checkContractOnERC721Received(
1850         address from,
1851         address to,
1852         uint256 tokenId,
1853         bytes memory _data
1854     ) private returns (bool) {
1855         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1856             bytes4 retval
1857         ) {
1858             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1859         } catch (bytes memory reason) {
1860             if (reason.length == 0) {
1861                 revert TransferToNonERC721ReceiverImplementer();
1862             } else {
1863                 assembly {
1864                     revert(add(32, reason), mload(reason))
1865                 }
1866             }
1867         }
1868     }
1869 
1870     // =============================================================
1871     //                        MINT OPERATIONS
1872     // =============================================================
1873 
1874     /**
1875      * @dev Mints `quantity` tokens and transfers them to `to`.
1876      *
1877      * Requirements:
1878      *
1879      * - `to` cannot be the zero address.
1880      * - `quantity` must be greater than 0.
1881      *
1882      * Emits a {Transfer} event for each mint.
1883      */
1884     function _mint(address to, uint256 quantity) internal virtual {
1885         uint256 startTokenId = _currentIndex;
1886         if (quantity == 0) revert MintZeroQuantity();
1887 
1888         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1889 
1890         // Overflows are incredibly unrealistic.
1891         // `balance` and `numberMinted` have a maximum limit of 2**64.
1892         // `tokenId` has a maximum limit of 2**256.
1893         unchecked {
1894             // Updates:
1895             // - `balance += quantity`.
1896             // - `numberMinted += quantity`.
1897             //
1898             // We can directly add to the `balance` and `numberMinted`.
1899             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1900 
1901             // Updates:
1902             // - `address` to the owner.
1903             // - `startTimestamp` to the timestamp of minting.
1904             // - `burned` to `false`.
1905             // - `nextInitialized` to `quantity == 1`.
1906             _packedOwnerships[startTokenId] = _packOwnershipData(
1907                 to,
1908                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1909             );
1910 
1911             uint256 toMasked;
1912             uint256 end = startTokenId + quantity;
1913 
1914             // Use assembly to loop and emit the `Transfer` event for gas savings.
1915             assembly {
1916                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1917                 toMasked := and(to, _BITMASK_ADDRESS)
1918                 // Emit the `Transfer` event.
1919                 log4(
1920                     0, // Start of data (0, since no data).
1921                     0, // End of data (0, since no data).
1922                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1923                     0, // `address(0)`.
1924                     toMasked, // `to`.
1925                     startTokenId // `tokenId`.
1926                 )
1927 
1928                 for {
1929                     let tokenId := add(startTokenId, 1)
1930                 } iszero(eq(tokenId, end)) {
1931                     tokenId := add(tokenId, 1)
1932                 } {
1933                     // Emit the `Transfer` event. Similar to above.
1934                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1935                 }
1936             }
1937             if (toMasked == 0) revert MintToZeroAddress();
1938 
1939             _currentIndex = end;
1940         }
1941         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1942     }
1943 
1944     /**
1945      * @dev Mints `quantity` tokens and transfers them to `to`.
1946      *
1947      * This function is intended for efficient minting only during contract creation.
1948      *
1949      * It emits only one {ConsecutiveTransfer} as defined in
1950      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1951      * instead of a sequence of {Transfer} event(s).
1952      *
1953      * Calling this function outside of contract creation WILL make your contract
1954      * non-compliant with the ERC721 standard.
1955      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1956      * {ConsecutiveTransfer} event is only permissible during contract creation.
1957      *
1958      * Requirements:
1959      *
1960      * - `to` cannot be the zero address.
1961      * - `quantity` must be greater than 0.
1962      *
1963      * Emits a {ConsecutiveTransfer} event.
1964      */
1965     function _mintERC2309(address to, uint256 quantity) internal virtual {
1966         uint256 startTokenId = _currentIndex;
1967         if (to == address(0)) revert MintToZeroAddress();
1968         if (quantity == 0) revert MintZeroQuantity();
1969         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1970 
1971         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1972 
1973         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1974         unchecked {
1975             // Updates:
1976             // - `balance += quantity`.
1977             // - `numberMinted += quantity`.
1978             //
1979             // We can directly add to the `balance` and `numberMinted`.
1980             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1981 
1982             // Updates:
1983             // - `address` to the owner.
1984             // - `startTimestamp` to the timestamp of minting.
1985             // - `burned` to `false`.
1986             // - `nextInitialized` to `quantity == 1`.
1987             _packedOwnerships[startTokenId] = _packOwnershipData(
1988                 to,
1989                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1990             );
1991 
1992             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1993 
1994             _currentIndex = startTokenId + quantity;
1995         }
1996         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1997     }
1998 
1999     /**
2000      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2001      *
2002      * Requirements:
2003      *
2004      * - If `to` refers to a smart contract, it must implement
2005      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2006      * - `quantity` must be greater than 0.
2007      *
2008      * See {_mint}.
2009      *
2010      * Emits a {Transfer} event for each mint.
2011      */
2012     function _safeMint(
2013         address to,
2014         uint256 quantity,
2015         bytes memory _data
2016     ) internal virtual {
2017         _mint(to, quantity);
2018 
2019         unchecked {
2020             if (to.code.length != 0) {
2021                 uint256 end = _currentIndex;
2022                 uint256 index = end - quantity;
2023                 do {
2024                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2025                         revert TransferToNonERC721ReceiverImplementer();
2026                     }
2027                 } while (index < end);
2028                 // Reentrancy protection.
2029                 if (_currentIndex != end) revert();
2030             }
2031         }
2032     }
2033 
2034     /**
2035      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2036      */
2037     function _safeMint(address to, uint256 quantity) internal virtual {
2038         _safeMint(to, quantity, '');
2039     }
2040 
2041     // =============================================================
2042     //                        BURN OPERATIONS
2043     // =============================================================
2044 
2045     /**
2046      * @dev Equivalent to `_burn(tokenId, false)`.
2047      */
2048     function _burn(uint256 tokenId) internal virtual {
2049         _burn(tokenId, false);
2050     }
2051 
2052     /**
2053      * @dev Destroys `tokenId`.
2054      * The approval is cleared when the token is burned.
2055      *
2056      * Requirements:
2057      *
2058      * - `tokenId` must exist.
2059      *
2060      * Emits a {Transfer} event.
2061      */
2062     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2063         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2064 
2065         address from = address(uint160(prevOwnershipPacked));
2066 
2067         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2068 
2069         if (approvalCheck) {
2070             // The nested ifs save around 20+ gas over a compound boolean condition.
2071             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2072                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2073         }
2074 
2075         _beforeTokenTransfers(from, address(0), tokenId, 1);
2076 
2077         // Clear approvals from the previous owner.
2078         assembly {
2079             if approvedAddress {
2080                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2081                 sstore(approvedAddressSlot, 0)
2082             }
2083         }
2084 
2085         // Underflow of the sender's balance is impossible because we check for
2086         // ownership above and the recipient's balance can't realistically overflow.
2087         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2088         unchecked {
2089             // Updates:
2090             // - `balance -= 1`.
2091             // - `numberBurned += 1`.
2092             //
2093             // We can directly decrement the balance, and increment the number burned.
2094             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2095             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2096 
2097             // Updates:
2098             // - `address` to the last owner.
2099             // - `startTimestamp` to the timestamp of burning.
2100             // - `burned` to `true`.
2101             // - `nextInitialized` to `true`.
2102             _packedOwnerships[tokenId] = _packOwnershipData(
2103                 from,
2104                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2105             );
2106 
2107             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2108             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2109                 uint256 nextTokenId = tokenId + 1;
2110                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2111                 if (_packedOwnerships[nextTokenId] == 0) {
2112                     // If the next slot is within bounds.
2113                     if (nextTokenId != _currentIndex) {
2114                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2115                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2116                     }
2117                 }
2118             }
2119         }
2120 
2121         emit Transfer(from, address(0), tokenId);
2122         _afterTokenTransfers(from, address(0), tokenId, 1);
2123 
2124         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2125         unchecked {
2126             _burnCounter++;
2127         }
2128     }
2129 
2130     // =============================================================
2131     //                     EXTRA DATA OPERATIONS
2132     // =============================================================
2133 
2134     /**
2135      * @dev Directly sets the extra data for the ownership data `index`.
2136      */
2137     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2138         uint256 packed = _packedOwnerships[index];
2139         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2140         uint256 extraDataCasted;
2141         // Cast `extraData` with assembly to avoid redundant masking.
2142         assembly {
2143             extraDataCasted := extraData
2144         }
2145         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2146         _packedOwnerships[index] = packed;
2147     }
2148 
2149     /**
2150      * @dev Called during each token transfer to set the 24bit `extraData` field.
2151      * Intended to be overridden by the cosumer contract.
2152      *
2153      * `previousExtraData` - the value of `extraData` before transfer.
2154      *
2155      * Calling conditions:
2156      *
2157      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2158      * transferred to `to`.
2159      * - When `from` is zero, `tokenId` will be minted for `to`.
2160      * - When `to` is zero, `tokenId` will be burned by `from`.
2161      * - `from` and `to` are never both zero.
2162      */
2163     function _extraData(
2164         address from,
2165         address to,
2166         uint24 previousExtraData
2167     ) internal view virtual returns (uint24) {}
2168 
2169     /**
2170      * @dev Returns the next extra data for the packed ownership data.
2171      * The returned result is shifted into position.
2172      */
2173     function _nextExtraData(
2174         address from,
2175         address to,
2176         uint256 prevOwnershipPacked
2177     ) private view returns (uint256) {
2178         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2179         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2180     }
2181 
2182     // =============================================================
2183     //                       OTHER OPERATIONS
2184     // =============================================================
2185 
2186     /**
2187      * @dev Returns the message sender (defaults to `msg.sender`).
2188      *
2189      * If you are writing GSN compatible contracts, you need to override this function.
2190      */
2191     function _msgSenderERC721A() internal view virtual returns (address) {
2192         return msg.sender;
2193     }
2194 
2195     /**
2196      * @dev Converts a uint256 to its ASCII string decimal representation.
2197      */
2198     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
2199         assembly {
2200             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
2201             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
2202             // We will need 1 32-byte word to store the length,
2203             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
2204             ptr := add(mload(0x40), 128)
2205             // Update the free memory pointer to allocate.
2206             mstore(0x40, ptr)
2207 
2208             // Cache the end of the memory to calculate the length later.
2209             let end := ptr
2210 
2211             // We write the string from the rightmost digit to the leftmost digit.
2212             // The following is essentially a do-while loop that also handles the zero case.
2213             // Costs a bit more than early returning for the zero case,
2214             // but cheaper in terms of deployment and overall runtime costs.
2215             for {
2216                 // Initialize and perform the first pass without check.
2217                 let temp := value
2218                 // Move the pointer 1 byte leftwards to point to an empty character slot.
2219                 ptr := sub(ptr, 1)
2220                 // Write the character to the pointer.
2221                 // The ASCII index of the '0' character is 48.
2222                 mstore8(ptr, add(48, mod(temp, 10)))
2223                 temp := div(temp, 10)
2224             } temp {
2225                 // Keep dividing `temp` until zero.
2226                 temp := div(temp, 10)
2227             } {
2228                 // Body of the for loop.
2229                 ptr := sub(ptr, 1)
2230                 mstore8(ptr, add(48, mod(temp, 10)))
2231             }
2232 
2233             let length := sub(end, ptr)
2234             // Move the pointer 32 bytes leftwards to make room for the length.
2235             ptr := sub(ptr, 32)
2236             // Store the length.
2237             mstore(ptr, length)
2238         }
2239     }
2240 }
2241 
2242 
2243 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
2244     /**
2245      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2246      *
2247      * If the `tokenId` is out of bounds:
2248      *
2249      * - `addr = address(0)`
2250      * - `startTimestamp = 0`
2251      * - `burned = false`
2252      * - `extraData = 0`
2253      *
2254      * If the `tokenId` is burned:
2255      *
2256      * - `addr = <Address of owner before token was burned>`
2257      * - `startTimestamp = <Timestamp when token was burned>`
2258      * - `burned = true`
2259      * - `extraData = <Extra data when token was burned>`
2260      *
2261      * Otherwise:
2262      *
2263      * - `addr = <Address of owner>`
2264      * - `startTimestamp = <Timestamp of start of ownership>`
2265      * - `burned = false`
2266      * - `extraData = <Extra data at start of ownership>`
2267      */
2268     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
2269         TokenOwnership memory ownership;
2270         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
2271             return ownership;
2272         }
2273         ownership = _ownershipAt(tokenId);
2274         if (ownership.burned) {
2275             return ownership;
2276         }
2277         return _ownershipOf(tokenId);
2278     }
2279 
2280     /**
2281      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2282      * See {ERC721AQueryable-explicitOwnershipOf}
2283      */
2284     function explicitOwnershipsOf(uint256[] calldata tokenIds)
2285         external
2286         view
2287         virtual
2288         override
2289         returns (TokenOwnership[] memory)
2290     {
2291         unchecked {
2292             uint256 tokenIdsLength = tokenIds.length;
2293             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
2294             for (uint256 i; i != tokenIdsLength; ++i) {
2295                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2296             }
2297             return ownerships;
2298         }
2299     }
2300 
2301     /**
2302      * @dev Returns an array of token IDs owned by `owner`,
2303      * in the range [`start`, `stop`)
2304      * (i.e. `start <= tokenId < stop`).
2305      *
2306      * This function allows for tokens to be queried if the collection
2307      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2308      *
2309      * Requirements:
2310      *
2311      * - `start < stop`
2312      */
2313     function tokensOfOwnerIn(
2314         address owner,
2315         uint256 start,
2316         uint256 stop
2317     ) external view virtual override returns (uint256[] memory) {
2318         unchecked {
2319             if (start >= stop) revert InvalidQueryRange();
2320             uint256 tokenIdsIdx;
2321             uint256 stopLimit = _nextTokenId();
2322             // Set `start = max(start, _startTokenId())`.
2323             if (start < _startTokenId()) {
2324                 start = _startTokenId();
2325             }
2326             // Set `stop = min(stop, stopLimit)`.
2327             if (stop > stopLimit) {
2328                 stop = stopLimit;
2329             }
2330             uint256 tokenIdsMaxLength = balanceOf(owner);
2331             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2332             // to cater for cases where `balanceOf(owner)` is too big.
2333             if (start < stop) {
2334                 uint256 rangeLength = stop - start;
2335                 if (rangeLength < tokenIdsMaxLength) {
2336                     tokenIdsMaxLength = rangeLength;
2337                 }
2338             } else {
2339                 tokenIdsMaxLength = 0;
2340             }
2341             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2342             if (tokenIdsMaxLength == 0) {
2343                 return tokenIds;
2344             }
2345             // We need to call `explicitOwnershipOf(start)`,
2346             // because the slot at `start` may not be initialized.
2347             TokenOwnership memory ownership = explicitOwnershipOf(start);
2348             address currOwnershipAddr;
2349             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2350             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2351             if (!ownership.burned) {
2352                 currOwnershipAddr = ownership.addr;
2353             }
2354             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2355                 ownership = _ownershipAt(i);
2356                 if (ownership.burned) {
2357                     continue;
2358                 }
2359                 if (ownership.addr != address(0)) {
2360                     currOwnershipAddr = ownership.addr;
2361                 }
2362                 if (currOwnershipAddr == owner) {
2363                     tokenIds[tokenIdsIdx++] = i;
2364                 }
2365             }
2366             // Downsize the array to fit.
2367             assembly {
2368                 mstore(tokenIds, tokenIdsIdx)
2369             }
2370             return tokenIds;
2371         }
2372     }
2373 
2374     /**
2375      * @dev Returns an array of token IDs owned by `owner`.
2376      *
2377      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2378      * It is meant to be called off-chain.
2379      *
2380      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2381      * multiple smaller scans if the collection is large enough to cause
2382      * an out-of-gas error (10K collections should be fine).
2383      */
2384     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2385         unchecked {
2386             uint256 tokenIdsIdx;
2387             address currOwnershipAddr;
2388             uint256 tokenIdsLength = balanceOf(owner);
2389             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2390             TokenOwnership memory ownership;
2391             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2392                 ownership = _ownershipAt(i);
2393                 if (ownership.burned) {
2394                     continue;
2395                 }
2396                 if (ownership.addr != address(0)) {
2397                     currOwnershipAddr = ownership.addr;
2398                 }
2399                 if (currOwnershipAddr == owner) {
2400                     tokenIds[tokenIdsIdx++] = i;
2401                 }
2402             }
2403             return tokenIds;
2404         }
2405     }
2406 }
2407 
2408 interface IERC721ABurnable is IERC721A {
2409     /**
2410      * @dev Burns `tokenId`. See {ERC721A-_burn}.
2411      *
2412      * Requirements:
2413      *
2414      * - The caller must own `tokenId` or be an approved operator.
2415      */
2416     function burn(uint256 tokenId) external;
2417 }
2418 
2419 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
2420     /**
2421      * @dev Burns `tokenId`. See {ERC721A-_burn}.
2422      *
2423      * Requirements:
2424      *
2425      * - The caller must own `tokenId` or be an approved operator.
2426      */
2427     function burn(uint256 tokenId) public virtual override {
2428         _burn(tokenId, true);
2429     }
2430 }
2431 
2432 error Unauthorized();
2433 error InsufficientValue(uint256 messageValue, uint256 required);
2434 
2435 contract BoredGrapesBottles is Ownable, ERC721A, ERC721AQueryable, ERC721ABurnable {
2436 
2437     using ECDSA for bytes32;
2438     using Strings for uint;
2439 
2440     address private signerAddressPresale;
2441     address private signerAddressWinelist;
2442 
2443     enum Step {
2444         Before,
2445         PreSale,
2446         WinelistSale,
2447         PublicSale,
2448         SoldOut,
2449         Reveal
2450     }
2451 
2452     string public baseURI;
2453 
2454     Step public sellingStep;
2455 
2456     uint private constant MAX_SUPPLY = 5555;
2457 
2458     mapping(address => uint) public mintedAmountNFTsperWalletPreSale;
2459     mapping(address => uint) public mintedAmountNFTsperWalletWinelistSale;
2460 
2461     uint public maxMintAmountPerPresale = 1;
2462     uint public maxMintAmountPerWinelist = 1;
2463 
2464     uint private teamLength;
2465 
2466     address constant private TREASURY = 0xbcE824E921259749fbB77a10dC5EF64f546124C9;
2467 
2468     constructor(address _signerAddressPresale, address _signerAddressWinelist, string memory _baseURI) ERC721A("Bored Grapes - Bottles", "$BOTTLES")
2469     {
2470         signerAddressPresale = _signerAddressPresale;
2471         signerAddressWinelist = _signerAddressWinelist;
2472         baseURI = _baseURI;
2473     }
2474 
2475     function getOwnershipAt(uint256 index) public view returns (TokenOwnership memory) {
2476         return _ownershipAt(index);
2477     }
2478 
2479     function totalMinted() public view returns (uint256) {
2480         return _totalMinted();
2481     }
2482 
2483     function totalBurned() public view returns (uint256) {
2484         return _totalBurned();
2485     }
2486 
2487     function numberBurned(address owner) public view returns (uint256) {
2488         return _numberBurned(owner);
2489     }
2490 
2491     function mintForOpensea() external onlyOwner{
2492         if(totalSupply() != 0) revert Unauthorized();
2493         _mint(TREASURY, 100);
2494     }
2495 
2496     function PresaleMint(address _account, uint _quantity, bytes calldata signature) external {
2497 
2498         if(_quantity <= 0) revert("Quantity is 0");
2499         if(sellingStep != Step.PreSale) revert Unauthorized();
2500         if(totalSupply() + _quantity > MAX_SUPPLY) revert Unauthorized();
2501         if(signerAddressPresale != keccak256(
2502             abi.encodePacked(
2503                 "\x19Ethereum Signed Message:\n32",
2504                 bytes32(uint256(uint160(msg.sender)))
2505             )
2506         ).recover(signature)) revert Unauthorized();
2507 
2508         if(mintedAmountNFTsperWalletPreSale[msg.sender] + _quantity > maxMintAmountPerPresale) revert Unauthorized();
2509             
2510         mintedAmountNFTsperWalletPreSale[msg.sender] += _quantity;
2511 
2512         _mint(_account, _quantity);
2513     }
2514 
2515     function WinelistMint(address _account, uint _quantity, bytes calldata signature) external {
2516 
2517         if(_quantity <= 0) revert("Quantity is 0");
2518         if(sellingStep != Step.WinelistSale) revert Unauthorized();
2519         if(totalSupply() + _quantity > MAX_SUPPLY) revert Unauthorized();
2520         if(signerAddressWinelist != keccak256(
2521             abi.encodePacked(
2522                 "\x19Ethereum Signed Message:\n32",
2523                 bytes32(uint256(uint160(msg.sender)))
2524             )
2525         ).recover(signature)) revert Unauthorized();
2526 
2527         if(mintedAmountNFTsperWalletWinelistSale[msg.sender] + _quantity > maxMintAmountPerWinelist) revert Unauthorized();
2528             
2529         mintedAmountNFTsperWalletWinelistSale[msg.sender] += _quantity;
2530 
2531         _mint(_account, _quantity);
2532     }
2533 
2534     function publicSaleMint(address _account, uint _quantity) external {
2535         if(_quantity <= 0) revert("Quantity is 0");
2536 
2537         if(sellingStep != Step.PublicSale) revert Unauthorized();
2538 
2539         if(totalSupply() + _quantity > MAX_SUPPLY) revert Unauthorized();
2540 
2541         _mint(_account, _quantity);
2542     }
2543 
2544     function setBaseUri(string memory _baseURI) external onlyOwner {
2545         baseURI = _baseURI;
2546     }
2547 
2548     function setStep(uint _step) external onlyOwner {
2549         sellingStep = Step(_step);
2550     }
2551 
2552     function setMaxMintPerPresale(uint amount) external onlyOwner{
2553         maxMintAmountPerPresale = amount;
2554     }
2555 
2556     function setMaxMintPerWinelist(uint amount) external onlyOwner{
2557         maxMintAmountPerWinelist = amount;
2558     }
2559 
2560     function currentState() external view returns (Step, uint, uint) {
2561         return (sellingStep, maxMintAmountPerPresale, maxMintAmountPerWinelist);
2562     }
2563 
2564     function getNumberMinted(address account) external view returns (uint256) {
2565         return _numberMinted(account);
2566     }
2567 
2568     function getNumberPresaleMinted(address account) external view returns (uint256) {
2569         return mintedAmountNFTsperWalletPreSale[account];
2570     }
2571 
2572     function getNumberWinelistMinted(address account) external view returns (uint256) {
2573         return mintedAmountNFTsperWalletWinelistSale[account];
2574     }
2575 
2576     function tokenURI(uint _tokenId) public view virtual override(ERC721A, IERC721A) returns (string memory) {
2577         require(_exists(_tokenId), "URI query for nonexistent token");
2578         return string(abi.encodePacked(baseURI, _toString(_tokenId), ".json"));
2579     }
2580 }