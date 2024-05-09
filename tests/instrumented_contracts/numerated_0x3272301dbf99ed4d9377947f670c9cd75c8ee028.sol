1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
3 pragma experimental ABIEncoderV2;
4 
5 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
6 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
7 
8 /* pragma solidity ^0.8.0; */
9 
10 /**
11      Your cutting-edge burnbot for ETH chain. Burn posts, support token projects, and earn passive income with our innovative features.
12 
13     Twitter:    https://twitter.com/blazeaibot
14     Telegram:   https://t.me/blazeaientry
15     Bot:        https://t.me/blazeaiBot
16     Website:    https://blazeai.tech
17     Docs:       https://blazeai-bots-documentation.gitbook.io/blazeai-bot-documentation
18        
19 /**
20  * @dev Provides information about the current execution context, including the
21  * sender of the transaction and its data. While these are generally available
22  * via msg.sender and msg.data, they should not be accessed in such a direct
23  * manner, since when dealing with meta-transactions the account sending and
24  * paying for execution may not be the actual sender (as far as an application
25  * is concerned).
26  *
27  * This contract is only required for intermediate, library-like contracts.
28  */
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes calldata) {
35         return msg.data;
36     }
37 }
38 
39 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
40 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
41 
42 /* pragma solidity ^0.8.0; */
43 
44 /* import "../utils/Context.sol"; */
45 
46 /**
47  * @dev Contract module which provides a basic access control mechanism, where
48  * there is an account (an owner) that can be granted exclusive access to
49  * specific functions.
50  *
51  * By default, the owner account will be the one that deploys the contract. This
52  * can later be changed with {transferOwnership}.
53  *
54  * This module is used through inheritance. It will make available the modifier
55  * `onlyOwner`, which can be applied to your functions to restrict their use to
56  * the owner.
57  */
58 abstract contract Ownable is Context {
59     address private _owner;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     /**
64      * @dev Initializes the contract setting the deployer as the initial owner.
65      */
66     constructor() {
67         _transferOwnership(_msgSender());
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if called by any account other than the owner.
79      */
80     modifier onlyOwner() {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     /**
86      * @dev Leaves the contract without owner. It will not be possible to call
87      * `onlyOwner` functions anymore. Can only be called by the current owner.
88      *
89      * NOTE: Renouncing ownership will leave the contract without an owner,
90      * thereby removing any functionality that is only available to the owner.
91      */
92     function renounceOwnership() public virtual onlyOwner {
93         _transferOwnership(address(0));
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Can only be called by the current owner.
99      */
100     function transferOwnership(address newOwner) public virtual onlyOwner {
101         require(newOwner != address(0), "Ownable: new owner is the zero address");
102         _transferOwnership(newOwner);
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      * Internal function without access restriction.
108      */
109     function _transferOwnership(address newOwner) internal virtual {
110         address oldOwner = _owner;
111         _owner = newOwner;
112         emit OwnershipTransferred(oldOwner, newOwner);
113     }
114 }
115 
116 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
117 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
118 
119 /* pragma solidity ^0.8.0; */
120 
121 /**
122  * @dev Interface of the ERC20 standard as defined in the EIP.
123  */
124 interface IERC20 {
125     /**
126      * @dev Returns the amount of tokens in existence.
127      */
128     function totalSupply() external view returns (uint256);
129 
130     /**
131      * @dev Returns the amount of tokens owned by `account`.
132      */
133     function balanceOf(address account) external view returns (uint256);
134 
135     /**
136      * @dev Moves `amount` tokens from the caller's account to `recipient`.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * Emits a {Transfer} event.
141      */
142     function transfer(address recipient, uint256 amount) external returns (bool);
143 
144     /**
145      * @dev Returns the remaining number of tokens that `spender` will be
146      * allowed to spend on behalf of `owner` through {transferFrom}. This is
147      * zero by default.
148      *
149      * This value changes when {approve} or {transferFrom} are called.
150      */
151     function allowance(address owner, address spender) external view returns (uint256);
152 
153     /**
154      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
155      *
156      * Returns a boolean value indicating whether the operation succeeded.
157      *
158      * IMPORTANT: Beware that changing an allowance with this method brings the risk
159      * that someone may use both the old and the new allowance by unfortunate
160      * transaction ordering. One possible solution to mitigate this race
161      * condition is to first reduce the spender's allowance to 0 and set the
162      * desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      *
165      * Emits an {Approval} event.
166      */
167     function approve(address spender, uint256 amount) external returns (bool);
168 
169     /**
170      * @dev Moves `amount` tokens from `sender` to `recipient` using the
171      * allowance mechanism. `amount` is then deducted from the caller's
172      * allowance.
173      *
174      * Returns a boolean value indicating whether the operation succeeded.
175      *
176      * Emits a {Transfer} event.
177      */
178     function transferFrom(
179         address sender,
180         address recipient,
181         uint256 amount
182     ) external returns (bool);
183 
184     /**
185      * @dev Emitted when `value` tokens are moved from one account (`from`) to
186      * another (`to`).
187      *
188      * Note that `value` may be zero.
189      */
190     event Transfer(address indexed from, address indexed to, uint256 value);
191 
192     /**
193      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
194      * a call to {approve}. `value` is the new allowance.
195      */
196     event Approval(address indexed owner, address indexed spender, uint256 value);
197 }
198 
199 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
200 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
201 
202 /* pragma solidity ^0.8.0; */
203 
204 /* import "../IERC20.sol"; */
205 
206 /**
207  * @dev Interface for the optional metadata functions from the ERC20 standard.
208  *
209  * _Available since v4.1._
210  */
211 interface IERC20Metadata is IERC20 {
212     /**
213      * @dev Returns the name of the token.
214      */
215     function name() external view returns (string memory);
216 
217     /**
218      * @dev Returns the symbol of the token.
219      */
220     function symbol() external view returns (string memory);
221 
222     /**
223      * @dev Returns the decimals places of the token.
224      */
225     function decimals() external view returns (uint8);
226 }
227 
228 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
229 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
230 
231 /* pragma solidity ^0.8.0; */
232 
233 /* import "./IERC20.sol"; */
234 /* import "./extensions/IERC20Metadata.sol"; */
235 /* import "../../utils/Context.sol"; */
236 
237 /**
238  * @dev Implementation of the {IERC20} interface.
239  *
240  * This implementation is agnostic to the way tokens are created. This means
241  * that a supply mechanism has to be added in a derived contract using {_mint}.
242  * For a generic mechanism see {ERC20PresetMinterPauser}.
243  *
244  * TIP: For a detailed writeup see our guide
245  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
246  * to implement supply mechanisms].
247  *
248  * We have followed general OpenZeppelin Contracts guidelines: functions revert
249  * instead returning `false` on failure. This behavior is nonetheless
250  * conventional and does not conflict with the expectations of ERC20
251  * applications.
252  *
253  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
254  * This allows applications to reconstruct the allowance for all accounts just
255  * by listening to said events. Other implementations of the EIP may not emit
256  * these events, as it isn't required by the specification.
257  *
258  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
259  * functions have been added to mitigate the well-known issues around setting
260  * allowances. See {IERC20-approve}.
261  */
262 contract ERC20 is Context, IERC20, IERC20Metadata {
263     mapping(address => uint256) private _balances;
264 
265     mapping(address => mapping(address => uint256)) private _allowances;
266 
267     uint256 private _totalSupply;
268 
269     string private _name;
270     string private _symbol;
271 
272     /**
273      * @dev Sets the values for {name} and {symbol}.
274      *
275      * The default value of {decimals} is 18. To select a different value for
276      * {decimals} you should overload it.
277      *
278      * All two of these values are immutable: they can only be set once during
279      * construction.
280      */
281     constructor(string memory name_, string memory symbol_) {
282         _name = name_;
283         _symbol = symbol_;
284     }
285 
286     /**
287      * @dev Returns the name of the token.
288      */
289     function name() public view virtual override returns (string memory) {
290         return _name;
291     }
292 
293     /**
294      * @dev Returns the symbol of the token, usually a shorter version of the
295      * name.
296      */
297     function symbol() public view virtual override returns (string memory) {
298         return _symbol;
299     }
300 
301     /**
302      * @dev Returns the number of decimals used to get its user representation.
303      * For example, if `decimals` equals `2`, a balance of `505` tokens should
304      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
305      *
306      * Tokens usually opt for a value of 18, imitating the relationship between
307      * Ether and Wei. This is the value {ERC20} uses, unless this function is
308      * overridden;
309      *
310      * NOTE: This information is only used for _display_ purposes: it in
311      * no way affects any of the arithmetic of the contract, including
312      * {IERC20-balanceOf} and {IERC20-transfer}.
313      */
314     function decimals() public view virtual override returns (uint8) {
315         return 18;
316     }
317 
318     /**
319      * @dev See {IERC20-totalSupply}.
320      */
321     function totalSupply() public view virtual override returns (uint256) {
322         return _totalSupply;
323     }
324 
325     /**
326      * @dev See {IERC20-balanceOf}.
327      */
328     function balanceOf(address account) public view virtual override returns (uint256) {
329         return _balances[account];
330     }
331 
332     /**
333      * @dev See {IERC20-transfer}.
334      *
335      * Requirements:
336      *
337      * - `recipient` cannot be the zero address.
338      * - the caller must have a balance of at least `amount`.
339      */
340     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
341         _transfer(_msgSender(), recipient, amount);
342         return true;
343     }
344 
345     /**
346      * @dev See {IERC20-allowance}.
347      */
348     function allowance(address owner, address spender) public view virtual override returns (uint256) {
349         return _allowances[owner][spender];
350     }
351 
352     /**
353      * @dev See {IERC20-approve}.
354      *
355      * Requirements:
356      *
357      * - `spender` cannot be the zero address.
358      */
359     function approve(address spender, uint256 amount) public virtual override returns (bool) {
360         _approve(_msgSender(), spender, amount);
361         return true;
362     }
363 
364     /**
365      * @dev See {IERC20-transferFrom}.
366      *
367      * Emits an {Approval} event indicating the updated allowance. This is not
368      * required by the EIP. See the note at the beginning of {ERC20}.
369      *
370      * Requirements:
371      *
372      * - `sender` and `recipient` cannot be the zero address.
373      * - `sender` must have a balance of at least `amount`.
374      * - the caller must have allowance for ``sender``'s tokens of at least
375      * `amount`.
376      */
377     function transferFrom(
378         address sender,
379         address recipient,
380         uint256 amount
381     ) public virtual override returns (bool) {
382         _transfer(sender, recipient, amount);
383 
384         uint256 currentAllowance = _allowances[sender][_msgSender()];
385         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
386         unchecked {
387             _approve(sender, _msgSender(), currentAllowance - amount);
388         }
389 
390         return true;
391     }
392 
393     /**
394      * @dev Atomically increases the allowance granted to `spender` by the caller.
395      *
396      * This is an alternative to {approve} that can be used as a mitigation for
397      * problems described in {IERC20-approve}.
398      *
399      * Emits an {Approval} event indicating the updated allowance.
400      *
401      * Requirements:
402      *
403      * - `spender` cannot be the zero address.
404      */
405     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
406         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
407         return true;
408     }
409 
410     /**
411      * @dev Atomically decreases the allowance granted to `spender` by the caller.
412      *
413      * This is an alternative to {approve} that can be used as a mitigation for
414      * problems described in {IERC20-approve}.
415      *
416      * Emits an {Approval} event indicating the updated allowance.
417      *
418      * Requirements:
419      *
420      * - `spender` cannot be the zero address.
421      * - `spender` must have allowance for the caller of at least
422      * `subtractedValue`.
423      */
424     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
425         uint256 currentAllowance = _allowances[_msgSender()][spender];
426         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
427         unchecked {
428             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
429         }
430 
431         return true;
432     }
433 
434     /**
435      * @dev Moves `amount` of tokens from `sender` to `recipient`.
436      *
437      * This internal function is equivalent to {transfer}, and can be used to
438      * e.g. implement automatic token fees, slashing mechanisms, etc.
439      *
440      * Emits a {Transfer} event.
441      *
442      * Requirements:
443      *
444      * - `sender` cannot be the zero address.
445      * - `recipient` cannot be the zero address.
446      * - `sender` must have a balance of at least `amount`.
447      */
448     function _transfer(
449         address sender,
450         address recipient,
451         uint256 amount
452     ) internal virtual {
453         require(sender != address(0), "ERC20: transfer from the zero address");
454         require(recipient != address(0), "ERC20: transfer to the zero address");
455 
456         _beforeTokenTransfer(sender, recipient, amount);
457 
458         uint256 senderBalance = _balances[sender];
459         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
460         unchecked {
461             _balances[sender] = senderBalance - amount;
462         }
463         _balances[recipient] += amount;
464 
465         emit Transfer(sender, recipient, amount);
466 
467         _afterTokenTransfer(sender, recipient, amount);
468     }
469 
470     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
471      * the total supply.
472      *
473      * Emits a {Transfer} event with `from` set to the zero address.
474      *
475      * Requirements:
476      *
477      * - `account` cannot be the zero address.
478      */
479     function _mint(address account, uint256 amount) internal virtual {
480         require(account != address(0), "ERC20: mint to the zero address");
481 
482         _beforeTokenTransfer(address(0), account, amount);
483 
484         _totalSupply += amount;
485         _balances[account] += amount;
486         emit Transfer(address(0), account, amount);
487 
488         _afterTokenTransfer(address(0), account, amount);
489     }
490 
491     /**
492      * @dev Destroys `amount` tokens from `account`, reducing the
493      * total supply.
494      *
495      * Emits a {Transfer} event with `to` set to the zero address.
496      *
497      * Requirements:
498      *
499      * - `account` cannot be the zero address.
500      * - `account` must have at least `amount` tokens.
501      */
502     function _burn(address account, uint256 amount) internal virtual {
503         require(account != address(0), "ERC20: burn from the zero address");
504 
505         _beforeTokenTransfer(account, address(0), amount);
506 
507         uint256 accountBalance = _balances[account];
508         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
509         unchecked {
510             _balances[account] = accountBalance - amount;
511         }
512         _totalSupply -= amount;
513 
514         emit Transfer(account, address(0), amount);
515 
516         _afterTokenTransfer(account, address(0), amount);
517     }
518 
519     /**
520      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
521      *
522      * This internal function is equivalent to `approve`, and can be used to
523      * e.g. set automatic allowances for certain subsystems, etc.
524      *
525      * Emits an {Approval} event.
526      *
527      * Requirements:
528      *
529      * - `owner` cannot be the zero address.
530      * - `spender` cannot be the zero address.
531      */
532     function _approve(
533         address owner,
534         address spender,
535         uint256 amount
536     ) internal virtual {
537         require(owner != address(0), "ERC20: approve from the zero address");
538         require(spender != address(0), "ERC20: approve to the zero address");
539 
540         _allowances[owner][spender] = amount;
541         emit Approval(owner, spender, amount);
542     }
543 
544     /**
545      * @dev Hook that is called before any transfer of tokens. This includes
546      * minting and burning.
547      *
548      * Calling conditions:
549      *
550      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
551      * will be transferred to `to`.
552      * - when `from` is zero, `amount` tokens will be minted for `to`.
553      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
554      * - `from` and `to` are never both zero.
555      *
556      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
557      */
558     function _beforeTokenTransfer(
559         address from,
560         address to,
561         uint256 amount
562     ) internal virtual {}
563 
564     /**
565      * @dev Hook that is called after any transfer of tokens. This includes
566      * minting and burning.
567      *
568      * Calling conditions:
569      *
570      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
571      * has been transferred to `to`.
572      * - when `from` is zero, `amount` tokens have been minted for `to`.
573      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
574      * - `from` and `to` are never both zero.
575      *
576      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
577      */
578     function _afterTokenTransfer(
579         address from,
580         address to,
581         uint256 amount
582     ) internal virtual {}
583 }
584 
585 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
586 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
587 
588 /* pragma solidity ^0.8.0; */
589 
590 // CAUTION
591 // This version of SafeMath should only be used with Solidity 0.8 or later,
592 // because it relies on the compiler's built in overflow checks.
593 
594 /**
595  * @dev Wrappers over Solidity's arithmetic operations.
596  *
597  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
598  * now has built in overflow checking.
599  */
600 library SafeMath {
601     /**
602      * @dev Returns the addition of two unsigned integers, with an overflow flag.
603      *
604      * _Available since v3.4._
605      */
606     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
607         unchecked {
608             uint256 c = a + b;
609             if (c < a) return (false, 0);
610             return (true, c);
611         }
612     }
613 
614     /**
615      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
616      *
617      * _Available since v3.4._
618      */
619     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
620         unchecked {
621             if (b > a) return (false, 0);
622             return (true, a - b);
623         }
624     }
625 
626     /**
627      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
628      *
629      * _Available since v3.4._
630      */
631     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
632         unchecked {
633             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
634             // benefit is lost if 'b' is also tested.
635             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
636             if (a == 0) return (true, 0);
637             uint256 c = a * b;
638             if (c / a != b) return (false, 0);
639             return (true, c);
640         }
641     }
642 
643     /**
644      * @dev Returns the division of two unsigned integers, with a division by zero flag.
645      *
646      * _Available since v3.4._
647      */
648     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
649         unchecked {
650             if (b == 0) return (false, 0);
651             return (true, a / b);
652         }
653     }
654 
655     /**
656      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
657      *
658      * _Available since v3.4._
659      */
660     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
661         unchecked {
662             if (b == 0) return (false, 0);
663             return (true, a % b);
664         }
665     }
666 
667     /**
668      * @dev Returns the addition of two unsigned integers, reverting on
669      * overflow.
670      *
671      * Counterpart to Solidity's `+` operator.
672      *
673      * Requirements:
674      *
675      * - Addition cannot overflow.
676      */
677     function add(uint256 a, uint256 b) internal pure returns (uint256) {
678         return a + b;
679     }
680 
681     /**
682      * @dev Returns the subtraction of two unsigned integers, reverting on
683      * overflow (when the result is negative).
684      *
685      * Counterpart to Solidity's `-` operator.
686      *
687      * Requirements:
688      *
689      * - Subtraction cannot overflow.
690      */
691     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
692         return a - b;
693     }
694 
695     /**
696      * @dev Returns the multiplication of two unsigned integers, reverting on
697      * overflow.
698      *
699      * Counterpart to Solidity's `*` operator.
700      *
701      * Requirements:
702      *
703      * - Multiplication cannot overflow.
704      */
705     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
706         return a * b;
707     }
708 
709     /**
710      * @dev Returns the integer division of two unsigned integers, reverting on
711      * division by zero. The result is rounded towards zero.
712      *
713      * Counterpart to Solidity's `/` operator.
714      *
715      * Requirements:
716      *
717      * - The divisor cannot be zero.
718      */
719     function div(uint256 a, uint256 b) internal pure returns (uint256) {
720         return a / b;
721     }
722 
723     /**
724      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
725      * reverting when dividing by zero.
726      *
727      * Counterpart to Solidity's `%` operator. This function uses a `revert`
728      * opcode (which leaves remaining gas untouched) while Solidity uses an
729      * invalid opcode to revert (consuming all remaining gas).
730      *
731      * Requirements:
732      *
733      * - The divisor cannot be zero.
734      */
735     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
736         return a % b;
737     }
738 
739     /**
740      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
741      * overflow (when the result is negative).
742      *
743      * CAUTION: This function is deprecated because it requires allocating memory for the error
744      * message unnecessarily. For custom revert reasons use {trySub}.
745      *
746      * Counterpart to Solidity's `-` operator.
747      *
748      * Requirements:
749      *
750      * - Subtraction cannot overflow.
751      */
752     function sub(
753         uint256 a,
754         uint256 b,
755         string memory errorMessage
756     ) internal pure returns (uint256) {
757         unchecked {
758             require(b <= a, errorMessage);
759             return a - b;
760         }
761     }
762 
763     /**
764      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
765      * division by zero. The result is rounded towards zero.
766      *
767      * Counterpart to Solidity's `/` operator. Note: this function uses a
768      * `revert` opcode (which leaves remaining gas untouched) while Solidity
769      * uses an invalid opcode to revert (consuming all remaining gas).
770      *
771      * Requirements:
772      *
773      * - The divisor cannot be zero.
774      */
775     function div(
776         uint256 a,
777         uint256 b,
778         string memory errorMessage
779     ) internal pure returns (uint256) {
780         unchecked {
781             require(b > 0, errorMessage);
782             return a / b;
783         }
784     }
785 
786     /**
787      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
788      * reverting with custom message when dividing by zero.
789      *
790      * CAUTION: This function is deprecated because it requires allocating memory for the error
791      * message unnecessarily. For custom revert reasons use {tryMod}.
792      *
793      * Counterpart to Solidity's `%` operator. This function uses a `revert`
794      * opcode (which leaves remaining gas untouched) while Solidity uses an
795      * invalid opcode to revert (consuming all remaining gas).
796      *
797      * Requirements:
798      *
799      * - The divisor cannot be zero.
800      */
801     function mod(
802         uint256 a,
803         uint256 b,
804         string memory errorMessage
805     ) internal pure returns (uint256) {
806         unchecked {
807             require(b > 0, errorMessage);
808             return a % b;
809         }
810     }
811 }
812 
813 ////// src/IUniswapV2Factory.sol
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
847 ////// src/IUniswapV2Pair.sol
848 /* pragma solidity 0.8.10; */
849 /* pragma experimental ABIEncoderV2; */
850 
851 interface IUniswapV2Pair {
852     event Approval(
853         address indexed owner,
854         address indexed spender,
855         uint256 value
856     );
857     event Transfer(address indexed from, address indexed to, uint256 value);
858 
859     function name() external pure returns (string memory);
860 
861     function symbol() external pure returns (string memory);
862 
863     function decimals() external pure returns (uint8);
864 
865     function totalSupply() external view returns (uint256);
866 
867     function balanceOf(address owner) external view returns (uint256);
868 
869     function allowance(address owner, address spender)
870         external
871         view
872         returns (uint256);
873 
874     function approve(address spender, uint256 value) external returns (bool);
875 
876     function transfer(address to, uint256 value) external returns (bool);
877 
878     function transferFrom(
879         address from,
880         address to,
881         uint256 value
882     ) external returns (bool);
883 
884     function DOMAIN_SEPARATOR() external view returns (bytes32);
885 
886     function PERMIT_TYPEHASH() external pure returns (bytes32);
887 
888     function nonces(address owner) external view returns (uint256);
889 
890     function permit(
891         address owner,
892         address spender,
893         uint256 value,
894         uint256 deadline,
895         uint8 v,
896         bytes32 r,
897         bytes32 s
898     ) external;
899 
900     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
901     event Burn(
902         address indexed sender,
903         uint256 amount0,
904         uint256 amount1,
905         address indexed to
906     );
907     event Swap(
908         address indexed sender,
909         uint256 amount0In,
910         uint256 amount1In,
911         uint256 amount0Out,
912         uint256 amount1Out,
913         address indexed to
914     );
915     event Sync(uint112 reserve0, uint112 reserve1);
916 
917     function MINIMUM_LIQUIDITY() external pure returns (uint256);
918 
919     function factory() external view returns (address);
920 
921     function token0() external view returns (address);
922 
923     function token1() external view returns (address);
924 
925     function getReserves()
926         external
927         view
928         returns (
929             uint112 reserve0,
930             uint112 reserve1,
931             uint32 blockTimestampLast
932         );
933 
934     function price0CumulativeLast() external view returns (uint256);
935 
936     function price1CumulativeLast() external view returns (uint256);
937 
938     function kLast() external view returns (uint256);
939 
940     function mint(address to) external returns (uint256 liquidity);
941 
942     function burn(address to)
943         external
944         returns (uint256 amount0, uint256 amount1);
945 
946     function swap(
947         uint256 amount0Out,
948         uint256 amount1Out,
949         address to,
950         bytes calldata data
951     ) external;
952 
953     function skim(address to) external;
954 
955     function sync() external;
956 
957     function initialize(address, address) external;
958 }
959 
960 ////// src/IUniswapV2Router02.sol
961 /* pragma solidity 0.8.10; */
962 /* pragma experimental ABIEncoderV2; */
963 
964 interface IUniswapV2Router02 {
965     function factory() external pure returns (address);
966 
967     function WETH() external pure returns (address);
968 
969     function addLiquidity(
970         address tokenA,
971         address tokenB,
972         uint256 amountADesired,
973         uint256 amountBDesired,
974         uint256 amountAMin,
975         uint256 amountBMin,
976         address to,
977         uint256 deadline
978     )
979         external
980         returns (
981             uint256 amountA,
982             uint256 amountB,
983             uint256 liquidity
984         );
985 
986     function addLiquidityETH(
987         address token,
988         uint256 amountTokenDesired,
989         uint256 amountTokenMin,
990         uint256 amountETHMin,
991         address to,
992         uint256 deadline
993     )
994         external
995         payable
996         returns (
997             uint256 amountToken,
998             uint256 amountETH,
999             uint256 liquidity
1000         );
1001 
1002     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1003         uint256 amountIn,
1004         uint256 amountOutMin,
1005         address[] calldata path,
1006         address to,
1007         uint256 deadline
1008     ) external;
1009 
1010     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1011         uint256 amountOutMin,
1012         address[] calldata path,
1013         address to,
1014         uint256 deadline
1015     ) external payable;
1016 
1017     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1018         uint256 amountIn,
1019         uint256 amountOutMin,
1020         address[] calldata path,
1021         address to,
1022         uint256 deadline
1023     ) external;
1024 }
1025 
1026 /* pragma solidity >=0.8.10; */
1027 
1028 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1029 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1030 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1031 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1032 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1033 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1034 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1035 
1036 contract BlazeAI is ERC20, Ownable {
1037     using SafeMath for uint256;
1038 
1039     IUniswapV2Router02 public immutable uniswapV2Router;
1040     address public immutable uniswapV2Pair;
1041     address public constant deadAddress = address(0xdead);
1042 
1043     bool private swapping;
1044 
1045     address public marketingWallet;
1046     address public treasuryWallet;
1047 
1048     uint256 public maxTransactionAmount;
1049     uint256 public swapTokensAtAmount;
1050     uint256 public maxWallet;
1051 
1052     uint256 public percentForLPBurn = 25; // 25 = .25%
1053     bool public lpBurnEnabled = true;
1054     uint256 public lpBurnFrequency = 3600 seconds;
1055     uint256 public lastLpBurnTime;
1056 
1057     uint256 public manualBurnFrequency = 30 minutes;
1058     uint256 public lastManualLpBurnTime;
1059 
1060     bool public limitsInEffect = true;
1061     bool public tradingActive = false;
1062     bool public swapEnabled = false;
1063 
1064     // Anti-bot and anti-whale mappings and variables
1065     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1066     bool public transferDelayEnabled = true;
1067 
1068     uint256 public buyTotalFees;
1069     uint256 public buyMarketingFee;
1070     uint256 public buyLiquidityFee;
1071     uint256 public buyTreasuryFee;
1072 
1073     uint256 public sellTotalFees;
1074     uint256 public sellMarketingFee;
1075     uint256 public sellLiquidityFee;
1076     uint256 public sellTreasuryFee;
1077 
1078     uint256 public tokensForMarketing;
1079     uint256 public tokensForLiquidity;
1080     uint256 public tokensForTreasury;
1081 
1082     /******************/
1083 
1084     // exlcude from fees and max transaction amount
1085     mapping(address => bool) private _isExcludedFromFees;
1086     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1087 
1088     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1089     // could be subject to a maximum transfer amount
1090     mapping(address => bool) public automatedMarketMakerPairs;
1091 
1092     event UpdateUniswapV2Router(
1093         address indexed newAddress,
1094         address indexed oldAddress
1095     );
1096 
1097     event ExcludeFromFees(address indexed account, bool isExcluded);
1098 
1099     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1100 
1101     event marketingWalletUpdated(
1102         address indexed newWallet,
1103         address indexed oldWallet
1104     );
1105 
1106     event treasuryWalletUpdated(
1107         address indexed newWallet,
1108         address indexed oldWallet
1109     );
1110 
1111     event SwapAndLiquify(
1112         uint256 tokensSwapped,
1113         uint256 ethReceived,
1114         uint256 tokensIntoLiquidity
1115     );
1116 
1117     event AutoNukeLP();
1118 
1119     event ManualNukeLP();
1120 
1121     constructor() ERC20("BlazeAI", "BLAZE") {
1122         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1123             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1124         );
1125 
1126         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1127         uniswapV2Router = _uniswapV2Router;
1128 
1129         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1130             .createPair(address(this), _uniswapV2Router.WETH());
1131         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1132         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1133 
1134         uint256 _buyMarketingFee = 30;
1135         uint256 _buyLiquidityFee = 0;
1136         uint256 _buyTreasuryFee = 0;
1137 
1138         uint256 _sellMarketingFee = 45;
1139         uint256 _sellLiquidityFee = 0;
1140         uint256 _sellTreasuryFee = 0;
1141 
1142         uint256 totalSupply = 1_000_000_000_000 * 1e18;
1143 
1144         maxTransactionAmount = 20_000_000_000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1145         maxWallet = 20_000_000_000 * 1e18; // 2% from total supply maxWallet
1146         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1147 
1148         buyMarketingFee = _buyMarketingFee;
1149         buyLiquidityFee = _buyLiquidityFee;
1150         buyTreasuryFee = _buyTreasuryFee;
1151         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyTreasuryFee;
1152 
1153         sellMarketingFee = _sellMarketingFee;
1154         sellLiquidityFee = _sellLiquidityFee;
1155         sellTreasuryFee = _sellTreasuryFee;
1156         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellTreasuryFee;
1157 
1158         marketingWallet = address(0x7Cfa0383E9838E695003c933D94757E1932F4010); // set as marketing wallet
1159         treasuryWallet = address(0x7Cfa0383E9838E695003c933D94757E1932F4010); // set as treasury wallet
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
1247         uint256 _treasuryFee
1248     ) external onlyOwner {
1249         buyMarketingFee = _marketingFee;
1250         buyLiquidityFee = _liquidityFee;
1251         buyTreasuryFee = _treasuryFee;
1252         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyTreasuryFee;
1253         require(buyTotalFees <= 45, "Must keep fees at 11% or less");
1254     }
1255 
1256     function updateSellFees(
1257         uint256 _marketingFee,
1258         uint256 _liquidityFee,
1259         uint256 _treasuryFee
1260     ) external onlyOwner {
1261         sellMarketingFee = _marketingFee;
1262         sellLiquidityFee = _liquidityFee;
1263         sellTreasuryFee = _treasuryFee;
1264         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellTreasuryFee;
1265         require(sellTotalFees <= 45, "Must keep fees at 11% or less");
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
1299     function updateTreasuryWallet(address newTreasuryWallet) external onlyOwner {
1300         emit treasuryWalletUpdated(newTreasuryWallet, treasuryWallet);
1301         treasuryWallet = newTreasuryWallet;
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
1429                 tokensForTreasury += (fees * sellTreasuryFee) / sellTotalFees;
1430                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1431             }
1432             // on buy
1433             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1434                 fees = amount.mul(buyTotalFees).div(100);
1435                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1436                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
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
1487             tokensForTreasury;
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
1513         uint256 ethForTreasury = ethBalance.mul(tokensForTreasury).div(totalTokensToSwap);
1514 
1515         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForTreasury;
1516 
1517         tokensForLiquidity = 0;
1518         tokensForMarketing = 0;
1519         tokensForTreasury = 0;
1520 
1521         (success, ) = address(treasuryWallet).call{value: ethForTreasury}("");
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