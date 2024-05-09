1 /*
2 
3 SPDX-License-Identifier: MIT
4 
5 ..........................................................................................
6 ..........................................................................................
7 ..........................................................................................
8 ..........................................................................................
9 ..........................................................................................
10 ..........................................................................................
11 ..........................................................................................
12 ..........................................................................................
13 ..........................................................................................
14 .........................,oxddxddddddddddddddddddddddddddddd:.............................
15 .......................''ck0OkxxxxxxxxxxxxxxxxxxxxxxxxxxkOOOl,'...........................
16 .....................'oxxkO0Oc..........................;k0Okkxd;.........................
17 ..................',,:xO0kddo;..........................,lddkO0kc,,'......................
18 ..................lkkOO0Ol. .:kOOOOOOOOOOOOOOOOOOOOOOOOOl. .:O0OOkkd,.....................
19 ..................oO0koll:,',o0KKKKKKKKKKKKKKKKKK0000K00d;'';llok00d,.....................
20 ..................o00o.  ,k0000KKKKKKKKKKKKKKKK000000KK0000O:  .lO0d,.....................
21 ..................oO0o.  ,kKKKKKKKKKKKKKKKKKKKK0KKKKKKKKKKK0:  .cO0d,.....................
22 ..................oO0o.  ,kKKKKKKKKKKKKKKKKKKKKKKKKK0KK0KKK0:  .cO0d,.....................
23 ..............,cclxO0d.  'kKKKKKKKKKK0000KKK00KKKKKK0KKKKKK0:  .cO0d,.....................
24 ..............cO0000Oo.  'kK0KK000000KKKKKKKKKKKKKKK00000KK0:  .cO0d,.....................
25 ..........'cllxO0kl;,.   'kKK0KKOl;,ckKKKKKK00KKKKKKkc,;lOK0:  .cO0d,.....................
26 ..........;k00OOOx,      ,kKKK0Kk'  .dKKKKKK000KKKKKd.  'kK0:  .cO0d,.....................
27 ..........;kOOl,',coooooox00KKKKk'  .dKKKKKKKKKK0KKKd.  'kKO:  .cO0d,.....................
28 ..........;k0O:  .l0KKK0000KK0KKk;  'xKK00KKKKKKKKKKx'  ;kK0:  .cO0d,.....................
29 ..........;kOO:  .l0K00O000KKKKK0kddx0KKK00KKK00KKKKOxddk0K0:  .cO0d,.....................
30 ..........:k0Oc...ckkxxxxk0KKK0KKKKK00KKK00000000KKKKKKKKKK0:  .cO0d,.....................
31 ..........;k0Okxxo,......;OK000KKKKKKK000000000K0KK00KKKKKK0:  .cO0d,.....................
32 ..........,oxxk00k:...   ,kK00KKK00KKK0000K0kxddddddxOKK0KK0:  .cO0d,.....................
33 .............'lO0OOkkl.  'kKKKKKKKK00KK0KKK0c..     'xK00KK0:  .cO0d,.....................
34 ..............;oodkO0o.  'kKKKKKKKK0KKK00KK0o,,''''':kK00KK0:  .cO0d,.....................
35 .................'oO0o.  'kKKKKKKKKKKKK00KK00000000000KK0KK0:  .cO0d,.....................
36 .................'oO0o.  ,kKKKKKKK000KKKK00000KKKKK0KK00KKK0:  .cO0d,.....................
37 ..................oO0o.  ,kKKKKKKKKKKKKKK00000KKKKKKK00K0KK0:  .cO0d,.....................
38 ..................oO0o.  ,kKKKKK0KKKKKKKK0K0dc::::::lkKKKKK0:  .cO0d,.....................
39 ..................oO0o.  ,kKKKK00KKKKKK0KKK0:.      .dK0KKK0:  .cO0d,.....................
40 ..................oO0o.  ,kKKKK0KK0KK0KKKKK0xllcccccoOKKKKK0:  .cO0d,.....................
41 ..................oO0o.  ,kKKKK0KK000KK0KKKKKKKKKKKKKKKK000O:  .lO0d,.....................
42 ..................oO0o.  ,kKKKK0KK0KK0KKKKKKKKKKKKKKKKK0d;'';llokOOd,.....................
43 ..................oO0o.  ,kKKKKKKKKK0OOOOOOOOOOOOOOOOOOOl. .:O0OOkko,.....................
44 ..................oO0o.  ,kKKKK0K0KKx;..................,lddkO0kc,,'......................
45 ..................oO0o.  ,kKKKKK00KKd.   ...............;k0Okxxd;.........................
46 ..................oO0o.  ,kKKKKK00KKd.  .oxxxxxxxxxxxxxxkO0Ol'''..........................
47 ..................oO0o.  ,kKKKKK00KKd.  ,xOOkxxddddddddddddd:.............................
48 ..................oO0o.  ,kKKKKK00KKd.  'x0Ol''...........................................
49 ..................oO0o.  ,kKKKKK000Kd.  ,x0Oc.............................................
50 
51 THE CRYPTOPOCALYPSE DAWNS
52 Will your punk survive?
53 
54 @art:   pixantle
55         @pixantle
56 
57 @tech:  white lights
58         @iamwhitelights
59 
60 @title  RADIOACTIVEPUNKS
61 
62 @dev    Extends ERC721 Non-Fungible Token Standard to allow pausing, burning,
63         enumerability, and royalties via the Rarible V1 Protocol and ERC2981 NFT
64         Royalty Standard. The metadata and images are stored on Arweave,
65         creating a completely on-chain generative collectible series. If any
66         NFTs were to survive nuclear winter, these would be the ones. Tokens
67         are only mintable by a signed EIP-718 transaction to ward off contract
68         attacks and minting via Etherscan. Any singular wallet can mint only ten
69         in the first 10 mins of sales and only 100 lifetime.
70 */
71 
72 
73 // File: @openzeppelin/contracts/utils/Context.sol
74 
75 pragma solidity ^0.8.0;
76 
77 /*
78  * @dev Provides information about the current execution context, including the
79  * sender of the transaction and its data. While these are generally available
80  * via msg.sender and msg.data, they should not be accessed in such a direct
81  * manner, since when dealing with meta-transactions the account sending and
82  * paying for execution may not be the actual sender (as far as an application
83  * is concerned).
84  *
85  * This contract is only required for intermediate, library-like contracts.
86  */
87 abstract contract Context {
88     function _msgSender() internal view virtual returns (address) {
89         return msg.sender;
90     }
91 
92     function _msgData() internal view virtual returns (bytes calldata) {
93         return msg.data;
94     }
95 }
96 
97 // File: @openzeppelin/contracts/access/Ownable.sol
98 
99 pragma solidity ^0.8.0;
100 
101 
102 /**
103  * @dev Contract module which provides a basic access control mechanism, where
104  * there is an account (an owner) that can be granted exclusive access to
105  * specific functions.
106  *
107  * By default, the owner account will be the one that deploys the contract. This
108  * can later be changed with {transferOwnership}.
109  *
110  * This module is used through inheritance. It will make available the modifier
111  * `onlyOwner`, which can be applied to your functions to restrict their use to
112  * the owner.
113  */
114 abstract contract Ownable is Context {
115     address private _owner;
116 
117     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
118 
119     /**
120      * @dev Initializes the contract setting the deployer as the initial owner.
121      */
122     constructor() {
123         _setOwner(_msgSender());
124     }
125 
126     /**
127      * @dev Returns the address of the current owner.
128      */
129     function owner() public view virtual returns (address) {
130         return _owner;
131     }
132 
133     /**
134      * @dev Throws if called by any account other than the owner.
135      */
136     modifier onlyOwner() {
137         require(owner() == _msgSender(), "Ownable: caller is not the owner");
138         _;
139     }
140 
141     /**
142      * @dev Leaves the contract without owner. It will not be possible to call
143      * `onlyOwner` functions anymore. Can only be called by the current owner.
144      *
145      * NOTE: Renouncing ownership will leave the contract without an owner,
146      * thereby removing any functionality that is only available to the owner.
147      */
148     function renounceOwnership() public virtual onlyOwner {
149         _setOwner(address(0));
150     }
151 
152     /**
153      * @dev Transfers ownership of the contract to a new account (`newOwner`).
154      * Can only be called by the current owner.
155      */
156     function transferOwnership(address newOwner) public virtual onlyOwner {
157         require(newOwner != address(0), "Ownable: new owner is the zero address");
158         _setOwner(newOwner);
159     }
160 
161     function _setOwner(address newOwner) private {
162         address oldOwner = _owner;
163         _owner = newOwner;
164         emit OwnershipTransferred(oldOwner, newOwner);
165     }
166 }
167 
168 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
169 
170 pragma solidity ^0.8.0;
171 
172 /**
173  * @dev Interface of the ERC165 standard, as defined in the
174  * https://eips.ethereum.org/EIPS/eip-165[EIP].
175  *
176  * Implementers can declare support of contract interfaces, which can then be
177  * queried by others ({ERC165Checker}).
178  *
179  * For an implementation, see {ERC165}.
180  */
181 interface IERC165 {
182     /**
183      * @dev Returns true if this contract implements the interface defined by
184      * `interfaceId`. See the corresponding
185      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
186      * to learn more about how these ids are created.
187      *
188      * This function call must use less than 30 000 gas.
189      */
190     function supportsInterface(bytes4 interfaceId) external view returns (bool);
191 }
192 
193 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
194 
195 pragma solidity ^0.8.0;
196 
197 
198 /**
199  * @dev Required interface of an ERC721 compliant contract.
200  */
201 interface IERC721 is IERC165 {
202     /**
203      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
204      */
205     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
206 
207     /**
208      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
209      */
210     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
211 
212     /**
213      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
214      */
215     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
216 
217     /**
218      * @dev Returns the number of tokens in ``owner``'s account.
219      */
220     function balanceOf(address owner) external view returns (uint256 balance);
221 
222     /**
223      * @dev Returns the owner of the `tokenId` token.
224      *
225      * Requirements:
226      *
227      * - `tokenId` must exist.
228      */
229     function ownerOf(uint256 tokenId) external view returns (address owner);
230 
231     /**
232      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
233      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
234      *
235      * Requirements:
236      *
237      * - `from` cannot be the zero address.
238      * - `to` cannot be the zero address.
239      * - `tokenId` token must exist and be owned by `from`.
240      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
241      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
242      *
243      * Emits a {Transfer} event.
244      */
245     function safeTransferFrom(
246         address from,
247         address to,
248         uint256 tokenId
249     ) external;
250 
251     /**
252      * @dev Transfers `tokenId` token from `from` to `to`.
253      *
254      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
255      *
256      * Requirements:
257      *
258      * - `from` cannot be the zero address.
259      * - `to` cannot be the zero address.
260      * - `tokenId` token must be owned by `from`.
261      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
262      *
263      * Emits a {Transfer} event.
264      */
265     function transferFrom(
266         address from,
267         address to,
268         uint256 tokenId
269     ) external;
270 
271     /**
272      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
273      * The approval is cleared when the token is transferred.
274      *
275      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
276      *
277      * Requirements:
278      *
279      * - The caller must own the token or be an approved operator.
280      * - `tokenId` must exist.
281      *
282      * Emits an {Approval} event.
283      */
284     function approve(address to, uint256 tokenId) external;
285 
286     /**
287      * @dev Returns the account approved for `tokenId` token.
288      *
289      * Requirements:
290      *
291      * - `tokenId` must exist.
292      */
293     function getApproved(uint256 tokenId) external view returns (address operator);
294 
295     /**
296      * @dev Approve or remove `operator` as an operator for the caller.
297      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
298      *
299      * Requirements:
300      *
301      * - The `operator` cannot be the caller.
302      *
303      * Emits an {ApprovalForAll} event.
304      */
305     function setApprovalForAll(address operator, bool _approved) external;
306 
307     /**
308      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
309      *
310      * See {setApprovalForAll}
311      */
312     function isApprovedForAll(address owner, address operator) external view returns (bool);
313 
314     /**
315      * @dev Safely transfers `tokenId` token from `from` to `to`.
316      *
317      * Requirements:
318      *
319      * - `from` cannot be the zero address.
320      * - `to` cannot be the zero address.
321      * - `tokenId` token must exist and be owned by `from`.
322      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
323      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
324      *
325      * Emits a {Transfer} event.
326      */
327     function safeTransferFrom(
328         address from,
329         address to,
330         uint256 tokenId,
331         bytes calldata data
332     ) external;
333 }
334 
335 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
336 
337 pragma solidity ^0.8.0;
338 
339 /**
340  * @title ERC721 token receiver interface
341  * @dev Interface for any contract that wants to support safeTransfers
342  * from ERC721 asset contracts.
343  */
344 interface IERC721Receiver {
345     /**
346      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
347      * by `operator` from `from`, this function is called.
348      *
349      * It must return its Solidity selector to confirm the token transfer.
350      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
351      *
352      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
353      */
354     function onERC721Received(
355         address operator,
356         address from,
357         uint256 tokenId,
358         bytes calldata data
359     ) external returns (bytes4);
360 }
361 
362 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
363 
364 pragma solidity ^0.8.0;
365 
366 
367 /**
368  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
369  * @dev See https://eips.ethereum.org/EIPS/eip-721
370  */
371 interface IERC721Metadata is IERC721 {
372     /**
373      * @dev Returns the token collection name.
374      */
375     function name() external view returns (string memory);
376 
377     /**
378      * @dev Returns the token collection symbol.
379      */
380     function symbol() external view returns (string memory);
381 
382     /**
383      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
384      */
385     function tokenURI(uint256 tokenId) external view returns (string memory);
386 }
387 
388 // File: @openzeppelin/contracts/utils/Address.sol
389 
390 pragma solidity ^0.8.0;
391 
392 /**
393  * @dev Collection of functions related to the address type
394  */
395 library Address {
396     /**
397      * @dev Returns true if `account` is a contract.
398      *
399      * [IMPORTANT]
400      * ====
401      * It is unsafe to assume that an address for which this function returns
402      * false is an externally-owned account (EOA) and not a contract.
403      *
404      * Among others, `isContract` will return false for the following
405      * types of addresses:
406      *
407      *  - an externally-owned account
408      *  - a contract in construction
409      *  - an address where a contract will be created
410      *  - an address where a contract lived, but was destroyed
411      * ====
412      */
413     function isContract(address account) internal view returns (bool) {
414         // This method relies on extcodesize, which returns 0 for contracts in
415         // construction, since the code is only stored at the end of the
416         // constructor execution.
417 
418         uint256 size;
419         assembly {
420             size := extcodesize(account)
421         }
422         return size > 0;
423     }
424 
425     /**
426      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
427      * `recipient`, forwarding all available gas and reverting on errors.
428      *
429      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
430      * of certain opcodes, possibly making contracts go over the 2300 gas limit
431      * imposed by `transfer`, making them unable to receive funds via
432      * `transfer`. {sendValue} removes this limitation.
433      *
434      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
435      *
436      * IMPORTANT: because control is transferred to `recipient`, care must be
437      * taken to not create reentrancy vulnerabilities. Consider using
438      * {ReentrancyGuard} or the
439      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
440      */
441     function sendValue(address payable recipient, uint256 amount) internal {
442         require(address(this).balance >= amount, "Address: insufficient balance");
443 
444         (bool success, ) = recipient.call{value: amount}("");
445         require(success, "Address: unable to send value, recipient may have reverted");
446     }
447 
448     /**
449      * @dev Performs a Solidity function call using a low level `call`. A
450      * plain `call` is an unsafe replacement for a function call: use this
451      * function instead.
452      *
453      * If `target` reverts with a revert reason, it is bubbled up by this
454      * function (like regular Solidity function calls).
455      *
456      * Returns the raw returned data. To convert to the expected return value,
457      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
458      *
459      * Requirements:
460      *
461      * - `target` must be a contract.
462      * - calling `target` with `data` must not revert.
463      *
464      * _Available since v3.1._
465      */
466     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
467         return functionCall(target, data, "Address: low-level call failed");
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
472      * `errorMessage` as a fallback revert reason when `target` reverts.
473      *
474      * _Available since v3.1._
475      */
476     function functionCall(
477         address target,
478         bytes memory data,
479         string memory errorMessage
480     ) internal returns (bytes memory) {
481         return functionCallWithValue(target, data, 0, errorMessage);
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
486      * but also transferring `value` wei to `target`.
487      *
488      * Requirements:
489      *
490      * - the calling contract must have an ETH balance of at least `value`.
491      * - the called Solidity function must be `payable`.
492      *
493      * _Available since v3.1._
494      */
495     function functionCallWithValue(
496         address target,
497         bytes memory data,
498         uint256 value
499     ) internal returns (bytes memory) {
500         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
505      * with `errorMessage` as a fallback revert reason when `target` reverts.
506      *
507      * _Available since v3.1._
508      */
509     function functionCallWithValue(
510         address target,
511         bytes memory data,
512         uint256 value,
513         string memory errorMessage
514     ) internal returns (bytes memory) {
515         require(address(this).balance >= value, "Address: insufficient balance for call");
516         require(isContract(target), "Address: call to non-contract");
517 
518         (bool success, bytes memory returndata) = target.call{value: value}(data);
519         return _verifyCallResult(success, returndata, errorMessage);
520     }
521 
522     /**
523      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
524      * but performing a static call.
525      *
526      * _Available since v3.3._
527      */
528     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
529         return functionStaticCall(target, data, "Address: low-level static call failed");
530     }
531 
532     /**
533      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
534      * but performing a static call.
535      *
536      * _Available since v3.3._
537      */
538     function functionStaticCall(
539         address target,
540         bytes memory data,
541         string memory errorMessage
542     ) internal view returns (bytes memory) {
543         require(isContract(target), "Address: static call to non-contract");
544 
545         (bool success, bytes memory returndata) = target.staticcall(data);
546         return _verifyCallResult(success, returndata, errorMessage);
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
551      * but performing a delegate call.
552      *
553      * _Available since v3.4._
554      */
555     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
556         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
561      * but performing a delegate call.
562      *
563      * _Available since v3.4._
564      */
565     function functionDelegateCall(
566         address target,
567         bytes memory data,
568         string memory errorMessage
569     ) internal returns (bytes memory) {
570         require(isContract(target), "Address: delegate call to non-contract");
571 
572         (bool success, bytes memory returndata) = target.delegatecall(data);
573         return _verifyCallResult(success, returndata, errorMessage);
574     }
575 
576     function _verifyCallResult(
577         bool success,
578         bytes memory returndata,
579         string memory errorMessage
580     ) private pure returns (bytes memory) {
581         if (success) {
582             return returndata;
583         } else {
584             // Look for revert reason and bubble it up if present
585             if (returndata.length > 0) {
586                 // The easiest way to bubble the revert reason is using memory via assembly
587 
588                 assembly {
589                     let returndata_size := mload(returndata)
590                     revert(add(32, returndata), returndata_size)
591                 }
592             } else {
593                 revert(errorMessage);
594             }
595         }
596     }
597 }
598 
599 // File: @openzeppelin/contracts/utils/Strings.sol
600 
601 pragma solidity ^0.8.0;
602 
603 /**
604  * @dev String operations.
605  */
606 library Strings {
607     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
608 
609     /**
610      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
611      */
612     function toString(uint256 value) internal pure returns (string memory) {
613         // Inspired by OraclizeAPI's implementation - MIT licence
614         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
615 
616         if (value == 0) {
617             return "0";
618         }
619         uint256 temp = value;
620         uint256 digits;
621         while (temp != 0) {
622             digits++;
623             temp /= 10;
624         }
625         bytes memory buffer = new bytes(digits);
626         while (value != 0) {
627             digits -= 1;
628             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
629             value /= 10;
630         }
631         return string(buffer);
632     }
633 
634     /**
635      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
636      */
637     function toHexString(uint256 value) internal pure returns (string memory) {
638         if (value == 0) {
639             return "0x00";
640         }
641         uint256 temp = value;
642         uint256 length = 0;
643         while (temp != 0) {
644             length++;
645             temp >>= 8;
646         }
647         return toHexString(value, length);
648     }
649 
650     /**
651      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
652      */
653     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
654         bytes memory buffer = new bytes(2 * length + 2);
655         buffer[0] = "0";
656         buffer[1] = "x";
657         for (uint256 i = 2 * length + 1; i > 1; --i) {
658             buffer[i] = _HEX_SYMBOLS[value & 0xf];
659             value >>= 4;
660         }
661         require(value == 0, "Strings: hex length insufficient");
662         return string(buffer);
663     }
664 }
665 
666 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
667 
668 pragma solidity ^0.8.0;
669 
670 
671 /**
672  * @dev Implementation of the {IERC165} interface.
673  *
674  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
675  * for the additional interface id that will be supported. For example:
676  *
677  * ```solidity
678  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
679  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
680  * }
681  * ```
682  *
683  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
684  */
685 abstract contract ERC165 is IERC165 {
686     /**
687      * @dev See {IERC165-supportsInterface}.
688      */
689     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
690         return interfaceId == type(IERC165).interfaceId;
691     }
692 }
693 
694 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
695 
696 pragma solidity ^0.8.0;
697 
698 
699 /**
700  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
701  * the Metadata extension, but not including the Enumerable extension, which is available separately as
702  * {ERC721Enumerable}.
703  */
704 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
705     using Address for address;
706     using Strings for uint256;
707 
708     // Token name
709     string private _name;
710 
711     // Token symbol
712     string private _symbol;
713 
714     // Mapping from token ID to owner address
715     mapping(uint256 => address) private _owners;
716 
717     // Mapping owner address to token count
718     mapping(address => uint256) private _balances;
719 
720     // Mapping from token ID to approved address
721     mapping(uint256 => address) private _tokenApprovals;
722 
723     // Mapping from owner to operator approvals
724     mapping(address => mapping(address => bool)) private _operatorApprovals;
725 
726     /**
727      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
728      */
729     constructor(string memory name_, string memory symbol_) {
730         _name = name_;
731         _symbol = symbol_;
732     }
733 
734     /**
735      * @dev See {IERC165-supportsInterface}.
736      */
737     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
738         return
739             interfaceId == type(IERC721).interfaceId ||
740             interfaceId == type(IERC721Metadata).interfaceId ||
741             super.supportsInterface(interfaceId);
742     }
743 
744     /**
745      * @dev See {IERC721-balanceOf}.
746      */
747     function balanceOf(address owner) public view virtual override returns (uint256) {
748         require(owner != address(0), "ERC721: balance query for the zero address");
749         return _balances[owner];
750     }
751 
752     /**
753      * @dev See {IERC721-ownerOf}.
754      */
755     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
756         address owner = _owners[tokenId];
757         require(owner != address(0), "ERC721: owner query for nonexistent token");
758         return owner;
759     }
760 
761     /**
762      * @dev See {IERC721Metadata-name}.
763      */
764     function name() public view virtual override returns (string memory) {
765         return _name;
766     }
767 
768     /**
769      * @dev See {IERC721Metadata-symbol}.
770      */
771     function symbol() public view virtual override returns (string memory) {
772         return _symbol;
773     }
774 
775     /**
776      * @dev See {IERC721Metadata-tokenURI}.
777      */
778     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
779         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
780 
781         string memory baseURI = _baseURI();
782         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
783     }
784 
785     /**
786      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
787      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
788      * by default, can be overriden in child contracts.
789      */
790     function _baseURI() internal view virtual returns (string memory) {
791         return "";
792     }
793 
794     /**
795      * @dev See {IERC721-approve}.
796      */
797     function approve(address to, uint256 tokenId) public virtual override {
798         address owner = ERC721.ownerOf(tokenId);
799         require(to != owner, "ERC721: approval to current owner");
800 
801         require(
802             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
803             "ERC721: approve caller is not owner nor approved for all"
804         );
805 
806         _approve(to, tokenId);
807     }
808 
809     /**
810      * @dev See {IERC721-getApproved}.
811      */
812     function getApproved(uint256 tokenId) public view virtual override returns (address) {
813         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
814 
815         return _tokenApprovals[tokenId];
816     }
817 
818     /**
819      * @dev See {IERC721-setApprovalForAll}.
820      */
821     function setApprovalForAll(address operator, bool approved) public virtual override {
822         require(operator != _msgSender(), "ERC721: approve to caller");
823 
824         _operatorApprovals[_msgSender()][operator] = approved;
825         emit ApprovalForAll(_msgSender(), operator, approved);
826     }
827 
828     /**
829      * @dev See {IERC721-isApprovedForAll}.
830      */
831     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
832         return _operatorApprovals[owner][operator];
833     }
834 
835     /**
836      * @dev See {IERC721-transferFrom}.
837      */
838     function transferFrom(
839         address from,
840         address to,
841         uint256 tokenId
842     ) public virtual override {
843         //solhint-disable-next-line max-line-length
844         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
845 
846         _transfer(from, to, tokenId);
847     }
848 
849     /**
850      * @dev See {IERC721-safeTransferFrom}.
851      */
852     function safeTransferFrom(
853         address from,
854         address to,
855         uint256 tokenId
856     ) public virtual override {
857         safeTransferFrom(from, to, tokenId, "");
858     }
859 
860     /**
861      * @dev See {IERC721-safeTransferFrom}.
862      */
863     function safeTransferFrom(
864         address from,
865         address to,
866         uint256 tokenId,
867         bytes memory _data
868     ) public virtual override {
869         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
870         _safeTransfer(from, to, tokenId, _data);
871     }
872 
873     /**
874      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
875      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
876      *
877      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
878      *
879      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
880      * implement alternative mechanisms to perform token transfer, such as signature-based.
881      *
882      * Requirements:
883      *
884      * - `from` cannot be the zero address.
885      * - `to` cannot be the zero address.
886      * - `tokenId` token must exist and be owned by `from`.
887      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
888      *
889      * Emits a {Transfer} event.
890      */
891     function _safeTransfer(
892         address from,
893         address to,
894         uint256 tokenId,
895         bytes memory _data
896     ) internal virtual {
897         _transfer(from, to, tokenId);
898         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
899     }
900 
901     /**
902      * @dev Returns whether `tokenId` exists.
903      *
904      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
905      *
906      * Tokens start existing when they are minted (`_mint`),
907      * and stop existing when they are burned (`_burn`).
908      */
909     function _exists(uint256 tokenId) internal view virtual returns (bool) {
910         return _owners[tokenId] != address(0);
911     }
912 
913     /**
914      * @dev Returns whether `spender` is allowed to manage `tokenId`.
915      *
916      * Requirements:
917      *
918      * - `tokenId` must exist.
919      */
920     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
921         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
922         address owner = ERC721.ownerOf(tokenId);
923         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
924     }
925 
926     /**
927      * @dev Safely mints `tokenId` and transfers it to `to`.
928      *
929      * Requirements:
930      *
931      * - `tokenId` must not exist.
932      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
933      *
934      * Emits a {Transfer} event.
935      */
936     function _safeMint(address to, uint256 tokenId) internal virtual {
937         _safeMint(to, tokenId, "");
938     }
939 
940     /**
941      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
942      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
943      */
944     function _safeMint(
945         address to,
946         uint256 tokenId,
947         bytes memory _data
948     ) internal virtual {
949         _mint(to, tokenId);
950         require(
951             _checkOnERC721Received(address(0), to, tokenId, _data),
952             "ERC721: transfer to non ERC721Receiver implementer"
953         );
954     }
955 
956     /**
957      * @dev Mints `tokenId` and transfers it to `to`.
958      *
959      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
960      *
961      * Requirements:
962      *
963      * - `tokenId` must not exist.
964      * - `to` cannot be the zero address.
965      *
966      * Emits a {Transfer} event.
967      */
968     function _mint(address to, uint256 tokenId) internal virtual {
969         require(to != address(0), "ERC721: mint to the zero address");
970         require(!_exists(tokenId), "ERC721: token already minted");
971 
972         _beforeTokenTransfer(address(0), to, tokenId);
973 
974         _balances[to] += 1;
975         _owners[tokenId] = to;
976 
977         emit Transfer(address(0), to, tokenId);
978     }
979 
980     /**
981      * @dev Destroys `tokenId`.
982      * The approval is cleared when the token is burned.
983      *
984      * Requirements:
985      *
986      * - `tokenId` must exist.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _burn(uint256 tokenId) internal virtual {
991         address owner = ERC721.ownerOf(tokenId);
992 
993         _beforeTokenTransfer(owner, address(0), tokenId);
994 
995         // Clear approvals
996         _approve(address(0), tokenId);
997 
998         _balances[owner] -= 1;
999         delete _owners[tokenId];
1000 
1001         emit Transfer(owner, address(0), tokenId);
1002     }
1003 
1004     /**
1005      * @dev Transfers `tokenId` from `from` to `to`.
1006      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1007      *
1008      * Requirements:
1009      *
1010      * - `to` cannot be the zero address.
1011      * - `tokenId` token must be owned by `from`.
1012      *
1013      * Emits a {Transfer} event.
1014      */
1015     function _transfer(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) internal virtual {
1020         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1021         require(to != address(0), "ERC721: transfer to the zero address");
1022 
1023         _beforeTokenTransfer(from, to, tokenId);
1024 
1025         // Clear approvals from the previous owner
1026         _approve(address(0), tokenId);
1027 
1028         _balances[from] -= 1;
1029         _balances[to] += 1;
1030         _owners[tokenId] = to;
1031 
1032         emit Transfer(from, to, tokenId);
1033     }
1034 
1035     /**
1036      * @dev Approve `to` to operate on `tokenId`
1037      *
1038      * Emits a {Approval} event.
1039      */
1040     function _approve(address to, uint256 tokenId) internal virtual {
1041         _tokenApprovals[tokenId] = to;
1042         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1043     }
1044 
1045     /**
1046      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1047      * The call is not executed if the target address is not a contract.
1048      *
1049      * @param from address representing the previous owner of the given token ID
1050      * @param to target address that will receive the tokens
1051      * @param tokenId uint256 ID of the token to be transferred
1052      * @param _data bytes optional data to send along with the call
1053      * @return bool whether the call correctly returned the expected magic value
1054      */
1055     function _checkOnERC721Received(
1056         address from,
1057         address to,
1058         uint256 tokenId,
1059         bytes memory _data
1060     ) private returns (bool) {
1061         if (to.isContract()) {
1062             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1063                 return retval == IERC721Receiver(to).onERC721Received.selector;
1064             } catch (bytes memory reason) {
1065                 if (reason.length == 0) {
1066                     revert("ERC721: transfer to non ERC721Receiver implementer");
1067                 } else {
1068                     assembly {
1069                         revert(add(32, reason), mload(reason))
1070                     }
1071                 }
1072             }
1073         } else {
1074             return true;
1075         }
1076     }
1077 
1078     /**
1079      * @dev Hook that is called before any token transfer. This includes minting
1080      * and burning.
1081      *
1082      * Calling conditions:
1083      *
1084      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1085      * transferred to `to`.
1086      * - When `from` is zero, `tokenId` will be minted for `to`.
1087      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1088      * - `from` and `to` are never both zero.
1089      *
1090      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1091      */
1092     function _beforeTokenTransfer(
1093         address from,
1094         address to,
1095         uint256 tokenId
1096     ) internal virtual {}
1097 }
1098 
1099 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1100 
1101 pragma solidity ^0.8.0;
1102 
1103 
1104 
1105 /**
1106  * @title ERC721 Burnable Token
1107  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1108  */
1109 abstract contract ERC721Burnable is Context, ERC721 {
1110     /**
1111      * @dev Burns `tokenId`. See {ERC721-_burn}.
1112      *
1113      * Requirements:
1114      *
1115      * - The caller must own `tokenId` or be an approved operator.
1116      */
1117     function burn(uint256 tokenId) public virtual {
1118         //solhint-disable-next-line max-line-length
1119         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1120         _burn(tokenId);
1121     }
1122 }
1123 
1124 // File: @openzeppelin/contracts/security/Pausable.sol
1125 
1126 pragma solidity ^0.8.0;
1127 
1128 
1129 /**
1130  * @dev Contract module which allows children to implement an emergency stop
1131  * mechanism that can be triggered by an authorized account.
1132  *
1133  * This module is used through inheritance. It will make available the
1134  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1135  * the functions of your contract. Note that they will not be pausable by
1136  * simply including this module, only once the modifiers are put in place.
1137  */
1138 abstract contract Pausable is Context {
1139     /**
1140      * @dev Emitted when the pause is triggered by `account`.
1141      */
1142     event Paused(address account);
1143 
1144     /**
1145      * @dev Emitted when the pause is lifted by `account`.
1146      */
1147     event Unpaused(address account);
1148 
1149     bool private _paused;
1150 
1151     /**
1152      * @dev Initializes the contract in unpaused state.
1153      */
1154     constructor() {
1155         _paused = false;
1156     }
1157 
1158     /**
1159      * @dev Returns true if the contract is paused, and false otherwise.
1160      */
1161     function paused() public view virtual returns (bool) {
1162         return _paused;
1163     }
1164 
1165     /**
1166      * @dev Modifier to make a function callable only when the contract is not paused.
1167      *
1168      * Requirements:
1169      *
1170      * - The contract must not be paused.
1171      */
1172     modifier whenNotPaused() {
1173         require(!paused(), "Pausable: paused");
1174         _;
1175     }
1176 
1177     /**
1178      * @dev Modifier to make a function callable only when the contract is paused.
1179      *
1180      * Requirements:
1181      *
1182      * - The contract must be paused.
1183      */
1184     modifier whenPaused() {
1185         require(paused(), "Pausable: not paused");
1186         _;
1187     }
1188 
1189     /**
1190      * @dev Triggers stopped state.
1191      *
1192      * Requirements:
1193      *
1194      * - The contract must not be paused.
1195      */
1196     function _pause() internal virtual whenNotPaused {
1197         _paused = true;
1198         emit Paused(_msgSender());
1199     }
1200 
1201     /**
1202      * @dev Returns to normal state.
1203      *
1204      * Requirements:
1205      *
1206      * - The contract must be paused.
1207      */
1208     function _unpause() internal virtual whenPaused {
1209         _paused = false;
1210         emit Unpaused(_msgSender());
1211     }
1212 }
1213 
1214 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol
1215 
1216 pragma solidity ^0.8.0;
1217 
1218 
1219 
1220 /**
1221  * @dev ERC721 token with pausable token transfers, minting and burning.
1222  *
1223  * Useful for scenarios such as preventing trades until the end of an evaluation
1224  * period, or having an emergency switch for freezing all token transfers in the
1225  * event of a large bug.
1226  */
1227 abstract contract ERC721Pausable is ERC721, Pausable {
1228     /**
1229      * @dev See {ERC721-_beforeTokenTransfer}.
1230      *
1231      * Requirements:
1232      *
1233      * - the contract must not be paused.
1234      */
1235     function _beforeTokenTransfer(
1236         address from,
1237         address to,
1238         uint256 tokenId
1239     ) internal virtual override {
1240         super._beforeTokenTransfer(from, to, tokenId);
1241 
1242         require(!paused(), "ERC721Pausable: token transfer while paused");
1243     }
1244 }
1245 
1246 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1247 
1248 pragma solidity ^0.8.0;
1249 
1250 
1251 /**
1252  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1253  * @dev See https://eips.ethereum.org/EIPS/eip-721
1254  */
1255 interface IERC721Enumerable is IERC721 {
1256     /**
1257      * @dev Returns the total amount of tokens stored by the contract.
1258      */
1259     function totalSupply() external view returns (uint256);
1260 
1261     /**
1262      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1263      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1264      */
1265     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1266 
1267     /**
1268      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1269      * Use along with {totalSupply} to enumerate all tokens.
1270      */
1271     function tokenByIndex(uint256 index) external view returns (uint256);
1272 }
1273 
1274 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1275 
1276 pragma solidity ^0.8.0;
1277 
1278 
1279 
1280 /**
1281  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1282  * enumerability of all the token ids in the contract as well as all token ids owned by each
1283  * account.
1284  */
1285 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1286     // Mapping from owner to list of owned token IDs
1287     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1288 
1289     // Mapping from token ID to index of the owner tokens list
1290     mapping(uint256 => uint256) private _ownedTokensIndex;
1291 
1292     // Array with all token ids, used for enumeration
1293     uint256[] private _allTokens;
1294 
1295     // Mapping from token id to position in the allTokens array
1296     mapping(uint256 => uint256) private _allTokensIndex;
1297 
1298     /**
1299      * @dev See {IERC165-supportsInterface}.
1300      */
1301     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1302         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1303     }
1304 
1305     /**
1306      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1307      */
1308     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1309         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1310         return _ownedTokens[owner][index];
1311     }
1312 
1313     /**
1314      * @dev See {IERC721Enumerable-totalSupply}.
1315      */
1316     function totalSupply() public view virtual override returns (uint256) {
1317         return _allTokens.length;
1318     }
1319 
1320     /**
1321      * @dev See {IERC721Enumerable-tokenByIndex}.
1322      */
1323     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1324         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1325         return _allTokens[index];
1326     }
1327 
1328     /**
1329      * @dev Hook that is called before any token transfer. This includes minting
1330      * and burning.
1331      *
1332      * Calling conditions:
1333      *
1334      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1335      * transferred to `to`.
1336      * - When `from` is zero, `tokenId` will be minted for `to`.
1337      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1338      * - `from` cannot be the zero address.
1339      * - `to` cannot be the zero address.
1340      *
1341      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1342      */
1343     function _beforeTokenTransfer(
1344         address from,
1345         address to,
1346         uint256 tokenId
1347     ) internal virtual override {
1348         super._beforeTokenTransfer(from, to, tokenId);
1349 
1350         if (from == address(0)) {
1351             _addTokenToAllTokensEnumeration(tokenId);
1352         } else if (from != to) {
1353             _removeTokenFromOwnerEnumeration(from, tokenId);
1354         }
1355         if (to == address(0)) {
1356             _removeTokenFromAllTokensEnumeration(tokenId);
1357         } else if (to != from) {
1358             _addTokenToOwnerEnumeration(to, tokenId);
1359         }
1360     }
1361 
1362     /**
1363      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1364      * @param to address representing the new owner of the given token ID
1365      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1366      */
1367     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1368         uint256 length = ERC721.balanceOf(to);
1369         _ownedTokens[to][length] = tokenId;
1370         _ownedTokensIndex[tokenId] = length;
1371     }
1372 
1373     /**
1374      * @dev Private function to add a token to this extension's token tracking data structures.
1375      * @param tokenId uint256 ID of the token to be added to the tokens list
1376      */
1377     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1378         _allTokensIndex[tokenId] = _allTokens.length;
1379         _allTokens.push(tokenId);
1380     }
1381 
1382     /**
1383      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1384      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1385      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1386      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1387      * @param from address representing the previous owner of the given token ID
1388      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1389      */
1390     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1391         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1392         // then delete the last slot (swap and pop).
1393 
1394         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1395         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1396 
1397         // When the token to delete is the last token, the swap operation is unnecessary
1398         if (tokenIndex != lastTokenIndex) {
1399             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1400 
1401             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1402             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1403         }
1404 
1405         // This also deletes the contents at the last position of the array
1406         delete _ownedTokensIndex[tokenId];
1407         delete _ownedTokens[from][lastTokenIndex];
1408     }
1409 
1410     /**
1411      * @dev Private function to remove a token from this extension's token tracking data structures.
1412      * This has O(1) time complexity, but alters the order of the _allTokens array.
1413      * @param tokenId uint256 ID of the token to be removed from the tokens list
1414      */
1415     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1416         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1417         // then delete the last slot (swap and pop).
1418 
1419         uint256 lastTokenIndex = _allTokens.length - 1;
1420         uint256 tokenIndex = _allTokensIndex[tokenId];
1421 
1422         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1423         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1424         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1425         uint256 lastTokenId = _allTokens[lastTokenIndex];
1426 
1427         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1428         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1429 
1430         // This also deletes the contents at the last position of the array
1431         delete _allTokensIndex[tokenId];
1432         _allTokens.pop();
1433     }
1434 }
1435 
1436 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1437 
1438 pragma solidity ^0.8.0;
1439 
1440 /**
1441  * @dev Interface of the ERC20 standard as defined in the EIP.
1442  */
1443 interface IERC20 {
1444     /**
1445      * @dev Returns the amount of tokens in existence.
1446      */
1447     function totalSupply() external view returns (uint256);
1448 
1449     /**
1450      * @dev Returns the amount of tokens owned by `account`.
1451      */
1452     function balanceOf(address account) external view returns (uint256);
1453 
1454     /**
1455      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1456      *
1457      * Returns a boolean value indicating whether the operation succeeded.
1458      *
1459      * Emits a {Transfer} event.
1460      */
1461     function transfer(address recipient, uint256 amount) external returns (bool);
1462 
1463     /**
1464      * @dev Returns the remaining number of tokens that `spender` will be
1465      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1466      * zero by default.
1467      *
1468      * This value changes when {approve} or {transferFrom} are called.
1469      */
1470     function allowance(address owner, address spender) external view returns (uint256);
1471 
1472     /**
1473      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1474      *
1475      * Returns a boolean value indicating whether the operation succeeded.
1476      *
1477      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1478      * that someone may use both the old and the new allowance by unfortunate
1479      * transaction ordering. One possible solution to mitigate this race
1480      * condition is to first reduce the spender's allowance to 0 and set the
1481      * desired value afterwards:
1482      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1483      *
1484      * Emits an {Approval} event.
1485      */
1486     function approve(address spender, uint256 amount) external returns (bool);
1487 
1488     /**
1489      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1490      * allowance mechanism. `amount` is then deducted from the caller's
1491      * allowance.
1492      *
1493      * Returns a boolean value indicating whether the operation succeeded.
1494      *
1495      * Emits a {Transfer} event.
1496      */
1497     function transferFrom(
1498         address sender,
1499         address recipient,
1500         uint256 amount
1501     ) external returns (bool);
1502 
1503     /**
1504      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1505      * another (`to`).
1506      *
1507      * Note that `value` may be zero.
1508      */
1509     event Transfer(address indexed from, address indexed to, uint256 value);
1510 
1511     /**
1512      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1513      * a call to {approve}. `value` is the new allowance.
1514      */
1515     event Approval(address indexed owner, address indexed spender, uint256 value);
1516 }
1517 
1518 // File: contracts/HasSecondarySaleFees.sol
1519 
1520 pragma solidity ^0.8.4;
1521 
1522 
1523 /**
1524  * Implements Rarible Royalties V1 Schema
1525  * @dev https://docs.rarible.com/asset/creating-an-asset/royalties-schema
1526  */
1527 abstract contract HasSecondarySaleFees is ERC165 {
1528 
1529   event SecondarySaleFees(uint256 tokenId, address[] recipients, uint[] bps);
1530 
1531   /*
1532    * bytes4(keccak256('getFeeBps(uint256)')) == 0x0ebd4c7f
1533    * bytes4(keccak256('getFeeRecipients(uint256)')) == 0xb9c4d9fb
1534    *
1535    * => 0x0ebd4c7f ^ 0xb9c4d9fb == 0xb7799584
1536    */
1537   bytes4 private constant _INTERFACE_ID_FEES = 0xb7799584;
1538 
1539   function getFeeRecipients(uint256 id) public view virtual returns (address payable[] memory);
1540   function getFeeBps(uint256 id) public view virtual returns (uint[] memory);
1541 
1542   function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1543     return interfaceId == _INTERFACE_ID_FEES
1544       || super.supportsInterface(interfaceId);
1545   }
1546 }
1547 
1548 // File: contracts/ERC2981.sol
1549 
1550 pragma solidity ^0.8.4;
1551 
1552 
1553 /*
1554  * Implements Rarible Royalties V1 Schema
1555  * @dev https://eips.ethereum.org/EIPS/eip-2981
1556  */
1557 abstract contract ERC2981 is ERC165 {
1558   /*
1559    * bytes4(keccak256('royaltyInfo(uint256, uint256, bytes)')) == 0xc155531d
1560    */
1561   bytes4 private constant _INTERFACE_ID_ERC2981 = 0xc155531d;
1562 
1563   // @notice Called with the sale price to determine how much royalty
1564   //         is owed and to whom.
1565   // @param _tokenId - the NFT asset queried for royalty information
1566   // @param _value - the sale price of the NFT asset specified by _tokenId
1567   // @param _data - information used by extensions of this ERC.
1568   //                Must not to be used by implementers of EIP-2981
1569   //                alone.
1570   // @return _receiver - address of who should be sent the royalty payment
1571   // @return _royaltyAmount - the royalty payment amount for _value sale price
1572   // @return _royaltyPaymentData - information used by extensions of this ERC.
1573   //                               Must not to be used by implementers of
1574   //                               EIP-2981 alone.
1575   function royaltyInfo(uint256 _tokenId, uint256 _value, bytes calldata _data) external virtual returns (address _receiver, uint256 _royaltyAmount, bytes memory _royaltyPaymentData);
1576 
1577   function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1578     return interfaceId == _INTERFACE_ID_ERC2981
1579       || super.supportsInterface(interfaceId);
1580   }
1581 }
1582 
1583 pragma solidity ^0.8.4;
1584 
1585 contract RADIOACTIVEPUNKS is ERC721Burnable, ERC721Pausable, ERC721Enumerable, HasSecondarySaleFees, ERC2981, Ownable {
1586 
1587   event Frozen();
1588 
1589   struct Unit {
1590       string logIn;
1591   }
1592 
1593   uint256 public activationTime = 1633536000; // THE CRYPTOPOCALYPSE
1594   address payable public PAYMENT_SPLITTER = payable(0xFc9961d08Ef8e04DB145b9fb3d48cf8DbA96116D ); // PaymentSplitter
1595   string public API_BASE_URL = '';
1596   string public METADATA_PROVENANCE_HASH = '';
1597   uint256 public constant punkPrice = 25000000000000000; // 0.025 ETH
1598   uint private constant maxPunksAtOnce = 5;
1599   uint256 private MAX_PUNKS = 3000;
1600   uint256 public PUNKS_LEFT = 2999;
1601   uint256 private PRIME = 197;
1602   uint256 private COPRIME = 474569;
1603   bool public frozen = false;
1604 
1605   string private constant EIP712_DOMAIN  = "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)";
1606   string private constant UNIT_TYPE = "Unit(string logIn)";
1607   bytes32 private constant EIP712_DOMAIN_TYPEHASH = keccak256(abi.encodePacked(EIP712_DOMAIN));
1608   bytes32 private constant UNIT_TYPEHASH = keccak256(abi.encodePacked(UNIT_TYPE));
1609 
1610   bytes32 private DOMAIN_SEPARATOR = keccak256(abi.encode(
1611     EIP712_DOMAIN_TYPEHASH,
1612     keccak256("RADIOACTIVEPUNKS"),
1613     keccak256("1"), // version
1614     1,
1615     0xFc9961d08Ef8e04DB145b9fb3d48cf8DbA96116D // PaymentSplitter
1616   ));
1617 
1618   constructor() ERC721("Radioactive Punks", "RPUNK") {}
1619 
1620   function withdraw() public onlyOwner {
1621     uint256 balance = address(this).balance;
1622     PAYMENT_SPLITTER.transfer(balance);
1623   }
1624 
1625   function setPaymentSplitter(address payable newAddress) external onlyOwner {
1626     PAYMENT_SPLITTER = newAddress;
1627   }
1628 
1629   function activated() public view returns (bool) {
1630     return block.timestamp >= activationTime;
1631   }
1632 
1633   function setActivationTime(uint256 timestampInSeconds) external onlyOwner {
1634     activationTime = timestampInSeconds;
1635   }
1636 
1637   /*
1638    * @dev Used in pseudorandom tokenId
1639    */
1640   function setCoprimes(uint256 primeNumber, uint256 coprimeNumber) external onlyOwner {
1641     PRIME = primeNumber;
1642     COPRIME = coprimeNumber;
1643   }
1644 
1645   /*
1646    * Once executed, metadata for NFTs can never be changed.
1647    */
1648   function freezeMetadata() external onlyOwner {
1649     frozen = true;
1650     emit Frozen();
1651   }
1652 
1653   function setAPIBaseURL(string memory URI) external onlyOwner {
1654     require(frozen == false, "Frozen");
1655     API_BASE_URL = URI;
1656   }
1657 
1658   function _baseURI() internal view override returns (string memory) {
1659     return API_BASE_URL;
1660   }
1661 
1662   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1663     require(_exists(tokenId), "Token DNE");
1664 
1665     string memory baseURI = _baseURI();
1666     return bytes(baseURI).length > 0
1667       ? string(abi.encodePacked(baseURI, uint2str(tokenId), '.json'))
1668       : '';
1669   }
1670 
1671   /*
1672    * Allows the owner to mint X tokens as a way
1673    * of reserving them for our core supporters.
1674    */
1675   function reservePunks(uint256 numberOfTokens) public onlyOwner {
1676     require(numberOfTokens <= PUNKS_LEFT, "Exceeds max supply");
1677 
1678     // for every tokent they want
1679     for(uint i = 0; i < numberOfTokens; i++) {
1680       // reduce the total pop after minting
1681       if (PUNKS_LEFT >= 0) {
1682         uint randomUnusedInt = ((PRIME * PUNKS_LEFT) + COPRIME) % MAX_PUNKS;
1683         _safeMint(msg.sender, randomUnusedInt);
1684         PUNKS_LEFT--;
1685       }
1686     }
1687   }
1688 
1689   /*
1690    * For minting up to five punks at once - tokenIds pseudorandomly generated.
1691    */
1692   function mintPunks(uint256 numberOfTokens, uint8 sigV, bytes32 sigR, bytes32 sigS) public payable {
1693     require(activated(), 'You are too early');
1694     require(numberOfTokens <= maxPunksAtOnce, "Exceeds max mint rate");
1695     require(numberOfTokens <= PUNKS_LEFT, "Exceeds max supply");
1696     require(punkPrice * numberOfTokens == msg.value, "Ether value incorrect");
1697     require(balanceOf(msg.sender) < 100, "Owns max amount");
1698     require(verify(msg.sender, sigV, sigR, sigS) == true, "No cheaters!");
1699 
1700     if (block.timestamp <= activationTime + 600) {
1701       require(balanceOf(msg.sender) + numberOfTokens <= 10, "Only 10 for first 10m");
1702     }
1703 
1704     // for every token they want
1705     for(uint i = 0; i < numberOfTokens; i++) {
1706       // reduce the total pop after minting
1707       if (PUNKS_LEFT >= 0) {
1708         uint randomUnusedInt = ((PRIME * PUNKS_LEFT) + COPRIME) % MAX_PUNKS;
1709         _safeMint(msg.sender, randomUnusedInt);
1710         PUNKS_LEFT--;
1711       }
1712     }
1713   }
1714 
1715   /*
1716    * @dev Leads to a big file on IPFS containing a list of all
1717    *      tokenIDs and their corresponding metadata etc.
1718    */
1719   function setProvenanceHash(string memory hash) external onlyOwner {
1720     METADATA_PROVENANCE_HASH = hash;
1721   }
1722 
1723   /*
1724    * @dev For returning ERC20s we dont know what to do with
1725    *      if people have issues they can contact owner/devs
1726    *      and we can send back their tokens.
1727    */
1728   function forwardERC20s(IERC20 _token, uint256 _amount) external onlyOwner {
1729     _token.transfer(address(this), _amount);
1730   }
1731 
1732   function pause() external onlyOwner {
1733     _pause();
1734   }
1735 
1736   function unpause() external onlyOwner{
1737     _unpause();
1738   }
1739 
1740   /*
1741    * @dev Required for ERC721Pausable
1742    */
1743   function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Pausable, ERC721Enumerable) {
1744     super._beforeTokenTransfer(from, to, tokenId);
1745   }
1746 
1747   /*
1748    * Rarible/Foundation Royalties Protocol
1749    */
1750   function getFeeRecipients(uint256 id) public view override returns (address payable[] memory) {
1751     require(_exists(id), "DNE");
1752     address payable[] memory result = new address payable[](1);
1753     result[0] = PAYMENT_SPLITTER;
1754     return result;
1755   }
1756 
1757   /*
1758    * Rarible/Foundation Royalties Protocol
1759    */
1760   function getFeeBps(uint256 id) public view override returns (uint[] memory) {
1761     require(_exists(id), "DNE");
1762     uint[] memory result = new uint[](1);
1763     result[0] = 1000; // 10%
1764     return result;
1765   }
1766 
1767   /*
1768    * ERC2981 Royalties Standard
1769    */
1770   function royaltyInfo(uint256 _tokenId, uint256 _value, bytes calldata _data) external view override returns (address _receiver, uint256 _royaltyAmount, bytes memory _royaltyPaymentData) {
1771     return (PAYMENT_SPLITTER, _value / 10, _data); // 10%
1772   }
1773 
1774   function supportsInterface(bytes4 interfaceId) public view override(ERC721, HasSecondarySaleFees, ERC721Enumerable, ERC2981) returns (bool) {
1775     return super.supportsInterface(interfaceId);
1776   }
1777 
1778   function uint2str(uint256 _i) internal pure returns (string memory str) {
1779     if (_i == 0)
1780     {
1781       return "0";
1782     }
1783     uint256 j = _i;
1784     uint256 length;
1785     while (j != 0)
1786     {
1787       length++;
1788       j /= 10;
1789     }
1790     bytes memory bstr = new bytes(length);
1791     uint256 k = length;
1792     j = _i;
1793     while (j != 0)
1794     {
1795       bstr[--k] = bytes1(uint8(48 + j % 10));
1796       j /= 10;
1797     }
1798     str = string(bstr);
1799   }
1800 
1801   /*
1802    * Generates the hash representation of the struct Unit for EIP-718 usage
1803    */
1804   function hashUnit(Unit memory unitobj) private view returns (bytes32) {
1805     return keccak256(abi.encodePacked(
1806         "\x19\x01",
1807         DOMAIN_SEPARATOR,
1808         keccak256(abi.encode(
1809             UNIT_TYPEHASH,
1810             keccak256(bytes(unitobj.logIn))
1811         ))
1812     ));
1813   }
1814 
1815   /*
1816    * EIP-718 signature check
1817    */
1818   function verify(address signer, uint8 sigV, bytes32 sigR, bytes32 sigS) private view returns (bool) {
1819     Unit memory msgObj = Unit({
1820        logIn: 'Log In To Radioactive Punks!'
1821     });
1822     return signer == ecrecover(hashUnit(msgObj), sigV, sigR, sigS);
1823   }
1824 }