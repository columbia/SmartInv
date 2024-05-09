1 /**
2 https://t.me/NYANTOKENERC
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
7 pragma experimental ABIEncoderV2;
8 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
9 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
10 /* pragma solidity ^0.8.0; */
11 /**
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         return msg.data;
28     }
29 }
30 
31 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
32 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
33 
34 /* pragma solidity ^0.8.0; */
35 
36 /* import "../utils/Context.sol"; */
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
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
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         _transferOwnership(newOwner);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Internal function without access restriction.
100      */
101     function _transferOwnership(address newOwner) internal virtual {
102         address oldOwner = _owner;
103         _owner = newOwner;
104         emit OwnershipTransferred(oldOwner, newOwner);
105     }
106 }
107 
108 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
109 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
110 
111 /* pragma solidity ^0.8.0; */
112 
113 /**
114  * @dev Interface of the ERC20 standard as defined in the EIP.
115  */
116 interface IERC20 {
117     /**
118      * @dev Returns the amount of tokens in existence.
119      */
120     function totalSupply() external view returns (uint256);
121 
122     /**
123      * @dev Returns the amount of tokens owned by `account`.
124      */
125     function balanceOf(address account) external view returns (uint256);
126 
127     /**
128      * @dev Moves `amount` tokens from the caller's account to `recipient`.
129      *
130      * Returns a boolean value indicating whether the operation succeeded.
131      *
132      * Emits a {Transfer} event.
133      */
134     function transfer(address recipient, uint256 amount) external returns (bool);
135 
136     /**
137      * @dev Returns the remaining number of tokens that `spender` will be
138      * allowed to spend on behalf of `owner` through {transferFrom}. This is
139      * zero by default.
140      *
141      * This value changes when {approve} or {transferFrom} are called.
142      */
143     function allowance(address owner, address spender) external view returns (uint256);
144 
145     /**
146      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
147      *
148      * Returns a boolean value indicating whether the operation succeeded.
149      *
150      * IMPORTANT: Beware that changing an allowance with this method brings the risk
151      * that someone may use both the old and the new allowance by unfortunate
152      * transaction ordering. One possible solution to mitigate this race
153      * condition is to first reduce the spender's allowance to 0 and set the
154      * desired value afterwards:
155      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156      *
157      * Emits an {Approval} event.
158      */
159     function approve(address spender, uint256 amount) external returns (bool);
160 
161     /**
162      * @dev Moves `amount` tokens from `sender` to `recipient` using the
163      * allowance mechanism. `amount` is then deducted from the caller's
164      * allowance.
165      *
166      * Returns a boolean value indicating whether the operation succeeded.
167      *
168      * Emits a {Transfer} event.
169      */
170     function transferFrom(
171         address sender,
172         address recipient,
173         uint256 amount
174     ) external returns (bool);
175 
176     /**
177      * @dev Emitted when `value` tokens are moved from one account (`from`) to
178      * another (`to`).
179      *
180      * Note that `value` may be zero.
181      */
182     event Transfer(address indexed from, address indexed to, uint256 value);
183 
184     /**
185      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
186      * a call to {approve}. `value` is the new allowance.
187      */
188     event Approval(address indexed owner, address indexed spender, uint256 value);
189 }
190 
191 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
192 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
193 
194 /* pragma solidity ^0.8.0; */
195 
196 /* import "../IERC20.sol"; */
197 
198 /**
199  * @dev Interface for the optional metadata functions from the ERC20 standard.
200  *
201  * _Available since v4.1._
202  */
203 interface IERC20Metadata is IERC20 {
204     /**
205      * @dev Returns the name of the token.
206      */
207     function name() external view returns (string memory);
208 
209     /**
210      * @dev Returns the symbol of the token.
211      */
212     function symbol() external view returns (string memory);
213 
214     /**
215      * @dev Returns the decimals places of the token.
216      */
217     function decimals() external view returns (uint8);
218 }
219 
220 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
221 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
222 
223 /* pragma solidity ^0.8.0; */
224 
225 /* import "./IERC20.sol"; */
226 /* import "./extensions/IERC20Metadata.sol"; */
227 /* import "../../utils/Context.sol"; */
228 
229 /**
230  * @dev Implementation of the {IERC20} interface.
231  *
232  * This implementation is agnostic to the way tokens are created. This means
233  * that a supply mechanism has to be added in a derived contract using {_mint}.
234  * For a generic mechanism see {ERC20PresetMinterPauser}.
235  *
236  * TIP: For a detailed writeup see our guide
237  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
238  * to implement supply mechanisms].
239  *
240  * We have followed general OpenZeppelin Contracts guidelines: functions revert
241  * instead returning `false` on failure. This behavior is nonetheless
242  * conventional and does not conflict with the expectations of ERC20
243  * applications.
244  *
245  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
246  * This allows applications to reconstruct the allowance for all accounts just
247  * by listening to said events. Other implementations of the EIP may not emit
248  * these events, as it isn't required by the specification.
249  *
250  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
251  * functions have been added to mitigate the well-known issues around setting
252  * allowances. See {IERC20-approve}.
253  */
254 contract ERC20 is Context, IERC20, IERC20Metadata {
255     mapping(address => uint256) private _balances;
256 
257     mapping(address => mapping(address => uint256)) private _allowances;
258 
259     uint256 private _totalSupply;
260 
261     string private _name;
262     string private _symbol;
263 
264     /**
265      * @dev Sets the values for {name} and {symbol}.
266      *
267      * The default value of {decimals} is 18. To select a different value for
268      * {decimals} you should overload it.
269      *
270      * All two of these values are immutable: they can only be set once during
271      * construction.
272      */
273     constructor(string memory name_, string memory symbol_) {
274         _name = name_;
275         _symbol = symbol_;
276     }
277 
278     /**
279      * @dev Returns the name of the token.
280      */
281     function name() public view virtual override returns (string memory) {
282         return _name;
283     }
284 
285     /**
286      * @dev Returns the symbol of the token, usually a shorter version of the
287      * name.
288      */
289     function symbol() public view virtual override returns (string memory) {
290         return _symbol;
291     }
292 
293     /**
294      * @dev Returns the number of decimals used to get its user representation.
295      * For example, if `decimals` equals `2`, a balance of `505` tokens should
296      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
297      *
298      * Tokens usually opt for a value of 18, imitating the relationship between
299      * Ether and Wei. This is the value {ERC20} uses, unless this function is
300      * overridden;
301      *
302      * NOTE: This information is only used for _display_ purposes: it in
303      * no way affects any of the arithmetic of the contract, including
304      * {IERC20-balanceOf} and {IERC20-transfer}.
305      */
306     function decimals() public view virtual override returns (uint8) {
307         return 18;
308     }
309 
310     /**
311      * @dev See {IERC20-totalSupply}.
312      */
313     function totalSupply() public view virtual override returns (uint256) {
314         return _totalSupply;
315     }
316 
317     /**
318      * @dev See {IERC20-balanceOf}.
319      */
320     function balanceOf(address account) public view virtual override returns (uint256) {
321         return _balances[account];
322     }
323 
324     /**
325      * @dev See {IERC20-transfer}.
326      *
327      * Requirements:
328      *
329      * - `recipient` cannot be the zero address.
330      * - the caller must have a balance of at least `amount`.
331      */
332     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
333         _transfer(_msgSender(), recipient, amount);
334         return true;
335     }
336 
337     /**
338      * @dev See {IERC20-allowance}.
339      */
340     function allowance(address owner, address spender) public view virtual override returns (uint256) {
341         return _allowances[owner][spender];
342     }
343 
344     /**
345      * @dev See {IERC20-approve}.
346      *
347      * Requirements:
348      *
349      * - `spender` cannot be the zero address.
350      */
351     function approve(address spender, uint256 amount) public virtual override returns (bool) {
352         _approve(_msgSender(), spender, amount);
353         return true;
354     }
355 
356     /**
357      * @dev See {IERC20-transferFrom}.
358      *
359      * Emits an {Approval} event indicating the updated allowance. This is not
360      * required by the EIP. See the note at the beginning of {ERC20}.
361      *
362      * Requirements:
363      *
364      * - `sender` and `recipient` cannot be the zero address.
365      * - `sender` must have a balance of at least `amount`.
366      * - the caller must have allowance for ``sender``'s tokens of at least
367      * `amount`.
368      */
369     function transferFrom(
370         address sender,
371         address recipient,
372         uint256 amount
373     ) public virtual override returns (bool) {
374         _transfer(sender, recipient, amount);
375 
376         uint256 currentAllowance = _allowances[sender][_msgSender()];
377         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
378         unchecked {
379             _approve(sender, _msgSender(), currentAllowance - amount);
380         }
381 
382         return true;
383     }
384 
385     /**
386      * @dev Atomically increases the allowance granted to `spender` by the caller.
387      *
388      * This is an alternative to {approve} that can be used as a mitigation for
389      * problems described in {IERC20-approve}.
390      *
391      * Emits an {Approval} event indicating the updated allowance.
392      *
393      * Requirements:
394      *
395      * - `spender` cannot be the zero address.
396      */
397     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
398         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
399         return true;
400     }
401 
402     /**
403      * @dev Atomically decreases the allowance granted to `spender` by the caller.
404      *
405      * This is an alternative to {approve} that can be used as a mitigation for
406      * problems described in {IERC20-approve}.
407      *
408      * Emits an {Approval} event indicating the updated allowance.
409      *
410      * Requirements:
411      *
412      * - `spender` cannot be the zero address.
413      * - `spender` must have allowance for the caller of at least
414      * `subtractedValue`.
415      */
416     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
417         uint256 currentAllowance = _allowances[_msgSender()][spender];
418         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
419         unchecked {
420             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
421         }
422 
423         return true;
424     }
425 
426     /**
427      * @dev Moves `amount` of tokens from `sender` to `recipient`.
428      *
429      * This internal function is equivalent to {transfer}, and can be used to
430      * e.g. implement automatic token fees, slashing mechanisms, etc.
431      *
432      * Emits a {Transfer} event.
433      *
434      * Requirements:
435      *
436      * - `sender` cannot be the zero address.
437      * - `recipient` cannot be the zero address.
438      * - `sender` must have a balance of at least `amount`.
439      */
440     function _transfer(
441         address sender,
442         address recipient,
443         uint256 amount
444     ) internal virtual {
445         require(sender != address(0), "ERC20: transfer from the zero address");
446         require(recipient != address(0), "ERC20: transfer to the zero address");
447 
448         _beforeTokenTransfer(sender, recipient, amount);
449 
450         uint256 senderBalance = _balances[sender];
451         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
452         unchecked {
453             _balances[sender] = senderBalance - amount;
454         }
455         _balances[recipient] += amount;
456 
457         emit Transfer(sender, recipient, amount);
458 
459         _afterTokenTransfer(sender, recipient, amount);
460     }
461 
462     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
463      * the total supply.
464      *
465      * Emits a {Transfer} event with `from` set to the zero address.
466      *
467      * Requirements:
468      *
469      * - `account` cannot be the zero address.
470      */
471     function _mint(address account, uint256 amount) internal virtual {
472         require(account != address(0), "ERC20: mint to the zero address");
473 
474         _beforeTokenTransfer(address(0), account, amount);
475 
476         _totalSupply += amount;
477         _balances[account] += amount;
478         emit Transfer(address(0), account, amount);
479 
480         _afterTokenTransfer(address(0), account, amount);
481     }
482 
483     /**
484      * @dev Destroys `amount` tokens from `account`, reducing the
485      * total supply.
486      *
487      * Emits a {Transfer} event with `to` set to the zero address.
488      *
489      * Requirements:
490      *
491      * - `account` cannot be the zero address.
492      * - `account` must have at least `amount` tokens.
493      */
494     function _burn(address account, uint256 amount) internal virtual {
495         require(account != address(0), "ERC20: burn from the zero address");
496 
497         _beforeTokenTransfer(account, address(0), amount);
498 
499         uint256 accountBalance = _balances[account];
500         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
501         unchecked {
502             _balances[account] = accountBalance - amount;
503         }
504         _totalSupply -= amount;
505 
506         emit Transfer(account, address(0), amount);
507 
508         _afterTokenTransfer(account, address(0), amount);
509     }
510 
511     /**
512      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
513      *
514      * This internal function is equivalent to `approve`, and can be used to
515      * e.g. set automatic allowances for certain subsystems, etc.
516      *
517      * Emits an {Approval} event.
518      *
519      * Requirements:
520      *
521      * - `owner` cannot be the zero address.
522      * - `spender` cannot be the zero address.
523      */
524     function _approve(
525         address owner,
526         address spender,
527         uint256 amount
528     ) internal virtual {
529         require(owner != address(0), "ERC20: approve from the zero address");
530         require(spender != address(0), "ERC20: approve to the zero address");
531 
532         _allowances[owner][spender] = amount;
533         emit Approval(owner, spender, amount);
534     }
535 
536     /**
537      * @dev Hook that is called before any transfer of tokens. This includes
538      * minting and burning.
539      *
540      * Calling conditions:
541      *
542      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
543      * will be transferred to `to`.
544      * - when `from` is zero, `amount` tokens will be minted for `to`.
545      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
546      * - `from` and `to` are never both zero.
547      *
548      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
549      */
550     function _beforeTokenTransfer(
551         address from,
552         address to,
553         uint256 amount
554     ) internal virtual {}
555 
556     /**
557      * @dev Hook that is called after any transfer of tokens. This includes
558      * minting and burning.
559      *
560      * Calling conditions:
561      *
562      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
563      * has been transferred to `to`.
564      * - when `from` is zero, `amount` tokens have been minted for `to`.
565      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
566      * - `from` and `to` are never both zero.
567      *
568      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
569      */
570     function _afterTokenTransfer(
571         address from,
572         address to,
573         uint256 amount
574     ) internal virtual {}
575 }
576 
577 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
578 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
579 
580 /* pragma solidity ^0.8.0; */
581 
582 // CAUTION
583 // This version of SafeMath should only be used with Solidity 0.8 or later,
584 // because it relies on the compiler's built in overflow checks.
585 
586 /**
587  * @dev Wrappers over Solidity's arithmetic operations.
588  *
589  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
590  * now has built in overflow checking.
591  */
592 library SafeMath {
593     /**
594      * @dev Returns the addition of two unsigned integers, with an overflow flag.
595      *
596      * _Available since v3.4._
597      */
598     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
599         unchecked {
600             uint256 c = a + b;
601             if (c < a) return (false, 0);
602             return (true, c);
603         }
604     }
605 
606     /**
607      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
608      *
609      * _Available since v3.4._
610      */
611     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
612         unchecked {
613             if (b > a) return (false, 0);
614             return (true, a - b);
615         }
616     }
617 
618     /**
619      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
620      *
621      * _Available since v3.4._
622      */
623     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
624         unchecked {
625             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
626             // benefit is lost if 'b' is also tested.
627             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
628             if (a == 0) return (true, 0);
629             uint256 c = a * b;
630             if (c / a != b) return (false, 0);
631             return (true, c);
632         }
633     }
634 
635     /**
636      * @dev Returns the division of two unsigned integers, with a division by zero flag.
637      *
638      * _Available since v3.4._
639      */
640     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
641         unchecked {
642             if (b == 0) return (false, 0);
643             return (true, a / b);
644         }
645     }
646 
647     /**
648      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
649      *
650      * _Available since v3.4._
651      */
652     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
653         unchecked {
654             if (b == 0) return (false, 0);
655             return (true, a % b);
656         }
657     }
658 
659     /**
660      * @dev Returns the addition of two unsigned integers, reverting on
661      * overflow.
662      *
663      * Counterpart to Solidity's `+` operator.
664      *
665      * Requirements:
666      *
667      * - Addition cannot overflow.
668      */
669     function add(uint256 a, uint256 b) internal pure returns (uint256) {
670         return a + b;
671     }
672 
673     /**
674      * @dev Returns the subtraction of two unsigned integers, reverting on
675      * overflow (when the result is negative).
676      *
677      * Counterpart to Solidity's `-` operator.
678      *
679      * Requirements:
680      *
681      * - Subtraction cannot overflow.
682      */
683     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
684         return a - b;
685     }
686 
687     /**
688      * @dev Returns the multiplication of two unsigned integers, reverting on
689      * overflow.
690      *
691      * Counterpart to Solidity's `*` operator.
692      *
693      * Requirements:
694      *
695      * - Multiplication cannot overflow.
696      */
697     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
698         return a * b;
699     }
700 
701     /**
702      * @dev Returns the integer division of two unsigned integers, reverting on
703      * division by zero. The result is rounded towards zero.
704      *
705      * Counterpart to Solidity's `/` operator.
706      *
707      * Requirements:
708      *
709      * - The divisor cannot be zero.
710      */
711     function div(uint256 a, uint256 b) internal pure returns (uint256) {
712         return a / b;
713     }
714 
715     /**
716      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
717      * reverting when dividing by zero.
718      *
719      * Counterpart to Solidity's `%` operator. This function uses a `revert`
720      * opcode (which leaves remaining gas untouched) while Solidity uses an
721      * invalid opcode to revert (consuming all remaining gas).
722      *
723      * Requirements:
724      *
725      * - The divisor cannot be zero.
726      */
727     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
728         return a % b;
729     }
730 
731     /**
732      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
733      * overflow (when the result is negative).
734      *
735      * CAUTION: This function is deprecated because it requires allocating memory for the error
736      * message unnecessarily. For custom revert reasons use {trySub}.
737      *
738      * Counterpart to Solidity's `-` operator.
739      *
740      * Requirements:
741      *
742      * - Subtraction cannot overflow.
743      */
744     function sub(
745         uint256 a,
746         uint256 b,
747         string memory errorMessage
748     ) internal pure returns (uint256) {
749         unchecked {
750             require(b <= a, errorMessage);
751             return a - b;
752         }
753     }
754 
755     /**
756      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
757      * division by zero. The result is rounded towards zero.
758      *
759      * Counterpart to Solidity's `/` operator. Note: this function uses a
760      * `revert` opcode (which leaves remaining gas untouched) while Solidity
761      * uses an invalid opcode to revert (consuming all remaining gas).
762      *
763      * Requirements:
764      *
765      * - The divisor cannot be zero.
766      */
767     function div(
768         uint256 a,
769         uint256 b,
770         string memory errorMessage
771     ) internal pure returns (uint256) {
772         unchecked {
773             require(b > 0, errorMessage);
774             return a / b;
775         }
776     }
777 
778     /**
779      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
780      * reverting with custom message when dividing by zero.
781      *
782      * CAUTION: This function is deprecated because it requires allocating memory for the error
783      * message unnecessarily. For custom revert reasons use {tryMod}.
784      *
785      * Counterpart to Solidity's `%` operator. This function uses a `revert`
786      * opcode (which leaves remaining gas untouched) while Solidity uses an
787      * invalid opcode to revert (consuming all remaining gas).
788      *
789      * Requirements:
790      *
791      * - The divisor cannot be zero.
792      */
793     function mod(
794         uint256 a,
795         uint256 b,
796         string memory errorMessage
797     ) internal pure returns (uint256) {
798         unchecked {
799             require(b > 0, errorMessage);
800             return a % b;
801         }
802     }
803 }
804 
805 /* pragma solidity 0.8.10; */
806 /* pragma experimental ABIEncoderV2; */
807 
808 interface IUniswapV2Factory {
809     event PairCreated(
810         address indexed token0,
811         address indexed token1,
812         address pair,
813         uint256
814     );
815 
816     function feeTo() external view returns (address);
817 
818     function feeToSetter() external view returns (address);
819 
820     function getPair(address tokenA, address tokenB)
821         external
822         view
823         returns (address pair);
824 
825     function allPairs(uint256) external view returns (address pair);
826 
827     function allPairsLength() external view returns (uint256);
828 
829     function createPair(address tokenA, address tokenB)
830         external
831         returns (address pair);
832 
833     function setFeeTo(address) external;
834 
835     function setFeeToSetter(address) external;
836 }
837 
838 /* pragma solidity 0.8.10; */
839 /* pragma experimental ABIEncoderV2; */ 
840 
841 interface IUniswapV2Pair {
842     event Approval(
843         address indexed owner,
844         address indexed spender,
845         uint256 value
846     );
847     event Transfer(address indexed from, address indexed to, uint256 value);
848 
849     function name() external pure returns (string memory);
850 
851     function symbol() external pure returns (string memory);
852 
853     function decimals() external pure returns (uint8);
854 
855     function totalSupply() external view returns (uint256);
856 
857     function balanceOf(address owner) external view returns (uint256);
858 
859     function allowance(address owner, address spender)
860         external
861         view
862         returns (uint256);
863 
864     function approve(address spender, uint256 value) external returns (bool);
865 
866     function transfer(address to, uint256 value) external returns (bool);
867 
868     function transferFrom(
869         address from,
870         address to,
871         uint256 value
872     ) external returns (bool);
873 
874     function DOMAIN_SEPARATOR() external view returns (bytes32);
875 
876     function PERMIT_TYPEHASH() external pure returns (bytes32);
877 
878     function nonces(address owner) external view returns (uint256);
879 
880     function permit(
881         address owner,
882         address spender,
883         uint256 value,
884         uint256 deadline,
885         uint8 v,
886         bytes32 r,
887         bytes32 s
888     ) external;
889 
890     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
891     event Burn(
892         address indexed sender,
893         uint256 amount0,
894         uint256 amount1,
895         address indexed to
896     );
897     event Swap(
898         address indexed sender,
899         uint256 amount0In,
900         uint256 amount1In,
901         uint256 amount0Out,
902         uint256 amount1Out,
903         address indexed to
904     );
905     event Sync(uint112 reserve0, uint112 reserve1);
906 
907     function MINIMUM_LIQUIDITY() external pure returns (uint256);
908 
909     function factory() external view returns (address);
910 
911     function token0() external view returns (address);
912 
913     function token1() external view returns (address);
914 
915     function getReserves()
916         external
917         view
918         returns (
919             uint112 reserve0,
920             uint112 reserve1,
921             uint32 blockTimestampLast
922         );
923 
924     function price0CumulativeLast() external view returns (uint256);
925 
926     function price1CumulativeLast() external view returns (uint256);
927 
928     function kLast() external view returns (uint256);
929 
930     function mint(address to) external returns (uint256 liquidity);
931 
932     function burn(address to)
933         external
934         returns (uint256 amount0, uint256 amount1);
935 
936     function swap(
937         uint256 amount0Out,
938         uint256 amount1Out,
939         address to,
940         bytes calldata data
941     ) external;
942 
943     function skim(address to) external;
944 
945     function sync() external;
946 
947     function initialize(address, address) external;
948 }
949 
950 /* pragma solidity 0.8.10; */
951 /* pragma experimental ABIEncoderV2; */
952 
953 interface IUniswapV2Router02 {
954     function factory() external pure returns (address);
955 
956     function WETH() external pure returns (address);
957 
958     function addLiquidity(
959         address tokenA,
960         address tokenB,
961         uint256 amountADesired,
962         uint256 amountBDesired,
963         uint256 amountAMin,
964         uint256 amountBMin,
965         address to,
966         uint256 deadline
967     )
968         external
969         returns (
970             uint256 amountA,
971             uint256 amountB,
972             uint256 liquidity
973         );
974 
975     function addLiquidityETH(
976         address token,
977         uint256 amountTokenDesired,
978         uint256 amountTokenMin,
979         uint256 amountETHMin,
980         address to,
981         uint256 deadline
982     )
983         external
984         payable
985         returns (
986             uint256 amountToken,
987             uint256 amountETH,
988             uint256 liquidity
989         );
990 
991     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
992         uint256 amountIn,
993         uint256 amountOutMin,
994         address[] calldata path,
995         address to,
996         uint256 deadline
997     ) external;
998 
999     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1000         uint256 amountOutMin,
1001         address[] calldata path,
1002         address to,
1003         uint256 deadline
1004     ) external payable;
1005 
1006     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1007         uint256 amountIn,
1008         uint256 amountOutMin,
1009         address[] calldata path,
1010         address to,
1011         uint256 deadline
1012     ) external;
1013 }
1014 
1015 /* pragma solidity >=0.8.10; */
1016 
1017 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1018 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1019 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1020 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1021 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1022 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1023 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1024 
1025 contract MYANCAT is ERC20, Ownable {
1026     using SafeMath for uint256;
1027 
1028     IUniswapV2Router02 public immutable uniswapV2Router;
1029     address public immutable uniswapV2Pair;
1030     address public constant deadAddress = address(0xdead);
1031 
1032     bool private swapping;
1033 
1034 	address public charityWallet;
1035     address public marketingWallet;
1036     address public devWallet;
1037 
1038     uint256 public maxTransactionAmount;
1039     uint256 public swapTokensAtAmount;
1040     uint256 public maxWallet;
1041 
1042     bool public limitsInEffect = true;
1043     bool public tradingActive = true;
1044     bool public swapEnabled = true;
1045 
1046     // Anti-bot and anti-whale mappings and variables
1047     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1048     bool public transferDelayEnabled = true;
1049 
1050     uint256 public buyTotalFees;
1051 	uint256 public buyCharityFee;
1052     uint256 public buyMarketingFee;
1053     uint256 public buyLiquidityFee;
1054     uint256 public buyDevFee;
1055 
1056     uint256 public sellTotalFees;
1057 	uint256 public sellCharityFee;
1058     uint256 public sellMarketingFee;
1059     uint256 public sellLiquidityFee;
1060     uint256 public sellDevFee;
1061 
1062 	uint256 public tokensForCharity;
1063     uint256 public tokensForMarketing;
1064     uint256 public tokensForLiquidity;
1065     uint256 public tokensForDev;
1066 
1067     /******************/
1068 
1069     // exlcude from fees and max transaction amount
1070     mapping(address => bool) private _isExcludedFromFees;
1071     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1072 
1073     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1074     // could be subject to a maximum transfer amount
1075     mapping(address => bool) public automatedMarketMakerPairs;
1076 
1077     event UpdateUniswapV2Router(
1078         address indexed newAddress,
1079         address indexed oldAddress
1080     );
1081 
1082     event ExcludeFromFees(address indexed account, bool isExcluded);
1083 
1084     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1085 
1086     event SwapAndLiquify(
1087         uint256 tokensSwapped,
1088         uint256 ethReceived,
1089         uint256 tokensIntoLiquidity
1090     );
1091 
1092     constructor() ERC20("Nyan Cat", "NYANCAT") {
1093         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1094             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1095         );
1096 
1097         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1098         uniswapV2Router = _uniswapV2Router;
1099 
1100         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1101             .createPair(address(this), _uniswapV2Router.WETH());
1102         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1103         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1104 
1105 		uint256 _buyCharityFee = 0;
1106         uint256 _buyMarketingFee = 10;
1107         uint256 _buyLiquidityFee = 0;
1108         uint256 _buyDevFee = 10;
1109 
1110 		uint256 _sellCharityFee = 0;
1111         uint256 _sellMarketingFee = 15;
1112         uint256 _sellLiquidityFee = 0;
1113         uint256 _sellDevFee = 15;
1114 
1115         uint256 totalSupply = 1000000000 * 1e18;
1116 
1117         maxTransactionAmount = 10000000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1118         maxWallet = 10000000 * 1e18; // 2% from total supply maxWallet
1119         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1120 
1121 		buyCharityFee = _buyCharityFee;
1122         buyMarketingFee = _buyMarketingFee;
1123         buyLiquidityFee = _buyLiquidityFee;
1124         buyDevFee = _buyDevFee;
1125         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1126 
1127 		sellCharityFee = _sellCharityFee;
1128         sellMarketingFee = _sellMarketingFee;
1129         sellLiquidityFee = _sellLiquidityFee;
1130         sellDevFee = _sellDevFee;
1131         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1132 
1133 		charityWallet = address(0x7D0f6c892756eBC00F025eBFc361F492307E2Ec4); // set as charity wallet
1134         marketingWallet = address(0x7D0f6c892756eBC00F025eBFc361F492307E2Ec4); // set as marketing wallet
1135         devWallet = address(0x7D0f6c892756eBC00F025eBFc361F492307E2Ec4); // set as dev wallet
1136 
1137         // exclude from paying fees or having max transaction amount
1138         excludeFromFees(owner(), true);
1139         excludeFromFees(address(this), true);
1140         excludeFromFees(address(0xdead), true);
1141 
1142         excludeFromMaxTransaction(owner(), true);
1143         excludeFromMaxTransaction(address(this), true);
1144         excludeFromMaxTransaction(address(0xdead), true);
1145 
1146         /*
1147             _mint is an internal function in ERC20.sol that is only called here,
1148             and CANNOT be called ever again
1149         */
1150         _mint(msg.sender, totalSupply);
1151     }
1152 
1153     receive() external payable {}
1154 
1155     // once enabled, can never be turned off
1156     function enableTrading() external onlyOwner {
1157         tradingActive = true;
1158         swapEnabled = true;
1159     }
1160 
1161     // remove limits after token is stable
1162     function removeLimits() external onlyOwner returns (bool) {
1163         limitsInEffect = false;
1164         return true;
1165     }
1166 
1167     // disable Transfer delay - cannot be reenabled
1168     function disableTransferDelay() external onlyOwner returns (bool) {
1169         transferDelayEnabled = false;
1170         return true;
1171     }
1172 
1173     // change the minimum amount of tokens to sell from fees
1174     function updateSwapTokensAtAmount(uint256 newAmount)
1175         external
1176         onlyOwner
1177         returns (bool)
1178     {
1179         require(
1180             newAmount >= (totalSupply() * 1) / 100000,
1181             "Swap amount cannot be lower than 0.001% total supply."
1182         );
1183         require(
1184             newAmount <= (totalSupply() * 5) / 1000,
1185             "Swap amount cannot be higher than 0.5% total supply."
1186         );
1187         swapTokensAtAmount = newAmount;
1188         return true;
1189     }
1190 
1191     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1192         require(
1193             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1194             "Cannot set maxTransactionAmount lower than 0.5%"
1195         );
1196         maxTransactionAmount = newNum * (10**18);
1197     }
1198 
1199     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1200         require(
1201             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1202             "Cannot set maxWallet lower than 0.5%"
1203         );
1204         maxWallet = newNum * (10**18);
1205     }
1206 	
1207     function excludeFromMaxTransaction(address updAds, bool isEx)
1208         public
1209         onlyOwner
1210     {
1211         _isExcludedMaxTransactionAmount[updAds] = isEx;
1212     }
1213 
1214     // only use to disable contract sales if absolutely necessary (emergency use only)
1215     function updateSwapEnabled(bool enabled) external onlyOwner {
1216         swapEnabled = enabled;
1217     }
1218 
1219     function updateBuyFees(
1220 		uint256 _charityFee,
1221         uint256 _marketingFee,
1222         uint256 _liquidityFee,
1223         uint256 _devFee
1224     ) external onlyOwner {
1225 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max BuyFee 10%");
1226 		buyCharityFee = _charityFee;
1227         buyMarketingFee = _marketingFee;
1228         buyLiquidityFee = _liquidityFee;
1229         buyDevFee = _devFee;
1230         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1231      }
1232 
1233     function updateSellFees(
1234 		uint256 _charityFee,
1235         uint256 _marketingFee,
1236         uint256 _liquidityFee,
1237         uint256 _devFee
1238     ) external onlyOwner {
1239 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max SellFee 10%");
1240 		sellCharityFee = _charityFee;
1241         sellMarketingFee = _marketingFee;
1242         sellLiquidityFee = _liquidityFee;
1243         sellDevFee = _devFee;
1244         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1245     }
1246 
1247     function excludeFromFees(address account, bool excluded) public onlyOwner {
1248         _isExcludedFromFees[account] = excluded;
1249         emit ExcludeFromFees(account, excluded);
1250     }
1251 
1252     function setAutomatedMarketMakerPair(address pair, bool value)
1253         public
1254         onlyOwner
1255     {
1256         require(
1257             pair != uniswapV2Pair,
1258             "The pair cannot be removed from automatedMarketMakerPairs"
1259         );
1260 
1261         _setAutomatedMarketMakerPair(pair, value);
1262     }
1263 
1264     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1265         automatedMarketMakerPairs[pair] = value;
1266 
1267         emit SetAutomatedMarketMakerPair(pair, value);
1268     }
1269 
1270     function isExcludedFromFees(address account) public view returns (bool) {
1271         return _isExcludedFromFees[account];
1272     }
1273 
1274     function _transfer(
1275         address from,
1276         address to,
1277         uint256 amount
1278     ) internal override {
1279         require(from != address(0), "ERC20: transfer from the zero address");
1280         require(to != address(0), "ERC20: transfer to the zero address");
1281 
1282         if (amount == 0) {
1283             super._transfer(from, to, 0);
1284             return;
1285         }
1286 
1287         if (limitsInEffect) {
1288             if (
1289                 from != owner() &&
1290                 to != owner() &&
1291                 to != address(0) &&
1292                 to != address(0xdead) &&
1293                 !swapping
1294             ) {
1295                 if (!tradingActive) {
1296                     require(
1297                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1298                         "Trading is not active."
1299                     );
1300                 }
1301 
1302                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1303                 if (transferDelayEnabled) {
1304                     if (
1305                         to != owner() &&
1306                         to != address(uniswapV2Router) &&
1307                         to != address(uniswapV2Pair)
1308                     ) {
1309                         require(
1310                             _holderLastTransferTimestamp[tx.origin] <
1311                                 block.number,
1312                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1313                         );
1314                         _holderLastTransferTimestamp[tx.origin] = block.number;
1315                     }
1316                 }
1317 
1318                 //when buy
1319                 if (
1320                     automatedMarketMakerPairs[from] &&
1321                     !_isExcludedMaxTransactionAmount[to]
1322                 ) {
1323                     require(
1324                         amount <= maxTransactionAmount,
1325                         "Buy transfer amount exceeds the maxTransactionAmount."
1326                     );
1327                     require(
1328                         amount + balanceOf(to) <= maxWallet,
1329                         "Max wallet exceeded"
1330                     );
1331                 }
1332                 //when sell
1333                 else if (
1334                     automatedMarketMakerPairs[to] &&
1335                     !_isExcludedMaxTransactionAmount[from]
1336                 ) {
1337                     require(
1338                         amount <= maxTransactionAmount,
1339                         "Sell transfer amount exceeds the maxTransactionAmount."
1340                     );
1341                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1342                     require(
1343                         amount + balanceOf(to) <= maxWallet,
1344                         "Max wallet exceeded"
1345                     );
1346                 }
1347             }
1348         }
1349 
1350         uint256 contractTokenBalance = balanceOf(address(this));
1351 
1352         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1353 
1354         if (
1355             canSwap &&
1356             swapEnabled &&
1357             !swapping &&
1358             !automatedMarketMakerPairs[from] &&
1359             !_isExcludedFromFees[from] &&
1360             !_isExcludedFromFees[to]
1361         ) {
1362             swapping = true;
1363 
1364             swapBack();
1365 
1366             swapping = false;
1367         }
1368 
1369         bool takeFee = !swapping;
1370 
1371         // if any account belongs to _isExcludedFromFee account then remove the fee
1372         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1373             takeFee = false;
1374         }
1375 
1376         uint256 fees = 0;
1377         // only take fees on buys/sells, do not take on wallet transfers
1378         if (takeFee) {
1379             // on sell
1380             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1381                 fees = amount.mul(sellTotalFees).div(100);
1382 				tokensForCharity += (fees * sellCharityFee) / sellTotalFees;
1383                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1384                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1385                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1386             }
1387             // on buy
1388             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1389                 fees = amount.mul(buyTotalFees).div(100);
1390 				tokensForCharity += (fees * buyCharityFee) / buyTotalFees;
1391                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1392                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1393                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1394             }
1395 
1396             if (fees > 0) {
1397                 super._transfer(from, address(this), fees);
1398             }
1399 
1400             amount -= fees;
1401         }
1402 
1403         super._transfer(from, to, amount);
1404     }
1405 
1406     function swapTokensForEth(uint256 tokenAmount) private {
1407         // generate the uniswap pair path of token -> weth
1408         address[] memory path = new address[](2);
1409         path[0] = address(this);
1410         path[1] = uniswapV2Router.WETH();
1411 
1412         _approve(address(this), address(uniswapV2Router), tokenAmount);
1413 
1414         // make the swap
1415         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1416             tokenAmount,
1417             0, // accept any amount of ETH
1418             path,
1419             address(this),
1420             block.timestamp
1421         );
1422     }
1423 
1424     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1425         // approve token transfer to cover all possible scenarios
1426         _approve(address(this), address(uniswapV2Router), tokenAmount);
1427 
1428         // add the liquidity
1429         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1430             address(this),
1431             tokenAmount,
1432             0, // slippage is unavoidable
1433             0, // slippage is unavoidable
1434             devWallet,
1435             block.timestamp
1436         );
1437     }
1438 
1439     function swapBack() private {
1440         uint256 contractBalance = balanceOf(address(this));
1441         uint256 totalTokensToSwap = tokensForCharity + tokensForLiquidity + tokensForMarketing + tokensForDev;
1442         bool success;
1443 
1444         if (contractBalance == 0 || totalTokensToSwap == 0) {
1445             return;
1446         }
1447 
1448         if (contractBalance > swapTokensAtAmount * 20) {
1449             contractBalance = swapTokensAtAmount * 20;
1450         }
1451 
1452         // Halve the amount of liquidity tokens
1453         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1454         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1455 
1456         uint256 initialETHBalance = address(this).balance;
1457 
1458         swapTokensForEth(amountToSwapForETH);
1459 
1460         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1461 
1462 		uint256 ethForCharity = ethBalance.mul(tokensForCharity).div(totalTokensToSwap);
1463         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1464         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1465 
1466         uint256 ethForLiquidity = ethBalance - ethForCharity - ethForMarketing - ethForDev;
1467 
1468         tokensForLiquidity = 0;
1469 		tokensForCharity = 0;
1470         tokensForMarketing = 0;
1471         tokensForDev = 0;
1472 
1473         (success, ) = address(devWallet).call{value: ethForDev}("");
1474         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1475 
1476 
1477         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1478             addLiquidity(liquidityTokens, ethForLiquidity);
1479             emit SwapAndLiquify(
1480                 amountToSwapForETH,
1481                 ethForLiquidity,
1482                 tokensForLiquidity
1483             );
1484         }
1485 
1486         (success, ) = address(charityWallet).call{value: address(this).balance}("");
1487     }
1488 
1489 }