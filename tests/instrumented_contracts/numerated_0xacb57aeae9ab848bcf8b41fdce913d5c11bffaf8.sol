1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-23
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-09-23
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Interface of the ERC20 standard as defined in the EIP.
15  */
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through {transferFrom}. This is
39      * zero by default.
40      *
41      * This value changes when {approve} or {transferFrom} are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 
92 /**
93  * @dev Collection of functions related to the address type
94  */
95 library Address {
96     /**
97      * @dev Returns true if `account` is a contract.
98      *
99      * [IMPORTANT]
100      * ====
101      * It is unsafe to assume that an address for which this function returns
102      * false is an externally-owned account (EOA) and not a contract.
103      *
104      * Among others, `isContract` will return false for the following
105      * types of addresses:
106      *
107      *  - an externally-owned account
108      *  - a contract in construction
109      *  - an address where a contract will be created
110      *  - an address where a contract lived, but was destroyed
111      * ====
112      */
113     function isContract(address account) internal view returns (bool) {
114         // This method relies on extcodesize, which returns 0 for contracts in
115         // construction, since the code is only stored at the end of the
116         // constructor execution.
117 
118         uint256 size;
119         assembly {
120             size := extcodesize(account)
121         }
122         return size > 0;
123     }
124 
125     /**
126      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
127      * `recipient`, forwarding all available gas and reverting on errors.
128      *
129      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
130      * of certain opcodes, possibly making contracts go over the 2300 gas limit
131      * imposed by `transfer`, making them unable to receive funds via
132      * `transfer`. {sendValue} removes this limitation.
133      *
134      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
135      *
136      * IMPORTANT: because control is transferred to `recipient`, care must be
137      * taken to not create reentrancy vulnerabilities. Consider using
138      * {ReentrancyGuard} or the
139      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
140      */
141     function sendValue(address payable recipient, uint256 amount) internal {
142         require(address(this).balance >= amount, "Address: insufficient balance");
143 
144         (bool success, ) = recipient.call{value: amount}("");
145         require(success, "Address: unable to send value, recipient may have reverted");
146     }
147 
148     /**
149      * @dev Performs a Solidity function call using a low level `call`. A
150      * plain `call` is an unsafe replacement for a function call: use this
151      * function instead.
152      *
153      * If `target` reverts with a revert reason, it is bubbled up by this
154      * function (like regular Solidity function calls).
155      *
156      * Returns the raw returned data. To convert to the expected return value,
157      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
158      *
159      * Requirements:
160      *
161      * - `target` must be a contract.
162      * - calling `target` with `data` must not revert.
163      *
164      * _Available since v3.1._
165      */
166     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
167         return functionCall(target, data, "Address: low-level call failed");
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
172      * `errorMessage` as a fallback revert reason when `target` reverts.
173      *
174      * _Available since v3.1._
175      */
176     function functionCall(
177         address target,
178         bytes memory data,
179         string memory errorMessage
180     ) internal returns (bytes memory) {
181         return functionCallWithValue(target, data, 0, errorMessage);
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
186      * but also transferring `value` wei to `target`.
187      *
188      * Requirements:
189      *
190      * - the calling contract must have an ETH balance of at least `value`.
191      * - the called Solidity function must be `payable`.
192      *
193      * _Available since v3.1._
194      */
195     function functionCallWithValue(
196         address target,
197         bytes memory data,
198         uint256 value
199     ) internal returns (bytes memory) {
200         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
205      * with `errorMessage` as a fallback revert reason when `target` reverts.
206      *
207      * _Available since v3.1._
208      */
209     function functionCallWithValue(
210         address target,
211         bytes memory data,
212         uint256 value,
213         string memory errorMessage
214     ) internal returns (bytes memory) {
215         require(address(this).balance >= value, "Address: insufficient balance for call");
216         require(isContract(target), "Address: call to non-contract");
217 
218         (bool success, bytes memory returndata) = target.call{value: value}(data);
219         return verifyCallResult(success, returndata, errorMessage);
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
224      * but performing a static call.
225      *
226      * _Available since v3.3._
227      */
228     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
229         return functionStaticCall(target, data, "Address: low-level static call failed");
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
234      * but performing a static call.
235      *
236      * _Available since v3.3._
237      */
238     function functionStaticCall(
239         address target,
240         bytes memory data,
241         string memory errorMessage
242     ) internal view returns (bytes memory) {
243         require(isContract(target), "Address: static call to non-contract");
244 
245         (bool success, bytes memory returndata) = target.staticcall(data);
246         return verifyCallResult(success, returndata, errorMessage);
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
251      * but performing a delegate call.
252      *
253      * _Available since v3.4._
254      */
255     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
256         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
261      * but performing a delegate call.
262      *
263      * _Available since v3.4._
264      */
265     function functionDelegateCall(
266         address target,
267         bytes memory data,
268         string memory errorMessage
269     ) internal returns (bytes memory) {
270         require(isContract(target), "Address: delegate call to non-contract");
271 
272         (bool success, bytes memory returndata) = target.delegatecall(data);
273         return verifyCallResult(success, returndata, errorMessage);
274     }
275 
276     /**
277      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
278      * revert reason using the provided one.
279      *
280      * _Available since v4.3._
281      */
282     function verifyCallResult(
283         bool success,
284         bytes memory returndata,
285         string memory errorMessage
286     ) internal pure returns (bytes memory) {
287         if (success) {
288             return returndata;
289         } else {
290             // Look for revert reason and bubble it up if present
291             if (returndata.length > 0) {
292                 // The easiest way to bubble the revert reason is using memory via assembly
293 
294                 assembly {
295                     let returndata_size := mload(returndata)
296                     revert(add(32, returndata), returndata_size)
297                 }
298             } else {
299                 revert(errorMessage);
300             }
301         }
302     }
303 }
304 
305 
306 /**
307  * @title SafeERC20
308  * @dev Wrappers around ERC20 operations that throw on failure (when the token
309  * contract returns false). Tokens that return no value (and instead revert or
310  * throw on failure) are also supported, non-reverting calls are assumed to be
311  * successful.
312  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
313  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
314  */
315 library SafeERC20 {
316     using Address for address;
317 
318     function safeTransfer(
319         IERC20 token,
320         address to,
321         uint256 value
322     ) internal {
323         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
324     }
325 
326     function safeTransferFrom(
327         IERC20 token,
328         address from,
329         address to,
330         uint256 value
331     ) internal {
332         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
333     }
334 
335     /**
336      * @dev Deprecated. This function has issues similar to the ones found in
337      * {IERC20-approve}, and its usage is discouraged.
338      *
339      * Whenever possible, use {safeIncreaseAllowance} and
340      * {safeDecreaseAllowance} instead.
341      */
342     function safeApprove(
343         IERC20 token,
344         address spender,
345         uint256 value
346     ) internal {
347         // safeApprove should only be called when setting an initial allowance,
348         // or when resetting it to zero. To increase and decrease it, use
349         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
350         require(
351             (value == 0) || (token.allowance(address(this), spender) == 0),
352             "SafeERC20: approve from non-zero to non-zero allowance"
353         );
354         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
355     }
356 
357     function safeIncreaseAllowance(
358         IERC20 token,
359         address spender,
360         uint256 value
361     ) internal {
362         uint256 newAllowance = token.allowance(address(this), spender) + value;
363         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
364     }
365 
366     function safeDecreaseAllowance(
367         IERC20 token,
368         address spender,
369         uint256 value
370     ) internal {
371         unchecked {
372             uint256 oldAllowance = token.allowance(address(this), spender);
373             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
374             uint256 newAllowance = oldAllowance - value;
375             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
376         }
377     }
378 
379     /**
380      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
381      * on the return value: the return value is optional (but if data is returned, it must not be false).
382      * @param token The token targeted by the call.
383      * @param data The call data (encoded using abi.encode or one of its variants).
384      */
385     function _callOptionalReturn(IERC20 token, bytes memory data) private {
386         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
387         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
388         // the target address contains contract code and also asserts for success in the low-level call.
389 
390         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
391         if (returndata.length > 0) {
392             // Return data is optional
393             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
394         }
395     }
396 }
397 
398 
399 /**
400  * @dev Provides information about the current execution context, including the
401  * sender of the transaction and its data. While these are generally available
402  * via msg.sender and msg.data, they should not be accessed in such a direct
403  * manner, since when dealing with meta-transactions the account sending and
404  * paying for execution may not be the actual sender (as far as an application
405  * is concerned).
406  *
407  * This contract is only required for intermediate, library-like contracts.
408  */
409 abstract contract Context {
410     function _msgSender() internal view virtual returns (address) {
411         return msg.sender;
412     }
413 
414     function _msgData() internal view virtual returns (bytes calldata) {
415         return msg.data;
416     }
417 }
418 
419 
420 /**
421  * @dev Contract module which provides a basic access control mechanism, where
422  * there is an account (an owner) that can be granted exclusive access to
423  * specific functions.
424  *
425  * By default, the owner account will be the one that deploys the contract. This
426  * can later be changed with {transferOwnership}.
427  *
428  * This module is used through inheritance. It will make available the modifier
429  * `onlyOwner`, which can be applied to your functions to restrict their use to
430  * the owner.
431  */
432 abstract contract Ownable is Context {
433     address private _owner;
434 
435     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
436 
437     /**
438      * @dev Initializes the contract setting the deployer as the initial owner.
439      */
440     constructor() {
441         _setOwner(_msgSender());
442     }
443 
444     /**
445      * @dev Returns the address of the current owner.
446      */
447     function owner() public view virtual returns (address) {
448         return _owner;
449     }
450 
451     /**
452      * @dev Throws if called by any account other than the owner.
453      */
454     modifier onlyOwner() {
455         require(owner() == _msgSender(), "Ownable: caller is not the owner");
456         _;
457     }
458 
459     /**
460      * @dev Leaves the contract without owner. It will not be possible to call
461      * `onlyOwner` functions anymore. Can only be called by the current owner.
462      *
463      * NOTE: Renouncing ownership will leave the contract without an owner,
464      * thereby removing any functionality that is only available to the owner.
465      */
466     function renounceOwnership() public virtual onlyOwner {
467         _setOwner(address(0));
468     }
469 
470     /**
471      * @dev Transfers ownership of the contract to a new account (`newOwner`).
472      * Can only be called by the current owner.
473      */
474     function transferOwnership(address newOwner) public virtual onlyOwner {
475         require(newOwner != address(0), "Ownable: new owner is the zero address");
476         _setOwner(newOwner);
477     }
478 
479     function _setOwner(address newOwner) private {
480         address oldOwner = _owner;
481         _owner = newOwner;
482         emit OwnershipTransferred(oldOwner, newOwner);
483     }
484 }
485 
486 
487 /**
488  * @dev Interface of the ERC165 standard, as defined in the
489  * https://eips.ethereum.org/EIPS/eip-165[EIP].
490  *
491  * Implementers can declare support of contract interfaces, which can then be
492  * queried by others ({ERC165Checker}).
493  *
494  * For an implementation, see {ERC165}.
495  */
496 interface IERC165 {
497     /**
498      * @dev Returns true if this contract implements the interface defined by
499      * `interfaceId`. See the corresponding
500      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
501      * to learn more about how these ids are created.
502      *
503      * This function call must use less than 30 000 gas.
504      */
505     function supportsInterface(bytes4 interfaceId) external view returns (bool);
506 }
507 
508 
509 /**
510  * @dev Required interface of an ERC721 compliant contract.
511  */
512 interface IERC721 is IERC165 {
513     /**
514      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
515      */
516     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
517 
518     /**
519      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
520      */
521     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
522 
523     /**
524      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
525      */
526     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
527 
528     /**
529      * @dev Returns the number of tokens in ``owner``'s account.
530      */
531     function balanceOf(address owner) external view returns (uint256 balance);
532 
533     /**
534      * @dev Returns the owner of the `tokenId` token.
535      *
536      * Requirements:
537      *
538      * - `tokenId` must exist.
539      */
540     function ownerOf(uint256 tokenId) external view returns (address owner);
541 
542     /**
543      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
544      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
545      *
546      * Requirements:
547      *
548      * - `from` cannot be the zero address.
549      * - `to` cannot be the zero address.
550      * - `tokenId` token must exist and be owned by `from`.
551      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
552      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
553      *
554      * Emits a {Transfer} event.
555      */
556     function safeTransferFrom(
557         address from,
558         address to,
559         uint256 tokenId
560     ) external;
561 
562     /**
563      * @dev Transfers `tokenId` token from `from` to `to`.
564      *
565      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
566      *
567      * Requirements:
568      *
569      * - `from` cannot be the zero address.
570      * - `to` cannot be the zero address.
571      * - `tokenId` token must be owned by `from`.
572      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
573      *
574      * Emits a {Transfer} event.
575      */
576     function transferFrom(
577         address from,
578         address to,
579         uint256 tokenId
580     ) external;
581 
582     /**
583      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
584      * The approval is cleared when the token is transferred.
585      *
586      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
587      *
588      * Requirements:
589      *
590      * - The caller must own the token or be an approved operator.
591      * - `tokenId` must exist.
592      *
593      * Emits an {Approval} event.
594      */
595     function approve(address to, uint256 tokenId) external;
596 
597     /**
598      * @dev Returns the account approved for `tokenId` token.
599      *
600      * Requirements:
601      *
602      * - `tokenId` must exist.
603      */
604     function getApproved(uint256 tokenId) external view returns (address operator);
605 
606     /**
607      * @dev Approve or remove `operator` as an operator for the caller.
608      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
609      *
610      * Requirements:
611      *
612      * - The `operator` cannot be the caller.
613      *
614      * Emits an {ApprovalForAll} event.
615      */
616     function setApprovalForAll(address operator, bool _approved) external;
617 
618     /**
619      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
620      *
621      * See {setApprovalForAll}
622      */
623     function isApprovedForAll(address owner, address operator) external view returns (bool);
624 
625     /**
626      * @dev Safely transfers `tokenId` token from `from` to `to`.
627      *
628      * Requirements:
629      *
630      * - `from` cannot be the zero address.
631      * - `to` cannot be the zero address.
632      * - `tokenId` token must exist and be owned by `from`.
633      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
634      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
635      *
636      * Emits a {Transfer} event.
637      */
638     function safeTransferFrom(
639         address from,
640         address to,
641         uint256 tokenId,
642         bytes calldata data
643     ) external;
644 }
645 
646 
647 /**
648  * @title ERC721 token receiver interface
649  * @dev Interface for any contract that wants to support safeTransfers
650  * from ERC721 asset contracts.
651  */
652 interface IERC721Receiver {
653     /**
654      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
655      * by `operator` from `from`, this function is called.
656      *
657      * It must return its Solidity selector to confirm the token transfer.
658      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
659      *
660      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
661      */
662     function onERC721Received(
663         address operator,
664         address from,
665         uint256 tokenId,
666         bytes calldata data
667     ) external returns (bytes4);
668 }
669 
670 
671 /**
672  * @dev Implementation of the {IERC721Receiver} interface.
673  *
674  * Accepts all token transfers.
675  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
676  */
677 contract ERC721Holder is IERC721Receiver {
678     /**
679      * @dev See {IERC721Receiver-onERC721Received}.
680      *
681      * Always returns `IERC721Receiver.onERC721Received.selector`.
682      */
683     function onERC721Received(
684         address,
685         address,
686         uint256,
687         bytes memory
688     ) public virtual override returns (bytes4) {
689         return this.onERC721Received.selector;
690     }
691 }
692 
693 
694 contract DinoSwap is ERC721Holder, Ownable {
695     IERC721 public inToken;
696     IERC721 public outToken;
697     
698     bool private _paused;
699     event Paused(address account);
700     event Unpaused(address account);
701 
702     uint256 public lastTokenIdSent;
703 
704     mapping(address => bool) public presalerList;
705     mapping(address => uint256) public presalerListPurchases;
706     uint256 public presalePurchaseLimit = 1;
707 
708     constructor(address _inToken, address _outToken) {
709         inToken = IERC721(_inToken);
710         outToken = IERC721(_outToken);
711         _paused = false;
712         lastTokenIdSent = 0;
713     }
714 
715     function swap(uint256 _tokenId) external whenNotPaused {
716         require(lastTokenIdSent < 555, "Maximum number of swaps reached");
717         require(presalerList[msg.sender], "NOT QUALIFIED");
718         require(presalerListPurchases[msg.sender] + 1 <= presalePurchaseLimit, "EXCEEDED ALLOCATION");
719 
720         presalerListPurchases[msg.sender]++;
721 
722         inToken.transferFrom(msg.sender, address(this), _tokenId);
723         outToken.transferFrom(address(this), msg.sender, lastTokenIdSent);
724         lastTokenIdSent = lastTokenIdSent + 1;
725 
726     }
727  
728 
729     function addToPresaleList(address[] calldata entries) external onlyOwner {
730         for(uint256 i = 0; i < entries.length; i++) {
731             address entry = entries[i];
732             require(entry != address(0), "Cannot add zero address");
733             require(!presalerList[entry], "Cannot add duplicate address");
734 
735             presalerList[entry] = true;
736         }   
737     }
738 
739     function removeFromPresaleList(address[] calldata entries) external onlyOwner {
740         for(uint256 i = 0; i < entries.length; i++) {
741             address entry = entries[i];
742             require(entry != address(0), "Cannot remove zero address");
743             
744             presalerList[entry] = false;
745         }
746     }
747 
748     function isPresaler(address addr) external view returns (bool) {
749         return presalerList[addr];
750     }
751     
752     function presalePurchasedCount(address addr) external view returns (uint256) {
753         return presalerListPurchases[addr];
754     }
755 
756     function adminWithdrawETH() external onlyOwner {
757         payable(msg.sender).transfer(address(this).balance);
758     }
759 
760     function adminWithdrawERC20(address token) external onlyOwner {
761         uint256 amount = IERC20(token).balanceOf(address(this));
762         IERC20(token).transfer(msg.sender, amount);
763     }
764 
765     function adminWithdrawERC721(address token, uint256 _tokenId) external onlyOwner {
766         IERC721(token).transferFrom(address(this), msg.sender, _tokenId);
767     }
768 
769     function adminWithdrawERC721Multi(address token, uint256[] calldata _tokenIds) external onlyOwner {
770         for (uint256 i = 0; i < _tokenIds.length; i++) {
771             IERC721(token).transferFrom(address(this), msg.sender, _tokenIds[i]);
772         }
773     }
774 
775     function setPresalePurchaseLimit(uint256 _newPresalePurchaseLimit) external onlyOwner {
776         presalePurchaseLimit = _newPresalePurchaseLimit;
777     }
778 
779     function pause() external onlyOwner{
780         _pause();
781     }
782 
783     function unpause() external onlyOwner{
784         _unpause();
785     }
786 
787     function paused() public view virtual returns (bool) {
788         return _paused;
789     }
790 
791     modifier whenNotPaused() {
792         require(!paused(), "Pausable: paused");
793         _;
794     }
795     
796     modifier whenPaused() {
797         require(paused(), "Pausable: not paused");
798         _;
799     }
800 
801     function _pause() internal virtual whenNotPaused {
802         _paused = true;
803         emit Paused(_msgSender());
804     }
805 
806     function _unpause() internal virtual whenPaused {
807         _paused = false;
808         emit Unpaused(_msgSender());
809     }
810 }