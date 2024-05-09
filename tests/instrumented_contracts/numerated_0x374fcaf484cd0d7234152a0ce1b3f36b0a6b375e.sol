1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-09
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 //   _________       __               .__    .__  __________                                         
8 //  /   _____/____ _/  |_  ____  _____|  |__ |__| \______   \__ __  ____   ____   ___________  ______
9 //  \_____  \\__  \\   __\/  _ \/  ___/  |  \|  |  |       _/  |  \/    \ /    \_/ __ \_  __ \/  ___/
10 //  /        \/ __ \|  | (  <_> )___ \|   Y  \  |  |    |   \  |  /   |  \   |  \  ___/|  | \/\___ \ 
11 // /_______  (____  /__|  \____/____  >___|  /__|  |____|_  /____/|___|  /___|  /\___  >__|  /____  >
12 //         \/     \/                \/     \/             \/           \/     \/     \/           \/ 
13 
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev Provides information about the current execution context, including the
19  * sender of the transaction and its data. While these are generally available
20  * via msg.sender and msg.data, they should not be accessed in such a direct
21  * manner, since when dealing with meta-transactions the account sending and
22  * paying for execution may not be the actual sender (as far as an application
23  * is concerned).
24  *
25  * This contract is only required for intermediate, library-like contracts.
26  */
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal view virtual returns (bytes calldata) {
33         return msg.data;
34     }
35 }
36 
37 // File: @openzeppelin/contracts/access/Ownable.sol
38 
39 
40 
41 pragma solidity ^0.8.0;
42 
43 
44 /**
45  * @dev Contract module which provides a basic access control mechanism, where
46  * there is an account (an owner) that can be granted exclusive access to
47  * specific functions.
48  *
49  * By default, the owner account will be the one that deploys the contract. This
50  * can later be changed with {transferOwnership}.
51  *
52  * This module is used through inheritance. It will make available the modifier
53  * `onlyOwner`, which can be applied to your functions to restrict their use to
54  * the owner.
55  */
56 abstract contract Ownable is Context {
57     address private _owner;
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     /**
62      * @dev Initializes the contract setting the deployer as the initial owner.
63      */
64     constructor() {
65         _setOwner(_msgSender());
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if called by any account other than the owner.
77      */
78     modifier onlyOwner() {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80         _;
81     }
82 
83     /**
84      * @dev Leaves the contract without owner. It will not be possible to call
85      * `onlyOwner` functions anymore. Can only be called by the current owner.
86      *
87      * NOTE: Renouncing ownership will leave the contract without an owner,
88      * thereby removing any functionality that is only available to the owner.
89      */
90     function renounceOwnership() public virtual onlyOwner {
91         _setOwner(address(0));
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Can only be called by the current owner.
97      */
98     function transferOwnership(address newOwner) public virtual onlyOwner {
99         require(newOwner != address(0), "Ownable: new owner is the zero address");
100         _setOwner(newOwner);
101     }
102 
103     function _setOwner(address newOwner) private {
104         address oldOwner = _owner;
105         _owner = newOwner;
106         emit OwnershipTransferred(oldOwner, newOwner);
107     }
108 }
109 
110 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
111 
112 
113 
114 pragma solidity ^0.8.0;
115 
116 /**
117  * @dev Interface of the ERC20 standard as defined in the EIP.
118  */
119 interface IERC20 {
120     /**
121      * @dev Returns the amount of tokens in existence.
122      */
123     function totalSupply() external view returns (uint256);
124 
125     /**
126      * @dev Returns the amount of tokens owned by `account`.
127      */
128     function balanceOf(address account) external view returns (uint256);
129 
130     /**
131      * @dev Moves `amount` tokens from the caller's account to `recipient`.
132      *
133      * Returns a boolean value indicating whether the operation succeeded.
134      *
135      * Emits a {Transfer} event.
136      */
137     function transfer(address recipient, uint256 amount) external returns (bool);
138 
139     /**
140      * @dev Returns the remaining number of tokens that `spender` will be
141      * allowed to spend on behalf of `owner` through {transferFrom}. This is
142      * zero by default.
143      *
144      * This value changes when {approve} or {transferFrom} are called.
145      */
146     function allowance(address owner, address spender) external view returns (uint256);
147 
148     /**
149      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * IMPORTANT: Beware that changing an allowance with this method brings the risk
154      * that someone may use both the old and the new allowance by unfortunate
155      * transaction ordering. One possible solution to mitigate this race
156      * condition is to first reduce the spender's allowance to 0 and set the
157      * desired value afterwards:
158      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159      *
160      * Emits an {Approval} event.
161      */
162     function approve(address spender, uint256 amount) external returns (bool);
163 
164     /**
165      * @dev Moves `amount` tokens from `sender` to `recipient` using the
166      * allowance mechanism. `amount` is then deducted from the caller's
167      * allowance.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * Emits a {Transfer} event.
172      */
173     function transferFrom(
174         address sender,
175         address recipient,
176         uint256 amount
177     ) external returns (bool);
178 
179     /**
180      * @dev Emitted when `value` tokens are moved from one account (`from`) to
181      * another (`to`).
182      *
183      * Note that `value` may be zero.
184      */
185     event Transfer(address indexed from, address indexed to, uint256 value);
186 
187     /**
188      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
189      * a call to {approve}. `value` is the new allowance.
190      */
191     event Approval(address indexed owner, address indexed spender, uint256 value);
192 }
193 
194 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
195 
196 
197 
198 pragma solidity ^0.8.0;
199 
200 
201 /**
202  * @dev Interface for the optional metadata functions from the ERC20 standard.
203  *
204  * _Available since v4.1._
205  */
206 interface IERC20Metadata is IERC20 {
207     /**
208      * @dev Returns the name of the token.
209      */
210     function name() external view returns (string memory);
211 
212     /**
213      * @dev Returns the symbol of the token.
214      */
215     function symbol() external view returns (string memory);
216 
217     /**
218      * @dev Returns the decimals places of the token.
219      */
220     function decimals() external view returns (uint8);
221 }
222 
223 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
224 
225 
226 
227 pragma solidity ^0.8.0;
228 
229 
230 
231 
232 /**
233  * @dev Implementation of the {IERC20} interface.
234  *
235  * This implementation is agnostic to the way tokens are created. This means
236  * that a supply mechanism has to be added in a derived contract using {_mint}.
237  * For a generic mechanism see {ERC20PresetMinterPauser}.
238  *
239  * TIP: For a detailed writeup see our guide
240  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
241  * to implement supply mechanisms].
242  *
243  * We have followed general OpenZeppelin Contracts guidelines: functions revert
244  * instead returning `false` on failure. This behavior is nonetheless
245  * conventional and does not conflict with the expectations of ERC20
246  * applications.
247  *
248  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
249  * This allows applications to reconstruct the allowance for all accounts just
250  * by listening to said events. Other implementations of the EIP may not emit
251  * these events, as it isn't required by the specification.
252  *
253  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
254  * functions have been added to mitigate the well-known issues around setting
255  * allowances. See {IERC20-approve}.
256  */
257 contract ERC20 is Context, IERC20, IERC20Metadata {
258     mapping(address => uint256) private _balances;
259 
260     mapping(address => mapping(address => uint256)) private _allowances;
261 
262     uint256 private _totalSupply;
263 
264     string private _name;
265     string private _symbol;
266 
267     /**
268      * @dev Sets the values for {name} and {symbol}.
269      *
270      * The default value of {decimals} is 18. To select a different value for
271      * {decimals} you should overload it.
272      *
273      * All two of these values are immutable: they can only be set once during
274      * construction.
275      */
276     constructor(string memory name_, string memory symbol_) {
277         _name = name_;
278         _symbol = symbol_;
279     }
280 
281     /**
282      * @dev Returns the name of the token.
283      */
284     function name() public view virtual override returns (string memory) {
285         return _name;
286     }
287 
288     /**
289      * @dev Returns the symbol of the token, usually a shorter version of the
290      * name.
291      */
292     function symbol() public view virtual override returns (string memory) {
293         return _symbol;
294     }
295 
296     /**
297      * @dev Returns the number of decimals used to get its user representation.
298      * For example, if `decimals` equals `2`, a balance of `505` tokens should
299      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
300      *
301      * Tokens usually opt for a value of 18, imitating the relationship between
302      * Ether and Wei. This is the value {ERC20} uses, unless this function is
303      * overridden;
304      *
305      * NOTE: This information is only used for _display_ purposes: it in
306      * no way affects any of the arithmetic of the contract, including
307      * {IERC20-balanceOf} and {IERC20-transfer}.
308      */
309     function decimals() public view virtual override returns (uint8) {
310         return 18;
311     }
312 
313     /**
314      * @dev See {IERC20-totalSupply}.
315      */
316     function totalSupply() public view virtual override returns (uint256) {
317         return _totalSupply;
318     }
319 
320     /**
321      * @dev See {IERC20-balanceOf}.
322      */
323     function balanceOf(address account) public view virtual override returns (uint256) {
324         return _balances[account];
325     }
326 
327     /**
328      * @dev See {IERC20-transfer}.
329      *
330      * Requirements:
331      *
332      * - `recipient` cannot be the zero address.
333      * - the caller must have a balance of at least `amount`.
334      */
335     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
336         _transfer(_msgSender(), recipient, amount);
337         return true;
338     }
339 
340     /**
341      * @dev See {IERC20-allowance}.
342      */
343     function allowance(address owner, address spender) public view virtual override returns (uint256) {
344         return _allowances[owner][spender];
345     }
346 
347     /**
348      * @dev See {IERC20-approve}.
349      *
350      * Requirements:
351      *
352      * - `spender` cannot be the zero address.
353      */
354     function approve(address spender, uint256 amount) public virtual override returns (bool) {
355         _approve(_msgSender(), spender, amount);
356         return true;
357     }
358 
359     /**
360      * @dev See {IERC20-transferFrom}.
361      *
362      * Emits an {Approval} event indicating the updated allowance. This is not
363      * required by the EIP. See the note at the beginning of {ERC20}.
364      *
365      * Requirements:
366      *
367      * - `sender` and `recipient` cannot be the zero address.
368      * - `sender` must have a balance of at least `amount`.
369      * - the caller must have allowance for ``sender``'s tokens of at least
370      * `amount`.
371      */
372     function transferFrom(
373         address sender,
374         address recipient,
375         uint256 amount
376     ) public virtual override returns (bool) {
377         _transfer(sender, recipient, amount);
378 
379         uint256 currentAllowance = _allowances[sender][_msgSender()];
380         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
381         unchecked {
382             _approve(sender, _msgSender(), currentAllowance - amount);
383         }
384 
385         return true;
386     }
387 
388     /**
389      * @dev Atomically increases the allowance granted to `spender` by the caller.
390      *
391      * This is an alternative to {approve} that can be used as a mitigation for
392      * problems described in {IERC20-approve}.
393      *
394      * Emits an {Approval} event indicating the updated allowance.
395      *
396      * Requirements:
397      *
398      * - `spender` cannot be the zero address.
399      */
400     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
401         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
402         return true;
403     }
404 
405     /**
406      * @dev Atomically decreases the allowance granted to `spender` by the caller.
407      *
408      * This is an alternative to {approve} that can be used as a mitigation for
409      * problems described in {IERC20-approve}.
410      *
411      * Emits an {Approval} event indicating the updated allowance.
412      *
413      * Requirements:
414      *
415      * - `spender` cannot be the zero address.
416      * - `spender` must have allowance for the caller of at least
417      * `subtractedValue`.
418      */
419     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
420         uint256 currentAllowance = _allowances[_msgSender()][spender];
421         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
422         unchecked {
423             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
424         }
425 
426         return true;
427     }
428 
429     /**
430      * @dev Moves `amount` of tokens from `sender` to `recipient`.
431      *
432      * This internal function is equivalent to {transfer}, and can be used to
433      * e.g. implement automatic token fees, slashing mechanisms, etc.
434      *
435      * Emits a {Transfer} event.
436      *
437      * Requirements:
438      *
439      * - `sender` cannot be the zero address.
440      * - `recipient` cannot be the zero address.
441      * - `sender` must have a balance of at least `amount`.
442      */
443     function _transfer(
444         address sender,
445         address recipient,
446         uint256 amount
447     ) internal virtual {
448         require(sender != address(0), "ERC20: transfer from the zero address");
449         require(recipient != address(0), "ERC20: transfer to the zero address");
450 
451         _beforeTokenTransfer(sender, recipient, amount);
452 
453         uint256 senderBalance = _balances[sender];
454         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
455         unchecked {
456             _balances[sender] = senderBalance - amount;
457         }
458         _balances[recipient] += amount;
459 
460         emit Transfer(sender, recipient, amount);
461 
462         _afterTokenTransfer(sender, recipient, amount);
463     }
464 
465     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
466      * the total supply.
467      *
468      * Emits a {Transfer} event with `from` set to the zero address.
469      *
470      * Requirements:
471      *
472      * - `account` cannot be the zero address.
473      */
474     function _mint(address account, uint256 amount) internal virtual {
475         require(account != address(0), "ERC20: mint to the zero address");
476 
477         _beforeTokenTransfer(address(0), account, amount);
478 
479         _totalSupply += amount;
480         _balances[account] += amount;
481         emit Transfer(address(0), account, amount);
482 
483         _afterTokenTransfer(address(0), account, amount);
484     }
485 
486     /**
487      * @dev Destroys `amount` tokens from `account`, reducing the
488      * total supply.
489      *
490      * Emits a {Transfer} event with `to` set to the zero address.
491      *
492      * Requirements:
493      *
494      * - `account` cannot be the zero address.
495      * - `account` must have at least `amount` tokens.
496      */
497     function _burn(address account, uint256 amount) internal virtual {
498         require(account != address(0), "ERC20: burn from the zero address");
499 
500         _beforeTokenTransfer(account, address(0), amount);
501 
502         uint256 accountBalance = _balances[account];
503         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
504         unchecked {
505             _balances[account] = accountBalance - amount;
506         }
507         _totalSupply -= amount;
508 
509         emit Transfer(account, address(0), amount);
510 
511         _afterTokenTransfer(account, address(0), amount);
512     }
513 
514     /**
515      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
516      *
517      * This internal function is equivalent to `approve`, and can be used to
518      * e.g. set automatic allowances for certain subsystems, etc.
519      *
520      * Emits an {Approval} event.
521      *
522      * Requirements:
523      *
524      * - `owner` cannot be the zero address.
525      * - `spender` cannot be the zero address.
526      */
527     function _approve(
528         address owner,
529         address spender,
530         uint256 amount
531     ) internal virtual {
532         require(owner != address(0), "ERC20: approve from the zero address");
533         require(spender != address(0), "ERC20: approve to the zero address");
534 
535         _allowances[owner][spender] = amount;
536         emit Approval(owner, spender, amount);
537     }
538 
539     /**
540      * @dev Hook that is called before any transfer of tokens. This includes
541      * minting and burning.
542      *
543      * Calling conditions:
544      *
545      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
546      * will be transferred to `to`.
547      * - when `from` is zero, `amount` tokens will be minted for `to`.
548      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
549      * - `from` and `to` are never both zero.
550      *
551      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
552      */
553     function _beforeTokenTransfer(
554         address from,
555         address to,
556         uint256 amount
557     ) internal virtual {}
558 
559     /**
560      * @dev Hook that is called after any transfer of tokens. This includes
561      * minting and burning.
562      *
563      * Calling conditions:
564      *
565      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
566      * has been transferred to `to`.
567      * - when `from` is zero, `amount` tokens have been minted for `to`.
568      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
569      * - `from` and `to` are never both zero.
570      *
571      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
572      */
573     function _afterTokenTransfer(
574         address from,
575         address to,
576         uint256 amount
577     ) internal virtual {}
578 }
579 
580 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
581 
582 
583 
584 pragma solidity ^0.8.0;
585 
586 
587 
588 /**
589  * @dev Extension of {ERC20} that allows token holders to destroy both their own
590  * tokens and those that they have an allowance for, in a way that can be
591  * recognized off-chain (via event analysis).
592  */
593 abstract contract ERC20Burnable is Context, ERC20 {
594     /**
595      * @dev Destroys `amount` tokens from the caller.
596      *
597      * See {ERC20-_burn}.
598      */
599     function burn(uint256 amount) public virtual {
600         _burn(_msgSender(), amount);
601     }
602 
603     /**
604      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
605      * allowance.
606      *
607      * See {ERC20-_burn} and {ERC20-allowance}.
608      *
609      * Requirements:
610      *
611      * - the caller must have allowance for ``accounts``'s tokens of at least
612      * `amount`.
613      */
614     function burnFrom(address account, uint256 amount) public virtual {
615         uint256 currentAllowance = allowance(account, _msgSender());
616         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
617         unchecked {
618             _approve(account, _msgSender(), currentAllowance - amount);
619         }
620         _burn(account, amount);
621     }
622 }
623 
624 pragma solidity ^0.8.4;
625 
626 
627 
628 interface ISatoshiRunners {
629     function transferFrom(address _from, address _to, uint256 _tokenId) external;
630 }
631 
632 contract SatoshiStaking is ERC20Burnable, Ownable {
633     uint256 public constant MAX_SUPPLY = 350000000 * 1 ether;
634     uint256 public constant LEGENDARY_EMISSION_RATE = 200; // 200 per day
635     uint256 public constant RUNNERS_EMISSION_RATE = 10; // 10 per day
636     address public constant RUNNERS_ADDRESS = 0x080CE3620a3cfed6119D6c8DB0F9A56e52451729;
637     bool public live = false;
638 
639     mapping(uint256 => uint256) internal runnersTimeStaked;
640     mapping(uint256 => address) internal runnersStaker;
641     mapping(address => uint256[]) internal stakerToRunner;
642         
643     ISatoshiRunners private constant _satoshiRunnersContract = ISatoshiRunners(RUNNERS_ADDRESS);
644 
645     constructor() ERC20("Satoshi", "SAT") {
646     }
647 
648     modifier stakingEnabled {
649         require(live, "NOT_LIVE");
650         _;
651     }
652 
653     function getStakedRunners(address staker) public view returns (uint256[] memory) {
654         return stakerToRunner[staker];
655     }
656     
657     function getStakedAmount(address staker) public view returns (uint256) {
658         return stakerToRunner[staker].length;
659     }
660 
661     function getStaker(uint256 tokenId) public view returns (address) {
662         return runnersStaker[tokenId];
663     }
664 
665     function getAllRewards(address staker) public view returns (uint256) {
666         uint256 totalRewards = 0;
667         
668         //calculate bonus
669         uint256 bonus = _getBonus(staker);
670 
671         uint256[] memory runnersTokens = stakerToRunner[staker];
672         for (uint256 i = 0; i < runnersTokens.length; i++) {
673             totalRewards += getReward(runnersTokens[i]);
674         }
675 
676         totalRewards += (bonus * totalRewards) / 100;
677         return totalRewards;
678     }
679 
680     function stakeRunnersById(uint256[] calldata tokenIds) external stakingEnabled {
681         for (uint256 i = 0; i < tokenIds.length; i++) {
682             uint256 id = tokenIds[i];
683             _satoshiRunnersContract.transferFrom(msg.sender, address(this), id);
684 
685             stakerToRunner[msg.sender].push(id);
686             runnersTimeStaked[id] = block.timestamp;
687             runnersStaker[id] = msg.sender;
688         }
689     }
690 
691     function unstakeRunnersByIds(uint256[] calldata tokenIds) external {
692         uint256 totalRewards = 0;
693 
694         //calculate bonus
695         uint256 bonus = _getBonus(msg.sender);
696 
697         for (uint256 i = 0; i < tokenIds.length; i++) {
698             uint256 id = tokenIds[i];
699             require(runnersStaker[id] == msg.sender, "NEEDS_TO_BE_OWNER");
700 
701             _satoshiRunnersContract.transferFrom(address(this), msg.sender, id);
702             totalRewards += getReward(id);
703 
704             removeTokenIdFromArray(stakerToRunner[msg.sender], id);
705             runnersStaker[id] = address(0);
706         }
707 
708         uint256 remaining = MAX_SUPPLY - totalSupply();
709         totalRewards += (bonus * totalRewards) / 100;
710 
711         _mint(msg.sender, totalRewards > remaining ? remaining : totalRewards);
712     }
713 
714     function unstakeAll() external {
715         require(getStakedAmount(msg.sender) > 0, "NONE_STAKED");
716         uint256 totalRewards = 0;
717 
718         //calculate bonus
719         uint256 bonus = _getBonus(msg.sender);
720 
721         for (uint256 i = stakerToRunner[msg.sender].length; i > 0; i--) {
722             uint256 id = stakerToRunner[msg.sender][i - 1];
723 
724             _satoshiRunnersContract.transferFrom(address(this), msg.sender, id);
725             totalRewards += getReward(id);
726 
727             stakerToRunner[msg.sender].pop();
728             runnersStaker[id] = address(0);
729         }
730 
731         uint256 remaining = MAX_SUPPLY - totalSupply();
732         totalRewards += (bonus * totalRewards) / 100;
733         
734         _mint(msg.sender, totalRewards > remaining ? remaining : totalRewards);
735     }
736 
737     function claimAll() external {
738         uint256 totalRewards = 0;
739 
740         //calculate bonus
741         uint256 bonus = _getBonus(msg.sender);
742 
743         uint256[] memory runnersTokens = stakerToRunner[msg.sender];
744         for (uint256 i = 0; i < runnersTokens.length; i++) {
745             uint256 id = runnersTokens[i];
746 
747             totalRewards += getReward(id);
748             runnersTimeStaked[id] = block.timestamp;
749         }
750 
751         uint256 remaining = MAX_SUPPLY - totalSupply();
752         totalRewards += (bonus * totalRewards) / 100;
753         
754         _mint(msg.sender, totalRewards > remaining ? remaining : totalRewards);
755     }
756 
757     function burn(address from, uint256 amount) external {
758         require(msg.sender == RUNNERS_ADDRESS, "NOT_AUTHORIZED");
759 
760         _burn(from, amount);
761     }
762     
763     function toggle() external onlyOwner {
764         live = !live;
765     }
766 
767     function mint(address to, uint256 value) external onlyOwner {
768         uint256 remaining = MAX_SUPPLY - totalSupply();
769         _mint(to, value > remaining ? remaining : value);
770     }
771 
772     function getReward(uint256 tokenId) internal view returns(uint256) {
773         uint256 EMISSION_RATE;
774         uint256 stakedTime = block.timestamp - runnersTimeStaked[tokenId];
775         uint256 daysBonus;
776         uint256 reward;
777         
778         if (stakedTime < 30 days) {
779             daysBonus = 0;
780         } else if (stakedTime < 45 days) {
781             daysBonus = 10;
782         } else if (stakedTime < 60 days) {
783             daysBonus = 30;
784         } else {
785             daysBonus = 50;
786         }
787         if (tokenId == 0 || tokenId == 1 || tokenId == 2 || tokenId == 417 || tokenId == 1095 || tokenId == 1389 || tokenId == 1856 || tokenId == 2563 || tokenId == 6396 || tokenId == 6673) {
788             EMISSION_RATE = LEGENDARY_EMISSION_RATE;
789         } else {
790             EMISSION_RATE = RUNNERS_EMISSION_RATE;
791         }
792 
793         reward = stakedTime * EMISSION_RATE / 86400 * 1 ether; 
794         reward += (daysBonus * reward) / 100;
795 
796         return reward;
797     }
798 
799     function removeTokenIdFromArray(uint256[] storage array, uint256 tokenId) internal {
800         uint256 length = array.length;
801         for (uint256 i = 0; i < length; i++) {
802             if (array[i] == tokenId) {
803                 length--;
804                 if (i < length) {
805                     array[i] = array[length];
806                 }
807                 array.pop();
808                 break;
809             }
810         }
811     }
812 
813     function _getBonus(address staker) internal view returns (uint256 bonus) {
814         uint256 balance = getStakedAmount(staker);
815 
816         if (balance < 5) return 0;
817         if (balance < 10) return 20;
818         if (balance < 20) return 50;
819         return 100;
820     }
821 }