1 // SPDX-License-Identifier: MIT
2 error TransactionCapExceeded();
3 error ExcessiveOwnedMints();
4 error MintZeroQuantity();
5 error InvalidPayment();
6 error CapExceeded();
7 error ValueCannotBeZero();
8 error CannotBeNullAddress();
9 error InvalidTeamChange();
10 error InvalidInputValue();
11 error NoStateChange();
12 
13 error PublicMintingClosed();
14 error AllowlistMintClosed();
15 
16 error AddressNotAllowlisted();
17 
18 error OnlyERC20MintingEnabled();
19 error ERC20TokenNotApproved();
20 error ERC20InsufficientBalance();
21 error ERC20InsufficientAllowance();
22 error ERC20TransferFailed();
23 error ERC20CappedInvalidValue();
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28 * @dev These functions deal with verification of Merkle Trees proofs.
29 *
30 * The proofs can be generated using the JavaScript library
31 * https://github.com/miguelmota/merkletreejs[merkletreejs].
32 * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
33 *
34 *
35 * WARNING: You should avoid using leaf values that are 64 bytes long prior to
36 * hashing, or use a hash function other than keccak256 for hashing leaves.
37 * This is because the concatenation of a sorted pair of internal nodes in
38 * the merkle tree could be reinterpreted as a leaf value.
39 */
40 library MerkleProof {
41     /**
42     * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
43     * defined by 'root'. For this, a 'proof' must be provided, containing
44     * sibling hashes on the branch from the leaf to the root of the tree. Each
45     * pair of leaves and each pair of pre-images are assumed to be sorted.
46     */
47     function verify(
48         bytes32[] memory proof,
49         bytes32 root,
50         bytes32 leaf
51     ) internal pure returns (bool) {
52         return processProof(proof, leaf) == root;
53     }
54 
55     /**
56     * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
57     * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
58     * hash matches the root of the tree. When processing the proof, the pairs
59     * of leafs & pre-images are assumed to be sorted.
60     *
61     * _Available since v4.4._
62     */
63     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
64         bytes32 computedHash = leaf;
65         for (uint256 i = 0; i < proof.length; i++) {
66             bytes32 proofElement = proof[i];
67             if (computedHash <= proofElement) {
68                 // Hash(current computed hash + current element of the proof)
69                 computedHash = _efficientHash(computedHash, proofElement);
70             } else {
71                 // Hash(current element of the proof + current computed hash)
72                 computedHash = _efficientHash(proofElement, computedHash);
73             }
74         }
75         return computedHash;
76     }
77 
78     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
79         assembly {
80             mstore(0x00, a)
81             mstore(0x20, b)
82             value := keccak256(0x00, 0x40)
83         }
84     }
85 }
86 
87 // File: @openzeppelin/contracts/utils/Context.sol
88 
89 
90 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev Provides information about the current execution context, including the
96  * sender of the transaction and its data. While these are generally available
97  * via msg.sender and msg.data, they should not be accessed in such a direct
98  * manner, since when dealing with meta-transactions the account sending and
99  * paying for execution may not be the actual sender (as far as an application
100  * is concerned).
101  *
102  * This contract is only required for intermediate, library-like contracts.
103  */
104 abstract contract Context {
105     function _msgSender() internal view virtual returns (address) {
106         return msg.sender;
107     }
108 
109     function _msgData() internal view virtual returns (bytes calldata) {
110         return msg.data;
111     }
112 }
113 
114 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
115 
116 
117 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev Interface of the ERC20 standard as defined in the EIP.
123  */
124 interface IERC20 {
125     /**
126      * @dev Emitted when `value` tokens are moved from one account (`from`) to
127      * another (`to`).
128      *
129      * Note that `value` may be zero.
130      */
131     event Transfer(address indexed from, address indexed to, uint256 value);
132 
133     /**
134      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
135      * a call to {approve}. `value` is the new allowance.
136      */
137     event Approval(address indexed owner, address indexed spender, uint256 value);
138 
139     /**
140      * @dev Returns the amount of tokens in existence.
141      */
142     function totalSupply() external view returns (uint256);
143 
144     /**
145      * @dev Returns the amount of tokens owned by `account`.
146      */
147     function balanceOf(address account) external view returns (uint256);
148 
149     /**
150      * @dev Moves `amount` tokens from the caller's account to `to`.
151      *
152      * Returns a boolean value indicating whether the operation succeeded.
153      *
154      * Emits a {Transfer} event.
155      */
156     function transfer(address to, uint256 amount) external returns (bool);
157 
158     /**
159      * @dev Returns the remaining number of tokens that `spender` will be
160      * allowed to spend on behalf of `owner` through {transferFrom}. This is
161      * zero by default.
162      *
163      * This value changes when {approve} or {transferFrom} are called.
164      */
165     function allowance(address owner, address spender) external view returns (uint256);
166 
167     /**
168      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
169      *
170      * Returns a boolean value indicating whether the operation succeeded.
171      *
172      * IMPORTANT: Beware that changing an allowance with this method brings the risk
173      * that someone may use both the old and the new allowance by unfortunate
174      * transaction ordering. One possible solution to mitigate this race
175      * condition is to first reduce the spender's allowance to 0 and set the
176      * desired value afterwards:
177      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178      *
179      * Emits an {Approval} event.
180      */
181     function approve(address spender, uint256 amount) external returns (bool);
182 
183     /**
184      * @dev Moves `amount` tokens from `from` to `to` using the
185      * allowance mechanism. `amount` is then deducted from the caller's
186      * allowance.
187      *
188      * Returns a boolean value indicating whether the operation succeeded.
189      *
190      * Emits a {Transfer} event.
191      */
192     function transferFrom(
193         address from,
194         address to,
195         uint256 amount
196     ) external returns (bool);
197 }
198 
199 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
200 
201 
202 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
203 
204 pragma solidity ^0.8.0;
205 
206 
207 /**
208  * @dev Interface for the optional metadata functions from the ERC20 standard.
209  *
210  * _Available since v4.1._
211  */
212 interface IERC20Metadata is IERC20 {
213     /**
214      * @dev Returns the name of the token.
215      */
216     function name() external view returns (string memory);
217 
218     /**
219      * @dev Returns the symbol of the token.
220      */
221     function symbol() external view returns (string memory);
222 
223     /**
224      * @dev Returns the decimals places of the token.
225      */
226     function decimals() external view returns (uint8);
227 }
228 
229 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
230 
231 
232 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
233 
234 pragma solidity ^0.8.0;
235 
236 
237 
238 
239 /**
240  * @dev Implementation of the {IERC20} interface.
241  *
242  * This implementation is agnostic to the way tokens are created. This means
243  * that a supply mechanism has to be added in a derived contract using {_mint}.
244  * For a generic mechanism see {ERC20PresetMinterPauser}.
245  *
246  * TIP: For a detailed writeup see our guide
247  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
248  * to implement supply mechanisms].
249  *
250  * We have followed general OpenZeppelin Contracts guidelines: functions revert
251  * instead returning `false` on failure. This behavior is nonetheless
252  * conventional and does not conflict with the expectations of ERC20
253  * applications.
254  *
255  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
256  * This allows applications to reconstruct the allowance for all accounts just
257  * by listening to said events. Other implementations of the EIP may not emit
258  * these events, as it isn't required by the specification.
259  *
260  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
261  * functions have been added to mitigate the well-known issues around setting
262  * allowances. See {IERC20-approve}.
263  */
264 contract ERC20 is Context, IERC20, IERC20Metadata {
265     mapping(address => uint256) private _balances;
266     mapping(address => mapping(address => uint256)) private _allowances;
267     uint256 private _totalSupply;
268     string private _name;
269     string private _symbol;
270 
271     /**
272      * @dev Sets the values for {name} and {symbol}.
273      *
274      * The default value of {decimals} is 18. To select a different value for
275      * {decimals} you should overload it.
276      *
277      * All two of these values are immutable: they can only be set once during
278      * construction.
279      */
280     constructor(string memory name_, string memory symbol_) {
281         _name = name_;
282         _symbol = symbol_;
283     }
284 
285     /**
286      * @dev Returns the name of the token.
287      */
288     function name() public view virtual override returns (string memory) {
289         return _name;
290     }
291 
292     /**
293      * @dev Returns the symbol of the token, usually a shorter version of the
294      * name.
295      */
296     function symbol() public view virtual override returns (string memory) {
297         return _symbol;
298     }
299 
300     /**
301      * @dev Returns the number of decimals used to get its user representation.
302      * For example, if `decimals` equals `2`, a balance of `505` tokens should
303      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
304      *
305      * Tokens usually opt for a value of 18, imitating the relationship between
306      * Ether and Wei. This is the value {ERC20} uses, unless this function is
307      * overridden;
308      *
309      * NOTE: This information is only used for _display_ purposes: it in
310      * no way affects any of the arithmetic of the contract, including
311      * {IERC20-balanceOf} and {IERC20-transfer}.
312      */
313     function decimals() public view virtual override returns (uint8) {
314         return 18;
315     }
316 
317     /**
318      * @dev See {IERC20-totalSupply}.
319      */
320     function totalSupply() public view virtual override returns (uint256) {
321         return _totalSupply;
322     }
323 
324     /**
325      * @dev See {IERC20-balanceOf}.
326      */
327     function balanceOf(address account) public view virtual override returns (uint256) {
328         return _balances[account];
329     }
330 
331     /**
332      * @dev See {IERC20-transfer}.
333      *
334      * Requirements:
335      *
336      * - `to` cannot be the zero address.
337      * - the caller must have a balance of at least `amount`.
338      */
339     function transfer(address to, uint256 amount) public virtual override returns (bool) {
340         address owner = _msgSender();
341         _transfer(owner, to, amount);
342         return true;
343     }
344 
345     /**
346      * @dev See {IERC20-allowance}.
347      */
348     function allowance(address owner, address spender) public view virtual override returns (uint256) {
349         return _allowances[owner][spender];
350     }
351 
352     /**
353      * @dev See {IERC20-approve}.
354      *
355      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
356      * `transferFrom`. This is semantically equivalent to an infinite approval.
357      *
358      * Requirements:
359      *
360      * - `spender` cannot be the zero address.
361      */
362     function approve(address spender, uint256 amount) public virtual override returns (bool) {
363         address owner = _msgSender();
364         _approve(owner, spender, amount);
365         return true;
366     }
367 
368     /**
369      * @dev See {IERC20-transferFrom}.
370      *
371      * Emits an {Approval} event indicating the updated allowance. This is not
372      * required by the EIP. See the note at the beginning of {ERC20}.
373      *
374      * NOTE: Does not update the allowance if the current allowance
375      * is the maximum `uint256`.
376      *
377      * Requirements:
378      *
379      * - `from` and `to` cannot be the zero address.
380      * - `from` must have a balance of at least `amount`.
381      * - the caller must have allowance for ``from``'s tokens of at least
382      * `amount`.
383      */
384     function transferFrom(
385         address from,
386         address to,
387         uint256 amount
388     ) public virtual override returns (bool) {
389         address spender = _msgSender();
390         _spendAllowance(from, spender, amount);
391         _transfer(from, to, amount);
392         return true;
393     }
394 
395     /**
396      * @dev Atomically increases the allowance granted to `spender` by the caller.
397      *
398      * This is an alternative to {approve} that can be used as a mitigation for
399      * problems described in {IERC20-approve}.
400      *
401      * Emits an {Approval} event indicating the updated allowance.
402      *
403      * Requirements:
404      *
405      * - `spender` cannot be the zero address.
406      */
407     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
408         address owner = _msgSender();
409         _approve(owner, spender, allowance(owner, spender) + addedValue);
410         return true;
411     }
412 
413     /**
414      * @dev Atomically decreases the allowance granted to `spender` by the caller.
415      *
416      * This is an alternative to {approve} that can be used as a mitigation for
417      * problems described in {IERC20-approve}.
418      *
419      * Emits an {Approval} event indicating the updated allowance.
420      *
421      * Requirements:
422      *
423      * - `spender` cannot be the zero address.
424      * - `spender` must have allowance for the caller of at least
425      * `subtractedValue`.
426      */
427     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
428         address owner = _msgSender();
429         uint256 currentAllowance = allowance(owner, spender);
430         if(currentAllowance < subtractedValue) revert ERC20InsufficientBalance();
431         unchecked {
432             _approve(owner, spender, currentAllowance - subtractedValue);
433         }
434 
435         return true;
436     }
437 
438     /**
439      * @dev Moves `amount` of tokens from `from` to `to`.
440      *
441      * This internal function is equivalent to {transfer}, and can be used to
442      * e.g. implement automatic token fees, slashing mechanisms, etc.
443      *
444      * Emits a {Transfer} event.
445      *
446      * Requirements:
447      *
448      * - `from` cannot be the zero address.
449      * - `to` cannot be the zero address.
450      * - `from` must have a balance of at least `amount`.
451      */
452     function _transfer(
453         address from,
454         address to,
455         uint256 amount
456     ) internal virtual {
457         if(from == address(0)) revert CannotBeNullAddress();
458         if(to == address(0)) revert CannotBeNullAddress();
459 
460         _beforeTokenTransfer(from, to, amount);
461 
462         uint256 fromBalance = _balances[from];
463         if(fromBalance < amount) revert ERC20InsufficientBalance();
464         unchecked {
465             _balances[from] = fromBalance - amount;
466         }
467         _balances[to] += amount;
468 
469         emit Transfer(from, to, amount);
470 
471         _afterTokenTransfer(from, to, amount);
472     }
473 
474     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
475      * the total supply.
476      *
477      * Emits a {Transfer} event with `from` set to the zero address.
478      *
479      * Requirements:
480      *
481      * - `account` cannot be the zero address.
482      */
483     function _mint(address account, uint256 amount) internal virtual {
484         if(account == address(0)) revert CannotBeNullAddress();
485 
486         _beforeTokenTransfer(address(0), account, amount);
487 
488         _totalSupply += amount;
489         _balances[account] += amount;
490         emit Transfer(address(0), account, amount);
491 
492         _afterTokenTransfer(address(0), account, amount);
493     }
494 
495     /**
496      * @dev Destroys `amount` tokens from `account`, reducing the
497      * total supply.
498      *
499      * Emits a {Transfer} event with `to` set to the zero address.
500      *
501      * Requirements:
502      *
503      * - `account` cannot be the zero address.
504      * - `account` must have at least `amount` tokens.
505      */
506     function _burn(address account, uint256 amount) internal virtual {
507         if(account == address(0)) revert CannotBeNullAddress();
508 
509         _beforeTokenTransfer(account, address(0), amount);
510 
511         uint256 accountBalance = _balances[account];
512         if(accountBalance < amount) revert ERC20InsufficientBalance();
513         unchecked {
514             _balances[account] = accountBalance - amount;
515         }
516         _totalSupply -= amount;
517 
518         emit Transfer(account, address(0), amount);
519 
520         _afterTokenTransfer(account, address(0), amount);
521     }
522 
523     /**
524      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
525      *
526      * This internal function is equivalent to `approve`, and can be used to
527      * e.g. set automatic allowances for certain subsystems, etc.
528      *
529      * Emits an {Approval} event.
530      *
531      * Requirements:
532      *
533      * - `owner` cannot be the zero address.
534      * - `spender` cannot be the zero address.
535      */
536     function _approve(
537         address owner,
538         address spender,
539         uint256 amount
540     ) internal virtual {
541         if(owner == address(0)) revert CannotBeNullAddress();
542         if(spender == address(0)) revert CannotBeNullAddress();
543 
544         _allowances[owner][spender] = amount;
545         emit Approval(owner, spender, amount);
546     }
547 
548     /**
549      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
550      *
551      * Does not update the allowance amount in case of infinite allowance.
552      * Revert if not enough allowance is available.
553      *
554      * Might emit an {Approval} event.
555      */
556     function _spendAllowance(
557         address owner,
558         address spender,
559         uint256 amount
560     ) internal virtual {
561         uint256 currentAllowance = allowance(owner, spender);
562         if (currentAllowance != type(uint256).max) {
563             if(currentAllowance < amount) revert ERC20InsufficientBalance();
564             unchecked {
565                 _approve(owner, spender, currentAllowance - amount);
566             }
567         }
568     }
569 
570     /**
571      * @dev Hook that is called before any transfer of tokens. This includes
572      * minting and burning.
573      *
574      * Calling conditions:
575      *
576      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
577      * will be transferred to `to`.
578      * - when `from` is zero, `amount` tokens will be minted for `to`.
579      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
580      * - `from` and `to` are never both zero.
581      *
582      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
583      */
584     function _beforeTokenTransfer(
585         address from,
586         address to,
587         uint256 amount
588     ) internal virtual {}
589 
590     /**
591      * @dev Hook that is called after any transfer of tokens. This includes
592      * minting and burning.
593      *
594      * Calling conditions:
595      *
596      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
597      * has been transferred to `to`.
598      * - when `from` is zero, `amount` tokens have been minted for `to`.
599      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
600      * - `from` and `to` are never both zero.
601      *
602      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
603      */
604     function _afterTokenTransfer(
605         address from,
606         address to,
607         uint256 amount
608     ) internal virtual {}
609 }
610 
611 // File: contracts/erc20.sol
612 
613 
614 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
615 
616 pragma solidity ^0.8.0;
617 
618 
619 
620 /**
621  * @dev Extension of {ERC20} that allows token holders to destroy both their own
622  * tokens and those that they have an allowance for, in a way that can be
623  * recognized off-chain (via event analysis).
624  */
625 abstract contract ERC20Burnable is Context, ERC20 {
626     /**
627      * @dev Destroys `amount` tokens from the caller.
628      *
629      * See {ERC20-_burn}.
630      */
631     function burn(uint256 amount) public virtual {
632         _burn(_msgSender(), amount);
633     }
634 
635     /**
636      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
637      * allowance.
638      *
639      * See {ERC20-_burn} and {ERC20-allowance}.
640      *
641      * Requirements:
642      *
643      * - the caller must have allowance for ``accounts``'s tokens of at least
644      * `amount`.
645      */
646     function burnFrom(address account, uint256 amount) public virtual {
647         _spendAllowance(account, _msgSender(), amount);
648         _burn(account, amount);
649     }
650 }
651 
652 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
653 
654 pragma solidity ^0.8.0;
655 
656 /**
657  * @dev Contract module which provides a basic access control mechanism, where
658  * there is an account (an owner) that can be granted exclusive access to
659  * specific functions.
660  *
661  * By default, the owner account will be the one that deploys the contract. This
662  * can later be changed with {transferOwnership}.
663  *
664  * This module is used through inheritance. It will make available the modifier
665  * `onlyOwner`, which can be applied to your functions to restrict their use to
666  * the owner.
667  */
668 abstract contract Ownable is Context {
669     address private _owner;
670 
671     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
672 
673     /**
674      * @dev Initializes the contract setting the deployer as the initial owner.
675      */
676     constructor() {
677         _transferOwnership(_msgSender());
678     }
679 
680     /**
681      * @dev Throws if called by any account other than the owner.
682      */
683     modifier onlyOwner() {
684         _checkOwner();
685         _;
686     }
687 
688     /**
689      * @dev Returns the address of the current owner.
690      */
691     function owner() public view virtual returns (address) {
692         return _owner;
693     }
694 
695     /**
696      * @dev Throws if the sender is not the owner.
697      */
698     function _checkOwner() internal view virtual {
699         require(owner() == _msgSender(), "Ownable: caller is not the owner");
700     }
701 
702     /**
703      * @dev Leaves the contract without owner. It will not be possible to call
704      * `onlyOwner` functions anymore. Can only be called by the current owner.
705      *
706      * NOTE: Renouncing ownership will leave the contract without an owner,
707      * thereby removing any functionality that is only available to the owner.
708      */
709     function renounceOwnership() public virtual onlyOwner {
710         _transferOwnership(address(0));
711     }
712 
713     /**
714      * @dev Transfers ownership of the contract to a new account (`newOwner`).
715      * Can only be called by the current owner.
716      */
717     function transferOwnership(address newOwner) public virtual onlyOwner {
718         if(newOwner == address(0)) revert CannotBeNullAddress();
719         _transferOwnership(newOwner);
720     }
721 
722     /**
723      * @dev Transfers ownership of the contract to a new account (`newOwner`).
724      * Internal function without access restriction.
725      */
726     function _transferOwnership(address newOwner) internal virtual {
727         address oldOwner = _owner;
728         _owner = newOwner;
729         emit OwnershipTransferred(oldOwner, newOwner);
730     }
731 }
732 
733 // Rampp Contracts v2.1 (Teams.sol)
734 
735 pragma solidity ^0.8.0;
736 
737 /**
738 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
739 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
740 * This will easily allow cross-collaboration via Mintplex.xyz.
741 **/
742 abstract contract Teams is Ownable{
743   mapping (address => bool) internal team;
744 
745   /**
746   * @dev Adds an address to the team. Allows them to execute protected functions
747   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
748   **/
749   function addToTeam(address _address) public onlyOwner {
750     if(_address == address(0)) revert CannotBeNullAddress();
751     if(inTeam(_address)) revert InvalidTeamChange();
752   
753     team[_address] = true;
754   }
755 
756   /**
757   * @dev Removes an address to the team.
758   * @param _address the ETH address to remove, cannot be 0x and must be in team
759   **/
760   function removeFromTeam(address _address) public onlyOwner {
761     if(_address == address(0)) revert CannotBeNullAddress();
762     if(!inTeam(_address)) revert InvalidTeamChange();
763   
764     team[_address] = false;
765   }
766 
767   /**
768   * @dev Check if an address is valid and active in the team
769   * @param _address ETH address to check for truthiness
770   **/
771   function inTeam(address _address)
772     public
773     view
774     returns (bool)
775   {
776     if(_address == address(0)) revert CannotBeNullAddress();
777     return team[_address] == true;
778   }
779 
780   /**
781   * @dev Throws if called by any account other than the owner or team member.
782   */
783   function _onlyTeamOrOwner() private view {
784     bool _isOwner = owner() == _msgSender();
785     bool _isTeam = inTeam(_msgSender());
786     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
787   }
788 
789   modifier onlyTeamOrOwner() {
790     _onlyTeamOrOwner();
791     _;
792   }
793 }
794 
795 // @dev Allows the contract to have an enforceable supply cap.
796 // @notice This is toggleable by the team, so supply can be unlimited/limited at will.
797 abstract contract ERC20Capped is ERC20, Teams {
798     bool public _capEnabled;
799     uint256 internal _cap; // Supply Cap of entire token contract
800 
801     function setCapStatus(bool _capStatus) public onlyTeamOrOwner {
802         _capEnabled = _capStatus;
803     }
804 
805     function canMintAmount(uint256 _amount) public view returns (bool) {
806         if(!_capEnabled){ return true; }
807         return ERC20.totalSupply() + _amount <= supplyCap();
808     }
809 
810     // @dev Update the total possible supply to a new value.
811     // @notice _newCap must be greater than or equal to the currently minted supply
812     // @param _newCap is the new amount of tokens available in wei
813     function setSupplyCap(uint256 _newCap) public onlyTeamOrOwner {
814         if(_newCap < ERC20.totalSupply()) revert ERC20CappedInvalidValue();
815         _cap = _newCap;
816     }
817 
818     function supplyCap() public view virtual returns (uint256) {
819         if(!_capEnabled){ return ERC20.totalSupply(); }
820         return _cap;
821     }
822 }
823 
824 abstract contract Feeable is Teams {
825   uint256 public PRICE = 0 ether;
826 
827   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
828     PRICE = _feeInWei;
829   }
830 
831   // @dev quickly calculate the fee that will be required for a given qty to mint
832   // @notice _count is the value in wei, not in human readable count
833   // @param _count is representation of quantity in wei. it will be converted to eth to arrive at proper value
834   function getPrice(uint256 _count) public view returns (uint256) {
835     if(_count < 1 ether) revert InvalidInputValue();
836     uint256 countHuman = _count / 1 ether;
837     return PRICE * countHuman;
838   }
839 }
840 
841 // File: Allowlist.sol
842 
843 pragma solidity ^0.8.0;
844 
845 abstract contract Allowlist is Teams {
846     bytes32 public merkleRoot;
847     bool public onlyAllowlistMode = false;
848 
849     /**
850         * @dev Update merkle root to reflect changes in Allowlist
851         * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
852         */
853     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
854         if(_newMerkleRoot == merkleRoot) revert NoStateChange();
855         merkleRoot = _newMerkleRoot;
856     }
857 
858     /**
859         * @dev Check the proof of an address if valid for merkle root
860         * @param _to address to check for proof
861         * @param _merkleProof Proof of the address to validate against root and leaf
862         */
863     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
864         if(merkleRoot == 0) revert ValueCannotBeZero();
865         bytes32 leaf = keccak256(abi.encodePacked(_to));
866 
867         return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
868     }
869 
870 
871     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
872         onlyAllowlistMode = true;
873     }
874 
875     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
876         onlyAllowlistMode = false;
877     }
878 }
879 
880 // File: WithdrawableV2
881 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
882 // ERC-20 Payouts are limited to a single payout address.
883 abstract contract WithdrawableV2 is Teams {
884   struct acceptedERC20 {
885     bool isActive;
886     uint256 chargeAmount;
887   }
888   mapping(address => acceptedERC20) private allowedTokenContracts;
889   address[] public payableAddresses;
890   address public erc20Payable;
891   uint256[] public payableFees;
892   uint256 public payableAddressCount;
893   bool public onlyERC20MintingMode;
894 
895   function withdrawAll() public onlyTeamOrOwner {
896       if(address(this).balance == 0) revert ValueCannotBeZero();
897       _withdrawAll(address(this).balance);
898   }
899 
900   function _withdrawAll(uint256 balance) private {
901       for(uint i=0; i < payableAddressCount; i++ ) {
902           _widthdraw(
903               payableAddresses[i],
904               (balance * payableFees[i]) / 100
905           );
906       }
907   }
908   
909   function _widthdraw(address _address, uint256 _amount) private {
910       (bool success, ) = _address.call{value: _amount}("");
911       require(success, "Transfer failed.");
912   }
913 
914   /**
915   * @dev Allow contract owner to withdraw ERC-20 balance from contract
916   * in the event ERC-20 tokens are paid to the contract for mints.
917   * @param _tokenContract contract of ERC-20 token to withdraw
918   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
919   */
920   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
921     if(_amountToWithdraw == 0) revert ValueCannotBeZero();
922     IERC20 tokenContract = IERC20(_tokenContract);
923     if(tokenContract.balanceOf(address(this)) < _amountToWithdraw) revert ERC20InsufficientBalance();
924     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
925   }
926 
927   /**
928   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
929   * @param _erc20TokenContract address of ERC-20 contract in question
930   */
931   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
932     return allowedTokenContracts[_erc20TokenContract].isActive == true;
933   }
934 
935   /**
936   * @dev get the value of tokens to transfer for user of an ERC-20
937   * @param _erc20TokenContract address of ERC-20 contract in question
938   */
939   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
940     if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
941     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
942   }
943 
944   /**
945   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
946   * @param _erc20TokenContract address of ERC-20 contract in question
947   * @param _isActive default status of if contract should be allowed to accept payments
948   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
949   */
950   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
951     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
952     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
953   }
954 
955   /**
956   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
957   * it will assume the default value of zero. This should not be used to create new payment tokens.
958   * @param _erc20TokenContract address of ERC-20 contract in question
959   */
960   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
961     allowedTokenContracts[_erc20TokenContract].isActive = true;
962   }
963 
964   /**
965   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
966   * it will assume the default value of zero. This should not be used to create new payment tokens.
967   * @param _erc20TokenContract address of ERC-20 contract in question
968   */
969   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
970     allowedTokenContracts[_erc20TokenContract].isActive = false;
971   }
972 
973   /**
974   * @dev Enable only ERC-20 payments for minting on this contract
975   */
976   function enableERC20OnlyMinting() public onlyTeamOrOwner {
977     onlyERC20MintingMode = true;
978   }
979 
980   /**
981   * @dev Disable only ERC-20 payments for minting on this contract
982   */
983   function disableERC20OnlyMinting() public onlyTeamOrOwner {
984     onlyERC20MintingMode = false;
985   }
986 
987   /**
988   * @dev Set the payout of the ERC-20 token payout to a specific address
989   * @param _newErc20Payable new payout addresses of ERC-20 tokens
990   */
991   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
992     if(_newErc20Payable == address(0)) revert CannotBeNullAddress();
993     if(_newErc20Payable == erc20Payable) revert NoStateChange();
994     erc20Payable = _newErc20Payable;
995   }
996 
997   function definePayables(address[] memory _newPayables, uint256[] memory _newFees) public onlyTeamOrOwner {
998       delete payableAddresses;
999       delete payableFees;
1000       payableAddresses = _newPayables;
1001       payableFees = _newFees;
1002       payableAddressCount = _newPayables.length;
1003   }
1004 }
1005 
1006 // @dev Allows us to add per wallet and per transaction caps to the minting aspect of this ERC20
1007 abstract contract ERC20MintCaps is Teams {
1008     mapping(address => uint256) private _minted;
1009     bool internal _mintCapEnabled; // per wallet mint cap
1010     bool internal _batchSizeEnabled; // txn batch size limit
1011     uint256 internal mintCap; // in wei
1012     uint256 internal maxBatchSize; // in wei
1013 
1014     function setMintCap(uint256 _newMintCap) public onlyTeamOrOwner {
1015         mintCap = _newMintCap;
1016     }
1017 
1018     function setMintCapStatus(bool _newStatus) public onlyTeamOrOwner {
1019         _mintCapEnabled = _newStatus;
1020     }
1021 
1022     function setMaxBatchSize(uint256 _maxBatchSize) public onlyTeamOrOwner {
1023         maxBatchSize = _maxBatchSize;
1024     }
1025 
1026     function setMaxBatchSizeStatus(bool _newStatus) public onlyTeamOrOwner {
1027         _batchSizeEnabled = _newStatus;
1028     }
1029 
1030     // @dev Check if amount of tokens is possible to be minted
1031     // @param _amount is the amount of tokens in wei
1032     function canMintBatch(uint256 _amount) public view returns (bool) {
1033         if(!_batchSizeEnabled){ return true; }
1034         return _amount <= maxBatchSize;
1035     }
1036 
1037     // @dev returns if current mint caps are enabled (mints per wallet)
1038     // @return bool if mint caps per wallet are enforced
1039     function mintCapEnabled() public view returns (bool) {
1040         return _mintCapEnabled;
1041     }
1042 
1043     // @dev the current mintCap in decimals value
1044     // @return uint256 of mint caps per wallet. mintCapEnabled can be disabled and this value be non-zero.
1045     function maxWalletMints() public view returns(uint256) {
1046         return mintCap;
1047     }
1048 
1049     // @dev returns if current batch size caps are enabled (mints per txn)
1050     // @return bool if mint caps per transaction are enforced
1051     function mintBatchSizeEnabled() public view returns (bool) {
1052         return _batchSizeEnabled;
1053     }
1054 
1055     // @dev the current cap for a single txn in decimals value
1056     // @return uint256 the current cap for a single txn in decimals value
1057     function maxMintsPerTxn() public view returns (uint256) {
1058         return maxBatchSize;
1059     }
1060 
1061     // @dev checks if the mint count of an account is within the proper range
1062     // @notice if maxWalletMints is false it will always return true
1063     // @param _account is address to check
1064     // @param _amount is the amount of tokens in wei to be added to current minted supply
1065     function canAccountMintAmount(address _account, uint256 _amount) public view returns (bool) {
1066         if(!_mintCapEnabled){ return true; }
1067         return mintedAmount(_account) + _amount <= mintCap;
1068     }
1069 
1070     // @dev gets currently minted amount for an account
1071     // @return uint256 of tokens owned in base decimal value (wei)
1072     function mintedAmount(address _account) public view returns (uint256) {
1073         return _minted[_account];
1074     }
1075 
1076     // @dev helper function that increased the mint amount for an account
1077     // @notice this is not the same as _balances, as that can vary as trades occur.
1078     // @param _account is address to add to
1079     // @param _amount is the amount of tokens in wei to be added to current minted amount
1080     function addMintsToAccount(address _account, uint256 _amount) internal {
1081         unchecked {
1082             _minted[_account] += _amount;
1083         }
1084     }
1085 }
1086 
1087 abstract contract SingleStateMintable is Teams {
1088     bool internal publicMintOpen = false;
1089     bool internal allowlistMintOpen = false;
1090 
1091     function inPublicMint() public view returns (bool){
1092         return publicMintOpen && !allowlistMintOpen;
1093     }
1094 
1095     function inAllowlistMint() public view returns (bool){
1096         return allowlistMintOpen && !publicMintOpen;
1097     }
1098 
1099     function openPublicMint() public onlyTeamOrOwner {
1100         publicMintOpen = true;
1101         allowlistMintOpen = false;
1102     }
1103 
1104     function openAllowlistMint() public onlyTeamOrOwner {
1105         allowlistMintOpen = true;
1106         publicMintOpen = false;
1107     }
1108 
1109     // @notice This will set close all minting to public regardless of previous state
1110     function closeMinting() public onlyTeamOrOwner {
1111         allowlistMintOpen = false;
1112         publicMintOpen = false;
1113     }
1114 }
1115 
1116 
1117 // File: contracts/ERC20Plus.sol
1118 pragma solidity ^0.8.0;
1119 
1120 contract ERC20Plus is 
1121     Ownable,
1122     ERC20Burnable,
1123     ERC20Capped,
1124     ERC20MintCaps,
1125     Feeable,
1126     Allowlist,
1127     WithdrawableV2,
1128     SingleStateMintable
1129     {
1130     uint8 immutable CONTRACT_VERSION = 1;
1131     constructor(
1132         string memory name,
1133         string memory symbol,
1134         address[] memory _payableAddresses,
1135         address _erc20Payable,
1136         uint256[] memory _payableFees,
1137         bool[3] memory mintSettings, // hasMaxSupply, mintCapEnabled, maxBatchEnabled
1138         uint256[3] memory mintValues, // initMaxSupply, initMintCap, initBatchSize
1139         uint256 initPrice
1140     ) ERC20(name, symbol) {
1141         // Payable settings
1142         payableAddresses = _payableAddresses;
1143         erc20Payable = _erc20Payable;
1144         payableFees = _payableFees;
1145         payableAddressCount = _payableAddresses.length;
1146 
1147         // Set inital Supply cap settings
1148         _capEnabled = mintSettings[0];
1149         _cap = mintValues[0];
1150         
1151         // Per wallet minting settings
1152         _mintCapEnabled = mintSettings[1];
1153         mintCap = mintValues[1];
1154 
1155         // Per txn minting settings
1156         _batchSizeEnabled = mintSettings[2];
1157         maxBatchSize = mintValues[2];
1158 
1159         // setup price
1160         PRICE = initPrice;
1161     }
1162 
1163     /////////////// Admin Mint Functions
1164     /**
1165     * @dev Mints tokens to an address.
1166     * This is owner only and allows a fee-free drop
1167     * @param _to address of the future owner of the token
1168     * @param _qty amount of tokens to drop the owner in decimal value (wei typically 1e18)
1169     */
1170     function adminMint(address _to, uint256 _qty) public onlyTeamOrOwner{
1171         if(_qty < 1 ether) revert MintZeroQuantity();
1172         if(!canMintAmount(_qty)) revert CapExceeded();
1173         _mint(_to, _qty);
1174     }
1175 
1176     function adminMintBulk(address[] memory _tos, uint256 _qty) public onlyTeamOrOwner{
1177         if(_qty < 1 ether) revert MintZeroQuantity();
1178         for(uint i=0; i < _tos.length; i++ ) {
1179             _mint(_tos[i], _qty);
1180         }
1181     }
1182 
1183     /////////////// GENERIC MINT FUNCTIONS
1184     /**
1185     * @dev Mints tokens to an address in batch.
1186     * fee may or may not be required*
1187     * @param _to address of the future owner of the token
1188     * @param _amount number of tokens to mint in wei
1189     */
1190     function mintMany(address _to, uint256 _amount) public payable {
1191         if(onlyERC20MintingMode) revert PublicMintingClosed();
1192         if(_amount < 1 ether) revert MintZeroQuantity();
1193         if(!inPublicMint()) revert PublicMintingClosed();
1194         if(!canMintBatch(_amount)) revert TransactionCapExceeded();
1195         if(!canMintAmount(_amount)) revert CapExceeded();
1196         if(!canAccountMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
1197         if(msg.value != getPrice(_amount)) revert InvalidPayment();
1198 
1199         addMintsToAccount(_to, _amount);
1200         _mint(_to, _amount);
1201     }
1202 
1203     /**
1204      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1205      * fee may or may not be required*
1206      * @param _to address of the future owner of the token
1207      * @param _amount number of tokens to mint in wei
1208      * @param _erc20TokenContract erc-20 token contract to mint with
1209      */
1210     function mintManyERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1211         if(_amount < 1 ether) revert MintZeroQuantity();
1212         if(!canMintAmount(_amount)) revert CapExceeded();
1213         if(!inPublicMint()) revert PublicMintingClosed();
1214         if(!canMintBatch(_amount)) revert TransactionCapExceeded();
1215         if(!canAccountMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
1216 
1217         // ERC-20 Specific pre-flight checks
1218         if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1219         uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1220         IERC20 payableToken = IERC20(_erc20TokenContract);
1221 
1222         if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
1223         if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
1224         bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1225         if(!transferComplete) revert ERC20TransferFailed();
1226         
1227         addMintsToAccount(_to, _amount);
1228         _mint(_to, _amount);
1229     }
1230 
1231     /**
1232     * @dev Mints tokens to an address using an allowlist.
1233     * fee may or may not be required*
1234     * @param _to address of the future owner of the token
1235     * @param _amount number of tokens to mint in wei
1236     * @param _merkleProof merkle proof array
1237     */
1238     function mintManyAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1239         if(onlyERC20MintingMode) revert AllowlistMintClosed();
1240         if(_amount < 1 ether) revert MintZeroQuantity();
1241         if(!inAllowlistMint()) revert AllowlistMintClosed();
1242         if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
1243         if(!canMintBatch(_amount)) revert TransactionCapExceeded();
1244         if(!canAccountMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
1245         if(!canMintAmount(_amount)) revert CapExceeded();
1246         if(msg.value != getPrice(_amount)) revert InvalidPayment();
1247 
1248         addMintsToAccount(_to, _amount);
1249         _mint(_to, _amount);
1250     }
1251 
1252     /**
1253     * @dev Mints tokens to an address using an allowlist.
1254     * fee may or may not be required*
1255     * @param _to address of the future owner of the token
1256     * @param _amount number of tokens to mint in wei
1257     * @param _merkleProof merkle proof array
1258     * @param _erc20TokenContract erc-20 token contract to mint with
1259     */
1260     function mintManyERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
1261         if(!inAllowlistMint()) revert AllowlistMintClosed();
1262         if(_amount < 1 ether) revert MintZeroQuantity();
1263         if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
1264         if(!canMintBatch(_amount)) revert TransactionCapExceeded();
1265         if(!canAccountMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
1266         if(!canMintAmount(_amount)) revert CapExceeded();
1267         
1268         // ERC-20 Specific pre-flight checks
1269         if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1270         uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1271         IERC20 payableToken = IERC20(_erc20TokenContract);
1272         
1273         if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
1274         if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
1275         
1276         bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1277         if(!transferComplete) revert ERC20TransferFailed();
1278 
1279         addMintsToAccount(_to, _amount);
1280         _mint(_to, _amount);
1281     }
1282 }