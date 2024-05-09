1 // SPDX-License-Identifier: MIT
2 // File: contracts/Signer.sol
3 
4 
5 pragma solidity ^0.8.3;
6 
7 /* Signature Verification
8 
9 How to Sign and Verify
10 # Signing
11 1. Create message to sign
12 2. Hash the message
13 3. Sign the hash (off chain, keep your private key secret)
14 
15 # Verify
16 1. Recreate hash from the original message
17 2. Recover signer from signature and hash
18 3. Compare recovered signer to claimed signer
19 */
20 
21 library VerifySignature {
22     /* 1. Unlock MetaMask account
23     ethereum.enable()
24     */
25 
26     /* 2. Get message hash to sign
27     getMessageHash(
28         0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C,
29         123,
30         "coffee and donuts",
31         1
32     )
33 
34     hash = "0xcf36ac4f97dc10d91fc2cbb20d718e94a8cbfe0f82eaedc6a4aa38946fb797cd"
35     */
36     function getMessageHash(
37         address _minter,
38         uint _quantity,
39         uint _nonce
40     ) public pure returns (bytes32) {
41         return keccak256(abi.encodePacked(_minter, _quantity, _nonce));
42     }
43 
44     /* 3. Sign message hash
45     # using browser
46     account = "copy paste account of signer here"
47     ethereum.request({ method: "personal_sign", params: [account, hash]}).then(console.log)
48 
49     # using web3
50     web3.personal.sign(hash, web3.eth.defaultAccount, console.log)
51 
52     Signature will be different for different accounts
53     0x993dab3dd91f5c6dc28e17439be475478f5635c92a56e17e82349d3fb2f166196f466c0b4e0c146f285204f0dcb13e5ae67bc33f4b888ec32dfe0a063e8f3f781b
54     */
55     function getEthSignedMessageHash(bytes32 _messageHash)
56         public
57         pure
58         returns (bytes32)
59     {
60         /*
61         Signature is produced by signing a keccak256 hash with the following format:
62         "\x19Ethereum Signed Message\n" + len(msg) + msg
63         */
64         return
65             keccak256(
66                 abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash)
67             );
68     }
69 
70     /* 4. Verify signature
71     signer = 0xB273216C05A8c0D4F0a4Dd0d7Bae1D2EfFE636dd
72     to = 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C
73     amount = 123
74     message = "coffee and donuts"
75     nonce = 1
76     signature =
77         0x993dab3dd91f5c6dc28e17439be475478f5635c92a56e17e82349d3fb2f166196f466c0b4e0c146f285204f0dcb13e5ae67bc33f4b888ec32dfe0a063e8f3f781b
78     */
79     function verify(
80         address _signer,
81         address _minter,
82         uint _quantity,
83         uint _nonce,
84         bytes memory signature
85     ) public pure returns (bool) {
86         bytes32 messageHash = getMessageHash(_minter, _quantity, _nonce);
87         bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
88 
89         return recoverSigner(ethSignedMessageHash, signature) == _signer;
90     }
91 
92     function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature)
93         public
94         pure
95         returns (address)
96     {
97         (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
98 
99         return ecrecover(_ethSignedMessageHash, v, r, s);
100     }
101 
102     function splitSignature(bytes memory sig)
103         public
104         pure
105         returns (
106             bytes32 r,
107             bytes32 s,
108             uint8 v
109         )
110     {
111         require(sig.length == 65, "invalid signature length");
112 
113         assembly {
114             /*
115             First 32 bytes stores the length of the signature
116 
117             add(sig, 32) = pointer of sig + 32
118             effectively, skips first 32 bytes of signature
119 
120             mload(p) loads next 32 bytes starting at the memory address p into memory
121             */
122 
123             // first 32 bytes, after the length prefix
124             r := mload(add(sig, 32))
125             // second 32 bytes
126             s := mload(add(sig, 64))
127             // final byte (first byte of the next 32 bytes)
128             v := byte(0, mload(add(sig, 96)))
129         }
130 
131         // implicitly return (r, s, v)
132     }
133 }
134 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
135 
136 
137 
138 pragma solidity ^0.8.0;
139 
140 /**
141  * @dev Contract module that helps prevent reentrant calls to a function.
142  *
143  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
144  * available, which can be applied to functions to make sure there are no nested
145  * (reentrant) calls to them.
146  *
147  * Note that because there is a single `nonReentrant` guard, functions marked as
148  * `nonReentrant` may not call one another. This can be worked around by making
149  * those functions `private`, and then adding `external` `nonReentrant` entry
150  * points to them.
151  *
152  * TIP: If you would like to learn more about reentrancy and alternative ways
153  * to protect against it, check out our blog post
154  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
155  */
156 abstract contract ReentrancyGuard {
157     // Booleans are more expensive than uint256 or any type that takes up a full
158     // word because each write operation emits an extra SLOAD to first read the
159     // slot's contents, replace the bits taken up by the boolean, and then write
160     // back. This is the compiler's defense against contract upgrades and
161     // pointer aliasing, and it cannot be disabled.
162 
163     // The values being non-zero value makes deployment a bit more expensive,
164     // but in exchange the refund on every call to nonReentrant will be lower in
165     // amount. Since refunds are capped to a percentage of the total
166     // transaction's gas, it is best to keep them low in cases like this one, to
167     // increase the likelihood of the full refund coming into effect.
168     uint256 private constant _NOT_ENTERED = 1;
169     uint256 private constant _ENTERED = 2;
170 
171     uint256 private _status;
172 
173     constructor() {
174         _status = _NOT_ENTERED;
175     }
176 
177     /**
178      * @dev Prevents a contract from calling itself, directly or indirectly.
179      * Calling a `nonReentrant` function from another `nonReentrant`
180      * function is not supported. It is possible to prevent this from happening
181      * by making the `nonReentrant` function external, and make it call a
182      * `private` function that does the actual work.
183      */
184     modifier nonReentrant() {
185         // On the first call to nonReentrant, _notEntered will be true
186         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
187 
188         // Any calls to nonReentrant after this point will fail
189         _status = _ENTERED;
190 
191         _;
192 
193         // By storing the original value once again, a refund is triggered (see
194         // https://eips.ethereum.org/EIPS/eip-2200)
195         _status = _NOT_ENTERED;
196     }
197 }
198 
199 // File: @openzeppelin/contracts/utils/Strings.sol
200 
201 
202 
203 pragma solidity ^0.8.0;
204 
205 /**
206  * @dev String operations.
207  */
208 library Strings {
209     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
210 
211     /**
212      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
213      */
214     function toString(uint256 value) internal pure returns (string memory) {
215         // Inspired by OraclizeAPI's implementation - MIT licence
216         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
217 
218         if (value == 0) {
219             return "0";
220         }
221         uint256 temp = value;
222         uint256 digits;
223         while (temp != 0) {
224             digits++;
225             temp /= 10;
226         }
227         bytes memory buffer = new bytes(digits);
228         while (value != 0) {
229             digits -= 1;
230             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
231             value /= 10;
232         }
233         return string(buffer);
234     }
235 
236     /**
237      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
238      */
239     function toHexString(uint256 value) internal pure returns (string memory) {
240         if (value == 0) {
241             return "0x00";
242         }
243         uint256 temp = value;
244         uint256 length = 0;
245         while (temp != 0) {
246             length++;
247             temp >>= 8;
248         }
249         return toHexString(value, length);
250     }
251 
252     /**
253      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
254      */
255     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
256         bytes memory buffer = new bytes(2 * length + 2);
257         buffer[0] = "0";
258         buffer[1] = "x";
259         for (uint256 i = 2 * length + 1; i > 1; --i) {
260             buffer[i] = _HEX_SYMBOLS[value & 0xf];
261             value >>= 4;
262         }
263         require(value == 0, "Strings: hex length insufficient");
264         return string(buffer);
265     }
266 }
267 
268 // File: @openzeppelin/contracts/utils/Context.sol
269 
270 
271 
272 pragma solidity ^0.8.0;
273 
274 /**
275  * @dev Provides information about the current execution context, including the
276  * sender of the transaction and its data. While these are generally available
277  * via msg.sender and msg.data, they should not be accessed in such a direct
278  * manner, since when dealing with meta-transactions the account sending and
279  * paying for execution may not be the actual sender (as far as an application
280  * is concerned).
281  *
282  * This contract is only required for intermediate, library-like contracts.
283  */
284 abstract contract Context {
285     function _msgSender() internal view virtual returns (address) {
286         return msg.sender;
287     }
288 
289     function _msgData() internal view virtual returns (bytes calldata) {
290         return msg.data;
291     }
292 }
293 
294 // File: contracts/access/DeveloperAccess.sol
295 
296 
297 
298 pragma solidity ^0.8.0;
299 
300 
301 /**
302  * @dev Contract module which provides a basic access control mechanism, where
303  * there is an account (an developer) that can be granted exclusive access to
304  * specific functions.
305  *
306  * By default, the developer account will be the one that deploys the contract. This
307  * can later be changed with {transferDevelopership}.
308  *
309  * This module is used through inheritance. It will make available the modifier
310  * `onlyDeveloper`, which can be applied to your functions to restrict their use to
311  * the developer.
312  */
313 abstract contract DeveloperAccess is Context {
314     address private _developer;
315 
316     event DevelopershipTransferred(address indexed previousDeveloper, address indexed newDeveloper);
317 
318     /**
319      * @dev Initializes the contract setting the deployer as the initial developer.
320      */
321     constructor(address dev) {
322         _setDeveloper(dev);
323     }
324 
325     /**
326      * @dev Returns the address of the current developer.
327      */
328     function developer() public view virtual returns (address) {
329         return _developer;
330     }
331 
332     /**
333      * @dev Throws if called by any account other than the developer.
334      */
335     modifier onlyDeveloper() {
336         require(developer() == _msgSender(), "Ownable: caller is not the developer");
337         _;
338     }
339 
340     /**
341      * @dev Leaves the contract without developer. It will not be possible to call
342      * `onlyDeveloper` functions anymore. Can only be called by the current developer.
343      *
344      * NOTE: Renouncing developership will leave the contract without an developer,
345      * thereby removing any functionality that is only available to the developer.
346      */
347     function renounceDevelopership() public virtual onlyDeveloper {
348         _setDeveloper(address(0));
349     }
350 
351     /**
352      * @dev Transfers developership of the contract to a new account (`newDeveloper`).
353      * Can only be called by the current developer.
354      */
355     function transferDevelopership(address newDeveloper) public virtual onlyDeveloper {
356         require(newDeveloper != address(0), "Ownable: new developer is the zero address");
357         _setDeveloper(newDeveloper);
358     }
359 
360     function _setDeveloper(address newDeveloper) private {
361         address oldDeveloper = _developer;
362         _developer = newDeveloper;
363         emit DevelopershipTransferred(oldDeveloper, newDeveloper);
364     }
365 }
366 
367 // File: @openzeppelin/contracts/access/Ownable.sol
368 
369 
370 
371 pragma solidity ^0.8.0;
372 
373 
374 /**
375  * @dev Contract module which provides a basic access control mechanism, where
376  * there is an account (an owner) that can be granted exclusive access to
377  * specific functions.
378  *
379  * By default, the owner account will be the one that deploys the contract. This
380  * can later be changed with {transferOwnership}.
381  *
382  * This module is used through inheritance. It will make available the modifier
383  * `onlyOwner`, which can be applied to your functions to restrict their use to
384  * the owner.
385  */
386 abstract contract Ownable is Context {
387     address private _owner;
388 
389     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
390 
391     /**
392      * @dev Initializes the contract setting the deployer as the initial owner.
393      */
394     constructor() {
395         _setOwner(_msgSender());
396     }
397 
398     /**
399      * @dev Returns the address of the current owner.
400      */
401     function owner() public view virtual returns (address) {
402         return _owner;
403     }
404 
405     /**
406      * @dev Throws if called by any account other than the owner.
407      */
408     modifier onlyOwner() {
409         require(owner() == _msgSender(), "Ownable: caller is not the owner");
410         _;
411     }
412 
413     /**
414      * @dev Leaves the contract without owner. It will not be possible to call
415      * `onlyOwner` functions anymore. Can only be called by the current owner.
416      *
417      * NOTE: Renouncing ownership will leave the contract without an owner,
418      * thereby removing any functionality that is only available to the owner.
419      */
420     function renounceOwnership() public virtual onlyOwner {
421         _setOwner(address(0));
422     }
423 
424     /**
425      * @dev Transfers ownership of the contract to a new account (`newOwner`).
426      * Can only be called by the current owner.
427      */
428     function transferOwnership(address newOwner) public virtual onlyOwner {
429         require(newOwner != address(0), "Ownable: new owner is the zero address");
430         _setOwner(newOwner);
431     }
432 
433     function _setOwner(address newOwner) private {
434         address oldOwner = _owner;
435         _owner = newOwner;
436         emit OwnershipTransferred(oldOwner, newOwner);
437     }
438 }
439 
440 // File: @openzeppelin/contracts/utils/Address.sol
441 
442 
443 
444 pragma solidity ^0.8.0;
445 
446 /**
447  * @dev Collection of functions related to the address type
448  */
449 library Address {
450     /**
451      * @dev Returns true if `account` is a contract.
452      *
453      * [IMPORTANT]
454      * ====
455      * It is unsafe to assume that an address for which this function returns
456      * false is an externally-owned account (EOA) and not a contract.
457      *
458      * Among others, `isContract` will return false for the following
459      * types of addresses:
460      *
461      *  - an externally-owned account
462      *  - a contract in construction
463      *  - an address where a contract will be created
464      *  - an address where a contract lived, but was destroyed
465      * ====
466      */
467     function isContract(address account) internal view returns (bool) {
468         // This method relies on extcodesize, which returns 0 for contracts in
469         // construction, since the code is only stored at the end of the
470         // constructor execution.
471 
472         uint256 size;
473         assembly {
474             size := extcodesize(account)
475         }
476         return size > 0;
477     }
478 
479     /**
480      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
481      * `recipient`, forwarding all available gas and reverting on errors.
482      *
483      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
484      * of certain opcodes, possibly making contracts go over the 2300 gas limit
485      * imposed by `transfer`, making them unable to receive funds via
486      * `transfer`. {sendValue} removes this limitation.
487      *
488      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
489      *
490      * IMPORTANT: because control is transferred to `recipient`, care must be
491      * taken to not create reentrancy vulnerabilities. Consider using
492      * {ReentrancyGuard} or the
493      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
494      */
495     function sendValue(address payable recipient, uint256 amount) internal {
496         require(address(this).balance >= amount, "Address: insufficient balance");
497 
498         (bool success, ) = recipient.call{value: amount}("");
499         require(success, "Address: unable to send value, recipient may have reverted");
500     }
501 
502     /**
503      * @dev Performs a Solidity function call using a low level `call`. A
504      * plain `call` is an unsafe replacement for a function call: use this
505      * function instead.
506      *
507      * If `target` reverts with a revert reason, it is bubbled up by this
508      * function (like regular Solidity function calls).
509      *
510      * Returns the raw returned data. To convert to the expected return value,
511      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
512      *
513      * Requirements:
514      *
515      * - `target` must be a contract.
516      * - calling `target` with `data` must not revert.
517      *
518      * _Available since v3.1._
519      */
520     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
521         return functionCall(target, data, "Address: low-level call failed");
522     }
523 
524     /**
525      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
526      * `errorMessage` as a fallback revert reason when `target` reverts.
527      *
528      * _Available since v3.1._
529      */
530     function functionCall(
531         address target,
532         bytes memory data,
533         string memory errorMessage
534     ) internal returns (bytes memory) {
535         return functionCallWithValue(target, data, 0, errorMessage);
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
540      * but also transferring `value` wei to `target`.
541      *
542      * Requirements:
543      *
544      * - the calling contract must have an ETH balance of at least `value`.
545      * - the called Solidity function must be `payable`.
546      *
547      * _Available since v3.1._
548      */
549     function functionCallWithValue(
550         address target,
551         bytes memory data,
552         uint256 value
553     ) internal returns (bytes memory) {
554         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
559      * with `errorMessage` as a fallback revert reason when `target` reverts.
560      *
561      * _Available since v3.1._
562      */
563     function functionCallWithValue(
564         address target,
565         bytes memory data,
566         uint256 value,
567         string memory errorMessage
568     ) internal returns (bytes memory) {
569         require(address(this).balance >= value, "Address: insufficient balance for call");
570         require(isContract(target), "Address: call to non-contract");
571 
572         (bool success, bytes memory returndata) = target.call{value: value}(data);
573         return verifyCallResult(success, returndata, errorMessage);
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
578      * but performing a static call.
579      *
580      * _Available since v3.3._
581      */
582     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
583         return functionStaticCall(target, data, "Address: low-level static call failed");
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
588      * but performing a static call.
589      *
590      * _Available since v3.3._
591      */
592     function functionStaticCall(
593         address target,
594         bytes memory data,
595         string memory errorMessage
596     ) internal view returns (bytes memory) {
597         require(isContract(target), "Address: static call to non-contract");
598 
599         (bool success, bytes memory returndata) = target.staticcall(data);
600         return verifyCallResult(success, returndata, errorMessage);
601     }
602 
603     /**
604      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
605      * but performing a delegate call.
606      *
607      * _Available since v3.4._
608      */
609     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
610         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
611     }
612 
613     /**
614      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
615      * but performing a delegate call.
616      *
617      * _Available since v3.4._
618      */
619     function functionDelegateCall(
620         address target,
621         bytes memory data,
622         string memory errorMessage
623     ) internal returns (bytes memory) {
624         require(isContract(target), "Address: delegate call to non-contract");
625 
626         (bool success, bytes memory returndata) = target.delegatecall(data);
627         return verifyCallResult(success, returndata, errorMessage);
628     }
629 
630     /**
631      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
632      * revert reason using the provided one.
633      *
634      * _Available since v4.3._
635      */
636     function verifyCallResult(
637         bool success,
638         bytes memory returndata,
639         string memory errorMessage
640     ) internal pure returns (bytes memory) {
641         if (success) {
642             return returndata;
643         } else {
644             // Look for revert reason and bubble it up if present
645             if (returndata.length > 0) {
646                 // The easiest way to bubble the revert reason is using memory via assembly
647 
648                 assembly {
649                     let returndata_size := mload(returndata)
650                     revert(add(32, returndata), returndata_size)
651                 }
652             } else {
653                 revert(errorMessage);
654             }
655         }
656     }
657 }
658 
659 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
660 
661 
662 
663 pragma solidity ^0.8.0;
664 
665 /**
666  * @title ERC721 token receiver interface
667  * @dev Interface for any contract that wants to support safeTransfers
668  * from ERC721 asset contracts.
669  */
670 interface IERC721Receiver {
671     /**
672      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
673      * by `operator` from `from`, this function is called.
674      *
675      * It must return its Solidity selector to confirm the token transfer.
676      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
677      *
678      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
679      */
680     function onERC721Received(
681         address operator,
682         address from,
683         uint256 tokenId,
684         bytes calldata data
685     ) external returns (bytes4);
686 }
687 
688 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
689 
690 
691 
692 pragma solidity ^0.8.0;
693 
694 /**
695  * @dev Interface of the ERC165 standard, as defined in the
696  * https://eips.ethereum.org/EIPS/eip-165[EIP].
697  *
698  * Implementers can declare support of contract interfaces, which can then be
699  * queried by others ({ERC165Checker}).
700  *
701  * For an implementation, see {ERC165}.
702  */
703 interface IERC165 {
704     /**
705      * @dev Returns true if this contract implements the interface defined by
706      * `interfaceId`. See the corresponding
707      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
708      * to learn more about how these ids are created.
709      *
710      * This function call must use less than 30 000 gas.
711      */
712     function supportsInterface(bytes4 interfaceId) external view returns (bool);
713 }
714 
715 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
716 
717 
718 
719 pragma solidity ^0.8.0;
720 
721 
722 /**
723  * @dev Implementation of the {IERC165} interface.
724  *
725  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
726  * for the additional interface id that will be supported. For example:
727  *
728  * ```solidity
729  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
730  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
731  * }
732  * ```
733  *
734  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
735  */
736 abstract contract ERC165 is IERC165 {
737     /**
738      * @dev See {IERC165-supportsInterface}.
739      */
740     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
741         return interfaceId == type(IERC165).interfaceId;
742     }
743 }
744 
745 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
746 
747 
748 
749 pragma solidity ^0.8.0;
750 
751 
752 /**
753  * @dev Required interface of an ERC721 compliant contract.
754  */
755 interface IERC721 is IERC165 {
756     /**
757      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
758      */
759     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
760 
761     /**
762      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
763      */
764     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
765 
766     /**
767      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
768      */
769     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
770 
771     /**
772      * @dev Returns the number of tokens in ``owner``'s account.
773      */
774     function balanceOf(address owner) external view returns (uint256 balance);
775 
776     /**
777      * @dev Returns the owner of the `tokenId` token.
778      *
779      * Requirements:
780      *
781      * - `tokenId` must exist.
782      */
783     function ownerOf(uint256 tokenId) external view returns (address owner);
784 
785     /**
786      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
787      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
788      *
789      * Requirements:
790      *
791      * - `from` cannot be the zero address.
792      * - `to` cannot be the zero address.
793      * - `tokenId` token must exist and be owned by `from`.
794      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
795      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
796      *
797      * Emits a {Transfer} event.
798      */
799     function safeTransferFrom(
800         address from,
801         address to,
802         uint256 tokenId
803     ) external;
804 
805     /**
806      * @dev Transfers `tokenId` token from `from` to `to`.
807      *
808      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
809      *
810      * Requirements:
811      *
812      * - `from` cannot be the zero address.
813      * - `to` cannot be the zero address.
814      * - `tokenId` token must be owned by `from`.
815      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
816      *
817      * Emits a {Transfer} event.
818      */
819     function transferFrom(
820         address from,
821         address to,
822         uint256 tokenId
823     ) external;
824 
825     /**
826      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
827      * The approval is cleared when the token is transferred.
828      *
829      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
830      *
831      * Requirements:
832      *
833      * - The caller must own the token or be an approved operator.
834      * - `tokenId` must exist.
835      *
836      * Emits an {Approval} event.
837      */
838     function approve(address to, uint256 tokenId) external;
839 
840     /**
841      * @dev Returns the account approved for `tokenId` token.
842      *
843      * Requirements:
844      *
845      * - `tokenId` must exist.
846      */
847     function getApproved(uint256 tokenId) external view returns (address operator);
848 
849     /**
850      * @dev Approve or remove `operator` as an operator for the caller.
851      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
852      *
853      * Requirements:
854      *
855      * - The `operator` cannot be the caller.
856      *
857      * Emits an {ApprovalForAll} event.
858      */
859     function setApprovalForAll(address operator, bool _approved) external;
860 
861     /**
862      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
863      *
864      * See {setApprovalForAll}
865      */
866     function isApprovedForAll(address owner, address operator) external view returns (bool);
867 
868     /**
869      * @dev Safely transfers `tokenId` token from `from` to `to`.
870      *
871      * Requirements:
872      *
873      * - `from` cannot be the zero address.
874      * - `to` cannot be the zero address.
875      * - `tokenId` token must exist and be owned by `from`.
876      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
877      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
878      *
879      * Emits a {Transfer} event.
880      */
881     function safeTransferFrom(
882         address from,
883         address to,
884         uint256 tokenId,
885         bytes calldata data
886     ) external;
887 }
888 
889 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
890 
891 
892 
893 pragma solidity ^0.8.0;
894 
895 
896 /**
897  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
898  * @dev See https://eips.ethereum.org/EIPS/eip-721
899  */
900 interface IERC721Metadata is IERC721 {
901     /**
902      * @dev Returns the token collection name.
903      */
904     function name() external view returns (string memory);
905 
906     /**
907      * @dev Returns the token collection symbol.
908      */
909     function symbol() external view returns (string memory);
910 
911     /**
912      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
913      */
914     function tokenURI(uint256 tokenId) external view returns (string memory);
915 }
916 
917 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
918 
919 
920 
921 pragma solidity ^0.8.0;
922 
923 
924 
925 
926 
927 
928 
929 
930 /**
931  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
932  * the Metadata extension, but not including the Enumerable extension, which is available separately as
933  * {ERC721Enumerable}.
934  */
935 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
936     using Address for address;
937     using Strings for uint256;
938 
939     // Token name
940     string private _name;
941 
942     // Token symbol
943     string private _symbol;
944 
945     // Mapping from token ID to owner address
946     mapping(uint256 => address) private _owners;
947 
948     // Mapping owner address to token count
949     mapping(address => uint256) private _balances;
950 
951     // Mapping from token ID to approved address
952     mapping(uint256 => address) private _tokenApprovals;
953 
954     // Mapping from owner to operator approvals
955     mapping(address => mapping(address => bool)) private _operatorApprovals;
956 
957     /**
958      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
959      */
960     constructor(string memory name_, string memory symbol_) {
961         _name = name_;
962         _symbol = symbol_;
963     }
964 
965     /**
966      * @dev See {IERC165-supportsInterface}.
967      */
968     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
969         return
970             interfaceId == type(IERC721).interfaceId ||
971             interfaceId == type(IERC721Metadata).interfaceId ||
972             super.supportsInterface(interfaceId);
973     }
974 
975     /**
976      * @dev See {IERC721-balanceOf}.
977      */
978     function balanceOf(address owner) public view virtual override returns (uint256) {
979         require(owner != address(0), "ERC721: balance query for the zero address");
980         return _balances[owner];
981     }
982 
983     /**
984      * @dev See {IERC721-ownerOf}.
985      */
986     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
987         address owner = _owners[tokenId];
988         require(owner != address(0), "ERC721: owner query for nonexistent token");
989         return owner;
990     }
991 
992     /**
993      * @dev See {IERC721Metadata-name}.
994      */
995     function name() public view virtual override returns (string memory) {
996         return _name;
997     }
998 
999     /**
1000      * @dev See {IERC721Metadata-symbol}.
1001      */
1002     function symbol() public view virtual override returns (string memory) {
1003         return _symbol;
1004     }
1005 
1006     /**
1007      * @dev See {IERC721Metadata-tokenURI}.
1008      */
1009     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1010         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1011 
1012         string memory baseURI = _baseURI();
1013         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1014     }
1015 
1016     /**
1017      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1018      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1019      * by default, can be overriden in child contracts.
1020      */
1021     function _baseURI() internal view virtual returns (string memory) {
1022         return "";
1023     }
1024 
1025     /**
1026      * @dev See {IERC721-approve}.
1027      */
1028     function approve(address to, uint256 tokenId) public virtual override {
1029         address owner = ERC721.ownerOf(tokenId);
1030         require(to != owner, "ERC721: approval to current owner");
1031 
1032         require(
1033             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1034             "ERC721: approve caller is not owner nor approved for all"
1035         );
1036 
1037         _approve(to, tokenId);
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-getApproved}.
1042      */
1043     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1044         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1045 
1046         return _tokenApprovals[tokenId];
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-setApprovalForAll}.
1051      */
1052     function setApprovalForAll(address operator, bool approved) public virtual override {
1053         require(operator != _msgSender(), "ERC721: approve to caller");
1054 
1055         _operatorApprovals[_msgSender()][operator] = approved;
1056         emit ApprovalForAll(_msgSender(), operator, approved);
1057     }
1058 
1059     /**
1060      * @dev See {IERC721-isApprovedForAll}.
1061      */
1062     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1063         return _operatorApprovals[owner][operator];
1064     }
1065 
1066     /**
1067      * @dev See {IERC721-transferFrom}.
1068      */
1069     function transferFrom(
1070         address from,
1071         address to,
1072         uint256 tokenId
1073     ) public virtual override {
1074         //solhint-disable-next-line max-line-length
1075         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1076 
1077         _transfer(from, to, tokenId);
1078     }
1079 
1080     /**
1081      * @dev See {IERC721-safeTransferFrom}.
1082      */
1083     function safeTransferFrom(
1084         address from,
1085         address to,
1086         uint256 tokenId
1087     ) public virtual override {
1088         safeTransferFrom(from, to, tokenId, "");
1089     }
1090 
1091     /**
1092      * @dev See {IERC721-safeTransferFrom}.
1093      */
1094     function safeTransferFrom(
1095         address from,
1096         address to,
1097         uint256 tokenId,
1098         bytes memory _data
1099     ) public virtual override {
1100         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1101         _safeTransfer(from, to, tokenId, _data);
1102     }
1103 
1104     /**
1105      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1106      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1107      *
1108      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1109      *
1110      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1111      * implement alternative mechanisms to perform token transfer, such as signature-based.
1112      *
1113      * Requirements:
1114      *
1115      * - `from` cannot be the zero address.
1116      * - `to` cannot be the zero address.
1117      * - `tokenId` token must exist and be owned by `from`.
1118      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1119      *
1120      * Emits a {Transfer} event.
1121      */
1122     function _safeTransfer(
1123         address from,
1124         address to,
1125         uint256 tokenId,
1126         bytes memory _data
1127     ) internal virtual {
1128         _transfer(from, to, tokenId);
1129         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1130     }
1131 
1132     /**
1133      * @dev Returns whether `tokenId` exists.
1134      *
1135      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1136      *
1137      * Tokens start existing when they are minted (`_mint`),
1138      * and stop existing when they are burned (`_burn`).
1139      */
1140     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1141         return _owners[tokenId] != address(0);
1142     }
1143 
1144     /**
1145      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1146      *
1147      * Requirements:
1148      *
1149      * - `tokenId` must exist.
1150      */
1151     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1152         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1153         address owner = ERC721.ownerOf(tokenId);
1154         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1155     }
1156 
1157     /**
1158      * @dev Safely mints `tokenId` and transfers it to `to`.
1159      *
1160      * Requirements:
1161      *
1162      * - `tokenId` must not exist.
1163      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1164      *
1165      * Emits a {Transfer} event.
1166      */
1167     function _safeMint(address to, uint256 tokenId) internal virtual {
1168         _safeMint(to, tokenId, "");
1169     }
1170 
1171     /**
1172      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1173      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1174      */
1175     function _safeMint(
1176         address to,
1177         uint256 tokenId,
1178         bytes memory _data
1179     ) internal virtual {
1180         _mint(to, tokenId);
1181         require(
1182             _checkOnERC721Received(address(0), to, tokenId, _data),
1183             "ERC721: transfer to non ERC721Receiver implementer"
1184         );
1185     }
1186 
1187     /**
1188      * @dev Mints `tokenId` and transfers it to `to`.
1189      *
1190      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1191      *
1192      * Requirements:
1193      *
1194      * - `tokenId` must not exist.
1195      * - `to` cannot be the zero address.
1196      *
1197      * Emits a {Transfer} event.
1198      */
1199     function _mint(address to, uint256 tokenId) internal virtual {
1200         require(to != address(0), "ERC721: mint to the zero address");
1201         require(!_exists(tokenId), "ERC721: token already minted");
1202 
1203         _beforeTokenTransfer(address(0), to, tokenId);
1204 
1205         _balances[to] += 1;
1206         _owners[tokenId] = to;
1207 
1208         emit Transfer(address(0), to, tokenId);
1209     }
1210 
1211     /**
1212      * @dev Destroys `tokenId`.
1213      * The approval is cleared when the token is burned.
1214      *
1215      * Requirements:
1216      *
1217      * - `tokenId` must exist.
1218      *
1219      * Emits a {Transfer} event.
1220      */
1221     function _burn(uint256 tokenId) internal virtual {
1222         address owner = ERC721.ownerOf(tokenId);
1223 
1224         _beforeTokenTransfer(owner, address(0), tokenId);
1225 
1226         // Clear approvals
1227         _approve(address(0), tokenId);
1228 
1229         _balances[owner] -= 1;
1230         delete _owners[tokenId];
1231 
1232         emit Transfer(owner, address(0), tokenId);
1233     }
1234 
1235     /**
1236      * @dev Transfers `tokenId` from `from` to `to`.
1237      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1238      *
1239      * Requirements:
1240      *
1241      * - `to` cannot be the zero address.
1242      * - `tokenId` token must be owned by `from`.
1243      *
1244      * Emits a {Transfer} event.
1245      */
1246     function _transfer(
1247         address from,
1248         address to,
1249         uint256 tokenId
1250     ) internal virtual {
1251         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1252         require(to != address(0), "ERC721: transfer to the zero address");
1253 
1254         _beforeTokenTransfer(from, to, tokenId);
1255 
1256         // Clear approvals from the previous owner
1257         _approve(address(0), tokenId);
1258 
1259         _balances[from] -= 1;
1260         _balances[to] += 1;
1261         _owners[tokenId] = to;
1262 
1263         emit Transfer(from, to, tokenId);
1264     }
1265 
1266     /**
1267      * @dev Approve `to` to operate on `tokenId`
1268      *
1269      * Emits a {Approval} event.
1270      */
1271     function _approve(address to, uint256 tokenId) internal virtual {
1272         _tokenApprovals[tokenId] = to;
1273         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1274     }
1275 
1276     /**
1277      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1278      * The call is not executed if the target address is not a contract.
1279      *
1280      * @param from address representing the previous owner of the given token ID
1281      * @param to target address that will receive the tokens
1282      * @param tokenId uint256 ID of the token to be transferred
1283      * @param _data bytes optional data to send along with the call
1284      * @return bool whether the call correctly returned the expected magic value
1285      */
1286     function _checkOnERC721Received(
1287         address from,
1288         address to,
1289         uint256 tokenId,
1290         bytes memory _data
1291     ) private returns (bool) {
1292         if (to.isContract()) {
1293             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1294                 return retval == IERC721Receiver.onERC721Received.selector;
1295             } catch (bytes memory reason) {
1296                 if (reason.length == 0) {
1297                     revert("ERC721: transfer to non ERC721Receiver implementer");
1298                 } else {
1299                     assembly {
1300                         revert(add(32, reason), mload(reason))
1301                     }
1302                 }
1303             }
1304         } else {
1305             return true;
1306         }
1307     }
1308 
1309     /**
1310      * @dev Hook that is called before any token transfer. This includes minting
1311      * and burning.
1312      *
1313      * Calling conditions:
1314      *
1315      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1316      * transferred to `to`.
1317      * - When `from` is zero, `tokenId` will be minted for `to`.
1318      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1319      * - `from` and `to` are never both zero.
1320      *
1321      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1322      */
1323     function _beforeTokenTransfer(
1324         address from,
1325         address to,
1326         uint256 tokenId
1327     ) internal virtual {}
1328 }
1329 
1330 // File: prb-math/contracts/PRBMath.sol
1331 
1332 
1333 pragma solidity >=0.8.4;
1334 
1335 /// @notice Emitted when the result overflows uint256.
1336 error PRBMath__MulDivFixedPointOverflow(uint256 prod1);
1337 
1338 /// @notice Emitted when the result overflows uint256.
1339 error PRBMath__MulDivOverflow(uint256 prod1, uint256 denominator);
1340 
1341 /// @notice Emitted when one of the inputs is type(int256).min.
1342 error PRBMath__MulDivSignedInputTooSmall();
1343 
1344 /// @notice Emitted when the intermediary absolute result overflows int256.
1345 error PRBMath__MulDivSignedOverflow(uint256 rAbs);
1346 
1347 /// @notice Emitted when the input is MIN_SD59x18.
1348 error PRBMathSD59x18__AbsInputTooSmall();
1349 
1350 /// @notice Emitted when ceiling a number overflows SD59x18.
1351 error PRBMathSD59x18__CeilOverflow(int256 x);
1352 
1353 /// @notice Emitted when one of the inputs is MIN_SD59x18.
1354 error PRBMathSD59x18__DivInputTooSmall();
1355 
1356 /// @notice Emitted when one of the intermediary unsigned results overflows SD59x18.
1357 error PRBMathSD59x18__DivOverflow(uint256 rAbs);
1358 
1359 /// @notice Emitted when the input is greater than 133.084258667509499441.
1360 error PRBMathSD59x18__ExpInputTooBig(int256 x);
1361 
1362 /// @notice Emitted when the input is greater than 192.
1363 error PRBMathSD59x18__Exp2InputTooBig(int256 x);
1364 
1365 /// @notice Emitted when flooring a number underflows SD59x18.
1366 error PRBMathSD59x18__FloorUnderflow(int256 x);
1367 
1368 /// @notice Emitted when converting a basic integer to the fixed-point format overflows SD59x18.
1369 error PRBMathSD59x18__FromIntOverflow(int256 x);
1370 
1371 /// @notice Emitted when converting a basic integer to the fixed-point format underflows SD59x18.
1372 error PRBMathSD59x18__FromIntUnderflow(int256 x);
1373 
1374 /// @notice Emitted when the product of the inputs is negative.
1375 error PRBMathSD59x18__GmNegativeProduct(int256 x, int256 y);
1376 
1377 /// @notice Emitted when multiplying the inputs overflows SD59x18.
1378 error PRBMathSD59x18__GmOverflow(int256 x, int256 y);
1379 
1380 /// @notice Emitted when the input is less than or equal to zero.
1381 error PRBMathSD59x18__LogInputTooSmall(int256 x);
1382 
1383 /// @notice Emitted when one of the inputs is MIN_SD59x18.
1384 error PRBMathSD59x18__MulInputTooSmall();
1385 
1386 /// @notice Emitted when the intermediary absolute result overflows SD59x18.
1387 error PRBMathSD59x18__MulOverflow(uint256 rAbs);
1388 
1389 /// @notice Emitted when the intermediary absolute result overflows SD59x18.
1390 error PRBMathSD59x18__PowuOverflow(uint256 rAbs);
1391 
1392 /// @notice Emitted when the input is negative.
1393 error PRBMathSD59x18__SqrtNegativeInput(int256 x);
1394 
1395 /// @notice Emitted when the calculating the square root overflows SD59x18.
1396 error PRBMathSD59x18__SqrtOverflow(int256 x);
1397 
1398 /// @notice Emitted when addition overflows UD60x18.
1399 error PRBMathUD60x18__AddOverflow(uint256 x, uint256 y);
1400 
1401 /// @notice Emitted when ceiling a number overflows UD60x18.
1402 error PRBMathUD60x18__CeilOverflow(uint256 x);
1403 
1404 /// @notice Emitted when the input is greater than 133.084258667509499441.
1405 error PRBMathUD60x18__ExpInputTooBig(uint256 x);
1406 
1407 /// @notice Emitted when the input is greater than 192.
1408 error PRBMathUD60x18__Exp2InputTooBig(uint256 x);
1409 
1410 /// @notice Emitted when converting a basic integer to the fixed-point format format overflows UD60x18.
1411 error PRBMathUD60x18__FromUintOverflow(uint256 x);
1412 
1413 /// @notice Emitted when multiplying the inputs overflows UD60x18.
1414 error PRBMathUD60x18__GmOverflow(uint256 x, uint256 y);
1415 
1416 /// @notice Emitted when the input is less than 1.
1417 error PRBMathUD60x18__LogInputTooSmall(uint256 x);
1418 
1419 /// @notice Emitted when the calculating the square root overflows UD60x18.
1420 error PRBMathUD60x18__SqrtOverflow(uint256 x);
1421 
1422 /// @notice Emitted when subtraction underflows UD60x18.
1423 error PRBMathUD60x18__SubUnderflow(uint256 x, uint256 y);
1424 
1425 /// @dev Common mathematical functions used in both PRBMathSD59x18 and PRBMathUD60x18. Note that this shared library
1426 /// does not always assume the signed 59.18-decimal fixed-point or the unsigned 60.18-decimal fixed-point
1427 /// representation. When it does not, it is explicitly mentioned in the NatSpec documentation.
1428 library PRBMath {
1429     /// STRUCTS ///
1430 
1431     struct SD59x18 {
1432         int256 value;
1433     }
1434 
1435     struct UD60x18 {
1436         uint256 value;
1437     }
1438 
1439     /// STORAGE ///
1440 
1441     /// @dev How many trailing decimals can be represented.
1442     uint256 internal constant SCALE = 1e18;
1443 
1444     /// @dev Largest power of two divisor of SCALE.
1445     uint256 internal constant SCALE_LPOTD = 262144;
1446 
1447     /// @dev SCALE inverted mod 2^256.
1448     uint256 internal constant SCALE_INVERSE =
1449         78156646155174841979727994598816262306175212592076161876661_508869554232690281;
1450 
1451     /// FUNCTIONS ///
1452 
1453     /// @notice Calculates the binary exponent of x using the binary fraction method.
1454     /// @dev Has to use 192.64-bit fixed-point numbers.
1455     /// See https://ethereum.stackexchange.com/a/96594/24693.
1456     /// @param x The exponent as an unsigned 192.64-bit fixed-point number.
1457     /// @return result The result as an unsigned 60.18-decimal fixed-point number.
1458     function exp2(uint256 x) internal pure returns (uint256 result) {
1459         unchecked {
1460             // Start from 0.5 in the 192.64-bit fixed-point format.
1461             result = 0x800000000000000000000000000000000000000000000000;
1462 
1463             // Multiply the result by root(2, 2^-i) when the bit at position i is 1. None of the intermediary results overflows
1464             // because the initial result is 2^191 and all magic factors are less than 2^65.
1465             if (x & 0x8000000000000000 > 0) {
1466                 result = (result * 0x16A09E667F3BCC909) >> 64;
1467             }
1468             if (x & 0x4000000000000000 > 0) {
1469                 result = (result * 0x1306FE0A31B7152DF) >> 64;
1470             }
1471             if (x & 0x2000000000000000 > 0) {
1472                 result = (result * 0x1172B83C7D517ADCE) >> 64;
1473             }
1474             if (x & 0x1000000000000000 > 0) {
1475                 result = (result * 0x10B5586CF9890F62A) >> 64;
1476             }
1477             if (x & 0x800000000000000 > 0) {
1478                 result = (result * 0x1059B0D31585743AE) >> 64;
1479             }
1480             if (x & 0x400000000000000 > 0) {
1481                 result = (result * 0x102C9A3E778060EE7) >> 64;
1482             }
1483             if (x & 0x200000000000000 > 0) {
1484                 result = (result * 0x10163DA9FB33356D8) >> 64;
1485             }
1486             if (x & 0x100000000000000 > 0) {
1487                 result = (result * 0x100B1AFA5ABCBED61) >> 64;
1488             }
1489             if (x & 0x80000000000000 > 0) {
1490                 result = (result * 0x10058C86DA1C09EA2) >> 64;
1491             }
1492             if (x & 0x40000000000000 > 0) {
1493                 result = (result * 0x1002C605E2E8CEC50) >> 64;
1494             }
1495             if (x & 0x20000000000000 > 0) {
1496                 result = (result * 0x100162F3904051FA1) >> 64;
1497             }
1498             if (x & 0x10000000000000 > 0) {
1499                 result = (result * 0x1000B175EFFDC76BA) >> 64;
1500             }
1501             if (x & 0x8000000000000 > 0) {
1502                 result = (result * 0x100058BA01FB9F96D) >> 64;
1503             }
1504             if (x & 0x4000000000000 > 0) {
1505                 result = (result * 0x10002C5CC37DA9492) >> 64;
1506             }
1507             if (x & 0x2000000000000 > 0) {
1508                 result = (result * 0x1000162E525EE0547) >> 64;
1509             }
1510             if (x & 0x1000000000000 > 0) {
1511                 result = (result * 0x10000B17255775C04) >> 64;
1512             }
1513             if (x & 0x800000000000 > 0) {
1514                 result = (result * 0x1000058B91B5BC9AE) >> 64;
1515             }
1516             if (x & 0x400000000000 > 0) {
1517                 result = (result * 0x100002C5C89D5EC6D) >> 64;
1518             }
1519             if (x & 0x200000000000 > 0) {
1520                 result = (result * 0x10000162E43F4F831) >> 64;
1521             }
1522             if (x & 0x100000000000 > 0) {
1523                 result = (result * 0x100000B1721BCFC9A) >> 64;
1524             }
1525             if (x & 0x80000000000 > 0) {
1526                 result = (result * 0x10000058B90CF1E6E) >> 64;
1527             }
1528             if (x & 0x40000000000 > 0) {
1529                 result = (result * 0x1000002C5C863B73F) >> 64;
1530             }
1531             if (x & 0x20000000000 > 0) {
1532                 result = (result * 0x100000162E430E5A2) >> 64;
1533             }
1534             if (x & 0x10000000000 > 0) {
1535                 result = (result * 0x1000000B172183551) >> 64;
1536             }
1537             if (x & 0x8000000000 > 0) {
1538                 result = (result * 0x100000058B90C0B49) >> 64;
1539             }
1540             if (x & 0x4000000000 > 0) {
1541                 result = (result * 0x10000002C5C8601CC) >> 64;
1542             }
1543             if (x & 0x2000000000 > 0) {
1544                 result = (result * 0x1000000162E42FFF0) >> 64;
1545             }
1546             if (x & 0x1000000000 > 0) {
1547                 result = (result * 0x10000000B17217FBB) >> 64;
1548             }
1549             if (x & 0x800000000 > 0) {
1550                 result = (result * 0x1000000058B90BFCE) >> 64;
1551             }
1552             if (x & 0x400000000 > 0) {
1553                 result = (result * 0x100000002C5C85FE3) >> 64;
1554             }
1555             if (x & 0x200000000 > 0) {
1556                 result = (result * 0x10000000162E42FF1) >> 64;
1557             }
1558             if (x & 0x100000000 > 0) {
1559                 result = (result * 0x100000000B17217F8) >> 64;
1560             }
1561             if (x & 0x80000000 > 0) {
1562                 result = (result * 0x10000000058B90BFC) >> 64;
1563             }
1564             if (x & 0x40000000 > 0) {
1565                 result = (result * 0x1000000002C5C85FE) >> 64;
1566             }
1567             if (x & 0x20000000 > 0) {
1568                 result = (result * 0x100000000162E42FF) >> 64;
1569             }
1570             if (x & 0x10000000 > 0) {
1571                 result = (result * 0x1000000000B17217F) >> 64;
1572             }
1573             if (x & 0x8000000 > 0) {
1574                 result = (result * 0x100000000058B90C0) >> 64;
1575             }
1576             if (x & 0x4000000 > 0) {
1577                 result = (result * 0x10000000002C5C860) >> 64;
1578             }
1579             if (x & 0x2000000 > 0) {
1580                 result = (result * 0x1000000000162E430) >> 64;
1581             }
1582             if (x & 0x1000000 > 0) {
1583                 result = (result * 0x10000000000B17218) >> 64;
1584             }
1585             if (x & 0x800000 > 0) {
1586                 result = (result * 0x1000000000058B90C) >> 64;
1587             }
1588             if (x & 0x400000 > 0) {
1589                 result = (result * 0x100000000002C5C86) >> 64;
1590             }
1591             if (x & 0x200000 > 0) {
1592                 result = (result * 0x10000000000162E43) >> 64;
1593             }
1594             if (x & 0x100000 > 0) {
1595                 result = (result * 0x100000000000B1721) >> 64;
1596             }
1597             if (x & 0x80000 > 0) {
1598                 result = (result * 0x10000000000058B91) >> 64;
1599             }
1600             if (x & 0x40000 > 0) {
1601                 result = (result * 0x1000000000002C5C8) >> 64;
1602             }
1603             if (x & 0x20000 > 0) {
1604                 result = (result * 0x100000000000162E4) >> 64;
1605             }
1606             if (x & 0x10000 > 0) {
1607                 result = (result * 0x1000000000000B172) >> 64;
1608             }
1609             if (x & 0x8000 > 0) {
1610                 result = (result * 0x100000000000058B9) >> 64;
1611             }
1612             if (x & 0x4000 > 0) {
1613                 result = (result * 0x10000000000002C5D) >> 64;
1614             }
1615             if (x & 0x2000 > 0) {
1616                 result = (result * 0x1000000000000162E) >> 64;
1617             }
1618             if (x & 0x1000 > 0) {
1619                 result = (result * 0x10000000000000B17) >> 64;
1620             }
1621             if (x & 0x800 > 0) {
1622                 result = (result * 0x1000000000000058C) >> 64;
1623             }
1624             if (x & 0x400 > 0) {
1625                 result = (result * 0x100000000000002C6) >> 64;
1626             }
1627             if (x & 0x200 > 0) {
1628                 result = (result * 0x10000000000000163) >> 64;
1629             }
1630             if (x & 0x100 > 0) {
1631                 result = (result * 0x100000000000000B1) >> 64;
1632             }
1633             if (x & 0x80 > 0) {
1634                 result = (result * 0x10000000000000059) >> 64;
1635             }
1636             if (x & 0x40 > 0) {
1637                 result = (result * 0x1000000000000002C) >> 64;
1638             }
1639             if (x & 0x20 > 0) {
1640                 result = (result * 0x10000000000000016) >> 64;
1641             }
1642             if (x & 0x10 > 0) {
1643                 result = (result * 0x1000000000000000B) >> 64;
1644             }
1645             if (x & 0x8 > 0) {
1646                 result = (result * 0x10000000000000006) >> 64;
1647             }
1648             if (x & 0x4 > 0) {
1649                 result = (result * 0x10000000000000003) >> 64;
1650             }
1651             if (x & 0x2 > 0) {
1652                 result = (result * 0x10000000000000001) >> 64;
1653             }
1654             if (x & 0x1 > 0) {
1655                 result = (result * 0x10000000000000001) >> 64;
1656             }
1657 
1658             // We're doing two things at the same time:
1659             //
1660             //   1. Multiply the result by 2^n + 1, where "2^n" is the integer part and the one is added to account for
1661             //      the fact that we initially set the result to 0.5. This is accomplished by subtracting from 191
1662             //      rather than 192.
1663             //   2. Convert the result to the unsigned 60.18-decimal fixed-point format.
1664             //
1665             // This works because 2^(191-ip) = 2^ip / 2^191, where "ip" is the integer part "2^n".
1666             result *= SCALE;
1667             result >>= (191 - (x >> 64));
1668         }
1669     }
1670 
1671     /// @notice Finds the zero-based index of the first one in the binary representation of x.
1672     /// @dev See the note on msb in the "Find First Set" Wikipedia article https://en.wikipedia.org/wiki/Find_first_set
1673     /// @param x The uint256 number for which to find the index of the most significant bit.
1674     /// @return msb The index of the most significant bit as an uint256.
1675     function mostSignificantBit(uint256 x) internal pure returns (uint256 msb) {
1676         if (x >= 2**128) {
1677             x >>= 128;
1678             msb += 128;
1679         }
1680         if (x >= 2**64) {
1681             x >>= 64;
1682             msb += 64;
1683         }
1684         if (x >= 2**32) {
1685             x >>= 32;
1686             msb += 32;
1687         }
1688         if (x >= 2**16) {
1689             x >>= 16;
1690             msb += 16;
1691         }
1692         if (x >= 2**8) {
1693             x >>= 8;
1694             msb += 8;
1695         }
1696         if (x >= 2**4) {
1697             x >>= 4;
1698             msb += 4;
1699         }
1700         if (x >= 2**2) {
1701             x >>= 2;
1702             msb += 2;
1703         }
1704         if (x >= 2**1) {
1705             // No need to shift x any more.
1706             msb += 1;
1707         }
1708     }
1709 
1710     /// @notice Calculates floor(x*y÷denominator) with full precision.
1711     ///
1712     /// @dev Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv.
1713     ///
1714     /// Requirements:
1715     /// - The denominator cannot be zero.
1716     /// - The result must fit within uint256.
1717     ///
1718     /// Caveats:
1719     /// - This function does not work with fixed-point numbers.
1720     ///
1721     /// @param x The multiplicand as an uint256.
1722     /// @param y The multiplier as an uint256.
1723     /// @param denominator The divisor as an uint256.
1724     /// @return result The result as an uint256.
1725     function mulDiv(
1726         uint256 x,
1727         uint256 y,
1728         uint256 denominator
1729     ) internal pure returns (uint256 result) {
1730         // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1731         // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1732         // variables such that product = prod1 * 2^256 + prod0.
1733         uint256 prod0; // Least significant 256 bits of the product
1734         uint256 prod1; // Most significant 256 bits of the product
1735         assembly {
1736             let mm := mulmod(x, y, not(0))
1737             prod0 := mul(x, y)
1738             prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1739         }
1740 
1741         // Handle non-overflow cases, 256 by 256 division.
1742         if (prod1 == 0) {
1743             unchecked {
1744                 result = prod0 / denominator;
1745             }
1746             return result;
1747         }
1748 
1749         // Make sure the result is less than 2^256. Also prevents denominator == 0.
1750         if (prod1 >= denominator) {
1751             revert PRBMath__MulDivOverflow(prod1, denominator);
1752         }
1753 
1754         ///////////////////////////////////////////////
1755         // 512 by 256 division.
1756         ///////////////////////////////////////////////
1757 
1758         // Make division exact by subtracting the remainder from [prod1 prod0].
1759         uint256 remainder;
1760         assembly {
1761             // Compute remainder using mulmod.
1762             remainder := mulmod(x, y, denominator)
1763 
1764             // Subtract 256 bit number from 512 bit number.
1765             prod1 := sub(prod1, gt(remainder, prod0))
1766             prod0 := sub(prod0, remainder)
1767         }
1768 
1769         // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1770         // See https://cs.stackexchange.com/q/138556/92363.
1771         unchecked {
1772             // Does not overflow because the denominator cannot be zero at this stage in the function.
1773             uint256 lpotdod = denominator & (~denominator + 1);
1774             assembly {
1775                 // Divide denominator by lpotdod.
1776                 denominator := div(denominator, lpotdod)
1777 
1778                 // Divide [prod1 prod0] by lpotdod.
1779                 prod0 := div(prod0, lpotdod)
1780 
1781                 // Flip lpotdod such that it is 2^256 / lpotdod. If lpotdod is zero, then it becomes one.
1782                 lpotdod := add(div(sub(0, lpotdod), lpotdod), 1)
1783             }
1784 
1785             // Shift in bits from prod1 into prod0.
1786             prod0 |= prod1 * lpotdod;
1787 
1788             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1789             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1790             // four bits. That is, denominator * inv = 1 mod 2^4.
1791             uint256 inverse = (3 * denominator) ^ 2;
1792 
1793             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1794             // in modular arithmetic, doubling the correct bits in each step.
1795             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1796             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1797             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1798             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1799             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1800             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1801 
1802             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1803             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1804             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1805             // is no longer required.
1806             result = prod0 * inverse;
1807             return result;
1808         }
1809     }
1810 
1811     /// @notice Calculates floor(x*y÷1e18) with full precision.
1812     ///
1813     /// @dev Variant of "mulDiv" with constant folding, i.e. in which the denominator is always 1e18. Before returning the
1814     /// final result, we add 1 if (x * y) % SCALE >= HALF_SCALE. Without this, 6.6e-19 would be truncated to 0 instead of
1815     /// being rounded to 1e-18.  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717.
1816     ///
1817     /// Requirements:
1818     /// - The result must fit within uint256.
1819     ///
1820     /// Caveats:
1821     /// - The body is purposely left uncommented; see the NatSpec comments in "PRBMath.mulDiv" to understand how this works.
1822     /// - It is assumed that the result can never be type(uint256).max when x and y solve the following two equations:
1823     ///     1. x * y = type(uint256).max * SCALE
1824     ///     2. (x * y) % SCALE >= SCALE / 2
1825     ///
1826     /// @param x The multiplicand as an unsigned 60.18-decimal fixed-point number.
1827     /// @param y The multiplier as an unsigned 60.18-decimal fixed-point number.
1828     /// @return result The result as an unsigned 60.18-decimal fixed-point number.
1829     function mulDivFixedPoint(uint256 x, uint256 y) internal pure returns (uint256 result) {
1830         uint256 prod0;
1831         uint256 prod1;
1832         assembly {
1833             let mm := mulmod(x, y, not(0))
1834             prod0 := mul(x, y)
1835             prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1836         }
1837 
1838         if (prod1 >= SCALE) {
1839             revert PRBMath__MulDivFixedPointOverflow(prod1);
1840         }
1841 
1842         uint256 remainder;
1843         uint256 roundUpUnit;
1844         assembly {
1845             remainder := mulmod(x, y, SCALE)
1846             roundUpUnit := gt(remainder, 499999999999999999)
1847         }
1848 
1849         if (prod1 == 0) {
1850             unchecked {
1851                 result = (prod0 / SCALE) + roundUpUnit;
1852                 return result;
1853             }
1854         }
1855 
1856         assembly {
1857             result := add(
1858                 mul(
1859                     or(
1860                         div(sub(prod0, remainder), SCALE_LPOTD),
1861                         mul(sub(prod1, gt(remainder, prod0)), add(div(sub(0, SCALE_LPOTD), SCALE_LPOTD), 1))
1862                     ),
1863                     SCALE_INVERSE
1864                 ),
1865                 roundUpUnit
1866             )
1867         }
1868     }
1869 
1870     /// @notice Calculates floor(x*y÷denominator) with full precision.
1871     ///
1872     /// @dev An extension of "mulDiv" for signed numbers. Works by computing the signs and the absolute values separately.
1873     ///
1874     /// Requirements:
1875     /// - None of the inputs can be type(int256).min.
1876     /// - The result must fit within int256.
1877     ///
1878     /// @param x The multiplicand as an int256.
1879     /// @param y The multiplier as an int256.
1880     /// @param denominator The divisor as an int256.
1881     /// @return result The result as an int256.
1882     function mulDivSigned(
1883         int256 x,
1884         int256 y,
1885         int256 denominator
1886     ) internal pure returns (int256 result) {
1887         if (x == type(int256).min || y == type(int256).min || denominator == type(int256).min) {
1888             revert PRBMath__MulDivSignedInputTooSmall();
1889         }
1890 
1891         // Get hold of the absolute values of x, y and the denominator.
1892         uint256 ax;
1893         uint256 ay;
1894         uint256 ad;
1895         unchecked {
1896             ax = x < 0 ? uint256(-x) : uint256(x);
1897             ay = y < 0 ? uint256(-y) : uint256(y);
1898             ad = denominator < 0 ? uint256(-denominator) : uint256(denominator);
1899         }
1900 
1901         // Compute the absolute value of (x*y)÷denominator. The result must fit within int256.
1902         uint256 rAbs = mulDiv(ax, ay, ad);
1903         if (rAbs > uint256(type(int256).max)) {
1904             revert PRBMath__MulDivSignedOverflow(rAbs);
1905         }
1906 
1907         // Get the signs of x, y and the denominator.
1908         uint256 sx;
1909         uint256 sy;
1910         uint256 sd;
1911         assembly {
1912             sx := sgt(x, sub(0, 1))
1913             sy := sgt(y, sub(0, 1))
1914             sd := sgt(denominator, sub(0, 1))
1915         }
1916 
1917         // XOR over sx, sy and sd. This is checking whether there are one or three negative signs in the inputs.
1918         // If yes, the result should be negative.
1919         result = sx ^ sy ^ sd == 0 ? -int256(rAbs) : int256(rAbs);
1920     }
1921 
1922     /// @notice Calculates the square root of x, rounding down.
1923     /// @dev Uses the Babylonian method https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method.
1924     ///
1925     /// Caveats:
1926     /// - This function does not work with fixed-point numbers.
1927     ///
1928     /// @param x The uint256 number for which to calculate the square root.
1929     /// @return result The result as an uint256.
1930     function sqrt(uint256 x) internal pure returns (uint256 result) {
1931         if (x == 0) {
1932             return 0;
1933         }
1934 
1935         // Set the initial guess to the closest power of two that is higher than x.
1936         uint256 xAux = uint256(x);
1937         result = 1;
1938         if (xAux >= 0x100000000000000000000000000000000) {
1939             xAux >>= 128;
1940             result <<= 64;
1941         }
1942         if (xAux >= 0x10000000000000000) {
1943             xAux >>= 64;
1944             result <<= 32;
1945         }
1946         if (xAux >= 0x100000000) {
1947             xAux >>= 32;
1948             result <<= 16;
1949         }
1950         if (xAux >= 0x10000) {
1951             xAux >>= 16;
1952             result <<= 8;
1953         }
1954         if (xAux >= 0x100) {
1955             xAux >>= 8;
1956             result <<= 4;
1957         }
1958         if (xAux >= 0x10) {
1959             xAux >>= 4;
1960             result <<= 2;
1961         }
1962         if (xAux >= 0x8) {
1963             result <<= 1;
1964         }
1965 
1966         // The operations can never overflow because the result is max 2^127 when it enters this block.
1967         unchecked {
1968             result = (result + x / result) >> 1;
1969             result = (result + x / result) >> 1;
1970             result = (result + x / result) >> 1;
1971             result = (result + x / result) >> 1;
1972             result = (result + x / result) >> 1;
1973             result = (result + x / result) >> 1;
1974             result = (result + x / result) >> 1; // Seven iterations should be enough
1975             uint256 roundedDownResult = x / result;
1976             return result >= roundedDownResult ? roundedDownResult : result;
1977         }
1978     }
1979 }
1980 
1981 // File: prb-math/contracts/PRBMathUD60x18.sol
1982 
1983 
1984 pragma solidity >=0.8.4;
1985 
1986 
1987 /// @title PRBMathUD60x18
1988 /// @author Paul Razvan Berg
1989 /// @notice Smart contract library for advanced fixed-point math that works with uint256 numbers considered to have 18
1990 /// trailing decimals. We call this number representation unsigned 60.18-decimal fixed-point, since there can be up to 60
1991 /// digits in the integer part and up to 18 decimals in the fractional part. The numbers are bound by the minimum and the
1992 /// maximum values permitted by the Solidity type uint256.
1993 library PRBMathUD60x18 {
1994     /// @dev Half the SCALE number.
1995     uint256 internal constant HALF_SCALE = 5e17;
1996 
1997     /// @dev log2(e) as an unsigned 60.18-decimal fixed-point number.
1998     uint256 internal constant LOG2_E = 1_442695040888963407;
1999 
2000     /// @dev The maximum value an unsigned 60.18-decimal fixed-point number can have.
2001     uint256 internal constant MAX_UD60x18 =
2002         115792089237316195423570985008687907853269984665640564039457_584007913129639935;
2003 
2004     /// @dev The maximum whole value an unsigned 60.18-decimal fixed-point number can have.
2005     uint256 internal constant MAX_WHOLE_UD60x18 =
2006         115792089237316195423570985008687907853269984665640564039457_000000000000000000;
2007 
2008     /// @dev How many trailing decimals can be represented.
2009     uint256 internal constant SCALE = 1e18;
2010 
2011     /// @notice Calculates the arithmetic average of x and y, rounding down.
2012     /// @param x The first operand as an unsigned 60.18-decimal fixed-point number.
2013     /// @param y The second operand as an unsigned 60.18-decimal fixed-point number.
2014     /// @return result The arithmetic average as an unsigned 60.18-decimal fixed-point number.
2015     function avg(uint256 x, uint256 y) internal pure returns (uint256 result) {
2016         // The operations can never overflow.
2017         unchecked {
2018             // The last operand checks if both x and y are odd and if that is the case, we add 1 to the result. We need
2019             // to do this because if both numbers are odd, the 0.5 remainder gets truncated twice.
2020             result = (x >> 1) + (y >> 1) + (x & y & 1);
2021         }
2022     }
2023 
2024     /// @notice Yields the least unsigned 60.18 decimal fixed-point number greater than or equal to x.
2025     ///
2026     /// @dev Optimized for fractional value inputs, because for every whole value there are (1e18 - 1) fractional counterparts.
2027     /// See https://en.wikipedia.org/wiki/Floor_and_ceiling_functions.
2028     ///
2029     /// Requirements:
2030     /// - x must be less than or equal to MAX_WHOLE_UD60x18.
2031     ///
2032     /// @param x The unsigned 60.18-decimal fixed-point number to ceil.
2033     /// @param result The least integer greater than or equal to x, as an unsigned 60.18-decimal fixed-point number.
2034     function ceil(uint256 x) internal pure returns (uint256 result) {
2035         if (x > MAX_WHOLE_UD60x18) {
2036             revert PRBMathUD60x18__CeilOverflow(x);
2037         }
2038         assembly {
2039             // Equivalent to "x % SCALE" but faster.
2040             let remainder := mod(x, SCALE)
2041 
2042             // Equivalent to "SCALE - remainder" but faster.
2043             let delta := sub(SCALE, remainder)
2044 
2045             // Equivalent to "x + delta * (remainder > 0 ? 1 : 0)" but faster.
2046             result := add(x, mul(delta, gt(remainder, 0)))
2047         }
2048     }
2049 
2050     /// @notice Divides two unsigned 60.18-decimal fixed-point numbers, returning a new unsigned 60.18-decimal fixed-point number.
2051     ///
2052     /// @dev Uses mulDiv to enable overflow-safe multiplication and division.
2053     ///
2054     /// Requirements:
2055     /// - The denominator cannot be zero.
2056     ///
2057     /// @param x The numerator as an unsigned 60.18-decimal fixed-point number.
2058     /// @param y The denominator as an unsigned 60.18-decimal fixed-point number.
2059     /// @param result The quotient as an unsigned 60.18-decimal fixed-point number.
2060     function div(uint256 x, uint256 y) internal pure returns (uint256 result) {
2061         result = PRBMath.mulDiv(x, SCALE, y);
2062     }
2063 
2064     /// @notice Returns Euler's number as an unsigned 60.18-decimal fixed-point number.
2065     /// @dev See https://en.wikipedia.org/wiki/E_(mathematical_constant).
2066     function e() internal pure returns (uint256 result) {
2067         result = 2_718281828459045235;
2068     }
2069 
2070     /// @notice Calculates the natural exponent of x.
2071     ///
2072     /// @dev Based on the insight that e^x = 2^(x * log2(e)).
2073     ///
2074     /// Requirements:
2075     /// - All from "log2".
2076     /// - x must be less than 133.084258667509499441.
2077     ///
2078     /// @param x The exponent as an unsigned 60.18-decimal fixed-point number.
2079     /// @return result The result as an unsigned 60.18-decimal fixed-point number.
2080     function exp(uint256 x) internal pure returns (uint256 result) {
2081         // Without this check, the value passed to "exp2" would be greater than 192.
2082         if (x >= 133_084258667509499441) {
2083             revert PRBMathUD60x18__ExpInputTooBig(x);
2084         }
2085 
2086         // Do the fixed-point multiplication inline to save gas.
2087         unchecked {
2088             uint256 doubleScaleProduct = x * LOG2_E;
2089             result = exp2((doubleScaleProduct + HALF_SCALE) / SCALE);
2090         }
2091     }
2092 
2093     /// @notice Calculates the binary exponent of x using the binary fraction method.
2094     ///
2095     /// @dev See https://ethereum.stackexchange.com/q/79903/24693.
2096     ///
2097     /// Requirements:
2098     /// - x must be 192 or less.
2099     /// - The result must fit within MAX_UD60x18.
2100     ///
2101     /// @param x The exponent as an unsigned 60.18-decimal fixed-point number.
2102     /// @return result The result as an unsigned 60.18-decimal fixed-point number.
2103     function exp2(uint256 x) internal pure returns (uint256 result) {
2104         // 2^192 doesn't fit within the 192.64-bit format used internally in this function.
2105         if (x >= 192e18) {
2106             revert PRBMathUD60x18__Exp2InputTooBig(x);
2107         }
2108 
2109         unchecked {
2110             // Convert x to the 192.64-bit fixed-point format.
2111             uint256 x192x64 = (x << 64) / SCALE;
2112 
2113             // Pass x to the PRBMath.exp2 function, which uses the 192.64-bit fixed-point number representation.
2114             result = PRBMath.exp2(x192x64);
2115         }
2116     }
2117 
2118     /// @notice Yields the greatest unsigned 60.18 decimal fixed-point number less than or equal to x.
2119     /// @dev Optimized for fractional value inputs, because for every whole value there are (1e18 - 1) fractional counterparts.
2120     /// See https://en.wikipedia.org/wiki/Floor_and_ceiling_functions.
2121     /// @param x The unsigned 60.18-decimal fixed-point number to floor.
2122     /// @param result The greatest integer less than or equal to x, as an unsigned 60.18-decimal fixed-point number.
2123     function floor(uint256 x) internal pure returns (uint256 result) {
2124         assembly {
2125             // Equivalent to "x % SCALE" but faster.
2126             let remainder := mod(x, SCALE)
2127 
2128             // Equivalent to "x - remainder * (remainder > 0 ? 1 : 0)" but faster.
2129             result := sub(x, mul(remainder, gt(remainder, 0)))
2130         }
2131     }
2132 
2133     /// @notice Yields the excess beyond the floor of x.
2134     /// @dev Based on the odd function definition https://en.wikipedia.org/wiki/Fractional_part.
2135     /// @param x The unsigned 60.18-decimal fixed-point number to get the fractional part of.
2136     /// @param result The fractional part of x as an unsigned 60.18-decimal fixed-point number.
2137     function frac(uint256 x) internal pure returns (uint256 result) {
2138         assembly {
2139             result := mod(x, SCALE)
2140         }
2141     }
2142 
2143     /// @notice Converts a number from basic integer form to unsigned 60.18-decimal fixed-point representation.
2144     ///
2145     /// @dev Requirements:
2146     /// - x must be less than or equal to MAX_UD60x18 divided by SCALE.
2147     ///
2148     /// @param x The basic integer to convert.
2149     /// @param result The same number in unsigned 60.18-decimal fixed-point representation.
2150     function fromUint(uint256 x) internal pure returns (uint256 result) {
2151         unchecked {
2152             if (x > MAX_UD60x18 / SCALE) {
2153                 revert PRBMathUD60x18__FromUintOverflow(x);
2154             }
2155             result = x * SCALE;
2156         }
2157     }
2158 
2159     /// @notice Calculates geometric mean of x and y, i.e. sqrt(x * y), rounding down.
2160     ///
2161     /// @dev Requirements:
2162     /// - x * y must fit within MAX_UD60x18, lest it overflows.
2163     ///
2164     /// @param x The first operand as an unsigned 60.18-decimal fixed-point number.
2165     /// @param y The second operand as an unsigned 60.18-decimal fixed-point number.
2166     /// @return result The result as an unsigned 60.18-decimal fixed-point number.
2167     function gm(uint256 x, uint256 y) internal pure returns (uint256 result) {
2168         if (x == 0) {
2169             return 0;
2170         }
2171 
2172         unchecked {
2173             // Checking for overflow this way is faster than letting Solidity do it.
2174             uint256 xy = x * y;
2175             if (xy / x != y) {
2176                 revert PRBMathUD60x18__GmOverflow(x, y);
2177             }
2178 
2179             // We don't need to multiply by the SCALE here because the x*y product had already picked up a factor of SCALE
2180             // during multiplication. See the comments within the "sqrt" function.
2181             result = PRBMath.sqrt(xy);
2182         }
2183     }
2184 
2185     /// @notice Calculates 1 / x, rounding toward zero.
2186     ///
2187     /// @dev Requirements:
2188     /// - x cannot be zero.
2189     ///
2190     /// @param x The unsigned 60.18-decimal fixed-point number for which to calculate the inverse.
2191     /// @return result The inverse as an unsigned 60.18-decimal fixed-point number.
2192     function inv(uint256 x) internal pure returns (uint256 result) {
2193         unchecked {
2194             // 1e36 is SCALE * SCALE.
2195             result = 1e36 / x;
2196         }
2197     }
2198 
2199     /// @notice Calculates the natural logarithm of x.
2200     ///
2201     /// @dev Based on the insight that ln(x) = log2(x) / log2(e).
2202     ///
2203     /// Requirements:
2204     /// - All from "log2".
2205     ///
2206     /// Caveats:
2207     /// - All from "log2".
2208     /// - This doesn't return exactly 1 for 2.718281828459045235, for that we would need more fine-grained precision.
2209     ///
2210     /// @param x The unsigned 60.18-decimal fixed-point number for which to calculate the natural logarithm.
2211     /// @return result The natural logarithm as an unsigned 60.18-decimal fixed-point number.
2212     function ln(uint256 x) internal pure returns (uint256 result) {
2213         // Do the fixed-point multiplication inline to save gas. This is overflow-safe because the maximum value that log2(x)
2214         // can return is 196205294292027477728.
2215         unchecked {
2216             result = (log2(x) * SCALE) / LOG2_E;
2217         }
2218     }
2219 
2220     /// @notice Calculates the common logarithm of x.
2221     ///
2222     /// @dev First checks if x is an exact power of ten and it stops if yes. If it's not, calculates the common
2223     /// logarithm based on the insight that log10(x) = log2(x) / log2(10).
2224     ///
2225     /// Requirements:
2226     /// - All from "log2".
2227     ///
2228     /// Caveats:
2229     /// - All from "log2".
2230     ///
2231     /// @param x The unsigned 60.18-decimal fixed-point number for which to calculate the common logarithm.
2232     /// @return result The common logarithm as an unsigned 60.18-decimal fixed-point number.
2233     function log10(uint256 x) internal pure returns (uint256 result) {
2234         if (x < SCALE) {
2235             revert PRBMathUD60x18__LogInputTooSmall(x);
2236         }
2237 
2238         // Note that the "mul" in this block is the assembly multiplication operation, not the "mul" function defined
2239         // in this contract.
2240         // prettier-ignore
2241         assembly {
2242             switch x
2243             case 1 { result := mul(SCALE, sub(0, 18)) }
2244             case 10 { result := mul(SCALE, sub(1, 18)) }
2245             case 100 { result := mul(SCALE, sub(2, 18)) }
2246             case 1000 { result := mul(SCALE, sub(3, 18)) }
2247             case 10000 { result := mul(SCALE, sub(4, 18)) }
2248             case 100000 { result := mul(SCALE, sub(5, 18)) }
2249             case 1000000 { result := mul(SCALE, sub(6, 18)) }
2250             case 10000000 { result := mul(SCALE, sub(7, 18)) }
2251             case 100000000 { result := mul(SCALE, sub(8, 18)) }
2252             case 1000000000 { result := mul(SCALE, sub(9, 18)) }
2253             case 10000000000 { result := mul(SCALE, sub(10, 18)) }
2254             case 100000000000 { result := mul(SCALE, sub(11, 18)) }
2255             case 1000000000000 { result := mul(SCALE, sub(12, 18)) }
2256             case 10000000000000 { result := mul(SCALE, sub(13, 18)) }
2257             case 100000000000000 { result := mul(SCALE, sub(14, 18)) }
2258             case 1000000000000000 { result := mul(SCALE, sub(15, 18)) }
2259             case 10000000000000000 { result := mul(SCALE, sub(16, 18)) }
2260             case 100000000000000000 { result := mul(SCALE, sub(17, 18)) }
2261             case 1000000000000000000 { result := 0 }
2262             case 10000000000000000000 { result := SCALE }
2263             case 100000000000000000000 { result := mul(SCALE, 2) }
2264             case 1000000000000000000000 { result := mul(SCALE, 3) }
2265             case 10000000000000000000000 { result := mul(SCALE, 4) }
2266             case 100000000000000000000000 { result := mul(SCALE, 5) }
2267             case 1000000000000000000000000 { result := mul(SCALE, 6) }
2268             case 10000000000000000000000000 { result := mul(SCALE, 7) }
2269             case 100000000000000000000000000 { result := mul(SCALE, 8) }
2270             case 1000000000000000000000000000 { result := mul(SCALE, 9) }
2271             case 10000000000000000000000000000 { result := mul(SCALE, 10) }
2272             case 100000000000000000000000000000 { result := mul(SCALE, 11) }
2273             case 1000000000000000000000000000000 { result := mul(SCALE, 12) }
2274             case 10000000000000000000000000000000 { result := mul(SCALE, 13) }
2275             case 100000000000000000000000000000000 { result := mul(SCALE, 14) }
2276             case 1000000000000000000000000000000000 { result := mul(SCALE, 15) }
2277             case 10000000000000000000000000000000000 { result := mul(SCALE, 16) }
2278             case 100000000000000000000000000000000000 { result := mul(SCALE, 17) }
2279             case 1000000000000000000000000000000000000 { result := mul(SCALE, 18) }
2280             case 10000000000000000000000000000000000000 { result := mul(SCALE, 19) }
2281             case 100000000000000000000000000000000000000 { result := mul(SCALE, 20) }
2282             case 1000000000000000000000000000000000000000 { result := mul(SCALE, 21) }
2283             case 10000000000000000000000000000000000000000 { result := mul(SCALE, 22) }
2284             case 100000000000000000000000000000000000000000 { result := mul(SCALE, 23) }
2285             case 1000000000000000000000000000000000000000000 { result := mul(SCALE, 24) }
2286             case 10000000000000000000000000000000000000000000 { result := mul(SCALE, 25) }
2287             case 100000000000000000000000000000000000000000000 { result := mul(SCALE, 26) }
2288             case 1000000000000000000000000000000000000000000000 { result := mul(SCALE, 27) }
2289             case 10000000000000000000000000000000000000000000000 { result := mul(SCALE, 28) }
2290             case 100000000000000000000000000000000000000000000000 { result := mul(SCALE, 29) }
2291             case 1000000000000000000000000000000000000000000000000 { result := mul(SCALE, 30) }
2292             case 10000000000000000000000000000000000000000000000000 { result := mul(SCALE, 31) }
2293             case 100000000000000000000000000000000000000000000000000 { result := mul(SCALE, 32) }
2294             case 1000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 33) }
2295             case 10000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 34) }
2296             case 100000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 35) }
2297             case 1000000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 36) }
2298             case 10000000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 37) }
2299             case 100000000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 38) }
2300             case 1000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 39) }
2301             case 10000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 40) }
2302             case 100000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 41) }
2303             case 1000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 42) }
2304             case 10000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 43) }
2305             case 100000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 44) }
2306             case 1000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 45) }
2307             case 10000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 46) }
2308             case 100000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 47) }
2309             case 1000000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 48) }
2310             case 10000000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 49) }
2311             case 100000000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 50) }
2312             case 1000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 51) }
2313             case 10000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 52) }
2314             case 100000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 53) }
2315             case 1000000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 54) }
2316             case 10000000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 55) }
2317             case 100000000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 56) }
2318             case 1000000000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 57) }
2319             case 10000000000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 58) }
2320             case 100000000000000000000000000000000000000000000000000000000000000000000000000000 { result := mul(SCALE, 59) }
2321             default {
2322                 result := MAX_UD60x18
2323             }
2324         }
2325 
2326         if (result == MAX_UD60x18) {
2327             // Do the fixed-point division inline to save gas. The denominator is log2(10).
2328             unchecked {
2329                 result = (log2(x) * SCALE) / 3_321928094887362347;
2330             }
2331         }
2332     }
2333 
2334     /// @notice Calculates the binary logarithm of x.
2335     ///
2336     /// @dev Based on the iterative approximation algorithm.
2337     /// https://en.wikipedia.org/wiki/Binary_logarithm#Iterative_approximation
2338     ///
2339     /// Requirements:
2340     /// - x must be greater than or equal to SCALE, otherwise the result would be negative.
2341     ///
2342     /// Caveats:
2343     /// - The results are nor perfectly accurate to the last decimal, due to the lossy precision of the iterative approximation.
2344     ///
2345     /// @param x The unsigned 60.18-decimal fixed-point number for which to calculate the binary logarithm.
2346     /// @return result The binary logarithm as an unsigned 60.18-decimal fixed-point number.
2347     function log2(uint256 x) internal pure returns (uint256 result) {
2348         if (x < SCALE) {
2349             revert PRBMathUD60x18__LogInputTooSmall(x);
2350         }
2351         unchecked {
2352             // Calculate the integer part of the logarithm and add it to the result and finally calculate y = x * 2^(-n).
2353             uint256 n = PRBMath.mostSignificantBit(x / SCALE);
2354 
2355             // The integer part of the logarithm as an unsigned 60.18-decimal fixed-point number. The operation can't overflow
2356             // because n is maximum 255 and SCALE is 1e18.
2357             result = n * SCALE;
2358 
2359             // This is y = x * 2^(-n).
2360             uint256 y = x >> n;
2361 
2362             // If y = 1, the fractional part is zero.
2363             if (y == SCALE) {
2364                 return result;
2365             }
2366 
2367             // Calculate the fractional part via the iterative approximation.
2368             // The "delta >>= 1" part is equivalent to "delta /= 2", but shifting bits is faster.
2369             for (uint256 delta = HALF_SCALE; delta > 0; delta >>= 1) {
2370                 y = (y * y) / SCALE;
2371 
2372                 // Is y^2 > 2 and so in the range [2,4)?
2373                 if (y >= 2 * SCALE) {
2374                     // Add the 2^(-m) factor to the logarithm.
2375                     result += delta;
2376 
2377                     // Corresponds to z/2 on Wikipedia.
2378                     y >>= 1;
2379                 }
2380             }
2381         }
2382     }
2383 
2384     /// @notice Multiplies two unsigned 60.18-decimal fixed-point numbers together, returning a new unsigned 60.18-decimal
2385     /// fixed-point number.
2386     /// @dev See the documentation for the "PRBMath.mulDivFixedPoint" function.
2387     /// @param x The multiplicand as an unsigned 60.18-decimal fixed-point number.
2388     /// @param y The multiplier as an unsigned 60.18-decimal fixed-point number.
2389     /// @return result The product as an unsigned 60.18-decimal fixed-point number.
2390     function mul(uint256 x, uint256 y) internal pure returns (uint256 result) {
2391         result = PRBMath.mulDivFixedPoint(x, y);
2392     }
2393 
2394     /// @notice Returns PI as an unsigned 60.18-decimal fixed-point number.
2395     function pi() internal pure returns (uint256 result) {
2396         result = 3_141592653589793238;
2397     }
2398 
2399     /// @notice Raises x to the power of y.
2400     ///
2401     /// @dev Based on the insight that x^y = 2^(log2(x) * y).
2402     ///
2403     /// Requirements:
2404     /// - All from "exp2", "log2" and "mul".
2405     ///
2406     /// Caveats:
2407     /// - All from "exp2", "log2" and "mul".
2408     /// - Assumes 0^0 is 1.
2409     ///
2410     /// @param x Number to raise to given power y, as an unsigned 60.18-decimal fixed-point number.
2411     /// @param y Exponent to raise x to, as an unsigned 60.18-decimal fixed-point number.
2412     /// @return result x raised to power y, as an unsigned 60.18-decimal fixed-point number.
2413     function pow(uint256 x, uint256 y) internal pure returns (uint256 result) {
2414         if (x == 0) {
2415             result = y == 0 ? SCALE : uint256(0);
2416         } else {
2417             result = exp2(mul(log2(x), y));
2418         }
2419     }
2420 
2421     /// @notice Raises x (unsigned 60.18-decimal fixed-point number) to the power of y (basic unsigned integer) using the
2422     /// famous algorithm "exponentiation by squaring".
2423     ///
2424     /// @dev See https://en.wikipedia.org/wiki/Exponentiation_by_squaring
2425     ///
2426     /// Requirements:
2427     /// - The result must fit within MAX_UD60x18.
2428     ///
2429     /// Caveats:
2430     /// - All from "mul".
2431     /// - Assumes 0^0 is 1.
2432     ///
2433     /// @param x The base as an unsigned 60.18-decimal fixed-point number.
2434     /// @param y The exponent as an uint256.
2435     /// @return result The result as an unsigned 60.18-decimal fixed-point number.
2436     function powu(uint256 x, uint256 y) internal pure returns (uint256 result) {
2437         // Calculate the first iteration of the loop in advance.
2438         result = y & 1 > 0 ? x : SCALE;
2439 
2440         // Equivalent to "for(y /= 2; y > 0; y /= 2)" but faster.
2441         for (y >>= 1; y > 0; y >>= 1) {
2442             x = PRBMath.mulDivFixedPoint(x, x);
2443 
2444             // Equivalent to "y % 2 == 1" but faster.
2445             if (y & 1 > 0) {
2446                 result = PRBMath.mulDivFixedPoint(result, x);
2447             }
2448         }
2449     }
2450 
2451     /// @notice Returns 1 as an unsigned 60.18-decimal fixed-point number.
2452     function scale() internal pure returns (uint256 result) {
2453         result = SCALE;
2454     }
2455 
2456     /// @notice Calculates the square root of x, rounding down.
2457     /// @dev Uses the Babylonian method https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method.
2458     ///
2459     /// Requirements:
2460     /// - x must be less than MAX_UD60x18 / SCALE.
2461     ///
2462     /// @param x The unsigned 60.18-decimal fixed-point number for which to calculate the square root.
2463     /// @return result The result as an unsigned 60.18-decimal fixed-point .
2464     function sqrt(uint256 x) internal pure returns (uint256 result) {
2465         unchecked {
2466             if (x > MAX_UD60x18 / SCALE) {
2467                 revert PRBMathUD60x18__SqrtOverflow(x);
2468             }
2469             // Multiply x by the SCALE to account for the factor of SCALE that is picked up when multiplying two unsigned
2470             // 60.18-decimal fixed-point numbers together (in this case, those two numbers are both the square root).
2471             result = PRBMath.sqrt(x * SCALE);
2472         }
2473     }
2474 
2475     /// @notice Converts a unsigned 60.18-decimal fixed-point number to basic integer form, rounding down in the process.
2476     /// @param x The unsigned 60.18-decimal fixed-point number to convert.
2477     /// @return result The same number in basic integer form.
2478     function toUint(uint256 x) internal pure returns (uint256 result) {
2479         unchecked {
2480             result = x / SCALE;
2481         }
2482     }
2483 }
2484 
2485 // File: contracts/Jesus.sol
2486 
2487 
2488 
2489 pragma solidity ^0.8.0;
2490 
2491 
2492 
2493 
2494 
2495 
2496 
2497 contract Jesus is ERC721, Ownable, DeveloperAccess, ReentrancyGuard {
2498     using PRBMathUD60x18 for uint256;
2499 
2500     uint256 constant private _developerEquity = 50000000000000000; // 5% (18 decimals)
2501     uint256 private _totalVolume;
2502     uint256 private _developerWithdrawn;
2503 
2504     uint256 public mintPrice;
2505 
2506     constructor(
2507         address devAddress,
2508         uint16 maxSupply,
2509         uint256 price,
2510         address signer,
2511         uint256 presaleMintStart,
2512         uint256 presaleMintEnd,
2513         uint16 maxPresale,
2514         uint256 publicMintStart,
2515         uint16 publicTransactionMax
2516     ) ERC721("Jesus", "JESUS") DeveloperAccess(devAddress) {
2517         require(maxSupply > 0, "Zero supply");
2518 
2519         // GLOBALS
2520         mintSigner = signer;
2521         totalSupply = maxSupply;
2522         mintPrice = price;
2523 
2524         // CONFIGURE PRESALE Mint
2525         presaleMint.startDate = presaleMintStart;
2526         presaleMint.endDate = presaleMintEnd;
2527         presaleMint.maxMinted = maxPresale;
2528 
2529         // CONFIGURE PUBLIC MINT
2530         publicMint.startDate = publicMintStart;
2531         publicMint.maxPerTransaction = publicTransactionMax;
2532     }
2533 
2534     event Paid(address sender, uint256 amount);
2535     event Withdraw(address recipient, uint256 amount);
2536 
2537     struct WhitelistedMint {
2538         /**
2539          * The start date in unix seconds
2540          */
2541         uint256 startDate;
2542         /**
2543          * The end date in unix seconds
2544          */
2545         uint256 endDate;
2546         /**
2547          * The total number of tokens minted in this whitelist
2548          */
2549         uint16 totalMinted;
2550         /**
2551          * The maximum number of tokens minted in this whitelist
2552          */
2553         uint16 maxMinted;
2554         /**
2555          * The minters in this whitelisted mint
2556          * mapped to the number minted
2557          */
2558         mapping(address => uint16) minted;
2559     }
2560 
2561     struct PublicMint {
2562         /**
2563          * The start date in unix seconds
2564          */
2565         uint256 startDate;
2566         /**
2567          * The maximum per transaction
2568          */
2569         uint16 maxPerTransaction;
2570     }
2571 
2572     string baseURI;
2573 
2574     uint16 public totalSupply;
2575     uint16 public minted;
2576 
2577     address private mintSigner;
2578     mapping(address => uint16) public lastMintNonce;
2579 
2580     /**
2581      * An exclusive mint for members granted
2582      * presale
2583      */
2584     WhitelistedMint public presaleMint;
2585 
2586     /**
2587      * The public mint for everybody.
2588      */
2589     PublicMint public publicMint;
2590 
2591     /**
2592      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2593      * token will be the concatenation of the `baseURI` and the `tokenId`.
2594      */
2595     function _baseURI() internal view virtual override returns (string memory) {
2596         return baseURI;
2597     }
2598 
2599     /**
2600      * Sets the base URI for all tokens
2601      *
2602      * @dev be sure to terminate with a slash
2603      * @param uri - the target base uri (ex: 'https://google.com/')
2604      */
2605     function setBaseURI(string calldata uri) public onlyOwner {
2606         baseURI = uri;
2607     }
2608 
2609     /**
2610      * Sets the signer for presale transactions
2611      *
2612      * @param signer - the new signer's address
2613      */
2614     function setSigner(address signer) public onlyOwner {
2615         mintSigner = signer;
2616     }
2617 
2618     /**
2619      * Burns the provided token id if you own it.
2620      * Reduces the supply by 1.
2621      *
2622      * @param tokenId - the ID of the token to be burned.
2623      */
2624     function burn(uint256 tokenId) public {
2625         require(ownerOf(tokenId) == msg.sender, "You do not own this token");
2626 
2627         _burn(tokenId);
2628     }
2629 
2630     // ------------------------------------------------ MINT STUFFS ------------------------------------------------
2631 
2632     function getPresaleMints(address user)
2633         external
2634         view
2635         returns (uint16)
2636     {
2637         return presaleMint.minted[user];
2638     }
2639 
2640     function updateMintPrice(
2641         uint256 price
2642     ) public onlyOwner {
2643         mintPrice = price;
2644     }
2645 
2646     /**
2647      * Updates the presale mint's characteristics
2648      *
2649      * @param startDate - the start date for that mint in UNIX seconds
2650      * @param endDate - the end date for that mint in UNIX seconds
2651      */
2652     function updatePresaleMint(
2653         uint256 startDate,
2654         uint256 endDate,
2655         uint16 maxMinted
2656     ) public onlyOwner {
2657         presaleMint.startDate = startDate;
2658         presaleMint.endDate = endDate;
2659         presaleMint.maxMinted = maxMinted;
2660     }
2661 
2662     /**
2663      * Updates the public mint's characteristics
2664      *
2665      * @param maxPerTransaction - the maximum amount allowed in a wallet to mint in the public mint
2666      * @param startDate - the start date for that mint in UNIX seconds
2667      */
2668     function updatePublicMint(
2669         uint16 maxPerTransaction,
2670         uint256 startDate
2671     ) public onlyOwner {
2672         publicMint.maxPerTransaction = maxPerTransaction;
2673         publicMint.startDate = startDate;
2674     }
2675 
2676     function getPremintHash(
2677         address minter,
2678         uint16 quantity,
2679         uint16 nonce
2680     ) public pure returns (bytes32) {
2681         return VerifySignature.getMessageHash(minter, quantity, nonce);
2682     }
2683 
2684     /**
2685      * Mints in the premint stage by using a signed transaction from a centralized whitelist.
2686      * The message signer is expected to only sign messages when they fall within the whitelist
2687      * specifications.
2688      *
2689      * @param quantity - the number to mint
2690      * @param nonce - a random nonce which indicates that a signed transaction hasn't already been used.
2691      * @param signature - the signature given by the centralized whitelist authority, signed by
2692      *                    the account specified as mintSigner.
2693      */
2694     function premint(
2695         uint16 quantity,
2696         uint16 nonce,
2697         bytes calldata signature
2698     ) public payable nonReentrant {
2699         uint256 remaining = totalSupply - minted;
2700 
2701         require(remaining > 0, "Mint over");
2702         require(quantity >= 1, "Zero mint");
2703         require(quantity <= remaining, "Not enough");
2704         require(lastMintNonce[msg.sender] < nonce, "Nonce used");
2705 
2706         require(
2707             presaleMint.startDate <= block.timestamp &&
2708                 presaleMint.endDate >= block.timestamp,
2709             "No mint"
2710         );
2711         require(
2712             VerifySignature.verify(
2713                 mintSigner,
2714                 msg.sender,
2715                 quantity,
2716                 nonce,
2717                 signature
2718             ),
2719             "Invalid sig"
2720         );
2721         require(mintPrice * quantity == msg.value, "Bad value");
2722         require(
2723             presaleMint.totalMinted + quantity <= presaleMint.maxMinted,
2724             "Limit exceeded"
2725         );
2726 
2727         presaleMint.minted[msg.sender] += quantity;
2728         presaleMint.totalMinted += quantity;
2729         lastMintNonce[msg.sender] = nonce; // update nonce
2730 
2731         _totalVolume += msg.value;
2732 
2733         // DISTRIBUTE THE TOKENS
2734         uint16 i;
2735         for (i; i < quantity; i++) {
2736             minted += 1;
2737             _safeMint(msg.sender, minted);
2738         }
2739     }
2740 
2741     /**
2742      * Mints the given quantity of tokens provided it is possible to.
2743      *
2744      * @notice This function allows minting in the public sale
2745      *         or at any time for the owner of the contract.
2746      *
2747      * @param quantity - the number of tokens to mint
2748      */
2749     function mint(uint16 quantity) public payable nonReentrant {
2750         uint256 remaining = totalSupply - minted;
2751 
2752         require(remaining > 0, "Mint over");
2753         require(quantity >= 1, "Zero mint");
2754         require(quantity <= remaining, "Not enough");
2755 
2756         if (owner() == msg.sender) {
2757             // OWNER MINTING FOR FREE
2758             require(msg.value == 0, "Owner paid");
2759         } else if (block.timestamp >= publicMint.startDate) {
2760             // PUBLIC MINT
2761             require(quantity <= publicMint.maxPerTransaction, "Exceeds max");
2762             require(
2763                 quantity * mintPrice == msg.value,
2764                 "Invalid value"
2765             );
2766         } else {
2767             // NOT ELIGIBLE FOR PUBLIC MINT
2768             revert("No mint");
2769         }
2770 
2771         _totalVolume += msg.value;
2772 
2773         // DISTRIBUTE THE TOKENS
2774         uint16 i;
2775         for (i; i < quantity; i++) {
2776             minted += 1;
2777             _safeMint(msg.sender, minted);
2778         }
2779     }
2780 
2781     function developerAllotment() public view returns (uint256) {
2782         return _developerEquity.mul(_totalVolume) - _developerWithdrawn;
2783     }
2784 
2785     /**
2786      * Withdraws balance from the contract to the owner (sender).
2787      * @param amount - the amount to withdraw, much be <= contract balance and  dev allotment.
2788      */
2789     function withdrawOwner(uint256 amount) external onlyOwner {
2790         require(address(this).balance >= amount + developerAllotment(), "Invalid amt");
2791 
2792         (bool success, ) = msg.sender.call{value: amount}("");
2793         require(success, "Trans failed");
2794         emit Withdraw(msg.sender, amount);
2795     }
2796 
2797     /**
2798      * Withdraws balance from the contract to the developer (sender).
2799      * @param amount - the amount to withdraw, much be <= contract balance.
2800      */
2801     function withdrawDeveloper(uint256 amount) external onlyDeveloper {
2802         uint256 devAllotment = developerAllotment();
2803 
2804         require(amount <= devAllotment, "Invalid amt");
2805 
2806         _developerWithdrawn += amount;
2807         (bool success, ) = msg.sender.call{value: amount}("");
2808         require(success, "Trans failed");
2809         emit Withdraw(msg.sender, amount);
2810     }
2811 
2812     /**
2813      * The receive function, does nothing
2814      */
2815     receive() external payable {
2816         _totalVolume += msg.value;
2817         emit Paid(msg.sender, msg.value);
2818     }
2819 }