1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts@4.8.3/utils/Context.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 //                          Summer is here, and it’s time for us all to enjoy some melon!         
10 //                                              .         .                                           
11 //                                                                                                    
12 //                                                                                                    
13 //                                                 ..                                                 
14 //                                 .     ^::..:::::^::::::..:^:                                       
15 //                                      .7~^^^^^^^^^^^^^^^^^^!~    ..                                 
16 //                                      :~^^^^!7?!^^^^~??7~^^^~.                                      
17 //                                     .^~^^~~~^^^7PPJ^^^~~~^^~^                                      
18 //                                     ::::^^^^7!~!JY7~!!^^^^:::.                                     
19 //                                     .......^B#BBBBBBBB^.......                                     
20 //                                     .....  .YBG5YYYPBJ   .....                                     
21 //                                     ......   ::^^^^::   .....                                      
22 //                                       .:....          ......                                       
23 //                          !::~!!!!!!!!!7?7777777!7!!7!7777??!7!7!!~^^^^..~                          
24 //                          J~:?JJJYYY55YY8YYYYYYYYYYYYYYYYYYYYY5YYYJJJJ?^^Y                          
25 //                          !?.!JJJJJJYYYY8YYYYYYYYYYYYYYYYYYYYYYYJJJJJJ7.77                          
26 //                           J~:7JJJJJJYJY8YYYJYYYYYYYYYYYYYY5YJJJJJJJJ?:^J.                          
27 //                           .J~:7JJJJJJJYYYYY5YYYYYYYYYY5YYYYYJJJJJJJ?^^J:                           
28 //                            .?!:!?JJJJJJJYYJ5YYYY55YYYY5JYYJJJJJJJ?!:~?:                            
29 //                              !?~^!??JJJJJJJJYYYYJJYYYJJJJJJJJJJ?!^^7!.                             
30 //                               .!7~^~!7?JJJJJJJJJJJJJJJJJJJJ??7~^~7!.                               
31 //                             :^^^~?J7~^~~!7???JJJJJJJJJ??77!~^~7??!^^^.                             
32 //                             :~77?77????7!~~~~~~~~~~~~~~~~!7??J??777~:                              
33 //                                .:^~!!77????????7777????????77!!~^.                                 
34 //                                      ..:::^^^^~~~~~~~^^^:::..                                      
35 
36 /**
37  * @dev Provides information about the current execution context, including the
38  * sender of the transaction and its data. While these are generally available
39  * via msg.sender and msg.data, they should not be accessed in such a direct
40  * manner, since when dealing with meta-transactions the account sending and
41  * paying for execution may not be the actual sender (as far as an application
42  * is concerned).
43  *
44  * This contract is only required for intermediate, library-like contracts.
45  */
46 abstract contract Context {
47     function _msgSender() internal view virtual returns (address) {
48         return msg.sender;
49     }
50 
51     function _msgData() internal view virtual returns (bytes calldata) {
52         return msg.data;
53     }
54 }
55 
56 // File: @openzeppelin/contracts@4.8.3/access/Ownable.sol
57 
58 
59 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
60 
61 pragma solidity ^0.8.0;
62 
63 
64 /**
65  * @dev Contract module which provides a basic access control mechanism, where
66  * there is an account (an owner) that can be granted exclusive access to
67  * specific functions.
68  *
69  * By default, the owner account will be the one that deploys the contract. This
70  * can later be changed with {transferOwnership}.
71  *
72  * This module is used through inheritance. It will make available the modifier
73  * `onlyOwner`, which can be applied to your functions to restrict their use to
74  * the owner.
75  */
76 abstract contract Ownable is Context {
77     address private _owner;
78 
79     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80 
81     /**
82      * @dev Initializes the contract setting the deployer as the initial owner.
83      */
84     constructor() {
85         _transferOwnership(_msgSender());
86     }
87 
88     /**
89      * @dev Throws if called by any account other than the owner.
90      */
91     modifier onlyOwner() {
92         _checkOwner();
93         _;
94     }
95 
96     /**
97      * @dev Returns the address of the current owner.
98      */
99     function owner() public view virtual returns (address) {
100         return _owner;
101     }
102 
103     /**
104      * @dev Throws if the sender is not the owner.
105      */
106     function _checkOwner() internal view virtual {
107         require(owner() == _msgSender(), "Ownable: caller is not the owner");
108     }
109 
110     /**
111      * @dev Leaves the contract without owner. It will not be possible to call
112      * `onlyOwner` functions anymore. Can only be called by the current owner.
113      *
114      * NOTE: Renouncing ownership will leave the contract without an owner,
115      * thereby removing any functionality that is only available to the owner.
116      */
117     function renounceOwnership() public virtual onlyOwner {
118         _transferOwnership(address(0));
119     }
120 
121     /**
122      * @dev Transfers ownership of the contract to a new account (`newOwner`).
123      * Can only be called by the current owner.
124      */
125     function transferOwnership(address newOwner) public virtual onlyOwner {
126         require(newOwner != address(0), "Ownable: new owner is the zero address");
127         _transferOwnership(newOwner);
128     }
129 
130     /**
131      * @dev Transfers ownership of the contract to a new account (`newOwner`).
132      * Internal function without access restriction.
133      */
134     function _transferOwnership(address newOwner) internal virtual {
135         address oldOwner = _owner;
136         _owner = newOwner;
137         emit OwnershipTransferred(oldOwner, newOwner);
138     }
139 }
140 
141 // File: @openzeppelin/contracts@4.8.3/token/ERC20/IERC20.sol
142 
143 
144 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
145 
146 pragma solidity ^0.8.0;
147 
148 /**
149  * @dev Interface of the ERC20 standard as defined in the EIP.
150  */
151 interface IERC20 {
152     /**
153      * @dev Emitted when `value` tokens are moved from one account (`from`) to
154      * another (`to`).
155      *
156      * Note that `value` may be zero.
157      */
158     event Transfer(address indexed from, address indexed to, uint256 value);
159 
160     /**
161      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
162      * a call to {approve}. `value` is the new allowance.
163      */
164     event Approval(address indexed owner, address indexed spender, uint256 value);
165 
166     /**
167      * @dev Returns the amount of tokens in existence.
168      */
169     function totalSupply() external view returns (uint256);
170 
171     /**
172      * @dev Returns the amount of tokens owned by `account`.
173      */
174     function balanceOf(address account) external view returns (uint256);
175 
176     /**
177      * @dev Moves `amount` tokens from the caller's account to `to`.
178      *
179      * Returns a boolean value indicating whether the operation succeeded.
180      *
181      * Emits a {Transfer} event.
182      */
183     function transfer(address to, uint256 amount) external returns (bool);
184 
185     /**
186      * @dev Returns the remaining number of tokens that `spender` will be
187      * allowed to spend on behalf of `owner` through {transferFrom}. This is
188      * zero by default.
189      *
190      * This value changes when {approve} or {transferFrom} are called.
191      */
192     function allowance(address owner, address spender) external view returns (uint256);
193 
194     /**
195      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
196      *
197      * Returns a boolean value indicating whether the operation succeeded.
198      *
199      * IMPORTANT: Beware that changing an allowance with this method brings the risk
200      * that someone may use both the old and the new allowance by unfortunate
201      * transaction ordering. One possible solution to mitigate this race
202      * condition is to first reduce the spender's allowance to 0 and set the
203      * desired value afterwards:
204      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205      *
206      * Emits an {Approval} event.
207      */
208     function approve(address spender, uint256 amount) external returns (bool);
209 
210     /**
211      * @dev Moves `amount` tokens from `from` to `to` using the
212      * allowance mechanism. `amount` is then deducted from the caller's
213      * allowance.
214      *
215      * Returns a boolean value indicating whether the operation succeeded.
216      *
217      * Emits a {Transfer} event.
218      */
219     function transferFrom(
220         address from,
221         address to,
222         uint256 amount
223     ) external returns (bool);
224 }
225 
226 // File: @openzeppelin/contracts@4.8.3/token/ERC20/extensions/IERC20Metadata.sol
227 
228 
229 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 
234 /**
235  * @dev Interface for the optional metadata functions from the ERC20 standard.
236  *
237  * _Available since v4.1._
238  */
239 interface IERC20Metadata is IERC20 {
240     /**
241      * @dev Returns the name of the token.
242      */
243     function name() external view returns (string memory);
244 
245     /**
246      * @dev Returns the symbol of the token.
247      */
248     function symbol() external view returns (string memory);
249 
250     /**
251      * @dev Returns the decimals places of the token.
252      */
253     function decimals() external view returns (uint8);
254 }
255 
256 // File: @openzeppelin/contracts@4.8.3/token/ERC20/ERC20.sol
257 
258 
259 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 
264 
265 
266 /**
267  * @dev Implementation of the {IERC20} interface.
268  *
269  * This implementation is agnostic to the way tokens are created. This means
270  * that a supply mechanism has to be added in a derived contract using {_mint}.
271  * For a generic mechanism see {ERC20PresetMinterPauser}.
272  *
273  * TIP: For a detailed writeup see our guide
274  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
275  * to implement supply mechanisms].
276  *
277  * We have followed general OpenZeppelin Contracts guidelines: functions revert
278  * instead returning `false` on failure. This behavior is nonetheless
279  * conventional and does not conflict with the expectations of ERC20
280  * applications.
281  *
282  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
283  * This allows applications to reconstruct the allowance for all accounts just
284  * by listening to said events. Other implementations of the EIP may not emit
285  * these events, as it isn't required by the specification.
286  *
287  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
288  * functions have been added to mitigate the well-known issues around setting
289  * allowances. See {IERC20-approve}.
290  */
291 contract ERC20 is Context, IERC20, IERC20Metadata {
292     mapping(address => uint256) private _balances;
293 
294     mapping(address => mapping(address => uint256)) private _allowances;
295 
296     uint256 private _totalSupply;
297 
298     string private _name;
299     string private _symbol;
300 
301     /**
302      * @dev Sets the values for {name} and {symbol}.
303      *
304      * The default value of {decimals} is 18. To select a different value for
305      * {decimals} you should overload it.
306      *
307      * All two of these values are immutable: they can only be set once during
308      * construction.
309      */
310     constructor(string memory name_, string memory symbol_) {
311         _name = name_;
312         _symbol = symbol_;
313     }
314 
315     /**
316      * @dev Returns the name of the token.
317      */
318     function name() public view virtual override returns (string memory) {
319         return _name;
320     }
321 
322     /**
323      * @dev Returns the symbol of the token, usually a shorter version of the
324      * name.
325      */
326     function symbol() public view virtual override returns (string memory) {
327         return _symbol;
328     }
329 
330     /**
331      * @dev Returns the number of decimals used to get its user representation.
332      * For example, if `decimals` equals `2`, a balance of `505` tokens should
333      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
334      *
335      * Tokens usually opt for a value of 18, imitating the relationship between
336      * Ether and Wei. This is the value {ERC20} uses, unless this function is
337      * overridden;
338      *
339      * NOTE: This information is only used for _display_ purposes: it in
340      * no way affects any of the arithmetic of the contract, including
341      * {IERC20-balanceOf} and {IERC20-transfer}.
342      */
343     function decimals() public view virtual override returns (uint8) {
344         return 18;
345     }
346 
347     /**
348      * @dev See {IERC20-totalSupply}.
349      */
350     function totalSupply() public view virtual override returns (uint256) {
351         return _totalSupply;
352     }
353 
354     /**
355      * @dev See {IERC20-balanceOf}.
356      */
357     function balanceOf(address account) public view virtual override returns (uint256) {
358         return _balances[account];
359     }
360 
361     /**
362      * @dev See {IERC20-transfer}.
363      *
364      * Requirements:
365      *
366      * - `to` cannot be the zero address.
367      * - the caller must have a balance of at least `amount`.
368      */
369     function transfer(address to, uint256 amount) public virtual override returns (bool) {
370         address owner = _msgSender();
371         _transfer(owner, to, amount);
372         return true;
373     }
374 
375     /**
376      * @dev See {IERC20-allowance}.
377      */
378     function allowance(address owner, address spender) public view virtual override returns (uint256) {
379         return _allowances[owner][spender];
380     }
381 
382     /**
383      * @dev See {IERC20-approve}.
384      *
385      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
386      * `transferFrom`. This is semantically equivalent to an infinite approval.
387      *
388      * Requirements:
389      *
390      * - `spender` cannot be the zero address.
391      */
392     function approve(address spender, uint256 amount) public virtual override returns (bool) {
393         address owner = _msgSender();
394         _approve(owner, spender, amount);
395         return true;
396     }
397 
398     /**
399      * @dev See {IERC20-transferFrom}.
400      *
401      * Emits an {Approval} event indicating the updated allowance. This is not
402      * required by the EIP. See the note at the beginning of {ERC20}.
403      *
404      * NOTE: Does not update the allowance if the current allowance
405      * is the maximum `uint256`.
406      *
407      * Requirements:
408      *
409      * - `from` and `to` cannot be the zero address.
410      * - `from` must have a balance of at least `amount`.
411      * - the caller must have allowance for ``from``'s tokens of at least
412      * `amount`.
413      */
414     function transferFrom(
415         address from,
416         address to,
417         uint256 amount
418     ) public virtual override returns (bool) {
419         address spender = _msgSender();
420         _spendAllowance(from, spender, amount);
421         _transfer(from, to, amount);
422         return true;
423     }
424 
425     /**
426      * @dev Atomically increases the allowance granted to `spender` by the caller.
427      *
428      * This is an alternative to {approve} that can be used as a mitigation for
429      * problems described in {IERC20-approve}.
430      *
431      * Emits an {Approval} event indicating the updated allowance.
432      *
433      * Requirements:
434      *
435      * - `spender` cannot be the zero address.
436      */
437     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
438         address owner = _msgSender();
439         _approve(owner, spender, allowance(owner, spender) + addedValue);
440         return true;
441     }
442 
443     /**
444      * @dev Atomically decreases the allowance granted to `spender` by the caller.
445      *
446      * This is an alternative to {approve} that can be used as a mitigation for
447      * problems described in {IERC20-approve}.
448      *
449      * Emits an {Approval} event indicating the updated allowance.
450      *
451      * Requirements:
452      *
453      * - `spender` cannot be the zero address.
454      * - `spender` must have allowance for the caller of at least
455      * `subtractedValue`.
456      */
457     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
458         address owner = _msgSender();
459         uint256 currentAllowance = allowance(owner, spender);
460         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
461         unchecked {
462             _approve(owner, spender, currentAllowance - subtractedValue);
463         }
464 
465         return true;
466     }
467 
468     /**
469      * @dev Moves `amount` of tokens from `from` to `to`.
470      *
471      * This internal function is equivalent to {transfer}, and can be used to
472      * e.g. implement automatic token fees, slashing mechanisms, etc.
473      *
474      * Emits a {Transfer} event.
475      *
476      * Requirements:
477      *
478      * - `from` cannot be the zero address.
479      * - `to` cannot be the zero address.
480      * - `from` must have a balance of at least `amount`.
481      */
482     function _transfer(
483         address from,
484         address to,
485         uint256 amount
486     ) internal virtual {
487         require(from != address(0), "ERC20: transfer from the zero address");
488         require(to != address(0), "ERC20: transfer to the zero address");
489 
490         _beforeTokenTransfer(from, to, amount);
491 
492         uint256 fromBalance = _balances[from];
493         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
494         unchecked {
495             _balances[from] = fromBalance - amount;
496             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
497             // decrementing then incrementing.
498             _balances[to] += amount;
499         }
500 
501         emit Transfer(from, to, amount);
502 
503         _afterTokenTransfer(from, to, amount);
504     }
505 
506     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
507      * the total supply.
508      *
509      * Emits a {Transfer} event with `from` set to the zero address.
510      *
511      * Requirements:
512      *
513      * - `account` cannot be the zero address.
514      */
515     function _mint(address account, uint256 amount) internal virtual {
516         require(account != address(0), "ERC20: mint to the zero address");
517 
518         _beforeTokenTransfer(address(0), account, amount);
519 
520         _totalSupply += amount;
521         unchecked {
522             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
523             _balances[account] += amount;
524         }
525         emit Transfer(address(0), account, amount);
526 
527         _afterTokenTransfer(address(0), account, amount);
528     }
529 
530     /**
531      * @dev Destroys `amount` tokens from `account`, reducing the
532      * total supply.
533      *
534      * Emits a {Transfer} event with `to` set to the zero address.
535      *
536      * Requirements:
537      *
538      * - `account` cannot be the zero address.
539      * - `account` must have at least `amount` tokens.
540      */
541     function _burn(address account, uint256 amount) internal virtual {
542         require(account != address(0), "ERC20: burn from the zero address");
543 
544         _beforeTokenTransfer(account, address(0), amount);
545 
546         uint256 accountBalance = _balances[account];
547         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
548         unchecked {
549             _balances[account] = accountBalance - amount;
550             // Overflow not possible: amount <= accountBalance <= totalSupply.
551             _totalSupply -= amount;
552         }
553 
554         emit Transfer(account, address(0), amount);
555 
556         _afterTokenTransfer(account, address(0), amount);
557     }
558 
559     /**
560      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
561      *
562      * This internal function is equivalent to `approve`, and can be used to
563      * e.g. set automatic allowances for certain subsystems, etc.
564      *
565      * Emits an {Approval} event.
566      *
567      * Requirements:
568      *
569      * - `owner` cannot be the zero address.
570      * - `spender` cannot be the zero address.
571      */
572     function _approve(
573         address owner,
574         address spender,
575         uint256 amount
576     ) internal virtual {
577         require(owner != address(0), "ERC20: approve from the zero address");
578         require(spender != address(0), "ERC20: approve to the zero address");
579 
580         _allowances[owner][spender] = amount;
581         emit Approval(owner, spender, amount);
582     }
583 
584     /**
585      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
586      *
587      * Does not update the allowance amount in case of infinite allowance.
588      * Revert if not enough allowance is available.
589      *
590      * Might emit an {Approval} event.
591      */
592     function _spendAllowance(
593         address owner,
594         address spender,
595         uint256 amount
596     ) internal virtual {
597         uint256 currentAllowance = allowance(owner, spender);
598         if (currentAllowance != type(uint256).max) {
599             require(currentAllowance >= amount, "ERC20: insufficient allowance");
600             unchecked {
601                 _approve(owner, spender, currentAllowance - amount);
602             }
603         }
604     }
605 
606     /**
607      * @dev Hook that is called before any transfer of tokens. This includes
608      * minting and burning.
609      *
610      * Calling conditions:
611      *
612      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
613      * will be transferred to `to`.
614      * - when `from` is zero, `amount` tokens will be minted for `to`.
615      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
616      * - `from` and `to` are never both zero.
617      *
618      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
619      */
620     function _beforeTokenTransfer(
621         address from,
622         address to,
623         uint256 amount
624     ) internal virtual {}
625 
626     /**
627      * @dev Hook that is called after any transfer of tokens. This includes
628      * minting and burning.
629      *
630      * Calling conditions:
631      *
632      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
633      * has been transferred to `to`.
634      * - when `from` is zero, `amount` tokens have been minted for `to`.
635      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
636      * - `from` and `to` are never both zero.
637      *
638      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
639      */
640     function _afterTokenTransfer(
641         address from,
642         address to,
643         uint256 amount
644     ) internal virtual {}
645 }
646 
647 // File: @openzeppelin/contracts@4.8.3/token/ERC20/extensions/ERC20Burnable.sol
648 
649 
650 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
651 
652 pragma solidity ^0.8.0;
653 
654 
655 
656 /**
657  * @dev Extension of {ERC20} that allows token holders to destroy both their own
658  * tokens and those that they have an allowance for, in a way that can be
659  * recognized off-chain (via event analysis).
660  */
661 abstract contract ERC20Burnable is Context, ERC20 {
662     /**
663      * @dev Destroys `amount` tokens from the caller.
664      *
665      * See {ERC20-_burn}.
666      */
667     function burn(uint256 amount) public virtual {
668         _burn(_msgSender(), amount);
669     }
670 
671     /**
672      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
673      * allowance.
674      *
675      * See {ERC20-_burn} and {ERC20-allowance}.
676      *
677      * Requirements:
678      *
679      * - the caller must have allowance for ``accounts``'s tokens of at least
680      * `amount`.
681      */
682     function burnFrom(address account, uint256 amount) public virtual {
683         _spendAllowance(account, _msgSender(), amount);
684         _burn(account, amount);
685     }
686 }
687 
688 // File: melon_contract.sol
689 
690 
691 pragma solidity ^0.8.9;
692 
693 
694 
695 
696 contract Melon is ERC20, ERC20Burnable, Ownable {
697     bool public limited;
698     uint256 public maxHoldingAmount;
699     uint256 public minHoldingAmount;
700     address public uniswapV2Pair;
701     mapping(address => bool) public blacklists;
702     
703     constructor() ERC20("Melon", "MELON") {
704         _mint(msg.sender, 800000000000008 * 10 ** decimals());
705     }
706 
707     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
708     blacklists[_address] = _isBlacklisting;
709     }
710 
711     function setRule(bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
712         limited = _limited;
713         uniswapV2Pair = _uniswapV2Pair;
714         maxHoldingAmount = _maxHoldingAmount;
715         minHoldingAmount = _minHoldingAmount;
716     }
717     function _beforeTokenTransfer(
718         address from,
719         address to,
720         uint256 amount
721     ) override internal virtual {
722         require(!blacklists[to] && !blacklists[from], "Blacklisted");
723 
724         if (uniswapV2Pair == address(0)) {
725             require(from == owner() || to == owner(), "trading is not started");
726             return;
727         }
728 
729         if (limited && from == uniswapV2Pair) {
730             require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
731         }
732     }
733 
734 }