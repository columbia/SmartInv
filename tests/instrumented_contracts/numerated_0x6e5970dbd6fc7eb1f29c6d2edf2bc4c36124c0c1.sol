1 // File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.1.0
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
9  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
10  *
11  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
12  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
13  * need to send a transaction, and thus is not required to hold Ether at all.
14  */
15 interface IERC20Permit {
16     /**
17      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
18      * given ``owner``'s signed approval.
19      *
20      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
21      * ordering also apply here.
22      *
23      * Emits an {Approval} event.
24      *
25      * Requirements:
26      *
27      * - `spender` cannot be the zero address.
28      * - `deadline` must be a timestamp in the future.
29      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
30      * over the EIP712-formatted function arguments.
31      * - the signature must use ``owner``'s current nonce (see {nonces}).
32      *
33      * For more information on the signature format, see the
34      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
35      * section].
36      */
37     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
38 
39     /**
40      * @dev Returns the current nonce for `owner`. This value must be
41      * included whenever a signature is generated for {permit}.
42      *
43      * Every successful call to {permit} increases ``owner``'s nonce by one. This
44      * prevents a signature from being used multiple times.
45      */
46     function nonces(address owner) external view returns (uint256);
47 
48     /**
49      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
50      */
51     // solhint-disable-next-line func-name-mixedcase
52     function DOMAIN_SEPARATOR() external view returns (bytes32);
53 }
54 
55 
56 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.1.0
57 
58 pragma solidity ^0.8.0;
59 
60 /**
61  * @dev Interface of the ERC20 standard as defined in the EIP.
62  */
63 interface IERC20 {
64     /**
65      * @dev Returns the amount of tokens in existence.
66      */
67     function totalSupply() external view returns (uint256);
68 
69     /**
70      * @dev Returns the amount of tokens owned by `account`.
71      */
72     function balanceOf(address account) external view returns (uint256);
73 
74     /**
75      * @dev Moves `amount` tokens from the caller's account to `recipient`.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transfer(address recipient, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Returns the remaining number of tokens that `spender` will be
85      * allowed to spend on behalf of `owner` through {transferFrom}. This is
86      * zero by default.
87      *
88      * This value changes when {approve} or {transferFrom} are called.
89      */
90     function allowance(address owner, address spender) external view returns (uint256);
91 
92     /**
93      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * IMPORTANT: Beware that changing an allowance with this method brings the risk
98      * that someone may use both the old and the new allowance by unfortunate
99      * transaction ordering. One possible solution to mitigate this race
100      * condition is to first reduce the spender's allowance to 0 and set the
101      * desired value afterwards:
102      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
103      *
104      * Emits an {Approval} event.
105      */
106     function approve(address spender, uint256 amount) external returns (bool);
107 
108     /**
109      * @dev Moves `amount` tokens from `sender` to `recipient` using the
110      * allowance mechanism. `amount` is then deducted from the caller's
111      * allowance.
112      *
113      * Returns a boolean value indicating whether the operation succeeded.
114      *
115      * Emits a {Transfer} event.
116      */
117     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
118 
119     /**
120      * @dev Emitted when `value` tokens are moved from one account (`from`) to
121      * another (`to`).
122      *
123      * Note that `value` may be zero.
124      */
125     event Transfer(address indexed from, address indexed to, uint256 value);
126 
127     /**
128      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
129      * a call to {approve}. `value` is the new allowance.
130      */
131     event Approval(address indexed owner, address indexed spender, uint256 value);
132 }
133 
134 
135 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.1.0
136 
137 pragma solidity ^0.8.0;
138 
139 /**
140  * @dev Interface for the optional metadata functions from the ERC20 standard.
141  *
142  * _Available since v4.1._
143  */
144 interface IERC20Metadata is IERC20 {
145     /**
146      * @dev Returns the name of the token.
147      */
148     function name() external view returns (string memory);
149 
150     /**
151      * @dev Returns the symbol of the token.
152      */
153     function symbol() external view returns (string memory);
154 
155     /**
156      * @dev Returns the decimals places of the token.
157      */
158     function decimals() external view returns (uint8);
159 }
160 
161 
162 // File @openzeppelin/contracts/utils/Context.sol@v4.1.0
163 
164 pragma solidity ^0.8.0;
165 
166 /*
167  * @dev Provides information about the current execution context, including the
168  * sender of the transaction and its data. While these are generally available
169  * via msg.sender and msg.data, they should not be accessed in such a direct
170  * manner, since when dealing with meta-transactions the account sending and
171  * paying for execution may not be the actual sender (as far as an application
172  * is concerned).
173  *
174  * This contract is only required for intermediate, library-like contracts.
175  */
176 abstract contract Context {
177     function _msgSender() internal view virtual returns (address) {
178         return msg.sender;
179     }
180 
181     function _msgData() internal view virtual returns (bytes calldata) {
182         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
183         return msg.data;
184     }
185 }
186 
187 
188 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.1.0
189 
190 pragma solidity ^0.8.0;
191 
192 
193 
194 /**
195  * @dev Implementation of the {IERC20} interface.
196  *
197  * This implementation is agnostic to the way tokens are created. This means
198  * that a supply mechanism has to be added in a derived contract using {_mint}.
199  * For a generic mechanism see {ERC20PresetMinterPauser}.
200  *
201  * TIP: For a detailed writeup see our guide
202  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
203  * to implement supply mechanisms].
204  *
205  * We have followed general OpenZeppelin guidelines: functions revert instead
206  * of returning `false` on failure. This behavior is nonetheless conventional
207  * and does not conflict with the expectations of ERC20 applications.
208  *
209  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
210  * This allows applications to reconstruct the allowance for all accounts just
211  * by listening to said events. Other implementations of the EIP may not emit
212  * these events, as it isn't required by the specification.
213  *
214  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
215  * functions have been added to mitigate the well-known issues around setting
216  * allowances. See {IERC20-approve}.
217  */
218 contract ERC20 is Context, IERC20, IERC20Metadata {
219     mapping (address => uint256) private _balances;
220 
221     mapping (address => mapping (address => uint256)) private _allowances;
222 
223     uint256 private _totalSupply;
224 
225     string private _name;
226     string private _symbol;
227 
228     /**
229      * @dev Sets the values for {name} and {symbol}.
230      *
231      * The defaut value of {decimals} is 18. To select a different value for
232      * {decimals} you should overload it.
233      *
234      * All two of these values are immutable: they can only be set once during
235      * construction.
236      */
237     constructor (string memory name_, string memory symbol_) {
238         _name = name_;
239         _symbol = symbol_;
240     }
241 
242     /**
243      * @dev Returns the name of the token.
244      */
245     function name() public view virtual override returns (string memory) {
246         return _name;
247     }
248 
249     /**
250      * @dev Returns the symbol of the token, usually a shorter version of the
251      * name.
252      */
253     function symbol() public view virtual override returns (string memory) {
254         return _symbol;
255     }
256 
257     /**
258      * @dev Returns the number of decimals used to get its user representation.
259      * For example, if `decimals` equals `2`, a balance of `505` tokens should
260      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
261      *
262      * Tokens usually opt for a value of 18, imitating the relationship between
263      * Ether and Wei. This is the value {ERC20} uses, unless this function is
264      * overridden;
265      *
266      * NOTE: This information is only used for _display_ purposes: it in
267      * no way affects any of the arithmetic of the contract, including
268      * {IERC20-balanceOf} and {IERC20-transfer}.
269      */
270     function decimals() public view virtual override returns (uint8) {
271         return 18;
272     }
273 
274     /**
275      * @dev See {IERC20-totalSupply}.
276      */
277     function totalSupply() public view virtual override returns (uint256) {
278         return _totalSupply;
279     }
280 
281     /**
282      * @dev See {IERC20-balanceOf}.
283      */
284     function balanceOf(address account) public view virtual override returns (uint256) {
285         return _balances[account];
286     }
287 
288     /**
289      * @dev See {IERC20-transfer}.
290      *
291      * Requirements:
292      *
293      * - `recipient` cannot be the zero address.
294      * - the caller must have a balance of at least `amount`.
295      */
296     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
297         _transfer(_msgSender(), recipient, amount);
298         return true;
299     }
300 
301     /**
302      * @dev See {IERC20-allowance}.
303      */
304     function allowance(address owner, address spender) public view virtual override returns (uint256) {
305         return _allowances[owner][spender];
306     }
307 
308     /**
309      * @dev See {IERC20-approve}.
310      *
311      * Requirements:
312      *
313      * - `spender` cannot be the zero address.
314      */
315     function approve(address spender, uint256 amount) public virtual override returns (bool) {
316         _approve(_msgSender(), spender, amount);
317         return true;
318     }
319 
320     /**
321      * @dev See {IERC20-transferFrom}.
322      *
323      * Emits an {Approval} event indicating the updated allowance. This is not
324      * required by the EIP. See the note at the beginning of {ERC20}.
325      *
326      * Requirements:
327      *
328      * - `sender` and `recipient` cannot be the zero address.
329      * - `sender` must have a balance of at least `amount`.
330      * - the caller must have allowance for ``sender``'s tokens of at least
331      * `amount`.
332      */
333     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
334         _transfer(sender, recipient, amount);
335 
336         uint256 currentAllowance = _allowances[sender][_msgSender()];
337         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
338         _approve(sender, _msgSender(), currentAllowance - amount);
339 
340         return true;
341     }
342 
343     /**
344      * @dev Atomically increases the allowance granted to `spender` by the caller.
345      *
346      * This is an alternative to {approve} that can be used as a mitigation for
347      * problems described in {IERC20-approve}.
348      *
349      * Emits an {Approval} event indicating the updated allowance.
350      *
351      * Requirements:
352      *
353      * - `spender` cannot be the zero address.
354      */
355     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
356         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
357         return true;
358     }
359 
360     /**
361      * @dev Atomically decreases the allowance granted to `spender` by the caller.
362      *
363      * This is an alternative to {approve} that can be used as a mitigation for
364      * problems described in {IERC20-approve}.
365      *
366      * Emits an {Approval} event indicating the updated allowance.
367      *
368      * Requirements:
369      *
370      * - `spender` cannot be the zero address.
371      * - `spender` must have allowance for the caller of at least
372      * `subtractedValue`.
373      */
374     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
375         uint256 currentAllowance = _allowances[_msgSender()][spender];
376         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
377         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
378 
379         return true;
380     }
381 
382     /**
383      * @dev Moves tokens `amount` from `sender` to `recipient`.
384      *
385      * This is internal function is equivalent to {transfer}, and can be used to
386      * e.g. implement automatic token fees, slashing mechanisms, etc.
387      *
388      * Emits a {Transfer} event.
389      *
390      * Requirements:
391      *
392      * - `sender` cannot be the zero address.
393      * - `recipient` cannot be the zero address.
394      * - `sender` must have a balance of at least `amount`.
395      */
396     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
397         require(sender != address(0), "ERC20: transfer from the zero address");
398         require(recipient != address(0), "ERC20: transfer to the zero address");
399 
400         _beforeTokenTransfer(sender, recipient, amount);
401 
402         uint256 senderBalance = _balances[sender];
403         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
404         _balances[sender] = senderBalance - amount;
405         _balances[recipient] += amount;
406 
407         emit Transfer(sender, recipient, amount);
408     }
409 
410     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
411      * the total supply.
412      *
413      * Emits a {Transfer} event with `from` set to the zero address.
414      *
415      * Requirements:
416      *
417      * - `to` cannot be the zero address.
418      */
419     function _mint(address account, uint256 amount) internal virtual {
420         require(account != address(0), "ERC20: mint to the zero address");
421 
422         _beforeTokenTransfer(address(0), account, amount);
423 
424         _totalSupply += amount;
425         _balances[account] += amount;
426         emit Transfer(address(0), account, amount);
427     }
428 
429     /**
430      * @dev Destroys `amount` tokens from `account`, reducing the
431      * total supply.
432      *
433      * Emits a {Transfer} event with `to` set to the zero address.
434      *
435      * Requirements:
436      *
437      * - `account` cannot be the zero address.
438      * - `account` must have at least `amount` tokens.
439      */
440     function _burn(address account, uint256 amount) internal virtual {
441         require(account != address(0), "ERC20: burn from the zero address");
442 
443         _beforeTokenTransfer(account, address(0), amount);
444 
445         uint256 accountBalance = _balances[account];
446         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
447         _balances[account] = accountBalance - amount;
448         _totalSupply -= amount;
449 
450         emit Transfer(account, address(0), amount);
451     }
452 
453     /**
454      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
455      *
456      * This internal function is equivalent to `approve`, and can be used to
457      * e.g. set automatic allowances for certain subsystems, etc.
458      *
459      * Emits an {Approval} event.
460      *
461      * Requirements:
462      *
463      * - `owner` cannot be the zero address.
464      * - `spender` cannot be the zero address.
465      */
466     function _approve(address owner, address spender, uint256 amount) internal virtual {
467         require(owner != address(0), "ERC20: approve from the zero address");
468         require(spender != address(0), "ERC20: approve to the zero address");
469 
470         _allowances[owner][spender] = amount;
471         emit Approval(owner, spender, amount);
472     }
473 
474     /**
475      * @dev Hook that is called before any transfer of tokens. This includes
476      * minting and burning.
477      *
478      * Calling conditions:
479      *
480      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
481      * will be to transferred to `to`.
482      * - when `from` is zero, `amount` tokens will be minted for `to`.
483      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
484      * - `from` and `to` are never both zero.
485      *
486      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
487      */
488     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
489 }
490 
491 
492 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.1.0
493 
494 pragma solidity ^0.8.0;
495 
496 /**
497  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
498  *
499  * These functions can be used to verify that a message was signed by the holder
500  * of the private keys of a given address.
501  */
502 library ECDSA {
503     /**
504      * @dev Returns the address that signed a hashed message (`hash`) with
505      * `signature`. This address can then be used for verification purposes.
506      *
507      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
508      * this function rejects them by requiring the `s` value to be in the lower
509      * half order, and the `v` value to be either 27 or 28.
510      *
511      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
512      * verification to be secure: it is possible to craft signatures that
513      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
514      * this is by receiving a hash of the original message (which may otherwise
515      * be too long), and then calling {toEthSignedMessageHash} on it.
516      */
517     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
518         // Divide the signature in r, s and v variables
519         bytes32 r;
520         bytes32 s;
521         uint8 v;
522 
523         // Check the signature length
524         // - case 65: r,s,v signature (standard)
525         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
526         if (signature.length == 65) {
527             // ecrecover takes the signature parameters, and the only way to get them
528             // currently is to use assembly.
529             // solhint-disable-next-line no-inline-assembly
530             assembly {
531                 r := mload(add(signature, 0x20))
532                 s := mload(add(signature, 0x40))
533                 v := byte(0, mload(add(signature, 0x60)))
534             }
535         } else if (signature.length == 64) {
536             // ecrecover takes the signature parameters, and the only way to get them
537             // currently is to use assembly.
538             // solhint-disable-next-line no-inline-assembly
539             assembly {
540                 let vs := mload(add(signature, 0x40))
541                 r := mload(add(signature, 0x20))
542                 s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
543                 v := add(shr(255, vs), 27)
544             }
545         } else {
546             revert("ECDSA: invalid signature length");
547         }
548 
549         return recover(hash, v, r, s);
550     }
551 
552     /**
553      * @dev Overload of {ECDSA-recover} that receives the `v`,
554      * `r` and `s` signature fields separately.
555      */
556     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
557         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
558         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
559         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
560         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
561         //
562         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
563         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
564         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
565         // these malleable signatures as well.
566         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
567         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
568 
569         // If the signature is valid (and not malleable), return the signer address
570         address signer = ecrecover(hash, v, r, s);
571         require(signer != address(0), "ECDSA: invalid signature");
572 
573         return signer;
574     }
575 
576     /**
577      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
578      * produces hash corresponding to the one signed with the
579      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
580      * JSON-RPC method as part of EIP-191.
581      *
582      * See {recover}.
583      */
584     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
585         // 32 is the length in bytes of hash,
586         // enforced by the type signature above
587         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
588     }
589 
590     /**
591      * @dev Returns an Ethereum Signed Typed Data, created from a
592      * `domainSeparator` and a `structHash`. This produces hash corresponding
593      * to the one signed with the
594      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
595      * JSON-RPC method as part of EIP-712.
596      *
597      * See {recover}.
598      */
599     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
600         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
601     }
602 }
603 
604 
605 // File @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol@v4.1.0
606 
607 pragma solidity ^0.8.0;
608 
609 /**
610  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
611  *
612  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
613  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
614  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
615  *
616  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
617  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
618  * ({_hashTypedDataV4}).
619  *
620  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
621  * the chain id to protect against replay attacks on an eventual fork of the chain.
622  *
623  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
624  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
625  *
626  * _Available since v3.4._
627  */
628 abstract contract EIP712 {
629     /* solhint-disable var-name-mixedcase */
630     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
631     // invalidate the cached domain separator if the chain id changes.
632     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
633     uint256 private immutable _CACHED_CHAIN_ID;
634 
635     bytes32 private immutable _HASHED_NAME;
636     bytes32 private immutable _HASHED_VERSION;
637     bytes32 private immutable _TYPE_HASH;
638     /* solhint-enable var-name-mixedcase */
639 
640     /**
641      * @dev Initializes the domain separator and parameter caches.
642      *
643      * The meaning of `name` and `version` is specified in
644      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
645      *
646      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
647      * - `version`: the current major version of the signing domain.
648      *
649      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
650      * contract upgrade].
651      */
652     constructor(string memory name, string memory version) {
653         bytes32 hashedName = keccak256(bytes(name));
654         bytes32 hashedVersion = keccak256(bytes(version));
655         bytes32 typeHash = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
656         _HASHED_NAME = hashedName;
657         _HASHED_VERSION = hashedVersion;
658         _CACHED_CHAIN_ID = block.chainid;
659         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
660         _TYPE_HASH = typeHash;
661     }
662 
663     /**
664      * @dev Returns the domain separator for the current chain.
665      */
666     function _domainSeparatorV4() internal view returns (bytes32) {
667         if (block.chainid == _CACHED_CHAIN_ID) {
668             return _CACHED_DOMAIN_SEPARATOR;
669         } else {
670             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
671         }
672     }
673 
674     function _buildDomainSeparator(bytes32 typeHash, bytes32 name, bytes32 version) private view returns (bytes32) {
675         return keccak256(
676             abi.encode(
677                 typeHash,
678                 name,
679                 version,
680                 block.chainid,
681                 address(this)
682             )
683         );
684     }
685 
686     /**
687      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
688      * function returns the hash of the fully encoded EIP712 message for this domain.
689      *
690      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
691      *
692      * ```solidity
693      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
694      *     keccak256("Mail(address to,string contents)"),
695      *     mailTo,
696      *     keccak256(bytes(mailContents))
697      * )));
698      * address signer = ECDSA.recover(digest, signature);
699      * ```
700      */
701     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
702         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
703     }
704 }
705 
706 
707 // File @openzeppelin/contracts/utils/Counters.sol@v4.1.0
708 
709 pragma solidity ^0.8.0;
710 
711 /**
712  * @title Counters
713  * @author Matt Condon (@shrugs)
714  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
715  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
716  *
717  * Include with `using Counters for Counters.Counter;`
718  */
719 library Counters {
720     struct Counter {
721         // This variable should never be directly accessed by users of the library: interactions must be restricted to
722         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
723         // this feature: see https://github.com/ethereum/solidity/issues/4637
724         uint256 _value; // default: 0
725     }
726 
727     function current(Counter storage counter) internal view returns (uint256) {
728         return counter._value;
729     }
730 
731     function increment(Counter storage counter) internal {
732         unchecked {
733             counter._value += 1;
734         }
735     }
736 
737     function decrement(Counter storage counter) internal {
738         uint256 value = counter._value;
739         require(value > 0, "Counter: decrement overflow");
740         unchecked {
741             counter._value = value - 1;
742         }
743     }
744 }
745 
746 
747 // File @openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol@v4.1.0
748 
749 pragma solidity ^0.8.0;
750 
751 
752 
753 
754 
755 /**
756  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
757  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
758  *
759  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
760  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
761  * need to send a transaction, and thus is not required to hold Ether at all.
762  *
763  * _Available since v3.4._
764  */
765 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
766     using Counters for Counters.Counter;
767 
768     mapping (address => Counters.Counter) private _nonces;
769 
770     // solhint-disable-next-line var-name-mixedcase
771     bytes32 private immutable _PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
772 
773     /**
774      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
775      *
776      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
777      */
778     constructor(string memory name) EIP712(name, "1") {
779     }
780 
781     /**
782      * @dev See {IERC20Permit-permit}.
783      */
784     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual override {
785         // solhint-disable-next-line not-rely-on-time
786         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
787 
788         bytes32 structHash = keccak256(
789             abi.encode(
790                 _PERMIT_TYPEHASH,
791                 owner,
792                 spender,
793                 value,
794                 _useNonce(owner),
795                 deadline
796             )
797         );
798 
799         bytes32 hash = _hashTypedDataV4(structHash);
800 
801         address signer = ECDSA.recover(hash, v, r, s);
802         require(signer == owner, "ERC20Permit: invalid signature");
803 
804         _approve(owner, spender, value);
805     }
806 
807     /**
808      * @dev See {IERC20Permit-nonces}.
809      */
810     function nonces(address owner) public view virtual override returns (uint256) {
811         return _nonces[owner].current();
812     }
813 
814     /**
815      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
816      */
817     // solhint-disable-next-line func-name-mixedcase
818     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
819         return _domainSeparatorV4();
820     }
821 
822     /**
823      * @dev "Consume a nonce": return the current value and increment.
824      *
825      * _Available since v4.1._
826      */
827     function _useNonce(address owner) internal virtual returns (uint256 current) {
828         Counters.Counter storage nonce = _nonces[owner];
829         current = nonce.current();
830         nonce.increment();
831     }
832 }
833 
834 
835 // File contracts/PolyTadeToken.sol
836 
837 pragma solidity 0.8.4;
838 
839 contract PolyTradeToken is ERC20Permit {
840 
841     address public governance;
842 
843     // The timestamp after which minting may occur
844     uint256 public mintAllowedAfter;
845 
846     // The timestamp after which burning may occur
847     uint256 public burnAllowedAfter;
848 
849     // Minimum time between mints/burns
850     uint32 public constant minimumTime = 1 days * 365;
851 
852     // Cap on the percentage of totalSupply that can be minted/burned at each mint/burn
853     uint8 public constant cap = 2;
854 
855     event GovernanceChanged(address indexed oldGovernance, address indexed newGovernance);
856 
857     constructor(
858         string memory name,
859         string memory symbol,
860         uint256 initialSupply,
861         uint256 allowedAfter,
862         address _governance,
863         address account
864     )
865         ERC20(name, symbol)
866         ERC20Permit(name)
867     {   
868         require(allowedAfter >= 0, "Minting/Burning can only begin after deployment");
869         mintAllowedAfter = block.timestamp + allowedAfter;
870         burnAllowedAfter = block.timestamp + allowedAfter;
871         governance = _governance;
872         _mint(account, initialSupply);
873     }
874 
875     /**
876      * @notice Change the governance address
877      * @param _governance The address of the new governance
878      */
879     function setGovernance(address _governance) external {
880         require(msg.sender == governance, "Unauthorised access");
881         emit GovernanceChanged(governance, _governance);
882         governance = _governance;
883     }
884 
885     /**
886      * @notice Mint new tokens
887      * @param receiver The address of the destination account
888      * @param amount The number of tokens to be minted
889      */
890     function mint(address receiver, uint amount) external {
891         require(msg.sender == governance, "Unauthorized access");
892         require(block.timestamp >= mintAllowedAfter, "minting not allowed yet");
893         require(receiver != address(0), "cannot transfer to the zero address");
894 
895         // record the mint
896         mintAllowedAfter = block.timestamp + minimumTime;
897 
898         // mint the amount
899         require(amount <= ((totalSupply() * cap)/100), "exceeded mint cap");
900         _mint(receiver, amount);
901     }
902 
903     /**
904      * @notice Burn tokens
905      * @param amount The number of tokens to be burned
906      * Tokens will be burned from governance account
907      */
908     function burn(uint amount) external {
909         require(msg.sender == governance, "Unauthorized access");
910         require(block.timestamp >= burnAllowedAfter, "burning not allowed yet");
911 
912         // record the mint
913         burnAllowedAfter = block.timestamp + minimumTime;
914 
915         // mint the amount
916         require(amount <= ((totalSupply() * cap)/100), "exceeded burn cap");
917         _burn(governance, amount);
918     }
919 
920 }