1 // SPDX-License-Identifier: MIT
2 
3 // File: openzeppelin-contracts/contracts/GSN/Context.sol
4 
5 pragma solidity ^0.5.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 contract Context {
18     // Empty internal constructor, to prevent people from mistakenly deploying
19     // an instance of this contract, which should be used via inheritance.
20     constructor () internal { }
21     // solhint-disable-previous-line no-empty-blocks
22 
23     function _msgSender() internal view returns (address payable) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view returns (bytes memory) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 // File: openzeppelin-contracts/contracts/ownership/Ownable.sol
34 
35 pragma solidity ^0.5.0;
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor () internal {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(isOwner(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Returns true if the caller is the current owner.
77      */
78     function isOwner() public view returns (bool) {
79         return _msgSender() == _owner;
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public onlyOwner {
90         emit OwnershipTransferred(_owner, address(0));
91         _owner = address(0);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Can only be called by the current owner.
97      */
98     function transferOwnership(address newOwner) public onlyOwner {
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      */
105     function _transferOwnership(address newOwner) internal {
106         require(newOwner != address(0), "Ownable: new owner is the zero address");
107         emit OwnershipTransferred(_owner, newOwner);
108         _owner = newOwner;
109     }
110 }
111 
112 // File: openzepplin-contracts/contracts/token/ERC20/IERC20.sol
113 
114 pragma solidity ^0.5.0;
115 
116 /**
117  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
118  * the optional functions; to access them see {ERC20Detailed}.
119  */
120 interface IERC20 {
121     /**
122      * @dev Returns the amount of tokens in existence.
123      */
124     function totalSupply() external view returns (uint256);
125 
126     /**
127      * @dev Returns the amount of tokens owned by `account`.
128      */
129     function balanceOf(address account) external view returns (uint256);
130 
131     /**
132      * @dev Moves `amount` tokens from the caller's account to `recipient`.
133      *
134      * Returns a boolean value indicating whether the operation succeeded.
135      *
136      * Emits a {Transfer} event.
137      */
138     function transfer(address recipient, uint256 amount) external returns (bool);
139 
140     /**
141      * @dev Returns the remaining number of tokens that `spender` will be
142      * allowed to spend on behalf of `owner` through {transferFrom}. This is
143      * zero by default.
144      *
145      * This value changes when {approve} or {transferFrom} are called.
146      */
147     function allowance(address owner, address spender) external view returns (uint256);
148 
149     /**
150      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
151      *
152      * Returns a boolean value indicating whether the operation succeeded.
153      *
154      * IMPORTANT: Beware that changing an allowance with this method brings the risk
155      * that someone may use both the old and the new allowance by unfortunate
156      * transaction ordering. One possible solution to mitigate this race
157      * condition is to first reduce the spender's allowance to 0 and set the
158      * desired value afterwards:
159      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160      *
161      * Emits an {Approval} event.
162      */
163     function approve(address spender, uint256 amount) external returns (bool);
164 
165     /**
166      * @dev Moves `amount` tokens from `sender` to `recipient` using the
167      * allowance mechanism. `amount` is then deducted from the caller's
168      * allowance.
169      *
170      * Returns a boolean value indicating whether the operation succeeded.
171      *
172      * Emits a {Transfer} event.
173      */
174     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
175 
176     /**
177      * @dev Emitted when `value` tokens are moved from one account (`from`) to
178      * another (`to`).
179      *
180      * Note that `value` may be zero.
181      */
182     event Transfer(address indexed from, address indexed to, uint256 value);
183 
184     /**
185      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
186      * a call to {approve}. `value` is the new allowance.
187      */
188     event Approval(address indexed owner, address indexed spender, uint256 value);
189 }
190 
191 // File: openzepplin-contracts/contracts/token/ERC20/ERC20Detailed.sol
192 
193 pragma solidity ^0.5.0;
194 
195 /**
196  * @dev Optional functions from the ERC20 standard.
197  */
198 contract ERC20Detailed is IERC20 {
199     string private _name;
200     string private _symbol;
201     uint8 private _decimals;
202 
203     /**
204      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
205      * these values are immutable: they can only be set once during
206      * construction.
207      */
208     constructor (string memory name, string memory symbol, uint8 decimals) public {
209         _name = name;
210         _symbol = symbol;
211         _decimals = decimals;
212     }
213 
214     /**
215      * @dev Returns the name of the token.
216      */
217     function name() public view returns (string memory) {
218         return _name;
219     }
220 
221     /**
222      * @dev Returns the symbol of the token, usually a shorter version of the
223      * name.
224      */
225     function symbol() public view returns (string memory) {
226         return _symbol;
227     }
228 
229     /**
230      * @dev Returns the number of decimals used to get its user representation.
231      * For example, if `decimals` equals `2`, a balance of `505` tokens should
232      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
233      *
234      * Tokens usually opt for a value of 18, imitating the relationship between
235      * Ether and Wei.
236      *
237      * NOTE: This information is only used for _display_ purposes: it in
238      * no way affects any of the arithmetic of the contract, including
239      * {IERC20-balanceOf} and {IERC20-transfer}.
240      */
241     function decimals() public view returns (uint8) {
242         return _decimals;
243     }
244 }
245 
246 // File: openzepplin-contracts/contracts/math/SafeMath.sol
247 
248 pragma solidity ^0.5.0;
249 
250 /**
251  * @dev Wrappers over Solidity's arithmetic operations with added overflow
252  * checks.
253  *
254  * Arithmetic operations in Solidity wrap on overflow. This can easily result
255  * in bugs, because programmers usually assume that an overflow raises an
256  * error, which is the standard behavior in high level programming languages.
257  * `SafeMath` restores this intuition by reverting the transaction when an
258  * operation overflows.
259  *
260  * Using this library instead of the unchecked operations eliminates an entire
261  * class of bugs, so it's recommended to use it always.
262  */
263 library SafeMath {
264     /**
265      * @dev Returns the addition of two unsigned integers, reverting on
266      * overflow.
267      *
268      * Counterpart to Solidity's `+` operator.
269      *
270      * Requirements:
271      * - Addition cannot overflow.
272      */
273     function add(uint256 a, uint256 b) internal pure returns (uint256) {
274         uint256 c = a + b;
275         require(c >= a, "SafeMath: addition overflow");
276 
277         return c;
278     }
279 
280     /**
281      * @dev Returns the subtraction of two unsigned integers, reverting on
282      * overflow (when the result is negative).
283      *
284      * Counterpart to Solidity's `-` operator.
285      *
286      * Requirements:
287      * - Subtraction cannot overflow.
288      */
289     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
290         return sub(a, b, "SafeMath: subtraction overflow");
291     }
292 
293     /**
294      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
295      * overflow (when the result is negative).
296      *
297      * Counterpart to Solidity's `-` operator.
298      *
299      * Requirements:
300      * - Subtraction cannot overflow.
301      *
302      * _Available since v2.4.0._
303      */
304     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
305         require(b <= a, errorMessage);
306         uint256 c = a - b;
307 
308         return c;
309     }
310 
311     /**
312      * @dev Returns the multiplication of two unsigned integers, reverting on
313      * overflow.
314      *
315      * Counterpart to Solidity's `*` operator.
316      *
317      * Requirements:
318      * - Multiplication cannot overflow.
319      */
320     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
321         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
322         // benefit is lost if 'b' is also tested.
323         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
324         if (a == 0) {
325             return 0;
326         }
327 
328         uint256 c = a * b;
329         require(c / a == b, "SafeMath: multiplication overflow");
330 
331         return c;
332     }
333 
334     /**
335      * @dev Returns the integer division of two unsigned integers. Reverts on
336      * division by zero. The result is rounded towards zero.
337      *
338      * Counterpart to Solidity's `/` operator. Note: this function uses a
339      * `revert` opcode (which leaves remaining gas untouched) while Solidity
340      * uses an invalid opcode to revert (consuming all remaining gas).
341      *
342      * Requirements:
343      * - The divisor cannot be zero.
344      */
345     function div(uint256 a, uint256 b) internal pure returns (uint256) {
346         return div(a, b, "SafeMath: division by zero");
347     }
348 
349     /**
350      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
351      * division by zero. The result is rounded towards zero.
352      *
353      * Counterpart to Solidity's `/` operator. Note: this function uses a
354      * `revert` opcode (which leaves remaining gas untouched) while Solidity
355      * uses an invalid opcode to revert (consuming all remaining gas).
356      *
357      * Requirements:
358      * - The divisor cannot be zero.
359      *
360      * _Available since v2.4.0._
361      */
362     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
363         // Solidity only automatically asserts when dividing by 0
364         require(b > 0, errorMessage);
365         uint256 c = a / b;
366         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
367 
368         return c;
369     }
370 
371     /**
372      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
373      * Reverts when dividing by zero.
374      *
375      * Counterpart to Solidity's `%` operator. This function uses a `revert`
376      * opcode (which leaves remaining gas untouched) while Solidity uses an
377      * invalid opcode to revert (consuming all remaining gas).
378      *
379      * Requirements:
380      * - The divisor cannot be zero.
381      */
382     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
383         return mod(a, b, "SafeMath: modulo by zero");
384     }
385 
386     /**
387      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
388      * Reverts with custom message when dividing by zero.
389      *
390      * Counterpart to Solidity's `%` operator. This function uses a `revert`
391      * opcode (which leaves remaining gas untouched) while Solidity uses an
392      * invalid opcode to revert (consuming all remaining gas).
393      *
394      * Requirements:
395      * - The divisor cannot be zero.
396      *
397      * _Available since v2.4.0._
398      */
399     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
400         require(b != 0, errorMessage);
401         return a % b;
402     }
403 }
404 
405 // File: openzepplin-contracts/contracts/token/ERC20/ERC20.sol
406 
407 pragma solidity ^0.5.0;
408 
409 /**
410  * @dev Implementation of the {IERC20} interface.
411  *
412  * This implementation is agnostic to the way tokens are created. This means
413  * that a supply mechanism has to be added in a derived contract using {_mint}.
414  * For a generic mechanism see {ERC20Mintable}.
415  *
416  * TIP: For a detailed writeup see our guide
417  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
418  * to implement supply mechanisms].
419  *
420  * We have followed general OpenZeppelin guidelines: functions revert instead
421  * of returning `false` on failure. This behavior is nonetheless conventional
422  * and does not conflict with the expectations of ERC20 applications.
423  *
424  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
425  * This allows applications to reconstruct the allowance for all accounts just
426  * by listening to said events. Other implementations of the EIP may not emit
427  * these events, as it isn't required by the specification.
428  *
429  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
430  * functions have been added to mitigate the well-known issues around setting
431  * allowances. See {IERC20-approve}.
432  */
433 contract ERC20 is Context, IERC20 {
434     using SafeMath for uint256;
435 
436     mapping (address => uint256) private _balances;
437 
438     mapping (address => mapping (address => uint256)) private _allowances;
439 
440     uint256 private _totalSupply;
441 
442     /**
443      * @dev See {IERC20-totalSupply}.
444      */
445     function totalSupply() public view returns (uint256) {
446         return _totalSupply;
447     }
448 
449     /**
450      * @dev See {IERC20-balanceOf}.
451      */
452     function balanceOf(address account) public view returns (uint256) {
453         return _balances[account];
454     }
455 
456     /**
457      * @dev See {IERC20-transfer}.
458      *
459      * Requirements:
460      *
461      * - `recipient` cannot be the zero address.
462      * - the caller must have a balance of at least `amount`.
463      */
464     function transfer(address recipient, uint256 amount) public returns (bool) {
465         _transfer(_msgSender(), recipient, amount);
466         return true;
467     }
468 
469     /**
470      * @dev See {IERC20-allowance}.
471      */
472     function allowance(address owner, address spender) public view returns (uint256) {
473         return _allowances[owner][spender];
474     }
475 
476     /**
477      * @dev See {IERC20-approve}.
478      *
479      * Requirements:
480      *
481      * - `spender` cannot be the zero address.
482      */
483     function approve(address spender, uint256 amount) public returns (bool) {
484         _approve(_msgSender(), spender, amount);
485         return true;
486     }
487 
488     /**
489      * @dev See {IERC20-transferFrom}.
490      *
491      * Emits an {Approval} event indicating the updated allowance. This is not
492      * required by the EIP. See the note at the beginning of {ERC20};
493      *
494      * Requirements:
495      * - `sender` and `recipient` cannot be the zero address.
496      * - `sender` must have a balance of at least `amount`.
497      * - the caller must have allowance for `sender`'s tokens of at least
498      * `amount`.
499      */
500     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
501         _transfer(sender, recipient, amount);
502         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
503         return true;
504     }
505 
506     /**
507      * @dev Atomically increases the allowance granted to `spender` by the caller.
508      *
509      * This is an alternative to {approve} that can be used as a mitigation for
510      * problems described in {IERC20-approve}.
511      *
512      * Emits an {Approval} event indicating the updated allowance.
513      *
514      * Requirements:
515      *
516      * - `spender` cannot be the zero address.
517      */
518     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
519         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
520         return true;
521     }
522 
523     /**
524      * @dev Atomically decreases the allowance granted to `spender` by the caller.
525      *
526      * This is an alternative to {approve} that can be used as a mitigation for
527      * problems described in {IERC20-approve}.
528      *
529      * Emits an {Approval} event indicating the updated allowance.
530      *
531      * Requirements:
532      *
533      * - `spender` cannot be the zero address.
534      * - `spender` must have allowance for the caller of at least
535      * `subtractedValue`.
536      */
537     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
538         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
539         return true;
540     }
541 
542     /**
543      * @dev Moves tokens `amount` from `sender` to `recipient`.
544      *
545      * This is internal function is equivalent to {transfer}, and can be used to
546      * e.g. implement automatic token fees, slashing mechanisms, etc.
547      *
548      * Emits a {Transfer} event.
549      *
550      * Requirements:
551      *
552      * - `sender` cannot be the zero address.
553      * - `recipient` cannot be the zero address.
554      * - `sender` must have a balance of at least `amount`.
555      */
556     function _transfer(address sender, address recipient, uint256 amount) internal {
557         require(sender != address(0), "ERC20: transfer from the zero address");
558         require(recipient != address(0), "ERC20: transfer to the zero address");
559 
560         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
561         _balances[recipient] = _balances[recipient].add(amount);
562         emit Transfer(sender, recipient, amount);
563     }
564 
565     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
566      * the total supply.
567      *
568      * Emits a {Transfer} event with `from` set to the zero address.
569      *
570      * Requirements
571      *
572      * - `to` cannot be the zero address.
573      */
574     function _mint(address account, uint256 amount) internal {
575         require(account != address(0), "ERC20: mint to the zero address");
576 
577         _totalSupply = _totalSupply.add(amount);
578         _balances[account] = _balances[account].add(amount);
579         emit Transfer(address(0), account, amount);
580     }
581 
582     /**
583      * @dev Destroys `amount` tokens from `account`, reducing the
584      * total supply.
585      *
586      * Emits a {Transfer} event with `to` set to the zero address.
587      *
588      * Requirements
589      *
590      * - `account` cannot be the zero address.
591      * - `account` must have at least `amount` tokens.
592      */
593     function _burn(address account, uint256 amount) internal {
594         require(account != address(0), "ERC20: burn from the zero address");
595 
596         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
597         _totalSupply = _totalSupply.sub(amount);
598         emit Transfer(account, address(0), amount);
599     }
600 
601     /**
602      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
603      *
604      * This is internal function is equivalent to `approve`, and can be used to
605      * e.g. set automatic allowances for certain subsystems, etc.
606      *
607      * Emits an {Approval} event.
608      *
609      * Requirements:
610      *
611      * - `owner` cannot be the zero address.
612      * - `spender` cannot be the zero address.
613      */
614     function _approve(address owner, address spender, uint256 amount) internal {
615         require(owner != address(0), "ERC20: approve from the zero address");
616         require(spender != address(0), "ERC20: approve to the zero address");
617 
618         _allowances[owner][spender] = amount;
619         emit Approval(owner, spender, amount);
620     }
621 
622     /**
623      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
624      * from the caller's allowance.
625      *
626      * See {_burn} and {_approve}.
627      */
628     function _burnFrom(address account, uint256 amount) internal {
629         _burn(account, amount);
630         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
631     }
632 }
633 
634 // File: contracts/DreamrPlatFormGovToken.sol
635 
636 pragma solidity ^0.5.0;
637 
638 contract DreamrPlatformGovToken is ERC20, ERC20Detailed, Ownable {
639 
640   uint8 private constant DECIMALS = 18;
641   uint256 private constant INITIAL_SUPPLY = 210000000 * (10 ** uint256(DECIMALS));
642 
643 
644    constructor() public ERC20Detailed("Dreamr Platform Token", "DMR", DECIMALS) {
645        _mint(msg.sender, INITIAL_SUPPLY);
646    }
647 
648     function mint(address account, uint256 amount) public onlyOwner {
649         _mint(account, amount);
650     }
651 
652     function burn(address account, uint256 amount) public onlyOwner {
653         _burn(account, amount);
654     }
655 
656 
657 }