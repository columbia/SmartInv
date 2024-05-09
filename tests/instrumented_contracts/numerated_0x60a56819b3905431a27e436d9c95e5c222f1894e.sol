1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
3 pragma experimental ABIEncoderV2;
4 
5 //https://cryptofiverr.shop//
6 //https://t.me/CryptoFiverrChannel//
7 
8 
9 
10 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
11 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
12 
13 /* pragma solidity ^0.8.0; */
14 
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
27 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
28 
29 /* pragma solidity ^0.8.0; */
30 
31 /* import "../utils/Context.sol"; */
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor() {
54         _transferOwnership(_msgSender());
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view virtual returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(owner() == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Leaves the contract without owner. It will not be possible to call
74      * `onlyOwner` functions anymore. Can only be called by the current owner.
75      *
76      * NOTE: Renouncing ownership will leave the contract without an owner,
77      * thereby removing any functionality that is only available to the owner.
78      */
79     function renounceOwnership() public virtual onlyOwner {
80         _transferOwnership(address(0));
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Can only be called by the current owner.
86      */
87     function transferOwnership(address newOwner) public virtual onlyOwner {
88         require(newOwner != address(0), "Ownable: new owner is the zero address");
89         _transferOwnership(newOwner);
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Internal function without access restriction.
95      */
96     function _transferOwnership(address newOwner) internal virtual {
97         address oldOwner = _owner;
98         _owner = newOwner;
99         emit OwnershipTransferred(oldOwner, newOwner);
100     }
101 }
102 
103 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
104 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
105 
106 /* pragma solidity ^0.8.0; */
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
186 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
187 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
188 
189 /* pragma solidity ^0.8.0; */
190 
191 /* import "../IERC20.sol"; */
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
215 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
216 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
217 
218 /* pragma solidity ^0.8.0; */
219 
220 /* import "./IERC20.sol"; */
221 /* import "./extensions/IERC20Metadata.sol"; */
222 /* import "../../utils/Context.sol"; */
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
572 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
573 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
574 
575 /* pragma solidity ^0.8.0; */
576 
577 // CAUTION
578 // This version of SafeMath should only be used with Solidity 0.8 or later,
579 // because it relies on the compiler's built in overflow checks.
580 
581 /**
582  * @dev Wrappers over Solidity's arithmetic operations.
583  *
584  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
585  * now has built in overflow checking.
586  */
587 library SafeMath {
588     /**
589      * @dev Returns the addition of two unsigned integers, with an overflow flag.
590      *
591      * _Available since v3.4._
592      */
593     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
594         unchecked {
595             uint256 c = a + b;
596             if (c < a) return (false, 0);
597             return (true, c);
598         }
599     }
600 
601     /**
602      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
603      *
604      * _Available since v3.4._
605      */
606     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
607         unchecked {
608             if (b > a) return (false, 0);
609             return (true, a - b);
610         }
611     }
612 
613     /**
614      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
615      *
616      * _Available since v3.4._
617      */
618     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
619         unchecked {
620             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
621             // benefit is lost if 'b' is also tested.
622             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
623             if (a == 0) return (true, 0);
624             uint256 c = a * b;
625             if (c / a != b) return (false, 0);
626             return (true, c);
627         }
628     }
629 
630     /**
631      * @dev Returns the division of two unsigned integers, with a division by zero flag.
632      *
633      * _Available since v3.4._
634      */
635     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
636         unchecked {
637             if (b == 0) return (false, 0);
638             return (true, a / b);
639         }
640     }
641 
642     /**
643      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
644      *
645      * _Available since v3.4._
646      */
647     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
648         unchecked {
649             if (b == 0) return (false, 0);
650             return (true, a % b);
651         }
652     }
653 
654     /**
655      * @dev Returns the addition of two unsigned integers, reverting on
656      * overflow.
657      *
658      * Counterpart to Solidity's `+` operator.
659      *
660      * Requirements:
661      *
662      * - Addition cannot overflow.
663      */
664     function add(uint256 a, uint256 b) internal pure returns (uint256) {
665         return a + b;
666     }
667 
668     /**
669      * @dev Returns the subtraction of two unsigned integers, reverting on
670      * overflow (when the result is negative).
671      *
672      * Counterpart to Solidity's `-` operator.
673      *
674      * Requirements:
675      *
676      * - Subtraction cannot overflow.
677      */
678     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
679         return a - b;
680     }
681 
682     /**
683      * @dev Returns the multiplication of two unsigned integers, reverting on
684      * overflow.
685      *
686      * Counterpart to Solidity's `*` operator.
687      *
688      * Requirements:
689      *
690      * - Multiplication cannot overflow.
691      */
692     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
693         return a * b;
694     }
695 
696     /**
697      * @dev Returns the integer division of two unsigned integers, reverting on
698      * division by zero. The result is rounded towards zero.
699      *
700      * Counterpart to Solidity's `/` operator.
701      *
702      * Requirements:
703      *
704      * - The divisor cannot be zero.
705      */
706     function div(uint256 a, uint256 b) internal pure returns (uint256) {
707         return a / b;
708     }
709 
710     /**
711      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
712      * reverting when dividing by zero.
713      *
714      * Counterpart to Solidity's `%` operator. This function uses a `revert`
715      * opcode (which leaves remaining gas untouched) while Solidity uses an
716      * invalid opcode to revert (consuming all remaining gas).
717      *
718      * Requirements:
719      *
720      * - The divisor cannot be zero.
721      */
722     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
723         return a % b;
724     }
725 
726     /**
727      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
728      * overflow (when the result is negative).
729      *
730      * CAUTION: This function is deprecated because it requires allocating memory for the error
731      * message unnecessarily. For custom revert reasons use {trySub}.
732      *
733      * Counterpart to Solidity's `-` operator.
734      *
735      * Requirements:
736      *
737      * - Subtraction cannot overflow.
738      */
739     function sub(
740         uint256 a,
741         uint256 b,
742         string memory errorMessage
743     ) internal pure returns (uint256) {
744         unchecked {
745             require(b <= a, errorMessage);
746             return a - b;
747         }
748     }
749 
750     /**
751      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
752      * division by zero. The result is rounded towards zero.
753      *
754      * Counterpart to Solidity's `/` operator. Note: this function uses a
755      * `revert` opcode (which leaves remaining gas untouched) while Solidity
756      * uses an invalid opcode to revert (consuming all remaining gas).
757      *
758      * Requirements:
759      *
760      * - The divisor cannot be zero.
761      */
762     function div(
763         uint256 a,
764         uint256 b,
765         string memory errorMessage
766     ) internal pure returns (uint256) {
767         unchecked {
768             require(b > 0, errorMessage);
769             return a / b;
770         }
771     }
772 
773     /**
774      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
775      * reverting with custom message when dividing by zero.
776      *
777      * CAUTION: This function is deprecated because it requires allocating memory for the error
778      * message unnecessarily. For custom revert reasons use {tryMod}.
779      *
780      * Counterpart to Solidity's `%` operator. This function uses a `revert`
781      * opcode (which leaves remaining gas untouched) while Solidity uses an
782      * invalid opcode to revert (consuming all remaining gas).
783      *
784      * Requirements:
785      *
786      * - The divisor cannot be zero.
787      */
788     function mod(
789         uint256 a,
790         uint256 b,
791         string memory errorMessage
792     ) internal pure returns (uint256) {
793         unchecked {
794             require(b > 0, errorMessage);
795             return a % b;
796         }
797     }
798 }
799 
800 ////// src/IUniswapV2Factory.sol
801 /* pragma solidity 0.8.10; */
802 /* pragma experimental ABIEncoderV2; */
803 
804 interface IUniswapV2Factory {
805     event PairCreated(
806         address indexed token0,
807         address indexed token1,
808         address pair,
809         uint256
810     );
811 
812     function feeTo() external view returns (address);
813 
814     function feeToSetter() external view returns (address);
815 
816     function getPair(address tokenA, address tokenB)
817         external
818         view
819         returns (address pair);
820 
821     function allPairs(uint256) external view returns (address pair);
822 
823     function allPairsLength() external view returns (uint256);
824 
825     function createPair(address tokenA, address tokenB)
826         external
827         returns (address pair);
828 
829     function setFeeTo(address) external;
830 
831     function setFeeToSetter(address) external;
832 }
833 
834 ////// src/IUniswapV2Pair.sol
835 /* pragma solidity 0.8.10; */
836 /* pragma experimental ABIEncoderV2; */
837 
838 interface IUniswapV2Pair {
839     event Approval(
840         address indexed owner,
841         address indexed spender,
842         uint256 value
843     );
844     event Transfer(address indexed from, address indexed to, uint256 value);
845 
846     function name() external pure returns (string memory);
847 
848     function symbol() external pure returns (string memory);
849 
850     function decimals() external pure returns (uint8);
851 
852     function totalSupply() external view returns (uint256);
853 
854     function balanceOf(address owner) external view returns (uint256);
855 
856     function allowance(address owner, address spender)
857         external
858         view
859         returns (uint256);
860 
861     function approve(address spender, uint256 value) external returns (bool);
862 
863     function transfer(address to, uint256 value) external returns (bool);
864 
865     function transferFrom(
866         address from,
867         address to,
868         uint256 value
869     ) external returns (bool);
870 
871     function DOMAIN_SEPARATOR() external view returns (bytes32);
872 
873     function PERMIT_TYPEHASH() external pure returns (bytes32);
874 
875     function nonces(address owner) external view returns (uint256);
876 
877     function permit(
878         address owner,
879         address spender,
880         uint256 value,
881         uint256 deadline,
882         uint8 v,
883         bytes32 r,
884         bytes32 s
885     ) external;
886 
887     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
888     event Burn(
889         address indexed sender,
890         uint256 amount0,
891         uint256 amount1,
892         address indexed to
893     );
894     event Swap(
895         address indexed sender,
896         uint256 amount0In,
897         uint256 amount1In,
898         uint256 amount0Out,
899         uint256 amount1Out,
900         address indexed to
901     );
902     event Sync(uint112 reserve0, uint112 reserve1);
903 
904     function MINIMUM_LIQUIDITY() external pure returns (uint256);
905 
906     function factory() external view returns (address);
907 
908     function token0() external view returns (address);
909 
910     function token1() external view returns (address);
911 
912     function getReserves()
913         external
914         view
915         returns (
916             uint112 reserve0,
917             uint112 reserve1,
918             uint32 blockTimestampLast
919         );
920 
921     function price0CumulativeLast() external view returns (uint256);
922 
923     function price1CumulativeLast() external view returns (uint256);
924 
925     function kLast() external view returns (uint256);
926 
927     function mint(address to) external returns (uint256 liquidity);
928 
929     function burn(address to)
930         external
931         returns (uint256 amount0, uint256 amount1);
932 
933     function swap(
934         uint256 amount0Out,
935         uint256 amount1Out,
936         address to,
937         bytes calldata data
938     ) external;
939 
940     function skim(address to) external;
941 
942     function sync() external;
943 
944     function initialize(address, address) external;
945 }
946 
947 ////// src/IUniswapV2Router02.sol
948 /* pragma solidity 0.8.10; */
949 /* pragma experimental ABIEncoderV2; */
950 
951 interface IUniswapV2Router02 {
952     function factory() external pure returns (address);
953 
954     function WETH() external pure returns (address);
955 
956     function addLiquidity(
957         address tokenA,
958         address tokenB,
959         uint256 amountADesired,
960         uint256 amountBDesired,
961         uint256 amountAMin,
962         uint256 amountBMin,
963         address to,
964         uint256 deadline
965     )
966         external
967         returns (
968             uint256 amountA,
969             uint256 amountB,
970             uint256 liquidity
971         );
972 
973     function addLiquidityETH(
974         address token,
975         uint256 amountTokenDesired,
976         uint256 amountTokenMin,
977         uint256 amountETHMin,
978         address to,
979         uint256 deadline
980     )
981         external
982         payable
983         returns (
984             uint256 amountToken,
985             uint256 amountETH,
986             uint256 liquidity
987         );
988 
989     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
990         uint256 amountIn,
991         uint256 amountOutMin,
992         address[] calldata path,
993         address to,
994         uint256 deadline
995     ) external;
996 
997     function swapExactETHForTokensSupportingFeeOnTransferTokens(
998         uint256 amountOutMin,
999         address[] calldata path,
1000         address to,
1001         uint256 deadline
1002     ) external payable;
1003 
1004     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1005         uint256 amountIn,
1006         uint256 amountOutMin,
1007         address[] calldata path,
1008         address to,
1009         uint256 deadline
1010     ) external;
1011 }
1012 
1013 /* pragma solidity >=0.8.10; */
1014 
1015 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1016 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1017 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1018 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1019 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1020 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1021 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1022 
1023 contract CryptoFiverr is ERC20, Ownable {
1024     using SafeMath for uint256;
1025 
1026     IUniswapV2Router02 public immutable uniswapV2Router;
1027     address public immutable uniswapV2Pair;
1028     address public constant deadAddress = address(0xdead);
1029 
1030     bool private swapping;
1031 
1032     address public marketingWallet;
1033     address public devWallet;
1034 
1035     uint256 public maxTransactionAmount;
1036     uint256 public swapTokensAtAmount;
1037     uint256 public maxWallet;
1038 
1039     uint256 public percentForLPBurn = 25; // 25 = .25%
1040     bool public lpBurnEnabled = true;
1041     uint256 public lpBurnFrequency = 3600 seconds;
1042     uint256 public lastLpBurnTime;
1043 
1044     uint256 public manualBurnFrequency = 30 minutes;
1045     uint256 public lastManualLpBurnTime;
1046 
1047     bool public limitsInEffect = true;
1048     bool public tradingActive = false;
1049     bool public swapEnabled = false;
1050 
1051     // Anti-bot and anti-whale mappings and variables
1052     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1053     bool public transferDelayEnabled = true;
1054 
1055     uint256 public buyTotalFees;
1056     uint256 public buyMarketingFee;
1057     uint256 public buyLiquidityFee;
1058     uint256 public buyDevFee;
1059 
1060     uint256 public sellTotalFees;
1061     uint256 public sellMarketingFee;
1062     uint256 public sellLiquidityFee;
1063     uint256 public sellDevFee;
1064 
1065     uint256 public tokensForMarketing;
1066     uint256 public tokensForLiquidity;
1067     uint256 public tokensForDev;
1068 
1069     /******************/
1070 
1071     // exlcude from fees and max transaction amount
1072     mapping(address => bool) private _isExcludedFromFees;
1073     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1074 
1075     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1076     // could be subject to a maximum transfer amount
1077     mapping(address => bool) public automatedMarketMakerPairs;
1078 
1079     event UpdateUniswapV2Router(
1080         address indexed newAddress,
1081         address indexed oldAddress
1082     );
1083 
1084     event ExcludeFromFees(address indexed account, bool isExcluded);
1085 
1086     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1087 
1088     event marketingWalletsUpdated(
1089         address indexed newWallet,
1090         address indexed oldWallet
1091     );
1092 
1093     event devWalletUpdated(
1094         address indexed newWallet,
1095         address indexed oldWallet
1096     );
1097 
1098     event SwapAndLiquify(
1099         uint256 tokensSwapped,
1100         uint256 ethReceived,
1101         uint256 tokensIntoLiquidity
1102     );
1103 
1104     event AutoNukeLP();
1105 
1106     event ManualNukeLP();
1107 
1108     constructor() ERC20("Crypto Fiverr", "CF") {
1109         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1110             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1111         );
1112 
1113         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1114         uniswapV2Router = _uniswapV2Router;
1115 
1116         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1117             .createPair(address(this), _uniswapV2Router.WETH());
1118         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1119         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1120 
1121         uint256 _buyMarketingFee = 19;
1122         uint256 _buyLiquidityFee = 1;
1123         uint256 _buyDevFee = 0;
1124 
1125         uint256 _sellMarketingFee = 39;
1126         uint256 _sellLiquidityFee = 1;
1127         uint256 _sellDevFees = 0;
1128 
1129         uint256 totalSupply = 1_000_000_000 * 1e18;
1130 
1131         maxTransactionAmount = 20_000_000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1132         maxWallet = 20_000_000 * 1e18; // 2% from total supply maxWallet
1133         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1134 
1135         buyMarketingFee = _buyMarketingFee;
1136         buyLiquidityFee = _buyLiquidityFee;
1137         buyDevFee = _buyDevFee;
1138         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1139 
1140         sellMarketingFee = _sellMarketingFee;
1141         sellLiquidityFee = _sellLiquidityFee;
1142         sellDevFee = _sellDevFees;
1143         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1144 
1145         marketingWallet = address(0xaA84c58D053F27e045cED366A7752be3642bbe89); // set as marketing wallet
1146         devWallet = address(0x6d238ae0867977150c8B7eaE47258af4C8aa323E); // set as dev wallet
1147 
1148         // exclude from paying fees or having max transaction amount
1149         excludeFromFees(owner(), true);
1150         excludeFromFees(address(this), true);
1151         excludeFromFees(address(0xdead), true);
1152 
1153         excludeFromMaxTransaction(owner(), true);
1154         excludeFromMaxTransaction(address(this), true);
1155         excludeFromMaxTransaction(address(0xdead), true);
1156 
1157         /*
1158             _mint is an internal function in ERC20.sol that is only called here,
1159             and CANNOT be called ever again
1160         */
1161         _mint(msg.sender, totalSupply);
1162     }
1163 
1164     receive() external payable {}
1165 
1166     // once enabled, can never be turned off
1167     function enableTrading() external onlyOwner {
1168         tradingActive = true;
1169         swapEnabled = true;
1170         lastLpBurnTime = block.timestamp;
1171     }
1172 
1173     // remove limits after token is stable
1174     function removeLimits() external onlyOwner returns (bool) {
1175         limitsInEffect = false;
1176         return true;
1177     }
1178 
1179     // disable Transfer delay - cannot be reenabled
1180     function disableTransferDelay() external onlyOwner returns (bool) {
1181         transferDelayEnabled = false;
1182         return true;
1183     }
1184 
1185     // change the minimum amount of tokens to sell from fees
1186     function updateSwapTokensAtAmount(uint256 newAmount)
1187         external
1188         onlyOwner
1189         returns (bool)
1190     {
1191         require(
1192             newAmount >= (totalSupply() * 1) / 100000,
1193             "Swap amount cannot be lower than 0.001% total supply."
1194         );
1195         require(
1196             newAmount <= (totalSupply() * 5) / 1000,
1197             "Swap amount cannot be higher than 0.5% total supply."
1198         );
1199         swapTokensAtAmount = newAmount;
1200         return true;
1201     }
1202 
1203     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1204         require(
1205             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1206             "Cannot set maxTransactionAmount lower than 0.1%"
1207         );
1208         maxTransactionAmount = newNum * (10**18);
1209     }
1210 
1211     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1212         require(
1213             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1214             "Cannot set maxWallet lower than 0.5%"
1215         );
1216         maxWallet = newNum * (10**18);
1217     }
1218 
1219     function excludeFromMaxTransaction(address updAds, bool isEx)
1220         public
1221         onlyOwner
1222     {
1223         _isExcludedMaxTransactionAmount[updAds] = isEx;
1224     }
1225 
1226     // only use to disable contract sales if absolutely necessary (emergency use only)
1227     function updateSwapEnabled(bool enabled) external onlyOwner {
1228         swapEnabled = enabled;
1229     }
1230 
1231     function updateBuyFees(
1232         uint256 _marketingFee,
1233         uint256 _liquidityFee,
1234         uint256 _devFee
1235     ) external onlyOwner {
1236         buyMarketingFee = _marketingFee;
1237         buyLiquidityFee = _liquidityFee;
1238         buyDevFee = _devFee;
1239         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1240         require(buyTotalFees <= 11, "Must keep fees at 11% or less");
1241     }
1242 
1243     function updateSellFees(
1244         uint256 _marketingFee,
1245         uint256 _liquidityFee,
1246         uint256 _devFee
1247     ) external onlyOwner {
1248         sellMarketingFee = _marketingFee;
1249         sellLiquidityFee = _liquidityFee;
1250         sellDevFee = _devFee;
1251         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1252         require(sellTotalFees <= 11, "Must keep fees at 11% or less");
1253     }
1254 
1255     function excludeFromFees(address account, bool excluded) public onlyOwner {
1256         _isExcludedFromFees[account] = excluded;
1257         emit ExcludeFromFees(account, excluded);
1258     }
1259 
1260     function setAutomatedMarketMakerPair(address pair, bool value)
1261         public
1262         onlyOwner
1263     {
1264         require(
1265             pair != uniswapV2Pair,
1266             "The pair cannot be removed from automatedMarketMakerPairs"
1267         );
1268 
1269         _setAutomatedMarketMakerPair(pair, value);
1270     }
1271 
1272     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1273         automatedMarketMakerPairs[pair] = value;
1274 
1275         emit SetAutomatedMarketMakerPair(pair, value);
1276     }
1277 
1278     function updateMarketingWallet(address newMarketingWallet)
1279         external
1280         onlyOwner
1281     {
1282         emit marketingWalletsUpdated(newMarketingWallet, marketingWallet);
1283         marketingWallet = newMarketingWallet;
1284     }
1285 
1286     function updateDevWallet(address newWallet) external onlyOwner {
1287         emit devWalletUpdated(newWallet, devWallet);
1288         devWallet = newWallet;
1289     }
1290 
1291     function isExcludedFromFees(address account) public view returns (bool) {
1292         return _isExcludedFromFees[account];
1293     }
1294 
1295     event BoughtEarly(address indexed sniper);
1296 
1297     function _transfer(
1298         address from,
1299         address to,
1300         uint256 amount
1301     ) internal override {
1302         require(from != address(0), "ERC20: transfer from the zero address");
1303         require(to != address(0), "ERC20: transfer to the zero address");
1304 
1305         if (amount == 0) {
1306             super._transfer(from, to, 0);
1307             return;
1308         }
1309 
1310         if (limitsInEffect) {
1311             if (
1312                 from != owner() &&
1313                 to != owner() &&
1314                 to != address(0) &&
1315                 to != address(0xdead) &&
1316                 !swapping
1317             ) {
1318                 if (!tradingActive) {
1319                     require(
1320                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1321                         "Trading is not active."
1322                     );
1323                 }
1324 
1325                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1326                 if (transferDelayEnabled) {
1327                     if (
1328                         to != owner() &&
1329                         to != address(uniswapV2Router) &&
1330                         to != address(uniswapV2Pair)
1331                     ) {
1332                         require(
1333                             _holderLastTransferTimestamp[tx.origin] <
1334                                 block.number,
1335                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1336                         );
1337                         _holderLastTransferTimestamp[tx.origin] = block.number;
1338                     }
1339                 }
1340 
1341                 //when buy
1342                 if (
1343                     automatedMarketMakerPairs[from] &&
1344                     !_isExcludedMaxTransactionAmount[to]
1345                 ) {
1346                     require(
1347                         amount <= maxTransactionAmount,
1348                         "Buy transfer amount exceeds the maxTransactionAmount."
1349                     );
1350                     require(
1351                         amount + balanceOf(to) <= maxWallet,
1352                         "Max wallet exceeded"
1353                     );
1354                 }
1355                 //when sell
1356                 else if (
1357                     automatedMarketMakerPairs[to] &&
1358                     !_isExcludedMaxTransactionAmount[from]
1359                 ) {
1360                     require(
1361                         amount <= maxTransactionAmount,
1362                         "Sell transfer amount exceeds the maxTransactionAmount."
1363                     );
1364                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1365                     require(
1366                         amount + balanceOf(to) <= maxWallet,
1367                         "Max wallet exceeded"
1368                     );
1369                 }
1370             }
1371         }
1372 
1373         uint256 contractTokenBalance = balanceOf(address(this));
1374 
1375         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1376 
1377         if (
1378             canSwap &&
1379             swapEnabled &&
1380             !swapping &&
1381             !automatedMarketMakerPairs[from] &&
1382             !_isExcludedFromFees[from] &&
1383             !_isExcludedFromFees[to]
1384         ) {
1385             swapping = true;
1386 
1387             swapBack();
1388 
1389             swapping = false;
1390         }
1391 
1392         if (
1393             !swapping &&
1394             automatedMarketMakerPairs[to] &&
1395             lpBurnEnabled &&
1396             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1397             !_isExcludedFromFees[from]
1398         ) {
1399             autoBurnLiquidityPairTokens();
1400         }
1401 
1402         bool takeFee = !swapping;
1403 
1404         // if any account belongs to _isExcludedFromFee account then remove the fee
1405         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1406             takeFee = false;
1407         }
1408 
1409         uint256 fees = 0;
1410         // only take fees on buys/sells, do not take on wallet transfers
1411         if (takeFee) {
1412             // on sell
1413             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1414                 fees = amount.mul(sellTotalFees).div(100);
1415                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1416                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1417                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1418             }
1419             // on buy
1420             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1421                 fees = amount.mul(buyTotalFees).div(100);
1422                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1423                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1424                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1425             }
1426 
1427             if (fees > 0) {
1428                 super._transfer(from, address(this), fees);
1429             }
1430 
1431             amount -= fees;
1432         }
1433 
1434         super._transfer(from, to, amount);
1435     }
1436 
1437     function swapTokensForEth(uint256 tokenAmount) private {
1438         // generate the uniswap pair path of token -> weth
1439         address[] memory path = new address[](2);
1440         path[0] = address(this);
1441         path[1] = uniswapV2Router.WETH();
1442 
1443         _approve(address(this), address(uniswapV2Router), tokenAmount);
1444 
1445         // make the swap
1446         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1447             tokenAmount,
1448             0, // accept any amount of ETH
1449             path,
1450             address(this),
1451             block.timestamp
1452         );
1453     }
1454 
1455     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1456         // approve token transfer to cover all possible scenarios
1457         _approve(address(this), address(uniswapV2Router), tokenAmount);
1458 
1459         // add the liquidity
1460         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1461             address(this),
1462             tokenAmount,
1463             0, // slippage is unavoidable
1464             0, // slippage is unavoidable
1465             deadAddress,
1466             block.timestamp
1467         );
1468     }
1469 
1470     function swapBack() private {
1471         uint256 contractBalance = balanceOf(address(this));
1472         uint256 totalTokensToSwap = tokensForLiquidity +
1473             tokensForMarketing +
1474             tokensForDev;
1475         bool success;
1476 
1477         if (contractBalance == 0 || totalTokensToSwap == 0) {
1478             return;
1479         }
1480 
1481         if (contractBalance > swapTokensAtAmount * 20) {
1482             contractBalance = swapTokensAtAmount * 20;
1483         }
1484 
1485         // Halve the amount of liquidity tokens
1486         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1487             totalTokensToSwap /
1488             2;
1489         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1490 
1491         uint256 initialETHBalance = address(this).balance;
1492 
1493         swapTokensForEth(amountToSwapForETH);
1494 
1495         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1496 
1497         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1498             totalTokensToSwap
1499         );
1500         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1501 
1502         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1503 
1504         tokensForLiquidity = 0;
1505         tokensForMarketing = 0;
1506         tokensForDev = 0;
1507 
1508         (success, ) = address(devWallet).call{value: ethForDev}("");
1509 
1510         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1511             addLiquidity(liquidityTokens, ethForLiquidity);
1512             emit SwapAndLiquify(
1513                 amountToSwapForETH,
1514                 ethForLiquidity,
1515                 tokensForLiquidity
1516             );
1517         }
1518 
1519         (success, ) = address(marketingWallet).call{
1520             value: address(this).balance
1521         }("");
1522     }
1523 
1524     function setAutoLPBurnSettings(
1525         uint256 _frequencyInSeconds,
1526         uint256 _percent,
1527         bool _Enabled
1528     ) external onlyOwner {
1529         require(
1530             _frequencyInSeconds >= 600,
1531             "cannot set buyback more often than every 10 minutes"
1532         );
1533         require(
1534             _percent <= 1000 && _percent >= 0,
1535             "Must set auto LP burn percent between 0% and 10%"
1536         );
1537         lpBurnFrequency = _frequencyInSeconds;
1538         percentForLPBurn = _percent;
1539         lpBurnEnabled = _Enabled;
1540     }
1541 
1542     function autoBurnLiquidityPairTokens() internal returns (bool) {
1543         lastLpBurnTime = block.timestamp;
1544 
1545         // get balance of liquidity pair
1546         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1547 
1548         // calculate amount to burn
1549         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1550             10000
1551         );
1552 
1553         // pull tokens from pancakePair liquidity and move to dead address permanently
1554         if (amountToBurn > 0) {
1555             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1556         }
1557 
1558         //sync price since this is not in a swap transaction!
1559         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1560         pair.sync();
1561         emit AutoNukeLP();
1562         return true;
1563     }
1564 
1565     function manualBurnLiquidityPairTokens(uint256 percent)
1566         external
1567         onlyOwner
1568         returns (bool)
1569     {
1570         require(
1571             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1572             "Must wait for cooldown to finish"
1573         );
1574         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1575         lastManualLpBurnTime = block.timestamp;
1576 
1577         // get balance of liquidity pair
1578         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1579 
1580         // calculate amount to burn
1581         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1582 
1583         // pull tokens from pancakePair liquidity and move to dead address permanently
1584         if (amountToBurn > 0) {
1585             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1586         }
1587 
1588         //sync price since this is not in a swap transaction!
1589         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1590         pair.sync();
1591         emit ManualNukeLP();
1592         return true;
1593     }
1594 }