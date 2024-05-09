1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
3 pragma experimental ABIEncoderV2;
4 
5 /**
6 
7 
8 
9 
10 Angry Potato, the most powerful potato on Earth. He has a deep rooted anger and an unquenchable desire to rule the world.
11 
12 
13 Web: https://angrypotatocoin.com/
14 Twitter: https://twitter.com/AngryPotatoCoin
15 Telegram: https://t.me/AngryPotatoPortal
16 
17 
18 
19 
20 
21 
22 
23 */
24 
25 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
26 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
27 
28 /* pragma solidity ^0.8.0; */
29 
30 /**
31  * @dev Provides information about the current execution context, including the
32  * sender of the transaction and its data. While these are generally available
33  * via msg.sender and msg.data, they should not be accessed in such a direct
34  * manner, since when dealing with meta-transactions the account sending and
35  * paying for execution may not be the actual sender (as far as an application
36  * is concerned).
37  *
38  * This contract is only required for intermediate, library-like contracts.
39  */
40 abstract contract Context {
41     function _msgSender() internal view virtual returns (address) {
42         return msg.sender;
43     }
44 
45     function _msgData() internal view virtual returns (bytes calldata) {
46         return msg.data;
47     }
48 }
49 
50 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
51 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
52 
53 /* pragma solidity ^0.8.0; */
54 
55 /* import "../utils/Context.sol"; */
56 
57 /**
58  * @dev Contract module which provides a basic access control mechanism, where
59  * there is an account (an owner) that can be granted exclusive access to
60  * specific functions.
61  *
62  * By default, the owner account will be the one that deploys the contract. This
63  * can later be changed with {transferOwnership}.
64  *
65  * This module is used through inheritance. It will make available the modifier
66  * `onlyOwner`, which can be applied to your functions to restrict their use to
67  * the owner.
68  */
69 abstract contract Ownable is Context {
70     address private _owner;
71 
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     /**
75      * @dev Initializes the contract setting the deployer as the initial owner.
76      */
77     constructor() {
78         _transferOwnership(_msgSender());
79     }
80 
81     /**
82      * @dev Returns the address of the current owner.
83      */
84     function owner() public view virtual returns (address) {
85         return _owner;
86     }
87 
88     /**
89      * @dev Throws if called by any account other than the owner.
90      */
91     modifier onlyOwner() {
92         require(owner() == _msgSender(), "Ownable: caller is not the owner");
93         _;
94     }
95 
96     /**
97      * @dev Leaves the contract without owner. It will not be possible to call
98      * `onlyOwner` functions anymore. Can only be called by the current owner.
99      *
100      * NOTE: Renouncing ownership will leave the contract without an owner,
101      * thereby removing any functionality that is only available to the owner.
102      */
103     function renounceOwnership() public virtual onlyOwner {
104         _transferOwnership(address(0));
105     }
106 
107     /**
108      * @dev Transfers ownership of the contract to a new account (`newOwner`).
109      * Can only be called by the current owner.
110      */
111     function transferOwnership(address newOwner) public virtual onlyOwner {
112         require(newOwner != address(0), "Ownable: new owner is the zero address");
113         _transferOwnership(newOwner);
114     }
115 
116     /**
117      * @dev Transfers ownership of the contract to a new account (`newOwner`).
118      * Internal function without access restriction.
119      */
120     function _transferOwnership(address newOwner) internal virtual {
121         address oldOwner = _owner;
122         _owner = newOwner;
123         emit OwnershipTransferred(oldOwner, newOwner);
124     }
125 }
126 
127 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
128 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
129 
130 /* pragma solidity ^0.8.0; */
131 
132 /**
133  * @dev Interface of the ERC20 standard as defined in the EIP.
134  */
135 interface IERC20 {
136     /**
137      * @dev Returns the amount of tokens in existence.
138      */
139     function totalSupply() external view returns (uint256);
140 
141     /**
142      * @dev Returns the amount of tokens owned by `account`.
143      */
144     function balanceOf(address account) external view returns (uint256);
145 
146     /**
147      * @dev Moves `amount` tokens from the caller's account to `recipient`.
148      *
149      * Returns a boolean value indicating whether the operation succeeded.
150      *
151      * Emits a {Transfer} event.
152      */
153     function transfer(address recipient, uint256 amount) external returns (bool);
154 
155     /**
156      * @dev Returns the remaining number of tokens that `spender` will be
157      * allowed to spend on behalf of `owner` through {transferFrom}. This is
158      * zero by default.
159      *
160      * This value changes when {approve} or {transferFrom} are called.
161      */
162     function allowance(address owner, address spender) external view returns (uint256);
163 
164     /**
165      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
166      *
167      * Returns a boolean value indicating whether the operation succeeded.
168      *
169      * IMPORTANT: Beware that changing an allowance with this method brings the risk
170      * that someone may use both the old and the new allowance by unfortunate
171      * transaction ordering. One possible solution to mitigate this race
172      * condition is to first reduce the spender's allowance to 0 and set the
173      * desired value afterwards:
174      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175      *
176      * Emits an {Approval} event.
177      */
178     function approve(address spender, uint256 amount) external returns (bool);
179 
180     /**
181      * @dev Moves `amount` tokens from `sender` to `recipient` using the
182      * allowance mechanism. `amount` is then deducted from the caller's
183      * allowance.
184      *
185      * Returns a boolean value indicating whether the operation succeeded.
186      *
187      * Emits a {Transfer} event.
188      */
189     function transferFrom(
190         address sender,
191         address recipient,
192         uint256 amount
193     ) external returns (bool);
194 
195     /**
196      * @dev Emitted when `value` tokens are moved from one account (`from`) to
197      * another (`to`).
198      *
199      * Note that `value` may be zero.
200      */
201     event Transfer(address indexed from, address indexed to, uint256 value);
202 
203     /**
204      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
205      * a call to {approve}. `value` is the new allowance.
206      */
207     event Approval(address indexed owner, address indexed spender, uint256 value);
208 }
209 
210 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
211 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
212 
213 /* pragma solidity ^0.8.0; */
214 
215 /* import "../IERC20.sol"; */
216 
217 /**
218  * @dev Interface for the optional metadata functions from the ERC20 standard.
219  *
220  * _Available since v4.1._
221  */
222 interface IERC20Metadata is IERC20 {
223     /**
224      * @dev Returns the name of the token.
225      */
226     function name() external view returns (string memory);
227 
228     /**
229      * @dev Returns the symbol of the token.
230      */
231     function symbol() external view returns (string memory);
232 
233     /**
234      * @dev Returns the decimals places of the token.
235      */
236     function decimals() external view returns (uint8);
237 }
238 
239 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
240 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
241 
242 /* pragma solidity ^0.8.0; */
243 
244 /* import "./IERC20.sol"; */
245 /* import "./extensions/IERC20Metadata.sol"; */
246 /* import "../../utils/Context.sol"; */
247 
248 /**
249  * @dev Implementation of the {IERC20} interface.
250  *
251  * This implementation is agnostic to the way tokens are created. This means
252  * that a supply mechanism has to be added in a derived contract using {_mint}.
253  * For a generic mechanism see {ERC20PresetMinterPauser}.
254  *
255  * TIP: For a detailed writeup see our guide
256  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
257  * to implement supply mechanisms].
258  *
259  * We have followed general OpenZeppelin Contracts guidelines: functions revert
260  * instead returning `false` on failure. This behavior is nonetheless
261  * conventional and does not conflict with the expectations of ERC20
262  * applications.
263  *
264  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
265  * This allows applications to reconstruct the allowance for all accounts just
266  * by listening to said events. Other implementations of the EIP may not emit
267  * these events, as it isn't required by the specification.
268  *
269  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
270  * functions have been added to mitigate the well-known issues around setting
271  * allowances. See {IERC20-approve}.
272  */
273 contract ERC20 is Context, IERC20, IERC20Metadata {
274     mapping(address => uint256) private _balances;
275 
276     mapping(address => mapping(address => uint256)) private _allowances;
277 
278     uint256 private _totalSupply;
279 
280     string private _name;
281     string private _symbol;
282 
283     /**
284      * @dev Sets the values for {name} and {symbol}.
285      *
286      * The default value of {decimals} is 18. To select a different value for
287      * {decimals} you should overload it.
288      *
289      * All two of these values are immutable: they can only be set once during
290      * construction.
291      */
292     constructor(string memory name_, string memory symbol_) {
293         _name = name_;
294         _symbol = symbol_;
295     }
296 
297     /**
298      * @dev Returns the name of the token.
299      */
300     function name() public view virtual override returns (string memory) {
301         return _name;
302     }
303 
304     /**
305      * @dev Returns the symbol of the token, usually a shorter version of the
306      * name.
307      */
308     function symbol() public view virtual override returns (string memory) {
309         return _symbol;
310     }
311 
312     /**
313      * @dev Returns the number of decimals used to get its user representation.
314      * For example, if `decimals` equals `2`, a balance of `505` tokens should
315      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
316      *
317      * Tokens usually opt for a value of 18, imitating the relationship between
318      * Ether and Wei. This is the value {ERC20} uses, unless this function is
319      * overridden;
320      *
321      * NOTE: This information is only used for _display_ purposes: it in
322      * no way affects any of the arithmetic of the contract, including
323      * {IERC20-balanceOf} and {IERC20-transfer}.
324      */
325     function decimals() public view virtual override returns (uint8) {
326         return 18;
327     }
328 
329     /**
330      * @dev See {IERC20-totalSupply}.
331      */
332     function totalSupply() public view virtual override returns (uint256) {
333         return _totalSupply;
334     }
335 
336     /**
337      * @dev See {IERC20-balanceOf}.
338      */
339     function balanceOf(address account) public view virtual override returns (uint256) {
340         return _balances[account];
341     }
342 
343     /**
344      * @dev See {IERC20-transfer}.
345      *
346      * Requirements:
347      *
348      * - `recipient` cannot be the zero address.
349      * - the caller must have a balance of at least `amount`.
350      */
351     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
352         _transfer(_msgSender(), recipient, amount);
353         return true;
354     }
355 
356     /**
357      * @dev See {IERC20-allowance}.
358      */
359     function allowance(address owner, address spender) public view virtual override returns (uint256) {
360         return _allowances[owner][spender];
361     }
362 
363     /**
364      * @dev See {IERC20-approve}.
365      *
366      * Requirements:
367      *
368      * - `spender` cannot be the zero address.
369      */
370     function approve(address spender, uint256 amount) public virtual override returns (bool) {
371         _approve(_msgSender(), spender, amount);
372         return true;
373     }
374 
375     /**
376      * @dev See {IERC20-transferFrom}.
377      *
378      * Emits an {Approval} event indicating the updated allowance. This is not
379      * required by the EIP. See the note at the beginning of {ERC20}.
380      *
381      * Requirements:
382      *
383      * - `sender` and `recipient` cannot be the zero address.
384      * - `sender` must have a balance of at least `amount`.
385      * - the caller must have allowance for ``sender``'s tokens of at least
386      * `amount`.
387      */
388     function transferFrom(
389         address sender,
390         address recipient,
391         uint256 amount
392     ) public virtual override returns (bool) {
393         _transfer(sender, recipient, amount);
394 
395         uint256 currentAllowance = _allowances[sender][_msgSender()];
396         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
397         unchecked {
398             _approve(sender, _msgSender(), currentAllowance - amount);
399         }
400 
401         return true;
402     }
403 
404     /**
405      * @dev Atomically increases the allowance granted to `spender` by the caller.
406      *
407      * This is an alternative to {approve} that can be used as a mitigation for
408      * problems described in {IERC20-approve}.
409      *
410      * Emits an {Approval} event indicating the updated allowance.
411      *
412      * Requirements:
413      *
414      * - `spender` cannot be the zero address.
415      */
416     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
417         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
418         return true;
419     }
420 
421     /**
422      * @dev Atomically decreases the allowance granted to `spender` by the caller.
423      *
424      * This is an alternative to {approve} that can be used as a mitigation for
425      * problems described in {IERC20-approve}.
426      *
427      * Emits an {Approval} event indicating the updated allowance.
428      *
429      * Requirements:
430      *
431      * - `spender` cannot be the zero address.
432      * - `spender` must have allowance for the caller of at least
433      * `subtractedValue`.
434      */
435     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
436         uint256 currentAllowance = _allowances[_msgSender()][spender];
437         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
438         unchecked {
439             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
440         }
441 
442         return true;
443     }
444 
445     /**
446      * @dev Moves `amount` of tokens from `sender` to `recipient`.
447      *
448      * This internal function is equivalent to {transfer}, and can be used to
449      * e.g. implement automatic token fees, slashing mechanisms, etc.
450      *
451      * Emits a {Transfer} event.
452      *
453      * Requirements:
454      *
455      * - `sender` cannot be the zero address.
456      * - `recipient` cannot be the zero address.
457      * - `sender` must have a balance of at least `amount`.
458      */
459     function _transfer(
460         address sender,
461         address recipient,
462         uint256 amount
463     ) internal virtual {
464         require(sender != address(0), "ERC20: transfer from the zero address");
465         require(recipient != address(0), "ERC20: transfer to the zero address");
466 
467         _beforeTokenTransfer(sender, recipient, amount);
468 
469         uint256 senderBalance = _balances[sender];
470         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
471         unchecked {
472             _balances[sender] = senderBalance - amount;
473         }
474         _balances[recipient] += amount;
475 
476         emit Transfer(sender, recipient, amount);
477 
478         _afterTokenTransfer(sender, recipient, amount);
479     }
480 
481     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
482      * the total supply.
483      *
484      * Emits a {Transfer} event with `from` set to the zero address.
485      *
486      * Requirements:
487      *
488      * - `account` cannot be the zero address.
489      */
490     function _mint(address account, uint256 amount) internal virtual {
491         require(account != address(0), "ERC20: mint to the zero address");
492 
493         _beforeTokenTransfer(address(0), account, amount);
494 
495         _totalSupply += amount;
496         _balances[account] += amount;
497         emit Transfer(address(0), account, amount);
498 
499         _afterTokenTransfer(address(0), account, amount);
500     }
501 
502     /**
503      * @dev Destroys `amount` tokens from `account`, reducing the
504      * total supply.
505      *
506      * Emits a {Transfer} event with `to` set to the zero address.
507      *
508      * Requirements:
509      *
510      * - `account` cannot be the zero address.
511      * - `account` must have at least `amount` tokens.
512      */
513     function _burn(address account, uint256 amount) internal virtual {
514         require(account != address(0), "ERC20: burn from the zero address");
515 
516         _beforeTokenTransfer(account, address(0), amount);
517 
518         uint256 accountBalance = _balances[account];
519         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
520         unchecked {
521             _balances[account] = accountBalance - amount;
522         }
523         _totalSupply -= amount;
524 
525         emit Transfer(account, address(0), amount);
526 
527         _afterTokenTransfer(account, address(0), amount);
528     }
529 
530     /**
531      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
532      *
533      * This internal function is equivalent to `approve`, and can be used to
534      * e.g. set automatic allowances for certain subsystems, etc.
535      *
536      * Emits an {Approval} event.
537      *
538      * Requirements:
539      *
540      * - `owner` cannot be the zero address.
541      * - `spender` cannot be the zero address.
542      */
543     function _approve(
544         address owner,
545         address spender,
546         uint256 amount
547     ) internal virtual {
548         require(owner != address(0), "ERC20: approve from the zero address");
549         require(spender != address(0), "ERC20: approve to the zero address");
550 
551         _allowances[owner][spender] = amount;
552         emit Approval(owner, spender, amount);
553     }
554 
555     /**
556      * @dev Hook that is called before any transfer of tokens. This includes
557      * minting and burning.
558      *
559      * Calling conditions:
560      *
561      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
562      * will be transferred to `to`.
563      * - when `from` is zero, `amount` tokens will be minted for `to`.
564      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
565      * - `from` and `to` are never both zero.
566      *
567      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
568      */
569     function _beforeTokenTransfer(
570         address from,
571         address to,
572         uint256 amount
573     ) internal virtual {}
574 
575     /**
576      * @dev Hook that is called after any transfer of tokens. This includes
577      * minting and burning.
578      *
579      * Calling conditions:
580      *
581      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
582      * has been transferred to `to`.
583      * - when `from` is zero, `amount` tokens have been minted for `to`.
584      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
585      * - `from` and `to` are never both zero.
586      *
587      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
588      */
589     function _afterTokenTransfer(
590         address from,
591         address to,
592         uint256 amount
593     ) internal virtual {}
594 }
595 
596 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
597 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
598 
599 /* pragma solidity ^0.8.0; */
600 
601 // CAUTION
602 // This version of SafeMath should only be used with Solidity 0.8 or later,
603 // because it relies on the compiler's built in overflow checks.
604 
605 /**
606  * @dev Wrappers over Solidity's arithmetic operations.
607  *
608  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
609  * now has built in overflow checking.
610  */
611 library SafeMath {
612     /**
613      * @dev Returns the addition of two unsigned integers, with an overflow flag.
614      *
615      * _Available since v3.4._
616      */
617     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
618         unchecked {
619             uint256 c = a + b;
620             if (c < a) return (false, 0);
621             return (true, c);
622         }
623     }
624 
625     /**
626      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
627      *
628      * _Available since v3.4._
629      */
630     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
631         unchecked {
632             if (b > a) return (false, 0);
633             return (true, a - b);
634         }
635     }
636 
637     /**
638      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
639      *
640      * _Available since v3.4._
641      */
642     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
643         unchecked {
644             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
645             // benefit is lost if 'b' is also tested.
646             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
647             if (a == 0) return (true, 0);
648             uint256 c = a * b;
649             if (c / a != b) return (false, 0);
650             return (true, c);
651         }
652     }
653 
654     /**
655      * @dev Returns the division of two unsigned integers, with a division by zero flag.
656      *
657      * _Available since v3.4._
658      */
659     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
660         unchecked {
661             if (b == 0) return (false, 0);
662             return (true, a / b);
663         }
664     }
665 
666     /**
667      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
668      *
669      * _Available since v3.4._
670      */
671     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
672         unchecked {
673             if (b == 0) return (false, 0);
674             return (true, a % b);
675         }
676     }
677 
678     /**
679      * @dev Returns the addition of two unsigned integers, reverting on
680      * overflow.
681      *
682      * Counterpart to Solidity's `+` operator.
683      *
684      * Requirements:
685      *
686      * - Addition cannot overflow.
687      */
688     function add(uint256 a, uint256 b) internal pure returns (uint256) {
689         return a + b;
690     }
691 
692     /**
693      * @dev Returns the subtraction of two unsigned integers, reverting on
694      * overflow (when the result is negative).
695      *
696      * Counterpart to Solidity's `-` operator.
697      *
698      * Requirements:
699      *
700      * - Subtraction cannot overflow.
701      */
702     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
703         return a - b;
704     }
705 
706     /**
707      * @dev Returns the multiplication of two unsigned integers, reverting on
708      * overflow.
709      *
710      * Counterpart to Solidity's `*` operator.
711      *
712      * Requirements:
713      *
714      * - Multiplication cannot overflow.
715      */
716     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
717         return a * b;
718     }
719 
720     /**
721      * @dev Returns the integer division of two unsigned integers, reverting on
722      * division by zero. The result is rounded towards zero.
723      *
724      * Counterpart to Solidity's `/` operator.
725      *
726      * Requirements:
727      *
728      * - The divisor cannot be zero.
729      */
730     function div(uint256 a, uint256 b) internal pure returns (uint256) {
731         return a / b;
732     }
733 
734     /**
735      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
736      * reverting when dividing by zero.
737      *
738      * Counterpart to Solidity's `%` operator. This function uses a `revert`
739      * opcode (which leaves remaining gas untouched) while Solidity uses an
740      * invalid opcode to revert (consuming all remaining gas).
741      *
742      * Requirements:
743      *
744      * - The divisor cannot be zero.
745      */
746     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
747         return a % b;
748     }
749 
750     /**
751      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
752      * overflow (when the result is negative).
753      *
754      * CAUTION: This function is deprecated because it requires allocating memory for the error
755      * message unnecessarily. For custom revert reasons use {trySub}.
756      *
757      * Counterpart to Solidity's `-` operator.
758      *
759      * Requirements:
760      *
761      * - Subtraction cannot overflow.
762      */
763     function sub(
764         uint256 a,
765         uint256 b,
766         string memory errorMessage
767     ) internal pure returns (uint256) {
768         unchecked {
769             require(b <= a, errorMessage);
770             return a - b;
771         }
772     }
773 
774     /**
775      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
776      * division by zero. The result is rounded towards zero.
777      *
778      * Counterpart to Solidity's `/` operator. Note: this function uses a
779      * `revert` opcode (which leaves remaining gas untouched) while Solidity
780      * uses an invalid opcode to revert (consuming all remaining gas).
781      *
782      * Requirements:
783      *
784      * - The divisor cannot be zero.
785      */
786     function div(
787         uint256 a,
788         uint256 b,
789         string memory errorMessage
790     ) internal pure returns (uint256) {
791         unchecked {
792             require(b > 0, errorMessage);
793             return a / b;
794         }
795     }
796 
797     /**
798      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
799      * reverting with custom message when dividing by zero.
800      *
801      * CAUTION: This function is deprecated because it requires allocating memory for the error
802      * message unnecessarily. For custom revert reasons use {tryMod}.
803      *
804      * Counterpart to Solidity's `%` operator. This function uses a `revert`
805      * opcode (which leaves remaining gas untouched) while Solidity uses an
806      * invalid opcode to revert (consuming all remaining gas).
807      *
808      * Requirements:
809      *
810      * - The divisor cannot be zero.
811      */
812     function mod(
813         uint256 a,
814         uint256 b,
815         string memory errorMessage
816     ) internal pure returns (uint256) {
817         unchecked {
818             require(b > 0, errorMessage);
819             return a % b;
820         }
821     }
822 }
823 
824 /* pragma solidity 0.8.10; */
825 /* pragma experimental ABIEncoderV2; */
826 
827 interface IUniswapV2Factory {
828     event PairCreated(
829         address indexed token0,
830         address indexed token1,
831         address pair,
832         uint256
833     );
834 
835     function feeTo() external view returns (address);
836 
837     function feeToSetter() external view returns (address);
838 
839     function getPair(address tokenA, address tokenB)
840         external
841         view
842         returns (address pair);
843 
844     function allPairs(uint256) external view returns (address pair);
845 
846     function allPairsLength() external view returns (uint256);
847 
848     function createPair(address tokenA, address tokenB)
849         external
850         returns (address pair);
851 
852     function setFeeTo(address) external;
853 
854     function setFeeToSetter(address) external;
855 }
856 
857 /* pragma solidity 0.8.10; */
858 /* pragma experimental ABIEncoderV2; */
859 
860 interface IUniswapV2Pair {
861     event Approval(
862         address indexed owner,
863         address indexed spender,
864         uint256 value
865     );
866     event Transfer(address indexed from, address indexed to, uint256 value);
867 
868     function name() external pure returns (string memory);
869 
870     function symbol() external pure returns (string memory);
871 
872     function decimals() external pure returns (uint8);
873 
874     function totalSupply() external view returns (uint256);
875 
876     function balanceOf(address owner) external view returns (uint256);
877 
878     function allowance(address owner, address spender)
879         external
880         view
881         returns (uint256);
882 
883     function approve(address spender, uint256 value) external returns (bool);
884 
885     function transfer(address to, uint256 value) external returns (bool);
886 
887     function transferFrom(
888         address from,
889         address to,
890         uint256 value
891     ) external returns (bool);
892 
893     function DOMAIN_SEPARATOR() external view returns (bytes32);
894 
895     function PERMIT_TYPEHASH() external pure returns (bytes32);
896 
897     function nonces(address owner) external view returns (uint256);
898 
899     function permit(
900         address owner,
901         address spender,
902         uint256 value,
903         uint256 deadline,
904         uint8 v,
905         bytes32 r,
906         bytes32 s
907     ) external;
908 
909     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
910     event Burn(
911         address indexed sender,
912         uint256 amount0,
913         uint256 amount1,
914         address indexed to
915     );
916     event Swap(
917         address indexed sender,
918         uint256 amount0In,
919         uint256 amount1In,
920         uint256 amount0Out,
921         uint256 amount1Out,
922         address indexed to
923     );
924     event Sync(uint112 reserve0, uint112 reserve1);
925 
926     function MINIMUM_LIQUIDITY() external pure returns (uint256);
927 
928     function factory() external view returns (address);
929 
930     function token0() external view returns (address);
931 
932     function token1() external view returns (address);
933 
934     function getReserves()
935         external
936         view
937         returns (
938             uint112 reserve0,
939             uint112 reserve1,
940             uint32 blockTimestampLast
941         );
942 
943     function price0CumulativeLast() external view returns (uint256);
944 
945     function price1CumulativeLast() external view returns (uint256);
946 
947     function kLast() external view returns (uint256);
948 
949     function mint(address to) external returns (uint256 liquidity);
950 
951     function burn(address to)
952         external
953         returns (uint256 amount0, uint256 amount1);
954 
955     function swap(
956         uint256 amount0Out,
957         uint256 amount1Out,
958         address to,
959         bytes calldata data
960     ) external;
961 
962     function skim(address to) external;
963 
964     function sync() external;
965 
966     function initialize(address, address) external;
967 }
968 
969 /* pragma solidity 0.8.10; */
970 /* pragma experimental ABIEncoderV2; */
971 
972 interface IUniswapV2Router02 {
973     function factory() external pure returns (address);
974 
975     function WETH() external pure returns (address);
976 
977     function addLiquidity(
978         address tokenA,
979         address tokenB,
980         uint256 amountADesired,
981         uint256 amountBDesired,
982         uint256 amountAMin,
983         uint256 amountBMin,
984         address to,
985         uint256 deadline
986     )
987         external
988         returns (
989             uint256 amountA,
990             uint256 amountB,
991             uint256 liquidity
992         );
993 
994     function addLiquidityETH(
995         address token,
996         uint256 amountTokenDesired,
997         uint256 amountTokenMin,
998         uint256 amountETHMin,
999         address to,
1000         uint256 deadline
1001     )
1002         external
1003         payable
1004         returns (
1005             uint256 amountToken,
1006             uint256 amountETH,
1007             uint256 liquidity
1008         );
1009 
1010     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1011         uint256 amountIn,
1012         uint256 amountOutMin,
1013         address[] calldata path,
1014         address to,
1015         uint256 deadline
1016     ) external;
1017 
1018     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1019         uint256 amountOutMin,
1020         address[] calldata path,
1021         address to,
1022         uint256 deadline
1023     ) external payable;
1024 
1025     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1026         uint256 amountIn,
1027         uint256 amountOutMin,
1028         address[] calldata path,
1029         address to,
1030         uint256 deadline
1031     ) external;
1032 }
1033 
1034 /* pragma solidity >=0.8.10; */
1035 
1036 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1037 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1038 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1039 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1040 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1041 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1042 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1043 
1044 contract POTATO is ERC20, Ownable {
1045     using SafeMath for uint256;
1046 
1047     IUniswapV2Router02 public immutable uniswapV2Router;
1048     address public immutable uniswapV2Pair;
1049     address public constant deadAddress = address(0xdead);
1050 
1051     bool private swapping;
1052 
1053 	address public charityWallet;
1054     address public marketingWallet;
1055     address public devWallet;
1056 
1057     uint256 public maxTransactionAmount;
1058     uint256 public swapTokensAtAmount;
1059     uint256 public maxWallet;
1060 
1061     bool public limitsInEffect = true;
1062     bool public tradingActive = true;
1063     bool public swapEnabled = true;
1064 
1065     // Anti-bot and anti-whale mappings and variables
1066     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1067     bool public transferDelayEnabled = true;
1068 
1069     uint256 public buyTotalFees;
1070 	uint256 public buyCharityFee;
1071     uint256 public buyMarketingFee;
1072     uint256 public buyLiquidityFee;
1073     uint256 public buyDevFee;
1074 
1075     uint256 public sellTotalFees;
1076 	uint256 public sellCharityFee;
1077     uint256 public sellMarketingFee;
1078     uint256 public sellLiquidityFee;
1079     uint256 public sellDevFee;
1080 
1081 	uint256 public tokensForCharity;
1082     uint256 public tokensForMarketing;
1083     uint256 public tokensForLiquidity;
1084     uint256 public tokensForDev;
1085 
1086     /******************/
1087 
1088     // exlcude from fees and max transaction amount
1089     mapping(address => bool) private _isExcludedFromFees;
1090     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1091 
1092     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1093     // could be subject to a maximum transfer amount
1094     mapping(address => bool) public automatedMarketMakerPairs;
1095 
1096     event UpdateUniswapV2Router(
1097         address indexed newAddress,
1098         address indexed oldAddress
1099     );
1100 
1101     event ExcludeFromFees(address indexed account, bool isExcluded);
1102 
1103     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1104 
1105     event SwapAndLiquify(
1106         uint256 tokensSwapped,
1107         uint256 ethReceived,
1108         uint256 tokensIntoLiquidity
1109     );
1110 
1111     constructor() ERC20("ANGRY POTATO", "POTATO") {
1112         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1113             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1114         );
1115 
1116         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1117         uniswapV2Router = _uniswapV2Router;
1118 
1119         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1120             .createPair(address(this), _uniswapV2Router.WETH());
1121         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1122         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1123 
1124 		uint256 _buyCharityFee = 0;
1125         uint256 _buyMarketingFee = 0;
1126         uint256 _buyLiquidityFee = 0;
1127         uint256 _buyDevFee = 12;
1128 
1129 		uint256 _sellCharityFee = 0;
1130         uint256 _sellMarketingFee = 0;
1131         uint256 _sellLiquidityFee = 0;
1132         uint256 _sellDevFee = 24;
1133 
1134         uint256 totalSupply = 5000000000000 * 1e18;
1135 
1136         maxTransactionAmount = 25000000000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1137         maxWallet = 50000000000 * 1e18; // 2% from total supply maxWallet
1138         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1139 
1140 		buyCharityFee = _buyCharityFee;
1141         buyMarketingFee = _buyMarketingFee;
1142         buyLiquidityFee = _buyLiquidityFee;
1143         buyDevFee = _buyDevFee;
1144         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1145 
1146 		sellCharityFee = _sellCharityFee;
1147         sellMarketingFee = _sellMarketingFee;
1148         sellLiquidityFee = _sellLiquidityFee;
1149         sellDevFee = _sellDevFee;
1150         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1151 
1152 		charityWallet = address(0xf8a4f9e16523B1ECDD3474CC5444329C2b995CFa); // 
1153         marketingWallet = address(0xDEBE81CaF2e43e5fA6900A6649aDE030a1432ce3); // Weaponery
1154         devWallet = address(0xf8a4f9e16523B1ECDD3474CC5444329C2b995CFa); // set as dev wallet
1155 
1156         // exclude from paying fees or having max transaction amount
1157         excludeFromFees(owner(), true);
1158         excludeFromFees(address(this), true);
1159         excludeFromFees(address(0xdead), true);
1160 
1161         excludeFromMaxTransaction(owner(), true);
1162         excludeFromMaxTransaction(address(this), true);
1163         excludeFromMaxTransaction(address(0xdead), true);
1164 
1165         /*
1166             _mint is an internal function in ERC20.sol that is only called here,
1167             and CANNOT be called ever again
1168         */
1169         _mint(msg.sender, totalSupply);
1170     }
1171 
1172     receive() external payable {}
1173 
1174     // once enabled, can never be turned off
1175     function enableTrading() external onlyOwner {
1176         tradingActive = true;
1177         swapEnabled = true;
1178     }
1179 
1180     // remove limits after token is stable
1181     function removeLimits() external onlyOwner returns (bool) {
1182         limitsInEffect = false;
1183         return true;
1184     }
1185 
1186     // disable Transfer delay - cannot be reenabled
1187     function disableTransferDelay() external onlyOwner returns (bool) {
1188         transferDelayEnabled = false;
1189         return true;
1190     }
1191 
1192     // change the minimum amount of tokens to sell from fees
1193     function updateSwapTokensAtAmount(uint256 newAmount)
1194         external
1195         onlyOwner
1196         returns (bool)
1197     {
1198         require(
1199             newAmount >= (totalSupply() * 1) / 100000,
1200             "Swap amount cannot be lower than 0.001% total supply."
1201         );
1202         require(
1203             newAmount <= (totalSupply() * 5) / 1000,
1204             "Swap amount cannot be higher than 0.5% total supply."
1205         );
1206         swapTokensAtAmount = newAmount;
1207         return true;
1208     }
1209 
1210     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1211         require(
1212             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1213             "Cannot set maxTransactionAmount lower than 0.5%"
1214         );
1215         maxTransactionAmount = newNum * (10**18);
1216     }
1217 
1218     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1219         require(
1220             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1221             "Cannot set maxWallet lower than 0.5%"
1222         );
1223         maxWallet = newNum * (10**18);
1224     }
1225 	
1226     function excludeFromMaxTransaction(address updAds, bool isEx)
1227         public
1228         onlyOwner
1229     {
1230         _isExcludedMaxTransactionAmount[updAds] = isEx;
1231     }
1232 
1233     // only use to disable contract sales if absolutely necessary (emergency use only)
1234     function updateSwapEnabled(bool enabled) external onlyOwner {
1235         swapEnabled = enabled;
1236     }
1237 
1238     function updateBuyFees(
1239 		uint256 _charityFee,
1240         uint256 _marketingFee,
1241         uint256 _liquidityFee,
1242         uint256 _devFee
1243     ) external onlyOwner {
1244 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max BuyFee 10%");
1245 		buyCharityFee = _charityFee;
1246         buyMarketingFee = _marketingFee;
1247         buyLiquidityFee = _liquidityFee;
1248         buyDevFee = _devFee;
1249         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1250      }
1251 
1252     function updateSellFees(
1253 		uint256 _charityFee,
1254         uint256 _marketingFee,
1255         uint256 _liquidityFee,
1256         uint256 _devFee
1257     ) external onlyOwner {
1258 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max SellFee 10%");
1259 		sellCharityFee = _charityFee;
1260         sellMarketingFee = _marketingFee;
1261         sellLiquidityFee = _liquidityFee;
1262         sellDevFee = _devFee;
1263         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1264     }
1265 
1266     function excludeFromFees(address account, bool excluded) public onlyOwner {
1267         _isExcludedFromFees[account] = excluded;
1268         emit ExcludeFromFees(account, excluded);
1269     }
1270 
1271     function setAutomatedMarketMakerPair(address pair, bool value)
1272         public
1273         onlyOwner
1274     {
1275         require(
1276             pair != uniswapV2Pair,
1277             "The pair cannot be removed from automatedMarketMakerPairs"
1278         );
1279 
1280         _setAutomatedMarketMakerPair(pair, value);
1281     }
1282 
1283     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1284         automatedMarketMakerPairs[pair] = value;
1285 
1286         emit SetAutomatedMarketMakerPair(pair, value);
1287     }
1288 
1289     function isExcludedFromFees(address account) public view returns (bool) {
1290         return _isExcludedFromFees[account];
1291     }
1292 
1293     function _transfer(
1294         address from,
1295         address to,
1296         uint256 amount
1297     ) internal override {
1298         require(from != address(0), "ERC20: transfer from the zero address");
1299         require(to != address(0), "ERC20: transfer to the zero address");
1300 
1301         if (amount == 0) {
1302             super._transfer(from, to, 0);
1303             return;
1304         }
1305 
1306         if (limitsInEffect) {
1307             if (
1308                 from != owner() &&
1309                 to != owner() &&
1310                 to != address(0) &&
1311                 to != address(0xdead) &&
1312                 !swapping
1313             ) {
1314                 if (!tradingActive) {
1315                     require(
1316                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1317                         "Trading is not active."
1318                     );
1319                 }
1320 
1321                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1322                 if (transferDelayEnabled) {
1323                     if (
1324                         to != owner() &&
1325                         to != address(uniswapV2Router) &&
1326                         to != address(uniswapV2Pair)
1327                     ) {
1328                         require(
1329                             _holderLastTransferTimestamp[tx.origin] <
1330                                 block.number,
1331                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1332                         );
1333                         _holderLastTransferTimestamp[tx.origin] = block.number;
1334                     }
1335                 }
1336 
1337                 //when buy
1338                 if (
1339                     automatedMarketMakerPairs[from] &&
1340                     !_isExcludedMaxTransactionAmount[to]
1341                 ) {
1342                     require(
1343                         amount <= maxTransactionAmount,
1344                         "Buy transfer amount exceeds the maxTransactionAmount."
1345                     );
1346                     require(
1347                         amount + balanceOf(to) <= maxWallet,
1348                         "Max wallet exceeded"
1349                     );
1350                 }
1351                 //when sell
1352                 else if (
1353                     automatedMarketMakerPairs[to] &&
1354                     !_isExcludedMaxTransactionAmount[from]
1355                 ) {
1356                     require(
1357                         amount <= maxTransactionAmount,
1358                         "Sell transfer amount exceeds the maxTransactionAmount."
1359                     );
1360                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1361                     require(
1362                         amount + balanceOf(to) <= maxWallet,
1363                         "Max wallet exceeded"
1364                     );
1365                 }
1366             }
1367         }
1368 
1369         uint256 contractTokenBalance = balanceOf(address(this));
1370 
1371         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1372 
1373         if (
1374             canSwap &&
1375             swapEnabled &&
1376             !swapping &&
1377             !automatedMarketMakerPairs[from] &&
1378             !_isExcludedFromFees[from] &&
1379             !_isExcludedFromFees[to]
1380         ) {
1381             swapping = true;
1382 
1383             swapBack();
1384 
1385             swapping = false;
1386         }
1387 
1388         bool takeFee = !swapping;
1389 
1390         // if any account belongs to _isExcludedFromFee account then remove the fee
1391         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1392             takeFee = false;
1393         }
1394 
1395         uint256 fees = 0;
1396         // only take fees on buys/sells, do not take on wallet transfers
1397         if (takeFee) {
1398             // on sell
1399             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1400                 fees = amount.mul(sellTotalFees).div(100);
1401 				tokensForCharity += (fees * sellCharityFee) / sellTotalFees;
1402                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1403                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1404                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1405             }
1406             // on buy
1407             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1408                 fees = amount.mul(buyTotalFees).div(100);
1409 				tokensForCharity += (fees * buyCharityFee) / buyTotalFees;
1410                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1411                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1412                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1413             }
1414 
1415             if (fees > 0) {
1416                 super._transfer(from, address(this), fees);
1417             }
1418 
1419             amount -= fees;
1420         }
1421 
1422         super._transfer(from, to, amount);
1423     }
1424 
1425     function swapTokensForEth(uint256 tokenAmount) private {
1426         // generate the uniswap pair path of token -> weth
1427         address[] memory path = new address[](2);
1428         path[0] = address(this);
1429         path[1] = uniswapV2Router.WETH();
1430 
1431         _approve(address(this), address(uniswapV2Router), tokenAmount);
1432 
1433         // make the swap
1434         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1435             tokenAmount,
1436             0, // accept any amount of ETH
1437             path,
1438             address(this),
1439             block.timestamp
1440         );
1441     }
1442 
1443     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1444         // approve token transfer to cover all possible scenarios
1445         _approve(address(this), address(uniswapV2Router), tokenAmount);
1446 
1447         // add the liquidity
1448         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1449             address(this),
1450             tokenAmount,
1451             0, // slippage is unavoidable
1452             0, // slippage is unavoidable
1453             devWallet,
1454             block.timestamp
1455         );
1456     }
1457 
1458     function swapBack() private {
1459         uint256 contractBalance = balanceOf(address(this));
1460         uint256 totalTokensToSwap = tokensForCharity + tokensForLiquidity + tokensForMarketing + tokensForDev;
1461         bool success;
1462 
1463         if (contractBalance == 0 || totalTokensToSwap == 0) {
1464             return;
1465         }
1466 
1467         if (contractBalance > swapTokensAtAmount * 20) {
1468             contractBalance = swapTokensAtAmount * 20;
1469         }
1470 
1471         // Halve the amount of liquidity tokens
1472         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1473         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1474 
1475         uint256 initialETHBalance = address(this).balance;
1476 
1477         swapTokensForEth(amountToSwapForETH);
1478 
1479         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1480 
1481 		uint256 ethForCharity = ethBalance.mul(tokensForCharity).div(totalTokensToSwap);
1482         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1483         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1484 
1485         uint256 ethForLiquidity = ethBalance - ethForCharity - ethForMarketing - ethForDev;
1486 
1487         tokensForLiquidity = 0;
1488 		tokensForCharity = 0;
1489         tokensForMarketing = 0;
1490         tokensForDev = 0;
1491 
1492         (success, ) = address(devWallet).call{value: ethForDev}("");
1493         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1494 
1495 
1496         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1497             addLiquidity(liquidityTokens, ethForLiquidity);
1498             emit SwapAndLiquify(
1499                 amountToSwapForETH,
1500                 ethForLiquidity,
1501                 tokensForLiquidity
1502             );
1503         }
1504 
1505         (success, ) = address(charityWallet).call{value: address(this).balance}("");
1506     }
1507 
1508 }