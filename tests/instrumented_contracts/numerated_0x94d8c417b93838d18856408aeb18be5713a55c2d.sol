1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
3 pragma experimental ABIEncoderV2;
4 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
5 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
6 /* pragma solidity ^0.8.0; */
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
802 /* pragma solidity 0.8.10; */
803 /* pragma experimental ABIEncoderV2; */
804 
805 interface IUniswapV2Factory {
806     event PairCreated(
807         address indexed token0,
808         address indexed token1,
809         address pair,
810         uint256
811     );
812 
813     function feeTo() external view returns (address);
814 
815     function feeToSetter() external view returns (address);
816 
817     function getPair(address tokenA, address tokenB)
818         external
819         view
820         returns (address pair);
821 
822     function allPairs(uint256) external view returns (address pair);
823 
824     function allPairsLength() external view returns (uint256);
825 
826     function createPair(address tokenA, address tokenB)
827         external
828         returns (address pair);
829 
830     function setFeeTo(address) external;
831 
832     function setFeeToSetter(address) external;
833 }
834 
835 /* pragma solidity 0.8.10; */
836 /* pragma experimental ABIEncoderV2; */ 
837 
838 interface IUniswapV2Pair {
839     event Approval(
840         address indexed owner,
841         address indexed spender,
842         uint256 value
843     );
844     event Transfer(address indexed from, address indexed to, uint256 value);
845 
846     function name() external pure returns (string memory);
847 
848     function symbol() external pure returns (string memory);
849 
850     function decimals() external pure returns (uint8);
851 
852     function totalSupply() external view returns (uint256);
853 
854     function balanceOf(address owner) external view returns (uint256);
855 
856     function allowance(address owner, address spender)
857         external
858         view
859         returns (uint256);
860 
861     function approve(address spender, uint256 value) external returns (bool);
862 
863     function transfer(address to, uint256 value) external returns (bool);
864 
865     function transferFrom(
866         address from,
867         address to,
868         uint256 value
869     ) external returns (bool);
870 
871     function DOMAIN_SEPARATOR() external view returns (bytes32);
872 
873     function PERMIT_TYPEHASH() external pure returns (bytes32);
874 
875     function nonces(address owner) external view returns (uint256);
876 
877     function permit(
878         address owner,
879         address spender,
880         uint256 value,
881         uint256 deadline,
882         uint8 v,
883         bytes32 r,
884         bytes32 s
885     ) external;
886 
887     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
888     event Burn(
889         address indexed sender,
890         uint256 amount0,
891         uint256 amount1,
892         address indexed to
893     );
894     event Swap(
895         address indexed sender,
896         uint256 amount0In,
897         uint256 amount1In,
898         uint256 amount0Out,
899         uint256 amount1Out,
900         address indexed to
901     );
902     event Sync(uint112 reserve0, uint112 reserve1);
903 
904     function MINIMUM_LIQUIDITY() external pure returns (uint256);
905 
906     function factory() external view returns (address);
907 
908     function token0() external view returns (address);
909 
910     function token1() external view returns (address);
911 
912     function getReserves()
913         external
914         view
915         returns (
916             uint112 reserve0,
917             uint112 reserve1,
918             uint32 blockTimestampLast
919         );
920 
921     function price0CumulativeLast() external view returns (uint256);
922 
923     function price1CumulativeLast() external view returns (uint256);
924 
925     function kLast() external view returns (uint256);
926 
927     function mint(address to) external returns (uint256 liquidity);
928 
929     function burn(address to)
930         external
931         returns (uint256 amount0, uint256 amount1);
932 
933     function swap(
934         uint256 amount0Out,
935         uint256 amount1Out,
936         address to,
937         bytes calldata data
938     ) external;
939 
940     function skim(address to) external;
941 
942     function sync() external;
943 
944     function initialize(address, address) external;
945 }
946 
947 /* pragma solidity 0.8.10; */
948 /* pragma experimental ABIEncoderV2; */
949 
950 interface IUniswapV2Router02 {
951     function factory() external pure returns (address);
952 
953     function WETH() external pure returns (address);
954 
955     function addLiquidity(
956         address tokenA,
957         address tokenB,
958         uint256 amountADesired,
959         uint256 amountBDesired,
960         uint256 amountAMin,
961         uint256 amountBMin,
962         address to,
963         uint256 deadline
964     )
965         external
966         returns (
967             uint256 amountA,
968             uint256 amountB,
969             uint256 liquidity
970         );
971 
972     function addLiquidityETH(
973         address token,
974         uint256 amountTokenDesired,
975         uint256 amountTokenMin,
976         uint256 amountETHMin,
977         address to,
978         uint256 deadline
979     )
980         external
981         payable
982         returns (
983             uint256 amountToken,
984             uint256 amountETH,
985             uint256 liquidity
986         );
987 
988     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
989         uint256 amountIn,
990         uint256 amountOutMin,
991         address[] calldata path,
992         address to,
993         uint256 deadline
994     ) external;
995 
996     function swapExactETHForTokensSupportingFeeOnTransferTokens(
997         uint256 amountOutMin,
998         address[] calldata path,
999         address to,
1000         uint256 deadline
1001     ) external payable;
1002 
1003     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1004         uint256 amountIn,
1005         uint256 amountOutMin,
1006         address[] calldata path,
1007         address to,
1008         uint256 deadline
1009     ) external;
1010 }
1011 
1012 /* pragma solidity >=0.8.10; */
1013 
1014 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1015 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1016 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1017 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1018 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1019 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1020 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1021 
1022 contract ALIENCOIN is ERC20, Ownable {
1023     using SafeMath for uint256;
1024 
1025     IUniswapV2Router02 public immutable uniswapV2Router;
1026     address public immutable uniswapV2Pair;
1027     address public constant deadAddress = address(0xdead);
1028 
1029     bool private swapping;
1030 
1031 	address public charityWallet;
1032     address public marketingWallet;
1033     address public devWallet;
1034 
1035     uint256 public maxTransactionAmount;
1036     uint256 public swapTokensAtAmount;
1037     uint256 public maxWallet;
1038 
1039     bool public limitsInEffect = true;
1040     bool public tradingActive = true;
1041     bool public swapEnabled = true;
1042 
1043     // Anti-bot and anti-whale mappings and variables
1044     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1045     bool public transferDelayEnabled = true;
1046 
1047     uint256 public buyTotalFees;
1048 	uint256 public buyCharityFee;
1049     uint256 public buyMarketingFee;
1050     uint256 public buyLiquidityFee;
1051     uint256 public buyDevFee;
1052 
1053     uint256 public sellTotalFees;
1054 	uint256 public sellCharityFee;
1055     uint256 public sellMarketingFee;
1056     uint256 public sellLiquidityFee;
1057     uint256 public sellDevFee;
1058 
1059 	uint256 public tokensForCharity;
1060     uint256 public tokensForMarketing;
1061     uint256 public tokensForLiquidity;
1062     uint256 public tokensForDev;
1063 
1064     /******************/
1065 
1066     // exlcude from fees and max transaction amount
1067     mapping(address => bool) private _isExcludedFromFees;
1068     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1069 
1070     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1071     // could be subject to a maximum transfer amount
1072     mapping(address => bool) public automatedMarketMakerPairs;
1073 
1074     event UpdateUniswapV2Router(
1075         address indexed newAddress,
1076         address indexed oldAddress
1077     );
1078 
1079     event ExcludeFromFees(address indexed account, bool isExcluded);
1080 
1081     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1082 
1083     event SwapAndLiquify(
1084         uint256 tokensSwapped,
1085         uint256 ethReceived,
1086         uint256 tokensIntoLiquidity
1087     );
1088 
1089     constructor() ERC20("UFO", "UFO") {
1090         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1091             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1092         );
1093 
1094         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1095         uniswapV2Router = _uniswapV2Router;
1096 
1097         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1098             .createPair(address(this), _uniswapV2Router.WETH());
1099         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1100         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1101 
1102 		uint256 _buyCharityFee = 0;
1103         uint256 _buyMarketingFee = 25;
1104         uint256 _buyLiquidityFee = 0;
1105         uint256 _buyDevFee = 0;
1106 
1107 		uint256 _sellCharityFee = 0;
1108         uint256 _sellMarketingFee = 25;
1109         uint256 _sellLiquidityFee = 0;
1110         uint256 _sellDevFee = 0;
1111 
1112         uint256 totalSupply = 1000000000 * 1e18;
1113 
1114         maxTransactionAmount = 20000000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1115         maxWallet = 20000000 * 1e18; // 2% from total supply maxWallet
1116         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1117 
1118 		buyCharityFee = _buyCharityFee;
1119         buyMarketingFee = _buyMarketingFee;
1120         buyLiquidityFee = _buyLiquidityFee;
1121         buyDevFee = _buyDevFee;
1122         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1123 
1124 		sellCharityFee = _sellCharityFee;
1125         sellMarketingFee = _sellMarketingFee;
1126         sellLiquidityFee = _sellLiquidityFee;
1127         sellDevFee = _sellDevFee;
1128         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1129 
1130 		charityWallet = address(0x3FF03B2845a29A5CA2dE02307473B49EAd5b19e0); // set as charity wallet
1131         marketingWallet = address(0x3FF03B2845a29A5CA2dE02307473B49EAd5b19e0); // set as marketing wallet
1132         devWallet = address(0x3FF03B2845a29A5CA2dE02307473B49EAd5b19e0); // set as dev wallet
1133 
1134         // exclude from paying fees or having max transaction amount
1135         excludeFromFees(owner(), true);
1136         excludeFromFees(address(this), true);
1137         excludeFromFees(address(0xdead), true);
1138 
1139         excludeFromMaxTransaction(owner(), true);
1140         excludeFromMaxTransaction(address(this), true);
1141         excludeFromMaxTransaction(address(0xdead), true);
1142 
1143         /*
1144             _mint is an internal function in ERC20.sol that is only called here,
1145             and CANNOT be called ever again
1146         */
1147         _mint(msg.sender, totalSupply);
1148     }
1149 
1150     receive() external payable {}
1151 
1152     // once enabled, can never be turned off
1153     function enableTrading() external onlyOwner {
1154         tradingActive = true;
1155         swapEnabled = true;
1156     }
1157 
1158     // remove limits after token is stable
1159     function removeLimits() external onlyOwner returns (bool) {
1160         limitsInEffect = false;
1161         return true;
1162     }
1163 
1164     // disable Transfer delay - cannot be reenabled
1165     function disableTransferDelay() external onlyOwner returns (bool) {
1166         transferDelayEnabled = false;
1167         return true;
1168     }
1169 
1170     // change the minimum amount of tokens to sell from fees
1171     function updateSwapTokensAtAmount(uint256 newAmount)
1172         external
1173         onlyOwner
1174         returns (bool)
1175     {
1176         require(
1177             newAmount >= (totalSupply() * 1) / 100000,
1178             "Swap amount cannot be lower than 0.001% total supply."
1179         );
1180         require(
1181             newAmount <= (totalSupply() * 5) / 1000,
1182             "Swap amount cannot be higher than 0.5% total supply."
1183         );
1184         swapTokensAtAmount = newAmount;
1185         return true;
1186     }
1187 
1188     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1189         require(
1190             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1191             "Cannot set maxTransactionAmount lower than 0.5%"
1192         );
1193         maxTransactionAmount = newNum * (10**18);
1194     }
1195 
1196     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1197         require(
1198             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1199             "Cannot set maxWallet lower than 0.5%"
1200         );
1201         maxWallet = newNum * (10**18);
1202     }
1203 	
1204     function excludeFromMaxTransaction(address updAds, bool isEx)
1205         public
1206         onlyOwner
1207     {
1208         _isExcludedMaxTransactionAmount[updAds] = isEx;
1209     }
1210 
1211     // only use to disable contract sales if absolutely necessary (emergency use only)
1212     function updateSwapEnabled(bool enabled) external onlyOwner {
1213         swapEnabled = enabled;
1214     }
1215 
1216     function updateBuyFees(
1217 		uint256 _charityFee,
1218         uint256 _marketingFee,
1219         uint256 _liquidityFee,
1220         uint256 _devFee
1221     ) external onlyOwner {
1222 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max BuyFee 10%");
1223 		buyCharityFee = _charityFee;
1224         buyMarketingFee = _marketingFee;
1225         buyLiquidityFee = _liquidityFee;
1226         buyDevFee = _devFee;
1227         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1228      }
1229 
1230     function updateSellFees(
1231 		uint256 _charityFee,
1232         uint256 _marketingFee,
1233         uint256 _liquidityFee,
1234         uint256 _devFee
1235     ) external onlyOwner {
1236 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max SellFee 10%");
1237 		sellCharityFee = _charityFee;
1238         sellMarketingFee = _marketingFee;
1239         sellLiquidityFee = _liquidityFee;
1240         sellDevFee = _devFee;
1241         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1242     }
1243 
1244     function excludeFromFees(address account, bool excluded) public onlyOwner {
1245         _isExcludedFromFees[account] = excluded;
1246         emit ExcludeFromFees(account, excluded);
1247     }
1248 
1249     function setAutomatedMarketMakerPair(address pair, bool value)
1250         public
1251         onlyOwner
1252     {
1253         require(
1254             pair != uniswapV2Pair,
1255             "The pair cannot be removed from automatedMarketMakerPairs"
1256         );
1257 
1258         _setAutomatedMarketMakerPair(pair, value);
1259     }
1260 
1261     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1262         automatedMarketMakerPairs[pair] = value;
1263 
1264         emit SetAutomatedMarketMakerPair(pair, value);
1265     }
1266 
1267     function isExcludedFromFees(address account) public view returns (bool) {
1268         return _isExcludedFromFees[account];
1269     }
1270 
1271     function _transfer(
1272         address from,
1273         address to,
1274         uint256 amount
1275     ) internal override {
1276         require(from != address(0), "ERC20: transfer from the zero address");
1277         require(to != address(0), "ERC20: transfer to the zero address");
1278 
1279         if (amount == 0) {
1280             super._transfer(from, to, 0);
1281             return;
1282         }
1283 
1284         if (limitsInEffect) {
1285             if (
1286                 from != owner() &&
1287                 to != owner() &&
1288                 to != address(0) &&
1289                 to != address(0xdead) &&
1290                 !swapping
1291             ) {
1292                 if (!tradingActive) {
1293                     require(
1294                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1295                         "Trading is not active."
1296                     );
1297                 }
1298 
1299                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1300                 if (transferDelayEnabled) {
1301                     if (
1302                         to != owner() &&
1303                         to != address(uniswapV2Router) &&
1304                         to != address(uniswapV2Pair)
1305                     ) {
1306                         require(
1307                             _holderLastTransferTimestamp[tx.origin] <
1308                                 block.number,
1309                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1310                         );
1311                         _holderLastTransferTimestamp[tx.origin] = block.number;
1312                     }
1313                 }
1314 
1315                 //when buy
1316                 if (
1317                     automatedMarketMakerPairs[from] &&
1318                     !_isExcludedMaxTransactionAmount[to]
1319                 ) {
1320                     require(
1321                         amount <= maxTransactionAmount,
1322                         "Buy transfer amount exceeds the maxTransactionAmount."
1323                     );
1324                     require(
1325                         amount + balanceOf(to) <= maxWallet,
1326                         "Max wallet exceeded"
1327                     );
1328                 }
1329                 //when sell
1330                 else if (
1331                     automatedMarketMakerPairs[to] &&
1332                     !_isExcludedMaxTransactionAmount[from]
1333                 ) {
1334                     require(
1335                         amount <= maxTransactionAmount,
1336                         "Sell transfer amount exceeds the maxTransactionAmount."
1337                     );
1338                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1339                     require(
1340                         amount + balanceOf(to) <= maxWallet,
1341                         "Max wallet exceeded"
1342                     );
1343                 }
1344             }
1345         }
1346 
1347         uint256 contractTokenBalance = balanceOf(address(this));
1348 
1349         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1350 
1351         if (
1352             canSwap &&
1353             swapEnabled &&
1354             !swapping &&
1355             !automatedMarketMakerPairs[from] &&
1356             !_isExcludedFromFees[from] &&
1357             !_isExcludedFromFees[to]
1358         ) {
1359             swapping = true;
1360 
1361             swapBack();
1362 
1363             swapping = false;
1364         }
1365 
1366         bool takeFee = !swapping;
1367 
1368         // if any account belongs to _isExcludedFromFee account then remove the fee
1369         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1370             takeFee = false;
1371         }
1372 
1373         uint256 fees = 0;
1374         // only take fees on buys/sells, do not take on wallet transfers
1375         if (takeFee) {
1376             // on sell
1377             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1378                 fees = amount.mul(sellTotalFees).div(100);
1379 				tokensForCharity += (fees * sellCharityFee) / sellTotalFees;
1380                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1381                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1382                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1383             }
1384             // on buy
1385             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1386                 fees = amount.mul(buyTotalFees).div(100);
1387 				tokensForCharity += (fees * buyCharityFee) / buyTotalFees;
1388                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1389                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1390                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1391             }
1392 
1393             if (fees > 0) {
1394                 super._transfer(from, address(this), fees);
1395             }
1396 
1397             amount -= fees;
1398         }
1399 
1400         super._transfer(from, to, amount);
1401     }
1402 
1403     function swapTokensForEth(uint256 tokenAmount) private {
1404         // generate the uniswap pair path of token -> weth
1405         address[] memory path = new address[](2);
1406         path[0] = address(this);
1407         path[1] = uniswapV2Router.WETH();
1408 
1409         _approve(address(this), address(uniswapV2Router), tokenAmount);
1410 
1411         // make the swap
1412         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1413             tokenAmount,
1414             0, // accept any amount of ETH
1415             path,
1416             address(this),
1417             block.timestamp
1418         );
1419     }
1420 
1421     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1422         // approve token transfer to cover all possible scenarios
1423         _approve(address(this), address(uniswapV2Router), tokenAmount);
1424 
1425         // add the liquidity
1426         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1427             address(this),
1428             tokenAmount,
1429             0, // slippage is unavoidable
1430             0, // slippage is unavoidable
1431             devWallet,
1432             block.timestamp
1433         );
1434     }
1435 
1436     function swapBack() private {
1437         uint256 contractBalance = balanceOf(address(this));
1438         uint256 totalTokensToSwap = tokensForCharity + tokensForLiquidity + tokensForMarketing + tokensForDev;
1439         bool success;
1440 
1441         if (contractBalance == 0 || totalTokensToSwap == 0) {
1442             return;
1443         }
1444 
1445         if (contractBalance > swapTokensAtAmount * 20) {
1446             contractBalance = swapTokensAtAmount * 20;
1447         }
1448 
1449         // Halve the amount of liquidity tokens
1450         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1451         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1452 
1453         uint256 initialETHBalance = address(this).balance;
1454 
1455         swapTokensForEth(amountToSwapForETH);
1456 
1457         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1458 
1459 		uint256 ethForCharity = ethBalance.mul(tokensForCharity).div(totalTokensToSwap);
1460         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1461         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1462 
1463         uint256 ethForLiquidity = ethBalance - ethForCharity - ethForMarketing - ethForDev;
1464 
1465         tokensForLiquidity = 0;
1466 		tokensForCharity = 0;
1467         tokensForMarketing = 0;
1468         tokensForDev = 0;
1469 
1470         (success, ) = address(devWallet).call{value: ethForDev}("");
1471         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1472 
1473 
1474         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1475             addLiquidity(liquidityTokens, ethForLiquidity);
1476             emit SwapAndLiquify(
1477                 amountToSwapForETH,
1478                 ethForLiquidity,
1479                 tokensForLiquidity
1480             );
1481         }
1482 
1483         (success, ) = address(charityWallet).call{value: address(this).balance}("");
1484     }
1485 
1486 }