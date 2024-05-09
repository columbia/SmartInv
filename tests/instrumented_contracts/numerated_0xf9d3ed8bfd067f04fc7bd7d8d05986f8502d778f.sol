1 // SPDX-License-Identifier: MIT
2 
3 // pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(
63         address sender,
64         address recipient,
65         uint256 amount
66     ) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 // Dependency file: @openzeppelin/contracts/utils/Context.sol
85 
86 
87 // pragma solidity ^0.8.0;
88 
89 /**
90  * @dev Provides information about the current execution context, including the
91  * sender of the transaction and its data. While these are generally available
92  * via msg.sender and msg.data, they should not be accessed in such a direct
93  * manner, since when dealing with meta-transactions the account sending and
94  * paying for execution may not be the actual sender (as far as an application
95  * is concerned).
96  *
97  * This contract is only required for intermediate, library-like contracts.
98  */
99 abstract contract Context {
100     function _msgSender() internal view virtual returns (address) {
101         return msg.sender;
102     }
103 
104     function _msgData() internal view virtual returns (bytes calldata) {
105         return msg.data;
106     }
107 }
108 
109 
110 // Dependency file: @openzeppelin/contracts/access/Ownable.sol
111 
112 
113 // pragma solidity ^0.8.0;
114 
115 // import "@openzeppelin/contracts/utils/Context.sol";
116 
117 /**
118  * @dev Contract module which provides a basic access control mechanism, where
119  * there is an account (an owner) that can be granted exclusive access to
120  * specific functions.
121  *
122  * By default, the owner account will be the one that deploys the contract. This
123  * can later be changed with {transferOwnership}.
124  *
125  * This module is used through inheritance. It will make available the modifier
126  * `onlyOwner`, which can be applied to your functions to restrict their use to
127  * the owner.
128  */
129 abstract contract Ownable is Context {
130     address private _owner;
131 
132     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
133 
134     /**
135      * @dev Initializes the contract setting the deployer as the initial owner.
136      */
137     constructor() {
138         _setOwner(_msgSender());
139     }
140 
141     /**
142      * @dev Returns the address of the current owner.
143      */
144     function owner() public view virtual returns (address) {
145         return _owner;
146     }
147 
148     /**
149      * @dev Throws if called by any account other than the owner.
150      */
151     modifier onlyOwner() {
152         require(owner() == _msgSender(), "Ownable: caller is not the owner");
153         _;
154     }
155 
156     /**
157      * @dev Leaves the contract without owner. It will not be possible to call
158      * `onlyOwner` functions anymore. Can only be called by the current owner.
159      *
160      * NOTE: Renouncing ownership will leave the contract without an owner,
161      * thereby removing any functionality that is only available to the owner.
162      */
163     function renounceOwnership() public virtual onlyOwner {
164         _setOwner(address(0));
165     }
166 
167     /**
168      * @dev Transfers ownership of the contract to a new account (`newOwner`).
169      * Can only be called by the current owner.
170      */
171     function transferOwnership(address newOwner) public virtual onlyOwner {
172         require(newOwner != address(0), "Ownable: new owner is the zero address");
173         _setOwner(newOwner);
174     }
175 
176     function _setOwner(address newOwner) private {
177         address oldOwner = _owner;
178         _owner = newOwner;
179         emit OwnershipTransferred(oldOwner, newOwner);
180     }
181 }
182 
183 
184 // Dependency file: @openzeppelin/contracts/utils/math/SafeMath.sol
185 
186 
187 // pragma solidity ^0.8.0;
188 
189 // CAUTION
190 // This version of SafeMath should only be used with Solidity 0.8 or later,
191 // because it relies on the compiler's built in overflow checks.
192 
193 /**
194  * @dev Wrappers over Solidity's arithmetic operations.
195  *
196  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
197  * now has built in overflow checking.
198  */
199 library SafeMath {
200     /**
201      * @dev Returns the addition of two unsigned integers, with an overflow flag.
202      *
203      * _Available since v3.4._
204      */
205     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
206         unchecked {
207             uint256 c = a + b;
208             if (c < a) return (false, 0);
209             return (true, c);
210         }
211     }
212 
213     /**
214      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
215      *
216      * _Available since v3.4._
217      */
218     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
219         unchecked {
220             if (b > a) return (false, 0);
221             return (true, a - b);
222         }
223     }
224 
225     /**
226      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
227      *
228      * _Available since v3.4._
229      */
230     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
231         unchecked {
232             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
233             // benefit is lost if 'b' is also tested.
234             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
235             if (a == 0) return (true, 0);
236             uint256 c = a * b;
237             if (c / a != b) return (false, 0);
238             return (true, c);
239         }
240     }
241 
242     /**
243      * @dev Returns the division of two unsigned integers, with a division by zero flag.
244      *
245      * _Available since v3.4._
246      */
247     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
248         unchecked {
249             if (b == 0) return (false, 0);
250             return (true, a / b);
251         }
252     }
253 
254     /**
255      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
256      *
257      * _Available since v3.4._
258      */
259     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
260         unchecked {
261             if (b == 0) return (false, 0);
262             return (true, a % b);
263         }
264     }
265 
266     /**
267      * @dev Returns the addition of two unsigned integers, reverting on
268      * overflow.
269      *
270      * Counterpart to Solidity's `+` operator.
271      *
272      * Requirements:
273      *
274      * - Addition cannot overflow.
275      */
276     function add(uint256 a, uint256 b) internal pure returns (uint256) {
277         return a + b;
278     }
279 
280     /**
281      * @dev Returns the subtraction of two unsigned integers, reverting on
282      * overflow (when the result is negative).
283      *
284      * Counterpart to Solidity's `-` operator.
285      *
286      * Requirements:
287      *
288      * - Subtraction cannot overflow.
289      */
290     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
291         return a - b;
292     }
293 
294     /**
295      * @dev Returns the multiplication of two unsigned integers, reverting on
296      * overflow.
297      *
298      * Counterpart to Solidity's `*` operator.
299      *
300      * Requirements:
301      *
302      * - Multiplication cannot overflow.
303      */
304     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
305         return a * b;
306     }
307 
308     /**
309      * @dev Returns the integer division of two unsigned integers, reverting on
310      * division by zero. The result is rounded towards zero.
311      *
312      * Counterpart to Solidity's `/` operator.
313      *
314      * Requirements:
315      *
316      * - The divisor cannot be zero.
317      */
318     function div(uint256 a, uint256 b) internal pure returns (uint256) {
319         return a / b;
320     }
321 
322     /**
323      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
324      * reverting when dividing by zero.
325      *
326      * Counterpart to Solidity's `%` operator. This function uses a `revert`
327      * opcode (which leaves remaining gas untouched) while Solidity uses an
328      * invalid opcode to revert (consuming all remaining gas).
329      *
330      * Requirements:
331      *
332      * - The divisor cannot be zero.
333      */
334     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
335         return a % b;
336     }
337 
338     /**
339      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
340      * overflow (when the result is negative).
341      *
342      * CAUTION: This function is deprecated because it requires allocating memory for the error
343      * message unnecessarily. For custom revert reasons use {trySub}.
344      *
345      * Counterpart to Solidity's `-` operator.
346      *
347      * Requirements:
348      *
349      * - Subtraction cannot overflow.
350      */
351     function sub(
352         uint256 a,
353         uint256 b,
354         string memory errorMessage
355     ) internal pure returns (uint256) {
356         unchecked {
357             require(b <= a, errorMessage);
358             return a - b;
359         }
360     }
361 
362     /**
363      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
364      * division by zero. The result is rounded towards zero.
365      *
366      * Counterpart to Solidity's `/` operator. Note: this function uses a
367      * `revert` opcode (which leaves remaining gas untouched) while Solidity
368      * uses an invalid opcode to revert (consuming all remaining gas).
369      *
370      * Requirements:
371      *
372      * - The divisor cannot be zero.
373      */
374     function div(
375         uint256 a,
376         uint256 b,
377         string memory errorMessage
378     ) internal pure returns (uint256) {
379         unchecked {
380             require(b > 0, errorMessage);
381             return a / b;
382         }
383     }
384 
385     /**
386      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
387      * reverting with custom message when dividing by zero.
388      *
389      * CAUTION: This function is deprecated because it requires allocating memory for the error
390      * message unnecessarily. For custom revert reasons use {tryMod}.
391      *
392      * Counterpart to Solidity's `%` operator. This function uses a `revert`
393      * opcode (which leaves remaining gas untouched) while Solidity uses an
394      * invalid opcode to revert (consuming all remaining gas).
395      *
396      * Requirements:
397      *
398      * - The divisor cannot be zero.
399      */
400     function mod(
401         uint256 a,
402         uint256 b,
403         string memory errorMessage
404     ) internal pure returns (uint256) {
405         unchecked {
406             require(b > 0, errorMessage);
407             return a % b;
408         }
409     }
410 }
411 
412 pragma solidity =0.8.4;
413 
414 contract Token is IERC20, Ownable {
415     using SafeMath for uint256;
416 
417 
418     mapping(address => uint256) private _balances;
419     mapping(address => mapping(address => uint256)) private _allowances;
420 
421     string private _name;
422     string private _symbol;
423     uint8 private _decimals;
424     uint256 private _totalSupply;
425 
426     constructor(
427         string memory name_,
428         string memory symbol_,
429         uint8 decimals_,
430         uint256 totalSupply_,
431         address serviceFeeReceiver_,
432         uint256 serviceFee_
433     ) payable {
434         _name = name_;
435         _symbol = symbol_;
436         _decimals = decimals_;
437         _totalSupply = totalSupply_ * 10**decimals_;
438         _balances[owner()] = _balances[owner()].add(_totalSupply);
439         emit Transfer(address(0), owner(), _totalSupply);
440         payable(serviceFeeReceiver_).transfer(serviceFee_);
441     }
442 
443 
444     /**
445      * @dev Returns the name of the token.
446      */
447     function name() public view virtual returns (string memory) {
448         return _name;
449     }
450 
451     /**
452      * @dev Returns the symbol of the token, usually a shorter version of the
453      * name.
454      */
455     function symbol() public view virtual returns (string memory) {
456         return _symbol;
457     }
458 
459     /**
460      * @dev Returns the number of decimals used to get its user representation.
461      * For example, if `decimals` equals `2`, a balance of `505` tokens should
462      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
463      *
464      * Tokens usually opt for a value of 18, imitating the relationship between
465      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
466      * called.
467      *
468      * NOTE: This information is only used for _display_ purposes: it in
469      * no way affects any of the arithmetic of the contract, including
470      * {IERC20-balanceOf} and {IERC20-transfer}.
471      */
472     function decimals() public view virtual returns (uint8) {
473         return _decimals;
474     }
475 
476     /**
477      * @dev See {IERC20-totalSupply}.
478      */
479     function totalSupply() public view virtual override returns (uint256) {
480         return _totalSupply;
481     }
482 
483     /**
484      * @dev See {IERC20-balanceOf}.
485      */
486     function balanceOf(address account)
487         public
488         view
489         virtual
490         override
491         returns (uint256)
492     {
493         return _balances[account];
494     }
495 
496     /**
497      * @dev See {IERC20-transfer}.
498      *
499      * Requirements:
500      *
501      * - `recipient` cannot be the zero address.
502      * - the caller must have a balance of at least `amount`.
503      */
504     function transfer(address recipient, uint256 amount)
505         public
506         virtual
507         override
508         returns (bool)
509     {
510         _transfer(_msgSender(), recipient, amount);
511         return true;
512     }
513 
514     /**
515      * @dev See {IERC20-allowance}.
516      */
517     function allowance(address owner, address spender)
518         public
519         view
520         virtual
521         override
522         returns (uint256)
523     {
524         return _allowances[owner][spender];
525     }
526 
527     /**
528      * @dev See {IERC20-approve}.
529      *
530      * Requirements:
531      *
532      * - `spender` cannot be the zero address.
533      */
534     function approve(address spender, uint256 amount)
535         public
536         virtual
537         override
538         returns (bool)
539     {
540         _approve(_msgSender(), spender, amount);
541         return true;
542     }
543 
544     /**
545      * @dev See {IERC20-transferFrom}.
546      *
547      * Emits an {Approval} event indicating the updated allowance. This is not
548      * required by the EIP. See the note at the beginning of {ERC20}.
549      *
550      * Requirements:
551      *
552      * - `sender` and `recipient` cannot be the zero address.
553      * - `sender` must have a balance of at least `amount`.
554      * - the caller must have allowance for ``sender``'s tokens of at least
555      * `amount`.
556      */
557     function transferFrom(
558         address sender,
559         address recipient,
560         uint256 amount
561     ) public virtual override returns (bool) {
562         _transfer(sender, recipient, amount);
563         _approve(
564             sender,
565             _msgSender(),
566             _allowances[sender][_msgSender()].sub(
567                 amount,
568                 "ERC20: transfer amount exceeds allowance"
569             )
570         );
571         return true;
572     }
573 
574     /**
575      * @dev Atomically increases the allowance granted to `spender` by the caller.
576      *
577      * This is an alternative to {approve} that can be used as a mitigation for
578      * problems described in {IERC20-approve}.
579      *
580      * Emits an {Approval} event indicating the updated allowance.
581      *
582      * Requirements:
583      *
584      * - `spender` cannot be the zero address.
585      */
586     function increaseAllowance(address spender, uint256 addedValue)
587         public
588         virtual
589         returns (bool)
590     {
591         _approve(
592             _msgSender(),
593             spender,
594             _allowances[_msgSender()][spender].add(addedValue)
595         );
596         return true;
597     }
598 
599     /**
600      * @dev Atomically decreases the allowance granted to `spender` by the caller.
601      *
602      * This is an alternative to {approve} that can be used as a mitigation for
603      * problems described in {IERC20-approve}.
604      *
605      * Emits an {Approval} event indicating the updated allowance.
606      *
607      * Requirements:
608      *
609      * - `spender` cannot be the zero address.
610      * - `spender` must have allowance for the caller of at least
611      * `subtractedValue`.
612      */
613     function decreaseAllowance(address spender, uint256 subtractedValue)
614         public
615         virtual
616         returns (bool)
617     {
618         _approve(
619             _msgSender(),
620             spender,
621             _allowances[_msgSender()][spender].sub(
622                 subtractedValue,
623                 "ERC20: decreased allowance below zero"
624             )
625         );
626         return true;
627     }
628 
629     /**
630      * @dev Moves tokens `amount` from `sender` to `recipient`.
631      *
632      * This is internal function is equivalent to {transfer}, and can be used to
633      * e.g. implement automatic token fees, slashing mechanisms, etc.
634      *
635      * Emits a {Transfer} event.
636      *
637      * Requirements:
638      *
639      * - `sender` cannot be the zero address.
640      * - `recipient` cannot be the zero address.
641      * - `sender` must have a balance of at least `amount`.
642      */
643     function _transfer(
644         address sender,
645         address recipient,
646         uint256 amount
647     ) internal virtual {
648         require(sender != address(0), "ERC20: transfer from the zero address");
649         require(recipient != address(0), "ERC20: transfer to the zero address");
650 
651         _balances[sender] = _balances[sender].sub(
652             amount,
653             "ERC20: transfer amount exceeds balance"
654         );
655         _balances[recipient] = _balances[recipient].add(amount);
656         emit Transfer(sender, recipient, amount);
657     }
658 
659     /**
660      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
661      *
662      * This internal function is equivalent to `approve`, and can be used to
663      * e.g. set automatic allowances for certain subsystems, etc.
664      *
665      * Emits an {Approval} event.
666      *
667      * Requirements:
668      *
669      * - `owner` cannot be the zero address.
670      * - `spender` cannot be the zero address.
671      */
672     function _approve(
673         address owner,
674         address spender,
675         uint256 amount
676     ) internal virtual {
677         require(owner != address(0), "ERC20: approve from the zero address");
678         require(spender != address(0), "ERC20: approve to the zero address");
679 
680         _allowances[owner][spender] = amount;
681         emit Approval(owner, spender, amount);
682     }
683 
684 
685 }