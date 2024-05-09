1 // Sources flattened with hardhat v2.1.2 https://hardhat.org
2 
3 // File contracts/libraries/Ownable.sol
4 
5 pragma solidity ^0.7.0;
6 
7 
8 /**
9  * @title Ownable
10  * @dev The Ownable contract has an owner address, and provides basic authorization control
11  * functions, this simplifies the implementation of "user permissions".
12  */
13 contract Ownable {
14   address public owner;
15 
16   event OwnershipTransferred(
17     address indexed previousOwner,
18     address indexed newOwner
19   );
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param _newOwner The address to transfer ownership to.
32    */
33   function transferOwnership(address _newOwner) public onlyOwner {
34     _transferOwnership(_newOwner);
35   }
36 
37   /**
38    * @dev Transfers control of the contract to a newOwner.
39    * @param _newOwner The address to transfer ownership to.
40    */
41   function _transferOwnership(address _newOwner) internal {
42     require(_newOwner != address(0));
43     emit OwnershipTransferred(owner, _newOwner);
44     owner = _newOwner;
45   }
46 }
47 
48 
49 // File contracts/libraries/ReentrancyGuard.sol
50 
51 
52 pragma solidity >=0.6.0 <0.8.0;
53 
54 /**
55  * @dev Contract module that helps prevent reentrant calls to a function.
56  *
57  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
58  * available, which can be applied to functions to make sure there are no nested
59  * (reentrant) calls to them.
60  *
61  * Note that because there is a single `nonReentrant` guard, functions marked as
62  * `nonReentrant` may not call one another. This can be worked around by making
63  * those functions `private`, and then adding `external` `nonReentrant` entry
64  * points to them.
65  *
66  * TIP: If you would like to learn more about reentrancy and alternative ways
67  * to protect against it, check out our blog post
68  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
69  */
70 abstract contract ReentrancyGuard {
71     // Booleans are more expensive than uint256 or any type that takes up a full
72     // word because each write operation emits an extra SLOAD to first read the
73     // slot's contents, replace the bits taken up by the boolean, and then write
74     // back. This is the compiler's defense against contract upgrades and
75     // pointer aliasing, and it cannot be disabled.
76 
77     // The values being non-zero value makes deployment a bit more expensive,
78     // but in exchange the refund on every call to nonReentrant will be lower in
79     // amount. Since refunds are capped to a percentage of the total
80     // transaction's gas, it is best to keep them low in cases like this one, to
81     // increase the likelihood of the full refund coming into effect.
82     uint256 private constant _NOT_ENTERED = 1;
83     uint256 private constant _ENTERED = 2;
84 
85     uint256 private _status;
86 
87     constructor () {
88         _status = _NOT_ENTERED;
89     }
90 
91     /**
92      * @dev Prevents a contract from calling itself, directly or indirectly.
93      * Calling a `nonReentrant` function from another `nonReentrant`
94      * function is not supported. It is possible to prevent this from happening
95      * by making the `nonReentrant` function external, and make it call a
96      * `private` function that does the actual work.
97      */
98     modifier nonReentrant() {
99         // On the first call to nonReentrant, _notEntered will be true
100         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
101 
102         // Any calls to nonReentrant after this point will fail
103         _status = _ENTERED;
104 
105         _;
106 
107         // By storing the original value once again, a refund is triggered (see
108         // https://eips.ethereum.org/EIPS/eip-2200)
109         _status = _NOT_ENTERED;
110     }
111 }
112 
113 
114 // File contracts/token/utils/Context.sol
115 
116 
117 pragma solidity >=0.6.0 <0.8.0;
118 
119 /*
120  * @dev Provides information about the current execution context, including the
121  * sender of the transaction and its data. While these are generally available
122  * via msg.sender and msg.data, they should not be accessed in such a direct
123  * manner, since when dealing with GSN meta-transactions the account sending and
124  * paying for execution may not be the actual sender (as far as an application
125  * is concerned).
126  *
127  * This contract is only required for intermediate, library-like contracts.
128  */
129 abstract contract Context {
130     function _msgSender() internal view virtual returns (address payable) {
131         return msg.sender;
132     }
133 
134     function _msgData() internal view virtual returns (bytes memory) {
135         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
136         return msg.data;
137     }
138 }
139 
140 
141 // File contracts/token/ERC20/IERC20.sol
142 
143 
144 pragma solidity >=0.6.0 <0.8.0;
145 
146 /**
147  * @dev Interface of the ERC20 standard as defined in the EIP.
148  */
149 interface IERC20 {
150     /**
151      * @dev Returns the amount of tokens in existence.
152      */
153     function totalSupply() external view returns (uint256);
154 
155     /**
156      * @dev Returns the amount of tokens owned by `account`.
157      */
158     function balanceOf(address account) external view returns (uint256);
159 
160     /**
161      * @dev Moves `amount` tokens from the caller's account to `recipient`.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * Emits a {Transfer} event.
166      */
167     function transfer(address recipient, uint256 amount) external returns (bool);
168 
169     /**
170      * @dev Returns the remaining number of tokens that `spender` will be
171      * allowed to spend on behalf of `owner` through {transferFrom}. This is
172      * zero by default.
173      *
174      * This value changes when {approve} or {transferFrom} are called.
175      */
176     function allowance(address owner, address spender) external view returns (uint256);
177 
178     /**
179      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
180      *
181      * Returns a boolean value indicating whether the operation succeeded.
182      *
183      * IMPORTANT: Beware that changing an allowance with this method brings the risk
184      * that someone may use both the old and the new allowance by unfortunate
185      * transaction ordering. One possible solution to mitigate this race
186      * condition is to first reduce the spender's allowance to 0 and set the
187      * desired value afterwards:
188      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
189      *
190      * Emits an {Approval} event.
191      */
192     function approve(address spender, uint256 amount) external returns (bool);
193 
194     /**
195      * @dev Moves `amount` tokens from `sender` to `recipient` using the
196      * allowance mechanism. `amount` is then deducted from the caller's
197      * allowance.
198      *
199      * Returns a boolean value indicating whether the operation succeeded.
200      *
201      * Emits a {Transfer} event.
202      */
203     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
204 
205     /**
206      * @dev Emitted when `value` tokens are moved from one account (`from`) to
207      * another (`to`).
208      *
209      * Note that `value` may be zero.
210      */
211     event Transfer(address indexed from, address indexed to, uint256 value);
212 
213     /**
214      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
215      * a call to {approve}. `value` is the new allowance.
216      */
217     event Approval(address indexed owner, address indexed spender, uint256 value);
218 }
219 
220 
221 // File contracts/libraries/SafeMath.sol
222 
223 pragma solidity ^0.7.0;
224 
225 // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
226 // Subject to the MIT license.
227 
228 /**
229  * @dev Wrappers over Solidity's arithmetic operations with added overflow
230  * checks.
231  *
232  * Arithmetic operations in Solidity wrap on overflow. This can easily result
233  * in bugs, because programmers usually assume that an overflow raises an
234  * error, which is the standard behavior in high level programming languages.
235  * `SafeMath` restores this intuition by reverting the transaction when an
236  * operation overflows.
237  *
238  * Using this library instead of the unchecked operations eliminates an entire
239  * class of bugs, so it's recommended to use it always.
240  */
241 library SafeMath {
242     /**
243      * @dev Returns the addition of two unsigned integers, reverting on overflow.
244      *
245      * Counterpart to Solidity's `+` operator.
246      *
247      * Requirements:
248      * - Addition cannot overflow.
249      */
250     function add(uint256 a, uint256 b) internal pure returns (uint256) {
251         uint256 c = a + b;
252         require(c >= a, "SafeMath: addition overflow");
253 
254         return c;
255     }
256 
257     /**
258      * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.
259      *
260      * Counterpart to Solidity's `+` operator.
261      *
262      * Requirements:
263      * - Addition cannot overflow.
264      */
265     function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         uint256 c = a + b;
267         require(c >= a, errorMessage);
268 
269         return c;
270     }
271 
272     /**
273      * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).
274      *
275      * Counterpart to Solidity's `-` operator.
276      *
277      * Requirements:
278      * - Subtraction cannot underflow.
279      */
280     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
281         return sub(a, b, "SafeMath: subtraction underflow");
282     }
283 
284     /**
285      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).
286      *
287      * Counterpart to Solidity's `-` operator.
288      *
289      * Requirements:
290      * - Subtraction cannot underflow.
291      */
292     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
293         require(b <= a, errorMessage);
294         uint256 c = a - b;
295 
296         return c;
297     }
298 
299     /**
300      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
301      *
302      * Counterpart to Solidity's `*` operator.
303      *
304      * Requirements:
305      * - Multiplication cannot overflow.
306      */
307     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
308         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
309         // benefit is lost if 'b' is also tested.
310         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
311         if (a == 0) {
312             return 0;
313         }
314 
315         uint256 c = a * b;
316         require(c / a == b, "SafeMath: multiplication overflow");
317 
318         return c;
319     }
320 
321     /**
322      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
323      *
324      * Counterpart to Solidity's `*` operator.
325      *
326      * Requirements:
327      * - Multiplication cannot overflow.
328      */
329     function mul(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
330         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
331         // benefit is lost if 'b' is also tested.
332         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
333         if (a == 0) {
334             return 0;
335         }
336 
337         uint256 c = a * b;
338         require(c / a == b, errorMessage);
339 
340         return c;
341     }
342 
343     /**
344      * @dev Returns the integer division of two unsigned integers.
345      * Reverts on division by zero. The result is rounded towards zero.
346      *
347      * Counterpart to Solidity's `/` operator. Note: this function uses a
348      * `revert` opcode (which leaves remaining gas untouched) while Solidity
349      * uses an invalid opcode to revert (consuming all remaining gas).
350      *
351      * Requirements:
352      * - The divisor cannot be zero.
353      */
354     function div(uint256 a, uint256 b) internal pure returns (uint256) {
355         return div(a, b, "SafeMath: division by zero");
356     }
357 
358     /**
359      * @dev Returns the integer division of two unsigned integers.
360      * Reverts with custom message on division by zero. The result is rounded towards zero.
361      *
362      * Counterpart to Solidity's `/` operator. Note: this function uses a
363      * `revert` opcode (which leaves remaining gas untouched) while Solidity
364      * uses an invalid opcode to revert (consuming all remaining gas).
365      *
366      * Requirements:
367      * - The divisor cannot be zero.
368      */
369     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
370         // Solidity only automatically asserts when dividing by 0
371         require(b > 0, errorMessage);
372         uint256 c = a / b;
373         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
374 
375         return c;
376     }
377 
378     /**
379      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
380      * Reverts when dividing by zero.
381      *
382      * Counterpart to Solidity's `%` operator. This function uses a `revert`
383      * opcode (which leaves remaining gas untouched) while Solidity uses an
384      * invalid opcode to revert (consuming all remaining gas).
385      *
386      * Requirements:
387      * - The divisor cannot be zero.
388      */
389     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
390         return mod(a, b, "SafeMath: modulo by zero");
391     }
392 
393     /**
394      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
395      * Reverts with custom message when dividing by zero.
396      *
397      * Counterpart to Solidity's `%` operator. This function uses a `revert`
398      * opcode (which leaves remaining gas untouched) while Solidity uses an
399      * invalid opcode to revert (consuming all remaining gas).
400      *
401      * Requirements:
402      * - The divisor cannot be zero.
403      */
404     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
405         require(b != 0, errorMessage);
406         return a % b;
407     }
408 }
409 
410 
411 // File contracts/token/ERC20/ERC20.sol
412 
413 
414 pragma solidity >=0.6.0 <0.8.0;
415 
416 
417 
418 /**
419  * @dev Implementation of the {IERC20} interface.
420  *
421  * This implementation is agnostic to the way tokens are created. This means
422  * that a supply mechanism has to be added in a derived contract using {_mint}.
423  * For a generic mechanism see {ERC20PresetMinterPauser}.
424  *
425  * TIP: For a detailed writeup see our guide
426  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
427  * to implement supply mechanisms].
428  *
429  * We have followed general OpenZeppelin guidelines: functions revert instead
430  * of returning `false` on failure. This behavior is nonetheless conventional
431  * and does not conflict with the expectations of ERC20 applications.
432  *
433  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
434  * This allows applications to reconstruct the allowance for all accounts just
435  * by listening to said events. Other implementations of the EIP may not emit
436  * these events, as it isn't required by the specification.
437  *
438  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
439  * functions have been added to mitigate the well-known issues around setting
440  * allowances. See {IERC20-approve}.
441  */
442 contract ERC20 is Context, IERC20 {
443     using SafeMath for uint256;
444 
445     mapping (address => uint256) private _balances;
446 
447     mapping (address => mapping (address => uint256)) private _allowances;
448 
449     uint256 private _totalSupply;
450 
451     string private _name;
452     string private _symbol;
453     uint8 private _decimals;
454 
455     /**
456      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
457      * a default value of 18.
458      *
459      * To select a different value for {decimals}, use {_setupDecimals}.
460      *
461      * All three of these values are immutable: they can only be set once during
462      * construction.
463      */
464     constructor (string memory name_, string memory symbol_) {
465         _name = name_;
466         _symbol = symbol_;
467         _decimals = 18;
468         _totalSupply = 1000000e18;
469     }
470 
471     /**
472      * @dev Returns the name of the token.
473      */
474     function name() public view returns (string memory) {
475         return _name;
476     }
477 
478     /**
479      * @dev Returns the symbol of the token, usually a shorter version of the
480      * name.
481      */
482     function symbol() public view returns (string memory) {
483         return _symbol;
484     }
485 
486     /**
487      * @dev Returns the number of decimals used to get its user representation.
488      * For example, if `decimals` equals `2`, a balance of `505` tokens should
489      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
490      *
491      * Tokens usually opt for a value of 18, imitating the relationship between
492      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
493      * called.
494      *
495      * NOTE: This information is only used for _display_ purposes: it in
496      * no way affects any of the arithmetic of the contract, including
497      * {IERC20-balanceOf} and {IERC20-transfer}.
498      */
499     function decimals() public view returns (uint8) {
500         return _decimals;
501     }
502 
503     /**
504      * @dev See {IERC20-totalSupply}.
505      */
506     function totalSupply() public view override returns (uint256) {
507         return _totalSupply;
508     }
509 
510     /**
511      * @dev See {IERC20-balanceOf}.
512      */
513     function balanceOf(address account) public view override returns (uint256) {
514         return _balances[account];
515     }
516 
517     /**
518      * @dev See {IERC20-transfer}.
519      *
520      * Requirements:
521      *
522      * - `recipient` cannot be the zero address.
523      * - the caller must have a balance of at least `amount`.
524      */
525     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
526         _transfer(_msgSender(), recipient, amount);
527         return true;
528     }
529 
530     /**
531      * @dev See {IERC20-allowance}.
532      */
533     function allowance(address owner, address spender) public view virtual override returns (uint256) {
534         return _allowances[owner][spender];
535     }
536 
537     /**
538      * @dev See {IERC20-approve}.
539      *
540      * Requirements:
541      *
542      * - `spender` cannot be the zero address.
543      */
544     function approve(address spender, uint256 amount) public virtual override returns (bool) {
545         _approve(_msgSender(), spender, amount);
546         return true;
547     }
548 
549     /**
550      * @dev See {IERC20-transferFrom}.
551      *
552      * Emits an {Approval} event indicating the updated allowance. This is not
553      * required by the EIP. See the note at the beginning of {ERC20}.
554      *
555      * Requirements:
556      *
557      * - `sender` and `recipient` cannot be the zero address.
558      * - `sender` must have a balance of at least `amount`.
559      * - the caller must have allowance for ``sender``'s tokens of at least
560      * `amount`.
561      */
562     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
563         _transfer(sender, recipient, amount);
564         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
565         return true;
566     }
567 
568     /**
569      * @dev Atomically increases the allowance granted to `spender` by the caller.
570      *
571      * This is an alternative to {approve} that can be used as a mitigation for
572      * problems described in {IERC20-approve}.
573      *
574      * Emits an {Approval} event indicating the updated allowance.
575      *
576      * Requirements:
577      *
578      * - `spender` cannot be the zero address.
579      */
580     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
581         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
582         return true;
583     }
584 
585     /**
586      * @dev Atomically decreases the allowance granted to `spender` by the caller.
587      *
588      * This is an alternative to {approve} that can be used as a mitigation for
589      * problems described in {IERC20-approve}.
590      *
591      * Emits an {Approval} event indicating the updated allowance.
592      *
593      * Requirements:
594      *
595      * - `spender` cannot be the zero address.
596      * - `spender` must have allowance for the caller of at least
597      * `subtractedValue`.
598      */
599     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
600         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
601         return true;
602     }
603 
604     /**
605      * @dev Moves tokens `amount` from `sender` to `recipient`.
606      *
607      * This is internal function is equivalent to {transfer}, and can be used to
608      * e.g. implement automatic token fees, slashing mechanisms, etc.
609      *
610      * Emits a {Transfer} event.
611      *
612      * Requirements:
613      *
614      * - `sender` cannot be the zero address.
615      * - `recipient` cannot be the zero address.
616      * - `sender` must have a balance of at least `amount`.
617      */
618     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
619         require(sender != address(0), "ERC20: transfer from the zero address");
620         require(recipient != address(0), "ERC20: transfer to the zero address");
621 
622         _beforeTokenTransfer(sender, recipient, amount);
623 
624         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
625         _balances[recipient] = _balances[recipient].add(amount);
626         emit Transfer(sender, recipient, amount);
627     }
628 
629     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
630      * the total supply.
631      *
632      * Emits a {Transfer} event with `from` set to the zero address.
633      *
634      * Requirements:
635      *
636      * - `to` cannot be the zero address.
637      */
638     function _mint(address account, uint256 amount) internal virtual {
639         require(account != address(0), "ERC20: mint to the zero address");
640 
641         _beforeTokenTransfer(address(0), account, amount);
642 
643         _totalSupply = _totalSupply.add(amount);
644         _balances[account] = _balances[account].add(amount);
645         emit Transfer(address(0), account, amount);
646     }
647 
648     /**
649      * @dev Destroys `amount` tokens from `account`, reducing the
650      * total supply.
651      *
652      * Emits a {Transfer} event with `to` set to the zero address.
653      *
654      * Requirements:
655      *
656      * - `account` cannot be the zero address.
657      * - `account` must have at least `amount` tokens.
658      */
659     function _burn(address account, uint256 amount) internal virtual {
660         require(account != address(0), "ERC20: burn from the zero address");
661 
662         _beforeTokenTransfer(account, address(0), amount);
663 
664         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
665         _totalSupply = _totalSupply.sub(amount);
666         emit Transfer(account, address(0), amount);
667     }
668 
669     /**
670      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
671      *
672      * This internal function is equivalent to `approve`, and can be used to
673      * e.g. set automatic allowances for certain subsystems, etc.
674      *
675      * Emits an {Approval} event.
676      *
677      * Requirements:
678      *
679      * - `owner` cannot be the zero address.
680      * - `spender` cannot be the zero address.
681      */
682     function _approve(address owner, address spender, uint256 amount) internal virtual {
683         require(owner != address(0), "ERC20: approve from the zero address");
684         require(spender != address(0), "ERC20: approve to the zero address");
685 
686         _allowances[owner][spender] = amount;
687         emit Approval(owner, spender, amount);
688     }
689 
690     /**
691      * @dev Sets {decimals} to a value other than the default one of 18.
692      *
693      * WARNING: This function should only be called from the constructor. Most
694      * applications that interact with token contracts will not expect
695      * {decimals} to ever change, and may work incorrectly if it does.
696      */
697     function _setupDecimals(uint8 decimals_) internal {
698         _decimals = decimals_;
699     }
700 
701     /**
702      * @dev Hook that is called before any transfer of tokens. This includes
703      * minting and burning.
704      *
705      * Calling conditions:
706      *
707      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
708      * will be to transferred to `to`.
709      * - when `from` is zero, `amount` tokens will be minted for `to`.
710      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
711      * - `from` and `to` are never both zero.
712      *
713      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
714      */
715     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
716 }
717 
718 
719 // File contracts/token/ERC721/IERC165.sol
720 
721 
722 pragma solidity >=0.6.0 <0.8.0;
723 
724 /**
725  * @dev Interface of the ERC165 standard, as defined in the
726  * https://eips.ethereum.org/EIPS/eip-165[EIP].
727  *
728  * Implementers can declare support of contract interfaces, which can then be
729  * queried by others ({ERC165Checker}).
730  *
731  * For an implementation, see {ERC165}.
732  */
733 interface IERC165 {
734     /**
735      * @dev Returns true if this contract implements the interface defined by
736      * `interfaceId`. See the corresponding
737      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
738      * to learn more about how these ids are created.
739      *
740      * This function call must use less than 30 000 gas.
741      */
742     function supportsInterface(bytes4 interfaceId) external view returns (bool);
743 }
744 
745 
746 // File contracts/token/ERC721/IERC721.sol
747 
748 
749 pragma solidity >=0.6.0 <0.8.0;
750 
751 /**
752  * @dev Required interface of an ERC721 compliant contract.
753  */
754 interface IERC721 is IERC165 {
755     /**
756      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
757      */
758     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
759 
760     /**
761      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
762      */
763     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
764 
765     /**
766      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
767      */
768     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
769 
770     /**
771      * @dev Returns the number of tokens in ``owner``'s account.
772      */
773     function balanceOf(address owner) external view returns (uint256 balance);
774 
775     /**
776      * @dev Returns the owner of the `tokenId` token.
777      *
778      * Requirements:
779      *
780      * - `tokenId` must exist.
781      */
782     function ownerOf(uint256 tokenId) external view returns (address owner);
783 
784     /**
785      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
786      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
787      *
788      * Requirements:
789      *
790      * - `from` cannot be the zero address.
791      * - `to` cannot be the zero address.
792      * - `tokenId` token must exist and be owned by `from`.
793      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
794      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
795      *
796      * Emits a {Transfer} event.
797      */
798     function safeTransferFrom(address from, address to, uint256 tokenId) external;
799 
800     /**
801      * @dev Transfers `tokenId` token from `from` to `to`.
802      *
803      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
804      *
805      * Requirements:
806      *
807      * - `from` cannot be the zero address.
808      * - `to` cannot be the zero address.
809      * - `tokenId` token must be owned by `from`.
810      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
811      *
812      * Emits a {Transfer} event.
813      */
814     function transferFrom(address from, address to, uint256 tokenId) external;
815 
816     /**
817      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
818      * The approval is cleared when the token is transferred.
819      *
820      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
821      *
822      * Requirements:
823      *
824      * - The caller must own the token or be an approved operator.
825      * - `tokenId` must exist.
826      *
827      * Emits an {Approval} event.
828      */
829     function approve(address to, uint256 tokenId) external;
830 
831     /**
832      * @dev Returns the account approved for `tokenId` token.
833      *
834      * Requirements:
835      *
836      * - `tokenId` must exist.
837      */
838     function getApproved(uint256 tokenId) external view returns (address operator);
839 
840     /**
841      * @dev Approve or remove `operator` as an operator for the caller.
842      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
843      *
844      * Requirements:
845      *
846      * - The `operator` cannot be the caller.
847      *
848      * Emits an {ApprovalForAll} event.
849      */
850     function setApprovalForAll(address operator, bool _approved) external;
851 
852     /**
853      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
854      *
855      * See {setApprovalForAll}
856      */
857     function isApprovedForAll(address owner, address operator) external view returns (bool);
858 
859     /**
860       * @dev Safely transfers `tokenId` token from `from` to `to`.
861       *
862       * Requirements:
863       *
864       * - `from` cannot be the zero address.
865       * - `to` cannot be the zero address.
866       * - `tokenId` token must exist and be owned by `from`.
867       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
868       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
869       *
870       * Emits a {Transfer} event.
871       */
872     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
873 }
874 
875 
876 // File contracts/token/ERC721/IERC721Receiver.sol
877 
878 
879 pragma solidity >=0.6.0 <0.8.0;
880 
881 /**
882  * @title ERC721 token receiver interface
883  * @dev Interface for any contract that wants to support safeTransfers
884  * from ERC721 asset contracts.
885  */
886 interface IERC721Receiver {
887     /**
888      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
889      * by `operator` from `from`, this function is called.
890      *
891      * It must return its Solidity selector to confirm the token transfer.
892      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
893      *
894      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
895      */
896     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
897 }
898 
899 
900 // File contracts/tier/RedKiteTiers.sol
901 
902 pragma solidity ^0.7.0;
903 
904 
905 
906 
907 
908 contract RedKiteTiers is IERC721Receiver, Ownable, ReentrancyGuard {
909     using SafeMath for uint256;
910 
911     // Info of each user
912     struct UserInfo {
913         uint256 staked; // How many tokens the user has provided
914         uint256 stakedTime; // Block timestamp when the user provided token
915     }
916 
917     // RedKiteTiers allow to stake multi tokens to up your tier. Please
918     // visit the website to get token list or use the token contract to
919     // check it is supported or not.
920 
921     // Info of each Token
922     // Currency Rate with PKF: amount * rate / 10 ** decimals
923     // Default PKF: rate=1, decimals=0
924     struct ExternalToken {
925         address contractAddress;
926         uint256 decimals;
927         uint256 rate;
928         bool isERC721;
929         bool canStake;
930     }
931 
932     uint256 constant MAX_NUM_TIERS = 10;
933     uint8 currentMaxTier = 4;
934 
935     // Address take user's withdraw fee
936     address public penaltyWallet;
937     // The POLKAFOUNDRY TOKEN!
938     address public PKF;
939 
940     // Info of each user that stakes tokens
941     mapping(address => mapping(address => UserInfo)) public userInfo;
942     // Info of total Non-PKF token staked, converted with rate
943     mapping(address => uint256) public userExternalStaked;
944     // Minimum PKF need to stake each tier
945     uint256[MAX_NUM_TIERS] tierPrice;
946     // Percentage of penalties
947     uint256[6] public withdrawFeePercent;
948     // The maximum number of days of penalties
949     uint256[5] public daysLockLevel;
950     // Info of each token can stake
951     mapping(address => ExternalToken) public externalToken;
952 
953     bool public canEmergencyWithdraw;
954 
955     event StakedERC20(address indexed user, address token, uint256 amount);
956     event StakedSingleERC721(
957         address indexed user,
958         address token,
959         uint128 tokenId
960     );
961     event StakedBatchERC721(
962         address indexed user,
963         address token,
964         uint128[] tokenIds
965     );
966     event WithdrawnERC20(
967         address indexed user,
968         address token,
969         uint256 indexed amount,
970         uint256 fee,
971         uint256 lastStakedTime
972     );
973     event WithdrawnSingleERC721(
974         address indexed user,
975         address token,
976         uint128 tokenId,
977         uint256 lastStakedTime
978     );
979     event WithdrawnBatchERC721(
980         address indexed user,
981         address token,
982         uint128[] tokenIds,
983         uint256 lastStakedTime
984     );
985     event EmergencyWithdrawnERC20(
986         address indexed user,
987         address token,
988         uint256 amount,
989         uint256 lastStakedTime
990     );
991     event EmergencyWithdrawnERC721(
992         address indexed user,
993         address token,
994         uint128[] tokenIds,
995         uint256 lastStakedTime
996     );
997     event AddExternalToken(
998         address indexed token,
999         uint256 decimals,
1000         uint256 rate,
1001         bool isERC721,
1002         bool canStake
1003     );
1004     event ExternalTokenStatsChange(
1005         address indexed token,
1006         uint256 decimals,
1007         uint256 rate,
1008         bool canStake
1009     );
1010     event ChangePenaltyWallet(address indexed penaltyWallet);
1011 
1012     constructor(address _pkf, address _sPkf, address _uniLp, address _penaltyWallet) {
1013         owner = msg.sender;
1014         penaltyWallet = _penaltyWallet;
1015 
1016         PKF = _pkf;
1017 
1018         addExternalToken(_pkf, 0, 1 , false, true);
1019         addExternalToken(_sPkf, 0, 1, false, true);
1020         addExternalToken(_uniLp, 0, 150, false, true);
1021 
1022         tierPrice[1] = 500e18;
1023         tierPrice[2] = 5000e18;
1024         tierPrice[3] = 20000e18;
1025         tierPrice[4] = 60000e18;
1026 
1027         daysLockLevel[0] = 10 days;
1028         daysLockLevel[1] = 20 days;
1029         daysLockLevel[2] = 30 days;
1030         daysLockLevel[3] = 60 days;
1031         daysLockLevel[4] = 90 days;
1032     }
1033 
1034     function depositERC20(address _token, uint256 _amount)
1035         external
1036         nonReentrant()
1037     {
1038         if (_token == PKF) {
1039             IERC20(PKF).transferFrom(msg.sender, address(this), _amount);
1040         } else {
1041             require(
1042                 externalToken[_token].canStake == true,
1043                 "TIER::TOKEN_NOT_ACCEPTED"
1044             );
1045             IERC20(_token).transferFrom(msg.sender, address(this), _amount);
1046 
1047             ExternalToken storage token = externalToken[_token];
1048             userExternalStaked[msg.sender] = userExternalStaked[msg.sender].add(
1049                 _amount.mul(token.rate).div(10**token.decimals)
1050             );
1051         }
1052 
1053         userInfo[msg.sender][_token].staked = userInfo[msg.sender][_token]
1054             .staked
1055             .add(_amount);
1056         userInfo[msg.sender][_token].stakedTime = block.timestamp;
1057 
1058         emit StakedERC20(msg.sender, _token, _amount);
1059     }
1060 
1061     function depositSingleERC721(address _token, uint128 _tokenId)
1062         external
1063         nonReentrant()
1064     {
1065         require(
1066             externalToken[_token].canStake == true,
1067             "TIER::TOKEN_NOT_ACCEPTED"
1068         );
1069         IERC721(_token).safeTransferFrom(msg.sender, address(this), _tokenId);
1070 
1071         ExternalToken storage token = externalToken[_token];
1072         userExternalStaked[msg.sender] = userExternalStaked[msg.sender].add(
1073             token.rate
1074         );
1075 
1076         userInfo[msg.sender][_token].staked = userInfo[msg.sender][_token]
1077             .staked
1078             .add(1);
1079         userInfo[msg.sender][_token].stakedTime = block.timestamp;
1080 
1081         emit StakedSingleERC721(msg.sender, _token, _tokenId);
1082     }
1083 
1084     function depositBatchERC721(address _token, uint128[] memory _tokenIds)
1085         external
1086         nonReentrant()
1087     {
1088         require(
1089             externalToken[_token].canStake == true,
1090             "TIER::TOKEN_NOT_ACCEPTED"
1091         );
1092         _batchSafeTransferFrom(_token, msg.sender, address(this), _tokenIds);
1093 
1094         uint256 amount = _tokenIds.length;
1095         ExternalToken storage token = externalToken[_token];
1096         userExternalStaked[msg.sender] = userExternalStaked[msg.sender].add(
1097             amount.mul(token.rate)
1098         );
1099 
1100         userInfo[msg.sender][_token].staked = userInfo[msg.sender][_token]
1101             .staked
1102             .add(amount);
1103         userInfo[msg.sender][_token].stakedTime = block.timestamp;
1104 
1105         emit StakedBatchERC721(msg.sender, _token, _tokenIds);
1106     }
1107 
1108     function withdrawERC20(address _token, uint256 _amount)
1109         external
1110         nonReentrant()
1111     {
1112         UserInfo storage user = userInfo[msg.sender][_token];
1113         require(user.staked >= _amount, "not enough amount to withdraw");
1114 
1115         if (_token != PKF) {
1116             ExternalToken storage token = externalToken[_token];
1117             userExternalStaked[msg.sender] = userExternalStaked[msg.sender].sub(
1118                 _amount.mul(token.rate).div(10**token.decimals)
1119             );
1120         }
1121 
1122         uint256 toPunish = calculateWithdrawFee(msg.sender, _token, _amount);
1123         if (toPunish > 0) {
1124             IERC20(_token).transfer(penaltyWallet, toPunish);
1125         }
1126 
1127         user.staked = user.staked.sub(_amount);
1128 
1129         IERC20(_token).transfer(msg.sender, _amount.sub(toPunish));
1130         emit WithdrawnERC20(
1131             msg.sender,
1132             _token,
1133             _amount,
1134             toPunish,
1135             user.stakedTime
1136         );
1137     }
1138 
1139     function withdrawSingleERC721(address _token, uint128 _tokenId)
1140         external
1141         nonReentrant()
1142     {
1143         UserInfo storage user = userInfo[msg.sender][_token];
1144         require(user.staked >= 1, "not enough amount to withdraw");
1145 
1146         user.staked = user.staked.sub(1);
1147 
1148         ExternalToken storage token = externalToken[_token];
1149         userExternalStaked[msg.sender] = userExternalStaked[msg.sender].sub(
1150             token.rate
1151         );
1152 
1153         IERC721(_token).safeTransferFrom(address(this), msg.sender, _tokenId);
1154         emit WithdrawnSingleERC721(
1155             msg.sender,
1156             _token,
1157             _tokenId,
1158             user.stakedTime
1159         );
1160     }
1161 
1162     function withdrawBatchERC721(address _token, uint128[] memory _tokenIds)
1163         external
1164         nonReentrant()
1165     {
1166         UserInfo storage user = userInfo[msg.sender][_token];
1167         uint256 amount = _tokenIds.length;
1168         require(user.staked >= amount, "not enough amount to withdraw");
1169 
1170         user.staked = user.staked.sub(amount);
1171 
1172         ExternalToken storage token = externalToken[_token];
1173         userExternalStaked[msg.sender] = userExternalStaked[msg.sender].sub(
1174             amount.mul(token.rate)
1175         );
1176 
1177         _batchSafeTransferFrom(_token, address(this), msg.sender, _tokenIds);
1178         emit WithdrawnBatchERC721(
1179             msg.sender,
1180             _token,
1181             _tokenIds,
1182             user.stakedTime
1183         );
1184     }
1185 
1186     function setPenaltyWallet(address _penaltyWallet) external onlyOwner {
1187         require(
1188             penaltyWallet != _penaltyWallet,
1189             "TIER::ALREADY_PENALTY_WALLET"
1190         );
1191         penaltyWallet = _penaltyWallet;
1192 
1193         emit ChangePenaltyWallet(_penaltyWallet);
1194     }
1195 
1196     function updateEmergencyWithdrawStatus(bool _status) external onlyOwner {
1197         canEmergencyWithdraw = _status;
1198     }
1199 
1200     function emergencyWithdrawERC20(address _token) external {
1201         require(canEmergencyWithdraw, "function disabled");
1202         UserInfo storage user = userInfo[msg.sender][_token];
1203         require(user.staked > 0, "nothing to withdraw");
1204 
1205         uint256 _amount = user.staked;
1206         user.staked = 0;
1207 
1208         if (_token != PKF) {
1209           ExternalToken storage token = externalToken[_token];
1210           userExternalStaked[msg.sender] = userExternalStaked[msg.sender].sub(
1211               _amount.mul(token.rate).div(10**token.decimals)
1212           );
1213         }
1214 
1215         IERC20(_token).transfer(msg.sender, _amount);
1216         emit EmergencyWithdrawnERC20(
1217             msg.sender,
1218             _token,
1219             _amount,
1220             user.stakedTime
1221         );
1222     }
1223 
1224     function emergencyWithdrawERC721(address _token, uint128[] memory _tokenIds)
1225         external
1226     {
1227         require(canEmergencyWithdraw, "function disabled");
1228         UserInfo storage user = userInfo[msg.sender][_token];
1229         require(user.staked > 0, "nothing to withdraw");
1230 
1231         uint256 _amount = user.staked;
1232         user.staked = 0;
1233 
1234         ExternalToken storage token = externalToken[_token];
1235         userExternalStaked[msg.sender] = userExternalStaked[msg.sender].sub(
1236             _amount.mul(token.rate).div(10**token.decimals)
1237         );
1238 
1239         if (_amount == 1) {
1240             IERC721(_token).safeTransferFrom(
1241                 address(this),
1242                 msg.sender,
1243                 _tokenIds[0]
1244             );
1245         } else {
1246             _batchSafeTransferFrom(
1247                 _token,
1248                 address(this),
1249                 msg.sender,
1250                 _tokenIds
1251             );
1252         }
1253         emit EmergencyWithdrawnERC721(
1254             msg.sender,
1255             _token,
1256             _tokenIds,
1257             user.stakedTime
1258         );
1259     }
1260 
1261     function addExternalToken(
1262         address _token,
1263         uint256 _decimals,
1264         uint256 _rate,
1265         bool _isERC721,
1266         bool _canStake
1267     ) public onlyOwner {
1268         ExternalToken storage token = externalToken[_token];
1269 
1270         require(_rate > 0, "TIER::INVALID_TOKEN_RATE");
1271 
1272         token.contractAddress = _token;
1273         token.decimals = _decimals;
1274         token.rate = _rate;
1275         token.isERC721 = _isERC721;
1276         token.canStake = _canStake;
1277 
1278         emit AddExternalToken(_token, _decimals, _rate, _isERC721, _canStake);
1279     }
1280 
1281     function setExternalToken(
1282         address _token,
1283         uint256 _decimals,
1284         uint256 _rate,
1285         bool _canStake
1286     ) external onlyOwner {
1287         ExternalToken storage token = externalToken[_token];
1288 
1289         require(token.contractAddress == _token, "TIER::TOKEN_NOT_EXISTS");
1290         require(_rate > 0, "TIER::INVALID_TOKEN_RATE");
1291 
1292         token.decimals = _decimals;
1293         token.rate = _rate;
1294         token.canStake = _canStake;
1295 
1296         emit ExternalTokenStatsChange(_token, _decimals, _rate, _canStake);
1297     }
1298 
1299     function updateTier(uint8 _tierId, uint256 _amount) external onlyOwner {
1300         require(_tierId > 0 && _tierId <= MAX_NUM_TIERS, "invalid _tierId");
1301         tierPrice[_tierId] = _amount;
1302         if (_tierId > currentMaxTier) {
1303             currentMaxTier = _tierId;
1304         }
1305     }
1306 
1307     function updateWithdrawFee(uint256 _key, uint256 _percent)
1308         external
1309         onlyOwner
1310     {
1311         require(_percent < 100, "too high percent");
1312         withdrawFeePercent[_key] = _percent;
1313     }
1314 
1315     function updatePunishTime(uint256 _key, uint256 _days) external onlyOwner {
1316         require(_days >= 0, "too short time");
1317         daysLockLevel[_key] = _days * 1 days;
1318     }
1319 
1320     function getUserTier(address _userAddress)
1321         external
1322         view
1323         returns (uint8 res)
1324     {
1325         uint256 totalStaked =
1326             userInfo[_userAddress][PKF].staked.add(
1327                 userExternalStaked[_userAddress]
1328             );
1329 
1330         for (uint8 i = 1; i <= MAX_NUM_TIERS; i++) {
1331             if (tierPrice[i] == 0 || totalStaked < tierPrice[i]) {
1332                 return res;
1333             }
1334 
1335             res = i;
1336         }
1337     }
1338 
1339     function calculateWithdrawFee(
1340         address _userAddress,
1341         address _token,
1342         uint256 _amount
1343     ) public view returns (uint256) {
1344         UserInfo storage user = userInfo[_userAddress][_token];
1345         require(user.staked >= _amount, "not enough amount to withdraw");
1346 
1347         if (block.timestamp < user.stakedTime.add(daysLockLevel[0])) {
1348             return _amount.mul(withdrawFeePercent[0]).div(100); //30%
1349         }
1350 
1351         if (block.timestamp < user.stakedTime.add(daysLockLevel[1])) {
1352             return _amount.mul(withdrawFeePercent[1]).div(100); //25%
1353         }
1354 
1355         if (block.timestamp < user.stakedTime.add(daysLockLevel[2])) {
1356             return _amount.mul(withdrawFeePercent[2]).div(100); //20%
1357         }
1358 
1359         if (block.timestamp < user.stakedTime.add(daysLockLevel[3])) {
1360             return _amount.mul(withdrawFeePercent[3]).div(100); //10%
1361         }
1362 
1363         if (block.timestamp < user.stakedTime.add(daysLockLevel[4])) {
1364             return _amount.mul(withdrawFeePercent[4]).div(100); //5%
1365         }
1366 
1367         return _amount.mul(withdrawFeePercent[5]).div(100);
1368     }
1369 
1370     //frontend func
1371     function getTiers()
1372         external
1373         view
1374         returns (uint256[MAX_NUM_TIERS] memory buf)
1375     {
1376         for (uint8 i = 1; i < MAX_NUM_TIERS; i++) {
1377             if (tierPrice[i] == 0) {
1378                 return buf;
1379             }
1380             buf[i - 1] = tierPrice[i];
1381         }
1382 
1383         return buf;
1384     }
1385 
1386     function userTotalStaked(address _userAddress) external view returns (uint256) {
1387         return
1388             userInfo[_userAddress][PKF].staked.add(
1389                 userExternalStaked[_userAddress]
1390             );
1391     }
1392 
1393     function _batchSafeTransferFrom(
1394         address _token,
1395         address _from,
1396         address _recepient,
1397         uint128[] memory _tokenIds
1398     ) internal {
1399         for (uint256 i = 0; i != _tokenIds.length; i++) {
1400             IERC721(_token).safeTransferFrom(_from, _recepient, _tokenIds[i]);
1401         }
1402     }
1403 
1404     function onERC721Received(
1405         address,
1406         address,
1407         uint256,
1408         bytes memory
1409     ) public virtual override returns (bytes4) {
1410         return this.onERC721Received.selector;
1411     }
1412 }