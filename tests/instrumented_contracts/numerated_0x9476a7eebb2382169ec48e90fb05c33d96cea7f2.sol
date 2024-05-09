1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 library ECDSA {
5     /**
6      * @dev Returns the address that signed a hashed message (`hash`) with
7      * `signature`. This address can then be used for verification purposes.
8      *
9      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
10      * this function rejects them by requiring the `s` value to be in the lower
11      * half order, and the `v` value to be either 27 or 28.
12      *
13      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
14      * verification to be secure: it is possible to craft signatures that
15      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
16      * this is by receiving a hash of the original message (which may otherwise
17      * be too long), and then calling {toEthSignedMessageHash} on it.
18      *
19      * Documentation for signature generation:
20      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
21      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
22      */
23     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
24         // Check the signature length
25         // - case 65: r,s,v signature (standard)
26         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
27         if (signature.length == 65) {
28             bytes32 r;
29             bytes32 s;
30             uint8 v;
31             // ecrecover takes the signature parameters, and the only way to get them
32             // currently is to use assembly.
33             assembly {
34                 r := mload(add(signature, 0x20))
35                 s := mload(add(signature, 0x40))
36                 v := byte(0, mload(add(signature, 0x60)))
37             }
38             return recover(hash, v, r, s);
39         } else if (signature.length == 64) {
40             bytes32 r;
41             bytes32 vs;
42             // ecrecover takes the signature parameters, and the only way to get them
43             // currently is to use assembly.
44             assembly {
45                 r := mload(add(signature, 0x20))
46                 vs := mload(add(signature, 0x40))
47             }
48             return recover(hash, r, vs);
49         } else {
50             revert("ECDSA: invalid signature length");
51         }
52     }
53 
54     /**
55      * @dev Overload of {ECDSA-recover} that receives the `r` and `vs` short-signature fields separately.
56      *
57      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
58      *
59      * _Available since v4.2._
60      */
61     function recover(
62         bytes32 hash,
63         bytes32 r,
64         bytes32 vs
65     ) internal pure returns (address) {
66         bytes32 s;
67         uint8 v;
68         assembly {
69             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
70             v := add(shr(255, vs), 27)
71         }
72         return recover(hash, v, r, s);
73     }
74 
75     /**
76      * @dev Overload of {ECDSA-recover} that receives the `v`, `r` and `s` signature fields separately.
77      */
78     function recover(
79         bytes32 hash,
80         uint8 v,
81         bytes32 r,
82         bytes32 s
83     ) internal pure returns (address) {
84         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
85         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
86         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
87         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
88         //
89         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
90         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
91         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
92         // these malleable signatures as well.
93         require(
94             uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0,
95             "ECDSA: invalid signature 's' value"
96         );
97         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
98 
99         // If the signature is valid (and not malleable), return the signer address
100         address signer = ecrecover(hash, v, r, s);
101         require(signer != address(0), "ECDSA: invalid signature");
102 
103         return signer;
104     }
105 
106     /**
107      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
108      * produces hash corresponding to the one signed with the
109      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
110      * JSON-RPC method as part of EIP-191.
111      *
112      * See {recover}.
113      */
114     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
115         // 32 is the length in bytes of hash,
116         // enforced by the type signature above
117         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
118     }
119 
120     /**
121      * @dev Returns an Ethereum Signed Typed Data, created from a
122      * `domainSeparator` and a `structHash`. This produces hash corresponding
123      * to the one signed with the
124      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
125      * JSON-RPC method as part of EIP-712.
126      *
127      * See {recover}.
128      */
129     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
130         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
131     }
132 }
133 
134 library SafeMath {
135     /**
136      * @dev Returns the addition of two unsigned integers, with an overflow flag.
137      *
138      * _Available since v3.4._
139      */
140     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
141         unchecked {
142             uint256 c = a + b;
143             if (c < a) return (false, 0);
144             return (true, c);
145         }
146     }
147 
148     /**
149      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
150      *
151      * _Available since v3.4._
152      */
153     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
154         unchecked {
155             if (b > a) return (false, 0);
156             return (true, a - b);
157         }
158     }
159 
160     /**
161      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
162      *
163      * _Available since v3.4._
164      */
165     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
166         unchecked {
167             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
168             // benefit is lost if 'b' is also tested.
169             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
170             if (a == 0) return (true, 0);
171             uint256 c = a * b;
172             if (c / a != b) return (false, 0);
173             return (true, c);
174         }
175     }
176 
177     /**
178      * @dev Returns the division of two unsigned integers, with a division by zero flag.
179      *
180      * _Available since v3.4._
181      */
182     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
183         unchecked {
184             if (b == 0) return (false, 0);
185             return (true, a / b);
186         }
187     }
188 
189     /**
190      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
191      *
192      * _Available since v3.4._
193      */
194     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
195         unchecked {
196             if (b == 0) return (false, 0);
197             return (true, a % b);
198         }
199     }
200 
201     /**
202      * @dev Returns the addition of two unsigned integers, reverting on
203      * overflow.
204      *
205      * Counterpart to Solidity's `+` operator.
206      *
207      * Requirements:
208      *
209      * - Addition cannot overflow.
210      */
211     function add(uint256 a, uint256 b) internal pure returns (uint256) {
212         return a + b;
213     }
214 
215     /**
216      * @dev Returns the subtraction of two unsigned integers, reverting on
217      * overflow (when the result is negative).
218      *
219      * Counterpart to Solidity's `-` operator.
220      *
221      * Requirements:
222      *
223      * - Subtraction cannot overflow.
224      */
225     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
226         return a - b;
227     }
228 
229     /**
230      * @dev Returns the multiplication of two unsigned integers, reverting on
231      * overflow.
232      *
233      * Counterpart to Solidity's `*` operator.
234      *
235      * Requirements:
236      *
237      * - Multiplication cannot overflow.
238      */
239     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
240         return a * b;
241     }
242 
243     /**
244      * @dev Returns the integer division of two unsigned integers, reverting on
245      * division by zero. The result is rounded towards zero.
246      *
247      * Counterpart to Solidity's `/` operator.
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function div(uint256 a, uint256 b) internal pure returns (uint256) {
254         return a / b;
255     }
256 
257     /**
258      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
259      * reverting when dividing by zero.
260      *
261      * Counterpart to Solidity's `%` operator. This function uses a `revert`
262      * opcode (which leaves remaining gas untouched) while Solidity uses an
263      * invalid opcode to revert (consuming all remaining gas).
264      *
265      * Requirements:
266      *
267      * - The divisor cannot be zero.
268      */
269     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
270         return a % b;
271     }
272 
273     /**
274      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
275      * overflow (when the result is negative).
276      *
277      * CAUTION: This function is deprecated because it requires allocating memory for the error
278      * message unnecessarily. For custom revert reasons use {trySub}.
279      *
280      * Counterpart to Solidity's `-` operator.
281      *
282      * Requirements:
283      *
284      * - Subtraction cannot overflow.
285      */
286     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
287         unchecked {
288             require(b <= a, errorMessage);
289             return a - b;
290         }
291     }
292 
293     /**
294      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
295      * division by zero. The result is rounded towards zero.
296      *
297      * Counterpart to Solidity's `%` operator. This function uses a `revert`
298      * opcode (which leaves remaining gas untouched) while Solidity uses an
299      * invalid opcode to revert (consuming all remaining gas).
300      *
301      * Counterpart to Solidity's `/` operator. Note: this function uses a
302      * `revert` opcode (which leaves remaining gas untouched) while Solidity
303      * uses an invalid opcode to revert (consuming all remaining gas).
304      *
305      * Requirements:
306      *
307      * - The divisor cannot be zero.
308      */
309     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
310         unchecked {
311             require(b > 0, errorMessage);
312             return a / b;
313         }
314     }
315 
316     /**
317      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
318      * reverting with custom message when dividing by zero.
319      *
320      * CAUTION: This function is deprecated because it requires allocating memory for the error
321      * message unnecessarily. For custom revert reasons use {tryMod}.
322      *
323      * Counterpart to Solidity's `%` operator. This function uses a `revert`
324      * opcode (which leaves remaining gas untouched) while Solidity uses an
325      * invalid opcode to revert (consuming all remaining gas).
326      *
327      * Requirements:
328      *
329      * - The divisor cannot be zero.
330      */
331     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
332         unchecked {
333             require(b > 0, errorMessage);
334             return a % b;
335         }
336     }
337 }
338 
339 library Strings {
340     bytes16 private constant alphabet = "0123456789abcdef";
341 
342     /**
343      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
344      */
345     function toString(uint256 value) internal pure returns (string memory) {
346         // Inspired by OraclizeAPI's implementation - MIT licence
347         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
348 
349         if (value == 0) {
350             return "0";
351         }
352         uint256 temp = value;
353         uint256 digits;
354         while (temp != 0) {
355             digits++;
356             temp /= 10;
357         }
358         bytes memory buffer = new bytes(digits);
359         while (value != 0) {
360             digits -= 1;
361             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
362             value /= 10;
363         }
364         return string(buffer);
365     }
366 
367     /**
368      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
369      */
370     function toHexString(uint256 value) internal pure returns (string memory) {
371         if (value == 0) {
372             return "0x00";
373         }
374         uint256 temp = value;
375         uint256 length = 0;
376         while (temp != 0) {
377             length++;
378             temp >>= 8;
379         }
380         return toHexString(value, length);
381     }
382 
383     /**
384      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
385      */
386     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
387         bytes memory buffer = new bytes(2 * length + 2);
388         buffer[0] = "0";
389         buffer[1] = "x";
390         for (uint256 i = 2 * length + 1; i > 1; --i) {
391             buffer[i] = alphabet[value & 0xf];
392             value >>= 4;
393         }
394         require(value == 0, "Strings: hex length insufficient");
395         return string(buffer);
396     }
397 
398 }
399 
400 abstract contract Context {
401     function _msgSender() internal view virtual returns (address) {
402         return msg.sender;
403     }
404 
405     function _msgData() internal view virtual returns (bytes calldata) {
406         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
407         return msg.data;
408     }
409 }
410 
411 abstract contract Ownable is Context {
412     address private _owner;
413 
414     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
415 
416     /**
417      * @dev Initializes the contract setting the deployer as the initial owner.
418      */
419     constructor () {
420         address msgSender = _msgSender();
421         _owner = msgSender;
422         emit OwnershipTransferred(address(0), msgSender);
423     }
424 
425     /**
426      * @dev Returns the address of the current owner.
427      */
428     function owner() public view virtual returns (address) {
429         return _owner;
430     }
431 
432     /**
433      * @dev Throws if called by any account other than the owner.
434      */
435     modifier onlyOwner() {
436         require(owner() == _msgSender(), "Ownable: caller is not the owner");
437         _;
438     }
439 
440     /**
441      * @dev Leaves the contract without owner. It will not be possible to call
442      * `onlyOwner` functions anymore. Can only be called by the current owner.
443      *
444      * NOTE: Renouncing ownership will leave the contract without an owner,
445      * thereby removing any functionality that is only available to the owner.
446      */
447     function renounceOwnership() public virtual onlyOwner {
448         emit OwnershipTransferred(_owner, address(0));
449         _owner = address(0);
450     }
451 
452     /**
453      * @dev Transfers ownership of the contract to a new account (`newOwner`).
454      * Can only be called by the current owner.
455      */
456     function transferOwnership(address newOwner) public virtual onlyOwner {
457         require(newOwner != address(0), "Ownable: new owner is the zero address");
458         emit OwnershipTransferred(_owner, newOwner);
459         _owner = newOwner;
460     }
461 }
462 
463 library Address {
464     /**
465      * @dev Returns true if `account` is a contract.
466      *
467      * [IMPORTANT]
468      * ====
469      * It is unsafe to assume that an address for which this function returns
470      * false is an externally-owned account (EOA) and not a contract.
471      *
472      * Among others, `isContract` will return false for the following
473      * types of addresses:
474      *
475      *  - an externally-owned account
476      *  - a contract in construction
477      *  - an address where a contract will be created
478      *  - an address where a contract lived, but was destroyed
479      * ====
480      */
481     function isContract(address account) internal view returns (bool) {
482         // This method relies on extcodesize, which returns 0 for contracts in
483         // construction, since the code is only stored at the end of the
484         // constructor execution.
485 
486         uint256 size;
487         // solhint-disable-next-line no-inline-assembly
488         assembly { size := extcodesize(account) }
489         return size > 0;
490     }
491 
492     /**
493      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
494      * `recipient`, forwarding all available gas and reverting on errors.
495      *
496      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
497      * of certain opcodes, possibly making contracts go over the 2300 gas limit
498      * imposed by `transfer`, making them unable to receive funds via
499      * `transfer`. {sendValue} removes this limitation.
500      *
501      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
502      *
503      * IMPORTANT: because control is transferred to `recipient`, care must be
504      * taken to not create reentrancy vulnerabilities. Consider using
505      * {ReentrancyGuard} or the
506      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
507      */
508     function sendValue(address payable recipient, uint256 amount) internal {
509         require(address(this).balance >= amount, "Address: insufficient balance");
510 
511         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
512         (bool success, ) = recipient.call{ value: amount }("");
513         require(success, "Address: unable to send value, recipient may have reverted");
514     }
515 
516     /**
517      * @dev Performs a Solidity function call using a low level `call`. A
518      * plain`call` is an unsafe replacement for a function call: use this
519      * function instead.
520      *
521      * If `target` reverts with a revert reason, it is bubbled up by this
522      * function (like regular Solidity function calls).
523      *
524      * Returns the raw returned data. To convert to the expected return value,
525      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
526      *
527      * Requirements:
528      *
529      * - `target` must be a contract.
530      * - calling `target` with `data` must not revert.
531      *
532      * _Available since v3.1._
533      */
534     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
535       return functionCall(target, data, "Address: low-level call failed");
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
540      * `errorMessage` as a fallback revert reason when `target` reverts.
541      *
542      * _Available since v3.1._
543      */
544     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
545         return functionCallWithValue(target, data, 0, errorMessage);
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
550      * but also transferring `value` wei to `target`.
551      *
552      * Requirements:
553      *
554      * - the calling contract must have an ETH balance of at least `value`.
555      * - the called Solidity function must be `payable`.
556      *
557      * _Available since v3.1._
558      */
559     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
560         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
565      * with `errorMessage` as a fallback revert reason when `target` reverts.
566      *
567      * _Available since v3.1._
568      */
569     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
570         require(address(this).balance >= value, "Address: insufficient balance for call");
571         require(isContract(target), "Address: call to non-contract");
572 
573         // solhint-disable-next-line avoid-low-level-calls
574         (bool success, bytes memory returndata) = target.call{ value: value }(data);
575         return _verifyCallResult(success, returndata, errorMessage);
576     }
577 
578     /**
579      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
580      * but performing a static call.
581      *
582      * _Available since v3.3._
583      */
584     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
585         return functionStaticCall(target, data, "Address: low-level static call failed");
586     }
587 
588     /**
589      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
590      * but performing a static call.
591      *
592      * _Available since v3.3._
593      */
594     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
595         require(isContract(target), "Address: static call to non-contract");
596 
597         // solhint-disable-next-line avoid-low-level-calls
598         (bool success, bytes memory returndata) = target.staticcall(data);
599         return _verifyCallResult(success, returndata, errorMessage);
600     }
601 
602     /**
603      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
604      * but performing a delegate call.
605      *
606      * _Available since v3.4._
607      */
608     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
609         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
610     }
611 
612     /**
613      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
614      * but performing a delegate call.
615      *
616      * _Available since v3.4._
617      */
618     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
619         require(isContract(target), "Address: delegate call to non-contract");
620 
621         // solhint-disable-next-line avoid-low-level-calls
622         (bool success, bytes memory returndata) = target.delegatecall(data);
623         return _verifyCallResult(success, returndata, errorMessage);
624     }
625 
626     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
627         if (success) {
628             return returndata;
629         } else {
630             // Look for revert reason and bubble it up if present
631             if (returndata.length > 0) {
632                 // The easiest way to bubble the revert reason is using memory via assembly
633 
634                 // solhint-disable-next-line no-inline-assembly
635                 assembly {
636                     let returndata_size := mload(returndata)
637                     revert(add(32, returndata), returndata_size)
638                 }
639             } else {
640                 revert(errorMessage);
641             }
642         }
643     }
644 }
645 
646 interface IERC721Receiver {
647     /**
648      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
649      * by `operator` from `from`, this function is called.
650      *
651      * It must return its Solidity selector to confirm the token transfer.
652      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
653      *
654      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
655      */
656     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
657 }
658 
659 interface IERC165 {
660     /**
661      * @dev Returns true if this contract implements the interface defined by
662      * `interfaceId`. See the corresponding
663      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
664      * to learn more about how these ids are created.
665      *
666      * This function call must use less than 30 000 gas.
667      */
668     function supportsInterface(bytes4 interfaceId) external view returns (bool);
669 }
670 
671 abstract contract ERC165 is IERC165 {
672     /**
673      * @dev See {IERC165-supportsInterface}.
674      */
675     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
676         return interfaceId == type(IERC165).interfaceId;
677     }
678 }
679 
680 interface IERC721 is IERC165 {
681     /**
682      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
683      */
684     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
685 
686     /**
687      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
688      */
689     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
690 
691     /**
692      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
693      */
694     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
695 
696     /**
697      * @dev Returns the number of tokens in ``owner``'s account.
698      */
699     function balanceOf(address owner) external view returns (uint256 balance);
700 
701     /**
702      * @dev Returns the owner of the `tokenId` token.
703      *
704      * Requirements:
705      *
706      * - `tokenId` must exist.
707      */
708     function ownerOf(uint256 tokenId) external view returns (address owner);
709 
710     /**
711      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
712      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
713      *
714      * Requirements:
715      *
716      * - `from` cannot be the zero address.
717      * - `to` cannot be the zero address.
718      * - `tokenId` token must exist and be owned by `from`.
719      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
720      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
721      *
722      * Emits a {Transfer} event.
723      */
724     function safeTransferFrom(address from, address to, uint256 tokenId) external;
725 
726     /**
727      * @dev Transfers `tokenId` token from `from` to `to`.
728      *
729      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
730      *
731      * Requirements:
732      *
733      * - `from` cannot be the zero address.
734      * - `to` cannot be the zero address.
735      * - `tokenId` token must be owned by `from`.
736      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
737      *
738      * Emits a {Transfer} event.
739      */
740     function transferFrom(address from, address to, uint256 tokenId) external;
741 
742     /**
743      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
744      * The approval is cleared when the token is transferred.
745      *
746      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
747      *
748      * Requirements:
749      *
750      * - The caller must own the token or be an approved operator.
751      * - `tokenId` must exist.
752      *
753      * Emits an {Approval} event.
754      */
755     function approve(address to, uint256 tokenId) external;
756 
757     /**
758      * @dev Returns the account approved for `tokenId` token.
759      *
760      * Requirements:
761      *
762      * - `tokenId` must exist.
763      */
764     function getApproved(uint256 tokenId) external view returns (address operator);
765 
766     /**
767      * @dev Approve or remove `operator` as an operator for the caller.
768      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
769      *
770      * Requirements:
771      *
772      * - The `operator` cannot be the caller.
773      *
774      * Emits an {ApprovalForAll} event.
775      */
776     function setApprovalForAll(address operator, bool _approved) external;
777 
778     /**
779      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
780      *
781      * See {setApprovalForAll}
782      */
783     function isApprovedForAll(address owner, address operator) external view returns (bool);
784 
785     /**
786       * @dev Safely transfers `tokenId` token from `from` to `to`.
787       *
788       * Requirements:
789       *
790       * - `from` cannot be the zero address.
791       * - `to` cannot be the zero address.
792       * - `tokenId` token must exist and be owned by `from`.
793       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
794       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
795       *
796       * Emits a {Transfer} event.
797       */
798     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
799 }
800 
801 interface IERC721Enumerable is IERC721 {
802 
803     /**
804      * @dev Returns the total amount of tokens stored by the contract.
805      */
806     function totalSupply() external view returns (uint256);
807 
808     /**
809      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
810      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
811      */
812     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
813 
814     /**
815      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
816      * Use along with {totalSupply} to enumerate all tokens.
817      */
818     function tokenByIndex(uint256 index) external view returns (uint256);
819 }
820 
821 interface IERC721Metadata is IERC721 {
822 
823     /**
824      * @dev Returns the token collection name.
825      */
826     function name() external view returns (string memory);
827 
828     /**
829      * @dev Returns the token collection symbol.
830      */
831     function symbol() external view returns (string memory);
832 
833     /**
834      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
835      */
836     function tokenURI(uint256 tokenId) external view returns (string memory);
837 }
838 
839 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
840     using Address for address;
841     using Strings for uint256;
842 
843     // Token name
844     string private _name;
845 
846     // Token symbol
847     string private _symbol;
848 
849     // Mapping from token ID to owner address
850     mapping (uint256 => address) private _owners;
851 
852     // Mapping owner address to token count
853     mapping (address => uint256) private _balances;
854 
855     // Mapping from token ID to approved address
856     mapping (uint256 => address) private _tokenApprovals;
857 
858     // Mapping from owner to operator approvals
859     mapping (address => mapping (address => bool)) private _operatorApprovals;
860 
861     /**
862      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
863      */
864     constructor (string memory name_, string memory symbol_) {
865         _name = name_;
866         _symbol = symbol_;
867     }
868 
869     /**
870      * @dev See {IERC165-supportsInterface}.
871      */
872     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
873         return interfaceId == type(IERC721).interfaceId
874             || interfaceId == type(IERC721Metadata).interfaceId
875             || super.supportsInterface(interfaceId);
876     }
877 
878     /**
879      * @dev See {IERC721-balanceOf}.
880      */
881     function balanceOf(address owner) public view virtual override returns (uint256) {
882         require(owner != address(0), "ERC721: balance query for the zero address");
883         return _balances[owner];
884     }
885 
886     /**
887      * @dev See {IERC721-ownerOf}.
888      */
889     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
890         address owner = _owners[tokenId];
891         require(owner != address(0), "ERC721: owner query for nonexistent token");
892         return owner;
893     }
894 
895     /**
896      * @dev See {IERC721Metadata-name}.
897      */
898     function name() public view virtual override returns (string memory) {
899         return _name;
900     }
901 
902     /**
903      * @dev See {IERC721Metadata-symbol}.
904      */
905     function symbol() public view virtual override returns (string memory) {
906         return _symbol;
907     }
908 
909     /**
910      * @dev See {IERC721Metadata-tokenURI}.
911      */
912     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
913         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
914 
915         string memory baseURI = _baseURI();
916         return bytes(baseURI).length > 0
917             ? string(abi.encodePacked(baseURI, tokenId.toString()))
918             : '';
919     }
920 
921     /**
922      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
923      * in child contracts.
924      */
925     function _baseURI() internal view virtual returns (string memory) {
926         return "";
927     }
928 
929     /**
930      * @dev See {IERC721-approve}.
931      */
932     function approve(address to, uint256 tokenId) public virtual override {
933         address owner = ERC721.ownerOf(tokenId);
934         require(to != owner, "ERC721: approval to current owner");
935 
936         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
937             "ERC721: approve caller is not owner nor approved for all"
938         );
939 
940         _approve(to, tokenId);
941     }
942 
943     /**
944      * @dev See {IERC721-getApproved}.
945      */
946     function getApproved(uint256 tokenId) public view virtual override returns (address) {
947         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
948 
949         return _tokenApprovals[tokenId];
950     }
951 
952     /**
953      * @dev See {IERC721-setApprovalForAll}.
954      */
955     function setApprovalForAll(address operator, bool approved) public virtual override {
956         require(operator != _msgSender(), "ERC721: approve to caller");
957 
958         _operatorApprovals[_msgSender()][operator] = approved;
959         emit ApprovalForAll(_msgSender(), operator, approved);
960     }
961 
962     /**
963      * @dev See {IERC721-isApprovedForAll}.
964      */
965     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
966         return _operatorApprovals[owner][operator];
967     }
968 
969     /**
970      * @dev See {IERC721-transferFrom}.
971      */
972     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
973         //solhint-disable-next-line max-line-length
974         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
975 
976         _transfer(from, to, tokenId);
977     }
978 
979     /**
980      * @dev See {IERC721-safeTransferFrom}.
981      */
982     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
983         safeTransferFrom(from, to, tokenId, "");
984     }
985 
986     /**
987      * @dev See {IERC721-safeTransferFrom}.
988      */
989     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
990         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
991         _safeTransfer(from, to, tokenId, _data);
992     }
993 
994     /**
995      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
996      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
997      *
998      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
999      *
1000      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1001      * implement alternative mechanisms to perform token transfer, such as signature-based.
1002      *
1003      * Requirements:
1004      *
1005      * - `from` cannot be the zero address.
1006      * - `to` cannot be the zero address.
1007      * - `tokenId` token must exist and be owned by `from`.
1008      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1013         _transfer(from, to, tokenId);
1014         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1015     }
1016 
1017     /**
1018      * @dev Returns whether `tokenId` exists.
1019      *
1020      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1021      *
1022      * Tokens start existing when they are minted (`_mint`),
1023      * and stop existing when they are burned (`_burn`).
1024      */
1025     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1026         return _owners[tokenId] != address(0);
1027     }
1028 
1029     /**
1030      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1031      *
1032      * Requirements:
1033      *
1034      * - `tokenId` must exist.
1035      */
1036     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1037         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1038         address owner = ERC721.ownerOf(tokenId);
1039         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1040     }
1041 
1042     /**
1043      * @dev Safely mints `tokenId` and transfers it to `to`.
1044      *
1045      * Requirements:
1046      *
1047      * - `tokenId` must not exist.
1048      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1049      *
1050      * Emits a {Transfer} event.
1051      */
1052     function _safeMint(address to, uint256 tokenId) internal virtual {
1053         _safeMint(to, tokenId, "");
1054     }
1055 
1056     /**
1057      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1058      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1059      */
1060     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1061         _mint(to, tokenId);
1062         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1063     }
1064 
1065     /**
1066      * @dev Mints `tokenId` and transfers it to `to`.
1067      *
1068      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1069      *
1070      * Requirements:
1071      *
1072      * - `tokenId` must not exist.
1073      * - `to` cannot be the zero address.
1074      *
1075      * Emits a {Transfer} event.
1076      */
1077     function _mint(address to, uint256 tokenId) internal virtual {
1078         require(to != address(0), "ERC721: mint to the zero address");
1079         require(!_exists(tokenId), "ERC721: token already minted");
1080 
1081         _beforeTokenTransfer(address(0), to, tokenId);
1082 
1083         _balances[to] += 1;
1084         _owners[tokenId] = to;
1085 
1086         emit Transfer(address(0), to, tokenId);
1087     }
1088 
1089     /**
1090      * @dev Destroys `tokenId`.
1091      * The approval is cleared when the token is burned.
1092      *
1093      * Requirements:
1094      *
1095      * - `tokenId` must exist.
1096      *
1097      * Emits a {Transfer} event.
1098      */
1099     function _burn(uint256 tokenId) internal virtual {
1100         address owner = ERC721.ownerOf(tokenId);
1101 
1102         _beforeTokenTransfer(owner, address(0), tokenId);
1103 
1104         // Clear approvals
1105         _approve(address(0), tokenId);
1106 
1107         _balances[owner] -= 1;
1108         delete _owners[tokenId];
1109 
1110         emit Transfer(owner, address(0), tokenId);
1111     }
1112 
1113     /**
1114      * @dev Transfers `tokenId` from `from` to `to`.
1115      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1116      *
1117      * Requirements:
1118      *
1119      * - `to` cannot be the zero address.
1120      * - `tokenId` token must be owned by `from`.
1121      *
1122      * Emits a {Transfer} event.
1123      */
1124     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1125         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1126         require(to != address(0), "ERC721: transfer to the zero address");
1127 
1128         _beforeTokenTransfer(from, to, tokenId);
1129 
1130         // Clear approvals from the previous owner
1131         _approve(address(0), tokenId);
1132 
1133         _balances[from] -= 1;
1134         _balances[to] += 1;
1135         _owners[tokenId] = to;
1136 
1137         emit Transfer(from, to, tokenId);
1138     }
1139 
1140     /**
1141      * @dev Approve `to` to operate on `tokenId`
1142      *
1143      * Emits a {Approval} event.
1144      */
1145     function _approve(address to, uint256 tokenId) internal virtual {
1146         _tokenApprovals[tokenId] = to;
1147         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1148     }
1149 
1150     /**
1151      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1152      * The call is not executed if the target address is not a contract.
1153      *
1154      * @param from address representing the previous owner of the given token ID
1155      * @param to target address that will receive the tokens
1156      * @param tokenId uint256 ID of the token to be transferred
1157      * @param _data bytes optional data to send along with the call
1158      * @return bool whether the call correctly returned the expected magic value
1159      */
1160     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1161         private returns (bool)
1162     {
1163         if (to.isContract()) {
1164             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1165                 return retval == IERC721Receiver(to).onERC721Received.selector;
1166             } catch (bytes memory reason) {
1167                 if (reason.length == 0) {
1168                     revert("ERC721: transfer to non ERC721Receiver implementer");
1169                 } else {
1170                     // solhint-disable-next-line no-inline-assembly
1171                     assembly {
1172                         revert(add(32, reason), mload(reason))
1173                     }
1174                 }
1175             }
1176         } else {
1177             return true;
1178         }
1179     }
1180 
1181     /**
1182      * @dev Hook that is called before any token transfer. This includes minting
1183      * and burning.
1184      *
1185      * Calling conditions:
1186      *
1187      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1188      * transferred to `to`.
1189      * - When `from` is zero, `tokenId` will be minted for `to`.
1190      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1191      * - `from` cannot be the zero address.
1192      * - `to` cannot be the zero address.
1193      *
1194      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1195      */
1196     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1197 }
1198 
1199 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1200     // Mapping from owner to list of owned token IDs
1201     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1202 
1203     // Mapping from token ID to index of the owner tokens list
1204     mapping(uint256 => uint256) private _ownedTokensIndex;
1205 
1206     // Array with all token ids, used for enumeration
1207     uint256[] private _allTokens;
1208 
1209     // Mapping from token id to position in the allTokens array
1210     mapping(uint256 => uint256) private _allTokensIndex;
1211 
1212     /**
1213      * @dev See {IERC165-supportsInterface}.
1214      */
1215     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1216         return interfaceId == type(IERC721Enumerable).interfaceId
1217             || super.supportsInterface(interfaceId);
1218     }
1219 
1220     /**
1221      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1222      */
1223     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1224         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1225         return _ownedTokens[owner][index];
1226     }
1227 
1228     /**
1229      * @dev See {IERC721Enumerable-totalSupply}.
1230      */
1231     function totalSupply() public view virtual override returns (uint256) {
1232         return _allTokens.length;
1233     }
1234 
1235     /**
1236      * @dev See {IERC721Enumerable-tokenByIndex}.
1237      */
1238     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1239         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1240         return _allTokens[index];
1241     }
1242 
1243     /**
1244      * @dev Hook that is called before any token transfer. This includes minting
1245      * and burning.
1246      *
1247      * Calling conditions:
1248      *
1249      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1250      * transferred to `to`.
1251      * - When `from` is zero, `tokenId` will be minted for `to`.
1252      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1253      * - `from` cannot be the zero address.
1254      * - `to` cannot be the zero address.
1255      *
1256      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1257      */
1258     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1259         super._beforeTokenTransfer(from, to, tokenId);
1260 
1261         if (from == address(0)) {
1262             _addTokenToAllTokensEnumeration(tokenId);
1263         } else if (from != to) {
1264             _removeTokenFromOwnerEnumeration(from, tokenId);
1265         }
1266         if (to == address(0)) {
1267             _removeTokenFromAllTokensEnumeration(tokenId);
1268         } else if (to != from) {
1269             _addTokenToOwnerEnumeration(to, tokenId);
1270         }
1271     }
1272 
1273     /**
1274      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1275      * @param to address representing the new owner of the given token ID
1276      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1277      */
1278     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1279         uint256 length = ERC721.balanceOf(to);
1280         _ownedTokens[to][length] = tokenId;
1281         _ownedTokensIndex[tokenId] = length;
1282     }
1283 
1284     /**
1285      * @dev Private function to add a token to this extension's token tracking data structures.
1286      * @param tokenId uint256 ID of the token to be added to the tokens list
1287      */
1288     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1289         _allTokensIndex[tokenId] = _allTokens.length;
1290         _allTokens.push(tokenId);
1291     }
1292 
1293     /**
1294      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1295      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1296      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1297      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1298      * @param from address representing the previous owner of the given token ID
1299      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1300      */
1301     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1302         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1303         // then delete the last slot (swap and pop).
1304 
1305         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1306         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1307 
1308         // When the token to delete is the last token, the swap operation is unnecessary
1309         if (tokenIndex != lastTokenIndex) {
1310             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1311 
1312             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1313             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1314         }
1315 
1316         // This also deletes the contents at the last position of the array
1317         delete _ownedTokensIndex[tokenId];
1318         delete _ownedTokens[from][lastTokenIndex];
1319     }
1320 
1321     /**
1322      * @dev Private function to remove a token from this extension's token tracking data structures.
1323      * This has O(1) time complexity, but alters the order of the _allTokens array.
1324      * @param tokenId uint256 ID of the token to be removed from the tokens list
1325      */
1326     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1327         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1328         // then delete the last slot (swap and pop).
1329 
1330         uint256 lastTokenIndex = _allTokens.length - 1;
1331         uint256 tokenIndex = _allTokensIndex[tokenId];
1332 
1333         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1334         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1335         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1336         uint256 lastTokenId = _allTokens[lastTokenIndex];
1337 
1338         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1339         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1340 
1341         // This also deletes the contents at the last position of the array
1342         delete _allTokensIndex[tokenId];
1343         _allTokens.pop();
1344     }
1345 }
1346 
1347 contract CrocZERC721 is ERC721Enumerable, Ownable {
1348     using SafeMath for uint256;
1349     using Address for address;
1350     using ECDSA for bytes32;
1351 
1352     string private baseURI;
1353 
1354     uint256 public maxSupply;
1355     uint256 public maxPreMint;
1356     uint256 public price = 0.055 ether;
1357 
1358     bool public presaleActive = false;
1359     bool public saleActive = false;
1360 
1361     mapping (address => uint256) public balanceGenesis;
1362     mapping(address => uint256) private _presaleListClaimed;
1363     mapping (address => uint256) private maxWallet;
1364 
1365     constructor(string memory name, string memory symbol, uint256 supply, uint256 maxMint) ERC721(name, symbol) {
1366         maxSupply = supply;
1367         maxPreMint = maxMint;
1368     }    
1369 
1370     function _hash(address _address) internal pure returns (bytes32)
1371     {
1372         return keccak256(abi.encodePacked(_address));
1373     }
1374 
1375     function _verify(bytes32 hash, bytes memory signature) internal pure returns (bool) {
1376         return (_recover(hash, signature) == 0x8f20d89bEe77ea2AbBaF46b5DEF3Ef109ab9d358);
1377     }
1378 
1379     function _recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1380         return hash.recover(signature);
1381     }
1382 
1383     function airdrop(uint256 numberOfMints) external onlyOwner {
1384         uint256 supply = totalSupply();
1385         require(supply.add(numberOfMints) <= maxSupply,   "Purchase would exceed max supply of CrocZ");
1386         
1387         for(uint256 i; i < numberOfMints; i++){
1388             _safeMint(msg.sender, supply + i);
1389             balanceGenesis[msg.sender]++;
1390         }
1391     }
1392 
1393     function mintPresale(bytes memory signature, uint256 numberOfMints) public payable {
1394         uint256 supply = totalSupply();
1395         require(_verify(_hash(msg.sender), signature),                          "This hash's signature is invalid.");
1396         require(presaleActive,                                                  "Presale must be active to mint");
1397         require(numberOfMints > 0 && numberOfMints <= 2,                        "Invalid purchase amount");
1398         require(_presaleListClaimed[msg.sender] + numberOfMints <= maxPreMint,  "You cannot mint any more presale CrocZ.");
1399         require(supply.add(numberOfMints) <= maxSupply,                         "Purchase would exceed max supply of CrocZ");
1400         require(price.mul(numberOfMints) == msg.value,                          "Ether value sent is not correct");
1401         _presaleListClaimed[msg.sender] += numberOfMints;
1402 
1403         for(uint256 i; i < numberOfMints; i++){
1404             _safeMint(msg.sender, supply + i);
1405             balanceGenesis[msg.sender]++;
1406             maxWallet[msg.sender]++;
1407         }
1408     }
1409 
1410    function mint(uint256 numberOfMints) public payable {
1411         uint256 supply = totalSupply();
1412         require(msg.sender == tx.origin,                    "Cannot use a contract to mint");
1413         require(saleActive,                                 "Sale must be active to mint");
1414         require(numberOfMints > 0 && numberOfMints <= 5,    "Invalid purchase amount");
1415         require(maxWallet[msg.sender] + numberOfMints <= 5, "You have minted the maximum allowed per wallet");
1416         require(supply.add(numberOfMints) <= maxSupply,     "Purchase would exceed max supply of CrocZ");
1417         require(price.mul(numberOfMints) == msg.value,      "Ether value sent is not correct");
1418         
1419         for(uint256 i; i < numberOfMints; i++) {
1420             _safeMint(msg.sender, supply + i);
1421             balanceGenesis[msg.sender]++;
1422             maxWallet[msg.sender]++;
1423         }
1424     }
1425 
1426     function walletOfOwner(address owner) external view returns(uint256[] memory) {
1427         uint256 tokenCount = balanceOf(owner);
1428 
1429         uint256[] memory tokensId = new uint256[](tokenCount);
1430         for(uint256 i; i < tokenCount; i++){
1431             tokensId[i] = tokenOfOwnerByIndex(owner, i);
1432         }
1433         return tokensId;
1434     }
1435 
1436     function withdraw() public onlyOwner {
1437         uint256 balance = address(this).balance;
1438         payable(msg.sender).transfer(balance);
1439     }
1440 
1441     function togglePresale() public onlyOwner {
1442         presaleActive = !presaleActive;
1443     }
1444 
1445     function toggleSale() public onlyOwner {
1446         saleActive = !saleActive;
1447     }
1448 
1449     function setPrice(uint256 newPrice) public onlyOwner {
1450         price = newPrice;
1451     }
1452     
1453     function setBaseURI(string memory uri) public onlyOwner {
1454         baseURI = uri;
1455     }
1456     
1457     function _baseURI() internal view override returns (string memory) {
1458         return baseURI;
1459     }
1460 }
1461 
1462 interface ISwamp {
1463     function burn(address _from, uint256 _amount) external;
1464     function updateCroczReward(address _from, address _to) external;
1465 } 
1466 
1467 contract CrocZ is CrocZERC721 {
1468 
1469     modifier croczOwner(uint256 croczId) {
1470         require(ownerOf(croczId) == msg.sender, "Cannot interact with a CrocZ you do not own");
1471         _;
1472     }
1473 
1474     ISwamp public Swamp;
1475 
1476     constructor(string memory name, string memory symbol, uint256 supply, uint256 maxMint) CrocZERC721(name, symbol, supply, maxMint) {}
1477 
1478     function setSwamp(address swampAddress) external onlyOwner {
1479         Swamp = ISwamp(swampAddress);
1480     }
1481     
1482     function transferFrom(address from, address to, uint256 tokenId) public override {
1483         if (tokenId < maxSupply) {
1484             Swamp.updateCroczReward(from, to);
1485             balanceGenesis[from]--;
1486             balanceGenesis[to]++;
1487         }
1488         ERC721.transferFrom(from, to, tokenId);
1489     }
1490 
1491     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override {
1492         if (tokenId < maxSupply) {
1493             Swamp.updateCroczReward(from, to);
1494             balanceGenesis[from]--;
1495             balanceGenesis[to]++;
1496         }
1497         ERC721.safeTransferFrom(from, to, tokenId, data);
1498     }
1499 }