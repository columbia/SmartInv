1 // File: node_modules\@openzeppelin\contracts\introspection\IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
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
32 pragma solidity >=0.6.2 <0.8.0;
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
137 pragma solidity >=0.6.0 <0.8.0;
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
196 
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
239 pragma solidity >=0.6.0 <0.8.0;
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
319 
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
331 
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
343 
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
370 
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
415 // File: contracts\models\common\IEthItemModelBase.sol
416 
417 //SPDX_License_Identifier: MIT
418 
419 
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
445 // File: contracts\models\ERC20Wrapper\1\IERC20WrapperV1.sol
446 
447 //SPDX_License_Identifier: MIT
448 
449 
450 
451 
452 /**
453  * @title ERC20-Based EthItem, version 1.
454  * @dev All the wrapped ERC20 Tokens will be created following this Model.
455  * The minting operation can be done by calling the appropriate method given in this interface.
456  * The burning operation will send back the original wrapped ERC20 amount.
457  * To initalize it, the original 'init(address,string,string)'
458  * function of the EthItem Token Standard will be used, but the first address parameter will be the original ERC20 Source Contract to Wrap, and NOT the ERC20Model, which is always taken by the Contract who creates the Wrapper.
459  */
460 interface IERC20WrapperV1 is IEthItemModelBase {
461 
462     /**
463      * @param objectId the Object Id you want to know info about
464      * @return erc20TokenAddress the wrapped ERC20 Token address corresponding to the given objectId
465      */
466     function source(uint256 objectId) external view returns (address erc20TokenAddress);
467 
468      /**
469      * @param erc20TokenAddress the wrapped ERC20 Token address you want to know info about
470      * @return objectId the id in the collection which correspondes to the given erc20TokenAddress
471      */
472     function object(address erc20TokenAddress) external view returns (uint256 objectId);
473 
474     /**
475      * @dev Mint operation.
476      * It inhibits and bypasses the original EthItem Token Standard 'mint(uint256,string)'.
477      * The logic will execute a transferFrom call to the given erc20TokenAddress to transfer the chosed amount of tokens
478      * @param erc20TokenAddress The token address to wrap.
479      * @param amount The token amount to wrap
480      *
481      * @return objectId the id given by this collection to the given erc20TokenAddress. It can be brand new if it is the first time this collection is created. Otherwhise, the firstly-created objectId value will be used.
482      * @return wrapperAddress The address ethItemERC20Wrapper generated after the creation of the returned objectId
483      */
484     function mint(address erc20TokenAddress, uint256 amount) external returns (uint256 objectId, address wrapperAddress);
485 
486     function mintETH() external payable returns (uint256 objectId, address wrapperAddress);
487 }
488 
489 // File: @openzeppelin\contracts\GSN\Context.sol
490 
491 // SPDX_License_Identifier: MIT
492 
493 pragma solidity >=0.6.0 <0.8.0;
494 
495 /*
496  * @dev Provides information about the current execution context, including the
497  * sender of the transaction and its data. While these are generally available
498  * via msg.sender and msg.data, they should not be accessed in such a direct
499  * manner, since when dealing with GSN meta-transactions the account sending and
500  * paying for execution may not be the actual sender (as far as an application
501  * is concerned).
502  *
503  * This contract is only required for intermediate, library-like contracts.
504  */
505 abstract contract Context {
506     function _msgSender() internal view virtual returns (address payable) {
507         return msg.sender;
508     }
509 
510     function _msgData() internal view virtual returns (bytes memory) {
511         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
512         return msg.data;
513     }
514 }
515 
516 // File: @openzeppelin\contracts\math\SafeMath.sol
517 
518 // SPDX_License_Identifier: MIT
519 
520 pragma solidity >=0.6.0 <0.8.0;
521 
522 /**
523  * @dev Wrappers over Solidity's arithmetic operations with added overflow
524  * checks.
525  *
526  * Arithmetic operations in Solidity wrap on overflow. This can easily result
527  * in bugs, because programmers usually assume that an overflow raises an
528  * error, which is the standard behavior in high level programming languages.
529  * `SafeMath` restores this intuition by reverting the transaction when an
530  * operation overflows.
531  *
532  * Using this library instead of the unchecked operations eliminates an entire
533  * class of bugs, so it's recommended to use it always.
534  */
535 library SafeMath {
536     /**
537      * @dev Returns the addition of two unsigned integers, reverting on
538      * overflow.
539      *
540      * Counterpart to Solidity's `+` operator.
541      *
542      * Requirements:
543      *
544      * - Addition cannot overflow.
545      */
546     function add(uint256 a, uint256 b) internal pure returns (uint256) {
547         uint256 c = a + b;
548         require(c >= a, "SafeMath: addition overflow");
549 
550         return c;
551     }
552 
553     /**
554      * @dev Returns the subtraction of two unsigned integers, reverting on
555      * overflow (when the result is negative).
556      *
557      * Counterpart to Solidity's `-` operator.
558      *
559      * Requirements:
560      *
561      * - Subtraction cannot overflow.
562      */
563     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
564         return sub(a, b, "SafeMath: subtraction overflow");
565     }
566 
567     /**
568      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
569      * overflow (when the result is negative).
570      *
571      * Counterpart to Solidity's `-` operator.
572      *
573      * Requirements:
574      *
575      * - Subtraction cannot overflow.
576      */
577     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
578         require(b <= a, errorMessage);
579         uint256 c = a - b;
580 
581         return c;
582     }
583 
584     /**
585      * @dev Returns the multiplication of two unsigned integers, reverting on
586      * overflow.
587      *
588      * Counterpart to Solidity's `*` operator.
589      *
590      * Requirements:
591      *
592      * - Multiplication cannot overflow.
593      */
594     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
595         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
596         // benefit is lost if 'b' is also tested.
597         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
598         if (a == 0) {
599             return 0;
600         }
601 
602         uint256 c = a * b;
603         require(c / a == b, "SafeMath: multiplication overflow");
604 
605         return c;
606     }
607 
608     /**
609      * @dev Returns the integer division of two unsigned integers. Reverts on
610      * division by zero. The result is rounded towards zero.
611      *
612      * Counterpart to Solidity's `/` operator. Note: this function uses a
613      * `revert` opcode (which leaves remaining gas untouched) while Solidity
614      * uses an invalid opcode to revert (consuming all remaining gas).
615      *
616      * Requirements:
617      *
618      * - The divisor cannot be zero.
619      */
620     function div(uint256 a, uint256 b) internal pure returns (uint256) {
621         return div(a, b, "SafeMath: division by zero");
622     }
623 
624     /**
625      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
626      * division by zero. The result is rounded towards zero.
627      *
628      * Counterpart to Solidity's `/` operator. Note: this function uses a
629      * `revert` opcode (which leaves remaining gas untouched) while Solidity
630      * uses an invalid opcode to revert (consuming all remaining gas).
631      *
632      * Requirements:
633      *
634      * - The divisor cannot be zero.
635      */
636     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
637         require(b > 0, errorMessage);
638         uint256 c = a / b;
639         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
640 
641         return c;
642     }
643 
644     /**
645      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
646      * Reverts when dividing by zero.
647      *
648      * Counterpart to Solidity's `%` operator. This function uses a `revert`
649      * opcode (which leaves remaining gas untouched) while Solidity uses an
650      * invalid opcode to revert (consuming all remaining gas).
651      *
652      * Requirements:
653      *
654      * - The divisor cannot be zero.
655      */
656     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
657         return mod(a, b, "SafeMath: modulo by zero");
658     }
659 
660     /**
661      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
662      * Reverts with custom message when dividing by zero.
663      *
664      * Counterpart to Solidity's `%` operator. This function uses a `revert`
665      * opcode (which leaves remaining gas untouched) while Solidity uses an
666      * invalid opcode to revert (consuming all remaining gas).
667      *
668      * Requirements:
669      *
670      * - The divisor cannot be zero.
671      */
672     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
673         require(b != 0, errorMessage);
674         return a % b;
675     }
676 }
677 
678 // File: @openzeppelin\contracts\utils\Address.sol
679 
680 // SPDX_License_Identifier: MIT
681 
682 pragma solidity >=0.6.2 <0.8.0;
683 
684 /**
685  * @dev Collection of functions related to the address type
686  */
687 library Address {
688     /**
689      * @dev Returns true if `account` is a contract.
690      *
691      * [IMPORTANT]
692      * ====
693      * It is unsafe to assume that an address for which this function returns
694      * false is an externally-owned account (EOA) and not a contract.
695      *
696      * Among others, `isContract` will return false for the following
697      * types of addresses:
698      *
699      *  - an externally-owned account
700      *  - a contract in construction
701      *  - an address where a contract will be created
702      *  - an address where a contract lived, but was destroyed
703      * ====
704      */
705     function isContract(address account) internal view returns (bool) {
706         // This method relies on extcodesize, which returns 0 for contracts in
707         // construction, since the code is only stored at the end of the
708         // constructor execution.
709 
710         uint256 size;
711         // solhint-disable-next-line no-inline-assembly
712         assembly { size := extcodesize(account) }
713         return size > 0;
714     }
715 
716     /**
717      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
718      * `recipient`, forwarding all available gas and reverting on errors.
719      *
720      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
721      * of certain opcodes, possibly making contracts go over the 2300 gas limit
722      * imposed by `transfer`, making them unable to receive funds via
723      * `transfer`. {sendValue} removes this limitation.
724      *
725      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
726      *
727      * IMPORTANT: because control is transferred to `recipient`, care must be
728      * taken to not create reentrancy vulnerabilities. Consider using
729      * {ReentrancyGuard} or the
730      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
731      */
732     function sendValue(address payable recipient, uint256 amount) internal {
733         require(address(this).balance >= amount, "Address: insufficient balance");
734 
735         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
736         (bool success, ) = recipient.call{ value: amount }("");
737         require(success, "Address: unable to send value, recipient may have reverted");
738     }
739 
740     /**
741      * @dev Performs a Solidity function call using a low level `call`. A
742      * plain`call` is an unsafe replacement for a function call: use this
743      * function instead.
744      *
745      * If `target` reverts with a revert reason, it is bubbled up by this
746      * function (like regular Solidity function calls).
747      *
748      * Returns the raw returned data. To convert to the expected return value,
749      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
750      *
751      * Requirements:
752      *
753      * - `target` must be a contract.
754      * - calling `target` with `data` must not revert.
755      *
756      * _Available since v3.1._
757      */
758     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
759       return functionCall(target, data, "Address: low-level call failed");
760     }
761 
762     /**
763      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
764      * `errorMessage` as a fallback revert reason when `target` reverts.
765      *
766      * _Available since v3.1._
767      */
768     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
769         return functionCallWithValue(target, data, 0, errorMessage);
770     }
771 
772     /**
773      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
774      * but also transferring `value` wei to `target`.
775      *
776      * Requirements:
777      *
778      * - the calling contract must have an ETH balance of at least `value`.
779      * - the called Solidity function must be `payable`.
780      *
781      * _Available since v3.1._
782      */
783     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
784         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
785     }
786 
787     /**
788      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
789      * with `errorMessage` as a fallback revert reason when `target` reverts.
790      *
791      * _Available since v3.1._
792      */
793     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
794         require(address(this).balance >= value, "Address: insufficient balance for call");
795         require(isContract(target), "Address: call to non-contract");
796 
797         // solhint-disable-next-line avoid-low-level-calls
798         (bool success, bytes memory returndata) = target.call{ value: value }(data);
799         return _verifyCallResult(success, returndata, errorMessage);
800     }
801 
802     /**
803      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
804      * but performing a static call.
805      *
806      * _Available since v3.3._
807      */
808     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
809         return functionStaticCall(target, data, "Address: low-level static call failed");
810     }
811 
812     /**
813      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
814      * but performing a static call.
815      *
816      * _Available since v3.3._
817      */
818     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
819         require(isContract(target), "Address: static call to non-contract");
820 
821         // solhint-disable-next-line avoid-low-level-calls
822         (bool success, bytes memory returndata) = target.staticcall(data);
823         return _verifyCallResult(success, returndata, errorMessage);
824     }
825 
826     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
827         if (success) {
828             return returndata;
829         } else {
830             // Look for revert reason and bubble it up if present
831             if (returndata.length > 0) {
832                 // The easiest way to bubble the revert reason is using memory via assembly
833 
834                 // solhint-disable-next-line no-inline-assembly
835                 assembly {
836                     let returndata_size := mload(returndata)
837                     revert(add(32, returndata), returndata_size)
838                 }
839             } else {
840                 revert(errorMessage);
841             }
842         }
843     }
844 }
845 
846 // File: @openzeppelin\contracts\introspection\ERC165.sol
847 
848 // SPDX_License_Identifier: MIT
849 
850 pragma solidity >=0.6.0 <0.8.0;
851 
852 
853 /**
854  * @dev Implementation of the {IERC165} interface.
855  *
856  * Contracts may inherit from this and call {_registerInterface} to declare
857  * their support of an interface.
858  */
859 abstract contract ERC165 is IERC165 {
860     /*
861      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
862      */
863     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
864 
865     /**
866      * @dev Mapping of interface ids to whether or not it's supported.
867      */
868     mapping(bytes4 => bool) private _supportedInterfaces;
869 
870     constructor () internal {
871         // Derived contracts need only register support for their own interfaces,
872         // we register support for ERC165 itself here
873         _registerInterface(_INTERFACE_ID_ERC165);
874     }
875 
876     /**
877      * @dev See {IERC165-supportsInterface}.
878      *
879      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
880      */
881     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
882         return _supportedInterfaces[interfaceId];
883     }
884 
885     /**
886      * @dev Registers the contract as an implementer of the interface defined by
887      * `interfaceId`. Support of the actual ERC165 interface is automatic and
888      * registering its interface id is not required.
889      *
890      * See {IERC165-supportsInterface}.
891      *
892      * Requirements:
893      *
894      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
895      */
896     function _registerInterface(bytes4 interfaceId) internal virtual {
897         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
898         _supportedInterfaces[interfaceId] = true;
899     }
900 }
901 
902 // File: node_modules\eth-item-token-standard\IEthItemMainInterface.sol
903 
904 // SPDX_License_Identifier: MIT
905 
906 
907 // File: eth-item-token-standard\EthItemMainInterface.sol
908 
909 // SPDX_License_Identifier: MIT
910 
911 
912 
913 
914 
915 
916 
917 
918 
919 
920 /**
921  * @title EthItem - An improved ERC1155 token with ERC20 trading capabilities.
922  * @dev In the EthItem standard, there is no a centralized storage where to save every objectId info.
923  * In fact every NFT data is saved in a specific ERC20 token that can also work as a standalone one, and let transfer parts of an atomic object.
924  * The ERC20 represents a unique Token Id, and its supply represents the entire supply of that Token Id.
925  * You can instantiate a EthItem as a brand-new one, or as a wrapper for pre-existent classic ERC1155 NFT.
926  * In the first case, you can introduce some particular permissions to mint new tokens.
927  * In the second case, you need to send your NFTs to the Wrapped EthItem (using the classic safeTransferFrom or safeBatchTransferFrom methods)
928  * and it will create a brand new ERC20 Token or mint new supply (in the case some tokens with the same id were transfered before yours).
929  */
930 contract EthItemMainInterface is IEthItemMainInterface, Context, ERC165 {
931     using SafeMath for uint256;
932     using Address for address;
933 
934     bytes4 internal constant _INTERFACEobjectId_ERC1155 = 0xd9b67a26;
935 
936     string internal _name;
937     string internal _symbol;
938 
939     mapping(uint256 => string) internal _objectUris;
940 
941     mapping(uint256 => address) internal _dest;
942     mapping(address => bool) internal _isMine;
943 
944     mapping(address => mapping(address => bool)) internal _operatorApprovals;
945 
946     address internal _interoperableInterfaceModel;
947     uint256 internal _interoperableInterfaceModelVersion;
948 
949     uint256 internal _decimals;
950 
951     /**
952      * @dev Constructor
953      * When you create a EthItem, you can specify if you want to create a brand new one, passing the classic data like name, symbol, amd URI,
954      * or wrap a pre-existent ERC1155 NFT, passing its contract address.
955      * You can use just one of the two modes at the same time.
956      * In both cases, a ERC20 token address is mandatory. It will be used as a model to be cloned for every minted NFT.
957      * @param erc20NFTWrapperModel the address of the ERC20 pre-deployed model. I will not be used in the procedure, but just cloned as a brand-new one every time a new NFT is minted.
958      * @param name the name of the brand new EthItem to be created. If you are wrapping a pre-existing ERC1155 NFT, this must be blank.
959      * @param symbol the symbol of the brand new EthItem to be created. If you are wrapping a pre-existing ERC1155 NFT, this must be blank.
960      */
961     constructor(
962         address erc20NFTWrapperModel,
963         string memory name,
964         string memory symbol
965     ) public {
966         if(erc20NFTWrapperModel != address(0)) {
967             init(erc20NFTWrapperModel, name, symbol);
968         }
969     }
970 
971     /**
972      * @dev Utility method which contains the logic of the constructor.
973      * This is a useful trick to instantiate a contract when it is cloned.
974      */
975     function init(
976         address interoperableInterfaceModel,
977         string memory name,
978         string memory symbol
979     ) public virtual override {
980         require(
981             _interoperableInterfaceModel == address(0),
982             "Init already called!"
983         );
984 
985         require(
986             interoperableInterfaceModel != address(0),
987             "Model should be a valid ethereum address"
988         );
989         _interoperableInterfaceModelVersion = IEthItemInteroperableInterface(_interoperableInterfaceModel = interoperableInterfaceModel).interoperableInterfaceVersion();
990         require(
991             keccak256(bytes(name)) != keccak256(""),
992             "Name is mandatory"
993         );
994         require(
995             keccak256(bytes(symbol)) != keccak256(""),
996             "Symbol is mandatory"
997         );
998 
999         _name = name;
1000         _symbol = symbol;
1001         _decimals = 18;
1002 
1003         _registerInterface(this.safeBatchTransferFrom.selector);
1004         _registerInterface(_INTERFACEobjectId_ERC1155);
1005         _registerInterface(this.balanceOf.selector);
1006         _registerInterface(this.balanceOfBatch.selector);
1007         _registerInterface(this.setApprovalForAll.selector);
1008         _registerInterface(this.isApprovedForAll.selector);
1009         _registerInterface(this.safeTransferFrom.selector);
1010         _registerInterface(this.uri.selector);
1011         _registerInterface(this.totalSupply.selector);
1012         _registerInterface(0x00ad800c); //name(uint256)
1013         _registerInterface(0x4e41a1fb); //symbol(uint256)
1014         _registerInterface(this.decimals.selector);
1015         _registerInterface(0x06fdde03); //name()
1016         _registerInterface(0x95d89b41); //symbol()
1017     }
1018 
1019     function mainInterfaceVersion() public pure virtual override returns(uint256) {
1020         return 1;
1021     }
1022 
1023     /**
1024      * @dev Mint
1025      * If the EthItem does not wrap a pre-existent NFT, this call is used to mint new NFTs, according to the permission rules provided by the Token creator.
1026      * @param amount The amount of tokens to be created. It must be greater than 1 unity.
1027      * @param objectUri The Uri to locate this new token's metadata.
1028      */
1029     function mint(uint256 amount, string memory objectUri)
1030         public
1031         virtual
1032         override
1033         returns (uint256 objectId, address tokenAddress)
1034     {
1035         require(
1036             amount > 1,
1037             "You need to pass more than a token"
1038         );
1039         require(
1040             keccak256(bytes(objectUri)) != keccak256(""),
1041             "Uri cannot be empty"
1042         );
1043         (objectId, tokenAddress) = _mint(msg.sender, amount);
1044         _objectUris[objectId] = objectUri;
1045     }
1046 
1047     /**
1048      * @dev Burn
1049      * You can choose to burn your NFTs.
1050      * In case this Token wraps a pre-existent ERC1155 NFT, you will receive the wrapped NFTs.
1051      */
1052     function burn(
1053         uint256 objectId,
1054         uint256 amount
1055     ) public virtual override {
1056         uint256[] memory objectIds = new uint256[](1);
1057         objectIds[0] = objectId;
1058         uint256[] memory amounts = new uint256[](1);
1059         amounts[0] = amount;
1060         _burn(msg.sender, objectIds, amounts);
1061         emit TransferSingle(msg.sender, msg.sender, address(0), objectId, amount);
1062     }
1063 
1064     /**
1065      * @dev Burn Batch
1066      * Same as burn, but for multiple NFTs at the same time
1067      */
1068     function burnBatch(
1069         uint256[] memory objectIds,
1070         uint256[] memory amounts
1071     ) public virtual override {
1072         _burn(msg.sender, objectIds, amounts);
1073         emit TransferBatch(msg.sender, msg.sender, address(0), objectIds, amounts);
1074     }
1075 
1076     function _burn(address owner, 
1077         uint256[] memory objectIds,
1078         uint256[] memory amounts) internal virtual {
1079         for (uint256 i = 0; i < objectIds.length; i++) {
1080             asInteroperable(objectIds[i]).burn(
1081                 owner,
1082                 toInteroperableInterfaceAmount(objectIds[i], amounts[i])
1083             );
1084         }
1085     }
1086 
1087     /**
1088      * @dev get the address of the ERC20 Contract used as a model
1089      */
1090     function interoperableInterfaceModel() public virtual override view returns (address, uint256) {
1091         return (_interoperableInterfaceModel, _interoperableInterfaceModelVersion);
1092     }
1093 
1094     /**
1095      * @dev Gives back the address of the ERC20 Token representing this Token Id
1096      */
1097     function asInteroperable(uint256 objectId)
1098         public
1099         virtual
1100         override
1101         view
1102         returns (IEthItemInteroperableInterface)
1103     {
1104         return IEthItemInteroperableInterface(_dest[objectId]);
1105     }
1106 
1107     /**
1108      * @dev Returns the total supply of the given token id
1109      * @param objectId the id of the token whose availability you want to know
1110      */
1111     function totalSupply(uint256 objectId)
1112         public
1113         virtual
1114         override
1115         view
1116         returns (uint256)
1117     {
1118         return toMainInterfaceAmount(objectId, asInteroperable(objectId).totalSupply());
1119     }
1120 
1121     /**
1122      * @dev Returns the name of the given token id
1123      * @param objectId the id of the token whose name you want to know
1124      */
1125     function name(uint256 objectId)
1126         public
1127         virtual
1128         override
1129         view
1130         returns (string memory)
1131     {
1132         return asInteroperable(objectId).name();
1133     }
1134 
1135     function name() public virtual override view returns (string memory) {
1136         return _name;
1137     }
1138 
1139     /**
1140      * @dev Returns the symbol of the given token id
1141      * @param objectId the id of the token whose symbol you want to know
1142      */
1143     function symbol(uint256 objectId)
1144         public
1145         virtual
1146         override
1147         view
1148         returns (string memory)
1149     {
1150         return asInteroperable(objectId).symbol();
1151     }
1152 
1153     function symbol() public virtual override view returns (string memory) {
1154         return _symbol;
1155     }
1156 
1157     /**
1158      * @dev Returns the decimals of the given token id
1159      */
1160     function decimals(uint256)
1161         public
1162         virtual
1163         override
1164         view
1165         returns (uint256)
1166     {
1167         return 1;
1168     }
1169 
1170     /**
1171      * @dev Returns the uri of the given token id
1172      * @param objectId the id of the token whose uri you want to know
1173      */
1174     function uri(uint256 objectId)
1175         public
1176         virtual
1177         override
1178         view
1179         returns (string memory)
1180     {
1181         return _objectUris[objectId];
1182     }
1183 
1184     /**
1185      * @dev Classic ERC1155 Standard Method
1186      */
1187     function balanceOf(address account, uint256 objectId)
1188         public
1189         virtual
1190         override
1191         view
1192         returns (uint256)
1193     {
1194         return toMainInterfaceAmount(objectId, asInteroperable(objectId).balanceOf(account));
1195     }
1196 
1197     /**
1198      * @dev Classic ERC1155 Standard Method
1199      */
1200     function balanceOfBatch(
1201         address[] memory accounts,
1202         uint256[] memory objectIds
1203     ) public virtual override view returns (uint256[] memory balances) {
1204         balances = new uint256[](accounts.length);
1205         for (uint256 i = 0; i < accounts.length; i++) {
1206             balances[i] = balanceOf(accounts[i], objectIds[i]);
1207         }
1208     }
1209 
1210     /**
1211      * @dev Classic ERC1155 Standard Method
1212      */
1213     function setApprovalForAll(address operator, bool approved)
1214         public
1215         virtual
1216         override
1217     {
1218         address sender = _msgSender();
1219         require(
1220             sender != operator,
1221             "ERC1155: setting approval status for self"
1222         );
1223 
1224         _operatorApprovals[sender][operator] = approved;
1225         emit ApprovalForAll(sender, operator, approved);
1226     }
1227 
1228     /**
1229      * @dev Classic ERC1155 Standard Method
1230      */
1231     function isApprovedForAll(address account, address operator)
1232         public
1233         virtual
1234         override
1235         view
1236         returns (bool)
1237     {
1238         return _operatorApprovals[account][operator];
1239     }
1240 
1241     /**
1242      * @dev Classic ERC1155 Standard Method
1243      */
1244     function safeTransferFrom(
1245         address from,
1246         address to,
1247         uint256 objectId,
1248         uint256 amount,
1249         bytes memory data
1250     ) public virtual override {
1251         require(to != address(0), "ERC1155: transfer to the zero address");
1252         address operator = _msgSender();
1253         require(
1254             from == operator || isApprovedForAll(from, operator),
1255             "ERC1155: caller is not owner nor approved"
1256         );
1257 
1258         asInteroperable(objectId).transferFrom(from, to, toInteroperableInterfaceAmount(objectId, amount));
1259 
1260         emit TransferSingle(operator, from, to, objectId, amount);
1261 
1262         _doSafeTransferAcceptanceCheck(
1263             operator,
1264             from,
1265             to,
1266             objectId,
1267             amount,
1268             data
1269         );
1270     }
1271 
1272     /**
1273      * @dev Classic ERC1155 Standard Method
1274      */
1275     function safeBatchTransferFrom(
1276         address from,
1277         address to,
1278         uint256[] memory objectIds,
1279         uint256[] memory amounts,
1280         bytes memory data
1281     ) public virtual override {
1282         require(to != address(0), "ERC1155: transfer to the zero address");
1283         require(
1284             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1285             "ERC1155: caller is not owner nor approved"
1286         );
1287 
1288         for (uint256 i = 0; i < objectIds.length; i++) {
1289             asInteroperable(objectIds[i]).transferFrom(
1290                 from,
1291                 to,
1292                 toInteroperableInterfaceAmount(objectIds[i], amounts[i])
1293             );
1294         }
1295 
1296         address operator = _msgSender();
1297 
1298         emit TransferBatch(operator, from, to, objectIds, amounts);
1299 
1300         _doSafeBatchTransferAcceptanceCheck(
1301             operator,
1302             from,
1303             to,
1304             objectIds,
1305             amounts,
1306             data
1307         );
1308     }
1309 
1310     function emitTransferSingleEvent(address sender, address from, address to, uint256 objectId, uint256 amount) public override {
1311         require(_dest[objectId] == msg.sender, "Unauthorized Action!");
1312         uint256 entireAmount = toMainInterfaceAmount(objectId, amount);
1313         if(entireAmount == 0) {
1314             return;
1315         }
1316         emit TransferSingle(sender, from, to, objectId, entireAmount);
1317     }
1318 
1319     function toInteroperableInterfaceAmount(uint256 objectId, uint256 mainInterfaceAmount) public override virtual view returns (uint256 interoperableInterfaceAmount) {
1320         interoperableInterfaceAmount = mainInterfaceAmount * (10**asInteroperable(objectId).decimals());
1321     }
1322 
1323     function toMainInterfaceAmount(uint256 objectId, uint256 interoperableInterfaceAmount) public override virtual view returns (uint256 mainInterfaceAmount) {
1324         mainInterfaceAmount = interoperableInterfaceAmount / (10**asInteroperable(objectId).decimals());
1325     }
1326 
1327     function _doSafeTransferAcceptanceCheck(
1328         address operator,
1329         address from,
1330         address to,
1331         uint256 id,
1332         uint256 amount,
1333         bytes memory data
1334     ) internal virtual {
1335         if (to.isContract()) {
1336             try
1337                 IERC1155Receiver(to).onERC1155Received(
1338                     operator,
1339                     from,
1340                     id,
1341                     amount,
1342                     data
1343                 )
1344             returns (bytes4 response) {
1345                 if (
1346                     response != IERC1155Receiver(to).onERC1155Received.selector
1347                 ) {
1348                     revert("ERC1155: ERC1155Receiver rejected tokens");
1349                 }
1350             } catch Error(string memory reason) {
1351                 revert(reason);
1352             } catch {
1353                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1354             }
1355         }
1356     }
1357 
1358     function _doSafeBatchTransferAcceptanceCheck(
1359         address operator,
1360         address from,
1361         address to,
1362         uint256[] memory ids,
1363         uint256[] memory amounts,
1364         bytes memory data
1365     ) internal virtual {
1366         if (to.isContract()) {
1367             try
1368                 IERC1155Receiver(to).onERC1155BatchReceived(
1369                     operator,
1370                     from,
1371                     ids,
1372                     amounts,
1373                     data
1374                 )
1375             returns (bytes4 response) {
1376                 if (
1377                     response !=
1378                     IERC1155Receiver(to).onERC1155BatchReceived.selector
1379                 ) {
1380                     revert("ERC1155: ERC1155Receiver rejected tokens");
1381                 }
1382             } catch Error(string memory reason) {
1383                 revert(reason);
1384             } catch {
1385                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1386             }
1387         }
1388     }
1389 
1390     function _clone(address original) internal returns (address copy) {
1391         assembly {
1392             mstore(
1393                 0,
1394                 or(
1395                     0x5880730000000000000000000000000000000000000000803b80938091923cF3,
1396                     mul(original, 0x1000000000000000000)
1397                 )
1398             )
1399             copy := create(0, 0, 32)
1400             switch extcodesize(copy)
1401                 case 0 {
1402                     invalid()
1403                 }
1404         }
1405     }
1406 
1407     function _mint(
1408         address from,
1409         uint256 amount
1410     ) internal virtual returns (uint256 objectId, address wrapperAddress) {
1411         IEthItemInteroperableInterface wrapper = IEthItemInteroperableInterface(wrapperAddress = _clone(_interoperableInterfaceModel));
1412         _isMine[_dest[objectId = uint256(wrapperAddress)] = wrapperAddress] = true;
1413         wrapper.init(objectId, _name, _symbol, _decimals);
1414         wrapper.mint(from, amount * (10**_decimals));
1415         emit NewItem(objectId, wrapperAddress);
1416         emit Mint(objectId, wrapperAddress, amount);
1417         emit TransferSingle(address(this), address(0), from, objectId, amount);
1418     }
1419 }
1420 
1421 // File: @openzeppelin\contracts\introspection\IERC165.sol
1422 
1423 // SPDX_License_Identifier: MIT
1424 
1425 pragma solidity >=0.6.0 <0.8.0;
1426 
1427 /**
1428  * @dev Interface of the ERC165 standard, as defined in the
1429  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1430  *
1431  * Implementers can declare support of contract interfaces, which can then be
1432  * queried by others ({ERC165Checker}).
1433  *
1434  * For an implementation, see {ERC165}.
1435  */
1436 
1437 // File: contracts\orchestrator\IEthItemOrchestratorDependantElement.sol
1438 
1439 //SPDX_License_Identifier: MIT
1440 
1441 
1442 
1443 
1444 interface IEthItemOrchestratorDependantElement is IERC165 {
1445 
1446     /**
1447      * @dev GET - The DoubleProxy of the DFO linked to this Contract
1448      */
1449     function doubleProxy() external view returns (address);
1450 
1451     /**
1452      * @dev SET - The DoubleProxy of the DFO linked to this Contract
1453      * It can be done only by the Factory controller
1454      * @param newDoubleProxy the new DoubleProxy address
1455      */
1456     function setDoubleProxy(address newDoubleProxy) external;
1457 
1458     function isAuthorizedOrchestrator(address operator) external view returns(bool);
1459 }
1460 
1461 // File: contracts\factory\IEthItemFactory.sol
1462 
1463 //SPDX_License_Identifier: MIT
1464 
1465 
1466 
1467 
1468 /**
1469  * @title IEthItemFactory
1470  * @dev This contract represents the Factory Used to deploy all the EthItems, keeping track of them.
1471  */
1472 interface IEthItemFactory is IEthItemOrchestratorDependantElement {
1473 
1474     function isModel(address modelAddress) external returns(bool);
1475 
1476     /**
1477      * @dev GET - The address of the Smart Contract whose code will serve as a model for all the EthItemERC20Wrappers (please see the eth-item-token-standard for further information).
1478      */
1479     function ethItemInteroperableInterfaceModel() external view returns (address ethItemInteroperableInterfaceModelAddress, uint256 ethItemInteroperableInterfaceModelVersion);
1480 
1481     /**
1482      * @dev SET - The address of the Smart Contract whose code will serve as a model for all the EthItemERC20Wrappers (please see the eth-item-token-standard for further information).
1483      * It can be done only by the Factory controller
1484      */
1485     function setEthItemInteroperableInterfaceModel(address ethItemInteroperableInterfaceModelAddress) external;
1486 
1487     /**
1488      * @dev GET - The address of the Smart Contract whose code will serve as a model for all the Native EthItems.
1489      * Every EthItem will have its own address, but the code will be cloned from this one.
1490      */
1491     function nativeModel() external view returns (address nativeModelAddress, uint256 nativeModelVersion);
1492 
1493     /**
1494      * @dev SET - The address of the Native EthItem model.
1495      * It can be done only by the Factory controller
1496      */
1497     function setNativeModel(address nativeModelAddress) external;
1498     function addNativeModel(address nativeModelAddress) external;
1499 
1500     event NativeModel(address indexed);
1501 
1502     /**
1503      * @dev GET - The address of the Smart Contract whose code will serve as a model for all the Wrapped ERC1155 EthItems.
1504      * Every EthItem will have its own address, but the code will be cloned from this one.
1505      */
1506     function erc1155WrapperModel() external view returns (address erc1155WrapperModelAddress, uint256 erc1155WrapperModelVersion);
1507 
1508     /**
1509      * @dev SET - The address of the ERC1155 NFT-Based EthItem model.
1510      * It can be done only by the Factory controller
1511      */
1512     function setERC1155WrapperModel(address erc1155WrapperModelAddress) external;
1513     function addERC1155WrapperModel(address erc1155WrapperModelAddress) external;
1514 
1515     event ERC1155WrapperModel(address indexed);
1516 
1517     /**
1518      * @dev GET - The address of the Smart Contract whose code will serve as a model for all the Wrapped ERC20 EthItems.
1519      */
1520     function erc20WrapperModel() external view returns (address erc20WrapperModelAddress, uint256 erc20WrapperModelVersion);
1521 
1522     /**
1523      * @dev SET - The address of the Smart Contract whose code will serve as a model for all the Wrapped ERC20 EthItems.
1524      * It can be done only by the Factory controller
1525      */
1526     function setERC20WrapperModel(address erc20WrapperModelAddress) external;
1527     function addERC20WrapperModel(address erc20WrapperModelAddress) external;
1528 
1529     event ERC20WrapperModel(address indexed);
1530 
1531     /**
1532      * @dev GET - The address of the Smart Contract whose code will serve as a model for all the Wrapped ERC721 EthItems.
1533      */
1534     function erc721WrapperModel() external view returns (address erc721WrapperModelAddress, uint256 erc721WrapperModelVersion);
1535 
1536     /**
1537      * @dev SET - The address of the Smart Contract whose code will serve as a model for all the Wrapped ERC721 EthItems.
1538      * It can be done only by the Factory controller
1539      */
1540     function setERC721WrapperModel(address erc721WrapperModelAddress) external;
1541     function addERC721WrapperModel(address erc721WrapperModelAddress) external;
1542 
1543     event ERC721WrapperModel(address indexed);
1544 
1545     /**
1546      * @dev GET - The elements (numerator and denominator) useful to calculate the percentage fee to be transfered to the DFO for every new Minted EthItem
1547      */
1548     function mintFeePercentage() external view returns (uint256 mintFeePercentageNumerator, uint256 mintFeePercentageDenominator);
1549 
1550     /**
1551      * @dev SET - The element useful to calculate the Percentage fee
1552      * It can be done only by the Factory controller
1553      */
1554     function setMintFeePercentage(uint256 mintFeePercentageNumerator, uint256 mintFeePercentageDenominator) external;
1555 
1556     /**
1557      * @dev Useful utility method to calculate the percentage fee to transfer to the DFO for the minted EthItem amount.
1558      * @param erc20WrapperAmount The amount of minted EthItem
1559      */
1560     function calculateMintFee(uint256 erc20WrapperAmount) external view returns (uint256 mintFee, address dfoWalletAddress);
1561 
1562     /**
1563      * @dev GET - The elements (numerator and denominator) useful to calculate the percentage fee to be transfered to the DFO for every Burned EthItem
1564      */
1565     function burnFeePercentage() external view returns (uint256 burnFeePercentageNumerator, uint256 burnFeePercentageDenominator);
1566 
1567     /**
1568      * @dev SET - The element useful to calculate the Percentage fee
1569      * It can be done only by the Factory controller
1570      */
1571     function setBurnFeePercentage(uint256 burnFeePercentageNumerator, uint256 burnFeePercentageDenominator) external;
1572 
1573     /**
1574      * @dev Useful utility method to calculate the percentage fee to transfer to the DFO for the burned EthItem amount.
1575      * @param erc20WrapperAmount The amount of burned EthItem
1576      */
1577     function calculateBurnFee(uint256 erc20WrapperAmount) external view returns (uint256 burnFee, address dfoWalletAddress);
1578 
1579     /**
1580      * @dev Business Logic to create a brand-new EthItem.
1581      * It raises the 'NewNativeCreated' events.
1582      * @param modelInitCallPayload The ABI-encoded input parameters to be passed to the model to phisically create the NFT.
1583      * It changes according to the Model Version.
1584      * @param ethItemAddress The address of the new EthItem
1585      * @param ethItemInitResponse The ABI-encoded output response eventually received by the Model initialization procedure.
1586      */
1587     function createNative(address modelAddress, bytes calldata modelInitCallPayload) external returns (address ethItemAddress, bytes memory ethItemInitResponse);
1588 
1589     event NewNativeCreated(uint256 indexed standardVersion, uint256 indexed wrappedItemModelVersion, uint256 indexed modelVersion, address tokenCreated);
1590     event NewNativeCreated(address indexed model, uint256 indexed modelVersion, address indexed tokenCreated, address creator);
1591 
1592     /**
1593      * @dev Business Logic to wrap already existing ERC1155 Tokens to obtain a new NFT-Based EthItem.
1594      * It raises the 'NewWrappedERC1155Created' events.
1595      * @param modelInitCallPayload The ABI-encoded input parameters to be passed to the model to phisically create the NFT.
1596      * It changes according to the Model Version.
1597      * @param ethItemAddress The address of the new EthItem
1598      * @param ethItemInitResponse The ABI-encoded output response eventually received by the Model initialization procedure.
1599      */
1600     function createWrappedERC1155(address modelAddress, bytes calldata modelInitCallPayload) external returns (address ethItemAddress, bytes memory ethItemInitResponse);
1601 
1602     event NewWrappedERC1155Created(uint256 indexed standardVersion, uint256 indexed wrappedItemModelVersion, uint256 indexed modelVersion, address tokenCreated);
1603     event NewWrappedERC1155Created(address indexed model, uint256 indexed modelVersion, address indexed tokenCreated, address creator);
1604 
1605     /**
1606      * @dev Business Logic to wrap already existing ERC20 Tokens to obtain a new NFT-Based EthItem.
1607      * It raises the 'NewWrappedERC20Created' events.
1608      * @param modelInitCallPayload The ABI-encoded input parameters to be passed to the model to phisically create the NFT.
1609      * It changes according to the Model Version.
1610      * @param ethItemAddress The address of the new EthItem
1611      * @param ethItemInitResponse The ABI-encoded output response eventually received by the Model initialization procedure.
1612      */
1613     function createWrappedERC20(bytes calldata modelInitCallPayload) external returns (address ethItemAddress, bytes memory ethItemInitResponse);
1614 
1615     event NewWrappedERC20Created(uint256 indexed standardVersion, uint256 indexed wrappedItemModelVersion, uint256 indexed modelVersion, address tokenCreated);
1616     event NewWrappedERC20Created(address indexed model, uint256 indexed modelVersion, address indexed tokenCreated, address creator);
1617 
1618     /**
1619      * @dev Business Logic to wrap already existing ERC721 Tokens to obtain a new NFT-Based EthItem.
1620      * It raises the 'NewWrappedERC721Created' events.
1621      * @param modelInitCallPayload The ABI-encoded input parameters to be passed to the model to phisically create the NFT.
1622      * It changes according to the Model Version.
1623      * @param ethItemAddress The address of the new EthItem
1624      * @param ethItemInitResponse The ABI-encoded output response eventually received by the Model initialization procedure.
1625      */
1626     function createWrappedERC721(address modelAddress, bytes calldata modelInitCallPayload) external returns (address ethItemAddress, bytes memory ethItemInitResponse);
1627 
1628     event NewWrappedERC721Created(uint256 indexed standardVersion, uint256 indexed wrappedItemModelVersion, uint256 indexed modelVersion, address tokenCreated);
1629     event NewWrappedERC721Created(address indexed model, uint256 indexed modelVersion, address indexed tokenCreated, address creator);
1630 }
1631 
1632 // File: contracts\models\common\EthItemModelBase.sol
1633 
1634 //SPDX_License_Identifier: MIT
1635 
1636 
1637 
1638 
1639 
1640 
1641 abstract contract EthItemModelBase is IEthItemModelBase, EthItemMainInterface(address(0), "", "") {
1642 
1643     address internal _factoryAddress;
1644 
1645     function init(
1646         address,
1647         string memory,
1648         string memory
1649     ) public virtual override(IEthItemMainInterface, EthItemMainInterface) {
1650         revert("Cannot directly call this method.");
1651     }
1652 
1653     function init(
1654         string memory name,
1655         string memory symbol
1656     ) public override virtual {
1657         require(_factoryAddress == address(0), "Init already called!");
1658         (address ethItemInteroperableInterfaceModelAddress,) = IEthItemFactory(_factoryAddress = msg.sender).ethItemInteroperableInterfaceModel();
1659         super.init(ethItemInteroperableInterfaceModelAddress, name, symbol);
1660     }
1661 
1662     function modelVersion() public override virtual pure returns(uint256) {
1663         return 1;
1664     }
1665 
1666     function factory() public override view returns (address) {
1667         return _factoryAddress;
1668     }
1669 
1670     function _sendMintFeeToDFO(address from, uint256 objectId, uint256 erc20WrapperAmount) internal virtual returns(uint256 mintFeeToDFO) {
1671         address dfoWallet;
1672         (mintFeeToDFO, dfoWallet) = IEthItemFactory(_factoryAddress).calculateMintFee(erc20WrapperAmount);
1673         if(mintFeeToDFO > 0 && dfoWallet != address(0)) {
1674             asInteroperable(objectId).transferFrom(from, dfoWallet, mintFeeToDFO);
1675         }
1676     }
1677 
1678     function _sendBurnFeeToDFO(address from, uint256 objectId, uint256 erc20WrapperAmount) internal virtual returns(uint256 burnFeeToDFO) {
1679         address dfoWallet;
1680         (burnFeeToDFO, dfoWallet) = IEthItemFactory(_factoryAddress).calculateBurnFee(erc20WrapperAmount);
1681         if(burnFeeToDFO > 0 && dfoWallet != address(0)) {
1682             asInteroperable(objectId).transferFrom(from, dfoWallet, burnFeeToDFO);
1683         }
1684     }
1685 
1686     function mint(uint256, string memory)
1687         public
1688         virtual
1689         override(IEthItemMainInterface, EthItemMainInterface)
1690         returns (uint256, address)
1691     {
1692         revert("Cannot directly call this method.");
1693     }
1694 
1695     function safeTransferFrom(
1696         address from,
1697         address to,
1698         uint256 objectId,
1699         uint256 amount,
1700         bytes memory data
1701     ) public virtual override(IERC1155, EthItemMainInterface) {
1702         require(to != address(0), "ERC1155: transfer to the zero address");
1703         address operator = _msgSender();
1704         require(
1705             from == operator || isApprovedForAll(from, operator),
1706             "ERC1155: caller is not owner nor approved"
1707         );
1708 
1709         _doERC20Transfer(from, to, objectId, amount);
1710 
1711         emit TransferSingle(operator, from, to, objectId, amount);
1712 
1713         _doSafeTransferAcceptanceCheck(
1714             operator,
1715             from,
1716             to,
1717             objectId,
1718             amount,
1719             data
1720         );
1721     }
1722 
1723     /**
1724      * @dev Classic ERC1155 Standard Method
1725      */
1726     function safeBatchTransferFrom(
1727         address from,
1728         address to,
1729         uint256[] memory objectIds,
1730         uint256[] memory amounts,
1731         bytes memory data
1732     ) public virtual override(IERC1155, EthItemMainInterface) {
1733         require(to != address(0), "ERC1155: transfer to the zero address");
1734         require(
1735             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1736             "ERC1155: caller is not owner nor approved"
1737         );
1738 
1739         for (uint256 i = 0; i < objectIds.length; i++) {
1740             _doERC20Transfer(from, to, objectIds[i], amounts[i]);
1741         }
1742 
1743         address operator = _msgSender();
1744 
1745         emit TransferBatch(operator, from, to, objectIds, amounts);
1746 
1747         _doSafeBatchTransferAcceptanceCheck(
1748             operator,
1749             from,
1750             to,
1751             objectIds,
1752             amounts,
1753             data
1754         );
1755     }
1756 
1757     function _doERC20Transfer(address from, address to, uint256 objectId, uint256 amount) internal virtual {
1758         (,uint256 result) = _getCorrectERC20ValueForTransferOrBurn(from, objectId, amount);
1759         asInteroperable(objectId).transferFrom(from, to, result);
1760     }
1761 
1762     function _getCorrectERC20ValueForTransferOrBurn(address from, uint256 objectId, uint256 amount) internal virtual view returns(uint256 balanceOfNormal, uint256 result) {
1763         uint256 toTransfer = toInteroperableInterfaceAmount(objectId, amount);
1764         uint256 balanceOfDecimals = asInteroperable(objectId).balanceOf(from);
1765         balanceOfNormal = balanceOf(from, objectId);
1766         result = amount == balanceOfNormal ? balanceOfDecimals : toTransfer;
1767     }
1768 
1769     function _burn(
1770         uint256 objectId,
1771         uint256 amount
1772     ) internal virtual returns(uint256 burnt, uint256 burnFeeToDFO) {
1773         (uint256 balanceOfNormal, uint256 result) = _getCorrectERC20ValueForTransferOrBurn(msg.sender, objectId, amount);
1774         require(balanceOfNormal >= amount, "Insufficient Amount");
1775         burnFeeToDFO = _sendBurnFeeToDFO(msg.sender, objectId, result);
1776         asInteroperable(objectId).burn(msg.sender, burnt = result - burnFeeToDFO);
1777     }
1778 
1779     function _isUnique(uint256 objectId) internal virtual view returns (bool unique, uint256 unity, uint256 totalSupply, uint256 erc20Decimals) {
1780         erc20Decimals = asInteroperable(objectId).decimals();
1781         unity = erc20Decimals <= 1 ? 1 : (10**erc20Decimals);
1782         totalSupply = asInteroperable(objectId).totalSupply();
1783         unique = totalSupply <= unity;
1784     }
1785 
1786     function toMainInterfaceAmount(uint256 objectId, uint256 interoperableInterfaceAmount) public virtual view override(IEthItemMainInterface, EthItemMainInterface) returns (uint256 mainInterfaceAmount) {
1787         (bool unique, uint256 unity,, uint256 erc20Decimals) = _isUnique(objectId);
1788         if(unique && interoperableInterfaceAmount < unity) {
1789             uint256 half = (unity * 51) / 100;
1790             return mainInterfaceAmount = interoperableInterfaceAmount <= half ? 0 : 1;
1791         }
1792         return mainInterfaceAmount = interoperableInterfaceAmount / (10**erc20Decimals);
1793     }
1794 }
1795 
1796 // File: eth-item-token-standard\IERC20Data.sol
1797 
1798 // SPDX_License_Identifier: MIT
1799 
1800 
1801 
1802 
1803 
1804 
1805 // File: contracts\models\ERC20Wrapper\1\ERC20WrapperV1.sol
1806 
1807 //SPDX_License_Identifier: MIT
1808 
1809 
1810 
1811 
1812 
1813 
1814 contract ERC20WrapperV1 is IERC20WrapperV1, EthItemModelBase {
1815 
1816     uint256 public constant ETHEREUM_OBJECT_ID = uint256(keccak256(bytes("THE ETHEREUM OBJECT IT")));
1817 
1818     mapping(uint256 => address) internal _sources;
1819     mapping(uint256 => uint256) internal _decimalsMap;
1820     mapping(address => uint256) internal _objects;
1821 
1822     function init(
1823         string memory name,
1824         string memory symbol
1825     ) public virtual override(IEthItemModelBase, EthItemModelBase) {
1826         super.init(name, symbol);
1827         (address interoperableInterfaceModelAddress,) = interoperableInterfaceModel();
1828         _isMine[_dest[ETHEREUM_OBJECT_ID] = _clone(interoperableInterfaceModelAddress)] = true;
1829         IEthItemInteroperableInterface(_dest[ETHEREUM_OBJECT_ID]).init(ETHEREUM_OBJECT_ID, "EthereumItem", "IETH", _decimalsMap[ETHEREUM_OBJECT_ID] = _decimals);
1830         emit NewItem(ETHEREUM_OBJECT_ID, _dest[ETHEREUM_OBJECT_ID]);
1831         emit Mint(ETHEREUM_OBJECT_ID, _dest[ETHEREUM_OBJECT_ID], 0);
1832     }
1833 
1834     function source(uint256 objectId) public override virtual view returns (address erc20TokenAddress) {
1835         erc20TokenAddress = _sources[objectId];
1836     }
1837 
1838     function object(address erc20TokenAddress) public override virtual view returns (uint256 objectId) {
1839         objectId = _objects[erc20TokenAddress];
1840     }
1841 
1842     function mintETH() public virtual payable override returns (uint256 objectId, address wrapperAddress) {
1843         require(msg.value > 0, "Insufficient amount");
1844         _mintItems(objectId = ETHEREUM_OBJECT_ID, wrapperAddress = _dest[ETHEREUM_OBJECT_ID], msg.value);
1845     }
1846 
1847     function mint(address erc20TokenAddress, uint256 amount)
1848         public
1849         virtual
1850         override
1851         returns (uint256 objectId, address wrapperAddress)
1852     {
1853         wrapperAddress = _dest[objectId = _objects[erc20TokenAddress]];
1854         if (wrapperAddress == address(0)) {
1855             (address interoperableInterfaceModelAddress,) = interoperableInterfaceModel();
1856             objectId = uint256(wrapperAddress = _clone(interoperableInterfaceModelAddress));
1857             _isMine[_dest[objectId] = wrapperAddress] = true;
1858             _sources[objectId] = erc20TokenAddress;
1859             _objects[erc20TokenAddress] = objectId;
1860             (string memory name, string memory symbol, uint256 dec) = _getMintData(erc20TokenAddress);
1861             _decimalsMap[objectId] = dec;
1862             IEthItemInteroperableInterface(wrapperAddress).init(objectId, name, symbol, _decimals);
1863             emit NewItem(objectId, wrapperAddress);
1864         }
1865         uint256 balanceBefore = IERC20Data(erc20TokenAddress).balanceOf(address(this));
1866         _safeTransferFrom(IERC20Data(erc20TokenAddress), msg.sender, address(this), amount);
1867         _mintItems(objectId, wrapperAddress, IERC20Data(erc20TokenAddress).balanceOf(address(this)) - balanceBefore);
1868     }
1869 
1870     function _mintItems(uint256 objectId, address wrapperAddress, uint256 amount) internal virtual {
1871         uint256 itemAmountDecimals = amount * _itemDecimals(objectId);
1872         asInteroperable(objectId).mint(msg.sender, itemAmountDecimals);
1873         uint256 itemAmount = itemAmountDecimals - _sendMintFeeToDFO(msg.sender, objectId, itemAmountDecimals);
1874         if(itemAmount > 0) {
1875             emit Mint(objectId, wrapperAddress, itemAmount);
1876             emit TransferSingle(address(this), address(0), msg.sender, objectId, itemAmount);
1877         }
1878     }
1879 
1880     function burn(
1881         uint256 objectId,
1882         uint256 amount
1883     ) public virtual override(IEthItemMainInterface) {
1884         _burn(objectId, amount);
1885         emit TransferSingle(msg.sender, msg.sender, address(0), objectId, amount);
1886     }
1887 
1888     function burnBatch(
1889         uint256[] memory objectIds,
1890         uint256[] memory amounts
1891     ) public virtual override(IEthItemMainInterface) {
1892         for (uint256 i = 0; i < objectIds.length; i++) {
1893             _burn(objectIds[i], amounts[i]);
1894         }
1895         emit TransferBatch(msg.sender, msg.sender, address(0), objectIds, amounts);
1896     }
1897 
1898     function _burn(
1899         uint256 objectId,
1900         uint256 amount
1901     ) internal virtual override returns(uint256 burnt, uint256) {
1902         (burnt,) = super._burn(objectId, amount);
1903         uint256 value = burnt / _itemDecimals(objectId);
1904         if(objectId == ETHEREUM_OBJECT_ID) {
1905             msg.sender.transfer(value);
1906         } else {
1907             _safeTransfer(IERC20Data(source(objectId)), msg.sender, value);
1908         }
1909     }
1910 
1911     function _getMintData(address erc20TokenAddress)
1912         internal
1913         virtual
1914         view
1915         returns (
1916             string memory name,
1917             string memory symbol,
1918             uint256 dec
1919         )
1920     {
1921         IERC20Data erc20Token = IERC20Data(erc20TokenAddress);
1922         name = string(abi.encodePacked(_stringValue(erc20Token, "name()", "NAME()"), " item"));
1923         symbol = string(abi.encodePacked("i", _stringValue(erc20Token, "symbol()", "SYMBOL()")));
1924         dec = _safeDecimals(erc20Token);
1925         if(dec == 0) {
1926             dec = _decimals;
1927         }
1928     }
1929 
1930     function _itemDecimals(uint256 objectId) internal view returns(uint256) {
1931         return (10**(_decimals - _decimalsMap[objectId]));
1932     }
1933 
1934     function _safeTransfer(IERC20Data erc20Token, address to, uint256 value) internal {
1935         bytes memory returnData = _call(address(erc20Token), abi.encodeWithSelector(erc20Token.transfer.selector, to, value));
1936         require(returnData.length == 0 || abi.decode(returnData, (bool)), 'TRANSFER_FAILED');
1937     }
1938 
1939     function _safeTransferFrom(IERC20Data erc20Token, address from, address to, uint256 value) private {
1940         bytes memory returnData = _call(address(erc20Token), abi.encodeWithSelector(erc20Token.transferFrom.selector, from, to, value));
1941         require(returnData.length == 0 || abi.decode(returnData, (bool)), 'TRANSFERFROM_FAILED');
1942     }
1943 
1944     function _call(address location, bytes memory payload) private returns(bytes memory returnData) {
1945         assembly {
1946             let result := call(gas(), location, 0, add(payload, 0x20), mload(payload), 0, 0)
1947             let size := returndatasize()
1948             returnData := mload(0x40)
1949             mstore(returnData, size)
1950             let returnDataPayloadStart := add(returnData, 0x20)
1951             returndatacopy(returnDataPayloadStart, 0, size)
1952             mstore(0x40, add(returnDataPayloadStart, size))
1953             switch result case 0 {revert(returnDataPayloadStart, size)}
1954         }
1955     }
1956 
1957     function _safeDecimals(IERC20Data erc20Token) internal view returns(uint256 dec) {
1958         (, bytes memory data) = address(erc20Token).staticcall(abi.encodeWithSelector(erc20Token.decimals.selector));
1959         dec = data.length == 0 ? 0 : abi.decode(data, (uint256));
1960     }
1961 
1962     function _stringValue(IERC20Data erc20Token, string memory firstTry, string memory secondTry) internal view returns(string memory) {
1963         (bool success, bytes memory data) = address(erc20Token).staticcall{ gas: 20000 }(abi.encodeWithSignature(firstTry));
1964         if (!success) {
1965             (success, data) = address(erc20Token).staticcall{ gas: 20000 }(abi.encodeWithSignature(secondTry));
1966         }
1967 
1968         if (success && data.length >= 96) {
1969             (uint256 offset, uint256 len) = abi.decode(data, (uint256, uint256));
1970             if (offset == 0x20 && len > 0 && len <= 256) {
1971                 return string(abi.decode(data, (bytes)));
1972             }
1973         }
1974 
1975         if (success && data.length == 32) {
1976             uint len = 0;
1977             while (len < data.length && data[len] >= 0x20 && data[len] <= 0x7E) {
1978                 len++;
1979             }
1980 
1981             if (len > 0) {
1982                 bytes memory result = new bytes(len);
1983                 for (uint i = 0; i < len; i++) {
1984                     result[i] = data[i];
1985                 }
1986                 return string(result);
1987             }
1988         }
1989 
1990         return _toHex(abi.encodePacked(address(erc20Token)));
1991     }
1992 
1993     function _toHex(bytes memory data) private pure returns(string memory) {
1994         bytes memory str = new bytes(2 + data.length * 2);
1995         str[0] = "0";
1996         str[1] = "x";
1997         uint j = 2;
1998         for (uint i = 0; i < data.length; i++) {
1999             uint a = uint8(data[i]) >> 4;
2000             uint b = uint8(data[i]) & 0x0f;
2001             str[j++] = byte(uint8(a + 48 + (a/10)*39));
2002             str[j++] = byte(uint8(b + 48 + (b/10)*39));
2003         }
2004 
2005         return string(str);
2006     }
2007 
2008     function decimals(uint256 objectId)
2009         public
2010         view
2011         virtual
2012         override
2013         returns (uint256)
2014     {
2015         return asInteroperable(objectId).decimals();
2016     }
2017 
2018     function toInteroperableInterfaceAmount(uint256, uint256 mainInterfaceAmount) public override virtual view returns (uint256 interoperableInterfaceAmount) {
2019         interoperableInterfaceAmount = mainInterfaceAmount;
2020     }
2021 
2022     function toMainInterfaceAmount(uint256, uint256 interoperableInterfaceAmount) public override(IEthItemMainInterface, EthItemModelBase) virtual view returns (uint256 mainInterfaceAmount) {
2023         mainInterfaceAmount = interoperableInterfaceAmount;
2024     }
2025 }