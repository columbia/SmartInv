1 /**
2 */
3 // SPDX-License-Identifier: MIT
4 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
5 pragma experimental ABIEncoderV2;
6 
7 /**
8 
9 
10 //  Floxi is born to a pair of loyal shiba inu parents, Floki and Flona. 
11 
12 // Floxinomics 
13 // 1% goes to Floki
14 // 1% goes to Flona 
15 // 2% goes to Floxi  
16 
17 
18 // https://floxitoken.com
19 // https://twitter.com/FloxiToken
20 // https://t.me/FLOXItoken
21 
22 
23 
24 */
25 
26 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
27 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
28 
29 /* pragma solidity ^0.8.0; */
30 
31 /**
32  * @dev Provides information about the current execution context, including the
33  * sender of the transaction and its data. While these are generally available
34  * via msg.sender and msg.data, they should not be accessed in such a direct
35  * manner, since when dealing with meta-transactions the account sending and
36  * paying for execution may not be the actual sender (as far as an application
37  * is concerned).
38  *
39  * This contract is only required for intermediate, library-like contracts.
40  */
41 abstract contract Context {
42     function _msgSender() internal view virtual returns (address) {
43         return msg.sender;
44     }
45 
46     function _msgData() internal view virtual returns (bytes calldata) {
47         return msg.data;
48     }
49 }
50 
51 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
52 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
53 
54 /* pragma solidity ^0.8.0; */
55 
56 /* import "../utils/Context.sol"; */
57 
58 /**
59  * @dev Contract module which provides a basic access control mechanism, where
60  * there is an account (an owner) that can be granted exclusive access to
61  * specific functions.
62  *
63  * By default, the owner account will be the one that deploys the contract. This
64  * can later be changed with {transferOwnership}.
65  *
66  * This module is used through inheritance. It will make available the modifier
67  * `onlyOwner`, which can be applied to your functions to restrict their use to
68  * the owner.
69  */
70 abstract contract Ownable is Context {
71     address private _owner;
72 
73     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
74 
75     /**
76      * @dev Initializes the contract setting the deployer as the initial owner.
77      */
78     constructor() {
79         _transferOwnership(_msgSender());
80     }
81 
82     /**
83      * @dev Returns the address of the current owner.
84      */
85     function owner() public view virtual returns (address) {
86         return _owner;
87     }
88 
89     /**
90      * @dev Throws if called by any account other than the owner.
91      */
92     modifier onlyOwner() {
93         require(owner() == _msgSender(), "Ownable: caller is not the owner");
94         _;
95     }
96 
97     /**
98      * @dev Leaves the contract without owner. It will not be possible to call
99      * `onlyOwner` functions anymore. Can only be called by the current owner.
100      *
101      * NOTE: Renouncing ownership will leave the contract without an owner,
102      * thereby removing any functionality that is only available to the owner.
103      */
104     function renounceOwnership() public virtual onlyOwner {
105         _transferOwnership(address(0));
106     }
107 
108     /**
109      * @dev Transfers ownership of the contract to a new account (`newOwner`).
110      * Can only be called by the current owner.
111      */
112     function transferOwnership(address newOwner) public virtual onlyOwner {
113         require(newOwner != address(0), "Ownable: new owner is the zero address");
114         _transferOwnership(newOwner);
115     }
116 
117     /**
118      * @dev Transfers ownership of the contract to a new account (`newOwner`).
119      * Internal function without access restriction.
120      */
121     function _transferOwnership(address newOwner) internal virtual {
122         address oldOwner = _owner;
123         _owner = newOwner;
124         emit OwnershipTransferred(oldOwner, newOwner);
125     }
126 }
127 
128 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
129 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
130 
131 /* pragma solidity ^0.8.0; */
132 
133 /**
134  * @dev Interface of the ERC20 standard as defined in the EIP.
135  */
136 interface IERC20 {
137     /**
138      * @dev Returns the amount of tokens in existence.
139      */
140     function totalSupply() external view returns (uint256);
141 
142     /**
143      * @dev Returns the amount of tokens owned by `account`.
144      */
145     function balanceOf(address account) external view returns (uint256);
146 
147     /**
148      * @dev Moves `amount` tokens from the caller's account to `recipient`.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * Emits a {Transfer} event.
153      */
154     function transfer(address recipient, uint256 amount) external returns (bool);
155 
156     /**
157      * @dev Returns the remaining number of tokens that `spender` will be
158      * allowed to spend on behalf of `owner` through {transferFrom}. This is
159      * zero by default.
160      *
161      * This value changes when {approve} or {transferFrom} are called.
162      */
163     function allowance(address owner, address spender) external view returns (uint256);
164 
165     /**
166      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * IMPORTANT: Beware that changing an allowance with this method brings the risk
171      * that someone may use both the old and the new allowance by unfortunate
172      * transaction ordering. One possible solution to mitigate this race
173      * condition is to first reduce the spender's allowance to 0 and set the
174      * desired value afterwards:
175      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176      *
177      * Emits an {Approval} event.
178      */
179     function approve(address spender, uint256 amount) external returns (bool);
180 
181     /**
182      * @dev Moves `amount` tokens from `sender` to `recipient` using the
183      * allowance mechanism. `amount` is then deducted from the caller's
184      * allowance.
185      *
186      * Returns a boolean value indicating whether the operation succeeded.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transferFrom(
191         address sender,
192         address recipient,
193         uint256 amount
194     ) external returns (bool);
195 
196     /**
197      * @dev Emitted when `value` tokens are moved from one account (`from`) to
198      * another (`to`).
199      *
200      * Note that `value` may be zero.
201      */
202     event Transfer(address indexed from, address indexed to, uint256 value);
203 
204     /**
205      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
206      * a call to {approve}. `value` is the new allowance.
207      */
208     event Approval(address indexed owner, address indexed spender, uint256 value);
209 }
210 
211 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
212 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
213 
214 /* pragma solidity ^0.8.0; */
215 
216 /* import "../IERC20.sol"; */
217 
218 /**
219  * @dev Interface for the optional metadata functions from the ERC20 standard.
220  *
221  * _Available since v4.1._
222  */
223 interface IERC20Metadata is IERC20 {
224     /**
225      * @dev Returns the name of the token.
226      */
227     function name() external view returns (string memory);
228 
229     /**
230      * @dev Returns the symbol of the token.
231      */
232     function symbol() external view returns (string memory);
233 
234     /**
235      * @dev Returns the decimals places of the token.
236      */
237     function decimals() external view returns (uint8);
238 }
239 
240 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
241 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
242 
243 /* pragma solidity ^0.8.0; */
244 
245 /* import "./IERC20.sol"; */
246 /* import "./extensions/IERC20Metadata.sol"; */
247 /* import "../../utils/Context.sol"; */
248 
249 /**
250  * @dev Implementation of the {IERC20} interface.
251  *
252  * This implementation is agnostic to the way tokens are created. This means
253  * that a supply mechanism has to be added in a derived contract using {_mint}.
254  * For a generic mechanism see {ERC20PresetMinterPauser}.
255  *
256  * TIP: For a detailed writeup see our guide
257  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
258  * to implement supply mechanisms].
259  *
260  * We have followed general OpenZeppelin Contracts guidelines: functions revert
261  * instead returning `false` on failure. This behavior is nonetheless
262  * conventional and does not conflict with the expectations of ERC20
263  * applications.
264  *
265  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
266  * This allows applications to reconstruct the allowance for all accounts just
267  * by listening to said events. Other implementations of the EIP may not emit
268  * these events, as it isn't required by the specification.
269  *
270  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
271  * functions have been added to mitigate the well-known issues around setting
272  * allowances. See {IERC20-approve}.
273  */
274 contract ERC20 is Context, IERC20, IERC20Metadata {
275     mapping(address => uint256) private _balances;
276 
277     mapping(address => mapping(address => uint256)) private _allowances;
278 
279     uint256 private _totalSupply;
280 
281     string private _name;
282     string private _symbol;
283 
284     /**
285      * @dev Sets the values for {name} and {symbol}.
286      *
287      * The default value of {decimals} is 18. To select a different value for
288      * {decimals} you should overload it.
289      *
290      * All two of these values are immutable: they can only be set once during
291      * construction.
292      */
293     constructor(string memory name_, string memory symbol_) {
294         _name = name_;
295         _symbol = symbol_;
296     }
297 
298     /**
299      * @dev Returns the name of the token.
300      */
301     function name() public view virtual override returns (string memory) {
302         return _name;
303     }
304 
305     /**
306      * @dev Returns the symbol of the token, usually a shorter version of the
307      * name.
308      */
309     function symbol() public view virtual override returns (string memory) {
310         return _symbol;
311     }
312 
313     /**
314      * @dev Returns the number of decimals used to get its user representation.
315      * For example, if `decimals` equals `2`, a balance of `505` tokens should
316      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
317      *
318      * Tokens usually opt for a value of 18, imitating the relationship between
319      * Ether and Wei. This is the value {ERC20} uses, unless this function is
320      * overridden;
321      *
322      * NOTE: This information is only used for _display_ purposes: it in
323      * no way affects any of the arithmetic of the contract, including
324      * {IERC20-balanceOf} and {IERC20-transfer}.
325      */
326     function decimals() public view virtual override returns (uint8) {
327         return 18;
328     }
329 
330     /**
331      * @dev See {IERC20-totalSupply}.
332      */
333     function totalSupply() public view virtual override returns (uint256) {
334         return _totalSupply;
335     }
336 
337     /**
338      * @dev See {IERC20-balanceOf}.
339      */
340     function balanceOf(address account) public view virtual override returns (uint256) {
341         return _balances[account];
342     }
343 
344     /**
345      * @dev See {IERC20-transfer}.
346      *
347      * Requirements:
348      *
349      * - `recipient` cannot be the zero address.
350      * - the caller must have a balance of at least `amount`.
351      */
352     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
353         _transfer(_msgSender(), recipient, amount);
354         return true;
355     }
356 
357     /**
358      * @dev See {IERC20-allowance}.
359      */
360     function allowance(address owner, address spender) public view virtual override returns (uint256) {
361         return _allowances[owner][spender];
362     }
363 
364     /**
365      * @dev See {IERC20-approve}.
366      *
367      * Requirements:
368      *
369      * - `spender` cannot be the zero address.
370      */
371     function approve(address spender, uint256 amount) public virtual override returns (bool) {
372         _approve(_msgSender(), spender, amount);
373         return true;
374     }
375 
376     /**
377      * @dev See {IERC20-transferFrom}.
378      *
379      * Emits an {Approval} event indicating the updated allowance. This is not
380      * required by the EIP. See the note at the beginning of {ERC20}.
381      *
382      * Requirements:
383      *
384      * - `sender` and `recipient` cannot be the zero address.
385      * - `sender` must have a balance of at least `amount`.
386      * - the caller must have allowance for ``sender``'s tokens of at least
387      * `amount`.
388      */
389     function transferFrom(
390         address sender,
391         address recipient,
392         uint256 amount
393     ) public virtual override returns (bool) {
394         _transfer(sender, recipient, amount);
395 
396         uint256 currentAllowance = _allowances[sender][_msgSender()];
397         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
398         unchecked {
399             _approve(sender, _msgSender(), currentAllowance - amount);
400         }
401 
402         return true;
403     }
404 
405     /**
406      * @dev Atomically increases the allowance granted to `spender` by the caller.
407      *
408      * This is an alternative to {approve} that can be used as a mitigation for
409      * problems described in {IERC20-approve}.
410      *
411      * Emits an {Approval} event indicating the updated allowance.
412      *
413      * Requirements:
414      *
415      * - `spender` cannot be the zero address.
416      */
417     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
418         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
419         return true;
420     }
421 
422     /**
423      * @dev Atomically decreases the allowance granted to `spender` by the caller.
424      *
425      * This is an alternative to {approve} that can be used as a mitigation for
426      * problems described in {IERC20-approve}.
427      *
428      * Emits an {Approval} event indicating the updated allowance.
429      *
430      * Requirements:
431      *
432      * - `spender` cannot be the zero address.
433      * - `spender` must have allowance for the caller of at least
434      * `subtractedValue`.
435      */
436     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
437         uint256 currentAllowance = _allowances[_msgSender()][spender];
438         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
439         unchecked {
440             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
441         }
442 
443         return true;
444     }
445 
446     /**
447      * @dev Moves `amount` of tokens from `sender` to `recipient`.
448      *
449      * This internal function is equivalent to {transfer}, and can be used to
450      * e.g. implement automatic token fees, slashing mechanisms, etc.
451      *
452      * Emits a {Transfer} event.
453      *
454      * Requirements:
455      *
456      * - `sender` cannot be the zero address.
457      * - `recipient` cannot be the zero address.
458      * - `sender` must have a balance of at least `amount`.
459      */
460     function _transfer(
461         address sender,
462         address recipient,
463         uint256 amount
464     ) internal virtual {
465         require(sender != address(0), "ERC20: transfer from the zero address");
466         require(recipient != address(0), "ERC20: transfer to the zero address");
467 
468         _beforeTokenTransfer(sender, recipient, amount);
469 
470         uint256 senderBalance = _balances[sender];
471         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
472         unchecked {
473             _balances[sender] = senderBalance - amount;
474         }
475         _balances[recipient] += amount;
476 
477         emit Transfer(sender, recipient, amount);
478 
479         _afterTokenTransfer(sender, recipient, amount);
480     }
481 
482     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
483      * the total supply.
484      *
485      * Emits a {Transfer} event with `from` set to the zero address.
486      *
487      * Requirements:
488      *
489      * - `account` cannot be the zero address.
490      */
491     function _mint(address account, uint256 amount) internal virtual {
492         require(account != address(0), "ERC20: mint to the zero address");
493 
494         _beforeTokenTransfer(address(0), account, amount);
495 
496         _totalSupply += amount;
497         _balances[account] += amount;
498         emit Transfer(address(0), account, amount);
499 
500         _afterTokenTransfer(address(0), account, amount);
501     }
502 
503     /**
504      * @dev Destroys `amount` tokens from `account`, reducing the
505      * total supply.
506      *
507      * Emits a {Transfer} event with `to` set to the zero address.
508      *
509      * Requirements:
510      *
511      * - `account` cannot be the zero address.
512      * - `account` must have at least `amount` tokens.
513      */
514     function _burn(address account, uint256 amount) internal virtual {
515         require(account != address(0), "ERC20: burn from the zero address");
516 
517         _beforeTokenTransfer(account, address(0), amount);
518 
519         uint256 accountBalance = _balances[account];
520         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
521         unchecked {
522             _balances[account] = accountBalance - amount;
523         }
524         _totalSupply -= amount;
525 
526         emit Transfer(account, address(0), amount);
527 
528         _afterTokenTransfer(account, address(0), amount);
529     }
530 
531     /**
532      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
533      *
534      * This internal function is equivalent to `approve`, and can be used to
535      * e.g. set automatic allowances for certain subsystems, etc.
536      *
537      * Emits an {Approval} event.
538      *
539      * Requirements:
540      *
541      * - `owner` cannot be the zero address.
542      * - `spender` cannot be the zero address.
543      */
544     function _approve(
545         address owner,
546         address spender,
547         uint256 amount
548     ) internal virtual {
549         require(owner != address(0), "ERC20: approve from the zero address");
550         require(spender != address(0), "ERC20: approve to the zero address");
551 
552         _allowances[owner][spender] = amount;
553         emit Approval(owner, spender, amount);
554     }
555 
556     /**
557      * @dev Hook that is called before any transfer of tokens. This includes
558      * minting and burning.
559      *
560      * Calling conditions:
561      *
562      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
563      * will be transferred to `to`.
564      * - when `from` is zero, `amount` tokens will be minted for `to`.
565      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
566      * - `from` and `to` are never both zero.
567      *
568      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
569      */
570     function _beforeTokenTransfer(
571         address from,
572         address to,
573         uint256 amount
574     ) internal virtual {}
575 
576     /**
577      * @dev Hook that is called after any transfer of tokens. This includes
578      * minting and burning.
579      *
580      * Calling conditions:
581      *
582      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
583      * has been transferred to `to`.
584      * - when `from` is zero, `amount` tokens have been minted for `to`.
585      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
586      * - `from` and `to` are never both zero.
587      *
588      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
589      */
590     function _afterTokenTransfer(
591         address from,
592         address to,
593         uint256 amount
594     ) internal virtual {}
595 }
596 
597 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
598 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
599 
600 /* pragma solidity ^0.8.0; */
601 
602 // CAUTION
603 // This version of SafeMath should only be used with Solidity 0.8 or later,
604 // because it relies on the compiler's built in overflow checks.
605 
606 /**
607  * @dev Wrappers over Solidity's arithmetic operations.
608  *
609  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
610  * now has built in overflow checking.
611  */
612 library SafeMath {
613     /**
614      * @dev Returns the addition of two unsigned integers, with an overflow flag.
615      *
616      * _Available since v3.4._
617      */
618     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
619         unchecked {
620             uint256 c = a + b;
621             if (c < a) return (false, 0);
622             return (true, c);
623         }
624     }
625 
626     /**
627      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
628      *
629      * _Available since v3.4._
630      */
631     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
632         unchecked {
633             if (b > a) return (false, 0);
634             return (true, a - b);
635         }
636     }
637 
638     /**
639      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
640      *
641      * _Available since v3.4._
642      */
643     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
644         unchecked {
645             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
646             // benefit is lost if 'b' is also tested.
647             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
648             if (a == 0) return (true, 0);
649             uint256 c = a * b;
650             if (c / a != b) return (false, 0);
651             return (true, c);
652         }
653     }
654 
655     /**
656      * @dev Returns the division of two unsigned integers, with a division by zero flag.
657      *
658      * _Available since v3.4._
659      */
660     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
661         unchecked {
662             if (b == 0) return (false, 0);
663             return (true, a / b);
664         }
665     }
666 
667     /**
668      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
669      *
670      * _Available since v3.4._
671      */
672     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
673         unchecked {
674             if (b == 0) return (false, 0);
675             return (true, a % b);
676         }
677     }
678 
679     /**
680      * @dev Returns the addition of two unsigned integers, reverting on
681      * overflow.
682      *
683      * Counterpart to Solidity's `+` operator.
684      *
685      * Requirements:
686      *
687      * - Addition cannot overflow.
688      */
689     function add(uint256 a, uint256 b) internal pure returns (uint256) {
690         return a + b;
691     }
692 
693     /**
694      * @dev Returns the subtraction of two unsigned integers, reverting on
695      * overflow (when the result is negative).
696      *
697      * Counterpart to Solidity's `-` operator.
698      *
699      * Requirements:
700      *
701      * - Subtraction cannot overflow.
702      */
703     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
704         return a - b;
705     }
706 
707     /**
708      * @dev Returns the multiplication of two unsigned integers, reverting on
709      * overflow.
710      *
711      * Counterpart to Solidity's `*` operator.
712      *
713      * Requirements:
714      *
715      * - Multiplication cannot overflow.
716      */
717     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
718         return a * b;
719     }
720 
721     /**
722      * @dev Returns the integer division of two unsigned integers, reverting on
723      * division by zero. The result is rounded towards zero.
724      *
725      * Counterpart to Solidity's `/` operator.
726      *
727      * Requirements:
728      *
729      * - The divisor cannot be zero.
730      */
731     function div(uint256 a, uint256 b) internal pure returns (uint256) {
732         return a / b;
733     }
734 
735     /**
736      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
737      * reverting when dividing by zero.
738      *
739      * Counterpart to Solidity's `%` operator. This function uses a `revert`
740      * opcode (which leaves remaining gas untouched) while Solidity uses an
741      * invalid opcode to revert (consuming all remaining gas).
742      *
743      * Requirements:
744      *
745      * - The divisor cannot be zero.
746      */
747     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
748         return a % b;
749     }
750 
751     /**
752      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
753      * overflow (when the result is negative).
754      *
755      * CAUTION: This function is deprecated because it requires allocating memory for the error
756      * message unnecessarily. For custom revert reasons use {trySub}.
757      *
758      * Counterpart to Solidity's `-` operator.
759      *
760      * Requirements:
761      *
762      * - Subtraction cannot overflow.
763      */
764     function sub(
765         uint256 a,
766         uint256 b,
767         string memory errorMessage
768     ) internal pure returns (uint256) {
769         unchecked {
770             require(b <= a, errorMessage);
771             return a - b;
772         }
773     }
774 
775     /**
776      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
777      * division by zero. The result is rounded towards zero.
778      *
779      * Counterpart to Solidity's `/` operator. Note: this function uses a
780      * `revert` opcode (which leaves remaining gas untouched) while Solidity
781      * uses an invalid opcode to revert (consuming all remaining gas).
782      *
783      * Requirements:
784      *
785      * - The divisor cannot be zero.
786      */
787     function div(
788         uint256 a,
789         uint256 b,
790         string memory errorMessage
791     ) internal pure returns (uint256) {
792         unchecked {
793             require(b > 0, errorMessage);
794             return a / b;
795         }
796     }
797 
798     /**
799      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
800      * reverting with custom message when dividing by zero.
801      *
802      * CAUTION: This function is deprecated because it requires allocating memory for the error
803      * message unnecessarily. For custom revert reasons use {tryMod}.
804      *
805      * Counterpart to Solidity's `%` operator. This function uses a `revert`
806      * opcode (which leaves remaining gas untouched) while Solidity uses an
807      * invalid opcode to revert (consuming all remaining gas).
808      *
809      * Requirements:
810      *
811      * - The divisor cannot be zero.
812      */
813     function mod(
814         uint256 a,
815         uint256 b,
816         string memory errorMessage
817     ) internal pure returns (uint256) {
818         unchecked {
819             require(b > 0, errorMessage);
820             return a % b;
821         }
822     }
823 }
824 
825 /* pragma solidity 0.8.10; */
826 /* pragma experimental ABIEncoderV2; */
827 
828 interface IUniswapV2Factory {
829     event PairCreated(
830         address indexed token0,
831         address indexed token1,
832         address pair,
833         uint256
834     );
835 
836     function feeTo() external view returns (address);
837 
838     function feeToSetter() external view returns (address);
839 
840     function getPair(address tokenA, address tokenB)
841         external
842         view
843         returns (address pair);
844 
845     function allPairs(uint256) external view returns (address pair);
846 
847     function allPairsLength() external view returns (uint256);
848 
849     function createPair(address tokenA, address tokenB)
850         external
851         returns (address pair);
852 
853     function setFeeTo(address) external;
854 
855     function setFeeToSetter(address) external;
856 }
857 
858 /* pragma solidity 0.8.10; */
859 /* pragma experimental ABIEncoderV2; */
860 
861 interface IUniswapV2Pair {
862     event Approval(
863         address indexed owner,
864         address indexed spender,
865         uint256 value
866     );
867     event Transfer(address indexed from, address indexed to, uint256 value);
868 
869     function name() external pure returns (string memory);
870 
871     function symbol() external pure returns (string memory);
872 
873     function decimals() external pure returns (uint8);
874 
875     function totalSupply() external view returns (uint256);
876 
877     function balanceOf(address owner) external view returns (uint256);
878 
879     function allowance(address owner, address spender)
880         external
881         view
882         returns (uint256);
883 
884     function approve(address spender, uint256 value) external returns (bool);
885 
886     function transfer(address to, uint256 value) external returns (bool);
887 
888     function transferFrom(
889         address from,
890         address to,
891         uint256 value
892     ) external returns (bool);
893 
894     function DOMAIN_SEPARATOR() external view returns (bytes32);
895 
896     function PERMIT_TYPEHASH() external pure returns (bytes32);
897 
898     function nonces(address owner) external view returns (uint256);
899 
900     function permit(
901         address owner,
902         address spender,
903         uint256 value,
904         uint256 deadline,
905         uint8 v,
906         bytes32 r,
907         bytes32 s
908     ) external;
909 
910     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
911     event Burn(
912         address indexed sender,
913         uint256 amount0,
914         uint256 amount1,
915         address indexed to
916     );
917     event Swap(
918         address indexed sender,
919         uint256 amount0In,
920         uint256 amount1In,
921         uint256 amount0Out,
922         uint256 amount1Out,
923         address indexed to
924     );
925     event Sync(uint112 reserve0, uint112 reserve1);
926 
927     function MINIMUM_LIQUIDITY() external pure returns (uint256);
928 
929     function factory() external view returns (address);
930 
931     function token0() external view returns (address);
932 
933     function token1() external view returns (address);
934 
935     function getReserves()
936         external
937         view
938         returns (
939             uint112 reserve0,
940             uint112 reserve1,
941             uint32 blockTimestampLast
942         );
943 
944     function price0CumulativeLast() external view returns (uint256);
945 
946     function price1CumulativeLast() external view returns (uint256);
947 
948     function kLast() external view returns (uint256);
949 
950     function mint(address to) external returns (uint256 liquidity);
951 
952     function burn(address to)
953         external
954         returns (uint256 amount0, uint256 amount1);
955 
956     function swap(
957         uint256 amount0Out,
958         uint256 amount1Out,
959         address to,
960         bytes calldata data
961     ) external;
962 
963     function skim(address to) external;
964 
965     function sync() external;
966 
967     function initialize(address, address) external;
968 }
969 
970 /* pragma solidity 0.8.10; */
971 /* pragma experimental ABIEncoderV2; */
972 
973 interface IUniswapV2Router02 {
974     function factory() external pure returns (address);
975 
976     function WETH() external pure returns (address);
977 
978     function addLiquidity(
979         address tokenA,
980         address tokenB,
981         uint256 amountADesired,
982         uint256 amountBDesired,
983         uint256 amountAMin,
984         uint256 amountBMin,
985         address to,
986         uint256 deadline
987     )
988         external
989         returns (
990             uint256 amountA,
991             uint256 amountB,
992             uint256 liquidity
993         );
994 
995     function addLiquidityETH(
996         address token,
997         uint256 amountTokenDesired,
998         uint256 amountTokenMin,
999         uint256 amountETHMin,
1000         address to,
1001         uint256 deadline
1002     )
1003         external
1004         payable
1005         returns (
1006             uint256 amountToken,
1007             uint256 amountETH,
1008             uint256 liquidity
1009         );
1010 
1011     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1012         uint256 amountIn,
1013         uint256 amountOutMin,
1014         address[] calldata path,
1015         address to,
1016         uint256 deadline
1017     ) external;
1018 
1019     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1020         uint256 amountOutMin,
1021         address[] calldata path,
1022         address to,
1023         uint256 deadline
1024     ) external payable;
1025 
1026     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1027         uint256 amountIn,
1028         uint256 amountOutMin,
1029         address[] calldata path,
1030         address to,
1031         uint256 deadline
1032     ) external;
1033 }
1034 
1035 /* pragma solidity >=0.8.10; */
1036 
1037 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1038 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1039 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1040 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1041 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1042 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1043 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1044 
1045 contract FLOXI is ERC20, Ownable {
1046     using SafeMath for uint256;
1047 
1048     IUniswapV2Router02 public immutable uniswapV2Router;
1049     address public immutable uniswapV2Pair;
1050     address public constant deadAddress = address(0xdead);
1051 
1052     bool private swapping;
1053 
1054 	address public charityWallet;
1055     address public marketingWallet;
1056     address public devWallet;
1057 
1058     uint256 public maxTransactionAmount;
1059     uint256 public swapTokensAtAmount;
1060     uint256 public maxWallet;
1061 
1062     bool public limitsInEffect = true;
1063     bool public tradingActive = true;
1064     bool public swapEnabled = true;
1065 
1066     // Anti-bot and anti-whale mappings and variables
1067     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1068     bool public transferDelayEnabled = true;
1069 
1070     uint256 public buyTotalFees;
1071 	uint256 public buyCharityFee;
1072     uint256 public buyMarketingFee;
1073     uint256 public buyLiquidityFee;
1074     uint256 public buyDevFee;
1075 
1076     uint256 public sellTotalFees;
1077 	uint256 public sellCharityFee;
1078     uint256 public sellMarketingFee;
1079     uint256 public sellLiquidityFee;
1080     uint256 public sellDevFee;
1081 
1082 	uint256 public tokensForCharity;
1083     uint256 public tokensForMarketing;
1084     uint256 public tokensForLiquidity;
1085     uint256 public tokensForDev;
1086 
1087     /******************/
1088 
1089     // exlcude from fees and max transaction amount
1090     mapping(address => bool) private _isExcludedFromFees;
1091     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1092 
1093     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1094     // could be subject to a maximum transfer amount
1095     mapping(address => bool) public automatedMarketMakerPairs;
1096 
1097     event UpdateUniswapV2Router(
1098         address indexed newAddress,
1099         address indexed oldAddress
1100     );
1101 
1102     event ExcludeFromFees(address indexed account, bool isExcluded);
1103 
1104     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1105 
1106     event SwapAndLiquify(
1107         uint256 tokensSwapped,
1108         uint256 ethReceived,
1109         uint256 tokensIntoLiquidity
1110     );
1111 
1112     constructor() ERC20("FLOXI", "FLOXI") {
1113         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1114             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1115         );
1116 
1117         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1118         uniswapV2Router = _uniswapV2Router;
1119 
1120         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1121             .createPair(address(this), _uniswapV2Router.WETH());
1122         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1123         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1124 
1125 		uint256 _buyCharityFee = 0;
1126         uint256 _buyMarketingFee = 0;
1127         uint256 _buyLiquidityFee = 0;
1128         uint256 _buyDevFee = 10;
1129 
1130 		uint256 _sellCharityFee = 0;
1131         uint256 _sellMarketingFee = 0;
1132         uint256 _sellLiquidityFee = 0;
1133         uint256 _sellDevFee = 25;
1134 
1135         uint256 totalSupply = 5000000000000 * 1e18;
1136 
1137         maxTransactionAmount = 25000000000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1138         maxWallet = 50000000000 * 1e18; // 2% from total supply maxWallet
1139         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1140 
1141 		buyCharityFee = _buyCharityFee;
1142         buyMarketingFee = _buyMarketingFee;
1143         buyLiquidityFee = _buyLiquidityFee;
1144         buyDevFee = _buyDevFee;
1145         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1146 
1147 		sellCharityFee = _sellCharityFee;
1148         sellMarketingFee = _sellMarketingFee;
1149         sellLiquidityFee = _sellLiquidityFee;
1150         sellDevFee = _sellDevFee;
1151         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1152 
1153 		charityWallet = address(0xa99c602037f8E85A44bbe88f3C0EE3Af60345B9b); // Floki
1154         marketingWallet = address(0xd8Dbc1CBa6Ae2aaa5f2227D4217901aC4A2d5525); // Flona
1155         devWallet = address(0x5380Ab70BAD2B6Ca522D6d52BBEc542e055834FF); // set as dev wallet
1156 
1157         // exclude from paying fees or having max transaction amount
1158         excludeFromFees(owner(), true);
1159         excludeFromFees(address(this), true);
1160         excludeFromFees(address(0xdead), true);
1161 
1162         excludeFromMaxTransaction(owner(), true);
1163         excludeFromMaxTransaction(address(this), true);
1164         excludeFromMaxTransaction(address(0xdead), true);
1165 
1166         /*
1167             _mint is an internal function in ERC20.sol that is only called here,
1168             and CANNOT be called ever again
1169         */
1170         _mint(msg.sender, totalSupply);
1171     }
1172 
1173     receive() external payable {}
1174 
1175     // once enabled, can never be turned off
1176     function enableTrading() external onlyOwner {
1177         tradingActive = true;
1178         swapEnabled = true;
1179     }
1180 
1181     // remove limits after token is stable
1182     function removeLimits() external onlyOwner returns (bool) {
1183         limitsInEffect = false;
1184         return true;
1185     }
1186 
1187     // disable Transfer delay - cannot be reenabled
1188     function disableTransferDelay() external onlyOwner returns (bool) {
1189         transferDelayEnabled = false;
1190         return true;
1191     }
1192 
1193     // change the minimum amount of tokens to sell from fees
1194     function updateSwapTokensAtAmount(uint256 newAmount)
1195         external
1196         onlyOwner
1197         returns (bool)
1198     {
1199         require(
1200             newAmount >= (totalSupply() * 1) / 100000,
1201             "Swap amount cannot be lower than 0.001% total supply."
1202         );
1203         require(
1204             newAmount <= (totalSupply() * 5) / 1000,
1205             "Swap amount cannot be higher than 0.5% total supply."
1206         );
1207         swapTokensAtAmount = newAmount;
1208         return true;
1209     }
1210 
1211     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1212         require(
1213             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1214             "Cannot set maxTransactionAmount lower than 0.5%"
1215         );
1216         maxTransactionAmount = newNum * (10**18);
1217     }
1218 
1219     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1220         require(
1221             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1222             "Cannot set maxWallet lower than 0.5%"
1223         );
1224         maxWallet = newNum * (10**18);
1225     }
1226 	
1227     function excludeFromMaxTransaction(address updAds, bool isEx)
1228         public
1229         onlyOwner
1230     {
1231         _isExcludedMaxTransactionAmount[updAds] = isEx;
1232     }
1233 
1234     // only use to disable contract sales if absolutely necessary (emergency use only)
1235     function updateSwapEnabled(bool enabled) external onlyOwner {
1236         swapEnabled = enabled;
1237     }
1238 
1239     function updateBuyFees(
1240 		uint256 _charityFee,
1241         uint256 _marketingFee,
1242         uint256 _liquidityFee,
1243         uint256 _devFee
1244     ) external onlyOwner {
1245 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max BuyFee 10%");
1246 		buyCharityFee = _charityFee;
1247         buyMarketingFee = _marketingFee;
1248         buyLiquidityFee = _liquidityFee;
1249         buyDevFee = _devFee;
1250         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1251      }
1252 
1253     function updateSellFees(
1254 		uint256 _charityFee,
1255         uint256 _marketingFee,
1256         uint256 _liquidityFee,
1257         uint256 _devFee
1258     ) external onlyOwner {
1259 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max SellFee 10%");
1260 		sellCharityFee = _charityFee;
1261         sellMarketingFee = _marketingFee;
1262         sellLiquidityFee = _liquidityFee;
1263         sellDevFee = _devFee;
1264         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
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
1290     function isExcludedFromFees(address account) public view returns (bool) {
1291         return _isExcludedFromFees[account];
1292     }
1293 
1294     function _transfer(
1295         address from,
1296         address to,
1297         uint256 amount
1298     ) internal override {
1299         require(from != address(0), "ERC20: transfer from the zero address");
1300         require(to != address(0), "ERC20: transfer to the zero address");
1301 
1302         if (amount == 0) {
1303             super._transfer(from, to, 0);
1304             return;
1305         }
1306 
1307         if (limitsInEffect) {
1308             if (
1309                 from != owner() &&
1310                 to != owner() &&
1311                 to != address(0) &&
1312                 to != address(0xdead) &&
1313                 !swapping
1314             ) {
1315                 if (!tradingActive) {
1316                     require(
1317                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1318                         "Trading is not active."
1319                     );
1320                 }
1321 
1322                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1323                 if (transferDelayEnabled) {
1324                     if (
1325                         to != owner() &&
1326                         to != address(uniswapV2Router) &&
1327                         to != address(uniswapV2Pair)
1328                     ) {
1329                         require(
1330                             _holderLastTransferTimestamp[tx.origin] <
1331                                 block.number,
1332                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1333                         );
1334                         _holderLastTransferTimestamp[tx.origin] = block.number;
1335                     }
1336                 }
1337 
1338                 //when buy
1339                 if (
1340                     automatedMarketMakerPairs[from] &&
1341                     !_isExcludedMaxTransactionAmount[to]
1342                 ) {
1343                     require(
1344                         amount <= maxTransactionAmount,
1345                         "Buy transfer amount exceeds the maxTransactionAmount."
1346                     );
1347                     require(
1348                         amount + balanceOf(to) <= maxWallet,
1349                         "Max wallet exceeded"
1350                     );
1351                 }
1352                 //when sell
1353                 else if (
1354                     automatedMarketMakerPairs[to] &&
1355                     !_isExcludedMaxTransactionAmount[from]
1356                 ) {
1357                     require(
1358                         amount <= maxTransactionAmount,
1359                         "Sell transfer amount exceeds the maxTransactionAmount."
1360                     );
1361                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1362                     require(
1363                         amount + balanceOf(to) <= maxWallet,
1364                         "Max wallet exceeded"
1365                     );
1366                 }
1367             }
1368         }
1369 
1370         uint256 contractTokenBalance = balanceOf(address(this));
1371 
1372         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1373 
1374         if (
1375             canSwap &&
1376             swapEnabled &&
1377             !swapping &&
1378             !automatedMarketMakerPairs[from] &&
1379             !_isExcludedFromFees[from] &&
1380             !_isExcludedFromFees[to]
1381         ) {
1382             swapping = true;
1383 
1384             swapBack();
1385 
1386             swapping = false;
1387         }
1388 
1389         bool takeFee = !swapping;
1390 
1391         // if any account belongs to _isExcludedFromFee account then remove the fee
1392         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1393             takeFee = false;
1394         }
1395 
1396         uint256 fees = 0;
1397         // only take fees on buys/sells, do not take on wallet transfers
1398         if (takeFee) {
1399             // on sell
1400             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1401                 fees = amount.mul(sellTotalFees).div(100);
1402 				tokensForCharity += (fees * sellCharityFee) / sellTotalFees;
1403                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1404                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1405                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1406             }
1407             // on buy
1408             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1409                 fees = amount.mul(buyTotalFees).div(100);
1410 				tokensForCharity += (fees * buyCharityFee) / buyTotalFees;
1411                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1412                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1413                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1414             }
1415 
1416             if (fees > 0) {
1417                 super._transfer(from, address(this), fees);
1418             }
1419 
1420             amount -= fees;
1421         }
1422 
1423         super._transfer(from, to, amount);
1424     }
1425 
1426     function swapTokensForEth(uint256 tokenAmount) private {
1427         // generate the uniswap pair path of token -> weth
1428         address[] memory path = new address[](2);
1429         path[0] = address(this);
1430         path[1] = uniswapV2Router.WETH();
1431 
1432         _approve(address(this), address(uniswapV2Router), tokenAmount);
1433 
1434         // make the swap
1435         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1436             tokenAmount,
1437             0, // accept any amount of ETH
1438             path,
1439             address(this),
1440             block.timestamp
1441         );
1442     }
1443 
1444     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1445         // approve token transfer to cover all possible scenarios
1446         _approve(address(this), address(uniswapV2Router), tokenAmount);
1447 
1448         // add the liquidity
1449         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1450             address(this),
1451             tokenAmount,
1452             0, // slippage is unavoidable
1453             0, // slippage is unavoidable
1454             devWallet,
1455             block.timestamp
1456         );
1457     }
1458 
1459     function swapBack() private {
1460         uint256 contractBalance = balanceOf(address(this));
1461         uint256 totalTokensToSwap = tokensForCharity + tokensForLiquidity + tokensForMarketing + tokensForDev;
1462         bool success;
1463 
1464         if (contractBalance == 0 || totalTokensToSwap == 0) {
1465             return;
1466         }
1467 
1468         if (contractBalance > swapTokensAtAmount * 20) {
1469             contractBalance = swapTokensAtAmount * 20;
1470         }
1471 
1472         // Halve the amount of liquidity tokens
1473         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1474         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1475 
1476         uint256 initialETHBalance = address(this).balance;
1477 
1478         swapTokensForEth(amountToSwapForETH);
1479 
1480         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1481 
1482 		uint256 ethForCharity = ethBalance.mul(tokensForCharity).div(totalTokensToSwap);
1483         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1484         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1485 
1486         uint256 ethForLiquidity = ethBalance - ethForCharity - ethForMarketing - ethForDev;
1487 
1488         tokensForLiquidity = 0;
1489 		tokensForCharity = 0;
1490         tokensForMarketing = 0;
1491         tokensForDev = 0;
1492 
1493         (success, ) = address(devWallet).call{value: ethForDev}("");
1494         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1495 
1496 
1497         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1498             addLiquidity(liquidityTokens, ethForLiquidity);
1499             emit SwapAndLiquify(
1500                 amountToSwapForETH,
1501                 ethForLiquidity,
1502                 tokensForLiquidity
1503             );
1504         }
1505 
1506         (success, ) = address(charityWallet).call{value: address(this).balance}("");
1507     }
1508 
1509 }