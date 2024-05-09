1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
4 
5 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `to`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address to, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender)
40         external
41         view
42         returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `from` to `to` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(
70         address from,
71         address to,
72         uint256 amount
73     ) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(
88         address indexed owner,
89         address indexed spender,
90         uint256 value
91     );
92 }
93 
94 pragma solidity ^0.8.0;
95 
96 library MerkleProof {
97     /**
98      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
99      * defined by `root`. For this, a `proof` must be provided, containing
100      * sibling hashes on the branch from the leaf to the root of the tree. Each
101      * pair of leaves and each pair of pre-images are assumed to be sorted.
102      */
103     function verify(
104         bytes32[] memory proof,
105         bytes32 root,
106         bytes32 leaf
107     ) internal pure returns (bool) {
108         return processProof(proof, leaf) == root;
109     }
110 
111     /**
112      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
113      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
114      * hash matches the root of the tree. When processing the proof, the pairs
115      * of leafs & pre-images are assumed to be sorted.
116      *
117      * _Available since v4.4._
118      */
119     function processProof(bytes32[] memory proof, bytes32 leaf)
120         internal
121         pure
122         returns (bytes32)
123     {
124         bytes32 computedHash = leaf;
125         for (uint256 i = 0; i < proof.length; i++) {
126             bytes32 proofElement = proof[i];
127             if (computedHash <= proofElement) {
128                 // Hash(current computed hash + current element of the proof)
129                 computedHash = _efficientHash(computedHash, proofElement);
130             } else {
131                 // Hash(current element of the proof + current computed hash)
132                 computedHash = _efficientHash(proofElement, computedHash);
133             }
134         }
135         return computedHash;
136     }
137 
138     function _efficientHash(bytes32 a, bytes32 b)
139         private
140         pure
141         returns (bytes32 value)
142     {
143         assembly {
144             mstore(0x00, a)
145             mstore(0x20, b)
146             value := keccak256(0x00, 0x40)
147         }
148     }
149 }
150 
151 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
152 
153 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
154 
155 pragma solidity ^0.8.0;
156 
157 /**
158  * @dev Contract module that helps prevent reentrant calls to a function.
159  *
160  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
161  * available, which can be applied to functions to make sure there are no nested
162  * (reentrant) calls to them.
163  *
164  * Note that because there is a single `nonReentrant` guard, functions marked as
165  * `nonReentrant` may not call one another. This can be worked around by making
166  * those functions `private`, and then adding `external` `nonReentrant` entry
167  * points to them.
168  *
169  * TIP: If you would like to learn more about reentrancy and alternative ways
170  * to protect against it, check out our blog post
171  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
172  */
173 abstract contract ReentrancyGuard {
174     // Booleans are more expensive than uint256 or any type that takes up a full
175     // word because each write operation emits an extra SLOAD to first read the
176     // slot's contents, replace the bits taken up by the boolean, and then write
177     // back. This is the compiler's defense against contract upgrades and
178     // pointer aliasing, and it cannot be disabled.
179 
180     // The values being non-zero value makes deployment a bit more expensive,
181     // but in exchange the refund on every call to nonReentrant will be lower in
182     // amount. Since refunds are capped to a percentage of the total
183     // transaction's gas, it is best to keep them low in cases like this one, to
184     // increase the likelihood of the full refund coming into effect.
185     uint256 private constant _NOT_ENTERED = 1;
186     uint256 private constant _ENTERED = 2;
187 
188     uint256 private _status;
189 
190     constructor() {
191         _status = _NOT_ENTERED;
192     }
193 
194     /**
195      * @dev Prevents a contract from calling itself, directly or indirectly.
196      * Calling a `nonReentrant` function from another `nonReentrant`
197      * function is not supported. It is possible to prevent this from happening
198      * by making the `nonReentrant` function external, and making it call a
199      * `private` function that does the actual work.
200      */
201     modifier nonReentrant() {
202         // On the first call to nonReentrant, _notEntered will be true
203         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
204 
205         // Any calls to nonReentrant after this point will fail
206         _status = _ENTERED;
207 
208         _;
209 
210         // By storing the original value once again, a refund is triggered (see
211         // https://eips.ethereum.org/EIPS/eip-2200)
212         _status = _NOT_ENTERED;
213     }
214 }
215 
216 // File: @openzeppelin/contracts/utils/Strings.sol
217 
218 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
219 
220 pragma solidity ^0.8.0;
221 
222 /**
223  * @dev String operations.
224  */
225 library Strings {
226     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
227 
228     /**
229      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
230      */
231     function toString(uint256 value) internal pure returns (string memory) {
232         // Inspired by OraclizeAPI's implementation - MIT licence
233         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
234 
235         if (value == 0) {
236             return "0";
237         }
238         uint256 temp = value;
239         uint256 digits;
240         while (temp != 0) {
241             digits++;
242             temp /= 10;
243         }
244         bytes memory buffer = new bytes(digits);
245         while (value != 0) {
246             digits -= 1;
247             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
248             value /= 10;
249         }
250         return string(buffer);
251     }
252 
253     /**
254      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
255      */
256     function toHexString(uint256 value) internal pure returns (string memory) {
257         if (value == 0) {
258             return "0x00";
259         }
260         uint256 temp = value;
261         uint256 length = 0;
262         while (temp != 0) {
263             length++;
264             temp >>= 8;
265         }
266         return toHexString(value, length);
267     }
268 
269     /**
270      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
271      */
272     function toHexString(uint256 value, uint256 length)
273         internal
274         pure
275         returns (string memory)
276     {
277         bytes memory buffer = new bytes(2 * length + 2);
278         buffer[0] = "0";
279         buffer[1] = "x";
280         for (uint256 i = 2 * length + 1; i > 1; --i) {
281             buffer[i] = _HEX_SYMBOLS[value & 0xf];
282             value >>= 4;
283         }
284         require(value == 0, "Strings: hex length insufficient");
285         return string(buffer);
286     }
287 }
288 
289 // File: @openzeppelin/contracts/utils/Context.sol
290 
291 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
292 
293 pragma solidity ^0.8.0;
294 
295 /**
296  * @dev Provides information about the current execution context, including the
297  * sender of the transaction and its data. While these are generally available
298  * via msg.sender and msg.data, they should not be accessed in such a direct
299  * manner, since when dealing with meta-transactions the account sending and
300  * paying for execution may not be the actual sender (as far as an application
301  * is concerned).
302  *
303  * This contract is only required for intermediate, library-like contracts.
304  */
305 abstract contract Context {
306     function _msgSender() internal view virtual returns (address) {
307         return msg.sender;
308     }
309 
310     function _msgData() internal view virtual returns (bytes calldata) {
311         return msg.data;
312     }
313 }
314 
315 // File: @openzeppelin/contracts/access/Ownable.sol
316 
317 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
318 
319 pragma solidity ^0.8.0;
320 
321 /**
322  * @dev Contract module which provides a basic access control mechanism, where
323  * there is an account (an owner) that can be granted exclusive access to
324  * specific functions.
325  *
326  * By default, the owner account will be the one that deploys the contract. This
327  * can later be changed with {transferOwnership}.
328  *
329  * This module is used through inheritance. It will make available the modifier
330  * `onlyOwner`, which can be applied to your functions to restrict their use to
331  * the owner.
332  */
333 abstract contract Ownable is Context {
334     address private _owner;
335 
336     event OwnershipTransferred(
337         address indexed previousOwner,
338         address indexed newOwner
339     );
340 
341     /**
342      * @dev Initializes the contract setting the deployer as the initial owner.
343      */
344     constructor() {
345         _transferOwnership(_msgSender());
346     }
347 
348     /**
349      * @dev Returns the address of the current owner.
350      */
351     function owner() public view virtual returns (address) {
352         return _owner;
353     }
354 
355     /**
356      * @dev Throws if called by any account other than the owner.
357      */
358     modifier onlyOwner() {
359         require(owner() == _msgSender(), "Ownable: caller is not the owner");
360         _;
361     }
362 
363     /**
364      * @dev Leaves the contract without owner. It will not be possible to call
365      * `onlyOwner` functions anymore. Can only be called by the current owner.
366      *
367      * NOTE: Renouncing ownership will leave the contract without an owner,
368      * thereby removing any functionality that is only available to the owner.
369      */
370     function renounceOwnership() public virtual onlyOwner {
371         _transferOwnership(address(0));
372     }
373 
374     /**
375      * @dev Transfers ownership of the contract to a new account (`newOwner`).
376      * Can only be called by the current owner.
377      */
378     function transferOwnership(address newOwner) public virtual onlyOwner {
379         require(
380             newOwner != address(0),
381             "Ownable: new owner is the zero address"
382         );
383         _transferOwnership(newOwner);
384     }
385 
386     /**
387      * @dev Transfers ownership of the contract to a new account (`newOwner`).
388      * Internal function without access restriction.
389      */
390     function _transferOwnership(address newOwner) internal virtual {
391         address oldOwner = _owner;
392         _owner = newOwner;
393         emit OwnershipTransferred(oldOwner, newOwner);
394     }
395 }
396 
397 // File: @openzeppelin/contracts/utils/Address.sol
398 
399 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
400 
401 pragma solidity ^0.8.1;
402 
403 /**
404  * @dev Collection of functions related to the address type
405  */
406 library Address {
407     /**
408      * @dev Returns true if `account` is a contract.
409      *
410      * [IMPORTANT]
411      * ====
412      * It is unsafe to assume that an address for which this function returns
413      * false is an externally-owned account (EOA) and not a contract.
414      *
415      * Among others, `isContract` will return false for the following
416      * types of addresses:
417      *
418      *  - an externally-owned account
419      *  - a contract in construction
420      *  - an address where a contract will be created
421      *  - an address where a contract lived, but was destroyed
422      * ====
423      *
424      * [IMPORTANT]
425      * ====
426      * You shouldn't rely on `isContract` to protect against flash loan attacks!
427      *
428      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
429      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
430      * constructor.
431      * ====
432      */
433     function isContract(address account) internal view returns (bool) {
434         // This method relies on extcodesize/address.code.length, which returns 0
435         // for contracts in construction, since the code is only stored at the end
436         // of the constructor execution.
437 
438         return account.code.length > 0;
439     }
440 
441     /**
442      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
443      * `recipient`, forwarding all available gas and reverting on errors.
444      *
445      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
446      * of certain opcodes, possibly making contracts go over the 2300 gas limit
447      * imposed by `transfer`, making them unable to receive funds via
448      * `transfer`. {sendValue} removes this limitation.
449      *
450      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
451      *
452      * IMPORTANT: because control is transferred to `recipient`, care must be
453      * taken to not create reentrancy vulnerabilities. Consider using
454      * {ReentrancyGuard} or the
455      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
456      */
457     function sendValue(address payable recipient, uint256 amount) internal {
458         require(
459             address(this).balance >= amount,
460             "Address: insufficient balance"
461         );
462 
463         (bool success, ) = recipient.call{value: amount}("");
464         require(
465             success,
466             "Address: unable to send value, recipient may have reverted"
467         );
468     }
469 
470     /**
471      * @dev Performs a Solidity function call using a low level `call`. A
472      * plain `call` is an unsafe replacement for a function call: use this
473      * function instead.
474      *
475      * If `target` reverts with a revert reason, it is bubbled up by this
476      * function (like regular Solidity function calls).
477      *
478      * Returns the raw returned data. To convert to the expected return value,
479      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
480      *
481      * Requirements:
482      *
483      * - `target` must be a contract.
484      * - calling `target` with `data` must not revert.
485      *
486      * _Available since v3.1._
487      */
488     function functionCall(address target, bytes memory data)
489         internal
490         returns (bytes memory)
491     {
492         return functionCall(target, data, "Address: low-level call failed");
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
497      * `errorMessage` as a fallback revert reason when `target` reverts.
498      *
499      * _Available since v3.1._
500      */
501     function functionCall(
502         address target,
503         bytes memory data,
504         string memory errorMessage
505     ) internal returns (bytes memory) {
506         return functionCallWithValue(target, data, 0, errorMessage);
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
511      * but also transferring `value` wei to `target`.
512      *
513      * Requirements:
514      *
515      * - the calling contract must have an ETH balance of at least `value`.
516      * - the called Solidity function must be `payable`.
517      *
518      * _Available since v3.1._
519      */
520     function functionCallWithValue(
521         address target,
522         bytes memory data,
523         uint256 value
524     ) internal returns (bytes memory) {
525         return
526             functionCallWithValue(
527                 target,
528                 data,
529                 value,
530                 "Address: low-level call with value failed"
531             );
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
536      * with `errorMessage` as a fallback revert reason when `target` reverts.
537      *
538      * _Available since v3.1._
539      */
540     function functionCallWithValue(
541         address target,
542         bytes memory data,
543         uint256 value,
544         string memory errorMessage
545     ) internal returns (bytes memory) {
546         require(
547             address(this).balance >= value,
548             "Address: insufficient balance for call"
549         );
550         require(isContract(target), "Address: call to non-contract");
551 
552         (bool success, bytes memory returndata) = target.call{value: value}(
553             data
554         );
555         return verifyCallResult(success, returndata, errorMessage);
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
560      * but performing a static call.
561      *
562      * _Available since v3.3._
563      */
564     function functionStaticCall(address target, bytes memory data)
565         internal
566         view
567         returns (bytes memory)
568     {
569         return
570             functionStaticCall(
571                 target,
572                 data,
573                 "Address: low-level static call failed"
574             );
575     }
576 
577     /**
578      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
579      * but performing a static call.
580      *
581      * _Available since v3.3._
582      */
583     function functionStaticCall(
584         address target,
585         bytes memory data,
586         string memory errorMessage
587     ) internal view returns (bytes memory) {
588         require(isContract(target), "Address: static call to non-contract");
589 
590         (bool success, bytes memory returndata) = target.staticcall(data);
591         return verifyCallResult(success, returndata, errorMessage);
592     }
593 
594     /**
595      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
596      * but performing a delegate call.
597      *
598      * _Available since v3.4._
599      */
600     function functionDelegateCall(address target, bytes memory data)
601         internal
602         returns (bytes memory)
603     {
604         return
605             functionDelegateCall(
606                 target,
607                 data,
608                 "Address: low-level delegate call failed"
609             );
610     }
611 
612     /**
613      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
614      * but performing a delegate call.
615      *
616      * _Available since v3.4._
617      */
618     function functionDelegateCall(
619         address target,
620         bytes memory data,
621         string memory errorMessage
622     ) internal returns (bytes memory) {
623         require(isContract(target), "Address: delegate call to non-contract");
624 
625         (bool success, bytes memory returndata) = target.delegatecall(data);
626         return verifyCallResult(success, returndata, errorMessage);
627     }
628 
629     /**
630      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
631      * revert reason using the provided one.
632      *
633      * _Available since v4.3._
634      */
635     function verifyCallResult(
636         bool success,
637         bytes memory returndata,
638         string memory errorMessage
639     ) internal pure returns (bytes memory) {
640         if (success) {
641             return returndata;
642         } else {
643             // Look for revert reason and bubble it up if present
644             if (returndata.length > 0) {
645                 // The easiest way to bubble the revert reason is using memory via assembly
646 
647                 assembly {
648                     let returndata_size := mload(returndata)
649                     revert(add(32, returndata), returndata_size)
650                 }
651             } else {
652                 revert(errorMessage);
653             }
654         }
655     }
656 }
657 
658 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
659 
660 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
661 
662 pragma solidity ^0.8.0;
663 
664 /**
665  * @title SafeERC20
666  * @dev Wrappers around ERC20 operations that throw on failure (when the token
667  * contract returns false). Tokens that return no value (and instead revert or
668  * throw on failure) are also supported, non-reverting calls are assumed to be
669  * successful.
670  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
671  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
672  */
673 library SafeERC20 {
674     using Address for address;
675 
676     function safeTransfer(
677         IERC20 token,
678         address to,
679         uint256 value
680     ) internal {
681         _callOptionalReturn(
682             token,
683             abi.encodeWithSelector(token.transfer.selector, to, value)
684         );
685     }
686 
687     function safeTransferFrom(
688         IERC20 token,
689         address from,
690         address to,
691         uint256 value
692     ) internal {
693         _callOptionalReturn(
694             token,
695             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
696         );
697     }
698 
699     /**
700      * @dev Deprecated. This function has issues similar to the ones found in
701      * {IERC20-approve}, and its usage is discouraged.
702      *
703      * Whenever possible, use {safeIncreaseAllowance} and
704      * {safeDecreaseAllowance} instead.
705      */
706     function safeApprove(
707         IERC20 token,
708         address spender,
709         uint256 value
710     ) internal {
711         // safeApprove should only be called when setting an initial allowance,
712         // or when resetting it to zero. To increase and decrease it, use
713         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
714         require(
715             (value == 0) || (token.allowance(address(this), spender) == 0),
716             "SafeERC20: approve from non-zero to non-zero allowance"
717         );
718         _callOptionalReturn(
719             token,
720             abi.encodeWithSelector(token.approve.selector, spender, value)
721         );
722     }
723 
724     function safeIncreaseAllowance(
725         IERC20 token,
726         address spender,
727         uint256 value
728     ) internal {
729         uint256 newAllowance = token.allowance(address(this), spender) + value;
730         _callOptionalReturn(
731             token,
732             abi.encodeWithSelector(
733                 token.approve.selector,
734                 spender,
735                 newAllowance
736             )
737         );
738     }
739 
740     function safeDecreaseAllowance(
741         IERC20 token,
742         address spender,
743         uint256 value
744     ) internal {
745         unchecked {
746             uint256 oldAllowance = token.allowance(address(this), spender);
747             require(
748                 oldAllowance >= value,
749                 "SafeERC20: decreased allowance below zero"
750             );
751             uint256 newAllowance = oldAllowance - value;
752             _callOptionalReturn(
753                 token,
754                 abi.encodeWithSelector(
755                     token.approve.selector,
756                     spender,
757                     newAllowance
758                 )
759             );
760         }
761     }
762 
763     /**
764      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
765      * on the return value: the return value is optional (but if data is returned, it must not be false).
766      * @param token The token targeted by the call.
767      * @param data The call data (encoded using abi.encode or one of its variants).
768      */
769     function _callOptionalReturn(IERC20 token, bytes memory data) private {
770         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
771         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
772         // the target address contains contract code and also asserts for success in the low-level call.
773 
774         bytes memory returndata = address(token).functionCall(
775             data,
776             "SafeERC20: low-level call failed"
777         );
778         if (returndata.length > 0) {
779             // Return data is optional
780             require(
781                 abi.decode(returndata, (bool)),
782                 "SafeERC20: ERC20 operation did not succeed"
783             );
784         }
785     }
786 }
787 
788 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
789 
790 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
791 
792 pragma solidity ^0.8.0;
793 
794 /**
795  * @title ERC721 token receiver interface
796  * @dev Interface for any contract that wants to support safeTransfers
797  * from ERC721 asset contracts.
798  */
799 interface IERC721Receiver {
800     /**
801      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
802      * by `operator` from `from`, this function is called.
803      *
804      * It must return its Solidity selector to confirm the token transfer.
805      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
806      *
807      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
808      */
809     function onERC721Received(
810         address operator,
811         address from,
812         uint256 tokenId,
813         bytes calldata data
814     ) external returns (bytes4);
815 }
816 
817 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
818 
819 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
820 
821 pragma solidity ^0.8.0;
822 
823 /**
824  * @dev Interface of the ERC165 standard, as defined in the
825  * https://eips.ethereum.org/EIPS/eip-165[EIP].
826  *
827  * Implementers can declare support of contract interfaces, which can then be
828  * queried by others ({ERC165Checker}).
829  *
830  * For an implementation, see {ERC165}.
831  */
832 interface IERC165 {
833     /**
834      * @dev Returns true if this contract implements the interface defined by
835      * `interfaceId`. See the corresponding
836      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
837      * to learn more about how these ids are created.
838      *
839      * This function call must use less than 30 000 gas.
840      */
841     function supportsInterface(bytes4 interfaceId) external view returns (bool);
842 }
843 
844 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
845 
846 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
847 
848 pragma solidity ^0.8.0;
849 
850 /**
851  * @dev Implementation of the {IERC165} interface.
852  *
853  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
854  * for the additional interface id that will be supported. For example:
855  *
856  * ```solidity
857  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
858  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
859  * }
860  * ```
861  *
862  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
863  */
864 abstract contract ERC165 is IERC165 {
865     /**
866      * @dev See {IERC165-supportsInterface}.
867      */
868     function supportsInterface(bytes4 interfaceId)
869         public
870         view
871         virtual
872         override
873         returns (bool)
874     {
875         return interfaceId == type(IERC165).interfaceId;
876     }
877 }
878 
879 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
880 
881 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
882 
883 pragma solidity ^0.8.0;
884 
885 /**
886  * @dev Required interface of an ERC721 compliant contract.
887  */
888 interface IERC721 is IERC165 {
889     /**
890      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
891      */
892     event Transfer(
893         address indexed from,
894         address indexed to,
895         uint256 indexed tokenId
896     );
897 
898     /**
899      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
900      */
901     event Approval(
902         address indexed owner,
903         address indexed approved,
904         uint256 indexed tokenId
905     );
906 
907     /**
908      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
909      */
910     event ApprovalForAll(
911         address indexed owner,
912         address indexed operator,
913         bool approved
914     );
915 
916     /**
917      * @dev Returns the number of tokens in ``owner``'s account.
918      */
919     function balanceOf(address owner) external view returns (uint256 balance);
920 
921     /**
922      * @dev Returns the owner of the `tokenId` token.
923      *
924      * Requirements:
925      *
926      * - `tokenId` must exist.
927      */
928     function ownerOf(uint256 tokenId) external view returns (address owner);
929 
930     /**
931      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
932      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
933      *
934      * Requirements:
935      *
936      * - `from` cannot be the zero address.
937      * - `to` cannot be the zero address.
938      * - `tokenId` token must exist and be owned by `from`.
939      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
940      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
941      *
942      * Emits a {Transfer} event.
943      */
944     function safeTransferFrom(
945         address from,
946         address to,
947         uint256 tokenId
948     ) external;
949 
950     /**
951      * @dev Transfers `tokenId` token from `from` to `to`.
952      *
953      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
954      *
955      * Requirements:
956      *
957      * - `from` cannot be the zero address.
958      * - `to` cannot be the zero address.
959      * - `tokenId` token must be owned by `from`.
960      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
961      *
962      * Emits a {Transfer} event.
963      */
964     function transferFrom(
965         address from,
966         address to,
967         uint256 tokenId
968     ) external;
969 
970     /**
971      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
972      * The approval is cleared when the token is transferred.
973      *
974      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
975      *
976      * Requirements:
977      *
978      * - The caller must own the token or be an approved operator.
979      * - `tokenId` must exist.
980      *
981      * Emits an {Approval} event.
982      */
983     function approve(address to, uint256 tokenId) external;
984 
985     /**
986      * @dev Returns the account approved for `tokenId` token.
987      *
988      * Requirements:
989      *
990      * - `tokenId` must exist.
991      */
992     function getApproved(uint256 tokenId)
993         external
994         view
995         returns (address operator);
996 
997     /**
998      * @dev Approve or remove `operator` as an operator for the caller.
999      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1000      *
1001      * Requirements:
1002      *
1003      * - The `operator` cannot be the caller.
1004      *
1005      * Emits an {ApprovalForAll} event.
1006      */
1007     function setApprovalForAll(address operator, bool _approved) external;
1008 
1009     /**
1010      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1011      *
1012      * See {setApprovalForAll}
1013      */
1014     function isApprovedForAll(address owner, address operator)
1015         external
1016         view
1017         returns (bool);
1018 
1019     /**
1020      * @dev Safely transfers `tokenId` token from `from` to `to`.
1021      *
1022      * Requirements:
1023      *
1024      * - `from` cannot be the zero address.
1025      * - `to` cannot be the zero address.
1026      * - `tokenId` token must exist and be owned by `from`.
1027      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1028      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1029      *
1030      * Emits a {Transfer} event.
1031      */
1032     function safeTransferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId,
1036         bytes calldata data
1037     ) external;
1038 }
1039 
1040 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1041 
1042 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1043 
1044 pragma solidity ^0.8.0;
1045 
1046 /**
1047  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1048  * @dev See https://eips.ethereum.org/EIPS/eip-721
1049  */
1050 interface IERC721Enumerable is IERC721 {
1051     /**
1052      * @dev Returns the total amount of tokens stored by the contract.
1053      */
1054     function totalSupply() external view returns (uint256);
1055 
1056     /**
1057      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1058      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1059      */
1060     function tokenOfOwnerByIndex(address owner, uint256 index)
1061         external
1062         view
1063         returns (uint256);
1064 
1065     /**
1066      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1067      * Use along with {totalSupply} to enumerate all tokens.
1068      */
1069     function tokenByIndex(uint256 index) external view returns (uint256);
1070 }
1071 
1072 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1073 
1074 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1075 
1076 pragma solidity ^0.8.0;
1077 
1078 /**
1079  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1080  * @dev See https://eips.ethereum.org/EIPS/eip-721
1081  */
1082 interface IERC721Metadata is IERC721 {
1083     /**
1084      * @dev Returns the token collection name.
1085      */
1086     function name() external view returns (string memory);
1087 
1088     /**
1089      * @dev Returns the token collection symbol.
1090      */
1091     function symbol() external view returns (string memory);
1092 
1093     /**
1094      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1095      */
1096     function tokenURI(uint256 tokenId) external view returns (string memory);
1097 }
1098 
1099 // File: contracts/TwistedToonz.sol
1100 
1101 // Creator: Chiru Labs
1102 
1103 pragma solidity ^0.8.0;
1104 
1105 /**
1106  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1107  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1108  *
1109  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1110  *
1111  * Does not support burning tokens to address(0).
1112  *
1113  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
1114  */
1115 contract ERC721A is
1116     Context,
1117     ERC165,
1118     IERC721,
1119     IERC721Metadata,
1120     IERC721Enumerable
1121 {
1122     using Address for address;
1123     using Strings for uint256;
1124 
1125     struct TokenOwnership {
1126         address addr;
1127         uint64 startTimestamp;
1128     }
1129 
1130     struct AddressData {
1131         uint128 balance;
1132         uint128 numberMinted;
1133     }
1134 
1135     uint256 internal currentIndex;
1136 
1137     // Token name
1138     string private _name;
1139 
1140     // Token symbol
1141     string private _symbol;
1142 
1143     // Mapping from token ID to ownership details
1144     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1145     mapping(uint256 => TokenOwnership) internal _ownerships;
1146 
1147     // Mapping owner address to address data
1148     mapping(address => AddressData) private _addressData;
1149 
1150     // Mapping from token ID to approved address
1151     mapping(uint256 => address) private _tokenApprovals;
1152 
1153     // Mapping from owner to operator approvals
1154     mapping(address => mapping(address => bool)) private _operatorApprovals;
1155 
1156     constructor(string memory name_, string memory symbol_) {
1157         _name = name_;
1158         _symbol = symbol_;
1159     }
1160 
1161     /**
1162      * @dev See {IERC721Enumerable-totalSupply}.
1163      */
1164     function totalSupply() public view override returns (uint256) {
1165         return currentIndex;
1166     }
1167 
1168     /**
1169      * @dev See {IERC721Enumerable-tokenByIndex}.
1170      */
1171     function tokenByIndex(uint256 index)
1172         public
1173         view
1174         override
1175         returns (uint256)
1176     {
1177         require(index < totalSupply(), "ERC721A: global index out of bounds");
1178         return index;
1179     }
1180 
1181     /**
1182      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1183      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1184      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1185      */
1186     function tokenOfOwnerByIndex(address owner, uint256 index)
1187         public
1188         view
1189         override
1190         returns (uint256)
1191     {
1192         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1193         uint256 numMintedSoFar = totalSupply();
1194         uint256 tokenIdsIdx;
1195         address currOwnershipAddr;
1196 
1197         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1198         unchecked {
1199             for (uint256 i; i < numMintedSoFar; i++) {
1200                 TokenOwnership memory ownership = _ownerships[i];
1201                 if (ownership.addr != address(0)) {
1202                     currOwnershipAddr = ownership.addr;
1203                 }
1204                 if (currOwnershipAddr == owner) {
1205                     if (tokenIdsIdx == index) {
1206                         return i;
1207                     }
1208                     tokenIdsIdx++;
1209                 }
1210             }
1211         }
1212 
1213         revert("ERC721A: unable to get token of owner by index");
1214     }
1215 
1216     /**
1217      * @dev See {IERC165-supportsInterface}.
1218      */
1219     function supportsInterface(bytes4 interfaceId)
1220         public
1221         view
1222         virtual
1223         override(ERC165, IERC165)
1224         returns (bool)
1225     {
1226         return
1227             interfaceId == type(IERC721).interfaceId ||
1228             interfaceId == type(IERC721Metadata).interfaceId ||
1229             interfaceId == type(IERC721Enumerable).interfaceId ||
1230             super.supportsInterface(interfaceId);
1231     }
1232 
1233     /**
1234      * @dev See {IERC721-balanceOf}.
1235      */
1236     function balanceOf(address owner) public view override returns (uint256) {
1237         require(
1238             owner != address(0),
1239             "ERC721A: balance query for the zero address"
1240         );
1241         return uint256(_addressData[owner].balance);
1242     }
1243 
1244     function _numberMinted(address owner) internal view returns (uint256) {
1245         require(
1246             owner != address(0),
1247             "ERC721A: number minted query for the zero address"
1248         );
1249         return uint256(_addressData[owner].numberMinted);
1250     }
1251 
1252     /**
1253      * Gas spent here starts off proportional to the maximum mint batch size.
1254      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1255      */
1256     function ownershipOf(uint256 tokenId)
1257         internal
1258         view
1259         returns (TokenOwnership memory)
1260     {
1261         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1262 
1263         unchecked {
1264             for (uint256 curr = tokenId; curr >= 0; curr--) {
1265                 TokenOwnership memory ownership = _ownerships[curr];
1266                 if (ownership.addr != address(0)) {
1267                     return ownership;
1268                 }
1269             }
1270         }
1271 
1272         revert("ERC721A: unable to determine the owner of token");
1273     }
1274 
1275     /**
1276      * @dev See {IERC721-ownerOf}.
1277      */
1278     function ownerOf(uint256 tokenId) public view override returns (address) {
1279         return ownershipOf(tokenId).addr;
1280     }
1281 
1282     /**
1283      * @dev See {IERC721Metadata-name}.
1284      */
1285     function name() public view virtual override returns (string memory) {
1286         return _name;
1287     }
1288 
1289     /**
1290      * @dev See {IERC721Metadata-symbol}.
1291      */
1292     function symbol() public view virtual override returns (string memory) {
1293         return _symbol;
1294     }
1295 
1296     /**
1297      * @dev See {IERC721Metadata-tokenURI}.
1298      */
1299     function tokenURI(uint256 tokenId)
1300         public
1301         view
1302         virtual
1303         override
1304         returns (string memory)
1305     {
1306         require(
1307             _exists(tokenId),
1308             "ERC721Metadata: URI query for nonexistent token"
1309         );
1310 
1311         string memory baseURI = _baseURI();
1312         return
1313             bytes(baseURI).length != 0
1314                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1315                 : "";
1316     }
1317 
1318     /**
1319      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1320      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1321      * by default, can be overriden in child contracts.
1322      */
1323     function _baseURI() internal view virtual returns (string memory) {
1324         return "";
1325     }
1326 
1327     /**
1328      * @dev See {IERC721-approve}.
1329      */
1330     function approve(address to, uint256 tokenId) public override {
1331         address owner = ERC721A.ownerOf(tokenId);
1332         require(to != owner, "ERC721A: approval to current owner");
1333 
1334         require(
1335             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1336             "ERC721A: approve caller is not owner nor approved for all"
1337         );
1338 
1339         _approve(to, tokenId, owner);
1340     }
1341 
1342     /**
1343      * @dev See {IERC721-getApproved}.
1344      */
1345     function getApproved(uint256 tokenId)
1346         public
1347         view
1348         override
1349         returns (address)
1350     {
1351         require(
1352             _exists(tokenId),
1353             "ERC721A: approved query for nonexistent token"
1354         );
1355 
1356         return _tokenApprovals[tokenId];
1357     }
1358 
1359     /**
1360      * @dev See {IERC721-setApprovalForAll}.
1361      */
1362     function setApprovalForAll(address operator, bool approved)
1363         public
1364         override
1365     {
1366         require(operator != _msgSender(), "ERC721A: approve to caller");
1367 
1368         _operatorApprovals[_msgSender()][operator] = approved;
1369         emit ApprovalForAll(_msgSender(), operator, approved);
1370     }
1371 
1372     /**
1373      * @dev See {IERC721-isApprovedForAll}.
1374      */
1375     function isApprovedForAll(address owner, address operator)
1376         public
1377         view
1378         virtual
1379         override
1380         returns (bool)
1381     {
1382         return _operatorApprovals[owner][operator];
1383     }
1384 
1385     /**
1386      * @dev See {IERC721-transferFrom}.
1387      */
1388     function transferFrom(
1389         address from,
1390         address to,
1391         uint256 tokenId
1392     ) public virtual override {
1393         _transfer(from, to, tokenId);
1394     }
1395 
1396     /**
1397      * @dev See {IERC721-safeTransferFrom}.
1398      */
1399     function safeTransferFrom(
1400         address from,
1401         address to,
1402         uint256 tokenId
1403     ) public virtual override {
1404         safeTransferFrom(from, to, tokenId, "");
1405     }
1406 
1407     /**
1408      * @dev See {IERC721-safeTransferFrom}.
1409      */
1410     function safeTransferFrom(
1411         address from,
1412         address to,
1413         uint256 tokenId,
1414         bytes memory _data
1415     ) public override {
1416         _transfer(from, to, tokenId);
1417         require(
1418             _checkOnERC721Received(from, to, tokenId, _data),
1419             "ERC721A: transfer to non ERC721Receiver implementer"
1420         );
1421     }
1422 
1423     /**
1424      * @dev Returns whether `tokenId` exists.
1425      *
1426      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1427      *
1428      * Tokens start existing when they are minted (`_mint`),
1429      */
1430     function _exists(uint256 tokenId) internal view returns (bool) {
1431         return tokenId < currentIndex;
1432     }
1433 
1434     function _safeMint(address to, uint256 quantity) internal {
1435         _safeMint(to, quantity, "");
1436     }
1437 
1438     /**
1439      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1440      *
1441      * Requirements:
1442      *
1443      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1444      * - `quantity` must be greater than 0.
1445      *
1446      * Emits a {Transfer} event.
1447      */
1448     function _safeMint(
1449         address to,
1450         uint256 quantity,
1451         bytes memory _data
1452     ) internal {
1453         _mint(to, quantity, _data, true);
1454     }
1455 
1456     /**
1457      * @dev Mints `quantity` tokens and transfers them to `to`.
1458      *
1459      * Requirements:
1460      *
1461      * - `to` cannot be the zero address.
1462      * - `quantity` must be greater than 0.
1463      *
1464      * Emits a {Transfer} event.
1465      */
1466     function _mint(
1467         address to,
1468         uint256 quantity,
1469         bytes memory _data,
1470         bool safe
1471     ) internal {
1472         uint256 startTokenId = currentIndex;
1473         require(to != address(0), "ERC721A: mint to the zero address");
1474         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1475 
1476         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1477 
1478         // Overflows are incredibly unrealistic.
1479         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1480         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1481         unchecked {
1482             _addressData[to].balance += uint128(quantity);
1483             _addressData[to].numberMinted += uint128(quantity);
1484 
1485             _ownerships[startTokenId].addr = to;
1486             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1487 
1488             uint256 updatedIndex = startTokenId;
1489 
1490             for (uint256 i; i < quantity; i++) {
1491                 emit Transfer(address(0), to, updatedIndex);
1492                 if (safe) {
1493                     require(
1494                         _checkOnERC721Received(
1495                             address(0),
1496                             to,
1497                             updatedIndex,
1498                             _data
1499                         ),
1500                         "ERC721A: transfer to non ERC721Receiver implementer"
1501                     );
1502                 }
1503 
1504                 updatedIndex++;
1505             }
1506 
1507             currentIndex = updatedIndex;
1508         }
1509 
1510         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1511     }
1512 
1513     /**
1514      * @dev Transfers `tokenId` from `from` to `to`.
1515      *
1516      * Requirements:
1517      *
1518      * - `to` cannot be the zero address.
1519      * - `tokenId` token must be owned by `from`.
1520      *
1521      * Emits a {Transfer} event.
1522      */
1523     function _transfer(
1524         address from,
1525         address to,
1526         uint256 tokenId
1527     ) private {
1528         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1529 
1530         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1531             getApproved(tokenId) == _msgSender() ||
1532             isApprovedForAll(prevOwnership.addr, _msgSender()));
1533 
1534         require(
1535             isApprovedOrOwner,
1536             "ERC721A: transfer caller is not owner nor approved"
1537         );
1538 
1539         require(
1540             prevOwnership.addr == from,
1541             "ERC721A: transfer from incorrect owner"
1542         );
1543         require(to != address(0), "ERC721A: transfer to the zero address");
1544 
1545         _beforeTokenTransfers(from, to, tokenId, 1);
1546 
1547         // Clear approvals from the previous owner
1548         _approve(address(0), tokenId, prevOwnership.addr);
1549 
1550         // Underflow of the sender's balance is impossible because we check for
1551         // ownership above and the recipient's balance can't realistically overflow.
1552         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1553         unchecked {
1554             _addressData[from].balance -= 1;
1555             _addressData[to].balance += 1;
1556 
1557             _ownerships[tokenId].addr = to;
1558             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1559 
1560             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1561             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1562             uint256 nextTokenId = tokenId + 1;
1563             if (_ownerships[nextTokenId].addr == address(0)) {
1564                 if (_exists(nextTokenId)) {
1565                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1566                     _ownerships[nextTokenId].startTimestamp = prevOwnership
1567                         .startTimestamp;
1568                 }
1569             }
1570         }
1571 
1572         emit Transfer(from, to, tokenId);
1573         _afterTokenTransfers(from, to, tokenId, 1);
1574     }
1575 
1576     /**
1577      * @dev Approve `to` to operate on `tokenId`
1578      *
1579      * Emits a {Approval} event.
1580      */
1581     function _approve(
1582         address to,
1583         uint256 tokenId,
1584         address owner
1585     ) private {
1586         _tokenApprovals[tokenId] = to;
1587         emit Approval(owner, to, tokenId);
1588     }
1589 
1590     /**
1591      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1592      * The call is not executed if the target address is not a contract.
1593      *
1594      * @param from address representing the previous owner of the given token ID
1595      * @param to target address that will receive the tokens
1596      * @param tokenId uint256 ID of the token to be transferred
1597      * @param _data bytes optional data to send along with the call
1598      * @return bool whether the call correctly returned the expected magic value
1599      */
1600     function _checkOnERC721Received(
1601         address from,
1602         address to,
1603         uint256 tokenId,
1604         bytes memory _data
1605     ) private returns (bool) {
1606         if (to.isContract()) {
1607             try
1608                 IERC721Receiver(to).onERC721Received(
1609                     _msgSender(),
1610                     from,
1611                     tokenId,
1612                     _data
1613                 )
1614             returns (bytes4 retval) {
1615                 return retval == IERC721Receiver(to).onERC721Received.selector;
1616             } catch (bytes memory reason) {
1617                 if (reason.length == 0) {
1618                     revert(
1619                         "ERC721A: transfer to non ERC721Receiver implementer"
1620                     );
1621                 } else {
1622                     assembly {
1623                         revert(add(32, reason), mload(reason))
1624                     }
1625                 }
1626             }
1627         } else {
1628             return true;
1629         }
1630     }
1631 
1632     /**
1633      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1634      *
1635      * startTokenId - the first token id to be transferred
1636      * quantity - the amount to be transferred
1637      *
1638      * Calling conditions:
1639      *
1640      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1641      * transferred to `to`.
1642      * - When `from` is zero, `tokenId` will be minted for `to`.
1643      */
1644     function _beforeTokenTransfers(
1645         address from,
1646         address to,
1647         uint256 startTokenId,
1648         uint256 quantity
1649     ) internal virtual {}
1650 
1651     /**
1652      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1653      * minting.
1654      *
1655      * startTokenId - the first token id to be transferred
1656      * quantity - the amount to be transferred
1657      *
1658      * Calling conditions:
1659      *
1660      * - when `from` and `to` are both non-zero.
1661      * - `from` and `to` are never both zero.
1662      */
1663     function _afterTokenTransfers(
1664         address from,
1665         address to,
1666         uint256 startTokenId,
1667         uint256 quantity
1668     ) internal virtual {}
1669 }
1670 
1671 contract BadTrippinApe is ERC721A, Ownable, ReentrancyGuard {
1672     string public baseURI;
1673     uint256 public price = 0.0025 ether;
1674     uint256 public maxPerTxWL = 2;
1675     uint256 public maxPerTx = 5;
1676     uint256 public maxPerWallet = 10;
1677     uint256 public totalFreeForWL = 260;
1678     uint256 public totalFree = 1111;
1679     uint256 public maxSupply = 5555;
1680     bytes32 public merkleRoot = 0x0;
1681     uint256 public nextOwnerToExplicitlySet;
1682     bool public wlEnabled = false;
1683     bool public mintEnabled = false;
1684 
1685     constructor() ERC721A("Bad Trippin Ape", "BAP") {}
1686 
1687     function mint(uint256 amt) external payable {
1688         uint256 cost = price;
1689         if (totalSupply() + amt < totalFree + 1) {
1690             cost = 0;
1691         }
1692         require(mintEnabled, "Minting is not live yet, hold on Bad Trippin Ape.");
1693         require(msg.sender == tx.origin, "Be yourself, honey.");
1694         require(msg.value >= amt * cost, "Please send the exact amount.");
1695         require(amt < maxPerTx + 1, "Max per TX reached.");
1696         require(
1697             numberMinted(msg.sender) + amt <= maxPerWallet,
1698             "Max per wallet reached."
1699         );
1700         require(totalSupply() + amt < maxSupply + 1, "No more Bad Trippin Ape");
1701 
1702         _safeMint(msg.sender, amt);
1703     }
1704 
1705     function WLMint(bytes32[] calldata _merkleProof, uint256 amt)
1706         external
1707         payable
1708     {
1709         require(wlEnabled, "Trippilist mint is disabled.");
1710         require(
1711             totalSupply() + amt < totalFreeForWL + 1,
1712             "No more Bad Trippin Apes for WL"
1713         );
1714         require(amt < maxPerTxWL + 1, "Max per TX reached.");
1715         require(
1716             numberMinted(msg.sender) + amt <= maxPerTxWL,
1717             "Max per wallet reached."
1718         );
1719 
1720         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1721         require(
1722             MerkleProof.verify(_merkleProof, merkleRoot, leaf),
1723             "Invalid Merkle proof."
1724         );
1725 
1726         _safeMint(msg.sender, amt);
1727     }
1728 
1729     function ownerBatchMint(uint256 amt) external onlyOwner {
1730         require(totalSupply() + amt < maxSupply + 1, "too many!");
1731 
1732         _safeMint(msg.sender, amt);
1733     }
1734 
1735     function toggleMinting() external onlyOwner {
1736         mintEnabled = !mintEnabled;
1737     }
1738 
1739     function toggleWLMinting() external onlyOwner {
1740         wlEnabled = !wlEnabled;
1741     }
1742 
1743     function numberMinted(address owner) public view returns (uint256) {
1744         return _numberMinted(owner);
1745     }
1746 
1747     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1748         merkleRoot = _merkleRoot;
1749     }
1750 
1751     function setBaseURI(string calldata baseURI_) external onlyOwner {
1752         baseURI = baseURI_;
1753     }
1754 
1755     function setPrice(uint256 price_) external onlyOwner {
1756         price = price_;
1757     }
1758 
1759     function setTotalFree(uint256 totalFree_) external onlyOwner {
1760         totalFree = totalFree_;
1761     }
1762 
1763     function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
1764         maxPerTx = maxPerTx_;
1765     }
1766 
1767     function setmaxSupply(uint256 maxSupply_) external onlyOwner {
1768         maxSupply = maxSupply_;
1769     }
1770 
1771     function _baseURI() internal view virtual override returns (string memory) {
1772         return baseURI;
1773     }
1774 
1775     function withdraw() external onlyOwner nonReentrant {
1776         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1777         require(success, "Transfer failed.");
1778     }
1779 }