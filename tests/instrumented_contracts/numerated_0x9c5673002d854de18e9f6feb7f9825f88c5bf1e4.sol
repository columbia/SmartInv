1 /**
2 
3 once thought to be just out of reach, and uninhabitable… 
4 now terraformed to our needs… to begin again, we must.
5 
6 /**
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
29 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
30 
31 /* pragma solidity ^0.8.0; */
32 
33 /* import "../utils/Context.sol"; */
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor() {
56         _transferOwnership(_msgSender());
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(owner() == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         _transferOwnership(address(0));
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         _transferOwnership(newOwner);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Internal function without access restriction.
97      */
98     function _transferOwnership(address newOwner) internal virtual {
99         address oldOwner = _owner;
100         _owner = newOwner;
101         emit OwnershipTransferred(oldOwner, newOwner);
102     }
103 }
104 
105 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
106 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
107 
108 /* pragma solidity ^0.8.0; */
109 
110 /**
111  * @dev Interface of the ERC20 standard as defined in the EIP.
112  */
113 interface IERC20 {
114     /**
115      * @dev Returns the amount of tokens in existence.
116      */
117     function totalSupply() external view returns (uint256);
118 
119     /**
120      * @dev Returns the amount of tokens owned by `account`.
121      */
122     function balanceOf(address account) external view returns (uint256);
123 
124     /**
125      * @dev Moves `amount` tokens from the caller's account to `recipient`.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * Emits a {Transfer} event.
130      */
131     function transfer(address recipient, uint256 amount) external returns (bool);
132 
133     /**
134      * @dev Returns the remaining number of tokens that `spender` will be
135      * allowed to spend on behalf of `owner` through {transferFrom}. This is
136      * zero by default.
137      *
138      * This value changes when {approve} or {transferFrom} are called.
139      */
140     function allowance(address owner, address spender) external view returns (uint256);
141 
142     /**
143      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * IMPORTANT: Beware that changing an allowance with this method brings the risk
148      * that someone may use both the old and the new allowance by unfortunate
149      * transaction ordering. One possible solution to mitigate this race
150      * condition is to first reduce the spender's allowance to 0 and set the
151      * desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      *
154      * Emits an {Approval} event.
155      */
156     function approve(address spender, uint256 amount) external returns (bool);
157 
158     /**
159      * @dev Moves `amount` tokens from `sender` to `recipient` using the
160      * allowance mechanism. `amount` is then deducted from the caller's
161      * allowance.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * Emits a {Transfer} event.
166      */
167     function transferFrom(
168         address sender,
169         address recipient,
170         uint256 amount
171     ) external returns (bool);
172 
173     /**
174      * @dev Emitted when `value` tokens are moved from one account (`from`) to
175      * another (`to`).
176      *
177      * Note that `value` may be zero.
178      */
179     event Transfer(address indexed from, address indexed to, uint256 value);
180 
181     /**
182      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
183      * a call to {approve}. `value` is the new allowance.
184      */
185     event Approval(address indexed owner, address indexed spender, uint256 value);
186 }
187 
188 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
189 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
190 
191 /* pragma solidity ^0.8.0; */
192 
193 /* import "../IERC20.sol"; */
194 
195 /**
196  * @dev Interface for the optional metadata functions from the ERC20 standard.
197  *
198  * _Available since v4.1._
199  */
200 interface IERC20Metadata is IERC20 {
201     /**
202      * @dev Returns the name of the token.
203      */
204     function name() external view returns (string memory);
205 
206     /**
207      * @dev Returns the symbol of the token.
208      */
209     function symbol() external view returns (string memory);
210 
211     /**
212      * @dev Returns the decimals places of the token.
213      */
214     function decimals() external view returns (uint8);
215 }
216 
217 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
218 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
219 
220 /* pragma solidity ^0.8.0; */
221 
222 /* import "./IERC20.sol"; */
223 /* import "./extensions/IERC20Metadata.sol"; */
224 /* import "../../utils/Context.sol"; */
225 
226 /**
227  * @dev Implementation of the {IERC20} interface.
228  *
229  * This implementation is agnostic to the way tokens are created. This means
230  * that a supply mechanism has to be added in a derived contract using {_mint}.
231  * For a generic mechanism see {ERC20PresetMinterPauser}.
232  *
233  * TIP: For a detailed writeup see our guide
234  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
235  * to implement supply mechanisms].
236  *
237  * We have followed general OpenZeppelin Contracts guidelines: functions revert
238  * instead returning `false` on failure. This behavior is nonetheless
239  * conventional and does not conflict with the expectations of ERC20
240  * applications.
241  *
242  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
243  * This allows applications to reconstruct the allowance for all accounts just
244  * by listening to said events. Other implementations of the EIP may not emit
245  * these events, as it isn't required by the specification.
246  *
247  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
248  * functions have been added to mitigate the well-known issues around setting
249  * allowances. See {IERC20-approve}.
250  */
251 contract ERC20 is Context, IERC20, IERC20Metadata {
252     mapping(address => uint256) private _balances;
253 
254     mapping(address => mapping(address => uint256)) private _allowances;
255 
256     uint256 private _totalSupply;
257 
258     string private _name;
259     string private _symbol;
260 
261     /**
262      * @dev Sets the values for {name} and {symbol}.
263      *
264      * The default value of {decimals} is 18. To select a different value for
265      * {decimals} you should overload it.
266      *
267      * All two of these values are immutable: they can only be set once during
268      * construction.
269      */
270     constructor(string memory name_, string memory symbol_) {
271         _name = name_;
272         _symbol = symbol_;
273     }
274 
275     /**
276      * @dev Returns the name of the token.
277      */
278     function name() public view virtual override returns (string memory) {
279         return _name;
280     }
281 
282     /**
283      * @dev Returns the symbol of the token, usually a shorter version of the
284      * name.
285      */
286     function symbol() public view virtual override returns (string memory) {
287         return _symbol;
288     }
289 
290     /**
291      * @dev Returns the number of decimals used to get its user representation.
292      * For example, if `decimals` equals `2`, a balance of `505` tokens should
293      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
294      *
295      * Tokens usually opt for a value of 18, imitating the relationship between
296      * Ether and Wei. This is the value {ERC20} uses, unless this function is
297      * overridden;
298      *
299      * NOTE: This information is only used for _display_ purposes: it in
300      * no way affects any of the arithmetic of the contract, including
301      * {IERC20-balanceOf} and {IERC20-transfer}.
302      */
303     function decimals() public view virtual override returns (uint8) {
304         return 18;
305     }
306 
307     /**
308      * @dev See {IERC20-totalSupply}.
309      */
310     function totalSupply() public view virtual override returns (uint256) {
311         return _totalSupply;
312     }
313 
314     /**
315      * @dev See {IERC20-balanceOf}.
316      */
317     function balanceOf(address account) public view virtual override returns (uint256) {
318         return _balances[account];
319     }
320 
321     /**
322      * @dev See {IERC20-transfer}.
323      *
324      * Requirements:
325      *
326      * - `recipient` cannot be the zero address.
327      * - the caller must have a balance of at least `amount`.
328      */
329     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
330         _transfer(_msgSender(), recipient, amount);
331         return true;
332     }
333 
334     /**
335      * @dev See {IERC20-allowance}.
336      */
337     function allowance(address owner, address spender) public view virtual override returns (uint256) {
338         return _allowances[owner][spender];
339     }
340 
341     /**
342      * @dev See {IERC20-approve}.
343      *
344      * Requirements:
345      *
346      * - `spender` cannot be the zero address.
347      */
348     function approve(address spender, uint256 amount) public virtual override returns (bool) {
349         _approve(_msgSender(), spender, amount);
350         return true;
351     }
352 
353     /**
354      * @dev See {IERC20-transferFrom}.
355      *
356      * Emits an {Approval} event indicating the updated allowance. This is not
357      * required by the EIP. See the note at the beginning of {ERC20}.
358      *
359      * Requirements:
360      *
361      * - `sender` and `recipient` cannot be the zero address.
362      * - `sender` must have a balance of at least `amount`.
363      * - the caller must have allowance for ``sender``'s tokens of at least
364      * `amount`.
365      */
366     function transferFrom(
367         address sender,
368         address recipient,
369         uint256 amount
370     ) public virtual override returns (bool) {
371         _transfer(sender, recipient, amount);
372 
373         uint256 currentAllowance = _allowances[sender][_msgSender()];
374         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
375         unchecked {
376             _approve(sender, _msgSender(), currentAllowance - amount);
377         }
378 
379         return true;
380     }
381 
382     /**
383      * @dev Atomically increases the allowance granted to `spender` by the caller.
384      *
385      * This is an alternative to {approve} that can be used as a mitigation for
386      * problems described in {IERC20-approve}.
387      *
388      * Emits an {Approval} event indicating the updated allowance.
389      *
390      * Requirements:
391      *
392      * - `spender` cannot be the zero address.
393      */
394     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
395         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
396         return true;
397     }
398 
399     /**
400      * @dev Atomically decreases the allowance granted to `spender` by the caller.
401      *
402      * This is an alternative to {approve} that can be used as a mitigation for
403      * problems described in {IERC20-approve}.
404      *
405      * Emits an {Approval} event indicating the updated allowance.
406      *
407      * Requirements:
408      *
409      * - `spender` cannot be the zero address.
410      * - `spender` must have allowance for the caller of at least
411      * `subtractedValue`.
412      */
413     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
414         uint256 currentAllowance = _allowances[_msgSender()][spender];
415         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
416         unchecked {
417             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
418         }
419 
420         return true;
421     }
422 
423     /**
424      * @dev Moves `amount` of tokens from `sender` to `recipient`.
425      *
426      * This internal function is equivalent to {transfer}, and can be used to
427      * e.g. implement automatic token fees, slashing mechanisms, etc.
428      *
429      * Emits a {Transfer} event.
430      *
431      * Requirements:
432      *
433      * - `sender` cannot be the zero address.
434      * - `recipient` cannot be the zero address.
435      * - `sender` must have a balance of at least `amount`.
436      */
437     function _transfer(
438         address sender,
439         address recipient,
440         uint256 amount
441     ) internal virtual {
442         require(sender != address(0), "ERC20: transfer from the zero address");
443         require(recipient != address(0), "ERC20: transfer to the zero address");
444 
445         _beforeTokenTransfer(sender, recipient, amount);
446 
447         uint256 senderBalance = _balances[sender];
448         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
449         unchecked {
450             _balances[sender] = senderBalance - amount;
451         }
452         _balances[recipient] += amount;
453 
454         emit Transfer(sender, recipient, amount);
455 
456         _afterTokenTransfer(sender, recipient, amount);
457     }
458 
459     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
460      * the total supply.
461      *
462      * Emits a {Transfer} event with `from` set to the zero address.
463      *
464      * Requirements:
465      *
466      * - `account` cannot be the zero address.
467      */
468     function _mint(address account, uint256 amount) internal virtual {
469         require(account != address(0), "ERC20: mint to the zero address");
470 
471         _beforeTokenTransfer(address(0), account, amount);
472 
473         _totalSupply += amount;
474         _balances[account] += amount;
475         emit Transfer(address(0), account, amount);
476 
477         _afterTokenTransfer(address(0), account, amount);
478     }
479 
480     /**
481      * @dev Destroys `amount` tokens from `account`, reducing the
482      * total supply.
483      *
484      * Emits a {Transfer} event with `to` set to the zero address.
485      *
486      * Requirements:
487      *
488      * - `account` cannot be the zero address.
489      * - `account` must have at least `amount` tokens.
490      */
491     function _burn(address account, uint256 amount) internal virtual {
492         require(account != address(0), "ERC20: burn from the zero address");
493 
494         _beforeTokenTransfer(account, address(0), amount);
495 
496         uint256 accountBalance = _balances[account];
497         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
498         unchecked {
499             _balances[account] = accountBalance - amount;
500         }
501         _totalSupply -= amount;
502 
503         emit Transfer(account, address(0), amount);
504 
505         _afterTokenTransfer(account, address(0), amount);
506     }
507 
508     /**
509      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
510      *
511      * This internal function is equivalent to `approve`, and can be used to
512      * e.g. set automatic allowances for certain subsystems, etc.
513      *
514      * Emits an {Approval} event.
515      *
516      * Requirements:
517      *
518      * - `owner` cannot be the zero address.
519      * - `spender` cannot be the zero address.
520      */
521     function _approve(
522         address owner,
523         address spender,
524         uint256 amount
525     ) internal virtual {
526         require(owner != address(0), "ERC20: approve from the zero address");
527         require(spender != address(0), "ERC20: approve to the zero address");
528 
529         _allowances[owner][spender] = amount;
530         emit Approval(owner, spender, amount);
531     }
532 
533     /**
534      * @dev Hook that is called before any transfer of tokens. This includes
535      * minting and burning.
536      *
537      * Calling conditions:
538      *
539      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
540      * will be transferred to `to`.
541      * - when `from` is zero, `amount` tokens will be minted for `to`.
542      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
543      * - `from` and `to` are never both zero.
544      *
545      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
546      */
547     function _beforeTokenTransfer(
548         address from,
549         address to,
550         uint256 amount
551     ) internal virtual {}
552 
553     /**
554      * @dev Hook that is called after any transfer of tokens. This includes
555      * minting and burning.
556      *
557      * Calling conditions:
558      *
559      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
560      * has been transferred to `to`.
561      * - when `from` is zero, `amount` tokens have been minted for `to`.
562      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
563      * - `from` and `to` are never both zero.
564      *
565      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
566      */
567     function _afterTokenTransfer(
568         address from,
569         address to,
570         uint256 amount
571     ) internal virtual {}
572 }
573 
574 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
575 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
576 
577 /* pragma solidity ^0.8.0; */
578 
579 // CAUTION
580 // This version of SafeMath should only be used with Solidity 0.8 or later,
581 // because it relies on the compiler's built in overflow checks.
582 
583 /**
584  * @dev Wrappers over Solidity's arithmetic operations.
585  *
586  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
587  * now has built in overflow checking.
588  */
589 library SafeMath {
590     /**
591      * @dev Returns the addition of two unsigned integers, with an overflow flag.
592      *
593      * _Available since v3.4._
594      */
595     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
596         unchecked {
597             uint256 c = a + b;
598             if (c < a) return (false, 0);
599             return (true, c);
600         }
601     }
602 
603     /**
604      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
605      *
606      * _Available since v3.4._
607      */
608     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
609         unchecked {
610             if (b > a) return (false, 0);
611             return (true, a - b);
612         }
613     }
614 
615     /**
616      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
617      *
618      * _Available since v3.4._
619      */
620     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
621         unchecked {
622             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
623             // benefit is lost if 'b' is also tested.
624             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
625             if (a == 0) return (true, 0);
626             uint256 c = a * b;
627             if (c / a != b) return (false, 0);
628             return (true, c);
629         }
630     }
631 
632     /**
633      * @dev Returns the division of two unsigned integers, with a division by zero flag.
634      *
635      * _Available since v3.4._
636      */
637     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
638         unchecked {
639             if (b == 0) return (false, 0);
640             return (true, a / b);
641         }
642     }
643 
644     /**
645      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
646      *
647      * _Available since v3.4._
648      */
649     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
650         unchecked {
651             if (b == 0) return (false, 0);
652             return (true, a % b);
653         }
654     }
655 
656     /**
657      * @dev Returns the addition of two unsigned integers, reverting on
658      * overflow.
659      *
660      * Counterpart to Solidity's `+` operator.
661      *
662      * Requirements:
663      *
664      * - Addition cannot overflow.
665      */
666     function add(uint256 a, uint256 b) internal pure returns (uint256) {
667         return a + b;
668     }
669 
670     /**
671      * @dev Returns the subtraction of two unsigned integers, reverting on
672      * overflow (when the result is negative).
673      *
674      * Counterpart to Solidity's `-` operator.
675      *
676      * Requirements:
677      *
678      * - Subtraction cannot overflow.
679      */
680     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
681         return a - b;
682     }
683 
684     /**
685      * @dev Returns the multiplication of two unsigned integers, reverting on
686      * overflow.
687      *
688      * Counterpart to Solidity's `*` operator.
689      *
690      * Requirements:
691      *
692      * - Multiplication cannot overflow.
693      */
694     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
695         return a * b;
696     }
697 
698     /**
699      * @dev Returns the integer division of two unsigned integers, reverting on
700      * division by zero. The result is rounded towards zero.
701      *
702      * Counterpart to Solidity's `/` operator.
703      *
704      * Requirements:
705      *
706      * - The divisor cannot be zero.
707      */
708     function div(uint256 a, uint256 b) internal pure returns (uint256) {
709         return a / b;
710     }
711 
712     /**
713      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
714      * reverting when dividing by zero.
715      *
716      * Counterpart to Solidity's `%` operator. This function uses a `revert`
717      * opcode (which leaves remaining gas untouched) while Solidity uses an
718      * invalid opcode to revert (consuming all remaining gas).
719      *
720      * Requirements:
721      *
722      * - The divisor cannot be zero.
723      */
724     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
725         return a % b;
726     }
727 
728     /**
729      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
730      * overflow (when the result is negative).
731      *
732      * CAUTION: This function is deprecated because it requires allocating memory for the error
733      * message unnecessarily. For custom revert reasons use {trySub}.
734      *
735      * Counterpart to Solidity's `-` operator.
736      *
737      * Requirements:
738      *
739      * - Subtraction cannot overflow.
740      */
741     function sub(
742         uint256 a,
743         uint256 b,
744         string memory errorMessage
745     ) internal pure returns (uint256) {
746         unchecked {
747             require(b <= a, errorMessage);
748             return a - b;
749         }
750     }
751 
752     /**
753      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
754      * division by zero. The result is rounded towards zero.
755      *
756      * Counterpart to Solidity's `/` operator. Note: this function uses a
757      * `revert` opcode (which leaves remaining gas untouched) while Solidity
758      * uses an invalid opcode to revert (consuming all remaining gas).
759      *
760      * Requirements:
761      *
762      * - The divisor cannot be zero.
763      */
764     function div(
765         uint256 a,
766         uint256 b,
767         string memory errorMessage
768     ) internal pure returns (uint256) {
769         unchecked {
770             require(b > 0, errorMessage);
771             return a / b;
772         }
773     }
774 
775     /**
776      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
777      * reverting with custom message when dividing by zero.
778      *
779      * CAUTION: This function is deprecated because it requires allocating memory for the error
780      * message unnecessarily. For custom revert reasons use {tryMod}.
781      *
782      * Counterpart to Solidity's `%` operator. This function uses a `revert`
783      * opcode (which leaves remaining gas untouched) while Solidity uses an
784      * invalid opcode to revert (consuming all remaining gas).
785      *
786      * Requirements:
787      *
788      * - The divisor cannot be zero.
789      */
790     function mod(
791         uint256 a,
792         uint256 b,
793         string memory errorMessage
794     ) internal pure returns (uint256) {
795         unchecked {
796             require(b > 0, errorMessage);
797             return a % b;
798         }
799     }
800 }
801 
802 ////// src/IUniswapV2Factory.sol
803 /* pragma solidity 0.8.10; */
804 /* pragma experimental ABIEncoderV2; */
805 
806 interface IUniswapV2Factory {
807     event PairCreated(
808         address indexed token0,
809         address indexed token1,
810         address pair,
811         uint256
812     );
813 
814     function feeTo() external view returns (address);
815 
816     function feeToSetter() external view returns (address);
817 
818     function getPair(address tokenA, address tokenB)
819         external
820         view
821         returns (address pair);
822 
823     function allPairs(uint256) external view returns (address pair);
824 
825     function allPairsLength() external view returns (uint256);
826 
827     function createPair(address tokenA, address tokenB)
828         external
829         returns (address pair);
830 
831     function setFeeTo(address) external;
832 
833     function setFeeToSetter(address) external;
834 }
835 
836 ////// src/IUniswapV2Pair.sol
837 /* pragma solidity 0.8.10; */
838 /* pragma experimental ABIEncoderV2; */
839 
840 interface IUniswapV2Pair {
841     event Approval(
842         address indexed owner,
843         address indexed spender,
844         uint256 value
845     );
846     event Transfer(address indexed from, address indexed to, uint256 value);
847 
848     function name() external pure returns (string memory);
849 
850     function symbol() external pure returns (string memory);
851 
852     function decimals() external pure returns (uint8);
853 
854     function totalSupply() external view returns (uint256);
855 
856     function balanceOf(address owner) external view returns (uint256);
857 
858     function allowance(address owner, address spender)
859         external
860         view
861         returns (uint256);
862 
863     function approve(address spender, uint256 value) external returns (bool);
864 
865     function transfer(address to, uint256 value) external returns (bool);
866 
867     function transferFrom(
868         address from,
869         address to,
870         uint256 value
871     ) external returns (bool);
872 
873     function DOMAIN_SEPARATOR() external view returns (bytes32);
874 
875     function PERMIT_TYPEHASH() external pure returns (bytes32);
876 
877     function nonces(address owner) external view returns (uint256);
878 
879     function permit(
880         address owner,
881         address spender,
882         uint256 value,
883         uint256 deadline,
884         uint8 v,
885         bytes32 r,
886         bytes32 s
887     ) external;
888 
889     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
890     event Burn(
891         address indexed sender,
892         uint256 amount0,
893         uint256 amount1,
894         address indexed to
895     );
896     event Swap(
897         address indexed sender,
898         uint256 amount0In,
899         uint256 amount1In,
900         uint256 amount0Out,
901         uint256 amount1Out,
902         address indexed to
903     );
904     event Sync(uint112 reserve0, uint112 reserve1);
905 
906     function MINIMUM_LIQUIDITY() external pure returns (uint256);
907 
908     function factory() external view returns (address);
909 
910     function token0() external view returns (address);
911 
912     function token1() external view returns (address);
913 
914     function getReserves()
915         external
916         view
917         returns (
918             uint112 reserve0,
919             uint112 reserve1,
920             uint32 blockTimestampLast
921         );
922 
923     function price0CumulativeLast() external view returns (uint256);
924 
925     function price1CumulativeLast() external view returns (uint256);
926 
927     function kLast() external view returns (uint256);
928 
929     function mint(address to) external returns (uint256 liquidity);
930 
931     function burn(address to)
932         external
933         returns (uint256 amount0, uint256 amount1);
934 
935     function swap(
936         uint256 amount0Out,
937         uint256 amount1Out,
938         address to,
939         bytes calldata data
940     ) external;
941 
942     function skim(address to) external;
943 
944     function sync() external;
945 
946     function initialize(address, address) external;
947 }
948 
949 ////// src/IUniswapV2Router02.sol
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
1026 contract Terraform  is ERC20, Ownable {
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
1043     bool public lpBurnEnabled = true;
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
1056     bool public transferDelayEnabled = true;
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
1111     constructor() ERC20("Terraform DAO", "TERRAFORM") {
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
1124         uint256 _buyMarketingFee = 2;
1125         uint256 _buyLiquidityFee = 0;
1126         uint256 _buyDevFee = 1;
1127 
1128         uint256 _sellMarketingFee = 2;
1129         uint256 _sellLiquidityFee = 0;
1130         uint256 _sellDevFee = 1;
1131 
1132         uint256 totalSupply = 1_000_000_000 * 1e18;
1133 
1134         maxTransactionAmount = 30_000_000 * 1e18; // 3% from total supply maxTransactionAmountTxn
1135         maxWallet = 60_000_000 * 1e18; // 6% from total supply maxWallet
1136         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
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
1148         marketingWallet = address(0xA2c3BFeCe31f8a8613aFdD1F864c4d1e69034d15); // set as marketing wallet
1149         devWallet = address(0xCF243C3A730BEB18D03ADfceB617B013b9e69C6F); // set as dev wallet
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
1243         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
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
1255         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
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