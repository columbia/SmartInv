1 pragma solidity 0.8.4;
2 
3 
4 // SPDX-License-Identifier: MIT
5 /**
6  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
7  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
8  *
9  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
10  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
11  * need to send a transaction, and thus is not required to hold Ether at all.
12  */
13 interface IERC20Permit {
14     /**
15      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
16      * given ``owner``'s signed approval.
17      *
18      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
19      * ordering also apply here.
20      *
21      * Emits an {Approval} event.
22      *
23      * Requirements:
24      *
25      * - `spender` cannot be the zero address.
26      * - `deadline` must be a timestamp in the future.
27      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
28      * over the EIP712-formatted function arguments.
29      * - the signature must use ``owner``'s current nonce (see {nonces}).
30      *
31      * For more information on the signature format, see the
32      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
33      * section].
34      */
35     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
36 
37     /**
38      * @dev Returns the current nonce for `owner`. This value must be
39      * included whenever a signature is generated for {permit}.
40      *
41      * Every successful call to {permit} increases ``owner``'s nonce by one. This
42      * prevents a signature from being used multiple times.
43      */
44     function nonces(address owner) external view returns (uint256);
45 
46     /**
47      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
48      */
49     // solhint-disable-next-line func-name-mixedcase
50     function DOMAIN_SEPARATOR() external view returns (bytes32);
51 }
52 
53 /**
54  * @dev Interface of the ERC20 standard as defined in the EIP.
55  */
56 interface IERC20 {
57     /**
58      * @dev Returns the amount of tokens in existence.
59      */
60     function totalSupply() external view returns (uint256);
61 
62     /**
63      * @dev Returns the amount of tokens owned by `account`.
64      */
65     function balanceOf(address account) external view returns (uint256);
66 
67     /**
68      * @dev Moves `amount` tokens from the caller's account to `recipient`.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transfer(address recipient, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Returns the remaining number of tokens that `spender` will be
78      * allowed to spend on behalf of `owner` through {transferFrom}. This is
79      * zero by default.
80      *
81      * This value changes when {approve} or {transferFrom} are called.
82      */
83     function allowance(address owner, address spender) external view returns (uint256);
84 
85     /**
86      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * IMPORTANT: Beware that changing an allowance with this method brings the risk
91      * that someone may use both the old and the new allowance by unfortunate
92      * transaction ordering. One possible solution to mitigate this race
93      * condition is to first reduce the spender's allowance to 0 and set the
94      * desired value afterwards:
95      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
96      *
97      * Emits an {Approval} event.
98      */
99     function approve(address spender, uint256 amount) external returns (bool);
100 
101     /**
102      * @dev Moves `amount` tokens from `sender` to `recipient` using the
103      * allowance mechanism. `amount` is then deducted from the caller's
104      * allowance.
105      *
106      * Returns a boolean value indicating whether the operation succeeded.
107      *
108      * Emits a {Transfer} event.
109      */
110     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
111 
112     /**
113      * @dev Emitted when `value` tokens are moved from one account (`from`) to
114      * another (`to`).
115      *
116      * Note that `value` may be zero.
117      */
118     event Transfer(address indexed from, address indexed to, uint256 value);
119 
120     /**
121      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
122      * a call to {approve}. `value` is the new allowance.
123      */
124     event Approval(address indexed owner, address indexed spender, uint256 value);
125 }
126 
127 /**
128  * @dev Interface for the optional metadata functions from the ERC20 standard.
129  *
130  * _Available since v4.1._
131  */
132 interface IERC20Metadata is IERC20 {
133     /**
134      * @dev Returns the name of the token.
135      */
136     function name() external view returns (string memory);
137 
138     /**
139      * @dev Returns the symbol of the token.
140      */
141     function symbol() external view returns (string memory);
142 
143     /**
144      * @dev Returns the decimals places of the token.
145      */
146     function decimals() external view returns (uint8);
147 }
148 
149 /*
150  * @dev Provides information about the current execution context, including the
151  * sender of the transaction and its data. While these are generally available
152  * via msg.sender and msg.data, they should not be accessed in such a direct
153  * manner, since when dealing with meta-transactions the account sending and
154  * paying for execution may not be the actual sender (as far as an application
155  * is concerned).
156  *
157  * This contract is only required for intermediate, library-like contracts.
158  */
159 abstract contract Context {
160     function _msgSender() internal view virtual returns (address) {
161         return msg.sender;
162     }
163 
164     function _msgData() internal view virtual returns (bytes calldata) {
165         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
166         return msg.data;
167     }
168 }
169 
170 /**
171  * @dev Implementation of the {IERC20} interface.
172  *
173  * This implementation is agnostic to the way tokens are created. This means
174  * that a supply mechanism has to be added in a derived contract using {_mint}.
175  * For a generic mechanism see {ERC20PresetMinterPauser}.
176  *
177  * TIP: For a detailed writeup see our guide
178  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
179  * to implement supply mechanisms].
180  *
181  * We have followed general OpenZeppelin guidelines: functions revert instead
182  * of returning `false` on failure. This behavior is nonetheless conventional
183  * and does not conflict with the expectations of ERC20 applications.
184  *
185  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
186  * This allows applications to reconstruct the allowance for all accounts just
187  * by listening to said events. Other implementations of the EIP may not emit
188  * these events, as it isn't required by the specification.
189  *
190  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
191  * functions have been added to mitigate the well-known issues around setting
192  * allowances. See {IERC20-approve}.
193  */
194 contract ERC20 is Context, IERC20, IERC20Metadata {
195     mapping (address => uint256) private _balances;
196 
197     mapping (address => mapping (address => uint256)) private _allowances;
198 
199     uint256 private _totalSupply;
200 
201     string private _name;
202     string private _symbol;
203 
204     /**
205      * @dev Sets the values for {name} and {symbol}.
206      *
207      * The defaut value of {decimals} is 18. To select a different value for
208      * {decimals} you should overload it.
209      *
210      * All two of these values are immutable: they can only be set once during
211      * construction.
212      */
213     constructor (string memory name_, string memory symbol_) {
214         _name = name_;
215         _symbol = symbol_;
216     }
217 
218     /**
219      * @dev Returns the name of the token.
220      */
221     function name() public view virtual override returns (string memory) {
222         return _name;
223     }
224 
225     /**
226      * @dev Returns the symbol of the token, usually a shorter version of the
227      * name.
228      */
229     function symbol() public view virtual override returns (string memory) {
230         return _symbol;
231     }
232 
233     /**
234      * @dev Returns the number of decimals used to get its user representation.
235      * For example, if `decimals` equals `2`, a balance of `505` tokens should
236      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
237      *
238      * Tokens usually opt for a value of 18, imitating the relationship between
239      * Ether and Wei. This is the value {ERC20} uses, unless this function is
240      * overridden;
241      *
242      * NOTE: This information is only used for _display_ purposes: it in
243      * no way affects any of the arithmetic of the contract, including
244      * {IERC20-balanceOf} and {IERC20-transfer}.
245      */
246     function decimals() public view virtual override returns (uint8) {
247         return 18;
248     }
249 
250     /**
251      * @dev See {IERC20-totalSupply}.
252      */
253     function totalSupply() public view virtual override returns (uint256) {
254         return _totalSupply;
255     }
256 
257     /**
258      * @dev See {IERC20-balanceOf}.
259      */
260     function balanceOf(address account) public view virtual override returns (uint256) {
261         return _balances[account];
262     }
263 
264     /**
265      * @dev See {IERC20-transfer}.
266      *
267      * Requirements:
268      *
269      * - `recipient` cannot be the zero address.
270      * - the caller must have a balance of at least `amount`.
271      */
272     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
273         _transfer(_msgSender(), recipient, amount);
274         return true;
275     }
276 
277     /**
278      * @dev See {IERC20-allowance}.
279      */
280     function allowance(address owner, address spender) public view virtual override returns (uint256) {
281         return _allowances[owner][spender];
282     }
283 
284     /**
285      * @dev See {IERC20-approve}.
286      *
287      * Requirements:
288      *
289      * - `spender` cannot be the zero address.
290      */
291     function approve(address spender, uint256 amount) public virtual override returns (bool) {
292         _approve(_msgSender(), spender, amount);
293         return true;
294     }
295 
296     /**
297      * @dev See {IERC20-transferFrom}.
298      *
299      * Emits an {Approval} event indicating the updated allowance. This is not
300      * required by the EIP. See the note at the beginning of {ERC20}.
301      *
302      * Requirements:
303      *
304      * - `sender` and `recipient` cannot be the zero address.
305      * - `sender` must have a balance of at least `amount`.
306      * - the caller must have allowance for ``sender``'s tokens of at least
307      * `amount`.
308      */
309     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
310         _transfer(sender, recipient, amount);
311 
312         uint256 currentAllowance = _allowances[sender][_msgSender()];
313         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
314         _approve(sender, _msgSender(), currentAllowance - amount);
315 
316         return true;
317     }
318 
319     /**
320      * @dev Atomically increases the allowance granted to `spender` by the caller.
321      *
322      * This is an alternative to {approve} that can be used as a mitigation for
323      * problems described in {IERC20-approve}.
324      *
325      * Emits an {Approval} event indicating the updated allowance.
326      *
327      * Requirements:
328      *
329      * - `spender` cannot be the zero address.
330      */
331     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
332         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
333         return true;
334     }
335 
336     /**
337      * @dev Atomically decreases the allowance granted to `spender` by the caller.
338      *
339      * This is an alternative to {approve} that can be used as a mitigation for
340      * problems described in {IERC20-approve}.
341      *
342      * Emits an {Approval} event indicating the updated allowance.
343      *
344      * Requirements:
345      *
346      * - `spender` cannot be the zero address.
347      * - `spender` must have allowance for the caller of at least
348      * `subtractedValue`.
349      */
350     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
351         uint256 currentAllowance = _allowances[_msgSender()][spender];
352         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
353         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
354 
355         return true;
356     }
357 
358     /**
359      * @dev Moves tokens `amount` from `sender` to `recipient`.
360      *
361      * This is internal function is equivalent to {transfer}, and can be used to
362      * e.g. implement automatic token fees, slashing mechanisms, etc.
363      *
364      * Emits a {Transfer} event.
365      *
366      * Requirements:
367      *
368      * - `sender` cannot be the zero address.
369      * - `recipient` cannot be the zero address.
370      * - `sender` must have a balance of at least `amount`.
371      */
372     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
373         require(sender != address(0), "ERC20: transfer from the zero address");
374         require(recipient != address(0), "ERC20: transfer to the zero address");
375 
376         _beforeTokenTransfer(sender, recipient, amount);
377 
378         uint256 senderBalance = _balances[sender];
379         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
380         _balances[sender] = senderBalance - amount;
381         _balances[recipient] += amount;
382 
383         emit Transfer(sender, recipient, amount);
384     }
385 
386     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
387      * the total supply.
388      *
389      * Emits a {Transfer} event with `from` set to the zero address.
390      *
391      * Requirements:
392      *
393      * - `to` cannot be the zero address.
394      */
395     function _mint(address account, uint256 amount) internal virtual {
396         require(account != address(0), "ERC20: mint to the zero address");
397 
398         _beforeTokenTransfer(address(0), account, amount);
399 
400         _totalSupply += amount;
401         _balances[account] += amount;
402         emit Transfer(address(0), account, amount);
403     }
404 
405     /**
406      * @dev Destroys `amount` tokens from `account`, reducing the
407      * total supply.
408      *
409      * Emits a {Transfer} event with `to` set to the zero address.
410      *
411      * Requirements:
412      *
413      * - `account` cannot be the zero address.
414      * - `account` must have at least `amount` tokens.
415      */
416     function _burn(address account, uint256 amount) internal virtual {
417         require(account != address(0), "ERC20: burn from the zero address");
418 
419         _beforeTokenTransfer(account, address(0), amount);
420 
421         uint256 accountBalance = _balances[account];
422         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
423         _balances[account] = accountBalance - amount;
424         _totalSupply -= amount;
425 
426         emit Transfer(account, address(0), amount);
427     }
428 
429     /**
430      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
431      *
432      * This internal function is equivalent to `approve`, and can be used to
433      * e.g. set automatic allowances for certain subsystems, etc.
434      *
435      * Emits an {Approval} event.
436      *
437      * Requirements:
438      *
439      * - `owner` cannot be the zero address.
440      * - `spender` cannot be the zero address.
441      */
442     function _approve(address owner, address spender, uint256 amount) internal virtual {
443         require(owner != address(0), "ERC20: approve from the zero address");
444         require(spender != address(0), "ERC20: approve to the zero address");
445 
446         _allowances[owner][spender] = amount;
447         emit Approval(owner, spender, amount);
448     }
449 
450     /**
451      * @dev Hook that is called before any transfer of tokens. This includes
452      * minting and burning.
453      *
454      * Calling conditions:
455      *
456      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
457      * will be to transferred to `to`.
458      * - when `from` is zero, `amount` tokens will be minted for `to`.
459      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
460      * - `from` and `to` are never both zero.
461      *
462      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
463      */
464     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
465 }
466 
467 /**
468  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
469  *
470  * These functions can be used to verify that a message was signed by the holder
471  * of the private keys of a given address.
472  */
473 library ECDSA {
474     /**
475      * @dev Returns the address that signed a hashed message (`hash`) with
476      * `signature`. This address can then be used for verification purposes.
477      *
478      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
479      * this function rejects them by requiring the `s` value to be in the lower
480      * half order, and the `v` value to be either 27 or 28.
481      *
482      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
483      * verification to be secure: it is possible to craft signatures that
484      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
485      * this is by receiving a hash of the original message (which may otherwise
486      * be too long), and then calling {toEthSignedMessageHash} on it.
487      */
488     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
489         // Divide the signature in r, s and v variables
490         bytes32 r;
491         bytes32 s;
492         uint8 v;
493 
494         // Check the signature length
495         // - case 65: r,s,v signature (standard)
496         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
497         if (signature.length == 65) {
498             // ecrecover takes the signature parameters, and the only way to get them
499             // currently is to use assembly.
500             // solhint-disable-next-line no-inline-assembly
501             assembly {
502                 r := mload(add(signature, 0x20))
503                 s := mload(add(signature, 0x40))
504                 v := byte(0, mload(add(signature, 0x60)))
505             }
506         } else if (signature.length == 64) {
507             // ecrecover takes the signature parameters, and the only way to get them
508             // currently is to use assembly.
509             // solhint-disable-next-line no-inline-assembly
510             assembly {
511                 let vs := mload(add(signature, 0x40))
512                 r := mload(add(signature, 0x20))
513                 s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
514                 v := add(shr(255, vs), 27)
515             }
516         } else {
517             revert("ECDSA: invalid signature length");
518         }
519 
520         return recover(hash, v, r, s);
521     }
522 
523     /**
524      * @dev Overload of {ECDSA-recover} that receives the `v`,
525      * `r` and `s` signature fields separately.
526      */
527     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
528         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
529         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
530         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
531         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
532         //
533         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
534         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
535         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
536         // these malleable signatures as well.
537         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
538         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
539 
540         // If the signature is valid (and not malleable), return the signer address
541         address signer = ecrecover(hash, v, r, s);
542         require(signer != address(0), "ECDSA: invalid signature");
543 
544         return signer;
545     }
546 
547     /**
548      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
549      * produces hash corresponding to the one signed with the
550      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
551      * JSON-RPC method as part of EIP-191.
552      *
553      * See {recover}.
554      */
555     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
556         // 32 is the length in bytes of hash,
557         // enforced by the type signature above
558         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
559     }
560 
561     /**
562      * @dev Returns an Ethereum Signed Typed Data, created from a
563      * `domainSeparator` and a `structHash`. This produces hash corresponding
564      * to the one signed with the
565      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
566      * JSON-RPC method as part of EIP-712.
567      *
568      * See {recover}.
569      */
570     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
571         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
572     }
573 }
574 
575 /**
576  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
577  *
578  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
579  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
580  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
581  *
582  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
583  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
584  * ({_hashTypedDataV4}).
585  *
586  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
587  * the chain id to protect against replay attacks on an eventual fork of the chain.
588  *
589  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
590  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
591  *
592  * _Available since v3.4._
593  */
594 abstract contract EIP712 {
595     /* solhint-disable var-name-mixedcase */
596     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
597     // invalidate the cached domain separator if the chain id changes.
598     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
599     uint256 private immutable _CACHED_CHAIN_ID;
600 
601     bytes32 private immutable _HASHED_NAME;
602     bytes32 private immutable _HASHED_VERSION;
603     bytes32 private immutable _TYPE_HASH;
604     /* solhint-enable var-name-mixedcase */
605 
606     /**
607      * @dev Initializes the domain separator and parameter caches.
608      *
609      * The meaning of `name` and `version` is specified in
610      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
611      *
612      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
613      * - `version`: the current major version of the signing domain.
614      *
615      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
616      * contract upgrade].
617      */
618     constructor(string memory name, string memory version) {
619         bytes32 hashedName = keccak256(bytes(name));
620         bytes32 hashedVersion = keccak256(bytes(version));
621         bytes32 typeHash = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
622         _HASHED_NAME = hashedName;
623         _HASHED_VERSION = hashedVersion;
624         _CACHED_CHAIN_ID = block.chainid;
625         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
626         _TYPE_HASH = typeHash;
627     }
628 
629     /**
630      * @dev Returns the domain separator for the current chain.
631      */
632     function _domainSeparatorV4() internal view returns (bytes32) {
633         if (block.chainid == _CACHED_CHAIN_ID) {
634             return _CACHED_DOMAIN_SEPARATOR;
635         } else {
636             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
637         }
638     }
639 
640     function _buildDomainSeparator(bytes32 typeHash, bytes32 name, bytes32 version) private view returns (bytes32) {
641         return keccak256(
642             abi.encode(
643                 typeHash,
644                 name,
645                 version,
646                 block.chainid,
647                 address(this)
648             )
649         );
650     }
651 
652     /**
653      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
654      * function returns the hash of the fully encoded EIP712 message for this domain.
655      *
656      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
657      *
658      * ```solidity
659      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
660      *     keccak256("Mail(address to,string contents)"),
661      *     mailTo,
662      *     keccak256(bytes(mailContents))
663      * )));
664      * address signer = ECDSA.recover(digest, signature);
665      * ```
666      */
667     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
668         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
669     }
670 }
671 
672 /**
673  * @title Counters
674  * @author Matt Condon (@shrugs)
675  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
676  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
677  *
678  * Include with `using Counters for Counters.Counter;`
679  */
680 library Counters {
681     struct Counter {
682         // This variable should never be directly accessed by users of the library: interactions must be restricted to
683         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
684         // this feature: see https://github.com/ethereum/solidity/issues/4637
685         uint256 _value; // default: 0
686     }
687 
688     function current(Counter storage counter) internal view returns (uint256) {
689         return counter._value;
690     }
691 
692     function increment(Counter storage counter) internal {
693         unchecked {
694             counter._value += 1;
695         }
696     }
697 
698     function decrement(Counter storage counter) internal {
699         uint256 value = counter._value;
700         require(value > 0, "Counter: decrement overflow");
701         unchecked {
702             counter._value = value - 1;
703         }
704     }
705 }
706 
707 /**
708  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
709  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
710  *
711  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
712  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
713  * need to send a transaction, and thus is not required to hold Ether at all.
714  *
715  * _Available since v3.4._
716  */
717 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
718     using Counters for Counters.Counter;
719 
720     mapping (address => Counters.Counter) private _nonces;
721 
722     // solhint-disable-next-line var-name-mixedcase
723     bytes32 private immutable _PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
724 
725     /**
726      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
727      *
728      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
729      */
730     constructor(string memory name) EIP712(name, "1") {
731     }
732 
733     /**
734      * @dev See {IERC20Permit-permit}.
735      */
736     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual override {
737         // solhint-disable-next-line not-rely-on-time
738         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
739 
740         bytes32 structHash = keccak256(
741             abi.encode(
742                 _PERMIT_TYPEHASH,
743                 owner,
744                 spender,
745                 value,
746                 _useNonce(owner),
747                 deadline
748             )
749         );
750 
751         bytes32 hash = _hashTypedDataV4(structHash);
752 
753         address signer = ECDSA.recover(hash, v, r, s);
754         require(signer == owner, "ERC20Permit: invalid signature");
755 
756         _approve(owner, spender, value);
757     }
758 
759     /**
760      * @dev See {IERC20Permit-nonces}.
761      */
762     function nonces(address owner) public view virtual override returns (uint256) {
763         return _nonces[owner].current();
764     }
765 
766     /**
767      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
768      */
769     // solhint-disable-next-line func-name-mixedcase
770     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
771         return _domainSeparatorV4();
772     }
773 
774     /**
775      * @dev "Consume a nonce": return the current value and increment.
776      *
777      * _Available since v4.1._
778      */
779     function _useNonce(address owner) internal virtual returns (uint256 current) {
780         Counters.Counter storage nonce = _nonces[owner];
781         current = nonce.current();
782         nonce.increment();
783     }
784 }
785 
786 /**
787  * @dev Contract module which allows children to implement an emergency stop
788  * mechanism that can be triggered by an authorized account.
789  *
790  * This module is used through inheritance. It will make available the
791  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
792  * the functions of your contract. Note that they will not be pausable by
793  * simply including this module, only once the modifiers are put in place.
794  */
795 abstract contract Pausable is Context {
796     /**
797      * @dev Emitted when the pause is triggered by `account`.
798      */
799     event Paused(address account);
800 
801     /**
802      * @dev Emitted when the pause is lifted by `account`.
803      */
804     event Unpaused(address account);
805 
806     bool private _paused;
807 
808     /**
809      * @dev Initializes the contract in unpaused state.
810      */
811     constructor () {
812         _paused = false;
813     }
814 
815     /**
816      * @dev Returns true if the contract is paused, and false otherwise.
817      */
818     function paused() public view virtual returns (bool) {
819         return _paused;
820     }
821 
822     /**
823      * @dev Modifier to make a function callable only when the contract is not paused.
824      *
825      * Requirements:
826      *
827      * - The contract must not be paused.
828      */
829     modifier whenNotPaused() {
830         require(!paused(), "Pausable: paused");
831         _;
832     }
833 
834     /**
835      * @dev Modifier to make a function callable only when the contract is paused.
836      *
837      * Requirements:
838      *
839      * - The contract must be paused.
840      */
841     modifier whenPaused() {
842         require(paused(), "Pausable: not paused");
843         _;
844     }
845 
846     /**
847      * @dev Triggers stopped state.
848      *
849      * Requirements:
850      *
851      * - The contract must not be paused.
852      */
853     function _pause() internal virtual whenNotPaused {
854         _paused = true;
855         emit Paused(_msgSender());
856     }
857 
858     /**
859      * @dev Returns to normal state.
860      *
861      * Requirements:
862      *
863      * - The contract must be paused.
864      */
865     function _unpause() internal virtual whenPaused {
866         _paused = false;
867         emit Unpaused(_msgSender());
868     }
869 }
870 
871 /**
872  * @dev ERC20 token with pausable token transfers, minting and burning.
873  *
874  * Useful for scenarios such as preventing trades until the end of an evaluation
875  * period, or having an emergency switch for freezing all token transfers in the
876  * event of a large bug.
877  */
878 abstract contract ERC20Pausable is ERC20, Pausable {
879     /**
880      * @dev See {ERC20-_beforeTokenTransfer}.
881      *
882      * Requirements:
883      *
884      * - the contract must not be paused.
885      */
886     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
887         super._beforeTokenTransfer(from, to, amount);
888 
889         require(!paused(), "ERC20Pausable: token transfer while paused");
890     }
891 }
892 
893 /**
894  * @dev String operations.
895  */
896 library Strings {
897     bytes16 private constant alphabet = "0123456789abcdef";
898 
899     /**
900      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
901      */
902     function toString(uint256 value) internal pure returns (string memory) {
903         // Inspired by OraclizeAPI's implementation - MIT licence
904         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
905 
906         if (value == 0) {
907             return "0";
908         }
909         uint256 temp = value;
910         uint256 digits;
911         while (temp != 0) {
912             digits++;
913             temp /= 10;
914         }
915         bytes memory buffer = new bytes(digits);
916         while (value != 0) {
917             digits -= 1;
918             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
919             value /= 10;
920         }
921         return string(buffer);
922     }
923 
924     /**
925      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
926      */
927     function toHexString(uint256 value) internal pure returns (string memory) {
928         if (value == 0) {
929             return "0x00";
930         }
931         uint256 temp = value;
932         uint256 length = 0;
933         while (temp != 0) {
934             length++;
935             temp >>= 8;
936         }
937         return toHexString(value, length);
938     }
939 
940     /**
941      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
942      */
943     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
944         bytes memory buffer = new bytes(2 * length + 2);
945         buffer[0] = "0";
946         buffer[1] = "x";
947         for (uint256 i = 2 * length + 1; i > 1; --i) {
948             buffer[i] = alphabet[value & 0xf];
949             value >>= 4;
950         }
951         require(value == 0, "Strings: hex length insufficient");
952         return string(buffer);
953     }
954 
955 }
956 
957 /**
958  * @dev Interface of the ERC165 standard, as defined in the
959  * https://eips.ethereum.org/EIPS/eip-165[EIP].
960  *
961  * Implementers can declare support of contract interfaces, which can then be
962  * queried by others ({ERC165Checker}).
963  *
964  * For an implementation, see {ERC165}.
965  */
966 interface IERC165 {
967     /**
968      * @dev Returns true if this contract implements the interface defined by
969      * `interfaceId`. See the corresponding
970      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
971      * to learn more about how these ids are created.
972      *
973      * This function call must use less than 30 000 gas.
974      */
975     function supportsInterface(bytes4 interfaceId) external view returns (bool);
976 }
977 
978 /**
979  * @dev Implementation of the {IERC165} interface.
980  *
981  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
982  * for the additional interface id that will be supported. For example:
983  *
984  * ```solidity
985  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
986  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
987  * }
988  * ```
989  *
990  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
991  */
992 abstract contract ERC165 is IERC165 {
993     /**
994      * @dev See {IERC165-supportsInterface}.
995      */
996     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
997         return interfaceId == type(IERC165).interfaceId;
998     }
999 }
1000 
1001 /**
1002  * @dev External interface of AccessControl declared to support ERC165 detection.
1003  */
1004 interface IAccessControl {
1005     function hasRole(bytes32 role, address account) external view returns (bool);
1006     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1007     function grantRole(bytes32 role, address account) external;
1008     function revokeRole(bytes32 role, address account) external;
1009     function renounceRole(bytes32 role, address account) external;
1010 }
1011 
1012 /**
1013  * @dev Contract module that allows children to implement role-based access
1014  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1015  * members except through off-chain means by accessing the contract event logs. Some
1016  * applications may benefit from on-chain enumerability, for those cases see
1017  * {AccessControlEnumerable}.
1018  *
1019  * Roles are referred to by their `bytes32` identifier. These should be exposed
1020  * in the external API and be unique. The best way to achieve this is by
1021  * using `public constant` hash digests:
1022  *
1023  * ```
1024  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1025  * ```
1026  *
1027  * Roles can be used to represent a set of permissions. To restrict access to a
1028  * function call, use {hasRole}:
1029  *
1030  * ```
1031  * function foo() public {
1032  *     require(hasRole(MY_ROLE, msg.sender));
1033  *     ...
1034  * }
1035  * ```
1036  *
1037  * Roles can be granted and revoked dynamically via the {grantRole} and
1038  * {revokeRole} functions. Each role has an associated admin role, and only
1039  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1040  *
1041  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1042  * that only accounts with this role will be able to grant or revoke other
1043  * roles. More complex role relationships can be created by using
1044  * {_setRoleAdmin}.
1045  *
1046  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1047  * grant and revoke this role. Extra precautions should be taken to secure
1048  * accounts that have been granted it.
1049  */
1050 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1051     struct RoleData {
1052         mapping (address => bool) members;
1053         bytes32 adminRole;
1054     }
1055 
1056     mapping (bytes32 => RoleData) private _roles;
1057 
1058     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1059 
1060     /**
1061      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1062      *
1063      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1064      * {RoleAdminChanged} not being emitted signaling this.
1065      *
1066      * _Available since v3.1._
1067      */
1068     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1069 
1070     /**
1071      * @dev Emitted when `account` is granted `role`.
1072      *
1073      * `sender` is the account that originated the contract call, an admin role
1074      * bearer except when using {_setupRole}.
1075      */
1076     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1077 
1078     /**
1079      * @dev Emitted when `account` is revoked `role`.
1080      *
1081      * `sender` is the account that originated the contract call:
1082      *   - if using `revokeRole`, it is the admin role bearer
1083      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1084      */
1085     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1086 
1087     /**
1088      * @dev Modifier that checks that an account has a specific role. Reverts
1089      * with a standardized message including the required role.
1090      *
1091      * The format of the revert reason is given by the following regular expression:
1092      *
1093      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
1094      *
1095      * _Available since v4.1._
1096      */
1097     modifier onlyRole(bytes32 role) {
1098         _checkRole(role, _msgSender());
1099         _;
1100     }
1101 
1102     /**
1103      * @dev See {IERC165-supportsInterface}.
1104      */
1105     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1106         return interfaceId == type(IAccessControl).interfaceId
1107             || super.supportsInterface(interfaceId);
1108     }
1109 
1110     /**
1111      * @dev Returns `true` if `account` has been granted `role`.
1112      */
1113     function hasRole(bytes32 role, address account) public view override returns (bool) {
1114         return _roles[role].members[account];
1115     }
1116 
1117     /**
1118      * @dev Revert with a standard message if `account` is missing `role`.
1119      *
1120      * The format of the revert reason is given by the following regular expression:
1121      *
1122      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
1123      */
1124     function _checkRole(bytes32 role, address account) internal view {
1125         if(!hasRole(role, account)) {
1126             revert(string(abi.encodePacked(
1127                 "AccessControl: account ",
1128                 Strings.toHexString(uint160(account), 20),
1129                 " is missing role ",
1130                 Strings.toHexString(uint256(role), 32)
1131             )));
1132         }
1133     }
1134 
1135     /**
1136      * @dev Returns the admin role that controls `role`. See {grantRole} and
1137      * {revokeRole}.
1138      *
1139      * To change a role's admin, use {_setRoleAdmin}.
1140      */
1141     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1142         return _roles[role].adminRole;
1143     }
1144 
1145     /**
1146      * @dev Grants `role` to `account`.
1147      *
1148      * If `account` had not been already granted `role`, emits a {RoleGranted}
1149      * event.
1150      *
1151      * Requirements:
1152      *
1153      * - the caller must have ``role``'s admin role.
1154      */
1155     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1156         _grantRole(role, account);
1157     }
1158 
1159     /**
1160      * @dev Revokes `role` from `account`.
1161      *
1162      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1163      *
1164      * Requirements:
1165      *
1166      * - the caller must have ``role``'s admin role.
1167      */
1168     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1169         _revokeRole(role, account);
1170     }
1171 
1172     /**
1173      * @dev Revokes `role` from the calling account.
1174      *
1175      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1176      * purpose is to provide a mechanism for accounts to lose their privileges
1177      * if they are compromised (such as when a trusted device is misplaced).
1178      *
1179      * If the calling account had been granted `role`, emits a {RoleRevoked}
1180      * event.
1181      *
1182      * Requirements:
1183      *
1184      * - the caller must be `account`.
1185      */
1186     function renounceRole(bytes32 role, address account) public virtual override {
1187         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1188 
1189         _revokeRole(role, account);
1190     }
1191 
1192     /**
1193      * @dev Grants `role` to `account`.
1194      *
1195      * If `account` had not been already granted `role`, emits a {RoleGranted}
1196      * event. Note that unlike {grantRole}, this function doesn't perform any
1197      * checks on the calling account.
1198      *
1199      * [WARNING]
1200      * ====
1201      * This function should only be called from the constructor when setting
1202      * up the initial roles for the system.
1203      *
1204      * Using this function in any other way is effectively circumventing the admin
1205      * system imposed by {AccessControl}.
1206      * ====
1207      */
1208     function _setupRole(bytes32 role, address account) internal virtual {
1209         _grantRole(role, account);
1210     }
1211 
1212     /**
1213      * @dev Sets `adminRole` as ``role``'s admin role.
1214      *
1215      * Emits a {RoleAdminChanged} event.
1216      */
1217     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1218         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
1219         _roles[role].adminRole = adminRole;
1220     }
1221 
1222     function _grantRole(bytes32 role, address account) private {
1223         if (!hasRole(role, account)) {
1224             _roles[role].members[account] = true;
1225             emit RoleGranted(role, account, _msgSender());
1226         }
1227     }
1228 
1229     function _revokeRole(bytes32 role, address account) private {
1230         if (hasRole(role, account)) {
1231             _roles[role].members[account] = false;
1232             emit RoleRevoked(role, account, _msgSender());
1233         }
1234     }
1235 }
1236 
1237 contract IDO is ERC20Permit, ERC20Pausable, AccessControl {
1238     // Contract owner address
1239     address public owner;
1240     // Proposed new contract owner address
1241     address public newOwner;
1242 
1243     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
1244     uint256 public constant cap = 100 * 1000 * 1000 * 1 ether;
1245 
1246     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1247 
1248     constructor() ERC20("Idexo Token", "IDO") ERC20Permit("Idexo Token") {
1249         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1250         _setupRole(OPERATOR_ROLE, _msgSender());
1251 
1252         _mint(_msgSender(), cap);
1253         owner = _msgSender();
1254         emit OwnershipTransferred(address(0), _msgSender());
1255     }
1256 
1257     /****************************|
1258     |          Ownership         |
1259     |___________________________*/
1260 
1261     /**
1262      * @dev Throws if called by any account other than the owner.
1263      */
1264     modifier onlyOwner() {
1265         require(owner == _msgSender(), "IDO: CALLER_NO_OWNER");
1266         _;
1267     }
1268 
1269     /**
1270      * @dev Leaves the contract without owner. It will not be possible to call
1271      * `onlyOwner` functions anymore. Can only be called by the current owner.
1272      * `owner` should first call {removeOperator} for himself.
1273      */
1274     function renounceOwnership() external onlyOwner {
1275         emit OwnershipTransferred(owner, address(0));
1276         owner = address(0);
1277     }
1278 
1279     /**
1280      * @dev Transfer the contract ownership.
1281      * The new owner still needs to accept the transfer.
1282      * can only be called by the contract owner.
1283      *
1284      * @param _newOwner new contract owner.
1285      */
1286     function transferOwnership(address _newOwner) external onlyOwner {
1287         require(_newOwner != address(0), "IDO: INVALID_ADDRESS");
1288         require(_newOwner != owner, "IDO: OWNERSHIP_SELF_TRANSFER");
1289         newOwner = _newOwner;
1290     }
1291 
1292     /**
1293      * @dev The new owner accept an ownership transfer.
1294      * The new owner should remove `operator` role from previous owner and add for himself.
1295      */
1296     function acceptOwnership() external {
1297         require(_msgSender() == newOwner, "IDO: CALLER_NO_NEW_OWNER");
1298         emit OwnershipTransferred(owner, newOwner);
1299         owner = newOwner;
1300         newOwner = address(0);
1301     }
1302 
1303     /***********************|
1304     |          Role         |
1305     |______________________*/
1306 
1307     /**
1308      * @dev Restricted to members of the operator role.
1309      */
1310     modifier onlyOperator() {
1311         require(hasRole(OPERATOR_ROLE, _msgSender()), "IDO: CALLER_NO_OPERATOR_ROLE");
1312         _;
1313     }
1314 
1315     /**
1316      * @dev Add an account to the operator role.
1317      * @param account address
1318      */
1319     function addOperator(address account) public onlyOwner {
1320         require(!hasRole(OPERATOR_ROLE, account), "IDO: ALREADY_OERATOR_ROLE");
1321         grantRole(OPERATOR_ROLE, account);
1322     }
1323 
1324     /**
1325      * @dev Remove an account from the operator role.
1326      * @param account address
1327      */
1328     function removeOperator(address account) public onlyOwner {
1329         require(hasRole(OPERATOR_ROLE, account), "IDO: NO_OPERATOR_ROLE");
1330         revokeRole(OPERATOR_ROLE, account);
1331     }
1332 
1333     /**
1334      * @dev Check if an account is operator.
1335      * @param account address
1336      */
1337     function checkOperator(address account) public view returns (bool) {
1338         return hasRole(OPERATOR_ROLE, account);
1339     }
1340 
1341     /************************|
1342     |          Token         |
1343     |_______________________*/
1344 
1345     /**
1346      * @dev `_beforeTokenTransfer` hook override.
1347      * @param from address
1348      * @param to address
1349      * @param amount uint256
1350      * `Owner` can only transfer when paused
1351      */
1352     function _beforeTokenTransfer(
1353         address from,
1354         address to,
1355         uint256 amount
1356     ) internal override(ERC20, ERC20Pausable) {
1357         if (from == owner) {
1358             return;
1359         }
1360         ERC20Pausable._beforeTokenTransfer(from, to, amount);
1361     }
1362 
1363     /**
1364      * @dev Get chain id.
1365      */
1366     function getChainId() public view returns (uint256) {
1367         uint256 id;
1368         assembly { id := chainid() }
1369         return id;
1370     }
1371 
1372     /******************************|
1373     |          Pausability         |
1374     |_____________________________*/
1375 
1376     /**
1377      * @dev Pause.
1378      */
1379     function pause() public onlyOperator {
1380         super._pause();
1381     }
1382 
1383     /**
1384      * @dev Unpause.
1385      */
1386     function unpause() public onlyOperator {
1387         super._unpause();
1388     }
1389 }