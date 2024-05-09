1 // SPDX-License-Identifier: MIT
2 // File @openzeppelin/contracts/cryptography/ECDSA.sol
3 
4 pragma solidity >=0.6.0 <0.8.0;
5 
6 /**
7  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
8  *
9  * These functions can be used to verify that a message was signed by the holder
10  * of the private keys of a given address.
11  */
12 library ECDSA {
13     /**
14      * @dev Returns the address that signed a hashed message (`hash`) with
15      * `signature`. This address can then be used for verification purposes.
16      *
17      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
18      * this function rejects them by requiring the `s` value to be in the lower
19      * half order, and the `v` value to be either 27 or 28.
20      *
21      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
22      * verification to be secure: it is possible to craft signatures that
23      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
24      * this is by receiving a hash of the original message (which may otherwise
25      * be too long), and then calling {toEthSignedMessageHash} on it.
26      */
27     function recover(bytes32 hash, bytes memory signature)
28         internal
29         pure
30         returns (address)
31     {
32         // Check the signature length
33         if (signature.length != 65) {
34             revert("ECDSA: invalid signature length");
35         }
36 
37         // Divide the signature in r, s and v variables
38         bytes32 r;
39         bytes32 s;
40         uint8 v;
41 
42         // ecrecover takes the signature parameters, and the only way to get them
43         // currently is to use assembly.
44         // solhint-disable-next-line no-inline-assembly
45         assembly {
46             r := mload(add(signature, 0x20))
47             s := mload(add(signature, 0x40))
48             v := byte(0, mload(add(signature, 0x60)))
49         }
50 
51         return recover(hash, v, r, s);
52     }
53 
54     /**
55      * @dev Overload of {ECDSA-recover-bytes32-bytes-} that receives the `v`,
56      * `r` and `s` signature fields separately.
57      */
58     function recover(
59         bytes32 hash,
60         uint8 v,
61         bytes32 r,
62         bytes32 s
63     ) internal pure returns (address) {
64         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
65         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
66         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
67         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
68         //
69         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
70         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
71         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
72         // these malleable signatures as well.
73         require(
74             uint256(s) <=
75                 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0,
76             "ECDSA: invalid signature 's' value"
77         );
78         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
79 
80         // If the signature is valid (and not malleable), return the signer address
81         address signer = ecrecover(hash, v, r, s);
82         require(signer != address(0), "ECDSA: invalid signature");
83 
84         return signer;
85     }
86 
87     /**
88      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
89      * replicates the behavior of the
90      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
91      * JSON-RPC method.
92      *
93      * See {recover}.
94      */
95     function toEthSignedMessageHash(bytes32 hash)
96         internal
97         pure
98         returns (bytes32)
99     {
100         // 32 is the length in bytes of hash,
101         // enforced by the type signature above
102         return
103             keccak256(
104                 abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
105             );
106     }
107 }
108 
109 pragma solidity >=0.6.0 <0.8.0;
110 
111 /**
112  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
113  *
114  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
115  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
116  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
117  *
118  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
119  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
120  * ({_hashTypedDataV4}).
121  *
122  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
123  * the chain id to protect against replay attacks on an eventual fork of the chain.
124  *
125  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
126  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
127  *
128  * _Available since v3.4._
129  */
130 abstract contract EIP712 {
131     /* solhint-disable var-name-mixedcase */
132     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
133     // invalidate the cached domain separator if the chain id changes.
134     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
135     uint256 private immutable _CACHED_CHAIN_ID;
136 
137     bytes32 private immutable _HASHED_NAME;
138     bytes32 private immutable _HASHED_VERSION;
139     bytes32 private immutable _TYPE_HASH;
140 
141     /* solhint-enable var-name-mixedcase */
142 
143     /**
144      * @dev Initializes the domain separator and parameter caches.
145      *
146      * The meaning of `name` and `version` is specified in
147      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
148      *
149      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
150      * - `version`: the current major version of the signing domain.
151      *
152      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
153      * contract upgrade].
154      */
155     constructor(string memory name, string memory version) internal {
156         bytes32 hashedName = keccak256(bytes(name));
157         bytes32 hashedVersion = keccak256(bytes(version));
158         bytes32 typeHash = keccak256(
159             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
160         );
161         _HASHED_NAME = hashedName;
162         _HASHED_VERSION = hashedVersion;
163         _CACHED_CHAIN_ID = _getChainId();
164         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(
165             typeHash,
166             hashedName,
167             hashedVersion
168         );
169         _TYPE_HASH = typeHash;
170     }
171 
172     /**
173      * @dev Returns the domain separator for the current chain.
174      */
175     function _domainSeparatorV4() internal view virtual returns (bytes32) {
176         if (_getChainId() == _CACHED_CHAIN_ID) {
177             return _CACHED_DOMAIN_SEPARATOR;
178         } else {
179             return
180                 _buildDomainSeparator(
181                     _TYPE_HASH,
182                     _HASHED_NAME,
183                     _HASHED_VERSION
184                 );
185         }
186     }
187 
188     function _buildDomainSeparator(
189         bytes32 typeHash,
190         bytes32 name,
191         bytes32 version
192     ) private view returns (bytes32) {
193         return
194             keccak256(
195                 abi.encode(
196                     typeHash,
197                     name,
198                     version,
199                     _getChainId(),
200                     address(this)
201                 )
202             );
203     }
204 
205     /**
206      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
207      * function returns the hash of the fully encoded EIP712 message for this domain.
208      *
209      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
210      *
211      * ```solidity
212      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
213      *     keccak256("Mail(address to,string contents)"),
214      *     mailTo,
215      *     keccak256(bytes(mailContents))
216      * )));
217      * address signer = ECDSA.recover(digest, signature);
218      * ```
219      */
220     function _hashTypedDataV4(bytes32 structHash)
221         internal
222         view
223         virtual
224         returns (bytes32)
225     {
226         return
227             keccak256(
228                 abi.encodePacked("\x19\x01", _domainSeparatorV4(), structHash)
229             );
230     }
231 
232     function _getChainId() private view returns (uint256 chainId) {
233         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
234         // solhint-disable-next-line no-inline-assembly
235         assembly {
236             chainId := chainid()
237         }
238     }
239 }
240 
241 pragma solidity >=0.6.0 <0.8.0;
242 
243 /**
244  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
245  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
246  *
247  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
248  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
249  * need to send a transaction, and thus is not required to hold Ether at all.
250  */
251 interface IERC20Permit {
252     /**
253      * @dev Sets `value` as the allowance of `spender` over `owner`'s tokens,
254      * given `owner`'s signed approval.
255      *
256      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
257      * ordering also apply here.
258      *
259      * Emits an {Approval} event.
260      *
261      * Requirements:
262      *
263      * - `spender` cannot be the zero address.
264      * - `deadline` must be a timestamp in the future.
265      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
266      * over the EIP712-formatted function arguments.
267      * - the signature must use ``owner``'s current nonce (see {nonces}).
268      *
269      * For more information on the signature format, see the
270      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
271      * section].
272      */
273     function permit(
274         address owner,
275         address spender,
276         uint256 value,
277         uint256 deadline,
278         uint8 v,
279         bytes32 r,
280         bytes32 s
281     ) external;
282 
283     /**
284      * @dev Returns the current nonce for `owner`. This value must be
285      * included whenever a signature is generated for {permit}.
286      *
287      * Every successful call to {permit} increases ``owner``'s nonce by one. This
288      * prevents a signature from being used multiple times.
289      */
290     function nonces(address owner) external view returns (uint256);
291 
292     /**
293      * @dev Returns the domain separator used in the encoding of the signature for `permit`, as defined by {EIP712}.
294      */
295     // solhint-disable-next-line func-name-mixedcase
296     function DOMAIN_SEPARATOR() external view returns (bytes32);
297 }
298 
299 // File @openzeppelin/contracts/math/SafeMath.sol
300 
301 pragma solidity >=0.6.0 <0.8.0;
302 
303 /**
304  * @dev Wrappers over Solidity's arithmetic operations with added overflow
305  * checks.
306  *
307  * Arithmetic operations in Solidity wrap on overflow. This can easily result
308  * in bugs, because programmers usually assume that an overflow raises an
309  * error, which is the standard behavior in high level programming languages.
310  * `SafeMath` restores this intuition by reverting the transaction when an
311  * operation overflows.
312  *
313  * Using this library instead of the unchecked operations eliminates an entire
314  * class of bugs, so it's recommended to use it always.
315  */
316 library SafeMath {
317     /**
318      * @dev Returns the addition of two unsigned integers, with an overflow flag.
319      *
320      * _Available since v3.4._
321      */
322     function tryAdd(uint256 a, uint256 b)
323         internal
324         pure
325         returns (bool, uint256)
326     {
327         uint256 c = a + b;
328         if (c < a) return (false, 0);
329         return (true, c);
330     }
331 
332     /**
333      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
334      *
335      * _Available since v3.4._
336      */
337     function trySub(uint256 a, uint256 b)
338         internal
339         pure
340         returns (bool, uint256)
341     {
342         if (b > a) return (false, 0);
343         return (true, a - b);
344     }
345 
346     /**
347      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
348      *
349      * _Available since v3.4._
350      */
351     function tryMul(uint256 a, uint256 b)
352         internal
353         pure
354         returns (bool, uint256)
355     {
356         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
357         // benefit is lost if 'b' is also tested.
358         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
359         if (a == 0) return (true, 0);
360         uint256 c = a * b;
361         if (c / a != b) return (false, 0);
362         return (true, c);
363     }
364 
365     /**
366      * @dev Returns the division of two unsigned integers, with a division by zero flag.
367      *
368      * _Available since v3.4._
369      */
370     function tryDiv(uint256 a, uint256 b)
371         internal
372         pure
373         returns (bool, uint256)
374     {
375         if (b == 0) return (false, 0);
376         return (true, a / b);
377     }
378 
379     /**
380      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
381      *
382      * _Available since v3.4._
383      */
384     function tryMod(uint256 a, uint256 b)
385         internal
386         pure
387         returns (bool, uint256)
388     {
389         if (b == 0) return (false, 0);
390         return (true, a % b);
391     }
392 
393     /**
394      * @dev Returns the addition of two unsigned integers, reverting on
395      * overflow.
396      *
397      * Counterpart to Solidity's `+` operator.
398      *
399      * Requirements:
400      *
401      * - Addition cannot overflow.
402      */
403     function add(uint256 a, uint256 b) internal pure returns (uint256) {
404         uint256 c = a + b;
405         require(c >= a, "SafeMath: addition overflow");
406         return c;
407     }
408 
409     /**
410      * @dev Returns the subtraction of two unsigned integers, reverting on
411      * overflow (when the result is negative).
412      *
413      * Counterpart to Solidity's `-` operator.
414      *
415      * Requirements:
416      *
417      * - Subtraction cannot overflow.
418      */
419     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
420         require(b <= a, "SafeMath: subtraction overflow");
421         return a - b;
422     }
423 
424     /**
425      * @dev Returns the multiplication of two unsigned integers, reverting on
426      * overflow.
427      *
428      * Counterpart to Solidity's `*` operator.
429      *
430      * Requirements:
431      *
432      * - Multiplication cannot overflow.
433      */
434     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
435         if (a == 0) return 0;
436         uint256 c = a * b;
437         require(c / a == b, "SafeMath: multiplication overflow");
438         return c;
439     }
440 
441     /**
442      * @dev Returns the integer division of two unsigned integers, reverting on
443      * division by zero. The result is rounded towards zero.
444      *
445      * Counterpart to Solidity's `/` operator. Note: this function uses a
446      * `revert` opcode (which leaves remaining gas untouched) while Solidity
447      * uses an invalid opcode to revert (consuming all remaining gas).
448      *
449      * Requirements:
450      *
451      * - The divisor cannot be zero.
452      */
453     function div(uint256 a, uint256 b) internal pure returns (uint256) {
454         require(b > 0, "SafeMath: division by zero");
455         return a / b;
456     }
457 
458     /**
459      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
460      * reverting when dividing by zero.
461      *
462      * Counterpart to Solidity's `%` operator. This function uses a `revert`
463      * opcode (which leaves remaining gas untouched) while Solidity uses an
464      * invalid opcode to revert (consuming all remaining gas).
465      *
466      * Requirements:
467      *
468      * - The divisor cannot be zero.
469      */
470     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
471         require(b > 0, "SafeMath: modulo by zero");
472         return a % b;
473     }
474 
475     /**
476      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
477      * overflow (when the result is negative).
478      *
479      * CAUTION: This function is deprecated because it requires allocating memory for the error
480      * message unnecessarily. For custom revert reasons use {trySub}.
481      *
482      * Counterpart to Solidity's `-` operator.
483      *
484      * Requirements:
485      *
486      * - Subtraction cannot overflow.
487      */
488     function sub(
489         uint256 a,
490         uint256 b,
491         string memory errorMessage
492     ) internal pure returns (uint256) {
493         require(b <= a, errorMessage);
494         return a - b;
495     }
496 
497     /**
498      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
499      * division by zero. The result is rounded towards zero.
500      *
501      * CAUTION: This function is deprecated because it requires allocating memory for the error
502      * message unnecessarily. For custom revert reasons use {tryDiv}.
503      *
504      * Counterpart to Solidity's `/` operator. Note: this function uses a
505      * `revert` opcode (which leaves remaining gas untouched) while Solidity
506      * uses an invalid opcode to revert (consuming all remaining gas).
507      *
508      * Requirements:
509      *
510      * - The divisor cannot be zero.
511      */
512     function div(
513         uint256 a,
514         uint256 b,
515         string memory errorMessage
516     ) internal pure returns (uint256) {
517         require(b > 0, errorMessage);
518         return a / b;
519     }
520 
521     /**
522      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
523      * reverting with custom message when dividing by zero.
524      *
525      * CAUTION: This function is deprecated because it requires allocating memory for the error
526      * message unnecessarily. For custom revert reasons use {tryMod}.
527      *
528      * Counterpart to Solidity's `%` operator. This function uses a `revert`
529      * opcode (which leaves remaining gas untouched) while Solidity uses an
530      * invalid opcode to revert (consuming all remaining gas).
531      *
532      * Requirements:
533      *
534      * - The divisor cannot be zero.
535      */
536     function mod(
537         uint256 a,
538         uint256 b,
539         string memory errorMessage
540     ) internal pure returns (uint256) {
541         require(b > 0, errorMessage);
542         return a % b;
543     }
544 }
545 
546 // File @openzeppelin/contracts/token/ERC20/IERC20.sol
547 
548 pragma solidity >=0.6.0 <0.8.0;
549 
550 /**
551  * @dev Interface of the ERC20 standard as defined in the EIP.
552  */
553 interface IERC20 {
554     /**
555      * @dev Returns the amount of tokens in existence.
556      */
557     function totalSupply() external view returns (uint256);
558 
559     /**
560      * @dev Returns the amount of tokens owned by `account`.
561      */
562     function balanceOf(address account) external view returns (uint256);
563 
564     /**
565      * @dev Moves `amount` tokens from the caller's account to `recipient`.
566      *
567      * Returns a boolean value indicating whether the operation succeeded.
568      *
569      * Emits a {Transfer} event.
570      */
571     function transfer(address recipient, uint256 amount)
572         external
573         returns (bool);
574 
575     /**
576      * @dev Returns the remaining number of tokens that `spender` will be
577      * allowed to spend on behalf of `owner` through {transferFrom}. This is
578      * zero by default.
579      *
580      * This value changes when {approve} or {transferFrom} are called.
581      */
582     function allowance(address owner, address spender)
583         external
584         view
585         returns (uint256);
586 
587     /**
588      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
589      *
590      * Returns a boolean value indicating whether the operation succeeded.
591      *
592      * IMPORTANT: Beware that changing an allowance with this method brings the risk
593      * that someone may use both the old and the new allowance by unfortunate
594      * transaction ordering. One possible solution to mitigate this race
595      * condition is to first reduce the spender's allowance to 0 and set the
596      * desired value afterwards:
597      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
598      *
599      * Emits an {Approval} event.
600      */
601     function approve(address spender, uint256 amount) external returns (bool);
602 
603     /**
604      * @dev Moves `amount` tokens from `sender` to `recipient` using the
605      * allowance mechanism. `amount` is then deducted from the caller's
606      * allowance.
607      *
608      * Returns a boolean value indicating whether the operation succeeded.
609      *
610      * Emits a {Transfer} event.
611      */
612     function transferFrom(
613         address sender,
614         address recipient,
615         uint256 amount
616     ) external returns (bool);
617 
618     /**
619      * @dev Emitted when `value` tokens are moved from one account (`from`) to
620      * another (`to`).
621      *
622      * Note that `value` may be zero.
623      */
624     event Transfer(address indexed from, address indexed to, uint256 value);
625 
626     /**
627      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
628      * a call to {approve}. `value` is the new allowance.
629      */
630     event Approval(
631         address indexed owner,
632         address indexed spender,
633         uint256 value
634     );
635 }
636 
637 // File @openzeppelin/contracts/utils/Context.sol
638 
639 pragma solidity >=0.6.0 <0.8.0;
640 
641 /*
642  * @dev Provides information about the current execution context, including the
643  * sender of the transaction and its data. While these are generally available
644  * via msg.sender and msg.data, they should not be accessed in such a direct
645  * manner, since when dealing with GSN meta-transactions the account sending and
646  * paying for execution may not be the actual sender (as far as an application
647  * is concerned).
648  *
649  * This contract is only required for intermediate, library-like contracts.
650  */
651 abstract contract Context {
652     function _msgSender() internal view virtual returns (address payable) {
653         return msg.sender;
654     }
655 
656     function _msgData() internal view virtual returns (bytes memory) {
657         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
658         return msg.data;
659     }
660 }
661 
662 // File @openzeppelin/contracts/token/ERC20/ERC20.sol
663 
664 pragma solidity >=0.6.0 <0.8.0;
665 
666 /**
667  * @dev Implementation of the {IERC20} interface.
668  *
669  * This implementation is agnostic to the way tokens are created. This means
670  * that a supply mechanism has to be added in a derived contract using {_mint}.
671  * For a generic mechanism see {ERC20PresetMinterPauser}.
672  *
673  * TIP: For a detailed writeup see our guide
674  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
675  * to implement supply mechanisms].
676  *
677  * We have followed general OpenZeppelin guidelines: functions revert instead
678  * of returning `false` on failure. This behavior is nonetheless conventional
679  * and does not conflict with the expectations of ERC20 applications.
680  *
681  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
682  * This allows applications to reconstruct the allowance for all accounts just
683  * by listening to said events. Other implementations of the EIP may not emit
684  * these events, as it isn't required by the specification.
685  *
686  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
687  * functions have been added to mitigate the well-known issues around setting
688  * allowances. See {IERC20-approve}.
689  */
690 contract ERC20 is Context, IERC20 {
691     using SafeMath for uint256;
692 
693     mapping(address => uint256) private _balances;
694 
695     mapping(address => mapping(address => uint256)) private _allowances;
696 
697     uint256 private _totalSupply;
698 
699     string private _name;
700     string private _symbol;
701     uint8 private _decimals;
702 
703     /**
704      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
705      * a default value of 18.
706      *
707      * To select a different value for {decimals}, use {_setupDecimals}.
708      *
709      * All three of these values are immutable: they can only be set once during
710      * construction.
711      */
712     constructor(string memory name_, string memory symbol_) public {
713         _name = name_;
714         _symbol = symbol_;
715         _decimals = 18;
716     }
717 
718     /**
719      * @dev Returns the name of the token.
720      */
721     function name() public view virtual returns (string memory) {
722         return _name;
723     }
724 
725     /**
726      * @dev Returns the symbol of the token, usually a shorter version of the
727      * name.
728      */
729     function symbol() public view virtual returns (string memory) {
730         return _symbol;
731     }
732 
733     /**
734      * @dev Returns the number of decimals used to get its user representation.
735      * For example, if `decimals` equals `2`, a balance of `505` tokens should
736      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
737      *
738      * Tokens usually opt for a value of 18, imitating the relationship between
739      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
740      * called.
741      *
742      * NOTE: This information is only used for _display_ purposes: it in
743      * no way affects any of the arithmetic of the contract, including
744      * {IERC20-balanceOf} and {IERC20-transfer}.
745      */
746     function decimals() public view virtual returns (uint8) {
747         return _decimals;
748     }
749 
750     /**
751      * @dev See {IERC20-totalSupply}.
752      */
753     function totalSupply() public view virtual override returns (uint256) {
754         return _totalSupply;
755     }
756 
757     /**
758      * @dev See {IERC20-balanceOf}.
759      */
760     function balanceOf(address account)
761         public
762         view
763         virtual
764         override
765         returns (uint256)
766     {
767         return _balances[account];
768     }
769 
770     /**
771      * @dev See {IERC20-transfer}.
772      *
773      * Requirements:
774      *
775      * - `recipient` cannot be the zero address.
776      * - the caller must have a balance of at least `amount`.
777      */
778     function transfer(address recipient, uint256 amount)
779         public
780         virtual
781         override
782         returns (bool)
783     {
784         _transfer(_msgSender(), recipient, amount);
785         return true;
786     }
787 
788     /**
789      * @dev See {IERC20-allowance}.
790      */
791     function allowance(address owner, address spender)
792         public
793         view
794         virtual
795         override
796         returns (uint256)
797     {
798         return _allowances[owner][spender];
799     }
800 
801     /**
802      * @dev See {IERC20-approve}.
803      *
804      * Requirements:
805      *
806      * - `spender` cannot be the zero address.
807      */
808     function approve(address spender, uint256 amount)
809         public
810         virtual
811         override
812         returns (bool)
813     {
814         _approve(_msgSender(), spender, amount);
815         return true;
816     }
817 
818     /**
819      * @dev See {IERC20-transferFrom}.
820      *
821      * Emits an {Approval} event indicating the updated allowance. This is not
822      * required by the EIP. See the note at the beginning of {ERC20}.
823      *
824      * Requirements:
825      *
826      * - `sender` and `recipient` cannot be the zero address.
827      * - `sender` must have a balance of at least `amount`.
828      * - the caller must have allowance for ``sender``'s tokens of at least
829      * `amount`.
830      */
831     function transferFrom(
832         address sender,
833         address recipient,
834         uint256 amount
835     ) public virtual override returns (bool) {
836         _transfer(sender, recipient, amount);
837         _approve(
838             sender,
839             _msgSender(),
840             _allowances[sender][_msgSender()].sub(
841                 amount,
842                 "ERC20: transfer amount exceeds allowance"
843             )
844         );
845         return true;
846     }
847 
848     /**
849      * @dev Atomically increases the allowance granted to `spender` by the caller.
850      *
851      * This is an alternative to {approve} that can be used as a mitigation for
852      * problems described in {IERC20-approve}.
853      *
854      * Emits an {Approval} event indicating the updated allowance.
855      *
856      * Requirements:
857      *
858      * - `spender` cannot be the zero address.
859      */
860     function increaseAllowance(address spender, uint256 addedValue)
861         public
862         virtual
863         returns (bool)
864     {
865         _approve(
866             _msgSender(),
867             spender,
868             _allowances[_msgSender()][spender].add(addedValue)
869         );
870         return true;
871     }
872 
873     /**
874      * @dev Atomically decreases the allowance granted to `spender` by the caller.
875      *
876      * This is an alternative to {approve} that can be used as a mitigation for
877      * problems described in {IERC20-approve}.
878      *
879      * Emits an {Approval} event indicating the updated allowance.
880      *
881      * Requirements:
882      *
883      * - `spender` cannot be the zero address.
884      * - `spender` must have allowance for the caller of at least
885      * `subtractedValue`.
886      */
887     function decreaseAllowance(address spender, uint256 subtractedValue)
888         public
889         virtual
890         returns (bool)
891     {
892         _approve(
893             _msgSender(),
894             spender,
895             _allowances[_msgSender()][spender].sub(
896                 subtractedValue,
897                 "ERC20: decreased allowance below zero"
898             )
899         );
900         return true;
901     }
902 
903     /**
904      * @dev Moves tokens `amount` from `sender` to `recipient`.
905      *
906      * This is internal function is equivalent to {transfer}, and can be used to
907      * e.g. implement automatic token fees, slashing mechanisms, etc.
908      *
909      * Emits a {Transfer} event.
910      *
911      * Requirements:
912      *
913      * - `sender` cannot be the zero address.
914      * - `recipient` cannot be the zero address.
915      * - `sender` must have a balance of at least `amount`.
916      */
917     function _transfer(
918         address sender,
919         address recipient,
920         uint256 amount
921     ) internal virtual {
922         require(sender != address(0), "ERC20: transfer from the zero address");
923         require(recipient != address(0), "ERC20: transfer to the zero address");
924 
925         _beforeTokenTransfer(sender, recipient, amount);
926 
927         _balances[sender] = _balances[sender].sub(
928             amount,
929             "ERC20: transfer amount exceeds balance"
930         );
931         _balances[recipient] = _balances[recipient].add(amount);
932         emit Transfer(sender, recipient, amount);
933     }
934 
935     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
936      * the total supply.
937      *
938      * Emits a {Transfer} event with `from` set to the zero address.
939      *
940      * Requirements:
941      *
942      * - `to` cannot be the zero address.
943      */
944     function _mint(address account, uint256 amount) internal virtual {
945         require(account != address(0), "ERC20: mint to the zero address");
946 
947         _beforeTokenTransfer(address(0), account, amount);
948 
949         _totalSupply = _totalSupply.add(amount);
950         _balances[account] = _balances[account].add(amount);
951         emit Transfer(address(0), account, amount);
952     }
953 
954     /**
955      * @dev Destroys `amount` tokens from `account`, reducing the
956      * total supply.
957      *
958      * Emits a {Transfer} event with `to` set to the zero address.
959      *
960      * Requirements:
961      *
962      * - `account` cannot be the zero address.
963      * - `account` must have at least `amount` tokens.
964      */
965     function _burn(address account, uint256 amount) internal virtual {
966         require(account != address(0), "ERC20: burn from the zero address");
967 
968         _beforeTokenTransfer(account, address(0), amount);
969 
970         _balances[account] = _balances[account].sub(
971             amount,
972             "ERC20: burn amount exceeds balance"
973         );
974         _totalSupply = _totalSupply.sub(amount);
975         emit Transfer(account, address(0), amount);
976     }
977 
978     /**
979      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
980      *
981      * This internal function is equivalent to `approve`, and can be used to
982      * e.g. set automatic allowances for certain subsystems, etc.
983      *
984      * Emits an {Approval} event.
985      *
986      * Requirements:
987      *
988      * - `owner` cannot be the zero address.
989      * - `spender` cannot be the zero address.
990      */
991     function _approve(
992         address owner,
993         address spender,
994         uint256 amount
995     ) internal virtual {
996         require(owner != address(0), "ERC20: approve from the zero address");
997         require(spender != address(0), "ERC20: approve to the zero address");
998 
999         _allowances[owner][spender] = amount;
1000         emit Approval(owner, spender, amount);
1001     }
1002 
1003     /**
1004      * @dev Sets {decimals} to a value other than the default one of 18.
1005      *
1006      * WARNING: This function should only be called from the constructor. Most
1007      * applications that interact with token contracts will not expect
1008      * {decimals} to ever change, and may work incorrectly if it does.
1009      */
1010     function _setupDecimals(uint8 decimals_) internal virtual {
1011         _decimals = decimals_;
1012     }
1013 
1014     /**
1015      * @dev Hook that is called before any transfer of tokens. This includes
1016      * minting and burning.
1017      *
1018      * Calling conditions:
1019      *
1020      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1021      * will be to transferred to `to`.
1022      * - when `from` is zero, `amount` tokens will be minted for `to`.
1023      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1024      * - `from` and `to` are never both zero.
1025      *
1026      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1027      */
1028     function _beforeTokenTransfer(
1029         address from,
1030         address to,
1031         uint256 amount
1032     ) internal virtual {}
1033 }
1034 
1035 // File @openzeppelin/contracts/utils/Counters.sol
1036 
1037 pragma solidity >=0.6.0 <0.8.0;
1038 
1039 /**
1040  * @title Counters
1041  * @author Matt Condon (@shrugs)
1042  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1043  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1044  *
1045  * Include with `using Counters for Counters.Counter;`
1046  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1047  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1048  * directly accessed.
1049  */
1050 library Counters {
1051     using SafeMath for uint256;
1052 
1053     struct Counter {
1054         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1055         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1056         // this feature: see https://github.com/ethereum/solidity/issues/4637
1057         uint256 _value; // default: 0
1058     }
1059 
1060     function current(Counter storage counter) internal view returns (uint256) {
1061         return counter._value;
1062     }
1063 
1064     function increment(Counter storage counter) internal {
1065         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1066         counter._value += 1;
1067     }
1068 
1069     function decrement(Counter storage counter) internal {
1070         counter._value = counter._value.sub(1);
1071     }
1072 }
1073 
1074 // File @openzeppelin/contracts/drafts/ERC20Permit.sol
1075 
1076 pragma solidity >=0.6.5 <0.8.0;
1077 
1078 /**
1079  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1080  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1081  *
1082  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1083  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1084  * need to send a transaction, and thus is not required to hold Ether at all.
1085  *
1086  * _Available since v3.4._
1087  */
1088 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1089     using Counters for Counters.Counter;
1090 
1091     mapping(address => Counters.Counter) private _nonces;
1092 
1093     // solhint-disable-next-line var-name-mixedcase
1094     bytes32 private immutable _PERMIT_TYPEHASH =
1095         keccak256(
1096             "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
1097         );
1098 
1099     /**
1100      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1101      *
1102      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1103      */
1104     constructor(string memory name) internal EIP712(name, "1") {}
1105 
1106     /**
1107      * @dev See {IERC20Permit-permit}.
1108      */
1109     function permit(
1110         address owner,
1111         address spender,
1112         uint256 value,
1113         uint256 deadline,
1114         uint8 v,
1115         bytes32 r,
1116         bytes32 s
1117     ) public virtual override {
1118         // solhint-disable-next-line not-rely-on-time
1119         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1120 
1121         bytes32 structHash = keccak256(
1122             abi.encode(
1123                 _PERMIT_TYPEHASH,
1124                 owner,
1125                 spender,
1126                 value,
1127                 _nonces[owner].current(),
1128                 deadline
1129             )
1130         );
1131 
1132         bytes32 hash = _hashTypedDataV4(structHash);
1133 
1134         address signer = ECDSA.recover(hash, v, r, s);
1135         require(signer == owner, "ERC20Permit: invalid signature");
1136 
1137         _nonces[owner].increment();
1138         _approve(owner, spender, value);
1139     }
1140 
1141     /**
1142      * @dev See {IERC20Permit-nonces}.
1143      */
1144     function nonces(address owner) public view override returns (uint256) {
1145         return _nonces[owner].current();
1146     }
1147 
1148     /**
1149      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1150      */
1151     // solhint-disable-next-line func-name-mixedcase
1152     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1153         return _domainSeparatorV4();
1154     }
1155 }
1156 
1157 // File contracts/UniDex.sol
1158 
1159 pragma solidity >=0.7.5;
1160 
1161 contract UniDex is ERC20Permit {
1162     constructor() ERC20("UniDex", "UNIDX") ERC20Permit("UniDex") {
1163         _mint(msg.sender, 4_000_000e18);
1164     }
1165 }