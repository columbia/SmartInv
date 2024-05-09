1 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(
65         address sender,
66         address recipient,
67         uint256 amount
68     ) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 
86 // Dependency file: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
87 
88 
89 // pragma solidity ^0.8.0;
90 
91 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
92 
93 /**
94  * @dev Interface for the optional metadata functions from the ERC20 standard.
95  *
96  * _Available since v4.1._
97  */
98 interface IERC20Metadata is IERC20 {
99     /**
100      * @dev Returns the name of the token.
101      */
102     function name() external view returns (string memory);
103 
104     /**
105      * @dev Returns the symbol of the token.
106      */
107     function symbol() external view returns (string memory);
108 
109     /**
110      * @dev Returns the decimals places of the token.
111      */
112     function decimals() external view returns (uint8);
113 }
114 
115 
116 // Dependency file: @openzeppelin/contracts/utils/Context.sol
117 
118 
119 // pragma solidity ^0.8.0;
120 
121 /**
122  * @dev Provides information about the current execution context, including the
123  * sender of the transaction and its data. While these are generally available
124  * via msg.sender and msg.data, they should not be accessed in such a direct
125  * manner, since when dealing with meta-transactions the account sending and
126  * paying for execution may not be the actual sender (as far as an application
127  * is concerned).
128  *
129  * This contract is only required for intermediate, library-like contracts.
130  */
131 abstract contract Context {
132     function _msgSender() internal view virtual returns (address) {
133         return msg.sender;
134     }
135 
136     function _msgData() internal view virtual returns (bytes calldata) {
137         return msg.data;
138     }
139 }
140 
141 
142 // Dependency file: @openzeppelin/contracts/token/ERC20/ERC20.sol
143 
144 
145 // pragma solidity ^0.8.0;
146 
147 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
148 // import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
149 // import "@openzeppelin/contracts/utils/Context.sol";
150 
151 /**
152  * @dev Implementation of the {IERC20} interface.
153  *
154  * This implementation is agnostic to the way tokens are created. This means
155  * that a supply mechanism has to be added in a derived contract using {_mint}.
156  * For a generic mechanism see {ERC20PresetMinterPauser}.
157  *
158  * TIP: For a detailed writeup see our guide
159  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
160  * to implement supply mechanisms].
161  *
162  * We have followed general OpenZeppelin Contracts guidelines: functions revert
163  * instead returning `false` on failure. This behavior is nonetheless
164  * conventional and does not conflict with the expectations of ERC20
165  * applications.
166  *
167  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
168  * This allows applications to reconstruct the allowance for all accounts just
169  * by listening to said events. Other implementations of the EIP may not emit
170  * these events, as it isn't required by the specification.
171  *
172  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
173  * functions have been added to mitigate the well-known issues around setting
174  * allowances. See {IERC20-approve}.
175  */
176 contract ERC20 is Context, IERC20, IERC20Metadata {
177     mapping(address => uint256) private _balances;
178 
179     mapping(address => mapping(address => uint256)) private _allowances;
180 
181     uint256 private _totalSupply;
182 
183     string private _name;
184     string private _symbol;
185 
186     /**
187      * @dev Sets the values for {name} and {symbol}.
188      *
189      * The default value of {decimals} is 18. To select a different value for
190      * {decimals} you should overload it.
191      *
192      * All two of these values are immutable: they can only be set once during
193      * construction.
194      */
195     constructor(string memory name_, string memory symbol_) {
196         _name = name_;
197         _symbol = symbol_;
198     }
199 
200     /**
201      * @dev Returns the name of the token.
202      */
203     function name() public view virtual override returns (string memory) {
204         return _name;
205     }
206 
207     /**
208      * @dev Returns the symbol of the token, usually a shorter version of the
209      * name.
210      */
211     function symbol() public view virtual override returns (string memory) {
212         return _symbol;
213     }
214 
215     /**
216      * @dev Returns the number of decimals used to get its user representation.
217      * For example, if `decimals` equals `2`, a balance of `505` tokens should
218      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
219      *
220      * Tokens usually opt for a value of 18, imitating the relationship between
221      * Ether and Wei. This is the value {ERC20} uses, unless this function is
222      * overridden;
223      *
224      * NOTE: This information is only used for _display_ purposes: it in
225      * no way affects any of the arithmetic of the contract, including
226      * {IERC20-balanceOf} and {IERC20-transfer}.
227      */
228     function decimals() public view virtual override returns (uint8) {
229         return 18;
230     }
231 
232     /**
233      * @dev See {IERC20-totalSupply}.
234      */
235     function totalSupply() public view virtual override returns (uint256) {
236         return _totalSupply;
237     }
238 
239     /**
240      * @dev See {IERC20-balanceOf}.
241      */
242     function balanceOf(address account) public view virtual override returns (uint256) {
243         return _balances[account];
244     }
245 
246     /**
247      * @dev See {IERC20-transfer}.
248      *
249      * Requirements:
250      *
251      * - `recipient` cannot be the zero address.
252      * - the caller must have a balance of at least `amount`.
253      */
254     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
255         _transfer(_msgSender(), recipient, amount);
256         return true;
257     }
258 
259     /**
260      * @dev See {IERC20-allowance}.
261      */
262     function allowance(address owner, address spender) public view virtual override returns (uint256) {
263         return _allowances[owner][spender];
264     }
265 
266     /**
267      * @dev See {IERC20-approve}.
268      *
269      * Requirements:
270      *
271      * - `spender` cannot be the zero address.
272      */
273     function approve(address spender, uint256 amount) public virtual override returns (bool) {
274         _approve(_msgSender(), spender, amount);
275         return true;
276     }
277 
278     /**
279      * @dev See {IERC20-transferFrom}.
280      *
281      * Emits an {Approval} event indicating the updated allowance. This is not
282      * required by the EIP. See the note at the beginning of {ERC20}.
283      *
284      * Requirements:
285      *
286      * - `sender` and `recipient` cannot be the zero address.
287      * - `sender` must have a balance of at least `amount`.
288      * - the caller must have allowance for ``sender``'s tokens of at least
289      * `amount`.
290      */
291     function transferFrom(
292         address sender,
293         address recipient,
294         uint256 amount
295     ) public virtual override returns (bool) {
296         _transfer(sender, recipient, amount);
297 
298         uint256 currentAllowance = _allowances[sender][_msgSender()];
299         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
300         unchecked {
301             _approve(sender, _msgSender(), currentAllowance - amount);
302         }
303 
304         return true;
305     }
306 
307     /**
308      * @dev Atomically increases the allowance granted to `spender` by the caller.
309      *
310      * This is an alternative to {approve} that can be used as a mitigation for
311      * problems described in {IERC20-approve}.
312      *
313      * Emits an {Approval} event indicating the updated allowance.
314      *
315      * Requirements:
316      *
317      * - `spender` cannot be the zero address.
318      */
319     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
320         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
321         return true;
322     }
323 
324     /**
325      * @dev Atomically decreases the allowance granted to `spender` by the caller.
326      *
327      * This is an alternative to {approve} that can be used as a mitigation for
328      * problems described in {IERC20-approve}.
329      *
330      * Emits an {Approval} event indicating the updated allowance.
331      *
332      * Requirements:
333      *
334      * - `spender` cannot be the zero address.
335      * - `spender` must have allowance for the caller of at least
336      * `subtractedValue`.
337      */
338     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
339         uint256 currentAllowance = _allowances[_msgSender()][spender];
340         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
341         unchecked {
342             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
343         }
344 
345         return true;
346     }
347 
348     /**
349      * @dev Moves `amount` of tokens from `sender` to `recipient`.
350      *
351      * This internal function is equivalent to {transfer}, and can be used to
352      * e.g. implement automatic token fees, slashing mechanisms, etc.
353      *
354      * Emits a {Transfer} event.
355      *
356      * Requirements:
357      *
358      * - `sender` cannot be the zero address.
359      * - `recipient` cannot be the zero address.
360      * - `sender` must have a balance of at least `amount`.
361      */
362     function _transfer(
363         address sender,
364         address recipient,
365         uint256 amount
366     ) internal virtual {
367         require(sender != address(0), "ERC20: transfer from the zero address");
368         require(recipient != address(0), "ERC20: transfer to the zero address");
369 
370         _beforeTokenTransfer(sender, recipient, amount);
371 
372         uint256 senderBalance = _balances[sender];
373         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
374         unchecked {
375             _balances[sender] = senderBalance - amount;
376         }
377         _balances[recipient] += amount;
378 
379         emit Transfer(sender, recipient, amount);
380 
381         _afterTokenTransfer(sender, recipient, amount);
382     }
383 
384     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
385      * the total supply.
386      *
387      * Emits a {Transfer} event with `from` set to the zero address.
388      *
389      * Requirements:
390      *
391      * - `account` cannot be the zero address.
392      */
393     function _mint(address account, uint256 amount) internal virtual {
394         require(account != address(0), "ERC20: mint to the zero address");
395 
396         _beforeTokenTransfer(address(0), account, amount);
397 
398         _totalSupply += amount;
399         _balances[account] += amount;
400         emit Transfer(address(0), account, amount);
401 
402         _afterTokenTransfer(address(0), account, amount);
403     }
404 
405     /**
406      * @dev Destroys `amount` tokens from `account`, reducing the
407      * total supply.
408      *
409      * Emits a {Transfer} event with `to` set to the zero address.
410      *
411      * Requirements:
412      *
413      * - `account` cannot be the zero address.
414      * - `account` must have at least `amount` tokens.
415      */
416     function _burn(address account, uint256 amount) internal virtual {
417         require(account != address(0), "ERC20: burn from the zero address");
418 
419         _beforeTokenTransfer(account, address(0), amount);
420 
421         uint256 accountBalance = _balances[account];
422         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
423         unchecked {
424             _balances[account] = accountBalance - amount;
425         }
426         _totalSupply -= amount;
427 
428         emit Transfer(account, address(0), amount);
429 
430         _afterTokenTransfer(account, address(0), amount);
431     }
432 
433     /**
434      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
435      *
436      * This internal function is equivalent to `approve`, and can be used to
437      * e.g. set automatic allowances for certain subsystems, etc.
438      *
439      * Emits an {Approval} event.
440      *
441      * Requirements:
442      *
443      * - `owner` cannot be the zero address.
444      * - `spender` cannot be the zero address.
445      */
446     function _approve(
447         address owner,
448         address spender,
449         uint256 amount
450     ) internal virtual {
451         require(owner != address(0), "ERC20: approve from the zero address");
452         require(spender != address(0), "ERC20: approve to the zero address");
453 
454         _allowances[owner][spender] = amount;
455         emit Approval(owner, spender, amount);
456     }
457 
458     /**
459      * @dev Hook that is called before any transfer of tokens. This includes
460      * minting and burning.
461      *
462      * Calling conditions:
463      *
464      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
465      * will be transferred to `to`.
466      * - when `from` is zero, `amount` tokens will be minted for `to`.
467      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
468      * - `from` and `to` are never both zero.
469      *
470      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
471      */
472     function _beforeTokenTransfer(
473         address from,
474         address to,
475         uint256 amount
476     ) internal virtual {}
477 
478     /**
479      * @dev Hook that is called after any transfer of tokens. This includes
480      * minting and burning.
481      *
482      * Calling conditions:
483      *
484      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
485      * has been transferred to `to`.
486      * - when `from` is zero, `amount` tokens have been minted for `to`.
487      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
488      * - `from` and `to` are never both zero.
489      *
490      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
491      */
492     function _afterTokenTransfer(
493         address from,
494         address to,
495         uint256 amount
496     ) internal virtual {}
497 }
498 
499 
500 // Dependency file: @openzeppelin/contracts/access/Ownable.sol
501 
502 
503 // pragma solidity ^0.8.0;
504 
505 // import "@openzeppelin/contracts/utils/Context.sol";
506 
507 /**
508  * @dev Contract module which provides a basic access control mechanism, where
509  * there is an account (an owner) that can be granted exclusive access to
510  * specific functions.
511  *
512  * By default, the owner account will be the one that deploys the contract. This
513  * can later be changed with {transferOwnership}.
514  *
515  * This module is used through inheritance. It will make available the modifier
516  * `onlyOwner`, which can be applied to your functions to restrict their use to
517  * the owner.
518  */
519 abstract contract Ownable is Context {
520     address private _owner;
521 
522     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
523 
524     /**
525      * @dev Initializes the contract setting the deployer as the initial owner.
526      */
527     constructor() {
528         _setOwner(_msgSender());
529     }
530 
531     /**
532      * @dev Returns the address of the current owner.
533      */
534     function owner() public view virtual returns (address) {
535         return _owner;
536     }
537 
538     /**
539      * @dev Throws if called by any account other than the owner.
540      */
541     modifier onlyOwner() {
542         require(owner() == _msgSender(), "Ownable: caller is not the owner");
543         _;
544     }
545 
546     /**
547      * @dev Leaves the contract without owner. It will not be possible to call
548      * `onlyOwner` functions anymore. Can only be called by the current owner.
549      *
550      * NOTE: Renouncing ownership will leave the contract without an owner,
551      * thereby removing any functionality that is only available to the owner.
552      */
553     function renounceOwnership() public virtual onlyOwner {
554         _setOwner(address(0));
555     }
556 
557     /**
558      * @dev Transfers ownership of the contract to a new account (`newOwner`).
559      * Can only be called by the current owner.
560      */
561     function transferOwnership(address newOwner) public virtual onlyOwner {
562         require(newOwner != address(0), "Ownable: new owner is the zero address");
563         _setOwner(newOwner);
564     }
565 
566     function _setOwner(address newOwner) private {
567         address oldOwner = _owner;
568         _owner = newOwner;
569         emit OwnershipTransferred(oldOwner, newOwner);
570     }
571 }
572 
573 
574 // Dependency file: @openzeppelin/contracts/utils/math/SafeMath.sol
575 
576 
577 // pragma solidity ^0.8.0;
578 
579 // CAUTION
580 // This version of SafeMath should only be used with Solidity 0.8 or later,
581 // because it relies on the compiler's built in overflow checks.
582 
583 /**
584  * @dev Wrappers over Solidity's arithmetic operations.
585  *
586  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
587  * now has built in overflow checking.
588  */
589 library SafeMath {
590     /**
591      * @dev Returns the addition of two unsigned integers, with an overflow flag.
592      *
593      * _Available since v3.4._
594      */
595     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
596         unchecked {
597             uint256 c = a + b;
598             if (c < a) return (false, 0);
599             return (true, c);
600         }
601     }
602 
603     /**
604      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
605      *
606      * _Available since v3.4._
607      */
608     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
609         unchecked {
610             if (b > a) return (false, 0);
611             return (true, a - b);
612         }
613     }
614 
615     /**
616      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
617      *
618      * _Available since v3.4._
619      */
620     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
621         unchecked {
622             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
623             // benefit is lost if 'b' is also tested.
624             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
625             if (a == 0) return (true, 0);
626             uint256 c = a * b;
627             if (c / a != b) return (false, 0);
628             return (true, c);
629         }
630     }
631 
632     /**
633      * @dev Returns the division of two unsigned integers, with a division by zero flag.
634      *
635      * _Available since v3.4._
636      */
637     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
638         unchecked {
639             if (b == 0) return (false, 0);
640             return (true, a / b);
641         }
642     }
643 
644     /**
645      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
646      *
647      * _Available since v3.4._
648      */
649     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
650         unchecked {
651             if (b == 0) return (false, 0);
652             return (true, a % b);
653         }
654     }
655 
656     /**
657      * @dev Returns the addition of two unsigned integers, reverting on
658      * overflow.
659      *
660      * Counterpart to Solidity's `+` operator.
661      *
662      * Requirements:
663      *
664      * - Addition cannot overflow.
665      */
666     function add(uint256 a, uint256 b) internal pure returns (uint256) {
667         return a + b;
668     }
669 
670     /**
671      * @dev Returns the subtraction of two unsigned integers, reverting on
672      * overflow (when the result is negative).
673      *
674      * Counterpart to Solidity's `-` operator.
675      *
676      * Requirements:
677      *
678      * - Subtraction cannot overflow.
679      */
680     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
681         return a - b;
682     }
683 
684     /**
685      * @dev Returns the multiplication of two unsigned integers, reverting on
686      * overflow.
687      *
688      * Counterpart to Solidity's `*` operator.
689      *
690      * Requirements:
691      *
692      * - Multiplication cannot overflow.
693      */
694     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
695         return a * b;
696     }
697 
698     /**
699      * @dev Returns the integer division of two unsigned integers, reverting on
700      * division by zero. The result is rounded towards zero.
701      *
702      * Counterpart to Solidity's `/` operator.
703      *
704      * Requirements:
705      *
706      * - The divisor cannot be zero.
707      */
708     function div(uint256 a, uint256 b) internal pure returns (uint256) {
709         return a / b;
710     }
711 
712     /**
713      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
714      * reverting when dividing by zero.
715      *
716      * Counterpart to Solidity's `%` operator. This function uses a `revert`
717      * opcode (which leaves remaining gas untouched) while Solidity uses an
718      * invalid opcode to revert (consuming all remaining gas).
719      *
720      * Requirements:
721      *
722      * - The divisor cannot be zero.
723      */
724     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
725         return a % b;
726     }
727 
728     /**
729      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
730      * overflow (when the result is negative).
731      *
732      * CAUTION: This function is deprecated because it requires allocating memory for the error
733      * message unnecessarily. For custom revert reasons use {trySub}.
734      *
735      * Counterpart to Solidity's `-` operator.
736      *
737      * Requirements:
738      *
739      * - Subtraction cannot overflow.
740      */
741     function sub(
742         uint256 a,
743         uint256 b,
744         string memory errorMessage
745     ) internal pure returns (uint256) {
746         unchecked {
747             require(b <= a, errorMessage);
748             return a - b;
749         }
750     }
751 
752     /**
753      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
754      * division by zero. The result is rounded towards zero.
755      *
756      * Counterpart to Solidity's `/` operator. Note: this function uses a
757      * `revert` opcode (which leaves remaining gas untouched) while Solidity
758      * uses an invalid opcode to revert (consuming all remaining gas).
759      *
760      * Requirements:
761      *
762      * - The divisor cannot be zero.
763      */
764     function div(
765         uint256 a,
766         uint256 b,
767         string memory errorMessage
768     ) internal pure returns (uint256) {
769         unchecked {
770             require(b > 0, errorMessage);
771             return a / b;
772         }
773     }
774 
775     /**
776      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
777      * reverting with custom message when dividing by zero.
778      *
779      * CAUTION: This function is deprecated because it requires allocating memory for the error
780      * message unnecessarily. For custom revert reasons use {tryMod}.
781      *
782      * Counterpart to Solidity's `%` operator. This function uses a `revert`
783      * opcode (which leaves remaining gas untouched) while Solidity uses an
784      * invalid opcode to revert (consuming all remaining gas).
785      *
786      * Requirements:
787      *
788      * - The divisor cannot be zero.
789      */
790     function mod(
791         uint256 a,
792         uint256 b,
793         string memory errorMessage
794     ) internal pure returns (uint256) {
795         unchecked {
796             require(b > 0, errorMessage);
797             return a % b;
798         }
799     }
800 }
801 
802 
803 // Dependency file: @openzeppelin/contracts/proxy/Clones.sol
804 
805 
806 // pragma solidity ^0.8.0;
807 
808 /**
809  * @dev https://eips.ethereum.org/EIPS/eip-1167[EIP 1167] is a standard for
810  * deploying minimal proxy contracts, also known as "clones".
811  *
812  * > To simply and cheaply clone contract functionality in an immutable way, this standard specifies
813  * > a minimal bytecode implementation that delegates all calls to a known, fixed address.
814  *
815  * The library includes functions to deploy a proxy using either `create` (traditional deployment) or `create2`
816  * (salted deterministic deployment). It also includes functions to predict the addresses of clones deployed using the
817  * deterministic method.
818  *
819  * _Available since v3.4._
820  */
821 library Clones {
822     /**
823      * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
824      *
825      * This function uses the create opcode, which should never revert.
826      */
827     function clone(address implementation) internal returns (address instance) {
828         assembly {
829             let ptr := mload(0x40)
830             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
831             mstore(add(ptr, 0x14), shl(0x60, implementation))
832             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
833             instance := create(0, ptr, 0x37)
834         }
835         require(instance != address(0), "ERC1167: create failed");
836     }
837 
838     /**
839      * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
840      *
841      * This function uses the create2 opcode and a `salt` to deterministically deploy
842      * the clone. Using the same `implementation` and `salt` multiple time will revert, since
843      * the clones cannot be deployed twice at the same address.
844      */
845     function cloneDeterministic(address implementation, bytes32 salt) internal returns (address instance) {
846         assembly {
847             let ptr := mload(0x40)
848             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
849             mstore(add(ptr, 0x14), shl(0x60, implementation))
850             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
851             instance := create2(0, ptr, 0x37, salt)
852         }
853         require(instance != address(0), "ERC1167: create2 failed");
854     }
855 
856     /**
857      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
858      */
859     function predictDeterministicAddress(
860         address implementation,
861         bytes32 salt,
862         address deployer
863     ) internal pure returns (address predicted) {
864         assembly {
865             let ptr := mload(0x40)
866             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
867             mstore(add(ptr, 0x14), shl(0x60, implementation))
868             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf3ff00000000000000000000000000000000)
869             mstore(add(ptr, 0x38), shl(0x60, deployer))
870             mstore(add(ptr, 0x4c), salt)
871             mstore(add(ptr, 0x6c), keccak256(ptr, 0x37))
872             predicted := keccak256(add(ptr, 0x37), 0x55)
873         }
874     }
875 
876     /**
877      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
878      */
879     function predictDeterministicAddress(address implementation, bytes32 salt)
880         internal
881         view
882         returns (address predicted)
883     {
884         return predictDeterministicAddress(implementation, salt, address(this));
885     }
886 }
887 
888 
889 // Dependency file: @openzeppelin/contracts/utils/Address.sol
890 
891 
892 // pragma solidity ^0.8.0;
893 
894 /**
895  * @dev Collection of functions related to the address type
896  */
897 library Address {
898     /**
899      * @dev Returns true if `account` is a contract.
900      *
901      * [IMPORTANT]
902      * ====
903      * It is unsafe to assume that an address for which this function returns
904      * false is an externally-owned account (EOA) and not a contract.
905      *
906      * Among others, `isContract` will return false for the following
907      * types of addresses:
908      *
909      *  - an externally-owned account
910      *  - a contract in construction
911      *  - an address where a contract will be created
912      *  - an address where a contract lived, but was destroyed
913      * ====
914      */
915     function isContract(address account) internal view returns (bool) {
916         // This method relies on extcodesize, which returns 0 for contracts in
917         // construction, since the code is only stored at the end of the
918         // constructor execution.
919 
920         uint256 size;
921         assembly {
922             size := extcodesize(account)
923         }
924         return size > 0;
925     }
926 
927     /**
928      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
929      * `recipient`, forwarding all available gas and reverting on errors.
930      *
931      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
932      * of certain opcodes, possibly making contracts go over the 2300 gas limit
933      * imposed by `transfer`, making them unable to receive funds via
934      * `transfer`. {sendValue} removes this limitation.
935      *
936      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
937      *
938      * IMPORTANT: because control is transferred to `recipient`, care must be
939      * taken to not create reentrancy vulnerabilities. Consider using
940      * {ReentrancyGuard} or the
941      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
942      */
943     function sendValue(address payable recipient, uint256 amount) internal {
944         require(address(this).balance >= amount, "Address: insufficient balance");
945 
946         (bool success, ) = recipient.call{value: amount}("");
947         require(success, "Address: unable to send value, recipient may have reverted");
948     }
949 
950     /**
951      * @dev Performs a Solidity function call using a low level `call`. A
952      * plain `call` is an unsafe replacement for a function call: use this
953      * function instead.
954      *
955      * If `target` reverts with a revert reason, it is bubbled up by this
956      * function (like regular Solidity function calls).
957      *
958      * Returns the raw returned data. To convert to the expected return value,
959      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
960      *
961      * Requirements:
962      *
963      * - `target` must be a contract.
964      * - calling `target` with `data` must not revert.
965      *
966      * _Available since v3.1._
967      */
968     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
969         return functionCall(target, data, "Address: low-level call failed");
970     }
971 
972     /**
973      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
974      * `errorMessage` as a fallback revert reason when `target` reverts.
975      *
976      * _Available since v3.1._
977      */
978     function functionCall(
979         address target,
980         bytes memory data,
981         string memory errorMessage
982     ) internal returns (bytes memory) {
983         return functionCallWithValue(target, data, 0, errorMessage);
984     }
985 
986     /**
987      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
988      * but also transferring `value` wei to `target`.
989      *
990      * Requirements:
991      *
992      * - the calling contract must have an ETH balance of at least `value`.
993      * - the called Solidity function must be `payable`.
994      *
995      * _Available since v3.1._
996      */
997     function functionCallWithValue(
998         address target,
999         bytes memory data,
1000         uint256 value
1001     ) internal returns (bytes memory) {
1002         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1003     }
1004 
1005     /**
1006      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1007      * with `errorMessage` as a fallback revert reason when `target` reverts.
1008      *
1009      * _Available since v3.1._
1010      */
1011     function functionCallWithValue(
1012         address target,
1013         bytes memory data,
1014         uint256 value,
1015         string memory errorMessage
1016     ) internal returns (bytes memory) {
1017         require(address(this).balance >= value, "Address: insufficient balance for call");
1018         require(isContract(target), "Address: call to non-contract");
1019 
1020         (bool success, bytes memory returndata) = target.call{value: value}(data);
1021         return verifyCallResult(success, returndata, errorMessage);
1022     }
1023 
1024     /**
1025      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1026      * but performing a static call.
1027      *
1028      * _Available since v3.3._
1029      */
1030     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1031         return functionStaticCall(target, data, "Address: low-level static call failed");
1032     }
1033 
1034     /**
1035      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1036      * but performing a static call.
1037      *
1038      * _Available since v3.3._
1039      */
1040     function functionStaticCall(
1041         address target,
1042         bytes memory data,
1043         string memory errorMessage
1044     ) internal view returns (bytes memory) {
1045         require(isContract(target), "Address: static call to non-contract");
1046 
1047         (bool success, bytes memory returndata) = target.staticcall(data);
1048         return verifyCallResult(success, returndata, errorMessage);
1049     }
1050 
1051     /**
1052      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1053      * but performing a delegate call.
1054      *
1055      * _Available since v3.4._
1056      */
1057     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1058         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1059     }
1060 
1061     /**
1062      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1063      * but performing a delegate call.
1064      *
1065      * _Available since v3.4._
1066      */
1067     function functionDelegateCall(
1068         address target,
1069         bytes memory data,
1070         string memory errorMessage
1071     ) internal returns (bytes memory) {
1072         require(isContract(target), "Address: delegate call to non-contract");
1073 
1074         (bool success, bytes memory returndata) = target.delegatecall(data);
1075         return verifyCallResult(success, returndata, errorMessage);
1076     }
1077 
1078     /**
1079      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1080      * revert reason using the provided one.
1081      *
1082      * _Available since v4.3._
1083      */
1084     function verifyCallResult(
1085         bool success,
1086         bytes memory returndata,
1087         string memory errorMessage
1088     ) internal pure returns (bytes memory) {
1089         if (success) {
1090             return returndata;
1091         } else {
1092             // Look for revert reason and bubble it up if present
1093             if (returndata.length > 0) {
1094                 // The easiest way to bubble the revert reason is using memory via assembly
1095 
1096                 assembly {
1097                     let returndata_size := mload(returndata)
1098                     revert(add(32, returndata), returndata_size)
1099                 }
1100             } else {
1101                 revert(errorMessage);
1102             }
1103         }
1104     }
1105 }
1106 
1107 
1108 // Dependency file: contracts/interfaces/IUniswapV2Factory.sol
1109 
1110 // pragma solidity >=0.5.0;
1111 
1112 interface IUniswapV2Factory {
1113     event PairCreated(
1114         address indexed token0,
1115         address indexed token1,
1116         address pair,
1117         uint256
1118     );
1119 
1120     function feeTo() external view returns (address);
1121 
1122     function feeToSetter() external view returns (address);
1123 
1124     function getPair(address tokenA, address tokenB)
1125         external
1126         view
1127         returns (address pair);
1128 
1129     function allPairs(uint256) external view returns (address pair);
1130 
1131     function allPairsLength() external view returns (uint256);
1132 
1133     function createPair(address tokenA, address tokenB)
1134         external
1135         returns (address pair);
1136 
1137     function setFeeTo(address) external;
1138 
1139     function setFeeToSetter(address) external;
1140 }
1141 
1142 
1143 // Dependency file: contracts/interfaces/IUniswapV2Router02.sol
1144 
1145 // pragma solidity >=0.6.2;
1146 
1147 interface IUniswapV2Router01 {
1148     function factory() external pure returns (address);
1149 
1150     function WETH() external pure returns (address);
1151 
1152     function addLiquidity(
1153         address tokenA,
1154         address tokenB,
1155         uint256 amountADesired,
1156         uint256 amountBDesired,
1157         uint256 amountAMin,
1158         uint256 amountBMin,
1159         address to,
1160         uint256 deadline
1161     )
1162         external
1163         returns (
1164             uint256 amountA,
1165             uint256 amountB,
1166             uint256 liquidity
1167         );
1168 
1169     function addLiquidityETH(
1170         address token,
1171         uint256 amountTokenDesired,
1172         uint256 amountTokenMin,
1173         uint256 amountETHMin,
1174         address to,
1175         uint256 deadline
1176     )
1177         external
1178         payable
1179         returns (
1180             uint256 amountToken,
1181             uint256 amountETH,
1182             uint256 liquidity
1183         );
1184 
1185     function removeLiquidity(
1186         address tokenA,
1187         address tokenB,
1188         uint256 liquidity,
1189         uint256 amountAMin,
1190         uint256 amountBMin,
1191         address to,
1192         uint256 deadline
1193     ) external returns (uint256 amountA, uint256 amountB);
1194 
1195     function removeLiquidityETH(
1196         address token,
1197         uint256 liquidity,
1198         uint256 amountTokenMin,
1199         uint256 amountETHMin,
1200         address to,
1201         uint256 deadline
1202     ) external returns (uint256 amountToken, uint256 amountETH);
1203 
1204     function removeLiquidityWithPermit(
1205         address tokenA,
1206         address tokenB,
1207         uint256 liquidity,
1208         uint256 amountAMin,
1209         uint256 amountBMin,
1210         address to,
1211         uint256 deadline,
1212         bool approveMax,
1213         uint8 v,
1214         bytes32 r,
1215         bytes32 s
1216     ) external returns (uint256 amountA, uint256 amountB);
1217 
1218     function removeLiquidityETHWithPermit(
1219         address token,
1220         uint256 liquidity,
1221         uint256 amountTokenMin,
1222         uint256 amountETHMin,
1223         address to,
1224         uint256 deadline,
1225         bool approveMax,
1226         uint8 v,
1227         bytes32 r,
1228         bytes32 s
1229     ) external returns (uint256 amountToken, uint256 amountETH);
1230 
1231     function swapExactTokensForTokens(
1232         uint256 amountIn,
1233         uint256 amountOutMin,
1234         address[] calldata path,
1235         address to,
1236         uint256 deadline
1237     ) external returns (uint256[] memory amounts);
1238 
1239     function swapTokensForExactTokens(
1240         uint256 amountOut,
1241         uint256 amountInMax,
1242         address[] calldata path,
1243         address to,
1244         uint256 deadline
1245     ) external returns (uint256[] memory amounts);
1246 
1247     function swapExactETHForTokens(
1248         uint256 amountOutMin,
1249         address[] calldata path,
1250         address to,
1251         uint256 deadline
1252     ) external payable returns (uint256[] memory amounts);
1253 
1254     function swapTokensForExactETH(
1255         uint256 amountOut,
1256         uint256 amountInMax,
1257         address[] calldata path,
1258         address to,
1259         uint256 deadline
1260     ) external returns (uint256[] memory amounts);
1261 
1262     function swapExactTokensForETH(
1263         uint256 amountIn,
1264         uint256 amountOutMin,
1265         address[] calldata path,
1266         address to,
1267         uint256 deadline
1268     ) external returns (uint256[] memory amounts);
1269 
1270     function swapETHForExactTokens(
1271         uint256 amountOut,
1272         address[] calldata path,
1273         address to,
1274         uint256 deadline
1275     ) external payable returns (uint256[] memory amounts);
1276 
1277     function quote(
1278         uint256 amountA,
1279         uint256 reserveA,
1280         uint256 reserveB
1281     ) external pure returns (uint256 amountB);
1282 
1283     function getAmountOut(
1284         uint256 amountIn,
1285         uint256 reserveIn,
1286         uint256 reserveOut
1287     ) external pure returns (uint256 amountOut);
1288 
1289     function getAmountIn(
1290         uint256 amountOut,
1291         uint256 reserveIn,
1292         uint256 reserveOut
1293     ) external pure returns (uint256 amountIn);
1294 
1295     function getAmountsOut(uint256 amountIn, address[] calldata path)
1296         external
1297         view
1298         returns (uint256[] memory amounts);
1299 
1300     function getAmountsIn(uint256 amountOut, address[] calldata path)
1301         external
1302         view
1303         returns (uint256[] memory amounts);
1304 }
1305 
1306 interface IUniswapV2Router02 is IUniswapV2Router01 {
1307     function removeLiquidityETHSupportingFeeOnTransferTokens(
1308         address token,
1309         uint256 liquidity,
1310         uint256 amountTokenMin,
1311         uint256 amountETHMin,
1312         address to,
1313         uint256 deadline
1314     ) external returns (uint256 amountETH);
1315 
1316     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1317         address token,
1318         uint256 liquidity,
1319         uint256 amountTokenMin,
1320         uint256 amountETHMin,
1321         address to,
1322         uint256 deadline,
1323         bool approveMax,
1324         uint8 v,
1325         bytes32 r,
1326         bytes32 s
1327     ) external returns (uint256 amountETH);
1328 
1329     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1330         uint256 amountIn,
1331         uint256 amountOutMin,
1332         address[] calldata path,
1333         address to,
1334         uint256 deadline
1335     ) external;
1336 
1337     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1338         uint256 amountOutMin,
1339         address[] calldata path,
1340         address to,
1341         uint256 deadline
1342     ) external payable;
1343 
1344     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1345         uint256 amountIn,
1346         uint256 amountOutMin,
1347         address[] calldata path,
1348         address to,
1349         uint256 deadline
1350     ) external;
1351 }
1352 
1353 
1354 // Dependency file: contracts/interfaces/IPinkAntiBot.sol
1355 
1356 // pragma solidity >=0.5.0;
1357 
1358 interface IPinkAntiBot {
1359   function setTokenOwner(address owner) external;
1360 
1361   function onPreTransferCheck(
1362     address from,
1363     address to,
1364     uint256 amount
1365   ) external;
1366 }
1367 
1368 
1369 // Dependency file: @openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol
1370 
1371 
1372 // pragma solidity ^0.8.0;
1373 
1374 /**
1375  * @dev Interface of the ERC20 standard as defined in the EIP.
1376  */
1377 interface IERC20Upgradeable {
1378     /**
1379      * @dev Returns the amount of tokens in existence.
1380      */
1381     function totalSupply() external view returns (uint256);
1382 
1383     /**
1384      * @dev Returns the amount of tokens owned by `account`.
1385      */
1386     function balanceOf(address account) external view returns (uint256);
1387 
1388     /**
1389      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1390      *
1391      * Returns a boolean value indicating whether the operation succeeded.
1392      *
1393      * Emits a {Transfer} event.
1394      */
1395     function transfer(address recipient, uint256 amount) external returns (bool);
1396 
1397     /**
1398      * @dev Returns the remaining number of tokens that `spender` will be
1399      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1400      * zero by default.
1401      *
1402      * This value changes when {approve} or {transferFrom} are called.
1403      */
1404     function allowance(address owner, address spender) external view returns (uint256);
1405 
1406     /**
1407      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1408      *
1409      * Returns a boolean value indicating whether the operation succeeded.
1410      *
1411      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1412      * that someone may use both the old and the new allowance by unfortunate
1413      * transaction ordering. One possible solution to mitigate this race
1414      * condition is to first reduce the spender's allowance to 0 and set the
1415      * desired value afterwards:
1416      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1417      *
1418      * Emits an {Approval} event.
1419      */
1420     function approve(address spender, uint256 amount) external returns (bool);
1421 
1422     /**
1423      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1424      * allowance mechanism. `amount` is then deducted from the caller's
1425      * allowance.
1426      *
1427      * Returns a boolean value indicating whether the operation succeeded.
1428      *
1429      * Emits a {Transfer} event.
1430      */
1431     function transferFrom(
1432         address sender,
1433         address recipient,
1434         uint256 amount
1435     ) external returns (bool);
1436 
1437     /**
1438      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1439      * another (`to`).
1440      *
1441      * Note that `value` may be zero.
1442      */
1443     event Transfer(address indexed from, address indexed to, uint256 value);
1444 
1445     /**
1446      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1447      * a call to {approve}. `value` is the new allowance.
1448      */
1449     event Approval(address indexed owner, address indexed spender, uint256 value);
1450 }
1451 
1452 
1453 // Dependency file: @openzeppelin/contracts-upgradeable/token/ERC20/extensions/IERC20MetadataUpgradeable.sol
1454 
1455 
1456 // pragma solidity ^0.8.0;
1457 
1458 // import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
1459 
1460 /**
1461  * @dev Interface for the optional metadata functions from the ERC20 standard.
1462  *
1463  * _Available since v4.1._
1464  */
1465 interface IERC20MetadataUpgradeable is IERC20Upgradeable {
1466     /**
1467      * @dev Returns the name of the token.
1468      */
1469     function name() external view returns (string memory);
1470 
1471     /**
1472      * @dev Returns the symbol of the token.
1473      */
1474     function symbol() external view returns (string memory);
1475 
1476     /**
1477      * @dev Returns the decimals places of the token.
1478      */
1479     function decimals() external view returns (uint8);
1480 }
1481 
1482 
1483 // Dependency file: @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol
1484 
1485 
1486 // pragma solidity ^0.8.0;
1487 
1488 /**
1489  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
1490  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
1491  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
1492  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
1493  *
1494  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
1495  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
1496  *
1497  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
1498  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
1499  */
1500 abstract contract Initializable {
1501     /**
1502      * @dev Indicates that the contract has been initialized.
1503      */
1504     bool private _initialized;
1505 
1506     /**
1507      * @dev Indicates that the contract is in the process of being initialized.
1508      */
1509     bool private _initializing;
1510 
1511     /**
1512      * @dev Modifier to protect an initializer function from being invoked twice.
1513      */
1514     modifier initializer() {
1515         require(_initializing || !_initialized, "Initializable: contract is already initialized");
1516 
1517         bool isTopLevelCall = !_initializing;
1518         if (isTopLevelCall) {
1519             _initializing = true;
1520             _initialized = true;
1521         }
1522 
1523         _;
1524 
1525         if (isTopLevelCall) {
1526             _initializing = false;
1527         }
1528     }
1529 }
1530 
1531 
1532 // Dependency file: @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol
1533 
1534 
1535 // pragma solidity ^0.8.0;
1536 // import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
1537 
1538 /**
1539  * @dev Provides information about the current execution context, including the
1540  * sender of the transaction and its data. While these are generally available
1541  * via msg.sender and msg.data, they should not be accessed in such a direct
1542  * manner, since when dealing with meta-transactions the account sending and
1543  * paying for execution may not be the actual sender (as far as an application
1544  * is concerned).
1545  *
1546  * This contract is only required for intermediate, library-like contracts.
1547  */
1548 abstract contract ContextUpgradeable is Initializable {
1549     function __Context_init() internal initializer {
1550         __Context_init_unchained();
1551     }
1552 
1553     function __Context_init_unchained() internal initializer {
1554     }
1555     function _msgSender() internal view virtual returns (address) {
1556         return msg.sender;
1557     }
1558 
1559     function _msgData() internal view virtual returns (bytes calldata) {
1560         return msg.data;
1561     }
1562     uint256[50] private __gap;
1563 }
1564 
1565 
1566 // Dependency file: @openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol
1567 
1568 
1569 // pragma solidity ^0.8.0;
1570 
1571 // import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
1572 // import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/IERC20MetadataUpgradeable.sol";
1573 // import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
1574 // import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
1575 
1576 /**
1577  * @dev Implementation of the {IERC20} interface.
1578  *
1579  * This implementation is agnostic to the way tokens are created. This means
1580  * that a supply mechanism has to be added in a derived contract using {_mint}.
1581  * For a generic mechanism see {ERC20PresetMinterPauser}.
1582  *
1583  * TIP: For a detailed writeup see our guide
1584  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1585  * to implement supply mechanisms].
1586  *
1587  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1588  * instead returning `false` on failure. This behavior is nonetheless
1589  * conventional and does not conflict with the expectations of ERC20
1590  * applications.
1591  *
1592  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1593  * This allows applications to reconstruct the allowance for all accounts just
1594  * by listening to said events. Other implementations of the EIP may not emit
1595  * these events, as it isn't required by the specification.
1596  *
1597  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1598  * functions have been added to mitigate the well-known issues around setting
1599  * allowances. See {IERC20-approve}.
1600  */
1601 contract ERC20Upgradeable is Initializable, ContextUpgradeable, IERC20Upgradeable, IERC20MetadataUpgradeable {
1602     mapping(address => uint256) private _balances;
1603 
1604     mapping(address => mapping(address => uint256)) private _allowances;
1605 
1606     uint256 private _totalSupply;
1607 
1608     string private _name;
1609     string private _symbol;
1610 
1611     /**
1612      * @dev Sets the values for {name} and {symbol}.
1613      *
1614      * The default value of {decimals} is 18. To select a different value for
1615      * {decimals} you should overload it.
1616      *
1617      * All two of these values are immutable: they can only be set once during
1618      * construction.
1619      */
1620     function __ERC20_init(string memory name_, string memory symbol_) internal initializer {
1621         __Context_init_unchained();
1622         __ERC20_init_unchained(name_, symbol_);
1623     }
1624 
1625     function __ERC20_init_unchained(string memory name_, string memory symbol_) internal initializer {
1626         _name = name_;
1627         _symbol = symbol_;
1628     }
1629 
1630     /**
1631      * @dev Returns the name of the token.
1632      */
1633     function name() public view virtual override returns (string memory) {
1634         return _name;
1635     }
1636 
1637     /**
1638      * @dev Returns the symbol of the token, usually a shorter version of the
1639      * name.
1640      */
1641     function symbol() public view virtual override returns (string memory) {
1642         return _symbol;
1643     }
1644 
1645     /**
1646      * @dev Returns the number of decimals used to get its user representation.
1647      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1648      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1649      *
1650      * Tokens usually opt for a value of 18, imitating the relationship between
1651      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1652      * overridden;
1653      *
1654      * NOTE: This information is only used for _display_ purposes: it in
1655      * no way affects any of the arithmetic of the contract, including
1656      * {IERC20-balanceOf} and {IERC20-transfer}.
1657      */
1658     function decimals() public view virtual override returns (uint8) {
1659         return 18;
1660     }
1661 
1662     /**
1663      * @dev See {IERC20-totalSupply}.
1664      */
1665     function totalSupply() public view virtual override returns (uint256) {
1666         return _totalSupply;
1667     }
1668 
1669     /**
1670      * @dev See {IERC20-balanceOf}.
1671      */
1672     function balanceOf(address account) public view virtual override returns (uint256) {
1673         return _balances[account];
1674     }
1675 
1676     /**
1677      * @dev See {IERC20-transfer}.
1678      *
1679      * Requirements:
1680      *
1681      * - `recipient` cannot be the zero address.
1682      * - the caller must have a balance of at least `amount`.
1683      */
1684     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1685         _transfer(_msgSender(), recipient, amount);
1686         return true;
1687     }
1688 
1689     /**
1690      * @dev See {IERC20-allowance}.
1691      */
1692     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1693         return _allowances[owner][spender];
1694     }
1695 
1696     /**
1697      * @dev See {IERC20-approve}.
1698      *
1699      * Requirements:
1700      *
1701      * - `spender` cannot be the zero address.
1702      */
1703     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1704         _approve(_msgSender(), spender, amount);
1705         return true;
1706     }
1707 
1708     /**
1709      * @dev See {IERC20-transferFrom}.
1710      *
1711      * Emits an {Approval} event indicating the updated allowance. This is not
1712      * required by the EIP. See the note at the beginning of {ERC20}.
1713      *
1714      * Requirements:
1715      *
1716      * - `sender` and `recipient` cannot be the zero address.
1717      * - `sender` must have a balance of at least `amount`.
1718      * - the caller must have allowance for ``sender``'s tokens of at least
1719      * `amount`.
1720      */
1721     function transferFrom(
1722         address sender,
1723         address recipient,
1724         uint256 amount
1725     ) public virtual override returns (bool) {
1726         _transfer(sender, recipient, amount);
1727 
1728         uint256 currentAllowance = _allowances[sender][_msgSender()];
1729         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1730         unchecked {
1731             _approve(sender, _msgSender(), currentAllowance - amount);
1732         }
1733 
1734         return true;
1735     }
1736 
1737     /**
1738      * @dev Atomically increases the allowance granted to `spender` by the caller.
1739      *
1740      * This is an alternative to {approve} that can be used as a mitigation for
1741      * problems described in {IERC20-approve}.
1742      *
1743      * Emits an {Approval} event indicating the updated allowance.
1744      *
1745      * Requirements:
1746      *
1747      * - `spender` cannot be the zero address.
1748      */
1749     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1750         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1751         return true;
1752     }
1753 
1754     /**
1755      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1756      *
1757      * This is an alternative to {approve} that can be used as a mitigation for
1758      * problems described in {IERC20-approve}.
1759      *
1760      * Emits an {Approval} event indicating the updated allowance.
1761      *
1762      * Requirements:
1763      *
1764      * - `spender` cannot be the zero address.
1765      * - `spender` must have allowance for the caller of at least
1766      * `subtractedValue`.
1767      */
1768     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1769         uint256 currentAllowance = _allowances[_msgSender()][spender];
1770         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1771         unchecked {
1772             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1773         }
1774 
1775         return true;
1776     }
1777 
1778     /**
1779      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1780      *
1781      * This internal function is equivalent to {transfer}, and can be used to
1782      * e.g. implement automatic token fees, slashing mechanisms, etc.
1783      *
1784      * Emits a {Transfer} event.
1785      *
1786      * Requirements:
1787      *
1788      * - `sender` cannot be the zero address.
1789      * - `recipient` cannot be the zero address.
1790      * - `sender` must have a balance of at least `amount`.
1791      */
1792     function _transfer(
1793         address sender,
1794         address recipient,
1795         uint256 amount
1796     ) internal virtual {
1797         require(sender != address(0), "ERC20: transfer from the zero address");
1798         require(recipient != address(0), "ERC20: transfer to the zero address");
1799 
1800         _beforeTokenTransfer(sender, recipient, amount);
1801 
1802         uint256 senderBalance = _balances[sender];
1803         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1804         unchecked {
1805             _balances[sender] = senderBalance - amount;
1806         }
1807         _balances[recipient] += amount;
1808 
1809         emit Transfer(sender, recipient, amount);
1810 
1811         _afterTokenTransfer(sender, recipient, amount);
1812     }
1813 
1814     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1815      * the total supply.
1816      *
1817      * Emits a {Transfer} event with `from` set to the zero address.
1818      *
1819      * Requirements:
1820      *
1821      * - `account` cannot be the zero address.
1822      */
1823     function _mint(address account, uint256 amount) internal virtual {
1824         require(account != address(0), "ERC20: mint to the zero address");
1825 
1826         _beforeTokenTransfer(address(0), account, amount);
1827 
1828         _totalSupply += amount;
1829         _balances[account] += amount;
1830         emit Transfer(address(0), account, amount);
1831 
1832         _afterTokenTransfer(address(0), account, amount);
1833     }
1834 
1835     /**
1836      * @dev Destroys `amount` tokens from `account`, reducing the
1837      * total supply.
1838      *
1839      * Emits a {Transfer} event with `to` set to the zero address.
1840      *
1841      * Requirements:
1842      *
1843      * - `account` cannot be the zero address.
1844      * - `account` must have at least `amount` tokens.
1845      */
1846     function _burn(address account, uint256 amount) internal virtual {
1847         require(account != address(0), "ERC20: burn from the zero address");
1848 
1849         _beforeTokenTransfer(account, address(0), amount);
1850 
1851         uint256 accountBalance = _balances[account];
1852         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1853         unchecked {
1854             _balances[account] = accountBalance - amount;
1855         }
1856         _totalSupply -= amount;
1857 
1858         emit Transfer(account, address(0), amount);
1859 
1860         _afterTokenTransfer(account, address(0), amount);
1861     }
1862 
1863     /**
1864      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1865      *
1866      * This internal function is equivalent to `approve`, and can be used to
1867      * e.g. set automatic allowances for certain subsystems, etc.
1868      *
1869      * Emits an {Approval} event.
1870      *
1871      * Requirements:
1872      *
1873      * - `owner` cannot be the zero address.
1874      * - `spender` cannot be the zero address.
1875      */
1876     function _approve(
1877         address owner,
1878         address spender,
1879         uint256 amount
1880     ) internal virtual {
1881         require(owner != address(0), "ERC20: approve from the zero address");
1882         require(spender != address(0), "ERC20: approve to the zero address");
1883 
1884         _allowances[owner][spender] = amount;
1885         emit Approval(owner, spender, amount);
1886     }
1887 
1888     /**
1889      * @dev Hook that is called before any transfer of tokens. This includes
1890      * minting and burning.
1891      *
1892      * Calling conditions:
1893      *
1894      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1895      * will be transferred to `to`.
1896      * - when `from` is zero, `amount` tokens will be minted for `to`.
1897      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1898      * - `from` and `to` are never both zero.
1899      *
1900      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1901      */
1902     function _beforeTokenTransfer(
1903         address from,
1904         address to,
1905         uint256 amount
1906     ) internal virtual {}
1907 
1908     /**
1909      * @dev Hook that is called after any transfer of tokens. This includes
1910      * minting and burning.
1911      *
1912      * Calling conditions:
1913      *
1914      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1915      * has been transferred to `to`.
1916      * - when `from` is zero, `amount` tokens have been minted for `to`.
1917      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1918      * - `from` and `to` are never both zero.
1919      *
1920      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1921      */
1922     function _afterTokenTransfer(
1923         address from,
1924         address to,
1925         uint256 amount
1926     ) internal virtual {}
1927     uint256[45] private __gap;
1928 }
1929 
1930 
1931 // Dependency file: @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol
1932 
1933 
1934 // pragma solidity ^0.8.0;
1935 
1936 // import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
1937 // import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
1938 
1939 /**
1940  * @dev Contract module which provides a basic access control mechanism, where
1941  * there is an account (an owner) that can be granted exclusive access to
1942  * specific functions.
1943  *
1944  * By default, the owner account will be the one that deploys the contract. This
1945  * can later be changed with {transferOwnership}.
1946  *
1947  * This module is used through inheritance. It will make available the modifier
1948  * `onlyOwner`, which can be applied to your functions to restrict their use to
1949  * the owner.
1950  */
1951 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
1952     address private _owner;
1953 
1954     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1955 
1956     /**
1957      * @dev Initializes the contract setting the deployer as the initial owner.
1958      */
1959     function __Ownable_init() internal initializer {
1960         __Context_init_unchained();
1961         __Ownable_init_unchained();
1962     }
1963 
1964     function __Ownable_init_unchained() internal initializer {
1965         _setOwner(_msgSender());
1966     }
1967 
1968     /**
1969      * @dev Returns the address of the current owner.
1970      */
1971     function owner() public view virtual returns (address) {
1972         return _owner;
1973     }
1974 
1975     /**
1976      * @dev Throws if called by any account other than the owner.
1977      */
1978     modifier onlyOwner() {
1979         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1980         _;
1981     }
1982 
1983     /**
1984      * @dev Leaves the contract without owner. It will not be possible to call
1985      * `onlyOwner` functions anymore. Can only be called by the current owner.
1986      *
1987      * NOTE: Renouncing ownership will leave the contract without an owner,
1988      * thereby removing any functionality that is only available to the owner.
1989      */
1990     function renounceOwnership() public virtual onlyOwner {
1991         _setOwner(address(0));
1992     }
1993 
1994     /**
1995      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1996      * Can only be called by the current owner.
1997      */
1998     function transferOwnership(address newOwner) public virtual onlyOwner {
1999         require(newOwner != address(0), "Ownable: new owner is the zero address");
2000         _setOwner(newOwner);
2001     }
2002 
2003     function _setOwner(address newOwner) private {
2004         address oldOwner = _owner;
2005         _owner = newOwner;
2006         emit OwnershipTransferred(oldOwner, newOwner);
2007     }
2008     uint256[49] private __gap;
2009 }
2010 
2011 
2012 // Dependency file: contracts/interfaces/IUniswapV2Pair.sol
2013 
2014 // pragma solidity >=0.5.0;
2015 
2016 interface IUniswapV2Pair {
2017     event Approval(address indexed owner, address indexed spender, uint value);
2018     event Transfer(address indexed from, address indexed to, uint value);
2019 
2020     function name() external pure returns (string memory);
2021     function symbol() external pure returns (string memory);
2022     function decimals() external pure returns (uint8);
2023     function totalSupply() external view returns (uint);
2024     function balanceOf(address owner) external view returns (uint);
2025     function allowance(address owner, address spender) external view returns (uint);
2026 
2027     function approve(address spender, uint value) external returns (bool);
2028     function transfer(address to, uint value) external returns (bool);
2029     function transferFrom(address from, address to, uint value) external returns (bool);
2030 
2031     function DOMAIN_SEPARATOR() external view returns (bytes32);
2032     function PERMIT_TYPEHASH() external pure returns (bytes32);
2033     function nonces(address owner) external view returns (uint);
2034 
2035     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
2036 
2037     event Mint(address indexed sender, uint amount0, uint amount1);
2038     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
2039     event Swap(
2040         address indexed sender,
2041         uint amount0In,
2042         uint amount1In,
2043         uint amount0Out,
2044         uint amount1Out,
2045         address indexed to
2046     );
2047     event Sync(uint112 reserve0, uint112 reserve1);
2048 
2049     function MINIMUM_LIQUIDITY() external pure returns (uint);
2050     function factory() external view returns (address);
2051     function token0() external view returns (address);
2052     function token1() external view returns (address);
2053     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
2054     function price0CumulativeLast() external view returns (uint);
2055     function price1CumulativeLast() external view returns (uint);
2056     function kLast() external view returns (uint);
2057 
2058     function mint(address to) external returns (uint liquidity);
2059     function burn(address to) external returns (uint amount0, uint amount1);
2060     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
2061     function skim(address to) external;
2062     function sync() external;
2063 
2064     function initialize(address, address) external;
2065 }
2066 
2067 // Dependency file: contracts/libs/SafeMathInt.sol
2068 
2069 // pragma solidity =0.8.4;
2070 
2071 /**
2072  * @title SafeMathInt
2073  * @dev Math operations for int256 with overflow safety checks.
2074  */
2075 library SafeMathInt {
2076     int256 private constant MIN_INT256 = int256(1) << 255;
2077     int256 private constant MAX_INT256 = ~(int256(1) << 255);
2078 
2079     /**
2080      * @dev Multiplies two int256 variables and fails on overflow.
2081      */
2082     function mul(int256 a, int256 b) internal pure returns (int256) {
2083         int256 c = a * b;
2084 
2085         // Detect overflow when multiplying MIN_INT256 with -1
2086         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
2087         require((b == 0) || (c / b == a));
2088         return c;
2089     }
2090 
2091     /**
2092      * @dev Division of two int256 variables and fails on overflow.
2093      */
2094     function div(int256 a, int256 b) internal pure returns (int256) {
2095         // Prevent overflow when dividing MIN_INT256 by -1
2096         require(b != -1 || a != MIN_INT256);
2097 
2098         // Solidity already throws when dividing by 0.
2099         return a / b;
2100     }
2101 
2102     /**
2103      * @dev Subtracts two int256 variables and fails on overflow.
2104      */
2105     function sub(int256 a, int256 b) internal pure returns (int256) {
2106         int256 c = a - b;
2107         require((b >= 0 && c <= a) || (b < 0 && c > a));
2108         return c;
2109     }
2110 
2111     /**
2112      * @dev Adds two int256 variables and fails on overflow.
2113      */
2114     function add(int256 a, int256 b) internal pure returns (int256) {
2115         int256 c = a + b;
2116         require((b >= 0 && c >= a) || (b < 0 && c < a));
2117         return c;
2118     }
2119 
2120     /**
2121      * @dev Converts to absolute value, and fails on overflow.
2122      */
2123     function abs(int256 a) internal pure returns (int256) {
2124         require(a != MIN_INT256);
2125         return a < 0 ? -a : a;
2126     }
2127 
2128     function toUint256Safe(int256 a) internal pure returns (uint256) {
2129         require(a >= 0);
2130         return uint256(a);
2131     }
2132 }
2133 
2134 
2135 // Dependency file: contracts/libs/SafeMathUint.sol
2136 
2137 // pragma solidity =0.8.4;
2138 
2139 /**
2140  * @title SafeMathUint
2141  * @dev Math operations with safety checks that revert on error
2142  */
2143 library SafeMathUint {
2144     function toInt256Safe(uint256 a) internal pure returns (int256) {
2145         int256 b = int256(a);
2146         require(b >= 0);
2147         return b;
2148     }
2149 }
2150 
2151 
2152 // Dependency file: contracts/baby/IterableMapping.sol
2153 
2154 // pragma solidity =0.8.4;
2155 
2156 library IterableMapping {
2157     // Iterable mapping from address to uint;
2158     struct Map {
2159         address[] keys;
2160         mapping(address => uint256) values;
2161         mapping(address => uint256) indexOf;
2162         mapping(address => bool) inserted;
2163     }
2164 
2165     function get(Map storage map, address key) public view returns (uint256) {
2166         return map.values[key];
2167     }
2168 
2169     function getIndexOfKey(Map storage map, address key)
2170         public
2171         view
2172         returns (int256)
2173     {
2174         if (!map.inserted[key]) {
2175             return -1;
2176         }
2177         return int256(map.indexOf[key]);
2178     }
2179 
2180     function getKeyAtIndex(Map storage map, uint256 index)
2181         public
2182         view
2183         returns (address)
2184     {
2185         return map.keys[index];
2186     }
2187 
2188     function size(Map storage map) public view returns (uint256) {
2189         return map.keys.length;
2190     }
2191 
2192     function set(
2193         Map storage map,
2194         address key,
2195         uint256 val
2196     ) public {
2197         if (map.inserted[key]) {
2198             map.values[key] = val;
2199         } else {
2200             map.inserted[key] = true;
2201             map.values[key] = val;
2202             map.indexOf[key] = map.keys.length;
2203             map.keys.push(key);
2204         }
2205     }
2206 
2207     function remove(Map storage map, address key) public {
2208         if (!map.inserted[key]) {
2209             return;
2210         }
2211 
2212         delete map.inserted[key];
2213         delete map.values[key];
2214 
2215         uint256 index = map.indexOf[key];
2216         uint256 lastIndex = map.keys.length - 1;
2217         address lastKey = map.keys[lastIndex];
2218 
2219         map.indexOf[lastKey] = index;
2220         delete map.indexOf[key];
2221 
2222         map.keys[index] = lastKey;
2223         map.keys.pop();
2224     }
2225 }
2226 
2227 
2228 // Dependency file: contracts/baby/BabyTokenDividendTracker.sol
2229 
2230 // pragma solidity =0.8.4;
2231 
2232 // import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
2233 // import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
2234 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
2235 // import "@openzeppelin/contracts/access/Ownable.sol";
2236 // import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
2237 // import "@openzeppelin/contracts/utils/math/SafeMath.sol";
2238 // import "contracts/interfaces/IUniswapV2Factory.sol";
2239 // import "contracts/interfaces/IUniswapV2Router02.sol";
2240 // import "contracts/interfaces/IUniswapV2Pair.sol";
2241 // import "contracts/libs/SafeMathInt.sol";
2242 // import "contracts/libs/SafeMathUint.sol";
2243 // import "contracts/baby/IterableMapping.sol";
2244 
2245 /// @title Dividend-Paying Token Interface
2246 /// @author Roger Wu (https://github.com/roger-wu)
2247 /// @dev An interface for a dividend-paying token contract.
2248 interface DividendPayingTokenInterface {
2249     /// @notice View the amount of dividend in wei that an address can withdraw.
2250     /// @param _owner The address of a token holder.
2251     /// @return The amount of dividend in wei that `_owner` can withdraw.
2252     function dividendOf(address _owner) external view returns (uint256);
2253 
2254     /// @notice Withdraws the ether distributed to the sender.
2255     /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
2256     ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
2257     function withdrawDividend() external;
2258 
2259     /// @dev This event MUST emit when ether is distributed to token holders.
2260     /// @param from The address which sends ether to this contract.
2261     /// @param weiAmount The amount of distributed ether in wei.
2262     event DividendsDistributed(address indexed from, uint256 weiAmount);
2263 
2264     /// @dev This event MUST emit when an address withdraws their dividend.
2265     /// @param to The address which withdraws ether from this contract.
2266     /// @param weiAmount The amount of withdrawn ether in wei.
2267     event DividendWithdrawn(address indexed to, uint256 weiAmount);
2268 }
2269 
2270 /// @title Dividend-Paying Token Optional Interface
2271 /// @author Roger Wu (https://github.com/roger-wu)
2272 /// @dev OPTIONAL functions for a dividend-paying token contract.
2273 interface DividendPayingTokenOptionalInterface {
2274     /// @notice View the amount of dividend in wei that an address can withdraw.
2275     /// @param _owner The address of a token holder.
2276     /// @return The amount of dividend in wei that `_owner` can withdraw.
2277     function withdrawableDividendOf(address _owner)
2278         external
2279         view
2280         returns (uint256);
2281 
2282     /// @notice View the amount of dividend in wei that an address has withdrawn.
2283     /// @param _owner The address of a token holder.
2284     /// @return The amount of dividend in wei that `_owner` has withdrawn.
2285     function withdrawnDividendOf(address _owner)
2286         external
2287         view
2288         returns (uint256);
2289 
2290     /// @notice View the amount of dividend in wei that an address has earned in total.
2291     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
2292     /// @param _owner The address of a token holder.
2293     /// @return The amount of dividend in wei that `_owner` has earned in total.
2294     function accumulativeDividendOf(address _owner)
2295         external
2296         view
2297         returns (uint256);
2298 }
2299 
2300 /// @title Dividend-Paying Token
2301 /// @author Roger Wu (https://github.com/roger-wu)
2302 /// @dev A mintable ERC20 token that allows anyone to pay and distribute ether
2303 ///  to token holders as dividends and allows token holders to withdraw their dividends.
2304 ///  Reference: the source code of PoWH3D: https://etherscan.io/address/0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe#code
2305 contract DividendPayingToken is
2306     ERC20Upgradeable,
2307     OwnableUpgradeable,
2308     DividendPayingTokenInterface,
2309     DividendPayingTokenOptionalInterface
2310 {
2311     using SafeMath for uint256;
2312     using SafeMathUint for uint256;
2313     using SafeMathInt for int256;
2314 
2315     address public rewardToken;
2316 
2317     // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
2318     // For more discussion about choosing the value of `magnitude`,
2319     //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
2320     uint256 internal constant magnitude = 2**128;
2321 
2322     uint256 internal magnifiedDividendPerShare;
2323 
2324     // About dividendCorrection:
2325     // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
2326     //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
2327     // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
2328     //   `dividendOf(_user)` should not be changed,
2329     //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
2330     // To keep the `dividendOf(_user)` unchanged, we add a correction term:
2331     //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
2332     //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
2333     //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
2334     // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
2335     mapping(address => int256) internal magnifiedDividendCorrections;
2336     mapping(address => uint256) internal withdrawnDividends;
2337 
2338     uint256 public totalDividendsDistributed;
2339 
2340     function __DividendPayingToken_init(
2341         address _rewardToken,
2342         string memory _name,
2343         string memory _symbol
2344     ) internal initializer {
2345         __Ownable_init();
2346         __ERC20_init(_name, _symbol);
2347         rewardToken = _rewardToken;
2348     }
2349 
2350     function distributeCAKEDividends(uint256 amount) public onlyOwner {
2351         require(totalSupply() > 0);
2352 
2353         if (amount > 0) {
2354             magnifiedDividendPerShare = magnifiedDividendPerShare.add(
2355                 (amount).mul(magnitude) / totalSupply()
2356             );
2357             emit DividendsDistributed(msg.sender, amount);
2358 
2359             totalDividendsDistributed = totalDividendsDistributed.add(amount);
2360         }
2361     }
2362 
2363     /// @notice Withdraws the ether distributed to the sender.
2364     /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
2365     function withdrawDividend() public virtual override {
2366         _withdrawDividendOfUser(payable(msg.sender));
2367     }
2368 
2369     /// @notice Withdraws the ether distributed to the sender.
2370     /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
2371     function _withdrawDividendOfUser(address payable user)
2372         internal
2373         returns (uint256)
2374     {
2375         uint256 _withdrawableDividend = withdrawableDividendOf(user);
2376         if (_withdrawableDividend > 0) {
2377             withdrawnDividends[user] = withdrawnDividends[user].add(
2378                 _withdrawableDividend
2379             );
2380             emit DividendWithdrawn(user, _withdrawableDividend);
2381             bool success = IERC20(rewardToken).transfer(
2382                 user,
2383                 _withdrawableDividend
2384             );
2385 
2386             if (!success) {
2387                 withdrawnDividends[user] = withdrawnDividends[user].sub(
2388                     _withdrawableDividend
2389                 );
2390                 return 0;
2391             }
2392 
2393             return _withdrawableDividend;
2394         }
2395 
2396         return 0;
2397     }
2398 
2399     /// @notice View the amount of dividend in wei that an address can withdraw.
2400     /// @param _owner The address of a token holder.
2401     /// @return The amount of dividend in wei that `_owner` can withdraw.
2402     function dividendOf(address _owner) public view override returns (uint256) {
2403         return withdrawableDividendOf(_owner);
2404     }
2405 
2406     /// @notice View the amount of dividend in wei that an address can withdraw.
2407     /// @param _owner The address of a token holder.
2408     /// @return The amount of dividend in wei that `_owner` can withdraw.
2409     function withdrawableDividendOf(address _owner)
2410         public
2411         view
2412         override
2413         returns (uint256)
2414     {
2415         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
2416     }
2417 
2418     /// @notice View the amount of dividend in wei that an address has withdrawn.
2419     /// @param _owner The address of a token holder.
2420     /// @return The amount of dividend in wei that `_owner` has withdrawn.
2421     function withdrawnDividendOf(address _owner)
2422         public
2423         view
2424         override
2425         returns (uint256)
2426     {
2427         return withdrawnDividends[_owner];
2428     }
2429 
2430     /// @notice View the amount of dividend in wei that an address has earned in total.
2431     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
2432     /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
2433     /// @param _owner The address of a token holder.
2434     /// @return The amount of dividend in wei that `_owner` has earned in total.
2435     function accumulativeDividendOf(address _owner)
2436         public
2437         view
2438         override
2439         returns (uint256)
2440     {
2441         return
2442             magnifiedDividendPerShare
2443                 .mul(balanceOf(_owner))
2444                 .toInt256Safe()
2445                 .add(magnifiedDividendCorrections[_owner])
2446                 .toUint256Safe() / magnitude;
2447     }
2448 
2449     /// @dev Internal function that transfer tokens from one address to another.
2450     /// Update magnifiedDividendCorrections to keep dividends unchanged.
2451     /// @param from The address to transfer from.
2452     /// @param to The address to transfer to.
2453     /// @param value The amount to be transferred.
2454     function _transfer(
2455         address from,
2456         address to,
2457         uint256 value
2458     ) internal virtual override {
2459         require(false);
2460 
2461         int256 _magCorrection = magnifiedDividendPerShare
2462             .mul(value)
2463             .toInt256Safe();
2464         magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from]
2465             .add(_magCorrection);
2466         magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(
2467             _magCorrection
2468         );
2469     }
2470 
2471     /// @dev Internal function that mints tokens to an account.
2472     /// Update magnifiedDividendCorrections to keep dividends unchanged.
2473     /// @param account The account that will receive the created tokens.
2474     /// @param value The amount that will be created.
2475     function _mint(address account, uint256 value) internal override {
2476         super._mint(account, value);
2477 
2478         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[
2479             account
2480         ].sub((magnifiedDividendPerShare.mul(value)).toInt256Safe());
2481     }
2482 
2483     /// @dev Internal function that burns an amount of the token of a given account.
2484     /// Update magnifiedDividendCorrections to keep dividends unchanged.
2485     /// @param account The account whose tokens will be burnt.
2486     /// @param value The amount that will be burnt.
2487     function _burn(address account, uint256 value) internal override {
2488         super._burn(account, value);
2489 
2490         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[
2491             account
2492         ].add((magnifiedDividendPerShare.mul(value)).toInt256Safe());
2493     }
2494 
2495     function _setBalance(address account, uint256 newBalance) internal {
2496         uint256 currentBalance = balanceOf(account);
2497 
2498         if (newBalance > currentBalance) {
2499             uint256 mintAmount = newBalance.sub(currentBalance);
2500             _mint(account, mintAmount);
2501         } else if (newBalance < currentBalance) {
2502             uint256 burnAmount = currentBalance.sub(newBalance);
2503             _burn(account, burnAmount);
2504         }
2505     }
2506 }
2507 
2508 contract BABYTOKENDividendTracker is OwnableUpgradeable, DividendPayingToken {
2509     using SafeMath for uint256;
2510     using SafeMathInt for int256;
2511     using IterableMapping for IterableMapping.Map;
2512 
2513     IterableMapping.Map private tokenHoldersMap;
2514     uint256 public lastProcessedIndex;
2515 
2516     mapping(address => bool) public excludedFromDividends;
2517 
2518     mapping(address => uint256) public lastClaimTimes;
2519 
2520     uint256 public claimWait;
2521     uint256 public minimumTokenBalanceForDividends;
2522 
2523     event ExcludeFromDividends(address indexed account);
2524     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
2525 
2526     event Claim(
2527         address indexed account,
2528         uint256 amount,
2529         bool indexed automatic
2530     );
2531 
2532     function initialize(
2533         address rewardToken_,
2534         uint256 minimumTokenBalanceForDividends_
2535     ) external initializer {
2536         DividendPayingToken.__DividendPayingToken_init(
2537             rewardToken_,
2538             "DIVIDEND_TRACKER",
2539             "DIVIDEND_TRACKER"
2540         );
2541         claimWait = 3600;
2542         minimumTokenBalanceForDividends = minimumTokenBalanceForDividends_;
2543     }
2544 
2545     function _transfer(
2546         address,
2547         address,
2548         uint256
2549     ) internal pure override {
2550         require(false, "Dividend_Tracker: No transfers allowed");
2551     }
2552 
2553     function withdrawDividend() public pure override {
2554         require(
2555             false,
2556             "Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main BABYTOKEN contract."
2557         );
2558     }
2559 
2560     function excludeFromDividends(address account) external onlyOwner {
2561         require(!excludedFromDividends[account]);
2562         excludedFromDividends[account] = true;
2563 
2564         _setBalance(account, 0);
2565         tokenHoldersMap.remove(account);
2566 
2567         emit ExcludeFromDividends(account);
2568     }
2569 
2570     function isExcludedFromDividends(address account)
2571         public
2572         view
2573         returns (bool)
2574     {
2575         return excludedFromDividends[account];
2576     }
2577 
2578     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
2579         require(
2580             newClaimWait >= 3600 && newClaimWait <= 86400,
2581             "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours"
2582         );
2583         require(
2584             newClaimWait != claimWait,
2585             "Dividend_Tracker: Cannot update claimWait to same value"
2586         );
2587         emit ClaimWaitUpdated(newClaimWait, claimWait);
2588         claimWait = newClaimWait;
2589     }
2590 
2591     function updateMinimumTokenBalanceForDividends(uint256 amount)
2592         external
2593         onlyOwner
2594     {
2595         minimumTokenBalanceForDividends = amount;
2596     }
2597 
2598     function getLastProcessedIndex() external view returns (uint256) {
2599         return lastProcessedIndex;
2600     }
2601 
2602     function getNumberOfTokenHolders() external view returns (uint256) {
2603         return tokenHoldersMap.keys.length;
2604     }
2605 
2606     function getAccount(address _account)
2607         public
2608         view
2609         returns (
2610             address account,
2611             int256 index,
2612             int256 iterationsUntilProcessed,
2613             uint256 withdrawableDividends,
2614             uint256 totalDividends,
2615             uint256 lastClaimTime,
2616             uint256 nextClaimTime,
2617             uint256 secondsUntilAutoClaimAvailable
2618         )
2619     {
2620         account = _account;
2621 
2622         index = tokenHoldersMap.getIndexOfKey(account);
2623 
2624         iterationsUntilProcessed = -1;
2625 
2626         if (index >= 0) {
2627             if (uint256(index) > lastProcessedIndex) {
2628                 iterationsUntilProcessed = index.sub(
2629                     int256(lastProcessedIndex)
2630                 );
2631             } else {
2632                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length >
2633                     lastProcessedIndex
2634                     ? tokenHoldersMap.keys.length.sub(lastProcessedIndex)
2635                     : 0;
2636 
2637                 iterationsUntilProcessed = index.add(
2638                     int256(processesUntilEndOfArray)
2639                 );
2640             }
2641         }
2642 
2643         withdrawableDividends = withdrawableDividendOf(account);
2644         totalDividends = accumulativeDividendOf(account);
2645 
2646         lastClaimTime = lastClaimTimes[account];
2647 
2648         nextClaimTime = lastClaimTime > 0 ? lastClaimTime.add(claimWait) : 0;
2649 
2650         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp
2651             ? nextClaimTime.sub(block.timestamp)
2652             : 0;
2653     }
2654 
2655     function getAccountAtIndex(uint256 index)
2656         public
2657         view
2658         returns (
2659             address,
2660             int256,
2661             int256,
2662             uint256,
2663             uint256,
2664             uint256,
2665             uint256,
2666             uint256
2667         )
2668     {
2669         if (index >= tokenHoldersMap.size()) {
2670             return (address(0), -1, -1, 0, 0, 0, 0, 0);
2671         }
2672 
2673         address account = tokenHoldersMap.getKeyAtIndex(index);
2674 
2675         return getAccount(account);
2676     }
2677 
2678     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
2679         if (lastClaimTime > block.timestamp) {
2680             return false;
2681         }
2682 
2683         return block.timestamp.sub(lastClaimTime) >= claimWait;
2684     }
2685 
2686     function setBalance(address payable account, uint256 newBalance)
2687         external
2688         onlyOwner
2689     {
2690         if (excludedFromDividends[account]) {
2691             return;
2692         }
2693         if (newBalance >= minimumTokenBalanceForDividends) {
2694             _setBalance(account, newBalance);
2695             tokenHoldersMap.set(account, newBalance);
2696         } else {
2697             _setBalance(account, 0);
2698             tokenHoldersMap.remove(account);
2699         }
2700         processAccount(account, true);
2701     }
2702 
2703     function process(uint256 gas)
2704         public
2705         returns (
2706             uint256,
2707             uint256,
2708             uint256
2709         )
2710     {
2711         uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
2712 
2713         if (numberOfTokenHolders == 0) {
2714             return (0, 0, lastProcessedIndex);
2715         }
2716 
2717         uint256 _lastProcessedIndex = lastProcessedIndex;
2718 
2719         uint256 gasUsed = 0;
2720 
2721         uint256 gasLeft = gasleft();
2722 
2723         uint256 iterations = 0;
2724         uint256 claims = 0;
2725 
2726         while (gasUsed < gas && iterations < numberOfTokenHolders) {
2727             _lastProcessedIndex++;
2728 
2729             if (_lastProcessedIndex >= tokenHoldersMap.keys.length) {
2730                 _lastProcessedIndex = 0;
2731             }
2732 
2733             address account = tokenHoldersMap.keys[_lastProcessedIndex];
2734 
2735             if (canAutoClaim(lastClaimTimes[account])) {
2736                 if (processAccount(payable(account), true)) {
2737                     claims++;
2738                 }
2739             }
2740 
2741             iterations++;
2742 
2743             uint256 newGasLeft = gasleft();
2744 
2745             if (gasLeft > newGasLeft) {
2746                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
2747             }
2748 
2749             gasLeft = newGasLeft;
2750         }
2751 
2752         lastProcessedIndex = _lastProcessedIndex;
2753 
2754         return (iterations, claims, lastProcessedIndex);
2755     }
2756 
2757     function processAccount(address payable account, bool automatic)
2758         public
2759         onlyOwner
2760         returns (bool)
2761     {
2762         uint256 amount = _withdrawDividendOfUser(account);
2763 
2764         if (amount > 0) {
2765             lastClaimTimes[account] = block.timestamp;
2766             emit Claim(account, amount, automatic);
2767             return true;
2768         }
2769 
2770         return false;
2771     }
2772 }
2773 
2774 
2775 // Dependency file: contracts/BaseToken.sol
2776 
2777 // pragma solidity =0.8.4;
2778 
2779 enum TokenType {
2780     standard,
2781     antiBotStandard,
2782     liquidityGenerator,
2783     antiBotLiquidityGenerator,
2784     baby,
2785     antiBotBaby,
2786     buybackBaby,
2787     antiBotBuybackBaby
2788 }
2789 
2790 abstract contract BaseToken {
2791     event TokenCreated(
2792         address indexed owner,
2793         address indexed token,
2794         TokenType tokenType,
2795         uint256 version
2796     );
2797 }
2798 
2799 
2800 // Root file: contracts/baby/AntiBotBabyToken.sol
2801 
2802 pragma solidity =0.8.4;
2803 
2804 // import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
2805 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
2806 // import "@openzeppelin/contracts/access/Ownable.sol";
2807 // import "@openzeppelin/contracts/utils/math/SafeMath.sol";
2808 // import "@openzeppelin/contracts/proxy/Clones.sol";
2809 // import "@openzeppelin/contracts/utils/Address.sol";
2810 
2811 // import "contracts/interfaces/IUniswapV2Factory.sol";
2812 // import "contracts/interfaces/IUniswapV2Router02.sol";
2813 // import "contracts/interfaces/IPinkAntiBot.sol";
2814 // import "contracts/baby/BabyTokenDividendTracker.sol";
2815 // import "contracts/BaseToken.sol";
2816 
2817 contract AntiBotBABYTOKEN is ERC20, Ownable, BaseToken {
2818     using SafeMath for uint256;
2819     using Address for address;
2820     using Address for address payable;
2821 
2822     uint256 public constant VERSION = 2;
2823 
2824     IUniswapV2Router02 public uniswapV2Router;
2825     address public uniswapV2Pair;
2826 
2827     bool private swapping;
2828 
2829     BABYTOKENDividendTracker public dividendTracker;
2830 
2831     address public rewardToken;
2832 
2833     uint256 public swapTokensAtAmount;
2834 
2835     uint256 public tokenRewardsFee;
2836     uint256 public liquidityFee;
2837     uint256 public marketingFee;
2838     uint256 public totalFees;
2839 
2840     address public _marketingWalletAddress;
2841 
2842     uint256 public gasForProcessing;
2843 
2844     // exlcude from fees and max transaction amount
2845     mapping(address => bool) private _isExcludedFromFees;
2846 
2847     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
2848     // could be subject to a maximum transfer amount
2849     mapping(address => bool) public automatedMarketMakerPairs;
2850 
2851     IPinkAntiBot public pinkAntiBot;
2852     bool public enableAntiBot;
2853 
2854     event ExcludeFromFees(address indexed account);
2855     event ExcludeMultipleAccountsFromFees(address[] accounts);
2856 
2857     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
2858 
2859     event GasForProcessingUpdated(
2860         uint256 indexed newValue,
2861         uint256 indexed oldValue
2862     );
2863 
2864     event SwapAndLiquify(
2865         uint256 tokensSwapped,
2866         uint256 ethReceived,
2867         uint256 tokensIntoLiqudity
2868     );
2869 
2870     event SendDividends(uint256 tokensSwapped, uint256 amount);
2871 
2872     event ProcessedDividendTracker(
2873         uint256 iterations,
2874         uint256 claims,
2875         uint256 lastProcessedIndex,
2876         bool indexed automatic,
2877         uint256 gas,
2878         address indexed processor
2879     );
2880 
2881     constructor(
2882         string memory name_,
2883         string memory symbol_,
2884         uint256 totalSupply_,
2885         address[5] memory addrs, // reward, router, marketing wallet, dividendTracker, anti bot
2886         uint256[3] memory feeSettings, // rewards, liquidity, marketing
2887         uint256 minimumTokenBalanceForDividends_,
2888         address serviceFeeReceiver_,
2889         uint256 serviceFee_
2890     ) payable ERC20(name_, symbol_) {
2891         rewardToken = addrs[0];
2892         _marketingWalletAddress = addrs[2];
2893         require(
2894             msg.sender != _marketingWalletAddress,
2895             "Owner and marketing wallet cannot be the same"
2896         );
2897         require(
2898             !_marketingWalletAddress.isContract(),
2899             "Marketing wallet cannot be a contract"
2900         );
2901 
2902         pinkAntiBot = IPinkAntiBot(addrs[4]);
2903         pinkAntiBot.setTokenOwner(owner());
2904         enableAntiBot = true;
2905 
2906         tokenRewardsFee = feeSettings[0];
2907         liquidityFee = feeSettings[1];
2908         marketingFee = feeSettings[2];
2909         totalFees = tokenRewardsFee.add(liquidityFee).add(marketingFee);
2910         require(totalFees <= 25, "Total fee is over 25%");
2911         swapTokensAtAmount = totalSupply_.div(1000); // 0.1%
2912 
2913         // use by default 300,000 gas to process auto-claiming dividends
2914         gasForProcessing = 300000;
2915 
2916         dividendTracker = BABYTOKENDividendTracker(
2917             payable(Clones.clone(addrs[3]))
2918         );
2919         dividendTracker.initialize(
2920             rewardToken,
2921             minimumTokenBalanceForDividends_
2922         );
2923 
2924         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(addrs[1]);
2925         // Create a uniswap pair for this new token
2926         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
2927             .createPair(address(this), _uniswapV2Router.WETH());
2928         uniswapV2Router = _uniswapV2Router;
2929         uniswapV2Pair = _uniswapV2Pair;
2930         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
2931 
2932         // exclude from receiving dividends
2933         dividendTracker.excludeFromDividends(address(dividendTracker));
2934         dividendTracker.excludeFromDividends(address(this));
2935         dividendTracker.excludeFromDividends(owner());
2936         dividendTracker.excludeFromDividends(address(0xdead));
2937         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
2938         // exclude from paying fees or having max transaction amount
2939         _isExcludedFromFees[owner()] = true;
2940         _isExcludedFromFees[_marketingWalletAddress] = true;
2941         _isExcludedFromFees[address(this)] = true;
2942         /*
2943             _mint is an internal function in ERC20.sol that is only called here,
2944             and CANNOT be called ever again
2945         */
2946         _mint(owner(), totalSupply_);
2947 
2948         emit TokenCreated(
2949             owner(),
2950             address(this),
2951             TokenType.antiBotBaby,
2952             VERSION
2953         );
2954 
2955         payable(serviceFeeReceiver_).transfer(serviceFee_);
2956     }
2957 
2958     function setEnableAntiBot(bool _enable) external onlyOwner {
2959         enableAntiBot = _enable;
2960     }
2961 
2962     receive() external payable {}
2963 
2964     function setSwapTokensAtAmount(uint256 amount) external onlyOwner {
2965         require(
2966             amount > totalSupply() / 10**5,
2967             "BABYTOKEN: Amount must be greater than 0.001% of total supply"
2968         );
2969         swapTokensAtAmount = amount;
2970     }
2971 
2972     function excludeFromFees(address account) external onlyOwner {
2973         require(
2974             !_isExcludedFromFees[account],
2975             "BABYTOKEN: Account is already excluded"
2976         );
2977         _isExcludedFromFees[account] = true;
2978 
2979         emit ExcludeFromFees(account);
2980     }
2981 
2982     function excludeMultipleAccountsFromFees(address[] calldata accounts)
2983         external
2984         onlyOwner
2985     {
2986         for (uint256 i = 0; i < accounts.length; i++) {
2987             _isExcludedFromFees[accounts[i]] = true;
2988         }
2989 
2990         emit ExcludeMultipleAccountsFromFees(accounts);
2991     }
2992 
2993     function setMarketingWallet(address payable wallet) external onlyOwner {
2994         require(
2995             wallet != address(0),
2996             "BABYTOKEN: The marketing wallet cannot be the value of zero"
2997         );
2998         require(!wallet.isContract(), "Marketing wallet cannot be a contract");
2999         _marketingWalletAddress = wallet;
3000     }
3001 
3002     function setTokenRewardsFee(uint256 value) external onlyOwner {
3003         tokenRewardsFee = value;
3004         totalFees = tokenRewardsFee.add(liquidityFee).add(marketingFee);
3005         require(totalFees <= 25, "Total fee is over 25%");
3006     }
3007 
3008     function setLiquiditFee(uint256 value) external onlyOwner {
3009         liquidityFee = value;
3010         totalFees = tokenRewardsFee.add(liquidityFee).add(marketingFee);
3011         require(totalFees <= 25, "Total fee is over 25%");
3012     }
3013 
3014     function setMarketingFee(uint256 value) external onlyOwner {
3015         marketingFee = value;
3016         totalFees = tokenRewardsFee.add(liquidityFee).add(marketingFee);
3017         require(totalFees <= 25, "Total fee is over 25%");
3018     }
3019 
3020     function _setAutomatedMarketMakerPair(address pair, bool value) private {
3021         require(
3022             automatedMarketMakerPairs[pair] != value,
3023             "BABYTOKEN: Automated market maker pair is already set to that value"
3024         );
3025         automatedMarketMakerPairs[pair] = value;
3026 
3027         if (value) {
3028             dividendTracker.excludeFromDividends(pair);
3029         }
3030 
3031         emit SetAutomatedMarketMakerPair(pair, value);
3032     }
3033 
3034     function updateGasForProcessing(uint256 newValue) public onlyOwner {
3035         require(
3036             newValue >= 200000 && newValue <= 500000,
3037             "BABYTOKEN: gasForProcessing must be between 200,000 and 500,000"
3038         );
3039         require(
3040             newValue != gasForProcessing,
3041             "BABYTOKEN: Cannot update gasForProcessing to same value"
3042         );
3043         emit GasForProcessingUpdated(newValue, gasForProcessing);
3044         gasForProcessing = newValue;
3045     }
3046 
3047     function updateClaimWait(uint256 claimWait) external onlyOwner {
3048         dividendTracker.updateClaimWait(claimWait);
3049     }
3050 
3051     function getClaimWait() external view returns (uint256) {
3052         return dividendTracker.claimWait();
3053     }
3054 
3055     function updateMinimumTokenBalanceForDividends(uint256 amount)
3056         external
3057         onlyOwner
3058     {
3059         dividendTracker.updateMinimumTokenBalanceForDividends(amount);
3060     }
3061 
3062     function getMinimumTokenBalanceForDividends()
3063         external
3064         view
3065         returns (uint256)
3066     {
3067         return dividendTracker.minimumTokenBalanceForDividends();
3068     }
3069 
3070     function getTotalDividendsDistributed() external view returns (uint256) {
3071         return dividendTracker.totalDividendsDistributed();
3072     }
3073 
3074     function isExcludedFromFees(address account) public view returns (bool) {
3075         return _isExcludedFromFees[account];
3076     }
3077 
3078     function withdrawableDividendOf(address account)
3079         public
3080         view
3081         returns (uint256)
3082     {
3083         return dividendTracker.withdrawableDividendOf(account);
3084     }
3085 
3086     function dividendTokenBalanceOf(address account)
3087         public
3088         view
3089         returns (uint256)
3090     {
3091         return dividendTracker.balanceOf(account);
3092     }
3093 
3094     function excludeFromDividends(address account) external onlyOwner {
3095         dividendTracker.excludeFromDividends(account);
3096     }
3097 
3098     function isExcludedFromDividends(address account)
3099         public
3100         view
3101         returns (bool)
3102     {
3103         return dividendTracker.isExcludedFromDividends(account);
3104     }
3105 
3106     function getAccountDividendsInfo(address account)
3107         external
3108         view
3109         returns (
3110             address,
3111             int256,
3112             int256,
3113             uint256,
3114             uint256,
3115             uint256,
3116             uint256,
3117             uint256
3118         )
3119     {
3120         return dividendTracker.getAccount(account);
3121     }
3122 
3123     function getAccountDividendsInfoAtIndex(uint256 index)
3124         external
3125         view
3126         returns (
3127             address,
3128             int256,
3129             int256,
3130             uint256,
3131             uint256,
3132             uint256,
3133             uint256,
3134             uint256
3135         )
3136     {
3137         return dividendTracker.getAccountAtIndex(index);
3138     }
3139 
3140     function processDividendTracker(uint256 gas) external {
3141         (
3142             uint256 iterations,
3143             uint256 claims,
3144             uint256 lastProcessedIndex
3145         ) = dividendTracker.process(gas);
3146         emit ProcessedDividendTracker(
3147             iterations,
3148             claims,
3149             lastProcessedIndex,
3150             false,
3151             gas,
3152             tx.origin
3153         );
3154     }
3155 
3156     function claim() external {
3157         dividendTracker.processAccount(payable(msg.sender), false);
3158     }
3159 
3160     function getLastProcessedIndex() external view returns (uint256) {
3161         return dividendTracker.getLastProcessedIndex();
3162     }
3163 
3164     function getNumberOfDividendTokenHolders() external view returns (uint256) {
3165         return dividendTracker.getNumberOfTokenHolders();
3166     }
3167 
3168     function _transfer(
3169         address from,
3170         address to,
3171         uint256 amount
3172     ) internal override {
3173         require(from != address(0), "ERC20: transfer from the zero address");
3174         require(to != address(0), "ERC20: transfer to the zero address");
3175 
3176         if (enableAntiBot) {
3177             pinkAntiBot.onPreTransferCheck(from, to, amount);
3178         }
3179 
3180         if (amount == 0) {
3181             super._transfer(from, to, 0);
3182             return;
3183         }
3184 
3185         uint256 contractTokenBalance = balanceOf(address(this));
3186 
3187         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
3188 
3189         if (
3190             canSwap &&
3191             !swapping &&
3192             !automatedMarketMakerPairs[from] &&
3193             from != owner() &&
3194             to != owner() &&
3195             totalFees > 0
3196         ) {
3197             swapping = true;
3198 
3199             if (marketingFee > 0) {
3200                 uint256 marketingTokens = contractTokenBalance
3201                     .mul(marketingFee)
3202                     .div(totalFees);
3203                 swapAndSendToFee(marketingTokens);
3204             }
3205 
3206             if (liquidityFee > 0) {
3207                 uint256 swapTokens = contractTokenBalance.mul(liquidityFee).div(
3208                     totalFees
3209                 );
3210                 swapAndLiquify(swapTokens);
3211             }
3212 
3213             uint256 sellTokens = balanceOf(address(this));
3214             if (sellTokens > 0) {
3215                 swapAndSendDividends(sellTokens);
3216             }
3217 
3218             swapping = false;
3219         }
3220 
3221         bool takeFee = !swapping;
3222 
3223         // if any account belongs to _isExcludedFromFee account then remove the fee
3224         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
3225             takeFee = false;
3226         }
3227 
3228         if (takeFee && totalFees > 0) {
3229             uint256 fees = amount.mul(totalFees).div(100);
3230             if (automatedMarketMakerPairs[to]) {
3231                 fees += amount.mul(1).div(100);
3232             }
3233             amount = amount.sub(fees);
3234 
3235             super._transfer(from, address(this), fees);
3236         }
3237 
3238         super._transfer(from, to, amount);
3239 
3240         try
3241             dividendTracker.setBalance(payable(from), balanceOf(from))
3242         {} catch {}
3243         try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
3244 
3245         if (!swapping) {
3246             uint256 gas = gasForProcessing;
3247 
3248             try dividendTracker.process(gas) returns (
3249                 uint256 iterations,
3250                 uint256 claims,
3251                 uint256 lastProcessedIndex
3252             ) {
3253                 emit ProcessedDividendTracker(
3254                     iterations,
3255                     claims,
3256                     lastProcessedIndex,
3257                     true,
3258                     gas,
3259                     tx.origin
3260                 );
3261             } catch {}
3262         }
3263     }
3264 
3265     function swapAndSendToFee(uint256 tokens) private {
3266         uint256 initialCAKEBalance = IERC20(rewardToken).balanceOf(
3267             address(this)
3268         );
3269 
3270         swapTokensForCake(tokens);
3271         uint256 newBalance = (IERC20(rewardToken).balanceOf(address(this))).sub(
3272             initialCAKEBalance
3273         );
3274         IERC20(rewardToken).transfer(_marketingWalletAddress, newBalance);
3275     }
3276 
3277     function swapAndLiquify(uint256 tokens) private {
3278         // split the contract balance into halves
3279         uint256 half = tokens.div(2);
3280         uint256 otherHalf = tokens.sub(half);
3281 
3282         // capture the contract's current ETH balance.
3283         // this is so that we can capture exactly the amount of ETH that the
3284         // swap creates, and not make the liquidity event include any ETH that
3285         // has been manually sent to the contract
3286         uint256 initialBalance = address(this).balance;
3287 
3288         // swap tokens for ETH
3289         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
3290 
3291         // how much ETH did we just swap into?
3292         uint256 newBalance = address(this).balance.sub(initialBalance);
3293 
3294         // add liquidity to uniswap
3295         addLiquidity(otherHalf, newBalance);
3296 
3297         emit SwapAndLiquify(half, newBalance, otherHalf);
3298     }
3299 
3300     function swapTokensForEth(uint256 tokenAmount) private {
3301         // generate the uniswap pair path of token -> weth
3302         address[] memory path = new address[](2);
3303         path[0] = address(this);
3304         path[1] = uniswapV2Router.WETH();
3305 
3306         _approve(address(this), address(uniswapV2Router), tokenAmount);
3307 
3308         // make the swap
3309         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
3310             tokenAmount,
3311             0, // accept any amount of ETH
3312             path,
3313             address(this),
3314             block.timestamp
3315         );
3316     }
3317 
3318     function swapTokensForCake(uint256 tokenAmount) private {
3319         address[] memory path = new address[](3);
3320         path[0] = address(this);
3321         path[1] = uniswapV2Router.WETH();
3322         path[2] = rewardToken;
3323 
3324         _approve(address(this), address(uniswapV2Router), tokenAmount);
3325 
3326         // make the swap
3327         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
3328             tokenAmount,
3329             0,
3330             path,
3331             address(this),
3332             block.timestamp
3333         );
3334     }
3335 
3336     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
3337         // approve token transfer to cover all possible scenarios
3338         _approve(address(this), address(uniswapV2Router), tokenAmount);
3339 
3340         // add the liquidity
3341         uniswapV2Router.addLiquidityETH{value: ethAmount}(
3342             address(this),
3343             tokenAmount,
3344             0, // slippage is unavoidable
3345             0, // slippage is unavoidable
3346             address(0xdead),
3347             block.timestamp
3348         );
3349     }
3350 
3351     function swapAndSendDividends(uint256 tokens) private {
3352         swapTokensForCake(tokens);
3353         uint256 dividends = IERC20(rewardToken).balanceOf(address(this));
3354         bool success = IERC20(rewardToken).transfer(
3355             address(dividendTracker),
3356             dividends
3357         );
3358 
3359         if (success) {
3360             dividendTracker.distributeCAKEDividends(dividends);
3361             emit SendDividends(tokens, dividends);
3362         }
3363     }
3364 }