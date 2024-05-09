1 // SPDX-License-Identifier: MIT
2 
3 /*
4 Telegram : https://t.me/HPOS4MMI
5 Website: hpos4mmi.com
6 Twitter: twitter.com/hpos4MMi
7 
8 ▕╮╭┻┻╮╭┻┻╮╭▕╮╲
9 ▕╯┃╭╮┃┃╭╮┃╰▕╯╭▏
10 ▕╭┻┻┻┛┗┻┻┛ ╰▏
11 ▕╰━━━┓┈┈┈╭╮▕╭╮▏
12 ▕╭╮╰┳┳┳┳╯╰╯▕╰╯▏
13 ▕╰╯┈┗┛┗┛┈╭╮▕╮┈▏
14 
15 */
16 
17 pragma solidity 0.8.20;
18 pragma experimental ABIEncoderV2;
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
40 /**
41  * @dev Contract module which provides a basic access control mechanism, where
42  * there is an account (an owner) that can be granted exclusive access to
43  * specific functions.
44  *
45  * By default, the owner account will be the one that deploys the contract. This
46  * can later be changed with {transferOwnership}.
47  *
48  * This module is used through inheritance. It will make available the modifier
49  * `onlyOwner`, which can be applied to your functions to restrict their use to
50  * the owner.
51  */
52 abstract contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     /**
58      * @dev Initializes the contract setting the deployer as the initial owner.
59      */
60     constructor() {
61         _transferOwnership(_msgSender());
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view virtual returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(owner() == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public virtual onlyOwner {
87         _transferOwnership(address(0));
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(newOwner != address(0), "Ownable: new owner is the zero address");
96         _transferOwnership(newOwner);
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      * Internal function without access restriction.
102      */
103     function _transferOwnership(address newOwner) internal virtual {
104         address oldOwner = _owner;
105         _owner = newOwner;
106         emit OwnershipTransferred(oldOwner, newOwner);
107     }
108 }
109 
110 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
111 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
112 
113 /* pragma solidity ^0.8.0; */
114 
115 /**
116  * @dev Interface of the ERC20 standard as defined in the EIP.
117  */
118 interface IERC20 {
119     /**
120      * @dev Returns the amount of tokens in existence.
121      */
122     function totalSupply() external view returns (uint256);
123 
124     /**
125      * @dev Returns the amount of tokens owned by `account`.
126      */
127     function balanceOf(address account) external view returns (uint256);
128 
129     /**
130      * @dev Moves `amount` tokens from the caller's account to `recipient`.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transfer(address recipient, uint256 amount) external returns (bool);
137 
138     /**
139      * @dev Returns the remaining number of tokens that `spender` will be
140      * allowed to spend on behalf of `owner` through {transferFrom}. This is
141      * zero by default.
142      *
143      * This value changes when {approve} or {transferFrom} are called.
144      */
145     function allowance(address owner, address spender) external view returns (uint256);
146 
147     /**
148      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * IMPORTANT: Beware that changing an allowance with this method brings the risk
153      * that someone may use both the old and the new allowance by unfortunate
154      * transaction ordering. One possible solution to mitigate this race
155      * condition is to first reduce the spender's allowance to 0 and set the
156      * desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      *
159      * Emits an {Approval} event.
160      */
161     function approve(address spender, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Moves `amount` tokens from `sender` to `recipient` using the
165      * allowance mechanism. `amount` is then deducted from the caller's
166      * allowance.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * Emits a {Transfer} event.
171      */
172     function transferFrom(
173         address sender,
174         address recipient,
175         uint256 amount
176     ) external returns (bool);
177 
178     /**
179      * @dev Emitted when `value` tokens are moved from one account (`from`) to
180      * another (`to`).
181      *
182      * Note that `value` may be zero.
183      */
184     event Transfer(address indexed from, address indexed to, uint256 value);
185 
186     /**
187      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
188      * a call to {approve}. `value` is the new allowance.
189      */
190     event Approval(address indexed owner, address indexed spender, uint256 value);
191 }
192 
193 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
194 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
195 
196 /* pragma solidity ^0.8.0; */
197 
198 /* import "../IERC20.sol"; */
199 
200 /**
201  * @dev Interface for the optional metadata functions from the ERC20 standard.
202  *
203  * _Available since v4.1._
204  */
205 interface IERC20Metadata is IERC20 {
206     /**
207      * @dev Returns the name of the token.
208      */
209     function name() external view returns (string memory);
210 
211     /**
212      * @dev Returns the symbol of the token.
213      */
214     function symbol() external view returns (string memory);
215 
216     /**
217      * @dev Returns the decimals places of the token.
218      */
219     function decimals() external view returns (uint8);
220 }
221 
222 /**
223  * @dev Implementation of the {IERC20} interface.
224  *
225  * This implementation is agnostic to the way tokens are created. This means
226  * that a supply mechanism has to be added in a derived contract using {_mint}.
227  * For a generic mechanism see {ERC20PresetMinterPauser}.
228  *
229  * TIP: For a detailed writeup see our guide
230  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
231  * to implement supply mechanisms].
232  *
233  * We have followed general OpenZeppelin Contracts guidelines: functions revert
234  * instead returning `false` on failure. This behavior is nonetheless
235  * conventional and does not conflict with the expectations of ERC20
236  * applications.
237  *
238  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
239  * This allows applications to reconstruct the allowance for all accounts just
240  * by listening to said events. Other implementations of the EIP may not emit
241  * these events, as it isn't required by the specification.
242  *
243  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
244  * functions have been added to mitigate the well-known issues around setting
245  * allowances. See {IERC20-approve}.
246  */
247 contract ERC20 is Context, IERC20, IERC20Metadata {
248     mapping(address => uint256) private _balances;
249 
250     mapping(address => mapping(address => uint256)) private _allowances;
251 
252     uint256 private _totalSupply;
253 
254     string private _name;
255     string private _symbol;
256 
257     /**
258      * @dev Sets the values for {name} and {symbol}.
259      *
260      * The default value of {decimals} is 18. To select a different value for
261      * {decimals} you should overload it.
262      *
263      * All two of these values are immutable: they can only be set once during
264      * construction.
265      */
266     constructor(string memory name_, string memory symbol_) {
267         _name = name_;
268         _symbol = symbol_;
269     }
270 
271     /**
272      * @dev Returns the name of the token.
273      */
274     function name() public view virtual override returns (string memory) {
275         return _name;
276     }
277 
278     /**
279      * @dev Returns the symbol of the token, usually a shorter version of the
280      * name.
281      */
282     function symbol() public view virtual override returns (string memory) {
283         return _symbol;
284     }
285 
286     /**
287      * @dev Returns the number of decimals used to get its user representation.
288      * For example, if `decimals` equals `2`, a balance of `505` tokens should
289      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
290      *
291      * Tokens usually opt for a value of 18, imitating the relationship between
292      * Ether and Wei. This is the value {ERC20} uses, unless this function is
293      * overridden;
294      *
295      * NOTE: This information is only used for _display_ purposes: it in
296      * no way affects any of the arithmetic of the contract, including
297      * {IERC20-balanceOf} and {IERC20-transfer}.
298      */
299     function decimals() public view virtual override returns (uint8) {
300         return 18;
301     }
302 
303     /**
304      * @dev See {IERC20-totalSupply}.
305      */
306     function totalSupply() public view virtual override returns (uint256) {
307         return _totalSupply;
308     }
309 
310     /**
311      * @dev See {IERC20-balanceOf}.
312      */
313     function balanceOf(address account) public view virtual override returns (uint256) {
314         return _balances[account];
315     }
316 
317     /**
318      * @dev See {IERC20-transfer}.
319      *
320      * Requirements:
321      *
322      * - `recipient` cannot be the zero address.
323      * - the caller must have a balance of at least `amount`.
324      */
325     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
326         _transfer(_msgSender(), recipient, amount);
327         return true;
328     }
329 
330     /**
331      * @dev See {IERC20-allowance}.
332      */
333     function allowance(address owner, address spender) public view virtual override returns (uint256) {
334         return _allowances[owner][spender];
335     }
336 
337     /**
338      * @dev See {IERC20-approve}.
339      *
340      * Requirements:
341      *
342      * - `spender` cannot be the zero address.
343      */
344     function approve(address spender, uint256 amount) public virtual override returns (bool) {
345         _approve(_msgSender(), spender, amount);
346         return true;
347     }
348 
349     /**
350      * @dev See {IERC20-transferFrom}.
351      *
352      * Emits an {Approval} event indicating the updated allowance. This is not
353      * required by the EIP. See the note at the beginning of {ERC20}.
354      *
355      * Requirements:
356      *
357      * - `sender` and `recipient` cannot be the zero address.
358      * - `sender` must have a balance of at least `amount`.
359      * - the caller must have allowance for ``sender``'s tokens of at least
360      * `amount`.
361      */
362     function transferFrom(
363         address sender,
364         address recipient,
365         uint256 amount
366     ) public virtual override returns (bool) {
367         _transfer(sender, recipient, amount);
368 
369         uint256 currentAllowance = _allowances[sender][_msgSender()];
370         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
371         unchecked {
372             _approve(sender, _msgSender(), currentAllowance - amount);
373         }
374 
375         return true;
376     }
377 
378     /**
379      * @dev Atomically increases the allowance granted to `spender` by the caller.
380      *
381      * This is an alternative to {approve} that can be used as a mitigation for
382      * problems described in {IERC20-approve}.
383      *
384      * Emits an {Approval} event indicating the updated allowance.
385      *
386      * Requirements:
387      *
388      * - `spender` cannot be the zero address.
389      */
390     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
391         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
392         return true;
393     }
394 
395     /**
396      * @dev Atomically decreases the allowance granted to `spender` by the caller.
397      *
398      * This is an alternative to {approve} that can be used as a mitigation for
399      * problems described in {IERC20-approve}.
400      *
401      * Emits an {Approval} event indicating the updated allowance.
402      *
403      * Requirements:
404      *
405      * - `spender` cannot be the zero address.
406      * - `spender` must have allowance for the caller of at least
407      * `subtractedValue`.
408      */
409     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
410         uint256 currentAllowance = _allowances[_msgSender()][spender];
411         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
412         unchecked {
413             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
414         }
415 
416         return true;
417     }
418 
419     /**
420      * @dev Moves `amount` of tokens from `sender` to `recipient`.
421      *
422      * This internal function is equivalent to {transfer}, and can be used to
423      * e.g. implement automatic token fees, slashing mechanisms, etc.
424      *
425      * Emits a {Transfer} event.
426      *
427      * Requirements:
428      *
429      * - `sender` cannot be the zero address.
430      * - `recipient` cannot be the zero address.
431      * - `sender` must have a balance of at least `amount`.
432      */
433     function _transfer(
434         address sender,
435         address recipient,
436         uint256 amount
437     ) internal virtual {
438         require(sender != address(0), "ERC20: transfer from the zero address");
439         require(recipient != address(0), "ERC20: transfer to the zero address");
440 
441         _beforeTokenTransfer(sender, recipient, amount);
442 
443         uint256 senderBalance = _balances[sender];
444         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
445         unchecked {
446             _balances[sender] = senderBalance - amount;
447         }
448         _balances[recipient] += amount;
449 
450         emit Transfer(sender, recipient, amount);
451 
452         _afterTokenTransfer(sender, recipient, amount);
453     }
454 
455     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
456      * the total supply.
457      *
458      * Emits a {Transfer} event with `from` set to the zero address.
459      *
460      * Requirements:
461      *
462      * - `account` cannot be the zero address.
463      */
464     function _mint(address account, uint256 amount) internal virtual {
465         require(account != address(0), "ERC20: mint to the zero address");
466 
467         _beforeTokenTransfer(address(0), account, amount);
468 
469         _totalSupply += amount;
470         _balances[account] += amount;
471         emit Transfer(address(0), account, amount);
472 
473         _afterTokenTransfer(address(0), account, amount);
474     }
475 
476     /**
477      * @dev Destroys `amount` tokens from `account`, reducing the
478      * total supply.
479      *
480      * Emits a {Transfer} event with `to` set to the zero address.
481      *
482      * Requirements:
483      *
484      * - `account` cannot be the zero address.
485      * - `account` must have at least `amount` tokens.
486      */
487     function _burn(address account, uint256 amount) internal virtual {
488         require(account != address(0), "ERC20: burn from the zero address");
489 
490         _beforeTokenTransfer(account, address(0), amount);
491 
492         uint256 accountBalance = _balances[account];
493         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
494         unchecked {
495             _balances[account] = accountBalance - amount;
496         }
497         _totalSupply -= amount;
498 
499         emit Transfer(account, address(0), amount);
500 
501         _afterTokenTransfer(account, address(0), amount);
502     }
503 
504     /**
505      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
506      *
507      * This internal function is equivalent to `approve`, and can be used to
508      * e.g. set automatic allowances for certain subsystems, etc.
509      *
510      * Emits an {Approval} event.
511      *
512      * Requirements:
513      *
514      * - `owner` cannot be the zero address.
515      * - `spender` cannot be the zero address.
516      */
517     function _approve(
518         address owner,
519         address spender,
520         uint256 amount
521     ) internal virtual {
522         require(owner != address(0), "ERC20: approve from the zero address");
523         require(spender != address(0), "ERC20: approve to the zero address");
524 
525         _allowances[owner][spender] = amount;
526         emit Approval(owner, spender, amount);
527     }
528 
529     /**
530      * @dev Hook that is called before any transfer of tokens. This includes
531      * minting and burning.
532      *
533      * Calling conditions:
534      *
535      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
536      * will be transferred to `to`.
537      * - when `from` is zero, `amount` tokens will be minted for `to`.
538      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
539      * - `from` and `to` are never both zero.
540      *
541      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
542      */
543     function _beforeTokenTransfer(
544         address from,
545         address to,
546         uint256 amount
547     ) internal virtual {}
548 
549     /**
550      * @dev Hook that is called after any transfer of tokens. This includes
551      * minting and burning.
552      *
553      * Calling conditions:
554      *
555      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
556      * has been transferred to `to`.
557      * - when `from` is zero, `amount` tokens have been minted for `to`.
558      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
559      * - `from` and `to` are never both zero.
560      *
561      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
562      */
563     function _afterTokenTransfer(
564         address from,
565         address to,
566         uint256 amount
567     ) internal virtual {}
568 }
569 
570 /**
571  * @dev Wrappers over Solidity's arithmetic operations.
572  *
573  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
574  * now has built in overflow checking.
575  */
576 library SafeMath {
577     /**
578      * @dev Returns the addition of two unsigned integers, with an overflow flag.
579      *
580      * _Available since v3.4._
581      */
582     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
583         unchecked {
584             uint256 c = a + b;
585             if (c < a) return (false, 0);
586             return (true, c);
587         }
588     }
589 
590     /**
591      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
592      *
593      * _Available since v3.4._
594      */
595     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
596         unchecked {
597             if (b > a) return (false, 0);
598             return (true, a - b);
599         }
600     }
601 
602     /**
603      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
604      *
605      * _Available since v3.4._
606      */
607     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
608         unchecked {
609             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
610             // benefit is lost if 'b' is also tested.
611             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
612             if (a == 0) return (true, 0);
613             uint256 c = a * b;
614             if (c / a != b) return (false, 0);
615             return (true, c);
616         }
617     }
618 
619     /**
620      * @dev Returns the division of two unsigned integers, with a division by zero flag.
621      *
622      * _Available since v3.4._
623      */
624     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
625         unchecked {
626             if (b == 0) return (false, 0);
627             return (true, a / b);
628         }
629     }
630 
631     /**
632      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
633      *
634      * _Available since v3.4._
635      */
636     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
637         unchecked {
638             if (b == 0) return (false, 0);
639             return (true, a % b);
640         }
641     }
642 
643     /**
644      * @dev Returns the addition of two unsigned integers, reverting on
645      * overflow.
646      *
647      * Counterpart to Solidity's `+` operator.
648      *
649      * Requirements:
650      *
651      * - Addition cannot overflow.
652      */
653     function add(uint256 a, uint256 b) internal pure returns (uint256) {
654         return a + b;
655     }
656 
657     /**
658      * @dev Returns the subtraction of two unsigned integers, reverting on
659      * overflow (when the result is negative).
660      *
661      * Counterpart to Solidity's `-` operator.
662      *
663      * Requirements:
664      *
665      * - Subtraction cannot overflow.
666      */
667     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
668         return a - b;
669     }
670 
671     /**
672      * @dev Returns the multiplication of two unsigned integers, reverting on
673      * overflow.
674      *
675      * Counterpart to Solidity's `*` operator.
676      *
677      * Requirements:
678      *
679      * - Multiplication cannot overflow.
680      */
681     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
682         return a * b;
683     }
684 
685     /**
686      * @dev Returns the integer division of two unsigned integers, reverting on
687      * division by zero. The result is rounded towards zero.
688      *
689      * Counterpart to Solidity's `/` operator.
690      *
691      * Requirements:
692      *
693      * - The divisor cannot be zero.
694      */
695     function div(uint256 a, uint256 b) internal pure returns (uint256) {
696         return a / b;
697     }
698 
699     /**
700      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
701      * reverting when dividing by zero.
702      *
703      * Counterpart to Solidity's `%` operator. This function uses a `revert`
704      * opcode (which leaves remaining gas untouched) while Solidity uses an
705      * invalid opcode to revert (consuming all remaining gas).
706      *
707      * Requirements:
708      *
709      * - The divisor cannot be zero.
710      */
711     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
712         return a % b;
713     }
714 
715     /**
716      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
717      * overflow (when the result is negative).
718      *
719      * CAUTION: This function is deprecated because it requires allocating memory for the error
720      * message unnecessarily. For custom revert reasons use {trySub}.
721      *
722      * Counterpart to Solidity's `-` operator.
723      *
724      * Requirements:
725      *
726      * - Subtraction cannot overflow.
727      */
728     function sub(
729         uint256 a,
730         uint256 b,
731         string memory errorMessage
732     ) internal pure returns (uint256) {
733         unchecked {
734             require(b <= a, errorMessage);
735             return a - b;
736         }
737     }
738 
739     /**
740      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
741      * division by zero. The result is rounded towards zero.
742      *
743      * Counterpart to Solidity's `/` operator. Note: this function uses a
744      * `revert` opcode (which leaves remaining gas untouched) while Solidity
745      * uses an invalid opcode to revert (consuming all remaining gas).
746      *
747      * Requirements:
748      *
749      * - The divisor cannot be zero.
750      */
751     function div(
752         uint256 a,
753         uint256 b,
754         string memory errorMessage
755     ) internal pure returns (uint256) {
756         unchecked {
757             require(b > 0, errorMessage);
758             return a / b;
759         }
760     }
761 
762     /**
763      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
764      * reverting with custom message when dividing by zero.
765      *
766      * CAUTION: This function is deprecated because it requires allocating memory for the error
767      * message unnecessarily. For custom revert reasons use {tryMod}.
768      *
769      * Counterpart to Solidity's `%` operator. This function uses a `revert`
770      * opcode (which leaves remaining gas untouched) while Solidity uses an
771      * invalid opcode to revert (consuming all remaining gas).
772      *
773      * Requirements:
774      *
775      * - The divisor cannot be zero.
776      */
777     function mod(
778         uint256 a,
779         uint256 b,
780         string memory errorMessage
781     ) internal pure returns (uint256) {
782         unchecked {
783             require(b > 0, errorMessage);
784             return a % b;
785         }
786     }
787 }
788 
789 interface IUniswapV2Factory {
790     event PairCreated(
791         address indexed token0,
792         address indexed token1,
793         address pair,
794         uint256
795     );
796 
797     function feeTo() external view returns (address);
798 
799     function feeToSetter() external view returns (address);
800 
801     function getPair(address tokenA, address tokenB)
802         external
803         view
804         returns (address pair);
805 
806     function allPairs(uint256) external view returns (address pair);
807 
808     function allPairsLength() external view returns (uint256);
809 
810     function createPair(address tokenA, address tokenB)
811         external
812         returns (address pair);
813 
814     function setFeeTo(address) external;
815 
816     function setFeeToSetter(address) external;
817 }
818 
819 ////// src/IUniswapV2Pair.sol
820 /* pragma solidity 0.8.10; */
821 /* pragma experimental ABIEncoderV2; */
822 
823 interface IUniswapV2Pair {
824     event Approval(
825         address indexed owner,
826         address indexed spender,
827         uint256 value
828     );
829     event Transfer(address indexed from, address indexed to, uint256 value);
830 
831     function name() external pure returns (string memory);
832 
833     function symbol() external pure returns (string memory);
834 
835     function decimals() external pure returns (uint8);
836 
837     function totalSupply() external view returns (uint256);
838 
839     function balanceOf(address owner) external view returns (uint256);
840 
841     function allowance(address owner, address spender)
842         external
843         view
844         returns (uint256);
845 
846     function approve(address spender, uint256 value) external returns (bool);
847 
848     function transfer(address to, uint256 value) external returns (bool);
849 
850     function transferFrom(
851         address from,
852         address to,
853         uint256 value
854     ) external returns (bool);
855 
856     function DOMAIN_SEPARATOR() external view returns (bytes32);
857 
858     function PERMIT_TYPEHASH() external pure returns (bytes32);
859 
860     function nonces(address owner) external view returns (uint256);
861 
862     function permit(
863         address owner,
864         address spender,
865         uint256 value,
866         uint256 deadline,
867         uint8 v,
868         bytes32 r,
869         bytes32 s
870     ) external;
871 
872     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
873     event Burn(
874         address indexed sender,
875         uint256 amount0,
876         uint256 amount1,
877         address indexed to
878     );
879     event Swap(
880         address indexed sender,
881         uint256 amount0In,
882         uint256 amount1In,
883         uint256 amount0Out,
884         uint256 amount1Out,
885         address indexed to
886     );
887     event Sync(uint112 reserve0, uint112 reserve1);
888 
889     function MINIMUM_LIQUIDITY() external pure returns (uint256);
890 
891     function factory() external view returns (address);
892 
893     function token0() external view returns (address);
894 
895     function token1() external view returns (address);
896 
897     function getReserves()
898         external
899         view
900         returns (
901             uint112 reserve0,
902             uint112 reserve1,
903             uint32 blockTimestampLast
904         );
905 
906     function price0CumulativeLast() external view returns (uint256);
907 
908     function price1CumulativeLast() external view returns (uint256);
909 
910     function kLast() external view returns (uint256);
911 
912     function mint(address to) external returns (uint256 liquidity);
913 
914     function burn(address to)
915         external
916         returns (uint256 amount0, uint256 amount1);
917 
918     function swap(
919         uint256 amount0Out,
920         uint256 amount1Out,
921         address to,
922         bytes calldata data
923     ) external;
924 
925     function skim(address to) external;
926 
927     function sync() external;
928 
929     function initialize(address, address) external;
930 }
931 
932 interface IUniswapV2Router02 {
933     function factory() external pure returns (address);
934 
935     function WETH() external pure returns (address);
936 
937     function addLiquidity(
938         address tokenA,
939         address tokenB,
940         uint256 amountADesired,
941         uint256 amountBDesired,
942         uint256 amountAMin,
943         uint256 amountBMin,
944         address to,
945         uint256 deadline
946     )
947         external
948         returns (
949             uint256 amountA,
950             uint256 amountB,
951             uint256 liquidity
952         );
953 
954     function addLiquidityETH(
955         address token,
956         uint256 amountTokenDesired,
957         uint256 amountTokenMin,
958         uint256 amountETHMin,
959         address to,
960         uint256 deadline
961     )
962         external
963         payable
964         returns (
965             uint256 amountToken,
966             uint256 amountETH,
967             uint256 liquidity
968         );
969 
970     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
971         uint256 amountIn,
972         uint256 amountOutMin,
973         address[] calldata path,
974         address to,
975         uint256 deadline
976     ) external;
977 
978     function swapExactETHForTokensSupportingFeeOnTransferTokens(
979         uint256 amountOutMin,
980         address[] calldata path,
981         address to,
982         uint256 deadline
983     ) external payable;
984 
985     function swapExactTokensForETHSupportingFeeOnTransferTokens(
986         uint256 amountIn,
987         uint256 amountOutMin,
988         address[] calldata path,
989         address to,
990         uint256 deadline
991     ) external;
992 }
993 
994 contract USD is ERC20, Ownable {
995     using SafeMath for uint256;
996 
997     IUniswapV2Router02 public immutable uniswapV2Router;
998     address public immutable uniswapV2Pair;
999     address public constant deadAddress = address(0xdead);
1000 
1001     bool private swapping;
1002 
1003     address public lotteryWallet;
1004     address public teamWallet;
1005 
1006     uint256 public maxTransactionAmount;
1007     uint256 public swapTokensAtAmount;
1008     uint256 public maxWallet;
1009 
1010     bool public limitsInEffect = true;
1011     bool public tradingActive = true;
1012     bool public swapEnabled = true;
1013 
1014     bool public blacklistRenounced = false;
1015 
1016     // Anti-bot and anti-whale mappings and variables
1017     mapping(address => bool) blacklisted;
1018 
1019     uint256 public buyTotalFees;
1020     uint256 public buyLotteryFee;
1021     uint256 public buyLiquidityFee;
1022     uint256 public buyTeamFee;
1023 
1024     uint256 public sellTotalFees;
1025     uint256 public sellLotteryFee;
1026     uint256 public sellLiquidityFee;
1027     uint256 public sellTeamFee;
1028 
1029     uint256 public tokensForLottery;
1030     uint256 public tokensForLiquidity;
1031     uint256 public tokensForTeam;
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
1043   
1044 
1045     event UpdateUniswapV2Router(
1046         address indexed newAddress,
1047         address indexed oldAddress
1048     );
1049 
1050     event ExcludeFromFees(address indexed account, bool isExcluded);
1051 
1052     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1053 
1054     event lotteryWalletUpdated(
1055         address indexed newWallet,
1056         address indexed oldWallet
1057     );
1058 
1059     event teamWalletUpdated(
1060         address indexed newWallet,
1061         address indexed oldWallet
1062     );
1063 
1064     event SwapAndLiquify(
1065         uint256 tokensSwapped,
1066         uint256 ethReceived,
1067         uint256 tokensIntoLiquidity
1068     );
1069 
1070     constructor() ERC20("HarryPotterObamaSpongebob4MegaMillionsInu", "USD") {
1071         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1072             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1073         );
1074 
1075         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1076         uniswapV2Router = _uniswapV2Router;
1077 
1078         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1079             .createPair(address(this), _uniswapV2Router.WETH());
1080         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1081         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1082 
1083         uint256 _buyLotteryFee = 8; //to prevent bots, will be updated to 3
1084         uint256 _buyLiquidityFee = 0; 
1085         uint256 _buyTeamFee = 7; //to prevent bots, will be updated to 2
1086 
1087         uint256 _sellLotteryFee = 7; //to prevent bots, will be updated to 2
1088         uint256 _sellLiquidityFee = 0;
1089         uint256 _sellTeamFee = 8; //to prevent bots, will be updated to 3
1090 
1091         uint256 totalSupply = 100_000_000 * 1e18;
1092 
1093         maxTransactionAmount = 2000_000 * 1e18; // 2%
1094         maxWallet = 2000_000 * 1e18; // 2% 
1095         swapTokensAtAmount = (totalSupply * 1) / 1000; // 0.1% 
1096 
1097         buyLotteryFee = _buyLotteryFee;
1098         buyLiquidityFee = _buyLiquidityFee;
1099         buyTeamFee = _buyTeamFee;
1100         buyTotalFees = buyLotteryFee + buyLiquidityFee + buyTeamFee;
1101 
1102         sellLotteryFee = _sellLotteryFee;
1103         sellLiquidityFee = _sellLiquidityFee;
1104         sellTeamFee = _sellTeamFee;
1105         sellTotalFees = sellLotteryFee + sellLiquidityFee + sellTeamFee;
1106 
1107         lotteryWallet = address(0x0dafe3Bd0091A986c898295f73A88C606975626A); // set as Jackpot wallet
1108         teamWallet = owner(); // set as team wallet
1109 
1110         // exclude from paying fees or having max transaction amount
1111         excludeFromFees(owner(), true);
1112         excludeFromFees(address(this), true);
1113         excludeFromFees(address(0xdead), true);
1114 
1115         excludeFromMaxTransaction(owner(), true);
1116         excludeFromMaxTransaction(address(this), true);
1117         excludeFromMaxTransaction(address(0xdead), true);
1118 
1119       
1120 
1121         /*
1122             _mint is an internal function in ERC20.sol that is only called here,
1123             and CANNOT be called ever again
1124         */
1125         _mint(msg.sender, totalSupply);
1126     }
1127 
1128     receive() external payable {}
1129 
1130     // once enabled, can never be turned off
1131     function enableTrading() external onlyOwner {
1132         tradingActive = true;
1133         swapEnabled = true;
1134       
1135     }
1136 
1137     // remove limits after token is stable
1138     function removeLimits() external onlyOwner returns (bool) {
1139         limitsInEffect = false;
1140         return true;
1141     }
1142 
1143     // change the minimum amount of tokens to sell from fees
1144     function updateSwapTokensAtAmount(uint256 newAmount)
1145         external
1146         onlyOwner
1147         returns (bool)
1148     {
1149         require(
1150             newAmount >= (totalSupply() * 1) / 100000,
1151             "Swap amount cannot be lower than 0.001% total supply."
1152         );
1153         require(
1154             newAmount <= (totalSupply() * 5) / 1000,
1155             "Swap amount cannot be higher than 0.5% total supply."
1156         );
1157         swapTokensAtAmount = newAmount;
1158         return true;
1159     }
1160 
1161     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1162         require(
1163             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1164             "Cannot set maxTransactionAmount lower than 0.5%"
1165         );
1166         maxTransactionAmount = newNum * (10**18);
1167     }
1168 
1169     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1170         require(
1171             newNum >= ((totalSupply() * 10) / 1000) / 1e18,
1172             "Cannot set maxWallet lower than 1.0%"
1173         );
1174         maxWallet = newNum * (10**18);
1175     }
1176 
1177     function excludeFromMaxTransaction(address updAds, bool isEx)
1178         public
1179         onlyOwner
1180     {
1181         _isExcludedMaxTransactionAmount[updAds] = isEx;
1182     }
1183 
1184     // only use to disable contract sales if absolutely necessary (emergency use only)
1185     function updateSwapEnabled(bool enabled) external onlyOwner {
1186         swapEnabled = enabled;
1187     }
1188 
1189     function updateBuyFees(
1190         uint256 _lotteryFee,
1191         uint256 _liquidityFee,
1192         uint256 _teamFee
1193     ) external onlyOwner {
1194         buyLotteryFee = _lotteryFee;
1195         buyLiquidityFee = _liquidityFee;
1196         buyTeamFee = _teamFee;
1197         buyTotalFees = buyLotteryFee + buyLiquidityFee + buyTeamFee;
1198         require(buyTotalFees <= 31, "Buy fees must be <= 31.");
1199     }
1200 
1201     function updateSellFees(
1202         uint256 _lotteryFee,
1203         uint256 _liquidityFee,
1204         uint256 _teamFee
1205     ) external onlyOwner {
1206         sellLotteryFee = _lotteryFee;
1207         sellLiquidityFee = _liquidityFee;
1208         sellTeamFee = _teamFee;
1209         sellTotalFees = sellLotteryFee + sellLiquidityFee + sellTeamFee;
1210         require(sellTotalFees <= 31, "Sell fees must be <= 31.");
1211     }
1212 
1213     function excludeFromFees(address account, bool excluded) public onlyOwner {
1214         _isExcludedFromFees[account] = excluded;
1215         emit ExcludeFromFees(account, excluded);
1216     }
1217 
1218     function setAutomatedMarketMakerPair(address pair, bool value)
1219         public
1220         onlyOwner
1221     {
1222         require(
1223             pair != uniswapV2Pair,
1224             "The pair cannot be removed from automatedMarketMakerPairs"
1225         );
1226 
1227         _setAutomatedMarketMakerPair(pair, value);
1228     }
1229 
1230     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1231         automatedMarketMakerPairs[pair] = value;
1232 
1233         emit SetAutomatedMarketMakerPair(pair, value);
1234     }
1235 
1236     function updateLotteryWallet(address newLotteryWallet) external onlyOwner {
1237         emit lotteryWalletUpdated(newLotteryWallet, lotteryWallet);
1238         lotteryWallet = newLotteryWallet;
1239     }
1240 
1241     function updateTeamWallet(address newWallet) external onlyOwner {
1242         emit teamWalletUpdated(newWallet, teamWallet);
1243         teamWallet = newWallet;
1244     }
1245 
1246     function isExcludedFromFees(address account) public view returns (bool) {
1247         return _isExcludedFromFees[account];
1248     }
1249 
1250     function isBlacklisted(address account) public view returns (bool) {
1251         return blacklisted[account];
1252     }
1253 
1254     function _transfer(
1255         address from,
1256         address to,
1257         uint256 amount
1258     ) internal override {
1259         require(from != address(0), "ERC20: transfer from the zero address");
1260         require(to != address(0), "ERC20: transfer to the zero address");
1261         require(!blacklisted[from],"Sender blacklisted");
1262         require(!blacklisted[to],"Receiver blacklisted");
1263 
1264         
1265         
1266 
1267         if (amount == 0) {
1268             super._transfer(from, to, 0);
1269             return;
1270         }
1271 
1272         if (limitsInEffect) {
1273             if (
1274                 from != owner() &&
1275                 to != owner() &&
1276                 to != address(0) &&
1277                 to != address(0xdead) &&
1278                 !swapping
1279             ) {
1280                 if (!tradingActive) {
1281                     require(
1282                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1283                         "Trading is not active."
1284                     );
1285                 }
1286 
1287                 //when buy
1288                 if (
1289                     automatedMarketMakerPairs[from] &&
1290                     !_isExcludedMaxTransactionAmount[to]
1291                 ) {
1292                     require(
1293                         amount <= maxTransactionAmount,
1294                         "Buy transfer amount exceeds the maxTransactionAmount."
1295                     );
1296                     require(
1297                         amount + balanceOf(to) <= maxWallet,
1298                         "Max wallet exceeded"
1299                     );
1300                 }
1301                 //when sell
1302                 else if (
1303                     automatedMarketMakerPairs[to] &&
1304                     !_isExcludedMaxTransactionAmount[from]
1305                 ) {
1306                     require(
1307                         amount <= maxTransactionAmount,
1308                         "Sell transfer amount exceeds the maxTransactionAmount."
1309                     );
1310                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1311                     require(
1312                         amount + balanceOf(to) <= maxWallet,
1313                         "Max wallet exceeded"
1314                     );
1315                 }
1316             }
1317         }
1318 
1319         uint256 contractTokenBalance = balanceOf(address(this));
1320 
1321         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1322 
1323         if (
1324             canSwap &&
1325             swapEnabled &&
1326             !swapping &&
1327             !automatedMarketMakerPairs[from] &&
1328             !_isExcludedFromFees[from] &&
1329             !_isExcludedFromFees[to]
1330         ) {
1331             swapping = true;
1332 
1333             swapBack();
1334 
1335             swapping = false;
1336         }
1337 
1338         bool takeFee = !swapping;
1339 
1340         // if any account belongs to _isExcludedFromFee account then remove the fee
1341         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1342             takeFee = false;
1343         }
1344 
1345         uint256 fees = 0;
1346         // only take fees on buys/sells, do not take on wallet transfers
1347         if (takeFee) {
1348             // on sell
1349             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1350                 fees = amount.mul(sellTotalFees).div(100);
1351                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1352                 tokensForTeam += (fees * sellTeamFee) / sellTotalFees;
1353                 tokensForLottery += (fees * sellLotteryFee) / sellTotalFees;
1354             }
1355             // on buy
1356             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1357                 fees = amount.mul(buyTotalFees).div(100);
1358                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1359                 tokensForTeam += (fees * buyTeamFee) / buyTotalFees;
1360                 tokensForLottery += (fees * buyLotteryFee) / buyTotalFees;
1361             }
1362 
1363             if (fees > 0) {
1364                 super._transfer(from, address(this), fees);
1365             }
1366 
1367             amount -= fees;
1368         }
1369 
1370         super._transfer(from, to, amount);
1371     }
1372 
1373     function swapTokensForEth(uint256 tokenAmount) private {
1374         // generate the uniswap pair path of token -> weth
1375         address[] memory path = new address[](2);
1376         path[0] = address(this);
1377         path[1] = uniswapV2Router.WETH();
1378 
1379         _approve(address(this), address(uniswapV2Router), tokenAmount);
1380 
1381         // make the swap
1382         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1383             tokenAmount,
1384             0, // accept any amount of ETH
1385             path,
1386             address(this),
1387             block.timestamp
1388         );
1389     }
1390 
1391     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1392         // approve token transfer to cover all possible scenarios
1393         _approve(address(this), address(uniswapV2Router), tokenAmount);
1394 
1395         // add the liquidity
1396         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1397             address(this),
1398             tokenAmount,
1399             0, // slippage is unavoidable
1400             0, // slippage is unavoidable
1401             owner(),
1402             block.timestamp
1403         );
1404     }
1405 
1406     function swapBack() private {
1407         uint256 contractBalance = balanceOf(address(this));
1408         uint256 totalTokensToSwap = tokensForLiquidity +
1409             tokensForLottery +
1410             tokensForTeam;
1411         bool success;
1412 
1413         if (contractBalance == 0 || totalTokensToSwap == 0) {
1414             return;
1415         }
1416 
1417         if (contractBalance > swapTokensAtAmount * 20) {
1418             contractBalance = swapTokensAtAmount * 20;
1419         }
1420 
1421         // Halve the amount of liquidity tokens
1422         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1423             totalTokensToSwap /
1424             2;
1425         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1426 
1427         uint256 initialETHBalance = address(this).balance;
1428 
1429         swapTokensForEth(amountToSwapForETH);
1430 
1431         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1432 
1433         uint256 ethForLottery = ethBalance.mul(tokensForLottery).div(totalTokensToSwap - (tokensForLiquidity / 2));
1434         
1435         uint256 ethForTeam = ethBalance.mul(tokensForTeam).div(totalTokensToSwap - (tokensForLiquidity / 2));
1436 
1437         uint256 ethForLiquidity = ethBalance - ethForLottery - ethForTeam;
1438 
1439         tokensForLiquidity = 0;
1440         tokensForLottery = 0;
1441         tokensForTeam = 0;
1442 
1443         (success, ) = address(teamWallet).call{value: ethForTeam}("");
1444 
1445         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1446             addLiquidity(liquidityTokens, ethForLiquidity);
1447             emit SwapAndLiquify(
1448                 amountToSwapForETH,
1449                 ethForLiquidity,
1450                 tokensForLiquidity
1451             );
1452         }
1453 
1454         (success, ) = address(lotteryWallet).call{value: address(this).balance}("");
1455     }
1456 
1457     function withdrawStuckUnibot() external onlyOwner {
1458         uint256 balance = IERC20(address(this)).balanceOf(address(this));
1459         IERC20(address(this)).transfer(msg.sender, balance);
1460         payable(msg.sender).transfer(address(this).balance);
1461     }
1462 
1463     function withdrawStuckToken(address _token, address _to) external onlyOwner {
1464         require(_token != address(0), "_token address cannot be 0");
1465         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1466         IERC20(_token).transfer(_to, _contractBalance);
1467     }
1468 
1469     function withdrawStuckEth(address toAddr) external onlyOwner {
1470         (bool success, ) = toAddr.call{
1471             value: address(this).balance
1472         } ("");
1473         require(success);
1474     }
1475 
1476     // @dev team renounce blacklist commands
1477     function renounceBlacklist() public onlyOwner {
1478         blacklistRenounced = true;
1479     }
1480 
1481     function blacklist(address _addr) public onlyOwner {
1482         require(!blacklistRenounced, "Team has revoked blacklist rights");
1483         require(
1484             _addr != address(uniswapV2Pair) && _addr != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D), 
1485             "Cannot blacklist token's v2 router or v2 pool."
1486         );
1487         blacklisted[_addr] = true;
1488     }
1489 
1490     // @dev blacklist v3 pools; can unblacklist() down the road to suit project and community
1491     function blacklistLiquidityPool(address lpAddress) public onlyOwner {
1492         require(!blacklistRenounced, "Team has revoked blacklist rights");
1493         require(
1494             lpAddress != address(uniswapV2Pair) && lpAddress != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D), 
1495             "Cannot blacklist token's v2 router or v2 pool."
1496         );
1497         blacklisted[lpAddress] = true;
1498     }
1499 
1500     // @dev unblacklist address; not affected by blacklistRenounced incase team wants to unblacklist v3 pools down the road
1501     function unblacklist(address _addr) public onlyOwner {
1502         blacklisted[_addr] = false;
1503     }
1504 }