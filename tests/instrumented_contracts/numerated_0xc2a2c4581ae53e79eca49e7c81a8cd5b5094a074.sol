1 //SPDX-License-Identifier: MIT
2 
3 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
4 
5 
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @title IERC1363Spender Interface
11  * @author Vittorio Minacori (https://github.com/vittominacori)
12  * @dev Interface for any contract that wants to support approveAndCall
13  *  from ERC1363 token contracts as defined in
14  *  https://eips.ethereum.org/EIPS/eip-1363
15  */
16 interface IERC1363Spender {
17     /**
18      * @notice Handle the approval of ERC1363 tokens
19      * @dev Any ERC1363 smart contract calls this function on the recipient
20      * after an `approve`. This function MAY throw to revert and reject the
21      * approval. Return of other than the magic value MUST result in the
22      * transaction being reverted.
23      * Note: the token contract address is always the message sender.
24      * @param sender address The address which called `approveAndCall` function
25      * @param amount uint256 The amount of tokens to be spent
26      * @param data bytes Additional data with no specified format
27      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))` unless throwing
28      */
29     function onApprovalReceived(
30         address sender,
31         uint256 amount,
32         bytes calldata data
33     ) external returns (bytes4);
34 }
35 
36 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
37 
38 
39 
40 pragma solidity ^0.8.0;
41 
42 /**
43  * @title IERC1363Receiver Interface
44  * @author Vittorio Minacori (https://github.com/vittominacori)
45  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
46  *  from ERC1363 token contracts as defined in
47  *  https://eips.ethereum.org/EIPS/eip-1363
48  */
49 interface IERC1363Receiver {
50     /**
51      * @notice Handle the receipt of ERC1363 tokens
52      * @dev Any ERC1363 smart contract calls this function on the recipient
53      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
54      * transfer. Return of other than the magic value MUST result in the
55      * transaction being reverted.
56      * Note: the token contract address is always the message sender.
57      * @param spender address The address which called `transferAndCall` or `transferFromAndCall` function
58      * @param sender address The address which are token transferred from
59      * @param amount uint256 The amount of tokens transferred
60      * @param data bytes Additional data with no specified format
61      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))` unless throwing
62      */
63     function onTransferReceived(
64         address spender,
65         address sender,
66         uint256 amount,
67         bytes calldata data
68     ) external returns (bytes4);
69 }
70 
71 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Interface of the ERC165 standard, as defined in the
80  * https://eips.ethereum.org/EIPS/eip-165[EIP].
81  *
82  * Implementers can declare support of contract interfaces, which can then be
83  * queried by others ({ERC165Checker}).
84  *
85  * For an implementation, see {ERC165}.
86  */
87 interface IERC165 {
88     /**
89      * @dev Returns true if this contract implements the interface defined by
90      * `interfaceId`. See the corresponding
91      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
92      * to learn more about how these ids are created.
93      *
94      * This function call must use less than 30 000 gas.
95      */
96     function supportsInterface(bytes4 interfaceId) external view returns (bool);
97 }
98 
99 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
100 
101 
102 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
103 
104 pragma solidity ^0.8.0;
105 
106 
107 /**
108  * @dev Implementation of the {IERC165} interface.
109  *
110  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
111  * for the additional interface id that will be supported. For example:
112  *
113  * ```solidity
114  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
115  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
116  * }
117  * ```
118  *
119  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
120  */
121 abstract contract ERC165 is IERC165 {
122     /**
123      * @dev See {IERC165-supportsInterface}.
124      */
125     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
126         return interfaceId == type(IERC165).interfaceId;
127     }
128 }
129 
130 // File: @openzeppelin/contracts/utils/Address.sol
131 
132 
133 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
134 
135 pragma solidity ^0.8.1;
136 
137 /**
138  * @dev Collection of functions related to the address type
139  */
140 library Address {
141     /**
142      * @dev Returns true if `account` is a contract.
143      *
144      * [IMPORTANT]
145      * ====
146      * It is unsafe to assume that an address for which this function returns
147      * false is an externally-owned account (EOA) and not a contract.
148      *
149      * Among others, `isContract` will return false for the following
150      * types of addresses:
151      *
152      *  - an externally-owned account
153      *  - a contract in construction
154      *  - an address where a contract will be created
155      *  - an address where a contract lived, but was destroyed
156      * ====
157      *
158      * [IMPORTANT]
159      * ====
160      * You shouldn't rely on `isContract` to protect against flash loan attacks!
161      *
162      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
163      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
164      * constructor.
165      * ====
166      */
167     function isContract(address account) internal view returns (bool) {
168         // This method relies on extcodesize/address.code.length, which returns 0
169         // for contracts in construction, since the code is only stored at the end
170         // of the constructor execution.
171 
172         return account.code.length > 0;
173     }
174 
175     /**
176      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
177      * `recipient`, forwarding all available gas and reverting on errors.
178      *
179      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
180      * of certain opcodes, possibly making contracts go over the 2300 gas limit
181      * imposed by `transfer`, making them unable to receive funds via
182      * `transfer`. {sendValue} removes this limitation.
183      *
184      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
185      *
186      * IMPORTANT: because control is transferred to `recipient`, care must be
187      * taken to not create reentrancy vulnerabilities. Consider using
188      * {ReentrancyGuard} or the
189      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
190      */
191     function sendValue(address payable recipient, uint256 amount) internal {
192         require(address(this).balance >= amount, "Address: insufficient balance");
193 
194         (bool success, ) = recipient.call{value: amount}("");
195         require(success, "Address: unable to send value, recipient may have reverted");
196     }
197 
198     /**
199      * @dev Performs a Solidity function call using a low level `call`. A
200      * plain `call` is an unsafe replacement for a function call: use this
201      * function instead.
202      *
203      * If `target` reverts with a revert reason, it is bubbled up by this
204      * function (like regular Solidity function calls).
205      *
206      * Returns the raw returned data. To convert to the expected return value,
207      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
208      *
209      * Requirements:
210      *
211      * - `target` must be a contract.
212      * - calling `target` with `data` must not revert.
213      *
214      * _Available since v3.1._
215      */
216     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
217         return functionCall(target, data, "Address: low-level call failed");
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
222      * `errorMessage` as a fallback revert reason when `target` reverts.
223      *
224      * _Available since v3.1._
225      */
226     function functionCall(
227         address target,
228         bytes memory data,
229         string memory errorMessage
230     ) internal returns (bytes memory) {
231         return functionCallWithValue(target, data, 0, errorMessage);
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
236      * but also transferring `value` wei to `target`.
237      *
238      * Requirements:
239      *
240      * - the calling contract must have an ETH balance of at least `value`.
241      * - the called Solidity function must be `payable`.
242      *
243      * _Available since v3.1._
244      */
245     function functionCallWithValue(
246         address target,
247         bytes memory data,
248         uint256 value
249     ) internal returns (bytes memory) {
250         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
255      * with `errorMessage` as a fallback revert reason when `target` reverts.
256      *
257      * _Available since v3.1._
258      */
259     function functionCallWithValue(
260         address target,
261         bytes memory data,
262         uint256 value,
263         string memory errorMessage
264     ) internal returns (bytes memory) {
265         require(address(this).balance >= value, "Address: insufficient balance for call");
266         require(isContract(target), "Address: call to non-contract");
267 
268         (bool success, bytes memory returndata) = target.call{value: value}(data);
269         return verifyCallResult(success, returndata, errorMessage);
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
274      * but performing a static call.
275      *
276      * _Available since v3.3._
277      */
278     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
279         return functionStaticCall(target, data, "Address: low-level static call failed");
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
284      * but performing a static call.
285      *
286      * _Available since v3.3._
287      */
288     function functionStaticCall(
289         address target,
290         bytes memory data,
291         string memory errorMessage
292     ) internal view returns (bytes memory) {
293         require(isContract(target), "Address: static call to non-contract");
294 
295         (bool success, bytes memory returndata) = target.staticcall(data);
296         return verifyCallResult(success, returndata, errorMessage);
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
301      * but performing a delegate call.
302      *
303      * _Available since v3.4._
304      */
305     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
306         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
311      * but performing a delegate call.
312      *
313      * _Available since v3.4._
314      */
315     function functionDelegateCall(
316         address target,
317         bytes memory data,
318         string memory errorMessage
319     ) internal returns (bytes memory) {
320         require(isContract(target), "Address: delegate call to non-contract");
321 
322         (bool success, bytes memory returndata) = target.delegatecall(data);
323         return verifyCallResult(success, returndata, errorMessage);
324     }
325 
326     /**
327      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
328      * revert reason using the provided one.
329      *
330      * _Available since v4.3._
331      */
332     function verifyCallResult(
333         bool success,
334         bytes memory returndata,
335         string memory errorMessage
336     ) internal pure returns (bytes memory) {
337         if (success) {
338             return returndata;
339         } else {
340             // Look for revert reason and bubble it up if present
341             if (returndata.length > 0) {
342                 // The easiest way to bubble the revert reason is using memory via assembly
343                 /// @solidity memory-safe-assembly
344                 assembly {
345                     let returndata_size := mload(returndata)
346                     revert(add(32, returndata), returndata_size)
347                 }
348             } else {
349                 revert(errorMessage);
350             }
351         }
352     }
353 }
354 
355 // File: @openzeppelin/contracts/utils/Context.sol
356 
357 
358 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
359 
360 pragma solidity ^0.8.0;
361 
362 /**
363  * @dev Provides information about the current execution context, including the
364  * sender of the transaction and its data. While these are generally available
365  * via msg.sender and msg.data, they should not be accessed in such a direct
366  * manner, since when dealing with meta-transactions the account sending and
367  * paying for execution may not be the actual sender (as far as an application
368  * is concerned).
369  *
370  * This contract is only required for intermediate, library-like contracts.
371  */
372 abstract contract Context {
373     function _msgSender() internal view virtual returns (address) {
374         return msg.sender;
375     }
376 
377     function _msgData() internal view virtual returns (bytes calldata) {
378         return msg.data;
379     }
380 }
381 
382 // File: @openzeppelin/contracts/security/Pausable.sol
383 
384 
385 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
386 
387 pragma solidity ^0.8.0;
388 
389 
390 /**
391  * @dev Contract module which allows children to implement an emergency stop
392  * mechanism that can be triggered by an authorized account.
393  *
394  * This module is used through inheritance. It will make available the
395  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
396  * the functions of your contract. Note that they will not be pausable by
397  * simply including this module, only once the modifiers are put in place.
398  */
399 abstract contract Pausable is Context {
400     /**
401      * @dev Emitted when the pause is triggered by `account`.
402      */
403     event Paused(address account);
404 
405     /**
406      * @dev Emitted when the pause is lifted by `account`.
407      */
408     event Unpaused(address account);
409 
410     bool private _paused;
411 
412     /**
413      * @dev Initializes the contract in unpaused state.
414      */
415     constructor() {
416         _paused = false;
417     }
418 
419     /**
420      * @dev Modifier to make a function callable only when the contract is not paused.
421      *
422      * Requirements:
423      *
424      * - The contract must not be paused.
425      */
426     modifier whenNotPaused() {
427         _requireNotPaused();
428         _;
429     }
430 
431     /**
432      * @dev Modifier to make a function callable only when the contract is paused.
433      *
434      * Requirements:
435      *
436      * - The contract must be paused.
437      */
438     modifier whenPaused() {
439         _requirePaused();
440         _;
441     }
442 
443     /**
444      * @dev Returns true if the contract is paused, and false otherwise.
445      */
446     function paused() public view virtual returns (bool) {
447         return _paused;
448     }
449 
450     /**
451      * @dev Throws if the contract is paused.
452      */
453     function _requireNotPaused() internal view virtual {
454         require(!paused(), "Pausable: paused");
455     }
456 
457     /**
458      * @dev Throws if the contract is not paused.
459      */
460     function _requirePaused() internal view virtual {
461         require(paused(), "Pausable: not paused");
462     }
463 
464     /**
465      * @dev Triggers stopped state.
466      *
467      * Requirements:
468      *
469      * - The contract must not be paused.
470      */
471     function _pause() internal virtual whenNotPaused {
472         _paused = true;
473         emit Paused(_msgSender());
474     }
475 
476     /**
477      * @dev Returns to normal state.
478      *
479      * Requirements:
480      *
481      * - The contract must be paused.
482      */
483     function _unpause() internal virtual whenPaused {
484         _paused = false;
485         emit Unpaused(_msgSender());
486     }
487 }
488 
489 // File: @openzeppelin/contracts/access/Ownable.sol
490 
491 
492 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
493 
494 pragma solidity ^0.8.0;
495 
496 
497 /**
498  * @dev Contract module which provides a basic access control mechanism, where
499  * there is an account (an owner) that can be granted exclusive access to
500  * specific functions.
501  *
502  * By default, the owner account will be the one that deploys the contract. This
503  * can later be changed with {transferOwnership}.
504  *
505  * This module is used through inheritance. It will make available the modifier
506  * `onlyOwner`, which can be applied to your functions to restrict their use to
507  * the owner.
508  */
509 abstract contract Ownable is Context {
510     address private _owner;
511 
512     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
513 
514     /**
515      * @dev Initializes the contract setting the deployer as the initial owner.
516      */
517     constructor() {
518         _transferOwnership(_msgSender());
519     }
520 
521     /**
522      * @dev Throws if called by any account other than the owner.
523      */
524     modifier onlyOwner() {
525         _checkOwner();
526         _;
527     }
528 
529     /**
530      * @dev Returns the address of the current owner.
531      */
532     function owner() public view virtual returns (address) {
533         return _owner;
534     }
535 
536     /**
537      * @dev Throws if the sender is not the owner.
538      */
539     function _checkOwner() internal view virtual {
540         require(owner() == _msgSender(), "Ownable: caller is not the owner");
541     }
542 
543     /**
544      * @dev Leaves the contract without owner. It will not be possible to call
545      * `onlyOwner` functions anymore. Can only be called by the current owner.
546      *
547      * NOTE: Renouncing ownership will leave the contract without an owner,
548      * thereby removing any functionality that is only available to the owner.
549      */
550     function renounceOwnership() public virtual onlyOwner {
551         _transferOwnership(address(0));
552     }
553 
554     /**
555      * @dev Transfers ownership of the contract to a new account (`newOwner`).
556      * Can only be called by the current owner.
557      */
558     function transferOwnership(address newOwner) public virtual onlyOwner {
559         require(newOwner != address(0), "Ownable: new owner is the zero address");
560         _transferOwnership(newOwner);
561     }
562 
563     /**
564      * @dev Transfers ownership of the contract to a new account (`newOwner`).
565      * Internal function without access restriction.
566      */
567     function _transferOwnership(address newOwner) internal virtual {
568         address oldOwner = _owner;
569         _owner = newOwner;
570         emit OwnershipTransferred(oldOwner, newOwner);
571     }
572 }
573 
574 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
575 
576 
577 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
578 
579 pragma solidity ^0.8.0;
580 
581 /**
582  * @dev Interface of the ERC20 standard as defined in the EIP.
583  */
584 interface IERC20 {
585     /**
586      * @dev Emitted when `value` tokens are moved from one account (`from`) to
587      * another (`to`).
588      *
589      * Note that `value` may be zero.
590      */
591     event Transfer(address indexed from, address indexed to, uint256 value);
592 
593     /**
594      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
595      * a call to {approve}. `value` is the new allowance.
596      */
597     event Approval(address indexed owner, address indexed spender, uint256 value);
598 
599     /**
600      * @dev Returns the amount of tokens in existence.
601      */
602     function totalSupply() external view returns (uint256);
603 
604     /**
605      * @dev Returns the amount of tokens owned by `account`.
606      */
607     function balanceOf(address account) external view returns (uint256);
608 
609     /**
610      * @dev Moves `amount` tokens from the caller's account to `to`.
611      *
612      * Returns a boolean value indicating whether the operation succeeded.
613      *
614      * Emits a {Transfer} event.
615      */
616     function transfer(address to, uint256 amount) external returns (bool);
617 
618     /**
619      * @dev Returns the remaining number of tokens that `spender` will be
620      * allowed to spend on behalf of `owner` through {transferFrom}. This is
621      * zero by default.
622      *
623      * This value changes when {approve} or {transferFrom} are called.
624      */
625     function allowance(address owner, address spender) external view returns (uint256);
626 
627     /**
628      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
629      *
630      * Returns a boolean value indicating whether the operation succeeded.
631      *
632      * IMPORTANT: Beware that changing an allowance with this method brings the risk
633      * that someone may use both the old and the new allowance by unfortunate
634      * transaction ordering. One possible solution to mitigate this race
635      * condition is to first reduce the spender's allowance to 0 and set the
636      * desired value afterwards:
637      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
638      *
639      * Emits an {Approval} event.
640      */
641     function approve(address spender, uint256 amount) external returns (bool);
642 
643     /**
644      * @dev Moves `amount` tokens from `from` to `to` using the
645      * allowance mechanism. `amount` is then deducted from the caller's
646      * allowance.
647      *
648      * Returns a boolean value indicating whether the operation succeeded.
649      *
650      * Emits a {Transfer} event.
651      */
652     function transferFrom(
653         address from,
654         address to,
655         uint256 amount
656     ) external returns (bool);
657 }
658 
659 // File: erc-payable-token/contracts/token/ERC1363/IERC1363.sol
660 
661 
662 
663 pragma solidity ^0.8.0;
664 
665 
666 
667 /**
668  * @title IERC1363 Interface
669  * @author Vittorio Minacori (https://github.com/vittominacori)
670  * @dev Interface for a Payable Token contract as defined in
671  *  https://eips.ethereum.org/EIPS/eip-1363
672  */
673 interface IERC1363 is IERC20, IERC165 {
674     /**
675      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
676      * @param to address The address which you want to transfer to
677      * @param amount uint256 The amount of tokens to be transferred
678      * @return true unless throwing
679      */
680     function transferAndCall(address to, uint256 amount) external returns (bool);
681 
682     /**
683      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
684      * @param to address The address which you want to transfer to
685      * @param amount uint256 The amount of tokens to be transferred
686      * @param data bytes Additional data with no specified format, sent in call to `to`
687      * @return true unless throwing
688      */
689     function transferAndCall(
690         address to,
691         uint256 amount,
692         bytes calldata data
693     ) external returns (bool);
694 
695     /**
696      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
697      * @param from address The address which you want to send tokens from
698      * @param to address The address which you want to transfer to
699      * @param amount uint256 The amount of tokens to be transferred
700      * @return true unless throwing
701      */
702     function transferFromAndCall(
703         address from,
704         address to,
705         uint256 amount
706     ) external returns (bool);
707 
708     /**
709      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
710      * @param from address The address which you want to send tokens from
711      * @param to address The address which you want to transfer to
712      * @param amount uint256 The amount of tokens to be transferred
713      * @param data bytes Additional data with no specified format, sent in call to `to`
714      * @return true unless throwing
715      */
716     function transferFromAndCall(
717         address from,
718         address to,
719         uint256 amount,
720         bytes calldata data
721     ) external returns (bool);
722 
723     /**
724      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
725      * and then call `onApprovalReceived` on spender.
726      * Beware that changing an allowance with this method brings the risk that someone may use both the old
727      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
728      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
729      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
730      * @param spender address The address which will spend the funds
731      * @param amount uint256 The amount of tokens to be spent
732      */
733     function approveAndCall(address spender, uint256 amount) external returns (bool);
734 
735     /**
736      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
737      * and then call `onApprovalReceived` on spender.
738      * Beware that changing an allowance with this method brings the risk that someone may use both the old
739      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
740      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
741      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
742      * @param spender address The address which will spend the funds
743      * @param amount uint256 The amount of tokens to be spent
744      * @param data bytes Additional data with no specified format, sent in call to `spender`
745      */
746     function approveAndCall(
747         address spender,
748         uint256 amount,
749         bytes calldata data
750     ) external returns (bool);
751 }
752 
753 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
754 
755 
756 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
757 
758 pragma solidity ^0.8.0;
759 
760 
761 /**
762  * @dev Interface for the optional metadata functions from the ERC20 standard.
763  *
764  * _Available since v4.1._
765  */
766 interface IERC20Metadata is IERC20 {
767     /**
768      * @dev Returns the name of the token.
769      */
770     function name() external view returns (string memory);
771 
772     /**
773      * @dev Returns the symbol of the token.
774      */
775     function symbol() external view returns (string memory);
776 
777     /**
778      * @dev Returns the decimals places of the token.
779      */
780     function decimals() external view returns (uint8);
781 }
782 
783 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
784 
785 
786 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
787 
788 pragma solidity ^0.8.0;
789 
790 
791 
792 
793 /**
794  * @dev Implementation of the {IERC20} interface.
795  *
796  * This implementation is agnostic to the way tokens are created. This means
797  * that a supply mechanism has to be added in a derived contract using {_mint}.
798  * For a generic mechanism see {ERC20PresetMinterPauser}.
799  *
800  * TIP: For a detailed writeup see our guide
801  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
802  * to implement supply mechanisms].
803  *
804  * We have followed general OpenZeppelin Contracts guidelines: functions revert
805  * instead returning `false` on failure. This behavior is nonetheless
806  * conventional and does not conflict with the expectations of ERC20
807  * applications.
808  *
809  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
810  * This allows applications to reconstruct the allowance for all accounts just
811  * by listening to said events. Other implementations of the EIP may not emit
812  * these events, as it isn't required by the specification.
813  *
814  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
815  * functions have been added to mitigate the well-known issues around setting
816  * allowances. See {IERC20-approve}.
817  */
818 contract ERC20 is Context, IERC20, IERC20Metadata {
819     mapping(address => uint256) private _balances;
820 
821     mapping(address => mapping(address => uint256)) private _allowances;
822 
823     uint256 private _totalSupply;
824 
825     string private _name;
826     string private _symbol;
827 
828     /**
829      * @dev Sets the values for {name} and {symbol}.
830      *
831      * The default value of {decimals} is 18. To select a different value for
832      * {decimals} you should overload it.
833      *
834      * All two of these values are immutable: they can only be set once during
835      * construction.
836      */
837     constructor(string memory name_, string memory symbol_) {
838         _name = name_;
839         _symbol = symbol_;
840     }
841 
842     /**
843      * @dev Returns the name of the token.
844      */
845     function name() public view virtual override returns (string memory) {
846         return _name;
847     }
848 
849     /**
850      * @dev Returns the symbol of the token, usually a shorter version of the
851      * name.
852      */
853     function symbol() public view virtual override returns (string memory) {
854         return _symbol;
855     }
856 
857     /**
858      * @dev Returns the number of decimals used to get its user representation.
859      * For example, if `decimals` equals `2`, a balance of `505` tokens should
860      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
861      *
862      * Tokens usually opt for a value of 18, imitating the relationship between
863      * Ether and Wei. This is the value {ERC20} uses, unless this function is
864      * overridden;
865      *
866      * NOTE: This information is only used for _display_ purposes: it in
867      * no way affects any of the arithmetic of the contract, including
868      * {IERC20-balanceOf} and {IERC20-transfer}.
869      */
870     function decimals() public view virtual override returns (uint8) {
871         return 18;
872     }
873 
874     /**
875      * @dev See {IERC20-totalSupply}.
876      */
877     function totalSupply() public view virtual override returns (uint256) {
878         return _totalSupply;
879     }
880 
881     /**
882      * @dev See {IERC20-balanceOf}.
883      */
884     function balanceOf(address account) public view virtual override returns (uint256) {
885         return _balances[account];
886     }
887 
888     /**
889      * @dev See {IERC20-transfer}.
890      *
891      * Requirements:
892      *
893      * - `to` cannot be the zero address.
894      * - the caller must have a balance of at least `amount`.
895      */
896     function transfer(address to, uint256 amount) public virtual override returns (bool) {
897         address owner = _msgSender();
898         _transfer(owner, to, amount);
899         return true;
900     }
901 
902     /**
903      * @dev See {IERC20-allowance}.
904      */
905     function allowance(address owner, address spender) public view virtual override returns (uint256) {
906         return _allowances[owner][spender];
907     }
908 
909     /**
910      * @dev See {IERC20-approve}.
911      *
912      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
913      * `transferFrom`. This is semantically equivalent to an infinite approval.
914      *
915      * Requirements:
916      *
917      * - `spender` cannot be the zero address.
918      */
919     function approve(address spender, uint256 amount) public virtual override returns (bool) {
920         address owner = _msgSender();
921         _approve(owner, spender, amount);
922         return true;
923     }
924 
925     /**
926      * @dev See {IERC20-transferFrom}.
927      *
928      * Emits an {Approval} event indicating the updated allowance. This is not
929      * required by the EIP. See the note at the beginning of {ERC20}.
930      *
931      * NOTE: Does not update the allowance if the current allowance
932      * is the maximum `uint256`.
933      *
934      * Requirements:
935      *
936      * - `from` and `to` cannot be the zero address.
937      * - `from` must have a balance of at least `amount`.
938      * - the caller must have allowance for ``from``'s tokens of at least
939      * `amount`.
940      */
941     function transferFrom(
942         address from,
943         address to,
944         uint256 amount
945     ) public virtual override returns (bool) {
946         address spender = _msgSender();
947         _spendAllowance(from, spender, amount);
948         _transfer(from, to, amount);
949         return true;
950     }
951 
952     /**
953      * @dev Atomically increases the allowance granted to `spender` by the caller.
954      *
955      * This is an alternative to {approve} that can be used as a mitigation for
956      * problems described in {IERC20-approve}.
957      *
958      * Emits an {Approval} event indicating the updated allowance.
959      *
960      * Requirements:
961      *
962      * - `spender` cannot be the zero address.
963      */
964     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
965         address owner = _msgSender();
966         _approve(owner, spender, allowance(owner, spender) + addedValue);
967         return true;
968     }
969 
970     /**
971      * @dev Atomically decreases the allowance granted to `spender` by the caller.
972      *
973      * This is an alternative to {approve} that can be used as a mitigation for
974      * problems described in {IERC20-approve}.
975      *
976      * Emits an {Approval} event indicating the updated allowance.
977      *
978      * Requirements:
979      *
980      * - `spender` cannot be the zero address.
981      * - `spender` must have allowance for the caller of at least
982      * `subtractedValue`.
983      */
984     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
985         address owner = _msgSender();
986         uint256 currentAllowance = allowance(owner, spender);
987         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
988         unchecked {
989             _approve(owner, spender, currentAllowance - subtractedValue);
990         }
991 
992         return true;
993     }
994 
995     /**
996      * @dev Moves `amount` of tokens from `from` to `to`.
997      *
998      * This internal function is equivalent to {transfer}, and can be used to
999      * e.g. implement automatic token fees, slashing mechanisms, etc.
1000      *
1001      * Emits a {Transfer} event.
1002      *
1003      * Requirements:
1004      *
1005      * - `from` cannot be the zero address.
1006      * - `to` cannot be the zero address.
1007      * - `from` must have a balance of at least `amount`.
1008      */
1009     function _transfer(
1010         address from,
1011         address to,
1012         uint256 amount
1013     ) internal virtual {
1014         require(from != address(0), "ERC20: transfer from the zero address");
1015         require(to != address(0), "ERC20: transfer to the zero address");
1016 
1017         _beforeTokenTransfer(from, to, amount);
1018 
1019         uint256 fromBalance = _balances[from];
1020         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1021         unchecked {
1022             _balances[from] = fromBalance - amount;
1023         }
1024         _balances[to] += amount;
1025 
1026         emit Transfer(from, to, amount);
1027 
1028         _afterTokenTransfer(from, to, amount);
1029     }
1030 
1031     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1032      * the total supply.
1033      *
1034      * Emits a {Transfer} event with `from` set to the zero address.
1035      *
1036      * Requirements:
1037      *
1038      * - `account` cannot be the zero address.
1039      */
1040     function _mint(address account, uint256 amount) internal virtual {
1041         require(account != address(0), "ERC20: mint to the zero address");
1042 
1043         _beforeTokenTransfer(address(0), account, amount);
1044 
1045         _totalSupply += amount;
1046         _balances[account] += amount;
1047         emit Transfer(address(0), account, amount);
1048 
1049         _afterTokenTransfer(address(0), account, amount);
1050     }
1051 
1052     /**
1053      * @dev Destroys `amount` tokens from `account`, reducing the
1054      * total supply.
1055      *
1056      * Emits a {Transfer} event with `to` set to the zero address.
1057      *
1058      * Requirements:
1059      *
1060      * - `account` cannot be the zero address.
1061      * - `account` must have at least `amount` tokens.
1062      */
1063     function _burn(address account, uint256 amount) internal virtual {
1064         require(account != address(0), "ERC20: burn from the zero address");
1065 
1066         _beforeTokenTransfer(account, address(0), amount);
1067 
1068         uint256 accountBalance = _balances[account];
1069         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1070         unchecked {
1071             _balances[account] = accountBalance - amount;
1072         }
1073         _totalSupply -= amount;
1074 
1075         emit Transfer(account, address(0), amount);
1076 
1077         _afterTokenTransfer(account, address(0), amount);
1078     }
1079 
1080     /**
1081      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1082      *
1083      * This internal function is equivalent to `approve`, and can be used to
1084      * e.g. set automatic allowances for certain subsystems, etc.
1085      *
1086      * Emits an {Approval} event.
1087      *
1088      * Requirements:
1089      *
1090      * - `owner` cannot be the zero address.
1091      * - `spender` cannot be the zero address.
1092      */
1093     function _approve(
1094         address owner,
1095         address spender,
1096         uint256 amount
1097     ) internal virtual {
1098         require(owner != address(0), "ERC20: approve from the zero address");
1099         require(spender != address(0), "ERC20: approve to the zero address");
1100 
1101         _allowances[owner][spender] = amount;
1102         emit Approval(owner, spender, amount);
1103     }
1104 
1105     /**
1106      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1107      *
1108      * Does not update the allowance amount in case of infinite allowance.
1109      * Revert if not enough allowance is available.
1110      *
1111      * Might emit an {Approval} event.
1112      */
1113     function _spendAllowance(
1114         address owner,
1115         address spender,
1116         uint256 amount
1117     ) internal virtual {
1118         uint256 currentAllowance = allowance(owner, spender);
1119         if (currentAllowance != type(uint256).max) {
1120             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1121             unchecked {
1122                 _approve(owner, spender, currentAllowance - amount);
1123             }
1124         }
1125     }
1126 
1127     /**
1128      * @dev Hook that is called before any transfer of tokens. This includes
1129      * minting and burning.
1130      *
1131      * Calling conditions:
1132      *
1133      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1134      * will be transferred to `to`.
1135      * - when `from` is zero, `amount` tokens will be minted for `to`.
1136      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1137      * - `from` and `to` are never both zero.
1138      *
1139      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1140      */
1141     function _beforeTokenTransfer(
1142         address from,
1143         address to,
1144         uint256 amount
1145     ) internal virtual {}
1146 
1147     /**
1148      * @dev Hook that is called after any transfer of tokens. This includes
1149      * minting and burning.
1150      *
1151      * Calling conditions:
1152      *
1153      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1154      * has been transferred to `to`.
1155      * - when `from` is zero, `amount` tokens have been minted for `to`.
1156      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1157      * - `from` and `to` are never both zero.
1158      *
1159      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1160      */
1161     function _afterTokenTransfer(
1162         address from,
1163         address to,
1164         uint256 amount
1165     ) internal virtual {}
1166 }
1167 
1168 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
1169 
1170 
1171 
1172 pragma solidity ^0.8.0;
1173 
1174 
1175 
1176 
1177 
1178 
1179 
1180 /**
1181  * @title ERC1363
1182  * @author Vittorio Minacori (https://github.com/vittominacori)
1183  * @dev Implementation of an ERC1363 interface
1184  */
1185 abstract contract ERC1363 is ERC20, IERC1363, ERC165 {
1186     using Address for address;
1187 
1188     /**
1189      * @dev See {IERC165-supportsInterface}.
1190      */
1191     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1192         return interfaceId == type(IERC1363).interfaceId || super.supportsInterface(interfaceId);
1193     }
1194 
1195     /**
1196      * @dev Transfer tokens to a specified address and then execute a callback on `to`.
1197      * @param to The address to transfer to.
1198      * @param amount The amount to be transferred.
1199      * @return A boolean that indicates if the operation was successful.
1200      */
1201     function transferAndCall(address to, uint256 amount) public virtual override returns (bool) {
1202         return transferAndCall(to, amount, "");
1203     }
1204 
1205     /**
1206      * @dev Transfer tokens to a specified address and then execute a callback on `to`.
1207      * @param to The address to transfer to
1208      * @param amount The amount to be transferred
1209      * @param data Additional data with no specified format
1210      * @return A boolean that indicates if the operation was successful.
1211      */
1212     function transferAndCall(
1213         address to,
1214         uint256 amount,
1215         bytes memory data
1216     ) public virtual override returns (bool) {
1217         transfer(to, amount);
1218         require(_checkOnTransferReceived(_msgSender(), to, amount, data), "ERC1363: receiver returned wrong data");
1219         return true;
1220     }
1221 
1222     /**
1223      * @dev Transfer tokens from one address to another and then execute a callback on `to`.
1224      * @param from The address which you want to send tokens from
1225      * @param to The address which you want to transfer to
1226      * @param amount The amount of tokens to be transferred
1227      * @return A boolean that indicates if the operation was successful.
1228      */
1229     function transferFromAndCall(
1230         address from,
1231         address to,
1232         uint256 amount
1233     ) public virtual override returns (bool) {
1234         return transferFromAndCall(from, to, amount, "");
1235     }
1236 
1237     /**
1238      * @dev Transfer tokens from one address to another and then execute a callback on `to`.
1239      * @param from The address which you want to send tokens from
1240      * @param to The address which you want to transfer to
1241      * @param amount The amount of tokens to be transferred
1242      * @param data Additional data with no specified format
1243      * @return A boolean that indicates if the operation was successful.
1244      */
1245     function transferFromAndCall(
1246         address from,
1247         address to,
1248         uint256 amount,
1249         bytes memory data
1250     ) public virtual override returns (bool) {
1251         transferFrom(from, to, amount);
1252         require(_checkOnTransferReceived(from, to, amount, data), "ERC1363: receiver returned wrong data");
1253         return true;
1254     }
1255 
1256     /**
1257      * @dev Approve spender to transfer tokens and then execute a callback on `spender`.
1258      * @param spender The address allowed to transfer to
1259      * @param amount The amount allowed to be transferred
1260      * @return A boolean that indicates if the operation was successful.
1261      */
1262     function approveAndCall(address spender, uint256 amount) public virtual override returns (bool) {
1263         return approveAndCall(spender, amount, "");
1264     }
1265 
1266     /**
1267      * @dev Approve spender to transfer tokens and then execute a callback on `spender`.
1268      * @param spender The address allowed to transfer to.
1269      * @param amount The amount allowed to be transferred.
1270      * @param data Additional data with no specified format.
1271      * @return A boolean that indicates if the operation was successful.
1272      */
1273     function approveAndCall(
1274         address spender,
1275         uint256 amount,
1276         bytes memory data
1277     ) public virtual override returns (bool) {
1278         approve(spender, amount);
1279         require(_checkOnApprovalReceived(spender, amount, data), "ERC1363: spender returned wrong data");
1280         return true;
1281     }
1282 
1283     /**
1284      * @dev Internal function to invoke {IERC1363Receiver-onTransferReceived} on a target address
1285      *  The call is not executed if the target address is not a contract
1286      * @param sender address Representing the previous owner of the given token amount
1287      * @param recipient address Target address that will receive the tokens
1288      * @param amount uint256 The amount mount of tokens to be transferred
1289      * @param data bytes Optional data to send along with the call
1290      * @return whether the call correctly returned the expected magic value
1291      */
1292     function _checkOnTransferReceived(
1293         address sender,
1294         address recipient,
1295         uint256 amount,
1296         bytes memory data
1297     ) internal virtual returns (bool) {
1298         if (!recipient.isContract()) {
1299             revert("ERC1363: transfer to non contract address");
1300         }
1301 
1302         try IERC1363Receiver(recipient).onTransferReceived(_msgSender(), sender, amount, data) returns (bytes4 retval) {
1303             return retval == IERC1363Receiver.onTransferReceived.selector;
1304         } catch (bytes memory reason) {
1305             if (reason.length == 0) {
1306                 revert("ERC1363: transfer to non ERC1363Receiver implementer");
1307             } else {
1308                 /// @solidity memory-safe-assembly
1309                 assembly {
1310                     revert(add(32, reason), mload(reason))
1311                 }
1312             }
1313         }
1314     }
1315 
1316     /**
1317      * @dev Internal function to invoke {IERC1363Receiver-onApprovalReceived} on a target address
1318      *  The call is not executed if the target address is not a contract
1319      * @param spender address The address which will spend the funds
1320      * @param amount uint256 The amount of tokens to be spent
1321      * @param data bytes Optional data to send along with the call
1322      * @return whether the call correctly returned the expected magic value
1323      */
1324     function _checkOnApprovalReceived(
1325         address spender,
1326         uint256 amount,
1327         bytes memory data
1328     ) internal virtual returns (bool) {
1329         if (!spender.isContract()) {
1330             revert("ERC1363: approve a non contract address");
1331         }
1332 
1333         try IERC1363Spender(spender).onApprovalReceived(_msgSender(), amount, data) returns (bytes4 retval) {
1334             return retval == IERC1363Spender.onApprovalReceived.selector;
1335         } catch (bytes memory reason) {
1336             if (reason.length == 0) {
1337                 revert("ERC1363: approve a non ERC1363Spender implementer");
1338             } else {
1339                 /// @solidity memory-safe-assembly
1340                 assembly {
1341                     revert(add(32, reason), mload(reason))
1342                 }
1343             }
1344         }
1345     }
1346 }
1347 
1348 // File: contracts/dopes.sol
1349 
1350 
1351 
1352 pragma solidity ^0.8.9;
1353 
1354 
1355 
1356 
1357 contract Dopes is ERC1363, Ownable, Pausable {
1358   uint private totalDopeSupply = 5000000000 * 10**18; // 5 thousand million Dopes
1359 
1360   // a mapping from an address to whether or not it can mint / burn
1361   mapping(address => bool) public controllers;
1362 
1363   constructor() ERC20("dopes", "DOPES") {
1364       _mint(owner(), totalDopeSupply);  // whole balance is held by the manager
1365   }
1366 
1367   /**
1368    * burns $DOPES from a holder
1369    * @param from the holder of the $DOPES
1370    * @param amount the amount of $DOPES to burn
1371    */
1372   function burn(address from, uint256 amount) external {
1373     require(controllers[_msgSender()], "Only controllers can burn");
1374     _burn(from, amount);
1375   }
1376 
1377   /**
1378    * enables an address to mint / burn
1379    * @param controller the address to enable
1380    */
1381   function addController(address controller) external onlyOwner {
1382     controllers[controller] = true;
1383   }
1384 
1385   /**
1386    * disables an address from minting / burning
1387    * @param controller the address to disbale
1388    */
1389   function removeController(address controller) external onlyOwner  {
1390     controllers[controller] = false;
1391   }
1392 
1393   function transfer(address _to, uint _value) public override whenNotPaused returns (bool) {
1394     return super.transfer(_to, _value);
1395   }
1396 
1397   function transferFrom(address _from, address _to, uint _value) public override whenNotPaused returns (bool) {
1398     return super.transferFrom(_from, _to, _value);
1399   }
1400   
1401   function pause() external onlyOwner {
1402       _pause();
1403   }
1404 
1405     function unpause() external onlyOwner {
1406       _unpause();
1407   }
1408 }