1 pragma solidity ^0.8.0;
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
26 /**
27  * @dev Contract module which provides a basic access control mechanism, where
28  * there is an account (an owner) that can be granted exclusive access to
29  * specific functions.
30  *
31  * By default, the owner account will be the one that deploys the contract. This
32  * can later be changed with {transferOwnership}.
33  *
34  * This module is used through inheritance. It will make available the modifier
35  * `onlyOwner`, which can be applied to your functions to restrict their use to
36  * the owner.
37  */
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor() {
47         _transferOwnership(_msgSender());
48     }
49 
50     /**
51      * @dev Returns the address of the current owner.
52      */
53     function owner() public view virtual returns (address) {
54         return _owner;
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         require(owner() == _msgSender(), "Ownable: caller is not the owner");
62         _;
63     }
64 
65     /**
66      * @dev Leaves the contract without owner. It will not be possible to call
67      * `onlyOwner` functions anymore. Can only be called by the current owner.
68      *
69      * NOTE: Renouncing ownership will leave the contract without an owner,
70      * thereby removing any functionality that is only available to the owner.
71      */
72     function renounceOwnership() public virtual onlyOwner {
73         _transferOwnership(address(0));
74     }
75 
76     /**
77      * @dev Transfers ownership of the contract to a new account (`newOwner`).
78      * Can only be called by the current owner.
79      */
80     function transferOwnership(address newOwner) public virtual onlyOwner {
81         require(newOwner != address(0), "Ownable: new owner is the zero address");
82         _transferOwnership(newOwner);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Internal function without access restriction.
88      */
89     function _transferOwnership(address newOwner) internal virtual {
90         address oldOwner = _owner;
91         _owner = newOwner;
92         emit OwnershipTransferred(oldOwner, newOwner);
93     }
94 }
95 
96 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
97 /**
98  * @dev Interface of the ERC20 standard as defined in the EIP.
99  */
100 interface IERC20 {
101     /**
102      * @dev Returns the amount of tokens in existence.
103      */
104     function totalSupply() external view returns (uint256);
105 
106     /**
107      * @dev Returns the amount of tokens owned by `account`.
108      */
109     function balanceOf(address account) external view returns (uint256);
110 
111     /**
112      * @dev Moves `amount` tokens from the caller's account to `recipient`.
113      *
114      * Returns a boolean value indicating whether the operation succeeded.
115      *
116      * Emits a {Transfer} event.
117      */
118     function transfer(address recipient, uint256 amount) external returns (bool);
119 
120     /**
121      * @dev Returns the remaining number of tokens that `spender` will be
122      * allowed to spend on behalf of `owner` through {transferFrom}. This is
123      * zero by default.
124      *
125      * This value changes when {approve} or {transferFrom} are called.
126      */
127     function allowance(address owner, address spender) external view returns (uint256);
128 
129     /**
130      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * IMPORTANT: Beware that changing an allowance with this method brings the risk
135      * that someone may use both the old and the new allowance by unfortunate
136      * transaction ordering. One possible solution to mitigate this race
137      * condition is to first reduce the spender's allowance to 0 and set the
138      * desired value afterwards:
139      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140      *
141      * Emits an {Approval} event.
142      */
143     function approve(address spender, uint256 amount) external returns (bool);
144 
145     /**
146      * @dev Moves `amount` tokens from `sender` to `recipient` using the
147      * allowance mechanism. `amount` is then deducted from the caller's
148      * allowance.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * Emits a {Transfer} event.
153      */
154     function transferFrom(
155         address sender,
156         address recipient,
157         uint256 amount
158     ) external returns (bool);
159 
160     /**
161      * @dev Emitted when `value` tokens are moved from one account (`from`) to
162      * another (`to`).
163      *
164      * Note that `value` may be zero.
165      */
166     event Transfer(address indexed from, address indexed to, uint256 value);
167 
168     /**
169      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
170      * a call to {approve}. `value` is the new allowance.
171      */
172     event Approval(address indexed owner, address indexed spender, uint256 value);
173 }
174 
175 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
176 /**
177  * @dev Collection of functions related to the address type
178  */
179 library Address {
180     /**
181      * @dev Returns true if `account` is a contract.
182      *
183      * [IMPORTANT]
184      * ====
185      * It is unsafe to assume that an address for which this function returns
186      * false is an externally-owned account (EOA) and not a contract.
187      *
188      * Among others, `isContract` will return false for the following
189      * types of addresses:
190      *
191      *  - an externally-owned account
192      *  - a contract in construction
193      *  - an address where a contract will be created
194      *  - an address where a contract lived, but was destroyed
195      * ====
196      */
197     function isContract(address account) internal view returns (bool) {
198         // This method relies on extcodesize, which returns 0 for contracts in
199         // construction, since the code is only stored at the end of the
200         // constructor execution.
201 
202         uint256 size;
203         assembly {
204             size := extcodesize(account)
205         }
206         return size > 0;
207     }
208 
209     /**
210      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
211      * `recipient`, forwarding all available gas and reverting on errors.
212      *
213      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
214      * of certain opcodes, possibly making contracts go over the 2300 gas limit
215      * imposed by `transfer`, making them unable to receive funds via
216      * `transfer`. {sendValue} removes this limitation.
217      *
218      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
219      *
220      * IMPORTANT: because control is transferred to `recipient`, care must be
221      * taken to not create reentrancy vulnerabilities. Consider using
222      * {ReentrancyGuard} or the
223      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
224      */
225     function sendValue(address payable recipient, uint256 amount) internal {
226         require(address(this).balance >= amount, "Address: insufficient balance");
227 
228         (bool success, ) = recipient.call{value: amount}("");
229         require(success, "Address: unable to send value, recipient may have reverted");
230     }
231 
232     /**
233      * @dev Performs a Solidity function call using a low level `call`. A
234      * plain `call` is an unsafe replacement for a function call: use this
235      * function instead.
236      *
237      * If `target` reverts with a revert reason, it is bubbled up by this
238      * function (like regular Solidity function calls).
239      *
240      * Returns the raw returned data. To convert to the expected return value,
241      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
242      *
243      * Requirements:
244      *
245      * - `target` must be a contract.
246      * - calling `target` with `data` must not revert.
247      *
248      * _Available since v3.1._
249      */
250     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
251         return functionCall(target, data, "Address: low-level call failed");
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
256      * `errorMessage` as a fallback revert reason when `target` reverts.
257      *
258      * _Available since v3.1._
259      */
260     function functionCall(
261         address target,
262         bytes memory data,
263         string memory errorMessage
264     ) internal returns (bytes memory) {
265         return functionCallWithValue(target, data, 0, errorMessage);
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
270      * but also transferring `value` wei to `target`.
271      *
272      * Requirements:
273      *
274      * - the calling contract must have an ETH balance of at least `value`.
275      * - the called Solidity function must be `payable`.
276      *
277      * _Available since v3.1._
278      */
279     function functionCallWithValue(
280         address target,
281         bytes memory data,
282         uint256 value
283     ) internal returns (bytes memory) {
284         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
289      * with `errorMessage` as a fallback revert reason when `target` reverts.
290      *
291      * _Available since v3.1._
292      */
293     function functionCallWithValue(
294         address target,
295         bytes memory data,
296         uint256 value,
297         string memory errorMessage
298     ) internal returns (bytes memory) {
299         require(address(this).balance >= value, "Address: insufficient balance for call");
300         require(isContract(target), "Address: call to non-contract");
301 
302         (bool success, bytes memory returndata) = target.call{value: value}(data);
303         return verifyCallResult(success, returndata, errorMessage);
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
308      * but performing a static call.
309      *
310      * _Available since v3.3._
311      */
312     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
313         return functionStaticCall(target, data, "Address: low-level static call failed");
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
318      * but performing a static call.
319      *
320      * _Available since v3.3._
321      */
322     function functionStaticCall(
323         address target,
324         bytes memory data,
325         string memory errorMessage
326     ) internal view returns (bytes memory) {
327         require(isContract(target), "Address: static call to non-contract");
328 
329         (bool success, bytes memory returndata) = target.staticcall(data);
330         return verifyCallResult(success, returndata, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but performing a delegate call.
336      *
337      * _Available since v3.4._
338      */
339     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
340         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
345      * but performing a delegate call.
346      *
347      * _Available since v3.4._
348      */
349     function functionDelegateCall(
350         address target,
351         bytes memory data,
352         string memory errorMessage
353     ) internal returns (bytes memory) {
354         require(isContract(target), "Address: delegate call to non-contract");
355 
356         (bool success, bytes memory returndata) = target.delegatecall(data);
357         return verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
362      * revert reason using the provided one.
363      *
364      * _Available since v4.3._
365      */
366     function verifyCallResult(
367         bool success,
368         bytes memory returndata,
369         string memory errorMessage
370     ) internal pure returns (bytes memory) {
371         if (success) {
372             return returndata;
373         } else {
374             // Look for revert reason and bubble it up if present
375             if (returndata.length > 0) {
376                 // The easiest way to bubble the revert reason is using memory via assembly
377 
378                 assembly {
379                     let returndata_size := mload(returndata)
380                     revert(add(32, returndata), returndata_size)
381                 }
382             } else {
383                 revert(errorMessage);
384             }
385         }
386     }
387 }
388 
389 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
390 /**
391  * @title SafeERC20
392  * @dev Wrappers around ERC20 operations that throw on failure (when the token
393  * contract returns false). Tokens that return no value (and instead revert or
394  * throw on failure) are also supported, non-reverting calls are assumed to be
395  * successful.
396  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
397  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
398  */
399 library SafeERC20 {
400     using Address for address;
401 
402     function safeTransfer(
403         IERC20 token,
404         address to,
405         uint256 value
406     ) internal {
407         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
408     }
409 
410     function safeTransferFrom(
411         IERC20 token,
412         address from,
413         address to,
414         uint256 value
415     ) internal {
416         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
417     }
418 
419     /**
420      * @dev Deprecated. This function has issues similar to the ones found in
421      * {IERC20-approve}, and its usage is discouraged.
422      *
423      * Whenever possible, use {safeIncreaseAllowance} and
424      * {safeDecreaseAllowance} instead.
425      */
426     function safeApprove(
427         IERC20 token,
428         address spender,
429         uint256 value
430     ) internal {
431         // safeApprove should only be called when setting an initial allowance,
432         // or when resetting it to zero. To increase and decrease it, use
433         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
434         require(
435             (value == 0) || (token.allowance(address(this), spender) == 0),
436             "SafeERC20: approve from non-zero to non-zero allowance"
437         );
438         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
439     }
440 
441     function safeIncreaseAllowance(
442         IERC20 token,
443         address spender,
444         uint256 value
445     ) internal {
446         uint256 newAllowance = token.allowance(address(this), spender) + value;
447         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
448     }
449 
450     function safeDecreaseAllowance(
451         IERC20 token,
452         address spender,
453         uint256 value
454     ) internal {
455         unchecked {
456             uint256 oldAllowance = token.allowance(address(this), spender);
457             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
458             uint256 newAllowance = oldAllowance - value;
459             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
460         }
461     }
462 
463     /**
464      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
465      * on the return value: the return value is optional (but if data is returned, it must not be false).
466      * @param token The token targeted by the call.
467      * @param data The call data (encoded using abi.encode or one of its variants).
468      */
469     function _callOptionalReturn(IERC20 token, bytes memory data) private {
470         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
471         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
472         // the target address contains contract code and also asserts for success in the low-level call.
473 
474         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
475         if (returndata.length > 0) {
476             // Return data is optional
477             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
478         }
479     }
480 }
481 
482 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
483 /**
484  * @dev Interface of the ERC165 standard, as defined in the
485  * https://eips.ethereum.org/EIPS/eip-165[EIP].
486  *
487  * Implementers can declare support of contract interfaces, which can then be
488  * queried by others ({ERC165Checker}).
489  *
490  * For an implementation, see {ERC165}.
491  */
492 interface IERC165 {
493     /**
494      * @dev Returns true if this contract implements the interface defined by
495      * `interfaceId`. See the corresponding
496      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
497      * to learn more about how these ids are created.
498      *
499      * This function call must use less than 30 000 gas.
500      */
501     function supportsInterface(bytes4 interfaceId) external view returns (bool);
502 }
503 
504 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
505 /**
506  * @dev Required interface of an ERC1155 compliant contract, as defined in the
507  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
508  *
509  * _Available since v3.1._
510  */
511 interface IERC1155 is IERC165 {
512     /**
513      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
514      */
515     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
516 
517     /**
518      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
519      * transfers.
520      */
521     event TransferBatch(
522         address indexed operator,
523         address indexed from,
524         address indexed to,
525         uint256[] ids,
526         uint256[] values
527     );
528 
529     /**
530      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
531      * `approved`.
532      */
533     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
534 
535     /**
536      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
537      *
538      * If an {URI} event was emitted for `id`, the standard
539      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
540      * returned by {IERC1155MetadataURI-uri}.
541      */
542     event URI(string value, uint256 indexed id);
543 
544     /**
545      * @dev Returns the amount of tokens of token type `id` owned by `account`.
546      *
547      * Requirements:
548      *
549      * - `account` cannot be the zero address.
550      */
551     function balanceOf(address account, uint256 id) external view returns (uint256);
552 
553     /**
554      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
555      *
556      * Requirements:
557      *
558      * - `accounts` and `ids` must have the same length.
559      */
560     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
561         external
562         view
563         returns (uint256[] memory);
564 
565     /**
566      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
567      *
568      * Emits an {ApprovalForAll} event.
569      *
570      * Requirements:
571      *
572      * - `operator` cannot be the caller.
573      */
574     function setApprovalForAll(address operator, bool approved) external;
575 
576     /**
577      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
578      *
579      * See {setApprovalForAll}.
580      */
581     function isApprovedForAll(address account, address operator) external view returns (bool);
582 
583     /**
584      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
585      *
586      * Emits a {TransferSingle} event.
587      *
588      * Requirements:
589      *
590      * - `to` cannot be the zero address.
591      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
592      * - `from` must have a balance of tokens of type `id` of at least `amount`.
593      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
594      * acceptance magic value.
595      */
596     function safeTransferFrom(
597         address from,
598         address to,
599         uint256 id,
600         uint256 amount,
601         bytes calldata data
602     ) external;
603 
604     /**
605      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
606      *
607      * Emits a {TransferBatch} event.
608      *
609      * Requirements:
610      *
611      * - `ids` and `amounts` must have the same length.
612      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
613      * acceptance magic value.
614      */
615     function safeBatchTransferFrom(
616         address from,
617         address to,
618         uint256[] calldata ids,
619         uint256[] calldata amounts,
620         bytes calldata data
621     ) external;
622 }
623 
624 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155Receiver.sol)
625 /**
626  * @dev _Available since v3.1._
627  */
628 interface IERC1155Receiver is IERC165 {
629     /**
630         @dev Handles the receipt of a single ERC1155 token type. This function is
631         called at the end of a `safeTransferFrom` after the balance has been updated.
632         To accept the transfer, this must return
633         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
634         (i.e. 0xf23a6e61, or its own function selector).
635         @param operator The address which initiated the transfer (i.e. msg.sender)
636         @param from The address which previously owned the token
637         @param id The ID of the token being transferred
638         @param value The amount of tokens being transferred
639         @param data Additional data with no specified format
640         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
641     */
642     function onERC1155Received(
643         address operator,
644         address from,
645         uint256 id,
646         uint256 value,
647         bytes calldata data
648     ) external returns (bytes4);
649 
650     /**
651         @dev Handles the receipt of a multiple ERC1155 token types. This function
652         is called at the end of a `safeBatchTransferFrom` after the balances have
653         been updated. To accept the transfer(s), this must return
654         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
655         (i.e. 0xbc197c81, or its own function selector).
656         @param operator The address which initiated the batch transfer (i.e. msg.sender)
657         @param from The address which previously owned the token
658         @param ids An array containing ids of each token being transferred (order and length must match values array)
659         @param values An array containing amounts of each token being transferred (order and length must match ids array)
660         @param data Additional data with no specified format
661         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
662     */
663     function onERC1155BatchReceived(
664         address operator,
665         address from,
666         uint256[] calldata ids,
667         uint256[] calldata values,
668         bytes calldata data
669     ) external returns (bytes4);
670 }
671 
672 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
673 /**
674  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
675  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
676  *
677  * _Available since v3.1._
678  */
679 interface IERC1155MetadataURI is IERC1155 {
680     /**
681      * @dev Returns the URI for token type `id`.
682      *
683      * If the `\{id\}` substring is present in the URI, it must be replaced by
684      * clients with the actual token type ID.
685      */
686     function uri(uint256 id) external view returns (string memory);
687 }
688 
689 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
690 /**
691  * @dev Implementation of the {IERC165} interface.
692  *
693  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
694  * for the additional interface id that will be supported. For example:
695  *
696  * ```solidity
697  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
698  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
699  * }
700  * ```
701  *
702  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
703  */
704 abstract contract ERC165 is IERC165 {
705     /**
706      * @dev See {IERC165-supportsInterface}.
707      */
708     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
709         return interfaceId == type(IERC165).interfaceId;
710     }
711 }
712 
713 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
714 /**
715  * @dev Implementation of the basic standard multi-token.
716  * See https://eips.ethereum.org/EIPS/eip-1155
717  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
718  *
719  * _Available since v3.1._
720  */
721 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
722     using Address for address;
723 
724     // Mapping from token ID to account balances
725     mapping(uint256 => mapping(address => uint256)) private _balances;
726 
727     // Mapping from account to operator approvals
728     mapping(address => mapping(address => bool)) private _operatorApprovals;
729 
730     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
731     string private _uri;
732 
733     /**
734      * @dev See {_setURI}.
735      */
736     constructor(string memory uri_) {
737         _setURI(uri_);
738     }
739 
740     /**
741      * @dev See {IERC165-supportsInterface}.
742      */
743     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
744         return
745             interfaceId == type(IERC1155).interfaceId ||
746             interfaceId == type(IERC1155MetadataURI).interfaceId ||
747             super.supportsInterface(interfaceId);
748     }
749 
750     /**
751      * @dev See {IERC1155MetadataURI-uri}.
752      *
753      * This implementation returns the same URI for *all* token types. It relies
754      * on the token type ID substitution mechanism
755      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
756      *
757      * Clients calling this function must replace the `\{id\}` substring with the
758      * actual token type ID.
759      */
760     function uri(uint256) public view virtual override returns (string memory) {
761         return _uri;
762     }
763 
764     /**
765      * @dev See {IERC1155-balanceOf}.
766      *
767      * Requirements:
768      *
769      * - `account` cannot be the zero address.
770      */
771     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
772         require(account != address(0), "ERC1155: balance query for the zero address");
773         return _balances[id][account];
774     }
775 
776     /**
777      * @dev See {IERC1155-balanceOfBatch}.
778      *
779      * Requirements:
780      *
781      * - `accounts` and `ids` must have the same length.
782      */
783     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
784         public
785         view
786         virtual
787         override
788         returns (uint256[] memory)
789     {
790         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
791 
792         uint256[] memory batchBalances = new uint256[](accounts.length);
793 
794         for (uint256 i = 0; i < accounts.length; ++i) {
795             batchBalances[i] = balanceOf(accounts[i], ids[i]);
796         }
797 
798         return batchBalances;
799     }
800 
801     /**
802      * @dev See {IERC1155-setApprovalForAll}.
803      */
804     function setApprovalForAll(address operator, bool approved) public virtual override {
805         _setApprovalForAll(_msgSender(), operator, approved);
806     }
807 
808     /**
809      * @dev See {IERC1155-isApprovedForAll}.
810      */
811     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
812         return _operatorApprovals[account][operator];
813     }
814 
815     /**
816      * @dev See {IERC1155-safeTransferFrom}.
817      */
818     function safeTransferFrom(
819         address from,
820         address to,
821         uint256 id,
822         uint256 amount,
823         bytes memory data
824     ) public virtual override {
825         require(
826             from == _msgSender() || isApprovedForAll(from, _msgSender()),
827             "ERC1155: caller is not owner nor approved"
828         );
829         _safeTransferFrom(from, to, id, amount, data);
830     }
831 
832     /**
833      * @dev See {IERC1155-safeBatchTransferFrom}.
834      */
835     function safeBatchTransferFrom(
836         address from,
837         address to,
838         uint256[] memory ids,
839         uint256[] memory amounts,
840         bytes memory data
841     ) public virtual override {
842         require(
843             from == _msgSender() || isApprovedForAll(from, _msgSender()),
844             "ERC1155: transfer caller is not owner nor approved"
845         );
846         _safeBatchTransferFrom(from, to, ids, amounts, data);
847     }
848 
849     /**
850      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
851      *
852      * Emits a {TransferSingle} event.
853      *
854      * Requirements:
855      *
856      * - `to` cannot be the zero address.
857      * - `from` must have a balance of tokens of type `id` of at least `amount`.
858      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
859      * acceptance magic value.
860      */
861     function _safeTransferFrom(
862         address from,
863         address to,
864         uint256 id,
865         uint256 amount,
866         bytes memory data
867     ) internal virtual {
868         require(to != address(0), "ERC1155: transfer to the zero address");
869 
870         address operator = _msgSender();
871 
872         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
873 
874         uint256 fromBalance = _balances[id][from];
875         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
876         unchecked {
877             _balances[id][from] = fromBalance - amount;
878         }
879         _balances[id][to] += amount;
880 
881         emit TransferSingle(operator, from, to, id, amount);
882 
883         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
884     }
885 
886     /**
887      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
888      *
889      * Emits a {TransferBatch} event.
890      *
891      * Requirements:
892      *
893      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
894      * acceptance magic value.
895      */
896     function _safeBatchTransferFrom(
897         address from,
898         address to,
899         uint256[] memory ids,
900         uint256[] memory amounts,
901         bytes memory data
902     ) internal virtual {
903         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
904         require(to != address(0), "ERC1155: transfer to the zero address");
905 
906         address operator = _msgSender();
907 
908         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
909 
910         for (uint256 i = 0; i < ids.length; ++i) {
911             uint256 id = ids[i];
912             uint256 amount = amounts[i];
913 
914             uint256 fromBalance = _balances[id][from];
915             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
916             unchecked {
917                 _balances[id][from] = fromBalance - amount;
918             }
919             _balances[id][to] += amount;
920         }
921 
922         emit TransferBatch(operator, from, to, ids, amounts);
923 
924         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
925     }
926 
927     /**
928      * @dev Sets a new URI for all token types, by relying on the token type ID
929      * substitution mechanism
930      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
931      *
932      * By this mechanism, any occurrence of the `\{id\}` substring in either the
933      * URI or any of the amounts in the JSON file at said URI will be replaced by
934      * clients with the token type ID.
935      *
936      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
937      * interpreted by clients as
938      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
939      * for token type ID 0x4cce0.
940      *
941      * See {uri}.
942      *
943      * Because these URIs cannot be meaningfully represented by the {URI} event,
944      * this function emits no events.
945      */
946     function _setURI(string memory newuri) internal virtual {
947         _uri = newuri;
948     }
949 
950     /**
951      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
952      *
953      * Emits a {TransferSingle} event.
954      *
955      * Requirements:
956      *
957      * - `to` cannot be the zero address.
958      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
959      * acceptance magic value.
960      */
961     function _mint(
962         address to,
963         uint256 id,
964         uint256 amount,
965         bytes memory data
966     ) internal virtual {
967         require(to != address(0), "ERC1155: mint to the zero address");
968 
969         address operator = _msgSender();
970 
971         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
972 
973         _balances[id][to] += amount;
974         emit TransferSingle(operator, address(0), to, id, amount);
975 
976         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
977     }
978 
979     /**
980      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
981      *
982      * Requirements:
983      *
984      * - `ids` and `amounts` must have the same length.
985      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
986      * acceptance magic value.
987      */
988     function _mintBatch(
989         address to,
990         uint256[] memory ids,
991         uint256[] memory amounts,
992         bytes memory data
993     ) internal virtual {
994         require(to != address(0), "ERC1155: mint to the zero address");
995         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
996 
997         address operator = _msgSender();
998 
999         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1000 
1001         for (uint256 i = 0; i < ids.length; i++) {
1002             _balances[ids[i]][to] += amounts[i];
1003         }
1004 
1005         emit TransferBatch(operator, address(0), to, ids, amounts);
1006 
1007         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1008     }
1009 
1010     /**
1011      * @dev Destroys `amount` tokens of token type `id` from `from`
1012      *
1013      * Requirements:
1014      *
1015      * - `from` cannot be the zero address.
1016      * - `from` must have at least `amount` tokens of token type `id`.
1017      */
1018     function _burn(
1019         address from,
1020         uint256 id,
1021         uint256 amount
1022     ) internal virtual {
1023         require(from != address(0), "ERC1155: burn from the zero address");
1024 
1025         address operator = _msgSender();
1026 
1027         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1028 
1029         uint256 fromBalance = _balances[id][from];
1030         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1031         unchecked {
1032             _balances[id][from] = fromBalance - amount;
1033         }
1034 
1035         emit TransferSingle(operator, from, address(0), id, amount);
1036     }
1037 
1038     /**
1039      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1040      *
1041      * Requirements:
1042      *
1043      * - `ids` and `amounts` must have the same length.
1044      */
1045     function _burnBatch(
1046         address from,
1047         uint256[] memory ids,
1048         uint256[] memory amounts
1049     ) internal virtual {
1050         require(from != address(0), "ERC1155: burn from the zero address");
1051         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1052 
1053         address operator = _msgSender();
1054 
1055         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1056 
1057         for (uint256 i = 0; i < ids.length; i++) {
1058             uint256 id = ids[i];
1059             uint256 amount = amounts[i];
1060 
1061             uint256 fromBalance = _balances[id][from];
1062             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1063             unchecked {
1064                 _balances[id][from] = fromBalance - amount;
1065             }
1066         }
1067 
1068         emit TransferBatch(operator, from, address(0), ids, amounts);
1069     }
1070 
1071     /**
1072      * @dev Approve `operator` to operate on all of `owner` tokens
1073      *
1074      * Emits a {ApprovalForAll} event.
1075      */
1076     function _setApprovalForAll(
1077         address owner,
1078         address operator,
1079         bool approved
1080     ) internal virtual {
1081         require(owner != operator, "ERC1155: setting approval status for self");
1082         _operatorApprovals[owner][operator] = approved;
1083         emit ApprovalForAll(owner, operator, approved);
1084     }
1085 
1086     /**
1087      * @dev Hook that is called before any token transfer. This includes minting
1088      * and burning, as well as batched variants.
1089      *
1090      * The same hook is called on both single and batched variants. For single
1091      * transfers, the length of the `id` and `amount` arrays will be 1.
1092      *
1093      * Calling conditions (for each `id` and `amount` pair):
1094      *
1095      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1096      * of token type `id` will be  transferred to `to`.
1097      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1098      * for `to`.
1099      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1100      * will be burned.
1101      * - `from` and `to` are never both zero.
1102      * - `ids` and `amounts` have the same, non-zero length.
1103      *
1104      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1105      */
1106     function _beforeTokenTransfer(
1107         address operator,
1108         address from,
1109         address to,
1110         uint256[] memory ids,
1111         uint256[] memory amounts,
1112         bytes memory data
1113     ) internal virtual {}
1114 
1115     function _doSafeTransferAcceptanceCheck(
1116         address operator,
1117         address from,
1118         address to,
1119         uint256 id,
1120         uint256 amount,
1121         bytes memory data
1122     ) private {
1123         if (to.isContract()) {
1124             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1125                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1126                     revert("ERC1155: ERC1155Receiver rejected tokens");
1127                 }
1128             } catch Error(string memory reason) {
1129                 revert(reason);
1130             } catch {
1131                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1132             }
1133         }
1134     }
1135 
1136     function _doSafeBatchTransferAcceptanceCheck(
1137         address operator,
1138         address from,
1139         address to,
1140         uint256[] memory ids,
1141         uint256[] memory amounts,
1142         bytes memory data
1143     ) private {
1144         if (to.isContract()) {
1145             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1146                 bytes4 response
1147             ) {
1148                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1149                     revert("ERC1155: ERC1155Receiver rejected tokens");
1150                 }
1151             } catch Error(string memory reason) {
1152                 revert(reason);
1153             } catch {
1154                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1155             }
1156         }
1157     }
1158 
1159     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1160         uint256[] memory array = new uint256[](1);
1161         array[0] = element;
1162 
1163         return array;
1164     }
1165 }
1166 
1167 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1168 /**
1169  * @dev String operations.
1170  */
1171 library Strings {
1172     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1173 
1174     /**
1175      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1176      */
1177     function toString(uint256 value) internal pure returns (string memory) {
1178         // Inspired by OraclizeAPI's implementation - MIT licence
1179         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1180 
1181         if (value == 0) {
1182             return "0";
1183         }
1184         uint256 temp = value;
1185         uint256 digits;
1186         while (temp != 0) {
1187             digits++;
1188             temp /= 10;
1189         }
1190         bytes memory buffer = new bytes(digits);
1191         while (value != 0) {
1192             digits -= 1;
1193             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1194             value /= 10;
1195         }
1196         return string(buffer);
1197     }
1198 
1199     /**
1200      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1201      */
1202     function toHexString(uint256 value) internal pure returns (string memory) {
1203         if (value == 0) {
1204             return "0x00";
1205         }
1206         uint256 temp = value;
1207         uint256 length = 0;
1208         while (temp != 0) {
1209             length++;
1210             temp >>= 8;
1211         }
1212         return toHexString(value, length);
1213     }
1214 
1215     /**
1216      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1217      */
1218     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1219         bytes memory buffer = new bytes(2 * length + 2);
1220         buffer[0] = "0";
1221         buffer[1] = "x";
1222         for (uint256 i = 2 * length + 1; i > 1; --i) {
1223             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1224             value >>= 4;
1225         }
1226         require(value == 0, "Strings: hex length insufficient");
1227         return string(buffer);
1228     }
1229 }
1230 
1231 // Abstract, as without permission system
1232 abstract contract AbsERC1155 is ERC1155 {
1233     string public baseURI;
1234     mapping(uint256 => uint256) public maxSupply;
1235     mapping(uint256 => uint256) public currentSupply;
1236 
1237     constructor(string memory baseURIParam) ERC1155("") {
1238         _setBaseURI(baseURIParam);
1239     }
1240 
1241     function uri(uint256 tokenId) public view virtual override returns (string memory) {
1242         require(isCreated(tokenId), "BaseERC1155: URI query for nonexistent token");
1243         return string(abi.encodePacked(baseURI, Strings.toString(tokenId), ".json"));
1244     }
1245 
1246     // be careful when overriding as this is used in the _create function
1247     function isCreated(uint256 tokenId) public view virtual returns (bool) {
1248         return maxSupply[tokenId] != 0;
1249     }
1250 
1251     // Internal function to create a token
1252     function _create(
1253         uint256 tokenId,
1254         uint256 initialSupply,
1255         uint256 maxSupply_
1256     ) internal {
1257         require(maxSupply_ != 0, "BaseERC1155: maxSupply cannot be 0");
1258         require(!isCreated(tokenId), "BaseERC1155: token already created");
1259         require(initialSupply <= maxSupply_, "BaseERC1155: initial supply cannot exceed max");
1260         maxSupply[tokenId] = maxSupply_;
1261         if (initialSupply > 0) {
1262             _mint(msg.sender, tokenId, initialSupply, hex"");
1263         }
1264     }
1265 
1266     // To be overridden with permissioning
1267     function setBaseURI(string memory baseURIParam) external virtual;
1268 
1269     // Internal function to create a token
1270     function _setBaseURI(string memory baseURIParam) internal {
1271         baseURI = baseURIParam;
1272     }
1273 
1274     function _mint(
1275         address account,
1276         uint256 id,
1277         uint256 amount,
1278         bytes memory data
1279     ) internal virtual override {
1280         require(amount != 0, "Zero amount");
1281         require(currentSupply[id] + amount <= maxSupply[id], "Max supply");
1282         currentSupply[id] += amount;
1283         super._mint(account, id, amount, data);
1284     }
1285 
1286     function _mintBatch(
1287         address to,
1288         uint256[] memory ids,
1289         uint256[] memory amounts,
1290         bytes memory data
1291     ) internal virtual override {
1292         require(ids.length == amounts.length, "Array length");
1293         require(ids.length != 0, "Zero values");
1294 
1295         for (uint256 i = 0; i < ids.length; i++) {
1296             require(amounts[i] != 0, "Zero amount");
1297             uint256 tokenId = ids[i];
1298             require(currentSupply[tokenId] + amounts[i] <= maxSupply[tokenId], "Max supply");
1299             currentSupply[tokenId] += amounts[i];
1300         }
1301         super._mintBatch(to, ids, amounts, data);
1302     }
1303 }
1304 
1305 /**
1306  * ERC1155 implementation that allows admin minting with a max supply
1307  */
1308 contract TreumERC1155 is AbsERC1155, Ownable {
1309     using SafeERC20 for IERC20;
1310 
1311     struct PublicMintData {
1312         address erc20Address;
1313         uint256 mintPrice;
1314         bool enabled;
1315     }
1316 
1317     mapping(uint256 => PublicMintData) public tokenMintPrices;
1318     mapping(uint256 => string) private tokenURIs;
1319 
1320     constructor() AbsERC1155("") {}
1321 
1322     function setBaseURI(string memory baseURI) external virtual override onlyOwner {
1323         _setBaseURI(baseURI);
1324     }
1325 
1326     /**
1327      * @dev Create an ERC1155 token, with a max supply
1328      * @dev The contract owner can mint tokens on demand up to the max supply
1329      */
1330     function createForAdminMint(
1331         uint256 tokenId,
1332         uint256 initialSupply,
1333         uint256 maxSupply,
1334         string memory uri
1335     ) external onlyOwner {
1336         tokenURIs[tokenId] = uri;
1337 
1338         // Create ERC1155 token with specified supplies
1339         _create(tokenId, initialSupply, maxSupply);
1340     }
1341 
1342     /**
1343      * @dev Mints an amount of ERC1155 tokens to an address
1344      */
1345     function adminMint(
1346         uint256 tokenId,
1347         uint256 amount,
1348         address to
1349     ) external onlyOwner {
1350         _mint(to, tokenId, amount, hex"");
1351     }
1352 
1353     function uri(uint256 tokenId) public view override returns (string memory) {
1354         // we could revert for non existant ones
1355         return tokenURIs[tokenId];
1356     }
1357 
1358     /**
1359      * @dev Safety function to be able to recover tokens if they are sent to this contract by mistake
1360      */
1361     function withdrawTokensTo(address erc20Address, address recipient) external onlyOwner {
1362         uint256 tokenBalance = IERC20(erc20Address).balanceOf(address(this));
1363         require(tokenBalance > 0, "No tokens");
1364 
1365         IERC20(erc20Address).safeTransfer(recipient, tokenBalance);
1366     }
1367 }