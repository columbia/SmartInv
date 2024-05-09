1 // SPDX-License-Identifier: GPL-3.0
2 
3 /**
4 c'''''''''''''''''';l:'''''''''''''''''':l;''''''''''''''''''cxl'''''''''''''''''',lc'''''''''''''''''':l;''''''''''''''''''c
5 '                  .,.                  .,                   'o'                   ,.                  .,.                  '
6 '                  .,.                  .,                   'o'                   ,.                  .,.                  '
7 '                  .,.                  .,                   'o'                   ,.                  .,.                  '
8 '                  .,.                  .,                   'o'                   ,.                  .,.                  '
9 '                  .,.                  .,                   'o'                   ,.                  .,.                  '
10 '                  .,.                  .,                   'o'                   ,.                  .,.                  '
11 '                  .,.                  .,                   'o'                   ,.                  .,.                  '
12 '                  .,.                  .,                   'o'                   ,.                  .,.                  '
13 '                  .,.                  .,                   'l'                   ,.                  .,.                  '
14 :..................,l;..................;c'.........',;;;,''.;l:''',,;;,'.........'c:..................,l,..................:
15 ;...................:,..................,:.....,,,,,,,,,'...........'',,,,,,,,.....:,..................':'..................;
16 '                  .,.                  .;........                         ........;.                  .,.                  '
17 '                  .,.                 .,:'..                                    .';;.                 .,.                  '
18 '                  .,.              .'''.                                           ..''.              .,.                  '
19 '                  .,.            .''.                                                 .''.            .,.                  '
20 '                  .,.          .,'                                                       .,'          .,.                  '
21 '                  .,.        .,.                                                           .,.        .,.                  '
22 '                  .,.      .,'                                                               ',.      .,.                  '
23 '                  .,.     .;.                                                                 .,'     .,.                  '
24 :..................'c,....,,.                                                                    ';....'c'..................;
25 :..................,c;..,c,                                                                       'c,..,l,..................:
26 '                  .,.  ,'                       .........         .........                       .;. .,.                  '
27 '                  .,. ,'                      .,..     ..,.     .,'.     ..,'                      .;..,.                  '
28 '                  .,.',                     .,'           ',.  ',           .;.                     ''.,.                  '
29 '                  .,,,.     ..              ',             ,' .;.            ,,              ..     .,;,.                  '
30 '                  .;c.      ''              ;:........':,';o, ,:.........;:;:c:.             ',      .c:.                  '
31 '                   cl.      .,              ',        .;. ;x' .;.       .;. ,d;              ''       co.                  '
32 '                   oc       .,.              ',.       .',o;   cl.       .',l:              .,.       ;o.                  '
33 '                  .c;        ''               .''.......''.    ':''.......',.               .,        'c.                  '
34 '                  .:'        .,.                 .......       .,. ........                .,.        .;.                  '
35 :..................'c'         .,.                              .,.                         ,'         .:,..................:
36 '                  .:'          ',                               ''                        ,,          .;.                  '
37 '                  .c;           ',.                             .,                       ,,           'c.                  '
38 '                   oc            .;.                            .,.                    .,'            :o.                  '
39 '                   cl.            .,'                            ,'                   .,.             co.                  '
40 '                   ;c'              .,.                          .,                 .,.              .c:.                  '
41 '                  .,,,.               .,'.                       .,.              .,'               .,,,.                  '
42 '                  .,.',                 .''.            ..........:'           .''.                 ,'.,.                  '
43 '                  .,. ,'                   .'...        ...........        ......                  ';..;.                  '
44 '                  .,.  ,'                     ........               ........                     .;. .,.                  '
45 :..................,c;..,c,                        .......................                        'c,..,c,..................:
46 :..................'c,....,,.                                                                    ',....,c'..................;
47 '                  .,.     .;.                                                                 .,'     .,.                  '
48 '                  .,.      .,'.                                                              ',.      .,.                  '
49 '                  .,.        .,'                                                           .,.        .,.                  '
50 '                  .,.          .,'.                                                      .,.          .,.                  '
51 '                  .,.            .''.                                                 .''.            .,.                  '
52 '                  .,.              .'''.                                           ..''.              .,.                  '
53 '                  .,.                 .,:'..                                   ..':;.                 .,.                  '
54 '                  .,.                  .;........                         ........;'                  .;.                  '
55 ;...................:,..................,:.....',,,,,,,,'...........',,,,,,,,,.....:,..................':'..................;
56 :..................,l;..................;c,.........',;;;,,'':o:'',,;;;,'.........'c:..................;l,..................:
57 '                  .,.                  .,                   'o'                   ,.                  .,.                  '
58 '                  .,.                  .,                   'o'                   ,.                  .,.                  '
59 '                  .,.                  .,                   'l'                   ,.                  .,.                  '
60 '                  .,.                  .,                   'o'                   ,.                  .,.                  '
61 '                  .,.                  .,                   'o'                   ,.                  .,.                  '
62 '                  .,.                  .,                   'o'                   ,.                  .,.                  '
63 '                  .,.                  .,                   'o'                   ,.                  .,.                  '
64 '                  .,.                  .,                   'o'                   ,.                  .,.                  '
65 '                  .,.                  .,                   'o'                   ,.                  .,.                  '
66 c'''''''''''''''''';l:'''''''''''''''''':l;''''''''''''''''''cxl'''''''''''''''''',lc'''''''''''''''''':l;''''''''''''''''''c
67 
68 
69  ___  ________   ________ ___  ________   ___  _________  _______           ________  ________  ___  ________     
70 |\  \|\   ___  \|\  _____\\  \|\   ___  \|\  \|\___   ___\\  ___ \         |\   ____\|\   __  \|\  \|\   ___ \    
71 \ \  \ \  \\ \  \ \  \__/\ \  \ \  \\ \  \ \  \|___ \  \_\ \   __/|        \ \  \___|\ \  \|\  \ \  \ \  \_|\ \   
72  \ \  \ \  \\ \  \ \   __\\ \  \ \  \\ \  \ \  \   \ \  \ \ \  \_|/__       \ \  \  __\ \   _  _\ \  \ \  \ \\ \  
73   \ \  \ \  \\ \  \ \  \_| \ \  \ \  \\ \  \ \  \   \ \  \ \ \  \_|\ \       \ \  \|\  \ \  \\  \\ \  \ \  \_\\ \ 
74    \ \__\ \__\\ \__\ \__\   \ \__\ \__\\ \__\ \__\   \ \__\ \ \_______\       \ \_______\ \__\\ _\\ \__\ \_______\
75     \|__|\|__| \|__|\|__|    \|__|\|__| \|__|\|__|    \|__|  \|_______|        \|_______|\|__|\|__|\|__|\|_______|
76                                                                                                                                   
77 
78 */
79 
80 // File: @openzeppelin/contracts/utils/Strings.sol
81 
82 
83 
84 pragma solidity ^0.8.0;
85 
86 /**
87  * @dev String operations.
88  */
89 library Strings {
90     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
91 
92     /**
93      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
94      */
95     function toString(uint256 value) internal pure returns (string memory) {
96         // Inspired by OraclizeAPI's implementation - MIT licence
97         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
98 
99         if (value == 0) {
100             return "0";
101         }
102         uint256 temp = value;
103         uint256 digits;
104         while (temp != 0) {
105             digits++;
106             temp /= 10;
107         }
108         bytes memory buffer = new bytes(digits);
109         while (value != 0) {
110             digits -= 1;
111             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
112             value /= 10;
113         }
114         return string(buffer);
115     }
116 
117     /**
118      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
119      */
120     function toHexString(uint256 value) internal pure returns (string memory) {
121         if (value == 0) {
122             return "0x00";
123         }
124         uint256 temp = value;
125         uint256 length = 0;
126         while (temp != 0) {
127             length++;
128             temp >>= 8;
129         }
130         return toHexString(value, length);
131     }
132 
133     /**
134      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
135      */
136     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
137         bytes memory buffer = new bytes(2 * length + 2);
138         buffer[0] = "0";
139         buffer[1] = "x";
140         for (uint256 i = 2 * length + 1; i > 1; --i) {
141             buffer[i] = _HEX_SYMBOLS[value & 0xf];
142             value >>= 4;
143         }
144         require(value == 0, "Strings: hex length insufficient");
145         return string(buffer);
146     }
147 }
148 
149 // File: @openzeppelin/contracts/utils/Context.sol
150 
151 
152 
153 pragma solidity ^0.8.0;
154 
155 /**
156  * @dev Provides information about the current execution context, including the
157  * sender of the transaction and its data. While these are generally available
158  * via msg.sender and msg.data, they should not be accessed in such a direct
159  * manner, since when dealing with meta-transactions the account sending and
160  * paying for execution may not be the actual sender (as far as an application
161  * is concerned).
162  *
163  * This contract is only required for intermediate, library-like contracts.
164  */
165 abstract contract Context {
166     function _msgSender() internal view virtual returns (address) {
167         return msg.sender;
168     }
169 
170     function _msgData() internal view virtual returns (bytes calldata) {
171         return msg.data;
172     }
173 }
174 
175 // File: @openzeppelin/contracts/access/Ownable.sol
176 
177 
178 
179 pragma solidity ^0.8.0;
180 
181 
182 /**
183  * @dev Contract module which provides a basic access control mechanism, where
184  * there is an account (an owner) that can be granted exclusive access to
185  * specific functions.
186  *
187  * By default, the owner account will be the one that deploys the contract. This
188  * can later be changed with {transferOwnership}.
189  *
190  * This module is used through inheritance. It will make available the modifier
191  * `onlyOwner`, which can be applied to your functions to restrict their use to
192  * the owner.
193  */
194 abstract contract Ownable is Context {
195     address private _owner;
196 
197     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
198 
199     /**
200      * @dev Initializes the contract setting the deployer as the initial owner.
201      */
202     constructor() {
203         _setOwner(_msgSender());
204     }
205 
206     /**
207      * @dev Returns the address of the current owner.
208      */
209     function owner() public view virtual returns (address) {
210         return _owner;
211     }
212 
213     /**
214      * @dev Throws if called by any account other than the owner.
215      */
216     modifier onlyOwner() {
217         require(owner() == _msgSender(), "Ownable: caller is not the owner");
218         _;
219     }
220 
221     /**
222      * @dev Leaves the contract without owner. It will not be possible to call
223      * `onlyOwner` functions anymore. Can only be called by the current owner.
224      *
225      * NOTE: Renouncing ownership will leave the contract without an owner,
226      * thereby removing any functionality that is only available to the owner.
227      */
228     function renounceOwnership() public virtual onlyOwner {
229         _setOwner(address(0));
230     }
231 
232     /**
233      * @dev Transfers ownership of the contract to a new account (`newOwner`).
234      * Can only be called by the current owner.
235      */
236     function transferOwnership(address newOwner) public virtual onlyOwner {
237         require(newOwner != address(0), "Ownable: new owner is the zero address");
238         _setOwner(newOwner);
239     }
240 
241     function _setOwner(address newOwner) private {
242         address oldOwner = _owner;
243         _owner = newOwner;
244         emit OwnershipTransferred(oldOwner, newOwner);
245     }
246 }
247 
248 // File: @openzeppelin/contracts/utils/Address.sol
249 
250 
251 
252 pragma solidity ^0.8.0;
253 
254 /**
255  * @dev Collection of functions related to the address type
256  */
257 library Address {
258     /**
259      * @dev Returns true if `account` is a contract.
260      *
261      * [IMPORTANT]
262      * ====
263      * It is unsafe to assume that an address for which this function returns
264      * false is an externally-owned account (EOA) and not a contract.
265      *
266      * Among others, `isContract` will return false for the following
267      * types of addresses:
268      *
269      *  - an externally-owned account
270      *  - a contract in construction
271      *  - an address where a contract will be created
272      *  - an address where a contract lived, but was destroyed
273      * ====
274      */
275     function isContract(address account) internal view returns (bool) {
276         // This method relies on extcodesize, which returns 0 for contracts in
277         // construction, since the code is only stored at the end of the
278         // constructor execution.
279 
280         uint256 size;
281         assembly {
282             size := extcodesize(account)
283         }
284         return size > 0;
285     }
286 
287     /**
288      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
289      * `recipient`, forwarding all available gas and reverting on errors.
290      *
291      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
292      * of certain opcodes, possibly making contracts go over the 2300 gas limit
293      * imposed by `transfer`, making them unable to receive funds via
294      * `transfer`. {sendValue} removes this limitation.
295      *
296      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
297      *
298      * IMPORTANT: because control is transferred to `recipient`, care must be
299      * taken to not create reentrancy vulnerabilities. Consider using
300      * {ReentrancyGuard} or the
301      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
302      */
303     function sendValue(address payable recipient, uint256 amount) internal {
304         require(address(this).balance >= amount, "Address: insufficient balance");
305 
306         (bool success, ) = recipient.call{value: amount}("");
307         require(success, "Address: unable to send value, recipient may have reverted");
308     }
309 
310     /**
311      * @dev Performs a Solidity function call using a low level `call`. A
312      * plain `call` is an unsafe replacement for a function call: use this
313      * function instead.
314      *
315      * If `target` reverts with a revert reason, it is bubbled up by this
316      * function (like regular Solidity function calls).
317      *
318      * Returns the raw returned data. To convert to the expected return value,
319      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
320      *
321      * Requirements:
322      *
323      * - `target` must be a contract.
324      * - calling `target` with `data` must not revert.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
329         return functionCall(target, data, "Address: low-level call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
334      * `errorMessage` as a fallback revert reason when `target` reverts.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(
339         address target,
340         bytes memory data,
341         string memory errorMessage
342     ) internal returns (bytes memory) {
343         return functionCallWithValue(target, data, 0, errorMessage);
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
348      * but also transferring `value` wei to `target`.
349      *
350      * Requirements:
351      *
352      * - the calling contract must have an ETH balance of at least `value`.
353      * - the called Solidity function must be `payable`.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(
358         address target,
359         bytes memory data,
360         uint256 value
361     ) internal returns (bytes memory) {
362         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
367      * with `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(
372         address target,
373         bytes memory data,
374         uint256 value,
375         string memory errorMessage
376     ) internal returns (bytes memory) {
377         require(address(this).balance >= value, "Address: insufficient balance for call");
378         require(isContract(target), "Address: call to non-contract");
379 
380         (bool success, bytes memory returndata) = target.call{value: value}(data);
381         return verifyCallResult(success, returndata, errorMessage);
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
386      * but performing a static call.
387      *
388      * _Available since v3.3._
389      */
390     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
391         return functionStaticCall(target, data, "Address: low-level static call failed");
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
396      * but performing a static call.
397      *
398      * _Available since v3.3._
399      */
400     function functionStaticCall(
401         address target,
402         bytes memory data,
403         string memory errorMessage
404     ) internal view returns (bytes memory) {
405         require(isContract(target), "Address: static call to non-contract");
406 
407         (bool success, bytes memory returndata) = target.staticcall(data);
408         return verifyCallResult(success, returndata, errorMessage);
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
413      * but performing a delegate call.
414      *
415      * _Available since v3.4._
416      */
417     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
418         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
423      * but performing a delegate call.
424      *
425      * _Available since v3.4._
426      */
427     function functionDelegateCall(
428         address target,
429         bytes memory data,
430         string memory errorMessage
431     ) internal returns (bytes memory) {
432         require(isContract(target), "Address: delegate call to non-contract");
433 
434         (bool success, bytes memory returndata) = target.delegatecall(data);
435         return verifyCallResult(success, returndata, errorMessage);
436     }
437 
438     /**
439      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
440      * revert reason using the provided one.
441      *
442      * _Available since v4.3._
443      */
444     function verifyCallResult(
445         bool success,
446         bytes memory returndata,
447         string memory errorMessage
448     ) internal pure returns (bytes memory) {
449         if (success) {
450             return returndata;
451         } else {
452             // Look for revert reason and bubble it up if present
453             if (returndata.length > 0) {
454                 // The easiest way to bubble the revert reason is using memory via assembly
455 
456                 assembly {
457                     let returndata_size := mload(returndata)
458                     revert(add(32, returndata), returndata_size)
459                 }
460             } else {
461                 revert(errorMessage);
462             }
463         }
464     }
465 }
466 
467 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
468 
469 
470 
471 pragma solidity ^0.8.0;
472 
473 /**
474  * @title ERC721 token receiver interface
475  * @dev Interface for any contract that wants to support safeTransfers
476  * from ERC721 asset contracts.
477  */
478 interface IERC721Receiver {
479     /**
480      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
481      * by `operator` from `from`, this function is called.
482      *
483      * It must return its Solidity selector to confirm the token transfer.
484      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
485      *
486      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
487      */
488     function onERC721Received(
489         address operator,
490         address from,
491         uint256 tokenId,
492         bytes calldata data
493     ) external returns (bytes4);
494 }
495 
496 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
497 
498 
499 
500 pragma solidity ^0.8.0;
501 
502 /**
503  * @dev Interface of the ERC165 standard, as defined in the
504  * https://eips.ethereum.org/EIPS/eip-165[EIP].
505  *
506  * Implementers can declare support of contract interfaces, which can then be
507  * queried by others ({ERC165Checker}).
508  *
509  * For an implementation, see {ERC165}.
510  */
511 interface IERC165 {
512     /**
513      * @dev Returns true if this contract implements the interface defined by
514      * `interfaceId`. See the corresponding
515      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
516      * to learn more about how these ids are created.
517      *
518      * This function call must use less than 30 000 gas.
519      */
520     function supportsInterface(bytes4 interfaceId) external view returns (bool);
521 }
522 
523 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
524 
525 
526 
527 pragma solidity ^0.8.0;
528 
529 
530 /**
531  * @dev Implementation of the {IERC165} interface.
532  *
533  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
534  * for the additional interface id that will be supported. For example:
535  *
536  * ```solidity
537  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
538  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
539  * }
540  * ```
541  *
542  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
543  */
544 abstract contract ERC165 is IERC165 {
545     /**
546      * @dev See {IERC165-supportsInterface}.
547      */
548     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
549         return interfaceId == type(IERC165).interfaceId;
550     }
551 }
552 
553 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
554 
555 
556 
557 pragma solidity ^0.8.0;
558 
559 
560 /**
561  * @dev Required interface of an ERC721 compliant contract.
562  */
563 interface IERC721 is IERC165 {
564     /**
565      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
566      */
567     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
568 
569     /**
570      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
571      */
572     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
573 
574     /**
575      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
576      */
577     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
578 
579     /**
580      * @dev Returns the number of tokens in ``owner``'s account.
581      */
582     function balanceOf(address owner) external view returns (uint256 balance);
583 
584     /**
585      * @dev Returns the owner of the `tokenId` token.
586      *
587      * Requirements:
588      *
589      * - `tokenId` must exist.
590      */
591     function ownerOf(uint256 tokenId) external view returns (address owner);
592 
593     /**
594      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
595      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
596      *
597      * Requirements:
598      *
599      * - `from` cannot be the zero address.
600      * - `to` cannot be the zero address.
601      * - `tokenId` token must exist and be owned by `from`.
602      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
603      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
604      *
605      * Emits a {Transfer} event.
606      */
607     function safeTransferFrom(
608         address from,
609         address to,
610         uint256 tokenId
611     ) external;
612 
613     /**
614      * @dev Transfers `tokenId` token from `from` to `to`.
615      *
616      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
617      *
618      * Requirements:
619      *
620      * - `from` cannot be the zero address.
621      * - `to` cannot be the zero address.
622      * - `tokenId` token must be owned by `from`.
623      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
624      *
625      * Emits a {Transfer} event.
626      */
627     function transferFrom(
628         address from,
629         address to,
630         uint256 tokenId
631     ) external;
632 
633     /**
634      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
635      * The approval is cleared when the token is transferred.
636      *
637      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
638      *
639      * Requirements:
640      *
641      * - The caller must own the token or be an approved operator.
642      * - `tokenId` must exist.
643      *
644      * Emits an {Approval} event.
645      */
646     function approve(address to, uint256 tokenId) external;
647 
648     /**
649      * @dev Returns the account approved for `tokenId` token.
650      *
651      * Requirements:
652      *
653      * - `tokenId` must exist.
654      */
655     function getApproved(uint256 tokenId) external view returns (address operator);
656 
657     /**
658      * @dev Approve or remove `operator` as an operator for the caller.
659      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
660      *
661      * Requirements:
662      *
663      * - The `operator` cannot be the caller.
664      *
665      * Emits an {ApprovalForAll} event.
666      */
667     function setApprovalForAll(address operator, bool _approved) external;
668 
669     /**
670      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
671      *
672      * See {setApprovalForAll}
673      */
674     function isApprovedForAll(address owner, address operator) external view returns (bool);
675 
676     /**
677      * @dev Safely transfers `tokenId` token from `from` to `to`.
678      *
679      * Requirements:
680      *
681      * - `from` cannot be the zero address.
682      * - `to` cannot be the zero address.
683      * - `tokenId` token must exist and be owned by `from`.
684      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
685      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
686      *
687      * Emits a {Transfer} event.
688      */
689     function safeTransferFrom(
690         address from,
691         address to,
692         uint256 tokenId,
693         bytes calldata data
694     ) external;
695 }
696 
697 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
698 
699 
700 
701 pragma solidity ^0.8.0;
702 
703 
704 /**
705  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
706  * @dev See https://eips.ethereum.org/EIPS/eip-721
707  */
708 interface IERC721Enumerable is IERC721 {
709     /**
710      * @dev Returns the total amount of tokens stored by the contract.
711      */
712     function totalSupply() external view returns (uint256);
713 
714     /**
715      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
716      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
717      */
718     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
719 
720     /**
721      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
722      * Use along with {totalSupply} to enumerate all tokens.
723      */
724     function tokenByIndex(uint256 index) external view returns (uint256);
725 }
726 
727 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
728 
729 
730 
731 pragma solidity ^0.8.0;
732 
733 
734 /**
735  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
736  * @dev See https://eips.ethereum.org/EIPS/eip-721
737  */
738 interface IERC721Metadata is IERC721 {
739     /**
740      * @dev Returns the token collection name.
741      */
742     function name() external view returns (string memory);
743 
744     /**
745      * @dev Returns the token collection symbol.
746      */
747     function symbol() external view returns (string memory);
748 
749     /**
750      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
751      */
752     function tokenURI(uint256 tokenId) external view returns (string memory);
753 }
754 
755 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
756 
757 
758 
759 pragma solidity ^0.8.0;
760 
761 
762 
763 
764 
765 
766 
767 
768 /**
769  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
770  * the Metadata extension, but not including the Enumerable extension, which is available separately as
771  * {ERC721Enumerable}.
772  */
773 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
774     using Address for address;
775     using Strings for uint256;
776 
777     // Token name
778     string private _name;
779 
780     // Token symbol
781     string private _symbol;
782 
783     // Mapping from token ID to owner address
784     mapping(uint256 => address) private _owners;
785 
786     // Mapping owner address to token count
787     mapping(address => uint256) private _balances;
788 
789     // Mapping from token ID to approved address
790     mapping(uint256 => address) private _tokenApprovals;
791 
792     // Mapping from owner to operator approvals
793     mapping(address => mapping(address => bool)) private _operatorApprovals;
794 
795     /**
796      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
797      */
798     constructor(string memory name_, string memory symbol_) {
799         _name = name_;
800         _symbol = symbol_;
801     }
802 
803     /**
804      * @dev See {IERC165-supportsInterface}.
805      */
806     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
807         return
808             interfaceId == type(IERC721).interfaceId ||
809             interfaceId == type(IERC721Metadata).interfaceId ||
810             super.supportsInterface(interfaceId);
811     }
812 
813     /**
814      * @dev See {IERC721-balanceOf}.
815      */
816     function balanceOf(address owner) public view virtual override returns (uint256) {
817         require(owner != address(0), "ERC721: balance query for the zero address");
818         return _balances[owner];
819     }
820 
821     /**
822      * @dev See {IERC721-ownerOf}.
823      */
824     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
825         address owner = _owners[tokenId];
826         require(owner != address(0), "ERC721: owner query for nonexistent token");
827         return owner;
828     }
829 
830     /**
831      * @dev See {IERC721Metadata-name}.
832      */
833     function name() public view virtual override returns (string memory) {
834         return _name;
835     }
836 
837     /**
838      * @dev See {IERC721Metadata-symbol}.
839      */
840     function symbol() public view virtual override returns (string memory) {
841         return _symbol;
842     }
843 
844     /**
845      * @dev See {IERC721Metadata-tokenURI}.
846      */
847     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
848         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
849 
850         string memory baseURI = _baseURI();
851         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
852     }
853 
854     /**
855      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
856      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
857      * by default, can be overriden in child contracts.
858      */
859     function _baseURI() internal view virtual returns (string memory) {
860         return "";
861     }
862 
863     /**
864      * @dev See {IERC721-approve}.
865      */
866     function approve(address to, uint256 tokenId) public virtual override {
867         address owner = ERC721.ownerOf(tokenId);
868         require(to != owner, "ERC721: approval to current owner");
869 
870         require(
871             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
872             "ERC721: approve caller is not owner nor approved for all"
873         );
874 
875         _approve(to, tokenId);
876     }
877 
878     /**
879      * @dev See {IERC721-getApproved}.
880      */
881     function getApproved(uint256 tokenId) public view virtual override returns (address) {
882         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
883 
884         return _tokenApprovals[tokenId];
885     }
886 
887     /**
888      * @dev See {IERC721-setApprovalForAll}.
889      */
890     function setApprovalForAll(address operator, bool approved) public virtual override {
891         require(operator != _msgSender(), "ERC721: approve to caller");
892 
893         _operatorApprovals[_msgSender()][operator] = approved;
894         emit ApprovalForAll(_msgSender(), operator, approved);
895     }
896 
897     /**
898      * @dev See {IERC721-isApprovedForAll}.
899      */
900     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
901         return _operatorApprovals[owner][operator];
902     }
903 
904     /**
905      * @dev See {IERC721-transferFrom}.
906      */
907     function transferFrom(
908         address from,
909         address to,
910         uint256 tokenId
911     ) public virtual override {
912         //solhint-disable-next-line max-line-length
913         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
914 
915         _transfer(from, to, tokenId);
916     }
917 
918     /**
919      * @dev See {IERC721-safeTransferFrom}.
920      */
921     function safeTransferFrom(
922         address from,
923         address to,
924         uint256 tokenId
925     ) public virtual override {
926         safeTransferFrom(from, to, tokenId, "");
927     }
928 
929     /**
930      * @dev See {IERC721-safeTransferFrom}.
931      */
932     function safeTransferFrom(
933         address from,
934         address to,
935         uint256 tokenId,
936         bytes memory _data
937     ) public virtual override {
938         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
939         _safeTransfer(from, to, tokenId, _data);
940     }
941 
942     /**
943      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
944      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
945      *
946      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
947      *
948      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
949      * implement alternative mechanisms to perform token transfer, such as signature-based.
950      *
951      * Requirements:
952      *
953      * - `from` cannot be the zero address.
954      * - `to` cannot be the zero address.
955      * - `tokenId` token must exist and be owned by `from`.
956      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
957      *
958      * Emits a {Transfer} event.
959      */
960     function _safeTransfer(
961         address from,
962         address to,
963         uint256 tokenId,
964         bytes memory _data
965     ) internal virtual {
966         _transfer(from, to, tokenId);
967         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
968     }
969 
970     /**
971      * @dev Returns whether `tokenId` exists.
972      *
973      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
974      *
975      * Tokens start existing when they are minted (`_mint`),
976      * and stop existing when they are burned (`_burn`).
977      */
978     function _exists(uint256 tokenId) internal view virtual returns (bool) {
979         return _owners[tokenId] != address(0);
980     }
981 
982     /**
983      * @dev Returns whether `spender` is allowed to manage `tokenId`.
984      *
985      * Requirements:
986      *
987      * - `tokenId` must exist.
988      */
989     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
990         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
991         address owner = ERC721.ownerOf(tokenId);
992         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
993     }
994 
995     /**
996      * @dev Safely mints `tokenId` and transfers it to `to`.
997      *
998      * Requirements:
999      *
1000      * - `tokenId` must not exist.
1001      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function _safeMint(address to, uint256 tokenId) internal virtual {
1006         _safeMint(to, tokenId, "");
1007     }
1008 
1009     /**
1010      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1011      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1012      */
1013     function _safeMint(
1014         address to,
1015         uint256 tokenId,
1016         bytes memory _data
1017     ) internal virtual {
1018         _mint(to, tokenId);
1019         require(
1020             _checkOnERC721Received(address(0), to, tokenId, _data),
1021             "ERC721: transfer to non ERC721Receiver implementer"
1022         );
1023     }
1024 
1025     /**
1026      * @dev Mints `tokenId` and transfers it to `to`.
1027      *
1028      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1029      *
1030      * Requirements:
1031      *
1032      * - `tokenId` must not exist.
1033      * - `to` cannot be the zero address.
1034      *
1035      * Emits a {Transfer} event.
1036      */
1037     function _mint(address to, uint256 tokenId) internal virtual {
1038         require(to != address(0), "ERC721: mint to the zero address");
1039         require(!_exists(tokenId), "ERC721: token already minted");
1040 
1041         _beforeTokenTransfer(address(0), to, tokenId);
1042 
1043         _balances[to] += 1;
1044         _owners[tokenId] = to;
1045 
1046         emit Transfer(address(0), to, tokenId);
1047     }
1048 
1049     /**
1050      * @dev Destroys `tokenId`.
1051      * The approval is cleared when the token is burned.
1052      *
1053      * Requirements:
1054      *
1055      * - `tokenId` must exist.
1056      *
1057      * Emits a {Transfer} event.
1058      */
1059     function _burn(uint256 tokenId) internal virtual {
1060         address owner = ERC721.ownerOf(tokenId);
1061 
1062         _beforeTokenTransfer(owner, address(0), tokenId);
1063 
1064         // Clear approvals
1065         _approve(address(0), tokenId);
1066 
1067         _balances[owner] -= 1;
1068         delete _owners[tokenId];
1069 
1070         emit Transfer(owner, address(0), tokenId);
1071     }
1072 
1073     /**
1074      * @dev Transfers `tokenId` from `from` to `to`.
1075      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1076      *
1077      * Requirements:
1078      *
1079      * - `to` cannot be the zero address.
1080      * - `tokenId` token must be owned by `from`.
1081      *
1082      * Emits a {Transfer} event.
1083      */
1084     function _transfer(
1085         address from,
1086         address to,
1087         uint256 tokenId
1088     ) internal virtual {
1089         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1090         require(to != address(0), "ERC721: transfer to the zero address");
1091 
1092         _beforeTokenTransfer(from, to, tokenId);
1093 
1094         // Clear approvals from the previous owner
1095         _approve(address(0), tokenId);
1096 
1097         _balances[from] -= 1;
1098         _balances[to] += 1;
1099         _owners[tokenId] = to;
1100 
1101         emit Transfer(from, to, tokenId);
1102     }
1103 
1104     /**
1105      * @dev Approve `to` to operate on `tokenId`
1106      *
1107      * Emits a {Approval} event.
1108      */
1109     function _approve(address to, uint256 tokenId) internal virtual {
1110         _tokenApprovals[tokenId] = to;
1111         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1112     }
1113 
1114     /**
1115      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1116      * The call is not executed if the target address is not a contract.
1117      *
1118      * @param from address representing the previous owner of the given token ID
1119      * @param to target address that will receive the tokens
1120      * @param tokenId uint256 ID of the token to be transferred
1121      * @param _data bytes optional data to send along with the call
1122      * @return bool whether the call correctly returned the expected magic value
1123      */
1124     function _checkOnERC721Received(
1125         address from,
1126         address to,
1127         uint256 tokenId,
1128         bytes memory _data
1129     ) private returns (bool) {
1130         if (to.isContract()) {
1131             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1132                 return retval == IERC721Receiver.onERC721Received.selector;
1133             } catch (bytes memory reason) {
1134                 if (reason.length == 0) {
1135                     revert("ERC721: transfer to non ERC721Receiver implementer");
1136                 } else {
1137                     assembly {
1138                         revert(add(32, reason), mload(reason))
1139                     }
1140                 }
1141             }
1142         } else {
1143             return true;
1144         }
1145     }
1146 
1147     /**
1148      * @dev Hook that is called before any token transfer. This includes minting
1149      * and burning.
1150      *
1151      * Calling conditions:
1152      *
1153      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1154      * transferred to `to`.
1155      * - When `from` is zero, `tokenId` will be minted for `to`.
1156      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1157      * - `from` and `to` are never both zero.
1158      *
1159      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1160      */
1161     function _beforeTokenTransfer(
1162         address from,
1163         address to,
1164         uint256 tokenId
1165     ) internal virtual {}
1166 }
1167 
1168 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1169 
1170 
1171 
1172 pragma solidity ^0.8.0;
1173 
1174 
1175 
1176 /**
1177  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1178  * enumerability of all the token ids in the contract as well as all token ids owned by each
1179  * account.
1180  */
1181 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1182     // Mapping from owner to list of owned token IDs
1183     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1184 
1185     // Mapping from token ID to index of the owner tokens list
1186     mapping(uint256 => uint256) private _ownedTokensIndex;
1187 
1188     // Array with all token ids, used for enumeration
1189     uint256[] private _allTokens;
1190 
1191     // Mapping from token id to position in the allTokens array
1192     mapping(uint256 => uint256) private _allTokensIndex;
1193 
1194     /**
1195      * @dev See {IERC165-supportsInterface}.
1196      */
1197     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1198         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1199     }
1200 
1201     /**
1202      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1203      */
1204     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1205         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1206         return _ownedTokens[owner][index];
1207     }
1208 
1209     /**
1210      * @dev See {IERC721Enumerable-totalSupply}.
1211      */
1212     function totalSupply() public view virtual override returns (uint256) {
1213         return _allTokens.length;
1214     }
1215 
1216     /**
1217      * @dev See {IERC721Enumerable-tokenByIndex}.
1218      */
1219     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1220         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1221         return _allTokens[index];
1222     }
1223 
1224     /**
1225      * @dev Hook that is called before any token transfer. This includes minting
1226      * and burning.
1227      *
1228      * Calling conditions:
1229      *
1230      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1231      * transferred to `to`.
1232      * - When `from` is zero, `tokenId` will be minted for `to`.
1233      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1234      * - `from` cannot be the zero address.
1235      * - `to` cannot be the zero address.
1236      *
1237      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1238      */
1239     function _beforeTokenTransfer(
1240         address from,
1241         address to,
1242         uint256 tokenId
1243     ) internal virtual override {
1244         super._beforeTokenTransfer(from, to, tokenId);
1245 
1246         if (from == address(0)) {
1247             _addTokenToAllTokensEnumeration(tokenId);
1248         } else if (from != to) {
1249             _removeTokenFromOwnerEnumeration(from, tokenId);
1250         }
1251         if (to == address(0)) {
1252             _removeTokenFromAllTokensEnumeration(tokenId);
1253         } else if (to != from) {
1254             _addTokenToOwnerEnumeration(to, tokenId);
1255         }
1256     }
1257 
1258     /**
1259      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1260      * @param to address representing the new owner of the given token ID
1261      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1262      */
1263     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1264         uint256 length = ERC721.balanceOf(to);
1265         _ownedTokens[to][length] = tokenId;
1266         _ownedTokensIndex[tokenId] = length;
1267     }
1268 
1269     /**
1270      * @dev Private function to add a token to this extension's token tracking data structures.
1271      * @param tokenId uint256 ID of the token to be added to the tokens list
1272      */
1273     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1274         _allTokensIndex[tokenId] = _allTokens.length;
1275         _allTokens.push(tokenId);
1276     }
1277 
1278     /**
1279      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1280      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1281      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1282      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1283      * @param from address representing the previous owner of the given token ID
1284      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1285      */
1286     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1287         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1288         // then delete the last slot (swap and pop).
1289 
1290         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1291         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1292 
1293         // When the token to delete is the last token, the swap operation is unnecessary
1294         if (tokenIndex != lastTokenIndex) {
1295             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1296 
1297             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1298             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1299         }
1300 
1301         // This also deletes the contents at the last position of the array
1302         delete _ownedTokensIndex[tokenId];
1303         delete _ownedTokens[from][lastTokenIndex];
1304     }
1305 
1306     /**
1307      * @dev Private function to remove a token from this extension's token tracking data structures.
1308      * This has O(1) time complexity, but alters the order of the _allTokens array.
1309      * @param tokenId uint256 ID of the token to be removed from the tokens list
1310      */
1311     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1312         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1313         // then delete the last slot (swap and pop).
1314 
1315         uint256 lastTokenIndex = _allTokens.length - 1;
1316         uint256 tokenIndex = _allTokensIndex[tokenId];
1317 
1318         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1319         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1320         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1321         uint256 lastTokenId = _allTokens[lastTokenIndex];
1322 
1323         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1324         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1325 
1326         // This also deletes the contents at the last position of the array
1327         delete _allTokensIndex[tokenId];
1328         _allTokens.pop();
1329     }
1330 }
1331 
1332 // File: contracts/infinity.sol
1333 
1334 pragma solidity >=0.7.0 <0.9.0;
1335 
1336 
1337 
1338 contract INFINITEGRID is ERC721Enumerable, Ownable {
1339   using Strings for uint256;
1340 
1341   string public baseURI;
1342   string public baseExtension = "";
1343   string public notRevealedUri;
1344   uint256 public cost = 0.09 ether;
1345   uint256 public maxSupply = 2525;
1346   uint256 public maxMintAmount = 25;
1347   uint256 public nftPerAddressLimit = 2;
1348   uint256 public nftForTeam = 25;
1349   bool public paused = true;
1350   bool public revealed = false;
1351   bool public onlyWhitelisted = true;
1352   address[] public whitelistedAddresses;
1353   mapping(address => uint256) public addressMintedBalance;
1354 
1355   constructor(
1356     string memory _name,
1357     string memory _symbol,
1358     string memory _initBaseURI,
1359     string memory _initNotRevealedUri
1360   ) ERC721(_name, _symbol) {
1361     setBaseURI(_initBaseURI);
1362     setNotRevealedURI(_initNotRevealedUri);
1363   }
1364 
1365   // internal
1366   function _baseURI() internal view virtual override returns (string memory) {
1367     return baseURI;
1368   }
1369 
1370   // public
1371   function mint(uint256 _mintAmount) public payable {
1372     require(!paused, "Infinite Grid is paused");
1373     uint256 supply = totalSupply();
1374     require(_mintAmount > 0, "You need to mint at least 1 Infinite Grid");
1375     require(_mintAmount <= maxMintAmount, "Max mint amount per session exceeded");
1376     require(supply + _mintAmount <= maxSupply, "Max NFT limit exceeded");
1377 
1378     if (msg.sender != owner()) {
1379         if(onlyWhitelisted == true) {
1380             require(isWhitelisted(msg.sender), "You are not whitelisted");
1381             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1382             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "Max NFT per address exceeded");
1383         }
1384         require(msg.value >= cost * _mintAmount, "Insufficient funds");
1385     }
1386     
1387     for (uint256 i = 1; i <= _mintAmount; i++) {
1388         addressMintedBalance[msg.sender]++;
1389       _safeMint(msg.sender, supply + i);
1390     }
1391   }
1392   
1393   function isWhitelisted(address _user) public view returns (bool) {
1394     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1395       if (whitelistedAddresses[i] == _user) {
1396           return true;
1397       }
1398     }
1399     return false;
1400   }
1401 
1402   function walletOfOwner(address _owner)
1403     public
1404     view
1405     returns (uint256[] memory)
1406   {
1407     uint256 ownerTokenCount = balanceOf(_owner);
1408     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1409     for (uint256 i; i < ownerTokenCount; i++) {
1410       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1411     }
1412     return tokenIds;
1413   }
1414 
1415   function tokenURI(uint256 tokenId)
1416     public
1417     view
1418     virtual
1419     override
1420     returns (string memory)
1421   {
1422     require(
1423       _exists(tokenId),
1424       "ERC721Metadata: URI query for nonexistent token"
1425     );
1426     
1427     if(revealed == false) {
1428         return notRevealedUri;
1429     }
1430 
1431     string memory currentBaseURI = _baseURI();
1432     return bytes(currentBaseURI).length > 0
1433         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1434         : "";
1435   }
1436 
1437   //only owner
1438   function reveal() public onlyOwner {
1439       revealed = true;
1440   }
1441 
1442   function mintTeam() public onlyOwner {
1443     uint256 supply = totalSupply();
1444     for (uint256 i = 1; i <= nftForTeam; i++) {
1445         addressMintedBalance[msg.sender]++;
1446         _safeMint(msg.sender, supply + i);
1447     }
1448   }
1449   
1450   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1451     nftPerAddressLimit = _limit;
1452   }
1453   
1454   function setCost(uint256 _newCost) public onlyOwner {
1455     cost = _newCost;
1456   }
1457 
1458   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1459     maxMintAmount = _newmaxMintAmount;
1460   }
1461 
1462   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1463     baseURI = _newBaseURI;
1464   }
1465 
1466   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1467     baseExtension = _newBaseExtension;
1468   }
1469   
1470   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1471     notRevealedUri = _notRevealedURI;
1472   }
1473 
1474   function pause(bool _state) public onlyOwner {
1475     paused = _state;
1476   }
1477   
1478   function setOnlyWhitelisted(bool _state) public onlyOwner {
1479     onlyWhitelisted = _state;
1480   }
1481   
1482   function whitelistUsers(address[] calldata _users) public onlyOwner {
1483     delete whitelistedAddresses;
1484     whitelistedAddresses = _users;
1485   }
1486  
1487   function withdraw() public payable onlyOwner {
1488     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1489     require(success);
1490   }
1491 }