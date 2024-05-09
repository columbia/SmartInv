1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
82 
83 
84 
85 pragma solidity ^0.8.0;
86 
87 
88 /**
89  * @dev Interface for the optional metadata functions from the ERC20 standard.
90  *
91  * _Available since v4.1._
92  */
93 interface IERC20Metadata is IERC20 {
94     /**
95      * @dev Returns the name of the token.
96      */
97     function name() external view returns (string memory);
98 
99     /**
100      * @dev Returns the symbol of the token.
101      */
102     function symbol() external view returns (string memory);
103 
104     /**
105      * @dev Returns the decimals places of the token.
106      */
107     function decimals() external view returns (uint8);
108 }
109 
110 // File: @openzeppelin/contracts/utils/Context.sol
111 
112 
113 
114 pragma solidity ^0.8.0;
115 
116 /*
117  * @dev Provides information about the current execution context, including the
118  * sender of the transaction and its data. While these are generally available
119  * via msg.sender and msg.data, they should not be accessed in such a direct
120  * manner, since when dealing with meta-transactions the account sending and
121  * paying for execution may not be the actual sender (as far as an application
122  * is concerned).
123  *
124  * This contract is only required for intermediate, library-like contracts.
125  */
126 abstract contract Context {
127     function _msgSender() internal view virtual returns (address) {
128         return msg.sender;
129     }
130 
131     function _msgData() internal view virtual returns (bytes calldata) {
132         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
133         return msg.data;
134     }
135 }
136 
137 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
138 
139 
140 
141 pragma solidity ^0.8.0;
142 
143 
144 
145 
146 /**
147  * @dev Implementation of the {IERC20} interface.
148  *
149  * This implementation is agnostic to the way tokens are created. This means
150  * that a supply mechanism has to be added in a derived contract using {_mint}.
151  * For a generic mechanism see {ERC20PresetMinterPauser}.
152  *
153  * TIP: For a detailed writeup see our guide
154  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
155  * to implement supply mechanisms].
156  *
157  * We have followed general OpenZeppelin guidelines: functions revert instead
158  * of returning `false` on failure. This behavior is nonetheless conventional
159  * and does not conflict with the expectations of ERC20 applications.
160  *
161  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
162  * This allows applications to reconstruct the allowance for all accounts just
163  * by listening to said events. Other implementations of the EIP may not emit
164  * these events, as it isn't required by the specification.
165  *
166  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
167  * functions have been added to mitigate the well-known issues around setting
168  * allowances. See {IERC20-approve}.
169  */
170 contract ERC20 is Context, IERC20, IERC20Metadata {
171     mapping (address => uint256) private _balances;
172 
173     mapping (address => mapping (address => uint256)) private _allowances;
174 
175     uint256 private _totalSupply;
176 
177     string private _name;
178     string private _symbol;
179 
180     /**
181      * @dev Sets the values for {name} and {symbol}.
182      *
183      * The defaut value of {decimals} is 18. To select a different value for
184      * {decimals} you should overload it.
185      *
186      * All two of these values are immutable: they can only be set once during
187      * construction.
188      */
189     constructor (string memory name_, string memory symbol_) {
190         _name = name_;
191         _symbol = symbol_;
192     }
193 
194     /**
195      * @dev Returns the name of the token.
196      */
197     function name() public view virtual override returns (string memory) {
198         return _name;
199     }
200 
201     /**
202      * @dev Returns the symbol of the token, usually a shorter version of the
203      * name.
204      */
205     function symbol() public view virtual override returns (string memory) {
206         return _symbol;
207     }
208 
209     /**
210      * @dev Returns the number of decimals used to get its user representation.
211      * For example, if `decimals` equals `2`, a balance of `505` tokens should
212      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
213      *
214      * Tokens usually opt for a value of 18, imitating the relationship between
215      * Ether and Wei. This is the value {ERC20} uses, unless this function is
216      * overridden;
217      *
218      * NOTE: This information is only used for _display_ purposes: it in
219      * no way affects any of the arithmetic of the contract, including
220      * {IERC20-balanceOf} and {IERC20-transfer}.
221      */
222     function decimals() public view virtual override returns (uint8) {
223         return 18;
224     }
225 
226     /**
227      * @dev See {IERC20-totalSupply}.
228      */
229     function totalSupply() public view virtual override returns (uint256) {
230         return _totalSupply;
231     }
232 
233     /**
234      * @dev See {IERC20-balanceOf}.
235      */
236     function balanceOf(address account) public view virtual override returns (uint256) {
237         return _balances[account];
238     }
239 
240     /**
241      * @dev See {IERC20-transfer}.
242      *
243      * Requirements:
244      *
245      * - `recipient` cannot be the zero address.
246      * - the caller must have a balance of at least `amount`.
247      */
248     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
249         _transfer(_msgSender(), recipient, amount);
250         return true;
251     }
252 
253     /**
254      * @dev See {IERC20-allowance}.
255      */
256     function allowance(address owner, address spender) public view virtual override returns (uint256) {
257         return _allowances[owner][spender];
258     }
259 
260     /**
261      * @dev See {IERC20-approve}.
262      *
263      * Requirements:
264      *
265      * - `spender` cannot be the zero address.
266      */
267     function approve(address spender, uint256 amount) public virtual override returns (bool) {
268         _approve(_msgSender(), spender, amount);
269         return true;
270     }
271 
272     /**
273      * @dev See {IERC20-transferFrom}.
274      *
275      * Emits an {Approval} event indicating the updated allowance. This is not
276      * required by the EIP. See the note at the beginning of {ERC20}.
277      *
278      * Requirements:
279      *
280      * - `sender` and `recipient` cannot be the zero address.
281      * - `sender` must have a balance of at least `amount`.
282      * - the caller must have allowance for ``sender``'s tokens of at least
283      * `amount`.
284      */
285     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
286         _transfer(sender, recipient, amount);
287 
288         uint256 currentAllowance = _allowances[sender][_msgSender()];
289         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
290         _approve(sender, _msgSender(), currentAllowance - amount);
291 
292         return true;
293     }
294 
295     /**
296      * @dev Atomically increases the allowance granted to `spender` by the caller.
297      *
298      * This is an alternative to {approve} that can be used as a mitigation for
299      * problems described in {IERC20-approve}.
300      *
301      * Emits an {Approval} event indicating the updated allowance.
302      *
303      * Requirements:
304      *
305      * - `spender` cannot be the zero address.
306      */
307     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
308         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
309         return true;
310     }
311 
312     /**
313      * @dev Atomically decreases the allowance granted to `spender` by the caller.
314      *
315      * This is an alternative to {approve} that can be used as a mitigation for
316      * problems described in {IERC20-approve}.
317      *
318      * Emits an {Approval} event indicating the updated allowance.
319      *
320      * Requirements:
321      *
322      * - `spender` cannot be the zero address.
323      * - `spender` must have allowance for the caller of at least
324      * `subtractedValue`.
325      */
326     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
327         uint256 currentAllowance = _allowances[_msgSender()][spender];
328         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
329         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
330 
331         return true;
332     }
333 
334     /**
335      * @dev Moves tokens `amount` from `sender` to `recipient`.
336      *
337      * This is internal function is equivalent to {transfer}, and can be used to
338      * e.g. implement automatic token fees, slashing mechanisms, etc.
339      *
340      * Emits a {Transfer} event.
341      *
342      * Requirements:
343      *
344      * - `sender` cannot be the zero address.
345      * - `recipient` cannot be the zero address.
346      * - `sender` must have a balance of at least `amount`.
347      */
348     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
349         require(sender != address(0), "ERC20: transfer from the zero address");
350         require(recipient != address(0), "ERC20: transfer to the zero address");
351 
352         _beforeTokenTransfer(sender, recipient, amount);
353 
354         uint256 senderBalance = _balances[sender];
355         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
356         _balances[sender] = senderBalance - amount;
357         _balances[recipient] += amount;
358 
359         emit Transfer(sender, recipient, amount);
360     }
361 
362     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
363      * the total supply.
364      *
365      * Emits a {Transfer} event with `from` set to the zero address.
366      *
367      * Requirements:
368      *
369      * - `to` cannot be the zero address.
370      */
371     function _mint(address account, uint256 amount) internal virtual {
372         require(account != address(0), "ERC20: mint to the zero address");
373 
374         _beforeTokenTransfer(address(0), account, amount);
375 
376         _totalSupply += amount;
377         _balances[account] += amount;
378         emit Transfer(address(0), account, amount);
379     }
380 
381     /**
382      * @dev Destroys `amount` tokens from `account`, reducing the
383      * total supply.
384      *
385      * Emits a {Transfer} event with `to` set to the zero address.
386      *
387      * Requirements:
388      *
389      * - `account` cannot be the zero address.
390      * - `account` must have at least `amount` tokens.
391      */
392     function _burn(address account, uint256 amount) internal virtual {
393         require(account != address(0), "ERC20: burn from the zero address");
394 
395         _beforeTokenTransfer(account, address(0), amount);
396 
397         uint256 accountBalance = _balances[account];
398         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
399         _balances[account] = accountBalance - amount;
400         _totalSupply -= amount;
401 
402         emit Transfer(account, address(0), amount);
403     }
404 
405     /**
406      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
407      *
408      * This internal function is equivalent to `approve`, and can be used to
409      * e.g. set automatic allowances for certain subsystems, etc.
410      *
411      * Emits an {Approval} event.
412      *
413      * Requirements:
414      *
415      * - `owner` cannot be the zero address.
416      * - `spender` cannot be the zero address.
417      */
418     function _approve(address owner, address spender, uint256 amount) internal virtual {
419         require(owner != address(0), "ERC20: approve from the zero address");
420         require(spender != address(0), "ERC20: approve to the zero address");
421 
422         _allowances[owner][spender] = amount;
423         emit Approval(owner, spender, amount);
424     }
425 
426     /**
427      * @dev Hook that is called before any transfer of tokens. This includes
428      * minting and burning.
429      *
430      * Calling conditions:
431      *
432      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
433      * will be to transferred to `to`.
434      * - when `from` is zero, `amount` tokens will be minted for `to`.
435      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
436      * - `from` and `to` are never both zero.
437      *
438      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
439      */
440     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
441 }
442 
443 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
444 
445 
446 
447 pragma solidity ^0.8.0;
448 
449 
450 
451 /**
452  * @dev Extension of {ERC20} that allows token holders to destroy both their own
453  * tokens and those that they have an allowance for, in a way that can be
454  * recognized off-chain (via event analysis).
455  */
456 abstract contract ERC20Burnable is Context, ERC20 {
457     /**
458      * @dev Destroys `amount` tokens from the caller.
459      *
460      * See {ERC20-_burn}.
461      */
462     function burn(uint256 amount) public virtual {
463         _burn(_msgSender(), amount);
464     }
465 
466     /**
467      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
468      * allowance.
469      *
470      * See {ERC20-_burn} and {ERC20-allowance}.
471      *
472      * Requirements:
473      *
474      * - the caller must have allowance for ``accounts``'s tokens of at least
475      * `amount`.
476      */
477     function burnFrom(address account, uint256 amount) public virtual {
478         uint256 currentAllowance = allowance(account, _msgSender());
479         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
480         _approve(account, _msgSender(), currentAllowance - amount);
481         _burn(account, amount);
482     }
483 }
484 
485 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
486 
487 
488 
489 pragma solidity ^0.8.0;
490 
491 /**
492  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
493  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
494  *
495  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
496  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
497  * need to send a transaction, and thus is not required to hold Ether at all.
498  */
499 interface IERC20Permit {
500     /**
501      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
502      * given ``owner``'s signed approval.
503      *
504      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
505      * ordering also apply here.
506      *
507      * Emits an {Approval} event.
508      *
509      * Requirements:
510      *
511      * - `spender` cannot be the zero address.
512      * - `deadline` must be a timestamp in the future.
513      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
514      * over the EIP712-formatted function arguments.
515      * - the signature must use ``owner``'s current nonce (see {nonces}).
516      *
517      * For more information on the signature format, see the
518      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
519      * section].
520      */
521     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
522 
523     /**
524      * @dev Returns the current nonce for `owner`. This value must be
525      * included whenever a signature is generated for {permit}.
526      *
527      * Every successful call to {permit} increases ``owner``'s nonce by one. This
528      * prevents a signature from being used multiple times.
529      */
530     function nonces(address owner) external view returns (uint256);
531 
532     /**
533      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
534      */
535     // solhint-disable-next-line func-name-mixedcase
536     function DOMAIN_SEPARATOR() external view returns (bytes32);
537 }
538 
539 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
540 
541 
542 
543 pragma solidity ^0.8.0;
544 
545 /**
546  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
547  *
548  * These functions can be used to verify that a message was signed by the holder
549  * of the private keys of a given address.
550  */
551 library ECDSA {
552     /**
553      * @dev Returns the address that signed a hashed message (`hash`) with
554      * `signature`. This address can then be used for verification purposes.
555      *
556      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
557      * this function rejects them by requiring the `s` value to be in the lower
558      * half order, and the `v` value to be either 27 or 28.
559      *
560      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
561      * verification to be secure: it is possible to craft signatures that
562      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
563      * this is by receiving a hash of the original message (which may otherwise
564      * be too long), and then calling {toEthSignedMessageHash} on it.
565      */
566     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
567         // Divide the signature in r, s and v variables
568         bytes32 r;
569         bytes32 s;
570         uint8 v;
571 
572         // Check the signature length
573         // - case 65: r,s,v signature (standard)
574         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
575         if (signature.length == 65) {
576             // ecrecover takes the signature parameters, and the only way to get them
577             // currently is to use assembly.
578             // solhint-disable-next-line no-inline-assembly
579             assembly {
580                 r := mload(add(signature, 0x20))
581                 s := mload(add(signature, 0x40))
582                 v := byte(0, mload(add(signature, 0x60)))
583             }
584         } else if (signature.length == 64) {
585             // ecrecover takes the signature parameters, and the only way to get them
586             // currently is to use assembly.
587             // solhint-disable-next-line no-inline-assembly
588             assembly {
589                 let vs := mload(add(signature, 0x40))
590                 r := mload(add(signature, 0x20))
591                 s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
592                 v := add(shr(255, vs), 27)
593             }
594         } else {
595             revert("ECDSA: invalid signature length");
596         }
597 
598         return recover(hash, v, r, s);
599     }
600 
601     /**
602      * @dev Overload of {ECDSA-recover} that receives the `v`,
603      * `r` and `s` signature fields separately.
604      */
605     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
606         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
607         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
608         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
609         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
610         //
611         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
612         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
613         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
614         // these malleable signatures as well.
615         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
616         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
617 
618         // If the signature is valid (and not malleable), return the signer address
619         address signer = ecrecover(hash, v, r, s);
620         require(signer != address(0), "ECDSA: invalid signature");
621 
622         return signer;
623     }
624 
625     /**
626      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
627      * produces hash corresponding to the one signed with the
628      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
629      * JSON-RPC method as part of EIP-191.
630      *
631      * See {recover}.
632      */
633     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
634         // 32 is the length in bytes of hash,
635         // enforced by the type signature above
636         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
637     }
638 
639     /**
640      * @dev Returns an Ethereum Signed Typed Data, created from a
641      * `domainSeparator` and a `structHash`. This produces hash corresponding
642      * to the one signed with the
643      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
644      * JSON-RPC method as part of EIP-712.
645      *
646      * See {recover}.
647      */
648     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
649         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
650     }
651 }
652 
653 // File: @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol
654 
655 
656 
657 pragma solidity ^0.8.0;
658 
659 
660 /**
661  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
662  *
663  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
664  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
665  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
666  *
667  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
668  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
669  * ({_hashTypedDataV4}).
670  *
671  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
672  * the chain id to protect against replay attacks on an eventual fork of the chain.
673  *
674  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
675  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
676  *
677  * _Available since v3.4._
678  */
679 abstract contract EIP712 {
680     /* solhint-disable var-name-mixedcase */
681     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
682     // invalidate the cached domain separator if the chain id changes.
683     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
684     uint256 private immutable _CACHED_CHAIN_ID;
685 
686     bytes32 private immutable _HASHED_NAME;
687     bytes32 private immutable _HASHED_VERSION;
688     bytes32 private immutable _TYPE_HASH;
689     /* solhint-enable var-name-mixedcase */
690 
691     /**
692      * @dev Initializes the domain separator and parameter caches.
693      *
694      * The meaning of `name` and `version` is specified in
695      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
696      *
697      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
698      * - `version`: the current major version of the signing domain.
699      *
700      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
701      * contract upgrade].
702      */
703     constructor(string memory name, string memory version) {
704         bytes32 hashedName = keccak256(bytes(name));
705         bytes32 hashedVersion = keccak256(bytes(version));
706         bytes32 typeHash = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
707         _HASHED_NAME = hashedName;
708         _HASHED_VERSION = hashedVersion;
709         _CACHED_CHAIN_ID = block.chainid;
710         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
711         _TYPE_HASH = typeHash;
712     }
713 
714     /**
715      * @dev Returns the domain separator for the current chain.
716      */
717     function _domainSeparatorV4() internal view returns (bytes32) {
718         if (block.chainid == _CACHED_CHAIN_ID) {
719             return _CACHED_DOMAIN_SEPARATOR;
720         } else {
721             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
722         }
723     }
724 
725     function _buildDomainSeparator(bytes32 typeHash, bytes32 name, bytes32 version) private view returns (bytes32) {
726         return keccak256(
727             abi.encode(
728                 typeHash,
729                 name,
730                 version,
731                 block.chainid,
732                 address(this)
733             )
734         );
735     }
736 
737     /**
738      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
739      * function returns the hash of the fully encoded EIP712 message for this domain.
740      *
741      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
742      *
743      * ```solidity
744      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
745      *     keccak256("Mail(address to,string contents)"),
746      *     mailTo,
747      *     keccak256(bytes(mailContents))
748      * )));
749      * address signer = ECDSA.recover(digest, signature);
750      * ```
751      */
752     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
753         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
754     }
755 }
756 
757 // File: @openzeppelin/contracts/utils/Counters.sol
758 
759 
760 
761 pragma solidity ^0.8.0;
762 
763 /**
764  * @title Counters
765  * @author Matt Condon (@shrugs)
766  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
767  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
768  *
769  * Include with `using Counters for Counters.Counter;`
770  */
771 library Counters {
772     struct Counter {
773         // This variable should never be directly accessed by users of the library: interactions must be restricted to
774         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
775         // this feature: see https://github.com/ethereum/solidity/issues/4637
776         uint256 _value; // default: 0
777     }
778 
779     function current(Counter storage counter) internal view returns (uint256) {
780         return counter._value;
781     }
782 
783     function increment(Counter storage counter) internal {
784         //unchecked {
785             counter._value += 1;
786         //}
787     }
788 
789     function decrement(Counter storage counter) internal {
790         uint256 value = counter._value;
791         require(value > 0, "Counter: decrement overflow");
792         //unchecked {
793             counter._value = value - 1;
794         //}
795     }
796 }
797 
798 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol
799 
800 
801 
802 pragma solidity ^0.8.0;
803 
804 
805 
806 
807 
808 
809 /**
810  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
811  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
812  *
813  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
814  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
815  * need to send a transaction, and thus is not required to hold Ether at all.
816  *
817  * _Available since v3.4._
818  */
819 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
820     using Counters for Counters.Counter;
821 
822     mapping (address => Counters.Counter) private _nonces;
823 
824     // solhint-disable-next-line var-name-mixedcase
825     bytes32 private immutable _PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
826 
827     /**
828      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
829      *
830      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
831      */
832     constructor(string memory name) EIP712(name, "1") {
833     }
834 
835     /**
836      * @dev See {IERC20Permit-permit}.
837      */
838     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual override {
839         // solhint-disable-next-line not-rely-on-time
840         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
841 
842         bytes32 structHash = keccak256(
843             abi.encode(
844                 _PERMIT_TYPEHASH,
845                 owner,
846                 spender,
847                 value,
848                 _useNonce(owner),
849                 deadline
850             )
851         );
852 
853         bytes32 hash = _hashTypedDataV4(structHash);
854 
855         address signer = ECDSA.recover(hash, v, r, s);
856         require(signer == owner, "ERC20Permit: invalid signature");
857 
858         _approve(owner, spender, value);
859     }
860 
861     /**
862      * @dev See {IERC20Permit-nonces}.
863      */
864     function nonces(address owner) public view virtual override returns (uint256) {
865         return _nonces[owner].current();
866     }
867 
868     /**
869      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
870      */
871     // solhint-disable-next-line func-name-mixedcase
872     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
873         return _domainSeparatorV4();
874     }
875 
876     /**
877      * @dev "Consume a nonce": return the current value and increment.
878      *
879      * _Available since v4.1._
880      */
881     function _useNonce(address owner) internal virtual returns (uint256 current) {
882         Counters.Counter storage nonce = _nonces[owner];
883         current = nonce.current();
884         nonce.increment();
885     }
886 }
887 
888 // File: @openzeppelin/contracts/access/Ownable.sol
889 
890 
891 
892 pragma solidity ^0.8.0;
893 
894 /**
895  * @dev Contract module which provides a basic access control mechanism, where
896  * there is an account (an owner) that can be granted exclusive access to
897  * specific functions.
898  *
899  * By default, the owner account will be the one that deploys the contract. This
900  * can later be changed with {transferOwnership}.
901  *
902  * This module is used through inheritance. It will make available the modifier
903  * `onlyOwner`, which can be applied to your functions to restrict their use to
904  * the owner.
905  */
906 abstract contract Ownable is Context {
907     address private _owner;
908 
909     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
910 
911     /**
912      * @dev Initializes the contract setting the deployer as the initial owner.
913      */
914     constructor () {
915         address msgSender = _msgSender();
916         _owner = msgSender;
917         emit OwnershipTransferred(address(0), msgSender);
918     }
919 
920     /**
921      * @dev Returns the address of the current owner.
922      */
923     function owner() public view virtual returns (address) {
924         return _owner;
925     }
926 
927     /**
928      * @dev Throws if called by any account other than the owner.
929      */
930     modifier onlyOwner() {
931         require(owner() == _msgSender(), "Ownable: caller is not the owner");
932         _;
933     }
934 
935     /**
936      * @dev Leaves the contract without owner. It will not be possible to call
937      * `onlyOwner` functions anymore. Can only be called by the current owner.
938      *
939      * NOTE: Renouncing ownership will leave the contract without an owner,
940      * thereby removing any functionality that is only available to the owner.
941      */
942     function renounceOwnership() public virtual onlyOwner {
943         emit OwnershipTransferred(_owner, address(0));
944         _owner = address(0);
945     }
946 
947     /**
948      * @dev Transfers ownership of the contract to a new account (`newOwner`).
949      * Can only be called by the current owner.
950      */
951     function transferOwnership(address newOwner) public virtual onlyOwner {
952         require(newOwner != address(0), "Ownable: new owner is the zero address");
953         emit OwnershipTransferred(_owner, newOwner);
954         _owner = newOwner;
955     }
956 }
957 
958 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
959 
960 
961 
962 pragma solidity ^0.8.0;
963 
964 // CAUTION
965 // This version of SafeMath should only be used with Solidity 0.8 or later,
966 // because it relies on the compiler's built in overflow checks.
967 
968 /**
969  * @dev Wrappers over Solidity's arithmetic operations.
970  *
971  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
972  * now has built in overflow checking.
973  */
974 library SafeMath {
975     /**
976      * @dev Returns the addition of two unsigned integers, with an overflow flag.
977      *
978      * _Available since v3.4._
979      */
980     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
981         // unchecked {
982             uint256 c = a + b;
983             if (c < a) return (false, 0);
984             return (true, c);
985         // }
986     }
987 
988     /**
989      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
990      *
991      * _Available since v3.4._
992      */
993     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
994         // unchecked {
995             if (b > a) return (false, 0);
996             return (true, a - b);
997         // }
998     }
999 
1000     /**
1001      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1002      *
1003      * _Available since v3.4._
1004      */
1005     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1006         // unchecked {
1007             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1008             // benefit is lost if 'b' is also tested.
1009             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1010             if (a == 0) return (true, 0);
1011             uint256 c = a * b;
1012             if (c / a != b) return (false, 0);
1013             return (true, c);
1014         // }
1015     }
1016 
1017     /**
1018      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1019      *
1020      * _Available since v3.4._
1021      */
1022     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1023         // unchecked {
1024             if (b == 0) return (false, 0);
1025             return (true, a / b);
1026         // }
1027     }
1028 
1029     /**
1030      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1031      *
1032      * _Available since v3.4._
1033      */
1034     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1035         // unchecked {
1036             if (b == 0) return (false, 0);
1037             return (true, a % b);
1038         // }
1039     }
1040 
1041     /**
1042      * @dev Returns the addition of two unsigned integers, reverting on
1043      * overflow.
1044      *
1045      * Counterpart to Solidity's `+` operator.
1046      *
1047      * Requirements:
1048      *
1049      * - Addition cannot overflow.
1050      */
1051     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1052         return a + b;
1053     }
1054 
1055     /**
1056      * @dev Returns the subtraction of two unsigned integers, reverting on
1057      * overflow (when the result is negative).
1058      *
1059      * Counterpart to Solidity's `-` operator.
1060      *
1061      * Requirements:
1062      *
1063      * - Subtraction cannot overflow.
1064      */
1065     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1066         return a - b;
1067     }
1068 
1069     /**
1070      * @dev Returns the multiplication of two unsigned integers, reverting on
1071      * overflow.
1072      *
1073      * Counterpart to Solidity's `*` operator.
1074      *
1075      * Requirements:
1076      *
1077      * - Multiplication cannot overflow.
1078      */
1079     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1080         return a * b;
1081     }
1082 
1083     /**
1084      * @dev Returns the integer division of two unsigned integers, reverting on
1085      * division by zero. The result is rounded towards zero.
1086      *
1087      * Counterpart to Solidity's `/` operator.
1088      *
1089      * Requirements:
1090      *
1091      * - The divisor cannot be zero.
1092      */
1093     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1094         return a / b;
1095     }
1096 
1097     /**
1098      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1099      * reverting when dividing by zero.
1100      *
1101      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1102      * opcode (which leaves remaining gas untouched) while Solidity uses an
1103      * invalid opcode to revert (consuming all remaining gas).
1104      *
1105      * Requirements:
1106      *
1107      * - The divisor cannot be zero.
1108      */
1109     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1110         return a % b;
1111     }
1112 
1113     /**
1114      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1115      * overflow (when the result is negative).
1116      *
1117      * CAUTION: This function is deprecated because it requires allocating memory for the error
1118      * message unnecessarily. For custom revert reasons use {trySub}.
1119      *
1120      * Counterpart to Solidity's `-` operator.
1121      *
1122      * Requirements:
1123      *
1124      * - Subtraction cannot overflow.
1125      */
1126     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1127         // unchecked {
1128             require(b <= a, errorMessage);
1129             return a - b;
1130         // }
1131     }
1132 
1133     /**
1134      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1135      * division by zero. The result is rounded towards zero.
1136      *
1137      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1138      * opcode (which leaves remaining gas untouched) while Solidity uses an
1139      * invalid opcode to revert (consuming all remaining gas).
1140      *
1141      * Counterpart to Solidity's `/` operator. Note: this function uses a
1142      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1143      * uses an invalid opcode to revert (consuming all remaining gas).
1144      *
1145      * Requirements:
1146      *
1147      * - The divisor cannot be zero.
1148      */
1149     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1150         // unchecked {
1151             require(b > 0, errorMessage);
1152             return a / b;
1153         // }
1154     }
1155 
1156     /**
1157      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1158      * reverting with custom message when dividing by zero.
1159      *
1160      * CAUTION: This function is deprecated because it requires allocating memory for the error
1161      * message unnecessarily. For custom revert reasons use {tryMod}.
1162      *
1163      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1164      * opcode (which leaves remaining gas untouched) while Solidity uses an
1165      * invalid opcode to revert (consuming all remaining gas).
1166      *
1167      * Requirements:
1168      *
1169      * - The divisor cannot be zero.
1170      */
1171     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1172         // unchecked {
1173             require(b > 0, errorMessage);
1174             return a % b;
1175         // }
1176     }
1177 }
1178 
1179 // File: contracts/OwnixToken.sol
1180 
1181 // contracts/ OwnixToken.sol
1182 
1183 
1184 pragma solidity ^0.8.0;
1185 
1186 
1187 
1188 
1189 
1190 
1191 contract OwnixToken is ERC20, Ownable, ERC20Burnable, ERC20Permit {
1192   using SafeMath for uint256;
1193 
1194   mapping(address => bool) private minters;
1195 
1196   modifier onlyMinters {
1197     require(minters[msg.sender] || msg.sender == owner(), "Only Minters");
1198     _;
1199   }
1200 
1201   constructor(address[] memory _addresses) ERC20("Ownix", "ONX") ERC20Permit("Ownix")  {
1202     require(_addresses.length > 0, " OwnixToken: no addresses");
1203     require(_addresses.length == 5, " OwnixToken: payees must be 5");
1204 
1205     uint256 totalTokens = 1000000000 * (10**uint256(decimals()));
1206     _mint(_addresses[0], totalTokens.mul(35).div(100));
1207     _mint(_addresses[1], totalTokens.mul(30).div(100));
1208     _mint(_addresses[2], totalTokens.mul(20).div(100));
1209     _mint(_addresses[3], totalTokens.mul(10).div(100));
1210     _mint(_addresses[4], totalTokens.mul(5).div(100));
1211   }
1212 
1213   /**
1214    * Minters APIs
1215    */
1216    
1217    /**
1218    * @dev onlyMinters function to mint new token.
1219    *
1220    * @param _account address to mint to
1221    * @param _amount amount to mint
1222    */
1223   function mint(address _account, uint256 _amount) external onlyMinters {
1224     _mint(_account, _amount);
1225   }
1226 
1227   /**
1228    * Owner APIs
1229    */
1230 
1231   /**
1232    * @dev admin function to set minter.
1233    *
1234    * @param _minter address the address to set minting privileges of
1235    * @param _privileged bool whether or not this address can mint
1236    */
1237   function setMinter(address _minter, bool _privileged) external onlyOwner {
1238     minters[_minter] = _privileged;
1239   }
1240 
1241   /**
1242    * @dev withdraw the tokens from the contrcat
1243    * @param _withdrawAddress - The withdraw address
1244    * @param _amount - The withdrawal amount
1245    */
1246   function withdraw(address _withdrawAddress, uint256 _amount)
1247     external
1248     onlyOwner
1249   {
1250     require(
1251       _withdrawAddress != address(0),
1252       "address can't be the zero address"
1253     );
1254 
1255     require(transfer(_withdrawAddress, _amount), "Withdraw failed");
1256   }
1257 
1258   /**
1259    * Read APIs
1260    */
1261   function isMinter(address _minter) external view returns (bool) {
1262     return minters[_minter];
1263   }
1264 }