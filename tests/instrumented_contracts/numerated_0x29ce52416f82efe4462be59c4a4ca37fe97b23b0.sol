1 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
2 pragma experimental ABIEncoderV2;
3 
4 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
5 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
6 
7 /* pragma solidity ^0.8.0; */
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
30 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
31 
32 /* pragma solidity ^0.8.0; */
33 
34 /* import "../utils/Context.sol"; */
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
107 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
108 
109 /* pragma solidity ^0.8.0; */
110 
111 /**
112  * @dev Interface of the ERC20 standard as defined in the EIP.
113  */
114 interface IERC20 {
115     /**
116      * @dev Returns the amount of tokens in existence.
117      */
118     function totalSupply() external view returns (uint256);
119 
120     /**
121      * @dev Returns the amount of tokens owned by `account`.
122      */
123     function balanceOf(address account) external view returns (uint256);
124 
125     /**
126      * @dev Moves `amount` tokens from the caller's account to `recipient`.
127      *
128      * Returns a boolean value indicating whether the operation succeeded.
129      *
130      * Emits a {Transfer} event.
131      */
132     function transfer(address recipient, uint256 amount) external returns (bool);
133 
134     /**
135      * @dev Returns the remaining number of tokens that `spender` will be
136      * allowed to spend on behalf of `owner` through {transferFrom}. This is
137      * zero by default.
138      *
139      * This value changes when {approve} or {transferFrom} are called.
140      */
141     function allowance(address owner, address spender) external view returns (uint256);
142 
143     /**
144      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
145      *
146      * Returns a boolean value indicating whether the operation succeeded.
147      *
148      * IMPORTANT: Beware that changing an allowance with this method brings the risk
149      * that someone may use both the old and the new allowance by unfortunate
150      * transaction ordering. One possible solution to mitigate this race
151      * condition is to first reduce the spender's allowance to 0 and set the
152      * desired value afterwards:
153      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154      *
155      * Emits an {Approval} event.
156      */
157     function approve(address spender, uint256 amount) external returns (bool);
158 
159     /**
160      * @dev Moves `amount` tokens from `sender` to `recipient` using the
161      * allowance mechanism. `amount` is then deducted from the caller's
162      * allowance.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * Emits a {Transfer} event.
167      */
168     function transferFrom(
169         address sender,
170         address recipient,
171         uint256 amount
172     ) external returns (bool);
173 
174     /**
175      * @dev Emitted when `value` tokens are moved from one account (`from`) to
176      * another (`to`).
177      *
178      * Note that `value` may be zero.
179      */
180     event Transfer(address indexed from, address indexed to, uint256 value);
181 
182     /**
183      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
184      * a call to {approve}. `value` is the new allowance.
185      */
186     event Approval(address indexed owner, address indexed spender, uint256 value);
187 }
188 
189 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
190 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
191 
192 /* pragma solidity ^0.8.0; */
193 
194 /* import "../IERC20.sol"; */
195 
196 /**
197  * @dev Interface for the optional metadata functions from the ERC20 standard.
198  *
199  * _Available since v4.1._
200  */
201 interface IERC20Metadata is IERC20 {
202     /**
203      * @dev Returns the name of the token.
204      */
205     function name() external view returns (string memory);
206 
207     /**
208      * @dev Returns the symbol of the token.
209      */
210     function symbol() external view returns (string memory);
211 
212     /**
213      * @dev Returns the decimals places of the token.
214      */
215     function decimals() external view returns (uint8);
216 }
217 
218 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
219 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
220 
221 /* pragma solidity ^0.8.0; */
222 
223 /* import "./IERC20.sol"; */
224 /* import "./extensions/IERC20Metadata.sol"; */
225 /* import "../../utils/Context.sol"; */
226 
227 /**
228  * @dev Implementation of the {IERC20} interface.
229  *
230  * This implementation is agnostic to the way tokens are created. This means
231  * that a supply mechanism has to be added in a derived contract using {_mint}.
232  * For a generic mechanism see {ERC20PresetMinterPauser}.
233  *
234  * TIP: For a detailed writeup see our guide
235  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
236  * to implement supply mechanisms].
237  *
238  * We have followed general OpenZeppelin Contracts guidelines: functions revert
239  * instead returning `false` on failure. This behavior is nonetheless
240  * conventional and does not conflict with the expectations of ERC20
241  * applications.
242  *
243  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
244  * This allows applications to reconstruct the allowance for all accounts just
245  * by listening to said events. Other implementations of the EIP may not emit
246  * these events, as it isn't required by the specification.
247  *
248  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
249  * functions have been added to mitigate the well-known issues around setting
250  * allowances. See {IERC20-approve}.
251  */
252 contract ERC20 is Context, IERC20, IERC20Metadata {
253     mapping(address => uint256) private _balances;
254 
255     mapping(address => mapping(address => uint256)) private _allowances;
256 
257     uint256 private _totalSupply;
258 
259     string private _name;
260     string private _symbol;
261 
262     /**
263      * @dev Sets the values for {name} and {symbol}.
264      *
265      * The default value of {decimals} is 18. To select a different value for
266      * {decimals} you should overload it.
267      *
268      * All two of these values are immutable: they can only be set once during
269      * construction.
270      */
271     constructor(string memory name_, string memory symbol_) {
272         _name = name_;
273         _symbol = symbol_;
274     }
275 
276     /**
277      * @dev Returns the name of the token.
278      */
279     function name() public view virtual override returns (string memory) {
280         return _name;
281     }
282 
283     /**
284      * @dev Returns the symbol of the token, usually a shorter version of the
285      * name.
286      */
287     function symbol() public view virtual override returns (string memory) {
288         return _symbol;
289     }
290 
291     /**
292      * @dev Returns the number of decimals used to get its user representation.
293      * For example, if `decimals` equals `2`, a balance of `505` tokens should
294      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
295      *
296      * Tokens usually opt for a value of 18, imitating the relationship between
297      * Ether and Wei. This is the value {ERC20} uses, unless this function is
298      * overridden;
299      *
300      * NOTE: This information is only used for _display_ purposes: it in
301      * no way affects any of the arithmetic of the contract, including
302      * {IERC20-balanceOf} and {IERC20-transfer}.
303      */
304     function decimals() public view virtual override returns (uint8) {
305         return 18;
306     }
307 
308     /**
309      * @dev See {IERC20-totalSupply}.
310      */
311     function totalSupply() public view virtual override returns (uint256) {
312         return _totalSupply;
313     }
314 
315     /**
316      * @dev See {IERC20-balanceOf}.
317      */
318     function balanceOf(address account) public view virtual override returns (uint256) {
319         return _balances[account];
320     }
321 
322     /**
323      * @dev See {IERC20-transfer}.
324      *
325      * Requirements:
326      *
327      * - `recipient` cannot be the zero address.
328      * - the caller must have a balance of at least `amount`.
329      */
330     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
331         _transfer(_msgSender(), recipient, amount);
332         return true;
333     }
334 
335     /**
336      * @dev See {IERC20-allowance}.
337      */
338     function allowance(address owner, address spender) public view virtual override returns (uint256) {
339         return _allowances[owner][spender];
340     }
341 
342     /**
343      * @dev See {IERC20-approve}.
344      *
345      * Requirements:
346      *
347      * - `spender` cannot be the zero address.
348      */
349     function approve(address spender, uint256 amount) public virtual override returns (bool) {
350         _approve(_msgSender(), spender, amount);
351         return true;
352     }
353 
354     /**
355      * @dev See {IERC20-transferFrom}.
356      *
357      * Emits an {Approval} event indicating the updated allowance. This is not
358      * required by the EIP. See the note at the beginning of {ERC20}.
359      *
360      * Requirements:
361      *
362      * - `sender` and `recipient` cannot be the zero address.
363      * - `sender` must have a balance of at least `amount`.
364      * - the caller must have allowance for ``sender``'s tokens of at least
365      * `amount`.
366      */
367     function transferFrom(
368         address sender,
369         address recipient,
370         uint256 amount
371     ) public virtual override returns (bool) {
372         _transfer(sender, recipient, amount);
373 
374         uint256 currentAllowance = _allowances[sender][_msgSender()];
375         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
376         unchecked {
377             _approve(sender, _msgSender(), currentAllowance - amount);
378         }
379 
380         return true;
381     }
382 
383     /**
384      * @dev Atomically increases the allowance granted to `spender` by the caller.
385      *
386      * This is an alternative to {approve} that can be used as a mitigation for
387      * problems described in {IERC20-approve}.
388      *
389      * Emits an {Approval} event indicating the updated allowance.
390      *
391      * Requirements:
392      *
393      * - `spender` cannot be the zero address.
394      */
395     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
396         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
397         return true;
398     }
399 
400     /**
401      * @dev Atomically decreases the allowance granted to `spender` by the caller.
402      *
403      * This is an alternative to {approve} that can be used as a mitigation for
404      * problems described in {IERC20-approve}.
405      *
406      * Emits an {Approval} event indicating the updated allowance.
407      *
408      * Requirements:
409      *
410      * - `spender` cannot be the zero address.
411      * - `spender` must have allowance for the caller of at least
412      * `subtractedValue`.
413      */
414     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
415         uint256 currentAllowance = _allowances[_msgSender()][spender];
416         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
417         unchecked {
418             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
419         }
420 
421         return true;
422     }
423 
424     /**
425      * @dev Moves `amount` of tokens from `sender` to `recipient`.
426      *
427      * This internal function is equivalent to {transfer}, and can be used to
428      * e.g. implement automatic token fees, slashing mechanisms, etc.
429      *
430      * Emits a {Transfer} event.
431      *
432      * Requirements:
433      *
434      * - `sender` cannot be the zero address.
435      * - `recipient` cannot be the zero address.
436      * - `sender` must have a balance of at least `amount`.
437      */
438     function _transfer(
439         address sender,
440         address recipient,
441         uint256 amount
442     ) internal virtual {
443         require(sender != address(0), "ERC20: transfer from the zero address");
444         require(recipient != address(0), "ERC20: transfer to the zero address");
445 
446         _beforeTokenTransfer(sender, recipient, amount);
447 
448         uint256 senderBalance = _balances[sender];
449         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
450         unchecked {
451             _balances[sender] = senderBalance - amount;
452         }
453         _balances[recipient] += amount;
454 
455         emit Transfer(sender, recipient, amount);
456 
457         _afterTokenTransfer(sender, recipient, amount);
458     }
459 
460     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
461      * the total supply.
462      *
463      * Emits a {Transfer} event with `from` set to the zero address.
464      *
465      * Requirements:
466      *
467      * - `account` cannot be the zero address.
468      */
469     function _mint(address account, uint256 amount) internal virtual {
470         require(account != address(0), "ERC20: mint to the zero address");
471 
472         _beforeTokenTransfer(address(0), account, amount);
473 
474         _totalSupply += amount;
475         _balances[account] += amount;
476         emit Transfer(address(0), account, amount);
477 
478         _afterTokenTransfer(address(0), account, amount);
479     }
480 
481     /**
482      * @dev Destroys `amount` tokens from `account`, reducing the
483      * total supply.
484      *
485      * Emits a {Transfer} event with `to` set to the zero address.
486      *
487      * Requirements:
488      *
489      * - `account` cannot be the zero address.
490      * - `account` must have at least `amount` tokens.
491      */
492     function _burn(address account, uint256 amount) internal virtual {
493         require(account != address(0), "ERC20: burn from the zero address");
494 
495         _beforeTokenTransfer(account, address(0), amount);
496 
497         uint256 accountBalance = _balances[account];
498         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
499         unchecked {
500             _balances[account] = accountBalance - amount;
501         }
502         _totalSupply -= amount;
503 
504         emit Transfer(account, address(0), amount);
505 
506         _afterTokenTransfer(account, address(0), amount);
507     }
508 
509     /**
510      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
511      *
512      * This internal function is equivalent to `approve`, and can be used to
513      * e.g. set automatic allowances for certain subsystems, etc.
514      *
515      * Emits an {Approval} event.
516      *
517      * Requirements:
518      *
519      * - `owner` cannot be the zero address.
520      * - `spender` cannot be the zero address.
521      */
522     function _approve(
523         address owner,
524         address spender,
525         uint256 amount
526     ) internal virtual {
527         require(owner != address(0), "ERC20: approve from the zero address");
528         require(spender != address(0), "ERC20: approve to the zero address");
529 
530         _allowances[owner][spender] = amount;
531         emit Approval(owner, spender, amount);
532     }
533 
534     /**
535      * @dev Hook that is called before any transfer of tokens. This includes
536      * minting and burning.
537      *
538      * Calling conditions:
539      *
540      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
541      * will be transferred to `to`.
542      * - when `from` is zero, `amount` tokens will be minted for `to`.
543      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
544      * - `from` and `to` are never both zero.
545      *
546      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
547      */
548     function _beforeTokenTransfer(
549         address from,
550         address to,
551         uint256 amount
552     ) internal virtual {}
553 
554     /**
555      * @dev Hook that is called after any transfer of tokens. This includes
556      * minting and burning.
557      *
558      * Calling conditions:
559      *
560      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
561      * has been transferred to `to`.
562      * - when `from` is zero, `amount` tokens have been minted for `to`.
563      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
564      * - `from` and `to` are never both zero.
565      *
566      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
567      */
568     function _afterTokenTransfer(
569         address from,
570         address to,
571         uint256 amount
572     ) internal virtual {}
573 }
574 
575 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
576 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
577 
578 /* pragma solidity ^0.8.0; */
579 
580 // CAUTION
581 // This version of SafeMath should only be used with Solidity 0.8 or later,
582 // because it relies on the compiler's built in overflow checks.
583 
584 /**
585  * @dev Wrappers over Solidity's arithmetic operations.
586  *
587  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
588  * now has built in overflow checking.
589  */
590 library SafeMath {
591     /**
592      * @dev Returns the addition of two unsigned integers, with an overflow flag.
593      *
594      * _Available since v3.4._
595      */
596     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
597         unchecked {
598             uint256 c = a + b;
599             if (c < a) return (false, 0);
600             return (true, c);
601         }
602     }
603 
604     /**
605      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
606      *
607      * _Available since v3.4._
608      */
609     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
610         unchecked {
611             if (b > a) return (false, 0);
612             return (true, a - b);
613         }
614     }
615 
616     /**
617      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
618      *
619      * _Available since v3.4._
620      */
621     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
622         unchecked {
623             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
624             // benefit is lost if 'b' is also tested.
625             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
626             if (a == 0) return (true, 0);
627             uint256 c = a * b;
628             if (c / a != b) return (false, 0);
629             return (true, c);
630         }
631     }
632 
633     /**
634      * @dev Returns the division of two unsigned integers, with a division by zero flag.
635      *
636      * _Available since v3.4._
637      */
638     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
639         unchecked {
640             if (b == 0) return (false, 0);
641             return (true, a / b);
642         }
643     }
644 
645     /**
646      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
647      *
648      * _Available since v3.4._
649      */
650     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
651         unchecked {
652             if (b == 0) return (false, 0);
653             return (true, a % b);
654         }
655     }
656 
657     /**
658      * @dev Returns the addition of two unsigned integers, reverting on
659      * overflow.
660      *
661      * Counterpart to Solidity's `+` operator.
662      *
663      * Requirements:
664      *
665      * - Addition cannot overflow.
666      */
667     function add(uint256 a, uint256 b) internal pure returns (uint256) {
668         return a + b;
669     }
670 
671     /**
672      * @dev Returns the subtraction of two unsigned integers, reverting on
673      * overflow (when the result is negative).
674      *
675      * Counterpart to Solidity's `-` operator.
676      *
677      * Requirements:
678      *
679      * - Subtraction cannot overflow.
680      */
681     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
682         return a - b;
683     }
684 
685     /**
686      * @dev Returns the multiplication of two unsigned integers, reverting on
687      * overflow.
688      *
689      * Counterpart to Solidity's `*` operator.
690      *
691      * Requirements:
692      *
693      * - Multiplication cannot overflow.
694      */
695     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
696         return a * b;
697     }
698 
699     /**
700      * @dev Returns the integer division of two unsigned integers, reverting on
701      * division by zero. The result is rounded towards zero.
702      *
703      * Counterpart to Solidity's `/` operator.
704      *
705      * Requirements:
706      *
707      * - The divisor cannot be zero.
708      */
709     function div(uint256 a, uint256 b) internal pure returns (uint256) {
710         return a / b;
711     }
712 
713     /**
714      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
715      * reverting when dividing by zero.
716      *
717      * Counterpart to Solidity's `%` operator. This function uses a `revert`
718      * opcode (which leaves remaining gas untouched) while Solidity uses an
719      * invalid opcode to revert (consuming all remaining gas).
720      *
721      * Requirements:
722      *
723      * - The divisor cannot be zero.
724      */
725     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
726         return a % b;
727     }
728 
729     /**
730      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
731      * overflow (when the result is negative).
732      *
733      * CAUTION: This function is deprecated because it requires allocating memory for the error
734      * message unnecessarily. For custom revert reasons use {trySub}.
735      *
736      * Counterpart to Solidity's `-` operator.
737      *
738      * Requirements:
739      *
740      * - Subtraction cannot overflow.
741      */
742     function sub(
743         uint256 a,
744         uint256 b,
745         string memory errorMessage
746     ) internal pure returns (uint256) {
747         unchecked {
748             require(b <= a, errorMessage);
749             return a - b;
750         }
751     }
752 
753     /**
754      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
755      * division by zero. The result is rounded towards zero.
756      *
757      * Counterpart to Solidity's `/` operator. Note: this function uses a
758      * `revert` opcode (which leaves remaining gas untouched) while Solidity
759      * uses an invalid opcode to revert (consuming all remaining gas).
760      *
761      * Requirements:
762      *
763      * - The divisor cannot be zero.
764      */
765     function div(
766         uint256 a,
767         uint256 b,
768         string memory errorMessage
769     ) internal pure returns (uint256) {
770         unchecked {
771             require(b > 0, errorMessage);
772             return a / b;
773         }
774     }
775 
776     /**
777      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
778      * reverting with custom message when dividing by zero.
779      *
780      * CAUTION: This function is deprecated because it requires allocating memory for the error
781      * message unnecessarily. For custom revert reasons use {tryMod}.
782      *
783      * Counterpart to Solidity's `%` operator. This function uses a `revert`
784      * opcode (which leaves remaining gas untouched) while Solidity uses an
785      * invalid opcode to revert (consuming all remaining gas).
786      *
787      * Requirements:
788      *
789      * - The divisor cannot be zero.
790      */
791     function mod(
792         uint256 a,
793         uint256 b,
794         string memory errorMessage
795     ) internal pure returns (uint256) {
796         unchecked {
797             require(b > 0, errorMessage);
798             return a % b;
799         }
800     }
801 }
802 
803 ////// src/IUniswapV2Factory.sol
804 /* pragma solidity 0.8.10; */
805 /* pragma experimental ABIEncoderV2; */
806 
807 interface IUniswapV2Factory {
808     event PairCreated(
809         address indexed token0,
810         address indexed token1,
811         address pair,
812         uint256
813     );
814 
815     function feeTo() external view returns (address);
816 
817     function feeToSetter() external view returns (address);
818 
819     function getPair(address tokenA, address tokenB)
820         external
821         view
822         returns (address pair);
823 
824     function allPairs(uint256) external view returns (address pair);
825 
826     function allPairsLength() external view returns (uint256);
827 
828     function createPair(address tokenA, address tokenB)
829         external
830         returns (address pair);
831 
832     function setFeeTo(address) external;
833 
834     function setFeeToSetter(address) external;
835 }
836 
837 ////// src/IUniswapV2Pair.sol
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
950 ////// src/IUniswapV2Router02.sol
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
1026 contract BodhiInu is ERC20, Ownable {
1027     using SafeMath for uint256;
1028 
1029     IUniswapV2Router02 public immutable uniswapV2Router;
1030     address public immutable uniswapV2Pair;
1031     address public constant deadAddress = address(0xdead);
1032 
1033     bool private swapping;
1034 
1035     address public marketingWallet;
1036     address public devWallet;
1037 
1038     uint256 public maxTransactionAmount;
1039     uint256 public swapTokensAtAmount;
1040     uint256 public maxWallet;
1041 
1042     uint256 public percentForLPBurn = 25; // 25 = .25%
1043     bool public lpBurnEnabled = false;
1044     uint256 public lpBurnFrequency = 3600 seconds;
1045     uint256 public lastLpBurnTime;
1046 
1047     uint256 public manualBurnFrequency = 30 minutes;
1048     uint256 public lastManualLpBurnTime;
1049 
1050     bool public limitsInEffect = true;
1051     bool public tradingActive = false;
1052     bool public swapEnabled = false;
1053 
1054     // Anti-bot and anti-whale mappings and variables
1055     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1056     bool public transferDelayEnabled = false;
1057 
1058     uint256 public buyTotalFees;
1059     uint256 public buyMarketingFee;
1060     uint256 public buyLiquidityFee;
1061     uint256 public buyDevFee;
1062 
1063     uint256 public sellTotalFees;
1064     uint256 public sellMarketingFee;
1065     uint256 public sellLiquidityFee;
1066     uint256 public sellDevFee;
1067 
1068     uint256 public tokensForMarketing;
1069     uint256 public tokensForLiquidity;
1070     uint256 public tokensForDev;
1071 
1072     /******************/
1073 
1074     // exlcude from fees and max transaction amount
1075     mapping(address => bool) private _isExcludedFromFees;
1076     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1077 
1078     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1079     // could be subject to a maximum transfer amount
1080     mapping(address => bool) public automatedMarketMakerPairs;
1081 
1082     event UpdateUniswapV2Router(
1083         address indexed newAddress,
1084         address indexed oldAddress
1085     );
1086 
1087     event ExcludeFromFees(address indexed account, bool isExcluded);
1088 
1089     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1090 
1091     event marketingWalletUpdated(
1092         address indexed newWallet,
1093         address indexed oldWallet
1094     );
1095 
1096     event devWalletUpdated(
1097         address indexed newWallet,
1098         address indexed oldWallet
1099     );
1100 
1101     event SwapAndLiquify(
1102         uint256 tokensSwapped,
1103         uint256 ethReceived,
1104         uint256 tokensIntoLiquidity
1105     );
1106 
1107     event AutoNukeLP();
1108 
1109     event ManualNukeLP();
1110 
1111     constructor() ERC20("Bodhi Inu", "BODHI") {
1112         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1113             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1114         );
1115 
1116         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1117         uniswapV2Router = _uniswapV2Router;
1118 
1119         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1120             .createPair(address(this), _uniswapV2Router.WETH());
1121         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1122         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1123 
1124         uint256 _buyMarketingFee = 5;
1125         uint256 _buyLiquidityFee = 0;
1126         uint256 _buyDevFee = 0;
1127 
1128         uint256 _sellMarketingFee = 5;
1129         uint256 _sellLiquidityFee = 0;
1130         uint256 _sellDevFee = 0;
1131 
1132         uint256 totalSupply = 1_000_000_000_000 * 1e18;
1133 
1134         maxTransactionAmount = 5_000_000_000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1135         maxWallet = 5_000_000_000 * 1e18; // 1% from total supply maxWallet
1136         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1137 
1138         buyMarketingFee = _buyMarketingFee;
1139         buyLiquidityFee = _buyLiquidityFee;
1140         buyDevFee = _buyDevFee;
1141         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1142 
1143         sellMarketingFee = _sellMarketingFee;
1144         sellLiquidityFee = _sellLiquidityFee;
1145         sellDevFee = _sellDevFee;
1146         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1147 
1148         marketingWallet = address(0xed210abf183f95DC019DDc7C6E6a5e855227DdC0); // set as marketing wallet
1149         devWallet = address(0xed210abf183f95DC019DDc7C6E6a5e855227DdC0); // set as dev wallet
1150 
1151         // exclude from paying fees or having max transaction amount
1152         excludeFromFees(owner(), true);
1153         excludeFromFees(address(this), true);
1154         excludeFromFees(address(0xdead), true);
1155 
1156         excludeFromMaxTransaction(owner(), true);
1157         excludeFromMaxTransaction(address(this), true);
1158         excludeFromMaxTransaction(address(0xdead), true);
1159 
1160         /*
1161             _mint is an internal function in ERC20.sol that is only called here,
1162             and CANNOT be called ever again
1163         */
1164         _mint(msg.sender, totalSupply);
1165     }
1166 
1167     receive() external payable {}
1168 
1169     // once enabled, can never be turned off
1170     function enableTrading() external onlyOwner {
1171         tradingActive = true;
1172         swapEnabled = true;
1173         lastLpBurnTime = block.timestamp;
1174     }
1175 
1176     // remove limits after token is stable
1177     function removeLimits() external onlyOwner returns (bool) {
1178         limitsInEffect = false;
1179         return true;
1180     }
1181 
1182     // disable Transfer delay - cannot be reenabled
1183     function disableTransferDelay() external onlyOwner returns (bool) {
1184         transferDelayEnabled = false;
1185         return true;
1186     }
1187 
1188     // change the minimum amount of tokens to sell from fees
1189     function updateSwapTokensAtAmount(uint256 newAmount)
1190         external
1191         onlyOwner
1192         returns (bool)
1193     {
1194         require(
1195             newAmount >= (totalSupply() * 1) / 100000,
1196             "Swap amount cannot be lower than 0.001% total supply."
1197         );
1198         require(
1199             newAmount <= (totalSupply() * 5) / 1000,
1200             "Swap amount cannot be higher than 0.5% total supply."
1201         );
1202         swapTokensAtAmount = newAmount;
1203         return true;
1204     }
1205 
1206     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1207         require(
1208             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1209             "Cannot set maxTransactionAmount lower than 0.1%"
1210         );
1211         maxTransactionAmount = newNum * (10**18);
1212     }
1213 
1214     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1215         require(
1216             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1217             "Cannot set maxWallet lower than 0.5%"
1218         );
1219         maxWallet = newNum * (10**18);
1220     }
1221 
1222     function excludeFromMaxTransaction(address updAds, bool isEx)
1223         public
1224         onlyOwner
1225     {
1226         _isExcludedMaxTransactionAmount[updAds] = isEx;
1227     }
1228 
1229     // only use to disable contract sales if absolutely necessary (emergency use only)
1230     function updateSwapEnabled(bool enabled) external onlyOwner {
1231         swapEnabled = enabled;
1232     }
1233 
1234     function updateBuyFees(
1235         uint256 _marketingFee,
1236         uint256 _liquidityFee,
1237         uint256 _devFee
1238     ) external onlyOwner {
1239         buyMarketingFee = _marketingFee;
1240         buyLiquidityFee = _liquidityFee;
1241         buyDevFee = _devFee;
1242         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1243         require(buyTotalFees <= 99, "Must keep fees at 99% or less");
1244     }
1245 
1246     function updateSellFees(
1247         uint256 _marketingFee,
1248         uint256 _liquidityFee,
1249         uint256 _devFee
1250     ) external onlyOwner {
1251         sellMarketingFee = _marketingFee;
1252         sellLiquidityFee = _liquidityFee;
1253         sellDevFee = _devFee;
1254         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1255         require(sellTotalFees <= 99, "Must keep fees at 99% or less");
1256     }
1257 
1258     function excludeFromFees(address account, bool excluded) public onlyOwner {
1259         _isExcludedFromFees[account] = excluded;
1260         emit ExcludeFromFees(account, excluded);
1261     }
1262 
1263     function setAutomatedMarketMakerPair(address pair, bool value)
1264         public
1265         onlyOwner
1266     {
1267         require(
1268             pair != uniswapV2Pair,
1269             "The pair cannot be removed from automatedMarketMakerPairs"
1270         );
1271 
1272         _setAutomatedMarketMakerPair(pair, value);
1273     }
1274 
1275     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1276         automatedMarketMakerPairs[pair] = value;
1277 
1278         emit SetAutomatedMarketMakerPair(pair, value);
1279     }
1280 
1281     function updateMarketingWallet(address newMarketingWallet)
1282         external
1283         onlyOwner
1284     {
1285         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1286         marketingWallet = newMarketingWallet;
1287     }
1288 
1289     function updateDevWallet(address newWallet) external onlyOwner {
1290         emit devWalletUpdated(newWallet, devWallet);
1291         devWallet = newWallet;
1292     }
1293 
1294     function isExcludedFromFees(address account) public view returns (bool) {
1295         return _isExcludedFromFees[account];
1296     }
1297 
1298     event BoughtEarly(address indexed sniper);
1299 
1300     function _transfer(
1301         address from,
1302         address to,
1303         uint256 amount
1304     ) internal override {
1305         require(from != address(0), "ERC20: transfer from the zero address");
1306         require(to != address(0), "ERC20: transfer to the zero address");
1307 
1308         if (amount == 0) {
1309             super._transfer(from, to, 0);
1310             return;
1311         }
1312 
1313         if (limitsInEffect) {
1314             if (
1315                 from != owner() &&
1316                 to != owner() &&
1317                 to != address(0) &&
1318                 to != address(0xdead) &&
1319                 !swapping
1320             ) {
1321                 if (!tradingActive) {
1322                     require(
1323                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1324                         "Trading is not active."
1325                     );
1326                 }
1327 
1328                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1329                 if (transferDelayEnabled) {
1330                     if (
1331                         to != owner() &&
1332                         to != address(uniswapV2Router) &&
1333                         to != address(uniswapV2Pair)
1334                     ) {
1335                         require(
1336                             _holderLastTransferTimestamp[tx.origin] <
1337                                 block.number,
1338                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1339                         );
1340                         _holderLastTransferTimestamp[tx.origin] = block.number;
1341                     }
1342                 }
1343 
1344                 //when buy
1345                 if (
1346                     automatedMarketMakerPairs[from] &&
1347                     !_isExcludedMaxTransactionAmount[to]
1348                 ) {
1349                     require(
1350                         amount <= maxTransactionAmount,
1351                         "Buy transfer amount exceeds the maxTransactionAmount."
1352                     );
1353                     require(
1354                         amount + balanceOf(to) <= maxWallet,
1355                         "Max wallet exceeded"
1356                     );
1357                 }
1358                 //when sell
1359                 else if (
1360                     automatedMarketMakerPairs[to] &&
1361                     !_isExcludedMaxTransactionAmount[from]
1362                 ) {
1363                     require(
1364                         amount <= maxTransactionAmount,
1365                         "Sell transfer amount exceeds the maxTransactionAmount."
1366                     );
1367                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1368                     require(
1369                         amount + balanceOf(to) <= maxWallet,
1370                         "Max wallet exceeded"
1371                     );
1372                 }
1373             }
1374         }
1375 
1376         uint256 contractTokenBalance = balanceOf(address(this));
1377 
1378         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1379 
1380         if (
1381             canSwap &&
1382             swapEnabled &&
1383             !swapping &&
1384             !automatedMarketMakerPairs[from] &&
1385             !_isExcludedFromFees[from] &&
1386             !_isExcludedFromFees[to]
1387         ) {
1388             swapping = true;
1389 
1390             swapBack();
1391 
1392             swapping = false;
1393         }
1394 
1395         if (
1396             !swapping &&
1397             automatedMarketMakerPairs[to] &&
1398             lpBurnEnabled &&
1399             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1400             !_isExcludedFromFees[from]
1401         ) {
1402             autoBurnLiquidityPairTokens();
1403         }
1404 
1405         bool takeFee = !swapping;
1406 
1407         // if any account belongs to _isExcludedFromFee account then remove the fee
1408         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1409             takeFee = false;
1410         }
1411 
1412         uint256 fees = 0;
1413         // only take fees on buys/sells, do not take on wallet transfers
1414         if (takeFee) {
1415             // on sell
1416             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1417                 fees = amount.mul(sellTotalFees).div(100);
1418                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1419                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1420                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1421             }
1422             // on buy
1423             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1424                 fees = amount.mul(buyTotalFees).div(100);
1425                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1426                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1427                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1428             }
1429 
1430             if (fees > 0) {
1431                 super._transfer(from, address(this), fees);
1432             }
1433 
1434             amount -= fees;
1435         }
1436 
1437         super._transfer(from, to, amount);
1438     }
1439 
1440     function swapTokensForEth(uint256 tokenAmount) private {
1441         // generate the uniswap pair path of token -> weth
1442         address[] memory path = new address[](2);
1443         path[0] = address(this);
1444         path[1] = uniswapV2Router.WETH();
1445 
1446         _approve(address(this), address(uniswapV2Router), tokenAmount);
1447 
1448         // make the swap
1449         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1450             tokenAmount,
1451             0, // accept any amount of ETH
1452             path,
1453             address(this),
1454             block.timestamp
1455         );
1456     }
1457 
1458     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1459         // approve token transfer to cover all possible scenarios
1460         _approve(address(this), address(uniswapV2Router), tokenAmount);
1461 
1462         // add the liquidity
1463         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1464             address(this),
1465             tokenAmount,
1466             0, // slippage is unavoidable
1467             0, // slippage is unavoidable
1468             deadAddress,
1469             block.timestamp
1470         );
1471     }
1472 
1473     function swapBack() private {
1474         uint256 contractBalance = balanceOf(address(this));
1475         uint256 totalTokensToSwap = tokensForLiquidity +
1476             tokensForMarketing +
1477             tokensForDev;
1478         bool success;
1479 
1480         if (contractBalance == 0 || totalTokensToSwap == 0) {
1481             return;
1482         }
1483 
1484         if (contractBalance > swapTokensAtAmount * 20) {
1485             contractBalance = swapTokensAtAmount * 20;
1486         }
1487 
1488         // Halve the amount of liquidity tokens
1489         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1490             totalTokensToSwap /
1491             2;
1492         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1493 
1494         uint256 initialETHBalance = address(this).balance;
1495 
1496         swapTokensForEth(amountToSwapForETH);
1497 
1498         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1499 
1500         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1501             totalTokensToSwap
1502         );
1503         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1504 
1505         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1506 
1507         tokensForLiquidity = 0;
1508         tokensForMarketing = 0;
1509         tokensForDev = 0;
1510 
1511         (success, ) = address(devWallet).call{value: ethForDev}("");
1512 
1513         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1514             addLiquidity(liquidityTokens, ethForLiquidity);
1515             emit SwapAndLiquify(
1516                 amountToSwapForETH,
1517                 ethForLiquidity,
1518                 tokensForLiquidity
1519             );
1520         }
1521 
1522         (success, ) = address(marketingWallet).call{
1523             value: address(this).balance
1524         }("");
1525     }
1526 
1527     function setAutoLPBurnSettings(
1528         uint256 _frequencyInSeconds,
1529         uint256 _percent,
1530         bool _Enabled
1531     ) external onlyOwner {
1532         require(
1533             _frequencyInSeconds >= 600,
1534             "cannot set buyback more often than every 10 minutes"
1535         );
1536         require(
1537             _percent <= 1000 && _percent >= 0,
1538             "Must set auto LP burn percent between 0% and 10%"
1539         );
1540         lpBurnFrequency = _frequencyInSeconds;
1541         percentForLPBurn = _percent;
1542         lpBurnEnabled = _Enabled;
1543     }
1544 
1545     function autoBurnLiquidityPairTokens() internal returns (bool) {
1546         lastLpBurnTime = block.timestamp;
1547 
1548         // get balance of liquidity pair
1549         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1550 
1551         // calculate amount to burn
1552         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1553             10000
1554         );
1555 
1556         // pull tokens from pancakePair liquidity and move to dead address permanently
1557         if (amountToBurn > 0) {
1558             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1559         }
1560 
1561         //sync price since this is not in a swap transaction!
1562         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1563         pair.sync();
1564         emit AutoNukeLP();
1565         return true;
1566     }
1567 
1568     function manualBurnLiquidityPairTokens(uint256 percent)
1569         external
1570         onlyOwner
1571         returns (bool)
1572     {
1573         require(
1574             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1575             "Must wait for cooldown to finish"
1576         );
1577         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1578         lastManualLpBurnTime = block.timestamp;
1579 
1580         // get balance of liquidity pair
1581         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1582 
1583         // calculate amount to burn
1584         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1585 
1586         // pull tokens from pancakePair liquidity and move to dead address permanently
1587         if (amountToBurn > 0) {
1588             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1589         }
1590 
1591         //sync price since this is not in a swap transaction!
1592         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1593         pair.sync();
1594         emit ManualNukeLP();
1595         return true;
1596     }
1597 }