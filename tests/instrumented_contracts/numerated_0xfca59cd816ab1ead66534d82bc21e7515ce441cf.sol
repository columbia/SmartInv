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
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * This module is used through inheritance. It will make available the modifier
35  * `onlyOwner`, which can be applied to your functions to restrict their use to
36  * the owner.
37  */
38 contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor () internal {
47         address msgSender = _msgSender();
48         _owner = msgSender;
49         emit OwnershipTransferred(address(0), msgSender);
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(isOwner(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     /**
68      * @dev Returns true if the caller is the current owner.
69      */
70     function isOwner() public view returns (bool) {
71         return _msgSender() == _owner;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public onlyOwner {
91         _transferOwnership(newOwner);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      */
97     function _transferOwnership(address newOwner) internal {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         emit OwnershipTransferred(_owner, newOwner);
100         _owner = newOwner;
101     }
102 }
103 
104 contract Pausable is Ownable {
105     /**
106      * @dev Emitted when the pause is triggered by owner (`account`).
107      */
108     event Paused(address account);
109 
110     /**
111      * @dev Emitted when the pause is lifted by owner (`account`).
112      */
113     event Unpaused(address account);
114 
115     bool private _paused;
116 
117     /**
118      * @dev Initializes the contract in unpaused state
119      */
120     constructor () internal {
121         _paused = false;
122     }
123 
124     /**
125      * @dev Returns true if the contract is paused, and false otherwise.
126      */
127     function paused() public view returns (bool) {
128         return _paused;
129     }
130 
131     /**
132      * @dev Modifier to make a function callable only when the contract is not paused.
133      */
134     modifier whenNotPaused() {
135         require(!_paused, "Pausable: paused");
136         _;
137     }
138 
139     /**
140      * @dev Modifier to make a function callable only when the contract is paused.
141      */
142     modifier whenPaused() {
143         require(_paused, "Pausable: not paused");
144         _;
145     }
146 
147     /**
148      * @dev Called by a pauser to pause, triggers stopped state.
149      */
150     function pause() public onlyOwner whenNotPaused {
151         _paused = true;
152         emit Paused(_msgSender());
153     }
154 
155     /**
156      * @dev Called by a pauser to unpause, returns to normal state.
157      */
158     function unpause() public onlyOwner whenPaused {
159         _paused = false;
160         emit Unpaused(_msgSender());
161     }
162 }
163 
164 /**
165  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
166  * the optional functions; to access them see {ERC20Detailed}.
167  */
168 interface IERC20 {
169     /**
170      * @dev Returns the amount of tokens in existence.
171      */
172     function totalSupply() external view returns (uint256);
173 
174     /**
175      * @dev Returns the amount of tokens owned by `account`.
176      */
177     function balanceOf(address account) external view returns (uint256);
178 
179     /**
180      * @dev Moves `amount` tokens from the caller's account to `recipient`.
181      *
182      * Returns a boolean value indicating whether the operation succeeded.
183      *
184      * Emits a {Transfer} event.
185      */
186     function transfer(address recipient, uint256 amount) external returns (bool);
187 
188     /**
189      * @dev Returns the remaining number of tokens that `spender` will be
190      * allowed to spend on behalf of `owner` through {transferFrom}. This is
191      * zero by default.
192      *
193      * This value changes when {approve} or {transferFrom} are called.
194      */
195     function allowance(address owner, address spender) external view returns (uint256);
196 
197     /**
198      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
199      *
200      * Returns a boolean value indicating whether the operation succeeded.
201      *
202      * IMPORTANT: Beware that changing an allowance with this method brings the risk
203      * that someone may use both the old and the new allowance by unfortunate
204      * transaction ordering. One possible solution to mitigate this race
205      * condition is to first reduce the spender's allowance to 0 and set the
206      * desired value afterwards:
207      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208      *
209      * Emits an {Approval} event.
210      */
211     function approve(address spender, uint256 amount) external returns (bool);
212 
213     /**
214      * @dev Moves `amount` tokens from `sender` to `recipient` using the
215      * allowance mechanism. `amount` is then deducted from the caller's
216      * allowance.
217      *
218      * Returns a boolean value indicating whether the operation succeeded.
219      *
220      * Emits a {Transfer} event.
221      */
222     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
223 
224     /**
225      * @dev Emitted when `value` tokens are moved from one account (`from`) to
226      * another (`to`).
227      *
228      * Note that `value` may be zero.
229      */
230     event Transfer(address indexed from, address indexed to, uint256 value);
231 
232     /**
233      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
234      * a call to {approve}. `value` is the new allowance.
235      */
236     event Approval(address indexed owner, address indexed spender, uint256 value);
237 }
238 
239 /**
240  * @dev Wrappers over Solidity's arithmetic operations with added overflow
241  * checks.
242  *
243  * Arithmetic operations in Solidity wrap on overflow. This can easily result
244  * in bugs, because programmers usually assume that an overflow raises an
245  * error, which is the standard behavior in high level programming languages.
246  * `SafeMath` restores this intuition by reverting the transaction when an
247  * operation overflows.
248  *
249  * Using this library instead of the unchecked operations eliminates an entire
250  * class of bugs, so it's recommended to use it always.
251  */
252 library SafeMath {
253     /**
254      * @dev Returns the addition of two unsigned integers, reverting on
255      * overflow.
256      *
257      * Counterpart to Solidity's `+` operator.
258      *
259      * Requirements:
260      * - Addition cannot overflow.
261      */
262     function add(uint256 a, uint256 b) internal pure returns (uint256) {
263         uint256 c = a + b;
264         require(c >= a, "SafeMath: addition overflow");
265 
266         return c;
267     }
268 
269     /**
270      * @dev Returns the subtraction of two unsigned integers, reverting on
271      * overflow (when the result is negative).
272      *
273      * Counterpart to Solidity's `-` operator.
274      *
275      * Requirements:
276      * - Subtraction cannot overflow.
277      */
278     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
279         return sub(a, b, "SafeMath: subtraction overflow");
280     }
281 
282     /**
283      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
284      * overflow (when the result is negative).
285      *
286      * Counterpart to Solidity's `-` operator.
287      *
288      * Requirements:
289      * - Subtraction cannot overflow.
290      *
291      * _Available since v2.4.0._
292      */
293     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
294         require(b <= a, errorMessage);
295         uint256 c = a - b;
296 
297         return c;
298     }
299 
300     /**
301      * @dev Returns the multiplication of two unsigned integers, reverting on
302      * overflow.
303      *
304      * Counterpart to Solidity's `*` operator.
305      *
306      * Requirements:
307      * - Multiplication cannot overflow.
308      */
309     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
310         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
311         // benefit is lost if 'b' is also tested.
312         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
313         if (a == 0) {
314             return 0;
315         }
316 
317         uint256 c = a * b;
318         require(c / a == b, "SafeMath: multiplication overflow");
319 
320         return c;
321     }
322 
323     /**
324      * @dev Returns the integer division of two unsigned integers. Reverts on
325      * division by zero. The result is rounded towards zero.
326      *
327      * Counterpart to Solidity's `/` operator. Note: this function uses a
328      * `revert` opcode (which leaves remaining gas untouched) while Solidity
329      * uses an invalid opcode to revert (consuming all remaining gas).
330      *
331      * Requirements:
332      * - The divisor cannot be zero.
333      */
334     function div(uint256 a, uint256 b) internal pure returns (uint256) {
335         return div(a, b, "SafeMath: division by zero");
336     }
337 
338     /**
339      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
340      * division by zero. The result is rounded towards zero.
341      *
342      * Counterpart to Solidity's `/` operator. Note: this function uses a
343      * `revert` opcode (which leaves remaining gas untouched) while Solidity
344      * uses an invalid opcode to revert (consuming all remaining gas).
345      *
346      * Requirements:
347      * - The divisor cannot be zero.
348      *
349      * _Available since v2.4.0._
350      */
351     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
352         // Solidity only automatically asserts when dividing by 0
353         require(b > 0, errorMessage);
354         uint256 c = a / b;
355         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
356 
357         return c;
358     }
359 
360     /**
361      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
362      * Reverts when dividing by zero.
363      *
364      * Counterpart to Solidity's `%` operator. This function uses a `revert`
365      * opcode (which leaves remaining gas untouched) while Solidity uses an
366      * invalid opcode to revert (consuming all remaining gas).
367      *
368      * Requirements:
369      * - The divisor cannot be zero.
370      */
371     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
372         return mod(a, b, "SafeMath: modulo by zero");
373     }
374 
375     /**
376      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
377      * Reverts with custom message when dividing by zero.
378      *
379      * Counterpart to Solidity's `%` operator. This function uses a `revert`
380      * opcode (which leaves remaining gas untouched) while Solidity uses an
381      * invalid opcode to revert (consuming all remaining gas).
382      *
383      * Requirements:
384      * - The divisor cannot be zero.
385      *
386      * _Available since v2.4.0._
387      */
388     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
389         require(b != 0, errorMessage);
390         return a % b;
391     }
392 }
393 
394 /**
395  * @dev Implementation of the {IERC20} interface.
396  *
397  * This implementation is agnostic to the way tokens are created. This means
398  * that a supply mechanism has to be added in a derived contract using {_mint}.
399  * For a generic mechanism see {ERC20Mintable}.
400  *
401  * TIP: For a detailed writeup see our guide
402  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
403  * to implement supply mechanisms].
404  *
405  * We have followed general OpenZeppelin guidelines: functions revert instead
406  * of returning `false` on failure. This behavior is nonetheless conventional
407  * and does not conflict with the expectations of ERC20 applications.
408  *
409  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
410  * This allows applications to reconstruct the allowance for all accounts just
411  * by listening to said events. Other implementations of the EIP may not emit
412  * these events, as it isn't required by the specification.
413  *
414  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
415  * functions have been added to mitigate the well-known issues around setting
416  * allowances. See {IERC20-approve}.
417  */
418 contract ERC20 is Context, IERC20 {
419     using SafeMath for uint256;
420 
421     mapping (address => uint256) private _balances;
422 
423     mapping (address => mapping (address => uint256)) private _allowances;
424 
425     uint256 private _totalSupply;
426 
427     /**
428      * @dev See {IERC20-totalSupply}.
429      */
430     function totalSupply() public view returns (uint256) {
431         return _totalSupply;
432     }
433 
434     /**
435      * @dev See {IERC20-balanceOf}.
436      */
437     function balanceOf(address account) public view returns (uint256) {
438         return _balances[account];
439     }
440 
441     /**
442      * @dev See {IERC20-transfer}.
443      *
444      * Requirements:
445      *
446      * - `recipient` cannot be the zero address.
447      * - the caller must have a balance of at least `amount`.
448      */
449     function transfer(address recipient, uint256 amount) public returns (bool) {
450         _transfer(_msgSender(), recipient, amount);
451         return true;
452     }
453 
454     /**
455      * @dev See {IERC20-allowance}.
456      */
457     function allowance(address owner, address spender) public view returns (uint256) {
458         return _allowances[owner][spender];
459     }
460 
461     /**
462      * @dev See {IERC20-approve}.
463      *
464      * Requirements:
465      *
466      * - `spender` cannot be the zero address.
467      */
468     function approve(address spender, uint256 amount) public returns (bool) {
469         _approve(_msgSender(), spender, amount);
470         return true;
471     }
472 
473     /**
474      * @dev See {IERC20-transferFrom}.
475      *
476      * Emits an {Approval} event indicating the updated allowance. This is not
477      * required by the EIP. See the note at the beginning of {ERC20};
478      *
479      * Requirements:
480      * - `sender` and `recipient` cannot be the zero address.
481      * - `sender` must have a balance of at least `amount`.
482      * - the caller must have allowance for `sender`'s tokens of at least
483      * `amount`.
484      */
485     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
486         _transfer(sender, recipient, amount);
487         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
488         return true;
489     }
490 
491     /**
492      * @dev Atomically increases the allowance granted to `spender` by the caller.
493      *
494      * This is an alternative to {approve} that can be used as a mitigation for
495      * problems described in {IERC20-approve}.
496      *
497      * Emits an {Approval} event indicating the updated allowance.
498      *
499      * Requirements:
500      *
501      * - `spender` cannot be the zero address.
502      */
503     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
504         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
505         return true;
506     }
507 
508     /**
509      * @dev Atomically decreases the allowance granted to `spender` by the caller.
510      *
511      * This is an alternative to {approve} that can be used as a mitigation for
512      * problems described in {IERC20-approve}.
513      *
514      * Emits an {Approval} event indicating the updated allowance.
515      *
516      * Requirements:
517      *
518      * - `spender` cannot be the zero address.
519      * - `spender` must have allowance for the caller of at least
520      * `subtractedValue`.
521      */
522     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
523         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
524         return true;
525     }
526 
527     /**
528      * @dev Moves tokens `amount` from `sender` to `recipient`.
529      *
530      * This is internal function is equivalent to {transfer}, and can be used to
531      * e.g. implement automatic token fees, slashing mechanisms, etc.
532      *
533      * Emits a {Transfer} event.
534      *
535      * Requirements:
536      *
537      * - `sender` cannot be the zero address.
538      * - `recipient` cannot be the zero address.
539      * - `sender` must have a balance of at least `amount`.
540      */
541     function _transfer(address sender, address recipient, uint256 amount) internal {
542         require(sender != address(0), "ERC20: transfer from the zero address");
543         require(recipient != address(0), "ERC20: transfer to the zero address");
544 
545         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
546         _balances[recipient] = _balances[recipient].add(amount);
547         emit Transfer(sender, recipient, amount);
548     }
549 
550     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
551      * the total supply.
552      *
553      * Emits a {Transfer} event with `from` set to the zero address.
554      *
555      * Requirements
556      *
557      * - `to` cannot be the zero address.
558      */
559     function _mint(address account, uint256 amount) internal {
560         require(account != address(0), "ERC20: mint to the zero address");
561 
562         _totalSupply = _totalSupply.add(amount);
563         _balances[account] = _balances[account].add(amount);
564         emit Transfer(address(0), account, amount);
565     }
566 
567     /**
568      * @dev Destroys `amount` tokens from `account`, reducing the
569      * total supply.
570      *
571      * Emits a {Transfer} event with `to` set to the zero address.
572      *
573      * Requirements
574      *
575      * - `account` cannot be the zero address.
576      * - `account` must have at least `amount` tokens.
577      */
578     function _burn(address account, uint256 amount) internal {
579         require(account != address(0), "ERC20: burn from the zero address");
580 
581         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
582         _totalSupply = _totalSupply.sub(amount);
583         emit Transfer(account, address(0), amount);
584     }
585 
586     /**
587      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
588      *
589      * This is internal function is equivalent to `approve`, and can be used to
590      * e.g. set automatic allowances for certain subsystems, etc.
591      *
592      * Emits an {Approval} event.
593      *
594      * Requirements:
595      *
596      * - `owner` cannot be the zero address.
597      * - `spender` cannot be the zero address.
598      */
599     function _approve(address owner, address spender, uint256 amount) internal {
600         require(owner != address(0), "ERC20: approve from the zero address");
601         require(spender != address(0), "ERC20: approve to the zero address");
602 
603         _allowances[owner][spender] = amount;
604         emit Approval(owner, spender, amount);
605     }
606 
607     /**
608      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
609      * from the caller's allowance.
610      *
611      * See {_burn} and {_approve}.
612      */
613     function _burnFrom(address account, uint256 amount) internal {
614         _burn(account, amount);
615         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
616     }
617 }
618 
619 /**
620  * @title Pausable token
621  * @dev ERC20 with pausable transfers and allowances.
622  *
623  * Useful if you want to stop trades until the end of a crowdsale, or have
624  * an emergency switch for freezing all token transfers in the event of a large
625  * bug.
626  */
627 contract ERC20Pausable is Ownable, Pausable, ERC20 {
628     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
629         return super.transfer(to, value);
630     }
631 
632     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
633         return super.transferFrom(from, to, value);
634     }
635 
636     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
637         return super.approve(spender, value);
638     }
639 
640     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
641         return super.increaseAllowance(spender, addedValue);
642     }
643 
644     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
645         return super.decreaseAllowance(spender, subtractedValue);
646     }
647 }
648 
649 contract RariToken is ERC20Pausable {
650     string constant public name = "Rarible";
651     string constant public symbol = "RARI";
652     uint8 constant public decimals = 18;
653 
654     bool public mintStopped = false;
655 
656     constructor() public {
657     }
658 
659     function mint(address account, uint256 amount) public onlyOwner returns (bool) {
660         require(!mintStopped, "mint is stopped");
661         _mint(account, amount);
662         return true;
663     }
664 
665     function stopMint() public onlyOwner {
666         mintStopped = true;
667     }
668 }