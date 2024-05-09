1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.11;
4 
5 // File: @openzeppelin/contracts/utils/Context.sol
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/access/Ownable.sol
30 
31 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(
51         address indexed previousOwner,
52         address indexed newOwner
53     );
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         _transferOwnership(address(0));
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(
94             newOwner != address(0),
95             "Ownable: new owner is the zero address"
96         );
97         _transferOwnership(newOwner);
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      * Internal function without access restriction.
103      */
104     function _transferOwnership(address newOwner) internal virtual {
105         address oldOwner = _owner;
106         _owner = newOwner;
107         emit OwnershipTransferred(oldOwner, newOwner);
108     }
109 }
110 
111 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
112 
113 pragma solidity ^0.8.0;
114 
115 /**
116  * @dev Interface of the ERC20 standard as defined in the EIP.
117  */
118 interface IERC20 {
119     /**
120      * @dev Returns the amount of tokens in existence.
121      */
122     function totalSupply() external view returns (uint256);
123 
124     /**
125      * @dev Returns the amount of tokens owned by `account`.
126      */
127     function balanceOf(address account) external view returns (uint256);
128 
129     /**
130      * @dev Moves `amount` tokens from the caller's account to `to`.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transfer(address to, uint256 amount) external returns (bool);
137 
138     /**
139      * @dev Returns the remaining number of tokens that `spender` will be
140      * allowed to spend on behalf of `owner` through {transferFrom}. This is
141      * zero by default.
142      *
143      * This value changes when {approve} or {transferFrom} are called.
144      */
145     function allowance(address owner, address spender)
146         external
147         view
148         returns (uint256);
149 
150     /**
151      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * IMPORTANT: Beware that changing an allowance with this method brings the risk
156      * that someone may use both the old and the new allowance by unfortunate
157      * transaction ordering. One possible solution to mitigate this race
158      * condition is to first reduce the spender's allowance to 0 and set the
159      * desired value afterwards:
160      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161      *
162      * Emits an {Approval} event.
163      */
164     function approve(address spender, uint256 amount) external returns (bool);
165 
166     /**
167      * @dev Moves `amount` tokens from `from` to `to` using the
168      * allowance mechanism. `amount` is then deducted from the caller's
169      * allowance.
170      *
171      * Returns a boolean value indicating whether the operation succeeded.
172      *
173      * Emits a {Transfer} event.
174      */
175     function transferFrom(
176         address from,
177         address to,
178         uint256 amount
179     ) external returns (bool);
180 
181     /**
182      * @dev Emitted when `value` tokens are moved from one account (`from`) to
183      * another (`to`).
184      *
185      * Note that `value` may be zero.
186      */
187     event Transfer(address indexed from, address indexed to, uint256 value);
188 
189     /**
190      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
191      * a call to {approve}. `value` is the new allowance.
192      */
193     event Approval(
194         address indexed owner,
195         address indexed spender,
196         uint256 value
197     );
198 }
199 
200 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
201 
202 pragma solidity ^0.8.0;
203 
204 /**
205  * @dev Interface for the optional metadata functions from the ERC20 standard.
206  *
207  * _Available since v4.1._
208  */
209 interface IERC20Metadata is IERC20 {
210     /**
211      * @dev Returns the name of the token.
212      */
213     function name() external view returns (string memory);
214 
215     /**
216      * @dev Returns the symbol of the token.
217      */
218     function symbol() external view returns (string memory);
219 
220     /**
221      * @dev Returns the decimals places of the token.
222      */
223     function decimals() external view returns (uint8);
224 }
225 
226 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
227 
228 pragma solidity ^0.8.0;
229 
230 /**
231  * @dev Implementation of the {IERC20} interface.
232  *
233  * This implementation is agnostic to the way tokens are created. This means
234  * that a supply mechanism has to be added in a derived contract using {_mint}.
235  * For a generic mechanism see {ERC20PresetMinterPauser}.
236  *
237  * TIP: For a detailed writeup see our guide
238  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
239  * to implement supply mechanisms].
240  *
241  * We have followed general OpenZeppelin Contracts guidelines: functions revert
242  * instead returning `false` on failure. This behavior is nonetheless
243  * conventional and does not conflict with the expectations of ERC20
244  * applications.
245  *
246  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
247  * This allows applications to reconstruct the allowance for all accounts just
248  * by listening to said events. Other implementations of the EIP may not emit
249  * these events, as it isn't required by the specification.
250  *
251  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
252  * functions have been added to mitigate the well-known issues around setting
253  * allowances. See {IERC20-approve}.
254  */
255 contract ERC20 is Context, IERC20, IERC20Metadata {
256     mapping(address => uint256) private _balances;
257 
258     mapping(address => mapping(address => uint256)) private _allowances;
259 
260     uint256 private _totalSupply;
261 
262     string private _name;
263     string private _symbol;
264 
265     /**
266      * @dev Sets the values for {name} and {symbol}.
267      *
268      * The default value of {decimals} is 18. To select a different value for
269      * {decimals} you should overload it.
270      *
271      * All two of these values are immutable: they can only be set once during
272      * construction.
273      */
274     constructor(string memory name_, string memory symbol_) {
275         _name = name_;
276         _symbol = symbol_;
277     }
278 
279     /**
280      * @dev Returns the name of the token.
281      */
282     function name() public view virtual override returns (string memory) {
283         return _name;
284     }
285 
286     /**
287      * @dev Returns the symbol of the token, usually a shorter version of the
288      * name.
289      */
290     function symbol() public view virtual override returns (string memory) {
291         return _symbol;
292     }
293 
294     /**
295      * @dev Returns the number of decimals used to get its user representation.
296      * For example, if `decimals` equals `2`, a balance of `505` tokens should
297      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
298      *
299      * Tokens usually opt for a value of 18, imitating the relationship between
300      * Ether and Wei. This is the value {ERC20} uses, unless this function is
301      * overridden;
302      *
303      * NOTE: This information is only used for _display_ purposes: it in
304      * no way affects any of the arithmetic of the contract, including
305      * {IERC20-balanceOf} and {IERC20-transfer}.
306      */
307     function decimals() public view virtual override returns (uint8) {
308         return 18;
309     }
310 
311     /**
312      * @dev See {IERC20-totalSupply}.
313      */
314     function totalSupply() public view virtual override returns (uint256) {
315         return _totalSupply;
316     }
317 
318     /**
319      * @dev See {IERC20-balanceOf}.
320      */
321     function balanceOf(address account)
322         public
323         view
324         virtual
325         override
326         returns (uint256)
327     {
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
339     function transfer(address to, uint256 amount)
340         public
341         virtual
342         override
343         returns (bool)
344     {
345         address owner = _msgSender();
346         _transfer(owner, to, amount);
347         return true;
348     }
349 
350     /**
351      * @dev See {IERC20-allowance}.
352      */
353     function allowance(address owner, address spender)
354         public
355         view
356         virtual
357         override
358         returns (uint256)
359     {
360         return _allowances[owner][spender];
361     }
362 
363     /**
364      * @dev See {IERC20-approve}.
365      *
366      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
367      * `transferFrom`. This is semantically equivalent to an infinite approval.
368      *
369      * Requirements:
370      *
371      * - `spender` cannot be the zero address.
372      */
373     function approve(address spender, uint256 amount)
374         public
375         virtual
376         override
377         returns (bool)
378     {
379         address owner = _msgSender();
380         _approve(owner, spender, amount);
381         return true;
382     }
383 
384     /**
385      * @dev See {IERC20-transferFrom}.
386      *
387      * Emits an {Approval} event indicating the updated allowance. This is not
388      * required by the EIP. See the note at the beginning of {ERC20}.
389      *
390      * NOTE: Does not update the allowance if the current allowance
391      * is the maximum `uint256`.
392      *
393      * Requirements:
394      *
395      * - `from` and `to` cannot be the zero address.
396      * - `from` must have a balance of at least `amount`.
397      * - the caller must have allowance for ``from``'s tokens of at least
398      * `amount`.
399      */
400     function transferFrom(
401         address from,
402         address to,
403         uint256 amount
404     ) public virtual override returns (bool) {
405         address spender = _msgSender();
406         _spendAllowance(from, spender, amount);
407         _transfer(from, to, amount);
408         return true;
409     }
410 
411     /**
412      * @dev Atomically increases the allowance granted to `spender` by the caller.
413      *
414      * This is an alternative to {approve} that can be used as a mitigation for
415      * problems described in {IERC20-approve}.
416      *
417      * Emits an {Approval} event indicating the updated allowance.
418      *
419      * Requirements:
420      *
421      * - `spender` cannot be the zero address.
422      */
423     function increaseAllowance(address spender, uint256 addedValue)
424         public
425         virtual
426         returns (bool)
427     {
428         address owner = _msgSender();
429         _approve(owner, spender, _allowances[owner][spender] + addedValue);
430         return true;
431     }
432 
433     /**
434      * @dev Atomically decreases the allowance granted to `spender` by the caller.
435      *
436      * This is an alternative to {approve} that can be used as a mitigation for
437      * problems described in {IERC20-approve}.
438      *
439      * Emits an {Approval} event indicating the updated allowance.
440      *
441      * Requirements:
442      *
443      * - `spender` cannot be the zero address.
444      * - `spender` must have allowance for the caller of at least
445      * `subtractedValue`.
446      */
447     function decreaseAllowance(address spender, uint256 subtractedValue)
448         public
449         virtual
450         returns (bool)
451     {
452         address owner = _msgSender();
453         uint256 currentAllowance = _allowances[owner][spender];
454         require(
455             currentAllowance >= subtractedValue,
456             "ERC20: decreased allowance below zero"
457         );
458         unchecked {
459             _approve(owner, spender, currentAllowance - subtractedValue);
460         }
461 
462         return true;
463     }
464 
465     /**
466      * @dev Moves `amount` of tokens from `sender` to `recipient`.
467      *
468      * This internal function is equivalent to {transfer}, and can be used to
469      * e.g. implement automatic token fees, slashing mechanisms, etc.
470      *
471      * Emits a {Transfer} event.
472      *
473      * Requirements:
474      *
475      * - `from` cannot be the zero address.
476      * - `to` cannot be the zero address.
477      * - `from` must have a balance of at least `amount`.
478      */
479     function _transfer(
480         address from,
481         address to,
482         uint256 amount
483     ) internal virtual {
484         require(from != address(0), "ERC20: transfer from the zero address");
485         require(to != address(0), "ERC20: transfer to the zero address");
486 
487         _beforeTokenTransfer(from, to, amount);
488 
489         uint256 fromBalance = _balances[from];
490         require(
491             fromBalance >= amount,
492             "ERC20: transfer amount exceeds balance"
493         );
494         unchecked {
495             _balances[from] = fromBalance - amount;
496         }
497         _balances[to] += amount;
498 
499         emit Transfer(from, to, amount);
500 
501         _afterTokenTransfer(from, to, amount);
502     }
503 
504     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
505      * the total supply.
506      *
507      * Emits a {Transfer} event with `from` set to the zero address.
508      *
509      * Requirements:
510      *
511      * - `account` cannot be the zero address.
512      */
513     function _mint(address account, uint256 amount) internal virtual {
514         require(account != address(0), "ERC20: mint to the zero address");
515 
516         _beforeTokenTransfer(address(0), account, amount);
517 
518         _totalSupply += amount;
519         _balances[account] += amount;
520         emit Transfer(address(0), account, amount);
521 
522         _afterTokenTransfer(address(0), account, amount);
523     }
524 
525     /**
526      * @dev Destroys `amount` tokens from `account`, reducing the
527      * total supply.
528      *
529      * Emits a {Transfer} event with `to` set to the zero address.
530      *
531      * Requirements:
532      *
533      * - `account` cannot be the zero address.
534      * - `account` must have at least `amount` tokens.
535      */
536     function _burn(address account, uint256 amount) internal virtual {
537         require(account != address(0), "ERC20: burn from the zero address");
538 
539         _beforeTokenTransfer(account, address(0), amount);
540 
541         uint256 accountBalance = _balances[account];
542         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
543         unchecked {
544             _balances[account] = accountBalance - amount;
545         }
546         _totalSupply -= amount;
547 
548         emit Transfer(account, address(0), amount);
549 
550         _afterTokenTransfer(account, address(0), amount);
551     }
552 
553     /**
554      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
555      *
556      * This internal function is equivalent to `approve`, and can be used to
557      * e.g. set automatic allowances for certain subsystems, etc.
558      *
559      * Emits an {Approval} event.
560      *
561      * Requirements:
562      *
563      * - `owner` cannot be the zero address.
564      * - `spender` cannot be the zero address.
565      */
566     function _approve(
567         address owner,
568         address spender,
569         uint256 amount
570     ) internal virtual {
571         require(owner != address(0), "ERC20: approve from the zero address");
572         require(spender != address(0), "ERC20: approve to the zero address");
573 
574         _allowances[owner][spender] = amount;
575         emit Approval(owner, spender, amount);
576     }
577 
578     /**
579      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
580      *
581      * Does not update the allowance amount in case of infinite allowance.
582      * Revert if not enough allowance is available.
583      *
584      * Might emit an {Approval} event.
585      */
586     function _spendAllowance(
587         address owner,
588         address spender,
589         uint256 amount
590     ) internal virtual {
591         uint256 currentAllowance = allowance(owner, spender);
592         if (currentAllowance != type(uint256).max) {
593             require(
594                 currentAllowance >= amount,
595                 "ERC20: insufficient allowance"
596             );
597             unchecked {
598                 _approve(owner, spender, currentAllowance - amount);
599             }
600         }
601     }
602 
603     /**
604      * @dev Hook that is called before any transfer of tokens. This includes
605      * minting and burning.
606      *
607      * Calling conditions:
608      *
609      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
610      * will be transferred to `to`.
611      * - when `from` is zero, `amount` tokens will be minted for `to`.
612      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
613      * - `from` and `to` are never both zero.
614      *
615      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
616      */
617     function _beforeTokenTransfer(
618         address from,
619         address to,
620         uint256 amount
621     ) internal virtual {}
622 
623     /**
624      * @dev Hook that is called after any transfer of tokens. This includes
625      * minting and burning.
626      *
627      * Calling conditions:
628      *
629      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
630      * has been transferred to `to`.
631      * - when `from` is zero, `amount` tokens have been minted for `to`.
632      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
633      * - `from` and `to` are never both zero.
634      *
635      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
636      */
637     function _afterTokenTransfer(
638         address from,
639         address to,
640         uint256 amount
641     ) internal virtual {}
642 }
643 
644 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
645 
646 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
647 
648 pragma solidity ^0.8.0;
649 
650 /**
651  * @title ERC721 token receiver interface
652  * @dev Interface for any contract that wants to support safeTransfers
653  * from ERC721 asset contracts.
654  */
655 interface IERC721Receiver {
656     /**
657      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
658      * by `operator` from `from`, this function is called.
659      *
660      * It must return its Solidity selector to confirm the token transfer.
661      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
662      *
663      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
664      */
665     function onERC721Received(
666         address operator,
667         address from,
668         uint256 tokenId,
669         bytes calldata data
670     ) external returns (bytes4);
671 }
672 
673 pragma solidity 0.8.11;
674 
675 interface ICryptoBearWatchClub {
676     function ownerOf(uint256 tokenId) external view returns (address owner);
677 
678     function safeTransferFrom(
679         address from,
680         address to,
681         uint256 tokenId
682     ) external;
683 }
684 
685 pragma solidity 0.8.11;
686 
687 contract Arkouda is ERC20, Ownable, IERC721Receiver {
688     ICryptoBearWatchClub public CryptoBearWatchClub;
689 
690     enum TX_TYPE {
691         UNSTAKE,
692         CLAIM
693     }
694 
695     bool public stakingLive;
696 
697     uint256 public constant tier1Reward = 30 ether;
698     uint256 public constant tier2Reward = 9 ether;
699     uint256 public constant tier3Reward = 3 ether;
700 
701     // Stores tier of a CBWC NFT.
702     // 0 represents tier 3
703     mapping(uint256 => uint256) public tokenIdTier;
704 
705     // Stores token id staker address
706     mapping(uint256 => address) public tokenOwner;
707 
708     // To store when was the last time user staked or claimed the reward of the token Id
709     mapping(address => mapping(uint256 => uint256)) public lastUpdate;
710 
711     // To store addresses that can burn their Arkouda token
712     mapping(address => bool) public allowedAddresses;
713 
714     event Staked(address indexed staker, uint256[] tokenIds, uint256 stakeTime);
715     event Unstaked(address indexed unstaker, uint256[] tokenIds);
716     event RewardsPaid(
717         address indexed claimer,
718         uint256[] tokenIds,
719         uint256 _tier1Rewards,
720         uint256 _tier2Rewards,
721         uint256 _tier3Rewards
722     );
723 
724     constructor(ICryptoBearWatchClub _cryptoBearWatchClub)
725         ERC20("Arkouda", "$ark")
726     {
727         CryptoBearWatchClub = _cryptoBearWatchClub;
728     }
729 
730     modifier isTokenOwner(uint256[] memory _tokenIds) {
731         for (uint256 i = 0; i < _tokenIds.length; i++) {
732             require(
733                 tokenOwner[_tokenIds[i]] == _msgSender(),
734                 "CALLER_IS_NOT_STAKER"
735             );
736         }
737         _;
738     }
739 
740     modifier isStakingLive() {
741         require(stakingLive, "STAKING_IS_NOT_LIVE_YET");
742         _;
743     }
744 
745     modifier checkInputLength(uint256[] memory _tokenIds) {
746         require(_tokenIds.length > 0, "INVALID_INPUT_LENGTH");
747         _;
748     }
749 
750     // To start staking/ reward generation
751     function startStaking() external onlyOwner {
752         require(!stakingLive, "STAKING_IS_ALREADY_LIVE");
753         stakingLive = true;
754     }
755 
756     // To grant/revoke burn access
757     function setAllowedAddresses(address _address, bool _access)
758         external
759         onlyOwner
760     {
761         allowedAddresses[_address] = _access;
762     }
763 
764     // Sets the tier of CBWC NFTs
765     function setCBWCNFTTier(uint256[] calldata _tokenIds, uint256 _tier)
766         external
767         onlyOwner
768     {
769         require(_tier == 1 || _tier == 2, "INVALID_TIER");
770         for (uint256 i = 0; i < _tokenIds.length; i++) {
771             require(tokenIdTier[_tokenIds[i]] == 0, "TIER_ALREADY_SET");
772             tokenIdTier[_tokenIds[i]] = _tier;
773         }
774     }
775 
776     function onERC721Received(
777         address,
778         address,
779         uint256,
780         bytes memory
781     ) external pure override returns (bytes4) {
782         return this.onERC721Received.selector;
783     }
784 
785     function burn(uint256 amount) external {
786         require(
787             allowedAddresses[_msgSender()],
788             "ADDRESS_DOES_NOT_HAVE_PERMISSION_TO_BURN"
789         );
790         _burn(_msgSender(), amount);
791     }
792 
793     // Stakes CBWC NFTs
794     function stakeCBWC(uint256[] calldata _tokenIds)
795         external
796         isStakingLive
797         checkInputLength(_tokenIds)
798     {
799         for (uint256 i = 0; i < _tokenIds.length; i++) {
800             require(
801                 CryptoBearWatchClub.ownerOf(_tokenIds[i]) == _msgSender(),
802                 "CBWC_NFT_IS_NOT_YOURS"
803             );
804 
805             // Transferring NFT from staker to the contract
806             CryptoBearWatchClub.safeTransferFrom(
807                 _msgSender(),
808                 address(this),
809                 _tokenIds[i]
810             );
811 
812             // Keeping track of token id staker address
813             tokenOwner[_tokenIds[i]] = _msgSender();
814 
815             lastUpdate[_msgSender()][_tokenIds[i]] = block.timestamp;
816         }
817 
818         emit Staked(_msgSender(), _tokenIds, block.timestamp);
819     }
820 
821     // Unstakes CBWC NFTs
822     function unStakeCBWC(uint256[] calldata _tokenIds)
823         external
824         isStakingLive
825         isTokenOwner(_tokenIds)
826         checkInputLength(_tokenIds)
827     {
828         claimOrUnstake(_tokenIds, TX_TYPE.UNSTAKE);
829         emit Unstaked(_msgSender(), _tokenIds);
830     }
831 
832     // To claim reward for staking CBWC NFTs
833     function claimRewards(uint256[] calldata _tokenIds)
834         external
835         isStakingLive
836         isTokenOwner(_tokenIds)
837         checkInputLength(_tokenIds)
838     {
839         claimOrUnstake(_tokenIds, TX_TYPE.CLAIM);
840     }
841 
842     function claimOrUnstake(uint256[] memory _tokenIds, TX_TYPE txType)
843         private
844     {
845         uint256 rewards;
846         uint256 _tier1Rewards;
847         uint256 _tier2Rewards;
848         uint256 _tier3Rewards;
849         uint256 tier;
850 
851         for (uint256 i = 0; i < _tokenIds.length; i++) {
852             (rewards, tier) = getPendingRewardAndTier(_tokenIds[i]);
853             if (tier == 1) {
854                 _tier1Rewards += rewards;
855             } else if (tier == 2) {
856                 _tier2Rewards += rewards;
857             } else {
858                 _tier3Rewards += rewards;
859             }
860 
861             if (txType == TX_TYPE.UNSTAKE) {
862                 // Transferring NFT back to the staker
863                 CryptoBearWatchClub.safeTransferFrom(
864                     address(this),
865                     _msgSender(),
866                     _tokenIds[i]
867                 );
868 
869                 // Resetting token id staker address
870                 tokenOwner[_tokenIds[i]] = address(0);
871 
872                 // Resetting last update timer of token id
873                 // Resetting it so that 'getPendingReward' function returns 0 if you check pending reward of unstaked NFT
874                 lastUpdate[_msgSender()][_tokenIds[i]] = 0;
875             } else {
876                 // Updating last claim time
877                 lastUpdate[_msgSender()][_tokenIds[i]] = block.timestamp;
878             }
879         }
880         _mint(_msgSender(), (_tier1Rewards + _tier2Rewards + _tier3Rewards));
881         emit RewardsPaid(
882             _msgSender(),
883             _tokenIds,
884             _tier1Rewards,
885             _tier2Rewards,
886             _tier3Rewards
887         );
888     }
889 
890     // Returns total pending rewards of all input token ids
891     function getTotalClaimable(uint256[] memory _tokenIds)
892         external
893         view
894         returns (uint256 totalRewards)
895     {
896         for (uint256 i = 0; i < _tokenIds.length; i++) {
897             totalRewards += getPendingReward(_tokenIds[i]);
898         }
899     }
900 
901     // Returns pending accumulated reward of the token id
902     function getPendingReward(uint256 _tokenId)
903         public
904         view
905         returns (uint256 reward)
906     {
907         if (lastUpdate[_msgSender()][_tokenId] == 0) {
908             return 0;
909         }
910         (reward, ) = getPendingRewardAndTier(_tokenId);
911     }
912 
913     // Returns pending accumulated reward of the token id along with token id tier
914     function getPendingRewardAndTier(uint256 _tokenId)
915         private
916         view
917         returns (uint256 rewards, uint256 tier)
918     {
919         uint256 secondsHeld = block.timestamp -
920             lastUpdate[_msgSender()][_tokenId];
921 
922         if (tokenIdTier[_tokenId] == 1) {
923             return (((tier1Reward * secondsHeld) / 86400), 1);
924         } else if (tokenIdTier[_tokenId] == 2) {
925             return (((tier2Reward * secondsHeld) / 86400), 2);
926         } else {
927             return (((tier3Reward * secondsHeld) / 86400), 3);
928         }
929     }
930 }