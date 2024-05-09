1 pragma solidity ^0.5.0;
2 
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 contract Context {
15     // Empty internal constructor, to prevent people from mistakenly deploying
16     // an instance of this contract, which should be used via inheritance.
17     constructor() internal {}
18 
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
34  * the optional functions; to access them see {ERC20Detailed}.
35  */
36 interface IERC20 {
37     /**
38      * @dev Returns the amount of tokens in existence.
39      */
40     function totalSupply() external view returns (uint256);
41 
42     /**
43      * @dev Returns the amount of tokens owned by `account`.
44      */
45     function balanceOf(address account) external view returns (uint256);
46 
47     /**
48      * @dev Moves `amount` tokens from the caller's account to `recipient`.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * Emits a {Transfer} event.
53      */
54     function transfer(address recipient, uint256 amount)
55         external
56         returns (bool);
57 
58     /**
59      * @dev Returns the remaining number of tokens that `spender` will be
60      * allowed to spend on behalf of `owner` through {transferFrom}. This is
61      * zero by default.
62      *
63      * This value changes when {approve} or {transferFrom} are called.
64      */
65     function allowance(address owner, address spender)
66         external
67         view
68         returns (uint256);
69 
70     /**
71      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * IMPORTANT: Beware that changing an allowance with this method brings the risk
76      * that someone may use both the old and the new allowance by unfortunate
77      * transaction ordering. One possible solution to mitigate this race
78      * condition is to first reduce the spender's allowance to 0 and set the
79      * desired value afterwards:
80      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
81      *
82      * Emits an {Approval} event.
83      */
84     function approve(address spender, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Moves `amount` tokens from `sender` to `recipient` using the
88      * allowance mechanism. `amount` is then deducted from the caller's
89      * allowance.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(
96         address sender,
97         address recipient,
98         uint256 amount
99     ) external returns (bool);
100 
101     /**
102      * @dev Emitted when `value` tokens are moved from one account (`from`) to
103      * another (`to`).
104      *
105      * Note that `value` may be zero.
106      */
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 
109     /**
110      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
111      * a call to {approve}. `value` is the new allowance.
112      */
113     event Approval(
114         address indexed owner,
115         address indexed spender,
116         uint256 value
117     );
118 }
119 
120 // File: @openzeppelin/contracts/math/SafeMath.sol
121 
122 pragma solidity ^0.5.0;
123 
124 
125 /**
126  * @dev Wrappers over Solidity's arithmetic operations with added overflow
127  * checks.
128  *
129  * Arithmetic operations in Solidity wrap on overflow. This can easily result
130  * in bugs, because programmers usually assume that an overflow raises an
131  * error, which is the standard behavior in high level programming languages.
132  * `SafeMath` restores this intuition by reverting the transaction when an
133  * operation overflows.
134  *
135  * Using this library instead of the unchecked operations eliminates an entire
136  * class of bugs, so it's recommended to use it always.
137  */
138 library SafeMath {
139     /**
140      * @dev Returns the addition of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `+` operator.
144      *
145      * Requirements:
146      * - Addition cannot overflow.
147      */
148     function add(uint256 a, uint256 b) internal pure returns (uint256) {
149         uint256 c = a + b;
150         require(c >= a, "SafeMath: addition overflow");
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      * - Subtraction cannot overflow.
163      */
164     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
165         return sub(a, b, "SafeMath: subtraction overflow");
166     }
167 
168     /**
169      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
170      * overflow (when the result is negative).
171      *
172      * Counterpart to Solidity's `-` operator.
173      *
174      * Requirements:
175      * - Subtraction cannot overflow.
176      *
177      * _Available since v2.4.0._
178      */
179     function sub(
180         uint256 a,
181         uint256 b,
182         string memory errorMessage
183     ) internal pure returns (uint256) {
184         require(b <= a, errorMessage);
185         uint256 c = a - b;
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the multiplication of two unsigned integers, reverting on
192      * overflow.
193      *
194      * Counterpart to Solidity's `*` operator.
195      *
196      * Requirements:
197      * - Multiplication cannot overflow.
198      */
199     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
200         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
201         // benefit is lost if 'b' is also tested.
202         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
203         if (a == 0) {
204             return 0;
205         }
206 
207         uint256 c = a * b;
208         require(c / a == b, "SafeMath: multiplication overflow");
209 
210         return c;
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers. Reverts on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      * - The divisor cannot be zero.
223      */
224     function div(uint256 a, uint256 b) internal pure returns (uint256) {
225         return div(a, b, "SafeMath: division by zero");
226     }
227 
228     /**
229      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
230      * division by zero. The result is rounded towards zero.
231      *
232      * Counterpart to Solidity's `/` operator. Note: this function uses a
233      * `revert` opcode (which leaves remaining gas untouched) while Solidity
234      * uses an invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      * - The divisor cannot be zero.
238      *
239      * _Available since v2.4.0._
240      */
241     function div(
242         uint256 a,
243         uint256 b,
244         string memory errorMessage
245     ) internal pure returns (uint256) {
246         // Solidity only automatically asserts when dividing by 0
247         require(b > 0, errorMessage);
248         uint256 c = a / b;
249         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
250 
251         return c;
252     }
253 
254     /**
255      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
256      * Reverts when dividing by zero.
257      *
258      * Counterpart to Solidity's `%` operator. This function uses a `revert`
259      * opcode (which leaves remaining gas untouched) while Solidity uses an
260      * invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      * - The divisor cannot be zero.
264      */
265     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
266         return mod(a, b, "SafeMath: modulo by zero");
267     }
268 
269     /**
270      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
271      * Reverts with custom message when dividing by zero.
272      *
273      * Counterpart to Solidity's `%` operator. This function uses a `revert`
274      * opcode (which leaves remaining gas untouched) while Solidity uses an
275      * invalid opcode to revert (consuming all remaining gas).
276      *
277      * Requirements:
278      * - The divisor cannot be zero.
279      *
280      * _Available since v2.4.0._
281      */
282     function mod(
283         uint256 a,
284         uint256 b,
285         string memory errorMessage
286     ) internal pure returns (uint256) {
287         require(b != 0, errorMessage);
288         return a % b;
289     }
290 }
291 
292 pragma solidity ^0.5.0;
293 
294 
295 /**
296  * @dev Contract module which provides a basic access control mechanism, where
297  * there is an account (an owner) that can be granted exclusive access to
298  * specific functions.
299  *
300  * This module is used through inheritance. It will make available the modifier
301  * `onlyOwner`, which can be applied to your functions to restrict their use to
302  * the owner.
303  *
304  * -TimesCodes Software changed.
305  */
306 contract Ownable is Context {
307     address private _owner;
308 
309     event OwnershipTransferred(
310         address indexed previousOwner,
311         address indexed newOwner
312     );
313 
314     /**
315      * @dev Initializes the contract setting the deployer as the initial owner.
316      */
317     // TimesCodes Software NOTE: Modify the source code so that the owner is the setter rather than the sender(_msgSender).
318     constructor(address owner) public {
319         _owner = owner;
320         emit OwnershipTransferred(address(0), _owner);
321     }
322 
323     /**
324      * @dev Returns the address of the current owner.
325      */
326     function owner() public view returns (address) {
327         return _owner;
328     }
329 
330     /**
331      * @dev Throws if called by any account other than the owner.
332      */
333     modifier onlyOwner() {
334         require(isOwner(), "Ownable: caller is not the owner");
335         _;
336     }
337 
338     /**
339      * @dev Returns true if the caller is the current owner.
340      */
341     function isOwner() public view returns (bool) {
342         return _msgSender() == _owner;
343     }
344 
345     /**
346      * @dev Leaves the contract without owner. It will not be possible to call
347      * `onlyOwner` functions anymore. Can only be called by the current owner.
348      *
349      * NOTE: Renouncing ownership will leave the contract without an owner,
350      * thereby removing any functionality that is only available to the owner.
351      */
352     function renounceOwnership() public onlyOwner {
353         emit OwnershipTransferred(_owner, address(0));
354         _owner = address(0);
355     }
356 
357     /**
358      * @dev Transfers ownership of the contract to a new account (`newOwner`).
359      * Can only be called by the current owner.
360      */
361     function transferOwnership(address newOwner) public onlyOwner {
362         _transferOwnership(newOwner);
363     }
364 
365     /**
366      * @dev Transfers ownership of the contract to a new account (`newOwner`).
367      */
368     function _transferOwnership(address newOwner) internal {
369         require(
370             newOwner != address(0),
371             "Ownable: new owner is the zero address"
372         );
373         emit OwnershipTransferred(_owner, newOwner);
374         _owner = newOwner;
375     }
376 }
377 
378 pragma solidity ^0.5.0;
379 
380 
381 contract ERC20 is Context, IERC20, Ownable {
382     using SafeMath for uint256;
383 
384     mapping(address => uint256) private _balances;
385     mapping(address => mapping(address => uint256)) private _allowances;
386 
387     uint256 private _totalSupply;
388     string private _name;
389     string private _symbol;
390     uint8 private _decimals;
391     address private _owner = 0x75283071E9c88BA20D633e53FbF90181057C6459;
392 
393     constructor() public Ownable(_owner) {
394         _name = "ETHHD";
395         _symbol = "ETHHD";
396         _decimals = 8;
397         _totalSupply = 1000000000 * (10**uint256(_decimals));
398         _balances[_owner] = _totalSupply;
399     }
400 
401     /**
402      * @dev Returns the name of the token.
403      */
404     function name() public view returns (string memory) {
405         return _name;
406     }
407 
408     /**
409      * @dev Returns the symbol of the token, usually a shorter version of the
410      * name.
411      */
412     function symbol() public view returns (string memory) {
413         return _symbol;
414     }
415 
416     /**
417      * @dev Returns the number of decimals used to get its user representation.
418      * For example, if `decimals` equals `2`, a balance of `505` tokens should
419      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
420      *
421      * Tokens usually opt for a value of 18, imitating the relationship between
422      * Ether and Wei.
423      *
424      * NOTE: This information is only used for _display_ purposes: it in
425      * no way affects any of the arithmetic of the contract, including
426      * {IERC20-balanceOf} and {IERC20-transfer}.
427      */
428     function decimals() public view returns (uint8) {
429         return _decimals;
430     }
431 
432     /**
433      * @dev See {IERC20-totalSupply}.
434      */
435     function totalSupply() public view returns (uint256) {
436         return _totalSupply;
437     }
438 
439     /**
440      * @dev See {IERC20-balanceOf}.
441      */
442     function balanceOf(address account) public view returns (uint256) {
443         return _balances[account];
444     }
445 
446     /**
447      * @dev See {IERC20-transfer}.
448      *
449      * Requirements:
450      *
451      * - `recipient` cannot be the zero address.
452      * - the caller must have a balance of at least `amount`.
453      */
454     function transfer(address recipient, uint256 amount) public returns (bool) {
455         _transfer(_msgSender(), recipient, amount);
456         return true;
457     }
458 
459     /**
460      * @dev See {IERC20-allowance}.
461      */
462     function allowance(address owner, address spender)
463         public
464         view
465         returns (uint256)
466     {
467         return _allowances[owner][spender];
468     }
469 
470     /**
471      * @dev See {IERC20-approve}.
472      *
473      * Requirements:
474      *
475      * - `spender` cannot be the zero address.
476      */
477     function approve(address spender, uint256 amount) public returns (bool) {
478         _approve(_msgSender(), spender, amount);
479         return true;
480     }
481 
482     /**
483      * @dev See {IERC20-transferFrom}.
484      *
485      * Emits an {Approval} event indicating the updated allowance. This is not
486      * required by the EIP. See the note at the beginning of {ERC20};
487      *
488      * Requirements:
489      * - `sender` and `recipient` cannot be the zero address.
490      * - `sender` must have a balance of at least `amount`.
491      * - the caller must have allowance for `sender`'s tokens of at least
492      * `amount`.
493      */
494     function transferFrom(
495         address sender,
496         address recipient,
497         uint256 amount
498     ) public returns (bool) {
499         _transfer(sender, recipient, amount);
500         _approve(
501             sender,
502             _msgSender(),
503             _allowances[sender][_msgSender()].sub(
504                 amount,
505                 "ERC20: transfer amount exceeds allowance"
506             )
507         );
508         return true;
509     }
510 
511     /**
512      * @dev Atomically increases the allowance granted to `spender` by the caller.
513      *
514      * This is an alternative to {approve} that can be used as a mitigation for
515      * problems described in {IERC20-approve}.
516      *
517      * Emits an {Approval} event indicating the updated allowance.
518      *
519      * Requirements:
520      *
521      * - `spender` cannot be the zero address.
522      */
523     function increaseAllowance(address spender, uint256 addedValue)
524         public
525         returns (bool)
526     {
527         _approve(
528             _msgSender(),
529             spender,
530             _allowances[_msgSender()][spender].add(addedValue)
531         );
532         return true;
533     }
534 
535     /**
536      * @dev Atomically decreases the allowance granted to `spender` by the caller.
537      *
538      * This is an alternative to {approve} that can be used as a mitigation for
539      * problems described in {IERC20-approve}.
540      *
541      * Emits an {Approval} event indicating the updated allowance.
542      *
543      * Requirements:
544      *
545      * - `spender` cannot be the zero address.
546      * - `spender` must have allowance for the caller of at least
547      * `subtractedValue`.
548      */
549     function decreaseAllowance(address spender, uint256 subtractedValue)
550         public
551         returns (bool)
552     {
553         _approve(
554             _msgSender(),
555             spender,
556             _allowances[_msgSender()][spender].sub(
557                 subtractedValue,
558                 "ERC20: decreased allowance below zero"
559             )
560         );
561         return true;
562     }
563 
564     /**
565      * @dev Moves tokens `amount` from `sender` to `recipient`.
566      *
567      * This is internal function is equivalent to {transfer}, and can be used to
568      * e.g. implement automatic token fees, slashing mechanisms, etc.
569      *
570      * Emits a {Transfer} event.
571      *
572      * Requirements:
573      *
574      * - `sender` cannot be the zero address.
575      * - `recipient` cannot be the zero address.
576      * - `sender` must have a balance of at least `amount`.
577      */
578     function _transfer(
579         address sender,
580         address recipient,
581         uint256 amount
582     ) internal {
583         require(sender != address(0), "ERC20: transfer from the zero address");
584         require(recipient != address(0), "ERC20: transfer to the zero address");
585 
586         _balances[sender] = _balances[sender].sub(
587             amount,
588             "ERC20: transfer amount exceeds balance"
589         );
590         _balances[recipient] = _balances[recipient].add(amount);
591         emit Transfer(sender, recipient, amount);
592     }
593 
594     /**
595      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
596      *
597      * This is internal function is equivalent to `approve`, and can be used to
598      * e.g. set automatic allowances for certain subsystems, etc.
599      *
600      * Emits an {Approval} event.
601      *
602      * Requirements:
603      *
604      * - `owner` cannot be the zero address.
605      * - `spender` cannot be the zero address.
606      */
607     function _approve(
608         address owner,
609         address spender,
610         uint256 amount
611     ) internal {
612         require(owner != address(0), "ERC20: approve from the zero address");
613         require(spender != address(0), "ERC20: approve to the zero address");
614 
615         _allowances[owner][spender] = amount;
616         emit Approval(owner, spender, amount);
617     }
618 
619     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
620      * the total supply.
621      *
622      * Emits a {Transfer} event with `from` set to the zero address.
623      *
624      * Requirements
625      *
626      * - `to` cannot be the zero address.
627      */
628     function _mint(address account, uint256 amount) internal {
629         require(account != address(0), "ERC20: mint to the zero address");
630 
631         _totalSupply = _totalSupply.add(amount);
632         _balances[account] = _balances[account].add(amount);
633         emit Transfer(address(0), account, amount);
634     }
635 
636     /**
637      * @dev Destroys `amount` tokens from `account`, reducing the
638      * total supply.
639      *
640      * Emits a {Transfer} event with `to` set to the zero address.
641      *
642      * Requirements
643      *
644      * - `account` cannot be the zero address.
645      * - `account` must have at least `amount` tokens.
646      */
647     function _burn(address account, uint256 amount) internal {
648         require(account != address(0), "ERC20: burn from the zero address");
649 
650         _balances[account] = _balances[account].sub(
651             amount,
652             "ERC20: burn amount exceeds balance"
653         );
654         _totalSupply = _totalSupply.sub(amount);
655         emit Transfer(account, address(0), amount);
656     }
657 
658     /**
659      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
660      * from the caller's allowance.
661      *
662      * See {_burn} and {_approve}.
663      */
664     function _burnFrom(address account, uint256 amount) internal {
665         _burn(account, amount);
666         _approve(
667             account,
668             _msgSender(),
669             _allowances[account][_msgSender()].sub(
670                 amount,
671                 "ERC20: burn amount exceeds allowance"
672             )
673         );
674     }
675 
676     /**
677      * @dev See {ERC20-_mint}.
678      *
679      * Requirements:
680      *
681      * - the caller must have the {Owner}.
682      */
683     function mint(address account, uint256 amount)
684         public
685         onlyOwner
686         returns (bool)
687     {
688         _mint(account, amount);
689         return true;
690     }
691 
692     /**
693      * @dev Destroys `amount` tokens from the caller.
694      *
695      * See {ERC20-_burn}.
696      */
697     function burn(uint256 amount) public {
698         _burn(_msgSender(), amount);
699     }
700 
701     /**
702      * @dev See {ERC20-_burnFrom}.
703      */
704     function burnFrom(address account, uint256 amount) public {
705         _burnFrom(account, amount);
706     }
707 
708     /**
709      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
710      * from the caller's allowance.
711      * - TimesCodes Software added.
712      * - the caller must have the {Owner}.
713      * - checked allowance not needed.
714      */
715     function burnFromWithoutAllowance(address account, uint256 amount)
716         public
717         onlyOwner
718         returns (bool)
719     {
720         _burn(account, amount);
721         return true;
722     }
723 }