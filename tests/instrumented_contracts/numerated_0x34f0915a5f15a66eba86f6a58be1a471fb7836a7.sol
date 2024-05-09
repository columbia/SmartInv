1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/token/ERC20/IERC20.sol
29 
30 
31 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP.
37  */
38 interface IERC20 {
39     /**
40      * @dev Returns the amount of tokens in existence.
41      */
42     function totalSupply() external view returns (uint256);
43 
44     /**
45      * @dev Returns the amount of tokens owned by `account`.
46      */
47     function balanceOf(address account) external view returns (uint256);
48 
49     /**
50      * @dev Moves `amount` tokens from the caller's account to `recipient`.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transfer(address recipient, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Returns the remaining number of tokens that `spender` will be
60      * allowed to spend on behalf of `owner` through {transferFrom}. This is
61      * zero by default.
62      *
63      * This value changes when {approve} or {transferFrom} are called.
64      */
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67     /**
68      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * IMPORTANT: Beware that changing an allowance with this method brings the risk
73      * that someone may use both the old and the new allowance by unfortunate
74      * transaction ordering. One possible solution to mitigate this race
75      * condition is to first reduce the spender's allowance to 0 and set the
76      * desired value afterwards:
77      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78      *
79      * Emits an {Approval} event.
80      */
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Moves `amount` tokens from `sender` to `recipient` using the
85      * allowance mechanism. `amount` is then deducted from the caller's
86      * allowance.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(
93         address sender,
94         address recipient,
95         uint256 amount
96     ) external returns (bool);
97 
98     /**
99      * @dev Emitted when `value` tokens are moved from one account (`from`) to
100      * another (`to`).
101      *
102      * Note that `value` may be zero.
103      */
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 
106     /**
107      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
108      * a call to {approve}. `value` is the new allowance.
109      */
110     event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/token/ERC20/extensions/IERC20Metadata.sol
114 
115 
116 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 
121 /**
122  * @dev Interface for the optional metadata functions from the ERC20 standard.
123  *
124  * _Available since v4.1._
125  */
126 interface IERC20Metadata is IERC20 {
127     /**
128      * @dev Returns the name of the token.
129      */
130     function name() external view returns (string memory);
131 
132     /**
133      * @dev Returns the symbol of the token.
134      */
135     function symbol() external view returns (string memory);
136 
137     /**
138      * @dev Returns the decimals places of the token.
139      */
140     function decimals() external view returns (uint8);
141 }
142 
143 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/token/ERC20/ERC20.sol
144 
145 
146 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
147 
148 pragma solidity ^0.8.0;
149 
150 
151 
152 
153 /**
154  * @dev Implementation of the {IERC20} interface.
155  *
156  * This implementation is agnostic to the way tokens are created. This means
157  * that a supply mechanism has to be added in a derived contract using {_mint}.
158  * For a generic mechanism see {ERC20PresetMinterPauser}.
159  *
160  * TIP: For a detailed writeup see our guide
161  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
162  * to implement supply mechanisms].
163  *
164  * We have followed general OpenZeppelin Contracts guidelines: functions revert
165  * instead returning `false` on failure. This behavior is nonetheless
166  * conventional and does not conflict with the expectations of ERC20
167  * applications.
168  *
169  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
170  * This allows applications to reconstruct the allowance for all accounts just
171  * by listening to said events. Other implementations of the EIP may not emit
172  * these events, as it isn't required by the specification.
173  *
174  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
175  * functions have been added to mitigate the well-known issues around setting
176  * allowances. See {IERC20-approve}.
177  */
178 contract ERC20 is Context, IERC20, IERC20Metadata {
179     mapping(address => uint256) private _balances;
180 
181     mapping(address => mapping(address => uint256)) private _allowances;
182 
183     uint256 private _totalSupply;
184 
185     string private _name;
186     string private _symbol;
187 
188     /**
189      * @dev Sets the values for {name} and {symbol}.
190      *
191      * The default value of {decimals} is 18. To select a different value for
192      * {decimals} you should overload it.
193      *
194      * All two of these values are immutable: they can only be set once during
195      * construction.
196      */
197     constructor(string memory name_, string memory symbol_) {
198         _name = name_;
199         _symbol = symbol_;
200     }
201 
202     /**
203      * @dev Returns the name of the token.
204      */
205     function name() public view virtual override returns (string memory) {
206         return _name;
207     }
208 
209     /**
210      * @dev Returns the symbol of the token, usually a shorter version of the
211      * name.
212      */
213     function symbol() public view virtual override returns (string memory) {
214         return _symbol;
215     }
216 
217     /**
218      * @dev Returns the number of decimals used to get its user representation.
219      * For example, if `decimals` equals `2`, a balance of `505` tokens should
220      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
221      *
222      * Tokens usually opt for a value of 18, imitating the relationship between
223      * Ether and Wei. This is the value {ERC20} uses, unless this function is
224      * overridden;
225      *
226      * NOTE: This information is only used for _display_ purposes: it in
227      * no way affects any of the arithmetic of the contract, including
228      * {IERC20-balanceOf} and {IERC20-transfer}.
229      */
230     function decimals() public view virtual override returns (uint8) {
231         return 18;
232     }
233 
234     /**
235      * @dev See {IERC20-totalSupply}.
236      */
237     function totalSupply() public view virtual override returns (uint256) {
238         return _totalSupply;
239     }
240 
241     /**
242      * @dev See {IERC20-balanceOf}.
243      */
244     function balanceOf(address account) public view virtual override returns (uint256) {
245         return _balances[account];
246     }
247 
248     /**
249      * @dev See {IERC20-transfer}.
250      *
251      * Requirements:
252      *
253      * - `recipient` cannot be the zero address.
254      * - the caller must have a balance of at least `amount`.
255      */
256     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
257         _transfer(_msgSender(), recipient, amount);
258         return true;
259     }
260 
261     /**
262      * @dev See {IERC20-allowance}.
263      */
264     function allowance(address owner, address spender) public view virtual override returns (uint256) {
265         return _allowances[owner][spender];
266     }
267 
268     /**
269      * @dev See {IERC20-approve}.
270      *
271      * Requirements:
272      *
273      * - `spender` cannot be the zero address.
274      */
275     function approve(address spender, uint256 amount) public virtual override returns (bool) {
276         _approve(_msgSender(), spender, amount);
277         return true;
278     }
279 
280     /**
281      * @dev See {IERC20-transferFrom}.
282      *
283      * Emits an {Approval} event indicating the updated allowance. This is not
284      * required by the EIP. See the note at the beginning of {ERC20}.
285      *
286      * Requirements:
287      *
288      * - `sender` and `recipient` cannot be the zero address.
289      * - `sender` must have a balance of at least `amount`.
290      * - the caller must have allowance for ``sender``'s tokens of at least
291      * `amount`.
292      */
293     function transferFrom(
294         address sender,
295         address recipient,
296         uint256 amount
297     ) public virtual override returns (bool) {
298         _transfer(sender, recipient, amount);
299 
300         uint256 currentAllowance = _allowances[sender][_msgSender()];
301         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
302         unchecked {
303             _approve(sender, _msgSender(), currentAllowance - amount);
304         }
305 
306         return true;
307     }
308 
309     /**
310      * @dev Atomically increases the allowance granted to `spender` by the caller.
311      *
312      * This is an alternative to {approve} that can be used as a mitigation for
313      * problems described in {IERC20-approve}.
314      *
315      * Emits an {Approval} event indicating the updated allowance.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      */
321     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
322         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
323         return true;
324     }
325 
326     /**
327      * @dev Atomically decreases the allowance granted to `spender` by the caller.
328      *
329      * This is an alternative to {approve} that can be used as a mitigation for
330      * problems described in {IERC20-approve}.
331      *
332      * Emits an {Approval} event indicating the updated allowance.
333      *
334      * Requirements:
335      *
336      * - `spender` cannot be the zero address.
337      * - `spender` must have allowance for the caller of at least
338      * `subtractedValue`.
339      */
340     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
341         uint256 currentAllowance = _allowances[_msgSender()][spender];
342         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
343         unchecked {
344             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
345         }
346 
347         return true;
348     }
349 
350     /**
351      * @dev Moves `amount` of tokens from `sender` to `recipient`.
352      *
353      * This internal function is equivalent to {transfer}, and can be used to
354      * e.g. implement automatic token fees, slashing mechanisms, etc.
355      *
356      * Emits a {Transfer} event.
357      *
358      * Requirements:
359      *
360      * - `sender` cannot be the zero address.
361      * - `recipient` cannot be the zero address.
362      * - `sender` must have a balance of at least `amount`.
363      */
364     function _transfer(
365         address sender,
366         address recipient,
367         uint256 amount
368     ) internal virtual {
369         require(sender != address(0), "ERC20: transfer from the zero address");
370         require(recipient != address(0), "ERC20: transfer to the zero address");
371 
372         _beforeTokenTransfer(sender, recipient, amount);
373 
374         uint256 senderBalance = _balances[sender];
375         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
376         unchecked {
377             _balances[sender] = senderBalance - amount;
378         }
379         _balances[recipient] += amount;
380 
381         emit Transfer(sender, recipient, amount);
382 
383         _afterTokenTransfer(sender, recipient, amount);
384     }
385 
386     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
387      * the total supply.
388      *
389      * Emits a {Transfer} event with `from` set to the zero address.
390      *
391      * Requirements:
392      *
393      * - `account` cannot be the zero address.
394      */
395     function _mint(address account, uint256 amount) internal virtual {
396         require(account != address(0), "ERC20: mint to the zero address");
397 
398         _beforeTokenTransfer(address(0), account, amount);
399 
400         _totalSupply += amount;
401         _balances[account] += amount;
402         emit Transfer(address(0), account, amount);
403 
404         _afterTokenTransfer(address(0), account, amount);
405     }
406 
407     /**
408      * @dev Destroys `amount` tokens from `account`, reducing the
409      * total supply.
410      *
411      * Emits a {Transfer} event with `to` set to the zero address.
412      *
413      * Requirements:
414      *
415      * - `account` cannot be the zero address.
416      * - `account` must have at least `amount` tokens.
417      */
418     function _burn(address account, uint256 amount) internal virtual {
419         require(account != address(0), "ERC20: burn from the zero address");
420 
421         _beforeTokenTransfer(account, address(0), amount);
422 
423         uint256 accountBalance = _balances[account];
424         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
425         unchecked {
426             _balances[account] = accountBalance - amount;
427         }
428         _totalSupply -= amount;
429 
430         emit Transfer(account, address(0), amount);
431 
432         _afterTokenTransfer(account, address(0), amount);
433     }
434 
435     /**
436      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
437      *
438      * This internal function is equivalent to `approve`, and can be used to
439      * e.g. set automatic allowances for certain subsystems, etc.
440      *
441      * Emits an {Approval} event.
442      *
443      * Requirements:
444      *
445      * - `owner` cannot be the zero address.
446      * - `spender` cannot be the zero address.
447      */
448     function _approve(
449         address owner,
450         address spender,
451         uint256 amount
452     ) internal virtual {
453         require(owner != address(0), "ERC20: approve from the zero address");
454         require(spender != address(0), "ERC20: approve to the zero address");
455 
456         _allowances[owner][spender] = amount;
457         emit Approval(owner, spender, amount);
458     }
459 
460     /**
461      * @dev Hook that is called before any transfer of tokens. This includes
462      * minting and burning.
463      *
464      * Calling conditions:
465      *
466      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
467      * will be transferred to `to`.
468      * - when `from` is zero, `amount` tokens will be minted for `to`.
469      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
470      * - `from` and `to` are never both zero.
471      *
472      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
473      */
474     function _beforeTokenTransfer(
475         address from,
476         address to,
477         uint256 amount
478     ) internal virtual {}
479 
480     /**
481      * @dev Hook that is called after any transfer of tokens. This includes
482      * minting and burning.
483      *
484      * Calling conditions:
485      *
486      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
487      * has been transferred to `to`.
488      * - when `from` is zero, `amount` tokens have been minted for `to`.
489      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
490      * - `from` and `to` are never both zero.
491      *
492      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
493      */
494     function _afterTokenTransfer(
495         address from,
496         address to,
497         uint256 amount
498     ) internal virtual {}
499 }
500 
501 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/utils/math/SafeMath.sol
502 
503 
504 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 // CAUTION
509 // This version of SafeMath should only be used with Solidity 0.8 or later,
510 // because it relies on the compiler's built in overflow checks.
511 
512 /**
513  * @dev Wrappers over Solidity's arithmetic operations.
514  *
515  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
516  * now has built in overflow checking.
517  */
518 library SafeMath {
519     /**
520      * @dev Returns the addition of two unsigned integers, with an overflow flag.
521      *
522      * _Available since v3.4._
523      */
524     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
525         unchecked {
526             uint256 c = a + b;
527             if (c < a) return (false, 0);
528             return (true, c);
529         }
530     }
531 
532     /**
533      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
534      *
535      * _Available since v3.4._
536      */
537     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
538         unchecked {
539             if (b > a) return (false, 0);
540             return (true, a - b);
541         }
542     }
543 
544     /**
545      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
546      *
547      * _Available since v3.4._
548      */
549     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
550         unchecked {
551             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
552             // benefit is lost if 'b' is also tested.
553             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
554             if (a == 0) return (true, 0);
555             uint256 c = a * b;
556             if (c / a != b) return (false, 0);
557             return (true, c);
558         }
559     }
560 
561     /**
562      * @dev Returns the division of two unsigned integers, with a division by zero flag.
563      *
564      * _Available since v3.4._
565      */
566     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
567         unchecked {
568             if (b == 0) return (false, 0);
569             return (true, a / b);
570         }
571     }
572 
573     /**
574      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
575      *
576      * _Available since v3.4._
577      */
578     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
579         unchecked {
580             if (b == 0) return (false, 0);
581             return (true, a % b);
582         }
583     }
584 
585     /**
586      * @dev Returns the addition of two unsigned integers, reverting on
587      * overflow.
588      *
589      * Counterpart to Solidity's `+` operator.
590      *
591      * Requirements:
592      *
593      * - Addition cannot overflow.
594      */
595     function add(uint256 a, uint256 b) internal pure returns (uint256) {
596         return a + b;
597     }
598 
599     /**
600      * @dev Returns the subtraction of two unsigned integers, reverting on
601      * overflow (when the result is negative).
602      *
603      * Counterpart to Solidity's `-` operator.
604      *
605      * Requirements:
606      *
607      * - Subtraction cannot overflow.
608      */
609     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
610         return a - b;
611     }
612 
613     /**
614      * @dev Returns the multiplication of two unsigned integers, reverting on
615      * overflow.
616      *
617      * Counterpart to Solidity's `*` operator.
618      *
619      * Requirements:
620      *
621      * - Multiplication cannot overflow.
622      */
623     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
624         return a * b;
625     }
626 
627     /**
628      * @dev Returns the integer division of two unsigned integers, reverting on
629      * division by zero. The result is rounded towards zero.
630      *
631      * Counterpart to Solidity's `/` operator.
632      *
633      * Requirements:
634      *
635      * - The divisor cannot be zero.
636      */
637     function div(uint256 a, uint256 b) internal pure returns (uint256) {
638         return a / b;
639     }
640 
641     /**
642      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
643      * reverting when dividing by zero.
644      *
645      * Counterpart to Solidity's `%` operator. This function uses a `revert`
646      * opcode (which leaves remaining gas untouched) while Solidity uses an
647      * invalid opcode to revert (consuming all remaining gas).
648      *
649      * Requirements:
650      *
651      * - The divisor cannot be zero.
652      */
653     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
654         return a % b;
655     }
656 
657     /**
658      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
659      * overflow (when the result is negative).
660      *
661      * CAUTION: This function is deprecated because it requires allocating memory for the error
662      * message unnecessarily. For custom revert reasons use {trySub}.
663      *
664      * Counterpart to Solidity's `-` operator.
665      *
666      * Requirements:
667      *
668      * - Subtraction cannot overflow.
669      */
670     function sub(
671         uint256 a,
672         uint256 b,
673         string memory errorMessage
674     ) internal pure returns (uint256) {
675         unchecked {
676             require(b <= a, errorMessage);
677             return a - b;
678         }
679     }
680 
681     /**
682      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
683      * division by zero. The result is rounded towards zero.
684      *
685      * Counterpart to Solidity's `/` operator. Note: this function uses a
686      * `revert` opcode (which leaves remaining gas untouched) while Solidity
687      * uses an invalid opcode to revert (consuming all remaining gas).
688      *
689      * Requirements:
690      *
691      * - The divisor cannot be zero.
692      */
693     function div(
694         uint256 a,
695         uint256 b,
696         string memory errorMessage
697     ) internal pure returns (uint256) {
698         unchecked {
699             require(b > 0, errorMessage);
700             return a / b;
701         }
702     }
703 
704     /**
705      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
706      * reverting with custom message when dividing by zero.
707      *
708      * CAUTION: This function is deprecated because it requires allocating memory for the error
709      * message unnecessarily. For custom revert reasons use {tryMod}.
710      *
711      * Counterpart to Solidity's `%` operator. This function uses a `revert`
712      * opcode (which leaves remaining gas untouched) while Solidity uses an
713      * invalid opcode to revert (consuming all remaining gas).
714      *
715      * Requirements:
716      *
717      * - The divisor cannot be zero.
718      */
719     function mod(
720         uint256 a,
721         uint256 b,
722         string memory errorMessage
723     ) internal pure returns (uint256) {
724         unchecked {
725             require(b > 0, errorMessage);
726             return a % b;
727         }
728     }
729 }
730 
731 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/utils/cryptography/MerkleProof.sol
732 
733 
734 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
735 
736 pragma solidity ^0.8.0;
737 
738 /**
739  * @dev These functions deal with verification of Merkle Trees proofs.
740  *
741  * The proofs can be generated using the JavaScript library
742  * https://github.com/miguelmota/merkletreejs[merkletreejs].
743  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
744  *
745  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
746  */
747 library MerkleProof {
748     /**
749      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
750      * defined by `root`. For this, a `proof` must be provided, containing
751      * sibling hashes on the branch from the leaf to the root of the tree. Each
752      * pair of leaves and each pair of pre-images are assumed to be sorted.
753      */
754     function verify(
755         bytes32[] memory proof,
756         bytes32 root,
757         bytes32 leaf
758     ) internal pure returns (bool) {
759         return processProof(proof, leaf) == root;
760     }
761 
762     /**
763      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
764      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
765      * hash matches the root of the tree. When processing the proof, the pairs
766      * of leafs & pre-images are assumed to be sorted.
767      *
768      * _Available since v4.4._
769      */
770     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
771         bytes32 computedHash = leaf;
772         for (uint256 i = 0; i < proof.length; i++) {
773             bytes32 proofElement = proof[i];
774             if (computedHash <= proofElement) {
775                 // Hash(current computed hash + current element of the proof)
776                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
777             } else {
778                 // Hash(current element of the proof + current computed hash)
779                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
780             }
781         }
782         return computedHash;
783     }
784 }
785 
786 // File: contracts/PulseDogecoin.sol
787 
788 
789 pragma solidity ^0.8.0;
790 
791 /*
792 
793  /$$$$$$$            /$$                     /$$$$$$$                                                    /$$          
794 | $$__  $$          | $$                    | $$__  $$                                                  |__/          
795 | $$  \ $$ /$$   /$$| $$  /$$$$$$$  /$$$$$$ | $$  \ $$  /$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$$  /$$$$$$  /$$ /$$$$$$$ 
796 | $$$$$$$/| $$  | $$| $$ /$$_____/ /$$__  $$| $$  | $$ /$$__  $$ /$$__  $$ /$$__  $$ /$$_____/ /$$__  $$| $$| $$__  $$
797 | $$____/ | $$  | $$| $$|  $$$$$$ | $$$$$$$$| $$  | $$| $$  \ $$| $$  \ $$| $$$$$$$$| $$      | $$  \ $$| $$| $$  \ $$
798 | $$      | $$  | $$| $$ \____  $$| $$_____/| $$  | $$| $$  | $$| $$  | $$| $$_____/| $$      | $$  | $$| $$| $$  | $$
799 | $$      |  $$$$$$/| $$ /$$$$$$$/|  $$$$$$$| $$$$$$$/|  $$$$$$/|  $$$$$$$|  $$$$$$$|  $$$$$$$|  $$$$$$/| $$| $$  | $$
800 |__/       \______/ |__/|_______/  \_______/|_______/  \______/  \____  $$ \_______/ \_______/ \______/ |__/|__/  |__/
801                                                                  /$$  \ $$                                            
802                                                                 |  $$$$$$/                                            
803                                                                  \______/    
804    _  _   _   _  _______   ___                 
805  _| || |_| | | ||  ___\ \ / (_)                
806 |_  __  _| |_| || |__  \ V / _  ___ __ _ _ __  
807  _| || |_|  _  ||  __| /   \| |/ __/ _` | '_ \ 
808 |_  __  _| | | || |___/ /^\ \ | (_| (_| | | | |
809   |_||_| \_| |_/\____/\/   \/_|\___\__,_|_| |_|
810 
811 */
812 
813 /// ============ Imports ============
814 
815 
816 
817 
818 contract PulseDogecoin is ERC20 {
819     using SafeMath for uint256;
820 
821     constructor() ERC20("PulseDogecoin", "PLSD")
822     {
823         _launchTime = block.timestamp;
824     }
825 
826     /// ============== Events ==============
827 
828     /// @dev Emitted after a successful token claim
829     /// @param to recipient of claim
830     /// @param amount of tokens claimed
831     event Claim(address indexed to, uint256 amount);
832 
833 
834     /// ============== Constants ==============
835 
836     /* Root hash of the HEX Stakers Merkle tree */
837     bytes32 internal constant MERKLE_TREE_ROOT = 0x8f4e1c18aa0323d567b9abc6cf64f9626e82ef1b41a404b3f48bfa92eecb9142;
838 
839     /* HEX Origin Address */
840     address internal constant HEX_ORIGIN_ADDR = 0x9A6a414D6F3497c05E3b1De90520765fA1E07c03;
841 
842     /* PulseDogecoin Benevolent Address */
843     address internal constant BENEVOLANT_ADDR = 0x7686640F09123394Cd8Dc3032e9927767aD89344;
844 
845     /* Smallest token amount = 1 DOGI; 10^12 = BASE_TOKEN_DECIMALS */
846     uint256 internal constant BASE_TOKEN_DECIMALS = 10**12;
847 
848     /* HEX Origin Address & PulseDogecoin Benevolent Address token payout per claim */
849     uint256 internal constant TOKEN_PAYOUT_IN_DOGI = 10 * BASE_TOKEN_DECIMALS;
850 
851     /* Length of airdrop claim phase */
852     uint256 internal constant CLAIM_PHASE_DAYS = 100;
853 
854     /// ============== Contract Deploy ==============
855 
856     /* Time of contract launch, set in constructor */
857     uint256 private _launchTime;
858 
859     /* Number of airdrop token claims, initial 0*/
860     uint256 private _numberOfClaims;
861 
862     /* HEX OA PLSD BA mint flag, initial false */
863     bool private _OaBaTokensMinted;
864 
865 
866     /// ============== Mutable Storage ==============
867 
868     /* Mapping of addresses who have claimed tokens */
869     mapping(address => bool) public hasClaimed;
870 
871 
872     /// ============== Functions ==============
873 
874     /*
875      * @dev PUBLIC FUNCTION: Overridden decimals function
876      * @return contract decimals
877      */
878     function decimals()
879         public
880         view
881         virtual
882         override
883         returns (uint8)
884     {
885         return 12;
886     }
887         
888     /* 
889      * @dev PUBLIC FUNCTION: External helper for returning the contract launch time 
890      * @return The contract launch time in epoch time
891      */
892     function launchTime()
893         public
894         view
895         returns (uint256)
896     {
897         return _launchTime;
898     }
899 
900     /*
901      * @dev PUBLIC FUNCTION: External helper for returning the number of airdrop claims 
902      * @return The total number of airdrop claims 
903      */
904     function numberOfClaims()
905         public
906         view
907         returns (uint256)
908     {
909         return _numberOfClaims;
910     }
911 
912     /*
913      * @dev PUBLIC FUNCTION: External helper for the current day number since launch time
914      * @return Current day number (zero-based)
915      */
916     function currentDay()
917         external
918         view
919         returns (uint256)
920     {
921         return _currentDay();
922     }
923 
924     function _currentDay()
925         internal
926         view
927         returns (uint256)
928     {
929         return (block.timestamp.sub(_launchTime)).div(1 days);
930     }
931 
932     /*
933      * @dev PUBLIC FUNCTION: Determine if an address and amount are eligble for the airdrop
934      * @param hexAddr HEX staker address
935      * @param plsdAmount PLSD token amount
936      * @param proof Merkle tree proof
937      * @return true or false
938      */
939     function hexAddressIsClaimable(address hexAddr, uint256 plsdAmount, bytes32[] calldata proof)
940         external
941         pure
942         returns (bool)
943     {
944         return _hexAddressIsClaimable(hexAddr, plsdAmount, proof);
945     }
946 
947     function _hexAddressIsClaimable(address hexAddr, uint256 plsdAmount, bytes32[] memory proof)
948         internal
949         pure
950         returns (bool)
951     {
952         bytes32 leaf = keccak256(abi.encodePacked(hexAddr, plsdAmount));
953         bool isValidLeaf = MerkleProof.verify(proof, MERKLE_TREE_ROOT, leaf);
954         return isValidLeaf;
955     }
956 
957     /*
958      * @dev PUBLIC FUNCTION: Mint HEX Origin & PLSD Benevolant Address tokens. Must be after claim phase has ended. Tokens can only be minted once.
959      */
960     function mintOaBaTokens() 
961         external
962     {
963         // Claim phase must be over
964         require(_currentDay() > CLAIM_PHASE_DAYS, "Claim phase has not ended.");
965 
966         // HEX OA & PLSD BA tokens must not have already been minted
967         require(!_OaBaTokensMinted, "HEX Origin Address & Benevolant Address Tokens have already been minted.");
968 
969         // HEX OA & PLSD BA tokens can only be minted once, set flag
970         _OaBaTokensMinted = true;
971 
972         // Determine the amount of tokens each address will receive and mint those tokens
973         uint256 tokenPayout = _numberOfClaims.mul(TOKEN_PAYOUT_IN_DOGI);
974         _mint(HEX_ORIGIN_ADDR, tokenPayout);
975         _mint(BENEVOLANT_ADDR, tokenPayout);
976     }
977 
978     /*
979      * @dev PUBLIC FUNCTION: External function to claim airdrop tokens. Must be before the end of the claim phase. 
980      * Tokens can only be minted once per unique address. The address must be within the airdrop set.
981      * @param to HEX staker address
982      * @param amount PLSD token amount
983      * @param proof Merkle tree proof
984      */
985     function claim(address to, uint256 amount, bytes32[] calldata proof)
986         external
987     {    
988         require(_currentDay() <= CLAIM_PHASE_DAYS, "Claim phase has ended.");
989         require(!hasClaimed[to], "Address has already claimed.");
990         require(_hexAddressIsClaimable(to, amount, proof), "HEX Address is not claimable.");
991 
992         // Set claim flag for address
993         hasClaimed[to] = true;
994 
995         // Increment the number of claims counter
996         _numberOfClaims = _numberOfClaims.add(1);
997 
998         // Mint tokens to address
999         _mint(to, amount);
1000 
1001         // Emit claim event
1002         emit Claim(to, amount);
1003     }
1004 }