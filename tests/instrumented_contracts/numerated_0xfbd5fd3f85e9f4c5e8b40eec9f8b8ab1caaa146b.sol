1 /*
2 
3 t.me/TreatPortal
4 
5 https://twitter.com/shibtoken/
6 
7 https://t.me/ShibaInu_Dogecoinkiller
8 
9 
10 */
11 // SPDX-License-Identifier: MIT
12 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
13 pragma experimental ABIEncoderV2;
14 
15 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
16 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
17 
18 /* pragma solidity ^0.8.0; */
19 
20 /**
21  * @dev Provides information about the current execution context, including the
22  * sender of the transaction and its data. While these are generally available
23  * via msg.sender and msg.data, they should not be accessed in such a direct
24  * manner, since when dealing with meta-transactions the account sending and
25  * paying for execution may not be the actual sender (as far as an application
26  * is concerned).
27  *
28  * This contract is only required for intermediate, library-like contracts.
29  */
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address) {
32         return msg.sender;
33     }
34 
35     function _msgData() internal view virtual returns (bytes calldata) {
36         return msg.data;
37     }
38 }
39 
40 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
41 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
42 
43 /* pragma solidity ^0.8.0; */
44 
45 /* import "../utils/Context.sol"; */
46 
47 /**
48  * @dev Contract module which provides a basic access control mechanism, where
49  * there is an account (an owner) that can be granted exclusive access to
50  * specific functions.
51  *
52  * By default, the owner account will be the one that deploys the contract. This
53  * can later be changed with {transferOwnership}.
54  *
55  * This module is used through inheritance. It will make available the modifier
56  * `onlyOwner`, which can be applied to your functions to restrict their use to
57  * the owner.
58  */
59 abstract contract Ownable is Context {
60     address private _owner;
61 
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     /**
65      * @dev Initializes the contract setting the deployer as the initial owner.
66      */
67     constructor() {
68         _transferOwnership(_msgSender());
69     }
70 
71     /**
72      * @dev Returns the address of the current owner.
73      */
74     function owner() public view virtual returns (address) {
75         return _owner;
76     }
77 
78     /**
79      * @dev Throws if called by any account other than the owner.
80      */
81     modifier onlyOwner() {
82         require(owner() == _msgSender(), "Ownable: caller is not the owner");
83         _;
84     }
85 
86     /**
87      * @dev Leaves the contract without owner. It will not be possible to call
88      * `onlyOwner` functions anymore. Can only be called by the current owner.
89      *
90      * NOTE: Renouncing ownership will leave the contract without an owner,
91      * thereby removing any functionality that is only available to the owner.
92      */
93     function renounceOwnership() public virtual onlyOwner {
94         _transferOwnership(address(0));
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Can only be called by the current owner.
100      */
101     function transferOwnership(address newOwner) public virtual onlyOwner {
102         require(newOwner != address(0), "Ownable: new owner is the zero address");
103         _transferOwnership(newOwner);
104     }
105 
106     /**
107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
108      * Internal function without access restriction.
109      */
110     function _transferOwnership(address newOwner) internal virtual {
111         address oldOwner = _owner;
112         _owner = newOwner;
113         emit OwnershipTransferred(oldOwner, newOwner);
114     }
115 }
116 
117 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
118 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
119 
120 /* pragma solidity ^0.8.0; */
121 
122 /**
123  * @dev Interface of the ERC20 standard as defined in the EIP.
124  */
125 interface IERC20 {
126     /**
127      * @dev Returns the amount of tokens in existence.
128      */
129     function totalSupply() external view returns (uint256);
130 
131     /**
132      * @dev Returns the amount of tokens owned by `account`.
133      */
134     function balanceOf(address account) external view returns (uint256);
135 
136     /**
137      * @dev Moves `amount` tokens from the caller's account to `recipient`.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * Emits a {Transfer} event.
142      */
143     function transfer(address recipient, uint256 amount) external returns (bool);
144 
145     /**
146      * @dev Returns the remaining number of tokens that `spender` will be
147      * allowed to spend on behalf of `owner` through {transferFrom}. This is
148      * zero by default.
149      *
150      * This value changes when {approve} or {transferFrom} are called.
151      */
152     function allowance(address owner, address spender) external view returns (uint256);
153 
154     /**
155      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * IMPORTANT: Beware that changing an allowance with this method brings the risk
160      * that someone may use both the old and the new allowance by unfortunate
161      * transaction ordering. One possible solution to mitigate this race
162      * condition is to first reduce the spender's allowance to 0 and set the
163      * desired value afterwards:
164      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165      *
166      * Emits an {Approval} event.
167      */
168     function approve(address spender, uint256 amount) external returns (bool);
169 
170     /**
171      * @dev Moves `amount` tokens from `sender` to `recipient` using the
172      * allowance mechanism. `amount` is then deducted from the caller's
173      * allowance.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * Emits a {Transfer} event.
178      */
179     function transferFrom(
180         address sender,
181         address recipient,
182         uint256 amount
183     ) external returns (bool);
184 
185     /**
186      * @dev Emitted when `value` tokens are moved from one account (`from`) to
187      * another (`to`).
188      *
189      * Note that `value` may be zero.
190      */
191     event Transfer(address indexed from, address indexed to, uint256 value);
192 
193     /**
194      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
195      * a call to {approve}. `value` is the new allowance.
196      */
197     event Approval(address indexed owner, address indexed spender, uint256 value);
198 }
199 
200 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
201 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
202 
203 /* pragma solidity ^0.8.0; */
204 
205 /* import "../IERC20.sol"; */
206 
207 /**
208  * @dev Interface for the optional metadata functions from the ERC20 standard.
209  *
210  * _Available since v4.1._
211  */
212 interface IERC20Metadata is IERC20 {
213     /**
214      * @dev Returns the name of the token.
215      */
216     function name() external view returns (string memory);
217 
218     /**
219      * @dev Returns the symbol of the token.
220      */
221     function symbol() external view returns (string memory);
222 
223     /**
224      * @dev Returns the decimals places of the token.
225      */
226     function decimals() external view returns (uint8);
227 }
228 
229 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
230 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
231 
232 /* pragma solidity ^0.8.0; */
233 
234 /* import "./IERC20.sol"; */
235 /* import "./extensions/IERC20Metadata.sol"; */
236 /* import "../../utils/Context.sol"; */
237 
238 /**
239  * @dev Implementation of the {IERC20} interface.
240  *
241  * This implementation is agnostic to the way tokens are created. This means
242  * that a supply mechanism has to be added in a derived contract using {_mint}.
243  * For a generic mechanism see {ERC20PresetMinterPauser}.
244  *
245  * TIP: For a detailed writeup see our guide
246  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
247  * to implement supply mechanisms].
248  *
249  * We have followed general OpenZeppelin Contracts guidelines: functions revert
250  * instead returning `false` on failure. This behavior is nonetheless
251  * conventional and does not conflict with the expectations of ERC20
252  * applications.
253  *
254  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
255  * This allows applications to reconstruct the allowance for all accounts just
256  * by listening to said events. Other implementations of the EIP may not emit
257  * these events, as it isn't required by the specification.
258  *
259  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
260  * functions have been added to mitigate the well-known issues around setting
261  * allowances. See {IERC20-approve}.
262  */
263 contract ERC20 is Context, IERC20, IERC20Metadata {
264     mapping(address => uint256) private _balances;
265 
266     mapping(address => mapping(address => uint256)) private _allowances;
267 
268     uint256 private _totalSupply;
269 
270     string private _name;
271     string private _symbol;
272 
273     /**
274      * @dev Sets the values for {name} and {symbol}.
275      *
276      * The default value of {decimals} is 18. To select a different value for
277      * {decimals} you should overload it.
278      *
279      * All two of these values are immutable: they can only be set once during
280      * construction.
281      */
282     constructor(string memory name_, string memory symbol_) {
283         _name = name_;
284         _symbol = symbol_;
285     }
286 
287     /**
288      * @dev Returns the name of the token.
289      */
290     function name() public view virtual override returns (string memory) {
291         return _name;
292     }
293 
294     /**
295      * @dev Returns the symbol of the token, usually a shorter version of the
296      * name.
297      */
298     function symbol() public view virtual override returns (string memory) {
299         return _symbol;
300     }
301 
302     /**
303      * @dev Returns the number of decimals used to get its user representation.
304      * For example, if `decimals` equals `2`, a balance of `505` tokens should
305      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
306      *
307      * Tokens usually opt for a value of 18, imitating the relationship between
308      * Ether and Wei. This is the value {ERC20} uses, unless this function is
309      * overridden;
310      *
311      * NOTE: This information is only used for _display_ purposes: it in
312      * no way affects any of the arithmetic of the contract, including
313      * {IERC20-balanceOf} and {IERC20-transfer}.
314      */
315     function decimals() public view virtual override returns (uint8) {
316         return 18;
317     }
318 
319     /**
320      * @dev See {IERC20-totalSupply}.
321      */
322     function totalSupply() public view virtual override returns (uint256) {
323         return _totalSupply;
324     }
325 
326     /**
327      * @dev See {IERC20-balanceOf}.
328      */
329     function balanceOf(address account) public view virtual override returns (uint256) {
330         return _balances[account];
331     }
332 
333     /**
334      * @dev See {IERC20-transfer}.
335      *
336      * Requirements:
337      *
338      * - `recipient` cannot be the zero address.
339      * - the caller must have a balance of at least `amount`.
340      */
341     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
342         _transfer(_msgSender(), recipient, amount);
343         return true;
344     }
345 
346     /**
347      * @dev See {IERC20-allowance}.
348      */
349     function allowance(address owner, address spender) public view virtual override returns (uint256) {
350         return _allowances[owner][spender];
351     }
352 
353     /**
354      * @dev See {IERC20-approve}.
355      *
356      * Requirements:
357      *
358      * - `spender` cannot be the zero address.
359      */
360     function approve(address spender, uint256 amount) public virtual override returns (bool) {
361         _approve(_msgSender(), spender, amount);
362         return true;
363     }
364 
365     /**
366      * @dev See {IERC20-transferFrom}.
367      *
368      * Emits an {Approval} event indicating the updated allowance. This is not
369      * required by the EIP. See the note at the beginning of {ERC20}.
370      *
371      * Requirements:
372      *
373      * - `sender` and `recipient` cannot be the zero address.
374      * - `sender` must have a balance of at least `amount`.
375      * - the caller must have allowance for ``sender``'s tokens of at least
376      * `amount`.
377      */
378     function transferFrom(
379         address sender,
380         address recipient,
381         uint256 amount
382     ) public virtual override returns (bool) {
383         _transfer(sender, recipient, amount);
384 
385         uint256 currentAllowance = _allowances[sender][_msgSender()];
386         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
387         unchecked {
388             _approve(sender, _msgSender(), currentAllowance - amount);
389         }
390 
391         return true;
392     }
393 
394     /**
395      * @dev Atomically increases the allowance granted to `spender` by the caller.
396      *
397      * This is an alternative to {approve} that can be used as a mitigation for
398      * problems described in {IERC20-approve}.
399      *
400      * Emits an {Approval} event indicating the updated allowance.
401      *
402      * Requirements:
403      *
404      * - `spender` cannot be the zero address.
405      */
406     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
407         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
408         return true;
409     }
410 
411     /**
412      * @dev Atomically decreases the allowance granted to `spender` by the caller.
413      *
414      * This is an alternative to {approve} that can be used as a mitigation for
415      * problems described in {IERC20-approve}.
416      *
417      * Emits an {Approval} event indicating the updated allowance.
418      *
419      * Requirements:
420      *
421      * - `spender` cannot be the zero address.
422      * - `spender` must have allowance for the caller of at least
423      * `subtractedValue`.
424      */
425     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
426         uint256 currentAllowance = _allowances[_msgSender()][spender];
427         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
428         unchecked {
429             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
430         }
431 
432         return true;
433     }
434 
435     /**
436      * @dev Moves `amount` of tokens from `sender` to `recipient`.
437      *
438      * This internal function is equivalent to {transfer}, and can be used to
439      * e.g. implement automatic token fees, slashing mechanisms, etc.
440      *
441      * Emits a {Transfer} event.
442      *
443      * Requirements:
444      *
445      * - `sender` cannot be the zero address.
446      * - `recipient` cannot be the zero address.
447      * - `sender` must have a balance of at least `amount`.
448      */
449     function _transfer(
450         address sender,
451         address recipient,
452         uint256 amount
453     ) internal virtual {
454         require(sender != address(0), "ERC20: transfer from the zero address");
455         require(recipient != address(0), "ERC20: transfer to the zero address");
456 
457         _beforeTokenTransfer(sender, recipient, amount);
458 
459         uint256 senderBalance = _balances[sender];
460         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
461         unchecked {
462             _balances[sender] = senderBalance - amount;
463         }
464         _balances[recipient] += amount;
465 
466         emit Transfer(sender, recipient, amount);
467 
468         _afterTokenTransfer(sender, recipient, amount);
469     }
470 
471     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
472      * the total supply.
473      *
474      * Emits a {Transfer} event with `from` set to the zero address.
475      *
476      * Requirements:
477      *
478      * - `account` cannot be the zero address.
479      */
480     function _mint(address account, uint256 amount) internal virtual {
481         require(account != address(0), "ERC20: mint to the zero address");
482 
483         _beforeTokenTransfer(address(0), account, amount);
484 
485         _totalSupply += amount;
486         _balances[account] += amount;
487         emit Transfer(address(0), account, amount);
488 
489         _afterTokenTransfer(address(0), account, amount);
490     }
491 
492     /**
493      * @dev Destroys `amount` tokens from `account`, reducing the
494      * total supply.
495      *
496      * Emits a {Transfer} event with `to` set to the zero address.
497      *
498      * Requirements:
499      *
500      * - `account` cannot be the zero address.
501      * - `account` must have at least `amount` tokens.
502      */
503     function _burn(address account, uint256 amount) internal virtual {
504         require(account != address(0), "ERC20: burn from the zero address");
505 
506         _beforeTokenTransfer(account, address(0), amount);
507 
508         uint256 accountBalance = _balances[account];
509         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
510         unchecked {
511             _balances[account] = accountBalance - amount;
512         }
513         _totalSupply -= amount;
514 
515         emit Transfer(account, address(0), amount);
516 
517         _afterTokenTransfer(account, address(0), amount);
518     }
519 
520     /**
521      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
522      *
523      * This internal function is equivalent to `approve`, and can be used to
524      * e.g. set automatic allowances for certain subsystems, etc.
525      *
526      * Emits an {Approval} event.
527      *
528      * Requirements:
529      *
530      * - `owner` cannot be the zero address.
531      * - `spender` cannot be the zero address.
532      */
533     function _approve(
534         address owner,
535         address spender,
536         uint256 amount
537     ) internal virtual {
538         require(owner != address(0), "ERC20: approve from the zero address");
539         require(spender != address(0), "ERC20: approve to the zero address");
540 
541         _allowances[owner][spender] = amount;
542         emit Approval(owner, spender, amount);
543     }
544 
545     /**
546      * @dev Hook that is called before any transfer of tokens. This includes
547      * minting and burning.
548      *
549      * Calling conditions:
550      *
551      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
552      * will be transferred to `to`.
553      * - when `from` is zero, `amount` tokens will be minted for `to`.
554      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
555      * - `from` and `to` are never both zero.
556      *
557      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
558      */
559     function _beforeTokenTransfer(
560         address from,
561         address to,
562         uint256 amount
563     ) internal virtual {}
564 
565     /**
566      * @dev Hook that is called after any transfer of tokens. This includes
567      * minting and burning.
568      *
569      * Calling conditions:
570      *
571      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
572      * has been transferred to `to`.
573      * - when `from` is zero, `amount` tokens have been minted for `to`.
574      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
575      * - `from` and `to` are never both zero.
576      *
577      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
578      */
579     function _afterTokenTransfer(
580         address from,
581         address to,
582         uint256 amount
583     ) internal virtual {}
584 }
585 
586 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
587 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
588 
589 /* pragma solidity ^0.8.0; */
590 
591 // CAUTION
592 // This version of SafeMath should only be used with Solidity 0.8 or later,
593 // because it relies on the compiler's built in overflow checks.
594 
595 /**
596  * @dev Wrappers over Solidity's arithmetic operations.
597  *
598  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
599  * now has built in overflow checking.
600  */
601 library SafeMath {
602     /**
603      * @dev Returns the addition of two unsigned integers, with an overflow flag.
604      *
605      * _Available since v3.4._
606      */
607     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
608         unchecked {
609             uint256 c = a + b;
610             if (c < a) return (false, 0);
611             return (true, c);
612         }
613     }
614 
615     /**
616      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
617      *
618      * _Available since v3.4._
619      */
620     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
621         unchecked {
622             if (b > a) return (false, 0);
623             return (true, a - b);
624         }
625     }
626 
627     /**
628      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
629      *
630      * _Available since v3.4._
631      */
632     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
633         unchecked {
634             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
635             // benefit is lost if 'b' is also tested.
636             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
637             if (a == 0) return (true, 0);
638             uint256 c = a * b;
639             if (c / a != b) return (false, 0);
640             return (true, c);
641         }
642     }
643 
644     /**
645      * @dev Returns the division of two unsigned integers, with a division by zero flag.
646      *
647      * _Available since v3.4._
648      */
649     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
650         unchecked {
651             if (b == 0) return (false, 0);
652             return (true, a / b);
653         }
654     }
655 
656     /**
657      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
658      *
659      * _Available since v3.4._
660      */
661     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
662         unchecked {
663             if (b == 0) return (false, 0);
664             return (true, a % b);
665         }
666     }
667 
668     /**
669      * @dev Returns the addition of two unsigned integers, reverting on
670      * overflow.
671      *
672      * Counterpart to Solidity's `+` operator.
673      *
674      * Requirements:
675      *
676      * - Addition cannot overflow.
677      */
678     function add(uint256 a, uint256 b) internal pure returns (uint256) {
679         return a + b;
680     }
681 
682     /**
683      * @dev Returns the subtraction of two unsigned integers, reverting on
684      * overflow (when the result is negative).
685      *
686      * Counterpart to Solidity's `-` operator.
687      *
688      * Requirements:
689      *
690      * - Subtraction cannot overflow.
691      */
692     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
693         return a - b;
694     }
695 
696     /**
697      * @dev Returns the multiplication of two unsigned integers, reverting on
698      * overflow.
699      *
700      * Counterpart to Solidity's `*` operator.
701      *
702      * Requirements:
703      *
704      * - Multiplication cannot overflow.
705      */
706     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
707         return a * b;
708     }
709 
710     /**
711      * @dev Returns the integer division of two unsigned integers, reverting on
712      * division by zero. The result is rounded towards zero.
713      *
714      * Counterpart to Solidity's `/` operator.
715      *
716      * Requirements:
717      *
718      * - The divisor cannot be zero.
719      */
720     function div(uint256 a, uint256 b) internal pure returns (uint256) {
721         return a / b;
722     }
723 
724     /**
725      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
726      * reverting when dividing by zero.
727      *
728      * Counterpart to Solidity's `%` operator. This function uses a `revert`
729      * opcode (which leaves remaining gas untouched) while Solidity uses an
730      * invalid opcode to revert (consuming all remaining gas).
731      *
732      * Requirements:
733      *
734      * - The divisor cannot be zero.
735      */
736     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
737         return a % b;
738     }
739 
740     /**
741      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
742      * overflow (when the result is negative).
743      *
744      * CAUTION: This function is deprecated because it requires allocating memory for the error
745      * message unnecessarily. For custom revert reasons use {trySub}.
746      *
747      * Counterpart to Solidity's `-` operator.
748      *
749      * Requirements:
750      *
751      * - Subtraction cannot overflow.
752      */
753     function sub(
754         uint256 a,
755         uint256 b,
756         string memory errorMessage
757     ) internal pure returns (uint256) {
758         unchecked {
759             require(b <= a, errorMessage);
760             return a - b;
761         }
762     }
763 
764     /**
765      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
766      * division by zero. The result is rounded towards zero.
767      *
768      * Counterpart to Solidity's `/` operator. Note: this function uses a
769      * `revert` opcode (which leaves remaining gas untouched) while Solidity
770      * uses an invalid opcode to revert (consuming all remaining gas).
771      *
772      * Requirements:
773      *
774      * - The divisor cannot be zero.
775      */
776     function div(
777         uint256 a,
778         uint256 b,
779         string memory errorMessage
780     ) internal pure returns (uint256) {
781         unchecked {
782             require(b > 0, errorMessage);
783             return a / b;
784         }
785     }
786 
787     /**
788      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
789      * reverting with custom message when dividing by zero.
790      *
791      * CAUTION: This function is deprecated because it requires allocating memory for the error
792      * message unnecessarily. For custom revert reasons use {tryMod}.
793      *
794      * Counterpart to Solidity's `%` operator. This function uses a `revert`
795      * opcode (which leaves remaining gas untouched) while Solidity uses an
796      * invalid opcode to revert (consuming all remaining gas).
797      *
798      * Requirements:
799      *
800      * - The divisor cannot be zero.
801      */
802     function mod(
803         uint256 a,
804         uint256 b,
805         string memory errorMessage
806     ) internal pure returns (uint256) {
807         unchecked {
808             require(b > 0, errorMessage);
809             return a % b;
810         }
811     }
812 }
813 
814 ////// src/IUniswapV2Factory.sol
815 /* pragma solidity 0.8.10; */
816 /* pragma experimental ABIEncoderV2; */
817 
818 interface IUniswapV2Factory {
819     event PairCreated(
820         address indexed token0,
821         address indexed token1,
822         address pair,
823         uint256
824     );
825 
826     function feeTo() external view returns (address);
827 
828     function feeToSetter() external view returns (address);
829 
830     function getPair(address tokenA, address tokenB)
831         external
832         view
833         returns (address pair);
834 
835     function allPairs(uint256) external view returns (address pair);
836 
837     function allPairsLength() external view returns (uint256);
838 
839     function createPair(address tokenA, address tokenB)
840         external
841         returns (address pair);
842 
843     function setFeeTo(address) external;
844 
845     function setFeeToSetter(address) external;
846 }
847 
848 ////// src/IUniswapV2Pair.sol
849 /* pragma solidity 0.8.10; */
850 /* pragma experimental ABIEncoderV2; */
851 
852 interface IUniswapV2Pair {
853     event Approval(
854         address indexed owner,
855         address indexed spender,
856         uint256 value
857     );
858     event Transfer(address indexed from, address indexed to, uint256 value);
859 
860     function name() external pure returns (string memory);
861 
862     function symbol() external pure returns (string memory);
863 
864     function decimals() external pure returns (uint8);
865 
866     function totalSupply() external view returns (uint256);
867 
868     function balanceOf(address owner) external view returns (uint256);
869 
870     function allowance(address owner, address spender)
871         external
872         view
873         returns (uint256);
874 
875     function approve(address spender, uint256 value) external returns (bool);
876 
877     function transfer(address to, uint256 value) external returns (bool);
878 
879     function transferFrom(
880         address from,
881         address to,
882         uint256 value
883     ) external returns (bool);
884 
885     function DOMAIN_SEPARATOR() external view returns (bytes32);
886 
887     function PERMIT_TYPEHASH() external pure returns (bytes32);
888 
889     function nonces(address owner) external view returns (uint256);
890 
891     function permit(
892         address owner,
893         address spender,
894         uint256 value,
895         uint256 deadline,
896         uint8 v,
897         bytes32 r,
898         bytes32 s
899     ) external;
900 
901     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
902     event Burn(
903         address indexed sender,
904         uint256 amount0,
905         uint256 amount1,
906         address indexed to
907     );
908     event Swap(
909         address indexed sender,
910         uint256 amount0In,
911         uint256 amount1In,
912         uint256 amount0Out,
913         uint256 amount1Out,
914         address indexed to
915     );
916     event Sync(uint112 reserve0, uint112 reserve1);
917 
918     function MINIMUM_LIQUIDITY() external pure returns (uint256);
919 
920     function factory() external view returns (address);
921 
922     function token0() external view returns (address);
923 
924     function token1() external view returns (address);
925 
926     function getReserves()
927         external
928         view
929         returns (
930             uint112 reserve0,
931             uint112 reserve1,
932             uint32 blockTimestampLast
933         );
934 
935     function price0CumulativeLast() external view returns (uint256);
936 
937     function price1CumulativeLast() external view returns (uint256);
938 
939     function kLast() external view returns (uint256);
940 
941     function mint(address to) external returns (uint256 liquidity);
942 
943     function burn(address to)
944         external
945         returns (uint256 amount0, uint256 amount1);
946 
947     function swap(
948         uint256 amount0Out,
949         uint256 amount1Out,
950         address to,
951         bytes calldata data
952     ) external;
953 
954     function skim(address to) external;
955 
956     function sync() external;
957 
958     function initialize(address, address) external;
959 }
960 
961 ////// src/IUniswapV2Router02.sol
962 /* pragma solidity 0.8.10; */
963 /* pragma experimental ABIEncoderV2; */
964 
965 interface IUniswapV2Router02 {
966     function factory() external pure returns (address);
967 
968     function WETH() external pure returns (address);
969 
970     function addLiquidity(
971         address tokenA,
972         address tokenB,
973         uint256 amountADesired,
974         uint256 amountBDesired,
975         uint256 amountAMin,
976         uint256 amountBMin,
977         address to,
978         uint256 deadline
979     )
980         external
981         returns (
982             uint256 amountA,
983             uint256 amountB,
984             uint256 liquidity
985         );
986 
987     function addLiquidityETH(
988         address token,
989         uint256 amountTokenDesired,
990         uint256 amountTokenMin,
991         uint256 amountETHMin,
992         address to,
993         uint256 deadline
994     )
995         external
996         payable
997         returns (
998             uint256 amountToken,
999             uint256 amountETH,
1000             uint256 liquidity
1001         );
1002 
1003     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1004         uint256 amountIn,
1005         uint256 amountOutMin,
1006         address[] calldata path,
1007         address to,
1008         uint256 deadline
1009     ) external;
1010 
1011     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1012         uint256 amountOutMin,
1013         address[] calldata path,
1014         address to,
1015         uint256 deadline
1016     ) external payable;
1017 
1018     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1019         uint256 amountIn,
1020         uint256 amountOutMin,
1021         address[] calldata path,
1022         address to,
1023         uint256 deadline
1024     ) external;
1025 }
1026 
1027 /* pragma solidity >=0.8.10; */
1028 
1029 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1030 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1031 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1032 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1033 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1034 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1035 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1036 
1037 contract Treat is ERC20, Ownable {
1038     using SafeMath for uint256;
1039 
1040     IUniswapV2Router02 public immutable uniswapV2Router;
1041     address public immutable uniswapV2Pair;
1042     address public constant deadAddress = address(0xdead);
1043 
1044     bool private swapping;
1045 
1046     address public marketingWallet;
1047     address public devWallet;
1048 
1049     uint256 public maxTransactionAmount;
1050     uint256 public swapTokensAtAmount;
1051     uint256 public maxWallet;
1052 
1053     uint256 public percentForLPBurn = 25; // 25 = .25%
1054     bool public lpBurnEnabled = true;
1055     uint256 public lpBurnFrequency = 3600 seconds;
1056     uint256 public lastLpBurnTime;
1057 
1058     uint256 public manualBurnFrequency = 30 minutes;
1059     uint256 public lastManualLpBurnTime;
1060 
1061     bool public limitsInEffect = true;
1062     bool public tradingActive = false;
1063     bool public swapEnabled = false;
1064 
1065     // Anti-bot and anti-whale mappings and variables
1066     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1067     bool public transferDelayEnabled = true;
1068 
1069     uint256 public buyTotalFees;
1070     uint256 public buyMarketingFee;
1071     uint256 public buyLiquidityFee;
1072     uint256 public buyDevFee;
1073 
1074     uint256 public sellTotalFees;
1075     uint256 public sellMarketingFee;
1076     uint256 public sellLiquidityFee;
1077     uint256 public sellDevFee;
1078 
1079     uint256 public tokensForMarketing;
1080     uint256 public tokensForLiquidity;
1081     uint256 public tokensForDev;
1082 
1083     /******************/
1084 
1085     // exlcude from fees and max transaction amount
1086     mapping(address => bool) private _isExcludedFromFees;
1087     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1088 
1089     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1090     // could be subject to a maximum transfer amount
1091     mapping(address => bool) public automatedMarketMakerPairs;
1092 
1093     event UpdateUniswapV2Router(
1094         address indexed newAddress,
1095         address indexed oldAddress
1096     );
1097 
1098     event ExcludeFromFees(address indexed account, bool isExcluded);
1099 
1100     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1101 
1102     event marketingWalletUpdated(
1103         address indexed newWallet,
1104         address indexed oldWallet
1105     );
1106 
1107     event devWalletUpdated(
1108         address indexed newWallet,
1109         address indexed oldWallet
1110     );
1111 
1112     event SwapAndLiquify(
1113         uint256 tokensSwapped,
1114         uint256 ethReceived,
1115         uint256 tokensIntoLiquidity
1116     );
1117 
1118     event AutoNukeLP();
1119 
1120     event ManualNukeLP();
1121 
1122     constructor() ERC20("Treat", "TREAT") {
1123         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1124             0x03f7724180AA6b939894B5Ca4314783B0b36b329
1125         );
1126 
1127         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1128         uniswapV2Router = _uniswapV2Router;
1129 
1130         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1131             .createPair(address(this), _uniswapV2Router.WETH());
1132         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1133         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1134 
1135         uint256 _buyMarketingFee = 0;
1136         uint256 _buyLiquidityFee = 0;
1137         uint256 _buyDevFee = 20;
1138 
1139         uint256 _sellMarketingFee = 0;
1140         uint256 _sellLiquidityFee = 0;
1141         uint256 _sellDevFee = 30;
1142 
1143         uint256 totalSupply = 3_333_333_333 * 1e18;
1144 
1145         maxTransactionAmount = 33_333_333 * 1e18; 
1146         maxWallet = 33_333_333 * 1e18; // 
1147 
1148         buyMarketingFee = _buyMarketingFee;
1149         buyLiquidityFee = _buyLiquidityFee;
1150         buyDevFee = _buyDevFee;
1151         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1152 
1153         sellMarketingFee = _sellMarketingFee;
1154         sellLiquidityFee = _sellLiquidityFee;
1155         sellDevFee = _sellDevFee;
1156         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1157 
1158         marketingWallet = address(0x30391dD1076A47B6d39bD6FcD7359583Fc8c3eaC); // set as marketing wallet
1159         devWallet = address(0x30391dD1076A47B6d39bD6FcD7359583Fc8c3eaC); // set as dev wallet
1160 
1161         // exclude from paying fees or having max transaction amount
1162         excludeFromFees(owner(), true);
1163         excludeFromFees(address(this), true);
1164         excludeFromFees(address(0xdead), true);
1165 
1166         excludeFromMaxTransaction(owner(), true);
1167         excludeFromMaxTransaction(address(this), true);
1168         excludeFromMaxTransaction(address(0xdead), true);
1169 
1170         /*
1171             _mint is an internal function in ERC20.sol that is only called here,
1172             and CANNOT be called ever again
1173         */
1174         _mint(msg.sender, totalSupply);
1175     }
1176 
1177     receive() external payable {}
1178 
1179     // once enabled, can never be turned off
1180     function enableTrading() external onlyOwner {
1181         tradingActive = true;
1182         swapEnabled = true;
1183         lastLpBurnTime = block.timestamp;
1184     }
1185 
1186     // remove limits after token is stable
1187     function removeLimits() external onlyOwner returns (bool) {
1188         limitsInEffect = false;
1189         return true;
1190     }
1191 
1192     // disable Transfer delay - cannot be reenabled
1193     function disableTransferDelay() external onlyOwner returns (bool) {
1194         transferDelayEnabled = false;
1195         return true;
1196     }
1197 
1198     // change the minimum amount of tokens to sell from fees
1199     function updateSwapTokensAtAmount(uint256 newAmount)
1200         external
1201         onlyOwner
1202         returns (bool)
1203     {
1204         require(
1205             newAmount >= (totalSupply() * 1) / 100000,
1206             "Swap amount cannot be lower than 0.001% total supply."
1207         );
1208         require(
1209             newAmount <= (totalSupply() * 5) / 1000,
1210             "Swap amount cannot be higher than 0.5% total supply."
1211         );
1212         swapTokensAtAmount = newAmount;
1213         return true;
1214     }
1215 
1216     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1217         require(
1218             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1219             "Cannot set maxTransactionAmount lower than 0.1%"
1220         );
1221         maxTransactionAmount = newNum * (10**18);
1222     }
1223 
1224     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1225         require(
1226             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1227             "Cannot set maxWallet lower than 0.5%"
1228         );
1229         maxWallet = newNum * (10**18);
1230     }
1231 
1232     function excludeFromMaxTransaction(address updAds, bool isEx)
1233         public
1234         onlyOwner
1235     {
1236         _isExcludedMaxTransactionAmount[updAds] = isEx;
1237     }
1238 
1239     // only use to disable contract sales if absolutely necessary (emergency use only)
1240     function updateSwapEnabled(bool enabled) external onlyOwner {
1241         swapEnabled = enabled;
1242     }
1243 
1244     function updateBuyFees(
1245         uint256 _marketingFee,
1246         uint256 _liquidityFee,
1247         uint256 _devFee
1248     ) external onlyOwner {
1249         buyMarketingFee = _marketingFee;
1250         buyLiquidityFee = _liquidityFee;
1251         buyDevFee = _devFee;
1252         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1253         require(buyTotalFees <= 11, "Must keep fees at 11% or less");
1254     }
1255 
1256     function updateSellFees(
1257         uint256 _marketingFee,
1258         uint256 _liquidityFee,
1259         uint256 _devFee
1260     ) external onlyOwner {
1261         sellMarketingFee = _marketingFee;
1262         sellLiquidityFee = _liquidityFee;
1263         sellDevFee = _devFee;
1264         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1265         require(sellTotalFees <= 11, "Must keep fees at 11% or less");
1266     }
1267 
1268     function excludeFromFees(address account, bool excluded) public onlyOwner {
1269         _isExcludedFromFees[account] = excluded;
1270         emit ExcludeFromFees(account, excluded);
1271     }
1272 
1273     function setAutomatedMarketMakerPair(address pair, bool value)
1274         public
1275         onlyOwner
1276     {
1277         require(
1278             pair != uniswapV2Pair,
1279             "The pair cannot be removed from automatedMarketMakerPairs"
1280         );
1281 
1282         _setAutomatedMarketMakerPair(pair, value);
1283     }
1284 
1285     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1286         automatedMarketMakerPairs[pair] = value;
1287 
1288         emit SetAutomatedMarketMakerPair(pair, value);
1289     }
1290 
1291     function updateMarketingWallet(address newMarketingWallet)
1292         external
1293         onlyOwner
1294     {
1295         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1296         marketingWallet = newMarketingWallet;
1297     }
1298 
1299     function updateDevWallet(address newWallet) external onlyOwner {
1300         emit devWalletUpdated(newWallet, devWallet);
1301         devWallet = newWallet;
1302     }
1303 
1304     function isExcludedFromFees(address account) public view returns (bool) {
1305         return _isExcludedFromFees[account];
1306     }
1307 
1308     event BoughtEarly(address indexed sniper);
1309 
1310     function _transfer(
1311         address from,
1312         address to,
1313         uint256 amount
1314     ) internal override {
1315         require(from != address(0), "ERC20: transfer from the zero address");
1316         require(to != address(0), "ERC20: transfer to the zero address");
1317 
1318         if (amount == 0) {
1319             super._transfer(from, to, 0);
1320             return;
1321         }
1322 
1323         if (limitsInEffect) {
1324             if (
1325                 from != owner() &&
1326                 to != owner() &&
1327                 to != address(0) &&
1328                 to != address(0xdead) &&
1329                 !swapping
1330             ) {
1331                 if (!tradingActive) {
1332                     require(
1333                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1334                         "Trading is not active."
1335                     );
1336                 }
1337 
1338                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1339                 if (transferDelayEnabled) {
1340                     if (
1341                         to != owner() &&
1342                         to != address(uniswapV2Router) &&
1343                         to != address(uniswapV2Pair)
1344                     ) {
1345                         require(
1346                             _holderLastTransferTimestamp[tx.origin] <
1347                                 block.number,
1348                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1349                         );
1350                         _holderLastTransferTimestamp[tx.origin] = block.number;
1351                     }
1352                 }
1353 
1354                 //when buy
1355                 if (
1356                     automatedMarketMakerPairs[from] &&
1357                     !_isExcludedMaxTransactionAmount[to]
1358                 ) {
1359                     require(
1360                         amount <= maxTransactionAmount,
1361                         "Buy transfer amount exceeds the maxTransactionAmount."
1362                     );
1363                     require(
1364                         amount + balanceOf(to) <= maxWallet,
1365                         "Max wallet exceeded"
1366                     );
1367                 }
1368                 //when sell
1369                 else if (
1370                     automatedMarketMakerPairs[to] &&
1371                     !_isExcludedMaxTransactionAmount[from]
1372                 ) {
1373                     require(
1374                         amount <= maxTransactionAmount,
1375                         "Sell transfer amount exceeds the maxTransactionAmount."
1376                     );
1377                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1378                     require(
1379                         amount + balanceOf(to) <= maxWallet,
1380                         "Max wallet exceeded"
1381                     );
1382                 }
1383             }
1384         }
1385 
1386         uint256 contractTokenBalance = balanceOf(address(this));
1387 
1388         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1389 
1390         if (
1391             canSwap &&
1392             swapEnabled &&
1393             !swapping &&
1394             !automatedMarketMakerPairs[from] &&
1395             !_isExcludedFromFees[from] &&
1396             !_isExcludedFromFees[to]
1397         ) {
1398             swapping = true;
1399 
1400             swapBack();
1401 
1402             swapping = false;
1403         }
1404 
1405         if (
1406             !swapping &&
1407             automatedMarketMakerPairs[to] &&
1408             lpBurnEnabled &&
1409             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1410             !_isExcludedFromFees[from]
1411         ) {
1412             autoBurnLiquidityPairTokens();
1413         }
1414 
1415         bool takeFee = !swapping;
1416 
1417         // if any account belongs to _isExcludedFromFee account then remove the fee
1418         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1419             takeFee = false;
1420         }
1421 
1422         uint256 fees = 0;
1423         // only take fees on buys/sells, do not take on wallet transfers
1424         if (takeFee) {
1425             // on sell
1426             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1427                 fees = amount.mul(sellTotalFees).div(100);
1428                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1429                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1430                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1431             }
1432             // on buy
1433             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1434                 fees = amount.mul(buyTotalFees).div(100);
1435                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1436                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1437                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1438             }
1439 
1440             if (fees > 0) {
1441                 super._transfer(from, address(this), fees);
1442             }
1443 
1444             amount -= fees;
1445         }
1446 
1447         super._transfer(from, to, amount);
1448     }
1449 
1450     function swapTokensForEth(uint256 tokenAmount) private {
1451         // generate the uniswap pair path of token -> weth
1452         address[] memory path = new address[](2);
1453         path[0] = address(this);
1454         path[1] = uniswapV2Router.WETH();
1455 
1456         _approve(address(this), address(uniswapV2Router), tokenAmount);
1457 
1458         // make the swap
1459         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1460             tokenAmount,
1461             0, // accept any amount of ETH
1462             path,
1463             address(this),
1464             block.timestamp
1465         );
1466     }
1467 
1468     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1469         // approve token transfer to cover all possible scenarios
1470         _approve(address(this), address(uniswapV2Router), tokenAmount);
1471 
1472         // add the liquidity
1473         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1474             address(this),
1475             tokenAmount,
1476             0, // slippage is unavoidable
1477             0, // slippage is unavoidable
1478             deadAddress,
1479             block.timestamp
1480         );
1481     }
1482 
1483     function swapBack() private {
1484         uint256 contractBalance = balanceOf(address(this));
1485         uint256 totalTokensToSwap = tokensForLiquidity +
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
1502         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1503 
1504         uint256 initialETHBalance = address(this).balance;
1505 
1506         swapTokensForEth(amountToSwapForETH);
1507 
1508         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1509 
1510         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1511             totalTokensToSwap
1512         );
1513         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1514 
1515         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1516 
1517         tokensForLiquidity = 0;
1518         tokensForMarketing = 0;
1519         tokensForDev = 0;
1520 
1521         (success, ) = address(devWallet).call{value: ethForDev}("");
1522 
1523         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1524             addLiquidity(liquidityTokens, ethForLiquidity);
1525             emit SwapAndLiquify(
1526                 amountToSwapForETH,
1527                 ethForLiquidity,
1528                 tokensForLiquidity
1529             );
1530         }
1531 
1532         (success, ) = address(marketingWallet).call{
1533             value: address(this).balance
1534         }("");
1535     }
1536 
1537     function setAutoLPBurnSettings(
1538         uint256 _frequencyInSeconds,
1539         uint256 _percent,
1540         bool _Enabled
1541     ) external onlyOwner {
1542         require(
1543             _frequencyInSeconds >= 600,
1544             "cannot set buyback more often than every 10 minutes"
1545         );
1546         require(
1547             _percent <= 1000 && _percent >= 0,
1548             "Must set auto LP burn percent between 0% and 10%"
1549         );
1550         lpBurnFrequency = _frequencyInSeconds;
1551         percentForLPBurn = _percent;
1552         lpBurnEnabled = _Enabled;
1553     }
1554 
1555     function autoBurnLiquidityPairTokens() internal returns (bool) {
1556         lastLpBurnTime = block.timestamp;
1557 
1558         // get balance of liquidity pair
1559         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1560 
1561         // calculate amount to burn
1562         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1563             10000
1564         );
1565 
1566         // pull tokens from pancakePair liquidity and move to dead address permanently
1567         if (amountToBurn > 0) {
1568             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1569         }
1570 
1571         //sync price since this is not in a swap transaction!
1572         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1573         pair.sync();
1574         emit AutoNukeLP();
1575         return true;
1576     }
1577 
1578     function manualBurnLiquidityPairTokens(uint256 percent)
1579         external
1580         onlyOwner
1581         returns (bool)
1582     {
1583         require(
1584             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1585             "Must wait for cooldown to finish"
1586         );
1587         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1588         lastManualLpBurnTime = block.timestamp;
1589 
1590         // get balance of liquidity pair
1591         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1592 
1593         // calculate amount to burn
1594         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1595 
1596         // pull tokens from pancakePair liquidity and move to dead address permanently
1597         if (amountToBurn > 0) {
1598             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1599         }
1600 
1601         //sync price since this is not in a swap transaction!
1602         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1603         pair.sync();
1604         emit ManualNukeLP();
1605         return true;
1606     }
1607 }