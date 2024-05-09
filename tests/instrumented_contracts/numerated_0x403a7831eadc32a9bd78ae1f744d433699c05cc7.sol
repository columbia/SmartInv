1 // %%%%%%%%%%%%%%%%%%%%%/                                                 
2       // /((((((((((((((((((((((/,    (%%%%%.                                            
3       // ((((((((((((((/*,.....,,/(((((((@@@(* ,%%%%%,                                         
4       // (((((.  * @  *@* &@.,@ &@ @. /@%    /(@@( (%%%%%#                                       
5       // (((,  @ %@ @ & @# @@( @ &@,@%( @&.@&@@  (@(  %%%%%%.                                     
6       // ((( % @@ %@@@ @ @% @/@ @@&@&@@& @@@&@@& .  ((  %%%%%%%                                    
7       // (( @@ @ @@&@  @@@@@@@@ @@@@@@@   ..     &@  (( #%%%%%%%                                   
8       // *(. @    @@&    (@@@@     ,**                ((  %%%%%%%%                                  
9       // ((                                           /(( %%%%%%%%.                                 
10       // ((            ((((.           *(((/           (( #%%%%%%%%                                 
11       // ((         ((((((((/        (((((((((         (( .%%%%%%%%                                 
12       // ((        (((((((((         ((((((((((        ((  %%%%%%%%#                                
13       // *(       (((((((((.       @ *(((((((((        ((  %%%%%%%%#                                
14       // (       (((((((((/       @  (((((((((        ((                                           
15       // (       (((((((((((        ((((((((((        ((                                           
16       // (        ((((((((((((((((((((((((((((        ((                                           
17       // (.        ((((((((((((((((((((((((((         ((.                                          
18       // (*          ((((((((((((((((((((((           ((,  #%%%%%%%                                
19       // ((                                           ((/ %%%%%%%%%                                
20       // ((                        &&                 ((( %%%%%%%%%                                
21       // /(      %@@@@@@&        (@@@@@@              ((( %%%%%%%%%                                
22       // (  @@ &@/@@@@@*  /(    %@ &@@@@(  @@@@@@ ,  ((( #%%%%%%%*                                
23       // ((  @ @@,%@*@@ @@@@@@@  #,@ /@@@ .,@.@ @@   ((( #%%%%%%%/,                               
24       // ((, @  &@.@*@# @@@@@@@, @@&.@@#@ # @ @#@   (@(/ %%%%%%%%%%                               
25       // ((/ /. @ @ @@ @@& @ @% @,.@@ @% @(@ @@,& (@#( #****%%%%%%                               
26       // .((/  @.@ .@ @@@ @ @@ @  @* @, @@@ @  /(((/ %******%%%%%%                              
27       // %%  ((((,   @ @%@*@ @@ @  @ /@*    *(((((* *%%#****%%%%%%%                              
28       // %%%%%   ,((((((*           ,(((((((((,  .%%%%%%%%%%%%%%%%%%                             
29       // ***#%%%%%%#      ./(((((((*.      .%%%%%%%%%%%%%%%%%%%#   **                            
30       // ****%%%%%%%%%%%%%%%%%%%%%%%%#(%%%%%%%%%%%%%%%%%%%%    %%%                               
31       // **, %%%%%****(%%%%%%%%%%%%%****%%%%%%%%*****(  %% %%( ##%%***                           
32       // .    *%%    .***%%%%%%%%%%%%%%%%%%%%%%%%    ,**    #%%%%%%%%%%%%                          
33       // %%%(    **  *(%  .            .%* .%# #*, **%%%%%%%%%%%%%%%%%%%                         
34       // *%%%%%%%%%%%/         /(   *.     #    %%%#%%%%%%%*****%%%%%%%%%%                        
35       // %%%%%%%%%%%%%%%%(****/%  ,(#% %%%%%****#%%%%%%%%%%/****#%%%%%%%%%*                       
36       // %%**(%%%%%%%%%%%(**** &@@      %%%******%%%%%%%%%%%%%%%%%%%%%%%%%**                      
37       // /%****(%%%%%%(%%%%%%%%%%  ((((( %%%*****(%%%%(**%%%%%%%%%%%%%%%%%%***                     
38       // %*****%%%%%****%%%%%%%%         %%%%%%%%%%%%%%/%%%%%%%%%%(**%%%%%%%***                    
39       // %/***%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*******#%%%%%%%%,  
40 
41 
42 // File: @openzeppelin/contracts/utils/Strings.sol
43 
44 
45 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
46 
47 pragma solidity ^0.8.0;
48 
49 /**
50  * @dev String operations.
51  */
52 library Strings {
53     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
57      */
58     function toString(uint256 value) internal pure returns (string memory) {
59         // Inspired by OraclizeAPI's implementation - MIT licence
60         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
61 
62         if (value == 0) {
63             return "0";
64         }
65         uint256 temp = value;
66         uint256 digits;
67         while (temp != 0) {
68             digits++;
69             temp /= 10;
70         }
71         bytes memory buffer = new bytes(digits);
72         while (value != 0) {
73             digits -= 1;
74             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
75             value /= 10;
76         }
77         return string(buffer);
78     }
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
82      */
83     function toHexString(uint256 value) internal pure returns (string memory) {
84         if (value == 0) {
85             return "0x00";
86         }
87         uint256 temp = value;
88         uint256 length = 0;
89         while (temp != 0) {
90             length++;
91             temp >>= 8;
92         }
93         return toHexString(value, length);
94     }
95 
96     /**
97      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
98      */
99     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
100         bytes memory buffer = new bytes(2 * length + 2);
101         buffer[0] = "0";
102         buffer[1] = "x";
103         for (uint256 i = 2 * length + 1; i > 1; --i) {
104             buffer[i] = _HEX_SYMBOLS[value & 0xf];
105             value >>= 4;
106         }
107         require(value == 0, "Strings: hex length insufficient");
108         return string(buffer);
109     }
110 }
111 
112 // File: @openzeppelin/contracts/utils/Context.sol
113 
114 
115 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 /**
120  * @dev Provides information about the current execution context, including the
121  * sender of the transaction and its data. While these are generally available
122  * via msg.sender and msg.data, they should not be accessed in such a direct
123  * manner, since when dealing with meta-transactions the account sending and
124  * paying for execution may not be the actual sender (as far as an application
125  * is concerned).
126  *
127  * This contract is only required for intermediate, library-like contracts.
128  */
129 abstract contract Context {
130     function _msgSender() internal view virtual returns (address) {
131         return msg.sender;
132     }
133 
134     function _msgData() internal view virtual returns (bytes calldata) {
135         return msg.data;
136     }
137 }
138 
139 // File: @openzeppelin/contracts/access/Ownable.sol
140 
141 
142 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
143 
144 pragma solidity ^0.8.0;
145 
146 
147 /**
148  * @dev Contract module which provides a basic access control mechanism, where
149  * there is an account (an owner) that can be granted exclusive access to
150  * specific functions.
151  *
152  * By default, the owner account will be the one that deploys the contract. This
153  * can later be changed with {transferOwnership}.
154  *
155  * This module is used through inheritance. It will make available the modifier
156  * `onlyOwner`, which can be applied to your functions to restrict their use to
157  * the owner.
158  */
159 abstract contract Ownable is Context {
160     address private _owner;
161 
162     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
163 
164     /**
165      * @dev Initializes the contract setting the deployer as the initial owner.
166      */
167     constructor() {
168         _transferOwnership(_msgSender());
169     }
170 
171     /**
172      * @dev Returns the address of the current owner.
173      */
174     function owner() public view virtual returns (address) {
175         return _owner;
176     }
177 
178     /**
179      * @dev Throws if called by any account other than the owner.
180      */
181     modifier onlyOwner() {
182         require(owner() == _msgSender(), "Ownable: caller is not the owner");
183         _;
184     }
185 
186     /**
187      * @dev Leaves the contract without owner. It will not be possible to call
188      * `onlyOwner` functions anymore. Can only be called by the current owner.
189      *
190      * NOTE: Renouncing ownership will leave the contract without an owner,
191      * thereby removing any functionality that is only available to the owner.
192      */
193     function renounceOwnership() public virtual onlyOwner {
194         _transferOwnership(address(0));
195     }
196 
197     /**
198      * @dev Transfers ownership of the contract to a new account (`newOwner`).
199      * Can only be called by the current owner.
200      */
201     function transferOwnership(address newOwner) public virtual onlyOwner {
202         require(newOwner != address(0), "Ownable: new owner is the zero address");
203         _transferOwnership(newOwner);
204     }
205 
206     /**
207      * @dev Transfers ownership of the contract to a new account (`newOwner`).
208      * Internal function without access restriction.
209      */
210     function _transferOwnership(address newOwner) internal virtual {
211         address oldOwner = _owner;
212         _owner = newOwner;
213         emit OwnershipTransferred(oldOwner, newOwner);
214     }
215 }
216 
217 // File: @openzeppelin/contracts/utils/Address.sol
218 
219 
220 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
221 
222 pragma solidity ^0.8.1;
223 
224 /**
225  * @dev Collection of functions related to the address type
226  */
227 library Address {
228     /**
229      * @dev Returns true if `account` is a contract.
230      *
231      * [IMPORTANT]
232      * ====
233      * It is unsafe to assume that an address for which this function returns
234      * false is an externally-owned account (EOA) and not a contract.
235      *
236      * Among others, `isContract` will return false for the following
237      * types of addresses:
238      *
239      *  - an externally-owned account
240      *  - a contract in construction
241      *  - an address where a contract will be created
242      *  - an address where a contract lived, but was destroyed
243      * ====
244      *
245      * [IMPORTANT]
246      * ====
247      * You shouldn't rely on `isContract` to protect against flash loan attacks!
248      *
249      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
250      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
251      * constructor.
252      * ====
253      */
254     function isContract(address account) internal view returns (bool) {
255         // This method relies on extcodesize/address.code.length, which returns 0
256         // for contracts in construction, since the code is only stored at the end
257         // of the constructor execution.
258 
259         return account.code.length > 0;
260     }
261 
262     /**
263      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
264      * `recipient`, forwarding all available gas and reverting on errors.
265      *
266      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
267      * of certain opcodes, possibly making contracts go over the 2300 gas limit
268      * imposed by `transfer`, making them unable to receive funds via
269      * `transfer`. {sendValue} removes this limitation.
270      *
271      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
272      *
273      * IMPORTANT: because control is transferred to `recipient`, care must be
274      * taken to not create reentrancy vulnerabilities. Consider using
275      * {ReentrancyGuard} or the
276      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
277      */
278     function sendValue(address payable recipient, uint256 amount) internal {
279         require(address(this).balance >= amount, "Address: insufficient balance");
280 
281         (bool success, ) = recipient.call{value: amount}("");
282         require(success, "Address: unable to send value, recipient may have reverted");
283     }
284 
285     /**
286      * @dev Performs a Solidity function call using a low level `call`. A
287      * plain `call` is an unsafe replacement for a function call: use this
288      * function instead.
289      *
290      * If `target` reverts with a revert reason, it is bubbled up by this
291      * function (like regular Solidity function calls).
292      *
293      * Returns the raw returned data. To convert to the expected return value,
294      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
295      *
296      * Requirements:
297      *
298      * - `target` must be a contract.
299      * - calling `target` with `data` must not revert.
300      *
301      * _Available since v3.1._
302      */
303     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
304         return functionCall(target, data, "Address: low-level call failed");
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
309      * `errorMessage` as a fallback revert reason when `target` reverts.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(
314         address target,
315         bytes memory data,
316         string memory errorMessage
317     ) internal returns (bytes memory) {
318         return functionCallWithValue(target, data, 0, errorMessage);
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but also transferring `value` wei to `target`.
324      *
325      * Requirements:
326      *
327      * - the calling contract must have an ETH balance of at least `value`.
328      * - the called Solidity function must be `payable`.
329      *
330      * _Available since v3.1._
331      */
332     function functionCallWithValue(
333         address target,
334         bytes memory data,
335         uint256 value
336     ) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
342      * with `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(
347         address target,
348         bytes memory data,
349         uint256 value,
350         string memory errorMessage
351     ) internal returns (bytes memory) {
352         require(address(this).balance >= value, "Address: insufficient balance for call");
353         require(isContract(target), "Address: call to non-contract");
354 
355         (bool success, bytes memory returndata) = target.call{value: value}(data);
356         return verifyCallResult(success, returndata, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but performing a static call.
362      *
363      * _Available since v3.3._
364      */
365     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
366         return functionStaticCall(target, data, "Address: low-level static call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
371      * but performing a static call.
372      *
373      * _Available since v3.3._
374      */
375     function functionStaticCall(
376         address target,
377         bytes memory data,
378         string memory errorMessage
379     ) internal view returns (bytes memory) {
380         require(isContract(target), "Address: static call to non-contract");
381 
382         (bool success, bytes memory returndata) = target.staticcall(data);
383         return verifyCallResult(success, returndata, errorMessage);
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
388      * but performing a delegate call.
389      *
390      * _Available since v3.4._
391      */
392     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
393         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
398      * but performing a delegate call.
399      *
400      * _Available since v3.4._
401      */
402     function functionDelegateCall(
403         address target,
404         bytes memory data,
405         string memory errorMessage
406     ) internal returns (bytes memory) {
407         require(isContract(target), "Address: delegate call to non-contract");
408 
409         (bool success, bytes memory returndata) = target.delegatecall(data);
410         return verifyCallResult(success, returndata, errorMessage);
411     }
412 
413     /**
414      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
415      * revert reason using the provided one.
416      *
417      * _Available since v4.3._
418      */
419     function verifyCallResult(
420         bool success,
421         bytes memory returndata,
422         string memory errorMessage
423     ) internal pure returns (bytes memory) {
424         if (success) {
425             return returndata;
426         } else {
427             // Look for revert reason and bubble it up if present
428             if (returndata.length > 0) {
429                 // The easiest way to bubble the revert reason is using memory via assembly
430 
431                 assembly {
432                     let returndata_size := mload(returndata)
433                     revert(add(32, returndata), returndata_size)
434                 }
435             } else {
436                 revert(errorMessage);
437             }
438         }
439     }
440 }
441 
442 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
443 
444 
445 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
446 
447 pragma solidity ^0.8.0;
448 
449 /**
450  * @title ERC721 token receiver interface
451  * @dev Interface for any contract that wants to support safeTransfers
452  * from ERC721 asset contracts.
453  */
454 interface IERC721Receiver {
455     /**
456      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
457      * by `operator` from `from`, this function is called.
458      *
459      * It must return its Solidity selector to confirm the token transfer.
460      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
461      *
462      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
463      */
464     function onERC721Received(
465         address operator,
466         address from,
467         uint256 tokenId,
468         bytes calldata data
469     ) external returns (bytes4);
470 }
471 
472 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
473 
474 
475 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
476 
477 pragma solidity ^0.8.0;
478 
479 /**
480  * @dev Interface of the ERC165 standard, as defined in the
481  * https://eips.ethereum.org/EIPS/eip-165[EIP].
482  *
483  * Implementers can declare support of contract interfaces, which can then be
484  * queried by others ({ERC165Checker}).
485  *
486  * For an implementation, see {ERC165}.
487  */
488 interface IERC165 {
489     /**
490      * @dev Returns true if this contract implements the interface defined by
491      * `interfaceId`. See the corresponding
492      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
493      * to learn more about how these ids are created.
494      *
495      * This function call must use less than 30 000 gas.
496      */
497     function supportsInterface(bytes4 interfaceId) external view returns (bool);
498 }
499 
500 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
501 
502 
503 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
504 
505 pragma solidity ^0.8.0;
506 
507 
508 /**
509  * @dev Interface for the NFT Royalty Standard.
510  *
511  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
512  * support for royalty payments across all NFT marketplaces and ecosystem participants.
513  *
514  * _Available since v4.5._
515  */
516 interface IERC2981 is IERC165 {
517     /**
518      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
519      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
520      */
521     function royaltyInfo(uint256 tokenId, uint256 salePrice)
522         external
523         view
524         returns (address receiver, uint256 royaltyAmount);
525 }
526 
527 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
528 
529 
530 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
531 
532 pragma solidity ^0.8.0;
533 
534 
535 /**
536  * @dev Implementation of the {IERC165} interface.
537  *
538  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
539  * for the additional interface id that will be supported. For example:
540  *
541  * ```solidity
542  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
543  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
544  * }
545  * ```
546  *
547  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
548  */
549 abstract contract ERC165 is IERC165 {
550     /**
551      * @dev See {IERC165-supportsInterface}.
552      */
553     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
554         return interfaceId == type(IERC165).interfaceId;
555     }
556 }
557 
558 // File: @openzeppelin/contracts/token/common/ERC2981.sol
559 
560 
561 // OpenZeppelin Contracts (last updated v4.6.0) (token/common/ERC2981.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 
566 
567 /**
568  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
569  *
570  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
571  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
572  *
573  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
574  * fee is specified in basis points by default.
575  *
576  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
577  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
578  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
579  *
580  * _Available since v4.5._
581  */
582 abstract contract ERC2981 is IERC2981, ERC165 {
583     struct RoyaltyInfo {
584         address receiver;
585         uint96 royaltyFraction;
586     }
587 
588     RoyaltyInfo private _defaultRoyaltyInfo;
589     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
590 
591     /**
592      * @dev See {IERC165-supportsInterface}.
593      */
594     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
595         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
596     }
597 
598     /**
599      * @inheritdoc IERC2981
600      */
601     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
602         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
603 
604         if (royalty.receiver == address(0)) {
605             royalty = _defaultRoyaltyInfo;
606         }
607 
608         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
609 
610         return (royalty.receiver, royaltyAmount);
611     }
612 
613     /**
614      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
615      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
616      * override.
617      */
618     function _feeDenominator() internal pure virtual returns (uint96) {
619         return 10000;
620     }
621 
622     /**
623      * @dev Sets the royalty information that all ids in this contract will default to.
624      *
625      * Requirements:
626      *
627      * - `receiver` cannot be the zero address.
628      * - `feeNumerator` cannot be greater than the fee denominator.
629      */
630     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
631         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
632         require(receiver != address(0), "ERC2981: invalid receiver");
633 
634         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
635     }
636 
637     /**
638      * @dev Removes default royalty information.
639      */
640     function _deleteDefaultRoyalty() internal virtual {
641         delete _defaultRoyaltyInfo;
642     }
643 
644     /**
645      * @dev Sets the royalty information for a specific token id, overriding the global default.
646      *
647      * Requirements:
648      *
649      * - `tokenId` must be already minted.
650      * - `receiver` cannot be the zero address.
651      * - `feeNumerator` cannot be greater than the fee denominator.
652      */
653     function _setTokenRoyalty(
654         uint256 tokenId,
655         address receiver,
656         uint96 feeNumerator
657     ) internal virtual {
658         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
659         require(receiver != address(0), "ERC2981: Invalid parameters");
660 
661         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
662     }
663 
664     /**
665      * @dev Resets royalty information for the token id back to the global default.
666      */
667     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
668         delete _tokenRoyaltyInfo[tokenId];
669     }
670 }
671 
672 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
673 
674 
675 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
676 
677 pragma solidity ^0.8.0;
678 
679 
680 /**
681  * @dev Required interface of an ERC721 compliant contract.
682  */
683 interface IERC721 is IERC165 {
684     /**
685      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
686      */
687     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
688 
689     /**
690      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
691      */
692     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
693 
694     /**
695      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
696      */
697     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
698 
699     /**
700      * @dev Returns the number of tokens in ``owner``'s account.
701      */
702     function balanceOf(address owner) external view returns (uint256 balance);
703 
704     /**
705      * @dev Returns the owner of the `tokenId` token.
706      *
707      * Requirements:
708      *
709      * - `tokenId` must exist.
710      */
711     function ownerOf(uint256 tokenId) external view returns (address owner);
712 
713     /**
714      * @dev Safely transfers `tokenId` token from `from` to `to`.
715      *
716      * Requirements:
717      *
718      * - `from` cannot be the zero address.
719      * - `to` cannot be the zero address.
720      * - `tokenId` token must exist and be owned by `from`.
721      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
722      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
723      *
724      * Emits a {Transfer} event.
725      */
726     function safeTransferFrom(
727         address from,
728         address to,
729         uint256 tokenId,
730         bytes calldata data
731     ) external;
732 
733     /**
734      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
735      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
736      *
737      * Requirements:
738      *
739      * - `from` cannot be the zero address.
740      * - `to` cannot be the zero address.
741      * - `tokenId` token must exist and be owned by `from`.
742      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
743      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
744      *
745      * Emits a {Transfer} event.
746      */
747     function safeTransferFrom(
748         address from,
749         address to,
750         uint256 tokenId
751     ) external;
752 
753     /**
754      * @dev Transfers `tokenId` token from `from` to `to`.
755      *
756      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
757      *
758      * Requirements:
759      *
760      * - `from` cannot be the zero address.
761      * - `to` cannot be the zero address.
762      * - `tokenId` token must be owned by `from`.
763      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
764      *
765      * Emits a {Transfer} event.
766      */
767     function transferFrom(
768         address from,
769         address to,
770         uint256 tokenId
771     ) external;
772 
773     /**
774      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
775      * The approval is cleared when the token is transferred.
776      *
777      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
778      *
779      * Requirements:
780      *
781      * - The caller must own the token or be an approved operator.
782      * - `tokenId` must exist.
783      *
784      * Emits an {Approval} event.
785      */
786     function approve(address to, uint256 tokenId) external;
787 
788     /**
789      * @dev Approve or remove `operator` as an operator for the caller.
790      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
791      *
792      * Requirements:
793      *
794      * - The `operator` cannot be the caller.
795      *
796      * Emits an {ApprovalForAll} event.
797      */
798     function setApprovalForAll(address operator, bool _approved) external;
799 
800     /**
801      * @dev Returns the account approved for `tokenId` token.
802      *
803      * Requirements:
804      *
805      * - `tokenId` must exist.
806      */
807     function getApproved(uint256 tokenId) external view returns (address operator);
808 
809     /**
810      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
811      *
812      * See {setApprovalForAll}
813      */
814     function isApprovedForAll(address owner, address operator) external view returns (bool);
815 }
816 
817 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
818 
819 
820 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
821 
822 pragma solidity ^0.8.0;
823 
824 
825 /**
826  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
827  * @dev See https://eips.ethereum.org/EIPS/eip-721
828  */
829 interface IERC721Enumerable is IERC721 {
830     /**
831      * @dev Returns the total amount of tokens stored by the contract.
832      */
833     function totalSupply() external view returns (uint256);
834 
835     /**
836      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
837      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
838      */
839     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
840 
841     /**
842      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
843      * Use along with {totalSupply} to enumerate all tokens.
844      */
845     function tokenByIndex(uint256 index) external view returns (uint256);
846 }
847 
848 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
849 
850 
851 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
852 
853 pragma solidity ^0.8.0;
854 
855 
856 /**
857  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
858  * @dev See https://eips.ethereum.org/EIPS/eip-721
859  */
860 interface IERC721Metadata is IERC721 {
861     /**
862      * @dev Returns the token collection name.
863      */
864     function name() external view returns (string memory);
865 
866     /**
867      * @dev Returns the token collection symbol.
868      */
869     function symbol() external view returns (string memory);
870 
871     /**
872      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
873      */
874     function tokenURI(uint256 tokenId) external view returns (string memory);
875 }
876 
877 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
878 
879 
880 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
881 
882 pragma solidity ^0.8.0;
883 
884 
885 
886 
887 
888 
889 
890 
891 /**
892  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
893  * the Metadata extension, but not including the Enumerable extension, which is available separately as
894  * {ERC721Enumerable}.
895  */
896 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
897     using Address for address;
898     using Strings for uint256;
899 
900     // Token name
901     string private _name;
902 
903     // Token symbol
904     string private _symbol;
905 
906     // Mapping from token ID to owner address
907     mapping(uint256 => address) private _owners;
908 
909     // Mapping owner address to token count
910     mapping(address => uint256) private _balances;
911 
912     // Mapping from token ID to approved address
913     mapping(uint256 => address) private _tokenApprovals;
914 
915     // Mapping from owner to operator approvals
916     mapping(address => mapping(address => bool)) private _operatorApprovals;
917 
918     /**
919      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
920      */
921     constructor(string memory name_, string memory symbol_) {
922         _name = name_;
923         _symbol = symbol_;
924     }
925 
926     /**
927      * @dev See {IERC165-supportsInterface}.
928      */
929     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
930         return
931             interfaceId == type(IERC721).interfaceId ||
932             interfaceId == type(IERC721Metadata).interfaceId ||
933             super.supportsInterface(interfaceId);
934     }
935 
936     /**
937      * @dev See {IERC721-balanceOf}.
938      */
939     function balanceOf(address owner) public view virtual override returns (uint256) {
940         require(owner != address(0), "ERC721: balance query for the zero address");
941         return _balances[owner];
942     }
943 
944     /**
945      * @dev See {IERC721-ownerOf}.
946      */
947     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
948         address owner = _owners[tokenId];
949         require(owner != address(0), "ERC721: owner query for nonexistent token");
950         return owner;
951     }
952 
953     /**
954      * @dev See {IERC721Metadata-name}.
955      */
956     function name() public view virtual override returns (string memory) {
957         return _name;
958     }
959 
960     /**
961      * @dev See {IERC721Metadata-symbol}.
962      */
963     function symbol() public view virtual override returns (string memory) {
964         return _symbol;
965     }
966 
967     /**
968      * @dev See {IERC721Metadata-tokenURI}.
969      */
970     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
971         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
972 
973         string memory baseURI = _baseURI();
974         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
975     }
976 
977     /**
978      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
979      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
980      * by default, can be overridden in child contracts.
981      */
982     function _baseURI() internal view virtual returns (string memory) {
983         return "";
984     }
985 
986     /**
987      * @dev See {IERC721-approve}.
988      */
989     function approve(address to, uint256 tokenId) public virtual override {
990         address owner = ERC721.ownerOf(tokenId);
991         require(to != owner, "ERC721: approval to current owner");
992 
993         require(
994             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
995             "ERC721: approve caller is not owner nor approved for all"
996         );
997 
998         _approve(to, tokenId);
999     }
1000 
1001     /**
1002      * @dev See {IERC721-getApproved}.
1003      */
1004     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1005         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1006 
1007         return _tokenApprovals[tokenId];
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-setApprovalForAll}.
1012      */
1013     function setApprovalForAll(address operator, bool approved) public virtual override {
1014         _setApprovalForAll(_msgSender(), operator, approved);
1015     }
1016 
1017     /**
1018      * @dev See {IERC721-isApprovedForAll}.
1019      */
1020     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1021         return _operatorApprovals[owner][operator];
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-transferFrom}.
1026      */
1027     function transferFrom(
1028         address from,
1029         address to,
1030         uint256 tokenId
1031     ) public virtual override {
1032         //solhint-disable-next-line max-line-length
1033         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1034 
1035         _transfer(from, to, tokenId);
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-safeTransferFrom}.
1040      */
1041     function safeTransferFrom(
1042         address from,
1043         address to,
1044         uint256 tokenId
1045     ) public virtual override {
1046         safeTransferFrom(from, to, tokenId, "");
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-safeTransferFrom}.
1051      */
1052     function safeTransferFrom(
1053         address from,
1054         address to,
1055         uint256 tokenId,
1056         bytes memory _data
1057     ) public virtual override {
1058         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1059         _safeTransfer(from, to, tokenId, _data);
1060     }
1061 
1062     /**
1063      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1064      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1065      *
1066      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1067      *
1068      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1069      * implement alternative mechanisms to perform token transfer, such as signature-based.
1070      *
1071      * Requirements:
1072      *
1073      * - `from` cannot be the zero address.
1074      * - `to` cannot be the zero address.
1075      * - `tokenId` token must exist and be owned by `from`.
1076      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function _safeTransfer(
1081         address from,
1082         address to,
1083         uint256 tokenId,
1084         bytes memory _data
1085     ) internal virtual {
1086         _transfer(from, to, tokenId);
1087         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1088     }
1089 
1090     /**
1091      * @dev Returns whether `tokenId` exists.
1092      *
1093      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1094      *
1095      * Tokens start existing when they are minted (`_mint`),
1096      * and stop existing when they are burned (`_burn`).
1097      */
1098     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1099         return _owners[tokenId] != address(0);
1100     }
1101 
1102     /**
1103      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1104      *
1105      * Requirements:
1106      *
1107      * - `tokenId` must exist.
1108      */
1109     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1110         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1111         address owner = ERC721.ownerOf(tokenId);
1112         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1113     }
1114 
1115     /**
1116      * @dev Safely mints `tokenId` and transfers it to `to`.
1117      *
1118      * Requirements:
1119      *
1120      * - `tokenId` must not exist.
1121      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1122      *
1123      * Emits a {Transfer} event.
1124      */
1125     function _safeMint(address to, uint256 tokenId) internal virtual {
1126         _safeMint(to, tokenId, "");
1127     }
1128 
1129     /**
1130      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1131      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1132      */
1133     function _safeMint(
1134         address to,
1135         uint256 tokenId,
1136         bytes memory _data
1137     ) internal virtual {
1138         _mint(to, tokenId);
1139         require(
1140             _checkOnERC721Received(address(0), to, tokenId, _data),
1141             "ERC721: transfer to non ERC721Receiver implementer"
1142         );
1143     }
1144 
1145     /**
1146      * @dev Mints `tokenId` and transfers it to `to`.
1147      *
1148      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1149      *
1150      * Requirements:
1151      *
1152      * - `tokenId` must not exist.
1153      * - `to` cannot be the zero address.
1154      *
1155      * Emits a {Transfer} event.
1156      */
1157     function _mint(address to, uint256 tokenId) internal virtual {
1158         require(to != address(0), "ERC721: mint to the zero address");
1159         require(!_exists(tokenId), "ERC721: token already minted");
1160 
1161         _beforeTokenTransfer(address(0), to, tokenId);
1162 
1163         _balances[to] += 1;
1164         _owners[tokenId] = to;
1165 
1166         emit Transfer(address(0), to, tokenId);
1167 
1168         _afterTokenTransfer(address(0), to, tokenId);
1169     }
1170 
1171     /**
1172      * @dev Destroys `tokenId`.
1173      * The approval is cleared when the token is burned.
1174      *
1175      * Requirements:
1176      *
1177      * - `tokenId` must exist.
1178      *
1179      * Emits a {Transfer} event.
1180      */
1181     function _burn(uint256 tokenId) internal virtual {
1182         address owner = ERC721.ownerOf(tokenId);
1183 
1184         _beforeTokenTransfer(owner, address(0), tokenId);
1185 
1186         // Clear approvals
1187         _approve(address(0), tokenId);
1188 
1189         _balances[owner] -= 1;
1190         delete _owners[tokenId];
1191 
1192         emit Transfer(owner, address(0), tokenId);
1193 
1194         _afterTokenTransfer(owner, address(0), tokenId);
1195     }
1196 
1197     /**
1198      * @dev Transfers `tokenId` from `from` to `to`.
1199      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1200      *
1201      * Requirements:
1202      *
1203      * - `to` cannot be the zero address.
1204      * - `tokenId` token must be owned by `from`.
1205      *
1206      * Emits a {Transfer} event.
1207      */
1208     function _transfer(
1209         address from,
1210         address to,
1211         uint256 tokenId
1212     ) internal virtual {
1213         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1214         require(to != address(0), "ERC721: transfer to the zero address");
1215 
1216         _beforeTokenTransfer(from, to, tokenId);
1217 
1218         // Clear approvals from the previous owner
1219         _approve(address(0), tokenId);
1220 
1221         _balances[from] -= 1;
1222         _balances[to] += 1;
1223         _owners[tokenId] = to;
1224 
1225         emit Transfer(from, to, tokenId);
1226 
1227         _afterTokenTransfer(from, to, tokenId);
1228     }
1229 
1230     /**
1231      * @dev Approve `to` to operate on `tokenId`
1232      *
1233      * Emits a {Approval} event.
1234      */
1235     function _approve(address to, uint256 tokenId) internal virtual {
1236         _tokenApprovals[tokenId] = to;
1237         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1238     }
1239 
1240     /**
1241      * @dev Approve `operator` to operate on all of `owner` tokens
1242      *
1243      * Emits a {ApprovalForAll} event.
1244      */
1245     function _setApprovalForAll(
1246         address owner,
1247         address operator,
1248         bool approved
1249     ) internal virtual {
1250         require(owner != operator, "ERC721: approve to caller");
1251         _operatorApprovals[owner][operator] = approved;
1252         emit ApprovalForAll(owner, operator, approved);
1253     }
1254 
1255     /**
1256      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1257      * The call is not executed if the target address is not a contract.
1258      *
1259      * @param from address representing the previous owner of the given token ID
1260      * @param to target address that will receive the tokens
1261      * @param tokenId uint256 ID of the token to be transferred
1262      * @param _data bytes optional data to send along with the call
1263      * @return bool whether the call correctly returned the expected magic value
1264      */
1265     function _checkOnERC721Received(
1266         address from,
1267         address to,
1268         uint256 tokenId,
1269         bytes memory _data
1270     ) private returns (bool) {
1271         if (to.isContract()) {
1272             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1273                 return retval == IERC721Receiver.onERC721Received.selector;
1274             } catch (bytes memory reason) {
1275                 if (reason.length == 0) {
1276                     revert("ERC721: transfer to non ERC721Receiver implementer");
1277                 } else {
1278                     assembly {
1279                         revert(add(32, reason), mload(reason))
1280                     }
1281                 }
1282             }
1283         } else {
1284             return true;
1285         }
1286     }
1287 
1288     /**
1289      * @dev Hook that is called before any token transfer. This includes minting
1290      * and burning.
1291      *
1292      * Calling conditions:
1293      *
1294      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1295      * transferred to `to`.
1296      * - When `from` is zero, `tokenId` will be minted for `to`.
1297      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1298      * - `from` and `to` are never both zero.
1299      *
1300      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1301      */
1302     function _beforeTokenTransfer(
1303         address from,
1304         address to,
1305         uint256 tokenId
1306     ) internal virtual {}
1307 
1308     /**
1309      * @dev Hook that is called after any transfer of tokens. This includes
1310      * minting and burning.
1311      *
1312      * Calling conditions:
1313      *
1314      * - when `from` and `to` are both non-zero.
1315      * - `from` and `to` are never both zero.
1316      *
1317      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1318      */
1319     function _afterTokenTransfer(
1320         address from,
1321         address to,
1322         uint256 tokenId
1323     ) internal virtual {}
1324 }
1325 
1326 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1327 
1328 
1329 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1330 
1331 pragma solidity ^0.8.0;
1332 
1333 
1334 
1335 /**
1336  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1337  * enumerability of all the token ids in the contract as well as all token ids owned by each
1338  * account.
1339  */
1340 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1341     // Mapping from owner to list of owned token IDs
1342     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1343 
1344     // Mapping from token ID to index of the owner tokens list
1345     mapping(uint256 => uint256) private _ownedTokensIndex;
1346 
1347     // Array with all token ids, used for enumeration
1348     uint256[] private _allTokens;
1349 
1350     // Mapping from token id to position in the allTokens array
1351     mapping(uint256 => uint256) private _allTokensIndex;
1352 
1353     /**
1354      * @dev See {IERC165-supportsInterface}.
1355      */
1356     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1357         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1358     }
1359 
1360     /**
1361      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1362      */
1363     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1364         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1365         return _ownedTokens[owner][index];
1366     }
1367 
1368     /**
1369      * @dev See {IERC721Enumerable-totalSupply}.
1370      */
1371     function totalSupply() public view virtual override returns (uint256) {
1372         return _allTokens.length;
1373     }
1374 
1375     /**
1376      * @dev See {IERC721Enumerable-tokenByIndex}.
1377      */
1378     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1379         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1380         return _allTokens[index];
1381     }
1382 
1383     /**
1384      * @dev Hook that is called before any token transfer. This includes minting
1385      * and burning.
1386      *
1387      * Calling conditions:
1388      *
1389      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1390      * transferred to `to`.
1391      * - When `from` is zero, `tokenId` will be minted for `to`.
1392      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1393      * - `from` cannot be the zero address.
1394      * - `to` cannot be the zero address.
1395      *
1396      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1397      */
1398     function _beforeTokenTransfer(
1399         address from,
1400         address to,
1401         uint256 tokenId
1402     ) internal virtual override {
1403         super._beforeTokenTransfer(from, to, tokenId);
1404 
1405         if (from == address(0)) {
1406             _addTokenToAllTokensEnumeration(tokenId);
1407         } else if (from != to) {
1408             _removeTokenFromOwnerEnumeration(from, tokenId);
1409         }
1410         if (to == address(0)) {
1411             _removeTokenFromAllTokensEnumeration(tokenId);
1412         } else if (to != from) {
1413             _addTokenToOwnerEnumeration(to, tokenId);
1414         }
1415     }
1416 
1417     /**
1418      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1419      * @param to address representing the new owner of the given token ID
1420      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1421      */
1422     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1423         uint256 length = ERC721.balanceOf(to);
1424         _ownedTokens[to][length] = tokenId;
1425         _ownedTokensIndex[tokenId] = length;
1426     }
1427 
1428     /**
1429      * @dev Private function to add a token to this extension's token tracking data structures.
1430      * @param tokenId uint256 ID of the token to be added to the tokens list
1431      */
1432     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1433         _allTokensIndex[tokenId] = _allTokens.length;
1434         _allTokens.push(tokenId);
1435     }
1436 
1437     /**
1438      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1439      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1440      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1441      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1442      * @param from address representing the previous owner of the given token ID
1443      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1444      */
1445     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1446         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1447         // then delete the last slot (swap and pop).
1448 
1449         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1450         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1451 
1452         // When the token to delete is the last token, the swap operation is unnecessary
1453         if (tokenIndex != lastTokenIndex) {
1454             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1455 
1456             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1457             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1458         }
1459 
1460         // This also deletes the contents at the last position of the array
1461         delete _ownedTokensIndex[tokenId];
1462         delete _ownedTokens[from][lastTokenIndex];
1463     }
1464 
1465     /**
1466      * @dev Private function to remove a token from this extension's token tracking data structures.
1467      * This has O(1) time complexity, but alters the order of the _allTokens array.
1468      * @param tokenId uint256 ID of the token to be removed from the tokens list
1469      */
1470     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1471         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1472         // then delete the last slot (swap and pop).
1473 
1474         uint256 lastTokenIndex = _allTokens.length - 1;
1475         uint256 tokenIndex = _allTokensIndex[tokenId];
1476 
1477         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1478         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1479         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1480         uint256 lastTokenId = _allTokens[lastTokenIndex];
1481 
1482         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1483         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1484 
1485         // This also deletes the contents at the last position of the array
1486         delete _allTokensIndex[tokenId];
1487         _allTokens.pop();
1488     }
1489 }
1490 
1491 // File: contracts/nono_contract.sol
1492 
1493 
1494 
1495 pragma solidity ^0.8.0;
1496 
1497 
1498 
1499 
1500 
1501 contract ElCocoContract is ERC2981, ERC721Enumerable, Ownable  {
1502   using Strings for uint256;
1503 
1504   string public baseURI;
1505   string public baseExtension = ".json";
1506   uint256 public cost = 0.0999 ether;
1507   uint256 public maxSupply = 10000;
1508   uint256 public maxMintAmount = 10;
1509   bool public paused = false;
1510   mapping(address => bool) public whitelisted;
1511   uint96 royaltyFeesInBips;
1512   address royaltyAddress;
1513 
1514   constructor(
1515     string memory _name,
1516     string memory _symbol,
1517     string memory _initBaseURI,
1518     uint96 _royaltyFeesInBips
1519   ) ERC721(_name, _symbol) {
1520     setBaseURI(_initBaseURI);
1521     mint(msg.sender, 10);
1522     setRoyaltyInfo(msg.sender, _royaltyFeesInBips);
1523   }
1524 
1525   // internal
1526   function _baseURI() internal view virtual override returns (string memory) {
1527     return baseURI;
1528   }
1529 
1530   // public
1531   function mint(address _to, uint256 _mintAmount) public payable {
1532     uint256 supply = totalSupply();
1533     require(!paused);
1534     require(_mintAmount > 0);
1535     require(_mintAmount <= maxMintAmount);
1536     require(supply + _mintAmount <= maxSupply);
1537 
1538     if (msg.sender != owner()) {
1539       require(msg.value >= cost * _mintAmount);
1540     }
1541 
1542     for (uint256 i = 1; i <= _mintAmount; i++) {
1543       _safeMint(_to, supply + i);
1544     }
1545   }
1546 
1547   function setRoyaltyInfo(address _receiver, uint96 _royaltyFeesInBips) public onlyOwner {
1548       _setDefaultRoyalty(_receiver, _royaltyFeesInBips);
1549   }
1550 
1551   function walletOfOwner(address _owner)
1552     public
1553     view
1554     returns (uint256[] memory)
1555   {
1556     uint256 ownerTokenCount = balanceOf(_owner);
1557     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1558     for (uint256 i; i < ownerTokenCount; i++) {
1559       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1560     }
1561     return tokenIds;
1562   }
1563 
1564   function tokenURI(uint256 tokenId)
1565     public
1566     view
1567     virtual
1568     override
1569     returns (string memory)
1570   {
1571     require(
1572       _exists(tokenId),
1573       "ERC721Metadata: URI query for nonexistent token"
1574     );
1575 
1576     string memory currentBaseURI = _baseURI();
1577     return bytes(currentBaseURI).length > 0
1578         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1579         : "";
1580   }
1581 
1582   //only owner
1583   function setCost(uint256 _newCost) public onlyOwner {
1584     cost = _newCost;
1585   }
1586 
1587   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1588     maxMintAmount = _newmaxMintAmount;
1589   }
1590 
1591   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1592     baseURI = _newBaseURI;
1593   }
1594 
1595   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1596     baseExtension = _newBaseExtension;
1597   }
1598 
1599   function pause(bool _state) public onlyOwner {
1600     paused = _state;
1601   }
1602  
1603  function whitelistUser(address _user) public onlyOwner {
1604     whitelisted[_user] = true;
1605   }
1606  
1607   function removeWhitelistUser(address _user) public onlyOwner {
1608     whitelisted[_user] = false;
1609   }
1610 
1611   function withdraw() public payable onlyOwner {
1612     require(payable(msg.sender).send(address(this).balance));
1613   }
1614 
1615   function supportsInterface(bytes4 interfaceId)
1616         public
1617         view
1618         override(ERC721Enumerable, ERC2981)
1619         returns (bool)
1620     {
1621         return interfaceId == 0x2a55205a || super.supportsInterface(interfaceId);
1622     }
1623 }