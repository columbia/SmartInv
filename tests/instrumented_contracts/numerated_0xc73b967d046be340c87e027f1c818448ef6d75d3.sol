1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 /*                                      
5  * @dev Collection of functions related to the address type
6  */
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
1086 contract PaymentSplitter is Context {
1087     event PayeeAdded(address account, uint256 shares);
1088     event PaymentReleased(address to, uint256 amount);
1089     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
1090     event PaymentReceived(address from, uint256 amount);
1091 
1092     uint256 private _totalShares;
1093     uint256 private _totalReleased;
1094 
1095     mapping(address => uint256) private _shares;
1096     mapping(address => uint256) private _released;
1097     address[] private _payees;
1098 
1099     mapping(IERC20 => uint256) private _erc20TotalReleased;
1100     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
1101 
1102     /**
1103      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1104      * the matching position in the `shares` array.
1105      *
1106      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1107      * duplicates in `payees`.
1108      */
1109     constructor(address[] memory payees, uint256[] memory shares_) payable {
1110         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1111         require(payees.length > 0, "PaymentSplitter: no payees");
1112 
1113         for (uint256 i = 0; i < payees.length; i++) {
1114             _addPayee(payees[i], shares_[i]);
1115         }
1116     }
1117 
1118     /**
1119      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1120      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1121      * reliability of the events, and not the actual splitting of Ether.
1122      *
1123      * To learn more about this see the Solidity documentation for
1124      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1125      * functions].
1126      */
1127     receive() external payable virtual {
1128         emit PaymentReceived(_msgSender(), msg.value);
1129     }
1130 
1131     /**
1132      * @dev Getter for the total shares held by payees.
1133      */
1134     function totalShares() public view returns (uint256) {
1135         return _totalShares;
1136     }
1137 
1138     /**
1139      * @dev Getter for the total amount of Ether already released.
1140      */
1141     function totalReleased() public view returns (uint256) {
1142         return _totalReleased;
1143     }
1144 
1145     /**
1146      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
1147      * contract.
1148      */
1149     function totalReleased(IERC20 token) public view returns (uint256) {
1150         return _erc20TotalReleased[token];
1151     }
1152 
1153     /**
1154      * @dev Getter for the amount of shares held by an account.
1155      */
1156     function shares(address account) public view returns (uint256) {
1157         return _shares[account];
1158     }
1159 
1160     /**
1161      * @dev Getter for the amount of Ether already released to a payee.
1162      */
1163     function released(address account) public view returns (uint256) {
1164         return _released[account];
1165     }
1166 
1167     /**
1168      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
1169      * IERC20 contract.
1170      */
1171     function released(IERC20 token, address account) public view returns (uint256) {
1172         return _erc20Released[token][account];
1173     }
1174 
1175     /**
1176      * @dev Getter for the address of the payee number `index`.
1177      */
1178     function payee(uint256 index) public view returns (address) {
1179         return _payees[index];
1180     }
1181 
1182     /**
1183      * @dev Getter for the amount of payee's releasable Ether.
1184      */
1185     function releasable(address account) public view returns (uint256) {
1186         uint256 totalReceived = address(this).balance + totalReleased();
1187         return _pendingPayment(account, totalReceived, released(account));
1188     }
1189 
1190     /**
1191      * @dev Getter for the amount of payee's releasable `token` tokens. `token` should be the address of an
1192      * IERC20 contract.
1193      */
1194     function releasable(IERC20 token, address account) public view returns (uint256) {
1195         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1196         return _pendingPayment(account, totalReceived, released(token, account));
1197     }
1198 
1199     /**
1200      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1201      * total shares and their previous withdrawals.
1202      */
1203     function release(address payable account) public virtual {
1204         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1205 
1206         uint256 payment = releasable(account);
1207 
1208         require(payment != 0, "PaymentSplitter: account is not due payment");
1209 
1210         _released[account] += payment;
1211         _totalReleased += payment;
1212 
1213         Address.sendValue(account, payment);
1214         emit PaymentReleased(account, payment);
1215     }
1216 
1217     /**
1218      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1219      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1220      * contract.
1221      */
1222     function release(IERC20 token, address account) public virtual {
1223         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1224 
1225         uint256 payment = releasable(token, account);
1226 
1227         require(payment != 0, "PaymentSplitter: account is not due payment");
1228 
1229         _erc20Released[token][account] += payment;
1230         _erc20TotalReleased[token] += payment;
1231 
1232         SafeERC20.safeTransfer(token, account, payment);
1233         emit ERC20PaymentReleased(token, account, payment);
1234     }
1235 
1236     /**
1237      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1238      * already released amounts.
1239      */
1240     function _pendingPayment(
1241         address account,
1242         uint256 totalReceived,
1243         uint256 alreadyReleased
1244     ) private view returns (uint256) {
1245         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1246     }
1247 
1248     /**
1249      * @dev Add a new payee to the contract.
1250      * @param account The address of the payee to add.
1251      * @param shares_ The number of shares owned by the payee.
1252      */
1253     function _addPayee(address account, uint256 shares_) private {
1254         require(account != address(0), "PaymentSplitter: account is the zero address");
1255         require(shares_ > 0, "PaymentSplitter: shares are 0");
1256         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1257 
1258         _payees.push(account);
1259         _shares[account] = shares_;
1260         _totalShares = _totalShares + shares_;
1261         emit PayeeAdded(account, shares_);
1262     }
1263 }
1264 
1265 /**
1266  * @dev Interface of ERC721 token receiver.
1267  */
1268 interface ERC721A__IERC721Receiver {
1269     function onERC721Received(
1270         address operator,
1271         address from,
1272         uint256 tokenId,
1273         bytes calldata data
1274     ) external returns (bytes4);
1275 }
1276 
1277 /**
1278  * @title ERC721A
1279  *
1280  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1281  * Non-Fungible Token Standard, including the Metadata extension.
1282  * Optimized for lower gas during batch mints.
1283  *
1284  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1285  * starting from `_startTokenId()`.
1286  *
1287  * Assumptions:
1288  *
1289  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1290  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1291  */
1292 contract ERC721A is IERC721A {
1293     // Reference type for token approval.
1294     struct TokenApprovalRef {
1295         address value;
1296     }
1297 
1298     // =============================================================
1299     //                           CONSTANTS
1300     // =============================================================
1301 
1302     // Mask of an entry in packed address data.
1303     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1304 
1305     // The bit position of `numberMinted` in packed address data.
1306     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1307 
1308     // The bit position of `numberBurned` in packed address data.
1309     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1310 
1311     // The bit position of `aux` in packed address data.
1312     uint256 private constant _BITPOS_AUX = 192;
1313 
1314     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1315     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1316 
1317     // The bit position of `startTimestamp` in packed ownership.
1318     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1319 
1320     // The bit mask of the `burned` bit in packed ownership.
1321     uint256 private constant _BITMASK_BURNED = 1 << 224;
1322 
1323     // The bit position of the `nextInitialized` bit in packed ownership.
1324     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1325 
1326     // The bit mask of the `nextInitialized` bit in packed ownership.
1327     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1328 
1329     // The bit position of `extraData` in packed ownership.
1330     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1331 
1332     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1333     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1334 
1335     // The mask of the lower 160 bits for addresses.
1336     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1337 
1338     // The maximum `quantity` that can be minted with {_mintERC2309}.
1339     // This limit is to prevent overflows on the address data entries.
1340     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1341     // is required to cause an overflow, which is unrealistic.
1342     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1343 
1344     // The `Transfer` event signature is given by:
1345     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1346     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1347         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1348 
1349     // =============================================================
1350     //                            STORAGE
1351     // =============================================================
1352 
1353     // The next token ID to be minted.
1354     uint256 private _currentIndex;
1355 
1356     // The number of tokens burned.
1357     uint256 private _burnCounter;
1358 
1359     // Token name
1360     string private _name;
1361 
1362     // Token symbol
1363     string private _symbol;
1364 
1365     // Mapping from token ID to ownership details
1366     // An empty struct value does not necessarily mean the token is unowned.
1367     // See {_packedOwnershipOf} implementation for details.
1368     //
1369     // Bits Layout:
1370     // - [0..159]   `addr`
1371     // - [160..223] `startTimestamp`
1372     // - [224]      `burned`
1373     // - [225]      `nextInitialized`
1374     // - [232..255] `extraData`
1375     mapping(uint256 => uint256) private _packedOwnerships;
1376 
1377     // Mapping owner address to address data.
1378     //
1379     // Bits Layout:
1380     // - [0..63]    `balance`
1381     // - [64..127]  `numberMinted`
1382     // - [128..191] `numberBurned`
1383     // - [192..255] `aux`
1384     mapping(address => uint256) private _packedAddressData;
1385 
1386     // Mapping from token ID to approved address.
1387     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1388 
1389     // Mapping from owner to operator approvals
1390     mapping(address => mapping(address => bool)) private _operatorApprovals;
1391 
1392     // =============================================================
1393     //                          CONSTRUCTOR
1394     // =============================================================
1395 
1396     constructor(string memory name_, string memory symbol_) {
1397         _name = name_;
1398         _symbol = symbol_;
1399         _currentIndex = _startTokenId();
1400     }
1401 
1402     // =============================================================
1403     //                   TOKEN COUNTING OPERATIONS
1404     // =============================================================
1405 
1406     /**
1407      * @dev Returns the starting token ID.
1408      * To change the starting token ID, please override this function.
1409      */
1410     function _startTokenId() internal view virtual returns (uint256) {
1411         return 1;
1412     }
1413 
1414     /**
1415      * @dev Returns the next token ID to be minted.
1416      */
1417     function _nextTokenId() internal view virtual returns (uint256) {
1418         return _currentIndex;
1419     }
1420 
1421     /**
1422      * @dev Returns the total number of tokens in existence.
1423      * Burned tokens will reduce the count.
1424      * To get the total number of tokens minted, please see {_totalMinted}.
1425      */
1426     function totalSupply() public view virtual override returns (uint256) {
1427         // Counter underflow is impossible as _burnCounter cannot be incremented
1428         // more than `_currentIndex - _startTokenId()` times.
1429         unchecked {
1430             return _currentIndex - _burnCounter - _startTokenId();
1431         }
1432     }
1433 
1434     /**
1435      * @dev Returns the total amount of tokens minted in the contract.
1436      */
1437     function _totalMinted() internal view virtual returns (uint256) {
1438         // Counter underflow is impossible as `_currentIndex` does not decrement,
1439         // and it is initialized to `_startTokenId()`.
1440         unchecked {
1441             return _currentIndex - _startTokenId();
1442         }
1443     }
1444 
1445     /**
1446      * @dev Returns the total number of tokens burned.
1447      */
1448     function _totalBurned() internal view virtual returns (uint256) {
1449         return _burnCounter;
1450     }
1451 
1452     // =============================================================
1453     //                    ADDRESS DATA OPERATIONS
1454     // =============================================================
1455 
1456     /**
1457      * @dev Returns the number of tokens in `owner`'s account.
1458      */
1459     function balanceOf(address owner) public view virtual override returns (uint256) {
1460         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1461         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1462     }
1463 
1464     /**
1465      * Returns the number of tokens minted by `owner`.
1466      */
1467     function _numberMinted(address owner) internal view returns (uint256) {
1468         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1469     }
1470 
1471     /**
1472      * Returns the number of tokens burned by or on behalf of `owner`.
1473      */
1474     function _numberBurned(address owner) internal view returns (uint256) {
1475         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1476     }
1477 
1478     /**
1479      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1480      */
1481     function _getAux(address owner) internal view returns (uint64) {
1482         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1483     }
1484 
1485     /**
1486      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1487      * If there are multiple variables, please pack them into a uint64.
1488      */
1489     function _setAux(address owner, uint64 aux) internal virtual {
1490         uint256 packed = _packedAddressData[owner];
1491         uint256 auxCasted;
1492         // Cast `aux` with assembly to avoid redundant masking.
1493         assembly {
1494             auxCasted := aux
1495         }
1496         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1497         _packedAddressData[owner] = packed;
1498     }
1499 
1500     // =============================================================
1501     //                            IERC165
1502     // =============================================================
1503 
1504     /**
1505      * @dev Returns true if this contract implements the interface defined by
1506      * `interfaceId`. See the corresponding
1507      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1508      * to learn more about how these ids are created.
1509      *
1510      * This function call must use less than 30000 gas.
1511      */
1512     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1513         // The interface IDs are constants representing the first 4 bytes
1514         // of the XOR of all function selectors in the interface.
1515         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1516         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1517         return
1518             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1519             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1520             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1521     }
1522 
1523     // =============================================================
1524     //                        IERC721Metadata
1525     // =============================================================
1526 
1527     /**
1528      * @dev Returns the token collection name.
1529      */
1530     function name() public view virtual override returns (string memory) {
1531         return _name;
1532     }
1533 
1534     /**
1535      * @dev Returns the token collection symbol.
1536      */
1537     function symbol() public view virtual override returns (string memory) {
1538         return _symbol;
1539     }
1540 
1541     /**
1542      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1543      */
1544     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1545         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1546 
1547         string memory baseURI = _baseURI();
1548         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1549     }
1550 
1551     /**
1552      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1553      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1554      * by default, it can be overridden in child contracts.
1555      */
1556     function _baseURI() internal view virtual returns (string memory) {
1557         return '';
1558     }
1559 
1560     // =============================================================
1561     //                     OWNERSHIPS OPERATIONS
1562     // =============================================================
1563 
1564     /**
1565      * @dev Returns the owner of the `tokenId` token.
1566      *
1567      * Requirements:
1568      *
1569      * - `tokenId` must exist.
1570      */
1571     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1572         return address(uint160(_packedOwnershipOf(tokenId)));
1573     }
1574 
1575     /**
1576      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1577      * It gradually moves to O(1) as tokens get transferred around over time.
1578      */
1579     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1580         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1581     }
1582 
1583     /**
1584      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1585      */
1586     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1587         return _unpackedOwnership(_packedOwnerships[index]);
1588     }
1589 
1590     /**
1591      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1592      */
1593     function _initializeOwnershipAt(uint256 index) internal virtual {
1594         if (_packedOwnerships[index] == 0) {
1595             _packedOwnerships[index] = _packedOwnershipOf(index);
1596         }
1597     }
1598 
1599     /**
1600      * Returns the packed ownership data of `tokenId`.
1601      */
1602     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1603         uint256 curr = tokenId;
1604 
1605         unchecked {
1606             if (_startTokenId() <= curr)
1607                 if (curr < _currentIndex) {
1608                     uint256 packed = _packedOwnerships[curr];
1609                     // If not burned.
1610                     if (packed & _BITMASK_BURNED == 0) {
1611                         // Invariant:
1612                         // There will always be an initialized ownership slot
1613                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1614                         // before an unintialized ownership slot
1615                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1616                         // Hence, `curr` will not underflow.
1617                         //
1618                         // We can directly compare the packed value.
1619                         // If the address is zero, packed will be zero.
1620                         while (packed == 0) {
1621                             packed = _packedOwnerships[--curr];
1622                         }
1623                         return packed;
1624                     }
1625                 }
1626         }
1627         revert OwnerQueryForNonexistentToken();
1628     }
1629 
1630     /**
1631      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1632      */
1633     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1634         ownership.addr = address(uint160(packed));
1635         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1636         ownership.burned = packed & _BITMASK_BURNED != 0;
1637         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1638     }
1639 
1640     /**
1641      * @dev Packs ownership data into a single uint256.
1642      */
1643     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1644         assembly {
1645             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1646             owner := and(owner, _BITMASK_ADDRESS)
1647             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1648             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1649         }
1650     }
1651 
1652     /**
1653      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1654      */
1655     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1656         // For branchless setting of the `nextInitialized` flag.
1657         assembly {
1658             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1659             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1660         }
1661     }
1662 
1663     // =============================================================
1664     //                      APPROVAL OPERATIONS
1665     // =============================================================
1666 
1667     /**
1668      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1669      * The approval is cleared when the token is transferred.
1670      *
1671      * Only a single account can be approved at a time, so approving the
1672      * zero address clears previous approvals.
1673      *
1674      * Requirements:
1675      *
1676      * - The caller must own the token or be an approved operator.
1677      * - `tokenId` must exist.
1678      *
1679      * Emits an {Approval} event.
1680      */
1681     function approve(address to, uint256 tokenId) public virtual override {
1682         address owner = ownerOf(tokenId);
1683 
1684         if (_msgSenderERC721A() != owner)
1685             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1686                 revert ApprovalCallerNotOwnerNorApproved();
1687             }
1688 
1689         _tokenApprovals[tokenId].value = to;
1690         emit Approval(owner, to, tokenId);
1691     }
1692 
1693     /**
1694      * @dev Returns the account approved for `tokenId` token.
1695      *
1696      * Requirements:
1697      *
1698      * - `tokenId` must exist.
1699      */
1700     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1701         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1702 
1703         return _tokenApprovals[tokenId].value;
1704     }
1705 
1706     /**
1707      * @dev Approve or remove `operator` as an operator for the caller.
1708      * Operators can call {transferFrom} or {safeTransferFrom}
1709      * for any token owned by the caller.
1710      *
1711      * Requirements:
1712      *
1713      * - The `operator` cannot be the caller.
1714      *
1715      * Emits an {ApprovalForAll} event.
1716      */
1717     function setApprovalForAll(address operator, bool approved) public virtual override {
1718         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1719 
1720         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1721         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1722     }
1723 
1724     /**
1725      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1726      *
1727      * See {setApprovalForAll}.
1728      */
1729     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1730         return _operatorApprovals[owner][operator];
1731     }
1732 
1733     /**
1734      * @dev Returns whether `tokenId` exists.
1735      *
1736      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1737      *
1738      * Tokens start existing when they are minted. See {_mint}.
1739      */
1740     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1741         return
1742             _startTokenId() <= tokenId &&
1743             tokenId < _currentIndex && // If within bounds,
1744             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1745     }
1746 
1747     /**
1748      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1749      */
1750     function _isSenderApprovedOrOwner(
1751         address approvedAddress,
1752         address owner,
1753         address msgSender
1754     ) private pure returns (bool result) {
1755         assembly {
1756             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1757             owner := and(owner, _BITMASK_ADDRESS)
1758             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1759             msgSender := and(msgSender, _BITMASK_ADDRESS)
1760             // `msgSender == owner || msgSender == approvedAddress`.
1761             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1762         }
1763     }
1764 
1765     /**
1766      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1767      */
1768     function _getApprovedSlotAndAddress(uint256 tokenId)
1769         private
1770         view
1771         returns (uint256 approvedAddressSlot, address approvedAddress)
1772     {
1773         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1774         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1775         assembly {
1776             approvedAddressSlot := tokenApproval.slot
1777             approvedAddress := sload(approvedAddressSlot)
1778         }
1779     }
1780 
1781     // =============================================================
1782     //                      TRANSFER OPERATIONS
1783     // =============================================================
1784 
1785     /**
1786      * @dev Transfers `tokenId` from `from` to `to`.
1787      *
1788      * Requirements:
1789      *
1790      * - `from` cannot be the zero address.
1791      * - `to` cannot be the zero address.
1792      * - `tokenId` token must be owned by `from`.
1793      * - If the caller is not `from`, it must be approved to move this token
1794      * by either {approve} or {setApprovalForAll}.
1795      *
1796      * Emits a {Transfer} event.
1797      */
1798     function transferFrom(
1799         address from,
1800         address to,
1801         uint256 tokenId
1802     ) public virtual override {
1803         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1804 
1805         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1806 
1807         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1808 
1809         // The nested ifs save around 20+ gas over a compound boolean condition.
1810         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1811             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1812 
1813         if (to == address(0)) revert TransferToZeroAddress();
1814 
1815         _beforeTokenTransfers(from, to, tokenId, 1);
1816 
1817         // Clear approvals from the previous owner.
1818         assembly {
1819             if approvedAddress {
1820                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1821                 sstore(approvedAddressSlot, 0)
1822             }
1823         }
1824 
1825         // Underflow of the sender's balance is impossible because we check for
1826         // ownership above and the recipient's balance can't realistically overflow.
1827         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1828         unchecked {
1829             // We can directly increment and decrement the balances.
1830             --_packedAddressData[from]; // Updates: `balance -= 1`.
1831             ++_packedAddressData[to]; // Updates: `balance += 1`.
1832 
1833             // Updates:
1834             // - `address` to the next owner.
1835             // - `startTimestamp` to the timestamp of transfering.
1836             // - `burned` to `false`.
1837             // - `nextInitialized` to `true`.
1838             _packedOwnerships[tokenId] = _packOwnershipData(
1839                 to,
1840                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1841             );
1842 
1843             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1844             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1845                 uint256 nextTokenId = tokenId + 1;
1846                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1847                 if (_packedOwnerships[nextTokenId] == 0) {
1848                     // If the next slot is within bounds.
1849                     if (nextTokenId != _currentIndex) {
1850                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1851                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1852                     }
1853                 }
1854             }
1855         }
1856 
1857         emit Transfer(from, to, tokenId);
1858         _afterTokenTransfers(from, to, tokenId, 1);
1859     }
1860 
1861     /**
1862      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1863      */
1864     function safeTransferFrom(
1865         address from,
1866         address to,
1867         uint256 tokenId
1868     ) public virtual override {
1869         safeTransferFrom(from, to, tokenId, '');
1870     }
1871 
1872     /**
1873      * @dev Safely transfers `tokenId` token from `from` to `to`.
1874      *
1875      * Requirements:
1876      *
1877      * - `from` cannot be the zero address.
1878      * - `to` cannot be the zero address.
1879      * - `tokenId` token must exist and be owned by `from`.
1880      * - If the caller is not `from`, it must be approved to move this token
1881      * by either {approve} or {setApprovalForAll}.
1882      * - If `to` refers to a smart contract, it must implement
1883      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1884      *
1885      * Emits a {Transfer} event.
1886      */
1887     function safeTransferFrom(
1888         address from,
1889         address to,
1890         uint256 tokenId,
1891         bytes memory _data
1892     ) public virtual override {
1893         transferFrom(from, to, tokenId);
1894         if (to.code.length != 0)
1895             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1896                 revert TransferToNonERC721ReceiverImplementer();
1897             }
1898     }
1899 
1900     /**
1901      * @dev Hook that is called before a set of serially-ordered token IDs
1902      * are about to be transferred. This includes minting.
1903      * And also called before burning one token.
1904      *
1905      * `startTokenId` - the first token ID to be transferred.
1906      * `quantity` - the amount to be transferred.
1907      *
1908      * Calling conditions:
1909      *
1910      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1911      * transferred to `to`.
1912      * - When `from` is zero, `tokenId` will be minted for `to`.
1913      * - When `to` is zero, `tokenId` will be burned by `from`.
1914      * - `from` and `to` are never both zero.
1915      */
1916     function _beforeTokenTransfers(
1917         address from,
1918         address to,
1919         uint256 startTokenId,
1920         uint256 quantity
1921     ) internal virtual {}
1922 
1923     /**
1924      * @dev Hook that is called after a set of serially-ordered token IDs
1925      * have been transferred. This includes minting.
1926      * And also called after one token has been burned.
1927      *
1928      * `startTokenId` - the first token ID to be transferred.
1929      * `quantity` - the amount to be transferred.
1930      *
1931      * Calling conditions:
1932      *
1933      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1934      * transferred to `to`.
1935      * - When `from` is zero, `tokenId` has been minted for `to`.
1936      * - When `to` is zero, `tokenId` has been burned by `from`.
1937      * - `from` and `to` are never both zero.
1938      */
1939     function _afterTokenTransfers(
1940         address from,
1941         address to,
1942         uint256 startTokenId,
1943         uint256 quantity
1944     ) internal virtual {}
1945 
1946     /**
1947      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1948      *
1949      * `from` - Previous owner of the given token ID.
1950      * `to` - Target address that will receive the token.
1951      * `tokenId` - Token ID to be transferred.
1952      * `_data` - Optional data to send along with the call.
1953      *
1954      * Returns whether the call correctly returned the expected magic value.
1955      */
1956     function _checkContractOnERC721Received(
1957         address from,
1958         address to,
1959         uint256 tokenId,
1960         bytes memory _data
1961     ) private returns (bool) {
1962         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1963             bytes4 retval
1964         ) {
1965             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1966         } catch (bytes memory reason) {
1967             if (reason.length == 0) {
1968                 revert TransferToNonERC721ReceiverImplementer();
1969             } else {
1970                 assembly {
1971                     revert(add(32, reason), mload(reason))
1972                 }
1973             }
1974         }
1975     }
1976 
1977     // =============================================================
1978     //                        MINT OPERATIONS
1979     // =============================================================
1980 
1981     /**
1982      * @dev Mints `quantity` tokens and transfers them to `to`.
1983      *
1984      * Requirements:
1985      *
1986      * - `to` cannot be the zero address.
1987      * - `quantity` must be greater than 0.
1988      *
1989      * Emits a {Transfer} event for each mint.
1990      */
1991     function _mint(address to, uint256 quantity) internal virtual {
1992         uint256 startTokenId = _currentIndex;
1993         if (quantity == 0) revert MintZeroQuantity();
1994 
1995         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1996 
1997         // Overflows are incredibly unrealistic.
1998         // `balance` and `numberMinted` have a maximum limit of 2**64.
1999         // `tokenId` has a maximum limit of 2**256.
2000         unchecked {
2001             // Updates:
2002             // - `balance += quantity`.
2003             // - `numberMinted += quantity`.
2004             //
2005             // We can directly add to the `balance` and `numberMinted`.
2006             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2007 
2008             // Updates:
2009             // - `address` to the owner.
2010             // - `startTimestamp` to the timestamp of minting.
2011             // - `burned` to `false`.
2012             // - `nextInitialized` to `quantity == 1`.
2013             _packedOwnerships[startTokenId] = _packOwnershipData(
2014                 to,
2015                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2016             );
2017 
2018             uint256 toMasked;
2019             uint256 end = startTokenId + quantity;
2020 
2021             // Use assembly to loop and emit the `Transfer` event for gas savings.
2022             assembly {
2023                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2024                 toMasked := and(to, _BITMASK_ADDRESS)
2025                 // Emit the `Transfer` event.
2026                 log4(
2027                     0, // Start of data (0, since no data).
2028                     0, // End of data (0, since no data).
2029                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2030                     0, // `address(0)`.
2031                     toMasked, // `to`.
2032                     startTokenId // `tokenId`.
2033                 )
2034 
2035                 for {
2036                     let tokenId := add(startTokenId, 1)
2037                 } iszero(eq(tokenId, end)) {
2038                     tokenId := add(tokenId, 1)
2039                 } {
2040                     // Emit the `Transfer` event. Similar to above.
2041                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2042                 }
2043             }
2044             if (toMasked == 0) revert MintToZeroAddress();
2045 
2046             _currentIndex = end;
2047         }
2048         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2049     }
2050 
2051     /**
2052      * @dev Mints `quantity` tokens and transfers them to `to`.
2053      *
2054      * This function is intended for efficient minting only during contract creation.
2055      *
2056      * It emits only one {ConsecutiveTransfer} as defined in
2057      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2058      * instead of a sequence of {Transfer} event(s).
2059      *
2060      * Calling this function outside of contract creation WILL make your contract
2061      * non-compliant with the ERC721 standard.
2062      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2063      * {ConsecutiveTransfer} event is only permissible during contract creation.
2064      *
2065      * Requirements:
2066      *
2067      * - `to` cannot be the zero address.
2068      * - `quantity` must be greater than 0.
2069      *
2070      * Emits a {ConsecutiveTransfer} event.
2071      */
2072     function _mintERC2309(address to, uint256 quantity) internal virtual {
2073         uint256 startTokenId = _currentIndex;
2074         if (to == address(0)) revert MintToZeroAddress();
2075         if (quantity == 0) revert MintZeroQuantity();
2076         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2077 
2078         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2079 
2080         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2081         unchecked {
2082             // Updates:
2083             // - `balance += quantity`.
2084             // - `numberMinted += quantity`.
2085             //
2086             // We can directly add to the `balance` and `numberMinted`.
2087             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2088 
2089             // Updates:
2090             // - `address` to the owner.
2091             // - `startTimestamp` to the timestamp of minting.
2092             // - `burned` to `false`.
2093             // - `nextInitialized` to `quantity == 1`.
2094             _packedOwnerships[startTokenId] = _packOwnershipData(
2095                 to,
2096                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2097             );
2098 
2099             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2100 
2101             _currentIndex = startTokenId + quantity;
2102         }
2103         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2104     }
2105 
2106     /**
2107      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2108      *
2109      * Requirements:
2110      *
2111      * - If `to` refers to a smart contract, it must implement
2112      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2113      * - `quantity` must be greater than 0.
2114      *
2115      * See {_mint}.
2116      *
2117      * Emits a {Transfer} event for each mint.
2118      */
2119     function _safeMint(
2120         address to,
2121         uint256 quantity,
2122         bytes memory _data
2123     ) internal virtual {
2124         _mint(to, quantity);
2125 
2126         unchecked {
2127             if (to.code.length != 0) {
2128                 uint256 end = _currentIndex;
2129                 uint256 index = end - quantity;
2130                 do {
2131                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2132                         revert TransferToNonERC721ReceiverImplementer();
2133                     }
2134                 } while (index < end);
2135                 // Reentrancy protection.
2136                 if (_currentIndex != end) revert();
2137             }
2138         }
2139     }
2140 
2141     /**
2142      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2143      */
2144     function _safeMint(address to, uint256 quantity) internal virtual {
2145         _safeMint(to, quantity, '');
2146     }
2147 
2148     // =============================================================
2149     //                        BURN OPERATIONS
2150     // =============================================================
2151 
2152     /**
2153      * @dev Equivalent to `_burn(tokenId, false)`.
2154      */
2155     function _burn(uint256 tokenId) internal virtual {
2156         _burn(tokenId, false);
2157     }
2158 
2159     /**
2160      * @dev Destroys `tokenId`.
2161      * The approval is cleared when the token is burned.
2162      *
2163      * Requirements:
2164      *
2165      * - `tokenId` must exist.
2166      *
2167      * Emits a {Transfer} event.
2168      */
2169     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2170         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2171 
2172         address from = address(uint160(prevOwnershipPacked));
2173 
2174         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2175 
2176         if (approvalCheck) {
2177             // The nested ifs save around 20+ gas over a compound boolean condition.
2178             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2179                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2180         }
2181 
2182         _beforeTokenTransfers(from, address(0), tokenId, 1);
2183 
2184         // Clear approvals from the previous owner.
2185         assembly {
2186             if approvedAddress {
2187                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2188                 sstore(approvedAddressSlot, 0)
2189             }
2190         }
2191 
2192         // Underflow of the sender's balance is impossible because we check for
2193         // ownership above and the recipient's balance can't realistically overflow.
2194         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2195         unchecked {
2196             // Updates:
2197             // - `balance -= 1`.
2198             // - `numberBurned += 1`.
2199             //
2200             // We can directly decrement the balance, and increment the number burned.
2201             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2202             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2203 
2204             // Updates:
2205             // - `address` to the last owner.
2206             // - `startTimestamp` to the timestamp of burning.
2207             // - `burned` to `true`.
2208             // - `nextInitialized` to `true`.
2209             _packedOwnerships[tokenId] = _packOwnershipData(
2210                 from,
2211                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2212             );
2213 
2214             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2215             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2216                 uint256 nextTokenId = tokenId + 1;
2217                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2218                 if (_packedOwnerships[nextTokenId] == 0) {
2219                     // If the next slot is within bounds.
2220                     if (nextTokenId != _currentIndex) {
2221                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2222                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2223                     }
2224                 }
2225             }
2226         }
2227 
2228         emit Transfer(from, address(0), tokenId);
2229         _afterTokenTransfers(from, address(0), tokenId, 1);
2230 
2231         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2232         unchecked {
2233             _burnCounter++;
2234         }
2235     }
2236 
2237     // =============================================================
2238     //                     EXTRA DATA OPERATIONS
2239     // =============================================================
2240 
2241     /**
2242      * @dev Directly sets the extra data for the ownership data `index`.
2243      */
2244     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2245         uint256 packed = _packedOwnerships[index];
2246         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2247         uint256 extraDataCasted;
2248         // Cast `extraData` with assembly to avoid redundant masking.
2249         assembly {
2250             extraDataCasted := extraData
2251         }
2252         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2253         _packedOwnerships[index] = packed;
2254     }
2255 
2256     /**
2257      * @dev Called during each token transfer to set the 24bit `extraData` field.
2258      * Intended to be overridden by the cosumer contract.
2259      *
2260      * `previousExtraData` - the value of `extraData` before transfer.
2261      *
2262      * Calling conditions:
2263      *
2264      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2265      * transferred to `to`.
2266      * - When `from` is zero, `tokenId` will be minted for `to`.
2267      * - When `to` is zero, `tokenId` will be burned by `from`.
2268      * - `from` and `to` are never both zero.
2269      */
2270     function _extraData(
2271         address from,
2272         address to,
2273         uint24 previousExtraData
2274     ) internal view virtual returns (uint24) {}
2275 
2276     /**
2277      * @dev Returns the next extra data for the packed ownership data.
2278      * The returned result is shifted into position.
2279      */
2280     function _nextExtraData(
2281         address from,
2282         address to,
2283         uint256 prevOwnershipPacked
2284     ) private view returns (uint256) {
2285         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2286         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2287     }
2288 
2289     // =============================================================
2290     //                       OTHER OPERATIONS
2291     // =============================================================
2292 
2293     /**
2294      * @dev Returns the message sender (defaults to `msg.sender`).
2295      *
2296      * If you are writing GSN compatible contracts, you need to override this function.
2297      */
2298     function _msgSenderERC721A() internal view virtual returns (address) {
2299         return msg.sender;
2300     }
2301 
2302     /**
2303      * @dev Converts a uint256 to its ASCII string decimal representation.
2304      */
2305     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
2306         assembly {
2307             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
2308             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
2309             // We will need 1 32-byte word to store the length,
2310             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
2311             ptr := add(mload(0x40), 128)
2312             // Update the free memory pointer to allocate.
2313             mstore(0x40, ptr)
2314 
2315             // Cache the end of the memory to calculate the length later.
2316             let end := ptr
2317 
2318             // We write the string from the rightmost digit to the leftmost digit.
2319             // The following is essentially a do-while loop that also handles the zero case.
2320             // Costs a bit more than early returning for the zero case,
2321             // but cheaper in terms of deployment and overall runtime costs.
2322             for {
2323                 // Initialize and perform the first pass without check.
2324                 let temp := value
2325                 // Move the pointer 1 byte leftwards to point to an empty character slot.
2326                 ptr := sub(ptr, 1)
2327                 // Write the character to the pointer.
2328                 // The ASCII index of the '0' character is 48.
2329                 mstore8(ptr, add(48, mod(temp, 10)))
2330                 temp := div(temp, 10)
2331             } temp {
2332                 // Keep dividing `temp` until zero.
2333                 temp := div(temp, 10)
2334             } {
2335                 // Body of the for loop.
2336                 ptr := sub(ptr, 1)
2337                 mstore8(ptr, add(48, mod(temp, 10)))
2338             }
2339 
2340             let length := sub(end, ptr)
2341             // Move the pointer 32 bytes leftwards to make room for the length.
2342             ptr := sub(ptr, 32)
2343             // Store the length.
2344             mstore(ptr, length)
2345         }
2346     }
2347 }
2348 
2349 contract HeroesHQ is Ownable, ERC721A, PaymentSplitter {
2350 
2351     using ECDSA for bytes32;
2352     using Strings for uint;
2353 
2354     address private signerAddressWL;
2355 
2356     enum Step {
2357         Before,
2358         PublicSale,
2359         WhitelistSale,
2360         SoldOut,
2361         Reveal
2362     }
2363 
2364     string public baseURI;
2365 
2366     Step public sellingStep;
2367 
2368     uint private constant MAX_PUBLIC = 666;
2369     uint private constant MAX_WL = 333;
2370 
2371     uint public wlSalePrice = 0.0069 ether;
2372     uint public publicSalePrice = 0.01 ether;
2373 
2374     mapping(address => uint) public mintedAmountNFTsperWalletWhitelistSale;
2375     mapping(address => uint) public mintedAmountNFTsperWalletPublicSale;
2376 
2377     uint public maxMintAmountPerWhitelist = 1; 
2378     uint public maxMintAmountPerPublic = 2; 
2379 
2380     uint private teamLength;
2381 
2382     constructor(address[] memory _team, uint[] memory _teamShares, address _signerAddressWL, string memory _baseURI) ERC721A("Heroes HQ", "HQ")
2383     PaymentSplitter(_team, _teamShares) {
2384         signerAddressWL = _signerAddressWL;
2385         baseURI = _baseURI;
2386         teamLength = _team.length;
2387     }
2388 
2389     function mintForOpensea() external onlyOwner{
2390         if(totalSupply() != 0) revert("Only five mint for deployer");
2391         _mint(msg.sender, 5);
2392     }
2393 
2394     function publicSaleMint(uint _quantity) external payable {
2395         uint price = publicSalePrice;
2396         if(price <= 0) revert("Price is 0");
2397         if(sellingStep != Step.PublicSale) revert("Public Mint not live.");
2398         if(totalSupply() + _quantity > (MAX_PUBLIC)) revert("Max supply exceeded for public exceeded");
2399         if(msg.value < price * _quantity) revert("Not enough funds");
2400         if(mintedAmountNFTsperWalletPublicSale[msg.sender] + _quantity > maxMintAmountPerPublic) revert("Max exceeded");
2401 
2402         mintedAmountNFTsperWalletPublicSale[msg.sender] += _quantity;
2403 
2404         _mint(msg.sender, _quantity);
2405     }
2406 
2407     function WLMint(uint _quantity, bytes calldata signature) external payable {
2408         uint price = wlSalePrice;
2409         if(price <= 0) revert("Price is 0");
2410 
2411         if(sellingStep != Step.WhitelistSale) revert("WL Mint not live.");
2412         if(totalSupply() + _quantity > (MAX_PUBLIC + MAX_WL)) revert("Max supply exceeded for WL exceeded");
2413         if(msg.value < price * _quantity) revert("Not enough funds");          
2414         if(signerAddressWL != keccak256(
2415             abi.encodePacked(
2416                 "\x19Ethereum Signed Message:\n32",
2417                 bytes32(uint256(uint160(msg.sender)))
2418             )
2419         ).recover(signature)) revert("You are not in WL whitelist");
2420         if(mintedAmountNFTsperWalletWhitelistSale[msg.sender] + _quantity > maxMintAmountPerWhitelist) revert("You can only get 1 NFT on the Whitelist Sale");
2421             
2422         mintedAmountNFTsperWalletWhitelistSale[msg.sender] += _quantity;
2423         _mint(msg.sender, _quantity);
2424     }
2425 
2426     function currentState() external view returns (Step, uint, uint, uint, uint) {
2427         return (sellingStep, publicSalePrice, wlSalePrice, maxMintAmountPerWhitelist, maxMintAmountPerPublic);
2428     }
2429 
2430     function changeWlSalePrice(uint256 new_price) external onlyOwner{
2431         wlSalePrice = new_price;
2432     }
2433 
2434     function changePublicSalePrice(uint256 new_price) external onlyOwner{
2435         publicSalePrice = new_price;
2436     }
2437 
2438     function setBaseUri(string memory _baseURI) external onlyOwner {
2439         baseURI = _baseURI;
2440     }
2441 
2442     function setStep(uint _step) external onlyOwner {
2443         sellingStep = Step(_step);
2444     }
2445 
2446     function setMaxMintPerWhitelist(uint amount) external onlyOwner{
2447         maxMintAmountPerWhitelist = amount;
2448     }
2449 
2450     function setMaxMintPerPublic(uint amount) external onlyOwner{
2451         maxMintAmountPerPublic = amount;
2452     }
2453 
2454     function getNumberMinted(address account) external view returns (uint256) {
2455         return _numberMinted(account);
2456     }
2457 
2458     function getNumberWLMinted(address account) external view returns (uint256) {
2459         return mintedAmountNFTsperWalletWhitelistSale[account];
2460     }
2461 
2462     function getNumberPublicMinted(address account) external view returns (uint256) {
2463         return mintedAmountNFTsperWalletPublicSale[account];
2464     }
2465 
2466     function tokenURI(uint _tokenId) public view virtual override returns (string memory) {
2467         require(_exists(_tokenId), "URI query for nonexistent token");
2468         return string(abi.encodePacked(baseURI, _toString(_tokenId), ".json"));
2469     }
2470 
2471     function releaseAll() external {
2472         for(uint i = 0 ; i < teamLength ; i++) {
2473             release(payable(payee(i)));
2474         }
2475     }
2476 }