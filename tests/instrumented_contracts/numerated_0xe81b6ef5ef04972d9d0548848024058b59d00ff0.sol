1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Trees proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  *
17  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
18  * hashing, or use a hash function other than keccak256 for hashing leaves.
19  * This is because the concatenation of a sorted pair of internal nodes in
20  * the merkle tree could be reinterpreted as a leaf value.
21  */
22 library MerkleProof {
23     /**
24      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
25      * defined by `root`. For this, a `proof` must be provided, containing
26      * sibling hashes on the branch from the leaf to the root of the tree. Each
27      * pair of leaves and each pair of pre-images are assumed to be sorted.
28      */
29     function verify(
30         bytes32[] memory proof,
31         bytes32 root,
32         bytes32 leaf
33     ) internal pure returns (bool) {
34         return processProof(proof, leaf) == root;
35     }
36 
37     /**
38      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
39      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
40      * hash matches the root of the tree. When processing the proof, the pairs
41      * of leafs & pre-images are assumed to be sorted.
42      *
43      * _Available since v4.4._
44      */
45     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
46         bytes32 computedHash = leaf;
47         for (uint256 i = 0; i < proof.length; i++) {
48             bytes32 proofElement = proof[i];
49             if (computedHash <= proofElement) {
50                 // Hash(current computed hash + current element of the proof)
51                 computedHash = _efficientHash(computedHash, proofElement);
52             } else {
53                 // Hash(current element of the proof + current computed hash)
54                 computedHash = _efficientHash(proofElement, computedHash);
55             }
56         }
57         return computedHash;
58     }
59 
60     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
61         assembly {
62             mstore(0x00, a)
63             mstore(0x20, b)
64             value := keccak256(0x00, 0x40)
65         }
66     }
67 }
68 
69 // File: @openzeppelin/contracts/utils/Context.sol
70 
71 
72 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev Provides information about the current execution context, including the
78  * sender of the transaction and its data. While these are generally available
79  * via msg.sender and msg.data, they should not be accessed in such a direct
80  * manner, since when dealing with meta-transactions the account sending and
81  * paying for execution may not be the actual sender (as far as an application
82  * is concerned).
83  *
84  * This contract is only required for intermediate, library-like contracts.
85  */
86 abstract contract Context {
87     function _msgSender() internal view virtual returns (address) {
88         return msg.sender;
89     }
90 
91     function _msgData() internal view virtual returns (bytes calldata) {
92         return msg.data;
93     }
94 }
95 
96 // File: @openzeppelin/contracts/access/Ownable.sol
97 
98 
99 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
100 
101 pragma solidity ^0.8.0;
102 
103 
104 /**
105  * @dev Contract module which provides a basic access control mechanism, where
106  * there is an account (an owner) that can be granted exclusive access to
107  * specific functions.
108  *
109  * By default, the owner account will be the one that deploys the contract. This
110  * can later be changed with {transferOwnership}.
111  *
112  * This module is used through inheritance. It will make available the modifier
113  * `onlyOwner`, which can be applied to your functions to restrict their use to
114  * the owner.
115  */
116 abstract contract Ownable is Context {
117     address private _owner;
118 
119     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
120 
121     /**
122      * @dev Initializes the contract setting the deployer as the initial owner.
123      */
124     constructor() {
125         _transferOwnership(_msgSender());
126     }
127 
128     /**
129      * @dev Returns the address of the current owner.
130      */
131     function owner() public view virtual returns (address) {
132         return _owner;
133     }
134 
135     /**
136      * @dev Throws if called by any account other than the owner.
137      */
138     modifier onlyOwner() {
139         require(owner() == _msgSender(), "Ownable: caller is not the owner");
140         _;
141     }
142 
143     /**
144      * @dev Leaves the contract without owner. It will not be possible to call
145      * `onlyOwner` functions anymore. Can only be called by the current owner.
146      *
147      * NOTE: Renouncing ownership will leave the contract without an owner,
148      * thereby removing any functionality that is only available to the owner.
149      */
150     function renounceOwnership() public virtual onlyOwner {
151         _transferOwnership(address(0));
152     }
153 
154     /**
155      * @dev Transfers ownership of the contract to a new account (`newOwner`).
156      * Can only be called by the current owner.
157      */
158     function transferOwnership(address newOwner) public virtual onlyOwner {
159         require(newOwner != address(0), "Ownable: new owner is the zero address");
160         _transferOwnership(newOwner);
161     }
162 
163     /**
164      * @dev Transfers ownership of the contract to a new account (`newOwner`).
165      * Internal function without access restriction.
166      */
167     function _transferOwnership(address newOwner) internal virtual {
168         address oldOwner = _owner;
169         _owner = newOwner;
170         emit OwnershipTransferred(oldOwner, newOwner);
171     }
172 }
173 
174 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
175 
176 
177 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @dev Interface of the ERC20 standard as defined in the EIP.
183  */
184 interface IERC20 {
185     /**
186      * @dev Emitted when `value` tokens are moved from one account (`from`) to
187      * another (`to`).
188      *
189      * Note that `value` may be zero.
190      */
191     event Transfer(address indexed from, address indexed to, uint256 value);
192 
193     /**
194      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
195      * a call to {approve}. `value` is the new allowance.
196      */
197     event Approval(address indexed owner, address indexed spender, uint256 value);
198 
199     /**
200      * @dev Returns the amount of tokens in existence.
201      */
202     function totalSupply() external view returns (uint256);
203 
204     /**
205      * @dev Returns the amount of tokens owned by `account`.
206      */
207     function balanceOf(address account) external view returns (uint256);
208 
209     /**
210      * @dev Moves `amount` tokens from the caller's account to `to`.
211      *
212      * Returns a boolean value indicating whether the operation succeeded.
213      *
214      * Emits a {Transfer} event.
215      */
216     function transfer(address to, uint256 amount) external returns (bool);
217 
218     /**
219      * @dev Returns the remaining number of tokens that `spender` will be
220      * allowed to spend on behalf of `owner` through {transferFrom}. This is
221      * zero by default.
222      *
223      * This value changes when {approve} or {transferFrom} are called.
224      */
225     function allowance(address owner, address spender) external view returns (uint256);
226 
227     /**
228      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
229      *
230      * Returns a boolean value indicating whether the operation succeeded.
231      *
232      * IMPORTANT: Beware that changing an allowance with this method brings the risk
233      * that someone may use both the old and the new allowance by unfortunate
234      * transaction ordering. One possible solution to mitigate this race
235      * condition is to first reduce the spender's allowance to 0 and set the
236      * desired value afterwards:
237      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238      *
239      * Emits an {Approval} event.
240      */
241     function approve(address spender, uint256 amount) external returns (bool);
242 
243     /**
244      * @dev Moves `amount` tokens from `from` to `to` using the
245      * allowance mechanism. `amount` is then deducted from the caller's
246      * allowance.
247      *
248      * Returns a boolean value indicating whether the operation succeeded.
249      *
250      * Emits a {Transfer} event.
251      */
252     function transferFrom(
253         address from,
254         address to,
255         uint256 amount
256     ) external returns (bool);
257 }
258 
259 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
260 
261 
262 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
263 
264 pragma solidity ^0.8.0;
265 
266 
267 /**
268  * @dev Interface for the optional metadata functions from the ERC20 standard.
269  *
270  * _Available since v4.1._
271  */
272 interface IERC20Metadata is IERC20 {
273     /**
274      * @dev Returns the name of the token.
275      */
276     function name() external view returns (string memory);
277 
278     /**
279      * @dev Returns the symbol of the token.
280      */
281     function symbol() external view returns (string memory);
282 
283     /**
284      * @dev Returns the decimals places of the token.
285      */
286     function decimals() external view returns (uint8);
287 }
288 
289 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
290 
291 
292 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
293 
294 pragma solidity ^0.8.0;
295 
296 
297 
298 
299 /**
300  * @dev Implementation of the {IERC20} interface.
301  *
302  * This implementation is agnostic to the way tokens are created. This means
303  * that a supply mechanism has to be added in a derived contract using {_mint}.
304  * For a generic mechanism see {ERC20PresetMinterPauser}.
305  *
306  * TIP: For a detailed writeup see our guide
307  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
308  * to implement supply mechanisms].
309  *
310  * We have followed general OpenZeppelin Contracts guidelines: functions revert
311  * instead returning `false` on failure. This behavior is nonetheless
312  * conventional and does not conflict with the expectations of ERC20
313  * applications.
314  *
315  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
316  * This allows applications to reconstruct the allowance for all accounts just
317  * by listening to said events. Other implementations of the EIP may not emit
318  * these events, as it isn't required by the specification.
319  *
320  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
321  * functions have been added to mitigate the well-known issues around setting
322  * allowances. See {IERC20-approve}.
323  */
324 contract ERC20 is Context, IERC20, IERC20Metadata {
325     mapping(address => uint256) private _balances;
326 
327     mapping(address => mapping(address => uint256)) private _allowances;
328 
329     uint256 private _totalSupply;
330 
331     string private _name;
332     string private _symbol;
333 
334     /**
335      * @dev Sets the values for {name} and {symbol}.
336      *
337      * The default value of {decimals} is 18. To select a different value for
338      * {decimals} you should overload it.
339      *
340      * All two of these values are immutable: they can only be set once during
341      * construction.
342      */
343     constructor(string memory name_, string memory symbol_) {
344         _name = name_;
345         _symbol = symbol_;
346     }
347 
348     /**
349      * @dev Returns the name of the token.
350      */
351     function name() public view virtual override returns (string memory) {
352         return _name;
353     }
354 
355     /**
356      * @dev Returns the symbol of the token, usually a shorter version of the
357      * name.
358      */
359     function symbol() public view virtual override returns (string memory) {
360         return _symbol;
361     }
362 
363     /**
364      * @dev Returns the number of decimals used to get its user representation.
365      * For example, if `decimals` equals `2`, a balance of `505` tokens should
366      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
367      *
368      * Tokens usually opt for a value of 18, imitating the relationship between
369      * Ether and Wei. This is the value {ERC20} uses, unless this function is
370      * overridden;
371      *
372      * NOTE: This information is only used for _display_ purposes: it in
373      * no way affects any of the arithmetic of the contract, including
374      * {IERC20-balanceOf} and {IERC20-transfer}.
375      */
376     function decimals() public view virtual override returns (uint8) {
377         return 18;
378     }
379 
380     /**
381      * @dev See {IERC20-totalSupply}.
382      */
383     function totalSupply() public view virtual override returns (uint256) {
384         return _totalSupply;
385     }
386 
387     /**
388      * @dev See {IERC20-balanceOf}.
389      */
390     function balanceOf(address account) public view virtual override returns (uint256) {
391         return _balances[account];
392     }
393 
394     /**
395      * @dev See {IERC20-transfer}.
396      *
397      * Requirements:
398      *
399      * - `to` cannot be the zero address.
400      * - the caller must have a balance of at least `amount`.
401      */
402     function transfer(address to, uint256 amount) public virtual override returns (bool) {
403         address owner = _msgSender();
404         _transfer(owner, to, amount);
405         return true;
406     }
407 
408     /**
409      * @dev See {IERC20-allowance}.
410      */
411     function allowance(address owner, address spender) public view virtual override returns (uint256) {
412         return _allowances[owner][spender];
413     }
414 
415     /**
416      * @dev See {IERC20-approve}.
417      *
418      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
419      * `transferFrom`. This is semantically equivalent to an infinite approval.
420      *
421      * Requirements:
422      *
423      * - `spender` cannot be the zero address.
424      */
425     function approve(address spender, uint256 amount) public virtual override returns (bool) {
426         address owner = _msgSender();
427         _approve(owner, spender, amount);
428         return true;
429     }
430 
431     /**
432      * @dev See {IERC20-transferFrom}.
433      *
434      * Emits an {Approval} event indicating the updated allowance. This is not
435      * required by the EIP. See the note at the beginning of {ERC20}.
436      *
437      * NOTE: Does not update the allowance if the current allowance
438      * is the maximum `uint256`.
439      *
440      * Requirements:
441      *
442      * - `from` and `to` cannot be the zero address.
443      * - `from` must have a balance of at least `amount`.
444      * - the caller must have allowance for ``from``'s tokens of at least
445      * `amount`.
446      */
447     function transferFrom(
448         address from,
449         address to,
450         uint256 amount
451     ) public virtual override returns (bool) {
452         address spender = _msgSender();
453         _spendAllowance(from, spender, amount);
454         _transfer(from, to, amount);
455         return true;
456     }
457 
458     /**
459      * @dev Atomically increases the allowance granted to `spender` by the caller.
460      *
461      * This is an alternative to {approve} that can be used as a mitigation for
462      * problems described in {IERC20-approve}.
463      *
464      * Emits an {Approval} event indicating the updated allowance.
465      *
466      * Requirements:
467      *
468      * - `spender` cannot be the zero address.
469      */
470     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
471         address owner = _msgSender();
472         _approve(owner, spender, allowance(owner, spender) + addedValue);
473         return true;
474     }
475 
476     /**
477      * @dev Atomically decreases the allowance granted to `spender` by the caller.
478      *
479      * This is an alternative to {approve} that can be used as a mitigation for
480      * problems described in {IERC20-approve}.
481      *
482      * Emits an {Approval} event indicating the updated allowance.
483      *
484      * Requirements:
485      *
486      * - `spender` cannot be the zero address.
487      * - `spender` must have allowance for the caller of at least
488      * `subtractedValue`.
489      */
490     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
491         address owner = _msgSender();
492         uint256 currentAllowance = allowance(owner, spender);
493         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
494         unchecked {
495             _approve(owner, spender, currentAllowance - subtractedValue);
496         }
497 
498         return true;
499     }
500 
501     /**
502      * @dev Moves `amount` of tokens from `sender` to `recipient`.
503      *
504      * This internal function is equivalent to {transfer}, and can be used to
505      * e.g. implement automatic token fees, slashing mechanisms, etc.
506      *
507      * Emits a {Transfer} event.
508      *
509      * Requirements:
510      *
511      * - `from` cannot be the zero address.
512      * - `to` cannot be the zero address.
513      * - `from` must have a balance of at least `amount`.
514      */
515     function _transfer(
516         address from,
517         address to,
518         uint256 amount
519     ) internal virtual {
520         require(from != address(0), "ERC20: transfer from the zero address");
521         require(to != address(0), "ERC20: transfer to the zero address");
522 
523         _beforeTokenTransfer(from, to, amount);
524 
525         uint256 fromBalance = _balances[from];
526         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
527         unchecked {
528             _balances[from] = fromBalance - amount;
529         }
530         _balances[to] += amount;
531 
532         emit Transfer(from, to, amount);
533 
534         _afterTokenTransfer(from, to, amount);
535     }
536 
537     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
538      * the total supply.
539      *
540      * Emits a {Transfer} event with `from` set to the zero address.
541      *
542      * Requirements:
543      *
544      * - `account` cannot be the zero address.
545      */
546     function _mint(address account, uint256 amount) internal virtual {
547         require(account != address(0), "ERC20: mint to the zero address");
548 
549         _beforeTokenTransfer(address(0), account, amount);
550 
551         _totalSupply += amount;
552         _balances[account] += amount;
553         emit Transfer(address(0), account, amount);
554 
555         _afterTokenTransfer(address(0), account, amount);
556     }
557 
558     /**
559      * @dev Destroys `amount` tokens from `account`, reducing the
560      * total supply.
561      *
562      * Emits a {Transfer} event with `to` set to the zero address.
563      *
564      * Requirements:
565      *
566      * - `account` cannot be the zero address.
567      * - `account` must have at least `amount` tokens.
568      */
569     function _burn(address account, uint256 amount) internal virtual {
570         require(account != address(0), "ERC20: burn from the zero address");
571 
572         _beforeTokenTransfer(account, address(0), amount);
573 
574         uint256 accountBalance = _balances[account];
575         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
576         unchecked {
577             _balances[account] = accountBalance - amount;
578         }
579         _totalSupply -= amount;
580 
581         emit Transfer(account, address(0), amount);
582 
583         _afterTokenTransfer(account, address(0), amount);
584     }
585 
586     /**
587      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
588      *
589      * This internal function is equivalent to `approve`, and can be used to
590      * e.g. set automatic allowances for certain subsystems, etc.
591      *
592      * Emits an {Approval} event.
593      *
594      * Requirements:
595      *
596      * - `owner` cannot be the zero address.
597      * - `spender` cannot be the zero address.
598      */
599     function _approve(
600         address owner,
601         address spender,
602         uint256 amount
603     ) internal virtual {
604         require(owner != address(0), "ERC20: approve from the zero address");
605         require(spender != address(0), "ERC20: approve to the zero address");
606 
607         _allowances[owner][spender] = amount;
608         emit Approval(owner, spender, amount);
609     }
610 
611     /**
612      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
613      *
614      * Does not update the allowance amount in case of infinite allowance.
615      * Revert if not enough allowance is available.
616      *
617      * Might emit an {Approval} event.
618      */
619     function _spendAllowance(
620         address owner,
621         address spender,
622         uint256 amount
623     ) internal virtual {
624         uint256 currentAllowance = allowance(owner, spender);
625         if (currentAllowance != type(uint256).max) {
626             require(currentAllowance >= amount, "ERC20: insufficient allowance");
627             unchecked {
628                 _approve(owner, spender, currentAllowance - amount);
629             }
630         }
631     }
632 
633     /**
634      * @dev Hook that is called before any transfer of tokens. This includes
635      * minting and burning.
636      *
637      * Calling conditions:
638      *
639      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
640      * will be transferred to `to`.
641      * - when `from` is zero, `amount` tokens will be minted for `to`.
642      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
643      * - `from` and `to` are never both zero.
644      *
645      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
646      */
647     function _beforeTokenTransfer(
648         address from,
649         address to,
650         uint256 amount
651     ) internal virtual {}
652 
653     /**
654      * @dev Hook that is called after any transfer of tokens. This includes
655      * minting and burning.
656      *
657      * Calling conditions:
658      *
659      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
660      * has been transferred to `to`.
661      * - when `from` is zero, `amount` tokens have been minted for `to`.
662      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
663      * - `from` and `to` are never both zero.
664      *
665      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
666      */
667     function _afterTokenTransfer(
668         address from,
669         address to,
670         uint256 amount
671     ) internal virtual {}
672 }
673 
674 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
675 
676 
677 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
678 
679 pragma solidity ^0.8.0;
680 
681 
682 
683 /**
684  * @dev Extension of {ERC20} that allows token holders to destroy both their own
685  * tokens and those that they have an allowance for, in a way that can be
686  * recognized off-chain (via event analysis).
687  */
688 abstract contract ERC20Burnable is Context, ERC20 {
689     /**
690      * @dev Destroys `amount` tokens from the caller.
691      *
692      * See {ERC20-_burn}.
693      */
694     function burn(uint256 amount) public virtual {
695         _burn(_msgSender(), amount);
696     }
697 
698     /**
699      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
700      * allowance.
701      *
702      * See {ERC20-_burn} and {ERC20-allowance}.
703      *
704      * Requirements:
705      *
706      * - the caller must have allowance for ``accounts``'s tokens of at least
707      * `amount`.
708      */
709     function burnFrom(address account, uint256 amount) public virtual {
710         _spendAllowance(account, _msgSender(), amount);
711         _burn(account, amount);
712     }
713 }
714 
715 // File: contracts/DEYE.sol
716 
717 
718 // Author: Mas C. (Project Dark Eye)
719 pragma solidity ^0.8.0;
720 
721 
722 
723 
724 contract DEYE is ERC20Burnable, Ownable {
725     // Max Supply: 10,000,000,000, with 18 decimals.
726     uint256 public constant MAX_SUPPLY = 1e28;
727 
728     uint256 public totalMinted;
729 
730     bytes32 public allowanceMerkleRoot;
731 
732     bool public claimEnabled = false;
733 
734     // Claimed tokens per address.
735     mapping(address => uint256) public claimed;
736 
737     // Addresses that are allowed to call owner only functions.
738     mapping(address => bool) public managers;
739 
740     constructor(bytes32 merkleRoot) ERC20("Project Dark Eye Token", "DEYE") {
741         allowanceMerkleRoot = merkleRoot;
742         totalMinted = 0;
743     }
744 
745     function claim(uint256 amount, uint256 allowance, bytes32[] calldata proof) public {
746         require(claimEnabled, "Claim not enabled");
747         require(verifyAllowance(msg.sender, allowance, proof), "Failed allowance verification");
748         require(claimed[msg.sender] + amount <= allowance, "Request higher than allowance");
749         require(totalMinted + amount <= MAX_SUPPLY, "Request higher than max supply");
750 
751         claimed[msg.sender] = claimed[msg.sender] + amount;
752         totalMinted = totalMinted + amount;
753         _mint(msg.sender, amount * 10**uint(decimals()));
754     }
755 
756     function getQuantityClaimed(address claimee) public view returns (uint256) {
757         return claimed[claimee];
758     }
759 
760     function verifyAllowance(address account, uint256 allowance, bytes32[] calldata proof) public view returns (bool) {
761         return MerkleProof.verify(proof, allowanceMerkleRoot, generateAllowanceMerkleLeaf(account, allowance));
762     }
763 
764     function generateAllowanceMerkleLeaf(address account, uint256 allowance) public pure returns (bytes32) {
765         return keccak256(abi.encodePacked(account, allowance));
766     }
767 
768     // Owner Only Functions.
769 
770     function setAllowanceMerkleRoot(bytes32 merkleRoot) public onlyOwner {
771         require(merkleRoot != allowanceMerkleRoot,"merkleRoot is the same as previous value");
772         allowanceMerkleRoot = merkleRoot;
773     }
774 
775     function teamMint(address account, uint256 amount) public onlyOwner {
776         require(totalMinted + amount <= MAX_SUPPLY, "Request higher than max supply");
777         totalMinted = totalMinted + amount;
778         _mint(account, amount * 10**uint(decimals()));
779     }
780 
781     function setManagers(address[] memory addresses, bool[] memory allowedValues) public onlyOwner {
782         require(addresses.length == allowedValues.length, "addresses does not match allowedValues length");
783         for (uint256 i = 0; i < addresses.length; i++) {
784             managers[addresses[i]] = allowedValues[i];
785         }
786     }
787 
788     function isManager(address addr) public view returns (bool) {
789         return managers[addr];
790     }
791 
792     function setAllowanceMerkleRootByManager(bytes32 merkleRoot) public {
793         require(managers[msg.sender], "Caller not allowed");
794         require(merkleRoot != allowanceMerkleRoot,"merkleRoot is the same as previous value");
795         allowanceMerkleRoot = merkleRoot;
796     }
797 
798     function teamMintByManager(address account, uint256 amount) public {
799         require(managers[msg.sender], "Caller not allowed");
800         require(totalMinted + amount <= MAX_SUPPLY, "Request higher than max supply");
801         totalMinted = totalMinted + amount;
802         _mint(account, amount * 10**uint(decimals()));
803     }
804 
805     function setClaimEnabled(bool enabled) public onlyOwner {
806         claimEnabled = enabled;
807     }
808 }