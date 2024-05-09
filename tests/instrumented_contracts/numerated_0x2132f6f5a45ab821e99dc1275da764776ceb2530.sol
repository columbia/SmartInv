1 // SPDX-License-Identifier: MIT
2 // File: interfaces/IMerkleDistributor.sol
3 
4 
5 pragma solidity ^0.8.0;
6 
7 // Allows anyone to claim a token if they exist in a merkle root.
8 interface IMerkleDistributor {
9     // Returns the address of the token distributed by this contract.
10     function token() external view returns (address);
11     // Returns the merkle root of the merkle tree containing account balances available to claim.
12     function merkleRoot() external view returns (bytes32);
13     // Returns true if the index has been marked claimed.
14     function isClaimed(uint256 index) external view returns (bool);
15     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
16     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external;
17 
18     // This event is triggered whenever a call to #claim succeeds.
19     event Claimed(uint256 index, address account, uint256 amount);
20 }
21 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
22 
23 
24 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
25 
26 pragma solidity ^0.8.0;
27 
28 /**
29  * @dev These functions deal with verification of Merkle Trees proofs.
30  *
31  * The proofs can be generated using the JavaScript library
32  * https://github.com/miguelmota/merkletreejs[merkletreejs].
33  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
34  *
35  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
36  */
37 library MerkleProof {
38     /**
39      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
40      * defined by `root`. For this, a `proof` must be provided, containing
41      * sibling hashes on the branch from the leaf to the root of the tree. Each
42      * pair of leaves and each pair of pre-images are assumed to be sorted.
43      */
44     function verify(
45         bytes32[] memory proof,
46         bytes32 root,
47         bytes32 leaf
48     ) internal pure returns (bool) {
49         return processProof(proof, leaf) == root;
50     }
51 
52     /**
53      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
54      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
55      * hash matches the root of the tree. When processing the proof, the pairs
56      * of leafs & pre-images are assumed to be sorted.
57      *
58      * _Available since v4.4._
59      */
60     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
61         bytes32 computedHash = leaf;
62         for (uint256 i = 0; i < proof.length; i++) {
63             bytes32 proofElement = proof[i];
64             if (computedHash <= proofElement) {
65                 // Hash(current computed hash + current element of the proof)
66                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
67             } else {
68                 // Hash(current element of the proof + current computed hash)
69                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
70             }
71         }
72         return computedHash;
73     }
74 }
75 
76 // File: @openzeppelin/contracts/utils/Context.sol
77 
78 
79 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
80 
81 pragma solidity ^0.8.0;
82 
83 /**
84  * @dev Provides information about the current execution context, including the
85  * sender of the transaction and its data. While these are generally available
86  * via msg.sender and msg.data, they should not be accessed in such a direct
87  * manner, since when dealing with meta-transactions the account sending and
88  * paying for execution may not be the actual sender (as far as an application
89  * is concerned).
90  *
91  * This contract is only required for intermediate, library-like contracts.
92  */
93 abstract contract Context {
94     function _msgSender() internal view virtual returns (address) {
95         return msg.sender;
96     }
97 
98     function _msgData() internal view virtual returns (bytes calldata) {
99         return msg.data;
100     }
101 }
102 
103 // File: @openzeppelin/contracts/access/Ownable.sol
104 
105 
106 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
107 
108 pragma solidity ^0.8.0;
109 
110 
111 /**
112  * @dev Contract module which provides a basic access control mechanism, where
113  * there is an account (an owner) that can be granted exclusive access to
114  * specific functions.
115  *
116  * By default, the owner account will be the one that deploys the contract. This
117  * can later be changed with {transferOwnership}.
118  *
119  * This module is used through inheritance. It will make available the modifier
120  * `onlyOwner`, which can be applied to your functions to restrict their use to
121  * the owner.
122  */
123 abstract contract Ownable is Context {
124     address private _owner;
125 
126     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
127 
128     /**
129      * @dev Initializes the contract setting the deployer as the initial owner.
130      */
131     constructor() {
132         _transferOwnership(_msgSender());
133     }
134 
135     /**
136      * @dev Returns the address of the current owner.
137      */
138     function owner() public view virtual returns (address) {
139         return _owner;
140     }
141 
142     /**
143      * @dev Throws if called by any account other than the owner.
144      */
145     modifier onlyOwner() {
146         require(owner() == _msgSender(), "Ownable: caller is not the owner");
147         _;
148     }
149 
150     /**
151      * @dev Leaves the contract without owner. It will not be possible to call
152      * `onlyOwner` functions anymore. Can only be called by the current owner.
153      *
154      * NOTE: Renouncing ownership will leave the contract without an owner,
155      * thereby removing any functionality that is only available to the owner.
156      */
157     function renounceOwnership() public virtual onlyOwner {
158         _transferOwnership(address(0));
159     }
160 
161     /**
162      * @dev Transfers ownership of the contract to a new account (`newOwner`).
163      * Can only be called by the current owner.
164      */
165     function transferOwnership(address newOwner) public virtual onlyOwner {
166         require(newOwner != address(0), "Ownable: new owner is the zero address");
167         _transferOwnership(newOwner);
168     }
169 
170     /**
171      * @dev Transfers ownership of the contract to a new account (`newOwner`).
172      * Internal function without access restriction.
173      */
174     function _transferOwnership(address newOwner) internal virtual {
175         address oldOwner = _owner;
176         _owner = newOwner;
177         emit OwnershipTransferred(oldOwner, newOwner);
178     }
179 }
180 
181 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
182 
183 
184 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
185 
186 pragma solidity ^0.8.0;
187 
188 /**
189  * @dev Interface of the ERC20 standard as defined in the EIP.
190  */
191 interface IERC20 {
192     /**
193      * @dev Returns the amount of tokens in existence.
194      */
195     function totalSupply() external view returns (uint256);
196 
197     /**
198      * @dev Returns the amount of tokens owned by `account`.
199      */
200     function balanceOf(address account) external view returns (uint256);
201 
202     /**
203      * @dev Moves `amount` tokens from the caller's account to `recipient`.
204      *
205      * Returns a boolean value indicating whether the operation succeeded.
206      *
207      * Emits a {Transfer} event.
208      */
209     function transfer(address recipient, uint256 amount) external returns (bool);
210 
211     /**
212      * @dev Returns the remaining number of tokens that `spender` will be
213      * allowed to spend on behalf of `owner` through {transferFrom}. This is
214      * zero by default.
215      *
216      * This value changes when {approve} or {transferFrom} are called.
217      */
218     function allowance(address owner, address spender) external view returns (uint256);
219 
220     /**
221      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
222      *
223      * Returns a boolean value indicating whether the operation succeeded.
224      *
225      * IMPORTANT: Beware that changing an allowance with this method brings the risk
226      * that someone may use both the old and the new allowance by unfortunate
227      * transaction ordering. One possible solution to mitigate this race
228      * condition is to first reduce the spender's allowance to 0 and set the
229      * desired value afterwards:
230      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231      *
232      * Emits an {Approval} event.
233      */
234     function approve(address spender, uint256 amount) external returns (bool);
235 
236     /**
237      * @dev Moves `amount` tokens from `sender` to `recipient` using the
238      * allowance mechanism. `amount` is then deducted from the caller's
239      * allowance.
240      *
241      * Returns a boolean value indicating whether the operation succeeded.
242      *
243      * Emits a {Transfer} event.
244      */
245     function transferFrom(
246         address sender,
247         address recipient,
248         uint256 amount
249     ) external returns (bool);
250 
251     /**
252      * @dev Emitted when `value` tokens are moved from one account (`from`) to
253      * another (`to`).
254      *
255      * Note that `value` may be zero.
256      */
257     event Transfer(address indexed from, address indexed to, uint256 value);
258 
259     /**
260      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
261      * a call to {approve}. `value` is the new allowance.
262      */
263     event Approval(address indexed owner, address indexed spender, uint256 value);
264 }
265 
266 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
267 
268 
269 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
270 
271 pragma solidity ^0.8.0;
272 
273 
274 /**
275  * @dev Interface for the optional metadata functions from the ERC20 standard.
276  *
277  * _Available since v4.1._
278  */
279 interface IERC20Metadata is IERC20 {
280     /**
281      * @dev Returns the name of the token.
282      */
283     function name() external view returns (string memory);
284 
285     /**
286      * @dev Returns the symbol of the token.
287      */
288     function symbol() external view returns (string memory);
289 
290     /**
291      * @dev Returns the decimals places of the token.
292      */
293     function decimals() external view returns (uint8);
294 }
295 
296 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
297 
298 
299 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
300 
301 pragma solidity ^0.8.0;
302 
303 
304 
305 
306 /**
307  * @dev Implementation of the {IERC20} interface.
308  *
309  * This implementation is agnostic to the way tokens are created. This means
310  * that a supply mechanism has to be added in a derived contract using {_mint}.
311  * For a generic mechanism see {ERC20PresetMinterPauser}.
312  *
313  * TIP: For a detailed writeup see our guide
314  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
315  * to implement supply mechanisms].
316  *
317  * We have followed general OpenZeppelin Contracts guidelines: functions revert
318  * instead returning `false` on failure. This behavior is nonetheless
319  * conventional and does not conflict with the expectations of ERC20
320  * applications.
321  *
322  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
323  * This allows applications to reconstruct the allowance for all accounts just
324  * by listening to said events. Other implementations of the EIP may not emit
325  * these events, as it isn't required by the specification.
326  *
327  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
328  * functions have been added to mitigate the well-known issues around setting
329  * allowances. See {IERC20-approve}.
330  */
331 contract ERC20 is Context, IERC20, IERC20Metadata {
332     mapping(address => uint256) private _balances;
333 
334     mapping(address => mapping(address => uint256)) private _allowances;
335 
336     uint256 private _totalSupply;
337 
338     string private _name;
339     string private _symbol;
340 
341     /**
342      * @dev Sets the values for {name} and {symbol}.
343      *
344      * The default value of {decimals} is 18. To select a different value for
345      * {decimals} you should overload it.
346      *
347      * All two of these values are immutable: they can only be set once during
348      * construction.
349      */
350     constructor(string memory name_, string memory symbol_) {
351         _name = name_;
352         _symbol = symbol_;
353     }
354 
355     /**
356      * @dev Returns the name of the token.
357      */
358     function name() public view virtual override returns (string memory) {
359         return _name;
360     }
361 
362     /**
363      * @dev Returns the symbol of the token, usually a shorter version of the
364      * name.
365      */
366     function symbol() public view virtual override returns (string memory) {
367         return _symbol;
368     }
369 
370     /**
371      * @dev Returns the number of decimals used to get its user representation.
372      * For example, if `decimals` equals `2`, a balance of `505` tokens should
373      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
374      *
375      * Tokens usually opt for a value of 18, imitating the relationship between
376      * Ether and Wei. This is the value {ERC20} uses, unless this function is
377      * overridden;
378      *
379      * NOTE: This information is only used for _display_ purposes: it in
380      * no way affects any of the arithmetic of the contract, including
381      * {IERC20-balanceOf} and {IERC20-transfer}.
382      */
383     function decimals() public view virtual override returns (uint8) {
384         return 18;
385     }
386 
387     /**
388      * @dev See {IERC20-totalSupply}.
389      */
390     function totalSupply() public view virtual override returns (uint256) {
391         return _totalSupply;
392     }
393 
394     /**
395      * @dev See {IERC20-balanceOf}.
396      */
397     function balanceOf(address account) public view virtual override returns (uint256) {
398         return _balances[account];
399     }
400 
401     /**
402      * @dev See {IERC20-transfer}.
403      *
404      * Requirements:
405      *
406      * - `recipient` cannot be the zero address.
407      * - the caller must have a balance of at least `amount`.
408      */
409     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
410         _transfer(_msgSender(), recipient, amount);
411         return true;
412     }
413 
414     /**
415      * @dev See {IERC20-allowance}.
416      */
417     function allowance(address owner, address spender) public view virtual override returns (uint256) {
418         return _allowances[owner][spender];
419     }
420 
421     /**
422      * @dev See {IERC20-approve}.
423      *
424      * Requirements:
425      *
426      * - `spender` cannot be the zero address.
427      */
428     function approve(address spender, uint256 amount) public virtual override returns (bool) {
429         _approve(_msgSender(), spender, amount);
430         return true;
431     }
432 
433     /**
434      * @dev See {IERC20-transferFrom}.
435      *
436      * Emits an {Approval} event indicating the updated allowance. This is not
437      * required by the EIP. See the note at the beginning of {ERC20}.
438      *
439      * Requirements:
440      *
441      * - `sender` and `recipient` cannot be the zero address.
442      * - `sender` must have a balance of at least `amount`.
443      * - the caller must have allowance for ``sender``'s tokens of at least
444      * `amount`.
445      */
446     function transferFrom(
447         address sender,
448         address recipient,
449         uint256 amount
450     ) public virtual override returns (bool) {
451         _transfer(sender, recipient, amount);
452 
453         uint256 currentAllowance = _allowances[sender][_msgSender()];
454         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
455         unchecked {
456             _approve(sender, _msgSender(), currentAllowance - amount);
457         }
458 
459         return true;
460     }
461 
462     /**
463      * @dev Atomically increases the allowance granted to `spender` by the caller.
464      *
465      * This is an alternative to {approve} that can be used as a mitigation for
466      * problems described in {IERC20-approve}.
467      *
468      * Emits an {Approval} event indicating the updated allowance.
469      *
470      * Requirements:
471      *
472      * - `spender` cannot be the zero address.
473      */
474     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
475         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
476         return true;
477     }
478 
479     /**
480      * @dev Atomically decreases the allowance granted to `spender` by the caller.
481      *
482      * This is an alternative to {approve} that can be used as a mitigation for
483      * problems described in {IERC20-approve}.
484      *
485      * Emits an {Approval} event indicating the updated allowance.
486      *
487      * Requirements:
488      *
489      * - `spender` cannot be the zero address.
490      * - `spender` must have allowance for the caller of at least
491      * `subtractedValue`.
492      */
493     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
494         uint256 currentAllowance = _allowances[_msgSender()][spender];
495         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
496         unchecked {
497             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
498         }
499 
500         return true;
501     }
502 
503     /**
504      * @dev Moves `amount` of tokens from `sender` to `recipient`.
505      *
506      * This internal function is equivalent to {transfer}, and can be used to
507      * e.g. implement automatic token fees, slashing mechanisms, etc.
508      *
509      * Emits a {Transfer} event.
510      *
511      * Requirements:
512      *
513      * - `sender` cannot be the zero address.
514      * - `recipient` cannot be the zero address.
515      * - `sender` must have a balance of at least `amount`.
516      */
517     function _transfer(
518         address sender,
519         address recipient,
520         uint256 amount
521     ) internal virtual {
522         require(sender != address(0), "ERC20: transfer from the zero address");
523         require(recipient != address(0), "ERC20: transfer to the zero address");
524 
525         _beforeTokenTransfer(sender, recipient, amount);
526 
527         uint256 senderBalance = _balances[sender];
528         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
529         unchecked {
530             _balances[sender] = senderBalance - amount;
531         }
532         _balances[recipient] += amount;
533 
534         emit Transfer(sender, recipient, amount);
535 
536         _afterTokenTransfer(sender, recipient, amount);
537     }
538 
539     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
540      * the total supply.
541      *
542      * Emits a {Transfer} event with `from` set to the zero address.
543      *
544      * Requirements:
545      *
546      * - `account` cannot be the zero address.
547      */
548     function _mint(address account, uint256 amount) internal virtual {
549         require(account != address(0), "ERC20: mint to the zero address");
550 
551         _beforeTokenTransfer(address(0), account, amount);
552 
553         _totalSupply += amount;
554         _balances[account] += amount;
555         emit Transfer(address(0), account, amount);
556 
557         _afterTokenTransfer(address(0), account, amount);
558     }
559 
560     /**
561      * @dev Destroys `amount` tokens from `account`, reducing the
562      * total supply.
563      *
564      * Emits a {Transfer} event with `to` set to the zero address.
565      *
566      * Requirements:
567      *
568      * - `account` cannot be the zero address.
569      * - `account` must have at least `amount` tokens.
570      */
571     function _burn(address account, uint256 amount) internal virtual {
572         require(account != address(0), "ERC20: burn from the zero address");
573 
574         _beforeTokenTransfer(account, address(0), amount);
575 
576         uint256 accountBalance = _balances[account];
577         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
578         unchecked {
579             _balances[account] = accountBalance - amount;
580         }
581         _totalSupply -= amount;
582 
583         emit Transfer(account, address(0), amount);
584 
585         _afterTokenTransfer(account, address(0), amount);
586     }
587 
588     /**
589      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
590      *
591      * This internal function is equivalent to `approve`, and can be used to
592      * e.g. set automatic allowances for certain subsystems, etc.
593      *
594      * Emits an {Approval} event.
595      *
596      * Requirements:
597      *
598      * - `owner` cannot be the zero address.
599      * - `spender` cannot be the zero address.
600      */
601     function _approve(
602         address owner,
603         address spender,
604         uint256 amount
605     ) internal virtual {
606         require(owner != address(0), "ERC20: approve from the zero address");
607         require(spender != address(0), "ERC20: approve to the zero address");
608 
609         _allowances[owner][spender] = amount;
610         emit Approval(owner, spender, amount);
611     }
612 
613     /**
614      * @dev Hook that is called before any transfer of tokens. This includes
615      * minting and burning.
616      *
617      * Calling conditions:
618      *
619      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
620      * will be transferred to `to`.
621      * - when `from` is zero, `amount` tokens will be minted for `to`.
622      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
623      * - `from` and `to` are never both zero.
624      *
625      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
626      */
627     function _beforeTokenTransfer(
628         address from,
629         address to,
630         uint256 amount
631     ) internal virtual {}
632 
633     /**
634      * @dev Hook that is called after any transfer of tokens. This includes
635      * minting and burning.
636      *
637      * Calling conditions:
638      *
639      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
640      * has been transferred to `to`.
641      * - when `from` is zero, `amount` tokens have been minted for `to`.
642      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
643      * - `from` and `to` are never both zero.
644      *
645      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
646      */
647     function _afterTokenTransfer(
648         address from,
649         address to,
650         uint256 amount
651     ) internal virtual {}
652 }
653 
654 // File: MREIT.sol
655 
656 
657 
658 // Contract for an ENMT token (ERC20 compliant Non-Mintable Token). Fully compliant with the ERC20 specification.
659 
660 // TOKEN SPECIFICATIONS:
661 // - Total supply set upon creation.
662 // - No new tokens can ever be minted.
663 // - Tokens can be burnt by any user to reduce total supply.
664 // - Fully ERC20 compliant.
665 // - This token has no owner, no admin functions, and is fully decentralised.
666 
667 pragma solidity ^0.8.0;
668 
669 
670 
671 
672 
673 // A fully ERC20 Compliant Non Mintable Token (ENMT)
674 contract MREIT is ERC20, Ownable, IMerkleDistributor {
675     
676     // Defines how to read the TokenInfo ABI, as well as the capabilities of the token
677     uint256 public TOKEN_TYPE = 1;
678     
679     struct TokenInfo {
680         uint8 decimals;
681         address creator;
682     }
683     
684     TokenInfo public INFO;
685 
686     bytes32 public override merkleRoot;
687     // address of token i.e MREIT
688     address public immutable override token;
689     // This is a packed array of booleans for verifying the claims.
690     mapping(uint256 => uint256) private claimedBitMap;
691     
692 
693     constructor(
694         string memory _name, 
695         string memory _symbol, 
696         uint8 _decimals, 
697         address _creator, 
698         uint256 _totalSupply, 
699         bytes32 _merkleRoot
700     ) ERC20(_name, _symbol) {
701         _mint(msg.sender, _totalSupply);
702         INFO = TokenInfo(_decimals, _creator);
703         merkleRoot = _merkleRoot;
704         token = address(this);
705     }
706     
707     function decimals() public view virtual override returns (uint8) {
708         return INFO.decimals;
709     }
710 
711     function burn(uint256 amount) public virtual {
712         _burn(_msgSender(), amount);
713     }
714     
715 
716     ///@dev set claim for the given index
717     function _setClaimed(uint256 index) internal {
718         uint256 claimedWordIndex = index / 256;
719         uint256 claimedBitIndex = index % 256;
720         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
721     }
722 
723     ///@dev called by the user to claim the token
724     ///@param index sequential index 
725     ///@param account account of the claim address
726     ///@param amount amount of claim 
727     ///@param merkleProof merkleProof for the claim of the account
728     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external override {
729         require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');
730 
731         // Verify the merkle proof.
732         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
733         require(MerkleProof.verify(merkleProof, merkleRoot, node), 'MerkleDistributor: Invalid proof.');
734 
735         // Mark it claimed and send the token.
736         _setClaimed(index);
737         require(transfer(account, amount), 'MerkleDistributor: Transfer failed.');
738 
739         emit Claimed(index, account, amount);
740     }
741 
742     ///@dev look if already claimed or not for the index
743     ///@param index index of the token
744     function isClaimed(uint256 index) public view override returns (bool) {
745         uint256 claimedWordIndex = index / 256;
746         uint256 claimedBitIndex = index % 256;
747         uint256 claimedWord = claimedBitMap[claimedWordIndex];
748         uint256 mask = (1 << claimedBitIndex);
749         return claimedWord & mask == mask;
750     }
751 
752 
753     ///@dev update merkle root 
754     ///@param _newMerkleRoot new merkle root for the distribution
755     function updateMerkleRoot(bytes32 _newMerkleRoot) external onlyOwner{
756         merkleRoot = _newMerkleRoot;
757     }
758 
759     ///@dev called by the owner of the contract to rescue the token from the contract
760     ///@param amount amount of token to withdraw
761     function withdrawToken(uint256 amount) external onlyOwner{
762         transfer(msg.sender, amount);
763     }
764     
765 }