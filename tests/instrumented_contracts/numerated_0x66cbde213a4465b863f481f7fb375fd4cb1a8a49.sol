1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
3 pragma experimental ABIEncoderV2;
4 
5 /** https://t.me/WaterRabbitEntry
6 
7 https://waterrabbiteth.com/
8 
9 https://twitter.com/WRabbitEth
10 
11 https://www.dextools.io/app/en/ether/pair-explorer/0x596d7B33ff5E9Fd331FFd3E93C326a4289aD5979
12 
13 */
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
814 /* pragma solidity 0.8.10; */
815 /* pragma experimental ABIEncoderV2; */
816 
817 interface IUniswapV2Factory {
818     event PairCreated(
819         address indexed token0,
820         address indexed token1,
821         address pair,
822         uint256
823     );
824 
825     function feeTo() external view returns (address);
826 
827     function feeToSetter() external view returns (address);
828 
829     function getPair(address tokenA, address tokenB)
830         external
831         view
832         returns (address pair);
833 
834     function allPairs(uint256) external view returns (address pair);
835 
836     function allPairsLength() external view returns (uint256);
837 
838     function createPair(address tokenA, address tokenB)
839         external
840         returns (address pair);
841 
842     function setFeeTo(address) external;
843 
844     function setFeeToSetter(address) external;
845 }
846 
847 /* pragma solidity 0.8.10; */
848 /* pragma experimental ABIEncoderV2; */
849 
850 interface IUniswapV2Pair {
851     event Approval(
852         address indexed owner,
853         address indexed spender,
854         uint256 value
855     );
856     event Transfer(address indexed from, address indexed to, uint256 value);
857 
858     function name() external pure returns (string memory);
859 
860     function symbol() external pure returns (string memory);
861 
862     function decimals() external pure returns (uint8);
863 
864     function totalSupply() external view returns (uint256);
865 
866     function balanceOf(address owner) external view returns (uint256);
867 
868     function allowance(address owner, address spender)
869         external
870         view
871         returns (uint256);
872 
873     function approve(address spender, uint256 value) external returns (bool);
874 
875     function transfer(address to, uint256 value) external returns (bool);
876 
877     function transferFrom(
878         address from,
879         address to,
880         uint256 value
881     ) external returns (bool);
882 
883     function DOMAIN_SEPARATOR() external view returns (bytes32);
884 
885     function PERMIT_TYPEHASH() external pure returns (bytes32);
886 
887     function nonces(address owner) external view returns (uint256);
888 
889     function permit(
890         address owner,
891         address spender,
892         uint256 value,
893         uint256 deadline,
894         uint8 v,
895         bytes32 r,
896         bytes32 s
897     ) external;
898 
899     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
900     event Burn(
901         address indexed sender,
902         uint256 amount0,
903         uint256 amount1,
904         address indexed to
905     );
906     event Swap(
907         address indexed sender,
908         uint256 amount0In,
909         uint256 amount1In,
910         uint256 amount0Out,
911         uint256 amount1Out,
912         address indexed to
913     );
914     event Sync(uint112 reserve0, uint112 reserve1);
915 
916     function MINIMUM_LIQUIDITY() external pure returns (uint256);
917 
918     function factory() external view returns (address);
919 
920     function token0() external view returns (address);
921 
922     function token1() external view returns (address);
923 
924     function getReserves()
925         external
926         view
927         returns (
928             uint112 reserve0,
929             uint112 reserve1,
930             uint32 blockTimestampLast
931         );
932 
933     function price0CumulativeLast() external view returns (uint256);
934 
935     function price1CumulativeLast() external view returns (uint256);
936 
937     function kLast() external view returns (uint256);
938 
939     function mint(address to) external returns (uint256 liquidity);
940 
941     function burn(address to)
942         external
943         returns (uint256 amount0, uint256 amount1);
944 
945     function swap(
946         uint256 amount0Out,
947         uint256 amount1Out,
948         address to,
949         bytes calldata data
950     ) external;
951 
952     function skim(address to) external;
953 
954     function sync() external;
955 
956     function initialize(address, address) external;
957 }
958 
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
1024 /* pragma solidity >=0.8.10; */
1025 
1026 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1027 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1028 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1029 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1030 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1031 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1032 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1033 
1034 contract WaterRabbit is ERC20, Ownable {
1035     using SafeMath for uint256;
1036 
1037     IUniswapV2Router02 public immutable uniswapV2Router;
1038     address public immutable uniswapV2Pair;
1039     address public constant deadAddress = address(0xdead);
1040 
1041     bool private swapping;
1042 
1043 	address public charityWallet;
1044     address public marketingWallet;
1045     address public devWallet;
1046 
1047     uint256 public maxTransactionAmount;
1048     uint256 public swapTokensAtAmount;
1049     uint256 public maxWallet;
1050 
1051     bool public limitsInEffect = true;
1052     bool public tradingActive = true;
1053     bool public swapEnabled = true;
1054 
1055     // Anti-bot and anti-whale mappings and variables
1056     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1057     bool public transferDelayEnabled = true;
1058 
1059     uint256 public buyTotalFees;
1060 	uint256 public buyCharityFee;
1061     uint256 public buyMarketingFee;
1062     uint256 public buyLiquidityFee;
1063     uint256 public buyDevFee;
1064 
1065     uint256 public sellTotalFees;
1066 	uint256 public sellCharityFee;
1067     uint256 public sellMarketingFee;
1068     uint256 public sellLiquidityFee;
1069     uint256 public sellDevFee;
1070 
1071 	uint256 public tokensForCharity;
1072     uint256 public tokensForMarketing;
1073     uint256 public tokensForLiquidity;
1074     uint256 public tokensForDev;
1075 
1076     /******************/
1077 
1078     // exlcude from fees and max transaction amount
1079     mapping(address => bool) private _isExcludedFromFees;
1080     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1081 
1082     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1083     // could be subject to a maximum transfer amount
1084     mapping(address => bool) public automatedMarketMakerPairs;
1085 
1086     event UpdateUniswapV2Router(
1087         address indexed newAddress,
1088         address indexed oldAddress
1089     );
1090 
1091     event ExcludeFromFees(address indexed account, bool isExcluded);
1092 
1093     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1094 
1095     event SwapAndLiquify(
1096         uint256 tokensSwapped,
1097         uint256 ethReceived,
1098         uint256 tokensIntoLiquidity
1099     );
1100 
1101     constructor() ERC20("Water Rabbit", "Hope") {
1102         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1103             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1104         );
1105 
1106         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1107         uniswapV2Router = _uniswapV2Router;
1108 
1109         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1110             .createPair(address(this), _uniswapV2Router.WETH());
1111         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1112         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1113 
1114 		uint256 _buyCharityFee = 0;
1115         uint256 _buyMarketingFee = 13;
1116         uint256 _buyLiquidityFee = 0;
1117         uint256 _buyDevFee = 7;
1118 
1119 		uint256 _sellCharityFee = 0;
1120         uint256 _sellMarketingFee = 13;
1121         uint256 _sellLiquidityFee = 0;
1122         uint256 _sellDevFee = 7;
1123 
1124         uint256 totalSupply = 1000000000 * 1e18;
1125 
1126         maxTransactionAmount = 5000000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1127         maxWallet = 10000000 * 1e18; // 2% from total supply maxWallet
1128         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1129 
1130 		buyCharityFee = _buyCharityFee;
1131         buyMarketingFee = _buyMarketingFee;
1132         buyLiquidityFee = _buyLiquidityFee;
1133         buyDevFee = _buyDevFee;
1134         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1135 
1136 		sellCharityFee = _sellCharityFee;
1137         sellMarketingFee = _sellMarketingFee;
1138         sellLiquidityFee = _sellLiquidityFee;
1139         sellDevFee = _sellDevFee;
1140         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1141 
1142 		charityWallet = address(0x599271954af7fcAc3F8bac0025032E78e461Ab51); // set as charity wallet
1143         marketingWallet = address(0x599271954af7fcAc3F8bac0025032E78e461Ab51); // set as marketing wallet
1144         devWallet = address(0x53Beb597Ac1EA0dE6b41Fe3767C723A6FfFC4904); // set as dev wallet
1145 
1146         // exclude from paying fees or having max transaction amount
1147         excludeFromFees(owner(), true);
1148         excludeFromFees(address(this), true);
1149         excludeFromFees(address(0xdead), true);
1150 
1151         excludeFromMaxTransaction(owner(), true);
1152         excludeFromMaxTransaction(address(this), true);
1153         excludeFromMaxTransaction(address(0xdead), true);
1154 
1155         /*
1156             _mint is an internal function in ERC20.sol that is only called here,
1157             and CANNOT be called ever again
1158         */
1159         _mint(msg.sender, totalSupply);
1160     }
1161 
1162     receive() external payable {}
1163 
1164     // once enabled, can never be turned off
1165     function enableTrading() external onlyOwner {
1166         tradingActive = true;
1167         swapEnabled = true;
1168     }
1169 
1170     // remove limits after token is stable
1171     function removeLimits() external onlyOwner returns (bool) {
1172         limitsInEffect = false;
1173         return true;
1174     }
1175 
1176     // disable Transfer delay - cannot be reenabled
1177     function disableTransferDelay() external onlyOwner returns (bool) {
1178         transferDelayEnabled = false;
1179         return true;
1180     }
1181 
1182     // change the minimum amount of tokens to sell from fees
1183     function updateSwapTokensAtAmount(uint256 newAmount)
1184         external
1185         onlyOwner
1186         returns (bool)
1187     {
1188         require(
1189             newAmount >= (totalSupply() * 1) / 100000,
1190             "Swap amount cannot be lower than 0.001% total supply."
1191         );
1192         require(
1193             newAmount <= (totalSupply() * 5) / 1000,
1194             "Swap amount cannot be higher than 0.5% total supply."
1195         );
1196         swapTokensAtAmount = newAmount;
1197         return true;
1198     }
1199 
1200     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1201         require(
1202             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1203             "Cannot set maxTransactionAmount lower than 0.5%"
1204         );
1205         maxTransactionAmount = newNum * (10**18);
1206     }
1207 
1208     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1209         require(
1210             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1211             "Cannot set maxWallet lower than 0.5%"
1212         );
1213         maxWallet = newNum * (10**18);
1214     }
1215 	
1216     function excludeFromMaxTransaction(address updAds, bool isEx)
1217         public
1218         onlyOwner
1219     {
1220         _isExcludedMaxTransactionAmount[updAds] = isEx;
1221     }
1222 
1223     // only use to disable contract sales if absolutely necessary (emergency use only)
1224     function updateSwapEnabled(bool enabled) external onlyOwner {
1225         swapEnabled = enabled;
1226     }
1227 
1228     function updateBuyFees(
1229 		uint256 _charityFee,
1230         uint256 _marketingFee,
1231         uint256 _liquidityFee,
1232         uint256 _devFee
1233     ) external onlyOwner {
1234 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max BuyFee 10%");
1235 		buyCharityFee = _charityFee;
1236         buyMarketingFee = _marketingFee;
1237         buyLiquidityFee = _liquidityFee;
1238         buyDevFee = _devFee;
1239         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1240      }
1241 
1242     function updateSellFees(
1243 		uint256 _charityFee,
1244         uint256 _marketingFee,
1245         uint256 _liquidityFee,
1246         uint256 _devFee
1247     ) external onlyOwner {
1248 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max SellFee 10%");
1249 		sellCharityFee = _charityFee;
1250         sellMarketingFee = _marketingFee;
1251         sellLiquidityFee = _liquidityFee;
1252         sellDevFee = _devFee;
1253         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1254     }
1255 
1256     function excludeFromFees(address account, bool excluded) public onlyOwner {
1257         _isExcludedFromFees[account] = excluded;
1258         emit ExcludeFromFees(account, excluded);
1259     }
1260 
1261     function setAutomatedMarketMakerPair(address pair, bool value)
1262         public
1263         onlyOwner
1264     {
1265         require(
1266             pair != uniswapV2Pair,
1267             "The pair cannot be removed from automatedMarketMakerPairs"
1268         );
1269 
1270         _setAutomatedMarketMakerPair(pair, value);
1271     }
1272 
1273     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1274         automatedMarketMakerPairs[pair] = value;
1275 
1276         emit SetAutomatedMarketMakerPair(pair, value);
1277     }
1278 
1279     function isExcludedFromFees(address account) public view returns (bool) {
1280         return _isExcludedFromFees[account];
1281     }
1282 
1283     function _transfer(
1284         address from,
1285         address to,
1286         uint256 amount
1287     ) internal override {
1288         require(from != address(0), "ERC20: transfer from the zero address");
1289         require(to != address(0), "ERC20: transfer to the zero address");
1290 
1291         if (amount == 0) {
1292             super._transfer(from, to, 0);
1293             return;
1294         }
1295 
1296         if (limitsInEffect) {
1297             if (
1298                 from != owner() &&
1299                 to != owner() &&
1300                 to != address(0) &&
1301                 to != address(0xdead) &&
1302                 !swapping
1303             ) {
1304                 if (!tradingActive) {
1305                     require(
1306                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1307                         "Trading is not active."
1308                     );
1309                 }
1310 
1311                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1312                 if (transferDelayEnabled) {
1313                     if (
1314                         to != owner() &&
1315                         to != address(uniswapV2Router) &&
1316                         to != address(uniswapV2Pair)
1317                     ) {
1318                         require(
1319                             _holderLastTransferTimestamp[tx.origin] <
1320                                 block.number,
1321                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1322                         );
1323                         _holderLastTransferTimestamp[tx.origin] = block.number;
1324                     }
1325                 }
1326 
1327                 //when buy
1328                 if (
1329                     automatedMarketMakerPairs[from] &&
1330                     !_isExcludedMaxTransactionAmount[to]
1331                 ) {
1332                     require(
1333                         amount <= maxTransactionAmount,
1334                         "Buy transfer amount exceeds the maxTransactionAmount."
1335                     );
1336                     require(
1337                         amount + balanceOf(to) <= maxWallet,
1338                         "Max wallet exceeded"
1339                     );
1340                 }
1341                 //when sell
1342                 else if (
1343                     automatedMarketMakerPairs[to] &&
1344                     !_isExcludedMaxTransactionAmount[from]
1345                 ) {
1346                     require(
1347                         amount <= maxTransactionAmount,
1348                         "Sell transfer amount exceeds the maxTransactionAmount."
1349                     );
1350                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1351                     require(
1352                         amount + balanceOf(to) <= maxWallet,
1353                         "Max wallet exceeded"
1354                     );
1355                 }
1356             }
1357         }
1358 
1359         uint256 contractTokenBalance = balanceOf(address(this));
1360 
1361         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1362 
1363         if (
1364             canSwap &&
1365             swapEnabled &&
1366             !swapping &&
1367             !automatedMarketMakerPairs[from] &&
1368             !_isExcludedFromFees[from] &&
1369             !_isExcludedFromFees[to]
1370         ) {
1371             swapping = true;
1372 
1373             swapBack();
1374 
1375             swapping = false;
1376         }
1377 
1378         bool takeFee = !swapping;
1379 
1380         // if any account belongs to _isExcludedFromFee account then remove the fee
1381         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1382             takeFee = false;
1383         }
1384 
1385         uint256 fees = 0;
1386         // only take fees on buys/sells, do not take on wallet transfers
1387         if (takeFee) {
1388             // on sell
1389             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1390                 fees = amount.mul(sellTotalFees).div(100);
1391 				tokensForCharity += (fees * sellCharityFee) / sellTotalFees;
1392                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1393                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1394                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1395             }
1396             // on buy
1397             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1398                 fees = amount.mul(buyTotalFees).div(100);
1399 				tokensForCharity += (fees * buyCharityFee) / buyTotalFees;
1400                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1401                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1402                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1403             }
1404 
1405             if (fees > 0) {
1406                 super._transfer(from, address(this), fees);
1407             }
1408 
1409             amount -= fees;
1410         }
1411 
1412         super._transfer(from, to, amount);
1413     }
1414 
1415     function swapTokensForEth(uint256 tokenAmount) private {
1416         // generate the uniswap pair path of token -> weth
1417         address[] memory path = new address[](2);
1418         path[0] = address(this);
1419         path[1] = uniswapV2Router.WETH();
1420 
1421         _approve(address(this), address(uniswapV2Router), tokenAmount);
1422 
1423         // make the swap
1424         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1425             tokenAmount,
1426             0, // accept any amount of ETH
1427             path,
1428             address(this),
1429             block.timestamp
1430         );
1431     }
1432 
1433     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1434         // approve token transfer to cover all possible scenarios
1435         _approve(address(this), address(uniswapV2Router), tokenAmount);
1436 
1437         // add the liquidity
1438         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1439             address(this),
1440             tokenAmount,
1441             0, // slippage is unavoidable
1442             0, // slippage is unavoidable
1443             devWallet,
1444             block.timestamp
1445         );
1446     }
1447 
1448     function swapBack() private {
1449         uint256 contractBalance = balanceOf(address(this));
1450         uint256 totalTokensToSwap = tokensForCharity + tokensForLiquidity + tokensForMarketing + tokensForDev;
1451         bool success;
1452 
1453         if (contractBalance == 0 || totalTokensToSwap == 0) {
1454             return;
1455         }
1456 
1457         if (contractBalance > swapTokensAtAmount * 20) {
1458             contractBalance = swapTokensAtAmount * 20;
1459         }
1460 
1461         // Halve the amount of liquidity tokens
1462         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1463         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1464 
1465         uint256 initialETHBalance = address(this).balance;
1466 
1467         swapTokensForEth(amountToSwapForETH);
1468 
1469         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1470 
1471 		uint256 ethForCharity = ethBalance.mul(tokensForCharity).div(totalTokensToSwap);
1472         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1473         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1474 
1475         uint256 ethForLiquidity = ethBalance - ethForCharity - ethForMarketing - ethForDev;
1476 
1477         tokensForLiquidity = 0;
1478 		tokensForCharity = 0;
1479         tokensForMarketing = 0;
1480         tokensForDev = 0;
1481 
1482         (success, ) = address(devWallet).call{value: ethForDev}("");
1483         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1484 
1485 
1486         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1487             addLiquidity(liquidityTokens, ethForLiquidity);
1488             emit SwapAndLiquify(
1489                 amountToSwapForETH,
1490                 ethForLiquidity,
1491                 tokensForLiquidity
1492             );
1493         }
1494 
1495         (success, ) = address(charityWallet).call{value: address(this).balance}("");
1496     }
1497 
1498 }