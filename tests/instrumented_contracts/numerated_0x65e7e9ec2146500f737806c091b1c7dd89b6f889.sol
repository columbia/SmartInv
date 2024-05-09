1 /**
2  *Submitted for verification at Etherscan.io on 2022-09-02
3 */
4 
5 //https://medium.com/@ikigaierc/what-is-the-meaning-of-my-life-511260988900
6 //https://twitter.com/IkigaiErc
7 
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
1031 contract Ikigai is ERC20, Ownable {
1032     using SafeMath for uint256;
1033 
1034     IUniswapV2Router02 public immutable uniswapV2Router;
1035     address public immutable uniswapV2Pair;
1036     address public constant deadAddress = address(0xdead);
1037 
1038     bool private swapping;
1039 
1040     address public devWallet;
1041 
1042     uint256 public maxTransactionAmount;
1043     uint256 public swapTokensAtAmount;
1044     uint256 public maxWallet;
1045 
1046     bool public limitsInEffect = true;
1047     bool public tradingActive = false;
1048     bool public swapEnabled = false;
1049 
1050     uint256 public buyTotalFees;
1051     uint256 public buyLiquidityFee;
1052     uint256 public buyDevFee;
1053 
1054     uint256 public sellTotalFees;
1055     uint256 public sellLiquidityFee;
1056     uint256 public sellDevFee;
1057 
1058 	uint256 public tokensForLiquidity;
1059     uint256 public tokensForDev;
1060 
1061     /******************/
1062 
1063     // exlcude from fees and max transaction amount
1064     mapping(address => bool) private _isExcludedFromFees;
1065     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1066 
1067     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1068     // could be subject to a maximum transfer amount
1069     mapping(address => bool) public automatedMarketMakerPairs;
1070 
1071     event UpdateUniswapV2Router(
1072         address indexed newAddress,
1073         address indexed oldAddress
1074     );
1075 
1076     event ExcludeFromFees(address indexed account, bool isExcluded);
1077 
1078     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1079 
1080     event SwapAndLiquify(
1081         uint256 tokensSwapped,
1082         uint256 ethReceived,
1083         uint256 tokensIntoLiquidity
1084     );
1085 
1086     constructor() ERC20("Ikigai", "Gai") {
1087         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1088             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1089         );
1090 
1091         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1092         uniswapV2Router = _uniswapV2Router;
1093 
1094         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1095             .createPair(address(this), _uniswapV2Router.WETH());
1096         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1097         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1098 
1099         uint256 _buyLiquidityFee = 2;
1100         uint256 _buyDevFee = 0;
1101 
1102         uint256 _sellLiquidityFee = 2;
1103         uint256 _sellDevFee = 0;
1104 
1105         uint256 totalSupply = 1 * 1e9 * 1e18;
1106 
1107         maxTransactionAmount = 2 * 1e7 * 1e18; // 2% from total supply maxTransactionAmountTxn
1108         maxWallet = 2 * 1e7 * 1e18; // 2% from total supply maxWallet
1109         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1110 
1111         buyLiquidityFee = _buyLiquidityFee;
1112         buyDevFee = _buyDevFee;
1113         buyTotalFees = buyLiquidityFee + buyDevFee;
1114 
1115         sellLiquidityFee = _sellLiquidityFee;
1116         sellDevFee = _sellDevFee;
1117         sellTotalFees = sellLiquidityFee + sellDevFee;
1118 
1119         devWallet = address(0xC40c0479D4c664525ACC34eB5D343E946759C190); // set as dev wallet
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
1143     }
1144 
1145     // remove limits after token is stable
1146     function removeLimits() external onlyOwner returns (bool) {
1147         limitsInEffect = false;
1148         return true;
1149     }
1150 
1151     // change the minimum amount of tokens to sell from fees
1152     function updateSwapTokensAtAmount(uint256 newAmount)
1153         external
1154         onlyOwner
1155         returns (bool)
1156     {
1157         require(
1158             newAmount >= (totalSupply() * 1) / 100000,
1159             "Swap amount cannot be lower than 0.001% total supply."
1160         );
1161         require(
1162             newAmount <= (totalSupply() * 5) / 1000,
1163             "Swap amount cannot be higher than 0.5% total supply."
1164         );
1165         swapTokensAtAmount = newAmount;
1166         return true;
1167     }
1168 	
1169     function excludeFromMaxTransaction(address updAds, bool isEx)
1170         public
1171         onlyOwner
1172     {
1173         _isExcludedMaxTransactionAmount[updAds] = isEx;
1174     }
1175 
1176     // only use to disable contract sales if absolutely necessary (emergency use only)
1177     function updateSwapEnabled(bool enabled) external onlyOwner {
1178         swapEnabled = enabled;
1179     }
1180 
1181     function excludeFromFees(address account, bool excluded) public onlyOwner {
1182         _isExcludedFromFees[account] = excluded;
1183         emit ExcludeFromFees(account, excluded);
1184     }
1185 
1186     function setAutomatedMarketMakerPair(address pair, bool value)
1187         public
1188         onlyOwner
1189     {
1190         require(
1191             pair != uniswapV2Pair,
1192             "The pair cannot be removed from automatedMarketMakerPairs"
1193         );
1194 
1195         _setAutomatedMarketMakerPair(pair, value);
1196     }
1197 
1198     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1199         automatedMarketMakerPairs[pair] = value;
1200 
1201         emit SetAutomatedMarketMakerPair(pair, value);
1202     }
1203 
1204     function isExcludedFromFees(address account) public view returns (bool) {
1205         return _isExcludedFromFees[account];
1206     }
1207 
1208     function _transfer(
1209         address from,
1210         address to,
1211         uint256 amount
1212     ) internal override {
1213         require(from != address(0), "ERC20: transfer from the zero address");
1214         require(to != address(0), "ERC20: transfer to the zero address");
1215 
1216         if (amount == 0) {
1217             super._transfer(from, to, 0);
1218             return;
1219         }
1220 
1221         if (limitsInEffect) {
1222             if (
1223                 from != owner() &&
1224                 to != owner() &&
1225                 to != address(0) &&
1226                 to != address(0xdead) &&
1227                 !swapping
1228             ) {
1229                 if (!tradingActive) {
1230                     require(
1231                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1232                         "Trading is not active."
1233                     );
1234                 }
1235 
1236                 //when buy
1237                 if (
1238                     automatedMarketMakerPairs[from] &&
1239                     !_isExcludedMaxTransactionAmount[to]
1240                 ) {
1241                     require(
1242                         amount <= maxTransactionAmount,
1243                         "Buy transfer amount exceeds the maxTransactionAmount."
1244                     );
1245                     require(
1246                         amount + balanceOf(to) <= maxWallet,
1247                         "Max wallet exceeded"
1248                     );
1249                 }
1250                 //when sell
1251                 else if (
1252                     automatedMarketMakerPairs[to] &&
1253                     !_isExcludedMaxTransactionAmount[from]
1254                 ) {
1255                     require(
1256                         amount <= maxTransactionAmount,
1257                         "Sell transfer amount exceeds the maxTransactionAmount."
1258                     );
1259                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1260                     require(
1261                         amount + balanceOf(to) <= maxWallet,
1262                         "Max wallet exceeded"
1263                     );
1264                 }
1265             }
1266         }
1267 
1268         uint256 contractTokenBalance = balanceOf(address(this));
1269 
1270         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1271 
1272         if (
1273             canSwap &&
1274             swapEnabled &&
1275             !swapping &&
1276             !automatedMarketMakerPairs[from] &&
1277             !_isExcludedFromFees[from] &&
1278             !_isExcludedFromFees[to]
1279         ) {
1280             swapping = true;
1281 
1282             swapBack();
1283 
1284             swapping = false;
1285         }
1286 
1287         bool takeFee = !swapping;
1288 
1289         // if any account belongs to _isExcludedFromFee account then remove the fee
1290         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1291             takeFee = false;
1292         }
1293 
1294         uint256 fees = 0;
1295         // only take fees on buys/sells, do not take on wallet transfers
1296         if (takeFee) {
1297             // on sell
1298             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1299                 fees = amount.mul(sellTotalFees).div(100);
1300                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1301                 tokensForDev += (fees * sellDevFee) / sellTotalFees;                
1302             }
1303             // on buy
1304             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1305                 fees = amount.mul(buyTotalFees).div(100);
1306                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1307                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1308             }
1309 
1310             if (fees > 0) {
1311                 super._transfer(from, address(this), fees);
1312             }
1313 
1314             amount -= fees;
1315         }
1316 
1317         super._transfer(from, to, amount);
1318     }
1319 
1320     function swapTokensForEth(uint256 tokenAmount) private {
1321         // generate the uniswap pair path of token -> weth
1322         address[] memory path = new address[](2);
1323         path[0] = address(this);
1324         path[1] = uniswapV2Router.WETH();
1325 
1326         _approve(address(this), address(uniswapV2Router), tokenAmount);
1327 
1328         // make the swap
1329         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1330             tokenAmount,
1331             0, // accept any amount of ETH
1332             path,
1333             address(this),
1334             block.timestamp
1335         );
1336     }
1337 
1338     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1339         // approve token transfer to cover all possible scenarios
1340         _approve(address(this), address(uniswapV2Router), tokenAmount);
1341 
1342         // add the liquidity
1343         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1344             address(this),
1345             tokenAmount,
1346             0, // slippage is unavoidable
1347             0, // slippage is unavoidable
1348             devWallet,
1349             block.timestamp
1350         );
1351     }
1352 
1353     function swapBack() private {
1354         uint256 contractBalance = balanceOf(address(this));
1355         uint256 totalTokensToSwap = tokensForLiquidity + tokensForDev;
1356         bool success;
1357 
1358         if (contractBalance == 0 || totalTokensToSwap == 0) {
1359             return;
1360         }
1361 
1362         if (contractBalance > swapTokensAtAmount * 20) {
1363             contractBalance = swapTokensAtAmount * 20;
1364         }
1365 
1366         // Halve the amount of liquidity tokens
1367         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1368         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1369 
1370         uint256 initialETHBalance = address(this).balance;
1371 
1372         swapTokensForEth(amountToSwapForETH);
1373 
1374         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1375 	
1376         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1377 
1378         uint256 ethForLiquidity = ethBalance - ethForDev;
1379 
1380         tokensForLiquidity = 0;
1381         tokensForDev = 0;
1382 
1383         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1384             addLiquidity(liquidityTokens, ethForLiquidity);
1385             emit SwapAndLiquify(
1386                 amountToSwapForETH,
1387                 ethForLiquidity,
1388                 tokensForLiquidity
1389             );
1390         }
1391 
1392         (success, ) = address(devWallet).call{value: address(this).balance}("");
1393     }
1394 
1395 }