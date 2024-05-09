1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 
5 
6 
7 pragma solidity ^0.8.0;
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
31 
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _setOwner(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _setOwner(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _setOwner(newOwner);
93     }
94 
95     function _setOwner(address newOwner) private {
96         address oldOwner = _owner;
97         _owner = newOwner;
98         emit OwnershipTransferred(oldOwner, newOwner);
99     }
100 }
101 
102 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
103 
104 
105 
106 pragma solidity ^0.8.0;
107 
108 /**
109  * @dev Interface of the ERC20 standard as defined in the EIP.
110  */
111 interface IERC20 {
112     /**
113      * @dev Returns the amount of tokens in existence.
114      */
115     function totalSupply() external view returns (uint256);
116 
117     /**
118      * @dev Returns the amount of tokens owned by `account`.
119      */
120     function balanceOf(address account) external view returns (uint256);
121 
122     /**
123      * @dev Moves `amount` tokens from the caller's account to `recipient`.
124      *
125      * Returns a boolean value indicating whether the operation succeeded.
126      *
127      * Emits a {Transfer} event.
128      */
129     function transfer(address recipient, uint256 amount) external returns (bool);
130 
131     /**
132      * @dev Returns the remaining number of tokens that `spender` will be
133      * allowed to spend on behalf of `owner` through {transferFrom}. This is
134      * zero by default.
135      *
136      * This value changes when {approve} or {transferFrom} are called.
137      */
138     function allowance(address owner, address spender) external view returns (uint256);
139 
140     /**
141      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * IMPORTANT: Beware that changing an allowance with this method brings the risk
146      * that someone may use both the old and the new allowance by unfortunate
147      * transaction ordering. One possible solution to mitigate this race
148      * condition is to first reduce the spender's allowance to 0 and set the
149      * desired value afterwards:
150      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151      *
152      * Emits an {Approval} event.
153      */
154     function approve(address spender, uint256 amount) external returns (bool);
155 
156     /**
157      * @dev Moves `amount` tokens from `sender` to `recipient` using the
158      * allowance mechanism. `amount` is then deducted from the caller's
159      * allowance.
160      *
161      * Returns a boolean value indicating whether the operation succeeded.
162      *
163      * Emits a {Transfer} event.
164      */
165     function transferFrom(
166         address sender,
167         address recipient,
168         uint256 amount
169     ) external returns (bool);
170 
171     /**
172      * @dev Emitted when `value` tokens are moved from one account (`from`) to
173      * another (`to`).
174      *
175      * Note that `value` may be zero.
176      */
177     event Transfer(address indexed from, address indexed to, uint256 value);
178 
179     /**
180      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
181      * a call to {approve}. `value` is the new allowance.
182      */
183     event Approval(address indexed owner, address indexed spender, uint256 value);
184 }
185 
186 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
187 
188 
189 
190 pragma solidity ^0.8.0;
191 
192 
193 /**
194  * @dev Interface for the optional metadata functions from the ERC20 standard.
195  *
196  * _Available since v4.1._
197  */
198 interface IERC20Metadata is IERC20 {
199     /**
200      * @dev Returns the name of the token.
201      */
202     function name() external view returns (string memory);
203 
204     /**
205      * @dev Returns the symbol of the token.
206      */
207     function symbol() external view returns (string memory);
208 
209     /**
210      * @dev Returns the decimals places of the token.
211      */
212     function decimals() external view returns (uint8);
213 }
214 
215 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
216 
217 
218 
219 pragma solidity ^0.8.0;
220 
221 
222 
223 
224 /**
225  * @dev Implementation of the {IERC20} interface.
226  *
227  * This implementation is agnostic to the way tokens are created. This means
228  * that a supply mechanism has to be added in a derived contract using {_mint}.
229  * For a generic mechanism see {ERC20PresetMinterPauser}.
230  *
231  * TIP: For a detailed writeup see our guide
232  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
233  * to implement supply mechanisms].
234  *
235  * We have followed general OpenZeppelin Contracts guidelines: functions revert
236  * instead returning `false` on failure. This behavior is nonetheless
237  * conventional and does not conflict with the expectations of ERC20
238  * applications.
239  *
240  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
241  * This allows applications to reconstruct the allowance for all accounts just
242  * by listening to said events. Other implementations of the EIP may not emit
243  * these events, as it isn't required by the specification.
244  *
245  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
246  * functions have been added to mitigate the well-known issues around setting
247  * allowances. See {IERC20-approve}.
248  */
249 contract ERC20 is Context, IERC20, IERC20Metadata {
250     mapping(address => uint256) private _balances;
251 
252     mapping(address => mapping(address => uint256)) private _allowances;
253 
254     uint256 private _totalSupply;
255 
256     string private _name;
257     string private _symbol;
258 
259     /**
260      * @dev Sets the values for {name} and {symbol}.
261      *
262      * The default value of {decimals} is 18. To select a different value for
263      * {decimals} you should overload it.
264      *
265      * All two of these values are immutable: they can only be set once during
266      * construction.
267      */
268     constructor(string memory name_, string memory symbol_) {
269         _name = name_;
270         _symbol = symbol_;
271     }
272 
273     /**
274      * @dev Returns the name of the token.
275      */
276     function name() public view virtual override returns (string memory) {
277         return _name;
278     }
279 
280     /**
281      * @dev Returns the symbol of the token, usually a shorter version of the
282      * name.
283      */
284     function symbol() public view virtual override returns (string memory) {
285         return _symbol;
286     }
287 
288     /**
289      * @dev Returns the number of decimals used to get its user representation.
290      * For example, if `decimals` equals `2`, a balance of `505` tokens should
291      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
292      *
293      * Tokens usually opt for a value of 18, imitating the relationship between
294      * Ether and Wei. This is the value {ERC20} uses, unless this function is
295      * overridden;
296      *
297      * NOTE: This information is only used for _display_ purposes: it in
298      * no way affects any of the arithmetic of the contract, including
299      * {IERC20-balanceOf} and {IERC20-transfer}.
300      */
301     function decimals() public view virtual override returns (uint8) {
302         return 18;
303     }
304 
305     /**
306      * @dev See {IERC20-totalSupply}.
307      */
308     function totalSupply() public view virtual override returns (uint256) {
309         return _totalSupply;
310     }
311 
312     /**
313      * @dev See {IERC20-balanceOf}.
314      */
315     function balanceOf(address account) public view virtual override returns (uint256) {
316         return _balances[account];
317     }
318 
319     /**
320      * @dev See {IERC20-transfer}.
321      *
322      * Requirements:
323      *
324      * - `recipient` cannot be the zero address.
325      * - the caller must have a balance of at least `amount`.
326      */
327     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
328         _transfer(_msgSender(), recipient, amount);
329         return true;
330     }
331 
332     /**
333      * @dev See {IERC20-allowance}.
334      */
335     function allowance(address owner, address spender) public view virtual override returns (uint256) {
336         return _allowances[owner][spender];
337     }
338 
339     /**
340      * @dev See {IERC20-approve}.
341      *
342      * Requirements:
343      *
344      * - `spender` cannot be the zero address.
345      */
346     function approve(address spender, uint256 amount) public virtual override returns (bool) {
347         _approve(_msgSender(), spender, amount);
348         return true;
349     }
350 
351     /**
352      * @dev See {IERC20-transferFrom}.
353      *
354      * Emits an {Approval} event indicating the updated allowance. This is not
355      * required by the EIP. See the note at the beginning of {ERC20}.
356      *
357      * Requirements:
358      *
359      * - `sender` and `recipient` cannot be the zero address.
360      * - `sender` must have a balance of at least `amount`.
361      * - the caller must have allowance for ``sender``'s tokens of at least
362      * `amount`.
363      */
364     function transferFrom(
365         address sender,
366         address recipient,
367         uint256 amount
368     ) public virtual override returns (bool) {
369         _transfer(sender, recipient, amount);
370 
371         uint256 currentAllowance = _allowances[sender][_msgSender()];
372         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
373         unchecked {
374             _approve(sender, _msgSender(), currentAllowance - amount);
375         }
376 
377         return true;
378     }
379 
380     /**
381      * @dev Atomically increases the allowance granted to `spender` by the caller.
382      *
383      * This is an alternative to {approve} that can be used as a mitigation for
384      * problems described in {IERC20-approve}.
385      *
386      * Emits an {Approval} event indicating the updated allowance.
387      *
388      * Requirements:
389      *
390      * - `spender` cannot be the zero address.
391      */
392     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
393         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
394         return true;
395     }
396 
397     /**
398      * @dev Atomically decreases the allowance granted to `spender` by the caller.
399      *
400      * This is an alternative to {approve} that can be used as a mitigation for
401      * problems described in {IERC20-approve}.
402      *
403      * Emits an {Approval} event indicating the updated allowance.
404      *
405      * Requirements:
406      *
407      * - `spender` cannot be the zero address.
408      * - `spender` must have allowance for the caller of at least
409      * `subtractedValue`.
410      */
411     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
412         uint256 currentAllowance = _allowances[_msgSender()][spender];
413         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
414         unchecked {
415             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
416         }
417 
418         return true;
419     }
420 
421     /**
422      * @dev Moves `amount` of tokens from `sender` to `recipient`.
423      *
424      * This internal function is equivalent to {transfer}, and can be used to
425      * e.g. implement automatic token fees, slashing mechanisms, etc.
426      *
427      * Emits a {Transfer} event.
428      *
429      * Requirements:
430      *
431      * - `sender` cannot be the zero address.
432      * - `recipient` cannot be the zero address.
433      * - `sender` must have a balance of at least `amount`.
434      */
435     function _transfer(
436         address sender,
437         address recipient,
438         uint256 amount
439     ) internal virtual {
440         require(sender != address(0), "ERC20: transfer from the zero address");
441         require(recipient != address(0), "ERC20: transfer to the zero address");
442 
443         _beforeTokenTransfer(sender, recipient, amount);
444 
445         uint256 senderBalance = _balances[sender];
446         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
447         unchecked {
448             _balances[sender] = senderBalance - amount;
449         }
450         _balances[recipient] += amount;
451 
452         emit Transfer(sender, recipient, amount);
453 
454         _afterTokenTransfer(sender, recipient, amount);
455     }
456 
457     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
458      * the total supply.
459      *
460      * Emits a {Transfer} event with `from` set to the zero address.
461      *
462      * Requirements:
463      *
464      * - `account` cannot be the zero address.
465      */
466     function _mint(address account, uint256 amount) internal virtual {
467         require(account != address(0), "ERC20: mint to the zero address");
468 
469         _beforeTokenTransfer(address(0), account, amount);
470 
471         _totalSupply += amount;
472         _balances[account] += amount;
473         emit Transfer(address(0), account, amount);
474 
475         _afterTokenTransfer(address(0), account, amount);
476     }
477 
478     /**
479      * @dev Destroys `amount` tokens from `account`, reducing the
480      * total supply.
481      *
482      * Emits a {Transfer} event with `to` set to the zero address.
483      *
484      * Requirements:
485      *
486      * - `account` cannot be the zero address.
487      * - `account` must have at least `amount` tokens.
488      */
489     function _burn(address account, uint256 amount) internal virtual {
490         require(account != address(0), "ERC20: burn from the zero address");
491 
492         _beforeTokenTransfer(account, address(0), amount);
493 
494         uint256 accountBalance = _balances[account];
495         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
496         unchecked {
497             _balances[account] = accountBalance - amount;
498         }
499         _totalSupply -= amount;
500 
501         emit Transfer(account, address(0), amount);
502 
503         _afterTokenTransfer(account, address(0), amount);
504     }
505 
506     /**
507      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
508      *
509      * This internal function is equivalent to `approve`, and can be used to
510      * e.g. set automatic allowances for certain subsystems, etc.
511      *
512      * Emits an {Approval} event.
513      *
514      * Requirements:
515      *
516      * - `owner` cannot be the zero address.
517      * - `spender` cannot be the zero address.
518      */
519     function _approve(
520         address owner,
521         address spender,
522         uint256 amount
523     ) internal virtual {
524         require(owner != address(0), "ERC20: approve from the zero address");
525         require(spender != address(0), "ERC20: approve to the zero address");
526 
527         _allowances[owner][spender] = amount;
528         emit Approval(owner, spender, amount);
529     }
530 
531     /**
532      * @dev Hook that is called before any transfer of tokens. This includes
533      * minting and burning.
534      *
535      * Calling conditions:
536      *
537      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
538      * will be transferred to `to`.
539      * - when `from` is zero, `amount` tokens will be minted for `to`.
540      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
541      * - `from` and `to` are never both zero.
542      *
543      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
544      */
545     function _beforeTokenTransfer(
546         address from,
547         address to,
548         uint256 amount
549     ) internal virtual {}
550 
551     /**
552      * @dev Hook that is called after any transfer of tokens. This includes
553      * minting and burning.
554      *
555      * Calling conditions:
556      *
557      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
558      * has been transferred to `to`.
559      * - when `from` is zero, `amount` tokens have been minted for `to`.
560      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
561      * - `from` and `to` are never both zero.
562      *
563      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
564      */
565     function _afterTokenTransfer(
566         address from,
567         address to,
568         uint256 amount
569     ) internal virtual {}
570 }
571 
572 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
573 
574 
575 
576 pragma solidity ^0.8.0;
577 
578 
579 
580 /**
581  * @dev Extension of {ERC20} that allows token holders to destroy both their own
582  * tokens and those that they have an allowance for, in a way that can be
583  * recognized off-chain (via event analysis).
584  */
585 abstract contract ERC20Burnable is Context, ERC20 {
586     /**
587      * @dev Destroys `amount` tokens from the caller.
588      *
589      * See {ERC20-_burn}.
590      */
591     function burn(uint256 amount) public virtual {
592         _burn(_msgSender(), amount);
593     }
594 
595     /**
596      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
597      * allowance.
598      *
599      * See {ERC20-_burn} and {ERC20-allowance}.
600      *
601      * Requirements:
602      *
603      * - the caller must have allowance for ``accounts``'s tokens of at least
604      * `amount`.
605      */
606     function burnFrom(address account, uint256 amount) public virtual {
607         uint256 currentAllowance = allowance(account, _msgSender());
608         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
609         unchecked {
610             _approve(account, _msgSender(), currentAllowance - amount);
611         }
612         _burn(account, amount);
613     }
614 }
615 
616 
617 pragma solidity ^0.8.4;
618 
619 
620 
621 interface DuckNFT {
622     function transferFrom(address _from, address _to, uint256 _tokenId) external;
623 }
624 interface DucklingNFT {
625     function transferFrom(address _from, address _to, uint256 _tokenId) external;
626 }
627 interface AlphaNFT {
628     function transferFrom(address _from, address _to, uint256 _tokenId) external;
629 }
630 
631 contract grapes is ERC20Burnable, Ownable {
632     uint256 public constant MAX_SUPPLY = 200000000 * 1 ether;
633     uint256 public constant ALPHA_EMISSION_RATE = 17; // 17 per day
634     uint256 public constant DUCK_EMISSION_RATE = 10; // 10 per day
635     uint256 public constant DUCKLING_EMISSION_RATE = 5; // 5 per day
636     address public DUCK_ADDRESS = 0x36D7b711390D34e8fe26ad8f2bB14E7C8f0c56e9; 
637     address public DUCKLING_ADDRESS = 0xeB4A28587503d84dc29DE8e4Fc8bF0A57A7Ddb0d;
638     address public ALPHA_ADDRESS = 0x7dC0503Cd5F4c4a11b0f4AA326E15C464632Ede9;
639     bool public live = false;
640 
641     mapping(uint256 => uint256) internal duckTimeStaked;
642     mapping(uint256 => address) internal duckStaker;
643     mapping(address => uint256[]) internal stakerToDuck;
644     
645     mapping(uint256 => uint256) internal ducklingTimeStaked;
646     mapping(uint256 => address) internal ducklingStaker;
647     mapping(address => uint256[]) internal stakerToDuckling;
648     
649     mapping(uint256 => uint256) internal alphaTimeStaked;
650     mapping(uint256 => address) internal alphaStaker;
651     mapping(address => uint256[]) internal stakerToAlpha;
652 
653 
654     DuckNFT private _duckContract = DuckNFT(DUCK_ADDRESS);
655     DucklingNFT private _ducklingContract = DucklingNFT(DUCKLING_ADDRESS);
656     AlphaNFT private _alphaContract = AlphaNFT(ALPHA_ADDRESS);
657 
658     constructor() ERC20("GRAPES", "GRAPES") {
659         _mint(msg.sender, 2100 * 1 ether);
660     }
661 
662     modifier stakingEnabled {
663         require(live, "NOT_LIVE");
664         _;
665     }
666 
667     function getStakedDuck(address staker) public view returns (uint256[] memory) {
668         return stakerToDuck[staker];
669     }
670     
671     function getStakedAmount(address staker) public view returns (uint256) {
672         return stakerToDuck[staker].length + stakerToDuckling[staker].length + stakerToAlpha[staker].length;
673     }
674 
675     function getDuckStaker(uint256 tokenId) public view returns (address) {
676         return duckStaker[tokenId];
677     }
678 
679     function getStakedDuckling(address staker) public view returns (uint256[] memory) {
680         return stakerToDuckling[staker];
681     }
682     
683     function getDucklingStakedAmount(address staker) public view returns (uint256) {
684         return stakerToDuckling[staker].length;
685     }
686 
687     function getDucklingStaker(uint256 tokenId) public view returns (address) {
688         return ducklingStaker[tokenId];
689     }
690 
691     function getStakedAlpha(address staker) public view returns (uint256[] memory) {
692         return stakerToAlpha[staker];
693     }
694     
695     function getAlphaStakedAmount(address staker) public view returns (uint256) {
696         return stakerToAlpha[staker].length;
697     }
698 
699     function getAlphaStaker(uint256 tokenId) public view returns (address) {
700         return alphaStaker[tokenId];
701     }
702 
703     function getAllRewards(address staker) public view returns (uint256) {
704         uint256 totalRewards = 0;
705 
706         uint256[] memory duckTokens = stakerToDuck[staker];
707         for (uint256 i = 0; i < duckTokens.length; i++) {
708             totalRewards += getReward(duckTokens[i]);
709         }
710 
711         uint256[] memory ducklingTokens = stakerToDuckling[staker];
712         for (uint256 i = 0; i < ducklingTokens.length; i++) {
713             totalRewards += getDucklingReward(ducklingTokens[i]);
714         }
715 
716         uint256[] memory alphaTokens = stakerToAlpha[staker];
717         for (uint256 i = 0; i < alphaTokens.length; i++) {
718             totalRewards += getAlphaReward(alphaTokens[i]);
719         }
720 
721         return totalRewards;
722     }
723 
724     function stakeDuckById(uint256[] calldata tokenIds) external stakingEnabled {
725         for (uint256 i = 0; i < tokenIds.length; i++) {
726             uint256 id = tokenIds[i];
727             _duckContract.transferFrom(msg.sender, address(this), id);
728 
729             stakerToDuck[msg.sender].push(id);
730             duckTimeStaked[id] = block.timestamp;
731             duckStaker[id] = msg.sender;
732         }
733     }
734 
735     function unstakeDuckByIds(uint256[] calldata tokenIds) external {
736         uint256 totalRewards = 0;
737 
738         for (uint256 i = 0; i < tokenIds.length; i++) {
739             uint256 id = tokenIds[i];
740             require(duckStaker[id] == msg.sender, "NEEDS_TO_BE_OWNER");
741 
742             _duckContract.transferFrom(address(this), msg.sender, id);
743             totalRewards += getReward(id);
744 
745             removeTokenIdFromArray(stakerToDuck[msg.sender], id);
746             duckStaker[id] = address(0);
747         }
748 
749         uint256 remaining = MAX_SUPPLY - totalSupply();
750         _mint(msg.sender, totalRewards > remaining ? remaining : totalRewards);
751     }
752 
753     function stakeDucklingsById(uint256[] calldata tokenIds) external stakingEnabled {
754         for (uint256 i = 0; i < tokenIds.length; i++) {
755             uint256 id = tokenIds[i];
756             _ducklingContract.transferFrom(msg.sender, address(this), id);
757 
758             stakerToDuckling[msg.sender].push(id);
759             ducklingTimeStaked[id] = block.timestamp;
760             ducklingStaker[id] = msg.sender;
761         }
762     }
763 
764     function unstakeDucklingsByIds(uint256[] calldata tokenIds) external {
765         uint256 totalRewards = 0;
766 
767         for (uint256 i = 0; i < tokenIds.length; i++) {
768             uint256 id = tokenIds[i];
769             require(ducklingStaker[id] == msg.sender, "NEEDS_TO_BE_OWNER");
770 
771             _ducklingContract.transferFrom(address(this), msg.sender, id);
772             totalRewards += getDucklingReward(id);
773 
774             removeTokenIdFromArray(stakerToDuckling[msg.sender], id);
775             ducklingStaker[id] = address(0);
776         }
777 
778         uint256 remaining = MAX_SUPPLY - totalSupply();
779         _mint(msg.sender, totalRewards > remaining ? remaining : totalRewards);
780     }
781 
782     function stakeAlphaById(uint256[] calldata tokenIds) external stakingEnabled {
783         for (uint256 i = 0; i < tokenIds.length; i++) {
784             uint256 id = tokenIds[i];
785             _alphaContract.transferFrom(msg.sender, address(this), id);
786 
787             stakerToAlpha[msg.sender].push(id);
788             alphaTimeStaked[id] = block.timestamp;
789             alphaStaker[id] = msg.sender;
790         }
791     }
792 
793     function unstakeAlphaByIds(uint256[] calldata tokenIds) external {
794         uint256 totalRewards = 0;
795 
796         for (uint256 i = 0; i < tokenIds.length; i++) {
797             uint256 id = tokenIds[i];
798             require(alphaStaker[id] == msg.sender, "NEEDS_TO_BE_OWNER");
799 
800             _alphaContract.transferFrom(address(this), msg.sender, id);
801             totalRewards += getAlphaReward(id);
802 
803             removeTokenIdFromArray(stakerToAlpha[msg.sender], id);
804             alphaStaker[id] = address(0);
805         }
806 
807         uint256 remaining = MAX_SUPPLY - totalSupply();
808         _mint(msg.sender, totalRewards > remaining ? remaining : totalRewards);
809     }
810 
811     function unstakeAll() external {
812         require(getStakedAmount(msg.sender) > 0 || getDucklingStakedAmount(msg.sender) > 0 || getAlphaStakedAmount(msg.sender) > 0, "None Staked");
813         uint256 totalRewards = 0;
814 
815         for (uint256 i = stakerToDuck[msg.sender].length; i > 0; i--) {
816             uint256 id = stakerToDuck[msg.sender][i - 1];
817 
818             _duckContract.transferFrom(address(this), msg.sender, id);
819             totalRewards += getReward(id);
820 
821             stakerToDuck[msg.sender].pop();
822             duckStaker[id] = address(0);
823         }
824 
825         for (uint256 i = stakerToDuckling[msg.sender].length; i > 0; i--) {
826             uint256 id = stakerToDuckling[msg.sender][i - 1];
827 
828             _ducklingContract.transferFrom(address(this), msg.sender, id);
829             totalRewards += getDucklingReward(id);
830 
831             stakerToDuckling[msg.sender].pop();
832             ducklingStaker[id] = address(0);
833         }
834 
835         for (uint256 i = stakerToAlpha[msg.sender].length; i > 0; i--) {
836             uint256 id = stakerToAlpha[msg.sender][i - 1];
837 
838             _alphaContract.transferFrom(address(this), msg.sender, id);
839             totalRewards += getAlphaReward(id);
840 
841             stakerToAlpha[msg.sender].pop();
842             alphaStaker[id] = address(0);
843         }
844 
845         uint256 remaining = MAX_SUPPLY - totalSupply();
846         _mint(msg.sender, totalRewards > remaining ? remaining : totalRewards);
847     }
848 
849     function claimAll() external {
850         uint256 totalRewards = 0;
851 
852         uint256[] memory duckTokens = stakerToDuck[msg.sender];
853         for (uint256 i = 0; i < duckTokens.length; i++) {
854             uint256 id = duckTokens[i];
855 
856             totalRewards += getReward(duckTokens[i]);
857             duckTimeStaked[id] = block.timestamp;
858         }
859 
860         uint256[] memory ducklingTokens = stakerToDuckling[msg.sender];
861         for (uint256 i = 0; i < ducklingTokens.length; i++) {
862             uint256 id = ducklingTokens[i];
863 
864             totalRewards += getDucklingReward(ducklingTokens[i]);
865             ducklingTimeStaked[id] = block.timestamp;
866         }
867 
868         uint256[] memory alphaTokens = stakerToAlpha[msg.sender];
869         for (uint256 i = 0; i < alphaTokens.length; i++) {
870             uint256 id = alphaTokens[i];
871 
872             totalRewards += getAlphaReward(alphaTokens[i]);
873             alphaTimeStaked[id] = block.timestamp;
874         }
875 
876         uint256 remaining = MAX_SUPPLY - totalSupply();
877         _mint(msg.sender, totalRewards > remaining ? remaining : totalRewards);
878     }
879 
880         function Grapedrop(address[] calldata _to, uint256[] calldata _amount)
881         external
882         onlyOwner
883     {
884         for (uint256 i; i < _to.length; ) {
885             require(
886                 totalSupply() + _amount[i] - 1 <= MAX_SUPPLY,
887                 "Not enough supply"
888             );
889             _mint(_to[i], _amount[i]);
890 
891             unchecked {
892                 i++;
893             }
894         }
895     }
896 
897 
898     function burn(address from, uint256 amount) external {
899         _burn(from, amount);
900     }
901 
902     function setAlphaAddress(address ALPHA_ADDRESS_) public onlyOwner {
903         ALPHA_ADDRESS = ALPHA_ADDRESS_;
904     }
905     
906     function toggle() external onlyOwner {
907         live = !live;
908     }
909 
910     function getReward(uint256 tokenId) internal view returns(uint256) {
911         return (block.timestamp - duckTimeStaked[tokenId]) * DUCK_EMISSION_RATE / 86400 * 1 ether;
912     }
913 
914     function getDucklingReward(uint256 tokenId) internal view returns(uint256) {
915         return (block.timestamp - ducklingTimeStaked[tokenId]) * DUCKLING_EMISSION_RATE / 86400 * 1 ether;
916     }
917 
918     function getAlphaReward(uint256 tokenId) internal view returns(uint256) {
919         return (block.timestamp - alphaTimeStaked[tokenId]) * ALPHA_EMISSION_RATE / 86400 * 1 ether;
920     }
921 
922     function removeTokenIdFromArray(uint256[] storage array, uint256 tokenId) internal {
923         uint256 length = array.length;
924         for (uint256 i = 0; i < length; i++) {
925             if (array[i] == tokenId) {
926                 length--;
927                 if (i < length) {
928                     array[i] = array[length];
929                 }
930                 array.pop();
931                 break;
932             }
933         }
934     }
935 }