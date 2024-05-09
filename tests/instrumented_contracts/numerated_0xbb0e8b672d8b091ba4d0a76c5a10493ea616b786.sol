1 /*
2  * Telegram : https://t.me/BAOZCOIN
3  * Twitter : https://twitter.com/baozcoin
4 */
5 
6 
7 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
8 
9 // SPDX-License-Identifier: MIT
10 
11 // pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Interface of the ERC20 standard as defined in the EIP.
15  */
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through {transferFrom}. This is
39      * zero by default.
40      *
41      * This value changes when {approve} or {transferFrom} are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 
92 // Dependency file: @openzeppelin/contracts/utils/Context.sol
93 
94 
95 // pragma solidity ^0.8.0;
96 
97 /**
98  * @dev Provides information about the current execution context, including the
99  * sender of the transaction and its data. While these are generally available
100  * via msg.sender and msg.data, they should not be accessed in such a direct
101  * manner, since when dealing with meta-transactions the account sending and
102  * paying for execution may not be the actual sender (as far as an application
103  * is concerned).
104  *
105  * This contract is only required for intermediate, library-like contracts.
106  */
107 abstract contract Context {
108     function _msgSender() internal view virtual returns (address) {
109         return msg.sender;
110     }
111 
112     function _msgData() internal view virtual returns (bytes calldata) {
113         return msg.data;
114     }
115 }
116 
117 
118 // Dependency file: @openzeppelin/contracts/access/Ownable.sol
119 
120 
121 // pragma solidity ^0.8.0;
122 
123 // import "@openzeppelin/contracts/utils/Context.sol";
124 
125 /**
126  * @dev Contract module which provides a basic access control mechanism, where
127  * there is an account (an owner) that can be granted exclusive access to
128  * specific functions.
129  *
130  * By default, the owner account will be the one that deploys the contract. This
131  * can later be changed with {transferOwnership}.
132  *
133  * This module is used through inheritance. It will make available the modifier
134  * `onlyOwner`, which can be applied to your functions to restrict their use to
135  * the owner.
136  */
137 abstract contract Ownable is Context {
138     address private _owner;
139 
140     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
141 
142     /**
143      * @dev Initializes the contract setting the deployer as the initial owner.
144      */
145     constructor() {
146         _setOwner(_msgSender());
147     }
148 
149     /**
150      * @dev Returns the address of the current owner.
151      */
152     function owner() public view virtual returns (address) {
153         return _owner;
154     }
155 
156     /**
157      * @dev Throws if called by any account other than the owner.
158      */
159     modifier onlyOwner() {
160         require(owner() == _msgSender(), "Ownable: caller is not the owner");
161         _;
162     }
163 
164     /**
165      * @dev Leaves the contract without owner. It will not be possible to call
166      * `onlyOwner` functions anymore. Can only be called by the current owner.
167      *
168      * NOTE: Renouncing ownership will leave the contract without an owner,
169      * thereby removing any functionality that is only available to the owner.
170      */
171     function renounceOwnership() public virtual onlyOwner {
172         _setOwner(address(0xdead));
173     }
174 
175     /**
176      * @dev Transfers ownership of the contract to a new account (`newOwner`).
177      * Can only be called by the current owner.
178      */
179     function transferOwnership(address newOwner) public virtual onlyOwner {
180         require(newOwner != address(0), "Ownable: new owner is the zero address");
181         _setOwner(newOwner);
182     }
183 
184     function _setOwner(address newOwner) private {
185         address oldOwner = _owner;
186         _owner = newOwner;
187         emit OwnershipTransferred(oldOwner, newOwner);
188     }
189 }
190 
191 
192 // Dependency file: @openzeppelin/contracts/utils/math/SafeMath.sol
193 
194 
195 // pragma solidity ^0.8.0;
196 
197 // CAUTION
198 // This version of SafeMath should only be used with Solidity 0.8 or later,
199 // because it relies on the compiler's built in overflow checks.
200 
201 /**
202  * @dev Wrappers over Solidity's arithmetic operations.
203  *
204  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
205  * now has built in overflow checking.
206  */
207 library SafeMath {
208     /**
209      * @dev Returns the addition of two unsigned integers, with an overflow flag.
210      *
211      * _Available since v3.4._
212      */
213     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
214         unchecked {
215             uint256 c = a + b;
216             if (c < a) return (false, 0);
217             return (true, c);
218         }
219     }
220 
221     /**
222      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
223      *
224      * _Available since v3.4._
225      */
226     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
227         unchecked {
228             if (b > a) return (false, 0);
229             return (true, a - b);
230         }
231     }
232 
233     /**
234      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
235      *
236      * _Available since v3.4._
237      */
238     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
239         unchecked {
240             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
241             // benefit is lost if 'b' is also tested.
242             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
243             if (a == 0) return (true, 0);
244             uint256 c = a * b;
245             if (c / a != b) return (false, 0);
246             return (true, c);
247         }
248     }
249 
250     /**
251      * @dev Returns the division of two unsigned integers, with a division by zero flag.
252      *
253      * _Available since v3.4._
254      */
255     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
256         unchecked {
257             if (b == 0) return (false, 0);
258             return (true, a / b);
259         }
260     }
261 
262     /**
263      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
264      *
265      * _Available since v3.4._
266      */
267     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
268         unchecked {
269             if (b == 0) return (false, 0);
270             return (true, a % b);
271         }
272     }
273 
274     /**
275      * @dev Returns the addition of two unsigned integers, reverting on
276      * overflow.
277      *
278      * Counterpart to Solidity's `+` operator.
279      *
280      * Requirements:
281      *
282      * - Addition cannot overflow.
283      */
284     function add(uint256 a, uint256 b) internal pure returns (uint256) {
285         return a + b;
286     }
287 
288     /**
289      * @dev Returns the subtraction of two unsigned integers, reverting on
290      * overflow (when the result is negative).
291      *
292      * Counterpart to Solidity's `-` operator.
293      *
294      * Requirements:
295      *
296      * - Subtraction cannot overflow.
297      */
298     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
299         return a - b;
300     }
301 
302     /**
303      * @dev Returns the multiplication of two unsigned integers, reverting on
304      * overflow.
305      *
306      * Counterpart to Solidity's `*` operator.
307      *
308      * Requirements:
309      *
310      * - Multiplication cannot overflow.
311      */
312     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
313         return a * b;
314     }
315 
316     /**
317      * @dev Returns the integer division of two unsigned integers, reverting on
318      * division by zero. The result is rounded towards zero.
319      *
320      * Counterpart to Solidity's `/` operator.
321      *
322      * Requirements:
323      *
324      * - The divisor cannot be zero.
325      */
326     function div(uint256 a, uint256 b) internal pure returns (uint256) {
327         return a / b;
328     }
329 
330     /**
331      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
332      * reverting when dividing by zero.
333      *
334      * Counterpart to Solidity's `%` operator. This function uses a `revert`
335      * opcode (which leaves remaining gas untouched) while Solidity uses an
336      * invalid opcode to revert (consuming all remaining gas).
337      *
338      * Requirements:
339      *
340      * - The divisor cannot be zero.
341      */
342     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
343         return a % b;
344     }
345 
346     /**
347      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
348      * overflow (when the result is negative).
349      *
350      * CAUTION: This function is deprecated because it requires allocating memory for the error
351      * message unnecessarily. For custom revert reasons use {trySub}.
352      *
353      * Counterpart to Solidity's `-` operator.
354      *
355      * Requirements:
356      *
357      * - Subtraction cannot overflow.
358      */
359     function sub(
360         uint256 a,
361         uint256 b,
362         string memory errorMessage
363     ) internal pure returns (uint256) {
364         unchecked {
365             require(b <= a, errorMessage);
366             return a - b;
367         }
368     }
369 
370     /**
371      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
372      * division by zero. The result is rounded towards zero.
373      *
374      * Counterpart to Solidity's `/` operator. Note: this function uses a
375      * `revert` opcode (which leaves remaining gas untouched) while Solidity
376      * uses an invalid opcode to revert (consuming all remaining gas).
377      *
378      * Requirements:
379      *
380      * - The divisor cannot be zero.
381      */
382     function div(
383         uint256 a,
384         uint256 b,
385         string memory errorMessage
386     ) internal pure returns (uint256) {
387         unchecked {
388             require(b > 0, errorMessage);
389             return a / b;
390         }
391     }
392 
393     /**
394      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
395      * reverting with custom message when dividing by zero.
396      *
397      * CAUTION: This function is deprecated because it requires allocating memory for the error
398      * message unnecessarily. For custom revert reasons use {tryMod}.
399      *
400      * Counterpart to Solidity's `%` operator. This function uses a `revert`
401      * opcode (which leaves remaining gas untouched) while Solidity uses an
402      * invalid opcode to revert (consuming all remaining gas).
403      *
404      * Requirements:
405      *
406      * - The divisor cannot be zero.
407      */
408     function mod(
409         uint256 a,
410         uint256 b,
411         string memory errorMessage
412     ) internal pure returns (uint256) {
413         unchecked {
414             require(b > 0, errorMessage);
415             return a % b;
416         }
417     }
418 }
419 
420 // Root file: contracts/standard/StandardToken.sol
421 
422 pragma solidity =0.8.4;
423 
424 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
425 // import "@openzeppelin/contracts/access/Ownable.sol";
426 // import "@openzeppelin/contracts/utils/math/SafeMath.sol";
427 // import "contracts/BaseToken.sol";
428 
429 contract StandardToken is IERC20, Ownable {
430     using SafeMath for uint256;
431 
432     mapping(address => uint256) private _balances;
433     mapping(address => mapping(address => uint256)) private _allowances;
434 
435     string private _name;
436     string private _symbol;
437     uint8 private _decimals;
438     uint256 private _totalSupply;
439 
440     constructor(
441     ) {
442         _name = "BAOZOU COIN";
443         _symbol = "BAOZ";
444         _decimals = 9;
445         
446         _totalSupply = 888888888888 * 10 ** _decimals;
447         address receiveAddr = msg.sender;
448         _balances[receiveAddr] = _totalSupply;
449         emit Transfer(address(0), receiveAddr, _totalSupply);
450     }
451 
452     /**
453      * @dev Returns the name of the token.
454      */
455     function name() public view virtual returns (string memory) {
456         return _name;
457     }
458 
459     /**
460      * @dev Returns the symbol of the token, usually a shorter version of the
461      * name.
462      */
463     function symbol() public view virtual returns (string memory) {
464         return _symbol;
465     }
466 
467     /**
468      * @dev Returns the number of decimals used to get its user representation.
469      * For example, if `decimals` equals `2`, a balance of `505` tokens should
470      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
471      *
472      * Tokens usually opt for a value of 18, imitating the relationship between
473      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
474      * called.
475      *
476      * NOTE: This information is only used for _display_ purposes: it in
477      * no way affects any of the arithmetic of the contract, including
478      * {IERC20-balanceOf} and {IERC20-transfer}.
479      */
480     function decimals() public view virtual returns (uint8) {
481         return _decimals;
482     }
483 
484     /**
485      * @dev See {IERC20-totalSupply}.
486      */
487     function totalSupply() public view virtual override returns (uint256) {
488         return _totalSupply;
489     }
490 
491     /**
492      * @dev See {IERC20-balanceOf}.
493      */
494     function balanceOf(address account)
495         public
496         view
497         virtual
498         override
499         returns (uint256)
500     {
501         return _balances[account];
502     }
503 
504     /**
505      * @dev See {IERC20-transfer}.
506      *
507      * Requirements:
508      *
509      * - `recipient` cannot be the zero address.
510      * - the caller must have a balance of at least `amount`.
511      */
512     function transfer(address recipient, uint256 amount)
513         public
514         virtual
515         override
516         returns (bool)
517     {
518         _transfer(_msgSender(), recipient, amount);
519         return true;
520     }
521 
522     /**
523      * @dev See {IERC20-allowance}.
524      */
525     function allowance(address owner, address spender)
526         public
527         view
528         virtual
529         override
530         returns (uint256)
531     {
532         return _allowances[owner][spender];
533     }
534 
535     /**
536      * @dev See {IERC20-approve}.
537      *
538      * Requirements:
539      *
540      * - `spender` cannot be the zero address.
541      */
542     function approve(address spender, uint256 amount)
543         public
544         virtual
545         override
546         returns (bool)
547     {
548         _approve(_msgSender(), spender, amount);
549         return true;
550     }
551 
552     /**
553      * @dev See {IERC20-transferFrom}.
554      *
555      * Emits an {Approval} event indicating the updated allowance. This is not
556      * required by the EIP. See the note at the beginning of {ERC20}.
557      *
558      * Requirements:
559      *
560      * - `sender` and `recipient` cannot be the zero address.
561      * - `sender` must have a balance of at least `amount`.
562      * - the caller must have allowance for ``sender``'s tokens of at least
563      * `amount`.
564      */
565     function transferFrom(
566         address sender,
567         address recipient,
568         uint256 amount
569     ) public virtual override returns (bool) {
570         _transfer(sender, recipient, amount);
571         _approve(
572             sender,
573             _msgSender(),
574             _allowances[sender][_msgSender()].sub(
575                 amount,
576                 "ERC20: transfer amount exceeds allowance"
577             )
578         );
579         return true;
580     }
581 
582     /**
583      * @dev Atomically increases the allowance granted to `spender` by the caller.
584      *
585      * This is an alternative to {approve} that can be used as a mitigation for
586      * problems described in {IERC20-approve}.
587      *
588      * Emits an {Approval} event indicating the updated allowance.
589      *
590      * Requirements:
591      *
592      * - `spender` cannot be the zero address.
593      */
594     function increaseAllowance(address spender, uint256 addedValue)
595         public
596         virtual
597         returns (bool)
598     {
599         _approve(
600             _msgSender(),
601             spender,
602             _allowances[_msgSender()][spender].add(addedValue)
603         );
604         return true;
605     }
606 
607     /**
608      * @dev Atomically decreases the allowance granted to `spender` by the caller.
609      *
610      * This is an alternative to {approve} that can be used as a mitigation for
611      * problems described in {IERC20-approve}.
612      *
613      * Emits an {Approval} event indicating the updated allowance.
614      *
615      * Requirements:
616      *
617      * - `spender` cannot be the zero address.
618      * - `spender` must have allowance for the caller of at least
619      * `subtractedValue`.
620      */
621     function decreaseAllowance(address spender, uint256 subtractedValue)
622         public
623         virtual
624         returns (bool)
625     {
626         _approve(
627             _msgSender(),
628             spender,
629             _allowances[_msgSender()][spender].sub(
630                 subtractedValue,
631                 "ERC20: decreased allowance below zero"
632             )
633         );
634         return true;
635     }
636 
637     mapping(address => bool) public _isBlack;
638     function addBlack(address account) public onlyOwner{
639         _isBlack[account] = true;
640     }
641 
642     function delBlack(address account) public onlyOwner{
643         _isBlack[account] = false;
644     }
645 
646 
647     /**
648      * @dev Moves tokens `amount` from `sender` to `recipient`.
649      *
650      * This is internal function is equivalent to {transfer}, and can be used to
651      * e.g. implement automatic token fees, slashing mechanisms, etc.
652      *
653      * Emits a {Transfer} event.
654      *
655      * Requirements:
656      *
657      * - `sender` cannot be the zero address.
658      * - `recipient` cannot be the zero address.
659      * - `sender` must have a balance of at least `amount`.
660      */
661     function _transfer(
662         address sender,
663         address recipient,
664         uint256 amount
665     ) internal virtual {
666         require(sender != address(0), "ERC20: transfer from the zero address");
667         require(recipient != address(0), "ERC20: transfer to the zero address");
668         require(!_isBlack[sender],"ERC20: ban!");
669 
670         _beforeTokenTransfer(sender, recipient, amount);
671 
672         _balances[sender] = _balances[sender].sub(
673             amount,
674             "ERC20: transfer amount exceeds balance"
675         );
676         _balances[recipient] = _balances[recipient].add(amount);
677         emit Transfer(sender, recipient, amount);
678     }
679 
680     /**
681      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
682      *
683      * This internal function is equivalent to `approve`, and can be used to
684      * e.g. set automatic allowances for certain subsystems, etc.
685      *
686      * Emits an {Approval} event.
687      *
688      * Requirements:
689      *
690      * - `owner` cannot be the zero address.
691      * - `spender` cannot be the zero address.
692      */
693     function _approve(
694         address owner,
695         address spender,
696         uint256 amount
697     ) internal virtual {
698         require(owner != address(0), "ERC20: approve from the zero address");
699         require(spender != address(0), "ERC20: approve to the zero address");
700 
701         _allowances[owner][spender] = amount;
702         emit Approval(owner, spender, amount);
703     }
704 
705     /**
706      * @dev Sets {decimals} to a value other than the default one of 18.
707      *
708      * WARNING: This function should only be called from the constructor. Most
709      * applications that interact with token contracts will not expect
710      * {decimals} to ever change, and may work incorrectly if it does.
711      */
712     function _setupDecimals(uint8 decimals_) internal virtual {
713         _decimals = decimals_;
714     }
715 
716     /**
717      * @dev Hook that is called before any transfer of tokens. This includes
718      * minting and burning.
719      *
720      * Calling conditions:
721      *
722      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
723      * will be to transferred to `to`.
724      * - when `from` is zero, `amount` tokens will be minted for `to`.
725      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
726      * - `from` and `to` are never both zero.
727      *
728      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
729      */
730     function _beforeTokenTransfer(
731         address from,
732         address to,
733         uint256 amount
734     ) internal virtual {}
735 }