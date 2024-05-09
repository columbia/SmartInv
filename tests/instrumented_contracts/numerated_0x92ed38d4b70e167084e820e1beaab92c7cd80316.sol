1 // File: node_modules\@openzeppelin\contracts\introspection\IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 // File: @openzeppelin\contracts\token\ERC1155\IERC1155.sol
29 
30 // SPDX_License_Identifier: MIT
31 
32 pragma solidity ^0.6.2;
33 
34 
35 /**
36  * @dev Required interface of an ERC1155 compliant contract, as defined in the
37  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
38  *
39  * _Available since v3.1._
40  */
41 interface IERC1155 is IERC165 {
42     /**
43      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
44      */
45     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
46 
47     /**
48      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
49      * transfers.
50      */
51     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
52 
53     /**
54      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
55      * `approved`.
56      */
57     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
58 
59     /**
60      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
61      *
62      * If an {URI} event was emitted for `id`, the standard
63      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
64      * returned by {IERC1155MetadataURI-uri}.
65      */
66     event URI(string value, uint256 indexed id);
67 
68     /**
69      * @dev Returns the amount of tokens of token type `id` owned by `account`.
70      *
71      * Requirements:
72      *
73      * - `account` cannot be the zero address.
74      */
75     function balanceOf(address account, uint256 id) external view returns (uint256);
76 
77     /**
78      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
79      *
80      * Requirements:
81      *
82      * - `accounts` and `ids` must have the same length.
83      */
84     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
85 
86     /**
87      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
88      *
89      * Emits an {ApprovalForAll} event.
90      *
91      * Requirements:
92      *
93      * - `operator` cannot be the caller.
94      */
95     function setApprovalForAll(address operator, bool approved) external;
96 
97     /**
98      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
99      *
100      * See {setApprovalForAll}.
101      */
102     function isApprovedForAll(address account, address operator) external view returns (bool);
103 
104     /**
105      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
106      *
107      * Emits a {TransferSingle} event.
108      *
109      * Requirements:
110      *
111      * - `to` cannot be the zero address.
112      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
113      * - `from` must have a balance of tokens of type `id` of at least `amount`.
114      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
115      * acceptance magic value.
116      */
117     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
118 
119     /**
120      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
121      *
122      * Emits a {TransferBatch} event.
123      *
124      * Requirements:
125      *
126      * - `ids` and `amounts` must have the same length.
127      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
128      * acceptance magic value.
129      */
130     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
131 }
132 
133 // File: @openzeppelin\contracts\token\ERC1155\IERC1155Receiver.sol
134 
135 // SPDX_License_Identifier: MIT
136 
137 pragma solidity ^0.6.0;
138 
139 
140 /**
141  * _Available since v3.1._
142  */
143 interface IERC1155Receiver is IERC165 {
144 
145     /**
146         @dev Handles the receipt of a single ERC1155 token type. This function is
147         called at the end of a `safeTransferFrom` after the balance has been updated.
148         To accept the transfer, this must return
149         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
150         (i.e. 0xf23a6e61, or its own function selector).
151         @param operator The address which initiated the transfer (i.e. msg.sender)
152         @param from The address which previously owned the token
153         @param id The ID of the token being transferred
154         @param value The amount of tokens being transferred
155         @param data Additional data with no specified format
156         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
157     */
158     function onERC1155Received(
159         address operator,
160         address from,
161         uint256 id,
162         uint256 value,
163         bytes calldata data
164     )
165         external
166         returns(bytes4);
167 
168     /**
169         @dev Handles the receipt of a multiple ERC1155 token types. This function
170         is called at the end of a `safeBatchTransferFrom` after the balances have
171         been updated. To accept the transfer(s), this must return
172         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
173         (i.e. 0xbc197c81, or its own function selector).
174         @param operator The address which initiated the batch transfer (i.e. msg.sender)
175         @param from The address which previously owned the token
176         @param ids An array containing ids of each token being transferred (order and length must match values array)
177         @param values An array containing amounts of each token being transferred (order and length must match ids array)
178         @param data Additional data with no specified format
179         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
180     */
181     function onERC1155BatchReceived(
182         address operator,
183         address from,
184         uint256[] calldata ids,
185         uint256[] calldata values,
186         bytes calldata data
187     )
188         external
189         returns(bytes4);
190 }
191 
192 // File: node_modules\eth-item-token-standard\IERC1155Views.sol
193 
194 // SPDX_License_Identifier: MIT
195 
196 pragma solidity ^0.6.0;
197 
198 /**
199  * @title IERC1155Views - An optional utility interface to improve the ERC-1155 Standard.
200  * @dev This interface introduces some additional capabilities for ERC-1155 Tokens.
201  */
202 interface IERC1155Views {
203 
204     /**
205      * @dev Returns the total supply of the given token id
206      * @param objectId the id of the token whose availability you want to know 
207      */
208     function totalSupply(uint256 objectId) external view returns (uint256);
209 
210     /**
211      * @dev Returns the name of the given token id
212      * @param objectId the id of the token whose name you want to know 
213      */
214     function name(uint256 objectId) external view returns (string memory);
215 
216     /**
217      * @dev Returns the symbol of the given token id
218      * @param objectId the id of the token whose symbol you want to know 
219      */
220     function symbol(uint256 objectId) external view returns (string memory);
221 
222     /**
223      * @dev Returns the decimals of the given token id
224      * @param objectId the id of the token whose decimals you want to know 
225      */
226     function decimals(uint256 objectId) external view returns (uint256);
227 
228     /**
229      * @dev Returns the uri of the given token id
230      * @param objectId the id of the token whose uri you want to know 
231      */
232     function uri(uint256 objectId) external view returns (string memory);
233 }
234 
235 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
236 
237 // SPDX_License_Identifier: MIT
238 
239 pragma solidity ^0.6.0;
240 
241 /**
242  * @dev Interface of the ERC20 standard as defined in the EIP.
243  */
244 interface IERC20 {
245     /**
246      * @dev Returns the amount of tokens in existence.
247      */
248     function totalSupply() external view returns (uint256);
249 
250     /**
251      * @dev Returns the amount of tokens owned by `account`.
252      */
253     function balanceOf(address account) external view returns (uint256);
254 
255     /**
256      * @dev Moves `amount` tokens from the caller's account to `recipient`.
257      *
258      * Returns a boolean value indicating whether the operation succeeded.
259      *
260      * Emits a {Transfer} event.
261      */
262     function transfer(address recipient, uint256 amount) external returns (bool);
263 
264     /**
265      * @dev Returns the remaining number of tokens that `spender` will be
266      * allowed to spend on behalf of `owner` through {transferFrom}. This is
267      * zero by default.
268      *
269      * This value changes when {approve} or {transferFrom} are called.
270      */
271     function allowance(address owner, address spender) external view returns (uint256);
272 
273     /**
274      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
275      *
276      * Returns a boolean value indicating whether the operation succeeded.
277      *
278      * IMPORTANT: Beware that changing an allowance with this method brings the risk
279      * that someone may use both the old and the new allowance by unfortunate
280      * transaction ordering. One possible solution to mitigate this race
281      * condition is to first reduce the spender's allowance to 0 and set the
282      * desired value afterwards:
283      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
284      *
285      * Emits an {Approval} event.
286      */
287     function approve(address spender, uint256 amount) external returns (bool);
288 
289     /**
290      * @dev Moves `amount` tokens from `sender` to `recipient` using the
291      * allowance mechanism. `amount` is then deducted from the caller's
292      * allowance.
293      *
294      * Returns a boolean value indicating whether the operation succeeded.
295      *
296      * Emits a {Transfer} event.
297      */
298     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
299 
300     /**
301      * @dev Emitted when `value` tokens are moved from one account (`from`) to
302      * another (`to`).
303      *
304      * Note that `value` may be zero.
305      */
306     event Transfer(address indexed from, address indexed to, uint256 value);
307 
308     /**
309      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
310      * a call to {approve}. `value` is the new allowance.
311      */
312     event Approval(address indexed owner, address indexed spender, uint256 value);
313 }
314 
315 // File: node_modules\eth-item-token-standard\IBaseTokenData.sol
316 
317 // SPDX_License_Identifier: MIT
318 
319 pragma solidity ^0.6.0;
320 
321 interface IBaseTokenData {
322     function name() external view returns (string memory);
323 
324     function symbol() external view returns (string memory);
325 }
326 
327 // File: node_modules\eth-item-token-standard\IERC20Data.sol
328 
329 // SPDX_License_Identifier: MIT
330 
331 pragma solidity ^0.6.0;
332 
333 
334 
335 interface IERC20Data is IBaseTokenData, IERC20 {
336     function decimals() external view returns (uint256);
337 }
338 
339 // File: node_modules\eth-item-token-standard\IEthItemInteroperableInterface.sol
340 
341 // SPDX_License_Identifier: MIT
342 
343 pragma solidity ^0.6.0;
344 
345 
346 
347 interface IEthItemInteroperableInterface is IERC20, IERC20Data {
348 
349     function init(uint256 objectId, string memory name, string memory symbol, uint256 decimals) external;
350 
351     function mainInterface() external view returns (address);
352 
353     function objectId() external view returns (uint256);
354 
355     function mint(address owner, uint256 amount) external;
356 
357     function burn(address owner, uint256 amount) external;
358 
359     function permitNonce(address sender) external view returns(uint256);
360 
361     function permit(address owner, address spender, uint value, uint8 v, bytes32 r, bytes32 s) external;
362 
363     function interoperableInterfaceVersion() external pure returns(uint256 ethItemInteroperableInterfaceVersion);
364 }
365 
366 // File: eth-item-token-standard\IEthItemMainInterface.sol
367 
368 // SPDX_License_Identifier: MIT
369 
370 pragma solidity ^0.6.0;
371 
372 
373 
374 
375 
376 
377 interface IEthItemMainInterface is IERC1155, IERC1155Views, IBaseTokenData {
378 
379     function init(
380         address interoperableInterfaceModel,
381         string calldata name,
382         string calldata symbol
383     ) external;
384 
385     function mainInterfaceVersion() external pure returns(uint256 ethItemInteroperableVersion);
386 
387     function toInteroperableInterfaceAmount(uint256 objectId, uint256 ethItemAmount) external view returns (uint256 interoperableInterfaceAmount);
388 
389     function toMainInterfaceAmount(uint256 objectId, uint256 erc20WrapperAmount) external view returns (uint256 mainInterfaceAmount);
390 
391     function interoperableInterfaceModel() external view returns (address, uint256);
392 
393     function asInteroperable(uint256 objectId) external view returns (IEthItemInteroperableInterface);
394 
395     function emitTransferSingleEvent(address sender, address from, address to, uint256 objectId, uint256 amount) external;
396 
397     function mint(uint256 amount, string calldata partialUri)
398         external
399         returns (uint256, address);
400 
401     function burn(
402         uint256 objectId,
403         uint256 amount
404     ) external;
405 
406     function burnBatch(
407         uint256[] calldata objectIds,
408         uint256[] calldata amounts
409     ) external;
410 
411     event NewItem(uint256 indexed objectId, address indexed tokenAddress);
412     event Mint(uint256 objectId, address tokenAddress, uint256 amount);
413 }
414 
415 // File: models\common\IEthItemModelBase.sol
416 
417 //SPDX_License_Identifier: MIT
418 
419 pragma solidity ^0.6.0;
420 
421 
422 /**
423  * @dev This interface contains the commonn data provided by all the EthItem models
424  */
425 interface IEthItemModelBase is IEthItemMainInterface {
426 
427     /**
428      * @dev Contract Initialization, the caller of this method should be a Contract containing the logic to provide the EthItemERC20WrapperModel to be used to create ERC20-based objectIds
429      * @param name the chosen name for this NFT
430      * @param symbol the chosen symbol (Ticker) for this NFT
431      */
432     function init(string calldata name, string calldata symbol) external;
433 
434     /**
435      * @return modelVersionNumber The version number of the Model, it should be progressive
436      */
437     function modelVersion() external pure returns(uint256 modelVersionNumber);
438 
439     /**
440      * @return factoryAddress the address of the Contract which initialized this EthItem
441      */
442     function factory() external view returns(address factoryAddress);
443 }
444 
445 // File: models\Native\1\INativeV1.sol
446 
447 //SPDX_License_Identifier: MIT
448 
449 pragma solidity ^0.6.0;
450 
451 
452 /**
453  * @dev EthItem token standard - Version 1
454  * This is a pure extension of the EthItem Token Standard, which also introduces an optional extension that can introduce some external behavior to the EthItem.
455  * Extension can also be a simple wallet
456  */
457 interface INativeV1 is IEthItemModelBase {
458 
459     /**
460      * @dev Contract initialization
461      * @param name the chosen name for this NFT
462      * @param symbol the chosen symbol (Ticker) for this NFT
463      * @param extensionAddress the optional address of the extension. It can be a Wallet or a SmartContract
464      * @param extensionInitPayload the optional payload useful to call the extension within the new created EthItem
465      */
466     function init(string calldata name, string calldata symbol, bool hasDecimals, string calldata collectionUri, address extensionAddress, bytes calldata extensionInitPayload) external returns(bytes memory extensionInitCallResponse);
467 
468     /**
469      * @return extensionAddress the address of the eventual EthItem main owner or the SmartContract which contains all the logics to directly exploit all the Collection Items of this EthItem. It can also be a simple wallet
470      */
471     function extension() external view returns (address extensionAddress);
472 
473     /**
474      * @param operator The address to know info about
475      * @return result true if the given address is able to mint new tokens, false otherwise.
476      */
477     function canMint(address operator) external view returns (bool result);
478 
479     /**
480      * @param objectId The item to know info about
481      * @return result true if it is possible to mint more items of the given objectId, false otherwhise.
482      */
483     function isEditable(uint256 objectId) external view returns (bool result);
484 
485     /**
486      * @dev Method callable by the extension only and useful to release the control on the EthItem, which from now on will run independently
487      */
488     function releaseExtension() external;
489 
490     function uri() external view returns (string memory);
491 
492     function decimals() external view returns (uint256);
493 
494     function mint(uint256 amount, string calldata tokenName, string calldata tokenSymbol, string calldata objectUri, bool editable) external returns (uint256 objectId, address tokenAddress);
495 
496     function mint(uint256 amount, string calldata tokenName, string calldata tokenSymbol, string calldata objectUri) external returns (uint256 objectId, address tokenAddress);
497 
498     function mint(uint256 objectId, uint256 amount) external;
499 
500     function makeReadOnly(uint256 objectId) external;
501 
502     function setUri(string calldata newUri) external;
503 
504     function setUri(uint256 objectId, string calldata newUri) external;
505 }
506 
507 // File: @openzeppelin\contracts\GSN\Context.sol
508 
509 // SPDX_License_Identifier: MIT
510 
511 pragma solidity ^0.6.0;
512 
513 /*
514  * @dev Provides information about the current execution context, including the
515  * sender of the transaction and its data. While these are generally available
516  * via msg.sender and msg.data, they should not be accessed in such a direct
517  * manner, since when dealing with GSN meta-transactions the account sending and
518  * paying for execution may not be the actual sender (as far as an application
519  * is concerned).
520  *
521  * This contract is only required for intermediate, library-like contracts.
522  */
523 abstract contract Context {
524     function _msgSender() internal view virtual returns (address payable) {
525         return msg.sender;
526     }
527 
528     function _msgData() internal view virtual returns (bytes memory) {
529         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
530         return msg.data;
531     }
532 }
533 
534 // File: @openzeppelin\contracts\math\SafeMath.sol
535 
536 // SPDX_License_Identifier: MIT
537 
538 pragma solidity ^0.6.0;
539 
540 /**
541  * @dev Wrappers over Solidity's arithmetic operations with added overflow
542  * checks.
543  *
544  * Arithmetic operations in Solidity wrap on overflow. This can easily result
545  * in bugs, because programmers usually assume that an overflow raises an
546  * error, which is the standard behavior in high level programming languages.
547  * `SafeMath` restores this intuition by reverting the transaction when an
548  * operation overflows.
549  *
550  * Using this library instead of the unchecked operations eliminates an entire
551  * class of bugs, so it's recommended to use it always.
552  */
553 library SafeMath {
554     /**
555      * @dev Returns the addition of two unsigned integers, reverting on
556      * overflow.
557      *
558      * Counterpart to Solidity's `+` operator.
559      *
560      * Requirements:
561      *
562      * - Addition cannot overflow.
563      */
564     function add(uint256 a, uint256 b) internal pure returns (uint256) {
565         uint256 c = a + b;
566         require(c >= a, "SafeMath: addition overflow");
567 
568         return c;
569     }
570 
571     /**
572      * @dev Returns the subtraction of two unsigned integers, reverting on
573      * overflow (when the result is negative).
574      *
575      * Counterpart to Solidity's `-` operator.
576      *
577      * Requirements:
578      *
579      * - Subtraction cannot overflow.
580      */
581     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
582         return sub(a, b, "SafeMath: subtraction overflow");
583     }
584 
585     /**
586      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
587      * overflow (when the result is negative).
588      *
589      * Counterpart to Solidity's `-` operator.
590      *
591      * Requirements:
592      *
593      * - Subtraction cannot overflow.
594      */
595     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
596         require(b <= a, errorMessage);
597         uint256 c = a - b;
598 
599         return c;
600     }
601 
602     /**
603      * @dev Returns the multiplication of two unsigned integers, reverting on
604      * overflow.
605      *
606      * Counterpart to Solidity's `*` operator.
607      *
608      * Requirements:
609      *
610      * - Multiplication cannot overflow.
611      */
612     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
613         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
614         // benefit is lost if 'b' is also tested.
615         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
616         if (a == 0) {
617             return 0;
618         }
619 
620         uint256 c = a * b;
621         require(c / a == b, "SafeMath: multiplication overflow");
622 
623         return c;
624     }
625 
626     /**
627      * @dev Returns the integer division of two unsigned integers. Reverts on
628      * division by zero. The result is rounded towards zero.
629      *
630      * Counterpart to Solidity's `/` operator. Note: this function uses a
631      * `revert` opcode (which leaves remaining gas untouched) while Solidity
632      * uses an invalid opcode to revert (consuming all remaining gas).
633      *
634      * Requirements:
635      *
636      * - The divisor cannot be zero.
637      */
638     function div(uint256 a, uint256 b) internal pure returns (uint256) {
639         return div(a, b, "SafeMath: division by zero");
640     }
641 
642     /**
643      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
644      * division by zero. The result is rounded towards zero.
645      *
646      * Counterpart to Solidity's `/` operator. Note: this function uses a
647      * `revert` opcode (which leaves remaining gas untouched) while Solidity
648      * uses an invalid opcode to revert (consuming all remaining gas).
649      *
650      * Requirements:
651      *
652      * - The divisor cannot be zero.
653      */
654     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
655         require(b > 0, errorMessage);
656         uint256 c = a / b;
657         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
658 
659         return c;
660     }
661 
662     /**
663      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
664      * Reverts when dividing by zero.
665      *
666      * Counterpart to Solidity's `%` operator. This function uses a `revert`
667      * opcode (which leaves remaining gas untouched) while Solidity uses an
668      * invalid opcode to revert (consuming all remaining gas).
669      *
670      * Requirements:
671      *
672      * - The divisor cannot be zero.
673      */
674     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
675         return mod(a, b, "SafeMath: modulo by zero");
676     }
677 
678     /**
679      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
680      * Reverts with custom message when dividing by zero.
681      *
682      * Counterpart to Solidity's `%` operator. This function uses a `revert`
683      * opcode (which leaves remaining gas untouched) while Solidity uses an
684      * invalid opcode to revert (consuming all remaining gas).
685      *
686      * Requirements:
687      *
688      * - The divisor cannot be zero.
689      */
690     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
691         require(b != 0, errorMessage);
692         return a % b;
693     }
694 }
695 
696 // File: @openzeppelin\contracts\utils\Address.sol
697 
698 // SPDX_License_Identifier: MIT
699 
700 pragma solidity ^0.6.2;
701 
702 /**
703  * @dev Collection of functions related to the address type
704  */
705 library Address {
706     /**
707      * @dev Returns true if `account` is a contract.
708      *
709      * [IMPORTANT]
710      * ====
711      * It is unsafe to assume that an address for which this function returns
712      * false is an externally-owned account (EOA) and not a contract.
713      *
714      * Among others, `isContract` will return false for the following
715      * types of addresses:
716      *
717      *  - an externally-owned account
718      *  - a contract in construction
719      *  - an address where a contract will be created
720      *  - an address where a contract lived, but was destroyed
721      * ====
722      */
723     function isContract(address account) internal view returns (bool) {
724         // This method relies in extcodesize, which returns 0 for contracts in
725         // construction, since the code is only stored at the end of the
726         // constructor execution.
727 
728         uint256 size;
729         // solhint-disable-next-line no-inline-assembly
730         assembly { size := extcodesize(account) }
731         return size > 0;
732     }
733 
734     /**
735      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
736      * `recipient`, forwarding all available gas and reverting on errors.
737      *
738      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
739      * of certain opcodes, possibly making contracts go over the 2300 gas limit
740      * imposed by `transfer`, making them unable to receive funds via
741      * `transfer`. {sendValue} removes this limitation.
742      *
743      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
744      *
745      * IMPORTANT: because control is transferred to `recipient`, care must be
746      * taken to not create reentrancy vulnerabilities. Consider using
747      * {ReentrancyGuard} or the
748      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
749      */
750     function sendValue(address payable recipient, uint256 amount) internal {
751         require(address(this).balance >= amount, "Address: insufficient balance");
752 
753         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
754         (bool success, ) = recipient.call{ value: amount }("");
755         require(success, "Address: unable to send value, recipient may have reverted");
756     }
757 
758     /**
759      * @dev Performs a Solidity function call using a low level `call`. A
760      * plain`call` is an unsafe replacement for a function call: use this
761      * function instead.
762      *
763      * If `target` reverts with a revert reason, it is bubbled up by this
764      * function (like regular Solidity function calls).
765      *
766      * Returns the raw returned data. To convert to the expected return value,
767      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
768      *
769      * Requirements:
770      *
771      * - `target` must be a contract.
772      * - calling `target` with `data` must not revert.
773      *
774      * _Available since v3.1._
775      */
776     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
777       return functionCall(target, data, "Address: low-level call failed");
778     }
779 
780     /**
781      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
782      * `errorMessage` as a fallback revert reason when `target` reverts.
783      *
784      * _Available since v3.1._
785      */
786     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
787         return _functionCallWithValue(target, data, 0, errorMessage);
788     }
789 
790     /**
791      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
792      * but also transferring `value` wei to `target`.
793      *
794      * Requirements:
795      *
796      * - the calling contract must have an ETH balance of at least `value`.
797      * - the called Solidity function must be `payable`.
798      *
799      * _Available since v3.1._
800      */
801     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
802         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
803     }
804 
805     /**
806      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
807      * with `errorMessage` as a fallback revert reason when `target` reverts.
808      *
809      * _Available since v3.1._
810      */
811     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
812         require(address(this).balance >= value, "Address: insufficient balance for call");
813         return _functionCallWithValue(target, data, value, errorMessage);
814     }
815 
816     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
817         require(isContract(target), "Address: call to non-contract");
818 
819         // solhint-disable-next-line avoid-low-level-calls
820         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
821         if (success) {
822             return returndata;
823         } else {
824             // Look for revert reason and bubble it up if present
825             if (returndata.length > 0) {
826                 // The easiest way to bubble the revert reason is using memory via assembly
827 
828                 // solhint-disable-next-line no-inline-assembly
829                 assembly {
830                     let returndata_size := mload(returndata)
831                     revert(add(32, returndata), returndata_size)
832                 }
833             } else {
834                 revert(errorMessage);
835             }
836         }
837     }
838 }
839 
840 // File: @openzeppelin\contracts\introspection\ERC165.sol
841 
842 // SPDX_License_Identifier: MIT
843 
844 pragma solidity ^0.6.0;
845 
846 
847 /**
848  * @dev Implementation of the {IERC165} interface.
849  *
850  * Contracts may inherit from this and call {_registerInterface} to declare
851  * their support of an interface.
852  */
853 contract ERC165 is IERC165 {
854     /*
855      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
856      */
857     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
858 
859     /**
860      * @dev Mapping of interface ids to whether or not it's supported.
861      */
862     mapping(bytes4 => bool) private _supportedInterfaces;
863 
864     constructor () internal {
865         // Derived contracts need only register support for their own interfaces,
866         // we register support for ERC165 itself here
867         _registerInterface(_INTERFACE_ID_ERC165);
868     }
869 
870     /**
871      * @dev See {IERC165-supportsInterface}.
872      *
873      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
874      */
875     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
876         return _supportedInterfaces[interfaceId];
877     }
878 
879     /**
880      * @dev Registers the contract as an implementer of the interface defined by
881      * `interfaceId`. Support of the actual ERC165 interface is automatic and
882      * registering its interface id is not required.
883      *
884      * See {IERC165-supportsInterface}.
885      *
886      * Requirements:
887      *
888      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
889      */
890     function _registerInterface(bytes4 interfaceId) internal virtual {
891         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
892         _supportedInterfaces[interfaceId] = true;
893     }
894 }
895 
896 // File: eth-item-token-standard\EthItemMainInterface.sol
897 
898 // SPDX_License_Identifier: MIT
899 
900 pragma solidity ^0.6.0;
901 
902 
903 
904 
905 
906 
907 
908 
909 /**
910  * @title EthItem - An improved ERC1155 token with ERC20 trading capabilities.
911  * @dev In the EthItem standard, there is no a centralized storage where to save every objectId info.
912  * In fact every NFT data is saved in a specific ERC20 token that can also work as a standalone one, and let transfer parts of an atomic object.
913  * The ERC20 represents a unique Token Id, and its supply represents the entire supply of that Token Id.
914  * You can instantiate a EthItem as a brand-new one, or as a wrapper for pre-existent classic ERC1155 NFT.
915  * In the first case, you can introduce some particular permissions to mint new tokens.
916  * In the second case, you need to send your NFTs to the Wrapped EthItem (using the classic safeTransferFrom or safeBatchTransferFrom methods)
917  * and it will create a brand new ERC20 Token or mint new supply (in the case some tokens with the same id were transfered before yours).
918  */
919 contract EthItemMainInterface is IEthItemMainInterface, Context, ERC165 {
920     using SafeMath for uint256;
921     using Address for address;
922 
923     bytes4 internal constant _INTERFACEobjectId_ERC1155 = 0xd9b67a26;
924 
925     string internal _name;
926     string internal _symbol;
927 
928     mapping(uint256 => string) internal _objectUris;
929 
930     mapping(uint256 => address) internal _dest;
931     mapping(address => bool) internal _isMine;
932 
933     mapping(address => mapping(address => bool)) internal _operatorApprovals;
934 
935     address internal _interoperableInterfaceModel;
936     uint256 internal _interoperableInterfaceModelVersion;
937 
938     uint256 internal _decimals;
939 
940     /**
941      * @dev Constructor
942      * When you create a EthItem, you can specify if you want to create a brand new one, passing the classic data like name, symbol, amd URI,
943      * or wrap a pre-existent ERC1155 NFT, passing its contract address.
944      * You can use just one of the two modes at the same time.
945      * In both cases, a ERC20 token address is mandatory. It will be used as a model to be cloned for every minted NFT.
946      * @param erc20NFTWrapperModel the address of the ERC20 pre-deployed model. I will not be used in the procedure, but just cloned as a brand-new one every time a new NFT is minted.
947      * @param name the name of the brand new EthItem to be created. If you are wrapping a pre-existing ERC1155 NFT, this must be blank.
948      * @param symbol the symbol of the brand new EthItem to be created. If you are wrapping a pre-existing ERC1155 NFT, this must be blank.
949      */
950     constructor(
951         address erc20NFTWrapperModel,
952         string memory name,
953         string memory symbol
954     ) public {
955         if(erc20NFTWrapperModel != address(0)) {
956             init(erc20NFTWrapperModel, name, symbol);
957         }
958     }
959 
960     /**
961      * @dev Utility method which contains the logic of the constructor.
962      * This is a useful trick to instantiate a contract when it is cloned.
963      */
964     function init(
965         address interoperableInterfaceModel,
966         string memory name,
967         string memory symbol
968     ) public virtual override {
969         require(
970             _interoperableInterfaceModel == address(0),
971             "Init already called!"
972         );
973 
974         require(
975             interoperableInterfaceModel != address(0),
976             "Model should be a valid ethereum address"
977         );
978         _interoperableInterfaceModelVersion = IEthItemInteroperableInterface(_interoperableInterfaceModel = interoperableInterfaceModel).interoperableInterfaceVersion();
979         require(
980             keccak256(bytes(name)) != keccak256(""),
981             "Name is mandatory"
982         );
983         require(
984             keccak256(bytes(symbol)) != keccak256(""),
985             "Symbol is mandatory"
986         );
987 
988         _name = name;
989         _symbol = symbol;
990         _decimals = 18;
991 
992         _registerInterface(this.safeBatchTransferFrom.selector);
993         _registerInterface(_INTERFACEobjectId_ERC1155);
994         _registerInterface(this.balanceOf.selector);
995         _registerInterface(this.balanceOfBatch.selector);
996         _registerInterface(this.setApprovalForAll.selector);
997         _registerInterface(this.isApprovedForAll.selector);
998         _registerInterface(this.safeTransferFrom.selector);
999         _registerInterface(this.uri.selector);
1000         _registerInterface(this.totalSupply.selector);
1001         _registerInterface(0x00ad800c); //name(uint256)
1002         _registerInterface(0x4e41a1fb); //symbol(uint256)
1003         _registerInterface(this.decimals.selector);
1004         _registerInterface(0x06fdde03); //name()
1005         _registerInterface(0x95d89b41); //symbol()
1006     }
1007 
1008     function mainInterfaceVersion() public pure virtual override returns(uint256) {
1009         return 1;
1010     }
1011 
1012     /**
1013      * @dev Mint
1014      * If the EthItem does not wrap a pre-existent NFT, this call is used to mint new NFTs, according to the permission rules provided by the Token creator.
1015      * @param amount The amount of tokens to be created. It must be greater than 1 unity.
1016      * @param objectUri The Uri to locate this new token's metadata.
1017      */
1018     function mint(uint256 amount, string memory objectUri)
1019         public
1020         virtual
1021         override
1022         returns (uint256 objectId, address tokenAddress)
1023     {
1024         require(
1025             amount > 1,
1026             "You need to pass more than a token"
1027         );
1028         require(
1029             keccak256(bytes(objectUri)) != keccak256(""),
1030             "Uri cannot be empty"
1031         );
1032         (objectId, tokenAddress) = _mint(msg.sender, amount);
1033         _objectUris[objectId] = objectUri;
1034     }
1035 
1036     /**
1037      * @dev Burn
1038      * You can choose to burn your NFTs.
1039      * In case this Token wraps a pre-existent ERC1155 NFT, you will receive the wrapped NFTs.
1040      */
1041     function burn(
1042         uint256 objectId,
1043         uint256 amount
1044     ) public virtual override {
1045         uint256[] memory objectIds = new uint256[](1);
1046         objectIds[0] = objectId;
1047         uint256[] memory amounts = new uint256[](1);
1048         amounts[0] = amount;
1049         _burn(msg.sender, objectIds, amounts);
1050         emit TransferSingle(msg.sender, msg.sender, address(0), objectId, amount);
1051     }
1052 
1053     /**
1054      * @dev Burn Batch
1055      * Same as burn, but for multiple NFTs at the same time
1056      */
1057     function burnBatch(
1058         uint256[] memory objectIds,
1059         uint256[] memory amounts
1060     ) public virtual override {
1061         _burn(msg.sender, objectIds, amounts);
1062         emit TransferBatch(msg.sender, msg.sender, address(0), objectIds, amounts);
1063     }
1064 
1065     function _burn(address owner, 
1066         uint256[] memory objectIds,
1067         uint256[] memory amounts) internal virtual {
1068         for (uint256 i = 0; i < objectIds.length; i++) {
1069             asInteroperable(objectIds[i]).burn(
1070                 owner,
1071                 toInteroperableInterfaceAmount(objectIds[i], amounts[i])
1072             );
1073         }
1074     }
1075 
1076     /**
1077      * @dev get the address of the ERC20 Contract used as a model
1078      */
1079     function interoperableInterfaceModel() public virtual override view returns (address, uint256) {
1080         return (_interoperableInterfaceModel, _interoperableInterfaceModelVersion);
1081     }
1082 
1083     /**
1084      * @dev Gives back the address of the ERC20 Token representing this Token Id
1085      */
1086     function asInteroperable(uint256 objectId)
1087         public
1088         virtual
1089         override
1090         view
1091         returns (IEthItemInteroperableInterface)
1092     {
1093         return IEthItemInteroperableInterface(_dest[objectId]);
1094     }
1095 
1096     /**
1097      * @dev Returns the total supply of the given token id
1098      * @param objectId the id of the token whose availability you want to know
1099      */
1100     function totalSupply(uint256 objectId)
1101         public
1102         virtual
1103         override
1104         view
1105         returns (uint256)
1106     {
1107         return toMainInterfaceAmount(objectId, asInteroperable(objectId).totalSupply());
1108     }
1109 
1110     /**
1111      * @dev Returns the name of the given token id
1112      * @param objectId the id of the token whose name you want to know
1113      */
1114     function name(uint256 objectId)
1115         public
1116         virtual
1117         override
1118         view
1119         returns (string memory)
1120     {
1121         return asInteroperable(objectId).name();
1122     }
1123 
1124     function name() public virtual override view returns (string memory) {
1125         return _name;
1126     }
1127 
1128     /**
1129      * @dev Returns the symbol of the given token id
1130      * @param objectId the id of the token whose symbol you want to know
1131      */
1132     function symbol(uint256 objectId)
1133         public
1134         virtual
1135         override
1136         view
1137         returns (string memory)
1138     {
1139         return asInteroperable(objectId).symbol();
1140     }
1141 
1142     function symbol() public virtual override view returns (string memory) {
1143         return _symbol;
1144     }
1145 
1146     /**
1147      * @dev Returns the decimals of the given token id
1148      */
1149     function decimals(uint256)
1150         public
1151         virtual
1152         override
1153         view
1154         returns (uint256)
1155     {
1156         return 1;
1157     }
1158 
1159     /**
1160      * @dev Returns the uri of the given token id
1161      * @param objectId the id of the token whose uri you want to know
1162      */
1163     function uri(uint256 objectId)
1164         public
1165         virtual
1166         override
1167         view
1168         returns (string memory)
1169     {
1170         return _objectUris[objectId];
1171     }
1172 
1173     /**
1174      * @dev Classic ERC1155 Standard Method
1175      */
1176     function balanceOf(address account, uint256 objectId)
1177         public
1178         virtual
1179         override
1180         view
1181         returns (uint256)
1182     {
1183         return toMainInterfaceAmount(objectId, asInteroperable(objectId).balanceOf(account));
1184     }
1185 
1186     /**
1187      * @dev Classic ERC1155 Standard Method
1188      */
1189     function balanceOfBatch(
1190         address[] memory accounts,
1191         uint256[] memory objectIds
1192     ) public virtual override view returns (uint256[] memory balances) {
1193         balances = new uint256[](accounts.length);
1194         for (uint256 i = 0; i < accounts.length; i++) {
1195             balances[i] = balanceOf(accounts[i], objectIds[i]);
1196         }
1197     }
1198 
1199     /**
1200      * @dev Classic ERC1155 Standard Method
1201      */
1202     function setApprovalForAll(address operator, bool approved)
1203         public
1204         virtual
1205         override
1206     {
1207         address sender = _msgSender();
1208         require(
1209             sender != operator,
1210             "ERC1155: setting approval status for self"
1211         );
1212 
1213         _operatorApprovals[sender][operator] = approved;
1214         emit ApprovalForAll(sender, operator, approved);
1215     }
1216 
1217     /**
1218      * @dev Classic ERC1155 Standard Method
1219      */
1220     function isApprovedForAll(address account, address operator)
1221         public
1222         virtual
1223         override
1224         view
1225         returns (bool)
1226     {
1227         return _operatorApprovals[account][operator];
1228     }
1229 
1230     /**
1231      * @dev Classic ERC1155 Standard Method
1232      */
1233     function safeTransferFrom(
1234         address from,
1235         address to,
1236         uint256 objectId,
1237         uint256 amount,
1238         bytes memory data
1239     ) public virtual override {
1240         require(to != address(0), "ERC1155: transfer to the zero address");
1241         address operator = _msgSender();
1242         require(
1243             from == operator || isApprovedForAll(from, operator),
1244             "ERC1155: caller is not owner nor approved"
1245         );
1246 
1247         asInteroperable(objectId).transferFrom(from, to, toInteroperableInterfaceAmount(objectId, amount));
1248 
1249         emit TransferSingle(operator, from, to, objectId, amount);
1250 
1251         _doSafeTransferAcceptanceCheck(
1252             operator,
1253             from,
1254             to,
1255             objectId,
1256             amount,
1257             data
1258         );
1259     }
1260 
1261     /**
1262      * @dev Classic ERC1155 Standard Method
1263      */
1264     function safeBatchTransferFrom(
1265         address from,
1266         address to,
1267         uint256[] memory objectIds,
1268         uint256[] memory amounts,
1269         bytes memory data
1270     ) public virtual override {
1271         require(to != address(0), "ERC1155: transfer to the zero address");
1272         require(
1273             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1274             "ERC1155: caller is not owner nor approved"
1275         );
1276 
1277         for (uint256 i = 0; i < objectIds.length; i++) {
1278             asInteroperable(objectIds[i]).transferFrom(
1279                 from,
1280                 to,
1281                 toInteroperableInterfaceAmount(objectIds[i], amounts[i])
1282             );
1283         }
1284 
1285         address operator = _msgSender();
1286 
1287         emit TransferBatch(operator, from, to, objectIds, amounts);
1288 
1289         _doSafeBatchTransferAcceptanceCheck(
1290             operator,
1291             from,
1292             to,
1293             objectIds,
1294             amounts,
1295             data
1296         );
1297     }
1298 
1299     function emitTransferSingleEvent(address sender, address from, address to, uint256 objectId, uint256 amount) public override {
1300         require(_dest[objectId] == msg.sender, "Unauthorized Action!");
1301         uint256 entireAmount = toMainInterfaceAmount(objectId, amount);
1302         if(entireAmount == 0) {
1303             return;
1304         }
1305         emit TransferSingle(sender, from, to, objectId, entireAmount);
1306     }
1307 
1308     function toInteroperableInterfaceAmount(uint256 objectId, uint256 mainInterfaceAmount) public override virtual view returns (uint256 interoperableInterfaceAmount) {
1309         interoperableInterfaceAmount = mainInterfaceAmount * (10**asInteroperable(objectId).decimals());
1310     }
1311 
1312     function toMainInterfaceAmount(uint256 objectId, uint256 interoperableInterfaceAmount) public override virtual view returns (uint256 mainInterfaceAmount) {
1313         mainInterfaceAmount = interoperableInterfaceAmount / (10**asInteroperable(objectId).decimals());
1314     }
1315 
1316     function _doSafeTransferAcceptanceCheck(
1317         address operator,
1318         address from,
1319         address to,
1320         uint256 id,
1321         uint256 amount,
1322         bytes memory data
1323     ) internal virtual {
1324         if (to.isContract()) {
1325             try
1326                 IERC1155Receiver(to).onERC1155Received(
1327                     operator,
1328                     from,
1329                     id,
1330                     amount,
1331                     data
1332                 )
1333             returns (bytes4 response) {
1334                 if (
1335                     response != IERC1155Receiver(to).onERC1155Received.selector
1336                 ) {
1337                     revert("ERC1155: ERC1155Receiver rejected tokens");
1338                 }
1339             } catch Error(string memory reason) {
1340                 revert(reason);
1341             } catch {
1342                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1343             }
1344         }
1345     }
1346 
1347     function _doSafeBatchTransferAcceptanceCheck(
1348         address operator,
1349         address from,
1350         address to,
1351         uint256[] memory ids,
1352         uint256[] memory amounts,
1353         bytes memory data
1354     ) internal virtual {
1355         if (to.isContract()) {
1356             try
1357                 IERC1155Receiver(to).onERC1155BatchReceived(
1358                     operator,
1359                     from,
1360                     ids,
1361                     amounts,
1362                     data
1363                 )
1364             returns (bytes4 response) {
1365                 if (
1366                     response !=
1367                     IERC1155Receiver(to).onERC1155BatchReceived.selector
1368                 ) {
1369                     revert("ERC1155: ERC1155Receiver rejected tokens");
1370                 }
1371             } catch Error(string memory reason) {
1372                 revert(reason);
1373             } catch {
1374                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1375             }
1376         }
1377     }
1378 
1379     function _clone(address original) internal returns (address copy) {
1380         assembly {
1381             mstore(
1382                 0,
1383                 or(
1384                     0x5880730000000000000000000000000000000000000000803b80938091923cF3,
1385                     mul(original, 0x1000000000000000000)
1386                 )
1387             )
1388             copy := create(0, 0, 32)
1389             switch extcodesize(copy)
1390                 case 0 {
1391                     invalid()
1392                 }
1393         }
1394     }
1395 
1396     function _mint(
1397         address from,
1398         uint256 amount
1399     ) internal virtual returns (uint256 objectId, address wrapperAddress) {
1400         IEthItemInteroperableInterface wrapper = IEthItemInteroperableInterface(wrapperAddress = _clone(_interoperableInterfaceModel));
1401         _isMine[_dest[objectId = uint256(wrapperAddress)] = wrapperAddress] = true;
1402         wrapper.init(objectId, _name, _symbol, _decimals);
1403         wrapper.mint(from, amount * (10**_decimals));
1404         emit NewItem(objectId, wrapperAddress);
1405         emit Mint(objectId, wrapperAddress, amount);
1406         emit TransferSingle(address(this), address(0), from, objectId, amount);
1407     }
1408 }
1409 
1410 // File: orchestrator\IEthItemOrchestratorDependantElement.sol
1411 
1412 //SPDX_License_Identifier: MIT
1413 
1414 pragma solidity ^0.6.0;
1415 
1416 
1417 interface IEthItemOrchestratorDependantElement is IERC165 {
1418 
1419     /**
1420      * @dev GET - The DoubleProxy of the DFO linked to this Contract
1421      */
1422     function doubleProxy() external view returns (address);
1423 
1424     /**
1425      * @dev SET - The DoubleProxy of the DFO linked to this Contract
1426      * It can be done only by the Factory controller
1427      * @param newDoubleProxy the new DoubleProxy address
1428      */
1429     function setDoubleProxy(address newDoubleProxy) external;
1430 
1431     function isAuthorizedOrchestrator(address operator) external view returns(bool);
1432 }
1433 
1434 // File: factory\IEthItemFactory.sol
1435 
1436 //SPDX_License_Identifier: MIT
1437 
1438 pragma solidity ^0.6.0;
1439 
1440 
1441 /**
1442  * @title IEthItemFactory
1443  * @dev This contract represents the Factory Used to deploy all the EthItems, keeping track of them.
1444  */
1445 interface IEthItemFactory is IEthItemOrchestratorDependantElement {
1446 
1447     /**
1448      * @dev GET - The address of the Smart Contract whose code will serve as a model for all the EthItemERC20Wrappers (please see the eth-item-token-standard for further information).
1449      */
1450     function ethItemInteroperableInterfaceModel() external view returns (address ethItemInteroperableInterfaceModelAddress, uint256 ethItemInteroperableInterfaceModelVersion);
1451 
1452     /**
1453      * @dev SET - The address of the Smart Contract whose code will serve as a model for all the EthItemERC20Wrappers (please see the eth-item-token-standard for further information).
1454      * It can be done only by the Factory controller
1455      */
1456     function setEthItemInteroperableInterfaceModel(address ethItemInteroperableInterfaceModelAddress) external;
1457 
1458     /**
1459      * @dev GET - The address of the Smart Contract whose code will serve as a model for all the Native EthItems.
1460      * Every EthItem will have its own address, but the code will be cloned from this one.
1461      */
1462     function nativeModel() external view returns (address nativeModelAddress, uint256 nativeModelVersion);
1463 
1464     /**
1465      * @dev SET - The address of the Native EthItem model.
1466      * It can be done only by the Factory controller
1467      */
1468     function setNativeModel(address nativeModelAddress) external;
1469 
1470     /**
1471      * @dev GET - The address of the Smart Contract whose code will serve as a model for all the Wrapped ERC1155 EthItems.
1472      * Every EthItem will have its own address, but the code will be cloned from this one.
1473      */
1474     function erc1155WrapperModel() external view returns (address erc1155WrapperModelAddress, uint256 erc1155WrapperModelVersion);
1475 
1476     /**
1477      * @dev SET - The address of the ERC1155 NFT-Based EthItem model.
1478      * It can be done only by the Factory controller
1479      */
1480     function setERC1155WrapperModel(address erc1155WrapperModelAddress) external;
1481 
1482     /**
1483      * @dev GET - The address of the Smart Contract whose code will serve as a model for all the Wrapped ERC20 EthItems.
1484      */
1485     function erc20WrapperModel() external view returns (address erc20WrapperModelAddress, uint256 erc20WrapperModelVersion);
1486 
1487     /**
1488      * @dev SET - The address of the Smart Contract whose code will serve as a model for all the Wrapped ERC20 EthItems.
1489      * It can be done only by the Factory controller
1490      */
1491     function setERC20WrapperModel(address erc20WrapperModelAddress) external;
1492 
1493     /**
1494      * @dev GET - The address of the Smart Contract whose code will serve as a model for all the Wrapped ERC721 EthItems.
1495      */
1496     function erc721WrapperModel() external view returns (address erc721WrapperModelAddress, uint256 erc721WrapperModelVersion);
1497 
1498     /**
1499      * @dev SET - The address of the Smart Contract whose code will serve as a model for all the Wrapped ERC721 EthItems.
1500      * It can be done only by the Factory controller
1501      */
1502     function setERC721WrapperModel(address erc721WrapperModelAddress) external;
1503 
1504     /**
1505      * @dev GET - The elements (numerator and denominator) useful to calculate the percentage fee to be transfered to the DFO for every new Minted EthItem
1506      */
1507     function mintFeePercentage() external view returns (uint256 mintFeePercentageNumerator, uint256 mintFeePercentageDenominator);
1508 
1509     /**
1510      * @dev SET - The element useful to calculate the Percentage fee
1511      * It can be done only by the Factory controller
1512      */
1513     function setMintFeePercentage(uint256 mintFeePercentageNumerator, uint256 mintFeePercentageDenominator) external;
1514 
1515     /**
1516      * @dev Useful utility method to calculate the percentage fee to transfer to the DFO for the minted EthItem amount.
1517      * @param erc20WrapperAmount The amount of minted EthItem
1518      */
1519     function calculateMintFee(uint256 erc20WrapperAmount) external view returns (uint256 mintFee, address dfoWalletAddress);
1520 
1521     /**
1522      * @dev GET - The elements (numerator and denominator) useful to calculate the percentage fee to be transfered to the DFO for every Burned EthItem
1523      */
1524     function burnFeePercentage() external view returns (uint256 burnFeePercentageNumerator, uint256 burnFeePercentageDenominator);
1525 
1526     /**
1527      * @dev SET - The element useful to calculate the Percentage fee
1528      * It can be done only by the Factory controller
1529      */
1530     function setBurnFeePercentage(uint256 burnFeePercentageNumerator, uint256 burnFeePercentageDenominator) external;
1531 
1532     /**
1533      * @dev Useful utility method to calculate the percentage fee to transfer to the DFO for the burned EthItem amount.
1534      * @param erc20WrapperAmount The amount of burned EthItem
1535      */
1536     function calculateBurnFee(uint256 erc20WrapperAmount) external view returns (uint256 burnFee, address dfoWalletAddress);
1537 
1538     /**
1539      * @dev Business Logic to create a brand-new EthItem.
1540      * It raises the 'NewNativeCreated' events.
1541      * @param modelInitCallPayload The ABI-encoded input parameters to be passed to the model to phisically create the NFT.
1542      * It changes according to the Model Version.
1543      * @param ethItemAddress The address of the new EthItem
1544      * @param ethItemInitResponse The ABI-encoded output response eventually received by the Model initialization procedure.
1545      */
1546     function createNative(bytes calldata modelInitCallPayload) external returns (address ethItemAddress, bytes memory ethItemInitResponse);
1547 
1548     event NewNativeCreated(uint256 indexed standardVersion, uint256 indexed wrappedItemModelVersion, uint256 indexed modelVersion, address tokenCreated);
1549     event NewNativeCreated(address indexed model, uint256 indexed modelVersion, address indexed tokenCreated, address creator);
1550 
1551     /**
1552      * @dev Business Logic to wrap already existing ERC1155 Tokens to obtain a new NFT-Based EthItem.
1553      * It raises the 'NewWrappedERC1155Created' events.
1554      * @param modelInitCallPayload The ABI-encoded input parameters to be passed to the model to phisically create the NFT.
1555      * It changes according to the Model Version.
1556      * @param ethItemAddress The address of the new EthItem
1557      * @param ethItemInitResponse The ABI-encoded output response eventually received by the Model initialization procedure.
1558      */
1559     function createWrappedERC1155(bytes calldata modelInitCallPayload) external returns (address ethItemAddress, bytes memory ethItemInitResponse);
1560 
1561     event NewWrappedERC1155Created(uint256 indexed standardVersion, uint256 indexed wrappedItemModelVersion, uint256 indexed modelVersion, address tokenCreated);
1562     event NewWrappedERC1155Created(address indexed model, uint256 indexed modelVersion, address indexed tokenCreated, address creator);
1563 
1564     /**
1565      * @dev Business Logic to wrap already existing ERC20 Tokens to obtain a new NFT-Based EthItem.
1566      * It raises the 'NewWrappedERC20Created' events.
1567      * @param modelInitCallPayload The ABI-encoded input parameters to be passed to the model to phisically create the NFT.
1568      * It changes according to the Model Version.
1569      * @param ethItemAddress The address of the new EthItem
1570      * @param ethItemInitResponse The ABI-encoded output response eventually received by the Model initialization procedure.
1571      */
1572     function createWrappedERC20(bytes calldata modelInitCallPayload) external returns (address ethItemAddress, bytes memory ethItemInitResponse);
1573 
1574     event NewWrappedERC20Created(uint256 indexed standardVersion, uint256 indexed wrappedItemModelVersion, uint256 indexed modelVersion, address tokenCreated);
1575     event NewWrappedERC20Created(address indexed model, uint256 indexed modelVersion, address indexed tokenCreated, address creator);
1576 
1577     /**
1578      * @dev Business Logic to wrap already existing ERC721 Tokens to obtain a new NFT-Based EthItem.
1579      * It raises the 'NewWrappedERC721Created' events.
1580      * @param modelInitCallPayload The ABI-encoded input parameters to be passed to the model to phisically create the NFT.
1581      * It changes according to the Model Version.
1582      * @param ethItemAddress The address of the new EthItem
1583      * @param ethItemInitResponse The ABI-encoded output response eventually received by the Model initialization procedure.
1584      */
1585     function createWrappedERC721(bytes calldata modelInitCallPayload) external returns (address ethItemAddress, bytes memory ethItemInitResponse);
1586 
1587     event NewWrappedERC721Created(uint256 indexed standardVersion, uint256 indexed wrappedItemModelVersion, uint256 indexed modelVersion, address tokenCreated);
1588     event NewWrappedERC721Created(address indexed model, uint256 indexed modelVersion, address indexed tokenCreated, address creator);
1589 }
1590 
1591 // File: models\common\EthItemModelBase.sol
1592 
1593 //SPDX_License_Identifier: MIT
1594 
1595 pragma solidity ^0.6.0;
1596 
1597 
1598 
1599 
1600 abstract contract EthItemModelBase is IEthItemModelBase, EthItemMainInterface(address(0), "", "") {
1601 
1602     address internal _factoryAddress;
1603 
1604     function init(
1605         address,
1606         string memory,
1607         string memory
1608     ) public virtual override(IEthItemMainInterface, EthItemMainInterface) {
1609         revert("Cannot directly call this method.");
1610     }
1611 
1612     function init(
1613         string memory name,
1614         string memory symbol
1615     ) public override virtual {
1616         require(_factoryAddress == address(0), "Init already called!");
1617         (address ethItemInteroperableInterfaceModelAddress,) = IEthItemFactory(_factoryAddress = msg.sender).ethItemInteroperableInterfaceModel();
1618         super.init(ethItemInteroperableInterfaceModelAddress, name, symbol);
1619     }
1620 
1621     function modelVersion() public override virtual pure returns(uint256) {
1622         return 1;
1623     }
1624 
1625     function factory() public override view returns (address) {
1626         return _factoryAddress;
1627     }
1628 
1629     function _sendMintFeeToDFO(address from, uint256 objectId, uint256 erc20WrapperAmount) internal virtual returns(uint256 mintFeeToDFO) {
1630         address dfoWallet;
1631         (mintFeeToDFO, dfoWallet) = IEthItemFactory(_factoryAddress).calculateMintFee(erc20WrapperAmount);
1632         if(mintFeeToDFO > 0 && dfoWallet != address(0)) {
1633             asInteroperable(objectId).transferFrom(from, dfoWallet, mintFeeToDFO);
1634         }
1635     }
1636 
1637     function _sendBurnFeeToDFO(address from, uint256 objectId, uint256 erc20WrapperAmount) internal virtual returns(uint256 burnFeeToDFO) {
1638         address dfoWallet;
1639         (burnFeeToDFO, dfoWallet) = IEthItemFactory(_factoryAddress).calculateBurnFee(erc20WrapperAmount);
1640         if(burnFeeToDFO > 0 && dfoWallet != address(0)) {
1641             asInteroperable(objectId).transferFrom(from, dfoWallet, burnFeeToDFO);
1642         }
1643     }
1644 
1645     function mint(uint256, string memory)
1646         public
1647         virtual
1648         override(IEthItemMainInterface, EthItemMainInterface)
1649         returns (uint256, address)
1650     {
1651         revert("Cannot directly call this method.");
1652     }
1653 
1654     function safeTransferFrom(
1655         address from,
1656         address to,
1657         uint256 objectId,
1658         uint256 amount,
1659         bytes memory data
1660     ) public virtual override(IERC1155, EthItemMainInterface) {
1661         require(to != address(0), "ERC1155: transfer to the zero address");
1662         address operator = _msgSender();
1663         require(
1664             from == operator || isApprovedForAll(from, operator),
1665             "ERC1155: caller is not owner nor approved"
1666         );
1667 
1668         _doERC20Transfer(from, to, objectId, amount);
1669 
1670         emit TransferSingle(operator, from, to, objectId, amount);
1671 
1672         _doSafeTransferAcceptanceCheck(
1673             operator,
1674             from,
1675             to,
1676             objectId,
1677             amount,
1678             data
1679         );
1680     }
1681 
1682     /**
1683      * @dev Classic ERC1155 Standard Method
1684      */
1685     function safeBatchTransferFrom(
1686         address from,
1687         address to,
1688         uint256[] memory objectIds,
1689         uint256[] memory amounts,
1690         bytes memory data
1691     ) public virtual override(IERC1155, EthItemMainInterface) {
1692         require(to != address(0), "ERC1155: transfer to the zero address");
1693         require(
1694             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1695             "ERC1155: caller is not owner nor approved"
1696         );
1697 
1698         for (uint256 i = 0; i < objectIds.length; i++) {
1699             _doERC20Transfer(from, to, objectIds[i], amounts[i]);
1700         }
1701 
1702         address operator = _msgSender();
1703 
1704         emit TransferBatch(operator, from, to, objectIds, amounts);
1705 
1706         _doSafeBatchTransferAcceptanceCheck(
1707             operator,
1708             from,
1709             to,
1710             objectIds,
1711             amounts,
1712             data
1713         );
1714     }
1715 
1716     function _doERC20Transfer(address from, address to, uint256 objectId, uint256 amount) internal virtual {
1717         (,uint256 result) = _getCorrectERC20ValueForTransferOrBurn(from, objectId, amount);
1718         asInteroperable(objectId).transferFrom(from, to, result);
1719     }
1720 
1721     function _getCorrectERC20ValueForTransferOrBurn(address from, uint256 objectId, uint256 amount) internal virtual view returns(uint256 balanceOfNormal, uint256 result) {
1722         uint256 toTransfer = toInteroperableInterfaceAmount(objectId, amount);
1723         uint256 balanceOfDecimals = asInteroperable(objectId).balanceOf(from);
1724         balanceOfNormal = balanceOf(from, objectId);
1725         result = amount == balanceOfNormal ? balanceOfDecimals : toTransfer;
1726     }
1727 
1728     function _burn(
1729         uint256 objectId,
1730         uint256 amount
1731     ) internal virtual returns(uint256 burnt, uint256 burnFeeToDFO) {
1732         (uint256 balanceOfNormal, uint256 result) = _getCorrectERC20ValueForTransferOrBurn(msg.sender, objectId, amount);
1733         require(balanceOfNormal >= amount, "Insufficient Amount");
1734         burnFeeToDFO = _sendBurnFeeToDFO(msg.sender, objectId, result);
1735         asInteroperable(objectId).burn(msg.sender, burnt = result - burnFeeToDFO);
1736     }
1737 
1738     function _isUnique(uint256 objectId) internal virtual view returns (bool unique, uint256 unity, uint256 totalSupply, uint256 erc20Decimals) {
1739         erc20Decimals = asInteroperable(objectId).decimals();
1740         unity = erc20Decimals <= 1 ? 1 : (10**erc20Decimals);
1741         totalSupply = asInteroperable(objectId).totalSupply();
1742         unique = totalSupply <= unity;
1743     }
1744 
1745     function toMainInterfaceAmount(uint256 objectId, uint256 interoperableInterfaceAmount) public virtual view override(IEthItemMainInterface, EthItemMainInterface) returns (uint256 mainInterfaceAmount) {
1746         (bool unique, uint256 unity,, uint256 erc20Decimals) = _isUnique(objectId);
1747         if(unique && interoperableInterfaceAmount < unity) {
1748             uint256 half = (unity * 51) / 100;
1749             return mainInterfaceAmount = interoperableInterfaceAmount <= half ? 0 : 1;
1750         }
1751         return mainInterfaceAmount = interoperableInterfaceAmount / (10**erc20Decimals);
1752     }
1753 }
1754 
1755 // File: models\Native\1\NativeV1.sol
1756 
1757 //SPDX_License_Identifier: MIT
1758 
1759 pragma solidity ^0.6.0;
1760 
1761 
1762 
1763 contract NativeV1 is INativeV1, EthItemModelBase {
1764 
1765     address internal _extensionAddress;
1766     string internal _uri;
1767     bool internal _supportsSpecificDecimals;
1768     mapping(uint256 => bool) internal _editable;
1769 
1770     function init(string memory name, string memory symbol, bool hasDecimals, string memory collectionUri, address extensionAddress, bytes memory extensionInitPayload) public override virtual returns(bytes memory extensionInitCallResponse) {
1771         super.init(name, symbol);
1772         require(
1773             keccak256(bytes(collectionUri)) != keccak256(""),
1774             "Uri cannot be empty"
1775         );
1776         _uri = collectionUri;
1777         extensionInitCallResponse = _initExtension(extensionAddress, extensionInitPayload);
1778         _supportsSpecificDecimals = hasDecimals;
1779     }
1780 
1781     function _initExtension(address extensionAddress, bytes memory extensionInitPayload) internal virtual returns(bytes memory extensionInitCallResponse) {
1782         require(extensionAddress != address(0), "Extension is mandatory");
1783         _extensionAddress = extensionAddress;
1784         if (
1785             extensionAddress != address(0) &&
1786             keccak256(extensionInitPayload) != keccak256("")
1787         ) {
1788             bool extensionInitCallResult = false;
1789             (
1790                 extensionInitCallResult,
1791                 extensionInitCallResponse
1792             ) = extensionAddress.call(extensionInitPayload);
1793             require(
1794                 extensionInitCallResult,
1795                 "Extension Init Call Result failed!"
1796             );
1797         }
1798     }
1799 
1800     function extension() public view virtual override returns (address) {
1801         return _extensionAddress;
1802     }
1803 
1804     function canMint(address operator) public view virtual override returns (bool result) {
1805         result = operator == _extensionAddress;
1806     }
1807 
1808     function setUri(string memory newUri) public virtual override {
1809         require(canMint(msg.sender), "Unauthorized Action!");
1810         _uri = newUri;
1811     }
1812 
1813     function setUri(uint256 objectId, string memory newUri) public virtual override {
1814         require(canMint(msg.sender), "Unauthorized Action!");
1815         require(isEditable(objectId), "Unauthorized Action!");
1816         _objectUris[objectId] = newUri;
1817     }
1818 
1819     function isEditable(uint256 objectId) public view virtual override returns (bool result) {
1820         result = _editable[objectId] && _extensionAddress != address(0);
1821     }
1822 
1823     function uri() public virtual view override returns(string memory) {
1824         return _uri;
1825     }
1826 
1827     function decimals() public override view returns (uint256) {
1828         return _supportsSpecificDecimals ? _decimals : 1;
1829     }
1830 
1831     function decimals(uint256 objectId)
1832         public
1833         view
1834         virtual
1835         override
1836         returns (uint256)
1837     {
1838         return
1839             !_supportsSpecificDecimals
1840                 ? 1
1841                 : asInteroperable(objectId).decimals();
1842     }
1843 
1844     function mint(uint256 amount, string memory tokenName, string memory tokenSymbol, string memory objectUri, bool editable)
1845         public
1846         virtual
1847         override
1848         returns (uint256 objectId, address wrapperAddress)
1849     {
1850         require(canMint(msg.sender), "Unauthorized action!");
1851         require(
1852             keccak256(bytes(objectUri)) != keccak256(""),
1853             "Uri cannot be empty"
1854         );
1855         string memory name = keccak256(bytes(tokenName)) != keccak256("") ? tokenName : _name;
1856         string memory symbol = keccak256(bytes(tokenSymbol)) != keccak256("") ? tokenSymbol : _symbol;
1857         (address ethItemERC20WrapperModelAddress,) = interoperableInterfaceModel();
1858         IEthItemInteroperableInterface wrapper = IEthItemInteroperableInterface(wrapperAddress = _clone(ethItemERC20WrapperModelAddress));
1859         _isMine[_dest[objectId = uint256(wrapperAddress)] = wrapperAddress] = true;
1860         _objectUris[objectId] = objectUri;
1861         _editable[objectId] = editable;
1862         wrapper.init(objectId, name, symbol, _decimals);
1863         emit NewItem(objectId, wrapperAddress);
1864         _mint(objectId, amount);
1865     }
1866 
1867     function mint(uint256 amount, string memory tokenName, string memory tokenSymbol, string memory objectUri)
1868         public
1869         virtual
1870         override
1871         returns (uint256 objectId, address wrapperAddress)
1872     {
1873         return mint(amount, tokenName, tokenSymbol, objectUri, false);
1874     }
1875 
1876     function mint(uint256 objectId, uint256 amount) public virtual override {
1877         require(isEditable(objectId), "Unauthorized action!");
1878         require(canMint(msg.sender), "Unauthorized action!");
1879         _mint(objectId, amount);
1880     }
1881 
1882     function _mint(uint256 objectId, uint256 amount) internal virtual {
1883         IEthItemInteroperableInterface wrapper = asInteroperable(objectId);
1884         uint256 amountInDecimals = amount * (_supportsSpecificDecimals ? 1 : (10**_decimals));
1885         wrapper.mint(msg.sender, amountInDecimals);
1886         emit Mint(objectId, address(wrapper), amount);
1887         uint256 sentForMint = _sendMintFeeToDFO(msg.sender, objectId, amountInDecimals);
1888         emit TransferSingle(address(this), address(0), msg.sender, objectId, toMainInterfaceAmount(objectId, amountInDecimals - sentForMint));
1889     }
1890 
1891     function makeReadOnly(uint256 objectId) public virtual override {
1892         require(canMint(msg.sender), "Unauthorized action!");
1893         require(isEditable(objectId), "Unauthorized Action!");
1894         require(_editable[objectId], "Already read only!");
1895         _editable[objectId] = false;
1896     }
1897 
1898     function burn(
1899         uint256 objectId,
1900         uint256 amount
1901     ) public virtual override {
1902         _burn(objectId, amount);
1903         emit TransferSingle(msg.sender, msg.sender, address(0), objectId, amount);
1904     }
1905 
1906     function burnBatch(
1907         uint256[] memory objectIds,
1908         uint256[] memory amounts
1909     ) public virtual override {
1910         for (uint256 i = 0; i < objectIds.length; i++) {
1911             _burn(objectIds[i], amounts[i]);
1912         }
1913         emit TransferBatch(msg.sender, msg.sender, address(0), objectIds, amounts);
1914     }
1915 
1916     function isApprovedForAll(address account, address operator)
1917         public
1918         view
1919         virtual
1920         override
1921         returns (bool)
1922     {
1923         if(operator == _extensionAddress) {
1924             return true;
1925         }
1926         return super.isApprovedForAll(account, operator);
1927     }
1928 
1929     function releaseExtension() public override {
1930         require(msg.sender == _extensionAddress, "Unauthorized Action!");
1931         _extensionAddress = address(0);
1932     }
1933 
1934     function toInteroperableInterfaceAmount(uint256 objectId, uint256 mainInterfaceAmount) public override virtual view returns (uint256 interoperableInterfaceAmount) {
1935         interoperableInterfaceAmount = _supportsSpecificDecimals ? mainInterfaceAmount : super.toInteroperableInterfaceAmount(objectId, mainInterfaceAmount);
1936     }
1937 
1938     function toMainInterfaceAmount(uint256 objectId, uint256 interoperableInterfaceAmount) public override(IEthItemMainInterface, EthItemModelBase) virtual view returns (uint256 mainInterfaceAmount) {
1939         mainInterfaceAmount = _supportsSpecificDecimals ? interoperableInterfaceAmount : super.toMainInterfaceAmount(objectId, interoperableInterfaceAmount);
1940     }
1941 }