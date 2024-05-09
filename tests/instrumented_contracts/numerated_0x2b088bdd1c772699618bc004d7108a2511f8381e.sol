1 /**
2 https://jimmycoineth.com/
3 https://t.me/JIMMYCOINETH
4 https://twitter.com/JIMMYCOINETH
5 */
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
9 pragma experimental ABIEncoderV2;
10 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
11 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
12 /* pragma solidity ^0.8.0; */
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
952 /* pragma solidity 0.8.10; */
953 /* pragma experimental ABIEncoderV2; */
954 
955 interface IUniswapV2Router02 {
956     function factory() external pure returns (address);
957 
958     function WETH() external pure returns (address);
959 
960     function addLiquidity(
961         address tokenA,
962         address tokenB,
963         uint256 amountADesired,
964         uint256 amountBDesired,
965         uint256 amountAMin,
966         uint256 amountBMin,
967         address to,
968         uint256 deadline
969     )
970         external
971         returns (
972             uint256 amountA,
973             uint256 amountB,
974             uint256 liquidity
975         );
976 
977     function addLiquidityETH(
978         address token,
979         uint256 amountTokenDesired,
980         uint256 amountTokenMin,
981         uint256 amountETHMin,
982         address to,
983         uint256 deadline
984     )
985         external
986         payable
987         returns (
988             uint256 amountToken,
989             uint256 amountETH,
990             uint256 liquidity
991         );
992 
993     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
994         uint256 amountIn,
995         uint256 amountOutMin,
996         address[] calldata path,
997         address to,
998         uint256 deadline
999     ) external;
1000 
1001     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1002         uint256 amountOutMin,
1003         address[] calldata path,
1004         address to,
1005         uint256 deadline
1006     ) external payable;
1007 
1008     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1009         uint256 amountIn,
1010         uint256 amountOutMin,
1011         address[] calldata path,
1012         address to,
1013         uint256 deadline
1014     ) external;
1015 }
1016 
1017 /* pragma solidity >=0.8.10; */
1018 
1019 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1020 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1021 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1022 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1023 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1024 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1025 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1026 
1027 contract LITTLEJIMMYERC20 is ERC20, Ownable {
1028     using SafeMath for uint256;
1029 
1030     IUniswapV2Router02 public immutable uniswapV2Router;
1031     address public immutable uniswapV2Pair;
1032     address public constant deadAddress = address(0xdead);
1033 
1034     bool private swapping;
1035 
1036 	address public charityWallet;
1037     address public marketingWallet;
1038     address public devWallet;
1039 
1040     uint256 public maxTransactionAmount;
1041     uint256 public swapTokensAtAmount;
1042     uint256 public maxWallet;
1043 
1044     bool public limitsInEffect = true;
1045     bool public tradingActive = true;
1046     bool public swapEnabled = true;
1047 
1048     // Anti-bot and anti-whale mappings and variables
1049     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1050     bool public transferDelayEnabled = true;
1051 
1052     uint256 public buyTotalFees;
1053 	uint256 public buyCharityFee;
1054     uint256 public buyMarketingFee;
1055     uint256 public buyLiquidityFee;
1056     uint256 public buyDevFee;
1057 
1058     uint256 public sellTotalFees;
1059 	uint256 public sellCharityFee;
1060     uint256 public sellMarketingFee;
1061     uint256 public sellLiquidityFee;
1062     uint256 public sellDevFee;
1063 
1064 	uint256 public tokensForCharity;
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
1088     event SwapAndLiquify(
1089         uint256 tokensSwapped,
1090         uint256 ethReceived,
1091         uint256 tokensIntoLiquidity
1092     );
1093 
1094     constructor() ERC20("Jimmy", "JIMMY") {
1095         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1096             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1097         );
1098 
1099         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1100         uniswapV2Router = _uniswapV2Router;
1101 
1102         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1103             .createPair(address(this), _uniswapV2Router.WETH());
1104         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1105         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1106 
1107 		uint256 _buyCharityFee = 12;
1108         uint256 _buyMarketingFee = 12;
1109         uint256 _buyLiquidityFee = 0;
1110         uint256 _buyDevFee = 0;
1111 
1112 		uint256 _sellCharityFee = 12;
1113         uint256 _sellMarketingFee = 12;
1114         uint256 _sellLiquidityFee = 0;
1115         uint256 _sellDevFee = 0;
1116 
1117         uint256 totalSupply = 69420420 * 1e18;
1118 
1119         maxTransactionAmount = 2100000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1120         maxWallet = 2100000 * 1e18; // 2% from total supply maxWallet
1121         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1122 
1123 		buyCharityFee = _buyCharityFee;
1124         buyMarketingFee = _buyMarketingFee;
1125         buyLiquidityFee = _buyLiquidityFee;
1126         buyDevFee = _buyDevFee;
1127         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1128 
1129 		sellCharityFee = _sellCharityFee;
1130         sellMarketingFee = _sellMarketingFee;
1131         sellLiquidityFee = _sellLiquidityFee;
1132         sellDevFee = _sellDevFee;
1133         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1134 
1135 		charityWallet = address(0xd3170D1FCa2C8a668A3304958Ee4d5382be777E3); // set as charity wallet
1136         marketingWallet = address(0xF39FaA997E3821CAd217C4DF87a1E72E15bc71A3); // set as marketing wallet
1137         devWallet = address(0xF39FaA997E3821CAd217C4DF87a1E72E15bc71A3); // set as dev wallet
1138 
1139         // exclude from paying fees or having max transaction amount
1140         excludeFromFees(owner(), true);
1141         excludeFromFees(address(this), true);
1142         excludeFromFees(address(0xdead), true);
1143 
1144         excludeFromMaxTransaction(owner(), true);
1145         excludeFromMaxTransaction(address(this), true);
1146         excludeFromMaxTransaction(address(0xdead), true);
1147 
1148         /*
1149             _mint is an internal function in ERC20.sol that is only called here,
1150             and CANNOT be called ever again
1151         */
1152         _mint(msg.sender, totalSupply);
1153     }
1154 
1155     receive() external payable {}
1156 
1157     // once enabled, can never be turned off
1158     function enableTrading() external onlyOwner {
1159         tradingActive = true;
1160         swapEnabled = true;
1161     }
1162 
1163     // remove limits after token is stable
1164     function removeLimits() external onlyOwner returns (bool) {
1165         limitsInEffect = false;
1166         return true;
1167     }
1168 
1169     // disable Transfer delay - cannot be reenabled
1170     function disableTransferDelay() external onlyOwner returns (bool) {
1171         transferDelayEnabled = false;
1172         return true;
1173     }
1174 
1175     // change the minimum amount of tokens to sell from fees
1176     function updateSwapTokensAtAmount(uint256 newAmount)
1177         external
1178         onlyOwner
1179         returns (bool)
1180     {
1181         require(
1182             newAmount >= (totalSupply() * 1) / 100000,
1183             "Swap amount cannot be lower than 0.001% total supply."
1184         );
1185         require(
1186             newAmount <= (totalSupply() * 5) / 1000,
1187             "Swap amount cannot be higher than 0.5% total supply."
1188         );
1189         swapTokensAtAmount = newAmount;
1190         return true;
1191     }
1192 
1193     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1194         require(
1195             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1196             "Cannot set maxTransactionAmount lower than 0.5%"
1197         );
1198         maxTransactionAmount = newNum * (10**18);
1199     }
1200 
1201     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1202         require(
1203             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1204             "Cannot set maxWallet lower than 0.5%"
1205         );
1206         maxWallet = newNum * (10**18);
1207     }
1208 	
1209     function excludeFromMaxTransaction(address updAds, bool isEx)
1210         public
1211         onlyOwner
1212     {
1213         _isExcludedMaxTransactionAmount[updAds] = isEx;
1214     }
1215 
1216     // only use to disable contract sales if absolutely necessary (emergency use only)
1217     function updateSwapEnabled(bool enabled) external onlyOwner {
1218         swapEnabled = enabled;
1219     }
1220 
1221     function updateBuyFees(
1222 		uint256 _charityFee,
1223         uint256 _marketingFee,
1224         uint256 _liquidityFee,
1225         uint256 _devFee
1226     ) external onlyOwner {
1227 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max BuyFee 10%");
1228 		buyCharityFee = _charityFee;
1229         buyMarketingFee = _marketingFee;
1230         buyLiquidityFee = _liquidityFee;
1231         buyDevFee = _devFee;
1232         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1233      }
1234 
1235     function updateSellFees(
1236 		uint256 _charityFee,
1237         uint256 _marketingFee,
1238         uint256 _liquidityFee,
1239         uint256 _devFee
1240     ) external onlyOwner {
1241 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max SellFee 10%");
1242 		sellCharityFee = _charityFee;
1243         sellMarketingFee = _marketingFee;
1244         sellLiquidityFee = _liquidityFee;
1245         sellDevFee = _devFee;
1246         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1247     }
1248 
1249     function excludeFromFees(address account, bool excluded) public onlyOwner {
1250         _isExcludedFromFees[account] = excluded;
1251         emit ExcludeFromFees(account, excluded);
1252     }
1253 
1254     function setAutomatedMarketMakerPair(address pair, bool value)
1255         public
1256         onlyOwner
1257     {
1258         require(
1259             pair != uniswapV2Pair,
1260             "The pair cannot be removed from automatedMarketMakerPairs"
1261         );
1262 
1263         _setAutomatedMarketMakerPair(pair, value);
1264     }
1265 
1266     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1267         automatedMarketMakerPairs[pair] = value;
1268 
1269         emit SetAutomatedMarketMakerPair(pair, value);
1270     }
1271 
1272     function isExcludedFromFees(address account) public view returns (bool) {
1273         return _isExcludedFromFees[account];
1274     }
1275 
1276     function _transfer(
1277         address from,
1278         address to,
1279         uint256 amount
1280     ) internal override {
1281         require(from != address(0), "ERC20: transfer from the zero address");
1282         require(to != address(0), "ERC20: transfer to the zero address");
1283 
1284         if (amount == 0) {
1285             super._transfer(from, to, 0);
1286             return;
1287         }
1288 
1289         if (limitsInEffect) {
1290             if (
1291                 from != owner() &&
1292                 to != owner() &&
1293                 to != address(0) &&
1294                 to != address(0xdead) &&
1295                 !swapping
1296             ) {
1297                 if (!tradingActive) {
1298                     require(
1299                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1300                         "Trading is not active."
1301                     );
1302                 }
1303 
1304                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1305                 if (transferDelayEnabled) {
1306                     if (
1307                         to != owner() &&
1308                         to != address(uniswapV2Router) &&
1309                         to != address(uniswapV2Pair)
1310                     ) {
1311                         require(
1312                             _holderLastTransferTimestamp[tx.origin] <
1313                                 block.number,
1314                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1315                         );
1316                         _holderLastTransferTimestamp[tx.origin] = block.number;
1317                     }
1318                 }
1319 
1320                 //when buy
1321                 if (
1322                     automatedMarketMakerPairs[from] &&
1323                     !_isExcludedMaxTransactionAmount[to]
1324                 ) {
1325                     require(
1326                         amount <= maxTransactionAmount,
1327                         "Buy transfer amount exceeds the maxTransactionAmount."
1328                     );
1329                     require(
1330                         amount + balanceOf(to) <= maxWallet,
1331                         "Max wallet exceeded"
1332                     );
1333                 }
1334                 //when sell
1335                 else if (
1336                     automatedMarketMakerPairs[to] &&
1337                     !_isExcludedMaxTransactionAmount[from]
1338                 ) {
1339                     require(
1340                         amount <= maxTransactionAmount,
1341                         "Sell transfer amount exceeds the maxTransactionAmount."
1342                     );
1343                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1344                     require(
1345                         amount + balanceOf(to) <= maxWallet,
1346                         "Max wallet exceeded"
1347                     );
1348                 }
1349             }
1350         }
1351 
1352         uint256 contractTokenBalance = balanceOf(address(this));
1353 
1354         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1355 
1356         if (
1357             canSwap &&
1358             swapEnabled &&
1359             !swapping &&
1360             !automatedMarketMakerPairs[from] &&
1361             !_isExcludedFromFees[from] &&
1362             !_isExcludedFromFees[to]
1363         ) {
1364             swapping = true;
1365 
1366             swapBack();
1367 
1368             swapping = false;
1369         }
1370 
1371         bool takeFee = !swapping;
1372 
1373         // if any account belongs to _isExcludedFromFee account then remove the fee
1374         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1375             takeFee = false;
1376         }
1377 
1378         uint256 fees = 0;
1379         // only take fees on buys/sells, do not take on wallet transfers
1380         if (takeFee) {
1381             // on sell
1382             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1383                 fees = amount.mul(sellTotalFees).div(100);
1384 				tokensForCharity += (fees * sellCharityFee) / sellTotalFees;
1385                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1386                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1387                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1388             }
1389             // on buy
1390             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1391                 fees = amount.mul(buyTotalFees).div(100);
1392 				tokensForCharity += (fees * buyCharityFee) / buyTotalFees;
1393                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1394                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1395                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1396             }
1397 
1398             if (fees > 0) {
1399                 super._transfer(from, address(this), fees);
1400             }
1401 
1402             amount -= fees;
1403         }
1404 
1405         super._transfer(from, to, amount);
1406     }
1407 
1408     function swapTokensForEth(uint256 tokenAmount) private {
1409         // generate the uniswap pair path of token -> weth
1410         address[] memory path = new address[](2);
1411         path[0] = address(this);
1412         path[1] = uniswapV2Router.WETH();
1413 
1414         _approve(address(this), address(uniswapV2Router), tokenAmount);
1415 
1416         // make the swap
1417         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1418             tokenAmount,
1419             0, // accept any amount of ETH
1420             path,
1421             address(this),
1422             block.timestamp
1423         );
1424     }
1425 
1426     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1427         // approve token transfer to cover all possible scenarios
1428         _approve(address(this), address(uniswapV2Router), tokenAmount);
1429 
1430         // add the liquidity
1431         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1432             address(this),
1433             tokenAmount,
1434             0, // slippage is unavoidable
1435             0, // slippage is unavoidable
1436             devWallet,
1437             block.timestamp
1438         );
1439     }
1440 
1441     function swapBack() private {
1442         uint256 contractBalance = balanceOf(address(this));
1443         uint256 totalTokensToSwap = tokensForCharity + tokensForLiquidity + tokensForMarketing + tokensForDev;
1444         bool success;
1445 
1446         if (contractBalance == 0 || totalTokensToSwap == 0) {
1447             return;
1448         }
1449 
1450         if (contractBalance > swapTokensAtAmount * 20) {
1451             contractBalance = swapTokensAtAmount * 20;
1452         }
1453 
1454         // Halve the amount of liquidity tokens
1455         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1456         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1457 
1458         uint256 initialETHBalance = address(this).balance;
1459 
1460         swapTokensForEth(amountToSwapForETH);
1461 
1462         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1463 
1464 		uint256 ethForCharity = ethBalance.mul(tokensForCharity).div(totalTokensToSwap);
1465         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1466         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1467 
1468         uint256 ethForLiquidity = ethBalance - ethForCharity - ethForMarketing - ethForDev;
1469 
1470         tokensForLiquidity = 0;
1471 		tokensForCharity = 0;
1472         tokensForMarketing = 0;
1473         tokensForDev = 0;
1474 
1475         (success, ) = address(devWallet).call{value: ethForDev}("");
1476         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1477 
1478 
1479         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1480             addLiquidity(liquidityTokens, ethForLiquidity);
1481             emit SwapAndLiquify(
1482                 amountToSwapForETH,
1483                 ethForLiquidity,
1484                 tokensForLiquidity
1485             );
1486         }
1487 
1488         (success, ) = address(charityWallet).call{value: address(this).balance}("");
1489     }
1490 
1491 }