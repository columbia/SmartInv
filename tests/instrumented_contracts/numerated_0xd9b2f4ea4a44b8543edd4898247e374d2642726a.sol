1 pragma solidity =0.8.9 >=0.8.9 >=0.8.0 <0.9.0;
2 pragma experimental ABIEncoderV2;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 /**
25  * @dev Contract module which provides a basic access control mechanism, where
26  * there is an account (an owner) that can be granted exclusive access to
27  * specific functions.
28  *
29  * By default, the owner account will be the one that deploys the contract. This
30  * can later be changed with {transferOwnership}.
31  *
32  * This module is used through inheritance. It will make available the modifier
33  * `onlyOwner`, which can be applied to your functions to restrict their use to
34  * the owner.
35  */
36 abstract contract Ownable is Context {
37     address private _owner;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41     /**
42      * @dev Initializes the contract setting the deployer as the initial owner.
43      */
44     constructor() {
45         _transferOwnership(_msgSender());
46     }
47 
48     /**
49      * @dev Returns the address of the current owner.
50      */
51     function owner() public view virtual returns (address) {
52         return _owner;
53     }
54 
55     /**
56      * @dev Throws if called by any account other than the owner.
57      */
58     modifier onlyOwner() {
59         require(owner() == _msgSender(), "Ownable: caller is not the owner");
60         _;
61     }
62 
63     /**
64      * @dev Leaves the contract without owner. It will not be possible to call
65      * `onlyOwner` functions anymore. Can only be called by the current owner.
66      *
67      * NOTE: Renouncing ownership will leave the contract without an owner,
68      * thereby removing any functionality that is only available to the owner.
69      */
70     function renounceOwnership() public virtual onlyOwner {
71         _transferOwnership(address(0));
72     }
73 
74     /**
75      * @dev Transfers ownership of the contract to a new account (`newOwner`).
76      * Can only be called by the current owner.
77      */
78     function transferOwnership(address newOwner) public virtual onlyOwner {
79         require(newOwner != address(0), "Ownable: new owner is the zero address");
80         _transferOwnership(newOwner);
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Internal function without access restriction.
86      */
87     function _transferOwnership(address newOwner) internal virtual {
88         address oldOwner = _owner;
89         _owner = newOwner;
90         emit OwnershipTransferred(oldOwner, newOwner);
91     }
92 }
93 
94 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
95 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
96 
97 /* pragma solidity ^0.8.0; */
98 
99 /**
100  * @dev Interface of the ERC20 standard as defined in the EIP.
101  */
102 interface IERC20 {
103     /**
104      * @dev Returns the amount of tokens in existence.
105      */
106     function totalSupply() external view returns (uint256);
107 
108     /**
109      * @dev Returns the amount of tokens owned by `account`.
110      */
111     function balanceOf(address account) external view returns (uint256);
112 
113     /**
114      * @dev Moves `amount` tokens from the caller's account to `recipient`.
115      *
116      * Returns a boolean value indicating whether the operation succeeded.
117      *
118      * Emits a {Transfer} event.
119      */
120     function transfer(address recipient, uint256 amount) external returns (bool);
121 
122     /**
123      * @dev Returns the remaining number of tokens that `spender` will be
124      * allowed to spend on behalf of `owner` through {transferFrom}. This is
125      * zero by default.
126      *
127      * This value changes when {approve} or {transferFrom} are called.
128      */
129     function allowance(address owner, address spender) external view returns (uint256);
130 
131     /**
132      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
133      *
134      * Returns a boolean value indicating whether the operation succeeded.
135      *
136      * IMPORTANT: Beware that changing an allowance with this method brings the risk
137      * that someone may use both the old and the new allowance by unfortunate
138      * transaction ordering. One possible solution to mitigate this race
139      * condition is to first reduce the spender's allowance to 0 and set the
140      * desired value afterwards:
141      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
142      *
143      * Emits an {Approval} event.
144      */
145     function approve(address spender, uint256 amount) external returns (bool);
146 
147     /**
148      * @dev Moves `amount` tokens from `sender` to `recipient` using the
149      * allowance mechanism. `amount` is then deducted from the caller's
150      * allowance.
151      *
152      * Returns a boolean value indicating whether the operation succeeded.
153      *
154      * Emits a {Transfer} event.
155      */
156     function transferFrom(
157         address sender,
158         address recipient,
159         uint256 amount
160     ) external returns (bool);
161 
162     /**
163      * @dev Emitted when `value` tokens are moved from one account (`from`) to
164      * another (`to`).
165      *
166      * Note that `value` may be zero.
167      */
168     event Transfer(address indexed from, address indexed to, uint256 value);
169 
170     /**
171      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
172      * a call to {approve}. `value` is the new allowance.
173      */
174     event Approval(address indexed owner, address indexed spender, uint256 value);
175 }
176 
177 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
178 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
179 
180 /* pragma solidity ^0.8.0; */
181 
182 /* import "../IERC20.sol"; */
183 
184 /**
185  * @dev Interface for the optional metadata functions from the ERC20 standard.
186  *
187  * _Available since v4.1._
188  */
189 interface IERC20Metadata is IERC20 {
190     /**
191      * @dev Returns the name of the token.
192      */
193     function name() external view returns (string memory);
194 
195     /**
196      * @dev Returns the symbol of the token.
197      */
198     function symbol() external view returns (string memory);
199 
200     /**
201      * @dev Returns the decimals places of the token.
202      */
203     function decimals() external view returns (uint8);
204 }
205 
206 /**
207  * @dev Implementation of the {IERC20} interface.
208  *
209  * This implementation is agnostic to the way tokens are created. This means
210  * that a supply mechanism has to be added in a derived contract using {_mint}.
211  * For a generic mechanism see {ERC20PresetMinterPauser}.
212  *
213  * TIP: For a detailed writeup see our guide
214  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
215  * to implement supply mechanisms].
216  *
217  * We have followed general OpenZeppelin Contracts guidelines: functions revert
218  * instead returning `false` on failure. This behavior is nonetheless
219  * conventional and does not conflict with the expectations of ERC20
220  * applications.
221  *
222  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
223  * This allows applications to reconstruct the allowance for all accounts just
224  * by listening to said events. Other implementations of the EIP may not emit
225  * these events, as it isn't required by the specification.
226  *
227  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
228  * functions have been added to mitigate the well-known issues around setting
229  * allowances. See {IERC20-approve}.
230  */
231 contract ERC20 is Context, IERC20, IERC20Metadata {
232     mapping(address => uint256) private _balances;
233 
234     mapping(address => mapping(address => uint256)) private _allowances;
235 
236     uint256 private _totalSupply;
237 
238     string private _name;
239     string private _symbol;
240 
241     /**
242      * @dev Sets the values for {name} and {symbol}.
243      *
244      * The default value of {decimals} is 18. To select a different value for
245      * {decimals} you should overload it.
246      *
247      * All two of these values are immutable: they can only be set once during
248      * construction.
249      */
250     constructor(string memory name_, string memory symbol_) {
251         _name = name_;
252         _symbol = symbol_;
253     }
254 
255     /**
256      * @dev Returns the name of the token.
257      */
258     function name() public view virtual override returns (string memory) {
259         return _name;
260     }
261 
262     /**
263      * @dev Returns the symbol of the token, usually a shorter version of the
264      * name.
265      */
266     function symbol() public view virtual override returns (string memory) {
267         return _symbol;
268     }
269 
270     /**
271      * @dev Returns the number of decimals used to get its user representation.
272      * For example, if `decimals` equals `2`, a balance of `505` tokens should
273      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
274      *
275      * Tokens usually opt for a value of 18, imitating the relationship between
276      * Ether and Wei. This is the value {ERC20} uses, unless this function is
277      * overridden;
278      *
279      * NOTE: This information is only used for _display_ purposes: it in
280      * no way affects any of the arithmetic of the contract, including
281      * {IERC20-balanceOf} and {IERC20-transfer}.
282      */
283     function decimals() public view virtual override returns (uint8) {
284         return 18;
285     }
286 
287     /**
288      * @dev See {IERC20-totalSupply}.
289      */
290     function totalSupply() public view virtual override returns (uint256) {
291         return _totalSupply;
292     }
293 
294     /**
295      * @dev See {IERC20-balanceOf}.
296      */
297     function balanceOf(address account) public view virtual override returns (uint256) {
298         return _balances[account];
299     }
300 
301     /**
302      * @dev See {IERC20-transfer}.
303      *
304      * Requirements:
305      *
306      * - `recipient` cannot be the zero address.
307      * - the caller must have a balance of at least `amount`.
308      */
309     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
310         _transfer(_msgSender(), recipient, amount);
311         return true;
312     }
313 
314     /**
315      * @dev See {IERC20-allowance}.
316      */
317     function allowance(address owner, address spender) public view virtual override returns (uint256) {
318         return _allowances[owner][spender];
319     }
320 
321     /**
322      * @dev See {IERC20-approve}.
323      *
324      * Requirements:
325      *
326      * - `spender` cannot be the zero address.
327      */
328     function approve(address spender, uint256 amount) public virtual override returns (bool) {
329         _approve(_msgSender(), spender, amount);
330         return true;
331     }
332 
333     /**
334      * @dev See {IERC20-transferFrom}.
335      *
336      * Emits an {Approval} event indicating the updated allowance. This is not
337      * required by the EIP. See the note at the beginning of {ERC20}.
338      *
339      * Requirements:
340      *
341      * - `sender` and `recipient` cannot be the zero address.
342      * - `sender` must have a balance of at least `amount`.
343      * - the caller must have allowance for ``sender``'s tokens of at least
344      * `amount`.
345      */
346     function transferFrom(
347         address sender,
348         address recipient,
349         uint256 amount
350     ) public virtual override returns (bool) {
351         _transfer(sender, recipient, amount);
352 
353         uint256 currentAllowance = _allowances[sender][_msgSender()];
354         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
355         unchecked {
356             _approve(sender, _msgSender(), currentAllowance - amount);
357         }
358 
359         return true;
360     }
361 
362     /**
363      * @dev Atomically increases the allowance granted to `spender` by the caller.
364      *
365      * This is an alternative to {approve} that can be used as a mitigation for
366      * problems described in {IERC20-approve}.
367      *
368      * Emits an {Approval} event indicating the updated allowance.
369      *
370      * Requirements:
371      *
372      * - `spender` cannot be the zero address.
373      */
374     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
375         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
376         return true;
377     }
378 
379     /**
380      * @dev Atomically decreases the allowance granted to `spender` by the caller.
381      *
382      * This is an alternative to {approve} that can be used as a mitigation for
383      * problems described in {IERC20-approve}.
384      *
385      * Emits an {Approval} event indicating the updated allowance.
386      *
387      * Requirements:
388      *
389      * - `spender` cannot be the zero address.
390      * - `spender` must have allowance for the caller of at least
391      * `subtractedValue`.
392      */
393     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
394         uint256 currentAllowance = _allowances[_msgSender()][spender];
395         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
396         unchecked {
397             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
398         }
399 
400         return true;
401     }
402 
403     /**
404      * @dev Moves `amount` of tokens from `sender` to `recipient`.
405      *
406      * This internal function is equivalent to {transfer}, and can be used to
407      * e.g. implement automatic token fees, slashing mechanisms, etc.
408      *
409      * Emits a {Transfer} event.
410      *
411      * Requirements:
412      *
413      * - `sender` cannot be the zero address.
414      * - `recipient` cannot be the zero address.
415      * - `sender` must have a balance of at least `amount`.
416      */
417     function _transfer(
418         address sender,
419         address recipient,
420         uint256 amount
421     ) internal virtual {
422         require(sender != address(0), "ERC20: transfer from the zero address");
423         require(recipient != address(0), "ERC20: transfer to the zero address");
424 
425         _beforeTokenTransfer(sender, recipient, amount);
426 
427         uint256 senderBalance = _balances[sender];
428         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
429         unchecked {
430             _balances[sender] = senderBalance - amount;
431         }
432         _balances[recipient] += amount;
433 
434         emit Transfer(sender, recipient, amount);
435 
436         _afterTokenTransfer(sender, recipient, amount);
437     }
438 
439     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
440      * the total supply.
441      *
442      * Emits a {Transfer} event with `from` set to the zero address.
443      *
444      * Requirements:
445      *
446      * - `account` cannot be the zero address.
447      */
448     function _mint(address account, uint256 amount) internal virtual {
449         require(account != address(0), "ERC20: mint to the zero address");
450 
451         _beforeTokenTransfer(address(0), account, amount);
452 
453         _totalSupply += amount;
454         _balances[account] += amount;
455         emit Transfer(address(0), account, amount);
456 
457         _afterTokenTransfer(address(0), account, amount);
458     }
459 
460     /**
461      * @dev Destroys `amount` tokens from `account`, reducing the
462      * total supply.
463      *
464      * Emits a {Transfer} event with `to` set to the zero address.
465      *
466      * Requirements:
467      *
468      * - `account` cannot be the zero address.
469      * - `account` must have at least `amount` tokens.
470      */
471     function _burn(address account, uint256 amount) internal virtual {
472         require(account != address(0), "ERC20: burn from the zero address");
473 
474         _beforeTokenTransfer(account, address(0), amount);
475 
476         uint256 accountBalance = _balances[account];
477         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
478         unchecked {
479             _balances[account] = accountBalance - amount;
480         }
481         _totalSupply -= amount;
482 
483         emit Transfer(account, address(0), amount);
484 
485         _afterTokenTransfer(account, address(0), amount);
486     }
487 
488     /**
489      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
490      *
491      * This internal function is equivalent to `approve`, and can be used to
492      * e.g. set automatic allowances for certain subsystems, etc.
493      *
494      * Emits an {Approval} event.
495      *
496      * Requirements:
497      *
498      * - `owner` cannot be the zero address.
499      * - `spender` cannot be the zero address.
500      */
501     function _approve(
502         address owner,
503         address spender,
504         uint256 amount
505     ) internal virtual {
506         require(owner != address(0), "ERC20: approve from the zero address");
507         require(spender != address(0), "ERC20: approve to the zero address");
508 
509         _allowances[owner][spender] = amount;
510         emit Approval(owner, spender, amount);
511     }
512 
513     /**
514      * @dev Hook that is called before any transfer of tokens. This includes
515      * minting and burning.
516      *
517      * Calling conditions:
518      *
519      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
520      * will be transferred to `to`.
521      * - when `from` is zero, `amount` tokens will be minted for `to`.
522      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
523      * - `from` and `to` are never both zero.
524      *
525      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
526      */
527     function _beforeTokenTransfer(
528         address from,
529         address to,
530         uint256 amount
531     ) internal virtual {}
532 
533     /**
534      * @dev Hook that is called after any transfer of tokens. This includes
535      * minting and burning.
536      *
537      * Calling conditions:
538      *
539      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
540      * has been transferred to `to`.
541      * - when `from` is zero, `amount` tokens have been minted for `to`.
542      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
543      * - `from` and `to` are never both zero.
544      *
545      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
546      */
547     function _afterTokenTransfer(
548         address from,
549         address to,
550         uint256 amount
551     ) internal virtual {}
552 }
553 
554 /**
555  * @dev Wrappers over Solidity's arithmetic operations.
556  *
557  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
558  * now has built in overflow checking.
559  */
560 library SafeMath {
561     /**
562      * @dev Returns the addition of two unsigned integers, with an overflow flag.
563      *
564      * _Available since v3.4._
565      */
566     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
567         unchecked {
568             uint256 c = a + b;
569             if (c < a) return (false, 0);
570             return (true, c);
571         }
572     }
573 
574     /**
575      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
576      *
577      * _Available since v3.4._
578      */
579     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
580         unchecked {
581             if (b > a) return (false, 0);
582             return (true, a - b);
583         }
584     }
585 
586     /**
587      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
588      *
589      * _Available since v3.4._
590      */
591     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
592         unchecked {
593             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
594             // benefit is lost if 'b' is also tested.
595             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
596             if (a == 0) return (true, 0);
597             uint256 c = a * b;
598             if (c / a != b) return (false, 0);
599             return (true, c);
600         }
601     }
602 
603     /**
604      * @dev Returns the division of two unsigned integers, with a division by zero flag.
605      *
606      * _Available since v3.4._
607      */
608     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
609         unchecked {
610             if (b == 0) return (false, 0);
611             return (true, a / b);
612         }
613     }
614 
615     /**
616      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
617      *
618      * _Available since v3.4._
619      */
620     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
621         unchecked {
622             if (b == 0) return (false, 0);
623             return (true, a % b);
624         }
625     }
626 
627     /**
628      * @dev Returns the addition of two unsigned integers, reverting on
629      * overflow.
630      *
631      * Counterpart to Solidity's `+` operator.
632      *
633      * Requirements:
634      *
635      * - Addition cannot overflow.
636      */
637     function add(uint256 a, uint256 b) internal pure returns (uint256) {
638         return a + b;
639     }
640 
641     /**
642      * @dev Returns the subtraction of two unsigned integers, reverting on
643      * overflow (when the result is negative).
644      *
645      * Counterpart to Solidity's `-` operator.
646      *
647      * Requirements:
648      *
649      * - Subtraction cannot overflow.
650      */
651     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
652         return a - b;
653     }
654 
655     /**
656      * @dev Returns the multiplication of two unsigned integers, reverting on
657      * overflow.
658      *
659      * Counterpart to Solidity's `*` operator.
660      *
661      * Requirements:
662      *
663      * - Multiplication cannot overflow.
664      */
665     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
666         return a * b;
667     }
668 
669     /**
670      * @dev Returns the integer division of two unsigned integers, reverting on
671      * division by zero. The result is rounded towards zero.
672      *
673      * Counterpart to Solidity's `/` operator.
674      *
675      * Requirements:
676      *
677      * - The divisor cannot be zero.
678      */
679     function div(uint256 a, uint256 b) internal pure returns (uint256) {
680         return a / b;
681     }
682 
683     /**
684      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
685      * reverting when dividing by zero.
686      *
687      * Counterpart to Solidity's `%` operator. This function uses a `revert`
688      * opcode (which leaves remaining gas untouched) while Solidity uses an
689      * invalid opcode to revert (consuming all remaining gas).
690      *
691      * Requirements:
692      *
693      * - The divisor cannot be zero.
694      */
695     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
696         return a % b;
697     }
698 
699     /**
700      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
701      * overflow (when the result is negative).
702      *
703      * CAUTION: This function is deprecated because it requires allocating memory for the error
704      * message unnecessarily. For custom revert reasons use {trySub}.
705      *
706      * Counterpart to Solidity's `-` operator.
707      *
708      * Requirements:
709      *
710      * - Subtraction cannot overflow.
711      */
712     function sub(
713         uint256 a,
714         uint256 b,
715         string memory errorMessage
716     ) internal pure returns (uint256) {
717         unchecked {
718             require(b <= a, errorMessage);
719             return a - b;
720         }
721     }
722 
723     /**
724      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
725      * division by zero. The result is rounded towards zero.
726      *
727      * Counterpart to Solidity's `/` operator. Note: this function uses a
728      * `revert` opcode (which leaves remaining gas untouched) while Solidity
729      * uses an invalid opcode to revert (consuming all remaining gas).
730      *
731      * Requirements:
732      *
733      * - The divisor cannot be zero.
734      */
735     function div(
736         uint256 a,
737         uint256 b,
738         string memory errorMessage
739     ) internal pure returns (uint256) {
740         unchecked {
741             require(b > 0, errorMessage);
742             return a / b;
743         }
744     }
745 
746     /**
747      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
748      * reverting with custom message when dividing by zero.
749      *
750      * CAUTION: This function is deprecated because it requires allocating memory for the error
751      * message unnecessarily. For custom revert reasons use {tryMod}.
752      *
753      * Counterpart to Solidity's `%` operator. This function uses a `revert`
754      * opcode (which leaves remaining gas untouched) while Solidity uses an
755      * invalid opcode to revert (consuming all remaining gas).
756      *
757      * Requirements:
758      *
759      * - The divisor cannot be zero.
760      */
761     function mod(
762         uint256 a,
763         uint256 b,
764         string memory errorMessage
765     ) internal pure returns (uint256) {
766         unchecked {
767             require(b > 0, errorMessage);
768             return a % b;
769         }
770     }
771 }
772 
773 interface IUniswapV2Factory {
774     event PairCreated(
775         address indexed token0,
776         address indexed token1,
777         address pair,
778         uint256
779     );
780 
781     function feeTo() external view returns (address);
782 
783     function feeToSetter() external view returns (address);
784 
785     function getPair(address tokenA, address tokenB)
786         external
787         view
788         returns (address pair);
789 
790     function allPairs(uint256) external view returns (address pair);
791 
792     function allPairsLength() external view returns (uint256);
793 
794     function createPair(address tokenA, address tokenB)
795         external
796         returns (address pair);
797 
798     function setFeeTo(address) external;
799 
800     function setFeeToSetter(address) external;
801 }
802 
803 ////// src/IUniswapV2Pair.sol
804 /* pragma solidity 0.8.10; */
805 /* pragma experimental ABIEncoderV2; */
806 
807 interface IUniswapV2Pair {
808     event Approval(
809         address indexed owner,
810         address indexed spender,
811         uint256 value
812     );
813     event Transfer(address indexed from, address indexed to, uint256 value);
814 
815     function name() external pure returns (string memory);
816 
817     function symbol() external pure returns (string memory);
818 
819     function decimals() external pure returns (uint8);
820 
821     function totalSupply() external view returns (uint256);
822 
823     function balanceOf(address owner) external view returns (uint256);
824 
825     function allowance(address owner, address spender)
826         external
827         view
828         returns (uint256);
829 
830     function approve(address spender, uint256 value) external returns (bool);
831 
832     function transfer(address to, uint256 value) external returns (bool);
833 
834     function transferFrom(
835         address from,
836         address to,
837         uint256 value
838     ) external returns (bool);
839 
840     function DOMAIN_SEPARATOR() external view returns (bytes32);
841 
842     function PERMIT_TYPEHASH() external pure returns (bytes32);
843 
844     function nonces(address owner) external view returns (uint256);
845 
846     function permit(
847         address owner,
848         address spender,
849         uint256 value,
850         uint256 deadline,
851         uint8 v,
852         bytes32 r,
853         bytes32 s
854     ) external;
855 
856     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
857     event Burn(
858         address indexed sender,
859         uint256 amount0,
860         uint256 amount1,
861         address indexed to
862     );
863     event Swap(
864         address indexed sender,
865         uint256 amount0In,
866         uint256 amount1In,
867         uint256 amount0Out,
868         uint256 amount1Out,
869         address indexed to
870     );
871     event Sync(uint112 reserve0, uint112 reserve1);
872 
873     function MINIMUM_LIQUIDITY() external pure returns (uint256);
874 
875     function factory() external view returns (address);
876 
877     function token0() external view returns (address);
878 
879     function token1() external view returns (address);
880 
881     function getReserves()
882         external
883         view
884         returns (
885             uint112 reserve0,
886             uint112 reserve1,
887             uint32 blockTimestampLast
888         );
889 
890     function price0CumulativeLast() external view returns (uint256);
891 
892     function price1CumulativeLast() external view returns (uint256);
893 
894     function kLast() external view returns (uint256);
895 
896     function mint(address to) external returns (uint256 liquidity);
897 
898     function burn(address to)
899         external
900         returns (uint256 amount0, uint256 amount1);
901 
902     function swap(
903         uint256 amount0Out,
904         uint256 amount1Out,
905         address to,
906         bytes calldata data
907     ) external;
908 
909     function skim(address to) external;
910 
911     function sync() external;
912 
913     function initialize(address, address) external;
914 }
915 
916 interface IUniswapV2Router02 {
917     function factory() external pure returns (address);
918 
919     function WETH() external pure returns (address);
920 
921     function addLiquidity(
922         address tokenA,
923         address tokenB,
924         uint256 amountADesired,
925         uint256 amountBDesired,
926         uint256 amountAMin,
927         uint256 amountBMin,
928         address to,
929         uint256 deadline
930     )
931         external
932         returns (
933             uint256 amountA,
934             uint256 amountB,
935             uint256 liquidity
936         );
937 
938     function addLiquidityETH(
939         address token,
940         uint256 amountTokenDesired,
941         uint256 amountTokenMin,
942         uint256 amountETHMin,
943         address to,
944         uint256 deadline
945     )
946         external
947         payable
948         returns (
949             uint256 amountToken,
950             uint256 amountETH,
951             uint256 liquidity
952         );
953 
954     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
955         uint256 amountIn,
956         uint256 amountOutMin,
957         address[] calldata path,
958         address to,
959         uint256 deadline
960     ) external;
961 
962     function swapExactETHForTokensSupportingFeeOnTransferTokens(
963         uint256 amountOutMin,
964         address[] calldata path,
965         address to,
966         uint256 deadline
967     ) external payable;
968 
969     function swapExactTokensForETHSupportingFeeOnTransferTokens(
970         uint256 amountIn,
971         uint256 amountOutMin,
972         address[] calldata path,
973         address to,
974         uint256 deadline
975     ) external;
976 }
977 
978 contract EthScape is ERC20, Ownable {
979     using SafeMath for uint256;
980 
981     IUniswapV2Router02 public immutable uniswapV2Router;
982     address public immutable uniswapV2Pair;
983     address public constant deadAddress = address(0xdead);
984 
985     bool private swapping;
986 
987     address public gameDevelopmentWallet;
988     address public marketingWallet;
989     address public devWallet;
990     address public p2eWallet;
991 
992     uint256 public maxTransactionAmount;
993     uint256 public swapTokensAtAmount;
994     uint256 public maxWallet;
995 
996     uint256 public percentForLPBurn = 25; // 25 = .25%
997     bool public lpBurnEnabled = false;
998     uint256 public lpBurnFrequency = 3600 seconds;
999     uint256 public lastLpBurnTime;
1000 
1001     uint256 public manualBurnFrequency = 30 minutes;
1002     uint256 public lastManualLpBurnTime;
1003 
1004     bool public limitsInEffect = true;
1005     bool public tradingActive = false;
1006     bool public swapEnabled = false;
1007 
1008     // Anti-bot and anti-whale mappings and variables
1009     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1010     mapping(address => bool) blacklisted;
1011     bool public transferDelayEnabled = true;
1012 
1013     uint256 public buyTotalFees;
1014     uint256 public buyGameDevelopmentFee;
1015     uint256 public buyMarketingFee;
1016     uint256 public buyLiquidityFee;
1017     uint256 public buyDevFee;
1018     uint256 public buyP2eFee;
1019 
1020     uint256 public sellTotalFees;
1021     uint256 public sellGameDevelopmentFee;
1022     uint256 public sellMarketingFee;
1023     uint256 public sellLiquidityFee;
1024     uint256 public sellDevFee;
1025     uint256 public sellP2eFee;
1026 
1027     uint256 public tokensForGameDevelopment;
1028     uint256 public tokensForMarketing;
1029     uint256 public tokensForLiquidity;
1030     uint256 public tokensForDev;
1031     uint256 public tokensForP2e;
1032 
1033     /******************/
1034 
1035     // exclude from fees and max transaction amount
1036     mapping(address => bool) private _isExcludedFromFees;
1037     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1038 
1039     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1040     // could be subject to a maximum transfer amount
1041     mapping(address => bool) public automatedMarketMakerPairs;
1042 
1043     event UpdateUniswapV2Router(
1044         address indexed newAddress,
1045         address indexed oldAddress
1046     );
1047 
1048     event ExcludeFromFees(address indexed account, bool isExcluded);
1049 
1050     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1051 
1052     event gameDevelopmentWalletUpdated(
1053         address indexed newWallet,
1054         address indexed oldWallet
1055     );
1056 
1057     event marketingWalletUpdated(
1058         address indexed newWallet,
1059         address indexed oldWallet
1060     );
1061 
1062     event devWalletUpdated(
1063         address indexed newWallet,
1064         address indexed oldWallet
1065     );
1066 
1067     event p2eWalletUpdated(
1068         address indexed newWallet,
1069         address indexed oldWallet
1070     );
1071 
1072     event SwapAndLiquify(
1073         uint256 tokensSwapped,
1074         uint256 ethReceived,
1075         uint256 tokensIntoLiquidity
1076     );
1077 
1078     event AutoNukeLP();
1079 
1080     event ManualNukeLP();
1081 
1082     constructor() ERC20("EthScape", "ESC") {
1083         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1084             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1085         );
1086 
1087         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1088         uniswapV2Router = _uniswapV2Router;
1089 
1090         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1091             .createPair(address(this), _uniswapV2Router.WETH());
1092         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1093         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1094 
1095         uint256 _buyGameDevelopmentFee = 1;
1096         uint256 _buyMarketingFee = 1;
1097         uint256 _buyLiquidityFee = 1;
1098         uint256 _buyDevFee = 1;
1099         uint256 _buyP2eFee = 1;
1100 
1101         uint256 _sellGameDevelopmentFee = 2;
1102         uint256 _sellMarketingFee = 1;
1103         uint256 _sellLiquidityFee = 1;
1104         uint256 _sellDevFee = 1;
1105         uint256 _sellP2eFee = 2;
1106 
1107         uint256 totalSupply = 10_000_000 * 1e18;
1108 
1109         maxTransactionAmount = 25_000 * 1e18; // 0.25% from total supply
1110         maxWallet = 200_000 * 1e18; // 2% from total supply maxWallet
1111         swapTokensAtAmount = 5_000 * 1e18; // 0.05% swap wallet
1112 
1113         buyGameDevelopmentFee = _buyGameDevelopmentFee;
1114         buyMarketingFee = _buyMarketingFee;
1115         buyLiquidityFee = _buyLiquidityFee;
1116         buyDevFee = _buyDevFee;
1117         buyP2eFee = _buyP2eFee;
1118         buyTotalFees = buyGameDevelopmentFee + buyMarketingFee + buyLiquidityFee + buyDevFee + buyP2eFee;
1119 
1120         sellGameDevelopmentFee = _sellGameDevelopmentFee;
1121         sellMarketingFee = _sellMarketingFee;
1122         sellLiquidityFee = _sellLiquidityFee;
1123         sellDevFee = _sellDevFee;
1124         sellP2eFee = _sellP2eFee;
1125         sellTotalFees = sellGameDevelopmentFee + sellMarketingFee + sellLiquidityFee + sellDevFee + sellP2eFee;
1126 
1127         gameDevelopmentWallet = address(0xaF6ffB3b48823Be1F4B500E0eBaEcaf8A8247356); // set as gameDevelopment wallet
1128         marketingWallet = address(0xE2485E5c03A7725e30345258605787A1b09e5f1f); // set as marketing wallet
1129         devWallet = address(0x3fA94552749e71FCdE884625dc968539535a2c33); // set as dev wallet
1130         p2eWallet = address(0x8A63CAAc0c8e388E5d3C31efd585C154A5C06259); // set as p2e wallet
1131 
1132         // exclude from paying fees or having max transaction amount
1133         excludeFromFees(owner(), true);
1134         excludeFromFees(address(this), true);
1135         excludeFromFees(address(0xdead), true);
1136 
1137         excludeFromMaxTransaction(owner(), true);
1138         excludeFromMaxTransaction(address(this), true);
1139         excludeFromMaxTransaction(address(0xdead), true);
1140 
1141         /*
1142             _mint is an internal function in ERC20.sol that is only called here,
1143             and CANNOT be called ever again
1144         */
1145         _mint(msg.sender, totalSupply);
1146     }
1147 
1148     receive() external payable {}
1149 
1150     // once enabled, can never be turned off
1151     function enableTrading() external onlyOwner {
1152         tradingActive = true;
1153         swapEnabled = true;
1154         lastLpBurnTime = block.timestamp;
1155     }
1156 
1157     // remove limits after token is stable
1158     function removeLimits() external onlyOwner returns (bool) {
1159         limitsInEffect = false;
1160         return true;
1161     }
1162 
1163     function enableLimits() external onlyOwner returns (bool) {
1164         limitsInEffect = true;
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
1194             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1195             "Cannot set maxTransactionAmount lower than 0.1%"
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
1221         uint256 _gameDevelopmentFee,
1222         uint256 _marketingFee,
1223         uint256 _liquidityFee,
1224         uint256 _devFee,
1225         uint256 _p2eFee
1226     ) external onlyOwner {
1227         buyGameDevelopmentFee = _gameDevelopmentFee;
1228         buyMarketingFee = _marketingFee;
1229         buyLiquidityFee = _liquidityFee;
1230         buyDevFee = _devFee;
1231         buyP2eFee = _p2eFee;
1232         buyTotalFees = buyGameDevelopmentFee + buyMarketingFee + buyLiquidityFee + buyDevFee + buyP2eFee;
1233         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1234     }
1235 
1236     function updateSellFees(
1237         uint256 _gameDevelopmentFee,
1238         uint256 _marketingFee,
1239         uint256 _liquidityFee,
1240         uint256 _devFee,
1241         uint256 _p2eFee
1242     ) external onlyOwner {
1243         sellGameDevelopmentFee = _gameDevelopmentFee;
1244         sellMarketingFee = _marketingFee;
1245         sellLiquidityFee = _liquidityFee;
1246         sellDevFee = _devFee;
1247         sellP2eFee = _p2eFee;
1248         sellTotalFees = sellGameDevelopmentFee + sellMarketingFee + sellLiquidityFee + sellDevFee + sellP2eFee;
1249         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
1250     }
1251 
1252     function excludeFromFees(address account, bool excluded) public onlyOwner {
1253         _isExcludedFromFees[account] = excluded;
1254         emit ExcludeFromFees(account, excluded);
1255     }
1256 
1257     function setAutomatedMarketMakerPair(address pair, bool value)
1258         public
1259         onlyOwner
1260     {
1261         require(
1262             pair != uniswapV2Pair,
1263             "The pair cannot be removed from automatedMarketMakerPairs"
1264         );
1265 
1266         _setAutomatedMarketMakerPair(pair, value);
1267     }
1268 
1269     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1270         automatedMarketMakerPairs[pair] = value;
1271 
1272         emit SetAutomatedMarketMakerPair(pair, value);
1273     }
1274 
1275     function updateGameDevelopmentWallet(address newGameDevelopmentWallet) external onlyOwner {
1276         emit gameDevelopmentWalletUpdated(newGameDevelopmentWallet, gameDevelopmentWallet);
1277         gameDevelopmentWallet = newGameDevelopmentWallet;
1278     }
1279 
1280     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1281         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1282         marketingWallet = newMarketingWallet;
1283     }
1284 
1285     function updateDevWallet(address newWallet) external onlyOwner {
1286         emit devWalletUpdated(newWallet, devWallet);
1287         devWallet = newWallet;
1288     }
1289 
1290     function updateP2eWallet(address newWallet) external onlyOwner {
1291         emit p2eWalletUpdated(newWallet, p2eWallet);
1292         p2eWallet = newWallet;
1293     }
1294 
1295     function isExcludedFromFees(address account) public view returns (bool) {
1296         return _isExcludedFromFees[account];
1297     }
1298 
1299     function isBlacklisted(address account) public view returns (bool) {
1300         return blacklisted[account];
1301     }
1302 
1303     function _transfer(
1304         address from,
1305         address to,
1306         uint256 amount
1307     ) internal override {
1308         require(from != address(0), "ERC20: transfer from the zero address");
1309         require(to != address(0), "ERC20: transfer to the zero address");
1310         require(!blacklisted[from],"Sender blacklisted");
1311         require(!blacklisted[to],"Receiver blacklisted");
1312 
1313         if (amount == 0) {
1314             super._transfer(from, to, 0);
1315             return;
1316         }
1317 
1318         if (limitsInEffect) {
1319             if (
1320                 from != owner() &&
1321                 to != owner() &&
1322                 to != address(0) &&
1323                 to != address(0xdead) &&
1324                 !swapping
1325             ) {
1326                 if (!tradingActive) {
1327                     require(
1328                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1329                         "Trading is not active."
1330                     );
1331                 }
1332 
1333                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1334                 if (transferDelayEnabled) {
1335                     if (
1336                         to != owner() &&
1337                         to != address(uniswapV2Router) &&
1338                         to != address(uniswapV2Pair)
1339                     ) {
1340                         require(
1341                             _holderLastTransferTimestamp[tx.origin] + 1 <
1342                                 block.number,
1343                             "_transfer:: Transfer Delay enabled.  Only one purchase per two blocks allowed."
1344                         );
1345                         _holderLastTransferTimestamp[tx.origin] = block.number;
1346                     }
1347                 }
1348 
1349                 //when buy
1350                 if (
1351                     automatedMarketMakerPairs[from] &&
1352                     !_isExcludedMaxTransactionAmount[to]
1353                 ) {
1354                     require(
1355                         amount <= maxTransactionAmount,
1356                         "Buy transfer amount exceeds the maxTransactionAmount."
1357                     );
1358                     require(
1359                         amount + balanceOf(to) <= maxWallet,
1360                         "Max wallet exceeded"
1361                     );
1362                 }
1363                 //when sell
1364                 else if (
1365                     automatedMarketMakerPairs[to] &&
1366                     !_isExcludedMaxTransactionAmount[from]
1367                 ) {
1368                     require(
1369                         amount <= maxTransactionAmount,
1370                         "Sell transfer amount exceeds the maxTransactionAmount."
1371                     );
1372                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1373                     require(
1374                         amount + balanceOf(to) <= maxWallet,
1375                         "Max wallet exceeded"
1376                     );
1377                 }
1378             }
1379         }
1380 
1381         uint256 contractTokenBalance = balanceOf(address(this));
1382 
1383         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1384 
1385         if (
1386             canSwap &&
1387             swapEnabled &&
1388             !swapping &&
1389             !automatedMarketMakerPairs[from] &&
1390             !_isExcludedFromFees[from] &&
1391             !_isExcludedFromFees[to]
1392         ) {
1393             swapping = true;
1394 
1395             swapBack();
1396 
1397             swapping = false;
1398         }
1399 
1400         if (
1401             !swapping &&
1402             automatedMarketMakerPairs[to] &&
1403             lpBurnEnabled &&
1404             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1405             !_isExcludedFromFees[from]
1406         ) {
1407             autoBurnLiquidityPairTokens();
1408         }
1409 
1410         bool takeFee = !swapping;
1411 
1412         // if any account belongs to _isExcludedFromFee account then remove the fee
1413         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1414             takeFee = false;
1415         }
1416 
1417         uint256 fees = 0;
1418         // only take fees on buys/sells, do not take on wallet transfers
1419         if (takeFee) {
1420             // on sell
1421             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1422                 fees = amount.mul(sellTotalFees).div(100);
1423                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1424                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1425                 tokensForGameDevelopment += (fees * sellGameDevelopmentFee) / sellTotalFees;
1426                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1427                 tokensForP2e += (fees * sellP2eFee) / sellTotalFees;
1428             }
1429             // on buy
1430             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1431                 fees = amount.mul(buyTotalFees).div(100);
1432                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1433                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1434                 tokensForGameDevelopment += (fees * buyGameDevelopmentFee) / buyTotalFees;
1435                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1436                 tokensForP2e += (fees * buyP2eFee) / buyTotalFees;
1437             }
1438 
1439             if (fees > 0) {
1440                 super._transfer(from, address(this), fees);
1441             }
1442 
1443             amount -= fees;
1444         }
1445 
1446         super._transfer(from, to, amount);
1447     }
1448 
1449     function swapTokensForEth(uint256 tokenAmount) private {
1450         // generate the uniswap pair path of token -> weth
1451         address[] memory path = new address[](2);
1452         path[0] = address(this);
1453         path[1] = uniswapV2Router.WETH();
1454 
1455         _approve(address(this), address(uniswapV2Router), tokenAmount);
1456 
1457         // make the swap
1458         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1459             tokenAmount,
1460             0, // accept any amount of ETH
1461             path,
1462             address(this),
1463             block.timestamp
1464         );
1465     }
1466 
1467     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1468         // approve token transfer to cover all possible scenarios
1469         _approve(address(this), address(uniswapV2Router), tokenAmount);
1470 
1471         // add the liquidity
1472         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1473             address(this),
1474             tokenAmount,
1475             0, // slippage is unavoidable
1476             0, // slippage is unavoidable
1477             owner(),
1478             block.timestamp
1479         );
1480     }
1481 
1482     function swapBack() private {
1483         uint256 contractBalance = balanceOf(address(this));
1484         uint256 totalTokensToSwap = tokensForLiquidity +
1485             tokensForGameDevelopment +
1486             tokensForMarketing +
1487             tokensForDev;
1488         bool success;
1489 
1490         if (contractBalance == 0 || totalTokensToSwap == 0) {
1491             return;
1492         }
1493 
1494         if (contractBalance > swapTokensAtAmount * 20) {
1495             contractBalance = swapTokensAtAmount * 20;
1496         }
1497 
1498         // Halve the amount of liquidity tokens
1499         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1500             totalTokensToSwap /
1501             2;
1502         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens + tokensForP2e);
1503 
1504         uint256 initialETHBalance = address(this).balance;
1505 
1506         swapTokensForEth(amountToSwapForETH);
1507 
1508         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1509 
1510         uint256 ethForGameDevelopment = ethBalance.mul(tokensForGameDevelopment).div(totalTokensToSwap - (tokensForLiquidity / 2));
1511 
1512         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap - (tokensForLiquidity / 2));
1513         
1514         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap - (tokensForLiquidity / 2));
1515 
1516         uint256 ethForLiquidity = ethBalance - ethForGameDevelopment - ethForMarketing - ethForDev;
1517 
1518         IERC20(address(this)).transfer(p2eWallet, tokensForP2e);
1519         
1520         tokensForP2e = 0;
1521         tokensForGameDevelopment = 0;
1522         tokensForMarketing = 0;
1523         tokensForDev = 0;
1524 
1525         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1526             addLiquidity(liquidityTokens, ethForLiquidity);
1527             emit SwapAndLiquify(
1528                 amountToSwapForETH,
1529                 ethForLiquidity,
1530                 tokensForLiquidity
1531             );
1532         }
1533 
1534         tokensForLiquidity = 0;
1535 
1536         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1537 
1538         (success, ) = address(gameDevelopmentWallet).call{value: ethForGameDevelopment}("");
1539 
1540         (success, ) = address(devWallet).call{value: address(this).balance}("");
1541     }
1542 
1543     function setAutoLPBurnSettings(
1544         uint256 _frequencyInSeconds,
1545         uint256 _percent,
1546         bool _Enabled
1547     ) external onlyOwner {
1548         require(
1549             _frequencyInSeconds >= 600,
1550             "cannot set buyback more often than every 10 minutes"
1551         );
1552         require(
1553             _percent <= 1000 && _percent >= 0,
1554             "Must set auto LP burn percent between 0% and 10%"
1555         );
1556         lpBurnFrequency = _frequencyInSeconds;
1557         percentForLPBurn = _percent;
1558         lpBurnEnabled = _Enabled;
1559     }
1560 
1561     function autoBurnLiquidityPairTokens() internal returns (bool) {
1562         lastLpBurnTime = block.timestamp;
1563 
1564         // get balance of liquidity pair
1565         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1566 
1567         // calculate amount to burn
1568         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1569             10000
1570         );
1571 
1572         // pull tokens from Pair liquidity and move to dead address permanently
1573         if (amountToBurn > 0) {
1574             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1575         }
1576 
1577         //sync price since this is not in a swap transaction!
1578         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1579         pair.sync();
1580         emit AutoNukeLP();
1581         return true;
1582     }
1583 
1584     function manualBurnLiquidityPairTokens(uint256 percent)
1585         external
1586         onlyOwner
1587         returns (bool)
1588     {
1589         require(
1590             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1591             "Must wait for cooldown to finish"
1592         );
1593         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1594         lastManualLpBurnTime = block.timestamp;
1595 
1596         // get balance of liquidity pair
1597         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1598 
1599         // calculate amount to burn
1600         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1601 
1602         // pull tokens from Pair liquidity and move to dead address permanently
1603         if (amountToBurn > 0) {
1604             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1605         }
1606 
1607         //sync price since this is not in a swap transaction!
1608         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1609         pair.sync();
1610         emit ManualNukeLP();
1611         return true;
1612     }
1613 
1614     function withdraw() external onlyOwner {
1615         uint256 balance = IERC20(address(this)).balanceOf(address(this));
1616         IERC20(address(this)).transfer(msg.sender, balance);
1617         payable(msg.sender).transfer(address(this).balance);
1618     }
1619 
1620     function withdrawToken(address _token, address _to) external onlyOwner {
1621         require(_token != address(0), "_token address cannot be 0");
1622         require(_token != address(this), "Can't withdraw native tokens");
1623         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1624         IERC20(_token).transfer(_to, _contractBalance);
1625     }
1626 
1627     function blacklist(address _black) public onlyOwner {
1628         blacklisted[_black] = true;
1629     }
1630 
1631     function unblacklist(address _black) public onlyOwner {
1632         blacklisted[_black] = false;
1633     }
1634 }