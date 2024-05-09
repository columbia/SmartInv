1 /**
2 What color is your bugatti?
3 https://t.me/bugatticoin
4 */
5 
6 // SPDX-License-Identifier: MIT
7 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
8 pragma experimental ABIEncoderV2;
9 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
10 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
11 /* pragma solidity ^0.8.0; */
12 /**
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
33 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
34 
35 /* pragma solidity ^0.8.0; */
36 
37 /* import "../utils/Context.sol"; */
38 
39 /**
40  * @dev Contract module which provides a basic access control mechanism, where
41  * there is an account (an owner) that can be granted exclusive access to
42  * specific functions.
43  *
44  * By default, the owner account will be the one that deploys the contract. This
45  * can later be changed with {transferOwnership}.
46  *
47  * This module is used through inheritance. It will make available the modifier
48  * `onlyOwner`, which can be applied to your functions to restrict their use to
49  * the owner.
50  */
51 abstract contract Ownable is Context {
52     address private _owner;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     /**
57      * @dev Initializes the contract setting the deployer as the initial owner.
58      */
59     constructor() {
60         _transferOwnership(_msgSender());
61     }
62 
63     /**
64      * @dev Returns the address of the current owner.
65      */
66     function owner() public view virtual returns (address) {
67         return _owner;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(owner() == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     /**
79      * @dev Leaves the contract without owner. It will not be possible to call
80      * `onlyOwner` functions anymore. Can only be called by the current owner.
81      *
82      * NOTE: Renouncing ownership will leave the contract without an owner,
83      * thereby removing any functionality that is only available to the owner.
84      */
85     function renounceOwnership() public virtual onlyOwner {
86         _transferOwnership(address(0));
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         _transferOwnership(newOwner);
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      * Internal function without access restriction.
101      */
102     function _transferOwnership(address newOwner) internal virtual {
103         address oldOwner = _owner;
104         _owner = newOwner;
105         emit OwnershipTransferred(oldOwner, newOwner);
106     }
107 }
108 
109 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
110 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
111 
112 /* pragma solidity ^0.8.0; */
113 
114 /**
115  * @dev Interface of the ERC20 standard as defined in the EIP.
116  */
117 interface IERC20 {
118     /**
119      * @dev Returns the amount of tokens in existence.
120      */
121     function totalSupply() external view returns (uint256);
122 
123     /**
124      * @dev Returns the amount of tokens owned by `account`.
125      */
126     function balanceOf(address account) external view returns (uint256);
127 
128     /**
129      * @dev Moves `amount` tokens from the caller's account to `recipient`.
130      *
131      * Returns a boolean value indicating whether the operation succeeded.
132      *
133      * Emits a {Transfer} event.
134      */
135     function transfer(address recipient, uint256 amount) external returns (bool);
136 
137     /**
138      * @dev Returns the remaining number of tokens that `spender` will be
139      * allowed to spend on behalf of `owner` through {transferFrom}. This is
140      * zero by default.
141      *
142      * This value changes when {approve} or {transferFrom} are called.
143      */
144     function allowance(address owner, address spender) external view returns (uint256);
145 
146     /**
147      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
148      *
149      * Returns a boolean value indicating whether the operation succeeded.
150      *
151      * IMPORTANT: Beware that changing an allowance with this method brings the risk
152      * that someone may use both the old and the new allowance by unfortunate
153      * transaction ordering. One possible solution to mitigate this race
154      * condition is to first reduce the spender's allowance to 0 and set the
155      * desired value afterwards:
156      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157      *
158      * Emits an {Approval} event.
159      */
160     function approve(address spender, uint256 amount) external returns (bool);
161 
162     /**
163      * @dev Moves `amount` tokens from `sender` to `recipient` using the
164      * allowance mechanism. `amount` is then deducted from the caller's
165      * allowance.
166      *
167      * Returns a boolean value indicating whether the operation succeeded.
168      *
169      * Emits a {Transfer} event.
170      */
171     function transferFrom(
172         address sender,
173         address recipient,
174         uint256 amount
175     ) external returns (bool);
176 
177     /**
178      * @dev Emitted when `value` tokens are moved from one account (`from`) to
179      * another (`to`).
180      *
181      * Note that `value` may be zero.
182      */
183     event Transfer(address indexed from, address indexed to, uint256 value);
184 
185     /**
186      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
187      * a call to {approve}. `value` is the new allowance.
188      */
189     event Approval(address indexed owner, address indexed spender, uint256 value);
190 }
191 
192 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
193 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
194 
195 /* pragma solidity ^0.8.0; */
196 
197 /* import "../IERC20.sol"; */
198 
199 /**
200  * @dev Interface for the optional metadata functions from the ERC20 standard.
201  *
202  * _Available since v4.1._
203  */
204 interface IERC20Metadata is IERC20 {
205     /**
206      * @dev Returns the name of the token.
207      */
208     function name() external view returns (string memory);
209 
210     /**
211      * @dev Returns the symbol of the token.
212      */
213     function symbol() external view returns (string memory);
214 
215     /**
216      * @dev Returns the decimals places of the token.
217      */
218     function decimals() external view returns (uint8);
219 }
220 
221 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
222 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
223 
224 /* pragma solidity ^0.8.0; */
225 
226 /* import "./IERC20.sol"; */
227 /* import "./extensions/IERC20Metadata.sol"; */
228 /* import "../../utils/Context.sol"; */
229 
230 /**
231  * @dev Implementation of the {IERC20} interface.
232  *
233  * This implementation is agnostic to the way tokens are created. This means
234  * that a supply mechanism has to be added in a derived contract using {_mint}.
235  * For a generic mechanism see {ERC20PresetMinterPauser}.
236  *
237  * TIP: For a detailed writeup see our guide
238  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
239  * to implement supply mechanisms].
240  *
241  * We have followed general OpenZeppelin Contracts guidelines: functions revert
242  * instead returning `false` on failure. This behavior is nonetheless
243  * conventional and does not conflict with the expectations of ERC20
244  * applications.
245  *
246  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
247  * This allows applications to reconstruct the allowance for all accounts just
248  * by listening to said events. Other implementations of the EIP may not emit
249  * these events, as it isn't required by the specification.
250  *
251  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
252  * functions have been added to mitigate the well-known issues around setting
253  * allowances. See {IERC20-approve}.
254  */
255 contract ERC20 is Context, IERC20, IERC20Metadata {
256     mapping(address => uint256) private _balances;
257 
258     mapping(address => mapping(address => uint256)) private _allowances;
259 
260     uint256 private _totalSupply;
261 
262     string private _name;
263     string private _symbol;
264 
265     /**
266      * @dev Sets the values for {name} and {symbol}.
267      *
268      * The default value of {decimals} is 18. To select a different value for
269      * {decimals} you should overload it.
270      *
271      * All two of these values are immutable: they can only be set once during
272      * construction.
273      */
274     constructor(string memory name_, string memory symbol_) {
275         _name = name_;
276         _symbol = symbol_;
277     }
278 
279     /**
280      * @dev Returns the name of the token.
281      */
282     function name() public view virtual override returns (string memory) {
283         return _name;
284     }
285 
286     /**
287      * @dev Returns the symbol of the token, usually a shorter version of the
288      * name.
289      */
290     function symbol() public view virtual override returns (string memory) {
291         return _symbol;
292     }
293 
294     /**
295      * @dev Returns the number of decimals used to get its user representation.
296      * For example, if `decimals` equals `2`, a balance of `505` tokens should
297      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
298      *
299      * Tokens usually opt for a value of 18, imitating the relationship between
300      * Ether and Wei. This is the value {ERC20} uses, unless this function is
301      * overridden;
302      *
303      * NOTE: This information is only used for _display_ purposes: it in
304      * no way affects any of the arithmetic of the contract, including
305      * {IERC20-balanceOf} and {IERC20-transfer}.
306      */
307     function decimals() public view virtual override returns (uint8) {
308         return 18;
309     }
310 
311     /**
312      * @dev See {IERC20-totalSupply}.
313      */
314     function totalSupply() public view virtual override returns (uint256) {
315         return _totalSupply;
316     }
317 
318     /**
319      * @dev See {IERC20-balanceOf}.
320      */
321     function balanceOf(address account) public view virtual override returns (uint256) {
322         return _balances[account];
323     }
324 
325     /**
326      * @dev See {IERC20-transfer}.
327      *
328      * Requirements:
329      *
330      * - `recipient` cannot be the zero address.
331      * - the caller must have a balance of at least `amount`.
332      */
333     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
334         _transfer(_msgSender(), recipient, amount);
335         return true;
336     }
337 
338     /**
339      * @dev See {IERC20-allowance}.
340      */
341     function allowance(address owner, address spender) public view virtual override returns (uint256) {
342         return _allowances[owner][spender];
343     }
344 
345     /**
346      * @dev See {IERC20-approve}.
347      *
348      * Requirements:
349      *
350      * - `spender` cannot be the zero address.
351      */
352     function approve(address spender, uint256 amount) public virtual override returns (bool) {
353         _approve(_msgSender(), spender, amount);
354         return true;
355     }
356 
357     /**
358      * @dev See {IERC20-transferFrom}.
359      *
360      * Emits an {Approval} event indicating the updated allowance. This is not
361      * required by the EIP. See the note at the beginning of {ERC20}.
362      *
363      * Requirements:
364      *
365      * - `sender` and `recipient` cannot be the zero address.
366      * - `sender` must have a balance of at least `amount`.
367      * - the caller must have allowance for ``sender``'s tokens of at least
368      * `amount`.
369      */
370     function transferFrom(
371         address sender,
372         address recipient,
373         uint256 amount
374     ) public virtual override returns (bool) {
375         _transfer(sender, recipient, amount);
376 
377         uint256 currentAllowance = _allowances[sender][_msgSender()];
378         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
379         unchecked {
380             _approve(sender, _msgSender(), currentAllowance - amount);
381         }
382 
383         return true;
384     }
385 
386     /**
387      * @dev Atomically increases the allowance granted to `spender` by the caller.
388      *
389      * This is an alternative to {approve} that can be used as a mitigation for
390      * problems described in {IERC20-approve}.
391      *
392      * Emits an {Approval} event indicating the updated allowance.
393      *
394      * Requirements:
395      *
396      * - `spender` cannot be the zero address.
397      */
398     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
399         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
400         return true;
401     }
402 
403     /**
404      * @dev Atomically decreases the allowance granted to `spender` by the caller.
405      *
406      * This is an alternative to {approve} that can be used as a mitigation for
407      * problems described in {IERC20-approve}.
408      *
409      * Emits an {Approval} event indicating the updated allowance.
410      *
411      * Requirements:
412      *
413      * - `spender` cannot be the zero address.
414      * - `spender` must have allowance for the caller of at least
415      * `subtractedValue`.
416      */
417     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
418         uint256 currentAllowance = _allowances[_msgSender()][spender];
419         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
420         unchecked {
421             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
422         }
423 
424         return true;
425     }
426 
427     /**
428      * @dev Moves `amount` of tokens from `sender` to `recipient`.
429      *
430      * This internal function is equivalent to {transfer}, and can be used to
431      * e.g. implement automatic token fees, slashing mechanisms, etc.
432      *
433      * Emits a {Transfer} event.
434      *
435      * Requirements:
436      *
437      * - `sender` cannot be the zero address.
438      * - `recipient` cannot be the zero address.
439      * - `sender` must have a balance of at least `amount`.
440      */
441     function _transfer(
442         address sender,
443         address recipient,
444         uint256 amount
445     ) internal virtual {
446         require(sender != address(0), "ERC20: transfer from the zero address");
447         require(recipient != address(0), "ERC20: transfer to the zero address");
448 
449         _beforeTokenTransfer(sender, recipient, amount);
450 
451         uint256 senderBalance = _balances[sender];
452         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
453         unchecked {
454             _balances[sender] = senderBalance - amount;
455         }
456         _balances[recipient] += amount;
457 
458         emit Transfer(sender, recipient, amount);
459 
460         _afterTokenTransfer(sender, recipient, amount);
461     }
462 
463     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
464      * the total supply.
465      *
466      * Emits a {Transfer} event with `from` set to the zero address.
467      *
468      * Requirements:
469      *
470      * - `account` cannot be the zero address.
471      */
472     function _mint(address account, uint256 amount) internal virtual {
473         require(account != address(0), "ERC20: mint to the zero address");
474 
475         _beforeTokenTransfer(address(0), account, amount);
476 
477         _totalSupply += amount;
478         _balances[account] += amount;
479         emit Transfer(address(0), account, amount);
480 
481         _afterTokenTransfer(address(0), account, amount);
482     }
483 
484     /**
485      * @dev Destroys `amount` tokens from `account`, reducing the
486      * total supply.
487      *
488      * Emits a {Transfer} event with `to` set to the zero address.
489      *
490      * Requirements:
491      *
492      * - `account` cannot be the zero address.
493      * - `account` must have at least `amount` tokens.
494      */
495     function _burn(address account, uint256 amount) internal virtual {
496         require(account != address(0), "ERC20: burn from the zero address");
497 
498         _beforeTokenTransfer(account, address(0), amount);
499 
500         uint256 accountBalance = _balances[account];
501         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
502         unchecked {
503             _balances[account] = accountBalance - amount;
504         }
505         _totalSupply -= amount;
506 
507         emit Transfer(account, address(0), amount);
508 
509         _afterTokenTransfer(account, address(0), amount);
510     }
511 
512     /**
513      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
514      *
515      * This internal function is equivalent to `approve`, and can be used to
516      * e.g. set automatic allowances for certain subsystems, etc.
517      *
518      * Emits an {Approval} event.
519      *
520      * Requirements:
521      *
522      * - `owner` cannot be the zero address.
523      * - `spender` cannot be the zero address.
524      */
525     function _approve(
526         address owner,
527         address spender,
528         uint256 amount
529     ) internal virtual {
530         require(owner != address(0), "ERC20: approve from the zero address");
531         require(spender != address(0), "ERC20: approve to the zero address");
532 
533         _allowances[owner][spender] = amount;
534         emit Approval(owner, spender, amount);
535     }
536 
537     /**
538      * @dev Hook that is called before any transfer of tokens. This includes
539      * minting and burning.
540      *
541      * Calling conditions:
542      *
543      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
544      * will be transferred to `to`.
545      * - when `from` is zero, `amount` tokens will be minted for `to`.
546      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
547      * - `from` and `to` are never both zero.
548      *
549      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
550      */
551     function _beforeTokenTransfer(
552         address from,
553         address to,
554         uint256 amount
555     ) internal virtual {}
556 
557     /**
558      * @dev Hook that is called after any transfer of tokens. This includes
559      * minting and burning.
560      *
561      * Calling conditions:
562      *
563      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
564      * has been transferred to `to`.
565      * - when `from` is zero, `amount` tokens have been minted for `to`.
566      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
567      * - `from` and `to` are never both zero.
568      *
569      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
570      */
571     function _afterTokenTransfer(
572         address from,
573         address to,
574         uint256 amount
575     ) internal virtual {}
576 }
577 
578 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
579 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
580 
581 /* pragma solidity ^0.8.0; */
582 
583 // CAUTION
584 // This version of SafeMath should only be used with Solidity 0.8 or later,
585 // because it relies on the compiler's built in overflow checks.
586 
587 /**
588  * @dev Wrappers over Solidity's arithmetic operations.
589  *
590  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
591  * now has built in overflow checking.
592  */
593 library SafeMath {
594     /**
595      * @dev Returns the addition of two unsigned integers, with an overflow flag.
596      *
597      * _Available since v3.4._
598      */
599     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
600         unchecked {
601             uint256 c = a + b;
602             if (c < a) return (false, 0);
603             return (true, c);
604         }
605     }
606 
607     /**
608      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
609      *
610      * _Available since v3.4._
611      */
612     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
613         unchecked {
614             if (b > a) return (false, 0);
615             return (true, a - b);
616         }
617     }
618 
619     /**
620      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
621      *
622      * _Available since v3.4._
623      */
624     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
625         unchecked {
626             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
627             // benefit is lost if 'b' is also tested.
628             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
629             if (a == 0) return (true, 0);
630             uint256 c = a * b;
631             if (c / a != b) return (false, 0);
632             return (true, c);
633         }
634     }
635 
636     /**
637      * @dev Returns the division of two unsigned integers, with a division by zero flag.
638      *
639      * _Available since v3.4._
640      */
641     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
642         unchecked {
643             if (b == 0) return (false, 0);
644             return (true, a / b);
645         }
646     }
647 
648     /**
649      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
650      *
651      * _Available since v3.4._
652      */
653     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
654         unchecked {
655             if (b == 0) return (false, 0);
656             return (true, a % b);
657         }
658     }
659 
660     /**
661      * @dev Returns the addition of two unsigned integers, reverting on
662      * overflow.
663      *
664      * Counterpart to Solidity's `+` operator.
665      *
666      * Requirements:
667      *
668      * - Addition cannot overflow.
669      */
670     function add(uint256 a, uint256 b) internal pure returns (uint256) {
671         return a + b;
672     }
673 
674     /**
675      * @dev Returns the subtraction of two unsigned integers, reverting on
676      * overflow (when the result is negative).
677      *
678      * Counterpart to Solidity's `-` operator.
679      *
680      * Requirements:
681      *
682      * - Subtraction cannot overflow.
683      */
684     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
685         return a - b;
686     }
687 
688     /**
689      * @dev Returns the multiplication of two unsigned integers, reverting on
690      * overflow.
691      *
692      * Counterpart to Solidity's `*` operator.
693      *
694      * Requirements:
695      *
696      * - Multiplication cannot overflow.
697      */
698     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
699         return a * b;
700     }
701 
702     /**
703      * @dev Returns the integer division of two unsigned integers, reverting on
704      * division by zero. The result is rounded towards zero.
705      *
706      * Counterpart to Solidity's `/` operator.
707      *
708      * Requirements:
709      *
710      * - The divisor cannot be zero.
711      */
712     function div(uint256 a, uint256 b) internal pure returns (uint256) {
713         return a / b;
714     }
715 
716     /**
717      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
718      * reverting when dividing by zero.
719      *
720      * Counterpart to Solidity's `%` operator. This function uses a `revert`
721      * opcode (which leaves remaining gas untouched) while Solidity uses an
722      * invalid opcode to revert (consuming all remaining gas).
723      *
724      * Requirements:
725      *
726      * - The divisor cannot be zero.
727      */
728     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
729         return a % b;
730     }
731 
732     /**
733      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
734      * overflow (when the result is negative).
735      *
736      * CAUTION: This function is deprecated because it requires allocating memory for the error
737      * message unnecessarily. For custom revert reasons use {trySub}.
738      *
739      * Counterpart to Solidity's `-` operator.
740      *
741      * Requirements:
742      *
743      * - Subtraction cannot overflow.
744      */
745     function sub(
746         uint256 a,
747         uint256 b,
748         string memory errorMessage
749     ) internal pure returns (uint256) {
750         unchecked {
751             require(b <= a, errorMessage);
752             return a - b;
753         }
754     }
755 
756     /**
757      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
758      * division by zero. The result is rounded towards zero.
759      *
760      * Counterpart to Solidity's `/` operator. Note: this function uses a
761      * `revert` opcode (which leaves remaining gas untouched) while Solidity
762      * uses an invalid opcode to revert (consuming all remaining gas).
763      *
764      * Requirements:
765      *
766      * - The divisor cannot be zero.
767      */
768     function div(
769         uint256 a,
770         uint256 b,
771         string memory errorMessage
772     ) internal pure returns (uint256) {
773         unchecked {
774             require(b > 0, errorMessage);
775             return a / b;
776         }
777     }
778 
779     /**
780      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
781      * reverting with custom message when dividing by zero.
782      *
783      * CAUTION: This function is deprecated because it requires allocating memory for the error
784      * message unnecessarily. For custom revert reasons use {tryMod}.
785      *
786      * Counterpart to Solidity's `%` operator. This function uses a `revert`
787      * opcode (which leaves remaining gas untouched) while Solidity uses an
788      * invalid opcode to revert (consuming all remaining gas).
789      *
790      * Requirements:
791      *
792      * - The divisor cannot be zero.
793      */
794     function mod(
795         uint256 a,
796         uint256 b,
797         string memory errorMessage
798     ) internal pure returns (uint256) {
799         unchecked {
800             require(b > 0, errorMessage);
801             return a % b;
802         }
803     }
804 }
805 
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
839 /* pragma solidity 0.8.10; */
840 /* pragma experimental ABIEncoderV2; */ 
841 
842 interface IUniswapV2Pair {
843     event Approval(
844         address indexed owner,
845         address indexed spender,
846         uint256 value
847     );
848     event Transfer(address indexed from, address indexed to, uint256 value);
849 
850     function name() external pure returns (string memory);
851 
852     function symbol() external pure returns (string memory);
853 
854     function decimals() external pure returns (uint8);
855 
856     function totalSupply() external view returns (uint256);
857 
858     function balanceOf(address owner) external view returns (uint256);
859 
860     function allowance(address owner, address spender)
861         external
862         view
863         returns (uint256);
864 
865     function approve(address spender, uint256 value) external returns (bool);
866 
867     function transfer(address to, uint256 value) external returns (bool);
868 
869     function transferFrom(
870         address from,
871         address to,
872         uint256 value
873     ) external returns (bool);
874 
875     function DOMAIN_SEPARATOR() external view returns (bytes32);
876 
877     function PERMIT_TYPEHASH() external pure returns (bytes32);
878 
879     function nonces(address owner) external view returns (uint256);
880 
881     function permit(
882         address owner,
883         address spender,
884         uint256 value,
885         uint256 deadline,
886         uint8 v,
887         bytes32 r,
888         bytes32 s
889     ) external;
890 
891     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
892     event Burn(
893         address indexed sender,
894         uint256 amount0,
895         uint256 amount1,
896         address indexed to
897     );
898     event Swap(
899         address indexed sender,
900         uint256 amount0In,
901         uint256 amount1In,
902         uint256 amount0Out,
903         uint256 amount1Out,
904         address indexed to
905     );
906     event Sync(uint112 reserve0, uint112 reserve1);
907 
908     function MINIMUM_LIQUIDITY() external pure returns (uint256);
909 
910     function factory() external view returns (address);
911 
912     function token0() external view returns (address);
913 
914     function token1() external view returns (address);
915 
916     function getReserves()
917         external
918         view
919         returns (
920             uint112 reserve0,
921             uint112 reserve1,
922             uint32 blockTimestampLast
923         );
924 
925     function price0CumulativeLast() external view returns (uint256);
926 
927     function price1CumulativeLast() external view returns (uint256);
928 
929     function kLast() external view returns (uint256);
930 
931     function mint(address to) external returns (uint256 liquidity);
932 
933     function burn(address to)
934         external
935         returns (uint256 amount0, uint256 amount1);
936 
937     function swap(
938         uint256 amount0Out,
939         uint256 amount1Out,
940         address to,
941         bytes calldata data
942     ) external;
943 
944     function skim(address to) external;
945 
946     function sync() external;
947 
948     function initialize(address, address) external;
949 }
950 
951 /* pragma solidity 0.8.10; */
952 /* pragma experimental ABIEncoderV2; */
953 
954 interface IUniswapV2Router02 {
955     function factory() external pure returns (address);
956 
957     function WETH() external pure returns (address);
958 
959     function addLiquidity(
960         address tokenA,
961         address tokenB,
962         uint256 amountADesired,
963         uint256 amountBDesired,
964         uint256 amountAMin,
965         uint256 amountBMin,
966         address to,
967         uint256 deadline
968     )
969         external
970         returns (
971             uint256 amountA,
972             uint256 amountB,
973             uint256 liquidity
974         );
975 
976     function addLiquidityETH(
977         address token,
978         uint256 amountTokenDesired,
979         uint256 amountTokenMin,
980         uint256 amountETHMin,
981         address to,
982         uint256 deadline
983     )
984         external
985         payable
986         returns (
987             uint256 amountToken,
988             uint256 amountETH,
989             uint256 liquidity
990         );
991 
992     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
993         uint256 amountIn,
994         uint256 amountOutMin,
995         address[] calldata path,
996         address to,
997         uint256 deadline
998     ) external;
999 
1000     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1001         uint256 amountOutMin,
1002         address[] calldata path,
1003         address to,
1004         uint256 deadline
1005     ) external payable;
1006 
1007     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1008         uint256 amountIn,
1009         uint256 amountOutMin,
1010         address[] calldata path,
1011         address to,
1012         uint256 deadline
1013     ) external;
1014 }
1015 
1016 /* pragma solidity >=0.8.10; */
1017 
1018 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1019 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1020 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1021 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1022 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1023 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1024 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1025 
1026 contract BUGATTI is ERC20, Ownable {
1027     using SafeMath for uint256;
1028 
1029     IUniswapV2Router02 public immutable uniswapV2Router;
1030     address public immutable uniswapV2Pair;
1031     address public constant deadAddress = address(0xdead);
1032 
1033     bool private swapping;
1034 
1035 	address public charityWallet;
1036     address public marketingWallet;
1037     address public devWallet;
1038 
1039     uint256 public maxTransactionAmount;
1040     uint256 public swapTokensAtAmount;
1041     uint256 public maxWallet;
1042 
1043     bool public limitsInEffect = true;
1044     bool public tradingActive = true;
1045     bool public swapEnabled = true;
1046 
1047     // Anti-bot and anti-whale mappings and variables
1048     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1049     bool public transferDelayEnabled = true;
1050 
1051     uint256 public buyTotalFees;
1052 	uint256 public buyCharityFee;
1053     uint256 public buyMarketingFee;
1054     uint256 public buyLiquidityFee;
1055     uint256 public buyDevFee;
1056 
1057     uint256 public sellTotalFees;
1058 	uint256 public sellCharityFee;
1059     uint256 public sellMarketingFee;
1060     uint256 public sellLiquidityFee;
1061     uint256 public sellDevFee;
1062 
1063 	uint256 public tokensForCharity;
1064     uint256 public tokensForMarketing;
1065     uint256 public tokensForLiquidity;
1066     uint256 public tokensForDev;
1067 
1068     /******************/
1069 
1070     // exlcude from fees and max transaction amount
1071     mapping(address => bool) private _isExcludedFromFees;
1072     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1073 
1074     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1075     // could be subject to a maximum transfer amount
1076     mapping(address => bool) public automatedMarketMakerPairs;
1077 
1078     event UpdateUniswapV2Router(
1079         address indexed newAddress,
1080         address indexed oldAddress
1081     );
1082 
1083     event ExcludeFromFees(address indexed account, bool isExcluded);
1084 
1085     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1086 
1087     event SwapAndLiquify(
1088         uint256 tokensSwapped,
1089         uint256 ethReceived,
1090         uint256 tokensIntoLiquidity
1091     );
1092 
1093     constructor() ERC20("Bugatti", "BUGATTI") {
1094         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1095             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1096         );
1097 
1098         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1099         uniswapV2Router = _uniswapV2Router;
1100 
1101         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1102             .createPair(address(this), _uniswapV2Router.WETH());
1103         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1104         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1105 
1106 		uint256 _buyCharityFee = 0;
1107         uint256 _buyMarketingFee = 10;
1108         uint256 _buyLiquidityFee = 0;
1109         uint256 _buyDevFee = 10;
1110 
1111 		uint256 _sellCharityFee = 0;
1112         uint256 _sellMarketingFee = 10;
1113         uint256 _sellLiquidityFee = 0;
1114         uint256 _sellDevFee = 10;
1115 
1116         uint256 totalSupply = 100000000000000 * 1e18;
1117 
1118         maxTransactionAmount = 1000000000000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1119         maxWallet = 1000000000000 * 1e18; // 2% from total supply maxWallet
1120         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1121 
1122 		buyCharityFee = _buyCharityFee;
1123         buyMarketingFee = _buyMarketingFee;
1124         buyLiquidityFee = _buyLiquidityFee;
1125         buyDevFee = _buyDevFee;
1126         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1127 
1128 		sellCharityFee = _sellCharityFee;
1129         sellMarketingFee = _sellMarketingFee;
1130         sellLiquidityFee = _sellLiquidityFee;
1131         sellDevFee = _sellDevFee;
1132         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1133 
1134 		charityWallet = address(0xb50E56A443AF93B32e1D5596f0824F200E871175); // set as charity wallet
1135         marketingWallet = address(0xb50E56A443AF93B32e1D5596f0824F200E871175); // set as marketing wallet
1136         devWallet = address(0xb50E56A443AF93B32e1D5596f0824F200E871175); // set as dev wallet
1137 
1138         // exclude from paying fees or having max transaction amount
1139         excludeFromFees(owner(), true);
1140         excludeFromFees(address(this), true);
1141         excludeFromFees(address(0xdead), true);
1142 
1143         excludeFromMaxTransaction(owner(), true);
1144         excludeFromMaxTransaction(address(this), true);
1145         excludeFromMaxTransaction(address(0xdead), true);
1146 
1147         /*
1148             _mint is an internal function in ERC20.sol that is only called here,
1149             and CANNOT be called ever again
1150         */
1151         _mint(msg.sender, totalSupply);
1152     }
1153 
1154     receive() external payable {}
1155 
1156     // once enabled, can never be turned off
1157     function enableTrading() external onlyOwner {
1158         tradingActive = true;
1159         swapEnabled = true;
1160     }
1161 
1162     // remove limits after token is stable
1163     function removeLimits() external onlyOwner returns (bool) {
1164         limitsInEffect = false;
1165         return true;
1166     }
1167 
1168     // disable Transfer delay - cannot be reenabled
1169     function disableTransferDelay() external onlyOwner returns (bool) {
1170         transferDelayEnabled = false;
1171         return true;
1172     }
1173 
1174     // change the minimum amount of tokens to sell from fees
1175     function updateSwapTokensAtAmount(uint256 newAmount)
1176         external
1177         onlyOwner
1178         returns (bool)
1179     {
1180         require(
1181             newAmount >= (totalSupply() * 1) / 100000,
1182             "Swap amount cannot be lower than 0.001% total supply."
1183         );
1184         require(
1185             newAmount <= (totalSupply() * 5) / 1000,
1186             "Swap amount cannot be higher than 0.5% total supply."
1187         );
1188         swapTokensAtAmount = newAmount;
1189         return true;
1190     }
1191 
1192     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1193         require(
1194             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1195             "Cannot set maxTransactionAmount lower than 0.5%"
1196         );
1197         maxTransactionAmount = newNum * (10**18);
1198     }
1199 
1200     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1201         require(
1202             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1203             "Cannot set maxWallet lower than 0.5%"
1204         );
1205         maxWallet = newNum * (10**18);
1206     }
1207 	
1208     function excludeFromMaxTransaction(address updAds, bool isEx)
1209         public
1210         onlyOwner
1211     {
1212         _isExcludedMaxTransactionAmount[updAds] = isEx;
1213     }
1214 
1215     // only use to disable contract sales if absolutely necessary (emergency use only)
1216     function updateSwapEnabled(bool enabled) external onlyOwner {
1217         swapEnabled = enabled;
1218     }
1219 
1220     function updateBuyFees(
1221 		uint256 _charityFee,
1222         uint256 _marketingFee,
1223         uint256 _liquidityFee,
1224         uint256 _devFee
1225     ) external onlyOwner {
1226 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max BuyFee 10%");
1227 		buyCharityFee = _charityFee;
1228         buyMarketingFee = _marketingFee;
1229         buyLiquidityFee = _liquidityFee;
1230         buyDevFee = _devFee;
1231         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1232      }
1233 
1234     function updateSellFees(
1235 		uint256 _charityFee,
1236         uint256 _marketingFee,
1237         uint256 _liquidityFee,
1238         uint256 _devFee
1239     ) external onlyOwner {
1240 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max SellFee 10%");
1241 		sellCharityFee = _charityFee;
1242         sellMarketingFee = _marketingFee;
1243         sellLiquidityFee = _liquidityFee;
1244         sellDevFee = _devFee;
1245         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1246     }
1247 
1248     function excludeFromFees(address account, bool excluded) public onlyOwner {
1249         _isExcludedFromFees[account] = excluded;
1250         emit ExcludeFromFees(account, excluded);
1251     }
1252 
1253     function setAutomatedMarketMakerPair(address pair, bool value)
1254         public
1255         onlyOwner
1256     {
1257         require(
1258             pair != uniswapV2Pair,
1259             "The pair cannot be removed from automatedMarketMakerPairs"
1260         );
1261 
1262         _setAutomatedMarketMakerPair(pair, value);
1263     }
1264 
1265     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1266         automatedMarketMakerPairs[pair] = value;
1267 
1268         emit SetAutomatedMarketMakerPair(pair, value);
1269     }
1270 
1271     function isExcludedFromFees(address account) public view returns (bool) {
1272         return _isExcludedFromFees[account];
1273     }
1274 
1275     function _transfer(
1276         address from,
1277         address to,
1278         uint256 amount
1279     ) internal override {
1280         require(from != address(0), "ERC20: transfer from the zero address");
1281         require(to != address(0), "ERC20: transfer to the zero address");
1282 
1283         if (amount == 0) {
1284             super._transfer(from, to, 0);
1285             return;
1286         }
1287 
1288         if (limitsInEffect) {
1289             if (
1290                 from != owner() &&
1291                 to != owner() &&
1292                 to != address(0) &&
1293                 to != address(0xdead) &&
1294                 !swapping
1295             ) {
1296                 if (!tradingActive) {
1297                     require(
1298                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1299                         "Trading is not active."
1300                     );
1301                 }
1302 
1303                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1304                 if (transferDelayEnabled) {
1305                     if (
1306                         to != owner() &&
1307                         to != address(uniswapV2Router) &&
1308                         to != address(uniswapV2Pair)
1309                     ) {
1310                         require(
1311                             _holderLastTransferTimestamp[tx.origin] <
1312                                 block.number,
1313                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1314                         );
1315                         _holderLastTransferTimestamp[tx.origin] = block.number;
1316                     }
1317                 }
1318 
1319                 //when buy
1320                 if (
1321                     automatedMarketMakerPairs[from] &&
1322                     !_isExcludedMaxTransactionAmount[to]
1323                 ) {
1324                     require(
1325                         amount <= maxTransactionAmount,
1326                         "Buy transfer amount exceeds the maxTransactionAmount."
1327                     );
1328                     require(
1329                         amount + balanceOf(to) <= maxWallet,
1330                         "Max wallet exceeded"
1331                     );
1332                 }
1333                 //when sell
1334                 else if (
1335                     automatedMarketMakerPairs[to] &&
1336                     !_isExcludedMaxTransactionAmount[from]
1337                 ) {
1338                     require(
1339                         amount <= maxTransactionAmount,
1340                         "Sell transfer amount exceeds the maxTransactionAmount."
1341                     );
1342                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1343                     require(
1344                         amount + balanceOf(to) <= maxWallet,
1345                         "Max wallet exceeded"
1346                     );
1347                 }
1348             }
1349         }
1350 
1351         uint256 contractTokenBalance = balanceOf(address(this));
1352 
1353         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1354 
1355         if (
1356             canSwap &&
1357             swapEnabled &&
1358             !swapping &&
1359             !automatedMarketMakerPairs[from] &&
1360             !_isExcludedFromFees[from] &&
1361             !_isExcludedFromFees[to]
1362         ) {
1363             swapping = true;
1364 
1365             swapBack();
1366 
1367             swapping = false;
1368         }
1369 
1370         bool takeFee = !swapping;
1371 
1372         // if any account belongs to _isExcludedFromFee account then remove the fee
1373         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1374             takeFee = false;
1375         }
1376 
1377         uint256 fees = 0;
1378         // only take fees on buys/sells, do not take on wallet transfers
1379         if (takeFee) {
1380             // on sell
1381             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1382                 fees = amount.mul(sellTotalFees).div(100);
1383 				tokensForCharity += (fees * sellCharityFee) / sellTotalFees;
1384                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1385                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1386                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1387             }
1388             // on buy
1389             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1390                 fees = amount.mul(buyTotalFees).div(100);
1391 				tokensForCharity += (fees * buyCharityFee) / buyTotalFees;
1392                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1393                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1394                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1395             }
1396 
1397             if (fees > 0) {
1398                 super._transfer(from, address(this), fees);
1399             }
1400 
1401             amount -= fees;
1402         }
1403 
1404         super._transfer(from, to, amount);
1405     }
1406 
1407     function swapTokensForEth(uint256 tokenAmount) private {
1408         // generate the uniswap pair path of token -> weth
1409         address[] memory path = new address[](2);
1410         path[0] = address(this);
1411         path[1] = uniswapV2Router.WETH();
1412 
1413         _approve(address(this), address(uniswapV2Router), tokenAmount);
1414 
1415         // make the swap
1416         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1417             tokenAmount,
1418             0, // accept any amount of ETH
1419             path,
1420             address(this),
1421             block.timestamp
1422         );
1423     }
1424 
1425     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1426         // approve token transfer to cover all possible scenarios
1427         _approve(address(this), address(uniswapV2Router), tokenAmount);
1428 
1429         // add the liquidity
1430         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1431             address(this),
1432             tokenAmount,
1433             0, // slippage is unavoidable
1434             0, // slippage is unavoidable
1435             devWallet,
1436             block.timestamp
1437         );
1438     }
1439 
1440     function swapBack() private {
1441         uint256 contractBalance = balanceOf(address(this));
1442         uint256 totalTokensToSwap = tokensForCharity + tokensForLiquidity + tokensForMarketing + tokensForDev;
1443         bool success;
1444 
1445         if (contractBalance == 0 || totalTokensToSwap == 0) {
1446             return;
1447         }
1448 
1449         if (contractBalance > swapTokensAtAmount * 20) {
1450             contractBalance = swapTokensAtAmount * 20;
1451         }
1452 
1453         // Halve the amount of liquidity tokens
1454         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1455         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1456 
1457         uint256 initialETHBalance = address(this).balance;
1458 
1459         swapTokensForEth(amountToSwapForETH);
1460 
1461         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1462 
1463 		uint256 ethForCharity = ethBalance.mul(tokensForCharity).div(totalTokensToSwap);
1464         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1465         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1466 
1467         uint256 ethForLiquidity = ethBalance - ethForCharity - ethForMarketing - ethForDev;
1468 
1469         tokensForLiquidity = 0;
1470 		tokensForCharity = 0;
1471         tokensForMarketing = 0;
1472         tokensForDev = 0;
1473 
1474         (success, ) = address(devWallet).call{value: ethForDev}("");
1475         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1476 
1477 
1478         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1479             addLiquidity(liquidityTokens, ethForLiquidity);
1480             emit SwapAndLiquify(
1481                 amountToSwapForETH,
1482                 ethForLiquidity,
1483                 tokensForLiquidity
1484             );
1485         }
1486 
1487         (success, ) = address(charityWallet).call{value: address(this).balance}("");
1488     }
1489 
1490 }