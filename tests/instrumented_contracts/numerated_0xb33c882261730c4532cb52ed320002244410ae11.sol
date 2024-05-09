1 /**
2  * @dev Provides information about the current execution context, including the
3  * sender of the transaction and its data. While these are generally available
4  * via msg.sender and msg.data, they should not be accessed in such a direct
5  * manner, since when dealing with meta-transactions the account sending and
6  * paying for execution may not be the actual sender (as far as an application
7  * is concerned).
8  *
9  * This contract is only required for intermediate, library-like contracts.
10  */
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         return msg.data;
18     }
19 }
20 
21 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
22 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
23 
24 /* pragma solidity ^0.8.0; */
25 
26 /* import "../utils/Context.sol"; */
27 
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor() {
49         _transferOwnership(_msgSender());
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view virtual returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(owner() == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public virtual onlyOwner {
75         _transferOwnership(address(0));
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         _transferOwnership(newOwner);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Internal function without access restriction.
90      */
91     function _transferOwnership(address newOwner) internal virtual {
92         address oldOwner = _owner;
93         _owner = newOwner;
94         emit OwnershipTransferred(oldOwner, newOwner);
95     }
96 }
97 
98 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
99 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
100 
101 /* pragma solidity ^0.8.0; */
102 
103 /**
104  * @dev Interface of the ERC20 standard as defined in the EIP.
105  */
106 interface IERC20 {
107     /**
108      * @dev Returns the amount of tokens in existence.
109      */
110     function totalSupply() external view returns (uint256);
111 
112     /**
113      * @dev Returns the amount of tokens owned by `account`.
114      */
115     function balanceOf(address account) external view returns (uint256);
116 
117     /**
118      * @dev Moves `amount` tokens from the caller's account to `recipient`.
119      *
120      * Returns a boolean value indicating whether the operation succeeded.
121      *
122      * Emits a {Transfer} event.
123      */
124     function transfer(address recipient, uint256 amount) external returns (bool);
125 
126     /**
127      * @dev Returns the remaining number of tokens that `spender` will be
128      * allowed to spend on behalf of `owner` through {transferFrom}. This is
129      * zero by default.
130      *
131      * This value changes when {approve} or {transferFrom} are called.
132      */
133     function allowance(address owner, address spender) external view returns (uint256);
134 
135     /**
136      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * IMPORTANT: Beware that changing an allowance with this method brings the risk
141      * that someone may use both the old and the new allowance by unfortunate
142      * transaction ordering. One possible solution to mitigate this race
143      * condition is to first reduce the spender's allowance to 0 and set the
144      * desired value afterwards:
145      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146      *
147      * Emits an {Approval} event.
148      */
149     function approve(address spender, uint256 amount) external returns (bool);
150 
151     /**
152      * @dev Moves `amount` tokens from `sender` to `recipient` using the
153      * allowance mechanism. `amount` is then deducted from the caller's
154      * allowance.
155      *
156      * Returns a boolean value indicating whether the operation succeeded.
157      *
158      * Emits a {Transfer} event.
159      */
160     function transferFrom(
161         address sender,
162         address recipient,
163         uint256 amount
164     ) external returns (bool);
165 
166     /**
167      * @dev Emitted when `value` tokens are moved from one account (`from`) to
168      * another (`to`).
169      *
170      * Note that `value` may be zero.
171      */
172     event Transfer(address indexed from, address indexed to, uint256 value);
173 
174     /**
175      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
176      * a call to {approve}. `value` is the new allowance.
177      */
178     event Approval(address indexed owner, address indexed spender, uint256 value);
179 }
180 
181 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
182 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
183 
184 /* pragma solidity ^0.8.0; */
185 
186 /* import "../IERC20.sol"; */
187 
188 /**
189  * @dev Interface for the optional metadata functions from the ERC20 standard.
190  *
191  * _Available since v4.1._
192  */
193 interface IERC20Metadata is IERC20 {
194     /**
195      * @dev Returns the name of the token.
196      */
197     function name() external view returns (string memory);
198 
199     /**
200      * @dev Returns the symbol of the token.
201      */
202     function symbol() external view returns (string memory);
203 
204     /**
205      * @dev Returns the decimals places of the token.
206      */
207     function decimals() external view returns (uint8);
208 }
209 
210 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
211 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
212 
213 /* pragma solidity ^0.8.0; */
214 
215 /* import "./IERC20.sol"; */
216 /* import "./extensions/IERC20Metadata.sol"; */
217 /* import "../../utils/Context.sol"; */
218 
219 /**
220  * @dev Implementation of the {IERC20} interface.
221  *
222  * This implementation is agnostic to the way tokens are created. This means
223  * that a supply mechanism has to be added in a derived contract using {_mint}.
224  * For a generic mechanism see {ERC20PresetMinterPauser}.
225  *
226  * TIP: For a detailed writeup see our guide
227  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
228  * to implement supply mechanisms].
229  *
230  * We have followed general OpenZeppelin Contracts guidelines: functions revert
231  * instead returning `false` on failure. This behavior is nonetheless
232  * conventional and does not conflict with the expectations of ERC20
233  * applications.
234  *
235  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
236  * This allows applications to reconstruct the allowance for all accounts just
237  * by listening to said events. Other implementations of the EIP may not emit
238  * these events, as it isn't required by the specification.
239  *
240  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
241  * functions have been added to mitigate the well-known issues around setting
242  * allowances. See {IERC20-approve}.
243  */
244 contract ERC20 is Context, IERC20, IERC20Metadata {
245     mapping(address => uint256) private _balances;
246 
247     mapping(address => mapping(address => uint256)) private _allowances;
248 
249     uint256 private _totalSupply;
250 
251     string private _name;
252     string private _symbol;
253 
254     /**
255      * @dev Sets the values for {name} and {symbol}.
256      *
257      * The default value of {decimals} is 18. To select a different value for
258      * {decimals} you should overload it.
259      *
260      * All two of these values are immutable: they can only be set once during
261      * construction.
262      */
263     constructor(string memory name_, string memory symbol_) {
264         _name = name_;
265         _symbol = symbol_;
266     }
267 
268     /**
269      * @dev Returns the name of the token.
270      */
271     function name() public view virtual override returns (string memory) {
272         return _name;
273     }
274 
275     /**
276      * @dev Returns the symbol of the token, usually a shorter version of the
277      * name.
278      */
279     function symbol() public view virtual override returns (string memory) {
280         return _symbol;
281     }
282 
283     /**
284      * @dev Returns the number of decimals used to get its user representation.
285      * For example, if `decimals` equals `2`, a balance of `505` tokens should
286      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
287      *
288      * Tokens usually opt for a value of 18, imitating the relationship between
289      * Ether and Wei. This is the value {ERC20} uses, unless this function is
290      * overridden;
291      *
292      * NOTE: This information is only used for _display_ purposes: it in
293      * no way affects any of the arithmetic of the contract, including
294      * {IERC20-balanceOf} and {IERC20-transfer}.
295      */
296     function decimals() public view virtual override returns (uint8) {
297         return 18;
298     }
299 
300     /**
301      * @dev See {IERC20-totalSupply}.
302      */
303     function totalSupply() public view virtual override returns (uint256) {
304         return _totalSupply;
305     }
306 
307     /**
308      * @dev See {IERC20-balanceOf}.
309      */
310     function balanceOf(address account) public view virtual override returns (uint256) {
311         return _balances[account];
312     }
313 
314     /**
315      * @dev See {IERC20-transfer}.
316      *
317      * Requirements:
318      *
319      * - `recipient` cannot be the zero address.
320      * - the caller must have a balance of at least `amount`.
321      */
322     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
323         _transfer(_msgSender(), recipient, amount);
324         return true;
325     }
326 
327     /**
328      * @dev See {IERC20-allowance}.
329      */
330     function allowance(address owner, address spender) public view virtual override returns (uint256) {
331         return _allowances[owner][spender];
332     }
333 
334     /**
335      * @dev See {IERC20-approve}.
336      *
337      * Requirements:
338      *
339      * - `spender` cannot be the zero address.
340      */
341     function approve(address spender, uint256 amount) public virtual override returns (bool) {
342         _approve(_msgSender(), spender, amount);
343         return true;
344     }
345 
346     /**
347      * @dev See {IERC20-transferFrom}.
348      *
349      * Emits an {Approval} event indicating the updated allowance. This is not
350      * required by the EIP. See the note at the beginning of {ERC20}.
351      *
352      * Requirements:
353      *
354      * - `sender` and `recipient` cannot be the zero address.
355      * - `sender` must have a balance of at least `amount`.
356      * - the caller must have allowance for ``sender``'s tokens of at least
357      * `amount`.
358      */
359     function transferFrom(
360         address sender,
361         address recipient,
362         uint256 amount
363     ) public virtual override returns (bool) {
364         _transfer(sender, recipient, amount);
365 
366         uint256 currentAllowance = _allowances[sender][_msgSender()];
367         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
368         unchecked {
369             _approve(sender, _msgSender(), currentAllowance - amount);
370         }
371 
372         return true;
373     }
374 
375     /**
376      * @dev Atomically increases the allowance granted to `spender` by the caller.
377      *
378      * This is an alternative to {approve} that can be used as a mitigation for
379      * problems described in {IERC20-approve}.
380      *
381      * Emits an {Approval} event indicating the updated allowance.
382      *
383      * Requirements:
384      *
385      * - `spender` cannot be the zero address.
386      */
387     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
388         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
389         return true;
390     }
391 
392     /**
393      * @dev Atomically decreases the allowance granted to `spender` by the caller.
394      *
395      * This is an alternative to {approve} that can be used as a mitigation for
396      * problems described in {IERC20-approve}.
397      *
398      * Emits an {Approval} event indicating the updated allowance.
399      *
400      * Requirements:
401      *
402      * - `spender` cannot be the zero address.
403      * - `spender` must have allowance for the caller of at least
404      * `subtractedValue`.
405      */
406     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
407         uint256 currentAllowance = _allowances[_msgSender()][spender];
408         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
409         unchecked {
410             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
411         }
412 
413         return true;
414     }
415 
416     /**
417      * @dev Moves `amount` of tokens from `sender` to `recipient`.
418      *
419      * This internal function is equivalent to {transfer}, and can be used to
420      * e.g. implement automatic token fees, slashing mechanisms, etc.
421      *
422      * Emits a {Transfer} event.
423      *
424      * Requirements:
425      *
426      * - `sender` cannot be the zero address.
427      * - `recipient` cannot be the zero address.
428      * - `sender` must have a balance of at least `amount`.
429      */
430     function _transfer(
431         address sender,
432         address recipient,
433         uint256 amount
434     ) internal virtual {
435         require(sender != address(0), "ERC20: transfer from the zero address");
436         require(recipient != address(0), "ERC20: transfer to the zero address");
437 
438         _beforeTokenTransfer(sender, recipient, amount);
439 
440         uint256 senderBalance = _balances[sender];
441         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
442         unchecked {
443             _balances[sender] = senderBalance - amount;
444         }
445         _balances[recipient] += amount;
446 
447         emit Transfer(sender, recipient, amount);
448 
449         _afterTokenTransfer(sender, recipient, amount);
450     }
451 
452     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
453      * the total supply.
454      *
455      * Emits a {Transfer} event with `from` set to the zero address.
456      *
457      * Requirements:
458      *
459      * - `account` cannot be the zero address.
460      */
461     function _mint(address account, uint256 amount) internal virtual {
462         require(account != address(0), "ERC20: mint to the zero address");
463 
464         _beforeTokenTransfer(address(0), account, amount);
465 
466         _totalSupply += amount;
467         _balances[account] += amount;
468         emit Transfer(address(0), account, amount);
469 
470         _afterTokenTransfer(address(0), account, amount);
471     }
472 
473     /**
474      * @dev Destroys `amount` tokens from `account`, reducing the
475      * total supply.
476      *
477      * Emits a {Transfer} event with `to` set to the zero address.
478      *
479      * Requirements:
480      *
481      * - `account` cannot be the zero address.
482      * - `account` must have at least `amount` tokens.
483      */
484     function _burn(address account, uint256 amount) internal virtual {
485         require(account != address(0), "ERC20: burn from the zero address");
486 
487         _beforeTokenTransfer(account, address(0), amount);
488 
489         uint256 accountBalance = _balances[account];
490         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
491         unchecked {
492             _balances[account] = accountBalance - amount;
493         }
494         _totalSupply -= amount;
495 
496         emit Transfer(account, address(0), amount);
497 
498         _afterTokenTransfer(account, address(0), amount);
499     }
500 
501     /**
502      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
503      *
504      * This internal function is equivalent to `approve`, and can be used to
505      * e.g. set automatic allowances for certain subsystems, etc.
506      *
507      * Emits an {Approval} event.
508      *
509      * Requirements:
510      *
511      * - `owner` cannot be the zero address.
512      * - `spender` cannot be the zero address.
513      */
514     function _approve(
515         address owner,
516         address spender,
517         uint256 amount
518     ) internal virtual {
519         require(owner != address(0), "ERC20: approve from the zero address");
520         require(spender != address(0), "ERC20: approve to the zero address");
521 
522         _allowances[owner][spender] = amount;
523         emit Approval(owner, spender, amount);
524     }
525 
526     /**
527      * @dev Hook that is called before any transfer of tokens. This includes
528      * minting and burning.
529      *
530      * Calling conditions:
531      *
532      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
533      * will be transferred to `to`.
534      * - when `from` is zero, `amount` tokens will be minted for `to`.
535      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
536      * - `from` and `to` are never both zero.
537      *
538      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
539      */
540     function _beforeTokenTransfer(
541         address from,
542         address to,
543         uint256 amount
544     ) internal virtual {}
545 
546     /**
547      * @dev Hook that is called after any transfer of tokens. This includes
548      * minting and burning.
549      *
550      * Calling conditions:
551      *
552      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
553      * has been transferred to `to`.
554      * - when `from` is zero, `amount` tokens have been minted for `to`.
555      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
556      * - `from` and `to` are never both zero.
557      *
558      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
559      */
560     function _afterTokenTransfer(
561         address from,
562         address to,
563         uint256 amount
564     ) internal virtual {}
565 }
566 
567 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
568 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
569 
570 /* pragma solidity ^0.8.0; */
571 
572 // CAUTION
573 // This version of SafeMath should only be used with Solidity 0.8 or later,
574 // because it relies on the compiler's built in overflow checks.
575 
576 /**
577  * @dev Wrappers over Solidity's arithmetic operations.
578  *
579  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
580  * now has built in overflow checking.
581  */
582 library SafeMath {
583     /**
584      * @dev Returns the addition of two unsigned integers, with an overflow flag.
585      *
586      * _Available since v3.4._
587      */
588     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
589         unchecked {
590             uint256 c = a + b;
591             if (c < a) return (false, 0);
592             return (true, c);
593         }
594     }
595 
596     /**
597      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
598      *
599      * _Available since v3.4._
600      */
601     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
602         unchecked {
603             if (b > a) return (false, 0);
604             return (true, a - b);
605         }
606     }
607 
608     /**
609      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
610      *
611      * _Available since v3.4._
612      */
613     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
614         unchecked {
615             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
616             // benefit is lost if 'b' is also tested.
617             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
618             if (a == 0) return (true, 0);
619             uint256 c = a * b;
620             if (c / a != b) return (false, 0);
621             return (true, c);
622         }
623     }
624 
625     /**
626      * @dev Returns the division of two unsigned integers, with a division by zero flag.
627      *
628      * _Available since v3.4._
629      */
630     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
631         unchecked {
632             if (b == 0) return (false, 0);
633             return (true, a / b);
634         }
635     }
636 
637     /**
638      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
639      *
640      * _Available since v3.4._
641      */
642     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
643         unchecked {
644             if (b == 0) return (false, 0);
645             return (true, a % b);
646         }
647     }
648 
649     /**
650      * @dev Returns the addition of two unsigned integers, reverting on
651      * overflow.
652      *
653      * Counterpart to Solidity's `+` operator.
654      *
655      * Requirements:
656      *
657      * - Addition cannot overflow.
658      */
659     function add(uint256 a, uint256 b) internal pure returns (uint256) {
660         return a + b;
661     }
662 
663     /**
664      * @dev Returns the subtraction of two unsigned integers, reverting on
665      * overflow (when the result is negative).
666      *
667      * Counterpart to Solidity's `-` operator.
668      *
669      * Requirements:
670      *
671      * - Subtraction cannot overflow.
672      */
673     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
674         return a - b;
675     }
676 
677     /**
678      * @dev Returns the multiplication of two unsigned integers, reverting on
679      * overflow.
680      *
681      * Counterpart to Solidity's `*` operator.
682      *
683      * Requirements:
684      *
685      * - Multiplication cannot overflow.
686      */
687     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
688         return a * b;
689     }
690 
691     /**
692      * @dev Returns the integer division of two unsigned integers, reverting on
693      * division by zero. The result is rounded towards zero.
694      *
695      * Counterpart to Solidity's `/` operator.
696      *
697      * Requirements:
698      *
699      * - The divisor cannot be zero.
700      */
701     function div(uint256 a, uint256 b) internal pure returns (uint256) {
702         return a / b;
703     }
704 
705     /**
706      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
707      * reverting when dividing by zero.
708      *
709      * Counterpart to Solidity's `%` operator. This function uses a `revert`
710      * opcode (which leaves remaining gas untouched) while Solidity uses an
711      * invalid opcode to revert (consuming all remaining gas).
712      *
713      * Requirements:
714      *
715      * - The divisor cannot be zero.
716      */
717     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
718         return a % b;
719     }
720 
721     /**
722      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
723      * overflow (when the result is negative).
724      *
725      * CAUTION: This function is deprecated because it requires allocating memory for the error
726      * message unnecessarily. For custom revert reasons use {trySub}.
727      *
728      * Counterpart to Solidity's `-` operator.
729      *
730      * Requirements:
731      *
732      * - Subtraction cannot overflow.
733      */
734     function sub(
735         uint256 a,
736         uint256 b,
737         string memory errorMessage
738     ) internal pure returns (uint256) {
739         unchecked {
740             require(b <= a, errorMessage);
741             return a - b;
742         }
743     }
744 
745     /**
746      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
747      * division by zero. The result is rounded towards zero.
748      *
749      * Counterpart to Solidity's `/` operator. Note: this function uses a
750      * `revert` opcode (which leaves remaining gas untouched) while Solidity
751      * uses an invalid opcode to revert (consuming all remaining gas).
752      *
753      * Requirements:
754      *
755      * - The divisor cannot be zero.
756      */
757     function div(
758         uint256 a,
759         uint256 b,
760         string memory errorMessage
761     ) internal pure returns (uint256) {
762         unchecked {
763             require(b > 0, errorMessage);
764             return a / b;
765         }
766     }
767 
768     /**
769      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
770      * reverting with custom message when dividing by zero.
771      *
772      * CAUTION: This function is deprecated because it requires allocating memory for the error
773      * message unnecessarily. For custom revert reasons use {tryMod}.
774      *
775      * Counterpart to Solidity's `%` operator. This function uses a `revert`
776      * opcode (which leaves remaining gas untouched) while Solidity uses an
777      * invalid opcode to revert (consuming all remaining gas).
778      *
779      * Requirements:
780      *
781      * - The divisor cannot be zero.
782      */
783     function mod(
784         uint256 a,
785         uint256 b,
786         string memory errorMessage
787     ) internal pure returns (uint256) {
788         unchecked {
789             require(b > 0, errorMessage);
790             return a % b;
791         }
792     }
793 }
794 
795 ////// src/IUniswapV2Factory.sol
796 /* pragma solidity 0.8.10; */
797 /* pragma experimental ABIEncoderV2; */
798 
799 interface IUniswapV2Factory {
800     event PairCreated(
801         address indexed token0,
802         address indexed token1,
803         address pair,
804         uint256
805     );
806 
807     function feeTo() external view returns (address);
808 
809     function feeToSetter() external view returns (address);
810 
811     function getPair(address tokenA, address tokenB)
812         external
813         view
814         returns (address pair);
815 
816     function allPairs(uint256) external view returns (address pair);
817 
818     function allPairsLength() external view returns (uint256);
819 
820     function createPair(address tokenA, address tokenB)
821         external
822         returns (address pair);
823 
824     function setFeeTo(address) external;
825 
826     function setFeeToSetter(address) external;
827 }
828 
829 ////// src/IUniswapV2Pair.sol
830 /* pragma solidity 0.8.10; */
831 /* pragma experimental ABIEncoderV2; */
832 
833 interface IUniswapV2Pair {
834     event Approval(
835         address indexed owner,
836         address indexed spender,
837         uint256 value
838     );
839     event Transfer(address indexed from, address indexed to, uint256 value);
840 
841     function name() external pure returns (string memory);
842 
843     function symbol() external pure returns (string memory);
844 
845     function decimals() external pure returns (uint8);
846 
847     function totalSupply() external view returns (uint256);
848 
849     function balanceOf(address owner) external view returns (uint256);
850 
851     function allowance(address owner, address spender)
852         external
853         view
854         returns (uint256);
855 
856     function approve(address spender, uint256 value) external returns (bool);
857 
858     function transfer(address to, uint256 value) external returns (bool);
859 
860     function transferFrom(
861         address from,
862         address to,
863         uint256 value
864     ) external returns (bool);
865 
866     function DOMAIN_SEPARATOR() external view returns (bytes32);
867 
868     function PERMIT_TYPEHASH() external pure returns (bytes32);
869 
870     function nonces(address owner) external view returns (uint256);
871 
872     function permit(
873         address owner,
874         address spender,
875         uint256 value,
876         uint256 deadline,
877         uint8 v,
878         bytes32 r,
879         bytes32 s
880     ) external;
881 
882     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
883     event Burn(
884         address indexed sender,
885         uint256 amount0,
886         uint256 amount1,
887         address indexed to
888     );
889     event Swap(
890         address indexed sender,
891         uint256 amount0In,
892         uint256 amount1In,
893         uint256 amount0Out,
894         uint256 amount1Out,
895         address indexed to
896     );
897     event Sync(uint112 reserve0, uint112 reserve1);
898 
899     function MINIMUM_LIQUIDITY() external pure returns (uint256);
900 
901     function factory() external view returns (address);
902 
903     function token0() external view returns (address);
904 
905     function token1() external view returns (address);
906 
907     function getReserves()
908         external
909         view
910         returns (
911             uint112 reserve0,
912             uint112 reserve1,
913             uint32 blockTimestampLast
914         );
915 
916     function price0CumulativeLast() external view returns (uint256);
917 
918     function price1CumulativeLast() external view returns (uint256);
919 
920     function kLast() external view returns (uint256);
921 
922     function mint(address to) external returns (uint256 liquidity);
923 
924     function burn(address to)
925         external
926         returns (uint256 amount0, uint256 amount1);
927 
928     function swap(
929         uint256 amount0Out,
930         uint256 amount1Out,
931         address to,
932         bytes calldata data
933     ) external;
934 
935     function skim(address to) external;
936 
937     function sync() external;
938 
939     function initialize(address, address) external;
940 }
941 
942 ////// src/IUniswapV2Router02.sol
943 /* pragma solidity 0.8.10; */
944 /* pragma experimental ABIEncoderV2; */
945 
946 interface IUniswapV2Router02 {
947     function factory() external pure returns (address);
948 
949     function WETH() external pure returns (address);
950 
951     function addLiquidity(
952         address tokenA,
953         address tokenB,
954         uint256 amountADesired,
955         uint256 amountBDesired,
956         uint256 amountAMin,
957         uint256 amountBMin,
958         address to,
959         uint256 deadline
960     )
961         external
962         returns (
963             uint256 amountA,
964             uint256 amountB,
965             uint256 liquidity
966         );
967 
968     function addLiquidityETH(
969         address token,
970         uint256 amountTokenDesired,
971         uint256 amountTokenMin,
972         uint256 amountETHMin,
973         address to,
974         uint256 deadline
975     )
976         external
977         payable
978         returns (
979             uint256 amountToken,
980             uint256 amountETH,
981             uint256 liquidity
982         );
983 
984     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
985         uint256 amountIn,
986         uint256 amountOutMin,
987         address[] calldata path,
988         address to,
989         uint256 deadline
990     ) external;
991 
992     function swapExactETHForTokensSupportingFeeOnTransferTokens(
993         uint256 amountOutMin,
994         address[] calldata path,
995         address to,
996         uint256 deadline
997     ) external payable;
998 
999     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1000         uint256 amountIn,
1001         uint256 amountOutMin,
1002         address[] calldata path,
1003         address to,
1004         uint256 deadline
1005     ) external;
1006 }
1007 
1008 
1009 contract MUNCH  is ERC20, Ownable {
1010     using SafeMath for uint256;
1011 
1012     IUniswapV2Router02 public immutable uniswapV2Router;
1013     address public immutable uniswapV2Pair;
1014     address public constant deadAddress = address(0xdead);
1015 
1016     bool private swapping;
1017 
1018     address public marketingWallet;
1019     address public devWallet;
1020 
1021     uint256 public maxTransactionAmount;
1022     uint256 public swapTokensAtAmount;
1023     uint256 public maxWallet;
1024 
1025     uint256 public percentForLPBurn = 25; 
1026     bool public lpBurnEnabled = true;
1027     uint256 public lpBurnFrequency = 3600 seconds;
1028     uint256 public lastLpBurnTime;
1029 
1030     uint256 public manualBurnFrequency = 30 minutes;
1031     uint256 public lastManualLpBurnTime;
1032 
1033     bool public limitsInEffect = true;
1034     bool public tradingActive = false;
1035     bool public swapEnabled = false;
1036 
1037     mapping(address => uint256) private _holderLastTransferTimestamp;
1038     bool public transferDelayEnabled = true;
1039 
1040     uint256 public buyTotalFees;
1041     uint256 public buyMarketingFee;
1042     uint256 public buyLiquidityFee;
1043     uint256 public buyDevFee;
1044 
1045     uint256 public sellTotalFees;
1046     uint256 public sellMarketingFee;
1047     uint256 public sellLiquidityFee;
1048     uint256 public sellDevFee;
1049 
1050     uint256 public tokensForMarketing;
1051     uint256 public tokensForLiquidity;
1052     uint256 public tokensForDev;
1053 
1054     /******************/
1055 
1056     // exlcude from fees and max transaction amount
1057     mapping(address => bool) private _isExcludedFromFees;
1058     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1059 
1060     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1061     // could be subject to a maximum transfer amount
1062     mapping(address => bool) public automatedMarketMakerPairs;
1063 
1064     event UpdateUniswapV2Router(
1065         address indexed newAddress,
1066         address indexed oldAddress
1067     );
1068 
1069     event ExcludeFromFees(address indexed account, bool isExcluded);
1070 
1071     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1072 
1073     event marketingWalletUpdated(
1074         address indexed newWallet,
1075         address indexed oldWallet
1076     );
1077 
1078     event devWalletUpdated(
1079         address indexed newWallet,
1080         address indexed oldWallet
1081     );
1082 
1083     event SwapAndLiquify(
1084         uint256 tokensSwapped,
1085         uint256 ethReceived,
1086         uint256 tokensIntoLiquidity
1087     );
1088 
1089     event AutoNukeLP();
1090 
1091     event ManualNukeLP();
1092 
1093     constructor() ERC20("MUNCH AGENCY", "MUNCH") {
1094         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1095             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1096         );
1097 
1098         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1099         uniswapV2Router = _uniswapV2Router;
1100 
1101         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1102             .createPair(address(this), _uniswapV2Router.WETH());
1103         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1104         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1105 
1106         uint256 _buyMarketingFee = 3;
1107         uint256 _buyLiquidityFee = 3;
1108         uint256 _buyDevFee = 3;
1109 
1110         uint256 _sellMarketingFee = 3;
1111         uint256 _sellLiquidityFee = 3;
1112         uint256 _sellDevFee = 3;
1113 
1114         uint256 totalSupply = 1_000_000_000_000 * 1e18;
1115 
1116         maxTransactionAmount = 2_000_000_000 * 1e18; 
1117         maxWallet = 2_000_000_000 * 1e18; 
1118         swapTokensAtAmount = (totalSupply * 5) / 10000; 
1119 
1120         buyMarketingFee = _buyMarketingFee;
1121         buyLiquidityFee = _buyLiquidityFee;
1122         buyDevFee = _buyDevFee;
1123         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1124 
1125         sellMarketingFee = _sellMarketingFee;
1126         sellLiquidityFee = _sellLiquidityFee;
1127         sellDevFee = _sellDevFee;
1128         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1129 
1130         marketingWallet = address(0x13dA81dA63809b9bb2761F2143bA1ee080fAc647); 
1131         devWallet = address(0x33ed1F8fBF17D14e16A08b7b6E66d1C20B713866); 
1132 
1133         excludeFromFees(owner(), true);
1134         excludeFromFees(address(this), true);
1135         excludeFromFees(address(0xdead), true);
1136 
1137         excludeFromMaxTransaction(owner(), true);
1138         excludeFromMaxTransaction(address(this), true);
1139         excludeFromMaxTransaction(address(0xdead), true);
1140 
1141         _mint(msg.sender, totalSupply);
1142     }
1143 
1144     receive() external payable {}
1145 
1146     function enableTrading() external onlyOwner {
1147         tradingActive = true;
1148         swapEnabled = true;
1149         lastLpBurnTime = block.timestamp;
1150     }
1151 
1152     function removeLimits() external onlyOwner returns (bool) {
1153         limitsInEffect = false;
1154         return true;
1155     }
1156 
1157     function disableTransferDelay() external onlyOwner returns (bool) {
1158         transferDelayEnabled = false;
1159         return true;
1160     }
1161 
1162     function updateSwapTokensAtAmount(uint256 newAmount)
1163         external
1164         onlyOwner
1165         returns (bool)
1166     {
1167         require(
1168             newAmount >= (totalSupply() * 1) / 100000,
1169             "Swap amount cannot be lower than 0.001% total supply."
1170         );
1171         require(
1172             newAmount <= (totalSupply() * 5) / 1000,
1173             "Swap amount cannot be higher than 0.5% total supply."
1174         );
1175         swapTokensAtAmount = newAmount;
1176         return true;
1177     }
1178 
1179     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1180         require(
1181             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1182             "Cannot set maxTransactionAmount lower than 0.1%"
1183         );
1184         maxTransactionAmount = newNum * (10**18);
1185     }
1186 
1187     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1188         require(
1189             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1190             "Cannot set maxWallet lower than 0.5%"
1191         );
1192         maxWallet = newNum * (10**18);
1193     }
1194 
1195     function excludeFromMaxTransaction(address updAds, bool isEx)
1196         public
1197         onlyOwner
1198     {
1199         _isExcludedMaxTransactionAmount[updAds] = isEx;
1200     }
1201 
1202     function updateSwapEnabled(bool enabled) external onlyOwner {
1203         swapEnabled = enabled;
1204     }
1205 
1206     function updateBuyFees(
1207         uint256 _marketingFee,
1208         uint256 _liquidityFee,
1209         uint256 _devFee
1210     ) external onlyOwner {
1211         buyMarketingFee = _marketingFee;
1212         buyLiquidityFee = _liquidityFee;
1213         buyDevFee = _devFee;
1214         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1215         require(buyTotalFees <= 9, "Must keep fees at 9% or less");
1216     }
1217 
1218     function updateSellFees(
1219         uint256 _marketingFee,
1220         uint256 _liquidityFee,
1221         uint256 _devFee
1222     ) external onlyOwner {
1223         sellMarketingFee = _marketingFee;
1224         sellLiquidityFee = _liquidityFee;
1225         sellDevFee = _devFee;
1226         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1227         require(sellTotalFees <= 9, "Must keep fees at 9% or less");
1228     }
1229 
1230     function excludeFromFees(address account, bool excluded) public onlyOwner {
1231         _isExcludedFromFees[account] = excluded;
1232         emit ExcludeFromFees(account, excluded);
1233     }
1234 
1235     function setAutomatedMarketMakerPair(address pair, bool value)
1236         public
1237         onlyOwner
1238     {
1239         require(
1240             pair != uniswapV2Pair,
1241             "The pair cannot be removed from automatedMarketMakerPairs"
1242         );
1243 
1244         _setAutomatedMarketMakerPair(pair, value);
1245     }
1246 
1247     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1248         automatedMarketMakerPairs[pair] = value;
1249 
1250         emit SetAutomatedMarketMakerPair(pair, value);
1251     }
1252 
1253     function updateMarketingWallet(address newMarketingWallet)
1254         external
1255         onlyOwner
1256     {
1257         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1258         marketingWallet = newMarketingWallet;
1259     }
1260 
1261     function updateDevWallet(address newWallet) external onlyOwner {
1262         emit devWalletUpdated(newWallet, devWallet);
1263         devWallet = newWallet;
1264     }
1265 
1266     function isExcludedFromFees(address account) public view returns (bool) {
1267         return _isExcludedFromFees[account];
1268     }
1269 
1270     function _transfer(
1271         address from,
1272         address to,
1273         uint256 amount
1274     ) internal override {
1275         require(from != address(0), "ERC20: transfer from the zero address");
1276         require(to != address(0), "ERC20: transfer to the zero address");
1277 
1278         if (amount == 0) {
1279             super._transfer(from, to, 0);
1280             return;
1281         }
1282 
1283         if (limitsInEffect) {
1284             if (
1285                 from != owner() &&
1286                 to != owner() &&
1287                 to != address(0) &&
1288                 to != address(0xdead) &&
1289                 !swapping
1290             ) {
1291                 if (!tradingActive) {
1292                     require(
1293                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1294                         "Trading is not active."
1295                     );
1296                 }
1297 
1298                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1299                 if (transferDelayEnabled) {
1300                     if (
1301                         to != owner() &&
1302                         to != address(uniswapV2Router) &&
1303                         to != address(uniswapV2Pair)
1304                     ) {
1305                         require(
1306                             _holderLastTransferTimestamp[tx.origin] <
1307                                 block.number,
1308                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1309                         );
1310                         _holderLastTransferTimestamp[tx.origin] = block.number;
1311                     }
1312                 }
1313 
1314                 //when buy
1315                 if (
1316                     automatedMarketMakerPairs[from] &&
1317                     !_isExcludedMaxTransactionAmount[to]
1318                 ) {
1319                     require(
1320                         amount <= maxTransactionAmount,
1321                         "Buy transfer amount exceeds the maxTransactionAmount."
1322                     );
1323                     require(
1324                         amount + balanceOf(to) <= maxWallet,
1325                         "Max wallet exceeded"
1326                     );
1327                 }
1328                 //when sell
1329                 else if (
1330                     automatedMarketMakerPairs[to] &&
1331                     !_isExcludedMaxTransactionAmount[from]
1332                 ) {
1333                     require(
1334                         amount <= maxTransactionAmount,
1335                         "Sell transfer amount exceeds the maxTransactionAmount."
1336                     );
1337                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1338                     require(
1339                         amount + balanceOf(to) <= maxWallet,
1340                         "Max wallet exceeded"
1341                     );
1342                 }
1343             }
1344         }
1345 
1346         uint256 contractTokenBalance = balanceOf(address(this));
1347 
1348         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1349 
1350         if (
1351             canSwap &&
1352             swapEnabled &&
1353             !swapping &&
1354             !automatedMarketMakerPairs[from] &&
1355             !_isExcludedFromFees[from] &&
1356             !_isExcludedFromFees[to]
1357         ) {
1358             swapping = true;
1359 
1360             swapBack();
1361 
1362             swapping = false;
1363         }
1364 
1365         if (
1366             !swapping &&
1367             automatedMarketMakerPairs[to] &&
1368             lpBurnEnabled &&
1369             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1370             !_isExcludedFromFees[from]
1371         ) {
1372             autoBurnLiquidityPairTokens();
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
1388                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1389                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1390                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1391             }
1392             // on buy
1393             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1394                 fees = amount.mul(buyTotalFees).div(100);
1395                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1396                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1397                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1398             }
1399 
1400             if (fees > 0) {
1401                 super._transfer(from, address(this), fees);
1402             }
1403 
1404             amount -= fees;
1405         }
1406 
1407         super._transfer(from, to, amount);
1408     }
1409 
1410     function swapTokensForEth(uint256 tokenAmount) private {
1411         // generate the uniswap pair path of token -> weth
1412         address[] memory path = new address[](2);
1413         path[0] = address(this);
1414         path[1] = uniswapV2Router.WETH();
1415 
1416         _approve(address(this), address(uniswapV2Router), tokenAmount);
1417 
1418         // make the swap
1419         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1420             tokenAmount,
1421             0, // accept any amount of ETH
1422             path,
1423             address(this),
1424             block.timestamp
1425         );
1426     }
1427 
1428     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1429         // approve token transfer to cover all possible scenarios
1430         _approve(address(this), address(uniswapV2Router), tokenAmount);
1431 
1432         // add the liquidity
1433         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1434             address(this),
1435             tokenAmount,
1436             0, // slippage is unavoidable
1437             0, // slippage is unavoidable
1438             deadAddress,
1439             block.timestamp
1440         );
1441     }
1442 
1443     function swapBack() private {
1444         uint256 contractBalance = balanceOf(address(this));
1445         uint256 totalTokensToSwap = tokensForLiquidity +
1446             tokensForMarketing +
1447             tokensForDev;
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
1459         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1460             totalTokensToSwap /
1461             2;
1462         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1463 
1464         uint256 initialETHBalance = address(this).balance;
1465 
1466         swapTokensForEth(amountToSwapForETH);
1467 
1468         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1469 
1470         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1471             totalTokensToSwap
1472         );
1473         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1474 
1475         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1476 
1477         tokensForLiquidity = 0;
1478         tokensForMarketing = 0;
1479         tokensForDev = 0;
1480 
1481         (success, ) = address(devWallet).call{value: ethForDev}("");
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
1492         (success, ) = address(marketingWallet).call{
1493             value: address(this).balance
1494         }("");
1495     }
1496 
1497     function setAutoLPBurnSettings(
1498         uint256 _frequencyInSeconds,
1499         uint256 _percent,
1500         bool _Enabled
1501     ) external onlyOwner {
1502         require(
1503             _frequencyInSeconds >= 600,
1504             "cannot set buyback more often than every 10 minutes"
1505         );
1506         require(
1507             _percent <= 1000 && _percent >= 0,
1508             "Must set auto LP burn percent between 0% and 10%"
1509         );
1510         lpBurnFrequency = _frequencyInSeconds;
1511         percentForLPBurn = _percent;
1512         lpBurnEnabled = _Enabled;
1513     }
1514 
1515     function autoBurnLiquidityPairTokens() internal returns (bool) {
1516         lastLpBurnTime = block.timestamp;
1517 
1518         // get balance of liquidity pair
1519         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1520 
1521         // calculate amount to burn
1522         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1523             10000
1524         );
1525 
1526         // pull tokens from pancakePair liquidity and move to dead address permanently
1527         if (amountToBurn > 0) {
1528             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1529         }
1530 
1531         //sync price since this is not in a swap transaction!
1532         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1533         pair.sync();
1534         emit AutoNukeLP();
1535         return true;
1536     }
1537 
1538     function manualBurnLiquidityPairTokens(uint256 percent)
1539         external
1540         onlyOwner
1541         returns (bool)
1542     {
1543         require(
1544             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1545             "Must wait for cooldown to finish"
1546         );
1547         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1548         lastManualLpBurnTime = block.timestamp;
1549 
1550         // get balance of liquidity pair
1551         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1552 
1553         // calculate amount to burn
1554         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1555 
1556         // pull tokens from pancakePair liquidity and move to dead address permanently
1557         if (amountToBurn > 0) {
1558             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1559         }
1560 
1561         //sync price since this is not in a swap transaction!
1562         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1563         pair.sync();
1564         emit ManualNukeLP();
1565         return true;
1566     }
1567 }