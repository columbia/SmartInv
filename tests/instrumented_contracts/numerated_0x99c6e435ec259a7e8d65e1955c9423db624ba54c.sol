1 // Dependency file: contracts/GSN/Context.sol
2 
3 // pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor() internal {}
19 
20     // solhint-disable-previous-line no-empty-blocks
21 
22     function _msgSender() internal view returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 
33 // Dependency file: contracts/math/SafeMath.sol
34 
35 // pragma solidity ^0.5.0;
36 
37 /**
38  * @dev Wrappers over Solidity's arithmetic operations with added overflow
39  * checks.
40  *
41  * Arithmetic operations in Solidity wrap on overflow. This can easily result
42  * in bugs, because programmers usually assume that an overflow raises an
43  * error, which is the standard behavior in high level programming languages.
44  * `SafeMath` restores this intuition by reverting the transaction when an
45  * operation overflows.
46  *
47  * Using this library instead of the unchecked operations eliminates an entire
48  * class of bugs, so it's recommended to use it always.
49  */
50 library SafeMath {
51     /**
52      * @dev Returns the addition of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `+` operator.
56      *
57      * Requirements:
58      * - Addition cannot overflow.
59      */
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         require(c >= a, "SafeMath: addition overflow");
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the subtraction of two unsigned integers, reverting on
69      * overflow (when the result is negative).
70      *
71      * Counterpart to Solidity's `-` operator.
72      *
73      * Requirements:
74      * - Subtraction cannot overflow.
75      */
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         return sub(a, b, "SafeMath: subtraction overflow");
78     }
79 
80     /**
81      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
82      * overflow (when the result is negative).
83      *
84      * Counterpart to Solidity's `-` operator.
85      *
86      * Requirements:
87      * - Subtraction cannot overflow.
88      *
89      * _Available since v2.4.0._
90      */
91     function sub(
92         uint256 a,
93         uint256 b,
94         string memory errorMessage
95     ) internal pure returns (uint256) {
96         require(b <= a, errorMessage);
97         uint256 c = a - b;
98 
99         return c;
100     }
101 
102     /**
103      * @dev Returns the multiplication of two unsigned integers, reverting on
104      * overflow.
105      *
106      * Counterpart to Solidity's `*` operator.
107      *
108      * Requirements:
109      * - Multiplication cannot overflow.
110      */
111     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
112         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
113         // benefit is lost if 'b' is also tested.
114         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
115         if (a == 0) {
116             return 0;
117         }
118 
119         uint256 c = a * b;
120         require(c / a == b, "SafeMath: multiplication overflow");
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers. Reverts on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator. Note: this function uses a
130      * `revert` opcode (which leaves remaining gas untouched) while Solidity
131      * uses an invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      * - The divisor cannot be zero.
135      */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         return div(a, b, "SafeMath: division by zero");
138     }
139 
140     /**
141      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
142      * division by zero. The result is rounded towards zero.
143      *
144      * Counterpart to Solidity's `/` operator. Note: this function uses a
145      * `revert` opcode (which leaves remaining gas untouched) while Solidity
146      * uses an invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      * - The divisor cannot be zero.
150      *
151      * _Available since v2.4.0._
152      */
153     function div(
154         uint256 a,
155         uint256 b,
156         string memory errorMessage
157     ) internal pure returns (uint256) {
158         // Solidity only automatically asserts when dividing by 0
159         require(b > 0, errorMessage);
160         uint256 c = a / b;
161         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
168      * Reverts when dividing by zero.
169      *
170      * Counterpart to Solidity's `%` operator. This function uses a `revert`
171      * opcode (which leaves remaining gas untouched) while Solidity uses an
172      * invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      * - The divisor cannot be zero.
176      */
177     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
178         return mod(a, b, "SafeMath: modulo by zero");
179     }
180 
181     /**
182      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
183      * Reverts with custom message when dividing by zero.
184      *
185      * Counterpart to Solidity's `%` operator. This function uses a `revert`
186      * opcode (which leaves remaining gas untouched) while Solidity uses an
187      * invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      * - The divisor cannot be zero.
191      *
192      * _Available since v2.4.0._
193      */
194     function mod(
195         uint256 a,
196         uint256 b,
197         string memory errorMessage
198     ) internal pure returns (uint256) {
199         require(b != 0, errorMessage);
200         return a % b;
201     }
202 }
203 
204 
205 // Dependency file: contracts/token/IERC20.sol
206 
207 // pragma solidity ^0.5.0;
208 
209 /**
210  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
211  * the optional functions; to access them see {ERC20Detailed}.
212  */
213 interface IERC20 {
214     /**
215      * @dev Returns the amount of tokens in existence.
216      */
217     function totalSupply() external view returns (uint256);
218 
219     /**
220      * @dev Returns the amount of tokens owned by `account`.
221      */
222     function balanceOf(address account) external view returns (uint256);
223 
224     /**
225      * @dev Moves `amount` tokens from the caller's account to `recipient`.
226      *
227      * Returns a boolean value indicating whether the operation succeeded.
228      *
229      * Emits a {Transfer} event.
230      */
231     function transfer(address recipient, uint256 amount)
232         external
233         returns (bool);
234 
235     /**
236      * @dev Returns the remaining number of tokens that `spender` will be
237      * allowed to spend on behalf of `owner` through {transferFrom}. This is
238      * zero by default.
239      *
240      * This value changes when {approve} or {transferFrom} are called.
241      */
242     function allowance(address owner, address spender)
243         external
244         view
245         returns (uint256);
246 
247     /**
248      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
249      *
250      * Returns a boolean value indicating whether the operation succeeded.
251      *
252      * IMPORTANT: Beware that changing an allowance with this method brings the risk
253      * that someone may use both the old and the new allowance by unfortunate
254      * transaction ordering. One possible solution to mitigate this race
255      * condition is to first reduce the spender's allowance to 0 and set the
256      * desired value afterwards:
257      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
258      *
259      * Emits an {Approval} event.
260      */
261     function approve(address spender, uint256 amount) external returns (bool);
262 
263     /**
264      * @dev Moves `amount` tokens from `sender` to `recipient` using the
265      * allowance mechanism. `amount` is then deducted from the caller's
266      * allowance.
267      *
268      * Returns a boolean value indicating whether the operation succeeded.
269      *
270      * Emits a {Transfer} event.
271      */
272     function transferFrom(
273         address sender,
274         address recipient,
275         uint256 amount
276     ) external returns (bool);
277 
278     /**
279      * @dev Emitted when `value` tokens are moved from one account (`from`) to
280      * another (`to`).
281      *
282      * Note that `value` may be zero.
283      */
284     event Transfer(address indexed from, address indexed to, uint256 value);
285 
286     /**
287      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
288      * a call to {approve}. `value` is the new allowance.
289      */
290     event Approval(
291         address indexed owner,
292         address indexed spender,
293         uint256 value
294     );
295 }
296 
297 
298 // Dependency file: contracts/token/ERC20.sol
299 
300 // pragma solidity ^0.5.0;
301 
302 // import "contracts/math/SafeMath.sol";
303 // import "contracts/GSN/Context.sol";
304 // import "contracts/token/IERC20.sol";
305 
306 /**
307  * @dev Implementation of the {IERC20} interface.
308  *
309  * This implementation is agnostic to the way tokens are created. This means
310  * that a supply mechanism has to be added in a derived contract using {_mint}.
311  * For a generic mechanism see {ERC20Mintable}.
312  *
313  * TIP: For a detailed writeup see our guide
314  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
315  * to implement supply mechanisms].
316  *
317  * We have followed general OpenZeppelin guidelines: functions revert instead
318  * of returning `false` on failure. This behavior is nonetheless conventional
319  * and does not conflict with the expectations of ERC20 applications.
320  *
321  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
322  * This allows applications to reconstruct the allowance for all accounts just
323  * by listening to said events. Other implementations of the EIP may not emit
324  * these events, as it isn't required by the specification.
325  *
326  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
327  * functions have been added to mitigate the well-known issues around setting
328  * allowances. See {IERC20-approve}.
329  */
330 contract ERC20 is Context, IERC20 {
331     using SafeMath for uint256;
332 
333     mapping(address => uint256) private _balances;
334 
335     mapping(address => mapping(address => uint256)) private _allowances;
336 
337     uint256 private _totalSupply;
338 
339     /**
340      * @dev See {IERC20-totalSupply}.
341      */
342     function totalSupply() public view returns (uint256) {
343         return _totalSupply;
344     }
345 
346     /**
347      * @dev See {IERC20-balanceOf}.
348      */
349     function balanceOf(address account) public view returns (uint256) {
350         return _balances[account];
351     }
352 
353     /**
354      * @dev See {IERC20-transfer}.
355      *
356      * Requirements:
357      *
358      * - `recipient` cannot be the zero address.
359      * - the caller must have a balance of at least `amount`.
360      */
361     function transfer(address recipient, uint256 amount) public returns (bool) {
362         _transfer(_msgSender(), recipient, amount);
363         return true;
364     }
365 
366     /**
367      * @dev See {IERC20-allowance}.
368      */
369     function allowance(address owner, address spender)
370         public
371         view
372         returns (uint256)
373     {
374         return _allowances[owner][spender];
375     }
376 
377     /**
378      * @dev See {IERC20-approve}.
379      *
380      * Requirements:
381      *
382      * - `spender` cannot be the zero address.
383      */
384     function approve(address spender, uint256 amount) public returns (bool) {
385         _approve(_msgSender(), spender, amount);
386         return true;
387     }
388 
389     /**
390      * @dev See {IERC20-transferFrom}.
391      *
392      * Emits an {Approval} event indicating the updated allowance. This is not
393      * required by the EIP. See the note at the beginning of {ERC20};
394      *
395      * Requirements:
396      * - `sender` and `recipient` cannot be the zero address.
397      * - `sender` must have a balance of at least `amount`.
398      * - the caller must have allowance for `sender`'s tokens of at least
399      * `amount`.
400      */
401     function transferFrom(
402         address sender,
403         address recipient,
404         uint256 amount
405     ) public returns (bool) {
406         _transfer(sender, recipient, amount);
407         _approve(
408             sender,
409             _msgSender(),
410             _allowances[sender][_msgSender()].sub(
411                 amount,
412                 "ERC20: transfer amount exceeds allowance"
413             )
414         );
415         return true;
416     }
417 
418     /**
419      * @dev Atomically increases the allowance granted to `spender` by the caller.
420      *
421      * This is an alternative to {approve} that can be used as a mitigation for
422      * problems described in {IERC20-approve}.
423      *
424      * Emits an {Approval} event indicating the updated allowance.
425      *
426      * Requirements:
427      *
428      * - `spender` cannot be the zero address.
429      */
430     function increaseAllowance(address spender, uint256 addedValue)
431         public
432         returns (bool)
433     {
434         _approve(
435             _msgSender(),
436             spender,
437             _allowances[_msgSender()][spender].add(addedValue)
438         );
439         return true;
440     }
441 
442     /**
443      * @dev Atomically decreases the allowance granted to `spender` by the caller.
444      *
445      * This is an alternative to {approve} that can be used as a mitigation for
446      * problems described in {IERC20-approve}.
447      *
448      * Emits an {Approval} event indicating the updated allowance.
449      *
450      * Requirements:
451      *
452      * - `spender` cannot be the zero address.
453      * - `spender` must have allowance for the caller of at least
454      * `subtractedValue`.
455      */
456     function decreaseAllowance(address spender, uint256 subtractedValue)
457         public
458         returns (bool)
459     {
460         _approve(
461             _msgSender(),
462             spender,
463             _allowances[_msgSender()][spender].sub(
464                 subtractedValue,
465                 "ERC20: decreased allowance below zero"
466             )
467         );
468         return true;
469     }
470 
471     /**
472      * @dev Moves tokens `amount` from `sender` to `recipient`.
473      *
474      * This is internal function is equivalent to {transfer}, and can be used to
475      * e.g. implement automatic token fees, slashing mechanisms, etc.
476      *
477      * Emits a {Transfer} event.
478      *
479      * Requirements:
480      *
481      * - `sender` cannot be the zero address.
482      * - `recipient` cannot be the zero address.
483      * - `sender` must have a balance of at least `amount`.
484      */
485     function _transfer(
486         address sender,
487         address recipient,
488         uint256 amount
489     ) internal {
490         require(sender != address(0), "ERC20: transfer from the zero address");
491         require(recipient != address(0), "ERC20: transfer to the zero address");
492 
493         _balances[sender] = _balances[sender].sub(
494             amount,
495             "ERC20: transfer amount exceeds balance"
496         );
497         _balances[recipient] = _balances[recipient].add(amount);
498         emit Transfer(sender, recipient, amount);
499     }
500 
501     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
502      * the total supply.
503      *
504      * Emits a {Transfer} event with `from` set to the zero address.
505      *
506      * Requirements
507      *
508      * - `to` cannot be the zero address.
509      */
510     function _mint(address account, uint256 amount) internal {
511         require(account != address(0), "ERC20: mint to the zero address");
512 
513         _totalSupply = _totalSupply.add(amount);
514         _balances[account] = _balances[account].add(amount);
515         emit Transfer(address(0), account, amount);
516     }
517 
518     /**
519      * @dev Destroys `amount` tokens from `account`, reducing the
520      * total supply.
521      *
522      * Emits a {Transfer} event with `to` set to the zero address.
523      *
524      * Requirements
525      *
526      * - `account` cannot be the zero address.
527      * - `account` must have at least `amount` tokens.
528      */
529     function _burn(address account, uint256 amount) internal {
530         require(account != address(0), "ERC20: burn from the zero address");
531 
532         _balances[account] = _balances[account].sub(
533             amount,
534             "ERC20: burn amount exceeds balance"
535         );
536         _totalSupply = _totalSupply.sub(amount);
537         emit Transfer(account, address(0), amount);
538     }
539 
540     /**
541      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
542      *
543      * This is internal function is equivalent to `approve`, and can be used to
544      * e.g. set automatic allowances for certain subsystems, etc.
545      *
546      * Emits an {Approval} event.
547      *
548      * Requirements:
549      *
550      * - `owner` cannot be the zero address.
551      * - `spender` cannot be the zero address.
552      */
553     function _approve(
554         address owner,
555         address spender,
556         uint256 amount
557     ) internal {
558         require(owner != address(0), "ERC20: approve from the zero address");
559         require(spender != address(0), "ERC20: approve to the zero address");
560 
561         _allowances[owner][spender] = amount;
562         emit Approval(owner, spender, amount);
563     }
564 
565     /**
566      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
567      * from the caller's allowance.
568      *
569      * See {_burn} and {_approve}.
570      */
571     function _burnFrom(address account, uint256 amount) internal {
572         _burn(account, amount);
573         _approve(
574             account,
575             _msgSender(),
576             _allowances[account][_msgSender()].sub(
577                 amount,
578                 "ERC20: burn amount exceeds allowance"
579             )
580         );
581     }
582 }
583 
584 
585 // Dependency file: contracts/token/ERC20Detailed.sol
586 
587 // pragma solidity ^0.5.0;
588 
589 // import "contracts/token/IERC20.sol";
590 
591 /**
592  * @dev Optional functions from the ERC20 standard.
593  */
594 contract ERC20Detailed is IERC20 {
595     string private _name;
596     string private _symbol;
597     uint8 private _decimals;
598 
599     /**
600      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
601      * these values are immutable: they can only be set once during
602      * construction.
603      */
604     constructor(
605         string memory name,
606         string memory symbol,
607         uint8 decimals
608     ) public {
609         _name = name;
610         _symbol = symbol;
611         _decimals = decimals;
612     }
613 
614     /**
615      * @dev Returns the name of the token.
616      */
617     function name() public view returns (string memory) {
618         return _name;
619     }
620 
621     /**
622      * @dev Returns the symbol of the token, usually a shorter version of the
623      * name.
624      */
625     function symbol() public view returns (string memory) {
626         return _symbol;
627     }
628 
629     /**
630      * @dev Returns the number of decimals used to get its user representation.
631      * For example, if `decimals` equals `2`, a balance of `505` tokens should
632      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
633      *
634      * Tokens usually opt for a value of 18, imitating the relationship between
635      * Ether and Wei.
636      *
637      * NOTE: This information is only used for _display_ purposes: it in
638      * no way affects any of the arithmetic of the contract, including
639      * {IERC20-balanceOf} and {IERC20-transfer}.
640      */
641     function decimals() public view returns (uint8) {
642         return _decimals;
643     }
644 }
645 
646 
647 // Dependency file: contracts/FinminityBase.sol
648 
649 // pragma solidity ^0.5.0;
650 
651 // import 'contracts/GSN/Context.sol';
652 // import 'contracts/token/ERC20.sol';
653 // import 'contracts/token/ERC20Detailed.sol';
654 
655 contract FinminityBase is Context, ERC20, ERC20Detailed {
656     address public admin;
657     uint256 public nonce;
658 
659     enum Step {Burn, Mint}
660     event CrossTransfer(
661         address from,
662         address to,
663         uint256 amount,
664         uint256 date,
665         uint256 nonce,
666         Step indexed step
667     );
668 
669     /**
670      * @dev Constructor that gives _msgSender() all of existing tokens.
671      */
672     constructor(uint256 initialAmount)
673         public
674         ERC20Detailed('Finminity', 'FMT', 18)
675     {
676         admin = _msgSender();
677         _mint(_msgSender(), initialAmount * (10**uint256(decimals())));
678     }
679 
680     modifier onlyAdmin() {
681         require(
682             _msgSender() == admin,
683             'Only admin is allowed to execute this operation.'
684         );
685         _;
686     }
687 
688     function updateAdmin(address newAdmin) external onlyAdmin {
689         admin = newAdmin;
690     }
691 
692     function mint(address to, uint256 amount) external onlyAdmin {
693         _mint(to, amount);
694     }
695 
696     function transfer(address recipient, uint256 amount) public returns (bool) {
697         _transfer(_msgSender(), recipient, amount);
698         if (recipient == admin) {
699             _burn(admin, amount);
700             emit CrossTransfer(
701                 admin,
702                 _msgSender(),
703                 amount,
704                 block.timestamp,
705                 nonce,
706                 Step.Burn
707             );
708             nonce++;
709         }
710         return true;
711     }
712 }
713 
714 
715 // Root file: contracts/FinminityEth.sol
716 
717 pragma solidity ^0.5.0;
718 
719 // import 'contracts/FinminityBase.sol';
720 
721 contract FinminityEth is FinminityBase {
722     constructor() public FinminityBase(10000000) {}
723 }