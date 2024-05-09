1 /**
2 https://wallstreetdaddy.vip
3 https://t.me/wallstreetdaddy_portal
4 https://twitter.com/WSD_DADDY_ETH
5 
6 "If you want to be rich, never give up. 
7 People tend to give up. 
8 If you have persistence, you will come out ahead of most people.
9  More importantly, you will learn. When you do something, you might fail. 
10  But that’s not because you’re a failure. It’s because you have not learnt enough. 
11  Do it differently each time. One day, you will do it right.
12   Failure is your friend. "
13 */
14 
15 // SPDX-License-Identifier: MIT
16 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
17 pragma experimental ABIEncoderV2;
18 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
19 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
20 /* pragma solidity ^0.8.0; */
21 /**
22  * @dev Provides information about the current execution context, including the
23  * sender of the transaction and its data. While these are generally available
24  * via msg.sender and msg.data, they should not be accessed in such a direct
25  * manner, since when dealing with meta-transactions the account sending and
26  * paying for execution may not be the actual sender (as far as an application
27  * is concerned).
28  *
29  * This contract is only required for intermediate, library-like contracts.
30  */
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes calldata) {
37         return msg.data;
38     }
39 }
40 
41 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
42 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
43 
44 /* pragma solidity ^0.8.0; */
45 
46 /* import "../utils/Context.sol"; */
47 
48 /**
49  * @dev Contract module which provides a basic access control mechanism, where
50  * there is an account (an owner) that can be granted exclusive access to
51  * specific functions.
52  *
53  * By default, the owner account will be the one that deploys the contract. This
54  * can later be changed with {transferOwnership}.
55  *
56  * This module is used through inheritance. It will make available the modifier
57  * `onlyOwner`, which can be applied to your functions to restrict their use to
58  * the owner.
59  */
60 abstract contract Ownable is Context {
61     address private _owner;
62 
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65     /**
66      * @dev Initializes the contract setting the deployer as the initial owner.
67      */
68     constructor() {
69         _transferOwnership(_msgSender());
70     }
71 
72     /**
73      * @dev Returns the address of the current owner.
74      */
75     function owner() public view virtual returns (address) {
76         return _owner;
77     }
78 
79     /**
80      * @dev Throws if called by any account other than the owner.
81      */
82     modifier onlyOwner() {
83         require(owner() == _msgSender(), "Ownable: caller is not the owner");
84         _;
85     }
86 
87     /**
88      * @dev Leaves the contract without owner. It will not be possible to call
89      * `onlyOwner` functions anymore. Can only be called by the current owner.
90      *
91      * NOTE: Renouncing ownership will leave the contract without an owner,
92      * thereby removing any functionality that is only available to the owner.
93      */
94     function renounceOwnership() public virtual onlyOwner {
95         _transferOwnership(address(0));
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      * Can only be called by the current owner.
101      */
102     function transferOwnership(address newOwner) public virtual onlyOwner {
103         require(newOwner != address(0), "Ownable: new owner is the zero address");
104         _transferOwnership(newOwner);
105     }
106 
107     /**
108      * @dev Transfers ownership of the contract to a new account (`newOwner`).
109      * Internal function without access restriction.
110      */
111     function _transferOwnership(address newOwner) internal virtual {
112         address oldOwner = _owner;
113         _owner = newOwner;
114         emit OwnershipTransferred(oldOwner, newOwner);
115     }
116 }
117 
118 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
119 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
120 
121 /* pragma solidity ^0.8.0; */
122 
123 /**
124  * @dev Interface of the ERC20 standard as defined in the EIP.
125  */
126 interface IERC20 {
127     /**
128      * @dev Returns the amount of tokens in existence.
129      */
130     function totalSupply() external view returns (uint256);
131 
132     /**
133      * @dev Returns the amount of tokens owned by `account`.
134      */
135     function balanceOf(address account) external view returns (uint256);
136 
137     /**
138      * @dev Moves `amount` tokens from the caller's account to `recipient`.
139      *
140      * Returns a boolean value indicating whether the operation succeeded.
141      *
142      * Emits a {Transfer} event.
143      */
144     function transfer(address recipient, uint256 amount) external returns (bool);
145 
146     /**
147      * @dev Returns the remaining number of tokens that `spender` will be
148      * allowed to spend on behalf of `owner` through {transferFrom}. This is
149      * zero by default.
150      *
151      * This value changes when {approve} or {transferFrom} are called.
152      */
153     function allowance(address owner, address spender) external view returns (uint256);
154 
155     /**
156      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
157      *
158      * Returns a boolean value indicating whether the operation succeeded.
159      *
160      * IMPORTANT: Beware that changing an allowance with this method brings the risk
161      * that someone may use both the old and the new allowance by unfortunate
162      * transaction ordering. One possible solution to mitigate this race
163      * condition is to first reduce the spender's allowance to 0 and set the
164      * desired value afterwards:
165      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166      *
167      * Emits an {Approval} event.
168      */
169     function approve(address spender, uint256 amount) external returns (bool);
170 
171     /**
172      * @dev Moves `amount` tokens from `sender` to `recipient` using the
173      * allowance mechanism. `amount` is then deducted from the caller's
174      * allowance.
175      *
176      * Returns a boolean value indicating whether the operation succeeded.
177      *
178      * Emits a {Transfer} event.
179      */
180     function transferFrom(
181         address sender,
182         address recipient,
183         uint256 amount
184     ) external returns (bool);
185 
186     /**
187      * @dev Emitted when `value` tokens are moved from one account (`from`) to
188      * another (`to`).
189      *
190      * Note that `value` may be zero.
191      */
192     event Transfer(address indexed from, address indexed to, uint256 value);
193 
194     /**
195      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
196      * a call to {approve}. `value` is the new allowance.
197      */
198     event Approval(address indexed owner, address indexed spender, uint256 value);
199 }
200 
201 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
202 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
203 
204 /* pragma solidity ^0.8.0; */
205 
206 /* import "../IERC20.sol"; */
207 
208 /**
209  * @dev Interface for the optional metadata functions from the ERC20 standard.
210  *
211  * _Available since v4.1._
212  */
213 interface IERC20Metadata is IERC20 {
214     /**
215      * @dev Returns the name of the token.
216      */
217     function name() external view returns (string memory);
218 
219     /**
220      * @dev Returns the symbol of the token.
221      */
222     function symbol() external view returns (string memory);
223 
224     /**
225      * @dev Returns the decimals places of the token.
226      */
227     function decimals() external view returns (uint8);
228 }
229 
230 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
231 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
232 
233 /* pragma solidity ^0.8.0; */
234 
235 /* import "./IERC20.sol"; */
236 /* import "./extensions/IERC20Metadata.sol"; */
237 /* import "../../utils/Context.sol"; */
238 
239 /**
240  * @dev Implementation of the {IERC20} interface.
241  *
242  * This implementation is agnostic to the way tokens are created. This means
243  * that a supply mechanism has to be added in a derived contract using {_mint}.
244  * For a generic mechanism see {ERC20PresetMinterPauser}.
245  *
246  * TIP: For a detailed writeup see our guide
247  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
248  * to implement supply mechanisms].
249  *
250  * We have followed general OpenZeppelin Contracts guidelines: functions revert
251  * instead returning `false` on failure. This behavior is nonetheless
252  * conventional and does not conflict with the expectations of ERC20
253  * applications.
254  *
255  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
256  * This allows applications to reconstruct the allowance for all accounts just
257  * by listening to said events. Other implementations of the EIP may not emit
258  * these events, as it isn't required by the specification.
259  *
260  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
261  * functions have been added to mitigate the well-known issues around setting
262  * allowances. See {IERC20-approve}.
263  */
264 contract ERC20 is Context, IERC20, IERC20Metadata {
265     mapping(address => uint256) private _balances;
266 
267     mapping(address => mapping(address => uint256)) private _allowances;
268 
269     uint256 private _totalSupply;
270 
271     string private _name;
272     string private _symbol;
273 
274     /**
275      * @dev Sets the values for {name} and {symbol}.
276      *
277      * The default value of {decimals} is 18. To select a different value for
278      * {decimals} you should overload it.
279      *
280      * All two of these values are immutable: they can only be set once during
281      * construction.
282      */
283     constructor(string memory name_, string memory symbol_) {
284         _name = name_;
285         _symbol = symbol_;
286     }
287 
288     /**
289      * @dev Returns the name of the token.
290      */
291     function name() public view virtual override returns (string memory) {
292         return _name;
293     }
294 
295     /**
296      * @dev Returns the symbol of the token, usually a shorter version of the
297      * name.
298      */
299     function symbol() public view virtual override returns (string memory) {
300         return _symbol;
301     }
302 
303     /**
304      * @dev Returns the number of decimals used to get its user representation.
305      * For example, if `decimals` equals `2`, a balance of `505` tokens should
306      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
307      *
308      * Tokens usually opt for a value of 18, imitating the relationship between
309      * Ether and Wei. This is the value {ERC20} uses, unless this function is
310      * overridden;
311      *
312      * NOTE: This information is only used for _display_ purposes: it in
313      * no way affects any of the arithmetic of the contract, including
314      * {IERC20-balanceOf} and {IERC20-transfer}.
315      */
316     function decimals() public view virtual override returns (uint8) {
317         return 18;
318     }
319 
320     /**
321      * @dev See {IERC20-totalSupply}.
322      */
323     function totalSupply() public view virtual override returns (uint256) {
324         return _totalSupply;
325     }
326 
327     /**
328      * @dev See {IERC20-balanceOf}.
329      */
330     function balanceOf(address account) public view virtual override returns (uint256) {
331         return _balances[account];
332     }
333 
334     /**
335      * @dev See {IERC20-transfer}.
336      *
337      * Requirements:
338      *
339      * - `recipient` cannot be the zero address.
340      * - the caller must have a balance of at least `amount`.
341      */
342     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
343         _transfer(_msgSender(), recipient, amount);
344         return true;
345     }
346 
347     /**
348      * @dev See {IERC20-allowance}.
349      */
350     function allowance(address owner, address spender) public view virtual override returns (uint256) {
351         return _allowances[owner][spender];
352     }
353 
354     /**
355      * @dev See {IERC20-approve}.
356      *
357      * Requirements:
358      *
359      * - `spender` cannot be the zero address.
360      */
361     function approve(address spender, uint256 amount) public virtual override returns (bool) {
362         _approve(_msgSender(), spender, amount);
363         return true;
364     }
365 
366     /**
367      * @dev See {IERC20-transferFrom}.
368      *
369      * Emits an {Approval} event indicating the updated allowance. This is not
370      * required by the EIP. See the note at the beginning of {ERC20}.
371      *
372      * Requirements:
373      *
374      * - `sender` and `recipient` cannot be the zero address.
375      * - `sender` must have a balance of at least `amount`.
376      * - the caller must have allowance for ``sender``'s tokens of at least
377      * `amount`.
378      */
379     function transferFrom(
380         address sender,
381         address recipient,
382         uint256 amount
383     ) public virtual override returns (bool) {
384         _transfer(sender, recipient, amount);
385 
386         uint256 currentAllowance = _allowances[sender][_msgSender()];
387         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
388         unchecked {
389             _approve(sender, _msgSender(), currentAllowance - amount);
390         }
391 
392         return true;
393     }
394 
395     /**
396      * @dev Atomically increases the allowance granted to `spender` by the caller.
397      *
398      * This is an alternative to {approve} that can be used as a mitigation for
399      * problems described in {IERC20-approve}.
400      *
401      * Emits an {Approval} event indicating the updated allowance.
402      *
403      * Requirements:
404      *
405      * - `spender` cannot be the zero address.
406      */
407     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
408         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
409         return true;
410     }
411 
412     /**
413      * @dev Atomically decreases the allowance granted to `spender` by the caller.
414      *
415      * This is an alternative to {approve} that can be used as a mitigation for
416      * problems described in {IERC20-approve}.
417      *
418      * Emits an {Approval} event indicating the updated allowance.
419      *
420      * Requirements:
421      *
422      * - `spender` cannot be the zero address.
423      * - `spender` must have allowance for the caller of at least
424      * `subtractedValue`.
425      */
426     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
427         uint256 currentAllowance = _allowances[_msgSender()][spender];
428         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
429         unchecked {
430             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
431         }
432 
433         return true;
434     }
435 
436     /**
437      * @dev Moves `amount` of tokens from `sender` to `recipient`.
438      *
439      * This internal function is equivalent to {transfer}, and can be used to
440      * e.g. implement automatic token fees, slashing mechanisms, etc.
441      *
442      * Emits a {Transfer} event.
443      *
444      * Requirements:
445      *
446      * - `sender` cannot be the zero address.
447      * - `recipient` cannot be the zero address.
448      * - `sender` must have a balance of at least `amount`.
449      */
450     function _transfer(
451         address sender,
452         address recipient,
453         uint256 amount
454     ) internal virtual {
455         require(sender != address(0), "ERC20: transfer from the zero address");
456         require(recipient != address(0), "ERC20: transfer to the zero address");
457 
458         _beforeTokenTransfer(sender, recipient, amount);
459 
460         uint256 senderBalance = _balances[sender];
461         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
462         unchecked {
463             _balances[sender] = senderBalance - amount;
464         }
465         _balances[recipient] += amount;
466 
467         emit Transfer(sender, recipient, amount);
468 
469         _afterTokenTransfer(sender, recipient, amount);
470     }
471 
472     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
473      * the total supply.
474      *
475      * Emits a {Transfer} event with `from` set to the zero address.
476      *
477      * Requirements:
478      *
479      * - `account` cannot be the zero address.
480      */
481     function _mint(address account, uint256 amount) internal virtual {
482         require(account != address(0), "ERC20: mint to the zero address");
483 
484         _beforeTokenTransfer(address(0), account, amount);
485 
486         _totalSupply += amount;
487         _balances[account] += amount;
488         emit Transfer(address(0), account, amount);
489 
490         _afterTokenTransfer(address(0), account, amount);
491     }
492 
493     /**
494      * @dev Destroys `amount` tokens from `account`, reducing the
495      * total supply.
496      *
497      * Emits a {Transfer} event with `to` set to the zero address.
498      *
499      * Requirements:
500      *
501      * - `account` cannot be the zero address.
502      * - `account` must have at least `amount` tokens.
503      */
504     function _burn(address account, uint256 amount) internal virtual {
505         require(account != address(0), "ERC20: burn from the zero address");
506 
507         _beforeTokenTransfer(account, address(0), amount);
508 
509         uint256 accountBalance = _balances[account];
510         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
511         unchecked {
512             _balances[account] = accountBalance - amount;
513         }
514         _totalSupply -= amount;
515 
516         emit Transfer(account, address(0), amount);
517 
518         _afterTokenTransfer(account, address(0), amount);
519     }
520 
521     /**
522      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
523      *
524      * This internal function is equivalent to `approve`, and can be used to
525      * e.g. set automatic allowances for certain subsystems, etc.
526      *
527      * Emits an {Approval} event.
528      *
529      * Requirements:
530      *
531      * - `owner` cannot be the zero address.
532      * - `spender` cannot be the zero address.
533      */
534     function _approve(
535         address owner,
536         address spender,
537         uint256 amount
538     ) internal virtual {
539         require(owner != address(0), "ERC20: approve from the zero address");
540         require(spender != address(0), "ERC20: approve to the zero address");
541 
542         _allowances[owner][spender] = amount;
543         emit Approval(owner, spender, amount);
544     }
545 
546     /**
547      * @dev Hook that is called before any transfer of tokens. This includes
548      * minting and burning.
549      *
550      * Calling conditions:
551      *
552      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
553      * will be transferred to `to`.
554      * - when `from` is zero, `amount` tokens will be minted for `to`.
555      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
556      * - `from` and `to` are never both zero.
557      *
558      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
559      */
560     function _beforeTokenTransfer(
561         address from,
562         address to,
563         uint256 amount
564     ) internal virtual {}
565 
566     /**
567      * @dev Hook that is called after any transfer of tokens. This includes
568      * minting and burning.
569      *
570      * Calling conditions:
571      *
572      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
573      * has been transferred to `to`.
574      * - when `from` is zero, `amount` tokens have been minted for `to`.
575      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
576      * - `from` and `to` are never both zero.
577      *
578      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
579      */
580     function _afterTokenTransfer(
581         address from,
582         address to,
583         uint256 amount
584     ) internal virtual {}
585 }
586 
587 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
588 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
589 
590 /* pragma solidity ^0.8.0; */
591 
592 // CAUTION
593 // This version of SafeMath should only be used with Solidity 0.8 or later,
594 // because it relies on the compiler's built in overflow checks.
595 
596 /**
597  * @dev Wrappers over Solidity's arithmetic operations.
598  *
599  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
600  * now has built in overflow checking.
601  */
602 library SafeMath {
603     /**
604      * @dev Returns the addition of two unsigned integers, with an overflow flag.
605      *
606      * _Available since v3.4._
607      */
608     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
609         unchecked {
610             uint256 c = a + b;
611             if (c < a) return (false, 0);
612             return (true, c);
613         }
614     }
615 
616     /**
617      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
618      *
619      * _Available since v3.4._
620      */
621     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
622         unchecked {
623             if (b > a) return (false, 0);
624             return (true, a - b);
625         }
626     }
627 
628     /**
629      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
630      *
631      * _Available since v3.4._
632      */
633     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
634         unchecked {
635             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
636             // benefit is lost if 'b' is also tested.
637             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
638             if (a == 0) return (true, 0);
639             uint256 c = a * b;
640             if (c / a != b) return (false, 0);
641             return (true, c);
642         }
643     }
644 
645     /**
646      * @dev Returns the division of two unsigned integers, with a division by zero flag.
647      *
648      * _Available since v3.4._
649      */
650     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
651         unchecked {
652             if (b == 0) return (false, 0);
653             return (true, a / b);
654         }
655     }
656 
657     /**
658      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
659      *
660      * _Available since v3.4._
661      */
662     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
663         unchecked {
664             if (b == 0) return (false, 0);
665             return (true, a % b);
666         }
667     }
668 
669     /**
670      * @dev Returns the addition of two unsigned integers, reverting on
671      * overflow.
672      *
673      * Counterpart to Solidity's `+` operator.
674      *
675      * Requirements:
676      *
677      * - Addition cannot overflow.
678      */
679     function add(uint256 a, uint256 b) internal pure returns (uint256) {
680         return a + b;
681     }
682 
683     /**
684      * @dev Returns the subtraction of two unsigned integers, reverting on
685      * overflow (when the result is negative).
686      *
687      * Counterpart to Solidity's `-` operator.
688      *
689      * Requirements:
690      *
691      * - Subtraction cannot overflow.
692      */
693     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
694         return a - b;
695     }
696 
697     /**
698      * @dev Returns the multiplication of two unsigned integers, reverting on
699      * overflow.
700      *
701      * Counterpart to Solidity's `*` operator.
702      *
703      * Requirements:
704      *
705      * - Multiplication cannot overflow.
706      */
707     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
708         return a * b;
709     }
710 
711     /**
712      * @dev Returns the integer division of two unsigned integers, reverting on
713      * division by zero. The result is rounded towards zero.
714      *
715      * Counterpart to Solidity's `/` operator.
716      *
717      * Requirements:
718      *
719      * - The divisor cannot be zero.
720      */
721     function div(uint256 a, uint256 b) internal pure returns (uint256) {
722         return a / b;
723     }
724 
725     /**
726      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
727      * reverting when dividing by zero.
728      *
729      * Counterpart to Solidity's `%` operator. This function uses a `revert`
730      * opcode (which leaves remaining gas untouched) while Solidity uses an
731      * invalid opcode to revert (consuming all remaining gas).
732      *
733      * Requirements:
734      *
735      * - The divisor cannot be zero.
736      */
737     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
738         return a % b;
739     }
740 
741     /**
742      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
743      * overflow (when the result is negative).
744      *
745      * CAUTION: This function is deprecated because it requires allocating memory for the error
746      * message unnecessarily. For custom revert reasons use {trySub}.
747      *
748      * Counterpart to Solidity's `-` operator.
749      *
750      * Requirements:
751      *
752      * - Subtraction cannot overflow.
753      */
754     function sub(
755         uint256 a,
756         uint256 b,
757         string memory errorMessage
758     ) internal pure returns (uint256) {
759         unchecked {
760             require(b <= a, errorMessage);
761             return a - b;
762         }
763     }
764 
765     /**
766      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
767      * division by zero. The result is rounded towards zero.
768      *
769      * Counterpart to Solidity's `/` operator. Note: this function uses a
770      * `revert` opcode (which leaves remaining gas untouched) while Solidity
771      * uses an invalid opcode to revert (consuming all remaining gas).
772      *
773      * Requirements:
774      *
775      * - The divisor cannot be zero.
776      */
777     function div(
778         uint256 a,
779         uint256 b,
780         string memory errorMessage
781     ) internal pure returns (uint256) {
782         unchecked {
783             require(b > 0, errorMessage);
784             return a / b;
785         }
786     }
787 
788     /**
789      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
790      * reverting with custom message when dividing by zero.
791      *
792      * CAUTION: This function is deprecated because it requires allocating memory for the error
793      * message unnecessarily. For custom revert reasons use {tryMod}.
794      *
795      * Counterpart to Solidity's `%` operator. This function uses a `revert`
796      * opcode (which leaves remaining gas untouched) while Solidity uses an
797      * invalid opcode to revert (consuming all remaining gas).
798      *
799      * Requirements:
800      *
801      * - The divisor cannot be zero.
802      */
803     function mod(
804         uint256 a,
805         uint256 b,
806         string memory errorMessage
807     ) internal pure returns (uint256) {
808         unchecked {
809             require(b > 0, errorMessage);
810             return a % b;
811         }
812     }
813 }
814 
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
960 /* pragma solidity 0.8.10; */
961 /* pragma experimental ABIEncoderV2; */
962 
963 interface IUniswapV2Router02 {
964     function factory() external pure returns (address);
965 
966     function WETH() external pure returns (address);
967 
968     function addLiquidity(
969         address tokenA,
970         address tokenB,
971         uint256 amountADesired,
972         uint256 amountBDesired,
973         uint256 amountAMin,
974         uint256 amountBMin,
975         address to,
976         uint256 deadline
977     )
978         external
979         returns (
980             uint256 amountA,
981             uint256 amountB,
982             uint256 liquidity
983         );
984 
985     function addLiquidityETH(
986         address token,
987         uint256 amountTokenDesired,
988         uint256 amountTokenMin,
989         uint256 amountETHMin,
990         address to,
991         uint256 deadline
992     )
993         external
994         payable
995         returns (
996             uint256 amountToken,
997             uint256 amountETH,
998             uint256 liquidity
999         );
1000 
1001     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1002         uint256 amountIn,
1003         uint256 amountOutMin,
1004         address[] calldata path,
1005         address to,
1006         uint256 deadline
1007     ) external;
1008 
1009     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1010         uint256 amountOutMin,
1011         address[] calldata path,
1012         address to,
1013         uint256 deadline
1014     ) external payable;
1015 
1016     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1017         uint256 amountIn,
1018         uint256 amountOutMin,
1019         address[] calldata path,
1020         address to,
1021         uint256 deadline
1022     ) external;
1023 }
1024 
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
1035 contract WALLSTREETDADDY is ERC20, Ownable {
1036     using SafeMath for uint256;
1037 
1038     IUniswapV2Router02 public immutable uniswapV2Router;
1039     address public immutable uniswapV2Pair;
1040     address public constant deadAddress = address(0xdead);
1041 
1042     bool private swapping;
1043 
1044 	address public charityWallet;
1045     address public marketingWallet;
1046     address public devWallet;
1047 
1048     uint256 public maxTransactionAmount;
1049     uint256 public swapTokensAtAmount;
1050     uint256 public maxWallet;
1051 
1052     bool public limitsInEffect = true;
1053     bool public tradingActive = true;
1054     bool public swapEnabled = true;
1055 
1056     // Anti-bot and anti-whale mappings and variables
1057     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1058     bool public transferDelayEnabled = true;
1059 
1060     uint256 public buyTotalFees;
1061 	uint256 public buyCharityFee;
1062     uint256 public buyMarketingFee;
1063     uint256 public buyLiquidityFee;
1064     uint256 public buyDevFee;
1065 
1066     uint256 public sellTotalFees;
1067 	uint256 public sellCharityFee;
1068     uint256 public sellMarketingFee;
1069     uint256 public sellLiquidityFee;
1070     uint256 public sellDevFee;
1071 
1072 	uint256 public tokensForCharity;
1073     uint256 public tokensForMarketing;
1074     uint256 public tokensForLiquidity;
1075     uint256 public tokensForDev;
1076 
1077     /******************/
1078 
1079     // exlcude from fees and max transaction amount
1080     mapping(address => bool) private _isExcludedFromFees;
1081     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1082 
1083     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1084     // could be subject to a maximum transfer amount
1085     mapping(address => bool) public automatedMarketMakerPairs;
1086 
1087     event UpdateUniswapV2Router(
1088         address indexed newAddress,
1089         address indexed oldAddress
1090     );
1091 
1092     event ExcludeFromFees(address indexed account, bool isExcluded);
1093 
1094     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1095 
1096     event SwapAndLiquify(
1097         uint256 tokensSwapped,
1098         uint256 ethReceived,
1099         uint256 tokensIntoLiquidity
1100     );
1101 
1102     constructor() ERC20("Wall Street Daddy", "WSD") {
1103         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1104             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1105         );
1106 
1107         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1108         uniswapV2Router = _uniswapV2Router;
1109 
1110         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1111             .createPair(address(this), _uniswapV2Router.WETH());
1112         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1113         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1114 
1115 		uint256 _buyCharityFee = 0;
1116         uint256 _buyMarketingFee = 10;
1117         uint256 _buyLiquidityFee = 0;
1118         uint256 _buyDevFee = 10;
1119 
1120 		uint256 _sellCharityFee = 0;
1121         uint256 _sellMarketingFee = 10;
1122         uint256 _sellLiquidityFee = 0;
1123         uint256 _sellDevFee = 10;
1124 
1125         uint256 totalSupply = 100000000000000 * 1e18;
1126 
1127         maxTransactionAmount = 1000000000000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1128         maxWallet = 1000000000000 * 1e18; // 2% from total supply maxWallet
1129         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1130 
1131 		buyCharityFee = _buyCharityFee;
1132         buyMarketingFee = _buyMarketingFee;
1133         buyLiquidityFee = _buyLiquidityFee;
1134         buyDevFee = _buyDevFee;
1135         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1136 
1137 		sellCharityFee = _sellCharityFee;
1138         sellMarketingFee = _sellMarketingFee;
1139         sellLiquidityFee = _sellLiquidityFee;
1140         sellDevFee = _sellDevFee;
1141         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1142 
1143 		charityWallet = address(0x443edc3C37da9B721b5C5222e2785c1d9269861a); // set as charity wallet
1144         marketingWallet = address(0x0a9E6aeFF937205C927CFb70A28ff9984ce7B8da); // set as marketing wallet
1145         devWallet = address(0x443edc3C37da9B721b5C5222e2785c1d9269861a); // set as dev wallet
1146 
1147         // exclude from paying fees or having max transaction amount
1148         excludeFromFees(owner(), true);
1149         excludeFromFees(address(this), true);
1150         excludeFromFees(address(0xdead), true);
1151 
1152         excludeFromMaxTransaction(owner(), true);
1153         excludeFromMaxTransaction(address(this), true);
1154         excludeFromMaxTransaction(address(0xdead), true);
1155 
1156         /*
1157             _mint is an internal function in ERC20.sol that is only called here,
1158             and CANNOT be called ever again
1159         */
1160         _mint(msg.sender, totalSupply);
1161     }
1162 
1163     receive() external payable {}
1164 
1165     // once enabled, can never be turned off
1166     function enableTrading() external onlyOwner {
1167         tradingActive = true;
1168         swapEnabled = true;
1169     }
1170 
1171     // remove limits after token is stable
1172     function removeLimits() external onlyOwner returns (bool) {
1173         limitsInEffect = false;
1174         return true;
1175     }
1176 
1177     // disable Transfer delay - cannot be reenabled
1178     function disableTransferDelay() external onlyOwner returns (bool) {
1179         transferDelayEnabled = false;
1180         return true;
1181     }
1182 
1183     // change the minimum amount of tokens to sell from fees
1184     function updateSwapTokensAtAmount(uint256 newAmount)
1185         external
1186         onlyOwner
1187         returns (bool)
1188     {
1189         require(
1190             newAmount >= (totalSupply() * 1) / 100000,
1191             "Swap amount cannot be lower than 0.001% total supply."
1192         );
1193         require(
1194             newAmount <= (totalSupply() * 5) / 1000,
1195             "Swap amount cannot be higher than 0.5% total supply."
1196         );
1197         swapTokensAtAmount = newAmount;
1198         return true;
1199     }
1200 
1201     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1202         require(
1203             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1204             "Cannot set maxTransactionAmount lower than 0.5%"
1205         );
1206         maxTransactionAmount = newNum * (10**18);
1207     }
1208 
1209     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1210         require(
1211             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1212             "Cannot set maxWallet lower than 0.5%"
1213         );
1214         maxWallet = newNum * (10**18);
1215     }
1216 	
1217     function excludeFromMaxTransaction(address updAds, bool isEx)
1218         public
1219         onlyOwner
1220     {
1221         _isExcludedMaxTransactionAmount[updAds] = isEx;
1222     }
1223 
1224     // only use to disable contract sales if absolutely necessary (emergency use only)
1225     function updateSwapEnabled(bool enabled) external onlyOwner {
1226         swapEnabled = enabled;
1227     }
1228 
1229     function updateBuyFees(
1230 		uint256 _charityFee,
1231         uint256 _marketingFee,
1232         uint256 _liquidityFee,
1233         uint256 _devFee
1234     ) external onlyOwner {
1235 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max BuyFee 10%");
1236 		buyCharityFee = _charityFee;
1237         buyMarketingFee = _marketingFee;
1238         buyLiquidityFee = _liquidityFee;
1239         buyDevFee = _devFee;
1240         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1241      }
1242 
1243     function updateSellFees(
1244 		uint256 _charityFee,
1245         uint256 _marketingFee,
1246         uint256 _liquidityFee,
1247         uint256 _devFee
1248     ) external onlyOwner {
1249 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max SellFee 10%");
1250 		sellCharityFee = _charityFee;
1251         sellMarketingFee = _marketingFee;
1252         sellLiquidityFee = _liquidityFee;
1253         sellDevFee = _devFee;
1254         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1255     }
1256 
1257     function excludeFromFees(address account, bool excluded) public onlyOwner {
1258         _isExcludedFromFees[account] = excluded;
1259         emit ExcludeFromFees(account, excluded);
1260     }
1261 
1262     function setAutomatedMarketMakerPair(address pair, bool value)
1263         public
1264         onlyOwner
1265     {
1266         require(
1267             pair != uniswapV2Pair,
1268             "The pair cannot be removed from automatedMarketMakerPairs"
1269         );
1270 
1271         _setAutomatedMarketMakerPair(pair, value);
1272     }
1273 
1274     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1275         automatedMarketMakerPairs[pair] = value;
1276 
1277         emit SetAutomatedMarketMakerPair(pair, value);
1278     }
1279 
1280     function isExcludedFromFees(address account) public view returns (bool) {
1281         return _isExcludedFromFees[account];
1282     }
1283 
1284     function _transfer(
1285         address from,
1286         address to,
1287         uint256 amount
1288     ) internal override {
1289         require(from != address(0), "ERC20: transfer from the zero address");
1290         require(to != address(0), "ERC20: transfer to the zero address");
1291 
1292         if (amount == 0) {
1293             super._transfer(from, to, 0);
1294             return;
1295         }
1296 
1297         if (limitsInEffect) {
1298             if (
1299                 from != owner() &&
1300                 to != owner() &&
1301                 to != address(0) &&
1302                 to != address(0xdead) &&
1303                 !swapping
1304             ) {
1305                 if (!tradingActive) {
1306                     require(
1307                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1308                         "Trading is not active."
1309                     );
1310                 }
1311 
1312                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1313                 if (transferDelayEnabled) {
1314                     if (
1315                         to != owner() &&
1316                         to != address(uniswapV2Router) &&
1317                         to != address(uniswapV2Pair)
1318                     ) {
1319                         require(
1320                             _holderLastTransferTimestamp[tx.origin] <
1321                                 block.number,
1322                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1323                         );
1324                         _holderLastTransferTimestamp[tx.origin] = block.number;
1325                     }
1326                 }
1327 
1328                 //when buy
1329                 if (
1330                     automatedMarketMakerPairs[from] &&
1331                     !_isExcludedMaxTransactionAmount[to]
1332                 ) {
1333                     require(
1334                         amount <= maxTransactionAmount,
1335                         "Buy transfer amount exceeds the maxTransactionAmount."
1336                     );
1337                     require(
1338                         amount + balanceOf(to) <= maxWallet,
1339                         "Max wallet exceeded"
1340                     );
1341                 }
1342                 //when sell
1343                 else if (
1344                     automatedMarketMakerPairs[to] &&
1345                     !_isExcludedMaxTransactionAmount[from]
1346                 ) {
1347                     require(
1348                         amount <= maxTransactionAmount,
1349                         "Sell transfer amount exceeds the maxTransactionAmount."
1350                     );
1351                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1352                     require(
1353                         amount + balanceOf(to) <= maxWallet,
1354                         "Max wallet exceeded"
1355                     );
1356                 }
1357             }
1358         }
1359 
1360         uint256 contractTokenBalance = balanceOf(address(this));
1361 
1362         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1363 
1364         if (
1365             canSwap &&
1366             swapEnabled &&
1367             !swapping &&
1368             !automatedMarketMakerPairs[from] &&
1369             !_isExcludedFromFees[from] &&
1370             !_isExcludedFromFees[to]
1371         ) {
1372             swapping = true;
1373 
1374             swapBack();
1375 
1376             swapping = false;
1377         }
1378 
1379         bool takeFee = !swapping;
1380 
1381         // if any account belongs to _isExcludedFromFee account then remove the fee
1382         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1383             takeFee = false;
1384         }
1385 
1386         uint256 fees = 0;
1387         // only take fees on buys/sells, do not take on wallet transfers
1388         if (takeFee) {
1389             // on sell
1390             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1391                 fees = amount.mul(sellTotalFees).div(100);
1392 				tokensForCharity += (fees * sellCharityFee) / sellTotalFees;
1393                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1394                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1395                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1396             }
1397             // on buy
1398             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1399                 fees = amount.mul(buyTotalFees).div(100);
1400 				tokensForCharity += (fees * buyCharityFee) / buyTotalFees;
1401                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1402                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1403                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1404             }
1405 
1406             if (fees > 0) {
1407                 super._transfer(from, address(this), fees);
1408             }
1409 
1410             amount -= fees;
1411         }
1412 
1413         super._transfer(from, to, amount);
1414     }
1415 
1416     function swapTokensForEth(uint256 tokenAmount) private {
1417         // generate the uniswap pair path of token -> weth
1418         address[] memory path = new address[](2);
1419         path[0] = address(this);
1420         path[1] = uniswapV2Router.WETH();
1421 
1422         _approve(address(this), address(uniswapV2Router), tokenAmount);
1423 
1424         // make the swap
1425         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1426             tokenAmount,
1427             0, // accept any amount of ETH
1428             path,
1429             address(this),
1430             block.timestamp
1431         );
1432     }
1433 
1434     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1435         // approve token transfer to cover all possible scenarios
1436         _approve(address(this), address(uniswapV2Router), tokenAmount);
1437 
1438         // add the liquidity
1439         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1440             address(this),
1441             tokenAmount,
1442             0, // slippage is unavoidable
1443             0, // slippage is unavoidable
1444             devWallet,
1445             block.timestamp
1446         );
1447     }
1448 
1449     function swapBack() private {
1450         uint256 contractBalance = balanceOf(address(this));
1451         uint256 totalTokensToSwap = tokensForCharity + tokensForLiquidity + tokensForMarketing + tokensForDev;
1452         bool success;
1453 
1454         if (contractBalance == 0 || totalTokensToSwap == 0) {
1455             return;
1456         }
1457 
1458         if (contractBalance > swapTokensAtAmount * 20) {
1459             contractBalance = swapTokensAtAmount * 20;
1460         }
1461 
1462         // Halve the amount of liquidity tokens
1463         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1464         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1465 
1466         uint256 initialETHBalance = address(this).balance;
1467 
1468         swapTokensForEth(amountToSwapForETH);
1469 
1470         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1471 
1472 		uint256 ethForCharity = ethBalance.mul(tokensForCharity).div(totalTokensToSwap);
1473         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1474         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1475 
1476         uint256 ethForLiquidity = ethBalance - ethForCharity - ethForMarketing - ethForDev;
1477 
1478         tokensForLiquidity = 0;
1479 		tokensForCharity = 0;
1480         tokensForMarketing = 0;
1481         tokensForDev = 0;
1482 
1483         (success, ) = address(devWallet).call{value: ethForDev}("");
1484         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1485 
1486 
1487         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1488             addLiquidity(liquidityTokens, ethForLiquidity);
1489             emit SwapAndLiquify(
1490                 amountToSwapForETH,
1491                 ethForLiquidity,
1492                 tokensForLiquidity
1493             );
1494         }
1495 
1496         (success, ) = address(charityWallet).call{value: address(this).balance}("");
1497     }
1498 
1499 }