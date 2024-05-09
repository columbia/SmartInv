1 /**
2  *Submitted for verification at Etherscan.io on 2023-01-04
3 */
4 
5 /**
6 
7 twitter: https://twitter.com/CapoERC20
8 
9 telegram: t.me/CapoTokenPortal
10 
11 taxes will be reduced every 10-20 minutes until 4/4 and then eventually lowered to 0/0 and renounced after that
12 
13 */
14 
15 // SPDX-License-Identifier: MIT
16 pragma solidity =0.8.17 >=0.8.10 >=0.8.0 <0.9.0;
17 pragma experimental ABIEncoderV2;
18 
19 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
20 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
21 
22 /* pragma solidity ^0.8.0; */
23 
24 /**
25  * @dev Provides information about the current execution context, including the
26  * sender of the transaction and its data. While these are generally available
27  * via msg.sender and msg.data, they should not be accessed in such a direct
28  * manner, since when dealing with meta-transactions the account sending and
29  * paying for execution may not be the actual sender (as far as an application
30  * is concerned).
31  *
32  * This contract is only required for intermediate, library-like contracts.
33  */
34 abstract contract Context {
35     function _msgSender() internal view virtual returns (address) {
36         return msg.sender;
37     }
38 
39     function _msgData() internal view virtual returns (bytes calldata) {
40         return msg.data;
41     }
42 }
43 
44 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
45 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
46 
47 /* pragma solidity ^0.8.0; */
48 
49 /* import "../utils/Context.sol"; */
50 
51 /**
52  * @dev Contract module which provides a basic access control mechanism, where
53  * there is an account (an owner) that can be granted exclusive access to
54  * specific functions.
55  *
56  * By default, the owner account will be the one that deploys the contract. This
57  * can later be changed with {transferOwnership}.
58  *
59  * This module is used through inheritance. It will make available the modifier
60  * `onlyOwner`, which can be applied to your functions to restrict their use to
61  * the owner.
62  */
63 abstract contract Ownable is Context {
64     address private _owner;
65 
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     /**
69      * @dev Initializes the contract setting the deployer as the initial owner.
70      */
71     constructor() {
72         _transferOwnership(_msgSender());
73     }
74 
75     /**
76      * @dev Returns the address of the current owner.
77      */
78     function owner() public view virtual returns (address) {
79         return _owner;
80     }
81 
82     /**
83      * @dev Throws if called by any account other than the owner.
84      */
85     modifier onlyOwner() {
86         require(owner() == _msgSender(), "Ownable: caller is not the owner");
87         _;
88     }
89 
90     /**
91      * @dev Leaves the contract without owner. It will not be possible to call
92      * `onlyOwner` functions anymore. Can only be called by the current owner.
93      *
94      * NOTE: Renouncing ownership will leave the contract without an owner,
95      * thereby removing any functionality that is only available to the owner.
96      */
97     function renounceOwnership() public virtual onlyOwner {
98         _transferOwnership(address(0));
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Can only be called by the current owner.
104      */
105     function transferOwnership(address newOwner) public virtual onlyOwner {
106         require(newOwner != address(0), "Ownable: new owner is the zero address");
107         _transferOwnership(newOwner);
108     }
109 
110     /**
111      * @dev Transfers ownership of the contract to a new account (`newOwner`).
112      * Internal function without access restriction.
113      */
114     function _transferOwnership(address newOwner) internal virtual {
115         address oldOwner = _owner;
116         _owner = newOwner;
117         emit OwnershipTransferred(oldOwner, newOwner);
118     }
119 }
120 
121 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
122 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
123 
124 /* pragma solidity ^0.8.0; */
125 
126 /**
127  * @dev Interface of the ERC20 standard as defined in the EIP.
128  */
129 interface IERC20 {
130     /**
131      * @dev Returns the amount of tokens in existence.
132      */
133     function totalSupply() external view returns (uint256);
134 
135     /**
136      * @dev Returns the amount of tokens owned by `account`.
137      */
138     function balanceOf(address account) external view returns (uint256);
139 
140     /**
141      * @dev Moves `amount` tokens from the caller's account to `recipient`.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * Emits a {Transfer} event.
146      */
147     function transfer(address recipient, uint256 amount) external returns (bool);
148 
149     /**
150      * @dev Returns the remaining number of tokens that `spender` will be
151      * allowed to spend on behalf of `owner` through {transferFrom}. This is
152      * zero by default.
153      *
154      * This value changes when {approve} or {transferFrom} are called.
155      */
156     function allowance(address owner, address spender) external view returns (uint256);
157 
158     /**
159      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
160      *
161      * Returns a boolean value indicating whether the operation succeeded.
162      *
163      * IMPORTANT: Beware that changing an allowance with this method brings the risk
164      * that someone may use both the old and the new allowance by unfortunate
165      * transaction ordering. One possible solution to mitigate this race
166      * condition is to first reduce the spender's allowance to 0 and set the
167      * desired value afterwards:
168      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169      *
170      * Emits an {Approval} event.
171      */
172     function approve(address spender, uint256 amount) external returns (bool);
173 
174     /**
175      * @dev Moves `amount` tokens from `sender` to `recipient` using the
176      * allowance mechanism. `amount` is then deducted from the caller's
177      * allowance.
178      *
179      * Returns a boolean value indicating whether the operation succeeded.
180      *
181      * Emits a {Transfer} event.
182      */
183     function transferFrom(
184         address sender,
185         address recipient,
186         uint256 amount
187     ) external returns (bool);
188 
189     /**
190      * @dev Emitted when `value` tokens are moved from one account (`from`) to
191      * another (`to`).
192      *
193      * Note that `value` may be zero.
194      */
195     event Transfer(address indexed from, address indexed to, uint256 value);
196 
197     /**
198      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
199      * a call to {approve}. `value` is the new allowance.
200      */
201     event Approval(address indexed owner, address indexed spender, uint256 value);
202 }
203 
204 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
205 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
206 
207 /* pragma solidity ^0.8.0; */
208 
209 /* import "../IERC20.sol"; */
210 
211 /**
212  * @dev Interface for the optional metadata functions from the ERC20 standard.
213  *
214  * _Available since v4.1._
215  */
216 interface IERC20Metadata is IERC20 {
217     /**
218      * @dev Returns the name of the token.
219      */
220     function name() external view returns (string memory);
221 
222     /**
223      * @dev Returns the symbol of the token.
224      */
225     function symbol() external view returns (string memory);
226 
227     /**
228      * @dev Returns the decimals places of the token.
229      */
230     function decimals() external view returns (uint8);
231 }
232 
233 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
234 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
235 
236 /* pragma solidity ^0.8.0; */
237 
238 /* import "./IERC20.sol"; */
239 /* import "./extensions/IERC20Metadata.sol"; */
240 /* import "../../utils/Context.sol"; */
241 
242 /**
243  * @dev Implementation of the {IERC20} interface.
244  *
245  * This implementation is agnostic to the way tokens are created. This means
246  * that a supply mechanism has to be added in a derived contract using {_mint}.
247  * For a generic mechanism see {ERC20PresetMinterPauser}.
248  *
249  * TIP: For a detailed writeup see our guide
250  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
251  * to implement supply mechanisms].
252  *
253  * We have followed general OpenZeppelin Contracts guidelines: functions revert
254  * instead returning `false` on failure. This behavior is nonetheless
255  * conventional and does not conflict with the expectations of ERC20
256  * applications.
257  *
258  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
259  * This allows applications to reconstruct the allowance for all accounts just
260  * by listening to said events. Other implementations of the EIP may not emit
261  * these events, as it isn't required by the specification.
262  *
263  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
264  * functions have been added to mitigate the well-known issues around setting
265  * allowances. See {IERC20-approve}.
266  */
267 contract ERC20 is Context, IERC20, IERC20Metadata {
268     mapping(address => uint256) private _balances;
269 
270     mapping(address => mapping(address => uint256)) private _allowances;
271 
272     uint256 private _totalSupply;
273 
274     string private _name;
275     string private _symbol;
276 
277     /**
278      * @dev Sets the values for {name} and {symbol}.
279      *
280      * The default value of {decimals} is 18. To select a different value for
281      * {decimals} you should overload it.
282      *
283      * All two of these values are immutable: they can only be set once during
284      * construction.
285      */
286     constructor(string memory name_, string memory symbol_) {
287         _name = name_;
288         _symbol = symbol_;
289     }
290 
291     /**
292      * @dev Returns the name of the token.
293      */
294     function name() public view virtual override returns (string memory) {
295         return _name;
296     }
297 
298     /**
299      * @dev Returns the symbol of the token, usually a shorter version of the
300      * name.
301      */
302     function symbol() public view virtual override returns (string memory) {
303         return _symbol;
304     }
305 
306     /**
307      * @dev Returns the number of decimals used to get its user representation.
308      * For example, if `decimals` equals `2`, a balance of `505` tokens should
309      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
310      *
311      * Tokens usually opt for a value of 18, imitating the relationship between
312      * Ether and Wei. This is the value {ERC20} uses, unless this function is
313      * overridden;
314      *
315      * NOTE: This information is only used for _display_ purposes: it in
316      * no way affects any of the arithmetic of the contract, including
317      * {IERC20-balanceOf} and {IERC20-transfer}.
318      */
319     function decimals() public view virtual override returns (uint8) {
320         return 18;
321     }
322 
323     /**
324      * @dev See {IERC20-totalSupply}.
325      */
326     function totalSupply() public view virtual override returns (uint256) {
327         return _totalSupply;
328     }
329 
330     /**
331      * @dev See {IERC20-balanceOf}.
332      */
333     function balanceOf(address account) public view virtual override returns (uint256) {
334         return _balances[account];
335     }
336 
337     /**
338      * @dev See {IERC20-transfer}.
339      *
340      * Requirements:
341      *
342      * - `recipient` cannot be the zero address.
343      * - the caller must have a balance of at least `amount`.
344      */
345     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
346         _transfer(_msgSender(), recipient, amount);
347         return true;
348     }
349 
350     /**
351      * @dev See {IERC20-allowance}.
352      */
353     function allowance(address owner, address spender) public view virtual override returns (uint256) {
354         return _allowances[owner][spender];
355     }
356 
357     /**
358      * @dev See {IERC20-approve}.
359      *
360      * Requirements:
361      *
362      * - `spender` cannot be the zero address.
363      */
364     function approve(address spender, uint256 amount) public virtual override returns (bool) {
365         _approve(_msgSender(), spender, amount);
366         return true;
367     }
368 
369     /**
370      * @dev See {IERC20-transferFrom}.
371      *
372      * Emits an {Approval} event indicating the updated allowance. This is not
373      * required by the EIP. See the note at the beginning of {ERC20}.
374      *
375      * Requirements:
376      *
377      * - `sender` and `recipient` cannot be the zero address.
378      * - `sender` must have a balance of at least `amount`.
379      * - the caller must have allowance for ``sender``'s tokens of at least
380      * `amount`.
381      */
382     function transferFrom(
383         address sender,
384         address recipient,
385         uint256 amount
386     ) public virtual override returns (bool) {
387         _transfer(sender, recipient, amount);
388 
389         uint256 currentAllowance = _allowances[sender][_msgSender()];
390         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
391         unchecked {
392             _approve(sender, _msgSender(), currentAllowance - amount);
393         }
394 
395         return true;
396     }
397 
398     /**
399      * @dev Atomically increases the allowance granted to `spender` by the caller.
400      *
401      * This is an alternative to {approve} that can be used as a mitigation for
402      * problems described in {IERC20-approve}.
403      *
404      * Emits an {Approval} event indicating the updated allowance.
405      *
406      * Requirements:
407      *
408      * - `spender` cannot be the zero address.
409      */
410     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
411         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
412         return true;
413     }
414 
415     /**
416      * @dev Atomically decreases the allowance granted to `spender` by the caller.
417      *
418      * This is an alternative to {approve} that can be used as a mitigation for
419      * problems described in {IERC20-approve}.
420      *
421      * Emits an {Approval} event indicating the updated allowance.
422      *
423      * Requirements:
424      *
425      * - `spender` cannot be the zero address.
426      * - `spender` must have allowance for the caller of at least
427      * `subtractedValue`.
428      */
429     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
430         uint256 currentAllowance = _allowances[_msgSender()][spender];
431         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
432         unchecked {
433             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
434         }
435 
436         return true;
437     }
438 
439     /**
440      * @dev Moves `amount` of tokens from `sender` to `recipient`.
441      *
442      * This internal function is equivalent to {transfer}, and can be used to
443      * e.g. implement automatic token fees, slashing mechanisms, etc.
444      *
445      * Emits a {Transfer} event.
446      *
447      * Requirements:
448      *
449      * - `sender` cannot be the zero address.
450      * - `recipient` cannot be the zero address.
451      * - `sender` must have a balance of at least `amount`.
452      */
453     function _transfer(
454         address sender,
455         address recipient,
456         uint256 amount
457     ) internal virtual {
458         require(sender != address(0), "ERC20: transfer from the zero address");
459         require(recipient != address(0), "ERC20: transfer to the zero address");
460         
461 
462         _beforeTokenTransfer(sender, recipient, amount);
463 
464         uint256 senderBalance = _balances[sender];
465         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
466         unchecked {
467             _balances[sender] = senderBalance - amount;
468         }
469         _balances[recipient] += amount;
470 
471         emit Transfer(sender, recipient, amount);
472 
473         _afterTokenTransfer(sender, recipient, amount);
474     }
475 
476     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
477      * the total supply.
478      *
479      * Emits a {Transfer} event with `from` set to the zero address.
480      *
481      * Requirements:
482      *
483      * - `account` cannot be the zero address.
484      */
485     function _mint(address account, uint256 amount) internal virtual {
486         require(account != address(0), "ERC20: mint to the zero address");
487 
488         _beforeTokenTransfer(address(0), account, amount);
489 
490         _totalSupply += amount;
491         _balances[account] += amount;
492         emit Transfer(address(0), account, amount);
493 
494         _afterTokenTransfer(address(0), account, amount);
495     }
496 
497     /**
498      * @dev Destroys `amount` tokens from `account`, reducing the
499      * total supply.
500      *
501      * Emits a {Transfer} event with `to` set to the zero address.
502      *
503      * Requirements:
504      *
505      * - `account` cannot be the zero address.
506      * - `account` must have at least `amount` tokens.
507      */
508     function _burn(address account, uint256 amount) internal virtual {
509         require(account != address(0), "ERC20: burn from the zero address");
510 
511         _beforeTokenTransfer(account, address(0), amount);
512 
513         uint256 accountBalance = _balances[account];
514         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
515         unchecked {
516             _balances[account] = accountBalance - amount;
517         }
518         _totalSupply -= amount;
519 
520         emit Transfer(account, address(0), amount);
521 
522         _afterTokenTransfer(account, address(0), amount);
523     }
524 
525     /**
526      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
527      *
528      * This internal function is equivalent to `approve`, and can be used to
529      * e.g. set automatic allowances for certain subsystems, etc.
530      *
531      * Emits an {Approval} event.
532      *
533      * Requirements:
534      *
535      * - `owner` cannot be the zero address.
536      * - `spender` cannot be the zero address.
537      */
538     function _approve(
539         address owner,
540         address spender,
541         uint256 amount
542     ) internal virtual {
543         require(owner != address(0), "ERC20: approve from the zero address");
544         require(spender != address(0), "ERC20: approve to the zero address");
545 
546         _allowances[owner][spender] = amount;
547         emit Approval(owner, spender, amount);
548     }
549 
550     /**
551      * @dev Hook that is called before any transfer of tokens. This includes
552      * minting and burning.
553      *
554      * Calling conditions:
555      *
556      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
557      * will be transferred to `to`.
558      * - when `from` is zero, `amount` tokens will be minted for `to`.
559      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
560      * - `from` and `to` are never both zero.
561      *
562      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
563      */
564     function _beforeTokenTransfer(
565         address from,
566         address to,
567         uint256 amount
568     ) internal virtual {}
569 
570     /**
571      * @dev Hook that is called after any transfer of tokens. This includes
572      * minting and burning.
573      *
574      * Calling conditions:
575      *
576      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
577      * has been transferred to `to`.
578      * - when `from` is zero, `amount` tokens have been minted for `to`.
579      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
580      * - `from` and `to` are never both zero.
581      *
582      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
583      */
584     function _afterTokenTransfer(
585         address from,
586         address to,
587         uint256 amount
588     ) internal virtual {}
589 }
590 
591 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
592 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
593 
594 /* pragma solidity ^0.8.0; */
595 
596 // CAUTION
597 // This version of SafeMath should only be used with Solidity 0.8 or later,
598 // because it relies on the compiler's built in overflow checks.
599 
600 /**
601  * @dev Wrappers over Solidity's arithmetic operations.
602  *
603  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
604  * now has built in overflow checking.
605  */
606 library SafeMath {
607     /**
608      * @dev Returns the addition of two unsigned integers, with an overflow flag.
609      *
610      * _Available since v3.4._
611      */
612     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
613         unchecked {
614             uint256 c = a + b;
615             if (c < a) return (false, 0);
616             return (true, c);
617         }
618     }
619 
620     /**
621      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
622      *
623      * _Available since v3.4._
624      */
625     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
626         unchecked {
627             if (b > a) return (false, 0);
628             return (true, a - b);
629         }
630     }
631 
632     /**
633      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
634      *
635      * _Available since v3.4._
636      */
637     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
638         unchecked {
639             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
640             // benefit is lost if 'b' is also tested.
641             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
642             if (a == 0) return (true, 0);
643             uint256 c = a * b;
644             if (c / a != b) return (false, 0);
645             return (true, c);
646         }
647     }
648 
649     /**
650      * @dev Returns the division of two unsigned integers, with a division by zero flag.
651      *
652      * _Available since v3.4._
653      */
654     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
655         unchecked {
656             if (b == 0) return (false, 0);
657             return (true, a / b);
658         }
659     }
660 
661     /**
662      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
663      *
664      * _Available since v3.4._
665      */
666     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
667         unchecked {
668             if (b == 0) return (false, 0);
669             return (true, a % b);
670         }
671     }
672 
673     /**
674      * @dev Returns the addition of two unsigned integers, reverting on
675      * overflow.
676      *
677      * Counterpart to Solidity's `+` operator.
678      *
679      * Requirements:
680      *
681      * - Addition cannot overflow.
682      */
683     function add(uint256 a, uint256 b) internal pure returns (uint256) {
684         return a + b;
685     }
686 
687     /**
688      * @dev Returns the subtraction of two unsigned integers, reverting on
689      * overflow (when the result is negative).
690      *
691      * Counterpart to Solidity's `-` operator.
692      *
693      * Requirements:
694      *
695      * - Subtraction cannot overflow.
696      */
697     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
698         return a - b;
699     }
700 
701     /**
702      * @dev Returns the multiplication of two unsigned integers, reverting on
703      * overflow.
704      *
705      * Counterpart to Solidity's `*` operator.
706      *
707      * Requirements:
708      *
709      * - Multiplication cannot overflow.
710      */
711     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
712         return a * b;
713     }
714 
715     /**
716      * @dev Returns the integer division of two unsigned integers, reverting on
717      * division by zero. The result is rounded towards zero.
718      *
719      * Counterpart to Solidity's `/` operator.
720      *
721      * Requirements:
722      *
723      * - The divisor cannot be zero.
724      */
725     function div(uint256 a, uint256 b) internal pure returns (uint256) {
726         return a / b;
727     }
728 
729     /**
730      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
731      * reverting when dividing by zero.
732      *
733      * Counterpart to Solidity's `%` operator. This function uses a `revert`
734      * opcode (which leaves remaining gas untouched) while Solidity uses an
735      * invalid opcode to revert (consuming all remaining gas).
736      *
737      * Requirements:
738      *
739      * - The divisor cannot be zero.
740      */
741     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
742         return a % b;
743     }
744 
745     /**
746      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
747      * overflow (when the result is negative).
748      *
749      * CAUTION: This function is deprecated because it requires allocating memory for the error
750      * message unnecessarily. For custom revert reasons use {trySub}.
751      *
752      * Counterpart to Solidity's `-` operator.
753      *
754      * Requirements:
755      *
756      * - Subtraction cannot overflow.
757      */
758     function sub(
759         uint256 a,
760         uint256 b,
761         string memory errorMessage
762     ) internal pure returns (uint256) {
763         unchecked {
764             require(b <= a, errorMessage);
765             return a - b;
766         }
767     }
768 
769     /**
770      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
771      * division by zero. The result is rounded towards zero.
772      *
773      * Counterpart to Solidity's `/` operator. Note: this function uses a
774      * `revert` opcode (which leaves remaining gas untouched) while Solidity
775      * uses an invalid opcode to revert (consuming all remaining gas).
776      *
777      * Requirements:
778      *
779      * - The divisor cannot be zero.
780      */
781     function div(
782         uint256 a,
783         uint256 b,
784         string memory errorMessage
785     ) internal pure returns (uint256) {
786         unchecked {
787             require(b > 0, errorMessage);
788             return a / b;
789         }
790     }
791 
792     /**
793      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
794      * reverting with custom message when dividing by zero.
795      *
796      * CAUTION: This function is deprecated because it requires allocating memory for the error
797      * message unnecessarily. For custom revert reasons use {tryMod}.
798      *
799      * Counterpart to Solidity's `%` operator. This function uses a `revert`
800      * opcode (which leaves remaining gas untouched) while Solidity uses an
801      * invalid opcode to revert (consuming all remaining gas).
802      *
803      * Requirements:
804      *
805      * - The divisor cannot be zero.
806      */
807     function mod(
808         uint256 a,
809         uint256 b,
810         string memory errorMessage
811     ) internal pure returns (uint256) {
812         unchecked {
813             require(b > 0, errorMessage);
814             return a % b;
815         }
816     }
817 }
818 
819 ////// src/IUniswapV2Factory.sol
820 /* pragma solidity 0.8.10; */
821 /* pragma experimental ABIEncoderV2; */
822 
823 interface IUniswapV2Factory {
824     event PairCreated(
825         address indexed token0,
826         address indexed token1,
827         address pair,
828         uint256
829     );
830 
831     function feeTo() external view returns (address);
832 
833     function feeToSetter() external view returns (address);
834 
835     function getPair(address tokenA, address tokenB)
836         external
837         view
838         returns (address pair);
839 
840     function allPairs(uint256) external view returns (address pair);
841 
842     function allPairsLength() external view returns (uint256);
843 
844     function createPair(address tokenA, address tokenB)
845         external
846         returns (address pair);
847 
848     function setFeeTo(address) external;
849 
850     function setFeeToSetter(address) external;
851 }
852 
853 ////// src/IUniswapV2Pair.sol
854 /* pragma solidity 0.8.10; */
855 /* pragma experimental ABIEncoderV2; */
856 
857 interface IUniswapV2Pair {
858     event Approval(
859         address indexed owner,
860         address indexed spender,
861         uint256 value
862     );
863     event Transfer(address indexed from, address indexed to, uint256 value);
864 
865     function name() external pure returns (string memory);
866 
867     function symbol() external pure returns (string memory);
868 
869     function decimals() external pure returns (uint8);
870 
871     function totalSupply() external view returns (uint256);
872 
873     function balanceOf(address owner) external view returns (uint256);
874 
875     function allowance(address owner, address spender)
876         external
877         view
878         returns (uint256);
879 
880     function approve(address spender, uint256 value) external returns (bool);
881 
882     function transfer(address to, uint256 value) external returns (bool);
883 
884     function transferFrom(
885         address from,
886         address to,
887         uint256 value
888     ) external returns (bool);
889 
890     function DOMAIN_SEPARATOR() external view returns (bytes32);
891 
892     function PERMIT_TYPEHASH() external pure returns (bytes32);
893 
894     function nonces(address owner) external view returns (uint256);
895 
896     function permit(
897         address owner,
898         address spender,
899         uint256 value,
900         uint256 deadline,
901         uint8 v,
902         bytes32 r,
903         bytes32 s
904     ) external;
905 
906     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
907     event Burn(
908         address indexed sender,
909         uint256 amount0,
910         uint256 amount1,
911         address indexed to
912     );
913     event Swap(
914         address indexed sender,
915         uint256 amount0In,
916         uint256 amount1In,
917         uint256 amount0Out,
918         uint256 amount1Out,
919         address indexed to
920     );
921     event Sync(uint112 reserve0, uint112 reserve1);
922 
923     function MINIMUM_LIQUIDITY() external pure returns (uint256);
924 
925     function factory() external view returns (address);
926 
927     function token0() external view returns (address);
928 
929     function token1() external view returns (address);
930 
931     function getReserves()
932         external
933         view
934         returns (
935             uint112 reserve0,
936             uint112 reserve1,
937             uint32 blockTimestampLast
938         );
939 
940     function price0CumulativeLast() external view returns (uint256);
941 
942     function price1CumulativeLast() external view returns (uint256);
943 
944     function kLast() external view returns (uint256);
945 
946     function mint(address to) external returns (uint256 liquidity);
947 
948     function burn(address to)
949         external
950         returns (uint256 amount0, uint256 amount1);
951 
952     function swap(
953         uint256 amount0Out,
954         uint256 amount1Out,
955         address to,
956         bytes calldata data
957     ) external;
958 
959     function skim(address to) external;
960 
961     function sync() external;
962 
963     function initialize(address, address) external;
964 }
965 
966 ////// src/IUniswapV2Router02.sol
967 /* pragma solidity 0.8.10; */
968 /* pragma experimental ABIEncoderV2; */
969 
970 interface IUniswapV2Router02 {
971     function factory() external pure returns (address);
972 
973     function WETH() external pure returns (address);
974 
975     function addLiquidity(
976         address tokenA,
977         address tokenB,
978         uint256 amountADesired,
979         uint256 amountBDesired,
980         uint256 amountAMin,
981         uint256 amountBMin,
982         address to,
983         uint256 deadline
984     )
985         external
986         returns (
987             uint256 amountA,
988             uint256 amountB,
989             uint256 liquidity
990         );
991 
992     function addLiquidityETH(
993         address token,
994         uint256 amountTokenDesired,
995         uint256 amountTokenMin,
996         uint256 amountETHMin,
997         address to,
998         uint256 deadline
999     )
1000         external
1001         payable
1002         returns (
1003             uint256 amountToken,
1004             uint256 amountETH,
1005             uint256 liquidity
1006         );
1007 
1008     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1009         uint256 amountIn,
1010         uint256 amountOutMin,
1011         address[] calldata path,
1012         address to,
1013         uint256 deadline
1014     ) external;
1015 
1016     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1017         uint256 amountOutMin,
1018         address[] calldata path,
1019         address to,
1020         uint256 deadline
1021     ) external payable;
1022 
1023     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1024         uint256 amountIn,
1025         uint256 amountOutMin,
1026         address[] calldata path,
1027         address to,
1028         uint256 deadline
1029     ) external;
1030 }
1031 
1032 contract CAPO is ERC20, Ownable {
1033     using SafeMath for uint256;
1034 
1035     IUniswapV2Router02 public immutable uniswapV2Router;
1036     address public immutable uniswapV2Pair;
1037     address public constant deadAddress = address(0xdead);
1038     mapping (address => bool) private _blacklist;
1039 
1040     bool private swapping;
1041 
1042     address public marketingWallet;
1043     address public devWallet;
1044 
1045     uint256 public swapTokensAtAmount;
1046 
1047     bool public limitsInEffect = true;
1048     bool public tradingActive = false;
1049     bool public swapEnabled = false;
1050 
1051     // Anti-bot and anti-whale mappings and variables
1052     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1053     bool public transferDelayEnabled = true;
1054 
1055     uint256 public buyTotalFees;
1056     uint256 public buyMarketingFee;
1057     uint256 public buyLiquidityFee;
1058     uint256 public buyDevFee;
1059 
1060     uint256 public sellTotalFees;
1061     uint256 public sellMarketingFee;
1062     uint256 public sellLiquidityFee;
1063     uint256 public sellDevFee;
1064 
1065     uint256 public tokensForMarketing;
1066     uint256 public tokensForLiquidity;
1067     uint256 public tokensForDev;
1068 
1069     /******************/
1070 
1071     // exlcude from fees and max transaction amount
1072     mapping(address => bool) private _isExcludedFromFees;
1073 
1074     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1075     // could be subject to a maximum transfer amount
1076     mapping(address => bool) public automatedMarketMakerPairs;
1077 
1078     event UpdateUniswapV2Router(
1079         address indexed newAddress,
1080         address indexed oldAddress
1081     );
1082 
1083     event ExcludeFromFees(address indexed account, bool isExcluded);
1084 
1085     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1086 
1087     event marketingWalletUpdated(
1088         address indexed newWallet,
1089         address indexed oldWallet
1090     );
1091 
1092     event devWalletUpdated(
1093         address indexed newWallet,
1094         address indexed oldWallet
1095     );
1096 
1097     event SwapAndLiquify(
1098         uint256 tokensSwapped,
1099         uint256 ethReceived,
1100         uint256 tokensIntoLiquidity
1101     );
1102 
1103     event AutoNukeLP();
1104 
1105     event ManualNukeLP();
1106 
1107     constructor() ERC20("Bears Down Bad", "CAPO") {
1108         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1109             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1110         );
1111 
1112         uniswapV2Router = _uniswapV2Router;
1113 
1114         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1115             .createPair(address(this), _uniswapV2Router.WETH());
1116         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1117 
1118         uint256 _buyMarketingFee = 6;
1119         uint256 _buyLiquidityFee = 6;
1120         uint256 _buyDevFee = 6;
1121 
1122         uint256 _sellMarketingFee = 6;
1123         uint256 _sellLiquidityFee = 6;
1124         uint256 _sellDevFee = 6;
1125 
1126         uint256 totalSupply = 1_000_000_000_000 * 1e18;
1127 
1128         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1129 
1130         buyMarketingFee = _buyMarketingFee;
1131         buyLiquidityFee = _buyLiquidityFee;
1132         buyDevFee = _buyDevFee;
1133         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1134 
1135         sellMarketingFee = _sellMarketingFee;
1136         sellLiquidityFee = _sellLiquidityFee;
1137         sellDevFee = _sellDevFee;
1138         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1139 
1140         marketingWallet = address(0x00447EDF6E93dfaC032961672EDa8fA0F4287A6E); // set as marketing wallet
1141         devWallet = address(0x528B216659f9D05F658d40813DE808d6DB4D530B); // set as dev wallet
1142 
1143         // exclude from paying fees or having max transaction amount
1144         excludeFromFees(owner(), true);
1145         excludeFromFees(address(this), true);
1146         excludeFromFees(address(0xdead), true);
1147 
1148 
1149         /*
1150             _mint is an internal function in ERC20.sol that is only called here,
1151             and CANNOT be called ever again
1152         */
1153         _mint(msg.sender, totalSupply);
1154     }
1155 
1156     receive() external payable {}
1157 
1158     // once enabled, can never be turned off
1159     function enableTrading() external onlyOwner {
1160         tradingActive = true;
1161         swapEnabled = true;
1162     }
1163 
1164     // remove limits after token is stable
1165     function removeLimits() external onlyOwner returns (bool) {
1166         limitsInEffect = false;
1167         return true;
1168     }
1169 
1170     // disable Transfer delay - cannot be reenabled
1171     function disableTransferDelay() external onlyOwner returns (bool) {
1172         transferDelayEnabled = false;
1173         return true;
1174     }
1175 
1176     // change the minimum amount of tokens to sell from fees
1177     function updateSwapTokensAtAmount(uint256 newAmount)
1178         external
1179         onlyOwner
1180         returns (bool)
1181     {
1182         require(
1183             newAmount >= (totalSupply() * 1) / 100000,
1184             "Swap amount cannot be lower than 0.001% total supply."
1185         );
1186         require(
1187             newAmount <= (totalSupply() * 5) / 1000,
1188             "Swap amount cannot be higher than 0.5% total supply."
1189         );
1190         swapTokensAtAmount = newAmount;
1191         return true;
1192     }
1193 
1194 
1195     // only use to disable contract sales if absolutely necessary (emergency use only)
1196     function updateSwapEnabled(bool enabled) external onlyOwner {
1197         swapEnabled = enabled;
1198     }
1199 
1200     function updateBuyFees(
1201         uint256 _marketingFee,
1202         uint256 _liquidityFee,
1203         uint256 _devFee
1204     ) external onlyOwner {
1205         buyMarketingFee = _marketingFee;
1206         buyLiquidityFee = _liquidityFee;
1207         buyDevFee = _devFee;
1208         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1209         require(buyTotalFees <= 11, "Must keep fees at 11% or less");
1210     }
1211 
1212     function updateSellFees(
1213         uint256 _marketingFee,
1214         uint256 _liquidityFee,
1215         uint256 _devFee
1216     ) external onlyOwner {
1217         sellMarketingFee = _marketingFee;
1218         sellLiquidityFee = _liquidityFee;
1219         sellDevFee = _devFee;
1220         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1221         require(sellTotalFees <= 11, "Must keep fees at 11% or less");
1222     }
1223 
1224     function excludeFromFees(address account, bool excluded) public onlyOwner {
1225         _isExcludedFromFees[account] = excluded;
1226         emit ExcludeFromFees(account, excluded);
1227     }
1228 
1229     function setAutomatedMarketMakerPair(address pair, bool value)
1230         public
1231         onlyOwner
1232     {
1233         require(
1234             pair != uniswapV2Pair,
1235             "The pair cannot be removed from automatedMarketMakerPairs"
1236         );
1237 
1238         _setAutomatedMarketMakerPair(pair, value);
1239     }
1240 
1241     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1242         automatedMarketMakerPairs[pair] = value;
1243 
1244         emit SetAutomatedMarketMakerPair(pair, value);
1245     }
1246 
1247     function updateMarketingWallet(address newMarketingWallet)
1248         external
1249         onlyOwner
1250     {
1251         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1252         marketingWallet = newMarketingWallet;
1253     }
1254 
1255     function updateDevWallet(address newWallet) external onlyOwner {
1256         emit devWalletUpdated(newWallet, devWallet);
1257         devWallet = newWallet;
1258     }
1259 
1260     function isExcludedFromFees(address account) public view returns (bool) {
1261         return _isExcludedFromFees[account];
1262     }
1263 
1264     event BoughtEarly(address indexed sniper);
1265 
1266     function _transfer(
1267         address from,
1268         address to,
1269         uint256 amount
1270     ) internal override {
1271         require(from != address(0), "ERC20: transfer from the zero address");
1272         require(to != address(0), "ERC20: transfer to the zero address");
1273         require(!_blacklist[from] && !_blacklist[to], "You are a bot");
1274 
1275         if (amount == 0) {
1276             super._transfer(from, to, 0);
1277             return;
1278         }
1279 
1280         if (limitsInEffect) {
1281             if (
1282                 from != owner() &&
1283                 to != owner() &&
1284                 to != address(0) &&
1285                 to != address(0xdead) &&
1286                 !swapping
1287             ) {
1288                 if (!tradingActive) {
1289                     require(
1290                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1291                         "Trading is not active."
1292                     );
1293                 }
1294 
1295                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1296                 if (transferDelayEnabled) {
1297                     if (
1298                         to != owner() &&
1299                         to != address(uniswapV2Router) &&
1300                         to != address(uniswapV2Pair)
1301                     ) {
1302                         require(
1303                             _holderLastTransferTimestamp[tx.origin] <
1304                                 block.number,
1305                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1306                         );
1307                         _holderLastTransferTimestamp[tx.origin] = block.number;
1308                     }
1309                 }
1310             }
1311         }
1312 
1313         uint256 contractTokenBalance = balanceOf(address(this));
1314 
1315         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1316 
1317         if (
1318             canSwap &&
1319             swapEnabled &&
1320             !swapping &&
1321             !automatedMarketMakerPairs[from] &&
1322             !_isExcludedFromFees[from] &&
1323             !_isExcludedFromFees[to]
1324         ) {
1325             swapping = true;
1326 
1327             swapBack();
1328 
1329             swapping = false;
1330         }
1331 
1332         bool takeFee = !swapping;
1333 
1334         // if any account belongs to _isExcludedFromFee account then remove the fee
1335         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1336             takeFee = false;
1337         }
1338 
1339         uint256 fees = 0;
1340         // only take fees on buys/sells, do not take on wallet transfers
1341         if (takeFee) {
1342             // on sell
1343             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1344                 fees = amount.mul(sellTotalFees).div(100);
1345                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1346                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1347                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1348             }
1349             // on buy
1350             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1351                 fees = amount.mul(buyTotalFees).div(100);
1352                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1353                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1354                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1355             }
1356 
1357             if (fees > 0) {
1358                 super._transfer(from, address(this), fees);
1359             }
1360 
1361             amount -= fees;
1362         }
1363 
1364         super._transfer(from, to, amount);
1365     }
1366 
1367     function addBL(address account, bool isBlacklisted) public onlyOwner {
1368         _blacklist[account] = isBlacklisted;
1369     }
1370  
1371     function multiBL(address[] memory multiblacklist_) public onlyOwner {
1372         for (uint256 i = 0; i < multiblacklist_.length; i++) {
1373             _blacklist[multiblacklist_[i]] = true;
1374         }
1375     }
1376 
1377     function swapTokensForEth(uint256 tokenAmount) private {
1378         // generate the uniswap pair path of token -> weth
1379         address[] memory path = new address[](2);
1380         path[0] = address(this);
1381         path[1] = uniswapV2Router.WETH();
1382 
1383         _approve(address(this), address(uniswapV2Router), tokenAmount);
1384 
1385         // make the swap
1386         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1387             tokenAmount,
1388             0, // accept any amount of ETH
1389             path,
1390             address(this),
1391             block.timestamp
1392         );
1393     }
1394 
1395     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1396         // approve token transfer to cover all possible scenarios
1397         _approve(address(this), address(uniswapV2Router), tokenAmount);
1398 
1399         // add the liquidity
1400         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1401             address(this),
1402             tokenAmount,
1403             0, // slippage is unavoidable
1404             0, // slippage is unavoidable
1405             deadAddress,
1406             block.timestamp
1407         );
1408     }
1409 
1410     function swapBack() private {
1411         uint256 contractBalance = balanceOf(address(this));
1412         uint256 totalTokensToSwap = tokensForLiquidity +
1413             tokensForMarketing +
1414             tokensForDev;
1415         bool success;
1416 
1417         if (contractBalance == 0 || totalTokensToSwap == 0) {
1418             return;
1419         }
1420 
1421         if (contractBalance > swapTokensAtAmount * 20) {
1422             contractBalance = swapTokensAtAmount * 20;
1423         }
1424 
1425         // Halve the amount of liquidity tokens
1426         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1427             totalTokensToSwap /
1428             2;
1429         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1430 
1431         uint256 initialETHBalance = address(this).balance;
1432 
1433         swapTokensForEth(amountToSwapForETH);
1434 
1435         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1436 
1437         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1438             totalTokensToSwap
1439         );
1440         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1441 
1442         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1443 
1444         tokensForLiquidity = 0;
1445         tokensForMarketing = 0;
1446         tokensForDev = 0;
1447 
1448         (success, ) = address(devWallet).call{value: ethForDev}("");
1449 
1450         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1451             addLiquidity(liquidityTokens, ethForLiquidity);
1452             emit SwapAndLiquify(
1453                 amountToSwapForETH,
1454                 ethForLiquidity,
1455                 tokensForLiquidity
1456             );
1457         }
1458 
1459         (success, ) = address(marketingWallet).call{
1460             value: address(this).balance
1461         }("");
1462     }
1463 }