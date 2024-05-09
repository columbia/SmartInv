1 /**
2 https://t.me/JakePaul_inu
3 */
4 // SPDX-License-Identifier: MIT
5 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
6 pragma experimental ABIEncoderV2;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes calldata) {
14         return msg.data;
15     }
16 }
17 
18 abstract contract Ownable is Context {
19     address private _owner;
20 
21     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23     /**
24      * @dev Initializes the contract setting the deployer as the initial owner.
25      */
26     constructor() {
27         _transferOwnership(_msgSender());
28     }
29 
30     /**
31      * @dev Returns the address of the current owner.
32      */
33     function owner() public view virtual returns (address) {
34         return _owner;
35     }
36 
37     /**
38      * @dev Throws if called by any account other than the owner.
39      */
40     modifier onlyOwner() {
41         require(owner() == _msgSender(), "Ownable: caller is not the owner");
42         _;
43     }
44 
45     /**
46      * @dev Leaves the contract without owner. It will not be possible to call
47      * `onlyOwner` functions anymore. Can only be called by the current owner.
48      *
49      * NOTE: Renouncing ownership will leave the contract without an owner,
50      * thereby removing any functionality that is only available to the owner.
51      */
52     function renounceOwnership() public virtual onlyOwner {
53         _transferOwnership(address(0));
54     }
55 
56     /**
57      * @dev Transfers ownership of the contract to a new account (`newOwner`).
58      * Can only be called by the current owner.
59      */
60     function transferOwnership(address newOwner) public virtual onlyOwner {
61         require(newOwner != address(0), "Ownable: new owner is the zero address");
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers ownership of the contract to a new account (`newOwner`).
67      * Internal function without access restriction.
68      */
69     function _transferOwnership(address newOwner) internal virtual {
70         address oldOwner = _owner;
71         _owner = newOwner;
72         emit OwnershipTransferred(oldOwner, newOwner);
73     }
74 }
75 
76 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
77 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
78 
79 /* pragma solidity ^0.8.0; */
80 
81 /**
82  * @dev Interface of the ERC20 standard as defined in the EIP.
83  */
84 interface IERC20 {
85     /**
86      * @dev Returns the amount of tokens in existence.
87      */
88     function totalSupply() external view returns (uint256);
89 
90     /**
91      * @dev Returns the amount of tokens owned by `account`.
92      */
93     function balanceOf(address account) external view returns (uint256);
94 
95     /**
96      * @dev Moves `amount` tokens from the caller's account to `recipient`.
97      *
98      * Returns a boolean value indicating whether the operation succeeded.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transfer(address recipient, uint256 amount) external returns (bool);
103 
104     /**
105      * @dev Returns the remaining number of tokens that `spender` will be
106      * allowed to spend on behalf of `owner` through {transferFrom}. This is
107      * zero by default.
108      *
109      * This value changes when {approve} or {transferFrom} are called.
110      */
111     function allowance(address owner, address spender) external view returns (uint256);
112 
113     /**
114      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
115      *
116      * Returns a boolean value indicating whether the operation succeeded.
117      *
118      * IMPORTANT: Beware that changing an allowance with this method brings the risk
119      * that someone may use both the old and the new allowance by unfortunate
120      * transaction ordering. One possible solution to mitigate this race
121      * condition is to first reduce the spender's allowance to 0 and set the
122      * desired value afterwards:
123      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
124      *
125      * Emits an {Approval} event.
126      */
127     function approve(address spender, uint256 amount) external returns (bool);
128 
129     /**
130      * @dev Moves `amount` tokens from `sender` to `recipient` using the
131      * allowance mechanism. `amount` is then deducted from the caller's
132      * allowance.
133      *
134      * Returns a boolean value indicating whether the operation succeeded.
135      *
136      * Emits a {Transfer} event.
137      */
138     function transferFrom(
139         address sender,
140         address recipient,
141         uint256 amount
142     ) external returns (bool);
143 
144     /**
145      * @dev Emitted when `value` tokens are moved from one account (`from`) to
146      * another (`to`).
147      *
148      * Note that `value` may be zero.
149      */
150     event Transfer(address indexed from, address indexed to, uint256 value);
151 
152     /**
153      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
154      * a call to {approve}. `value` is the new allowance.
155      */
156     event Approval(address indexed owner, address indexed spender, uint256 value);
157 }
158 
159 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
160 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
161 
162 /* pragma solidity ^0.8.0; */
163 
164 /* import "../IERC20.sol"; */
165 
166 /**
167  * @dev Interface for the optional metadata functions from the ERC20 standard.
168  *
169  * _Available since v4.1._
170  */
171 interface IERC20Metadata is IERC20 {
172     /**
173      * @dev Returns the name of the token.
174      */
175     function name() external view returns (string memory);
176 
177     /**
178      * @dev Returns the symbol of the token.
179      */
180     function symbol() external view returns (string memory);
181 
182     /**
183      * @dev Returns the decimals places of the token.
184      */
185     function decimals() external view returns (uint8);
186 }
187 
188 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
189 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
190 
191 /* pragma solidity ^0.8.0; */
192 
193 /* import "./IERC20.sol"; */
194 /* import "./extensions/IERC20Metadata.sol"; */
195 /* import "../../utils/Context.sol"; */
196 
197 /**
198  * @dev Implementation of the {IERC20} interface.
199  *
200  * This implementation is agnostic to the way tokens are created. This means
201  * that a supply mechanism has to be added in a derived contract using {_mint}.
202  * For a generic mechanism see {ERC20PresetMinterPauser}.
203  *
204  * TIP: For a detailed writeup see our guide
205  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
206  * to implement supply mechanisms].
207  *
208  * We have followed general OpenZeppelin Contracts guidelines: functions revert
209  * instead returning `false` on failure. This behavior is nonetheless
210  * conventional and does not conflict with the expectations of ERC20
211  * applications.
212  *
213  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
214  * This allows applications to reconstruct the allowance for all accounts just
215  * by listening to said events. Other implementations of the EIP may not emit
216  * these events, as it isn't required by the specification.
217  *
218  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
219  * functions have been added to mitigate the well-known issues around setting
220  * allowances. See {IERC20-approve}.
221  */
222 contract ERC20 is Context, IERC20, IERC20Metadata {
223     mapping(address => uint256) private _balances;
224 
225     mapping(address => mapping(address => uint256)) private _allowances;
226 
227     uint256 private _totalSupply;
228 
229     string private _name;
230     string private _symbol;
231 
232     /**
233      * @dev Sets the values for {name} and {symbol}.
234      *
235      * The default value of {decimals} is 18. To select a different value for
236      * {decimals} you should overload it.
237      *
238      * All two of these values are immutable: they can only be set once during
239      * construction.
240      */
241     constructor(string memory name_, string memory symbol_) {
242         _name = name_;
243         _symbol = symbol_;
244     }
245 
246     /**
247      * @dev Returns the name of the token.
248      */
249     function name() public view virtual override returns (string memory) {
250         return _name;
251     }
252 
253     /**
254      * @dev Returns the symbol of the token, usually a shorter version of the
255      * name.
256      */
257     function symbol() public view virtual override returns (string memory) {
258         return _symbol;
259     }
260 
261     /**
262      * @dev Returns the number of decimals used to get its user representation.
263      * For example, if `decimals` equals `2`, a balance of `505` tokens should
264      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
265      *
266      * Tokens usually opt for a value of 18, imitating the relationship between
267      * Ether and Wei. This is the value {ERC20} uses, unless this function is
268      * overridden;
269      *
270      * NOTE: This information is only used for _display_ purposes: it in
271      * no way affects any of the arithmetic of the contract, including
272      * {IERC20-balanceOf} and {IERC20-transfer}.
273      */
274     function decimals() public view virtual override returns (uint8) {
275         return 18;
276     }
277 
278     /**
279      * @dev See {IERC20-totalSupply}.
280      */
281     function totalSupply() public view virtual override returns (uint256) {
282         return _totalSupply;
283     }
284 
285     /**
286      * @dev See {IERC20-balanceOf}.
287      */
288     function balanceOf(address account) public view virtual override returns (uint256) {
289         return _balances[account];
290     }
291 
292     /**
293      * @dev See {IERC20-transfer}.
294      *
295      * Requirements:
296      *
297      * - `recipient` cannot be the zero address.
298      * - the caller must have a balance of at least `amount`.
299      */
300     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
301         _transfer(_msgSender(), recipient, amount);
302         return true;
303     }
304 
305     /**
306      * @dev See {IERC20-allowance}.
307      */
308     function allowance(address owner, address spender) public view virtual override returns (uint256) {
309         return _allowances[owner][spender];
310     }
311 
312     /**
313      * @dev See {IERC20-approve}.
314      *
315      * Requirements:
316      *
317      * - `spender` cannot be the zero address.
318      */
319     function approve(address spender, uint256 amount) public virtual override returns (bool) {
320         _approve(_msgSender(), spender, amount);
321         return true;
322     }
323 
324     /**
325      * @dev See {IERC20-transferFrom}.
326      *
327      * Emits an {Approval} event indicating the updated allowance. This is not
328      * required by the EIP. See the note at the beginning of {ERC20}.
329      *
330      * Requirements:
331      *
332      * - `sender` and `recipient` cannot be the zero address.
333      * - `sender` must have a balance of at least `amount`.
334      * - the caller must have allowance for ``sender``'s tokens of at least
335      * `amount`.
336      */
337     function transferFrom(
338         address sender,
339         address recipient,
340         uint256 amount
341     ) public virtual override returns (bool) {
342         _transfer(sender, recipient, amount);
343 
344         uint256 currentAllowance = _allowances[sender][_msgSender()];
345         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
346         unchecked {
347             _approve(sender, _msgSender(), currentAllowance - amount);
348         }
349 
350         return true;
351     }
352 
353     /**
354      * @dev Atomically increases the allowance granted to `spender` by the caller.
355      *
356      * This is an alternative to {approve} that can be used as a mitigation for
357      * problems described in {IERC20-approve}.
358      *
359      * Emits an {Approval} event indicating the updated allowance.
360      *
361      * Requirements:
362      *
363      * - `spender` cannot be the zero address.
364      */
365     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
366         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
367         return true;
368     }
369 
370     /**
371      * @dev Atomically decreases the allowance granted to `spender` by the caller.
372      *
373      * This is an alternative to {approve} that can be used as a mitigation for
374      * problems described in {IERC20-approve}.
375      *
376      * Emits an {Approval} event indicating the updated allowance.
377      *
378      * Requirements:
379      *
380      * - `spender` cannot be the zero address.
381      * - `spender` must have allowance for the caller of at least
382      * `subtractedValue`.
383      */
384     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
385         uint256 currentAllowance = _allowances[_msgSender()][spender];
386         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
387         unchecked {
388             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
389         }
390 
391         return true;
392     }
393 
394     /**
395      * @dev Moves `amount` of tokens from `sender` to `recipient`.
396      *
397      * This internal function is equivalent to {transfer}, and can be used to
398      * e.g. implement automatic token fees, slashing mechanisms, etc.
399      *
400      * Emits a {Transfer} event.
401      *
402      * Requirements:
403      *
404      * - `sender` cannot be the zero address.
405      * - `recipient` cannot be the zero address.
406      * - `sender` must have a balance of at least `amount`.
407      */
408     function _transfer(
409         address sender,
410         address recipient,
411         uint256 amount
412     ) internal virtual {
413         require(sender != address(0), "ERC20: transfer from the zero address");
414         require(recipient != address(0), "ERC20: transfer to the zero address");
415 
416         _beforeTokenTransfer(sender, recipient, amount);
417 
418         uint256 senderBalance = _balances[sender];
419         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
420         unchecked {
421             _balances[sender] = senderBalance - amount;
422         }
423         _balances[recipient] += amount;
424 
425         emit Transfer(sender, recipient, amount);
426 
427         _afterTokenTransfer(sender, recipient, amount);
428     }
429 
430     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
431      * the total supply.
432      *
433      * Emits a {Transfer} event with `from` set to the zero address.
434      *
435      * Requirements:
436      *
437      * - `account` cannot be the zero address.
438      */
439     function _mint(address account, uint256 amount) internal virtual {
440         require(account != address(0), "ERC20: mint to the zero address");
441 
442         _beforeTokenTransfer(address(0), account, amount);
443 
444         _totalSupply += amount;
445         _balances[account] += amount;
446         emit Transfer(address(0), account, amount);
447 
448         _afterTokenTransfer(address(0), account, amount);
449     }
450 
451     /**
452      * @dev Destroys `amount` tokens from `account`, reducing the
453      * total supply.
454      *
455      * Emits a {Transfer} event with `to` set to the zero address.
456      *
457      * Requirements:
458      *
459      * - `account` cannot be the zero address.
460      * - `account` must have at least `amount` tokens.
461      */
462     function _burn(address account, uint256 amount) internal virtual {
463         require(account != address(0), "ERC20: burn from the zero address");
464 
465         _beforeTokenTransfer(account, address(0), amount);
466 
467         uint256 accountBalance = _balances[account];
468         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
469         unchecked {
470             _balances[account] = accountBalance - amount;
471         }
472         _totalSupply -= amount;
473 
474         emit Transfer(account, address(0), amount);
475 
476         _afterTokenTransfer(account, address(0), amount);
477     }
478 
479     /**
480      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
481      *
482      * This internal function is equivalent to `approve`, and can be used to
483      * e.g. set automatic allowances for certain subsystems, etc.
484      *
485      * Emits an {Approval} event.
486      *
487      * Requirements:
488      *
489      * - `owner` cannot be the zero address.
490      * - `spender` cannot be the zero address.
491      */
492     function _approve(
493         address owner,
494         address spender,
495         uint256 amount
496     ) internal virtual {
497         require(owner != address(0), "ERC20: approve from the zero address");
498         require(spender != address(0), "ERC20: approve to the zero address");
499 
500         _allowances[owner][spender] = amount;
501         emit Approval(owner, spender, amount);
502     }
503 
504     /**
505      * @dev Hook that is called before any transfer of tokens. This includes
506      * minting and burning.
507      *
508      * Calling conditions:
509      *
510      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
511      * will be transferred to `to`.
512      * - when `from` is zero, `amount` tokens will be minted for `to`.
513      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
514      * - `from` and `to` are never both zero.
515      *
516      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
517      */
518     function _beforeTokenTransfer(
519         address from,
520         address to,
521         uint256 amount
522     ) internal virtual {}
523 
524     /**
525      * @dev Hook that is called after any transfer of tokens. This includes
526      * minting and burning.
527      *
528      * Calling conditions:
529      *
530      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
531      * has been transferred to `to`.
532      * - when `from` is zero, `amount` tokens have been minted for `to`.
533      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
534      * - `from` and `to` are never both zero.
535      *
536      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
537      */
538     function _afterTokenTransfer(
539         address from,
540         address to,
541         uint256 amount
542     ) internal virtual {}
543 }
544 
545 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
546 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
547 
548 /* pragma solidity ^0.8.0; */
549 
550 // CAUTION
551 // This version of SafeMath should only be used with Solidity 0.8 or later,
552 // because it relies on the compiler's built in overflow checks.
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
773 ////// src/IUniswapV2Factory.sol
774 /* pragma solidity 0.8.10; */
775 /* pragma experimental ABIEncoderV2; */
776 
777 interface IUniswapV2Factory {
778     event PairCreated(
779         address indexed token0,
780         address indexed token1,
781         address pair,
782         uint256
783     );
784 
785     function feeTo() external view returns (address);
786 
787     function feeToSetter() external view returns (address);
788 
789     function getPair(address tokenA, address tokenB)
790         external
791         view
792         returns (address pair);
793 
794     function allPairs(uint256) external view returns (address pair);
795 
796     function allPairsLength() external view returns (uint256);
797 
798     function createPair(address tokenA, address tokenB)
799         external
800         returns (address pair);
801 
802     function setFeeTo(address) external;
803 
804     function setFeeToSetter(address) external;
805 }
806 
807 ////// src/IUniswapV2Pair.sol
808 /* pragma solidity 0.8.10; */
809 /* pragma experimental ABIEncoderV2; */
810 
811 interface IUniswapV2Pair {
812     event Approval(
813         address indexed owner,
814         address indexed spender,
815         uint256 value
816     );
817     event Transfer(address indexed from, address indexed to, uint256 value);
818 
819     function name() external pure returns (string memory);
820 
821     function symbol() external pure returns (string memory);
822 
823     function decimals() external pure returns (uint8);
824 
825     function totalSupply() external view returns (uint256);
826 
827     function balanceOf(address owner) external view returns (uint256);
828 
829     function allowance(address owner, address spender)
830         external
831         view
832         returns (uint256);
833 
834     function approve(address spender, uint256 value) external returns (bool);
835 
836     function transfer(address to, uint256 value) external returns (bool);
837 
838     function transferFrom(
839         address from,
840         address to,
841         uint256 value
842     ) external returns (bool);
843 
844     function DOMAIN_SEPARATOR() external view returns (bytes32);
845 
846     function PERMIT_TYPEHASH() external pure returns (bytes32);
847 
848     function nonces(address owner) external view returns (uint256);
849 
850     function permit(
851         address owner,
852         address spender,
853         uint256 value,
854         uint256 deadline,
855         uint8 v,
856         bytes32 r,
857         bytes32 s
858     ) external;
859 
860     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
861     event Burn(
862         address indexed sender,
863         uint256 amount0,
864         uint256 amount1,
865         address indexed to
866     );
867     event Swap(
868         address indexed sender,
869         uint256 amount0In,
870         uint256 amount1In,
871         uint256 amount0Out,
872         uint256 amount1Out,
873         address indexed to
874     );
875     event Sync(uint112 reserve0, uint112 reserve1);
876 
877     function MINIMUM_LIQUIDITY() external pure returns (uint256);
878 
879     function factory() external view returns (address);
880 
881     function token0() external view returns (address);
882 
883     function token1() external view returns (address);
884 
885     function getReserves()
886         external
887         view
888         returns (
889             uint112 reserve0,
890             uint112 reserve1,
891             uint32 blockTimestampLast
892         );
893 
894     function price0CumulativeLast() external view returns (uint256);
895 
896     function price1CumulativeLast() external view returns (uint256);
897 
898     function kLast() external view returns (uint256);
899 
900     function mint(address to) external returns (uint256 liquidity);
901 
902     function burn(address to)
903         external
904         returns (uint256 amount0, uint256 amount1);
905 
906     function swap(
907         uint256 amount0Out,
908         uint256 amount1Out,
909         address to,
910         bytes calldata data
911     ) external;
912 
913     function skim(address to) external;
914 
915     function sync() external;
916 
917     function initialize(address, address) external;
918 }
919 
920 ////// src/IUniswapV2Router02.sol
921 /* pragma solidity 0.8.10; */
922 /* pragma experimental ABIEncoderV2; */
923 
924 interface IUniswapV2Router02 {
925     function factory() external pure returns (address);
926 
927     function WETH() external pure returns (address);
928 
929     function addLiquidity(
930         address tokenA,
931         address tokenB,
932         uint256 amountADesired,
933         uint256 amountBDesired,
934         uint256 amountAMin,
935         uint256 amountBMin,
936         address to,
937         uint256 deadline
938     )
939         external
940         returns (
941             uint256 amountA,
942             uint256 amountB,
943             uint256 liquidity
944         );
945 
946     function addLiquidityETH(
947         address token,
948         uint256 amountTokenDesired,
949         uint256 amountTokenMin,
950         uint256 amountETHMin,
951         address to,
952         uint256 deadline
953     )
954         external
955         payable
956         returns (
957             uint256 amountToken,
958             uint256 amountETH,
959             uint256 liquidity
960         );
961 
962     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
963         uint256 amountIn,
964         uint256 amountOutMin,
965         address[] calldata path,
966         address to,
967         uint256 deadline
968     ) external;
969 
970     function swapExactETHForTokensSupportingFeeOnTransferTokens(
971         uint256 amountOutMin,
972         address[] calldata path,
973         address to,
974         uint256 deadline
975     ) external payable;
976 
977     function swapExactTokensForETHSupportingFeeOnTransferTokens(
978         uint256 amountIn,
979         uint256 amountOutMin,
980         address[] calldata path,
981         address to,
982         uint256 deadline
983     ) external;
984 }
985 
986 /* pragma solidity >=0.8.10; */
987 
988 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
989 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
990 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
991 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
992 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
993 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
994 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
995 
996 contract PAUL is ERC20, Ownable {
997     using SafeMath for uint256;
998 
999     IUniswapV2Router02 public immutable uniswapV2Router;
1000     address public immutable uniswapV2Pair;
1001     address public constant deadAddress = address(0xdead);
1002 
1003     bool private swapping;
1004 
1005     address public marketingWallet;
1006     address public devWallet;
1007 
1008     uint256 public maxTransactionAmount;
1009     uint256 public swapTokensAtAmount;
1010     uint256 public maxWallet;
1011 
1012     uint256 public percentForLPBurn = 25; // 25 = .25%
1013     bool public lpBurnEnabled = false;
1014     uint256 public lpBurnFrequency = 3600 seconds;
1015     uint256 public lastLpBurnTime;
1016 
1017     uint256 public manualBurnFrequency = 30 minutes;
1018     uint256 public lastManualLpBurnTime;
1019 
1020     bool public limitsInEffect = true;
1021     bool public tradingActive = false;
1022     bool public swapEnabled = false;
1023 
1024     // Anti-bot and anti-whale mappings and variables
1025     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1026     bool public transferDelayEnabled = true;
1027 
1028     uint256 public buyTotalFees;
1029     uint256 public buyMarketingFee;
1030     uint256 public buyLiquidityFee;
1031     uint256 public buyDevFee;
1032 
1033     uint256 public sellTotalFees;
1034     uint256 public sellMarketingFee;
1035     uint256 public sellLiquidityFee;
1036     uint256 public sellDevFee;
1037 
1038     uint256 public tokensForMarketing;
1039     uint256 public tokensForLiquidity;
1040     uint256 public tokensForDev;
1041 
1042     /******************/
1043 
1044     // exlcude from fees and max transaction amount
1045     mapping(address => bool) private _isExcludedFromFees;
1046     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1047 
1048     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1049     // could be subject to a maximum transfer amount
1050     mapping(address => bool) public automatedMarketMakerPairs;
1051 
1052     event UpdateUniswapV2Router(
1053         address indexed newAddress,
1054         address indexed oldAddress
1055     );
1056 
1057     event ExcludeFromFees(address indexed account, bool isExcluded);
1058 
1059     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1060 
1061     event marketingWalletUpdated(
1062         address indexed newWallet,
1063         address indexed oldWallet
1064     );
1065 
1066     event devWalletUpdated(
1067         address indexed newWallet,
1068         address indexed oldWallet
1069     );
1070 
1071     event SwapAndLiquify(
1072         uint256 tokensSwapped,
1073         uint256 ethReceived,
1074         uint256 tokensIntoLiquidity
1075     );
1076 
1077     event AutoNukeLP();
1078 
1079     event ManualNukeLP();
1080 
1081     constructor() ERC20("Jake Paul Inu", "PAUL") {
1082         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1083             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1084         );
1085 
1086         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1087         uniswapV2Router = _uniswapV2Router;
1088 
1089         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1090             .createPair(address(this), _uniswapV2Router.WETH());
1091         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1092         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1093 
1094         uint256 _buyMarketingFee = 5;
1095         uint256 _buyLiquidityFee = 0;
1096         uint256 _buyDevFee = 0;
1097 
1098         uint256 _sellMarketingFee = 5;
1099         uint256 _sellLiquidityFee = 0;
1100         uint256 _sellDevFee = 0;
1101 
1102         uint256 totalSupply = 1_000_000_000 * 1e18;
1103 
1104         maxTransactionAmount = 5_000_000 * 1e18;
1105         maxWallet = 20_000_000 * 1e18;
1106         swapTokensAtAmount = (totalSupply) / 1000; // 
1107 
1108         buyMarketingFee = _buyMarketingFee;
1109         buyLiquidityFee = _buyLiquidityFee;
1110         buyDevFee = _buyDevFee;
1111         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1112 
1113         sellMarketingFee = _sellMarketingFee;
1114         sellLiquidityFee = _sellLiquidityFee;
1115         sellDevFee = _sellDevFee;
1116         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1117 
1118         marketingWallet = address(0xB0a85794d534Aa4F1a3679319Ab5b4C990b7cb43); // set as marketing wallet
1119         devWallet = address(0x28F3Eae44c78e0bAEBd2c56Ba1204AeDA10f0730); // set as dev wallet
1120 
1121         // exclude from paying fees or having max transaction amount
1122         excludeFromFees(owner(), true);
1123         excludeFromFees(address(this), true);
1124         excludeFromFees(address(0xdead), true);
1125 
1126         excludeFromMaxTransaction(owner(), true);
1127         excludeFromMaxTransaction(address(this), true);
1128         excludeFromMaxTransaction(address(0xdead), true);
1129 
1130         /*
1131             _mint is an internal function in ERC20.sol that is only called here,
1132             and CANNOT be called ever again
1133         */
1134         _mint(msg.sender, totalSupply);
1135     }
1136 
1137     receive() external payable {}
1138 
1139     // once enabled, can never be turned off
1140     function enableTrading() external onlyOwner {
1141         tradingActive = true;
1142         swapEnabled = true;
1143         lastLpBurnTime = block.timestamp;
1144     }
1145 
1146     // remove limits after token is stable
1147     function removeLimits() external onlyOwner returns (bool) {
1148         limitsInEffect = false;
1149         return true;
1150     }
1151 
1152     // disable Transfer delay - cannot be reenabled
1153     function disableTransferDelay() external onlyOwner returns (bool) {
1154         transferDelayEnabled = false;
1155         return true;
1156     }
1157 
1158     // change the minimum amount of tokens to sell from fees
1159     function updateSwapTokensAtAmount(uint256 newAmount)
1160         external
1161         onlyOwner
1162         returns (bool)
1163     {
1164         require(
1165             newAmount >= (totalSupply() * 1) / 100000,
1166             "Swap amount cannot be lower than 0.001% total supply."
1167         );
1168         require(
1169             newAmount <= (totalSupply() * 5) / 1000,
1170             "Swap amount cannot be higher than 0.5% total supply."
1171         );
1172         swapTokensAtAmount = newAmount;
1173         return true;
1174     }
1175 
1176     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1177         require(
1178             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1179             "Cannot set maxTransactionAmount lower than 0.1%"
1180         );
1181         maxTransactionAmount = newNum * (10**18);
1182     }
1183 
1184     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1185         require(
1186             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1187             "Cannot set maxWallet lower than 0.5%"
1188         );
1189         maxWallet = newNum * (10**18);
1190     }
1191 
1192     function excludeFromMaxTransaction(address updAds, bool isEx)
1193         public
1194         onlyOwner
1195     {
1196         _isExcludedMaxTransactionAmount[updAds] = isEx;
1197     }
1198 
1199     // only use to disable contract sales if absolutely necessary (emergency use only)
1200     function updateSwapEnabled(bool enabled) external onlyOwner {
1201         swapEnabled = enabled;
1202     }
1203 
1204     function updateBuyFees(
1205         uint256 _marketingFee,
1206         uint256 _liquidityFee,
1207         uint256 _devFee
1208     ) external onlyOwner {
1209         buyMarketingFee = _marketingFee;
1210         buyLiquidityFee = _liquidityFee;
1211         buyDevFee = _devFee;
1212         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1213         require(buyTotalFees <= 9, "Must keep fees at 9% or less");
1214     }
1215 
1216     function updateSellFees(
1217         uint256 _marketingFee,
1218         uint256 _liquidityFee,
1219         uint256 _devFee
1220     ) external onlyOwner {
1221         sellMarketingFee = _marketingFee;
1222         sellLiquidityFee = _liquidityFee;
1223         sellDevFee = _devFee;
1224         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1225         require(sellTotalFees <= 9, "Must keep fees at 9% or less");
1226     }
1227 
1228     function excludeFromFees(address account, bool excluded) public onlyOwner {
1229         _isExcludedFromFees[account] = excluded;
1230         emit ExcludeFromFees(account, excluded);
1231     }
1232 
1233     function setAutomatedMarketMakerPair(address pair, bool value)
1234         public
1235         onlyOwner
1236     {
1237         require(
1238             pair != uniswapV2Pair,
1239             "The pair cannot be removed from automatedMarketMakerPairs"
1240         );
1241 
1242         _setAutomatedMarketMakerPair(pair, value);
1243     }
1244 
1245     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1246         automatedMarketMakerPairs[pair] = value;
1247 
1248         emit SetAutomatedMarketMakerPair(pair, value);
1249     }
1250 
1251     function updateMarketingWallet(address newMarketingWallet)
1252         external
1253         onlyOwner
1254     {
1255         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1256         marketingWallet = newMarketingWallet;
1257     }
1258 
1259     function updateDevWallet(address newWallet) external onlyOwner {
1260         emit devWalletUpdated(newWallet, devWallet);
1261         devWallet = newWallet;
1262     }
1263 
1264     function isExcludedFromFees(address account) public view returns (bool) {
1265         return _isExcludedFromFees[account];
1266     }
1267 
1268     event BoughtEarly(address indexed sniper);
1269 
1270     function _transfer(
1271         address from,
1272         address to,
1273         uint256 amount
1274     ) internal override {
1275         require(from != address(0), "ERC20: transfer from the zero address");
1276         require(to != address(0), "ERC20: transfer to the zero address");
1277 
1278         if (amount == 0) {
1279             super._transfer(from, to, 0);
1280             return;
1281         }
1282 
1283         if (limitsInEffect) {
1284             if (
1285                 from != owner() &&
1286                 to != owner() &&
1287                 to != address(0) &&
1288                 to != address(0xdead) &&
1289                 !swapping
1290             ) {
1291                 if (!tradingActive) {
1292                     require(
1293                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1294                         "Trading is not active."
1295                     );
1296                 }
1297 
1298                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1299                 if (transferDelayEnabled) {
1300                     if (
1301                         to != owner() &&
1302                         to != address(uniswapV2Router) &&
1303                         to != address(uniswapV2Pair)
1304                     ) {
1305                         require(
1306                             _holderLastTransferTimestamp[tx.origin] <
1307                                 block.number,
1308                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1309                         );
1310                         _holderLastTransferTimestamp[tx.origin] = block.number;
1311                     }
1312                 }
1313 
1314                 //when buy
1315                 if (
1316                     automatedMarketMakerPairs[from] &&
1317                     !_isExcludedMaxTransactionAmount[to]
1318                 ) {
1319                     require(
1320                         amount <= maxTransactionAmount,
1321                         "Buy transfer amount exceeds the maxTransactionAmount."
1322                     );
1323                     require(
1324                         amount + balanceOf(to) <= maxWallet,
1325                         "Max wallet exceeded"
1326                     );
1327                 }
1328                 //when sell
1329                 else if (
1330                     automatedMarketMakerPairs[to] &&
1331                     !_isExcludedMaxTransactionAmount[from]
1332                 ) {
1333                     require(
1334                         amount <= maxTransactionAmount,
1335                         "Sell transfer amount exceeds the maxTransactionAmount."
1336                     );
1337                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1338                     require(
1339                         amount + balanceOf(to) <= maxWallet,
1340                         "Max wallet exceeded"
1341                     );
1342                 }
1343             }
1344         }
1345 
1346         uint256 contractTokenBalance = balanceOf(address(this));
1347 
1348         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1349 
1350         if (
1351             canSwap &&
1352             swapEnabled &&
1353             !swapping &&
1354             !automatedMarketMakerPairs[from] &&
1355             !_isExcludedFromFees[from] &&
1356             !_isExcludedFromFees[to]
1357         ) {
1358             swapping = true;
1359 
1360             swapBack();
1361 
1362             swapping = false;
1363         }
1364 
1365         if (
1366             !swapping &&
1367             automatedMarketMakerPairs[to] &&
1368             lpBurnEnabled &&
1369             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1370             !_isExcludedFromFees[from]
1371         ) {
1372             autoBurnLiquidityPairTokens();
1373         }
1374 
1375         bool takeFee = !swapping;
1376 
1377         // if any account belongs to _isExcludedFromFee account then remove the fee
1378         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1379             takeFee = false;
1380         }
1381 
1382         uint256 fees = 0;
1383         // only take fees on buys/sells, do not take on wallet transfers
1384         if (takeFee) {
1385             // on sell
1386             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1387                 fees = amount.mul(sellTotalFees).div(100);
1388                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1389                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1390                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1391             }
1392             // on buy
1393             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1394                 fees = amount.mul(buyTotalFees).div(100);
1395                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1396                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1397                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1398             }
1399 
1400             if (fees > 0) {
1401                 super._transfer(from, address(this), fees);
1402             }
1403 
1404             amount -= fees;
1405         }
1406 
1407         super._transfer(from, to, amount);
1408     }
1409 
1410     function swapTokensForEth(uint256 tokenAmount) private {
1411         // generate the uniswap pair path of token -> weth
1412         address[] memory path = new address[](2);
1413         path[0] = address(this);
1414         path[1] = uniswapV2Router.WETH();
1415 
1416         _approve(address(this), address(uniswapV2Router), tokenAmount);
1417 
1418         // make the swap
1419         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1420             tokenAmount,
1421             0, // accept any amount of ETH
1422             path,
1423             address(this),
1424             block.timestamp
1425         );
1426     }
1427 
1428     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1429         // approve token transfer to cover all possible scenarios
1430         _approve(address(this), address(uniswapV2Router), tokenAmount);
1431 
1432         // add the liquidity
1433         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1434             address(this),
1435             tokenAmount,
1436             0, // slippage is unavoidable
1437             0, // slippage is unavoidable
1438             deadAddress,
1439             block.timestamp
1440         );
1441     }
1442 
1443     function swapBack() private {
1444         uint256 contractBalance = balanceOf(address(this));
1445         uint256 totalTokensToSwap = tokensForLiquidity +
1446             tokensForMarketing +
1447             tokensForDev;
1448         bool success;
1449 
1450         if (contractBalance == 0 || totalTokensToSwap == 0) {
1451             return;
1452         }
1453 
1454         if (contractBalance > swapTokensAtAmount * 5) {
1455             contractBalance = swapTokensAtAmount * 5;
1456         }
1457 
1458         // Halve the amount of liquidity tokens
1459         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1460             totalTokensToSwap /
1461             2;
1462         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1463 
1464         uint256 initialETHBalance = address(this).balance;
1465 
1466         swapTokensForEth(amountToSwapForETH);
1467 
1468         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1469 
1470         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1471             totalTokensToSwap
1472         );
1473         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1474 
1475         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1476 
1477         tokensForLiquidity = 0;
1478         tokensForMarketing = 0;
1479         tokensForDev = 0;
1480 
1481         (success, ) = address(devWallet).call{value: ethForDev}("");
1482 
1483         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1484             addLiquidity(liquidityTokens, ethForLiquidity);
1485             emit SwapAndLiquify(
1486                 amountToSwapForETH,
1487                 ethForLiquidity,
1488                 tokensForLiquidity
1489             );
1490         }
1491 
1492         (success, ) = address(marketingWallet).call{
1493             value: address(this).balance
1494         }("");
1495     }
1496 
1497     function autoBurnLiquidityPairTokens() internal returns (bool) {
1498         lastLpBurnTime = block.timestamp;
1499 
1500         // get balance of liquidity pair
1501         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1502 
1503         // calculate amount to burn
1504         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1505             10000
1506         );
1507 
1508         // pull tokens from pancakePair liquidity and move to dead address permanently
1509         if (amountToBurn > 0) {
1510             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1511         }
1512 
1513         //sync price since this is not in a swap transaction!
1514         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1515         pair.sync();
1516         emit AutoNukeLP();
1517         return true;
1518     }
1519 
1520 }