1 pragma solidity ^0.8.0;
2 
3 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol
4 
5 // CAUTION
6 // This version of SafeMath should only be used with Solidity 0.8 or later,
7 // because it relies on the compiler's built in overflow checks.
8 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations.
11  *
12  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
13  * now has built in overflow checking.
14  */
15 library SafeMath {
16     /**
17      * @dev Returns the addition of two unsigned integers, with an overflow flag.
18      *
19      * _Available since v3.4._
20      */
21     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
22         unchecked {
23             uint256 c = a + b;
24             if (c < a) return (false, 0);
25             return (true, c);
26         }
27     }
28 
29     /**
30      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
31      *
32      * _Available since v3.4._
33      */
34     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         unchecked {
36             if (b > a) return (false, 0);
37             return (true, a - b);
38         }
39     }
40 
41     /**
42      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
43      *
44      * _Available since v3.4._
45      */
46     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
47         unchecked {
48             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49             // benefit is lost if 'b' is also tested.
50             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51             if (a == 0) return (true, 0);
52             uint256 c = a * b;
53             if (c / a != b) return (false, 0);
54             return (true, c);
55         }
56     }
57 
58     /**
59      * @dev Returns the division of two unsigned integers, with a division by zero flag.
60      *
61      * _Available since v3.4._
62      */
63     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
64         unchecked {
65             if (b == 0) return (false, 0);
66             return (true, a / b);
67         }
68     }
69 
70     /**
71      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
72      *
73      * _Available since v3.4._
74      */
75     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
76         unchecked {
77             if (b == 0) return (false, 0);
78             return (true, a % b);
79         }
80     }
81 
82     /**
83      * @dev Returns the addition of two unsigned integers, reverting on
84      * overflow.
85      *
86      * Counterpart to Solidity's `+` operator.
87      *
88      * Requirements:
89      *
90      * - Addition cannot overflow.
91      */
92     function add(uint256 a, uint256 b) internal pure returns (uint256) {
93         return a + b;
94     }
95 
96     /**
97      * @dev Returns the subtraction of two unsigned integers, reverting on
98      * overflow (when the result is negative).
99      *
100      * Counterpart to Solidity's `-` operator.
101      *
102      * Requirements:
103      *
104      * - Subtraction cannot overflow.
105      */
106     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
107         return a - b;
108     }
109 
110     /**
111      * @dev Returns the multiplication of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `*` operator.
115      *
116      * Requirements:
117      *
118      * - Multiplication cannot overflow.
119      */
120     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121         return a * b;
122     }
123 
124     /**
125      * @dev Returns the integer division of two unsigned integers, reverting on
126      * division by zero. The result is rounded towards zero.
127      *
128      * Counterpart to Solidity's `/` operator.
129      *
130      * Requirements:
131      *
132      * - The divisor cannot be zero.
133      */
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         return a / b;
136     }
137 
138     /**
139      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
140      * reverting when dividing by zero.
141      *
142      * Counterpart to Solidity's `%` operator. This function uses a `revert`
143      * opcode (which leaves remaining gas untouched) while Solidity uses an
144      * invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      *
148      * - The divisor cannot be zero.
149      */
150     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
151         return a % b;
152     }
153 
154     /**
155      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
156      * overflow (when the result is negative).
157      *
158      * CAUTION: This function is deprecated because it requires allocating memory for the error
159      * message unnecessarily. For custom revert reasons use {trySub}.
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      *
165      * - Subtraction cannot overflow.
166      */
167     function sub(
168         uint256 a,
169         uint256 b,
170         string memory errorMessage
171     ) internal pure returns (uint256) {
172         unchecked {
173             require(b <= a, errorMessage);
174             return a - b;
175         }
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(
191         uint256 a,
192         uint256 b,
193         string memory errorMessage
194     ) internal pure returns (uint256) {
195         unchecked {
196             require(b > 0, errorMessage);
197             return a / b;
198         }
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * reverting with custom message when dividing by zero.
204      *
205      * CAUTION: This function is deprecated because it requires allocating memory for the error
206      * message unnecessarily. For custom revert reasons use {tryMod}.
207      *
208      * Counterpart to Solidity's `%` operator. This function uses a `revert`
209      * opcode (which leaves remaining gas untouched) while Solidity uses an
210      * invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function mod(
217         uint256 a,
218         uint256 b,
219         string memory errorMessage
220     ) internal pure returns (uint256) {
221         unchecked {
222             require(b > 0, errorMessage);
223             return a % b;
224         }
225     }
226 }
227 
228 /** https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
229  * @dev Interface of the ERC20 standard as defined in the EIP.
230  */
231 interface IERC20 {
232     /**
233      * @dev Emitted when `value` tokens are moved from one account (`from`) to
234      * another (`to`).
235      *
236      * Note that `value` may be zero.
237      */
238     event Transfer(address indexed from, address indexed to, uint256 value);
239 
240     /**
241      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
242      * a call to {approve}. `value` is the new allowance.
243      */
244     event Approval(address indexed owner, address indexed spender, uint256 value);
245 
246     /**
247      * @dev Returns the amount of tokens in existence.
248      */
249     function totalSupply() external view returns (uint256);
250 
251     /**
252      * @dev Returns the amount of tokens owned by `account`.
253      */
254     function balanceOf(address account) external view returns (uint256);
255 
256     /**
257      * @dev Moves `amount` tokens from the caller's account to `to`.
258      *
259      * Returns a boolean value indicating whether the operation succeeded.
260      *
261      * Emits a {Transfer} event.
262      */
263     function transfer(address to, uint256 amount) external returns (bool);
264 
265     /**
266      * @dev Returns the remaining number of tokens that `spender` will be
267      * allowed to spend on behalf of `owner` through {transferFrom}. This is
268      * zero by default.
269      *
270      * This value changes when {approve} or {transferFrom} are called.
271      */
272     function allowance(address owner, address spender) external view returns (uint256);
273 
274     /**
275      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
276      *
277      * Returns a boolean value indicating whether the operation succeeded.
278      *
279      * IMPORTANT: Beware that changing an allowance with this method brings the risk
280      * that someone may use both the old and the new allowance by unfortunate
281      * transaction ordering. One possible solution to mitigate this race
282      * condition is to first reduce the spender's allowance to 0 and set the
283      * desired value afterwards:
284      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
285      *
286      * Emits an {Approval} event.
287      */
288     function approve(address spender, uint256 amount) external returns (bool);
289 
290     /**
291      * @dev Moves `amount` tokens from `from` to `to` using the
292      * allowance mechanism. `amount` is then deducted from the caller's
293      * allowance.
294      *
295      * Returns a boolean value indicating whether the operation succeeded.
296      *
297      * Emits a {Transfer} event.
298      */
299     function transferFrom(
300         address from,
301         address to,
302         uint256 amount
303     ) external returns (bool);
304 }
305 
306 
307 /** https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
308  * @dev Provides information about the current execution context, including the
309  * sender of the transaction and its data. While these are generally available
310  * via msg.sender and msg.data, they should not be accessed in such a direct
311  * manner, since when dealing with meta-transactions the account sending and
312  * paying for execution may not be the actual sender (as far as an application
313  * is concerned).
314  *
315  * This contract is only required for intermediate, library-like contracts.
316  */
317 abstract contract Context {
318     function _msgSender() internal view virtual returns (address) {
319         return msg.sender;
320     }
321 
322     function _msgData() internal view virtual returns (bytes calldata) {
323         return msg.data;
324     }
325 }
326 
327 /** https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol
328  * @dev Interface for the optional metadata functions from the ERC20 standard.
329  *
330  * _Available since v4.1._
331  */
332 interface IERC20Metadata is IERC20 {
333     /**
334      * @dev Returns the name of the token.
335      */
336     function name() external view returns (string memory);
337 
338     /**
339      * @dev Returns the symbol of the token.
340      */
341     function symbol() external view returns (string memory);
342 
343     /**
344      * @dev Returns the decimals places of the token.
345      */
346     function decimals() external view returns (uint8);
347 }
348 
349 /** https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
350  * @dev Implementation of the {IERC20} interface.
351  *
352  * This implementation is agnostic to the way tokens are created. This means
353  * that a supply mechanism has to be added in a derived contract using {_mint}.
354  * For a generic mechanism see {ERC20PresetMinterPauser}.
355  *
356  * TIP: For a detailed writeup see our guide
357  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
358  * to implement supply mechanisms].
359  *
360  * We have followed general OpenZeppelin Contracts guidelines: functions revert
361  * instead returning `false` on failure. This behavior is nonetheless
362  * conventional and does not conflict with the expectations of ERC20
363  * applications.
364  *
365  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
366  * This allows applications to reconstruct the allowance for all accounts just
367  * by listening to said events. Other implementations of the EIP may not emit
368  * these events, as it isn't required by the specification.
369  *
370  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
371  * functions have been added to mitigate the well-known issues around setting
372  * allowances. See {IERC20-approve}.
373  */
374 contract ERC20 is Context, IERC20, IERC20Metadata {
375     mapping(address => uint256) private _balances;
376 
377     mapping(address => mapping(address => uint256)) private _allowances;
378 
379     uint256 private _totalSupply;
380 
381     string private _name;
382     string private _symbol;
383 
384     /**
385      * @dev Sets the values for {name} and {symbol}.
386      *
387      * The default value of {decimals} is 18. To select a different value for
388      * {decimals} you should overload it.
389      *
390      * All two of these values are immutable: they can only be set once during
391      * construction.
392      */
393     constructor(string memory name_, string memory symbol_) {
394         _name = name_;
395         _symbol = symbol_;
396     }
397 
398     /**
399      * @dev Returns the name of the token.
400      */
401     function name() public view virtual override returns (string memory) {
402         return _name;
403     }
404 
405     /**
406      * @dev Returns the symbol of the token, usually a shorter version of the
407      * name.
408      */
409     function symbol() public view virtual override returns (string memory) {
410         return _symbol;
411     }
412 
413     /**
414      * @dev Returns the number of decimals used to get its user representation.
415      * For example, if `decimals` equals `2`, a balance of `505` tokens should
416      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
417      *
418      * Tokens usually opt for a value of 18, imitating the relationship between
419      * Ether and Wei. This is the value {ERC20} uses, unless this function is
420      * overridden;
421      *
422      * NOTE: This information is only used for _display_ purposes: it in
423      * no way affects any of the arithmetic of the contract, including
424      * {IERC20-balanceOf} and {IERC20-transfer}.
425      */
426     function decimals() public view virtual override returns (uint8) {
427         return 18;
428     }
429 
430     /**
431      * @dev See {IERC20-totalSupply}.
432      */
433     function totalSupply() public view virtual override returns (uint256) {
434         return _totalSupply;
435     }
436 
437     /**
438      * @dev See {IERC20-balanceOf}.
439      */
440     function balanceOf(address account) public view virtual override returns (uint256) {
441         return _balances[account];
442     }
443 
444     /**
445      * @dev See {IERC20-transfer}.
446      *
447      * Requirements:
448      *
449      * - `to` cannot be the zero address.
450      * - the caller must have a balance of at least `amount`.
451      */
452     function transfer(address to, uint256 amount) public virtual override returns (bool) {
453         address owner = _msgSender();
454         _transfer(owner, to, amount);
455         return true;
456     }
457 
458     /**
459      * @dev See {IERC20-allowance}.
460      */
461     function allowance(address owner, address spender) public view virtual override returns (uint256) {
462         return _allowances[owner][spender];
463     }
464 
465     /**
466      * @dev See {IERC20-approve}.
467      *
468      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
469      * `transferFrom`. This is semantically equivalent to an infinite approval.
470      *
471      * Requirements:
472      *
473      * - `spender` cannot be the zero address.
474      */
475     function approve(address spender, uint256 amount) public virtual override returns (bool) {
476         address owner = _msgSender();
477         _approve(owner, spender, amount);
478         return true;
479     }
480 
481     /**
482      * @dev See {IERC20-transferFrom}.
483      *
484      * Emits an {Approval} event indicating the updated allowance. This is not
485      * required by the EIP. See the note at the beginning of {ERC20}.
486      *
487      * NOTE: Does not update the allowance if the current allowance
488      * is the maximum `uint256`.
489      *
490      * Requirements:
491      *
492      * - `from` and `to` cannot be the zero address.
493      * - `from` must have a balance of at least `amount`.
494      * - the caller must have allowance for ``from``'s tokens of at least
495      * `amount`.
496      */
497     function transferFrom(
498         address from,
499         address to,
500         uint256 amount
501     ) public virtual override returns (bool) {
502         address spender = _msgSender();
503         _spendAllowance(from, spender, amount);
504         _transfer(from, to, amount);
505         return true;
506     }
507 
508     /**
509      * @dev Atomically increases the allowance granted to `spender` by the caller.
510      *
511      * This is an alternative to {approve} that can be used as a mitigation for
512      * problems described in {IERC20-approve}.
513      *
514      * Emits an {Approval} event indicating the updated allowance.
515      *
516      * Requirements:
517      *
518      * - `spender` cannot be the zero address.
519      */
520     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
521         address owner = _msgSender();
522         _approve(owner, spender, allowance(owner, spender) + addedValue);
523         return true;
524     }
525 
526     /**
527      * @dev Atomically decreases the allowance granted to `spender` by the caller.
528      *
529      * This is an alternative to {approve} that can be used as a mitigation for
530      * problems described in {IERC20-approve}.
531      *
532      * Emits an {Approval} event indicating the updated allowance.
533      *
534      * Requirements:
535      *
536      * - `spender` cannot be the zero address.
537      * - `spender` must have allowance for the caller of at least
538      * `subtractedValue`.
539      */
540     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
541         address owner = _msgSender();
542         uint256 currentAllowance = allowance(owner, spender);
543         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
544         unchecked {
545             _approve(owner, spender, currentAllowance - subtractedValue);
546         }
547 
548         return true;
549     }
550 
551     /**
552      * @dev Moves `amount` of tokens from `sender` to `recipient`.
553      *
554      * This internal function is equivalent to {transfer}, and can be used to
555      * e.g. implement automatic token fees, slashing mechanisms, etc.
556      *
557      * Emits a {Transfer} event.
558      *
559      * Requirements:
560      *
561      * - `from` cannot be the zero address.
562      * - `to` cannot be the zero address.
563      * - `from` must have a balance of at least `amount`.
564      */
565     function _transfer(
566         address from,
567         address to,
568         uint256 amount
569     ) internal virtual {
570         require(from != address(0), "ERC20: transfer from the zero address");
571         require(to != address(0), "ERC20: transfer to the zero address");
572 
573         _beforeTokenTransfer(from, to, amount);
574 
575         uint256 fromBalance = _balances[from];
576         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
577         unchecked {
578             _balances[from] = fromBalance - amount;
579         }
580         _balances[to] += amount;
581 
582         emit Transfer(from, to, amount);
583 
584         _afterTokenTransfer(from, to, amount);
585     }
586 
587     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
588      * the total supply.
589      *
590      * Emits a {Transfer} event with `from` set to the zero address.
591      *
592      * Requirements:
593      *
594      * - `account` cannot be the zero address.
595      */
596     function _mint(address account, uint256 amount) internal virtual {
597         require(account != address(0), "ERC20: mint to the zero address");
598 
599         _beforeTokenTransfer(address(0), account, amount);
600 
601         _totalSupply += amount;
602         _balances[account] += amount;
603         emit Transfer(address(0), account, amount);
604 
605         _afterTokenTransfer(address(0), account, amount);
606     }
607 
608     /**
609      * @dev Destroys `amount` tokens from `account`, reducing the
610      * total supply.
611      *
612      * Emits a {Transfer} event with `to` set to the zero address.
613      *
614      * Requirements:
615      *
616      * - `account` cannot be the zero address.
617      * - `account` must have at least `amount` tokens.
618      */
619     function _burn(address account, uint256 amount) internal virtual {
620         require(account != address(0), "ERC20: burn from the zero address");
621 
622         _beforeTokenTransfer(account, address(0), amount);
623 
624         uint256 accountBalance = _balances[account];
625         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
626         unchecked {
627             _balances[account] = accountBalance - amount;
628         }
629         _totalSupply -= amount;
630 
631         emit Transfer(account, address(0), amount);
632 
633         _afterTokenTransfer(account, address(0), amount);
634     }
635 
636     /**
637      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
638      *
639      * This internal function is equivalent to `approve`, and can be used to
640      * e.g. set automatic allowances for certain subsystems, etc.
641      *
642      * Emits an {Approval} event.
643      *
644      * Requirements:
645      *
646      * - `owner` cannot be the zero address.
647      * - `spender` cannot be the zero address.
648      */
649     function _approve(
650         address owner,
651         address spender,
652         uint256 amount
653     ) internal virtual {
654         require(owner != address(0), "ERC20: approve from the zero address");
655         require(spender != address(0), "ERC20: approve to the zero address");
656 
657         _allowances[owner][spender] = amount;
658         emit Approval(owner, spender, amount);
659     }
660 
661     /**
662      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
663      *
664      * Does not update the allowance amount in case of infinite allowance.
665      * Revert if not enough allowance is available.
666      *
667      * Might emit an {Approval} event.
668      */
669     function _spendAllowance(
670         address owner,
671         address spender,
672         uint256 amount
673     ) internal virtual {
674         uint256 currentAllowance = allowance(owner, spender);
675         if (currentAllowance != type(uint256).max) {
676             require(currentAllowance >= amount, "ERC20: insufficient allowance");
677             unchecked {
678                 _approve(owner, spender, currentAllowance - amount);
679             }
680         }
681     }
682 
683     /**
684      * @dev Hook that is called before any transfer of tokens. This includes
685      * minting and burning.
686      *
687      * Calling conditions:
688      *
689      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
690      * will be transferred to `to`.
691      * - when `from` is zero, `amount` tokens will be minted for `to`.
692      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
693      * - `from` and `to` are never both zero.
694      *
695      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
696      */
697     function _beforeTokenTransfer(
698         address from,
699         address to,
700         uint256 amount
701     ) internal virtual {}
702 
703     /**
704      * @dev Hook that is called after any transfer of tokens. This includes
705      * minting and burning.
706      *
707      * Calling conditions:
708      *
709      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
710      * has been transferred to `to`.
711      * - when `from` is zero, `amount` tokens have been minted for `to`.
712      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
713      * - `from` and `to` are never both zero.
714      *
715      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
716      */
717     function _afterTokenTransfer(
718         address from,
719         address to,
720         uint256 amount
721     ) internal virtual {}
722 }
723 
724 
725 /** https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
726  * @dev Contract module which provides a basic access control mechanism, where
727  * there is an account (an owner) that can be granted exclusive access to
728  * specific functions.
729  *
730  * By default, the owner account will be the one that deploys the contract. This
731  * can later be changed with {transferOwnership}.
732  *
733  * This module is used through inheritance. It will make available the modifier
734  * `onlyOwner`, which can be applied to your functions to restrict their use to
735  * the owner.
736  */
737 abstract contract Ownable is Context {
738     address private _owner;
739 
740     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
741 
742     /**
743      * @dev Initializes the contract setting the deployer as the initial owner.
744      */
745     constructor() {
746         _transferOwnership(_msgSender());
747     }
748 
749     /**
750      * @dev Returns the address of the current owner.
751      */
752     function owner() public view virtual returns (address) {
753         return _owner;
754     }
755 
756     /**
757      * @dev Throws if called by any account other than the owner.
758      */
759     modifier onlyOwner() {
760         require(owner() == _msgSender(), "Ownable: caller is not the owner");
761         _;
762     }
763 
764     /**
765      * @dev Transfers ownership of the contract to a new account (`newOwner`).
766      * Can only be called by the current owner.
767      */
768     function transferOwnership(address newOwner) public virtual onlyOwner {
769         require(newOwner != address(0), "Ownable: new owner is the zero address");
770         _transferOwnership(newOwner);
771     }
772 
773     /**
774      * @dev Transfers ownership of the contract to a new account (`newOwner`).
775      * Internal function without access restriction.
776      */
777     function _transferOwnership(address newOwner) internal virtual {
778         address oldOwner = _owner;
779         _owner = newOwner;
780         emit OwnershipTransferred(oldOwner, newOwner);
781     }
782 }
783 
784 /** https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/ERC20Burnable.sol
785  * @dev Extension of {ERC20} that allows token holders to destroy both their own
786  * tokens and those that they have an allowance for, in a way that can be
787  * recognized off-chain (via event analysis).
788  */
789 abstract contract ERC20Burnable is Ownable, ERC20 {
790     /**
791      * @dev Destroys `amount` tokens from the caller.
792      *
793      * See {ERC20-_burn}.
794      */
795     function burn(uint256 amount) public virtual {
796         _burn(_msgSender(), amount);
797     }
798 
799     /**
800      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
801      * allowance.
802      *
803      * See {ERC20-_burn} and {ERC20-allowance}.
804      *
805      * Requirements:
806      *
807      * - the caller must have allowance for ``accounts``'s tokens of at least
808      * `amount`.
809      */
810     function burnFrom(address account, uint256 amount) public virtual {
811         _spendAllowance(account, _msgSender(), amount);
812         _burn(account, amount);
813     }
814 }
815 
816 /** https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/ERC20Capped.sol
817  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
818  */
819 abstract contract ERC20Capped is ERC20Burnable {
820     uint256 private immutable _cap;
821 
822     /**
823      * @dev Sets the value of the `cap`. This value is immutable, it can only be
824      * set once during construction.
825      */
826     constructor(uint256 cap_) {
827         require(cap_ > 0, "ERC20Capped: cap is 0");
828         _cap = cap_;
829     }
830 
831     /**
832      * @dev Returns the cap on the token's total supply.
833      */
834     function cap() public view virtual returns (uint256) {
835         return _cap;
836     }
837 
838     /**
839      * @dev See {ERC20-_mint}.
840      */
841     function _mint(address account, uint256 amount) internal virtual override {
842         require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
843         super._mint(account, amount);
844     }
845 }
846 
847 contract SAFEToken is ERC20Capped(3E25) {
848 
849     using  SafeMath for uint256;
850     string private constant NAME      = "SAFE(AnWang)";
851     string private constant SYMBOL    = "SAFE";
852 
853     event Eth2Safe_Event(address indexed eth_address, uint256 amount, string safe_address);
854     event Safe2Eth_Event(address indexed eth_address, uint256 amount, string txid);
855     
856     constructor () public ERC20(NAME, SYMBOL) {}
857     
858     //called by owner, _to recieves wSAFE sent by minting
859     function safe2eth(address _to, uint256 _value, string memory _safe_txid) onlyOwner public
860     {
861         require(_value < 1E25, "SAFE: transform too much SAFE");
862         super._mint(_to,_value);
863 		emit Safe2Eth_Event(_to,_value,_safe_txid);
864     }    
865 
866     //users burn wSAFE, and receieve SAFE on SAFE network
867     function eth2safe(uint256 _value, string memory _safe_dst_address) public
868     {
869 		require(_value > 1E14, "SAFE: transform too few SAFE");
870         super.burn(_value);
871         emit Eth2Safe_Event(_msgSender(),_value,_safe_dst_address);
872     }
873 }