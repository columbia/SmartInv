1 // SPDX-License-Identifier: GPL-3.0
2 
3 pragma solidity ^0.8.19;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13     
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:https://github.com/ethereum/solidity/issues/2691 
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations.
81  *
82  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
83  * now has built in overflow checking.
84  */
85 
86 library SafeMath {
87     /**
88      * @dev Returns the addition of two unsigned integers, with an overflow flag.
89      *
90      * _Available since v3.4._
91      */
92     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
93         unchecked {
94             uint256 c = a + b;
95             if (c < a) return (false, 0);
96             return (true, c);
97         }
98     }
99 
100     /**
101      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
102      *
103      * _Available since v3.4._
104      */
105     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
106         unchecked {
107             if (b > a) return (false, 0);
108             return (true, a - b);
109         }
110     }
111 
112     /**
113      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
114      *
115      * _Available since v3.4._
116      */
117     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
118         unchecked {
119             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
120             // benefit is lost if 'b' is also tested.
121             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
122             if (a == 0) return (true, 0);
123             uint256 c = a * b;
124             if (c / a != b) return (false, 0);
125             return (true, c);
126         }
127     }
128 
129     /**
130      * @dev Returns the division of two unsigned integers, with a division by zero flag.
131      *
132      * _Available since v3.4._
133      */
134     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
135         unchecked {
136             if (b == 0) return (false, 0);
137             return (true, a / b);
138         }
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
143      *
144      * _Available since v3.4._
145      */
146     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
147         unchecked {
148             if (b == 0) return (false, 0);
149             return (true, a % b);
150         }
151     }
152 
153     /**
154      * @dev Returns the addition of two unsigned integers, reverting on
155      * overflow.
156      *
157      * Counterpart to Solidity's `+` operator.
158      *
159      * Requirements:
160      *
161      * - Addition cannot overflow.
162      */
163     function add(uint256 a, uint256 b) internal pure returns (uint256) {
164         return a + b;
165     }
166 
167     /**
168      * @dev Returns the subtraction of two unsigned integers, reverting on
169      * overflow (when the result is negative).
170      *
171      * Counterpart to Solidity's `-` operator.
172      *
173      * Requirements:
174      *
175      * - Subtraction cannot overflow.
176      */
177     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
178         return a - b;
179     }
180 
181     /**
182      * @dev Returns the multiplication of two unsigned integers, reverting on
183      * overflow.
184      *
185      * Counterpart to Solidity's `*` operator.
186      *
187      * Requirements:
188      *
189      * - Multiplication cannot overflow.
190      */
191     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
192         return a * b;
193     }
194 
195     /**
196      * @dev Returns the integer division of two unsigned integers, reverting on
197      * division by zero. The result is rounded towards zero.
198      *
199      * Counterpart to Solidity's `/` operator.
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function div(uint256 a, uint256 b) internal pure returns (uint256) {
206         return a / b;
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * reverting when dividing by zero.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222         return a % b;
223     }
224 
225     /**
226      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
227      * overflow (when the result is negative).
228      *
229      * CAUTION: This function is deprecated because it requires allocating memory for the error
230      * message unnecessarily. For custom revert reasons use {trySub}.
231      *
232      * Counterpart to Solidity's `-` operator.
233      *
234      * Requirements:
235      *
236      * - Subtraction cannot overflow.
237      */
238     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
239         unchecked {
240             require(b <= a, errorMessage);
241             return a - b;
242         }
243     }
244 
245     /**
246      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
247      * division by zero. The result is rounded towards zero.
248      *
249      * Counterpart to Solidity's `/` operator. Note: this function uses a
250      * `revert` opcode (which leaves remaining gas untouched) while Solidity
251      * uses an invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function div(
258         uint256 a,
259         uint256 b,
260         string memory errorMessage
261     ) internal pure returns (uint256) {
262         unchecked {
263             require(b > 0, errorMessage);
264             return a / b;
265         }
266     }
267 
268     /**
269      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
270      * reverting with custom message when dividing by zero.
271      *
272      * CAUTION: This function is deprecated because it requires allocating memory for the error
273      * message unnecessarily. For custom revert reasons use {tryMod}.
274      *
275      * Counterpart to Solidity's `%` operator. This function uses a `revert`
276      * opcode (which leaves remaining gas untouched) while Solidity uses an
277      * invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      *
281      * - The divisor cannot be zero.
282      */
283     function mod(
284         uint256 a,
285         uint256 b,
286         string memory errorMessage
287     ) internal pure returns (uint256) {
288         unchecked {
289             require(b > 0, errorMessage);
290             return a % b;
291         }
292     }
293 }
294 
295 /**
296  * @dev Provides information about the current execution context, including the
297  * sender of the transaction and its data. While these are generally available
298  * via msg.sender and msg.data, they should not be accessed in such a direct
299  * manner, since when dealing with meta-transactions the account sending and
300  * paying for execution may not be the actual sender (as far as an application
301  * is concerned).
302  *
303  * This contract is only required for intermediate, library-like contracts.
304  */
305 abstract contract Context {
306     function _msgSender() internal view virtual returns (address) {
307         return msg.sender;
308     }
309 
310     function _msgData() internal view virtual returns (bytes calldata) {
311         this; // silence state mutability warning without generating bytecode - see 
312         return msg.data;
313     }
314 }
315 
316 /**
317  * @dev Contract module which provides a basic access control mechanism, where
318  * there is an account (an owner) that can be granted exclusive access to
319  * specific functions.
320  *
321  * By default, the owner account will be the one that deploys the contract. This
322  * can later be changed with {transferOwnership}.
323  *
324  * This module is used through inheritance. It will make available the modifier
325  * `onlyOwner`, which can be applied to your functions to restrict their use to
326  * the owner.
327  */
328 abstract contract Ownable is Context {
329     address private _owner;
330 
331     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
332 
333     /**
334      * @dev Initializes the contract setting the deployer as the initial owner.
335      */
336     constructor() {
337         _transferOwnership(_msgSender());
338     }
339 
340     /**
341      * @dev Returns the address of the current owner.
342      */
343     function owner() public view virtual returns (address) {
344         return _owner;
345     }
346 
347     /**
348      * @dev Throws if called by any account other than the owner.
349      */
350     modifier onlyOwner() {
351         require(owner() == _msgSender(), "Ownable: caller is not the owner");
352         _;
353     }
354 
355     /**
356      * @dev Leaves the contract without owner. It will not be possible to call
357      * `onlyOwner` functions anymore. Can only be called by the current owner.
358      *
359      * NOTE: Renouncing ownership will leave the contract without an owner,
360      * thereby removing any functionality that is only available to the owner.
361      */
362     function renounceOwnership() public virtual onlyOwner {
363         _transferOwnership(address(0));
364     }
365 
366     /**
367      * @dev Transfers ownership of the contract to a new account (`newOwner`).
368      * Can only be called by the current owner.
369      */
370     function transferOwnership(address newOwner) public virtual onlyOwner {
371         require(newOwner != address(0), "Ownable: new owner is the zero address");
372         _transferOwnership(newOwner);
373     }
374 
375     /**
376      * @dev Transfers ownership of the contract to a new account (`newOwner`).
377      * Internal function without access restriction.
378      */
379     function _transferOwnership(address newOwner) internal virtual {
380         address oldOwner = _owner;
381         _owner = newOwner;
382         emit OwnershipTransferred(oldOwner, newOwner);
383     }
384 }
385 
386 /**
387  * @dev Interface for the optional metadata functions from the ERC20 standard.
388  *
389  * _Available since v4.1._
390  */
391 interface IERC20Metadata is IERC20 {
392     /**
393      * @dev Returns the name of the token.
394      */
395     function name() external view returns (string memory);
396 
397     /**
398      * @dev Returns the symbol of the token.
399      */
400     function symbol() external view returns (string memory);
401 
402     /**
403      * @dev Returns the decimals places of the token.
404      */
405     function decimals() external view returns (uint8);
406 }
407 
408 /**
409  * @dev Implementation of the {IERC20} interface.
410  *
411  * This implementation is agnostic to the way tokens are created. This means
412  * that a supply mechanism has to be added in a derived contract using {_mint}.
413  * For a generic mechanism see {ERC20PresetMinterPauser}.
414  *
415  * TIP: For a detailed writeup see our guide
416  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
417  * to implement supply mechanisms].
418  *
419  * We have followed general OpenZeppelin Contracts guidelines: functions revert
420  * instead returning `false` on failure. This behavior is nonetheless
421  * conventional and does not conflict with the expectations of ERC20
422  * applications.
423  *
424  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
425  * This allows applications to reconstruct the allowance for all accounts just
426  * by listening to said events. Other implementations of the EIP may not emit
427  * these events, as it isn't required by the specification.
428  *
429  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
430  * functions have been added to mitigate the well-known issues around setting
431  * allowances. See {IERC20-approve}.
432  */
433 contract ERC20 is Context, IERC20, IERC20Metadata {
434     mapping(address => uint256) private _balances;
435 
436     mapping(address => mapping(address => uint256)) private _allowances;
437 
438     uint256 private _totalSupply;
439 
440     string private _name;
441     string private _symbol;
442 
443     /**
444      * @dev Sets the values for {name} and {symbol}.
445      *
446      * The default value of {decimals} is 18. To select a different value for
447      * {decimals} you should overload it.
448      *
449      * All two of these values are immutable: they can only be set once during
450      * construction.
451      */
452     constructor(string memory name_, string memory symbol_) {
453         _name = name_;
454         _symbol = symbol_;
455     }
456 
457     /**
458      * @dev Returns the name of the token.
459      */
460     function name() public view virtual override returns (string memory) {
461         return _name;
462     }
463 
464     /**
465      * @dev Returns the symbol of the token, usually a shorter version of the
466      * name.
467      */
468     function symbol() public view virtual override returns (string memory) {
469         return _symbol;
470     }
471 
472     /**
473      * @dev Returns the number of decimals used to get its user representation.
474      * For example, if `decimals` equals `2`, a balance of `505` tokens should
475      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
476      *
477      * Tokens usually opt for a value of 18, imitating the relationship between
478      * Ether and Wei. This is the value {ERC20} uses, unless this function is
479      * overridden;
480      *
481      * NOTE: This information is only used for _display_ purposes: it in
482      * no way affects any of the arithmetic of the contract, including
483      * {IERC20-balanceOf} and {IERC20-transfer}.
484      */
485     function decimals() public view virtual override returns (uint8) {
486         return 9;
487     }
488 
489     /**
490      * @dev See {IERC20-totalSupply}.
491      */
492     function totalSupply() public view virtual override returns (uint256) {
493         return _totalSupply;
494     }
495 
496     /**
497      * @dev See {IERC20-balanceOf}.
498      */
499     function balanceOf(address account) public view virtual override returns (uint256) {
500         return _balances[account];
501     }
502 
503     /**
504      * @dev See {IERC20-transfer}.
505      *
506      * Requirements:
507      *
508      * - `recipient` cannot be the zero address.
509      * - the caller must have a balance of at least `amount`.
510      */
511     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
512         _transfer(_msgSender(), recipient, amount);
513         return true;
514     }
515 
516     /**
517      * @dev See {IERC20-allowance}.
518      */
519     function allowance(address owner, address spender) public view virtual override returns (uint256) {
520         return _allowances[owner][spender];
521     }
522 
523     /**
524      * @dev See {IERC20-approve}.
525      *
526      * Requirements:
527      *
528      * - `spender` cannot be the zero address.
529      */
530     function approve(address spender, uint256 amount) public virtual override returns (bool) {
531         _approve(_msgSender(), spender, amount);
532         return true;
533     }
534 
535     /**
536      * @dev See {IERC20-transferFrom}.
537      *
538      * Emits an {Approval} event indicating the updated allowance. This is not
539      * required by the EIP. See the note at the beginning of {ERC20}.
540      *
541      * Requirements:
542      *
543      * - `sender` and `recipient` cannot be the zero address.
544      * - `sender` must have a balance of at least `amount`.
545      * - the caller must have allowance for ``sender``'s tokens of at least
546      * `amount`.
547      */
548     function transferFrom(
549         address sender,
550         address recipient,
551         uint256 amount
552     ) public virtual override returns (bool) {
553         _transfer(sender, recipient, amount);
554 
555         uint256 currentAllowance = _allowances[sender][_msgSender()];
556         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
557         unchecked {
558             _approve(sender, _msgSender(), currentAllowance - amount);
559         }
560 
561         return true;
562     }
563 
564     /**
565      * @dev Atomically increases the allowance granted to `spender` by the caller.
566      *
567      * This is an alternative to {approve} that can be used as a mitigation for
568      * problems described in {IERC20-approve}.
569      *
570      * Emits an {Approval} event indicating the updated allowance.
571      *
572      * Requirements:
573      *
574      * - `spender` cannot be the zero address.
575      */
576     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
577         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
578         return true;
579     }
580 
581     /**
582      * @dev Atomically decreases the allowance granted to `spender` by the caller.
583      *
584      * This is an alternative to {approve} that can be used as a mitigation for
585      * problems described in {IERC20-approve}.
586      *
587      * Emits an {Approval} event indicating the updated allowance.
588      *
589      * Requirements:
590      *
591      * - `spender` cannot be the zero address.
592      * - `spender` must have allowance for the caller of at least
593      * `subtractedValue`.
594      */
595     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
596         uint256 currentAllowance = _allowances[_msgSender()][spender];
597         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
598         unchecked {
599             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
600         }
601 
602         return true;
603     }
604 
605     /**
606      * @dev Moves `amount` of tokens from `sender` to `recipient`.
607      *
608      * This internal function is equivalent to {transfer}, and can be used to
609      * e.g. implement automatic token fees, slashing mechanisms, etc.
610      *
611      * Emits a {Transfer} event.
612      *
613      * Requirements:
614      *
615      * - `sender` cannot be the zero address.
616      * - `recipient` cannot be the zero address.
617      * - `sender` must have a balance of at least `amount`.
618      */
619     function _transfer(
620         address sender,
621         address recipient,
622         uint256 amount
623     ) internal virtual {
624         require(sender != address(0), "ERC20: transfer from the zero address");
625         require(recipient != address(0), "ERC20: transfer to the zero address");
626 
627         _beforeTokenTransfer(sender, recipient, amount);
628 
629         uint256 senderBalance = _balances[sender];
630         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
631         unchecked {
632             _balances[sender] = senderBalance - amount;
633         }
634         _balances[recipient] += amount;
635 
636         emit Transfer(sender, recipient, amount);
637 
638         _afterTokenTransfer(sender, recipient, amount);
639     }
640 
641     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
642      * the total supply.
643      *
644      * Emits a {Transfer} event with `from` set to the zero address.
645      *
646      * Requirements:
647      *
648      * - `account` cannot be the zero address.
649      */
650     function _mint(address account, uint256 amount) internal virtual {
651         require(account != address(0), "ERC20: mint to the zero address");
652 
653         _beforeTokenTransfer(address(0), account, amount);
654 
655         _totalSupply += amount;
656         _balances[account] += amount;
657         emit Transfer(address(0), account, amount);
658 
659         _afterTokenTransfer(address(0), account, amount);
660     }
661 
662     /**
663      * @dev Destroys `amount` tokens from `account`, reducing the
664      * total supply.
665      *
666      * Emits a {Transfer} event with `to` set to the zero address.
667      *
668      * Requirements:
669      *
670      * - `account` cannot be the zero address.
671      * - `account` must have at least `amount` tokens.
672      */
673     function _burn(address account, uint256 amount) internal virtual {
674         require(account != address(0), "ERC20: burn from the zero address");
675 
676         _beforeTokenTransfer(account, address(0), amount);
677 
678         uint256 accountBalance = _balances[account];
679         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
680         unchecked {
681             _balances[account] = accountBalance - amount;
682         }
683         _totalSupply -= amount;
684 
685         emit Transfer(account, address(0), amount);
686 
687         _afterTokenTransfer(account, address(0), amount);
688     }
689 
690     /**
691      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
692      *
693      * This internal function is equivalent to `approve`, and can be used to
694      * e.g. set automatic allowances for certain subsystems, etc.
695      *
696      * Emits an {Approval} event.
697      *
698      * Requirements:
699      *
700      * - `owner` cannot be the zero address.
701      * - `spender` cannot be the zero address.
702      */
703     function _approve(
704         address owner,
705         address spender,
706         uint256 amount
707     ) internal virtual {
708         require(owner != address(0), "ERC20: approve from the zero address");
709         require(spender != address(0), "ERC20: approve to the zero address");
710 
711         _allowances[owner][spender] = amount;
712         emit Approval(owner, spender, amount);
713     }
714 
715     /**
716      * @dev Hook that is called before any transfer of tokens. This includes
717      * minting and burning.
718      *
719      * Calling conditions:
720      *
721      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
722      * will be transferred to `to`.
723      * - when `from` is zero, `amount` tokens will be minted for `to`.
724      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
725      * - `from` and `to` are never both zero.
726      *
727      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
728      */
729     function _beforeTokenTransfer(
730         address from,
731         address to,
732         uint256 amount
733     ) internal virtual {}
734 
735     /**
736      * @dev Hook that is called after any transfer of tokens. This includes
737      * minting and burning.
738      *
739      * Calling conditions:
740      *
741      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
742      * has been transferred to `to`.
743      * - when `from` is zero, `amount` tokens have been minted for `to`.
744      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
745      * - `from` and `to` are never both zero.
746      *
747      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
748      */
749     function _afterTokenTransfer(
750         address from,
751         address to,
752         uint256 amount
753     ) internal virtual {}
754 }
755 
756 contract VisionCity is ERC20, Ownable {
757     using SafeMath for uint256;
758 
759     mapping(address => bool) private _isExcludedFromFees;
760 
761     uint256 public buyTax;
762     uint256 private buyDevFee;
763 
764     uint256 public sellTax;
765     uint256 private sellDevFee;
766 
767     address public devWallet; 
768     uint256 private tokensForDev;
769 
770     event ExcludeFromFees(address indexed account, bool isExcluded);
771     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
772 
773     constructor() ERC20("Vision City", "VIZ") {
774         uint256 _buyDevFee = 3;
775         uint256 _sellDevFee = 3;
776 
777         uint256 totalSupply = 300 * 10**9 * 10**9;
778 
779         buyDevFee = _buyDevFee;
780         buyTax = buyDevFee;
781 
782         sellDevFee = _sellDevFee;
783         sellTax = sellDevFee;
784 
785         devWallet = address(0x2F240C6C0f8d78e4435655cE7f853510eeeC6FBF);
786 
787         excludeFromFees(owner(), true);
788         excludeFromFees(address(this), true);
789 
790         _mint(msg.sender, totalSupply);
791     }
792 
793     receive() external payable {}
794 
795     function setBuyFees(uint256 _devFee) external onlyOwner {
796         buyDevFee = _devFee;
797         buyTax = buyDevFee;
798     }
799 
800     function setSellFees(uint256 _devFee) external onlyOwner {
801         sellDevFee = _devFee;
802         sellTax = sellDevFee;
803     }
804 
805     function excludeFromFees(address account, bool excluded) public onlyOwner {
806         _isExcludedFromFees[account] = excluded;
807         emit ExcludeFromFees(account, excluded);
808     }
809 
810     function setDevWallet(address newWallet) external onlyOwner {
811         emit devWalletUpdated(newWallet, devWallet);
812         devWallet = newWallet;
813     }
814 
815     function isExcludedFromFees(address account) public view returns (bool) {
816         return _isExcludedFromFees[account];
817     }
818 
819     function _transfer(address from, address to, uint256 amount) internal override {
820         require(from != address(0), "ERC20: transfer from the zero address");
821         require(to != address(0), "ERC20: transfer to the zero address");
822 
823         if (amount == 0) {
824             super._transfer(from, to, 0);
825             return;
826         }
827 
828         bool takeFee = true;
829 
830         // if any account belongs to _isExcludedFromFee account then remove the fee
831         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
832             takeFee = false;
833         }
834 
835         uint256 fees = sellDevFee;
836         
837         if (takeFee) 
838         {
839             if (fees > 0) 
840             {
841                 fees = amount.mul(sellTax).div(100);
842                 tokensForDev += (fees * sellDevFee) / sellTax;
843             }
844             else {
845                 fees = amount.mul(buyTax).div(100);
846                 tokensForDev += (fees * buyDevFee) / buyTax;
847             }
848             if (fees > 0) {
849                 super._transfer(from, address(devWallet), fees);
850             }
851             amount -= fees;
852         }
853 
854         super._transfer(from, to, amount);
855     }
856 
857     function withdrawEthFromSc() external onlyOwner () {
858         uint256 balance = address(this).balance;
859         payable(owner()).transfer(balance);
860     }
861     
862     function withdrawTokenFromSc(address _tokenContract, uint256 _amount) external onlyOwner {
863         IERC20 tokenContract = IERC20(_tokenContract);
864         tokenContract.transfer(msg.sender, _amount);
865     }  
866 }