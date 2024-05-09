1 /* 
2 SpeechAI ($SAI)
3 
4 #SpeechAI, The most developed Text To Speech AI brought to Telegram
5 
6 Telegram Community: https://t.me/SpeechAIERC
7 
8 Telegram Announcements: https://t.me/SpeechAIAnnouncements
9 
10 Telegram Bot: https://t.me/SpeechAI_bot
11 
12 Twitter: https://twitter.com/SpeechAIERC
13 
14 Website: http://www.speechai.online/
15 
16 5/5 tax
17 3% marketing & devolopment 
18 1% further Bot development
19 1% liquidity
20 
21 */
22 
23 
24 // SPDX-License-Identifier: MIT
25 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
26 pragma experimental ABIEncoderV2;
27 
28 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
29 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
30 
31 /* pragma solidity ^0.8.0; */
32 
33 /**
34  * @dev Provides information about the current execution context, including the
35  * sender of the transaction and its data. While these are generally available
36  * via msg.sender and msg.data, they should not be accessed in such a direct
37  * manner, since when dealing with meta-transactions the account sending and
38  * paying for execution may not be the actual sender (as far as an application
39  * is concerned).
40  *
41  * This contract is only required for intermediate, library-like contracts.
42  */
43 abstract contract Context {
44     function _msgSender() internal view virtual returns (address) {
45         return msg.sender;
46     }
47 
48     function _msgData() internal view virtual returns (bytes calldata) {
49         return msg.data;
50     }
51 }
52 
53 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
54 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
55 
56 /* pragma solidity ^0.8.0; */
57 
58 /* import "../utils/Context.sol"; */
59 
60 /**
61  * @dev Contract module which provides a basic access control mechanism, where
62  * there is an account (an owner) that can be granted exclusive access to
63  * specific functions.
64  *
65  * By default, the owner account will be the one that deploys the contract. This
66  * can later be changed with {transferOwnership}.
67  *
68  * This module is used through inheritance. It will make available the modifier
69  * `onlyOwner`, which can be applied to your functions to restrict their use to
70  * the owner.
71  */
72 abstract contract Ownable is Context {
73     address private _owner;
74 
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77     /**
78      * @dev Initializes the contract setting the deployer as the initial owner.
79      */
80     constructor() {
81         _transferOwnership(_msgSender());
82     }
83 
84     /**
85      * @dev Returns the address of the current owner.
86      */
87     function owner() public view virtual returns (address) {
88         return _owner;
89     }
90 
91     /**
92      * @dev Throws if called by any account other than the owner.
93      */
94     modifier onlyOwner() {
95         require(owner() == _msgSender(), "Ownable: caller is not the owner");
96         _;
97     }
98 
99     /**
100      * @dev Leaves the contract without owner. It will not be possible to call
101      * `onlyOwner` functions anymore. Can only be called by the current owner.
102      *
103      * NOTE: Renouncing ownership will leave the contract without an owner,
104      * thereby removing any functionality that is only available to the owner.
105      */
106     function renounceOwnership() public virtual onlyOwner {
107         _transferOwnership(address(0));
108     }
109 
110     /**
111      * @dev Transfers ownership of the contract to a new account (`newOwner`).
112      * Can only be called by the current owner.
113      */
114     function transferOwnership(address newOwner) public virtual onlyOwner {
115         require(newOwner != address(0), "Ownable: new owner is the zero address");
116         _transferOwnership(newOwner);
117     }
118 
119     /**
120      * @dev Transfers ownership of the contract to a new account (`newOwner`).
121      * Internal function without access restriction.
122      */
123     function _transferOwnership(address newOwner) internal virtual {
124         address oldOwner = _owner;
125         _owner = newOwner;
126         emit OwnershipTransferred(oldOwner, newOwner);
127     }
128 }
129 
130 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
131 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
132 
133 /* pragma solidity ^0.8.0; */
134 
135 /**
136  * @dev Interface of the ERC20 standard as defined in the EIP.
137  */
138 interface IERC20 {
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
150      * @dev Moves `amount` tokens from the caller's account to `recipient`.
151      *
152      * Returns a boolean value indicating whether the operation succeeded.
153      *
154      * Emits a {Transfer} event.
155      */
156     function transfer(address recipient, uint256 amount) external returns (bool);
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
184      * @dev Moves `amount` tokens from `sender` to `recipient` using the
185      * allowance mechanism. `amount` is then deducted from the caller's
186      * allowance.
187      *
188      * Returns a boolean value indicating whether the operation succeeded.
189      *
190      * Emits a {Transfer} event.
191      */
192     function transferFrom(
193         address sender,
194         address recipient,
195         uint256 amount
196     ) external returns (bool);
197 
198     /**
199      * @dev Emitted when `value` tokens are moved from one account (`from`) to
200      * another (`to`).
201      *
202      * Note that `value` may be zero.
203      */
204     event Transfer(address indexed from, address indexed to, uint256 value);
205 
206     /**
207      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
208      * a call to {approve}. `value` is the new allowance.
209      */
210     event Approval(address indexed owner, address indexed spender, uint256 value);
211 }
212 
213 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
214 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
215 
216 /* pragma solidity ^0.8.0; */
217 
218 /* import "../IERC20.sol"; */
219 
220 /**
221  * @dev Interface for the optional metadata functions from the ERC20 standard.
222  *
223  * _Available since v4.1._
224  */
225 interface IERC20Metadata is IERC20 {
226     /**
227      * @dev Returns the name of the token.
228      */
229     function name() external view returns (string memory);
230 
231     /**
232      * @dev Returns the symbol of the token.
233      */
234     function symbol() external view returns (string memory);
235 
236     /**
237      * @dev Returns the decimals places of the token.
238      */
239     function decimals() external view returns (uint8);
240 }
241 
242 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
243 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
244 
245 /* pragma solidity ^0.8.0; */
246 
247 /* import "./IERC20.sol"; */
248 /* import "./extensions/IERC20Metadata.sol"; */
249 /* import "../../utils/Context.sol"; */
250 
251 /**
252  * @dev Implementation of the {IERC20} interface.
253  *
254  * This implementation is agnostic to the way tokens are created. This means
255  * that a supply mechanism has to be added in a derived contract using {_mint}.
256  * For a generic mechanism see {ERC20PresetMinterPauser}.
257  *
258  * TIP: For a detailed writeup see our guide
259  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
260  * to implement supply mechanisms].
261  *
262  * We have followed general OpenZeppelin Contracts guidelines: functions revert
263  * instead returning `false` on failure. This behavior is nonetheless
264  * conventional and does not conflict with the expectations of ERC20
265  * applications.
266  *
267  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
268  * This allows applications to reconstruct the allowance for all accounts just
269  * by listening to said events. Other implementations of the EIP may not emit
270  * these events, as it isn't required by the specification.
271  *
272  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
273  * functions have been added to mitigate the well-known issues around setting
274  * allowances. See {IERC20-approve}.
275  */
276 contract ERC20 is Context, IERC20, IERC20Metadata {
277     mapping(address => uint256) private _balances;
278 
279     mapping(address => mapping(address => uint256)) private _allowances;
280 
281     uint256 private _totalSupply;
282 
283     string private _name;
284     string private _symbol;
285 
286     /**
287      * @dev Sets the values for {name} and {symbol}.
288      *
289      * The default value of {decimals} is 18. To select a different value for
290      * {decimals} you should overload it.
291      *
292      * All two of these values are immutable: they can only be set once during
293      * construction.
294      */
295     constructor(string memory name_, string memory symbol_) {
296         _name = name_;
297         _symbol = symbol_;
298     }
299 
300     /**
301      * @dev Returns the name of the token.
302      */
303     function name() public view virtual override returns (string memory) {
304         return _name;
305     }
306 
307     /**
308      * @dev Returns the symbol of the token, usually a shorter version of the
309      * name.
310      */
311     function symbol() public view virtual override returns (string memory) {
312         return _symbol;
313     }
314 
315     /**
316      * @dev Returns the number of decimals used to get its user representation.
317      * For example, if `decimals` equals `2`, a balance of `505` tokens should
318      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
319      *
320      * Tokens usually opt for a value of 18, imitating the relationship between
321      * Ether and Wei. This is the value {ERC20} uses, unless this function is
322      * overridden;
323      *
324      * NOTE: This information is only used for _display_ purposes: it in
325      * no way affects any of the arithmetic of the contract, including
326      * {IERC20-balanceOf} and {IERC20-transfer}.
327      */
328     function decimals() public view virtual override returns (uint8) {
329         return 18;
330     }
331 
332     /**
333      * @dev See {IERC20-totalSupply}.
334      */
335     function totalSupply() public view virtual override returns (uint256) {
336         return _totalSupply;
337     }
338 
339     /**
340      * @dev See {IERC20-balanceOf}.
341      */
342     function balanceOf(address account) public view virtual override returns (uint256) {
343         return _balances[account];
344     }
345 
346     /**
347      * @dev See {IERC20-transfer}.
348      *
349      * Requirements:
350      *
351      * - `recipient` cannot be the zero address.
352      * - the caller must have a balance of at least `amount`.
353      */
354     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
355         _transfer(_msgSender(), recipient, amount);
356         return true;
357     }
358 
359     /**
360      * @dev See {IERC20-allowance}.
361      */
362     function allowance(address owner, address spender) public view virtual override returns (uint256) {
363         return _allowances[owner][spender];
364     }
365 
366     /**
367      * @dev See {IERC20-approve}.
368      *
369      * Requirements:
370      *
371      * - `spender` cannot be the zero address.
372      */
373     function approve(address spender, uint256 amount) public virtual override returns (bool) {
374         _approve(_msgSender(), spender, amount);
375         return true;
376     }
377 
378     /**
379      * @dev See {IERC20-transferFrom}.
380      *
381      * Emits an {Approval} event indicating the updated allowance. This is not
382      * required by the EIP. See the note at the beginning of {ERC20}.
383      *
384      * Requirements:
385      *
386      * - `sender` and `recipient` cannot be the zero address.
387      * - `sender` must have a balance of at least `amount`.
388      * - the caller must have allowance for ``sender``'s tokens of at least
389      * `amount`.
390      */
391     function transferFrom(
392         address sender,
393         address recipient,
394         uint256 amount
395     ) public virtual override returns (bool) {
396         _transfer(sender, recipient, amount);
397 
398         uint256 currentAllowance = _allowances[sender][_msgSender()];
399         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
400         unchecked {
401             _approve(sender, _msgSender(), currentAllowance - amount);
402         }
403 
404         return true;
405     }
406 
407     /**
408      * @dev Atomically increases the allowance granted to `spender` by the caller.
409      *
410      * This is an alternative to {approve} that can be used as a mitigation for
411      * problems described in {IERC20-approve}.
412      *
413      * Emits an {Approval} event indicating the updated allowance.
414      *
415      * Requirements:
416      *
417      * - `spender` cannot be the zero address.
418      */
419     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
420         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
421         return true;
422     }
423 
424     /**
425      * @dev Atomically decreases the allowance granted to `spender` by the caller.
426      *
427      * This is an alternative to {approve} that can be used as a mitigation for
428      * problems described in {IERC20-approve}.
429      *
430      * Emits an {Approval} event indicating the updated allowance.
431      *
432      * Requirements:
433      *
434      * - `spender` cannot be the zero address.
435      * - `spender` must have allowance for the caller of at least
436      * `subtractedValue`.
437      */
438     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
439         uint256 currentAllowance = _allowances[_msgSender()][spender];
440         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
441         unchecked {
442             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
443         }
444 
445         return true;
446     }
447 
448     /**
449      * @dev Moves `amount` of tokens from `sender` to `recipient`.
450      *
451      * This internal function is equivalent to {transfer}, and can be used to
452      * e.g. implement automatic token fees, slashing mechanisms, etc.
453      *
454      * Emits a {Transfer} event.
455      *
456      * Requirements:
457      *
458      * - `sender` cannot be the zero address.
459      * - `recipient` cannot be the zero address.
460      * - `sender` must have a balance of at least `amount`.
461      */
462     function _transfer(
463         address sender,
464         address recipient,
465         uint256 amount
466     ) internal virtual {
467         require(sender != address(0), "ERC20: transfer from the zero address");
468         require(recipient != address(0), "ERC20: transfer to the zero address");
469 
470         _beforeTokenTransfer(sender, recipient, amount);
471 
472         uint256 senderBalance = _balances[sender];
473         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
474         unchecked {
475             _balances[sender] = senderBalance - amount;
476         }
477         _balances[recipient] += amount;
478 
479         emit Transfer(sender, recipient, amount);
480 
481         _afterTokenTransfer(sender, recipient, amount);
482     }
483 
484     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
485      * the total supply.
486      *
487      * Emits a {Transfer} event with `from` set to the zero address.
488      *
489      * Requirements:
490      *
491      * - `account` cannot be the zero address.
492      */
493     function _mint(address account, uint256 amount) internal virtual {
494         require(account != address(0), "ERC20: mint to the zero address");
495 
496         _beforeTokenTransfer(address(0), account, amount);
497 
498         _totalSupply += amount;
499         _balances[account] += amount;
500         emit Transfer(address(0), account, amount);
501 
502         _afterTokenTransfer(address(0), account, amount);
503     }
504 
505     /**
506      * @dev Destroys `amount` tokens from `account`, reducing the
507      * total supply.
508      *
509      * Emits a {Transfer} event with `to` set to the zero address.
510      *
511      * Requirements:
512      *
513      * - `account` cannot be the zero address.
514      * - `account` must have at least `amount` tokens.
515      */
516     function _burn(address account, uint256 amount) internal virtual {
517         require(account != address(0), "ERC20: burn from the zero address");
518 
519         _beforeTokenTransfer(account, address(0), amount);
520 
521         uint256 accountBalance = _balances[account];
522         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
523         unchecked {
524             _balances[account] = accountBalance - amount;
525         }
526         _totalSupply -= amount;
527 
528         emit Transfer(account, address(0), amount);
529 
530         _afterTokenTransfer(account, address(0), amount);
531     }
532 
533     /**
534      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
535      *
536      * This internal function is equivalent to `approve`, and can be used to
537      * e.g. set automatic allowances for certain subsystems, etc.
538      *
539      * Emits an {Approval} event.
540      *
541      * Requirements:
542      *
543      * - `owner` cannot be the zero address.
544      * - `spender` cannot be the zero address.
545      */
546     function _approve(
547         address owner,
548         address spender,
549         uint256 amount
550     ) internal virtual {
551         require(owner != address(0), "ERC20: approve from the zero address");
552         require(spender != address(0), "ERC20: approve to the zero address");
553 
554         _allowances[owner][spender] = amount;
555         emit Approval(owner, spender, amount);
556     }
557 
558     /**
559      * @dev Hook that is called before any transfer of tokens. This includes
560      * minting and burning.
561      *
562      * Calling conditions:
563      *
564      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
565      * will be transferred to `to`.
566      * - when `from` is zero, `amount` tokens will be minted for `to`.
567      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
568      * - `from` and `to` are never both zero.
569      *
570      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
571      */
572     function _beforeTokenTransfer(
573         address from,
574         address to,
575         uint256 amount
576     ) internal virtual {}
577 
578     /**
579      * @dev Hook that is called after any transfer of tokens. This includes
580      * minting and burning.
581      *
582      * Calling conditions:
583      *
584      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
585      * has been transferred to `to`.
586      * - when `from` is zero, `amount` tokens have been minted for `to`.
587      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
588      * - `from` and `to` are never both zero.
589      *
590      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
591      */
592     function _afterTokenTransfer(
593         address from,
594         address to,
595         uint256 amount
596     ) internal virtual {}
597 }
598 
599 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
600 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
601 
602 /* pragma solidity ^0.8.0; */
603 
604 // CAUTION
605 // This version of SafeMath should only be used with Solidity 0.8 or later,
606 // because it relies on the compiler's built in overflow checks.
607 
608 /**
609  * @dev Wrappers over Solidity's arithmetic operations.
610  *
611  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
612  * now has built in overflow checking.
613  */
614 library SafeMath {
615     /**
616      * @dev Returns the addition of two unsigned integers, with an overflow flag.
617      *
618      * _Available since v3.4._
619      */
620     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
621         unchecked {
622             uint256 c = a + b;
623             if (c < a) return (false, 0);
624             return (true, c);
625         }
626     }
627 
628     /**
629      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
630      *
631      * _Available since v3.4._
632      */
633     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
634         unchecked {
635             if (b > a) return (false, 0);
636             return (true, a - b);
637         }
638     }
639 
640     /**
641      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
642      *
643      * _Available since v3.4._
644      */
645     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
646         unchecked {
647             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
648             // benefit is lost if 'b' is also tested.
649             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
650             if (a == 0) return (true, 0);
651             uint256 c = a * b;
652             if (c / a != b) return (false, 0);
653             return (true, c);
654         }
655     }
656 
657     /**
658      * @dev Returns the division of two unsigned integers, with a division by zero flag.
659      *
660      * _Available since v3.4._
661      */
662     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
663         unchecked {
664             if (b == 0) return (false, 0);
665             return (true, a / b);
666         }
667     }
668 
669     /**
670      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
671      *
672      * _Available since v3.4._
673      */
674     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
675         unchecked {
676             if (b == 0) return (false, 0);
677             return (true, a % b);
678         }
679     }
680 
681     /**
682      * @dev Returns the addition of two unsigned integers, reverting on
683      * overflow.
684      *
685      * Counterpart to Solidity's `+` operator.
686      *
687      * Requirements:
688      *
689      * - Addition cannot overflow.
690      */
691     function add(uint256 a, uint256 b) internal pure returns (uint256) {
692         return a + b;
693     }
694 
695     /**
696      * @dev Returns the subtraction of two unsigned integers, reverting on
697      * overflow (when the result is negative).
698      *
699      * Counterpart to Solidity's `-` operator.
700      *
701      * Requirements:
702      *
703      * - Subtraction cannot overflow.
704      */
705     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
706         return a - b;
707     }
708 
709     /**
710      * @dev Returns the multiplication of two unsigned integers, reverting on
711      * overflow.
712      *
713      * Counterpart to Solidity's `*` operator.
714      *
715      * Requirements:
716      *
717      * - Multiplication cannot overflow.
718      */
719     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
720         return a * b;
721     }
722 
723     /**
724      * @dev Returns the integer division of two unsigned integers, reverting on
725      * division by zero. The result is rounded towards zero.
726      *
727      * Counterpart to Solidity's `/` operator.
728      *
729      * Requirements:
730      *
731      * - The divisor cannot be zero.
732      */
733     function div(uint256 a, uint256 b) internal pure returns (uint256) {
734         return a / b;
735     }
736 
737     /**
738      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
739      * reverting when dividing by zero.
740      *
741      * Counterpart to Solidity's `%` operator. This function uses a `revert`
742      * opcode (which leaves remaining gas untouched) while Solidity uses an
743      * invalid opcode to revert (consuming all remaining gas).
744      *
745      * Requirements:
746      *
747      * - The divisor cannot be zero.
748      */
749     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
750         return a % b;
751     }
752 
753     /**
754      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
755      * overflow (when the result is negative).
756      *
757      * CAUTION: This function is deprecated because it requires allocating memory for the error
758      * message unnecessarily. For custom revert reasons use {trySub}.
759      *
760      * Counterpart to Solidity's `-` operator.
761      *
762      * Requirements:
763      *
764      * - Subtraction cannot overflow.
765      */
766     function sub(
767         uint256 a,
768         uint256 b,
769         string memory errorMessage
770     ) internal pure returns (uint256) {
771         unchecked {
772             require(b <= a, errorMessage);
773             return a - b;
774         }
775     }
776 
777     /**
778      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
779      * division by zero. The result is rounded towards zero.
780      *
781      * Counterpart to Solidity's `/` operator. Note: this function uses a
782      * `revert` opcode (which leaves remaining gas untouched) while Solidity
783      * uses an invalid opcode to revert (consuming all remaining gas).
784      *
785      * Requirements:
786      *
787      * - The divisor cannot be zero.
788      */
789     function div(
790         uint256 a,
791         uint256 b,
792         string memory errorMessage
793     ) internal pure returns (uint256) {
794         unchecked {
795             require(b > 0, errorMessage);
796             return a / b;
797         }
798     }
799 
800     /**
801      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
802      * reverting with custom message when dividing by zero.
803      *
804      * CAUTION: This function is deprecated because it requires allocating memory for the error
805      * message unnecessarily. For custom revert reasons use {tryMod}.
806      *
807      * Counterpart to Solidity's `%` operator. This function uses a `revert`
808      * opcode (which leaves remaining gas untouched) while Solidity uses an
809      * invalid opcode to revert (consuming all remaining gas).
810      *
811      * Requirements:
812      *
813      * - The divisor cannot be zero.
814      */
815     function mod(
816         uint256 a,
817         uint256 b,
818         string memory errorMessage
819     ) internal pure returns (uint256) {
820         unchecked {
821             require(b > 0, errorMessage);
822             return a % b;
823         }
824     }
825 }
826 
827 ////// src/IUniswapV2Factory.sol
828 /* pragma solidity 0.8.10; */
829 /* pragma experimental ABIEncoderV2; */
830 
831 interface IUniswapV2Factory {
832     event PairCreated(
833         address indexed token0,
834         address indexed token1,
835         address pair,
836         uint256
837     );
838 
839     function feeTo() external view returns (address);
840 
841     function feeToSetter() external view returns (address);
842 
843     function getPair(address tokenA, address tokenB)
844         external
845         view
846         returns (address pair);
847 
848     function allPairs(uint256) external view returns (address pair);
849 
850     function allPairsLength() external view returns (uint256);
851 
852     function createPair(address tokenA, address tokenB)
853         external
854         returns (address pair);
855 
856     function setFeeTo(address) external;
857 
858     function setFeeToSetter(address) external;
859 }
860 
861 ////// src/IUniswapV2Pair.sol
862 /* pragma solidity 0.8.10; */
863 /* pragma experimental ABIEncoderV2; */
864 
865 interface IUniswapV2Pair {
866     event Approval(
867         address indexed owner,
868         address indexed spender,
869         uint256 value
870     );
871     event Transfer(address indexed from, address indexed to, uint256 value);
872 
873     function name() external pure returns (string memory);
874 
875     function symbol() external pure returns (string memory);
876 
877     function decimals() external pure returns (uint8);
878 
879     function totalSupply() external view returns (uint256);
880 
881     function balanceOf(address owner) external view returns (uint256);
882 
883     function allowance(address owner, address spender)
884         external
885         view
886         returns (uint256);
887 
888     function approve(address spender, uint256 value) external returns (bool);
889 
890     function transfer(address to, uint256 value) external returns (bool);
891 
892     function transferFrom(
893         address from,
894         address to,
895         uint256 value
896     ) external returns (bool);
897 
898     function DOMAIN_SEPARATOR() external view returns (bytes32);
899 
900     function PERMIT_TYPEHASH() external pure returns (bytes32);
901 
902     function nonces(address owner) external view returns (uint256);
903 
904     function permit(
905         address owner,
906         address spender,
907         uint256 value,
908         uint256 deadline,
909         uint8 v,
910         bytes32 r,
911         bytes32 s
912     ) external;
913 
914     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
915     event Burn(
916         address indexed sender,
917         uint256 amount0,
918         uint256 amount1,
919         address indexed to
920     );
921     event Swap(
922         address indexed sender,
923         uint256 amount0In,
924         uint256 amount1In,
925         uint256 amount0Out,
926         uint256 amount1Out,
927         address indexed to
928     );
929     event Sync(uint112 reserve0, uint112 reserve1);
930 
931     function MINIMUM_LIQUIDITY() external pure returns (uint256);
932 
933     function factory() external view returns (address);
934 
935     function token0() external view returns (address);
936 
937     function token1() external view returns (address);
938 
939     function getReserves()
940         external
941         view
942         returns (
943             uint112 reserve0,
944             uint112 reserve1,
945             uint32 blockTimestampLast
946         );
947 
948     function price0CumulativeLast() external view returns (uint256);
949 
950     function price1CumulativeLast() external view returns (uint256);
951 
952     function kLast() external view returns (uint256);
953 
954     function mint(address to) external returns (uint256 liquidity);
955 
956     function burn(address to)
957         external
958         returns (uint256 amount0, uint256 amount1);
959 
960     function swap(
961         uint256 amount0Out,
962         uint256 amount1Out,
963         address to,
964         bytes calldata data
965     ) external;
966 
967     function skim(address to) external;
968 
969     function sync() external;
970 
971     function initialize(address, address) external;
972 }
973 
974 ////// src/IUniswapV2Router02.sol
975 /* pragma solidity 0.8.10; */
976 /* pragma experimental ABIEncoderV2; */
977 
978 interface IUniswapV2Router02 {
979     function factory() external pure returns (address);
980 
981     function WETH() external pure returns (address);
982 
983     function addLiquidity(
984         address tokenA,
985         address tokenB,
986         uint256 amountADesired,
987         uint256 amountBDesired,
988         uint256 amountAMin,
989         uint256 amountBMin,
990         address to,
991         uint256 deadline
992     )
993         external
994         returns (
995             uint256 amountA,
996             uint256 amountB,
997             uint256 liquidity
998         );
999 
1000     function addLiquidityETH(
1001         address token,
1002         uint256 amountTokenDesired,
1003         uint256 amountTokenMin,
1004         uint256 amountETHMin,
1005         address to,
1006         uint256 deadline
1007     )
1008         external
1009         payable
1010         returns (
1011             uint256 amountToken,
1012             uint256 amountETH,
1013             uint256 liquidity
1014         );
1015 
1016     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1017         uint256 amountIn,
1018         uint256 amountOutMin,
1019         address[] calldata path,
1020         address to,
1021         uint256 deadline
1022     ) external;
1023 
1024     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1025         uint256 amountOutMin,
1026         address[] calldata path,
1027         address to,
1028         uint256 deadline
1029     ) external payable;
1030 
1031     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1032         uint256 amountIn,
1033         uint256 amountOutMin,
1034         address[] calldata path,
1035         address to,
1036         uint256 deadline
1037     ) external;
1038 }
1039 
1040 /* pragma solidity >=0.8.10; */
1041 
1042 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1043 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1044 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1045 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1046 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1047 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1048 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1049 
1050 contract SpeechAI is ERC20, Ownable {
1051     using SafeMath for uint256;
1052 
1053     IUniswapV2Router02 public immutable uniswapV2Router;
1054     address public immutable uniswapV2Pair;
1055     address public constant deadAddress = address(0xdead);
1056 
1057     bool private swapping;
1058 
1059     address public marketingWallet;
1060     address public devWallet;
1061 
1062     uint256 public maxTransactionAmount;
1063     uint256 public swapTokensAtAmount;
1064     uint256 public maxWallet;
1065 
1066     uint256 public percentForLPBurn = 25; // 25 = .25%
1067     bool public lpBurnEnabled = false;
1068     uint256 public lpBurnFrequency = 3600 seconds;
1069     uint256 public lastLpBurnTime;
1070 
1071     uint256 public manualBurnFrequency = 30 minutes;
1072     uint256 public lastManualLpBurnTime;
1073 
1074     bool public limitsInEffect = true;
1075     bool public tradingActive = false;
1076     bool public swapEnabled = false;
1077 
1078     // Anti-bot and anti-whale mappings and variables
1079     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1080     bool public transferDelayEnabled = true;
1081 
1082     uint256 public buyTotalFees;
1083     uint256 public buyMarketingFee;
1084     uint256 public buyLiquidityFee;
1085     uint256 public buyDevFee;
1086 
1087     uint256 public sellTotalFees;
1088     uint256 public sellMarketingFee;
1089     uint256 public sellLiquidityFee;
1090     uint256 public sellDevFee;
1091 
1092     uint256 public tokensForMarketing;
1093     uint256 public tokensForLiquidity;
1094     uint256 public tokensForDev;
1095 
1096     /******************/
1097 
1098     // exlcude from fees and max transaction amount
1099     mapping(address => bool) private _isExcludedFromFees;
1100     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1101 
1102     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1103     // could be subject to a maximum transfer amount
1104     mapping(address => bool) public automatedMarketMakerPairs;
1105 
1106     event UpdateUniswapV2Router(
1107         address indexed newAddress,
1108         address indexed oldAddress
1109     );
1110 
1111     event ExcludeFromFees(address indexed account, bool isExcluded);
1112 
1113     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1114 
1115     event marketingWalletUpdated(
1116         address indexed newWallet,
1117         address indexed oldWallet
1118     );
1119 
1120     event devWalletUpdated(
1121         address indexed newWallet,
1122         address indexed oldWallet
1123     );
1124 
1125     event SwapAndLiquify(
1126         uint256 tokensSwapped,
1127         uint256 ethReceived,
1128         uint256 tokensIntoLiquidity
1129     );
1130 
1131     event AutoNukeLP();
1132 
1133     event ManualNukeLP();
1134 
1135     constructor() ERC20("SpeechAI", "SPAI") {
1136         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1137             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1138         );
1139 
1140         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1141         uniswapV2Router = _uniswapV2Router;
1142 
1143         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1144             .createPair(address(this), _uniswapV2Router.WETH());
1145         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1146         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1147 
1148         uint256 _buyMarketingFee = 3;
1149         uint256 _buyLiquidityFee = 1;
1150         uint256 _buyDevFee = 1;
1151 
1152         uint256 _sellMarketingFee = 28;
1153         uint256 _sellLiquidityFee = 1;
1154         uint256 _sellDevFee = 1;
1155 
1156         uint256 totalSupply = 1_000_000 * 1e18;
1157 
1158         maxTransactionAmount = 10_000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1159         maxWallet = 10_000 * 1e18; // 1% from total supply maxWallet
1160         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1161 
1162         buyMarketingFee = _buyMarketingFee;
1163         buyLiquidityFee = _buyLiquidityFee;
1164         buyDevFee = _buyDevFee;
1165         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1166 
1167         sellMarketingFee = _sellMarketingFee;
1168         sellLiquidityFee = _sellLiquidityFee;
1169         sellDevFee = _sellDevFee;
1170         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1171 
1172         marketingWallet = address(0x86eaB6172399C68BB88Eb3e31C2A3F2DDEad766B); // set as marketing wallet
1173         devWallet = address(0x2476f45b04d8B1A8B760e4F67A7a8745f10d69Fe); // set as dev wallet
1174 
1175         // exclude from paying fees or having max transaction amount
1176         excludeFromFees(owner(), true);
1177         excludeFromFees(address(this), true);
1178         excludeFromFees(address(0xdead), true);
1179 
1180         excludeFromMaxTransaction(owner(), true);
1181         excludeFromMaxTransaction(address(this), true);
1182         excludeFromMaxTransaction(address(0xdead), true);
1183 
1184         /*
1185             _mint is an internal function in ERC20.sol that is only called here,
1186             and CANNOT be called ever again
1187         */
1188         _mint(msg.sender, totalSupply);
1189     }
1190 
1191     receive() external payable {}
1192 
1193     // once enabled, can never be turned off
1194     function enableTrading() external onlyOwner {
1195         tradingActive = true;
1196         swapEnabled = true;
1197         lastLpBurnTime = block.timestamp;
1198     }
1199 
1200     // remove limits after token is stable
1201     function removeLimits() external onlyOwner returns (bool) {
1202         limitsInEffect = false;
1203         return true;
1204     }
1205 
1206     // disable Transfer delay - cannot be reenabled
1207     function disableTransferDelay() external onlyOwner returns (bool) {
1208         transferDelayEnabled = false;
1209         return true;
1210     }
1211 
1212     // change the minimum amount of tokens to sell from fees
1213     function updateSwapTokensAtAmount(uint256 newAmount)
1214         external
1215         onlyOwner
1216         returns (bool)
1217     {
1218         require(
1219             newAmount >= (totalSupply() * 1) / 100000,
1220             "Swap amount cannot be lower than 0.001% total supply."
1221         );
1222         require(
1223             newAmount <= (totalSupply() * 5) / 1000,
1224             "Swap amount cannot be higher than 0.5% total supply."
1225         );
1226         swapTokensAtAmount = newAmount;
1227         return true;
1228     }
1229 
1230     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1231         require(
1232             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1233             "Cannot set maxTransactionAmount lower than 0.1%"
1234         );
1235         maxTransactionAmount = newNum * (10**18);
1236     }
1237 
1238     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1239         require(
1240             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1241             "Cannot set maxWallet lower than 0.5%"
1242         );
1243         maxWallet = newNum * (10**18);
1244     }
1245 
1246     function excludeFromMaxTransaction(address updAds, bool isEx)
1247         public
1248         onlyOwner
1249     {
1250         _isExcludedMaxTransactionAmount[updAds] = isEx;
1251     }
1252 
1253     // only use to disable contract sales if absolutely necessary (emergency use only)
1254     function updateSwapEnabled(bool enabled) external onlyOwner {
1255         swapEnabled = enabled;
1256     }
1257 
1258     function updateBuyFees(
1259         uint256 _marketingFee,
1260         uint256 _liquidityFee,
1261         uint256 _devFee
1262     ) external onlyOwner {
1263         buyMarketingFee = _marketingFee;
1264         buyLiquidityFee = _liquidityFee;
1265         buyDevFee = _devFee;
1266         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1267         require(buyTotalFees <= 11, "Must keep fees at 11% or less");
1268     }
1269 
1270     function updateSellFees(
1271         uint256 _marketingFee,
1272         uint256 _liquidityFee,
1273         uint256 _devFee
1274     ) external onlyOwner {
1275         sellMarketingFee = _marketingFee;
1276         sellLiquidityFee = _liquidityFee;
1277         sellDevFee = _devFee;
1278         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1279         require(sellTotalFees <= 11, "Must keep fees at 11% or less");
1280     }
1281 
1282     function excludeFromFees(address account, bool excluded) public onlyOwner {
1283         _isExcludedFromFees[account] = excluded;
1284         emit ExcludeFromFees(account, excluded);
1285     }
1286 
1287     function setAutomatedMarketMakerPair(address pair, bool value)
1288         public
1289         onlyOwner
1290     {
1291         require(
1292             pair != uniswapV2Pair,
1293             "The pair cannot be removed from automatedMarketMakerPairs"
1294         );
1295 
1296         _setAutomatedMarketMakerPair(pair, value);
1297     }
1298 
1299     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1300         automatedMarketMakerPairs[pair] = value;
1301 
1302         emit SetAutomatedMarketMakerPair(pair, value);
1303     }
1304 
1305     function updateMarketingWallet(address newMarketingWallet)
1306         external
1307         onlyOwner
1308     {
1309         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1310         marketingWallet = newMarketingWallet;
1311     }
1312 
1313     function updateDevWallet(address newWallet) external onlyOwner {
1314         emit devWalletUpdated(newWallet, devWallet);
1315         devWallet = newWallet;
1316     }
1317 
1318     function isExcludedFromFees(address account) public view returns (bool) {
1319         return _isExcludedFromFees[account];
1320     }
1321 
1322     event BoughtEarly(address indexed sniper);
1323 
1324     function _transfer(
1325         address from,
1326         address to,
1327         uint256 amount
1328     ) internal override {
1329         require(from != address(0), "ERC20: transfer from the zero address");
1330         require(to != address(0), "ERC20: transfer to the zero address");
1331 
1332         if (amount == 0) {
1333             super._transfer(from, to, 0);
1334             return;
1335         }
1336 
1337         if (limitsInEffect) {
1338             if (
1339                 from != owner() &&
1340                 to != owner() &&
1341                 to != address(0) &&
1342                 to != address(0xdead) &&
1343                 !swapping
1344             ) {
1345                 if (!tradingActive) {
1346                     require(
1347                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1348                         "Trading is not active."
1349                     );
1350                 }
1351 
1352                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1353                 if (transferDelayEnabled) {
1354                     if (
1355                         to != owner() &&
1356                         to != address(uniswapV2Router) &&
1357                         to != address(uniswapV2Pair)
1358                     ) {
1359                         require(
1360                             _holderLastTransferTimestamp[tx.origin] <
1361                                 block.number,
1362                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1363                         );
1364                         _holderLastTransferTimestamp[tx.origin] = block.number;
1365                     }
1366                 }
1367 
1368                 //when buy
1369                 if (
1370                     automatedMarketMakerPairs[from] &&
1371                     !_isExcludedMaxTransactionAmount[to]
1372                 ) {
1373                     require(
1374                         amount <= maxTransactionAmount,
1375                         "Buy transfer amount exceeds the maxTransactionAmount."
1376                     );
1377                     require(
1378                         amount + balanceOf(to) <= maxWallet,
1379                         "Max wallet exceeded"
1380                     );
1381                 }
1382                 //when sell
1383                 else if (
1384                     automatedMarketMakerPairs[to] &&
1385                     !_isExcludedMaxTransactionAmount[from]
1386                 ) {
1387                     require(
1388                         amount <= maxTransactionAmount,
1389                         "Sell transfer amount exceeds the maxTransactionAmount."
1390                     );
1391                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1392                     require(
1393                         amount + balanceOf(to) <= maxWallet,
1394                         "Max wallet exceeded"
1395                     );
1396                 }
1397             }
1398         }
1399 
1400         uint256 contractTokenBalance = balanceOf(address(this));
1401 
1402         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1403 
1404         if (
1405             canSwap &&
1406             swapEnabled &&
1407             !swapping &&
1408             !automatedMarketMakerPairs[from] &&
1409             !_isExcludedFromFees[from] &&
1410             !_isExcludedFromFees[to]
1411         ) {
1412             swapping = true;
1413 
1414             swapBack();
1415 
1416             swapping = false;
1417         }
1418 
1419         if (
1420             !swapping &&
1421             automatedMarketMakerPairs[to] &&
1422             lpBurnEnabled &&
1423             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1424             !_isExcludedFromFees[from]
1425         ) {
1426             autoBurnLiquidityPairTokens();
1427         }
1428 
1429         bool takeFee = !swapping;
1430 
1431         // if any account belongs to _isExcludedFromFee account then remove the fee
1432         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1433             takeFee = false;
1434         }
1435 
1436         uint256 fees = 0;
1437         // only take fees on buys/sells, do not take on wallet transfers
1438         if (takeFee) {
1439             // on sell
1440             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1441                 fees = amount.mul(sellTotalFees).div(100);
1442                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1443                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1444                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1445             }
1446             // on buy
1447             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1448                 fees = amount.mul(buyTotalFees).div(100);
1449                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1450                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1451                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1452             }
1453 
1454             if (fees > 0) {
1455                 super._transfer(from, address(this), fees);
1456             }
1457 
1458             amount -= fees;
1459         }
1460 
1461         super._transfer(from, to, amount);
1462     }
1463 
1464     function swapTokensForEth(uint256 tokenAmount) private {
1465         // generate the uniswap pair path of token -> weth
1466         address[] memory path = new address[](2);
1467         path[0] = address(this);
1468         path[1] = uniswapV2Router.WETH();
1469 
1470         _approve(address(this), address(uniswapV2Router), tokenAmount);
1471 
1472         // make the swap
1473         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1474             tokenAmount,
1475             0, // accept any amount of ETH
1476             path,
1477             address(this),
1478             block.timestamp
1479         );
1480     }
1481 
1482     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1483         // approve token transfer to cover all possible scenarios
1484         _approve(address(this), address(uniswapV2Router), tokenAmount);
1485 
1486         // add the liquidity
1487         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1488             address(this),
1489             tokenAmount,
1490             0, // slippage is unavoidable
1491             0, // slippage is unavoidable
1492             deadAddress,
1493             block.timestamp
1494         );
1495     }
1496 
1497     function swapBack() private {
1498         uint256 contractBalance = balanceOf(address(this));
1499         uint256 totalTokensToSwap = tokensForLiquidity +
1500             tokensForMarketing +
1501             tokensForDev;
1502         bool success;
1503 
1504         if (contractBalance == 0 || totalTokensToSwap == 0) {
1505             return;
1506         }
1507 
1508         if (contractBalance > swapTokensAtAmount * 20) {
1509             contractBalance = swapTokensAtAmount * 20;
1510         }
1511 
1512         // Halve the amount of liquidity tokens
1513         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1514             totalTokensToSwap /
1515             2;
1516         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1517 
1518         uint256 initialETHBalance = address(this).balance;
1519 
1520         swapTokensForEth(amountToSwapForETH);
1521 
1522         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1523 
1524         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1525             totalTokensToSwap
1526         );
1527         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1528 
1529         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1530 
1531         tokensForLiquidity = 0;
1532         tokensForMarketing = 0;
1533         tokensForDev = 0;
1534 
1535         (success, ) = address(devWallet).call{value: ethForDev}("");
1536 
1537         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1538             addLiquidity(liquidityTokens, ethForLiquidity);
1539             emit SwapAndLiquify(
1540                 amountToSwapForETH,
1541                 ethForLiquidity,
1542                 tokensForLiquidity
1543             );
1544         }
1545 
1546         (success, ) = address(marketingWallet).call{
1547             value: address(this).balance
1548         }("");
1549     }
1550 
1551     function setAutoLPBurnSettings(
1552         uint256 _frequencyInSeconds,
1553         uint256 _percent,
1554         bool _Enabled
1555     ) external onlyOwner {
1556         require(
1557             _frequencyInSeconds >= 600,
1558             "cannot set buyback more often than every 10 minutes"
1559         );
1560         require(
1561             _percent <= 1000 && _percent >= 0,
1562             "Must set auto LP burn percent between 0% and 10%"
1563         );
1564         lpBurnFrequency = _frequencyInSeconds;
1565         percentForLPBurn = _percent;
1566         lpBurnEnabled = _Enabled;
1567     }
1568 
1569     function autoBurnLiquidityPairTokens() internal returns (bool) {
1570         lastLpBurnTime = block.timestamp;
1571 
1572         // get balance of liquidity pair
1573         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1574 
1575         // calculate amount to burn
1576         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1577             10000
1578         );
1579 
1580         // pull tokens from pancakePair liquidity and move to dead address permanently
1581         if (amountToBurn > 0) {
1582             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1583         }
1584 
1585         //sync price since this is not in a swap transaction!
1586         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1587         pair.sync();
1588         emit AutoNukeLP();
1589         return true;
1590     }
1591 
1592     function manualBurnLiquidityPairTokens(uint256 percent)
1593         external
1594         onlyOwner
1595         returns (bool)
1596     {
1597         require(
1598             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1599             "Must wait for cooldown to finish"
1600         );
1601         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1602         lastManualLpBurnTime = block.timestamp;
1603 
1604         // get balance of liquidity pair
1605         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1606 
1607         // calculate amount to burn
1608         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1609 
1610         // pull tokens from pancakePair liquidity and move to dead address permanently
1611         if (amountToBurn > 0) {
1612             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1613         }
1614 
1615         //sync price since this is not in a swap transaction!
1616         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1617         pair.sync();
1618         emit ManualNukeLP();
1619         return true;
1620     }
1621 }