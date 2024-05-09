1 /**
2 papaya.garden
3 */
4 // SPDX-License-Identifier: MIT
5 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
6 pragma experimental ABIEncoderV2;
7 
8 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
9 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
10 
11 /* pragma solidity ^0.8.0; */
12 
13 /**
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         return msg.data;
30     }
31 }
32 
33 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
34 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
35 
36 /* pragma solidity ^0.8.0; */
37 
38 /* import "../utils/Context.sol"; */
39 
40 /**
41  * @dev Contract module which provides a basic access control mechanism, where
42  * there is an account (an owner) that can be granted exclusive access to
43  * specific functions.
44  *
45  * By default, the owner account will be the one that deploys the contract. This
46  * can later be changed with {transferOwnership}.
47  *
48  * This module is used through inheritance. It will make available the modifier
49  * `onlyOwner`, which can be applied to your functions to restrict their use to
50  * the owner.
51  */
52 abstract contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     /**
58      * @dev Initializes the contract setting the deployer as the initial owner.
59      */
60     constructor() {
61         _transferOwnership(_msgSender());
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view virtual returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(owner() == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public virtual onlyOwner {
87         _transferOwnership(address(0));
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(newOwner != address(0), "Ownable: new owner is the zero address");
96         _transferOwnership(newOwner);
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      * Internal function without access restriction.
102      */
103     function _transferOwnership(address newOwner) internal virtual {
104         address oldOwner = _owner;
105         _owner = newOwner;
106         emit OwnershipTransferred(oldOwner, newOwner);
107     }
108 }
109 
110 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
111 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
112 
113 /* pragma solidity ^0.8.0; */
114 
115 /**
116  * @dev Interface of the ERC20 standard as defined in the EIP.
117  */
118 interface IERC20 {
119     /**
120      * @dev Returns the amount of tokens in existence.
121      */
122     function totalSupply() external view returns (uint256);
123 
124     /**
125      * @dev Returns the amount of tokens owned by `account`.
126      */
127     function balanceOf(address account) external view returns (uint256);
128 
129     /**
130      * @dev Moves `amount` tokens from the caller's account to `recipient`.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transfer(address recipient, uint256 amount) external returns (bool);
137 
138     /**
139      * @dev Returns the remaining number of tokens that `spender` will be
140      * allowed to spend on behalf of `owner` through {transferFrom}. This is
141      * zero by default.
142      *
143      * This value changes when {approve} or {transferFrom} are called.
144      */
145     function allowance(address owner, address spender) external view returns (uint256);
146 
147     /**
148      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * IMPORTANT: Beware that changing an allowance with this method brings the risk
153      * that someone may use both the old and the new allowance by unfortunate
154      * transaction ordering. One possible solution to mitigate this race
155      * condition is to first reduce the spender's allowance to 0 and set the
156      * desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      *
159      * Emits an {Approval} event.
160      */
161     function approve(address spender, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Moves `amount` tokens from `sender` to `recipient` using the
165      * allowance mechanism. `amount` is then deducted from the caller's
166      * allowance.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * Emits a {Transfer} event.
171      */
172     function transferFrom(
173         address sender,
174         address recipient,
175         uint256 amount
176     ) external returns (bool);
177 
178     /**
179      * @dev Emitted when `value` tokens are moved from one account (`from`) to
180      * another (`to`).
181      *
182      * Note that `value` may be zero.
183      */
184     event Transfer(address indexed from, address indexed to, uint256 value);
185 
186     /**
187      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
188      * a call to {approve}. `value` is the new allowance.
189      */
190     event Approval(address indexed owner, address indexed spender, uint256 value);
191 }
192 
193 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
194 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
195 
196 /* pragma solidity ^0.8.0; */
197 
198 /* import "../IERC20.sol"; */
199 
200 /**
201  * @dev Interface for the optional metadata functions from the ERC20 standard.
202  *
203  * _Available since v4.1._
204  */
205 interface IERC20Metadata is IERC20 {
206     /**
207      * @dev Returns the name of the token.
208      */
209     function name() external view returns (string memory);
210 
211     /**
212      * @dev Returns the symbol of the token.
213      */
214     function symbol() external view returns (string memory);
215 
216     /**
217      * @dev Returns the decimals places of the token.
218      */
219     function decimals() external view returns (uint8);
220 }
221 
222 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
223 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
224 
225 /* pragma solidity ^0.8.0; */
226 
227 /* import "./IERC20.sol"; */
228 /* import "./extensions/IERC20Metadata.sol"; */
229 /* import "../../utils/Context.sol"; */
230 
231 /**
232  * @dev Implementation of the {IERC20} interface.
233  *
234  * This implementation is agnostic to the way tokens are created. This means
235  * that a supply mechanism has to be added in a derived contract using {_mint}.
236  * For a generic mechanism see {ERC20PresetMinterPauser}.
237  *
238  * TIP: For a detailed writeup see our guide
239  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
240  * to implement supply mechanisms].
241  *
242  * We have followed general OpenZeppelin Contracts guidelines: functions revert
243  * instead returning `false` on failure. This behavior is nonetheless
244  * conventional and does not conflict with the expectations of ERC20
245  * applications.
246  *
247  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
248  * This allows applications to reconstruct the allowance for all accounts just
249  * by listening to said events. Other implementations of the EIP may not emit
250  * these events, as it isn't required by the specification.
251  *
252  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
253  * functions have been added to mitigate the well-known issues around setting
254  * allowances. See {IERC20-approve}.
255  */
256 contract ERC20 is Context, IERC20, IERC20Metadata {
257     mapping(address => uint256) private _balances;
258 
259     mapping(address => mapping(address => uint256)) private _allowances;
260 
261     uint256 private _totalSupply;
262 
263     string private _name;
264     string private _symbol;
265 
266     /**
267      * @dev Sets the values for {name} and {symbol}.
268      *
269      * The default value of {decimals} is 18. To select a different value for
270      * {decimals} you should overload it.
271      *
272      * All two of these values are immutable: they can only be set once during
273      * construction.
274      */
275     constructor(string memory name_, string memory symbol_) {
276         _name = name_;
277         _symbol = symbol_;
278     }
279 
280     /**
281      * @dev Returns the name of the token.
282      */
283     function name() public view virtual override returns (string memory) {
284         return _name;
285     }
286 
287     /**
288      * @dev Returns the symbol of the token, usually a shorter version of the
289      * name.
290      */
291     function symbol() public view virtual override returns (string memory) {
292         return _symbol;
293     }
294 
295     /**
296      * @dev Returns the number of decimals used to get its user representation.
297      * For example, if `decimals` equals `2`, a balance of `505` tokens should
298      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
299      *
300      * Tokens usually opt for a value of 18, imitating the relationship between
301      * Ether and Wei. This is the value {ERC20} uses, unless this function is
302      * overridden;
303      *
304      * NOTE: This information is only used for _display_ purposes: it in
305      * no way affects any of the arithmetic of the contract, including
306      * {IERC20-balanceOf} and {IERC20-transfer}.
307      */
308     function decimals() public view virtual override returns (uint8) {
309         return 18;
310     }
311 
312     /**
313      * @dev See {IERC20-totalSupply}.
314      */
315     function totalSupply() public view virtual override returns (uint256) {
316         return _totalSupply;
317     }
318 
319     /**
320      * @dev See {IERC20-balanceOf}.
321      */
322     function balanceOf(address account) public view virtual override returns (uint256) {
323         return _balances[account];
324     }
325 
326     /**
327      * @dev See {IERC20-transfer}.
328      *
329      * Requirements:
330      *
331      * - `recipient` cannot be the zero address.
332      * - the caller must have a balance of at least `amount`.
333      */
334     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
335         _transfer(_msgSender(), recipient, amount);
336         return true;
337     }
338 
339     /**
340      * @dev See {IERC20-allowance}.
341      */
342     function allowance(address owner, address spender) public view virtual override returns (uint256) {
343         return _allowances[owner][spender];
344     }
345 
346     /**
347      * @dev See {IERC20-approve}.
348      *
349      * Requirements:
350      *
351      * - `spender` cannot be the zero address.
352      */
353     function approve(address spender, uint256 amount) public virtual override returns (bool) {
354         _approve(_msgSender(), spender, amount);
355         return true;
356     }
357 
358     /**
359      * @dev See {IERC20-transferFrom}.
360      *
361      * Emits an {Approval} event indicating the updated allowance. This is not
362      * required by the EIP. See the note at the beginning of {ERC20}.
363      *
364      * Requirements:
365      *
366      * - `sender` and `recipient` cannot be the zero address.
367      * - `sender` must have a balance of at least `amount`.
368      * - the caller must have allowance for ``sender``'s tokens of at least
369      * `amount`.
370      */
371     function transferFrom(
372         address sender,
373         address recipient,
374         uint256 amount
375     ) public virtual override returns (bool) {
376         _transfer(sender, recipient, amount);
377 
378         uint256 currentAllowance = _allowances[sender][_msgSender()];
379         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
380         unchecked {
381             _approve(sender, _msgSender(), currentAllowance - amount);
382         }
383 
384         return true;
385     }
386 
387     /**
388      * @dev Atomically increases the allowance granted to `spender` by the caller.
389      *
390      * This is an alternative to {approve} that can be used as a mitigation for
391      * problems described in {IERC20-approve}.
392      *
393      * Emits an {Approval} event indicating the updated allowance.
394      *
395      * Requirements:
396      *
397      * - `spender` cannot be the zero address.
398      */
399     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
400         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
401         return true;
402     }
403 
404     /**
405      * @dev Atomically decreases the allowance granted to `spender` by the caller.
406      *
407      * This is an alternative to {approve} that can be used as a mitigation for
408      * problems described in {IERC20-approve}.
409      *
410      * Emits an {Approval} event indicating the updated allowance.
411      *
412      * Requirements:
413      *
414      * - `spender` cannot be the zero address.
415      * - `spender` must have allowance for the caller of at least
416      * `subtractedValue`.
417      */
418     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
419         uint256 currentAllowance = _allowances[_msgSender()][spender];
420         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
421         unchecked {
422             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
423         }
424 
425         return true;
426     }
427 
428     /**
429      * @dev Moves `amount` of tokens from `sender` to `recipient`.
430      *
431      * This internal function is equivalent to {transfer}, and can be used to
432      * e.g. implement automatic token fees, slashing mechanisms, etc.
433      *
434      * Emits a {Transfer} event.
435      *
436      * Requirements:
437      *
438      * - `sender` cannot be the zero address.
439      * - `recipient` cannot be the zero address.
440      * - `sender` must have a balance of at least `amount`.
441      */
442     function _transfer(
443         address sender,
444         address recipient,
445         uint256 amount
446     ) internal virtual {
447         require(sender != address(0), "ERC20: transfer from the zero address");
448         require(recipient != address(0), "ERC20: transfer to the zero address");
449 
450         _beforeTokenTransfer(sender, recipient, amount);
451 
452         uint256 senderBalance = _balances[sender];
453         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
454         unchecked {
455             _balances[sender] = senderBalance - amount;
456         }
457         _balances[recipient] += amount;
458 
459         emit Transfer(sender, recipient, amount);
460 
461         _afterTokenTransfer(sender, recipient, amount);
462     }
463 
464     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
465      * the total supply.
466      *
467      * Emits a {Transfer} event with `from` set to the zero address.
468      *
469      * Requirements:
470      *
471      * - `account` cannot be the zero address.
472      */
473     function _mint(address account, uint256 amount) internal virtual {
474         require(account != address(0), "ERC20: mint to the zero address");
475 
476         _beforeTokenTransfer(address(0), account, amount);
477 
478         _totalSupply += amount;
479         _balances[account] += amount;
480         emit Transfer(address(0), account, amount);
481 
482         _afterTokenTransfer(address(0), account, amount);
483     }
484 
485     /**
486      * @dev Destroys `amount` tokens from `account`, reducing the
487      * total supply.
488      *
489      * Emits a {Transfer} event with `to` set to the zero address.
490      *
491      * Requirements:
492      *
493      * - `account` cannot be the zero address.
494      * - `account` must have at least `amount` tokens.
495      */
496     function _burn(address account, uint256 amount) internal virtual {
497         require(account != address(0), "ERC20: burn from the zero address");
498 
499         _beforeTokenTransfer(account, address(0), amount);
500 
501         uint256 accountBalance = _balances[account];
502         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
503         unchecked {
504             _balances[account] = accountBalance - amount;
505         }
506         _totalSupply -= amount;
507 
508         emit Transfer(account, address(0), amount);
509 
510         _afterTokenTransfer(account, address(0), amount);
511     }
512 
513     /**
514      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
515      *
516      * This internal function is equivalent to `approve`, and can be used to
517      * e.g. set automatic allowances for certain subsystems, etc.
518      *
519      * Emits an {Approval} event.
520      *
521      * Requirements:
522      *
523      * - `owner` cannot be the zero address.
524      * - `spender` cannot be the zero address.
525      */
526     function _approve(
527         address owner,
528         address spender,
529         uint256 amount
530     ) internal virtual {
531         require(owner != address(0), "ERC20: approve from the zero address");
532         require(spender != address(0), "ERC20: approve to the zero address");
533 
534         _allowances[owner][spender] = amount;
535         emit Approval(owner, spender, amount);
536     }
537 
538     /**
539      * @dev Hook that is called before any transfer of tokens. This includes
540      * minting and burning.
541      *
542      * Calling conditions:
543      *
544      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
545      * will be transferred to `to`.
546      * - when `from` is zero, `amount` tokens will be minted for `to`.
547      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
548      * - `from` and `to` are never both zero.
549      *
550      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
551      */
552     function _beforeTokenTransfer(
553         address from,
554         address to,
555         uint256 amount
556     ) internal virtual {}
557 
558     /**
559      * @dev Hook that is called after any transfer of tokens. This includes
560      * minting and burning.
561      *
562      * Calling conditions:
563      *
564      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
565      * has been transferred to `to`.
566      * - when `from` is zero, `amount` tokens have been minted for `to`.
567      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
568      * - `from` and `to` are never both zero.
569      *
570      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
571      */
572     function _afterTokenTransfer(
573         address from,
574         address to,
575         uint256 amount
576     ) internal virtual {}
577 }
578 
579 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
580 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
581 
582 /* pragma solidity ^0.8.0; */
583 
584 // CAUTION
585 // This version of SafeMath should only be used with Solidity 0.8 or later,
586 // because it relies on the compiler's built in overflow checks.
587 
588 /**
589  * @dev Wrappers over Solidity's arithmetic operations.
590  *
591  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
592  * now has built in overflow checking.
593  */
594 library SafeMath {
595     /**
596      * @dev Returns the addition of two unsigned integers, with an overflow flag.
597      *
598      * _Available since v3.4._
599      */
600     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
601         unchecked {
602             uint256 c = a + b;
603             if (c < a) return (false, 0);
604             return (true, c);
605         }
606     }
607 
608     /**
609      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
610      *
611      * _Available since v3.4._
612      */
613     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
614         unchecked {
615             if (b > a) return (false, 0);
616             return (true, a - b);
617         }
618     }
619 
620     /**
621      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
622      *
623      * _Available since v3.4._
624      */
625     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
626         unchecked {
627             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
628             // benefit is lost if 'b' is also tested.
629             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
630             if (a == 0) return (true, 0);
631             uint256 c = a * b;
632             if (c / a != b) return (false, 0);
633             return (true, c);
634         }
635     }
636 
637     /**
638      * @dev Returns the division of two unsigned integers, with a division by zero flag.
639      *
640      * _Available since v3.4._
641      */
642     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
643         unchecked {
644             if (b == 0) return (false, 0);
645             return (true, a / b);
646         }
647     }
648 
649     /**
650      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
651      *
652      * _Available since v3.4._
653      */
654     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
655         unchecked {
656             if (b == 0) return (false, 0);
657             return (true, a % b);
658         }
659     }
660 
661     /**
662      * @dev Returns the addition of two unsigned integers, reverting on
663      * overflow.
664      *
665      * Counterpart to Solidity's `+` operator.
666      *
667      * Requirements:
668      *
669      * - Addition cannot overflow.
670      */
671     function add(uint256 a, uint256 b) internal pure returns (uint256) {
672         return a + b;
673     }
674 
675     /**
676      * @dev Returns the subtraction of two unsigned integers, reverting on
677      * overflow (when the result is negative).
678      *
679      * Counterpart to Solidity's `-` operator.
680      *
681      * Requirements:
682      *
683      * - Subtraction cannot overflow.
684      */
685     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
686         return a - b;
687     }
688 
689     /**
690      * @dev Returns the multiplication of two unsigned integers, reverting on
691      * overflow.
692      *
693      * Counterpart to Solidity's `*` operator.
694      *
695      * Requirements:
696      *
697      * - Multiplication cannot overflow.
698      */
699     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
700         return a * b;
701     }
702 
703     /**
704      * @dev Returns the integer division of two unsigned integers, reverting on
705      * division by zero. The result is rounded towards zero.
706      *
707      * Counterpart to Solidity's `/` operator.
708      *
709      * Requirements:
710      *
711      * - The divisor cannot be zero.
712      */
713     function div(uint256 a, uint256 b) internal pure returns (uint256) {
714         return a / b;
715     }
716 
717     /**
718      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
719      * reverting when dividing by zero.
720      *
721      * Counterpart to Solidity's `%` operator. This function uses a `revert`
722      * opcode (which leaves remaining gas untouched) while Solidity uses an
723      * invalid opcode to revert (consuming all remaining gas).
724      *
725      * Requirements:
726      *
727      * - The divisor cannot be zero.
728      */
729     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
730         return a % b;
731     }
732 
733     /**
734      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
735      * overflow (when the result is negative).
736      *
737      * CAUTION: This function is deprecated because it requires allocating memory for the error
738      * message unnecessarily. For custom revert reasons use {trySub}.
739      *
740      * Counterpart to Solidity's `-` operator.
741      *
742      * Requirements:
743      *
744      * - Subtraction cannot overflow.
745      */
746     function sub(
747         uint256 a,
748         uint256 b,
749         string memory errorMessage
750     ) internal pure returns (uint256) {
751         unchecked {
752             require(b <= a, errorMessage);
753             return a - b;
754         }
755     }
756 
757     /**
758      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
759      * division by zero. The result is rounded towards zero.
760      *
761      * Counterpart to Solidity's `/` operator. Note: this function uses a
762      * `revert` opcode (which leaves remaining gas untouched) while Solidity
763      * uses an invalid opcode to revert (consuming all remaining gas).
764      *
765      * Requirements:
766      *
767      * - The divisor cannot be zero.
768      */
769     function div(
770         uint256 a,
771         uint256 b,
772         string memory errorMessage
773     ) internal pure returns (uint256) {
774         unchecked {
775             require(b > 0, errorMessage);
776             return a / b;
777         }
778     }
779 
780     /**
781      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
782      * reverting with custom message when dividing by zero.
783      *
784      * CAUTION: This function is deprecated because it requires allocating memory for the error
785      * message unnecessarily. For custom revert reasons use {tryMod}.
786      *
787      * Counterpart to Solidity's `%` operator. This function uses a `revert`
788      * opcode (which leaves remaining gas untouched) while Solidity uses an
789      * invalid opcode to revert (consuming all remaining gas).
790      *
791      * Requirements:
792      *
793      * - The divisor cannot be zero.
794      */
795     function mod(
796         uint256 a,
797         uint256 b,
798         string memory errorMessage
799     ) internal pure returns (uint256) {
800         unchecked {
801             require(b > 0, errorMessage);
802             return a % b;
803         }
804     }
805 }
806 
807 ////// src/IUniswapV2Factory.sol
808 /* pragma solidity 0.8.10; */
809 /* pragma experimental ABIEncoderV2; */
810 
811 interface IUniswapV2Factory {
812     event PairCreated(
813         address indexed token0,
814         address indexed token1,
815         address pair,
816         uint256
817     );
818 
819     function feeTo() external view returns (address);
820 
821     function feeToSetter() external view returns (address);
822 
823     function getPair(address tokenA, address tokenB)
824         external
825         view
826         returns (address pair);
827 
828     function allPairs(uint256) external view returns (address pair);
829 
830     function allPairsLength() external view returns (uint256);
831 
832     function createPair(address tokenA, address tokenB)
833         external
834         returns (address pair);
835 
836     function setFeeTo(address) external;
837 
838     function setFeeToSetter(address) external;
839 }
840 
841 ////// src/IUniswapV2Pair.sol
842 /* pragma solidity 0.8.10; */
843 /* pragma experimental ABIEncoderV2; */
844 
845 interface IUniswapV2Pair {
846     event Approval(
847         address indexed owner,
848         address indexed spender,
849         uint256 value
850     );
851     event Transfer(address indexed from, address indexed to, uint256 value);
852 
853     function name() external pure returns (string memory);
854 
855     function symbol() external pure returns (string memory);
856 
857     function decimals() external pure returns (uint8);
858 
859     function totalSupply() external view returns (uint256);
860 
861     function balanceOf(address owner) external view returns (uint256);
862 
863     function allowance(address owner, address spender)
864         external
865         view
866         returns (uint256);
867 
868     function approve(address spender, uint256 value) external returns (bool);
869 
870     function transfer(address to, uint256 value) external returns (bool);
871 
872     function transferFrom(
873         address from,
874         address to,
875         uint256 value
876     ) external returns (bool);
877 
878     function DOMAIN_SEPARATOR() external view returns (bytes32);
879 
880     function PERMIT_TYPEHASH() external pure returns (bytes32);
881 
882     function nonces(address owner) external view returns (uint256);
883 
884     function permit(
885         address owner,
886         address spender,
887         uint256 value,
888         uint256 deadline,
889         uint8 v,
890         bytes32 r,
891         bytes32 s
892     ) external;
893 
894     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
895     event Burn(
896         address indexed sender,
897         uint256 amount0,
898         uint256 amount1,
899         address indexed to
900     );
901     event Swap(
902         address indexed sender,
903         uint256 amount0In,
904         uint256 amount1In,
905         uint256 amount0Out,
906         uint256 amount1Out,
907         address indexed to
908     );
909     event Sync(uint112 reserve0, uint112 reserve1);
910 
911     function MINIMUM_LIQUIDITY() external pure returns (uint256);
912 
913     function factory() external view returns (address);
914 
915     function token0() external view returns (address);
916 
917     function token1() external view returns (address);
918 
919     function getReserves()
920         external
921         view
922         returns (
923             uint112 reserve0,
924             uint112 reserve1,
925             uint32 blockTimestampLast
926         );
927 
928     function price0CumulativeLast() external view returns (uint256);
929 
930     function price1CumulativeLast() external view returns (uint256);
931 
932     function kLast() external view returns (uint256);
933 
934     function mint(address to) external returns (uint256 liquidity);
935 
936     function burn(address to)
937         external
938         returns (uint256 amount0, uint256 amount1);
939 
940     function swap(
941         uint256 amount0Out,
942         uint256 amount1Out,
943         address to,
944         bytes calldata data
945     ) external;
946 
947     function skim(address to) external;
948 
949     function sync() external;
950 
951     function initialize(address, address) external;
952 }
953 
954 ////// src/IUniswapV2Router02.sol
955 /* pragma solidity 0.8.10; */
956 /* pragma experimental ABIEncoderV2; */
957 
958 interface IUniswapV2Router02 {
959     function factory() external pure returns (address);
960 
961     function WETH() external pure returns (address);
962 
963     function addLiquidity(
964         address tokenA,
965         address tokenB,
966         uint256 amountADesired,
967         uint256 amountBDesired,
968         uint256 amountAMin,
969         uint256 amountBMin,
970         address to,
971         uint256 deadline
972     )
973         external
974         returns (
975             uint256 amountA,
976             uint256 amountB,
977             uint256 liquidity
978         );
979 
980     function addLiquidityETH(
981         address token,
982         uint256 amountTokenDesired,
983         uint256 amountTokenMin,
984         uint256 amountETHMin,
985         address to,
986         uint256 deadline
987     )
988         external
989         payable
990         returns (
991             uint256 amountToken,
992             uint256 amountETH,
993             uint256 liquidity
994         );
995 
996     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
997         uint256 amountIn,
998         uint256 amountOutMin,
999         address[] calldata path,
1000         address to,
1001         uint256 deadline
1002     ) external;
1003 
1004     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1005         uint256 amountOutMin,
1006         address[] calldata path,
1007         address to,
1008         uint256 deadline
1009     ) external payable;
1010 
1011     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1012         uint256 amountIn,
1013         uint256 amountOutMin,
1014         address[] calldata path,
1015         address to,
1016         uint256 deadline
1017     ) external;
1018 }
1019 
1020 /* pragma solidity >=0.8.10; */
1021 
1022 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1023 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1024 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1025 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1026 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1027 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1028 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1029 
1030 contract PsychedelicApe is ERC20, Ownable {
1031     using SafeMath for uint256;
1032 
1033     IUniswapV2Router02 public immutable uniswapV2Router;
1034     address public immutable uniswapV2Pair;
1035     address public constant deadAddress = address(0xdead);
1036 
1037     bool private swapping;
1038 
1039     address public marketingWallet;
1040     address public devWallet;
1041 
1042     uint256 public maxTransactionAmount;
1043     uint256 public swapTokensAtAmount;
1044     uint256 public maxWallet;
1045 
1046     uint256 public percentForLPBurn = 25; // 25 = .25%
1047     bool public lpBurnEnabled = true;
1048     uint256 public lpBurnFrequency = 3600 seconds;
1049     uint256 public lastLpBurnTime;
1050 
1051     uint256 public manualBurnFrequency = 30 minutes;
1052     uint256 public lastManualLpBurnTime;
1053 
1054     bool public limitsInEffect = true;
1055     bool public tradingActive = false;
1056     bool public swapEnabled = false;
1057 
1058     // Anti-bot and anti-whale mappings and variables
1059     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1060     bool public transferDelayEnabled = true;
1061 
1062     uint256 public buyTotalFees;
1063     uint256 public buyMarketingFee;
1064     uint256 public buyLiquidityFee;
1065     uint256 public buyDevFee;
1066 
1067     uint256 public sellTotalFees;
1068     uint256 public sellMarketingFee;
1069     uint256 public sellLiquidityFee;
1070     uint256 public sellDevFee;
1071 
1072     uint256 public tokensForMarketing;
1073     uint256 public tokensForLiquidity;
1074     uint256 public tokensForDev;
1075 
1076     /******************/
1077 
1078     // exlcude from fees and max transaction amount
1079     mapping(address => bool) private _isExcludedFromFees;
1080     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1081 
1082     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1083     // could be subject to a maximum transfer amount
1084     mapping(address => bool) public automatedMarketMakerPairs;
1085 
1086     event UpdateUniswapV2Router(
1087         address indexed newAddress,
1088         address indexed oldAddress
1089     );
1090 
1091     event ExcludeFromFees(address indexed account, bool isExcluded);
1092 
1093     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1094 
1095     event marketingWalletUpdated(
1096         address indexed newWallet,
1097         address indexed oldWallet
1098     );
1099 
1100     event devWalletUpdated(
1101         address indexed newWallet,
1102         address indexed oldWallet
1103     );
1104 
1105     event SwapAndLiquify(
1106         uint256 tokensSwapped,
1107         uint256 ethReceived,
1108         uint256 tokensIntoLiquidity
1109     );
1110 
1111     event AutoNukeLP();
1112 
1113     event ManualNukeLP();
1114 
1115     constructor() ERC20("Psychedelic Papaya Ape", "PPA") {
1116         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1117             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1118         );
1119 
1120         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1121         uniswapV2Router = _uniswapV2Router;
1122 
1123         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1124             .createPair(address(this), _uniswapV2Router.WETH());
1125         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1126         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1127 
1128         uint256 _buyMarketingFee = 10;
1129         uint256 _buyLiquidityFee = 0;
1130         uint256 _buyDevFee = 0;
1131 
1132         uint256 _sellMarketingFee = 20;
1133         uint256 _sellLiquidityFee = 0;
1134         uint256 _sellDevFee = 0;
1135 
1136         uint256 totalSupply = 1_000_000_000 * 1e18;
1137 
1138         maxTransactionAmount = 20_000_000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1139         maxWallet = 20_000_000 * 1e18; // 3% from total supply maxWallet
1140         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1141 
1142         buyMarketingFee = _buyMarketingFee;
1143         buyLiquidityFee = _buyLiquidityFee;
1144         buyDevFee = _buyDevFee;
1145         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1146 
1147         sellMarketingFee = _sellMarketingFee;
1148         sellLiquidityFee = _sellLiquidityFee;
1149         sellDevFee = _sellDevFee;
1150         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1151 
1152         marketingWallet = address(0x7D3Dbf742F890ae2FFc224456332963aB2eb9347); // set as marketing wallet
1153         devWallet = address(0x7D3Dbf742F890ae2FFc224456332963aB2eb9347); // set as dev wallet
1154 
1155         // exclude from paying fees or having max transaction amount
1156         excludeFromFees(owner(), true);
1157         excludeFromFees(address(this), true);
1158         excludeFromFees(address(0xdead), true);
1159 
1160         excludeFromMaxTransaction(owner(), true);
1161         excludeFromMaxTransaction(address(this), true);
1162         excludeFromMaxTransaction(address(0xdead), true);
1163 
1164         /*
1165             _mint is an internal function in ERC20.sol that is only called here,
1166             and CANNOT be called ever again
1167         */
1168         _mint(msg.sender, totalSupply);
1169     }
1170 
1171     receive() external payable {}
1172 
1173     // once enabled, can never be turned off
1174     function enableTrading() external onlyOwner {
1175         tradingActive = true;
1176         swapEnabled = true;
1177         lastLpBurnTime = block.timestamp;
1178     }
1179 
1180     // remove limits after token is stable
1181     function removeLimits() external onlyOwner returns (bool) {
1182         limitsInEffect = false;
1183         return true;
1184     }
1185 
1186     // disable Transfer delay - cannot be reenabled
1187     function disableTransferDelay() external onlyOwner returns (bool) {
1188         transferDelayEnabled = false;
1189         return true;
1190     }
1191 
1192     // change the minimum amount of tokens to sell from fees
1193     function updateSwapTokensAtAmount(uint256 newAmount)
1194         external
1195         onlyOwner
1196         returns (bool)
1197     {
1198         require(
1199             newAmount >= (totalSupply() * 1) / 100000,
1200             "Swap amount cannot be lower than 0.001% total supply."
1201         );
1202         require(
1203             newAmount <= (totalSupply() * 5) / 1000,
1204             "Swap amount cannot be higher than 0.5% total supply."
1205         );
1206         swapTokensAtAmount = newAmount;
1207         return true;
1208     }
1209 
1210     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1211         require(
1212             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1213             "Cannot set maxTransactionAmount lower than 0.1%"
1214         );
1215         maxTransactionAmount = newNum * (10**18);
1216     }
1217 
1218     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1219         require(
1220             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1221             "Cannot set maxWallet lower than 0.1%"
1222         );
1223         maxWallet = newNum * (10**18);
1224     }
1225 
1226     function excludeFromMaxTransaction(address updAds, bool isEx)
1227         public
1228         onlyOwner
1229     {
1230         _isExcludedMaxTransactionAmount[updAds] = isEx;
1231     }
1232 
1233     // only use to disable contract sales if absolutely necessary (emergency use only)
1234     function updateSwapEnabled(bool enabled) external onlyOwner {
1235         swapEnabled = enabled;
1236     }
1237 
1238     function updateBuyFees(
1239         uint256 _marketingFee,
1240         uint256 _liquidityFee,
1241         uint256 _devFee
1242     ) external onlyOwner {
1243         buyMarketingFee = _marketingFee;
1244         buyLiquidityFee = _liquidityFee;
1245         buyDevFee = _devFee;
1246         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1247         require(buyTotalFees <= 40, "Must keep fees at 40% or less");
1248     }
1249 
1250     function updateSellFees(
1251         uint256 _marketingFee,
1252         uint256 _liquidityFee,
1253         uint256 _devFee
1254     ) external onlyOwner {
1255         sellMarketingFee = _marketingFee;
1256         sellLiquidityFee = _liquidityFee;
1257         sellDevFee = _devFee;
1258         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1259         require(sellTotalFees <= 40, "Must keep fees at 40% or less");
1260     }
1261 
1262     function excludeFromFees(address account, bool excluded) public onlyOwner {
1263         _isExcludedFromFees[account] = excluded;
1264         emit ExcludeFromFees(account, excluded);
1265     }
1266 
1267     function setAutomatedMarketMakerPair(address pair, bool value)
1268         public
1269         onlyOwner
1270     {
1271         require(
1272             pair != uniswapV2Pair,
1273             "The pair cannot be removed from automatedMarketMakerPairs"
1274         );
1275 
1276         _setAutomatedMarketMakerPair(pair, value);
1277     }
1278 
1279     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1280         automatedMarketMakerPairs[pair] = value;
1281 
1282         emit SetAutomatedMarketMakerPair(pair, value);
1283     }
1284 
1285     function updateMarketingWallet(address newMarketingWallet)
1286         external
1287         onlyOwner
1288     {
1289         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1290         marketingWallet = newMarketingWallet;
1291     }
1292 
1293     function updateDevWallet(address newWallet) external onlyOwner {
1294         emit devWalletUpdated(newWallet, devWallet);
1295         devWallet = newWallet;
1296     }
1297 
1298     function isExcludedFromFees(address account) public view returns (bool) {
1299         return _isExcludedFromFees[account];
1300     }
1301 
1302     event BoughtEarly(address indexed sniper);
1303 
1304     function _transfer(
1305         address from,
1306         address to,
1307         uint256 amount
1308     ) internal override {
1309         require(from != address(0), "ERC20: transfer from the zero address");
1310         require(to != address(0), "ERC20: transfer to the zero address");
1311 
1312         if (amount == 0) {
1313             super._transfer(from, to, 0);
1314             return;
1315         }
1316 
1317         if (limitsInEffect) {
1318             if (
1319                 from != owner() &&
1320                 to != owner() &&
1321                 to != address(0) &&
1322                 to != address(0xdead) &&
1323                 !swapping
1324             ) {
1325                 if (!tradingActive) {
1326                     require(
1327                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1328                         "Trading is not active."
1329                     );
1330                 }
1331 
1332                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1333                 if (transferDelayEnabled) {
1334                     if (
1335                         to != owner() &&
1336                         to != address(uniswapV2Router) &&
1337                         to != address(uniswapV2Pair)
1338                     ) {
1339                         require(
1340                             _holderLastTransferTimestamp[tx.origin] <
1341                                 block.number,
1342                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1343                         );
1344                         _holderLastTransferTimestamp[tx.origin] = block.number;
1345                     }
1346                 }
1347 
1348                 //when buy
1349                 if (
1350                     automatedMarketMakerPairs[from] &&
1351                     !_isExcludedMaxTransactionAmount[to]
1352                 ) {
1353                     require(
1354                         amount <= maxTransactionAmount,
1355                         "Buy transfer amount exceeds the maxTransactionAmount."
1356                     );
1357                     require(
1358                         amount + balanceOf(to) <= maxWallet,
1359                         "Max wallet exceeded"
1360                     );
1361                 }
1362                 //when sell
1363                 else if (
1364                     automatedMarketMakerPairs[to] &&
1365                     !_isExcludedMaxTransactionAmount[from]
1366                 ) {
1367                     require(
1368                         amount <= maxTransactionAmount,
1369                         "Sell transfer amount exceeds the maxTransactionAmount."
1370                     );
1371                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1372                     require(
1373                         amount + balanceOf(to) <= maxWallet,
1374                         "Max wallet exceeded"
1375                     );
1376                 }
1377             }
1378         }
1379 
1380         uint256 contractTokenBalance = balanceOf(address(this));
1381 
1382         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1383 
1384         if (
1385             canSwap &&
1386             swapEnabled &&
1387             !swapping &&
1388             !automatedMarketMakerPairs[from] &&
1389             !_isExcludedFromFees[from] &&
1390             !_isExcludedFromFees[to]
1391         ) {
1392             swapping = true;
1393 
1394             swapBack();
1395 
1396             swapping = false;
1397         }
1398 
1399         if (
1400             !swapping &&
1401             automatedMarketMakerPairs[to] &&
1402             lpBurnEnabled &&
1403             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1404             !_isExcludedFromFees[from]
1405         ) {
1406             autoBurnLiquidityPairTokens();
1407         }
1408 
1409         bool takeFee = !swapping;
1410 
1411         // if any account belongs to _isExcludedFromFee account then remove the fee
1412         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1413             takeFee = false;
1414         }
1415 
1416         uint256 fees = 0;
1417         // only take fees on buys/sells, do not take on wallet transfers
1418         if (takeFee) {
1419             // on sell
1420             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1421                 fees = amount.mul(sellTotalFees).div(100);
1422                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1423                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1424                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1425             }
1426             // on buy
1427             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1428                 fees = amount.mul(buyTotalFees).div(100);
1429                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1430                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1431                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1432             }
1433 
1434             if (fees > 0) {
1435                 super._transfer(from, address(this), fees);
1436             }
1437 
1438             amount -= fees;
1439         }
1440 
1441         super._transfer(from, to, amount);
1442     }
1443 
1444     function swapTokensForEth(uint256 tokenAmount) private {
1445         // generate the uniswap pair path of token -> weth
1446         address[] memory path = new address[](2);
1447         path[0] = address(this);
1448         path[1] = uniswapV2Router.WETH();
1449 
1450         _approve(address(this), address(uniswapV2Router), tokenAmount);
1451 
1452         // make the swap
1453         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1454             tokenAmount,
1455             0, // accept any amount of ETH
1456             path,
1457             address(this),
1458             block.timestamp
1459         );
1460     }
1461 
1462     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1463         // approve token transfer to cover all possible scenarios
1464         _approve(address(this), address(uniswapV2Router), tokenAmount);
1465 
1466         // add the liquidity
1467         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1468             address(this),
1469             tokenAmount,
1470             0, // slippage is unavoidable
1471             0, // slippage is unavoidable
1472             deadAddress,
1473             block.timestamp
1474         );
1475     }
1476 
1477     function swapBack() private {
1478         uint256 contractBalance = balanceOf(address(this));
1479         uint256 totalTokensToSwap = tokensForLiquidity +
1480             tokensForMarketing +
1481             tokensForDev;
1482         bool success;
1483 
1484         if (contractBalance == 0 || totalTokensToSwap == 0) {
1485             return;
1486         }
1487 
1488         if (contractBalance > swapTokensAtAmount * 20) {
1489             contractBalance = swapTokensAtAmount * 20;
1490         }
1491 
1492         // Halve the amount of liquidity tokens
1493         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1494             totalTokensToSwap /
1495             2;
1496         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1497 
1498         uint256 initialETHBalance = address(this).balance;
1499 
1500         swapTokensForEth(amountToSwapForETH);
1501 
1502         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1503 
1504         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1505             totalTokensToSwap
1506         );
1507         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1508 
1509         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1510 
1511         tokensForLiquidity = 0;
1512         tokensForMarketing = 0;
1513         tokensForDev = 0;
1514 
1515         (success, ) = address(devWallet).call{value: ethForDev}("");
1516 
1517         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1518             addLiquidity(liquidityTokens, ethForLiquidity);
1519             emit SwapAndLiquify(
1520                 amountToSwapForETH,
1521                 ethForLiquidity,
1522                 tokensForLiquidity
1523             );
1524         }
1525 
1526         (success, ) = address(marketingWallet).call{
1527             value: address(this).balance
1528         }("");
1529     }
1530 
1531     function setAutoLPBurnSettings(
1532         uint256 _frequencyInSeconds,
1533         uint256 _percent,
1534         bool _Enabled
1535     ) external onlyOwner {
1536         require(
1537             _frequencyInSeconds >= 600,
1538             "cannot set buyback more often than every 10 minutes"
1539         );
1540         require(
1541             _percent <= 1000 && _percent >= 0,
1542             "Must set auto LP burn percent between 0% and 10%"
1543         );
1544         lpBurnFrequency = _frequencyInSeconds;
1545         percentForLPBurn = _percent;
1546         lpBurnEnabled = _Enabled;
1547     }
1548 
1549     function autoBurnLiquidityPairTokens() internal returns (bool) {
1550         lastLpBurnTime = block.timestamp;
1551 
1552         // get balance of liquidity pair
1553         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1554 
1555         // calculate amount to burn
1556         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1557             10000
1558         );
1559 
1560         // pull tokens from pancakePair liquidity and move to dead address permanently
1561         if (amountToBurn > 0) {
1562             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1563         }
1564 
1565         //sync price since this is not in a swap transaction!
1566         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1567         pair.sync();
1568         emit AutoNukeLP();
1569         return true;
1570     }
1571 
1572     function manualBurnLiquidityPairTokens(uint256 percent)
1573         external
1574         onlyOwner
1575         returns (bool)
1576     {
1577         require(
1578             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1579             "Must wait for cooldown to finish"
1580         );
1581         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1582         lastManualLpBurnTime = block.timestamp;
1583 
1584         // get balance of liquidity pair
1585         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1586 
1587         // calculate amount to burn
1588         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1589 
1590         // pull tokens from pancakePair liquidity and move to dead address permanently
1591         if (amountToBurn > 0) {
1592             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1593         }
1594 
1595         //sync price since this is not in a swap transaction!
1596         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1597         pair.sync();
1598         emit ManualNukeLP();
1599         return true;
1600     }
1601 }