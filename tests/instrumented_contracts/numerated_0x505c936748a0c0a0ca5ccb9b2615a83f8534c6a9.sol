1 /**
2  *
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
7 pragma experimental ABIEncoderV2;
8 
9 
10 
11 
12 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
13 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
14 
15 /* pragma solidity ^0.8.0; */
16 
17 /**
18  * @dev Provides information about the current execution context, including the
19  * sender of the transaction and its data. While these are generally available
20  * via msg.sender and msg.data, they should not be accessed in such a direct
21  * manner, since when dealing with meta-transactions the account sending and
22  * paying for execution may not be the actual sender (as far as an application
23  * is concerned).
24  *
25  * This contract is only required for intermediate, library-like contracts.
26  */
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal view virtual returns (bytes calldata) {
33         return msg.data;
34     }
35 }
36 
37 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
38 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
39 
40 /* pragma solidity ^0.8.0; */
41 
42 /* import "../utils/Context.sol"; */
43 
44 /**
45  * @dev Contract module which provides a basic access control mechanism, where
46  * there is an account (an owner) that can be granted exclusive access to
47  * specific functions.
48  *
49  * By default, the owner account will be the one that deploys the contract. This
50  * can later be changed with {transferOwnership}.
51  *
52  * This module is used through inheritance. It will make available the modifier
53  * `onlyOwner`, which can be applied to your functions to restrict their use to
54  * the owner.
55  */
56 abstract contract Ownable is Context {
57     address private _owner;
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     /**
62      * @dev Initializes the contract setting the deployer as the initial owner.
63      */
64     constructor() {
65         _transferOwnership(_msgSender());
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if called by any account other than the owner.
77      */
78     modifier onlyOwner() {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80         _;
81     }
82 
83     /**
84      * @dev Leaves the contract without owner. It will not be possible to call
85      * `onlyOwner` functions anymore. Can only be called by the current owner.
86      *
87      * NOTE: Renouncing ownership will leave the contract without an owner,
88      * thereby removing any functionality that is only available to the owner.
89      */
90     function renounceOwnership() public virtual onlyOwner {
91         _transferOwnership(address(0));
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Can only be called by the current owner.
97      */
98     function transferOwnership(address newOwner) public virtual onlyOwner {
99         require(newOwner != address(0), "Ownable: new owner is the zero address");
100         _transferOwnership(newOwner);
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Internal function without access restriction.
106      */
107     function _transferOwnership(address newOwner) internal virtual {
108         address oldOwner = _owner;
109         _owner = newOwner;
110         emit OwnershipTransferred(oldOwner, newOwner);
111     }
112 }
113 
114 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
115 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
116 
117 /* pragma solidity ^0.8.0; */
118 
119 /**
120  * @dev Interface of the ERC20 standard as defined in the EIP.
121  */
122 interface IERC20 {
123     /**
124      * @dev Returns the amount of tokens in existence.
125      */
126     function totalSupply() external view returns (uint256);
127 
128     /**
129      * @dev Returns the amount of tokens owned by `account`.
130      */
131     function balanceOf(address account) external view returns (uint256);
132 
133     /**
134      * @dev Moves `amount` tokens from the caller's account to `recipient`.
135      *
136      * Returns a boolean value indicating whether the operation succeeded.
137      *
138      * Emits a {Transfer} event.
139      */
140     function transfer(address recipient, uint256 amount) external returns (bool);
141 
142     /**
143      * @dev Returns the remaining number of tokens that `spender` will be
144      * allowed to spend on behalf of `owner` through {transferFrom}. This is
145      * zero by default.
146      *
147      * This value changes when {approve} or {transferFrom} are called.
148      */
149     function allowance(address owner, address spender) external view returns (uint256);
150 
151     /**
152      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * IMPORTANT: Beware that changing an allowance with this method brings the risk
157      * that someone may use both the old and the new allowance by unfortunate
158      * transaction ordering. One possible solution to mitigate this race
159      * condition is to first reduce the spender's allowance to 0 and set the
160      * desired value afterwards:
161      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162      *
163      * Emits an {Approval} event.
164      */
165     function approve(address spender, uint256 amount) external returns (bool);
166 
167     /**
168      * @dev Moves `amount` tokens from `sender` to `recipient` using the
169      * allowance mechanism. `amount` is then deducted from the caller's
170      * allowance.
171      *
172      * Returns a boolean value indicating whether the operation succeeded.
173      *
174      * Emits a {Transfer} event.
175      */
176     function transferFrom(
177         address sender,
178         address recipient,
179         uint256 amount
180     ) external returns (bool);
181 
182     /**
183      * @dev Emitted when `value` tokens are moved from one account (`from`) to
184      * another (`to`).
185      *
186      * Note that `value` may be zero.
187      */
188     event Transfer(address indexed from, address indexed to, uint256 value);
189 
190     /**
191      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
192      * a call to {approve}. `value` is the new allowance.
193      */
194     event Approval(address indexed owner, address indexed spender, uint256 value);
195 }
196 
197 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
198 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
199 
200 /* pragma solidity ^0.8.0; */
201 
202 /* import "../IERC20.sol"; */
203 
204 /**
205  * @dev Interface for the optional metadata functions from the ERC20 standard.
206  *
207  * _Available since v4.1._
208  */
209 interface IERC20Metadata is IERC20 {
210     /**
211      * @dev Returns the name of the token.
212      */
213     function name() external view returns (string memory);
214 
215     /**
216      * @dev Returns the symbol of the token.
217      */
218     function symbol() external view returns (string memory);
219 
220     /**
221      * @dev Returns the decimals places of the token.
222      */
223     function decimals() external view returns (uint8);
224 }
225 
226 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
227 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
228 
229 /* pragma solidity ^0.8.0; */
230 
231 /* import "./IERC20.sol"; */
232 /* import "./extensions/IERC20Metadata.sol"; */
233 /* import "../../utils/Context.sol"; */
234 
235 /**
236  * @dev Implementation of the {IERC20} interface.
237  *
238  * This implementation is agnostic to the way tokens are created. This means
239  * that a supply mechanism has to be added in a derived contract using {_mint}.
240  * For a generic mechanism see {ERC20PresetMinterPauser}.
241  *
242  * TIP: For a detailed writeup see our guide
243  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
244  * to implement supply mechanisms].
245  *
246  * We have followed general OpenZeppelin Contracts guidelines: functions revert
247  * instead returning `false` on failure. This behavior is nonetheless
248  * conventional and does not conflict with the expectations of ERC20
249  * applications.
250  *
251  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
252  * This allows applications to reconstruct the allowance for all accounts just
253  * by listening to said events. Other implementations of the EIP may not emit
254  * these events, as it isn't required by the specification.
255  *
256  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
257  * functions have been added to mitigate the well-known issues around setting
258  * allowances. See {IERC20-approve}.
259  */
260 contract ERC20 is Context, IERC20, IERC20Metadata {
261     mapping(address => uint256) private _balances;
262 
263     mapping(address => mapping(address => uint256)) private _allowances;
264 
265     uint256 private _totalSupply;
266 
267     string private _name;
268     string private _symbol;
269 
270     /**
271      * @dev Sets the values for {name} and {symbol}.
272      *
273      * The default value of {decimals} is 18. To select a different value for
274      * {decimals} you should overload it.
275      *
276      * All two of these values are immutable: they can only be set once during
277      * construction.
278      */
279     constructor(string memory name_, string memory symbol_) {
280         _name = name_;
281         _symbol = symbol_;
282     }
283 
284     /**
285      * @dev Returns the name of the token.
286      */
287     function name() public view virtual override returns (string memory) {
288         return _name;
289     }
290 
291     /**
292      * @dev Returns the symbol of the token, usually a shorter version of the
293      * name.
294      */
295     function symbol() public view virtual override returns (string memory) {
296         return _symbol;
297     }
298 
299     /**
300      * @dev Returns the number of decimals used to get its user representation.
301      * For example, if `decimals` equals `2`, a balance of `505` tokens should
302      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
303      *
304      * Tokens usually opt for a value of 18, imitating the relationship between
305      * Ether and Wei. This is the value {ERC20} uses, unless this function is
306      * overridden;
307      *
308      * NOTE: This information is only used for _display_ purposes: it in
309      * no way affects any of the arithmetic of the contract, including
310      * {IERC20-balanceOf} and {IERC20-transfer}.
311      */
312     function decimals() public view virtual override returns (uint8) {
313         return 18;
314     }
315 
316     /**
317      * @dev See {IERC20-totalSupply}.
318      */
319     function totalSupply() public view virtual override returns (uint256) {
320         return _totalSupply;
321     }
322 
323     /**
324      * @dev See {IERC20-balanceOf}.
325      */
326     function balanceOf(address account) public view virtual override returns (uint256) {
327         return _balances[account];
328     }
329 
330     /**
331      * @dev See {IERC20-transfer}.
332      *
333      * Requirements:
334      *
335      * - `recipient` cannot be the zero address.
336      * - the caller must have a balance of at least `amount`.
337      */
338     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
339         _transfer(_msgSender(), recipient, amount);
340         return true;
341     }
342 
343     /**
344      * @dev See {IERC20-allowance}.
345      */
346     function allowance(address owner, address spender) public view virtual override returns (uint256) {
347         return _allowances[owner][spender];
348     }
349 
350     /**
351      * @dev See {IERC20-approve}.
352      *
353      * Requirements:
354      *
355      * - `spender` cannot be the zero address.
356      */
357     function approve(address spender, uint256 amount) public virtual override returns (bool) {
358         _approve(_msgSender(), spender, amount);
359         return true;
360     }
361 
362     /**
363      * @dev See {IERC20-transferFrom}.
364      *
365      * Emits an {Approval} event indicating the updated allowance. This is not
366      * required by the EIP. See the note at the beginning of {ERC20}.
367      *
368      * Requirements:
369      *
370      * - `sender` and `recipient` cannot be the zero address.
371      * - `sender` must have a balance of at least `amount`.
372      * - the caller must have allowance for ``sender``'s tokens of at least
373      * `amount`.
374      */
375     function transferFrom(
376         address sender,
377         address recipient,
378         uint256 amount
379     ) public virtual override returns (bool) {
380         _transfer(sender, recipient, amount);
381 
382         uint256 currentAllowance = _allowances[sender][_msgSender()];
383         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
384         unchecked {
385             _approve(sender, _msgSender(), currentAllowance - amount);
386         }
387 
388         return true;
389     }
390 
391     /**
392      * @dev Atomically increases the allowance granted to `spender` by the caller.
393      *
394      * This is an alternative to {approve} that can be used as a mitigation for
395      * problems described in {IERC20-approve}.
396      *
397      * Emits an {Approval} event indicating the updated allowance.
398      *
399      * Requirements:
400      *
401      * - `spender` cannot be the zero address.
402      */
403     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
404         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
405         return true;
406     }
407 
408     /**
409      * @dev Atomically decreases the allowance granted to `spender` by the caller.
410      *
411      * This is an alternative to {approve} that can be used as a mitigation for
412      * problems described in {IERC20-approve}.
413      *
414      * Emits an {Approval} event indicating the updated allowance.
415      *
416      * Requirements:
417      *
418      * - `spender` cannot be the zero address.
419      * - `spender` must have allowance for the caller of at least
420      * `subtractedValue`.
421      */
422     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
423         uint256 currentAllowance = _allowances[_msgSender()][spender];
424         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
425         unchecked {
426             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
427         }
428 
429         return true;
430     }
431 
432     /**
433      * @dev Moves `amount` of tokens from `sender` to `recipient`.
434      *
435      * This internal function is equivalent to {transfer}, and can be used to
436      * e.g. implement automatic token fees, slashing mechanisms, etc.
437      *
438      * Emits a {Transfer} event.
439      *
440      * Requirements:
441      *
442      * - `sender` cannot be the zero address.
443      * - `recipient` cannot be the zero address.
444      * - `sender` must have a balance of at least `amount`.
445      */
446     function _transfer(
447         address sender,
448         address recipient,
449         uint256 amount
450     ) internal virtual {
451         require(sender != address(0), "ERC20: transfer from the zero address");
452         require(recipient != address(0), "ERC20: transfer to the zero address");
453 
454         _beforeTokenTransfer(sender, recipient, amount);
455 
456         uint256 senderBalance = _balances[sender];
457         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
458         unchecked {
459             _balances[sender] = senderBalance - amount;
460         }
461         _balances[recipient] += amount;
462 
463         emit Transfer(sender, recipient, amount);
464 
465         _afterTokenTransfer(sender, recipient, amount);
466     }
467 
468     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
469      * the total supply.
470      *
471      * Emits a {Transfer} event with `from` set to the zero address.
472      *
473      * Requirements:
474      *
475      * - `account` cannot be the zero address.
476      */
477     function _mint(address account, uint256 amount) internal virtual {
478         require(account != address(0), "ERC20: mint to the zero address");
479 
480         _beforeTokenTransfer(address(0), account, amount);
481 
482         _totalSupply += amount;
483         _balances[account] += amount;
484         emit Transfer(address(0), account, amount);
485 
486         _afterTokenTransfer(address(0), account, amount);
487     }
488 
489     /**
490      * @dev Destroys `amount` tokens from `account`, reducing the
491      * total supply.
492      *
493      * Emits a {Transfer} event with `to` set to the zero address.
494      *
495      * Requirements:
496      *
497      * - `account` cannot be the zero address.
498      * - `account` must have at least `amount` tokens.
499      */
500     function _burn(address account, uint256 amount) internal virtual {
501         require(account != address(0), "ERC20: burn from the zero address");
502 
503         _beforeTokenTransfer(account, address(0), amount);
504 
505         uint256 accountBalance = _balances[account];
506         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
507         unchecked {
508             _balances[account] = accountBalance - amount;
509         }
510         _totalSupply -= amount;
511 
512         emit Transfer(account, address(0), amount);
513 
514         _afterTokenTransfer(account, address(0), amount);
515     }
516 
517     /**
518      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
519      *
520      * This internal function is equivalent to `approve`, and can be used to
521      * e.g. set automatic allowances for certain subsystems, etc.
522      *
523      * Emits an {Approval} event.
524      *
525      * Requirements:
526      *
527      * - `owner` cannot be the zero address.
528      * - `spender` cannot be the zero address.
529      */
530     function _approve(
531         address owner,
532         address spender,
533         uint256 amount
534     ) internal virtual {
535         require(owner != address(0), "ERC20: approve from the zero address");
536         require(spender != address(0), "ERC20: approve to the zero address");
537 
538         _allowances[owner][spender] = amount;
539         emit Approval(owner, spender, amount);
540     }
541 
542     /**
543      * @dev Hook that is called before any transfer of tokens. This includes
544      * minting and burning.
545      *
546      * Calling conditions:
547      *
548      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
549      * will be transferred to `to`.
550      * - when `from` is zero, `amount` tokens will be minted for `to`.
551      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
552      * - `from` and `to` are never both zero.
553      *
554      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
555      */
556     function _beforeTokenTransfer(
557         address from,
558         address to,
559         uint256 amount
560     ) internal virtual {}
561 
562     /**
563      * @dev Hook that is called after any transfer of tokens. This includes
564      * minting and burning.
565      *
566      * Calling conditions:
567      *
568      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
569      * has been transferred to `to`.
570      * - when `from` is zero, `amount` tokens have been minted for `to`.
571      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
572      * - `from` and `to` are never both zero.
573      *
574      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
575      */
576     function _afterTokenTransfer(
577         address from,
578         address to,
579         uint256 amount
580     ) internal virtual {}
581 }
582 
583 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
584 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
585 
586 /* pragma solidity ^0.8.0; */
587 
588 // CAUTION
589 // This version of SafeMath should only be used with Solidity 0.8 or later,
590 // because it relies on the compiler's built in overflow checks.
591 
592 /**
593  * @dev Wrappers over Solidity's arithmetic operations.
594  *
595  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
596  * now has built in overflow checking.
597  */
598 library SafeMath {
599     /**
600      * @dev Returns the addition of two unsigned integers, with an overflow flag.
601      *
602      * _Available since v3.4._
603      */
604     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
605         unchecked {
606             uint256 c = a + b;
607             if (c < a) return (false, 0);
608             return (true, c);
609         }
610     }
611 
612     /**
613      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
614      *
615      * _Available since v3.4._
616      */
617     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
618         unchecked {
619             if (b > a) return (false, 0);
620             return (true, a - b);
621         }
622     }
623 
624     /**
625      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
626      *
627      * _Available since v3.4._
628      */
629     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
630         unchecked {
631             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
632             // benefit is lost if 'b' is also tested.
633             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
634             if (a == 0) return (true, 0);
635             uint256 c = a * b;
636             if (c / a != b) return (false, 0);
637             return (true, c);
638         }
639     }
640 
641     /**
642      * @dev Returns the division of two unsigned integers, with a division by zero flag.
643      *
644      * _Available since v3.4._
645      */
646     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
647         unchecked {
648             if (b == 0) return (false, 0);
649             return (true, a / b);
650         }
651     }
652 
653     /**
654      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
655      *
656      * _Available since v3.4._
657      */
658     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
659         unchecked {
660             if (b == 0) return (false, 0);
661             return (true, a % b);
662         }
663     }
664 
665     /**
666      * @dev Returns the addition of two unsigned integers, reverting on
667      * overflow.
668      *
669      * Counterpart to Solidity's `+` operator.
670      *
671      * Requirements:
672      *
673      * - Addition cannot overflow.
674      */
675     function add(uint256 a, uint256 b) internal pure returns (uint256) {
676         return a + b;
677     }
678 
679     /**
680      * @dev Returns the subtraction of two unsigned integers, reverting on
681      * overflow (when the result is negative).
682      *
683      * Counterpart to Solidity's `-` operator.
684      *
685      * Requirements:
686      *
687      * - Subtraction cannot overflow.
688      */
689     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
690         return a - b;
691     }
692 
693     /**
694      * @dev Returns the multiplication of two unsigned integers, reverting on
695      * overflow.
696      *
697      * Counterpart to Solidity's `*` operator.
698      *
699      * Requirements:
700      *
701      * - Multiplication cannot overflow.
702      */
703     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
704         return a * b;
705     }
706 
707     /**
708      * @dev Returns the integer division of two unsigned integers, reverting on
709      * division by zero. The result is rounded towards zero.
710      *
711      * Counterpart to Solidity's `/` operator.
712      *
713      * Requirements:
714      *
715      * - The divisor cannot be zero.
716      */
717     function div(uint256 a, uint256 b) internal pure returns (uint256) {
718         return a / b;
719     }
720 
721     /**
722      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
723      * reverting when dividing by zero.
724      *
725      * Counterpart to Solidity's `%` operator. This function uses a `revert`
726      * opcode (which leaves remaining gas untouched) while Solidity uses an
727      * invalid opcode to revert (consuming all remaining gas).
728      *
729      * Requirements:
730      *
731      * - The divisor cannot be zero.
732      */
733     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
734         return a % b;
735     }
736 
737     /**
738      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
739      * overflow (when the result is negative).
740      *
741      * CAUTION: This function is deprecated because it requires allocating memory for the error
742      * message unnecessarily. For custom revert reasons use {trySub}.
743      *
744      * Counterpart to Solidity's `-` operator.
745      *
746      * Requirements:
747      *
748      * - Subtraction cannot overflow.
749      */
750     function sub(
751         uint256 a,
752         uint256 b,
753         string memory errorMessage
754     ) internal pure returns (uint256) {
755         unchecked {
756             require(b <= a, errorMessage);
757             return a - b;
758         }
759     }
760 
761     /**
762      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
763      * division by zero. The result is rounded towards zero.
764      *
765      * Counterpart to Solidity's `/` operator. Note: this function uses a
766      * `revert` opcode (which leaves remaining gas untouched) while Solidity
767      * uses an invalid opcode to revert (consuming all remaining gas).
768      *
769      * Requirements:
770      *
771      * - The divisor cannot be zero.
772      */
773     function div(
774         uint256 a,
775         uint256 b,
776         string memory errorMessage
777     ) internal pure returns (uint256) {
778         unchecked {
779             require(b > 0, errorMessage);
780             return a / b;
781         }
782     }
783 
784     /**
785      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
786      * reverting with custom message when dividing by zero.
787      *
788      * CAUTION: This function is deprecated because it requires allocating memory for the error
789      * message unnecessarily. For custom revert reasons use {tryMod}.
790      *
791      * Counterpart to Solidity's `%` operator. This function uses a `revert`
792      * opcode (which leaves remaining gas untouched) while Solidity uses an
793      * invalid opcode to revert (consuming all remaining gas).
794      *
795      * Requirements:
796      *
797      * - The divisor cannot be zero.
798      */
799     function mod(
800         uint256 a,
801         uint256 b,
802         string memory errorMessage
803     ) internal pure returns (uint256) {
804         unchecked {
805             require(b > 0, errorMessage);
806             return a % b;
807         }
808     }
809 }
810 
811 /* pragma solidity 0.8.10; */
812 /* pragma experimental ABIEncoderV2; */
813 
814 interface IUniswapV2Factory {
815     event PairCreated(
816         address indexed token0,
817         address indexed token1,
818         address pair,
819         uint256
820     );
821 
822     function feeTo() external view returns (address);
823 
824     function feeToSetter() external view returns (address);
825 
826     function getPair(address tokenA, address tokenB)
827         external
828         view
829         returns (address pair);
830 
831     function allPairs(uint256) external view returns (address pair);
832 
833     function allPairsLength() external view returns (uint256);
834 
835     function createPair(address tokenA, address tokenB)
836         external
837         returns (address pair);
838 
839     function setFeeTo(address) external;
840 
841     function setFeeToSetter(address) external;
842 }
843 
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
956 /* pragma solidity 0.8.10; */
957 /* pragma experimental ABIEncoderV2; */
958 
959 interface IUniswapV2Router02 {
960     function factory() external pure returns (address);
961 
962     function WETH() external pure returns (address);
963 
964     function addLiquidity(
965         address tokenA,
966         address tokenB,
967         uint256 amountADesired,
968         uint256 amountBDesired,
969         uint256 amountAMin,
970         uint256 amountBMin,
971         address to,
972         uint256 deadline
973     )
974         external
975         returns (
976             uint256 amountA,
977             uint256 amountB,
978             uint256 liquidity
979         );
980 
981     function addLiquidityETH(
982         address token,
983         uint256 amountTokenDesired,
984         uint256 amountTokenMin,
985         uint256 amountETHMin,
986         address to,
987         uint256 deadline
988     )
989         external
990         payable
991         returns (
992             uint256 amountToken,
993             uint256 amountETH,
994             uint256 liquidity
995         );
996 
997     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
998         uint256 amountIn,
999         uint256 amountOutMin,
1000         address[] calldata path,
1001         address to,
1002         uint256 deadline
1003     ) external;
1004 
1005     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1006         uint256 amountOutMin,
1007         address[] calldata path,
1008         address to,
1009         uint256 deadline
1010     ) external payable;
1011 
1012     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1013         uint256 amountIn,
1014         uint256 amountOutMin,
1015         address[] calldata path,
1016         address to,
1017         uint256 deadline
1018     ) external;
1019 }
1020 
1021 /* pragma solidity >=0.8.10; */
1022 
1023 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1024 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1025 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1026 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1027 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1028 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1029 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1030 
1031 contract ShibaCoin is ERC20, Ownable {
1032     using SafeMath for uint256;
1033 
1034     IUniswapV2Router02 public immutable uniswapV2Router;
1035     address public immutable uniswapV2Pair;
1036     address public constant deadAddress = address(0xdead);
1037 
1038     bool private swapping;
1039 
1040 	address public ShibaWallet;
1041     address public marketingWallet;
1042     address public devWallet;
1043 
1044     uint256 public maxTransactionAmount;
1045     uint256 public swapTokensAtAmount;
1046     uint256 public maxWallet;
1047 
1048     bool public limitsInEffect = true;
1049     bool public tradingActive = false;
1050     bool public swapEnabled = true;
1051 
1052     // Anti-bot and anti-whale mappings and variables
1053     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1054     bool public transferDelayEnabled = true;
1055 
1056     uint256 private buyTotalFees;
1057 	uint256 private buyShibaFee;
1058     uint256 private buyMarketingFee;
1059     uint256 private buyLiquidityFee;
1060     uint256 private buyDevFee;
1061 
1062     uint256 private sellTotalFees;
1063 	uint256 private sellShibaFee;
1064     uint256 private sellMarketingFee;
1065     uint256 private sellLiquidityFee;
1066     uint256 private sellDevFee;
1067 
1068 	uint256 public tokensForShiba;
1069     uint256 public tokensForMarketing;
1070     uint256 public tokensForLiquidity;
1071     uint256 public tokensForDev;
1072 
1073     /******************/
1074 
1075     // exlcude from fees and max transaction amount
1076     mapping(address => bool) private _isExcludedFromFees;
1077     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1078 
1079     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1080     // could be subject to a maximum transfer amount
1081     mapping(address => bool) public automatedMarketMakerPairs;
1082 
1083     event UpdateUniswapV2Router(
1084         address indexed newAddress,
1085         address indexed oldAddress
1086     );
1087 
1088     event ExcludeFromFees(address indexed account, bool isExcluded);
1089 
1090     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1091 
1092     event SwapAndLiquify(
1093         uint256 tokensSwapped,
1094         uint256 ethReceived,
1095         uint256 tokensIntoLiquidity
1096     );
1097 
1098     constructor() ERC20("ShibaCoin", "SC") {
1099         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1100             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1101         );
1102 
1103         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1104         uniswapV2Router = _uniswapV2Router;
1105 
1106         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1107             .createPair(address(this), _uniswapV2Router.WETH());
1108         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1109         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1110 
1111 		uint256 _buyShibaFee = 10;
1112         uint256 _buyMarketingFee = 0;
1113         uint256 _buyLiquidityFee = 1;
1114         uint256 _buyDevFee = 4;
1115 
1116 		uint256 _sellShibaFee = 10;
1117         uint256 _sellMarketingFee = 0;
1118         uint256 _sellLiquidityFee = 1;
1119         uint256 _sellDevFee = 4;
1120 
1121         uint256 totalSupply = 1000000000 * 1e18;
1122 
1123         maxTransactionAmount = 10000000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1124         maxWallet = 10000000 * 1e18; // 2% from total supply maxWallet
1125         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1126 
1127 		buyShibaFee = _buyShibaFee;
1128         buyMarketingFee = _buyMarketingFee;
1129         buyLiquidityFee = _buyLiquidityFee;
1130         buyDevFee = _buyDevFee;
1131         buyTotalFees = buyShibaFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1132 
1133 		sellShibaFee = _sellShibaFee;
1134         sellMarketingFee = _sellMarketingFee;
1135         sellLiquidityFee = _sellLiquidityFee;
1136         sellDevFee = _sellDevFee;
1137         sellTotalFees = sellShibaFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1138 
1139 		ShibaWallet = address(0xCf0db0083E05E4559076Eb779F8d3a2a97aA1285); // set as Shiba wallet
1140         marketingWallet = address(0x4Ba57F6B7cCd3D062081236Ef9974a5C80546B37); // set as marketing wallet
1141         devWallet = address(0x4Ba57F6B7cCd3D062081236Ef9974a5C80546B37); // set as dev wallet
1142 
1143         // exclude from paying fees or having max transaction amount
1144         excludeFromFees(owner(), true);
1145         excludeFromFees(address(this), true);
1146         excludeFromFees(address(0xdead), true);
1147 
1148         excludeFromMaxTransaction(owner(), true);
1149         excludeFromMaxTransaction(address(this), true);
1150         excludeFromMaxTransaction(address(0xdead), true);
1151 
1152         /*
1153             _mint is an internal function in ERC20.sol that is only called here,
1154             and CANNOT be called ever again
1155         */
1156         _mint(msg.sender, totalSupply);
1157     }
1158 
1159     receive() external payable {}
1160 
1161     // once enabled, can never be turned off
1162     function enableTrading() external onlyOwner {
1163         tradingActive = true;
1164         swapEnabled = true;
1165     }
1166 
1167     // remove limits after token is stable
1168     function removeLimits() external onlyOwner returns (bool) {
1169         limitsInEffect = false;
1170         return true;
1171     }
1172 
1173     // disable Transfer delay - cannot be reenabled
1174     function disableTransferDelay() external onlyOwner returns (bool) {
1175         transferDelayEnabled = false;
1176         return true;
1177     }
1178 
1179     // change the minimum amount of tokens to sell from fees
1180     function updateSwapTokensAtAmount(uint256 newAmount)
1181         external
1182         onlyOwner
1183         returns (bool)
1184     {
1185         require(
1186             newAmount >= (totalSupply() * 1) / 100000,
1187             "Swap amount cannot be lower than 0.001% total supply."
1188         );
1189         require(
1190             newAmount <= (totalSupply() * 5) / 1000,
1191             "Swap amount cannot be higher than 0.5% total supply."
1192         );
1193         swapTokensAtAmount = newAmount;
1194         return true;
1195     }
1196 
1197     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1198         require(
1199             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1200             "Cannot set maxTransactionAmount lower than 0.5%"
1201         );
1202         maxTransactionAmount = newNum * (10**18);
1203     }
1204 
1205     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1206         require(
1207             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1208             "Cannot set maxWallet lower than 0.5%"
1209         );
1210         maxWallet = newNum * (10**18);
1211     }
1212 	
1213     function excludeFromMaxTransaction(address updAds, bool isEx)
1214         public
1215         onlyOwner
1216     {
1217         _isExcludedMaxTransactionAmount[updAds] = isEx;
1218     }
1219 
1220     // only use to disable contract sales if absolutely necessary (emergency use only)
1221     function updateSwapEnabled(bool enabled) external onlyOwner {
1222         swapEnabled = enabled;
1223     }
1224 
1225     function updateBuyFees(
1226 		uint256 _ShibaFee,
1227         uint256 _marketingFee,
1228         uint256 _liquidityFee,
1229         uint256 _devFee
1230     ) external onlyOwner {
1231 		require((_ShibaFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max BuyFee 10%");
1232 		buyShibaFee = _ShibaFee;
1233         buyMarketingFee = _marketingFee;
1234         buyLiquidityFee = _liquidityFee;
1235         buyDevFee = _devFee;
1236         buyTotalFees = buyShibaFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1237      }
1238 
1239     function updateSellFees(
1240 		uint256 _ShibaFee,
1241         uint256 _marketingFee,
1242         uint256 _liquidityFee,
1243         uint256 _devFee
1244     ) external onlyOwner {
1245 		require((_ShibaFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max SellFee 10%");
1246 		sellShibaFee = _ShibaFee;
1247         sellMarketingFee = _marketingFee;
1248         sellLiquidityFee = _liquidityFee;
1249         sellDevFee = _devFee;
1250         sellTotalFees = sellShibaFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1251     }
1252 
1253     function excludeFromFees(address account, bool excluded) public onlyOwner {
1254         _isExcludedFromFees[account] = excluded;
1255         emit ExcludeFromFees(account, excluded);
1256     }
1257 
1258     function setAutomatedMarketMakerPair(address pair, bool value)
1259         public
1260         onlyOwner
1261     {
1262         require(
1263             pair != uniswapV2Pair,
1264             "The pair cannot be removed from automatedMarketMakerPairs"
1265         );
1266 
1267         _setAutomatedMarketMakerPair(pair, value);
1268     }
1269 
1270     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1271         automatedMarketMakerPairs[pair] = value;
1272 
1273         emit SetAutomatedMarketMakerPair(pair, value);
1274     }
1275 
1276     function isExcludedFromFees(address account) public view returns (bool) {
1277         return _isExcludedFromFees[account];
1278     }
1279 
1280     function _transfer(
1281         address from,
1282         address to,
1283         uint256 amount
1284     ) internal override {
1285         require(from != address(0), "ERC20: transfer from the zero address");
1286         require(to != address(0), "ERC20: transfer to the zero address");
1287 
1288         if (amount == 0) {
1289             super._transfer(from, to, 0);
1290             return;
1291         }
1292 
1293         if (limitsInEffect) {
1294             if (
1295                 from != owner() &&
1296                 to != owner() &&
1297                 to != address(0) &&
1298                 to != address(0xdead) &&
1299                 !swapping
1300             ) {
1301                 if (!tradingActive) {
1302                     require(
1303                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1304                         "Trading is not active."
1305                     );
1306                 }
1307 
1308                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1309                 if (transferDelayEnabled) {
1310                     if (
1311                         to != owner() &&
1312                         to != address(uniswapV2Router) &&
1313                         to != address(uniswapV2Pair)
1314                     ) {
1315                         require(
1316                             _holderLastTransferTimestamp[tx.origin] <
1317                                 block.number,
1318                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1319                         );
1320                         _holderLastTransferTimestamp[tx.origin] = block.number;
1321                     }
1322                 }
1323 
1324                 //when buy
1325                 if (
1326                     automatedMarketMakerPairs[from] &&
1327                     !_isExcludedMaxTransactionAmount[to]
1328                 ) {
1329                     require(
1330                         amount <= maxTransactionAmount,
1331                         "Buy transfer amount exceeds the maxTransactionAmount."
1332                     );
1333                     require(
1334                         amount + balanceOf(to) <= maxWallet,
1335                         "Max wallet exceeded"
1336                     );
1337                 }
1338                 //when sell
1339                 else if (
1340                     automatedMarketMakerPairs[to] &&
1341                     !_isExcludedMaxTransactionAmount[from]
1342                 ) {
1343                     require(
1344                         amount <= maxTransactionAmount,
1345                         "Sell transfer amount exceeds the maxTransactionAmount."
1346                     );
1347                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1348                     require(
1349                         amount + balanceOf(to) <= maxWallet,
1350                         "Max wallet exceeded"
1351                     );
1352                 }
1353             }
1354         }
1355 
1356         uint256 contractTokenBalance = balanceOf(address(this));
1357 
1358         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1359 
1360         if (
1361             canSwap &&
1362             swapEnabled &&
1363             !swapping &&
1364             !automatedMarketMakerPairs[from] &&
1365             !_isExcludedFromFees[from] &&
1366             !_isExcludedFromFees[to]
1367         ) {
1368             swapping = true;
1369 
1370             swapBack();
1371 
1372             swapping = false;
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
1388 				tokensForShiba += (fees * sellShibaFee) / sellTotalFees;
1389                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1390                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1391                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1392             }
1393             // on buy
1394             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1395                 fees = amount.mul(buyTotalFees).div(100);
1396 				tokensForShiba += (fees * buyShibaFee) / buyTotalFees;
1397                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1398                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1399                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1400             }
1401 
1402             if (fees > 0) {
1403                 super._transfer(from, address(this), fees);
1404             }
1405 
1406             amount -= fees;
1407         }
1408 
1409         super._transfer(from, to, amount);
1410     }
1411 
1412     function swapTokensForEth(uint256 tokenAmount) private {
1413         // generate the uniswap pair path of token -> weth
1414         address[] memory path = new address[](2);
1415         path[0] = address(this);
1416         path[1] = uniswapV2Router.WETH();
1417 
1418         _approve(address(this), address(uniswapV2Router), tokenAmount);
1419 
1420         // make the swap
1421         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1422             tokenAmount,
1423             0, // accept any amount of ETH
1424             path,
1425             address(this),
1426             block.timestamp
1427         );
1428     }
1429 
1430     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1431         // approve token transfer to cover all possible scenarios
1432         _approve(address(this), address(uniswapV2Router), tokenAmount);
1433 
1434         // add the liquidity
1435         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1436             address(this),
1437             tokenAmount,
1438             0, // slippage is unavoidable
1439             0, // slippage is unavoidable
1440             devWallet,
1441             block.timestamp
1442         );
1443     }
1444 
1445     function swapBack() private {
1446         uint256 contractBalance = balanceOf(address(this));
1447         uint256 totalTokensToSwap = tokensForShiba + tokensForLiquidity + tokensForMarketing + tokensForDev;
1448         bool success;
1449 
1450         if (contractBalance == 0 || totalTokensToSwap == 0) {
1451             return;
1452         }
1453 
1454         if (contractBalance > swapTokensAtAmount * 20) {
1455             contractBalance = swapTokensAtAmount * 20;
1456         }
1457 
1458         // Halve the amount of liquidity tokens
1459         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1460         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1461 
1462         uint256 initialETHBalance = address(this).balance;
1463 
1464         swapTokensForEth(amountToSwapForETH);
1465 
1466         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1467 
1468 		uint256 ethForShiba = ethBalance.mul(tokensForShiba).div(totalTokensToSwap);
1469         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1470         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1471 
1472         uint256 ethForLiquidity = ethBalance - ethForShiba - ethForMarketing - ethForDev;
1473 
1474         tokensForLiquidity = 0;
1475 		tokensForShiba = 0;
1476         tokensForMarketing = 0;
1477         tokensForDev = 0;
1478 
1479         (success, ) = address(devWallet).call{value: ethForDev}("");
1480         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1481 
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
1492         (success, ) = address(ShibaWallet).call{value: address(this).balance}("");
1493     }
1494 
1495 }