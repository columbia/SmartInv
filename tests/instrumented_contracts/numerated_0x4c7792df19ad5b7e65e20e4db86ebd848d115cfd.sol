1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-08
3 */
4 
5 // Verified using https://dapp.tools
6 
7 // hevm: flattened sources of src/FUCKTHESEC.sol
8 // SPDX-License-Identifier: MIT
9 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
10 pragma experimental ABIEncoderV2;
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
811 ////// src/IUniswapV2Factory.sol
812 /* pragma solidity 0.8.10; */
813 /* pragma experimental ABIEncoderV2; */
814 
815 interface IUniswapV2Factory {
816     event PairCreated(
817         address indexed token0,
818         address indexed token1,
819         address pair,
820         uint256
821     );
822 
823     function feeTo() external view returns (address);
824 
825     function feeToSetter() external view returns (address);
826 
827     function getPair(address tokenA, address tokenB)
828         external
829         view
830         returns (address pair);
831 
832     function allPairs(uint256) external view returns (address pair);
833 
834     function allPairsLength() external view returns (uint256);
835 
836     function createPair(address tokenA, address tokenB)
837         external
838         returns (address pair);
839 
840     function setFeeTo(address) external;
841 
842     function setFeeToSetter(address) external;
843 }
844 
845 ////// src/IUniswapV2Pair.sol
846 /* pragma solidity 0.8.10; */
847 /* pragma experimental ABIEncoderV2; */
848 
849 interface IUniswapV2Pair {
850     event Approval(
851         address indexed owner,
852         address indexed spender,
853         uint256 value
854     );
855     event Transfer(address indexed from, address indexed to, uint256 value);
856 
857     function name() external pure returns (string memory);
858 
859     function symbol() external pure returns (string memory);
860 
861     function decimals() external pure returns (uint8);
862 
863     function totalSupply() external view returns (uint256);
864 
865     function balanceOf(address owner) external view returns (uint256);
866 
867     function allowance(address owner, address spender)
868         external
869         view
870         returns (uint256);
871 
872     function approve(address spender, uint256 value) external returns (bool);
873 
874     function transfer(address to, uint256 value) external returns (bool);
875 
876     function transferFrom(
877         address from,
878         address to,
879         uint256 value
880     ) external returns (bool);
881 
882     function DOMAIN_SEPARATOR() external view returns (bytes32);
883 
884     function PERMIT_TYPEHASH() external pure returns (bytes32);
885 
886     function nonces(address owner) external view returns (uint256);
887 
888     function permit(
889         address owner,
890         address spender,
891         uint256 value,
892         uint256 deadline,
893         uint8 v,
894         bytes32 r,
895         bytes32 s
896     ) external;
897 
898     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
899     event Burn(
900         address indexed sender,
901         uint256 amount0,
902         uint256 amount1,
903         address indexed to
904     );
905     event Swap(
906         address indexed sender,
907         uint256 amount0In,
908         uint256 amount1In,
909         uint256 amount0Out,
910         uint256 amount1Out,
911         address indexed to
912     );
913     event Sync(uint112 reserve0, uint112 reserve1);
914 
915     function MINIMUM_LIQUIDITY() external pure returns (uint256);
916 
917     function factory() external view returns (address);
918 
919     function token0() external view returns (address);
920 
921     function token1() external view returns (address);
922 
923     function getReserves()
924         external
925         view
926         returns (
927             uint112 reserve0,
928             uint112 reserve1,
929             uint32 blockTimestampLast
930         );
931 
932     function price0CumulativeLast() external view returns (uint256);
933 
934     function price1CumulativeLast() external view returns (uint256);
935 
936     function kLast() external view returns (uint256);
937 
938     function mint(address to) external returns (uint256 liquidity);
939 
940     function burn(address to)
941         external
942         returns (uint256 amount0, uint256 amount1);
943 
944     function swap(
945         uint256 amount0Out,
946         uint256 amount1Out,
947         address to,
948         bytes calldata data
949     ) external;
950 
951     function skim(address to) external;
952 
953     function sync() external;
954 
955     function initialize(address, address) external;
956 }
957 
958 ////// src/IUniswapV2Router02.sol
959 /* pragma solidity 0.8.10; */
960 /* pragma experimental ABIEncoderV2; */
961 
962 interface IUniswapV2Router02 {
963     function factory() external pure returns (address);
964 
965     function WETH() external pure returns (address);
966 
967     function addLiquidity(
968         address tokenA,
969         address tokenB,
970         uint256 amountADesired,
971         uint256 amountBDesired,
972         uint256 amountAMin,
973         uint256 amountBMin,
974         address to,
975         uint256 deadline
976     )
977         external
978         returns (
979             uint256 amountA,
980             uint256 amountB,
981             uint256 liquidity
982         );
983 
984     function addLiquidityETH(
985         address token,
986         uint256 amountTokenDesired,
987         uint256 amountTokenMin,
988         uint256 amountETHMin,
989         address to,
990         uint256 deadline
991     )
992         external
993         payable
994         returns (
995             uint256 amountToken,
996             uint256 amountETH,
997             uint256 liquidity
998         );
999 
1000     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1001         uint256 amountIn,
1002         uint256 amountOutMin,
1003         address[] calldata path,
1004         address to,
1005         uint256 deadline
1006     ) external;
1007 
1008     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1009         uint256 amountOutMin,
1010         address[] calldata path,
1011         address to,
1012         uint256 deadline
1013     ) external payable;
1014 
1015     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1016         uint256 amountIn,
1017         uint256 amountOutMin,
1018         address[] calldata path,
1019         address to,
1020         uint256 deadline
1021     ) external;
1022 }
1023 
1024 ////// src/MarshallRoganInu.sol
1025 /* pragma solidity >=0.8.10; */
1026 
1027 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1028 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1029 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1030 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1031 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1032 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1033 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1034 
1035 contract FUCKTHESEC is ERC20, Ownable {
1036     using SafeMath for uint256;
1037 
1038     IUniswapV2Router02 public immutable uniswapV2Router;
1039     address public immutable uniswapV2Pair;
1040     address public constant deadAddress = address(0xdead);
1041 
1042     bool private swapping;
1043 
1044     address public marketingWallet;
1045     address public devWallet;
1046 
1047     uint256 public maxTransactionAmount;
1048     uint256 public swapTokensAtAmount;
1049     uint256 public maxWallet;
1050 
1051     uint256 public percentForLPBurn = 25; // 25 = .25%
1052     bool public lpBurnEnabled = true;
1053     uint256 public lpBurnFrequency = 3600 seconds;
1054     uint256 public lastLpBurnTime;
1055 
1056     uint256 public manualBurnFrequency = 30 minutes;
1057     uint256 public lastManualLpBurnTime;
1058 
1059     bool public limitsInEffect = true;
1060     bool public tradingActive = false;
1061     bool public swapEnabled = false;
1062 
1063     // Anti-bot and anti-whale mappings and variables
1064     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1065     bool public transferDelayEnabled = true;
1066 
1067     uint256 public buyTotalFees;
1068     uint256 public buyMarketingFee;
1069     uint256 public buyLiquidityFee;
1070     uint256 public buyDevFee;
1071 
1072     uint256 public sellTotalFees;
1073     uint256 public sellMarketingFee;
1074     uint256 public sellLiquidityFee;
1075     uint256 public sellDevFee;
1076 
1077     uint256 public tokensForMarketing;
1078     uint256 public tokensForLiquidity;
1079     uint256 public tokensForDev;
1080 
1081     /******************/
1082 
1083     // exlcude from fees and max transaction amount
1084     mapping(address => bool) private _isExcludedFromFees;
1085     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1086 
1087     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1088     // could be subject to a maximum transfer amount
1089     mapping(address => bool) public automatedMarketMakerPairs;
1090 
1091     event UpdateUniswapV2Router(
1092         address indexed newAddress,
1093         address indexed oldAddress
1094     );
1095 
1096     event ExcludeFromFees(address indexed account, bool isExcluded);
1097 
1098     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1099 
1100     event marketingWalletUpdated(
1101         address indexed newWallet,
1102         address indexed oldWallet
1103     );
1104 
1105     event devWalletUpdated(
1106         address indexed newWallet,
1107         address indexed oldWallet
1108     );
1109 
1110     event SwapAndLiquify(
1111         uint256 tokensSwapped,
1112         uint256 ethReceived,
1113         uint256 tokensIntoLiquidity
1114     );
1115 
1116     event AutoNukeLP();
1117 
1118     event ManualNukeLP();
1119 
1120     constructor() ERC20("FUCKTHESEC", "SEC Inu") {
1121         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1122             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1123         );
1124 
1125         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1126         uniswapV2Router = _uniswapV2Router;
1127 
1128         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1129             .createPair(address(this), _uniswapV2Router.WETH());
1130         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1131         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1132 
1133         uint256 _buyMarketingFee = 2;
1134         uint256 _buyLiquidityFee = 1;
1135         uint256 _buyDevFee = 2;
1136 
1137         uint256 _sellMarketingFee = 3;
1138         uint256 _sellLiquidityFee = 1;
1139         uint256 _sellDevFee = 3;
1140 
1141         uint256 totalSupply = 1_000_000_000 * 1e18;
1142 
1143         maxTransactionAmount = 10_000_000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1144         maxWallet = 20_000_000 * 1e18; // 2% from total supply maxWallet
1145         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1146 
1147         buyMarketingFee = _buyMarketingFee;
1148         buyLiquidityFee = _buyLiquidityFee;
1149         buyDevFee = _buyDevFee;
1150         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1151 
1152         sellMarketingFee = _sellMarketingFee;
1153         sellLiquidityFee = _sellLiquidityFee;
1154         sellDevFee = _sellDevFee;
1155         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1156 
1157         marketingWallet = address(0x75f00DeB9A771bDb62B1469FC7a065e345Fb99A2); // set as marketing wallet
1158         devWallet = address(0x75f00DeB9A771bDb62B1469FC7a065e345Fb99A2); // set as dev wallet
1159 
1160         // exclude from paying fees or having max transaction amount
1161         excludeFromFees(owner(), true);
1162         excludeFromFees(address(this), true);
1163         excludeFromFees(address(0xdead), true);
1164 
1165         excludeFromMaxTransaction(owner(), true);
1166         excludeFromMaxTransaction(address(this), true);
1167         excludeFromMaxTransaction(address(0xdead), true);
1168 
1169         /*
1170             _mint is an internal function in ERC20.sol that is only called here,
1171             and CANNOT be called ever again
1172         */
1173         _mint(msg.sender, totalSupply);
1174     }
1175 
1176     receive() external payable {}
1177 
1178     // once enabled, can never be turned off
1179     function enableTrading() external onlyOwner {
1180         tradingActive = true;
1181         swapEnabled = true;
1182         lastLpBurnTime = block.timestamp;
1183     }
1184 
1185     // remove limits after token is stable
1186     function removeLimits() external onlyOwner returns (bool) {
1187         limitsInEffect = false;
1188         return true;
1189     }
1190 
1191     // disable Transfer delay - cannot be reenabled
1192     function disableTransferDelay() external onlyOwner returns (bool) {
1193         transferDelayEnabled = false;
1194         return true;
1195     }
1196 
1197     // change the minimum amount of tokens to sell from fees
1198     function updateSwapTokensAtAmount(uint256 newAmount)
1199         external
1200         onlyOwner
1201         returns (bool)
1202     {
1203         require(
1204             newAmount >= (totalSupply() * 1) / 100000,
1205             "Swap amount cannot be lower than 0.001% total supply."
1206         );
1207         require(
1208             newAmount <= (totalSupply() * 5) / 1000,
1209             "Swap amount cannot be higher than 0.5% total supply."
1210         );
1211         swapTokensAtAmount = newAmount;
1212         return true;
1213     }
1214 
1215     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1216         require(
1217             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1218             "Cannot set maxTransactionAmount lower than 0.1%"
1219         );
1220         maxTransactionAmount = newNum * (10**18);
1221     }
1222 
1223     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1224         require(
1225             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1226             "Cannot set maxWallet lower than 0.5%"
1227         );
1228         maxWallet = newNum * (10**18);
1229     }
1230 
1231     function excludeFromMaxTransaction(address updAds, bool isEx)
1232         public
1233         onlyOwner
1234     {
1235         _isExcludedMaxTransactionAmount[updAds] = isEx;
1236     }
1237 
1238     // only use to disable contract sales if absolutely necessary (emergency use only)
1239     function updateSwapEnabled(bool enabled) external onlyOwner {
1240         swapEnabled = enabled;
1241     }
1242 
1243     function updateBuyFees(
1244         uint256 _marketingFee,
1245         uint256 _liquidityFee,
1246         uint256 _devFee
1247     ) external onlyOwner {
1248         buyMarketingFee = _marketingFee;
1249         buyLiquidityFee = _liquidityFee;
1250         buyDevFee = _devFee;
1251         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1252         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1253     }
1254 
1255     function updateSellFees(
1256         uint256 _marketingFee,
1257         uint256 _liquidityFee,
1258         uint256 _devFee
1259     ) external onlyOwner {
1260         sellMarketingFee = _marketingFee;
1261         sellLiquidityFee = _liquidityFee;
1262         sellDevFee = _devFee;
1263         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1264         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1265     }
1266 
1267     function excludeFromFees(address account, bool excluded) public onlyOwner {
1268         _isExcludedFromFees[account] = excluded;
1269         emit ExcludeFromFees(account, excluded);
1270     }
1271 
1272     function setAutomatedMarketMakerPair(address pair, bool value)
1273         public
1274         onlyOwner
1275     {
1276         require(
1277             pair != uniswapV2Pair,
1278             "The pair cannot be removed from automatedMarketMakerPairs"
1279         );
1280 
1281         _setAutomatedMarketMakerPair(pair, value);
1282     }
1283 
1284     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1285         automatedMarketMakerPairs[pair] = value;
1286 
1287         emit SetAutomatedMarketMakerPair(pair, value);
1288     }
1289 
1290     function updateMarketingWallet(address newMarketingWallet)
1291         external
1292         onlyOwner
1293     {
1294         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1295         marketingWallet = newMarketingWallet;
1296     }
1297 
1298     function updateDevWallet(address newWallet) external onlyOwner {
1299         emit devWalletUpdated(newWallet, devWallet);
1300         devWallet = newWallet;
1301     }
1302 
1303     function isExcludedFromFees(address account) public view returns (bool) {
1304         return _isExcludedFromFees[account];
1305     }
1306 
1307     event BoughtEarly(address indexed sniper);
1308 
1309     function _transfer(
1310         address from,
1311         address to,
1312         uint256 amount
1313     ) internal override {
1314         require(from != address(0), "ERC20: transfer from the zero address");
1315         require(to != address(0), "ERC20: transfer to the zero address");
1316 
1317         if (amount == 0) {
1318             super._transfer(from, to, 0);
1319             return;
1320         }
1321 
1322         if (limitsInEffect) {
1323             if (
1324                 from != owner() &&
1325                 to != owner() &&
1326                 to != address(0) &&
1327                 to != address(0xdead) &&
1328                 !swapping
1329             ) {
1330                 if (!tradingActive) {
1331                     require(
1332                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1333                         "Trading is not active."
1334                     );
1335                 }
1336 
1337                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1338                 if (transferDelayEnabled) {
1339                     if (
1340                         to != owner() &&
1341                         to != address(uniswapV2Router) &&
1342                         to != address(uniswapV2Pair)
1343                     ) {
1344                         require(
1345                             _holderLastTransferTimestamp[tx.origin] <
1346                                 block.number,
1347                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1348                         );
1349                         _holderLastTransferTimestamp[tx.origin] = block.number;
1350                     }
1351                 }
1352 
1353                 //when buy
1354                 if (
1355                     automatedMarketMakerPairs[from] &&
1356                     !_isExcludedMaxTransactionAmount[to]
1357                 ) {
1358                     require(
1359                         amount <= maxTransactionAmount,
1360                         "Buy transfer amount exceeds the maxTransactionAmount."
1361                     );
1362                     require(
1363                         amount + balanceOf(to) <= maxWallet,
1364                         "Max wallet exceeded"
1365                     );
1366                 }
1367                 //when sell
1368                 else if (
1369                     automatedMarketMakerPairs[to] &&
1370                     !_isExcludedMaxTransactionAmount[from]
1371                 ) {
1372                     require(
1373                         amount <= maxTransactionAmount,
1374                         "Sell transfer amount exceeds the maxTransactionAmount."
1375                     );
1376                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1377                     require(
1378                         amount + balanceOf(to) <= maxWallet,
1379                         "Max wallet exceeded"
1380                     );
1381                 }
1382             }
1383         }
1384 
1385         uint256 contractTokenBalance = balanceOf(address(this));
1386 
1387         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1388 
1389         if (
1390             canSwap &&
1391             swapEnabled &&
1392             !swapping &&
1393             !automatedMarketMakerPairs[from] &&
1394             !_isExcludedFromFees[from] &&
1395             !_isExcludedFromFees[to]
1396         ) {
1397             swapping = true;
1398 
1399             swapBack();
1400 
1401             swapping = false;
1402         }
1403 
1404         if (
1405             !swapping &&
1406             automatedMarketMakerPairs[to] &&
1407             lpBurnEnabled &&
1408             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1409             !_isExcludedFromFees[from]
1410         ) {
1411             autoBurnLiquidityPairTokens();
1412         }
1413 
1414         bool takeFee = !swapping;
1415 
1416         // if any account belongs to _isExcludedFromFee account then remove the fee
1417         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1418             takeFee = false;
1419         }
1420 
1421         uint256 fees = 0;
1422         // only take fees on buys/sells, do not take on wallet transfers
1423         if (takeFee) {
1424             // on sell
1425             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1426                 fees = amount.mul(sellTotalFees).div(100);
1427                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1428                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1429                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1430             }
1431             // on buy
1432             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1433                 fees = amount.mul(buyTotalFees).div(100);
1434                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1435                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1436                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
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
1477             deadAddress,
1478             block.timestamp
1479         );
1480     }
1481 
1482     function swapBack() private {
1483         uint256 contractBalance = balanceOf(address(this));
1484         uint256 totalTokensToSwap = tokensForLiquidity +
1485             tokensForMarketing +
1486             tokensForDev;
1487         bool success;
1488 
1489         if (contractBalance == 0 || totalTokensToSwap == 0) {
1490             return;
1491         }
1492 
1493         if (contractBalance > swapTokensAtAmount * 20) {
1494             contractBalance = swapTokensAtAmount * 20;
1495         }
1496 
1497         // Halve the amount of liquidity tokens
1498         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1499             totalTokensToSwap /
1500             2;
1501         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1502 
1503         uint256 initialETHBalance = address(this).balance;
1504 
1505         swapTokensForEth(amountToSwapForETH);
1506 
1507         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1508 
1509         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1510             totalTokensToSwap
1511         );
1512         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1513 
1514         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1515 
1516         tokensForLiquidity = 0;
1517         tokensForMarketing = 0;
1518         tokensForDev = 0;
1519 
1520         (success, ) = address(devWallet).call{value: ethForDev}("");
1521 
1522         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1523             addLiquidity(liquidityTokens, ethForLiquidity);
1524             emit SwapAndLiquify(
1525                 amountToSwapForETH,
1526                 ethForLiquidity,
1527                 tokensForLiquidity
1528             );
1529         }
1530 
1531         (success, ) = address(marketingWallet).call{
1532             value: address(this).balance
1533         }("");
1534     }
1535 
1536     function setAutoLPBurnSettings(
1537         uint256 _frequencyInSeconds,
1538         uint256 _percent,
1539         bool _Enabled
1540     ) external onlyOwner {
1541         require(
1542             _frequencyInSeconds >= 600,
1543             "cannot set buyback more often than every 10 minutes"
1544         );
1545         require(
1546             _percent <= 1000 && _percent >= 0,
1547             "Must set auto LP burn percent between 0% and 10%"
1548         );
1549         lpBurnFrequency = _frequencyInSeconds;
1550         percentForLPBurn = _percent;
1551         lpBurnEnabled = _Enabled;
1552     }
1553 
1554     function autoBurnLiquidityPairTokens() internal returns (bool) {
1555         lastLpBurnTime = block.timestamp;
1556 
1557         // get balance of liquidity pair
1558         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1559 
1560         // calculate amount to burn
1561         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1562             10000
1563         );
1564 
1565         // pull tokens from pancakePair liquidity and move to dead address permanently
1566         if (amountToBurn > 0) {
1567             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1568         }
1569 
1570         //sync price since this is not in a swap transaction!
1571         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1572         pair.sync();
1573         emit AutoNukeLP();
1574         return true;
1575     }
1576 
1577     function manualBurnLiquidityPairTokens(uint256 percent)
1578         external
1579         onlyOwner
1580         returns (bool)
1581     {
1582         require(
1583             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1584             "Must wait for cooldown to finish"
1585         );
1586         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1587         lastManualLpBurnTime = block.timestamp;
1588 
1589         // get balance of liquidity pair
1590         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1591 
1592         // calculate amount to burn
1593         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1594 
1595         // pull tokens from pancakePair liquidity and move to dead address permanently
1596         if (amountToBurn > 0) {
1597             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1598         }
1599 
1600         //sync price since this is not in a swap transaction!
1601         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1602         pair.sync();
1603         emit ManualNukeLP();
1604         return true;
1605     }
1606 }