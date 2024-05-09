1 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: contracts\standalone\IERC20NFTWrapper.sol
82 
83 // SPDX_License_Identifier: MIT
84 
85 pragma solidity ^0.6.0;
86 
87 
88 interface IERC20NFTWrapper is IERC20 {
89     function init(uint256 objectId) external;
90 
91     function mainWrapper() external view returns (address);
92 
93     function objectId() external view returns (uint256);
94 
95     function name() external view returns (string memory);
96 
97     function symbol() external view returns (string memory);
98 
99     function decimals() external view returns (uint256);
100 
101     function mint(address owner, uint256 amount) external;
102 
103     function burn(address owner, uint256 amount) external;
104 }
105 
106 // File: contracts\standalone\voting\IDFOERC20NFTWrapper.sol
107 
108 // SPDX_License_Identifier: MIT
109 
110 pragma solidity ^0.6.0;
111 
112 
113 interface IDFOERC20NFTWrapper is IERC20NFTWrapper {
114     function mint(uint256 amount) external;
115     function getProxy() external view returns (address);
116     function setProxy() external;
117 }
118 
119 interface IMVDFunctionalityProposalManager {
120     function isValidProposal(address proposal) external view returns (bool);
121 }
122 
123 // File: node_modules\@openzeppelin\contracts\introspection\IERC165.sol
124 
125 // SPDX_License_Identifier: MIT
126 
127 pragma solidity ^0.6.0;
128 
129 /**
130  * @dev Interface of the ERC165 standard, as defined in the
131  * https://eips.ethereum.org/EIPS/eip-165[EIP].
132  *
133  * Implementers can declare support of contract interfaces, which can then be
134  * queried by others ({ERC165Checker}).
135  *
136  * For an implementation, see {ERC165}.
137  */
138 interface IERC165 {
139     /**
140      * @dev Returns true if this contract implements the interface defined by
141      * `interfaceId`. See the corresponding
142      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
143      * to learn more about how these ids are created.
144      *
145      * This function call must use less than 30 000 gas.
146      */
147     function supportsInterface(bytes4 interfaceId) external view returns (bool);
148 }
149 
150 // File: @openzeppelin\contracts\token\ERC1155\IERC1155.sol
151 
152 // SPDX_License_Identifier: MIT
153 
154 pragma solidity ^0.6.2;
155 
156 
157 /**
158  * @dev Required interface of an ERC1155 compliant contract, as defined in the
159  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
160  *
161  * _Available since v3.1._
162  */
163 interface IERC1155 is IERC165 {
164     /**
165      * @dev Emitted when `value` tokens of token type `id` are transfered from `from` to `to` by `operator`.
166      */
167     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
168 
169     /**
170      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
171      * transfers.
172      */
173     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
174 
175     /**
176      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
177      * `approved`.
178      */
179     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
180 
181     /**
182      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
183      *
184      * If an {URI} event was emitted for `id`, the standard
185      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
186      * returned by {IERC1155MetadataURI-uri}.
187      */
188     event URI(string value, uint256 indexed id);
189 
190     /**
191      * @dev Returns the amount of tokens of token type `id` owned by `account`.
192      *
193      * Requirements:
194      *
195      * - `account` cannot be the zero address.
196      */
197     function balanceOf(address account, uint256 id) external view returns (uint256);
198 
199     /**
200      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
201      *
202      * Requirements:
203      *
204      * - `accounts` and `ids` must have the same length.
205      */
206     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
207 
208     /**
209      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
210      *
211      * Emits an {ApprovalForAll} event.
212      *
213      * Requirements:
214      *
215      * - `operator` cannot be the caller.
216      */
217     function setApprovalForAll(address operator, bool approved) external;
218 
219     /**
220      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
221      *
222      * See {setApprovalForAll}.
223      */
224     function isApprovedForAll(address account, address operator) external view returns (bool);
225 
226     /**
227      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
228      *
229      * Emits a {TransferSingle} event.
230      *
231      * Requirements:
232      *
233      * - `to` cannot be the zero address.
234      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
235      * - `from` must have a balance of tokens of type `id` of at least `amount`.
236      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
237      * acceptance magic value.
238      */
239     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
240 
241     /**
242      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
243      *
244      * Emits a {TransferBatch} event.
245      *
246      * Requirements:
247      *
248      * - `ids` and `amounts` must have the same length.
249      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
250      * acceptance magic value.
251      */
252     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
253 }
254 
255 // File: @openzeppelin\contracts\token\ERC1155\IERC1155Receiver.sol
256 
257 // SPDX_License_Identifier: MIT
258 
259 pragma solidity ^0.6.0;
260 
261 
262 /**
263  * _Available since v3.1._
264  */
265 interface IERC1155Receiver is IERC165 {
266 
267     /**
268         @dev Handles the receipt of a single ERC1155 token type. This function is
269         called at the end of a `safeTransferFrom` after the balance has been updated.
270         To accept the transfer, this must return
271         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
272         (i.e. 0xf23a6e61, or its own function selector).
273         @param operator The address which initiated the transfer (i.e. msg.sender)
274         @param from The address which previously owned the token
275         @param id The ID of the token being transferred
276         @param value The amount of tokens being transferred
277         @param data Additional data with no specified format
278         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
279     */
280     function onERC1155Received(
281         address operator,
282         address from,
283         uint256 id,
284         uint256 value,
285         bytes calldata data
286     )
287         external
288         returns(bytes4);
289 
290     /**
291         @dev Handles the receipt of a multiple ERC1155 token types. This function
292         is called at the end of a `safeBatchTransferFrom` after the balances have
293         been updated. To accept the transfer(s), this must return
294         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
295         (i.e. 0xbc197c81, or its own function selector).
296         @param operator The address which initiated the batch transfer (i.e. msg.sender)
297         @param from The address which previously owned the token
298         @param ids An array containing ids of each token being transferred (order and length must match values array)
299         @param values An array containing amounts of each token being transferred (order and length must match ids array)
300         @param data Additional data with no specified format
301         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
302     */
303     function onERC1155BatchReceived(
304         address operator,
305         address from,
306         uint256[] calldata ids,
307         uint256[] calldata values,
308         bytes calldata data
309     )
310         external
311         returns(bytes4);
312 }
313 
314 // File: contracts\standalone\IERC1155Views.sol
315 
316 // SPDX_License_Identifier: MIT
317 
318 pragma solidity ^0.6.0;
319 
320 /**
321  * @title IERC1155Views - An optional utility interface to improve the ERC-1155 Standard.
322  * @dev This interface introduces some additional capabilities for ERC-1155 Tokens.
323  */
324 interface IERC1155Views {
325 
326     /**
327      * @dev Returns the total supply of the given token id
328      * @param objectId the id of the token whose availability you want to know 
329      */
330     function totalSupply(uint256 objectId) external view returns (uint256);
331 
332     /**
333      * @dev Returns the name of the given token id
334      * @param objectId the id of the token whose name you want to know 
335      */
336     function name(uint256 objectId) external view returns (string memory);
337 
338     /**
339      * @dev Returns the symbol of the given token id
340      * @param objectId the id of the token whose symbol you want to know 
341      */
342     function symbol(uint256 objectId) external view returns (string memory);
343 
344     /**
345      * @dev Returns the decimals of the given token id
346      * @param objectId the id of the token whose decimals you want to know 
347      */
348     function decimals(uint256 objectId) external view returns (uint256);
349 
350     /**
351      * @dev Returns the uri of the given token id
352      * @param objectId the id of the token whose uri you want to know 
353      */
354     function uri(uint256 objectId) external view returns (string memory);
355 }
356 
357 // File: contracts\standalone\IERC1155Data.sol
358 
359 // SPDX_License_Identifier: MIT
360 
361 pragma solidity ^0.6.0;
362 
363 interface IERC1155Data {
364     function name() external view returns (string memory);
365 
366     function symbol() external view returns (string memory);
367 }
368 
369 // File: contracts\standalone\ISuperSaiyanToken.sol
370 
371 // SPDX_License_Identifier: MIT
372 
373 pragma solidity ^0.6.0;
374 
375 
376 
377 
378 
379 
380 interface ISuperSaiyanToken is IERC1155, IERC1155Receiver, IERC1155Views, IERC1155Data {
381     function init(
382         address model,
383         address source,
384         string calldata name,
385         string calldata symbol
386     ) external;
387 
388     function fromDecimals(uint256 objectId, uint256 amount)
389         external
390         view
391         returns (uint256);
392 
393     function toDecimals(uint256 objectId, uint256 amount)
394         external
395         view
396         returns (uint256);
397 
398     function getMintData(uint256 objectId)
399         external
400         view
401         returns (
402             string memory,
403             string memory,
404             uint256
405         );
406 
407     function getModel() external view returns (address);
408 
409     function source() external view returns (address);
410 
411     function asERC20(uint256 objectId) external view returns (IERC20NFTWrapper);
412 
413     function emitTransferSingleEvent(address sender, address from, address to, uint256 objectId, uint256 amount) external;
414 
415     function mint(uint256 amount, string calldata partialUri)
416         external
417         returns (uint256, address);
418 
419     function burn(
420         uint256 objectId,
421         uint256 amount,
422         bytes calldata data
423     ) external;
424 
425     function burnBatch(
426         uint256[] calldata objectIds,
427         uint256[] calldata amounts,
428         bytes calldata data
429     ) external;
430 
431     event Mint(uint256 objectId, address tokenAddress);
432 }
433 
434 // File: contracts\standalone\voting\IDFOSuperSaiyanToken.sol
435 
436 // SPDX_License_Identifier: MIT
437 
438 pragma solidity ^0.6.0;
439 
440 
441 interface IDFOSuperSaiyanToken is ISuperSaiyanToken {
442 
443     function doubleProxy() external view returns(address);
444     function setDoubleProxy(address newDoubleProxy) external;
445     function setUri(uint256 objectId, string calldata uri) external;
446 
447     event UriChanged(uint256 indexed objectId, string oldUri, string newUri);
448 }
449 
450 interface IDoubleProxy {
451     function proxy() external view returns(address);
452 }
453 
454 interface IMVDProxy {
455     function getToken() external view returns(address);
456     function getStateHolderAddress() external view returns(address);
457     function getMVDWalletAddress() external view returns(address);
458     function getMVDFunctionalitiesManagerAddress() external view returns(address);
459     function getMVDFunctionalityProposalManagerAddress() external view returns(address);
460     function submit(string calldata codeName, bytes calldata data) external payable returns(bytes memory returnData);
461 }
462 
463 interface IStateHolder {
464     function setUint256(string calldata name, uint256 value) external returns(uint256);
465     function getUint256(string calldata name) external view returns(uint256);
466     function getBool(string calldata varName) external view returns (bool);
467     function clear(string calldata varName) external returns(string memory oldDataType, bytes memory oldVal);
468 }
469 
470 interface IMVDFunctionalitiesManager {
471     function isAuthorizedFunctionality(address functionality) external view returns(bool);
472 }
473 
474 // File: @openzeppelin\contracts\GSN\Context.sol
475 
476 // SPDX_License_Identifier: MIT
477 
478 pragma solidity ^0.6.0;
479 
480 /*
481  * @dev Provides information about the current execution context, including the
482  * sender of the transaction and its data. While these are generally available
483  * via msg.sender and msg.data, they should not be accessed in such a direct
484  * manner, since when dealing with GSN meta-transactions the account sending and
485  * paying for execution may not be the actual sender (as far as an application
486  * is concerned).
487  *
488  * This contract is only required for intermediate, library-like contracts.
489  */
490 abstract contract Context {
491     function _msgSender() internal view virtual returns (address payable) {
492         return msg.sender;
493     }
494 
495     function _msgData() internal view virtual returns (bytes memory) {
496         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
497         return msg.data;
498     }
499 }
500 
501 // File: @openzeppelin\contracts\math\SafeMath.sol
502 
503 // SPDX_License_Identifier: MIT
504 
505 pragma solidity ^0.6.0;
506 
507 /**
508  * @dev Wrappers over Solidity's arithmetic operations with added overflow
509  * checks.
510  *
511  * Arithmetic operations in Solidity wrap on overflow. This can easily result
512  * in bugs, because programmers usually assume that an overflow raises an
513  * error, which is the standard behavior in high level programming languages.
514  * `SafeMath` restores this intuition by reverting the transaction when an
515  * operation overflows.
516  *
517  * Using this library instead of the unchecked operations eliminates an entire
518  * class of bugs, so it's recommended to use it always.
519  */
520 library SafeMath {
521     /**
522      * @dev Returns the addition of two unsigned integers, reverting on
523      * overflow.
524      *
525      * Counterpart to Solidity's `+` operator.
526      *
527      * Requirements:
528      *
529      * - Addition cannot overflow.
530      */
531     function add(uint256 a, uint256 b) internal pure returns (uint256) {
532         uint256 c = a + b;
533         require(c >= a, "SafeMath: addition overflow");
534 
535         return c;
536     }
537 
538     /**
539      * @dev Returns the subtraction of two unsigned integers, reverting on
540      * overflow (when the result is negative).
541      *
542      * Counterpart to Solidity's `-` operator.
543      *
544      * Requirements:
545      *
546      * - Subtraction cannot overflow.
547      */
548     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
549         return sub(a, b, "SafeMath: subtraction overflow");
550     }
551 
552     /**
553      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
554      * overflow (when the result is negative).
555      *
556      * Counterpart to Solidity's `-` operator.
557      *
558      * Requirements:
559      *
560      * - Subtraction cannot overflow.
561      */
562     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
563         require(b <= a, errorMessage);
564         uint256 c = a - b;
565 
566         return c;
567     }
568 
569     /**
570      * @dev Returns the multiplication of two unsigned integers, reverting on
571      * overflow.
572      *
573      * Counterpart to Solidity's `*` operator.
574      *
575      * Requirements:
576      *
577      * - Multiplication cannot overflow.
578      */
579     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
580         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
581         // benefit is lost if 'b' is also tested.
582         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
583         if (a == 0) {
584             return 0;
585         }
586 
587         uint256 c = a * b;
588         require(c / a == b, "SafeMath: multiplication overflow");
589 
590         return c;
591     }
592 
593     /**
594      * @dev Returns the integer division of two unsigned integers. Reverts on
595      * division by zero. The result is rounded towards zero.
596      *
597      * Counterpart to Solidity's `/` operator. Note: this function uses a
598      * `revert` opcode (which leaves remaining gas untouched) while Solidity
599      * uses an invalid opcode to revert (consuming all remaining gas).
600      *
601      * Requirements:
602      *
603      * - The divisor cannot be zero.
604      */
605     function div(uint256 a, uint256 b) internal pure returns (uint256) {
606         return div(a, b, "SafeMath: division by zero");
607     }
608 
609     /**
610      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
611      * division by zero. The result is rounded towards zero.
612      *
613      * Counterpart to Solidity's `/` operator. Note: this function uses a
614      * `revert` opcode (which leaves remaining gas untouched) while Solidity
615      * uses an invalid opcode to revert (consuming all remaining gas).
616      *
617      * Requirements:
618      *
619      * - The divisor cannot be zero.
620      */
621     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
622         require(b > 0, errorMessage);
623         uint256 c = a / b;
624         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
625 
626         return c;
627     }
628 
629     /**
630      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
631      * Reverts when dividing by zero.
632      *
633      * Counterpart to Solidity's `%` operator. This function uses a `revert`
634      * opcode (which leaves remaining gas untouched) while Solidity uses an
635      * invalid opcode to revert (consuming all remaining gas).
636      *
637      * Requirements:
638      *
639      * - The divisor cannot be zero.
640      */
641     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
642         return mod(a, b, "SafeMath: modulo by zero");
643     }
644 
645     /**
646      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
647      * Reverts with custom message when dividing by zero.
648      *
649      * Counterpart to Solidity's `%` operator. This function uses a `revert`
650      * opcode (which leaves remaining gas untouched) while Solidity uses an
651      * invalid opcode to revert (consuming all remaining gas).
652      *
653      * Requirements:
654      *
655      * - The divisor cannot be zero.
656      */
657     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
658         require(b != 0, errorMessage);
659         return a % b;
660     }
661 }
662 
663 // File: @openzeppelin\contracts\utils\Address.sol
664 
665 // SPDX_License_Identifier: MIT
666 
667 pragma solidity ^0.6.2;
668 
669 /**
670  * @dev Collection of functions related to the address type
671  */
672 library Address {
673     /**
674      * @dev Returns true if `account` is a contract.
675      *
676      * [IMPORTANT]
677      * ====
678      * It is unsafe to assume that an address for which this function returns
679      * false is an externally-owned account (EOA) and not a contract.
680      *
681      * Among others, `isContract` will return false for the following
682      * types of addresses:
683      *
684      *  - an externally-owned account
685      *  - a contract in construction
686      *  - an address where a contract will be created
687      *  - an address where a contract lived, but was destroyed
688      * ====
689      */
690     function isContract(address account) internal view returns (bool) {
691         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
692         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
693         // for accounts without code, i.e. `keccak256('')`
694         bytes32 codehash;
695         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
696         // solhint-disable-next-line no-inline-assembly
697         assembly { codehash := extcodehash(account) }
698         return (codehash != accountHash && codehash != 0x0);
699     }
700 
701     /**
702      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
703      * `recipient`, forwarding all available gas and reverting on errors.
704      *
705      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
706      * of certain opcodes, possibly making contracts go over the 2300 gas limit
707      * imposed by `transfer`, making them unable to receive funds via
708      * `transfer`. {sendValue} removes this limitation.
709      *
710      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
711      *
712      * IMPORTANT: because control is transferred to `recipient`, care must be
713      * taken to not create reentrancy vulnerabilities. Consider using
714      * {ReentrancyGuard} or the
715      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
716      */
717     function sendValue(address payable recipient, uint256 amount) internal {
718         require(address(this).balance >= amount, "Address: insufficient balance");
719 
720         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
721         (bool success, ) = recipient.call{ value: amount }("");
722         require(success, "Address: unable to send value, recipient may have reverted");
723     }
724 
725     /**
726      * @dev Performs a Solidity function call using a low level `call`. A
727      * plain`call` is an unsafe replacement for a function call: use this
728      * function instead.
729      *
730      * If `target` reverts with a revert reason, it is bubbled up by this
731      * function (like regular Solidity function calls).
732      *
733      * Returns the raw returned data. To convert to the expected return value,
734      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
735      *
736      * Requirements:
737      *
738      * - `target` must be a contract.
739      * - calling `target` with `data` must not revert.
740      *
741      * _Available since v3.1._
742      */
743     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
744       return functionCall(target, data, "Address: low-level call failed");
745     }
746 
747     /**
748      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
749      * `errorMessage` as a fallback revert reason when `target` reverts.
750      *
751      * _Available since v3.1._
752      */
753     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
754         return _functionCallWithValue(target, data, 0, errorMessage);
755     }
756 
757     /**
758      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
759      * but also transferring `value` wei to `target`.
760      *
761      * Requirements:
762      *
763      * - the calling contract must have an ETH balance of at least `value`.
764      * - the called Solidity function must be `payable`.
765      *
766      * _Available since v3.1._
767      */
768     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
769         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
770     }
771 
772     /**
773      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
774      * with `errorMessage` as a fallback revert reason when `target` reverts.
775      *
776      * _Available since v3.1._
777      */
778     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
779         require(address(this).balance >= value, "Address: insufficient balance for call");
780         return _functionCallWithValue(target, data, value, errorMessage);
781     }
782 
783     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
784         require(isContract(target), "Address: call to non-contract");
785 
786         // solhint-disable-next-line avoid-low-level-calls
787         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
788         if (success) {
789             return returndata;
790         } else {
791             // Look for revert reason and bubble it up if present
792             if (returndata.length > 0) {
793                 // The easiest way to bubble the revert reason is using memory via assembly
794 
795                 // solhint-disable-next-line no-inline-assembly
796                 assembly {
797                     let returndata_size := mload(returndata)
798                     revert(add(32, returndata), returndata_size)
799                 }
800             } else {
801                 revert(errorMessage);
802             }
803         }
804     }
805 }
806 
807 // File: contracts\standalone\ERC20NFTWrapper.sol
808 
809 // SPDX_License_Identifier: MIT
810 
811 pragma solidity ^0.6.0;
812 
813 
814 
815 
816 
817 
818 contract ERC20NFTWrapper is Context, IERC20NFTWrapper {
819     using SafeMath for uint256;
820     using Address for address;
821 
822     mapping(address => uint256) internal _balances;
823 
824     mapping(address => mapping(address => uint256)) internal _allowances;
825 
826     uint256 internal _totalSupply;
827 
828     string internal _name;
829     string internal _symbol;
830     uint256 internal _decimals;
831 
832     address internal _mainWrapper;
833     uint256 internal _objectId;
834 
835     function init(uint256 objectId) public virtual override {
836         require(_mainWrapper == address(0), "Init already called!");
837         (_name, _symbol, _decimals) = ISuperSaiyanToken(
838             _mainWrapper = msg.sender
839         )
840             .getMintData(_objectId = objectId);
841     }
842 
843     function mainWrapper() public virtual override view returns (address) {
844         return _mainWrapper;
845     }
846 
847     function objectId() public virtual override view returns (uint256) {
848         return _objectId;
849     }
850 
851     function name() public virtual override view returns (string memory) {
852         return _name;
853     }
854 
855     function symbol() public virtual override view returns (string memory) {
856         return _symbol;
857     }
858 
859     function decimals() public virtual override view returns (uint256) {
860         return _decimals;
861     }
862 
863     function totalSupply() public virtual override view returns (uint256) {
864         return _totalSupply;
865     }
866 
867     function balanceOf(address account)
868         public
869         virtual
870         override
871         view
872         returns (uint256)
873     {
874         return _balances[account];
875     }
876 
877     function mint(address owner, uint256 amount) public virtual override {
878         require(msg.sender == _mainWrapper, "Unauthorized action!");
879         _mint(owner, amount);
880     }
881 
882     function burn(address owner, uint256 amount) public virtual override {
883         require(
884             msg.sender == _mainWrapper ||
885                 (ISuperSaiyanToken(_mainWrapper).source() == address(0) &&
886                     msg.sender == owner),
887             "Unauthorized action!"
888         );
889         _burn(owner, amount);
890     }
891 
892     function transfer(address recipient, uint256 amount)
893         public
894         virtual
895         override
896         returns (bool)
897     {
898         _transfer(_msgSender(), recipient, amount);
899         return true;
900     }
901 
902     function allowance(address owner, address spender)
903         public
904         virtual
905         override
906         view
907         returns (uint256 allowanceAmount)
908     {
909         allowanceAmount = _allowances[owner][spender];
910         if (
911             allowanceAmount == 0 &&
912             ISuperSaiyanToken(_mainWrapper).isApprovedForAll(owner, spender)
913         ) {
914             allowanceAmount = _totalSupply;
915         }
916     }
917 
918     function approve(address spender, uint256 amount)
919         public
920         virtual
921         override
922         returns (bool)
923     {
924         _approve(_msgSender(), spender, amount);
925         return true;
926     }
927 
928     function transferFrom(
929         address sender,
930         address recipient,
931         uint256 amount
932     ) public virtual override returns (bool) {
933         _transfer(sender, recipient, amount);
934         if (_msgSender() == _mainWrapper) {
935             return true;
936         }
937         if (
938             !ISuperSaiyanToken(_mainWrapper).isApprovedForAll(
939                 sender,
940                 _msgSender()
941             )
942         ) {
943             _approve(
944                 sender,
945                 _msgSender(),
946                 _allowances[sender][_msgSender()].sub(
947                     amount,
948                     "ERC20: transfer amount exceeds allowance"
949                 )
950             );
951         }
952         return true;
953     }
954 
955     function _transfer(
956         address sender,
957         address recipient,
958         uint256 amount
959     ) internal virtual {
960         require(sender != address(0), "ERC20: transfer from the zero address");
961         require(recipient != address(0), "ERC20: transfer to the zero address");
962 
963         _balances[sender] = _balances[sender].sub(
964             amount,
965             "ERC20: transfer amount exceeds balance"
966         );
967         _balances[recipient] = _balances[recipient].add(amount);
968         emit Transfer(sender, recipient, amount);
969         ISuperSaiyanToken(_mainWrapper).emitTransferSingleEvent(_msgSender(), sender, recipient, _objectId, amount);
970     }
971 
972     function _mint(address account, uint256 amount) internal virtual {
973         require(account != address(0), "ERC20: mint to the zero address");
974 
975         _totalSupply = _totalSupply.add(amount);
976         _balances[account] = _balances[account].add(amount);
977         emit Transfer(address(0), account, amount);
978     }
979 
980     function _burn(address account, uint256 amount) internal virtual {
981         require(account != address(0), "ERC20: burn from the zero address");
982 
983         _balances[account] = _balances[account].sub(
984             amount,
985             "ERC20: burn amount exceeds balance"
986         );
987         _totalSupply = _totalSupply.sub(amount);
988         emit Transfer(account, address(0), amount);
989     }
990 
991     function _approve(
992         address owner,
993         address spender,
994         uint256 amount
995     ) internal virtual {
996         require(owner != address(0), "ERC20: approve from the zero address");
997         require(spender != address(0), "ERC20: approve to the zero address");
998 
999         _allowances[owner][spender] = amount;
1000         emit Approval(owner, spender, amount);
1001     }
1002 }
1003 
1004 // File: contracts\standalone\voting\DFOERC20NFTWrapper.sol
1005 
1006 // SPDX_License_Identifier: MIT
1007 
1008 pragma solidity ^0.6.0;
1009 
1010 
1011 
1012 
1013 /**
1014  * @title DFOSuperSaiyanToken
1015  */
1016 contract DFOERC20NFTWrapper is IDFOERC20NFTWrapper, ERC20NFTWrapper {
1017 
1018     function mint(uint256 amount) public virtual override {
1019         IMVDProxy proxy = IMVDProxy(getProxy());
1020         require(
1021             IMVDFunctionalitiesManager(
1022                 proxy.getMVDFunctionalitiesManagerAddress()
1023             )
1024                 .isAuthorizedFunctionality(msg.sender),
1025             "Unauthorized action!"
1026         );
1027         super._mint(address(proxy), amount);
1028     }
1029 
1030     function transferFrom(
1031         address sender,
1032         address recipient,
1033         uint256 amount
1034     ) public override(IERC20, ERC20NFTWrapper) returns (bool) {
1035         _transfer(sender, recipient, amount);
1036         address txSender = _msgSender();
1037         if (txSender == _mainWrapper || ISuperSaiyanToken(_mainWrapper).isApprovedForAll(
1038                 sender,
1039                 txSender
1040             )) {
1041             return true;
1042         }
1043         address proxy = getProxy();
1044         if (
1045             proxy == address(0) ||
1046             !(IMVDFunctionalityProposalManager(
1047                 IMVDProxy(proxy).getMVDFunctionalityProposalManagerAddress()
1048             )
1049                 .isValidProposal(txSender) && recipient == txSender)
1050         ) {
1051             _approve(
1052                 sender,
1053                 txSender,
1054                 _allowances[sender][txSender] = _allowances[sender][txSender].sub(
1055                     amount,
1056                     "ERC20: transfer amount exceeds allowance"
1057                 )
1058             );
1059         }
1060         return true;
1061     }
1062 
1063     receive() external payable {
1064         revert("ETH not accepted");
1065     }
1066 
1067     function getProxy() public override view returns (address) {
1068         address doubleProxy = IDFOSuperSaiyanToken(_mainWrapper).doubleProxy();
1069         return doubleProxy == address(0) ? address(0) : IDoubleProxy(doubleProxy).proxy();
1070     }
1071 
1072     function setProxy() public override {
1073     }
1074 }