1 // Verified using https://dapp.tools
2 
3 // SPDX-License-Identifier: MIT
4 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
5 pragma experimental ABIEncoderV2;
6 
7 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
8 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
9 
10 /* pragma solidity ^0.8.0; */
11 
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
806 ////// src/IUniswapV2Factory.sol
807 /* pragma solidity 0.8.10; */
808 /* pragma experimental ABIEncoderV2; */
809 
810 interface IUniswapV2Factory {
811     event PairCreated(
812         address indexed token0,
813         address indexed token1,
814         address pair,
815         uint256
816     );
817 
818     function feeTo() external view returns (address);
819 
820     function feeToSetter() external view returns (address);
821 
822     function getPair(address tokenA, address tokenB)
823         external
824         view
825         returns (address pair);
826 
827     function allPairs(uint256) external view returns (address pair);
828 
829     function allPairsLength() external view returns (uint256);
830 
831     function createPair(address tokenA, address tokenB)
832         external
833         returns (address pair);
834 
835     function setFeeTo(address) external;
836 
837     function setFeeToSetter(address) external;
838 }
839 
840 ////// src/IUniswapV2Pair.sol
841 /* pragma solidity 0.8.10; */
842 /* pragma experimental ABIEncoderV2; */
843 
844 interface IUniswapV2Pair {
845     event Approval(
846         address indexed owner,
847         address indexed spender,
848         uint256 value
849     );
850     event Transfer(address indexed from, address indexed to, uint256 value);
851 
852     function name() external pure returns (string memory);
853 
854     function symbol() external pure returns (string memory);
855 
856     function decimals() external pure returns (uint8);
857 
858     function totalSupply() external view returns (uint256);
859 
860     function balanceOf(address owner) external view returns (uint256);
861 
862     function allowance(address owner, address spender)
863         external
864         view
865         returns (uint256);
866 
867     function approve(address spender, uint256 value) external returns (bool);
868 
869     function transfer(address to, uint256 value) external returns (bool);
870 
871     function transferFrom(
872         address from,
873         address to,
874         uint256 value
875     ) external returns (bool);
876 
877     function DOMAIN_SEPARATOR() external view returns (bytes32);
878 
879     function PERMIT_TYPEHASH() external pure returns (bytes32);
880 
881     function nonces(address owner) external view returns (uint256);
882 
883     function permit(
884         address owner,
885         address spender,
886         uint256 value,
887         uint256 deadline,
888         uint8 v,
889         bytes32 r,
890         bytes32 s
891     ) external;
892 
893     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
894     event Burn(
895         address indexed sender,
896         uint256 amount0,
897         uint256 amount1,
898         address indexed to
899     );
900     event Swap(
901         address indexed sender,
902         uint256 amount0In,
903         uint256 amount1In,
904         uint256 amount0Out,
905         uint256 amount1Out,
906         address indexed to
907     );
908     event Sync(uint112 reserve0, uint112 reserve1);
909 
910     function MINIMUM_LIQUIDITY() external pure returns (uint256);
911 
912     function factory() external view returns (address);
913 
914     function token0() external view returns (address);
915 
916     function token1() external view returns (address);
917 
918     function getReserves()
919         external
920         view
921         returns (
922             uint112 reserve0,
923             uint112 reserve1,
924             uint32 blockTimestampLast
925         );
926 
927     function price0CumulativeLast() external view returns (uint256);
928 
929     function price1CumulativeLast() external view returns (uint256);
930 
931     function kLast() external view returns (uint256);
932 
933     function mint(address to) external returns (uint256 liquidity);
934 
935     function burn(address to)
936         external
937         returns (uint256 amount0, uint256 amount1);
938 
939     function swap(
940         uint256 amount0Out,
941         uint256 amount1Out,
942         address to,
943         bytes calldata data
944     ) external;
945 
946     function skim(address to) external;
947 
948     function sync() external;
949 
950     function initialize(address, address) external;
951 }
952 
953 ////// src/IUniswapV2Router02.sol
954 /* pragma solidity 0.8.10; */
955 /* pragma experimental ABIEncoderV2; */
956 
957 interface IUniswapV2Router02 {
958     function factory() external pure returns (address);
959 
960     function WETH() external pure returns (address);
961 
962     function addLiquidity(
963         address tokenA,
964         address tokenB,
965         uint256 amountADesired,
966         uint256 amountBDesired,
967         uint256 amountAMin,
968         uint256 amountBMin,
969         address to,
970         uint256 deadline
971     )
972         external
973         returns (
974             uint256 amountA,
975             uint256 amountB,
976             uint256 liquidity
977         );
978 
979     function addLiquidityETH(
980         address token,
981         uint256 amountTokenDesired,
982         uint256 amountTokenMin,
983         uint256 amountETHMin,
984         address to,
985         uint256 deadline
986     )
987         external
988         payable
989         returns (
990             uint256 amountToken,
991             uint256 amountETH,
992             uint256 liquidity
993         );
994 
995     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
996         uint256 amountIn,
997         uint256 amountOutMin,
998         address[] calldata path,
999         address to,
1000         uint256 deadline
1001     ) external;
1002 
1003     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1004         uint256 amountOutMin,
1005         address[] calldata path,
1006         address to,
1007         uint256 deadline
1008     ) external payable;
1009 
1010     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1011         uint256 amountIn,
1012         uint256 amountOutMin,
1013         address[] calldata path,
1014         address to,
1015         uint256 deadline
1016     ) external;
1017 }
1018 
1019 /* pragma solidity >=0.8.10; */
1020 
1021 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1022 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1023 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1024 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1025 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1026 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1027 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1028 
1029 contract C500 is ERC20, Ownable {
1030     using SafeMath for uint256;
1031 
1032     IUniswapV2Router02 public immutable uniswapV2Router;
1033     address public immutable uniswapV2Pair;
1034     address public constant deadAddress = address(0xdead);
1035 
1036     bool private swapping;
1037 
1038     address public marketingWallet;
1039     address public devWallet;
1040 
1041     uint256 public maxTransactionAmount;
1042     uint256 public swapTokensAtAmount;
1043     uint256 public maxWallet;
1044 
1045     uint256 public percentForLPBurn = 25; // 25 = .25%
1046     bool public lpBurnEnabled = true;
1047     uint256 public lpBurnFrequency = 3600 seconds;
1048     uint256 public lastLpBurnTime;
1049 
1050     uint256 public manualBurnFrequency = 30 minutes;
1051     uint256 public lastManualLpBurnTime;
1052 
1053     bool public limitsInEffect = true;
1054     bool public tradingActive = false;
1055     bool public swapEnabled = false;
1056 
1057     // Anti-bot and anti-whale mappings and variables
1058     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1059     bool public transferDelayEnabled = true;
1060 
1061     uint256 public buyTotalFees;
1062     uint256 public buyMarketingFee;
1063     uint256 public buyLiquidityFee;
1064     uint256 public buyDevFee;
1065 
1066     uint256 public sellTotalFees;
1067     uint256 public sellMarketingFee;
1068     uint256 public sellLiquidityFee;
1069     uint256 public sellDevFee;
1070 
1071     uint256 public tokensForMarketing;
1072     uint256 public tokensForLiquidity;
1073     uint256 public tokensForDev;
1074 
1075     /******************/
1076 
1077     // exlcude from fees and max transaction amount
1078     mapping(address => bool) private _isExcludedFromFees;
1079     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1080 
1081     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1082     // could be subject to a maximum transfer amount
1083     mapping(address => bool) public automatedMarketMakerPairs;
1084 
1085     event UpdateUniswapV2Router(
1086         address indexed newAddress,
1087         address indexed oldAddress
1088     );
1089 
1090     event ExcludeFromFees(address indexed account, bool isExcluded);
1091 
1092     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1093 
1094     event marketingWalletUpdated(
1095         address indexed newWallet,
1096         address indexed oldWallet
1097     );
1098 
1099     event devWalletUpdated(
1100         address indexed newWallet,
1101         address indexed oldWallet
1102     );
1103 
1104     event SwapAndLiquify(
1105         uint256 tokensSwapped,
1106         uint256 ethReceived,
1107         uint256 tokensIntoLiquidity
1108     );
1109 
1110     event AutoNukeLP();
1111 
1112     event ManualNukeLP();
1113 
1114     constructor() ERC20("Crypto 500", "C500") {
1115         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1116             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1117         );
1118 
1119         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1120         uniswapV2Router = _uniswapV2Router;
1121 
1122         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1123             .createPair(address(this), _uniswapV2Router.WETH());
1124         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1125         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1126 
1127         uint256 _buyMarketingFee = 7;
1128         uint256 _buyLiquidityFee = 3;
1129         uint256 _buyDevFee = 2;
1130 
1131         uint256 _sellMarketingFee = 10;
1132         uint256 _sellLiquidityFee = 3;
1133         uint256 _sellDevFee = 2;
1134 
1135         uint256 totalSupply = 1_000_000_000 * 1e18;
1136 
1137         maxTransactionAmount = 10_000_000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1138         maxWallet = 20_000_000 * 1e18; // 2% from total supply maxWallet
1139         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1140 
1141         buyMarketingFee = _buyMarketingFee;
1142         buyLiquidityFee = _buyLiquidityFee;
1143         buyDevFee = _buyDevFee;
1144         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1145 
1146         sellMarketingFee = _sellMarketingFee;
1147         sellLiquidityFee = _sellLiquidityFee;
1148         sellDevFee = _sellDevFee;
1149         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1150 
1151         marketingWallet = address(0x35256AAf750ffBeB357fD92D594CBD17aC8bb53d); // set as marketing wallet
1152         devWallet = address(0x35256AAf750ffBeB357fD92D594CBD17aC8bb53d); // set as dev wallet
1153 
1154         // exclude from paying fees or having max transaction amount
1155         excludeFromFees(owner(), true);
1156         excludeFromFees(address(this), true);
1157         excludeFromFees(address(0xdead), true);
1158 
1159         excludeFromMaxTransaction(owner(), true);
1160         excludeFromMaxTransaction(address(this), true);
1161         excludeFromMaxTransaction(address(0xdead), true);
1162 
1163         /*
1164             _mint is an internal function in ERC20.sol that is only called here,
1165             and CANNOT be called ever again
1166         */
1167         _mint(msg.sender, totalSupply);
1168     }
1169 
1170     receive() external payable {}
1171 
1172     // once enabled, can never be turned off
1173     function enableTrading() external onlyOwner {
1174         tradingActive = true;
1175         swapEnabled = true;
1176         lastLpBurnTime = block.timestamp;
1177     }
1178 
1179     // remove limits after token is stable
1180     function removeLimits() external onlyOwner returns (bool) {
1181         limitsInEffect = false;
1182         return true;
1183     }
1184 
1185     // disable Transfer delay - cannot be reenabled
1186     function disableTransferDelay() external onlyOwner returns (bool) {
1187         transferDelayEnabled = false;
1188         return true;
1189     }
1190 
1191     // change the minimum amount of tokens to sell from fees
1192     function updateSwapTokensAtAmount(uint256 newAmount)
1193         external
1194         onlyOwner
1195         returns (bool)
1196     {
1197         require(
1198             newAmount >= (totalSupply() * 1) / 100000,
1199             "Swap amount cannot be lower than 0.001% total supply."
1200         );
1201         require(
1202             newAmount <= (totalSupply() * 5) / 1000,
1203             "Swap amount cannot be higher than 0.5% total supply."
1204         );
1205         swapTokensAtAmount = newAmount;
1206         return true;
1207     }
1208 
1209     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1210         require(
1211             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1212             "Cannot set maxTransactionAmount lower than 0.1%"
1213         );
1214         maxTransactionAmount = newNum * (10**18);
1215     }
1216 
1217     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1218         require(
1219             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1220             "Cannot set maxWallet lower than 0.5%"
1221         );
1222         maxWallet = newNum * (10**18);
1223     }
1224 
1225     function excludeFromMaxTransaction(address updAds, bool isEx)
1226         public
1227         onlyOwner
1228     {
1229         _isExcludedMaxTransactionAmount[updAds] = isEx;
1230     }
1231 
1232     // only use to disable contract sales if absolutely necessary (emergency use only)
1233     function updateSwapEnabled(bool enabled) external onlyOwner {
1234         swapEnabled = enabled;
1235     }
1236 
1237     function updateBuyFees(
1238         uint256 _marketingFee,
1239         uint256 _liquidityFee,
1240         uint256 _devFee
1241     ) external onlyOwner {
1242         buyMarketingFee = _marketingFee;
1243         buyLiquidityFee = _liquidityFee;
1244         buyDevFee = _devFee;
1245         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1246         require(buyTotalFees <= 30, "Must keep fees at 20% or less");
1247     }
1248 
1249     function updateSellFees(
1250         uint256 _marketingFee,
1251         uint256 _liquidityFee,
1252         uint256 _devFee
1253     ) external onlyOwner {
1254         sellMarketingFee = _marketingFee;
1255         sellLiquidityFee = _liquidityFee;
1256         sellDevFee = _devFee;
1257         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1258         require(sellTotalFees <= 51, "Must keep fees at 25% or less");
1259     }
1260 
1261     function excludeFromFees(address account, bool excluded) public onlyOwner {
1262         _isExcludedFromFees[account] = excluded;
1263         emit ExcludeFromFees(account, excluded);
1264     }
1265 
1266     function setAutomatedMarketMakerPair(address pair, bool value)
1267         public
1268         onlyOwner
1269     {
1270         require(
1271             pair != uniswapV2Pair,
1272             "The pair cannot be removed from automatedMarketMakerPairs"
1273         );
1274 
1275         _setAutomatedMarketMakerPair(pair, value);
1276     }
1277 
1278     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1279         automatedMarketMakerPairs[pair] = value;
1280 
1281         emit SetAutomatedMarketMakerPair(pair, value);
1282     }
1283 
1284     function updateMarketingWallet(address newMarketingWallet)
1285         external
1286         onlyOwner
1287     {
1288         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1289         marketingWallet = newMarketingWallet;
1290     }
1291 
1292     function updateDevWallet(address newWallet) external onlyOwner {
1293         emit devWalletUpdated(newWallet, devWallet);
1294         devWallet = newWallet;
1295     }
1296 
1297     function isExcludedFromFees(address account) public view returns (bool) {
1298         return _isExcludedFromFees[account];
1299     }
1300 
1301     event BoughtEarly(address indexed sniper);
1302 
1303     function _transfer(
1304         address from,
1305         address to,
1306         uint256 amount
1307     ) internal override {
1308         require(from != address(0), "ERC20: transfer from the zero address");
1309         require(to != address(0), "ERC20: transfer to the zero address");
1310 
1311         if (amount == 0) {
1312             super._transfer(from, to, 0);
1313             return;
1314         }
1315 
1316         if (limitsInEffect) {
1317             if (
1318                 from != owner() &&
1319                 to != owner() &&
1320                 to != address(0) &&
1321                 to != address(0xdead) &&
1322                 !swapping
1323             ) {
1324                 if (!tradingActive) {
1325                     require(
1326                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1327                         "Trading is not active."
1328                     );
1329                 }
1330 
1331                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1332                 if (transferDelayEnabled) {
1333                     if (
1334                         to != owner() &&
1335                         to != address(uniswapV2Router) &&
1336                         to != address(uniswapV2Pair)
1337                     ) {
1338                         require(
1339                             _holderLastTransferTimestamp[tx.origin] <
1340                                 block.number,
1341                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1342                         );
1343                         _holderLastTransferTimestamp[tx.origin] = block.number;
1344                     }
1345                 }
1346 
1347                 //when buy
1348                 if (
1349                     automatedMarketMakerPairs[from] &&
1350                     !_isExcludedMaxTransactionAmount[to]
1351                 ) {
1352                     require(
1353                         amount <= maxTransactionAmount,
1354                         "Buy transfer amount exceeds the maxTransactionAmount."
1355                     );
1356                     require(
1357                         amount + balanceOf(to) <= maxWallet,
1358                         "Max wallet exceeded"
1359                     );
1360                 }
1361                 //when sell
1362                 else if (
1363                     automatedMarketMakerPairs[to] &&
1364                     !_isExcludedMaxTransactionAmount[from]
1365                 ) {
1366                     require(
1367                         amount <= maxTransactionAmount,
1368                         "Sell transfer amount exceeds the maxTransactionAmount."
1369                     );
1370                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1371                     require(
1372                         amount + balanceOf(to) <= maxWallet,
1373                         "Max wallet exceeded"
1374                     );
1375                 }
1376             }
1377         }
1378 
1379         uint256 contractTokenBalance = balanceOf(address(this));
1380 
1381         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1382 
1383         if (
1384             canSwap &&
1385             swapEnabled &&
1386             !swapping &&
1387             !automatedMarketMakerPairs[from] &&
1388             !_isExcludedFromFees[from] &&
1389             !_isExcludedFromFees[to]
1390         ) {
1391             swapping = true;
1392 
1393             swapBack();
1394 
1395             swapping = false;
1396         }
1397 
1398         if (
1399             !swapping &&
1400             automatedMarketMakerPairs[to] &&
1401             lpBurnEnabled &&
1402             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1403             !_isExcludedFromFees[from]
1404         ) {
1405             autoBurnLiquidityPairTokens();
1406         }
1407 
1408         bool takeFee = !swapping;
1409 
1410         // if any account belongs to _isExcludedFromFee account then remove the fee
1411         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1412             takeFee = false;
1413         }
1414 
1415         uint256 fees = 0;
1416         // only take fees on buys/sells, do not take on wallet transfers
1417         if (takeFee) {
1418             // on sell
1419             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1420                 fees = amount.mul(sellTotalFees).div(100);
1421                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1422                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1423                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1424             }
1425             // on buy
1426             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1427                 fees = amount.mul(buyTotalFees).div(100);
1428                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1429                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1430                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1431             }
1432 
1433             if (fees > 0) {
1434                 super._transfer(from, address(this), fees);
1435             }
1436 
1437             amount -= fees;
1438         }
1439 
1440         super._transfer(from, to, amount);
1441     }
1442 
1443     function swapTokensForEth(uint256 tokenAmount) private {
1444         // generate the uniswap pair path of token -> weth
1445         address[] memory path = new address[](2);
1446         path[0] = address(this);
1447         path[1] = uniswapV2Router.WETH();
1448 
1449         _approve(address(this), address(uniswapV2Router), tokenAmount);
1450 
1451         // make the swap
1452         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1453             tokenAmount,
1454             0, // accept any amount of ETH
1455             path,
1456             address(this),
1457             block.timestamp
1458         );
1459     }
1460 
1461     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1462         // approve token transfer to cover all possible scenarios
1463         _approve(address(this), address(uniswapV2Router), tokenAmount);
1464 
1465         // add the liquidity
1466         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1467             address(this),
1468             tokenAmount,
1469             0, // slippage is unavoidable
1470             0, // slippage is unavoidable
1471             deadAddress,
1472             block.timestamp
1473         );
1474     }
1475 
1476     function swapBack() private {
1477         uint256 contractBalance = balanceOf(address(this));
1478         uint256 totalTokensToSwap = tokensForLiquidity +
1479             tokensForMarketing +
1480             tokensForDev;
1481         bool success;
1482 
1483         if (contractBalance == 0 || totalTokensToSwap == 0) {
1484             return;
1485         }
1486 
1487         if (contractBalance > swapTokensAtAmount * 20) {
1488             contractBalance = swapTokensAtAmount * 20;
1489         }
1490 
1491         // Halve the amount of liquidity tokens
1492         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1493             totalTokensToSwap /
1494             2;
1495         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1496 
1497         uint256 initialETHBalance = address(this).balance;
1498 
1499         swapTokensForEth(amountToSwapForETH);
1500 
1501         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1502 
1503         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1504             totalTokensToSwap
1505         );
1506         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1507 
1508         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1509 
1510         tokensForLiquidity = 0;
1511         tokensForMarketing = 0;
1512         tokensForDev = 0;
1513 
1514         (success, ) = address(devWallet).call{value: ethForDev}("");
1515 
1516         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1517             addLiquidity(liquidityTokens, ethForLiquidity);
1518             emit SwapAndLiquify(
1519                 amountToSwapForETH,
1520                 ethForLiquidity,
1521                 tokensForLiquidity
1522             );
1523         }
1524 
1525         (success, ) = address(marketingWallet).call{
1526             value: address(this).balance
1527         }("");
1528     }
1529 
1530     function setAutoLPBurnSettings(
1531         uint256 _frequencyInSeconds,
1532         uint256 _percent,
1533         bool _Enabled
1534     ) external onlyOwner {
1535         require(
1536             _frequencyInSeconds >= 600,
1537             "cannot set buyback more often than every 10 minutes"
1538         );
1539         require(
1540             _percent <= 1000 && _percent >= 0,
1541             "Must set auto LP burn percent between 0% and 10%"
1542         );
1543         lpBurnFrequency = _frequencyInSeconds;
1544         percentForLPBurn = _percent;
1545         lpBurnEnabled = _Enabled;
1546     }
1547 
1548     function autoBurnLiquidityPairTokens() internal returns (bool) {
1549         lastLpBurnTime = block.timestamp;
1550 
1551         // get balance of liquidity pair
1552         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1553 
1554         // calculate amount to burn
1555         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1556             10000
1557         );
1558 
1559         // pull tokens from pancakePair liquidity and move to dead address permanently
1560         if (amountToBurn > 0) {
1561             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1562         }
1563 
1564         //sync price since this is not in a swap transaction!
1565         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1566         pair.sync();
1567         emit AutoNukeLP();
1568         return true;
1569     }
1570 
1571     function manualBurnLiquidityPairTokens(uint256 percent)
1572         external
1573         onlyOwner
1574         returns (bool)
1575     {
1576         require(
1577             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1578             "Must wait for cooldown to finish"
1579         );
1580         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1581         lastManualLpBurnTime = block.timestamp;
1582 
1583         // get balance of liquidity pair
1584         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1585 
1586         // calculate amount to burn
1587         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1588 
1589         // pull tokens from pancakePair liquidity and move to dead address permanently
1590         if (amountToBurn > 0) {
1591             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1592         }
1593 
1594         //sync price since this is not in a swap transaction!
1595         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1596         pair.sync();
1597         emit ManualNukeLP();
1598         return true;
1599     }
1600 }