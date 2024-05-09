1 // SPDX-License-Identifier: MIT
2 /*
3 
4  ███▄ ▄███▓ ██▓  ▄████  ██░ ██ ▄▄▄█████▓▓██   ██▓    ███▄ ▄███▓▓█████  ██▀███    █████▒▒█████   ██▓     ██ ▄█▀
5 ▓██▒▀█▀ ██▒▓██▒ ██▒ ▀█▒▓██░ ██▒▓  ██▒ ▓▒ ▒██  ██▒   ▓██▒▀█▀ ██▒▓█   ▀ ▓██ ▒ ██▒▓██   ▒▒██▒  ██▒▓██▒     ██▄█▒ 
6 ▓██    ▓██░▒██▒▒██░▄▄▄░▒██▀▀██░▒ ▓██░ ▒░  ▒██ ██░   ▓██    ▓██░▒███   ▓██ ░▄█ ▒▒████ ░▒██░  ██▒▒██░    ▓███▄░ 
7 ▒██    ▒██ ░██░░▓█  ██▓░▓█ ░██ ░ ▓██▓ ░   ░ ▐██▓░   ▒██    ▒██ ▒▓█  ▄ ▒██▀▀█▄  ░▓█▒  ░▒██   ██░▒██░    ▓██ █▄ 
8 ▒██▒   ░██▒░██░░▒▓███▀▒░▓█▒░██▓  ▒██▒ ░   ░ ██▒▓░   ▒██▒   ░██▒░▒████▒░██▓ ▒██▒░▒█░   ░ ████▓▒░░██████▒▒██▒ █▄
9 ░ ▒░   ░  ░░▓   ░▒   ▒  ▒ ░░▒░▒  ▒ ░░      ██▒▒▒    ░ ▒░   ░  ░░░ ▒░ ░░ ▒▓ ░▒▓░ ▒ ░   ░ ▒░▒░▒░ ░ ▒░▓  ░▒ ▒▒ ▓▒
10 ░  ░      ░ ▒ ░  ░   ░  ▒ ░▒░ ░    ░     ▓██ ░▒░    ░  ░      ░ ░ ░  ░  ░▒ ░ ▒░ ░       ░ ▒ ▒░ ░ ░ ▒  ░░ ░▒ ▒░
11 ░      ░    ▒ ░░ ░   ░  ░  ░░ ░  ░       ▒ ▒ ░░     ░      ░      ░     ░░   ░  ░ ░   ░ ░ ░ ▒    ░ ░   ░ ░░ ░ 
12        ░    ░        ░  ░  ░  ░          ░ ░               ░      ░  ░   ░                ░ ░      ░  ░░  ░   
13                                          ░ ░                                                                  
14 
15 
16 ⻏丫 ⼕尺丫尸〸ㄖ⼕尺丫丂
17 
18 Terms and Conditions:
19 
20 1.1. The seller of the Mighty Merfolk (MM) subject to this smart contract (“Seller”) undertakes to sell or transfer
21 the MM only on third party sites or platforms that support the sale of Ethereum-based
22 NFTs. 
23 
24 1.2. The Seller hereby provides to the buyer of the MM subject to this smart contract (“Buyer”):
25 - A membership to Mighty Merfolk Community
26 - Details of the amount and payment method of the royalty of 6.9% (excluding any gas fees
27 and the commission applied by the relevant platform or marketplace which shall be
28 additionally charged) received by Better.Together.Stronger LLC on all secondary sales.
29 
30 1.3. Buyer acquires or owns no intellectual property rights to the MM and/or any of the following exclusive benefits 
31 granted to MM owners.
32 
33 1.4. Buyer of the MM is granted an exclusive, limited license to the MM and to any
34 underlying assets and benefits linked to the MM, to use, display or store the MM and/or underlying assets solely
35 for   their   personal,   non-commercial,   non-promotional   purposes,   or   for   communicating
36 ownership, or for purposes of secondary sales via any other marketplace or platform. 
37 
38 1.5. Buyer cannot use the MM for any illegal or unauthorised purpose, including for any
39 unauthorised action as listed in Section 1.4.
40 
41 1.6. Buyer and Seller acknowledge and agree that any commercial or other exploitation in breach
42 of the terms of this smart contract and/or any additional terms may subject Buyer or Seller to claims of
43 intellectual property infringement. Better.Together.Stronger LLC reserves the right to terminate or
44 suspend without notice Seller's or Buyer's use or ownership of, or rights in, the MM in the
45 event of any breach of this smart contract or the Terms.
46 
47 1.7. Buyer acknowledges that Mighty Merfolk and Better.Together.Stronger LLC are not providing financial advice 
48 and that you are making the decision to copy our trades or use proprietary trading software on your own account. We take no responsibility 
49 for money made or lost as a result of our signals or advice on forex related products we offer.
50 DISCLAIMER: Mighty Merfolk and Better.Together.Stronger LLC and its team members are not registered as financial advisors 
51 and hold no formal qualifications to give financial advice. Everything that is provided within the community or affiliated communication channels 
52 are intermediates to personal investment strategies only. The source materials, any affiliate websites and/or its team members are purely for 
53 educational purposes only and its team members are not accountable or liable for any losses or damages. You are responsible for all the risks you take. 
54 Any content provided by Mighty Merfolk and/or Better.Together.Stronger LLC should not be construed as financial advice or a suggestion 
55 to buy or sell securities.
56 ---
57 
58 Developer: CryptoCrys
59 
60 */
61 // File: @openzeppelin/contracts/utils/Strings.sol
62 
63 
64 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
65 
66 pragma solidity ^0.8.0;
67 
68 /**
69  * @dev String operations.
70  */
71 library Strings {
72     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
73 
74     /**
75      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
76      */
77     function toString(uint256 value) internal pure returns (string memory) {
78         // Inspired by OraclizeAPI's implementation - MIT licence
79         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
80 
81         if (value == 0) {
82             return "0";
83         }
84         uint256 temp = value;
85         uint256 digits;
86         while (temp != 0) {
87             digits++;
88             temp /= 10;
89         }
90         bytes memory buffer = new bytes(digits);
91         while (value != 0) {
92             digits -= 1;
93             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
94             value /= 10;
95         }
96         return string(buffer);
97     }
98 
99     /**
100      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
101      */
102     function toHexString(uint256 value) internal pure returns (string memory) {
103         if (value == 0) {
104             return "0x00";
105         }
106         uint256 temp = value;
107         uint256 length = 0;
108         while (temp != 0) {
109             length++;
110             temp >>= 8;
111         }
112         return toHexString(value, length);
113     }
114 
115     /**
116      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
117      */
118     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
119         bytes memory buffer = new bytes(2 * length + 2);
120         buffer[0] = "0";
121         buffer[1] = "x";
122         for (uint256 i = 2 * length + 1; i > 1; --i) {
123             buffer[i] = _HEX_SYMBOLS[value & 0xf];
124             value >>= 4;
125         }
126         require(value == 0, "Strings: hex length insufficient");
127         return string(buffer);
128     }
129 }
130 
131 // File: @openzeppelin/contracts/utils/Context.sol
132 
133 
134 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
135 
136 pragma solidity ^0.8.0;
137 
138 /**
139  * @dev Provides information about the current execution context, including the
140  * sender of the transaction and its data. While these are generally available
141  * via msg.sender and msg.data, they should not be accessed in such a direct
142  * manner, since when dealing with meta-transactions the account sending and
143  * paying for execution may not be the actual sender (as far as an application
144  * is concerned).
145  *
146  * This contract is only required for intermediate, library-like contracts.
147  */
148 abstract contract Context {
149     function _msgSender() internal view virtual returns (address) {
150         return msg.sender;
151     }
152 
153     function _msgData() internal view virtual returns (bytes calldata) {
154         return msg.data;
155     }
156 }
157 
158 // File: @openzeppelin/contracts/security/Pausable.sol
159 
160 
161 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
162 
163 pragma solidity ^0.8.0;
164 
165 
166 /**
167  * @dev Contract module which allows children to implement an emergency stop
168  * mechanism that can be triggered by an authorized account.
169  *
170  * This module is used through inheritance. It will make available the
171  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
172  * the functions of your contract. Note that they will not be pausable by
173  * simply including this module, only once the modifiers are put in place.
174  */
175 abstract contract Pausable is Context {
176     /**
177      * @dev Emitted when the pause is triggered by `account`.
178      */
179     event Paused(address account);
180 
181     /**
182      * @dev Emitted when the pause is lifted by `account`.
183      */
184     event Unpaused(address account);
185 
186     bool private _paused;
187 
188     /**
189      * @dev Initializes the contract in unpaused state.
190      */
191     constructor() {
192         _paused = false;
193     }
194 
195     /**
196      * @dev Returns true if the contract is paused, and false otherwise.
197      */
198     function paused() public view virtual returns (bool) {
199         return _paused;
200     }
201 
202     /**
203      * @dev Modifier to make a function callable only when the contract is not paused.
204      *
205      * Requirements:
206      *
207      * - The contract must not be paused.
208      */
209     modifier whenNotPaused() {
210         require(!paused(), "Pausable: paused");
211         _;
212     }
213 
214     /**
215      * @dev Modifier to make a function callable only when the contract is paused.
216      *
217      * Requirements:
218      *
219      * - The contract must be paused.
220      */
221     modifier whenPaused() {
222         require(paused(), "Pausable: not paused");
223         _;
224     }
225 
226     /**
227      * @dev Triggers stopped state.
228      *
229      * Requirements:
230      *
231      * - The contract must not be paused.
232      */
233     function _pause() internal virtual whenNotPaused {
234         _paused = true;
235         emit Paused(_msgSender());
236     }
237 
238     /**
239      * @dev Returns to normal state.
240      *
241      * Requirements:
242      *
243      * - The contract must be paused.
244      */
245     function _unpause() internal virtual whenPaused {
246         _paused = false;
247         emit Unpaused(_msgSender());
248     }
249 }
250 
251 // File: @openzeppelin/contracts/access/Ownable.sol
252 
253 
254 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
255 
256 pragma solidity ^0.8.0;
257 
258 
259 /**
260  * @dev Contract module which provides a basic access control mechanism, where
261  * there is an account (an owner) that can be granted exclusive access to
262  * specific functions.
263  *
264  * By default, the owner account will be the one that deploys the contract. This
265  * can later be changed with {transferOwnership}.
266  *
267  * This module is used through inheritance. It will make available the modifier
268  * `onlyOwner`, which can be applied to your functions to restrict their use to
269  * the owner.
270  */
271 abstract contract Ownable is Context {
272     address private _owner;
273 
274     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
275 
276     /**
277      * @dev Initializes the contract setting the deployer as the initial owner.
278      */
279     constructor() {
280         _transferOwnership(_msgSender());
281     }
282 
283     /**
284      * @dev Returns the address of the current owner.
285      */
286     function owner() public view virtual returns (address) {
287         return _owner;
288     }
289 
290     /**
291      * @dev Throws if called by any account other than the owner.
292      */
293     modifier onlyOwner() {
294         require(owner() == _msgSender(), "Ownable: caller is not the owner");
295         _;
296     }
297 
298     /**
299      * @dev Leaves the contract without owner. It will not be possible to call
300      * `onlyOwner` functions anymore. Can only be called by the current owner.
301      *
302      * NOTE: Renouncing ownership will leave the contract without an owner,
303      * thereby removing any functionality that is only available to the owner.
304      */
305     function renounceOwnership() public virtual onlyOwner {
306         _transferOwnership(address(0));
307     }
308 
309     /**
310      * @dev Transfers ownership of the contract to a new account (`newOwner`).
311      * Can only be called by the current owner.
312      */
313     function transferOwnership(address newOwner) public virtual onlyOwner {
314         require(newOwner != address(0), "Ownable: new owner is the zero address");
315         _transferOwnership(newOwner);
316     }
317 
318     /**
319      * @dev Transfers ownership of the contract to a new account (`newOwner`).
320      * Internal function without access restriction.
321      */
322     function _transferOwnership(address newOwner) internal virtual {
323         address oldOwner = _owner;
324         _owner = newOwner;
325         emit OwnershipTransferred(oldOwner, newOwner);
326     }
327 }
328 
329 // File: @openzeppelin/contracts/utils/Address.sol
330 
331 
332 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
333 
334 pragma solidity ^0.8.1;
335 
336 /**
337  * @dev Collection of functions related to the address type
338  */
339 library Address {
340     /**
341      * @dev Returns true if `account` is a contract.
342      *
343      * [IMPORTANT]
344      * ====
345      * It is unsafe to assume that an address for which this function returns
346      * false is an externally-owned account (EOA) and not a contract.
347      *
348      * Among others, `isContract` will return false for the following
349      * types of addresses:
350      *
351      *  - an externally-owned account
352      *  - a contract in construction
353      *  - an address where a contract will be created
354      *  - an address where a contract lived, but was destroyed
355      * ====
356      *
357      * [IMPORTANT]
358      * ====
359      * You shouldn't rely on `isContract` to protect against flash loan attacks!
360      *
361      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
362      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
363      * constructor.
364      * ====
365      */
366     function isContract(address account) internal view returns (bool) {
367         // This method relies on extcodesize/address.code.length, which returns 0
368         // for contracts in construction, since the code is only stored at the end
369         // of the constructor execution.
370 
371         return account.code.length > 0;
372     }
373 
374     /**
375      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
376      * `recipient`, forwarding all available gas and reverting on errors.
377      *
378      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
379      * of certain opcodes, possibly making contracts go over the 2300 gas limit
380      * imposed by `transfer`, making them unable to receive funds via
381      * `transfer`. {sendValue} removes this limitation.
382      *
383      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
384      *
385      * IMPORTANT: because control is transferred to `recipient`, care must be
386      * taken to not create reentrancy vulnerabilities. Consider using
387      * {ReentrancyGuard} or the
388      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
389      */
390     function sendValue(address payable recipient, uint256 amount) internal {
391         require(address(this).balance >= amount, "Address: insufficient balance");
392 
393         (bool success, ) = recipient.call{value: amount}("");
394         require(success, "Address: unable to send value, recipient may have reverted");
395     }
396 
397     /**
398      * @dev Performs a Solidity function call using a low level `call`. A
399      * plain `call` is an unsafe replacement for a function call: use this
400      * function instead.
401      *
402      * If `target` reverts with a revert reason, it is bubbled up by this
403      * function (like regular Solidity function calls).
404      *
405      * Returns the raw returned data. To convert to the expected return value,
406      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
407      *
408      * Requirements:
409      *
410      * - `target` must be a contract.
411      * - calling `target` with `data` must not revert.
412      *
413      * _Available since v3.1._
414      */
415     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
416         return functionCall(target, data, "Address: low-level call failed");
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
421      * `errorMessage` as a fallback revert reason when `target` reverts.
422      *
423      * _Available since v3.1._
424      */
425     function functionCall(
426         address target,
427         bytes memory data,
428         string memory errorMessage
429     ) internal returns (bytes memory) {
430         return functionCallWithValue(target, data, 0, errorMessage);
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
435      * but also transferring `value` wei to `target`.
436      *
437      * Requirements:
438      *
439      * - the calling contract must have an ETH balance of at least `value`.
440      * - the called Solidity function must be `payable`.
441      *
442      * _Available since v3.1._
443      */
444     function functionCallWithValue(
445         address target,
446         bytes memory data,
447         uint256 value
448     ) internal returns (bytes memory) {
449         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
454      * with `errorMessage` as a fallback revert reason when `target` reverts.
455      *
456      * _Available since v3.1._
457      */
458     function functionCallWithValue(
459         address target,
460         bytes memory data,
461         uint256 value,
462         string memory errorMessage
463     ) internal returns (bytes memory) {
464         require(address(this).balance >= value, "Address: insufficient balance for call");
465         require(isContract(target), "Address: call to non-contract");
466 
467         (bool success, bytes memory returndata) = target.call{value: value}(data);
468         return verifyCallResult(success, returndata, errorMessage);
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
473      * but performing a static call.
474      *
475      * _Available since v3.3._
476      */
477     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
478         return functionStaticCall(target, data, "Address: low-level static call failed");
479     }
480 
481     /**
482      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
483      * but performing a static call.
484      *
485      * _Available since v3.3._
486      */
487     function functionStaticCall(
488         address target,
489         bytes memory data,
490         string memory errorMessage
491     ) internal view returns (bytes memory) {
492         require(isContract(target), "Address: static call to non-contract");
493 
494         (bool success, bytes memory returndata) = target.staticcall(data);
495         return verifyCallResult(success, returndata, errorMessage);
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
500      * but performing a delegate call.
501      *
502      * _Available since v3.4._
503      */
504     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
505         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
510      * but performing a delegate call.
511      *
512      * _Available since v3.4._
513      */
514     function functionDelegateCall(
515         address target,
516         bytes memory data,
517         string memory errorMessage
518     ) internal returns (bytes memory) {
519         require(isContract(target), "Address: delegate call to non-contract");
520 
521         (bool success, bytes memory returndata) = target.delegatecall(data);
522         return verifyCallResult(success, returndata, errorMessage);
523     }
524 
525     /**
526      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
527      * revert reason using the provided one.
528      *
529      * _Available since v4.3._
530      */
531     function verifyCallResult(
532         bool success,
533         bytes memory returndata,
534         string memory errorMessage
535     ) internal pure returns (bytes memory) {
536         if (success) {
537             return returndata;
538         } else {
539             // Look for revert reason and bubble it up if present
540             if (returndata.length > 0) {
541                 // The easiest way to bubble the revert reason is using memory via assembly
542 
543                 assembly {
544                     let returndata_size := mload(returndata)
545                     revert(add(32, returndata), returndata_size)
546                 }
547             } else {
548                 revert(errorMessage);
549             }
550         }
551     }
552 }
553 
554 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
555 
556 
557 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
558 
559 pragma solidity ^0.8.0;
560 
561 /**
562  * @title ERC721 token receiver interface
563  * @dev Interface for any contract that wants to support safeTransfers
564  * from ERC721 asset contracts.
565  */
566 interface IERC721Receiver {
567     /**
568      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
569      * by `operator` from `from`, this function is called.
570      *
571      * It must return its Solidity selector to confirm the token transfer.
572      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
573      *
574      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
575      */
576     function onERC721Received(
577         address operator,
578         address from,
579         uint256 tokenId,
580         bytes calldata data
581     ) external returns (bytes4);
582 }
583 
584 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
585 
586 
587 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
588 
589 pragma solidity ^0.8.0;
590 
591 /**
592  * @dev Interface of the ERC165 standard, as defined in the
593  * https://eips.ethereum.org/EIPS/eip-165[EIP].
594  *
595  * Implementers can declare support of contract interfaces, which can then be
596  * queried by others ({ERC165Checker}).
597  *
598  * For an implementation, see {ERC165}.
599  */
600 interface IERC165 {
601     /**
602      * @dev Returns true if this contract implements the interface defined by
603      * `interfaceId`. See the corresponding
604      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
605      * to learn more about how these ids are created.
606      *
607      * This function call must use less than 30 000 gas.
608      */
609     function supportsInterface(bytes4 interfaceId) external view returns (bool);
610 }
611 
612 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
613 
614 
615 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
616 
617 pragma solidity ^0.8.0;
618 
619 
620 /**
621  * @dev Implementation of the {IERC165} interface.
622  *
623  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
624  * for the additional interface id that will be supported. For example:
625  *
626  * ```solidity
627  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
628  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
629  * }
630  * ```
631  *
632  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
633  */
634 abstract contract ERC165 is IERC165 {
635     /**
636      * @dev See {IERC165-supportsInterface}.
637      */
638     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
639         return interfaceId == type(IERC165).interfaceId;
640     }
641 }
642 
643 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
644 
645 
646 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
647 
648 pragma solidity ^0.8.0;
649 
650 
651 /**
652  * @dev Required interface of an ERC721 compliant contract.
653  */
654 interface IERC721 is IERC165 {
655     /**
656      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
657      */
658     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
659 
660     /**
661      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
662      */
663     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
664 
665     /**
666      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
667      */
668     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
669 
670     /**
671      * @dev Returns the number of tokens in ``owner``'s account.
672      */
673     function balanceOf(address owner) external view returns (uint256 balance);
674 
675     /**
676      * @dev Returns the owner of the `tokenId` token.
677      *
678      * Requirements:
679      *
680      * - `tokenId` must exist.
681      */
682     function ownerOf(uint256 tokenId) external view returns (address owner);
683 
684     /**
685      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
686      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
687      *
688      * Requirements:
689      *
690      * - `from` cannot be the zero address.
691      * - `to` cannot be the zero address.
692      * - `tokenId` token must exist and be owned by `from`.
693      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
694      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
695      *
696      * Emits a {Transfer} event.
697      */
698     function safeTransferFrom(
699         address from,
700         address to,
701         uint256 tokenId
702     ) external;
703 
704     /**
705      * @dev Transfers `tokenId` token from `from` to `to`.
706      *
707      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
708      *
709      * Requirements:
710      *
711      * - `from` cannot be the zero address.
712      * - `to` cannot be the zero address.
713      * - `tokenId` token must be owned by `from`.
714      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
715      *
716      * Emits a {Transfer} event.
717      */
718     function transferFrom(
719         address from,
720         address to,
721         uint256 tokenId
722     ) external;
723 
724     /**
725      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
726      * The approval is cleared when the token is transferred.
727      *
728      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
729      *
730      * Requirements:
731      *
732      * - The caller must own the token or be an approved operator.
733      * - `tokenId` must exist.
734      *
735      * Emits an {Approval} event.
736      */
737     function approve(address to, uint256 tokenId) external;
738 
739     /**
740      * @dev Returns the account approved for `tokenId` token.
741      *
742      * Requirements:
743      *
744      * - `tokenId` must exist.
745      */
746     function getApproved(uint256 tokenId) external view returns (address operator);
747 
748     /**
749      * @dev Approve or remove `operator` as an operator for the caller.
750      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
751      *
752      * Requirements:
753      *
754      * - The `operator` cannot be the caller.
755      *
756      * Emits an {ApprovalForAll} event.
757      */
758     function setApprovalForAll(address operator, bool _approved) external;
759 
760     /**
761      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
762      *
763      * See {setApprovalForAll}
764      */
765     function isApprovedForAll(address owner, address operator) external view returns (bool);
766 
767     /**
768      * @dev Safely transfers `tokenId` token from `from` to `to`.
769      *
770      * Requirements:
771      *
772      * - `from` cannot be the zero address.
773      * - `to` cannot be the zero address.
774      * - `tokenId` token must exist and be owned by `from`.
775      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
776      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
777      *
778      * Emits a {Transfer} event.
779      */
780     function safeTransferFrom(
781         address from,
782         address to,
783         uint256 tokenId,
784         bytes calldata data
785     ) external;
786 }
787 
788 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
789 
790 
791 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
792 
793 pragma solidity ^0.8.0;
794 
795 
796 /**
797  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
798  * @dev See https://eips.ethereum.org/EIPS/eip-721
799  */
800 interface IERC721Enumerable is IERC721 {
801     /**
802      * @dev Returns the total amount of tokens stored by the contract.
803      */
804     function totalSupply() external view returns (uint256);
805 
806     /**
807      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
808      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
809      */
810     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
811 
812     /**
813      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
814      * Use along with {totalSupply} to enumerate all tokens.
815      */
816     function tokenByIndex(uint256 index) external view returns (uint256);
817 }
818 
819 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
820 
821 
822 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
823 
824 pragma solidity ^0.8.0;
825 
826 
827 /**
828  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
829  * @dev See https://eips.ethereum.org/EIPS/eip-721
830  */
831 interface IERC721Metadata is IERC721 {
832     /**
833      * @dev Returns the token collection name.
834      */
835     function name() external view returns (string memory);
836 
837     /**
838      * @dev Returns the token collection symbol.
839      */
840     function symbol() external view returns (string memory);
841 
842     /**
843      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
844      */
845     function tokenURI(uint256 tokenId) external view returns (string memory);
846 }
847 
848 // File: contracts/ERC721A.sol
849 
850 
851 // Creator: Chiru Labs
852 
853 pragma solidity ^0.8.4;
854 
855 
856 
857 
858 
859 
860 
861 
862 
863 error ApprovalCallerNotOwnerNorApproved();
864 error ApprovalQueryForNonexistentToken();
865 error ApproveToCaller();
866 error ApprovalToCurrentOwner();
867 error BalanceQueryForZeroAddress();
868 error MintedQueryForZeroAddress();
869 error BurnedQueryForZeroAddress();
870 error MintToZeroAddress();
871 error MintZeroQuantity();
872 error OwnerIndexOutOfBounds();
873 error OwnerQueryForNonexistentToken();
874 error TokenIndexOutOfBounds();
875 error TransferCallerNotOwnerNorApproved();
876 error TransferFromIncorrectOwner();
877 error TransferToNonERC721ReceiverImplementer();
878 error TransferToZeroAddress();
879 error URIQueryForNonexistentToken();
880 
881 /**
882  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
883  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
884  *
885  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
886  *
887  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
888  *
889  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
890  */
891 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
892     using Address for address;
893     using Strings for uint256;
894 
895     // Compiler will pack this into a single 256bit word.
896     struct TokenOwnership {
897         // The address of the owner.
898         address addr;
899         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
900         uint64 startTimestamp;
901         // Whether the token has been burned.
902         bool burned;
903     }
904 
905     // Compiler will pack this into a single 256bit word.
906     struct AddressData {
907         // Realistically, 2**64-1 is more than enough.
908         uint64 balance;
909         // Keeps track of mint count with minimal overhead for tokenomics.
910         uint64 numberMinted;
911         // Keeps track of burn count with minimal overhead for tokenomics.
912         uint64 numberBurned;
913     }
914 
915     // Compiler will pack the following 
916     // _currentIndex and _burnCounter into a single 256bit word.
917     
918     // The tokenId of the next token to be minted.
919     uint128 internal _currentIndex;
920 
921     // The number of tokens burned.
922     uint128 internal _burnCounter;
923 
924     // Token name
925     string private _name;
926 
927     // Token symbol
928     string private _symbol;
929 
930     // Mapping from token ID to ownership details
931     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
932     mapping(uint256 => TokenOwnership) internal _ownerships;
933 
934     // Mapping owner address to address data
935     mapping(address => AddressData) private _addressData;
936 
937     // Mapping from token ID to approved address
938     mapping(uint256 => address) private _tokenApprovals;
939 
940     // Mapping from owner to operator approvals
941     mapping(address => mapping(address => bool)) private _operatorApprovals;
942 
943     constructor(string memory name_, string memory symbol_) {
944         _name = name_;
945         _symbol = symbol_;
946     }
947 
948     /**
949      * @dev See {IERC721Enumerable-totalSupply}.
950      */
951     function totalSupply() public view override returns (uint256) {
952         // Counter underflow is impossible as _burnCounter cannot be incremented
953         // more than _currentIndex times
954         unchecked {
955             return _currentIndex - _burnCounter;    
956         }
957     }
958 
959     /**
960      * @dev See {IERC721Enumerable-tokenByIndex}.
961      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
962      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
963      */
964     function tokenByIndex(uint256 index) public view override returns (uint256) {
965         uint256 numMintedSoFar = _currentIndex;
966         uint256 tokenIdsIdx;
967 
968         // Counter overflow is impossible as the loop breaks when
969         // uint256 i is equal to another uint256 numMintedSoFar.
970         unchecked {
971             for (uint256 i; i < numMintedSoFar; i++) {
972                 TokenOwnership memory ownership = _ownerships[i];
973                 if (!ownership.burned) {
974                     if (tokenIdsIdx == index) {
975                         return i;
976                     }
977                     tokenIdsIdx++;
978                 }
979             }
980         }
981         revert TokenIndexOutOfBounds();
982     }
983 
984     /**
985      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
986      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
987      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
988      */
989     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
990         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
991         uint256 numMintedSoFar = _currentIndex;
992         uint256 tokenIdsIdx;
993         address currOwnershipAddr;
994 
995         // Counter overflow is impossible as the loop breaks when
996         // uint256 i is equal to another uint256 numMintedSoFar.
997         unchecked {
998             for (uint256 i; i < numMintedSoFar; i++) {
999                 TokenOwnership memory ownership = _ownerships[i];
1000                 if (ownership.burned) {
1001                     continue;
1002                 }
1003                 if (ownership.addr != address(0)) {
1004                     currOwnershipAddr = ownership.addr;
1005                 }
1006                 if (currOwnershipAddr == owner) {
1007                     if (tokenIdsIdx == index) {
1008                         return i;
1009                     }
1010                     tokenIdsIdx++;
1011                 }
1012             }
1013         }
1014 
1015         // Execution should never reach this point.
1016         revert();
1017     }
1018 
1019     /**
1020      * @dev See {IERC165-supportsInterface}.
1021      */
1022     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1023         return
1024             interfaceId == type(IERC721).interfaceId ||
1025             interfaceId == type(IERC721Metadata).interfaceId ||
1026             interfaceId == type(IERC721Enumerable).interfaceId ||
1027             super.supportsInterface(interfaceId);
1028     }
1029 
1030     /**
1031      * @dev See {IERC721-balanceOf}.
1032      */
1033     function balanceOf(address owner) public view override returns (uint256) {
1034         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1035         return uint256(_addressData[owner].balance);
1036     }
1037 
1038     function _numberMinted(address owner) internal view returns (uint256) {
1039         if (owner == address(0)) revert MintedQueryForZeroAddress();
1040         return uint256(_addressData[owner].numberMinted);
1041     }
1042 
1043     function _numberBurned(address owner) internal view returns (uint256) {
1044         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1045         return uint256(_addressData[owner].numberBurned);
1046     }
1047 
1048     /**
1049      * Gas spent here starts off proportional to the maximum mint batch size.
1050      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1051      */
1052     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1053         uint256 curr = tokenId;
1054 
1055         unchecked {
1056             if (curr < _currentIndex) {
1057                 TokenOwnership memory ownership = _ownerships[curr];
1058                 if (!ownership.burned) {
1059                     if (ownership.addr != address(0)) {
1060                         return ownership;
1061                     }
1062                     // Invariant: 
1063                     // There will always be an ownership that has an address and is not burned 
1064                     // before an ownership that does not have an address and is not burned.
1065                     // Hence, curr will not underflow.
1066                     while (true) {
1067                         curr--;
1068                         ownership = _ownerships[curr];
1069                         if (ownership.addr != address(0)) {
1070                             return ownership;
1071                         }
1072                     }
1073                 }
1074             }
1075         }
1076         revert OwnerQueryForNonexistentToken();
1077     }
1078 
1079     /**
1080      * @dev See {IERC721-ownerOf}.
1081      */
1082     function ownerOf(uint256 tokenId) public view override returns (address) {
1083         return ownershipOf(tokenId).addr;
1084     }
1085 
1086     /**
1087      * @dev See {IERC721Metadata-name}.
1088      */
1089     function name() public view virtual override returns (string memory) {
1090         return _name;
1091     }
1092 
1093     /**
1094      * @dev See {IERC721Metadata-symbol}.
1095      */
1096     function symbol() public view virtual override returns (string memory) {
1097         return _symbol;
1098     }
1099 
1100     /**
1101      * @dev See {IERC721Metadata-tokenURI}.
1102      */
1103     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1104         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1105 
1106         string memory baseURI = _baseURI();
1107         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1108     }
1109 
1110     /**
1111      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1112      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1113      * by default, can be overriden in child contracts.
1114      */
1115     function _baseURI() internal view virtual returns (string memory) {
1116         return '';
1117     }
1118 
1119     /**
1120      * @dev See {IERC721-approve}.
1121      */
1122     function approve(address to, uint256 tokenId) public override {
1123         address owner = ERC721A.ownerOf(tokenId);
1124         if (to == owner) revert ApprovalToCurrentOwner();
1125 
1126         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1127             revert ApprovalCallerNotOwnerNorApproved();
1128         }
1129 
1130         _approve(to, tokenId, owner);
1131     }
1132 
1133     /**
1134      * @dev See {IERC721-getApproved}.
1135      */
1136     function getApproved(uint256 tokenId) public view override returns (address) {
1137         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1138 
1139         return _tokenApprovals[tokenId];
1140     }
1141 
1142     /**
1143      * @dev See {IERC721-setApprovalForAll}.
1144      */
1145     function setApprovalForAll(address operator, bool approved) public override {
1146         if (operator == _msgSender()) revert ApproveToCaller();
1147 
1148         _operatorApprovals[_msgSender()][operator] = approved;
1149         emit ApprovalForAll(_msgSender(), operator, approved);
1150     }
1151 
1152     /**
1153      * @dev See {IERC721-isApprovedForAll}.
1154      */
1155     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1156         return _operatorApprovals[owner][operator];
1157     }
1158 
1159     /**
1160      * @dev See {IERC721-transferFrom}.
1161      */
1162     function transferFrom(
1163         address from,
1164         address to,
1165         uint256 tokenId
1166     ) public virtual override {
1167         _transfer(from, to, tokenId);
1168     }
1169 
1170     /**
1171      * @dev See {IERC721-safeTransferFrom}.
1172      */
1173     function safeTransferFrom(
1174         address from,
1175         address to,
1176         uint256 tokenId
1177     ) public virtual override {
1178         safeTransferFrom(from, to, tokenId, '');
1179     }
1180 
1181     /**
1182      * @dev See {IERC721-safeTransferFrom}.
1183      */
1184     function safeTransferFrom(
1185         address from,
1186         address to,
1187         uint256 tokenId,
1188         bytes memory _data
1189     ) public virtual override {
1190         _transfer(from, to, tokenId);
1191         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1192             revert TransferToNonERC721ReceiverImplementer();
1193         }
1194     }
1195 
1196     /**
1197      * @dev Returns whether `tokenId` exists.
1198      *
1199      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1200      *
1201      * Tokens start existing when they are minted (`_mint`),
1202      */
1203     function _exists(uint256 tokenId) internal view returns (bool) {
1204         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1205     }
1206 
1207     function _safeMint(address to, uint256 quantity) internal {
1208         _safeMint(to, quantity, '');
1209     }
1210 
1211     /**
1212      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1213      *
1214      * Requirements:
1215      *
1216      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1217      * - `quantity` must be greater than 0.
1218      *
1219      * Emits a {Transfer} event.
1220      */
1221     function _safeMint(
1222         address to,
1223         uint256 quantity,
1224         bytes memory _data
1225     ) internal {
1226         _mint(to, quantity, _data, true);
1227     }
1228 
1229     /**
1230      * @dev Mints `quantity` tokens and transfers them to `to`.
1231      *
1232      * Requirements:
1233      *
1234      * - `to` cannot be the zero address.
1235      * - `quantity` must be greater than 0.
1236      *
1237      * Emits a {Transfer} event.
1238      */
1239     function _mint(
1240         address to,
1241         uint256 quantity,
1242         bytes memory _data,
1243         bool safe
1244     ) internal {
1245         uint256 startTokenId = _currentIndex;
1246         if (to == address(0)) revert MintToZeroAddress();
1247         if (quantity == 0) revert MintZeroQuantity();
1248 
1249         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1250 
1251         // Overflows are incredibly unrealistic.
1252         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1253         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1254         unchecked {
1255             _addressData[to].balance += uint64(quantity);
1256             _addressData[to].numberMinted += uint64(quantity);
1257 
1258             _ownerships[startTokenId].addr = to;
1259             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1260 
1261             uint256 updatedIndex = startTokenId;
1262 
1263             for (uint256 i; i < quantity; i++) {
1264                 emit Transfer(address(0), to, updatedIndex);
1265                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1266                     revert TransferToNonERC721ReceiverImplementer();
1267                 }
1268                 updatedIndex++;
1269             }
1270 
1271             _currentIndex = uint128(updatedIndex);
1272         }
1273         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1274     }
1275 
1276     /**
1277      * @dev Transfers `tokenId` from `from` to `to`.
1278      *
1279      * Requirements:
1280      *
1281      * - `to` cannot be the zero address.
1282      * - `tokenId` token must be owned by `from`.
1283      *
1284      * Emits a {Transfer} event.
1285      */
1286     function _transfer(
1287         address from,
1288         address to,
1289         uint256 tokenId
1290     ) private {
1291         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1292 
1293         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1294             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1295             getApproved(tokenId) == _msgSender());
1296 
1297         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1298         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1299         if (to == address(0)) revert TransferToZeroAddress();
1300 
1301         _beforeTokenTransfers(from, to, tokenId, 1);
1302 
1303         // Clear approvals from the previous owner
1304         _approve(address(0), tokenId, prevOwnership.addr);
1305 
1306         // Underflow of the sender's balance is impossible because we check for
1307         // ownership above and the recipient's balance can't realistically overflow.
1308         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1309         unchecked {
1310             _addressData[from].balance -= 1;
1311             _addressData[to].balance += 1;
1312 
1313             _ownerships[tokenId].addr = to;
1314             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1315 
1316             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1317             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1318             uint256 nextTokenId = tokenId + 1;
1319             if (_ownerships[nextTokenId].addr == address(0)) {
1320                 // This will suffice for checking _exists(nextTokenId),
1321                 // as a burned slot cannot contain the zero address.
1322                 if (nextTokenId < _currentIndex) {
1323                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1324                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1325                 }
1326             }
1327         }
1328 
1329         emit Transfer(from, to, tokenId);
1330         _afterTokenTransfers(from, to, tokenId, 1);
1331     }
1332 
1333     /**
1334      * @dev Destroys `tokenId`.
1335      * The approval is cleared when the token is burned.
1336      *
1337      * Requirements:
1338      *
1339      * - `tokenId` must exist.
1340      *
1341      * Emits a {Transfer} event.
1342      */
1343     function _burn(uint256 tokenId) internal virtual {
1344         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1345 
1346         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1347 
1348         // Clear approvals from the previous owner
1349         _approve(address(0), tokenId, prevOwnership.addr);
1350 
1351         // Underflow of the sender's balance is impossible because we check for
1352         // ownership above and the recipient's balance can't realistically overflow.
1353         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1354         unchecked {
1355             _addressData[prevOwnership.addr].balance -= 1;
1356             _addressData[prevOwnership.addr].numberBurned += 1;
1357 
1358             // Keep track of who burned the token, and the timestamp of burning.
1359             _ownerships[tokenId].addr = prevOwnership.addr;
1360             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1361             _ownerships[tokenId].burned = true;
1362 
1363             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1364             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1365             uint256 nextTokenId = tokenId + 1;
1366             if (_ownerships[nextTokenId].addr == address(0)) {
1367                 // This will suffice for checking _exists(nextTokenId),
1368                 // as a burned slot cannot contain the zero address.
1369                 if (nextTokenId < _currentIndex) {
1370                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1371                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1372                 }
1373             }
1374         }
1375 
1376         emit Transfer(prevOwnership.addr, address(0), tokenId);
1377         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1378 
1379         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1380         unchecked { 
1381             _burnCounter++;
1382         }
1383     }
1384 
1385     /**
1386      * @dev Approve `to` to operate on `tokenId`
1387      *
1388      * Emits a {Approval} event.
1389      */
1390     function _approve(
1391         address to,
1392         uint256 tokenId,
1393         address owner
1394     ) private {
1395         _tokenApprovals[tokenId] = to;
1396         emit Approval(owner, to, tokenId);
1397     }
1398 
1399     /**
1400      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1401      * The call is not executed if the target address is not a contract.
1402      *
1403      * @param from address representing the previous owner of the given token ID
1404      * @param to target address that will receive the tokens
1405      * @param tokenId uint256 ID of the token to be transferred
1406      * @param _data bytes optional data to send along with the call
1407      * @return bool whether the call correctly returned the expected magic value
1408      */
1409     function _checkOnERC721Received(
1410         address from,
1411         address to,
1412         uint256 tokenId,
1413         bytes memory _data
1414     ) private returns (bool) {
1415         if (to.isContract()) {
1416             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1417                 return retval == IERC721Receiver(to).onERC721Received.selector;
1418             } catch (bytes memory reason) {
1419                 if (reason.length == 0) {
1420                     revert TransferToNonERC721ReceiverImplementer();
1421                 } else {
1422                     assembly {
1423                         revert(add(32, reason), mload(reason))
1424                     }
1425                 }
1426             }
1427         } else {
1428             return true;
1429         }
1430     }
1431 
1432     /**
1433      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1434      * And also called before burning one token.
1435      *
1436      * startTokenId - the first token id to be transferred
1437      * quantity - the amount to be transferred
1438      *
1439      * Calling conditions:
1440      *
1441      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1442      * transferred to `to`.
1443      * - When `from` is zero, `tokenId` will be minted for `to`.
1444      * - When `to` is zero, `tokenId` will be burned by `from`.
1445      * - `from` and `to` are never both zero.
1446      */
1447     function _beforeTokenTransfers(
1448         address from,
1449         address to,
1450         uint256 startTokenId,
1451         uint256 quantity
1452     ) internal virtual {}
1453 
1454     /**
1455      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1456      * minting.
1457      * And also called after one token has been burned.
1458      *
1459      * startTokenId - the first token id to be transferred
1460      * quantity - the amount to be transferred
1461      *
1462      * Calling conditions:
1463      *
1464      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1465      * transferred to `to`.
1466      * - When `from` is zero, `tokenId` has been minted for `to`.
1467      * - When `to` is zero, `tokenId` has been burned by `from`.
1468      * - `from` and `to` are never both zero.
1469      */
1470     function _afterTokenTransfers(
1471         address from,
1472         address to,
1473         uint256 startTokenId,
1474         uint256 quantity
1475     ) internal virtual {}
1476 }
1477 // File: contracts/mm.sol
1478 
1479 
1480 
1481 pragma solidity ^0.8.0;
1482 
1483 
1484 contract MightyMerfolk is ERC721A, Ownable, Pausable {
1485     using Strings for uint256;
1486 
1487     string public baseURI;
1488     string public baseExtension = ".json";
1489     string public notRevealedUri;
1490     bool public revealed = true;
1491 
1492 
1493     uint256 public mint1price = 0.0269 ether;
1494     uint256 public constant maxSupply = 4469;
1495     uint256 public maxMintAmount = 10;
1496     uint256 public nftPerAddressLimit = 10;
1497     bool public onlyWhitelisted = true;
1498     address[] public whitelistedAddresses;
1499     mapping(address => uint256) public addressMintedBalance;
1500 
1501     constructor(
1502         string memory _name,
1503         string memory _symbol,
1504         string memory _initBaseURI,
1505         string memory _initNotRevealedUri
1506       ) ERC721A(_name, _symbol) {
1507             setBaseURI(_initBaseURI);
1508             setNotRevealedURI(_initNotRevealedUri);
1509     }
1510 
1511   // internal
1512     function _baseURI() internal view virtual override returns (string memory) {
1513         return baseURI;
1514     }
1515 
1516     function mint(uint256 _mintAmount) public payable whenNotPaused {
1517         //require(mint1price * _mintAmount <= msg.value, "LOW_ETHER");
1518         require(_mintAmount <= maxMintAmount, "Max mint amount per session exceeded");
1519         unchecked { require(totalSupply() + _mintAmount <= maxSupply, "MAX_REACHED"); }
1520         if (msg.sender != owner()) {
1521             if(onlyWhitelisted == true) {
1522                 require(isWhitelisted(msg.sender), "User is not whitelisted");
1523                 uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1524                 require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "Max NFT per address exceeded");
1525         }
1526         require(msg.value >= mint1price * _mintAmount, "Insufficient funds");
1527     }
1528         
1529         _safeMint(msg.sender, _mintAmount);
1530     }
1531 
1532 // Whitelist functions
1533 
1534     function isWhitelisted(address _user) public view returns (bool) {
1535         for (uint i = 0; i < whitelistedAddresses.length; i++) {
1536             if (whitelistedAddresses[i] == _user) {
1537                 return true;
1538             }
1539         }
1540         return false;
1541         }
1542 
1543     function setOnlyWhitelisted(bool _state) public onlyOwner {
1544         onlyWhitelisted = _state;
1545     }
1546   
1547     function whitelistUsers(address[] calldata _users) public onlyOwner {
1548         delete whitelistedAddresses;
1549         whitelistedAddresses = _users;
1550     }
1551 
1552     // Mints for promotional purposes and early investors in the project
1553     function promoMint() public onlyOwner {
1554         unchecked { require(totalSupply() == 0, "PROMO_RUN"); }
1555         _unpause();
1556 
1557         _safeMint(0x0030F6eE90660967788D9442871Cc549DdF6484a, 20);
1558     }
1559 
1560     function setPrice(uint256 newPrice) public onlyOwner {
1561         mint1price = newPrice;
1562     }
1563 
1564 
1565     function withdraw() external onlyOwner {
1566         uint256 currentBalance = address(this).balance;
1567         payable(0x37615BeaBcec9f81D424E0cC075d1b6afE764232).transfer((currentBalance * 30) / 100);
1568         payable(0x63Ec88cD13DABcACF4c33AF038A76bD12eaFBC91).transfer((currentBalance * 30) / 100);
1569         payable(0x0030F6eE90660967788D9442871Cc549DdF6484a).transfer(address(this).balance);
1570     }
1571     
1572     function tokenURI(uint256 tokenId)
1573         public
1574         view
1575         virtual
1576         override
1577         returns (string memory)
1578     {
1579         require(
1580         _exists(tokenId),
1581         "ERC721Metadata: URI query for nonexistent token"
1582         );
1583     
1584         if(revealed == false) {
1585             return notRevealedUri;
1586     }
1587 
1588         string memory currentBaseURI = _baseURI();
1589         return bytes(currentBaseURI).length > 0
1590             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1591             : "";
1592     }
1593 
1594     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1595         baseURI = _newBaseURI;
1596     }
1597 
1598     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1599         baseExtension = _newBaseExtension;
1600     }
1601   
1602     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1603         notRevealedUri = _notRevealedURI;
1604     }
1605 
1606     //function _baseURI() internal pure override returns (string memory) {
1607     //    return baseURI;
1608     //}
1609 
1610     function reveal() public onlyOwner {
1611       revealed = true;
1612     }
1613     function pause() public onlyOwner {
1614         _pause();
1615     }
1616 
1617     function unpause() public onlyOwner {
1618         _unpause();
1619     }
1620 }