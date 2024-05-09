1 /*
2     Rebler is a crypto social forum where people can talk about new list, new pair and new project. 
3 
4     What's Reddit current problem?
5     There is too much content, too distracting and too many bots.
6     Rebler aims to become the most coveted crypto social network where people can freely talk about new tokens, 
7     projects that have yet to be open for sale, private sale, public sale and much more.
8     Each user can have a Rebler account and everyone can be followed by other accounts, just like a social network.
9 
10     .______       _______ .______    __       _______ .______      
11     |   _  \     |   ____||   _  \  |  |     |   ____||   _  \     
12     |  |_)  |    |  |__   |  |_)  | |  |     |  |__   |  |_)  |    
13     |      /     |   __|  |   _  <  |  |     |   __|  |      /     
14     |  |\  \----.|  |____ |  |_)  | |  `----.|  |____ |  |\  \----.
15     | _| `._____||_______||______/  |_______||_______|| _| `._____|
16 
17     Telegram: https://t.me/reblerthecryptoforum
18 
19 */
20 
21 // SPDX-License-Identifier: MIT
22 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
23 pragma experimental ABIEncoderV2;
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
824 ////// src/IUniswapV2Factory.sol
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
858 ////// src/IUniswapV2Pair.sol
859 /* pragma solidity 0.8.10; */
860 /* pragma experimental ABIEncoderV2; */
861 
862 interface IUniswapV2Pair {
863     event Approval(
864         address indexed owner,
865         address indexed spender,
866         uint256 value
867     );
868     event Transfer(address indexed from, address indexed to, uint256 value);
869 
870     function name() external pure returns (string memory);
871 
872     function symbol() external pure returns (string memory);
873 
874     function decimals() external pure returns (uint8);
875 
876     function totalSupply() external view returns (uint256);
877 
878     function balanceOf(address owner) external view returns (uint256);
879 
880     function allowance(address owner, address spender)
881         external
882         view
883         returns (uint256);
884 
885     function approve(address spender, uint256 value) external returns (bool);
886 
887     function transfer(address to, uint256 value) external returns (bool);
888 
889     function transferFrom(
890         address from,
891         address to,
892         uint256 value
893     ) external returns (bool);
894 
895     function DOMAIN_SEPARATOR() external view returns (bytes32);
896 
897     function PERMIT_TYPEHASH() external pure returns (bytes32);
898 
899     function nonces(address owner) external view returns (uint256);
900 
901     function permit(
902         address owner,
903         address spender,
904         uint256 value,
905         uint256 deadline,
906         uint8 v,
907         bytes32 r,
908         bytes32 s
909     ) external;
910 
911     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
912     event Burn(
913         address indexed sender,
914         uint256 amount0,
915         uint256 amount1,
916         address indexed to
917     );
918     event Swap(
919         address indexed sender,
920         uint256 amount0In,
921         uint256 amount1In,
922         uint256 amount0Out,
923         uint256 amount1Out,
924         address indexed to
925     );
926     event Sync(uint112 reserve0, uint112 reserve1);
927 
928     function MINIMUM_LIQUIDITY() external pure returns (uint256);
929 
930     function factory() external view returns (address);
931 
932     function token0() external view returns (address);
933 
934     function token1() external view returns (address);
935 
936     function getReserves()
937         external
938         view
939         returns (
940             uint112 reserve0,
941             uint112 reserve1,
942             uint32 blockTimestampLast
943         );
944 
945     function price0CumulativeLast() external view returns (uint256);
946 
947     function price1CumulativeLast() external view returns (uint256);
948 
949     function kLast() external view returns (uint256);
950 
951     function mint(address to) external returns (uint256 liquidity);
952 
953     function burn(address to)
954         external
955         returns (uint256 amount0, uint256 amount1);
956 
957     function swap(
958         uint256 amount0Out,
959         uint256 amount1Out,
960         address to,
961         bytes calldata data
962     ) external;
963 
964     function skim(address to) external;
965 
966     function sync() external;
967 
968     function initialize(address, address) external;
969 }
970 
971 ////// src/IUniswapV2Router02.sol
972 /* pragma solidity 0.8.10; */
973 /* pragma experimental ABIEncoderV2; */
974 
975 interface IUniswapV2Router02 {
976     function factory() external pure returns (address);
977 
978     function WETH() external pure returns (address);
979 
980     function addLiquidity(
981         address tokenA,
982         address tokenB,
983         uint256 amountADesired,
984         uint256 amountBDesired,
985         uint256 amountAMin,
986         uint256 amountBMin,
987         address to,
988         uint256 deadline
989     )
990         external
991         returns (
992             uint256 amountA,
993             uint256 amountB,
994             uint256 liquidity
995         );
996 
997     function addLiquidityETH(
998         address token,
999         uint256 amountTokenDesired,
1000         uint256 amountTokenMin,
1001         uint256 amountETHMin,
1002         address to,
1003         uint256 deadline
1004     )
1005         external
1006         payable
1007         returns (
1008             uint256 amountToken,
1009             uint256 amountETH,
1010             uint256 liquidity
1011         );
1012 
1013     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1014         uint256 amountIn,
1015         uint256 amountOutMin,
1016         address[] calldata path,
1017         address to,
1018         uint256 deadline
1019     ) external;
1020 
1021     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1022         uint256 amountOutMin,
1023         address[] calldata path,
1024         address to,
1025         uint256 deadline
1026     ) external payable;
1027 
1028     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1029         uint256 amountIn,
1030         uint256 amountOutMin,
1031         address[] calldata path,
1032         address to,
1033         uint256 deadline
1034     ) external;
1035 }
1036 
1037 /* pragma solidity >=0.8.10; */
1038 
1039 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1040 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1041 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1042 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1043 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1044 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1045 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1046 
1047 contract ReblerToken is ERC20, Ownable {
1048     using SafeMath for uint256;
1049 
1050     IUniswapV2Router02 public immutable uniswapV2Router;
1051     address public immutable uniswapV2Pair;
1052     address public constant deadAddress = address(0xdead);
1053 
1054     bool private swapping;
1055 
1056     address public marketingWallet;
1057     address public devWallet;
1058 
1059     uint256 public maxTransactionAmount;
1060     uint256 public swapTokensAtAmount;
1061     uint256 public maxWallet;
1062 
1063     uint256 public percentForLPBurn = 25; // 25 = .25%
1064     bool public lpBurnEnabled = true;
1065     uint256 public lpBurnFrequency = 3600 seconds;
1066     uint256 public lastLpBurnTime;
1067 
1068     uint256 public manualBurnFrequency = 30 minutes;
1069     uint256 public lastManualLpBurnTime;
1070 
1071     bool public limitsInEffect = true;
1072     bool public tradingActive = false;
1073     bool public swapEnabled = false;
1074 
1075     // Anti-bot and anti-whale mappings and variables
1076     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1077     bool public transferDelayEnabled = true;
1078 
1079     uint256 public buyTotalFees;
1080     uint256 public buyMarketingFee;
1081     uint256 public buyLiquidityFee;
1082     uint256 public buyDevFee;
1083 
1084     uint256 public sellTotalFees;
1085     uint256 public sellMarketingFee;
1086     uint256 public sellLiquidityFee;
1087     uint256 public sellDevFee;
1088 
1089     uint256 public tokensForMarketing;
1090     uint256 public tokensForLiquidity;
1091     uint256 public tokensForDev;
1092 
1093     /******************/
1094 
1095     // exlcude from fees and max transaction amount
1096     mapping(address => bool) private _isExcludedFromFees;
1097     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1098 
1099     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1100     // could be subject to a maximum transfer amount
1101     mapping(address => bool) public automatedMarketMakerPairs;
1102 
1103     event UpdateUniswapV2Router(
1104         address indexed newAddress,
1105         address indexed oldAddress
1106     );
1107 
1108     event ExcludeFromFees(address indexed account, bool isExcluded);
1109 
1110     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1111 
1112     event marketingWalletUpdated(
1113         address indexed newWallet,
1114         address indexed oldWallet
1115     );
1116 
1117     event devWalletUpdated(
1118         address indexed newWallet,
1119         address indexed oldWallet
1120     );
1121 
1122     event SwapAndLiquify(
1123         uint256 tokensSwapped,
1124         uint256 ethReceived,
1125         uint256 tokensIntoLiquidity
1126     );
1127 
1128     event AutoNukeLP();
1129 
1130     event ManualNukeLP();
1131 
1132     constructor() ERC20("The Crypto Forum", "Rebler") {
1133         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1134             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1135         );
1136 
1137         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1138         uniswapV2Router = _uniswapV2Router;
1139 
1140         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1141             .createPair(address(this), _uniswapV2Router.WETH());
1142         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1143         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1144 
1145         uint256 _buyMarketingFee = 5;
1146         uint256 _buyLiquidityFee = 0;
1147         uint256 _buyDevFee = 0;
1148 
1149         uint256 _sellMarketingFee = 5;
1150         uint256 _sellLiquidityFee = 0;
1151         uint256 _sellDevFee = 0;
1152 
1153         uint256 totalSupply = 1_000_000_000 * 1e18;
1154 
1155         maxTransactionAmount = 20_000_000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1156         maxWallet = 20_000_000 * 1e18; // 2% from total supply maxWallet
1157         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1158 
1159         buyMarketingFee = _buyMarketingFee;
1160         buyLiquidityFee = _buyLiquidityFee;
1161         buyDevFee = _buyDevFee;
1162         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1163 
1164         sellMarketingFee = _sellMarketingFee;
1165         sellLiquidityFee = _sellLiquidityFee;
1166         sellDevFee = _sellDevFee;
1167         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1168 
1169         marketingWallet = address(0x1Bd373a47e7A549222B58302754b62EA8028c66B); // set as marketing wallet
1170         devWallet = address(0x1Bd373a47e7A549222B58302754b62EA8028c66B); // set as dev wallet
1171 
1172         // exclude from paying fees or having max transaction amount
1173         excludeFromFees(owner(), true);
1174         excludeFromFees(address(this), true);
1175         excludeFromFees(address(0xdead), true);
1176 
1177         excludeFromMaxTransaction(owner(), true);
1178         excludeFromMaxTransaction(address(this), true);
1179         excludeFromMaxTransaction(address(0xdead), true);
1180 
1181         /*
1182             _mint is an internal function in ERC20.sol that is only called here,
1183             and CANNOT be called ever again
1184         */
1185         _mint(msg.sender, totalSupply);
1186     }
1187 
1188     receive() external payable {}
1189 
1190     // once enabled, can never be turned off
1191     function enableTrading() external onlyOwner {
1192         tradingActive = true;
1193         swapEnabled = true;
1194         lastLpBurnTime = block.timestamp;
1195     }
1196 
1197     // remove limits after token is stable
1198     function removeLimits() external onlyOwner returns (bool) {
1199         limitsInEffect = false;
1200         return true;
1201     }
1202 
1203     // disable Transfer delay - cannot be reenabled
1204     function disableTransferDelay() external onlyOwner returns (bool) {
1205         transferDelayEnabled = false;
1206         return true;
1207     }
1208 
1209     // change the minimum amount of tokens to sell from fees
1210     function updateSwapTokensAtAmount(uint256 newAmount)
1211         external
1212         onlyOwner
1213         returns (bool)
1214     {
1215         require(
1216             newAmount >= (totalSupply() * 1) / 100000,
1217             "Swap amount cannot be lower than 0.001% total supply."
1218         );
1219         require(
1220             newAmount <= (totalSupply() * 5) / 1000,
1221             "Swap amount cannot be higher than 0.5% total supply."
1222         );
1223         swapTokensAtAmount = newAmount;
1224         return true;
1225     }
1226 
1227     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1228         require(
1229             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1230             "Cannot set maxTransactionAmount lower than 0.1%"
1231         );
1232         maxTransactionAmount = newNum * (10**18);
1233     }
1234 
1235     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1236         require(
1237             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1238             "Cannot set maxWallet lower than 0.5%"
1239         );
1240         maxWallet = newNum * (10**18);
1241     }
1242 
1243     function excludeFromMaxTransaction(address updAds, bool isEx)
1244         public
1245         onlyOwner
1246     {
1247         _isExcludedMaxTransactionAmount[updAds] = isEx;
1248     }
1249 
1250     // only use to disable contract sales if absolutely necessary (emergency use only)
1251     function updateSwapEnabled(bool enabled) external onlyOwner {
1252         swapEnabled = enabled;
1253     }
1254 
1255     function updateBuyFees(
1256         uint256 _marketingFee,
1257         uint256 _liquidityFee,
1258         uint256 _devFee
1259     ) external onlyOwner {
1260         buyMarketingFee = _marketingFee;
1261         buyLiquidityFee = _liquidityFee;
1262         buyDevFee = _devFee;
1263         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1264         require(buyTotalFees <= 11, "Must keep fees at 11% or less");
1265     }
1266 
1267     function updateSellFees(
1268         uint256 _marketingFee,
1269         uint256 _liquidityFee,
1270         uint256 _devFee
1271     ) external onlyOwner {
1272         sellMarketingFee = _marketingFee;
1273         sellLiquidityFee = _liquidityFee;
1274         sellDevFee = _devFee;
1275         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1276         require(sellTotalFees <= 11, "Must keep fees at 11% or less");
1277     }
1278 
1279     function excludeFromFees(address account, bool excluded) public onlyOwner {
1280         _isExcludedFromFees[account] = excluded;
1281         emit ExcludeFromFees(account, excluded);
1282     }
1283 
1284     function setAutomatedMarketMakerPair(address pair, bool value)
1285         public
1286         onlyOwner
1287     {
1288         require(
1289             pair != uniswapV2Pair,
1290             "The pair cannot be removed from automatedMarketMakerPairs"
1291         );
1292 
1293         _setAutomatedMarketMakerPair(pair, value);
1294     }
1295 
1296     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1297         automatedMarketMakerPairs[pair] = value;
1298 
1299         emit SetAutomatedMarketMakerPair(pair, value);
1300     }
1301 
1302     function updateMarketingWallet(address newMarketingWallet)
1303         external
1304         onlyOwner
1305     {
1306         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1307         marketingWallet = newMarketingWallet;
1308     }
1309 
1310     function updateDevWallet(address newWallet) external onlyOwner {
1311         emit devWalletUpdated(newWallet, devWallet);
1312         devWallet = newWallet;
1313     }
1314 
1315     function isExcludedFromFees(address account) public view returns (bool) {
1316         return _isExcludedFromFees[account];
1317     }
1318 
1319     event BoughtEarly(address indexed sniper);
1320 
1321     function _transfer(
1322         address from,
1323         address to,
1324         uint256 amount
1325     ) internal override {
1326         require(from != address(0), "ERC20: transfer from the zero address");
1327         require(to != address(0), "ERC20: transfer to the zero address");
1328 
1329         if (amount == 0) {
1330             super._transfer(from, to, 0);
1331             return;
1332         }
1333 
1334         if (limitsInEffect) {
1335             if (
1336                 from != owner() &&
1337                 to != owner() &&
1338                 to != address(0) &&
1339                 to != address(0xdead) &&
1340                 !swapping
1341             ) {
1342                 if (!tradingActive) {
1343                     require(
1344                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1345                         "Trading is not active."
1346                     );
1347                 }
1348 
1349                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1350                 if (transferDelayEnabled) {
1351                     if (
1352                         to != owner() &&
1353                         to != address(uniswapV2Router) &&
1354                         to != address(uniswapV2Pair)
1355                     ) {
1356                         require(
1357                             _holderLastTransferTimestamp[tx.origin] <
1358                                 block.number,
1359                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1360                         );
1361                         _holderLastTransferTimestamp[tx.origin] = block.number;
1362                     }
1363                 }
1364 
1365                 //when buy
1366                 if (
1367                     automatedMarketMakerPairs[from] &&
1368                     !_isExcludedMaxTransactionAmount[to]
1369                 ) {
1370                     require(
1371                         amount <= maxTransactionAmount,
1372                         "Buy transfer amount exceeds the maxTransactionAmount."
1373                     );
1374                     require(
1375                         amount + balanceOf(to) <= maxWallet,
1376                         "Max wallet exceeded"
1377                     );
1378                 }
1379                 //when sell
1380                 else if (
1381                     automatedMarketMakerPairs[to] &&
1382                     !_isExcludedMaxTransactionAmount[from]
1383                 ) {
1384                     require(
1385                         amount <= maxTransactionAmount,
1386                         "Sell transfer amount exceeds the maxTransactionAmount."
1387                     );
1388                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1389                     require(
1390                         amount + balanceOf(to) <= maxWallet,
1391                         "Max wallet exceeded"
1392                     );
1393                 }
1394             }
1395         }
1396 
1397         uint256 contractTokenBalance = balanceOf(address(this));
1398 
1399         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1400 
1401         if (
1402             canSwap &&
1403             swapEnabled &&
1404             !swapping &&
1405             !automatedMarketMakerPairs[from] &&
1406             !_isExcludedFromFees[from] &&
1407             !_isExcludedFromFees[to]
1408         ) {
1409             swapping = true;
1410 
1411             swapBack();
1412 
1413             swapping = false;
1414         }
1415 
1416         if (
1417             !swapping &&
1418             automatedMarketMakerPairs[to] &&
1419             lpBurnEnabled &&
1420             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1421             !_isExcludedFromFees[from]
1422         ) {
1423             autoBurnLiquidityPairTokens();
1424         }
1425 
1426         bool takeFee = !swapping;
1427 
1428         // if any account belongs to _isExcludedFromFee account then remove the fee
1429         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1430             takeFee = false;
1431         }
1432 
1433         uint256 fees = 0;
1434         // only take fees on buys/sells, do not take on wallet transfers
1435         if (takeFee) {
1436             // on sell
1437             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1438                 fees = amount.mul(sellTotalFees).div(100);
1439                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1440                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1441                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1442             }
1443             // on buy
1444             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1445                 fees = amount.mul(buyTotalFees).div(100);
1446                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1447                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1448                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1449             }
1450 
1451             if (fees > 0) {
1452                 super._transfer(from, address(this), fees);
1453             }
1454 
1455             amount -= fees;
1456         }
1457 
1458         super._transfer(from, to, amount);
1459     }
1460 
1461     function swapTokensForEth(uint256 tokenAmount) private {
1462         // generate the uniswap pair path of token -> weth
1463         address[] memory path = new address[](2);
1464         path[0] = address(this);
1465         path[1] = uniswapV2Router.WETH();
1466 
1467         _approve(address(this), address(uniswapV2Router), tokenAmount);
1468 
1469         // make the swap
1470         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1471             tokenAmount,
1472             0, // accept any amount of ETH
1473             path,
1474             address(this),
1475             block.timestamp
1476         );
1477     }
1478 
1479     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1480         // approve token transfer to cover all possible scenarios
1481         _approve(address(this), address(uniswapV2Router), tokenAmount);
1482 
1483         // add the liquidity
1484         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1485             address(this),
1486             tokenAmount,
1487             0, // slippage is unavoidable
1488             0, // slippage is unavoidable
1489             deadAddress,
1490             block.timestamp
1491         );
1492     }
1493 
1494     function swapBack() private {
1495         uint256 contractBalance = balanceOf(address(this));
1496         uint256 totalTokensToSwap = tokensForLiquidity +
1497             tokensForMarketing +
1498             tokensForDev;
1499         bool success;
1500 
1501         if (contractBalance == 0 || totalTokensToSwap == 0) {
1502             return;
1503         }
1504 
1505         if (contractBalance > swapTokensAtAmount * 20) {
1506             contractBalance = swapTokensAtAmount * 20;
1507         }
1508 
1509         // Halve the amount of liquidity tokens
1510         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1511             totalTokensToSwap /
1512             2;
1513         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1514 
1515         uint256 initialETHBalance = address(this).balance;
1516 
1517         swapTokensForEth(amountToSwapForETH);
1518 
1519         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1520 
1521         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1522             totalTokensToSwap
1523         );
1524         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1525 
1526         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1527 
1528         tokensForLiquidity = 0;
1529         tokensForMarketing = 0;
1530         tokensForDev = 0;
1531 
1532         (success, ) = address(devWallet).call{value: ethForDev}("");
1533 
1534         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1535             addLiquidity(liquidityTokens, ethForLiquidity);
1536             emit SwapAndLiquify(
1537                 amountToSwapForETH,
1538                 ethForLiquidity,
1539                 tokensForLiquidity
1540             );
1541         }
1542 
1543         (success, ) = address(marketingWallet).call{
1544             value: address(this).balance
1545         }("");
1546     }
1547 
1548     function setAutoLPBurnSettings(
1549         uint256 _frequencyInSeconds,
1550         uint256 _percent,
1551         bool _Enabled
1552     ) external onlyOwner {
1553         require(
1554             _frequencyInSeconds >= 600,
1555             "cannot set buyback more often than every 10 minutes"
1556         );
1557         require(
1558             _percent <= 1000 && _percent >= 0,
1559             "Must set auto LP burn percent between 0% and 10%"
1560         );
1561         lpBurnFrequency = _frequencyInSeconds;
1562         percentForLPBurn = _percent;
1563         lpBurnEnabled = _Enabled;
1564     }
1565 
1566     function autoBurnLiquidityPairTokens() internal returns (bool) {
1567         lastLpBurnTime = block.timestamp;
1568 
1569         // get balance of liquidity pair
1570         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1571 
1572         // calculate amount to burn
1573         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1574             10000
1575         );
1576 
1577         // pull tokens from pancakePair liquidity and move to dead address permanently
1578         if (amountToBurn > 0) {
1579             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1580         }
1581 
1582         //sync price since this is not in a swap transaction!
1583         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1584         pair.sync();
1585         emit AutoNukeLP();
1586         return true;
1587     }
1588 
1589     function manualBurnLiquidityPairTokens(uint256 percent)
1590         external
1591         onlyOwner
1592         returns (bool)
1593     {
1594         require(
1595             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1596             "Must wait for cooldown to finish"
1597         );
1598         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1599         lastManualLpBurnTime = block.timestamp;
1600 
1601         // get balance of liquidity pair
1602         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1603 
1604         // calculate amount to burn
1605         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1606 
1607         // pull tokens from pancakePair liquidity and move to dead address permanently
1608         if (amountToBurn > 0) {
1609             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1610         }
1611 
1612         //sync price since this is not in a swap transaction!
1613         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1614         pair.sync();
1615         emit ManualNukeLP();
1616         return true;
1617     }
1618 }