1 pragma solidity ^0.5.0;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 contract Context {
14     // Empty internal constructor, to prevent people from mistakenly deploying
15     // an instance of this contract, which should be used via inheritance.
16     constructor () internal { }
17     // solhint-disable-previous-line no-empty-blocks
18 
19     function _msgSender() internal view returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 /**
30  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
31  * the optional functions; to access them see {ERC20Detailed}.
32  */
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `+` operator.
123      *
124      * Requirements:
125      * - Addition cannot overflow.
126      */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a, "SafeMath: addition overflow");
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the subtraction of two unsigned integers, reverting on
136      * overflow (when the result is negative).
137      *
138      * Counterpart to Solidity's `-` operator.
139      *
140      * Requirements:
141      * - Subtraction cannot overflow.
142      */
143     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144         return sub(a, b, "SafeMath: subtraction overflow");
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
149      * overflow (when the result is negative).
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      * - Subtraction cannot overflow.
155      *
156      * _Available since v2.4.0._
157      */
158     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b <= a, errorMessage);
160         uint256 c = a - b;
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the multiplication of two unsigned integers, reverting on
167      * overflow.
168      *
169      * Counterpart to Solidity's `*` operator.
170      *
171      * Requirements:
172      * - Multiplication cannot overflow.
173      */
174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
176         // benefit is lost if 'b' is also tested.
177         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
178         if (a == 0) {
179             return 0;
180         }
181 
182         uint256 c = a * b;
183         require(c / a == b, "SafeMath: multiplication overflow");
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b) internal pure returns (uint256) {
200         return div(a, b, "SafeMath: division by zero");
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      * - The divisor cannot be zero.
213      *
214      * _Available since v2.4.0._
215      */
216     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
217         // Solidity only automatically asserts when dividing by 0
218         require(b > 0, errorMessage);
219         uint256 c = a / b;
220         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
237         return mod(a, b, "SafeMath: modulo by zero");
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts with custom message when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      * - The divisor cannot be zero.
250      *
251      * _Available since v2.4.0._
252      */
253     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b != 0, errorMessage);
255         return a % b;
256     }
257 }
258 
259 
260 /**
261  * @dev Implementation of the {IERC20} interface.
262  *
263  * This implementation is agnostic to the way tokens are created. This means
264  * that a supply mechanism has to be added in a derived contract using {_mint}.
265  * For a generic mechanism see {ERC20Mintable}.
266  *
267  * TIP: For a detailed writeup see our guide
268  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
269  * to implement supply mechanisms].
270  *
271  * We have followed general OpenZeppelin guidelines: functions revert instead
272  * of returning `false` on failure. This behavior is nonetheless conventional
273  * and does not conflict with the expectations of ERC20 applications.
274  *
275  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
276  * This allows applications to reconstruct the allowance for all accounts just
277  * by listening to said events. Other implementations of the EIP may not emit
278  * these events, as it isn't required by the specification.
279  *
280  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
281  * functions have been added to mitigate the well-known issues around setting
282  * allowances. See {IERC20-approve}.
283  */
284 contract ERC20 is Context, IERC20 {
285     using SafeMath for uint256;
286 
287     mapping (address => uint256) private _balances;
288 
289     mapping (address => mapping (address => uint256)) private _allowances;
290 
291     uint256 private _totalSupply;
292 
293     /**
294      * @dev See {IERC20-totalSupply}.
295      */
296     function totalSupply() public view returns (uint256) {
297         return _totalSupply;
298     }
299 
300     /**
301      * @dev See {IERC20-balanceOf}.
302      */
303     function balanceOf(address account) public view returns (uint256) {
304         return _balances[account];
305     }
306 
307     /**
308      * @dev See {IERC20-transfer}.
309      *
310      * Requirements:
311      *
312      * - `recipient` cannot be the zero address.
313      * - the caller must have a balance of at least `amount`.
314      */
315     function transfer(address recipient, uint256 amount) public returns (bool) {
316         _transfer(_msgSender(), recipient, amount);
317         return true;
318     }
319 
320     /**
321      * @dev See {IERC20-allowance}.
322      */
323     function allowance(address owner, address spender) public view returns (uint256) {
324         return _allowances[owner][spender];
325     }
326 
327     /**
328      * @dev See {IERC20-approve}.
329      *
330      * Requirements:
331      *
332      * - `spender` cannot be the zero address.
333      */
334     function approve(address spender, uint256 amount) public returns (bool) {
335         _approve(_msgSender(), spender, amount);
336         return true;
337     }
338 
339     /**
340      * @dev See {IERC20-transferFrom}.
341      *
342      * Emits an {Approval} event indicating the updated allowance. This is not
343      * required by the EIP. See the note at the beginning of {ERC20};
344      *
345      * Requirements:
346      * - `sender` and `recipient` cannot be the zero address.
347      * - `sender` must have a balance of at least `amount`.
348      * - the caller must have allowance for `sender`'s tokens of at least
349      * `amount`.
350      */
351     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
352         _transfer(sender, recipient, amount);
353         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
354         return true;
355     }
356 
357     /**
358      * @dev Atomically increases the allowance granted to `spender` by the caller.
359      *
360      * This is an alternative to {approve} that can be used as a mitigation for
361      * problems described in {IERC20-approve}.
362      *
363      * Emits an {Approval} event indicating the updated allowance.
364      *
365      * Requirements:
366      *
367      * - `spender` cannot be the zero address.
368      */
369     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
370         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
371         return true;
372     }
373 
374     /**
375      * @dev Atomically decreases the allowance granted to `spender` by the caller.
376      *
377      * This is an alternative to {approve} that can be used as a mitigation for
378      * problems described in {IERC20-approve}.
379      *
380      * Emits an {Approval} event indicating the updated allowance.
381      *
382      * Requirements:
383      *
384      * - `spender` cannot be the zero address.
385      * - `spender` must have allowance for the caller of at least
386      * `subtractedValue`.
387      */
388     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
389         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
390         return true;
391     }
392 
393     /**
394      * @dev Moves tokens `amount` from `sender` to `recipient`.
395      *
396      * This is internal function is equivalent to {transfer}, and can be used to
397      * e.g. implement automatic token fees, slashing mechanisms, etc.
398      *
399      * Emits a {Transfer} event.
400      *
401      * Requirements:
402      *
403      * - `sender` cannot be the zero address.
404      * - `recipient` cannot be the zero address.
405      * - `sender` must have a balance of at least `amount`.
406      */
407     function _transfer(address sender, address recipient, uint256 amount) internal {
408         require(sender != address(0), "ERC20: transfer from the zero address");
409         require(recipient != address(0), "ERC20: transfer to the zero address");
410 
411         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
412         _balances[recipient] = _balances[recipient].add(amount);
413         emit Transfer(sender, recipient, amount);
414     }
415 
416     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
417      * the total supply.
418      *
419      * Emits a {Transfer} event with `from` set to the zero address.
420      *
421      * Requirements
422      *
423      * - `to` cannot be the zero address.
424      */
425     function _mint(address account, uint256 amount) internal {
426         require(account != address(0), "ERC20: mint to the zero address");
427 
428         _totalSupply = _totalSupply.add(amount);
429         _balances[account] = _balances[account].add(amount);
430         emit Transfer(address(0), account, amount);
431     }
432 
433     /**
434      * @dev Destroys `amount` tokens from `account`, reducing the
435      * total supply.
436      *
437      * Emits a {Transfer} event with `to` set to the zero address.
438      *
439      * Requirements
440      *
441      * - `account` cannot be the zero address.
442      * - `account` must have at least `amount` tokens.
443      */
444     function _burn(address account, uint256 amount) internal {
445         require(account != address(0), "ERC20: burn from the zero address");
446 
447         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
448         _totalSupply = _totalSupply.sub(amount);
449         emit Transfer(account, address(0), amount);
450     }
451 
452     /**
453      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
454      *
455      * This is internal function is equivalent to `approve`, and can be used to
456      * e.g. set automatic allowances for certain subsystems, etc.
457      *
458      * Emits an {Approval} event.
459      *
460      * Requirements:
461      *
462      * - `owner` cannot be the zero address.
463      * - `spender` cannot be the zero address.
464      */
465     function _approve(address owner, address spender, uint256 amount) internal {
466         require(owner != address(0), "ERC20: approve from the zero address");
467         require(spender != address(0), "ERC20: approve to the zero address");
468 
469         _allowances[owner][spender] = amount;
470         emit Approval(owner, spender, amount);
471     }
472 
473     /**
474      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
475      * from the caller's allowance.
476      *
477      * See {_burn} and {_approve}.
478      */
479     function _burnFrom(address account, uint256 amount) internal {
480         _burn(account, amount);
481         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
482     }
483 }
484 
485 /**
486  * @dev Optional functions from the ERC20 standard.
487  */
488 contract ERC20Detailed is IERC20 {
489     string private _name;
490     string private _symbol;
491     uint8 private _decimals;
492 
493     /**
494      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
495      * these values are immutable: they can only be set once during
496      * construction.
497      */
498     constructor (string memory name, string memory symbol, uint8 decimals) public {
499         _name = name;
500         _symbol = symbol;
501         _decimals = decimals;
502     }
503 
504     /**
505      * @dev Returns the name of the token.
506      */
507     function name() public view returns (string memory) {
508         return _name;
509     }
510 
511     /**
512      * @dev Returns the symbol of the token, usually a shorter version of the
513      * name.
514      */
515     function symbol() public view returns (string memory) {
516         return _symbol;
517     }
518 
519     /**
520      * @dev Returns the number of decimals used to get its user representation.
521      * For example, if `decimals` equals `2`, a balance of `505` tokens should
522      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
523      *
524      * Tokens usually opt for a value of 18, imitating the relationship between
525      * Ether and Wei.
526      *
527      * NOTE: This information is only used for _display_ purposes: it in
528      * no way affects any of the arithmetic of the contract, including
529      * {IERC20-balanceOf} and {IERC20-transfer}.
530      */
531     function decimals() public view returns (uint8) {
532         return _decimals;
533     }
534 }
535 
536 /**
537  * @dev Contract module which provides a basic access control mechanism, where
538  * there is an account (an owner) that can be granted exclusive access to
539  * specific functions.
540  *
541  * This module is used through inheritance. It will make available the modifier
542  * `onlyOwner`, which can be applied to your functions to restrict their use to
543  * the owner.
544  */
545 contract Ownable is Context {
546     address private _owner;
547 
548     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
549 
550     /**
551      * @dev Initializes the contract setting the deployer as the initial owner.
552      */
553     constructor () internal {
554         address msgSender = _msgSender();
555         _owner = msgSender;
556         emit OwnershipTransferred(address(0), msgSender);
557     }
558 
559     /**
560      * @dev Returns the address of the current owner.
561      */
562     function owner() public view returns (address) {
563         return _owner;
564     }
565 
566     /**
567      * @dev Throws if called by any account other than the owner.
568      */
569     modifier onlyOwner() {
570         require(isOwner(), "Ownable: caller is not the owner");
571         _;
572     }
573 
574     /**
575      * @dev Returns true if the caller is the current owner.
576      */
577     function isOwner() public view returns (bool) {
578         return _msgSender() == _owner;
579     }
580 
581     /**
582      * @dev Leaves the contract without owner. It will not be possible to call
583      * `onlyOwner` functions anymore. Can only be called by the current owner.
584      *
585      * NOTE: Renouncing ownership will leave the contract without an owner,
586      * thereby removing any functionality that is only available to the owner.
587      */
588     function renounceOwnership() public onlyOwner {
589         emit OwnershipTransferred(_owner, address(0));
590         _owner = address(0);
591     }
592 
593     /**
594      * @dev Transfers ownership of the contract to a new account (`newOwner`).
595      * Can only be called by the current owner.
596      */
597     function transferOwnership(address newOwner) public onlyOwner {
598         _transferOwnership(newOwner);
599     }
600 
601     /**
602      * @dev Transfers ownership of the contract to a new account (`newOwner`).
603      */
604     function _transferOwnership(address newOwner) internal {
605         require(newOwner != address(0), "Ownable: new owner is the zero address");
606         emit OwnershipTransferred(_owner, newOwner);
607         _owner = newOwner;
608     }
609 }
610 
611 contract DIAToken is ERC20, ERC20Detailed, Ownable {
612     constructor () public ERC20Detailed("DIAToken", "DIA", 18) {
613         _mint(_msgSender(), 200000000 * (10 ** uint256(decimals())));
614     }
615     
616     mapping(uint256 => uint256) public auditHashes;
617     
618     function addAuditHash(uint256 hashKey, uint256 newAuditHash) public onlyOwner {
619        auditHashes[hashKey] = newAuditHash;
620     }
621     
622 }