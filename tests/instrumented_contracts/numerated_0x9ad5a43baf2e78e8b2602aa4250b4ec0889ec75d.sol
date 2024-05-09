1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 // CAUTION
9 // This version of SafeMath should only be used with Solidity 0.8 or later,
10 // because it relies on the compiler's built in overflow checks.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations.
14  *
15  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
16  * now has built in overflow checking.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             uint256 c = a + b;
27             if (c < a) return (false, 0);
28             return (true, c);
29         }
30     }
31 
32     /**
33      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (b > a) return (false, 0);
40             return (true, a - b);
41         }
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52             // benefit is lost if 'b' is also tested.
53             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54             if (a == 0) return (true, 0);
55             uint256 c = a * b;
56             if (c / a != b) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     /**
62      * @dev Returns the division of two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a % b);
82         }
83     }
84 
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      *
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a + b;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a - b;
111     }
112 
113     /**
114      * @dev Returns the multiplication of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `*` operator.
118      *
119      * Requirements:
120      *
121      * - Multiplication cannot overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a * b;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator.
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         unchecked {
172             require(b <= a, errorMessage);
173             return a - b;
174         }
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
190         unchecked {
191             require(b > 0, errorMessage);
192             return a / b;
193         }
194     }
195 
196     /**
197      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198      * reverting with custom message when dividing by zero.
199      *
200      * CAUTION: This function is deprecated because it requires allocating memory for the error
201      * message unnecessarily. For custom revert reasons use {tryMod}.
202      *
203      * Counterpart to Solidity's `%` operator. This function uses a `revert`
204      * opcode (which leaves remaining gas untouched) while Solidity uses an
205      * invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
212         unchecked {
213             require(b > 0, errorMessage);
214             return a % b;
215         }
216     }
217 }
218 
219 // File: @openzeppelin/contracts/utils/Context.sol
220 
221 
222 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
223 
224 pragma solidity ^0.8.0;
225 
226 /**
227  * @dev Provides information about the current execution context, including the
228  * sender of the transaction and its data. While these are generally available
229  * via msg.sender and msg.data, they should not be accessed in such a direct
230  * manner, since when dealing with meta-transactions the account sending and
231  * paying for execution may not be the actual sender (as far as an application
232  * is concerned).
233  *
234  * This contract is only required for intermediate, library-like contracts.
235  */
236 abstract contract Context {
237     function _msgSender() internal view virtual returns (address) {
238         return msg.sender;
239     }
240 
241     function _msgData() internal view virtual returns (bytes calldata) {
242         return msg.data;
243     }
244 }
245 
246 // File: @openzeppelin/contracts/access/Ownable.sol
247 
248 
249 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
250 
251 pragma solidity ^0.8.0;
252 
253 
254 /**
255  * @dev Contract module which provides a basic access control mechanism, where
256  * there is an account (an owner) that can be granted exclusive access to
257  * specific functions.
258  *
259  * By default, the owner account will be the one that deploys the contract. This
260  * can later be changed with {transferOwnership}.
261  *
262  * This module is used through inheritance. It will make available the modifier
263  * `onlyOwner`, which can be applied to your functions to restrict their use to
264  * the owner.
265  */
266 abstract contract Ownable is Context {
267     address private _owner;
268 
269     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
270 
271     /**
272      * @dev Initializes the contract setting the deployer as the initial owner.
273      */
274     constructor() {
275         _transferOwnership(_msgSender());
276     }
277 
278     /**
279      * @dev Throws if called by any account other than the owner.
280      */
281     modifier onlyOwner() {
282         _checkOwner();
283         _;
284     }
285 
286     /**
287      * @dev Returns the address of the current owner.
288      */
289     function owner() public view virtual returns (address) {
290         return _owner;
291     }
292 
293     /**
294      * @dev Throws if the sender is not the owner.
295      */
296     function _checkOwner() internal view virtual {
297         require(owner() == _msgSender(), "Ownable: caller is not the owner");
298     }
299 
300     /**
301      * @dev Leaves the contract without owner. It will not be possible to call
302      * `onlyOwner` functions. Can only be called by the current owner.
303      *
304      * NOTE: Renouncing ownership will leave the contract without an owner,
305      * thereby disabling any functionality that is only available to the owner.
306      */
307     function renounceOwnership() public virtual onlyOwner {
308         _transferOwnership(address(0));
309     }
310 
311     /**
312      * @dev Transfers ownership of the contract to a new account (`newOwner`).
313      * Can only be called by the current owner.
314      */
315     function transferOwnership(address newOwner) public virtual onlyOwner {
316         require(newOwner != address(0), "Ownable: new owner is the zero address");
317         _transferOwnership(newOwner);
318     }
319 
320     /**
321      * @dev Transfers ownership of the contract to a new account (`newOwner`).
322      * Internal function without access restriction.
323      */
324     function _transferOwnership(address newOwner) internal virtual {
325         address oldOwner = _owner;
326         _owner = newOwner;
327         emit OwnershipTransferred(oldOwner, newOwner);
328     }
329 }
330 
331 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
332 
333 
334 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
335 
336 pragma solidity ^0.8.0;
337 
338 /**
339  * @dev Interface of the ERC20 standard as defined in the EIP.
340  */
341 interface IERC20 {
342     /**
343      * @dev Emitted when `value` tokens are moved from one account (`from`) to
344      * another (`to`).
345      *
346      * Note that `value` may be zero.
347      */
348     event Transfer(address indexed from, address indexed to, uint256 value);
349 
350     /**
351      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
352      * a call to {approve}. `value` is the new allowance.
353      */
354     event Approval(address indexed owner, address indexed spender, uint256 value);
355 
356     /**
357      * @dev Returns the amount of tokens in existence.
358      */
359     function totalSupply() external view returns (uint256);
360 
361     /**
362      * @dev Returns the amount of tokens owned by `account`.
363      */
364     function balanceOf(address account) external view returns (uint256);
365 
366     /**
367      * @dev Moves `amount` tokens from the caller's account to `to`.
368      *
369      * Returns a boolean value indicating whether the operation succeeded.
370      *
371      * Emits a {Transfer} event.
372      */
373     function transfer(address to, uint256 amount) external returns (bool);
374 
375     /**
376      * @dev Returns the remaining number of tokens that `spender` will be
377      * allowed to spend on behalf of `owner` through {transferFrom}. This is
378      * zero by default.
379      *
380      * This value changes when {approve} or {transferFrom} are called.
381      */
382     function allowance(address owner, address spender) external view returns (uint256);
383 
384     /**
385      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
386      *
387      * Returns a boolean value indicating whether the operation succeeded.
388      *
389      * IMPORTANT: Beware that changing an allowance with this method brings the risk
390      * that someone may use both the old and the new allowance by unfortunate
391      * transaction ordering. One possible solution to mitigate this race
392      * condition is to first reduce the spender's allowance to 0 and set the
393      * desired value afterwards:
394      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
395      *
396      * Emits an {Approval} event.
397      */
398     function approve(address spender, uint256 amount) external returns (bool);
399 
400     /**
401      * @dev Moves `amount` tokens from `from` to `to` using the
402      * allowance mechanism. `amount` is then deducted from the caller's
403      * allowance.
404      *
405      * Returns a boolean value indicating whether the operation succeeded.
406      *
407      * Emits a {Transfer} event.
408      */
409     function transferFrom(address from, address to, uint256 amount) external returns (bool);
410 }
411 
412 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
413 
414 
415 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
416 
417 pragma solidity ^0.8.0;
418 
419 
420 /**
421  * @dev Interface for the optional metadata functions from the ERC20 standard.
422  *
423  * _Available since v4.1._
424  */
425 interface IERC20Metadata is IERC20 {
426     /**
427      * @dev Returns the name of the token.
428      */
429     function name() external view returns (string memory);
430 
431     /**
432      * @dev Returns the symbol of the token.
433      */
434     function symbol() external view returns (string memory);
435 
436     /**
437      * @dev Returns the decimals places of the token.
438      */
439     function decimals() external view returns (uint8);
440 }
441 
442 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
443 
444 
445 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
446 
447 pragma solidity ^0.8.0;
448 
449 
450 
451 
452 /**
453  * @dev Implementation of the {IERC20} interface.
454  *
455  * This implementation is agnostic to the way tokens are created. This means
456  * that a supply mechanism has to be added in a derived contract using {_mint}.
457  * For a generic mechanism see {ERC20PresetMinterPauser}.
458  *
459  * TIP: For a detailed writeup see our guide
460  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
461  * to implement supply mechanisms].
462  *
463  * The default value of {decimals} is 18. To change this, you should override
464  * this function so it returns a different value.
465  *
466  * We have followed general OpenZeppelin Contracts guidelines: functions revert
467  * instead returning `false` on failure. This behavior is nonetheless
468  * conventional and does not conflict with the expectations of ERC20
469  * applications.
470  *
471  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
472  * This allows applications to reconstruct the allowance for all accounts just
473  * by listening to said events. Other implementations of the EIP may not emit
474  * these events, as it isn't required by the specification.
475  *
476  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
477  * functions have been added to mitigate the well-known issues around setting
478  * allowances. See {IERC20-approve}.
479  */
480 contract ERC20 is Context, IERC20, IERC20Metadata {
481     mapping(address => uint256) private _balances;
482 
483     mapping(address => mapping(address => uint256)) private _allowances;
484 
485     uint256 private _totalSupply;
486 
487     string private _name;
488     string private _symbol;
489 
490     /**
491      * @dev Sets the values for {name} and {symbol}.
492      *
493      * All two of these values are immutable: they can only be set once during
494      * construction.
495      */
496     constructor(string memory name_, string memory symbol_) {
497         _name = name_;
498         _symbol = symbol_;
499     }
500 
501     /**
502      * @dev Returns the name of the token.
503      */
504     function name() public view virtual override returns (string memory) {
505         return _name;
506     }
507 
508     /**
509      * @dev Returns the symbol of the token, usually a shorter version of the
510      * name.
511      */
512     function symbol() public view virtual override returns (string memory) {
513         return _symbol;
514     }
515 
516     /**
517      * @dev Returns the number of decimals used to get its user representation.
518      * For example, if `decimals` equals `2`, a balance of `505` tokens should
519      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
520      *
521      * Tokens usually opt for a value of 18, imitating the relationship between
522      * Ether and Wei. This is the default value returned by this function, unless
523      * it's overridden.
524      *
525      * NOTE: This information is only used for _display_ purposes: it in
526      * no way affects any of the arithmetic of the contract, including
527      * {IERC20-balanceOf} and {IERC20-transfer}.
528      */
529     function decimals() public view virtual override returns (uint8) {
530         return 18;
531     }
532 
533     /**
534      * @dev See {IERC20-totalSupply}.
535      */
536     function totalSupply() public view virtual override returns (uint256) {
537         return _totalSupply;
538     }
539 
540     /**
541      * @dev See {IERC20-balanceOf}.
542      */
543     function balanceOf(address account) public view virtual override returns (uint256) {
544         return _balances[account];
545     }
546 
547     /**
548      * @dev See {IERC20-transfer}.
549      *
550      * Requirements:
551      *
552      * - `to` cannot be the zero address.
553      * - the caller must have a balance of at least `amount`.
554      */
555     function transfer(address to, uint256 amount) public virtual override returns (bool) {
556         address owner = _msgSender();
557         _transfer(owner, to, amount);
558         return true;
559     }
560 
561     /**
562      * @dev See {IERC20-allowance}.
563      */
564     function allowance(address owner, address spender) public view virtual override returns (uint256) {
565         return _allowances[owner][spender];
566     }
567 
568     /**
569      * @dev See {IERC20-approve}.
570      *
571      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
572      * `transferFrom`. This is semantically equivalent to an infinite approval.
573      *
574      * Requirements:
575      *
576      * - `spender` cannot be the zero address.
577      */
578     function approve(address spender, uint256 amount) public virtual override returns (bool) {
579         address owner = _msgSender();
580         _approve(owner, spender, amount);
581         return true;
582     }
583 
584     /**
585      * @dev See {IERC20-transferFrom}.
586      *
587      * Emits an {Approval} event indicating the updated allowance. This is not
588      * required by the EIP. See the note at the beginning of {ERC20}.
589      *
590      * NOTE: Does not update the allowance if the current allowance
591      * is the maximum `uint256`.
592      *
593      * Requirements:
594      *
595      * - `from` and `to` cannot be the zero address.
596      * - `from` must have a balance of at least `amount`.
597      * - the caller must have allowance for ``from``'s tokens of at least
598      * `amount`.
599      */
600     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
601         address spender = _msgSender();
602         _spendAllowance(from, spender, amount);
603         _transfer(from, to, amount);
604         return true;
605     }
606 
607     /**
608      * @dev Atomically increases the allowance granted to `spender` by the caller.
609      *
610      * This is an alternative to {approve} that can be used as a mitigation for
611      * problems described in {IERC20-approve}.
612      *
613      * Emits an {Approval} event indicating the updated allowance.
614      *
615      * Requirements:
616      *
617      * - `spender` cannot be the zero address.
618      */
619     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
620         address owner = _msgSender();
621         _approve(owner, spender, allowance(owner, spender) + addedValue);
622         return true;
623     }
624 
625     /**
626      * @dev Atomically decreases the allowance granted to `spender` by the caller.
627      *
628      * This is an alternative to {approve} that can be used as a mitigation for
629      * problems described in {IERC20-approve}.
630      *
631      * Emits an {Approval} event indicating the updated allowance.
632      *
633      * Requirements:
634      *
635      * - `spender` cannot be the zero address.
636      * - `spender` must have allowance for the caller of at least
637      * `subtractedValue`.
638      */
639     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
640         address owner = _msgSender();
641         uint256 currentAllowance = allowance(owner, spender);
642         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
643         unchecked {
644             _approve(owner, spender, currentAllowance - subtractedValue);
645         }
646 
647         return true;
648     }
649 
650     /**
651      * @dev Moves `amount` of tokens from `from` to `to`.
652      *
653      * This internal function is equivalent to {transfer}, and can be used to
654      * e.g. implement automatic token fees, slashing mechanisms, etc.
655      *
656      * Emits a {Transfer} event.
657      *
658      * Requirements:
659      *
660      * - `from` cannot be the zero address.
661      * - `to` cannot be the zero address.
662      * - `from` must have a balance of at least `amount`.
663      */
664     function _transfer(address from, address to, uint256 amount) internal virtual {
665         require(from != address(0), "ERC20: transfer from the zero address");
666         require(to != address(0), "ERC20: transfer to the zero address");
667 
668         _beforeTokenTransfer(from, to, amount);
669 
670         uint256 fromBalance = _balances[from];
671         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
672         unchecked {
673             _balances[from] = fromBalance - amount;
674             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
675             // decrementing then incrementing.
676             _balances[to] += amount;
677         }
678 
679         emit Transfer(from, to, amount);
680 
681         _afterTokenTransfer(from, to, amount);
682     }
683 
684     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
685      * the total supply.
686      *
687      * Emits a {Transfer} event with `from` set to the zero address.
688      *
689      * Requirements:
690      *
691      * - `account` cannot be the zero address.
692      */
693     function _mint(address account, uint256 amount) internal virtual {
694         require(account != address(0), "ERC20: mint to the zero address");
695 
696         _beforeTokenTransfer(address(0), account, amount);
697 
698         _totalSupply += amount;
699         unchecked {
700             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
701             _balances[account] += amount;
702         }
703         emit Transfer(address(0), account, amount);
704 
705         _afterTokenTransfer(address(0), account, amount);
706     }
707 
708     /**
709      * @dev Destroys `amount` tokens from `account`, reducing the
710      * total supply.
711      *
712      * Emits a {Transfer} event with `to` set to the zero address.
713      *
714      * Requirements:
715      *
716      * - `account` cannot be the zero address.
717      * - `account` must have at least `amount` tokens.
718      */
719     function _burn(address account, uint256 amount) internal virtual {
720         require(account != address(0), "ERC20: burn from the zero address");
721 
722         _beforeTokenTransfer(account, address(0), amount);
723 
724         uint256 accountBalance = _balances[account];
725         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
726         unchecked {
727             _balances[account] = accountBalance - amount;
728             // Overflow not possible: amount <= accountBalance <= totalSupply.
729             _totalSupply -= amount;
730         }
731 
732         emit Transfer(account, address(0), amount);
733 
734         _afterTokenTransfer(account, address(0), amount);
735     }
736 
737     /**
738      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
739      *
740      * This internal function is equivalent to `approve`, and can be used to
741      * e.g. set automatic allowances for certain subsystems, etc.
742      *
743      * Emits an {Approval} event.
744      *
745      * Requirements:
746      *
747      * - `owner` cannot be the zero address.
748      * - `spender` cannot be the zero address.
749      */
750     function _approve(address owner, address spender, uint256 amount) internal virtual {
751         require(owner != address(0), "ERC20: approve from the zero address");
752         require(spender != address(0), "ERC20: approve to the zero address");
753 
754         _allowances[owner][spender] = amount;
755         emit Approval(owner, spender, amount);
756     }
757 
758     /**
759      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
760      *
761      * Does not update the allowance amount in case of infinite allowance.
762      * Revert if not enough allowance is available.
763      *
764      * Might emit an {Approval} event.
765      */
766     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
767         uint256 currentAllowance = allowance(owner, spender);
768         if (currentAllowance != type(uint256).max) {
769             require(currentAllowance >= amount, "ERC20: insufficient allowance");
770             unchecked {
771                 _approve(owner, spender, currentAllowance - amount);
772             }
773         }
774     }
775 
776     /**
777      * @dev Hook that is called before any transfer of tokens. This includes
778      * minting and burning.
779      *
780      * Calling conditions:
781      *
782      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
783      * will be transferred to `to`.
784      * - when `from` is zero, `amount` tokens will be minted for `to`.
785      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
786      * - `from` and `to` are never both zero.
787      *
788      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
789      */
790     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
791 
792     /**
793      * @dev Hook that is called after any transfer of tokens. This includes
794      * minting and burning.
795      *
796      * Calling conditions:
797      *
798      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
799      * has been transferred to `to`.
800      * - when `from` is zero, `amount` tokens have been minted for `to`.
801      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
802      * - `from` and `to` are never both zero.
803      *
804      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
805      */
806     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
807 }
808 
809 // File: popi.sol
810 
811 //SPDX-License-Identifier: MIT
812 
813 
814 
815 
816 pragma solidity 0.8.19;
817 
818 interface DexFactory {
819     function createPair(
820         address tokenA,
821         address tokenB
822     ) external returns (address pair);
823 }
824 
825 interface DexRouter {
826     function factory() external pure returns (address);
827 
828     function WETH() external pure returns (address);
829 
830     function addLiquidityETH(
831         address token,
832         uint256 amountTokenDesired,
833         uint256 amountTokenMin,
834         uint256 amountETHMin,
835         address to,
836         uint256 deadline
837     )
838         external
839         payable
840         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
841 
842     function swapExactTokensForETHSupportingFeeOnTransferTokens(
843         uint256 amountIn,
844         uint256 amountOutMin,
845         address[] calldata path,
846         address to,
847         uint256 deadline
848     ) external;
849 }
850 
851 contract POPI is ERC20, Ownable {
852     struct Tax {
853         uint256 marketingTax;
854     }
855 
856     uint256 private constant _totalSupply = 420_690_000_000_000 * 1e18;
857 
858     //Router
859     DexRouter public immutable uniswapRouter;
860     address public immutable pairAddress;
861 
862     //Taxes
863     Tax public buyTaxes = Tax(5);
864     Tax public sellTaxes = Tax(5);
865     Tax public transferTaxes = Tax(5);
866 
867 
868 
869     //Whitelisting from taxes/maxwallet/txlimit/etc
870     mapping(address => bool) private whitelisted;
871     mapping(address => bool) private isblacklisted;
872     mapping(address => uint256) private _holderLastTransferTimestamp;
873 
874     //Swapping
875     uint256 public swapTokensAtAmount = _totalSupply / 1_000_000; //after 0.01% of total supply, swap them
876     bool public swapAndLiquifyEnabled = true;
877     bool public isSwapping = false;
878     bool public tradingEnabled = false;
879     uint256 public startTradingBlock;
880     bool public transferDelayEnabled = true;
881 
882     //Wallets
883     address public marketingWallet = 0x625ef188BcC8F27785F5036ef1dacf5f8e40cE2E ;
884     uint256 public maxWalletPercentage = 2;
885 
886 
887     //Events
888     event BuyFeesUpdated(uint256 indexed _trFee);
889     event SellFeesUpdated(uint256 indexed _trFee);
890     event marketingWalletChanged(address indexed _trWallet);
891     event SwapThresholdUpdated(uint256 indexed _newThreshold);
892     event InternalSwapStatusUpdated(bool indexed _status);
893     event Whitelist(address indexed _target, bool indexed _status);
894     event MaxWalletChanged(uint256 percentage);
895 
896     constructor() ERC20("POPI", "Popi") {
897 
898 
899        uniswapRouter = DexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // mainet
900         pairAddress = DexFactory(uniswapRouter.factory()).createPair(
901             address(this),
902             uniswapRouter.WETH()
903         );
904         whitelisted[msg.sender] = true;
905         whitelisted[address(uniswapRouter)] = true;
906         whitelisted[address(this)] = true;       
907         _mint(msg.sender, _totalSupply);
908  
909     }
910 
911     function setmarketingWallet(address _newmarketing) external onlyOwner {
912         require(
913             _newmarketing != address(0),
914             "can not set marketing to dead wallet"
915         );
916         marketingWallet = _newmarketing;
917         emit marketingWalletChanged(_newmarketing);
918     }
919     function enableTrading() external onlyOwner {
920         require(!tradingEnabled, "Trading is already enabled");
921         tradingEnabled = true;
922         startTradingBlock = block.number;
923     }
924 
925     function setBuyTaxes(uint256 _marketingTax) external onlyOwner {
926         buyTaxes.marketingTax = _marketingTax;
927         require(_marketingTax <= 30, "Can not set buy fees higher than 30%");
928         emit BuyFeesUpdated(_marketingTax);
929     }
930 
931     function setSellTaxes(uint256 _marketingTax) external onlyOwner {
932         sellTaxes.marketingTax = _marketingTax;
933         require(_marketingTax <= 30, "Can not set buy fees higher than 30%");
934         emit SellFeesUpdated(_marketingTax);
935     }
936 
937     function setSwapTokensAtAmount(uint256 _newAmount) external onlyOwner {
938         require(
939             _newAmount > 0 && _newAmount <= (_totalSupply * 5) / 1000,
940             "Minimum swap amount must be greater than 0 and less than 0.5% of total supply!"
941         );
942         swapTokensAtAmount = _newAmount;
943         emit SwapThresholdUpdated(swapTokensAtAmount);
944     }
945 
946     function toggleSwapping() external onlyOwner {
947         swapAndLiquifyEnabled = (swapAndLiquifyEnabled) ? false : true;
948     }
949 
950     function setWhitelistStatus(
951         address _wallet,
952         bool _status
953     ) external onlyOwner {
954         whitelisted[_wallet] = _status;
955         emit Whitelist(_wallet, _status);
956     }
957 
958     function checkWhitelist(address _wallet) external view returns (bool) {
959         return whitelisted[_wallet];
960     }
961     function setMaxWalletPercentage(uint256 _percentage) external onlyOwner {
962     require(_percentage > 1, "Percentage must be greater than 1%");
963     require(_percentage <= 100, "Percentage must be less than or equal to 100");
964     maxWalletPercentage = _percentage;
965     emit MaxWalletChanged(_percentage);
966 }
967 
968 
969     // this function is reponsible for managing tax, if _from or _to is whitelisted, we simply return _amount and skip all the limitations
970 function _takeTax(
971         address _from,
972         address _to,
973         uint256 _amount
974     ) internal returns (uint256) {
975         if (whitelisted[_from] || whitelisted[_to]) {
976             return _amount;
977         }
978 
979         uint256 totalTax = transferTaxes.marketingTax;
980 
981         if (_to == pairAddress) {
982             totalTax = sellTaxes.marketingTax;
983         } else if (_from == pairAddress) {
984             totalTax = buyTaxes.marketingTax;
985         }
986 
987 
988         uint256 tax = 0;
989         if (totalTax > 0) {
990             tax = (_amount * totalTax) / 100;
991             super._transfer(_from, address(this), tax);
992         }
993         return (_amount - tax);
994     }
995 
996 function _transfer(
997     address _from,
998     address _to,
999     uint256 _amount
1000 ) internal virtual override {
1001     // Add transfer delay logic
1002     if (transferDelayEnabled) {
1003         if (_to != address(pairAddress) && _to != address(pairAddress)) {
1004             require(_holderLastTransferTimestamp[tx.origin] < block.number, "Only one transfer per block allowed.");
1005             _holderLastTransferTimestamp[tx.origin] = block.number;
1006         }
1007     }
1008 
1009     require(_from != address(0), "transfer from address zero");
1010     require(_to != address(0), "transfer to address zero");
1011     require(_amount > 0, "Transfer amount must be greater than zero");
1012 
1013     // Check if the addresses are blacklisted
1014     require(!isblacklisted[_from], "Transfer from blacklisted address");
1015     require(!isblacklisted[_to], "Transfer to blacklisted address");
1016 
1017     // Calculate the maximum wallet amount based on the total supply and the maximum wallet percentage
1018     uint256 maxWalletAmount = _totalSupply * maxWalletPercentage / 100;
1019 
1020     // Check if the transaction is within the maximum wallet limit
1021     if (!whitelisted[_from] && !whitelisted[_to] && _to != address(0) && _to != address(this) && _to != pairAddress) {
1022         require(balanceOf(_to) + _amount <= maxWalletAmount, "Exceeds maximum wallet amount");
1023     }
1024 
1025     uint256 toTransfer = _takeTax(_from, _to, _amount);
1026 
1027     bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
1028     if (!whitelisted[_from] && !whitelisted[_to]) {
1029         require(tradingEnabled, "Trading not active");
1030         if (pairAddress == _to && swapAndLiquifyEnabled && canSwap && !isSwapping) {
1031             internalSwap();
1032         }
1033     }
1034 
1035     super._transfer(_from, _to, toTransfer);
1036 }
1037 
1038     function internalSwap() internal {
1039         isSwapping = true;
1040         uint256 taxAmount = balanceOf(address(this)); 
1041         if (taxAmount == 0) {
1042             return;
1043         }
1044         swapToETH(balanceOf(address(this)));
1045        (bool success, ) = marketingWallet.call{value: address(this).balance}("");
1046         require(success, "Transfer failed.");
1047         isSwapping = false;
1048     }
1049     function Isblacklisted(address a) public view returns (bool){
1050       return isblacklisted[a];
1051     }
1052 
1053     function addtoblacklist(address[] memory isblacklisted_) public onlyOwner {
1054         for (uint i = 0; i < isblacklisted_.length; i++) {
1055             isblacklisted[isblacklisted_[i]] = true;
1056         }
1057     }
1058 
1059     function removefromblacklist(address[] memory isnotblacklisted_) public onlyOwner {
1060       for (uint i = 0; i < isnotblacklisted_.length; i++) {
1061           isblacklisted[isnotblacklisted_[i]] = false;
1062       }
1063     }
1064 
1065         function removeLimits() external onlyOwner{
1066         maxWalletPercentage =100;
1067         transferDelayEnabled=false;
1068         transferTaxes.marketingTax = 0;
1069     }
1070 
1071     function swapToETH(uint256 _amount) internal {
1072         address[] memory path = new address[](2);
1073         path[0] = address(this);
1074         path[1] = uniswapRouter.WETH();
1075         _approve(address(this), address(uniswapRouter), _amount);
1076         uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1077             _amount,
1078             0,
1079             path,
1080             address(this),
1081             block.timestamp
1082         );
1083     }
1084 
1085     receive() external payable {}
1086 }