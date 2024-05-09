1 // SPDX-License-Identifier: Unlicensed  
2 
3 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
4 pragma experimental ABIEncoderV2;
5 
6 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
7 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
8 
9 /* pragma solidity ^0.8.0; */
10 
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
805 ////// src/IUniswapV2Factory.sol
806 /* pragma solidity 0.8.10; */
807 /* pragma experimental ABIEncoderV2; */
808 
809 interface IUniswapV2Factory {
810     event PairCreated(
811         address indexed token0,
812         address indexed token1,
813         address pair,
814         uint256
815     );
816 
817     function feeTo() external view returns (address);
818 
819     function feeToSetter() external view returns (address);
820 
821     function getPair(address tokenA, address tokenB)
822         external
823         view
824         returns (address pair);
825 
826     function allPairs(uint256) external view returns (address pair);
827 
828     function allPairsLength() external view returns (uint256);
829 
830     function createPair(address tokenA, address tokenB)
831         external
832         returns (address pair);
833 
834     function setFeeTo(address) external;
835 
836     function setFeeToSetter(address) external;
837 }
838 
839 ////// src/IUniswapV2Pair.sol
840 /* pragma solidity 0.8.10; */
841 /* pragma experimental ABIEncoderV2; */
842 
843 interface IUniswapV2Pair {
844     event Approval(
845         address indexed owner,
846         address indexed spender,
847         uint256 value
848     );
849     event Transfer(address indexed from, address indexed to, uint256 value);
850 
851     function name() external pure returns (string memory);
852 
853     function symbol() external pure returns (string memory);
854 
855     function decimals() external pure returns (uint8);
856 
857     function totalSupply() external view returns (uint256);
858 
859     function balanceOf(address owner) external view returns (uint256);
860 
861     function allowance(address owner, address spender)
862         external
863         view
864         returns (uint256);
865 
866     function approve(address spender, uint256 value) external returns (bool);
867 
868     function transfer(address to, uint256 value) external returns (bool);
869 
870     function transferFrom(
871         address from,
872         address to,
873         uint256 value
874     ) external returns (bool);
875 
876     function DOMAIN_SEPARATOR() external view returns (bytes32);
877 
878     function PERMIT_TYPEHASH() external pure returns (bytes32);
879 
880     function nonces(address owner) external view returns (uint256);
881 
882     function permit(
883         address owner,
884         address spender,
885         uint256 value,
886         uint256 deadline,
887         uint8 v,
888         bytes32 r,
889         bytes32 s
890     ) external;
891 
892     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
893     event Burn(
894         address indexed sender,
895         uint256 amount0,
896         uint256 amount1,
897         address indexed to
898     );
899     event Swap(
900         address indexed sender,
901         uint256 amount0In,
902         uint256 amount1In,
903         uint256 amount0Out,
904         uint256 amount1Out,
905         address indexed to
906     );
907     event Sync(uint112 reserve0, uint112 reserve1);
908 
909     function MINIMUM_LIQUIDITY() external pure returns (uint256);
910 
911     function factory() external view returns (address);
912 
913     function token0() external view returns (address);
914 
915     function token1() external view returns (address);
916 
917     function getReserves()
918         external
919         view
920         returns (
921             uint112 reserve0,
922             uint112 reserve1,
923             uint32 blockTimestampLast
924         );
925 
926     function price0CumulativeLast() external view returns (uint256);
927 
928     function price1CumulativeLast() external view returns (uint256);
929 
930     function kLast() external view returns (uint256);
931 
932     function mint(address to) external returns (uint256 liquidity);
933 
934     function burn(address to)
935         external
936         returns (uint256 amount0, uint256 amount1);
937 
938     function swap(
939         uint256 amount0Out,
940         uint256 amount1Out,
941         address to,
942         bytes calldata data
943     ) external;
944 
945     function skim(address to) external;
946 
947     function sync() external;
948 
949     function initialize(address, address) external;
950 }
951 
952 ////// src/IUniswapV2Router02.sol
953 /* pragma solidity 0.8.10; */
954 /* pragma experimental ABIEncoderV2; */
955 
956 interface IUniswapV2Router02 {
957     function factory() external pure returns (address);
958 
959     function WETH() external pure returns (address);
960 
961     function addLiquidity(
962         address tokenA,
963         address tokenB,
964         uint256 amountADesired,
965         uint256 amountBDesired,
966         uint256 amountAMin,
967         uint256 amountBMin,
968         address to,
969         uint256 deadline
970     )
971         external
972         returns (
973             uint256 amountA,
974             uint256 amountB,
975             uint256 liquidity
976         );
977 
978     function addLiquidityETH(
979         address token,
980         uint256 amountTokenDesired,
981         uint256 amountTokenMin,
982         uint256 amountETHMin,
983         address to,
984         uint256 deadline
985     )
986         external
987         payable
988         returns (
989             uint256 amountToken,
990             uint256 amountETH,
991             uint256 liquidity
992         );
993 
994     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
995         uint256 amountIn,
996         uint256 amountOutMin,
997         address[] calldata path,
998         address to,
999         uint256 deadline
1000     ) external;
1001 
1002     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1003         uint256 amountOutMin,
1004         address[] calldata path,
1005         address to,
1006         uint256 deadline
1007     ) external payable;
1008 
1009     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1010         uint256 amountIn,
1011         uint256 amountOutMin,
1012         address[] calldata path,
1013         address to,
1014         uint256 deadline
1015     ) external;
1016 }
1017 
1018 /* pragma solidity >=0.8.10; */
1019 
1020 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1021 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1022 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1023 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1024 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1025 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1026 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1027 
1028 contract KARAT is ERC20, Ownable {
1029     using SafeMath for uint256;
1030 
1031     IUniswapV2Router02 public immutable uniswapV2Router;
1032     address public immutable uniswapV2Pair;
1033     address public constant deadAddress = address(0xdead);
1034 
1035     bool private swapping;
1036 
1037     address public treasuryWallet;
1038     address public devWallet;
1039 
1040     uint256 public maxTransactionAmount;
1041     uint256 public swapTokensAtAmount;
1042     uint256 public maxWallet;
1043 
1044     uint256 public percentForLPBurn = 25; // 25 = .25%
1045     bool public lpBurnEnabled = true;
1046     uint256 public lpBurnFrequency = 3600 seconds;
1047     uint256 public lastLpBurnTime;
1048 
1049     uint256 public manualBurnFrequency = 30 minutes;
1050     uint256 public lastManualLpBurnTime;
1051 
1052     bool public limitsInEffect = true;
1053     bool public tradingActive = false;
1054     bool public swapEnabled = false;
1055 
1056     // Anti-bot and anti-whale mappings and variables
1057     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1058     bool public transferDelayEnabled = false;
1059 
1060     uint256 public buyTotalFees;
1061     uint256 public buyTreasuryFee;
1062     uint256 public buyLiquidityFee;
1063     uint256 public buyDevFee;
1064 
1065     uint256 public sellTotalFees;
1066     uint256 public sellTreasuryFee;
1067     uint256 public sellLiquidityFee;
1068     uint256 public sellDevFee;
1069 
1070     uint256 public tokensForTreasury;
1071     uint256 public tokensForLiquidity;
1072     uint256 public tokensForDev;
1073 
1074     /******************/
1075 
1076     // exlcude from fees and max transaction amount
1077     mapping(address => bool) private _isExcludedFromFees;
1078     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1079 
1080     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1081     // could be subject to a maximum transfer amount
1082     mapping(address => bool) public automatedMarketMakerPairs;
1083 
1084     event UpdateUniswapV2Router(
1085         address indexed newAddress,
1086         address indexed oldAddress
1087     );
1088 
1089     event ExcludeFromFees(address indexed account, bool isExcluded);
1090 
1091     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1092 
1093     event treasuryWalletUpdated(
1094         address indexed newWallet,
1095         address indexed oldWallet
1096     );
1097 
1098     event devWalletUpdated(
1099         address indexed newWallet,
1100         address indexed oldWallet
1101     );
1102 
1103     event SwapAndLiquify(
1104         uint256 tokensSwapped,
1105         uint256 ethReceived,
1106         uint256 tokensIntoLiquidity
1107     );
1108 
1109     event AutoNukeLP();
1110 
1111     event ManualNukeLP();
1112 
1113     constructor() ERC20("Twenty Four Karat Inu", "$KARAT") {
1114         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1115             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1116         );
1117 
1118         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1119         uniswapV2Router = _uniswapV2Router;
1120 
1121         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1122             .createPair(address(this), _uniswapV2Router.WETH());
1123         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1124         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1125 
1126         uint256 _buyTreasuryFee = 99;
1127         uint256 _buyLiquidityFee = 0;
1128         uint256 _buyDevFee = 0;
1129 
1130         uint256 _sellTreasuryFee = 5;
1131         uint256 _sellLiquidityFee = 5;
1132         uint256 _sellDevFee = 20;
1133 
1134         uint256 totalSupply = 100_000_000 * 1e18;
1135 
1136         maxTransactionAmount = 2_000_000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1137         maxWallet = 2_000_000 * 1e18; // 2% from total supply maxWallet
1138         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1139 
1140         buyTreasuryFee = _buyTreasuryFee;
1141         buyLiquidityFee = _buyLiquidityFee;
1142         buyDevFee = _buyDevFee;
1143         buyTotalFees = buyTreasuryFee + buyLiquidityFee + buyDevFee;
1144 
1145         sellTreasuryFee = _sellTreasuryFee;
1146         sellLiquidityFee = _sellLiquidityFee;
1147         sellDevFee = _sellDevFee;
1148         sellTotalFees = sellTreasuryFee + sellLiquidityFee + sellDevFee;
1149 
1150         treasuryWallet = address(0x1F41Abc95170b9fB5D09db372bFA6258BCb30dB5); // set as treasury wallet
1151         devWallet = address(0x7761DdB875be64efe7C9c966864f388Af5122821); // set as dev wallet
1152 
1153         // exclude from paying fees or having max transaction amount
1154         excludeFromFees(owner(), true);
1155         excludeFromFees(address(this), true);
1156         excludeFromFees(address(0xdead), true);
1157 
1158         excludeFromMaxTransaction(owner(), true);
1159         excludeFromMaxTransaction(address(this), true);
1160         excludeFromMaxTransaction(address(0xdead), true);
1161 
1162         /*
1163             _mint is an internal function in ERC20.sol that is only called here,
1164             and CANNOT be called ever again
1165         */
1166         _mint(msg.sender, totalSupply);
1167     }
1168 
1169     receive() external payable {}
1170 
1171     // once enabled, can never be turned off
1172     function enableTrading() external onlyOwner {
1173         tradingActive = true;
1174         swapEnabled = true;
1175         lastLpBurnTime = block.timestamp;
1176     }
1177 
1178     // remove limits after token is stable
1179     function removeLimits() external onlyOwner returns (bool) {
1180         limitsInEffect = false;
1181         return true;
1182     }
1183 
1184     // disable Transfer delay - cannot be reenabled
1185     function disableTransferDelay() external onlyOwner returns (bool) {
1186         transferDelayEnabled = false;
1187         return true;
1188     }
1189 
1190     // change the minimum amount of tokens to sell from fees
1191     function updateSwapTokensAtAmount(uint256 newAmount)
1192         external
1193         onlyOwner
1194         returns (bool)
1195     {
1196         require(
1197             newAmount >= (totalSupply() * 1) / 100000,
1198             "Swap amount cannot be lower than 0.001% total supply."
1199         );
1200         require(
1201             newAmount <= (totalSupply() * 5) / 1000,
1202             "Swap amount cannot be higher than 0.5% total supply."
1203         );
1204         swapTokensAtAmount = newAmount;
1205         return true;
1206     }
1207 
1208     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1209         require(
1210             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1211             "Cannot set maxTransactionAmount lower than 0.1%"
1212         );
1213         maxTransactionAmount = newNum * (10**18);
1214     }
1215 
1216     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1217         require(
1218             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1219             "Cannot set maxWallet lower than 0.5%"
1220         );
1221         maxWallet = newNum * (10**18);
1222     }
1223 
1224     function excludeFromMaxTransaction(address updAds, bool isEx)
1225         public
1226         onlyOwner
1227     {
1228         _isExcludedMaxTransactionAmount[updAds] = isEx;
1229     }
1230 
1231     // only use to disable contract sales if absolutely necessary (emergency use only)
1232     function updateSwapEnabled(bool enabled) external onlyOwner {
1233         swapEnabled = enabled;
1234     }
1235 
1236     function updateBuyFees(
1237         uint256 _treasuryFee,
1238         uint256 _liquidityFee,
1239         uint256 _devFee
1240     ) external onlyOwner {
1241         buyTreasuryFee = _treasuryFee;
1242         buyLiquidityFee = _liquidityFee;
1243         buyDevFee = _devFee;
1244         buyTotalFees = buyTreasuryFee + buyLiquidityFee + buyDevFee;
1245         require(buyTotalFees <= 99, "Must keep fees at 99% or less");
1246     }
1247 
1248     function updateSellFees(
1249         uint256 _treasuryFee,
1250         uint256 _liquidityFee,
1251         uint256 _devFee
1252     ) external onlyOwner {
1253         sellTreasuryFee = _treasuryFee;
1254         sellLiquidityFee = _liquidityFee;
1255         sellDevFee = _devFee;
1256         sellTotalFees = sellTreasuryFee + sellLiquidityFee + sellDevFee;
1257         require(sellTotalFees <= 99, "Must keep fees at 99% or less");
1258     }
1259 
1260     function excludeFromFees(address account, bool excluded) public onlyOwner {
1261         _isExcludedFromFees[account] = excluded;
1262         emit ExcludeFromFees(account, excluded);
1263     }
1264 
1265     function setAutomatedMarketMakerPair(address pair, bool value)
1266         public
1267         onlyOwner
1268     {
1269         require(
1270             pair != uniswapV2Pair,
1271             "The pair cannot be removed from automatedMarketMakerPairs"
1272         );
1273 
1274         _setAutomatedMarketMakerPair(pair, value);
1275     }
1276 
1277     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1278         automatedMarketMakerPairs[pair] = value;
1279 
1280         emit SetAutomatedMarketMakerPair(pair, value);
1281     }
1282 
1283     function updateTreasuryWallet(address newTreasuryWallet)
1284         external
1285         onlyOwner
1286     {
1287         emit treasuryWalletUpdated(newTreasuryWallet, treasuryWallet);
1288         treasuryWallet = newTreasuryWallet;
1289     }
1290 
1291     function updateDevWallet(address newWallet) external onlyOwner {
1292         emit devWalletUpdated(newWallet, devWallet);
1293         devWallet = newWallet;
1294     }
1295 
1296     function isExcludedFromFees(address account) public view returns (bool) {
1297         return _isExcludedFromFees[account];
1298     }
1299 
1300     event BoughtEarly(address indexed sniper);
1301 
1302     function _transfer(
1303         address from,
1304         address to,
1305         uint256 amount
1306     ) internal override {
1307         require(from != address(0), "ERC20: transfer from the zero address");
1308         require(to != address(0), "ERC20: transfer to the zero address");
1309 
1310         if (amount == 0) {
1311             super._transfer(from, to, 0);
1312             return;
1313         }
1314 
1315         if (limitsInEffect) {
1316             if (
1317                 from != owner() &&
1318                 to != owner() &&
1319                 to != address(0) &&
1320                 to != address(0xdead) &&
1321                 !swapping
1322             ) {
1323                 if (!tradingActive) {
1324                     require(
1325                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1326                         "Trading is not active."
1327                     );
1328                 }
1329 
1330                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1331                 if (transferDelayEnabled) {
1332                     if (
1333                         to != owner() &&
1334                         to != address(uniswapV2Router) &&
1335                         to != address(uniswapV2Pair)
1336                     ) {
1337                         require(
1338                             _holderLastTransferTimestamp[tx.origin] <
1339                                 block.number,
1340                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1341                         );
1342                         _holderLastTransferTimestamp[tx.origin] = block.number;
1343                     }
1344                 }
1345 
1346                 //when buy
1347                 if (
1348                     automatedMarketMakerPairs[from] &&
1349                     !_isExcludedMaxTransactionAmount[to]
1350                 ) {
1351                     require(
1352                         amount <= maxTransactionAmount,
1353                         "Buy transfer amount exceeds the maxTransactionAmount."
1354                     );
1355                     require(
1356                         amount + balanceOf(to) <= maxWallet,
1357                         "Max wallet exceeded"
1358                     );
1359                 }
1360                 //when sell
1361                 else if (
1362                     automatedMarketMakerPairs[to] &&
1363                     !_isExcludedMaxTransactionAmount[from]
1364                 ) {
1365                     require(
1366                         amount <= maxTransactionAmount,
1367                         "Sell transfer amount exceeds the maxTransactionAmount."
1368                     );
1369                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1370                     require(
1371                         amount + balanceOf(to) <= maxWallet,
1372                         "Max wallet exceeded"
1373                     );
1374                 }
1375             }
1376         }
1377 
1378         uint256 contractTokenBalance = balanceOf(address(this));
1379 
1380         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1381 
1382         if (
1383             canSwap &&
1384             swapEnabled &&
1385             !swapping &&
1386             !automatedMarketMakerPairs[from] &&
1387             !_isExcludedFromFees[from] &&
1388             !_isExcludedFromFees[to]
1389         ) {
1390             swapping = true;
1391 
1392             swapBack();
1393 
1394             swapping = false;
1395         }
1396 
1397         if (
1398             !swapping &&
1399             automatedMarketMakerPairs[to] &&
1400             lpBurnEnabled &&
1401             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1402             !_isExcludedFromFees[from]
1403         ) {
1404             autoBurnLiquidityPairTokens();
1405         }
1406 
1407         bool takeFee = !swapping;
1408 
1409         // if any account belongs to _isExcludedFromFee account then remove the fee
1410         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1411             takeFee = false;
1412         }
1413 
1414         uint256 fees = 0;
1415         // only take fees on buys/sells, do not take on wallet transfers
1416         if (takeFee) {
1417             // on sell
1418             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1419                 fees = amount.mul(sellTotalFees).div(100);
1420                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1421                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1422                 tokensForTreasury += (fees * sellTreasuryFee) / sellTotalFees;
1423             }
1424             // on buy
1425             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1426                 fees = amount.mul(buyTotalFees).div(100);
1427                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1428                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1429                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
1430             }
1431 
1432             if (fees > 0) {
1433                 super._transfer(from, address(this), fees);
1434             }
1435 
1436             amount -= fees;
1437         }
1438 
1439         super._transfer(from, to, amount);
1440     }
1441 
1442     function swapTokensForEth(uint256 tokenAmount) private {
1443         // generate the uniswap pair path of token -> weth
1444         address[] memory path = new address[](2);
1445         path[0] = address(this);
1446         path[1] = uniswapV2Router.WETH();
1447 
1448         _approve(address(this), address(uniswapV2Router), tokenAmount);
1449 
1450         // make the swap
1451         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1452             tokenAmount,
1453             0, // accept any amount of ETH
1454             path,
1455             address(this),
1456             block.timestamp
1457         );
1458     }
1459 
1460     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1461         // approve token transfer to cover all possible scenarios
1462         _approve(address(this), address(uniswapV2Router), tokenAmount);
1463 
1464         // add the liquidity
1465         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1466             address(this),
1467             tokenAmount,
1468             0, // slippage is unavoidable
1469             0, // slippage is unavoidable
1470             deadAddress,
1471             block.timestamp
1472         );
1473     }
1474 
1475     function swapBack() private {
1476         uint256 contractBalance = balanceOf(address(this));
1477         uint256 totalTokensToSwap = tokensForLiquidity +
1478             tokensForTreasury +
1479             tokensForDev;
1480         bool success;
1481 
1482         if (contractBalance == 0 || totalTokensToSwap == 0) {
1483             return;
1484         }
1485 
1486         if (contractBalance > swapTokensAtAmount * 20) {
1487             contractBalance = swapTokensAtAmount * 20;
1488         }
1489 
1490         // Halve the amount of liquidity tokens
1491         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1492             totalTokensToSwap /
1493             2;
1494         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1495 
1496         uint256 initialETHBalance = address(this).balance;
1497 
1498         swapTokensForEth(amountToSwapForETH);
1499 
1500         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1501 
1502         uint256 ethForTreasury = ethBalance.mul(tokensForTreasury).div(
1503             totalTokensToSwap
1504         );
1505         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1506 
1507         uint256 ethForLiquidity = ethBalance - ethForTreasury - ethForDev;
1508 
1509         tokensForLiquidity = 0;
1510         tokensForTreasury = 0;
1511         tokensForDev = 0;
1512 
1513         (success, ) = address(devWallet).call{value: ethForDev}("");
1514 
1515         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1516             addLiquidity(liquidityTokens, ethForLiquidity);
1517             emit SwapAndLiquify(
1518                 amountToSwapForETH,
1519                 ethForLiquidity,
1520                 tokensForLiquidity
1521             );
1522         }
1523 
1524         (success, ) = address(treasuryWallet).call{
1525             value: address(this).balance
1526         }("");
1527     }
1528 
1529     function setAutoLPBurnSettings(
1530         uint256 _frequencyInSeconds,
1531         uint256 _percent,
1532         bool _Enabled
1533     ) external onlyOwner {
1534         require(
1535             _frequencyInSeconds >= 600,
1536             "cannot set buyback more often than every 10 minutes"
1537         );
1538         require(
1539             _percent <= 1000 && _percent >= 0,
1540             "Must set auto LP burn percent between 0% and 10%"
1541         );
1542         lpBurnFrequency = _frequencyInSeconds;
1543         percentForLPBurn = _percent;
1544         lpBurnEnabled = _Enabled;
1545     }
1546 
1547     function autoBurnLiquidityPairTokens() internal returns (bool) {
1548         lastLpBurnTime = block.timestamp;
1549 
1550         // get balance of liquidity pair
1551         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1552 
1553         // calculate amount to burn
1554         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1555             10000
1556         );
1557 
1558         // pull tokens from pancakePair liquidity and move to dead address permanently
1559         if (amountToBurn > 0) {
1560             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1561         }
1562 
1563         //sync price since this is not in a swap transaction!
1564         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1565         pair.sync();
1566         emit AutoNukeLP();
1567         return true;
1568     }
1569 
1570     function manualBurnLiquidityPairTokens(uint256 percent)
1571         external
1572         onlyOwner
1573         returns (bool)
1574     {
1575         require(
1576             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1577             "Must wait for cooldown to finish"
1578         );
1579         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1580         lastManualLpBurnTime = block.timestamp;
1581 
1582         // get balance of liquidity pair
1583         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1584 
1585         // calculate amount to burn
1586         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1587 
1588         // pull tokens from pancakePair liquidity and move to dead address permanently
1589         if (amountToBurn > 0) {
1590             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1591         }
1592 
1593         //sync price since this is not in a swap transaction!
1594         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1595         pair.sync();
1596         emit ManualNukeLP();
1597         return true;
1598     }
1599 }