1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * By default, the owner account will be the one that deploys the contract. This
31  * can later be changed with {transferOwnership}.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev Initializes the contract setting the deployer as the initial owner.
44      */
45     constructor () {
46         address msgSender = _msgSender();
47         _owner = msgSender;
48         emit OwnershipTransferred(address(0), msgSender);
49     }
50 
51     /**
52      * @dev Returns the address of the current owner.
53      */
54     function owner() public view virtual returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(owner() == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     /**
67      * @dev Leaves the contract without owner. It will not be possible to call
68      * `onlyOwner` functions anymore. Can only be called by the current owner.
69      *
70      * NOTE: Renouncing ownership will leave the contract without an owner,
71      * thereby removing any functionality that is only available to the owner.
72      */
73     function renounceOwnership() public virtual onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         emit OwnershipTransferred(_owner, newOwner);
85         _owner = newOwner;
86     }
87 }
88 
89 /**
90  * @title Counters
91  * @author Matt Condon (@shrugs)
92  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
93  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
94  *
95  * Include with `using Counters for Counters.Counter;`
96  */
97 library Counters {
98     struct Counter {
99         // This variable should never be directly accessed by users of the library: interactions must be restricted to
100         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
101         // this feature: see https://github.com/ethereum/solidity/issues/4637
102         uint256 _value; // default: 0
103     }
104 
105     function current(Counter storage counter) internal view returns (uint256) {
106         return counter._value;
107     }
108 
109     function increment(Counter storage counter) internal {
110         unchecked {
111             counter._value += 1;
112         }
113     }
114 
115     function decrement(Counter storage counter) internal {
116         uint256 value = counter._value;
117         require(value > 0, "Counter: decrement overflow");
118         unchecked {
119             counter._value = value - 1;
120         }
121     }
122 }
123 
124 /**
125  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
126  *
127  * These functions can be used to verify that a message was signed by the holder
128  * of the private keys of a given address.
129  */
130 library ECDSA {
131     /**
132      * @dev Returns the address that signed a hashed message (`hash`) with
133      * `signature`. This address can then be used for verification purposes.
134      *
135      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
136      * this function rejects them by requiring the `s` value to be in the lower
137      * half order, and the `v` value to be either 27 or 28.
138      *
139      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
140      * verification to be secure: it is possible to craft signatures that
141      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
142      * this is by receiving a hash of the original message (which may otherwise
143      * be too long), and then calling {toEthSignedMessageHash} on it.
144      */
145     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
146         // Check the signature length
147         if (signature.length != 65) {
148             revert("ECDSA: invalid signature length");
149         }
150 
151         // Divide the signature in r, s and v variables
152         bytes32 r;
153         bytes32 s;
154         uint8 v;
155 
156         // ecrecover takes the signature parameters, and the only way to get them
157         // currently is to use assembly.
158         // solhint-disable-next-line no-inline-assembly
159         assembly {
160             r := mload(add(signature, 0x20))
161             s := mload(add(signature, 0x40))
162             v := byte(0, mload(add(signature, 0x60)))
163         }
164 
165         return recover(hash, v, r, s);
166     }
167 
168     /**
169      * @dev Overload of {ECDSA-recover} that receives the `v`,
170      * `r` and `s` signature fields separately.
171      */
172     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
173         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
174         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
175         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
176         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
177         //
178         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
179         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
180         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
181         // these malleable signatures as well.
182         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
183         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
184 
185         // If the signature is valid (and not malleable), return the signer address
186         address signer = ecrecover(hash, v, r, s);
187         require(signer != address(0), "ECDSA: invalid signature");
188 
189         return signer;
190     }
191 
192     /**
193      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
194      * produces hash corresponding to the one signed with the
195      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
196      * JSON-RPC method as part of EIP-191.
197      *
198      * See {recover}.
199      */
200     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
201         // 32 is the length in bytes of hash,
202         // enforced by the type signature above
203         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
204     }
205 
206     /**
207      * @dev Returns an Ethereum Signed Typed Data, created from a
208      * `domainSeparator` and a `structHash`. This produces hash corresponding
209      * to the one signed with the
210      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
211      * JSON-RPC method as part of EIP-712.
212      *
213      * See {recover}.
214      */
215     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
216         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
217     }
218 }
219 
220 /**
221  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
222  *
223  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
224  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
225  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
226  *
227  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
228  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
229  * ({_hashTypedDataV4}).
230  *
231  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
232  * the chain id to protect against replay attacks on an eventual fork of the chain.
233  *
234  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
235  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
236  *
237  * _Available since v3.4._
238  */
239 abstract contract EIP712 {
240     /* solhint-disable var-name-mixedcase */
241     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
242     // invalidate the cached domain separator if the chain id changes.
243     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
244     uint256 private immutable _CACHED_CHAIN_ID;
245 
246     bytes32 private immutable _HASHED_NAME;
247     bytes32 private immutable _HASHED_VERSION;
248     bytes32 private immutable _TYPE_HASH;
249     /* solhint-enable var-name-mixedcase */
250 
251     /**
252      * @dev Initializes the domain separator and parameter caches.
253      *
254      * The meaning of `name` and `version` is specified in
255      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
256      *
257      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
258      * - `version`: the current major version of the signing domain.
259      *
260      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
261      * contract upgrade].
262      */
263     constructor(string memory name, string memory version) {
264         bytes32 hashedName = keccak256(bytes(name));
265         bytes32 hashedVersion = keccak256(bytes(version));
266         bytes32 typeHash = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
267         _HASHED_NAME = hashedName;
268         _HASHED_VERSION = hashedVersion;
269         _CACHED_CHAIN_ID = block.chainid;
270         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
271         _TYPE_HASH = typeHash;
272     }
273 
274     /**
275      * @dev Returns the domain separator for the current chain.
276      */
277     function _domainSeparatorV4() internal view returns (bytes32) {
278         if (block.chainid == _CACHED_CHAIN_ID) {
279             return _CACHED_DOMAIN_SEPARATOR;
280         } else {
281             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
282         }
283     }
284 
285     function _buildDomainSeparator(bytes32 typeHash, bytes32 name, bytes32 version) private view returns (bytes32) {
286         return keccak256(
287             abi.encode(
288                 typeHash,
289                 name,
290                 version,
291                 block.chainid,
292                 address(this)
293             )
294         );
295     }
296 
297     /**
298      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
299      * function returns the hash of the fully encoded EIP712 message for this domain.
300      *
301      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
302      *
303      * ```solidity
304      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
305      *     keccak256("Mail(address to,string contents)"),
306      *     mailTo,
307      *     keccak256(bytes(mailContents))
308      * )));
309      * address signer = ECDSA.recover(digest, signature);
310      * ```
311      */
312     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
313         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
314     }
315 }
316 
317 /**
318  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
319  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
320  *
321  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
322  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
323  * need to send a transaction, and thus is not required to hold Ether at all.
324  */
325 interface IERC20Permit {
326     /**
327      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
328      * given ``owner``'s signed approval.
329      *
330      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
331      * ordering also apply here.
332      *
333      * Emits an {Approval} event.
334      *
335      * Requirements:
336      *
337      * - `spender` cannot be the zero address.
338      * - `deadline` must be a timestamp in the future.
339      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
340      * over the EIP712-formatted function arguments.
341      * - the signature must use ``owner``'s current nonce (see {nonces}).
342      *
343      * For more information on the signature format, see the
344      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
345      * section].
346      */
347     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
348 
349     /**
350      * @dev Returns the current nonce for `owner`. This value must be
351      * included whenever a signature is generated for {permit}.
352      *
353      * Every successful call to {permit} increases ``owner``'s nonce by one. This
354      * prevents a signature from being used multiple times.
355      */
356     function nonces(address owner) external view returns (uint256);
357 
358     /**
359      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
360      */
361     // solhint-disable-next-line func-name-mixedcase
362     function DOMAIN_SEPARATOR() external view returns (bytes32);
363 }
364 
365 /**
366  * @dev Interface of the ERC20 standard as defined in the EIP.
367  */
368 interface IERC20 {
369     /**
370      * @dev Returns the amount of tokens in existence.
371      */
372     function totalSupply() external view returns (uint256);
373 
374     /**
375      * @dev Returns the amount of tokens owned by `account`.
376      */
377     function balanceOf(address account) external view returns (uint256);
378 
379     /**
380      * @dev Moves `amount` tokens from the caller's account to `recipient`.
381      *
382      * Returns a boolean value indicating whether the operation succeeded.
383      *
384      * Emits a {Transfer} event.
385      */
386     function transfer(address recipient, uint256 amount) external returns (bool);
387 
388     /**
389      * @dev Returns the remaining number of tokens that `spender` will be
390      * allowed to spend on behalf of `owner` through {transferFrom}. This is
391      * zero by default.
392      *
393      * This value changes when {approve} or {transferFrom} are called.
394      */
395     function allowance(address owner, address spender) external view returns (uint256);
396 
397     /**
398      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
399      *
400      * Returns a boolean value indicating whether the operation succeeded.
401      *
402      * IMPORTANT: Beware that changing an allowance with this method brings the risk
403      * that someone may use both the old and the new allowance by unfortunate
404      * transaction ordering. One possible solution to mitigate this race
405      * condition is to first reduce the spender's allowance to 0 and set the
406      * desired value afterwards:
407      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
408      *
409      * Emits an {Approval} event.
410      */
411     function approve(address spender, uint256 amount) external returns (bool);
412 
413     /**
414      * @dev Moves `amount` tokens from `sender` to `recipient` using the
415      * allowance mechanism. `amount` is then deducted from the caller's
416      * allowance.
417      *
418      * Returns a boolean value indicating whether the operation succeeded.
419      *
420      * Emits a {Transfer} event.
421      */
422     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
423 
424     /**
425      * @dev Emitted when `value` tokens are moved from one account (`from`) to
426      * another (`to`).
427      *
428      * Note that `value` may be zero.
429      */
430     event Transfer(address indexed from, address indexed to, uint256 value);
431 
432     /**
433      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
434      * a call to {approve}. `value` is the new allowance.
435      */
436     event Approval(address indexed owner, address indexed spender, uint256 value);
437 }
438 
439 /**
440  * @dev Interface for the optional metadata functions from the ERC20 standard.
441  */
442 interface IERC20Metadata is IERC20 {
443     /**
444      * @dev Returns the name of the token.
445      */
446     function name() external view returns (string memory);
447 
448     /**
449      * @dev Returns the symbol of the token.
450      */
451     function symbol() external view returns (string memory);
452 
453     /**
454      * @dev Returns the decimals places of the token.
455      */
456     function decimals() external view returns (uint8);
457 }
458 
459 /**
460  * @dev Implementation of the {IERC20} interface.
461  *
462  * This implementation is agnostic to the way tokens are created. This means
463  * that a supply mechanism has to be added in a derived contract using {_mint}.
464  * For a generic mechanism see {ERC20PresetMinterPauser}.
465  *
466  * TIP: For a detailed writeup see our guide
467  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
468  * to implement supply mechanisms].
469  *
470  * We have followed general OpenZeppelin guidelines: functions revert instead
471  * of returning `false` on failure. This behavior is nonetheless conventional
472  * and does not conflict with the expectations of ERC20 applications.
473  *
474  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
475  * This allows applications to reconstruct the allowance for all accounts just
476  * by listening to said events. Other implementations of the EIP may not emit
477  * these events, as it isn't required by the specification.
478  *
479  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
480  * functions have been added to mitigate the well-known issues around setting
481  * allowances. See {IERC20-approve}.
482  */
483 contract ERC20 is Context, IERC20, IERC20Metadata {
484     mapping (address => uint256) internal _balances;
485 
486     mapping (address => mapping (address => uint256)) private _allowances;
487 
488     uint256 internal _totalSupply;
489 
490     string private _name;
491     string private _symbol;
492 
493     /**
494      * @dev Sets the values for {name} and {symbol}.
495      *
496      * The defaut value of {decimals} is 18. To select a different value for
497      * {decimals} you should overload it.
498      *
499      * All two of these values are immutable: they can only be set once during
500      * construction.
501      */
502     constructor (string memory name_, string memory symbol_) {
503         _name = name_;
504         _symbol = symbol_;
505     }
506 
507     /**
508      * @dev Returns the name of the token.
509      */
510     function name() public view virtual override returns (string memory) {
511         return _name;
512     }
513 
514     /**
515      * @dev Returns the symbol of the token, usually a shorter version of the
516      * name.
517      */
518     function symbol() public view virtual override returns (string memory) {
519         return _symbol;
520     }
521 
522     /**
523      * @dev Returns the number of decimals used to get its user representation.
524      * For example, if `decimals` equals `2`, a balance of `505` tokens should
525      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
526      *
527      * Tokens usually opt for a value of 18, imitating the relationship between
528      * Ether and Wei. This is the value {ERC20} uses, unless this function is
529      * overloaded;
530      *
531      * NOTE: This information is only used for _display_ purposes: it in
532      * no way affects any of the arithmetic of the contract, including
533      * {IERC20-balanceOf} and {IERC20-transfer}.
534      */
535     function decimals() public view virtual override returns (uint8) {
536         return 18;
537     }
538 
539     /**
540      * @dev See {IERC20-totalSupply}.
541      */
542     function totalSupply() public view virtual override returns (uint256) {
543         return _totalSupply;
544     }
545 
546     /**
547      * @dev See {IERC20-balanceOf}.
548      */
549     function balanceOf(address account) public view virtual override returns (uint256) {
550         return _balances[account];
551     }
552 
553     /**
554      * @dev See {IERC20-transfer}.
555      *
556      * Requirements:
557      *
558      * - `recipient` cannot be the zero address.
559      * - the caller must have a balance of at least `amount`.
560      */
561     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
562         _transfer(_msgSender(), recipient, amount);
563         return true;
564     }
565 
566     /**
567      * @dev See {IERC20-allowance}.
568      */
569     function allowance(address owner, address spender) public view virtual override returns (uint256) {
570         return _allowances[owner][spender];
571     }
572 
573     /**
574      * @dev See {IERC20-approve}.
575      *
576      * Requirements:
577      *
578      * - `spender` cannot be the zero address.
579      */
580     function approve(address spender, uint256 amount) public virtual override returns (bool) {
581         _approve(_msgSender(), spender, amount);
582         return true;
583     }
584 
585     /**
586      * @dev See {IERC20-transferFrom}.
587      *
588      * Emits an {Approval} event indicating the updated allowance. This is not
589      * required by the EIP. See the note at the beginning of {ERC20}.
590      *
591      * Requirements:
592      *
593      * - `sender` and `recipient` cannot be the zero address.
594      * - `sender` must have a balance of at least `amount`.
595      * - the caller must have allowance for ``sender``'s tokens of at least
596      * `amount`.
597      */
598     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
599         _transfer(sender, recipient, amount);
600 
601         uint256 currentAllowance = _allowances[sender][_msgSender()];
602         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
603         _approve(sender, _msgSender(), currentAllowance - amount);
604 
605         return true;
606     }
607 
608     /**
609      * @dev Atomically increases the allowance granted to `spender` by the caller.
610      *
611      * This is an alternative to {approve} that can be used as a mitigation for
612      * problems described in {IERC20-approve}.
613      *
614      * Emits an {Approval} event indicating the updated allowance.
615      *
616      * Requirements:
617      *
618      * - `spender` cannot be the zero address.
619      */
620     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
621         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
622         return true;
623     }
624 
625     /**
626      * @dev Atomically decreases the allowance granted to `spender` by the caller.
627      *
628      * This is an alternative to {approve} that can be used as a mitigation for
629      * problems described in {IERC20-approve}.
630      *
631      * Emits an {Approval} event indicating the updated allowance.
632      *
633      * Requirements:
634      *
635      * - `spender` cannot be the zero address.
636      * - `spender` must have allowance for the caller of at least
637      * `subtractedValue`.
638      */
639     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
640         uint256 currentAllowance = _allowances[_msgSender()][spender];
641         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
642         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
643 
644         return true;
645     }
646 
647     /**
648      * @dev Moves tokens `amount` from `sender` to `recipient`.
649      *
650      * This is internal function is equivalent to {transfer}, and can be used to
651      * e.g. implement automatic token fees, slashing mechanisms, etc.
652      *
653      * Emits a {Transfer} event.
654      *
655      * Requirements:
656      *
657      * - `sender` cannot be the zero address.
658      * - `recipient` cannot be the zero address.
659      * - `sender` must have a balance of at least `amount`.
660      */
661     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
662         require(sender != address(0), "ERC20: transfer from the zero address");
663         require(recipient != address(0), "ERC20: transfer to the zero address");
664 
665         uint256 senderBalance = _balances[sender];
666         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
667         _balances[sender] = senderBalance - amount;
668         _balances[recipient] += amount;
669 
670         emit Transfer(sender, recipient, amount);
671     }
672 
673     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
674      * the total supply.
675      *
676      * Emits a {Transfer} event with `from` set to the zero address.
677      *
678      * Requirements:
679      *
680      * - `to` cannot be the zero address.
681      */
682     function _mint(address account, uint256 amount) internal virtual {
683         require(account != address(0), "ERC20: mint to the zero address");
684 
685         _totalSupply += amount;
686         _balances[account] += amount;
687         emit Transfer(address(0), account, amount);
688     }
689 
690     /**
691      * @dev Destroys `amount` tokens from `account`, reducing the
692      * total supply.
693      *
694      * Emits a {Transfer} event with `to` set to the zero address.
695      *
696      * Requirements:
697      *
698      * - `account` cannot be the zero address.
699      * - `account` must have at least `amount` tokens.
700      */
701     function _burn(address account, uint256 amount) internal virtual {
702         require(account != address(0), "ERC20: burn from the zero address");
703 
704         uint256 accountBalance = _balances[account];
705         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
706         _balances[account] = accountBalance - amount;
707         _totalSupply -= amount;
708 
709         emit Transfer(account, address(0), amount);
710     }
711 
712     /**
713      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
714      *
715      * This internal function is equivalent to `approve`, and can be used to
716      * e.g. set automatic allowances for certain subsystems, etc.
717      *
718      * Emits an {Approval} event.
719      *
720      * Requirements:
721      *
722      * - `owner` cannot be the zero address.
723      * - `spender` cannot be the zero address.
724      */
725     function _approve(address owner, address spender, uint256 amount) internal virtual {
726         require(owner != address(0), "ERC20: approve from the zero address");
727         require(spender != address(0), "ERC20: approve to the zero address");
728 
729         _allowances[owner][spender] = amount;
730         emit Approval(owner, spender, amount);
731     }
732 }
733 
734 /**
735  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
736  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
737  *
738  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
739  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
740  * need to send a transaction, and thus is not required to hold Ether at all.
741  *
742  * _Available since v3.4._
743  */
744 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
745     using Counters for Counters.Counter;
746 
747     mapping (address => Counters.Counter) private _nonces;
748 
749     // solhint-disable-next-line var-name-mixedcase
750     bytes32 private immutable _PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
751 
752     /**
753      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
754      *
755      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
756      */
757     constructor(string memory name) EIP712(name, "1") {
758     }
759 
760     /**
761      * @dev See {IERC20Permit-permit}.
762      */
763     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual override {
764         // solhint-disable-next-line not-rely-on-time
765         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
766 
767         bytes32 structHash = keccak256(
768             abi.encode(
769                 _PERMIT_TYPEHASH,
770                 owner,
771                 spender,
772                 value,
773                 _useNonce(owner),
774                 deadline
775             )
776         );
777 
778         bytes32 hash = _hashTypedDataV4(structHash);
779 
780         address signer = ECDSA.recover(hash, v, r, s);
781         require(signer == owner, "ERC20Permit: invalid signature");
782 
783         _approve(owner, spender, value);
784     }
785 
786     /**
787      * @dev See {IERC20Permit-nonces}.
788      */
789     function nonces(address owner) public view virtual override returns (uint256) {
790         return _nonces[owner].current();
791     }
792 
793     /**
794      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
795      */
796     // solhint-disable-next-line func-name-mixedcase
797     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
798         return _domainSeparatorV4();
799     }
800 
801     /**
802      * @dev "Consume a nonce": return the current value and increment.
803      */
804     function _useNonce(address owner) internal virtual returns (uint256 current) {
805         Counters.Counter storage nonce = _nonces[owner];
806         current = nonce.current();
807         nonce.increment();
808     }
809 }
810 
811 /**
812  * ICE is a token which enables the work and token economics of Popsicle finance -
813  * a cross-chain yield enhancement platform focusing on
814  * Automated Market-Making (AMM) Liquidity Providers (LP)
815  */
816 contract IceToken is ERC20Permit, Ownable {
817     
818     constructor()  ERC20("IceToken", "ICE") ERC20Permit("IceToken") 
819     {
820         
821     }
822     
823     
824     // Maximum total supply of the token (69M)
825     uint256 private _maxTotalSupply = 69000000000000000000000000;
826 
827     
828     // Returns maximum total supply of the token
829     function getMaxTotalSupply() external view returns (uint256) {
830         return _maxTotalSupply;
831     }
832     
833     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
834      * the total supply.
835      *
836      * Emits a {Transfer} event with `from` set to the zero address.
837      *
838      * Requirements
839      *
840      * - `to` cannot be the zero address.
841      * - can be called only by the owner of contract
842      */
843     function mint(address account, uint256 amount) external onlyOwner {
844         _mint(account, amount);
845     }
846     
847     /**
848      * @dev Destroys `amount` tokens from `account`, reducing the
849      * total supply.
850      *
851      * Emits a {Transfer} event with `to` set to the zero address.
852      *
853      * Requirements
854      *
855      * - `account` cannot be the zero address.
856      * - `account` must have at least `amount` tokens.
857      */
858     function burn(address account, uint256 amount) external onlyOwner {
859         _burn(account, amount);
860     }
861     
862     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
863      * the total supply.
864      *
865      * Emits a {Transfer} event with `from` set to the zero address.
866      *
867      * Requirements
868      *
869      * - `to` cannot be the zero address.
870      */
871     function _mint(address account, uint256 amount) internal override {
872         require(account != address(0), "ERC20: mint to the zero address");
873         require(_totalSupply + amount <= _maxTotalSupply, "ERC20: minting more then MaxTotalSupply");
874         
875         _totalSupply += amount;
876         _balances[account] += amount;
877         emit Transfer(address(0), account, amount);
878     }
879 }