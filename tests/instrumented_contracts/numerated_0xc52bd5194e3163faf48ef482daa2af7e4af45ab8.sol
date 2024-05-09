1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @title ERC721 token receiver interface
80  * @dev Interface for any contract that wants to support safeTransfers
81  * from ERC721 asset contracts.
82  */
83 interface IERC721Receiver {
84     /**
85      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
86      * by `operator` from `from`, this function is called.
87      *
88      * It must return its Solidity selector to confirm the token transfer.
89      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
90      *
91      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
92      */
93     function onERC721Received(
94         address operator,
95         address from,
96         uint256 tokenId,
97         bytes calldata data
98     ) external returns (bytes4);
99 }
100 
101 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
102 
103 
104 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 /**
109  * @dev Interface of the ERC165 standard, as defined in the
110  * https://eips.ethereum.org/EIPS/eip-165[EIP].
111  *
112  * Implementers can declare support of contract interfaces, which can then be
113  * queried by others ({ERC165Checker}).
114  *
115  * For an implementation, see {ERC165}.
116  */
117 interface IERC165 {
118     /**
119      * @dev Returns true if this contract implements the interface defined by
120      * `interfaceId`. See the corresponding
121      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
122      * to learn more about how these ids are created.
123      *
124      * This function call must use less than 30 000 gas.
125      */
126     function supportsInterface(bytes4 interfaceId) external view returns (bool);
127 }
128 
129 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
130 
131 
132 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
133 
134 pragma solidity ^0.8.0;
135 
136 
137 /**
138  * @dev Implementation of the {IERC165} interface.
139  *
140  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
141  * for the additional interface id that will be supported. For example:
142  *
143  * ```solidity
144  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
145  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
146  * }
147  * ```
148  *
149  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
150  */
151 abstract contract ERC165 is IERC165 {
152     /**
153      * @dev See {IERC165-supportsInterface}.
154      */
155     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
156         return interfaceId == type(IERC165).interfaceId;
157     }
158 }
159 
160 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
161 
162 
163 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
164 
165 pragma solidity ^0.8.0;
166 
167 
168 /**
169  * @dev Required interface of an ERC721 compliant contract.
170  */
171 interface IERC721 is IERC165 {
172     /**
173      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
174      */
175     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
176 
177     /**
178      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
179      */
180     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
181 
182     /**
183      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
184      */
185     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
186 
187     /**
188      * @dev Returns the number of tokens in ``owner``'s account.
189      */
190     function balanceOf(address owner) external view returns (uint256 balance);
191 
192     /**
193      * @dev Returns the owner of the `tokenId` token.
194      *
195      * Requirements:
196      *
197      * - `tokenId` must exist.
198      */
199     function ownerOf(uint256 tokenId) external view returns (address owner);
200 
201     /**
202      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
203      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
204      *
205      * Requirements:
206      *
207      * - `from` cannot be the zero address.
208      * - `to` cannot be the zero address.
209      * - `tokenId` token must exist and be owned by `from`.
210      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
211      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
212      *
213      * Emits a {Transfer} event.
214      */
215     function safeTransferFrom(
216         address from,
217         address to,
218         uint256 tokenId
219     ) external;
220 
221     /**
222      * @dev Transfers `tokenId` token from `from` to `to`.
223      *
224      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
225      *
226      * Requirements:
227      *
228      * - `from` cannot be the zero address.
229      * - `to` cannot be the zero address.
230      * - `tokenId` token must be owned by `from`.
231      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
232      *
233      * Emits a {Transfer} event.
234      */
235     function transferFrom(
236         address from,
237         address to,
238         uint256 tokenId
239     ) external;
240 
241     /**
242      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
243      * The approval is cleared when the token is transferred.
244      *
245      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
246      *
247      * Requirements:
248      *
249      * - The caller must own the token or be an approved operator.
250      * - `tokenId` must exist.
251      *
252      * Emits an {Approval} event.
253      */
254     function approve(address to, uint256 tokenId) external;
255 
256     /**
257      * @dev Returns the account approved for `tokenId` token.
258      *
259      * Requirements:
260      *
261      * - `tokenId` must exist.
262      */
263     function getApproved(uint256 tokenId) external view returns (address operator);
264 
265     /**
266      * @dev Approve or remove `operator` as an operator for the caller.
267      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
268      *
269      * Requirements:
270      *
271      * - The `operator` cannot be the caller.
272      *
273      * Emits an {ApprovalForAll} event.
274      */
275     function setApprovalForAll(address operator, bool _approved) external;
276 
277     /**
278      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
279      *
280      * See {setApprovalForAll}
281      */
282     function isApprovedForAll(address owner, address operator) external view returns (bool);
283 
284     /**
285      * @dev Safely transfers `tokenId` token from `from` to `to`.
286      *
287      * Requirements:
288      *
289      * - `from` cannot be the zero address.
290      * - `to` cannot be the zero address.
291      * - `tokenId` token must exist and be owned by `from`.
292      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
293      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
294      *
295      * Emits a {Transfer} event.
296      */
297     function safeTransferFrom(
298         address from,
299         address to,
300         uint256 tokenId,
301         bytes calldata data
302     ) external;
303 }
304 
305 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
306 
307 
308 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
309 
310 pragma solidity ^0.8.0;
311 
312 
313 /**
314  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
315  * @dev See https://eips.ethereum.org/EIPS/eip-721
316  */
317 interface IERC721Metadata is IERC721 {
318     /**
319      * @dev Returns the token collection name.
320      */
321     function name() external view returns (string memory);
322 
323     /**
324      * @dev Returns the token collection symbol.
325      */
326     function symbol() external view returns (string memory);
327 
328     /**
329      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
330      */
331     function tokenURI(uint256 tokenId) external view returns (string memory);
332 }
333 
334 // File: contracts/IterableMapping.sol
335 
336 
337 pragma solidity ^0.8.0;
338 
339 library IterableMapping {
340   // Iterable mapping from address to uint;
341   struct Map {
342     address[] keys;
343     mapping(address => uint256) values;
344     mapping(address => uint256) indexOf;
345     mapping(address => bool) inserted;
346   }
347 
348   function get(Map storage map, address key) public view returns (uint256) {
349     return map.values[key];
350   }
351 
352   function getIndexOfKey(Map storage map, address key)
353     public
354     view
355     returns (int256)
356   {
357     if (!map.inserted[key]) {
358       return -1;
359     }
360     return int256(map.indexOf[key]);
361   }
362 
363   function getKeyAtIndex(Map storage map, uint256 index)
364     public
365     view
366     returns (address)
367   {
368     return map.keys[index];
369   }
370 
371   function size(Map storage map) public view returns (uint256) {
372     return map.keys.length;
373   }
374 
375   function set(
376     Map storage map,
377     address key,
378     uint256 val
379   ) public {
380     if (map.inserted[key]) {
381       map.values[key] = val;
382     } else {
383       map.inserted[key] = true;
384       map.values[key] = val;
385       map.indexOf[key] = map.keys.length;
386       map.keys.push(key);
387     }
388   }
389 
390   function remove(Map storage map, address key) public {
391     if (!map.inserted[key]) {
392       return;
393     }
394 
395     delete map.inserted[key];
396     delete map.values[key];
397 
398     uint256 index = map.indexOf[key];
399     uint256 lastIndex = map.keys.length - 1;
400     address lastKey = map.keys[lastIndex];
401 
402     map.indexOf[lastKey] = index;
403     delete map.indexOf[key];
404 
405     map.keys[index] = lastKey;
406     map.keys.pop();
407   }
408 }
409 
410 // File: contracts/IUniswapV2Factory.sol
411 
412 
413 
414 pragma solidity >=0.5.0;
415 
416 interface IUniswapV2Factory {
417     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
418 
419     function feeTo() external view returns (address);
420     function feeToSetter() external view returns (address);
421 
422     function getPair(address tokenA, address tokenB) external view returns (address pair);
423     function allPairs(uint) external view returns (address pair);
424     function allPairsLength() external view returns (uint);
425 
426     function createPair(address tokenA, address tokenB) external returns (address pair);
427 
428     function setFeeTo(address) external;
429     function setFeeToSetter(address) external;
430 }
431 // File: contracts/INodeManager.sol
432 
433 
434 pragma solidity ^0.8.0;
435 
436 interface INodeManager {
437   struct NodeEntity {
438     string name;
439     uint256 creationTime;
440     uint256 lastClaimTime;
441     uint256 amount;
442     uint256 tier;
443     uint256 totalClaimed;
444   }
445 
446   function getNodePrice(uint256 _tierIndex) external view returns (uint256);
447 
448   function createNode(
449     address account,
450     string memory nodeName,
451     uint256 tier
452   ) external;
453 
454   function getNodeReward(address account, uint256 _creationTime)
455     external
456     view
457     returns (uint256);
458 
459   function getAllNodesRewards(address account) external view returns (uint256);
460 
461   function cashoutNodeReward(address account, uint256 _creationTime) external;
462 
463   function cashoutAllNodesRewards(address account) external;
464 
465   function getAllNodes(address account)
466     external
467     view
468     returns (NodeEntity[] memory);
469 
470   function getNodeFee(
471     address account,
472     uint256 _creationTime,
473     uint256 _rewardAmount
474   ) external returns (uint256);
475 
476   function getAllNodesFee(address account, uint256 _rewardAmount)
477     external
478     returns (uint256);
479 }
480 
481 // File: contracts/IUniswapV2Router01.sol
482 
483 
484 pragma solidity >=0.6.2;
485 
486 interface IUniswapV2Router01 {
487     function factory() external pure returns (address);
488     function WETH() external pure returns (address);
489 
490     function addLiquidity(
491         address tokenA,
492         address tokenB,
493         uint amountADesired,
494         uint amountBDesired,
495         uint amountAMin,
496         uint amountBMin,
497         address to,
498         uint deadline
499     ) external returns (uint amountA, uint amountB, uint liquidity);
500     function addLiquidityETH(
501         address token,
502         uint amountTokenDesired,
503         uint amountTokenMin,
504         uint amountETHMin,
505         address to,
506         uint deadline
507     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
508     function removeLiquidity(
509         address tokenA,
510         address tokenB,
511         uint liquidity,
512         uint amountAMin,
513         uint amountBMin,
514         address to,
515         uint deadline
516     ) external returns (uint amountA, uint amountB);
517     function removeLiquidityETH(
518         address token,
519         uint liquidity,
520         uint amountTokenMin,
521         uint amountETHMin,
522         address to,
523         uint deadline
524     ) external returns (uint amountToken, uint amountETH);
525     function removeLiquidityWithPermit(
526         address tokenA,
527         address tokenB,
528         uint liquidity,
529         uint amountAMin,
530         uint amountBMin,
531         address to,
532         uint deadline,
533         bool approveMax, uint8 v, bytes32 r, bytes32 s
534     ) external returns (uint amountA, uint amountB);
535     function removeLiquidityETHWithPermit(
536         address token,
537         uint liquidity,
538         uint amountTokenMin,
539         uint amountETHMin,
540         address to,
541         uint deadline,
542         bool approveMax, uint8 v, bytes32 r, bytes32 s
543     ) external returns (uint amountToken, uint amountETH);
544     function swapExactTokensForTokens(
545         uint amountIn,
546         uint amountOutMin,
547         address[] calldata path,
548         address to,
549         uint deadline
550     ) external returns (uint[] memory amounts);
551     function swapTokensForExactTokens(
552         uint amountOut,
553         uint amountInMax,
554         address[] calldata path,
555         address to,
556         uint deadline
557     ) external returns (uint[] memory amounts);
558     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
559         external
560         payable
561         returns (uint[] memory amounts);
562     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
563         external
564         returns (uint[] memory amounts);
565     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
566         external
567         returns (uint[] memory amounts);
568     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
569         external
570         payable
571         returns (uint[] memory amounts);
572 
573     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
574     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
575     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
576     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
577     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
578 }
579 // File: contracts/IUniswapV2Router02.sol
580 
581 
582 
583 pragma solidity >=0.6.2;
584 
585 
586 interface IUniswapV2Router02 is IUniswapV2Router01 {
587     function removeLiquidityETHSupportingFeeOnTransferTokens(
588         address token,
589         uint liquidity,
590         uint amountTokenMin,
591         uint amountETHMin,
592         address to,
593         uint deadline
594     ) external returns (uint amountETH);
595     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
596         address token,
597         uint liquidity,
598         uint amountTokenMin,
599         uint amountETHMin,
600         address to,
601         uint deadline,
602         bool approveMax, uint8 v, bytes32 r, bytes32 s
603     ) external returns (uint amountETH);
604 
605     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
606         uint amountIn,
607         uint amountOutMin,
608         address[] calldata path,
609         address to,
610         uint deadline
611     ) external;
612     function swapExactETHForTokensSupportingFeeOnTransferTokens(
613         uint amountOutMin,
614         address[] calldata path,
615         address to,
616         uint deadline
617     ) external payable;
618     function swapExactTokensForETHSupportingFeeOnTransferTokens(
619         uint amountIn,
620         uint amountOutMin,
621         address[] calldata path,
622         address to,
623         uint deadline
624     ) external;
625 }
626 // File: @openzeppelin/contracts/utils/Address.sol
627 
628 
629 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
630 
631 pragma solidity ^0.8.0;
632 
633 /**
634  * @dev Collection of functions related to the address type
635  */
636 library Address {
637     /**
638      * @dev Returns true if `account` is a contract.
639      *
640      * [IMPORTANT]
641      * ====
642      * It is unsafe to assume that an address for which this function returns
643      * false is an externally-owned account (EOA) and not a contract.
644      *
645      * Among others, `isContract` will return false for the following
646      * types of addresses:
647      *
648      *  - an externally-owned account
649      *  - a contract in construction
650      *  - an address where a contract will be created
651      *  - an address where a contract lived, but was destroyed
652      * ====
653      */
654     function isContract(address account) internal view returns (bool) {
655         // This method relies on extcodesize, which returns 0 for contracts in
656         // construction, since the code is only stored at the end of the
657         // constructor execution.
658 
659         uint256 size;
660         assembly {
661             size := extcodesize(account)
662         }
663         return size > 0;
664     }
665 
666     /**
667      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
668      * `recipient`, forwarding all available gas and reverting on errors.
669      *
670      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
671      * of certain opcodes, possibly making contracts go over the 2300 gas limit
672      * imposed by `transfer`, making them unable to receive funds via
673      * `transfer`. {sendValue} removes this limitation.
674      *
675      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
676      *
677      * IMPORTANT: because control is transferred to `recipient`, care must be
678      * taken to not create reentrancy vulnerabilities. Consider using
679      * {ReentrancyGuard} or the
680      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
681      */
682     function sendValue(address payable recipient, uint256 amount) internal {
683         require(address(this).balance >= amount, "Address: insufficient balance");
684 
685         (bool success, ) = recipient.call{value: amount}("");
686         require(success, "Address: unable to send value, recipient may have reverted");
687     }
688 
689     /**
690      * @dev Performs a Solidity function call using a low level `call`. A
691      * plain `call` is an unsafe replacement for a function call: use this
692      * function instead.
693      *
694      * If `target` reverts with a revert reason, it is bubbled up by this
695      * function (like regular Solidity function calls).
696      *
697      * Returns the raw returned data. To convert to the expected return value,
698      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
699      *
700      * Requirements:
701      *
702      * - `target` must be a contract.
703      * - calling `target` with `data` must not revert.
704      *
705      * _Available since v3.1._
706      */
707     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
708         return functionCall(target, data, "Address: low-level call failed");
709     }
710 
711     /**
712      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
713      * `errorMessage` as a fallback revert reason when `target` reverts.
714      *
715      * _Available since v3.1._
716      */
717     function functionCall(
718         address target,
719         bytes memory data,
720         string memory errorMessage
721     ) internal returns (bytes memory) {
722         return functionCallWithValue(target, data, 0, errorMessage);
723     }
724 
725     /**
726      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
727      * but also transferring `value` wei to `target`.
728      *
729      * Requirements:
730      *
731      * - the calling contract must have an ETH balance of at least `value`.
732      * - the called Solidity function must be `payable`.
733      *
734      * _Available since v3.1._
735      */
736     function functionCallWithValue(
737         address target,
738         bytes memory data,
739         uint256 value
740     ) internal returns (bytes memory) {
741         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
742     }
743 
744     /**
745      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
746      * with `errorMessage` as a fallback revert reason when `target` reverts.
747      *
748      * _Available since v3.1._
749      */
750     function functionCallWithValue(
751         address target,
752         bytes memory data,
753         uint256 value,
754         string memory errorMessage
755     ) internal returns (bytes memory) {
756         require(address(this).balance >= value, "Address: insufficient balance for call");
757         require(isContract(target), "Address: call to non-contract");
758 
759         (bool success, bytes memory returndata) = target.call{value: value}(data);
760         return verifyCallResult(success, returndata, errorMessage);
761     }
762 
763     /**
764      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
765      * but performing a static call.
766      *
767      * _Available since v3.3._
768      */
769     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
770         return functionStaticCall(target, data, "Address: low-level static call failed");
771     }
772 
773     /**
774      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
775      * but performing a static call.
776      *
777      * _Available since v3.3._
778      */
779     function functionStaticCall(
780         address target,
781         bytes memory data,
782         string memory errorMessage
783     ) internal view returns (bytes memory) {
784         require(isContract(target), "Address: static call to non-contract");
785 
786         (bool success, bytes memory returndata) = target.staticcall(data);
787         return verifyCallResult(success, returndata, errorMessage);
788     }
789 
790     /**
791      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
792      * but performing a delegate call.
793      *
794      * _Available since v3.4._
795      */
796     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
797         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
798     }
799 
800     /**
801      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
802      * but performing a delegate call.
803      *
804      * _Available since v3.4._
805      */
806     function functionDelegateCall(
807         address target,
808         bytes memory data,
809         string memory errorMessage
810     ) internal returns (bytes memory) {
811         require(isContract(target), "Address: delegate call to non-contract");
812 
813         (bool success, bytes memory returndata) = target.delegatecall(data);
814         return verifyCallResult(success, returndata, errorMessage);
815     }
816 
817     /**
818      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
819      * revert reason using the provided one.
820      *
821      * _Available since v4.3._
822      */
823     function verifyCallResult(
824         bool success,
825         bytes memory returndata,
826         string memory errorMessage
827     ) internal pure returns (bytes memory) {
828         if (success) {
829             return returndata;
830         } else {
831             // Look for revert reason and bubble it up if present
832             if (returndata.length > 0) {
833                 // The easiest way to bubble the revert reason is using memory via assembly
834 
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
846 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
847 
848 
849 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
850 
851 pragma solidity ^0.8.0;
852 
853 /**
854  * @dev Interface of the ERC20 standard as defined in the EIP.
855  */
856 interface IERC20 {
857     /**
858      * @dev Returns the amount of tokens in existence.
859      */
860     function totalSupply() external view returns (uint256);
861 
862     /**
863      * @dev Returns the amount of tokens owned by `account`.
864      */
865     function balanceOf(address account) external view returns (uint256);
866 
867     /**
868      * @dev Moves `amount` tokens from the caller's account to `recipient`.
869      *
870      * Returns a boolean value indicating whether the operation succeeded.
871      *
872      * Emits a {Transfer} event.
873      */
874     function transfer(address recipient, uint256 amount) external returns (bool);
875 
876     /**
877      * @dev Returns the remaining number of tokens that `spender` will be
878      * allowed to spend on behalf of `owner` through {transferFrom}. This is
879      * zero by default.
880      *
881      * This value changes when {approve} or {transferFrom} are called.
882      */
883     function allowance(address owner, address spender) external view returns (uint256);
884 
885     /**
886      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
887      *
888      * Returns a boolean value indicating whether the operation succeeded.
889      *
890      * IMPORTANT: Beware that changing an allowance with this method brings the risk
891      * that someone may use both the old and the new allowance by unfortunate
892      * transaction ordering. One possible solution to mitigate this race
893      * condition is to first reduce the spender's allowance to 0 and set the
894      * desired value afterwards:
895      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
896      *
897      * Emits an {Approval} event.
898      */
899     function approve(address spender, uint256 amount) external returns (bool);
900 
901     /**
902      * @dev Moves `amount` tokens from `sender` to `recipient` using the
903      * allowance mechanism. `amount` is then deducted from the caller's
904      * allowance.
905      *
906      * Returns a boolean value indicating whether the operation succeeded.
907      *
908      * Emits a {Transfer} event.
909      */
910     function transferFrom(
911         address sender,
912         address recipient,
913         uint256 amount
914     ) external returns (bool);
915 
916     /**
917      * @dev Emitted when `value` tokens are moved from one account (`from`) to
918      * another (`to`).
919      *
920      * Note that `value` may be zero.
921      */
922     event Transfer(address indexed from, address indexed to, uint256 value);
923 
924     /**
925      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
926      * a call to {approve}. `value` is the new allowance.
927      */
928     event Approval(address indexed owner, address indexed spender, uint256 value);
929 }
930 
931 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
932 
933 
934 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
935 
936 pragma solidity ^0.8.0;
937 
938 
939 
940 /**
941  * @title SafeERC20
942  * @dev Wrappers around ERC20 operations that throw on failure (when the token
943  * contract returns false). Tokens that return no value (and instead revert or
944  * throw on failure) are also supported, non-reverting calls are assumed to be
945  * successful.
946  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
947  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
948  */
949 library SafeERC20 {
950     using Address for address;
951 
952     function safeTransfer(
953         IERC20 token,
954         address to,
955         uint256 value
956     ) internal {
957         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
958     }
959 
960     function safeTransferFrom(
961         IERC20 token,
962         address from,
963         address to,
964         uint256 value
965     ) internal {
966         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
967     }
968 
969     /**
970      * @dev Deprecated. This function has issues similar to the ones found in
971      * {IERC20-approve}, and its usage is discouraged.
972      *
973      * Whenever possible, use {safeIncreaseAllowance} and
974      * {safeDecreaseAllowance} instead.
975      */
976     function safeApprove(
977         IERC20 token,
978         address spender,
979         uint256 value
980     ) internal {
981         // safeApprove should only be called when setting an initial allowance,
982         // or when resetting it to zero. To increase and decrease it, use
983         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
984         require(
985             (value == 0) || (token.allowance(address(this), spender) == 0),
986             "SafeERC20: approve from non-zero to non-zero allowance"
987         );
988         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
989     }
990 
991     function safeIncreaseAllowance(
992         IERC20 token,
993         address spender,
994         uint256 value
995     ) internal {
996         uint256 newAllowance = token.allowance(address(this), spender) + value;
997         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
998     }
999 
1000     function safeDecreaseAllowance(
1001         IERC20 token,
1002         address spender,
1003         uint256 value
1004     ) internal {
1005         unchecked {
1006             uint256 oldAllowance = token.allowance(address(this), spender);
1007             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1008             uint256 newAllowance = oldAllowance - value;
1009             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1010         }
1011     }
1012 
1013     /**
1014      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1015      * on the return value: the return value is optional (but if data is returned, it must not be false).
1016      * @param token The token targeted by the call.
1017      * @param data The call data (encoded using abi.encode or one of its variants).
1018      */
1019     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1020         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1021         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1022         // the target address contains contract code and also asserts for success in the low-level call.
1023 
1024         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1025         if (returndata.length > 0) {
1026             // Return data is optional
1027             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1028         }
1029     }
1030 }
1031 
1032 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
1033 
1034 
1035 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1036 
1037 pragma solidity ^0.8.0;
1038 
1039 
1040 /**
1041  * @dev Interface for the optional metadata functions from the ERC20 standard.
1042  *
1043  * _Available since v4.1._
1044  */
1045 interface IERC20Metadata is IERC20 {
1046     /**
1047      * @dev Returns the name of the token.
1048      */
1049     function name() external view returns (string memory);
1050 
1051     /**
1052      * @dev Returns the symbol of the token.
1053      */
1054     function symbol() external view returns (string memory);
1055 
1056     /**
1057      * @dev Returns the decimals places of the token.
1058      */
1059     function decimals() external view returns (uint8);
1060 }
1061 
1062 // File: @openzeppelin/contracts/utils/Context.sol
1063 
1064 
1065 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1066 
1067 pragma solidity ^0.8.0;
1068 
1069 /**
1070  * @dev Provides information about the current execution context, including the
1071  * sender of the transaction and its data. While these are generally available
1072  * via msg.sender and msg.data, they should not be accessed in such a direct
1073  * manner, since when dealing with meta-transactions the account sending and
1074  * paying for execution may not be the actual sender (as far as an application
1075  * is concerned).
1076  *
1077  * This contract is only required for intermediate, library-like contracts.
1078  */
1079 abstract contract Context {
1080     function _msgSender() internal view virtual returns (address) {
1081         return msg.sender;
1082     }
1083 
1084     function _msgData() internal view virtual returns (bytes calldata) {
1085         return msg.data;
1086     }
1087 }
1088 
1089 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1090 
1091 
1092 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1093 
1094 pragma solidity ^0.8.0;
1095 
1096 
1097 
1098 
1099 
1100 
1101 
1102 
1103 /**
1104  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1105  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1106  * {ERC721Enumerable}.
1107  */
1108 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1109     using Address for address;
1110     using Strings for uint256;
1111 
1112     // Token name
1113     string private _name;
1114 
1115     // Token symbol
1116     string private _symbol;
1117 
1118     // Mapping from token ID to owner address
1119     mapping(uint256 => address) private _owners;
1120 
1121     // Mapping owner address to token count
1122     mapping(address => uint256) private _balances;
1123 
1124     // Mapping from token ID to approved address
1125     mapping(uint256 => address) private _tokenApprovals;
1126 
1127     // Mapping from owner to operator approvals
1128     mapping(address => mapping(address => bool)) private _operatorApprovals;
1129 
1130     /**
1131      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1132      */
1133     constructor(string memory name_, string memory symbol_) {
1134         _name = name_;
1135         _symbol = symbol_;
1136     }
1137 
1138     /**
1139      * @dev See {IERC165-supportsInterface}.
1140      */
1141     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1142         return
1143             interfaceId == type(IERC721).interfaceId ||
1144             interfaceId == type(IERC721Metadata).interfaceId ||
1145             super.supportsInterface(interfaceId);
1146     }
1147 
1148     /**
1149      * @dev See {IERC721-balanceOf}.
1150      */
1151     function balanceOf(address owner) public view virtual override returns (uint256) {
1152         require(owner != address(0), "ERC721: balance query for the zero address");
1153         return _balances[owner];
1154     }
1155 
1156     /**
1157      * @dev See {IERC721-ownerOf}.
1158      */
1159     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1160         address owner = _owners[tokenId];
1161         require(owner != address(0), "ERC721: owner query for nonexistent token");
1162         return owner;
1163     }
1164 
1165     /**
1166      * @dev See {IERC721Metadata-name}.
1167      */
1168     function name() public view virtual override returns (string memory) {
1169         return _name;
1170     }
1171 
1172     /**
1173      * @dev See {IERC721Metadata-symbol}.
1174      */
1175     function symbol() public view virtual override returns (string memory) {
1176         return _symbol;
1177     }
1178 
1179     /**
1180      * @dev See {IERC721Metadata-tokenURI}.
1181      */
1182     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1183         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1184 
1185         string memory baseURI = _baseURI();
1186         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1187     }
1188 
1189     /**
1190      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1191      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1192      * by default, can be overriden in child contracts.
1193      */
1194     function _baseURI() internal view virtual returns (string memory) {
1195         return "";
1196     }
1197 
1198     /**
1199      * @dev See {IERC721-approve}.
1200      */
1201     function approve(address to, uint256 tokenId) public virtual override {
1202         address owner = ERC721.ownerOf(tokenId);
1203         require(to != owner, "ERC721: approval to current owner");
1204 
1205         require(
1206             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1207             "ERC721: approve caller is not owner nor approved for all"
1208         );
1209 
1210         _approve(to, tokenId);
1211     }
1212 
1213     /**
1214      * @dev See {IERC721-getApproved}.
1215      */
1216     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1217         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1218 
1219         return _tokenApprovals[tokenId];
1220     }
1221 
1222     /**
1223      * @dev See {IERC721-setApprovalForAll}.
1224      */
1225     function setApprovalForAll(address operator, bool approved) public virtual override {
1226         _setApprovalForAll(_msgSender(), operator, approved);
1227     }
1228 
1229     /**
1230      * @dev See {IERC721-isApprovedForAll}.
1231      */
1232     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1233         return _operatorApprovals[owner][operator];
1234     }
1235 
1236     /**
1237      * @dev See {IERC721-transferFrom}.
1238      */
1239     function transferFrom(
1240         address from,
1241         address to,
1242         uint256 tokenId
1243     ) public virtual override {
1244         //solhint-disable-next-line max-line-length
1245         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1246 
1247         _transfer(from, to, tokenId);
1248     }
1249 
1250     /**
1251      * @dev See {IERC721-safeTransferFrom}.
1252      */
1253     function safeTransferFrom(
1254         address from,
1255         address to,
1256         uint256 tokenId
1257     ) public virtual override {
1258         safeTransferFrom(from, to, tokenId, "");
1259     }
1260 
1261     /**
1262      * @dev See {IERC721-safeTransferFrom}.
1263      */
1264     function safeTransferFrom(
1265         address from,
1266         address to,
1267         uint256 tokenId,
1268         bytes memory _data
1269     ) public virtual override {
1270         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1271         _safeTransfer(from, to, tokenId, _data);
1272     }
1273 
1274     /**
1275      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1276      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1277      *
1278      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1279      *
1280      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1281      * implement alternative mechanisms to perform token transfer, such as signature-based.
1282      *
1283      * Requirements:
1284      *
1285      * - `from` cannot be the zero address.
1286      * - `to` cannot be the zero address.
1287      * - `tokenId` token must exist and be owned by `from`.
1288      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1289      *
1290      * Emits a {Transfer} event.
1291      */
1292     function _safeTransfer(
1293         address from,
1294         address to,
1295         uint256 tokenId,
1296         bytes memory _data
1297     ) internal virtual {
1298         _transfer(from, to, tokenId);
1299         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1300     }
1301 
1302     /**
1303      * @dev Returns whether `tokenId` exists.
1304      *
1305      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1306      *
1307      * Tokens start existing when they are minted (`_mint`),
1308      * and stop existing when they are burned (`_burn`).
1309      */
1310     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1311         return _owners[tokenId] != address(0);
1312     }
1313 
1314     /**
1315      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1316      *
1317      * Requirements:
1318      *
1319      * - `tokenId` must exist.
1320      */
1321     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1322         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1323         address owner = ERC721.ownerOf(tokenId);
1324         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1325     }
1326 
1327     /**
1328      * @dev Safely mints `tokenId` and transfers it to `to`.
1329      *
1330      * Requirements:
1331      *
1332      * - `tokenId` must not exist.
1333      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1334      *
1335      * Emits a {Transfer} event.
1336      */
1337     function _safeMint(address to, uint256 tokenId) internal virtual {
1338         _safeMint(to, tokenId, "");
1339     }
1340 
1341     /**
1342      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1343      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1344      */
1345     function _safeMint(
1346         address to,
1347         uint256 tokenId,
1348         bytes memory _data
1349     ) internal virtual {
1350         _mint(to, tokenId);
1351         require(
1352             _checkOnERC721Received(address(0), to, tokenId, _data),
1353             "ERC721: transfer to non ERC721Receiver implementer"
1354         );
1355     }
1356 
1357     /**
1358      * @dev Mints `tokenId` and transfers it to `to`.
1359      *
1360      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1361      *
1362      * Requirements:
1363      *
1364      * - `tokenId` must not exist.
1365      * - `to` cannot be the zero address.
1366      *
1367      * Emits a {Transfer} event.
1368      */
1369     function _mint(address to, uint256 tokenId) internal virtual {
1370         require(to != address(0), "ERC721: mint to the zero address");
1371         require(!_exists(tokenId), "ERC721: token already minted");
1372 
1373         _beforeTokenTransfer(address(0), to, tokenId);
1374 
1375         _balances[to] += 1;
1376         _owners[tokenId] = to;
1377 
1378         emit Transfer(address(0), to, tokenId);
1379     }
1380 
1381     /**
1382      * @dev Destroys `tokenId`.
1383      * The approval is cleared when the token is burned.
1384      *
1385      * Requirements:
1386      *
1387      * - `tokenId` must exist.
1388      *
1389      * Emits a {Transfer} event.
1390      */
1391     function _burn(uint256 tokenId) internal virtual {
1392         address owner = ERC721.ownerOf(tokenId);
1393 
1394         _beforeTokenTransfer(owner, address(0), tokenId);
1395 
1396         // Clear approvals
1397         _approve(address(0), tokenId);
1398 
1399         _balances[owner] -= 1;
1400         delete _owners[tokenId];
1401 
1402         emit Transfer(owner, address(0), tokenId);
1403     }
1404 
1405     /**
1406      * @dev Transfers `tokenId` from `from` to `to`.
1407      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1408      *
1409      * Requirements:
1410      *
1411      * - `to` cannot be the zero address.
1412      * - `tokenId` token must be owned by `from`.
1413      *
1414      * Emits a {Transfer} event.
1415      */
1416     function _transfer(
1417         address from,
1418         address to,
1419         uint256 tokenId
1420     ) internal virtual {
1421         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1422         require(to != address(0), "ERC721: transfer to the zero address");
1423 
1424         _beforeTokenTransfer(from, to, tokenId);
1425 
1426         // Clear approvals from the previous owner
1427         _approve(address(0), tokenId);
1428 
1429         _balances[from] -= 1;
1430         _balances[to] += 1;
1431         _owners[tokenId] = to;
1432 
1433         emit Transfer(from, to, tokenId);
1434     }
1435 
1436     /**
1437      * @dev Approve `to` to operate on `tokenId`
1438      *
1439      * Emits a {Approval} event.
1440      */
1441     function _approve(address to, uint256 tokenId) internal virtual {
1442         _tokenApprovals[tokenId] = to;
1443         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1444     }
1445 
1446     /**
1447      * @dev Approve `operator` to operate on all of `owner` tokens
1448      *
1449      * Emits a {ApprovalForAll} event.
1450      */
1451     function _setApprovalForAll(
1452         address owner,
1453         address operator,
1454         bool approved
1455     ) internal virtual {
1456         require(owner != operator, "ERC721: approve to caller");
1457         _operatorApprovals[owner][operator] = approved;
1458         emit ApprovalForAll(owner, operator, approved);
1459     }
1460 
1461     /**
1462      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1463      * The call is not executed if the target address is not a contract.
1464      *
1465      * @param from address representing the previous owner of the given token ID
1466      * @param to target address that will receive the tokens
1467      * @param tokenId uint256 ID of the token to be transferred
1468      * @param _data bytes optional data to send along with the call
1469      * @return bool whether the call correctly returned the expected magic value
1470      */
1471     function _checkOnERC721Received(
1472         address from,
1473         address to,
1474         uint256 tokenId,
1475         bytes memory _data
1476     ) private returns (bool) {
1477         if (to.isContract()) {
1478             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1479                 return retval == IERC721Receiver.onERC721Received.selector;
1480             } catch (bytes memory reason) {
1481                 if (reason.length == 0) {
1482                     revert("ERC721: transfer to non ERC721Receiver implementer");
1483                 } else {
1484                     assembly {
1485                         revert(add(32, reason), mload(reason))
1486                     }
1487                 }
1488             }
1489         } else {
1490             return true;
1491         }
1492     }
1493 
1494     /**
1495      * @dev Hook that is called before any token transfer. This includes minting
1496      * and burning.
1497      *
1498      * Calling conditions:
1499      *
1500      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1501      * transferred to `to`.
1502      * - When `from` is zero, `tokenId` will be minted for `to`.
1503      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1504      * - `from` and `to` are never both zero.
1505      *
1506      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1507      */
1508     function _beforeTokenTransfer(
1509         address from,
1510         address to,
1511         uint256 tokenId
1512     ) internal virtual {}
1513 }
1514 
1515 // File: @openzeppelin/contracts/security/Pausable.sol
1516 
1517 
1518 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1519 
1520 pragma solidity ^0.8.0;
1521 
1522 
1523 /**
1524  * @dev Contract module which allows children to implement an emergency stop
1525  * mechanism that can be triggered by an authorized account.
1526  *
1527  * This module is used through inheritance. It will make available the
1528  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1529  * the functions of your contract. Note that they will not be pausable by
1530  * simply including this module, only once the modifiers are put in place.
1531  */
1532 abstract contract Pausable is Context {
1533     /**
1534      * @dev Emitted when the pause is triggered by `account`.
1535      */
1536     event Paused(address account);
1537 
1538     /**
1539      * @dev Emitted when the pause is lifted by `account`.
1540      */
1541     event Unpaused(address account);
1542 
1543     bool private _paused;
1544 
1545     /**
1546      * @dev Initializes the contract in unpaused state.
1547      */
1548     constructor() {
1549         _paused = false;
1550     }
1551 
1552     /**
1553      * @dev Returns true if the contract is paused, and false otherwise.
1554      */
1555     function paused() public view virtual returns (bool) {
1556         return _paused;
1557     }
1558 
1559     /**
1560      * @dev Modifier to make a function callable only when the contract is not paused.
1561      *
1562      * Requirements:
1563      *
1564      * - The contract must not be paused.
1565      */
1566     modifier whenNotPaused() {
1567         require(!paused(), "Pausable: paused");
1568         _;
1569     }
1570 
1571     /**
1572      * @dev Modifier to make a function callable only when the contract is paused.
1573      *
1574      * Requirements:
1575      *
1576      * - The contract must be paused.
1577      */
1578     modifier whenPaused() {
1579         require(paused(), "Pausable: not paused");
1580         _;
1581     }
1582 
1583     /**
1584      * @dev Triggers stopped state.
1585      *
1586      * Requirements:
1587      *
1588      * - The contract must not be paused.
1589      */
1590     function _pause() internal virtual whenNotPaused {
1591         _paused = true;
1592         emit Paused(_msgSender());
1593     }
1594 
1595     /**
1596      * @dev Returns to normal state.
1597      *
1598      * Requirements:
1599      *
1600      * - The contract must be paused.
1601      */
1602     function _unpause() internal virtual whenPaused {
1603         _paused = false;
1604         emit Unpaused(_msgSender());
1605     }
1606 }
1607 
1608 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
1609 
1610 
1611 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
1612 
1613 pragma solidity ^0.8.0;
1614 
1615 
1616 
1617 
1618 /**
1619  * @title PaymentSplitter
1620  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1621  * that the Ether will be split in this way, since it is handled transparently by the contract.
1622  *
1623  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1624  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1625  * an amount proportional to the percentage of total shares they were assigned.
1626  *
1627  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1628  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1629  * function.
1630  *
1631  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
1632  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
1633  * to run tests before sending real value to this contract.
1634  */
1635 contract PaymentSplitter is Context {
1636     event PayeeAdded(address account, uint256 shares);
1637     event PaymentReleased(address to, uint256 amount);
1638     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
1639     event PaymentReceived(address from, uint256 amount);
1640 
1641     uint256 private _totalShares;
1642     uint256 private _totalReleased;
1643 
1644     mapping(address => uint256) private _shares;
1645     mapping(address => uint256) private _released;
1646     address[] private _payees;
1647 
1648     mapping(IERC20 => uint256) private _erc20TotalReleased;
1649     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
1650 
1651     /**
1652      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1653      * the matching position in the `shares` array.
1654      *
1655      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1656      * duplicates in `payees`.
1657      */
1658     constructor(address[] memory payees, uint256[] memory shares_) payable {
1659         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1660         require(payees.length > 0, "PaymentSplitter: no payees");
1661 
1662         for (uint256 i = 0; i < payees.length; i++) {
1663             _addPayee(payees[i], shares_[i]);
1664         }
1665     }
1666 
1667     /**
1668      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1669      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1670      * reliability of the events, and not the actual splitting of Ether.
1671      *
1672      * To learn more about this see the Solidity documentation for
1673      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1674      * functions].
1675      */
1676     receive() external payable virtual {
1677         emit PaymentReceived(_msgSender(), msg.value);
1678     }
1679 
1680     /**
1681      * @dev Getter for the total shares held by payees.
1682      */
1683     function totalShares() public view returns (uint256) {
1684         return _totalShares;
1685     }
1686 
1687     /**
1688      * @dev Getter for the total amount of Ether already released.
1689      */
1690     function totalReleased() public view returns (uint256) {
1691         return _totalReleased;
1692     }
1693 
1694     /**
1695      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
1696      * contract.
1697      */
1698     function totalReleased(IERC20 token) public view returns (uint256) {
1699         return _erc20TotalReleased[token];
1700     }
1701 
1702     /**
1703      * @dev Getter for the amount of shares held by an account.
1704      */
1705     function shares(address account) public view returns (uint256) {
1706         return _shares[account];
1707     }
1708 
1709     /**
1710      * @dev Getter for the amount of Ether already released to a payee.
1711      */
1712     function released(address account) public view returns (uint256) {
1713         return _released[account];
1714     }
1715 
1716     /**
1717      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
1718      * IERC20 contract.
1719      */
1720     function released(IERC20 token, address account) public view returns (uint256) {
1721         return _erc20Released[token][account];
1722     }
1723 
1724     /**
1725      * @dev Getter for the address of the payee number `index`.
1726      */
1727     function payee(uint256 index) public view returns (address) {
1728         return _payees[index];
1729     }
1730 
1731     /**
1732      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1733      * total shares and their previous withdrawals.
1734      */
1735     function release(address payable account) public virtual {
1736         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1737 
1738         uint256 totalReceived = address(this).balance + totalReleased();
1739         uint256 payment = _pendingPayment(account, totalReceived, released(account));
1740 
1741         require(payment != 0, "PaymentSplitter: account is not due payment");
1742 
1743         _released[account] += payment;
1744         _totalReleased += payment;
1745 
1746         Address.sendValue(account, payment);
1747         emit PaymentReleased(account, payment);
1748     }
1749 
1750     /**
1751      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1752      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1753      * contract.
1754      */
1755     function release(IERC20 token, address account) public virtual {
1756         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1757 
1758         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1759         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
1760 
1761         require(payment != 0, "PaymentSplitter: account is not due payment");
1762 
1763         _erc20Released[token][account] += payment;
1764         _erc20TotalReleased[token] += payment;
1765 
1766         SafeERC20.safeTransfer(token, account, payment);
1767         emit ERC20PaymentReleased(token, account, payment);
1768     }
1769 
1770     /**
1771      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1772      * already released amounts.
1773      */
1774     function _pendingPayment(
1775         address account,
1776         uint256 totalReceived,
1777         uint256 alreadyReleased
1778     ) private view returns (uint256) {
1779         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1780     }
1781 
1782     /**
1783      * @dev Add a new payee to the contract.
1784      * @param account The address of the payee to add.
1785      * @param shares_ The number of shares owned by the payee.
1786      */
1787     function _addPayee(address account, uint256 shares_) private {
1788         require(account != address(0), "PaymentSplitter: account is the zero address");
1789         require(shares_ > 0, "PaymentSplitter: shares are 0");
1790         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1791 
1792         _payees.push(account);
1793         _shares[account] = shares_;
1794         _totalShares = _totalShares + shares_;
1795         emit PayeeAdded(account, shares_);
1796     }
1797 }
1798 
1799 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1800 
1801 
1802 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
1803 
1804 pragma solidity ^0.8.0;
1805 
1806 
1807 
1808 
1809 /**
1810  * @dev Implementation of the {IERC20} interface.
1811  *
1812  * This implementation is agnostic to the way tokens are created. This means
1813  * that a supply mechanism has to be added in a derived contract using {_mint}.
1814  * For a generic mechanism see {ERC20PresetMinterPauser}.
1815  *
1816  * TIP: For a detailed writeup see our guide
1817  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1818  * to implement supply mechanisms].
1819  *
1820  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1821  * instead returning `false` on failure. This behavior is nonetheless
1822  * conventional and does not conflict with the expectations of ERC20
1823  * applications.
1824  *
1825  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1826  * This allows applications to reconstruct the allowance for all accounts just
1827  * by listening to said events. Other implementations of the EIP may not emit
1828  * these events, as it isn't required by the specification.
1829  *
1830  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1831  * functions have been added to mitigate the well-known issues around setting
1832  * allowances. See {IERC20-approve}.
1833  */
1834 contract ERC20 is Context, IERC20, IERC20Metadata {
1835     mapping(address => uint256) private _balances;
1836 
1837     mapping(address => mapping(address => uint256)) private _allowances;
1838 
1839     uint256 private _totalSupply;
1840 
1841     string private _name;
1842     string private _symbol;
1843 
1844     /**
1845      * @dev Sets the values for {name} and {symbol}.
1846      *
1847      * The default value of {decimals} is 18. To select a different value for
1848      * {decimals} you should overload it.
1849      *
1850      * All two of these values are immutable: they can only be set once during
1851      * construction.
1852      */
1853     constructor(string memory name_, string memory symbol_) {
1854         _name = name_;
1855         _symbol = symbol_;
1856     }
1857 
1858     /**
1859      * @dev Returns the name of the token.
1860      */
1861     function name() public view virtual override returns (string memory) {
1862         return _name;
1863     }
1864 
1865     /**
1866      * @dev Returns the symbol of the token, usually a shorter version of the
1867      * name.
1868      */
1869     function symbol() public view virtual override returns (string memory) {
1870         return _symbol;
1871     }
1872 
1873     /**
1874      * @dev Returns the number of decimals used to get its user representation.
1875      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1876      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1877      *
1878      * Tokens usually opt for a value of 18, imitating the relationship between
1879      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1880      * overridden;
1881      *
1882      * NOTE: This information is only used for _display_ purposes: it in
1883      * no way affects any of the arithmetic of the contract, including
1884      * {IERC20-balanceOf} and {IERC20-transfer}.
1885      */
1886     function decimals() public view virtual override returns (uint8) {
1887         return 18;
1888     }
1889 
1890     /**
1891      * @dev See {IERC20-totalSupply}.
1892      */
1893     function totalSupply() public view virtual override returns (uint256) {
1894         return _totalSupply;
1895     }
1896 
1897     /**
1898      * @dev See {IERC20-balanceOf}.
1899      */
1900     function balanceOf(address account) public view virtual override returns (uint256) {
1901         return _balances[account];
1902     }
1903 
1904     /**
1905      * @dev See {IERC20-transfer}.
1906      *
1907      * Requirements:
1908      *
1909      * - `recipient` cannot be the zero address.
1910      * - the caller must have a balance of at least `amount`.
1911      */
1912     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1913         _transfer(_msgSender(), recipient, amount);
1914         return true;
1915     }
1916 
1917     /**
1918      * @dev See {IERC20-allowance}.
1919      */
1920     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1921         return _allowances[owner][spender];
1922     }
1923 
1924     /**
1925      * @dev See {IERC20-approve}.
1926      *
1927      * Requirements:
1928      *
1929      * - `spender` cannot be the zero address.
1930      */
1931     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1932         _approve(_msgSender(), spender, amount);
1933         return true;
1934     }
1935 
1936     /**
1937      * @dev See {IERC20-transferFrom}.
1938      *
1939      * Emits an {Approval} event indicating the updated allowance. This is not
1940      * required by the EIP. See the note at the beginning of {ERC20}.
1941      *
1942      * Requirements:
1943      *
1944      * - `sender` and `recipient` cannot be the zero address.
1945      * - `sender` must have a balance of at least `amount`.
1946      * - the caller must have allowance for ``sender``'s tokens of at least
1947      * `amount`.
1948      */
1949     function transferFrom(
1950         address sender,
1951         address recipient,
1952         uint256 amount
1953     ) public virtual override returns (bool) {
1954         _transfer(sender, recipient, amount);
1955 
1956         uint256 currentAllowance = _allowances[sender][_msgSender()];
1957         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1958         unchecked {
1959             _approve(sender, _msgSender(), currentAllowance - amount);
1960         }
1961 
1962         return true;
1963     }
1964 
1965     /**
1966      * @dev Atomically increases the allowance granted to `spender` by the caller.
1967      *
1968      * This is an alternative to {approve} that can be used as a mitigation for
1969      * problems described in {IERC20-approve}.
1970      *
1971      * Emits an {Approval} event indicating the updated allowance.
1972      *
1973      * Requirements:
1974      *
1975      * - `spender` cannot be the zero address.
1976      */
1977     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1978         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1979         return true;
1980     }
1981 
1982     /**
1983      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1984      *
1985      * This is an alternative to {approve} that can be used as a mitigation for
1986      * problems described in {IERC20-approve}.
1987      *
1988      * Emits an {Approval} event indicating the updated allowance.
1989      *
1990      * Requirements:
1991      *
1992      * - `spender` cannot be the zero address.
1993      * - `spender` must have allowance for the caller of at least
1994      * `subtractedValue`.
1995      */
1996     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1997         uint256 currentAllowance = _allowances[_msgSender()][spender];
1998         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1999         unchecked {
2000             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
2001         }
2002 
2003         return true;
2004     }
2005 
2006     /**
2007      * @dev Moves `amount` of tokens from `sender` to `recipient`.
2008      *
2009      * This internal function is equivalent to {transfer}, and can be used to
2010      * e.g. implement automatic token fees, slashing mechanisms, etc.
2011      *
2012      * Emits a {Transfer} event.
2013      *
2014      * Requirements:
2015      *
2016      * - `sender` cannot be the zero address.
2017      * - `recipient` cannot be the zero address.
2018      * - `sender` must have a balance of at least `amount`.
2019      */
2020     function _transfer(
2021         address sender,
2022         address recipient,
2023         uint256 amount
2024     ) internal virtual {
2025         require(sender != address(0), "ERC20: transfer from the zero address");
2026         require(recipient != address(0), "ERC20: transfer to the zero address");
2027 
2028         _beforeTokenTransfer(sender, recipient, amount);
2029 
2030         uint256 senderBalance = _balances[sender];
2031         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
2032         unchecked {
2033             _balances[sender] = senderBalance - amount;
2034         }
2035         _balances[recipient] += amount;
2036 
2037         emit Transfer(sender, recipient, amount);
2038 
2039         _afterTokenTransfer(sender, recipient, amount);
2040     }
2041 
2042     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2043      * the total supply.
2044      *
2045      * Emits a {Transfer} event with `from` set to the zero address.
2046      *
2047      * Requirements:
2048      *
2049      * - `account` cannot be the zero address.
2050      */
2051     function _mint(address account, uint256 amount) internal virtual {
2052         require(account != address(0), "ERC20: mint to the zero address");
2053 
2054         _beforeTokenTransfer(address(0), account, amount);
2055 
2056         _totalSupply += amount;
2057         _balances[account] += amount;
2058         emit Transfer(address(0), account, amount);
2059 
2060         _afterTokenTransfer(address(0), account, amount);
2061     }
2062 
2063     /**
2064      * @dev Destroys `amount` tokens from `account`, reducing the
2065      * total supply.
2066      *
2067      * Emits a {Transfer} event with `to` set to the zero address.
2068      *
2069      * Requirements:
2070      *
2071      * - `account` cannot be the zero address.
2072      * - `account` must have at least `amount` tokens.
2073      */
2074     function _burn(address account, uint256 amount) internal virtual {
2075         require(account != address(0), "ERC20: burn from the zero address");
2076 
2077         _beforeTokenTransfer(account, address(0), amount);
2078 
2079         uint256 accountBalance = _balances[account];
2080         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
2081         unchecked {
2082             _balances[account] = accountBalance - amount;
2083         }
2084         _totalSupply -= amount;
2085 
2086         emit Transfer(account, address(0), amount);
2087 
2088         _afterTokenTransfer(account, address(0), amount);
2089     }
2090 
2091     /**
2092      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
2093      *
2094      * This internal function is equivalent to `approve`, and can be used to
2095      * e.g. set automatic allowances for certain subsystems, etc.
2096      *
2097      * Emits an {Approval} event.
2098      *
2099      * Requirements:
2100      *
2101      * - `owner` cannot be the zero address.
2102      * - `spender` cannot be the zero address.
2103      */
2104     function _approve(
2105         address owner,
2106         address spender,
2107         uint256 amount
2108     ) internal virtual {
2109         require(owner != address(0), "ERC20: approve from the zero address");
2110         require(spender != address(0), "ERC20: approve to the zero address");
2111 
2112         _allowances[owner][spender] = amount;
2113         emit Approval(owner, spender, amount);
2114     }
2115 
2116     /**
2117      * @dev Hook that is called before any transfer of tokens. This includes
2118      * minting and burning.
2119      *
2120      * Calling conditions:
2121      *
2122      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2123      * will be transferred to `to`.
2124      * - when `from` is zero, `amount` tokens will be minted for `to`.
2125      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2126      * - `from` and `to` are never both zero.
2127      *
2128      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2129      */
2130     function _beforeTokenTransfer(
2131         address from,
2132         address to,
2133         uint256 amount
2134     ) internal virtual {}
2135 
2136     /**
2137      * @dev Hook that is called after any transfer of tokens. This includes
2138      * minting and burning.
2139      *
2140      * Calling conditions:
2141      *
2142      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2143      * has been transferred to `to`.
2144      * - when `from` is zero, `amount` tokens have been minted for `to`.
2145      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
2146      * - `from` and `to` are never both zero.
2147      *
2148      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2149      */
2150     function _afterTokenTransfer(
2151         address from,
2152         address to,
2153         uint256 amount
2154     ) internal virtual {}
2155 }
2156 
2157 // File: @openzeppelin/contracts/access/Ownable.sol
2158 
2159 
2160 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
2161 
2162 pragma solidity ^0.8.0;
2163 
2164 
2165 /**
2166  * @dev Contract module which provides a basic access control mechanism, where
2167  * there is an account (an owner) that can be granted exclusive access to
2168  * specific functions.
2169  *
2170  * By default, the owner account will be the one that deploys the contract. This
2171  * can later be changed with {transferOwnership}.
2172  *
2173  * This module is used through inheritance. It will make available the modifier
2174  * `onlyOwner`, which can be applied to your functions to restrict their use to
2175  * the owner.
2176  */
2177 abstract contract Ownable is Context {
2178     address private _owner;
2179 
2180     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2181 
2182     /**
2183      * @dev Initializes the contract setting the deployer as the initial owner.
2184      */
2185     constructor() {
2186         _transferOwnership(_msgSender());
2187     }
2188 
2189     /**
2190      * @dev Returns the address of the current owner.
2191      */
2192     function owner() public view virtual returns (address) {
2193         return _owner;
2194     }
2195 
2196     /**
2197      * @dev Throws if called by any account other than the owner.
2198      */
2199     modifier onlyOwner() {
2200         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2201         _;
2202     }
2203 
2204     /**
2205      * @dev Leaves the contract without owner. It will not be possible to call
2206      * `onlyOwner` functions anymore. Can only be called by the current owner.
2207      *
2208      * NOTE: Renouncing ownership will leave the contract without an owner,
2209      * thereby removing any functionality that is only available to the owner.
2210      */
2211     function renounceOwnership() public virtual onlyOwner {
2212         _transferOwnership(address(0));
2213     }
2214 
2215     /**
2216      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2217      * Can only be called by the current owner.
2218      */
2219     function transferOwnership(address newOwner) public virtual onlyOwner {
2220         require(newOwner != address(0), "Ownable: new owner is the zero address");
2221         _transferOwnership(newOwner);
2222     }
2223 
2224     /**
2225      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2226      * Internal function without access restriction.
2227      */
2228     function _transferOwnership(address newOwner) internal virtual {
2229         address oldOwner = _owner;
2230         _owner = newOwner;
2231         emit OwnershipTransferred(oldOwner, newOwner);
2232     }
2233 }
2234 
2235 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2236 
2237 
2238 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
2239 
2240 pragma solidity ^0.8.0;
2241 
2242 // CAUTION
2243 // This version of SafeMath should only be used with Solidity 0.8 or later,
2244 // because it relies on the compiler's built in overflow checks.
2245 
2246 /**
2247  * @dev Wrappers over Solidity's arithmetic operations.
2248  *
2249  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
2250  * now has built in overflow checking.
2251  */
2252 library SafeMath {
2253     /**
2254      * @dev Returns the addition of two unsigned integers, with an overflow flag.
2255      *
2256      * _Available since v3.4._
2257      */
2258     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2259         unchecked {
2260             uint256 c = a + b;
2261             if (c < a) return (false, 0);
2262             return (true, c);
2263         }
2264     }
2265 
2266     /**
2267      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
2268      *
2269      * _Available since v3.4._
2270      */
2271     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2272         unchecked {
2273             if (b > a) return (false, 0);
2274             return (true, a - b);
2275         }
2276     }
2277 
2278     /**
2279      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
2280      *
2281      * _Available since v3.4._
2282      */
2283     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2284         unchecked {
2285             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
2286             // benefit is lost if 'b' is also tested.
2287             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
2288             if (a == 0) return (true, 0);
2289             uint256 c = a * b;
2290             if (c / a != b) return (false, 0);
2291             return (true, c);
2292         }
2293     }
2294 
2295     /**
2296      * @dev Returns the division of two unsigned integers, with a division by zero flag.
2297      *
2298      * _Available since v3.4._
2299      */
2300     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2301         unchecked {
2302             if (b == 0) return (false, 0);
2303             return (true, a / b);
2304         }
2305     }
2306 
2307     /**
2308      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
2309      *
2310      * _Available since v3.4._
2311      */
2312     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2313         unchecked {
2314             if (b == 0) return (false, 0);
2315             return (true, a % b);
2316         }
2317     }
2318 
2319     /**
2320      * @dev Returns the addition of two unsigned integers, reverting on
2321      * overflow.
2322      *
2323      * Counterpart to Solidity's `+` operator.
2324      *
2325      * Requirements:
2326      *
2327      * - Addition cannot overflow.
2328      */
2329     function add(uint256 a, uint256 b) internal pure returns (uint256) {
2330         return a + b;
2331     }
2332 
2333     /**
2334      * @dev Returns the subtraction of two unsigned integers, reverting on
2335      * overflow (when the result is negative).
2336      *
2337      * Counterpart to Solidity's `-` operator.
2338      *
2339      * Requirements:
2340      *
2341      * - Subtraction cannot overflow.
2342      */
2343     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
2344         return a - b;
2345     }
2346 
2347     /**
2348      * @dev Returns the multiplication of two unsigned integers, reverting on
2349      * overflow.
2350      *
2351      * Counterpart to Solidity's `*` operator.
2352      *
2353      * Requirements:
2354      *
2355      * - Multiplication cannot overflow.
2356      */
2357     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
2358         return a * b;
2359     }
2360 
2361     /**
2362      * @dev Returns the integer division of two unsigned integers, reverting on
2363      * division by zero. The result is rounded towards zero.
2364      *
2365      * Counterpart to Solidity's `/` operator.
2366      *
2367      * Requirements:
2368      *
2369      * - The divisor cannot be zero.
2370      */
2371     function div(uint256 a, uint256 b) internal pure returns (uint256) {
2372         return a / b;
2373     }
2374 
2375     /**
2376      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2377      * reverting when dividing by zero.
2378      *
2379      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2380      * opcode (which leaves remaining gas untouched) while Solidity uses an
2381      * invalid opcode to revert (consuming all remaining gas).
2382      *
2383      * Requirements:
2384      *
2385      * - The divisor cannot be zero.
2386      */
2387     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
2388         return a % b;
2389     }
2390 
2391     /**
2392      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
2393      * overflow (when the result is negative).
2394      *
2395      * CAUTION: This function is deprecated because it requires allocating memory for the error
2396      * message unnecessarily. For custom revert reasons use {trySub}.
2397      *
2398      * Counterpart to Solidity's `-` operator.
2399      *
2400      * Requirements:
2401      *
2402      * - Subtraction cannot overflow.
2403      */
2404     function sub(
2405         uint256 a,
2406         uint256 b,
2407         string memory errorMessage
2408     ) internal pure returns (uint256) {
2409         unchecked {
2410             require(b <= a, errorMessage);
2411             return a - b;
2412         }
2413     }
2414 
2415     /**
2416      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
2417      * division by zero. The result is rounded towards zero.
2418      *
2419      * Counterpart to Solidity's `/` operator. Note: this function uses a
2420      * `revert` opcode (which leaves remaining gas untouched) while Solidity
2421      * uses an invalid opcode to revert (consuming all remaining gas).
2422      *
2423      * Requirements:
2424      *
2425      * - The divisor cannot be zero.
2426      */
2427     function div(
2428         uint256 a,
2429         uint256 b,
2430         string memory errorMessage
2431     ) internal pure returns (uint256) {
2432         unchecked {
2433             require(b > 0, errorMessage);
2434             return a / b;
2435         }
2436     }
2437 
2438     /**
2439      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2440      * reverting with custom message when dividing by zero.
2441      *
2442      * CAUTION: This function is deprecated because it requires allocating memory for the error
2443      * message unnecessarily. For custom revert reasons use {tryMod}.
2444      *
2445      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2446      * opcode (which leaves remaining gas untouched) while Solidity uses an
2447      * invalid opcode to revert (consuming all remaining gas).
2448      *
2449      * Requirements:
2450      *
2451      * - The divisor cannot be zero.
2452      */
2453     function mod(
2454         uint256 a,
2455         uint256 b,
2456         string memory errorMessage
2457     ) internal pure returns (uint256) {
2458         unchecked {
2459             require(b > 0, errorMessage);
2460             return a % b;
2461         }
2462     }
2463 }
2464 
2465 // File: contracts/Counters.sol
2466 
2467 
2468 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
2469 
2470 pragma solidity ^0.8.4;
2471 
2472 
2473 library Counters {
2474     using SafeMath for uint256;
2475 
2476     struct Counter {
2477         // This variable should never be directly accessed by users of the library: interactions must be restricted to
2478         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
2479         // this feature: see https://github.com/ethereum/solidity/issues/4637
2480         uint256 _value; // default: 0
2481     }
2482 
2483     function current(Counter storage counter) internal view returns (uint256) {
2484         return counter._value;
2485     }
2486 
2487     function increment(Counter storage counter) internal {
2488         counter._value += 1;
2489     }
2490 
2491     function decrement(Counter storage counter) internal {
2492         counter._value = counter._value.sub(1);
2493     }
2494 }
2495 // File: contracts/Molecules.sol
2496 
2497 //SPDX-License-Identifier: MIT
2498 // contracts/ERC721.sol
2499 
2500 pragma solidity >=0.8.0;
2501 
2502 
2503 
2504 
2505 
2506 
2507 
2508 
2509 
2510 contract Molecules is ERC721, Ownable {
2511     using SafeMath for uint256;
2512     using IterableMapping for IterableMapping.Map;
2513     using Counters for Counters.Counter;
2514 
2515     Counters.Counter private _tokenIds;
2516 
2517     address private _owner;
2518     address private _royaltiesAddr; // royality receiver
2519     uint256 public royaltyPercentage; // royalty based on sales price
2520     mapping(address => bool) public excludedList; // list of people who dont have to pay fee
2521 
2522     // cost to mint
2523     uint256 public mintFeeAmount;
2524 
2525     // // NFT Meta data
2526     string public baseURL;
2527 
2528     // UnbondingTime
2529     uint256 public unbondingTime = 604800;
2530 
2531     uint256 public constant maxSupply = 1000;
2532 
2533     // enable flag for public
2534     bool public openForPublic;
2535 
2536     // define Molecule struct
2537     struct Molecule {
2538         uint256 tokenId;
2539         // string tokenURI;
2540         address mintedBy;
2541         address currentOwner;
2542         uint256 previousPrice;
2543         uint256 price;
2544         uint256 numberOfTransfers;
2545         bool forSale;
2546         bool bonded;
2547         uint256 kind;
2548         uint256 level;
2549         uint256 lastUpgradeTime;
2550         uint256 bondedTime;
2551     }
2552 
2553     
2554 
2555     // map id to Molecules obj
2556     mapping(uint256 => Molecule) public allMolecules;
2557 
2558     // Mapping from owner to list of owned token IDs
2559     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2560 
2561     // Mapping from token ID to index of the owner tokens list
2562     mapping(uint256 => uint256) private _ownedTokensIndex;
2563 
2564     // Array with all token ids, used for enumeration
2565     uint256[] private _allTokens;
2566 
2567     // Mapping from token id to position in the allTokens array
2568     mapping(uint256 => uint256) private _allTokensIndex;
2569 
2570     //================================= Events ================================= //
2571 
2572     event SaleToggle(uint256 moleculeNumber, bool isForSale, uint256 price);
2573     event PurchaseEvent(uint256 moleculeNumber, address from, address to, uint256 price);
2574     event moleculeBonded(uint256 moleculeNumber, address owner, uint256 NodeCreationTime);
2575     event moleculeUnbonded(uint256 moleculeNumber, address owner, uint256 NodeCreationTime);   
2576     event moleculeGrown(uint256 moleculeNumber, uint256 newLevel); 
2577 
2578     constructor(
2579         address _contractOwner,
2580         address _royaltyReceiver,
2581         uint256 _royaltyPercentage,
2582         uint256 _mintFeeAmount,
2583         string memory _baseURL,
2584         bool _openForPublic
2585     ) ERC721("Molecules","M") Ownable() {
2586         royaltyPercentage = _royaltyPercentage;
2587         _owner = _contractOwner;
2588         _royaltiesAddr = _royaltyReceiver;
2589         mintFeeAmount = _mintFeeAmount.mul(1e18);
2590         excludedList[_contractOwner] = true; // add owner to exclude list
2591         excludedList[_royaltyReceiver] = true; // add artist to exclude list
2592         baseURL = _baseURL;
2593         openForPublic = _openForPublic;
2594     }
2595 
2596     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721) returns (bool) {
2597         return super.supportsInterface(interfaceId);
2598     }
2599 
2600     function mint(uint256 numberOfToken) public payable {
2601         // check if this function caller is not an zero address account
2602         require(openForPublic == true, "not open");
2603         require(msg.sender != address(0));
2604         require(
2605             _allTokens.length + numberOfToken <= maxSupply,
2606             "max supply"
2607         );
2608         require(numberOfToken > 0, "Min 1");
2609         require(numberOfToken <= 3, "Max 3");
2610         uint256 price = 0;
2611         // pay for minting cost
2612         if (excludedList[msg.sender] == false) {
2613             // send token's worth of ethers to the owner
2614             price = mintFeeAmount * numberOfToken;
2615             require(msg.value >= price, "Not enough fee");
2616             payable(_royaltiesAddr).transfer(msg.value);
2617         } else {
2618             // return money to sender // since its free
2619             payable(msg.sender).transfer(msg.value);
2620         }
2621         uint256 newPrice = mintFeeAmount;
2622 
2623         for (uint256 i = 1; i <= numberOfToken; i++) {
2624             _tokenIds.increment();
2625             uint256 newItemId = _tokenIds.current();
2626             _safeMint(msg.sender, newItemId);
2627             Molecule memory newMolecule = Molecule(
2628                 newItemId,
2629                 msg.sender,
2630                 msg.sender,
2631                 mintFeeAmount,
2632                 0,
2633                 0,
2634                 false,
2635                 false,
2636                 0,
2637                 1,
2638                 0,
2639                 0
2640             );
2641             // add the token id to the allMolecules
2642             allMolecules[newItemId] = newMolecule;
2643             // increase mint price if 200 (or multiple thereof) has been minted for the next person minting
2644             // e.g. on avax mint price goes up by 0.5 avax every 200 NFTs
2645             if (newItemId%200 == 0){
2646                 uint256 addPrice = 5;
2647                 newPrice += addPrice.mul(1e17);
2648             }
2649         }
2650         mintFeeAmount = newPrice;
2651     }
2652 
2653     function changeUrl(string memory url) external onlyOwner {
2654         baseURL = url;
2655     }
2656 
2657     function setMoleculeKind(uint256[] memory _tokens, uint256[] memory _kinds) external onlyOwner{
2658         require(_tokens.length > 0, "lists can't be empty");
2659         require(_tokens.length == _kinds.length, "both lists should have same length");
2660         for (uint256 i = 0; i < _tokens.length; i++) {
2661             require(_exists(_tokens[i]), "token not found");
2662             Molecule memory mol = allMolecules[_tokens[i]];
2663             mol.kind = _kinds[i];
2664             allMolecules[_tokens[i]] = mol;
2665         }
2666     }
2667 
2668     function totalSupply() public view returns (uint256) {
2669         return _allTokens.length;
2670     }
2671 
2672 
2673     function setPriceForSale(
2674         uint256 _tokenId,
2675         uint256 _newPrice,
2676         bool isForSale
2677     ) external {
2678         require(_exists(_tokenId), "token not found");
2679         address tokenOwner = ownerOf(_tokenId);
2680         require(tokenOwner == msg.sender, "not owner");
2681         Molecule memory mol = allMolecules[_tokenId];
2682         require(mol.bonded == false);
2683         mol.price = _newPrice;
2684         mol.forSale = isForSale;
2685         allMolecules[_tokenId] = mol;
2686         emit SaleToggle(_tokenId, isForSale, _newPrice);
2687     }
2688 
2689     function getAllSaleTokens() public view returns (uint256[] memory) {
2690         uint256 _totalSupply = totalSupply();
2691         uint256[] memory _tokenForSales = new uint256[](_totalSupply);
2692         uint256 counter = 0;
2693         for (uint256 i = 1; i <= _totalSupply; i++) {
2694             if (allMolecules[i].forSale == true) {
2695                 _tokenForSales[counter] = allMolecules[i].tokenId;
2696                 counter++;
2697             }
2698         }
2699         return _tokenForSales;
2700     }
2701 
2702     // by a token by passing in the token's id
2703     function buyToken(uint256 _tokenId) public payable {
2704         // check if the token id of the token being bought exists or not
2705         require(_exists(_tokenId));
2706         // get the token's owner
2707         address tokenOwner = ownerOf(_tokenId);
2708         // token's owner should not be an zero address account
2709         require(tokenOwner != address(0));
2710         // the one who wants to buy the token should not be the token's owner
2711         require(tokenOwner != msg.sender);
2712         // get that token from all Molecules mapping and create a memory of it defined as (struct => Molecules)
2713         Molecule memory mol = allMolecules[_tokenId];
2714         // price sent in to buy should be equal to or more than the token's price
2715         require(msg.value >= mol.price);
2716         // token should be for sale
2717         require(mol.forSale);
2718         uint256 amount = msg.value;
2719         uint256 _royaltiesAmount = amount.mul(royaltyPercentage).div(100);
2720         uint256 payOwnerAmount = amount.sub(_royaltiesAmount);
2721         payable(_royaltiesAddr).transfer(_royaltiesAmount);
2722         payable(mol.currentOwner).transfer(payOwnerAmount);
2723         require(mol.bonded == false, "Molecule is Bonded");
2724         mol.previousPrice = mol.price;
2725         mol.bonded = false;
2726         mol.numberOfTransfers += 1;
2727         mol.price = 0;
2728         mol.forSale = false;
2729         allMolecules[_tokenId] = mol;
2730         _transfer(tokenOwner, msg.sender, _tokenId);
2731         emit PurchaseEvent(_tokenId, mol.currentOwner, msg.sender, mol.price);
2732     }
2733 
2734     function tokenOfOwnerByIndex(address owner, uint256 index)
2735         public
2736         view
2737         returns (uint256)
2738     {
2739         require(index < balanceOf(owner), "out of bounds");
2740         return _ownedTokens[owner][index];
2741     }
2742 
2743     //  URI Storage override functions
2744     /** Overrides ERC-721's _baseURI function */
2745     function _baseURI()
2746         internal
2747         view
2748         virtual
2749         override(ERC721)
2750         returns (string memory)
2751     {
2752         return baseURL;
2753     }
2754 
2755     function _burn(uint256 tokenId) internal override(ERC721) {
2756         super._burn(tokenId);
2757     }
2758 
2759     function tokenURI(uint256 tokenId)
2760         public
2761         view
2762         override(ERC721)
2763         returns (string memory)
2764     {
2765         return super.tokenURI(tokenId);
2766     }
2767 
2768     /**
2769      * @dev Hook that is called before any token transfer. This includes minting
2770      * and burning.
2771      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2772      */
2773     function _beforeTokenTransfer(
2774         address from,
2775         address to,
2776         uint256 tokenId
2777     ) internal virtual override(ERC721) {
2778         super._beforeTokenTransfer(from, to, tokenId);
2779         Molecule memory mol = allMolecules[tokenId];
2780         require(mol.bonded == false,"Molecule is bonded!");
2781         mol.currentOwner = to;
2782         mol.numberOfTransfers += 1;
2783         mol.forSale = false;
2784         allMolecules[tokenId] = mol;
2785         if (from == address(0)) {
2786             _addTokenToAllTokensEnumeration(tokenId);
2787         } else if (from != to) {
2788             _removeTokenFromOwnerEnumeration(from, tokenId);
2789         }
2790         if (to == address(0)) {
2791             _removeTokenFromAllTokensEnumeration(tokenId);
2792         } else if (to != from) {
2793             _addTokenToOwnerEnumeration(to, tokenId);
2794         }
2795     }
2796 
2797     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2798         uint256 length = balanceOf(to);
2799         _ownedTokens[to][length] = tokenId;
2800         _ownedTokensIndex[tokenId] = length;
2801     }
2802 
2803     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2804         _allTokensIndex[tokenId] = _allTokens.length;
2805         _allTokens.push(tokenId);
2806     }
2807 
2808     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
2809         private
2810     {
2811         uint256 lastTokenIndex = balanceOf(from) - 1;
2812         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2813 
2814         // When the token to delete is the last token, the swap operation is unnecessary
2815         if (tokenIndex != lastTokenIndex) {
2816             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2817 
2818             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2819             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2820         }
2821 
2822         // This also deletes the contents at the last position of the array
2823         delete _ownedTokensIndex[tokenId];
2824         delete _ownedTokens[from][lastTokenIndex];
2825     }
2826 
2827     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2828         uint256 lastTokenIndex = _allTokens.length - 1;
2829         uint256 tokenIndex = _allTokensIndex[tokenId];
2830 
2831         uint256 lastTokenId = _allTokens[lastTokenIndex];
2832 
2833         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2834         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2835 
2836         // This also deletes the contents at the last position of the array
2837         delete _allTokensIndex[tokenId];
2838         _allTokens.pop();
2839     }
2840 
2841     // upgrade contract to support authorized
2842 
2843     mapping(address => bool) public authorized;
2844 
2845     modifier onlyAuthorized() {
2846         require(authorized[msg.sender] ||  msg.sender == _owner , "Not authorized");
2847         _;
2848     }
2849 
2850     function addAuthorized(address _toAdd) public {
2851         require(msg.sender == _owner, 'Not owner');
2852         require(_toAdd != address(0));
2853         authorized[_toAdd] = true;
2854     }
2855 
2856     function removeAuthorized(address _toRemove) public {
2857         require(msg.sender == _owner, 'Not owner');
2858         require(_toRemove != address(0));
2859         require(_toRemove != msg.sender);
2860         authorized[_toRemove] = false;
2861     }
2862 
2863     // upgrade contract to allow OXG Nodes to 
2864 
2865     function bondMolecule(address account,uint256 _tokenId, uint256 nodeCreationTime) external onlyAuthorized {
2866         require(_exists(_tokenId), "token not found");
2867         address tokenOwner = ownerOf(_tokenId);
2868         require(tokenOwner == account, "not owner");
2869         Molecule memory mol = allMolecules[_tokenId];
2870         require(mol.bonded == false, "Molecule already bonded");
2871         mol.bonded = true;
2872         allMolecules[_tokenId] = mol;
2873         emit moleculeBonded(_tokenId, account, nodeCreationTime);
2874     }
2875 
2876     function unbondMolecule(address account,uint256 _tokenId, uint256 nodeCreationTime) external onlyAuthorized {
2877         require(_exists(_tokenId), "token not found");
2878         address tokenOwner = ownerOf(_tokenId);
2879         require(tokenOwner == account, "not owner");
2880         Molecule memory mol = allMolecules[_tokenId];
2881         require(mol.bonded == true, "Molecule not bonded");
2882         require(mol.bondedTime + unbondingTime > block.timestamp, "You have to wait 7 days from bonding to unbond");
2883         mol.bonded = false;
2884         allMolecules[_tokenId] = mol;
2885         emit moleculeUnbonded(_tokenId, account, nodeCreationTime);
2886     }
2887 
2888     function growMolecule(uint256 _tokenId) external onlyAuthorized {
2889         require(_exists(_tokenId), "token not found");
2890         Molecule memory mol = allMolecules[_tokenId];
2891         mol.level += 1;
2892         allMolecules[_tokenId] = mol;
2893         emit moleculeGrown(_tokenId, mol.level);
2894     }
2895 
2896     function getMoleculeLevel(uint256 _tokenId) public view returns(uint256){
2897         Molecule memory mol = allMolecules[_tokenId];
2898         return mol.level;
2899     }
2900 
2901     function getMoleculeKind(uint256 _tokenId) public view returns(uint256) {
2902         Molecule memory mol = allMolecules[_tokenId];
2903         return mol.kind;
2904     }
2905 
2906     //function to return all the structure data.
2907 
2908 
2909 
2910 
2911 }
2912 // File: contracts/NodeManager.sol
2913 
2914 
2915 pragma solidity ^0.8.4;
2916 
2917 
2918 
2919 
2920 
2921 
2922 contract NodeManager is Ownable, Pausable {
2923   using SafeMath for uint256;
2924   using IterableMapping for IterableMapping.Map;
2925 
2926   struct NodeEntity {
2927     string name;
2928     uint256 creationTime;
2929     uint256 lastClaimTime;
2930     uint256 amount;
2931     uint256 tier;
2932     uint256 totalClaimed;
2933     uint256 borrowedRewards;
2934     uint256[3] bondedMolecules; // tokenId of bonded molecules
2935     uint256 bondedMols; //number of molecules bonded
2936   }
2937 
2938   IterableMapping.Map private nodeOwners;
2939   mapping(address => NodeEntity[]) private _nodesOfUser;
2940 
2941   Molecules public molecules;
2942 
2943   address public token;
2944   uint256 public totalNodesCreated = 0;
2945   uint256 public totalStaked = 0;
2946   uint256 public totalClaimed = 0;
2947 
2948   uint256 public levelMultiplier = 250; // bps 250 = 2.5%
2949 
2950   uint256[] public _tiersPrice = [1, 6, 20, 50, 150];
2951   uint256[] public _tiersRewards = [1250,8000,30000,87500,300000]; // 10000 => 1 OXG
2952   uint256[] public _boostMultipliers = [102, 105, 110, 130, 200]; // %
2953   uint256[] public _boostRequiredDays = [35, 56, 84, 183, 365]; // days
2954   uint256[] public _paperHandsTaxes = [150, 100, 40, 0]; // %; 10 => 1
2955   uint256[] public _paperHandsWeeks = [1, 2, 3, 4]; // weeks
2956   uint256[] public _claimTaxFees = [8, 8, 8, 8, 8]; // %, match with tiers
2957 
2958 
2959 
2960   event NodeCreated(
2961     address indexed account,
2962     uint256 indexed blockTime,
2963     uint256 indexed amount
2964   );
2965 
2966   event NodeBondedToMolecule(
2967     address account,
2968     uint256 tokenID,
2969     uint256 nodeCreationTime
2970   );
2971 
2972   event NodeUnbondedToMolecule(
2973     address account,
2974     uint256 tokenID,
2975     uint256 nodeCreationTime
2976   );
2977 
2978   modifier onlyGuard() {
2979     require(owner() == _msgSender() || token == _msgSender(), "NOT_GUARD");
2980     _;
2981   }
2982 
2983   constructor() {}
2984 
2985   // Private methods
2986 
2987 
2988   function _isNameAvailable(address account, string memory nodeName)
2989     private
2990     view
2991     returns (bool)
2992   {
2993     NodeEntity[] memory nodes = _nodesOfUser[account];
2994     for (uint256 i = 0; i < nodes.length; i++) {
2995       if (keccak256(bytes(nodes[i].name)) == keccak256(bytes(nodeName))) {
2996         return false;
2997       }
2998     }
2999     return true;
3000   }
3001 
3002   function _getNodeWithCreatime(
3003     NodeEntity[] storage nodes,
3004     uint256 _creationTime
3005   ) private view returns (NodeEntity storage) {
3006     uint256 numberOfNodes = nodes.length;
3007     require(
3008       numberOfNodes > 0,
3009       "CASHOUT ERROR: You don't have nodes to cash-out"
3010     );
3011     bool found = false;
3012     int256 index = _binarySearch(nodes, 0, numberOfNodes, _creationTime);
3013     uint256 validIndex;
3014     if (index >= 0) {
3015       found = true;
3016       validIndex = uint256(index);
3017     }
3018     require(found, "NODE SEARCH: No NODE Found with this blocktime");
3019     return nodes[validIndex];
3020   }
3021 
3022   function _binarySearch(
3023     NodeEntity[] memory arr,
3024     uint256 low,
3025     uint256 high,
3026     uint256 x
3027   ) private view returns (int256) {
3028     if (high >= low) {
3029       uint256 mid = (high + low).div(2);
3030       if (arr[mid].creationTime == x) {
3031         return int256(mid);
3032       } else if (arr[mid].creationTime > x) {
3033         return _binarySearch(arr, low, mid - 1, x);
3034       } else {
3035         return _binarySearch(arr, mid + 1, high, x);
3036       }
3037     } else {
3038       return -1;
3039     }
3040   }
3041 
3042   
3043   function _uint2str(uint256 _i)
3044     private
3045     pure
3046     returns (string memory _uintAsString)
3047   {
3048     if (_i == 0) {
3049       return "0";
3050     }
3051     uint256 j = _i;
3052     uint256 len;
3053     while (j != 0) {
3054       len++;
3055       j /= 10;
3056     }
3057     bytes memory bstr = new bytes(len);
3058     uint256 k = len;
3059     while (_i != 0) {
3060       k = k - 1;
3061       uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
3062       bytes1 b1 = bytes1(temp);
3063       bstr[k] = b1;
3064       _i /= 10;
3065     }
3066     return string(bstr);
3067   }
3068 
3069   function _calculateNodeRewards(
3070     uint256 _lastClaimTime,
3071     uint256 _tier
3072   ) private view returns (uint256 rewards) {
3073     uint256 elapsedTime_ = (block.timestamp - _lastClaimTime);
3074     uint256 boostMultiplier = _calculateBoost(elapsedTime_);
3075     uint256 rewardPerMonth = _tiersRewards[_tier];
3076     return
3077       rewardPerMonth.mul(1e18).div(2628000).mul(elapsedTime_).mul(boostMultiplier).div(100).div(10000);
3078   }
3079 
3080   function _calculateBoost(uint256 elapsedTime_)
3081     internal
3082     view
3083     returns (uint256)
3084   {
3085     uint256 elapsedTimeInDays_ = elapsedTime_ / 1 days;
3086 
3087     if (elapsedTimeInDays_ >= _boostRequiredDays[4]) {
3088       return _boostMultipliers[4];
3089     } else if (elapsedTimeInDays_ >= _boostRequiredDays[3]) {
3090       return _boostMultipliers[3];
3091     } else if (elapsedTimeInDays_ >= _boostRequiredDays[2]) {
3092       return _boostMultipliers[2];
3093     } else if (elapsedTimeInDays_ >= _boostRequiredDays[1]) {
3094       return _boostMultipliers[1];
3095     } else if (elapsedTimeInDays_ >= _boostRequiredDays[0]) {
3096       return _boostMultipliers[0];
3097     } else {
3098       return 100;
3099     }
3100   }
3101 
3102   // External methods
3103 
3104    function upgradeNode(address account, uint256 blocktime) 
3105     external
3106     onlyGuard
3107     whenNotPaused
3108     {
3109         require(blocktime > 0, "NODE: CREATIME must be higher than zero");
3110         NodeEntity[] storage nodes = _nodesOfUser[account];
3111         require(
3112             nodes.length > 0,
3113             "CASHOUT ERROR: You don't have nodes to cash-out"
3114             );
3115         NodeEntity storage node = _getNodeWithCreatime(nodes, blocktime);
3116         node.tier += 1;
3117     }
3118 
3119     function borrowRewards(address account, uint256 blocktime, uint256 amount)
3120     external
3121     onlyGuard
3122     whenNotPaused
3123     {
3124         require(blocktime > 0, "NODE: blocktime must be higher than zero");
3125         NodeEntity[] storage nodes = _nodesOfUser[account];
3126         require(
3127             nodes.length > 0,
3128             "You don't have any nodes"
3129         );
3130         NodeEntity storage node = _getNodeWithCreatime(nodes, blocktime);
3131         uint256 rewardsAvailable = _calculateNodeRewards(node.lastClaimTime, node.tier).sub(node.borrowedRewards);
3132         require(rewardsAvailable >= amount,"You do not have enough rewards available");
3133         node.borrowedRewards += amount;
3134     }
3135 
3136   function createNode(
3137     address account,
3138     string memory nodeName,
3139     uint256 _tier
3140   ) external onlyGuard whenNotPaused {
3141     require(_isNameAvailable(account, nodeName), "Name not available");
3142     NodeEntity[] storage _nodes = _nodesOfUser[account];
3143     require(_nodes.length <= 100, "Max nodes exceeded");
3144     uint256 amount = getNodePrice(_tier);
3145     _nodes.push(
3146       NodeEntity({
3147         name: nodeName,
3148         creationTime: block.timestamp,
3149         lastClaimTime: block.timestamp,
3150         amount: amount,
3151         tier: _tier,
3152         totalClaimed: 0,
3153         borrowedRewards: 0,
3154         bondedMolecules: [uint256(0),0,0],
3155         bondedMols: 0
3156       })
3157     );
3158     nodeOwners.set(account, _nodesOfUser[account].length);
3159     emit NodeCreated(account, block.timestamp, amount);
3160     totalNodesCreated++;
3161     totalStaked += amount;
3162   }
3163 
3164   function getNodeReward(address account, uint256 _creationTime)
3165     public
3166     view
3167     returns (uint256)
3168   {
3169     require(_creationTime > 0, "NODE: CREATIME must be higher than zero");
3170     NodeEntity[] storage nodes = _nodesOfUser[account];
3171     require(
3172       nodes.length > 0,
3173       "CASHOUT ERROR: You don't have nodes to cash-out"
3174     );
3175     NodeEntity storage node = _getNodeWithCreatime(nodes, _creationTime);
3176     return _calculateNodeRewards(node.lastClaimTime, node.tier).mul(getNodeAPRIncrease(account, _creationTime)).div(10000).sub(node.borrowedRewards);
3177   }
3178 
3179   function getAllNodesRewards(address account) external view returns (uint256[2] memory) {
3180     NodeEntity[] storage nodes = _nodesOfUser[account];
3181     uint256 nodesCount = nodes.length;
3182     require(nodesCount > 0, "NODE: CREATIME must be higher than zero");
3183     NodeEntity storage _node;
3184     uint256 rewardsTotal = 0;
3185     uint256 taxTotal = 0;
3186     for (uint256 i = 0; i < nodesCount; i++) {
3187       _node = nodes[i];
3188       uint256 nodeReward =  _calculateNodeRewards(
3189         _node.lastClaimTime,
3190         _node.tier
3191       ).sub(_node.borrowedRewards);
3192       nodeReward = nodeReward;
3193       taxTotal += getNodeFee(account, _node.creationTime, nodeReward);
3194       rewardsTotal += nodeReward;
3195     }
3196     return [rewardsTotal, taxTotal];
3197   }
3198 
3199   function cashoutNodeReward(address account, uint256 _creationTime)
3200     external
3201     onlyGuard
3202     whenNotPaused
3203   {
3204     require(_creationTime > 0, "NODE: CREATIME must be higher than zero");
3205     NodeEntity[] storage nodes = _nodesOfUser[account];
3206     require(
3207       nodes.length > 0,
3208       "CASHOUT ERROR: You don't have nodes to cash-out"
3209     );
3210     NodeEntity storage node = _getNodeWithCreatime(nodes, _creationTime);
3211     uint256 toClaim = _calculateNodeRewards(
3212       node.lastClaimTime,
3213       node.tier
3214     ).sub(node.borrowedRewards);
3215     node.totalClaimed += toClaim;
3216     node.lastClaimTime = block.timestamp;
3217     node.borrowedRewards = 0;
3218   }
3219 
3220   function cashoutAllNodesRewards(address account)
3221     external
3222     onlyGuard
3223     whenNotPaused 
3224   {
3225     NodeEntity[] storage nodes = _nodesOfUser[account];
3226     uint256 nodesCount = nodes.length;
3227     require(nodesCount > 0, "NODE: CREATIME must be higher than zero");
3228     NodeEntity storage _node;
3229     for (uint256 i = 0; i < nodesCount; i++) {
3230       _node = nodes[i];  
3231       uint256 toClaim = _calculateNodeRewards(
3232         _node.lastClaimTime,
3233         _node.tier
3234       ).sub(_node.borrowedRewards);
3235       _node.totalClaimed += toClaim;
3236       _node.lastClaimTime = block.timestamp;
3237       _node.borrowedRewards = 0;
3238     }
3239   }
3240 
3241   function setMoleculeAddress(address _moleculesAddress) external onlyOwner {
3242       molecules = Molecules(_moleculesAddress);
3243     }
3244 
3245 
3246 
3247   function bondNFT(uint256 _creationTime, uint256 _tokenId) external {
3248     address account = _msgSender();
3249     require(_creationTime > 0, "NODE: CREATIME must be higher than zero");
3250     NodeEntity[] storage nodes = _nodesOfUser[account];
3251     require(
3252       nodes.length > 0,
3253       "You don't own any nodes"
3254     );
3255     NodeEntity storage node = _getNodeWithCreatime(nodes, _creationTime);
3256     require(node.bondedMols < 3,"Already bonded to enough molecules");
3257     molecules.bondMolecule(account, _tokenId, node.creationTime);
3258     node.bondedMolecules[node.bondedMols] = _tokenId;
3259     node.bondedMols += 1;
3260     emit NodeBondedToMolecule(account, _tokenId, _creationTime);
3261   }
3262 
3263   // function to unbond NFT 
3264 
3265   function unbondNFT(uint256 _creationTime, uint256 _tokenId) external {
3266     address account = _msgSender();
3267     require(_creationTime > 0, "NODE: CREATIME must be higher than zero");
3268     NodeEntity[] storage nodes = _nodesOfUser[account];
3269     require(
3270       nodes.length > 0,
3271       "You don't own any nodes"
3272     );
3273     NodeEntity storage node = _getNodeWithCreatime(nodes, _creationTime);
3274     require(node.bondedMols > 0,"No Molecules Bonded");
3275     molecules.unbondMolecule(account, _tokenId, node.creationTime);
3276     uint256[3] memory newArray = [uint256(0),0,0];
3277     for (uint256 i = 0 ; i < node.bondedMols; i++) {
3278         if (node.bondedMolecules[i] != _tokenId) {
3279           newArray[i] = node.bondedMolecules[i];
3280         }
3281     }
3282     node.bondedMolecules = newArray;
3283     node.bondedMols -= 1;
3284     emit NodeUnbondedToMolecule(account, _tokenId, _creationTime);
3285   }
3286 
3287   function getNodesNames(address account) public view returns (string memory) {
3288     NodeEntity[] memory nodes = _nodesOfUser[account];
3289     uint256 nodesCount = nodes.length;
3290     NodeEntity memory _node;
3291     string memory names = nodes[0].name;
3292     string memory separator = "#";
3293     for (uint256 i = 1; i < nodesCount; i++) {
3294       _node = nodes[i];
3295       names = string(abi.encodePacked(names, separator, _node.name));
3296     }
3297     return names;
3298   }
3299 
3300   function getNodesRewards(address account) public view returns (string memory) {
3301     NodeEntity[] memory nodes = _nodesOfUser[account];
3302     uint256 nodesCount = nodes.length;
3303     NodeEntity memory _node;
3304     string memory rewards = _uint2str(_calculateNodeRewards(nodes[0].lastClaimTime, nodes[0].tier).mul(getNodeAPRIncrease(account, nodes[0].creationTime)).div(10000).sub(nodes[0].borrowedRewards));
3305     string memory separator = "#";
3306     for (uint256 i = 1; i < nodesCount; i++) {
3307       _node = nodes[i];
3308       string memory _rewardStr = _uint2str(_calculateNodeRewards(_node.lastClaimTime, _node.tier).mul(getNodeAPRIncrease(account, _node.creationTime)).div(10000).sub(_node.borrowedRewards));
3309       rewards = string(abi.encodePacked(rewards, separator, _rewardStr));
3310     }
3311     return rewards;
3312   }
3313 
3314   function getNodesCreationTime(address account)
3315     public
3316     view
3317     returns (string memory)
3318   {
3319     NodeEntity[] memory nodes = _nodesOfUser[account];
3320     uint256 nodesCount = nodes.length;
3321     NodeEntity memory _node;
3322     string memory _creationTimes = _uint2str(nodes[0].creationTime);
3323     string memory separator = "#";
3324 
3325     for (uint256 i = 1; i < nodesCount; i++) {
3326       _node = nodes[i];
3327 
3328       _creationTimes = string(
3329         abi.encodePacked(
3330           _creationTimes,
3331           separator,
3332           _uint2str(_node.creationTime)
3333         )
3334       );
3335     }
3336     return _creationTimes;
3337   }
3338 
3339   function getNodeAPRIncrease(address account, uint256 _creationTime) public view returns (uint256){
3340     require(_creationTime > 0, "NODE: CREATIME must be higher than zero");
3341     NodeEntity[] storage nodes = _nodesOfUser[account];
3342     require(
3343       nodes.length > 0,
3344       "You don't own any nodes"
3345     );
3346     NodeEntity storage node = _getNodeWithCreatime(nodes, _creationTime);
3347     if (node.bondedMols == 0){
3348       uint256 totalApyBenefit = 10000;
3349       return totalApyBenefit;
3350     }
3351     else {
3352       uint256 totalApyBenefit = 0;
3353       for (uint256 i = 0; i < node.bondedMols; i++) {
3354         if (molecules.getMoleculeKind(node.bondedMolecules[i]) == 2 || molecules.getMoleculeKind(node.bondedMolecules[i]) == 3) {
3355           uint256 APYBenefit = molecules.getMoleculeLevel(node.bondedMolecules[i]).mul(levelMultiplier).add(250);
3356           totalApyBenefit += APYBenefit;
3357         }
3358       }
3359       totalApyBenefit += 10000;
3360       return totalApyBenefit;
3361     }
3362   }
3363 
3364   
3365   function getNodeTaxDecrease(address account, uint256 _creationTime) public view returns (uint256){
3366     require(_creationTime > 0, "NODE: CREATIME must be higher than zero");
3367     NodeEntity[] storage nodes = _nodesOfUser[account];
3368     require(
3369       nodes.length > 0,
3370       "You don't own any nodes"
3371     );
3372     NodeEntity storage node = _getNodeWithCreatime(nodes, _creationTime);
3373     if (node.bondedMols == 0){
3374       uint256 totalTaxDecrease = 0;
3375       return totalTaxDecrease;
3376     }
3377     else {
3378       uint256 totalTaxDecrease = 0;
3379       for (uint256 i = 0; i < node.bondedMols; i++) {
3380         if (molecules.getMoleculeKind(node.bondedMolecules[i]) == 1 || molecules.getMoleculeKind(node.bondedMolecules[i]) == 3) {
3381           uint256 APYBenefit = molecules.getMoleculeLevel(node.bondedMolecules[i]).mul(levelMultiplier).add(250);
3382           totalTaxDecrease += APYBenefit;
3383         }
3384       }
3385       if (totalTaxDecrease > 10000) {
3386         totalTaxDecrease = 10000;
3387       }
3388       return totalTaxDecrease;
3389     }
3390   }
3391 
3392 
3393   function getNodesLastClaimTime(address account)
3394     public
3395     view
3396     returns (string memory)
3397   {
3398     NodeEntity[] memory nodes = _nodesOfUser[account];
3399     uint256 nodesCount = nodes.length;
3400     NodeEntity memory _node;
3401     string memory _lastClaimTimes = _uint2str(nodes[0].lastClaimTime);
3402     string memory separator = "#";
3403 
3404     for (uint256 i = 1; i < nodesCount; i++) {
3405       _node = nodes[i];
3406 
3407       _lastClaimTimes = string(
3408         abi.encodePacked(
3409           _lastClaimTimes,
3410           separator,
3411           _uint2str(_node.lastClaimTime)
3412         )
3413       );
3414     }
3415     return _lastClaimTimes;
3416   }
3417 
3418   function getNodeFee(
3419     address account,
3420     uint256 _creationTime,
3421     uint256 _rewardsAmount
3422   ) public view returns (uint256) {
3423     require(_creationTime > 0, "NODE: CREATIME must be higher than zero");
3424     NodeEntity[] storage nodes = _nodesOfUser[account];
3425     require(
3426       nodes.length > 0,
3427       "CASHOUT ERROR: You don't have nodes to cash-out"
3428     );
3429     NodeEntity storage node = _getNodeWithCreatime(nodes, _creationTime);
3430 
3431     uint256 paperHandsTax = 0;
3432     uint256 claimTx = _rewardsAmount.mul(_claimTaxFees[node.tier]).div(100);
3433 
3434     uint256 elapsedSeconds = block.timestamp - node.lastClaimTime;
3435 
3436     if (elapsedSeconds >= _paperHandsWeeks[3].mul(86400).mul(7)) {
3437       paperHandsTax = _rewardsAmount.mul(_paperHandsTaxes[3]).div(1000);
3438     } else if (elapsedSeconds >= _paperHandsWeeks[2].mul(86400).mul(7)) {
3439       paperHandsTax = _rewardsAmount.mul(_paperHandsTaxes[2]).div(1000);
3440     } else if (elapsedSeconds >= _paperHandsWeeks[1].mul(86400).mul(7)) {
3441       paperHandsTax = _rewardsAmount.mul(_paperHandsTaxes[1]).div(1000);
3442     } else if (elapsedSeconds >= _paperHandsWeeks[0].mul(86400).mul(7)) {
3443       paperHandsTax = _rewardsAmount.mul(_paperHandsTaxes[0]).div(1000);
3444     } else {
3445       paperHandsTax = _rewardsAmount.mul(200).div(1000);
3446     }
3447     uint256 totalTax = claimTx.add(paperHandsTax);
3448     uint256 taxRebate = totalTax.mul(getNodeTaxDecrease(account,_creationTime)).div(10000);
3449 
3450     return totalTax.sub(taxRebate);
3451   }
3452 
3453   function updateToken(address newToken) external onlyOwner {
3454     token = newToken;
3455   }
3456 
3457   function updateTiersRewards(uint256[] memory newVal) external onlyOwner {
3458     require(newVal.length == 5, "Wrong length");
3459     _tiersRewards = newVal;
3460   }
3461 
3462   function updateTiersPrice(uint256[] memory newVal) external onlyOwner {
3463     require(newVal.length == 5, "Wrong length");
3464     _tiersPrice = newVal;
3465   }
3466 
3467   function updateBoostMultipliers(uint8[] calldata newVal) external onlyOwner {
3468     require(newVal.length == 5, "Wrong length");
3469     _boostMultipliers = newVal;
3470   }
3471 
3472   function updateBoostRequiredDays(uint8[] calldata newVal) external onlyOwner {
3473     require(newVal.length == 5, "Wrong length");
3474     _boostRequiredDays = newVal;
3475   }
3476 
3477   function getNodeTier(address account, uint256 blocktime) public view returns (uint256) {
3478     require(blocktime > 0, "Creation Time has to be higher than 0");
3479     require(isNodeOwner(account), "NOT NODE OWNER");
3480     NodeEntity[] storage nodes = _nodesOfUser[account];
3481     uint256 numberOfNodes = nodes.length;
3482     require(
3483         numberOfNodes > 0,
3484         "You don't own any nodes."
3485     );
3486     NodeEntity storage node = _getNodeWithCreatime(nodes, blocktime);
3487     return node.tier;
3488   }
3489 
3490   function getNodePrice(uint256 _tierIndex) public view returns (uint256) {
3491     return _tiersPrice[_tierIndex];
3492   }
3493 
3494   function getNodeNumberOf(address account) external view returns (uint256) {
3495     return nodeOwners.get(account);
3496   }
3497 
3498   function isNodeOwner(address account) public view returns (bool) {
3499     return nodeOwners.get(account) > 0;
3500   }
3501 
3502   function getNodeMolecules(address account, uint256 blocktime) public view returns (uint256[3] memory) {
3503     require(blocktime > 0, "Creation Time has to be higher than 0");
3504     require(isNodeOwner(account), "NOT NODE OWNER");
3505     NodeEntity[] storage nodes = _nodesOfUser[account];
3506     uint256 numberOfNodes = nodes.length;
3507     require(
3508         numberOfNodes > 0,
3509         "You don't own any nodes."
3510     );
3511     NodeEntity storage node = _getNodeWithCreatime(nodes, blocktime);
3512     return node.bondedMolecules;
3513   }
3514 
3515   function getAllNodes(address account)
3516     external
3517     view
3518     returns (NodeEntity[] memory)
3519   {
3520     return _nodesOfUser[account];
3521   }
3522 
3523   function getIndexOfKey(address account)
3524     external
3525     view
3526     onlyOwner
3527     returns (int256)
3528   {
3529     require(account != address(0));
3530     return nodeOwners.getIndexOfKey(account);
3531   }
3532 
3533   function burn(uint256 index) external onlyOwner {
3534     require(index < nodeOwners.size());
3535     nodeOwners.remove(nodeOwners.getKeyAtIndex(index));
3536   }
3537 
3538   // User Methods
3539 
3540   function changeNodeName(uint256 _creationTime, string memory newName) 
3541     public 
3542     {
3543         address sender = msg.sender;
3544         require(isNodeOwner(sender), "NOT NODE OWNER");
3545         NodeEntity[] storage nodes = _nodesOfUser[sender];
3546         uint256 numberOfNodes = nodes.length;
3547         require(
3548             numberOfNodes > 0,
3549             "You don't own any nodes."
3550         );
3551         NodeEntity storage node = _getNodeWithCreatime(nodes, _creationTime);
3552         node.name = newName;
3553     }
3554 
3555 
3556   // Firewall methods
3557 
3558   function pause() external onlyOwner {
3559     _pause();
3560   }
3561 
3562   function unpause() external onlyOwner {
3563     _unpause();
3564   }
3565 }
3566 // File: contracts/Oxygen_eth.sol
3567 
3568 
3569 
3570 pragma solidity ^0.8.4;
3571 
3572 
3573 
3574 
3575 
3576 
3577 
3578 
3579 
3580 
3581 
3582 contract OXG is ERC20, Ownable, PaymentSplitter {
3583     using SafeMath for uint256;
3584 
3585     NodeManager public nodeManager;
3586     Molecules public molecules;
3587 
3588 
3589     IUniswapV2Router02 public uniswapV2Router;
3590 
3591     address public uniswapV2Pair;
3592     address public teamPool;
3593     address public distributionPool;
3594     address public devPool;
3595     address public advisorPool;
3596 
3597     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
3598 
3599     uint256 public rewardsFee;
3600     uint256 public liquidityPoolFee;
3601     uint256 public futurFee;
3602     uint256 public totalFees;
3603 
3604     uint256 public sellTax = 10;
3605 
3606 
3607     uint256 public cashoutFee;
3608 
3609     uint256 private rwSwap;
3610     uint256 private devShare = 20;
3611     uint256 private advisorShare = 40;
3612     bool private swapping = false;
3613     bool private swapLiquify = true;
3614     uint256 public swapTokensAmount;
3615     uint256 public growMultiplier = 2e18; //multiplier for growing molecules e.g. level 1 molecule needs 2 OXG to become a level 2, level 2 needs 4 OXG to become level 3
3616 
3617     bool private tradingOpen = false;
3618     bool public nodeEnforced = true;
3619     uint256 private _openTradingBlock = 0;
3620     uint256 private maxTx = 375;
3621 
3622     mapping(address => bool) public _isBlacklisted;
3623     mapping(address => bool) public automatedMarketMakerPairs;
3624 
3625     event UpdateUniswapV2Router(
3626         address indexed newAddress,
3627         address indexed oldAddress
3628     );
3629 
3630     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
3631 
3632     event LiquidityWalletUpdated(
3633         address indexed newLiquidityWallet,
3634         address indexed oldLiquidityWallet
3635     );
3636 
3637     event SwapAndLiquify(
3638         uint256 tokensSwapped,
3639         uint256 ethReceived,
3640         uint256 tokensIntoLiqudity
3641     );
3642 
3643     constructor(
3644         address[] memory payees,
3645         uint256[] memory shares,
3646         address uniV2Router
3647     ) ERC20("Oxy-Fi", "OXY") PaymentSplitter(payees, shares) {
3648 
3649         teamPool = 0xaf4a303E107b47f11F2e744c547885b8A9A4E2F7;
3650         distributionPool = 0xAD2ea18F968a23a35580CF6Aca562d9F7b380644;
3651         devPool = 0x1feffA18be68B22A5882f76E180c1666EF667E15;
3652         advisorPool = 0x457276267e0f0C86a6Ddf3674Cc4f36e067C42e0;
3653 
3654         require(uniV2Router != address(0), "ROUTER CANNOT BE ZERO");
3655         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(uniV2Router);
3656 
3657         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
3658         .createPair(address(this), _uniswapV2Router.WETH());
3659 
3660         uniswapV2Router = _uniswapV2Router;
3661         uniswapV2Pair = _uniswapV2Pair;
3662 
3663         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
3664 
3665         futurFee = 13;
3666         rewardsFee = 80;
3667         liquidityPoolFee = 7;
3668         rwSwap = 25;
3669 
3670         totalFees = rewardsFee.add(liquidityPoolFee).add(futurFee);
3671 
3672 
3673         _mint(_msgSender(), 300000e18);
3674 
3675         require(totalSupply() == 300000e18, "CONSTR: totalSupply must equal 300,000");
3676         swapTokensAmount = 100 * (10**18);
3677     }
3678 
3679     function setNodeManagement(address nodeManagement) external onlyOwner {
3680         nodeManager = NodeManager(nodeManagement);
3681     }
3682 
3683     function setMolecules(address moleculesAddress) external onlyOwner {
3684         molecules = Molecules(moleculesAddress);
3685     }
3686 
3687     function updateUniswapV2Router(address newAddress) public onlyOwner {
3688         require(newAddress != address(uniswapV2Router), "TKN: The router already has that address");
3689         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
3690         uniswapV2Router = IUniswapV2Router02(newAddress);
3691         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
3692         .createPair(address(this), uniswapV2Router.WETH());
3693         uniswapV2Pair = _uniswapV2Pair;
3694     }
3695 
3696     function updateSwapTokensAmount(uint256 newVal) external onlyOwner {
3697         swapTokensAmount = newVal;
3698     }
3699 
3700     function updateFuturWall(address payable wall) external onlyOwner {
3701         teamPool = wall;
3702     }
3703 
3704     function updateDevWall(address payable wall) external onlyOwner {
3705         devPool = wall;
3706     }
3707 
3708     function updateRewardsWall(address payable wall) external onlyOwner {
3709         distributionPool = wall;
3710     }
3711 
3712     function updateRewardsFee(uint256 value) external onlyOwner {
3713         rewardsFee = value;
3714         totalFees = rewardsFee.add(liquidityPoolFee).add(futurFee);
3715     }
3716 
3717     function updateLiquidityFee(uint256 value) external onlyOwner {
3718         liquidityPoolFee = value;
3719         totalFees = rewardsFee.add(liquidityPoolFee).add(futurFee);
3720     }
3721 
3722     function updateFuturFee(uint256 value) external onlyOwner {
3723         futurFee = value;
3724         totalFees = rewardsFee.add(liquidityPoolFee).add(futurFee);
3725     }
3726 
3727     function updateCashoutFee(uint256 value) external onlyOwner {
3728         cashoutFee = value;
3729     }
3730 
3731     function updateRwSwapFee(uint256 value) external onlyOwner {
3732         rwSwap = value;
3733     }
3734 
3735     function updateSellTax(uint256 value) external onlyOwner {
3736         sellTax = value;
3737     }
3738 
3739 
3740     function setAutomatedMarketMakerPair(address pair, bool value)
3741     public
3742     onlyOwner
3743     {
3744         require(
3745             pair != uniswapV2Pair,
3746             "TKN: The PancakeSwap pair cannot be removed from automatedMarketMakerPairs"
3747         );
3748 
3749         _setAutomatedMarketMakerPair(pair, value);
3750     }
3751 
3752     function blacklistMalicious(address account, bool value)
3753     external
3754     onlyOwner
3755     {
3756         _isBlacklisted[account] = value;
3757     }
3758 
3759     function _setAutomatedMarketMakerPair(address pair, bool value) private {
3760         require(
3761             automatedMarketMakerPairs[pair] != value,
3762             "TKN: Automated market maker pair is already set to that value"
3763         );
3764         automatedMarketMakerPairs[pair] = value;
3765 
3766         emit SetAutomatedMarketMakerPair(pair, value);
3767     }
3768 
3769     function _transfer(
3770         address from,
3771         address to,
3772         uint256 amount
3773     ) internal override {
3774         require(
3775             !_isBlacklisted[from] && !_isBlacklisted[to],
3776             "Blacklisted address"
3777         );
3778         require(from != address(0), "ERC20: transfer from the zero address");
3779         require(to != address(0), "ERC20: transfer to the zero address");
3780         if (to == address(uniswapV2Pair) && (from != address(this) && from != owner()) && nodeEnforced){
3781             require(nodeManager.isNodeOwner(from), "You need to own a node to be able to sell");
3782             uint256 sellTaxAmount = amount.mul(sellTax).div(100);
3783             super._transfer(from,address(this), sellTaxAmount);
3784             amount = amount.sub(sellTaxAmount);
3785             
3786         }
3787         uint256 amount2 = amount;
3788         if (from != owner() && to != uniswapV2Pair && to != address(uniswapV2Router) && to != address(this) && from != address(this) ) {
3789             // require(tradingOpen, "Trading not yet enabled.");
3790             
3791             if (!tradingOpen) {
3792                 amount2 = amount.div(100);
3793                 super._transfer(from,address(this),amount.sub(amount2));
3794 
3795             }
3796 
3797             // anti whale
3798             if (to != teamPool && to != distributionPool && to != devPool && from != teamPool && from != distributionPool && from != devPool) {
3799                 uint256 walletBalance = balanceOf(address(to));
3800                 require(
3801                     amount2.add(walletBalance) <= maxTx.mul(1e18), 
3802                     "STOP TRYING TO BECOME A WHALE. WE KNOW WHO YOU ARE.")
3803                 ;
3804             }
3805         }
3806         super._transfer(from, to, amount2);
3807     }
3808 
3809 
3810     function swapAndLiquify(uint256 tokens) private {
3811         uint256 half = tokens.div(2);
3812         uint256 otherHalf = tokens.sub(half);
3813 
3814         uint256 initialBalance = address(this).balance;
3815 
3816         swapTokensForEth(half);
3817 
3818         uint256 newBalance = address(this).balance.sub(initialBalance);
3819 
3820         addLiquidity(otherHalf, newBalance);
3821 
3822         emit SwapAndLiquify(half, newBalance, otherHalf);
3823     }
3824 
3825     function swapTokensForEth(uint256 tokenAmount) private {
3826         address[] memory path = new address[](2);
3827         path[0] = address(this);
3828         path[1] = uniswapV2Router.WETH();
3829 
3830         _approve(address(this), address(uniswapV2Router), tokenAmount);
3831 
3832         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
3833             tokenAmount,
3834             0, // accept any amount of ETH
3835             path,
3836             address(this),
3837             block.timestamp
3838         );
3839     }
3840 
3841     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
3842         // approve token transfer to cover all possible scenarios
3843         _approve(address(this), address(uniswapV2Router), tokenAmount);
3844 
3845         // add the liquidity
3846         uniswapV2Router.addLiquidityETH{value: ethAmount}(
3847             address(this),
3848             tokenAmount,
3849             0, // slippage is unavoidable
3850             0, // slippage is unavoidable
3851             distributionPool,
3852             block.timestamp
3853         );
3854     }
3855 
3856     function createNodeWithTokens(string memory name, uint256  tier) public {
3857         require(
3858             bytes(name).length > 3 && bytes(name).length < 32,
3859             "NODE CREATION: NAME SIZE INVALID"
3860         );
3861         address sender = _msgSender();
3862         require(
3863             sender != address(0),
3864             "NODE CREATION:  creation from the zero address"
3865         );
3866         require(!_isBlacklisted[sender], "NODE CREATION: Blacklisted address");
3867         require(
3868             sender != distributionPool,
3869             "NODE CREATION: futur, dev and rewardsPool cannot create node"
3870         );
3871     
3872         uint256 nodePrice = nodeManager._tiersPrice(tier);
3873         require(
3874             balanceOf(sender) >= nodePrice.mul(1e18),
3875             "NODE CREATION: Balance too low for creation. Try lower tier."
3876         );
3877         uint256 contractTokenBalance = balanceOf(address(this));
3878         bool swapAmountOk = contractTokenBalance >= swapTokensAmount;
3879         if (
3880             swapAmountOk &&
3881             swapLiquify &&
3882             !swapping &&
3883             sender != owner() &&
3884             !automatedMarketMakerPairs[sender]
3885         ) {
3886             swapping = true;
3887 
3888             uint256 fdTokens = contractTokenBalance.mul(futurFee).div(100);
3889             uint256 devTokens = fdTokens.mul(devShare).div(100);
3890             uint256 advTokens = fdTokens.mul(advisorShare).div(100);
3891             uint256 teamTokens = fdTokens.sub(devTokens).sub(advTokens);
3892 
3893 
3894             uint256 rewardsPoolTokens = contractTokenBalance.mul(rewardsFee).div(100);
3895 
3896             uint256 rewardsTokenstoSwap = rewardsPoolTokens.mul(rwSwap).div(
3897                 100
3898             );
3899             
3900             super._transfer(address(this),distributionPool,rewardsPoolTokens.sub(rewardsTokenstoSwap));
3901 
3902             uint256 swapTokens = contractTokenBalance.mul(liquidityPoolFee).div(100);
3903             swapAndLiquify(swapTokens);
3904             swapTokensForEth(balanceOf(address(this)));
3905             uint256 totalTaxTokens = devTokens.add(teamTokens).add(rewardsTokenstoSwap).add(advTokens);
3906             
3907             uint256 ETHBalance = address(this).balance;
3908 
3909             payable(devPool).transfer(ETHBalance.mul(devTokens).div(totalTaxTokens));
3910             payable(teamPool).transfer(ETHBalance.mul(teamTokens).div(totalTaxTokens));
3911             payable(advisorPool).transfer(ETHBalance.mul(advTokens).div(totalTaxTokens));
3912             distributionPool.call{value: balanceOf(address(this))}("");
3913          
3914             swapping = false;
3915         }
3916         super._transfer(sender, address(this), nodePrice.mul(1e18));
3917         nodeManager.createNode(sender, name, tier);
3918     }
3919 
3920     function createNodeWithRewards(uint256 blocktime, string memory name, uint256 tier) public {
3921         require(
3922             bytes(name).length > 3 && bytes(name).length < 32,
3923             "NODE CREATION: NAME SIZE INVALID"
3924         );
3925         address sender = _msgSender();
3926         require(
3927             sender != address(0),
3928             "NODE CREATION:  creation from the zero address"
3929         );
3930         require(!_isBlacklisted[sender], "NODE CREATION: Blacklisted address");
3931         require(
3932             sender != distributionPool,
3933             "NODE CREATION: rewardsPool cannot create node"
3934         );
3935         uint256 nodePrice = nodeManager._tiersPrice(tier);
3936         uint256 rewardOf = nodeManager.getNodeReward(sender, blocktime);
3937         require(
3938             rewardOf >= nodePrice.mul(1e18),
3939             "NODE CREATION: Reward Balance too low for creation."
3940         );
3941         nodeManager.borrowRewards(sender, blocktime, nodeManager.getNodePrice(tier).mul(1e18));
3942         nodeManager.createNode(sender, name, tier);
3943         super._transfer(distributionPool, address(this), nodePrice.mul(1e18));
3944     }
3945 
3946 
3947     function upgradeNode(uint256 blocktime) public {
3948         address sender = _msgSender();
3949         require(sender != address(0), "Zero address not permitted");
3950         require(!_isBlacklisted[sender], "MANIA CSHT: Blacklisted address");
3951         require(
3952             sender != distributionPool,
3953             "Cannot upgrade nodes"
3954         );
3955         uint256 currentTier = nodeManager.getNodeTier(sender, blocktime);
3956         require(currentTier < 4, "Your Node is already at max level");
3957         uint256 nextTier = currentTier.add(1);
3958         uint256 currentPrice = nodeManager.getNodePrice(currentTier);
3959         uint256 newPrice = nodeManager.getNodePrice(nextTier);
3960         uint256 priceDiff = (newPrice.sub(currentPrice)).mul(1e18);
3961         uint256 rewardOf = nodeManager.getNodeReward(sender, blocktime);
3962         if (rewardOf > priceDiff) {
3963             upgradeNodeCashout(sender, blocktime, rewardOf.sub(priceDiff));
3964             super._transfer(distributionPool, address(this), priceDiff);
3965             nodeManager.cashoutNodeReward(sender, blocktime);
3966 
3967         }
3968         else if (rewardOf < priceDiff) {
3969             upgradeNodeAddOn(sender, blocktime, priceDiff.sub(rewardOf));
3970             super._transfer(distributionPool, address(this), rewardOf);
3971             nodeManager.cashoutNodeReward(sender, blocktime);
3972         }
3973         
3974     }
3975 
3976     function upgradeNodeCashout(address account, uint256 blocktime, uint256 cashOutAmount) internal {
3977         uint256 taxAmount = nodeManager.getNodeFee(account, blocktime,cashOutAmount);
3978         super._transfer(distributionPool, account, cashOutAmount.sub(taxAmount)); 
3979         super._transfer(distributionPool, address(this), taxAmount);
3980         nodeManager.upgradeNode(account, blocktime);
3981     }
3982 
3983     function upgradeNodeAddOn(address account, uint256 blocktime, uint256 AddAmount) internal {
3984         super._transfer(account, address(this), AddAmount);
3985         nodeManager.upgradeNode(account, blocktime);
3986     }
3987 
3988     function growMolecule(uint256 _tokenId) external {
3989         address sender = _msgSender();
3990         uint256 molLevel = molecules.getMoleculeLevel(_tokenId);
3991         uint256 growPrice = molLevel.mul(growMultiplier);
3992         require(balanceOf(sender) > growPrice, "Not enough OXG to grow your Molecule");
3993         super._transfer(sender, address(this), growPrice);
3994         molecules.growMolecule(_tokenId);
3995     }
3996 
3997 
3998     function cashoutReward(uint256 blocktime) public {
3999         address sender = _msgSender();
4000         require(sender != address(0), "CSHT:  can't from the zero address");
4001         require(!_isBlacklisted[sender], "MANIA CSHT: Blacklisted address");
4002         require(
4003             sender != teamPool && sender != distributionPool,
4004             "CSHT: futur and rewardsPool cannot cashout rewards"
4005         );
4006         uint256 rewardAmount = nodeManager.getNodeReward(
4007             sender,
4008             blocktime
4009         );
4010         require(
4011             rewardAmount > 0,
4012             "CSHT: You don't have enough reward to cash out"
4013         );
4014 
4015         uint256 taxAmount = nodeManager.getNodeFee(sender, blocktime,rewardAmount);
4016         super._transfer(distributionPool, sender, rewardAmount.sub(taxAmount));
4017         super._transfer(distributionPool, address(this), taxAmount);
4018         nodeManager.cashoutNodeReward(sender, blocktime);
4019     }
4020 
4021     function cashoutAll() public {
4022         address sender = _msgSender();
4023         require(
4024             sender != address(0),
4025             "MANIA CSHT:  creation from the zero address"
4026         );
4027         require(!_isBlacklisted[sender], "MANIA CSHT: Blacklisted address");
4028         require(
4029             sender != teamPool && sender != distributionPool,
4030             "MANIA CSHT: futur and rewardsPool cannot cashout rewards"
4031         );
4032         uint256[2] memory rewardTax = nodeManager.getAllNodesRewards(sender);
4033         uint256 rewardAmount = rewardTax[0];
4034         uint256 taxAmount = rewardTax[1];
4035         require(
4036             rewardAmount > 0,
4037             "MANIA CSHT: You don't have enough reward to cash out"
4038         );
4039         super._transfer(distributionPool, sender, rewardAmount);
4040         super._transfer(distributionPool, address(this), taxAmount);
4041         nodeManager.cashoutAllNodesRewards(sender);
4042     }
4043 
4044     function rescueFunds(uint amount) public onlyOwner {
4045         if (amount > address(this).balance) amount = address(this).balance;
4046         payable(owner()).transfer(amount);
4047     }
4048 
4049 
4050     function changeSwapLiquify(bool newVal) public onlyOwner {
4051         swapLiquify = newVal;
4052     }
4053 
4054     function getNodeNumberOf(address account) public view returns (uint256) {
4055         return nodeManager.getNodeNumberOf(account);
4056     }
4057 
4058     function getRewardAmountOf(address account)
4059     public
4060     view
4061     onlyOwner
4062     returns (uint256[2] memory)
4063     {
4064         return nodeManager.getAllNodesRewards(account);
4065     }
4066 
4067     function getRewardAmount() public view returns (uint256[2] memory) {
4068         require(_msgSender() != address(0), "SENDER CAN'T BE ZERO");
4069         require(
4070             nodeManager.isNodeOwner(_msgSender()),
4071             "NO NODE OWNER"
4072         );
4073         return nodeManager.getAllNodesRewards(_msgSender());
4074     }
4075 
4076     function updateTiersRewards(uint256[] memory newVal) external onlyOwner {
4077         require(newVal.length == 5, "Wrong length");
4078         nodeManager.updateTiersRewards(newVal);
4079   }
4080 
4081     function getNodesNames() public view returns (string memory) {
4082         require(_msgSender() != address(0), "SENDER CAN'T BE ZERO");
4083         require(
4084             nodeManager.isNodeOwner(_msgSender()),
4085             "NO NODE OWNER"
4086         );
4087         return nodeManager.getNodesNames(_msgSender());
4088     }
4089 
4090     function getNodesCreatime() public view returns (string memory) {
4091         require(_msgSender() != address(0), "SENDER CAN'T BE ZERO");
4092         require(
4093             nodeManager.isNodeOwner(_msgSender()),
4094             "NO NODE OWNER"
4095         );
4096         return nodeManager.getNodesCreationTime(_msgSender());
4097     }
4098 
4099     function getNodesRewards() public view returns (string memory) {
4100         require(_msgSender() != address(0), "SENDER CAN'T BE ZERO");
4101         require(
4102             nodeManager.isNodeOwner(_msgSender()),
4103             "NO NODE OWNER"
4104         );
4105         return nodeManager.getNodesRewards(_msgSender());
4106     }
4107 
4108     function getNodesLastClaims() public view returns (string memory) {
4109         require(_msgSender() != address(0), "SENDER CAN'T BE ZERO");
4110         require(
4111             nodeManager.isNodeOwner(_msgSender()),
4112             "NO NODE OWNER"
4113         );
4114         return nodeManager.getNodesLastClaimTime(_msgSender());
4115     }
4116 
4117 
4118     function getTotalStakedReward() public view returns (uint256) {
4119         return nodeManager.totalStaked();
4120     }
4121 
4122     function getTotalCreatedNodes() public view returns (uint256) {
4123         return nodeManager.totalNodesCreated();
4124     }
4125 
4126 
4127     function openTrading() external onlyOwner() {
4128         require(!tradingOpen,"trading is already open");
4129         tradingOpen = true;
4130         _openTradingBlock = block.number;
4131     }
4132 
4133     function nodeEnforcement(bool val) external onlyOwner() {
4134         nodeEnforced = val;
4135     }
4136 
4137     function updateMaxTxAmount(uint256 newVal) public onlyOwner {
4138         maxTx = newVal;
4139     }
4140 }