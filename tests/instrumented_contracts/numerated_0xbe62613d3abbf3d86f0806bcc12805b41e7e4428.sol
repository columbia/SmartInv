1 // SPDX-License-Identifier: MIT
2  
3 pragma solidity ^0.8.0;
4  
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19  
20     function _msgData() internal view virtual returns (bytes calldata) {
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
40     event OwnershipTransferred(
41         address indexed previousOwner,
42         address indexed newOwner
43     );
44  
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor() {
49         _setOwner(_msgSender());
50     }
51  
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view virtual returns (address) {
56         return _owner;
57     }
58  
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(owner() == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66  
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public virtual onlyOwner {
75         _setOwner(address(0));
76     }
77  
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(
84             newOwner != address(0),
85             "Ownable: new owner is the zero address"
86         );
87         _setOwner(newOwner);
88     }
89  
90     function _setOwner(address newOwner) private {
91         address oldOwner = _owner;
92         _owner = newOwner;
93         emit OwnershipTransferred(oldOwner, newOwner);
94     }
95 }
96  
97 /**
98  * @dev Interface of the ERC20 standard as defined in the EIP.
99  */
100 interface IERC20 {
101     /**
102      * @dev Returns the amount of tokens in existence.
103      */
104     function totalSupply() external view returns (uint256);
105  
106     /**
107      * @dev Returns the amount of tokens owned by `account`.
108      */
109     function balanceOf(address account) external view returns (uint256);
110  
111     /**
112      * @dev Moves `amount` tokens from the caller's account to `recipient`.
113      *
114      * Returns a boolean value indicating whether the operation succeeded.
115      *
116      * Emits a {Transfer} event.
117      */
118     function transfer(address recipient, uint256 amount)
119         external
120         returns (bool);
121  
122     /**
123      * @dev Returns the remaining number of tokens that `spender` will be
124      * allowed to spend on behalf of `owner` through {transferFrom}. This is
125      * zero by default.
126      *
127      * This value changes when {approve} or {transferFrom} are called.
128      */
129     function allowance(address owner, address spender)
130         external
131         view
132         returns (uint256);
133  
134     /**
135      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * IMPORTANT: Beware that changing an allowance with this method brings the risk
140      * that someone may use both the old and the new allowance by unfortunate
141      * transaction ordering. One possible solution to mitigate this race
142      * condition is to first reduce the spender's allowance to 0 and set the
143      * desired value afterwards:
144      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145      *
146      * Emits an {Approval} event.
147      */
148     function approve(address spender, uint256 amount) external returns (bool);
149  
150     /**
151      * @dev Moves `amount` tokens from `sender` to `recipient` using the
152      * allowance mechanism. `amount` is then deducted from the caller's
153      * allowance.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transferFrom(
160         address sender,
161         address recipient,
162         uint256 amount
163     ) external returns (bool);
164  
165     /**
166      * @dev Emitted when `value` tokens are moved from one account (`from`) to
167      * another (`to`).
168      *
169      * Note that `value` may be zero.
170      */
171     event Transfer(address indexed from, address indexed to, uint256 value);
172  
173     /**
174      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
175      * a call to {approve}. `value` is the new allowance.
176      */
177     event Approval(
178         address indexed owner,
179         address indexed spender,
180         uint256 value
181     );
182 }
183  
184 /**
185  * @dev Interface for the optional metadata functions from the ERC20 standard.
186  *
187  * _Available since v4.1._
188  */
189 interface IERC20Metadata is IERC20 {
190     /**
191      * @dev Returns the name of the token.
192      */
193     function name() external view returns (string memory);
194  
195     /**
196      * @dev Returns the symbol of the token.
197      */
198     function symbol() external view returns (string memory);
199  
200     /**
201      * @dev Returns the decimals places of the token.
202      */
203     function decimals() external view returns (uint8);
204 }
205  
206 /**
207  * @dev Implementation of the {IERC20} interface.
208  *
209  * This implementation is agnostic to the way tokens are created. This means
210  * that a supply mechanism has to be added in a derived contract using {_mint}.
211  * For a generic mechanism see {ERC20PresetMinterPauser}.
212  *
213  * TIP: For a detailed writeup see our guide
214  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
215  * to implement supply mechanisms].
216  *
217  * We have followed general OpenZeppelin Contracts guidelines: functions revert
218  * instead returning `false` on failure. This behavior is nonetheless
219  * conventional and does not conflict with the expectations of ERC20
220  * applications.
221  *
222  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
223  * This allows applications to reconstruct the allowance for all accounts just
224  * by listening to said events. Other implementations of the EIP may not emit
225  * these events, as it isn't required by the specification.
226  *
227  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
228  * functions have been added to mitigate the well-known issues around setting
229  * allowances. See {IERC20-approve}.
230  */
231 contract ERC20 is Context, IERC20, IERC20Metadata {
232     mapping(address => uint256) private _balances;
233  
234     mapping(address => mapping(address => uint256)) private _allowances;
235  
236     uint256 private _totalSupply;
237  
238     string private _name;
239     string private _symbol;
240  
241     /**
242      * @dev Sets the values for {name} and {symbol}.
243      *
244      * The default value of {decimals} is 18. To select a different value for
245      * {decimals} you should overload it.
246      *
247      * All two of these values are immutable: they can only be set once during
248      * construction.
249      */
250     constructor(string memory name_, string memory symbol_) {
251         _name = name_;
252         _symbol = symbol_;
253     }
254  
255     /**
256      * @dev Returns the name of the token.
257      */
258     function name() public view virtual override returns (string memory) {
259         return _name;
260     }
261  
262     /**
263      * @dev Returns the symbol of the token, usually a shorter version of the
264      * name.
265      */
266     function symbol() public view virtual override returns (string memory) {
267         return _symbol;
268     }
269  
270     /**
271      * @dev Returns the number of decimals used to get its user representation.
272      * For example, if `decimals` equals `2`, a balance of `505` tokens should
273      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
274      *
275      * Tokens usually opt for a value of 18, imitating the relationship between
276      * Ether and Wei. This is the value {ERC20} uses, unless this function is
277      * overridden;
278      *
279      * NOTE: This information is only used for _display_ purposes: it in
280      * no way affects any of the arithmetic of the contract, including
281      * {IERC20-balanceOf} and {IERC20-transfer}.
282      */
283     function decimals() public view virtual override returns (uint8) {
284         return 18;
285     }
286  
287     /**
288      * @dev See {IERC20-totalSupply}.
289      */
290     function totalSupply() public view virtual override returns (uint256) {
291         return _totalSupply;
292     }
293  
294     /**
295      * @dev See {IERC20-balanceOf}.
296      */
297     function balanceOf(address account)
298         public
299         view
300         virtual
301         override
302         returns (uint256)
303     {
304         return _balances[account];
305     }
306  
307     /**
308      * @dev See {IERC20-transfer}.
309      *
310      * Requirements:
311      *
312      * - `recipient` cannot be the zero address.
313      * - the caller must have a balance of at least `amount`.
314      */
315     function transfer(address recipient, uint256 amount)
316         public
317         virtual
318         override
319         returns (bool)
320     {
321         _transfer(_msgSender(), recipient, amount);
322         return true;
323     }
324  
325     /**
326      * @dev See {IERC20-allowance}.
327      */
328     function allowance(address owner, address spender)
329         public
330         view
331         virtual
332         override
333         returns (uint256)
334     {
335         return _allowances[owner][spender];
336     }
337  
338     /**
339      * @dev See {IERC20-approve}.
340      *
341      * Requirements:
342      *
343      * - `spender` cannot be the zero address.
344      */
345     function approve(address spender, uint256 amount)
346         public
347         virtual
348         override
349         returns (bool)
350     {
351         _approve(_msgSender(), spender, amount);
352         return true;
353     }
354  
355     /**
356      * @dev See {IERC20-transferFrom}.
357      *
358      * Emits an {Approval} event indicating the updated allowance. This is not
359      * required by the EIP. See the note at the beginning of {ERC20}.
360      *
361      * Requirements:
362      *
363      * - `sender` and `recipient` cannot be the zero address.
364      * - `sender` must have a balance of at least `amount`.
365      * - the caller must have allowance for ``sender``'s tokens of at least
366      * `amount`.
367      */
368     function transferFrom(
369         address sender,
370         address recipient,
371         uint256 amount
372     ) public virtual override returns (bool) {
373         _transfer(sender, recipient, amount);
374  
375         uint256 currentAllowance = _allowances[sender][_msgSender()];
376         require(
377             currentAllowance >= amount,
378             "ERC20: transfer amount exceeds allowance"
379         );
380         unchecked {
381             _approve(sender, _msgSender(), currentAllowance - amount);
382         }
383  
384         return true;
385     }
386  
387     /**
388      * @dev Atomically increases the allowance granted to `spender` by the caller.
389      *
390      * This is an alternative to {approve} that can be used as a mitigation for
391      * problems described in {IERC20-approve}.
392      *
393      * Emits an {Approval} event indicating the updated allowance.
394      *
395      * Requirements:
396      *
397      * - `spender` cannot be the zero address.
398      */
399     function increaseAllowance(address spender, uint256 addedValue)
400         public
401         virtual
402         returns (bool)
403     {
404         _approve(
405             _msgSender(),
406             spender,
407             _allowances[_msgSender()][spender] + addedValue
408         );
409         return true;
410     }
411  
412     /**
413      * @dev Atomically decreases the allowance granted to `spender` by the caller.
414      *
415      * This is an alternative to {approve} that can be used as a mitigation for
416      * problems described in {IERC20-approve}.
417      *
418      * Emits an {Approval} event indicating the updated allowance.
419      *
420      * Requirements:
421      *
422      * - `spender` cannot be the zero address.
423      * - `spender` must have allowance for the caller of at least
424      * `subtractedValue`.
425      */
426     function decreaseAllowance(address spender, uint256 subtractedValue)
427         public
428         virtual
429         returns (bool)
430     {
431         uint256 currentAllowance = _allowances[_msgSender()][spender];
432         require(
433             currentAllowance >= subtractedValue,
434             "ERC20: decreased allowance below zero"
435         );
436         unchecked {
437             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
438         }
439  
440         return true;
441     }
442  
443     /**
444      * @dev Moves `amount` of tokens from `sender` to `recipient`.
445      *
446      * This internal function is equivalent to {transfer}, and can be used to
447      * e.g. implement automatic token fees, slashing mechanisms, etc.
448      *
449      * Emits a {Transfer} event.
450      *
451      * Requirements:
452      *
453      * - `sender` cannot be the zero address.
454      * - `recipient` cannot be the zero address.
455      * - `sender` must have a balance of at least `amount`.
456      */
457     function _transfer(
458         address sender,
459         address recipient,
460         uint256 amount
461     ) internal virtual {
462         require(sender != address(0), "ERC20: transfer from the zero address");
463         require(recipient != address(0), "ERC20: transfer to the zero address");
464  
465         _beforeTokenTransfer(sender, recipient, amount);
466  
467         uint256 senderBalance = _balances[sender];
468         require(
469             senderBalance >= amount,
470             "ERC20: transfer amount exceeds balance"
471         );
472         unchecked {
473             _balances[sender] = senderBalance - amount;
474         }
475         _balances[recipient] += amount;
476  
477         emit Transfer(sender, recipient, amount);
478  
479         _afterTokenTransfer(sender, recipient, amount);
480     }
481  
482     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
483      * the total supply.
484      *
485      * Emits a {Transfer} event with `from` set to the zero address.
486      *
487      * Requirements:
488      *
489      * - `account` cannot be the zero address.
490      */
491     function _mint(address account, uint256 amount) internal virtual {
492         require(account != address(0), "ERC20: mint to the zero address");
493  
494         _beforeTokenTransfer(address(0), account, amount);
495  
496         _totalSupply += amount;
497         _balances[account] += amount;
498         emit Transfer(address(0), account, amount);
499  
500         _afterTokenTransfer(address(0), account, amount);
501     }
502  
503     /**
504      * @dev Destroys `amount` tokens from `account`, reducing the
505      * total supply.
506      *
507      * Emits a {Transfer} event with `to` set to the zero address.
508      *
509      * Requirements:
510      *
511      * - `account` cannot be the zero address.
512      * - `account` must have at least `amount` tokens.
513      */
514     function _burn(uint256 amount) internal virtual {
515         address burner = msg.sender;
516         _beforeTokenTransfer(burner, address(0), amount);
517  
518         uint256 accountBalance = _balances[burner];
519         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
520         unchecked {
521             _balances[burner] = accountBalance - amount;
522         }
523         _totalSupply -= amount;
524  
525         emit Transfer(burner, address(0), amount);
526  
527         _afterTokenTransfer(burner, address(0), amount);
528     }
529  
530     /**
531      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
532      *
533      * This internal function is equivalent to `approve`, and can be used to
534      * e.g. set automatic allowances for certain subsystems, etc.
535      *
536      * Emits an {Approval} event.
537      *
538      * Requirements:
539      *
540      * - `owner` cannot be the zero address.
541      * - `spender` cannot be the zero address.
542      */
543     function _approve(
544         address owner,
545         address spender,
546         uint256 amount
547     ) internal virtual {
548         require(owner != address(0), "ERC20: approve from the zero address");
549         require(spender != address(0), "ERC20: approve to the zero address");
550  
551         _allowances[owner][spender] = amount;
552         emit Approval(owner, spender, amount);
553     }
554  
555     /**
556      * @dev Hook that is called before any transfer of tokens. This includes
557      * minting and burning.
558      *
559      * Calling conditions:
560      *
561      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
562      * will be transferred to `to`.
563      * - when `from` is zero, `amount` tokens will be minted for `to`.
564      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
565      * - `from` and `to` are never both zero.
566      *
567      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
568      */
569     function _beforeTokenTransfer(
570         address from,
571         address to,
572         uint256 amount
573     ) internal virtual {}
574  
575     /**
576      * @dev Hook that is called after any transfer of tokens. This includes
577      * minting and burning.
578      *
579      * Calling conditions:
580      *
581      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
582      * has been transferred to `to`.
583      * - when `from` is zero, `amount` tokens have been minted for `to`.
584      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
585      * - `from` and `to` are never both zero.
586      *
587      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
588      */
589     function _afterTokenTransfer(
590         address from,
591         address to,
592         uint256 amount
593     ) internal virtual {}
594 }
595  
596 /**
597  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
598  *
599  * These functions can be used to verify that a message was signed by the holder
600  * of the private keys of a given address.
601  */
602 library ECDSA {
603     enum RecoverError {
604         NoError,
605         InvalidSignature,
606         InvalidSignatureLength,
607         InvalidSignatureS,
608         InvalidSignatureV
609     }
610  
611     function _throwError(RecoverError error) private pure {
612         if (error == RecoverError.NoError) {
613             return; // no error: do nothing
614         } else if (error == RecoverError.InvalidSignature) {
615             revert("ECDSA: invalid signature");
616         } else if (error == RecoverError.InvalidSignatureLength) {
617             revert("ECDSA: invalid signature length");
618         } else if (error == RecoverError.InvalidSignatureS) {
619             revert("ECDSA: invalid signature 's' value");
620         } else if (error == RecoverError.InvalidSignatureV) {
621             revert("ECDSA: invalid signature 'v' value");
622         }
623     }
624  
625     /**
626      * @dev Returns the address that signed a hashed message (`hash`) with
627      * `signature` or error string. This address can then be used for verification purposes.
628      *
629      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
630      * this function rejects them by requiring the `s` value to be in the lower
631      * half order, and the `v` value to be either 27 or 28.
632      *
633      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
634      * verification to be secure: it is possible to craft signatures that
635      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
636      * this is by receiving a hash of the original message (which may otherwise
637      * be too long), and then calling {toEthSignedMessageHash} on it.
638      *
639      * Documentation for signature generation:
640      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
641      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
642      *
643      * _Available since v4.3._
644      */
645     function tryRecover(bytes32 hash, bytes memory signature)
646         internal
647         pure
648         returns (address, RecoverError)
649     {
650         // Check the signature length
651         // - case 65: r,s,v signature (standard)
652         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
653         if (signature.length == 65) {
654             bytes32 r;
655             bytes32 s;
656             uint8 v;
657             // ecrecover takes the signature parameters, and the only way to get them
658             // currently is to use assembly.
659             assembly {
660                 r := mload(add(signature, 0x20))
661                 s := mload(add(signature, 0x40))
662                 v := byte(0, mload(add(signature, 0x60)))
663             }
664             return tryRecover(hash, v, r, s);
665         } else if (signature.length == 64) {
666             bytes32 r;
667             bytes32 vs;
668             // ecrecover takes the signature parameters, and the only way to get them
669             // currently is to use assembly.
670             assembly {
671                 r := mload(add(signature, 0x20))
672                 vs := mload(add(signature, 0x40))
673             }
674             return tryRecover(hash, r, vs);
675         } else {
676             return (address(0), RecoverError.InvalidSignatureLength);
677         }
678     }
679  
680     /**
681      * @dev Returns the address that signed a hashed message (`hash`) with
682      * `signature`. This address can then be used for verification purposes.
683      *
684      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
685      * this function rejects them by requiring the `s` value to be in the lower
686      * half order, and the `v` value to be either 27 or 28.
687      *
688      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
689      * verification to be secure: it is possible to craft signatures that
690      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
691      * this is by receiving a hash of the original message (which may otherwise
692      * be too long), and then calling {toEthSignedMessageHash} on it.
693      */
694     function recover(bytes32 hash, bytes memory signature)
695         internal
696         pure
697         returns (address)
698     {
699         (address recovered, RecoverError error) = tryRecover(hash, signature);
700         _throwError(error);
701         return recovered;
702     }
703  
704     /**
705      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
706      *
707      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
708      *
709      * _Available since v4.3._
710      */
711     function tryRecover(
712         bytes32 hash,
713         bytes32 r,
714         bytes32 vs
715     ) internal pure returns (address, RecoverError) {
716         bytes32 s;
717         uint8 v;
718         assembly {
719             s := and(
720                 vs,
721                 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
722             )
723             v := add(shr(255, vs), 27)
724         }
725         return tryRecover(hash, v, r, s);
726     }
727  
728     /**
729      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
730      *
731      * _Available since v4.2._
732      */
733     function recover(
734         bytes32 hash,
735         bytes32 r,
736         bytes32 vs
737     ) internal pure returns (address) {
738         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
739         _throwError(error);
740         return recovered;
741     }
742  
743     /**
744      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
745      * `r` and `s` signature fields separately.
746      *
747      * _Available since v4.3._
748      */
749     function tryRecover(
750         bytes32 hash,
751         uint8 v,
752         bytes32 r,
753         bytes32 s
754     ) internal pure returns (address, RecoverError) {
755         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
756         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
757         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
758         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
759         //
760         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
761         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
762         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
763         // these malleable signatures as well.
764         if (
765             uint256(s) >
766             0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
767         ) {
768             return (address(0), RecoverError.InvalidSignatureS);
769         }
770         if (v != 27 && v != 28) {
771             return (address(0), RecoverError.InvalidSignatureV);
772         }
773  
774         // If the signature is valid (and not malleable), return the signer address
775         address signer = ecrecover(hash, v, r, s);
776         if (signer == address(0)) {
777             return (address(0), RecoverError.InvalidSignature);
778         }
779  
780         return (signer, RecoverError.NoError);
781     }
782  
783     /**
784      * @dev Overload of {ECDSA-recover} that receives the `v`,
785      * `r` and `s` signature fields separately.
786      */
787     function recover(
788         bytes32 hash,
789         uint8 v,
790         bytes32 r,
791         bytes32 s
792     ) internal pure returns (address) {
793         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
794         _throwError(error);
795         return recovered;
796     }
797  
798     /**
799      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
800      * produces hash corresponding to the one signed with the
801      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
802      * JSON-RPC method as part of EIP-191.
803      *
804      * See {recover}.
805      */
806     function toEthSignedMessageHash(bytes32 hash)
807         internal
808         pure
809         returns (bytes32)
810     {
811         // 32 is the length in bytes of hash,
812         // enforced by the type signature above
813         return
814             keccak256(
815                 abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
816             );
817     }
818  
819     /**
820      * @dev Returns an Ethereum Signed Typed Data, created from a
821      * `domainSeparator` and a `structHash`. This produces hash corresponding
822      * to the one signed with the
823      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
824      * JSON-RPC method as part of EIP-712.
825      *
826      * See {recover}.
827      */
828     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash)
829         internal
830         pure
831         returns (bytes32)
832     {
833         return
834             keccak256(
835                 abi.encodePacked("\x19\x01", domainSeparator, structHash)
836             );
837     }
838 }
839  
840 /**
841  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
842  *
843  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
844  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
845  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
846  *
847  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
848  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
849  * ({_hashTypedDataV4}).
850  *
851  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
852  * the chain id to protect against replay attacks on an eventual fork of the chain.
853  *
854  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
855  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
856  *
857  * _Available since v3.4._
858  */
859 abstract contract EIP712 {
860     /* solhint-disable var-name-mixedcase */
861     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
862     // invalidate the cached domain separator if the chain id changes.
863     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
864     uint256 private immutable _CACHED_CHAIN_ID;
865  
866     bytes32 private immutable _HASHED_NAME;
867     bytes32 private immutable _HASHED_VERSION;
868     bytes32 private immutable _TYPE_HASH;
869  
870     /* solhint-enable var-name-mixedcase */
871  
872     /**
873      * @dev Initializes the domain separator and parameter caches.
874      *
875      * The meaning of `name` and `version` is specified in
876      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
877      *
878      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
879      * - `version`: the current major version of the signing domain.
880      *
881      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
882      * contract upgrade].
883      */
884     constructor(string memory name, string memory version) {
885         bytes32 hashedName = keccak256(bytes(name));
886         bytes32 hashedVersion = keccak256(bytes(version));
887         bytes32 typeHash = keccak256(
888             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
889         );
890         _HASHED_NAME = hashedName;
891         _HASHED_VERSION = hashedVersion;
892         _CACHED_CHAIN_ID = block.chainid;
893         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(
894             typeHash,
895             hashedName,
896             hashedVersion
897         );
898         _TYPE_HASH = typeHash;
899     }
900  
901     /**
902      * @dev Returns the domain separator for the current chain.
903      */
904     function _domainSeparatorV4() internal view returns (bytes32) {
905         if (block.chainid == _CACHED_CHAIN_ID) {
906             return _CACHED_DOMAIN_SEPARATOR;
907         } else {
908             return
909                 _buildDomainSeparator(
910                     _TYPE_HASH,
911                     _HASHED_NAME,
912                     _HASHED_VERSION
913                 );
914         }
915     }
916  
917     function _buildDomainSeparator(
918         bytes32 typeHash,
919         bytes32 nameHash,
920         bytes32 versionHash
921     ) private view returns (bytes32) {
922         return
923             keccak256(
924                 abi.encode(
925                     typeHash,
926                     nameHash,
927                     versionHash,
928                     block.chainid,
929                     address(this)
930                 )
931             );
932     }
933  
934     /**
935      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
936      * function returns the hash of the fully encoded EIP712 message for this domain.
937      *
938      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
939      *
940      * ```solidity
941      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
942      *     keccak256("Mail(address to,string contents)"),
943      *     mailTo,
944      *     keccak256(bytes(mailContents))
945      * )));
946      * address signer = ECDSA.recover(digest, signature);
947      * ```
948      */
949     function _hashTypedDataV4(bytes32 structHash)
950         internal
951         view
952         virtual
953         returns (bytes32)
954     {
955         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
956     }
957 }
958  
959 /**
960  * @title Counters
961  * @author Matt Condon (@shrugs)
962  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
963  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
964  *
965  * Include with `using Counters for Counters.Counter;`
966  */
967 library Counters {
968     struct Counter {
969         // This variable should never be directly accessed by users of the library: interactions must be restricted to
970         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
971         // this feature: see https://github.com/ethereum/solidity/issues/4637
972         uint256 _value; // default: 0
973     }
974  
975     function current(Counter storage counter) internal view returns (uint256) {
976         return counter._value;
977     }
978  
979     function increment(Counter storage counter) internal {
980         unchecked {
981             counter._value += 1;
982         }
983     }
984  
985     function decrement(Counter storage counter) internal {
986         uint256 value = counter._value;
987         require(value > 0, "Counter: decrement overflow");
988         unchecked {
989             counter._value = value - 1;
990         }
991     }
992  
993     function reset(Counter storage counter) internal {
994         counter._value = 0;
995     }
996 }
997  
998 /**
999  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1000  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1001  *
1002  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1003  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
1004  * need to send a transaction, and thus is not required to hold Ether at all.
1005  */
1006 interface IERC20Permit {
1007     /**
1008      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1009      * given ``owner``'s signed approval.
1010      *
1011      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1012      * ordering also apply here.
1013      *
1014      * Emits an {Approval} event.
1015      *
1016      * Requirements:
1017      *
1018      * - `spender` cannot be the zero address.
1019      * - `deadline` must be a timestamp in the future.
1020      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1021      * over the EIP712-formatted function arguments.
1022      * - the signature must use ``owner``'s current nonce (see {nonces}).
1023      *
1024      * For more information on the signature format, see the
1025      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1026      * section].
1027      */
1028     function permit(
1029         address owner,
1030         address spender,
1031         uint256 value,
1032         uint256 deadline,
1033         uint8 v,
1034         bytes32 r,
1035         bytes32 s
1036     ) external;
1037  
1038     /**
1039      * @dev Returns the current nonce for `owner`. This value must be
1040      * included whenever a signature is generated for {permit}.
1041      *
1042      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1043      * prevents a signature from being used multiple times.
1044      */
1045     function nonces(address owner) external view returns (uint256);
1046  
1047     /**
1048      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1049      */
1050     // solhint-disable-next-line func-name-mixedcase
1051     function DOMAIN_SEPARATOR() external view returns (bytes32);
1052 }
1053  
1054 /**
1055  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1056  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1057  *
1058  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1059  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1060  * need to send a transaction, and thus is not required to hold Ether at all.
1061  *
1062  * _Available since v3.4._
1063  */
1064 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1065     using Counters for Counters.Counter;
1066  
1067     mapping(address => Counters.Counter) private _nonces;
1068  
1069     // solhint-disable-next-line var-name-mixedcase
1070     bytes32 private immutable _PERMIT_TYPEHASH =
1071         keccak256(
1072             "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
1073         );
1074  
1075     /**
1076      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1077      *
1078      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1079      */
1080     constructor(string memory name) EIP712(name, "1") {}
1081  
1082     /**
1083      * @dev See {IERC20Permit-permit}.
1084      */
1085     function permit(
1086         address owner,
1087         address spender,
1088         uint256 value,
1089         uint256 deadline,
1090         uint8 v,
1091         bytes32 r,
1092         bytes32 s
1093     ) public virtual override {
1094         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1095  
1096         bytes32 structHash = keccak256(
1097             abi.encode(
1098                 _PERMIT_TYPEHASH,
1099                 owner,
1100                 spender,
1101                 value,
1102                 _useNonce(owner),
1103                 deadline
1104             )
1105         );
1106  
1107         bytes32 hash = _hashTypedDataV4(structHash);
1108  
1109         address signer = ECDSA.recover(hash, v, r, s);
1110         require(signer == owner, "ERC20Permit: invalid signature");
1111  
1112         _approve(owner, spender, value);
1113     }
1114  
1115     /**
1116      * @dev See {IERC20Permit-nonces}.
1117      */
1118     function nonces(address owner)
1119         public
1120         view
1121         virtual
1122         override
1123         returns (uint256)
1124     {
1125         return _nonces[owner].current();
1126     }
1127  
1128     /**
1129      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1130      */
1131     // solhint-disable-next-line func-name-mixedcase
1132     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1133         return _domainSeparatorV4();
1134     }
1135  
1136     /**
1137      * @dev "Consume a nonce": return the current value and increment.
1138      *
1139      * _Available since v4.1._
1140      */
1141     function _useNonce(address owner)
1142         internal
1143         virtual
1144         returns (uint256 current)
1145     {
1146         Counters.Counter storage nonce = _nonces[owner];
1147         current = nonce.current();
1148         nonce.increment();
1149     }
1150 }
1151  
1152 contract ChainGainToken is ERC20Permit, Ownable {
1153     string internal constant NAME = "ChainGain";
1154     string internal constant SYMBOL = "CGN";
1155     uint256 internal constant MAX_SUPPLY_AMOUNT = 100000000;
1156     uint256 public maxSupply;
1157  
1158     event Burn(address indexed burner, uint256 value);
1159  
1160     constructor() ERC20Permit(NAME) ERC20(NAME, SYMBOL) {
1161         maxSupply = MAX_SUPPLY_AMOUNT * decimalFactor();
1162     }
1163  
1164     function decimalFactor() public view returns (uint256) {
1165         return 10**decimals();
1166     }
1167  
1168     function mint(address _to, uint256 _value) external onlyOwner {
1169         unchecked {
1170             uint256 newTotalSupply = totalSupply() + _value;
1171             require(maxSupply >= newTotalSupply, "Minting exceed max supply");
1172         }
1173         super._mint(_to, _value);
1174     }
1175  
1176     function burn(uint256 _value) public {
1177         super._burn(_value);
1178         emit Burn(msg.sender, _value);
1179     }
1180 }