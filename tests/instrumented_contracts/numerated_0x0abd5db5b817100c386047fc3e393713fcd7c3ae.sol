1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 /*
5   
6   __  __                                     
7  |  \/  |                                    
8  | \  / | ___ _ __   __ _  ___ ___           
9  | |\/| |/ _ \ '_ \ / _` |/ __/ _ \          
10  | |  | |  __/ | | | (_| | (_|  __/          
11  |_|  |_|\___|_| |_|\__,_|\___\___|          
12  \ \        / /            (_)               
13   \ \  /\  / /_ _ _ __ _ __ _  ___  _ __ ___ 
14    \ \/  \/ / _` | '__| '__| |/ _ \| '__/ __|
15     \  /\  / (_| | |  | |  | | (_) | |  \__ \
16      \/  \/ \__,_|_|  |_|  |_|\___/|_|  |___/
17                                              
18                                            
19  * @dev Collection of functions related to the address type
20  */
21 library Address {
22     /**
23      * @dev Returns true if `account` is a contract.
24      *
25      * [IMPORTANT]
26      * ====
27      * It is unsafe to assume that an address for which this function returns
28      * false is an externally-owned account (EOA) and not a contract.
29      *
30      * Among others, `isContract` will return false for the following
31      * types of addresses:
32      *
33      *  - an externally-owned account
34      *  - a contract in construction
35      *  - an address where a contract will be created
36      *  - an address where a contract lived, but was destroyed
37      * ====
38      *
39      * [IMPORTANT]
40      * ====
41      * You shouldn't rely on `isContract` to protect against flash loan attacks!
42      *
43      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
44      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
45      * constructor.
46      * ====
47      */
48     function isContract(address account) internal view returns (bool) {
49         // This method relies on extcodesize/address.code.length, which returns 0
50         // for contracts in construction, since the code is only stored at the end
51         // of the constructor execution.
52 
53         return account.code.length > 0;
54     }
55 
56     /**
57      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
58      * `recipient`, forwarding all available gas and reverting on errors.
59      *
60      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
61      * of certain opcodes, possibly making contracts go over the 2300 gas limit
62      * imposed by `transfer`, making them unable to receive funds via
63      * `transfer`. {sendValue} removes this limitation.
64      *
65      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
66      *
67      * IMPORTANT: because control is transferred to `recipient`, care must be
68      * taken to not create reentrancy vulnerabilities. Consider using
69      * {ReentrancyGuard} or the
70      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
71      */
72     function sendValue(address payable recipient, uint256 amount) internal {
73         require(address(this).balance >= amount, "Address: insufficient balance");
74 
75         (bool success, ) = recipient.call{value: amount}("");
76         require(success, "Address: unable to send value, recipient may have reverted");
77     }
78 
79     /**
80      * @dev Performs a Solidity function call using a low level `call`. A
81      * plain `call` is an unsafe replacement for a function call: use this
82      * function instead.
83      *
84      * If `target` reverts with a revert reason, it is bubbled up by this
85      * function (like regular Solidity function calls).
86      *
87      * Returns the raw returned data. To convert to the expected return value,
88      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
89      *
90      * Requirements:
91      *
92      * - `target` must be a contract.
93      * - calling `target` with `data` must not revert.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
98         return functionCall(target, data, "Address: low-level call failed");
99     }
100 
101     /**
102      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
103      * `errorMessage` as a fallback revert reason when `target` reverts.
104      *
105      * _Available since v3.1._
106      */
107     function functionCall(
108         address target,
109         bytes memory data,
110         string memory errorMessage
111     ) internal returns (bytes memory) {
112         return functionCallWithValue(target, data, 0, errorMessage);
113     }
114 
115     /**
116      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
117      * but also transferring `value` wei to `target`.
118      *
119      * Requirements:
120      *
121      * - the calling contract must have an ETH balance of at least `value`.
122      * - the called Solidity function must be `payable`.
123      *
124      * _Available since v3.1._
125      */
126     function functionCallWithValue(
127         address target,
128         bytes memory data,
129         uint256 value
130     ) internal returns (bytes memory) {
131         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
132     }
133 
134     /**
135      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
136      * with `errorMessage` as a fallback revert reason when `target` reverts.
137      *
138      * _Available since v3.1._
139      */
140     function functionCallWithValue(
141         address target,
142         bytes memory data,
143         uint256 value,
144         string memory errorMessage
145     ) internal returns (bytes memory) {
146         require(address(this).balance >= value, "Address: insufficient balance for call");
147         require(isContract(target), "Address: call to non-contract");
148 
149         (bool success, bytes memory returndata) = target.call{value: value}(data);
150         return verifyCallResult(success, returndata, errorMessage);
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
160         return functionStaticCall(target, data, "Address: low-level static call failed");
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
165      * but performing a static call.
166      *
167      * _Available since v3.3._
168      */
169     function functionStaticCall(
170         address target,
171         bytes memory data,
172         string memory errorMessage
173     ) internal view returns (bytes memory) {
174         require(isContract(target), "Address: static call to non-contract");
175 
176         (bool success, bytes memory returndata) = target.staticcall(data);
177         return verifyCallResult(success, returndata, errorMessage);
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
187         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
192      * but performing a delegate call.
193      *
194      * _Available since v3.4._
195      */
196     function functionDelegateCall(
197         address target,
198         bytes memory data,
199         string memory errorMessage
200     ) internal returns (bytes memory) {
201         require(isContract(target), "Address: delegate call to non-contract");
202 
203         (bool success, bytes memory returndata) = target.delegatecall(data);
204         return verifyCallResult(success, returndata, errorMessage);
205     }
206 
207     /**
208      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
209      * revert reason using the provided one.
210      *
211      * _Available since v4.3._
212      */
213     function verifyCallResult(
214         bool success,
215         bytes memory returndata,
216         string memory errorMessage
217     ) internal pure returns (bytes memory) {
218         if (success) {
219             return returndata;
220         } else {
221             // Look for revert reason and bubble it up if present
222             if (returndata.length > 0) {
223                 // The easiest way to bubble the revert reason is using memory via assembly
224                 /// @solidity memory-safe-assembly
225                 assembly {
226                     let returndata_size := mload(returndata)
227                     revert(add(32, returndata), returndata_size)
228                 }
229             } else {
230                 revert(errorMessage);
231             }
232         }
233     }
234 }
235 
236 abstract contract Context {
237     function _msgSender() internal view virtual returns (address) {
238         return msg.sender;
239     }
240 
241     function _msgData() internal view virtual returns (bytes calldata) {
242         return msg.data;
243     }
244 }
245 
246 interface IERC721A {
247     /**
248      * The caller must own the token or be an approved operator.
249      */
250     error ApprovalCallerNotOwnerNorApproved();
251 
252     /**
253      * The token does not exist.
254      */
255     error ApprovalQueryForNonexistentToken();
256 
257     /**
258      * The caller cannot approve to their own address.
259      */
260     error ApproveToCaller();
261 
262     /**
263      * Cannot query the balance for the zero address.
264      */
265     error BalanceQueryForZeroAddress();
266 
267     /**
268      * Cannot mint to the zero address.
269      */
270     error MintToZeroAddress();
271 
272     /**
273      * The quantity of tokens minted must be more than zero.
274      */
275     error MintZeroQuantity();
276 
277     /**
278      * The token does not exist.
279      */
280     error OwnerQueryForNonexistentToken();
281 
282     /**
283      * The caller must own the token or be an approved operator.
284      */
285     error TransferCallerNotOwnerNorApproved();
286 
287     /**
288      * The token must be owned by `from`.
289      */
290     error TransferFromIncorrectOwner();
291 
292     /**
293      * Cannot safely transfer to a contract that does not implement the
294      * ERC721Receiver interface.
295      */
296     error TransferToNonERC721ReceiverImplementer();
297 
298     /**
299      * Cannot transfer to the zero address.
300      */
301     error TransferToZeroAddress();
302 
303     /**
304      * The token does not exist.
305      */
306     error URIQueryForNonexistentToken();
307 
308     /**
309      * The `quantity` minted with ERC2309 exceeds the safety limit.
310      */
311     error MintERC2309QuantityExceedsLimit();
312 
313     /**
314      * The `extraData` cannot be set on an unintialized ownership slot.
315      */
316     error OwnershipNotInitializedForExtraData();
317 
318     // =============================================================
319     //                            STRUCTS
320     // =============================================================
321 
322     struct TokenOwnership {
323         // The address of the owner.
324         address addr;
325         // Stores the start time of ownership with minimal overhead for tokenomics.
326         uint64 startTimestamp;
327         // Whether the token has been burned.
328         bool burned;
329         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
330         uint24 extraData;
331     }
332 
333     // =============================================================
334     //                         TOKEN COUNTERS
335     // =============================================================
336 
337     /**
338      * @dev Returns the total number of tokens in existence.
339      * Burned tokens will reduce the count.
340      * To get the total number of tokens minted, please see {_totalMinted}.
341      */
342     function totalSupply() external view returns (uint256);
343 
344     // =============================================================
345     //                            IERC165
346     // =============================================================
347 
348     /**
349      * @dev Returns true if this contract implements the interface defined by
350      * `interfaceId`. See the corresponding
351      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
352      * to learn more about how these ids are created.
353      *
354      * This function call must use less than 30000 gas.
355      */
356     function supportsInterface(bytes4 interfaceId) external view returns (bool);
357 
358     // =============================================================
359     //                            IERC721
360     // =============================================================
361 
362     /**
363      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
364      */
365     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
366 
367     /**
368      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
369      */
370     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
371 
372     /**
373      * @dev Emitted when `owner` enables or disables
374      * (`approved`) `operator` to manage all of its assets.
375      */
376     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
377 
378     /**
379      * @dev Returns the number of tokens in `owner`'s account.
380      */
381     function balanceOf(address owner) external view returns (uint256 balance);
382 
383     /**
384      * @dev Returns the owner of the `tokenId` token.
385      *
386      * Requirements:
387      *
388      * - `tokenId` must exist.
389      */
390     function ownerOf(uint256 tokenId) external view returns (address owner);
391 
392     /**
393      * @dev Safely transfers `tokenId` token from `from` to `to`,
394      * checking first that contract recipients are aware of the ERC721 protocol
395      * to prevent tokens from being forever locked.
396      *
397      * Requirements:
398      *
399      * - `from` cannot be the zero address.
400      * - `to` cannot be the zero address.
401      * - `tokenId` token must exist and be owned by `from`.
402      * - If the caller is not `from`, it must be have been allowed to move
403      * this token by either {approve} or {setApprovalForAll}.
404      * - If `to` refers to a smart contract, it must implement
405      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
406      *
407      * Emits a {Transfer} event.
408      */
409     function safeTransferFrom(
410         address from,
411         address to,
412         uint256 tokenId,
413         bytes calldata data
414     ) external;
415 
416     /**
417      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
418      */
419     function safeTransferFrom(
420         address from,
421         address to,
422         uint256 tokenId
423     ) external;
424 
425     /**
426      * @dev Transfers `tokenId` from `from` to `to`.
427      *
428      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
429      * whenever possible.
430      *
431      * Requirements:
432      *
433      * - `from` cannot be the zero address.
434      * - `to` cannot be the zero address.
435      * - `tokenId` token must be owned by `from`.
436      * - If the caller is not `from`, it must be approved to move this token
437      * by either {approve} or {setApprovalForAll}.
438      *
439      * Emits a {Transfer} event.
440      */
441     function transferFrom(
442         address from,
443         address to,
444         uint256 tokenId
445     ) external;
446 
447     /**
448      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
449      * The approval is cleared when the token is transferred.
450      *
451      * Only a single account can be approved at a time, so approving the
452      * zero address clears previous approvals.
453      *
454      * Requirements:
455      *
456      * - The caller must own the token or be an approved operator.
457      * - `tokenId` must exist.
458      *
459      * Emits an {Approval} event.
460      */
461     function approve(address to, uint256 tokenId) external;
462 
463     /**
464      * @dev Approve or remove `operator` as an operator for the caller.
465      * Operators can call {transferFrom} or {safeTransferFrom}
466      * for any token owned by the caller.
467      *
468      * Requirements:
469      *
470      * - The `operator` cannot be the caller.
471      *
472      * Emits an {ApprovalForAll} event.
473      */
474     function setApprovalForAll(address operator, bool _approved) external;
475 
476     /**
477      * @dev Returns the account approved for `tokenId` token.
478      *
479      * Requirements:
480      *
481      * - `tokenId` must exist.
482      */
483     function getApproved(uint256 tokenId) external view returns (address operator);
484 
485     /**
486      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
487      *
488      * See {setApprovalForAll}.
489      */
490     function isApprovedForAll(address owner, address operator) external view returns (bool);
491 
492     // =============================================================
493     //                        IERC721Metadata
494     // =============================================================
495 
496     /**
497      * @dev Returns the token collection name.
498      */
499     function name() external view returns (string memory);
500 
501     /**
502      * @dev Returns the token collection symbol.
503      */
504     function symbol() external view returns (string memory);
505 
506     /**
507      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
508      */
509     function tokenURI(uint256 tokenId) external view returns (string memory);
510 
511     // =============================================================
512     //                           IERC2309
513     // =============================================================
514 
515     /**
516      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
517      * (inclusive) is transferred from `from` to `to`, as defined in the
518      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
519      *
520      * See {_mintERC2309} for more details.
521      */
522     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
523 }
524 
525 interface IERC20Permit {
526     /**
527      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
528      * given ``owner``'s signed approval.
529      *
530      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
531      * ordering also apply here.
532      *
533      * Emits an {Approval} event.
534      *
535      * Requirements:
536      *
537      * - `spender` cannot be the zero address.
538      * - `deadline` must be a timestamp in the future.
539      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
540      * over the EIP712-formatted function arguments.
541      * - the signature must use ``owner``'s current nonce (see {nonces}).
542      *
543      * For more information on the signature format, see the
544      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
545      * section].
546      */
547     function permit(
548         address owner,
549         address spender,
550         uint256 value,
551         uint256 deadline,
552         uint8 v,
553         bytes32 r,
554         bytes32 s
555     ) external;
556 
557     /**
558      * @dev Returns the current nonce for `owner`. This value must be
559      * included whenever a signature is generated for {permit}.
560      *
561      * Every successful call to {permit} increases ``owner``'s nonce by one. This
562      * prevents a signature from being used multiple times.
563      */
564     function nonces(address owner) external view returns (uint256);
565 
566     /**
567      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
568      */
569     // solhint-disable-next-line func-name-mixedcase
570     function DOMAIN_SEPARATOR() external view returns (bytes32);
571 }
572 
573 interface IERC20 {
574     /**
575      * @dev Emitted when `value` tokens are moved from one account (`from`) to
576      * another (`to`).
577      *
578      * Note that `value` may be zero.
579      */
580     event Transfer(address indexed from, address indexed to, uint256 value);
581 
582     /**
583      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
584      * a call to {approve}. `value` is the new allowance.
585      */
586     event Approval(address indexed owner, address indexed spender, uint256 value);
587 
588     /**
589      * @dev Returns the amount of tokens in existence.
590      */
591     function totalSupply() external view returns (uint256);
592 
593     /**
594      * @dev Returns the amount of tokens owned by `account`.
595      */
596     function balanceOf(address account) external view returns (uint256);
597 
598     /**
599      * @dev Moves `amount` tokens from the caller's account to `to`.
600      *
601      * Returns a boolean value indicating whether the operation succeeded.
602      *
603      * Emits a {Transfer} event.
604      */
605     function transfer(address to, uint256 amount) external returns (bool);
606 
607     /**
608      * @dev Returns the remaining number of tokens that `spender` will be
609      * allowed to spend on behalf of `owner` through {transferFrom}. This is
610      * zero by default.
611      *
612      * This value changes when {approve} or {transferFrom} are called.
613      */
614     function allowance(address owner, address spender) external view returns (uint256);
615 
616     /**
617      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
618      *
619      * Returns a boolean value indicating whether the operation succeeded.
620      *
621      * IMPORTANT: Beware that changing an allowance with this method brings the risk
622      * that someone may use both the old and the new allowance by unfortunate
623      * transaction ordering. One possible solution to mitigate this race
624      * condition is to first reduce the spender's allowance to 0 and set the
625      * desired value afterwards:
626      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
627      *
628      * Emits an {Approval} event.
629      */
630     function approve(address spender, uint256 amount) external returns (bool);
631 
632     /**
633      * @dev Moves `amount` tokens from `from` to `to` using the
634      * allowance mechanism. `amount` is then deducted from the caller's
635      * allowance.
636      *
637      * Returns a boolean value indicating whether the operation succeeded.
638      *
639      * Emits a {Transfer} event.
640      */
641     function transferFrom(
642         address from,
643         address to,
644         uint256 amount
645     ) external returns (bool);
646 }
647 
648 library SafeERC20 {
649     using Address for address;
650 
651     function safeTransfer(
652         IERC20 token,
653         address to,
654         uint256 value
655     ) internal {
656         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
657     }
658 
659     function safeTransferFrom(
660         IERC20 token,
661         address from,
662         address to,
663         uint256 value
664     ) internal {
665         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
666     }
667 
668     /**
669      * @dev Deprecated. This function has issues similar to the ones found in
670      * {IERC20-approve}, and its usage is discouraged.
671      *
672      * Whenever possible, use {safeIncreaseAllowance} and
673      * {safeDecreaseAllowance} instead.
674      */
675     function safeApprove(
676         IERC20 token,
677         address spender,
678         uint256 value
679     ) internal {
680         // safeApprove should only be called when setting an initial allowance,
681         // or when resetting it to zero. To increase and decrease it, use
682         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
683         require(
684             (value == 0) || (token.allowance(address(this), spender) == 0),
685             "SafeERC20: approve from non-zero to non-zero allowance"
686         );
687         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
688     }
689 
690     function safeIncreaseAllowance(
691         IERC20 token,
692         address spender,
693         uint256 value
694     ) internal {
695         uint256 newAllowance = token.allowance(address(this), spender) + value;
696         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
697     }
698 
699     function safeDecreaseAllowance(
700         IERC20 token,
701         address spender,
702         uint256 value
703     ) internal {
704         unchecked {
705             uint256 oldAllowance = token.allowance(address(this), spender);
706             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
707             uint256 newAllowance = oldAllowance - value;
708             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
709         }
710     }
711 
712     function safePermit(
713         IERC20Permit token,
714         address owner,
715         address spender,
716         uint256 value,
717         uint256 deadline,
718         uint8 v,
719         bytes32 r,
720         bytes32 s
721     ) internal {
722         uint256 nonceBefore = token.nonces(owner);
723         token.permit(owner, spender, value, deadline, v, r, s);
724         uint256 nonceAfter = token.nonces(owner);
725         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
726     }
727 
728     /**
729      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
730      * on the return value: the return value is optional (but if data is returned, it must not be false).
731      * @param token The token targeted by the call.
732      * @param data The call data (encoded using abi.encode or one of its variants).
733      */
734     function _callOptionalReturn(IERC20 token, bytes memory data) private {
735         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
736         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
737         // the target address contains contract code and also asserts for success in the low-level call.
738 
739         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
740         if (returndata.length > 0) {
741             // Return data is optional
742             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
743         }
744     }
745 }
746 
747 library Strings {
748     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
749     uint8 private constant _ADDRESS_LENGTH = 20;
750 
751     /**
752      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
753      */
754     function toString(uint256 value) internal pure returns (string memory) {
755         // Inspired by OraclizeAPI's implementation - MIT licence
756         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
757 
758         if (value == 0) {
759             return "0";
760         }
761         uint256 temp = value;
762         uint256 digits;
763         while (temp != 0) {
764             digits++;
765             temp /= 10;
766         }
767         bytes memory buffer = new bytes(digits);
768         while (value != 0) {
769             digits -= 1;
770             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
771             value /= 10;
772         }
773         return string(buffer);
774     }
775 
776     /**
777      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
778      */
779     function toHexString(uint256 value) internal pure returns (string memory) {
780         if (value == 0) {
781             return "0x00";
782         }
783         uint256 temp = value;
784         uint256 length = 0;
785         while (temp != 0) {
786             length++;
787             temp >>= 8;
788         }
789         return toHexString(value, length);
790     }
791 
792     /**
793      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
794      */
795     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
796         bytes memory buffer = new bytes(2 * length + 2);
797         buffer[0] = "0";
798         buffer[1] = "x";
799         for (uint256 i = 2 * length + 1; i > 1; --i) {
800             buffer[i] = _HEX_SYMBOLS[value & 0xf];
801             value >>= 4;
802         }
803         require(value == 0, "Strings: hex length insufficient");
804         return string(buffer);
805     }
806 
807     /**
808      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
809      */
810     function toHexString(address addr) internal pure returns (string memory) {
811         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
812     }
813 }
814 
815 abstract contract Ownable is Context {
816     address private _owner;
817 
818     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
819 
820     /**
821      * @dev Initializes the contract setting the deployer as the initial owner.
822      */
823     constructor() {
824         _transferOwnership(_msgSender());
825     }
826 
827     /**
828      * @dev Throws if called by any account other than the owner.
829      */
830     modifier onlyOwner() {
831         _checkOwner();
832         _;
833     }
834 
835     /**
836      * @dev Returns the address of the current owner.
837      */
838     function owner() public view virtual returns (address) {
839         return _owner;
840     }
841 
842     /**
843      * @dev Throws if the sender is not the owner.
844      */
845     function _checkOwner() internal view virtual {
846         require(owner() == _msgSender(), "Ownable: caller is not the owner");
847     }
848 
849     /**
850      * @dev Leaves the contract without owner. It will not be possible to call
851      * `onlyOwner` functions anymore. Can only be called by the current owner.
852      *
853      * NOTE: Renouncing ownership will leave the contract without an owner,
854      * thereby removing any functionality that is only available to the owner.
855      */
856     function renounceOwnership() public virtual onlyOwner {
857         _transferOwnership(address(0));
858     }
859 
860     /**
861      * @dev Transfers ownership of the contract to a new account (`newOwner`).
862      * Can only be called by the current owner.
863      */
864     function transferOwnership(address newOwner) public virtual onlyOwner {
865         require(newOwner != address(0), "Ownable: new owner is the zero address");
866         _transferOwnership(newOwner);
867     }
868 
869     /**
870      * @dev Transfers ownership of the contract to a new account (`newOwner`).
871      * Internal function without access restriction.
872      */
873     function _transferOwnership(address newOwner) internal virtual {
874         address oldOwner = _owner;
875         _owner = newOwner;
876         emit OwnershipTransferred(oldOwner, newOwner);
877     }
878 }
879 
880 library ECDSA {
881     enum RecoverError {
882         NoError,
883         InvalidSignature,
884         InvalidSignatureLength,
885         InvalidSignatureS,
886         InvalidSignatureV
887     }
888 
889     function _throwError(RecoverError error) private pure {
890         if (error == RecoverError.NoError) {
891             return; // no error: do nothing
892         } else if (error == RecoverError.InvalidSignature) {
893             revert("ECDSA: invalid signature");
894         } else if (error == RecoverError.InvalidSignatureLength) {
895             revert("ECDSA: invalid signature length");
896         } else if (error == RecoverError.InvalidSignatureS) {
897             revert("ECDSA: invalid signature 's' value");
898         } else if (error == RecoverError.InvalidSignatureV) {
899             revert("ECDSA: invalid signature 'v' value");
900         }
901     }
902 
903     /**
904      * @dev Returns the address that signed a hashed message (`hash`) with
905      * `signature` or error string. This address can then be used for verification purposes.
906      *
907      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
908      * this function rejects them by requiring the `s` value to be in the lower
909      * half order, and the `v` value to be either 27 or 28.
910      *
911      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
912      * verification to be secure: it is possible to craft signatures that
913      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
914      * this is by receiving a hash of the original message (which may otherwise
915      * be too long), and then calling {toEthSignedMessageHash} on it.
916      *
917      * Documentation for signature generation:
918      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
919      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
920      *
921      * _Available since v4.3._
922      */
923     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
924         // Check the signature length
925         // - case 65: r,s,v signature (standard)
926         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
927         if (signature.length == 65) {
928             bytes32 r;
929             bytes32 s;
930             uint8 v;
931             // ecrecover takes the signature parameters, and the only way to get them
932             // currently is to use assembly.
933             /// @solidity memory-safe-assembly
934             assembly {
935                 r := mload(add(signature, 0x20))
936                 s := mload(add(signature, 0x40))
937                 v := byte(0, mload(add(signature, 0x60)))
938             }
939             return tryRecover(hash, v, r, s);
940         } else if (signature.length == 64) {
941             bytes32 r;
942             bytes32 vs;
943             // ecrecover takes the signature parameters, and the only way to get them
944             // currently is to use assembly.
945             /// @solidity memory-safe-assembly
946             assembly {
947                 r := mload(add(signature, 0x20))
948                 vs := mload(add(signature, 0x40))
949             }
950             return tryRecover(hash, r, vs);
951         } else {
952             return (address(0), RecoverError.InvalidSignatureLength);
953         }
954     }
955 
956     /**
957      * @dev Returns the address that signed a hashed message (`hash`) with
958      * `signature`. This address can then be used for verification purposes.
959      *
960      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
961      * this function rejects them by requiring the `s` value to be in the lower
962      * half order, and the `v` value to be either 27 or 28.
963      *
964      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
965      * verification to be secure: it is possible to craft signatures that
966      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
967      * this is by receiving a hash of the original message (which may otherwise
968      * be too long), and then calling {toEthSignedMessageHash} on it.
969      */
970     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
971         (address recovered, RecoverError error) = tryRecover(hash, signature);
972         _throwError(error);
973         return recovered;
974     }
975 
976     /**
977      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
978      *
979      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
980      *
981      * _Available since v4.3._
982      */
983     function tryRecover(
984         bytes32 hash,
985         bytes32 r,
986         bytes32 vs
987     ) internal pure returns (address, RecoverError) {
988         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
989         uint8 v = uint8((uint256(vs) >> 255) + 27);
990         return tryRecover(hash, v, r, s);
991     }
992 
993     /**
994      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
995      *
996      * _Available since v4.2._
997      */
998     function recover(
999         bytes32 hash,
1000         bytes32 r,
1001         bytes32 vs
1002     ) internal pure returns (address) {
1003         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1004         _throwError(error);
1005         return recovered;
1006     }
1007 
1008     /**
1009      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1010      * `r` and `s` signature fields separately.
1011      *
1012      * _Available since v4.3._
1013      */
1014     function tryRecover(
1015         bytes32 hash,
1016         uint8 v,
1017         bytes32 r,
1018         bytes32 s
1019     ) internal pure returns (address, RecoverError) {
1020         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1021         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1022         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1023         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1024         //
1025         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1026         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1027         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1028         // these malleable signatures as well.
1029         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1030             return (address(0), RecoverError.InvalidSignatureS);
1031         }
1032         if (v != 27 && v != 28) {
1033             return (address(0), RecoverError.InvalidSignatureV);
1034         }
1035 
1036         // If the signature is valid (and not malleable), return the signer address
1037         address signer = ecrecover(hash, v, r, s);
1038         if (signer == address(0)) {
1039             return (address(0), RecoverError.InvalidSignature);
1040         }
1041 
1042         return (signer, RecoverError.NoError);
1043     }
1044 
1045     /**
1046      * @dev Overload of {ECDSA-recover} that receives the `v`,
1047      * `r` and `s` signature fields separately.
1048      */
1049     function recover(
1050         bytes32 hash,
1051         uint8 v,
1052         bytes32 r,
1053         bytes32 s
1054     ) internal pure returns (address) {
1055         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1056         _throwError(error);
1057         return recovered;
1058     }
1059 
1060     /**
1061      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1062      * produces hash corresponding to the one signed with the
1063      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1064      * JSON-RPC method as part of EIP-191.
1065      *
1066      * See {recover}.
1067      */
1068     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1069         // 32 is the length in bytes of hash,
1070         // enforced by the type signature above
1071         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1072     }
1073 
1074     /**
1075      * @dev Returns an Ethereum Signed Message, created from `s`. This
1076      * produces hash corresponding to the one signed with the
1077      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1078      * JSON-RPC method as part of EIP-191.
1079      *
1080      * See {recover}.
1081      */
1082     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1083         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1084     }
1085 
1086     /**
1087      * @dev Returns an Ethereum Signed Typed Data, created from a
1088      * `domainSeparator` and a `structHash`. This produces hash corresponding
1089      * to the one signed with the
1090      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1091      * JSON-RPC method as part of EIP-712.
1092      *
1093      * See {recover}.
1094      */
1095     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1096         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1097     }
1098 }
1099 
1100 contract PaymentSplitter is Context {
1101     event PayeeAdded(address account, uint256 shares);
1102     event PaymentReleased(address to, uint256 amount);
1103     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
1104     event PaymentReceived(address from, uint256 amount);
1105 
1106     uint256 private _totalShares;
1107     uint256 private _totalReleased;
1108 
1109     mapping(address => uint256) private _shares;
1110     mapping(address => uint256) private _released;
1111     address[] private _payees;
1112 
1113     mapping(IERC20 => uint256) private _erc20TotalReleased;
1114     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
1115 
1116     /**
1117      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1118      * the matching position in the `shares` array.
1119      *
1120      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1121      * duplicates in `payees`.
1122      */
1123     constructor(address[] memory payees, uint256[] memory shares_) payable {
1124         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1125         require(payees.length > 0, "PaymentSplitter: no payees");
1126 
1127         for (uint256 i = 0; i < payees.length; i++) {
1128             _addPayee(payees[i], shares_[i]);
1129         }
1130     }
1131 
1132     /**
1133      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1134      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1135      * reliability of the events, and not the actual splitting of Ether.
1136      *
1137      * To learn more about this see the Solidity documentation for
1138      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1139      * functions].
1140      */
1141     receive() external payable virtual {
1142         emit PaymentReceived(_msgSender(), msg.value);
1143     }
1144 
1145     /**
1146      * @dev Getter for the total shares held by payees.
1147      */
1148     function totalShares() public view returns (uint256) {
1149         return _totalShares;
1150     }
1151 
1152     /**
1153      * @dev Getter for the total amount of Ether already released.
1154      */
1155     function totalReleased() public view returns (uint256) {
1156         return _totalReleased;
1157     }
1158 
1159     /**
1160      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
1161      * contract.
1162      */
1163     function totalReleased(IERC20 token) public view returns (uint256) {
1164         return _erc20TotalReleased[token];
1165     }
1166 
1167     /**
1168      * @dev Getter for the amount of shares held by an account.
1169      */
1170     function shares(address account) public view returns (uint256) {
1171         return _shares[account];
1172     }
1173 
1174     /**
1175      * @dev Getter for the amount of Ether already released to a payee.
1176      */
1177     function released(address account) public view returns (uint256) {
1178         return _released[account];
1179     }
1180 
1181     /**
1182      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
1183      * IERC20 contract.
1184      */
1185     function released(IERC20 token, address account) public view returns (uint256) {
1186         return _erc20Released[token][account];
1187     }
1188 
1189     /**
1190      * @dev Getter for the address of the payee number `index`.
1191      */
1192     function payee(uint256 index) public view returns (address) {
1193         return _payees[index];
1194     }
1195 
1196     /**
1197      * @dev Getter for the amount of payee's releasable Ether.
1198      */
1199     function releasable(address account) public view returns (uint256) {
1200         uint256 totalReceived = address(this).balance + totalReleased();
1201         return _pendingPayment(account, totalReceived, released(account));
1202     }
1203 
1204     /**
1205      * @dev Getter for the amount of payee's releasable `token` tokens. `token` should be the address of an
1206      * IERC20 contract.
1207      */
1208     function releasable(IERC20 token, address account) public view returns (uint256) {
1209         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1210         return _pendingPayment(account, totalReceived, released(token, account));
1211     }
1212 
1213     /**
1214      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1215      * total shares and their previous withdrawals.
1216      */
1217     function release(address payable account) public virtual {
1218         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1219 
1220         uint256 payment = releasable(account);
1221 
1222         require(payment != 0, "PaymentSplitter: account is not due payment");
1223 
1224         _released[account] += payment;
1225         _totalReleased += payment;
1226 
1227         Address.sendValue(account, payment);
1228         emit PaymentReleased(account, payment);
1229     }
1230 
1231     /**
1232      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1233      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1234      * contract.
1235      */
1236     function release(IERC20 token, address account) public virtual {
1237         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1238 
1239         uint256 payment = releasable(token, account);
1240 
1241         require(payment != 0, "PaymentSplitter: account is not due payment");
1242 
1243         _erc20Released[token][account] += payment;
1244         _erc20TotalReleased[token] += payment;
1245 
1246         SafeERC20.safeTransfer(token, account, payment);
1247         emit ERC20PaymentReleased(token, account, payment);
1248     }
1249 
1250     /**
1251      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1252      * already released amounts.
1253      */
1254     function _pendingPayment(
1255         address account,
1256         uint256 totalReceived,
1257         uint256 alreadyReleased
1258     ) private view returns (uint256) {
1259         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1260     }
1261 
1262     /**
1263      * @dev Add a new payee to the contract.
1264      * @param account The address of the payee to add.
1265      * @param shares_ The number of shares owned by the payee.
1266      */
1267     function _addPayee(address account, uint256 shares_) private {
1268         require(account != address(0), "PaymentSplitter: account is the zero address");
1269         require(shares_ > 0, "PaymentSplitter: shares are 0");
1270         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1271 
1272         _payees.push(account);
1273         _shares[account] = shares_;
1274         _totalShares = _totalShares + shares_;
1275         emit PayeeAdded(account, shares_);
1276     }
1277 }
1278 
1279 /**
1280  * @dev Interface of ERC721 token receiver.
1281  */
1282 interface ERC721A__IERC721Receiver {
1283     function onERC721Received(
1284         address operator,
1285         address from,
1286         uint256 tokenId,
1287         bytes calldata data
1288     ) external returns (bytes4);
1289 }
1290 
1291 /**
1292  * @title ERC721A
1293  *
1294  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1295  * Non-Fungible Token Standard, including the Metadata extension.
1296  * Optimized for lower gas during batch mints.
1297  *
1298  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1299  * starting from `_startTokenId()`.
1300  *
1301  * Assumptions:
1302  *
1303  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1304  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1305  */
1306 contract ERC721A is IERC721A {
1307     // Reference type for token approval.
1308     struct TokenApprovalRef {
1309         address value;
1310     }
1311 
1312     // =============================================================
1313     //                           CONSTANTS
1314     // =============================================================
1315 
1316     // Mask of an entry in packed address data.
1317     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1318 
1319     // The bit position of `numberMinted` in packed address data.
1320     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1321 
1322     // The bit position of `numberBurned` in packed address data.
1323     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1324 
1325     // The bit position of `aux` in packed address data.
1326     uint256 private constant _BITPOS_AUX = 192;
1327 
1328     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1329     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1330 
1331     // The bit position of `startTimestamp` in packed ownership.
1332     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1333 
1334     // The bit mask of the `burned` bit in packed ownership.
1335     uint256 private constant _BITMASK_BURNED = 1 << 224;
1336 
1337     // The bit position of the `nextInitialized` bit in packed ownership.
1338     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1339 
1340     // The bit mask of the `nextInitialized` bit in packed ownership.
1341     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1342 
1343     // The bit position of `extraData` in packed ownership.
1344     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1345 
1346     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1347     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1348 
1349     // The mask of the lower 160 bits for addresses.
1350     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1351 
1352     // The maximum `quantity` that can be minted with {_mintERC2309}.
1353     // This limit is to prevent overflows on the address data entries.
1354     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1355     // is required to cause an overflow, which is unrealistic.
1356     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1357 
1358     // The `Transfer` event signature is given by:
1359     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1360     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1361         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1362 
1363     // =============================================================
1364     //                            STORAGE
1365     // =============================================================
1366 
1367     // The next token ID to be minted.
1368     uint256 private _currentIndex;
1369 
1370     // The number of tokens burned.
1371     uint256 private _burnCounter;
1372 
1373     // Token name
1374     string private _name;
1375 
1376     // Token symbol
1377     string private _symbol;
1378 
1379     // Mapping from token ID to ownership details
1380     // An empty struct value does not necessarily mean the token is unowned.
1381     // See {_packedOwnershipOf} implementation for details.
1382     //
1383     // Bits Layout:
1384     // - [0..159]   `addr`
1385     // - [160..223] `startTimestamp`
1386     // - [224]      `burned`
1387     // - [225]      `nextInitialized`
1388     // - [232..255] `extraData`
1389     mapping(uint256 => uint256) private _packedOwnerships;
1390 
1391     // Mapping owner address to address data.
1392     //
1393     // Bits Layout:
1394     // - [0..63]    `balance`
1395     // - [64..127]  `numberMinted`
1396     // - [128..191] `numberBurned`
1397     // - [192..255] `aux`
1398     mapping(address => uint256) private _packedAddressData;
1399 
1400     // Mapping from token ID to approved address.
1401     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1402 
1403     // Mapping from owner to operator approvals
1404     mapping(address => mapping(address => bool)) private _operatorApprovals;
1405 
1406     // =============================================================
1407     //                          CONSTRUCTOR
1408     // =============================================================
1409 
1410     constructor(string memory name_, string memory symbol_) {
1411         _name = name_;
1412         _symbol = symbol_;
1413         _currentIndex = _startTokenId();
1414     }
1415 
1416     // =============================================================
1417     //                   TOKEN COUNTING OPERATIONS
1418     // =============================================================
1419 
1420     /**
1421      * @dev Returns the starting token ID.
1422      * To change the starting token ID, please override this function.
1423      */
1424     function _startTokenId() internal view virtual returns (uint256) {
1425         return 0;
1426     }
1427 
1428     /**
1429      * @dev Returns the next token ID to be minted.
1430      */
1431     function _nextTokenId() internal view virtual returns (uint256) {
1432         return _currentIndex;
1433     }
1434 
1435     /**
1436      * @dev Returns the total number of tokens in existence.
1437      * Burned tokens will reduce the count.
1438      * To get the total number of tokens minted, please see {_totalMinted}.
1439      */
1440     function totalSupply() public view virtual override returns (uint256) {
1441         // Counter underflow is impossible as _burnCounter cannot be incremented
1442         // more than `_currentIndex - _startTokenId()` times.
1443         unchecked {
1444             return _currentIndex - _burnCounter - _startTokenId();
1445         }
1446     }
1447 
1448     /**
1449      * @dev Returns the total amount of tokens minted in the contract.
1450      */
1451     function _totalMinted() internal view virtual returns (uint256) {
1452         // Counter underflow is impossible as `_currentIndex` does not decrement,
1453         // and it is initialized to `_startTokenId()`.
1454         unchecked {
1455             return _currentIndex - _startTokenId();
1456         }
1457     }
1458 
1459     /**
1460      * @dev Returns the total number of tokens burned.
1461      */
1462     function _totalBurned() internal view virtual returns (uint256) {
1463         return _burnCounter;
1464     }
1465 
1466     // =============================================================
1467     //                    ADDRESS DATA OPERATIONS
1468     // =============================================================
1469 
1470     /**
1471      * @dev Returns the number of tokens in `owner`'s account.
1472      */
1473     function balanceOf(address owner) public view virtual override returns (uint256) {
1474         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1475         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1476     }
1477 
1478     /**
1479      * Returns the number of tokens minted by `owner`.
1480      */
1481     function _numberMinted(address owner) internal view returns (uint256) {
1482         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1483     }
1484 
1485     /**
1486      * Returns the number of tokens burned by or on behalf of `owner`.
1487      */
1488     function _numberBurned(address owner) internal view returns (uint256) {
1489         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1490     }
1491 
1492     /**
1493      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1494      */
1495     function _getAux(address owner) internal view returns (uint64) {
1496         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1497     }
1498 
1499     /**
1500      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1501      * If there are multiple variables, please pack them into a uint64.
1502      */
1503     function _setAux(address owner, uint64 aux) internal virtual {
1504         uint256 packed = _packedAddressData[owner];
1505         uint256 auxCasted;
1506         // Cast `aux` with assembly to avoid redundant masking.
1507         assembly {
1508             auxCasted := aux
1509         }
1510         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1511         _packedAddressData[owner] = packed;
1512     }
1513 
1514     // =============================================================
1515     //                            IERC165
1516     // =============================================================
1517 
1518     /**
1519      * @dev Returns true if this contract implements the interface defined by
1520      * `interfaceId`. See the corresponding
1521      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1522      * to learn more about how these ids are created.
1523      *
1524      * This function call must use less than 30000 gas.
1525      */
1526     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1527         // The interface IDs are constants representing the first 4 bytes
1528         // of the XOR of all function selectors in the interface.
1529         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1530         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1531         return
1532             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1533             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1534             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1535     }
1536 
1537     // =============================================================
1538     //                        IERC721Metadata
1539     // =============================================================
1540 
1541     /**
1542      * @dev Returns the token collection name.
1543      */
1544     function name() public view virtual override returns (string memory) {
1545         return _name;
1546     }
1547 
1548     /**
1549      * @dev Returns the token collection symbol.
1550      */
1551     function symbol() public view virtual override returns (string memory) {
1552         return _symbol;
1553     }
1554 
1555     /**
1556      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1557      */
1558     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1559         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1560 
1561         string memory baseURI = _baseURI();
1562         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1563     }
1564 
1565     /**
1566      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1567      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1568      * by default, it can be overridden in child contracts.
1569      */
1570     function _baseURI() internal view virtual returns (string memory) {
1571         return '';
1572     }
1573 
1574     // =============================================================
1575     //                     OWNERSHIPS OPERATIONS
1576     // =============================================================
1577 
1578     /**
1579      * @dev Returns the owner of the `tokenId` token.
1580      *
1581      * Requirements:
1582      *
1583      * - `tokenId` must exist.
1584      */
1585     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1586         return address(uint160(_packedOwnershipOf(tokenId)));
1587     }
1588 
1589     /**
1590      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1591      * It gradually moves to O(1) as tokens get transferred around over time.
1592      */
1593     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1594         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1595     }
1596 
1597     /**
1598      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1599      */
1600     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1601         return _unpackedOwnership(_packedOwnerships[index]);
1602     }
1603 
1604     /**
1605      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1606      */
1607     function _initializeOwnershipAt(uint256 index) internal virtual {
1608         if (_packedOwnerships[index] == 0) {
1609             _packedOwnerships[index] = _packedOwnershipOf(index);
1610         }
1611     }
1612 
1613     /**
1614      * Returns the packed ownership data of `tokenId`.
1615      */
1616     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1617         uint256 curr = tokenId;
1618 
1619         unchecked {
1620             if (_startTokenId() <= curr)
1621                 if (curr < _currentIndex) {
1622                     uint256 packed = _packedOwnerships[curr];
1623                     // If not burned.
1624                     if (packed & _BITMASK_BURNED == 0) {
1625                         // Invariant:
1626                         // There will always be an initialized ownership slot
1627                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1628                         // before an unintialized ownership slot
1629                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1630                         // Hence, `curr` will not underflow.
1631                         //
1632                         // We can directly compare the packed value.
1633                         // If the address is zero, packed will be zero.
1634                         while (packed == 0) {
1635                             packed = _packedOwnerships[--curr];
1636                         }
1637                         return packed;
1638                     }
1639                 }
1640         }
1641         revert OwnerQueryForNonexistentToken();
1642     }
1643 
1644     /**
1645      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1646      */
1647     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1648         ownership.addr = address(uint160(packed));
1649         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1650         ownership.burned = packed & _BITMASK_BURNED != 0;
1651         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1652     }
1653 
1654     /**
1655      * @dev Packs ownership data into a single uint256.
1656      */
1657     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1658         assembly {
1659             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1660             owner := and(owner, _BITMASK_ADDRESS)
1661             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1662             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1663         }
1664     }
1665 
1666     /**
1667      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1668      */
1669     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1670         // For branchless setting of the `nextInitialized` flag.
1671         assembly {
1672             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1673             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1674         }
1675     }
1676 
1677     // =============================================================
1678     //                      APPROVAL OPERATIONS
1679     // =============================================================
1680 
1681     /**
1682      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1683      * The approval is cleared when the token is transferred.
1684      *
1685      * Only a single account can be approved at a time, so approving the
1686      * zero address clears previous approvals.
1687      *
1688      * Requirements:
1689      *
1690      * - The caller must own the token or be an approved operator.
1691      * - `tokenId` must exist.
1692      *
1693      * Emits an {Approval} event.
1694      */
1695     function approve(address to, uint256 tokenId) public virtual override {
1696         address owner = ownerOf(tokenId);
1697 
1698         if (_msgSenderERC721A() != owner)
1699             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1700                 revert ApprovalCallerNotOwnerNorApproved();
1701             }
1702 
1703         _tokenApprovals[tokenId].value = to;
1704         emit Approval(owner, to, tokenId);
1705     }
1706 
1707     /**
1708      * @dev Returns the account approved for `tokenId` token.
1709      *
1710      * Requirements:
1711      *
1712      * - `tokenId` must exist.
1713      */
1714     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1715         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1716 
1717         return _tokenApprovals[tokenId].value;
1718     }
1719 
1720     /**
1721      * @dev Approve or remove `operator` as an operator for the caller.
1722      * Operators can call {transferFrom} or {safeTransferFrom}
1723      * for any token owned by the caller.
1724      *
1725      * Requirements:
1726      *
1727      * - The `operator` cannot be the caller.
1728      *
1729      * Emits an {ApprovalForAll} event.
1730      */
1731     function setApprovalForAll(address operator, bool approved) public virtual override {
1732         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1733 
1734         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1735         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1736     }
1737 
1738     /**
1739      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1740      *
1741      * See {setApprovalForAll}.
1742      */
1743     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1744         return _operatorApprovals[owner][operator];
1745     }
1746 
1747     /**
1748      * @dev Returns whether `tokenId` exists.
1749      *
1750      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1751      *
1752      * Tokens start existing when they are minted. See {_mint}.
1753      */
1754     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1755         return
1756             _startTokenId() <= tokenId &&
1757             tokenId < _currentIndex && // If within bounds,
1758             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1759     }
1760 
1761     /**
1762      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1763      */
1764     function _isSenderApprovedOrOwner(
1765         address approvedAddress,
1766         address owner,
1767         address msgSender
1768     ) private pure returns (bool result) {
1769         assembly {
1770             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1771             owner := and(owner, _BITMASK_ADDRESS)
1772             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1773             msgSender := and(msgSender, _BITMASK_ADDRESS)
1774             // `msgSender == owner || msgSender == approvedAddress`.
1775             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1776         }
1777     }
1778 
1779     /**
1780      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1781      */
1782     function _getApprovedSlotAndAddress(uint256 tokenId)
1783         private
1784         view
1785         returns (uint256 approvedAddressSlot, address approvedAddress)
1786     {
1787         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1788         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1789         assembly {
1790             approvedAddressSlot := tokenApproval.slot
1791             approvedAddress := sload(approvedAddressSlot)
1792         }
1793     }
1794 
1795     // =============================================================
1796     //                      TRANSFER OPERATIONS
1797     // =============================================================
1798 
1799     /**
1800      * @dev Transfers `tokenId` from `from` to `to`.
1801      *
1802      * Requirements:
1803      *
1804      * - `from` cannot be the zero address.
1805      * - `to` cannot be the zero address.
1806      * - `tokenId` token must be owned by `from`.
1807      * - If the caller is not `from`, it must be approved to move this token
1808      * by either {approve} or {setApprovalForAll}.
1809      *
1810      * Emits a {Transfer} event.
1811      */
1812     function transferFrom(
1813         address from,
1814         address to,
1815         uint256 tokenId
1816     ) public virtual override {
1817         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1818 
1819         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1820 
1821         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1822 
1823         // The nested ifs save around 20+ gas over a compound boolean condition.
1824         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1825             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1826 
1827         if (to == address(0)) revert TransferToZeroAddress();
1828 
1829         _beforeTokenTransfers(from, to, tokenId, 1);
1830 
1831         // Clear approvals from the previous owner.
1832         assembly {
1833             if approvedAddress {
1834                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1835                 sstore(approvedAddressSlot, 0)
1836             }
1837         }
1838 
1839         // Underflow of the sender's balance is impossible because we check for
1840         // ownership above and the recipient's balance can't realistically overflow.
1841         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1842         unchecked {
1843             // We can directly increment and decrement the balances.
1844             --_packedAddressData[from]; // Updates: `balance -= 1`.
1845             ++_packedAddressData[to]; // Updates: `balance += 1`.
1846 
1847             // Updates:
1848             // - `address` to the next owner.
1849             // - `startTimestamp` to the timestamp of transfering.
1850             // - `burned` to `false`.
1851             // - `nextInitialized` to `true`.
1852             _packedOwnerships[tokenId] = _packOwnershipData(
1853                 to,
1854                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1855             );
1856 
1857             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1858             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1859                 uint256 nextTokenId = tokenId + 1;
1860                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1861                 if (_packedOwnerships[nextTokenId] == 0) {
1862                     // If the next slot is within bounds.
1863                     if (nextTokenId != _currentIndex) {
1864                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1865                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1866                     }
1867                 }
1868             }
1869         }
1870 
1871         emit Transfer(from, to, tokenId);
1872         _afterTokenTransfers(from, to, tokenId, 1);
1873     }
1874 
1875     /**
1876      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1877      */
1878     function safeTransferFrom(
1879         address from,
1880         address to,
1881         uint256 tokenId
1882     ) public virtual override {
1883         safeTransferFrom(from, to, tokenId, '');
1884     }
1885 
1886     /**
1887      * @dev Safely transfers `tokenId` token from `from` to `to`.
1888      *
1889      * Requirements:
1890      *
1891      * - `from` cannot be the zero address.
1892      * - `to` cannot be the zero address.
1893      * - `tokenId` token must exist and be owned by `from`.
1894      * - If the caller is not `from`, it must be approved to move this token
1895      * by either {approve} or {setApprovalForAll}.
1896      * - If `to` refers to a smart contract, it must implement
1897      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1898      *
1899      * Emits a {Transfer} event.
1900      */
1901     function safeTransferFrom(
1902         address from,
1903         address to,
1904         uint256 tokenId,
1905         bytes memory _data
1906     ) public virtual override {
1907         transferFrom(from, to, tokenId);
1908         if (to.code.length != 0)
1909             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1910                 revert TransferToNonERC721ReceiverImplementer();
1911             }
1912     }
1913 
1914     /**
1915      * @dev Hook that is called before a set of serially-ordered token IDs
1916      * are about to be transferred. This includes minting.
1917      * And also called before burning one token.
1918      *
1919      * `startTokenId` - the first token ID to be transferred.
1920      * `quantity` - the amount to be transferred.
1921      *
1922      * Calling conditions:
1923      *
1924      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1925      * transferred to `to`.
1926      * - When `from` is zero, `tokenId` will be minted for `to`.
1927      * - When `to` is zero, `tokenId` will be burned by `from`.
1928      * - `from` and `to` are never both zero.
1929      */
1930     function _beforeTokenTransfers(
1931         address from,
1932         address to,
1933         uint256 startTokenId,
1934         uint256 quantity
1935     ) internal virtual {}
1936 
1937     /**
1938      * @dev Hook that is called after a set of serially-ordered token IDs
1939      * have been transferred. This includes minting.
1940      * And also called after one token has been burned.
1941      *
1942      * `startTokenId` - the first token ID to be transferred.
1943      * `quantity` - the amount to be transferred.
1944      *
1945      * Calling conditions:
1946      *
1947      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1948      * transferred to `to`.
1949      * - When `from` is zero, `tokenId` has been minted for `to`.
1950      * - When `to` is zero, `tokenId` has been burned by `from`.
1951      * - `from` and `to` are never both zero.
1952      */
1953     function _afterTokenTransfers(
1954         address from,
1955         address to,
1956         uint256 startTokenId,
1957         uint256 quantity
1958     ) internal virtual {}
1959 
1960     /**
1961      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1962      *
1963      * `from` - Previous owner of the given token ID.
1964      * `to` - Target address that will receive the token.
1965      * `tokenId` - Token ID to be transferred.
1966      * `_data` - Optional data to send along with the call.
1967      *
1968      * Returns whether the call correctly returned the expected magic value.
1969      */
1970     function _checkContractOnERC721Received(
1971         address from,
1972         address to,
1973         uint256 tokenId,
1974         bytes memory _data
1975     ) private returns (bool) {
1976         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1977             bytes4 retval
1978         ) {
1979             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1980         } catch (bytes memory reason) {
1981             if (reason.length == 0) {
1982                 revert TransferToNonERC721ReceiverImplementer();
1983             } else {
1984                 assembly {
1985                     revert(add(32, reason), mload(reason))
1986                 }
1987             }
1988         }
1989     }
1990 
1991     // =============================================================
1992     //                        MINT OPERATIONS
1993     // =============================================================
1994 
1995     /**
1996      * @dev Mints `quantity` tokens and transfers them to `to`.
1997      *
1998      * Requirements:
1999      *
2000      * - `to` cannot be the zero address.
2001      * - `quantity` must be greater than 0.
2002      *
2003      * Emits a {Transfer} event for each mint.
2004      */
2005     function _mint(address to, uint256 quantity) internal virtual {
2006         uint256 startTokenId = _currentIndex;
2007         if (quantity == 0) revert MintZeroQuantity();
2008 
2009         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2010 
2011         // Overflows are incredibly unrealistic.
2012         // `balance` and `numberMinted` have a maximum limit of 2**64.
2013         // `tokenId` has a maximum limit of 2**256.
2014         unchecked {
2015             // Updates:
2016             // - `balance += quantity`.
2017             // - `numberMinted += quantity`.
2018             //
2019             // We can directly add to the `balance` and `numberMinted`.
2020             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2021 
2022             // Updates:
2023             // - `address` to the owner.
2024             // - `startTimestamp` to the timestamp of minting.
2025             // - `burned` to `false`.
2026             // - `nextInitialized` to `quantity == 1`.
2027             _packedOwnerships[startTokenId] = _packOwnershipData(
2028                 to,
2029                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2030             );
2031 
2032             uint256 toMasked;
2033             uint256 end = startTokenId + quantity;
2034 
2035             // Use assembly to loop and emit the `Transfer` event for gas savings.
2036             assembly {
2037                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2038                 toMasked := and(to, _BITMASK_ADDRESS)
2039                 // Emit the `Transfer` event.
2040                 log4(
2041                     0, // Start of data (0, since no data).
2042                     0, // End of data (0, since no data).
2043                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2044                     0, // `address(0)`.
2045                     toMasked, // `to`.
2046                     startTokenId // `tokenId`.
2047                 )
2048 
2049                 for {
2050                     let tokenId := add(startTokenId, 1)
2051                 } iszero(eq(tokenId, end)) {
2052                     tokenId := add(tokenId, 1)
2053                 } {
2054                     // Emit the `Transfer` event. Similar to above.
2055                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2056                 }
2057             }
2058             if (toMasked == 0) revert MintToZeroAddress();
2059 
2060             _currentIndex = end;
2061         }
2062         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2063     }
2064 
2065     /**
2066      * @dev Mints `quantity` tokens and transfers them to `to`.
2067      *
2068      * This function is intended for efficient minting only during contract creation.
2069      *
2070      * It emits only one {ConsecutiveTransfer} as defined in
2071      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2072      * instead of a sequence of {Transfer} event(s).
2073      *
2074      * Calling this function outside of contract creation WILL make your contract
2075      * non-compliant with the ERC721 standard.
2076      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2077      * {ConsecutiveTransfer} event is only permissible during contract creation.
2078      *
2079      * Requirements:
2080      *
2081      * - `to` cannot be the zero address.
2082      * - `quantity` must be greater than 0.
2083      *
2084      * Emits a {ConsecutiveTransfer} event.
2085      */
2086     function _mintERC2309(address to, uint256 quantity) internal virtual {
2087         uint256 startTokenId = _currentIndex;
2088         if (to == address(0)) revert MintToZeroAddress();
2089         if (quantity == 0) revert MintZeroQuantity();
2090         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2091 
2092         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2093 
2094         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2095         unchecked {
2096             // Updates:
2097             // - `balance += quantity`.
2098             // - `numberMinted += quantity`.
2099             //
2100             // We can directly add to the `balance` and `numberMinted`.
2101             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2102 
2103             // Updates:
2104             // - `address` to the owner.
2105             // - `startTimestamp` to the timestamp of minting.
2106             // - `burned` to `false`.
2107             // - `nextInitialized` to `quantity == 1`.
2108             _packedOwnerships[startTokenId] = _packOwnershipData(
2109                 to,
2110                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2111             );
2112 
2113             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2114 
2115             _currentIndex = startTokenId + quantity;
2116         }
2117         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2118     }
2119 
2120     /**
2121      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2122      *
2123      * Requirements:
2124      *
2125      * - If `to` refers to a smart contract, it must implement
2126      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2127      * - `quantity` must be greater than 0.
2128      *
2129      * See {_mint}.
2130      *
2131      * Emits a {Transfer} event for each mint.
2132      */
2133     function _safeMint(
2134         address to,
2135         uint256 quantity,
2136         bytes memory _data
2137     ) internal virtual {
2138         _mint(to, quantity);
2139 
2140         unchecked {
2141             if (to.code.length != 0) {
2142                 uint256 end = _currentIndex;
2143                 uint256 index = end - quantity;
2144                 do {
2145                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2146                         revert TransferToNonERC721ReceiverImplementer();
2147                     }
2148                 } while (index < end);
2149                 // Reentrancy protection.
2150                 if (_currentIndex != end) revert();
2151             }
2152         }
2153     }
2154 
2155     /**
2156      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2157      */
2158     function _safeMint(address to, uint256 quantity) internal virtual {
2159         _safeMint(to, quantity, '');
2160     }
2161 
2162     // =============================================================
2163     //                        BURN OPERATIONS
2164     // =============================================================
2165 
2166     /**
2167      * @dev Equivalent to `_burn(tokenId, false)`.
2168      */
2169     function _burn(uint256 tokenId) internal virtual {
2170         _burn(tokenId, false);
2171     }
2172 
2173     /**
2174      * @dev Destroys `tokenId`.
2175      * The approval is cleared when the token is burned.
2176      *
2177      * Requirements:
2178      *
2179      * - `tokenId` must exist.
2180      *
2181      * Emits a {Transfer} event.
2182      */
2183     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2184         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2185 
2186         address from = address(uint160(prevOwnershipPacked));
2187 
2188         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2189 
2190         if (approvalCheck) {
2191             // The nested ifs save around 20+ gas over a compound boolean condition.
2192             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2193                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2194         }
2195 
2196         _beforeTokenTransfers(from, address(0), tokenId, 1);
2197 
2198         // Clear approvals from the previous owner.
2199         assembly {
2200             if approvedAddress {
2201                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2202                 sstore(approvedAddressSlot, 0)
2203             }
2204         }
2205 
2206         // Underflow of the sender's balance is impossible because we check for
2207         // ownership above and the recipient's balance can't realistically overflow.
2208         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2209         unchecked {
2210             // Updates:
2211             // - `balance -= 1`.
2212             // - `numberBurned += 1`.
2213             //
2214             // We can directly decrement the balance, and increment the number burned.
2215             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2216             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2217 
2218             // Updates:
2219             // - `address` to the last owner.
2220             // - `startTimestamp` to the timestamp of burning.
2221             // - `burned` to `true`.
2222             // - `nextInitialized` to `true`.
2223             _packedOwnerships[tokenId] = _packOwnershipData(
2224                 from,
2225                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2226             );
2227 
2228             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2229             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2230                 uint256 nextTokenId = tokenId + 1;
2231                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2232                 if (_packedOwnerships[nextTokenId] == 0) {
2233                     // If the next slot is within bounds.
2234                     if (nextTokenId != _currentIndex) {
2235                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2236                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2237                     }
2238                 }
2239             }
2240         }
2241 
2242         emit Transfer(from, address(0), tokenId);
2243         _afterTokenTransfers(from, address(0), tokenId, 1);
2244 
2245         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2246         unchecked {
2247             _burnCounter++;
2248         }
2249     }
2250 
2251     // =============================================================
2252     //                     EXTRA DATA OPERATIONS
2253     // =============================================================
2254 
2255     /**
2256      * @dev Directly sets the extra data for the ownership data `index`.
2257      */
2258     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2259         uint256 packed = _packedOwnerships[index];
2260         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2261         uint256 extraDataCasted;
2262         // Cast `extraData` with assembly to avoid redundant masking.
2263         assembly {
2264             extraDataCasted := extraData
2265         }
2266         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2267         _packedOwnerships[index] = packed;
2268     }
2269 
2270     /**
2271      * @dev Called during each token transfer to set the 24bit `extraData` field.
2272      * Intended to be overridden by the cosumer contract.
2273      *
2274      * `previousExtraData` - the value of `extraData` before transfer.
2275      *
2276      * Calling conditions:
2277      *
2278      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2279      * transferred to `to`.
2280      * - When `from` is zero, `tokenId` will be minted for `to`.
2281      * - When `to` is zero, `tokenId` will be burned by `from`.
2282      * - `from` and `to` are never both zero.
2283      */
2284     function _extraData(
2285         address from,
2286         address to,
2287         uint24 previousExtraData
2288     ) internal view virtual returns (uint24) {}
2289 
2290     /**
2291      * @dev Returns the next extra data for the packed ownership data.
2292      * The returned result is shifted into position.
2293      */
2294     function _nextExtraData(
2295         address from,
2296         address to,
2297         uint256 prevOwnershipPacked
2298     ) private view returns (uint256) {
2299         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2300         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2301     }
2302 
2303     // =============================================================
2304     //                       OTHER OPERATIONS
2305     // =============================================================
2306 
2307     /**
2308      * @dev Returns the message sender (defaults to `msg.sender`).
2309      *
2310      * If you are writing GSN compatible contracts, you need to override this function.
2311      */
2312     function _msgSenderERC721A() internal view virtual returns (address) {
2313         return msg.sender;
2314     }
2315 
2316     /**
2317      * @dev Converts a uint256 to its ASCII string decimal representation.
2318      */
2319     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
2320         assembly {
2321             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
2322             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
2323             // We will need 1 32-byte word to store the length,
2324             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
2325             ptr := add(mload(0x40), 128)
2326             // Update the free memory pointer to allocate.
2327             mstore(0x40, ptr)
2328 
2329             // Cache the end of the memory to calculate the length later.
2330             let end := ptr
2331 
2332             // We write the string from the rightmost digit to the leftmost digit.
2333             // The following is essentially a do-while loop that also handles the zero case.
2334             // Costs a bit more than early returning for the zero case,
2335             // but cheaper in terms of deployment and overall runtime costs.
2336             for {
2337                 // Initialize and perform the first pass without check.
2338                 let temp := value
2339                 // Move the pointer 1 byte leftwards to point to an empty character slot.
2340                 ptr := sub(ptr, 1)
2341                 // Write the character to the pointer.
2342                 // The ASCII index of the '0' character is 48.
2343                 mstore8(ptr, add(48, mod(temp, 10)))
2344                 temp := div(temp, 10)
2345             } temp {
2346                 // Keep dividing `temp` until zero.
2347                 temp := div(temp, 10)
2348             } {
2349                 // Body of the for loop.
2350                 ptr := sub(ptr, 1)
2351                 mstore8(ptr, add(48, mod(temp, 10)))
2352             }
2353 
2354             let length := sub(end, ptr)
2355             // Move the pointer 32 bytes leftwards to make room for the length.
2356             ptr := sub(ptr, 32)
2357             // Store the length.
2358             mstore(ptr, length)
2359         }
2360     }
2361 }
2362 
2363 contract MenaceWarriors is Ownable, ERC721A, PaymentSplitter {
2364 
2365     using ECDSA for bytes32;
2366     using Strings for uint;
2367 
2368     address private signerAddressVIP;
2369     address private signerAddressWL;
2370 
2371     enum Step {
2372         Before,
2373         VIPSale,
2374         WhitelistSale,
2375         PublicSale,
2376         SoldOut,
2377         Reveal
2378     }
2379 
2380     string public baseURI;
2381 
2382     Step public sellingStep;
2383 
2384     uint private constant MAX_SUPPLY = 8888;
2385     uint private constant MAX_VIP = 1888;
2386 
2387     uint public wlSalePrice = 0.0088 ether;
2388     uint public publicSalePrice = 0.02 ether;
2389 
2390     mapping(address => uint) public mintedAmountNFTsperWalletWhitelistSale;
2391     mapping(address => uint) public mintedAmountNFTsperWalletVIPSale;
2392 
2393     uint public maxMintAmountPerVIP = 1;
2394     uint public maxMintAmountPerWhitelist = 3; 
2395 
2396     uint public maxAmountPerTxnPublic = 3; 
2397 
2398     uint private teamLength;
2399 
2400     constructor(address[] memory _team, uint[] memory _teamShares, address _signerAddressVIP, address _signerAddressWL, string memory _baseURI) ERC721A("Menace Warriors", "MenaceWarriors")
2401     PaymentSplitter(_team, _teamShares) {
2402         signerAddressVIP = _signerAddressVIP;
2403         signerAddressWL = _signerAddressWL;
2404         baseURI = _baseURI;
2405         teamLength = _team.length;
2406     }
2407 
2408     function changeVIPSignerAddress(address newSigner) external onlyOwner{
2409         signerAddressVIP = newSigner;
2410     }
2411 
2412     function changeWLSignerAddress(address newSigner) external onlyOwner{
2413         signerAddressWL = newSigner;
2414     }
2415 
2416     function mintForOpensea() external onlyOwner{
2417         if(totalSupply() != 0) revert("Only one mint for deployer");
2418         _mint(msg.sender, 40);
2419     }
2420 
2421     function VIPMint(address _account, uint _quantity, bytes calldata signature) external {
2422         if(sellingStep != Step.VIPSale) revert("VIP Mint is not open");
2423         if(totalSupply() + _quantity > MAX_SUPPLY) revert("Max supply for VIP exceeded");
2424         if(signerAddressVIP != keccak256(
2425             abi.encodePacked(
2426                 "\x19Ethereum Signed Message:\n32",
2427                 bytes32(uint256(uint160(msg.sender)))
2428             )
2429         ).recover(signature)) revert("You are not in VIP whitelist");
2430         if(mintedAmountNFTsperWalletVIPSale[msg.sender] + _quantity > maxMintAmountPerVIP) revert("You can only get 1 NFT on the VIP Sale");
2431             
2432         mintedAmountNFTsperWalletVIPSale[msg.sender] += _quantity;
2433         
2434         // The _numberMinted is incremented internally
2435         _mint(_account, _quantity);
2436     }
2437 
2438     function publicSaleMint(address _account, uint _quantity) external payable {
2439         uint price = publicSalePrice;
2440         if(price <= 0) revert("Price is 0");
2441 
2442         if(_quantity > maxAmountPerTxnPublic) revert("Max amount per txn is 3");
2443 
2444         if(sellingStep != Step.PublicSale) revert("Public Mint not live.");
2445         if(totalSupply() + _quantity > (MAX_SUPPLY - MAX_VIP)) revert("Max supply exceeded for public exceeded");
2446         if(msg.value < price * _quantity) revert("Not enough funds");   
2447 
2448         _mint(_account, _quantity);
2449     }
2450 
2451     function WLMint(address _account, uint _quantity, bytes calldata signature) external payable {
2452         uint price = wlSalePrice;
2453         if(price <= 0) revert("Price is 0");
2454 
2455         if(sellingStep != Step.WhitelistSale) revert("WL Mint not live.");
2456         if(totalSupply() + _quantity > (MAX_SUPPLY - MAX_VIP)) revert("Max supply exceeded for WL exceeded");
2457         if(msg.value < price * _quantity) revert("Not enough funds");          
2458         if(signerAddressWL != keccak256(
2459             abi.encodePacked(
2460                 "\x19Ethereum Signed Message:\n32",
2461                 bytes32(uint256(uint160(msg.sender)))
2462             )
2463         ).recover(signature)) revert("You are not in WL whitelist");
2464         if(mintedAmountNFTsperWalletWhitelistSale[msg.sender] + _quantity > maxMintAmountPerWhitelist) revert("You can only get 3 NFT on the Whitelist Sale");
2465             
2466         mintedAmountNFTsperWalletWhitelistSale[msg.sender] += _quantity;
2467         _mint(_account, _quantity);
2468     }
2469 
2470     function changeWlSalePrice(uint256 new_price) external onlyOwner{
2471         wlSalePrice = new_price;
2472     }
2473 
2474     function changePublicSalePrice(uint256 new_price) external onlyOwner{
2475         publicSalePrice = new_price;
2476     }
2477 
2478     function setBaseUri(string memory _baseURI) external onlyOwner {
2479         baseURI = _baseURI;
2480     }
2481 
2482     function setStep(uint _step) external onlyOwner {
2483         sellingStep = Step(_step);
2484     }
2485 
2486     function setMaxMintPerVIP(uint amount) external onlyOwner {
2487         maxMintAmountPerVIP = amount;
2488     }
2489 
2490     function setMaxMintPerWhitelist(uint amount) external onlyOwner{
2491         maxMintAmountPerWhitelist = amount;
2492     }
2493 
2494     function setMaxTxnPublic(uint amount) external onlyOwner{
2495         maxAmountPerTxnPublic = amount;
2496     }
2497 
2498     function getNumberMinted(address account) external view returns (uint256) {
2499         return _numberMinted(account);
2500     }
2501 
2502     function getNumberWLMinted(address account) external view returns (uint256) {
2503         return mintedAmountNFTsperWalletWhitelistSale[account];
2504     }
2505 
2506     function testSignerRecovery(bytes calldata signature) external view returns (address) {
2507         return keccak256(
2508             abi.encodePacked(
2509                 "\x19Ethereum Signed Message:\n32",
2510                 bytes32(uint256(uint160(msg.sender)))
2511             )
2512         ).recover(signature);
2513     }
2514 
2515     function tokenURI(uint _tokenId) public view virtual override returns (string memory) {
2516         require(_exists(_tokenId), "URI query for nonexistent token");
2517         return string(abi.encodePacked(baseURI, _toString(_tokenId), ".json"));
2518     }
2519 
2520     function releaseAll() external {
2521         for(uint i = 0 ; i < teamLength ; i++) {
2522             release(payable(payee(i)));
2523         }
2524     }
2525 }