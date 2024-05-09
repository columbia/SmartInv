1 // File: @faircrypto/xen-crypto/contracts/interfaces/IBurnRedeemable.sol
2 
3 
4 pragma solidity ^0.8.10;
5 
6 interface IBurnRedeemable {
7     event Redeemed(
8         address indexed user,
9         address indexed xenContract,
10         address indexed tokenContract,
11         uint256 xenAmount,
12         uint256 tokenAmount
13     );
14 
15     function onTokenBurned(address user, uint256 amount) external;
16 }
17 
18 // File: @faircrypto/xen-crypto/contracts/interfaces/IBurnableToken.sol
19 
20 
21 pragma solidity ^0.8.10;
22 
23 interface IBurnableToken {
24     function burn(address user, uint256 amount) external;
25 }
26 
27 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
28 
29 
30 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Interface of the ERC165 standard, as defined in the
36  * https://eips.ethereum.org/EIPS/eip-165[EIP].
37  *
38  * Implementers can declare support of contract interfaces, which can then be
39  * queried by others ({ERC165Checker}).
40  *
41  * For an implementation, see {ERC165}.
42  */
43 interface IERC165 {
44     /**
45      * @dev Returns true if this contract implements the interface defined by
46      * `interfaceId`. See the corresponding
47      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
48      * to learn more about how these ids are created.
49      *
50      * This function call must use less than 30 000 gas.
51      */
52     function supportsInterface(bytes4 interfaceId) external view returns (bool);
53 }
54 
55 // File: @openzeppelin/contracts/interfaces/IERC165.sol
56 
57 
58 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
59 
60 pragma solidity ^0.8.0;
61 
62 
63 // File: @openzeppelin/contracts/utils/Context.sol
64 
65 
66 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
67 
68 pragma solidity ^0.8.0;
69 
70 /**
71  * @dev Provides information about the current execution context, including the
72  * sender of the transaction and its data. While these are generally available
73  * via msg.sender and msg.data, they should not be accessed in such a direct
74  * manner, since when dealing with meta-transactions the account sending and
75  * paying for execution may not be the actual sender (as far as an application
76  * is concerned).
77  *
78  * This contract is only required for intermediate, library-like contracts.
79  */
80 abstract contract Context {
81     function _msgSender() internal view virtual returns (address) {
82         return msg.sender;
83     }
84 
85     function _msgData() internal view virtual returns (bytes calldata) {
86         return msg.data;
87     }
88 }
89 
90 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
91 
92 
93 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
94 
95 pragma solidity ^0.8.0;
96 
97 /**
98  * @dev Interface of the ERC20 standard as defined in the EIP.
99  */
100 interface IERC20 {
101     /**
102      * @dev Emitted when `value` tokens are moved from one account (`from`) to
103      * another (`to`).
104      *
105      * Note that `value` may be zero.
106      */
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 
109     /**
110      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
111      * a call to {approve}. `value` is the new allowance.
112      */
113     event Approval(address indexed owner, address indexed spender, uint256 value);
114 
115     /**
116      * @dev Returns the amount of tokens in existence.
117      */
118     function totalSupply() external view returns (uint256);
119 
120     /**
121      * @dev Returns the amount of tokens owned by `account`.
122      */
123     function balanceOf(address account) external view returns (uint256);
124 
125     /**
126      * @dev Moves `amount` tokens from the caller's account to `to`.
127      *
128      * Returns a boolean value indicating whether the operation succeeded.
129      *
130      * Emits a {Transfer} event.
131      */
132     function transfer(address to, uint256 amount) external returns (bool);
133 
134     /**
135      * @dev Returns the remaining number of tokens that `spender` will be
136      * allowed to spend on behalf of `owner` through {transferFrom}. This is
137      * zero by default.
138      *
139      * This value changes when {approve} or {transferFrom} are called.
140      */
141     function allowance(address owner, address spender) external view returns (uint256);
142 
143     /**
144      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
145      *
146      * Returns a boolean value indicating whether the operation succeeded.
147      *
148      * IMPORTANT: Beware that changing an allowance with this method brings the risk
149      * that someone may use both the old and the new allowance by unfortunate
150      * transaction ordering. One possible solution to mitigate this race
151      * condition is to first reduce the spender's allowance to 0 and set the
152      * desired value afterwards:
153      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154      *
155      * Emits an {Approval} event.
156      */
157     function approve(address spender, uint256 amount) external returns (bool);
158 
159     /**
160      * @dev Moves `amount` tokens from `from` to `to` using the
161      * allowance mechanism. `amount` is then deducted from the caller's
162      * allowance.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * Emits a {Transfer} event.
167      */
168     function transferFrom(
169         address from,
170         address to,
171         uint256 amount
172     ) external returns (bool);
173 }
174 
175 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
176 
177 
178 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
179 
180 pragma solidity ^0.8.0;
181 
182 
183 /**
184  * @dev Interface for the optional metadata functions from the ERC20 standard.
185  *
186  * _Available since v4.1._
187  */
188 interface IERC20Metadata is IERC20 {
189     /**
190      * @dev Returns the name of the token.
191      */
192     function name() external view returns (string memory);
193 
194     /**
195      * @dev Returns the symbol of the token.
196      */
197     function symbol() external view returns (string memory);
198 
199     /**
200      * @dev Returns the decimals places of the token.
201      */
202     function decimals() external view returns (uint8);
203 }
204 
205 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
206 
207 
208 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
209 
210 pragma solidity ^0.8.0;
211 
212 
213 
214 
215 /**
216  * @dev Implementation of the {IERC20} interface.
217  *
218  * This implementation is agnostic to the way tokens are created. This means
219  * that a supply mechanism has to be added in a derived contract using {_mint}.
220  * For a generic mechanism see {ERC20PresetMinterPauser}.
221  *
222  * TIP: For a detailed writeup see our guide
223  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
224  * to implement supply mechanisms].
225  *
226  * We have followed general OpenZeppelin Contracts guidelines: functions revert
227  * instead returning `false` on failure. This behavior is nonetheless
228  * conventional and does not conflict with the expectations of ERC20
229  * applications.
230  *
231  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
232  * This allows applications to reconstruct the allowance for all accounts just
233  * by listening to said events. Other implementations of the EIP may not emit
234  * these events, as it isn't required by the specification.
235  *
236  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
237  * functions have been added to mitigate the well-known issues around setting
238  * allowances. See {IERC20-approve}.
239  */
240 contract ERC20 is Context, IERC20, IERC20Metadata {
241     mapping(address => uint256) private _balances;
242 
243     mapping(address => mapping(address => uint256)) private _allowances;
244 
245     uint256 private _totalSupply;
246 
247     string private _name;
248     string private _symbol;
249 
250     /**
251      * @dev Sets the values for {name} and {symbol}.
252      *
253      * The default value of {decimals} is 18. To select a different value for
254      * {decimals} you should overload it.
255      *
256      * All two of these values are immutable: they can only be set once during
257      * construction.
258      */
259     constructor(string memory name_, string memory symbol_) {
260         _name = name_;
261         _symbol = symbol_;
262     }
263 
264     /**
265      * @dev Returns the name of the token.
266      */
267     function name() public view virtual override returns (string memory) {
268         return _name;
269     }
270 
271     /**
272      * @dev Returns the symbol of the token, usually a shorter version of the
273      * name.
274      */
275     function symbol() public view virtual override returns (string memory) {
276         return _symbol;
277     }
278 
279     /**
280      * @dev Returns the number of decimals used to get its user representation.
281      * For example, if `decimals` equals `2`, a balance of `505` tokens should
282      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
283      *
284      * Tokens usually opt for a value of 18, imitating the relationship between
285      * Ether and Wei. This is the value {ERC20} uses, unless this function is
286      * overridden;
287      *
288      * NOTE: This information is only used for _display_ purposes: it in
289      * no way affects any of the arithmetic of the contract, including
290      * {IERC20-balanceOf} and {IERC20-transfer}.
291      */
292     function decimals() public view virtual override returns (uint8) {
293         return 18;
294     }
295 
296     /**
297      * @dev See {IERC20-totalSupply}.
298      */
299     function totalSupply() public view virtual override returns (uint256) {
300         return _totalSupply;
301     }
302 
303     /**
304      * @dev See {IERC20-balanceOf}.
305      */
306     function balanceOf(address account) public view virtual override returns (uint256) {
307         return _balances[account];
308     }
309 
310     /**
311      * @dev See {IERC20-transfer}.
312      *
313      * Requirements:
314      *
315      * - `to` cannot be the zero address.
316      * - the caller must have a balance of at least `amount`.
317      */
318     function transfer(address to, uint256 amount) public virtual override returns (bool) {
319         address owner = _msgSender();
320         _transfer(owner, to, amount);
321         return true;
322     }
323 
324     /**
325      * @dev See {IERC20-allowance}.
326      */
327     function allowance(address owner, address spender) public view virtual override returns (uint256) {
328         return _allowances[owner][spender];
329     }
330 
331     /**
332      * @dev See {IERC20-approve}.
333      *
334      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
335      * `transferFrom`. This is semantically equivalent to an infinite approval.
336      *
337      * Requirements:
338      *
339      * - `spender` cannot be the zero address.
340      */
341     function approve(address spender, uint256 amount) public virtual override returns (bool) {
342         address owner = _msgSender();
343         _approve(owner, spender, amount);
344         return true;
345     }
346 
347     /**
348      * @dev See {IERC20-transferFrom}.
349      *
350      * Emits an {Approval} event indicating the updated allowance. This is not
351      * required by the EIP. See the note at the beginning of {ERC20}.
352      *
353      * NOTE: Does not update the allowance if the current allowance
354      * is the maximum `uint256`.
355      *
356      * Requirements:
357      *
358      * - `from` and `to` cannot be the zero address.
359      * - `from` must have a balance of at least `amount`.
360      * - the caller must have allowance for ``from``'s tokens of at least
361      * `amount`.
362      */
363     function transferFrom(
364         address from,
365         address to,
366         uint256 amount
367     ) public virtual override returns (bool) {
368         address spender = _msgSender();
369         _spendAllowance(from, spender, amount);
370         _transfer(from, to, amount);
371         return true;
372     }
373 
374     /**
375      * @dev Atomically increases the allowance granted to `spender` by the caller.
376      *
377      * This is an alternative to {approve} that can be used as a mitigation for
378      * problems described in {IERC20-approve}.
379      *
380      * Emits an {Approval} event indicating the updated allowance.
381      *
382      * Requirements:
383      *
384      * - `spender` cannot be the zero address.
385      */
386     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
387         address owner = _msgSender();
388         _approve(owner, spender, allowance(owner, spender) + addedValue);
389         return true;
390     }
391 
392     /**
393      * @dev Atomically decreases the allowance granted to `spender` by the caller.
394      *
395      * This is an alternative to {approve} that can be used as a mitigation for
396      * problems described in {IERC20-approve}.
397      *
398      * Emits an {Approval} event indicating the updated allowance.
399      *
400      * Requirements:
401      *
402      * - `spender` cannot be the zero address.
403      * - `spender` must have allowance for the caller of at least
404      * `subtractedValue`.
405      */
406     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
407         address owner = _msgSender();
408         uint256 currentAllowance = allowance(owner, spender);
409         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
410         unchecked {
411             _approve(owner, spender, currentAllowance - subtractedValue);
412         }
413 
414         return true;
415     }
416 
417     /**
418      * @dev Moves `amount` of tokens from `from` to `to`.
419      *
420      * This internal function is equivalent to {transfer}, and can be used to
421      * e.g. implement automatic token fees, slashing mechanisms, etc.
422      *
423      * Emits a {Transfer} event.
424      *
425      * Requirements:
426      *
427      * - `from` cannot be the zero address.
428      * - `to` cannot be the zero address.
429      * - `from` must have a balance of at least `amount`.
430      */
431     function _transfer(
432         address from,
433         address to,
434         uint256 amount
435     ) internal virtual {
436         require(from != address(0), "ERC20: transfer from the zero address");
437         require(to != address(0), "ERC20: transfer to the zero address");
438 
439         _beforeTokenTransfer(from, to, amount);
440 
441         uint256 fromBalance = _balances[from];
442         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
443         unchecked {
444             _balances[from] = fromBalance - amount;
445             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
446             // decrementing then incrementing.
447             _balances[to] += amount;
448         }
449 
450         emit Transfer(from, to, amount);
451 
452         _afterTokenTransfer(from, to, amount);
453     }
454 
455     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
456      * the total supply.
457      *
458      * Emits a {Transfer} event with `from` set to the zero address.
459      *
460      * Requirements:
461      *
462      * - `account` cannot be the zero address.
463      */
464     function _mint(address account, uint256 amount) internal virtual {
465         require(account != address(0), "ERC20: mint to the zero address");
466 
467         _beforeTokenTransfer(address(0), account, amount);
468 
469         _totalSupply += amount;
470         unchecked {
471             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
472             _balances[account] += amount;
473         }
474         emit Transfer(address(0), account, amount);
475 
476         _afterTokenTransfer(address(0), account, amount);
477     }
478 
479     /**
480      * @dev Destroys `amount` tokens from `account`, reducing the
481      * total supply.
482      *
483      * Emits a {Transfer} event with `to` set to the zero address.
484      *
485      * Requirements:
486      *
487      * - `account` cannot be the zero address.
488      * - `account` must have at least `amount` tokens.
489      */
490     function _burn(address account, uint256 amount) internal virtual {
491         require(account != address(0), "ERC20: burn from the zero address");
492 
493         _beforeTokenTransfer(account, address(0), amount);
494 
495         uint256 accountBalance = _balances[account];
496         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
497         unchecked {
498             _balances[account] = accountBalance - amount;
499             // Overflow not possible: amount <= accountBalance <= totalSupply.
500             _totalSupply -= amount;
501         }
502 
503         emit Transfer(account, address(0), amount);
504 
505         _afterTokenTransfer(account, address(0), amount);
506     }
507 
508     /**
509      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
510      *
511      * This internal function is equivalent to `approve`, and can be used to
512      * e.g. set automatic allowances for certain subsystems, etc.
513      *
514      * Emits an {Approval} event.
515      *
516      * Requirements:
517      *
518      * - `owner` cannot be the zero address.
519      * - `spender` cannot be the zero address.
520      */
521     function _approve(
522         address owner,
523         address spender,
524         uint256 amount
525     ) internal virtual {
526         require(owner != address(0), "ERC20: approve from the zero address");
527         require(spender != address(0), "ERC20: approve to the zero address");
528 
529         _allowances[owner][spender] = amount;
530         emit Approval(owner, spender, amount);
531     }
532 
533     /**
534      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
535      *
536      * Does not update the allowance amount in case of infinite allowance.
537      * Revert if not enough allowance is available.
538      *
539      * Might emit an {Approval} event.
540      */
541     function _spendAllowance(
542         address owner,
543         address spender,
544         uint256 amount
545     ) internal virtual {
546         uint256 currentAllowance = allowance(owner, spender);
547         if (currentAllowance != type(uint256).max) {
548             require(currentAllowance >= amount, "ERC20: insufficient allowance");
549             unchecked {
550                 _approve(owner, spender, currentAllowance - amount);
551             }
552         }
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
596 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol
597 
598 
599 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Capped.sol)
600 
601 pragma solidity ^0.8.0;
602 
603 
604 /**
605  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
606  */
607 abstract contract ERC20Capped is ERC20 {
608     uint256 private immutable _cap;
609 
610     /**
611      * @dev Sets the value of the `cap`. This value is immutable, it can only be
612      * set once during construction.
613      */
614     constructor(uint256 cap_) {
615         require(cap_ > 0, "ERC20Capped: cap is 0");
616         _cap = cap_;
617     }
618 
619     /**
620      * @dev Returns the cap on the token's total supply.
621      */
622     function cap() public view virtual returns (uint256) {
623         return _cap;
624     }
625 
626     /**
627      * @dev See {ERC20-_mint}.
628      */
629     function _mint(address account, uint256 amount) internal virtual override {
630         require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
631         super._mint(account, amount);
632     }
633 }
634 
635 // File: contracts/XENDoge.sol
636 
637 
638 pragma solidity 0.8.19;
639 
640 
641 
642 
643 
644 contract XENDoge is ERC20Capped, IERC165, IBurnRedeemable { 
645     address public constant XEN_ADDRESS = 0x06450dEe7FD2Fb8E39061434BAbCFC05599a6Fb8;
646     address payable public constant DONATION_ADDRESS = payable(0xDd1353ABC10433e0Df7217404B7908163Ad76930);
647     uint256 public constant XEN_BURN_RATIO = 1000;
648     uint256 public totalXenBurned = 0;
649     uint256 public totalDonated = 0;
650 
651     constructor() ERC20("XENDoge", "XDOGE") ERC20Capped(50000000000000000000000000000) {}
652 
653     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
654         return interfaceId == type(IBurnRedeemable).interfaceId || interfaceId == this.supportsInterface.selector;
655     }
656 
657     function burnXEN(uint256 xen) public payable {
658         (bool sent,) = DONATION_ADDRESS.call{value: msg.value}("");
659         require(sent, "XENDoge: Failed to send Ether to the donation address.");
660 
661         totalDonated += msg.value;
662         
663         IBurnableToken(XEN_ADDRESS).burn(_msgSender(), xen);
664     }
665 
666     function onTokenBurned(address user, uint256 amount) external {
667         require(_msgSender() == XEN_ADDRESS, "XENDoge: Caller must be XEN Crypto.");
668         require(user != address(0), "XENDoge: Address cannot be the 0 address.");
669         require(amount >= 100000, "XENDoge: Burn amount too small.");
670 
671         totalXenBurned += amount;
672 
673         uint256 xenDoge = calculateMintReward(this.totalSupply(), amount);
674         _mint(user, xenDoge);
675 
676         emit Redeemed(user, XEN_ADDRESS, address(this), amount, xenDoge);
677     }
678 
679     function calculateMintReward(uint256 currentSupply, uint256 amountBurned) internal pure returns (uint256) {
680         uint256 baseReward = amountBurned / XEN_BURN_RATIO;
681         uint32 percentBonus = getPercentBonus(currentSupply);
682         uint256 earlyAdopterBonus = percentageOf(baseReward, percentBonus);
683 
684         return baseReward + earlyAdopterBonus;
685     }
686 
687     function getPercentBonus(uint256 currentSupply) internal pure returns (uint32) {
688         if (currentSupply >= 0 && currentSupply <= 7500000000000000000000000000) return 150000; 
689 
690         if (currentSupply > 7500000000000000000000000000 && currentSupply <= 12500000000000000000000000000) return 100000;
691 
692         if (currentSupply > 12500000000000000000000000000 && currentSupply <= 17500000000000000000000000000) return 66600; 
693 
694         if (currentSupply > 17500000000000000000000000000 && currentSupply <= 22500000000000000000000000000) return 44400; 
695 
696         if (currentSupply > 22500000000000000000000000000 && currentSupply <= 27500000000000000000000000000) return 29600; 
697 
698         if (currentSupply > 27500000000000000000000000000 && currentSupply <= 32500000000000000000000000000) return 19700; 
699 
700         if (currentSupply > 32500000000000000000000000000 && currentSupply <= 35000000000000000000000000000) return 13100; 
701 
702         if (currentSupply > 35000000000000000000000000000 && currentSupply <= 37500000000000000000000000000) return 8700; 
703 
704         if (currentSupply > 37500000000000000000000000000 && currentSupply <= 40000000000000000000000000000) return 5800; 
705 
706         if (currentSupply > 40000000000000000000000000000 && currentSupply <= 42500000000000000000000000000) return 3800; 
707 
708         if (currentSupply > 42500000000000000000000000000 && currentSupply <= 45000000000000000000000000000) return 2500; 
709 
710         if (currentSupply > 45000000000000000000000000000 && currentSupply <= 47500000000000000000000000000) return 1700; 
711 
712         return 0;
713     }
714 
715     function percentageOf(uint256 number, uint32 percent) internal pure returns (uint256) {
716         return number * percent / 10000;
717     }
718 }