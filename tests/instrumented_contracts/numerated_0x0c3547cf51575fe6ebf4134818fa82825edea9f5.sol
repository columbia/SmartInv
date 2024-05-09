1 /**
2  * https://twitter.com/suscoineth
3  * https://t.me/susportal
4 */
5 
6 // SPDX-License-Identifier: MIT
7 pragma solidity ^0.8.10;
8 pragma experimental ABIEncoderV2;
9 
10 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
11 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
12 
13 /* pragma solidity ^0.8.0; */
14 
15 /**
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes calldata) {
31         return msg.data;
32     }
33 }
34 
35 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
36 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
37 
38 /* pragma solidity ^0.8.0; */
39 
40 /* import "../utils/Context.sol"; */
41 
42 /**
43  * @dev Contract module which provides a basic access control mechanism, where
44  * there is an account (an owner) that can be granted exclusive access to
45  * specific functions.
46  *
47  * By default, the owner account will be the one that deploys the contract. This
48  * can later be changed with {transferOwnership}.
49  *
50  * This module is used through inheritance. It will make available the modifier
51  * `onlyOwner`, which can be applied to your functions to restrict their use to
52  * the owner.
53  */
54 abstract contract Ownable is Context {
55     address private _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     /**
60      * @dev Initializes the contract setting the deployer as the initial owner.
61      */
62     constructor() {
63         _transferOwnership(_msgSender());
64     }
65 
66     /**
67      * @dev Returns the address of the current owner.
68      */
69     function owner() public view virtual returns (address) {
70         return _owner;
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         require(owner() == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     /**
82      * @dev Leaves the contract without owner. It will not be possible to call
83      * `onlyOwner` functions anymore. Can only be called by the current owner.
84      *
85      * NOTE: Renouncing ownership will leave the contract without an owner,
86      * thereby removing any functionality that is only available to the owner.
87      */
88     function renounceOwnership() public virtual onlyOwner {
89         _transferOwnership(address(0));
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         _transferOwnership(newOwner);
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Internal function without access restriction.
104      */
105     function _transferOwnership(address newOwner) internal virtual {
106         address oldOwner = _owner;
107         _owner = newOwner;
108         emit OwnershipTransferred(oldOwner, newOwner);
109     }
110 }
111 
112 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
113 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
114 
115 /* pragma solidity ^0.8.0; */
116 
117 /**
118  * @dev Interface of the ERC20 standard as defined in the EIP.
119  */
120 interface IERC20 {
121     /**
122      * @dev Returns the amount of tokens in existence.
123      */
124     function totalSupply() external view returns (uint256);
125 
126     /**
127      * @dev Returns the amount of tokens owned by `account`.
128      */
129     function balanceOf(address account) external view returns (uint256);
130 
131     /**
132      * @dev Moves `amount` tokens from the caller's account to `recipient`.
133      *
134      * Returns a boolean value indicating whether the operation succeeded.
135      *
136      * Emits a {Transfer} event.
137      */
138     function transfer(address recipient, uint256 amount) external returns (bool);
139 
140     /**
141      * @dev Returns the remaining number of tokens that `spender` will be
142      * allowed to spend on behalf of `owner` through {transferFrom}. This is
143      * zero by default.
144      *
145      * This value changes when {approve} or {transferFrom} are called.
146      */
147     function allowance(address owner, address spender) external view returns (uint256);
148 
149     /**
150      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
151      *
152      * Returns a boolean value indicating whether the operation succeeded.
153      *
154      * IMPORTANT: Beware that changing an allowance with this method brings the risk
155      * that someone may use both the old and the new allowance by unfortunate
156      * transaction ordering. One possible solution to mitigate this race
157      * condition is to first reduce the spender's allowance to 0 and set the
158      * desired value afterwards:
159      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160      *
161      * Emits an {Approval} event.
162      */
163     function approve(address spender, uint256 amount) external returns (bool);
164 
165     /**
166      * @dev Moves `amount` tokens from `sender` to `recipient` using the
167      * allowance mechanism. `amount` is then deducted from the caller's
168      * allowance.
169      *
170      * Returns a boolean value indicating whether the operation succeeded.
171      *
172      * Emits a {Transfer} event.
173      */
174     function transferFrom(
175         address sender,
176         address recipient,
177         uint256 amount
178     ) external returns (bool);
179 
180     /**
181      * @dev Emitted when `value` tokens are moved from one account (`from`) to
182      * another (`to`).
183      *
184      * Note that `value` may be zero.
185      */
186     event Transfer(address indexed from, address indexed to, uint256 value);
187 
188     /**
189      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
190      * a call to {approve}. `value` is the new allowance.
191      */
192     event Approval(address indexed owner, address indexed spender, uint256 value);
193 }
194 
195 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
196 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
197 
198 /* pragma solidity ^0.8.0; */
199 
200 /* import "../IERC20.sol"; */
201 
202 /**
203  * @dev Interface for the optional metadata functions from the ERC20 standard.
204  *
205  * _Available since v4.1._
206  */
207 interface IERC20Metadata is IERC20 {
208     /**
209      * @dev Returns the name of the token.
210      */
211     function name() external view returns (string memory);
212 
213     /**
214      * @dev Returns the symbol of the token.
215      */
216     function symbol() external view returns (string memory);
217 
218     /**
219      * @dev Returns the decimals places of the token.
220      */
221     function decimals() external view returns (uint8);
222 }
223 
224 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
225 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
226 
227 /* pragma solidity ^0.8.0; */
228 
229 /* import "./IERC20.sol"; */
230 /* import "./extensions/IERC20Metadata.sol"; */
231 /* import "../../utils/Context.sol"; */
232 
233 /**
234  * @dev Implementation of the {IERC20} interface.
235  *
236  * This implementation is agnostic to the way tokens are created. This means
237  * that a supply mechanism has to be added in a derived contract using {_mint}.
238  * For a generic mechanism see {ERC20PresetMinterPauser}.
239  *
240  * TIP: For a detailed writeup see our guide
241  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
242  * to implement supply mechanisms].
243  *
244  * We have followed general OpenZeppelin Contracts guidelines: functions revert
245  * instead returning `false` on failure. This behavior is nonetheless
246  * conventional and does not conflict with the expectations of ERC20
247  * applications.
248  *
249  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
250  * This allows applications to reconstruct the allowance for all accounts just
251  * by listening to said events. Other implementations of the EIP may not emit
252  * these events, as it isn't required by the specification.
253  *
254  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
255  * functions have been added to mitigate the well-known issues around setting
256  * allowances. See {IERC20-approve}.
257  */
258 contract ERC20 is Context, IERC20, IERC20Metadata {
259     mapping(address => uint256) private _balances;
260 
261     mapping(address => mapping(address => uint256)) private _allowances;
262 
263     uint256 private _totalSupply;
264 
265     string private _name;
266     string private _symbol;
267 
268     /**
269      * @dev Sets the values for {name} and {symbol}.
270      *
271      * The default value of {decimals} is 18. To select a different value for
272      * {decimals} you should overload it.
273      *
274      * All two of these values are immutable: they can only be set once during
275      * construction.
276      */
277     constructor(string memory name_, string memory symbol_) {
278         _name = name_;
279         _symbol = symbol_;
280     }
281 
282     /**
283      * @dev Returns the name of the token.
284      */
285     function name() public view virtual override returns (string memory) {
286         return _name;
287     }
288 
289     /**
290      * @dev Returns the symbol of the token, usually a shorter version of the
291      * name.
292      */
293     function symbol() public view virtual override returns (string memory) {
294         return _symbol;
295     }
296 
297     /**
298      * @dev Returns the number of decimals used to get its user representation.
299      * For example, if `decimals` equals `2`, a balance of `505` tokens should
300      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
301      *
302      * Tokens usually opt for a value of 18, imitating the relationship between
303      * Ether and Wei. This is the value {ERC20} uses, unless this function is
304      * overridden;
305      *
306      * NOTE: This information is only used for _display_ purposes: it in
307      * no way affects any of the arithmetic of the contract, including
308      * {IERC20-balanceOf} and {IERC20-transfer}.
309      */
310     function decimals() public view virtual override returns (uint8) {
311         return 18;
312     }
313 
314     /**
315      * @dev See {IERC20-totalSupply}.
316      */
317     function totalSupply() public view virtual override returns (uint256) {
318         return _totalSupply;
319     }
320 
321     /**
322      * @dev See {IERC20-balanceOf}.
323      */
324     function balanceOf(address account) public view virtual override returns (uint256) {
325         return _balances[account];
326     }
327 
328     /**
329      * @dev See {IERC20-transfer}.
330      *
331      * Requirements:
332      *
333      * - `recipient` cannot be the zero address.
334      * - the caller must have a balance of at least `amount`.
335      */
336     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
337         _transfer(_msgSender(), recipient, amount);
338         return true;
339     }
340 
341     /**
342      * @dev See {IERC20-allowance}.
343      */
344     function allowance(address owner, address spender) public view virtual override returns (uint256) {
345         return _allowances[owner][spender];
346     }
347 
348     /**
349      * @dev See {IERC20-approve}.
350      *
351      * Requirements:
352      *
353      * - `spender` cannot be the zero address.
354      */
355     function approve(address spender, uint256 amount) public virtual override returns (bool) {
356         _approve(_msgSender(), spender, amount);
357         return true;
358     }
359 
360     /**
361      * @dev See {IERC20-transferFrom}.
362      *
363      * Emits an {Approval} event indicating the updated allowance. This is not
364      * required by the EIP. See the note at the beginning of {ERC20}.
365      *
366      * Requirements:
367      *
368      * - `sender` and `recipient` cannot be the zero address.
369      * - `sender` must have a balance of at least `amount`.
370      * - the caller must have allowance for ``sender``'s tokens of at least
371      * `amount`.
372      */
373     function transferFrom(
374         address sender,
375         address recipient,
376         uint256 amount
377     ) public virtual override returns (bool) {
378         _transfer(sender, recipient, amount);
379 
380         uint256 currentAllowance = _allowances[sender][_msgSender()];
381         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
382         unchecked {
383             _approve(sender, _msgSender(), currentAllowance - amount);
384         }
385 
386         return true;
387     }
388 
389     /**
390      * @dev Atomically increases the allowance granted to `spender` by the caller.
391      *
392      * This is an alternative to {approve} that can be used as a mitigation for
393      * problems described in {IERC20-approve}.
394      *
395      * Emits an {Approval} event indicating the updated allowance.
396      *
397      * Requirements:
398      *
399      * - `spender` cannot be the zero address.
400      */
401     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
402         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
403         return true;
404     }
405 
406     /**
407      * @dev Atomically decreases the allowance granted to `spender` by the caller.
408      *
409      * This is an alternative to {approve} that can be used as a mitigation for
410      * problems described in {IERC20-approve}.
411      *
412      * Emits an {Approval} event indicating the updated allowance.
413      *
414      * Requirements:
415      *
416      * - `spender` cannot be the zero address.
417      * - `spender` must have allowance for the caller of at least
418      * `subtractedValue`.
419      */
420     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
421         uint256 currentAllowance = _allowances[_msgSender()][spender];
422         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
423         unchecked {
424             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
425         }
426 
427         return true;
428     }
429 
430     /**
431      * @dev Moves `amount` of tokens from `sender` to `recipient`.
432      *
433      * This internal function is equivalent to {transfer}, and can be used to
434      * e.g. implement automatic token fees, slashing mechanisms, etc.
435      *
436      * Emits a {Transfer} event.
437      *
438      * Requirements:
439      *
440      * - `sender` cannot be the zero address.
441      * - `recipient` cannot be the zero address.
442      * - `sender` must have a balance of at least `amount`.
443      */
444     function _transfer(
445         address sender,
446         address recipient,
447         uint256 amount
448     ) internal virtual {
449         require(sender != address(0), "ERC20: transfer from the zero address");
450         require(recipient != address(0), "ERC20: transfer to the zero address");
451 
452         _beforeTokenTransfer(sender, recipient, amount);
453 
454         uint256 senderBalance = _balances[sender];
455         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
456         unchecked {
457             _balances[sender] = senderBalance - amount;
458         }
459         _balances[recipient] += amount;
460 
461         emit Transfer(sender, recipient, amount);
462 
463         _afterTokenTransfer(sender, recipient, amount);
464     }
465 
466     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
467      * the total supply.
468      *
469      * Emits a {Transfer} event with `from` set to the zero address.
470      *
471      * Requirements:
472      *
473      * - `account` cannot be the zero address.
474      */
475     function _mint(address account, uint256 amount) internal virtual {
476         require(account != address(0), "ERC20: mint to the zero address");
477 
478         _beforeTokenTransfer(address(0), account, amount);
479 
480         _totalSupply += amount;
481         _balances[account] += amount;
482         emit Transfer(address(0), account, amount);
483 
484         _afterTokenTransfer(address(0), account, amount);
485     }
486 
487     /**
488      * @dev Destroys `amount` tokens from `account`, reducing the
489      * total supply.
490      *
491      * Emits a {Transfer} event with `to` set to the zero address.
492      *
493      * Requirements:
494      *
495      * - `account` cannot be the zero address.
496      * - `account` must have at least `amount` tokens.
497      */
498     function _burn(address account, uint256 amount) internal virtual {
499         require(account != address(0), "ERC20: burn from the zero address");
500 
501         _beforeTokenTransfer(account, address(0), amount);
502 
503         uint256 accountBalance = _balances[account];
504         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
505         unchecked {
506             _balances[account] = accountBalance - amount;
507         }
508         _totalSupply -= amount;
509 
510         emit Transfer(account, address(0), amount);
511 
512         _afterTokenTransfer(account, address(0), amount);
513     }
514 
515     /**
516      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
517      *
518      * This internal function is equivalent to `approve`, and can be used to
519      * e.g. set automatic allowances for certain subsystems, etc.
520      *
521      * Emits an {Approval} event.
522      *
523      * Requirements:
524      *
525      * - `owner` cannot be the zero address.
526      * - `spender` cannot be the zero address.
527      */
528     function _approve(
529         address owner,
530         address spender,
531         uint256 amount
532     ) internal virtual {
533         require(owner != address(0), "ERC20: approve from the zero address");
534         require(spender != address(0), "ERC20: approve to the zero address");
535 
536         _allowances[owner][spender] = amount;
537         emit Approval(owner, spender, amount);
538     }
539 
540     /**
541      * @dev Hook that is called before any transfer of tokens. This includes
542      * minting and burning.
543      *
544      * Calling conditions:
545      *
546      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
547      * will be transferred to `to`.
548      * - when `from` is zero, `amount` tokens will be minted for `to`.
549      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
550      * - `from` and `to` are never both zero.
551      *
552      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
553      */
554     function _beforeTokenTransfer(
555         address from,
556         address to,
557         uint256 amount
558     ) internal virtual {}
559 
560     /**
561      * @dev Hook that is called after any transfer of tokens. This includes
562      * minting and burning.
563      *
564      * Calling conditions:
565      *
566      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
567      * has been transferred to `to`.
568      * - when `from` is zero, `amount` tokens have been minted for `to`.
569      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
570      * - `from` and `to` are never both zero.
571      *
572      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
573      */
574     function _afterTokenTransfer(
575         address from,
576         address to,
577         uint256 amount
578     ) internal virtual {}
579 }
580 
581 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
582 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
583 
584 /* pragma solidity ^0.8.0; */
585 
586 // CAUTION
587 // This version of SafeMath should only be used with Solidity 0.8 or later,
588 // because it relies on the compiler's built in overflow checks.
589 
590 /**
591  * @dev Wrappers over Solidity's arithmetic operations.
592  *
593  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
594  * now has built in overflow checking.
595  */
596 library SafeMath {
597     /**
598      * @dev Returns the addition of two unsigned integers, with an overflow flag.
599      *
600      * _Available since v3.4._
601      */
602     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
603         unchecked {
604             uint256 c = a + b;
605             if (c < a) return (false, 0);
606             return (true, c);
607         }
608     }
609 
610     /**
611      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
612      *
613      * _Available since v3.4._
614      */
615     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
616         unchecked {
617             if (b > a) return (false, 0);
618             return (true, a - b);
619         }
620     }
621 
622     /**
623      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
624      *
625      * _Available since v3.4._
626      */
627     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
628         unchecked {
629             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
630             // benefit is lost if 'b' is also tested.
631             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
632             if (a == 0) return (true, 0);
633             uint256 c = a * b;
634             if (c / a != b) return (false, 0);
635             return (true, c);
636         }
637     }
638 
639     /**
640      * @dev Returns the division of two unsigned integers, with a division by zero flag.
641      *
642      * _Available since v3.4._
643      */
644     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
645         unchecked {
646             if (b == 0) return (false, 0);
647             return (true, a / b);
648         }
649     }
650 
651     /**
652      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
653      *
654      * _Available since v3.4._
655      */
656     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
657         unchecked {
658             if (b == 0) return (false, 0);
659             return (true, a % b);
660         }
661     }
662 
663     /**
664      * @dev Returns the addition of two unsigned integers, reverting on
665      * overflow.
666      *
667      * Counterpart to Solidity's `+` operator.
668      *
669      * Requirements:
670      *
671      * - Addition cannot overflow.
672      */
673     function add(uint256 a, uint256 b) internal pure returns (uint256) {
674         return a + b;
675     }
676 
677     /**
678      * @dev Returns the subtraction of two unsigned integers, reverting on
679      * overflow (when the result is negative).
680      *
681      * Counterpart to Solidity's `-` operator.
682      *
683      * Requirements:
684      *
685      * - Subtraction cannot overflow.
686      */
687     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
688         return a - b;
689     }
690 
691     /**
692      * @dev Returns the multiplication of two unsigned integers, reverting on
693      * overflow.
694      *
695      * Counterpart to Solidity's `*` operator.
696      *
697      * Requirements:
698      *
699      * - Multiplication cannot overflow.
700      */
701     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
702         return a * b;
703     }
704 
705     /**
706      * @dev Returns the integer division of two unsigned integers, reverting on
707      * division by zero. The result is rounded towards zero.
708      *
709      * Counterpart to Solidity's `/` operator.
710      *
711      * Requirements:
712      *
713      * - The divisor cannot be zero.
714      */
715     function div(uint256 a, uint256 b) internal pure returns (uint256) {
716         return a / b;
717     }
718 
719     /**
720      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
721      * reverting when dividing by zero.
722      *
723      * Counterpart to Solidity's `%` operator. This function uses a `revert`
724      * opcode (which leaves remaining gas untouched) while Solidity uses an
725      * invalid opcode to revert (consuming all remaining gas).
726      *
727      * Requirements:
728      *
729      * - The divisor cannot be zero.
730      */
731     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
732         return a % b;
733     }
734 
735     /**
736      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
737      * overflow (when the result is negative).
738      *
739      * CAUTION: This function is deprecated because it requires allocating memory for the error
740      * message unnecessarily. For custom revert reasons use {trySub}.
741      *
742      * Counterpart to Solidity's `-` operator.
743      *
744      * Requirements:
745      *
746      * - Subtraction cannot overflow.
747      */
748     function sub(
749         uint256 a,
750         uint256 b,
751         string memory errorMessage
752     ) internal pure returns (uint256) {
753         unchecked {
754             require(b <= a, errorMessage);
755             return a - b;
756         }
757     }
758 
759     /**
760      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
761      * division by zero. The result is rounded towards zero.
762      *
763      * Counterpart to Solidity's `/` operator. Note: this function uses a
764      * `revert` opcode (which leaves remaining gas untouched) while Solidity
765      * uses an invalid opcode to revert (consuming all remaining gas).
766      *
767      * Requirements:
768      *
769      * - The divisor cannot be zero.
770      */
771     function div(
772         uint256 a,
773         uint256 b,
774         string memory errorMessage
775     ) internal pure returns (uint256) {
776         unchecked {
777             require(b > 0, errorMessage);
778             return a / b;
779         }
780     }
781 
782     /**
783      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
784      * reverting with custom message when dividing by zero.
785      *
786      * CAUTION: This function is deprecated because it requires allocating memory for the error
787      * message unnecessarily. For custom revert reasons use {tryMod}.
788      *
789      * Counterpart to Solidity's `%` operator. This function uses a `revert`
790      * opcode (which leaves remaining gas untouched) while Solidity uses an
791      * invalid opcode to revert (consuming all remaining gas).
792      *
793      * Requirements:
794      *
795      * - The divisor cannot be zero.
796      */
797     function mod(
798         uint256 a,
799         uint256 b,
800         string memory errorMessage
801     ) internal pure returns (uint256) {
802         unchecked {
803             require(b > 0, errorMessage);
804             return a % b;
805         }
806     }
807 }
808 
809 ////// src/IUniswapV2Factory.sol
810 /* pragma solidity 0.8.10; */
811 /* pragma experimental ABIEncoderV2; */
812 
813 interface IUniswapV2Factory {
814     event PairCreated(
815         address indexed token0,
816         address indexed token1,
817         address pair,
818         uint256
819     );
820 
821     function feeTo() external view returns (address);
822 
823     function feeToSetter() external view returns (address);
824 
825     function getPair(address tokenA, address tokenB)
826         external
827         view
828         returns (address pair);
829 
830     function allPairs(uint256) external view returns (address pair);
831 
832     function allPairsLength() external view returns (uint256);
833 
834     function createPair(address tokenA, address tokenB)
835         external
836         returns (address pair);
837 
838     function setFeeTo(address) external;
839 
840     function setFeeToSetter(address) external;
841 }
842 
843 ////// src/IUniswapV2Pair.sol
844 /* pragma solidity 0.8.10; */
845 /* pragma experimental ABIEncoderV2; */
846 
847 interface IUniswapV2Pair {
848     event Approval(
849         address indexed owner,
850         address indexed spender,
851         uint256 value
852     );
853     event Transfer(address indexed from, address indexed to, uint256 value);
854 
855     function name() external pure returns (string memory);
856 
857     function symbol() external pure returns (string memory);
858 
859     function decimals() external pure returns (uint8);
860 
861     function totalSupply() external view returns (uint256);
862 
863     function balanceOf(address owner) external view returns (uint256);
864 
865     function allowance(address owner, address spender)
866         external
867         view
868         returns (uint256);
869 
870     function approve(address spender, uint256 value) external returns (bool);
871 
872     function transfer(address to, uint256 value) external returns (bool);
873 
874     function transferFrom(
875         address from,
876         address to,
877         uint256 value
878     ) external returns (bool);
879 
880     function DOMAIN_SEPARATOR() external view returns (bytes32);
881 
882     function PERMIT_TYPEHASH() external pure returns (bytes32);
883 
884     function nonces(address owner) external view returns (uint256);
885 
886     function permit(
887         address owner,
888         address spender,
889         uint256 value,
890         uint256 deadline,
891         uint8 v,
892         bytes32 r,
893         bytes32 s
894     ) external;
895 
896     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
897     event Burn(
898         address indexed sender,
899         uint256 amount0,
900         uint256 amount1,
901         address indexed to
902     );
903     event Swap(
904         address indexed sender,
905         uint256 amount0In,
906         uint256 amount1In,
907         uint256 amount0Out,
908         uint256 amount1Out,
909         address indexed to
910     );
911     event Sync(uint112 reserve0, uint112 reserve1);
912 
913     function MINIMUM_LIQUIDITY() external pure returns (uint256);
914 
915     function factory() external view returns (address);
916 
917     function token0() external view returns (address);
918 
919     function token1() external view returns (address);
920 
921     function getReserves()
922         external
923         view
924         returns (
925             uint112 reserve0,
926             uint112 reserve1,
927             uint32 blockTimestampLast
928         );
929 
930     function price0CumulativeLast() external view returns (uint256);
931 
932     function price1CumulativeLast() external view returns (uint256);
933 
934     function kLast() external view returns (uint256);
935 
936     function mint(address to) external returns (uint256 liquidity);
937 
938     function burn(address to)
939         external
940         returns (uint256 amount0, uint256 amount1);
941 
942     function swap(
943         uint256 amount0Out,
944         uint256 amount1Out,
945         address to,
946         bytes calldata data
947     ) external;
948 
949     function skim(address to) external;
950 
951     function sync() external;
952 
953     function initialize(address, address) external;
954 }
955 
956 ////// src/IUniswapV2Router02.sol
957 /* pragma solidity 0.8.10; */
958 /* pragma experimental ABIEncoderV2; */
959 
960 interface IUniswapV2Router02 {
961     function factory() external pure returns (address);
962 
963     function WETH() external pure returns (address);
964 
965     function addLiquidity(
966         address tokenA,
967         address tokenB,
968         uint256 amountADesired,
969         uint256 amountBDesired,
970         uint256 amountAMin,
971         uint256 amountBMin,
972         address to,
973         uint256 deadline
974     )
975         external
976         returns (
977             uint256 amountA,
978             uint256 amountB,
979             uint256 liquidity
980         );
981 
982     function addLiquidityETH(
983         address token,
984         uint256 amountTokenDesired,
985         uint256 amountTokenMin,
986         uint256 amountETHMin,
987         address to,
988         uint256 deadline
989     )
990         external
991         payable
992         returns (
993             uint256 amountToken,
994             uint256 amountETH,
995             uint256 liquidity
996         );
997 
998     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
999         uint256 amountIn,
1000         uint256 amountOutMin,
1001         address[] calldata path,
1002         address to,
1003         uint256 deadline
1004     ) external;
1005 
1006     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1007         uint256 amountOutMin,
1008         address[] calldata path,
1009         address to,
1010         uint256 deadline
1011     ) external payable;
1012 
1013     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1014         uint256 amountIn,
1015         uint256 amountOutMin,
1016         address[] calldata path,
1017         address to,
1018         uint256 deadline
1019     ) external;
1020 }
1021 
1022 /* pragma solidity >=0.8.10; */
1023 
1024 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1025 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1026 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1027 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1028 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1029 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1030 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1031 
1032 contract SUS is ERC20, Ownable {
1033     using SafeMath for uint256;
1034 
1035     IUniswapV2Router02 public immutable uniswapV2Router;
1036     address public immutable uniswapV2Pair;
1037     address public constant deadAddress = address(0xdead);
1038 
1039     bool private swapping;
1040 
1041     address public marketingWallet;
1042     address public devWallet;
1043 
1044     uint256 public maxTransactionAmount;
1045     uint256 public swapTokensAtAmount;
1046     uint256 public maxWallet;
1047 
1048     uint256 public percentForLPBurn = 25; // 25 = .25%
1049     bool public lpBurnEnabled = true;
1050     uint256 public lpBurnFrequency = 3600 seconds;
1051     uint256 public lastLpBurnTime;
1052 
1053     uint256 public manualBurnFrequency = 30 minutes;
1054     uint256 public lastManualLpBurnTime;
1055 
1056     bool public limitsInEffect = true;
1057     bool public tradingActive = false;
1058     bool public swapEnabled = false;
1059 
1060     // Anti-bot and anti-whale mappings and variables
1061     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1062     bool public transferDelayEnabled = true;
1063 
1064     uint256 public buyTotalFees;
1065     uint256 public buyMarketingFee;
1066     uint256 public buyLiquidityFee;
1067     uint256 public buyDevFee;
1068 
1069     uint256 public sellTotalFees;
1070     uint256 public sellMarketingFee;
1071     uint256 public sellLiquidityFee;
1072     uint256 public sellDevFee;
1073 
1074     uint256 public tokensForMarketing;
1075     uint256 public tokensForLiquidity;
1076     uint256 public tokensForDev;
1077 
1078     /******************/
1079 
1080     // deadblock
1081     uint256 public deadBlock;
1082     uint256 public constant feeDuration = 13;
1083     bool public isFeeUpdated = false;
1084 
1085     /******************/
1086 
1087     // exlcude from fees and max transaction amount
1088     mapping(address => bool) private _isExcludedFromFees;
1089     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1090 
1091     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1092     // could be subject to a maximum transfer amount
1093     mapping(address => bool) public automatedMarketMakerPairs;
1094 
1095     event UpdateUniswapV2Router(
1096         address indexed newAddress,
1097         address indexed oldAddress
1098     );
1099 
1100     event ExcludeFromFees(address indexed account, bool isExcluded);
1101 
1102     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1103 
1104     event marketingWalletUpdated(
1105         address indexed newWallet,
1106         address indexed oldWallet
1107     );
1108 
1109     event devWalletUpdated(
1110         address indexed newWallet,
1111         address indexed oldWallet
1112     );
1113 
1114     event SwapAndLiquify(
1115         uint256 tokensSwapped,
1116         uint256 ethReceived,
1117         uint256 tokensIntoLiquidity
1118     );
1119 
1120     event AutoNukeLP();
1121 
1122     event ManualNukeLP();
1123 
1124     constructor() ERC20("SUS", unicode"SUS") {
1125         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1126             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1127         );
1128 
1129         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1130         uniswapV2Router = _uniswapV2Router;
1131 
1132         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1133             .createPair(address(this), _uniswapV2Router.WETH());
1134         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1135         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1136 
1137         uint256 _buyMarketingFee = 0;
1138         uint256 _buyLiquidityFee = 1;
1139         uint256 _buyDevFee = 99;
1140 
1141         uint256 _sellMarketingFee = 0;
1142         uint256 _sellLiquidityFee = 1;
1143         uint256 _sellDevFee = 99;
1144 
1145         uint256 totalSupply = 1_000_000_000 * 1e18;
1146 
1147         maxTransactionAmount = 20_000_000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1148         maxWallet = 20_000_000 * 1e18; // 3% from total supply maxWallet
1149         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1150 
1151         buyMarketingFee = _buyMarketingFee;
1152         buyLiquidityFee = _buyLiquidityFee;
1153         buyDevFee = _buyDevFee;
1154         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1155 
1156         sellMarketingFee = _sellMarketingFee;
1157         sellLiquidityFee = _sellLiquidityFee;
1158         sellDevFee = _sellDevFee;
1159         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1160 
1161         marketingWallet = address(0xaDAD207d675342981f4cb1403776282Ec2c5b6a5); // set as marketing wallet
1162         devWallet = address(0xBF58D40a0e139cCBf0e1f2f13b31Af7508986CB4); // set as dev wallet
1163 
1164         deadBlock = block.number; // set the initial deadblock
1165 
1166         // exclude from paying fees or having max transaction amount
1167         excludeFromFees(owner(), true);
1168         excludeFromFees(address(this), true);
1169         excludeFromFees(address(0xdead), true);
1170 
1171         excludeFromMaxTransaction(owner(), true);
1172         excludeFromMaxTransaction(address(this), true);
1173         excludeFromMaxTransaction(address(0xdead), true);
1174 
1175         /*
1176             _mint is an internal function in ERC20.sol that is only called here,
1177             and CANNOT be called ever again
1178         */
1179         _mint(msg.sender, totalSupply);
1180     }
1181 
1182     receive() external payable {}
1183 
1184     // once enabled, can never be turned off
1185     function enableTrading() external onlyOwner {
1186         tradingActive = true;
1187         swapEnabled = true;
1188         lastLpBurnTime = block.timestamp;
1189     }
1190 
1191     // remove limits after token is stable
1192     function removeLimits() external onlyOwner returns (bool) {
1193         limitsInEffect = false;
1194         return true;
1195     }
1196 
1197     // disable Transfer delay - cannot be reenabled
1198     function disableTransferDelay() external onlyOwner returns (bool) {
1199         transferDelayEnabled = false;
1200         return true;
1201     }
1202 
1203     // change the minimum amount of tokens to sell from fees
1204     function updateSwapTokensAtAmount(uint256 newAmount)
1205         external
1206         onlyOwner
1207         returns (bool)
1208     {
1209         require(
1210             newAmount >= (totalSupply() * 1) / 100000,
1211             "Swap amount cannot be lower than 0.001% total supply."
1212         );
1213         require(
1214             newAmount <= (totalSupply() * 5) / 1000,
1215             "Swap amount cannot be higher than 0.5% total supply."
1216         );
1217         swapTokensAtAmount = newAmount;
1218         return true;
1219     }
1220 
1221     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1222         require(
1223             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1224             "Cannot set maxTransactionAmount lower than 0.1%"
1225         );
1226         maxTransactionAmount = newNum * (10**18);
1227     }
1228 
1229     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1230         require(
1231             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1232             "Cannot set maxWallet lower than 0.5%"
1233         );
1234         maxWallet = newNum * (10**18);
1235     }
1236 
1237     function excludeFromMaxTransaction(address updAds, bool isEx)
1238         public
1239         onlyOwner
1240     {
1241         _isExcludedMaxTransactionAmount[updAds] = isEx;
1242     }
1243 
1244     // only use to disable contract sales if absolutely necessary (emergency use only)
1245     function updateSwapEnabled(bool enabled) external onlyOwner {
1246         swapEnabled = enabled;
1247     }
1248 
1249     function updateBuyFees(
1250         uint256 _marketingFee,
1251         uint256 _liquidityFee,
1252         uint256 _devFee
1253     ) external onlyOwner {
1254         isFeeUpdated = true;
1255 
1256         buyMarketingFee = _marketingFee;
1257         buyLiquidityFee = _liquidityFee;
1258         buyDevFee = _devFee;
1259         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1260         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1261     }
1262 
1263     function updateSellFees(
1264         uint256 _marketingFee,
1265         uint256 _liquidityFee,
1266         uint256 _devFee
1267     ) external onlyOwner {
1268         isFeeUpdated = true;
1269 
1270         sellMarketingFee = _marketingFee;
1271         sellLiquidityFee = _liquidityFee;
1272         sellDevFee = _devFee;
1273         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1274         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
1275     }
1276 
1277     function excludeFromFees(address account, bool excluded) public onlyOwner {
1278         _isExcludedFromFees[account] = excluded;
1279         emit ExcludeFromFees(account, excluded);
1280     }
1281 
1282     function setAutomatedMarketMakerPair(address pair, bool value)
1283         public
1284         onlyOwner
1285     {
1286         require(
1287             pair != uniswapV2Pair,
1288             "The pair cannot be removed from automatedMarketMakerPairs"
1289         );
1290 
1291         _setAutomatedMarketMakerPair(pair, value);
1292     }
1293 
1294     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1295         automatedMarketMakerPairs[pair] = value;
1296         emit SetAutomatedMarketMakerPair(pair, value);
1297     }
1298 
1299     function updateMarketingWallet(address newMarketingWallet)
1300         external
1301         onlyOwner
1302     {
1303         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1304         marketingWallet = newMarketingWallet;
1305     }
1306 
1307     function updateDevWallet(address newWallet) external onlyOwner {
1308         emit devWalletUpdated(newWallet, devWallet);
1309         devWallet = newWallet;
1310     }
1311 
1312     function isExcludedFromFees(address account) public view returns (bool) {
1313         return _isExcludedFromFees[account];
1314     }
1315 
1316     event BoughtEarly(address indexed sniper);
1317 
1318     function _transfer(
1319         address from,
1320         address to,
1321         uint256 amount
1322     ) internal override {
1323         require(from != address(0), "ERC20: transfer from the zero address");
1324         require(to != address(0), "ERC20: transfer to the zero address");
1325 
1326         if (amount == 0) {
1327             super._transfer(from, to, 0);
1328             return;
1329         }
1330 
1331         if (limitsInEffect) {
1332             if (
1333                 from != owner() &&
1334                 to != owner() &&
1335                 to != address(0) &&
1336                 to != address(0xdead) &&
1337                 !swapping
1338             ) {
1339                 if (!tradingActive) {
1340                     require(
1341                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1342                         "Trading is not active."
1343                     );
1344                 }
1345 
1346                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1347                 if (transferDelayEnabled) {
1348                     if (
1349                         to != owner() &&
1350                         to != address(uniswapV2Router) &&
1351                         to != address(uniswapV2Pair)
1352                     ) {
1353                         require(
1354                             _holderLastTransferTimestamp[tx.origin] <
1355                                 block.number,
1356                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1357                         );
1358                         _holderLastTransferTimestamp[tx.origin] = block.number;
1359                     }
1360                 }
1361 
1362                 //when buy
1363                 if (
1364                     automatedMarketMakerPairs[from] &&
1365                     !_isExcludedMaxTransactionAmount[to]
1366                 ) {
1367                     require(
1368                         amount <= maxTransactionAmount,
1369                         "Buy transfer amount exceeds the maxTransactionAmount."
1370                     );
1371                     require(
1372                         amount + balanceOf(to) <= maxWallet,
1373                         "Max wallet exceeded"
1374                     );
1375                 }
1376                 //when sell
1377                 else if (
1378                     automatedMarketMakerPairs[to] &&
1379                     !_isExcludedMaxTransactionAmount[from]
1380                 ) {
1381                     require(
1382                         amount <= maxTransactionAmount,
1383                         "Sell transfer amount exceeds the maxTransactionAmount."
1384                     );
1385                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1386                     require(
1387                         amount + balanceOf(to) <= maxWallet,
1388                         "Max wallet exceeded"
1389                     );
1390                 }
1391             }
1392         }
1393 
1394         uint256 contractTokenBalance = balanceOf(address(this));
1395 
1396         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1397 
1398         if (
1399             canSwap &&
1400             swapEnabled &&
1401             !swapping &&
1402             !automatedMarketMakerPairs[from] &&
1403             !_isExcludedFromFees[from] &&
1404             !_isExcludedFromFees[to]
1405         ) {
1406             swapping = true;
1407 
1408             swapBack();
1409 
1410             swapping = false;
1411         }
1412 
1413         if (
1414             !swapping &&
1415             automatedMarketMakerPairs[to] &&
1416             lpBurnEnabled &&
1417             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1418             !_isExcludedFromFees[from]
1419         ) {
1420             autoBurnLiquidityPairTokens();
1421         }
1422 
1423         bool takeFee = !swapping;
1424 
1425         // set deadblock when add initial lp
1426         if(automatedMarketMakerPairs[to] && from == owner()){
1427             deadBlock = block.number;
1428         }
1429 
1430         // check if we are in a fee period and adjust fee accordingly
1431         if(!isFeeUpdated){
1432             // until fee is updated
1433             if (block.number >= (deadBlock + feeDuration)) {
1434                 buyMarketingFee = 0;
1435                 buyLiquidityFee = 1;
1436                 buyDevFee = 29;
1437                 buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1438 
1439                 sellMarketingFee = 0;
1440                 sellLiquidityFee = 1;
1441                 sellDevFee = 98;
1442                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1443             }
1444         }
1445 
1446         // if any account belongs to _isExcludedFromFee account then remove the fee
1447         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1448             takeFee = false;
1449         }
1450 
1451         uint256 fees = 0;
1452         // only take fees on buys/sells, do not take on wallet transfers
1453         if (takeFee) {
1454             // on sell
1455             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1456                 fees = amount.mul(sellTotalFees).div(100);
1457                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1458                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1459                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1460             }
1461             // on buy
1462             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1463                 fees = amount.mul(buyTotalFees).div(100);
1464                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1465                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1466                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1467             }
1468 
1469             if (fees > 0) {
1470                 super._transfer(from, address(this), fees);
1471             }
1472 
1473             amount -= fees;
1474         }
1475 
1476         super._transfer(from, to, amount);
1477     }
1478 
1479     function swapTokensForEth(uint256 tokenAmount) private {
1480         // generate the uniswap pair path of token -> weth
1481         address[] memory path = new address[](2);
1482         path[0] = address(this);
1483         path[1] = uniswapV2Router.WETH();
1484 
1485         _approve(address(this), address(uniswapV2Router), tokenAmount);
1486 
1487         // make the swap
1488         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1489             tokenAmount,
1490             0, // accept any amount of ETH
1491             path,
1492             address(this),
1493             block.timestamp
1494         );
1495     }
1496 
1497     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1498         // approve token transfer to cover all possible scenarios
1499         _approve(address(this), address(uniswapV2Router), tokenAmount);
1500 
1501         // add the liquidity
1502         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1503             address(this),
1504             tokenAmount,
1505             0, // slippage is unavoidable
1506             0, // slippage is unavoidable
1507             deadAddress,
1508             block.timestamp
1509         );
1510     }
1511 
1512     function swapBack() private {
1513         uint256 contractBalance = balanceOf(address(this));
1514         uint256 totalTokensToSwap = tokensForLiquidity +
1515             tokensForMarketing +
1516             tokensForDev;
1517         bool success;
1518 
1519         if (contractBalance == 0 || totalTokensToSwap == 0) {
1520             return;
1521         }
1522 
1523         if (contractBalance > swapTokensAtAmount * 20) {
1524             contractBalance = swapTokensAtAmount * 20;
1525         }
1526 
1527         // Halve the amount of liquidity tokens
1528         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1529             totalTokensToSwap /
1530             2;
1531         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1532 
1533         uint256 initialETHBalance = address(this).balance;
1534 
1535         swapTokensForEth(amountToSwapForETH);
1536 
1537         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1538 
1539         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1540             totalTokensToSwap
1541         );
1542         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1543 
1544         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1545 
1546         tokensForLiquidity = 0;
1547         tokensForMarketing = 0;
1548         tokensForDev = 0;
1549 
1550         (success, ) = address(devWallet).call{value: ethForDev}("");
1551 
1552         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1553             addLiquidity(liquidityTokens, ethForLiquidity);
1554             emit SwapAndLiquify(
1555                 amountToSwapForETH,
1556                 ethForLiquidity,
1557                 tokensForLiquidity
1558             );
1559         }
1560 
1561         (success, ) = address(marketingWallet).call{
1562             value: address(this).balance
1563         }("");
1564     }
1565 
1566     function setAutoLPBurnSettings(
1567         uint256 _frequencyInSeconds,
1568         uint256 _percent,
1569         bool _Enabled
1570     ) external onlyOwner {
1571         require(
1572             _frequencyInSeconds >= 600,
1573             "cannot set buyback more often than every 10 minutes"
1574         );
1575         require(
1576             _percent <= 1000 && _percent >= 0,
1577             "Must set auto LP burn percent between 0% and 10%"
1578         );
1579         lpBurnFrequency = _frequencyInSeconds;
1580         percentForLPBurn = _percent;
1581         lpBurnEnabled = _Enabled;
1582     }
1583 
1584     function autoBurnLiquidityPairTokens() internal returns (bool) {
1585         lastLpBurnTime = block.timestamp;
1586 
1587         // get balance of liquidity pair
1588         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1589 
1590         // calculate amount to burn
1591         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1592             10000
1593         );
1594 
1595         // pull tokens from pancakePair liquidity and move to dead address permanently
1596         if (amountToBurn > 0) {
1597             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1598         }
1599 
1600         //sync price since this is not in a swap transaction!
1601         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1602         pair.sync();
1603         emit AutoNukeLP();
1604         return true;
1605     }
1606 
1607     function manualBurnLiquidityPairTokens(uint256 percent)
1608         external
1609         onlyOwner
1610         returns (bool)
1611     {
1612         require(
1613             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1614             "Must wait for cooldown to finish"
1615         );
1616         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1617         lastManualLpBurnTime = block.timestamp;
1618 
1619         // get balance of liquidity pair
1620         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1621 
1622         // calculate amount to burn
1623         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1624 
1625         // pull tokens from pancakePair liquidity and move to dead address permanently
1626         if (amountToBurn > 0) {
1627             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1628         }
1629 
1630         //sync price since this is not in a swap transaction!
1631         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1632         pair.sync();
1633         emit ManualNukeLP();
1634         return true;
1635     }
1636 }