1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
5  * the optional functions; to access them see {ERC20Detailed}.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 
79 
80 
81 
82 
83 
84 /**
85  * @dev Optional functions from the ERC20 standard.
86  */
87 contract ERC20Detailed is IERC20 {
88     string private _name;
89     string private _symbol;
90     uint8 private _decimals;
91 
92     /**
93      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
94      * these values are immutable: they can only be set once during
95      * construction.
96      */
97     constructor (string memory name, string memory symbol, uint8 decimals) public {
98         _name = name;
99         _symbol = symbol;
100         _decimals = decimals;
101     }
102 
103     /**
104      * @dev Returns the name of the token.
105      */
106     function name() public view returns (string memory) {
107         return _name;
108     }
109 
110     /**
111      * @dev Returns the symbol of the token, usually a shorter version of the
112      * name.
113      */
114     function symbol() public view returns (string memory) {
115         return _symbol;
116     }
117 
118     /**
119      * @dev Returns the number of decimals used to get its user representation.
120      * For example, if `decimals` equals `2`, a balance of `505` tokens should
121      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
122      *
123      * Tokens usually opt for a value of 18, imitating the relationship between
124      * Ether and Wei.
125      *
126      * NOTE: This information is only used for _display_ purposes: it in
127      * no way affects any of the arithmetic of the contract, including
128      * {IERC20-balanceOf} and {IERC20-transfer}.
129      */
130     function decimals() public view returns (uint8) {
131         return _decimals;
132     }
133 }
134 
135 
136 
137 
138 
139 /*
140  * @dev Provides information about the current execution context, including the
141  * sender of the transaction and its data. While these are generally available
142  * via msg.sender and msg.data, they should not be accessed in such a direct
143  * manner, since when dealing with GSN meta-transactions the account sending and
144  * paying for execution may not be the actual sender (as far as an application
145  * is concerned).
146  *
147  * This contract is only required for intermediate, library-like contracts.
148  */
149 contract Context {
150     // Empty internal constructor, to prevent people from mistakenly deploying
151     // an instance of this contract, which should be used via inheritance.
152     constructor () internal { }
153     // solhint-disable-previous-line no-empty-blocks
154 
155     function _msgSender() internal view returns (address payable) {
156         return msg.sender;
157     }
158 
159     function _msgData() internal view returns (bytes memory) {
160         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
161         return msg.data;
162     }
163 }
164 
165 
166 
167 
168 /**
169  * @dev Wrappers over Solidity's arithmetic operations with added overflow
170  * checks.
171  *
172  * Arithmetic operations in Solidity wrap on overflow. This can easily result
173  * in bugs, because programmers usually assume that an overflow raises an
174  * error, which is the standard behavior in high level programming languages.
175  * `SafeMath` restores this intuition by reverting the transaction when an
176  * operation overflows.
177  *
178  * Using this library instead of the unchecked operations eliminates an entire
179  * class of bugs, so it's recommended to use it always.
180  */
181 library SafeMath {
182     /**
183      * @dev Returns the addition of two unsigned integers, reverting on
184      * overflow.
185      *
186      * Counterpart to Solidity's `+` operator.
187      *
188      * Requirements:
189      * - Addition cannot overflow.
190      */
191     function add(uint256 a, uint256 b) internal pure returns (uint256) {
192         uint256 c = a + b;
193         require(c >= a, "SafeMath: addition overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the subtraction of two unsigned integers, reverting on
200      * overflow (when the result is negative).
201      *
202      * Counterpart to Solidity's `-` operator.
203      *
204      * Requirements:
205      * - Subtraction cannot overflow.
206      */
207     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
208         return sub(a, b, "SafeMath: subtraction overflow");
209     }
210 
211     /**
212      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
213      * overflow (when the result is negative).
214      *
215      * Counterpart to Solidity's `-` operator.
216      *
217      * Requirements:
218      * - Subtraction cannot overflow.
219      *
220      * _Available since v2.4.0._
221      */
222     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223         require(b <= a, errorMessage);
224         uint256 c = a - b;
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the multiplication of two unsigned integers, reverting on
231      * overflow.
232      *
233      * Counterpart to Solidity's `*` operator.
234      *
235      * Requirements:
236      * - Multiplication cannot overflow.
237      */
238     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
239         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
240         // benefit is lost if 'b' is also tested.
241         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
242         if (a == 0) {
243             return 0;
244         }
245 
246         uint256 c = a * b;
247         require(c / a == b, "SafeMath: multiplication overflow");
248 
249         return c;
250     }
251 
252     /**
253      * @dev Returns the integer division of two unsigned integers. Reverts on
254      * division by zero. The result is rounded towards zero.
255      *
256      * Counterpart to Solidity's `/` operator. Note: this function uses a
257      * `revert` opcode (which leaves remaining gas untouched) while Solidity
258      * uses an invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      * - The divisor cannot be zero.
262      */
263     function div(uint256 a, uint256 b) internal pure returns (uint256) {
264         return div(a, b, "SafeMath: division by zero");
265     }
266 
267     /**
268      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
269      * division by zero. The result is rounded towards zero.
270      *
271      * Counterpart to Solidity's `/` operator. Note: this function uses a
272      * `revert` opcode (which leaves remaining gas untouched) while Solidity
273      * uses an invalid opcode to revert (consuming all remaining gas).
274      *
275      * Requirements:
276      * - The divisor cannot be zero.
277      *
278      * _Available since v2.4.0._
279      */
280     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
281         // Solidity only automatically asserts when dividing by 0
282         require(b > 0, errorMessage);
283         uint256 c = a / b;
284         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
285 
286         return c;
287     }
288 
289     /**
290      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
291      * Reverts when dividing by zero.
292      *
293      * Counterpart to Solidity's `%` operator. This function uses a `revert`
294      * opcode (which leaves remaining gas untouched) while Solidity uses an
295      * invalid opcode to revert (consuming all remaining gas).
296      *
297      * Requirements:
298      * - The divisor cannot be zero.
299      */
300     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
301         return mod(a, b, "SafeMath: modulo by zero");
302     }
303 
304     /**
305      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
306      * Reverts with custom message when dividing by zero.
307      *
308      * Counterpart to Solidity's `%` operator. This function uses a `revert`
309      * opcode (which leaves remaining gas untouched) while Solidity uses an
310      * invalid opcode to revert (consuming all remaining gas).
311      *
312      * Requirements:
313      * - The divisor cannot be zero.
314      *
315      * _Available since v2.4.0._
316      */
317     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
318         require(b != 0, errorMessage);
319         return a % b;
320     }
321 }
322 
323 
324 /**
325  * @dev Implementation of the {IERC20} interface.
326  *
327  * This implementation is agnostic to the way tokens are created. This means
328  * that a supply mechanism has to be added in a derived contract using {_mint}.
329  * For a generic mechanism see {ERC20Mintable}.
330  *
331  * TIP: For a detailed writeup see our guide
332  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
333  * to implement supply mechanisms].
334  *
335  * We have followed general OpenZeppelin guidelines: functions revert instead
336  * of returning `false` on failure. This behavior is nonetheless conventional
337  * and does not conflict with the expectations of ERC20 applications.
338  *
339  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
340  * This allows applications to reconstruct the allowance for all accounts just
341  * by listening to said events. Other implementations of the EIP may not emit
342  * these events, as it isn't required by the specification.
343  *
344  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
345  * functions have been added to mitigate the well-known issues around setting
346  * allowances. See {IERC20-approve}.
347  */
348 contract ERC20 is Context, IERC20 {
349     using SafeMath for uint256;
350 
351     mapping (address => uint256) private _balances;
352 
353     mapping (address => mapping (address => uint256)) private _allowances;
354 
355     uint256 private _totalSupply;
356 
357     /**
358      * @dev See {IERC20-totalSupply}.
359      */
360     function totalSupply() public view returns (uint256) {
361         return _totalSupply;
362     }
363 
364     /**
365      * @dev See {IERC20-balanceOf}.
366      */
367     function balanceOf(address account) public view returns (uint256) {
368         return _balances[account];
369     }
370 
371     /**
372      * @dev See {IERC20-transfer}.
373      *
374      * Requirements:
375      *
376      * - `recipient` cannot be the zero address.
377      * - the caller must have a balance of at least `amount`.
378      */
379     function transfer(address recipient, uint256 amount) public returns (bool) {
380         _transfer(_msgSender(), recipient, amount);
381         return true;
382     }
383 
384     /**
385      * @dev See {IERC20-allowance}.
386      */
387     function allowance(address owner, address spender) public view returns (uint256) {
388         return _allowances[owner][spender];
389     }
390 
391     /**
392      * @dev See {IERC20-approve}.
393      *
394      * Requirements:
395      *
396      * - `spender` cannot be the zero address.
397      */
398     function approve(address spender, uint256 amount) public returns (bool) {
399         _approve(_msgSender(), spender, amount);
400         return true;
401     }
402 
403     /**
404      * @dev See {IERC20-transferFrom}.
405      *
406      * Emits an {Approval} event indicating the updated allowance. This is not
407      * required by the EIP. See the note at the beginning of {ERC20};
408      *
409      * Requirements:
410      * - `sender` and `recipient` cannot be the zero address.
411      * - `sender` must have a balance of at least `amount`.
412      * - the caller must have allowance for `sender`'s tokens of at least
413      * `amount`.
414      */
415     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
416         _transfer(sender, recipient, amount);
417         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
418         return true;
419     }
420 
421     /**
422      * @dev Atomically increases the allowance granted to `spender` by the caller.
423      *
424      * This is an alternative to {approve} that can be used as a mitigation for
425      * problems described in {IERC20-approve}.
426      *
427      * Emits an {Approval} event indicating the updated allowance.
428      *
429      * Requirements:
430      *
431      * - `spender` cannot be the zero address.
432      */
433     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
434         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
435         return true;
436     }
437 
438     /**
439      * @dev Atomically decreases the allowance granted to `spender` by the caller.
440      *
441      * This is an alternative to {approve} that can be used as a mitigation for
442      * problems described in {IERC20-approve}.
443      *
444      * Emits an {Approval} event indicating the updated allowance.
445      *
446      * Requirements:
447      *
448      * - `spender` cannot be the zero address.
449      * - `spender` must have allowance for the caller of at least
450      * `subtractedValue`.
451      */
452     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
453         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
454         return true;
455     }
456 
457     /**
458      * @dev Moves tokens `amount` from `sender` to `recipient`.
459      *
460      * This is internal function is equivalent to {transfer}, and can be used to
461      * e.g. implement automatic token fees, slashing mechanisms, etc.
462      *
463      * Emits a {Transfer} event.
464      *
465      * Requirements:
466      *
467      * - `sender` cannot be the zero address.
468      * - `recipient` cannot be the zero address.
469      * - `sender` must have a balance of at least `amount`.
470      */
471     function _transfer(address sender, address recipient, uint256 amount) internal {
472         require(sender != address(0), "ERC20: transfer from the zero address");
473         require(recipient != address(0), "ERC20: transfer to the zero address");
474 
475         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
476         _balances[recipient] = _balances[recipient].add(amount);
477         emit Transfer(sender, recipient, amount);
478     }
479 
480     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
481      * the total supply.
482      *
483      * Emits a {Transfer} event with `from` set to the zero address.
484      *
485      * Requirements
486      *
487      * - `to` cannot be the zero address.
488      */
489     function _mint(address account, uint256 amount) internal {
490         require(account != address(0), "ERC20: mint to the zero address");
491 
492         _totalSupply = _totalSupply.add(amount);
493         _balances[account] = _balances[account].add(amount);
494         emit Transfer(address(0), account, amount);
495     }
496 
497     /**
498      * @dev Destroys `amount` tokens from `account`, reducing the
499      * total supply.
500      *
501      * Emits a {Transfer} event with `to` set to the zero address.
502      *
503      * Requirements
504      *
505      * - `account` cannot be the zero address.
506      * - `account` must have at least `amount` tokens.
507      */
508     function _burn(address account, uint256 amount) internal {
509         require(account != address(0), "ERC20: burn from the zero address");
510 
511         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
512         _totalSupply = _totalSupply.sub(amount);
513         emit Transfer(account, address(0), amount);
514     }
515 
516     /**
517      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
518      *
519      * This is internal function is equivalent to `approve`, and can be used to
520      * e.g. set automatic allowances for certain subsystems, etc.
521      *
522      * Emits an {Approval} event.
523      *
524      * Requirements:
525      *
526      * - `owner` cannot be the zero address.
527      * - `spender` cannot be the zero address.
528      */
529     function _approve(address owner, address spender, uint256 amount) internal {
530         require(owner != address(0), "ERC20: approve from the zero address");
531         require(spender != address(0), "ERC20: approve to the zero address");
532 
533         _allowances[owner][spender] = amount;
534         emit Approval(owner, spender, amount);
535     }
536 
537     /**
538      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
539      * from the caller's allowance.
540      *
541      * See {_burn} and {_approve}.
542      */
543     function _burnFrom(address account, uint256 amount) internal {
544         _burn(account, amount);
545         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
546     }
547 }
548 
549 
550 
551 
552 /**
553  * @dev Contract module which provides a basic access control mechanism, where
554  * there is an account (an owner) that can be granted exclusive access to
555  * specific functions.
556  *
557  * This module is used through inheritance. It will make available the modifier
558  * `onlyOwner`, which can be applied to your functions to restrict their use to
559  * the owner.
560  */
561 contract Ownable is Context {
562     address private _owner;
563 
564     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
565 
566     /**
567      * @dev Initializes the contract setting the deployer as the initial owner.
568      */
569     constructor () internal {
570         address msgSender = _msgSender();
571         _owner = msgSender;
572         emit OwnershipTransferred(address(0), msgSender);
573     }
574 
575     /**
576      * @dev Returns the address of the current owner.
577      */
578     function owner() public view returns (address) {
579         return _owner;
580     }
581 
582     /**
583      * @dev Throws if called by any account other than the owner.
584      */
585     modifier onlyOwner() {
586         require(isOwner(), "Ownable: caller is not the owner");
587         _;
588     }
589 
590     /**
591      * @dev Returns true if the caller is the current owner.
592      */
593     function isOwner() public view returns (bool) {
594         return _msgSender() == _owner;
595     }
596 
597     /**
598      * @dev Leaves the contract without owner. It will not be possible to call
599      * `onlyOwner` functions anymore. Can only be called by the current owner.
600      *
601      * NOTE: Renouncing ownership will leave the contract without an owner,
602      * thereby removing any functionality that is only available to the owner.
603      */
604     function renounceOwnership() public onlyOwner {
605         emit OwnershipTransferred(_owner, address(0));
606         _owner = address(0);
607     }
608 
609     /**
610      * @dev Transfers ownership of the contract to a new account (`newOwner`).
611      * Can only be called by the current owner.
612      */
613     function transferOwnership(address newOwner) public onlyOwner {
614         _transferOwnership(newOwner);
615     }
616 
617     /**
618      * @dev Transfers ownership of the contract to a new account (`newOwner`).
619      */
620     function _transferOwnership(address newOwner) internal {
621         require(newOwner != address(0), "Ownable: new owner is the zero address");
622         emit OwnershipTransferred(_owner, newOwner);
623         _owner = newOwner;
624     }
625 }
626 
627 
628 contract KiiAToken is ERC20, ERC20Detailed, Ownable {
629 
630     //Token percentages
631     uint256 private tokenSaleRatio        = 50;
632     uint256 private foundersRatio         = 10;
633     uint256 private marketingRatio        = 40;
634     uint256 private foundersplit          = 20; 
635 
636     //Constructor
637     constructor(
638         string  memory _name, 
639         string  memory _symbol, 
640         uint8   _decimals,
641         address _founder1,
642         address _founder2,
643         address _founder3,
644         address _founder4,
645         address _founder5,
646         address _marketing,
647         address _publicsale,
648         uint256 _initialSupply
649         )
650         ERC20Detailed(_name, _symbol, _decimals)
651         public
652     {
653         uint256 tempInitialSupply = _initialSupply * (10 ** uint256(_decimals));
654 
655         uint256 publicSupply = tempInitialSupply.mul(tokenSaleRatio).div(100);
656         uint256 marketingSupply = tempInitialSupply.mul(marketingRatio).div(100);
657         uint256 tempfounderSupply   = tempInitialSupply.mul(foundersRatio).div(100);
658         uint256 founderSupply   = tempfounderSupply.mul(foundersplit).div(100);
659 
660         _mint(_publicsale, publicSupply);
661         _mint(_marketing, marketingSupply);
662         _mint(_founder1, founderSupply);
663         _mint(_founder2, founderSupply);
664         _mint(_founder3, founderSupply);
665         _mint(_founder4, founderSupply);
666         _mint(_founder5, founderSupply);
667 
668     }
669 
670 }